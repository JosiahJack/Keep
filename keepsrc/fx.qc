//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by W. Josiah Jack, aka Qmaster
//
// Attributions: All and some of my own.
//
//
// Distribution / Copyright / Permissions 
//
// Please do not use any of these assets in ANY COMMERCIAL PROJECT.
// and remember to give credit if you use any of these assets. Please credit
// the appropriate authors of the various content used.  Refer to the credits
// folder.
//				  
// The QC files in this MOD are based on 1.06 source files by ID Software.
// These files are released under the terms of GNU General Public License v2 or
// later. You may use the source files as a base to build your own MODs as long
// as you release them under the same license and make the source available.
// Please also give proper credit. Check http://www.gnu.org for details.
//
// Quake is a registered trademark of id Software, Inc.
//
// All of these resources may be electronically distributed only at 
// NO CHARGE to the recipient.
//
// Stats:
// Entity count: 10
// Function count: 104
//
// Implements: Special Effects
//
// Description:
// Various visual effects such as explosions, blood, etc.
//=============================================================================

float BEAM_TEMPORARY = 0;
float BEAM_NORMAL = 1;
float BEAM_STATIC = 2;

void Touch_Missile();
float HasReflection(entity ent, vector spot, float damage);
float(float damage) Reflected_Damage;
float() Reflected;
void(float fx, entity src, vector p1, vector p2) Tent_Beam;
float(entity source, entity targ) ai_immunebreakable;
void(entity targ, vector org, vector vel, float damage, float type, string hitsound, string burstsound) Resist_Effects;
void() misc_dripremovable_think;
void() misc_drip_removetouch;
void trigger_particles();
void stop_smoke();
void() BecomeExplosion;

void(vector org, float velrnd, float upbase, float uprnd) SpawnProjectileSmoke = { // [FUNCTION]
	newmis = spawn();
	newmis.classtype = CT_TEMPPHYS;
	newmis.classgroup = CG_TEMPENT;
	newmis.movetype = MOVETYPE_TOSS;
	newmis.solid = SOLID_NOT;
	setmodel(newmis, MODEL_PROJ_SMOKE);
	setorigin(newmis, org);
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);
	if (velrnd > 0) newmis.velocity = vecrand(0,velrnd,TRUE);
	else newmis.velocity = '0 0 0';
	newmis.velocity_z = upbase + random()*uprnd;
	newmis.nextthink = time + 1 + random()*3;
	newmis.think = SUB_Remove;
};

void(vector org, vector veldir, float velbase, float velrnd) SpawnVelocitySmoke = { // [FUNCTION]
	newmis = spawn();
	newmis.classtype = CT_TEMPPHYS;
	newmis.classgroup = CG_TEMPENT;
	newmis.movetype = MOVETYPE_TOSS;
	newmis.solid = SOLID_NOT;
	setmodel(newmis, MODEL_PROJ_SMOKE);
	setorigin(newmis, org);
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);
	newmis.velocity = veldir * (velbase + (random()*velrnd));
	newmis.nextthink = time + 1 + random()*3;
	newmis.think = SUB_Remove;
};

void(entity source, entity targ) ProjectileType = { // [FUNCTION]
	if (source.poisonous) {
		setmodel(targ, MODEL_PROJ_FLESHP);
		targ.gibtype = GIBTYPE_POISON;
	} else if (source.classgroup == CG_ROBOT || source.classgroup == CG_STONE) {
		setmodel(targ, MODEL_PROJ_SMOKE);
		targ.gibtype = GIBTYPE_STONE;
	} else {
		setmodel(targ, MODEL_PROJ_FLESH);
		targ.gibtype = GIBTYPE_BLOOD;
	}
	if (ext_dppart) DPP_blood_trail(targ); // Finally add DP particle trails
};

// Mainly used to show resistance to an ammo type.  Also used by boils for their idle gibs
void(entity source, vector org, float velrnd, float upbase, float uprnd) SpawnProjectileMeat = { // [FUNCTION]
	newmis = spawn();
	newmis.classtype = CT_TEMPGIB;
	newmis.classgroup = CG_TEMPENT;
	newmis.movetype = MOVETYPE_BOUNCE;
	newmis.solid = SOLID_NOT;
	ProjectileType(source, newmis); // Projectile types (Poison/Robot/Stone/Blood)
	setorigin(newmis, org);
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);		
	newmis.velocity = vecrand(0,velrnd,TRUE);
	newmis.velocity_z = upbase, random()*uprnd;
	newmis.avelocity = vecrand(100,velrnd,FALSE);
	newmis.nextthink = time + 1 + random()*3;
	newmis.think = SUB_Remove;
};

// SpawnBlood
void(entity targ, vector org, vector vel, float part_qty, float overridecol) SpawnBlood = { // [FUNCTION]
	local float loop_count, part_col;

	if (!targ) return;

	if (targ.bleedcolour <= 0 && targ.bloodtype <= 0) targ.bleedcolour = MON_BCOLOR_RED;
	else if (targ.bleedcolour != targ.bloodtype && targ.bleedcolour <= 0 && targ.bloodtype > 0) targ.bleedcolour = targ.bloodtype; // fix it just in case
	else if (targ.bleedcolour != targ.bloodtype && !targ.bloodtype && targ.bleedcolour) targ.bloodtype = targ.bleedcolour;

	loop_count = 0;
	vel = vel * 0.1;
	if (targ.classgroup == CG_BREAKABLE) {
		part_col = targ.bloodtype; // Breakables don't always bleed red blood - user specified.
	} else {
		if (targ.poisonous) part_col = MON_BCOLOR_GREEN;
		else if (targ.classgroup == CG_ROBOT) part_col = MON_BCOLOR_YELLOW;
		else if (targ.bleedcolour > 0) part_col = targ.bleedcolour; // Can be used to override the func object bleeding blood problem.
		else part_col = MON_BCOLOR_RED;
	}

	if (self.flags & FL_CLIENT && self.weapon == IT_LIGHTNING && !self.selfweaponismoditems) part_col = 225; // Lightning uses 225 blood colour
	
	if (overridecol > 0 && overridecol < 255) part_col = overridecol;

	// Loop through particle count creating bursts of particles
	while(loop_count < 4) {
		if (loop_count == 2 && targ.bloodtype > 0) part_col = targ.bloodtype;
		if (targ.frozen) {
			particle(org,vel,41,part_qty);
			particle(org,vel, 9,part_qty);
		} else particle(org,vel,part_col,part_qty);
		loop_count = loop_count + 1;
	}
};

// Triggered by Touch_Bullet, Touch_Projectile.
void(entity source, entity targ, float damage) spawn_touchblood = { // [FUNCTION]
	local vector org, vel;

	if (!source || !targ) return;

	makevectors(source.angles);
	vel = normalize (source.velocity);
	vel = normalize(vel + v_up*(random()- 0.5) + v_right*(random()- 0.5));
	vel = vel + 2*trace_plane_normal;
	vel = vel * 0.4; // Originally vel = ((vel * 200) * 0.2) * 0.01
	if (CheckZeroVector(source.meleeoffset)) org = '0 0 0'; // Check for an origin blood offset (monsters)
	else org = attack_vector(source.meleeoffset);
	
	SpawnBlood(targ,source.origin + org, vel, damage,0);
};

// Spawns a particle trail for an invisible blood model.
// Useful for any monster with blood of unusual color (like black or blue).
// It could be motor oil, antifreeze, milk, or fruit juice for all we know.
void() MeatSprayThink = { // [FUNCTION]
    local   vector  dir;

    if (self.delay <= time) { remove(self); return;}

    dir = normalize (self.velocity);
    particle (self.origin, dir, self.bloodtype, 10);
    self.nextthink = time + 0.100;
};

// SpawnMeatSpray
// Changed to remove dependance on 'self' for missile origin
// Changed parameters to add source and destination of attack
// Changed velocity to side so it is calculated correctly from angles
void(entity source, entity targ, float side) SpawnMeatSpray = { // [FUNCTION]
	local float btype;
	local vector org;
    local string text;

	text = "";
	btype = targ.bloodtype;
	if (targ.bloodtype <= 0) btype = BLOOD_RED;
    if (btype == BLOOD_RED) text = "progs/q15/zom_gib.mdl";
    if (btype == BLOOD_GREEN) text = "progs/drake/gr_gib.mdl";
    if (btype == BLOOD_PURPLE) text = "progs/drake/pur_gib.mdl";
    if (btype == BLOOD_FIRE) text = "progs/drake/ember.mdl";
	makevectors(source.angles);
	if (CheckZeroVector(source.meleeoffset)) org = v_forward * 16; // Check for a melee offset? - Special vector offset
	else org = attack_vector(source.meleeoffset);
	org = org + source.origin; // Create starting point to spawn

	if (targ.bloodtype) {
		SpawnBlood(targ, org, v_up*2, 100,0);
	} else {
		newmis = spawn();
		newmis.classtype = CT_TEMPGIB;
		newmis.classgroup = CG_TEMPENT;
		newmis.owner = source;
		newmis.movetype = MOVETYPE_BOUNCE;
		newmis.solid = SOLID_NOT;
		ProjectileType(targ, newmis);
		setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);		
		setorigin(newmis, org);
		newmis.velocity = ((crandom()*16) * v_forward) + (side * v_right); // Use side velocity to determine which direction to throw
		newmis.velocity_z = newmis.velocity_z + 150 + 50*random();
		newmis.avelocity = vecrand(100,200,FALSE);
		if (btype) {
			newmis.velocity_z = newmis.velocity_z + 100; // Drake used 250 instead of 150
			newmis.avelocity   = '3000 1000 2000';
		}

		if (text != "")
			setmodel(newmis, text); // Oh hey we actually have substance!
		else
			newmis.modelindex  = 0; // Invisible blood dripper

		newmis.bloodtype   = btype;
		newmis.delay       = time + 1 + random()*3;
		newmis.nextthink   = 0.01;
		newmis.think       = MeatSprayThink; // All spray should do this for specialty blood colors
	}
};

// Drake Temporary Entities.  PM: These are common within the qc progs.
void(float fx, vector spot) Tent_Point = { // [FUNCTION]
    WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
    WriteByte (MSG_BROADCAST, fx);
    WriteCoord (MSG_BROADCAST, spot_x);
    WriteCoord (MSG_BROADCAST, spot_y);
    WriteCoord (MSG_BROADCAST, spot_z);
};

void(vector start, float zoffset, string snd) Tent_LavaSplash = {
	local vector org;

	org = start;
	org_z = org_z + zoffset;
	Tent_Point(TE_LAVASPLASH,org);
	if (snd != "") sound(self,CHAN_AUTO,snd,1,ATTN_NONE);
};

// Explode self into ice chunks.
void() Shattered = { // [FUNCTION]
    sound(self,CHAN_VOICE,"drake/weapons/shatter.wav",1,ATTN_NORM);
    MakeIcyExp (self.origin); 
	self.gibbed = TRUE;
	self.think = SUB_Null;
	self.gibpartstyle = PARTICLE_BURST_BLUE;
	self.gibtype = GIBTYPE_ICE;
	particle(self.origin, crandom() * 100 * '1 1 1', 41 + rint(random()*7), 20);
	particle(self.origin, crandom() * 100 * '1 1 1', 9 + rint(random()*7), 20);
	particle(self.origin, crandom() * 100 * '1 1 1', 41 + rint(random()*7), 20);
	particle(self.origin, crandom() * 100 * '1 1 1', 9 + rint(random()*7), 20);
	ThrowGib(GIBTYPE_ICE,rint(random() * (self.max_health / 10)));
	remove(self);
};

// 'waitmin' = slow color, 'waitmax' = fast color.
void(entity shot, float rgb) Laser_Color = { // [FUNCTION]
    shot.skin = rgb;
    if (rgb == 3) { shot.waitmin = 9;  shot.waitmax = 41;} // Blue
    else if (rgb == 2) { shot.waitmin = 105;  shot.waitmax = 193;} // Yellow
    else if (rgb == 1) { shot.waitmin = 73;  shot.waitmax = 225;} // Red
    else { shot.skin = 0;  shot.waitmin = 97;  shot.waitmax = 233;} // Orange.  Replaced 225 with 97 to stop blood in some ports.
};

// PM:  Moved circle drawing code from Zerstorer's misc.qc to here.
void(vector Center, float Radius, float CColor) DrawCircleXY = { // [FUNCTION]
	local float MajorAxis, MinorAxis, RadSqminusMajAxis, MinAxisSqThreshold;
	local vector circlepos, vel;

    MajorAxis = 0;
    MinorAxis = Radius;
    circlepos_z = Center_z;
    vel = '0 0 1';
    RadSqminusMajAxis = Radius * Radius;
    MinAxisSqThreshold = MinorAxis * MinorAxis - MinorAxis;
    do {
        circlepos_x = Center_x+MajorAxis; circlepos_y = Center_y-MinorAxis;
        particle(circlepos, vel, CColor, 15);
        circlepos_x = Center_x-MajorAxis;
        particle(circlepos, vel, CColor, 15);
        circlepos_x = Center_x+MajorAxis; circlepos_y = Center_y+MinorAxis;
        particle(circlepos, vel, CColor, 15);
        circlepos_x = Center_x-MajorAxis;
        particle(circlepos, vel, CColor, 15);
        circlepos_x = Center_x+MinorAxis; circlepos_y = Center_y-MajorAxis;
        particle(circlepos, vel, CColor, 15);
        circlepos_x = Center_x-MinorAxis;
        particle(circlepos, vel, CColor, 15);
        circlepos_x = Center_x+MinorAxis; circlepos_y = Center_y+MajorAxis;
        particle(circlepos, vel, CColor, 15);
        circlepos_x = Center_x-MinorAxis;
        particle(circlepos, vel, CColor, 15);
        MajorAxis = MajorAxis + 20;
        RadSqminusMajAxis = RadSqminusMajAxis - (MajorAxis + MajorAxis - 20);
        if (RadSqminusMajAxis <= MinAxisSqThreshold) {
            MinorAxis = MinorAxis - 20;
            MinAxisSqThreshold = MinAxisSqThreshold - (MinorAxis + MinorAxis);
        }
    } while (MajorAxis <= MinorAxis);
};

//  Wind Wall.  Spawns a dust cloud upward.  Used by Storm Baron's gust attack.
void(entity ent) Particle_Gust = { // [FUNCTION]
    local vector spot;
    local float loop;

    loop = 9;
    while (loop > 0) {
        loop = loop - 1;
        spot_x = random() * 2 - 0.5;
        spot_y = random() * 2 - 0.5;
        spot_z = loop / 8;
        spot = Anypoint(ent,spot);
        particle(spot,'0 0 8',1,5);
    }
};

float SPRITE_PLAYONCE = 4;
float SPRITE_RANDOMWAIT = 8;
float S_ACTIVE = 1;
float S_DEACTIVE = 0;
float S_ALPHANULL = 0.001;

void() env_sprite_loop = { // [FUNCTION]
	if (self.spritestarted == FALSE) {
		self.frame = self.pos1_x;
		self.spritestarted = TRUE;
		self.alpha = self.pos1_y;
	} else {
		self.frame = self.frame + 1;
	}

	if (self.frame > (self.idleweaponframe)) {
		self.frame = self.pos1_x;
		if (self.spawnflags & SPRITE_PLAYONCE) { self.use(); return; }
		
		if (self.spawnflags & SPRITE_RANDOMWAIT && self.wait > 0) {
			self.alpha = S_ALPHANULL;
			self.think = env_sprite_loop;
			self.nextthink = time + self.waitmin + random()*self.wait;
			self.spritestarted = TRUE;
			return;
		}
	}

	self.think = env_sprite_loop;
	self.nextthink = time + self.impulse;
};

// Added by Qmaster
void() env_sprite_hide = { // [FUNCTION]
	self.alpha = 0.001;
	self.spritestarted = FALSE;
	self.frame = self.pos1_x;	//reset
	self.effects = 0;
	self.solid = SOLID_NOT;
	self.takedamage = DAMAGE_NO;
	self.movetype = MOVETYPE_NONE;
	self.velocity = VEC_ORIGIN;
	self.angles = VEC_ORIGIN;
	self.use = self.think1;
	self.think = SUB_Null;
	self.nextthink = time + 0.1;
};

void() env_sprite_on = { // [FUNCTION]
	self.state = S_ACTIVE;
	self.alpha = self.pos1_y;
	self.think = env_sprite_loop;
	self.nextthink = time + self.impulse;
};

void() env_sprite_off = { // [FUNCTION]
		self.alpha = S_ALPHANULL;
		self.spritestarted = FALSE;
		self.state = S_DEACTIVE;
};

void() env_sprite_use = { // [FUNCTION]
	if (self.state == S_ACTIVE) {
		env_sprite_off();
	} else {
		env_sprite_on();
	}
};

void() env_sprite_reset = { // [FUNCTION]
	self.frame = self.pos1_x;
};

void() env_sprite = { // [ENTITY]
	if (self.mdl == "") { dprint("ERROR: no model for env_sprite\n"); return; }

	precache_model(self.mdl);
	setmodel(self,self.mdl);
	if (self.alpha <= 0) self.alpha = 1;
	self.pos1_x = self.frame;
	self.pos1_y = self.alpha;
	self.use = env_sprite_use;
	self.estate_on = env_sprite_on;
	self.estate_off = env_sprite_off;
	self.estate_disable = env_sprite_hide;
	self.estate_reset = env_sprite_reset;
	self.estate = ESTATE_ON;
	if (self.spawnflags & 64) self.estate_off();
	self.think = SUB_Null;
	if (self.idleweaponframe > 0) self.think = env_sprite_loop;
	if (self.impulse <= 0) self.impulse = 0.05; // default delay between frames
	self.nextthink = time + self.delay;
};

void() info_sprite_static = { // [ENTITY]
	self.classname = "env_sprite";
	self.mdl = self.model;
	env_sprite();
};

void() raincloud_raindrip = { // [FUNCTION]
	local entity drip;

	// dprint("Spawning a raindrop from a cloud");
	drip = spawn();
	drip.owner = self;
	if (self.owner) drip.charmer = self.owner;
	drip.owner = self;
	drip.classname = "misc_drip";
	drip.classtype = CT_MISCDRIP;
	drip.classgroup = CG_TEMPENT;
	drip.movetype = MOVETYPE_FLY;
	drip.solid = SOLID_TRIGGER;
	drip.headmdl = self.headmdl;
	drip.frame = 0;
	setmodel(drip, self.path);
	setsize (drip, VEC_ORIGIN, VEC_ORIGIN);
	drip.origin_x = self.origin_x + crandom()*self.t_width;
	drip.origin_y = self.origin_y + crandom()*self.t_length;
	drip.origin_z = self.origin_z;
	setorigin(drip, drip.origin);
	//drip.velocity = vecrand(0,5,TRUE);
	drip.velocity_z = -map_gravity;

	drip.nextthink = time + 0.5 + random()*0.5;
	drip.think = misc_dripremovable_think;
	drip.touch = misc_drip_removetouch;
};

void() raincloud_think = { // [FUNCTION]
	if (!(self.spawnflags & 4)) {
		// Moves about randomly at the same height
		if (self.attack_finished < time) {
			self.attack_finished = time + self.search_time;
			self.velocity_x = 8 + (crandom() * 100);
			self.velocity_y = 8 + (crandom() * 100);
			self.velocity_z = 0;
		}
	} else {
		// Static
		self.velocity = 0;
		self.movetype = MOVETYPE_NONE;
	}

	if (self.spritestarted == FALSE) {
		self.frame = 0;
		self.spritestarted = TRUE;
	} else {
		self.frame = self.frame + 1;

		if (self.bubble_count < self.count) {
			self.bubble_count = self.bubble_count + 1;
			raincloud_raindrip();
		}

		// Dying
		if (self.spritestarted == 2) {
			if (self.frame >= 201) {
				self.frame = 0;
				self.alpha = 0.001;
				if (self.owner) {
					self.owner.minion_maxcount = self.owner.minion_maxcount - 1;
					if (self.owner.minion_maxcount < 0) self.owner.minion_maxcount = 0; // just in case
				}
				remove(self);
				return;
			}
		}

		if (self.frame > 177 && self.spritestarted != 2) self.frame = 77;
	}

	// Time to die out
	if (self.flight_finished < time && !(self.cnt == -1)) {
		self.spritestarted = 2; // dying state
	}

	self.think = raincloud_think;
	self.nextthink = time + self.impulse;
};

void() raincloud_use = { // [FUNCTION]
	self.think = raincloud_think;
	self.nextthink = time + self.delay;
};

// Spawns a storm cloud that moves about randomly at the same height.
void() spawn_raincloud = { // [FUNCTION]
	self.mdl = "progs/qmaster/astorm.spr";
	if (self.alpha <= 0) self.alpha = 1;
	setmodel(self, self.mdl);
    setsize (self, '0 0 0', '0 0 0');
	self.movetype = MOVETYPE_FLYMISSILE;
	self.solid = SOLID_BBOX;
	setorigin(self, self.origin);
	self.attack_finished = 0;
	self.classname = "misc_raincloud";
	if (!self.count) self.count = 10;
	if (!self.cnt) self.cnt = 20; // give a default lifetime
	if (self.impulse <= 0) self.impulse = 0.05; // default delay between frames
	if (!self.search_time) self.search_time = 2 + (random() * 3); // Time to drift before changing direction
	self.bubble_count = 0;
	self.flight_finished = time + self.cnt;
	if (self.targetname != "") { self.use = raincloud_use; return; }
	
	self.t_width = 40;
	self.t_length = 40;
	self.think = raincloud_think;
	self.nextthink = time + self.delay;
};

void() misc_raincloud = { // [ENTITY]
	// Pick type of drip sprite based on spawnflags
	if (self.spawnflags & 16) {
		if (self.spawnflags & 8) {
			if (self.path == "") self.path = "progs/s_dripred_lg.spr";
		} else {
			if (self.path == "") self.path = SBLOOD_DRIP;
		}

		if (self.headmdl == "") self.headmdl = SBLOOD_SPLASH;
		if (self.aflag <= 0) self.aflag = 64;
	} else if (self.spawnflags & 32) {
		if (self.spawnflags & 8) {
			if (self.path == "") self.path = "progs/s_dripgreen_lg.spr";
		} else {
			if (self.path == "") self.path = SSLIME_DRIP;
		}

		if (self.headmdl == "") self.headmdl = SSLIME_SPLASH;
		if (self.aflag <= 0) self.aflag = 48;
	} else {
		if (self.spawnflags & 8) {
			if (self.path == "") self.path = "progs/s_dripblue_lg.spr";
		} else {
			if (self.path == "") self.path = SWATER_DRIP;
		}

		if (self.headmdl == "") self.headmdl = SWATER_SPLASH;
		if (self.aflag <= 0) self.aflag = 0;
	}
	precache_model (self.path);
	precache_model (self.headmdl);
	if (!self.noise1) self.noise1 = "rrp/misc/drip1.wav";
	if (!self.noise2) self.noise2 = "rrp/misc/drip2.wav";
	if (!self.noise3) self.noise3 = "rrp/misc/drip3.wav";
	precache_sound(self.noise1);
	precache_sound(self.noise2);
	precache_sound(self.noise3);
	precache_model("progs/qmaster/astorm.spr");
	if (!self.delay && (self.targetname == "")) self.delay = (random() * 5); // random spawn time to not all storm the same
	spawn_raincloud();
};

void() skyl_stand1	= [  0,	skyl_stand2  ] { self.effects = EF_BRIGHTLIGHT;}; // [FUNCTION]
void() skyl_stand2	= [  1,	skyl_stand3  ] {}; // [FUNCTION]
void() skyl_stand3	= [  2,	skyl_stand4  ] { self.effects = 0;}; // [FUNCTION]
void() skyl_stand4	= [  3,	skyl_stand5  ] { self.effects = EF_BRIGHTLIGHT;}; // [FUNCTION]
void() skyl_stand5	= [  4,	skyl_stand6  ] {}; // [FUNCTION]
void() skyl_stand6	= [  5,	skyl_stand7  ] {}; // [FUNCTION]
void() skyl_stand7	= [  6,	skyl_stand8  ] { if (!(self.spawnflags & 2)) { sound(world, CHAN_AUTO, "drake/bane/thunder.wav", 1, ATTN_NONE); } }; // [FUNCTION]
void() skyl_stand8	= [  7,	skyl_stand1  ] { self.effects = 0; self.nextthink = time + self.wait + (random() * self.waitmax); }; //time  lightning appears time + your time, [FUNCTION]

void() model_skylight = { // [ENTITY]
	precache_model ("progs/madfox/skylight.spr");
	self.solid = SOLID_BBOX;                               
	self.movetype = MOVETYPE_NONE;
	self.classname = "env_lightning";
	setmodel(self, "progs/madfox/skylight.spr");
	precache_sound("drake/bane/thunder.wav");
	setsize (self, '16 16 16', '24 24 24');
	if (!self.wait) self.wait = 10;
	self.think = skyl_stand1;
	self.nextthink = time + 0.01;
};

void() env_lightning = { model_skylight(); }; // [ENTITY]

void particles_reset() = { // [FUNCTION]
  self.use = trigger_particles;
  self.think = SUB_Null;
  self.nextthink = time + LARGE_TIMER;
};

void emit_particles() = { // [FUNCTION]
  local vector spot1;

  if (self.endtime > 0) {
    self.count = self.count + self.delay;
    if (self.count > self.endtime) {
      particles_reset();
      return;
      }
    }
  if (self.method < 1) {
    particle(self.origin, self.movedir, self.cnt, self.duration);
    }
  else {
    makevectors(self.aether);
    self.aether_y = self.aether_y + self.speed;
    if (self.aether_y > 360) {
      self.aether_y = self.aether_y - 360;
      }
    if (self.aether_y < 0) {
      self.aether_y = self.aether_y + 360;
      }
    spot1 = self.origin + v_forward * self.impulse;
    particle(spot1, self.movedir, self.cnt, self.duration);
    if (self.method == 2) {
      spot1 = self.origin + v_forward * (0 - self.impulse);
      particle(spot1, self.movedir, self.cnt, self.duration);
      }
    }
  self.think = emit_particles;
  self.nextthink = time + self.delay;
};

void trigger_particles() = { // [ENTITY]
  self.count = 0;
  self.use = particles_reset;
  self.think = emit_particles;
  self.nextthink = time + self.delay;
}

void info_particles() = { // [ENTITY]
	if (self.speed <= 0) self.speed = 1;
	if (self.delay <= 0) self.delay = 0.1;

	if (self.targetname) {
		if (self.spawnflags & 64) {
			self.use = particles_reset;
			self.think = emit_particles;
			self.nextthink = time + self.wait;
			return;
		}
		self.use = trigger_particles;
		return;
	}
	trigger_particles();
};

void spawn_smokethang() = { // [FUNCTION]
  local entity head;

  head = spawn();
  head.alpha = -1;
  head.solid = SOLID_TRIGGER;
  head.movetype = MOVETYPE_NOCLIP;
  head.velocity = '0 0 1000';
  head.velocity_z = self.speed + random() * 200;
  setmodel(head, "progs/null.mdl");
  setsize(head, VEC_ORIGIN, VEC_ORIGIN);
  setorigin(head, self.origin);
  head.effects = head.effects & EF_NODRAW;
  head.nextthink = time + self.wait;
  head.think = SUB_Remove;
  if (self.cnt == -1) {
    self.nextthink = time + random();
  } else {
    self.nextthink = time + self.cnt;
  }
  self.think = spawn_smokethang;
};

void trigger_smoke() = { // [ENTITY]
	self.use = stop_smoke;
	self.nextthink = time + random();
	self.think = spawn_smokethang;
};

void stop_smoke() = { // [FUNCTION]
	self.nextthink = time + 99999;
	self.think = SUB_Null;
	self.use = trigger_smoke;
};

// Launches invisible touchless grenades that have grenade particle trails
void misc_smokemaker() = { // [ENTITY]
	precache_model("progs/null.mdl");
	if (!(self.speed)) self.speed = 2000;
	if (self.cnt == 0) self.cnt = 0.2;
	if (self.wait == 0) self.wait = 0.5;
	if (self.targetname) { self.use = trigger_smoke; return; }

	self.nextthink = time + random();
	self.think = spawn_smokethang;
};

void big_bang() = { // [FUNCTION]
	local vector newo;
	local float x, y, z;

	if (self.wait == 1) sound(self, CHAN_VOICE, "boss2/pop2.wav", 1, ATTN_NONE);
	x = random() * 128 - 64;
	y = random() * 128 - 64;
	z = random() * 128 - 64;
	newo_x = self.origin_x + x;
	newo_y = self.origin_y + y;
	newo_z = self.origin_z + z;
	Tent_Explosion(newo);
	self.wait = self.wait - 1;
	if (self.wait < 0) { entity_hide(self); return; }

	self.nextthink = time + 0.2 * random() + 0.1;
	self.think = big_bang;
};

void misc_boom() = { // [ENTITY]
	precache_sound("boss2/pop2.wav");
	self.use = big_bang;
	self.wait = 1;
};

void() nehahra_deathbeams = { // [FUNCTION]
	local entity mark;
	local vector vec;

	sound(self, CHAN_AUTO, "nehahra/sets/set2_4.wav", 1, ATTN_NONE);
	mark = spawn();
	mark.solid = SOLID_NOT;
	mark.fullbright = 1;
	mark.alpha = 0.1;
	mark.movetype = MOVETYPE_NONE;
	mark.event = "nehahra_jetdeath";
	vec = self.origin;
	if (random() < 0.4) {
		vec_x = vec_x + random() * 20;
	} else {
		vec_x = vec_x - random() * 20;
	}
	if (random() < 0.4) {
		vec_y = vec_y - random() * 20;
	} else {
		vec_y = vec_y + random() * 20;
	}
	if (random() < 0.4) {
		vec_z = vec_z + 100 - random() * 20;
	} else {
		vec_z = vec_z + 100 + random() * 20;
	}
	setorigin(mark, vec);
	setsize(mark, VEC_ORIGIN, VEC_ORIGIN);
	setmodel(mark, "progs/nehahra/nehjet.mdl");
	mark.angles_x = 360 * random();
	mark.angles_y = 360 * random();
	mark.angles_z = 360 * random();
	mark.effects = mark.effects | EF_DIMLIGHT;
	mark.think = SUB_Remove;
	mark.nextthink = time + 0.1;
};

void() nehjet = { // [FUNCTION]
	nehahra_deathbeams();
	nehahra_deathbeams();
	nehahra_deathbeams();
};

void() throwgibs = { // [FUNCTION]
	if (pointcontents(self.origin) == CONTENT_SKY) { remove(self); return; }

	sound(self, CHAN_AUTO, "player/udeath.wav", 1, ATTN_NONE);
	ThrowGib(1, 1);
	ThrowGib(2, 2);
	ThrowGib(3, 1);
};

void(string gibname, float dm) ThrowGibstorm = { // [FUNCTION]
	local entity new;
	new = spawn();
	new.origin = self.origin;
	setmodel(new, gibname);
	setsize(self, VEC_HULL_MIN, '16 16 40');
	new.velocity = VelocityForDamage(dm);
	new.movetype = MOVETYPE_BOUNCE;
	new.solid = SOLID_NOT;
	new.health = -120;
	new.avelocity_x = random() * 600;
	new.avelocity_y = random() * 600;
	new.avelocity_z = random() * 600;
	new.touch = throwgibs;
	new.think = throwgibs;
	new.nextthink = time + 1 + random() + random();
};

void() shambler_walking_quake = { // [FUNCTION]
	local entity enFind;
	
	enFind = findradius(self.origin, 444);		
	while(enFind) { 
		if (enFind.flags & FL_ONGROUND) { 
			if (enFind.flags & FL_CLIENT) {
				if (cvar("sv_gravity") > 600 && enFind.gravity) {
					enFind.velocity_x = enFind.velocity_x + (crandom() * 30);  
					enFind.velocity_y = enFind.velocity_y + (crandom() * 30); 
					enFind.velocity_z = enFind.velocity_z + (crandom() * 75); 
				} 
			   	enFind.punchangle = enFind.punchangle + (mathlib_randomvec() * 0.6);  // Apply Punchangle
			}
		}
		enFind = enFind.chain;
	}
};

void() screenshake = { // [FUNCTION]
	local entity plyr;
	local float	d;

	if (self.attack_finished < time) return; // Is the shaking over?
	
	plyr = nextent(world); // Create a list of entities to check for players
	while(plyr) {
		if (plyr.flags & FL_CLIENT) { // Only shake players (clients)
			d = vlen(self.origin - plyr.origin); // Scale effect by distance
			d = (1300 - d)/180;
			if (d > 0) {
				plyr.punchangle_x = -1 * (random(-1,1) + (0.05*d)); // shake up the view
				plyr.punchangle_y = -1 * (random(-1,1) + (0.05*d));
				plyr.punchangle_z = -1 * (random(-2,2) + (0.05*d));	
			}
		}
		plyr = nextent(plyr); // Find next entity in chain.
	}
	self.nextthink = time + 0.1;
	self.think = screenshake; // keep on shaking!  shake a little faster!  shake a little slower!  good thing we got our shaking clothes
};

// idea taken from kleshik
void(float fPunchStrength, float fRadius) Monster_Animation_EarthQuake = { // [FUNCTION]
	local entity enFind;

	if (self.flags & FL_ONGROUND) { 
		enFind = findradius(self.origin, fRadius);	
		while(enFind) { 
			if (enFind.flags & FL_ONGROUND && enFind != self) { 
				if (enFind.flags & FL_MONSTER || enFind.flags & FL_CLIENT) {
					enFind.velocity_x = enFind.velocity_x + (crandom() * fPunchStrength * 5);  
					enFind.velocity_y = enFind.velocity_y + (crandom() * fPunchStrength * 5); 
					enFind.velocity_z = enFind.velocity_z + (fPunchStrength * 10) + (crandom() * 40);  
				}
				if (enFind.flags & FL_CLIENT) enFind.punchangle = enFind.punchangle + (mathlib_randomvec() * (0.7 * fPunchStrength));  // Apply Punchangle
			}
			enFind = enFind.chain;
		}
	}
};
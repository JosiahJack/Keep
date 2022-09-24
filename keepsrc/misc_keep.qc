//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by W. Josiah Jack, aka Qmaster
//
// Attributions: Qmaster and Anders Persson
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
// Entity count: 8
// Function count: 18
//
// Implements: Various Miscellaneous Effects and Decorations.
//
// Description:
// Various stuff.
//=============================================================================

float FILTER_NOPROJECTILE_BYPASS = 1; // Check against projectile, not owner.

void() effect_pulse_launch = { // [FUNCTION]
	local entity missile;
	missile = spawn();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	missile.classname = "pulse";
	missile.velocity = self.movedir * self.speed;
	missile.touch = SUB_Remove;
	missile.nextthink = time + 5;
	missile.think = SUB_Remove;
	missile.effects = EF_DIMLIGHT;
	setmodel(missile, "progs/null.spr");  // formerly s_null.spr
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(missile, self.origin);
};

void() effect_pulse_loop = { // [FUNCTION]
	if (self.wait > 0) self.nextthink = time + self.wait;
	self.think = effect_pulse_loop;
	effect_pulse_launch();
	if (self.wait == CONTENT_EMPTY) { SUB_Remove(); return; }
};

void() effect_pulse_start = { // [FUNCTION]
	self.nextthink = time + self.delay;
	self.think = effect_pulse_loop;
};

void() effect_pulse = { // [ENTITY], Redirecty [sic Quoth]
	precache_model("progs/null.spr"); //formerly s_null.spr
	SetMovedir();
	if (!(self.speed)) self.speed = 400;
	if (!(self.delay)) self.delay = 0.1;
	if (!(self.wait)) self.wait = 1;
	self.nextthink = time + self.delay;
	if (self.targetname) {
		self.think = SUB_Null;
		self.use = effect_pulse_start;
		return;
	}
	self.think = effect_pulse_loop;
};

void() info_effect_pulse = { effect_pulse(); }; // [ENTITY], Main entity, don't use effect_pulse normally.

void() shaker_think = { // [FUNCTION]
	local float d;

	d = vlen(self.origin - self.spawnmaster.origin); // Scale effect by distance
	d = (self.count - d)/self.count;
	self.nextthink = time + self.lip;
	self.think = shaker_think;
	if (self.ltime > time) {
		self.spawnmaster.punchangle_x = (time - self.ltime) * random() * self.multiplier;
		self.spawnmaster.punchangle_y = (time - self.ltime) * random() * self.multiplier;
		self.spawnmaster.punchangle_z = (time - self.ltime) * random() * self.multiplier;
	}

	if (d > 0) {
		if (self.spawnmaster.flags & FL_ONGROUND && self.spawnflags & 2) { // push the grounded players around
			d = self.dmg*d;
			self.spawnmaster.velocity_x = self.spawnmaster.velocity_x + (random()*d*2 - d);
			self.spawnmaster.velocity_y = self.spawnmaster.velocity_y + (random()*d*2 - d);
			self.spawnmaster.velocity_z = self.spawnmaster.velocity_z + (random()*d);// always push up
		}	
	}

	if (self.ltime < time) SUB_Remove();
};

void() shake_use = { // [FUNCTION]
	local entity qent;

	qent = spawn();
	qent.owner = self;
	qent.movetype = MOVETYPE_NONE;
	qent.solid = SOLID_NOT;
	qent.spawnmaster = activator;
	qent.nextthink = time + self.lip;
	qent.think = shaker_think;
	qent.multiplier = self.multiplier;
	qent.lip = self.lip;
	qent.duration = time + self.duration;
	qent.ltime = time + self.ltime;
	setsize(qent, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(qent, self.origin);
};

void() info_screenshake = { // [ENTITY]
	if (!(self.ltime)) self.ltime = 1;
	if (!(self.lip)) self.lip = 0.010000;
	if (!(self.multiplier)) self.multiplier = 0.000500;
	if (!self.dmg) self.dmg = 120;
	self.use = shake_use;
};

void(entity e, float magnitude, float interval, float mult) shake_player = { // [FUNCTION]
	local entity qent;

	qent = spawn();
	qent.owner = self;
	qent.movetype = MOVETYPE_NONE;
	qent.solid = SOLID_NOT;
	qent.spawnmaster = e;
	qent.nextthink = time + 0.1;
	qent.think = shaker_think;
	qent.ltime = time + magnitude;
	qent.lip = interval;
	qent.multiplier = mult;
	setsize(qent, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(qent, e.origin);
};

void() bombthink = { // [FUNCTION]
	T_RadiusDamage(self, self.owner, 512, world,DAMAGEALL);
	self.frame = self.frame + 1;
	if (self.frame == 24) spawn_big_explosion(self.origin, 0);
	if (self.frame > 25) { SUB_Remove(); return; }

	self.think = bombthink;
	self.nextthink = time + 0.1;
};

void() ringthink = { // [FUNCTION]
	self.nextthink = time + 0.1;
	self.think = ringthink;
	self.frame = self.frame + 1;
	if (self.frame > 20) SUB_Remove();
};

void() ringprethink = { // [FUNCTION]
	self.nextthink = time + 0.1;
	self.think = ringthink;
	self.avelocity = '0 0 200';
	setmodel(self, "progs/quoth/shockwave.mdl");
};

void() W_Bomb = { // [FUNCTION]
	local entity bomb, t, ring;
	local float dist;

	if (coop > 0 && self.gotbomb != -1) self.gotbomb = 1;
	bomb = spawn();
	bomb.solid = SOLID_NOT;
	setsize(bomb, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(bomb, self.origin);
	setmodel(bomb, "progs/ne_ruins/boom.mdl");
	bomb.think = bombthink;
	bomb.nextthink = time + 0.1;
	bomb.owner = self;
	bomb.effects = EF_BRIGHTLIGHT + 32;
	bomb.glow_color = 239;
	bomb.glow_size = 1000;
	if (cvar("pr_checkextension")) {
		if (checkextension("DP_TE_CUSTOMFLASH")) {
			te_customflash(self.origin, 1000, 5, '1 0.6 0.6');
			bomb.effects = 32;
		}
	}

	spawn_big_explosion(self.origin,1);
	t = nextent(world);
	while (t) {
		if (t.classname == "player") {
			dist = vlen(self.origin - t.origin);
			if (dist < 700) shake_player(t, 2.5, 0.010000, 8);
			else {
				if (dist < 1200) shake_player(t, 1, 0.010000, 7);
				else shake_player(t, 0.5, 0.010000, 10);
			}
		}
		t = nextent(t);
	}

	ring = spawn();
	setorigin(ring, self.origin);
	ring.think = ringprethink;
	ring.nextthink = time + 0.3;
	ring.movetype = MOVETYPE_FLY;
	ring.effects = 32;
	ring = spawn();
	setorigin(ring, self.origin);
	ring.think = ringprethink;
	ring.nextthink = time + 0.3;
	ring.movetype = MOVETYPE_FLY;
	ring.effects = 32;
	ring.angles = '0 90 0';
	Tent_Explosion(ring.origin);
	if (self.invincible_finished) {
		self.items = self.items - IT_INVULNERABILITY;
		self.invincible_time = 0;
		self.invincible_finished = 0;
	}

	if (self.cross_finished) {
		//self.items2 = self.items2 - IT2_CROSS;
		self.cross_finished = 0;
		self.cross_time = 0;
		self.cross_start = 2;
		Safe_stuffcmd(self, "v_cshift 0 0 0 0\n");
	}

	T_RadiusDamage(bomb, self, 512, self,DAMAGEALL);
	T_Damage(self, self, self, -666,DAMARMOR);
	self.velocity_z = 700;
	sound(self,CHAN_AUTO,"quoth/weapons/bombfar.wav",1,ATTN_NONE);
	sound(self,CHAN_AUTO,"quoth/weapons/bomb.wav", 1, 0.7);
};

void() info_bomb = { // [ENTITY]
	precache_sound("quoth/weapons/bomb.wav");
	precache_sound("quoth/weapons/bombfar.wav");
	precache_model("progs/quoth/v_bomb.mdl");
	precache_model("progs/quoth/smlexp.spr");
	precache_model("progs/quoth/bigexp.spr");
	precache_model("progs/ne_ruins/boom.mdl");
	precache_model("progs/quoth/shockwave.mdl");
	self.use = W_Bomb;
};

void() splash_think = { // [FUNCTION]
	local vector vec;
	local float variance;

	variance = vlen(self.movedir) / 2;
	vec_x = self.movedir_x - variance + random() * variance * 2;
	vec_y = self.movedir_y - variance + random() * variance * 2;
	vec_z = self.movedir_z - variance + random() * variance * 2;
	particle (self.origin, vec, self.col, self.volume);
	self.nextthink = time + self.wait;
}

void() misc_splash_toggle = { // [FUNCTION]
	if (self.state) {
		self.state = FALSE;
		self.think = SUB_Null;
	} else {
		self.state = TRUE;
		self.nextthink = time + self.wait;
		self.think = splash_think;
	}
};

// QUAKED misc_splash (0 .5 .8) (-8 -8 -8) (8 8 8)
// Produces a continuous particle splash for waterfalls
// "color" color of particles.  0 through 15, corresponds to a row of the quake palette. (default 0)
// "movedir" average movement vector of particles (default 0 0 4)
// "wait" time between particle generation cycles.  (default 0.1)
// "volume" density of particles. (default 10)
void() misc_splash = { // [ENTITY]
	if (!self.wait) self.wait = 0.1;
	if (self.mangle != '0 0 0' && !self.movedir) self.movedir = self.mangle;
	if (!self.movedir) self.movedir = '0 0 4';
	if (!self.volume) self.volume = 10;
	self.col = self.col * 16;
	self.use = misc_splash_toggle;
	if (self.state == 0) self.state = TRUE; // Default on.
	self.nextthink = time + self.wait;
	self.think = splash_think;
};

void() light_globecolor = { // [ENTITY]
	if (self.count == 1) self.mdl = "progs/s_light2.spr";      // Red orange
	else if (self.count == 2) self.mdl = "progs/s_light3.spr"; // Yellow
	else if (self.count == 3) self.mdl = "progs/s_light4.spr"; // Blue
	else if (self.count == 4) self.mdl = "progs/s_light5.spr"; // White
	else if (self.count == 5) self.mdl = "progs/s_light6.spr"; // Dark red
	else self.mdl = "progs/s_light.spr";					   // Normal

	precache_model(self.mdl);
	setmodel(self, self.mdl);
	setsize(self, VEC_ORIGIN, VEC_ORIGIN);
	self.classtype = CT_LIGHTSTATIC; // Default = static entity, check done in static function
	setup_vanilla_nostatic();
	light_customstyle_start(); // Check for any custom light styles
};

void() misc_fan_break = { // [FUNCTION]
	self.frame = 15;
	self.think = SUB_Null;
	self.nextthink = time;
	self.use = SUB_Null;
	SUB_UseTargets();
};

void() misc_fan_run = { // [FUNCTION]
	self.walkframe = self.walkframe + 1;
	if (self.walkframe > 14) self.walkframe = 0;
	self.frame = self.walkframe;
	self.think = misc_fan_run;
	self.nextthink = time + self.speed;
};

void() misc_fan_enable = { // [FUNCTION]
	self.estate = ESTATE_ON;				// Switch running/spinning
	self.think = misc_fan_run;
	self.nextthink = time + self.speed;
};

void() misc_fan_idle = { // [FUNCTION]
	self.frame = 0;
	self.think = misc_fan_idle;
	self.nextthink = time + 0.1;
};

void() misc_fan_disable = { // [FUNCTION]
	self.estate = ESTATE_DISABLE; // Switch to stationary
	self.think = misc_fan_idle;
	self.nextthink = time + 0.1;
};

void() misc_fan_reset = { // [FUNCTION]
	setmodel(self,self.mdl);
	setsize (self, VEC_ORIGIN, VEC_ORIGIN);
	self.velocity = '0 0 0';
	setorigin(self, self.oldorigin);
	misc_fan_enable();
};

void() misc_fan_off = { // [FUNCTION]
	self.estate = ESTATE_OFF; // Completely invisible
	self.model = "";				// hide bmodel surface
	self.think = misc_fan_idle;
	self.nextthink = 0;
};

// Madfox destroyable fast fan model.  0-14 run.  15 broke
void() misc_fan = { // [ENTITY]
	self.mdl = "progs/madfox/fanhouse.mdl";
	precache_model (self.mdl);
	setmodel(self,self.mdl);
	setsize (self, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(self, self.origin);
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_NONE;
	self.use = misc_fan_break;
	self.oldorigin = self.origin;
	if (!self.mangle) self.mangle = self.angles; // Override angles with mangle.  Save for later.
	self.angles = self.mangle;
	if (self.speed <=0 ) self.speed = 0.1;
	if (self.spawnflags & 1) { misc_fan_disable(); return; }
	else if (self.spawnflags & 2) { misc_fan_break(); return; }

	self.estate_disable = misc_fan_disable;
	self.estate_reset = misc_fan_reset;
	self.estate_on = misc_fan_enable;
	self.estate_off = misc_fan_off;
	self.walkframe = 0;
	misc_fan_run();
};

// Rotating fan hack from tfl4 by Anders Persson
void() rotating_wall = { // [ENTITY]
	setmodel(self, self.model);
	self.solid = SOLID_BBOX;
	self.movetype = MOVETYPE_FLY;
	self.classname = "r_wall";
	self.origin_x = self.r_wall_x;
	self.origin_y = self.r_wall_y;
	self.origin_z = self.r_wall_z;
	self.avelocity_x = self.r_wall_x_spin;
	self.avelocity_y = self.r_wall_y_spin;
	self.avelocity_z = self.r_wall_z_spin;
};

void() move_rope_spawn = { // [FUNCTION]
	local float btype;

	self.attachment = find(world,targetname,self.target);
	if (!self.attachment) self.attachment = find(world,targetname,self.target);
	if (self.attachment && self.target != "") {
		btype = BEAM_NORMAL;
		if (self.spawnflags & ENT_SPNSTATIC) btype = BEAM_STATIC; 
		QC_ParseBeamGeneric(0,self.mdl,self.skin,self,self.origin,self.attachment.origin,self.delay,btype,self.attachment);
	} else {
		dprint("couldn't find a rope target of ");
		dprint(self.target);
		dprint("\n");
	}
};

void() move_rope = {
	if (self.mdl == "") self.mdl = "progs/beam.mdl";
	precache_model(self.mdl);
	if (self.delay <= 0) self.delay = 32; // Default length
	if (self.target != "") {
		self.think = move_rope_spawn;
		self.nextthink = time + (random() * 0.5) + 1;
	}
};

float(string actval, string filterval, float type) info_filter_filterstring = {
	if (actval == "") {
		if (filterval == "") {
			if (type == 1) return FALSE; // Not Equal
			else return TRUE; // Equal
		} else {
			if (type == 1) return TRUE; // Not Equal
			else return FALSE; // Equal
		}
	} else {
		if (filterval == "") {
			if (type == 1) return TRUE; // Not Equal
			else return FALSE; // Equal
		}
	}

	// OK so both actval != "" and filterval != "" here
	if (type == 1) return (actval != filterval); // Not Equal
	else return (actval == filterval); // Equal
};

float(float actval, float filterval, float type) info_filter_filternumber = {
	if (type == 5) return (actval > filterval); // Only Above
 	else if (type == 4) return (actval < filterval); // Only Below
	else if (type == 3) return (actval >= filterval); // Above or Equal
	else if (type == 2) return (actval <= filterval); // Below or Equal
	else if (type == 1) return (actval != filterval); // Not Equal
	else return (actval == filterval); // Equal
};

float(float actval, float filterval, float type) info_filter_filterbits = {
	if (type == 1) return !(actval & filterval); // Not Equal
	else return (actval & filterval); // Equal
};

void() info_filter_use = {
	local float success, actval, filterval;
	local string actstring, filterstring;
	local entity act;

	if (activator) act = activator;
	else if (self.bmodel_act) act = self.bmodel_act;
	else if (other) act = other;
	if (!act) return; // Nothing to run filter on!

	if (IsProjectile(act) && !(self.spawnflags & FILTER_NOPROJECTILE_BYPASS)) {
		if (act.owner.flags & FLx_CREATURE) act = act.owner; // Pass owner info.
	}

	success = FALSE;
	if (self.filterstyle == FILTER_CURRENTWEAPON) {
		actval = GetWepIDIndex(act.weapon,act.weaponismoditems);
		filterval = GetWepIDIndex(self.weapon,self.weaponismoditems);
		success = info_filter_filternumber(actval,filterval,self.state);
	} else if (self.filterstyle == FILTER_HASITEM)  success = info_filter_filterbits(act.items,self.items,self.state);
	else if (self.filterstyle == FILTER_HASITEM2)   success = info_filter_filterbits(act.items2,self.items2,self.state);
	else if (self.filterstyle == FILTER_HASMODITEM) success = info_filter_filterbits(act.moditems,self.moditems,self.state);
	else if (self.filterstyle == FILTER_HASPERM)    success = info_filter_filterbits(act.perms,self.perms,self.state);
	else if (self.filterstyle == FILTER_HASITEM3)   success = info_filter_filterbits(act.items3,self.items3,self.state);
	else if (self.filterstyle == FILTER_CLASSNAME)  success = info_filter_filterstring(act.classname,self.filtername,self.state);
	else if (self.filterstyle == FILTER_CLASSTYPE)  success = info_filter_filternumber(act.classtype,self.classtype,self.state);
	else if (self.filterstyle == FILTER_TARGETNAME) success = info_filter_filterstring(act.targetname,self.filtername,self.state);
	else if (self.filterstyle == FILTER_COUNT)      success = info_filter_filternumber(act.count,self.count,self.state);
	else if (self.filterstyle == FILTER_CNT)        success = info_filter_filternumber(act.cnt,self.cnt,self.state);
	else if (self.filterstyle == FILTER_HEALTH)     success = info_filter_filternumber(act.health,self.health,self.state);
	else if (self.filterstyle == FILTER_ONFIRE) {
		if (self.state) success = !act.burning;
		else success = act.burning;
	} else if (self.filterstyle == FILTER_POISONED) {
		if (self.state) success = !act.poisoned;
		else success = act.poisoned;
	} else if (self.filterstyle == FILTER_BLEEDING){
		if (self.state) success = !act.bleeding;
		else success = act.bleeding;
	} else if (self.filterstyle == FILTER_INVISIBLE) {
		if (self.state) success = !Invisible(act);
		else success = Invisible(act);
	} else if (self.filterstyle == FILTER_INVINCIBLE){
		if (self.state) success = !Indestructable(act);
		else success = Indestructable(act);
	} else if (self.filterstyle == FILTER_DAMAGEABLE){
		if (self.state) success = (act.takedamage == DAMAGE_NO);
		else success = act.takedamage;
	} else if (self.filterstyle == FILTER_CURSED){
		if (self.state) success = !act.curse_type;
		else success = act.curse_type;
	} else if (self.filterstyle == FILTER_SLOWED){
		if (self.state) success = !act.slow_finished;
		else success = act.slow_finished;
	} else if (self.filterstyle == FILTER_FROZEN){
		if (self.state) success = !act.frozen;
		else success = act.frozen;
	} else if (self.filterstyle == FILTER_ROTTING){
		if (self.state) success = !act.rotting;
		else success = act.rotting;
	} else if (self.filterstyle == FILTER_WET){
		if (self.state) success = !act.liquidbase && !act.waterlevel;
		else success = act.liquidbase || act.waterlevel;
	} else if (self.filterstyle == FILTER_PLAYER){
		if (self.state) success = !(act.flags & FL_CLIENT);
		else success = (act.flags & FL_CLIENT);
	} else if (self.filterstyle == FILTER_MONSTER){
		if (self.state) success = !(act.flags & FL_MONSTER);
		else success = (act.flags & FL_MONSTER);
	} else if (self.filterstyle == FILTER_CREATURE){
		if (self.state) success = !(act.flags & FLx_CREATURE);
		else success = (act.flags & FLx_CREATURE);
	} else if (self.filterstyle == FILTER_DENIZEN){
		if (self.state) success = !(act.alignment == NEUTRAL && act.classgroup == CG_HARMLESS);
		else success = (act.alignment == NEUTRAL && act.classgroup == CG_HARMLESS);
	} else if (self.filterstyle == FILTER_ALIGNMENT){
		if (self.state) success = !Align_Match(self,act);
		else success = Align_Match(self,act);
	}

	if (success) {
		if (self.noise != "") sound(self,CHAN_VOICE,self.noise,1,ATTN_NORM);
		if (self.message != "") centerprint(act,self.message);
		activator = act;
		SUB_UseTargets();
	} else {
		if (self.message2 != "") {
			sound(act,CHAN_VOICE,"misc/talk.wav",1,ATTN_NORM);
			centerprint(act,self.message2);
		}
	}
};

void() info_filter = {
	if (self.noise != "") precache_sound(self.noise);
	if (!self.filterstyle) self.filterstyle = FILTER_CLASSNAME;
	self.use = info_filter_use;
};
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

// Classic ID rocket/grenade explosion
void() s_explode1 = [0,	s_explode2] {}; // [FUNCTION]
void() s_explode2 = [1,	s_explode3] {}; // [FUNCTION]
void() s_explode3 = [2,	s_explode4] {}; // [FUNCTION]
void() s_explode4 = [3,	s_explode5] {}; // [FUNCTION]
void() s_explode5 = [4,	s_explode6] {}; // [FUNCTION]
void() s_explode6 = [5,	SUB_Remove] {}; // [FUNCTION]

void() s_explode_think = { // [FUNCTION]
    if (self.frame >= self.cnt) {SUB_Remove ();  return;}

    self.frame = self.frame + 1;
    self.nextthink = time + self.wait;
    if (self.frame == self.cnt) self.think = SUB_Remove;
};

// General purpose animated spite function.  Types: Small, medium, big, plasma, puffpuff!
void() SpawnExplosion_think = { // [FUNCTION]
	self.frame = self.frame + 1;
	if (self.frame > self.count) SUB_Remove();
	else self.nextthink = time + self.speed;
};

void(float sprite_type, vector org, string expl_sound) SpawnExplosion = { // [FUNCTION]
	local string spr_name;
	local float spr_count, spr_speed;
	
	spr_count = -1;
	if (sprite_type == EXPLODE_SMALL) {
		if (ext_dppart) pointparticles(particleeffectnum(DPP_TEEXPLODE), org, '0 0 0', 1);
		spr_name = SEXP_SMALL;
		spr_count = 5;
		spr_speed = 0.1;
	} else if (sprite_type == EXPLODE_MED) {
		if (ext_dppart) pointparticles(particleeffectnum(DPP_TEEXPLODE), org, '0 0 0', 1);
		spr_name = SEXP_MED;
		spr_count = 13;
		spr_speed = 0.05;
	} else if (sprite_type == EXPLODE_BIG) {
		if (ext_dppart) pointparticles(particleeffectnum(DPP_TEEXPLODE), org, '0 0 0', 1);
		spr_name = SEXP_BIG;
		spr_count = 16;
		spr_speed = 0.05;
	} else if (sprite_type == EXPLODE_PLASMA_SMALL) {
		if (ext_dppart) pointparticles(particleeffectnum(DPP_TEPLASMA), org, '0 0 0', 1);
		spr_name = SEXP_PLASMA_SMALL;
		spr_count = 12;
		spr_speed = 0.05;
	} else if (sprite_type == EXPLODE_PLASMA_MED || sprite_type == EXPLODE_PLASMA_BIG) {
		if (ext_dppart) pointparticles(particleeffectnum(DPP_TEPLASMABIG), org, '0 0 0', 1);
		spr_name = SEXP_PLASMA_BIG;
		spr_count = 12;
		spr_speed = 0.05;
	} else if (sprite_type == EXPLODE_POISON_SMALL) {
		if (ext_dppart) pointparticles(particleeffectnum(DPP_TEPOISON), org, '0 0 0', 1);
		spr_name = SEXP_POISON_SMALL;
		spr_count = 12;
		spr_speed = 0.05;
	} else if (sprite_type == EXPLODE_POISON_MED || sprite_type == EXPLODE_POISON_BIG) {
		if (ext_dppart) pointparticles(particleeffectnum(DPP_TEPOISONMED), org, '0 0 0', 1);
		spr_name = SEXP_POISON_MED;
		spr_count = 12;
		spr_speed = 0.05;
	} else if (sprite_type == EXPLODE_ELECT_SMALL || sprite_type == EXPLODE_ELECT_MED || sprite_type == EXPLODE_ELECT_BIG) {
		if (ext_dppart) pointparticles(particleeffectnum(DPP_TEPLASMA), org, '0 0 0', 1);
		spr_name = SEXP_ELECTRIC;
		spr_count = 4;
		spr_speed = 0.1;
	} else if (sprite_type == EXPLODE_ICE_BIG) {
		// This must be pre-cached by entity using it (monster_icegolem)!  This is not cached in worldspawn as its rarely used.
		if (ext_dppart) pointparticles(particleeffectnum(DPP_TEPLASMA), org, '0 0 0', 1);
		spr_name = SEXP_ICE_BIG;
		spr_count = 9;
		spr_speed = 0.1;
	} else if (sprite_type == EXPLODE_BURST_SMOKE) {
		if (ext_dppart) pointparticles(particleeffectnum(DPP_TEBSMOKE), org, '0 0 0', 1);
		spr_name = SBURST_SMOKE;
		spr_count = 6;
		spr_speed = 0.05;
	} else if (sprite_type == EXPLODE_BURST_FLAME) {
		if (ext_dppart) pointparticles(particleeffectnum(DPP_TEBFLAME), org, '0 0 0', 1);
		spr_name = SBURST_FLAME;
		spr_count = 6;
		spr_speed = 0.05;
	} else if (sprite_type == EXPLODE_BURST_POISON) {
		if (ext_dppart) pointparticles(particleeffectnum(DPP_TEBPOISON), org, '0 0 0', 1);
		spr_name = SBURST_POISON;
		spr_count = 6;
		spr_speed = 0.05;
	} else return; // NO EXPLOSION, let's get outta here!

	// Always spawn a temporary entity.  Need one for sprite and/or explosion sound
	newmis = spawn();
	newmis.classgroup = CG_TEMPENT;
	newmis.movetype = MOVETYPE_NONE;
	newmis.solid = SOLID_NOT;
	setorigin(newmis, org);

	// Any sprite requirements? (Fitz engine)
	if (spr_count > 0) {
		setmodel(newmis, spr_name);	// Setup sprite
		setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);
		newmis.alpha = 0.85;		// Slightly transparent
		newmis.effects = 32;		// Additive blending
		newmis.count = spr_count;	// Total frames
		newmis.speed = spr_speed;	// Frame speed
		newmis.think = SpawnExplosion_think;
		newmis.nextthink = time + newmis.speed;
	} else {
		// No sprite required but need entity for sound to play
		// Allow for sound to finish and just remove
		setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);
		newmis.think = SUB_Remove;
		newmis.nextthink = time + 4;
	}

	// Play any explosion sounds on temporary entity
	if (self.owner.classtype == CT_MONEEL) expl_sound = "ad171/eel/impact1.wav";
	if (expl_sound != "") sound(newmis, CHAN_WEAPON, expl_sound, 1, ATTN_NORM);
};

// Use SpawnExplosion where possible as it copes with DP effects better.
void() BecomeExplosion = { // [FUNCTION]
	self.touch = SUB_Null;
	self.velocity = '0 0 0';
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	setmodel(self, "");
	SpawnExplosion(EXPLODE_SMALL, self.origin, "");
	self.nextthink = time + 0.6;
	self.think = SUB_Remove;
};

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
		setmodel (targ, MODEL_PROJ_FLESHP);
		targ.gibtype = GIBTYPE_POISON;
	} else if (source.classgroup == CG_ROBOT || source.classgroup == CG_STONE) {
		setmodel (targ, MODEL_PROJ_SMOKE);
		targ.gibtype = GIBTYPE_STONE;
	} else {
		setmodel (targ, MODEL_PROJ_FLESH);
		targ.gibtype = GIBTYPE_BLOOD;
	}
	if (ext_dppart) DPP_blood_trail(targ); // Finally add DP particle trails
};

// Mainly used to show resistance to an ammo type.  Also used by boils for their idle gibs
void(entity source, vector org, float velrnd, float upbase, float uprnd) SpawnProjectileMeat = { // [FUNCTION]
	newmis = spawn ();
	newmis.classtype = CT_TEMPGIB;
	newmis.classgroup = CG_TEMPENT;
	newmis.movetype = MOVETYPE_BOUNCE;
	newmis.solid = SOLID_NOT;
	ProjectileType(source, newmis); // Projectile types (Poison/Robot/Stone/Blood)
	setorigin (newmis, org);
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);		
	newmis.velocity = vecrand(0,velrnd,TRUE);
	newmis.velocity_z = upbase, random()*uprnd;
	newmis.avelocity = vecrand(100,velrnd,FALSE);
	newmis.nextthink = time + 1 + random()*3;
	newmis.think = SUB_Remove;
};

// SpawnBlood
void(entity targ, vector org, vector vel, float part_qty) SpawnBlood = { // [FUNCTION]
	local float loop_count, part_col;

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

// Triggered by Touch_Bullet, Touch_PlasmaProjectile, Touch_Projectile.
void(entity source, entity targ, float damage) spawn_touchblood = { // [FUNCTION]
	local vector org, vel;

	makevectors(source.angles);
	vel = normalize (source.velocity);
	vel = normalize(vel + v_up*(random()- 0.5) + v_right*(random()- 0.5));
	vel = vel + 2*trace_plane_normal;
	vel = vel * 0.4; // Originally vel = ((vel * 200) * 0.2) * 0.01
	if (CheckZeroVector(source.meleeoffset)) org = '0 0 0'; // Check for an origin blood offset (monsters)
	else org = attack_vector(source.meleeoffset);
	
	SpawnBlood (targ, source.origin + org, vel, damage);
};

// Spawns a particle trail for an invisible blood model.
// Useful for any monster with blood of unusual color (like black or blue).
// It could be motor oil, antifreeze, milk, or fruit juice for all we know.
void() MeatSprayThink = { // [FUNCTION]
    local   vector  dir;

    if (self.delay <= time) {remove(self); return;}

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

	text = string_null;
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
		SpawnBlood(targ, org, v_up*2, 100);
	} else {
		newmis = spawn();
		newmis.classtype = CT_TEMPGIB;
		newmis.classgroup = CG_TEMPENT;
		newmis.owner = source;
		newmis.movetype = MOVETYPE_BOUNCE;
		newmis.solid = SOLID_NOT;
		ProjectileType(targ, newmis);
		setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);		
		setorigin (newmis, org);
		newmis.velocity = ((crandom()*16) * v_forward) + (side * v_right); // Use side velocity to determine which direction to throw
		newmis.velocity_z = newmis.velocity_z + 150 + 50*random();
		newmis.avelocity = vecrand(100,200,FALSE);
		if (btype) {
			newmis.velocity_z = newmis.velocity_z + 100; // Drake used 250 instead of 150
			newmis.avelocity   = '3000 1000 2000';
		}

		if (text != string_null)
			setmodel (newmis, text); // Oh hey we actually have substance!
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

void() SUB_BeamRemove = { // [FUNCTION]
	num_beams = num_beams - 1;
	if (num_beams < 0) num_beams = 0;
	remove(self);
};

void() rope_think = { // [FUNCTION]
	local vector massvec, turnangle;

	// Sag
	if (self.mass) {
		massvec_z = self.mass;
		if (self.faceangle_inc_x == self.faceangle_inc_z) massvec_z = self.mass; // Midpoint needs to be halfway between start and end and then lowered down by mass.
		else massvec_z = 0;//massvec_z * (self.faceangle_inc_x / self.faceangle_inc_y); // Sag
		// else if (RopeInLastHalf())  massvec_z = massvec_z * (self.faceangle_inc_x / self.faceangle_inc_y); // Sag
		// else massvec_z = 0; // Don't move the start and end down for sag.

		//setorigin(self,self.oldorigin - massvec);


	// TODO Handle wind.

	// Use Gyro aerodynamics code to align to movedir facing angle to point toward midpoint
	// if (self.faceangle_inc_x != self.faceangle_inc_z) {
		// self.angles_y = 0; // Lay flat for midpoint
	// } else if (RopeInFirstHalf() || RopeInLastHalf()) {
		// if (RopeInFirstHalf()) self.movedir = normalize(self.facevector - self.owner.origin); // Less than half way, point from start to midpoint
		// else self.movedir = normalize(self.enemy.origin - self.facevector); // More than half way, point from end to midpoint
		// turnangle = vectoangles(self.movedir);
		// turnangle = turnangle - self.angles;
		// while (turnangle_x > 180.0) turnangle_x = turnangle_x - 360.0;
		// while (turnangle_x < -180.0) turnangle_x = turnangle_x + 360.0;
		// while (turnangle_y > 180.0) turnangle_y = turnangle_y - 360.0;
		// while (turnangle_y < -180.0) turnangle_y = turnangle_y + 360.0;
		// while (turnangle_z > 180.0) turnangle_z = turnangle_z - 360.0;
		// while (turnangle_z < -180.0) turnangle_z = turnangle_z + 360.0;
		// self.angles = turnangle;
	}
	SUB_SelfThink(rope_think,0.05);
};

// Engine C Code conversion to QC of CL_ParseBeam.  We need a whole lot more than just one progs/beam.mdl!!
// Oh and the beams are all different lengths.  Yay modders :/  Supposed to be 32 apparently.
// Nehahra beam is 32 long
// Drake beam is 31 long
// Custents beam is 48 long
// Redfield beam is 32 long
// Kurok beam is 32 long
// Check your precaches in old non-QSS/FTE/DP engines!
//
// Example usage: QC_ParseBeam(0,"progs/redfield/beam.mdl", self, org, trace_endpos, 32);
void(float fx, string m, entity src, vector start, vector end, float length, float persistent, entity dest) QC_ParseBeamGeneric = { // [FUNCTION]
	local float loop, numneeded, dist;
	local entity beam, lastbeam;
	local vector turnangle, midpoint;

	if (fx == TE_BEAM || fx == TE_LIGHTNING1 || fx == TE_LIGHTNING2) { Tent_Beam(fx,src, start,end); return;} // Normal vanilla beams, use if src moves!
	if (!m) { Tent_Beam(TE_BEAM,src, start,end); return;} // Vanilla beam
	if (num_beams >= MAX_BEAMS) { // Exceeded max qc beams
		dprint("Beam effect list overflow! More than ");
		dprint(ftos(MAX_BEAMS));
		dprint("!\n");\
		return;
	}

	if (length <= 0) length = 32; // default
	dist = vlen(end-start);
	numneeded = ceil(dist/length); // Ceil to get at least 2
	dist = dist / length; // Reuse dist to store spacing needed, this isn't rounded, yes I know I just divided this a second ago
	if (persistent) midpoint = start + ((end - start) * length * (numneeded / 2));
	lastbeam = world;
	while (loop < numneeded) {
		if (num_beams < MAX_BEAMS) {
			beam = spawn();
			if (!lastbeam) lastbeam = beam; // Set first beam.
			num_beams = num_beams + 1;
			beam.mass = src.mass;
			setmodel(beam,m);
			if (persistent <= 0) {
				beam.nextthink = time + 0.2;
				beam.think = SUB_BeamRemove;
			} else if (persistent == 1) {
				beam.nextthink = time + 0.2;
				beam.think = rope_think; // Sag and sway.
				midpoint_z = midpoint_z - self.mass;
				beam.facevector = midpoint; // Store midpoint
				beam.faceangle_inc_x = loop;
				beam.faceangle_inc_y = numneeded;
				beam.faceangle_inc_z = floor(self.faceangle_inc_y / 2); // Index of middle beam entity.
				beam.owner = src;
				if (lastbeam) beam.oldenemy = lastbeam;
				beam.enemy = dest;
			}
			lastbeam = beam;
			beam.movedir = normalize(end - start);
			setsize(beam,VEC_ORIGIN,VEC_ORIGIN);
			setorigin(beam,start + (beam.movedir * loop * length));
			beam.velocity = beam.avelocity = VEC_ORIGIN;

			if (!src.style) {
				// Align to movedir facing angle
				if (src.flags & FL_CLIENT) {
					makevectors(src.v_angle);
					turnangle = v_forward * 32;
					beam.angles = vectoangles(turnangle);
				} else {
					turnangle = vectoangles(beam.movedir);
					beam.angles = Gyro_Aerodynamics_Turnangle(turnangle,beam.angles);
				}
			}
			beam.oldorigin = beam.origin;
			if (persistent == BEAM_STATIC) makestatic(beam);
		}
		loop = loop + 1;
	}
};

void(float fx, string m, entity src, vector start, vector end, float length) QC_ParseBeam = { QC_ParseBeamGeneric(fx,m,src,start,end,length,BEAM_TEMPORARY,world); }; // [FUNCTION]

void(float fx, entity src, vector p1, vector p2) Tent_Beam = { // [FUNCTION]
    WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
    WriteByte (MSG_BROADCAST, fx);
    WriteEntity (MSG_BROADCAST, src);   // If client, src.origin overrides p1.
    WriteCoord (MSG_BROADCAST, p1_x);
    WriteCoord (MSG_BROADCAST, p1_y);
    WriteCoord (MSG_BROADCAST, p1_z);
    WriteCoord (MSG_BROADCAST, p2_x);
    WriteCoord (MSG_BROADCAST, p2_y);
    WriteCoord (MSG_BROADCAST, p2_z);
};

void(vector spot) Tent_Explosion = { // [FUNCTION]
    WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
    WriteByte (MSG_BROADCAST, TE_EXPLOSION);
    WriteCoord (MSG_BROADCAST, spot_x);
    WriteCoord (MSG_BROADCAST, spot_y);
    WriteCoord (MSG_BROADCAST, spot_z);
};

void(vector spot, float rgb, float add) Tent_Explosion2 = { // [FUNCTION]
    WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
    WriteByte (MSG_BROADCAST, 12);      // TE_EXPLOSION2
    WriteCoord (MSG_BROADCAST, spot_x);
    WriteCoord (MSG_BROADCAST, spot_y);
    WriteCoord (MSG_BROADCAST, spot_z);
    WriteByte (MSG_BROADCAST, rgb);     // First index to use on the palette.
    WriteByte (MSG_BROADCAST, add);     // Range is from rgb to rgb+add-1.
};

void(vector spot) R_Exp3 = { // [FUNCTION]
    local entity e;

    e = spawn();
    setorigin(e, spot);
    sound(e,CHAN_AUTO, "weapons/r_exp3.wav", 1, ATTN_NORM);
	entity_remove(e,3); // Kind of the point to delay removal before playing the sound
};

void(vector spot) R_ExpSmall = { // [FUNCTION]
    local   entity  e;

    e = spawn();
    setorigin (e, spot);
    sound (e, CHAN_AUTO, "kinn/shuffler/expsmall.wav", 1, ATTN_NORM);
	entity_remove(e,3); // Kind of the point to delay removal before playing the sound
};

void(vector spot, float rgb, float add) Rocket_Explosion2 = { R_Exp3 (spot); Tent_Explosion2 (spot, rgb, add); }; // [FUNCTION]

void(vector spot) Rocket_TarExplosion = { // [FUNCTION]
    R_Exp3 (spot);
	Tent_Point(TE_TAREXPLOSION,spot);
};

void() Old_Explosion1 = {R_Exp3(self.origin); Tent_Explosion(self.origin); BecomeExplosion();}; // [FUNCTION]

//  Common Explosions
//float   CX_ORANGE   = 0;
//float   CX_RED      = 1;
//float   CX_YELLOW   = 2;
//float   CX_BLUE     = 3;
//float   CX_PURPLE   = 4;
void(vector spot, float r) Colored_Explosion = { // [FUNCTION]
    local float base, add;

    if (r == 3) { base = 244; add = 3; }
    else if (r == 2) { base = 240; add = 4; }
    else if (r == 1) { base = 247; add = 5; }
    else {
        r = random() * 3;
        if (r < 1) { base = 224; add = 16; }
        else if (r < 2) { base = 230; add = 8; }
        else { base = 232; add = 8; }
    }
    Rocket_Explosion2 (spot, base, add);
};

void(float base, float add, string text) BecomeAnyExplosionSetup = { // [FUNCTION]
	if (!add) add = 6; // Assume standard duration of six frames.
    self.movetype   = MOVETYPE_NONE;
    self.velocity   = '0 0 0';
    self.touch      = SUB_Null;
    setmodel (self, text);
    self.solid      = SOLID_NOT;
    self.frame      = base;
    self.cnt        = base + add - 1;
	self.nextthink  = time + self.wait;
    self.think      = s_explode_think;
};

// As 'BecomeAnyExplosion', with adjustable frames per second.  Used by some custom explosions.
void(float base, float add, float fps, string text) BecomeFpsExplosion = { // [FUNCTION]
    if (!fps) fps = 10;
    self.wait = 1 / fps;
	BecomeAnyExplosionSetup(base,add,text);
};

void(float base, float add, string text) BecomeAnyExplosion = { BecomeFpsExplosion(base,add,10,text); }; // [FUNCTION]

void(vector spot, float base, float add, string text) MakeAnyExplosion = { // [FUNCTION]
    local entity swap;

    swap = self;
    self = spawn();
    setsize (self, '0 0 0', '0 0 0');        
    setorigin (self, spot);
    BecomeAnyExplosion (base, add, text);
    self = swap;
};

void(float base, float add) BecomeFancy = {BecomeAnyExplosion (base, add, "progs/drake/s_fancy.spr");}; // [FUNCTION]

void(vector spot, float base, float add) MakeFancy = {MakeAnyExplosion (spot, base, add, "progs/drake/s_fancy.spr");}; // [FUNCTION]

//  Ice Explosions.  frames 0-2 = iceballs, frames 3-7 = explosion of shards.
void() BecomeIcyExp = { // [FUNCTION]
    self.skin = 0;
    BecomeAnyExplosion (3, 5, "progs/drake/iceball.mdl");
    self.alpha = ALPHA_ICE;
};

void(vector spot) MakeIcyExp = { // [FUNCTION]
    local entity iced;

    iced = spawn();
    iced.movetype   = MOVETYPE_NONE;
    iced.velocity   = '0 0 0';
    iced.touch      = SUB_Null;
    iced.solid      = SOLID_NOT;
    iced.alpha      = ALPHA_ICE;
    iced.frame      = 3;
    iced.cnt        = iced.frame + 4;    // 5 - 1
    iced.wait       = 0.1;
    iced.nextthink  = time + 0.1;
    iced.think      = s_explode_think;
    setall (iced, "progs/drake/iceball.mdl", '0 0 0', '0 0 0', spot);
};

void(vector spot, float base, float add, string text, float toponly) ShockWave = { // [FUNCTION]
    local entity wav1, wav2, ts;
    local vector ang;

	// NOTE:  Don't use world in the 4th (ignore) parm or else the traceline
	// will pass through any non-world bsp entites, such as shootable
	// trap doors.  Use self instead, which should be an inflictor entity.
    traceline (spot, spot - '0 0 64', TRUE, self);
    if (trace_fraction >= 1.0) return; // Too far from ground.
    if (!toponly && (trace_plane_normal * '0 0 1') < 0.5) return; // Ground slopes too much.  Was 0.7071.

    spot = trace_endpos + trace_plane_normal * 2;
    ang = vectoangles(trace_plane_normal);
    ang_y = anglemod(ang_y + 180);
    wav1 = spawn(); // Top side.
    wav1.angles = ang;
    setorigin (wav1, spot);
	
	if (!toponly) { // Bottom side.
		ang_x = anglemod(ang_x + 180);
		wav2 = spawn();
		wav2.angles = ang;
		setorigin (wav2, spot);
	}
	
    ts = self; // Thinking
    self = wav1;
    BecomeAnyExplosion (base, add, text);
	if (!toponly) { self = wav2; BecomeAnyExplosion (base, add, text); }
    self = ts;
};

// Explode self into ice chunks.
void() Shattered = { // [FUNCTION]
    sound (self, CHAN_VOICE, "drake/weapons/shatter.wav", 1, ATTN_NORM);
    MakeIcyExp (self.origin); 
	self.gibbed = TRUE;
	self.think = SUB_Null;
	self.gibpartstyle = PARTICLE_BURST_BLUE;
	self.gibtype = GIBTYPE_ICE;
	particle (self.origin, crandom() * 100 * '1 1 1', 41 + rint(random()*7), 20);
	particle (self.origin, crandom() * 100 * '1 1 1', 9 + rint(random()*7), 20);
	particle (self.origin, crandom() * 100 * '1 1 1', 41 + rint(random()*7), 20);
	particle (self.origin, crandom() * 100 * '1 1 1', 9 + rint(random()*7), 20);
	ThrowGib(GIBTYPE_ICE,rint(random() * (self.max_health / 10)));
	remove(self);
};

// Used by exploding barrels and MIRVs.  Yes, add 7 instead of 8.
void() FlameWave = { ShockWave(self.origin,RING_FIRE,7,"progs/drake/s_wave.spr",FALSE); }; // [FUNCTION]

// Modified Custents explosion, fast version; slow version was <7, 8, 10, 12, 14, 16, 18, 19, 20>.
void() s_explodeb1  =[  7,  s_explodeb2 ] {}; // [FUNCTION]
void() s_explodeb2  =[ 10,  s_explodeb3 ] {}; // [FUNCTION]
void() s_explodeb3  =[ 13,  s_explodeb4 ] {}; // [FUNCTION]
void() s_explodeb4  =[ 16,  s_explodeb5 ] {}; // [FUNCTION]
void() s_explodeb5  =[ 19,  s_explodeb6 ] {}; // [FUNCTION]
void() s_explodeb6  =[ 20,  SUB_Remove  ] {}; // [FUNCTION]

void() s_fiery1 =[  1, s_fiery2 ] {}; // [FUNCTION]
void() s_fiery2 =[  3, s_fiery3 ] {}; // [FUNCTION]
void() s_fiery3 =[  5, s_fiery4 ] {}; // [FUNCTION]
void() s_fiery4 =[  7, s_fiery5 ] {}; // [FUNCTION]
void() s_fiery5 =[  9, s_fiery6 ] {}; // [FUNCTION]
void() s_fiery6 =[ 11, s_fiery7 ] {}; // [FUNCTION]
void() s_fiery7 =[ 13, s_fiery8 ] {}; // [FUNCTION]
void() s_fiery8 =[ 15, SUB_Remove]{}; // [FUNCTION]

void(string fx, void() thinkst) Explosion_Start = { // [FUNCTION]
    self.movetype   = MOVETYPE_NONE;
    self.velocity   = '0 0 0';
    self.touch      = SUB_Null;
    setmodel (self, fx);
    self.solid      = SOLID_NOT;
    thinkst ();
};

void() BecomeTheBigFire = { // [FUNCTION]
    if (deathmatch || coop)	Explosion_Start ("progs/quoth/bigexp.spr", s_fiery1);
    else					BecomeFpsExplosion (0, 17, 20, "progs/quoth/bigexp.spr");
};

void() BecomeExplosion2 = { // [FUNCTION]
    if (deathmatch || coop)	Explosion_Start ("progs/drake/s_explod.spr", s_explodeb1);
    else					BecomeFpsExplosion (6, 16, 25, "progs/drake/s_explod.spr");
};

// This creates a small particle trail behind the shot.
void(float rgb, float density, float full) Meteor_Trail = { // [FUNCTION]
    Particle_Beam (self.oldorigin, self.origin, rgb, rgb, density, full);
    self.oldorigin = self.origin;   // Update previous point.
};

// 'waitmin' = slow color, 'waitmax' = fast color.
void(entity shot, float rgb) Laser_Color = { // [FUNCTION]
    shot.skin = rgb;
    if (rgb == 3) {shot.waitmin = 9;  shot.waitmax = 41;} // Blue
    else if (rgb == 2) {shot.waitmin = 105;  shot.waitmax = 193;} // Yellow
    else if (rgb == 1) {shot.waitmin = 73;  shot.waitmax = 225;} // Red
    else {shot.skin = 0;  shot.waitmin = 97;  shot.waitmax = 233;} // Orange.  Replaced 225 with 97 to stop blood in some ports.
};

// Like BecomeExplosion, but for Nemesants.  Some drake bosses use this for their post-mortem explosions.
void() WarpExplosion = { // [FUNCTION]
    sound (self, CHAN_AUTO, "zerstorer/trog/bigboom.wav", 1, ATTN_NORM);
    Tent_Point (TE_EXPLOSION, self.origin);
    FlameWave ();       // PM:  New shockwave effect at ground zero.
    BecomeTheBigFire ();    // Replaced old fireball mdl with big sprite.
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

// Used by lightning code to draw reflected lightning bolts.
void() InitLightning = { // [FUNCTION]
    lightning = spawn();
    setsize (lightning, VEC_ORIGIN, VEC_ORIGIN);
    lightning.solid      = SOLID_NOT;
    lightning.movetype   = MOVETYPE_NONE;
    lightning.classname  = "lightning";
	dprint("\b[SETUP]\b Drake lightning is now setup\n");
};

void(entity targ, entity inflictor, entity attacker, vector org, float damage) BoltDamage = { // [FUNCTION]
	if (ai_immunebreakable(attacker, targ)) { // This is resist lightning function without pain sound
		if (inflictor.lightning_timer < time) {
			inflictor.lightning_timer = time + 0.3; // Don't spawn smoke constantly (let the sprite finish)
			SpawnExplosion(EXPLODE_BURST_SMOKE, org, "");
		}
		SpawnProjectileSmoke(org, 200, 50, 150);
	} else {
		if (targ.resist_cells > 0) Resist_Effects(targ,org,VEC_ORIGIN,0,AM_CELLS,targ.pain_sound,"");
		else SpawnBlood(targ, org, '0 0 100', damage*4);
	}
    T_Damage (targ, inflictor, attacker, damage, DAMARMOR);
};

//  This strikes all entities hit by the lightning bolt.
// The old lightning code spawned two more invisible beams at weird places
// that could damage and kill more enemies (or teammates).  The new code
// below creates a single piercing bolt that hits everything in its path,
// like the railgun.  Lightning in many games (e.g., D&D, Diablo) pierce.
void(vector p1, vector p2, entity attacker, float damage, entity inflictor, float fx) LightningBolt = { // [FUNCTION]
    local entity ruler, ignore, targ;
    local vector start, dir;
    local float dist, delta, yes, first;

    first = yes = TRUE;
    ruler = inflictor;
    dir = p2 - p1;
    delta = vlen(dir);  // Get total length in case of reflection.
    dir = normalize(dir);
    while (ruler) {
        ignore = inflictor = ruler;
        ruler = world;      // End loop unless set otherwise by reflection.
        start = p1;
        do {
            traceline (p1, p2, FALSE, ignore);
            p1 = trace_endpos;
            targ = trace_ent;

            if (targ.solid != SOLID_BSP)
                ignore = targ;
            else
                ignore = world;

			// Dirty hack to prevent suicide.
            if (targ != inflictor) {
                if (HasReflection (targ, p1, damage)) {
                    if (yes) {
                       yes = FALSE;
                       ruler = targ;
                       delta = delta - vlen(p1 - start);   // Get remaining dist.
                       dir = normalize(p1 - targ.origin);
                        // p2 = p1 + dir*delta;
                    } else inflictor = lightning; // ...we give up.
 
                    ignore = world;     // Stop bolt.
                    ReflectSound (targ);
                } else {
                    if (first && targ.takedamage) BoltDamage(targ,inflictor,attacker,p1,damage);
                }
            }

        // If current trace hits inflictor/attacker, next trace will miss all.
        // Move the new start point ahead slightly to prevent attacker from
        // hitting himself and preventing the bolt from piercing anymore.
        // (Note:  If attacker is inside the monster because of noclip,
        // he can still hit himself.)
            if (ignore) { // Always world if 'p2 == trace_endpos'.
                dist = vlen(p2 - p1);
                if (dist > 1)	p1 = p1 + dir;
                else			ignore = world;   // Not enough distance left, so just stop.
            }
        } while (ignore); // end do{}while

		QC_ParseBeam(fx,string_null, inflictor, start, p1, 32); // Draw the lightning bolt between the two points.
    }
};

//  Smart Fireballs -- Used by nemesant (and SoE sorcerer).
void() SmartBall_Think = { // [FUNCTION]
    if (self.delay <= time) {remove(self); return;}

    self.angles = vectoangles(self.velocity);
	// Changed particle count from 25 at 10/sec to 10 at 20/sec.  2000 speed rocket trails spawn 11 at about 50/sec.
    particle (self.origin, '0 0 1', 233, 10);   //particle (self.origin, '0 0 1', 233, 25);
    self.nextthink = time + 0.05;               //self.nextthink = time + 0.1;
};

void() SmartBall_Bounce = { // [FUNCTION]
    local   vector  p1, p2;
    local   float   up;

    p1 = self.origin;
    p2 = self.enemy.origin + self.enemy.view_ofs;   // Go for the eyes.
    up = Aim_TossUp (p1, p2, 400);
    self.flags = self.flags - (self.flags & FL_ONGROUND); 
    self.velocity = Maim_SmartBall (p1, p2, 400, up, world, '0 0 0'); // Fireballs can be fooled by invisibility.
    self.velocity = self.velocity * 400;
    self.velocity_z = self.velocity_z + up;
    self.angles = vectoangles(self.velocity);
    self.nextthink = time + 0.01;
    self.think = SmartBall_Think;
};

void() SmartBall_Touch = { // [FUNCTION]
    if (pointcontents(self.origin) == CONTENT_SKY) {remove(self); return;}     // Disappeared into space.
    if (Reflected_Damage (COURAGE_DAMAGE)) return;     // Bounced off reflective shield.
    if (other.takedamage || (self.count >= 3) || (self.enemy.health <= 0)) { Touch_Missile(); return; } // Go BOOM!

    sound (self, CHAN_WEAPON, "zerstorer/trog/frblfly.wav", 0.6, ATTN_NORM);
    self.count = self.count + 1;
    self.think = SmartBall_Bounce;
    self.nextthink = time + 0.01;
};

void(vector start, vector dir, vector add) SmartBall_Launch = { // [FUNCTION]
    newmis = spawn ();
    newmis.master = newmis.owner = self;
    newmis.movetype     = MOVETYPE_TOSS;
    newmis.solid        = SOLID_BBOX;
	newmis.classgroup = CG_PROJROCKETS;
    newmis.classname    = "fireball";
    newmis.speed        = 600;
    newmis.velocity     = (dir * 600) + add;
    newmis.angles       = vectoangles(newmis.velocity);
    newmis.dmg          = 40;
    newmis.enemy        = self.enemy;
    newmis.count        = 0;
    newmis.touch        = SmartBall_Touch;
    newmis.delay        = time + 20;    // Total duration
    newmis.nextthink    = time + 0.1;
    newmis.think        = SmartBall_Think;
	newmis.classtype 	= CT_PROJ_SMARTBALL;
    setall (newmis, "progs/drake/smartbal.mdl", '0 0 0', '0 0 0', start);
};

void(vector st) M_FireSmart = { // [FUNCTION]
    local vector p1, p2, dir, up;
    local entity targ;

    targ = world;
    makevectors (self.angles);
    p1 = self.origin + (v_forward*st_x) + (v_right*st_y) + (v_up*st_z);
    p2 = Aimpoint (self.enemy);
    up = '0 0 0';
    up_z = Aim_TossUp (p1, p2, 600);
    dir = Maim_SmartBall (p1, p2, 600, up_z, targ, '0 0 0');
    if (!targ) { // In case we can't hit enemy, just lob it straight ahead.
		TraceBallistic (p1,up + (dir*600),FALSE,self,5,p1,MOVETYPE_TOSS);
        if (trace_ent != self.enemy) up_z = 200;
    }
    self.effects = self.effects | EF_MUZZLEFLASH;
    sound (self, CHAN_AUTO, "zerstorer/trog/frblfly.wav", 0.6, ATTN_NORM);
    SmartBall_Launch (p1, dir, up);
};

void() death_puff = { // [FUNCTION]
    local vector spot;
    local entity puff;

    spot_x = random();
    spot_y = random();
    spot_z = random() * 0.5;
    spot = Anypoint(self,spot);
    puff = spawn();
    setorigin (puff, spot);
    puff.effects = EF_MUZZLEFLASH;
    sound (puff, CHAN_AUTO, "hknight/hit.wav", 1, ATTN_NORM);
    SUB_ThinkImmediate(puff,BecomeExplosion);
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
	self.alpha = 0.0001;
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

void () env_sprite_on = { // [FUNCTION]
	self.state = S_ACTIVE;
	self.alpha = self.pos1_y;
	self.think = env_sprite_loop;
	self.nextthink = time + self.impulse;
};

void () env_sprite_off = { // [FUNCTION]
		self.alpha = S_ALPHANULL;
		self.spritestarted = FALSE;
		self.state = S_DEACTIVE;
};

void () env_sprite_use = { // [FUNCTION]
	if (self.state == S_ACTIVE) {
		env_sprite_off();
	} else {
		env_sprite_on();
	}
};

void () env_sprite_reset = { // [FUNCTION]
	self.frame = self.pos1_x;
};

void () env_sprite = { // [ENTITY]
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

void () info_sprite_static = { // [ENTITY]
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

void () raincloud_think = { // [FUNCTION]
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

void () raincloud_use = { // [FUNCTION]
	self.think = raincloud_think;
	self.nextthink = time + self.delay;
};

// Spawns a storm cloud that moves about randomly at the same height.
void () spawn_raincloud = { // [FUNCTION]
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

void () misc_raincloud = { // [ENTITY]
	// Pick type of drip sprite based on spawnflags
	if (self.spawnflags & 16) {
		if (self.spawnflags & 8) {
			self.path = "progs/s_dripred_lg.spr";
		} else {
			self.path = SBLOOD_DRIP;
		}

		self.headmdl = SBLOOD_SPLASH;
		self.aflag = 64;
	} else if (self.spawnflags & 32) {
		if (self.spawnflags & 8) {
			self.path = "progs/s_dripgreen_lg.spr";
		} else {
			self.path = SSLIME_DRIP;
		}

		self.headmdl = SSLIME_SPLASH;
		self.aflag = 48;
	} else {
		if (self.spawnflags & 8) {
			self.path = "progs/s_dripblue_lg.spr";
		} else {
			self.path = SWATER_DRIP;
		}

		self.headmdl = SWATER_SPLASH;
		self.aflag = 0;
	}
	precache_model (self.path);
	precache_model (self.headmdl);
	if (!self.noise1) self.noise1 = "rrp/misc/drip1.wav";
	if (!self.noise2) self.noise2 = "rrp/misc/drip2.wav";
	if (!self.noise3) self.noise3 = "rrp/misc/drip3.wav";
	precache_sound (self.noise1);
	precache_sound (self.noise2);
	precache_sound (self.noise3);
	precache_model("progs/qmaster/astorm.spr");
	if (!self.delay && (self.targetname == "")) self.delay = (random() * 5); // random spawn time to not all storm the same
	spawn_raincloud();
};

void() skyl_stand1	=[  0,	skyl_stand2  ]{self.effects = EF_BRIGHTLIGHT;}; // [FUNCTION]
void() skyl_stand2	=[  1,	skyl_stand3  ]{}; // [FUNCTION]
void() skyl_stand3	=[  2,	skyl_stand4  ]{self.effects = 0;}; // [FUNCTION]
void() skyl_stand4	=[  3,	skyl_stand5  ]{self.effects = EF_BRIGHTLIGHT;}; // [FUNCTION]
void() skyl_stand5	=[  4,	skyl_stand6  ]{}; // [FUNCTION]
void() skyl_stand6	=[  5,	skyl_stand7  ]{}; // [FUNCTION]
void() skyl_stand7	=[  6,	skyl_stand8  ]{if (!(self.spawnflags & 2)) { sound (world, CHAN_AUTO, "drake/bane/thunder.wav", 1, ATTN_NONE); } }; // [FUNCTION]
void() skyl_stand8	=[  7,	skyl_stand1  ]{self.effects = 0; self.nextthink = time + self.wait + (random() * self.waitmax);}; //time  lightning appears time + your time, [FUNCTION]

void() model_skylight = { // [ENTITY]
	precache_model ("progs/madfox/skylight.spr");
	self.solid = SOLID_BBOX;                               
	self.movetype = MOVETYPE_NONE;
	self.classname = "env_lightning";
	setmodel (self, "progs/madfox/skylight.spr");
	precache_sound ("drake/bane/thunder.wav");
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
	x = random() * FL_NOTARGET - FL_GODMODE;
	y = random() * FL_NOTARGET - FL_GODMODE;
	z = random() * FL_NOTARGET - FL_GODMODE;
	newo_x = self.origin_x + x;
	newo_y = self.origin_y + y;
	newo_z = self.origin_z + z;
	Tent_Point(TE_EXPLOSION,newo);
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

void () shambler_walking_quake = { // [FUNCTION]
	local entity enFind;
	
	enFind = findradius(self.origin, 444);		
	while(enFind) { 
		if(enFind.flags & FL_ONGROUND) { 
			if (enFind.flags & FL_CLIENT) {
				if (cvar("sv_gravity") > 600 && enFind.gravity) {
					enFind.velocity_x = enFind.velocity_x + (crandom() * 30);  
					enFind.velocity_y = enFind.velocity_y + (crandom() * 30); 
					enFind.velocity_z = enFind.velocity_z + (crandom() * 75); 
				} 
			   	enFind.punchangle = enFind.punchangle + (randomvec() * 0.6);  // Apply Punchangle
			}
		}
		enFind = enFind.chain;
	}
};

void() screenshake = { // [FUNCTION]
	local entity plyr;
	local float	d;

	if (self.attack_finished < time) return; // Is the shaking over?
	
	plyr = findradius(self.origin, 1300); // Create a list of entities to check for players
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
		plyr = plyr.chain; // Find next entity in chain.
	}
	self.nextthink = time + 0.1;
	self.think = screenshake; // keep on shaking!  shake a little faster!  shake a little slower!  good thing we got our shaking clothes
};

// idea taken from kleshik
void (float fPunchStrength, float fRadius) Monster_Animation_EarthQuake = { // [FUNCTION]
	local entity enFind;

	if(self.flags & FL_ONGROUND) { 
		enFind = findradius(self.origin, fRadius);	
		while(enFind) { 
			if(enFind.flags & FL_ONGROUND && enFind != self) { 
				if (enFind.flags & FL_MONSTER || enFind.flags & FL_CLIENT) {
					enFind.velocity_x = enFind.velocity_x + (crandom() * fPunchStrength * 5);  
					enFind.velocity_y = enFind.velocity_y + (crandom() * fPunchStrength * 5); 
					enFind.velocity_z = enFind.velocity_z + (fPunchStrength * 10) + (crandom() * 40);  
				}
				if (enFind.flags & FL_CLIENT) enFind.punchangle = enFind.punchangle + (randomvec() * (0.7 * fPunchStrength));  // Apply Punchangle
			}
			enFind = enFind.chain;
		}
	}
};
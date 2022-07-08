//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
//
// Attributions: Rubicon
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
// Entity count: 2
// Function count: 54
//
// Implements: Turret Traps
//
// Description:
// Stationary turrets that can spin in place to target the player with limited
// up/down angle tracking.
//=============================================================================

$cd apoc/progs/turret
$origin 0 0 10
$base base		
$skin base
$frame tilt0 tilt6 tilt12 tilt18
$frame tilt24 tilt30 tilt36 tilt42
$frame tilt48 tilt54 tilt60 tilt66
$frame tilt72 tilt78 tilt84 tilt90
$frame retract1 retract2 retract3 retract4 retract5 retract6 retract7

void() turret_active;
void() turret_ret2;

// Returns the appropriate frame for the passed pitch
float(float pitch) turret_frame= { return floor(pitch/5.625); }; // [FUNCTION]

// returns the appropriate frame for while firing
float(float pitch) turret_fireframe= { return (turret_frame(pitch) + 23); }; // [FUNCTION]

void() turret_face = { // [FUNCTION]
	local vector tmpvec;

	tmpvec = vectoangles(self.origin - (self.enemy.origin + self.enemy.view_ofs));
	if (tmpvec_x > self.rotate_type) {
		if (tmpvec_x > (self.rotate_type + 6)) self.rotate_type = self.rotate_type + 6;
		else self.rotate_type = tmpvec_x;
	} else if (tmpvec_x < self.rotate_type) {
		if (tmpvec_x < (self.rotate_type - 6)) self.rotate_type = self.rotate_type - 6;
		else self.rotate_type = tmpvec_x;
	}

	self.frame = turret_frame(self.rotate_type);
	ai_face();
};

void() turret_still =	[$tilt0, turret_still] { self.frame = turret_frame(self.rotate_type); FindTarget(); }; // [FUNCTION]

void() turret_ret1 =	[$retract1, turret_ret1] { if (self.frame >= 15) { turret_ret2(); return; } self.frame = self.frame + 1; self.nextthink = time + 0.05; }; // [FUNCTION]
void() turret_ret2 =	[$retract1, turret_ret3] { self.nextthink = time + 0.05; }; // [FUNCTION]
void() turret_ret3 =	[$retract2, turret_ret4] { self.nextthink = time + 0.05; }; // [FUNCTION]
void() turret_ret4 =	[$retract3, turret_ret5] { self.nextthink = time + 0.05; }; // [FUNCTION]
void() turret_ret5 =	[$retract4, turret_ret6] { self.solid = SOLID_NOT;self.nextthink = time + 0.05; }; // [FUNCTION]
void() turret_ret6 =	[$retract5, turret_ret7] { self.nextthink = time + 0.05; }; // [FUNCTION]
void() turret_ret7 =	[$retract6, turret_ret8] { self.nextthink = time + 0.05; }; // [FUNCTION]
void() turret_ret8 =	[$retract7, turret_retracted] { if (!self.currentammo) self.think = SUB_Null;self.nextthink = time + 0.05; }; // [FUNCTION]

void() turret_unret1 =	[$retract6, turret_unret2] { self.nextthink = time + 0.05; }; // [FUNCTION]
void() turret_unret2 =	[$retract5, turret_unret3] { self.nextthink = time + 0.05; }; // [FUNCTION]
void() turret_unret3 =	[$retract4, turret_unret4] { self.nextthink = time + 0.05; }; // [FUNCTION]
void() turret_unret4 =	[$retract3, turret_unret5] { self.solid = SOLID_SLIDEBOX; setmodel (self, "progs/custents/turret.mdl"); self.nextthink = time + 0.05; }; // [FUNCTION]
void() turret_unret5 =	[$retract2, turret_unret6] { self.nextthink = time + 0.05; }; // [FUNCTION]
void() turret_unret6 =	[$retract1, turret_unret7] { self.nextthink = time + 0.05; }; // [FUNCTION]
void() turret_unret7 =	[$tilt0, turret_unret7] { // [FUNCTION]
	if (self.frame > (turret_frame(self.rotate_type) + 1)) self.frame = self.frame - 2;
	else {
		self.frame = turret_frame(self.rotate_type);
		turret_active();
	}
};

void() turret_retracted =	[$retract7, turret_retracted] { if (FindTarget ()) turret_unret1(); }; // [FUNCTION]

void() turret_active =	[$tilt0, turret_active] { // [FUNCTION]
	enemy_infront = infront(self.enemy);
	enemy_range = range(self.enemy);
	enemy_yaw = vectoyaw(self.enemy.origin - self.origin);
	self.frame = turret_frame(self.rotate_type);

	// see if the enemy is dead
	if (self.enemy.health <= 0 || self.enemy.deadflag != 0) {
		self.enemy = world;
		// FIXME: look all around for other targets
		if (self.oldenemy.health > 0) {
			self.enemy = self.oldenemy;
			HuntTarget();
		} else {
			self.th_stand();
			return;
		}
	}
	self.show_hostile = time + 1;       // wake up other monsters

	// check knowledge of enemy
	enemy_vis = visible(self.enemy);
	if (enemy_vis) self.search_time = time + 5;

	// look for other coop players
	if ((coop && self.search_time < time) && (FindTarget())) return;
	if (self.attack_state == AS_MISSILE || self.attack_state == AS_MELEE) { ai_run_missile(); return; }
	CheckTurretAttack();
};

void() M_TurretFireBullets = {
	local vector dir, bullet_dir, spread_dir, bullet_spread;

	bullet_spread = SPREAD_SG2; // Sharpshooter!
	turret_face();
	self.frame = turret_fireframe(self.rotate_type);
	sound(self,CHAN_WEAPON,"custents/turret/plasbult.wav",1,ATTN_NORM);
	self.effects = self.effects | EF_MUZZLEFLASH;
	bullet_dir = self.enemy.origin - self.enemy.velocity*0.2;
	bullet_dir = normalize (dir - self.origin);
	spread_dir = bullet_dir + (crandom()*bullet_spread_x) * v_right + (crandom()*bullet_spread_y) * v_up;
	Launch_Bullet(self.origin, dir, CT_PROJ_SG, (crandom()*10 + (SPEED_MONSG + (skill*SPEED_MONSGMULT))));
	Launch_Bullet(self.origin, dir, CT_PROJ_SG, (crandom()*10 + (SPEED_MONSG + (skill*SPEED_MONSGMULT))));
	Launch_ShellCasing(1);
};

void() turret_bullet1 = [$tilt0, turret_bullet2] { M_TurretFireBullets(); }; // [FUNCTION]
void() turret_bullet2 = [$tilt0, turret_bullet3] { turret_face(); self.nextthink = time + 0.05; }; // [FUNCTION]
void() turret_bullet3 = [$tilt0, turret_bullet4] { M_TurretFireBullets(); }; // [FUNCTION]
void() turret_bullet4 = [$tilt0, turret_bullet5] { turret_face(); self.nextthink = time + 0.05; }; // [FUNCTION]
void() turret_bullet5 = [$tilt0, turret_active] { M_TurretFireBullets(); }; // [FUNCTION]

void() turret_laser1 = [$tilt0, turret_laser2] { // [FUNCTION]
	local vector dir, vel;
	
	turret_face();
	self.frame = turret_fireframe(self.rotate_type);
	sound (self, CHAN_WEAPON, "enforcer/enfire.wav", 1, ATTN_NORM);
	self.effects = self.effects | EF_MUZZLEFLASH;
	vel = normalize(self.enemy.origin - self.origin);
	vel = vel * SPEED_LASER;
	dir = vectoangles(vel);
	launch_projectile (self.origin,dir,NO_SPIN,CT_PROJ_LASER,SPEED_LASER);
};
void() turret_laser2 = [$tilt0, turret_laser3] { turret_face(); }; // [FUNCTION]
void() turret_laser3 = [$tilt0, turret_laser4] { turret_face(); }; // [FUNCTION]
void() turret_laser4 = [$tilt0, turret_laser5] { turret_face(); }; // [FUNCTION]
void() turret_laser5 = [$tilt0, turret_active] { // [FUNCTION]
	local vector dir, vel;
	
	turret_face();
	self.frame = turret_fireframe(self.rotate_type);
	sound (self, CHAN_WEAPON, "enforcer/enfire.wav", 1, ATTN_NORM);
	self.effects = self.effects | EF_MUZZLEFLASH;
	vel = normalize(self.enemy.origin - self.origin);
	vel = vel * SPEED_LASER;
	dir = vectoangles(vel);
	launch_projectile (self.origin,dir,NO_SPIN,CT_PROJ_LASER,SPEED_LASER);
};

void() turret_rocket1 = [$tilt0, turret_active] { // [FUNCTION]
	local vector dir, vel;
	
	turret_face();
	self.frame = turret_fireframe(self.rotate_type);
	sound (self, CHAN_WEAPON, "weapons/sgun1.wav", 1, ATTN_NORM);
	self.effects = self.effects | EF_MUZZLEFLASH;
	vel = normalize(self.enemy.origin - self.origin);
	vel = vel * SPEED_LASER;
	dir = vectoangles(vel);
	launch_projectile(self.origin,dir,self.avelocity,CT_PROJ_ARMY,SPEED_RLPLAYER);
};

void() turret_beam1 = [$tilt0, turret_beam2] { turret_face(); sound (self, CHAN_WEAPON, "custents/turret/beamchrg.wav", 1, ATTN_NORM); self.nextthink = time + 0.2; }; // [FUNCTION]
void() turret_beam2 = [$tilt0, turret_beam3] { turret_face(); sound (self, CHAN_WEAPON, "custents/turret/beamchrg.wav", 1, ATTN_NORM); self.nextthink = time + 0.2; }; // [FUNCTION]
void() turret_beam3 = [$tilt0, turret_beam4] { turret_face(); sound (self, CHAN_WEAPON, "custents/turret/beamchrg.wav", 1, ATTN_NORM); self.nextthink = time + 0.2; }; // [FUNCTION]
void() turret_beam4 = [$tilt0, turret_beam5] { // [FUNCTION]
	turret_face();
	self.frame = turret_fireframe(self.rotate_type);

	// explode if under water
	if (self.waterlevel > 1) {
		beam_water_burst(20);
		return;
	}
	newmis = spawn();
	newmis.solid = SOLID_NOT;
	newmis.movetype = MOVETYPE_FLY;
	newmis.currentammo = 10;
	setorigin(newmis, self.origin);
	newmis.owner = self;
	newmis.think = beam_generate;
	newmis.nextthink = time + 0.05;
};
void() turret_beam5 = [$tilt0, turret_beam6] { turret_face(); }; // [FUNCTION]
void() turret_beam6 = [$tilt0, turret_beam7] { turret_face(); }; // [FUNCTION]
void() turret_beam7 = [$tilt0, turret_active] { turret_face(); }; // [FUNCTION]

void() turret_fire2;
void() turret_fire1 =	[$tilt0, turret_fire2] { turret_face(); if (infront(self.enemy)) self.think = turret_fire2; self.nextthink = time + 0.05; }; // [FUNCTION]
void() turret_fire2 =	[$tilt0, turret_fire3] { turret_face(); self.nextthink = time + 0.05; }; // [FUNCTION]
void() turret_fire3 =	[$tilt0, turret_fire4] { turret_face(); self.nextthink = time + 0.05; }; // [FUNCTION]
void() turret_fire4 =	[$tilt0, turret_fire4] { // [FUNCTION]
	turret_face();
	if (self.spawnflags & TUR_LASERS) turret_laser1();
	else if (self.spawnflags & TUR_ROCKETS) turret_rocket1();
	else if (self.spawnflags & TUR_PPC) turret_beam1();
	else turret_bullet1();
};

void(entity inflictor, entity attacker, float damage)	turret_pain = { // [FUNCTION]
	if (self.pain_finished > time) return;
	self.pain_finished = time + 1;
	sound (self, CHAN_VOICE, "custents/turret/beamchrg.wav", 1, ATTN_NORM);
	ThrowGib(11, 1);
};

void() turret_die= { // [FUNCTION]
	self.use = SUB_Null;
	Tent_Explosion(self.origin);
	newmis = spawn();
	newmis.solid = SOLID_NOT;
	newmis.movetype = MOVETYPE_NONE;
	newmis.angles = self.angles;
	setorigin(newmis, self.origin);
	setmodel(newmis, "progs/custents/dedturet.mdl");
	setsize(self, '-10 -10 -3', '10 10 12');
	newmis.skin = self.skin;
	ThrowGib(25,1); // headmdl
	ThrowGib(11,4);
};

void() turret_use= { // [FUNCTION]
	if (self.currentammo) {
		self.currentammo = FALSE;
		if ((self.spawnflags & TUR_RETRACT) || (self.spawnflags & TUR_OFFRET))
			turret_ret1();
		else
			self.think = SUB_Null;
	} else {
		self.currentammo = TRUE;
		if ((self.spawnflags & TUR_RETRACT) || (self.spawnflags & TUR_OFFRET))
			turret_unret1();
		else
			turret_still();
	}
};

void() turret_setup= { // [FUNCTION]
	local vector endorg;

	traceline(self.origin, self.origin + '0 0 2000', TRUE, self);
	endorg = trace_endpos;
	endorg_z = endorg_z - 12;
	setorigin(self, endorg);
	self.nextthink = time + random()*0.5;
	// decide how to start according to the spawnflags
	if (self.spawnflags & TUR_STARTOFF){
		if ((self.spawnflags & TUR_RETRACT) || (self.spawnflags & TUR_OFFRET)) {
			self.frame = $retract7;
			self.solid = SOLID_NOT;
		} else
			self.frame = turret_frame(self.rotate_type);

		self.currentammo = FALSE;
		self.think = SUB_Null;
	} else {
		if (self.spawnflags & TUR_RETRACT) {
			self.solid = SOLID_NOT;
			turret_retracted();
		} else self.think = turret_still;
	}
};

void() trap_turret= { // [ENTITY]
	self.mdl = "progs/custents/turret.mdl";
	self.headmdl = "progs/custents/h_turret.mdl";
	self.gib1mdl = "progs/custents/turetgib.mdl";
	precache_model ("progs/custents/turret.mdl");
	precache_model ("progs/custents/h_turret.mdl");
	precache_model ("progs/custents/dedturet.mdl");
	precache_model ("progs/custents/turetgib.mdl");
	precache_sound ("custents/turret/beamchrg.wav");
	precache_sound ("custents/turret/beammode.wav");
	precache_model ("progs/laser.mdl");
	precache_sound ("enforcer/enfire.wav");
	precache_sound (SOUND_LASER_HIT);
	precache_model ("progs/missile.mdl");
	precache_model ("progs/custents/beam.mdl");
	precache_sound ("custents/turret/beamhit.wav");
	precache_sound ("hipnotic/weapons/mjolhit.wav");
	precache_sound ("custents/turret/plasbult.wav");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel (self, self.mdl);
	setsize (self, '-12 -12 -6', '12 12 12');
	if (self.health < 1) self.health = 100;
	self.max_health = self.health;
	if (self.rotate_type < 0 || self.rotate_type > 90) self.rotate_type = 0;
	self.currentammo = TRUE;
	if (self.spawnflags & TUR_RETRACT) {
		self.th_stand = turret_ret1;
		self.th_walk = turret_ret1;
	} else {
		self.th_stand = turret_still;
		self.th_walk = turret_still;
	}

	self.th_run = turret_active;
	self.th_pain = turret_pain;
	self.th_die = turret_die;
	self.th_missile = turret_fire1;
	self.takedamage = DAMAGE_AIM;
	self.ideal_yaw = self.angles * '0 1 0';
	self.yaw_speed = 30;
	self.view_ofs = '0 0 -0.1';
	self.use = turret_use;
	self.flags = self.flags | FL_FLY;
	self.pausetime = 99999999;
	self.nextthink = self.nextthink + random()*0.5;
	self.think = turret_setup;
};

void() turret_shoot = { // [FUNCTION]
	local vector ang;

	self.effects = self.effects | EF_MUZZLEFLASH;
	sound (self, CHAN_VOICE, "enforcer/enfire.wav", 1, ATTN_NORM);
	ang = vectoangles(self.enemy.origin - self.origin); //calculate pitch based on the enemy's position, but clamp it to a narrow range
	if (ang_x > 180) ang_x = ang_x - 360;	
	if (ang_x > TURRET_MAX_PITCH) ang_x = TURRET_MAX_PITCH;
	if (ang_x < TURRET_MIN_PITCH) ang_x = TURRET_MIN_PITCH;
	self.angles_x = 0 - ang_x; //invert it because for some reason +pitch is downwards for makevectors() but upwards for vectoangles()	
	makevectors(self.angles);
	launch_projectile(self.origin + ('0 0 1' * self.angles_x),v_forward,NO_SPIN,CT_PROJ_LASER,SPEED_LASER);
};

void() turret_helper_think = { // [FUNCTION]
	self.nextthink = time + 0.2;
	if ( self.owner.state != TURRET_STATE_ACTIVE) return;
	if (!FindTarget()) return; // Find enemy.

	self.yaw_speed = (50 + skill * 20) * 0.2;
	ai_face();
	turret_shoot(); //shoot if enemy is in sight (even if facing wrong way)
};

void() turret_hit_bottom = { sound (self, CHAN_VOICE, self.noise1, 1, ATTN_NORM); self.state = TURRET_STATE_INACTIVE; }; // [FUNCTION]

void() turret_go_down = { sound (self, CHAN_VOICE, self.noise2, 1, ATTN_NORM); self.state = TURRET_STATE_DEACTIVATING; SUB_CalcMove (self.pos1, self.speed, turret_hit_bottom); }; // [FUNCTION]

void() turret_hit_top = { sound (self, CHAN_VOICE, self.noise1, 1, ATTN_NORM); self.state = TURRET_STATE_ACTIVE; }; // [FUNCTION]

void() turret_go_up = { // [FUNCTION]
	sound (self, CHAN_VOICE, self.noise2, 1, ATTN_NORM);
	self.state = TURRET_STATE_ACTIVATING;
	SUB_CalcMove (self.pos2, self.speed, turret_hit_top);
};

void() turret_func_use = { // [FUNCTION]
	if (self.state == TURRET_STATE_INACTIVE || self.state == TURRET_STATE_DEACTIVATING) {
		self.frame = 0;
		turret_go_up();
		self.enemy = activator;
	} else if (self.state == TURRET_STATE_ACTIVATING || self.state == TURRET_STATE_ACTIVE) {
		self.frame = 1;
		
		//if deactivated after being previously active, use movedir2 to determine position
		self.pos1 = self.origin + self.movedir2;
		turret_go_down();
	}
};


// QUAKED func_turret (0 .5 .8) ? START_OFF
// A rotating laser shooter that aims at the player in any horizontal direction. Has a capped rotation speed based on skill setting. When triggered, toggles between active and inactive states
// START_OFF spawns in the inactive state
// place in the level in the active/attacking position for proper lighting.
// "movedir" 	the offset from active position to the initial START_OFF position 
// "movedir2"  the offset from the active position to the deactivated position (after being previously active)
// "height" 	the position that laser originates, measured up from the very bottom of the model
// "angle"		determines the initial turret direction (horizontal directions only)
// "speed"		speed when moving to a new position
// "sounds"	sounds to use when moving to a new position
// 0)	no sound
// 1)	stone
// 2)	base
// 3)	stone chain
// 4)	screechy metal
void() func_turret = { // [ENTITY]
	local entity helper;
	local vector org;

	if (self.sounds == 0) self.noise1 = self.noise2 = SOUND_EMPTY;
	if (self.sounds == 1) {
		precache_sound ("doors/drclos4.wav");
		precache_sound ("doors/doormv1.wav");
		self.noise1 = "doors/drclos4.wav";
		self.noise2 = "doors/doormv1.wav";
	} else if (self.sounds == 2) {
		precache_sound ("doors/hydro1.wav");
		precache_sound ("doors/hydro2.wav");
		self.noise2 = "doors/hydro1.wav";
		self.noise1 = "doors/hydro2.wav";
	} else if (self.sounds == 3) {
		precache_sound ("doors/stndr1.wav");
		precache_sound ("doors/stndr2.wav");
		self.noise2 = "doors/stndr1.wav";
		self.noise1 = "doors/stndr2.wav";
	} else if (self.sounds == 4) {
		precache_sound ("doors/ddoor1.wav");
		precache_sound ("doors/ddoor2.wav");
		self.noise1 = "doors/ddoor2.wav";
		self.noise2 = "doors/ddoor1.wav";
	}
	precache_model ("progs/laser.mdl");
	precache_sound (SOUND_LASER_FIRE);
	precache_sound (SOUND_LASER_HIT);
	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_PUSH;
	setorigin (self, self.origin);	
	setmodel (self, self.model);
	self.use = turret_func_use;
	if (!self.speed) self.speed = 100;
	self.pos1 = self.origin + self.movedir; //inactive position
	self.pos2 = self.origin; //active position
	
	//spawn a second entity to handle alpha changes, since MOVETYPE_PUSH doesn't support think functions
	helper = spawn();
	helper.owner = self;
	helper.nextthink = 0.1;
	helper.think = turret_helper_think;
	helper.classname = "turret";
	helper.angles = self.angles;
	org_x = (self.absmin_x + self.absmax_x) / 2;
	org_y = (self.absmin_y + self.absmax_y) / 2;
	org_z = self.absmin_z + self.height;
	setorigin (helper, org);
	self.angles = '0 0 0'; // Set actual angles to 0 now that helper has its angles

	//move to initial position
	if (self.spawnflags & TUR_STARTOFF) {
		self.state = TURRET_STATE_INACTIVE;
		setorigin (self, self.pos1);
		self.frame = 1;
	} else {
		self.state = TURRET_STATE_ACTIVE;
		setorigin (self, self.pos2);
		self.frame = 0;
	}

	// Testing using stuff from trap_turret to get this to work right
	if (self.health < 1) self.health = 100;
	self.max_health = self.health;
	if (self.rotate_type < 0 || self.rotate_type > 90) self.rotate_type = 0;
	self.currentammo = TRUE;

	if (self.spawnflags & TUR_RETRACT) {
		self.th_stand = turret_ret1;
		self.th_walk = turret_ret1;
	} else {
		self.th_stand = turret_still;
		self.th_walk = turret_still;
	}
	self.th_run = turret_active;
	self.th_pain = turret_pain;
	self.th_die = turret_die;
	self.th_missile = turret_fire1;
	self.takedamage = DAMAGE_AIM;
	self.ideal_yaw = self.angles * '0 1 0';
	self.yaw_speed = 30;
	self.view_ofs = '0 0 -0.1';
	self.use = turret_use;
	self.flags = self.flags | FL_FLY;
	self.pausetime = 99999999;
	self.nextthink = self.nextthink + random()*0.5;
	self.think = turret_setup;
};
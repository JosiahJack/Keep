//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by W. Josiah Jack, aka Qmaster
//
// Attributions: Carl Glave aka General Wart for Quake: The Apocalypse
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
// Entity count: 1
// Function count: 51
//
// Implements: Automated Gun Turret
//
// Description:
// A stationary gun turret that shoots passersby and can be retraced.
//=============================================================================

$cd apoc/progs/turret
$origin 0 0 10
$base base		
$skin base
$frame tilt0 tilt6 tilt12 tilt18 // The tilt according to the angle of that frame's gun tilt
$frame tilt24 tilt30 tilt36 tilt42
$frame tilt48 tilt54 tilt60 tilt66
$frame tilt72 tilt78 tilt84 tilt90
$frame retract1 retract2 retract3 retract4 retract5 retract6 retract7

void() turret_active;
void() turret_ret2;

// returns the appropriate frame for the passed pitch
float(float pitch) turret_frame = { return floor(pitch/5.625); }; // [FUNCTION]

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
	self.ideal_yaw = vectoyaw(SUB_orgEnemyTarget() - self.origin);
	ChangeYaw();
};



void() turret_still = [$tilt0, turret_still] { // [FUNCTION]
	self.frame = turret_frame(self.rotate_type);
	FindTarget();
};

void() turret_ret1 = [$retract1, turret_ret1] { // [FUNCTION]
	if (self.frame >= 15) {
		turret_ret2();
		return;
	}

	self.frame = self.frame + 1;
	self.nextthink = time + 0.05;
};
void() turret_ret2 =	[$retract1, turret_ret3] { self.nextthink = time + 0.05; }; // [FUNCTION]
void() turret_ret3 =	[$retract2, turret_ret4] { self.nextthink = time + 0.05; }; // [FUNCTION]
void() turret_ret4 =	[$retract3, turret_ret5] { self.nextthink = time + 0.05; }; // [FUNCTION]
void() turret_ret5 =	[$retract4, turret_ret6] { self.solid = SOLID_NOT; self.nextthink = time + 0.05; }; // [FUNCTION]
void() turret_ret6 =	[$retract5, turret_ret7] { self.nextthink = time + 0.05; }; // [FUNCTION]
void() turret_ret7 =	[$retract6, turret_ret8] { self.nextthink = time + 0.05; }; // [FUNCTION]
void() turret_ret8 =	[$retract7, turret_retracted]
{ if (!self.currentammo) self.think = SUB_Null; self.nextthink = time + 0.05; }; // [FUNCTION]

void() turret_unret1 =	[$retract6, turret_unret2] { self.nextthink = time + 0.05; }; // [FUNCTION]
void() turret_unret2 =	[$retract5, turret_unret3] { self.nextthink = time + 0.05; }; // [FUNCTION]
void() turret_unret3 =	[$retract4, turret_unret4] { self.nextthink = time + 0.05; }; // [FUNCTION]
void() turret_unret4 =	[$retract3, turret_unret5] {
	self.solid = SOLID_SLIDEBOX;
	setmodel(self, "progs/custents/turret.mdl");
	self.nextthink = time + 0.05;
};
void() turret_unret5 =	[$retract2, turret_unret6] { self.nextthink = time + 0.05; }; // [FUNCTION]
void() turret_unret6 =	[$retract1, turret_unret7] { self.nextthink = time + 0.05; }; // [FUNCTION]
void() turret_unret7 =	[$tilt0, turret_unret7] { // [FUNCTION]
	if (self.frame > (turret_frame(self.rotate_type) + 1))
		self.frame = self.frame - 2;
	else {
		self.frame = turret_frame(self.rotate_type);
		turret_active();
	}
};

void() turret_retracted =	[$retract7, turret_retracted] { // [FUNCTION]
	if (FindTarget()) turret_unret1();
};

void() turret_active =	[$tilt0, turret_active] { // [FUNCTION]
	local vector delta;
	local float axis, direct, ang_rint, ang_floor, ang_ceil;

	enemy_infront = infront(self.enemy);
	enemy_range = range(self.enemy);
	ai_setidealyaw();
	self.frame = turret_frame(self.rotate_type);

	// see if the enemy is dead
	if (self.enemy.health <= 0 || self.enemy.deadflag != 0) {
		self.enemy = world;
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
	if (coop && self.search_time < time) {
		if (FindTarget()) return;
	}

	if (self.attack_state == AS_MISSILE || self.attack_state == AS_MELEE) {
		ai_facingideal_action(self.th_missile);
		return;
	}

	CheckTurretAttack();
}

void() M_TurretFireBullets = { // [FUNCTION]
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
	sound(self,CHAN_WEAPON,"enforcer/enfire.wav",1,ATTN_NORM);
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
	sound(self,CHAN_WEAPON,"enforcer/enfire.wav",1,ATTN_NORM);
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
	sound(self,CHAN_WEAPON,"weapons/sgun1.wav",1,ATTN_NORM);
	self.effects = self.effects | EF_MUZZLEFLASH;
	vel = normalize(self.enemy.origin - self.origin);
	vel = vel * SPEED_LASER;
	dir = vectoangles(vel);
	launch_projectile(self.origin,dir,self.avelocity,CT_PROJ_ARMY,SPEED_RLPLAYER);
};

void() turret_beam1 = [$tilt0, turret_beam2] { turret_face(); sound(self,CHAN_WEAPON,"custents/turret/beamchrg.wav",1,ATTN_NORM); self.nextthink = time + 0.2; }; // [FUNCTION]
void() turret_beam2 = [$tilt0, turret_beam3] { turret_face(); sound(self,CHAN_WEAPON,"custents/turret/beamchrg.wav",1,ATTN_NORM); self.nextthink = time + 0.2; }; // [FUNCTION]
void() turret_beam3 = [$tilt0, turret_beam4] { turret_face(); sound(self,CHAN_WEAPON,"custents/turret/beamchrg.wav",1,ATTN_NORM); self.nextthink = time + 0.2; }; // [FUNCTION]
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
void(entity inflictor, entity attacker, float take)	turret_pain = {
	if (self.pain_finished > time) return;

	self.pain_finished = time + 1;
	sound(self,CHAN_VOICE, "custents/turret/beamchrg.wav",1,ATTN_NORM);
	ThrowGib(11,1);
};

void() turret_die = {
	self.use = SUB_Null;
	Tent_Explosion(self.origin);
	newmis = spawn();
	newmis.solid = SOLID_NOT;
	newmis.movetype = MOVETYPE_NONE;
	newmis.angles = self.angles;
	setorigin(newmis, self.origin);
	setmodel(newmis, "progs/custents/dedturet.mdl");
	setsize (self, '-10 -10 -3', '10 10 12');
	newmis.skin = self.skin;
	ThrowGib(25,1);
	ThrowGib(11,4);
	entity_remove(self,0.1);
};

void() turret_use= {
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

void() monster_turret_precache = {
	precache_model ("progs/custents/turret.mdl");
	precache_model ("progs/custents/h_turret.mdl");
	precache_model ("progs/custents/dedturet.mdl");
	precache_model ("progs/custents/turetgib.mdl");
	precache_sound("custents/turret/beamchrg.wav");
	precache_sound("custents/turret/beammode.wav");
	precache_model ("progs/laser.mdl");
	precache_sound(SOUND_LASER_FIRE);
	precache_sound(SOUND_LASER_HIT);
	precache_model ("progs/missile.mdl");
	precache_model ("progs/custents/beam.mdl");
	precache_sound("custents/turret/beamhit.wav");
	precache_sound("hipnotic/weapons/mjolhit.wav");
	precache_sound("custents/turret/plasbult.wav");
};

void() monster_turret = {
	local vector endorg;

	if (monster_checkspawn() == TRUE) return; // Check all spawn exceptions (monsters.qc)

	self.mdl = "progs/custents/turret.mdl";
	self.headmdl = "progs/custents/h_turret.mdl";
	self.gib1mdl = "progs/custents/turetgib.mdl";
	self.solid = SOLID_NOT;			// No interaction with world
	self.movetype = MOVETYPE_NONE;	// Static item, no movement
	self.bbmins = '-12 -12 -6';	// Special Size
	self.bbmaxs = '12 12 12';
	self.bboxtype = BBOX_CUSTOM;	// Custom size
	if (self.deathstring == "") self.deathstring = " was blasted by a Turret\n";
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
    self.hittype    = HIT_METAL;
	self.ideal_yaw = self.angles * '0 1 0';
	self.yaw_speed = 30;
	self.view_ofs = '0 0 -0.1';
	self.use = turret_use;
	self.flags = self.flags | FL_FLY;
	self.flags = self.flags | FL_MONSTER;
	self.pausetime = 99999999;
	traceline(self.origin, self.origin + '0 0 2000', TRUE, self);
	endorg = trace_endpos;
	endorg_z = endorg_z - 12;
	setorigin(self, endorg);

	// decide how to start according to the spawnflags
	if (self.spawnflags & TUR_STARTOFF) {
		if ((self.spawnflags & TUR_RETRACT) || (self.spawnflags & TUR_OFFRET)) {
			self.frame = $retract7;
			self.solid = SOLID_NOT;
		} else self.frame = turret_frame(self.rotate_type);

		self.currentammo = FALSE;
		self.think = SUB_Null;
	} else {
		if (self.spawnflags & TUR_RETRACT) {
			self.solid = SOLID_NOT;
			turret_retracted();
		} else turret_still();

		self.nextthink = self.nextthink + random()*0.5;
	}

	monster_start();
};

void() trap_turret = { // [ENTITY]
	self.classname = "monster_turret";
	monster_turret();
};
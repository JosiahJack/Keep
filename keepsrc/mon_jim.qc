/*==============================================================================
Jim (Heavily inspired by bob from Quoth - Kell/Necros/Preach)
New models, skins and animations, code
==============================================================================*/
// Slight movement of wings
$frame idle1 idle2 idle3 idle4 idle5 idle6

// Twist wings backward and evil eyes
$frame idle7 idle8 idle9 idle10 idle11 idle12

// Wobble gun (+/- 5 degrees) and evil eyes
$frame idle13 idle14 idle15 idle16 idle17 idle18

// Idle while gun is point left or right
$frame idleleft1 idleleft2 idleleft3 idleleft4 idleleft5 idleleft6
$frame idleright1 idleright2 idleright3 idleright4 idleright5 idleright6

// Idle and turn gun left or right 30 degrees
$frame idleturnl1 idleturnl2 idleturnl3 idleturnl4 idleturnl5 idleturnl6
$frame idleturnr1 idleturnr2 idleturnr3 idleturnr4 idleturnr5 idleturnr6

// Custom wing movements for combat
$frame movedn1 movedn2 movedn3 movedn4 movedn5 movedn6
$frame moveup1 moveup2 moveup3 moveup4 moveup5 moveup6

// Flap wings and get angry eyes
$frame pain1 pain2 pain3 pain4 pain5 pain6

// Downward spiral with twisted wings
$frame zdeath1 zdeath2 zdeath3 zdeath4 zdeath5 zdeath6

float JS_IDLE = 0;		// Default state
float JS_IDLE2 = 1;		// Special idle (stationary)
float JS_IDLE3 = 2;		// Special idle (stationary)
float JS_IDLELEFT = 3;	// Looking left
float JS_IDLERIGHT = 4;	// Looking right
float JS_TURNLEFT = 5;	// Turning left (not looped)
float JS_TURNRIGHT = 6;	// Turning right (not looped)
float JS_DOWN = 7;		// Combat move
float JS_UP = 8;		// Combat move
float JS_PAIN = 9;		// Resets current animation
float JS_DYING = 10;	// Final animation

// Size of each animation block
float JS_ANIMBLOCK = 6;

// Update Jim every frame with skin/sound updates fstate (see above for animation block details)
void(float fstate) jim_update = {
	// If jim is dead, no more updates
	if (self.health < 1) return;

	// Update ther gun idle (buzzing) sound
	if (self.t_width < time) {
		self.t_width = time + 0.9;
		// Play on auto channel so it overlaps with existing sound
		sound(self,CHAN_AUTO,"quoth/bob/hover.wav", 0.3,ATTN_WEAPON);
	}

	// Time for an idle sound?
	if (self.idletimer < time) monster_idle_sound();

	// Jim has a glowing gun and eye skin feature!
	if (self.t_length < time) {
		self.t_length = time + 0.2;
		self.exactskin = self.exactskin + 1;
		if (self.exactskin > 2) self.exactskin = 0;
		self.skin = self.exactskin;
	}

	// In combat?
	if (self.enemy) {
		self.idlebusy = FALSE;
		if (fstate == JS_IDLE) {
			if (self.origin_z > self.oldorigin_z) fstate = JS_UP;
			else if (self.origin_z < self.oldorigin_z) fstate = JS_DOWN;
		}
	} else {
		// At beginning of frame block and reversing?
		if (self.count == 0 && self.idlereverse) {
			if (self.idlebusy == JS_TURNLEFT || self.idlebusy == JS_TURNRIGHT) {
				self.idlebusy = JS_IDLE;
				self.idlereverse = FALSE;
				self.waitmin = time + 2 + random() * 4;
			}
		}
		// At end of frame block and going forward?
		else if (self.count == JS_ANIMBLOCK-1 && !self.idlereverse) {
			// Staring forward, doing nothing
			if (self.idlebusy == JS_IDLE && self.waitmin < time) {
				// Only start idle animations if stationary
				if (self.velocity_x == 0 && self.velocity_y == 0) {
					if (self.idletimer < time) monster_idle_sound();
					self.lip = random();
					if (self.lip < 0.3) self.idlebusy = JS_TURNLEFT;
					else if (self.lip < 0.6) self.idlebusy = JS_TURNRIGHT;
					else if (self.lip < 0.8) self.idlebusy = JS_IDLE2;
					else self.idlebusy = JS_IDLE3;
				}
			}
			// Return from wing flex, gun swing idle animations
			else if (self.idlebusy == JS_IDLE2 || self.idlebusy == JS_IDLE3) {
				self.idlebusy = JS_IDLE;
				self.waitmin = time + 2 + random() * 4;
			}
			// Turning eyes/gun in left direction
			else if (self.idlebusy == JS_TURNLEFT) {
				self.idlebusy = JS_IDLELEFT;
				self.waitmin = time + 2 + random() * 4;
			}
			// Turning eyes/gun to right direction
			else if (self.idlebusy == JS_TURNRIGHT) {
				self.idlebusy = JS_IDLERIGHT;
				self.waitmin = time + 2 + random() * 4;
			}
			// Looking left and randomly think about returning
			else if (self.idlebusy == JS_IDLELEFT) {
				if (self.waitmin < time && random() < 0.5) {
					self.idlebusy = JS_TURNLEFT;
					self.idlereverse = TRUE;
				}
			}
			// Looking right and randomly think about returning
			else if (self.idlebusy == JS_IDLERIGHT) {
				if (self.waitmin < time && random() < 0.5) {
					self.idlebusy = JS_TURNRIGHT;
					self.idlereverse = TRUE;
				}
			}
		}
		
		// Change the movement type so that jim can easily move up/down
		// using velocity, forced origin movement is really jerky!
		if (self.velocity_x == 0 && self.velocity_y == 0) {
			if (self.attack_timer < time) {
				self.attack_timer = time + 1;
				if (self.lip < 1) self.lip = 1;
				else self.lip = -1;
				self.velocity_z = 2 * self.lip;
			}
		}
	}

	// Check frame direction and update counter
	if (self.idlereverse) self.count = self.count - 1;
	else self.count = self.count + 1;
	if (self.count >= JS_ANIMBLOCK) self.count = 0;
	if (self.count < 0) self.count = JS_ANIMBLOCK-1;
	
	// Busy with an idle animation?
	if (self.idlebusy > 0) fstate = self.idlebusy;
	// Update frame animation block with frame counter
	self.frame = fstate * JS_ANIMBLOCK + self.count;
	// Store current origin position
	self.oldorigin = self.origin;
};


// All stand, walk and run functions are condensed down to one entry
// because the robot has a constant skin/sound update that has to
// happen at specific intervals
//
void()	jim_stand1	= [	$idle1,	jim_stand1 ] {
	// Standing idle has gentle bobbing up and down
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_FLY;
	jim_update(JS_IDLE); ai_stand(); };
void()	jim_walk1	= [	$idle1,	jim_walk1 ] {
	// Movement is steps, not velocity
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	jim_update(JS_IDLE); ai_walk(8); };
void()	jim_run1	= [	$idle1,	jim_run1 ] {
	// Movement is steps, only velocity when firing weapon
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	jim_update(JS_IDLE);
	ai_run(16); };


// Range (LASERS or ROCKETS)

void() jim_laser = { // [FUNCTION]
	local vector org, dir, vec;

	if (!self.enemy) return;
	if (self.health < 1) return;
	// Always make sure there is no monster or obstacle in the way
	if ( visxray(self,self.enemy, self.attack_offset, '0 0 12', FALSE) ) return;

	self.effects = self.effects | EF_MUZZLEFLASH;
	sound(self,CHAN_WEAPON,"enforcer/enfire.wav",1,ATTN_NORM);
	makevectors(self.angles);
	org = self.origin + attack_vector(self.attack_offset);

	// Aim high to catch jumping players
	dir = SUB_orgEnemyTarget() + '0 0 12';
	vec = normalize(dir - org);
	// Variable laser speed, original unit was just 800 every skill
	self.attack_speed = SPEED_JIMPROJ + (skill * SPEED_JIMPROJSKILL);
	launch_projectile(org,vec,NO_SPIN,CT_PROJ_LASER,self.attack_speed);
};

// Straight aim rocket, no pre-calculation or steering (skill based speed)
void() jim_rocket = { // [FUNCTION]
	local vector org, dir, vec;
	
	if (!self.enemy) return;
	if (self.health < 1) return;
	// Always make sure there is no monster or obstacle in the way
	if ( visxray(self,self.enemy, self.attack_offset, '0 0 -12', FALSE) ) return;
	
	self.effects = self.effects | EF_MUZZLEFLASH;
	sound(self,CHAN_WEAPON,"quoth/soldier/rocket.wav",1,ATTN_NORM);	
	makevectors(self.angles);
	org = self.origin + attack_vector(self.attack_offset);

	// Aim low to catch players with splash damage
	dir = SUB_orgEnemyTarget() - '0 0 12';
	vec = normalize(dir - org);
	
	// Variable rocket speed, matching laser (very nasty)
	self.attack_speed = SPEED_JIMPROJ + (skill * SPEED_JIMPROJSKILL);
	launch_projectile(org,vec,NO_SPIN,CT_PROJ_JIM2,self.attack_speed);
};

void(float vspeed) jim_vel = { 
	// Turn and face enemy and update attack velocity
	ai_face(); self.velocity = self.attack_track * vspeed;
};

// Calculate new attack vector for firing lasers at the player
void() jim_attack = { // [FUNCTION]
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_FLY;
	makevectors(self.angles);
	// Always fly upwards away from the player
	self.pos1 = v_up * (50 + random() * 100);
	// Randomly pick a left or right strafe direction
	self.pos2 = v_right * (crandom() * 200);
	// Always try to back away from the player
	self.pos3 = v_forward * (random() * 100);
	
	// Merge all the randomness together
	self.attack_track = self.pos1 + self.pos2 + self.pos3;
	// Check nothing is in the way, estimate vector of attack
	traceline(self.origin, self.origin+self.attack_track, FALSE, self);
};

void() jim_fire1 = [$idle1, jim_fire2 ] { jim_update(JS_IDLE);
	if (self.classtype == CT_MONJIM) 
		sound(self,CHAN_WEAPON,"quoth/bob/fire.wav",1,ATTN_NORM);
	else sound(self,CHAN_WEAPON,"ad171/jim/rocket_load.wav",1,ATTN_NORM);
};
void() jim_fire2 = [$idle1, jim_fire3 ] { jim_update(JS_IDLE);jim_attack();
	if (skill < SKILL_HARD) jim_vel(0.4);
	else jim_vel(1.5);
};
void() jim_fire3 = [$idle1, jim_fire4 ] {
	jim_update(JS_IDLE); if (skill < SKILL_HARD) jim_vel(0.6); };
void() jim_fire4 = [$idle1, jim_fire5 ] { jim_update(JS_IDLE); 
	if (skill < SKILL_HARD) jim_vel(0.8); };
void() jim_fire5 = [$idle1, jim_fire6 ] { jim_update(JS_IDLE);jim_vel(1.0); };
void() jim_fire6 = [$idle1, jim_fire7 ] {
	jim_update(JS_IDLE); if (skill < SKILL_HARD) jim_vel(1.2);
	if (self.classtype == CT_MONJIM) jim_laser();
	else jim_rocket();
};
void() jim_fire7 = [$idle1, jim_fire8 ] { jim_update(JS_IDLE);
	if (skill < SKILL_HARD) jim_vel(1.4);
	if (self.classtype == CT_MONJIM) jim_laser();
};
void() jim_fire8 = [$idle1, jim_fire9 ] { jim_update(JS_IDLE);
	if (skill < SKILL_HARD) jim_vel(1.3);
	if (self.classtype == CT_MONJIM && skill >= SKILL_NORMAL) jim_laser();
};
void() jim_fire9 = [$idle1, jim_fire10] { jim_update(JS_IDLE);
	if (skill < SKILL_HARD) jim_vel(1.1);
	if (self.classtype == CT_MONJIM && skill >= SKILL_HARD) jim_laser();
};
void() jim_fire10 = [$idle1, jim_fire11] { jim_update(JS_IDLE);jim_vel(0.5); };
void() jim_fire11 = [$idle1, jim_run1 ] { jim_update(JS_IDLE);
	// Chance of bob instantly firing again
	if (random() < 0.8) SUB_AttackFinished( 1 + random() );
	else SUB_AttackFinished( 1 + random()*0.5 );
};


// ROBOT PAIN!?!

void() jim_inpain = { // [FUNCTION]
	// Keep cycling the pain animation
	self.think = jim_inpain;
	self.nextthink = time + 0.1;
	
	// Start of pain cycle
	if (self.inpain ==  0) {
		// Spawn a pile of sparks and dust falling down
		particle_dust(self.origin, 10+random()*10, 16, PARTICLE_BURST_YELLOW);
		self.pos1 = '0 0 0';
		self.pos1_x = random() * self.lefty;	// Pitch away from dmg
		self.pos1_z = crandom() * -10;			// Roll left / right
	}
	// Finished, back to combat
	else if (self.inpain >= 5) {
		// reset pitch/roll
		self.angles_x = self.angles_z = 0;
		self.think = self.th_run;
	}
	else {
		// Keep moving in the pitch/roll direction
		self.pos1 = self.pos1 * 1.2;
		self.angles = self.angles + self.pos1;
	}
	
	// Update pain frame
	jim_update(JS_PAIN);
	// Next pain animation
	self.inpain = self.inpain + 1;
};

void(entity inflictor, entity attacker, float damage) jim_pain = {
	// Check all pain conditions and set up what to do next
	monster_pain_check(attacker, damage);
	
	// Stop any ai_run velocity and reset movetype
	self.velocity = '0 0 0';
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	if (random() < 0.5) sound(self,CHAN_VOICE, self.pain_sound,1,ATTN_NORM);
	else sound(self,CHAN_VOICE, self.pain_sound2,1,ATTN_NORM);
	self.inpain = 0;
	
	// Work out which direction the damage came from (enemy)
	if (infront(attacker)) self.lefty = 10;	// Hit from infront
	else self.lefty = -10;					// Hit from behind
	
	jim_inpain();
};


// SLOW DYING ROBOT!?!

void() jim_dying2;
void() jim_is_dead;

void() jim_dying1 = { // [FUNCTION]
	// Setup correct death frame
	self.frame = JS_DYING + self.cnt;
	self.cnt = self.cnt + 1;
	
	// Start spinning the robot out of control
	// This update works with avelocity to create spiral effect
	makevectors(self.angles);
	self.velocity = (v_forward * 300) + (v_up * -30);
	// Keep spinning out of control (constant direction)
	if (self.lefty == 1) self.angles_y = (self.angles_y + 10);
	else self.angles_y = (self.angles_y - 10);

	// Spawn some extra smoke trails
	if (random() < 0.3) SpawnProjectileSmoke(self.origin, 150, 50, 150);

	// Keep looping round
	self.think = jim_dying1;
	self.nextthink = time + 0.1;

	// Next frame/function?
	if (self.cnt > 3) { 
		self.think = jim_dying2;	// Next function
		self.waitmin = time + 1;	// Setup timer for next part
		self.cnt = 0; 				// Reset death animation
	}
};

void() jim_dying2 = { // [FUNCTION]
	// Setup correct death frame
	self.frame = JS_DYING + self.cnt;
	self.cnt = self.cnt + 1;
	if (self.cnt > 5) self.cnt = 0;

	// Medium explosion + sound OR smoke projectile trail
	if (random() > 0.7) SpawnExplosion(EXPLODE_MED, self.origin, "quoth/bob/s_explode.wav");
	else if (random() < 0.3) SpawnProjectileSmoke(self.origin, 150, 50, 150);

	// Turn down towards the ground
	makevectors(self.angles);
	self.solid = SOLID_BBOX;	// Collision + touch
	// Slow down the velocity to accent the spinning
	self.velocity = (self.velocity * 0.2) + ((v_forward * 100) * 0.8);
	self.velocity = normalize(self.velocity) * 300;
	self.velocity_z = self.velocity_z - 200;
	// Keep spinning out of control (constant direction)
	if (self.lefty == 1) self.angles_y = (self.angles_y + 10);
	else self.angles_y = (self.angles_y - 10);

	// Keep looping round
	self.nextthink = time + 0.1;
	if (self.waitmin < time) self.think = jim_is_dead;
	else self.think = jim_dying2;
};

// He's dead Jim! Star Trek references.
void() jim_is_dead = { // [FUNCTION]
	self.think = self.touch = SUB_Null;
	particle_dust(self.origin, 10+random()*10, 16, PARTICLE_BURST_YELLOW); // Final fireworks!
	SpawnProjectileSmoke(self.origin, 150, 50, 150);
	SpawnProjectileSmoke(self.origin, 150, 50, 150);
	SpawnExplosion(EXPLODE_BIG, self.origin, "ad171/seeker/explode_major.wav");
	entity_hide(self); // Goto final resting place
};

void() jim_die = { // [FUNCTION]
	// Pre-check routine to tidy up extra entities
	monster_death_precheck();

	// Flush every sound channel to kill gun buzzing sound
	StopSound(self,CHAN_WEAPON);
	StopSound(self,CHAN_VOICE);
	StopSound(self,CHAN_ITEM);
	StopSound(self,CHAN_FEET);
	StopSound(self,CHAN_EXTRA1);
	StopSound(self,CHAN_EXTRA2);

	// Special explosive death event 
	// First function creates the upward spiral (negative avelocity)
	// Second function accents the spiral (1s forward movement)
	// Third final impact (touch function goes here as well)
	//
	sound(self,CHAN_VOICE, "quoth/bob/death.wav",1,ATTN_NORM);
	self.solid = SOLID_NOT;			// No world colision
	self.movetype = MOVETYPE_FLY;	// Free velocity movement
	self.touch = jim_is_dead;		// still can touch stuff
	self.cnt = 0;					// Death frame 0
	// The avelocity works better when negative (twisting upward)
	self.avelocity_x = (random() * 50) - 100;
	self.avelocity_y = (random() * 50) - 100;
	self.avelocity_z = (random() * 50) - 100;
	
	// Decide which direction to spin
	if (random() < 0.5) self.lefty = 1;
	else self.lefty = 0;

	// Spawn dust and sprite explosion
	particle_dust(self.origin, 10+random()*10, 16, PARTICLE_BURST_YELLOW);
	SpawnExplosion(EXPLODE_BIG, self.origin, "quoth/bob/s_explode.wav");
	SpawnProjectileSmoke(self.origin, 150, 50, 150);

	jim_dying1();
};

void() monster_jim_precache = { // [FUNCTION]
	precache_model("progs/ad171/mon_jim.mdl");
	precache_model("progs/ad171/mon_jimrock.mdl");
	precache_model(MODEL_PROJ_LASER);		// Projectile fire and impact (used in projectiles): Enforcer laser model
	precache_sound("quoth/bob/death.wav");
	precache_sound("ad171/jim/pain1.wav");
	precache_sound("ad171/jim/pain2.wav");
	precache_sound("quoth/bob/s_explode.wav");
	precache_sound("ad171/seeker/explode_major.wav");
	precache_sound("quoth/bob/hover.wav"); // Long buzzing sound
	precache_sound("quoth/bob/sight.wav");
	precache_sound("ad171/jim/idle1.wav");
	precache_sound("ad171/jim/idle2.wav");
	precache_sound("quoth/defender/blip.wav");
	precache_sound("ad171/jim/rocket_load.wav"); // Projectile fire and impact (used in projectiles): Wind up...
	precache_sound("quoth/soldier/rocket.wav"); // ...Fire
	precache_sound("quoth/dguard/hit.wav"); // ...Impact
	precache_sound("quoth/bob/fire.wav");		// Wind up
	precache_sound(SOUND_LASER_FIRE); // Fire
	precache_sound(SOUND_LASER_HIT); // Impact
};

// QUAKED monster_jim (1 0 0) (-16 -16 -24) (16 16 24) Ambush
void() monster_jim = {
	if (monster_checkrandomizer() == TRUE) return; // Check for any random monster setups
	if (monster_checkspawn() == TRUE) return; // Check all spawn exceptions (monsters.qc)

	if (self.spawnflags & MON_JIM_ROCKET) self.mdl = "progs/ad171/mon_jimrock.mdl";
	else self.mdl = "progs/ad171/mon_jim.mdl";

	self.pain_sound = "ad171/jim/pain1.wav"; // death/pain/attack sounds
	self.pain_sound2 = "ad171/jim/pain2.wav";
	self.sight_sound = "quoth/bob/sight.wav";
	self.solid = SOLID_NOT;				// No interaction with world
	self.movetype = MOVETYPE_NONE;		// Static item, no movement
	if (self.bboxtype < 1) self.bboxtype = BBOX_SHORT;
	self.gibhealth = MON_NEVERGIB;		// Cannot be gibbed by weapons
	self.gibbed = FALSE;
	self.pain_flinch = 30;				// Sometimes flinch
	self.steptype = FS_FLYING;			// Silent feet
	self.pain_longanim = FALSE;			// No long pain animation
	self.blockudeath = TRUE;			// No humanoid death sound
	if (self.height == 0) self.height = MONAI_ABOVEDIST; // Custom height
	self.oldorigin = self.origin;		// Used for wing angles
	self.idlebusy = 0;					// Rotate gun idle states
	self.idlereverse = FALSE;			// Reverse direction for idle
	self.attack_offset = '20 0 -10';	// front of laser/rocket
	Resist_ChangeType(self,-1); // Always reset Ammo Resistance to be consistent
	self.th_checkattack = StrafeFlyerCheckAttack;
	self.th_stand = jim_stand1;
	self.th_walk = jim_walk1;
	self.th_run = jim_run1;
	self.th_pain = jim_pain;
	self.th_die = jim_die;
	self.th_missile = jim_fire1;
    self.hittype    = HIT_METAL;
	self.classgroup = CG_ROBOT;
	self.classmove = MON_MOVEFLY;
	if (self.spawnflags & MON_JIM_ROCKET) {
		self.classtype = CT_MONJIMROCKET;
		if (self.health < 1) self.health = 50;
		self.idle_sound = "ad171/jim/idle1.wav"; // Classic idle sound + new variant
		self.idle_sound2 = "quoth/defender/blip.wav";
		if (self.deathstring == "")  self.deathstring = " was blown away by Jim\n";
	} else {
		self.classtype = CT_MONJIM;
		if (self.health < 1) self.health = 100;
		self.idle_sound = "ad171/jim/idle1.wav"; // Classic idle sound + new variant
		self.idle_sound2 = "ad171/jim/idle2.wav";
		if (self.deathstring == "")  self.deathstring = " was cauterized by Jim\n";
	}
	monster_start();
};

// Re-direct all Quoth Bob requests to Jim!
void() monster_bob = { // [ENTITY], Redirect
	if (self.deathstring == "")  self.deathstring = " was zapped by a Bob-bot\n";
	monster_jim();
}

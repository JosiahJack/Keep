/*==============================================================================
Large rotating surface mount turret (model/animation by Benoit Stordeur)
 * QC was created for Bal's personal JamX project

  Interesting QC traits
  * Can be mounted on walls, ceilings or floors
  * Special axis lock feature to prevent turret clipping into world geo
  * Does not use a front facing angle for sight checks (infront)
  * The attacks get faster over time, the longer the enemy is in view
  * Range attack will not bend projectiles if enemy outside axis range
  * Will not track enemies if out of sight, uses last known location instead
  * Has no head model when destroyed on death, can hide stuff behind it! :P
 
  Assets required to get this monster working in AD
    (model's in 'progs' and wav's in 'sound' sub directories)
  * mon_turretbal.mdl (complete model)
  * gib_turretbal1.mdl (base of gun barrel)
  * gib_turretbal2.mdl (end of metal barrel)
  * gib_turretbal3.mdl (barrel section)
  * gib_turretbal4.mdl (main body section)

==============================================================================*/

// (000-012) Push barrels out, ready to attack
$frame open1 open2 open3 open4 open5 open6 open7 open8
$frame open9 open10 open11 open12 open13

// (013-036) Fire 3 shots, 1 barrel at a time
$frame fire1 fire2 fire3 fire4 fire5 fire6 fire7 fire8
$frame fire9 fire10 fire11 fire12 fire13 fire14 fire15 fire16
$frame fire17 fire18 fire19 fire20 fire21 fire22 fire23 fire24

// (037-041) Idle (no movement)
$frame idle1 idle2 idle3 idle4 idle5

// (042-057) Fire 1 shot, 3 barrels at once
$frame blast1 blast2 blast3 blast4 blast5 blast6 blast7 blast8
$frame blast9 blast10 blast11 blast12 blast13 blast14 blast15 blast16

// (058-079) Retract all barrels, spin barrels around at same time
$frame close1 close2 close3 close4 close5 close6 close7 close8
$frame close9 close10 close11 close12 close13 close14 close15 close16
$frame close17 close18 close19 close20 close21 close22

//======================================================================
// Many new custom functions because the turret only rotates
// Most monster (AI) functions assume the monster can move around
// Also all rotation has to go through an axis lock check first
//======================================================================

// Will twist the turret around to random angles (idle phase)
void(float rnd_angle) turretb_rotate =
{
	// angles = up/down, angle, tilt left/right 'pitch yaw roll'
	self.mangle = '0 0 0';
	self.mangle_x = crandom() * rnd_angle;
	self.mangle_y = crandom() * rnd_angle;
	// Finalangle is the spawn/starting angle of the model
	// Always reset the angle back to starting position
	self.angles = self.finalangle + self.mangle;
};

//----------------------------------------------------------------------
// Create vector offset of where enemy sight/fire tests are done
// Used by the various visibility check/fire functions
void(vector att_angle, vector att_offset) turretb_attvector =
{
	// Duplicate current turret angles
	self.attack_track = att_angle;
	// X has to be reversed, no idea why!
	self.attack_track_x = -self.attack_track_x;
	// Make all v_ vectors for 'attack_vector' function
	makevectors(self.attack_track);
	// Workout projectile starting point (end of barrel)
	self.attack_track = attack_vector(att_offset);
};

//----------------------------------------------------------------------
// Used to create an attack vector from the end of the barrel
vector(vector s_offset, vector t_offset) turretb_tracking =
{
	local vector attorigin;
	
	// If something (world geo/monster) in the way?
	if ( !visxray(self.enemy, s_offset, t_offset, FALSE) )
		// use backup origin instead, something wrong
		attorigin = normalize((self.move_state + t_offset) - self.origin);
	// Still got the enemy in sight, aim at head to catch jumpers
	else attorigin = normalize((self.enemy.origin + t_offset) - self.origin);
	
	return attorigin;
};

//----------------------------------------------------------------------
// The main function for checking if axis rotation has hit a limit
// Uses local and return variable so that it can cope with re-use
//----------------------------------------------------------------------
vector(vector angcheck) turretb_axischeck =
{
	local vector angpos1, angpos2;
	
	// What is the difference between current angle and spawn angle?
	// First convert the angles to the new system (0/360 = spawn direction)
	// Use anglemod to convert angles to 0-360 range (fix neg values)
	angpos1_x = anglemod(angcheck_x - self.anglockx_z);
	angpos1_y = anglemod(angcheck_y - self.anglocky_z);
	angpos1_z = 0;
	angpos2 = angcheck;

	// Check for angle zone from lock number to 180
	if (angpos1_x >= 180 && angpos1_x <= self.anglockx_x)
		angpos2_x = anglemod(self.anglockx_x + self.anglockx_z);
	if (angpos1_x < 180 && angpos1_x >= self.anglockx_y)
		angpos2_x = anglemod(self.anglockx_y + self.anglockx_z);
	
	// Wall mounted turrets use two axis (XY) instead
	if (self.distance) {
		if (angpos1_y >= 180 && angpos1_y <= self.anglocky_x)
			angpos2_y = anglemod(self.anglocky_x + self.anglocky_z);
		if (angpos1_y < 180 && angpos1_y >= self.anglocky_y)
			angpos2_y = anglemod(self.anglocky_y + self.anglocky_z);
	}
	return angpos2;
};

//----------------------------------------------------------------------
// Works like ai_face and turns the model barrels towards the enemy
// This function takes care of axis movement restrictions 
// HALFSPEED : Used when waking up to slowdown the turning speed
//----------------------------------------------------------------------
void(float halfspeed) turretb_ai_face =
{
	if (!self.enemy) return;
	if (self.health < 1) return;
	
	// Create enemy facing vector (Will use last known position as well)
	// The axis lock needs to be from monster origin, not end of barrel
	// The second offset is to aim at the enemies head (catches jumpers)
	self.movedir = turretb_tracking('0 0 0', '0 0 12');
	// Convert enemy vector into ideal facing angle
	self.pos1 = vectoangles(self.movedir);
	// Checks that enemy facing angles is within axis lock range
	self.finaldest = turretb_axischeck(self.pos1);
	
	// Half speed angle movement?
	if (halfspeed) {
		// Calculate the half way point between current and destination
		// rotation angle of model. Originally tried to do this by
		// calculating the difference between two angles. It was
		// a total mess because the turret would often clip through
		// the walls because of rotation errors.
		// The final idea was to use vectors (v_forward) and add half
		// the distance to the original and turn back into an angle
		// Does not suffer from any clipping issues because the axis
		// rotations are validated beforehand.
		makevectors(self.angles);
		self.pos1 = v_forward;
		makevectors(self.finaldest);
		self.pos2 = v_forward;
		// Create half way point between two vectors
		self.pos3 = self.pos1 + (self.pos2*0.5);
		// Switch back to an angle
		self.finaldest = vectoangles(self.pos3);
		// Fix angle conversion errors (Pitch is reversed)
		self.finaldest_x = self.finaldest_x = -self.finaldest_x;
	}
	// Finally rotate to new position
	self.angles = vectormod(self.finaldest);
};

//----------------------------------------------------------------------
// placeholder function if animated skins are required later
void() turretb_stand = { ai_stand(); };

//----------------------------------------------------------------------
// Slight twist of barrels, move barrels out/in quickly
void() turretb_idleA1 =[ $open2, turretb_idleA2 ] {turretb_stand(); };
void() turretb_idleA2 =[ $open4, turretb_idleA3 ] {turretb_stand(); };
void() turretb_idleA3 =[ $open6, turretb_idleA4 ] {turretb_stand(); };
void() turretb_idleA4 =[ $open8, turretb_idleA5 ] {turretb_stand(); };
void() turretb_idleA5 =[ $open7, turretb_idleA6 ] {turretb_stand(); };
void() turretb_idleA6 =[ $open6, turretb_idleA7 ] {turretb_stand(); };
void() turretb_idleA7 =[ $open5, turretb_idleA8 ] {turretb_stand(); };
void() turretb_idleA8 =[ $open4, turretb_idleA9 ] {turretb_stand(); };
void() turretb_idleA9 =[ $open3, turretb_idleA10 ] {turretb_stand(); };
void() turretb_idleA10 =[ $open2, turretb_idle1 ] {turretb_stand(); };

//----------------------------------------------------------------------
// Rotate barrels (slow spin)
void() turretb_idleB1 =[ $close22, turretb_idleB2 ] {turretb_stand(); };
void() turretb_idleB2 =[ $close21, turretb_idleB3 ] {turretb_stand(); };
void() turretb_idleB3 =[ $close20, turretb_idleB4 ] {turretb_stand(); };
void() turretb_idleB4 =[ $close19, turretb_idleB5 ] {turretb_stand(); };
void() turretb_idleB5 =[ $close18, turretb_idleB6 ] {turretb_stand(); };
void() turretb_idleB6 =[ $close17, turretb_idleB7 ] {turretb_stand(); };
void() turretb_idleB7 =[ $close18, turretb_idleB8 ] {turretb_stand(); };
void() turretb_idleB8 =[ $close19, turretb_idleB9 ] {turretb_stand(); };
void() turretb_idleB9 =[ $close20, turretb_idleB10 ] {turretb_stand(); };
void() turretb_idleB10 =[ $close21, turretb_idle1 ] {turretb_stand(); };

//----------------------------------------------------------------------
// Rotate barrels (fast spin)
void() turretb_idleC1 =[ $close22, turretb_idleC2 ] {turretb_stand(); };
void() turretb_idleC2 =[ $close20, turretb_idleC3 ] {turretb_stand(); };
void() turretb_idleC3 =[ $close18, turretb_idleC4 ] {turretb_stand(); };
void() turretb_idleC4 =[ $close16, turretb_idleC5 ] {turretb_stand(); };
void() turretb_idleC5 =[ $close14, turretb_idleC6 ] {turretb_stand(); };
void() turretb_idleC6 =[ $close12, turretb_idleC7 ] {turretb_stand(); };
void() turretb_idleC7 =[ $close14, turretb_idleC8 ] {turretb_stand(); };
void() turretb_idleC8 =[ $close16, turretb_idleC9 ] {turretb_stand(); };
void() turretb_idleC9 =[ $close18, turretb_idleC10 ] {turretb_stand(); };
void() turretb_idleC10 =[ $close20, turretb_idle1 ] {turretb_stand(); };

//----------------------------------------------------------------------
// Main idle loop (10 frames so idle sounds are less frequent)
void()	turretb_idle1 =[ $open1, turretb_idle2 ] { monster_idle_sound();turretb_stand(); };
void()	turretb_idle2 =[ $open1, turretb_idle3 ] { turretb_stand(); };
void()	turretb_idle3 =[ $open1, turretb_idle4 ] { turretb_stand(); };
void()	turretb_idle4 =[ $open1, turretb_idle5 ] { turretb_stand(); };
void()	turretb_idle5 =[ $open1, turretb_idle6 ] { turretb_stand(); };
void()	turretb_idle6 =[ $open1, turretb_idle7 ] { turretb_stand(); };
void()	turretb_idle7 =[ $open1, turretb_idle8 ] { turretb_stand(); };
void()	turretb_idle8 =[ $open1, turretb_idle9 ] { turretb_stand(); };
void()	turretb_idle9 =[ $open1, turretb_idle10 ] { turretb_stand(); };
void()	turretb_idle10 =[ $open1, turretb_idle1 ] {
	self.idlebusy = FALSE; 
	self.weaponstate = FALSE;
	if (random() < MON_IDLE_ANIMATION) {
		// Slight random movement of turret barrels
		turretb_rotate(15);
		self.idlebusy = TRUE; 
		// Make sure the idle animations don't repeat in a row
		self.lefty = self.lip;
		while (self.lefty == self.lip) { self.lefty = rint(random()*3);}
		self.lip = self.lefty;
		if (self.lip < 1) self.think = turretb_idleA1;		// Push barrels out/in
		else if (self.lip < 2) self.think = turretb_idleB1;	// Slow rotate barrels
		else self.think = turretb_idleC1;					// Fast rotate barrels
	}
};

//======================================================================
// Move barrels outwards ready for attack (slowly rotate towards enemy)
void() turretb_wakeup4 =[ $open6, turretb_wakeup6 ] {turretb_ai_face(TRUE);};
void() turretb_wakeup6 =[ $open8, turretb_wakeup8 ] {turretb_ai_face(TRUE);};
void() turretb_wakeup8 =[ $open10, turretb_wakeup9 ] {turretb_ai_face(TRUE);};
void() turretb_wakeup9 =[ $open11, turretb_wakeup10 ] {turretb_ai_face(TRUE);};
void() turretb_wakeup10 =[ $open12, turretb_ready ] {turretb_ai_face(TRUE);};

//----------------------------------------------------------------------
void() turretb_ready =[ $open13, turretb_ready ] { 
	// weaponstate = barrels extended
	self.weaponstate = TRUE;
	// Turn barrels to face enemy (axis restriction)
	turretb_ai_face(FALSE);
	// Update firing location (end of barrel) and set self.attack_track
	turretb_attvector(self.angles, self.attack_offset);
	// typical run function (check for attacks)
	ai_run(0);
};

//----------------------------------------------------------------------
// Entry point into run function, is barrels extended yet?
void() turretb_run = {
	// Reset attack/pain timers
	self.attack_finished = 0;
	self.pain_finished = 0;
	// Create backup copy for later
	self.move_state = self.enemy.origin;
	// Check if barrels are ready to fire or not?
	if (self.weaponstate) turretb_ready();
	// Extend barrels into firing position
	else turretb_wakeup4();
};
	
//======================================================================
// Range (LASERS or PLASMA)
//======================================================================
void(vector att_offset) turretb_laser =
{
	local vector org, vec;

	if (!self.enemy) return;
	if (self.health < 1) return;
	
	self.effects = self.effects | EF_MUZZLEFLASH;

	// Work out attack offset from end of barrel
	turretb_attvector(self.angles, att_offset);
	org = self.origin + self.attack_track;
	// Typically a projectile will fire directly at the enemy
	// This monster/turret has an axis lock and cannot fire any angle
	// The firing vector is taken from the monsters angles field instead
	// This means the projectile will not bend towards the enemy and
	// fire directly from the barrel using axis restrictions
	// This looks better and does not feel like the AI is cheating
	vec = v_forward;

	// Variable speed projectiles
	self.attack_speed = SPEED_TURRETBPROJ + (skill * SPEED_TURRETBPROJSKILL);
	// Laser or plasma? (different damage, same speed)
	if (self.spawnflags & MON_TURRETB_PLASMA) {
		sound (self, CHAN_WEAPON, SOUND_PLASMA_FIRE, 1, ATTN_NORM);
		launch_plasma(org, vec, CT_MONTURRETB, self.attack_speed);
	}
	else {
		sound (self, CHAN_WEAPON, "enforcer/enfire.wav", 1, ATTN_NORM);
		launch_projectile(org, vec, CT_PROJ_LASER, self.attack_speed);
	}
};

//----------------------------------------------------------------------
void() turretb_fireframe =
{
	// If dead, no more updates
	if (self.health < 1) return;
	
	// Start animation at 10fps, spin up to 20fps (x 2 speed)
	self.nextthink = time + 0.05 + (0.01*(self.attack_rage-self.attack_chance));
	self.think = turretb_fireframe;

	// Turn towards enemy or use last known position
	// Check angle against axis lock at all times
	turretb_ai_face(FALSE);
	
	// Animation trigger events
	if (self.spawnflags & MON_TURRETB_TRIPLE) {
		self.frame = $blast1 + self.walkframe;
		if (self.walkframe == 1) turretb_laser('66 0 5');
		if (self.walkframe == 1) turretb_laser('66 6 -4');
		if (self.walkframe == 1) turretb_laser('66 -6 -4');
	}
	else {
		self.frame = $fire1 + self.walkframe;
		if (self.walkframe == 1) turretb_laser('66 0 5');
		else if (self.walkframe == 10) turretb_laser('66 0 5');
		else if (self.walkframe == 18) turretb_laser('66 0 5');
	}
	
	// Move frame forward, check for conditions
	self.walkframe = self.walkframe + 1;
	
	// End of animation loop?
	if (self.walkframe > self.attack_frame) {
		// Reset animation to fire on first frame
		self.walkframe = 1;
		// If something (world geo/monster) in the way?
		if ( !visxray(self.enemy, '0 0 0', '0 0 12', FALSE) ) {
			// Stop firing and exit
			self.think = turretb_ready;
		}
		// Increase fire rate
		if (self.attack_chance < self.attack_rage) 
			self.attack_chance = self.attack_chance + self.attack_count;
	}
};

//----------------------------------------------------------------------
void() turretb_fire = { 
	self.walkframe = 0; self.attack_chance = 0; turretb_fireframe();
};

//======================================================================
vector() turretb_spawnvec =
{
	// Work out v_* directions
	makevectors(self.finalangle);
	// reverse direction if up/down config active
	if(self.distance) return v_forward;
	else return -v_forward;
}

//----------------------------------------------------------------------
void(entity inflictor, entity attacker, float damage) turretb_pain =
{
	// Check all pain conditions and set up what to do next
	monster_pain_check(attacker, damage);

	// Work out spawn angle/v_forward direction
	self.dest1 = turretb_spawnvec();
	// Spawn dust/model particles
	SpawnVelocitySmoke(self.origin, self.dest1+(crandom()*v_up), 200, 200);
	SpawnVelocitySmoke(self.origin, self.dest1+(crandom()*v_up), 200, 200);
	SpawnVelocitySmoke(self.origin, self.dest1+(crandom()*v_up), 200, 200);
	particle_dust(self.origin, 10+random()*10, PARTICLE_BURST_YELLOW);

	// Any pain animation/sound required?
	if (self.pain_check > 0) {
		sound (self, CHAN_VOICE, self.pain_sound, 1, ATTN_NORM);
		self.pain_finished = time + 1;
	}
};

//======================================================================
void() turretb_die =
{
	// Pre-check routine to tidy up extra entities
	monster_death_precheck();

	// Work out spawn angle/v_forward direction
	self.dest1 = turretb_spawnvec();
	// Spawn dust/model particles
	SpawnVelocitySmoke(self.origin, self.dest1+(crandom()*v_up), 200, 200);
	SpawnVelocitySmoke(self.origin, self.dest1+(crandom()*v_up), 200, 200);
	SpawnVelocitySmoke(self.origin, self.dest1+(crandom()*v_up), 200, 200);
	particle_dust(self.origin, 10+random()*10, PARTICLE_BURST_YELLOW);
	// Sprite explosion
	SpawnExplosion(EXPLODE_BIG, self.origin, self.death_sound);

	// no more turret
	entity_hide (self);
	// Make sure gibs go flying up
	self.max_health = MON_GIBFOUNTAIN;
	self.health = -100;

	// Metal and custom body parts
	self.gibtype = GIBTYPE_METAL;
	ThrowGib(11, 1);						// Base of gun barrel
	ThrowGib(12, 1 + rint(random()*2));		// End of barrel (max 3)
	ThrowGib(13, 2 + rint(random()*2));		// Barrel section
	ThrowGib(14, 2 + rint(random()*2));		// Main body chunks
	ThrowGib(15, 2 + rint(random()*2));		// Generic metal
};

/*======================================================================
QUAKED monster_turretbal (1 0 0) (-20 -20 -20) (20 20 20) Ambush
======================================================================*/
void() monster_turretbal =
{
	if (deathmatch) { remove(self); return; }

	self.mdl = "progs/ad172/mon_turretbal.mdl";		// Turret
//	self.headmdl = "progs/h_turretbal.mdl";		// Not used
	self.gib1mdl = "progs/ad172/gib_turretbal1.mdl";	// base of gun barrel
	self.gib2mdl = "progs/ad172/gib_turretbal2.mdl";	// end of metal barrel
	self.gib3mdl = "progs/ad172/gib_turretbal3.mdl";	// barrel section
	self.gib4mdl = "progs/ad172/gib_turretbal4.mdl";	// main body section
	self.gib5mdl = "progs/ad172/gib_metal1.mdl";		// generic metal chunk

	precache_model (self.mdl);			// Turret
//	precache_model (self.headmdl);		// Not used
	precache_model (self.gib1mdl);		// frame of gun barrel
	precache_model (self.gib2mdl);		// end of metal barrel
	precache_model (self.gib3mdl);		// barrel section
	precache_model (self.gib4mdl);		// main body section
	precache_model (self.gib5mdl);		// generic metal chunk
	
	self.idle_sound = "turretb/idle1.wav";
	precache_sound (self.idle_sound);
	self.idle_sound2 = "turretb/idle2.wav";
	precache_sound (self.idle_sound2);

	// Default attack - lasers!
	precache_model (MODEL_PROJ_LASER);			// Copy of enforcer laser
	precache_sound ("enforcer/enfire.wav");
	precache_sound ("enforcer/enfstop.wav");

	// Extra attack - plasma!
	precache_model (MODEL_PROJ_LASERBLUE);		// Blue version of laser
	precache_sound (SOUND_PLASMA_FIRE);
	precache_sound (SOUND_PLASMA_HIT);
	
	self.pain_sound = "turretb/pain1.wav";
	precache_sound (self.pain_sound);
	self.death_sound = "turretb/explode_major.wav";
	precache_sound (self.death_sound);
	
	self.sight_sound = "turretb/sight1.wav";
	precache_sound (self.sight_sound);

	self.solid = SOLID_NOT;				// No interaction with world
	self.movetype = MOVETYPE_NONE;		// Static item, no movement
	if (self.bboxtype < 1) self.bboxtype = BBOX_SQUARE;
	if (self.health < 1) self.health = 200;
	self.gibhealth = MON_NEVERGIB;		// Special explosion death
	self.gibbed = FALSE;
	self.pain_flinch = 1;				// Always flinch
	self.pain_timeout = 1;				// Low pain threshold
	self.steptype = FS_FLYING;			// Silent feet
	self.pain_longanim = FALSE;			// No long pain animation
	self.blockudeath = TRUE;			// No humanoid death sound
	self.poisonous = FALSE;				// Robots are not poisonous
	self.no_liquiddmg = TRUE;			// Immune to slime/lava
	self.deathstring = " was blasted to hell by a Turret\n";
	self.attack_offset = '66 0 0';		// Middle of three barrels
	self.sight_nofront = TRUE;			// Has no front facing
	self.weaponstate = FALSE;			// Open/close barrel state
	self.movespeed = -1;				// Never move model
	if (self.attack_count < 0) self.attack_count = 0;
	else self.attack_count = 1;			// Fire rate Increment
	self.attack_rage = 5;				// Fire rate Maximum
	// Different animation sets for single/blast attacks
	if (self.spawnflags & MON_TURRETB_TRIPLE) self.attack_frame = 16;
	else self.attack_frame = 24;

	//----------------------------------------------------------------------
	// The turret can only be setup in two positions, wall or floor/ceiling.
	// The floor/ceiling are treated the same because its just reversed.
	// The wall version uses the 'angle' key to determine its center point
	// and the floor/ceiling uses the weird -1/-2 'angle' setting instead.
	// If the up/down version is detected then the 'angles' key is reset.
	// 
	if (self.angles == '0 -1 0') self.angles = '90 0 0';		// Up
	else if (self.angles == '0 -2 0') self.angles = '270 0 0';	// Down
	else self.angles_x = 0;		// Yaw movement only (wall setup)

	// Due to the way the model is setup for up/down and yaw axis rotation
	// the up/down setups only need to check one axis (X) range and the
	// wall setup requires multiple (XY) ranges instead
	if (self.angles_x > 0) self.distance = FALSE;
	else self.distance = TRUE;
	
	// Make sure angle values (xyz) are in the range of 0-360 otherwise
	// comparisions for XY range will not work if values are negative
	self.angles = vectormod(self.angles);
	// Create the v_ vectors
	makevectors (self.angles);
	self.movedir = v_forward;
	// Save spawning angle for idle movement adjustment
	self.finalangle = self.angles;
	
	// Make sure axis lock ranges are 1-90 degree's
	if (self.t_length <= 0) self.t_length = 75;
	if (self.t_length > 90) self.t_length = 90;
	if (self.t_width <= 0) self.t_width = 75;
	if (self.t_width > 90) self.t_width = 90;
	
	// The problem with QC angle maths is when 0 should wrap around to 360
	// This becomes apparent when looking for certain angle ranges (> && <)
	// because you can end up with a range spanning across the 0/360 boundary.
	// The best solution is to move the 0/360 boundary to an angle location
	// where the crossover has no affect on the target range.
	// 
	// The axis lock feature is centered around the spawning angle, which will
	// always be accessible to the turret and never blocked. This angle is the
	// perfect location for the 0/360 boundary because its never tested.
	//
	// The lock range is setup using the new 0/360 location and the ai_run
	// test function converts 'angles' key to that range first before testing.
	// Once the test has finished, then 'angles' key is converted back using
	// the spawn angle as a way to switch between formats.
	//
	// Setup axis lock cone (+/-) around 0/360 boundary
	// The setup cone cannot be more than 90 degree's, the default is 75
	self.anglockx_x = 0 - self.t_length;
	self.anglockx_y = 0 + self.t_length;
	// Z is the original spawn angle (used to move between formats)
	self.anglockx_z = self.angles_x;
	// make sure all parameters are within range 0-360
	self.anglockx = vectormod(self.anglockx);
	
	// Setup axis lock cone (+/-) around 0/360 boundary
	// This is really a duplicate of the X axis, but it can be different
	// for turrets which are setup on walls as they use two axis instead.
	self.anglocky_x = 0 - self.t_width;
	self.anglocky_y = 0 + self.t_width;
	// Z is the original spawn angle (used to move between formats)
	self.anglocky_z = self.angles_y;
	// make sure all parameters are within range 0-360
	self.anglocky = vectormod(self.anglocky);
	
	// Debug makevector arrow directions
	// v_forward reversed for up/down model angles
/*	
	if (self.distance) spawn_arrow(self.origin, vectoangles(v_forward), 0);
		spawn_arrow(self.origin, vectoangles(-v_forward), 0);
	spawn_arrow(self.origin, vectoangles(v_up), 3);
	spawn_arrow(self.origin, vectoangles(v_right), 4);
*/

	//----------------------------------------------------------------------
	// Always reset Ammo Resistance to be consistent
	self.resist_shells = self.resist_nails = 0;
	self.resist_rockets = self.resist_cells = 0;
	
	self.th_checkattack = TurretbCheckAttack;
	self.th_stand = turretb_idle1;
	self.th_walk = turretb_idle1;
	self.th_run = turretb_run;
	self.th_missile = turretb_fire;
	self.th_pain = turretb_pain;
	self.th_die = turretb_die;

	self.classtype = CT_MONTURRETB;
	self.classgroup = CG_ROBOT;
	self.classmove = MON_MOVEFLY;
	
	monster_start();
};

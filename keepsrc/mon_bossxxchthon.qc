//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by W. Josiah Jack, aka Qmaster
//
// Attributions: Arcane Dimensions (AD) from the idea in Beyond Belief
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
// Function count: 41
//
// Implements: Chthon (killable version)
//
// Description:
// 
//=============================================================================

// Chthon (Custom Version)

$frame rise1 rise2 rise3 rise4 rise5 rise6 rise7 rise8 rise9 rise10
$frame rise11 rise12 rise13 rise14 rise15 rise16 rise17 
$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8
$frame walk9 walk10 walk11 walk12 walk13 walk14 walk15
$frame walk16 walk17 walk18 walk19 walk20 walk21 walk22
$frame walk23 walk24 walk25 walk26 walk27 walk28 walk29 walk30 walk31
$frame death1 death2 death3 death4 death5 death6 death7 death8 death9
$frame attack1 attack2 attack3 attack4 attack5 attack6 attack7 attack8
$frame attack9 attack10 attack11 attack12 attack13 attack14 attack15
$frame attack16 attack17 attack18 attack19 attack20 attack21 attack22
$frame attack23
$frame shocka1 shocka2 shocka3 shocka4 shocka5 shocka6 shocka7 shocka8
$frame shocka9 shocka10 
$frame shockb1 shockb2 shockb3 shockb4 shockb5 shockb6
$frame shockc1 shockc2 shockc3 shockc4 shockc5 shockc6 shockc7 shockc8 
$frame shockc9 shockc10

float CHTHON_PHASE1 = 1;	// Rising from Lava
float CHTHON_PHASE2 = 2;	// Fighting
float CHTHON_PHASE3 = 3;	// Frenzy mode
float CHTHON_PHASE4 = 4;	// Death

// IDLE state - waiting for player
void() xxchthon_idleframe = { // [FUNCTION]
	// Get the obvious exception(s) done first
	if (self.health < 1) return;

	if (self.walkframe == 0) monster_idle_sound(); // Beginning of animation block

	// Move frame forward, check for conditions
	self.walkframe = self.walkframe + 1;
	if (self.walkframe > 30) self.walkframe = 0;
	self.nextthink = time + 0.1;
	self.think = xxchthon_idleframe;
	self.frame = $walk1 + self.walkframe; // Setup current animation frame

	// Check for HP trigger event
	if (SUB_BossWaveCheck(0)) self.th_jump();
	else if (FindTarget()) self.th_missile();
};

void() xxchthon_idle = { self.walkframe = 0; xxchthon_idleframe(); }; // [FUNCTION]

// ATTACK 1 - Constant fireballs
void(vector orgofs) xxchthon_missile = { // [FUNCTION]
	local vector offang, org, vec, dir, mdest, avel;
	local float projlen;

	// No enemy or player dead?
	if (!self.enemy) return;
	
	sound(self,CHAN_WEAPON,"ad171/chthon/attack1.wav",1,ATTN_NORM);
	offang = vectoangles (self.enemy.origin - self.origin);	
	makevectors(offang);
	org = self.origin + attack_vector(orgofs);
	
	// Skill level adjustment
	self.attack_speed = self.pos1_x + (skill*self.pos1_y);
	
	// Lead the missile on hard mode (This formula is not perfect) 
	// There are plenty of missiles that go in strange directions, 
	// especially if the player strafes a lot from side to side.
	if (skill > SKILL_HARD) {
		projlen = vlen(self.enemy.origin - org) / self.attack_speed;
		vec = self.enemy.velocity;
		vec_z = 0;
		mdest = self.enemy.origin + projlen * vec;		
	}
	else mdest = self.enemy.origin;
	
	dir = normalize (mdest - org);
	avel = vecrand(100,200,FALSE);
	launch_projectile (org,dir,avel,CT_PROJ_CHTHON,self.attack_speed);
};

void() xxchthon_attackframe = { // [FUNCTION]
	if (self.health < 1) return; // Get the obvious exception(s) done first

	if (self.walkframe == 0) monster_idle_sound(); // Beginning of animation block
	else if (self.walkframe == 7) xxchthon_missile('100 100 200');
	else if (self.walkframe == 18) xxchthon_missile('100 -100 200');

	self.walkframe = self.walkframe + 1; // Move frame forward, check for conditions
	if (self.walkframe > 22) self.walkframe = 0;
	self.nextthink = time + 0.1;
	self.think = xxchthon_attackframe;
	self.frame = $attack1 + self.walkframe; // Setup current animation frame
	if (SUB_BossWaveCheck(0)) self.th_jump(); // Check for HP trigger event
	else {
		// Keep checking for player and turning towards them
		// Check for any no combat conditions
		if (self.enemy.health < 1) self.enemy = world;
		else if (frame_pause()) self.enemy = world;
		else if (Invisible(self.enemy)) self.enemy = world;
		
		if (!self.enemy) self.th_stand(); // No enemy? back to idle, else keep turning
		else ai_face();
	}
};

void() xxchthon_attack = { self.walkframe = 0; xxchthon_attackframe(); }; // [FUNCTION]

// Re-using the original shock animations for end of wave event
void() xxchthon_shakeattack = { // [FUNCTION]
	local vector org, ang, dir, avel;

	self.attack_speed = self.pos3_x; // Custom grenade firing speed
	makevectors(self.angles);
	org = self.origin + attack_vector(self.dest2); // Shoot grenades from top of shub
	ang = '0 0 0';
	ang_y = rint(random()*360); // Randomly shoot grenades in any directions
	makevectors(ang);
	dir = v_forward * self.attack_speed;
	dir_z = self.pos3_y; // Use classic grenade angle system, not Z aware
	avel = vecrand(100,200,FALSE); // A bit of random spin and fire!
	launch_projectile(org,dir,avel,CT_PROJ_CHTHON2,1);
};

void() xxchthon_shakeframe = { // [FUNCTION]
	if (random() < 0.75) xxchthon_shakeattack(); // Randomnly fire grenades outward
	self.nextthink = time + 0.1; // Keep on looping around
	self.think = xxchthon_shakeframe;
	self.walkframe = self.walkframe + 1; // Move frame forward, check for conditions
	if (self.walkframe > 9) {
		self.walkframe = 0;
		self.count = self.count + 1;
		self.inpain = self.inpain + 1;
		
		// has chthon looped around 3 times?
		if (self.count > 1) {
			Resist_ChangeType(self, FALSE);
			self.style = CHTHON_PHASE2;
			// Straight back to throwing fireballs!
			self.think = self.th_missile;
		}
	}

	// Update current frames (2 sets of animations)
	if (self.inpain == 0) self.frame = $shocka1 + self.walkframe;
	else self.frame = $shockc1 + self.walkframe;
};

void() xxchthon_shake = { // [FUNCTION]
	// Start roaring and shaking
	sound(self,CHAN_VOICE, self.sight_sound,1,ATTN_NORM);
	Resist_ChangeType(self, TRUE);
	self.walkframe = self.count = self.inpain = 0;
	xxchthon_shakeframe();
};

void(entity inflictor, entity attacker, float damage) xxchthon_pain = { // [FUNCTION]

	// Check for boss wave trigger events
	if (SUB_BossWaveCheck(0)) { self.th_jump(); return; }
	self.pain_finished = time + 2 + random()*2;

	// Spawn particle/smoke damage
	SpawnProjectileSmoke(inflictor.origin, 200, 50, 150);
	if (damage > 30) SpawnProjectileSmoke(inflictor.origin, 200, 50, 250);
	// The pain sound not linked to animation, so less useful
	if (random() < 0.2 && damage > 30)
		sound(self,CHAN_VOICE, self.pain_sound,1,ATTN_NORM);
};

// DEATH - Fall down and explode
void() xxchthon_lavasplash = { // [FUNCTION]
	if (ext_dppart) {
		// Two different types of liquid splash (only DP)
		if (self.spawnflags & MON_CHTHON_GREEN) 
			pointparticles(particleeffectnum("TE_SLIMESPLASH"), self.origin, '0 0 0', 1);
		else Tent_LavaSplash(self.origin,0,"ad171/chthon/lavasplash.wav");
	}
};

void() xxchthon_explode = { // [FUNCTION]
	entity_hide(self); // No more Boss!
	self.max_health = MON_GIBEXPLOSION; // Gib explosive fountain!?!
	ThrowGib(11, 15 + rint(random()*10));	// lava explosions
};

void() xxchthon_explosion = { // [FUNCTION]
	// Pick random location above/center of chthin
	self.oldorigin = self.origin + vecrand(0,100,TRUE);
	self.oldorigin_z = self.origin_z + 50 + random()*100;

	// Spawn smoke, explosion and lava gib!
	SpawnProjectileSmoke(self.oldorigin, 100, 400, 100);
	if (random() < 0.5) self.lip = EXPLODE_MED;
	else self.lip = EXPLODE_BIG;

	SpawnExplosion(self.lip, self.oldorigin, "");
	ThrowGib(11, 1);
};

void() xxchthon_death1 = [$death1, xxchthon_death2] {}; // [FUNCTION]
void() xxchthon_death2 = [$death2, xxchthon_death3] { xxchthon_explosion(); }; // [FUNCTION]
void() xxchthon_death3 = [$death3, xxchthon_death4] { xxchthon_explosion(); }; // [FUNCTION]
void() xxchthon_death4 = [$death4, xxchthon_death5] { xxchthon_explosion(); }; // [FUNCTION]
void() xxchthon_death5 = [$death5, xxchthon_death6] { xxchthon_explosion(); }; // [FUNCTION]
void() xxchthon_death6 = [$death6, xxchthon_death7] { xxchthon_explosion(); }; // [FUNCTION]
void() xxchthon_death7 = [$death7, xxchthon_death8] { xxchthon_explosion(); }; // [FUNCTION]
void() xxchthon_death8 = [$death8, xxchthon_death9] { xxchthon_explosion(); }; // [FUNCTION]
void() xxchthon_death9 = [$death9, xxchthon_explode] { xxchthon_lavasplash(); }; // [FUNCTION]

void() xxchthon_die = { // [FUNCTION]
	self.style = CHTHON_PHASE4;		// Game Over for Chthon!
	self.deadflag = DEAD_DEAD;		// the rock finally crashed
	self.effects = 0;				// Remove effects on death
	self.solid = SOLID_NOT;			// no longer need to block
	self.max_health = MON_GIBEXPLOSION;

	sound(self,CHAN_VOICE, "ad171/chthon/death1.wav",1,ATTN_NORM);
	xxchthon_death1();
};

// RISE up from the swirling liquid
void() xxchthon_rise1	= [	$rise1, xxchthon_rise2 ] { xxchthon_lavasplash(); };
void() xxchthon_rise2	= [	$rise2, xxchthon_rise3 ] { sound(self,CHAN_VOICE, self.sight_sound,1,ATTN_NORM); };
void() xxchthon_rise3	= [	$rise3, xxchthon_rise4 ] {};
void() xxchthon_rise4	= [	$rise4, xxchthon_rise5 ] { ai_face(); };
void() xxchthon_rise5	= [	$rise5, xxchthon_rise6 ] {};
void() xxchthon_rise6	= [	$rise6, xxchthon_rise7 ] { ai_face(); };
void() xxchthon_rise7	= [	$rise7, xxchthon_rise8 ] {};
void() xxchthon_rise8	= [	$rise8, xxchthon_rise9 ] { ai_face(); };
void() xxchthon_rise9	= [	$rise9, xxchthon_rise10 ] {};
void() xxchthon_rise10	= [	$rise10, xxchthon_rise11 ] { ai_face(); };
void() xxchthon_rise11	= [	$rise11, xxchthon_rise12 ] {};
void() xxchthon_rise12	= [	$rise12, xxchthon_rise13 ] { ai_face(); };
void() xxchthon_rise13	= [	$rise13, xxchthon_rise14 ] {};
void() xxchthon_rise14	= [	$rise14, xxchthon_rise15 ] { ai_face(); };
void() xxchthon_rise15	= [	$rise15, xxchthon_rise16 ] {};
void() xxchthon_rise16	= [	$rise16, xxchthon_rise17 ] { ai_face(); };
void() xxchthon_rise17	= [	$rise17, xxchthon_attack ] {
	self.style = CHTHON_PHASE2;		// Start fighting
	self.takedamage = DAMAGE_AIM;
};

// Setup Chthon after trigger event
void() xxchthon_awake = { // [FUNCTION]
	self.use = SUB_Null;			// No more triggers
	self.style = CHTHON_PHASE1;		// Rising from Lava
	self.flags = FL_MONSTER;		// Reset flag (no user settings)
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, self.mdl);					// Setup model
	setsize (self, self.bbmins, self.bbmaxs);	// Restore BB size
	self.takedamage = DAMAGE_NO;	// Still immune to damage
	self.yaw_speed = 20;			// Average Speed
	self.velocity = '0 0 0';		// Make sure stationary
	self.pain_longanim = FALSE;		// No axe advantage
	self.noinfighting = TRUE;		// No infighting
	Resist_Save(self);				// Save for Later
		
	// Setup boss waves and overall health
	if (self.bosswave < 1) self.bosswavetotal = 5;
	else self.bosswavetotal = self.bosswave;
	
	// Always start bosswave at 1
	self.bosswave = 1;
	if (self.bosswaveqty < 1) self.bosswaveqty = 500;
	self.max_health = self.bosswavetotal * self.bosswaveqty;
	// Setup boss wave HP + trigger event
	SUB_BossWaveSetupHP();

	// Restore all think functions
	self.th_stand = xxchthon_idle;
	self.th_walk = xxchthon_idle;
	self.th_run = xxchthon_idle;
	self.th_missile = xxchthon_attack;
	self.th_jump = xxchthon_shake;
	self.th_pain = xxchthon_pain;
	self.th_die = xxchthon_die;
	
	self.pain_finished = time + 3;		// Make pain go away
	self.attack_finished = time + 2;	// Reset attack system
	self.gibhealth = -1000;				// Special death sequence
	self.enemy = activator;

	// DP particle spark and smoke effect to Chthon 
	// original idea by Seven, green version added later by me
	if (ext_dppart) self.traileffectnum = particleeffectnum(self.dpp_name);

	// Time to rise from lava
	xxchthon_rise1();
};

void() monster_chthon_precache = {
	precache_model("progs/ad171/mon_bosschthon.mdl");
	precache_model(MODEL_PROJ_LAVA);
	precache_model(MODEL_PROJ_CHTHON1);
	precache_model(MODEL_PROJ_SLIME);
	precache_sound("weapons/rocket1i.wav");
	precache_sound("ad171/chthon/pain1.wav");
	precache_sound("ad171/chthon/death1.wav");
	precache_sound("ad171/chthon/sight1.wav");
	precache_sound("ad171/chthon/lavasplash.wav");
	precache_sound("ad171/chthon/idle1.wav");
	precache_sound("ad171/chthon/attack1.wav"); // Attack/throw/electric sound
	precache_sound("ad171/wraith/bounce.wav");
};

// QUAKED monster_chthon (1 0 0) (-128 -128 -24) (128 128 256)
void() monster_chthon = {
	if (monster_checkrandomizer() == TRUE) return; // Check for any random monster setups

	self.mdl = "progs/ad171/mon_bosschthon.mdl";
	self.gib1mdl = MODEL_PROJ_CHTHON1; // Final explosion (10 distorted balls of lava/slime)
	self.gib1frame = 9;
	
	// Load up slime version and switch gibs
	if (self.spawnflags & MON_CHTHON_GREEN) {
		self.skin = self.gib1skin = 2;
		self.dpp_name = "TR_BOSSCHTHONGRN";
		self.gibtype = GIBTYPE_POISON;
		self.poisonous = TRUE;
		if (self.deathstring == "") self.deathstring = " was blown apart by Poison Chthon\n";
	} else {
		// Check for new red/fire skin
		if (self.spawnflags & MON_CHTHON_RED) {
			self.skin = self.gib1skin = 1;
			if (self.deathstring == "") self.deathstring = " was blown apart by Blood Chthon\n";
		} else {
			if (self.deathstring == "") self.deathstring = " was blown apart by Chthon\n";
		}
		
		self.dpp_name = "TR_BOSSCHTHON";
	}
	self.idle_sound = "ad171/chthon/idle1.wav";
	self.pain_sound = "ad171/chthon/pain1.wav";
	self.sight_sound = "ad171/chthon/sight1.wav"; // Rise from lava roar + splash
	self.solid = SOLID_NOT;			// No interaction with world
	self.movetype = MOVETYPE_NONE;	// Static item, no movement
	if (self.bboxtype < 1) {
		self.bbmins = '-80 -80 -24';	// Use to be 128 square, reduced size to help with radius/splash damage being more effective
		self.bbmaxs = '80 80 256';
		self.bboxtype = BBOX_CUSTOM;
	}
	self.bossflag = TRUE;			// Boss flag (like FL_MONSTER)
	if (self.health < 1) self.health = MEGADEATH;
	self.max_health = self.health;
	self.pain_finished = LARGE_TIMER;
	self.no_liquiddmg = TRUE;		// no slime/lava damage
	self.gibbed = FALSE;			// Still in one piece
	self.pain_flinch = 400;			// Shambler level
	self.pain_timeout = 2;			// Stop constant pain
	self.deadflag = DEAD_NO;					// used to stop death re-triggering
	self.liquidbase = self.liquidcheck = 0;		// Used for liquid content damage
	self.dmgcombined = self.dmgtimeframe = 0;	// combined damage over 0.1s
	self.takedamage = DAMAGE_NO;	// Immune to damage
	if (self.deathstring == "")  self.deathstring = " was blown apart by Chthon\n";
	if (VectorIsAllZeros(self.pos1)) self.pos1 = '250 50 0'; // Setup projectile speed (250 + 50*skill)
	if (VectorIsAllZeros(self.pos2)) self.pos2 = DAMAGE_RLPLAYER; // Setup projectile damage (Base + Random, Splash)
	if (VectorIsAllZeros(self.pos3)) self.pos3 = '300 500 40'; // Attack 2 - Setup projectile speed, splash damage
	if (VectorIsAllZeros(self.dest2)) self.dest2 = '0 0 96'; // Attack 2 - Spawn location (offset from origin)
	self.classtype = CT_MONXXCHTHON;
	self.classgroup = CG_BOSS;
	self.style = 0;
	Resist_ChangeType(self,-1); // Always reset Ammo Resistance to be consistent
	self.resist_fire = 1;
	self.th_stand = self.th_walk = self.th_run = SUB_Null;
	self.th_missile = self.th_die = SUB_Null;
	self.th_pain = SUB_Null_pain;
	monster_start();
	if (self.targetname == "") xxchthon_awake();
	else self.use = xxchthon_awake;
};
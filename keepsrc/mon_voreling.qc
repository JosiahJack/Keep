//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by W. Josiah Jack, aka Qmaster
//
// Attributions: Quoth, Arcane Dimensions (AD), Kell, Necros, Preach
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
// Function count: 121
//
// Implements: Voreling, Swampling
//
// Description:
// A baby vore that bites your kneecaps off, can start hanging from the
// ceiling, and can be found in all sorts of places such as inside breakables.
//
// AD added the growing effect when spawning from an egg as a minion dropped by
// momma vores.  AD also added large purple variant that attacks with toxic
// (poisonous) spit.
//
// The monster_swampling variant is a slimy poisonous green version.
//=============================================================================

$frame idle1 idle2 idle3 idle4 idle5 idle6 idle7 idle8
$frame idle9 idle10 idle11 idle12 idle13
$frame idleup1 idleup2 idleup3 idleup4 idleup5 idleup6 
$frame drop1 drop2 drop3 drop4 drop5
$frame grow1 grow2 grow3 grow4 grow5 grow6 grow7 grow8 grow9 grow10
$frame walk1 walk2 walk3 walk4 walk5
$frame run1 run2 run3 run4
$frame jump1 jump2 jump3 jump4 jump5 jump6 // Jumping up
$frame bite1 bite2 bite3 bite4 bite5 bite6 bite7 // Bite attack
$frame pain1 pain2 // Extremely short pain set
$frame death1 death2 death3 death4 death5 death6 // fall over and die
$frame deathB1 deathB2 deathB3 deathB4 deathB5 deathB6 deathB7 // body flies up and then back to the ground
$frame base1 base2 // Not used, modelling templates

void()	voreling_idle1	= [	$idle1,	voreling_idle2	] { monster_idle_sound(); ai_stand(); };
void()	voreling_idle2	= [	$idle2,	voreling_idle3	] { ai_stand(); };
void()	voreling_idle3	= [	$idle3,	voreling_idle4	] { ai_stand(); };
void()	voreling_idle4	= [	$idle4,	voreling_idle5	] { ai_stand(); };
void()	voreling_idle5	= [	$idle5,	voreling_idle6	] { ai_stand(); };
void()	voreling_idle6	= [	$idle6,	voreling_idle7	] { ai_stand(); };
void()	voreling_idle7	= [	$idle7,	voreling_idle8	] { ai_stand(); };
void()	voreling_idle8	= [	$idle8,	voreling_idle9	] { ai_stand(); };
void()	voreling_idle9	= [	$idle9,	voreling_idle10	] { ai_stand(); };
void()	voreling_idle10	= [	$idle10,voreling_idle11	] { ai_stand(); };
void()	voreling_idle11	= [	$idle11,voreling_idle12	] { ai_stand(); };
void()	voreling_idle12	= [	$idle12,voreling_idle13	] { ai_stand(); };
void()	voreling_idle13	= [	$idle13,voreling_idle1	] { ai_stand(); };

void()	voreling_walk1	= [	$walk1,	voreling_walk2	] { monster_idle_sound(); ai_walk(4); };
void()	voreling_walk2	= [	$walk2,	voreling_walk3	] { monster_footstep(FALSE); ai_walk(3); };
void()	voreling_walk3	= [	$walk3,	voreling_walk4	] { ai_walk(4); };
void()	voreling_walk4	= [	$walk4,	voreling_walk5	] { ai_walk(5); };
void()	voreling_walk5	= [	$walk5,	voreling_walk1	] { ai_walk(5); };

void() voreling_runpause = { // [FUNCTION]
	if (!self.enemy) return; // Do nothing is not to fight or dead
	if (self.health < 1) return;

	if (self.jump_flag < time) self.th_run();
	self.enemydist = range_distance(self.enemy, FALSE); // Is the enemy too close? no more pausing, fight!
	if (self.enemydist < MONAI_RUNPAUSE) self.th_run();
};

void()	voreling_runp1	= [	$idle1,	voreling_runp2	] { voreling_runpause(); };
void()	voreling_runp2	= [	$idle2,	voreling_runp3	] { voreling_runpause(); };
void()	voreling_runp3	= [	$idle3,	voreling_runp4	] { voreling_runpause(); };
void()	voreling_runp4	= [	$idle4,	voreling_runp5	] { voreling_runpause(); };
void()	voreling_runp5	= [	$idle5,	voreling_runp6	] { voreling_runpause(); };
void()	voreling_runp6	= [	$idle6,	voreling_runp7	] { voreling_runpause(); };
void()	voreling_runp7	= [	$idle7,	voreling_runp8	] { voreling_runpause(); };
void()	voreling_runp8	= [	$idle8,	voreling_runp9	] { voreling_runpause(); };
void()	voreling_runp9	= [	$idle9,	voreling_runp10	] { voreling_runpause(); };
void()	voreling_runp10	= [	$idle10,voreling_runp11	] { voreling_runpause(); };
void()	voreling_runp11	= [	$idle11,voreling_runp12	] { voreling_runpause(); };
void()	voreling_runp12	= [	$idle12,voreling_runp13	] { voreling_runpause(); };
void()	voreling_runp13	= [	$idle13,voreling_runp1	] { voreling_runpause(); };

void(float dist) voreling_checkpause = { // [FUNCTION]
	if (!self.enemy) return; // Do nothing is not to fight or dead
	if (self.health < 1) return;

	self.movespeed = self.movespeed + 1; // Make vorelings run in bursts of
										 // speed and reset every run cycle.
	ai_run(dist + self.movespeed); // Do run code to check for enemies
	if (self.enemydist < MONAI_RUNPAUSE) return; // Too close

	// Random chance to stop and pause running
	if (self.movespeed > 7 && random() < 0.2) {
		self.jump_flag = time + random();
		self.think = voreling_runp1;
	}
};

void()	voreling_run1 = [$run1, voreling_run2 ] { // [FUNCTION]
	self.movespeed = 0;
	monster_idle_sound();
	voreling_checkpause(8);
	// Vorelings have constant problems with weird angles (X/Z)
	// Just keep resetting them so they move normally
	ai_resetangles();
};
void()	voreling_run2 = [$run2, voreling_run3 ] { monster_footstep(FALSE); voreling_checkpause(6); };
void()	voreling_run3 = [$run3, voreling_run4 ] { voreling_checkpause(8); };
void()	voreling_run4 = [$run4, voreling_run5 ] { voreling_checkpause(10); };
void()	voreling_run5 = [$run1, voreling_run6 ] { voreling_checkpause(8); };
void()	voreling_run6 = [$run2, voreling_run7 ] { monster_footstep(FALSE); voreling_checkpause(6); };
void()	voreling_run7 = [$run3, voreling_run8 ] { voreling_checkpause(8); };
void()	voreling_run8 = [$run4, voreling_run1 ] { voreling_checkpause(10); };

void()	voreling_slide1	= [	$walk1,		voreling_slide2	] { ai_run_slide(6); monster_idle_sound(); };
void()	voreling_slide2	= [	$walk2,		voreling_slide3	] { ai_run_slide(4); };
void()	voreling_slide3	= [	$walk3,		voreling_slide4	] { ai_run_slide(6); };
void()	voreling_slide4	= [	$walk4,		voreling_slide5	] { ai_run_slide(4); };
void()	voreling_slide5	= [	$walk5,		voreling_run1	] { ai_run(4); };

// VORELING 2 - PURPLE/POISON SPIT FUNCTIONS (range)
void(float sideang) voreling_spitacid = { // [FUNCTION]
	local vector org, ang, dir, avel;
	local string snd;
	local float projtype;
	
	if (!self.enemy) return;
	if (self.health < 1) return;

	if (self.classtype == CT_MONSWAMPLING) {
		snd = "ad171/swampling/spit4.wav";
		projtype = CT_PROJ_SWAMP;
	} else if (self.classtype == CT_MONSPIDER) {
		snd = self.idle_sound2;
		projtype = CT_PROJ_SPID;
	} else {
		snd = "ad171/spider/hiss2.wav";
		projtype = CT_PROJ_VORE;
	}
		
	// Flash effect to show where bolt is coming from	
	self.effects = self.effects | EF_MUZZLEFLASH;
	if (sideang < 0) sound(self,CHAN_WEAPON,snd,1,ATTN_NORM);
	makevectors(self.angles);	
	org = self.origin + attack_vector(self.attack_offset);

	// Create elevation angle and use makevectors to create projectile direction
	ang = vectoangles(self.enemy.origin - org);
	ang_x = -self.attack_elev;	// Negative = upwards angle 
	makevectors(ang);
	// fire spit in arc pattern (sideang)
	dir = (v_forward * SPEED_VORELING + v_right * sideang);	
	avel = vecrand(100,200,FALSE);
	launch_projectile(org,dir,avel,projtype,1);
};

void()	voreling_spit1 = [$pain1, voreling_spit2 ] { ai_face(); self.attack_elev = SUB_Elevation(ELEV_DEFAULT, self.origin, self.enemy.origin, SPEED_VORELING); };
void()	voreling_spit2 = [$pain2, voreling_spit3 ] { ai_face(); self.attack_elev = SUB_Elevation(self.attack_elev, self.origin, self.enemy.origin, SPEED_VORELING); };
void()	voreling_spit3 = [$bite1, voreling_spit4 ] { ai_face(); self.attack_elev = SUB_Elevation(self.attack_elev, self.origin, self.enemy.origin, SPEED_VORELING); };
void()	voreling_spit4 = [$bite2, voreling_spit5 ] { voreling_spitacid(-0.1); };
void()	voreling_spit5 = [$bite3, voreling_spit6 ] { voreling_spitacid(0); };
void()	voreling_spit6 = [$bite4, voreling_spit7 ] { voreling_spitacid(0.1); };
void()	voreling_spit7 = [$bite5, voreling_spit8 ] {};
void()	voreling_spit8 = [$bite6, voreling_spit9 ] {};
void()	voreling_spit9 = [$bite7, voreling_run1 ] {};

// BITE
void() voreling_melee = { // [FUNCTION]
	local float ldmg;

	if (!self.enemy) return;
	if (self.health < 1) return;
		
	ai_charge(10);			// Get closer for extra bite
	ai_damagebreakable(10);	// Damage any breakables
	if (!ai_checkmelee(self.meleerange,self.meleerangez)) return;	// Too far away
	if (!self.enemy.takedamage) return; // Can the target bleed?

	if (self.classtype == CT_MONSPIDER) {
		if (random() < 0.5) sound(self,CHAN_WEAPON,"ad171/spider/attackmunch.wav", TRUE, TRUE);
		else sound(self,CHAN_WEAPON,"ad171/spider/attacktear.wav", TRUE, TRUE);
	} else {
		if (random() < 0.5) sound(self,CHAN_VOICE, "quoth/voreling/bitestrt.wav", TRUE, TRUE);
		else {
			if (random() < 0.5) sound(self,CHAN_VOICE, "quoth/voreling/bite.wav", TRUE, TRUE);
			else sound(self,CHAN_VOICE, "ad171/voreling/attacktear.wav", TRUE, TRUE);
		}
	}

	if (self.poisonous) PoisonDeBuff(self.enemy);
	ldmg = SUB_ClampFloat((random() + random() + random()) * 3,1,9); // Very weak.
	T_Damage(self.enemy,self,self,ldmg,DAMARMOR);
	spawn_touchblood(self,self.enemy,ldmg * 3);
};

void()	voreling_bite1	= [	$bite1, voreling_bite2	] { ai_face(); };
void()	voreling_bite2	= [	$bite2, voreling_bite3 ] { ai_face(); }; 
void()	voreling_bite3	= [	$bite3, voreling_bite4 ] { ai_face(); };
void()	voreling_bite4 = [	$bite4, voreling_bite5 ] { voreling_melee(); };
void()	voreling_bite5 = [	$bite5, voreling_bite6 ] {};
void()	voreling_bite6 = [	$bite6, voreling_bite7 ] {
	if (ai_checkmelee(self.meleerange,self.meleerangez) && self.enemy.health > 0) self.think = voreling_bite2; }; // Exit bite attack loop
void()	voreling_bite7	= [	$bite7, voreling_run1	] {};

void()	Voreling_JumpTouch = { // [FUNCTION]
	local float ldmg;

	if (self.health <= 0) return;
	ai_jumpbreakable(20);			// Damage any breakables
	self.touch = SUB_Null;			// No more touching
	self.count = self.count + 1;	// Total amount of touch jumps
	self.think = self.th_jumpexit;	// Exit frame
	self.jumptouch = other;			// Keep track of touch target

	// Do not damage other vorelings with jump attacks
	// Prevents packs from killing themselves
	if ((self.classtype != other.classtype || Align_Opposing(self,other))
		&& other.takedamage) {
		if (vlen(self.velocity) > 300 ) {
			ldmg = 5 + 5*random();
			ldmg = Align_DamageModifier(other,self,ldmg, TRUE);
			T_Damage(other,self,self,ldmg,DAMARMOR);	
			spawn_touchblood(self,self.enemy,ldmg*3);
		}
	}

	// Is the voreling floating in the air?
	if (!checkbottom(self)) {
		// Is the voreling standing on something?
		if (self.flags & FL_ONGROUND) {	
			// Do an extra jump if got the count
			if (self.count < 2)  self.think = self.th_jump;
		}
	}

	self.nextthink = time + 0.1;
};

void() voreling_leap1	= [	$jump1, voreling_leap2	] { ai_face();
	self.jump_flag = time + MONAI_JUMPTIMEOUT; // Stop jumping so much
	monster_idle_sound();
};
void() voreling_leap2	= [	$jump2, voreling_leap3	] { ai_face(); };
void() voreling_leap3	= [	$jump3, voreling_leap4	] {
	ai_face();
	self.jump_flag = time + MONAI_JUMPTIMEOUT; // Stop jumping so much
	self.touch = Voreling_JumpTouch;
	makevectors(self.angles);
	self.velocity = (v_forward*self.jumpdist_x) + ('0 0 1'*self.jumpdist_z);
	self.origin_z = self.origin_z + 4;
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	self.oldorigin = self.origin;
};

// Flying through the air waiting to touch something!
void() voreling_leap4	= [	$jump4, voreling_leap5	] {};
void() voreling_leap5	= [	$jump5, voreling_leap6 ] {};	
void() voreling_leap6	= [	$jump6, voreling_leap7	] {
	// Double check monster is still falling?
	if (VectorIsAllZeros(self.velocity) || self.oldorigin == self.origin) {
		self.ideal_yaw = random() * 360; //random jump angle
		self.think = voreling_leap3;
	}
	self.oldorigin = self.origin;
};

void() voreling_leap7 = [$jump3, voreling_leap8 ] { monster_footstep(FALSE); };
void() voreling_leap8 = [$jump2, voreling_leap9 ] { monster_footstep(FALSE); };
void() voreling_leap9 = [$jump1, voreling_run1	] { ai_resetangles(); };


// CEILING VORELINGS - Idle/Drop/Touch/Land functions

void()	voreling_idleup1 = [$idleup1, voreling_idleup2] { monster_idle_sound(); ai_stand(); };
void()	voreling_idleup2 = [$idleup2, voreling_idleup3] { ai_stand(); };
void()	voreling_idleup3 = [$idleup3, voreling_idleup4] { ai_stand(); };
void()	voreling_idleup4 = [$idleup4, voreling_idleup5] { ai_stand(); };
void()	voreling_idleup5 = [$idleup5, voreling_idleup6] { ai_stand(); };
void()	voreling_idleup6 = [$idleup6, voreling_idleup1] { ai_stand(); };

void() voreling_droptouch = { // [FUNCTION]
	// Check if landed on something that is not the ground?
	if (!checkbottom(self)) {
		// Is the voreling standing on something?
		if (self.flags & FL_ONGROUND) {
			SUB_RemoveFlags(self,FL_ONGROUND);
			self.origin_z = self.origin_z + 8;
			setorigin(self, self.origin);	// raise up
			self.attack_timer = time + 1;	// reset timer
			makevectors(self.angles);
			self.velocity = v_forward * 100 + '0 0 200';
		}
		return;
	}

	// No more flying, back to running
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setsize(self,self.bbmins,self.bbmaxs);
	self.view_ofs = '0 0 24';		// Restore view offset
	self.touch = SUB_Null;			// No more jump touching
	FoundHuntTarget(TRUE);			// Setup goals and warn other monsters
	if (self.enemy.flags & FL_CLIENT) monster_sightsound();
	self.th_stand = voreling_idle1; // Restore all thinks, off ceiling now.
	self.th_walk = voreling_walk1;
	self.th_run = voreling_run1; 
	self.th_slide = voreling_slide1;
	self.th_melee = voreling_bite1;

	// Voreling 1 and 2 have different range attacks
	if (self.spawnflags & MON_VORELING_LARGE) self.th_missile = voreling_spit1;
	else self.th_jump = voreling_leap1;

	// Back to running or standing around!
	if (!self.enemy) self.think = self.th_stand;
	else self.think = self.th_run;
	self.nextthink = time + 0.1;
};

void()	voreling_drop1	= [	$drop1,	voreling_drop2	] {};
void()	voreling_drop2	= [	$drop2,	voreling_drop3	] {};
void()	voreling_drop3	= [	$drop3,	voreling_drop4	] {};
void()	voreling_drop4	= [	$drop4,	voreling_drop5	] {};
void()	voreling_drop5	= [	$drop5,	voreling_drop5	] {
	if (self.attack_timer < time || self.velocity_z == 0) voreling_droptouch();
};

void() voreling_wakeup = { // [FUNCTION]
	if (self.health < 1) return; // Dead already?

	// No longer need cling to ceiling spawnflag, remove it
	self.spawnflags = self.spawnflags - (self.spawnflags & MON_VORELING_CEILING);
	self.th_walk = self.th_run = self.th_slide = SUB_Null; // Only wakeup once.
	self.flags = FL_MONSTER;			// reset flags
	if (engine == ENG_FITZ) self.origin_z = self.origin_z - 8;
	else self.origin_z = self.origin_z - 32;	// Unstick from ceiling
	setorigin(self, self.origin);		// Move down slightly
	self.movetype = MOVETYPE_TOSS;		// Affected by gravity
	self.solid = SOLID_SLIDEBOX;
	self.attack_timer = time + 1;		// Stuck timer
	self.classmove = MON_MOVEWALK;		// Back to walking/running 
	self.pain_finished = time + 1.5;	// No pain
	SUB_AttackFinished(2 + random());	// No attacking for short bit
	makevectors(self.angles);			// Move towards face direction
	self.velocity = v_forward * 50;		// Slight nudge forward
	self.touch = voreling_droptouch;	// Touch something?
	if (!self.jump_flag) 
	self.jump_flag = time + 1 + random()*2;	// Don't jump straight away
	voreling_drop1();						// Turn around, cat tricks!
};

// MINION - Grow and spin up from nothing
void() voreling_grow1 = [$grow1, voreling_grow2 ] {};
void() voreling_grow2 = [$grow2, voreling_grow3 ] { SUB_GrowAngle(); };
void() voreling_grow3 = [$grow3, voreling_grow4 ] { SUB_GrowAngle(); };
void() voreling_grow4 = [$grow4, voreling_grow5 ] { SUB_GrowAngle(); };
void() voreling_grow5 = [$grow5, voreling_grow6 ] { SUB_GrowAngle(); };
void() voreling_grow6 = [$grow6, voreling_grow7 ] { SUB_GrowAngle(); };
void() voreling_grow7 = [$grow7, voreling_grow8 ] { SUB_GrowAngle(); };
void() voreling_grow8 = [$grow8, voreling_grow9 ] { SUB_GrowAngle(); };
void() voreling_grow9 = [$grow9, voreling_grow10] { SUB_GrowAngle(); };
void() voreling_grow10= [$grow10, voreling_run1 ] {
	if (!InOpenOrLiquid(self.origin)) { // Is the voreling stuck? cannot move?
		self.health = self.gibhealth;
		Killed(self,self); // Time to die!
	} else {
		self.angles_y = self.angles_y + self.lefty; // Spin to original position
		FoundHuntTarget(TRUE); // Setup goals and warn other monsters
		self.th_stand = voreling_idle1; // Restore all think state functions
		self.th_walk = voreling_walk1;
		self.th_run = voreling_run1; 
		self.th_slide = voreling_slide1;
		self.th_melee = voreling_bite1;
		// Large variants have different range attacks
		if (self.spawnflags & MON_VORELING_LARGE) self.th_missile = voreling_spit1;
		else {
			self.th_jump = voreling_leap1;
			self.th_jumpexit = voreling_leap7;
		}
	}
};
void() voreling_grow = { // [FUNCTION]
	// Only call wakeup function once
	self.th_stand = self.th_walk = self.th_run  = SUB_Null;
	if (random() < 0.5) self.lefty = 36;
	else self.lefty = -36;
	monster_sightsound();
	voreling_grow1();
};

void() voreling_pain1	= [	$pain1,	voreling_pain2	] {}; // [FUNCTION]
void() voreling_pain2	= [	$pain2,	voreling_run1	] {}; // [FUNCTION]

void(entity inflictor, entity attacker, float damage) voreling_pain = { // [FUNCTION]
	// Has the voreling been hit while on the ceiling?
	if (self.spawnflags & MON_VORELING_CEILING) {
		self.pain_finished = time + 1;
		voreling_wakeup();
		return;
	}
		
	// Check all pain conditions and set up what to do next
	monster_pain_check(attacker, damage);

	// Any pain animation/sound required?
	if (self.pain_check > 0) {
		sound(self,CHAN_VOICE, self.pain_sound,1,ATTN_NORM);
		self.pain_finished = time + 1;

		if (self.pain_check == 1) voreling_pain1();
		else if (self.pain_check == 2) {
			// reset axe hit and setup short pain recovery
			self.pain_finished = time + 0.2;
			self.axhitme = 0;
			voreling_pain1();
		}
	}
};

void() voreling_die1 = [	$death1, voreling_die2	] {};
void() voreling_die2 = [	$death2, voreling_die3	] { monster_check_gib(); };
void() voreling_die3 = [	$death3, voreling_die4	] { monster_check_gib(); self.solid = SOLID_NOT; };
void() voreling_die4 = [	$death4, voreling_die5	] {};
void() voreling_die5 = [	$death5, voreling_die6	] { monster_death_postcheck(); };
void() voreling_die6 = [	$death6, voreling_die6	] { monster_deadbody_check(); };

void() voreling_dieB1 = [	$deathB1, voreling_dieB2	] {};
void() voreling_dieB2 = [	$deathB2, voreling_dieB3	] { monster_check_gib(); };
void() voreling_dieB3 = [	$deathB3, voreling_dieB4	] { monster_check_gib(); self.solid = SOLID_NOT; };
void() voreling_dieB4 = [	$deathB4, voreling_dieB5	] {};
void() voreling_dieB5 = [	$deathB5, voreling_dieB6	] {};
void() voreling_dieB6 = [	$deathB6, voreling_dieB7	] { monster_death_postcheck(); };
void() voreling_dieB7 = [	$deathB7, voreling_dieB7	] { monster_deadbody_check(); };

void() voreling_die = { // [FUNCTION]
	if (self.spawnflags & MON_VORELING_CEILING) self.gibondeath = TRUE; // Has the voreling died while on the ceiling?
	monster_death_precheck(); // Pre-check routine to tidy up extra entities
	if (!self.gibbed) { // regular death
		sound(self,CHAN_VOICE, "quoth/voreling/death.wav",1,ATTN_NORM);
		if (random() < 0.6) voreling_die1();
		else voreling_dieB1();
	}
};

void() monster_voreling_precache = { // [FUNCTION]
	precache_model("progs/ad171/mon_vorelingp.mdl");
	precache_model("progs/ad171/gib_vorelegp.mdl");
	precache_model(MODEL_PROJ_VORE);			// Spit Projectile
	precache_model("progs/ad171/mon_voreling.mdl");
	precache_model("progs/q15/gib_voreleg.mdl");
	precache_sound("quoth/voreling/idle.wav");
	precache_sound("quoth/voreling/death.wav"); // death/pain/attack sounds
	precache_sound("quoth/voreling/pain.wav");
	precache_sound("ad171/wraith/bounce.wav");	// Spit misses
	precache_sound("ad171/spider/hiss2.wav");	// Spit attack
	precache_sound("quoth/voreling/bitestrt.wav");
	precache_sound("quoth/voreling/bite.wav");
	precache_sound("ad171/voreling/attacktear.wav");
	precache_sound("quoth/voreling/land.wav");
	precache_sound("quoth/voreling/sight.wav");
};

void() monster_swampling_precache = { // [FUNCTION]
	monster_voreling_precache();
	precache_model("progs/ad171/mon_swamplingp.mdl");
	precache_model("progs/ad171/gib_swamplegp.mdl");
	precache_model("progs/ad171/mon_swampling.mdl");
	precache_model("progs/ad171/gib_swampleg.mdl");
	precache_model(MODEL_PROJ_SWAMP);			// Spit Projectile
	precache_poisongibs();
	precache_sound("ad171/swampling/idle1.wav");
	precache_sound("ad171/swampling/idle3.wav");
	precache_sound("ad171/swampling/idle2.wav");
	precache_sound("ad171/swampling/pain3.wav");
	precache_sound("ad171/swampling/spit4.wav");	// Spit attack
	precache_sound("ad171/swampling/sight2.wav");
};

void() setup_voreling;

// QUAKED monster_voreling (1 0 0) (-16 -16 -24) (16 16 24) Ambush
void() monster_voreling = {
	if (monster_checkrandomizer() == TRUE) return; // Check for any random monster setups

	if (self.spawnflags & MON_VORELING_LARGE) {
		if (self.mdl == "") self.mdl = "progs/ad171/mon_vorelingp.mdl";
		if (self.gib1mdl == "") self.gib1mdl = "progs/ad171/gib_vorelegp.mdl";	// Single Leg
	}
	if (!(self.spawnflags & MON_VORELING_LARGE) || 
		self.classtype == CT_CACHEVORELING) {
		if (self.mdl == "") self.mdl = "progs/ad171/mon_voreling.mdl";
		if (self.gib1mdl == "") self.gib1mdl = "progs/q15/gib_voreleg.mdl";		// Single Leg, q15 has added frame
	}
	
	if (self.idle_sound == "") self.idle_sound = "quoth/voreling/idle.wav"; // IDLE/COMBAT and SIGHT sounds
	if (self.pain_sound == "") self.pain_sound = "quoth/voreling/pain.wav";
	if (self.sight_sound == "") self.sight_sound = "quoth/voreling/sight.wav";
	if (self.classtype != CT_CACHEVORELING) setup_voreling(); // Cache voreling is a special class used for precache only
};

void() monster_swampling = { // [ENTITY]
	self.classtype = CT_MONSWAMPLING;
	if (self.spawnflags & MON_VORELING_LARGE) {
		self.mdl = "progs/ad171/mon_swamplingp.mdl";
		self.gib1mdl = "progs/ad171/gib_swamplegp.mdl";	// Single Leg
	} else {
		self.mdl = "progs/ad171/mon_swampling.mdl";
		self.gib1mdl = "progs/ad171/gib_swampleg.mdl";	// Single Leg
	}
	self.idle_sound = "ad171/swampling/idle1.wav"; // IDLE/COMBAT and SIGHT sounds
	self.idle_sound2 = "ad171/swampling/idle3.wav";
	self.idle_soundcom = "ad171/swampling/idle2.wav";
	self.pain_sound = "ad171/swampling/pain3.wav";
	self.sight_sound = "ad171/swampling/sight2.wav";
	if (self.poisonous == 0) self.poisonous = TRUE;
	if (self.deathstring == "") self.deathstring = " was bitten by a Swampling\n";
	setup_voreling(); // Cache voreling is a special class used for precache only
};

void() monster_shalrathminion = { 
	self.classtype = CT_CACHEVORELING; 
	self.spawnflags = MON_VORELING_LARGE;	// Precache both vorelings
	monster_voreling();
};

void() setup_voreling = { // [FUNCTION]
	self.solid = SOLID_NOT;				// No interaction with world
	self.movetype = MOVETYPE_NONE;		// Static item, no movement
	if (self.bboxtype < 1) self.bboxtype = BBOX_TINY;
	self.gibbed = FALSE;
	if (random() < 0.5) self.gftype = MON_NOGIBVELOCITY; // Vorelings are small, gibs don't bounce far
	self.pain_flinch = 10;				// Always flinch
	self.steptype = FS_TYPELIGHT;
	self.pain_longanim = TRUE;			// can be chopped with shadow axe
	self.blockudeath = TRUE;			// No humanoid death sound
	self.meleeoffset = '20 0 0';		// Bite attack offset
	self.meleerange = MONAI_MELEESPIDER;
	self.meleerangez = 0;
	self.attack_offset = '14 0 8';		// Used by purple voreling, at jaws
	self.movespeed = 1;					// Can never be a turret
	Resist_ChangeType(self,-1); // Always reset Ammo Resistance to be consistent
	if (self.deathstring == "") self.deathstring = " was nibbled by a Voreling\n";
	self.th_checkattack = VorelingCheckAttack;
	self.meleerange = MONAI_MELEEVORELING;
	self.meleerangez = 48;
	self.th_pain = voreling_pain;
	self.th_die = voreling_die;
	if (!self.classtype) self.classtype = CT_MONVORELING;
	self.classgroup = CG_SPIDER;
	self.classmove = MON_MOVEWALK;

	// Setup white/purple voreling difference
	if (self.spawnflags & MON_VORELING_LARGE) {
		if (self.health < 1) self.health = 60;
		self.gibhealth = -25;
		self.th_missile = voreling_spit1;
	} else {
		if (self.health < 1) self.health = 30;
		self.gibhealth = -20;
		self.th_jump = voreling_leap1;
		self.th_jumpexit = voreling_leap7;
		// Default jump forward/up distance
		if (VectorIsAllZeros(self.jumpdist)) self.jumpdist = '500 0 200';
		if (self.jumprange_x <= 0) self.jumprange_x = MONAI_JUMPVORELINGNEAR;
		if (self.jumprange_y <= self.jumprange_x) self.jumprange_y = MONAI_JUMPVORELINGFAR;
	}

	// Check for quoth on ceiling entity flag
	if (self.dangle) {
		self.spawnflags = self.spawnflags | MON_VORELING_CEILING;
	}

	// Ceiling vorelings have special idle animation and need to let go of the ceiling before resuming any normal behaviour (most think functions are intercepted)
	if (self.spawnflags & MON_VORELING_CEILING) {
		self.th_stand = self.th_walk = voreling_idleup1;
		self.th_run = self.th_slide = voreling_wakeup;
		self.th_melee = self.th_missile = self.th_jump = voreling_wakeup; // th_pain and th_die functions understand ceiling vorelings
	} else if (self.classtype == CT_MINIONVORELING) {
		// Special spawning minion need to start spinning
		self.th_stand = self.th_walk = self.th_run = voreling_grow;
		self.th_melee = self.th_slide = SUB_Null;
		self.th_missile = self.th_jump = SUB_Null;
	} else {
		// Default voreling behaviour functions
		self.th_stand = voreling_idle1;
		self.th_walk = voreling_walk1;
		self.th_run = voreling_run1;
		self.th_melee = voreling_bite1;
		self.th_slide = voreling_slide1;
	}
	
	monster_start();
};

// A code way to spawn vorelings (requires monster_shalrathminion entity)
void(vector minion_org, entity minion_targ) minion_voreling = { // [FUNCTION]
	local entity minion;

	// Check if there is space to spawn entity
	if (!InOpenOrLiquid(minion_org)) return;
	
	update_minioncount(self.owner, 1);		// Update spawn counters
	minion = spawn();
	minion.classname = "monster_voreling";	// For function searching
	setorigin(minion, minion_org);			// Move to new location
	minion.owner = self.owner;				// Spawner Parent Link
	self.owner = minion;					// Stop gibs interacting with minion
	minion.effects = minion.flags = 0;		// make sure are blank
	minion.gibondeath = 1;					// Always gib on death
	minion.classtype = CT_MINIONVORELING;	// Special minion class
	minion.enemy = minion_targ;				// Target to attack
	minion.spawnflags = 0;
	minion.minion_active = TRUE;			// Minion flag
	minion.bodyfadeaway = TRUE;				// Get rid of body
	if (random() < 0.2) minion.spawnflags = MON_VORELING_LARGE;
	else minion.spawnflags = 0;

	if (minion.spawnflags & MON_VORELING_LARGE) {
		minion.mdl = "progs/ad171/mon_vorelingp.mdl";		// Purpler horror
		minion.gib1mdl = "progs/ad171/gib_vorelegp.mdl";	// Single Leg
	} else {	
		minion.mdl = "progs/ad171/mon_voreling.mdl";		// Creamy delight
		minion.gib1mdl = "progs/q15/gib_voreleg.mdl"; // Single Leg, q15 has added frame
	}
	
	minion.idle_sound = "quoth/voreling/idle.wav";
	minion.sight_sound = "quoth/voreling/sight.wav";
	minion.pain_sound = "quoth/voreling/pain.wav";
	minion.nextthink = time + 0.01;
	minion.think = setup_voreling;
};
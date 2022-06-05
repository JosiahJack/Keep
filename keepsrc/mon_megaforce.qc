/*==============================================================================
 Mega Enforcer (Original from Zerstorer MOD)
 * I Added Yellow skin and modified blue skin to match better
 
 Originally had 150 HP, fired a plasma bolt and 'drunk' rockets
 The shield was a 100% no damage setup and only down when attacking.
 Personally I found the shield confusing at first because it
 never had any visual feedback that nothing was doing damage.
 
 
 
==============================================================================*/

// 000-007 (No Shield)
$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7

// 008-022 (Shield active)
$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8
$frame walk9 walk10 walk11 walk12 walk13 walk14 walk15 walk16

// 023-030 (Shield active)
$frame run1 run2 run3 run4 run5 run6 run7 run8

// 031-050 (Plasma Cannon)
$frame attack1 attack2 attack3 attack4 attack5 attack6 attack7 attack8
$frame attack9 attack10 attack11 attack12 attack13 attack14 attack15 attack16
$frame attack17 attack18 attack19 attack20

// 051-064 (No Shield)
$frame death1 death2 death3 death4 death5 death6 death7 death8
$frame death9 death10 death11 death12 death13 death14

// 065-075 (No Shield)
$frame fdeath1 fdeath2 fdeath3 fdeath4 fdeath5 fdeath6 fdeath7 fdeath8
$frame fdeath9 fdeath10 fdeath11

// A=076-079 B=080-084 C=085-092 D=093-111
$frame paina1 paina2 paina3 paina4
$frame painb1 painb2 painb3 painb4 painb5
$frame painc1 painc2 painc3 painc4 painc5 painc6 painc7 painc8
// Stumble forward
$frame paind1 paind2 paind3 paind4 paind5 paind6 paind7 paind8
$frame paind9 paind10 paind11 paind12 paind13 paind14 paind15 paind16
$frame paind17 paind18 paind19

// 112-118 (Rocket Attack)
$frame attackp1 attackp2 attackp3 attackp4 attackp5 attackp6 attackp7

// 119-125 (Shield turns on/off)
$frame fieldon1 fieldon2 fieldon3 fieldon4 fieldon5 fieldon6 fieldon7

// Shield status (IDLE=OFF, WALK=ON, RUN=ON)
float MEGAF_IDLE = 0;
float MEGAF_WALK = 1;
float MEGAF_RUN = 2;

void() megaf_shieldon = {
	self.takedamage = DAMAGE_YES;	// Grenades bounce off
	self.bouncegrenade = TRUE;		// Warning to other monsters
	self.reflectlightning = TRUE;	// Reflect lightning strikes
	self.reflectplasma = TRUE;		// Reflect plasma projectiles
	self.reflectnails = TRUE;		// Reflect nail projectiles
	// Visually show resistance and reduce damage taken
	self.resist_shells = self.resist_nails = 0.5;
	self.resist_rockets = self.resist_cells = 0.5;
	self.resist_plasma = 0.5;
	self.resist_multi_rockets = 0.5;
	// Lava nails pierce armor remember :), not changing that one.
	self.resist_plasma = 0.5;
	self.resist_bolts = 0.5;
	self.resist_poison = self.resist_acid = 0.5;
	// Magical AoA weapons still go through
};

void() megaf_shieldoff = {
	self.takedamage = DAMAGE_AIM;	// Grenades make contact
	self.bouncegrenade = FALSE;		// Reset to default
	self.reflectlightning = FALSE;	// Reflect lightning strikes
	self.reflectplasma = FALSE;		// Reflect plasma projectiles
	self.reflectnails = FALSE;		// Reflect nail projectiles
	self.resist_shells = self.resist_nails = 0;
	self.resist_rockets = 0; self.resist_cells = 0;
	self.resist_plasma = 0;
	self.resist_multi_rockets = 0;
	self.resist_plasma = 0;
	self.resist_bolts = 0;
	self.resist_poison = self.resist_acid = 0;
};

void() megaf_shieldsound_on = {
	sound (self, CHAN_ITEM, "ad181/deflector/shield_on.wav", 1, ATTN_NORM);
};

void() megaf_shieldsound_off = {
	sound (self, CHAN_ITEM, "ad181/deflector/shield_off.wav", 1, ATTN_NORM);
};

void() megaf_shieldparticle = {
	self.pos1 = self.origin;
	// Randomize position from middle to feet (particles float up)
	self.pos1_z = self.pos1_z - (random()*20);
	self.cnt = rint(5 + random()*10);
	particle_explode(self.pos1, self.cnt, 1, PARTICLE_BURST_YELLOW, PARTICLE_BURST_UPWARD); 
};

void() megaf_stands7;	// Forward compiler reference
void() megaf_stand1=[ $stand1, megaf_stand2] {ai_stand();

	// Work out if shield was on before this state
	if (self.weaponstate == MEGAF_WALK && self.health > 0) {
		self.weaponstate = MEGAF_IDLE;
		megaf_stands7();
	}
	// No idle sound at same time as shield sound
	else monster_idle_sound();
};
// Switch off shield (reverse animation)
void() megaf_stands7=[ $fieldon7, megaf_stands6] {ai_stand();
	megaf_shieldoff();megaf_shieldsound_off();};
void() megaf_stands6=[ $fieldon6, megaf_stands5] {ai_stand();};
void() megaf_stands5=[ $fieldon5, megaf_stand2] {ai_stand();};

void() megaf_stand2=[ $stand2, megaf_stand3] {ai_stand();};
void() megaf_stand3=[ $stand3, megaf_stand4] {ai_stand();};
void() megaf_stand4=[ $stand4, megaf_stand5] {ai_stand();};
void() megaf_stand5=[ $stand5, megaf_stand6] {ai_stand();};
void() megaf_stand6=[ $stand6, megaf_stand7] {ai_stand();};
void() megaf_stand7=[ $stand7, megaf_stand1] {ai_stand();};

void() megaf_walks5;	// Forward compiler reference
void() megaf_walk1=[ $walk1, megaf_walk2] {ai_walk(2);
	// Work out if shield was on before this state
	if (self.weaponstate == MEGAF_IDLE && self.health > 0) {
		self.weaponstate = MEGAF_WALK;
		megaf_walks5();
	}
	// No idle sound at same time as shield sound
	else monster_idle_sound();
};
// Switch on shield (forward animation)
void() megaf_walks5=[ $fieldon5, megaf_walks6] {ai_walk(0);
	megaf_shieldon();megaf_shieldsound_on();};
void() megaf_walks6=[ $fieldon6, megaf_walks7] {ai_walk(0);};
void() megaf_walks7=[ $fieldon7, megaf_walk2] {ai_walk(0);};

void() megaf_walk2=[ $walk2, megaf_walk3] {megaf_shieldparticle(); monster_footstep(FALSE);ai_walk(4);};
void() megaf_walk3=[ $walk3, megaf_walk4] {ai_walk(4);};
void() megaf_walk4=[ $walk4, megaf_walk5] {ai_walk(3);};
void() megaf_walk5=[ $walk5, megaf_walk6] {ai_walk(1);};
void() megaf_walk6=[ $walk6, megaf_walk7] {ai_walk(2);};
void() megaf_walk7=[ $walk7, megaf_walk8] {ai_walk(2);};
void() megaf_walk8=[ $walk8, megaf_walk9] {ai_walk(1);};
void() megaf_walk9=[ $walk9, megaf_walk10] {ai_walk(2);};
void() megaf_walk10=[ $walk10, megaf_walk11] {megaf_shieldparticle(); monster_footstep(FALSE); ai_walk(4);};
void() megaf_walk11=[ $walk11, megaf_walk12] {ai_walk(4);};
void() megaf_walk12=[ $walk12, megaf_walk13] {ai_walk(1);};
void() megaf_walk13=[ $walk13, megaf_walk14] {ai_walk(2);};
void() megaf_walk14=[ $walk14, megaf_walk15] {ai_walk(3);};
void() megaf_walk15=[ $walk15, megaf_walk16] {ai_walk(4);};
void() megaf_walk16=[ $walk16, megaf_walk1] {ai_walk(2);};

// Two speed run animation based on enemy visibility
void()	megaf_slow1;
void()	megaf_fast1;

// run state has two animation speeds (single function required)
void(float movespd) megaf_run = {
	// Block all checks if dead
	if (self.health < 1) return;
	// idle functions work for both animation sets
	if (self.walkframe == 0) monster_idle_sound();
	
	// Work out if shield was on/off before this state
	if (self.weaponstate == MEGAF_IDLE) {
		self.weaponstate = MEGAF_RUN;
		megaf_shieldsound_on();
	}
	// Both walk/run animations have shield on!
	megaf_shieldon();
		
	// Change animation set based on enemy visibilty
	// Ignore frame 0 for checks (endless loop)
	// Make sure animations don't switch too rapid (timer)
	if (self.enemy) {
		if (self.walkframe > 0 && self.attack_timer < time) {
			// Prevent rapid switching (attack_timer)
			self.attack_timer = time + 1 + random();
			enemy_vis = visible(self.enemy);
			if (!enemy_vis) self.think = megaf_fast1;
			else self.think = megaf_slow1;
		}
	}
	
	// Check run/attack functions
	ai_run(movespd);
	// Walk through animation sets (reset on frame 0)
	self.walkframe = self.walkframe + 1;
};


// Walk animation with 150% movement speed
void()	megaf_slow1	=[ $walk1,	megaf_slow2	] {self.walkframe=0;megaf_run(3);};
void()	megaf_slow2	=[ $walk2,	megaf_slow3	] {
	megaf_shieldparticle(); monster_footstep(FALSE);megaf_run(6);};
void()	megaf_slow3	=[ $walk3,	megaf_slow4	] {megaf_run(6);};
void()	megaf_slow4	=[ $walk4,	megaf_slow5	] {megaf_run(4.5);};
void()	megaf_slow5	=[ $walk5,	megaf_slow6	] {megaf_run(1.5);};
void()	megaf_slow6	=[ $walk6,	megaf_slow7	] {megaf_run(3);};
void()	megaf_slow7	=[ $walk7,	megaf_slow8	] {megaf_run(3);};
void()	megaf_slow8	=[ $walk8,	megaf_slow9	] {megaf_run(1.5);};
void()	megaf_slow9	=[ $walk9,	megaf_slow10] {megaf_run(3);};
void()	megaf_slow10=[ $walk10, megaf_slow11] {
	megaf_shieldparticle(); monster_footstep(FALSE); megaf_run(6);};
void()	megaf_slow11=[ $walk11, megaf_slow12] {megaf_run(6);};
void()	megaf_slow12=[ $walk12, megaf_slow13] {megaf_run(1.5);};
void()	megaf_slow13=[ $walk13, megaf_slow14] {megaf_run(3);};
void()	megaf_slow14=[ $walk14, megaf_slow15] {megaf_run(4.5);};
void()	megaf_slow15=[ $walk15, megaf_slow16] {megaf_run(6);};
void()	megaf_slow16=[ $walk16, megaf_slow1] {megaf_run(3);};

// Typical run animation (used when enemy out of sight)
void()	megaf_fast1=[ $run1, megaf_fast2] {self.walkframe=0;megaf_run(18);};
void()	megaf_fast2=[ $run2, megaf_fast3] {megaf_run(14);};
void()	megaf_fast3=[ $run3, megaf_fast4] {
	megaf_shieldparticle(); monster_footstep(FALSE); megaf_run(7);};
void()	megaf_fast4=[ $run4, megaf_fast5] {megaf_run(12);};
void()	megaf_fast5=[ $run5, megaf_fast6] {megaf_run(14);};
void()	megaf_fast6=[ $run6, megaf_fast7] {megaf_run(14);};
void()	megaf_fast7=[ $run7, megaf_fast8] {
	megaf_shieldparticle(); monster_footstep(FALSE); megaf_run(7);};
void()	megaf_fast8=[ $run8, megaf_fast1] {megaf_run(11);};

// Melee/Close attack (Plasma Canon)
void() megaf_fire_plasma = {
	local vector org, targ_org, dir;

	if (!self.enemy) return;
	if (self.health < 1) return;

	// Keep adding up projectile counter
	self.attack_chance = self.attack_chance + 1;
	self.effects = self.effects | EF_MUZZLEFLASH;
	self.attack_speed = SPEED_MEGAFBOLT + (skill * SPEED_MEGAFBSKILL);
	sound (self, CHAN_WEAPON, SOUND_PLASMA_FIRE, 1, ATTN_NORM);

	ai_face();
	makevectors (self.angles);
	org = self.origin + attack_vector(self.attack_offset);

	// Aim plasma bolt towards the enemy feet (using view_ofs)
	if (self.enemy.flags & FL_CLIENT) targ_org = self.enemy.origin - '0 0 20';
	else targ_org = self.enemy.origin - self.enemy.view_ofs;
	dir = normalize(targ_org - self.origin);

	launch_plasma(org, dir, CT_MONDEFLECTOR, self.attack_speed);
};

void() megaf_plasma1 = [ $attack1, megaf_plasma2] {};
void() megaf_plasma2 = [ $attack2, megaf_plasma3] {self.attack_chance = self.attack_timer = 0;megaf_shieldoff(); megaf_shieldsound_off();};
void() megaf_plasma3 = [ $attack3, megaf_plasma14] {ai_face();};
// Skipping frames 4-13 - terrible loop material

// Plasma Burn Loop
void() megaf_plasma14 = [ $attack14, megaf_plasma15] {ai_face();sound (self, CHAN_WEAPON, "ad171/enforcer/elim_pg_load.wav", 1, ATTN_NORM);};
void() megaf_plasma15 = [ $attack15, megaf_plasma16] {ai_face();};
void() megaf_plasma16 = [ $attack16, megaf_plasma17] {megaf_fire_plasma();};
void() megaf_plasma17 = [ $attack17, megaf_plasma18] {};
void() megaf_plasma18 = [ $attack18, megaf_plasma19] {};
void() megaf_plasma19 = [ $attack19, megaf_plasma20] {ai_face();
	// Is the enemy active and self alive?
	if (self.enemy && self.health > 0) {
		// Anymore projectiles to fire?
		if (self.attack_chance < MONAI_MEGAFMAX) {
			// Is the enemy still visible?
			if ( visxray(self.enemy, self.attack_offset, '0 0 0', FALSE) ) {
				self.attack_timer = time + 0.8;
			}
			// Is the enemy still in view timer still active?
			if (self.attack_timer > time) self.think = megaf_plasma14;
		}
	}
};

// Plasma Burn Exit
void() megaf_plasma20 = [ $attack20, megaf_slow1] {ai_face();megaf_shieldon();megaf_shieldsound_on();}; // last frame has shield coming on

// RANGE attack (Rocket Launcher)
void(vector orgofs) megaf_fire_rocket = {
	local vector org, dir;
	
	if (!self.enemy) return;
	if (self.health < 1) return;
	
	self.effects = self.effects | EF_MUZZLEFLASH;
	sound (self, CHAN_WEAPON, "ad181/deflector/rocket_fire.wav", 1, ATTN_NORM);	

	ai_face();
	makevectors (self.angles);
	org = self.origin + attack_vector(orgofs);
	dir = normalize(self.enemy.origin - org);

	self.attack_speed = SPEED_MEGAFROCKET + (skill * SPEED_MEGAFRSKILL);
	Launch_Missile (org, dir, '0 0 0', CT_PROJ_DEFLECT1, self.attack_speed);
};

void() megaf_rock4b;	// Forward compiler reference
void() megaf_rock1 = [ $attackp1, megaf_rock2] {self.pain_finished = time + 1.5;sound (self, CHAN_WEAPON, "ad181/deflector/rocket_load.wav", 1, ATTN_NORM);};
void() megaf_rock2 = [ $attackp2, megaf_rock3] {ai_face();megaf_shieldoff(); megaf_shieldsound_off();};
void() megaf_rock3 = [ $attackp3, megaf_rock4] {ai_face();};
void() megaf_rock4 = [ $attackp4, megaf_rock5] {ai_face();};
void() megaf_rock5 = [ $attackp5, megaf_rock6] {megaf_fire_rocket('8 8 28');};
void() megaf_rock6 = [ $attackp6, megaf_rock7] {
	// Fire second rocket for hard/nightmare skill
	if (self.health > 0 && skill > SKILL_NORMAL) {
		ai_face();
		sound (self, CHAN_WEAPON, "ad181/deflector/rocket_load.wav", 1, ATTN_NORM);
		self.think = megaf_rock4b;
	}
};
void() megaf_rock4b = [ $attackp4, megaf_rock5b] {ai_face();};
void() megaf_rock5b = [ $attackp5, megaf_rock6b] {megaf_fire_rocket('8 8 28');};
void() megaf_rock6b = [ $attackp6, megaf_rock7] {};
void() megaf_rock7 = [ $attackp7, megaf_slow1] {megaf_shieldon();megaf_shieldsound_on();}; // last frame has shield coming on

// Classic enforcer 4 pain animation sets
void() megaf_paina1=[ $paina1, megaf_paina2] {};
void() megaf_paina2=[ $paina2, megaf_paina3] {};
void() megaf_paina3=[ $paina3, megaf_paina4] {};
void() megaf_paina4=[ $paina4, megaf_slow1] {megaf_shieldon();megaf_shieldsound_on();}; // Last pain frame has shield coming on

void() megaf_painb1=[ $painb1, megaf_painb2] {};
void() megaf_painb2=[ $painb2, megaf_painb3] {};
void() megaf_painb3=[ $painb3, megaf_painb4] {};
void() megaf_painb4=[ $painb4, megaf_painb5] {};
void() megaf_painb5=[ $painb5, megaf_slow1] {megaf_shieldon();megaf_shieldsound_on();}; // Last pain frame has shield coming on

void() megaf_painc1=[ $painc1, megaf_painc2] {};
void() megaf_painc2=[ $painc2, megaf_painc3] {monster_footstep(FALSE);};
void() megaf_painc3=[ $painc3, megaf_painc4] {};
void() megaf_painc4=[ $painc4, megaf_painc5] {};
void() megaf_painc5=[ $painc5, megaf_painc6] {};
void() megaf_painc6=[ $painc6, megaf_painc7] {};
void() megaf_painc7=[ $painc7, megaf_painc8] {};
void() megaf_painc8=[ $painc8, megaf_slow1] {megaf_shieldon();megaf_shieldsound_on();}; // Last pain frame has shield coming on

void() megaf_paind1=[ $paind1, megaf_paind2] {};
void() megaf_paind2=[ $paind2, megaf_paind3] {};
void() megaf_paind3=[ $paind3, megaf_paind4] {monster_footstep(FALSE);};
void() megaf_paind4=[ $paind4, megaf_paind5] {ai_painforward(2);};
void() megaf_paind5=[ $paind5, megaf_paind6] {ai_painforward(1);};
void() megaf_paind6=[ $paind6, megaf_paind7] {};
void() megaf_paind7=[ $paind7, megaf_paind8] {};
void() megaf_paind8=[ $paind8, megaf_paind9] {};
void() megaf_paind9=[ $paind9, megaf_paind10] {};
void() megaf_paind10=[ $paind10, megaf_paind11] {};
void() megaf_paind11=[ $paind11, megaf_paind12] {ai_painforward(1);};
void() megaf_paind12=[ $paind12, megaf_paind13] {ai_painforward(1);};
void() megaf_paind13=[ $paind13, megaf_paind14] {ai_painforward(1);};
void() megaf_paind14=[ $paind14, megaf_paind15] {};
void() megaf_paind15=[ $paind15, megaf_paind16] {};
void() megaf_paind16=[ $paind16, megaf_paind17] {ai_pain(1);};
void() megaf_paind17=[ $paind17, megaf_paind18] {ai_pain(1);};
void() megaf_paind18=[ $paind18, megaf_paind19] {};
void() megaf_paind19=[ $paind19, megaf_slow1] {megaf_shieldon();megaf_shieldsound_on();}; // Last pain frame has shield coming on

void(entity inflictor, entity attacker, float damage) megaf_pain = {
	// Check all pain conditions and set up what to do next
	monster_pain_check(attacker, damage);

	// Any pain animation/sound required?
	if (self.pain_check > 0) {
		self.lip = random ();
		if (self.lip < 0.5) sound (self, CHAN_VOICE, self.pain_sound, 1, ATTN_NORM);
		else sound (self, CHAN_VOICE, self.pain_sound2, 1, ATTN_NORM);

		megaf_shieldoff(); // Turn off shield
		megaf_shieldsound_off();
		
		if (self.pain_check == 1) {
			// Randomly pick which pain animation to play
			if (self.lip < 0.2) megaf_paina1 ();
			else if (self.lip < 0.4) megaf_painb1 ();
			else if (self.lip < 0.7) megaf_painc1 ();
			else {
				self.pain_finished = time + 2;
				megaf_paind1 ();
			}
		} else if (self.pain_check == 2) { // The new axe forces monsters into long pain animations
			// reset axe hit and setup short pain recovery
			self.pain_finished = time + 1.9;
			self.axhitme = 0;
			megaf_paind1 ();
		}
	}
};

void() megaf_die1=[ $death1, megaf_die2] {};
void() megaf_die2=[ $death2, megaf_die3] {monster_check_gib();};
void() megaf_die3=[ $death3, megaf_die4] {monster_check_gib();self.solid = SOLID_NOT; if (!self.gibbed) DropBackpack();};
void() megaf_die4=[ $death4, megaf_die5] {ai_forward(14);};
void() megaf_die5=[ $death5, megaf_die6] {ai_forward(2);};
void() megaf_die6=[ $death6, megaf_die7] {};
void() megaf_die7=[ $death7, megaf_die8] {};
void() megaf_die8=[ $death8, megaf_die9] {};
void() megaf_die9=[ $death9, megaf_die10] {ai_forward(3);};
void() megaf_die10=[ $death10, megaf_die11] {ai_forward(5);};
void() megaf_die11=[ $death11, megaf_die12] {ai_forward(5);};
void() megaf_die12=[ $death12, megaf_die13] {ai_forward(5);};
void() megaf_die13=[ $death13, megaf_die14] {monster_death_postcheck();};
void() megaf_die14=[ $death14, megaf_die14] {monster_deadbody_check();};

void() megaf_fdie1=[ $fdeath1, megaf_fdie2] {};
void() megaf_fdie2=[ $fdeath2, megaf_fdie3] {monster_check_gib();};
void() megaf_fdie3=[ $fdeath3, megaf_fdie4] {monster_check_gib();self.solid = SOLID_NOT; if (!self.gibbed) DropBackpack();};
void() megaf_fdie4=[ $fdeath4, megaf_fdie5] {};
void() megaf_fdie5=[ $fdeath5, megaf_fdie6] {};
void() megaf_fdie6=[ $fdeath6, megaf_fdie7] {};
void() megaf_fdie7=[ $fdeath7, megaf_fdie8] {};
void() megaf_fdie8=[ $fdeath8, megaf_fdie9] {};
void() megaf_fdie9=[ $fdeath9, megaf_fdie10] {};
void() megaf_fdie10=[ $fdeath10, megaf_fdie11] {monster_death_postcheck();};
void() megaf_fdie11=[ $fdeath11, megaf_fdie11] {monster_deadbody_check();};

void() megaf_die = {
	// Pre-check routine to tidy up extra entities
	monster_death_precheck();

	// regular death
	if (!self.gibbed) {
		// Turn off shield
		megaf_shieldsound_off();

		// Typical forward/backward death + unique sound
		if (random() > 0.5) {
			megaf_die1 ();
			sound (self, CHAN_VOICE, self.death_sound2, 1, ATTN_NORM);
		} else {
			megaf_fdie1 ();
			sound (self, CHAN_VOICE, self.death_sound, 1, ATTN_NORM);
		}
	}
};

void() monster_megaforce_precache = {
	precache_model ("progs/ad181/mon_deflector.mdl");
	precache_model ("progs/ad181/h_deflector.mdl");
	precache_model ("progs/ad171/w_enforcergun.mdl");
	precache_model (MODEL_PROJ_PLASMA); // Standard plasma/rocket models
	precache_model (MODEL_PROJ_ROCKET);
	precache_poisongibs();
	precache_model (MODEL_PROJ_PLASMAGRN);
	precache_model (MODEL_PROJ_ROCKETGRN);
	precache_sound ("ad181/deflector/idle1.wav");
	precache_sound ("ad181/deflector/sight1.wav");
	precache_sound ("ad181/deflector/sight2.wav");
	precache_sound ("ad181/deflector/sight3.wav");
	precache_sound ("ad181/deflector/shield_off.wav"); // Shield off, shield on!
	precache_sound ("ad181/deflector/shield_on.wav");
	precache_sound ("ad181/deflector/rocket_load.wav"); // Projectile fire and impact (used in projectiles)
	precache_sound ("ad181/deflector/rocket_fire.wav");
	precache_sound ("ad181/deflector/rocket_hit.wav");
	precache_sound ("ad171/enforcer/elim_pg_load.wav"); // Extra load/fire sounds
	precache_sound (SOUND_PLASMA_FIRE);
	precache_sound (SOUND_PLASMA_HIT);
	precache_sound ("ad181/deflector/pain1.wav");
	precache_sound ("ad181/deflector/pain2.wav");
	precache_sound ("ad181/deflector/death1.wav");
	precache_sound ("ad181/deflector/death2.wav");
};

// QUAKED monster_megaforce (1 0 0) (-16 -16 -24) (16 16 40) Ambush
void() monster_megaforce = {
	if (monster_checkrandomizer() == TRUE) return; // Check for any random monster setups
	if (monster_checkspawn() == TRUE) return; // Check all spawn exceptions (monsters.qc)
	
	self.mdl = "progs/ad181/mon_deflector.mdl";
	self.headmdl = "progs/ad181/h_deflector.mdl";
	self.gib1mdl = "progs/ad171/w_enforcergun.mdl";	// Unique weapon
	self.gib1sound = GIB_IMPACT_WOOD;	// Gib sound for gun
	if (self.poisonous) self.gibtype = GIBTYPE_POISON;	// Poisonous blood trails
	self.idle_sound = "ad181/deflector/idle1.wav";
	self.sight_sound = "ad181/deflector/sight1.wav";
	self.sight_sound2 = "ad181/deflector/sight2.wav";
	self.sight_sound3 = "ad181/deflector/sight3.wav";
	self.pain_sound = "ad181/deflector/pain1.wav"; // Plenty of death and pain sounds
	self.pain_sound2 = "ad181/deflector/pain2.wav";
	self.death_sound = "ad181/deflector/death1.wav";
	self.death_sound2 = "ad181/deflector/death2.wav";
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_NONE;
	if (self.bboxtype < 1) self.bboxtype = BBOX_TALL;
	if (self.health < 1) self.health = 400;
	self.gibhealth = -60;
	self.gibbed = FALSE;
	self.pain_flinch = 100;				// High pain threshold
	self.pain_longanim = TRUE;			// Long pain animation for axe
	self.pain_timeout = 2;				// High pain threshold
	self.infightextra = 2;				// Double damage to other monsters
	self.steptype = FS_TYPEHEAVY;		// heavy player
	self.attack_offset = '28 8.5 16';	// End of Gun
	self.weaponstate = MEGAF_IDLE;		// No Shield active
	if (self.deathstring == "") self.deathstring = " was vaporized by a Mega-Enforcer\n";
	Resist_ChangeType(self,-1);
	megaf_shieldoff(); // Reset Ammo Resistance/Shield parameters
	self.th_checkattack = MegaforceCheckAttack;
	self.th_stand = megaf_stand1;
	self.th_walk = megaf_walk1;
	self.th_run = megaf_slow1;
	self.th_melee = megaf_plasma1;
	self.th_missile = megaf_rock1;
	self.th_pain = megaf_pain;
	self.th_die = megaf_die;
	self.classtype = CT_MONMEGAFORCE;
	self.classgroup = CG_DCAPTAIN;	// Make sure to infight
	self.classmove = MON_MOVEWALK;
	self.ammo_cells = rint(3 + random()*2);
	monster_start();
};

void() monster_me = { self.classname = "monster_megaforce"; monster_megaforce(); };
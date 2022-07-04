//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \ 
// |  \ |___ |___ |        |  | \__/ |__/ 
//
// Compiled by W. Josiah Jack, aka Qmaster
//
// Attributions: Arcane Dimensions (AD), Rubicon2 by John Fitzgibbons
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
// Entity count: 3
// Function count: 87
//
// Implements:  Pyro aka Dreadnought, Fumigator
//
// Description:
// Pyro is a flamethrower enforcer and the Fumigator is similar but poison gas.
//=============================================================================

$cd id1/models/enforcer
$origin 0 -6 24
$base base		
$skin skin
$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7
$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9 walk10
$frame walk11 walk12 walk13 walk14 walk15 walk16
$frame run1 run2 run3 run4 run5 run6 run7 run8
$frame attack1 attack2 attack3 attack4 attack5 attack6
$frame attack7 attack8 attack9 attack10
$frame death1 death2 death3 death4 death5 death6 death7 death8
$frame death9 death10 death11 death12 death13 death14
$frame fdeath1 fdeath2 fdeath3 fdeath4 fdeath5 fdeath6 fdeath7 fdeath8
$frame fdeath9 fdeath10 fdeath11
$frame paina1 paina2 paina3 paina4
$frame painb1 painb2 painb3 painb4 painb5
$frame painc1 painc2 painc3 painc4 painc5 painc6 painc7 painc8

float pyro_RUN_SPEED = 1.5;

void() pyro_soundreset = {
	if (self.attack_finished > time) sound (self, CHAN_WEAPON, self.noise4, 1, ATTN_NORM); // Turn off flame sound
	else StopSound(self,CHAN_WEAPON); // Play sound anyway to be sure the channel is silent
};

void()	pyro_stand1	=[	$stand1,	pyro_stand2	] {monster_idle_sound(); ai_stand();};
void()	pyro_stand2	=[	$stand2,	pyro_stand3	] {ai_stand();};
void()	pyro_stand3	=[	$stand3,	pyro_stand4	] {ai_stand();};
void()	pyro_stand4	=[	$stand4,	pyro_stand5	] {ai_stand();};
void()	pyro_stand5	=[	$stand5,	pyro_stand6	] {ai_stand();};
void()	pyro_stand6	=[	$stand6,	pyro_stand7	] {ai_stand();};
void()	pyro_stand7	=[	$stand7,	pyro_stand1	] {ai_stand();};

void()	pyro_walk1	=[	$walk1,		pyro_walk2	] {monster_idle_sound();ai_walk(2);};
void()	pyro_walk2	=[	$walk2,		pyro_walk3	] {monster_footstep(FALSE); ai_walk(4);};
void()	pyro_walk3	=[	$walk3,		pyro_walk4	] {ai_walk(4);};
void()	pyro_walk4	=[	$walk4,		pyro_walk5	] {ai_walk(3);};
void()	pyro_walk5	=[	$walk5,		pyro_walk6	] {ai_walk(1);};
void()	pyro_walk6	=[	$walk6,		pyro_walk7	] {ai_walk(2);};
void()	pyro_walk7	=[	$walk7,		pyro_walk8	] {ai_walk(2);};
void()	pyro_walk8	=[	$walk8,		pyro_walk9	] {ai_walk(1);};
void()	pyro_walk9	=[	$walk9,		pyro_walk10	] {ai_walk(2);};
void()	pyro_walk10	=[	$walk10,	pyro_walk11	] {monster_footstep(FALSE); ai_walk(4);};
void()	pyro_walk11	=[	$walk11,	pyro_walk12	] {ai_walk(4);};
void()	pyro_walk12	=[	$walk12,	pyro_walk13	] {ai_walk(1);};
void()	pyro_walk13	=[	$walk13,	pyro_walk14	] {ai_walk(2);};
void()	pyro_walk14	=[	$walk14,	pyro_walk15	] {ai_walk(3);};
void()	pyro_walk15	=[	$walk15,	pyro_walk16	] {ai_walk(4);};
void()	pyro_walk16	=[	$walk16,	pyro_walk1	] {ai_walk(2);};

void()	pyro_run1	=[	$run1,	pyro_run2	] {monster_idle_sound(); ai_run(18 * pyro_RUN_SPEED);};
void()	pyro_run2	=[	$run2,	pyro_run3	] {ai_run(14 * pyro_RUN_SPEED);};
void()	pyro_run3	=[	$run3,	pyro_run4	] {ai_run(7 * pyro_RUN_SPEED);};
void()	pyro_run4	=[	$run4,	pyro_run5	] {ai_run(12 * pyro_RUN_SPEED);};
void()	pyro_run5	=[	$run5,	pyro_run6	] {ai_run(14 * pyro_RUN_SPEED);};
void()	pyro_run6	=[	$run6,	pyro_run7	] {ai_run(14 * pyro_RUN_SPEED);};
void()	pyro_run7	=[	$run7,	pyro_run8	] {ai_run(7 * pyro_RUN_SPEED);};
void()	pyro_run8	=[	$run8,	pyro_run1	] {ai_run(11 * pyro_RUN_SPEED);};

void()	pyro_atk1	=[	$attack1,	pyro_atk2	] {ai_face();};
void()	pyro_atk2	=[	$attack3,	pyro_atk3	] {ai_face();};
void()	pyro_atk3	=[	$attack5,	pyro_atk4	] {ai_face();
	sound (self, CHAN_WEAPON, self.noise3, 1, ATTN_NORM);	// ON
	pyro_fire(); // FIRE! FIRE! FIRE!
	self.attack_finished = time + 0.3;
};
void()	pyro_atk4	=[	$attack5,	pyro_atk5	] {ai_face();
	pyro_fire();
	if (self.attack_finished > time || 
		(range(self.enemy) == RANGE_MELEE && self.enemy.health > 0) )
		self.think = pyro_atk4;
};
void()	pyro_atk5	=[	$attack10,	pyro_run1	] {ai_face();
	sound (self, CHAN_WEAPON, self.noise4, 1, ATTN_NORM);	// OFF
	SUB_CheckRefire(pyro_atk1);
};

void()	pyro_paina1	=[	$paina1,	pyro_paina2	] {};
void()	pyro_paina2	=[	$paina2,	pyro_paina3	] {};
void()	pyro_paina3	=[	$paina3,	pyro_paina4	] {};
void()	pyro_paina4	=[	$paina4,	pyro_run1	] {};

void()	pyro_painb1	=[	$painb1,	pyro_painb2	] {};
void()	pyro_painb2	=[	$painb2,	pyro_painb3	] {};
void()	pyro_painb3	=[	$painb3,	pyro_painb4	] {};
void()	pyro_painb4	=[	$painb4,	pyro_painb5	] {};
void()	pyro_painb5	=[	$painb5,	pyro_run1	] {};

void()	pyro_painc1	=[	$painc1,	pyro_painc2	] {};
void()	pyro_painc2	=[	$painc2,	pyro_painc3	] {};
void()	pyro_painc3	=[	$painc3,	pyro_painc4	] {};
void()	pyro_painc4	=[	$painc4,	pyro_painc5	] {};
void()	pyro_painc5	=[	$painc5,	pyro_painc6	] {};
void()	pyro_painc6	=[	$painc6,	pyro_painc7	] {};
void()	pyro_painc7	=[	$painc7,	pyro_painc8	] {};
void()	pyro_painc8	=[	$painc8,	pyro_run1	] {};

void(entity inflictor, entity attacker, float damage) pyro_pain = {
	monster_pain_check(attacker, damage); // Check all pain conditions and set up what to do next
	pyro_soundreset();

	// Any pain animation/sound required?
	if (self.pain_check > 0) {
		self.lip = random();
		if (self.lip < 0.5) sound (self, CHAN_VOICE, self.pain_sound, 1, ATTN_NORM);
		else sound (self, CHAN_VOICE, self.pain_sound2, 1, ATTN_NORM);
	
		// Not using long pain animation (need to be agile)
		if (self.pain_check == 1) {
			// Randomly pick which pain animation to play
			if (self.lip < 0.3) pyro_paina1();
			else if (self.lip < 0.6) pyro_painb1();
			else pyro_painc1();
		} else if (self.pain_check == 2) {
			// reset axe hit and setup short pain recovery
			self.pain_finished = time + 0.8;
			self.axhitme = 0;
			pyro_painc1();
		}
	}
};

void()	pyro_die1	=[	$death1,	pyro_die2	] {};
void()	pyro_die2	=[	$death2,	pyro_die3	] {monster_check_gib();};
void()	pyro_die3	=[	$death3,	pyro_die4	] {
	monster_check_gib();
	self.solid = SOLID_NOT;
	if (!self.gibbed) DropBackpack();
};
void()	pyro_die4	=[	$death4,	pyro_die5	] {ai_forward(14);};
void()	pyro_die5	=[	$death5,	pyro_die6	] {ai_forward(2);};
void()	pyro_die6	=[	$death6,	pyro_die7	] {};
void()	pyro_die7	=[	$death7,	pyro_die8	] {};
void()	pyro_die8	=[	$death8,	pyro_die9	] {};
void()	pyro_die9	=[	$death9,	pyro_die10	] {ai_forward(3);};
void()	pyro_die10	=[	$death10,	pyro_die11	] {ai_forward(5);};
void()	pyro_die11	=[	$death11,	pyro_die12	] {ai_forward(5);};
void()	pyro_die12	=[	$death12,	pyro_die13	] {ai_forward(5);};
void()	pyro_die13	=[	$death13,	pyro_die14	] {monster_death_postcheck();};
void()	pyro_die14	=[	$death14,	pyro_die14	] {monster_deadbody_check();};

void()	pyro_fdie1	=[	$fdeath1,	pyro_fdie2	] {};
void()	pyro_fdie2	=[	$fdeath2,	pyro_fdie3	] {monster_check_gib();};
void()	pyro_fdie3	=[	$fdeath3,	pyro_fdie4	] {monster_check_gib();self.solid = SOLID_NOT; if (!self.gibbed) DropBackpack();};
void()	pyro_fdie4	=[	$fdeath4,	pyro_fdie5	] {};
void()	pyro_fdie5	=[	$fdeath5,	pyro_fdie6	] {};
void()	pyro_fdie6	=[	$fdeath6,	pyro_fdie7	] {};
void()	pyro_fdie7	=[	$fdeath7,	pyro_fdie8	] {};
void()	pyro_fdie8	=[	$fdeath8,	pyro_fdie9	] {};
void()	pyro_fdie9	=[	$fdeath9,	pyro_fdie10	] {};
void()	pyro_fdie10	=[	$fdeath10,	pyro_fdie11	] {monster_death_postcheck();};
void()	pyro_fdie11	=[	$fdeath11,	pyro_fdie11	] {monster_deadbody_check();};

void() pyro_die = {
	monster_death_precheck(); // Pre-check routine to tidy up extra entities 
	pyro_soundreset();

	if (!self.gibbed) {
		sound (self, CHAN_VOICE, "enforcer/death1.wav", 1, ATTN_NORM);
		if (random() > 0.5) pyro_die1(); // regular death
		else pyro_fdie1();
	}
};

void() monster_pyro_precache = {
	precache_model ("progs/ad171/mon_pyro.mdl");
	precache_model ("progs/ad171/h_pyro.mdl");
	precache_model ("progs/ad171/w_enforcergun.mdl");
	precache_sound ("enforcer/death1.wav");
	precache_sound ("enforcer/pain1.wav");
	precache_sound ("enforcer/pain2.wav");
	precache_sound ("enforcer/idle1.wav");
	precache_sound ("quoth/pyro/sight.wav");
	precache_sound ("rrp/dread/flameon.wav");
	precache_sound ("rrp/dread/flameoff.wav");
	precache_model (SBURST_FLAME);		// Flame on
	precache_model (SBURST_SMOKE);		// Underwater
	precache_model (SBURST_FLAMEDP);	// DP Collision
};

// QUAKED monster_pyro (1 0 0) (-16 -16 -24) (16 16 40) Ambush
void() monster_pyro = {
	if (monster_checkrandomizer() == TRUE) return; // Check for any random monster setups
	if (monster_checkspawn() == TRUE) return; // Check all spawn exceptions (monsters.qc)
	
	self.mdl = "progs/ad171/mon_pyro.mdl";
	self.headmdl = "progs/ad171/h_pyro.mdl";
	self.gib1mdl = "progs/ad171/w_enforcergun.mdl";	// Unique weapon
	self.gib1skin = 3;
	self.pain_sound = "enforcer/pain1.wav";
	self.pain_sound2 = "enforcer/pain2.wav";
	self.idle_sound = "enforcer/idle1.wav";
	self.sight_sound = "quoth/pyro/sight.wav";
	self.noise3 = "rrp/dread/flameon.wav"; // Extra sound/sprite assets (from Rubicon2 MOD)
	self.noise4 = "rrp/dread/flameoff.wav";	
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_NONE;
	if (self.bboxtype < 1) self.bboxtype = BBOX_TALL;
	if (self.health < 1) self.health = 100;
	self.gibhealth = -35;
	self.gibbed = FALSE;
	self.yaw_speed = 35;				// Can turn really fast
	self.pain_flinch = 100;				// extremely high pain tolerance
	self.pain_longanim = TRUE;			// can be chopped with shadow axe
	self.steptype = FS_TYPEHEAVY;		// heavy feet
	self.attack_offset = '24 8.5 16';	// End of Gun
	self.ammo_shells = 4;				// drops armor shards instead
	if (!self.exactskin) self.randomskin = 4;

	Resist_ChangeType(self,-1); // Always reset Ammo Resistance to be consistent
	self.resist_nails = 0.5;
	self.resist_lava_nails = 0.75;
	self.resist_fire = 1;
	self.reflectnails = TRUE;		// Reflect nail projectiles
	self.th_checkattack = PyroCheckAttack;
	self.th_stand = pyro_stand1;
	self.th_walk = pyro_walk1;
	self.th_run = pyro_run1;
	self.th_pain = pyro_pain;
	self.th_die = pyro_die;
	self.th_melee = pyro_atk1;
	self.th_missile = pyro_atk1;		// For monster_turret function
	self.classtype = CT_MONPYRO;
	self.classgroup = CG_ENFORCER;
	self.classmove = MON_MOVEWALK;
	if (self.deathstring == "") self.deathstring = " was toasted by a Pyro\n";
	monster_start();
};

void() monster_fumigator_precache = {
	precache_model("progs/ad171/mon_fumigator.mdl");
	precache_model("progs/ad171/h_pyro.mdl");
	precache_model("progs/ad171/w_enforcergun.mdl");
	precache_poisongibs(); // Precache gibs
	precache_sound("enforcer/death1.wav");
	precache_sound("enforcer/pain1.wav");
	precache_sound("enforcer/pain2.wav");
	precache_sound("enforcer/idle1.wav");
	precache_sound("quoth/pyro/sight.wav");
	precache_sound("ad171/traps/steam_loop.wav");
	precache_sound("ad171/traps/steam_off.wav");
	precache_model(SBURST_POISON); // Poison on
	precache_model(SBURST_FLAMEDP); // DP Collision
};

// QUAKED monster_fumigator (1 0 0) (-16 -16 -24) (16 16 40) Ambush
void() monster_fumigator = {
	if (monster_checkrandomizer() == TRUE) return; // Check for any random monster setups
	if (monster_checkspawn() == TRUE) return; // Check all spawn exceptions (monsters.qc)
	
	self.mdl = "progs/ad171/mon_fumigator.mdl";
	self.headmdl = "progs/ad171/h_pyro.mdl";
	self.gib1mdl = "progs/ad171/w_enforcergun.mdl";	// Unique weapon
	self.gib1sound = GIB_IMPACT_WOOD;
	self.gib1skin = 4;
	self.pain_sound = "enforcer/pain1.wav";
	self.pain_sound2 = "enforcer/pain2.wav";
	self.idle_sound = "enforcer/idle1.wav";
	self.sight_sound = "quoth/pyro/sight.wav";
	self.noise3 = "ad171/traps/steam_loop.wav"; // Extra sound/sprite assets (from Rubicon2 MOD)
	self.noise4 = "ad171/traps/steam_off.wav";
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_NONE;
	if (self.bboxtype < 1) self.bboxtype = BBOX_TALL;
	if (self.health < 1) self.health = 100;
	self.gibhealth = -35;
	self.gibbed = FALSE;
	self.yaw_speed = 35;				// Can turn really fast
	self.pain_flinch = 100;				// extremely high pain tolerance
	self.pain_longanim = TRUE;			// can be chopped with shadow axe
	self.steptype = FS_TYPEHEAVY;		// heavy feet
	self.attack_offset = '24 8.5 16';	// End of Gun
	self.ammo_shells = 4;				// drops armor shards instead
	self.poisonous = TRUE;				// Oh yeah! Poison!
	self.gibtype = GIBTYPE_POISON;		// Poison gibs!
	self.no_liquiddmg = TRUE;			// Immune to slime/lava
	if (!self.exactskin) self.randomskin = 4;
	Resist_ChangeType(self,-1); // Always reset Ammo Resistance to be consistent
	self.resist_nails = 0.5;
	self.resist_lava_nails = 0.25;
	self.resist_fire = 0.25;
	self.resist_acid = 1;
	self.reflectnails = TRUE;		// Reflect nail projectiles
	self.th_checkattack = PyroCheckAttack;
	self.th_stand = pyro_stand1;
	self.th_walk = pyro_walk1;
	self.th_run = pyro_run1;
	self.th_pain = pyro_pain;
	self.th_die = pyro_die;
	self.th_melee = pyro_atk1;
	self.th_missile = pyro_atk1; // For monster_turret function
	self.classtype = CT_MONFUMIGATOR;
	self.classgroup = CG_ENFORCER;
	self.classmove = MON_MOVEWALK;
	if (self.deathstring == "")  self.deathstring = " was choked by a Fumigator\n";
	monster_start();
};

void() monster_dreadnaught = {
	if (self.deathstring == "")  self.deathstring = " was incinerated by a Dreadnaught\n";
	self.classname = "monster_pyro";
	monster_pyro();
};
/*==============================================================================
ENFORCER
==============================================================================*/
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

$frame paind1 paind2 paind3 paind4 paind5 paind6 paind7 paind8
$frame paind9 paind10 paind11 paind12 paind13 paind14 paind15 paind16
$frame paind17 paind18 paind19

float ENFORCER_LAVANG = 8192;

//============================================================================
void()	enf_stand1	=[	$stand1,	enf_stand2	] {monster_idle_sound(); ai_stand();};
void()	enf_stand2	=[	$stand2,	enf_stand3	] {ai_stand();};
void()	enf_stand3	=[	$stand3,	enf_stand4	] {ai_stand();};
void()	enf_stand4	=[	$stand4,	enf_stand5	] {ai_stand();};
void()	enf_stand5	=[	$stand5,	enf_stand6	] {ai_stand();};
void()	enf_stand6	=[	$stand6,	enf_stand7	] {ai_stand();};
void()	enf_stand7	=[	$stand7,	enf_stand1	] {ai_stand();};

//============================================================================
void()	enf_walk1	=[	$walk1,		enf_walk2	] {monster_idle_sound(); ai_walk(2);};
void()	enf_walk2	=[	$walk2,		enf_walk3	] {monster_footstep(FALSE); ai_walk(4);};
void()	enf_walk3	=[	$walk3,		enf_walk4	] {ai_walk(4);};
void()	enf_walk4	=[	$walk4,		enf_walk5	] {ai_walk(3);};
void()	enf_walk5	=[	$walk5,		enf_walk6	] {ai_walk(1);};
void()	enf_walk6	=[	$walk6,		enf_walk7	] {ai_walk(2);};
void()	enf_walk7	=[	$walk7,		enf_walk8	] {ai_walk(2);};
void()	enf_walk8	=[	$walk8,		enf_walk9	] {ai_walk(1);};
void()	enf_walk9	=[	$walk9,		enf_walk10	] {ai_walk(2);};
void()	enf_walk10	=[	$walk10,	enf_walk11	] {monster_footstep(FALSE); ai_walk(4);};
void()	enf_walk11	=[	$walk11,	enf_walk12	] {ai_walk(4);};
void()	enf_walk12	=[	$walk12,	enf_walk13	] {ai_walk(1);};
void()	enf_walk13	=[	$walk13,	enf_walk14	] {ai_walk(2);};
void()	enf_walk14	=[	$walk14,	enf_walk15	] {ai_walk(3);};
void()	enf_walk15	=[	$walk15,	enf_walk16	] {ai_walk(4);};
void()	enf_walk16	=[	$walk16,	enf_walk1	] {ai_walk(2);};

void()	lth_walk1	=[	$walk1 ,	lth_walk2	] {monster_idle_sound(); ai_walk(2);};
void()	lth_walk2	=[	$walk2 ,	lth_walk3	] {ai_walk(4);};
void()	lth_walk3	=[	$walk3 ,	lth_walk4	] {ai_walk(4);};
void()	lth_walk4	=[	$walk4 ,	lth_walk5	] {ai_walk(3);};
void()	lth_walk5	=[	$walk5 ,	lth_walk6	] {ai_walk(1);};
void()	lth_walk6	=[	$walk6 ,	lth_walk7	] {ai_walk(2);};
void()	lth_walk7	=[	$walk7 ,	lth_walk8	] {ai_walk(2);};
void()	lth_walk8	=[	$walk8 ,	lth_walk9	] {ai_walk(1);};
void()	lth_walk9	=[	$walk9 ,	lth_walk10	] {ai_walk(2);};
void()	lth_walk10	=[	$walk10,	lth_walk11	] {ai_walk(4);};
void()	lth_walk11	=[	$walk11,	lth_walk12	] {ai_walk(4);};
void()	lth_walk12	=[	$walk12,	lth_walk13	] {ai_walk(1);};
void()	lth_walk13	=[	$walk13,	lth_walk14	] {ai_walk(2);};
void()	lth_walk14	=[	$walk14,	lth_walk15	] {ai_walk(3);};
void()	lth_walk15	=[	$walk15,	lth_walk16	] {ai_walk(4);};
void()	lth_walk16	=[	$walk16,	lth_walk1	] {ai_walk(2);};

float MEGA_ENF = 2;
float ULTRA_ENF = 4;
void enforcer_updateshield();
void menf_ratk1();
void menf_zatk1();
void menf_gatk1();
void menf_atk1();
void enf_atk1();

//============================================================================
void()	enf_run1	=[	$run1,		enf_run2	] {monster_idle_sound(); ai_run(18); };
void()	enf_run2	=[	$run2,		enf_run3	] {ai_run(14); enforcer_updateshield(); };
void()	enf_run3	=[	$run3,		enf_run4	] {monster_footstep(FALSE); ai_run(7); enforcer_updateshield(); };
void()	enf_run4	=[	$run4,		enf_run5	] {ai_run(12); enforcer_updateshield(); };
void()	enf_run5	=[	$run5,		enf_run6	] {ai_run(14); enforcer_updateshield(); };
void()	enf_run6	=[	$run6,		enf_run7	] {ai_run(14); enforcer_updateshield(); };
void()	enf_run7	=[	$run7,		enf_run8	] {monster_footstep(FALSE); ai_run(7); enforcer_updateshield(); };
void()	enf_run8	=[	$run8,		enf_run1	] {ai_run(11); enforcer_updateshield(); };

void() enforcer_attack = {
	local float edist;
	edist = vlen(self.enemy.origin - self.origin);
	if (self.spawnflags & ULTRA_ENF) {
		if (random() < edist / 768 - 0.15)
			menf_ratk1();
		else
			menf_zatk1();
	} else if (self.spawnflags & MEGA_ENF) {
		if (edist < 768 && random() > 0.5)
			menf_gatk1();
		else
			menf_atk1();
	} else {
		enf_atk1();
	}
};

// Basic enforcer laser attack
void() enforcer_fire = {
	local vector org, vec;

	if (!self.enemy) return;

	self.effects = self.effects | EF_MUZZLEFLASH;
	sound (self, CHAN_WEAPON, SOUND_LASER_FIRE, 1, ATTN_NORM);
	makevectors (self.angles);
	org = self.origin + attack_vector(self.attack_offset);
	vec = normalize(self.enemy.origin - self.origin);
	launch_projectile(org, vec, CT_PROJ_LASER, SPEED_LASER);
};

void()	enf_atk1	=[	$attack1,	enf_atk2	] {};
void()	enf_atk2	=[	$attack2,	enf_atk3	] {monster_footstep(FALSE);ai_face();};
void()	enf_atk3	=[	$attack3,	enf_atk4	] {ai_face();};
void()	enf_atk4	=[	$attack4,	enf_atk5	] {ai_face();};
void()	enf_atk5	=[	$attack5,	enf_atk6	] {ai_face();};
void()	enf_atk6	=[	$attack6,	enf_atk7	] {
	if (self.health > 0) enforcer_fire();};
void()	enf_atk7	=[	$attack7,	enf_atk8	] {};
void()	enf_atk8	=[	$attack8,	enf_atk9	] {};
void()	enf_atk9	=[	$attack5,	enf_atk10	] {ai_face();};
void()	enf_atk10	=[	$attack6,	enf_atk11	] {ai_face();
	if (self.health > 0) enforcer_fire();};
void()	enf_atk11	=[	$attack7,	enf_atk12	] {};
void()	enf_atk12	=[	$attack8,	enf_atk13	] {};
void()	enf_atk13	=[	$attack9,	enf_atk14	] {ai_face();};
void()	enf_atk14	=[	$attack10,	enf_run1	] {ai_face();SUB_CheckRefire (enf_atk1);};

// - Defender enforcer (ssg/gl attack)
void() defender_ssg = {
	if (!self.enemy) return;
	if (self.health < 1) return;

	self.effects = self.effects | EF_MUZZLEFLASH;
	sound (self, CHAN_WEAPON, "quoth/defender/ssgfire.wav", 1, ATTN_NORM);	
	
	// Choose between a projectile or hit-scan system
	if (query_configflag(SVR_SHOTGPROJ)) 
		FireBullets (QUANTITY_DEFENDER, SPREAD_DEF);
	else {
		Launch_Shells(QUANTITY_DEFENDER, SPREAD_DEF, CT_PROJ_SG);
		Launch_ShellCasing(2);
	}
};

void()	def_atkssg1	=[	$attack1,	def_atkssg2	] {sound (self, CHAN_WEAPON, "quoth/defender/ssgcock.wav", 1, ATTN_NORM);};
void()	def_atkssg2	=[	$attack2,	def_atkssg3	] {monster_footstep(FALSE);ai_face();};
void()	def_atkssg3	=[	$attack3,	def_atkssg4	] {ai_face();};
void()	def_atkssg4	=[	$attack4,	def_atkssg5	] {ai_face();};
void()	def_atkssg5	=[	$attack5,	def_atkssg6	] {ai_face();};
void()	def_atkssg6	=[	$attack6,	def_atkssg7	] {ai_face();
	if (self.health > 0) defender_ssg();};
void()	def_atkssg7	=[	$attack7,	def_atkssg8	] {};
void()	def_atkssg8	=[	$attack8,	def_atkssg9	] {};
void()	def_atkssg9	=[	$attack9,	def_atkssg10] {ai_face();};
void()	def_atkssg10=[	$attack10,	enf_run1	] {SUB_CheckRefire (def_atkssg1);};

void()	def_atkgl1	=[	$attack1,	def_atkgl2	] {ai_face();};
void()	def_atkgl2	=[	$attack2,	def_atkgl3	] {monster_footstep(FALSE);ai_face();};
void()	def_atkgl3	=[	$attack3,	def_atkgl4	] {ai_face();
	MonsterGrenadeSound(); self.attack_speed = MonsterGrenadeSpeed();
	self.attack_elev = SUB_Elevation(ELEV_DEFAULT, self.origin, self.enemy.origin, self.attack_speed); };
void()	def_atkgl4	=[	$attack4,	def_atkgl5	] {ai_face();self.attack_elev = SUB_Elevation(self.attack_elev, self.origin, self.enemy.origin, self.attack_speed); };
void()	def_atkgl5	=[	$attack5,	def_atkgl6	] {ai_face();self.attack_elev = SUB_Elevation(self.attack_elev, self.origin, self.enemy.origin, self.attack_speed); };
void()	def_atkgl6	=[	$attack6,	def_atkgl7	] {ai_face();
	makevectors(self.angles);
	self.pos1 = self.origin + attack_vector(self.attack_offset);
	MonsterFireGrenade(self.pos1, self.enemy.origin);
};
void()	def_atkgl7	=[	$attack7,	def_atkgl8	] {};
void()	def_atkgl8	=[	$attack8,	def_atkgl9	] {};
void()	def_atkgl9	=[	$attack9,	def_atkgl10] {ai_face();};
void()	def_atkgl10=[	$attack10,	enf_run1	]{ai_face();};

// - Eliminator enforcer (plasma attack)
void() eliminator_fire = {
	local vector org, vec;

	if (!self.enemy) return;

	self.effects = self.effects | EF_MUZZLEFLASH;
	sound (self, CHAN_WEAPON, SOUND_PLASMA_FIRE, 1, ATTN_NORM);

	makevectors (self.angles);
	org = self.origin + attack_vector(self.attack_offset);
	vec = normalize(self.enemy.origin - self.origin);

	launch_plasma(org, vec, CT_PROJ_PLASMA, SPEED_PLASMA);
};

void()	elim_atk1	=[	$attack1,	elim_atk2	] {
	sound (self, CHAN_WEAPON, "ad171/enforcer/elim_pg_load.wav", 1, ATTN_NORM);};
void()	elim_atk2	=[	$attack2,	elim_atk3	] {monster_footstep(FALSE);ai_face();};
void()	elim_atk3	=[	$attack3,	elim_atk4	] {ai_face();};
void()	elim_atk4	=[	$attack4,	elim_atk5	] {ai_face();};
void()	elim_atk5	=[	$attack5,	elim_atk6	] {ai_face();};
void()	elim_atk6	=[	$attack6,	elim_atk7	] {ai_face();
	if (self.health > 0) eliminator_fire();};
void()	elim_atk7	=[	$attack7,	elim_atk8	] {};
void()	elim_atk8	=[	$attack8,	elim_atk9	] {};
void()	elim_atk9	=[	$attack5,	elim_atk10	] {ai_face();};
void()	elim_atk10	=[	$attack6,	elim_atk11	] {ai_face();
	if (self.health > 0) eliminator_fire();};
void()	elim_atk11	=[	$attack7,	elim_atk12	] {};
void()	elim_atk12	=[	$attack8,	elim_atk13	] {};
void()	elim_atk13	=[	$attack9,	elim_atk14	] {ai_face();};
void()	elim_atk14	=[	$attack10,	enf_run1	] {ai_face();SUB_CheckRefire (elim_atk1);};

void()	enf_paina1	=[	$paina1,	enf_paina2	] {};
void()	enf_paina2	=[	$paina2,	enf_paina3	] {};
void()	enf_paina3	=[	$paina3,	enf_paina4	] {};
void()	enf_paina4	=[	$paina4,	enf_run1	] {};

void()	enf_painb1	=[	$painb1,	enf_painb2	] {};
void()	enf_painb2	=[	$painb2,	enf_painb3	] {};
void()	enf_painb3	=[	$painb3,	enf_painb4	] {};
void()	enf_painb4	=[	$painb4,	enf_painb5	] {};
void()	enf_painb5	=[	$painb5,	enf_run1	] { enforcer_updateshield(); };

void()	enf_painc1	=[	$painc1,	enf_painc2	] {};
void()	enf_painc2	=[	$painc2,	enf_painc3	] {monster_footstep(FALSE);};
void()	enf_painc3	=[	$painc3,	enf_painc4	] {};
void()	enf_painc4	=[	$painc4,	enf_painc5	] {};
void()	enf_painc5	=[	$painc5,	enf_painc6	] { enforcer_updateshield(); };
void()	enf_painc6	=[	$painc6,	enf_painc7	] { enforcer_updateshield(); };
void()	enf_painc7	=[	$painc7,	enf_painc8	] { enforcer_updateshield(); };
void()	enf_painc8	=[	$painc8,	enf_run1	] { enforcer_updateshield(); };

void()	enf_paind1	=[	$paind1,	enf_paind2	] {};
void()	enf_paind2	=[	$paind2,	enf_paind3	] {};
void()	enf_paind3	=[	$paind3,	enf_paind4	] {monster_footstep(FALSE);};
void()	enf_paind4	=[	$paind4,	enf_paind5	] {ai_painforward(2);};
void()	enf_paind5	=[	$paind5,	enf_paind6	] {ai_painforward(1);};
void()	enf_paind6	=[	$paind6,	enf_paind7	] {};
void()	enf_paind7	=[	$paind7,	enf_paind8	] {};
void()	enf_paind8	=[	$paind8,	enf_paind9	] {};
void()	enf_paind9	=[	$paind9,	enf_paind10	] {};
void()	enf_paind10	=[	$paind10,	enf_paind11	] { enforcer_updateshield(); };
void()	enf_paind11	=[	$paind11,	enf_paind12	] {ai_painforward(1); enforcer_updateshield(); };
void()	enf_paind12	=[	$paind12,	enf_paind13	] {ai_painforward(1); enforcer_updateshield(); };
void()	enf_paind13	=[	$paind13,	enf_paind14	] {ai_painforward(1); enforcer_updateshield(); };
void()	enf_paind14	=[	$paind14,	enf_paind15	] { enforcer_updateshield(); };
void()	enf_paind15	=[	$paind15,	enf_paind16	] { enforcer_updateshield(); };
void()	enf_paind16	=[	$paind16,	enf_paind17	] {ai_pain(1); enforcer_updateshield(); };
void()	enf_paind17	=[	$paind17,	enf_paind18	] {ai_pain(1); enforcer_updateshield(); };
void()	enf_paind18	=[	$paind18,	enf_paind19	] { enforcer_updateshield(); };
void()	enf_paind19	=[	$paind19,	enf_run1	] { enforcer_updateshield(); };

void()	lth_paina1	=[	50,	lth_paina2	] {};
void()	lth_paina2	=[	51,	lth_paina3	] {};
void()	lth_paina3	=[	52,	lth_paina4	] {};
void()	lth_paina4	=[	53,	enf_run1	] {};

void(entity inflictor, entity attacker, float damage) enf_pain = {
	// Check all pain conditions and set up what to do next
	monster_pain_check(attacker, damage);



	// Any pain animation/sound required?
	if (self.pain_check > 0) {
		self.lip = random ();
		if (self.lip < 0.5) sound (self, CHAN_VOICE, self.pain_sound, 1, ATTN_NORM);
		else sound (self, CHAN_VOICE, self.pain_sound2, 1, ATTN_NORM);

		if (self.classtype == CT_MONSUPERENFORCER) { lth_paina1(); return; }

		if (self.pain_check == 1) {
			// Randomly pick which pain animation to play
			if (self.lip < 0.2) enf_paina1 ();
			else if (self.lip < 0.4) enf_painb1 ();
			else if (self.lip < 0.7) enf_painc1 ();
			else {
				self.pain_finished = time + 2;
				enf_paind1 ();
			}
		}
		// The new axe forces monsters into long pain animations
		else if (self.pain_check == 2) {
			// reset axe hit and setup short pain recovery
			self.pain_finished = time + 1.9;
			self.axhitme = 0;
			enf_paind1 ();
		}
	}
};

void()	enf_die1	=[	$death1,	enf_die2	] {};
void()	enf_die2	=[	$death2,	enf_die3	] {monster_check_gib();};
void()	enf_die3	=[	$death3,	enf_die4	] {monster_check_gib();
	self.solid = SOLID_NOT; if (!self.gibbed) DropBackpack();};
void()	enf_die4	=[	$death4,	enf_die5	] {ai_forward(14);};
void()	enf_die5	=[	$death5,	enf_die6	] {ai_forward(2);};
void()	enf_die6	=[	$death6,	enf_die7	] {};
void()	enf_die7	=[	$death7,	enf_die8	] {};
void()	enf_die8	=[	$death8,	enf_die9	] {};
void()	enf_die9	=[	$death9,	enf_die10	] {ai_forward(3);};
void()	enf_die10	=[	$death10,	enf_die11	] {ai_forward(5);};
void()	enf_die11	=[	$death11,	enf_die12	] {ai_forward(5);};
void()	enf_die12	=[	$death12,	enf_die13	] {ai_forward(5);};
void()	enf_die13	=[	$death13,	enf_die14	] {monster_death_postcheck();};
void()	enf_die14	=[	$death14,	enf_die14	] {monster_deadbody_check();};

void()	enf_fdie1	=[	$fdeath1,	enf_fdie2	] {};
void()	enf_fdie2	=[	$fdeath2,	enf_fdie3	] {monster_check_gib();};
void()	enf_fdie3	=[	$fdeath3,	enf_fdie4	] {monster_check_gib();self.solid = SOLID_NOT; if (!self.gibbed) DropBackpack();};
void()	enf_fdie4	=[	$fdeath4,	enf_fdie5	] {};
void()	enf_fdie5	=[	$fdeath5,	enf_fdie6	] {};
void()	enf_fdie6	=[	$fdeath6,	enf_fdie7	] {};
void()	enf_fdie7	=[	$fdeath7,	enf_fdie8	] {};
void()	enf_fdie8	=[	$fdeath8,	enf_fdie9	] {};
void()	enf_fdie9	=[	$fdeath9,	enf_fdie10	] {};
void()	enf_fdie10	=[	$fdeath10,	enf_fdie11	] {monster_death_postcheck();};
void()	enf_fdie11	=[	$fdeath11,	enf_fdie11	] {monster_deadbody_check();};

void()	lth_fdie1;

void() enf_die = {
	local float r;
	
	monster_death_precheck(); // Pre-check routine to tidy up extra entities

	// regular death
	if (!self.gibbed) {
		if (self.classtype == CT_MONENF_ULTRA) {
			r = random();
			if (r < 0.333)		sound (self, CHAN_VOICE, "lunaran/enforcer/ue_die1.wav", 1, ATTN_NORM);
			else if (r < 0.666)	sound (self, CHAN_VOICE, "lunaran/enforcer/ue_die2.wav", 1, ATTN_NORM);
			else 				sound (self, CHAN_VOICE, "lunaran/enforcer/ue_die3.wav", 1, ATTN_NORM);
		} else if (self.classtype == CT_MONENF_GUNNER) {
			if (random() < 0.5)	sound (self, CHAN_VOICE, "drake/gunner/death1.wav", 1, ATTN_NORM);
			else				sound (self, CHAN_VOICE, "drake/gunner/death2.wav", 1, ATTN_NORM);
		} else {
			sound (self, CHAN_VOICE, "enforcer/death1.wav", 1, ATTN_NORM);
		}

		if (self.classtype == CT_MONSUPERENFORCER) {
			if (self.spawnflags & ENFORCER_LAVANG) DropWeapon(MODEL_GWEAP_LSNG,IT_LAVA_SUPER_NAILGUN,CT_LAVASNG);
			else DropWeapon(MODEL_GWEAP_SNG,IT_SUPER_NAILGUN,CT_SUPER_NAILGUN);
			lth_fdie1();
			return;
		}

		if (random() > 0.5) enf_die1 ();
		else enf_fdie1 ();
	}
};

void() monster_enforcer_precache = {
	precache_model(MODEL_PROJ_LASER);	// Originally - progs/laser.mdl
	precache_model("progs/enforcer.mdl");
	precache_model("progs/h_mega.mdl");
	precache_model("progs/laser.mdl");
	precache_model("progs/travail/laser2.mdl");
	precache_model("progs/k_spike.mdl");
	precache_model("progs/missile.mdl");
	precache_model("progs/qmaster/mon_enforcer.mdl"); // Merged all the skins together
	precache_model("progs/qmaster/h_enforcer.mdl");  // Merged all the skins together
	precache_model("progs/ad171/w_enforcergun.mdl");
	precache_model(MODEL_PROJ_GRENADE);
	precache_model(MODEL_PROJ_PLASMA);
	precache_model("progs/s_spike.mdl");
	precache_model(MODEL_GWEAP_SNG);
	precache_model(MODEL_GWEAP_LSNG);
	precache_model("progs/ad171/g_nail2.mdl");
	precache_model("progs/lieutenant/enforce2.mdl");
	precache_model("progs/h_mega.mdl");
	precache_sound("enforcer/death1.wav");
	precache_sound(SOUND_LASER_FIRE);
	precache_sound(SOUND_LASER_HIT);
	precache_sound("enforcer/idle1.wav");
	precache_sound("enforcer/pain1.wav");
	precache_sound("enforcer/pain2.wav");
	precache_sound("enforcer/sight1.wav");
	precache_sound("enforcer/sight2.wav");
	precache_sound("enforcer/sight3.wav");
	precache_sound("enforcer/sight4.wav");
	precache_sound("lunaran/enforcer/me_fire1.wav");
	precache_sound("zerstorer/weapons/rocket1i.wav");
	precache_sound("items/protect3.wav");
	precache_sound("lunaran/enforcer/ue_die1.wav");
	precache_sound("lunaran/enforcer/ue_die2.wav");
	precache_sound("lunaran/enforcer/ue_die3.wav");
	precache_sound("lunaran/enforcer/ue_site1.wav");
	precache_sound("lunaran/enforcer/ue_site2.wav");
	precache_sound("lunaran/enforcer/ue_site3.wav");
	precache_sound("lunaran/enforcer/ue_site4.wav");
	precache_sound("lunaran/enforcer/ue_site5.wav");
	precache_sound("lunaran/enforcer/ue_pain1.wav");
	precache_sound("lunaran/enforcer/ue_pain2.wav");
	precache_sound("lunaran/enforcer/ue_pain3.wav");
	precache_sound("enforcer/sight1.wav");
	precache_sound("enforcer/sight2.wav");
	precache_sound("enforcer/sight3.wav");
	precache_sound("enforcer/sight4.wav");
	precache_sound(SOUND_LASER_FIRE); // Projectile fire and impact (used in projectiles)
	precache_sound(SOUND_LASER_HIT);
	precache_sound("quoth/defender/breathe.wav");
	precache_sound("quoth/defender/blip.wav");
	precache_sound("quoth/defender/sight1.wav");
	precache_sound("quoth/defender/sight2.wav");
	precache_sound("quoth/defender/sight3.wav");
	precache_sound("quoth/defender/sight4.wav");
	precache_sound("quoth/defender/ssgcock.wav"); // Extra load/fire sounds (from Quoth MOD)
	precache_sound("quoth/defender/ssgfire.wav");
	precache_sound("quoth/eliminator/idle1.wav");
	precache_sound("quoth/eliminator/idle2.wav");
	precache_sound("quoth/eliminator/idle3.wav");
	precache_sound("quoth/eliminator/sight.wav");
	precache_sound("ad171/enforcer/elim_pg_load.wav"); // Extra load/fire sounds (from Quoth MOD)
	precache_sound(SOUND_PLASMA_FIRE);
	precache_sound(SOUND_PLASMA_HIT);
	precache_sound("enforcer/pain1.wav");
	precache_sound("enforcer/pain2.wav");
	precache_sound("enforcer/sight1.wav");
	precache_sound("enforcer/sight2.wav");
	precache_sound("enforcer/sight3.wav");
	precache_sound("enforcer/sight4.wav");
	precache_sound("enforcer/death1.wav");
    precache_sound ("drake/gunner/death1.wav");
    precache_sound ("drake/gunner/death2.wav");
    precache_sound ("drake/gunner/idle.wav");
    precache_sound ("drake/gunner/pain1.wav");
    precache_sound ("drake/gunner/pain2.wav");
    precache_sound ("drake/gunner/sight.wav");
    precache_sound ("drake/weapons/dsshotgn.wav");    // Doom shotgun sound.
};

// QUAKED monster_enforcer (1 0 0) (-16 -16 -24) (16 16 40) Ambush
void() monster_base_enforcer = {
	local float r;
	
	if (!self.mdl) self.mdl = "progs/qmaster/mon_enforcer.mdl";
	if (!self.headmdl) self.headmdl = "progs/qmaster/h_enforcer.mdl";
	if (!self.gib1mdl) self.gib1mdl = "progs/ad171/w_enforcergun.mdl";	// Unique weapon
	if (self.classtype == CT_MONENF_ULTRA) {
		self.pain_sound = "lunaran/enforcer/ue_pain1.wav";
		r = random();
		if (r < 0.5)
			self.pain_sound2 = "lunaran/enforcer/ue_pain2.wav";
		else
			self.pain_sound2 = "lunaran/enforcer/ue_pain3.wav";
	} else {
		if (self.pain_sound == "") self.pain_sound = "enforcer/pain1.wav";
		if (self.pain_sound2 == "") self.pain_sound2 = "enforcer/pain2.wav";
	}
	if (!self.gib1sound) self.gib1sound = GIB_IMPACT_WOOD;
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_NONE;
	if (self.bboxtype < 1) self.bboxtype = BBOX_TALL;
	if (!self.gibhealth) self.gibhealth = -35;
	self.gibbed = FALSE;
	if (self.classtype == CT_MONENF_ULTRA) self.pain_flinch = 80; // high pain threshhold
	if (self.classtype == CT_MONENF_MEGA) self.pain_flinch = 50; // medium pain threshold
	if (self.classtype == CT_MONSUPERENFORCER) self.pain_flinch = 100; // medium pain threshold
	if (!self.pain_flinch) self.pain_flinch = 20;				// low pain threshold
	self.pain_longanim = TRUE;			// Long pain animation for axe
	if (!self.steptype) self.steptype = FS_TYPEHEAVY;		// heavy player
	if (CheckZeroVector(self.attack_offset)) self.attack_offset = '28 8.5 16';	// End of Gun
	Resist_ChangeType(self,-1);// Always reset Ammo Resistance to be consistent
	if (self.classtype == CT_MONELIMATOR) {self.resist_cells = 0.5;self.resist_plasma = 0.5;}
	if (self.classtype == CT_MONDEFENDER) {self.resist_rockets = 0.5;self.resist_multi_rockets = 0.5;}
	if (self.classtype == CT_MONENF_MEGA) {self.resist_cells = 0.75;self.resist_plasma = 0.75;}
	if (!self.th_stand) self.th_stand = enf_stand1;
	if (!self.th_walk) self.th_walk = enf_walk1;
	if (!self.th_run) self.th_run = enf_run1;
	if (!self.th_pain) self.th_pain = enf_pain;
	if (!self.th_die) self.th_die = enf_die;
	self.classgroup = CG_ENFORCER;
	self.classmove = MON_MOVEWALK;
	monster_start();
};

void enforcer_spawnshieldfx();

void() monster_enforcer = {
	if (monster_checkrandomizer() == TRUE) return; // Check for any random monster setups
	if (monster_checkspawn() == TRUE) return; // Check all spawn exceptions (monsters.qc)
	
	if (!self.classtype) self.classtype = CT_MONENFORCER;
	if (self.spawnflags & ULTRA_ENF) {
		if (self.health < 1) self.health = 400;
		self.skin = 12;
		enforcer_spawnshieldfx();
		self.classtype = CT_MONENF_ULTRA;
		if (self.deathstring == "")  self.deathstring = " was vaporized by an Ultra-enforcer\n";
	} else {
		if (self.spawnflags & MEGA_ENF) {
			if (self.health < 1) self.health = 200;
			self.skin = 11;
			self.classtype = CT_MONENF_MEGA;
			if (self.deathstring == "") self.deathstring = " was vaporized by a Mega-enforcer\n";
		} else {
			if (self.classtype == CT_MONENFORCER) {
				if (self.health < 1) self.health = 80;
				if (self.exactskin >=0) self.exactskin = rint((random()*3)-0.5);
				if (self.deathstring == "")  self.deathstring = " was blasted by an Enforcer\n";
				self.ammo_cells = rint(1 + random()*2);
				self.gib1skin = 0;
			}
		}
	}

	if (!self.idle_sound) self.idle_sound = "enforcer/idle1.wav";
	if (!self.sight_sound) self.sight_sound = "enforcer/sight1.wav";
	if (!self.sight_sound2) self.sight_sound2 = "enforcer/sight2.wav";
	if (!self.sight_sound3) self.sight_sound3 = "enforcer/sight3.wav";
	if (!self.sight_sound4) self.sight_sound4 = "enforcer/sight4.wav";
	if (!self.th_missile) self.th_missile = enforcer_attack;
	monster_base_enforcer();
};

void() monster_defender = {
	if (monster_checkrandomizer() == TRUE) return; // Check for any random monster setups
	if (monster_checkspawn() == TRUE) return; // Check all spawn exceptions (monsters.qc)
	
	self.classtype = CT_MONDEFENDER;
	if (self.health < 1) self.health = 100;
	self.ammo_shells = rint(4 + random()*4);
	self.exactskin = 3 + rint((random()*3)-0.5);
	self.gib1skin = 1;
	self.idle_sound = "quoth/defender/breathe.wav";
	self.idle_sound2 = "quoth/defender/blip.wav";
	self.sight_sound = "quoth/defender/sight1.wav";
	self.sight_sound2 = "quoth/defender/sight2.wav";
	self.sight_sound3 = "quoth/defender/sight3.wav";
	self.sight_sound4 = "quoth/defender/sight4.wav";
	self.th_missile = def_atkgl1;
	self.th_melee = def_atkssg1;
	self.th_checkattack = DefenderCheckAttack;
	// Grenade bounce off body
	self.bouncegrenade = TRUE;
	if (self.deathstring == "")  self.deathstring = " was destroyed by a Defender\n";
	monster_base_enforcer();
};

void() gunner_chaingun = {
    local vector p1, p2;

    makevectors(self.angles);
    p1 = self.origin + (v_forward*12) + (v_right*8.5) + (v_up*16);
    p2 = Midpoint(self.enemy);
    M_FireChaingun(p1, p2, self.enemy, '0 0 0');
};

// Chaingun, Doom2 style
void() gunner_gun1  =[ $attack6,  gunner_gun2  ] {ai_face(); gunner_chaingun();};
void() gunner_gun2  =[ $attack4,  gunner_gun1  ] {ai_face(); gunner_chaingun(); M_Break(enf_run1);};

// QUAKED monster_gunner (1 0 0) (-16 -16 -24) (16 16 40) Ambush
void() monster_gunner = {
	if (monster_checkrandomizer() == TRUE) return; // Check for any random monster setups
	if (monster_checkspawn() == TRUE) return; // Check all spawn exceptions (monsters.qc)

	self.classtype = CT_MONENF_GUNNER;
	if (self.health < 1) self.health = 70; // PM:  Chaingunners had 70 health in Doom2.
	self.pain_flinch = 30; // Gunners shrug off pain more easily than standard enforcers.
    self.mass       = MASS_MEDIUM;
    self.exactskin  = 13; // Bare face and arms, bloodied
	self.gib1skin = 13;
	self.idle_sound = "drake/gunner/idle.wav";
    self.sight_sound = "drake/gunner/sight.wav";
    self.hello_sound = "drake/gunner/idle.wav";
    self.pain_sound = "drake/gunner/pain1.wav";
    self.pain_sound2= "drake/gunner/pain2.wav";
    self.th_missile = gunner_gun1;
	if (self.deathstring == "") {
		if (random() < 0.5)	self.deathstring = " was perforated by a Chaingunner\n";
		else				self.deathstring = " was outgunned by a Gunner\n";
	}
    monster_base_enforcer();
};

// The Quoth Eliminator
void() monster_eliminator = {
	if (monster_checkrandomizer() == TRUE) return; // Check for any random monster setups
	if (monster_checkspawn() == TRUE) return; // Check all spawn exceptions (monsters.qc)
	 
	self.classtype = CT_MONELIMATOR;
	if (self.health < 1) self.health = 120;
	self.ammo_cells = rint(2 + random()*2);
	self.exactskin = 6 + rint((random()*3)-0.5);
	self.gib1skin = 2;
	self.idle_sound = "quoth/eliminator/idle1.wav";
	self.idle_sound2 = "quoth/eliminator/idle2.wav";
	self.idle_soundcom = "quoth/eliminator/idle3.wav";
	self.sight_sound = "quoth/eliminator/sight.wav";
	self.th_missile = elim_atk1;
	self.th_checkattack = EliminatorCheckAttack;
	if (self.deathstring == "")  self.deathstring = " was eliminated by an Eliminator\n";
	monster_base_enforcer();
};

// Drake's implementation of the Quoth Eliminator
void() monster_commando = {
	if (monster_checkrandomizer() == TRUE) return; // Check for any random monster setups
	if (monster_checkspawn() == TRUE) return; // Check all spawn exceptions (monsters.qc)

	if (self.health < 1) self.health = 160; // More health yikes!
	self.exactskin = 15;
	if (self.deathstring == "")  self.deathstring = " was eliminated by an Commando\n";
	self.classname = "monster_eliminator";
	monster_eliminator();
};

void() army_nailfire;
void() super_enforcer_fire = {
	ai_face();
	army_nailfire();
};

void()	lth_run1	=[	$run1  ,	lth_run2	] {
if (random() < 0.2) sound (self, CHAN_VOICE, "enforcer/idle1.wav", 1, ATTN_IDLE);
ai_run(18);};
void()	lth_run2	=[	$run2  ,	lth_run3	] {ai_run(14);};
void()	lth_run3	=[	$run3  ,	lth_run4	] {ai_run(7);};
void()	lth_run4	=[	$run4  ,	lth_run5	] {ai_run(12);};
void()	lth_run5	=[	$run5  ,	lth_run6	] {ai_run(14);};
void()	lth_run6	=[	$run6  ,	lth_run7	] {ai_run(14);};
void()	lth_run7	=[	$run7  ,	lth_run8	] {ai_run(7);};
void()	lth_run8	=[	$run8  ,	lth_run1	] {ai_run(11);};

void()	lth_atk1	=[	$attack1,	lth_atk2	] {ai_face();};
void()	lth_atk2	=[	$attack2,	lth_atk3	] {ai_face();};
void()	lth_atk3	=[	$attack3,	lth_atk4	] {ai_face();};
void()	lth_atk4	=[	$attack4,	lth_atk5	] {ai_face();};
void()	lth_atk5	=[	$attack5,	lth_atk6	] {ai_face();};
void()	lth_atk6	=[	$attack6,	lth_atk7	] {
	super_enforcer_fire();
	self.effects = self.effects | EF_MUZZLEFLASH;
};
void()	lth_atk7	=[	$attack7,	lth_atk8	] {
	super_enforcer_fire();
	if (random() < 0.9) {
		self.think = lth_atk6;
		self.nextthink = time + 0.1;
	}
};
void()	lth_atk8	=[	$attack8,	lth_atk9	] {};
void()	lth_atk9	=[	$attack3,	lth_atk10	] {};
void()	lth_atk10	=[	$attack2,	lth_atk11	] {};
void()	lth_atk11	=[	$attack1,	lth_run1	] {};

void()	lth_fdie1	=[	39,	lth_fdie2	] {};
void()	lth_fdie2	=[	40,	lth_fdie3	] {monster_check_gib();};
void()	lth_fdie3	=[	41,	lth_fdie4	] {monster_check_gib();};
void()	lth_fdie4	=[	42,	lth_fdie5	] {self.solid = SOLID_NOT; if (!self.gibbed) DropBackpack();};
void()	lth_fdie5	=[	43,	lth_fdie6	] {};
void()	lth_fdie6	=[	44,	lth_fdie7	] {};
void()	lth_fdie7	=[	45,	lth_fdie8	] {};
void()	lth_fdie8	=[	46,	lth_fdie9	] {};
void()	lth_fdie9	=[	47,	lth_fdie10	] {};
void()	lth_fdie10	=[	48,	lth_fdie11	] {monster_death_postcheck();};
void()	lth_fdie11	=[	49,	lth_fdie11	] {monster_deadbody_check();};

// Lieutant Enforcer from back2forwards by the Lieutenant
void() monster_super_enforcer = {
	if (monster_checkrandomizer() == TRUE) return; // Check for any random monster setups
	if (monster_checkspawn() == TRUE) return; // Check all spawn exceptions (monsters.qc)

	self.classtype = CT_MONSUPERENFORCER;
	// We drop the super nailgun on death :)
	if (world.devdata & DEV_AMMO_N_HEALTH && self.spawnflags & ENFORCER_LAVANG) world.deventity.ammo_lava_nails = world.deventity.ammo_lava_nails + AMMO_LAVA_NAILS_WPN;
	else if (world.devdata & DEV_AMMO_N_HEALTH)  world.deventity.ammo_nails = world.deventity.ammo_nails + AMMO_NAILS_WPN;

	if (self.health < 1) {
		if (skill == 0)
			self.health = 100;
		else
			self.health = 120;
	}
	self.armortype = 0.8; // What the heck??
	self.armorvalue = 1000; //Well...guess I'll leave it for posterity reasons

	if (self.spawnflags & ENFORCER_LAVANG) {
		self.ammo_lava_nails = rint(2 + random()*2);
	} else {
		self.ammo_nails = rint(2 + random()*2);
	}

	self.headmdl = "progs/h_mega.mdl";
	self.mdl = "progs/lieutenant/enforce2.mdl";
	self.th_stand 	= enf_stand1;
	self.th_walk 	= lth_walk1;
	self.th_run 	= lth_run1;
	self.gibhealth = MON_NEVERGIB;
	self.th_missile = lth_atk1;
	if (self.deathstring == "")  self.deathstring = " was nailed by a Lieutenant Enforcer\n";
	monster_base_enforcer();
};

void() monster_ultra = { self.spawnflags = self.spawnflags | ULTRA_ENF; monster_enforcer(); }; // Drake's commented out implementation of the Lieutenant's Ultra Enforcer.
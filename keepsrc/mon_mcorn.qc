// MANTICORE - by MadFox.

void() mcorn_stand1	=[	0,	mcorn_stand2	] {ai_stand();monster_idle_sound();};
void() mcorn_stand2	=[	1,	mcorn_stand3	] {ai_stand();};
void() mcorn_stand3	=[	2,	mcorn_stand4	] {ai_stand();};
void() mcorn_stand4	=[	3,	mcorn_stand5	] {ai_stand();};
void() mcorn_stand5	=[	4,	mcorn_stand6	] {ai_stand();};
void() mcorn_stand6	=[	5,	mcorn_stand7	] {ai_stand();};
void() mcorn_stand7	=[	6,	mcorn_stand8	] {ai_stand();};
void() mcorn_stand8	=[	7,	mcorn_stand9	] {ai_stand();};
void() mcorn_stand9	=[	8,	mcorn_stand10	] {ai_stand();};
void() mcorn_stand10=[	9,	mcorn_stand11	] {ai_stand();};
void() mcorn_stand11=[ 10,	mcorn_stand12	] {ai_stand();};
void() mcorn_stand12=[ 11,	mcorn_stand13	] {ai_stand();};
void() mcorn_stand13=[ 12,	mcorn_stand14	] {ai_stand();};
void() mcorn_stand14=[ 13,	mcorn_stand15	] {ai_stand();};
void() mcorn_stand15=[ 14,	mcorn_stand16	] {ai_stand();};
void() mcorn_stand16=[ 15,	mcorn_stand17	] {ai_stand();};
void() mcorn_stand17=[ 16,	mcorn_stand1	] {ai_stand();};

void() mcorn_walk1	=[	17, mcorn_walk2	] {ai_walk(8);};
void() mcorn_walk2	=[	18, mcorn_walk3	] {ai_walk(8);};
void() mcorn_walk3	=[	19, mcorn_walk4	] {ai_walk(8);};
void() mcorn_walk4	=[	20, mcorn_walk5	] {ai_walk(8);};
void() mcorn_walk5	=[	21, mcorn_walk6	] {ai_walk(8);monster_footstep(FALSE);monster_idle_sound();};
void() mcorn_walk6	=[	22, mcorn_walk7	] {ai_walk(8);};
void() mcorn_walk7	=[	23, mcorn_walk8	] {ai_walk(8);};
void() mcorn_walk8	=[	24, mcorn_walk9	] {ai_walk(8);};
void() mcorn_walk9	=[	25, mcorn_walk10] {ai_walk(8);};
void() mcorn_walk10	=[	26,	mcorn_walk11] {ai_walk(8);};
void() mcorn_walk11	=[	27,	mcorn_walk12] {ai_walk(8);};
void() mcorn_walk12	=[	28,	mcorn_walk13] {ai_walk(8);};
void() mcorn_walk13	=[	29,	mcorn_walk14] {ai_walk(8);monster_footstep(FALSE);};
void() mcorn_walk14	=[	30,	mcorn_walk15] {ai_walk(8);};
void() mcorn_walk15	=[	31,	mcorn_walk16] {ai_walk(8);};
void() mcorn_walk16	=[	32,	mcorn_walk1 ] {ai_walk(8);};

void() mcorn_run1		=[	34  ,	mcorn_run2	] {ai_run(16);monster_idle_sound();};
void() mcorn_run2		=[	35  ,	mcorn_run3	] {ai_run(32);};
void() mcorn_run3		=[	36  ,	mcorn_run4	] {ai_run(32);monster_footstep(FALSE);};
void() mcorn_run4		=[	37  ,	mcorn_run5	] {ai_run(20);};
void() mcorn_run5		=[	38  ,	mcorn_run6	] {ai_run(64);};
void() mcorn_run6		=[	39  ,	mcorn_run7	] {ai_run(32);};
void() mcorn_run7		=[	40  ,	mcorn_run8	] {ai_run(16);};
void() mcorn_run8		=[	41  ,	mcorn_run1	] {ai_run(32);};

// Melee tail swipe
void() mcorn_tailswipe = {
	local float ldmg;
	
	if (!self.enemy) return;
	if (self.health < 1) return;
	ai_face ();						// Turn towards enemy target
	walkmove (self.ideal_yaw, 12);	// Get extra close to enemy target
	ai_damagebreakable(20);			// Damage any breakables
	ldmg = 10 + 5*random();

	// Moved the check for melee distance to here with takedamage
	// If the demon is outside of melee range then need miss swipe sound
	// same goes for enemies that cannot be damaged (world geo mostly)
	if (!ai_checkmelee(MONAI_MELEEDEMON,FALSE) || !self.enemy.takedamage) {
		SwordSwipeSound(); // Melee claw miss sound
	} else {
		if (self.poisonous) {
			PoisonDeBuff(self.enemy); // Check for poisonous attribute, you know, just in case a mapper is being clever
			T_Damage (self.enemy, self, self, ldmg, DAMARMOR);
		} else {
			if (self.enemy.flags & FL_CLIENT) BleedDeBuff(self.enemy); // Don't apply T_Damage here or it will kill the player unfairly every time
			else T_Damage (self.enemy, self, self, ldmg, DAMARMOR);
		}

		sound (self, CHAN_WEAPON, "demon/dhit2.wav", 1, ATTN_NORM); // Melee claw hit sound
		SpawnMeatSpray (self, self.enemy, -150);
		SpawnMeatSpray (self, self.enemy, -175);
	}
};

// Projectile spit launch
void() mcorn_fire = {
	local vector org, vec;

	if (!self.enemy) return;

	makevectors (self.angles);
	org = self.origin + attack_vector(self.attack_offset);
	vec = normalize(self.enemy.origin - self.origin);
	launch_projectile(org, vec, CT_PROJ_MCOR1, SPEED_LASER);
};

// Barrage of ricocheting spikes in a fan spray shape
void() mcorn_barrage = {
	local	vector	offang;
	local	vector	org, dir;
	
	if (!self.enemy) return;
	if (self.health < 1) return;

	offang = vectoangles (self.enemy.origin - self.origin);
	offang_y = offang_y - 18;
	makevectors (offang);
	org = self.origin + self.mins + self.size*0.5 + v_forward * 20;
	dir = normalize (v_forward);
	dir_z = 0 - dir_z + (random() - 0.5)*0.1;
	//dir_z = 0.8; 
    launch_projectile (org, dir, CT_PROJ_MCOR2,(SPEED_HKSPIKE + ( skill * SPEED_HKSKILL)));

	offang = vectoangles (self.enemy.origin - self.origin);
	offang_y = offang_y - 12;
	makevectors (offang);
	org = self.origin + self.mins + self.size*0.5 + v_forward * 20;
	dir = normalize (v_forward);
	dir_z = 0 - dir_z + (random() - 0.5)*0.1;
	//dir_z = 0.8;
    launch_projectile (org, dir, CT_PROJ_MCOR2,(SPEED_HKSPIKE + ( skill * SPEED_HKSKILL)));

	offang = vectoangles (self.enemy.origin - self.origin);
	offang_y = offang_y - 6;
	makevectors (offang);
	org = self.origin + self.mins + self.size*0.5 + v_forward * 20;
	dir = normalize (v_forward);
	dir_z = 0 - dir_z + (random() - 0.5)*0.1;
	//dir_z = 0.8;
    launch_projectile (org, dir, CT_PROJ_MCOR2,(SPEED_HKSPIKE + ( skill * SPEED_HKSKILL)));

	offang = vectoangles (self.enemy.origin - self.origin);
	makevectors (offang);
	org = self.origin + self.mins + self.size*0.5 + v_forward * 20;
	dir = normalize (v_forward);
	dir_z = 0 - dir_z + (random() - 0.5)*0.1;
	//dir_z = 0.8;
    launch_projectile (org, dir, CT_PROJ_MCOR2,(SPEED_HKSPIKE + ( skill * SPEED_HKSKILL)));

	offang = vectoangles (self.enemy.origin - self.origin);
	offang_y = offang_y + 6;
	makevectors (offang);
	org = self.origin + self.mins + self.size*0.5 + v_forward * 20;
	dir = normalize (v_forward);
	dir_z = 0 - dir_z + (random() - 0.5)*0.1;
	//dir_z = 0.8;
    launch_projectile (org, dir, CT_PROJ_MCOR2,(SPEED_HKSPIKE + ( skill * SPEED_HKSKILL)));

	offang = vectoangles (self.enemy.origin - self.origin);
	offang_y = offang_y + 12;
	makevectors (offang);
	org = self.origin + self.mins + self.size*0.5 + v_forward * 20;
	dir = normalize (v_forward);
	dir_z = 0 - dir_z + (random() - 0.5)*0.1;
	//dir_z = 0.8;
    launch_projectile (org, dir, CT_PROJ_NG,(SPEED_HKSPIKE + ( skill * SPEED_HKSKILL)));

	offang = vectoangles (self.enemy.origin - self.origin);
	offang_y = offang_y + 18;
	makevectors (offang);
	org = self.origin + self.mins + self.size*0.5 + v_forward * 20;
	dir = normalize (v_forward);
	dir_z = 0 - dir_z + (random() - 0.5)*0.1;
	//dir_z = 0.8;
    launch_projectile (org, dir, CT_PROJ_MCOR2,(SPEED_HKSPIKE + ( skill * SPEED_HKSKILL)));
};

void() mcorn_projectiles = {
	if (random() < 0.1) mcorn_barrage();
	else mcorn_fire();
};

// Projectile spit attack
void() mcorn_atk1	=[	56,	mcorn_atk2	] {ai_face();};
void() mcorn_atk2	=[	57,	mcorn_atk3	] {ai_face();};
void() mcorn_atk3	=[	58,	mcorn_atk4	] {ai_face();sound (self, CHAN_VOICE, "qmaster/manticore/mon_manticore_attack1.wav", 1, ATTN_NORM);};
void() mcorn_atk4	=[	59,	mcorn_atk5	] {ai_face();};
void() mcorn_atk5	=[	60,	mcorn_atk6	] {};
void() mcorn_atk6	=[	61,	mcorn_atk7	] {mcorn_fire();};
void() mcorn_atk7	=[	65,	mcorn_atk8	] {}; // Skipped a few frames to keep it snappy and prevent overlap of actual projectile with manticore model's projectile.
void() mcorn_atk8	=[	66,	mcorn_run1	] {};

// Tail swipe!
void() mcorn_atka1	=[	67,	mcorn_atka2	] {ai_face();};
void() mcorn_atka2	=[	68,	mcorn_atka3	] {ai_face();};
void() mcorn_atka3	=[	69,	mcorn_atka4	] {ai_charge(2);};
void() mcorn_atka4	=[	70,	mcorn_atka5	] {
	ai_charge(4);
	if (random() < 0.5) sound (self, CHAN_VOICE, "qmaster/manticore/mon_manticore_attack2.wav", 1, ATTN_NORM);
	else sound (self, CHAN_VOICE, "qmaster/manticore/mon_manticore_attack3.wav", 1, ATTN_NORM);
};
void() mcorn_atka5	=[	71,	mcorn_atka6	] {mcorn_tailswipe();ai_charge(2);};
void() mcorn_atka6	=[	72,	mcorn_atka7	] {ai_face();};
void() mcorn_atka7	=[	73,	mcorn_atka8	] {ai_face();};
void() mcorn_atka8	=[	74,	mcorn_atka9	] {ai_face();};
void() mcorn_atka9	=[	75,	mcorn_atka10] {ai_face();};
void() mcorn_atka10	=[	76,	mcorn_atka11] {ai_face();};
void() mcorn_atka11	=[	77,	mcorn_atka12] {ai_face();};
void() mcorn_atka12	=[	78,	mcorn_atka13] {ai_face();};
void() mcorn_atka13	=[	79,	mcorn_run1	] {ai_face();};

// Spike barrage - either when player is unseen or behind
void() mcorn_atkb1	=[	80,	mcorn_atkb2	] {};
void() mcorn_atkb2	=[	81,	mcorn_atkb3	] {};
void() mcorn_atkb3	=[	82,	mcorn_atkb4	] {};
void() mcorn_atkb4	=[	83,	mcorn_atkb5	] {sound (self, CHAN_VOICE, "qmaster/manticore/mon_manticore_attack4.wav", 1, ATTN_NORM);};
void() mcorn_atkb5	=[	84,	mcorn_atkb6	] {mcorn_barrage();};
void() mcorn_atkb6	=[	85,	mcorn_atkb7	] {};
void() mcorn_atkb7	=[	86,	mcorn_run1	] {ai_face();};

void() mcorn_leap1	=[  80, mcorn_leap2	] {
	ai_face();
	self.jump_flag = time;	// No jump time limits
	if (self.skin == 1) sound (self, CHAN_VOICE, "demon/djump.wav", 1, ATTN_NORM);
	else {
		if (random() < 0.5) sound (self, CHAN_VOICE, "qmaster/manticore/mon_manticore_attack2.wav", 1, ATTN_NORM);
		else				sound (self, CHAN_VOICE, "qmaster/manticore/mon_manticore_attack3.wav", 1, ATTN_NORM);
	}
};
void() mcorn_leap2	=[  81, mcorn_leap3	] {ai_face();monster_footstep(FALSE);};
void() mcorn_leap3	=[  82, mcorn_leap4	] {ai_face();};
void() mcorn_leap4	=[  83, mcorn_leap5	] {ai_face();};
void() mcorn_leap5	=[  84, mcorn_leap6	] {ai_face();};
void() mcorn_leap6	=[  85, mcorn_leap7	] {
	ai_face();
	self.jump_flag = time;	// No jump time limits
	self.attack_finished = time + 0.6; // similar to fiend but we don't have extra jump frames for the flight
	self.touch = Demon_JumpTouch;
	makevectors (self.angles);
	self.velocity = v_forward * 1100 + '0 0 120';
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	self.oldorigin = self.origin;
};
void() mcorn_leap7	=[  85, mcorn_leap7	] {
	// Double check monster is still falling?
	if (CheckZeroVector(self.velocity) || self.oldorigin == self.origin) {
		self.ideal_yaw = random() * 360; //random jump angle
		self.think = mcorn_leap5;
	}
	self.oldorigin = self.origin;
};
void() mcorn_leap8	=[  86, mcorn_leap9	] {monster_footstep(FALSE);};
void() mcorn_leap9	=[  80, mcorn_run1	] {ai_resetangles();};

void() mcorn_pain1	=[	42 ,	mcorn_pain2	] {};
void() mcorn_pain2	=[	43 ,	mcorn_pain3	] {};
void() mcorn_pain3	=[	44 ,	mcorn_pain4	] {};
void() mcorn_pain4	=[	45 ,	mcorn_pain5	] {};
void() mcorn_pain5	=[	46 ,	mcorn_pain6	] {};
void() mcorn_pain6	=[	47 ,	mcorn_pain7	] {};
void() mcorn_pain7	=[	48 ,	mcorn_pain8	] {};
void() mcorn_pain8	=[	49 ,	mcorn_run1	] {};

void() mcorn_paina1	=[	50 ,	mcorn_paina2] {};
void() mcorn_paina2	=[	51 ,	mcorn_paina3] {};
void() mcorn_paina3	=[	52 ,	mcorn_paina4] {};
void() mcorn_paina4	=[	53 ,	mcorn_paina5] {};
void() mcorn_paina5	=[	54 ,	mcorn_paina6] {};
void() mcorn_paina6	=[	55 ,	mcorn_run1	] {};

void(entity inflictor, entity attacker, float damage) mcorn_pain = {
	local float r;

	r = random();
	if (r < 0.333) {
		sound (self, CHAN_VOICE, "qmaster/manticore/mon_manticore_pain3.wav", 1, ATTN_NORM);
	} else if (r < 0.666) {
		sound (self, CHAN_VOICE, "qmaster/manticore/mon_manticore_pain2.wav", 1, ATTN_NORM);
	} else {
		sound (self, CHAN_VOICE, "qmaster/manticore/mon_manticore_pain1.wav", 1, ATTN_NORM);
	}

	if (random() < 0.5) mcorn_paina1 ();
	else mcorn_pain1 ();
};

void() mcorn_die1	=[	87,	mcorn_die2	] {};
void() mcorn_die2	=[	88,	mcorn_die3	] {monster_check_gib();};
void() mcorn_die3	=[	89,	mcorn_die4	] {monster_check_gib();};
void() mcorn_die4	=[	90,	mcorn_die5	] {};
void() mcorn_die5	=[	91,	mcorn_die6	] {};
void() mcorn_die6	=[	92,	mcorn_die7	] {};
void() mcorn_die7	=[	93,	mcorn_die8	] {};
void() mcorn_die8	=[	94,	mcorn_die9	] {};
void() mcorn_die9	=[	95,	mcorn_die10 ] {};
void() mcorn_die10	=[	96,	mcorn_die11	] {};
void() mcorn_die11	=[	97,	mcorn_die12	] {};
void() mcorn_die12	=[	98,	mcorn_die13	] {};
void() mcorn_die13	=[	99,	mcorn_die14	] {};
void() mcorn_die14	=[	100,mcorn_die15	] {};
void() mcorn_die15	=[	101,mcorn_die16	] {};
void() mcorn_die16	=[	102,mcorn_die17	] {self.solid = SOLID_NOT;};
void() mcorn_die17	=[	103,mcorn_die18	] {};
void() mcorn_die18	=[	104,mcorn_die19	] {};
void() mcorn_die19	=[	105,mcorn_die20 ] {};
void() mcorn_die20	=[	106,mcorn_die21	] {};
void() mcorn_die21	=[	107,mcorn_die22	] {};
void() mcorn_die22	=[	108,mcorn_die23	] {};
void() mcorn_die23	=[	109,mcorn_die24	] {monster_death_postcheck();};
void() mcorn_die24	=[	110,mcorn_die24	] {monster_deadbody_check();sound(self, CHAN_VOICE, "qmaster/manticore/mon_manticore_ghostcall1.wav", 1, ATTN_NORM);};

// Invisible ghost that makes noises after death.  Is it dead?  IS IT???
void() mcorn_ghostthink = {
	local float r;

	r = random();
	if (r < 0.25) 		sound(self, CHAN_VOICE, "qmaster/manticore/mon_manticore_ghostcall1.wav", 0.5 + (random() * 0.5), ATTN_NORM);
	else if (r < 0.5)	sound(self, CHAN_VOICE, "qmaster/manticore/mon_manticore_ghostcall2.wav", 0.5 + (random() * 0.5), ATTN_NORM);
	else if (r < 0.75)	sound(self, CHAN_VOICE, "qmaster/manticore/mon_manticore_idle1.wav", 0.25 + (random() * 0.5), ATTN_NORM);
	else 				sound(self, CHAN_VOICE, "qmaster/manticore/mon_manticore_idle2.wav", 0.25 + (random() * 0.5), ATTN_NORM);
	self.think = mcorn_ghostthink;
	self.nextthink = time + (random() * 15);
};

void() mcorn_die = {
	local entity ghoster;

	// Pre-check routine to tidy up extra entities
	monster_death_precheck();

	ghoster = spawn();
	ghoster.solid = SOLID_NOT;
	ghoster.think = mcorn_ghostthink;
	ghoster.nextthink = time + 10 + (random() * 10);
	setorigin (ghoster,self.origin);

	// regular death
	if (!self.gibbed) {
		sound(self, CHAN_VOICE, "qmaster/manticore/mon_manticore_death2.wav", 1, ATTN_NORM);
		mcorn_die1 ();
	}
};

void() monster_mcorn_precache = {
	precache_model ("progs/madfox/h_mcorn.mdl");
	precache_model ("progs/madfox/mon_manticore.mdl");
	precache_model ("progs/madfox/proj_mcornflame.mdl");
	precache_model ("progs/q15/s_spike.mdl");
	precache_model ("progs/madfox/h_manticore.mdl");
	precache_sound ("qmaster/manticore/mon_manticore_attack1.wav");
	precache_sound ("qmaster/manticore/mon_manticore_attack2.wav");
	precache_sound ("qmaster/manticore/mon_manticore_attack3.wav");
	precache_sound ("qmaster/manticore/mon_manticore_attack4.wav");
	precache_sound ("qmaster/manticore/mon_manticore_death1.wav");
	precache_sound ("qmaster/manticore/mon_manticore_death2.wav");
	precache_sound ("qmaster/manticore/mon_manticore_ghostcall1.wav");
	precache_sound ("qmaster/manticore/mon_manticore_ghostcall2.wav");
	precache_sound ("qmaster/manticore/mon_manticore_gib.wav");
	precache_sound ("qmaster/manticore/mon_manticore_idle1.wav");
	precache_sound ("qmaster/manticore/mon_manticore_idle2.wav");
	precache_sound ("qmaster/manticore/mon_manticore_idle3.wav");
	precache_sound ("qmaster/manticore/mon_manticore_idle4.wav");
	precache_sound ("qmaster/manticore/mon_manticore_pain1.wav");
	precache_sound ("qmaster/manticore/mon_manticore_pain2.wav");
	precache_sound ("qmaster/manticore/mon_manticore_pain3.wav");
	precache_sound ("qmaster/manticore/mon_manticore_sight1.wav");
	precache_sound ("qmaster/manticore/mon_manticore_sight2.wav");
	precache_sound ("qmaster/manticore/mon_manticore_sight3.wav");
	precache_sound ("qmaster/manticore/mon_manticore_sight4.wav");
	precache_sound ("qmaster/manticore/mon_manticore_step1.wav");
	precache_sound ("qmaster/manticore/mon_manticore_step2.wav");
	precache_sound ("demon/dhit2.wav");
};

/*QUAKED monster_mcorn (1 0 0) (-32 -32 -24) (32 32 40) Ambush*/
void() monster_manticore = {
	if (monster_checkrandomizer() == TRUE) return; // Check for any random monster setups
	if (monster_checkspawn() == TRUE) return; // Check all spawn exceptions (monsters.qc)

	if (self.exactskin == 1) self.skin = 1;
	self.mdl = "progs/madfox/mon_manticore.mdl";
	self.headmdl = "progs/madfox/h_manticore.mdl";
	self.stepc1 = "qmaster/manticore/mon_manticore_step1.wav";
	self.stepc2 = "qmaster/manticore/mon_manticore_step2.wav";
	self.stepc3 = "qmaster/manticore/mon_manticore_step1.wav";
	self.stepc4 = "qmaster/manticore/mon_manticore_step2.wav";
	self.stepc5 = "qmaster/manticore/mon_manticore_step2.wav";
	if (!self.idle_sound) self.idle_sound = "qmaster/manticore/mon_manticore_idle1.wav";
	if (!self.idle_sound) self.idle_sound2 = "qmaster/manticore/mon_manticore_idle2.wav";
	if (!self.idle_sound) self.idle_soundcom = "qmaster/manticore/mon_manticore_idle3.wav";
	if (!self.idle_sound) self.idle_soundcom2 = "qmaster/manticore/mon_manticore_idle4.wav";
	if (!self.sight_sound) self.sight_sound = "qmaster/manticore/mon_manticore_sight1.wav";
	if (!self.sight_sound2) self.sight_sound2 = "qmaster/manticore/mon_manticore_sight2.wav";
	if (!self.sight_sound3) self.sight_sound3 = "qmaster/manticore/mon_manticore_sight3.wav";
	if (!self.sight_sound4) self.sight_sound4 = "qmaster/manticore/mon_manticore_sight4.wav";
	self.steptype = FS_TYPECUSTOM;
	self.solid = SOLID_NOT;				// No interaction with world
	self.movetype = MOVETYPE_NONE;		// Static item, no movement
	self.bbmins = '-48 -48 -24';	// Special Size
	self.bbmaxs = '48 48 24';
	self.bboxtype = BBOX_CUSTOM;	// Custom size
	if (self.health < 1) {
		self.health = 2400;
		if (skill > 1) self.health = self.health + 600; // 3000 on hard/nightmare
		if (self.skin == 1) self.health = self.health + 1000; // 3400 to 4000 for a Lich fiend
	}
	self.gibhealth = -120; 				// Hard to gib
	self.gibbed = FALSE;
	self.pain_flinch = 400;				// Really low chance of pain
	self.pain_timeout = 2;				// High pain threshold
	self.blockudeath = TRUE;			// No humanoid death sound
	self.attack_offset = '0 0 20';

	// Always reset resistances to be consistent
	self.resist_shells = self.resist_cells = 0;
	self.resist_rockets = self.resist_nails = 0.5;
	if (self.skin == 1) self.resist_fire = 1; // Can't burn a Lich Fiend
	if (self.skin != 1) self.resist_cold = 1; // Can't freeze a Manticore

	// Check for random rotation setup and angle limits
	if (self.angles_y < 0) self.angles_y = rint(random()*359);
	if (self.angles_y > 360) self.angles_y = 360;

	if (self.deathstring == "") {
		if (self.skin == 1) self.deathstring = " was mercilessly devoured by a Lich Fiend\n";
		else				self.deathstring = " was mauled by a Manticore\n";
	}

	self.th_checkattack = ManticoreCheckAttack;
	if (self.skin == 1) self.th_checkattack = DemonCheckAttack;
	self.th_stand = mcorn_stand1;
	self.th_walk = mcorn_walk1;
	self.th_run = mcorn_run1;
	self.th_pain = mcorn_pain;
	self.th_die = mcorn_die;
	self.th_melee = mcorn_atka1;
	self.th_jump = mcorn_leap1;		// jump attack
	self.th_jumpexit = mcorn_leap8;
	self.th_missile = mcorn_atk1;
	if (self.skin == 1) self.th_missile = self.th_jump; // just in case, Lich Fiend doesn't spit

	self.classtype = CT_MONMANTICORE;
	if (self.skin == 1) self.classtype = CT_MONLICHFIEND;
	self.classgroup = CG_DEMON;
	self.classmove = MON_MOVEWALK;
	monster_start();
};

void() monster_mcorn = {self.classname = "monster_manticore"; monster_manticore();};
void() monster_lichfiend = {self.exactskin = 1; self.skin = 1; monster_manticore();};
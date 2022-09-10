void() dlord_move1;
void() dlord_run1;
void() dlord_idle_sound;

void() dguard_hit = { // [FUNCTION]
	if (vlen(self.enemy.origin - self.origin) > 100) {
		if (random() < 0.5) {
			sound(self,CHAN_WEAPON,"quoth/dguard/slmiss1.wav",1,ATTN_NORM);
		} else {
			sound(self,CHAN_WEAPON,"quoth/dguard/slmiss2.wav",1,ATTN_NORM);
		}
		return;
	}
	sound(self,CHAN_WEAPON,"quoth/dguard/slhit.wav",1,ATTN_NORM);
	T_Damage(self.enemy, self, self, 30,DAMARMOR);
	// Check for poisonous attribute (new poison version)
	if (self.poisonous) PoisonDeBuff(self.enemy);
};

void(void() thinkst) SUB_DLordCheckRefire = { // [FUNCTION]
	local vector spot1;
	local vector spot2;
	local entity targ;

	if (self.dlord_firecnt > 30) {
		self.dlord_firecnt = 0;
		return;
	}
	targ = self.enemy;
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;
	traceline(spot1,spot2, 0, self);
	if (trace_ent == targ)
		self.dlord_playervis = time + 0.8;

	if (trace_ent != targ && self.dlord_playervis < time)
		return;

	self.think = thinkst;
};

void() dlord_shot_think = { // [FUNCTION]
	if (self.enemy.health < 1)
		return;

	self.velocity = self.velocity * 0.4 + (self.enemy.origin - (self.origin + '0 0 -12')) * 0.6;
	self.velocity = normalize(self.velocity);
	self.velocity = self.velocity * 750;
	self.nextthink = time + 0.1;
	self.think = dlord_shot_think;	
};

void(float offset) dlord_shot = { // [FUNCTION]
	local vector offang;
	local vector org;
	local vector vec;

	if (visible(self.enemy))
		self.oldorigin = self.enemy.origin;

	if (visible(self.enemy)) {
		offang = vectoangles(self.enemy.origin - self.origin);
	} else {
		offang = vectoangles(self.oldorigin - self.origin);
	}
	offang_y = offang_y + offset * 6;
	makevectors(offang);
	org = self.origin + '0 0 24' + v_forward * 20;
	vec = normalize(v_forward);
	vec_z = 0 - vec_z + (random() - 0.5) * 0.2;
	hknight_shot(offset);
	newmis.classname = "knightspike";
	setmodel(newmis, "progs/quoth/dspike.mdl");
	newmis.enemy = self.enemy;
	if (visible(self.enemy)) {
		newmis.think = dlord_shot_think;
	} else {
		newmis.think = SUB_Null;
	}
	newmis.nextthink = time + 0.1;
	newmis.avelocity = '500 500 500';
	setsize(newmis, VEC_ORIGIN, VEC_ORIGIN);
	newmis.velocity = vec * 750;
};

void() shieldon = { // [FUNCTION]
	self.shield = 1;
	self.effects = EF_BRIGHTFIELD;
	self.takedamage = DAMAGE_YES;
};

void() shieldoff = { // [FUNCTION]
	self.shield = 0;
	self.effects = 0;
	self.takedamage = DAMAGE_AIM;
};

void() dlord_stand1 = [0, dlord_stand2] { ai_stand(); };
void() dlord_stand2 = [1, dlord_stand3] { ai_stand(); };
void() dlord_stand3 = [2, dlord_stand4] { ai_stand(); };
void() dlord_stand4 = [3, dlord_stand5] { ai_stand(); };
void() dlord_stand5 = [4, dlord_stand6] { ai_stand(); };
void() dlord_stand6 = [5, dlord_stand7] { ai_stand(); };
void() dlord_stand7 = [6, dlord_stand8] { ai_stand(); };
void() dlord_stand8 = [7, dlord_stand9] { ai_stand(); };
void() dlord_stand9 = [8, dlord_stand1] { ai_stand(); };

void() dlord_walk1 = [9, dlord_walk2] { dlord_idle_sound(); ai_walk(2); };
void() dlord_walk2 = [10, dlord_walk3] { ai_walk(5); };
void() dlord_walk3 = [11, dlord_walk4] { ai_walk(5); };
void() dlord_walk4 = [12, dlord_walk5] { ai_walk(4); };
void() dlord_walk5 = [13, dlord_walk6] { ai_walk(4); };
void() dlord_walk6 = [14, dlord_walk7] { ai_walk(2); };
void() dlord_walk7 = [15, dlord_walk8] { ai_walk(2); };
void() dlord_walk8 = [16, dlord_walk9] { ai_walk(3); };
void() dlord_walk9 = [17, dlord_walk10] { ai_walk(3); };
void() dlord_walk10 = [18, dlord_walk11] { ai_walk(4); };
void() dlord_walk11 = [19, dlord_walk12] { ai_walk(3); };
void() dlord_walk12 = [20, dlord_walk13] { ai_walk(4); };
void() dlord_walk13 = [21, dlord_walk14] { ai_walk(6); };
void() dlord_walk14 = [22, dlord_walk15] { ai_walk(2); };
void() dlord_walk15 = [23, dlord_walk16] { ai_walk(2); };
void() dlord_walk16 = [24, dlord_walk17] { ai_walk(4); };
void() dlord_walk17 = [25, dlord_walk18] { ai_walk(3); };
void() dlord_walk18 = [26, dlord_walk19] { ai_walk(3); };
void() dlord_walk19 = [27, dlord_walk20] { ai_walk(3); };
void() dlord_walk20 = [28, dlord_walk1] { ai_walk(2); };

void() dlord_move1 = [9, dlord_move2] { ai_run(2 * 1.5); shieldon(); };
void() dlord_move2 = [10, dlord_move3] { ai_run(5 * 1.5); };
void() dlord_move3 = [11, dlord_move4] { ai_run(5 * 1.5); };
void() dlord_move4 = [12, dlord_move5] { ai_run(4 * 1.5); };
void() dlord_move5 = [13, dlord_move6] { ai_run(4 * 1.5); };
void() dlord_move6 = [14, dlord_move7] { ai_run(2 * 1.5); };
void() dlord_move7 = [15, dlord_move8] { ai_run(2 * 1.5); };
void() dlord_move8 = [16, dlord_move9] { ai_run(3 * 1.5); };
void() dlord_move9 = [17, dlord_move10] { ai_run(3 * 1.5); };
void() dlord_move10 = [18, dlord_move11] { ai_run(4 * 1.5); };
void() dlord_move11 = [19, dlord_move12] { ai_run(3 * 1.5); };
void() dlord_move12 = [20, dlord_move13] { ai_run(4 * 1.5); };
void() dlord_move13 = [21, dlord_move14] { ai_run(6 * 1.5); };
void() dlord_move14 = [22, dlord_move15] { ai_run(2 * 1.5); };
void() dlord_move15 = [23, dlord_move16] { ai_run(2 * 1.5); };
void() dlord_move16 = [24, dlord_move17] { ai_run(4 * 1.5); };
void() dlord_move17 = [25, dlord_move18] { ai_run(3 * 1.5); };
void() dlord_move18 = [26, dlord_move19] { ai_run(3 * 1.5); };
void() dlord_move19 = [27, dlord_move20] { ai_run(3 * 1.5); };
void() dlord_move20 = [28, dlord_move1] { ai_run(2 * 1.5); dlord_idle_sound(); };

void() dlord_run1 = [29, dlord_run2] { dlord_idle_sound(); ai_run(20); };
void() dlord_run2 = [30, dlord_run3] { ai_run(25); };
void() dlord_run3 = [31, dlord_run4] { ai_run(18); };
void() dlord_run4 = [32, dlord_run5] { ai_run(16); };
void() dlord_run5 = [33, dlord_run6] { ai_run(14); };
void() dlord_run6 = [34, dlord_run7] { ai_run(25); };
void() dlord_run7 = [35, dlord_run8] { ai_run(21); };
void() dlord_run8 = [36, dlord_run1] { ai_run(13); };

void() dlord_pain1 = [37, dlord_pain2] { sound(self,CHAN_VOICE, "quoth/dlord/pain.wav",1,ATTN_NORM); shieldon(); };
void() dlord_pain2 = [38, dlord_pain3] {};
void() dlord_pain3 = [39, dlord_pain4] {};
void() dlord_pain4 = [40, dlord_pain5] {};
void() dlord_pain5 = [41, dlord_move1] {};

void() dlord_die1 = [42, dlord_die2] { ai_forward(10); };
void() dlord_die2 = [43, dlord_die3] { ai_forward(8); };
void() dlord_die3 = [44, dlord_die4] { self.solid = SOLID_NOT; ai_forward(7); };
void() dlord_die4 = [45, dlord_die5] {};
void() dlord_die5 = [46, dlord_die6] {};
void() dlord_die6 = [47, dlord_die7] {};
void() dlord_die7 = [48, dlord_die8] {};
void() dlord_die8 = [49, dlord_die9] { ai_forward(10); };
void() dlord_die9 = [50, dlord_die10] { ai_forward(11); };
void() dlord_die10 = [51, dlord_die11] {};
void() dlord_die11 = [52, dlord_die12] { monster_death_postcheck(); };
void() dlord_die12 = [53, dlord_die12] { monster_deadbody_check(); };

void() dlord_dieb1 = [54, dlord_dieb2] {};
void() dlord_dieb2 = [55, dlord_dieb3] {};
void() dlord_dieb3 = [56, dlord_dieb4] { self.solid = SOLID_NOT; };
void() dlord_dieb4 = [57, dlord_dieb5] {};
void() dlord_dieb5 = [58, dlord_dieb6] {};
void() dlord_dieb6 = [59, dlord_dieb7] {};
void() dlord_dieb7 = [60, dlord_dieb8] {};
void() dlord_dieb8 = [61, dlord_dieb9] { monster_death_postcheck(); };
void() dlord_dieb9 = [62, dlord_dieb9] { monster_deadbody_check(); };

void() dlord_die = { // [FUNCTION]
	// Pre-check routine to tidy up extra entities
	monster_death_precheck();

	self.effects = 0;
	if (!self.gibbed) {
		sound(self,CHAN_VOICE, "quoth/dlord/death.wav",1,ATTN_NORM);
		if (random() > 0.5) { dlord_die1();
		} else { dlord_dieb1(); }
	}
};

void(float vertoffset) dlord_light = { // [FUNCTION]
	local vector org, org2, dir, offang;

	offang_z = offang_z + vertoffset;
	makevectors(offang);
	self.effects = self.effects | EF_MUZZLEFLASH;
	ai_face();
	org = self.origin + offang;
	org2 = self.origin + '0 0 20';
	dir = self.enemy.origin + '0 0 16' - org2;
	dir = normalize(dir);
	traceline(org, self.origin + dir * 200, 1, self);
	Tent_Beam(TE_LIGHTNING2,self,org,trace_endpos);
	LightningDamage(org, trace_endpos, self, 5);
};

void() dlord_magicd1 = [93, dlord_magicd2] { ai_face(); shieldoff(); };
void() dlord_magicd2 = [94, dlord_magicd3] { ai_face(); };
void() dlord_magicd3 = [95, dlord_magicd4] { ai_face(); };
void() dlord_magicd4 = [96, dlord_magicd5] { ai_face(); };
void() dlord_magicd5 = [97, dlord_magicd6] { ai_face(); };
void() dlord_magicd6 = [98, dlord_magicd7] { ai_face(); };
void() dlord_magicd7 = [99, dlord_magicd8] { ai_face(); };
void() dlord_magicd8 = [100, dlord_magicd9] { ai_face(); shieldoff(); };
void() dlord_magicd9 = [101, dlord_magicd10] {
	local float temprnd;

	ai_face();
	temprnd = random();
	if (temprnd < 0.4) {
		dlord_shot(0);
	} else {
		if (temprnd <= 0.7) {
			dlord_shot(CONTENT_EMPTY);
		} else {
			dlord_shot(1);
		}
	}
	sound(self,CHAN_WEAPON,"hknight/attack1.wav",1,ATTN_NORM);
	self.dlord_firecnt = self.dlord_firecnt + 1;
	shieldoff();
	SUB_DLordCheckRefire(dlord_magicd8);
};
void() dlord_magicd10 = [102, dlord_magicd11] { ai_face(); };
void() dlord_magicd11 = [103, dlord_magicd12] { ai_face(); };
void() dlord_magicd12 = [104, dlord_magicd13] { ai_face(); };
void() dlord_magicd13 = [105, dlord_move1] { ai_face(); };

void() dlord_magica1 = [79, dlord_magica2] { ai_face(); shieldoff(); };
void() dlord_magica2 = [80, dlord_magica3] { ai_face(); shieldoff(); };
void() dlord_magica3 = [81, dlord_magica4] { ai_face(); shieldoff(); };
void() dlord_magica4 = [82, dlord_magica5] { ai_face(); shieldoff(); };
void() dlord_magica5 = [83, dlord_magica6] { ai_face(); shieldoff(); };
void() dlord_magica6 = [84, dlord_magica7] { ai_face(); shieldoff(); };
void() dlord_magica7 = [85, dlord_magica8] { dlord_light(40); sound(self,CHAN_AUTO,"weapons/lstart.wav",1,ATTN_NORM); shieldoff(); };
void() dlord_magica8 = [86, dlord_magica9] { dlord_light(25); shieldoff(); };
void() dlord_magica9 = [87, dlord_magica10] { dlord_light(0); dguard_hit(); shieldoff(); };
void() dlord_magica10 = [88, dlord_magica11] { dlord_light(-20); shieldoff(); };
void() dlord_magica11 = [89, dlord_magica12] { dlord_light(-24); shieldoff(); };
void() dlord_magica12 = [90, dlord_magica13] { dlord_light(-14); shieldoff(); };
void() dlord_magica13 = [91, dlord_magica14] { ai_face(); };
void() dlord_magica14 = [92, dlord_move1] { ai_face(); };

void() dlord_char_a1 = [63, dlord_char_a2] { ai_charge(20); };
void() dlord_char_a2 = [64, dlord_char_a3] { ai_charge(25); };
void() dlord_char_a3 = [65, dlord_char_a4] { ai_charge(18); };
void() dlord_char_a4 = [66, dlord_char_a5] { ai_charge(16); };
void() dlord_char_a5 = [67, dlord_char_a6] { ai_charge(14); };
void() dlord_char_a6 = [68, dlord_char_a7] { ai_charge(20); ai_melee(); };
void() dlord_char_a7 = [69, dlord_char_a8] { ai_charge(21); ai_melee(); };
void() dlord_char_a8 = [70, dlord_char_a9] { ai_charge(13); ai_melee(); };
void() dlord_char_a9 = [71, dlord_char_a10] { ai_charge(20); ai_melee(); };
void() dlord_char_a10 = [72, dlord_char_a11] { ai_charge(20); ai_melee(); };
void() dlord_char_a11 = [73, dlord_char_a12] { ai_charge(18); ai_melee(); };
void() dlord_char_a12 = [74, dlord_char_a13] { ai_charge(16); };
void() dlord_char_a13 = [75, dlord_char_a14] { ai_charge(14); };
void() dlord_char_a14 = [76, dlord_char_a15] { ai_charge(25); };
void() dlord_char_a15 = [77, dlord_char_a16] { ai_charge(21); };
void() dlord_char_a16 = [78, dlord_run1] { ai_charge(13); };

void() dlord_slice1 = [112, dlord_slice2] { ai_charge(9); };
void() dlord_slice2 = [113, dlord_slice3] { ai_charge(6); };
void() dlord_slice3 = [114, dlord_slice4] { ai_charge(13); };
void() dlord_slice4 = [115, dlord_slice5] { ai_charge(4); };
void() dlord_slice5 = [116, dlord_slice6] { ai_charge(TE_WIZSPIKE); ai_melee(); };
void() dlord_slice6 = [117, dlord_slice7] { ai_charge(15); ai_melee(); };
void() dlord_slice7 = [118, dlord_slice8] { ai_charge(SECRET_NO_SHOOT); ai_melee(); };
void() dlord_slice8 = [119, dlord_slice9] { ai_charge(2); ai_melee(); };
void() dlord_slice9 = [120, dlord_slice10] { ai_melee(); };
void() dlord_slice10 = [121, dlord_run1] { ai_charge(3); };

void() dlord_smash1 = [122, dlord_smash2] { ai_charge(1); };
void() dlord_smash2 = [123, dlord_smash3] { ai_charge(13); };
void() dlord_smash3 = [124, dlord_smash4] { ai_charge(9); };
void() dlord_smash4 = [125, dlord_smash5] { ai_charge(TE_TELEPORT); };
void() dlord_smash5 = [126, dlord_smash6] { ai_charge(TE_LAVASPLASH); ai_melee(); };
void() dlord_smash6 = [127, dlord_smash7] { ai_charge(TE_WIZSPIKE); ai_melee(); };
void() dlord_smash7 = [128, dlord_smash8] { ai_charge(12); ai_melee(); };
void() dlord_smash8 = [129, dlord_smash9] { ai_charge(2); ai_melee(); };
void() dlord_smash9 = [130, dlord_smash10] { ai_charge(3); ai_melee(); };
void() dlord_smash10 = [131, dlord_smash11] { ai_charge(0); };
void() dlord_smash11 = [132, dlord_run1] { ai_charge(0); };

void() dlord_watk1 = [133, dlord_watk2] { ai_charge(2); };
void() dlord_watk2 = [134, dlord_watk3] { ai_charge(0); };
void() dlord_watk3 = [135, dlord_watk4] { ai_charge(0); };
void() dlord_watk4 = [136, dlord_watk5] { ai_melee(); };
void() dlord_watk5 = [137, dlord_watk6] { ai_melee(); };
void() dlord_watk6 = [138, dlord_watk7] { ai_melee(); };
void() dlord_watk7 = [139, dlord_watk8] { ai_charge(1); };
void() dlord_watk8 = [140, dlord_watk9] { ai_charge(4); };
void() dlord_watk9 = [141, dlord_watk10] { ai_charge(5); };
void() dlord_watk10 = [142, dlord_watk11] { ai_charge(3); ai_melee(); };
void() dlord_watk11 = [143, dlord_watk12] { ai_charge(2); ai_melee(); };
void() dlord_watk12 = [144, dlord_watk13] { ai_charge(2); ai_melee(); };
void() dlord_watk13 = [145, dlord_watk14] { ai_charge(0); };
void() dlord_watk14 = [146, dlord_watk15] { ai_charge(0); };
void() dlord_watk15 = [147, dlord_watk16] { ai_charge(0); };
void() dlord_watk16 = [148, dlord_watk17] { ai_charge(1); };
void() dlord_watk17 = [149, dlord_watk18] { ai_charge(1); ai_melee(); };
void() dlord_watk18 = [150, dlord_watk19] { ai_charge(3); ai_melee(); };
void() dlord_watk19 = [151, dlord_watk20] { ai_charge(4); ai_melee(); };
void() dlord_watk20 = [152, dlord_watk21] { ai_charge(6); };
void() dlord_watk21 = [153, dlord_watk22] { ai_charge(TE_WIZSPIKE); };
void() dlord_watk22 = [154, dlord_run1] { ai_charge(3); };

void() dlord_idle_sound = { // [FUNCTION]
	if (random() < 0.2) sound(self,CHAN_VOICE, "quoth/dlord/idle.wav",1,ATTN_NORM);
};

void(entity inflictor, entity attacker, float damage) dlord_pain = {
	if (self.pain_finished > time) return;

	sound(self,CHAN_VOICE, "quoth/dlord/pain.wav",1,ATTN_NORM);

	if (random() * 50 > damage) return;

	self.pain_finished = time + 12;
	dlord_pain1();
};

void() magic_choice = { // [FUNCTION]
	local vector dist;
	local float d;
	dist = self.enemy.origin - self.origin;
	dist_z = 0;
	d = vlen(dist);
	if (d < 200) {
		if (random() <= 0.4 || self.ltime < time) {
			self.ltime = time + 5;
			shieldon();
			dlord_magica1();
		}
	} else {
		if (d >= 200) {
			if (random() <= 0.6 || self.ltime < time) {
				self.ltime = time + 3;
				shieldon();
				dlord_magicd1();
			}
		}
	}
};

void() monster_death_lord_precache = {
	precache_model("progs/qmaster/mon_hknight.mdl");
	precache_model("progs/quoth/dspike.mdl");
	precache_model("progs/h_hellkn.mdl");
	precache_sound("hknight/attack1.wav");
	precache_sound("quoth/dlord/death.wav");
	precache_sound("quoth/dlord/pain.wav");
	precache_sound("quoth/dlord/sight.wav");
	precache_sound("quoth/dlord/idle.wav");
	precache_sound("knight/sword1.wav");
	precache_sound("knight/sword2.wav");
	precache_sound("quoth/dguard/slhit.wav");
	precache_sound("quoth/dguard/slmiss1.wav");
	precache_sound("quoth/dguard/slmiss2.wav");
};

void() monster_death_lord = {
	if (monster_checkrandomizer() == TRUE) return; // Check for any random monster setups
	if (monster_checkspawn() == TRUE) return; // Check all spawn exceptions (monsters.qc)

	self.mdl = "progs/qmaster/mon_hknight.mdl";
	self.headmdl = "progs/h_hellkn.mdl";
	self.th_stand = dlord_stand1;
	self.th_walk = dlord_walk1;
	self.th_run = dlord_move1;
	self.th_melee = dlord_magica1;
	self.th_missile = magic_choice;
	self.th_pain = dlord_pain;
	self.th_die = dlord_die;
	self.skin = 7;
	self.solid = SOLID_NOT;				// No interaction with world
	self.movetype = MOVETYPE_NONE;		// Static item, no movement
	if (self.bboxtype < 1) self.bboxtype = BBOX_TALL;
	if (self.health < 1) self.health = 400;
	self.gibhealth = -60;
	self.gibbed = FALSE;
	self.pain_flinch = 80;				// Take a lot to go into pain
	self.pain_timeout = 2;				// Shambler like pain level
	self.infightextra = 2;				// Double damage to other monsters
	self.steptype = FS_TYPEHEAVY;		// Heavy Player feet
	self.hittype = HIT_METAL;
	Resist_ChangeType(self,-1); // Always reset Ammo Resistance to be consistent
	if (self.deathstring == "") self.deathstring = " was executed by a Death Lord\n";
	self.classtype = CT_MONDLORD;
	self.classgroup = CG_DCAPTAIN;
	self.classmove = MON_MOVEWALK;
	monster_start();
};
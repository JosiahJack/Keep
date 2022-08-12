// LITTLE CUTY
$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8 stand9 stand10 
$frame stand11 stand12 stand13 stand14 stand15 stand16 stand17 stand18 stand19 
$frame stand20 
$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9 walk10 walk11
$frame walk12 walk13 walk14 walk15 walk16 walk17 walk18 walk19 walk20
$frame walk21 walk22 walk23 walk24
$frame run1 run2 run3 run4 run5 run6 run7 run8 run9
$frame atk1 atk2 atk3 atk4 atk5 atk6 atk7 atk8 atk9 atk10
$frame rush1 rush2 rush3 rush4 rush5 rush6 rush7 rush8 rush9 rush10 
$frame rush11 rush12 rush13
$frame pain1 pain2 pain3 pain4 pain5 pain6 pain7 pain8 pain9 
$frame paina1 paina2 paina3 paina4 paina5 paina6
$frame painc1 painc2 painc3 painc4 painc5 painc6 painc7 painc8
$frame die1 die2 die3 die4 die5 die6 die7 die8 die9 die10 
$frame die11 die12 die13 die14 die15 die16
$frame dieb1 dieb2 dieb3 dieb4 dieb5 dieb6 dieb7 dieb8 dieb9 dieb10 
$frame dieb11 dieb12 dieb13 dieb14 dieb15 dieb16

void()	octa_atk6;
void()	octa_atka6;

void()	octa_stand1	= [	$stand1,	octa_stand2	] { ai_stand(); monster_idle_sound(); };
void()	octa_stand2	= [	$stand2,	octa_stand3	] { ai_stand(); };
void()	octa_stand3	= [	$stand3,	octa_stand4	] { ai_stand(); };
void()	octa_stand4	= [	$stand4,	octa_stand5	] { ai_stand(); };
void()	octa_stand5	= [	$stand5,	octa_stand6	] { ai_stand(); };
void()	octa_stand6	= [	$stand6,	octa_stand7	] { ai_stand(); };
void()	octa_stand7	= [	$stand7,	octa_stand8	] { ai_stand(); };
void()	octa_stand8	= [	$stand8,	octa_stand9	] { ai_stand(); };
void()	octa_stand9	= [	$stand9,	octa_stand10	] { ai_stand(); };
void()	octa_stand10	= [	$stand10,	octa_stand11	] { ai_stand(); };
void()	octa_stand11	= [	$stand11,	octa_stand12	] { ai_stand(); };
void()	octa_stand12	= [	$stand12,	octa_stand13	] { ai_stand(); };
void()	octa_stand13	= [	$stand13,	octa_stand14	] { ai_stand(); };
void()	octa_stand14	= [	$stand14,	octa_stand15	] { ai_stand(); };
void()	octa_stand15	= [	$stand15,	octa_stand16	] { ai_stand(); };
void()	octa_stand16	= [	$stand16,	octa_stand17	] { ai_stand(); };
void()	octa_stand17	= [	$stand17,	octa_stand18	] { ai_stand(); };
void()	octa_stand18	= [	$stand18,	octa_stand19	] { ai_stand(); };
void()	octa_stand19	= [	$stand19,	octa_stand20	] { ai_stand(); };
void()	octa_stand20	= [	$stand20,	octa_stand1	] { ai_stand(); };

void()	octa_walk1	= [	$walk1 ,	octa_walk2	] { ai_walk(2); monster_idle_sound(); };
void()	octa_walk2	= [	$walk2 ,	octa_walk3	] { ai_walk(4); };
void()	octa_walk3	= [	$walk3 ,	octa_walk4	] { ai_walk(4); };
void()	octa_walk4	= [	$walk4 ,	octa_walk5	] { ai_walk(3); };
void()	octa_walk5	= [	$walk5 ,	octa_walk6	] { ai_walk(1); };
void()	octa_walk6	= [	$walk6 ,	octa_walk7	] { ai_walk(2); };
void()	octa_walk7	= [	$walk7 ,	octa_walk8	] { ai_walk(2); };
void()	octa_walk8	= [	$walk8 ,	octa_walk9	] { ai_walk(1); };
void()	octa_walk9	= [	$walk9 ,	octa_walk10	] { ai_walk(2); };
void()	octa_walk10	= [	$walk10,	octa_walk11	] { ai_walk(4); };
void()	octa_walk11	= [	$walk11,	octa_walk12	] { ai_walk(4); };
void()	octa_walk12	= [	$walk12,	octa_walk13	] { ai_walk(1); };
void()	octa_walk13	= [	$walk13,	octa_walk14	] { ai_walk(2); };
void()	octa_walk14	= [	$walk14,	octa_walk15	] { ai_walk(3); };
void()	octa_walk15	= [	$walk15,	octa_walk16	] { ai_walk(4); };
void()	octa_walk16	= [	$walk16,	octa_walk17	] { ai_walk(2); };
void()	octa_walk17	= [	$walk17,	octa_walk18	] { ai_walk(2); };
void()	octa_walk18	= [	$walk18,	octa_walk19	] { ai_walk(1); };
void()	octa_walk19	= [	$walk19,	octa_walk20	] { ai_walk(2); };
void()	octa_walk20	= [	$walk20,	octa_walk21	] { ai_walk(4); };
void()	octa_walk21	= [	$walk21,	octa_walk22	] { ai_walk(4); };
void()	octa_walk22	= [	$walk22,	octa_walk23	] { ai_walk(1); };
void()	octa_walk23	= [	$walk23,	octa_walk24	] { ai_walk(2); };
void()	octa_walk24	= [	$walk24,	octa_walk1	] { ai_walk(3); };

void()	octa_run1	= [	$run1  ,	octa_run2	] { ai_run(18); monster_idle_sound(); };
void()	octa_run2	= [	$run2  ,	octa_run3	] { ai_run(14); };
void()	octa_run3	= [	$run3  ,	octa_run4	] { ai_run(7); };
void()	octa_run4	= [	$run4  ,	octa_run5	] { ai_run(12); };
void()	octa_run5	= [	$run5  ,	octa_run6	] { ai_run(14); };
void()	octa_run6	= [	$run6  ,	octa_run7	] { ai_run(14); };
void()	octa_run7	= [	$run7  ,	octa_run8	] { ai_run(7); };
void()	octa_run8	= [	$run8  ,	octa_run9	] {
	ai_run(11);
	if (random() < 0.2) {
		self.enemydist = range_distance(self.enemy,TRUE);
		if (self.enemydist > 256) {
			octa_atk6();
		}
	}
};
void()	octa_run9	= [	$run9  ,	octa_run1	] { ai_run(12);sound(self,CHAN_VOICE,"tronyn/mon_bigfish_swim1.wav",1,ATTN_NORM); };

void()	octa_atk1	= [	$atk1,  	octa_atk2	] { ai_face(); };
void()	octa_atk2	= [	$atk2,  	octa_atk3	] { ai_face(); };
void()	octa_atk3	= [	$atk3,  	octa_atk4	] { ai_face(); };
void()	octa_atk4	= [	$atk4,  	octa_atk5	] { ai_face(); };
void()	octa_atk5	= [	$atk5,  	octa_atk6	] {
	ai_face();
	if (self.enemydist <= 100) ai_melee();
	else if (self.enemydist < 384) pyro_fire();
};
void()	octa_atk6	= [	$atk6,  	octa_atk7	] { ai_face(); if (self.enemydist <= 100) ai_melee(); };
void()	octa_atk7	= [	$atk7,	    octa_atk8	] { ai_face(); if (self.enemydist <= 100) ai_melee(); };
void()	octa_atk8	= [	$atk8,  	octa_atk9	] { ai_face(); };
void()	octa_atk9	= [	$atk9,  	octa_atk10	] { ai_face(); };
void()	octa_atk10	= [	$atk10,  	octa_run1	] { ai_face(); };

void()	octa_atka1	= [	$rush1,  	octa_atka2	] { ai_run(18); if (self.enemydist <= 100) ai_melee(); };
void()	octa_atka2	= [	$rush2,  	octa_atka3	] { ai_run(16); if (self.enemydist <= 100) ai_melee(); };
void()	octa_atka3	= [	$rush3,  	octa_atka4	] { ai_run(8); if (self.enemydist <= 100) ai_melee(); };
void()	octa_atka4	= [	$rush4,  	octa_atka5	] { ai_run(6); };
void()	octa_atka5	= [	$rush5,  	octa_atka6	] {
	ai_run(2);
	self.enemydist = range_distance(self.enemy,TRUE);
	if (self.enemydist < 256) octa_run8();
};
void()	octa_atka6	= [	$rush6,  	octa_atka7	] { ai_run(2); };
void()	octa_atka7	= [	$rush7,	    octa_atka8	] { ai_run(2); };
void()	octa_atka8	= [	$rush8,  	octa_atka9	] { ai_run(4); };
void()	octa_atka9	= [	$rush9,  	octa_atka10	] { ai_run(6); };
void()	octa_atka10	= [	$rush10,  	octa_atka11	] { ai_run(8); };
void()	octa_atka11	= [	$rush11,  	octa_atka12	] { ai_run(8); };
void()	octa_atka12	= [	$rush12,  	octa_atka13	] { ai_run(16); if (self.enemydist <= 100) ai_melee(); };
void()	octa_atka13	= [	$rush13,  	octa_run1	] { ai_run(22); if (self.enemydist <= 100) ai_melee(); sound(self,CHAN_VOICE,"tronyn/mon_bigfish_swim2.wav",1,ATTN_NORM); };

void() octa_attack = {
	sound(self,CHAN_WEAPON,"tronyn/mon_anglerfish_bite.wav",1,ATTN_NORM);
	self.enemydist = range_distance(self.enemy,TRUE);
	octa_atk1();
};

void()  octa_pain1	= [	$pain1, 	octa_pain2	] {};
void()	octa_pain2	= [	$pain2, 	octa_pain3	] {};
void()	octa_pain3	= [	$pain3, 	octa_pain4	] {};
void()	octa_pain4	= [	$pain4, 	octa_pain5	] {};
void()	octa_pain5	= [	$pain5, 	octa_pain6	] {};
void()	octa_pain6	= [	$pain6, 	octa_pain7	] {};
void()	octa_pain7	= [	$pain7, 	octa_pain8	] {};
void()	octa_pain8	= [	$pain8, 	octa_pain9	] {};
void()	octa_pain9	= [	$pain9, 	octa_run1	] {};

void()	octa_paina1	= [	$paina1, 	octa_paina2	] {};
void()	octa_paina2	= [	$paina2, 	octa_paina3	] {};
void()	octa_paina3	= [	$paina3, 	octa_paina4	] {};
void()	octa_paina4	= [	$paina4, 	octa_paina5	] {};
void()	octa_paina5	= [	$paina5, 	octa_paina6	] {};
void()	octa_paina6	= [	$paina6, 	octa_run1	] {};

void()	octa_painc1	= [	$painc1, 	octa_painc2	] {};
void()	octa_painc2	= [	$painc2, 	octa_painc3	] {};
void()	octa_painc3	= [	$painc3, 	octa_painc4	] {};
void()	octa_painc4	= [	$painc4, 	octa_painc5	] {};
void()	octa_painc5	= [	$painc5, 	octa_painc6	] {};
void()	octa_painc6	= [	$painc6, 	octa_painc7	] {};
void()	octa_painc7	= [	$painc7, 	octa_painc8	] {};
void()	octa_painc8	= [	$painc8, 	octa_run1	] {};

void(entity inflictor, entity attacker, float damage) octa_pain = {
	monster_pain_check(attacker,damage); // Check all pain conditions and set up what to do next

	// Any pain animation/sound required?
	if (self.pain_check > 0) {
		if (self.pain_sound != "") sound(self,CHAN_VOICE,self.pain_sound,1,ATTN_NORM);
		self.pain_finished = time + 1.5;
		self.lip = random();
		if (self.lip < 0.333) octa_pain1();
		else if (self.lip < 0.666) octa_paina1();
		else  octa_painc1();
	}
};

void()	octa_die1	= [	$die1,  	octa_die2	] {};
void()	octa_die2	= [	$die2,  	octa_die3	] { monster_check_gib(); };
void()	octa_die3	= [	$die3,  	octa_die4	] { monster_check_gib(); };
void()	octa_die4	= [	$die4,  	octa_die5	] { ai_forward(14); };
void()	octa_die5	= [	$die5,  	octa_die6	] { ai_forward(2); };
void()	octa_die6	= [	$die6,  	octa_die7	] {};
void()	octa_die7	= [	$die7,  	octa_die8	] {};
void()	octa_die8	= [	$die8,  	octa_die9	] {};
void()	octa_die9	= [	$die9,  	octa_die10	] { ai_forward(3); };
void()	octa_die10	= [	$die10,  	octa_die11	] { ai_forward(5); };
void()	octa_die11	= [	$die11,  	octa_die12	] { ai_forward(5); };
void()	octa_die12	= [	$die12,  	octa_die13	] { ai_forward(5); };
void()	octa_die13	= [	$die13,  	octa_die14	] {};
void()	octa_die14	= [	$die14,  	octa_die15 	] { self.solid = SOLID_NOT; };
void()	octa_die15	= [	$die15,  	octa_die16	] { monster_death_postcheck(); };
void()	octa_die16	= [	$die16,  	octa_die16	] { monster_deadbody_check(); };

void()	octa_dieb1	= [	$dieb1,  	octa_dieb2	] {};
void()	octa_dieb2	= [	$dieb2,  	octa_dieb3	] { monster_check_gib(); };
void()	octa_dieb3	= [	$dieb3,  	octa_dieb4	] { monster_check_gib(); };
void()	octa_dieb4	= [	$dieb4,  	octa_dieb5	] { ai_forward(14); };
void()	octa_dieb5	= [	$dieb5,  	octa_dieb6	] { ai_forward(2); };
void()	octa_dieb6	= [	$dieb6,  	octa_dieb7	] {};
void()	octa_dieb7	= [	$dieb7,  	octa_dieb8	] {};
void()	octa_dieb8	= [	$dieb8,  	octa_dieb9	] {};
void()	octa_dieb9	= [	$dieb9,  	octa_dieb10	] { ai_forward(3); };
void()	octa_dieb10	= [	$dieb10,  	octa_dieb11	] { ai_forward(5); };
void()	octa_dieb11	= [	$dieb11,  	octa_dieb12	] { ai_forward(5); };
void()	octa_dieb12	= [	$dieb12,  	octa_dieb13	] { ai_forward(5); };
void()	octa_dieb13	= [	$dieb13,  	octa_dieb14	] {};
void()	octa_dieb14	= [	$dieb14,  	octa_dieb15 ] { self.solid = SOLID_NOT; };
void()	octa_dieb15	= [	$dieb15,  	octa_dieb16	] { monster_death_postcheck(); };
void()	octa_dieb16	= [	$dieb16,  	octa_dieb16	] { monster_deadbody_check(); };

void() octa_die = {
	monster_death_precheck();
	if (!self.gibbed) {
		sound(self,CHAN_VOICE,"tronyn/mon_bigfish_death.wav",1,ATTN_NORM);
		self.lip = random();
		if (self.lip < 0.5) octa_die1();
		else octa_dieb1();
	}
};

void() monster_octa_precache = {
	precache_model("progs/madfox/mon_octa_extra.mdl");
	precache_model("progs/madfox/wink.spr");
    precache_model("progs/custents/beamhit.spr");
	precache_model("progs/w_spike.mdl");
	precache_sound("tronyn/mon_anglerfish_bite.wav");
	precache_sound("tronyn/mon_bigfish_bite.wav");
	precache_sound("tronyn/mon_bigfish_swim1.wav");
	precache_sound("tronyn/mon_bigfish_swim2.wav");
	precache_sound("tronyn/mon_seahorse_swim1.wav");
	precache_sound("tronyn/mon_seahorse_swim2.wav");
	precache_sound("tronyn/mon_bigfish_pain.wav");
	precache_sound("ad171/ogre/ogrefish_out.wav");
	precache_sound("tronyn/mon_bigfish_death.wav");
};

// QUAKED monster_octa (1 0 0) (-16 -16 -24) (16 16 40) Ambush
void() monster_octa = {
	if (monster_checkrandomizer() == TRUE) return; // Check for any random monster setups
	if (monster_checkspawn() == TRUE) return; // Check all spawn exceptions (monsters.qc)

	self.mdl = "progs/madfox/mon_octa_extra.mdl";
	self.idle_sound = "tronyn/mon_seahorse_swim1.wav";
	self.idle_sound = "tronyn/mon_seahorse_swim1.wav";
	self.idle_soundcom = "ad171/ogre/ogrefish_out.wav";
	self.sight_sound = "tronyn/mon_bigfish_bite.wav";
	self.pain_sound = "tronyn/mon_bigfish_pain.wav";
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_NONE;
	self.gibhealth = -80;
	self.gibbed = FALSE;
	self.pain_flinch = 30;
	self.steptype = FS_FLYING;			// It has tentacles!?!
	self.blockudeath = TRUE;			// No humanoid death sound
	if (self.health < 1) self.health = 120;
	if ( (random () < 0.500) ) {
		if (self.deathstring == "") self.deathstring = " was inked by an Octopus\n";
	} else {
		if (self.deathstring == "") self.deathstring = " was drowned by an Octopus\n";
	}
	self.move_state = '0 8 12';
	if (self.spawnflags & MON_LIQUIDBLOCK) self.liquidblock = TRUE; // Check for water sightline wakeup
	Resist_ChangeType(self,-1); // Always reset Ammo Resistance to be consistent
	if (self.bboxtype < 1) self.bboxtype = BBOX_TALL;
	self.th_stand = octa_stand1;
	self.th_walk = octa_walk1;
	self.th_run = octa_run1;
	self.th_melee = octa_attack;
	self.th_missile = octa_attack;
	self.th_pain = octa_pain;
	self.th_die = octa_die;
	self.classtype = CT_MONOCTOPUS;
	self.classgroup = CG_FISH;
	self.classmove = MON_MOVESWIM;
	monster_start();
};
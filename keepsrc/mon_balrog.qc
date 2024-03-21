$cd /raid/quake/id1/models/balrog
$origin 0 -6 24
$base base		
$skin skin0
$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8 stand9
$frame stand10 stand11 stand12 stand13
$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8
$frame walk9 walk10 walk11 walk12 walk13 walk14 walk15   
$frame run1 run2 run3 run4 run5 run6 run7 
$frame pain1 pain2 pain3 pain4 pain5 pain6 pain7 pain8 pain9
$frame paina1 paina2 paina3 paina4 paina5 
$frame atk1 atk2 atk3 atk4 atk5 atk6 atk7 atk8 atk9 atk10 atk11 atk12
$frame atk13 atk14
$frame die1 die2 die3 die4 die5 die6 die7 die8 die9 die10 die11 die12
$frame die13 die14 die15 die16 die17 die18 die19

void()	blrog_atk1	=[	$atk1,  	blrog_atk2	] {ai_face();};
void()	blrog_atk2	=[	$atk2,  	blrog_atk3	] {ai_face();};
void()	blrog_atk3	=[	$atk3,  	blrog_atk4	] {ai_face();};
void()	blrog_atk4	=[	$atk4,  	blrog_atk5	] {ai_face();};
void()	blrog_atk5	=[	$atk5,  	blrog_atk6	] {ai_face();};
void()	blrog_atk6	=[	$atk6,  	blrog_atk7	] {ai_face();};
void()	blrog_atk7	=[	$atk7,  	blrog_atk8	] {ai_face();};
void()	blrog_atk8	=[	$atk8,  	blrog_atk9	] {ai_face();};
void()	blrog_atk9	=[	$atk9,  	blrog_atk10	] {ai_face();};
void()	blrog_atk10	=[	$atk10, 	blrog_atk11	] {ftop_fire('0 0 56');};
void()	blrog_atk11	=[	$atk11, 	blrog_atk12	] {ai_face();};
void()	blrog_atk12	=[	$atk12, 	blrog_atk13	] {ai_face();};
void()	blrog_atk13	=[	$atk13, 	blrog_atk14	] {ai_face();};
void()	blrog_atk14	=[	$atk14, 	monster_run_start	] {};

//void()	blrog_pain1	=[	$pain1, 	blrog_pain2	] {};
//void()	blrog_pain2	=[	$pain2, 	blrog_pain3	] {};
//void()	blrog_pain3	=[	$pain3, 	blrog_pain4	] {};
//void()	blrog_pain4	=[	$pain4, 	blrog_pain5	] {};
//void()	blrog_pain5	=[	$pain5, 	blrog_pain6	] {};
//void()	blrog_pain6	=[	$pain6, 	blrog_pain7	] {};
//void()	blrog_pain7	=[	$pain7, 	blrog_pain8	] {};
//void()	blrog_pain8	=[	$pain8, 	blrog_pain9	] {};
//void()	blrog_pain9	=[	$pain9, 	monster_run_start	] {};

//void()	blrog_paina1	=[	$paina1, 	blrog_paina2	] {};
//void()	blrog_paina2	=[	$paina2, 	blrog_paina3	] {};
//void()	blrog_paina3	=[	$paina3, 	blrog_paina4	] {};
//void()	blrog_paina4	=[	$paina4, 	blrog_paina5	] {};
//void()	blrog_paina5	=[	$paina5, 	monster_run_start	] {};

void()	blrog_die1	=[	$die1,  	blrog_die2	] {};
void()	blrog_die2	=[	$die2,  	blrog_die3	] {monster_check_gib(); };
void()	blrog_die3	=[	$die3,  	blrog_die4	] {monster_check_gib(); self.solid = SOLID_NOT;};
void()	blrog_die4	=[	$die4,  	blrog_die5	] {};
void()	blrog_die5	=[	$die5,  	blrog_die6	] {};
void()	blrog_die6	=[	$die6,  	blrog_die7	] {};
void()	blrog_die7	=[	$die7,  	blrog_die8	] {};
void()	blrog_die8	=[	$die8,  	blrog_die9	] {};
void()	blrog_die9	=[	$die9,  	blrog_die10	] {};
void()	blrog_die10	=[	$die10, 	blrog_die11	] {};
void()	blrog_die11	=[	$die11, 	blrog_die12	] {};
void()	blrog_die12	=[	$die12, 	blrog_die13	] {};
void()	blrog_die13	=[	$die13, 	blrog_die14	] {};
void()	blrog_die14	=[	$die14, 	blrog_die15	] {};
void()	blrog_die15	=[	$die15, 	blrog_die16	] {};
void()	blrog_die16	=[	$die16, 	blrog_die17	] {};
void()	blrog_die17	=[	$die17, 	blrog_die18	] {};
void()	blrog_die18	=[	$die18, 	blrog_die19	] { monster_death_postcheck(); };
void()	blrog_die19	=[	$die19, 	blrog_die19	] { monster_deadbody_check(); };

void() blrog_die = {
	monster_death_precheck();
	sound(self, CHAN_VOICE,self.death_sound, 1, ATTN_NORM);
	blrog_die1();
};

void() monster_balrog_precache = {
	precache_model("progs/madfox/mon_balrog.mdl");
	precache_model("progs/ad171/proj_balllava.mdl");
	precache_model("progs/gib1.mdl");
	precache_model("progs/gib2.mdl");
	precache_model("progs/gib3.mdl");
	precache_sound("ad171/chthon/death1.wav");
	precache_sound("boss1/pain.wav");
	precache_sound("ad171/chthon/attack1.wav");
	precache_sound("player/udeath.wav");		// gib death
	precache_sound(SOUND_LASER_HIT);
	precache_sound(SOUND_LASER_FIRE);
};

/*QUAKED monster_balrog (1 0 0) (-16 -16 -24) (16 16 40) Ambush*/
void() monster_balrog = {	
	if (monster_checkrandomizer() == TRUE) return;
	
	// Frame definitions
	self.framemax = 250;
	self.frate = 0.1;
	self.idle1framestart = 0;
	self.idle1frameend = 12;
	self.idlesoundframe1 = self.idlesoundframe2 = 0;
	self.walk1framestart = 13;
	self.walk1frameend = 27;
	self.walkidlesoundframe1 = self.walkidlesoundframe2 = 13;
	self.walkstepframe1 = 17;
	self.walkstepframe2 = 24;
	self.walkspeedframe1 = 6;
	self.walkspeedframe2 = 8;
	self.walkspeedframe3 = 10;
	self.walkspeedframe4 = 4;
	self.walkspeedframe5 = 4; // Step
	self.walkspeedframe6 = 4;
	self.walkspeedframe7 = 4;
	self.walkspeedframe8 = 6;
	self.walkspeedframe9 = 8;
	self.walkspeedframe10 = 10;
	self.walkspeedframe11 = 4;
	self.walkspeedframe12 = 4; // Step
	self.walkspeedframe13 = 4;
	self.walkspeedframe14 = 4;
	self.walkspeedframe15 = 4;
	self.run1framestart = 28;
	self.run1frameend = 34;
	self.runidlesoundframe1 = self.runidlesoundframe2 = 28;
	self.runstepframe1 = 31;
	self.runstepframe2 = 34;
	self.runspeedframe1 = 12;
	self.runspeedframe2 = 12;
	self.runspeedframe3 = 12;
	self.runspeedframe4 = 12;
	self.runspeedframe5 = 12;
	self.runspeedframe6 = 12;
	self.pain1framestart = 35;
	self.pain1frameend = 43;
	self.pain2framestart = 44;
	self.pain2frameend = 48;

	self.mdl = "progs/madfox/mon_balrog.mdl";
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_NONE;
	self.pain_sound = "boss1/pain.wav";
	self.death_sound = "ad171/chthon/death1.wav";
	if (self.bboxtype < 1) {
		self.bbmins = '-52 -52 -48';	// Special Size
		self.bbmaxs = '52 52 72';
		self.bboxtype = BBOX_CUSTOM;	// Custom size
	}

	self.scale = 2.22;
	if (self.health < 1) self.health = 1800;
	self.effects = (self.effects | EF_DIMLIGHT);
	self.gibhealth = MON_NEVERGIB;
	self.gibbed = FALSE;
	self.pain_flinch = 800;
	self.pain_longanim = FALSE;
	self.steptype = FS_TYPEGIANT;
	Resist_ChangeType(self,-1); // Always reset Ammo Resistance to 0 to be consistent.
	self.resist_rockets = 0.5;       // Explosives and flame resistance.
	self.resist_multi_rockets = 0.5;
	self.resist_lava_nails = 0.5;
	self.resist_fire = 0.5;
	self.th_stand = monster_stand_start;
	self.th_walk = monster_walk;
	self.th_run = monster_run_start;
	self.th_missile =  blrog_atk1; 
	self.th_pain = monster_pain;
	self.th_pain1 = monster_pain1_start;
	self.th_pain2 = monster_pain2_start;
	self.th_die = blrog_die;
	self.classtype = CT_MONBALROG;
	self.classgroup = CG_BOSS;
	self.classmove = MON_MOVEWALK;
	monster_start ();
};

void()	blrog_atk1	=[92,blrog_atk2] {ai_face();}; // [FUNCTION]
void()	blrog_atk2	=[93,blrog_atk3] {ai_face();}; // [FUNCTION]
void()	blrog_atk3	=[93,blrog_atk4] {ai_face();}; // [FUNCTION]
void()	blrog_atk4	=[94,blrog_atk5] {ai_face();}; // [FUNCTION]
void()	blrog_atk5	=[95,blrog_atk6] {ftop_fire('0 0 56');}; // [FUNCTION]
void()	blrog_atk6	=[96,blrog_atk7] {}; // [FUNCTION]
void()	blrog_atk7	=[97,blrog_atk8] {}; // [FUNCTION]
void()	blrog_atk8	=[98,monster_run_start] {}; // [FUNCTION]

void()	blrog_atkb1	=[99,blrog_atkb2] {ai_face();}; // [FUNCTION]
void()	blrog_atkb2	=[100,blrog_atkb3] {ai_face();}; // [FUNCTION]
void()	blrog_atkb3	=[101,blrog_atkb4] {ai_face(); SwordSwipeSound(); T_Damage(self.enemy,self,self,self.dmg,DAMARMOR);}; // [FUNCTION]
void()	blrog_atkb4	=[102,blrog_atkb5] {ai_face(); ai_melee_side(); }; // [FUNCTION]
void()	blrog_atkb5	=[103,blrog_atkb6] {ai_face(); ai_melee_side(); monster_footstep(FALSE); }; // [FUNCTION]
void()	blrog_atkb6	=[104,blrog_atkb7] {ai_face();ai_melee_side(); }; // [FUNCTION]
void()	blrog_atkb7	=[105,monster_run_start] { ai_melee_side(); }; // [FUNCTION]

void()	blrog_die1	=[106,blrog_die2] {}; // [FUNCTION]
void()	blrog_die2	=[107,blrog_die3] { monster_check_gib(); }; // [FUNCTION]
void()	blrog_die3	=[108,blrog_die4] { monster_check_gib(); self.solid = SOLID_NOT;}; // [FUNCTION]
void()	blrog_die4	=[109,blrog_die5] {}; // [FUNCTION]
void()	blrog_die5	=[110,blrog_die6] {}; // [FUNCTION]
void()	blrog_die6	=[111,blrog_die7] {}; // [FUNCTION]
void()	blrog_die7	=[112,blrog_die8] {}; // [FUNCTION]
void()	blrog_die8	=[113,blrog_die9] {}; // [FUNCTION]
void()	blrog_die9	=[114,blrog_die10] {}; // [FUNCTION]
void()	blrog_die10	=[115,blrog_die11] {}; // [FUNCTION]
void()	blrog_die11	=[116,blrog_die12] {}; // [FUNCTION]
void()	blrog_die12	=[118,blrog_die13] {}; // [FUNCTION]
void()	blrog_die13	=[119,blrog_die14] {}; // [FUNCTION]
void()	blrog_die14	=[120,blrog_die15] {}; // [FUNCTION]
void()	blrog_die15	=[121,blrog_die16] {}; // [FUNCTION]
void()	blrog_die16	=[122,blrog_die17] {}; // [FUNCTION]
void()	blrog_die17	=[123,blrog_die18] { monster_death_postcheck();}; // [FUNCTION]
void()	blrog_die18	=[124,blrog_die18] { monster_deadbody_check(); }; // [FUNCTION]

void()	blrog_dieb1	=[125,blrog_dieb2] {}; // [FUNCTION]
void()	blrog_dieb2	=[126,blrog_dieb3] { monster_check_gib(); }; // [FUNCTION]
void()	blrog_dieb3	=[127,blrog_dieb4] { monster_check_gib(); self.solid = SOLID_NOT;}; // [FUNCTION]
void()	blrog_dieb4	=[128,blrog_dieb5] {}; // [FUNCTION]
void()	blrog_dieb5	=[129,blrog_dieb6] {}; // [FUNCTION]
void()	blrog_dieb6	=[130,blrog_dieb7] {}; // [FUNCTION]
void()	blrog_dieb7	=[131,blrog_dieb8] {}; // [FUNCTION]
void()	blrog_dieb8	=[132,blrog_dieb9] {}; // [FUNCTION]
void()	blrog_dieb9	=[133,blrog_dieb10] {}; // [FUNCTION]
void()	blrog_dieb10=[134,blrog_dieb11] {}; // [FUNCTION]
void()	blrog_dieb11=[135,blrog_dieb12] {}; // [FUNCTION]
void()	blrog_dieb12=[136,blrog_dieb13] {}; // [FUNCTION]
void()	blrog_dieb13=[137,blrog_dieb14] {}; // [FUNCTION]
void()	blrog_dieb14=[138,blrog_dieb15] { ai_forward(1); }; // [FUNCTION]
void()	blrog_dieb15=[139,blrog_dieb16] { ai_forward(3); }; // [FUNCTION]
void()	blrog_dieb16=[140,blrog_dieb17] { ai_forward(5); }; // [FUNCTION]
void()	blrog_dieb17=[141,blrog_dieb18] { ai_forward(12); }; // [FUNCTION]
void()	blrog_dieb18=[142,blrog_dieb19] { ai_forward(8); }; // [FUNCTION]
void()	blrog_dieb19=[143,blrog_dieb20] {}; // [FUNCTION]
void()	blrog_dieb20=[144,blrog_dieb21] {}; // [FUNCTION]
void()	blrog_dieb21=[145,blrog_dieb22] {}; // [FUNCTION]
void()	blrog_dieb22=[146,blrog_dieb23] {}; // [FUNCTION]
void()	blrog_dieb23=[147,blrog_dieb24] {}; // [FUNCTION]
void()	blrog_dieb24=[148,blrog_dieb25] { monster_death_postcheck(); }; // [FUNCTION]
void()	blrog_dieb25=[149,blrog_dieb25] { monster_deadbody_check(); }; // [FUNCTION]

void() blrog_die = { // [FUNCTION]
	monster_death_precheck();
	sound(self, CHAN_VOICE,self.death_sound, 1, ATTN_NORM);
	if (random() < 0.5) blrog_die1();
	else  blrog_dieb1();
};

void() monster_balrog_precache = { // [FUNCTION]
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
void() monster_balrog = { // [ENTITY]
	if (monster_checkrandomizer() == TRUE) return;
	
	// Frame definitions
	self.framemax = 250;
	self.frate = 0.1;
	self.idle1framestart = 1;
	self.idle1frameend = 38;
	self.idlesoundframe1 = self.idlesoundframe2 = 0;
	self.walk1framestart = 39;
	self.walk1frameend = 63;
	self.walkidlesoundframe1 = self.walkidlesoundframe2 = 39;
	self.walkstepframe1 = 46;
	self.walkstepframe2 = 59;
	self.walkspeedframe1 = 4;
	self.run1framestart = 64;
	self.run1frameend = 72;
	self.runidlesoundframe1 = self.runidlesoundframe2 = 64;
	self.runstepframe1 = 70;
	self.runstepframe2 = 74;
	self.runspeedframe1 = 14;
	self.pain1framestart = 73;
	self.pain1frameend = 81;
	self.pain2framestart = 82;
	self.pain2frameend = 91;

	self.mdl = "progs/madfox/mon_balrog.mdl";
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_NONE;
	self.pain_sound = "boss1/pain.wav";
	self.death_sound = "ad171/chthon/death1.wav";
	if (self.bboxtype < 1) {
		self.bbmins = '-52 -52 -24';	// Special Size
		self.bbmaxs = '52 52 72';
		self.bboxtype = BBOX_CUSTOM;	// Custom size
	}

	self.scale = 2.22;
	if (self.health < 1) self.health = 1800;
	self.effects = (self.effects | EF_DIMLIGHT);
	self.gibhealth = MON_NEVERGIB;
	self.gibbed = FALSE;
	self.pain_flinch = 20;
	self.dmg = 18;
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
	self.th_melee = blrog_atkb1;
	self.th_missile =  blrog_atk1;
	self.th_pain = monster_pain;
	self.th_pain1 = monster_pain1_start;
	self.th_pain2 = monster_pain2_start;
	self.th_die = blrog_die;
	self.classtype = CT_MONBALROG;
	self.classgroup = CG_BOSS;
	self.classmove = MON_MOVEWALK;

	if ( (random () < 0.500) ) {
		if (self.deathstring == "")  self.deathstring = " delved too deeply and disturbed a Balrog\n";
	} else {
		if (self.deathstring == "")  self.deathstring = " was pulled to the depths by a Balrog\n";
	}

	monster_start ();
};

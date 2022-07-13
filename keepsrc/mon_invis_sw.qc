// Rogue Invisible Sword (New animations, eyes attachment, and skin by Redfield)

// Frame macros for Redfield version, rogue is explicit frame numbers.  DANGEROUS!!
$frame stand1
$frame run1 run2 run3 run4 run5 run6 run7 run8 
$frame atk1 atk2 atk3 atk4 atk5 atk6 atk7 atk8 atk9 atk10
$frame death1 death2 death3 death4 death5 death6 death7 death8 death9 death10
$frame deathb1 deathb2 deathb3 deathb4 deathb5 deathb6 deathb7 deathb8 deathb9
$frame deathb10 deathb11 
$frame lean1
$frame idle1 idle2 idle3 idle4 idle5 idle6 idle7 idle8 idle9 idle10

float INVIS_SWORD_REDFIELD = 2;

// Redfield attachment eyes create
void() sword_create_attachment = {
	self.attachment = spawn();
	self.attachment.classtype = CT_ATTACHMENT;
	self.attachment.state = FALSE;
};

// Redfield attachment eyes setup
void() sword_setup_attachment = {
	if (self.attachment) {
		self.attachment.movetype = MOVETYPE_STEP;
		self.attachment.solid = SOLID_NOT;
		setmodel(self.attachment, MODEL_SWORDEYES);
		setsize (self.attachment, VEC_ORIGIN, VEC_ORIGIN);
		self.attachment.state = TRUE;
		self.attachment.alpha = self.alpha;
		if (self.spawnflags & MON_SWORD_BLUE) self.attachment.skin = 1;
	}
};

// Redfield eye blinking (attachment is eyes)
void() sword_eyecheck = {
	if (self.spawnflags & MON_SWORD_EYES) {
		if (!self.attachment) { 
			sword_create_attachment();
			sword_setup_attachment(); 
		}
		self.attachment.frame = self.frame;
		self.attachment.origin = self.origin;
		self.attachment.angles = self.angles;
   } 
};

// Rogue idle
void() sword_stand1 = [ 0.000, sword_stand1 ] { ai_stand(); };

// Redfield idle sound
void() sword_sound = {
	self.count = self.count + 1;
	if (self.count > 3) {
		if (random() < 0.3) {
			sound(self,CHAN_VOICE, "redfield/sword/die.wav",1,ATTN_NORM);
			self.count = 0;
		}
	} else return;
};

// Rogue run
void() sword_run1 = [ 1.000, sword_run2 ] {
   self.effects = EF_DIMLIGHT;
   ai_run (14);
};
void() sword_run2 = [ 2.000, sword_run3 ] { ai_run (14); };
void() sword_run3 = [ 3.000, sword_run4 ] { ai_run (14); };
void() sword_run4 = [ 4.000, sword_run5 ] { ai_run (14); };
void() sword_run5 = [ 5.000, sword_run6 ] { ai_run (14); };
void() sword_run6 = [ 6.000, sword_run7 ] { ai_run (14); };
void() sword_run7 = [ 7.000, sword_run8 ] { ai_run (14); };
void() sword_run8 = [ 8.000, sword_run1 ] { ai_run (14); };

// Rogue attack
void() sword_atk1 = [ 9.000, sword_atk2 ] {
   sound(self,FALSE,"knight/sword1.wav",TRUE,TRUE);
   ai_charge (14);
};
void() sword_atk2 = [ 10.000, sword_atk3 ] { ai_charge (14); };
void() sword_atk3 = [ 11.000, sword_atk4 ] { ai_charge (14); };
void() sword_atk4 = [ 12.000, sword_atk5 ] { ai_charge (14); };
void() sword_atk5 = [ 13.000, sword_atk6 ] { ai_melee(); };
void() sword_atk6 = [ 14.000, sword_atk7 ] { ai_melee(); };
void() sword_atk7 = [ 15.000, sword_atk8 ] { ai_melee(); };
void() sword_atk8 = [ 16.000, sword_atk9 ] { ai_charge (14); };
void() sword_atk9 = [ 17.000, sword_atk10 ] { ai_charge (14); };
void() sword_atk10 = [ 18.000, sword_run1 ] { ai_charge (14); };

// Rogue die
void() sword_die1 = [ 19.000, sword_die2 ] {};
void() sword_die2 = [ 20.000, sword_die3 ] { monster_check_gib(); };
void() sword_die3 = [ 21.000, sword_die4 ] { self.solid = SOLID_NOT; monster_check_gib(); };
void() sword_die4 = [ 22.000, sword_die5 ] {};
void() sword_die5 = [ 23.000, sword_die6 ] {};
void() sword_die6 = [ 24.000, sword_die7 ] {};
void() sword_die7 = [ 25.000, sword_die8 ] { sound(self,TRUE,"player/axhit2.wav",0.500,ATTN_NORM); };
void() sword_die8 = [ 26.000, sword_die9 ] {};
void() sword_die9 = [ 27.000, sword_die10 ] { monster_death_postcheck(); };
void() sword_die10 = [ 28.000, sword_die10 ] { monster_deadbody_check(); };

// Rogue dieb
void() sword_dieb1 = [ 29.000, sword_dieb2 ] {};
void() sword_dieb2 = [ 30.000, sword_dieb3 ] { monster_check_gib(); };
void() sword_dieb3 = [ 31.000, sword_dieb4 ] { self.solid = SOLID_NOT; monster_check_gib(); };
void() sword_dieb4 = [ 32.000, sword_dieb5 ] {};
void() sword_dieb5 = [ 33.000, sword_dieb6 ] {};
void() sword_dieb6 = [ 34.000, sword_dieb7 ] {};
void() sword_dieb7 = [ 35.000, sword_dieb8 ] { sound(self,TRUE,"player/axhit2.wav",0.500,ATTN_NORM); };
void() sword_dieb8 = [ 36.000, sword_dieb9 ] {};
void() sword_dieb9 = [ 37.000, sword_dieb10 ] {};
void() sword_dieb10 = [ 38.000, sword_dieb11 ] { monster_death_postcheck(); };
void() sword_dieb11 = [ 39.000, sword_dieb11 ] { monster_deadbody_check(); };

// Run Refield run
void() swordredfield_run1 = [$run1, swordredfield_run2 ] {
   self.alpha = 0.4;
   self.effects = EF_DIMLIGHT;
   sword_eyecheck();
   ai_run (14);
};
void() swordredfield_run2 = [$run2, swordredfield_run3 ] { ai_run (14); sword_eyecheck(); };
void() swordredfield_run3 = [$run3, swordredfield_run4 ] { ai_run (14); sword_eyecheck(); };
void() swordredfield_run4 = [$run4, swordredfield_run5 ] { ai_run (14); sword_eyecheck(); sword_sound(); };
void() swordredfield_run5 = [$run5, swordredfield_run6 ] { ai_run (14); sword_eyecheck(); };
void() swordredfield_run6 = [$run6, swordredfield_run7 ] { ai_run (14); sword_eyecheck(); };
void() swordredfield_run7 = [$run7, swordredfield_run8 ] { ai_run (14); sword_eyecheck(); };
void() swordredfield_run8 = [$run8, swordredfield_run1 ] { ai_run (14); sword_eyecheck(); };

// Refield attack
void() swordredfield_atk1 = [$atk1, sword_atk2 ] {
   sound(self,FALSE,"knight/sword1.wav",TRUE,TRUE);
   ai_charge (14);
   sword_eyecheck();
};
void() swordredfield_atk2 = [$atk2, swordredfield_atk3 ] { ai_charge (14); sword_eyecheck(); };
void() swordredfield_atk3 = [$atk3, swordredfield_atk4 ] { ai_charge (14); sword_eyecheck(); };
void() swordredfield_atk4 = [$atk4, swordredfield_atk5 ] { ai_charge (14); sword_eyecheck(); };
void() swordredfield_atk5 = [$atk5, swordredfield_atk6 ] { ai_melee(); sword_eyecheck(); };
void() swordredfield_atk6 = [$atk6, swordredfield_atk7 ] { ai_melee(); sword_eyecheck(); };
void() swordredfield_atk7 = [$atk7, swordredfield_atk8 ] { ai_melee(); sword_eyecheck(); };
void() swordredfield_atk8 = [$atk8, swordredfield_atk9 ] { ai_charge (14); sword_eyecheck(); };
void() swordredfield_atk9 = [$atk9, swordredfield_atk10 ] { ai_charge (14); sword_eyecheck(); };
void() swordredfield_atk10 = [$atk10, swordredfield_run1 ] { ai_charge (14); sword_eyecheck(); };

// Refield die, the sword, not him/her ;)
void() swordredfield_die1 = [$death1, swordredfield_die2 ] { sword_eyecheck(); };
void() swordredfield_die2 = [$death2, swordredfield_die3 ] { sword_eyecheck(); };
void() swordredfield_die3 = [$death3, swordredfield_die4 ] { sword_eyecheck(); 
self.solid = SOLID_NOT; monster_check_gib(); };
void() swordredfield_die4 = [$death4, swordredfield_die5 ] { sword_eyecheck(); };
void() swordredfield_die5 = [$death5, swordredfield_die6 ] { sword_eyecheck(); };
void() swordredfield_die6 = [$death6, swordredfield_die7 ] { sword_eyecheck(); };
void() swordredfield_die7 = [$death7, swordredfield_die8 ] { SUB_FinishAttachment(); SUB_RemoveAttachment(); 
sound(self,TRUE,"player/axhit2.wav",0.500,ATTN_NORM); };
void() swordredfield_die8 = [$death8, swordredfield_die9 ] { self.alpha = 1; };
void() swordredfield_die9 = [$death9, swordredfield_die10 ] { monster_death_postcheck(); };
void() swordredfield_die10 = [$death10, swordredfield_die10 ] { monster_deadbody_check(); };

// Refield dieb
void() swordredfield_dieb1 = [$deathb1, swordredfield_dieb2 ] { sword_eyecheck(); };
void() swordredfield_dieb2 = [$deathb2, swordredfield_dieb3 ] { sword_eyecheck(); };
void() swordredfield_dieb3 = [$deathb3, swordredfield_dieb4 ] { sword_eyecheck(); self.solid = SOLID_NOT; monster_check_gib(); };
void() swordredfield_dieb4 = [$deathb4, swordredfield_dieb5 ] { sword_eyecheck(); };
void() swordredfield_dieb5 = [$deathb5, swordredfield_dieb6 ] { sword_eyecheck(); };
void() swordredfield_dieb6 = [$deathb6, swordredfield_dieb7 ] { sword_eyecheck(); };
void() swordredfield_dieb7 = [$deathb7, swordredfield_dieb8 ] { SUB_FinishAttachment(); SUB_RemoveAttachment(); 
sound(self,TRUE,"player/axhit2.wav",0.500,ATTN_NORM); };
void() swordredfield_dieb8 = [$deathb8, swordredfield_dieb9 ] {};
void() swordredfield_dieb9 = [$deathb9, swordredfield_dieb10 ] { self.alpha = 1; };
void() swordredfield_dieb10 = [$deathb10, swordredfield_dieb11 ] { monster_death_postcheck(); };
void() swordredfield_dieb11 = [$deathb11, swordredfield_dieb11 ] { monster_deadbody_check(); };

// Refield lean
void() sword_lean1 = [$lean1, sword_lean1 ] { ai_stand(); };

// Refield idle float bobbing
void() sword_idle1 = [$idle1, sword_idle2 ] { ai_stand(); };
void() sword_idle2 = [$idle2, sword_idle3 ] { ai_stand(); };
void() sword_idle3 = [$idle3, sword_idle4 ] { ai_stand(); };
void() sword_idle4 = [$idle4, sword_idle5 ] { ai_stand(); };
void() sword_idle5 = [$idle5, sword_idle6 ] { ai_stand(); };
void() sword_idle6 = [$idle6, sword_idle7 ] { ai_stand(); };
void() sword_idle7 = [$idle7, sword_idle8 ] { ai_stand(); };
void() sword_idle8 = [$idle8, sword_idle9 ] { ai_stand(); };
void() sword_idle9 = [$idle9, sword_idle10 ] { ai_stand(); };
void() sword_idle10 = [$idle10, sword_idle1 ] { ai_stand(); };

// Refield walk
void() sword_walk1 = [$idle1, sword_walk2 ] { ai_walk(6); };
void() sword_walk2 = [$idle2, sword_walk3 ] { ai_walk(6); };
void() sword_walk3 = [$idle3, sword_walk4 ] { ai_walk(6); };
void() sword_walk4 = [$idle4, sword_walk5 ] { ai_walk(6); };
void() sword_walk5 = [$idle5, sword_walk6 ] { ai_walk(6); };
void() sword_walk6 = [$idle6, sword_walk7 ] { ai_walk(6); };
void() sword_walk7 = [$idle7, sword_walk8 ] { ai_walk(6); };
void() sword_walk8 = [$idle8, sword_walk9 ] { ai_walk(6); };
void() sword_walk9 = [$idle9, sword_walk10 ] { ai_walk(6); };
void() sword_walk10 = [$idle10, sword_walk1 ] { ai_walk(6); };

void() sword_idlechoose = {
	if (self.spawnflags & MON_SWORD_LEAN) {
		sword_lean1();
	} else {
		sword_idle1();
	}
};

void() sword_die = {
   monster_death_precheck();
   if (self.attachment) self.attachment.movetype = MOVETYPE_NOCLIP;
	if ( (random () < 0.500) ) {
		if (self.spawnflags & INVIS_SWORD_REDFIELD) swordredfield_die1();
		else sword_die1();
	} else {
		if (self.spawnflags & INVIS_SWORD_REDFIELD) swordredfield_dieb1();
		else sword_dieb1();
	}
};

void() sword_pause = {
	if (self.spawnflags & INVIS_SWORD_REDFIELD) {
		self.th_run = swordredfield_run1;
		self.think = swordredfield_run1;
	} else {
		self.th_run = sword_run1;
		self.think = sword_run1;
	}
	self.nextthink = (time + self.delay);
	self.delay = FALSE;
};

void(entity inflictor,entity attacker, float damage) sword_pain = {
	if (self.spawnflags & INVIS_SWORD_REDFIELD) {
		self.th_run = swordredfield_run1;
		self.think = swordredfield_run1;
	} else {
		self.th_run = sword_run1;
		self.think = sword_run1;
	}
	self.nextthink = (time + 0.100);
	self.delay = FALSE;
	self.th_pain = SUB_Null_pain;
};

void() monster_sword_precache = {
	precache_model ("progs/rogue/mon_sword.mdl");
	precache_model ("progs/redfield/mon_sword.mdl");
	precache_model (MODEL_SWORDEYES);
	precache_sound("knight/sword1.wav");
	precache_sound("knight/ksight.wav");
	precache_sound("player/axhit2.wav");
	precache_sound("redfield/sword/die.wav");
};

void() monster_sword = {
	if (monster_checkrandomizer() == TRUE) return; // Check for any random monster setups
	if (monster_checkspawn() == TRUE) return; // Check all spawn exceptions (monsters.qc)

	self.sight_sound = "knight/ksight.wav";
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_NONE;
	if (self.bboxtype < 1) self.bboxtype = BBOX_TALL;
	if (self.health < 1) self.health = 150;
	self.gibhealth = MON_NEVERGIB;
	self.gibbed = FALSE;
	self.steptype = FS_FLYING;
	self.bleedcolour = self.bloodtype = MON_BCOLOR_WHITE;
	if (self.delay <= 0) self.delay = 0.1;
	Resist_ChangeType(self,-1); // Always reset Ammo Resistance to be consistent
	self.classtype = CT_MONINVISSWORD;
	self.classgroup = CG_DKNIGHT;
	self.classmove = MON_MOVEWALK;
	self.th_run = sword_pause;
	self.th_die = sword_die;
	self.th_pain = sword_pain;
	if (self.spawnflags & INVIS_SWORD_REDFIELD) {
		self.mdl = "progs/redfield/mon_sword.mdl";
		self.spawnflags = self.spawnflags | MON_SPAWN_NOSIGHT;
		self.th_stand = sword_idlechoose;
		self.th_walk = sword_walk1;
		self.th_melee = swordredfield_atk1;

	} else {
		self.mdl = "progs/rogue/mon_sword.mdl";
		self.hittype = HIT_METAL;
		self.th_stand = sword_stand1;
		self.th_walk = sword_stand1;
		self.th_melee = sword_atk1;
	}

	self.classmove = MON_MOVEWALK;
	if (self.deathstring == "")  self.deathstring = " was slit open by a Phantom Swordsman\n";
	monster_start();
};
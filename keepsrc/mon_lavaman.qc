void(float AttackNumber) lavaman_missile;

void() lavaman_rise1 = [ 0.000, lavaman_rise2 ] { sound(self,CHAN_WEAPON,"boss1/out1.wav",TRUE,ATTN_NORM); };
void() lavaman_rise2 = [ 1.000, lavaman_rise3 ] { sound(self,CHAN_VOICE,"boss1/sight1.wav",TRUE,ATTN_NORM); };
void() lavaman_rise3 = [ 2.000, lavaman_rise4 ] {};
void() lavaman_rise4 = [ 3.000, lavaman_rise5 ] {};
void() lavaman_rise5 = [ 4.000, lavaman_rise6 ] {};
void() lavaman_rise6 = [ 5.000, lavaman_rise7 ] {};
void() lavaman_rise7 = [ 6.000, lavaman_rise8 ] {};
void() lavaman_rise8 = [ 7.000, lavaman_rise9 ] {};
void() lavaman_rise9 = [ 8.000, lavaman_rise10 ] {};
void() lavaman_rise10 = [ 9.000, lavaman_rise11 ] {};
void() lavaman_rise11 = [ 10.000, lavaman_rise12 ] {};
void() lavaman_rise12 = [ 11.000, lavaman_rise13 ] {};
void() lavaman_rise13 = [ 12.000, lavaman_rise14 ] {};
void() lavaman_rise14 = [ 13.000, lavaman_rise15 ] {};
void() lavaman_rise15 = [ 14.000, lavaman_rise16 ] {};
void() lavaman_rise16 = [ 15.000, lavaman_rise17 ] {};
void() lavaman_rise17 = [ 16.000, lavaman_fire1 ] {};

void() lavaman_fire1;

void() lavaman_idle1 = [ 17.000, lavaman_idle2 ] {
   if ( (random () < 0.200) )
      sound(self,CHAN_VOICE,"boss1/sight1.wav",TRUE,ATTN_NORM);
};

void() lavaman_idle2 = [ 18.000, lavaman_idle3 ] { ai_stand(); };
void() lavaman_idle3 = [ 19.000, lavaman_idle4 ] { ai_stand(); };
void() lavaman_idle4 = [ 20.000, lavaman_idle5 ] { ai_stand(); };
void() lavaman_idle5 = [ 21.000, lavaman_idle6 ] { ai_stand(); };
void() lavaman_idle6 = [ 20.000, lavaman_idle7 ] { ai_stand(); };
void() lavaman_idle7 = [ 19.000, lavaman_idle8 ] { ai_stand(); };
void() lavaman_idle8 = [ 18.000, lavaman_idle9 ] { ai_stand(); };
void() lavaman_idle9 = [ 17.000, lavaman_idle1 ] { ai_stand(); };

void() lavaman_walk1 = [ 17.000, lavaman_walk2 ] { ai_walk(FL_SWIM); };
void() lavaman_walk2 = [ 18.000, lavaman_walk3 ] { ai_walk(FL_SWIM); };
void() lavaman_walk3 = [ 19.000, lavaman_walk4 ] { ai_walk(FL_SWIM); };
void() lavaman_walk4 = [ 20.000, lavaman_walk5 ] { ai_walk(FL_SWIM); };
void() lavaman_walk5 = [ 21.000, lavaman_walk6 ] { ai_walk(FL_SWIM); };
void() lavaman_walk6 = [ 22.000, lavaman_walk7 ] { ai_walk(FL_SWIM); };
void() lavaman_walk7 = [ 23.000, lavaman_walk8 ] { ai_walk(FL_SWIM); };
void() lavaman_walk8 = [ 24.000, lavaman_walk9 ] { ai_walk(FL_SWIM); };
void() lavaman_walk9 = [ 25.000, lavaman_walk10 ] { ai_walk(FL_SWIM); };
void() lavaman_walk10 = [ 26.000, lavaman_walk11 ] { ai_walk(FL_SWIM); };
void() lavaman_walk11 = [ 27.000, lavaman_walk12 ] { ai_walk(FL_SWIM); };
void() lavaman_walk12 = [ 28.000, lavaman_walk13 ] { ai_walk(FL_SWIM); };
void() lavaman_walk13 = [ 29.000, lavaman_walk14 ] { ai_walk(FL_SWIM); };
void() lavaman_walk14 = [ 30.000, lavaman_walk15 ] { ai_walk(FL_SWIM); };
void() lavaman_walk15 = [ 31.000, lavaman_walk16 ] { ai_walk(FL_SWIM); };
void() lavaman_walk16 = [ 32.000, lavaman_walk17 ] { ai_walk(FL_SWIM); };
void() lavaman_walk17 = [ 33.000, lavaman_walk18 ] { ai_walk(FL_SWIM); };
void() lavaman_walk18 = [ 34.000, lavaman_walk19 ] { ai_walk(FL_SWIM); };
void() lavaman_walk19 = [ 35.000, lavaman_walk20 ] { ai_walk(FL_SWIM); };
void() lavaman_walk20 = [ 36.000, lavaman_walk21 ] { ai_walk(FL_SWIM); };
void() lavaman_walk21 = [ 37.000, lavaman_walk22 ] { ai_walk(FL_SWIM); };
void() lavaman_walk22 = [ 38.000, lavaman_walk23 ] { ai_walk(FL_SWIM); };
void() lavaman_walk23 = [ 39.000, lavaman_walk24 ] { ai_walk(FL_SWIM); };
void() lavaman_walk24 = [ 40.000, lavaman_walk25 ] { ai_walk(FL_SWIM); };
void() lavaman_walk25 = [ 41.000, lavaman_walk26 ] { ai_walk(FL_SWIM); };
void() lavaman_walk26 = [ 42.000, lavaman_walk27 ] { ai_walk(FL_SWIM); };
void() lavaman_walk27 = [ 43.000, lavaman_walk28 ] { ai_walk(FL_SWIM); };
void() lavaman_walk28 = [ 44.000, lavaman_walk29 ] { ai_walk(FL_SWIM); };
void() lavaman_walk29 = [ 45.000, lavaman_walk30 ] { ai_walk(FL_SWIM); };
void() lavaman_walk30 = [ 46.000, lavaman_walk31 ] { ai_walk(FL_SWIM); };
void() lavaman_walk31 = [ 47.000, lavaman_walk1 ] {};

void() lavaman_run1 = [ 17.000, lavaman_run2 ] { ai_run(FL_SWIM); };
void() lavaman_run2 = [ 18.000, lavaman_run3 ] { ai_run(FL_SWIM); };
void() lavaman_run3 = [ 19.000, lavaman_run4 ] { ai_run(FL_SWIM); };
void() lavaman_run4 = [ 20.000, lavaman_run5 ] { ai_run(FL_SWIM); };
void() lavaman_run5 = [ 21.000, lavaman_run6 ] { ai_run(FL_SWIM); };
void() lavaman_run6 = [ 22.000, lavaman_run7 ] { ai_run(FL_SWIM); };
void() lavaman_run7 = [ 23.000, lavaman_run8 ] { ai_run(FL_SWIM); };
void() lavaman_run8 = [ 24.000, lavaman_run9 ] { ai_run(FL_SWIM); };
void() lavaman_run9 = [ 25.000, lavaman_run10 ] { ai_run(FL_SWIM); };
void() lavaman_run10 = [ 26.000, lavaman_run11 ] { ai_run(FL_SWIM); };
void() lavaman_run11 = [ 27.000, lavaman_run12 ] { ai_run(FL_SWIM); };
void() lavaman_run12 = [ 28.000, lavaman_run13 ] { ai_run(FL_SWIM); };
void() lavaman_run13 = [ 29.000, lavaman_run14 ] { ai_run(FL_SWIM); };
void() lavaman_run14 = [ 30.000, lavaman_run15 ] { ai_run(FL_SWIM); };
void() lavaman_run15 = [ 31.000, lavaman_run16 ] { ai_run(FL_SWIM); };
void() lavaman_run16 = [ 32.000, lavaman_run17 ] { ai_run(FL_SWIM); };
void() lavaman_run17 = [ 33.000, lavaman_run18 ] { ai_run(FL_SWIM); };
void() lavaman_run18 = [ 34.000, lavaman_run19 ] { ai_run(FL_SWIM); };
void() lavaman_run19 = [ 35.000, lavaman_run20 ] { ai_run(FL_SWIM); };
void() lavaman_run20 = [ 36.000, lavaman_run21 ] { ai_run(FL_SWIM); };
void() lavaman_run21 = [ 37.000, lavaman_run22 ] { ai_run(FL_SWIM); };
void() lavaman_run22 = [ 38.000, lavaman_run23 ] { ai_run(FL_SWIM); };
void() lavaman_run23 = [ 39.000, lavaman_run24 ] { ai_run(FL_SWIM); };
void() lavaman_run24 = [ 40.000, lavaman_run25 ] { ai_run(FL_SWIM); };
void() lavaman_run25 = [ 41.000, lavaman_run26 ] { ai_run(FL_SWIM); };
void() lavaman_run26 = [ 42.000, lavaman_run27 ] { ai_run(FL_SWIM); };
void() lavaman_run27 = [ 43.000, lavaman_run28 ] { ai_run(FL_SWIM); };
void() lavaman_run28 = [ 44.000, lavaman_run29 ] { ai_run(FL_SWIM); };
void() lavaman_run29 = [ 45.000, lavaman_run30 ] { ai_run(FL_SWIM); };
void() lavaman_run30 = [ 46.000, lavaman_run31 ] { ai_run(FL_SWIM); };
void() lavaman_run31 = [ 47.000, lavaman_run1 ] {};

void() lavaman_fire1 = [ 57.000, lavaman_fire2 ] { ai_face(); };
void() lavaman_fire2 = [ 58.000, lavaman_fire3 ] { ai_charge(TRUE); };
void() lavaman_fire3 = [ 59.000, lavaman_fire4 ] { ai_face(); };
void() lavaman_fire4 = [ 60.000, lavaman_fire5 ] { ai_face(); };
void() lavaman_fire5 = [ 61.000, lavaman_fire6 ] { ai_charge(TRUE); };
void() lavaman_fire6 = [ 62.000, lavaman_fire7 ] { ai_face(); };
void() lavaman_fire7 = [ 63.000, lavaman_fire8 ] { lavaman_missile (TRUE); };
void() lavaman_fire8 = [ 64.000, lavaman_fire9 ] { ai_face(); };
void() lavaman_fire9 = [ 65.000, lavaman_fire10 ] { ai_face(); };
void() lavaman_fire10 = [ 66.000, lavaman_fire11 ] { ai_charge(TRUE); };
void() lavaman_fire11 = [ 67.000, lavaman_fire12 ] { ai_face(); };
void() lavaman_fire12 = [ 68.000, lavaman_fire13 ] { ai_charge(TRUE); };
void() lavaman_fire13 = [ 69.000, lavaman_fire14 ] { ai_face(); };
void() lavaman_fire14 = [ 70.000, lavaman_fire15 ] { ai_face(); };
void() lavaman_fire15 = [ 71.000, lavaman_fire16 ] { ai_charge(TRUE); };
void() lavaman_fire16 = [ 72.000, lavaman_fire17 ] { ai_charge(TRUE); };
void() lavaman_fire17 = [ 73.000, lavaman_fire18 ] { ai_face(); };
void() lavaman_fire18 = [ 74.000, lavaman_fire19 ] { lavaman_missile (FL_SWIM); };
void() lavaman_fire19 = [ 75.000, lavaman_fire20 ] { ai_face(); };
void() lavaman_fire20 = [ 76.000, lavaman_fire21 ] { ai_face(); };
void() lavaman_fire21 = [ 77.000, lavaman_fire22 ] { ai_face(); };
void() lavaman_fire22 = [ 78.000, lavaman_fire23 ] { ai_charge(TRUE); };
void() lavaman_fire23 = [ 79.000, lavaman_run1 ] {};

void() lavaman_shocka1 = [ 80.000, lavaman_shocka2 ] {};
void() lavaman_shocka2 = [ 81.000, lavaman_shocka3 ] {};
void() lavaman_shocka3 = [ 82.000, lavaman_shocka4 ] {};
void() lavaman_shocka4 = [ 83.000, lavaman_shocka5 ] {};
void() lavaman_shocka5 = [ 84.000, lavaman_shocka6 ] {};
void() lavaman_shocka6 = [ 85.000, lavaman_shocka7 ] {};
void() lavaman_shocka7 = [ 86.000, lavaman_shocka8 ] {};
void() lavaman_shocka8 = [ 87.000, lavaman_shocka9 ] {};
void() lavaman_shocka9 = [ 88.000, lavaman_shocka10 ] {};
void() lavaman_shocka10 = [ 89.000, lavaman_run1 ] {};

void(entity inflictor, entity attacker, float damage) lavaman_pain = {
   if ( (self.pain_finished > time) )
      return ;

   if ( (random () < 0.050) ) {
      self.pain_finished = (time + FL_SWIM);
      lavaman_shocka1();
   }
};

void() lavaman_death1 = [ 48.000, lavaman_death2 ] {};
void() lavaman_death2 = [ 49.000, lavaman_death3 ] {};
void() lavaman_death3 = [ 50.000, lavaman_death4 ] {};
void() lavaman_death4 = [ 51.000, lavaman_death5 ] {};
void() lavaman_death5 = [ 52.000, lavaman_death6 ] {};
void() lavaman_death6 = [ 53.000, lavaman_death7 ] { self.solid = SOLID_NOT; };
void() lavaman_death7 = [ 54.000, lavaman_death8 ] {};
void() lavaman_death8 = [ 55.000, lavaman_death9 ] {};
void() lavaman_death9 = [ 56.000, lavaman_death10 ] {
   monster_death_postcheck();
   sound(self,CHAN_BODY,"boss1/out1.wav",TRUE,ATTN_NORM);
   WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
   WriteByte (MSG_BROADCAST,TE_LAVASPLASH);
   WriteCoord (MSG_BROADCAST,self.origin_x);
   WriteCoord (MSG_BROADCAST,self.origin_y);
   WriteCoord (MSG_BROADCAST,self.origin_z);
};
void() lavaman_death10 = [ 56.000, lavaman_death10 ] { entity_remove(self,0.1); };

void() lavaman_die = {
   monster_death_precheck(); // Pre-check routine to tidy up extra entities
   sound(self,CHAN_VOICE,"boss1/death.wav",TRUE,ATTN_NORM);
   lavaman_death1();
};

void() lavaman_awake = {
   self.takedamage = DAMAGE_AIM;
   self.solid = SOLID_SLIDEBOX;
   self.movetype = MOVETYPE_STEP;
   self.ideal_yaw = (self.angles * '0.000 1.000 0.000');
   //setsize (self,'-24 -24 -24','24 24 64');
   self.view_ofs = '0.000 0.000 48.000';
   self.th_stand = lavaman_idle1;
   self.th_walk = lavaman_walk1;
   self.th_run = lavaman_run1;
   self.th_missile = lavaman_fire1;
   self.th_pain = lavaman_pain;
   self.th_die = lavaman_death1;
   self.th_melee = lavaman_fire1;
   self.attack_offset = (self.origin + '0.000 0.000 96.000');
   self.th_checkattack = LavaManCheckAttack;
   WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
   WriteByte (MSG_BROADCAST,TE_LAVASPLASH);
   WriteCoord (MSG_BROADCAST,self.origin_x);
   WriteCoord (MSG_BROADCAST,self.origin_y);
   WriteCoord (MSG_BROADCAST,self.origin_z);
   lavaman_rise1();
};

void() monster_lava_man_precache = {
	precache_model ("progs/rogue/mon_lavaman.mdl");
	precache_model (MODEL_PROJ_LAVA);
	precache_sound("boss1/out1.wav");
	precache_sound("boss1/sight1.wav");
	precache_sound("boss1/throw.wav");
	precache_sound("boss1/pain.wav");
	precache_sound("boss1/death.wav");
};

void() monster_lava_man = {
	if (monster_checkrandomizer() == TRUE) return; // Check for any random monster setups

	self.mdl = "progs/rogue/mon_lavaman.mdl";
	self.sight_sound = "boss1/sight1.wav";
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_NONE;
	if (self.bboxtype < 1) self.bboxtype = BBOX_GIANT;
	if (self.health < 1) self.health = 1500;
	if (self.yaw_speed < 1) self.yaw_speed = 20.000;  // Lumbering turn
	self.gibhealth = MON_NEVERGIB;
	self.gibbed = FALSE;
	self.pain_flinch = 80;
	self.blockudeath = TRUE;
	Resist_ChangeType(self,-1); // Always reset Ammo Resistance to 0 to be consistent.
	self.resist_fire = self.resist_lava_nails = 1;
	if (self.targetname != "") {
		self.th_stand = lavaman_awake;
		self.th_walk = lavaman_awake;
		self.th_run = lavaman_awake;
	} else {
		self.th_stand = lavaman_idle1;
		self.th_walk = lavaman_walk1;
		self.th_run = lavaman_run1;
	}
	self.ideal_yaw = (self.angles * '0.000 1.000 0.000');
	self.view_ofs = '0.000 0.000 48.000';
	self.th_missile = lavaman_fire1;
	self.th_pain = lavaman_pain;
	self.th_die = lavaman_die;
	self.th_melee = lavaman_fire1;
	self.attack_offset = (self.origin + '0.000 0.000 96.000');
	self.th_checkattack = LavaManCheckAttack;
	self.classtype = CT_MONLAVAMAN;
	self.classgroup = CG_BOSS;
	self.classmove = MON_MOVEWALK;
	if (self.deathstring == "") self.deathstring = " fries in Hephaestus' fury\n";
	monster_start();
};
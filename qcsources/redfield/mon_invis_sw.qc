/*==============================================================================
Invisible Sword	(New animations, attachment, and skin by Redfield)	
==============================================================================*/

$frame stand1

$frame run1 run2 run3 run4 run5 run6 run7 run8 

$frame atk1 atk2 atk3 atk4 atk5 atk6 atk7 atk8 atk9 atk10

$frame death1 death2 death3 death4 death5 death6 death7 death8 death9 death10

$frame deathb1 deathb2 deathb3 deathb4 deathb5 deathb6 deathb7 deathb8 deathb9
$frame deathb10 deathb11 

$frame lean1

$frame idle1 idle2 idle3 idle4 idle5 idle6 idle7 idle8 idle9 idle10

//============================================================================
// Attachment management (create, finish and delete)
//==============================================================================
//----------------------------------------------------------------------
void() sword_create_attachment =
{
	// Are the attachments setup yet?
		self.attachment = spawn();
		//self.attachment.owner = self;
		self.attachment.classtype = CT_ATTACHMENT;
		self.attachment.state = FALSE;
};

//----------------------------------------------------------------------
void() sword_finish_attachment =
{
	if (self.attachment) setmodel(self.attachment, "");
};

//----------------------------------------------------------------------
void() sword_setup_attachment =
{
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

//----------------------------------------------------------------------
void() sword_remove_attachment =
{
	if (self.attachment) {
		self.attachment.state = FALSE;
		self.attachment.think = SUB_Remove;
		self.attachment.nextthink = time + 0.1;
	}
};

void () sword_eyecheck =
{
	if (self.spawnflags & MON_SWORD_EYES) {
		if (!self.attachment) { 
			sword_create_attachment ();
			sword_setup_attachment (); 
	}
	self.attachment.frame = self.frame;
	self.attachment.origin = self.origin;
	self.attachment.angles = self.angles;
   } 
};

//----------------------------------------------------------------------
void () sword_stand1 = [ $stand1, sword_stand1 ] { ai_stand (); };

float sound_count;

//----------------------------------------------------------------------
void () sword_sound =
{
	sound_count = sound_count + 1;
	if (sound_count > 3) {
		if (random() < 0.3) {
			sound (self, CHAN_VOICE, "sword/die.wav", 1, ATTN_NORM);
			sound_count = 0;
		}
	}
	else return;
};

//----------------------------------------------------------------------
void () sword_run1 = [ $run1, sword_run2 ] {
   self.alpha = 0.4;
   self.effects = EF_DIMLIGHT;
   sword_eyecheck ();
   ai_run (14);
};
void () sword_run2 = [ $run2, sword_run3 ] { ai_run (14); sword_eyecheck ();};
void () sword_run3 = [ $run3, sword_run4 ] { ai_run (14); sword_eyecheck ();};
void () sword_run4 = [ $run4, sword_run5 ] { ai_run (14); sword_eyecheck ();
sword_sound (); };
void () sword_run5 = [ $run5, sword_run6 ] { ai_run (14); sword_eyecheck ();};
void () sword_run6 = [ $run6, sword_run7 ] { ai_run (14); sword_eyecheck ();};
void () sword_run7 = [ $run7, sword_run8 ] { ai_run (14); sword_eyecheck ();};
void () sword_run8 = [ $run8, sword_run1 ] { ai_run (14); sword_eyecheck ();};

//----------------------------------------------------------------------
void () sword_atk1 = [ $atk1, sword_atk2 ] {
   sound (self,FALSE,"knight/sword1.wav",TRUE,TRUE);
   ai_charge (14);
   sword_eyecheck ();
};
void () sword_atk2 = [ $atk2, sword_atk3 ] { ai_charge (14); sword_eyecheck ();};
void () sword_atk3 = [ $atk3, sword_atk4 ] { ai_charge (14); sword_eyecheck ();};
void () sword_atk4 = [ $atk4, sword_atk5 ] { ai_charge (14); sword_eyecheck ();};
void () sword_atk5 = [ $atk5, sword_atk6 ] { ai_melee (); sword_eyecheck ();};
void () sword_atk6 = [ $atk6, sword_atk7 ] { ai_melee (); sword_eyecheck ();};
void () sword_atk7 = [ $atk7, sword_atk8 ] { ai_melee (); sword_eyecheck ();};
void () sword_atk8 = [ $atk8, sword_atk9 ] { ai_charge (14); sword_eyecheck ();};
void () sword_atk9 = [ $atk9, sword_atk10 ] { ai_charge (14); sword_eyecheck ();};
void () sword_atk10 = [ $atk10, sword_run1 ] { ai_charge (14); sword_eyecheck ();};

//----------------------------------------------------------------------
void () sword_die1 = [ $death1, sword_die2 ] { sword_eyecheck (); };
void () sword_die2 = [ $death2, sword_die3 ] { sword_eyecheck (); };
void () sword_die3 = [ $death3, sword_die4 ] { sword_eyecheck (); 
self.solid = SOLID_NOT; monster_check_gib(); };
void () sword_die4 = [ $death4, sword_die5 ] { sword_eyecheck (); };
void () sword_die5 = [ $death5, sword_die6 ] { sword_eyecheck (); };
void () sword_die6 = [ $death6, sword_die7 ] { sword_eyecheck (); };
void () sword_die7 = [ $death7, sword_die8 ] {sword_finish_attachment(); sword_remove_attachment(); 
sound (self,TRUE,"player/axhit2.wav",0.500,ATTN_NORM); };
void () sword_die8 = [ $death8, sword_die9 ] { self.alpha = 1; };
void () sword_die9 = [ $death9, sword_die10 ] { monster_death_postcheck(); };
void () sword_die10 = [ $death10, sword_die10 ] { monster_deadbody_check(); };

//----------------------------------------------------------------------
void () sword_dieb1 = [ $deathb1, sword_dieb2 ] { sword_eyecheck (); };
void () sword_dieb2 = [ $deathb2, sword_dieb3 ] { sword_eyecheck (); };
void () sword_dieb3 = [ $deathb3, sword_dieb4 ] { sword_eyecheck ();
self.solid = SOLID_NOT; monster_check_gib(); };
void () sword_dieb4 = [ $deathb4, sword_dieb5 ] { sword_eyecheck (); };
void () sword_dieb5 = [ $deathb5, sword_dieb6 ] { sword_eyecheck (); };
void () sword_dieb6 = [ $deathb6, sword_dieb7 ] { sword_eyecheck (); };
void () sword_dieb7 = [ $deathb7, sword_dieb8 ] { sword_finish_attachment(); sword_remove_attachment(); 
sound (self,TRUE,"player/axhit2.wav",0.500,ATTN_NORM); };
void () sword_dieb8 = [ $deathb8, sword_dieb9 ] {};
void () sword_dieb9 = [ $deathb9, sword_dieb10 ] { self.alpha = 1; };
void () sword_dieb10 = [ $deathb10, sword_dieb11 ] { monster_death_postcheck(); };
void () sword_dieb11 = [ $deathb11, sword_dieb11 ] { monster_deadbody_check(); };

//----------------------------------------------------------------------
void () sword_lean1 = [ $lean1, sword_lean1 ] { ai_stand(); };

//----------------------------------------------------------------------
void () sword_idle1 = [ $idle1, sword_idle2 ] { ai_stand(); };
void () sword_idle2 = [ $idle2, sword_idle3 ] { ai_stand(); };
void () sword_idle3 = [ $idle3, sword_idle4 ] { ai_stand(); };
void () sword_idle4 = [ $idle4, sword_idle5 ] { ai_stand(); };
void () sword_idle5 = [ $idle5, sword_idle6 ] { ai_stand(); };
void () sword_idle6 = [ $idle6, sword_idle7 ] { ai_stand(); };
void () sword_idle7 = [ $idle7, sword_idle8 ] { ai_stand(); };
void () sword_idle8 = [ $idle8, sword_idle9 ] { ai_stand(); };
void () sword_idle9 = [ $idle9, sword_idle10 ] { ai_stand(); };
void () sword_idle10 = [ $idle10, sword_idle1 ] { ai_stand(); };

//----------------------------------------------------------------------
void () sword_walk1 = [ $idle1, sword_walk2 ] { ai_walk(6); };
void () sword_walk2 = [ $idle2, sword_walk3 ] { ai_walk(6); };
void () sword_walk3 = [ $idle3, sword_walk4 ] { ai_walk(6); };
void () sword_walk4 = [ $idle4, sword_walk5 ] { ai_walk(6); };
void () sword_walk5 = [ $idle5, sword_walk6 ] { ai_walk(6); };
void () sword_walk6 = [ $idle6, sword_walk7 ] { ai_walk(6); };
void () sword_walk7 = [ $idle7, sword_walk8 ] { ai_walk(6); };
void () sword_walk8 = [ $idle8, sword_walk9 ] { ai_walk(6); };
void () sword_walk9 = [ $idle9, sword_walk10 ] { ai_walk(6); };
void () sword_walk10 = [ $idle10, sword_walk1 ] { ai_walk(6); };

//----------------------------------------------------------------------
void () sword_idlechoose = {
	if (self.spawnflags & MON_SWORD_LEAN) {
		sword_lean1 ();
	}
	else {
		sword_idle1 ();
	}
};

//----------------------------------------------------------------------
void () sword_die = {
   monster_death_precheck();

   if (self.attachment) self.attachment.movetype = MOVETYPE_NOCLIP;

   if (!self.gibbed) {
      if ( (random () < 0.500) ) {
         sword_die1 ();
      } else {
         sword_dieb1 ();
      }
   }
};

//----------------------------------------------------------------------
void () sword_pause = {
   self.th_run = sword_run1;
   self.think = sword_run1;
   self.nextthink = (time + self.delay);
   self.delay = FALSE;
};

//----------------------------------------------------------------------
void (entity inflictor,entity attacker, float damage) sword_pain = {
   self.th_run = sword_run1;
   self.think = sword_run1;
   self.nextthink = (time + 0.100);
   self.delay = FALSE;
   self.th_pain = SUB_Null_pain;
};

/*======================================================================
QUAKED monster_sword (1 0 0) (-16 -16 -24) (16 16 40) Ambush
======================================================================*/
void () monster_sword = {
   if (deathmatch) { remove (self); return; }

   self.mdl = "progs/mon_sword.mdl";
   
   precache_model (MODEL_SWORDEYES);
   precache_model (self.mdl);
	
   precache_sound ("knight/sword1.wav");
   precache_sound ("player/axhit2.wav");
   precache_sound ("sword/die.wav");

   self.sight_sound = "misc/null.wav";
   self.solid = SOLID_NOT;
   self.movetype = MOVETYPE_NONE;
   if (self.bboxtype < 1) self.bboxtype = BBOX_TALL;
   if (self.health < 1) self.health = 150;
   self.gibhealth = MON_NEVERGIB;	// Cannot be gibbed by weapons
   self.gibbed = FALSE;
   self.steptype = FS_FLYING;
   self.bleedcolour = MON_BCOLOR_WHITE;

   if ( !self.delay )
      self.delay = 0.1;

   // Always reset Ammo Resistance to be consistent
   self.resist_shells = self.resist_nails = 0;
   self.resist_rockets = self.resist_cells = 0;

   self.classtype = CT_MONINVISSWORD;
   self.classgroup = CG_DKNIGHT;
   self.classmove = MON_MOVEWALK;
   
   self.th_stand = sword_idlechoose;
   self.th_walk = sword_walk1;
   self.th_run = sword_pause;
   self.th_melee = sword_atk1;
   self.th_die = sword_die;
   self.th_pain = sword_pain;
   self.classmove = MON_MOVEWALK;
   
   if (self.deathstring == "")  self.deathstring = " was slit open by a Phantom Swordsman\n";
   
   monster_start ();
};

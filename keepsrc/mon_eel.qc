$frame eswim1 eswim2 eswim3 eswim4 eswim5 eswim6
$frame edeath1 edeath2 edeath3 edeath4 edeath5 edeath6 edeath7 edeath8
$frame edeath9 edeath10 edeath11 edeath12 edeath13 edeath14 edeath15

void(entity inflictor, entity attacker, float damage) eel_pain1;

void() eel_pitch_change = {
   if (!InLiquid(self.origin)) {
      droptofloor();
      T_Damage(self,world,world,MOVETYPE_TOSS,DAMARMOR);
      return;
   }
   if (time < self.delay) return;

   if (self.weapon > 10) self.weapon = -10.0;

   if (self.weapon < 0) {
      self.angles_x = (self.angles_x - 1.500);
   } else {
      if (self.weapon > 0) self.angles_x = (self.angles_x + 1.500);
   }
   self.weapon = (self.weapon + TRUE);
};

void() eel_stand1 = [ 0, eel_stand2 ] {
   ai_stand();
   eel_pitch_change();
};
void() eel_stand2 = [ 1, eel_stand3 ] {
   ai_stand();
   eel_pitch_change();
};
void() eel_stand3 = [ 2, eel_stand4 ] {
   ai_stand();
   eel_pitch_change();
};
void() eel_stand4 = [ 3, eel_stand5 ] {
   ai_stand();
   eel_pitch_change();
};
void() eel_stand5 = [ 4, eel_stand6 ] {
   ai_stand();
   eel_pitch_change();
};
void() eel_stand6 = [ 5, eel_stand1 ] {
   ai_stand();
   eel_pitch_change();
};

void() eel_walk1 = [ 0, eel_walk2 ] {
   if ( (random () < 0.200) ) sound(self,CHAN_VOICE,"ad171/eel/idle1.wav",TRUE,ATTN_IDLE);

   ai_fish_movement("ai_walk",6);
   eel_pitch_change();
};
void() eel_walk2 = [ 1, eel_walk3 ] {
   ai_fish_movement("ai_walk",6);
   eel_pitch_change();
};
void() eel_walk3 = [ 2, eel_walk4 ] {
   ai_fish_movement("ai_walk",6);
   eel_pitch_change();
};
void() eel_walk4 = [ 3, eel_walk5 ] {
   ai_fish_movement("ai_walk",6);
   eel_pitch_change();
};
void() eel_walk5 = [ 4, eel_walk6 ] {
   ai_fish_movement("ai_walk",6);
   eel_pitch_change();
};
void() eel_walk6 = [ 5, eel_walk1 ] {
   ai_fish_movement("ai_walk",6);
   eel_pitch_change();
};

void() eel_run1 = [ 0, eel_run2 ] {
   if ( (random () < 0.400) )
      sound(self,CHAN_VOICE,"ad171/eel/idle1.wav",TRUE,ATTN_IDLE);

   ai_fish_movement("ai_run",10);
   eel_pitch_change();
};
void() eel_run2 = [ 1, eel_run3 ] {
   ai_fish_movement("ai_run",10);
   eel_pitch_change();
};
void() eel_run3 = [ 2, eel_run4 ] {
   ai_fish_movement("ai_run",10);
   eel_pitch_change();
};
void() eel_run4 = [ 3, eel_run5 ] {
   ai_fish_movement("ai_run",10);
   eel_pitch_change();
};
void() eel_run5 = [ 4, eel_run6 ] {
   ai_fish_movement("ai_run",10);
   eel_pitch_change();
};
void() eel_run6 = [ 5, eel_run1 ] {
   ai_fish_movement("ai_run",10);
   eel_pitch_change();
};

// RANGE - Plasma from mouth
void() eel_plasma = {
	local vector org, dir;

	// Check if can fire bolt of plasma
	if (visblocked_wide(self.enemy, self.attack_offset, '0 0 0')) return;	
	
	self.effects = self.effects | EF_MUZZLEFLASH;
	self.attack_speed = SPEED_EELBOLT + (skill * SPEED_EELSKILL);
	makevectors(self.angles);
	org = self.origin + attack_vector(self.attack_offset);
	dir = normalize(self.enemy.origin - self.origin);
	launch_projectile(org,dir,NO_SPIN,CT_PROJ_PLASMA,self.attack_speed);
};

void() eel_melee = {
   local float attackOK;

   attackOK = TRUE;
   traceline (self.origin,self.enemy.origin,FALSE,self);
   if (trace_ent != self.enemy) attackOK = FALSE;
   if (trace_inopen && trace_inwater) attackOK = FALSE;
   if (attackOK) T_RadiusDamage(self,self,45, world, DAMAGEALL);
   self.skin = FALSE;
   self.effects = FALSE;
};

void() eel_attack1 = [ 0, eel_attack2 ] {
   ai_fish_movement("ai_charge",8);
   eel_pitch_change();
};
void() eel_attack2 = [ 1, eel_attack3 ] {
   ai_fish_movement("ai_charge",8);
   eel_pitch_change();
};
void() eel_attack3 = [ 2, eel_attack4 ] {
   ai_fish_movement("ai_charge",8);
   eel_pitch_change();
};
void() eel_attack4 = [ 3, eel_attack5 ] {
   ai_fish_movement("ai_charge",8);
   eel_pitch_change();
};
void() eel_attack5 = [ 4, eel_attack6 ] {
   ai_fish_movement("ai_charge",8);
   eel_pitch_change();
};
void() eel_attack6 = [ 5, eel_attack7 ] {
   ai_fish_movement("ai_charge",8);
   eel_pitch_change();
};
void() eel_attack7 = [ 0, eel_attack8 ] {
   ai_fish_movement("ai_charge",8);
   eel_pitch_change();
};
void() eel_attack8 = [ 1, eel_attack9 ] {
   self.effects = EF_DIMLIGHT;
   self.skin = 1;
   ai_fish_movement("ai_charge",8);
   eel_pitch_change();
   sound(self,CHAN_WEAPON,"rogue/eel/eatt1.wav",TRUE,ATTN_NORM);
};
void() eel_attack9 = [ 2, eel_attack10 ] {
   self.skin = FL_SWIM;
   ai_fish_movement("ai_charge",8);
   eel_pitch_change();
};
void() eel_attack10 = [ 3, eel_attack11 ] {
   self.skin = MOVETYPE_WALK;
   ai_fish_movement("ai_charge",8);
   eel_pitch_change();
};
void() eel_attack11 = [ 4, eel_attack12 ] {
   self.effects = EF_BRIGHTLIGHT;
   self.skin = MOVETYPE_STEP;
   ai_fish_movement("ai_charge",8);
   eel_pitch_change();
};
void() eel_attack12 = [ 5, eel_run1 ] {
   self.skin = MOVETYPE_FLY;
   eel_melee();
};

void() eel_attack2_1 = [$eswim1, eel_attack2_2 ] { self.skin = 1; ai_face();sound(self, CHAN_VOICE, "rogue/eel/eatt1.wav", 1, ATTN_NORM); };
void() eel_attack2_2 = [$eswim2, eel_attack2_3 ] { self.skin = 2; ai_face(); self.effects = self.effects | EF_MUZZLEFLASH;};
void() eel_attack2_3 = [$eswim3, eel_attack2_4 ] { self.skin = 3; ai_face(); };
void() eel_attack2_4 = [$eswim4, eel_attack2_5 ] { self.skin = 4; ai_face(); self.effects = self.effects | EF_MUZZLEFLASH;};
void() eel_attack2_5 = [$eswim5, eel_attack2_6 ] { self.skin = 5; ai_face(); };
void() eel_attack2_6 = [$eswim6, eel_attack2_7 ] { self.skin = 4; ai_face(); eel_plasma(); };
void() eel_attack2_7 = [$eswim1, eel_attack2_8 ] { self.skin = 5;};
void() eel_attack2_8 = [$eswim2, eel_attack2_9 ] { self.skin = 4;};
void() eel_attack2_9 = [$eswim3, eel_attack2_10 ] { self.skin = 3;};
void() eel_attack2_10 = [$eswim4, eel_attack2_11 ] { self.skin = 2;};
void() eel_attack2_11 = [$eswim5, eel_attack2_12 ] { self.skin = 1; ai_face(); };
void() eel_attack2_12 = [$eswim6, eel_run1 ] { self.skin = 0; ai_face(); };

void() eel_death1 = [ 6, eel_death2 ] {
	self.skin = FALSE;
	self.effects = FALSE;
	sound(self,CHAN_VOICE,"rogue/eel/edie3r.wav",TRUE,ATTN_NORM);
};

void() eel_death2 = [ 7, eel_death3 ] { monster_check_gib(); };
void() eel_death3 = [ 8, eel_death4 ] { monster_check_gib(); };
void() eel_death4 = [ 9, eel_death5 ] { self.solid = SOLID_NOT; };
void() eel_death5 = [ 8, eel_death6 ] {};
void() eel_death6 = [ 7, eel_death7 ] {};
void() eel_death7 = [ 6, eel_death8 ] {};
void() eel_death8 = [ 7, eel_death9 ] {};
void() eel_death9 = [ 8, eel_death10 ] {};
void() eel_death10 = [ 9, eel_death11 ] {};
void() eel_death11 = [ 10, eel_death12 ] {};
void() eel_death12 = [ 11, eel_death13 ] {};
void() eel_death13 = [ 12, eel_death14 ] {};
void() eel_death14 = [ 13, eel_death15 ] {};
void() eel_death15 = [ 14, eel_death16 ] { monster_death_postcheck(); };
void() eel_death16 = [ 15, eel_death16 ] { monster_deadbody_check(); };

void() eel_death = {
   monster_death_precheck();
   if (!self.gibbed) { eel_death1(); }
};

void(entity inflictor, entity attacker, float damage) eel_pain1 = [ 6, eel_pain2 ] {
   if (self.pain_finished > time) return;

   self.pain_finished = (time + TRUE);
   sound(self,CHAN_VOICE,self.pain_sound,TRUE,ATTN_NORM);
   self.skin = FALSE;
};
void() eel_pain2 = [ 7, eel_pain3 ] {};
void() eel_pain3 = [ 8, eel_pain4 ] {};
void() eel_pain4 = [ 9, eel_pain5 ] {};
void() eel_pain5 = [ 8, eel_pain6 ] {};
void() eel_pain6 = [ 7, eel_pain7 ] {};
void() eel_pain7 = [ 6, eel_run1 ] {};

void() monster_eel_precache = {
	precache_model("progs/ad171/mon_eel.mdl");
	precache_model("progs/ad171/h_eel.mdl");
	precache_model("progs/ad171/eelgib.mdl");
	precache_model("progs/ad171/gib1.mdl");
	precache_model("progs/ad171/proj_plasma.mdl");
	precache_model(MODEL_PROJ_PLASMAGRN);
	precache_poisongibs(); // precache gibs
	precache_sound("rogue/eel/edie3r.wav");
	precache_sound("rogue/eel/epain3.wav");
	precache_sound("ad171/eel/idle1.wav");
	precache_sound("rogue/eel/eatt1.wav");
	precache_sound("rogue/eel/eelc5.wav");
	precache_sound("ad171/eel/impact1.wav");
	precache_sound("rogue/eel/eatt1.wav");
};

void() monster_eel = {
	if (monster_checkrandomizer() == TRUE) return; // Check for any random monster setups
	if (monster_checkspawn() == TRUE) return; // Check all spawn exceptions (monsters.qc)

	self.mdl = "progs/ad171/mon_eel.mdl";
	self.headmdl = "progs/ad171/h_eel.mdl";
	self.pain_sound = "rogue/eel/epain3.wav";
	self.sight_sound = "rogue/eel/eelc5.wav";
	if (self.poisonous) self.gibtype = GIBTYPE_POISON;	// Poisonous blood trails
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_NONE;
	if (self.bboxtype < 1) self.bboxtype = BBOX_EEL;
	if (self.health < 1) self.health = 60;
	self.gibhealth = -25;
	self.gibbed = FALSE;
	self.blockudeath = TRUE;
	self.pain_flinch = 10;	// Easy response to pain
	self.steptype = FS_FLYING;		// It has fins!?!
	if (self.spawnflags & MON_LIQUIDBLOCK) self.liquidblock = TRUE; // Check for water sightline wakeup
	Resist_ChangeType(self,-1); // Always reset Ammo Resistance to be consistent
	self.th_stand = eel_stand1;
	self.th_walk = eel_walk1;
	self.th_run = eel_run1;
	self.th_die = eel_death;
	self.th_pain = eel_pain1;
	self.th_melee = eel_attack1;
	self.th_missile = eel_attack2_1;
	self.classtype = CT_MONEEL;
	self.classgroup = CG_FISH;
	self.classmove = MON_MOVESWIM;
	if (self.deathstring == "")  self.deathstring = " was electrified by an Eel\n";
	monster_start();
};
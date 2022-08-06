void () monster_ogre_coop = {

   if ( deathmatch ) {

      remove (self);
      return ;

   }
   if (!coop) {

      remove (self);
      return ;

   }
   precache_model ("progs/ogre.mdl");
   precache_model ("progs/h_ogre.mdl");
   precache_model ("progs/grenade.mdl");
   precache_sound ("ogre/ogdrag.wav");
   precache_sound ("ogre/ogdth.wav");
   precache_sound ("ogre/ogidle.wav");
   precache_sound ("ogre/ogidle2.wav");
   precache_sound ("ogre/ogpain1.wav");
   precache_sound ("ogre/ogsawatk.wav");
   precache_sound ("ogre/ogwake.wav");
   self.solid = SOLID_SLIDEBOX;
   self.movetype = MOVETYPE_STEP;
   setmodel (self,"progs/ogre.mdl");
   setsize (self,VEC_HULL2_MIN,VEC_HULL2_MAX);
   self.health = 200.000;
   self.th_stand = ogre_stand1;
   self.th_walk = ogre_walk1;
   self.th_run = ogre_run1;
   self.th_die = ogre_die;
   self.th_melee = ogre_melee;
   self.th_missile = ogre_nail1;
   self.th_pain = ogre_pain;
   walkmonster_start ();

};

void () monster_ogre_marksman_coop = {

      monster_ogre_coop ();

};

void () monster_ogre_multi_coop = {

   if ( deathmatch ) {

      remove (self);
      return ;

   }
   precache_model ("progs/ogre.mdl");
   precache_model ("progs/h_ogre.mdl");
   precache_model ("progs/grenade.mdl");
   precache_sound ("ogre/ogdrag.wav");
   precache_sound ("ogre/ogdth.wav");
   precache_sound ("ogre/ogidle.wav");
   precache_sound ("ogre/ogidle2.wav");
   precache_sound ("ogre/ogpain1.wav");
   precache_sound ("ogre/ogsawatk.wav");
   precache_sound ("ogre/ogwake.wav");
   self.solid = SOLID_SLIDEBOX;
   self.movetype = MOVETYPE_STEP;
   setmodel (self,"progs/ogre.mdl");
   setsize (self,VEC_HULL2_MIN,VEC_HULL2_MAX);
   self.spawnflags = (self.spawnflags | OGRE_BOSS);
   self.skin = TRUE;
   self.health = 200.000;
   self.th_stand = ogre_stand1;
   self.th_walk = ogre_walk1;
   self.th_run = ogre_run1;
   self.th_die = ogre_die;
   self.th_melee = ogre_melee;
   self.th_missile = ogre_nail1;
   self.th_pain = ogre_pain;
   walkmonster_start ();

};

void () monster_knight_coop = {

   if ( deathmatch ) {

      remove (self);
      return ;

   }
   if (!coop) {

      remove (self);
      return ;

   }
   precache_model ("progs/knight.mdl");
   precache_model ("progs/h_knight.mdl");
   precache_sound ("knight/kdeath.wav");
   precache_sound ("knight/khurt.wav");
   precache_sound ("knight/ksight.wav");
   precache_sound ("knight/sword1.wav");
   precache_sound ("knight/sword2.wav");
   precache_sound ("knight/idle.wav");
   self.solid = SOLID_SLIDEBOX;
   self.movetype = MOVETYPE_STEP;
   setmodel (self,"progs/knight.mdl");
   setsize (self,VEC_HULL_MIN,'16.000 16.000 40.000');
   self.health = 75.000;
   self.th_stand = knight_stand1;
   self.th_walk = knight_walk1;
   self.th_run = knight_run1;
   self.th_melee = knight_atk1;
   self.th_pain = knight_pain;
   self.th_die = knight_die;
   walkmonster_start ();

};

void () monster_deathknight_coop = {

   if ( deathmatch ) {

      remove (self);
      return ;

   }
   if (!coop) {

      remove (self);
      return ;

   }
   precache_model2 ("progs/hknight.mdl");
   precache_model2 ("progs/k_spike.mdl");
   precache_model2 ("progs/h_hellkn.mdl");
   precache_sound2 ("hknight/attack1.wav");
   precache_sound2 ("hknight/death1.wav");
   precache_sound2 ("hknight/pain1.wav");
   precache_sound2 ("hknight/sight1.wav");
   precache_sound ("hknight/hit.wav");
   precache_sound2 ("hknight/slash1.wav");
   precache_sound2 ("hknight/idle.wav");
   precache_sound2 ("hknight/grunt.wav");
   precache_sound ("knight/sword1.wav");
   precache_sound ("knight/sword2.wav");
   self.solid = SOLID_SLIDEBOX;
   self.movetype = MOVETYPE_STEP;
   setmodel (self,"progs/hknight.mdl");
   setsize (self,VEC_HULL_MIN,'16.000 16.000 40.000');
   self.health = 250.000;
   self.th_stand = hknight_stand1;
   self.th_walk = hknight_walk1;
   self.th_run = hknight_run1;
   self.th_melee = hknight_melee;
   self.th_missile = hknight_magicc1;
   self.th_pain = hknight_pain;
   self.th_die = hknight_die;
   walkmonster_start ();

};


void () monster_vore_coop = {

   if ( deathmatch ) {

      remove (self);
      return ;

   }
   if (!coop) {

      remove (self);
      return ;

   }
   precache_model2 ("progs/shalrath.mdl");
   precache_model2 ("progs/h_shal.mdl");
   precache_model2 ("progs/v_spike.mdl");
   precache_sound2 ("shalrath/attack.wav");
   precache_sound2 ("shalrath/attack2.wav");
   precache_sound2 ("shalrath/death.wav");
   precache_sound2 ("shalrath/idle.wav");
   precache_sound2 ("shalrath/pain.wav");
   precache_sound2 ("shalrath/sight.wav");
   self.solid = SOLID_SLIDEBOX;
   self.movetype = MOVETYPE_STEP;
   setmodel (self,"progs/shalrath.mdl");
   setsize (self,VEC_HULL2_MIN,VEC_HULL2_MAX);
   self.health = 400.000;
   self.th_stand = shal_stand;
   self.th_walk = shal_walk1;
   self.th_run = shal_run1;
   self.th_die = shalrath_die;
   self.th_pain = shalrath_pain;
   self.th_missile = shal_attack1;
   self.think = walkmonster_start;
   self.nextthink = ((time + 0.100) + (random () * 0.100));

};

void () monster_shambler_coop = {

   if ( deathmatch ) {

      remove (self);
      return ;

   }
   if (!coop) {

      remove (self);
      return ;

   }
   precache_model ("progs/shambler.mdl");
   precache_model ("progs/s_light.mdl");
   precache_model ("progs/h_shams.mdl");
   precache_model ("progs/bolt.mdl");
   precache_sound ("shambler/sattck1.wav");
   precache_sound ("shambler/sboom.wav");
   precache_sound ("shambler/sdeath.wav");
   precache_sound ("shambler/shurt2.wav");
   precache_sound ("shambler/sidle.wav");
   precache_sound ("shambler/ssight.wav");
   precache_sound ("shambler/melee1.wav");
   precache_sound ("shambler/melee2.wav");
   precache_sound ("shambler/smack.wav");
   self.solid = SOLID_SLIDEBOX;
   self.movetype = MOVETYPE_STEP;
   setmodel (self,"progs/shambler.mdl");
   setsize (self,VEC_HULL2_MIN,VEC_HULL2_MAX);
   self.health = 600.000;
   self.th_stand = sham_stand1;
   self.th_walk = sham_walk1;
   self.th_run = sham_run1;
   self.th_die = sham_die;
   self.th_melee = sham_melee;
   self.th_missile = sham_magic1;
   self.th_pain = sham_pain;
   walkmonster_start ();

};

void () monster_army_coop = {

   if ( deathmatch ) {

      remove (self);
      return ;

   }
   if (!coop) {

      remove (self);
      return ;

   }
   precache_model ("progs/soldier.mdl");
   precache_model ("progs/h_guard.mdl");
   precache_model ("progs/gib1.mdl");
   precache_model ("progs/gib2.mdl");
   precache_model ("progs/gib3.mdl");
   precache_sound ("soldier/death1.wav");
   precache_sound ("soldier/idle.wav");
   precache_sound ("soldier/pain1.wav");
   precache_sound ("soldier/pain2.wav");
   precache_sound ("soldier/sattck1.wav");
   precache_sound ("soldier/sight1.wav");
   precache_sound ("player/udeath.wav");
   self.solid = SOLID_SLIDEBOX;
   self.movetype = MOVETYPE_STEP;
   setmodel (self,"progs/soldier.mdl");
   setsize (self,VEC_HULL_MIN,'16.000 16.000 40.000');
   self.health = SVC_INTERMISSION;
   self.th_stand = army_stand1;
   self.th_walk = army_walk1;
   self.th_run = army_run1;
   self.th_missile = army_atk1;
   self.th_pain = army_pain;
   self.th_die = army_die;
   walkmonster_start ();

};

void () monster_tarbaby_coop = {

   if ( deathmatch ) {

      remove (self);
      return ;

   }
   if (!coop) {

      remove (self);
      return ;

   }
   precache_model2 ("progs/tarbaby.mdl");
   precache_sound2 ("blob/death1.wav");
   precache_sound2 ("blob/hit1.wav");
   precache_sound2 ("blob/land1.wav");
   precache_sound2 ("blob/sight1.wav");
   self.solid = SOLID_SLIDEBOX;
   self.movetype = MOVETYPE_STEP;
   setmodel (self,"progs/tarbaby.mdl");
   setsize (self,VEC_HULL_MIN,'16.000 16.000 40.000');
   self.health = 80.000;
   self.th_stand = tbaby_stand1;
   self.th_walk = tbaby_walk1;
   self.th_run = tbaby_run1;
   self.th_missile = tbaby_jump1;
   self.th_melee = tbaby_jump1;
   self.th_die = tbaby_die1;
   walkmonster_start ();

};

void () monster_zombie_coop = {

   if ( deathmatch ) {

      remove (self);
      return ;

   }
   if (!coop) {

      remove (self);
      return ;

   }
   precache_model ("progs/zombie.mdl");
   precache_model ("progs/h_zombie.mdl");
   precache_model ("progs/zom_gib.mdl");
   precache_sound ("zombie/z_idle.wav");
   precache_sound ("zombie/z_idle1.wav");
   precache_sound ("zombie/z_shot1.wav");
   precache_sound ("zombie/z_gib.wav");
   precache_sound ("zombie/z_pain.wav");
   precache_sound ("zombie/z_pain1.wav");
   precache_sound ("zombie/z_fall.wav");
   precache_sound ("zombie/z_miss.wav");
   precache_sound ("zombie/z_hit.wav");
   precache_sound ("zombie/idle_w2.wav");
   self.solid = SOLID_SLIDEBOX;
   self.movetype = MOVETYPE_STEP;
   setmodel (self,"progs/zombie.mdl");
   setsize (self,VEC_HULL_MIN,'16.000 16.000 40.000');
   self.health = 60.000;
   self.th_stand = zombie_stand1;
   self.th_walk = zombie_walk1;
   self.th_run = zombie_run1;
   self.th_pain = zombie_pain;
   self.th_die = zombie_die;
   self.th_missile = zombie_missile;
   if ( (self.spawnflags & SPAWN_CRUCIFIED) ) {

      self.movetype = MOVETYPE_NONE;
      zombie_cruc1 ();

   } else {

      walkmonster_start ();

   }

};

void () monster_fish_coop = {

   if ( deathmatch ) {

      remove (self);
      return ;

   }
   if (!coop) {

      remove (self);
      return ;

   }
   precache_model2 ("progs/fish.mdl");
   precache_sound2 ("fish/death.wav");
   precache_sound2 ("fish/bite.wav");
   precache_sound2 ("fish/idle.wav");
   self.solid = SOLID_SLIDEBOX;
   self.movetype = MOVETYPE_STEP;
   setmodel (self,"progs/fish.mdl");
   setsize (self,VEC_HULL_MIN,'16.000 16.000 24.000');
   self.health = 25.000;
   self.th_stand = f_stand1;
   self.th_walk = f_walk1;
   self.th_run = f_run1;
   self.th_die = f_death1;
   self.th_pain = fish_pain;
   self.th_melee = f_attack1;
   swimmonster_start ();

};

void () monster_enforcer_coop = {

   if ( deathmatch ) {

      remove (self);
      return ;

   }
   if (!coop) {

      remove (self);
      return ;

   }
   precache_model2 ("progs/enforcer.mdl");
   precache_model2 ("progs/h_mega.mdl");
   precache_model2 ("progs/laser.mdl");
   precache_sound2 ("enforcer/death1.wav");
   precache_sound2 ("enforcer/enfire.wav");
   precache_sound2 ("enforcer/enfstop.wav");
   precache_sound2 ("enforcer/idle1.wav");
   precache_sound2 ("enforcer/pain1.wav");
   precache_sound2 ("enforcer/pain2.wav");
   precache_sound2 ("enforcer/sight1.wav");
   precache_sound2 ("enforcer/sight2.wav");
   precache_sound2 ("enforcer/sight3.wav");
   precache_sound2 ("enforcer/sight4.wav");
   self.solid = SOLID_SLIDEBOX;
   self.movetype = MOVETYPE_STEP;
   setmodel (self,"progs/enforcer.mdl");
   setsize (self,VEC_HULL_MIN,'16.000 16.000 40.000');
   self.health = 80.000;
   self.th_stand = enf_stand1;
   self.th_walk = enf_walk1;
   self.th_run = enf_run1;
   self.th_pain = enf_pain;
   self.th_die = enf_die;
   self.th_missile = enf_atk1;
   walkmonster_start ();

};


void () monster_dog_coop = {

   if ( deathmatch ) {

      remove (self);
      return ;

   }
   if (!coop) {

      remove (self);
      return ;

   }
   precache_model ("progs/h_dog.mdl");
   precache_model ("progs/dog.mdl");
   precache_sound ("dog/dattack1.wav");
   precache_sound ("dog/ddeath.wav");
   precache_sound ("dog/dpain1.wav");
   precache_sound ("dog/dsight.wav");
   precache_sound ("dog/idle.wav");
   self.solid = SOLID_SLIDEBOX;
   self.movetype = MOVETYPE_STEP;
   setmodel (self,"progs/dog.mdl");
   setsize (self,VEC_HULL2_MIN,'32.000 32.000 40.000');
   self.health = 25.000;
   self.th_stand = dog_stand1;
   self.th_walk = dog_walk1;
   self.th_run = dog_run1;
   self.th_pain = dog_pain;
   self.th_die = dog_die;
   self.th_melee = dog_atta1;
   self.th_missile = dog_leap1;
   walkmonster_start ();

};

void () monster_demon1_coop = {

   if ( deathmatch ) {

      remove (self);
      return ;

   }
   if (!coop) {

      remove (self);
      return ;

   }
   precache_model ("progs/demon.mdl");
   precache_model ("progs/h_demon.mdl");
   precache_sound ("demon/ddeath.wav");
   precache_sound ("demon/dhit2.wav");
   precache_sound ("demon/djump.wav");
   precache_sound ("demon/dpain1.wav");
   precache_sound ("demon/idle1.wav");
   precache_sound ("demon/sight2.wav");
   self.solid = SOLID_SLIDEBOX;
   self.movetype = MOVETYPE_STEP;
   setmodel (self,"progs/demon.mdl");
   setsize (self,VEC_HULL2_MIN,VEC_HULL2_MAX);
   self.health = 300.000;
   self.th_stand = demon1_stand1;
   self.th_walk = demon1_walk1;
   self.th_run = demon1_run1;
   self.th_die = demon_die;
   self.th_melee = Demon_MeleeAttack;
   self.th_missile = demon1_jump1;
   self.th_pain = demon1_pain;
   walkmonster_start ();

};

void () monster_wizard_coop = {

   if ( deathmatch ) {

      remove (self);
      return ;

   }
   if (!coop) {

      remove (self);
      return ;

   }
   precache_model ("progs/wizard.mdl");
   precache_model ("progs/h_wizard.mdl");
   precache_model ("progs/w_spike.mdl");
   precache_sound ("wizard/hit.wav");
   precache_sound ("wizard/wattack.wav");
   precache_sound ("wizard/wdeath.wav");
   precache_sound ("wizard/widle1.wav");
   precache_sound ("wizard/widle2.wav");
   precache_sound ("wizard/wpain.wav");
   precache_sound ("wizard/wsight.wav");
   self.solid = SOLID_SLIDEBOX;
   self.movetype = MOVETYPE_STEP;
   setmodel (self,"progs/wizard.mdl");
   setsize (self,VEC_HULL_MIN,'16.000 16.000 40.000');
   self.health = 80.000;
   self.th_stand = wiz_stand1;
   self.th_walk = wiz_walk1;
   self.th_run = wiz_run1;
   self.th_missile = Wiz_Missile;
   self.th_pain = Wiz_Pain;
   self.th_die = wiz_die;
   flymonster_start ();

};

void () monster_gremlin_coop = {

   if ( deathmatch ) {

      remove (self);
      return ;

   }
   if (!coop) {

      remove (self);
      return ;

   }
   monster_gremlin ();

};
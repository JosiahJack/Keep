
void () army_fire;

void () army_stand1 = [ 0.000, army_stand2 ] {

   ai_stand ();

};

void () army_stand2 = [ 1.000, army_stand3 ] {

   ai_stand ();

};

void () army_stand3 = [ 2.000, army_stand4 ] {

   ai_stand ();

};

void () army_stand4 = [ 3.000, army_stand5 ] {

   ai_stand ();

};

void () army_stand5 = [ 4.000, army_stand6 ] {

   ai_stand ();

};

void () army_stand6 = [ 5.000, army_stand7 ] {

   ai_stand ();

};

void () army_stand7 = [ 6.000, army_stand8 ] {

   ai_stand ();

};

void () army_stand8 = [ 7.000, army_stand1 ] {

   ai_stand ();

};

void () army_walk1 = [ 90.000, army_walk2 ] {

   if ( (random () < 0.200) ) {

      sound (self,CHAN_VOICE,"soldier/idle.wav",TRUE,ATTN_IDLE);

   }
   ai_walk (TRUE);

};

void () army_walk2 = [ 91.000, army_walk3 ] {

   ai_walk (TRUE);

};

void () army_walk3 = [ 92.000, army_walk4 ] {

   ai_walk (TRUE);

};

void () army_walk4 = [ 93.000, army_walk5 ] {

   ai_walk (TRUE);

};

void () army_walk5 = [ 94.000, army_walk6 ] {

   ai_walk (FL_SWIM);

};

void () army_walk6 = [ 95.000, army_walk7 ] {

   ai_walk (MOVETYPE_WALK);

};

void () army_walk7 = [ 96.000, army_walk8 ] {

   ai_walk (MOVETYPE_STEP);

};

void () army_walk8 = [ 97.000, army_walk9 ] {

   ai_walk (MOVETYPE_STEP);

};

void () army_walk9 = [ 98.000, army_walk10 ] {

   ai_walk (FL_SWIM);

};

void () army_walk10 = [ 99.000, army_walk11 ] {

   ai_walk (FL_SWIM);

};

void () army_walk11 = [ 100.000, army_walk12 ] {

   ai_walk (FL_SWIM);

};

void () army_walk12 = [ 101.000, army_walk13 ] {

   ai_walk (TRUE);

};

void () army_walk13 = [ 102.000, army_walk14 ] {

   ai_walk (FALSE);

};

void () army_walk14 = [ 103.000, army_walk15 ] {

   ai_walk (TRUE);

};

void () army_walk15 = [ 104.000, army_walk16 ] {

   ai_walk (TRUE);

};

void () army_walk16 = [ 105.000, army_walk17 ] {

   ai_walk (TRUE);

};

void () army_walk17 = [ 106.000, army_walk18 ] {

   ai_walk (MOVETYPE_WALK);

};

void () army_walk18 = [ 107.000, army_walk19 ] {

   ai_walk (MOVETYPE_WALK);

};

void () army_walk19 = [ 108.000, army_walk20 ] {

   ai_walk (MOVETYPE_WALK);

};

void () army_walk20 = [ 109.000, army_walk21 ] {

   ai_walk (MOVETYPE_WALK);

};

void () army_walk21 = [ 110.000, army_walk22 ] {

   ai_walk (FL_SWIM);

};

void () army_walk22 = [ 111.000, army_walk23 ] {

   ai_walk (TRUE);

};

void () army_walk23 = [ 112.000, army_walk24 ] {

   ai_walk (TRUE);

};

void () army_walk24 = [ 113.000, army_walk1 ] {

   ai_walk (TRUE);

};

void () army_run1 = [ 73.000, army_run2 ] {

   if ( (random () < 0.200) ) {

      sound (self,CHAN_VOICE,"soldier/idle.wav",TRUE,ATTN_IDLE);

   }
   ai_run (MOVETYPE_BOUNCEMISSILE);

};

void () army_run2 = [ 74.000, army_run3 ] {

   ai_run (15.000);

};

void () army_run3 = [ 75.000, army_run4 ] {

   ai_run (MOVETYPE_BOUNCE);

};

void () army_run4 = [ 76.000, army_run5 ] {

   ai_run (MOVETYPE_BOUNCE);

};

void () army_run5 = [ 77.000, army_run6 ] {

   ai_run (FL_CLIENT);

};

void () army_run6 = [ 78.000, army_run7 ] {

   ai_run (15.000);

};

void () army_run7 = [ 79.000, army_run8 ] {

   ai_run (MOVETYPE_BOUNCE);

};

void () army_run8 = [ 80.000, army_run1 ] {

   ai_run (FL_CLIENT);

};

void () army_atk1 = [ 81.000, army_atk2 ] {

   ai_face ();

};

void () army_atk2 = [ 82.000, army_atk3 ] {

   ai_face ();

};

void () army_atk3 = [ 83.000, army_atk4 ] {

   ai_face ();

};

void () army_atk4 = [ 84.000, army_atk5 ] {

   ai_face ();

};

void () army_atk5 = [ 85.000, army_atk6 ] {

   ai_face ();
   army_fire ();
   self.effects = (self.effects | EF_MUZZLEFLASH);

};

void () army_atk6 = [ 86.000, army_atk7 ] {

   ai_face ();

};

void () army_atk7 = [ 87.000, army_atk8 ] {

   ai_face ();
   SUB_CheckRefire (army_atk1);

};

void () army_atk8 = [ 88.000, army_atk9 ] {

   ai_face ();

};

void () army_atk9 = [ 89.000, army_run1 ] {

   ai_face ();

};

void () army_pain1 = [ 40.000, army_pain2 ] {


};

void () army_pain2 = [ 41.000, army_pain3 ] {


};

void () army_pain3 = [ 42.000, army_pain4 ] {


};

void () army_pain4 = [ 43.000, army_pain5 ] {


};

void () army_pain5 = [ 44.000, army_pain6 ] {


};

void () army_pain6 = [ 45.000, army_run1 ] {

   ai_pain (TRUE);

};

void () army_painb1 = [ 46.000, army_painb2 ] {


};

void () army_painb2 = [ 47.000, army_painb3 ] {

   ai_painforward (13.000);

};

void () army_painb3 = [ 48.000, army_painb4 ] {

   ai_painforward (MOVETYPE_FLYMISSILE);

};

void () army_painb4 = [ 49.000, army_painb5 ] {


};

void () army_painb5 = [ 50.000, army_painb6 ] {


};

void () army_painb6 = [ 51.000, army_painb7 ] {


};

void () army_painb7 = [ 52.000, army_painb8 ] {


};

void () army_painb8 = [ 53.000, army_painb9 ] {


};

void () army_painb9 = [ 54.000, army_painb10 ] {


};

void () army_painb10 = [ 55.000, army_painb11 ] {


};

void () army_painb11 = [ 56.000, army_painb12 ] {


};

void () army_painb12 = [ 57.000, army_painb13 ] {

   ai_pain (FL_SWIM);

};

void () army_painb13 = [ 58.000, army_painb14 ] {


};

void () army_painb14 = [ 59.000, army_run1 ] {


};

void () army_painc1 = [ 60.000, army_painc2 ] {


};

void () army_painc2 = [ 61.000, army_painc3 ] {

   ai_pain (TRUE);

};

void () army_painc3 = [ 62.000, army_painc4 ] {


};

void () army_painc4 = [ 63.000, army_painc5 ] {


};

void () army_painc5 = [ 64.000, army_painc6 ] {

   ai_painforward (TRUE);

};

void () army_painc6 = [ 65.000, army_painc7 ] {

   ai_painforward (TRUE);

};

void () army_painc7 = [ 66.000, army_painc8 ] {


};

void () army_painc8 = [ 67.000, army_painc9 ] {

   ai_pain (TRUE);

};

void () army_painc9 = [ 68.000, army_painc10 ] {

   ai_painforward (MOVETYPE_STEP);

};

void () army_painc10 = [ 69.000, army_painc11 ] {

   ai_painforward (MOVETYPE_WALK);

};

void () army_painc11 = [ 70.000, army_painc12 ] {

   ai_painforward (MOVETYPE_TOSS);

};

void () army_painc12 = [ 71.000, army_painc13 ] {

   ai_painforward (FL_CLIENT);

};

void () army_painc13 = [ 72.000, army_run1 ] {


};

void (entity attacker, float damage) army_pain = {

   local float r;

   if ( (self.pain_finished > time) ) {

      return ;

   }
   r = random ();
   if ( (r < 0.200) ) {

      self.pain_finished = (time + 0.600);
      army_pain1 ();
      sound (self,CHAN_VOICE,"soldier/pain1.wav",TRUE,ATTN_NORM);

   } else {

      if ( (r < 0.600) ) {

         self.pain_finished = (time + 1.100);
         army_painb1 ();
         sound (self,CHAN_VOICE,"soldier/pain2.wav",TRUE,ATTN_NORM);

      } else {

         self.pain_finished = (time + 1.100);
         army_painc1 ();
         sound (self,CHAN_VOICE,"soldier/pain2.wav",TRUE,ATTN_NORM);

      }

   }

};

void () army_fire = {

   local vector dir;
   local entity en;

   ai_face ();
   sound (self,CHAN_WEAPON,"soldier/sattck1.wav",TRUE,ATTN_NORM);
   en = self.enemy;
   dir = (en.origin - (en.velocity * 0.200));
   dir = normalize ((dir - self.origin));
   FireBullets (MOVETYPE_STEP,dir,'0.100 0.100 0.000');

};

void () army_die1 = [ 8.000, army_die2 ] {


};

void () army_die2 = [ 9.000, army_die3 ] {


};

void () army_die3 = [ 10.000, army_die4 ] {

   self.solid = SOLID_NOT;
   self.ammo_shells1 = MOVETYPE_FLY;
   DropBackpack ();

};

void () army_die4 = [ 11.000, army_die5 ] {


};

void () army_die5 = [ 12.000, army_die6 ] {


};

void () army_die6 = [ 13.000, army_die7 ] {


};

void () army_die7 = [ 14.000, army_die8 ] {


};

void () army_die8 = [ 15.000, army_die9 ] {


};

void () army_die9 = [ 16.000, army_die10 ] {


};

void () army_die10 = [ 17.000, army_die10 ] {

   if (bodyfade) {

      self.think = body_kill;
      self.nextthink = (time + 60.000);

   }

};

void () army_cdie1 = [ 18.000, army_cdie2 ] {


};

void () army_cdie2 = [ 19.000, army_cdie3 ] {

   ai_back (MOVETYPE_FLY);

};

void () army_cdie3 = [ 20.000, army_cdie4 ] {

   self.solid = SOLID_NOT;
   self.ammo_shells1 = MOVETYPE_FLY;
   DropBackpack ();
   ai_back (MOVETYPE_STEP);

};

void () army_cdie4 = [ 21.000, army_cdie5 ] {

   ai_back (13.000);

};

void () army_cdie5 = [ 22.000, army_cdie6 ] {

   ai_back (MOVETYPE_WALK);

};

void () army_cdie6 = [ 23.000, army_cdie7 ] {

   ai_back (MOVETYPE_STEP);

};

void () army_cdie7 = [ 24.000, army_cdie8 ] {


};

void () army_cdie8 = [ 25.000, army_cdie9 ] {


};

void () army_cdie9 = [ 26.000, army_cdie10 ] {


};

void () army_cdie10 = [ 27.000, army_cdie11 ] {


};

void () army_cdie11 = [ 28.000, army_cdie11 ] {

   if (bodyfade) {

      self.think = body_kill;
      self.nextthink = (time + 60.000);

   }

};

void () army_die = {

   if ( (self.health < -35.000) ) {

      sound (self,CHAN_VOICE,"player/udeath.wav",TRUE,ATTN_NORM);
      ThrowHead ("progs/h_guard.mdl",self.health);
      ThrowGib ("progs/gib1.mdl",self.health, GIB_FLESH);
      ThrowGib ("progs/gib2.mdl",self.health, GIB_FLESH);
      ThrowGib ("progs/gib3.mdl",self.health, GIB_FLESH);
      return ;

   }
   sound (self,CHAN_VOICE,"soldier/death1.wav",TRUE,ATTN_NORM);
   if ( (random () < 0.500) ) {

      army_die1 ();

   } else {

      army_cdie1 ();

   }

};

void () monster_army = {

   if ( deathmatch ) {

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

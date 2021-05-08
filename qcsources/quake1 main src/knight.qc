
void () knight_stand1 = [ 0.000, knight_stand2 ] {

   ai_stand ();

};

void () knight_stand2 = [ 1.000, knight_stand3 ] {

   ai_stand ();

};

void () knight_stand3 = [ 2.000, knight_stand4 ] {

   ai_stand ();

};

void () knight_stand4 = [ 3.000, knight_stand5 ] {

   ai_stand ();

};

void () knight_stand5 = [ 4.000, knight_stand6 ] {

   ai_stand ();

};

void () knight_stand6 = [ 5.000, knight_stand7 ] {

   ai_stand ();

};

void () knight_stand7 = [ 6.000, knight_stand8 ] {

   ai_stand ();

};

void () knight_stand8 = [ 7.000, knight_stand9 ] {

   ai_stand ();

};

void () knight_stand9 = [ 8.000, knight_stand1 ] {

   ai_stand ();

};

void () knight_walk1 = [ 53.000, knight_walk2 ] {

   if ( (random () < 0.200) ) {

      sound (self,CHAN_VOICE,"knight/idle.wav",TRUE,ATTN_IDLE);

   }
   ai_walk (MOVETYPE_WALK);

};

void () knight_walk2 = [ 54.000, knight_walk3 ] {

   ai_walk (FL_SWIM);

};

void () knight_walk3 = [ 55.000, knight_walk4 ] {

   ai_walk (MOVETYPE_WALK);

};

void () knight_walk4 = [ 56.000, knight_walk5 ] {

   ai_walk (MOVETYPE_STEP);

};

void () knight_walk5 = [ 57.000, knight_walk6 ] {

   ai_walk (MOVETYPE_WALK);

};

void () knight_walk6 = [ 58.000, knight_walk7 ] {

   ai_walk (MOVETYPE_WALK);

};

void () knight_walk7 = [ 59.000, knight_walk8 ] {

   ai_walk (MOVETYPE_WALK);

};

void () knight_walk8 = [ 60.000, knight_walk9 ] {

   ai_walk (MOVETYPE_STEP);

};

void () knight_walk9 = [ 61.000, knight_walk10 ] {

   ai_walk (MOVETYPE_WALK);

};

void () knight_walk10 = [ 62.000, knight_walk11 ] {

   ai_walk (MOVETYPE_WALK);

};

void () knight_walk11 = [ 63.000, knight_walk12 ] {

   ai_walk (FL_SWIM);

};

void () knight_walk12 = [ 64.000, knight_walk13 ] {

   ai_walk (MOVETYPE_WALK);

};

void () knight_walk13 = [ 65.000, knight_walk14 ] {

   ai_walk (MOVETYPE_STEP);

};

void () knight_walk14 = [ 66.000, knight_walk1 ] {

   ai_walk (MOVETYPE_WALK);

};

void () knight_run1 = [ 9.000, knight_run2 ] {

   if ( (random () < 0.200) ) {

      sound (self,CHAN_VOICE,"knight/idle.wav",TRUE,ATTN_IDLE);

   }
   ai_run (FL_INWATER);

};

void () knight_run2 = [ 10.000, knight_run3 ] {

   ai_run (20.000);

};

void () knight_run3 = [ 11.000, knight_run4 ] {

   ai_run (13.000);

};

void () knight_run4 = [ 12.000, knight_run5 ] {

   ai_run (MOVETYPE_PUSH);

};

void () knight_run5 = [ 13.000, knight_run6 ] {

   ai_run (FL_INWATER);

};

void () knight_run6 = [ 14.000, knight_run7 ] {

   ai_run (20.000);

};

void () knight_run7 = [ 15.000, knight_run8 ] {

   ai_run (14.000);

};

void () knight_run8 = [ 16.000, knight_run1 ] {

   ai_run (MOVETYPE_TOSS);

};

void () knight_runatk1 = [ 17.000, knight_runatk2 ] {

   if ( (random () > 0.500) ) {

      sound (self,CHAN_WEAPON,"knight/sword2.wav",TRUE,ATTN_NORM);

   } else {

      sound (self,CHAN_WEAPON,"knight/sword1.wav",TRUE,ATTN_NORM);

   }
   ai_charge (20.000);

};

void () knight_runatk2 = [ 18.000, knight_runatk3 ] {

   ai_charge_side ();

};

void () knight_runatk3 = [ 19.000, knight_runatk4 ] {

   ai_charge_side ();

};

void () knight_runatk4 = [ 20.000, knight_runatk5 ] {

   ai_charge_side ();

};

void () knight_runatk5 = [ 21.000, knight_runatk6 ] {

   ai_melee_side ();

};

void () knight_runatk6 = [ 22.000, knight_runatk7 ] {

   ai_melee_side ();

};

void () knight_runatk7 = [ 23.000, knight_runatk8 ] {

   ai_melee_side ();

};

void () knight_runatk8 = [ 24.000, knight_runatk9 ] {

   ai_melee_side ();

};

void () knight_runatk9 = [ 25.000, knight_runatk10 ] {

   ai_melee_side ();

};

void () knight_runatk10 = [ 26.000, knight_runatk11 ] {

   ai_charge_side ();

};

void () knight_runatk11 = [ 27.000, knight_run1 ] {

   ai_charge (MOVETYPE_BOUNCE);

};

void () knight_atk1 = [ 42.000, knight_atk2 ] {

   sound (self,CHAN_WEAPON,"knight/sword1.wav",TRUE,ATTN_NORM);
   ai_charge (FALSE);

};

void () knight_atk2 = [ 44.000, knight_atk3 ] {

   ai_charge (MOVETYPE_PUSH);

};

void () knight_atk3 = [ 45.000, knight_atk4 ] {

   ai_charge (MOVETYPE_STEP);

};

void () knight_atk4 = [ 46.000, knight_atk5 ] {

   ai_charge (FALSE);

};

void () knight_atk5 = [ 47.000, knight_atk6 ] {

   ai_charge (MOVETYPE_WALK);

};

void () knight_atk6 = [ 48.000, knight_atk7 ] {

   ai_charge (MOVETYPE_STEP);
   ai_melee ();

};

void () knight_atk7 = [ 49.000, knight_atk8 ] {

   ai_charge (TRUE);
   ai_melee ();

};

void () knight_atk8 = [ 50.000, knight_atk9 ] {

   ai_charge (MOVETYPE_WALK);
   ai_melee ();

};

void () knight_atk9 = [ 51.000, knight_atk10 ] {

   ai_charge (TRUE);

};

void () knight_atk10 = [ 52.000, knight_run1 ] {

   ai_charge (MOVETYPE_FLY);

};

void () knight_pain1 = [ 28.000, knight_pain2 ] {


};

void () knight_pain2 = [ 29.000, knight_pain3 ] {


};

void () knight_pain3 = [ 30.000, knight_run1 ] {


};

void () knight_painb1 = [ 31.000, knight_painb2 ] {

   ai_painforward (FALSE);

};

void () knight_painb2 = [ 32.000, knight_painb3 ] {

   ai_painforward (MOVETYPE_WALK);

};

void () knight_painb3 = [ 33.000, knight_painb4 ] {


};

void () knight_painb4 = [ 34.000, knight_painb5 ] {


};

void () knight_painb5 = [ 35.000, knight_painb6 ] {

   ai_painforward (FL_SWIM);

};

void () knight_painb6 = [ 36.000, knight_painb7 ] {

   ai_painforward (MOVETYPE_STEP);

};

void () knight_painb7 = [ 37.000, knight_painb8 ] {

   ai_painforward (FL_SWIM);

};

void () knight_painb8 = [ 38.000, knight_painb9 ] {

   ai_painforward (MOVETYPE_FLY);

};

void () knight_painb9 = [ 39.000, knight_painb10 ] {

   ai_painforward (MOVETYPE_FLY);

};

void () knight_painb10 = [ 40.000, knight_painb11 ] {

   ai_painforward (FALSE);

};

void () knight_painb11 = [ 41.000, knight_run1 ] {


};

void (entity attacker, float damage) knight_pain = {

   local float r;

   if ( (self.pain_finished > time) ) {

      return ;

   }
   r = random ();
   sound (self,CHAN_VOICE,"knight/khurt.wav",TRUE,ATTN_NORM);
   if ( (r < 0.850) ) {

      knight_pain1 ();
      self.pain_finished = (time + TRUE);

   } else {

      knight_painb1 ();
      self.pain_finished = (time + TRUE);

   }

};

void () knight_bow1 = [ 67.000, knight_bow2 ] {

   ai_turn ();

};

void () knight_bow2 = [ 68.000, knight_bow3 ] {

   ai_turn ();

};

void () knight_bow3 = [ 69.000, knight_bow4 ] {

   ai_turn ();

};

void () knight_bow4 = [ 70.000, knight_bow5 ] {

   ai_turn ();

};

void () knight_bow5 = [ 71.000, knight_bow5 ] {

   ai_turn ();

};

void () knight_bow6 = [ 70.000, knight_bow7 ] {

   ai_turn ();

};

void () knight_bow7 = [ 69.000, knight_bow8 ] {

   ai_turn ();

};

void () knight_bow8 = [ 68.000, knight_bow9 ] {

   ai_turn ();

};

void () knight_bow9 = [ 67.000, knight_bow10 ] {

   ai_turn ();

};

void () knight_bow10 = [ 53.000, knight_walk1 ] {

   ai_turn ();

};

void () knight_die1 = [ 76.000, knight_die2 ] {


};

void () knight_die2 = [ 77.000, knight_die3 ] {


};

void () knight_die3 = [ 78.000, knight_die4 ] {

   self.solid = SOLID_NOT;

};

void () knight_die4 = [ 79.000, knight_die5 ] {


};

void () knight_die5 = [ 80.000, knight_die6 ] {


};

void () knight_die6 = [ 81.000, knight_die7 ] {


};

void () knight_die7 = [ 82.000, knight_die8 ] {


};

void () knight_die8 = [ 83.000, knight_die9 ] {


};

void () knight_die9 = [ 84.000, knight_die10 ] {


};

void () knight_die10 = [ 85.000, knight_die10 ] {


};

void () knight_dieb1 = [ 86.000, knight_dieb2 ] {


};

void () knight_dieb2 = [ 87.000, knight_dieb3 ] {


};

void () knight_dieb3 = [ 88.000, knight_dieb4 ] {

   self.solid = SOLID_NOT;

};

void () knight_dieb4 = [ 89.000, knight_dieb5 ] {


};

void () knight_dieb5 = [ 90.000, knight_dieb6 ] {


};

void () knight_dieb6 = [ 91.000, knight_dieb7 ] {


};

void () knight_dieb7 = [ 92.000, knight_dieb8 ] {


};

void () knight_dieb8 = [ 93.000, knight_dieb9 ] {


};

void () knight_dieb9 = [ 94.000, knight_dieb10 ] {


};

void () knight_dieb10 = [ 95.000, knight_dieb11 ] {


};

void () knight_dieb11 = [ 96.000, knight_dieb11 ] {


};

void () knight_die = {

   if ( (self.health < -40.000) ) {

      sound (self,CHAN_VOICE,"player/udeath.wav",TRUE,ATTN_NORM);
      ThrowHead ("progs/h_knight.mdl",self.health);
      ThrowGib ("progs/gib1.mdl",self.health);
      ThrowGib ("progs/gib2.mdl",self.health);
      ThrowGib ("progs/gib3.mdl",self.health);
      return ;

   }
   sound (self,CHAN_VOICE,"knight/kdeath.wav",TRUE,ATTN_NORM);
   if ( (random () < 0.500) ) {

      knight_die1 ();

   } else {

      knight_dieb1 ();

   }

};

void () monster_knight = {

   if ( deathmatch ) {

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

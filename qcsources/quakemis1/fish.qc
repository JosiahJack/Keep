
void () f_stand1 = [ 39.000, f_stand2 ] {

   ai_stand ();

};

void () f_stand2 = [ 40.000, f_stand3 ] {

   ai_stand ();

};

void () f_stand3 = [ 41.000, f_stand4 ] {

   ai_stand ();

};

void () f_stand4 = [ 42.000, f_stand5 ] {

   ai_stand ();

};

void () f_stand5 = [ 43.000, f_stand6 ] {

   ai_stand ();

};

void () f_stand6 = [ 44.000, f_stand7 ] {

   ai_stand ();

};

void () f_stand7 = [ 45.000, f_stand8 ] {

   ai_stand ();

};

void () f_stand8 = [ 46.000, f_stand9 ] {

   ai_stand ();

};

void () f_stand9 = [ 47.000, f_stand10 ] {

   ai_stand ();

};

void () f_stand10 = [ 48.000, f_stand11 ] {

   ai_stand ();

};

void () f_stand11 = [ 49.000, f_stand12 ] {

   ai_stand ();

};

void () f_stand12 = [ 50.000, f_stand13 ] {

   ai_stand ();

};

void () f_stand13 = [ 51.000, f_stand14 ] {

   ai_stand ();

};

void () f_stand14 = [ 52.000, f_stand15 ] {

   ai_stand ();

};

void () f_stand15 = [ 53.000, f_stand16 ] {

   ai_stand ();

};

void () f_stand16 = [ 54.000, f_stand17 ] {

   ai_stand ();

};

void () f_stand17 = [ 55.000, f_stand18 ] {

   ai_stand ();

};

void () f_stand18 = [ 56.000, f_stand1 ] {

   ai_stand ();

};

void () f_walk1 = [ 39.000, f_walk2 ] {

   ai_walk (FL_CLIENT);

};

void () f_walk2 = [ 40.000, f_walk3 ] {

   ai_walk (FL_CLIENT);

};

void () f_walk3 = [ 41.000, f_walk4 ] {

   ai_walk (FL_CLIENT);

};

void () f_walk4 = [ 42.000, f_walk5 ] {

   ai_walk (FL_CLIENT);

};

void () f_walk5 = [ 43.000, f_walk6 ] {

   ai_walk (FL_CLIENT);

};

void () f_walk6 = [ 44.000, f_walk7 ] {

   ai_walk (FL_CLIENT);

};

void () f_walk7 = [ 45.000, f_walk8 ] {

   ai_walk (FL_CLIENT);

};

void () f_walk8 = [ 46.000, f_walk9 ] {

   ai_walk (FL_CLIENT);

};

void () f_walk9 = [ 47.000, f_walk10 ] {

   ai_walk (FL_CLIENT);

};

void () f_walk10 = [ 48.000, f_walk11 ] {

   ai_walk (FL_CLIENT);

};

void () f_walk11 = [ 49.000, f_walk12 ] {

   ai_walk (FL_CLIENT);

};

void () f_walk12 = [ 50.000, f_walk13 ] {

   ai_walk (FL_CLIENT);

};

void () f_walk13 = [ 51.000, f_walk14 ] {

   ai_walk (FL_CLIENT);

};

void () f_walk14 = [ 52.000, f_walk15 ] {

   ai_walk (FL_CLIENT);

};

void () f_walk15 = [ 53.000, f_walk16 ] {

   ai_walk (FL_CLIENT);

};

void () f_walk16 = [ 54.000, f_walk17 ] {

   ai_walk (FL_CLIENT);

};

void () f_walk17 = [ 55.000, f_walk18 ] {

   ai_walk (FL_CLIENT);

};

void () f_walk18 = [ 56.000, f_walk1 ] {

   ai_walk (FL_CLIENT);

};

void () f_run1 = [ 39.000, f_run2 ] {

   ai_run (STAT_TOTALMONSTERS);
   if ( (random () < 0.500) ) {

      sound (self,CHAN_VOICE,"fish/idle.wav",TRUE,ATTN_NORM);

   }

};

void () f_run2 = [ 41.000, f_run3 ] {

   ai_run (STAT_TOTALMONSTERS);

};

void () f_run3 = [ 43.000, f_run4 ] {

   ai_run (STAT_TOTALMONSTERS);

};

void () f_run4 = [ 45.000, f_run5 ] {

   ai_run (STAT_TOTALMONSTERS);

};

void () f_run5 = [ 47.000, f_run6 ] {

   ai_run (STAT_TOTALMONSTERS);

};

void () f_run6 = [ 49.000, f_run7 ] {

   ai_run (STAT_TOTALMONSTERS);

};

void () f_run7 = [ 51.000, f_run8 ] {

   ai_run (STAT_TOTALMONSTERS);

};

void () f_run8 = [ 53.000, f_run9 ] {

   ai_run (STAT_TOTALMONSTERS);

};

void () f_run9 = [ 55.000, f_run1 ] {

   ai_run (STAT_TOTALMONSTERS);

};

void () fish_melee = {

   local vector delta;
   local float ldmg;

   if ( !self.enemy ) {

      return ;

   }
   delta = (self.enemy.origin - self.origin);
   if ( (vlen (delta) > 60.000) ) {

      return ;

   }
   sound (self,CHAN_VOICE,"fish/bite.wav",TRUE,ATTN_NORM);
   ldmg = ((random () + random ()) * MOVETYPE_WALK);
   T_Damage (self.enemy,self,self,ldmg);

};

void () f_attack1 = [ 0.000, f_attack2 ] {

   ai_charge (MOVETYPE_BOUNCE);

};

void () f_attack2 = [ 1.000, f_attack3 ] {

   ai_charge (MOVETYPE_BOUNCE);

};

void () f_attack3 = [ 2.000, f_attack4 ] {

   fish_melee ();

};

void () f_attack4 = [ 3.000, f_attack5 ] {

   ai_charge (MOVETYPE_BOUNCE);

};

void () f_attack5 = [ 4.000, f_attack6 ] {

   ai_charge (MOVETYPE_BOUNCE);

};

void () f_attack6 = [ 5.000, f_attack7 ] {

   ai_charge (MOVETYPE_BOUNCE);

};

void () f_attack7 = [ 6.000, f_attack8 ] {

   ai_charge (MOVETYPE_BOUNCE);

};

void () f_attack8 = [ 7.000, f_attack9 ] {

   ai_charge (MOVETYPE_BOUNCE);

};

void () f_attack9 = [ 8.000, f_attack10 ] {

   fish_melee ();

};

void () f_attack10 = [ 9.000, f_attack11 ] {

   ai_charge (MOVETYPE_BOUNCE);

};

void () f_attack11 = [ 10.000, f_attack12 ] {

   ai_charge (MOVETYPE_BOUNCE);

};

void () f_attack12 = [ 11.000, f_attack13 ] {

   ai_charge (MOVETYPE_BOUNCE);

};

void () f_attack13 = [ 12.000, f_attack14 ] {

   ai_charge (MOVETYPE_BOUNCE);

};

void () f_attack14 = [ 13.000, f_attack15 ] {

   ai_charge (MOVETYPE_BOUNCE);

};

void () f_attack15 = [ 14.000, f_attack16 ] {

   fish_melee ();

};

void () f_attack16 = [ 15.000, f_attack17 ] {

   ai_charge (MOVETYPE_BOUNCE);

};

void () f_attack17 = [ 16.000, f_attack18 ] {

   ai_charge (MOVETYPE_BOUNCE);

};

void () f_attack18 = [ 17.000, f_run1 ] {

   ai_charge (MOVETYPE_BOUNCE);

};

void () f_death1 = [ 18.000, f_death2 ] {

   sound (self,CHAN_VOICE,"fish/death.wav",TRUE,ATTN_NORM);

};

void () f_death2 = [ 19.000, f_death3 ] {


};

void () f_death3 = [ 20.000, f_death4 ] {


};

void () f_death4 = [ 21.000, f_death5 ] {


};

void () f_death5 = [ 22.000, f_death6 ] {

   self.solid = SOLID_NOT;

};

void () f_death6 = [ 23.000, f_death7 ] {


};

void () f_death7 = [ 24.000, f_death8 ] {


};

void () f_death8 = [ 25.000, f_death9 ] {


};

void () f_death9 = [ 26.000, f_death10 ] {


};

void () f_death10 = [ 27.000, f_death11 ] {


};

void () f_death11 = [ 28.000, f_death12 ] {


};

void () f_death12 = [ 29.000, f_death13 ] {


};

void () f_death13 = [ 30.000, f_death14 ] {


};

void () f_death14 = [ 31.000, f_death15 ] {


};

void () f_death15 = [ 32.000, f_death16 ] {


};

void () f_death16 = [ 33.000, f_death17 ] {


};

void () f_death17 = [ 34.000, f_death18 ] {


};

void () f_death18 = [ 35.000, f_death19 ] {


};

void () f_death19 = [ 36.000, f_death20 ] {


};

void () f_death20 = [ 37.000, f_death21 ] {


};

void () f_death21 = [ 38.000, f_death21 ] {


};

void () fish_die = {

   if ( (self.health < -20.000) ) {

      sound (self,CHAN_VOICE,"player/udeath.wav",TRUE,ATTN_NORM);
      ThrowGib ("progs/gib1.mdl",self.health);
      ThrowGib ("progs/gib2.mdl",self.health);
      ThrowGib ("progs/gib3.mdl",self.health);
      self.think = SUB_Remove;
      self.nextthink = (time + 0.100);
      return ;

   }
   f_death1 ();

};

void () f_pain1 = [ 57.000, f_pain2 ] {


};

void () f_pain2 = [ 58.000, f_pain3 ] {

   ai_pain (MOVETYPE_TOSS);

};

void () f_pain3 = [ 59.000, f_pain4 ] {

   ai_pain (MOVETYPE_TOSS);

};

void () f_pain4 = [ 60.000, f_pain5 ] {

   ai_pain (MOVETYPE_TOSS);

};

void () f_pain5 = [ 61.000, f_pain6 ] {

   ai_pain (MOVETYPE_TOSS);

};

void () f_pain6 = [ 62.000, f_pain7 ] {

   ai_pain (MOVETYPE_TOSS);

};

void () f_pain7 = [ 63.000, f_pain8 ] {

   ai_pain (MOVETYPE_TOSS);

};

void () f_pain8 = [ 64.000, f_pain9 ] {

   ai_pain (MOVETYPE_TOSS);

};

void () f_pain9 = [ 65.000, f_run1 ] {

   ai_pain (MOVETYPE_TOSS);

};

void (entity attacker, float damage) fish_pain = {

   f_pain1 ();

};

void () monster_fish = {

   if ( deathmatch ) {

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
   self.th_die = fish_die;
   self.th_pain = fish_pain;
   self.th_melee = f_attack1;
   swimmonster_start ();

};

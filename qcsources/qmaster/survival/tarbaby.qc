
void () tbaby_stand1 = [ 0.000, tbaby_stand1 ] {

   ai_stand ();

};

void () tbaby_hang1 = [ 0.000, tbaby_hang1 ] {

   ai_stand ();

};

void () tbaby_walk1 = [ 0.000, tbaby_walk2 ] {

   ai_turn ();

};

void () tbaby_walk2 = [ 1.000, tbaby_walk3 ] {

   ai_turn ();

};

void () tbaby_walk3 = [ 2.000, tbaby_walk4 ] {

   ai_turn ();

};

void () tbaby_walk4 = [ 3.000, tbaby_walk5 ] {

   ai_turn ();

};

void () tbaby_walk5 = [ 4.000, tbaby_walk6 ] {

   ai_turn ();

};

void () tbaby_walk6 = [ 5.000, tbaby_walk7 ] {

   ai_turn ();

};

void () tbaby_walk7 = [ 6.000, tbaby_walk8 ] {

   ai_turn ();

};

void () tbaby_walk8 = [ 7.000, tbaby_walk9 ] {

   ai_turn ();

};

void () tbaby_walk9 = [ 8.000, tbaby_walk10 ] {

   ai_turn ();

};

void () tbaby_walk10 = [ 9.000, tbaby_walk11 ] {

   ai_turn ();

};

void () tbaby_walk11 = [ 10.000, tbaby_walk12 ] {

   ai_walk (FL_SWIM);

};

void () tbaby_walk12 = [ 11.000, tbaby_walk13 ] {

   ai_walk (FL_SWIM);

};

void () tbaby_walk13 = [ 12.000, tbaby_walk14 ] {

   ai_walk (FL_SWIM);

};

void () tbaby_walk14 = [ 13.000, tbaby_walk15 ] {

   ai_walk (FL_SWIM);

};

void () tbaby_walk15 = [ 14.000, tbaby_walk16 ] {

   ai_walk (FL_SWIM);

};

void () tbaby_walk16 = [ 15.000, tbaby_walk17 ] {

   ai_walk (FL_SWIM);

};

void () tbaby_walk17 = [ 16.000, tbaby_walk18 ] {

   ai_walk (FL_SWIM);

};

void () tbaby_walk18 = [ 17.000, tbaby_walk19 ] {

   ai_walk (FL_SWIM);

};

void () tbaby_walk19 = [ 18.000, tbaby_walk20 ] {

   ai_walk (FL_SWIM);

};

void () tbaby_walk20 = [ 19.000, tbaby_walk21 ] {

   ai_walk (FL_SWIM);

};

void () tbaby_walk21 = [ 20.000, tbaby_walk22 ] {

   ai_walk (FL_SWIM);

};

void () tbaby_walk22 = [ 21.000, tbaby_walk23 ] {

   ai_walk (FL_SWIM);

};

void () tbaby_walk23 = [ 22.000, tbaby_walk24 ] {

   ai_walk (FL_SWIM);

};

void () tbaby_walk24 = [ 23.000, tbaby_walk25 ] {

   ai_walk (FL_SWIM);

};

void () tbaby_walk25 = [ 24.000, tbaby_walk1 ] {

   ai_walk (FL_SWIM);

};

void () tbaby_run1 = [ 25.000, tbaby_run2 ] {

   ai_face ();

};

void () tbaby_run2 = [ 26.000, tbaby_run3 ] {

   ai_face ();

};

void () tbaby_run3 = [ 27.000, tbaby_run4 ] {

   ai_face ();

};

void () tbaby_run4 = [ 28.000, tbaby_run5 ] {

   ai_face ();

};

void () tbaby_run5 = [ 29.000, tbaby_run6 ] {

   ai_face ();

};

void () tbaby_run6 = [ 30.000, tbaby_run7 ] {

   ai_face ();

};

void () tbaby_run7 = [ 31.000, tbaby_run8 ] {

   ai_face ();

};

void () tbaby_run8 = [ 32.000, tbaby_run9 ] {

   ai_face ();

};

void () tbaby_run9 = [ 33.000, tbaby_run10 ] {

   ai_face ();

};

void () tbaby_run10 = [ 34.000, tbaby_run11 ] {

   ai_face ();

};

void () tbaby_run11 = [ 35.000, tbaby_run12 ] {

   ai_run (FL_SWIM);

};

void () tbaby_run12 = [ 36.000, tbaby_run13 ] {

   ai_run (FL_SWIM);

};

void () tbaby_run13 = [ 37.000, tbaby_run14 ] {

   ai_run (FL_SWIM);

};

void () tbaby_run14 = [ 38.000, tbaby_run15 ] {

   ai_run (FL_SWIM);

};

void () tbaby_run15 = [ 39.000, tbaby_run16 ] {

   ai_run (FL_SWIM);

};

void () tbaby_run16 = [ 40.000, tbaby_run17 ] {

   ai_run (FL_SWIM);

};

void () tbaby_run17 = [ 41.000, tbaby_run18 ] {

   ai_run (FL_SWIM);

};

void () tbaby_run18 = [ 42.000, tbaby_run19 ] {

   ai_run (FL_SWIM);

};

void () tbaby_run19 = [ 43.000, tbaby_run20 ] {

   ai_run (FL_SWIM);

};

void () tbaby_run20 = [ 44.000, tbaby_run21 ] {

   ai_run (FL_SWIM);

};

void () tbaby_run21 = [ 45.000, tbaby_run22 ] {

   ai_run (FL_SWIM);

};

void () tbaby_run22 = [ 46.000, tbaby_run23 ] {

   ai_run (FL_SWIM);

};

void () tbaby_run23 = [ 47.000, tbaby_run24 ] {

   ai_run (FL_SWIM);

};

void () tbaby_run24 = [ 48.000, tbaby_run25 ] {

   ai_run (FL_SWIM);

};

void () tbaby_run25 = [ 49.000, tbaby_run1 ] {

   ai_run (FL_SWIM);

};

void () tbaby_jump1;

void () Tar_JumpTouch = {

   local float ldmg;

   if ( (other.takedamage && (other.classname != self.classname)) ) {

      if ( (vlen (self.velocity) > 400.000) ) {

         ldmg = (MOVETYPE_BOUNCE + (MOVETYPE_BOUNCE * random ()));
         T_Damage (other,self,self,ldmg);
         sound (self,CHAN_WEAPON,"blob/hit1.wav",TRUE,ATTN_NORM);

      }

   } else {

      sound (self,CHAN_WEAPON,"blob/land1.wav",TRUE,ATTN_NORM);

   }
   if ( !checkbottom (self) ) {

      if ( (self.flags & FL_ONGROUND) ) {

         self.touch = SUB_Null;
         self.think = tbaby_run1;
         self.movetype = MOVETYPE_STEP;
         self.nextthink = (time + 0.100);

      }
      return ;

   }
   self.touch = SUB_Null;
   self.think = tbaby_jump1;
   self.nextthink = (time + 0.100);

};

void () tbaby_jump5;

void () tbaby_fly1 = [ 56.000, tbaby_fly2 ] {


};

void () tbaby_fly2 = [ 57.000, tbaby_fly3 ] {


};

void () tbaby_fly3 = [ 58.000, tbaby_fly4 ] {


};

void () tbaby_fly4 = [ 59.000, tbaby_fly1 ] {

   self.cnt = (self.cnt + TRUE);
   if ( (self.cnt == MOVETYPE_STEP) ) {

      tbaby_jump5 ();

   }

};

void () tbaby_jump1 = [ 50.000, tbaby_jump2 ] {

   ai_face ();

};

void () tbaby_jump2 = [ 51.000, tbaby_jump3 ] {

   ai_face ();

};

void () tbaby_jump3 = [ 52.000, tbaby_jump4 ] {

   ai_face ();

};

void () tbaby_jump4 = [ 53.000, tbaby_jump5 ] {

   ai_face ();

};

void () tbaby_jump5 = [ 54.000, tbaby_jump6 ] {

   self.movetype = MOVETYPE_BOUNCE;
   self.touch = Tar_JumpTouch;
   makevectors (self.angles);
   self.origin_z = (self.origin_z + TRUE);
   self.velocity = ((v_forward * 600.000) + '0.000 0.000 200.000');
   self.velocity_z = (self.velocity_z + (random () * 150.000));
   if ( (self.flags & FL_ONGROUND) ) {

      self.flags = (self.flags - FL_ONGROUND);

   }
   self.cnt = FALSE;

};

void () tbaby_jump6 = [ 55.000, tbaby_fly1 ] {


};

void () tbaby_die1 = [ 60.000, tbaby_die2 ] {

   self.takedamage = DAMAGE_NO;

};

void () tbaby_die2 = [ 60.000, tbaby_run1 ] {

   T_RadiusDamage (self,self,120.000,world);
   sound (self,CHAN_VOICE,"blob/death1.wav",TRUE,ATTN_NORM);
   self.origin = (self.origin - (FL_CLIENT * normalize (self.velocity)));
   WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
   WriteByte (MSG_BROADCAST,TE_TAREXPLOSION);
   WriteCoord (MSG_BROADCAST,self.origin_x);
   WriteCoord (MSG_BROADCAST,self.origin_y);
   WriteCoord (MSG_BROADCAST,self.origin_z);
   BecomeExplosion ();

};

void () monster_tarbaby = {

   if ( deathmatch ) {

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
   self.pts = 250.000;
   self.th_stand = tbaby_stand1;
   self.th_walk = tbaby_walk1;
   self.th_run = tbaby_run1;
   self.th_missile = tbaby_jump1;
   self.th_melee = tbaby_jump1;
   self.th_die = tbaby_die1;
   walkmonster_start ();

};

void () monster_spawn = {

   monster_tarbaby ();

};
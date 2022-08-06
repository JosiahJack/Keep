
void () Demon_JumpTouch;

void () demon1_stand1 = [ 0.000, demon1_stand2 ] {

   if (!(self.classmonster) ) {

      ai_stand ();

   }

};

void () demon1_stand2 = [ 1.000, demon1_stand3 ] {

   if (!(self.classmonster) ) {

      ai_stand ();

   }

};

void () demon1_stand3 = [ 2.000, demon1_stand4 ] {

   if (!(self.classmonster) ) {

      ai_stand ();

   }

};

void () demon1_stand4 = [ 3.000, demon1_stand5 ] {

   if (!(self.classmonster) ) {

      ai_stand ();

   }

};

void () demon1_stand5 = [ 4.000, demon1_stand6 ] {

   if (!(self.classmonster) ) {

      ai_stand ();

   }

};

void () demon1_stand6 = [ 5.000, demon1_stand7 ] {

   if (!(self.classmonster) ) {

      ai_stand ();

   }

};

void () demon1_stand7 = [ 6.000, demon1_stand8 ] {

   if (!(self.classmonster) ) {

      ai_stand ();

   }

};

void () demon1_stand8 = [ 7.000, demon1_stand9 ] {

   if (!(self.classmonster) ) {

      ai_stand ();

   }

};

void () demon1_stand9 = [ 8.000, demon1_stand10 ] {

   if (!(self.classmonster) ) {

      ai_stand ();

   }

};

void () demon1_stand10 = [ 9.000, demon1_stand11 ] {

   if (!(self.classmonster) ) {

      ai_stand ();

   }

};

void () demon1_stand11 = [ 10.000, demon1_stand12 ] {

   if (!(self.classmonster) ) {

      ai_stand ();

   }

};

void () demon1_stand12 = [ 11.000, demon1_stand13 ] {

   if (!(self.classmonster) ) {

      ai_stand ();

   }

};

void () demon1_stand13 = [ 12.000, demon1_stand1 ] {

   if (!(self.classmonster) ) {

      ai_stand ();

   }

};

void () demon1_walk1 = [ 13.000, demon1_walk2 ] {

   if ( (random () < 0.200) ) {

      sound (self,CHAN_VOICE,"demon/idle1.wav",TRUE,ATTN_IDLE);

   }
   ai_walk (FL_CLIENT);

};

void () demon1_walk2 = [ 14.000, demon1_walk3 ] {

   ai_walk (MOVETYPE_TOSS);

};

void () demon1_walk3 = [ 15.000, demon1_walk4 ] {

   ai_walk (MOVETYPE_TOSS);

};

void () demon1_walk4 = [ 16.000, demon1_walk5 ] {

   ai_walk (MOVETYPE_PUSH);

};

void () demon1_walk5 = [ 17.000, demon1_walk6 ] {

   ai_walk (MOVETYPE_STEP);

};

void () demon1_walk6 = [ 18.000, demon1_walk7 ] {

   ai_walk (MOVETYPE_TOSS);

};

void () demon1_walk7 = [ 19.000, demon1_walk8 ] {

   ai_walk (MOVETYPE_BOUNCE);

};

void () demon1_walk8 = [ 20.000, demon1_walk1 ] {

   ai_walk (MOVETYPE_BOUNCE);

};

void () demon1_run1 = [ 21.000, demon1_run2 ] {

   if ( (random () < 0.200) ) {

      sound (self,CHAN_VOICE,"demon/idle1.wav",TRUE,ATTN_IDLE);

   }
   if (!(self.classmonster) ) {

      ai_run (20.000);

   }

};

void () demon1_run2 = [ 22.000, demon1_run3 ] {

   if (!(self.classmonster) ) {

      ai_run (15.000);

   }

};

void () demon1_run3 = [ 23.000, demon1_run4 ] {

   if (!(self.classmonster) ) {

      ai_run (36.000);

   }

};

void () demon1_run4 = [ 24.000, demon1_run5 ] {

   if (!(self.classmonster) ) {

      ai_run (20.000);

   }

};

void () demon1_run5 = [ 25.000, demon1_run6 ] {

   if (!(self.classmonster) ) {

      ai_run (15.000);

   }

};

void () demon1_run6 = [ 26.000, demon1_run1 ] {

   if (!(self.classmonster) ) {

      ai_run (36.000);

   }

};

void () demon1_jump1 = [ 27.000, demon1_jump2 ] {

   ai_face ();

};

void () demon1_jump2 = [ 28.000, demon1_jump3 ] {

   ai_face ();

};

void () demon1_jump3 = [ 29.000, demon1_jump4 ] {

   ai_face ();

};

void () demon1_jump4 = [ 30.000, demon1_jump5 ] {

   ai_face ();
   self.touch = Demon_JumpTouch;
   makevectors (self.angles);
   self.origin_z = (self.origin_z + TRUE);
   self.velocity = ((v_forward * 600.000) + '0.000 0.000 250.000');
   if ( (self.flags & FL_ONGROUND) ) {

      self.flags = (self.flags - FL_ONGROUND);

   }

};

void () demon1_jump5 = [ 31.000, demon1_jump6 ] {


};

void () demon1_jump6 = [ 32.000, demon1_jump7 ] {


};

void () demon1_jump7 = [ 33.000, demon1_jump8 ] {


};

void () demon1_jump8 = [ 34.000, demon1_jump9 ] {


};

void () demon1_jump9 = [ 35.000, demon1_jump10 ] {


};

void () demon1_jump10 = [ 36.000, demon1_jump1 ] {

   self.nextthink = (time + MOVETYPE_WALK);

};

void () demon1_jump11 = [ 37.000, demon1_jump12 ] {


};

void () demon1_jump12 = [ 38.000, demon1_run1 ] {


};

void () demon1_atta1 = [ 54.000, demon1_atta2 ] {

   if (!(self.classmonster) ) {

      ai_charge (MOVETYPE_STEP);

   }

};

void () demon1_atta2 = [ 55.000, demon1_atta3 ] {

   if (!(self.classmonster) ) {

      ai_charge (FALSE);

   }

};

void () demon1_atta3 = [ 56.000, demon1_atta4 ] {

   if (!(self.classmonster) ) {

      ai_charge (FALSE);

   }

};

void () demon1_atta4 = [ 57.000, demon1_atta5 ] {

   if (!(self.classmonster) ) {

      ai_charge (TRUE);

   }

};

void () demon1_atta5 = [ 58.000, demon1_atta6 ] {

   if (!(self.classmonster) ) {

      ai_charge (FL_SWIM);
      Demon_Melee (200.000);

   }

};

void () demon1_atta6 = [ 59.000, demon1_atta7 ] {

   if (!(self.classmonster) ) {

      ai_charge (TRUE);

   }

};

void () demon1_atta7 = [ 60.000, demon1_atta8 ] {

   if (!(self.classmonster) ) {

      ai_charge (MOVETYPE_TOSS);

   }

};

void () demon1_atta8 = [ 61.000, demon1_atta9 ] {

   if (!(self.classmonster) ) {

      ai_charge (FL_CLIENT);

   }

};

void () demon1_atta9 = [ 62.000, demon1_atta10 ] {

   if (!(self.classmonster) ) {

      ai_charge (MOVETYPE_STEP);

   }

};

void () demon1_atta10 = [ 63.000, demon1_atta11 ] {

   if (!(self.classmonster) ) {

      ai_charge (FL_SWIM);

   }

};

void () demon1_atta11 = [ 64.000, demon1_atta12 ] {

   if (!(self.classmonster) ) {

      Demon_Melee (-200.000);

   }

};

void () demon1_atta12 = [ 65.000, demon1_atta13 ] {

   if (!(self.classmonster) ) {

      ai_charge (MOVETYPE_FLY);

   }

};

void () demon1_atta13 = [ 66.000, demon1_atta14 ] {

   if (!(self.classmonster) ) {

      ai_charge (FL_CLIENT);

   }

};

void () demon1_atta14 = [ 67.000, demon1_atta15 ] {

   if (!(self.classmonster) ) {

      ai_charge (MOVETYPE_STEP);

   }

};

void () demon1_atta15 = [ 68.000, demon1_run1 ] {

   if (!(self.classmonster) ) {

      ai_charge (MOVETYPE_STEP);

   }

};

void () demon1_pain1 = [ 39.000, demon1_pain2 ] {


};

void () demon1_pain2 = [ 40.000, demon1_pain3 ] {


};

void () demon1_pain3 = [ 41.000, demon1_pain4 ] {


};

void () demon1_pain4 = [ 42.000, demon1_pain5 ] {


};

void () demon1_pain5 = [ 43.000, demon1_pain6 ] {


};

void () demon1_pain6 = [ 44.000, demon1_run1 ] {


};

void (entity attacker, float damage) demon1_pain = {

   if ( (self.touch == Demon_JumpTouch) ) {

      return ;

   }
   if ( (self.pain_finished > time) ) {

      return ;

   }
   self.pain_finished = (time + TRUE);
   sound (self,CHAN_VOICE,"demon/dpain1.wav",TRUE,ATTN_NORM);
   if ( ((random () * 200.000) > damage) ) {

      return ;

   }
   demon1_pain1 ();

};

void () demon1_die1 = [ 45.000, demon1_die2 ] {

   sound (self,CHAN_VOICE,"demon/ddeath.wav",TRUE,ATTN_NORM);

};

void () demon1_die2 = [ 46.000, demon1_die3 ] {


};

void () demon1_die3 = [ 47.000, demon1_die4 ] {


};

void () demon1_die4 = [ 48.000, demon1_die5 ] {


};

void () demon1_die5 = [ 49.000, demon1_die6 ] {


};

void () demon1_die6 = [ 50.000, demon1_die7 ] {

   self.solid = SOLID_NOT;

};

void () demon1_die7 = [ 51.000, demon1_die8 ] {


};

void () demon1_die8 = [ 52.000, demon1_die9 ] {


};

void () demon1_die9 = [ 53.000, demon1_die9 ] {

   self.think = body_kill;
   self.nextthink = (time + 60.000);

};

void () demon_die = {

   if ( (self.health < -80.000) ) {

      sound (self,CHAN_VOICE,"player/udeath.wav",TRUE,ATTN_NORM);
      ThrowHead ("progs/h_demon.mdl",self.health);
      ThrowGib ("progs/gib1.mdl",self.health);
      ThrowGib ("progs/gib1.mdl",self.health);
      ThrowGib ("progs/gib1.mdl",self.health);
      return ;

   }
   demon1_die1 ();

};

void () Demon_MeleeAttack = {

   demon1_atta1 ();

};

void () monster_demon1 = {

   if ( deathmatch ) {

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
float () CheckDemonMelee = {

   if ( (enemy_range == RANGE_MELEE) ) {

      self.attack_state = AS_MELEE;
      return ( TRUE );

   }
   return ( FALSE );

};
float () CheckDemonJump = {

   local vector dist;
   local float d;

   if ( ((self.origin_z + self.mins_z) > ((self.enemy.origin_z + self.enemy.mins_z) + (0.750 * self.enemy.size_z))) ) {

      return ( FALSE );

   }
   if ( ((self.origin_z + self.maxs_z) < ((self.enemy.origin_z + self.enemy.mins_z) + (0.250 * self.enemy.size_z))) ) {

      return ( FALSE );

   }
   dist = (self.enemy.origin - self.origin);
   dist_z = FALSE;
   d = vlen (dist);
   if ( (d < 100.000) ) {

      return ( FALSE );

   }
   if ( (d > 200.000) ) {

      if ( (random () < 0.900) ) {

         return ( FALSE );

      }

   }
   return ( TRUE );

};
float () DemonCheckAttack = {

   if ( CheckDemonMelee () ) {

      self.attack_state = AS_MELEE;
      return ( TRUE );

   }
   if ( CheckDemonJump () ) {

      self.attack_state = AS_MISSILE;
      sound (self,CHAN_VOICE,"demon/djump.wav",TRUE,ATTN_NORM);
      return ( TRUE );

   }
   return ( FALSE );

};

void (float side) Demon_Melee = {

   local float ldmg;
   local vector delta;

   if (!(self.classmonster) ) {

      ai_face ();
      walkmove (self.ideal_yaw,12.000);
      delta = (self.enemy.origin - self.origin);
      if ( (vlen (delta) > 100.000) ) {

         return ;

      }

   }
   if ( !CanDamage (self.enemy,self) ) {

      return ;

   }
   sound (self,CHAN_WEAPON,"demon/dhit2.wav",TRUE,ATTN_NORM);
   ldmg = (MOVETYPE_BOUNCE + (MOVETYPE_FLY * random ()));
   T_Damage (self.enemy,self,self,ldmg);
   makevectors (self.angles);
   SpawnMeatSpray ((self.origin + (v_forward * FL_INWATER)),(side * v_right));

};

void () Demon_JumpTouch = {

   local float ldmg;

   if ( (self.health <= FALSE) ) {

      return ;

   }
   if ( other.takedamage ) {

      if ( (vlen (self.velocity) > 400.000) ) {

         ldmg = (40.000 + (MOVETYPE_BOUNCE * random ()));
         T_Damage (other,self,self,ldmg);

      }

   }
   if ( !checkbottom (self) ) {

      if ( (self.flags & FL_ONGROUND) ) {

         self.touch = SUB_Null;
         self.think = demon1_jump1;
         self.nextthink = (time + 0.100);

      }
      return ;

   }
   self.touch = SUB_Null;
   self.think = demon1_jump11;
   self.nextthink = (time + 0.100);

};


void () player_run;
void () bubble_bob;

void () player_stand1 = [ 17.000, player_stand1 ] {

   if ( (self.velocity_x || self.velocity_y) ) {

      self.walkframe = FALSE;
      player_run ();
      return ;

   }
   if ( (self.walkframe >= MOVETYPE_FLY) ) {

      self.walkframe = FALSE;

   }
   self.frame = (12.000 + self.walkframe);
   self.walkframe = (self.walkframe + TRUE);

};
void () player_run = [ 6.000, player_run ] {

   if ( (!self.velocity_x && !self.velocity_y) ) {

      self.walkframe = FALSE;
      player_stand1 ();
      return ;

   }
   if ( (self.walkframe == MOVETYPE_TOSS) ) {

      self.walkframe = FALSE;

   }
   self.frame = (self.frame + self.walkframe);
   self.walkframe = (self.walkframe + TRUE);

};

void (float num_bubbles) DeathBubbles;

void () PainSound = {

   local float rs;
   local float rand1;

   if ( (self.health < FALSE) ) {

      return ;

   }
   if ( (damage_attacker.classname == "teledeath") ) {

      sound (self,CHAN_VOICE,"player/teledth1.wav",TRUE,ATTN_NONE);
      return ;

   }
   if ( ((self.watertype == CONTENT_WATER) && (self.waterlevel == MOVETYPE_WALK)) ) {

      DeathBubbles (TRUE);
      if ( (random () > 0.500) ) {

         sound (self,CHAN_VOICE,"player/drown1.wav",TRUE,ATTN_NORM);

      } else {

         sound (self,CHAN_VOICE,"player/drown2.wav",TRUE,ATTN_NORM);

      }
      return ;

   }
   if ( (self.watertype == CONTENT_SLIME) ) {

      if ( (random () > 0.500) ) {

         sound (self,CHAN_VOICE,"player/pain1.wav",TRUE,ATTN_NORM);

      } else {

         sound (self,CHAN_VOICE,"player/pain4.wav",TRUE,ATTN_NORM);

      }
      return ;

   }
   if ( (self.watertype == CONTENT_LAVA) ) {

   rand1 = random();

      if ( (rand1 < 0.333 ) ) {

         sound (self,CHAN_VOICE,"player/pain2.wav",TRUE,ATTN_NORM);

      } else {

         if ( (rand1 > 0.333) + (rand1 < 0.666) ) {

            sound (self,CHAN_VOICE,"player/pain3.wav",TRUE,ATTN_NORM);

         } else {

            if ( (rand1 > 0.666) ) {

               sound (self,CHAN_VOICE,"player/pain5.wav",TRUE,ATTN_NORM);

            }

         }

      }
      return ;

   }
   if ( (self.pain_finished > time) ) {

      return ;

   }
   self.pain_finished = (time + 0.500);
   rs = rint (((random () * MOVETYPE_FLY) + TRUE));
   self.noise = "";
   if ( (rs == TRUE) ) {

      self.noise = "player/pain1.wav";

   } else {

      if ( (rs == FL_SWIM) ) {

         self.noise = "player/pain2.wav";

      } else {

         if ( (rs == MOVETYPE_WALK) ) {

            self.noise = "player/pain3.wav";

         } else {

            if ( (rs == MOVETYPE_STEP) ) {

               self.noise = "player/pain4.wav";

            } else {

               if ( (rs == MOVETYPE_FLY) ) {

                  self.noise = "player/pain5.wav";

               } else {

                  self.noise = "player/pain6.wav";

               }

            }

         }

      }

   }
   sound (self,CHAN_VOICE,self.noise,TRUE,ATTN_NORM);
   return ;

};

void () player_pain1 = [ 35.000, player_pain2 ] {
   PainSound ();
};
void () player_pain2 = [ 36.000, player_pain3 ] {};
void () player_pain3 = [ 37.000, player_pain4 ] {};
void () player_pain4 = [ 38.000, player_pain5 ] {};
void () player_pain5 = [ 39.000, player_pain6 ] {};
void () player_pain6 = [ 40.000, player_run ] {};

void () player_pain = {

   player_pain1 ();

};

void () player_diea1;
void () player_dieb1;
void () player_diec1;
void () player_died1;
void () player_diee1;

void () DeathBubblesSpawn = {

   local entity bubble;

   if ( (self.owner.waterlevel != MOVETYPE_WALK) ) {

      return ;

   }
   bubble = spawn ();
   setmodel (bubble,"progs/s_bubble.spr");
   setorigin (bubble,(self.owner.origin + '0.000 0.000 24.000'));
   bubble.movetype = MOVETYPE_NOCLIP;
   bubble.solid = SOLID_NOT;
   bubble.velocity = '0.000 0.000 15.000';
   bubble.nextthink = (time + 0.500);
   bubble.think = bubble_bob;
   bubble.classname = "bubble";
   bubble.frame = FALSE;
   bubble.cnt = FALSE;
   setsize (bubble,'-8.000 -8.000 -8.000','8.000 8.000 8.000');
   self.nextthink = (time + 0.100);
   self.think = DeathBubblesSpawn;
   self.air_finished = (self.air_finished + TRUE);
   if ( (self.air_finished >= self.bubble_count) ) {

      remove (self);

   }

};

void (float num_bubbles) DeathBubbles = {

   local entity bubble_spawner;

   bubble_spawner = spawn ();
   setorigin (bubble_spawner,self.origin);
   bubble_spawner.movetype = MOVETYPE_NONE;
   bubble_spawner.solid = SOLID_NOT;
   bubble_spawner.nextthink = (time + 0.100);
   bubble_spawner.think = DeathBubblesSpawn;
   bubble_spawner.air_finished = FALSE;
   bubble_spawner.owner = self;
   bubble_spawner.bubble_count = num_bubbles;
   return ;

};

void () DeathSound = {

   local float rs;

   if ( (self.waterlevel == MOVETYPE_WALK) ) {

      DeathBubbles (20.000);
      sound (self,CHAN_VOICE,"fish/death.wav",TRUE,ATTN_NONE);
      return ;

   }
   rs = rint (((random () * MOVETYPE_STEP) + TRUE));
   if ( (rs == TRUE) ) {

      self.noise = "player/death1.wav";

   }
   if ( (rs == FL_SWIM) ) {

      self.noise = "player/death2.wav";

   }
   if ( (rs == MOVETYPE_WALK) ) {

      self.noise = "player/death3.wav";

   }
   if ( (rs == MOVETYPE_STEP) ) {

      self.noise = "player/death4.wav";

   }
   if ( (rs == MOVETYPE_FLY) ) {

      self.noise = "player/death3.wav";

   }
   sound (self,CHAN_VOICE,self.noise,TRUE,ATTN_NONE);
   return ;

};

void () PlayerDead = {

   self.nextthink = CONTENT_EMPTY;
   self.deadflag = DEAD_DEAD;

};
vector (float dm) VelocityForDamage = {

   local vector v;

   v_x = (100.000 * crandom ());
   v_y = (100.000 * crandom ());
   v_z = (200.000 + (100.000 * random ()));
   if ( (dm > -50.000) ) {

      v = (v * 0.700);

   } else {

      if ( (dm > -200.000) ) {

         v = (v * FL_SWIM);

      } else {

         v = (v * MOVETYPE_BOUNCE);

      }

   }
   return ( v );

};

void () GibPlayer = {

   self.deadflag = DEAD_DEAD;
   if ( (damage_attacker.classname == "teledeath") ) {

      sound (self,CHAN_VOICE,"misc/power.wav",TRUE,ATTN_NONE);
      return ;

   }
   if ( (damage_attacker.classname == "teledeath2") ) {

      sound (self,CHAN_VOICE,"misc/power.wav",TRUE,ATTN_NONE);
      return ;

   }
   if ( (random () < 0.500) ) {

      sound (self,CHAN_VOICE,"player/death4.wav",TRUE,ATTN_NONE);

   } else {

      sound (self,CHAN_VOICE,"player/death2.wav",TRUE,ATTN_NONE);

   }

};

void () PlayerDie = {

   local float i;

   self.invincible_finished = FALSE;
   self.super_damage_finished = FALSE;
   self.radsuit_finished = FALSE;
   self.therm_finished = FALSE;
   self.wetsuit_finished = FALSE;
   self.antigrav_finished = FALSE;
   self.shield_finished = FALSE;
   self.empathy_finished = FALSE;
   self.modelindex = modelindex_player;
   self.view_ofs = '0.000 0.000 -8.000';
   self.deadflag = DEAD_DYING;
   self.solid = SOLID_NOT;
   self.flags = (self.flags - (self.flags & FL_ONGROUND));
   self.movetype = MOVETYPE_TOSS;
   if ( (self.velocity_z < MOVETYPE_BOUNCE) ) {

      self.velocity_z = (self.velocity_z + (random () * 300.000));

   }
   if ( (self.health < -40.000) ) {

      GibPlayer ();
      return ;

   }
   DeathSound ();
   self.angles_x = FALSE;
   self.angles_z = FALSE;
   i = cvar ("temp1");
   if ( !i ) {

      i = (TRUE + floor ((random () * MOVETYPE_TOSS)));

   }
   if ( (i == TRUE) ) {

      player_diea1 ();

   } else {

      if ( (i == FL_SWIM) ) {

         player_dieb1 ();

      } else {

         if ( (i == MOVETYPE_WALK) ) {

            player_diec1 ();

         } else {

            if ( (i == MOVETYPE_STEP) ) {

               player_died1 ();

            } else {

               player_diee1 ();

            }

         }

      }

   }

};

void () set_suicide_frame = {

   if ( (self.model != "progs/player.mdl") ) {

      return ;

   }
   self.frame = 60.000;
   self.solid = SOLID_NOT;
   self.movetype = MOVETYPE_TOSS;
   self.deadflag = DEAD_DEAD;
   self.nextthink = CONTENT_EMPTY;

};

void () player_diea1 = [ 50.000, player_diea2 ] {};
void () player_diea2 = [ 51.000, player_diea3 ] {};
void () player_diea3 = [ 52.000, player_diea4 ] {};
void () player_diea4 = [ 53.000, player_diea5 ] {};
void () player_diea5 = [ 54.000, player_diea6 ] {};
void () player_diea6 = [ 55.000, player_diea7 ] {};
void () player_diea7 = [ 56.000, player_diea8 ] {};
void () player_diea8 = [ 57.000, player_diea9 ] {};
void () player_diea9 = [ 58.000, player_diea10 ] {};
void () player_diea10 = [ 59.000, player_diea11 ] {};
void () player_diea11 = [ 60.000, player_diea11 ] {
   PlayerDead ();
};

void () player_dieb1 = [ 61.000, player_dieb2 ] {};
void () player_dieb2 = [ 62.000, player_dieb3 ] {};
void () player_dieb3 = [ 63.000, player_dieb4 ] {};
void () player_dieb4 = [ 64.000, player_dieb5 ] {};
void () player_dieb5 = [ 65.000, player_dieb6 ] {};
void () player_dieb6 = [ 66.000, player_dieb7 ] {};
void () player_dieb7 = [ 67.000, player_dieb8 ] {};
void () player_dieb8 = [ 68.000, player_dieb9 ] {};
void () player_dieb9 = [ 69.000, player_dieb9 ] {
   PlayerDead ();
};

void () player_diec1 = [ 70.000, player_diec2 ] {};
void () player_diec2 = [ 71.000, player_diec3 ] {};
void () player_diec3 = [ 72.000, player_diec4 ] {};
void () player_diec4 = [ 73.000, player_diec5 ] {};
void () player_diec5 = [ 74.000, player_diec6 ] {};
void () player_diec6 = [ 75.000, player_diec7 ] {};
void () player_diec7 = [ 76.000, player_diec8 ] {};
void () player_diec8 = [ 77.000, player_diec9 ] {};
void () player_diec9 = [ 78.000, player_diec10 ] {};
void () player_diec10 = [ 79.000, player_diec11 ] {};
void () player_diec11 = [ 80.000, player_diec12 ] {};
void () player_diec12 = [ 81.000, player_diec13 ] {};
void () player_diec13 = [ 82.000, player_diec14 ] {};
void () player_diec14 = [ 83.000, player_diec15 ] {};
void () player_diec15 = [ 84.000, player_diec15 ] {
   PlayerDead ();
};

void () player_died1 = [ 85.000, player_died2 ] {};
void () player_died2 = [ 86.000, player_died3 ] {};
void () player_died3 = [ 87.000, player_died4 ] {};
void () player_died4 = [ 88.000, player_died5 ] {};
void () player_died5 = [ 89.000, player_died6 ] {};
void () player_died6 = [ 90.000, player_died7 ] {};
void () player_died7 = [ 91.000, player_died8 ] {};
void () player_died8 = [ 92.000, player_died9 ] {};
void () player_died9 = [ 93.000, player_died9 ] {
   PlayerDead ();
};

void () player_diee1 = [ 94.000, player_diee2 ] {};
void () player_diee2 = [ 95.000, player_diee3 ] {};
void () player_diee3 = [ 96.000, player_diee4 ] {};
void () player_diee4 = [ 97.000, player_diee5 ] {};
void () player_diee5 = [ 98.000, player_diee6 ] {};
void () player_diee6 = [ 99.000, player_diee7 ] {};
void () player_diee7 = [ 100.000, player_diee8 ] {};
void () player_diee8 = [ 101.000, player_diee9 ] {};
void () player_diee9 = [ 102.000, player_diee9 ] {
   PlayerDead ();
};
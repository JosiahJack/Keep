float SCORPION_YELLOW   =  0.00000;
float SCORPION_BLACK   =  1.00000;
void  (float type)ScorpionInit;
void  ()ScorpionStand;
void  ()ScorpionWake;
void  ()ScorpionWalk;
void  ()ScorpionRun;
void  ()ScorpionRunBlack;
void  ()ScorpionPainDecide;
void  ()ScorpionPain;
void  ()ScorpionMeleeDecide;
void  ()ScorpionMelee1;
void  ()ScorpionMelee2;
void  ()ScorpionMelee3;
void  ()ScorpionMelee4;
void  ()ScorpionDie;
void  ()ScorpionDieInit;
entity  ()ScorpionLookProjectiles;
float  ()ScorpionCheckDefense;
void  ()ScorpionStrafeDefense;
float ScorpionStandFrames [6]   = { 129.00000,
    130.00000,    131.00000,    132.00000,    131.00000,
    130.00000};

void  ()monster_scorpion_yellow =  {
   ScorpionInit ( SCORPION_YELLOW);
};


void  ()monster_scorpion_black =  {
   ScorpionInit ( SCORPION_BLACK);
};


void  (float type)ScorpionInit =  {
   if ( deathmatch ) {

      remove ( self);
      return ;

   }
   if ( !((self.flags2 & FL_SUMMONED)) ) {

      precache_model2 ( "models/scorpion.mdl");
      precache_sound2 ( "scorpion/awaken.wav");
      precache_sound2 ( "scorpion/walk.wav");
      precache_sound2 ( "scorpion/clawsnap.wav");
      precache_sound2 ( "scorpion/tailwhip.wav");
      precache_sound2 ( "scorpion/pain.wav");
      precache_sound2 ( "scorpion/death.wav");

   }
   setmodel ( self, "models/scorpion.mdl");
   self.solid = SOLID_SLIDEBOX;
   self.movetype = MOVETYPE_STEP;
   self.thingtype = THINGTYPE_FLESH;
   if ( (type == SCORPION_YELLOW) ) {

      self.yaw_speed = 8.00000;
   } else {

      self.yaw_speed = 10.00000;

   }
   self.mass = 9.00000;
   self.mintel = 4.00000;
   setsize ( self, '-16.00000 -16.00000 0.00000', '16.00000 16.00000 64.00000');
   if ( (type == SCORPION_YELLOW) ) {

      self.health = 100.00000;
      self.experience_value = 60.00000;
   } else {

      self.health = 200.00000;
      self.experience_value = 150.00000;

   }
   self.takedamage = DAMAGE_YES;
   self.th_stand = ScorpionStand;
   self.th_walk = ScorpionWalk;
   if ( (type == SCORPION_BLACK) ) {

      self.th_run = ScorpionRunBlack;
   } else {

      self.th_run = ScorpionRun;

   }
   self.th_melee = ScorpionMeleeDecide;
   self.th_pain = ScorpionPainDecide;
   self.th_die = ScorpionDieInit;
   self.view_ofs = '0.00000 0.00000 12.00000';
   self.scorpionType = type;
   if ( (type == SCORPION_BLACK) ) {

      self.skin = 1.00000;

   }
   walkmonster_start ( );
};


void  ()ScorpionStand =  {
   self.think = ScorpionStand;
   self.nextthink = (time + 0.20000);
   self.scorpionRest += 2.00000;
   if ( ((self.scorpionRest < 0.00000) || (self.scorpionRest > 5.00000)) ) {

      self.scorpionRest = 0.00000;

   }
   self.frame = (ScorpionStandFrames->self.scorpionRest);
   ai_stand ( );
   if ( (self.think != ScorpionStand) ) {

      self.th_save = self.think;
      self.think = ScorpionWake;
      sound ( self, CHAN_VOICE, "scorpion/awaken.wav", 1.00000, ATTN_NORM);

   }
};


void  ()ScorpionWake =  {
   AdvanceFrame( 129.00000, 158.00000);
   if ( cycle_wrapped ) {

      self.cnt = time;
      self.think = self.th_save;
      self.think ( );

   }
};


void  ()ScorpionWalk =  {
   AdvanceFrame( 159.00000, 174.00000);
   self.scorpionWalkCount += 1.00000;
   if ( ((self.scorpionWalkCount & 3.00000) == 0.00000) ) {

      sound ( self, CHAN_BODY, "scorpion/walk.wav", random(0.90000,1.00000), ATTN_NORM);

   }
   ai_walk ( 2.00000);
   if ( (random() < 0.10000) ) {

      pitch_roll_for_slope ( '0.00000 0.00000 0.00000');

   }
};


void  ()ScorpionRunBlack =  {
local float enemy_dist = 0.00000;
   AdvanceFrame( 159.00000, 174.00000);
   self.scorpionWalkCount += 1.00000;
   if ( ((self.scorpionWalkCount & 3.00000) == 0.00000) ) {

      sound ( self, CHAN_BODY, "scorpion/walk.wav", random(0.90000,1.00000), ATTN_NORM);

   }
   if ( ((self.enemy.last_attack > (time - 1.00000)) && fov ( self, self.enemy, 45.00000)) ) {

      if ( ScorpionCheckDefense ( ) ) {

         ScorpionStrafeDefense ( );
         return ;

      }

   }
   if ( (self.attack_state == AS_SLIDING) ) {

      if ( ((random() < 0.80000) && (self.cnt <= time)) ) {

         self.cnt = (time + random(0.50000,1.00000));
         self.attack_state = AS_STRAIGHT;
         ScorpionMelee4 ( );
         return ;

      }

   }
   enemy_dist = vlen ( (self.enemy.origin - self.origin));
   if ( (enemy_dist < 120.00000) ) {

      if ( (((random() < 0.33000) && infront ( self.enemy)) && (self.cnt <= time)) ) {

         self.attack_state = AS_SLIDING;
         self.cnt = (time + random(0.50000,1.00000));
         self.lefty = random(0.00000,1.00000);
         if ( (self.lefty < 0.50000) ) {

            self.lefty = 0.00000;
         } else {

            self.lefty = 1.00000;

         }
         ai_run ( 10.00000);
         return ;
      } else {

         if ( !infront ( self.enemy) ) {

            self.attack_state = AS_STRAIGHT;

         }

      }
   } else {

      self.attack_state = AS_STRAIGHT;

   }
   ai_run ( 8.00000);
   if ( (random() < 0.10000) ) {

      pitch_roll_for_slope ( '0.00000 0.00000 0.00000');

   }
};


void  ()ScorpionRun =  {
local float enemy_dist = 0.00000;
   AdvanceFrame( 159.00000, 174.00000);
   self.scorpionWalkCount += 1.00000;
   if ( ((self.scorpionWalkCount & 3.00000) == 0.00000) ) {

      sound ( self, CHAN_BODY, "scorpion/walk.wav", random(0.90000,1.00000), ATTN_NORM);

   }
   if ( ((self.enemy.last_attack > (time - 1.00000)) && fov ( self, self.enemy, 45.00000)) ) {

      if ( ScorpionCheckDefense ( ) ) {

         ScorpionStrafeDefense ( );
         return ;

      }

   }
   if ( (self.attack_state == AS_SLIDING) ) {

      if ( ((random() < 0.50000) && (self.cnt <= time)) ) {

         self.cnt = (time + random(0.50000,1.00000));
         self.attack_state = AS_STRAIGHT;
         ScorpionMelee4 ( );
         return ;

      }

   }
   enemy_dist = vlen ( (self.enemy.origin - self.origin));
   if ( (enemy_dist < 120.00000) ) {

      if ( (((random() < 0.33000) && infront ( self.enemy)) && (self.cnt <= time)) ) {

         self.attack_state = AS_SLIDING;
         self.cnt = (time + random(0.50000,1.00000));
         self.lefty = random(0.00000,1.00000);
         if ( (self.lefty < 0.50000) ) {

            self.lefty = 0.00000;
         } else {

            self.lefty = 1.00000;

         }
         ai_run ( 10.00000);
         return ;
      } else {

         if ( !infront ( self.enemy) ) {

            self.attack_state = AS_STRAIGHT;

         }

      }
   } else {

      self.attack_state = AS_STRAIGHT;

   }
   ai_run ( 6.00000);
   if ( (random() < 0.10000) ) {

      pitch_roll_for_slope ( '0.00000 0.00000 0.00000');

   }
};


void  ()ScorpionPainDecide =  {
   if ( (random() < 0.30000) ) {

      ScorpionPain ( );
      sound ( self, CHAN_VOICE, "scorpion/pain.wav", 1.00000, ATTN_NORM);

   }
};


void  ()ScorpionPain =  {
   AdvanceFrame( 95.00000, 104.00000);
   if ( cycle_wrapped ) {

      self.th_run ( );

   }
};


void  (float damage)ScorpionMelee =  {
local vector source = '0.00000 0.00000 0.00000';
   makevectors ( self.angles);
   source = self.origin;
   traceline ( source, (source + (v_forward * 60.00000)), FALSE, self);
   if ( (trace_ent != self.enemy) ) {

      return ;

   }
   damage += random(0.10000,1.00000);
   T_Damage ( self.enemy, self, self, damage);
};


void  ()ScorpionMeleeDecide =  {
local float r = 0.00000;
   r = random();
   self.last_attack = time;
   if ( (self.classname == "monster_scorpion_black") ) {

      if ( (r < 0.20000) ) {

         ScorpionMelee1 ( );
      } else {

         if ( (r < 0.40000) ) {

            ScorpionMelee2 ( );
         } else {

            if ( (r < 0.60000) ) {

               ScorpionMelee3 ( );
            } else {

               ScorpionMelee4 ( );

            }

         }

      }
   } else {

      if ( (r < 0.30000) ) {

         ScorpionMelee1 ( );
      } else {

         if ( (r < 0.60000) ) {

            ScorpionMelee2 ( );
         } else {

            if ( (r < 0.90000) ) {

               ScorpionMelee3 ( );
            } else {

               ScorpionMelee4 ( );

            }

         }

      }

   }
};


void  ()ScorpionMelee1 =  {
   AdvanceFrame( 0.00000, 24.00000);
   if ( ((self.frame == 3.00000) || (self.frame == 8.00000)) ) {

      sound ( self, CHAN_VOICE, "scorpion/clawsnap.wav", 1.00000, ATTN_NORM);
      ScorpionMelee ( 1.00000);
   } else {

      if ( (self.frame == 13.00000) ) {

         sound ( self, CHAN_BODY, "scorpion/tailwhip.wav", 1.00000, ATTN_NORM);
         ScorpionMelee ( 1.00000);

      }

   }
   if ( ((self.frame > 15.00000) && (self.frame < 19.00000)) ) {

      ai_charge ( 4.00000);
      if ( (self.classname == "monster_scorpion_yellow") ) {

         ScorpionMelee ( 2.00000);
      } else {

         ScorpionMelee ( 3.00000);

      }
   } else {

      ai_charge ( 2.00000);

   }
   if ( cycle_wrapped ) {

      self.think = self.th_run;

   }
};


void  ()ScorpionMelee2 =  {
   AdvanceFrame( 25.00000, 51.00000);
   if ( (((self.frame == 28.00000) || (self.frame == 32.00000)) || (self.frame == 37.00000)) ) {

      sound ( self, CHAN_VOICE, "scorpion/clawsnap.wav", 1.00000, ATTN_NORM);
      ScorpionMelee ( 1.00000);

   }
   if ( ((self.frame > 40.00000) && (self.frame < 44.00000)) ) {

      ai_charge ( 4.00000);
      if ( (self.classname == "monster_scorpion_yellow") ) {

         ScorpionMelee ( 2.00000);
      } else {

         ScorpionMelee ( 3.00000);

      }
   } else {

      ai_charge ( 2.00000);

   }
   if ( cycle_wrapped ) {

      self.think = self.th_run;

   }
};


void  ()ScorpionMelee3 =  {
   AdvanceFrame( 52.00000, 73.00000);
   if ( (self.frame == 60.00000) ) {

      sound ( self, CHAN_BODY, "scorpion/tailwhip.wav", 1.00000, ATTN_NORM);
      ScorpionMelee ( 1.00000);

   }
   if ( ((self.frame > 67.00000) && (self.frame < 71.00000)) ) {

      ai_charge ( 4.00000);
      if ( (self.classname == "monster_scorpion_yellow") ) {

         ScorpionMelee ( 2.00000);
      } else {

         ScorpionMelee ( 3.00000);

      }
   } else {

      ai_charge ( 2.00000);

   }
   if ( cycle_wrapped ) {

      self.think = self.th_run;

   }
};


void  ()ScorpionMelee4 =  {
   AdvanceFrame( 0.00000, 24.00000);
   if ( ((self.frame == 3.00000) || (self.frame == 8.00000)) ) {

      sound ( self, CHAN_VOICE, "scorpion/clawsnap.wav", 1.00000, ATTN_NORM);
      ScorpionMelee ( 1.00000);
   } else {

      if ( (self.frame == 13.00000) ) {

         sound ( self, CHAN_BODY, "scorpion/tailwhip.wav", 1.00000, ATTN_NORM);
         if ( (self.classname == "monster_scorpion_yellow") ) {

            ScorpionMelee ( 2.00000);
         } else {

            ScorpionMelee ( 3.00000);

         }

      }

   }
   if ( ((self.frame > 15.00000) && (self.frame < 19.00000)) ) {

      ai_charge ( 16.00000);
      if ( (self.classname == "monster_scorpion_yellow") ) {

         ScorpionMelee ( 2.00000);
      } else {

         ScorpionMelee ( 4.00000);

      }
   } else {

      ai_charge ( 12.00000);

   }
   if ( cycle_wrapped ) {

      self.think = self.th_run;

   }
};


void  ()ScorpionStrafeDefense =  {
local float ofs = 0.00000;
   AdvanceFrame( 159.00000, 166.00000);
   if ( cycle_wrapped ) {

      AdvanceThinkTime(self,0.10000);
      self.think = self.th_run;
      return ;

   }
   makevectors ( self.v_angle);
   if ( (self.lefty == -1.00000) ) {

      ofs = 90.00000;
   } else {

      ofs = -90.00000;

   }
   if ( walkmove ( (self.ideal_yaw + ofs), 10.00000, FALSE) ) {

      return ;

   }
   walkmove ( (self.ideal_yaw - ofs), 10.00000, FALSE);
   if ( (self.lefty == -1.00000) ) {

      self.lefty = 1.00000;
   } else {

      self.lefty = -1.00000;

   }
};


float  ()ScorpionCheckDefense =  {
local entity enemy_proj;
local float r = 0.00000;
   enemy_proj = ScorpionLookProjectiles ( );
   if ( !enemy_proj ) {

      return ( 0.00000 );

   }
   r = range ( enemy_proj);
   self.lefty = check_heading_left_or_right ( enemy_proj);
   if ( (r == RANGE_NEAR) ) {

      if ( (random() < 0.20000) ) {

         return ( 1.00000 );

      }

   }
   return ( 0.00000 );
};


entity  ()ScorpionLookProjectiles =  {
local entity found;
local entity enemy_proj;
   found = findradius ( self.origin, 1000.00000);
   while ( found ) {

      if ( (((found.movetype == MOVETYPE_FLYMISSILE) || (found.movetype == MOVETYPE_BOUNCE)) || (found.movetype == MOVETYPE_BOUNCEMISSILE)) ) {

         if ( visible ( found) ) {

            if ( heading ( self, found, 0.90000) ) {

               enemy_proj = found;

            }

         }

      }
      found = found.chain;

   }
   if ( enemy_proj ) {

      return ( enemy_proj );
   } else {

      return ( world );

   }
};


void  ()ScorpionDie =  {
   if ( (self.frame == 94.00000) ) {

      MakeSolidCorpse ( );
      return ;

   }
   if ( (self.health < -30.00000) ) {

      chunk_death ( );

   }
   self.frame += 1.00000;
   AdvanceThinkTime(self,HX_FRAME_TIME);
};


void  ()ScorpionDieInit =  [ 74.0, ScorpionDie] {
   sound ( self, CHAN_VOICE, "scorpion/death.wav", 1.00000, ATTN_NORM);
};


float MUMMY_NONE   =  0.00000;
float MUMMY_LARM   =  1.00000;
float MUMMY_RARM   =  2.00000;
float MUMMY_LEG   =  3.00000;
float MUMMY_WAVER   =  1.00000;
float MUMMY_DOWN   =  2.00000;
void  ()mummyrun;
void  ()mummywalk;
void  ()mummymelee;

void  ()mummissile_touch =  {
local float damg = 0.00000;
   if ( (other == self.owner) ) {

      return ;

   }
   if ( (pointcontents ( self.origin) == CONTENT_SKY) ) {

      pmissile_gone ( );
      return ;

   }
   damg = random(5.00000,10.00000);
   if ( other.health ) {

      T_Damage ( other, self, self.owner, damg);

   }
   sound ( self, CHAN_BODY, "weapons/expsmall.wav", 1.00000, ATTN_NORM);
   self.origin = (self.origin - (8.00000 * normalize ( self.velocity)));
   CreateFireCircle ( (self.origin - (v_forward * 8.00000)));
   self.effects = EF_NODRAW;
   self.solid = SOLID_NOT;
   AdvanceThinkTime(self,0.50000);
   self.think = pmissile_gone;
};


void  ()mflame1_runup =  {
   AdvanceFrame( 0.00000, 16.00000);
   if ( cycle_wrapped ) {

      if ( self.cnt ) {

         self.cnt -= 1.00000;
         particle2 ( (self.origin + '0.00000 0.00000 17.00000'), '0.00000 0.00000 25.00000', '0.00000 0.00000 25.00000', 168.00000, 7.00000, 5.00000);
      } else {

         remove ( self);

      }

   }
};


void  ()mflame2_runup =  {
   AdvanceFrame( 17.00000, 33.00000);
   if ( cycle_wrapped ) {

      if ( self.cnt ) {

         self.cnt -= 1.00000;
         particle2 ( (self.origin + '0.00000 0.00000 17.00000'), '0.00000 0.00000 25.00000', '0.00000 0.00000 25.00000', 168.00000, 7.00000, 5.00000);
      } else {

         remove ( self);

      }

   }
};


void  ()mflame3_runup =  {
   AdvanceFrame( 34.00000, 50.00000);
   if ( cycle_wrapped ) {

      if ( self.cnt ) {

         self.cnt -= 1.00000;
         particle2 ( (self.origin + '0.00000 0.00000 17.00000'), '0.00000 0.00000 25.00000', '0.00000 0.00000 25.00000', 168.00000, 7.00000, 5.00000);
      } else {

         remove ( self);

      }

   }
};


void  ()mflame_burn =  {
local float damg = 0.00000;
   if ( ((other.health && (other != self.owner)) && (self.pain_finished < time)) ) {

      damg = (self.dmg + (random() * self.dmg));
      T_Damage ( other, self, self.owner, damg);
      self.pain_finished = (time + 0.05000);
      if ( (self.t_width < time) ) {

         sound ( self, CHAN_BODY, "crusader/sunhit.wav", 1.00000, ATTN_NORM);
         self.t_width = (time + 0.10000);

      }

   }
};


void  ()SpawnMummyFlame =  {
local entity new;
local float chance = 0.00000;
   traceline ( self.origin, (self.origin - '0.00000 0.00000 600.00000'), TRUE, self);
   if ( (trace_fraction == 1.00000) ) {

      return ;

   }
   if ( (pointcontents ( trace_endpos) == CONTENT_WATER) ) {

      remove ( self);
      return ;

   }
   new = spawn ( );
   CreateEntityNew ( new, ENT_MUMMY_FIRE, "models/mumshot.mdl", SUB_Null);
   setorigin ( new, trace_endpos);
   new.owner = self.owner;
   new.pain_finished = 0.00000;
   new.drawflags = MLS_ABSLIGHT;
   new.abslight = 0.50000;
   new.angles = self.angles;
   new.dmg = 3.00000;
   chance = random();
   if ( (chance < 0.33000) ) {

      new.think = mflame1_runup;
   } else {

      if ( (chance < 0.66000) ) {

         new.think = mflame2_runup;
      } else {

         new.think = mflame3_runup;

      }

   }
   AdvanceThinkTime(new,HX_FRAME_TIME);
   new.touch = mflame_burn;
   if ( (self.classname == "circfire") ) {

      new.angles = (self.angles + '0.00000 -90.00000 0.00000');
      new.scale = 2.50000;
      new.cnt = 5.00000;
      particle2 ( (new.origin + '0.00000 0.00000 17.00000'), '0.00000 0.00000 25.00000', '0.00000 0.00000 25.00000', 168.00000, 7.00000, 5.00000);
   } else {

      if ( (self.lifetime < time) ) {

         remove ( self);
      } else {

         particle2 ( new.origin, '0.00000 0.00000 25.00000', '0.00000 0.00000 25.00000', 168.00000, 7.00000, 5.00000);
         AdvanceThinkTime(self,0.04000);
         self.think = SpawnMummyFlame;

      }

   }
};


void  ()mumshot_gone =  {
local float damg = 0.00000;
   if ( other.health ) {

      damg = (15.00000 + (random() * 10.00000));
      T_Damage ( other, self, self.owner, damg);

   }
   remove ( self);
};


void  ()launch_mumshot =  {
local vector diff = '0.00000 0.00000 0.00000';
   self.last_attack = time;
   newmis = spawn ( );
   newmis.owner = self;
   newmis.movetype = MOVETYPE_FLYMISSILE;
   newmis.solid = SOLID_BBOX;
   setmodel ( newmis, "models/mumshot.mdl");
   setsize ( newmis, '0.00000 0.00000 0.00000', '0.00000 0.00000 0.00000');
   makevectors ( self.angles);
   setorigin ( newmis, (((self.origin + (v_forward * 14.00000)) + (v_right * 15.00000)) + (v_up * 50.00000)));
   diff = ((self.enemy.origin + self.enemy.view_ofs) - newmis.origin);
   newmis.velocity = normalize ( diff);
   newmis.velocity = (newmis.velocity * 400.00000);
   newmis.classname = "mumshot";
   newmis.angles = vectoangles ( newmis.velocity);
   newmis.touch = mumshot_gone;
   CreateRedFlash ( (((self.origin + (v_forward * -14.00000)) + (v_right * 15.00000)) + (v_up * 50.00000)));
   newmis.effects = EF_NODRAW;
   sound ( self, CHAN_WEAPON, "mummy/mislfire.wav", 1.00000, ATTN_NORM);
   newmis.lifetime = (time + 2.50000);
   AdvanceThinkTime(newmis,0.04000);
   newmis.think = SpawnMummyFlame;
};


void  ()launch_mumshot2 =  {
local vector diff = '0.00000 0.00000 0.00000';
   self.last_attack = time;
   newmis = spawn ( );
   CreateEntityNew ( newmis, ENT_MUMMY_MISSILE, "models/mumshot.mdl", SUB_Null);
   newmis.owner = self;
   setorigin ( newmis, (((self.origin + (v_forward * -14.00000)) + (v_right * -15.00000)) + (v_up * 50.00000)));
   sound ( self, CHAN_WEAPON, "mummy/mislfire.wav", 1.00000, ATTN_NORM);
   makevectors ( self.angles);
   diff = ((self.enemy.origin + '0.00000 0.00000 20.00000') - newmis.origin);
   newmis.velocity = normalize ( diff);
   newmis.velocity = (newmis.velocity * 600.00000);
   newmis.classname = "mummymissile";
   newmis.avelocity = '0.00000 0.00000 1000.00000';
   newmis.angles = vectoangles ( newmis.velocity);
   newmis.touch = T_MissileTouch;
   AdvanceThinkTime(newmis,2.50000);
   newmis.think = SUB_Remove;
};


void  ()mummy_die =  {
   if ( (self.classname == "monster_mummy_lord") ) {

      sound ( self, CHAN_VOICE, "mummy/die2.wav", 1.00000, ATTN_NORM);
   } else {

      sound ( self, CHAN_VOICE, "mummy/die.wav", 1.00000, ATTN_NORM);

   }
   chunk_death ( );
   AdvanceThinkTime(self,0.01000);
   self.think = SUB_Remove;
   return ;
};


void  ()mummy_throw_rightleg =  {
local entity new;
   new = spawn ( );
   CreateEntityNew ( new, ENT_MUMMY_LEG, "models/leg.mdl", SUB_Null);
   makevectors ( self.angles);
   new.origin = ((self.origin + (v_right * 10.00000)) + (v_up * 60.00000));
   new.velocity = VelocityForDamage ( 40.00000);
   new.avelocity_x = (random() * 600.00000);
   new.avelocity_y = (random() * 600.00000);
   new.avelocity_z = (random() * 600.00000);
   self.parts_gone = MUMMY_LEG;
   self.mummy_state = MUMMY_WAVER;
   new.movetype = MOVETYPE_BOUNCE;
   new.solid = SOLID_PHASE;
   new.flags ^= FL_ONGROUND;
   new.think = MakeSolidCorpse;
   AdvanceThinkTime(new,(HX_FRAME_TIME * 10.00000));
};


void  ()mummy_throw_rightarm =  {
local entity new;
   new = spawn ( );
   CreateEntityNew ( new, ENT_MUMMY_ARM, "models/larm.mdl", SUB_Null);
   makevectors ( self.angles);
   new.origin = ((self.origin + (v_right * 10.00000)) + (v_up * 60.00000));
   new.velocity = VelocityForDamage ( 40.00000);
   new.avelocity_x = (random() * 600.00000);
   new.avelocity_y = (random() * 600.00000);
   new.avelocity_z = (random() * 600.00000);
   new.movetype = MOVETYPE_BOUNCE;
   new.solid = SOLID_PHASE;
   new.flags ^= FL_ONGROUND;
   new.think = MakeSolidCorpse;
   AdvanceThinkTime(new,(HX_FRAME_TIME * 10.00000));
   self.parts_gone = MUMMY_RARM;
};


void  ()mummy_throw_leftarm =  {
local entity new;
   new = spawn ( );
   CreateEntityNew ( new, ENT_MUMMY_ARM, "models/larm.mdl", SUB_Null);
   makevectors ( self.angles);
   new.origin = ((self.origin - (v_right * 10.00000)) + (v_up * 60.00000));
   new.velocity = VelocityForDamage ( 40.00000);
   new.avelocity_x = (random() * 600.00000);
   new.avelocity_y = (random() * 600.00000);
   new.avelocity_z = (random() * 600.00000);
   new.movetype = MOVETYPE_BOUNCE;
   new.solid = SOLID_PHASE;
   new.flags ^= FL_ONGROUND;
   self.parts_gone = MUMMY_LARM;
   new.think = MakeSolidCorpse;
   AdvanceThinkTime(new,(HX_FRAME_TIME * 10.00000));
};


void  ()mummy_pain =  {
local float hold_parts = 0.00000;
   if ( (self.pain_finished > time) ) {

      return ;

   }
   if ( (self.classname == "monster_mummy_lord") ) {

      sound ( self, CHAN_VOICE, "mummy/pain2.wav", 1.00000, ATTN_NORM);
   } else {

      sound ( self, CHAN_VOICE, "mummy/pain.wav", 1.00000, ATTN_NORM);

   }
   hold_parts = self.parts_gone;
   if ( (self.health < 30.00000) ) {

      if ( (self.parts_gone <= MUMMY_NONE) ) {

         mummy_throw_leftarm ( );

      }
      if ( (self.parts_gone <= MUMMY_LARM) ) {

         mummy_throw_rightarm ( );

      }
      if ( (self.parts_gone <= MUMMY_RARM) ) {

         mummy_throw_rightleg ( );

      }
   } else {

      if ( (self.health < 60.00000) ) {

         if ( (self.parts_gone <= MUMMY_NONE) ) {

            mummy_throw_leftarm ( );

         }
         if ( (self.parts_gone <= MUMMY_LARM) ) {

            mummy_throw_rightarm ( );

         }
      } else {

         if ( (self.health < 100.00000) ) {

            if ( (self.parts_gone == MUMMY_NONE) ) {

               mummy_throw_leftarm ( );

            }

         }

      }

   }
   if ( (hold_parts != self.parts_gone) ) {

      sound ( self, CHAN_BODY, "mummy/limbloss.wav", 1.00000, ATTN_NORM);

   }
};


void  ()lordmummymissile =  {
local float result = 0.00000;
local vector delta = '0.00000 0.00000 0.00000';
   AdvanceThinkTime(self,HX_FRAME_TIME);
   self.think = lordmummymissile;
   delta = (self.enemy.origin - self.origin);
   if ( (vlen ( delta) < 70.00000) ) {

      mummymelee ( );

   }
   if ( (self.parts_gone == MUMMY_NONE) ) {

      result = AdvanceFrame ( 13.00000, 36.00000);
      if ( (self.frame == 22.00000) ) {

         sound ( self, CHAN_WEAPON, "mummy/tap.wav", 1.00000, ATTN_NORM);

      }
      if ( (self.frame == 29.00000) ) {

         launch_mumshot ( );

      }
      if ( (result == AF_END) ) {

         mummyrun ( );
      } else {

         ai_face ( );

      }
   } else {

      if ( (self.parts_gone == MUMMY_LARM) ) {

         result = AdvanceFrame ( 97.00000, 112.00000);
         if ( (self.frame == 112.00000) ) {

            launch_mumshot ( );

         }
         if ( (result == AF_END) ) {

            mummyrun ( );
         } else {

            ai_face ( );

         }
      } else {

         mummyrun ( );

      }

   }
};


void  ()mummymissile =  {
local float result = 0.00000;
local float chance = 0.00000;
local vector delta = '0.00000 0.00000 0.00000';
   AdvanceThinkTime(self,HX_FRAME_TIME);
   self.think = mummymissile;
   delta = (self.enemy.origin - self.origin);
   if ( (vlen ( delta) < 70.00000) ) {

      mummymelee ( );

   }
   if ( (self.parts_gone == MUMMY_NONE) ) {

      result = AdvanceFrame ( 131.00000, 146.00000);
      if ( (self.frame == 136.00000) ) {

         makevectors ( self.angles);
         Create_Missile ( self, (((self.origin + (v_forward * 14.00000)) - (v_right * 9.00000)) + (v_up * 25.00000)), (self.enemy.origin + self.enemy.view_ofs), "models/akarrow.mdl", "green_arrow", 0.00000, 1000.00000, mummissile_touch);

      }
      if ( (self.frame == 142.00000) ) {

         if ( (enemy_range < RANGE_NEAR) ) {

            chance = 0.80000;
         } else {

            if ( (enemy_range < RANGE_MID) ) {

               chance = 0.70000;
            } else {

               if ( (enemy_range < RANGE_FAR) ) {

                  chance = 0.40000;

               }

            }

         }
         if ( (random() < chance) ) {

            self.frame = 135.00000;

         }

      }
      if ( (result == AF_END) ) {

         mummyrun ( );
      } else {

         ai_face ( );

      }
   } else {

      if ( (self.parts_gone == MUMMY_LARM) ) {

         result = AdvanceFrame ( 147.00000, 162.00000);
         if ( (self.frame == 152.00000) ) {

            makevectors ( self.angles);
            Create_Missile ( self, (((self.origin + (v_forward * 14.00000)) + (v_right * 11.00000)) + (v_up * 40.00000)), (self.enemy.origin + self.enemy.view_ofs), "models/akarrow.mdl", "green_arrow", 0.00000, 1000.00000, mummissile_touch);

         }
         if ( (self.frame == 158.00000) ) {

            if ( (enemy_range < RANGE_NEAR) ) {

               chance = 0.80000;
            } else {

               if ( (enemy_range < RANGE_MID) ) {

                  chance = 0.70000;
               } else {

                  if ( (enemy_range < RANGE_FAR) ) {

                     chance = 0.40000;

                  }

               }

            }
            if ( (random() < chance) ) {

               self.frame = 151.00000;

            }

         }
         if ( (result == AF_END) ) {

            mummyrun ( );
         } else {

            ai_face ( );

         }
      } else {

         mummyrun ( );

      }

   }
};


void  ()mummylordchoice =  {
local float chance = 0.00000;
   if ( (enemy_range < RANGE_NEAR) ) {

      chance = 0.60000;
   } else {

      if ( (enemy_range < RANGE_MID) ) {

         chance = 0.80000;
      } else {

         if ( (enemy_range < RANGE_FAR) ) {

            chance = 0.90000;

         }

      }

   }
   if ( (random() < chance) ) {

      lordmummymissile ( );
   } else {

      mummymissile ( );

   }
};


void  ()mummypunch =  {
local vector delta = '0.00000 0.00000 0.00000';
local float ldmg = 0.00000;
   delta = (self.enemy.origin - self.origin);
   if ( (vlen ( delta) > 50.00000) ) {

      return ;

   }
   self.last_attack = time;
   if ( (self.classname == "monster_mummy") ) {

      ldmg = DMG_MUMMY_PUNCH;
   } else {

      ldmg = (DMG_MUMMY_PUNCH * 2.00000);

   }
   T_Damage ( self.enemy, self, self, ldmg);
   sound ( self, CHAN_WEAPON, "weapons/gauntht1.wav", 1.00000, ATTN_NORM);
};


void  ()mummybite =  {
local vector delta = '0.00000 0.00000 0.00000';
local float ldmg = 0.00000;
   delta = (self.enemy.origin - self.origin);
   if ( (vlen ( delta) > 50.00000) ) {

      return ;

   }
   self.last_attack = time;
   ldmg = (random() * DMG_MUMMY_PUNCH);
   T_Damage ( self.enemy, self, self, ldmg);
   sound ( self, CHAN_WEAPON, "mummy/bite.wav", 1.00000, ATTN_NORM);
};


void  ()mummymelee =  {
local float result = 0.00000;
local vector delta = '0.00000 0.00000 0.00000';
   self.nextthink = (time + HX_FRAME_TIME);
   self.think = mummymelee;
   if ( (self.parts_gone == MUMMY_NONE) ) {

      result = AdvanceFrame ( 47.00000, 64.00000);
      if ( (self.frame == 54.00000) ) {

         sound ( self, CHAN_WEAPON, "weapons/vorpswng.wav", 1.00000, ATTN_NORM);

      }
      if ( (self.frame == 57.00000) ) {

         mummypunch ( );

      }
   } else {

      if ( (self.parts_gone == MUMMY_LARM) ) {

         result = AdvanceFrame ( 65.00000, 82.00000);
         if ( (self.frame == 72.00000) ) {

            sound ( self, CHAN_WEAPON, "weapons/vorpswng.wav", 1.00000, ATTN_NORM);

         }
         if ( (self.frame == 75.00000) ) {

            mummypunch ( );

         }
      } else {

         if ( (self.parts_gone == MUMMY_RARM) ) {

            result = AdvanceFrame ( 37.00000, 46.00000);
            if ( (self.frame == 41.00000) ) {

               sound ( self, CHAN_WEAPON, "weapons/gaunt1.wav", 1.00000, ATTN_NORM);

            }
            if ( (self.frame == 44.00000) ) {

               mummypunch ( );

            }
         } else {

            AdvanceThinkTime(self,(HX_FRAME_TIME * 2.00000));
            self.mummy_state = MUMMY_DOWN;
            result = AdvanceFrame ( 190.00000, 203.00000);
            if ( (self.frame == 203.00000) ) {

               sound ( self, CHAN_BODY, "mummy/crawl.wav", 1.00000, ATTN_NORM);

            }
            if ( (self.frame == 196.00000) ) {

               mummybite ( );

            }

         }

      }

   }
   if ( (result == AF_END) ) {

      delta = (self.enemy.origin - self.origin);
      if ( (vlen ( delta) > 80.00000) ) {

         mummyrun ( );

      }
   } else {

      ai_charge ( 1.00000);

   }
};


void  ()mummyrun =  {
local float distance = 0.00000;
   AdvanceThinkTime(self,HX_FRAME_TIME);
   self.think = mummyrun;
   if ( (self.parts_gone == MUMMY_NONE) ) {

      if ( ((random() < 0.10000) && (self.frame == 83.00000)) ) {

         if ( (self.classname == "monster_mummy_lord") ) {

            sound ( self, CHAN_VOICE, "mummy/moan2.wav", 1.00000, ATTN_NORM);
         } else {

            sound ( self, CHAN_VOICE, "mummy/moan.wav", 1.00000, ATTN_NORM);

         }

      }
      AdvanceFrame ( 83.00000, 96.00000);
      if ( (self.frame == 88.00000) ) {

         sound ( self, CHAN_BODY, "mummy/step.wav", 1.00000, ATTN_NORM);
      } else {

         if ( (self.frame == 89.00000) ) {

            sound ( self, CHAN_BODY, "mummy/slide.wav", 1.00000, ATTN_NORM);

         }

      }
      if ( ((self.frame >= 83.00000) && (self.frame <= 86.00000)) ) {

         distance = 3.25000;
      } else {

         distance = 2.25000;

      }
   } else {

      if ( (self.parts_gone == MUMMY_LARM) ) {

         if ( ((random() < 0.10000) && (self.frame == 97.00000)) ) {

            if ( (self.classname == "monster_mummy_lord") ) {

               sound ( self, CHAN_VOICE, "mummy/moan2.wav", 1.00000, ATTN_NORM);
            } else {

               sound ( self, CHAN_VOICE, "mummy/moan.wav", 1.00000, ATTN_NORM);

            }

         }
         AdvanceFrame ( 97.00000, 112.00000);
         if ( (self.frame == 102.00000) ) {

            sound ( self, CHAN_BODY, "mummy/step.wav", 1.00000, ATTN_NORM);
         } else {

            if ( (self.frame == 104.00000) ) {

               sound ( self, CHAN_BODY, "mummy/slide.wav", 1.00000, ATTN_NORM);

            }

         }
         distance = 3.00000;
      } else {

         if ( (self.parts_gone == MUMMY_RARM) ) {

            if ( ((random() < 0.10000) && (self.frame == 113.00000)) ) {

               if ( (self.classname == "monster_mummy_lord") ) {

                  sound ( self, CHAN_VOICE, "mummy/moan2.wav", 1.00000, ATTN_NORM);
               } else {

                  sound ( self, CHAN_VOICE, "mummy/moan.wav", 1.00000, ATTN_NORM);

               }

            }
            AdvanceFrame ( 113.00000, 130.00000);
            if ( (self.frame == 120.00000) ) {

               sound ( self, CHAN_BODY, "mummy/step.wav", 1.00000, ATTN_NORM);
            } else {

               if ( (self.frame == 122.00000) ) {

                  sound ( self, CHAN_BODY, "mummy/slide.wav", 1.00000, ATTN_NORM);

               }

            }
            distance = 3.00000;
         } else {

            if ( (self.parts_gone <= MUMMY_LEG) ) {

               if ( (self.mummy_state == MUMMY_WAVER) ) {

                  AdvanceFrame ( 0.00000, 12.00000);
                  if ( (self.frame == 12.00000) ) {

                     self.mummy_state = MUMMY_DOWN;

                  }
                  distance = 0.00000;
               } else {

                  AdvanceThinkTime(self,(HX_FRAME_TIME * 2.00000));
                  AdvanceFrame ( 190.00000, 203.00000);
                  if ( (self.frame == 191.00000) ) {

                     sound ( self, CHAN_BODY, "mummy/slide.wav", 1.00000, ATTN_NORM);

                  }
                  if ( ((self.frame >= 190.00000) && (self.frame <= 194.00000)) ) {

                     distance = 3.00000;
                  } else {

                     distance = 0.00000;

                  }

               }

            }

         }

      }

   }
   ai_run ( distance);
};


void  ()mummywalk =  {
local float distance = 0.00000;
   AdvanceThinkTime(self,(HX_FRAME_TIME + 0.02000));
   self.think = mummywalk;
   if ( (self.parts_gone == MUMMY_NONE) ) {

      if ( ((random() < 0.10000) && (self.frame == 83.00000)) ) {

         if ( (self.classname == "monster_mummy_lord") ) {

            sound ( self, CHAN_VOICE, "mummy/moan2.wav", 1.00000, ATTN_NORM);
         } else {

            sound ( self, CHAN_VOICE, "mummy/moan.wav", 1.00000, ATTN_NORM);

         }

      }
      AdvanceFrame ( 83.00000, 96.00000);
      if ( (self.frame == 88.00000) ) {

         sound ( self, CHAN_BODY, "mummy/step.wav", 1.00000, ATTN_NORM);
      } else {

         if ( (self.frame == 89.00000) ) {

            sound ( self, CHAN_BODY, "mummy/slide.wav", 1.00000, ATTN_NORM);

         }

      }
      if ( ((self.frame >= 83.00000) && (self.frame <= 86.00000)) ) {

         distance = 3.25000;
      } else {

         distance = 2.25000;

      }
   } else {

      if ( (self.parts_gone == MUMMY_LARM) ) {

         if ( ((random() < 0.10000) && (self.frame == 97.00000)) ) {

            if ( (self.classname == "monster_mummy_lord") ) {

               sound ( self, CHAN_VOICE, "mummy/moan2.wav", 1.00000, ATTN_NORM);
            } else {

               sound ( self, CHAN_VOICE, "mummy/moan.wav", 1.00000, ATTN_NORM);

            }

         }
         AdvanceFrame ( 97.00000, 112.00000);
         distance = 2.25000;
         if ( (self.frame == 102.00000) ) {

            sound ( self, CHAN_BODY, "mummy/step.wav", 1.00000, ATTN_NORM);
         } else {

            if ( (self.frame == 104.00000) ) {

               sound ( self, CHAN_BODY, "mummy/slide.wav", 1.00000, ATTN_NORM);

            }

         }
      } else {

         if ( (self.parts_gone == MUMMY_RARM) ) {

            if ( ((random() < 0.10000) && (self.frame == 113.00000)) ) {

               if ( (self.classname == "monster_mummy_lord") ) {

                  sound ( self, CHAN_VOICE, "mummy/moan2.wav", 1.00000, ATTN_NORM);
               } else {

                  sound ( self, CHAN_VOICE, "mummy/moan.wav", 1.00000, ATTN_NORM);

               }

            }
            AdvanceFrame ( 113.00000, 130.00000);
            distance = 2.25000;
            if ( (self.frame == 120.00000) ) {

               sound ( self, CHAN_BODY, "mummy/step.wav", 1.00000, ATTN_NORM);
            } else {

               if ( (self.frame == 122.00000) ) {

                  sound ( self, CHAN_BODY, "mummy/slide.wav", 1.00000, ATTN_NORM);

               }

            }
         } else {

            if ( (self.parts_gone <= MUMMY_LEG) ) {

               if ( (self.mummy_state == MUMMY_WAVER) ) {

                  AdvanceFrame ( 0.00000, 12.00000);
                  if ( (self.frame == 12.00000) ) {

                     self.mummy_state = MUMMY_DOWN;

                  }
                  distance = 0.00000;
               } else {

                  AdvanceThinkTime(self,(HX_FRAME_TIME * 2.00000));
                  if ( (self.frame == 191.00000) ) {

                     sound ( self, CHAN_BODY, "mummy/slide.wav", 1.00000, ATTN_NORM);

                  }
                  AdvanceFrame ( 190.00000, 203.00000);
                  if ( (self.frame == 203.00000) ) {

                     sound ( self, CHAN_BODY, "mummy/crawl.wav", 1.00000, ATTN_NORM);

                  }
                  distance = 2.00000;

               }

            }

         }

      }

   }
   ai_walk ( distance);
};


void  ()mummystand =  {
   AdvanceThinkTime(self,HX_FRAME_TIME);
   self.think = mummystand;
   self.frame = 83.00000;
   if ( (random() < 0.50000) ) {

      ai_stand ( );

   }
};


void  ()monster_mummy =  {
   if ( deathmatch ) {

      remove ( self);
      return ;

   }
   if ( !(self.flags2 & FL_SUMMONED) ) {

      precache_model2 ( "models/mummy.mdl");
      precache_model2 ( "models/larm.mdl");
      precache_model2 ( "models/leg.mdl");
      precache_model2 ( "models/mumshot.mdl");
      precache_model2 ( "models/muhead.mdl");
      precache_sound2 ( "mummy/sight.wav");
      precache_sound2 ( "mummy/die.wav");
      precache_sound2 ( "mummy/mislfire.wav");
      precache_sound2 ( "mummy/limbloss.wav");
      precache_sound2 ( "mummy/moan.wav");
      precache_sound2 ( "mummy/pain.wav");
      precache_sound2 ( "mummy/crawl.wav");
      precache_sound2 ( "mummy/slide.wav");
      precache_sound2 ( "mummy/step.wav");
      precache_sound2 ( "mummy/tap.wav");
      precache_sound2 ( "mummy/bite.wav");

   }
   CreateEntityNew ( self, ENT_MUMMY, "models/mummy.mdl", mummy_die);
   self.mintel = 3.00000;
   self.monsterclass = CLASS_GRUNT;
   self.th_stand = mummystand;
   self.th_walk = mummywalk;
   self.th_run = mummyrun;
   self.th_melee = mummymelee;
   self.th_missile = mummymissile;
   self.th_pain = mummy_pain;
   self.parts_gone = MUMMY_NONE;
   self.skin = 0.00000;
   self.flags = (self.flags | FL_MONSTER);
   self.yaw_speed = 10.00000;
   self.health = 200.00000;
   self.experience_value = 200.00000;
   walkmonster_start ( );
};


void  ()monster_mummy_lord =  {
   if ( deathmatch ) {

      remove ( self);
      return ;

   }
   if ( !(self.flags2 & FL_SUMMONED) ) {

      precache_model2 ( "models/mummy.mdl");
      precache_model2 ( "models/larm.mdl");
      precache_model2 ( "models/leg.mdl");
      precache_model2 ( "models/mumshot.mdl");
      precache_model2 ( "models/muhead.mdl");
      precache_sound2 ( "mummy/sight2.wav");
      precache_sound2 ( "mummy/die2.wav");
      precache_sound2 ( "mummy/mislfire.wav");
      precache_sound2 ( "mummy/limbloss.wav");
      precache_sound2 ( "mummy/moan2.wav");
      precache_sound2 ( "mummy/pain2.wav");
      precache_sound2 ( "mummy/crawl.wav");
      precache_sound2 ( "mummy/slide.wav");
      precache_sound2 ( "mummy/step.wav");
      precache_sound2 ( "mummy/tap.wav");
      precache_sound2 ( "mummy/bite.wav");

   }
   CreateEntityNew ( self, ENT_MUMMY, "models/mummy.mdl", mummy_die);
   self.mintel = 3.00000;
   self.monsterclass = CLASS_GRUNT;
   self.th_stand = mummystand;
   self.th_walk = mummywalk;
   self.th_run = mummyrun;
   self.th_melee = mummymelee;
   self.th_missile = mummylordchoice;
   self.th_pain = mummy_pain;
   self.parts_gone = MUMMY_NONE;
   self.skin = 1.00000;
   self.headmodel = "models/muhead.mdl";
   self.flags = (self.flags | FL_MONSTER);
   self.yaw_speed = 10.00000;
   self.health = 400.00000;
   self.experience_value = 300.00000;
   walkmonster_start ( );
};


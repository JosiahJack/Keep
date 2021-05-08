float ARCHER_STUCK   =  2.00000;
float GREEN_ARROW   =  0.00000;
float RED_ARROW   =  1.00000;
float GOLD_ARROW   =  2.00000;
void  ()archer_run;
void  ()archer_stand;
void  ()archerredraw;
void  ()archerdraw;
void  ()archerdrawhold;
void  ()archermissile;
void  ()archer_check_defense;

void  ()archer_duck =  {
   AdvanceFrame( 43.00000, 56.00000);
   ai_face ( );
   if ( cycle_wrapped ) {

      setsize ( self, '-16.00000 -16.00000 0.00000', '16.00000 16.00000 56.00000');
      if ( infront ( self.enemy) ) {

         self.think = archermissile;
      } else {

         self.think = archerdrawhold;

      }
      AdvanceThinkTime(self,0.00000);
      return ;
   } else {

      if ( (self.frame == 43.00000) ) {

         if ( (self.classname == "monster_archer") ) {

            sound ( self, CHAN_VOICE, "archer/growl.wav", 1.00000, ATTN_NORM);
         } else {

            sound ( self, CHAN_VOICE, "archer/pain2.wav", 1.00000, ATTN_NORM);

         }
      } else {

         if ( (self.frame == 47.00000) ) {

            setsize ( self, '-16.00000 -16.00000 0.00000', '16.00000 16.00000 28.00000');
         } else {

            if ( (self.frame == 49.00000) ) {

               archer_check_defense ( );
               AdvanceThinkTime(self,0.20000);

            }

         }

      }

   }
};


void  ()archer_check_defense =  {
local entity enemy_proj;
   if ( (random(2.00000) > ((skill / 10.00000) + (self.skin / 2.00000))) ) {

      return ;

   }
   if ( (((self.enemy.last_attack + 0.50000) < time) && ((self.oldenemy.last_attack + 0.50000) < time)) ) {

      return ;

   }
   enemy_proj = look_projectiles ( );
   if ( !enemy_proj ) {

      if ( lineofsight ( self, self.enemy) ) {

         enemy_proj = self.enemy;
         self.level = (vlen ( (self.enemy.origin - self.origin)) / 1000.00000);
      } else {

         return ;

      }

   }
   if ( mezzo_check_duck ( enemy_proj) ) {

      if ( (self.think == archer_duck) ) {

         self.frame = 48.00000;
      } else {

         self.think = archer_duck;
         AdvanceThinkTime(self,0.00000);

      }
      return ;

   }
};


void  ()archer_arrow_touch =  {
local float damg = 0.00000;
local vector delta = '0.00000 0.00000 0.00000';
   if ( (pointcontents ( self.origin) == CONTENT_SKY) ) {

      remove ( self);
      return ;

   }
   if ( (self.owner.classname == "monster_archer") ) {

      damg = random(5.00000,7.00000);
   } else {

      if ( (self.classname == "red_arrow") ) {

         damg = random(8.00000,12.00000);
      } else {

         damg = random(13.00000,17.00000);

      }

   }
   if ( ((other.classname == "player") && (self.classname == "gold_arrow")) ) {

      delta = (other.origin - self.origin);
      other.velocity = (delta * 10.00000);
      if ( (other.flags & FL_ONGROUND) ) {

         other.flags ^= FL_ONGROUND;

      }
      other.velocity_z = 150.00000;

   }
   T_Damage ( other, self, self.owner, damg);
   self.origin = ((self.origin - (8.00000 * normalize ( self.velocity))) - '0.00000 0.00000 40.00000');
   sound ( self, CHAN_WEAPON, "weapons/explode.wav", 1.00000, ATTN_NORM);
   if ( (self.classname == "gold_arrow") ) {

      CreateSpark ( self.origin);
   } else {

      if ( (self.classname == "red_arrow") ) {

         CreateRedSpark ( self.origin);
      } else {

         CreateGreenSpark ( self.origin);

      }

   }
   remove ( self);
};


void  ()archer_dying =  {
   AdvanceFrame( 8.00000, 29.00000);
   sound ( self, CHAN_WEAPON, "misc/null.wav", 1.00000, ATTN_NORM);
   if ( (self.health < -80.00000) ) {

      chunk_death ( );
      remove ( self);

   }
   if ( cycle_wrapped ) {

      self.frame = 29.00000;
      MakeSolidCorpse ( );

   }
};


void  ()archer_die =  {
   if ( (self.health < -30.00000) ) {

      chunk_death ( );
      return ;
   } else {

      if ( (self.classname == "monster_archer") ) {

         sound ( self, CHAN_VOICE, "archer/death.wav", 1.00000, ATTN_NORM);
      } else {

         sound ( self, CHAN_VOICE, "archer/death2.wav", 1.00000, ATTN_NORM);

      }

   }
   archer_dying ( );
};


void  ()archer_pain_anim =  {
   AdvanceFrame( 61.00000, 76.00000);
   if ( (self.frame == 62.00000) ) {

      if ( (self.classname == "monster_archer") ) {

         sound ( self, CHAN_VOICE, "archer/pain.wav", 1.00000, ATTN_NORM);
      } else {

         sound ( self, CHAN_VOICE, "archer/pain2.wav", 1.00000, ATTN_NORM);

      }

   }
   if ( (self.frame == 76.00000) ) {

      self.pain_finished = (time + random(4.00000,6.00000));
      archerredraw ( );

   }
};


void  (entity attacker,float damg)archer_pain =  {
   if ( ((self.frame >= 61.00000) && (self.frame <= 76.00000)) ) {

      return ;

   }
   if ( (self.attack_state == AS_MISSILE) ) {

      return ;

   }
   setsize ( self, '-16.00000 -16.00000 0.00000', '16.00000 16.00000 56.00000');
   if ( ((self.pain_finished > time) || (random() < 0.50000)) ) {

      archerredraw ( );
   } else {

      archer_pain_anim ( );

   }
};


void  (float arrowtype,vector spot1,vector spot2)archer_launcharrow =  {
   self.last_attack = time;
   makevectors ( self.angles);
   if ( (arrowtype == GREEN_ARROW) ) {

      sound ( self, CHAN_WEAPON, "archer/arrowg.wav", 1.00000, ATTN_NORM);
      Create_Missile ( self, spot1, spot2, "models/akarrow.mdl", "green_arrow", 0.00000, 1000.00000, archer_arrow_touch);
   } else {

      if ( (arrowtype == RED_ARROW) ) {

         sound ( self, CHAN_WEAPON, "archer/arrowr.wav", 1.00000, ATTN_NORM);
         CreateRedFlash ( spot1);
         Create_Missile ( self, spot1, spot2, "models/akarrow.mdl", "red_arrow", 1.00000, 1000.00000, archer_arrow_touch);
      } else {

         sound ( self, CHAN_WEAPON, "archer/arrowg.wav", 1.00000, ATTN_NORM);
         CreateRedFlash ( spot1);
         Create_Missile ( self, spot1, spot2, "models/akarrow.mdl", "gold_arrow", 2.00000, 1000.00000, archer_arrow_touch);

      }

   }
   newmis.drawflags |= MLS_ABSLIGHT;
   newmis.abslight = 0.50000;
   AdvanceThinkTime(newmis,2.50000);
};


void  ()archerdrawdone =  {
   AdvanceFrame( 117.00000, 111.00000);
   archer_check_defense ( );
   walkmove ( self.angles_y, 0.50000, FALSE);
   if ( visible ( self.enemy) ) {

      ai_face ( );

   }
   if ( cycle_wrapped ) {

      self.pausetime = (time + random(0.50000,2.00000));
      self.attack_state = AS_WAIT;
      archer_run ( );

   }
};


void  ()archermissile =  {
local float chance = 0.00000;
local float ok = 0.00000;
local float tspeed = 0.00000;
local vector spot1 = '0.00000 0.00000 0.00000';
local vector spot2 = '0.00000 0.00000 0.00000';
   AdvanceFrame( 57.00000, 60.00000);
   self.attack_state = AS_MISSILE;
   if ( visible ( self.enemy) ) {

      ai_face ( );
   } else {

      self.think = self.th_run;
      AdvanceThinkTime(self,0.00000);
      return ;

   }
   if ( (self.frame == 58.00000) ) {

      makevectors ( self.angles);
      spot1 = (((self.origin + (v_forward * 4.00000)) + (v_right * 10.00000)) + (v_up * 36.00000));
      if ( (self.classname == "monster_archer_lord") ) {

         tspeed = vlen ( self.enemy.velocity);
         if ( (tspeed > 100.00000) ) {

            spot2 = extrapolate_pos_for_speed ( spot1, 1000.00000, self.enemy, 0.30000);

         }

      }
      if ( (spot2 == '0.00000 0.00000 0.00000') ) {

         spot2 = (self.enemy.origin + self.enemy.view_ofs);
         traceline ( spot1, spot2, FALSE, self);
         if ( (trace_ent.thingtype >= THINGTYPE_WEBS) ) {

            traceline ( trace_endpos, spot2, FALSE, trace_ent);

         }
         if ( (trace_ent == self.enemy) ) {

            ok = TRUE;
         } else {

            if ( ((((trace_ent.health <= 25.00000) || (trace_ent.thingtype >= THINGTYPE_WEBS)) && trace_ent.takedamage) && (!(trace_ent.flags & FL_MONSTER) || (trace_ent.classname == "player_sheep"))) ) {

               ok = TRUE;

            }

         }
      } else {

         ok = TRUE;

      }
      if ( ok ) {

         enemy_range = range ( self.enemy);
         if ( (enemy_range < RANGE_MELEE) ) {

            chance = 0.80000;
         } else {

            if ( (enemy_range < RANGE_NEAR) ) {

               chance = 0.50000;
            } else {

               if ( (enemy_range < RANGE_MID) ) {

                  chance = 0.30000;
               } else {

                  if ( (enemy_range < RANGE_FAR) ) {

                     chance = 0.10000;

                  }

               }

            }

         }
         if ( (self.classname == "monster_archer") ) {

            if ( (random(1.00000) < chance) ) {

               archer_launcharrow ( RED_ARROW, spot1, spot2);
            } else {

               archer_launcharrow ( GREEN_ARROW, spot1, spot2);

            }
         } else {

            if ( (random(1.00000) < chance) ) {

               archer_launcharrow ( GOLD_ARROW, spot1, spot2);
            } else {

               archer_launcharrow ( RED_ARROW, spot1, spot2);

            }

         }
         self.attack_finished = (time + random(0.50000,1.00000));
         if ( !self.skin ) {

            chance -= 0.30000;

         }
         chance += (skill / 10.00000);
         if ( (random() > chance) ) {

            archerdrawdone ( );

         }
      } else {

         self.attack_finished = (time + random());
         sound ( self, CHAN_WEAPON, "misc/null.wav", 1.00000, ATTN_NORM);
         archer_run ( );
         return ;

      }

   }
   if ( cycle_wrapped ) {

      self.frame = 39.00000;
      archerredraw ( );
   } else {

      if ( visible ( self.enemy) ) {

         ai_face ( );

      }

   }
};


void  ()archerredraw =  {
   AdvanceFrame( 99.00000, 110.00000);
   self.attack_state = AS_MISSILE;
   archer_check_defense ( );
   if ( (self.frame == 106.00000) ) {

      sound ( self, CHAN_WEAPON, "archer/draw.wav", 1.00000, ATTN_NORM);

   }
   if ( cycle_wrapped ) {

      archermissile ( );
   } else {

      if ( visible ( self.enemy) ) {

         ai_face ( );
      } else {

         self.think = self.th_run;
         AdvanceThinkTime(self,0.00000);
         return ;

      }

   }
};


void  ()archerdrawhold =  {
local float chance = 0.00000;
local float startframe = 0.00000;
local float endframe = 0.00000;
local vector spot1 = '0.00000 0.00000 0.00000';
local vector spot2 = '0.00000 0.00000 0.00000';
   if ( visible ( self.enemy) ) {

      ai_face ( );
   } else {

      self.think = self.th_run;
      AdvanceThinkTime(self,0.00000);
      return ;

   }
   archer_check_defense ( );
   startframe = 177.00000;
   endframe = 188.00000;
   if ( !(self.spawnflags & ARCHER_STUCK) ) {

      if ( (vlen ( (self.enemy.origin - self.origin)) <= 200.00000) ) {

         if ( infront ( self.enemy) ) {

            if ( walkmove ( (self.angles_y + 180.00000), 3.00000, FALSE) ) {

               startframe = 0.00000;
               endframe = 7.00000;

            }

         }

      }

   }
   AdvanceFrame ( startframe, endframe);
   self.think = archerdrawhold;
   AdvanceThinkTime(self,0.05000);
   enemy_range = range ( self.enemy);
   if ( ((enemy_range < RANGE_NEAR) && (random() < 0.40000)) ) {

      archermissile ( );
   } else {

      if ( (cycle_wrapped || (random() < ((skill / 20.00000) + (self.skin / 10.00000)))) ) {

         makevectors ( self.angles);
         spot1 = ((self.origin + (v_right * 10.00000)) + (v_up * 36.00000));
         spot2 = (self.enemy.origin + self.enemy.view_ofs);
         traceline ( spot1, spot2, FALSE, self);
         if ( (trace_ent.thingtype >= THINGTYPE_WEBS) ) {

            traceline ( trace_endpos, spot2, FALSE, trace_ent);

         }
         if ( (trace_ent != self.enemy) ) {

            if ( ((((trace_ent.health > 25.00000) && (trace_ent.thingtype != THINGTYPE_GLASS)) || !trace_ent.takedamage) || ((trace_ent.flags & FL_MONSTER) && (trace_ent.classname != "player_sheep"))) ) {

               sound ( self, CHAN_WEAPON, "misc/null.wav", 1.00000, ATTN_NORM);
               self.attack_state = AS_STRAIGHT;
               self.think = archer_run;
               return ;

            }

         }
         if ( (self.classname == "monster_archer") ) {

            if ( (enemy_range <= RANGE_MELEE) ) {

               chance = 1.00000;
            } else {

               if ( (enemy_range <= RANGE_NEAR) ) {

                  chance = 0.70000;
               } else {

                  if ( (enemy_range <= RANGE_MID) ) {

                     chance = 0.60000;
                  } else {

                     if ( (enemy_range <= RANGE_FAR) ) {

                        chance = 0.50000;

                     }

                  }

               }

            }
         } else {

            chance = 1.00000;

         }
         if ( (random() < chance) ) {

            archermissile ( );

         }

      }

   }
};


void  ()archerdraw =  {
local vector spot1 = '0.00000 0.00000 0.00000';
local vector spot2 = '0.00000 0.00000 0.00000';
   AdvanceFrame( 111.00000, 123.00000);
   archer_check_defense ( );
   if ( (self.frame == 111.00000) ) {

      makevectors ( self.angles);
      spot1 = ((self.origin + (v_right * 10.00000)) + (v_up * 36.00000));
      spot2 = (self.enemy.origin + self.enemy.view_ofs);
      traceline ( spot1, spot2, FALSE, self);
      if ( (trace_ent.thingtype >= THINGTYPE_WEBS) ) {

         traceline ( trace_endpos, spot2, FALSE, trace_ent);

      }
      if ( (trace_ent != self.enemy) ) {

         if ( ((((trace_ent.health > 25.00000) && (trace_ent.thingtype != THINGTYPE_GLASS)) || !trace_ent.takedamage) || ((trace_ent.flags & FL_MONSTER) && (trace_ent.classname != "player_sheep"))) ) {

            sound ( self, CHAN_WEAPON, "misc/null.wav", 1.00000, ATTN_NORM);
            self.attack_state = AS_STRAIGHT;
            self.think = archer_run;
            AdvanceThinkTime(self,HX_FRAME_TIME);
            return ;

         }

      }

   }
   if ( (self.frame == 116.00000) ) {

      sound ( self, CHAN_WEAPON, "archer/draw.wav", 1.00000, ATTN_NORM);

   }
   if ( ((self.frame >= 111.00000) && (self.frame <= 123.00000)) ) {

      walkmove ( (self.angles_y + 180.00000), 0.28000, FALSE);

   }
   if ( cycle_wrapped ) {

      archerdrawhold ( );
   } else {

      if ( visible ( self.enemy) ) {

         ai_face ( );
      } else {

         self.think = self.th_run;
         AdvanceThinkTime(self,0.00000);
         return ;

      }

   }
   if ( ((random(1.00000) < 0.10000) && (self.frame == 189.00000)) ) {

      if ( (self.classname == "monster_archer") ) {

         sound ( self, CHAN_BODY, "archer/growl.wav", 1.00000, ATTN_NORM);
      } else {

         if ( (random() < 0.70000) ) {

            sound ( self, CHAN_BODY, "archer/growl2.wav", 1.00000, ATTN_NORM);
         } else {

            sound ( self, CHAN_BODY, "archer/growl3.wav", 1.00000, ATTN_NORM);

         }

      }

   }
};


void  ()archer_run =  {
   self.think = archer_run;
   AdvanceThinkTime(self,HX_FRAME_TIME);
   archer_check_defense ( );
   if ( ((random(1.00000) < 0.10000) && (self.frame == 189.00000)) ) {

      if ( (self.classname == "monster_archer") ) {

         sound ( self, CHAN_VOICE, "archer/growl.wav", 1.00000, ATTN_NORM);
      } else {

         if ( (random() < 0.70000) ) {

            sound ( self, CHAN_VOICE, "archer/growl2.wav", 1.00000, ATTN_NORM);
         } else {

            sound ( self, CHAN_VOICE, "archer/growl3.wav", 1.00000, ATTN_NORM);

         }

      }

   }
   if ( ((self.spawnflags & ARCHER_STUCK) || (self.attack_state == AS_WAIT)) ) {

      AdvanceFrame ( 159.00000, 176.00000);
      ai_run ( 0.00000);
   } else {

      AdvanceFrame ( 189.00000, 204.00000);
      ai_run ( 4.00000);

   }
};


void  ()archer_walk =  {
   AdvanceFrame( 77.00000, 98.00000);
   AdvanceThinkTime(self,(HX_FRAME_TIME + 0.01000));
   archer_check_defense ( );
   if ( ((random() < 0.05000) && (self.frame == 77.00000)) ) {

      if ( (self.classname == "monster_archer") ) {

         sound ( self, CHAN_VOICE, "archer/growl.wav", 1.00000, ATTN_NORM);
      } else {

         if ( (random() < 0.70000) ) {

            sound ( self, CHAN_VOICE, "archer/growl2.wav", 1.00000, ATTN_NORM);
         } else {

            sound ( self, CHAN_VOICE, "archer/growl3.wav", 1.00000, ATTN_NORM);

         }

      }

   }
   if ( (self.spawnflags & ARCHER_STUCK) ) {

      self.frame = 77.00000;
      ai_walk ( 0.00000);
   } else {

      ai_walk ( 2.30000);

   }
};


void  ()archer_stand =  {
   AdvanceFrame( 159.00000, 176.00000);
   if ( (random() < 0.50000) ) {

      archer_check_defense ( );
      ai_stand ( );

   }
};


void  ()monster_archer =  {
   if ( deathmatch ) {

      remove ( self);
      return ;

   }
   if ( !(self.flags2 & FL_SUMMONED) ) {

      precache_archer ( );

   }
   CreateEntityNew ( self, ENT_ARCHER, "models/archer.mdl", archer_die);
   self.th_stand = archer_stand;
   self.th_walk = archer_walk;
   self.th_run = archer_run;
   self.th_melee = archerdraw;
   self.th_missile = archerdraw;
   self.th_pain = archer_pain;
   self.decap = 0.00000;
   self.headmodel = "models/archerhd.mdl";
   self.mintel = 7.00000;
   self.monsterclass = CLASS_GRUNT;
   self.experience_value = 25.00000;
   self.health = 80.00000;
   self.flags |= FL_MONSTER;
   self.yaw_speed = 10.00000;
   self.view_ofs = '0.00000 0.00000 40.00000';
   walkmonster_start ( );
};


void  ()monster_archer_lord =  {
   if ( deathmatch ) {

      remove ( self);
      return ;

   }
   if ( !(self.flags2 & FL_SUMMONED) ) {

      precache_model ( "models/archer.mdl");
      precache_model ( "models/archerhd.mdl");
      precache_model ( "models/gspark.spr");
      precache_sound ( "archer/arrowg.wav");
      precache_sound ( "archer/arrowr.wav");
      precache_sound ( "archer/growl2.wav");
      precache_sound ( "archer/growl3.wav");
      precache_sound ( "archer/pain2.wav");
      precache_sound ( "archer/sight2.wav");
      precache_sound ( "archer/death2.wav");
      precache_sound ( "archer/draw.wav");

   }
   CreateEntityNew ( self, ENT_ARCHER, "models/archer.mdl", archer_die);
   self.th_stand = archer_stand;
   self.th_walk = archer_walk;
   self.th_run = archer_run;
   self.th_melee = archerdraw;
   self.th_missile = archerdraw;
   self.th_pain = archer_pain;
   self.decap = 0.00000;
   self.headmodel = "models/archerhd.mdl";
   self.mintel = 7.00000;
   self.monsterclass = CLASS_HENCHMAN;
   self.experience_value = 200.00000;
   self.health = 325.00000;
   self.skin = 1.00000;
   self.flags |= FL_MONSTER;
   self.yaw_speed = 10.00000;
   self.view_ofs = '0.00000 0.00000 40.00000';
   walkmonster_start ( );
};


float  ()ArcherCheckAttack =  {
local vector spot1 = '0.00000 0.00000 0.00000';
local vector spot2 = '0.00000 0.00000 0.00000';
local entity targ;
local float chance = 0.00000;
   self.pain_finished = 0.00000;
   if ( (self.attack_finished > time) ) {

      return ( FALSE );

   }
   if ( !enemy_vis ) {

      return ( FALSE );

   }
   if ( (enemy_range == RANGE_FAR) ) {

      if ( (self.attack_state != AS_STRAIGHT) ) {

         self.attack_state = AS_STRAIGHT;
         archer_run ( );

      }
      return ( FALSE );

   }
   targ = self.enemy;
   makevectors ( self.angles);
   spot1 = ((self.origin + (v_right * 10.00000)) + (v_up * 36.00000));
   spot2 = (targ.origin + targ.view_ofs);
   traceline ( spot1, spot2, FALSE, self);
   if ( (trace_ent.thingtype >= THINGTYPE_WEBS) ) {

      traceline ( trace_endpos, spot2, FALSE, trace_ent);

   }
   if ( (trace_ent != targ) ) {

      if ( ((((trace_ent.health > 25.00000) && (trace_ent.thingtype != THINGTYPE_GLASS)) || !trace_ent.takedamage) || ((trace_ent.flags & FL_MONSTER) && (trace_ent.classname != "player_sheep"))) ) {

         self.attack_state = AS_STRAIGHT;
         return ( FALSE );

      }

   }
   enemy_range = range ( self.enemy);
   if ( (enemy_range == RANGE_MELEE) ) {

      chance = 0.40000;
   } else {

      if ( (enemy_range == RANGE_NEAR) ) {

         chance = 0.30000;
      } else {

         if ( (enemy_range == RANGE_MID) ) {

            chance = 0.20000;
         } else {

            chance = 0.00000;

         }

      }

   }
   if ( ((random() < chance) && (self.attack_state != AS_MISSILE)) ) {

      self.attack_state = AS_MISSILE;
      return ( TRUE );

   }
   if ( (enemy_range == RANGE_MID) ) {

      if ( (random(1.00000) < 0.50000) ) {

         self.attack_state = AS_SLIDING;
      } else {

         self.attack_state = AS_STRAIGHT;

      }
   } else {

      if ( (self.attack_state != AS_SLIDING) ) {

         self.attack_state = AS_SLIDING;

      }

   }
   return ( FALSE );
};


float stationary   =  1.00000;
void  ()sheep_tranA;
void  ()sheep_tranB;
void  ()sheep_graze_a;
void  ()sheep_graze_b;
void  ()sheep_gstep_a;
void  ()sheep_gstep_b;
void  ()sheep_wait;
void  ()sheep_pain;
void  ()sheep_lookdown;
void  ()sheep_look;
void  ()sheep_lookup;

void  ()restore_monster =  {
   newmis = spawn ( );
   AdvanceThinkTime(newmis,0.00000);
   newmis.think = self.th_spawn;
   newmis.skin = self.skin;
   newmis.health = self.max_health;
   remove ( self);
};


void  (float vol)sheep_sound =  {
local float r = 0.00000;
local string playsound;
   if ( ((self.noise != "") && (self.classname != "player")) ) {

      playsound = self.noise;
   } else {

      r = rint ( random(1.00000,3.00000));
      if ( (r == 1.00000) ) {

         playsound = "misc/sheep1.wav";
      } else {

         if ( (r == 2.00000) ) {

            playsound = "misc/sheep2.wav";
         } else {

            playsound = "misc/sheep3.wav";

         }

      }

   }
   sound ( self, CHAN_VOICE, playsound, vol, ATTN_NORM);
   self.pain_finished = (time + 1.00000);
};


void  ()sheep_turn =  {
   if ( (random() < 0.50000) ) {

      self.angles_y += ((random() * self.yaw_speed) + (self.yaw_speed / 2.00000));
   } else {

      self.angles_y -= ((random() * self.yaw_speed) + (self.yaw_speed / 2.00000));

   }
};


void  (float dist)sheep_move =  {
local vector best_yaw = '0.00000 0.00000 0.00000';
   best_yaw = normalize ( (self.goalentity.origin - self.origin));
   best_yaw = vectoangles ( best_yaw);
   self.ideal_yaw = best_yaw_y;
   ChangeYaw ( );
   movetogoal ( dist);
};


void  ()sheep_think =  {
   MonsterCheckContents ( );
   if ( ((!(self.spawnflags & stationary) && (((self.think == sheep_trot) || (self.think == sheep_gstep_a)) || (self.think == sheep_gstep_b))) && (random() < 0.10000)) ) {

      sheep_turn ( );

   }
   if ( (((random() < 0.10000) && (random() < 0.20000)) && (self.pain_finished < time)) ) {

      sheep_sound ( random(0.20000,0.80000));

   }
   if ( (self.flags & FL_ONGROUND) ) {

      self.last_onground = time;

   }
};


void  ()sheep_tranA =  {
local float r = 0.00000;
   AdvanceFrame( 202.00000, 211.00000);
   if ( self.target ) {

      sheep_move ( 3.00000);
   } else {

      if ( !walkmove ( self.angles_y, 3.00000, FALSE) ) {

         sheep_turn ( );

      }

   }
   sheep_think ( );
   if ( cycle_wrapped ) {

      r = rint ( random(1.00000,3.00000));
      if ( (r == 1.00000) ) {

         sheep_wait ( );
      } else {

         if ( (r == 2.00000) ) {

            sheep_tranB ( );
         } else {

            if ( (r == 3.00000) ) {

               sheep_lookdown ( );

            }

         }

      }

   }
};


void  ()sheep_tranB =  {
   AdvanceFrame( 212.00000, 223.00000);
   if ( self.target ) {

      sheep_move ( 3.00000);
   } else {

      if ( !walkmove ( self.angles_y, 3.00000, FALSE) ) {

         sheep_turn ( );

      }

   }
   sheep_think ( );
   if ( cycle_wrapped ) {

      sheep_trot ( );

   }
};


void  ()sheep_graze_a =  {
   AdvanceFrame( 0.00000, 39.00000);
   sheep_think ( );
   if ( (((self.frame == 8.00000) && (random() < 0.50000)) && !(self.spawnflags & 1.00000)) ) {

      sheep_gstep_b ( );
   } else {

      if ( (cycle_wrapped && (random() < 0.50000)) ) {

         sheep_lookup ( );

      }

   }
};


void  ()sheep_graze_b =  {
   AdvanceFrame( 40.00000, 79.00000);
   sheep_think ( );
   if ( (((self.frame == 48.00000) && (random() < 0.50000)) && !(self.spawnflags & 1.00000)) ) {

      sheep_gstep_a ( );

   }
};


void  ()sheep_gstep_a =  {
local float r = 0.00000;
   AdvanceFrame( 80.00000, 100.00000);
   sheep_think ( );
   if ( self.target ) {

      sheep_move ( 0.30000);
   } else {

      if ( !walkmove ( self.angles_y, 0.30000, FALSE) ) {

         sheep_turn ( );

      }

   }
   if ( cycle_wrapped ) {

      r = (rint ( random()) + 1.00000);
      if ( (r == 1.00000) ) {

         sheep_graze_a ( );
      } else {

         sheep_gstep_b ( );

      }

   }
};


void  ()sheep_gstep_b =  {
local float r = 0.00000;
   AdvanceFrame( 101.00000, 121.00000);
   sheep_think ( );
   if ( self.target ) {

      sheep_move ( 0.30000);
   } else {

      if ( !walkmove ( self.angles_y, 0.30000, FALSE) ) {

         sheep_turn ( );

      }

   }
   if ( cycle_wrapped ) {

      r = (rint ( random()) + 1.00000);
      if ( (r == 1.00000) ) {

         sheep_graze_b ( );
      } else {

         sheep_gstep_a ( );

      }

   }
};


void  ()sheep_trot =  {
   AdvanceFrame( 224.00000, 233.00000);
   if ( self.target ) {

      sheep_move ( 3.00000);
   } else {

      if ( !walkmove ( self.angles_y, 3.00000, FALSE) ) {

         sheep_turn ( );

      }

   }
   sheep_think ( );
   if ( cycle_wrapped ) {

      sheep_tranA ( );

   }
};


void  ()sheep_wait =  {
local float r = 0.00000;
   AdvanceFrame( 234.00000, 249.00000);
   sheep_think ( );
   if ( cycle_wrapped ) {

      r = (rint ( random(2.00000)) + 1.00000);
      if ( (r == 1.00000) ) {

         sheep_wait ( );
      } else {

         if ( ((r == 2.00000) && !(self.spawnflags & 1.00000)) ) {

            sheep_tranB ( );
         } else {

            if ( (r == 3.00000) ) {

               sheep_lookdown ( );

            }

         }

      }

   }
};


void  ()sheep_pain =  {
local float r = 0.00000;
   AdvanceFrame( 194.00000, 201.00000);
   ai_pain ( 1.00000);
   if ( cycle_wrapped ) {

      r = (rint ( random(2.00000)) + 1.00000);
      if ( (r == 1.00000) ) {

         sheep_wait ( );
      } else {

         if ( ((r == 2.00000) && !(self.spawnflags & 1.00000)) ) {

            sheep_tranB ( );
         } else {

            if ( (r == 3.00000) ) {

               sheep_lookdown ( );

            }

         }

      }
   } else {

      if ( (self.frame == 194.00000) ) {

         sheep_sound ( 1.00000);

      }

   }
};


void  ()sheep_lookdown =  {
local float r = 0.00000;
   AdvanceFrame( 133.00000, 122.00000);
   if ( cycle_wrapped ) {

      r = (rint ( random(4.00000)) + 1.00000);
      if ( (r == 1.00000) ) {

         sheep_graze_a ( );
      } else {

         if ( (r == 2.00000) ) {

            sheep_graze_b ( );
         } else {

            if ( ((r == 3.00000) && !(self.spawnflags & 1.00000)) ) {

               sheep_gstep_a ( );
            } else {

               if ( ((r == 4.00000) && !(self.spawnflags & 1.00000)) ) {

                  sheep_gstep_b ( );
               } else {

                  sheep_lookup ( );

               }

            }

         }

      }

   }
};


void  ()sheep_look =  {
local float r = 0.00000;
   AdvanceFrame( 134.00000, 193.00000);
   sheep_think ( );
   if ( cycle_wrapped ) {

      r = (rint ( random(2.00000)) + 1.00000);
      if ( (r == 1.00000) ) {

         sheep_wait ( );
      } else {

         if ( ((r == 2.00000) && !(self.spawnflags & 1.00000)) ) {

            sheep_tranB ( );
         } else {

            if ( (r == 3.00000) ) {

               sheep_lookdown ( );

            }

         }

      }

   }
};


void  ()sheep_lookup =  {
   AdvanceFrame( 122.00000, 133.00000);
   sheep_think ( );
   if ( cycle_wrapped ) {

      sheep_look ( );

   }
};


void  ()monster_sheep_bite =  {
   makevectors ( self.angles);
   traceline ( (self.origin + self.view_ofs), ((self.origin + self.view_ofs) + (v_forward * 36.00000)), FALSE, self);
   if ( trace_ent.takedamage ) {

      sound ( self, CHAN_VOICE, "spider/bite.wav", 1.00000, ATTN_NORM);
      SpawnPuff ( trace_endpos, '0.00000 0.00000 0.00000', 3.00000, trace_ent);
      T_Damage ( trace_ent, self, self, 5.00000);
      self.attack_finished = (time + random(0.20000,1.00000));

   }
};


void  ()monster_sheep_run =  {
   AdvanceFrame( 224.00000, 233.00000);
   MonsterCheckContents ( );
   if ( (!(self.enemy.flags2 & FL_ALIVE) || !visible ( self.enemy)) ) {

      self.think = sheep_trot;
      AdvanceThinkTime(self,0.00000);
   } else {

      if ( ((random() < 0.10000) && (random() < 0.20000)) ) {

         sheep_sound ( 1.00000);

      }
      ai_face ( );
      movetogoal ( 4.00000);
      if ( infront ( self.enemy) ) {

         if ( ((range ( self.enemy) == RANGE_MELEE) && (self.attack_finished < time)) ) {

            monster_sheep_bite ( );

         }

      }

   }
};


void  ()player_sheep =  {
local float r = 0.00000;
   if ( (self.th_spawn == SUB_Null) ) {

      self.th_spawn = player_sheep;
   } else {

      self.health = self.max_health;
      if ( (self.health > 25.00000) ) {

         self.health = 25.00000;

      }

   }
   CreateEntityNew ( self, ENT_SHEEP, "models/sheep.mdl", chunk_death);
   self.th_pain = sheep_pain;
   self.touch = obj_push;
   self.flags |= FL_PUSH;
   self.flags2 |= FL_ALIVE;
   self.yaw_speed = 2.00000;
   r = rint ( random(1.00000,3.00000));
   if ( (r == 1.00000) ) {

      self.noise = "misc/sheep1.wav";
   } else {

      if ( (r == 2.00000) ) {

         self.noise = "misc/sheep2.wav";
      } else {

         self.noise = "misc/sheep3.wav";

      }

   }
   if ( self.enemy ) {

      self.think = monster_sheep_run;
   } else {

      r = rint ( random(1.00000,11.00000));
      if ( (r == 1.00000) ) {

         self.think = sheep_graze_a;
      } else {

         if ( (r == 2.00000) ) {

            self.think = sheep_graze_b;
         } else {

            if ( ((r == 3.00000) && !(self.spawnflags & 1.00000)) ) {

               self.think = sheep_gstep_a;
            } else {

               if ( ((r == 4.00000) && !(self.spawnflags & 1.00000)) ) {

                  self.think = sheep_gstep_b;
               } else {

                  if ( (r == 5.00000) ) {

                     self.think = sheep_look;
                  } else {

                     if ( (r == 6.00000) ) {

                        self.think = sheep_lookup;
                     } else {

                        if ( ((r == 7.00000) && !(self.spawnflags & 1.00000)) ) {

                           self.think = sheep_trot;
                        } else {

                           if ( (r == 8.00000) ) {

                              self.think = sheep_wait;
                           } else {

                              if ( (r == 9.00000) ) {

                                 self.think = sheep_lookdown;
                              } else {

                                 if ( ((r == 10.00000) && !(self.spawnflags & 1.00000)) ) {

                                    self.think = sheep_tranA;
                                 } else {

                                    if ( !(self.spawnflags & 1.00000) ) {

                                       self.think = sheep_tranB;

                                    }

                                 }

                              }

                           }

                        }

                     }

                  }

               }

            }

         }

      }

   }
   if ( !self.think ) {

      self.think = sheep_wait;

   }
   self.th_stand = self.think;
   self.th_walk = self.think;
   walkmonster_start ( );
};

void  ()player_sheep_run;

void  ()player_sheep_snout_slowpuff =  {
   self.wfs = advanceweaponframe ( 22.00000, 31.00000);
   self.th_weapon = player_sheep_snout_slowpuff;
};


void  ()player_sheep_snout_fastpuff =  {
   self.wfs = advanceweaponframe ( 17.00000, 21.00000);
   self.th_weapon = player_sheep_snout_fastpuff;
   if ( (self.wfs == WF_CYCLE_WRAPPED) ) {

      self.weaponframe_cnt += 1.00000;

   }
   if ( (self.weaponframe_cnt > 5.00000) ) {

      self.weaponframe_cnt = 0.00000;
      player_sheep_snout_slowpuff ( );

   }
};


void  ()player_sheep_snout_bite =  {
   self.wfs = advanceweaponframe ( 8.00000, 16.00000);
   self.th_weapon = player_sheep_snout_bite;
   if ( (self.wfs == WF_CYCLE_WRAPPED) ) {

      player_sheep_snout_fastpuff ( );

   }
};


void  ()player_sheep_snout_pain1 =  {
   self.wfs = advanceweaponframe ( 0.00000, 3.00000);
   self.th_weapon = player_sheep_snout_pain1;
   if ( (self.wfs == WF_CYCLE_WRAPPED) ) {

      player_sheep_snout_fastpuff ( );

   }
};


void  ()player_sheep_snout_pain2 =  {
   self.wfs = advanceweaponframe ( 4.00000, 7.00000);
   self.th_weapon = player_sheep_snout_pain2;
   if ( (self.wfs == WF_CYCLE_WRAPPED) ) {

      player_sheep_snout_fastpuff ( );

   }
};


void  ()player_sheep_stand =  {
   AdvanceFrame( 234.00000, 249.00000);
   self.th_weapon ( );
   if ( (self.velocity_x || self.velocity_y) ) {

      self.think = player_sheep_run;

   }
};


void  ()player_sheep_run =  {
   AdvanceFrame( 224.00000, 233.00000);
   self.th_weapon ( );
   if ( (!self.velocity_x && !self.velocity_y) ) {

      self.think = player_sheep_stand;

   }
};


void  ()player_sheep_baa =  {
   self.th_weapon = player_sheep_snout_bite;
   self.th_weapon ( );
   traceline ( (self.origin + self.view_ofs), ((self.origin + self.view_ofs) + (v_forward * 36.00000)), FALSE, self);
   if ( trace_ent.takedamage ) {

      sound ( self, CHAN_VOICE, "spider/bite.wav", 1.00000, ATTN_NORM);
      SpawnPuff ( trace_endpos, '0.00000 0.00000 0.00000', 3.00000, trace_ent);
      T_Damage ( trace_ent, self, self, 5.00000);
   } else {

      sheep_sound ( 1.00000);

   }
   self.attack_finished = (time + 0.50000);
   if ( (!self.velocity_x && !self.velocity_y) ) {

      self.think = player_sheep_stand;
   } else {

      self.think = player_sheep_run;

   }
   AdvanceThinkTime(self,0.00000);
};


void  ()player_sheep_pain =  {
   AdvanceFrame( 194.00000, 201.00000);
   if ( (self.pain_finished < time) ) {

      if ( (random() < 0.50000) ) {

         self.th_weapon = player_sheep_snout_pain1;
      } else {

         self.th_weapon = player_sheep_snout_pain2;

      }

   }
   self.th_weapon ( );
   if ( cycle_wrapped ) {

      if ( (!self.velocity_x && !self.velocity_y) ) {

         self.think = player_sheep_stand;
      } else {

         self.think = player_sheep_run;

      }
   } else {

      if ( (self.frame == 194.00000) ) {

         sheep_sound ( 1.00000);

      }

   }
};


void  ()player_sheep_jump =  {
   AdvanceFrame( 224.00000, 233.00000);
   self.th_weapon ( );
   if ( cycle_wrapped ) {

      if ( (!self.velocity_x && !self.velocity_y) ) {

         self.think = player_sheep_stand;
      } else {

         self.think = player_sheep_run;

      }

   }
};


void  (entity loser)Polymorph =  {
   sound ( loser, CHAN_VOICE, "misc/sheepfly.wav", 1.00000, ATTN_NORM);
   loser.sheep_time = (time + 30.00000);
   GenerateTeleportEffect ( loser.origin, 1.00000);
   if ( (loser.classname == "player") ) {

      if ( (loser.artifact_active & ART_TOMEOFPOWER) ) {

         loser.tome_time = 0.00000;

      }
      if ( (loser.hull != HULL_CROUCH) ) {

         if ( loser.hasted ) {

            loser.hasted *= 0.60000;
         } else {

            loser.hasted = 0.60000;

         }

      }
      loser.mass = 3.00000;
      if ( (loser.health > 25.00000) ) {

         loser.health = 25.00000;

      }
      loser.th_missile = player_sheep_baa;
      loser.th_melee = player_sheep_baa;
      loser.th_stand = player_sheep_stand;
      loser.th_run = player_sheep_run;
      loser.th_walk = player_sheep_run;
      loser.th_pain = player_sheep_pain;
      loser.th_jump = player_sheep_jump;
      setmodel ( loser, "models/sheep.mdl");
      setsize ( loser, '-16.00000 -16.00000 0.00000', '16.00000 16.00000 28.00000');
      loser.model = "models/sheep.mdl";
      loser.th_weapon = player_sheep_snout_pain1;
      loser.hull = HULL_CROUCH;
      loser.view_ofs = '0.00000 0.00000 24.00000';
      loser.proj_ofs = '0.00000 0.00000 18.00000';
      loser.weaponmodel = "models/snout.mdl";
      loser.weaponframe = 0.00000;
      loser.sheep_sound_time = FALSE;
      loser.think = player_sheep_stand;
      AdvanceThinkTime(loser,0.00000);
   } else {

      sound ( loser, CHAN_BODY, "misc/null.wav", 1.00000, ATTN_NONE);
      sound ( loser, CHAN_WEAPON, "misc/null.wav", 1.00000, ATTN_NONE);
      sound ( loser, CHAN_ITEM, "misc/null.wav", 1.00000, ATTN_NONE);
      newmis = spawn ( );
      setorigin ( newmis, loser.origin);
      newmis.th_spawn = loser.th_spawn;
      newmis.skin = 0.00000;
      newmis.oldskin = loser.skin;
      newmis.max_health = loser.health;
      if ( !loser.enemy ) {

         newmis.enemy = self.owner;
      } else {

         newmis.enemy = loser.enemy;

      }
      newmis.goalentity = newmis.enemy;
      newmis.angles = loser.angles;
      remove ( loser);
      newmis.flags2 |= FL_SUMMONED;
      newmis.spawnflags |= NO_DROP;
      newmis.think = player_sheep;
      AdvanceThinkTime(newmis,0.00000);

   }
};


void  ()poly_touch =  {
   if ( ((other.monsterclass >= CLASS_BOSS) && (other != self.owner)) ) {

      self.velocity = (normalize ( (((self.owner.absmin + self.owner.absmax) * 0.50000) - self.origin)) * 700.00000);
      self.owner = other;
   } else {

      if ( (((other.flags2 & FL_ALIVE) && (other.model != "models/sheep.mdl")) && (other.classname != "monster_golem_crystal")) ) {

         self.touch = SUB_Null;
         Polymorph ( other);
         remove ( self);
      } else {

         if ( (((other.movetype != MOVETYPE_FLYMISSILE) && (other.movetype != MOVETYPE_BOUNCE)) && (other.movetype != MOVETYPE_BOUNCEMISSILE)) ) {

            self.touch = SUB_Null;
            particleexplosion ( self.origin, random(144.00000,159.00000), (self.absmax_z - self.absmin_z), 10.00000);
            remove ( self);

         }

      }

   }
};


void  ()polymorph_anim =  {
   AdvanceFrame( 0.00000, 3.00000);
   particle4 ( self.origin, 7.00000, random(144.00000,159.00000), PARTICLETYPE_EXPLODE2, random(1.00000,5.00000));
};


void  (float ofs)FirePoly =  {
   makevectors ( self.v_angle);
   newmis = spawn ( );
   newmis.movetype = MOVETYPE_FLYMISSILE;
   newmis.solid = SOLID_BBOX;
   newmis.owner = self;
   newmis.touch = poly_touch;
   newmis.speed = 700.00000;
   newmis.velocity = ((v_forward * newmis.speed) + (v_right * ofs));
   newmis.drawflags = MLS_POWERMODE;
   newmis.think = polymorph_anim;
   AdvanceThinkTime(newmis,0.00000);
   setmodel ( newmis, "models/polymrph.spr");
   setsize ( newmis, '0.00000 0.00000 0.00000', '0.00000 0.00000 0.00000');
   setorigin ( newmis, ((self.origin + self.proj_ofs) + (v_forward * 10.00000)));
};


void  ()Use_Polymorph =  {
   FirePoly ( -150.00000);
   FirePoly ( -75.00000);
   FirePoly ( 0.00000);
   FirePoly ( 75.00000);
   FirePoly ( 150.00000);
   self.cnt_polymorph -= 1.00000;
};


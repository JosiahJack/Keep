float MONSTER_STAND_GROUND   =  1.00000;
float MONSTER_HOVER   =  2.00000;
float SF_IMP_DORMANT   =  16.00000;
float PICKUP   =  32.00000;
void  ()imp_fly;
void  ()imp_hover;
void  ()imp_abort_swoop;
void  ()imp_touch;
float  ()imp_find_target;
float imp_up_amounts [23]   = { 0.00000,
    0.00000,    0.00000,    0.00000,    0.00000,
    0.00000,    0.00000,    0.00000,    1.00000,
    2.00000,    2.00000,    2.00000,    3.00000,
    3.00000,    3.00000,    3.00000,    4.00000,
    4.00000,    5.00000,    6.00000,    7.00000,
    5.00000,    2.00000};
float imp_fly_amounts [20]   = { -0.40000,
    -0.20000,    0.00000,    0.00000,    0.20000,
    0.40000,    0.40000,    0.60000,    0.60000,
    0.80000,    0.60000,    0.40000,    0.00000,
    0.00000,    -0.20000,    -0.40000,    -0.80000,
    -0.80000,    -0.80000,    -0.40000};

void  ()imp_drop =  {
   self.attack_state = AS_STRAIGHT;
   self.enemy.flags ^= FL_FLY;
   if ( (self.classname == "monster_imp_lord") ) {

      if ( (self.enemy.classname != "player") ) {

         self.enemy.health = 10.00000;

      }
      self.enemy.movetype = MOVETYPE_BOUNCE;
      self.enemy.mass = 10000.00000;
      self.enemy.velocity_z = -300.00000;

   }
};


void  ()summoned_imp_die =  {
   AdvanceFrame( 77.00000, 55.00000);
   if ( (self.health < -40.00000) ) {

      chunk_death ( );
      return ;

   }
   if ( (self.frame == 77.00000) ) {

      self.velocity = '0.00000 0.00000 0.00000';
      self.effects = EF_DIMLIGHT;
      self.movetype = MOVETYPE_NOCLIP;
      self.drawflags = SCALE_ORIGIN_CENTER;
      self.flags = 0.00000;
      self.solid = SOLID_NOT;
      self.avelocity_y = -200.00000;
      self.count = 0.00000;
      sound ( self, CHAN_VOICE, "imp/diebig.wav", 1.00000, ATTN_NORM);

   }
   self.velocity = '0.00000 0.00000 0.00000';
   self.scale -= 0.02500;
   self.avelocity_y -= 10.00000;
   self.count += 1.00000;
   if ( (self.count == 4.00000) ) {

      self.count = 0.00000;
   } else {

      if ( (self.frame < 77.00000) ) {

         self.frame += 1.00000;

      }

   }
   if ( (self.frame == 55.00000) ) {

      sound ( self, CHAN_BODY, "items/itmspawn.wav", 1.00000, ATTN_NORM);
      CreateRedFlash ( self.origin);
      remove ( self);

   }
};


void  ()imp_die =  {
   self.touch = SUB_Null;
   if ( (self.health < -30.00000) ) {

      sound ( self, CHAN_BODY, "misc/null.wav", 1.00000, ATTN_NONE);
      chunk_death ( );
      return ;

   }
   if ( (self.frame != 13.00000) ) {

      AdvanceFrame ( 0.00000, 13.00000);

   }
   if ( (self.frame == 0.00000) ) {

      self.flags ^= FL_ONGROUND;
      if ( (self.skin == 3.00000) ) {

         sound ( self, CHAN_BODY, "imp/diebig.wav", 1.00000, ATTN_NORM);
      } else {

         sound ( self, CHAN_BODY, "imp/die.wav", 1.00000, ATTN_NORM);

      }
      makevectors ( self.angles);
      self.movetype = MOVETYPE_BOUNCE;
      self.velocity_z = 0.00000;
      self.velocity += (v_forward * 80.00000);
      if ( (self.attack_state == AS_FERRY) ) {

         imp_drop ( );

      }

   }
   if ( (self.frame == 7.00000) ) {

      if ( (self.flags & FL_ONGROUND) ) {

         sound ( self, CHAN_BODY, "player/land.wav", 1.00000, ATTN_NORM);
         self.velocity_y = 0.00000;
         self.velocity_x = 0.00000;
      } else {

			self.frame = 6.00000;

      }

   }
   MonsterCheckContents ( );
   if ( ((self.frame == 13.00000) && (self.flags & FL_ONGROUND)) ) {

      MakeSolidCorpse ( );
   } else {

      if ( (self.health < -30.00000) ) {

         chunk_death ( );
      } else {

         if ( (self.health > 0.00000) ) {

            self.takedamage = DAMAGE_YES;
            self.flags |= FL_FLY;
            self.flags2 |= FL_ALIVE;
            self.solid = SOLID_SLIDEBOX;
            self.movetype = MOVETYPE_FLY;
            if ( (self.classname == "monster_imp_lord") ) {

               setsize ( self, '-32.00000 -32.00000 0.00000', '32.00000 32.00000 56.00000');
               self.hull = HULL_SCORPION;
            } else {

               setsize ( self, '-16.00000 -16.00000 0.00000', '16.00000 16.00000 36.00000');
               self.hull = HULL_CROUCH;

            }
            self.th_stand ( );
            return ;
         } else {

            self.think = imp_die;
            if ( ((self.frame == 6.00000) || (self.frame == 7.00000)) ) {

               AdvanceThinkTime(self,random(0.05000,0.21700));
            } else {

               AdvanceThinkTime(self,HX_FRAME_TIME);

            }

         }

      }

   }
};


void  ()imp_die_init =  {
   setsize ( self, '-16.00000 -16.00000 0.00000', '16.00000 16.00000 24.00000');
   self.hull = HULL_CROUCH;
   imp_die ( );
};


void  ()imp_up_down =  {
local vector end_vec = '0.00000 0.00000 0.00000';
local vector vec1 = '0.00000 0.00000 0.00000';
   if ( ((self.velocity_z > -10.00000) && (self.velocity_z < 10.00000)) ) {

      self.velocity_z = 0.00000;
      if ( ((random() < 0.30000) || (self.attack_state == AS_SLIDING)) ) {

         makevectors ( self.angles);
         if ( (random() < 0.50000) ) {

            vec1 = (self.origin + (v_up * -48.00000));
            traceline ( self.origin, vec1, FALSE, self);
            if ( (trace_fraction == 1.00000) ) {

               end_vec = (vec1 + (v_forward * 32.00000));
               traceline ( vec1, end_vec, FALSE, self);
               if ( ((trace_fraction == 1.00000) || (random() < 0.50000)) ) {

                  self.velocity_z = (self.speed * -7.00000);

               }

            }
         } else {

            vec1 = (self.origin + (v_up * 88.00000));
            traceline ( self.origin, vec1, FALSE, self);
            if ( (trace_fraction == 1.00000) ) {

               end_vec = (vec1 + (v_forward * 32.00000));
               traceline ( vec1, end_vec, FALSE, self);
               if ( ((trace_fraction == 1.00000) || (random() < 0.50000)) ) {

                  self.velocity_z = (self.speed * 7.00000);

               }

            }

         }
         self.flags ^= FL_ONGROUND;

      }

   }
};


void  ()imp_ferry =  {
local float dist = 0.00000;
local vector org = '0.00000 0.00000 0.00000';
   movetogoal ( self.speed);
   self.velocity_z = (self.goalentity.origin_z - self.origin_z);
   if ( (fabs ( self.velocity_z) > (self.speed * 30.00000)) ) {

      if ( (self.velocity_z < 0.00000) ) {

         self.velocity_z = (self.speed * -30.00000);
      } else {

         self.velocity_z = (self.speed * 30.00000);

      }

   }
   self.flags ^= FL_ONGROUND;
   org = self.goalentity.origin;
   dist = vlen ( (self.origin - org));
   if ( (dist <= self.size_x) ) {

      imp_drop ( );
      return ;

   }
   org = self.enemy.origin;
   org_z = self.enemy.absmax_z;
   dist = vlen ( (self.origin - org));
   if ( (dist > 200.00000) ) {

      imp_drop ( );
      return ;
   } else {

      self.enemy.velocity = ((normalize ( (self.origin - org)) * dist) * 5.00000);

   }
   self.enemy.angles = self.angles;
   MonsterCheckContents ( );
};


void  ()imp_pick_up =  {
   self.attack_state = AS_FERRY;
   self.goalentity = find ( world, targetname, self.target);
   self.enemy.flags |= FL_FLY;
};


void  ()imp_set_speeds =  {
local float anglediff = 0.00000;
local float dist = 0.00000;
   if ( (pointcontents ( (self.origin + self.view_ofs)) == CONTENT_WATER) ) {

      dist = 4.00000;
   } else {

      dist = 8.00000;

   }
   anglediff = fabs ( (self.angles_y - self.ideal_yaw));
   if ( (anglediff > 20.00000) ) {

      dist = (dist / 1.50000);

   }
   self.level = (imp_fly_amounts->(self.frame - 35.00000));
   self.speed = (dist + ((self.level * 4.00000) * self.scale));
   if ( !visible ( self.enemy) ) {

      if ( self.mintel ) {

         SetNextWaypoint ( );

      }
      if ( (((self.search_time < time) && (self.goalentity == self.enemy)) && (self.trigger_field.classname == "waypoint")) ) {

         self.goalentity = self.trigger_field;

      }
      self.level *= 4.00000;
   } else {

      self.search_time = (time + 5.00000);
      self.goalentity = self.enemy;
      self.wallspot = ((self.enemy.absmin + self.enemy.absmax) * 0.50000);

   }
};


float  ()imp_check_too_close =  {
local float enemy_zdiff = 0.00000;
local float enemy_hdist = 0.00000;
   if ( !visible ( self.enemy) ) {

      return ( FALSE );

   }
   if ( (self.attack_state == AS_FERRY) ) {

      return ( FALSE );

   }
   enemy_zdiff = fabs ( (self.origin_z - self.enemy.origin_z));
   enemy_hdist = vhlen ( (self.enemy.origin - self.origin));
   if ( ((enemy_zdiff >= 77.00000) && (enemy_hdist <= 77.00000)) ) {

      return ( TRUE );

   }
   return ( FALSE );
};


void  ()imp_move =  {
local float too_close = 0.00000;
local vector go_dir = '0.00000 0.00000 0.00000';
local float r = 0.00000;
local float minspeed = 0.00000;
local float maxspeed = 0.00000;
   if ( ((((self.skin == 3.00000) && (self.enemy == self.controller)) && (vlen ( (self.enemy.origin - self.origin)) < 128.00000)) || ((self.goalentity == world) || (self.enemy == world))) ) {

      self.think = self.th_stand;
      return ;

   }
   if ( (self.attack_state != AS_FERRY) ) {

      checkenemy ( );

   }
   self.velocity = (self.velocity * (1.00000 / 1.05000));
   if ( imp_check_too_close ( ) ) {

      self.ideal_yaw = self.angles_y;
      too_close = TRUE;
   } else {

      ai_face ( );

   }
   imp_set_speeds ( );
   if ( (self.attack_state == AS_FERRY) ) {

      imp_ferry ( );
      return ;

   }
   if ( (self.attack_state == AS_STRAIGHT) ) {

      if ( too_close ) {

         if ( !walkmove ( self.angles_y, self.speed, FALSE) ) {

            movetogoal ( self.speed);

         }
      } else {

         movetogoal ( self.speed);

      }

   }
   if ( (self.attack_state == AS_SLIDING) ) {

      enemy_yaw = vectoyaw ( (self.goalentity.origin - self.origin));
      movedist = self.speed;
      ai_run_slide ( );

   }
   movestep ( 0.00000, 0.00000, self.level, FALSE);
   if ( !check_z_move ( self.level) ) {

      imp_up_down ( );

   }
   if ( (random() < 0.20000) ) {

      if ( ((self.enemy != world) && (self.search_time >= time)) ) {

         enemy_vis = visible ( self.enemy);
         if ( (!enemy_vis || !clear_path ( self.enemy, FALSE)) ) {

            makevectors ( self.angles);
            minspeed = (100.00000 * self.scale);
            maxspeed = (300.00000 * self.scale);
            r = random();
            if ( (r < 0.25000) ) {

               go_dir = check_axis_move ( v_right, minspeed, maxspeed);
            } else {

               if ( (r <= 0.50000) ) {

                  go_dir = check_axis_move ( v_up, minspeed, maxspeed);
               } else {

                  if ( (r <= 0.75000) ) {

                     go_dir = check_axis_move ( ((v_right + v_up) * 0.50000), minspeed, maxspeed);
                  } else {

                     go_dir = check_axis_move ( (((v_right * -1.00000) + v_up) * 0.50000), minspeed, maxspeed);

                  }

               }

            }
            if ( (go_dir != '0.00000 0.00000 0.00000') ) {

               if ( (r < 0.25000) ) {

                  self.velocity_x = go_dir_x;
                  self.velocity_y = go_dir_y;
               } else {

                  if ( (r <= 0.50000) ) {

                     self.velocity_z = go_dir_z;
                  } else {

                     self.velocity = go_dir;

                  }

               }
               self.flags ^= FL_ONGROUND;

            }

         }

      }

   }
   if ( (self.spawnflags & PICKUP) ) {

      if ( (random() < 0.20000) ) {

         if ( (self.target != "") ) {

            if ( (self.origin_z > (self.enemy.absmax_z - 8.00000)) ) {

               if ( (vlen ( ((self.enemy.origin + self.enemy.proj_ofs) - self.origin)) <= (self.size_x * 1.50000)) ) {

                  imp_pick_up ( );

               }

            }

         }

      }

   }
   MonsterCheckContents ( );
};


float  ()imp_new_action =  {
local float too_close = 0.00000;
   enemy_vis = visible ( self.enemy);
   too_close = imp_check_too_close ( );
   if ( (((((random() < 0.70000) && (self.enemy.flags2 & FL_ALIVE)) || !enemy_vis) || too_close) || (self.attack_state == AS_FERRY)) ) {

      if ( ((self.think != imp_fly) && (self.enemy != world)) ) {

         self.think = imp_fly;
         AdvanceThinkTime(self,0.00000);
         return ( TRUE );

      }
      return ( FALSE );
   } else {

      if ( (self.think != imp_hover) ) {

         self.think = imp_hover;
         AdvanceThinkTime(self,0.00000);
         return ( TRUE );

      }
      return ( FALSE );

   }
   return ( FALSE );
};


void  ()imp_strafe_left =  {
local vector dir = '0.00000 0.00000 0.00000';
   AdvanceFrame( 35.00000, 54.00000);
   ai_face ( );
   if ( cycle_wrapped ) {

      self.think = imp_fly;
      AdvanceThinkTime(self,0.00000);
      return ;

   }
   makevectors ( self.angles);
   dir = ('0.00000 0.00000 0.00000' - ((v_right * (self.frame - 35.00000)) * 30.00000));
   self.velocity_x = dir_x;
   self.velocity_y = dir_y;
   check_pos_enemy ( );
};


void  ()imp_strafe_right =  {
local vector dir = '0.00000 0.00000 0.00000';
   AdvanceFrame( 35.00000, 54.00000);
   ai_face ( );
   if ( cycle_wrapped ) {

      self.think = imp_fly;
      AdvanceThinkTime(self,0.00000);
      return ;

   }
   makevectors ( self.angles);
   dir = ((v_right * (self.frame - 35.00000)) * 30.00000);
   self.velocity_x = dir_x;
   self.velocity_y = dir_y;
   check_pos_enemy ( );
};


void  ()imp_rise =  {
   AdvanceFrame( 35.00000, 54.00000);
   check_pos_enemy ( );
   if ( (self.frame == 35.00000) ) {

      self.attack_finished = (time + 1.70000);
      self.velocity_z = 600.00000;
   } else {

      if ( ((self.frame > 48.00000) && (self.attack_finished < time)) ) {

         self.velocity_z -= 100.00000;
      } else {

         self.velocity_z += 10.00000;

      }

   }
   if ( (self.frame == 54.00000) ) {

      self.velocity_z = 0.00000;
      self.think = imp_fly;
      AdvanceThinkTime(self,0.05000);

   }
};


void  ()imp_dive =  {
   AdvanceFrame( 102.00000, 121.00000);
   check_pos_enemy ( );
   if ( (self.frame == 102.00000) ) {

      self.velocity_z = -500.00000;
   } else {

      if ( (self.frame < 114.00000) ) {

         self.velocity_z -= 20.00000;
      } else {

         self.velocity_z += 100.00000;

      }

   }
   if ( (self.frame == 121.00000) ) {

      self.velocity_z = 0.00000;
      self.think = imp_abort_swoop;
      AdvanceThinkTime(self,0.00000);

   }
};


float  ()imp_check_defense =  {
local vector org = '0.00000 0.00000 0.00000';
local vector destiny = '0.00000 0.00000 0.00000';
local vector dir = '0.00000 0.00000 0.00000';
local vector proj_spot = '0.00000 0.00000 0.00000';
local vector proj_spot_dir = '0.00000 0.00000 0.00000';
local float dist = 0.00000;
local float dot = 0.00000;
   if ( ((self.enemy.last_attack < (time - 1.00000)) || (self.attack_state == AS_FERRY)) ) {

      return ( FALSE );

   }
   if ( fov ( self, self.enemy, 45.00000) ) {

      org = (self.enemy.origin + self.enemy.proj_ofs);
      destiny = ((self.absmin + self.absmax) * 0.50000);
      dir = normalize ( (destiny - org));
      dist = vlen ( (destiny - org));
      proj_spot = (org + (dir * dist));
      proj_spot_dir = normalize ( (proj_spot - destiny));
      makevectors ( self.angles);
      dot = (proj_spot_dir * v_right);
      if ( (dot > 0.10000) ) {

         imp_strafe_left ( );
         return ( TRUE );
      } else {

         if ( (dot < -0.10000) ) {

            imp_strafe_right ( );
            return ( TRUE );

         }

      }
      dot = (proj_spot_dir * v_up);
      if ( (dot > 0.20000) ) {

         imp_dive ( );
         return ( TRUE );
      } else {

         if ( (dot < 0.00000) ) {

            imp_rise ( );
            return ( TRUE );

         }

      }
      return ( FALSE );

   }
   return ( FALSE );
};


void  ()imp_missile =  {
   if ( ((self.classname == "monster_imp_ice") || ((self.classname == "monster_imp_lord") && (random() < 0.50000))) ) {

      sound ( self, CHAN_WEAPON, "imp/shard.wav", 1.00000, ATTN_NORM);
      makevectors ( self.angles);
      do_shard ( ('14.00000 8.00000 0.00000' * self.scale), (360.00000 + (random() * 150.00000)), '0.00000 0.00000 0.00000');
      do_shard ( ('14.00000 8.00000 0.00000' * self.scale), (360.00000 + (random() * 150.00000)), (((v_forward * ((random() * 40.00000) - 20.00000)) + (v_right * ((random() * 40.00000) - 20.00000))) + (v_up * ((random() * 20.00000) - 10.00000))));
      do_shard ( ('14.00000 8.00000 0.00000' * self.scale), (360.00000 + (random() * 150.00000)), (((v_forward * ((random() * 40.00000) - 20.00000)) + (v_right * ((random() * 40.00000) - 20.00000))) + (v_up * ((random() * 20.00000) - 10.00000))));
      if ( (random() < 0.50000) ) {

         do_shard ( ('14.00000 8.00000 0.00000' * self.scale), (360.00000 + (random() * 150.00000)), (((v_forward * ((random() * 40.00000) - 20.00000)) + (v_right * ((random() * 40.00000) - 20.00000))) + (v_up * ((random() * 20.00000) - 10.00000))));

      }
      if ( (random() < 0.50000) ) {

         do_shard ( ('14.00000 8.00000 0.00000' * self.scale), (360.00000 + (random() * 150.00000)), (((v_forward * ((random() * 40.00000) - 20.00000)) + (v_right * ((random() * 40.00000) - 20.00000))) + (v_up * ((random() * 20.00000) - 10.00000))));

      }
      if ( (random() < 0.50000) ) {

         do_shard ( ('14.00000 8.00000 0.00000' * self.scale), (360.00000 + (random() * 150.00000)), (((v_forward * ((random() * 40.00000) - 20.00000)) + (v_right * ((random() * 40.00000) - 20.00000))) + (v_up * ((random() * 20.00000) - 10.00000))));

      }
   } else {

      sound ( self, CHAN_WEAPON, "imp/fireball.wav", 1.00000, ATTN_NORM);
      do_fireball ( ('14.00000 8.00000 0.00000' * self.scale));

   }
};


void  ()imp_melee =  {
local vector org = '0.00000 0.00000 0.00000';
local vector destiny = '0.00000 0.00000 0.00000';
local float dist = 0.00000;
local float damg = 0.00000;
local string hitsound;
   makevectors ( self.angles);
   org = ((self.origin + self.proj_ofs) + ((v_forward * 16.00000) * self.scale));
   destiny = ((self.enemy.absmin + self.enemy.absmax) * 0.50000);
   dist = vlen ( (destiny - org));
   traceline ( org, destiny, FALSE, self);
   if ( ((dist > (48.00000 * self.scale)) || (trace_fraction == 1.00000)) ) {

      imp_missile ( );
      return ;

   }
   if ( trace_ent.takedamage ) {

      if ( (self.skin == 3.00000) ) {

         if ( (trace_ent.thingtype == THINGTYPE_FLESH) ) {

            MeatChunks ( trace_endpos, ((v_right * random(-100.00000,-300.00000)) + '0.00000 0.00000 200.00000'), 3.00000);

         }
         hitsound = "weapons/slash.wav";
      } else {

         hitsound = "assassin/chntear.wav";

      }
      sound ( trace_ent, CHAN_AUTO, hitsound, 1.00000, ATTN_NORM);
      if ( (self.skin == 3.00000) ) {

         damg = 40.00000;
      } else {

         damg = (10.00000 * self.scale);

      }
      T_Damage ( trace_ent, self, self, damg);
   } else {

      hitsound = "weapons/gauntht2.wav";

   }
   SpawnPuff ( trace_endpos, (v_right * -100.00000), (10.00000 * self.scale), trace_ent);
   sound ( self, CHAN_AUTO, hitsound, 1.00000, ATTN_NORM);
};


void  ()imp_attack =  {
   self.last_attack = time;
   if ( (vlen ( (self.origin - self.enemy.origin)) <= (64.00000 * self.scale)) ) {

      self.v_angle = self.angles;
      imp_melee ( );
   } else {

      imp_missile ( );

   }
};


void  ()imp_attack_anim =  {
   AdvanceFrame( 14.00000, 34.00000);
   check_pos_enemy ( );
   ai_face ( );
   if ( imp_check_defense ( ) ) {

      return ;

   }
   if ( (self.frame == 30.00000) ) {

      imp_attack ( );
   } else {

      if ( cycle_wrapped ) {

         self.think = imp_fly;
         if ( (visible ( self.enemy) && (self.enemy.flags2 & FL_ALIVE)) ) {

            if ( (random() < (0.20000 + (skill / 10.00000))) ) {

               self.think = imp_attack_anim;

            }

         }
         self.attack_finished = (time + 1.00000);
         AdvanceThinkTime(self,0.00000);

      }

   }
};


void  ()imp_abort_swoop =  {
   AdvanceFrame( 141.00000, 155.00000);
   check_pos_enemy ( );
   if ( (self.velocity_x > 10.00000) ) {

      self.velocity_x /= 2.00000;
   } else {

      self.velocity_x = 0.00000;

   }
   if ( (self.velocity_x > 10.00000) ) {

      self.velocity_y /= 2.00000;
   } else {

      self.velocity_y = 0.00000;

   }
   if ( (self.frame == 155.00000) ) {

      self.attack_finished = (time + 1.00000);
      self.think = imp_fly;
      AdvanceThinkTime(self,0.00000);

   }
};


void  ()imp_swoop_end =  {
   AdvanceFrame( 126.00000, 140.00000);
   check_pos_enemy ( );
   self.flags ^= FL_ONGROUND;
   self.velocity_z += 15.00000;
   self.velocity_x /= 1.20000;
   self.velocity_y /= 1.20000;
   if ( (self.frame == 140.00000) ) {

      self.attack_finished = (time + 1.00000);
      self.velocity = '0.00000 0.00000 0.00000';
      self.yaw_speed = 8.00000;
      self.think = imp_hover;
      AdvanceThinkTime(self,0.00000);

   }
};


void  ()imp_swoop_charge =  {
local vector dir = '0.00000 0.00000 0.00000';
local vector destiny = '0.00000 0.00000 0.00000';
local vector org = '0.00000 0.00000 0.00000';
   AdvanceFrame( 122.00000, 125.00000);
   self.last_attack = time;
   check_pos_enemy ( );
   destiny = (self.enemy.origin + self.enemy.proj_ofs);
   org = ((self.absmin + self.absmax) * 0.50000);
   enemy_vis = visible ( self.enemy);
   enemy_infront = infront ( self.enemy);
   enemy_range = vlen ( (destiny - org));
   if ( ((self.enemy.last_attack > (time - 1.00000)) && fov ( self, self.enemy, 45.00000)) ) {

      self.velocity_z += 150.00000;
      imp_abort_swoop ( );
   } else {

      if ( ((enemy_vis && enemy_infront) && (enemy_range < 2000.00000)) ) {

         dir = normalize ( (destiny - org));
         self.velocity = (dir * (377.00000 + (self.count * 7.00000)));
         ai_face ( );
         self.count += 1.00000;
         if ( ((self.flags & FL_ONGROUND) || (self.count > 30.00000)) ) {

            self.flags ^= FL_ONGROUND;
            imp_abort_swoop ( );

         }
      } else {

         imp_abort_swoop ( );

      }

   }
};


void  ()imp_enter_swoop =  {
local vector vec = '0.00000 0.00000 0.00000';
local vector org = '0.00000 0.00000 0.00000';
   AdvanceFrame( 102.00000, 121.00000);
   check_pos_enemy ( );
   if ( (self.frame == 102.00000) ) {

      self.yaw_speed = 15.00000;
      self.count = 140.00000;
      self.touch = imp_touch;
      self.velocity = '0.00000 0.00000 0.00000';
      if ( (self.skin == 3.00000) ) {

         sound ( self, CHAN_VOICE, "imp/swoopbig.wav", 1.00000, ATTN_NORM);
      } else {

         sound ( self, CHAN_VOICE, "imp/swoop.wav", 1.00000, ATTN_NORM);

      }

   }
   ai_face ( );
   self.count *= 1.15000;
   if ( (self.frame >= 113.00000) ) {

      org = self.origin;
      org_z = self.absmin_z;
      vec = normalize ( ((self.enemy.origin - org) + self.enemy.proj_ofs));
      self.velocity = (vec * self.count);
      if ( (self.frame <= 114.00000) ) {

         self.velocity_y = 0.00000;
         self.velocity_x = 0.00000;

      }
      if ( (((self.absmin_z - self.enemy.absmax_z) > 50.00000) && (self.frame == 114.00000)) ) {

         self.frame = 113.00000;

      }

   }
   if ( ((self.frame == 113.00000) || (self.frame == 114.00000)) ) {

      if ( (self.flags & FL_ONGROUND) ) {

         self.flags ^= FL_ONGROUND;
         self.frame = 115.00000;
         self.count = 280.00000;

      }
      if ( ((self.origin_z - self.enemy.origin_z) < 60.00000) ) {

         self.frame = 115.00000;
         self.count = 280.00000;

      }

   }
   if ( (self.frame == 121.00000) ) {

      self.count = 0.00000;
      self.think = imp_swoop_charge;
      AdvanceThinkTime(self,0.05000);

   }
};


void  ()imp_straight_swoop =  {
   AdvanceFrame( 155.00000, 141.00000);
   check_pos_enemy ( );
   ai_face ( );
   if ( imp_check_defense ( ) ) {

      return ;

   }
   if ( (self.frame == 155.00000) ) {

      self.yaw_speed = 15.00000;
      self.count = 140.00000;
      self.velocity = '0.00000 0.00000 0.00000';
      self.touch = imp_touch;
      if ( (self.skin == 3.00000) ) {

         sound ( self, CHAN_VOICE, "imp/swoopbig.wav", 1.00000, ATTN_NORM);
      } else {

         sound ( self, CHAN_VOICE, "imp/swoop.wav", 1.00000, ATTN_NORM);

      }

   }
   if ( (self.frame == 141.00000) ) {

      self.count = 0.00000;
      self.think = imp_swoop_charge;
      AdvanceThinkTime(self,0.05000);

   }
};


void  ()imp_touch =  {
local float damg = 0.00000;
local float damg_plus = 0.00000;
local vector punch = '0.00000 0.00000 0.00000';
local vector dir = '0.00000 0.00000 0.00000';
   self.touch = SUB_Null;
   if ( (((self.frame >= 122.00000) && (self.frame <= 125.00000)) || ((self.frame >= 117.00000) && (self.frame <= 121.00000))) ) {

      self.flags ^= FL_ONGROUND;
      sound ( self, CHAN_WEAPON, "imp/swoophit.wav", 1.00000, ATTN_NORM);
      self.think = imp_swoop_end;
      if ( other.takedamage ) {

         if ( ((self.frame >= 122.00000) && (self.frame <= 125.00000)) ) {

            damg_plus = self.count;
         } else {

            damg_plus = ((self.frame - 117.00000) * 5.00000);

         }
         if ( (self.classname == "monster_imp_lord") ) {

            damg = (33.00000 + (damg_plus * 5.00000));
            T_Damage ( other, self, self.controller, damg);
            if ( (other.monsterclass < CLASS_BOSS) ) {

               other.velocity_x += (self.velocity_x * 2.00000);
               other.velocity_y += (self.velocity_y * 2.00000);
               if ( (other.movetype == MOVETYPE_FLY) ) {

                  if ( (other.flags & FL_ONGROUND) ) {

                     other.velocity_z = 200.00000;

                  }
               } else {

                  other.velocity_z = 200.00000;

               }
               other.flags ^= FL_ONGROUND;

            }
         } else {

            damg = (10.00000 + (damg_plus / 2.00000));
            T_Damage ( other, self, self, damg);

         }
         if ( ((other.classname == "player") && (other.flags2 & FL_ALIVE)) ) {

            makevectors ( other.v_angle);
            dir = (normalize ( self.velocity) * -1.00000);
            punch_y = (v_forward * dir);
            punch_z = (v_right * dir);
            punch_x = (v_up * dir);
            other.punchangle = (punch * (damg / 10.00000));

         }
      } else {

         if ( (vlen ( self.velocity) > 400.00000) ) {

            makevectors ( self.angles);
            SpawnPuff ( ((self.origin + self.proj_ofs) + (v_forward * self.absmax_x)), '0.00000 0.00000 0.00000', 10.00000, self);
            self.pain_finished = -666.00000;
            self.think = self.th_pain;

         }

      }
      self.velocity = other.velocity;
   } else {

      if ( (vlen ( self.velocity) > 300.00000) ) {

         sound ( self, CHAN_WEAPON, "imp/swoophit.wav", 1.00000, ATTN_NORM);

      }

   }
};


float  ()imp_check_attack =  {
local float enemy_hdist = 0.00000;
local float enemy_zdiff = 0.00000;
local float swoop_no_drop = 0.00000;
local vector destiny = '0.00000 0.00000 0.00000';
local vector org = '0.00000 0.00000 0.00000';
local vector min = '0.00000 0.00000 0.00000';
local vector max = '0.00000 0.00000 0.00000';
   if ( (self.enemy == world) ) {

      self.think = self.th_stand;
      return ( FALSE );

   }
   if ( ((self.enemy == self.controller) || (self.enemy == self)) ) {

      if ( !LocateTarget ( ) ) {

         return ( FALSE );

      }

   }
   if ( (self.attack_state == AS_FERRY) ) {

      return ( FALSE );

   }
   enemy_vis = visible ( self.enemy);
   if ( !enemy_vis ) {

      if ( self.mintel ) {

         SetNextWaypoint ( );

      }
      if ( (((self.search_time < time) && (self.goalentity == self.enemy)) && (self.trigger_field.classname == "waypoint")) ) {

         self.goalentity = self.trigger_field;

      }
      self.attack_state = AS_STRAIGHT;
      return ( FALSE );
   } else {

      if ( self.mintel ) {

         self.goalentity = self.enemy;
         self.wallspot = ((self.enemy.absmin + self.enemy.absmax) * 0.50000);

      }

   }
   if ( (time < self.attack_finished) ) {

      return ( FALSE );

   }
   enemy_infront = infront ( self.enemy);
   if ( !enemy_infront ) {

      return ( FALSE );

   }
   enemy_range = range ( self.enemy);
   if ( (enemy_range == RANGE_FAR) ) {

      self.attack_state = AS_STRAIGHT;
      return ( FALSE );

   }
   destiny = (self.enemy.origin + self.enemy.proj_ofs);
   org = ((self.absmin + self.absmax) * 0.50000);
   if ( !clear_path ( self.enemy, FALSE) ) {

      if ( !CanDamage ( self.enemy, self) ) {

         return ( FALSE );

      }

   }
   if ( (self.skin != 3.00000) ) {

      if ( (random() < (0.50000 - (skill / 10.00000))) ) {

         return ( FALSE );

      }

   }
   if ( !(self.spawnflags & MONSTER_STAND_GROUND) ) {

      swoop_no_drop = FALSE;
      enemy_hdist = vhlen ( (destiny - org));
      if ( (self.skin == 3.00000) ) {

         enemy_zdiff = (self.absmin_z - destiny_z);
      } else {

         enemy_zdiff = (org_z - destiny_z);

      }
      if ( ((enemy_zdiff <= 36.00000) && (random() < 0.30000)) ) {

         swoop_no_drop = TRUE;

      }
      if ( (self.skin != 3.00000) ) {

         min = '-16.00000 -16.00000 0.00000';
         max = '16.00000 16.00000 28.00000';
      } else {

         min = '-48.00000 -48.00000 42.00000';
         max = '48.00000 48.00000 42.00000';

      }
      if ( ((enemy_hdist > (70.00000 + (30.00000 * self.scale))) && ((enemy_zdiff > 36.00000) || swoop_no_drop)) ) {

         tracearea ( org, (org - ('0.00000 0.00000 1.00000' * enemy_zdiff)), min, max, FALSE, self);
         if ( ((trace_fraction == 1.00000) || swoop_no_drop) ) {

            if ( swoop_no_drop ) {

               tracearea ( org, destiny, min, max, FALSE, self);
            } else {

               tracearea ( (org - ('0.00000 0.00000 1.00000' * enemy_zdiff)), destiny, min, max, FALSE, self);

            }
            if ( (trace_ent == self.enemy) ) {

               if ( swoop_no_drop ) {

                  self.think = imp_straight_swoop;
               } else {

                  self.think = imp_enter_swoop;

               }
               AdvanceThinkTime(self,0.00000);
               return ( TRUE );

            }

         }

      }

   }
   if ( (self.skin == 0.00000) ) {

      if ( (random() < 0.50000) ) {

         return ( FALSE );

      }

   }
   self.think = imp_attack_anim;
   AdvanceThinkTime(self,0.00000);
   return ( TRUE );
};


void  ()imp_hover =  {
local float too_close = 0.00000;
   AdvanceFrame( 35.00000, 54.00000);
   if ( (self.frame == 35.00000) ) {

      if ( (pointcontents ( (self.origin + self.view_ofs)) == CONTENT_WATER) ) {

         self.noise = "hydra/turn-s.wav";
      } else {

         if ( (self.skin == 3.00000) ) {

            self.noise = "imp/flybig.wav";
         } else {

            self.noise = "imp/fly.wav";

         }

      }
      sound ( self, CHAN_BODY, self.noise, 1.00000, ATTN_NORM);

   }
   if ( (self.skin == 3.00000) ) {

      if ( (((self.lifetime < time) || !(self.controller.flags2 & FL_ALIVE)) || (self.controller.imp_count != self.imp_count)) ) {

         self.think = summoned_imp_die;
         AdvanceThinkTime(self,0.00000);
         return ;

      }

   }
   if ( self.enemy ) {

      if ( (self.attack_state != AS_FERRY) ) {

         checkenemy ( );

      }

   }
   if ( (!self.enemy || ((self.enemy == self.controller) && (self.skin == 3.00000))) ) {

      if ( imp_find_target ( ) ) {

         return ;

      }

   }
   if ( self.enemy ) {

      self.velocity = (self.velocity * (1.00000 / 1.05000));
      ai_face ( );
      imp_set_speeds ( );
      check_z_move ( self.level);
      if ( imp_check_defense ( ) ) {

         return ;

      }
      if ( imp_check_attack ( ) ) {

         return ;

      }
      if ( (self.enemy != world) ) {

         too_close = imp_check_too_close ( );
         enemy_vis = visible ( self.enemy);
         if ( ((!enemy_vis || too_close) || (self.attack_state != AS_STRAIGHT)) ) {

            self.think = imp_fly;
            AdvanceThinkTime(self,0.00000);
            return ;

         }

      }

   }
   if ( ((self.enemy != world) || (self.goalentity != world)) ) {

      if ( imp_new_action ( ) ) {

         return ;

      }

   }
   MonsterCheckContents ( );
};


void  ()stone_imp_awaken =  {
   AdvanceFrame( 61.00000, 77.00000);
   if ( (self.frame == 64.00000) ) {

      self.ideal_yaw = vectoyaw ( (self.enemy.origin - self.origin));
      self.count = 0.00000;
      setsize ( self, '-16.00000 -16.00000 0.00000', '16.00000 16.00000 36.00000');
      self.origin_z -= 14.00000;
      self.hull = HULL_CROUCH;
      self.mass = 3.00000;
      self.health = self.max_health;
      self.flags |= (FL_MONSTER | FL_FLY);
      self.movetype = MOVETYPE_FLY;
      self.takedamage = DAMAGE_YES;
      self.touch = SUB_Null;
      self.th_die = imp_die_init;
      self.spawnflags ^= SF_IMP_DORMANT;
      self.artifact_active ^= ARTFLAG_STONED;
      sound ( self, CHAN_VOICE, "fx/wallbrk.wav", 1.00000, ATTN_NORM);
      while ( (chunk_cnt < CHUNK_MAX) ) {

         CreateModelChunks ( self.size, 0.70000);
         chunk_cnt += 1.00000;

      }
      self.skin = self.oldskin;
      if ( self.skin ) {

         self.classname = "monster_imp_ice";
      } else {

         self.classname = "monster_imp_fire";

      }
      self.thingtype = THINGTYPE_FLESH;
      self.scale = 1.00000;
   } else {

      if ( (self.frame == 77.00000) ) {

         self.think = imp_fly;

      }

   }
};


void  ()imp_pain_anim2 =  {
   AdvanceFrame( 60.00000, 68.00000);
   check_pos_enemy ( );
   ai_pain ( 2.00000);
   if ( (self.frame == 68.00000) ) {

      self.touch = SUB_Null;
      self.think = imp_hover;
      AdvanceThinkTime(self,0.00000);

   }
};


void  ()imp_pain_anim1 =  {
   AdvanceFrame( 68.00000, 60.00000);
   check_pos_enemy ( );
   ai_pain ( 2.00000);
   if ( (self.frame == 60.00000) ) {

      self.think = imp_pain_anim2;
      AdvanceThinkTime(self,0.00000);

   }
};


void  (entity attacker,float damage)imp_pain =  {
   if ( self.monster_awake ) {

      if ( (self.pain_finished > time) ) {

         return ;

      }

   }
   if ( ((self.targetname != "") && (self.skin == 2.00000)) ) {

      self.think = SUB_Null;
      self.nextthink = -1.00000;
      return ;

   }
   if ( (((((random() < 0.50000) && (self.pain_finished != -666.00000)) && (attacker != world)) && (self.touch != SUB_Null)) && self.monster_awake) ) {

      return ;

   }
   self.monster_awake = TRUE;
   self.pain_finished = (time + 3.00000);
   if ( ((self.attack_state == AS_FERRY) && (random() < 0.20000)) ) {

      imp_drop ( );

   }
   if ( (self.spawnflags & SF_IMP_DORMANT) ) {

      self.frame = 55.00000;
      self.think = stone_imp_awaken;
   } else {

      if ( (self.skin == 3.00000) ) {

         sound ( self, CHAN_VOICE, "imp/upbig.wav", 1.00000, ATTN_NORM);
      } else {

         sound ( self, CHAN_VOICE, "imp/up.wav", 1.00000, ATTN_NORM);

      }
      self.think = imp_pain_anim1;

   }
   AdvanceThinkTime(self,0.00000);
};


void  ()imp_use =  {
   self.use = SUB_Null;
   self.targetname = "";
   if ( (activator.classname == "player") ) {

      self.goalentity = activator;
      self.enemy = activator;
   } else {

      dprint ( "ERROR: monster not activated by player!\n");

   }
   self.frame = 55.00000;
   self.think = stone_imp_awaken;
   AdvanceThinkTime(self,random());
};


float  ()imp_find_target =  {
local float self_infront = 0.00000;
local float self_vis = 0.00000;
local float enemy_dist = 0.00000;
local float r1 = 0.00000;
   if ( LocateTarget ( ) ) {

      if ( (self.skin == 2.00000) ) {

         self_infront = infront_of_ent ( self, self.enemy);
         self_vis = visible2ent ( self, self.enemy);
         enemy_dist = vlen ( (self.origin - self.enemy.origin));
         r1 = random();
         r2 = random();
         if ( (((((self_infront && self_vis) && (r1 < 0.10000)) && (r2 < 0.50000)) && (enemy_dist < 1000.00000)) || (enemy_dist <= RANGE_MELEE)) ) {

            self.goalentity = self.enemy;
            self.think = stone_imp_awaken;
            AdvanceThinkTime(self,0.00000);
            return ( TRUE );
         } else {

            self.enemy = world;
            self.goalentity = world;
            return ( FALSE );

         }
      } else {

         self.goalentity = self.enemy;
         self.think = self.th_run;
         AdvanceThinkTime(self,0.00000);
         return ( TRUE );

      }
   } else {

      if ( (self.classname == "monster_imp_lord") ) {

         self.goalentity = self.controller;
         self.enemy = self.controller;

      }

   }
   return ( FALSE );
};


void  ()imp_wait =  {
   AdvanceFrame( 78.00000, 101.00000);
   if ( (self.skin == 2.00000) ) {

      self.frame = 78.00000;
   } else {

      if ( !(self.flags & FL_ONGROUND) ) {

         self.think = imp_hover;
         AdvanceThinkTime(self,0.00000);

      }

   }
   if ( (random() < 0.50000) ) {

      if ( imp_find_target ( ) ) {

         return ;

      }

   }
};


void  ()imp_fly =  {
   AdvanceFrame( 35.00000, 54.00000);
   if ( (self.frame == 35.00000) ) {

      if ( (pointcontents ( (self.origin + self.view_ofs)) == CONTENT_WATER) ) {

         self.noise = "hydra/turn-s.wav";
      } else {

         if ( (self.skin == 3.00000) ) {

            self.noise = "imp/flybig.wav";
         } else {

            self.noise = "imp/fly.wav";

         }

      }
      sound ( self, CHAN_BODY, self.noise, 1.00000, ATTN_NORM);

   }
   if ( (self.skin == 3.00000) ) {

      if ( (((self.lifetime < time) || !(self.controller.flags2 & FL_ALIVE)) || (self.controller.imp_count != self.imp_count)) ) {

         self.think = summoned_imp_die;
         AdvanceThinkTime(self,0.00000);
         return ;

      }

   }
   imp_move ( );
   if ( imp_check_defense ( ) ) {

      return ;

   }
   if ( imp_check_attack ( ) ) {

      return ;

   }
   if ( imp_new_action ( ) ) {

      return ;

   }
};


void  ()imp_awaken =  {
   AdvanceFrame( 55.00000, 77.00000);
   if ( (self.frame == 55.00000) ) {

      if ( (self.skin == 3.00000) ) {

         sound ( self, CHAN_VOICE, "imp/upbig.wav", 1.00000, ATTN_NORM);
      } else {

         sound ( self, CHAN_VOICE, "imp/up.wav", 1.00000, ATTN_NORM);

      }

   }
   check_pos_enemy ( );
   movestep ( 0.00000, 0.00000, (imp_up_amounts->(self.frame - 55.00000)), FALSE);
   walkmove ( self.angles_y, ((imp_up_amounts->(self.frame - 55.00000)) / 2.00000), FALSE);
   if ( (self.frame == 77.00000) ) {

      self.think = imp_fly;
      AdvanceThinkTime(self,0.00000);

   }
};


void  ()impmonster_start_go =  {
   self.ideal_yaw = (self.angles * '0.00000 1.00000 0.00000');
   if ( !self.yaw_speed ) {

      self.yaw_speed = 5.00000;

   }
   if ( !self.use ) {

      self.use = monster_use;

   }
   self.pausetime = 100000000.00000;
   if ( (self.targetname != "") ) {

      self.frame = 78.00000;
      self.think = imp_use;
      self.nextthink = -1.00000;
   } else {

      if ( (self.enemy != world) ) {

         imp_awaken ( );
      } else {

         self.th_stand ( );

      }

   }
};


void  ()impmonster_start =  {
   AdvanceThinkTime(self,random(0.50000));
   self.think = impmonster_start_go;
   total_monsters = (total_monsters + 1.00000);
};


void  (float which_skin)init_imp =  {
   if ( ((deathmatch && (self.wait != -1.00000)) && (self.classname != "monster_imp_lord")) ) {

      remove ( self);
      return ;

   }
   if ( !(self.flags2 & FL_SUMMONED) ) {

      precache_model2 ( "models/imp.mdl");
      precache_model2 ( "models/h_imp.mdl");
      if ( (self.classname == "monster_imp_lord") ) {

         precache_model2 ( "models/shardice.mdl");
         precache_model ( "models/fireball.mdl");
         precache_sound2 ( "imp/upbig.wav");
         precache_sound2 ( "imp/diebig.wav");
         precache_sound2 ( "imp/swoopbig.wav");
         precache_sound2 ( "imp/flybig.wav");
      } else {

         precache_sound2 ( "imp/up.wav");
         precache_sound2 ( "imp/die.wav");
         precache_sound2 ( "imp/swoop.wav");
         precache_sound2 ( "imp/fly.wav");
         if ( (self.classname == "monster_imp_ice") ) {

            precache_model2 ( "models/shardice.mdl");
         } else {

            precache_model ( "models/fireball.mdl");

         }

      }
      precache_sound2 ( "imp/swoophit.wav");
      precache_sound2 ( "imp/fireball.wav");
      precache_sound2 ( "imp/shard.wav");
      precache_sound ( "hydra/turn-s.wav");

   }
   self.solid = SOLID_SLIDEBOX;
   setmodel ( self, "models/imp.mdl");
   if ( (self.classname == "monster_imp_lord") ) {

      self.drawflags |= SCALE_ORIGIN_CENTER;
      self.scale = 2.30000;
      setsize ( self, '-32.00000 -32.00000 -32.00000', '32.00000 32.00000 32.00000');
      self.hull = HULL_HYDRA;
      self.proj_ofs = '0.00000 0.00000 82.00000';
      self.view_ofs = '0.00000 0.00000 82.00000';
   } else {

      self.scale = 1.00000;
      setsize ( self, '-16.00000 -16.00000 0.00000', '16.00000 16.00000 36.00000');
      self.proj_ofs = '0.00000 0.00000 33.00000';
      self.view_ofs = '0.00000 0.00000 33.00000';
      self.hull = HULL_CROUCH;

   }
   self.headmodel = "models/h_imp.mdl";
   if ( (which_skin == 3.00000) ) {

      self.flags |= (FL_COLDHEAL | FL_FIREHEAL);
   } else {

      if ( (which_skin == 1.00000) ) {

         self.flags |= FL_COLDHEAL;
      } else {

         self.flags |= FL_FIREHEAL;

      }

   }
   if ( (self.wait != -1.00000) ) {

      self.movetype = MOVETYPE_FLY;
      self.takedamage = DAMAGE_YES;
      self.skin = which_skin;
      self.impType = which_skin;
      self.flags2 |= FL_ALIVE;
      self.thingtype = THINGTYPE_FLESH;
      if ( (self.classname == "monster_imp_lord") ) {

         self.health = 600.00000;
         self.max_health = 600.00000;
         self.experience_value = 3000.00000;
         self.mass = 10.00000;
         self.th_die = summoned_imp_die;
      } else {

         self.health = (75.00000 + (self.skin * 25.00000));
         self.max_health = (75.00000 + (self.skin * 25.00000));
         self.experience_value = (400.00000 + (self.skin * 100.00000));
         self.mass = 3.00000;
         self.th_die = imp_die_init;

      }
      self.mintel = 5.00000;
      if ( (self.spawnflags & MONSTER_HOVER) ) {

         self.th_stand = imp_hover;
         self.th_walk = imp_fly;
      } else {

         self.th_stand = imp_wait;
         self.th_walk = imp_awaken;

      }
      self.th_run = self.th_walk;
      self.th_pain = imp_pain;
      self.th_missile = imp_enter_swoop;
      self.th_melee = imp_attack;

   }
   self.yaw_speed = 8.00000;
   self.speed = 10.00000;
   self.attack_state = AS_STRAIGHT;
   self.level = 0.00000;
   if ( (self.spawnflags & SF_IMP_DORMANT) ) {

      self.classname = "gargoyle";
      self.scale = 1.50000;
      self.artifact_active |= ARTFLAG_STONED;
      setsize ( self, '-16.00000 -16.00000 -14.00000', '16.00000 16.00000 22.00000');
      self.origin_z += 14.00000;
      self.hull = HULL_CROUCH;
      self.takedamage = DAMAGE_NO_GRENADE;
      self.thingtype = THINGTYPE_GREYSTONE;
      self.movetype = MOVETYPE_PUSHPULL;
      self.touch = obj_push;
      self.health += 100.00000;
      self.mass = 100.00000;
      self.th_die = chunk_death;
      if ( (self.wait != -1.00000) ) {

         self.use = imp_use;
         self.oldskin = self.skin;
         self.th_stand = imp_wait;

      }
      self.skin = 2.00000;
   } else {

      self.flags |= (FL_MONSTER | FL_FLY);

   }
   total_monsters += 1.00000;
   if ( self.enemy ) {

      self.th_run ( );
   } else {

      if ( (self.wait != -1.00000) ) {

         impmonster_start ( );
      } else {

         self.frame = 78.00000;

      }

   }
};


void  ()monster_imp_ice =  {
   init_imp ( 1.00000);
};


void  ()monster_imp_fire =  {
   init_imp ( 0.00000);
};


void  ()monster_imp_lord =  {
   if ( (self.flags2 & FL_SUMMONED) ) {

      self.spawnflags |= MONSTER_HOVER;

   }
   init_imp ( 3.00000);
};


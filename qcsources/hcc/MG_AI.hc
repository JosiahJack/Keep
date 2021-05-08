
void  (entity targ)get_visibility =  {
local float base = 0.00000;
local float divider = 0.00000;
   if ( (targ.classname != "player") ) {

      targ.visibility = 1.00000;
      return ;

   }
   if ( (targ.effects & EF_NODRAW) ) {

      targ.visibility = 0.00000;
      return ;

   }
   if ( (targ.drawflags & DRF_TRANSLUCENT) ) {

      if ( (targ.model == "models/assassin.mdl") ) {

         divider = 10.00000;
      } else {

         divider = 3.00000;

      }
   } else {

      divider = 1.00000;

   }
   if ( (targ.drawflags & MLS_ABSLIGHT) ) {

      base = (targ.abslight / 2.50000);
   } else {

      base = 1.00000;

   }
   if ( (targ.drawflags & MLS_POWERMODE) ) {

      base = 1.00000;
   } else {

      base = ((targ.light_level / 100.00000) * base);

   }
   targ.visibility = (base / divider);
};


float  (entity targ)visibility_good =  {
   get_visibility ( targ);
   if ( (random() < targ.visibility) ) {

      return ( TRUE );

   }
   return ( FALSE );
};


float  ()FindMonsterTarget =  {
local entity found;
local float okay = 0.00000;
   if ( (((self.controller.enemy != world) && (self.controller.enemy.flags2 & FL_ALIVE)) && visible ( self.controller.enemy)) ) {

      self.enemy = self.controller.enemy;
      return ( TRUE );

   }
   okay = FALSE;
   found = findradius ( self.origin, 1000.00000);
   while ( (found != world) ) {

      if ( (found != self) ) {

         if ( (found.flags2 & FL_ALIVE) ) {

            if ( visible ( found) ) {

               if ( (found != self.controller) ) {

                  if ( (found.controller != self.controller) ) {

                     if ( coop ) {

                        if ( (found.classname != "player") ) {

                           okay = TRUE;

                        }
                     } else {

                        if ( teamplay ) {

                           if ( (found.team != self.controller.team) ) {

                              okay = TRUE;

                           }
                        } else {

                           okay = TRUE;

                        }

                     }
                     if ( okay ) {

                        self.enemy = found;
                        return ( TRUE );

                     }

                  }

               }

            }

         }

      }
      found = found.chain;

   }
   if ( (self.classname == "monster_imp_lord") ) {

      self.enemy = self.controller;

   }
   return ( FALSE );
};


float  ()CheckJump =  {
local vector spot1 = '0.00000 0.00000 0.00000';
local vector spot2 = '0.00000 0.00000 0.00000';
local vector jumpdir = '0.00000 0.00000 0.00000';
local float jump_height = 0.00000;
local float jumpup = 0.00000;
local float ignore_height = 0.00000;
   makevectors ( self.angles);
   jumpdir = normalize ( (self.goalentity.origin - self.origin));
   jumpdir_z = 0.00000;
   jump_height = (jumpdir * v_forward);
   if ( (jump_height < 0.30000) ) {

      return ( FALSE );

   }
   spot1 = self.origin;
   spot2 = self.enemy.origin;
   spot1_z = 0.00000;
   spot2_z = 0.00000;
   jump_height = 16.00000;
   if ( (pointcontents ( ((spot1 + (v_forward * 24.00000)) - '0.00000 0.00000 10.00000')) != CONTENT_SOLID) ) {

      ignore_height = TRUE;

   }
   if ( ((self.classname != "monster_mezzoman") && !self.spiderType) ) {

      if ( (vlen ( (spot1 - spot2)) > 256.00000) ) {

         ignore_height = FALSE;

      }

   }
   if ( (self.jump_flag > time) ) {

      return ( FALSE );
   } else {

      if ( (pointcontents ( self.goalentity.origin) != CONTENT_EMPTY) ) {

         return ( FALSE );
      } else {

         if ( !visible ( self.goalentity) ) {

            return ( FALSE );
         } else {

            if ( (((!ignore_height && ((self.goalentity.absmin_z + 36.00000) >= self.absmin_z)) && (self.think != SpiderJumpBegin)) && (self.classname != "monster_mezzoman")) ) {

               return ( FALSE );
            } else {

               if ( !(self.flags & FL_ONGROUND) ) {

                  return ( FALSE );
               } else {

                  if ( (!(self.goalentity.flags & FL_ONGROUND) && (self.goalentity.classname != "waypoint")) ) {

                     return ( FALSE );
                  } else {

                     if ( !infront ( self.goalentity) ) {

                        return ( FALSE );
                     } else {

                        if ( ((vlen ( (spot1 - spot2)) > 777.00000) && !ignore_height) ) {

                           return ( FALSE );
                        } else {

                           if ( (vlen ( (spot1 - spot2)) <= 100.00000) ) {

                              return ( FALSE );

                           }

                        }

                     }

                  }

               }

            }

         }

      }

   }
   if ( (self.think == SpiderJumpBegin) ) {

      jump_height = (vlen ( (((self.goalentity.absmax + self.goalentity.absmin) * 0.50000) - self.origin)) / 13.00000);
   } else {

      if ( (self.classname == "monster_mezzoman") ) {

         if ( (self.goalentity.absmin_z >= (self.absmin_z + 36.00000)) ) {

            jump_height = (vlen ( (((self.goalentity.absmax + self.goalentity.absmin) * 0.50000) - self.origin)) / 13.00000);
            jumpup = TRUE;
         } else {

            if ( (self.goalentity.absmin_z > (self.absmin_z - 36.00000)) ) {

               if ( ignore_height ) {

                  jump_height = (vlen ( (((self.goalentity.absmax + self.goalentity.absmin) * 0.50000) - self.origin)) / 13.00000);
               } else {

                  return ( FALSE );

               }

            }

         }

      }

   }
   spot1 = self.origin;
   spot1_z = self.absmax_z;
   spot2 = spot1;
   spot2_z += 36.00000;
   traceline ( spot1, spot2, FALSE, self);
   if ( (trace_fraction < 1.00000) ) {

      return ( FALSE );

   }
   if ( !jumpup ) {

      spot1 += (jumpdir * ((self.maxs_x + self.maxs_y) * 0.50000));
      traceline ( self.origin, (spot1 + '0.00000 0.00000 36.00000'), FALSE, self);
      if ( (trace_fraction < 1.00000) ) {

         return ( FALSE );

      }
      traceline ( spot1, ((spot1 + (jumpdir * 64.00000)) - '0.00000 0.00000 500.00000'), FALSE, self);
      if ( (((pointcontents ( trace_endpos) == CONTENT_WATER) || (pointcontents ( trace_endpos) == CONTENT_SLIME)) || (pointcontents ( trace_endpos) == CONTENT_LAVA)) ) {

         return ( FALSE );

      }

   }
   ai_face ( );
   if ( (self.think != SpiderJumpBegin) ) {

      self.jump_flag = (time + 7.00000);
      SightSound ( );
      if ( !jumpup ) {

         self.velocity = (((jumpdir * jump_height) * 17.00000) * self.scale);
         self.velocity_z = ((jump_height * 12.00000) * self.scale);
      } else {

         self.velocity = (((jumpdir * jump_height) * 10.00000) * self.scale);
         self.velocity_z = ((jump_height * 14.00000) * self.scale);

      }
      self.flags ^= FL_ONGROUND;
      if ( self.th_jump ) {

         self.th_jump ( );
      } else {

         AdvanceThinkTime(self,0.30000);

      }
   } else {

      self.level = jump_height;
      return ( TRUE );

   }
};


void  ()do_contents_dam =  {
   T_Damage ( self.enemy, world, world, self.dmg);
   if ( (self.dmg == 5.00000) ) {

      self.classname = "contents damager";
      setorigin ( self, (self.enemy.origin + self.enemy.view_ofs));
      DeathBubbles ( 1.00000);

   }
   remove ( self);
};


void  ()MonsterCheckContents =  {
   if ( (random() > 0.30000) ) {

      return ;

   }
   if ( (pointcontents ( self.origin) == CONTENT_LAVA) ) {

      if ( (self.flags & FL_FIREHEAL) ) {

         if ( (self.health < self.max_health) ) {

            self.health += 1.00000;

         }
      } else {

         newmis = spawn ( );
         newmis.think = do_contents_dam;
         newmis.enemy = self;
         newmis.dmg = 30.00000;
         AdvanceThinkTime(newmis,0.00000);

      }

   }
   if ( (((self.movetype == MOVETYPE_SWIM) || (self.model == "models/skullwiz.mdl")) || (self.netname == "golem")) ) {

      return ;

   }
   if ( (pointcontents ( (self.origin + self.view_ofs)) == CONTENT_WATER) ) {

      if ( (self.air_finished < time) ) {

         newmis = spawn ( );
         newmis.think = do_contents_dam;
         newmis.enemy = self;
         newmis.dmg = 5.00000;
         AdvanceThinkTime(newmis,0.00000);

      }
   } else {

      self.air_finished = (time + 12.00000);

   }
};


void  (vector slope)pitch_roll_for_slope =  {
local vector new_angles = '0.00000 0.00000 0.00000';
local vector new_angles2 = '0.00000 0.00000 0.00000';
local vector old_forward = '0.00000 0.00000 0.00000';
local vector old_right = '0.00000 0.00000 0.00000';
local float dot = 0.00000;
local float mod = 0.00000;
   makevectors ( self.angles);
   old_forward = v_forward;
   old_right = v_right;
   if ( (slope == '0.00000 0.00000 0.00000') ) {

      traceline ( self.origin, (self.origin - '0.00000 0.00000 300.00000'), TRUE, self);
      if ( ((trace_fraction > 0.05000) && (self.movetype == MOVETYPE_STEP)) ) {

         self.flags ^= FL_ONGROUND;

      }
      if ( (trace_fraction == 1.00000) ) {

         return ;

      }
      slope = trace_plane_normal;

   }
   new_angles = vectoangles ( slope);
   new_angles_x = ((90.00000 - new_angles_x) * -1.00000);
   new_angles2 = '0.00000 0.00000 0.00000';
   new_angles2_y = new_angles_y;
   makevectors ( new_angles2);
   mod = (v_forward * old_right);
   if ( (mod < 0.00000) ) {

      mod = 1.00000;
   } else {

      mod = -1.00000;

   }
   dot = (v_forward * old_forward);
   self.angles_x = (dot * new_angles_x);
   self.angles_z = (((1.00000 - fabs ( dot)) * new_angles_x) * mod);
};


void  ()checkenemy =  {
local entity oldtarget;
   if ( (((self.enemy.classname == "player") && (self.enemy.flags2 & FL_ALIVE)) && (self.enemy != self.controller)) ) {

      return ;

   }
   if ( (!(self.enemy.flags2 & FL_ALIVE) || (self.enemy == self.controller)) ) {

      if ( (self.controller.classname == "player") ) {

         self.enemy = self.controller;
         self.goalentity = self.enemy;
      } else {

         self.enemy = world;

      }
      if ( (self.oldenemy.flags2 & FL_ALIVE) ) {

         self.enemy = self.oldenemy;
         self.goalentity = self.enemy;
         self.think = self.th_run;
      } else {

         if ( LocateTarget ( ) ) {

            self.goalentity = self.enemy;
            self.think = self.th_run;
         } else {

            if ( (self.controller.classname == "player") ) {

               self.enemy = self.controller;
               self.goalentity = self.controller;
            } else {

               self.enemy = world;
               self.goalentity = world;

            }
            if ( self.pathentity ) {

               self.think = self.th_walk;
            } else {

               self.think = self.th_stand;

            }

         }

      }
      AdvanceThinkTime(self,0.00000);
      return ;

   }
   if ( (self.classname == "monster_imp_lord") ) {

      return ;

   }
   if ( (((self.oldenemy.classname == "player") && (self.oldenemy.flags2 & FL_ALIVE)) && visible ( self.oldenemy)) ) {

      if ( (((self.model == "models/spider.mdl") || (self.model == "models/scorpion.mdl")) && (self.enemy.model == self.model)) ) {

         self.enemy = self.oldenemy;
      } else {

         oldtarget = self.enemy;
         self.enemy = self.oldenemy;
         self.oldenemy = oldtarget;

      }
      self.goalentity = self.enemy;

   }
};


float  (entity targ,entity from,float scope)fov =  {
local vector spot1 = '0.00000 0.00000 0.00000';
local vector spot2 = '0.00000 0.00000 0.00000';
local float dot = 0.00000;
   spot1 = (from.origin + from.proj_ofs);
   spot2 = ((targ.absmin + targ.absmax) * 0.50000);
   if ( (from.classname == "player") ) {

      makevectors ( from.v_angle);
   } else {

      makevectors ( from.angles);

   }
   dot = (normalize ( (spot2 - spot1)) * v_forward);
   dot = (180.00000 - (dot * 180.00000));
   if ( (dot <= scope) ) {

      return ( TRUE );

   }
   return ( FALSE );
};


void  ()check_pos_enemy =  {
   if ( !self.mintel ) {

      return ;

   }
   if ( !visible ( self.enemy) ) {

      self.attack_state = AS_STRAIGHT;
      SetNextWaypoint ( );
      if ( (self.model == "models/imp.mdl") ) {

         if ( (((self.search_time < time) && (self.goalentity == self.enemy)) && (self.trigger_field.classname == "waypoint")) ) {

            self.goalentity = self.trigger_field;

         }

      }
   } else {

      if ( (self.model == "models/imp.mdl") ) {

         self.search_time = (time + 5.00000);

      }
      self.goalentity = self.enemy;
      self.wallspot = ((self.enemy.absmin + self.enemy.absmax) * 0.50000);

   }
};


float  (entity targ,float whole_body)clear_path =  {
local vector destiny = '0.00000 0.00000 0.00000';
local vector org = '0.00000 0.00000 0.00000';
   destiny = (targ.origin + targ.proj_ofs);
   if ( (self.attack_state != AS_FERRY) ) {

      self.attack_state = AS_STRAIGHT;

   }
   if ( whole_body ) {

      org = ((self.absmin + self.absmax) * 0.50000);
      tracearea ( org, destiny, self.mins, self.maxs, FALSE, self);
   } else {

      org = (self.origin + self.proj_ofs);
      traceline ( org, destiny, FALSE, self);

   }
   if ( (!whole_body && (trace_ent.thingtype >= THINGTYPE_WEBS)) ) {

      traceline ( trace_endpos, destiny, FALSE, trace_ent);

   }
   if ( (trace_ent == targ) ) {

      return ( TRUE );

   }
   if ( whole_body ) {

      if ( (self.attack_state != AS_FERRY) ) {

         self.attack_state = AS_SLIDING;

      }
      return ( FALSE );

   }
   if ( (((trace_ent.health > 25.00000) || !trace_ent.takedamage) || ((trace_ent.flags & FL_MONSTER) && (trace_ent.classname != "player_sheep"))) ) {

      self.attack_state = AS_SLIDING;
      return ( FALSE );

   }
   return ( TRUE );
};


float  (entity targ,vector org,vector dir,float dist,float interval)check_view =  {
local float dist_counter = 0.00000;
   newmis = spawn ( );
   dir = normalize ( dir);
   while ( (dist_counter < dist) ) {

      dist_counter += interval;
      setorigin ( newmis, (org + (dir * dist_counter)));
      if ( visible2ent ( targ, newmis) ) {

         traceline ( newmis.origin, ((targ.absmin + targ.absmax) * 0.50000), FALSE, self);
         if ( (trace_ent == targ) ) {

            remove ( newmis);
            return ( dist_counter );

         }

      }

   }
   remove ( newmis);
   return ( FALSE );
};


vector  (vector checkdir,float minspeed,float maxspeed)check_axis_move =  {
local float go_dist = 0.00000;
   checkdir = normalize ( checkdir);
   if ( (random() < 0.50000) ) {

      checkdir = (checkdir * -1.00000);

   }
   go_dist = check_view ( self.enemy, (self.origin + self.view_ofs), checkdir, 500.00000, 30.00000);
   if ( (!go_dist && (random() < 0.50000)) ) {

      checkdir_x *= -1.00000;
      go_dist = check_view ( self.enemy, (self.origin + self.view_ofs), checkdir, 500.00000, 30.00000);

   }
   if ( go_dist ) {

      if ( (go_dist > maxspeed) ) {

         go_dist = maxspeed;
      } else {

         if ( (go_dist < minspeed) ) {

            go_dist = minspeed;

         }

      }
      checkdir = (checkdir * go_dist);
      return ( checkdir );

   }
   return ( '0.00000 0.00000 0.00000' );
};


float  (float maxdist)check_z_move =  {
local float goaldist = 0.00000;
local entity targ;
   if ( ((self.enemy != world) && visible ( self.enemy)) ) {

      targ = self.enemy;
   } else {

      if ( (self.goalentity != world) ) {

         targ = self.goalentity;
      } else {

         return ( FALSE );

      }

   }
   if ( (targ.origin_z != self.absmin_z) ) {

      goaldist = (((targ.absmin_z + targ.absmax_z) * 0.50000) - ((self.absmax_z + self.absmin_z) * 0.50000));
      maxdist = fabs ( maxdist);
      if ( (fabs ( goaldist) > maxdist) ) {

         if ( (goaldist > 0.00000) ) {

            goaldist = maxdist;
         } else {

            goaldist = (maxdist * -1.00000);

         }

      }
      if ( !movestep ( 0.00000, 0.00000, goaldist, FALSE) ) {

         return ( FALSE );

      }

   }
   return ( TRUE );
};


float  (entity targ,entity from)lineofsight =  {
local vector org = '0.00000 0.00000 0.00000';
local vector dir = '0.00000 0.00000 0.00000';
   if ( (from.classname == "player") ) {

      makevectors ( from.v_angle);
   } else {

      makevectors ( from.angles);

   }
   org = (from.origin + from.view_ofs);
   dir = normalize ( v_forward);
   traceline ( org, (org + (dir * 1000.00000)), FALSE, from);
   if ( (trace_ent != targ) ) {

      return ( FALSE );
   } else {

      return ( TRUE );

   }
};


entity  (entity subject_path)riderpath_findbest =  {
local entity search;
local entity found;
local entity best_path;
local float next = 0.00000;
local float num_points = 0.00000;
local float position = 0.00000;
local float bestdist = 0.00000;
local float lastdist = 0.00000;
   num_points = 0.00000;
   if ( subject_path.next_path_1 ) {

      num_points += 1.00000;

   }
   if ( subject_path.next_path_2 ) {

      num_points += 1.00000;

   }
   if ( subject_path.next_path_3 ) {

      num_points += 1.00000;

   }
   if ( subject_path.next_path_4 ) {

      num_points += 1.00000;

   }
   if ( subject_path.next_path_5 ) {

      num_points += 1.00000;

   }
   if ( subject_path.next_path_6 ) {

      num_points += 1.00000;

   }
   if ( !num_points ) {

      dprintf ( "rider path %s has no next points\n", subject_path.path_id);
      remove ( self);
      return ( world );

   }
   bestdist = vlen ( (self.goalentity.origin - self.origin));
   lastdist = bestdist;
   position = 0.00000;
   best_path = world;
   while ( (position < num_points) ) {

      position += 1.00000;
      if ( (position == 1.00000) ) {

         next = subject_path.next_path_1;
      } else {

         if ( (position == 2.00000) ) {

            next = subject_path.next_path_2;
         } else {

            if ( (position == 3.00000) ) {

               next = subject_path.next_path_3;
            } else {

               if ( (position == 4.00000) ) {

                  next = subject_path.next_path_4;
               } else {

                  if ( (position == 5.00000) ) {

                     next = subject_path.next_path_5;
                  } else {

                     if ( (position == 6.00000) ) {

                        next = subject_path.next_path_6;

                     }

                  }

               }

            }

         }

      }
      found = world;
      search = find ( world, classname, "rider_path");
      while ( ((search != world) && (found == world)) ) {

         if ( (search.path_id == next) ) {

            found = search;
         } else {

            search = find ( search, classname, "rider_path");

         }

      }
      if ( !found ) {

         dprintf ( "Could not find rider path %s\n", next);
         remove ( self);
         return ( world );
      } else {

         lastdist = vlen ( (self.goalentity.origin - found.origin));
         if ( (lastdist < bestdist) ) {

            best_path = found;
            bestdist = lastdist;

         }

      }

   }
   if ( !best_path ) {

      return ( world );

   }
   return ( best_path );
};


entity  ()look_projectiles =  {
local entity found;
local entity enemy_proj;
local float dist = 0.00000;
local float bestdist = 0.00000;
   found = findradius ( self.origin, 1000.00000);
   bestdist = 1001.00000;
   while ( found ) {

      if ( (((found.movetype == MOVETYPE_FLYMISSILE) || (found.movetype == MOVETYPE_BOUNCE)) || (found.movetype == MOVETYPE_BOUNCEMISSILE)) ) {

         if ( visible ( found) ) {

            dist = vlen ( (found.origin - self.origin));
            if ( (dist < bestdist) ) {

               if ( heading ( self, found, 0.90000) ) {

                  bestdist = dist;
                  enemy_proj = found;

               }

            }

         }

      }
      found = found.chain;

   }
   if ( enemy_proj ) {

      self.level = (bestdist / vlen ( enemy_proj.velocity));
      return ( enemy_proj );
   } else {

      return ( world );

   }
};


float  (vector startpos,vector endpos)solid_under =  {
local float diff_count = 0.00000;
local vector dir = '0.00000 0.00000 0.00000';
   dir = normalize ( (endpos - startpos));
   diff_count = (vlen ( (endpos - startpos)) / 5.00000);
   while ( (diff_count > 0.00000) ) {

      traceline ( startpos, (startpos - '0.00000 0.00000 18.00000'), TRUE, self);
      if ( (trace_fraction == 1.00000) ) {

         return ( FALSE );

      }
      startpos += (dir * 5.00000);
      diff_count -= 1.00000;

   }
   return ( TRUE );
};


float  (entity object)check_heading_left_or_right =  {
local vector spot1 = '0.00000 0.00000 0.00000';
local vector spot2 = '0.00000 0.00000 0.00000';
local vector vec = '0.00000 0.00000 0.00000';
local float dot = 0.00000;
local float rng = 0.00000;
local float reverse = 0.00000;
   makevectors ( self.angles);
   spot1 = (self.origin + self.view_ofs);
   spot2 = object.origin;
   rng = vlen ( (spot1 - spot2));
   spot2 += (normalize ( object.velocity) * (rng + 15.00000));
   vec = normalize ( (spot2 - spot1));
   if ( ((object.classname == "player") && !self.monster_awake) ) {

      self.monster_awake = TRUE;
      sound ( self, CHAN_VOICE, "mezzo/attack.wav", 1.00000, ATTN_NORM);
      reverse = -1.00000;
   } else {

      reverse = 1.00000;

   }
   dot = (vec * v_right);
   if ( (dot > 0.00000) ) {

      return ( (-1.00000 * reverse) );

   }
   dot = (vec * (v_right * -1.00000));
   if ( (dot > 0.00000) ) {

      return ( (1.00000 * reverse) );

   }
   return ( 0.00000 );
};


float  (float walkspeed)navigate =  {
local vector checkdir = '0.00000 0.00000 0.00000';
local vector org = '0.00000 0.00000 0.00000';
local vector new_angle = '0.00000 0.00000 0.00000';
local float vert_size = 0.00000;
local float horz_size = 0.00000;
   makevectors ( self.angles);
   checkdir = v_right;
   org = (self.origin + (checkdir * self.size_x));
   vert_size = (self.size_z / 2.00000);
   horz_size = ((self.size_x + self.size_y) / 4.00000);
   traceline ( org, (org + (v_forward * horz_size)), FALSE, self);
   if ( ((trace_fraction == 1.00000) && !trace_allsolid) ) {

      checkdir = (v_right * -1.00000);
      org = (self.origin + (checkdir * horz_size));
      traceline ( org, (org + (v_forward * horz_size)), FALSE, self);

   }
   if ( ((self.flags & FL_FLY) || (self.flags & FL_SWIM)) ) {

      if ( ((trace_fraction == 1.00000) && !trace_allsolid) ) {

         checkdir = v_up;
         org = (self.origin + (checkdir * vert_size));
         traceline ( org, (org + (v_forward * horz_size)), FALSE, self);

      }
      if ( ((trace_fraction == 1.00000) && !trace_allsolid) ) {

         checkdir = (v_up * -1.00000);
         org = (self.origin + (checkdir * vert_size));
         traceline ( org, (org + (v_forward * horz_size)), FALSE, self);

      }

   }
   if ( ((trace_fraction < 1.00000) || trace_allsolid) ) {

      if ( ((checkdir == v_right) || (checkdir == (v_right * -1.00000))) ) {

         new_angle = vectoangles ( (checkdir * -1.00000));
         if ( !walkmove ( new_angle_y, walkspeed, FALSE) ) {

            return ( FALSE );

         }
         return ( TRUE );

      }
      if ( (checkdir == v_up) ) {

         walkspeed *= -1.00000;

      }
      if ( !movestep ( 0.00000, 0.00000, walkspeed, FALSE) ) {

         return ( FALSE );

      }
      return ( TRUE );

   }
   return ( FALSE );
};


vector  (vector p1,float pspeed,entity targ,float accept)extrapolate_pos_for_speed =  {
local float dist1 = 0.00000;
local float dist2 = 0.00000;
local float tspeed = 0.00000;
local float dot = 0.00000;
local float eta1 = 0.00000;
local float eta2 = 0.00000;
local float eta_delta = 0.00000;
local float failed = 0.00000;
local vector p2 = '0.00000 0.00000 0.00000';
local vector p3 = '0.00000 0.00000 0.00000';
local vector targ_dir = '0.00000 0.00000 0.00000';
local vector vec1 = '0.00000 0.00000 0.00000';
local vector vec2 = '0.00000 0.00000 0.00000';
   p2 = (targ.origin + targ.view_ofs);
   vec1 = (p2 - p1);
   dist1 = vlen ( vec1);
   vec1 = normalize ( vec1);
   targ_dir = targ.velocity;
   tspeed = vlen ( targ_dir);
   targ_dir = normalize ( targ_dir);
   eta1 = (dist1 / pspeed);
   p3 = (p2 + ((targ_dir * tspeed) * eta1));
   dist2 = vlen ( (p3 - p1));
   eta2 = (dist2 / pspeed);
   eta_delta = (eta2 - eta1);
   p3 += (((targ_dir * tspeed) * eta_delta) * random());
   traceline ( p1, p3, FALSE, self);
   if ( (trace_fraction < 1.00000) ) {

      if ( (trace_ent.thingtype >= THINGTYPE_WEBS) ) {

         traceline ( trace_endpos, p3, FALSE, trace_ent);

      }
      if ( (trace_fraction < 1.00000) ) {

         if ( (((trace_ent.health > 25.00000) || !trace_ent.takedamage) || ((trace_ent.flags & FL_MONSTER) && (trace_ent.classname != "player_sheep"))) ) {

            self.attack_state = AS_SLIDING;
            failed = TRUE;

         }

      }

   }
   vec2 = normalize ( (p3 - p1));
   dot = (vec1 * vec2);
   if ( (dot < accept) ) {

      failed = TRUE;

   }
   if ( failed ) {

      p3 = '0.00000 0.00000 0.00000';

   }
   return ( p3 );
};


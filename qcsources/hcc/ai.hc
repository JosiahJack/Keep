float  ()ArcherCheckAttack;
float  ()MedusaCheckAttack;
void  ()SetNextWaypoint;
void  ()SpiderMeleeBegin;
void  ()spider_onwall_wait;
float  (entity targ,entity from)infront_of_ent;
void  (entity proj)mezzo_choose_roll;
void  ()hive_die;
float current_yaw   =  0.00000;
float sight_entity_time   =  0.00000;

float  (float v)anglemod =  {
   while ( (v >= 360.00000) ) {

      v = (v - 360.00000);

   }
   while ( (v < 0.00000) ) {

      v = (v + 360.00000);

   }
   return ( v );
};


float  (entity targ)range =  {
local vector spot1 = '0.00000 0.00000 0.00000';
local vector spot2 = '0.00000 0.00000 0.00000';
local float r = 0.00000;
local float melee = 0.00000;
   if ( (((self.solid == SOLID_BSP) || (self.solid == SOLID_TRIGGER)) && (self.origin == '0.00000 0.00000 0.00000')) ) {

      spot1 = ((self.absmax + self.absmin) * 0.50000);
   } else {

      spot1 = (self.origin + self.view_ofs);

   }
   if ( (((targ.solid == SOLID_BSP) || (targ.solid == SOLID_TRIGGER)) && (targ.origin == '0.00000 0.00000 0.00000')) ) {

      spot2 = ((targ.absmax + targ.absmin) * 0.50000);
   } else {

      spot2 = (targ.origin + targ.view_ofs);

   }
   r = vlen ( (spot1 - spot2));
   if ( (self.classname == "monster_mummy") ) {

      melee = 50.00000;
   } else {

      melee = 100.00000;

   }
   if ( (r < melee) ) {

      return ( RANGE_MELEE );

   }
   if ( (r < 500.00000) ) {

      return ( RANGE_NEAR );

   }
   if ( (r < 1000.00000) ) {

      return ( RANGE_MID );

   }
   return ( RANGE_FAR );
};


float  (entity targ,entity forent)visible2ent =  {
local vector spot1 = '0.00000 0.00000 0.00000';
local vector spot2 = '0.00000 0.00000 0.00000';
   if ( (((forent.solid == SOLID_BSP) || (forent.solid == SOLID_TRIGGER)) && (forent.origin == '0.00000 0.00000 0.00000')) ) {

      spot1 = ((forent.absmax + forent.absmin) * 0.50000);
   } else {

      spot1 = (forent.origin + forent.view_ofs);

   }
   if ( (((targ.solid == SOLID_BSP) || (targ.solid == SOLID_TRIGGER)) && (targ.origin == '0.00000 0.00000 0.00000')) ) {

      spot2 = ((targ.absmax + targ.absmin) * 0.50000);
   } else {

      spot2 = (targ.origin + targ.view_ofs);

   }
   traceline ( spot1, spot2, TRUE, forent);
   if ( (trace_ent.thingtype >= THINGTYPE_WEBS) ) {

      traceline ( trace_endpos, spot2, TRUE, trace_ent);
   } else {

      if ( (trace_inopen && trace_inwater) ) {

         return ( FALSE );

      }

   }
   if ( (trace_fraction == 1.00000) ) {

      return ( TRUE );

   }
   return ( FALSE );
};


float  (entity targ,entity from)infront_of_ent =  {
local vector vec = '0.00000 0.00000 0.00000';
local vector spot1 = '0.00000 0.00000 0.00000';
local vector spot2 = '0.00000 0.00000 0.00000';
local float accept = 0.00000;
local float dot = 0.00000;
   if ( (from.classname == "player") ) {

      makevectors ( from.v_angle);
   } else {

      makevectors ( from.angles);

   }
   if ( (((from.solid == SOLID_BSP) || (from.solid == SOLID_TRIGGER)) && (from.origin == '0.00000 0.00000 0.00000')) ) {

      spot1 = ((from.absmax + from.absmin) * 0.50000);
   } else {

      spot1 = (from.origin + from.view_ofs);

   }
   spot2 = ((targ.absmax + targ.absmin) * 0.50000);
   vec = normalize ( (spot2 - spot1));
   dot = (vec * v_forward);
   accept = 0.30000;
   if ( (dot > accept) ) {

      return ( TRUE );

   }
   return ( FALSE );
};


float  (entity targ)visible =  {
   return ( visible2ent ( targ, self) );
};


float  (entity targ)infront =  {
   return ( infront_of_ent ( targ, self) );
};


void  ()HuntTarget =  {
   self.goalentity = self.enemy;
   if ( (self.spawnflags & PLAY_DEAD) ) {

      self.think = self.th_possum_up;
      self.spawnflags ^= PLAY_DEAD;
   } else {

      self.think = self.th_run;

   }
   self.ideal_yaw = vectoyaw ( (self.goalentity.origin - self.origin));
   AdvanceThinkTime(self,0.10000);
};


void  ()SightSound =  {
   if ( (self.classname == "monster_archer") ) {

      sound ( self, CHAN_VOICE, "archer/sight.wav", 1.00000, ATTN_NORM);
   } else {

      if ( (self.classname == "monster_archer_lord") ) {

         sound ( self, CHAN_VOICE, "archer/sight2.wav", 1.00000, ATTN_NORM);
      } else {

         if ( (self.classname == "monster_mummy") ) {

            sound ( self, CHAN_WEAPON, "mummy/sight.wav", 1.00000, ATTN_NORM);
         } else {

            if ( (self.classname == "monster_mummy_lord") ) {

               sound ( self, CHAN_WEAPON, "mummy/sight2.wav", 1.00000, ATTN_NORM);

            }

         }

      }

   }
};


void  ()FoundTarget =  {
   if ( (self.enemy.classname == "player") ) {

      sight_entity = self;
      sight_entity_time = (time + 1.00000);

   }
   self.show_hostile = (time + 1.00000);
   SightSound ( );
   HuntTarget ( );
};


float  (float dont_hunt)FindTarget =  {
local entity client;
local float r = 0.00000;
   if ( (!deathmatch && ((self.classname == "monster_imp_lord") || (self.classname == "cube_of_force"))) ) {

      return ( FindMonsterTarget ( ) );

   }
   if ( (sight_entity_time >= time) ) {

      client = sight_entity;
      if ( (client.enemy == self.enemy) ) {

         return ( TRUE );

      }
   } else {

      client = checkclient ( );
      if ( !client ) {

         return ( FALSE );

      }

   }
   if ( (client == self.enemy) ) {

      return ( FALSE );

   }
   if ( (client.flags & FL_NOTARGET) ) {

      return ( FALSE );

   }
   r = range ( client);
   if ( (r == RANGE_FAR) ) {

      return ( FALSE );

   }
   if ( !visibility_good ( client) ) {

      return ( FALSE );

   }
   if ( (self.think != spider_onwall_wait) ) {

      if ( (r == RANGE_NEAR) ) {

         if ( ((client.show_hostile < time) && !infront ( client)) ) {

            return ( FALSE );

         }
      } else {

         if ( (r == RANGE_MID) ) {

            if ( !infront ( client) ) {

               return ( FALSE );

            }

         }

      }

   }
   if ( !visible ( client) ) {

      return ( FALSE );

   }
   self.enemy = client;
   if ( (self.enemy.classname != "player") ) {

      self.enemy = self.enemy.enemy;
      if ( (self.enemy.classname != "player") ) {

         self.enemy = world;
         return ( FALSE );

      }

   }
   if ( !dont_hunt ) {

      FoundTarget ( );

   }
   return ( TRUE );
};

void  ()SpiderJumpBegin;

void  (float dist)ai_forward =  {
   walkmove ( self.angles_y, dist, FALSE);
};


void  (float dist)ai_back =  {
   walkmove ( (self.angles_y + 180.00000), dist, FALSE);
};


void  (float dist)ai_pain =  {
local float away = 0.00000;
   vectoyaw ( (self.origin - self.enemy.origin));
   away = (random(0.50000,-0.50000) + (90.00000 * random(0.50000,-0.50000)));
   walkmove ( away, dist, FALSE);
};


void  (float dist)ai_painforward =  {
   walkmove ( self.ideal_yaw, dist, FALSE);
};


void  (float dist)ai_walk =  {
   MonsterCheckContents ( );
   movedist = dist;
   if ( FindTarget ( FALSE) ) {

      return ;

   }
   movetogoal ( dist);
};


void  ()ai_stand =  {
   MonsterCheckContents ( );
   if ( FindTarget ( FALSE) ) {

      return ;

   }
   if ( (self.spawnflags & PLAY_DEAD) ) {

      return ;

   }
   if ( (time > self.pausetime) ) {

      self.th_walk ( );
      return ;

   }
};


void  ()ai_turn =  {
   if ( FindTarget ( FALSE) ) {

      return ;

   }
   ChangeYaw ( );
};


void  (vector dest3)ChooseTurn =  {
local vector dir = '0.00000 0.00000 0.00000';
local vector newdir = '0.00000 0.00000 0.00000';
   dir = (self.origin - dest3);
   newdir_x = trace_plane_normal_y;
   newdir_y = (0.00000 - trace_plane_normal_x);
   newdir_z = 0.00000;
   if ( ((dir * newdir) > 0.00000) ) {

      dir_x = (0.00000 - trace_plane_normal_y);
      dir_y = trace_plane_normal_x;
   } else {

      dir_x = trace_plane_normal_y;
      dir_y = (0.00000 - trace_plane_normal_x);

   }
   dir_z = 0.00000;
   self.ideal_yaw = vectoyaw ( dir);
};


float  ()FacingIdeal =  {
local float delta = 0.00000;
   delta = anglemod ( (self.angles_y - self.ideal_yaw));
   if ( ((delta > 45.00000) && (delta < 315.00000)) ) {

      return ( FALSE );

   }
   return ( TRUE );
};


float  ()CheckAnyAttack =  {
   if ( ((self.model == "models/medusa.mdl") || (self.model == "models/medusa2.mdl")) ) {

      return ( MedusaCheckAttack ( ) );

   }
   if ( !enemy_vis ) {

      return ( FALSE );

   }
   if ( (self.model == "models/archer.mdl") ) {

      return ( ArcherCheckAttack ( ) );

   }
   if ( (self.goalentity == self.controller) ) {

      return ( FALSE );

   }
   return ( CheckAttack ( ) );
};


void  ()ai_attack_face =  {
   self.ideal_yaw = enemy_yaw;
   ChangeYaw ( );
   if ( FacingIdeal ( ) ) {

      if ( (self.attack_state == AS_MISSILE) ) {

         self.th_missile ( );
      } else {

         if ( (self.attack_state == AS_MELEE) ) {

            self.th_melee ( );

         }

      }
      self.attack_state = AS_STRAIGHT;

   }
};


void  ()ai_run_slide =  {
local float ofs = 0.00000;
   self.ideal_yaw = enemy_yaw;
   ChangeYaw ( );
   if ( self.lefty ) {

      ofs = 90.00000;
   } else {

      ofs = -90.00000;

   }
   if ( walkmove ( (self.ideal_yaw + ofs), movedist, FALSE) ) {

      return ;

   }
   self.lefty = (1.00000 - self.lefty);
   walkmove ( (self.ideal_yaw - ofs), movedist, FALSE);
};


void  (float dist)ai_run =  {
   MonsterCheckContents ( );
   movedist = dist;
   if ( (!(self.enemy.flags2 & FL_ALIVE) || ((self.enemy.artifact_active & ARTFLAG_STONED) && (self.classname != "monster_medusa"))) ) {

      self.enemy = world;
      if ( (self.oldenemy.health > 0.00000) ) {

         self.enemy = self.oldenemy;
         HuntTarget ( );
      } else {

         if ( coop ) {

            if ( !FindTarget ( TRUE) ) {

               if ( self.pathentity ) {

                  self.th_walk ( );
               } else {

                  self.th_stand ( );

               }
               return ;

            }
         } else {

            if ( self.pathentity ) {

               self.th_walk ( );
            } else {

               self.th_stand ( );

            }
            return ;

         }

      }

   }
   self.show_hostile = (time + 1.00000);
   enemy_vis = visible ( self.enemy);
   if ( enemy_vis ) {

      self.search_time = (time + 5.00000);
      if ( self.mintel ) {

         self.goalentity = self.enemy;
         self.wallspot = ((self.enemy.absmin + self.enemy.absmax) * 0.50000);

      }
   } else {

      if ( coop ) {

         if ( !FindTarget ( TRUE) ) {

            if ( (self.model == "models/spider.mdl") ) {

               if ( (random() < 0.50000) ) {

                  SetNextWaypoint ( );

               }
            } else {

               SetNextWaypoint ( );

            }

         }

      }
      if ( self.mintel ) {

         if ( (self.model == "models/spider.mdl") ) {

            if ( (random() < 0.50000) ) {

               SetNextWaypoint ( );

            }
         } else {

            SetNextWaypoint ( );

         }

      }

   }
   if ( ((((random() < 0.50000) && !(self.flags & FL_SWIM)) && !(self.flags & FL_FLY)) && (self.spawnflags & JUMP)) ) {

      CheckJump ( );

   }
   if ( (coop && (self.search_time < time)) ) {

      if ( FindTarget ( FALSE) ) {

         return ;

      }

   }
   enemy_infront = infront ( self.enemy);
   enemy_range = range ( self.enemy);
   enemy_yaw = vectoyaw ( (self.goalentity.origin - self.origin));
   if ( ((self.attack_state == AS_MISSILE) || (self.attack_state == AS_MELEE)) ) {

      ai_attack_face ( );
      return ;

   }
   if ( CheckAnyAttack ( ) ) {

      return ;

   }
   if ( (self.attack_state == AS_SLIDING) ) {

      ai_run_slide ( );
      return ;

   }
   movetogoal ( dist);
};

void  ()monster_imp_fire;
void  ()monster_imp_ice;
void  ()monster_archer;
void  ()monster_skull_wizard;
void  ()monster_scorpion_black;
void  ()monster_scorpion_yellow;
void  ()monster_spider_red_large;
void  ()monster_spider_red_small;
void  ()monster_spider_yellow_large;
void  ()monster_spider_yellow_small;
void  (vector org,entity death_owner)spawn_tdeath;

void  ()spawnspot_activate =  {
   self.deadflag = FALSE;
};


float  ()monster_spawn_precache =  {
local float have_monsters = 0.00000;
   if ( (self.spawnflags & IMP) ) {

      precache_model2 ( "models/imp.mdl");
      precache_model2 ( "models/h_imp.mdl");
      precache_sound2 ( "imp/up.wav");
      precache_sound2 ( "imp/die.wav");
      precache_sound2 ( "imp/swoop.wav");
      precache_sound2 ( "imp/fly.wav");
      precache_model2 ( "models/shardice.mdl");
      precache_model ( "models/fireball.mdl");
      precache_sound2 ( "imp/swoophit.wav");
      precache_sound2 ( "imp/fireball.wav");
      precache_sound2 ( "imp/shard.wav");
      precache_sound ( "hydra/turn-s.wav");
      have_monsters = TRUE;

   }
   if ( (self.spawnflags & ARCHER) ) {

      precache_archer ( );
      have_monsters = TRUE;

   }
   if ( (self.spawnflags & WIZARD) ) {

      precache_model ( "models/skullwiz.mdl");
      precache_model ( "models/skulbook.mdl");
      precache_model ( "models/skulhead.mdl");
      precache_model ( "models/skulshot.mdl");
      precache_model ( "models/spider.mdl");
      precache_sound ( "skullwiz/death.wav");
      precache_sound ( "skullwiz/blinkspk.wav");
      precache_sound ( "skullwiz/growl.wav");
      precache_sound ( "skullwiz/scream.wav");
      precache_sound ( "skullwiz/pain.wav");
      precache_sound ( "skullwiz/gate.wav");
      precache_sound ( "skullwiz/blinkin.wav");
      precache_sound ( "skullwiz/blinkout.wav");
      precache_sound ( "skullwiz/push.wav");
      precache_sound ( "skullwiz/firemisl.wav");
      precache_spider ( );
      have_monsters = TRUE;

   }
   if ( (self.spawnflags & SCORPION) ) {

      precache_model2 ( "models/scorpion.mdl");
      precache_sound2 ( "scorpion/awaken.wav");
      precache_sound2 ( "scorpion/walk.wav");
      precache_sound2 ( "scorpion/clawsnap.wav");
      precache_sound2 ( "scorpion/tailwhip.wav");
      precache_sound2 ( "scorpion/pain.wav");
      precache_sound2 ( "scorpion/death.wav");
      have_monsters = TRUE;

   }
   if ( (self.spawnflags & SPIDER) ) {

      precache_spider ( );
      have_monsters = TRUE;

   }
   return ( have_monsters );
};


float  ()check_monsterspawn_ok =  {
local vector org = '0.00000 0.00000 0.00000';
local entity findspot;
local float foundspot = 0.00000;
local float founddead = 0.00000;
local float foundthink = 0.00000;
local float rnd = 0.00000;
   if ( self.spawnername ) {

      findspot = find ( self.controller, netname, self.netname);
      while ( !foundspot ) {

         if ( (findspot.spawnername == self.spawnername) ) {

            if ( (findspot.aflag == (self.level + 1.00000)) ) {

               if ( findspot.deadflag ) {

                  founddead = TRUE;
                  self.level = findspot.aflag;
               } else {

                  foundspot = TRUE;

               }

            }
            if ( (findspot == self.controller) ) {

               if ( (self.level == 0.00000) ) {

                  if ( founddead ) {

                     return ( FALSE );
                  } else {

                     remove ( self);
                     return ( FALSE );

                  }
               } else {

                  self.level = 0.00000;

               }

            }

         }
         if ( !foundspot ) {

            findspot = find ( findspot, netname, self.netname);

         }

      }
      self.level = findspot.aflag;
      self.controller = findspot;
      org = findspot.origin;
   } else {

      org = self.origin;

   }
   if ( ((self.controller.spawnflags & ONDEATH) && (self.controller.goalentity.flags2 & FL_ALIVE)) ) {

      return ( FALSE );

   }
   tracearea ( org, org, self.mins, self.maxs, FALSE, self);
   newmis = spawn ( );
   if ( (trace_fraction < 1.00000) ) {

      if ( (trace_ent.flags2 & FL_ALIVE) ) {

         remove ( newmis);
         return ( FALSE );
      } else {

         spawn_tdeath ( trace_ent.origin, newmis);

      }

   }
   newmis.angles = self.angles;
   newmis.flags2 += FL_SUMMONED;
   while ( !foundthink ) {

      rnd = rint ( random(1.00000,5.00000));
      rnd = byte_me ( rnd);
      if ( (self.controller.spawnflags & rnd) ) {

         foundthink = TRUE;

      }

   }
   if ( (rnd == IMP) ) {

      if ( (random() < 0.50000) ) {

         newmis.classname = "monster_imp_ice";
         newmis.think = monster_imp_ice;
      } else {

         newmis.classname = "monster_imp_fire";
         newmis.think = monster_imp_fire;

      }
   } else {

      if ( (rnd == ARCHER) ) {

         newmis.classname = "monster_archer";
         newmis.think = monster_archer;
      } else {

         if ( (rnd == WIZARD) ) {

            newmis.classname = "monster_skull_wizard";
            newmis.think = monster_skull_wizard;
         } else {

            if ( (rnd == SCORPION) ) {

               if ( (random() < 0.50000) ) {

                  newmis.classname = "monster_scorpion_black";
                  newmis.think = monster_scorpion_black;
               } else {

                  newmis.classname = "monster_scorpion_yellow";
                  newmis.think = monster_scorpion_yellow;

               }
            } else {

               rnd = rint ( random(1.00000,4.00000));
               if ( (rnd == 4.00000) ) {

                  newmis.classname = "monster_spider_yellow_large";
                  newmis.think = monster_spider_yellow_large;
               } else {

                  if ( (rnd == 3.00000) ) {

                     newmis.classname = "monster_spider_yellow_small";
                     newmis.think = monster_spider_yellow_small;
                  } else {

                     if ( (rnd == 2.00000) ) {

                        newmis.classname = "monster_spider_red_large";
                        newmis.think = monster_spider_red_large;
                     } else {

                        newmis.classname = "monster_spider_red_small";
                        newmis.think = monster_spider_red_small;

                     }

                  }

               }

            }

         }

      }

   }
   self.controller.goalentity = newmis;
   setorigin ( newmis, org);
   if ( !(self.controller.spawnflags & QUIET) ) {

      spawn_tfog ( org);

   }
   newmis.nextthink = time;
   return ( TRUE );
};


void  ()monsterspawn_active =  {
   self.think = monsterspawn_active;
   if ( check_monsterspawn_ok ( ) ) {

      self.controller.frags += 1.00000;
      if ( (self.controller != self) ) {

         self.frags += 1.00000;

      }
      if ( (self.controller != self) ) {

         self.controller.deadflag = TRUE;
         self.controller.think = self.controller.use;
         self.controller.nextthink = (time + self.controller.wait);

      }
      if ( (self.controller.frags >= self.controller.cnt) ) {

         remove ( self.controller);

      }
      if ( (self.frags >= self.cnt) ) {

         remove ( self);

      }
      if ( (self.spawnflags & TRIGGERONLY) ) {

         self.nextthink = -1.00000;
      } else {

         self.nextthink = (time + self.wait);

      }
   } else {

      if ( (self.spawnflags & TRIGGERONLY) ) {

         self.nextthink = -1.00000;
      } else {

         self.nextthink = (time + 0.10000);

      }

   }
};


void  ()func_monsterspawner =  {
   if ( !self.cnt ) {

      self.cnt = 17.00000;

   }
   if ( !self.wait ) {

      self.wait = 0.50000;

   }
   self.netname = "monsterspawn_spot";
   if ( self.spawnername ) {

      self.controller = world;
   } else {

      self.controller = self;

   }
   self.level = 0.00000;
   setsize ( self, '-16.00000 -16.00000 0.00000', '16.00000 16.00000 56.00000');
   setorigin ( self, self.origin);
   if ( (!monster_spawn_precache ( ) && !self.spawnername) ) {

      remove ( self);

   }
   if ( self.targetname ) {

      self.use = monsterspawn_active;
   } else {

      self.think = monsterspawn_active;
      self.nextthink = (time + 3.00000);

   }
};


void  ()func_monsterspawn_spot =  {
   if ( !self.aflag ) {

      dprint ( "Ooo!  You didn't include me in the spawn cycle!  FIX ME!\n");
      remove ( self);

   }
   if ( !self.cnt ) {

      self.cnt = 17.00000;

   }
   self.netname = "monsterspawn_spot";
   if ( !monster_spawn_precache ( ) ) {

      dprint ( "You didn't give me any monsters to spawn!!!\n");
      remove ( self);

   }
   setsize ( self, '-16.00000 -16.00000 0.00000', '16.00000 16.00000 56.00000');
   setorigin ( self, self.origin);
   if ( self.targetname ) {

      self.deadflag = TRUE;
   } else {

      self.use = spawnspot_activate;

   }
};


void  ()hive_die =  {
};


void  (entity attacker)spawn_ghost =  {
};


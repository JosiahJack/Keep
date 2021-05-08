float SPAWNFLAG_BALLISTA_TRACK   =  1.00000;
void  (float vol)sheep_sound;
void  ()obj_barrel_roll;
void  ()float;
void  ()sheep_trot;

void  (entity loser)obj_fly_hurt =  {
local float magnitude = 0.00000;
local float my_mass = 0.00000;
local vector dir1 = '0.00000 0.00000 0.00000';
local vector dir2 = '0.00000 0.00000 0.00000';
local float force = 0.00000;
local float dot = 0.00000;
   if ( ((self.frozen > 0.00000) && (other.classname == "snowball")) ) {

      return ;

   }
   if ( (self.classname == "player") ) {

      my_mass = self.mass;
   } else {

      if ( !self.mass ) {

         my_mass = 1.00000;
      } else {

         if ( (self.mass <= 10.00000) ) {

            my_mass = 10.00000;
         } else {

            my_mass = (self.mass / 10.00000);

         }

      }

   }
   magnitude = ((vlen ( self.velocity) * my_mass) / 10.00000);
   if ( (pointcontents ( self.absmax) == CONTENT_WATER) ) {

      magnitude /= 3.00000;

   }
   if ( ((self.classname == "barrel") && self.aflag) ) {

      magnitude *= 3.00000;

   }
   if ( ((((((self.frozen > 0.00000) && (magnitude < 300.00000)) && (self.flags & FL_ONGROUND)) && (loser == world)) && (self.velocity_z < -20.00000)) && ((self.last_onground + 0.30000) < time)) ) {

      magnitude = 300.00000;

   }
   if ( ((self.last_onground + 0.30000) < time) ) {

      if ( ((((magnitude >= 100.00000) && loser.takedamage) && (loser.classname != "catapult")) && (loser != world)) ) {

         dir1 = normalize ( self.velocity);
         if ( (loser.origin == '0.00000 0.00000 0.00000') ) {

            dir2 = dir1;
         } else {

            dir2 = normalize ( (loser.origin - self.origin));

         }
         dot = (dir1 * dir2);
         if ( (dot >= 0.20000) ) {

            force = dot;
         } else {

            force = 0.00000;

         }
         force *= (magnitude / 50.00000);
         if ( ((pointcontents ( loser.absmax) == CONTENT_WATER) || ((self.classname == "barrel") && self.aflag)) ) {

            force /= 3.00000;

         }
         if ( ((self.flags & FL_MONSTER) && (loser == world)) ) {

            force /= 2.00000;

         }
         if ( ((self.frozen > 0.00000) && (force > 10.00000)) ) {

            force = 10.00000;

         }
         if ( (((force >= 1.00000) && (loser.classname != "player")) || (force >= 10.00000)) ) {

            T_Damage ( loser, self, self, force);

         }

      }
      if ( ((self.classname != "monster_mezzoman") && (self.netname != "spider")) ) {

         if ( (((magnitude >= (100.00000 + self.health)) && (self.classname != "player")) || (magnitude >= 700.00000)) ) {

            if ( (((self.classname == "player") && (self.flags & FL_ONGROUND)) && (magnitude < 1000.00000)) ) {

               magnitude /= 2.00000;
               if ( (self.absorb_time >= time) ) {

                  magnitude /= 2.00000;

               }

            }
            magnitude /= 40.00000;
            magnitude = (magnitude - (force / 2.00000));
            if ( (magnitude >= 1.00000) ) {

               if ( (((self.classname == "player_sheep") && (self.flags & FL_ONGROUND)) && (self.velocity_z > -50.00000)) ) {

                  return ;

               }
               T_Damage ( self, world, world, magnitude);

            }

         }

      }
      self.last_impact = time;
      if ( (self.flags & FL_ONGROUND) ) {

         self.last_onground = time;

      }

   }
};


void  ()obj_push =  {
local vector pushdir = '0.00000 0.00000 0.00000';
local vector pushangle = '0.00000 0.00000 0.00000';
local float ontop = 0.00000;
local float pushed = 0.00000;
local float inertia = 0.00000;
local float force = 0.00000;
local float walkforce = 0.00000;
local vector dir1 = '0.00000 0.00000 0.00000';
local vector dir2 = '0.00000 0.00000 0.00000';
local float dot_forward = 0.00000;
local float dot_right = 0.00000;
   if ( (((other.solid == SOLID_PHASE) || (other.movetype == MOVETYPE_FLYMISSILE)) || (other.movetype == MOVETYPE_BOUNCEMISSILE)) ) {

      return ;

   }
   if ( (((self.classname == "barrel") && (pointcontents ( self.origin) != CONTENT_EMPTY)) && !(self.spawnflags & BARREL_SINK)) ) {

      self.classname = "barrel_floating";
      self.think = float;
      self.nextthink = time;

   }
   if ( ((self.classname == "player_sheep") && (other.classname == "catapult")) ) {

      self.spawnflags |= 1.00000;

   }
   if ( ((self.last_impact + 0.10000) <= time) ) {

      obj_fly_hurt ( other);

   }
   if ( (((other != world) && (other.absmin_z >= ((self.origin_z + self.maxs_z) - 5.00000))) && (other.velocity_z < 1.00000)) ) {

      if ( ((!(other.flags2 & FL_ALIVE) && (other.flags & FL_MONSTER)) || (((self.flags & FL_MONSTER) && (self.model != "models/spider.mdl")) && (self.model != "models/scorpion.mdl"))) ) {

         makevectors ( other.angles);
         v_forward_z = 1.00000;
         other.velocity = (v_forward * 3200.00000);
         other.flags ^= FL_ONGROUND;

      }
      if ( (other.flags & FL_CLIENT) ) {

         ontop = FALSE;
      } else {

         ontop = TRUE;

      }

   }
   if ( (self.flags & FL_MONSTER) ) {

      if ( ((((((other != world) && (self.absmin_z >= (other.absmax_z - 3.00000))) && (self.velocity_z < 1.00000)) && (other.movetype != MOVETYPE_FLYMISSILE)) && (other.movetype != MOVETYPE_BOUNCE)) && (other.movetype != MOVETYPE_BOUNCEMISSILE)) ) {

         self.flags |= FL_ONGROUND;

      }
      if ( ((self.frozen <= 0.00000) && !(self.artifact_active & ARTFLAG_STONED)) ) {

         return ;

      }

   }
   if ( !other.velocity ) {

      return ;

   }
   if ( (self.impulse == 20.00000) ) {

      return ;

   }
   if ( !self.mass ) {

      inertia = 1.00000;

   }
   if ( (self.mass <= 30.00000) ) {

      inertia = (self.mass / 3.00000);
   } else {

      inertia = (self.mass / 33.00000);

   }
   if ( other.strength ) {

      force = (vlen ( other.velocity) * ((other.strength / 40.00000) + 0.50000));
   } else {

      force = vlen ( other.velocity);

   }
   if ( (((pointcontents ( self.origin) == CONTENT_WATER) || (pointcontents ( self.origin) == CONTENT_SLIME)) || (pointcontents ( self.origin) == CONTENT_LAVA)) ) {

      force /= 3.00000;

   }
   if ( (self.mass >= 1000.00000) ) {

      return ;

   }
   if ( (self.frozen > 0.00000) ) {

      self.freeze_time = (time + 10.00000);
      self.wait = (time + 10.00000);

   }
   if ( ontop ) {

      return ;

   }
   walkforce = ((force / inertia) / 40.00000);
   if ( ((self.classname == "barrel") && self.aflag) ) {

      self.angles_z = 0.00000;
      self.v_angle_z = 0.00000;
      self.v_angle_x = 0.00000;
      makevectors ( self.v_angle);
      if ( ontop ) {

         dir1 = normalize ( other.velocity);
      } else {

         dir1 = normalize ( (self.origin - other.origin));

      }
      dir2 = normalize ( v_forward);
      dir2_z = 0.00000;
      dir1_z = 0.00000;
      dot_forward = (dir1 * dir2);
      self.enemy = other;
      if ( (dot_forward >= 0.90000) ) {

         self.movedir = dir2;
         self.movedir_z = 0.00000;
         self.speed += (force / inertia);
         if ( (self.speed > (other.strength * 300.00000)) ) {

            self.speed = (other.strength * 300.00000);

         }
         traceline ( self.origin, (self.origin + (dir2 * 48.00000)), FALSE, self);
         if ( (trace_fraction == 1.00000) ) {

            self.velocity = (self.movedir * self.speed);
            self.think = obj_barrel_roll;
            self.nextthink = time;

         }
      } else {

         if ( (dot_forward <= -0.90000) ) {

            self.movedir = dir2;
            self.movedir_z = 0.00000;
            self.speed += ((force / inertia) * -1.00000);
            if ( (self.speed < (other.strength * -300.00000)) ) {

               self.speed = (other.strength * -300.00000);

            }
            traceline ( self.origin, (self.origin + (dir2 * -48.00000)), FALSE, self);
            if ( (trace_fraction == 1.00000) ) {

               self.velocity = (self.movedir * self.speed);
               self.think = obj_barrel_roll;
               self.nextthink = time;

            }
         } else {

            dir1 = normalize ( other.velocity);
            dir2 = normalize ( v_right);
            dot_right = (dir1 * dir2);
            if ( (dot_right > 0.20000) ) {

               if ( (dot_forward > 0.10000) ) {

                  self.angles_y -= (walkforce * 10.00000);
               } else {

                  if ( (dot_forward < -0.10000) ) {

                     self.angles_y += (walkforce * 10.00000);

                  }

               }
            } else {

               if ( (dot_right < -0.20000) ) {

                  if ( (dot_forward > 0.10000) ) {

                     self.angles_y += (walkforce * 10.00000);
                  } else {

                     if ( (dot_forward < -0.10000) ) {

                        self.angles_y -= (walkforce * 10.00000);

                     }

                  }

               }

            }
            self.v_angle_y = self.angles_y;

         }

      }
   } else {

      pushdir = normalize ( other.velocity);
      pushangle = vectoangles ( pushdir);
      pushed = FALSE;
      walkforce = ((force / inertia) / 20.00000);
      if ( !walkmove ( pushangle_y, walkforce, FALSE) ) {

         if ( (other.absmax_z <= (self.origin_z + (self.mins_z * 0.75000))) ) {

            pushdir_z *= 2.00000;

         }
         self.velocity = (((((pushdir * force) * 2.00000) * (1.00000 / inertia)) + self.velocity) * 0.50000);
         if ( (self.flags & FL_ONGROUND) ) {

            if ( (self.velocity_z < 0.00000) ) {

               self.velocity_z = 0.00000;

            }
            self.flags -= FL_ONGROUND;

         }
         if ( self.velocity ) {

            pushed = TRUE;

         }
      } else {

         pushed = TRUE;

      }
      if ( (pushed && (self.classname != "barrel_floating")) ) {

         if ( (self.pain_finished <= time) ) {

            if ( (self.classname == "player_sheep") ) {

               sheep_sound ( 0.75000);
               if ( (!infront ( other) && (random() < 0.50000)) ) {

                  self.think = sheep_trot;

               }
            } else {

               if ( (self.thingtype == THINGTYPE_WOOD) ) {

                  sound ( self, CHAN_VOICE, "misc/pushwood.wav", 1.00000, ATTN_NORM);
                  self.pain_finished = (time + 1.04100);
               } else {

                  if ( ((self.thingtype == THINGTYPE_GREYSTONE) || (self.thingtype == THINGTYPE_BROWNSTONE)) ) {

                     sound ( self, CHAN_VOICE, "misc/pushston.wav", 1.00000, ATTN_NORM);
                     self.pain_finished = (time + 0.71100);
                  } else {

                     if ( (self.thingtype == THINGTYPE_METAL) ) {

                        sound ( self, CHAN_VOICE, "misc/pushmetl.wav", 1.00000, ATTN_NORM);
                        self.pain_finished = (time + 0.83500);

                     }

                  }

               }

            }

         }

      }

   }
};


void  ()obj_chair =  {
   precache_model ( "models/chair.mdl");
   CreateEntityNew ( self, ENT_CHAIR, "models/chair.mdl", chunk_death);
   self.touch = obj_push;
   self.flags = (self.flags | FL_PUSH);
};


void  ()obj_barstool =  {
   precache_model2 ( "models/stool.mdl");
   CreateEntityNew ( self, ENT_BARSTOOL, "models/stool.mdl", chunk_death);
   self.touch = obj_push;
   self.flags = (self.flags | FL_PUSH);
};


void  ()obj_tree =  {
   precache_model2 ( "models/tree.mdl");
   CreateEntityNew ( self, ENT_TREEDEAD, "models/tree.mdl", chunk_death);
};


void  ()tree2_death =  {
   self.owner.nextthink = (time + 0.01000);
   self.owner.think = chunk_death;
   chunk_death ( );
};


void  ()obj_tree2 =  {
local entity top;
   precache_model ( "models/tree2.mdl");
   CreateEntityNew ( self, ENT_TREE, "models/tree2.mdl", tree2_death);
   top = spawn ( );
   top.scale = self.scale;
   CreateEntityNew ( top, ENT_TREETOP, top.model, tree2_death);
   top.origin = self.origin;
   if ( self.scale ) {

      top.origin_z += (top.scale * 104.00000);
   } else {

      top.origin_z += 104.00000;

   }
   top.health = self.health;
   top.classname = "tree2top";
   top.owner = self;
   self.owner = top;
};


void  ()obj_bench =  {
   precache_model2 ( "models/bench.mdl");
   CreateEntityNew ( self, ENT_BENCH, "models/bench.mdl", chunk_death);
   self.touch = obj_push;
};


void  ()obj_cart =  {
   precache_model ( "models/cart.mdl");
   CreateEntityNew ( self, ENT_CART, "models/cart.mdl", chunk_death);
   self.hull = HULL_SCORPION;
   self.touch = obj_push;
   self.flags = (self.flags | FL_PUSH);
};


void  ()obj_chest1 =  {
   precache_model ( "models/chest1.mdl");
   CreateEntityNew ( self, ENT_CHEST1, "models/chest1.mdl", chunk_death);
   self.touch = obj_push;
   self.flags = (self.flags | FL_PUSH);
};


void  ()obj_chest2 =  {
   precache_model2 ( "models/chest2.mdl");
   CreateEntityNew ( self, ENT_CHEST2, "models/chest2.mdl", chunk_death);
   self.touch = obj_push;
   self.flags = (self.flags | FL_PUSH);
};


void  ()obj_chest3 =  {
   precache_model2 ( "models/chest3.mdl");
   CreateEntityNew ( self, ENT_CHEST3, "models/chest3.mdl", chunk_death);
   self.touch = obj_push;
   self.flags = (self.flags | FL_PUSH);
};


void  ()obj_sword =  {
   precache_model ( "models/sword.mdl");
   CreateEntityNew ( self, ENT_SWORD, "models/sword.mdl", chunk_death);
   if ( self.targetname ) {

      self.use = chunk_death;

   }
};


void  ()BalBoltTouch =  {
local vector dir = '0.00000 0.00000 0.00000';
   if ( other.takedamage ) {

      if ( ((other != self.goalentity) && (self.velocity != '0.00000 0.00000 0.00000')) ) {

         self.goalentity = other;
         dir = normalize ( self.velocity);
         traceline ( (self.origin - (dir * 25.00000)), (self.origin + (dir * 25.00000)), FALSE, self);
         if ( (other.thingtype == THINGTYPE_FLESH) ) {

            MeatChunks ( trace_endpos, ((self.velocity * 0.50000) + '0.00000 0.00000 200.00000'), 3.00000);

         }
         SpawnPuff ( trace_endpos, ((self.velocity * 0.50000) + '0.00000 0.00000 200.00000'), self.dmg, trace_ent);
         T_Damage ( other, self, self.owner.enemy.enemy, self.dmg);

      }
      self.think = chunk_death;
      AdvanceThinkTime(self,0.20000);
      if ( ((other.solid == SOLID_BSP) || (normalize ( self.velocity) != self.movedir)) ) {

         chunk_death ( );

      }
   } else {

      chunk_death ( );

   }
};


void  ()FireBalBolt =  {
local vector org = '0.00000 0.00000 0.00000';
   newmis = spawn ( );
   newmis.owner = self;
   makevectors ( self.angles);
   org = ((self.origin + self.proj_ofs) + (v_forward * 10.00000));
   if ( (self.spawnflags & SPAWNFLAG_BALLISTA_TRACK) ) {

      newmis.velocity = (normalize ( (((self.enemy.absmax + self.enemy.absmin) * 0.50000) - org)) * 1000.00000);
   } else {

      newmis.velocity = (normalize ( (self.view_ofs - org)) * 1000.00000);
      traceline ( org, (org + newmis.velocity), FALSE, self);
      if ( ((trace_ent != self.goalentity) && self.goalentity.health) ) {

         newmis.velocity = (normalize ( (((self.goalentity.absmin + self.goalentity.absmax) * 0.50000) - org)) * 1000.00000);

      }

   }
   newmis.movedir = normalize ( newmis.velocity);
   newmis.movetype = MOVETYPE_FLYMISSILE;
   newmis.solid = SOLID_PHASE;
   newmis.thingtype = THINGTYPE_WOOD;
   newmis.touch = BalBoltTouch;
   newmis.angles = vectoangles ( newmis.velocity);
   newmis.avelocity_z = 500.00000;
   newmis.dmg = self.dmg;
   newmis.goalentity = newmis;
   setmodel ( newmis, "models/balbolt.mdl");
   setsize ( newmis, '0.00000 0.00000 0.00000', '0.00000 0.00000 0.00000');
   setorigin ( newmis, org);
};

void  ()ballista_think;

void  ()ballista_fire =  {
   AdvanceFrame( 1.00000, 30.00000);
   if ( (self.frame == 2.00000) ) {

      sound ( self, CHAN_WEAPON, "weapons/ballista.wav", 1.00000, ATTN_NORM);
   } else {

      if ( (self.frame == 4.00000) ) {

         FireBalBolt ( );
      } else {

         if ( (self.frame == 15.00000) ) {

            sound ( self, CHAN_WEAPON, "weapons/ballwind.wav", 1.00000, ATTN_NORM);

         }

      }

   }
   if ( cycle_wrapped ) {

      self.frame = 0.00000;
      self.last_attack = time;
      if ( (self.spawnflags & SPAWNFLAG_BALLISTA_TRACK) ) {

         self.think = ballista_think;
      } else {

         self.think = SUB_Null;

      }

   }
};


void  ()ballista_think =  {
local entity targ;
local float pitchmod = 0.00000;
local float checklooped = 0.00000;
local float bestdist = 0.00000;
local float lastdist = 0.00000;
local vector my_pitch = '0.00000 0.00000 0.00000';
local vector ideal_pitch = '0.00000 0.00000 0.00000';
   if ( ((((!self.enemy || !visible ( self.enemy)) || !(self.enemy.flags2 & FL_ALIVE)) && !(self.enemy.artifact_active & ART_INVISIBILITY)) && !(self.enemy.artifact_active & ART_INVINCIBILITY)) ) {

      targ = world;
      self.enemy = world;
      bestdist = 9999.00000;
      while ( !checklooped ) {

         targ = find ( targ, classname, "player");
         if ( (((visible ( targ) && (targ.flags2 & FL_ALIVE)) && !(targ.artifact_active & ART_INVISIBILITY)) && !(targ.artifact_active & ART_INVINCIBILITY)) ) {

            lastdist = vlen ( (targ.origin - self.origin));
            if ( (lastdist < bestdist) ) {

               bestdist = lastdist;
               self.enemy = targ;

            }

         }
         if ( (targ == world) ) {

            checklooped = TRUE;

         }

      }

   }
   if ( self.enemy ) {

      enemy_yaw = vectoyaw ( (self.enemy.origin - self.origin));
      ai_attack_face ( );
      makevectors ( self.angles);
      my_pitch = normalize ( v_forward);
      ideal_pitch = normalize ( (self.enemy.origin - self.origin));
      ideal_pitch = vectoangles ( ideal_pitch);
      if ( (ideal_pitch_z > my_pitch_z) ) {

         if ( ((ideal_pitch_z - my_pitch_z) > self.count) ) {

            pitchmod = self.count;
         } else {

            pitchmod = (ideal_pitch_z - my_pitch_z);

         }
         self.angles_z += pitchmod;
      } else {

         if ( (ideal_pitch_z < my_pitch_z) ) {

            if ( ((my_pitch_z - ideal_pitch_z) > self.count) ) {

               pitchmod = self.count;
            } else {

               pitchmod = (my_pitch_z - ideal_pitch_z);

            }
            self.angles_z -= pitchmod;

         }

      }
      if ( ((self.last_attack + self.speed) < time) ) {

         if ( visible ( self.enemy) ) {

            if ( infront ( self.enemy) ) {

               if ( (random() < 0.20000) ) {

                  ballista_fire ( );

               }

            }

         }

      }

   }
   self.nextthink = (self.ltime + 0.10000);
   self.think = ballista_think;
};


void  ()obj_ballista =  {
   precache_model ( "models/ballista.mdl");
   precache_model ( "models/balbolt.mdl");
   precache_sound ( "weapons/ballista.wav");
   precache_sound ( "weapons/ballwind.wav");
   if ( !self.mass ) {

      self.mass = 1000.00000;

   }
   CreateEntityNew ( self, ENT_BALLISTA, "models/ballista.mdl", chunk_death);
   self.hull = HULL_SCORPION;
   if ( !self.cnt ) {

      self.cnt = 30.00000;

   }
   if ( !self.count ) {

      self.count = 5.00000;

   }
   if ( !self.health ) {

      self.takedamage = DAMAGE_NO;

   }
   if ( !self.dmg ) {

      self.dmg = 50.00000;

   }
   if ( !self.speed ) {

      self.speed = 5.00000;

   }
   self.oldorigin = self.angles;
   if ( (self.spawnflags & SPAWNFLAG_BALLISTA_TRACK) ) {

      self.yaw_speed = self.count;
      self.th_missile = ballista_fire;
      self.think = ballista_think;
      self.nextthink = (time + 0.50000);
      self.last_attack = (time + 0.50000);

   }
   self.th_weapon = ballista_fire;
   self.proj_ofs = '0.00000 0.00000 48.00000';
   self.view_ofs = '0.00000 0.00000 48.00000';
};


void  (float anim)bell_attack =  {
local vector spot1 = '0.00000 0.00000 0.00000';
local vector spot2 = '0.00000 0.00000 0.00000';
local vector bell_angle = '0.00000 0.00000 0.00000';
   if ( !anim ) {

      bell_angle = self.v_angle;
   } else {

      bell_angle = self.v_angle;
      bell_angle_y = (self.v_angle_y - 180.00000);

   }
   makevectors ( bell_angle);
   spot1 = (self.origin + '0.00000 0.00000 -180.00000');
   spot2 = (spot1 + (v_forward * 150.00000));
   tracearea ( spot1, spot2, '-80.00000 -80.00000 0.00000', '80.00000 80.00000 64.00000', FALSE, self);
   if ( (trace_fraction == 1.00000) ) {

      return ;

   }
   if ( trace_ent.takedamage ) {

      sound ( self, CHAN_WEAPON, "weapons/gauntht1.wav", 1.00000, ATTN_NORM);
      if ( !(trace_ent.movetype == MOVETYPE_NONE) ) {

         if ( (trace_ent.flags & FL_ONGROUND) ) {

            trace_ent.flags = (trace_ent.flags - FL_ONGROUND);

         }
         trace_ent.velocity = (trace_ent.origin - self.origin);
         trace_ent.velocity_z = 280.00000;

      }

   }
};


void  ()bell_smallring =  {
   AdvanceFrame( 31.00000, 51.00000);
   self.nextthink = (((time + HX_FRAME_TIME) + HX_FRAME_TIME) + HX_FRAME_TIME);
   if ( cycle_wrapped ) {

      self.frame = 0.00000;
      self.nextthink = (time - 1.00000);
      self.think = SUB_Null;

   }
};


void  ()bell_bigring =  {
   AdvanceFrame( 0.00000, 30.00000);
   self.nextthink = (((time + HX_FRAME_TIME) + HX_FRAME_TIME) + HX_FRAME_TIME);
   if ( (self.frame == 2.00000) ) {

      sound ( self, CHAN_VOICE, "misc/bellring.wav", 1.00000, ATTN_IDLE);
      bell_attack ( 0.00000);

   }
   if ( (self.frame == 8.00000) ) {

      sound ( self, CHAN_VOICE, "misc/bellring.wav", 1.00000, ATTN_IDLE);
      bell_attack ( 1.00000);

   }
   if ( cycle_wrapped ) {

      self.frame = 0.00000;
      self.nextthink = (time - 1.00000);
      self.think = SUB_Null;

   }
};


void  ()bell_ring =  {
   if ( (self.frame != 0.00000) ) {

      return ;

   }
   if ( ((self.last_health - self.health) < 20.00000) ) {

      bell_smallring ( );
   } else {

      bell_bigring ( );

   }
   self.last_health = self.health;
};


void  ()obj_bell =  {
   precache_sound ( "misc/bellring.wav");
   precache_model ( "models/bellring.mdl");
   CreateEntityNew ( self, ENT_BELL, "models/bellring.mdl", chunk_death);
   self.last_health = self.health;
   self.th_pain = bell_ring;
   self.use = bell_bigring;
};


void  ()brush_pushable =  {
   self.max_health = self.health;
   self.solid = SOLID_SLIDEBOX;
   self.movetype = MOVETYPE_PUSHPULL;
   setorigin ( self, self.origin);
   setmodel ( self, self.model);
   self.classname = "pushable brush";
   self.touch = obj_push;
   self.hull = HULL_BIG;
   setsize ( self, self.mins, self.maxs);
   if ( !self.mass ) {

      self.mass = 5.00000;

   }
};


void  ()statue_death =  {
   if ( self.enemy ) {

      self.enemy.nextthink = (time + 0.01000);
      self.enemy.think = chunk_death;
      chunk_death ( );
   } else {

      chunk_death ( );

   }
};


void  ()obj_statue_mummy_head =  {
   precache_model2 ( "models/mhdstatu.mdl");
   CreateEntityNew ( self, ENT_STATUE_MUMMYHEAD, "models/mhdstatu.mdl", chunk_death);
   self.touch = obj_push;
   self.flags = (self.flags | FL_PUSH);
   self.drawflags += SCALE_ORIGIN_BOTTOM;
};


void  ()obj_statue_mummy =  {
local entity head;
   head = spawn ( );
   head.scale = self.scale;
   if ( self.scale ) {

      head.origin_z = (132.00000 * self.scale);
      head.mass = (150.00000 * self.scale);
   } else {

      head.origin_z = 132.00000;

   }
   head.origin += self.origin;
   head.angles = self.angles;
   self.enemy = head;
   precache_model2 ( "models/mumstatu.mdl");
   CreateEntityNew ( self, ENT_STATUE_MUMMY_BODY, "models/mumstatu.mdl", statue_death);
   self.drawflags += SCALE_ORIGIN_BOTTOM;
   precache_model2 ( "models/mhdstatu.mdl");
   CreateEntityNew ( head, ENT_STATUE_MUMMY_HEAD, "models/mhdstatu.mdl", statue_death);
   head.health = self.health;
   head.drawflags += SCALE_ORIGIN_BOTTOM;
};


void  ()obj_pot1 =  {
   precache_model ( "models/pot1.mdl");
   if ( (world.worldtype == WORLDTYPE_CASTLE) ) {

      self.skin = 0.00000;
   } else {

      if ( (world.worldtype == WORLDTYPE_EGYPT) ) {

         self.skin = 1.00000;
      } else {

         if ( (world.worldtype == WORLDTYPE_MESO) ) {

            self.skin = 2.00000;
         } else {

            if ( (world.worldtype == WORLDTYPE_ROMAN) ) {

               self.skin = 3.00000;

            }

         }

      }

   }
   CreateEntityNew ( self, ENT_POT1, "models/pot1.mdl", chunk_death);
   self.touch = obj_push;
   self.flags = (self.flags | FL_PUSH);
   self.drawflags += SCALE_ORIGIN_BOTTOM;
   if ( self.targetname ) {

      self.use = chunk_death;

   }
};


void  ()obj_pot2 =  {
   precache_model ( "models/pot2.mdl");
   if ( (world.worldtype == WORLDTYPE_CASTLE) ) {

      self.skin = 0.00000;
   } else {

      if ( (world.worldtype == WORLDTYPE_EGYPT) ) {

         self.skin = 1.00000;
      } else {

         if ( (world.worldtype == WORLDTYPE_MESO) ) {

            self.skin = 2.00000;
         } else {

            if ( (world.worldtype == WORLDTYPE_ROMAN) ) {

               self.skin = 3.00000;

            }

         }

      }

   }
   CreateEntityNew ( self, ENT_POT2, "models/pot2.mdl", chunk_death);
   self.touch = obj_push;
   self.flags = (self.flags | FL_PUSH);
   self.drawflags += SCALE_ORIGIN_BOTTOM;
   if ( self.targetname ) {

      self.use = chunk_death;

   }
};


void  ()obj_pot3 =  {
   precache_model ( "models/pot3.mdl");
   if ( (world.worldtype == WORLDTYPE_CASTLE) ) {

      self.skin = 0.00000;
   } else {

      if ( (world.worldtype == WORLDTYPE_EGYPT) ) {

         self.skin = 1.00000;
      } else {

         if ( (world.worldtype == WORLDTYPE_MESO) ) {

            self.skin = 2.00000;
         } else {

            if ( (world.worldtype == WORLDTYPE_ROMAN) ) {

               self.skin = 3.00000;

            }

         }

      }

   }
   CreateEntityNew ( self, ENT_POT3, "models/pot3.mdl", chunk_death);
   self.touch = obj_push;
   self.flags = (self.flags | FL_PUSH);
   self.drawflags += SCALE_ORIGIN_BOTTOM;
   if ( self.targetname ) {

      self.use = chunk_death;

   }
};


void  ()obj_statue_tut =  {
   precache_model2 ( "models/tutstatu.mdl");
   CreateEntityNew ( self, ENT_STATUE_TUT, "models/tutstatu.mdl", chunk_death);
   self.touch = obj_push;
   self.flags = (self.flags | FL_PUSH);
   self.drawflags += SCALE_ORIGIN_BOTTOM;
};


void  ()obj_flag =  {
   precache_model ( "models/flag.mdl");
   CreateEntityNew ( self, ENT_FLAG, "models/flag.mdl", chunk_death);
};


void  ()obj_statue_snake =  {
   precache_model2 ( "models/snkstatu.mdl");
   CreateEntityNew ( self, ENT_STATUE_SNAKE, "models/snkstatu.mdl", chunk_death);
   if ( (self.spawnflags & 1.00000) ) {

      self.health = 0.00000;
      self.takedamage = DAMAGE_NO;

   }
};


void  ()obj_hedge1 =  {
   precache_model2 ( "models/hedge1.mdl");
   CreateEntityNew ( self, ENT_HEDGE1, "models/hedge1.mdl", chunk_death);
};


void  ()obj_hedge2 =  {
   precache_model2 ( "models/hedge2.mdl");
   CreateEntityNew ( self, ENT_HEDGE2, "models/hedge2.mdl", chunk_death);
};


void  ()obj_hedge3 =  {
   precache_model2 ( "models/hedge3.mdl");
   CreateEntityNew ( self, ENT_HEDGE3, "models/hedge3.mdl", chunk_death);
};


void  ()obj_fountain =  {
   precache_model2 ( "models/fountain.mdl");
   CreateEntityNew ( self, ENT_FOUNTAIN, "models/fountain.mdl", chunk_death);
};


void  ()obj_book_open =  {
   precache_model ( "models/bookopen.mdl");
   CreateEntityNew ( self, ENT_BOOKOPEN, "models/bookopen.mdl", chunk_death);
   if ( self.targetname ) {

      self.use = chunk_death;

   }
};


void  ()obj_book_closed =  {
   precache_model ( "models/bookclos.mdl");
   CreateEntityNew ( self, ENT_BOOKCLOSED, "models/bookclos.mdl", chunk_death);
   if ( self.targetname ) {

      self.use = chunk_death;

   }
};


void  ()obj_fence =  {
   precache_model2 ( "models/fence.mdl");
   CreateEntityNew ( self, ENT_FENCE, "models/fence.mdl", chunk_death);
};


void  ()obj_bush1 =  {
   precache_model ( "models/bush1.mdl");
   CreateEntityNew ( self, ENT_BUSH1, "models/bush1.mdl", chunk_death);
};


void  ()obj_tombstone1 =  {
   precache_model ( "models/tombstn1.mdl");
   CreateEntityNew ( self, ENT_TOMBSTONE1, "models/tombstn1.mdl", chunk_death);
};


void  ()obj_tombstone2 =  {
   precache_model ( "models/tombstn2.mdl");
   CreateEntityNew ( self, ENT_TOMBSTONE2, "models/tombstn2.mdl", chunk_death);
};


void  ()obj_statue_angel =  {
   precache_model ( "models/anglstat.mdl");
   CreateEntityNew ( self, ENT_STATUE_ANGEL, "models/anglstat.mdl", chunk_death);
};


void  ()webs_think =  {
   AdvanceFrame( 1.00000, 100.00000);
   if ( (self.spawnflags & 8.00000) ) {

      self.touch = SUB_Null;
      if ( cycle_wrapped ) {

         self.touch = webs_think;
         self.nextthink = -1.00000;

      }

   }
};


void  ()webs_touch =  {
   if ( ((!other.movetype || (other.movetype == MOVETYPE_PUSHPULL)) || (other.classname == self.classname)) ) {

      return ;

   }
   if ( !(other.flags & FL_ONGROUND) ) {

      other.flags += FL_ONGROUND;

   }
};


void  ()webs_death =  {
   if ( ((!other.movetype || (other.movetype == MOVETYPE_PUSHPULL)) || (other.classname == self.classname)) ) {

      return ;

   }
   chunk_death ( );
};


void  ()obj_webs =  {
   if ( (self.skin == 4.00000) ) {

      precache_model2 ( "models/megaweb.mdl");
      CreateEntityNew ( self, ENT_WEB, "models/megaweb.mdl", chunk_death);
      self.skin = 0.00000;
   } else {

      precache_model2 ( "models/webs.mdl");
      CreateEntityNew ( self, ENT_WEB, "models/webs.mdl", chunk_death);

   }
   if ( !self.angles_y ) {

      self.angles = self.v_angle;
   } else {

      self.angles_x = self.v_angle_x;
      self.angles_z = self.v_angle_z;

   }
   if ( self.health ) {

      self.takedamage = DAMAGE_YES;
      self.solid = SOLID_TRIGGER;

   }
   if ( (self.spawnflags & 1.00000) ) {

      self.solid = SOLID_BBOX;
      self.touch = webs_touch;

   }
   if ( (self.spawnflags & 4.00000) ) {

      if ( !self.solid ) {

         self.solid = SOLID_TRIGGER;

      }
      self.touch = webs_death;

   }
   if ( (self.spawnflags & 8.00000) ) {

      if ( !self.solid ) {

         self.solid = SOLID_TRIGGER;

      }
      self.touch = webs_think;

   }
   if ( (self.spawnflags & 16.00000) ) {

      self.angles_x = 90.00000;
      self.angles_z = 0.00000;
      setsize ( self, '-25.00000 -25.00000 -2.00000', '25.00000 25.00000 2.00000');

   }
   if ( !(self.spawnflags & 32.00000) ) {

      self.drawflags = DRF_TRANSLUCENT;

   }
   setorigin ( self, self.origin);
   if ( (self.spawnflags & 2.00000) ) {

      self.think = webs_think;
      self.nextthink = time;

   }
};


void  ()obj_corpse1 =  {
   precache_model2 ( "models/corps1.mdl");
   CreateEntityNew ( self, ENT_CORPSE1, "models/corps1.mdl", chunk_death);
   self.use = chunk_death;
};


void  ()obj_corpse2 =  {
   precache_model ( "models/corps2.mdl");
   CreateEntityNew ( self, ENT_CORPSE2, "models/corps2.mdl", chunk_death);
   self.use = chunk_death;
};


void  ()cauldron_run =  {
local vector spot1 = '0.00000 0.00000 0.00000';
   spot1 = self.origin;
   spot1_z = (self.origin_z + 35.00000);
   CreateWhiteSmoke ( spot1, '0.00000 0.00000 8.00000', (HX_FRAME_TIME * 2.00000));
   self.think = cauldron_run;
   self.nextthink = (time + random(0.50000,1.50000));
};


void  ()obj_cauldron =  {
   precache_model ( "models/cauldron.mdl");
   CreateEntityNew ( self, ENT_CAULDRON, "models/cauldron.mdl", chunk_death);
   self.touch = obj_push;
   self.flags = (self.flags | FL_PUSH);
   self.drawflags += SCALE_ORIGIN_BOTTOM;
   self.think = cauldron_run;
   self.nextthink = (time + random(0.50000,1.50000));
};


void  ()obj_skullstick =  {
   precache_model2 ( "models/skllstk1.mdl");
   CreateEntityNew ( self, ENT_SKULLSTICK, "models/skllstk1.mdl", chunk_death);
};


void  ()obj_skull_stick2 =  {
   precache_model2 ( "models/skllstk2.mdl");
   CreateEntityNew ( self, ENT_SKULLSTICK, "models/skllstk2.mdl", chunk_death);
};


void  ()ice_touch =  {
   if ( (other.flags & FL_ONGROUND) ) {

      if ( (random() > self.friction) ) {

         other.flags -= FL_ONGROUND;

      }

   }
};


void  ()ice_slab_melt =  {
   if ( (self.scale > 0.05000) ) {

      self.scale -= 0.05000;
      setsize ( self, (self.mins * 0.90000), (self.maxs * 0.90000));
      AdvanceThinkTime(self,0.10000);
   } else {

      remove ( self);

   }
};


void  ()obj_ice =  {
   if ( (self.flags2 & FL_SUMMONED) ) {

      self.solid = SOLID_BBOX;
      self.movetype = MOVETYPE_NONE;
      self.drawflags |= SCALE_TYPE_XYONLY;
      self.scale = 1.00000;
      self.think = ice_slab_melt;
      AdvanceThinkTime(self,10.00000);
   } else {

      self.solid = SOLID_BSP;
      self.movetype = MOVETYPE_PUSH;

   }
   self.takedamage = DAMAGE_YES;
   self.thingtype = THINGTYPE_ICE;
   setorigin ( self, self.origin);
   setmodel ( self, self.model);
   self.frozen = TRUE;
   self.classname = "ice";
   self.use = chunk_death;
   self.drawflags += MLS_ABSLIGHT;
   if ( !self.abslight ) {

      self.abslight = 0.75000;

   }
   if ( !(self.spawnflags & 1.00000) ) {

      self.drawflags += DRF_TRANSLUCENT;

   }
   if ( !self.health ) {

      self.health = 20.00000;

   }
   self.max_health = self.health;
   if ( !self.friction ) {

      self.friction = 0.20000;

   }
   self.touch = ice_touch;
   self.th_die = chunk_death;
};


void  ()obj_beefslab =  {
   precache_model2 ( "models/beefslab.mdl");
   CreateEntityNew ( self, ENT_BEEFSLAB, "models/beefslab.mdl", chunk_death);
};


void  ()obj_seaweed =  {
   precache_model ( "models/seaweed.mdl");
   CreateEntityNew ( self, ENT_SEAWEED, "models/seaweed.mdl", chunk_death);
};


void  ()obj_statue_lion =  {
   precache_model2 ( "models/lion.mdl");
   CreateEntityNew ( self, ENT_STATUE_LION, "models/lion.mdl", chunk_death);
   self.drawflags += SCALE_ORIGIN_BOTTOM;
};


void  ()obj_statue_athena =  {
   precache_model2 ( "models/athena.mdl");
   CreateEntityNew ( self, ENT_STATUE_ATHENA, "models/athena.mdl", chunk_death);
   self.drawflags += SCALE_ORIGIN_BOTTOM;
};


void  ()obj_statue_neptune =  {
   precache_model2 ( "models/neptune.mdl");
   CreateEntityNew ( self, ENT_STATUE_NEPTUNE, "models/neptune.mdl", chunk_death);
   self.drawflags += SCALE_ORIGIN_BOTTOM;
};


void  ()obj_bonepile =  {
   precache_model2 ( "models/bonepile.mdl");
   CreateEntityNew ( self, ENT_BONEPILE, "models/bonepile.mdl", chunk_death);
   self.use = chunk_death;
   self.drawflags += SCALE_ORIGIN_BOTTOM;
};


void  ()obj_statue_caesar =  {
   precache_model2 ( "models/caesar.mdl");
   CreateEntityNew ( self, ENT_STATUE_CAESAR, "models/caesar.mdl", chunk_death);
   self.drawflags += SCALE_ORIGIN_BOTTOM;
};


void  ()obj_statue_snake_coil =  {
   precache_model2 ( "models/snake.mdl");
   CreateEntityNew ( self, ENT_STATUE_SNAKE_COIL, "models/snake.mdl", chunk_death);
   self.scale = 0.50000;
   self.drawflags += SCALE_ORIGIN_BOTTOM;
};


void  ()obj_skull =  {
   precache_model ( "models/skull.mdl");
   CreateEntityNew ( self, ENT_SKULL, "models/skull.mdl", chunk_death);
};


void  ()obj_pew =  {
   precache_model ( "models/pew.mdl");
   CreateEntityNew ( self, ENT_PEW, "models/pew.mdl", chunk_death);
};


void  ()obj_statue_olmec =  {
   precache_model2 ( "models/olmec1.mdl");
   CreateEntityNew ( self, ENT_STATUE_OLMEC, "models/olmec1.mdl", chunk_death);
};


void  ()obj_statue_mars =  {
   precache_model2 ( "models/mars.mdl");
   CreateEntityNew ( self, ENT_STATUE_MARS, "models/mars.mdl", chunk_death);
};


void  ()obj_playerhead_paladin =  {
   precache_model ( "models/h_pal.mdl");
   CreateEntityNew ( self, ENT_PLAYERHEAD, "models/h_pal.mdl", chunk_death);
   self.use = chunk_death;
};


void  ()obj_playerhead_assassin =  {
   precache_model ( "models/h_ass.mdl");
   CreateEntityNew ( self, ENT_PLAYERHEAD, "models/h_ass.mdl", chunk_death);
   self.use = chunk_death;
};


void  ()obj_playerhead_necromancer =  {
   precache_model2 ( "models/h_nec.mdl");
   CreateEntityNew ( self, ENT_PLAYERHEAD, "models/h_nec.mdl", chunk_death);
   self.use = chunk_death;
};


void  ()obj_playerhead_crusader =  {
   precache_model2 ( "models/h_cru.mdl");
   CreateEntityNew ( self, ENT_PLAYERHEAD, "models/h_cru.mdl", chunk_death);
   self.use = chunk_death;
};


void  ()obj_statue_king =  {
   precache_model2 ( "models/king.mdl");
   CreateEntityNew ( self, ENT_STATUE_KING, "models/king.mdl", chunk_death);
   self.mins -= '0.00000 0.00000 80.00000';
   self.maxs -= '0.00000 0.00000 80.00000';
   setsize ( self, self.mins, self.maxs);
};


void  ()obj_plant_generic =  {
   precache_model2 ( "models/plantgen.mdl");
   CreateEntityNew ( self, ENT_PLANT_GENERIC, "models/plantgen.mdl", chunk_death);
};


void  ()obj_plant_meso =  {
   precache_model2 ( "models/plantmez.mdl");
   CreateEntityNew ( self, ENT_PLANT_MESO, "models/plantmez.mdl", chunk_death);
};


void  ()obj_plant_rome =  {
   precache_model2 ( "models/plantrom.mdl");
   CreateEntityNew ( self, ENT_PLANT_ROME, "models/plantrom.mdl", chunk_death);
};


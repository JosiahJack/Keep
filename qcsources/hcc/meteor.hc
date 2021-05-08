
void  ()MeteoriteFizzle =  {
   CreateWhiteSmoke ( self.origin, '0.00000 0.00000 8.00000', (HX_FRAME_TIME * 2.00000));
   remove ( self);
};


void  ()MeteorThink =  {
   if ( (self.lifetime < time) ) {

      if ( (self.dmg == 3.00000) ) {

         MeteoriteFizzle ( );
      } else {

         MultiExplode ( );

      }

   }
   if ( (self.dmg > 3.00000) ) {

      CreateWhiteSmoke ( self.origin, '0.00000 0.00000 8.00000', (HX_FRAME_TIME * 2.00000));

   }
   self.think = MeteorThink;
   AdvanceThinkTime(self,0.30000);
};


void  ()MeteorTouch =  {
local vector hitdir = '0.00000 0.00000 0.00000';
   if ( (other.controller == self.owner) ) {

      return ;

   }
   if ( (self.dmg == 3.00000) ) {

      if ( (other == world) ) {

         if ( (!self.pain_finished && (random() < 0.30000)) ) {

            sound ( self.controller, CHAN_BODY, "misc/rubble.wav", 1.00000, ATTN_NORM);
            self.pain_finished = TRUE;

         }
         return ;
      } else {

         if ( (other.classname == "meteor") ) {

            return ;

         }

      }

   }
   if ( (other.takedamage && other.health) ) {

      T_Damage ( other, self, self.owner, self.dmg);
      if ( (self.dmg > 3.00000) ) {

         if ( (((other.flags & FL_CLIENT) || (other.flags & FL_MONSTER)) && (other.mass < 200.00000)) ) {

            hitdir = (self.o_angle * 300.00000);
            hitdir_z += 150.00000;
            if ( (hitdir_z < 0.00000) ) {

               hitdir_z = 0.00000;

            }
            other.velocity = hitdir;
            other.flags ^= FL_ONGROUND;

         }
         self.dmg /= 2.00000;

      }
   } else {

      if ( (self.dmg > 3.00000) ) {

         self.dmg = 100.00000;

      }

   }
   if ( (self.dmg > 3.00000) ) {

      MultiExplode ( );
   } else {

      MeteoriteFizzle ( );

   }
};


void  (string type)FireMeteor =  {
local vector org = '0.00000 0.00000 0.00000';
local entity meteor;
   meteor = spawn ( );
   setmodel ( meteor, "models/tempmetr.mdl");
   if ( (type == "minimeteor") ) {

      meteor.classname = "minimeteor";
      meteor.velocity = RandomVector ( '200.00000 200.00000 0.00000');
      meteor.velocity_z = random(200.00000,400.00000);
      meteor.lifetime = (time + 1.50000);
      meteor.dmg = 3.00000;
      meteor.scale = random(0.15000,0.45000);
      meteor.movetype = MOVETYPE_BOUNCE;
      org = self.origin;
      setsize ( meteor, '0.00000 0.00000 0.00000', '0.00000 0.00000 0.00000');
   } else {

      meteor.th_die = MultiExplode;
      if ( (self.classname == "player") ) {

         self.greenmana -= 8.00000;
         self.velocity += (normalize ( v_forward) * -300.00000);
         self.flags ^= FL_ONGROUND;

      }
      meteor.classname = "meteor";
      self.punchangle_x = -6.00000;
      sound ( self, CHAN_AUTO, "crusader/metfire.wav", 1.00000, ATTN_NORM);
      self.attack_finished = (time + 0.70000);
      self.effects |= EF_MUZZLEFLASH;
      makevectors ( self.v_angle);
      meteor.speed = 1000.00000;
      meteor.o_angle = normalize ( v_forward);
      meteor.velocity = (meteor.o_angle * meteor.speed);
      meteor.veer = 30.00000;
      meteor.lifetime = (time + 5.00000);
      meteor.dmg = 75.00000;
      meteor.movetype = MOVETYPE_FLYMISSILE;
      org = ((self.origin + self.proj_ofs) + (v_forward * 12.00000));
      setsize ( meteor, '0.00000 0.00000 0.00000', '0.00000 0.00000 0.00000');

   }
   meteor.drawflags |= MLS_FIREFLICKER;
   meteor.avelocity = RandomVector ( '360.00000 360.00000 360.00000');
   if ( (self.classname == "tornato") ) {

      meteor.owner = self.controller;
   } else {

      if ( (self.classname == "meteor") ) {

         meteor.owner = self.owner;
      } else {

         meteor.owner = self;

      }

   }
   meteor.controller = self;
   meteor.solid = SOLID_BBOX;
   meteor.touch = MeteorTouch;
   meteor.think = MeteorThink;
   AdvanceThinkTime(meteor,0.10000);
   setorigin ( meteor, org);
};


void  ()tornato_die =  {
   AdvanceFrame( 24.00000, 47.00000);
   if ( cycle_wrapped ) {

      if ( self.enemy ) {

         self.enemy.avelocity = '0.00000 500.00000 0.00000';
         if ( (self.enemy.flags2 & FL_ALIVE) ) {

            self.enemy.movetype = self.enemy.oldmovetype;

         }

      }
      if ( (self.movechain != world) ) {

         remove ( self.movechain);

      }
      remove ( self);

   }
   self.movechain.frame += 1.00000;
   if ( (self.movechain.frame > 24.00000) ) {

      self.movechain.frame = 0.00000;

   }
   if ( (self.movechain.scale > 0.04000) ) {

      self.movechain.scale -= 0.04000;

   }
   if ( (self.movechain.avelocity_y > 0.00000) ) {

      self.movechain.avelocity_y -= 20.00000;

   }
};


void  ()tornato_spin =  {
local float distance = 0.00000;
local float content = 0.00000;
local vector org = '0.00000 0.00000 0.00000';
local vector dir = '0.00000 0.00000 0.00000';
local float let_go = 0.00000;
local float seekspeed = 0.00000;
local entity sucker;
local float bestdist = 0.00000;
   AdvanceFrame( 0.00000, 23.00000);
   if ( ((time > self.lifetime) || (self.torncount < (self.owner.torncount - 1.00000))) ) {

      self.movechain.drawflags |= ((MLS_ABSLIGHT | SCALE_ORIGIN_BOTTOM) | SCALE_TYPE_XYONLY);
      self.think = tornato_die;
      AdvanceThinkTime(self,0.00000);

   }
   self.movechain.frame += 1.00000;
   if ( (self.movechain.frame > 24.00000) ) {

      self.movechain.frame = 0.00000;

   }
   if ( (random() < 0.20000) ) {

      self.velocity_x += random((-100.00000 * self.scale),(100.00000 * self.scale));
      if ( (fabs ( self.velocity_x) > 1000.00000) ) {

         self.velocity_x /= 2.00000;

      }

   }
   if ( (random() < 0.20000) ) {

      self.velocity_y += random((-100.00000 * self.scale),(100.00000 * self.scale));
      if ( (fabs ( self.velocity_y) > 1000.00000) ) {

         self.velocity_y /= 2.00000;

      }

   }
   content = pointcontents ( self.origin);
   if ( ((content == CONTENT_WATER) || (content == CONTENT_LAVA)) ) {

      self.velocity_z += random(33.00000,200.00000);
      particle4 ( self.origin, random(), (264.00000 * 15.00000), PARTICLETYPE_GRAV, (random() * 10.00000));
      particle4 ( self.origin, random(10.00000), random(406.00000,414.00000), PARTICLETYPE_GRAV, random(10.00000));
   } else {

      if ( (random() < 0.20000) ) {

         distance = random(-30.00000,15.00000);
         if ( ((self.goalentity != world) && (self.enemy != self.goalentity)) ) {

            if ( (self.goalentity.origin_z > self.origin_z) ) {

               distance = random(-30.00000,30.00000);

            }

         }
         self.velocity_z += distance;
         if ( (fabs ( self.velocity_z) > 333.00000) ) {

            self.velocity_z /= 3.00000;

         }

      }

   }
   if ( (self.enemy != world) ) {

      self.velocity = (self.velocity * 0.50000);
      org = self.origin;
      if ( (self.enemy.size_z >= self.size_z) ) {

         org = self.origin;
      } else {

         org_z += ((random(10.00000) * self.scale) + (4.00000 * self.scale));

      }
      if ( !(self.enemy.flags2 & FL_TORNATO_SAFE) ) {

         self.enemy.velocity = '0.00000 0.00000 0.00000';
         setorigin ( self.enemy, org);
      } else {

         self.enemy.flags2 ^= FL_TORNATO_SAFE;
         let_go = TRUE;

      }
      if ( ((!let_go && (self.enemy != world)) && !(self.enemy.flags2 & FL_ALIVE)) ) {

         if ( ((((random() >= 0.40000) || (self.goalentity == world)) || !visible ( self.goalentity)) || (self.goalentity.health <= 0.00000)) ) {

            self.pain_finished = (time + 1.00000);
         } else {

            self.pain_finished = -1.00000;
            if ( ((self.goalentity.solid == SOLID_BSP) && (self.goalentity.origin == '0.00000 0.00000 0.00000')) ) {

               dir = normalize ( (((self.goalentity.absmax + self.goalentity.absmin) * 0.50000) - self.enemy.origin));
            } else {

               dir = normalize ( (self.goalentity.origin - self.enemy.origin));

            }

         }

      }
      if ( (((!let_go && self.enemy.takedamage) && (self.enemy.health > 0.00000)) && (self.pain_finished > time)) ) {

         if ( (random() < 0.30000) ) {

            T_Damage ( self.enemy, self, self.owner, self.scale);

         }
      } else {

         if ( !let_go ) {

            self.pain_finished = -1.00000;
            if ( -1.00000 ) {

               self.enemy.velocity = ((dir * 350.00000) * self.scale);
            } else {

               self.enemy.velocity_z = random((200.00000 * self.scale));
               self.enemy.velocity_x = random((200.00000 * self.scale),(-200.00000 * self.scale));
               self.enemy.velocity_y = random((200.00000 * self.scale),(-200.00000 * self.scale));

            }

         }
         self.pain_finished = time;
         self.enemy.safe_time = ((time + 3.00000) + (let_go * 7.00000));
         if ( (self.enemy.flags2 & FL_ALIVE) ) {

            self.enemy.movetype = self.enemy.oldmovetype;
            if ( (self.enemy.classname == "player_sheep") ) {

               sound ( self.enemy, CHAN_VOICE, "misc/sheepfly.wav", 1.00000, ATTN_NORM);
               self.enemy.pain_finished = (time + 1.00000);

            }

         }
         if ( !let_go ) {

            self.enemy.avelocity_y = random((200.00000 * self.scale));

         }
         self.movechain.movechain = world;
         self.enemy = world;

      }
      if ( (self.enemy.classname == "player") ) {

         self.enemy.punchangle_y = random(3.00000,12.00000);
         self.enemy.punchangle_x = random(-3.00000,3.00000);
         self.enemy.punchangle_z = random(-3.00000,3.00000);

      }
      if ( ((self.enemy != world) && (self.goalentity == self.enemy)) ) {

         self.goalentity = world;

      }

   }
   if ( (random() < 0.30000) ) {

      if ( (((self.goalentity != world) && visible ( self.goalentity)) && (self.goalentity.health > 0.00000)) ) {

         seekspeed = random(150.00000,333.00000);
         if ( ((self.goalentity.solid == SOLID_BSP) && (self.goalentity.origin == '0.00000 0.00000 0.00000')) ) {

            distance = vlen ( (((self.goalentity.absmax + self.goalentity.absmin) * 0.50000) - self.origin));
         } else {

            distance = vlen ( (self.goalentity.origin - self.origin));

         }
         if ( (distance < 256.00000) ) {

            seekspeed += (256.00000 - distance);

         }
         if ( self.goalentity.velocity ) {

            seekspeed += vlen ( self.goalentity.velocity);

         }
         self.velocity = (((self.velocity * 3.00000) + ((normalize ( (self.goalentity.origin - self.origin)) * seekspeed) * self.scale)) * 0.25000);
      } else {

         self.goalentity = world;
         bestdist = 1001.00000;
         sucker = findradius ( self.origin, 1000.00000);
         while ( sucker ) {

            if ( ((((((sucker.takedamage && sucker.health) && (sucker != self.enemy)) && (sucker.mass < (500.00000 * self.scale))) && visible ( sucker)) && (sucker != self.owner)) && !(sucker.effects & EF_NODRAW)) ) {

               if ( ((sucker.solid == SOLID_BSP) && (sucker.origin == '0.00000 0.00000 0.00000')) ) {

                  distance = vlen ( (((sucker.absmax + sucker.absmin) * 0.50000) - self.origin));
               } else {

                  distance = vlen ( (sucker.origin - self.origin));

               }
               if ( (self.goalentity.velocity == '0.00000 0.00000 0.00000') ) {

                  if ( ((sucker.velocity != '0.00000 0.00000 0.00000') && (sucker.flags2 & FL_ALIVE)) ) {

                     bestdist = distance;
                     self.goalentity = sucker;
                  } else {

                     if ( !(self.goalentity.flags2 & FL_ALIVE) ) {

                        if ( (sucker.flags2 & FL_ALIVE) ) {

                           bestdist = distance;
                           self.goalentity = sucker;
                        } else {

                           if ( (distance < bestdist) ) {

                              bestdist = distance;
                              self.goalentity = sucker;

                           }

                        }
                     } else {

                        if ( ((sucker.flags2 & FL_ALIVE) && (distance < bestdist)) ) {

                           bestdist = distance;
                           self.goalentity = sucker;

                        }

                     }

                  }
               } else {

                  if ( (((distance < bestdist) && (sucker.velocity != '0.00000 0.00000 0.00000')) && (sucker.flags2 & FL_ALIVE)) ) {

                     bestdist = distance;
                     self.goalentity = sucker;

                  }

               }

            }
            sucker = sucker.chain;

         }

      }

   }
   if ( (random() < 0.10000) ) {

      if ( (random() < 0.10000) ) {

         self.proj_ofs_z = random(6.00000,54.00000);
         self.v_angle_x = random(-30.00000,30.00000);
         self.v_angle_y = random(-360.00000,360.00000);
         FireMeteor ( "meteor");
      } else {

         FireMeteor ( "minimeteor");

      }

   }
   if ( (self.flags & FL_ONGROUND) ) {

      self.velocity_z *= -0.33300;
      self.flags ^= FL_ONGROUND;
      dir_z = random(20.00000,70.00000);
      distance = random(10.00000,30.00000);
      SpawnPuff ( self.origin, dir, distance, self);
      CreateWhiteSmoke ( self.origin, '0.00000 0.00000 8.00000', (HX_FRAME_TIME * 2.00000));

   }
   if ( (self.t_width < time) ) {

      sound ( self, CHAN_VOICE, "crusader/tornado.wav", 1.00000, ATTN_NORM);
      self.t_width = (time + 1.00000);

   }
};

void  ()funnal_touch;

void  ()tornato_merge =  {
   self.scale += 0.02500;
   self.owner.scale += 0.02500;
   self.goalentity.scale -= 0.02400;
   self.goalentity.owner.scale -= 0.02400;
   if ( (self.scale >= self.target_scale) ) {

      self.touch = funnal_touch;
      self.owner.scale = self.target_scale;
      self.scale = self.target_scale;
      self.think = SUB_Null;
      self.nextthink = -1.00000;
      remove ( self.goalentity.owner);
      remove ( self.goalentity);
   } else {

      self.think = tornato_merge;
      AdvanceThinkTime(self,0.01000);

   }
};


void  ()funnal_touch =  {
local vector dir = '0.00000 0.00000 0.00000';
   if ( ((other.flags & FL_MONSTER) && (other.monsterclass >= CLASS_BOSS)) ) {

      T_Damage ( other, self, self.owner, 7.00000);
      traceline ( ((self.absmin + self.absmax) * 0.50000), ((other.absmin + other.absmax) * 0.50000), FALSE, self);
      SpawnPuff ( trace_endpos, random('-1.00000 -1.00000 -1.00000','1.00000 1.00000 1.00000'), 5.00000, other);
      return ;

   }
   if ( ((((((((other == self.controller) || (other.controller == self.owner)) || (other == world)) || (other == self.owner)) || (other == self.owner)) || (other.classname == "tornato")) || ((other.classname == "funnal") && other.aflag)) || (other.movetype == MOVETYPE_PUSH)) ) {

      return ;

   }
   if ( self.aflag ) {

      self.owner.think = SUB_Remove;
      self.think = SUB_Remove;
      return ;

   }
   if ( ((((other.classname == "funnal") && (other.scale >= 1.00000)) && (self.scale >= 1.00000)) && ((other.scale + self.scale) < 2.50000)) ) {

      tracearea ( self.origin, self.origin, (self.mins + other.mins), (self.maxs + other.maxs), TRUE, self);
      if ( (trace_fraction < 1.00000) ) {

         return ;

      }
      self.goalentity = other;
      other.touch = SUB_Null;
      self.touch = SUB_Null;
      if ( (other.controller != self.controller) ) {

         self.controller = self.owner;
         self.owner.controller = self.owner;
         self.owner.owner = self.owner;

      }
      self.drawflags = (MLS_ABSLIGHT | SCALE_ORIGIN_BOTTOM);
      self.owner.drawflags = SCALE_ORIGIN_BOTTOM;
      other.drawflags = ((MLS_ABSLIGHT + SCALE_ORIGIN_BOTTOM) + SCALE_TYPE_XYONLY);
      self.target_scale = (self.scale + other.scale);
      if ( (self.target_scale > 2.50000) ) {

         self.target_scale = 2.50000;

      }
      setsize ( self, (self.mins + other.mins), (self.maxs + other.maxs));
      setsize ( self.owner, (self.owner.mins + other.owner.mins), (self.owner.maxs + other.owner.maxs));
      tornato_merge ( );
   } else {

      if ( ((((other != self.movechain) && other.movetype) && (other.mass < (500.00000 * self.scale))) && (other.classname != "funnal")) ) {

         if ( ((other.health && other.takedamage) && (other.solid != SOLID_BSP)) ) {

            if ( !other.touch ) {

               other.touch = obj_push;

            }
            if ( ((self.movechain == world) && (other.safe_time < time)) ) {

               self.movechain = other;
               other.flags |= FL_MOVECHAIN_ANGLE;
               setorigin ( other, (self.origin + '0.00000 0.00000 4.00000'));
               other.velocity = '0.00000 0.00000 0.00000';
               if ( (other.flags2 & FL_ALIVE) ) {

                  other.avelocity = '0.00000 0.00000 0.00000';
               } else {

                  other.avelocity_x = random(360.00000);
                  other.avelocity_z = random(360.00000);

               }
               other.oldmovetype = other.movetype;
               other.movetype = MOVETYPE_NONE;
               self.owner.enemy = other;
               self.owner.pain_finished = (time + random(3.00000,10.00000));
               if ( ((other.classname == "player_sheep") && (other.flags2 & FL_ALIVE)) ) {

                  sound ( other, CHAN_VOICE, "misc/sheepfly.wav", 1.00000, ATTN_NORM);
                  other.pain_finished = (time + 1.00000);

               }
               return ;

            }

         }
         dir = normalize ( self.angles);
         dir_x *= (random(200.00000,700.00000) * self.scale);
         other.velocity += dir;
         other.velocity_z = (random(100.00000,250.00000) * self.scale);
         other.flags ^= FL_ONGROUND;
         if ( other.takedamage ) {

            T_Damage ( other, self.owner, self.owner.controller, (5.00000 * self.scale));

         }
         if ( ((other.classname == "player_sheep") && (other.flags2 & FL_ALIVE)) ) {

            sound ( other, CHAN_VOICE, "misc/sheepfly.wav", 1.00000, ATTN_NORM);
            other.pain_finished = (time + 1.00000);

         }

      }

   }
};


void  ()tornato_grow =  {
   AdvanceFrame( 48.00000, 72.00000);
   if ( cycle_wrapped ) {

      self.movechain.scale = 1.00000;
      self.think = tornato_spin;
      AdvanceThinkTime(self,0.00000);

   }
   self.movechain.frame += 1.00000;
   if ( (self.movechain.frame > 24.00000) ) {

      self.movechain.frame = 0.00000;

   }
   self.movechain.scale += 0.04000;
};


void  ()FireMeteorTornado =  {
local entity tornato;
local entity funnal;
local vector org = '0.00000 0.00000 0.00000';
   self.greenmana -= 20.00000;
   sound ( self, CHAN_WEAPON, "crusader/torngo.wav", 1.00000, ATTN_NORM);
   makevectors ( self.v_angle);
   org = (self.origin + (normalize ( v_forward) * 16.00000));
   org_z = (self.origin_z + 1.00000);
   tornato = spawn ( );
   self.torncount += 1.00000;
   tornato.torncount = self.torncount;
   tornato.solid = SOLID_NOT;
   tornato.movetype = MOVETYPE_FLY;
   tornato.controller = self;
   tornato.owner = self;
   tornato.classname = "tornato";
   tornato.enemy = world;
   setmodel ( tornato, "models/tornato.mdl");
   setsize ( tornato, '-18.00000 -18.00000 -3.00000', '18.00000 18.00000 64.00000');
   tornato.hull = HULL_PLAYER;
   setorigin ( tornato, org);
   tornato.velocity = ((normalize ( v_forward) * 250.00000) + '0.00000 0.00000 20.00000');
   tornato.velocity_z = 0.00000;
   tornato.scale = 1.00000;
   if ( (visible ( self.enemy) && (self.enemy.flags2 & FL_ALIVE)) ) {

      tornato.goalentity = self.enemy;

   }
   tornato.lifetime = (time + 20.00000);
   tornato.think = tornato_grow;
   AdvanceThinkTime(tornato,0.00000);
   funnal = spawn ( );
   funnal.owner = tornato;
   funnal.solid = SOLID_TRIGGER;
   funnal.classname = "funnal";
   funnal.movetype = MOVETYPE_FLYMISSILE;
   funnal.drawflags |= ((MLS_ABSLIGHT | SCALE_ORIGIN_BOTTOM) | SCALE_TYPE_ZONLY);
   funnal.abslight = 0.20000;
   funnal.scale = 0.01000;
   tornato.movechain = funnal;
   funnal.avelocity = '0.00000 100.00000 0.00000';
   funnal.controller = self;
   funnal.touch = funnal_touch;
   funnal.lifetime = (time + 1.70000);
   setmodel ( funnal, "models/funnal.mdl");
   setsize ( funnal, '-18.00000 -18.00000 -3.00000', '18.00000 18.00000 64.00000');
   funnal.hull = HULL_PLAYER;
   setorigin ( funnal, org);
};

void  ()meteor_ready_loop;
void  ()Cru_Met_Attack;

void  ()meteor_power_fire =  {
   self.wfs = advanceweaponframe ( 19.00000, 27.00000);
   self.th_weapon = meteor_power_fire;
   if ( ((self.weaponframe == 20.00000) && (self.attack_finished <= time)) ) {

      FireMeteorTornado ( );

   }
   if ( (self.wfs == WF_CYCLE_WRAPPED) ) {

      self.last_attack = time;
      meteor_ready_loop ( );

   }
};


void  ()meteor_fire =  {
   self.wfs = advanceweaponframe ( 19.00000, 27.00000);
   self.th_weapon = meteor_fire;
   if ( ((!self.button0 || (self.attack_finished > time)) && (self.wfs == WF_CYCLE_WRAPPED)) ) {

      self.last_attack = time;
      meteor_ready_loop ( );
   } else {

      if ( ((self.weaponframe == 19.00000) && (self.attack_finished <= time)) ) {

         FireMeteor ( "meteor");

      }

   }
};


void  ()Cru_Met_Attack =  {
   if ( (self.artifact_active & ART_TOMEOFPOWER) ) {

      self.th_weapon = meteor_power_fire;
   } else {

      self.th_weapon = meteor_fire;

   }
   AdvanceThinkTime(self,0.00000);
};


void  ()meteor_ready_loop =  {
   self.weaponframe = 0.00000;
   self.th_weapon = meteor_ready_loop;
};


void  ()meteor_select =  {
   self.wfs = advanceweaponframe ( 1.00000, 16.00000);
   self.weaponmodel = "models/meteor.mdl";
   self.th_weapon = meteor_select;
   self.last_attack = time;
   if ( (self.wfs == WF_CYCLE_WRAPPED) ) {

      self.attack_finished = (time - 1.00000);
      meteor_ready_loop ( );

   }
};


void  ()meteor_deselect =  {
   self.wfs = advanceweaponframe ( 16.00000, 1.00000);
   self.th_weapon = meteor_deselect;
   if ( (self.wfs == WF_CYCLE_WRAPPED) ) {

      W_SetCurrentAmmo ( );

   }
};


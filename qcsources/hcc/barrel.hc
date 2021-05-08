void  ()barrel_check_float;

void  ()float =  {
local float x_mod = 0.00000;
local float y_mod = 0.00000;
local float z_mod = 0.00000;
local vector org = '0.00000 0.00000 0.00000';
   org = self.origin;
   if ( (((pointcontents ( org) == CONTENT_WATER) || (pointcontents ( org) == CONTENT_SLIME)) || (pointcontents ( org) == CONTENT_LAVA)) ) {

      if ( self.velocity_x ) {

         self.velocity_x /= 1.10000;

      }
      if ( self.velocity_y ) {

         self.velocity_y /= 1.10000;

      }
      org_z += (self.maxs_z * 0.77000);
      if ( (((pointcontents ( org) == CONTENT_WATER) || (pointcontents ( org) == CONTENT_SLIME)) || (pointcontents ( org) == CONTENT_LAVA)) ) {

         self.flags ^= FL_ONGROUND;
         if ( (self.velocity_z < 77.00000) ) {

            self.velocity_z = 80.00000;
         } else {

            self.velocity_z += random(0.00000,0.01000);

         }
      } else {

         self.velocity_z -= random(0.00000,0.01000);

      }
      if ( (random() < 0.30000) ) {

         y_mod = random(-0.15000,0.15000);
         if ( (random() < 0.50000) ) {

            self.angles_y += y_mod;
         } else {

            self.angles_y += y_mod;

         }

      }
      if ( (random() < 0.30000) ) {

         x_mod = random(-0.15000,0.15000);
         if ( (fabs ( (self.angles_x + x_mod)) > 10.00000) ) {

            self.angles_x -= x_mod;
         } else {

            self.angles_x += x_mod;

         }

      }
      if ( (random() < 0.30000) ) {

         z_mod = random(-0.15000,0.15000);
         if ( (fabs ( (self.angles_z + z_mod)) > 10.00000) ) {

            self.angles_z -= z_mod;
         } else {

            self.angles_z += z_mod;

         }

      }
      AdvanceThinkTime(self,0.10000);
   } else {

      self.angles_z = 0.00000;
      self.angles_z = 0.00000;
      self.classname = "barrel";
      self.think = barrel_check_float;
      AdvanceThinkTime(self,0.50000);

   }
};


void  ()barrel_check_float =  {
local vector org = '0.00000 0.00000 0.00000';
   org = self.origin;
   if ( ((((pointcontents ( org) == CONTENT_WATER) || (pointcontents ( org) == CONTENT_SLIME)) || (pointcontents ( org) == CONTENT_LAVA)) && !(self.spawnflags & BARREL_SINK)) ) {

      self.think = float;
      AdvanceThinkTime(self,0.00000);
   } else {

      self.classname = "barrel";
      self.think = barrel_check_float;
      AdvanceThinkTime(self,0.50000);

   }
};


void  ()obj_barrel_explode =  {
local entity attacker;
   self.th_die = SUB_Null;
   self.takedamage = DAMAGE_NO;
   if ( (self.enemy.flags2 & FL_ALIVE) ) {

      attacker = self.enemy;
   } else {

      attacker = self;

   }
   T_RadiusDamage ( self, attacker, 100.00000, self);
   sound ( self, CHAN_VOICE, "weapons/explode.wav", 1.00000, ATTN_NORM);
   particleexplosion ( (self.origin + '0.00000 0.00000 83.00000'), 384.00000, 60.00000, 40.00000);
   starteffect ( CE_LG_EXPLOSION, ((self.absmin + self.absmax) * 0.50000));
   chunk_death ( );
};

void  ()monster_rat;

void  (float offset)rat_spawn =  {
   newmis = spawn ( );
   newmis.angles_y = (self.angles_y + (offset * 60.00000));
   newmis.flags2 |= FL_SUMMONED;
   if ( self.target ) {

      newmis.target = self.target;

   }
   makevectors ( newmis.angles);
   setorigin ( newmis, (self.origin + (v_forward * 16.00000)));
   newmis.think = monster_rat;
   AdvanceThinkTime(newmis,0.00000);
};


void  ()barrel_die =  {
local float r = 0.00000;
   self.solid = SOLID_NOT;
   if ( (((random() < 0.30000) || (self.target != "")) || (self.classname == "monster_ratnest")) ) {

      r = rint ( random(3.00000,6.00000));
      while ( (r > 0.00000) ) {

         rat_spawn ( r);
         r -= 1.00000;

      }

   }
   if ( (self.classname != "monster_ratnest") ) {

      chunk_death ( );
   } else {

      remove ( self);

   }
};


void  ()obj_barrel_roll =  {
local vector dircheck = '0.00000 0.00000 0.00000';
   self.v_angle_y = self.angles_y;
   self.v_angle_z = 0.00000;
   self.v_angle_x = 0.00000;
   makevectors ( self.v_angle);
   self.velocity -= (self.movedir * self.speed);
   self.movedir = normalize ( v_forward);
   self.speed /= 1.01000;
   self.anglespeed = (self.speed / 7.70000);
   if ( ((self.speed < 1.00000) && (self.speed > -1.00000)) ) {

      self.velocity = '0.00000 0.00000 0.00000';
      self.think = SUB_Null;
      self.nextthink = -1.00000;
   } else {

      if ( (self.flags & FL_ONGROUND) ) {

         self.flags ^= FL_ONGROUND;
         self.last_onground = time;
         self.level = TRUE;
      } else {

         if ( self.level ) {

            self.level = FALSE;
            self.last_onground = (time - 1.00000);
            self.speed /= 2.00000;

         }

      }
      self.velocity += (self.movedir * self.speed);
      self.angles_x -= self.anglespeed;
      self.think = obj_barrel_roll;
      AdvanceThinkTime(self,0.05000);
      dircheck = normalize ( self.velocity);
      makevectors ( self.angles);
      traceline ( self.origin, (self.origin + (dircheck * 39.00000)), FALSE, self);
      if ( (trace_fraction == 1.00000) ) {

         traceline ( (self.origin + (v_right * 16.00000)), ((self.origin + (v_right * 16.00000)) + (dircheck * 39.00000)), FALSE, self);
         if ( (trace_fraction == 1.00000) ) {

            traceline ( (self.origin - (v_right * 16.00000)), ((self.origin - (v_right * 16.00000)) + (dircheck * 39.00000)), FALSE, self);

         }

      }
      if ( (trace_fraction < 1.00000) ) {

         sound ( self, CHAN_AUTO, "fx/thngland.wav", 1.00000, ATTN_NORM);
         self.speed *= -0.25000;
         self.last_onground = (time - 1.00000);
         obj_fly_hurt ( trace_ent);
         self.velocity = (dircheck * self.speed);

      }

   }
};


void  ()obj_barrel_shoot =  {
   sound ( self, CHAN_AUTO, "fx/thngland.wav", 1.00000, ATTN_NORM);
};


void  ()obj_barrel_use =  {
   obj_barrel_explode ( );
};


void  (float barrel_type)spawn_barrel =  {
   precache_model ( "models/barrel.mdl");
   if ( (barrel_type == BARREL_NORMAL) ) {

      precache_model ( "models/rat.mdl");

   }
   CreateEntityNew ( self, ENT_BARREL, "models/barrel.mdl", chunk_death);
   if ( (self.spawnflags & ON_SIDE) ) {

      self.aflag = 1.00000;
      self.frame = 1.00000;
      self.v_angle = self.angles;
      setsize ( self, '-18.00000 -13.00000 -13.00000', '18.00000 13.00000 13.00000');
      self.hull = HULL_CROUCH;
   } else {

      setsize ( self, '-13.00000 -13.00000 0.00000', '13.00000 13.00000 36.00000');

   }
   if ( self.scale ) {

      self.mass *= self.scale;

   }
   self.classname = "barrel";
   self.flags |= FL_PUSH;
   self.touch = obj_push;
   self.th_pain = obj_barrel_shoot;
   if ( (barrel_type == BARREL_NORMAL) ) {

      self.th_die = barrel_die;
      self.skin = 0.00000;
   } else {

      if ( (barrel_type == BARREL_INDESTRUCTIBLE) ) {

         self.health = 999999.00000;
         self.th_die = SUB_Null;
         self.skin = 1.00000;
      } else {

         if ( (barrel_type == BARREL_EXPLODING) ) {

            self.th_die = obj_barrel_explode;
            self.skin = 2.00000;

         }

      }

   }
   if ( !(self.spawnflags & BARREL_SINK) ) {

      self.think = barrel_check_float;
      AdvanceThinkTime(self,0.00000);

   }
   if ( ((pointcontents ( self.origin) != CONTENT_EMPTY) && !(self.spawnflags & BARREL_SINK)) ) {

      self.classname = "barrel_floating";
      self.think = float;
      AdvanceThinkTime(self,0.00000);
   } else {

      if ( (!(self.flags2 & FL_SUMMONED) && !(self.spawnflags & BARREL_NO_DROP)) ) {

         droptofloor ( );

      }

   }
   if ( self.targetname ) {

      self.use = self.th_die;

   }
};


void  ()obj_barrel =  {
   precache_sound ( "misc/squeak.wav");
   spawn_barrel ( BARREL_NORMAL);
   self.mass = 75.00000;
};


void  ()obj_barrel_indestructible =  {
   spawn_barrel ( BARREL_INDESTRUCTIBLE);
   self.mass = 95.00000;
};


void  ()obj_barrel_exploding =  {
   spawn_barrel ( BARREL_EXPLODING);
   self.mass = 85.00000;
};


float SPAWNFLAG_BUTTON_ACTIVATE   =  1.00000;
float FIRE_MULTIPLE   =  4.00000;
void  ()button_return;
void  ()pressure_use;
void  ()pressure_touch;

void  ()button_wait =  {
   self.state = STATE_TOP;
   if ( (self.wait == -1.00000) ) {

      if ( !self.inactive ) {

         self.nextthink = -1.00000;
      } else {

         self.nextthink = (self.ltime + 0.30000);

      }
   } else {

      self.nextthink = (self.ltime + self.wait);

   }
   self.think = button_return;
   activator = self.enemy;
   if ( !self.inactive ) {

      SUB_UseTargets ( );

   }
   self.frame = 1.00000;
};


void  ()button_done =  {
   self.state = STATE_BOTTOM;
};


void  ()button_return =  {
   self.state = STATE_DOWN;
   SUB_CalcMove ( self.pos1, self.speed, button_done);
   self.frame = 0.00000;
   if ( self.health ) {

      self.takedamage = DAMAGE_NO_GRENADE;

   }
};


void  ()button_blocked =  {
};


void  ()button_fire =  {
local string s;
   if ( self.inactive ) {

      if ( ((other.classname == "player") && self.msg2) ) {

         s = getstring ( self.msg2);
         centerprint ( other, s);

      }
      return ;

   }
   if ( (self.state == STATE_UP) ) {

      return ;

   }
   self.check_ok = TRUE;
   sound ( self, CHAN_VOICE, self.noise, 1.00000, ATTN_NORM);
   self.state = STATE_UP;
   SUB_CalcMove ( self.pos2, self.speed, button_wait);
};


void  ()button_use =  {
   self.enemy = activator;
   button_fire ( );
};


void  ()button_touch =  {
   if ( (!(other.flags & FL_PUSH) && (other.classname != "player")) ) {

      return ;

   }
   if ( (self.state == STATE_TOP) ) {

      return ;

   }
   self.enemy = other;
   button_fire ( );
};


void  ()button_killed =  {
   self.enemy = damage_attacker;
   self.health = self.max_health;
   self.takedamage = DAMAGE_NO;
   button_fire ( );
};


void  ()func_button =  {
   if ( (self.soundtype == 0.00000) ) {

      precache_sound ( "buttons/button1.wav");
      self.noise = "buttons/button1.wav";

   }
   if ( (self.soundtype == 1.00000) ) {

      precache_sound ( "buttons/button2.wav");
      self.noise = "buttons/button2.wav";

   }
   if ( (self.soundtype == 2.00000) ) {

      precache_sound ( "buttons/button3.wav");
      self.noise = "buttons/button3.wav";

   }
   if ( (self.soundtype == 3.00000) ) {

      precache_sound ( "buttons/button4.wav");
      self.noise = "buttons/button4.wav";

   }
   SetMovedir ( );
   if ( self.abslight ) {

      self.drawflags |= MLS_ABSLIGHT;

   }
   self.classname = "button";
   self.movetype = MOVETYPE_PUSH;
   self.solid = SOLID_BSP;
   setmodel ( self, self.model);
   self.blocked = button_blocked;
   self.use = button_use;
   if ( self.health ) {

      self.max_health = self.health;
      if ( (self.spawnflags & FIRE_MULTIPLE) ) {

         self.th_pain = button_use;

      }
      self.th_die = button_killed;
      self.takedamage = DAMAGE_NO_GRENADE;

   }
   if ( !(self.spawnflags & 2.00000) ) {

      if ( !self.health ) {

         self.health = 10.00000;

      }
      self.touch = button_touch;

   }
   if ( !self.speed ) {

      self.speed = 40.00000;

   }
   if ( !self.wait ) {

      self.wait = 1.00000;

   }
   if ( !self.lip ) {

      self.lip = 4.00000;

   }
   if ( (self.spawnflags & SPAWNFLAG_BUTTON_ACTIVATE) ) {

      self.inactive = TRUE;
   } else {

      self.inactive = FALSE;

   }
   self.state = STATE_BOTTOM;
   self.pos1 = self.origin;
   self.pos2 = (self.pos1 + (self.movedir * (fabs ( (self.movedir * self.size)) - self.lip)));
   self.ltime = time;
};


float  ()pressure_weight_check =  {
local vector org = '0.00000 0.00000 0.00000';
local float len = 0.00000;
local float totalmass = 0.00000;
local entity head;
   org = ((self.absmax + self.absmin) * 0.50000);
   len = (vlen ( (self.absmax - self.absmin)) * 0.66000);
   head = findradius ( org, len);
   while ( head ) {

      if ( (head != self) ) {

         if ( (head.flags2 & FL_ALIVE) ) {

            totalmass += (head.mass * 10.00000);
         } else {

            totalmass += head.mass;

         }

      }
      head = head.chain;

   }
   if ( (totalmass >= self.mass) ) {

      return ( TRUE );
   } else {

      return ( FALSE );

   }
};


float  ()pressure_bounds_check =  {
local vector org1 = '0.00000 0.00000 0.00000';
local vector org2 = '0.00000 0.00000 0.00000';
local vector org3 = '0.00000 0.00000 0.00000';
local vector org4 = '0.00000 0.00000 0.00000';
local vector center = '0.00000 0.00000 0.00000';
local vector found_bottom = '0.00000 0.00000 0.00000';
local float radius = 0.00000;
local entity found;
   org4_z = (self.absmax_z + 3.00000);
   org3_z = (self.absmax_z + 3.00000);
   org2_z = (self.absmax_z + 3.00000);
   org1_z = (self.absmax_z + 3.00000);
   org1_x = self.absmin_x;
   org1_y = self.absmin_y;
   org2_x = self.absmin_x;
   org2_y = self.absmax_y;
   org3_x = self.absmax_x;
   org3_y = self.absmin_y;
   org4_x = self.absmax_x;
   org4_y = self.absmax_y;
   center = ((self.absmax + self.absmin) * 0.50000);
   center_z = self.absmax_z;
   radius = fabs ( (self.absmax_x - center_x));
   found = findradius ( center, radius);
   while ( found ) {

      found_bottom = ((found.absmin + found.absmax) * 0.50000);
      found_bottom_z = found.absmin_z;
      if ( (found != self) ) {

         if ( ((found_bottom_x > self.absmin_x) && (found_bottom_x < self.absmax_x)) ) {

            if ( ((found_bottom_y > self.absmin_y) && (found_bottom_y < self.absmax_y)) ) {

               if ( ((found_bottom_z >= (self.absmax_z - 3.00000)) && (found_bottom_z <= (self.absmax_z + 7.00000))) ) {

                  return ( TRUE );
               } else {

                  dprint ( "Not right height\n");

               }
            } else {

               dprint ( "Not right y\n");

            }
         } else {

            dprint ( "Not right x\n");

         }

      }
      found = found.chain;

   }
   return ( FALSE );
};


void  ()pressure_wait =  {
local float tripped = 0.00000;
   tripped = TRUE;
   if ( !pressure_bounds_check ( ) ) {

      tripped = FALSE;

   }
   if ( !pressure_weight_check ( ) ) {

      tripped = FALSE;

   }
   if ( tripped ) {

      self.check_ok = TRUE;
      self.nextthink = (self.ltime + 0.05000);
   } else {

      self.check_ok = FALSE;
      pressure_use ( );
      self.touch = pressure_touch;
      SUB_CalcMove ( self.pos1, self.speed, SUB_Null);

   }
};


void  ()pressure_fire =  {
   sound ( self, CHAN_VOICE, self.noise, 1.00000, ATTN_NORM);
   self.state = STATE_UP;
   self.touch = SUB_Null;
   SUB_UseTargets ( );
   SUB_CalcMove ( self.pos2, self.speed, pressure_wait);
};


void  ()pressure_use =  {
   self.enemy = activator;
   pressure_fire ( );
};


void  ()pressure_touch =  {
local entity found;
local float inbounds = 0.00000;
local float enough_weight = 0.00000;
   if ( (other == world) ) {

      return ;

   }
   if ( pressure_bounds_check ( ) ) {

      inbounds = TRUE;

   }
   if ( pressure_weight_check ( ) ) {

      enough_weight = TRUE;

   }
   if ( inbounds ) {

      if ( enough_weight ) {

         self.check_ok = TRUE;
         self.touch = SUB_Null;
         pressure_use ( );
      } else {

         if ( ((self.pain_finished < time) && (other != self.goalentity)) ) {

            if ( (other.classname == "player") ) {

               centerprint ( other, "Looks like it needs more weight...\n");
               self.pain_finished = (time + 1.00000);
            } else {

               found = findradius ( other.origin, 128.00000);
               while ( found ) {

                  if ( (found.classname == "player") ) {

                     centerprint ( found, "Looks like it needs more weight...\n");
                     self.pain_finished = (time + 1.00000);
                     found = world;
                  } else {

                     found = found.chain;

                  }

               }

            }

         }

      }

   }
   self.goalentity = other;
};


void  ()pressure_blocked =  {
local float tripped = 0.00000;
   tripped = TRUE;
   if ( !pressure_bounds_check ( ) ) {

      tripped = FALSE;

   }
   if ( !pressure_weight_check ( ) ) {

      tripped = FALSE;

   }
   if ( tripped ) {

      self.check_ok = TRUE;
      self.touch = SUB_Null;
      pressure_use ( );
      return ;

   }
};


void  ()func_pressure =  {
   if ( (self.soundtype == 0.00000) ) {

      precache_sound ( "buttons/airbut1.wav");
      self.noise = "buttons/airbut1.wav";

   }
   if ( (self.soundtype == 1.00000) ) {

      precache_sound ( "buttons/switch21.wav");
      self.noise = "buttons/switch21.wav";

   }
   if ( (self.soundtype == 2.00000) ) {

      precache_sound ( "buttons/switch02.wav");
      self.noise = "buttons/switch02.wav";

   }
   if ( (self.soundtype == 3.00000) ) {

      precache_sound ( "buttons/switch04.wav");
      self.noise = "buttons/switch04.wav";

   }
   SetMovedir ( );
   self.movetype = MOVETYPE_PUSH;
   self.solid = SOLID_BSP;
   setmodel ( self, self.model);
   self.blocked = pressure_blocked;
   self.use = pressure_use;
   self.touch = pressure_touch;
   self.ltime = time;
   if ( self.health ) {

      self.max_health = self.health;
      self.th_die = button_killed;
      self.takedamage = DAMAGE_NO_GRENADE;
   } else {

      self.touch = pressure_touch;

   }
   if ( !self.speed ) {

      self.speed = 40.00000;

   }
   if ( !self.wait ) {

      self.wait = 1.00000;

   }
   if ( !self.lip ) {

      self.lip = 4.00000;

   }
   if ( (self.spawnflags & SPAWNFLAG_BUTTON_ACTIVATE) ) {

      self.inactive = TRUE;

   }
   self.state = STATE_BOTTOM;
   self.pos1 = self.origin;
   self.pos2 = (self.pos1 + (self.movedir * (fabs ( (self.movedir * self.size)) - self.lip)));
};


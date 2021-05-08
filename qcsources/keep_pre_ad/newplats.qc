float DN_N_WAIT    = 1.000;
float PLT_TOGGLE    = 2.000;
float ELEVATOR    = 4.000;
float START_AT_TOP    = 8.000;
float PLAT2    = 16.000;
float PLAT2_BOTTOM    = 32.000;

void () dn_and_wait_go_up;

void () dn_and_wait_go_down;

void () dn_and_wait_crush;

void () dn_and_wait_hit_top = {

   sound (self,CHAN_VOICE,self.noise1,TRUE,ATTN_NORM);
   self.state = STATE_TOP;

};

void () dn_and_wait_hit_bottom = {

   sound (self,CHAN_VOICE,self.noise1,TRUE,ATTN_NORM);
   self.state = STATE_BOTTOM;
   self.think = dn_and_wait_go_up;
   self.nextthink = (self.ltime + self.health);

};

void () dn_and_wait_go_down = {

   sound (self,CHAN_VOICE,self.noise,TRUE,ATTN_NORM);
   self.state = STATE_DOWN;
   SUB_CalcMove (self.pos2,self.speed,dn_and_wait_hit_bottom);

};

void () dn_and_wait_go_up = {

   sound (self,CHAN_VOICE,self.noise,TRUE,ATTN_NORM);
   self.state = STATE_UP;
   SUB_CalcMove (self.pos1,self.speed,dn_and_wait_hit_top);

};

void () dn_and_wait_crush = {

   T_Damage (other,self,self,TRUE);
   if ( (self.state == STATE_UP) ) {

      dn_and_wait_go_down ();

   } else {

      if ( (self.state == STATE_DOWN) ) {

         dn_and_wait_go_up ();

      } else {

         objerror ("plat_new_crush: bad self.state\n");

      }

   }

};

void () dn_and_wait_use = {

   if ( (self.state != STATE_TOP) ) {

      return ;

   }
   dn_and_wait_go_down ();

};

void () toggle_go_up;

void () toggle_go_down;

void () toggle_crush;

void () toggle_hit_top = {

   sound (self,CHAN_VOICE,self.noise1,TRUE,ATTN_NORM);
   self.state = STATE_TOP;

};

void () toggle_hit_bottom = {

   sound (self,CHAN_VOICE,self.noise1,TRUE,ATTN_NORM);
   self.state = STATE_BOTTOM;

};

void () toggle_go_down = {

   sound (self,CHAN_VOICE,self.noise,TRUE,ATTN_NORM);
   self.state = STATE_DOWN;
   SUB_CalcMove (self.pos2,self.speed,toggle_hit_bottom);

};

void () toggle_go_up = {

   sound (self,CHAN_VOICE,self.noise,TRUE,ATTN_NORM);
   self.state = STATE_UP;
   SUB_CalcMove (self.pos1,self.speed,toggle_hit_top);

};

void () toggle_crush = {

   T_Damage (other,self,self,TRUE);
   if ( (self.state == STATE_UP) ) {

      toggle_go_down ();

   } else {

      if ( (self.state == STATE_DOWN) ) {

         toggle_go_up ();

      } else {

         objerror ("plat_new_crush: bad self.state\n");

      }

   }

};

void () toggle_use = {

   if ( (self.state == STATE_TOP) ) {

      toggle_go_down ();

   } else {

      if ( (self.state == STATE_BOTTOM) ) {

         toggle_go_up ();

      }

   }

};

void () elvtr_crush;

void () elvtr_stop = {

   self.elevatorOnFloor = self.elevatorToFloor;
   sound (self,CHAN_VOICE,self.noise1,TRUE,ATTN_NORM);
   self.state = STATE_BOTTOM;
   self.elevatorLastUse = time;

};

void () elvtr_go = {

   self.elevatorDestination = self.pos2;
   self.elevatorDestination_z = (self.pos2_z + (self.height * self.elevatorToFloor));
   sound (self,CHAN_VOICE,self.noise,TRUE,ATTN_NORM);
   self.state = STATE_UP;
   SUB_CalcMove (self.elevatorDestination,self.speed,elvtr_stop);
   self.elevatorLastUse = time;

};

void () elvtr_crush = {

   self.elevatorToFloor = self.elevatorOnFloor;
   elvtr_go ();

};

void () elvtr_use = {

   local float tempDist;
   local float elvPos;
   local float btnPos;

   if ( ((self.elevatorLastUse + FL_SWIM) > time) ) {

      return ;

   }
   self.elevatorLastUse = time;
   if ( (elv_button_dir == FALSE) ) {

      return ;

   }
   elvPos = ((self.absmin_z + self.absmax_z) * 0.500);
   btnPos = ((other.absmin_z + other.absmax_z) * 0.500);
   if ( (elvPos > btnPos) ) {

      tempDist = ((elvPos - btnPos) / self.height);
      tempDist = ceil (tempDist);
      self.elevatorToFloor = (self.elevatorOnFloor - tempDist);
      elvtr_go ();
      return ;

   } else {

      tempDist = (btnPos - elvPos);
      if ( (tempDist > self.height) ) {

         tempDist = (tempDist / self.height);
         tempDist = floor (tempDist);
         self.elevatorToFloor = (self.elevatorOnFloor + tempDist);
         elvtr_go ();
         return ;

      }

   }
   if ( (elv_button_dir == CONTENT_EMPTY) ) {

      if ( (self.elevatorOnFloor > FALSE) ) {

         self.elevatorToFloor = (self.elevatorOnFloor - TRUE);
         elvtr_go ();

      }

   } else {

      if ( (elv_button_dir == TRUE) ) {

         if ( (self.elevatorOnFloor < (self.cnt - TRUE)) ) {

            self.elevatorToFloor = (self.elevatorOnFloor + TRUE);
            elvtr_go ();

         }

      }

   }

};

void () plat2_center_touch;

void () plat2_go_up;

void () plat2_go_down;

void () plat2_crush;

void () plat2_spawn_inside_trigger = {

   local entity trigger;
   local vector tmin;
   local vector tmax;

   trigger = spawn ();
   trigger.touch = plat2_center_touch;
   trigger.movetype = MOVETYPE_NONE;
   trigger.solid = SOLID_TRIGGER;
   trigger.enemy = self;
   tmin = (self.mins + '25.000 25.000 0.000');
   tmax = (self.maxs - '25.000 25.000 -8.000');
   tmin_z = (tmax_z - ((self.pos1_z - self.pos2_z) + FL_CLIENT));
   if ( (self.spawnflags & PLAT_LOW_TRIGGER) ) {

      tmax_z = (tmin_z + FL_CLIENT);

   }
   if ( (self.size_x <= 50.000) ) {

      tmin_x = ((self.mins_x + self.maxs_x) / FL_SWIM);
      tmax_x = (tmin_x + TRUE);

   }
   if ( (self.size_y <= 50.000) ) {

      tmin_y = ((self.mins_y + self.maxs_y) / FL_SWIM);
      tmax_y = (tmin_y + TRUE);

   }
   setsize (trigger,tmin,tmax);

};

void () plat2_hit_top = {

   sound (self,CHAN_VOICE,self.noise1,TRUE,ATTN_NORM);
   self.state = STATE_TOP;
   self.plat2LastMove = time;
   if ( (self.plat2Called == TRUE) ) {

      self.think = plat2_go_down;
      self.nextthink = (self.ltime + 1.500);
      self.plat2Called = FALSE;
      self.plat2LastMove = FALSE;

   } else {

      if ( !(self.spawnflags & START_AT_TOP) ) {

         self.think = plat2_go_down;
         self.nextthink = (self.ltime + self.delay);
         self.plat2Called = FALSE;

      }

   }

};

void () plat2_hit_bottom = {

   sound (self,CHAN_VOICE,self.noise1,TRUE,ATTN_NORM);
   self.state = STATE_BOTTOM;
   self.plat2LastMove = time;
   if ( (self.plat2Called == TRUE) ) {

      self.think = plat2_go_up;
      self.nextthink = (self.ltime + 1.500);
      self.plat2Called = FALSE;
      self.plat2LastMove = FALSE;

   } else {

      if ( (self.spawnflags & START_AT_TOP) ) {

         self.think = plat2_go_up;
         self.nextthink = (self.ltime + self.delay);
         self.plat2Called = FALSE;

      }

   }

};

void () plat2_go_down = {

   sound (self,CHAN_VOICE,self.noise,TRUE,ATTN_NORM);
   self.state = STATE_DOWN;
   SUB_CalcMove (self.pos2,self.speed,plat2_hit_bottom);

};

void () plat2_go_up = {

   sound (self,CHAN_VOICE,self.noise,TRUE,ATTN_NORM);
   self.state = STATE_UP;
   SUB_CalcMove (self.pos1,self.speed,plat2_hit_top);

};

void () plat2_use = {

   if ( (self.state > MOVETYPE_STEP) ) {

      self.state = (self.state - MOVETYPE_BOUNCE);

   }
   self.use = SUB_Null;

};

void () plat2_center_touch = {

   local float otherState;
   local vector platPosition;

   if ( (other.classname != "player") ) {

      return ;

   }
   if ( (other.health <= FALSE) ) {

      return ;

   }
   self = self.enemy;
   if ( ((self.plat2LastMove + FL_SWIM) > time) ) {

      return ;

   }
   if ( (self.state > MOVETYPE_STEP) ) {

      return ;

   }
   if ( (self.plat2GoTo > STATE_BOTTOM) ) {

      if ( (self.plat2GoTime < time) ) {

         if ( (self.plat2GoTo == STATE_UP) ) {

            plat2_go_up ();

         } else {

            plat2_go_down ();

         }
         self.plat2GoTo = FALSE;

      }
      return ;

   }
   if ( (self.state > STATE_BOTTOM) ) {

      return ;

   }
   platPosition = ((self.absmax + self.absmin) * 0.500);
   if ( (self.state == STATE_TOP) ) {

      otherState = STATE_TOP;
      if ( (platPosition_z > other.origin_z) ) {

         otherState = STATE_BOTTOM;

      }

   } else {

      otherState = STATE_BOTTOM;
      if ( ((other.origin_z - platPosition_z) > self.height) ) {

         otherState = STATE_TOP;

      }

   }
   if ( (self.state == otherState) ) {

      self.plat2Called = FALSE;
      self.plat2GoTime = (time + 0.500);

   } else {

      self.plat2GoTime = (time + 0.100);
      self.plat2Called = TRUE;

   }
   if ( (self.state == STATE_BOTTOM) ) {

      self.plat2GoTo = STATE_UP;

   } else {

      if ( (self.state == STATE_TOP) ) {

         self.plat2GoTo = STATE_DOWN;

      }

   }

};

void () plat2_crush = {

   T_Damage (other,self,self,TRUE);
   if ( (self.state == STATE_UP) ) {

      plat2_go_down ();

   } else {

      if ( (self.state == STATE_DOWN) ) {

         plat2_go_up ();

      } else {

         objerror ("plat2_crush: bad self.state\n");

      }

   }

};

void () func_new_plat = {

   local float negativeHeight;

   negativeHeight = FALSE;
   if ( !self.t_length ) {

      self.t_length = 80.000;

   }
   if ( !self.t_width ) {

      self.t_width = MOVETYPE_BOUNCE;

   }
   if ( (self.sounds == FALSE) ) {

      self.sounds = FL_SWIM;

   }
   if ( (self.sounds == TRUE) ) {

      precache_sound ("plats/plat1.wav");
      precache_sound ("plats/plat2.wav");
      self.noise = "plats/plat1.wav";
      self.noise1 = "plats/plat2.wav";

   }
   if ( (self.sounds == FL_SWIM) ) {

      precache_sound ("plats/medplat1.wav");
      precache_sound ("plats/medplat2.wav");
      self.noise = "plats/medplat1.wav";
      self.noise1 = "plats/medplat2.wav";

   }
   self.mangle = self.angles;
   self.angles = VEC_ORIGIN;
   self.classname = "plat";
   self.solid = SOLID_BSP;
   self.movetype = MOVETYPE_PUSH;
   setorigin (self,self.origin);
   setmodel (self,self.model);
   setsize (self,self.mins,self.maxs);
   if ( !self.speed ) {

      self.speed = 150.000;

   }
   self.pos1 = self.origin;
   self.pos2 = self.origin;
   if ( (self.height < FALSE) ) {

      negativeHeight = TRUE;
      self.height = (FALSE - self.height);

   }
   if ( self.height ) {

      self.pos2_z = (self.origin_z - self.height);

   } else {

      negativeHeight = TRUE;
      self.height = (self.size_z - FL_CLIENT);
      self.pos2_z = (self.origin_z - self.height);

   }
   if ( (self.spawnflags & DN_N_WAIT) ) {

      self.use = dn_and_wait_use;
      self.blocked = dn_and_wait_crush;
      if ( (negativeHeight == TRUE) ) {

         self.state = STATE_BOTTOM;
         setorigin (self,self.pos2);

      } else {

         self.state = STATE_TOP;

      }
      if ( !self.health ) {

         self.health = MOVETYPE_FLY;

      }

   } else {

      if ( (self.spawnflags & PLT_TOGGLE) ) {

         self.use = toggle_use;
         self.blocked = toggle_crush;
         if ( (negativeHeight == TRUE) ) {

            setorigin (self,self.pos2);
            self.state = STATE_BOTTOM;

         } else {

            self.state = STATE_TOP;

         }

      } else {

         if ( (self.spawnflags & ELEVATOR) ) {

            self.elevatorOnFloor = FALSE;
            self.elevatorToFloor = FALSE;
            self.elevatorLastUse = FALSE;
            if ( (self.spawnflags & START_AT_TOP) ) {

               self.pos1 = self.origin;
               self.pos2 = self.origin;
               self.pos2_z = (self.origin_z - (self.height * (self.cnt - TRUE)));
               self.elevatorOnFloor = (self.cnt - TRUE);

            } else {

               self.pos1 = self.origin;
               self.pos2 = self.origin;
               self.pos1_z = (self.origin_z + (self.height * (self.cnt - TRUE)));
               self.elevatorOnFloor = FALSE;

            }
            self.use = elvtr_use;
            self.blocked = elvtr_crush;

         } else {

            if ( (self.spawnflags & PLAT2) ) {

               plat2_spawn_inside_trigger ();
               self.plat2Called = FALSE;
               self.plat2LastMove = FALSE;
               self.plat2GoTo = FALSE;
               self.plat2GoTime = FALSE;
               self.blocked = plat2_crush;
               if ( !self.delay ) {

                  self.delay = MOVETYPE_WALK;

               }
               if ( (negativeHeight == TRUE) ) {

                  self.state = STATE_BOTTOM;
                  self.spawnflags = PLAT2;
                  setorigin (self,self.pos2);

               } else {

                  self.spawnflags = (self.spawnflags | START_AT_TOP);
                  self.state = STATE_TOP;

               }
               if ( self.targetname ) {

                  self.use = plat2_use;
                  self.state = (self.state + MOVETYPE_BOUNCE);

               }

            }

         }

      }

   }

};

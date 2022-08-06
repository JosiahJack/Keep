
void () keytrigger_use = {

   if ( (activator.classname != "player") ) {

      return ;

   }
   if ( (activator.health <= FALSE) ) {

      return ;

   }
   if ( (self.attack_finished > time) ) {

      return ;

   }
   self.attack_finished = (time + FL_SWIM);
   if ( ((self.items & activator.items) != self.items) ) {

      centerprint (activator, "You need a special type of key\n to fit this lock.");
      sound (self,CHAN_VOICE,self.noise3,TRUE,ATTN_NORM);
      return ;

   }

   self.touch = SUB_Null;
   self.use = SUB_Null;
   self.nextthink = (time + 0.100);
   self.think = SUB_Remove;
   self.message = "";
   SUB_UseTargets ();

};

void () keytrigger_touch = {

   activator = other;
   keytrigger_use ();

};

void () trigger_usekey_skeleton = {

   self.use = keytrigger_use;
   self.touch = keytrigger_touch;
   if ( !(self.items) ) {

         self.items = IT_KEY_SKELETON;

   }
   precache_sound ("doors/runetry.wav");
   self.noise3 = "doors/runetry.wav";
   InitTrigger ();

};

void () requisit_use = {

   if ( (activator.classname != "player") ) {

      return ;

   }
   if ( (activator.health <= FALSE) ) {

      return ;

   }
   if ( (self.attack_finished > time) ) {

      return ;

   }
   self.attack_finished = (time + FL_SWIM);
   if ( ((self.items & activator.items) != self.items) ) {

      return ;

   }
   self.touch = SUB_Null;
   self.use = SUB_Null;
   self.nextthink = (time + 0.100);
   self.think = SUB_Remove;
   SUB_UseTargets ();

};

void () requisit_touch = {

   activator = other;
   keytrigger_use ();

};

void () trigger_prerequisit = {

   self.use = requisit_use;
   self.touch = requisit_touch;
   if (!(self.items) ) {

      self.items = IT_KEY1;

   }
   InitTrigger ();

};

void () func_slidebox = {

   self.angles = VEC_ORIGIN;
   self.movetype = MOVETYPE_PUSH;
   self.solid = SOLID_SLIDEBOX;
   self.use = func_wall_use;
   setmodel (self,self.model);

};

void () trigger_disabled_touch = {

   if ( (self.disabled == TRUE) ) {

      return;

   } else {

      multi_touch ();

   }

};

void () trigger_disabled_use = {

   self.disabled = FALSE;

};

void () trigger_once_disabled = {

   if ( (self.sounds == TRUE) ) {

      precache_sound ("misc/secret.wav");
      self.noise = "misc/secret.wav";

   } else {

      if ( (self.sounds == FL_SWIM) ) {

         precache_sound ("misc/talk.wav");
         self.noise = "misc/talk.wav";

      } else {

         if ( (self.sounds == MOVETYPE_WALK) ) {

            precache_sound ("misc/trigger1.wav");
            self.noise = "misc/trigger1.wav";

         }

      }

   }
   self.wait = CONTENT_EMPTY;
   self.use = trigger_disabled_use;
   self.disabled = TRUE;
   InitTrigger ();

   if ( !(self.spawnflags & SPAWNFLAG_NOTOUCH) ) {

      self.touch = trigger_disabled_touch;

   }

};

void () conv_touch = {

   local vector vel;

   if ( !(other) ) {

      return ;

   }
   if ( (other.classname != "player") ) {

      return ;

   }
   other.velocity = (self.speed * self.movedir);
   vel = (self.speed * self.movedir);

   if ( (other.velocity_x + vel_x) < other.velocity_x ) {

      other.velocity_x = other.velocity_x - vel_x;

   } else {

      other.velocity_x = other.velocity_x + vel_x;

   }

   if ( (other.velocity_y + vel_y) < other.velocity_y ) {

      other.velocity_y = other.velocity_y - vel_y;

   } else {

      other.velocity_y = other.velocity_y + vel_y;

   }

};

void () conv_use = {

   if ( (self.disabled) ) {

      self.disabled = FALSE;
      self.touch = conv_touch;

   } else {

      self.disabled = TRUE;
      self.touch = SUB_Null;

   }

};

void () trigger_conveyor = {

   self.use = conv_use;
   self.avelocity = ((self.speed * self.movedir) * MOVETYPE_BOUNCE);
   if ( (!self.speed) ) {

      self.speed = MOVETYPE_BOUNCE; // 10

   }
   if ( (self.targetname) ) {

      self.touch = SUB_Null;
      self.disabled = TRUE;

   } else {

      self.touch = conv_touch;
      self.disabled = FALSE;

   }
   InitTrigger ();

};

void () info_timer_go = {

   SUB_UseTargets();
   self.think = info_timer_go;
   self.nextthink = (time + self.wait);
   

};

void () info_timer = {

   if (!self.target) {

      return;
   
   }
   if (!self.wait) {

      self.wait = TRUE;

   }
   self.think = info_timer_go;
   self.nextthink = (time + self.delay);

};
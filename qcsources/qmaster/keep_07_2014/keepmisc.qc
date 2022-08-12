void () env_sprite = {

   if ( self.model ) {

      precache_model (self.model);
      setmodel (self,self.model);
      makestatic (self);

   } else {

      objerror ("Sprite without a model");
      return ;

   }

};

void() steamp2 = [1 , steamp3]{}; 
void() steamp3 = [2 , SUB_Remove]{self.nextthink = time + 0.7;};

void() env_steam_think = { 

   local entity steamp; 
   local vector r;

   steamp = spawn(); 
   setmodel (steamp, "progs/steam.spr"); 
   setorigin (steamp, self.origin); 
   r = '0 6 0' * (random() - 0.5); 
   makevectors(self.mangle + r); 
   steamp.movetype = MOVETYPE_NOCLIP; 
   steamp.velocity = v_forward * self.speed; 
   steamp.nextthink = time + 0.1; 
   steamp.think = steamp2; 
   steamp.avelocity = '20 20 0'; 
   self.nextthink = time + self.wait; 

} 

void () env_steam = {

   precache_sound ("ambience/steam.wav");
   precache_model( "progs/steam.spr"); 

   if(self.targetname) 
   self.use = env_steam_think; 
   else 
   { 
   self.think = env_steam_think; 
   self.nextthink = time + 1;//no need to start straight off 
   } 
   if(!self.speed) 
   self.speed = 90; 
   if(!self.wait) 
   self.wait = 0.15; 
   ambientsound (self.origin, "ambience/steam.wav", 0.8, ATTN_STATIC);

};

void () body_kill = {

   if ( (self.classname != "player") ) {

      remove (self);

   }

};

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
   self.items = IT2_KEY_SKELETON;
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
   self.use = multi_use;

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

void () trigger_localcmd_use = {

   if ( !(activator) ) {

      return ;

   }
   if ( (activator.classname != "player") ) {

      return ;

   }
   if ( (activator.health <= FALSE) ) {

      return ;

   }
   self.touch = SUB_Null;
   self.use = SUB_Null;
   self.nextthink = (time + self.wait);
   self.think = trigger_localcmd_use;
   if ( self.message ) {

      localcmd (self.message);

   }

};

void () trigger_localcmd_touch = {

   activator = other;
   trigger_localcmd_use ();

};

void () trigger_localcmd = {

   self.use = trigger_localcmd_use;
   self.touch = trigger_localcmd_touch;
   if ( (self.wait <= FALSE) ) {

      self.wait = FL_SWIM;

   }
   InitTrigger ();

};
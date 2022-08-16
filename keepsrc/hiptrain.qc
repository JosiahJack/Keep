
void() hip_train_next;

void() hip_func_train_find;

void() hip_train_use = {

   if ( (self.think != hip_func_train_find) ) {

      if ( (self.velocity != VEC_ORIGIN) ) {

         return ;

      }

   }
   hip_train_next();

};

void() hip_train_wait = {

   if (self.wait ) {

      sound(self,CHAN_VOICE,self.noise,TRUE,ATTN_NORM);
      if ( (self.wait != CONTENT_EMPTY) ) {

         self.nextthink = (self.ltime + self.wait);
         self.wait = FALSE;

      }

   } else {

      self.nextthink = (self.ltime + 0.100);

   }
   self.think = hip_train_next;

};

void() hip_train_next = {

   local entity targ;
   local float current;
   local string temp;

   current = self.cnt;
   targ = find (world,targetname,self.target);
   self.cnt = targ.speed;
   self.target = targ.target;
   if ( !self.target ) {

      objerror ("hip_train_next: no next target");

   }
   sound(self,CHAN_VOICE,self.noise1,TRUE,ATTN_NORM);
   self.wait = targ.wait;
   if ( targ.wait ) {

      self.think = hip_train_wait;

   } else {

      self.think = hip_train_next;

   }
   if (self.goalentity.event ) {

      temp = self.target;
      self.target = self.goalentity.event;
      self.message = self.goalentity.message;
      SUB_UseTargets();
      self.target = temp;
      self.message = "";

   }
   self.goalentity = targ;
   if ( (current == CONTENT_EMPTY) ) {

      setorigin(self,(targ.origin - self.mins));
      self.nextthink = (self.ltime + 0.010);

   } else {

      if ( (current > FALSE) ) {

         self.speed = current;

      }
      SUB_CalcMove ((targ.origin - self.mins),self.speed,self.think);

   }

};

void() hip_func_train_find = {

   local entity targ;

   targ = find (world,targetname,self.target);
   self.goalentity = targ;
   self.cnt = targ.speed;
   self.target = targ.target;
   setorigin(self,(targ.origin - self.mins));
   if ( !self.targetname ) {

      self.nextthink = (self.ltime + 0.100);
      self.think = hip_train_next;

   }

};

void() func_train2 = {

   if ( !self.speed ) {

      self.speed = 100.000;

   }
   if ( !self.target ) {

      objerror ("func_train2 without a target");

   }
   if ( !self.dmg ) {

      self.dmg = FL_SWIM;

   }
   if ( !self.noise ) {

      if ( (self.sounds == FALSE) ) {

         self.noise = "misc/null.wav";

      }
      if ( (self.sounds == TRUE) ) {

         self.noise = "plats/train2.wav";

      }

   }
   if ( !self.noise1 ) {

      if ( (self.sounds == FALSE) ) {

         self.noise1 = "misc/null.wav";

      }
      if ( (self.sounds == TRUE) ) {

         self.noise1 = "plats/train1.wav";

      }

   }
   precache_sound(self.noise);
   precache_sound(self.noise1);
   self.cnt = TRUE;
   self.solid = SOLID_BSP;
   self.movetype = MOVETYPE_PUSH;
	self.classgroup = CG_FUNCMOVER;
	self.bsporigin = TRUE;
   self.blocked = func_train_blocked;
   self.use = hip_train_use;
   self.classname = "train2";
   setmodel(self,self.model);
   setsize (self,self.mins,self.maxs);
   setorigin(self,self.origin);
   self.nextthink = (self.ltime + 0.100);
   self.think = hip_func_train_find;

};

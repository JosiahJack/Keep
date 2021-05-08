float COUNTER_TOGGLE    = 1.000;
float COUNTER_LOOP    = 2.000;
float COUNTER_STEP    = 4.000;
float COUNTER_RESET    = 8.000;
float COUNTER_RANDOM    = 16.000;
float COUNTER_FINISHCOUNT    = 32.000;
float COUNTER_START_ON    = 64.000;

void () counter_on_use;

void () counter_off_use;

void () counter_think = {

   self.cnt = (self.cnt + TRUE);
   if ( (self.spawnflags & COUNTER_RANDOM) ) {

      self.state = (random () * self.count);
      self.state = (floor (self.state) + TRUE);

   } else {

      self.state = self.cnt;

   }
   activator = other;
   SUB_UseTargets ();
   self.nextthink = (time + self.wait);
   if ( (self.spawnflags & COUNTER_STEP) ) {

      counter_on_use ();

   }
   if ( (self.cnt >= self.count) ) {

      self.cnt = FALSE;
      if ( (self.aflag || !(self.spawnflags & COUNTER_LOOP)) ) {

         if ( (self.spawnflags & COUNTER_TOGGLE) ) {

            counter_on_use ();

         } else {

            remove (self);

         }

      }

   }

};

void () counter_on_use = {

   if ( ((self.cnt != FALSE) && (self.spawnflags & COUNTER_FINISHCOUNT)) ) {

      self.aflag = TRUE;
      return ;

   }
   self.use = counter_off_use;
   self.think = SUB_Null;
   self.aflag = FALSE;

};

void () counter_off_use = {

   self.aflag = FALSE;
   if ( (self.spawnflags & COUNTER_TOGGLE) ) {

      self.use = counter_on_use;

   } else {

      self.use = SUB_Null;

   }
   if ( (self.spawnflags & COUNTER_RESET) ) {

      self.cnt = FALSE;
      self.state = FALSE;

   }
   self.think = counter_think;
   if ( self.delay ) {

      self.nextthink = (time + self.delay);

   } else {

      counter_think ();

   }

};
float (entity counter) counter_GetCount = {

   local float value;

   if ( (counter.classname == "counter") ) {

      return ( counter.state );

   }
   return ( FALSE );

};

void () func_counter = {

   if ( !self.wait ) {

      self.wait = TRUE;

   }
   self.count = floor (self.count);
   if ( (self.count <= FALSE) ) {

      self.count = MOVETYPE_BOUNCE;

   }
   self.cnt = FALSE;
   self.state = FALSE;
   self.classname = "counter";
   self.use = counter_off_use;
   self.think = SUB_Null;
   if ( (self.spawnflags & COUNTER_START_ON) ) {

      self.think = counter_off_use;
      self.nextthink = (time + 0.100);

   }

};

void () oncount_use = {

   if ( (counter_GetCount (other) == self.count) ) {

      activator = other;
      SUB_UseTargets ();

   }

};

void () func_oncount = {

   self.count = floor (self.count);
   if ( (self.count <= FALSE) ) {

      self.count = TRUE;

   }
   self.classname = "oncount";
   self.use = oncount_use;
   self.think = SUB_Null;

};

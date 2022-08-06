float EQ_RANDOM    = 1.000;

void () stop_earthquake;

void () earthquake_rumble = {

   if ( (self.attack_finished < time) ) {

      stop_earthquake ();

   } else {

      sound (self,CHAN_VOICE,"equake/rumble.wav",TRUE,ATTN_NONE);
      self.think = earthquake_rumble;
      self.nextthink = (time + TRUE);

   }

};

void () start_earthquake = {

   earthquake_active = TRUE;
   if ( (self.spawnflags & EQ_RANDOM) ) {

      self.attack_finished = (time + (random () * self.delay));

   } else {

      self.attack_finished = (time + self.delay);

   }
   earthquake_rumble ();

};

void () stop_earthquake = {

   earthquake_active = FALSE;
   self.think = start_earthquake;
   if ( (self.spawnflags & EQ_RANDOM) ) {

      self.nextthink = (time + (random () * self.wait));

   } else {

      self.nextthink = (time + self.wait);

   }

};

void () earthquake = {

   if ( !self.delay ) {

      self.delay = 20.000;

   }
   if ( !self.wait ) {

      self.wait = 60.000;

   }
   if ( !self.weapon ) {

      self.weapon = CTF_FLAG_RETURN_TIME;

   }
   precache_sound ("equake/rumble.wav");
   earthquake_active = FALSE;
   earthquake_intensity = (self.weapon * 0.500);
   setsize (self,VEC_ORIGIN,VEC_ORIGIN);
   self.think = stop_earthquake;
   self.nextthink = (time + TRUE);

};

void () earthquake_touch = {

   if ( self.delay ) {

      if ( (self.attack_finished < time) ) {

         sound (self,CHAN_VOICE,"equake/rumble.wav",TRUE,ATTN_NORM);
         self.attack_finished = (time + TRUE);

      }
      if ( (other.classname == "player") ) {

         if ( (other.flags & FL_ONGROUND) ) {

            other.velocity_x = ((other.velocity_x + ((random () * self.weapon) * FL_SWIM)) - self.weapon);
            other.velocity_y = ((other.velocity_y + ((random () * self.weapon) * FL_SWIM)) - self.weapon);
            other.velocity_z = ((other.velocity_z + ((random () * self.weapon) * FL_SWIM)) - self.weapon);

         }

      }

   }

};

void () earthquake_use = {

   self.delay = !self.delay;

};

void () trigger_earthquake = {

   precache_sound ("equake/rumble.wav");
   if ( !self.weapon ) {

      self.weapon = CTF_FLAG_RETURN_TIME;

   }
   self.weapon = (self.weapon * 0.500);
   self.delay = TRUE;
   self.touch = earthquake_touch;
   if ( self.targetname ) {

      self.use = earthquake_use;
      self.delay = FALSE;

   }
   InitTrigger ();

};

void () kill_earthquake = {

   local entity eq;

   if ( (other.classname != "player") ) {

      return ;

   }
   eq = find (world,classname,"earthquake");
   if ( (eq != world) ) {

      earthquake_active = FALSE;
      remove (eq);

   }

};

void () trigger_earthquake_kill = {

   self.touch = kill_earthquake;
   InitTrigger ();

};

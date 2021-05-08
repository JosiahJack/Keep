float earthquake /* = 0.000 */;
float quakeactive /* = 0.000 */;

void () StopEarthQuake = {

   earthquake = FALSE;

};

void (float value) EarthQuakeTime = {

   value = (value + time);
   if ( (value > earthquake) ) {

      earthquake = value;

   }

};

void () earthquake_prethink = {


};

void () earthquake_postthink = {

   if ( (earthquake > time) ) {

      if ( (quakeactive == FALSE) ) {

         sound (self,CHAN_VOICE,"misc/quake.wav",TRUE,ATTN_NONE);
         quakeactive = TRUE;

      }
      if ( (self.flags & FL_ONGROUND) ) {

         self.velocity = (self.velocity + (random () * '0.000 0.000 150.000'));

      }

   } else {

      if ( (quakeactive == TRUE) ) {

         sound (self,CHAN_VOICE,"misc/quakeend.wav",TRUE,ATTN_NONE);
         quakeactive = FALSE;

      }

   }

};

void () earthquake_use = {

   EarthQuakeTime (self.dmg);

};

void () func_earthquake = {

   quakeactive = FALSE;
   precache_sound ("misc/quake.wav");
   precache_sound ("misc/quakeend.wav");
   self.classname = "earthquake";
   self.use = earthquake_use;
   self.think = SUB_Null;
   if ( !self.dmg ) {

      self.dmg = 0.800;

   }

};

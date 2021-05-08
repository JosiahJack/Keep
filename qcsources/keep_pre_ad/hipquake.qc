float hipearthquake /* = 0.000 */;
float quakeactive /* = 0.000 */;

void () StopEarthQuake = {

   hipearthquake = FALSE;

};

void (float value) EarthQuakeTime = {

   value = (value + time);
   if ( (value > hipearthquake) ) {

      hipearthquake = value;

   }

};

void () earthquake_prethink = {


};

void () earthquake_postthink = {

   if ( (hipearthquake > time) ) {

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

void () hipearthquake_use = {

   EarthQuakeTime (self.dmg);

};

void () func_earthquake = {

   quakeactive = FALSE;
   precache_sound ("misc/quake.wav");
   precache_sound ("misc/quakeend.wav");
   self.classname = "earthquake";
   self.use = hipearthquake_use;
   self.think = SUB_Null;
   if ( !self.dmg ) {

      self.dmg = 0.800;

   }

};

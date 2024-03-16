float hip_earthquake /* = 0.000 */;
float hip_quakeactive /* = 0.000 */;

void () HipStopEarthQuake = {

   hip_earthquake = FALSE;

};

void (float value) HipEarthQuakeTime = {

   value = (value + time);
   if ( (value > hip_earthquake) ) {

      hip_earthquake = value;

   }

};

void () hip_earthquake_prethink = {


};

void () hip_earthquake_postthink = {

   if ( (hip_earthquake > time) ) {

      if ( (hip_quakeactive == FALSE) ) {

         sound (self,CHAN_VOICE,"misc/quake.wav",TRUE,ATTN_NONE);
         hip_quakeactive = TRUE;

      }
      if ( (self.flags & FL_ONGROUND) ) {

         self.velocity = (self.velocity + (random () * '0.000 0.000 150.000'));

      }

   } else {

      if ( (hip_quakeactive == TRUE) ) {

         sound (self,CHAN_VOICE,"misc/quakeend.wav",TRUE,ATTN_NONE);
         hip_quakeactive = FALSE;

      }

   }

};

void () hip_earthquake_use = {

   HipEarthQuakeTime (self.dmg);

};

void () func_earthquake = {

   hip_quakeactive = FALSE;
   precache_sound ("misc/quake.wav");
   precache_sound ("misc/quakeend.wav");
   self.classname = "earthquake";
   self.use = hip_earthquake_use;
   self.think = SUB_Null;
   if ( !self.dmg ) {

      self.dmg = 0.800;

   }

};

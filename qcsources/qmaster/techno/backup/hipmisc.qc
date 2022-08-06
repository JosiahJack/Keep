void () play_sound_use = {

   if ( (self.spawnflags & TRUE) ) {

      if ( (self.state == FALSE) ) {

         self.state = TRUE;
         sound (self,self.impulse,self.noise,self.volume,self.speed);

      } else {

         self.state = FALSE;
         sound (self,self.impulse,"misc/null.wav",self.volume,self.speed);

      }

   } else {

      sound (self,self.impulse,self.noise,self.volume,self.speed);

   }

};

void () PlaySoundThink = {

   local float t;

   t = (self.wait * random ());
   if ( (t < self.delay) ) {

      t = self.delay;

   }
   self.nextthink = (time + t);
   play_sound_use ();

};

void () play_sound_triggered = {

   precache_sound (self.noise);
   precache_sound ("misc/null.wav");
   if ( (self.volume == FALSE) ) {

      self.volume = TRUE;

   }
   if ( (self.speed == FALSE) ) {

      self.speed = TRUE;

   }
   if ( (self.speed == CONTENT_EMPTY) ) {

      self.speed = FALSE;

   }
   if ( (self.spawnflags & TRUE) ) {

      if ( (self.impulse == FALSE) ) {

         self.impulse = MOVETYPE_PUSH;

      }

   }
   self.use = play_sound_use;

};

void () play_sound = {

   local float t;

   play_sound_triggered ();
   if ( (self.wait == FALSE) ) {

      self.wait = 20.000;

   }
   if ( (self.delay == FALSE) ) {

      self.delay = FL_SWIM;

   }
   self.think = PlaySoundThink;
   t = (self.wait * random ());
   if ( (t < self.delay) ) {

      t = self.delay;

   }
   self.nextthink = (time + t);

};



void () ambient_humming = {

   if ( (self.volume == FALSE) ) {

      self.volume = 0.500;

   }
   precache_sound ("ambient/humming.wav");
   ambientsound (self.origin,"ambient/humming.wav",self.volume,ATTN_STATIC);

};

void () ambient_rushing = {

   if ( (self.volume == FALSE) ) {

      self.volume = 0.500;

   }
   precache_sound ("ambient/rushing.wav");
   ambientsound (self.origin,"ambient/rushing.wav",self.volume,ATTN_STATIC);

};

void () ambient_fan_blowing = {

   if ( (self.volume == FALSE) ) {

      self.volume = 0.500;

   }
   precache_sound ("ambient/fanblow.wav");
   ambientsound (self.origin,"ambient/fanblow.wav",self.volume,ATTN_STATIC);

};

void () ambient_waterfall = {

   if ( (self.volume == FALSE) ) {

      self.volume = 0.500;

   }
   precache_sound ("ambient/waterfal.wav");
   ambientsound (self.origin,"ambient/waterfal.wav",self.volume,ATTN_STATIC);

};

void () ambient_riftpower = {

   if ( (self.volume == FALSE) ) {

      self.volume = 0.500;

   }
   precache_sound ("ambient/riftpowr.wav");
   ambientsound (self.origin,"ambient/riftpowr.wav",self.volume,ATTN_STATIC);

};

void () command_use = {

   SUB_UseTargets ();
   if ( (self.currentammo) ) {
      if ( self.message ) {
  
         localcmd (self.message);
         self.currentammo = (self.currentammo - 1);

      }
   } else {

      remove (self);

   }

};

void () info_command = {

   if ( (self.targetname) ) {

      self.use = command_use;

   } else {

      if ( self.message ) {
  
         localcmd (self.message);

      }
   }

};

void () effect_teleport_use = {

   WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
   WriteByte (MSG_BROADCAST,TE_TELEPORT);
   WriteCoord (MSG_BROADCAST,self.origin_x);
   WriteCoord (MSG_BROADCAST,self.origin_y);
   WriteCoord (MSG_BROADCAST,self.origin_z);
   sound (self,CHAN_VOICE,"misc/r_tele1.wav",TRUE,ATTN_NORM);

};

void () effect_teleport = {

   precache_sound ("misc/r_tele1.wav");
   self.use = effect_teleport_use;

};
float SVC_UPDATEENTITY    = 128.000;

void (entity me, entity camera) UpdateCamera = {

   msg_entity = me;
   WriteByte (MSG_ONE,(SVC_UPDATEENTITY | 15.000));
   WriteByte (MSG_ONE,FL_GODMODE);
   WriteEntity (MSG_ONE,camera);
   WriteCoord (MSG_ONE,camera.origin_x);
   WriteCoord (MSG_ONE,camera.origin_y);
   WriteCoord (MSG_ONE,camera.origin_z);

};

void () info_startendtext_use = {

   intermission_running = TRUE;
   ExitIntermission ();

};

void () info_startendtext = {

   self.use = info_startendtext_use;

};

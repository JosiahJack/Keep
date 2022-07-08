void() play_sound_use = { // [FUNCTION]
   if ( (self.spawnflags & TRUE) ) {
      if ( (self.state == FALSE) ) {
         self.state = TRUE;
         sound (self,self.impulse,self.noise,self.volume,self.speed);
      } else {
         self.state = FALSE;
         sound (self,self.impulse,"misc/null.wav",self.volume,self.speed);
      }
   } else sound (self,self.impulse,self.noise,self.volume,self.speed);
};

void() PlaySoundThink = { // [FUNCTION]
   local float t;

   t = (self.wait * random());
   if (t < self.delay) t = self.delay;
   self.nextthink = (time + t);
   play_sound_use();
};

void() play_sound_triggered = { // [ENTITY]
   precache_sound (self.noise);
   precache_sound ("misc/null.wav");
   if ( (self.volume <= 0) ) self.volume = 1;
   if ( (self.speed == 0) ) self.speed = 1;
   if ( (self.speed < 0) ) self.speed = 0;
   if ( (self.spawnflags & TRUE) ) {
      if ( (self.impulse == FALSE) ) self.impulse = MOVETYPE_PUSH;
   }
   self.use = play_sound_use;
};

void() play_sound = { // [ENTITY]
   local float t;

   play_sound_triggered();
   if (self.wait <= 0) self.wait = 20.000;
   if (self.delay <= 0) self.delay = 2;
   self.think = PlaySoundThink;
   t = (self.wait * random ());
   if (t < self.delay) t = self.delay;
   self.nextthink = (time + t);
};

void() random_thunder = { // [ENTITY]
   self.noise = "ambience/thunder1.wav";
   play_sound();
   self.impulse = MOVETYPE_TOSS;
};

void() random_thunder_triggered = { // [ENTITY]
   self.noise = "ambience/thunder1.wav";
   play_sound_triggered();
   self.impulse = MOVETYPE_TOSS;
};

void() effect_teleport = { // [ENTITY]
   self.use = spawn_tfog_self;
};

float SVC_UPDATEENTITY    = 128.000;

void(entity me, entity camera) UpdateCamera = { // [FUNCTION]
   msg_entity = me;
   WriteByte (MSG_ONE,(SVC_UPDATEENTITY | 15.000));
   WriteByte (MSG_ONE,FL_GODMODE);
   WriteEntity (MSG_ONE,camera);
   WriteCoord (MSG_ONE,camera.origin_x);
   WriteCoord (MSG_ONE,camera.origin_y);
   WriteCoord (MSG_ONE,camera.origin_z);
};

void() effect_finale_use = { // [FUNCTION]
   local entity pos, pl, targ, temp;

   if (self.state) return;

   self.state = TRUE;
   pos = find (world,targetname,self.target);
   if (!pos) error ("no target in finale");
   WriteByte (MSG_ALL,SVC_CUTSCENE);
   WriteString (MSG_ALL,"");
   if ( !(self.spawnflags & FL_SWIM) ) {
      if ( (self.spawnflags & TRUE) ) {
         pl = find (world,classname,"player");
         targ = find (world,targetname,self.mdl);
         become_decoy (targ.target,pl.origin);
      } else {
         targ = find (world,targetname,self.mdl);
         become_decoy (targ.target,targ.origin);
      }
   }

   pl = find (world,classname,"player");
   while ( (pl != world) ) {
      pl.view_ofs = VEC_ORIGIN;
      other.v_angle = pos.mangle;
      pl.angles = pos.mangle;
      pl.mangle = pos.mangle;
      pl.fixangle = TRUE;
      pl.trigger_field = self;
      pl.nextthink = (time + 0.500);
      pl.takedamage = DAMAGE_NO;
      pl.solid = SOLID_NOT;
      pl.movetype = MOVETYPE_NONE;
      pl.modelindex = FALSE;
      setorigin (pl,pos.origin);
      pl.origin = pos.origin;
      pl.oldorigin = pos.origin;
      UpdateCamera(pl,pl);
      UpdateCamera(pl,pl.trigger_field);
      pl = find (pl,classname,"player");
   }

   if ( self.spawnfunction ) {
      self.nextthink = (time + self.wait);
      self.think = self.spawnfunction;
   }
};

void() effect_finale = { // [ENTITY]
   if ( deathmatch ) { remove(self); return; }

   setorigin (self,self.origin);
   self.angles = self.mangle;
   self.use = effect_finale_use;
   self.state = FALSE;
};

void() info_startendtext_use = { // [FUNCTION]
   intermission_running = TRUE;
   FinishIntermissionCamera();
};

void() info_startendtext = { // [ENTITY]
   self.use = info_startendtext_use;
};
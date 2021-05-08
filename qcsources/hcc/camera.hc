
void  (entity voyeur,entity viewthing)CameraViewPort =  {
   msg_entity = voyeur;
   WriteByte ( MSG_ONE, SVC_SETVIEWPORT);
   WriteEntity ( MSG_ONE, viewthing);
};


void  (entity voyeur,entity viewthing)CameraViewAngles =  {
   msg_entity = voyeur;
   WriteByte ( MSG_ONE, SVC_SETVIEWANGLES);
   if ( (viewthing.classname == "camera_remote") ) {

      WriteAngle ( MSG_ONE, (360.00000 - viewthing.angles_x));
   } else {

      WriteAngle ( MSG_ONE, viewthing.angles_x);

   }
   WriteAngle ( MSG_ONE, viewthing.angles_y);
   WriteAngle ( MSG_ONE, viewthing.angles_z);
};


void  ()target_null =  {
   self.solid = SOLID_SLIDEBOX;
   self.movetype = MOVETYPE_NONE;
   precache_model ( "models/sprites/null.spr");
   setmodel ( self, "models/sprites/null.spr");
};


void  ()play_camera =  {
   sound ( self, CHAN_VOICE, "misc/camera.wav", 1.00000, ATTN_NORM);
   remove ( self);
};


void  ()CameraUse =  {
local entity snd_ent;
   other = other.enemy;
   if ( (other.classname != "player") ) {

      return ;

   }
   stuffcmd ( other, "bf\n");
   if ( deathmatch ) {

      other.view_ofs = '0.00000 0.00000 0.00000';

   }
   other.cameramode = self;
   other.camera_time = (time + self.wait);
   other.oldangles = other.angles;
   other.lastweapon = other.weaponmodel;
   other.weaponmodel = string_null;
   CameraViewPort ( other, self);
   WriteByte ( MSG_ONE, 10.00000);
   WriteAngle ( MSG_ONE, (360.00000 - self.angles_x));
   WriteAngle ( MSG_ONE, self.angles_y);
   WriteAngle ( MSG_ONE, self.angles_z);
   snd_ent = spawn ( );
   snd_ent.origin = self.origin;
   AdvanceThinkTime(snd_ent,HX_FRAME_TIME);
   snd_ent.think = play_camera;
};


void  ()CameraReturn =  {
local entity snd_ent;
   self.cameramode = world;
   self.weaponmodel = self.lastweapon;
   self.view_ofs = (self.proj_ofs + '0.00000 0.00000 6.00000');
   stuffcmd ( self, "bf\n");
   self.angles = self.oldangles;
   self.idealroll = 0.00000;
   CameraViewPort ( self, self);
   CameraViewAngles ( self, self);
   snd_ent = spawn ( );
   snd_ent.origin = self.origin;
   AdvanceThinkTime(snd_ent,HX_FRAME_TIME);
   snd_ent.think = play_camera;
};


void  ()camera_target =  {
   self.enemy = find ( world, targetname, self.target);
   self.angles = vectoangles ( (self.enemy.origin - self.origin));
};


void  ()camera_remote =  {
   if ( deathmatch ) {

      remove ( self);
      return ;

   }
   self.solid = SOLID_NOT;
   self.movetype = MOVETYPE_NONE;
   precache_model ( "models/sprites/null.spr");
   setmodel ( self, "models/sprites/null.spr");
   self.use = CameraUse;
   if ( !self.wait ) {

      self.wait = 3.00000;

   }
   if ( self.target ) {

      self.think = camera_target;
      self.nextthink = (time + 0.02000);

   }
   setsize ( self, '-1.00000 -1.00000 0.00000', '1.00000 1.00000 1.00000');
};


void  ()CameraThink =  {
local vector viewdir = '0.00000 0.00000 0.00000';
local vector spot1 = '0.00000 0.00000 0.00000';
local vector spot2 = '0.00000 0.00000 0.00000';
   self.level = cvar ( "chase_back");
   if ( (self.cnt < self.level) ) {

      self.cnt += 1.00000;
   } else {

      if ( (self.cnt > self.level) ) {

         self.cnt -= 1.00000;

      }

   }
   makevectors ( self.owner.v_angle);
   viewdir = normalize ( v_forward);
   spot1 = ((self.owner.origin + self.owner.proj_ofs) + '0.00000 0.00000 6.00000');
   spot2 = (spot1 - (viewdir * self.cnt));
   traceline ( spot1, spot2, TRUE, self.owner);
   viewdir = normalize ( (spot1 - trace_endpos));
   setorigin ( self, (trace_endpos + (viewdir * 4.00000)));
   self.think = CameraThink;
   AdvanceThinkTime(self,0.00000);
};


void  ()MakeCamera =  {
   if ( (self.viewentity.classname == "chasecam") ) {

      CameraViewPort ( self, self);
      CameraViewAngles ( self, self);
      remove ( self.viewentity);
      self.viewentity = self;
      self.view_ofs = (self.proj_ofs + '0.00000 0.00000 6.00000');
      self.attack_finished = 0.00000;
      self.weaponmodel = self.lastweapon;
      W_SetCurrentWeapon ( );
   } else {

      self.lastweapon = self.weaponmodel;
      self.oldweapon = 0.00000;
      self.weaponmodel = "";
      makevectors ( self.v_angle);
      self.viewentity = spawn ( );
      self.viewentity.owner = self;
      self.viewentity.angles = self.angles;
      self.viewentity.level = cvar ( "chase_back");
      if ( !self.viewentity.level ) {

         self.viewentity.level = 68.00000;

      }
      self.viewentity.cnt = 4.00000;
      self.viewentity.classname = "chasecam";
      self.view_ofs = '0.00000 0.00000 0.00000';
      setmodel ( self.viewentity, "models/null.spr");
      setsize ( self.viewentity, '0.00000 0.00000 0.00000', '0.00000 0.00000 0.00000');
      setorigin ( self.viewentity, (((self.origin + self.proj_ofs) + '0.00000 0.00000 6.00000') - (v_forward * 4.00000)));
      CameraViewPort ( self, self.viewentity);
      CameraViewAngles ( self, self.viewentity);
      self.viewentity.think = CameraThink;
      AdvanceThinkTime(self.viewentity,0.00000);

   }
};


//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by W. Josiah Jack, aka Qmaster
//
// Attributions: Mission Pack 2 (Rogue)
//
//
// Distribution / Copyright / Permissions 
//
// Please do not use any of these assets in ANY COMMERCIAL PROJECT.
// and remember to give credit if you use any of these assets. Please credit
// the appropriate authors of the various content used.  Refer to the credits
// folder.
//				  
// The QC files in this MOD are based on 1.06 source files by ID Software.
// These files are released under the terms of GNU General Public License v2 or
// later. You may use the source files as a base to build your own MODs as long
// as you release them under the same license and make the source available.
// Please also give proper credit. Check http://www.gnu.org for details.
//
// Quake is a registered trademark of id Software, Inc.
//
// All of these resources may be electronically distributed only at 
// NO CHARGE to the recipient.
//
// Stats:
// Entity count: 0
// Function count: 30
//
// Implements: Ending Sequence
//
// Description:
// The final sequence when the player has defeated Quake by destroying the time
// machine after killing the dragon.
//=============================================================================

void(entity ownerEntity) sphere_remove;
void(entity thePlayer) spawn_actor;
void() actor_control;
void(entity playerEnt) move_rogue_camera;
void() time_crash;
void(entity inflictor, entity attacker, float take) time_crash_pain;
void() ending_remove_stuff;

void() ending_for_coop = { // [FUNCTION]
   intermission_exittime = (time + 10000000.000);
   intermission_running = TRUE;
   self.model = "";
   self.yaw_speed = 20.000;
   self.view_ofs = VEC_ORIGIN;
   self.takedamage = DAMAGE_NO;
   self.solid = SOLID_NOT;
   self.movetype = MOVETYPE_NONE;
   self.modelindex = 0;
   setorigin(self,(self.origin + '0.000 0.000 48.000'));
   WriteByte (MSG_ALL,SVC_FINALE);
   WriteString (MSG_ALL,"You have destroyed Quake's\nTemporal Teleporter. His assault\non Time has been defeated.");
   ending_remove_stuff();
   theMachine.think = time_crash;
   theMachine.nextthink = (time + 0.100);
};

void() xpackEnding = { // [FUNCTION]
   local entity cameraview;

   if (coop) { ending_for_coop(); return; }

   intermission_exittime = (time + 10000000.000);
   intermission_running = TRUE;
   WriteByte(MSG_ALL,SVC_CUTSCENE);
   WriteString(MSG_ALL,"");
   cameraview = find (world,targetname,"cameraview");
   if (cameraview == world) { ending_for_coop(); return; }

   self.solid = SOLID_NOT;
   self.movetype = MOVETYPE_NONE;
   spawn_actor(self);
   move_rogue_camera(self);
};

void() track_camera = { // [FUNCTION]
   local vector cameraAngle;

   cameraAngle = (theActor.origin - self.origin);
   cameraAngle_z = (FALSE - cameraAngle_z);
   self.angles = vectoangles (cameraAngle);
   self.v_angle = self.angles;
   self.think = track_camera;
   self.nextthink = (time + 0.100);
};

void(entity playerEnt) move_rogue_camera = { // [FUNCTION]
   local entity cameraPoint;
   local vector cameraAngle;

   cameraPoint = find (world,targetname,"cameraview");
   if (cameraPoint == world) objerror ("Could not find camerapoint!");

   self.model = "";
   self.yaw_speed = 20.000;
   self.view_ofs = VEC_ORIGIN;
   self.takedamage = DAMAGE_NO;
   self.solid = SOLID_NOT;
   self.movetype = MOVETYPE_NONE;
   self.modelindex = 0;
   setorigin(self,cameraPoint.origin);
   cameraAngle = (theActor.origin - self.origin);
   self.angles = vectoangles (cameraAngle);
   self.v_angle = self.angles;
   self.think = track_camera;
   self.nextthink = (time + 0.050);
};

void() ending_remove_stuff = { // [FUNCTION]
   local entity curEnt;

   curEnt = find (world,classname,"ltrail_start");
   while (curEnt) {
      remove(curEnt);
      curEnt = find (world,classname,"ltrail_start");

   }
   curEnt = find (world,classname,"item_time_core");
   Tent_Explosion2(curEnt.origin,230,5);
   curEnt.think = SUB_Remove;
   curEnt.nextthink = (time + 0.100);
};

void() actor_rogue_run = { // [FUNCTION]
   local vector dist;
   local entity pointOne;

   if (InLava(self.origin)) {
      pointOne = find(world,targetname,"point1");
      if (pointOne) setorigin(self,pointOne.origin);
   }
   if ( (self.goalentity.targetname == "endpoint1") ) {
      actorStage = STAGE_AT_POINT1;
      self.think = actor_control;
      self.nextthink = (time + 0.100);
      return;
   }

   if ( (self.goalentity.targetname == "endpoint2") ) {
      actorStage = STAGE_AT_POINT2;
      self.think = actor_control;
      self.nextthink = (time + 0.100);
      return;
   }

   self.frame = (self.frame + TRUE);
   if (self.frame > MOVETYPE_BOUNCEMISSILE) self.frame = MOVETYPE_TOSS;
   dist = (self.goalentity.origin - self.origin);
   movetogoal(CTF_CAPTURE_BONUS);
   self.think = actor_rogue_run;
   self.nextthink = (time + 0.100);
};

void() actor_fire1 = [ 107.000, actor_fire2 ] { // [FUNCTION]
	if (theMachine) {
	   self.goalentity = theMachine;
	   theMachine.th_pain = time_crash_pain;
	   theMachine.th_die = time_crash;
	   theMachine.health = TRUE;
	}
   self.angles = vectoangles ((self.goalentity.origin - self.origin));
   self.v_angle = self.angles;
   self.v_angle_x = (FALSE - self.angles_x);
   self.effects = EF_MUZZLEFLASH;
   W_FireRocket();
   WriteByte (MSG_ALL,SVC_FINALE);
   WriteString (MSG_ALL,"\nFinally, Quake's Temporal Teleporter\nyields to your assault. A high\npitched scream emits from the\ndevastated device as stressed steel\nblasts outward to rock the cavern.\nThe machine is devoured by molten lava.\n\nThe ground shudders as reality shi..");
};
void() actor_fire2 = [ 108.000, actor_fire3 ] { // [FUNCTION]
   self.v_angle_x = FALSE;
   self.angles_x = FALSE;
   self.nextthink = (time + 0.150);
};
void() actor_fire3 = [ 109.000, actor_fire4 ] { self.nextthink = (time + 0.150); }; // [FUNCTION]
void() actor_fire4 = [ 110.000, actor_fire5 ] { self.nextthink = (time + 0.150); }; // [FUNCTION]
void() actor_fire5 = [ 111.000, actor_fire6 ] { // [FUNCTION]
   self.nextthink = (time + 0.150);
   ending_remove_stuff();
	if (theMachine) {
	   if (theMachine.health > 0) {
		  theMachine.think = time_crash;
		  theMachine.nextthink = (time + 0.1);
	   }
	}
};
void() actor_fire6 = [ 112.000, actor_fire7 ] { self.effects = 0; self.nextthink = (time + 0.150); }; // [FUNCTION]
void() actor_fire7 = [ 12.000, actor_fire8 ] { self.nextthink = (time + 0.150); }; // [FUNCTION]
void() actor_fire8 = [ 13.000, actor_fire9 ] { self.nextthink = (time + 0.150); }; // [FUNCTION]
void() actor_fire9 = [ 14.000, actor_fire10 ] { self.nextthink = (time + 0.150); }; // [FUNCTION]
void() actor_fire10 = [ 15.000, actor_fire11 ] { self.nextthink = (time + 0.150); }; // [FUNCTION]
void() actor_fire11 = [ 16.000, actor_fire12 ] { self.nextthink = (time + 0.150); }; // [FUNCTION]
void() actor_fire12 = [ 12.000, actor_fire13 ] { self.nextthink = (time + 0.150); }; // [FUNCTION]
void() actor_fire13 = [ 13.000, actor_fire14 ] { self.nextthink = (time + 0.150); }; // [FUNCTION]
void() actor_fire14 = [ 14.000, actor_fire15 ] { self.nextthink = (time + 0.150); }; // [FUNCTION]
void() actor_fire15 = [ 15.000, actor_fire16 ] { self.nextthink = (time + 0.150); }; // [FUNCTION]
void() actor_fire16 = [ 16.000, actor_fire17 ] { self.nextthink = (time + 0.150); }; // [FUNCTION]
void() actor_fire17 = [ 12.000, actor_fire18 ] { self.nextthink = (time + 0.150); }; // [FUNCTION]
void() actor_fire18 = [ 13.000, actor_fire19 ] { self.nextthink = (time + 0.150); }; // [FUNCTION]
void() actor_fire19 = [ 14.000, actor_fire20 ] { self.nextthink = (time + 0.150); }; // [FUNCTION]
void() actor_fire20 = [ 15.000, actor_fire21 ] { self.nextthink = (time + 0.150); }; // [FUNCTION]
void() actor_fire21 = [ 16.000, actor_control ] { self.nextthink = (time + 0.150); actorStage = STAGE_TO_POINT2; }; // [FUNCTION]

void() actor_teleport = { // [FUNCTION]
   spawn_tfog (self.origin);
   self.model = "";
   self.think = SUB_Null;
   self.nextthink = (time + 999999.000);
};

void() actor_control = { // [FUNCTION]
   if (actorStage == STAGE_START) {
      self.target = "point1";
      self.movetarget = find (world,targetname,self.target);
      self.goalentity = self.movetarget;
      if (self.goalentity == world) objerror ("End Sequence point1 placing screwed up!");
      self.frame = MOVETYPE_TOSS;
      self.think = actor_rogue_run;
      self.nextthink = (time + 0.100);
      actorStage = STAGE_TO_POINT1;
   } else {
      if (actorStage == STAGE_AT_POINT1) {
         self.target = "machine";
         self.movetarget = find (world,targetname,self.target);
         self.goalentity = self.movetarget;
         if (self.goalentity == world) objerror ("End Sequence machine placing screwed up!");
         actorStage = STAGE_FIRING;
         self.think = actor_fire1;
         self.nextthink = (time + 0.100);
      } else {
         if (actorStage == STAGE_AT_POINT2) {
            self.frame = STAT_TOTALMONSTERS;
            self.think = actor_teleport;
            self.nextthink = (time + FL_SWIM);
         } else {
            if (actorStage == STAGE_TO_POINT2) {
               self.target = "timepod";
               SUB_UseTargets();
               self.target = "point2";
               self.movetarget = find (world,targetname,self.target);
               self.goalentity = self.movetarget;
               if (self.goalentity == world) objerror ("End Sequence point2 placing screwed up!");
               self.frame = MOVETYPE_TOSS;
               self.think = actor_rogue_run;
               self.nextthink = (time + 0.100);
            }
         }
      }
   }
};

void(entity thePlayer) spawn_actor = { // [FUNCTION]
	local entity pointOne;

	theActor = spawn();
	theActor.owner = self;
	theActor.classname = "actor";
	theActor.health = 100.000;
	theActor.solid = SOLID_SLIDEBOX;
	theActor.movetype = MOVETYPE_STEP;
	theActor.frame = self.frame;
	setmodel(theActor,"progs/player.mdl");
	setorigin(theActor,self.origin);
	setsize (theActor,VEC_HULL_MIN,VEC_HULL_MAX);
	theActor.view_ofs = '0.000 0.000 22.000';
	theActor.angles = self.angles;
	theActor.ideal_yaw = (theActor.angles * '0.000 1.000 0.000');
	if (!theActor.yaw_speed) theActor.yaw_speed = 20.000;
	theActor.view_ofs = '0.000 0.000 25.000';
	theActor.flags = (theActor.flags | FL_MONSTER);
	if (InLava(theActor.origin) ) {
		pointOne = find(world,targetname,"point1");
		if (pointOne) setorigin(theActor,pointOne.origin);
	}

	theActor.think = actor_control;
	theActor.nextthink = (time + 0.100);
};
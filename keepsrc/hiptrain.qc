//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by W. Josiah Jack, aka Qmaster
//
// Attributions: Mission Pack 1 (Hipnotic) by Ritual Entertainment
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
// Entity count: 1
// Function count: 4
//
// Implements: Advanced Train
//
// Description:
// This is a modification of the standard func_train entity.  It is
// functionally equivalent, except that it removes a slight delay that would
// occur after each path entry, and it adds a speed variable to the path_corner
// entity.
//
// "noise" contains the name of the sound to play when train stops.
// "noise1" contains the name of the sound to play when train moves.
// Both "noise" and "noise1" defaults depend upon "sounds" variable.
//
// In path_corner, set "speed" to be the new speed of the train after it reaches
// the path change.  If "speed" is -1, the train will warp directly to the next
// path change after the specified wait time.
//
// Also in path_corner, if wait is set to -1, the train will wait until it is
// retriggered before moving on to the next goal.
//
// Here is a reiteration of the func_train docs:
// Trains are moving platforms that players can ride.  The targets origin
// specifies the min point of the train at each corner.  The train spawns at
// the first target it is pointing at.  If the train is the target of a button
// or trigger, it will not begin moving until activated.
//
// speed	   default 100
// dmg		default	2
// sounds
// 1) ratchet metal
//=============================================================================

void() hip_train_next;
void() hip_func_train_find;

void() hip_train_use = { // [FUNCTION]
   if (self.think != hip_func_train_find) {
      if (self.velocity != VEC_ORIGIN) return;
   }

   hip_train_next();
};

void() hip_train_wait = { // [FUNCTION]
   if (self.wait ) {
      if (self.noise != "") sound(self,CHAN_VOICE,self.noise,TRUE,ATTN_NORM);
      if (self.wait != -1) {
         self.nextthink = (self.ltime + self.wait);
         self.wait = FALSE;
      }
   } else self.nextthink = (self.ltime + 0.100);

   self.think = hip_train_next;
};

void() hip_train_next = { // [FUNCTION]
   local entity targ;
   local float current;
   local string temp;

   current = self.cnt;
   targ = find (world,targetname,self.target);
   self.cnt = targ.speed;
   self.target = targ.target;
   if (!self.target) objerror("hip_train_next: no next target");

   if (self.noise1 != "") sound(self,CHAN_VOICE,self.noise1,TRUE,ATTN_NORM);
   self.wait = targ.wait;
   if (targ.wait) self.think = hip_train_wait;
   else self.think = hip_train_next;

   if (self.goalentity.event) {
      temp = self.target;
      self.target = self.goalentity.event;
      self.message = self.goalentity.message;
      SUB_UseTargets();
      self.target = temp;
      self.message = "";
   }

   self.goalentity = targ;
   if (current == -1) {
      setorigin(self,(targ.origin - self.mins));
      self.nextthink = (self.ltime + 0.01);
   } else {
      if (current > 0) self.speed = current;
      SUB_CalcMove((targ.origin - self.mins),self.speed,self.think);
   }
};

void() hip_func_train_find = { // [FUNCTION]
   local entity targ;

   if (self.target == "") return; // Do nothing!

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

void() func_train2 = { // [ENTITY]
   if (self.speed <= 0) self.speed = 100.000;
   if (self.target == "") dprint("func_train2 has no target, will not move\n");
   if (self.dmg <= 0) self.dmg = 2;
   if (self.noise == "") {
      if (self.sounds == 0) self.noise = "misc/null.wav";
      if (self.sounds == 1) self.noise = "plats/train2.wav";
   }

   if (self.noise1 == "") {
      if (self.sounds == 0) self.noise1 = "misc/null.wav";
      if (self.sounds == 1) self.noise1 = "plats/train1.wav";
   }

   if (self.noise != "") precache_sound(self.noise);
   if (self.noise1 != "") precache_sound(self.noise1);
   self.cnt = 1;
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

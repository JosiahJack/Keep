//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
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
// Entity count: 3
// Function count: 3
//
// Implements: Lightning Trap
//
// Description:
// Creates lightning traps that can be chained together from ltrail_start to
// multiple ltrail_relay's and finally to an ltrail_end.  Does damage when
// touched.
//=============================================================================

float LT_TOGGLE    = 1.000;
float LT_ACTIVE    = 2.000;

void() ltrail_chain = { // [FUNCTION]
   SUB_UseTargets();
   self.think = SUB_Null;
};

void() ltrail_fire = { // [FUNCTION]
   local entity myTarget;

   if ( (self.classname != "ltrail_end") ) {
      sound (self,CHAN_VOICE,"weapons/lhit.wav",TRUE,ATTN_NORM);
      myTarget = find (world,targetname,self.target);
      WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
      WriteByte (MSG_BROADCAST,TE_LIGHTNING2);
      WriteEntity (MSG_BROADCAST,self);
      WriteCoord (MSG_BROADCAST,self.origin_x);
      WriteCoord (MSG_BROADCAST,self.origin_y);
      WriteCoord (MSG_BROADCAST,self.origin_z);
      WriteCoord (MSG_BROADCAST,myTarget.origin_x);
      WriteCoord (MSG_BROADCAST,myTarget.origin_y);
      WriteCoord (MSG_BROADCAST,myTarget.origin_z);
      LightningDamage(self.origin,myTarget.origin,self,self.currentammo);
   }

   if ( (self.items < time) ) {
      self.think = ltrail_chain;
      self.nextthink = (time + self.frags);
   } else {
      self.think = ltrail_fire;
      self.nextthink = (time + 0.050);
   }
};

void() ltrail_start_fire = { // [FUNCTION]
   if (self.spawnflags & LT_TOGGLE) {
      if (other.classname != "ltrail_end") {
         if (self.spawnflags & LT_ACTIVE) {
            self.spawnflags = (self.spawnflags - LT_ACTIVE);
            return;
         } else self.spawnflags = (self.spawnflags + LT_ACTIVE);
      } else if (!(self.spawnflags & LT_ACTIVE)) return;
   }

   if (self.classname == "ltrail_start") {
      self.items = (time + self.weapon);
      ltrail_fire();
      self.ltrailLastUsed = time;
   } else {
      if (self.classname == "ltrail_relay") {
         self.items = (time + self.weapon);
         ltrail_fire();
      } else {
         self.think = ltrail_chain;
         self.nextthink = (time + self.frags);
      }
   }
};

void() ltrail_start = { // [ENTITY]
   self.ltrailLastUsed = time;
   precache_sound ("weapons/lhit.wav");
   self.movetype = MOVETYPE_NONE;
   self.solid = SOLID_BBOX;
   self.use = ltrail_start_fire;
   if (self.currentammo <= 0) self.currentammo = 25.000;
   if (self.weapon <= 0) self.weapon = 0.300;
   if (self.frags <= FALSE) self.frags = 0.300;
   if (self.spawnflags & LT_ACTIVE) {
      self.items = (time + 100000000.000);
      self.think = ltrail_fire;
      self.nextthink = (time + 0.100);
   }
};

void() ltrail_relay = { // [ENTITY]
   precache_sound ("weapons/lhit.wav");
   self.movetype = MOVETYPE_NONE;
   self.solid = SOLID_BBOX;
   self.use = ltrail_start_fire;
   if (self.currentammo <= 0) self.currentammo = 25.000;
   if (self.weapon <= 0)  self.weapon = 0.300;
   if (self.frags <= FALSE) self.frags = 0.300;
};

void() ltrail_end = { // [ENTITY]
   precache_sound ("weapons/lhit.wav");
   self.movetype = MOVETYPE_NONE;
   self.solid = SOLID_BBOX;
   self.use = ltrail_start_fire;
   if (self.currentammo <= 0) self.currentammo = 25.000;
   if (self.weapon <= 0) self.weapon = 0.300;
   if (self.frags <= 0) self.frags = 0.300;
};

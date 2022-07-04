//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
//
// Attributions: Mission Pack 1 (Hipnotic)
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
// Function count: 3
//
// Implements: Clock 
//
// Description:
// A fully functioning brush-based clock with second, minute, and hour hand.
// As seen on Qmaster's favorite map of all time, the Black Cathedral.  Set
// `count` to specify the time interval.
//=============================================================================

void() clock_setpos = { // [FUNCTION]
   local float pos, ang, seconds;
   local string temp;

   seconds = (time + self.cnt);
   pos = (seconds / self.count);
   pos = (pos - floor (pos));
   ang = (360.000 * pos);
   if ( self.event ) {
      if ( (self.ltime > ang) ) {
         temp = self.target;
         self.target = self.event;
         SUB_UseTargets ();
         self.target = temp;
      }
   }
   self.angles_x = (ang * self.movedir_x);
   self.angles_y = (ang * self.movedir_y);
   self.angles_z = (ang * self.movedir_z);
   RotateTargetsFinal ();
   self.ltime = ang;
};

void() clock_think = { // [FUNCTION]
   clock_setpos ();
   self.nextthink = (time + TRUE);
};

void() clock_firstthink = { // [FUNCTION]
   LinkRotateTargets ();
   self.think = clock_think;
   clock_think ();
};

void() func_clock = { // [ENTITY]
   local vector temp;

	if (!self.target) return;

   self.classname = "clock";
   self.think = clock_firstthink;
   self.nextthink = (time + 0.100);
   self.ltime = time;
   SetMovedir ();
   temp = self.movedir;
   self.movedir_x = (FALSE - temp_y);
   self.movedir_y = (FALSE - temp_z);
   self.movedir_z = (FALSE - temp_x);
   if ( !self.count ) {
      self.count = 60.000;
   }
   self.cnt = (self.cnt * (self.count / 12));
};
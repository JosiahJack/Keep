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
// Function count: 1
//
// Implements: Bobbing Water Brush
//
// Description:
// A nonsolid brush that moves up and down to mimic water...pumping I guess.
//
// Used to emulate water.  To use, create a thin water brush and center it
// on the water line of the body of water to bob.  The amount of the bob
// is the depth of the brush.
//
//"speed" is how long in seconds it takes the brush to do one full bob.
//=============================================================================

void() bobbingwater_think = { // [FUNCTION]
   local vector ang;

   self.count = (self.count + (self.speed * (time - self.ltime)));
   if ( (self.count > 360.000) ) self.count = (self.count - 360.000);
   ang_x = self.count;
   ang_y = FALSE;
   ang_z = FALSE;
   makevectors(ang);
   self.origin_z = (v_forward_z * self.cnt);
   setorigin(self,self.origin);
   self.ltime = time;
   self.nextthink = (time + 0.020);
};

void() func_bobbingwater = { // [ENTITY]
   self.angles = VEC_ORIGIN;
   self.movetype = MOVETYPE_STEP;
   self.solid = SOLID_NOT;
   setmodel(self,self.model);
   self.think = bobbingwater_think;
   self.count = FALSE;
   self.cnt = (self.size_z / FL_SWIM);
   if (self.speed <= 0) self.speed = 4;
   self.speed = (360.000 / self.speed);
   self.nextthink = (time + 0.020);
   self.ltime = time;
};

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
// Function count: 4
//
// Implements: Particle Forcefield
//
// Description:
// An invisible wall that spawns particles within it when triggered.  Used in
// conjunction with a func_oncount to trigger multiple "stripes" of separate
// brushes so that the particles can appear to move across in a wave pattern.
// Also useful for dust effects.
//=============================================================================

float USE_COUNT    = 1.000;

void () particlefield_XZ = { // [FUNCTION]
   local vector pos, start, end;

   if ( ((self.spawnflags & USE_COUNT) && (counter_GetCount (other) != self.cnt)) ) return;

   self.ltime = (time + 0.250);
   if ( self.noise ) sound (self,CHAN_VOICE,self.noise,TRUE,ATTN_NORM);
   if ( !checkclient () ) return ;
   start = (self.dest1 + self.origin);
   end = (self.dest2 + self.origin);
   pos_y = start_y;
   pos_z = start_z;
   while ( (pos_z <= end_z) ) {
      pos_x = start_x;
      while ( (pos_x <= end_x) ) {
         particle (pos,'0 0 0',self.col,self.count);
         pos_x = (pos_x + FL_INWATER);
      }
      pos_z = (pos_z + FL_INWATER);
   }
};

void () particlefield_YZ = { // [FUNCTION]
   local vector pos, start, end;

   if ( ((self.spawnflags & USE_COUNT) && (counter_GetCount (other) != self.cnt)) ) return;

   self.ltime = (time + 0.250);
   if ( self.noise ) sound (self,CHAN_VOICE,self.noise,TRUE,ATTN_NORM);
   if ( !checkclient () ) return;
   start = (self.dest1 + self.origin);
   end = (self.dest2 + self.origin);
   pos_x = start_x;
   pos_z = start_z;
   while ( (pos_z < end_z) ) {
      pos_y = start_y;
      while ( (pos_y < end_y) ) {
         particle (pos,VEC_ORIGIN,self.col,self.count);
         pos_y = (pos_y + FL_INWATER);
      }
      pos_z = (pos_z + FL_INWATER);
   }
};

void () particlefield_XY = { // [FUNCTION]
   local vector pos;
   local vector start;
   local vector end;

   if ( ((self.spawnflags & USE_COUNT) && (counter_GetCount (other) != self.cnt)) ) return;

   self.ltime = (time + 0.250);
   if ( self.noise ) sound (self,CHAN_VOICE,self.noise,TRUE,ATTN_NORM);
   if ( !checkclient () ) return ;
   start = (self.dest1 + self.origin);
   end = (self.dest2 + self.origin);
   pos_x = start_x;
   pos_z = start_z;
   while ( (pos_x < end_x) ) {
      pos_y = start_y;
      while ( (pos_y < end_y) ) {
         particle (pos,VEC_ORIGIN,self.col,self.count);
         pos_y = (pos_y + FL_INWATER);
      }
      pos_x = (pos_x + FL_INWATER);
   }
};

void () particlefield_touch = { // [FUNCTION]
   if ( !self.dmg ) return;
   if ( (time > self.ltime) ) return;
   if ( (time < self.attack_finished) ) return;

   self.attack_finished = (time + 0.500);
   T_Damage (other,self,self,self.dmg,DAMARMOR);
};

void () func_particlefield = { // [ENTITY]
   if ( !self.col ) self.col = 192.000;
   if ( (self.count == FALSE) ) self.count = FL_SWIM;
   self.classname = "particlefield";
   self.solid = SOLID_NOT;
   self.movetype = MOVETYPE_NONE;
   setmodel (self,self.model);
   self.model = string_null;
   self.origin = ((self.mins + self.maxs) * 0.500);
   setorigin (self,self.origin);
   self.dest = ((self.maxs - self.mins) - '16.000 16.000 16.000');
   self.dest1 = ((self.mins + '8.000 8.000 8.000') - self.origin);
   self.dest2 = ((self.maxs + '7.900 7.900 7.900') - self.origin);
   setsize (self,self.mins,self.maxs);
   self.touch = particlefield_touch;
   if ( (self.dest_x > self.dest_z) ) {
      if ( (self.dest_y > self.dest_z) ) {
         self.use = particlefield_XY;
         self.dest1_z = ((self.dest1_z + self.dest2_z) / FL_SWIM);
      } else {
         self.use = particlefield_XZ;
	 self.dest1_y = ((self.dest1_y + self.dest2_y) / FL_SWIM);
      }
   } else {
      if ( (self.dest_y > self.dest_x) ) {
         self.use = particlefield_YZ;
         self.dest1_x = ((self.dest1_x + self.dest2_x) / FL_SWIM);
      } else {
         self.use = particlefield_XZ;
         self.dest1_y = ((self.dest1_y + self.dest2_y) / FL_SWIM);
      }
   }
   if ( self.noise ) precache_sound (self.noise);
   self.ltime = time;
};
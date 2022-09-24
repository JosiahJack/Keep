//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by W. Josiah Jack, aka Qmaster
//
// Attributions: Rogue
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
// Entity count: 5
// Function count: 10
//
// Implements: Earthquake System
//
// Description:
// Causes earthquakes in various ways that can either shake the view or the
// player.
//=============================================================================

float EQ_RANDOM    = 1.000;

void() stop_earthquake;

void() earthquake_rumble = { // [FUNCTION]
   if (self.attack_finished < time) stop_earthquake();
   else {
      sound(self,CHAN_VOICE,"rogue/equake/rumble.wav",TRUE,ATTN_NONE);
      self.think = earthquake_rumble;
      self.nextthink = (time + TRUE);
   }
};

void() start_earthquake = { // [FUNCTION]
   earthquake_active = earthquake_active + (self.weapon * 0.5);
   if (self.spawnflags & EQ_RANDOM)  self.attack_finished = (time + (random () * self.delay));
   else self.attack_finished = (time + self.delay);

   earthquake_rumble();
};

void() stop_earthquake = { // [FUNCTION]
   earthquake_active = 0;
	if (self.targetname) self.use = start_earthquake;
	else self.think = start_earthquake;

   if (self.spawnflags & EQ_RANDOM) self.nextthink = (time + (random () * self.wait));
   else self.nextthink = (time + self.wait);
};

// Rogue Global Earthquake
void() earthquake = { // [ENTITY]
   if ( !self.delay ) self.delay = 20.000;
   if ( !self.wait ) self.wait = 60.000;
   if ( !self.weapon ) self.weapon = 40;
   precache_sound("rogue/equake/rumble.wav");
   earthquake_active = FALSE;
   setsize (self,VEC_ORIGIN,VEC_ORIGIN);
   self.think = stop_earthquake;
   self.nextthink = (time + TRUE);
};

void() info_earthquake = { earthquake(); }; // [ENTITY]

void() earthquake_touch = { // [FUNCTION]
   if (self.delay ) {
      if ( (self.attack_finished < time) ) {
         sound(self,CHAN_VOICE,"rogue/equake/rumble.wav",TRUE,ATTN_NORM);
         self.attack_finished = (time + TRUE);
      }
      if ( (other.classname == "player") ) {
         if ( (other.flags & FL_ONGROUND) ) {
            other.velocity_x = ((other.velocity_x + ((random () * self.weapon) * FL_SWIM)) - self.weapon);
            other.velocity_y = ((other.velocity_y + ((random () * self.weapon) * FL_SWIM)) - self.weapon);
            other.velocity_z = ((other.velocity_z + ((random () * self.weapon) * FL_SWIM)) - self.weapon);
         }
      }
   }
};

void() earthquake_use = { self.delay = !self.delay; }; // [FUNCTION]

// Rogue Local Earthquakes
void() trigger_earthquake = { // [ENTITY]
   precache_sound("rogue/equake/rumble.wav");
   if ( !self.weapon ) self.weapon = 40;
   self.weapon = self.weapon * 0.5;
   self.delay = TRUE;
   self.touch = earthquake_touch;
   if (self.targetname ) {
      self.use = earthquake_use;
      self.delay = FALSE;
   }
   InitTrigger();
};

void() earthquake_kill_touch = { // [FUNCTION]
   local entity eq;

   if (!(other.flags & FL_CLIENT)) return ;

   eq = find (world,classname,"earthquake");
   if ( (eq != world) ) {
      earthquake_active = hipearthquake = FALSE;
      remove (eq);
   }
};

// Stop any of Rogue or Hipnotic Global Earthquakes
void() trigger_earthquake_kill = { // [ENTITY]
   self.touch = earthquake_kill_touch;
   InitTrigger();
};

void() StopEarthQuake = { // [FUNCTION]
   hipearthquake = FALSE;
};

void(float value) EarthQuakeTime = { // [FUNCTION]
   value = (value + time);
   if (value > hipearthquake) hipearthquake = value;
};

// Rogue Earthquake force application.
void() earthquake_prethink = { // [FUNCTION]
   if (earthquake_active == 0) return;
   if (!(self.flags & FL_ONGROUND)) return;

   self.velocity_x = self.velocity_x + (random() * earthquake_active * 2) - earthquake_active;
   self.velocity_y = self.velocity_y + (random() * earthquake_active * 2) - earthquake_active;
   self.velocity_z = self.velocity_z + (random() * earthquake_active * 2) - earthquake_active;
};

// Hipnotic Earthquake force application.
void() earthquake_postthink = { // [FUNCTION]
   if (hipearthquake > time) {
      if (quakeactive == FALSE) {
         sound(self,CHAN_VOICE,"hipnotic/misc/quake.wav",TRUE,ATTN_NONE);
         quakeactive = TRUE;
      }
      if ((self.flags & FL_ONGROUND)) {
         self.velocity = (self.velocity + (random () * '0.000 0.000 150.000'));
      }
   } else {
      if (quakeactive == TRUE) {
         hipearthquake = 0;
         sound(self,CHAN_VOICE,"hipnotic/misc/quakeend.wav",TRUE,ATTN_NONE);
         quakeactive = FALSE;
      }
   }
};

void() hipearthquake_use = { // [FUNCTION]
   EarthQuakeTime (self.dmg);
};

// Hipnotic Earthquake
void() func_earthquake = { // [ENTITY]
   quakeactive = FALSE;
   precache_sound("hipnotic/misc/quake.wav");
   precache_sound("hipnotic/misc/quakeend.wav");
   self.classname = "earthquake";
   self.use = hipearthquake_use;
   self.think = SUB_Null;
   if ( !self.dmg ) self.dmg = 0.800;
};
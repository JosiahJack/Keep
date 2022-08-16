//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
//
// Attributions: Mission Pack 2 (Rogue)
//               pmack sept 96
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
// Entity count: 2
// Function count: 32
//
// Implements: Multi-level Bidirectional Elevator and Its Button
//
// Description:
// This is a moving elevator platform that goes up and down. You can have as
// many levels (stop points) as you want but they must be all the same distance
// away. Must use special elevator button entity as the trigger.  The elevator
// button is set to either be an up button to move the elevator up a level or a
// down button to move the elevator down a level.  Elevator moves and stops at
// next level unless it is at the top or bottom, then only the opposite
// direction button will cause it to move.
//=============================================================================

float ELVTR_DOWN = 1; // Flag to indicate whether this button is the button for up or down.
float DN_N_WAIT    = 1.000;
float PLT_TOGGLE    = 2.000;
float ELEVATOR    = 4.000;
float START_AT_TOP    = 8.000;
float PLAT2    = 16.000;
float PLAT2_BOTTOM    = 32.000;

void() dn_and_wait_go_up;
void() dn_and_wait_go_down;
void() dn_and_wait_crush;
void() toggle_go_up;
void() toggle_go_down;
void() toggle_crush;
void() elvtr_crush;
void() plat2_center_touch;
void() plat2_go_up;
void() plat2_go_down;
void() plat2_crush;
void() elvtr_button_wait;
void() elvtr_button_return;

void() elvtr_button_wait = { // [FUNCTION]
	self.lefty = 0;
	if (self.spawnflags & ELVTR_DOWN) self.lefty = -1;
	else self.lefty = 1;
		
	self.state = STATE_TOP;
	self.nextthink = self.ltime + self.wait;
	self.think = elvtr_button_return;
	activator = self.enemy;
	SUB_UseTargets();
	self.frame = 1; // use alternate textures
};

void() elvtr_button_done = { self.state = STATE_BOTTOM; }; // [FUNCTION]

void() elvtr_button_return = { // [FUNCTION]
	self.state = STATE_DOWN;
	SUB_CalcMove (self.pos1, self.speed, elvtr_button_done);
	self.frame = 0; // use normal textures
	if (self.health) self.takedamage = DAMAGE_YES;	// can be shot again
};

void() elvtr_button_blocked = {}; // [FUNCTION], Do nothing, just don't come all the way back out.

void() elvtr_button_fire = { // [FUNCTION]
	if (self.state == STATE_UP || self.state == STATE_TOP) return;

	sound(self,CHAN_VOICE, self.noise,1,ATTN_NORM);
	self.state = STATE_UP;
	SUB_CalcMove (self.pos2, self.speed, elvtr_button_wait);
};

void() elvtr_button_use = { self.enemy = activator; elvtr_button_fire(); }; // [FUNCTION]

void() elvtr_button_touch = { // [FUNCTION]
	if (other.classname != "player") return;

	self.enemy = other;
	elvtr_button_fire();
};

void() elvtr_button_killed = { // [FUNCTION]
	self.enemy = damage_attacker;
	self.health = self.max_health;
	self.takedamage = DAMAGE_NO;	// wil be reset upon return
	elvtr_button_fire();
};

// QUAKED func_elvtr_button (0 .5 .8) ? ELVTR_DOWN
// ELEVATOR BUTTON ONLY!  When a button is touched, it moves some distance in the direction of it's angle, triggers all of it's targets, waits some time, then returns to it's original position where it can be triggered again.
// ELVTR_DOWN causes this to be a DOWN button.  Default is UP.
// "angle"		determines the opening direction
// "target"	all entities with a matching targetname will be used
// "speed"		override the default 40 speed
// "wait"		override the default 1 second wait (-1 = never return)
// "lip"		override the default 4 pixel lip remaining at end of move
// "health"	if set, the button must be killed instead of touched
// "sounds"
// 0) steam metal
// 1) wooden clunk
// 2) metallic click
// 3) in-out
void() func_elvtr_button = { // [ENTITY]
	if (self.noise == "") {
		if (self.sounds == 0) self.noise = "buttons/airbut1.wav";
		else if (self.sounds == 1) self.noise = "buttons/switch21.wav";
		else if (self.sounds == 2) self.noise = "buttons/switch02.wav";
		else if (self.sounds == 3) self.noise = "buttons/switch04.wav";
	}
	precache_sound(self.noise);
	SetMovedir();
	self.movetype = MOVETYPE_PUSH;
	self.solid = SOLID_BSP;
	setmodel(self, self.model);
	self.blocked = elvtr_button_blocked;
	self.use = elvtr_button_use;
	if (self.health) {
		self.max_health = self.health;
		self.th_die = elvtr_button_killed;
		self.takedamage = DAMAGE_YES;
	} else self.touch = elvtr_button_touch;

	if (!self.speed) self.speed = 40;
	if (!self.wait) self.wait = 1;
	if (!self.lip) self.lip = 4;
	self.state = STATE_BOTTOM;
	self.pos1 = self.origin;
	self.pos2 = self.pos1 + self.movedir*(fabs(self.movedir*self.size) - self.lip);
};

void() dn_and_wait_hit_top = { // [FUNCTION]
	sound(self,CHAN_VOICE,self.noise1,1,ATTN_NORM);
	self.state = STATE_TOP;
};

void() dn_and_wait_hit_bottom = { // [FUNCTION]
	sound(self,CHAN_VOICE,self.noise1,1,ATTN_NORM);
	self.state = STATE_BOTTOM;
	self.think = dn_and_wait_go_up;
	self.nextthink = self.ltime + self.health;
};

void() dn_and_wait_go_down = { // [FUNCTION]
	sound(self,CHAN_VOICE, self.noise,1,ATTN_NORM);
	self.state = STATE_DOWN;
	SUB_CalcMove (self.pos2, self.speed, dn_and_wait_hit_bottom);
};

void() dn_and_wait_go_up = { // [FUNCTION]
	sound(self,CHAN_VOICE, self.noise,1,ATTN_NORM);
	self.state = STATE_UP;
	SUB_CalcMove (self.pos1, self.speed, dn_and_wait_hit_top);
};

void() dn_and_wait_crush = { // [FUNCTION]
	T_Damage(other, self, self, 1,DAMARMOR);
	if (self.state == STATE_UP) dn_and_wait_go_down();
	else if (self.state == STATE_DOWN) dn_and_wait_go_up();
};

void() dn_and_wait_use = { // [FUNCTION]
	if (self.state != STATE_TOP) return;
	
	dn_and_wait_go_down();
};

void() toggle_hit_top = { // [FUNCTION]
	dprint("new plat(toggle) hit top at ");
	dprint(vtos(self.origin));
	dprint("\n");
	sound(self,CHAN_VOICE, self.noise1,1,ATTN_NORM);
	self.state = STATE_TOP;
};

void() toggle_hit_bottom = { // [FUNCTION]
	dprint("new plat(toggle) hit bottom at ");
	dprint(vtos(self.origin));
	dprint("\n");
	sound(self,CHAN_VOICE, self.noise1,1,ATTN_NORM);
	self.state = STATE_BOTTOM;
};

void() toggle_go_down = { // [FUNCTION]
	dprint("new plat(toggle) go down to");
	dprint(vtos(self.pos2));
	dprint("\n");
	sound(self,CHAN_VOICE, self.noise,1,ATTN_NORM);
	self.state = STATE_DOWN;
	SUB_CalcMove (self.pos2, self.speed, toggle_hit_bottom);
};

void() toggle_go_up = { // [FUNCTION]
	dprint("new plat(toggle) go up to ");
	dprint(vtos(self.pos1));
	dprint("\n");
	sound(self,CHAN_VOICE, self.noise,1,ATTN_NORM);
	self.state = STATE_UP;
	SUB_CalcMove(self.pos1,self.speed,toggle_hit_top);
};

void() toggle_crush = { // [FUNCTION]
	dprint("new plat(toggle) crush\n");
	T_Damage(other, self, self, 1, DAMARMOR);
	if (self.state == STATE_UP) toggle_go_down();
	else if (self.state == STATE_DOWN) toggle_go_up();
};

void() toggle_use = { // [FUNCTION]
	dprint("new plat(toggle) used and at ");
	dprint(vtos(self.origin));
	dprint("\n");
	if (self.state == STATE_TOP) toggle_go_down();
	else if (self.state == STATE_BOTTOM) toggle_go_up();
};

void() elvtr_stop = { // [FUNCTION]
	self.elevatorOnFloor = self.elevatorToFloor;
	sound(self,CHAN_VOICE, self.noise1,1,ATTN_NORM);
	self.state = STATE_BOTTOM;
	self.elevatorLastUse = time;
};

void() elvtr_go = { // [FUNCTION]
	local vector pos;

	pos = self.pos2;
	pos_z = self.pos2_z + (self.height * self.elevatorToFloor);
	sound(self,CHAN_VOICE,self.noise,1,ATTN_NORM);
	self.state = STATE_UP;
	SUB_CalcMove(pos,self.speed,elvtr_stop);
	self.elevatorLastUse = time;
};

void() elvtr_crush = { // [FUNCTION]
	self.elevatorToFloor = self.elevatorOnFloor;
	elvtr_go();
};

// self = plat, other = elevator button, other.enemy = player
void() elvtr_use = { // [FUNCTION]
	local float	tempDist, elvPos, btnPos;
	
	if ((self.elevatorLastUse + 2) > time) return;
	
	self.elevatorLastUse = time;
	if (self.lefty == 0) return;

	elvPos = (self.absmin_z + self.absmax_z) * 0.5;
	btnPos = (other.absmin_z + other.absmax_z) * 0.5;
	if (elvPos > btnPos) {
		tempDist = (elvPos - btnPos) / self.height;
		tempDist = ceil ( tempDist);
		self.elevatorToFloor = self.elevatorOnFloor - tempDist;
		elvtr_go();
		return;
	} else {
		tempDist = btnPos - elvPos;
		if (tempDist > self.height) {
			tempDist = tempDist / self.height;
			tempDist = floor ( tempDist );
			self.elevatorToFloor = self.elevatorOnFloor + tempDist;
			elvtr_go();
			return;
		}
	}
		
	if (self.lefty == -1) {	
		if (self.elevatorOnFloor > 0) {
			self.elevatorToFloor = self.elevatorOnFloor - 1;
			elvtr_go();
		}
	} else if (self.lefty == 1) {
		if (self.elevatorOnFloor < (self.cnt - 1)) {
			self.elevatorToFloor = self.elevatorOnFloor + 1;
			elvtr_go();
		}
	}
};

void() plat2_spawn_inside_trigger = { // [FUNCTION]
	local entity trigger;
	local vector tmin, tmax;

	// middle trigger
	trigger = spawn();
	trigger.touch = plat2_center_touch;
	trigger.movetype = MOVETYPE_NONE;
	trigger.solid = SOLID_TRIGGER;
	trigger.enemy = self;
	tmin = self.mins + '25 25 0';
	tmax = self.maxs - '25 25 -8';
	tmin_z = tmax_z - (self.pos1_z - self.pos2_z + 8);
	if (self.spawnflags & PLAT_LOW_TRIGGER) tmax_z = tmin_z + 8;
	if (self.size_x <= 50) {
		tmin_x = (self.mins_x + self.maxs_x) / 2;
		tmax_x = tmin_x + 1;
	}

	if (self.size_y <= 50) {
		tmin_y = (self.mins_y + self.maxs_y) / 2;
		tmax_y = tmin_y + 1;
	}
	
	setsize (trigger, tmin, tmax);
};

void() plat2_hit_top = { // [FUNCTION]
	sound(self,CHAN_VOICE, self.noise1,1,ATTN_NORM);
	self.state = STATE_TOP;
	self.plat2LastMove = time;
	if (self.plat2Called == 1) {
		self.think = plat2_go_down;
		self.nextthink = self.ltime + 1.5;
		self.plat2Called = 0;
		self.plat2LastMove = 0; // allow immediate move
	} else if (!(self.spawnflags & START_AT_TOP)) {
		self.think = plat2_go_down;
		self.nextthink = self.ltime + self.delay;
		self.plat2Called = 0;
	}
};

void() plat2_hit_bottom = { // [FUNCTION]
	sound(self,CHAN_VOICE, self.noise1,1,ATTN_NORM);
	self.state = STATE_BOTTOM;
	self.plat2LastMove = time;
	if (self.plat2Called == 1) {
		self.think = plat2_go_up;
		self.nextthink = self.ltime + 1.5;
		self.plat2Called = 0;
		self.plat2LastMove = 0; // allow immediate move
	} else if (self.spawnflags & START_AT_TOP) {	
		self.think = plat2_go_up;
		self.nextthink = self.ltime + self.delay;
		self.plat2Called = 0;
	}
};

void() plat2_go_down = { // [FUNCTION]
	sound(self,CHAN_VOICE, self.noise,1,ATTN_NORM);
	self.state = STATE_DOWN;
	SUB_CalcMove (self.pos2, self.speed, plat2_hit_bottom);
};

void() plat2_go_up = { // [FUNCTION]
	sound(self,CHAN_VOICE, self.noise,1,ATTN_NORM);
	self.state = STATE_UP;
	SUB_CalcMove (self.pos1, self.speed, plat2_hit_top);
};

void() plat2_use = { // [FUNCTION]
	if (self.state > 4) self.state = self.state - 10;	
	self.use = SUB_Null;
};

void() plat2_center_touch = { // [FUNCTION]
	local float	otherState;
	local vector platPosition;

	if (other.classname != "player") return;
	if (other.health <= 0) return;

	self = self.enemy; // At this point, self is the trigger. self.enemy is the plat.  This changes self to be the plat, other is the player.
	if ((self.plat2LastMove + 2) > time) return;
	if (self.state > 4)	return; // Disabled.
		
	if (self.plat2GoTo > STATE_BOTTOM) {
		if (self.plat2GoTime < time) {
			if (self.plat2GoTo == STATE_UP) plat2_go_up();		
			else plat2_go_down();
				
			self.plat2GoTo = 0;
		}
		return;
	}
	if (self.state > STATE_BOTTOM) return; // STATE_UP or STATE_DOWN

	platPosition = (self.absmax + self.absmin) * 0.5;
	if (self.state == STATE_TOP) {
		otherState = STATE_TOP;
		if ( platPosition_z > other.origin_z )
			otherState = STATE_BOTTOM;
	} else {
		otherState = STATE_BOTTOM;
		if ( (other.origin_z - platPosition_z) > self.height) otherState = STATE_TOP;
	}	

	if (self.state == otherState) {
		self.plat2Called = 0;
		self.plat2GoTime = time + 0.5;
	} else {
		self.plat2GoTime = time + 0.1;
		self.plat2Called = 1;
	}	

	if (self.state == STATE_BOTTOM) self.plat2GoTo = STATE_UP;
	else if (self.state == STATE_TOP) self.plat2GoTo = STATE_DOWN;
};

void() plat2_crush = { // [FUNCTION]
	T_Damage(other, self, self, 1, DAMARMOR);
	if (self.state == STATE_UP) plat2_go_down();
	else if (self.state == STATE_DOWN) plat2_go_up();
};


// QUAKED func_new_plat (0 .5 .8) ? DN_N_WAIT PLT_TOGGLE ELEVATOR START_AT_TOP PLAT2 P2_BOTTOM
// DN_N_WAIT is a plat that starts at the top and when triggered, goes down, waits, then comes back up.
// health - number of seconds to wait (default 5)
// PLT_TOGGLE is a plat that will change between the top and bottom each time it is triggered.
// cnt is the number of floors
// height is the distance between floors.  If you don't want to bother figuring out the height, don't put a value in the height.  If the "height" key is set, that will determine the amount the plat moves, instead of being implicitly determined by the model's height.
// START_AT_TOP is an optional flag for elevators. It just tells the elevator that it's position is the top floor. (Default is the bottom floor) USE THIS ONLY WITH ELEVATORS!
// PLAT2 is a fixed version of the original plat. If you want the plat to start at the bottom and move to the top on demand, use a negative height. That will tell Quake to lower the plat at spawn time. Always place this plat type in the top position when making the map. This will ensure correct lighting, hopefully. If a plat2 is the target of a trigger, it will be disabled until it has been triggered. Delay is the wait before the plat returns to original position.
// delay		default 3
// speed		default 150
// cnt			default 2
// P2_BOTTOM is an optional switch to have an auto-sized plat2 start at the bottom.
// Plats are always drawn in the extended position, so they will light correctly.  If the plat is the target of another trigger or button, it will start out disabled in the extended position until it is trigger, when it will lower and become a normal plat.
// Set "sounds" to one of the following:
// 1) base fast
// 2) chain slow
void() func_new_plat = { // [ENTITY]
   local float negativeHeight;

   negativeHeight = FALSE;
   if ( !self.t_length ) self.t_length = 80;
   if ( !self.t_width ) self.t_width = 10;
   if ( (self.sounds == 0) ) self.sounds = 2;
   if ( (self.sounds == 1) ) {
      self.noise = "plats/plat1.wav";
      self.noise1 = "plats/plat2.wav";
   }
   if ( (self.sounds == 2) ) {
      self.noise = "plats/medplat1.wav";
      self.noise1 = "plats/medplat2.wav";
   }
   precache_sound(self.noise);
   precache_sound(self.noise1);
   self.mangle = self.angles;
   self.angles = VEC_ORIGIN;
   self.classname = "plat";
   self.solid = SOLID_BSP;
   self.movetype = MOVETYPE_PUSH;
   self.bsporigin = TRUE;
   self.classtype = CT_FUNCPLAT;
   self.classgroup = CG_FUNCMOVER;
   setorigin(self,self.origin);
   setmodel(self,self.model);
   setsize (self,self.mins,self.maxs);
   if (self.speed <= 0) self.speed = 150;
   self.pos1 = self.origin;  // pos1 is the top position,
   self.pos2 = self.origin;  // pos2 is the bottom
   if ( (self.height < 0) ) {
      negativeHeight = TRUE;
      self.height = (0 - self.height);
   }

   if (self.height) self.pos2_z = (self.origin_z - self.height);
   else {
      negativeHeight = TRUE;
      self.height = (self.size_z - 8);
      self.pos2_z = (self.origin_z - self.height);
   }

   if ( (self.spawnflags & DN_N_WAIT) ) {
      self.use = dn_and_wait_use;
      self.blocked = dn_and_wait_crush;
      if ( (negativeHeight == TRUE) ) {
         self.state = STATE_BOTTOM;
         setorigin(self,self.pos2);
      } else self.state = STATE_TOP;

      if (!self.health) self.health = 5;
   } else {
      if ( (self.spawnflags & PLT_TOGGLE) ) {
         self.use = toggle_use;
         self.blocked = toggle_crush;
         if ( (negativeHeight == TRUE) ) {
            setorigin(self,self.pos2);
            self.state = STATE_BOTTOM;
         } else {
            self.state = STATE_TOP;
         }
      } else {
         if ( (self.spawnflags & ELEVATOR) ) {
            self.elevatorOnFloor = FALSE;
            self.elevatorToFloor = FALSE;
            self.elevatorLastUse = FALSE;
            if ( (self.spawnflags & START_AT_TOP) ) {
               self.pos1 = self.origin;
               self.pos2 = self.origin;
               self.pos2_z = (self.origin_z - (self.height * (self.cnt - TRUE)));
               self.elevatorOnFloor = (self.cnt - TRUE);
            } else {
               self.pos1 = self.origin;
               self.pos2 = self.origin;
               self.pos1_z = (self.origin_z + (self.height * (self.cnt - TRUE)));
               self.elevatorOnFloor = FALSE;
            }
            self.use = elvtr_use;
            self.blocked = elvtr_crush;
         } else {
            if ( (self.spawnflags & PLAT2) ) {
               plat2_spawn_inside_trigger();
               self.plat2Called = FALSE;
               self.plat2LastMove = FALSE;
               self.plat2GoTo = FALSE;
               self.plat2GoTime = FALSE;
               self.blocked = plat2_crush;
               if ( !self.delay ) self.delay = 3;
               if ( (negativeHeight == TRUE) ) {
                  self.state = STATE_BOTTOM;
                  self.spawnflags = PLAT2;
                  setorigin(self,self.pos2);
               } else {
                  self.spawnflags = (self.spawnflags | START_AT_TOP);
                  self.state = STATE_TOP;
               }
               if (self.targetname) {
                  self.use = plat2_use;
                  self.state = (self.state + MOVETYPE_BOUNCE);
               }
            }
         }
      }
   }
};
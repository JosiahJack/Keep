//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
//
// Attributions: Arcane Dimensions (AD) and ID1
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
// Function count: 23
//
// Implements: Doors (func_door)
//
// Description:
// Moving brush models intended for use as doors.  Very useful for all sorts of
// things from breakaway floors, crushing ceilings, spike traps, platforms,
// elevators, pushers, crushers, decorative movers, buttons, shootable buttons,
// shootable destroyable walls, moving walls, crushing walls, etc.  Go wild.
//
// This entity moves between a start point and an end point, can wait before
// closing, can "toggle" to stay put at either end, can only ever open once
// (wait of -1), can have health to be shootable, and can start open... just to
// name a few
//
// Can also require a key and can display messages when locked or need a key.
//=============================================================================

float DOOR_START_OPEN = 1;		// Work the opposite way around
float DOOR_SPAWN_TRIGGER = 2;	// Spawn open trigger regardless of targetname
float DOOR_DONT_LINK = 4;		// never link this door with anything
float DOOR_GOLD_KEY = 8;		// Gold Key
float DOOR_SILVER_KEY = 16;		// Silver Key
float DOOR_TOGGLE = 32;			// Need trigger to open AND close

// Check for overlapping bound boxes
float (entity e1, entity e2) EntitiesTouching = { // [FUNCTION]
	if (e1.mins_x > e2.maxs_x) return FALSE;
	if (e1.mins_y > e2.maxs_y) return FALSE;
	if (e1.mins_z > e2.maxs_z) return FALSE;
	if (e1.maxs_x < e2.mins_x) return FALSE;
	if (e1.maxs_y < e2.mins_y) return FALSE;
	if (e1.maxs_z < e2.mins_z) return FALSE;
	return TRUE;
};

void() func_door_trigger_touch = { // [FUNCTION]
	if (self.owner.estate == ESTATE_BLOCK) return;
	if (self.owner.spawnflags & ENT_STARTOFF) return;
	if (other.health < 1) return;
	if (other.classtype == CT_FUNCBREAK) return;
	if (other.flags & FL_ITEM) return;
	if (time < self.attack_finished) return;

	self.attack_finished = time + 1;
	activator = other; // Switch to parent (self) of trigger
	self = self.owner;
	self.estate_use(); // func_door_use
};

entity(vector fmins, vector fmaxs) func_door_spawn_field = { // [FUNCTION]
	local entity trigger;

	trigger = spawn(); // Create trigger entity and link to parent (self)
	trigger.classtype = CT_FUNCDOORTRIG;
	trigger.bsporigin = TRUE;
	trigger.movetype = MOVETYPE_NONE;
	trigger.solid = SOLID_TRIGGER;
	trigger.owner = self;
	trigger.touch = func_door_trigger_touch;
	setsize (trigger, fmins + self.bbmins, fmaxs + self.bbmaxs); // Return the trigger entity to the previous function.   Extend the X/Y size of the trigger +/- 60 units.  Allow for custom sizes defined with bbmins/bbmaxs.
	return (trigger);
};

void() func_door_angletarget = { // [FUNCTION]
	TargetMovedir(self,TRUE); // Use sub function and return movetarget/dest1 values
	self.dest2 = self.oldorigin; // Need to use original spawn location because block functionality will have the func_door in between state positions (origin).
	if (self.height) { // Check for height plat movement system instead
		self.dest2 = self.dest2 - (self.size*0.5); // Convert self dest2 to func_train corner bottom left offset)
		self.movedir = normalize(self.dest1 - self.dest2); // re-calculate the movedir (bec of self origin is different), dest1 should be setup in TargetMovedir function
		self.pos2 = self.pos1 + (self.movedir * self.height); // Simple movement along vector length (no lip changes).  Not easy to predict in the editor because its the long side of a trangle (other corners are func_door/angletarget).
	} else self.pos2 = self.pos1 + (self.dest1 - self.dest2) + (self.size*0.5); // Work out destination (using func_train bottom left offset)	
};

void() func_door_final_setup = { // [FUNCTION]
	// Any angletarget entity key defined?
	if (self.angletarget != "") {
		func_door_angletarget(); // Upate second position based on angletarget
		if (self.midstart > 0) {
			setorigin (self, self.pos2); // Mid start requires second position in between start and end.
			self.state = STATE_TOP;
		}
	}
	
	if (self.spawnflags & ENT_STARTOFF) self.estate_off(); // Switch off the entity once setup has finished
};

// Link touching func_door entities....very annoying for new and old mappers alike!
// For some reason the original renamed doors and secret doors to the same classname string and created a list of both together.
// Not sure why anyone would want the two door types linked and it is certainly not in any of the original ID maps.
// Feature disabled - causes no end of state problems.
void() func_door_link = { // [FUNCTION]
	local entity linkdoor, master;
	local vector cmins, cmaxs;
	local float loopcondition;

	self.think = func_door_final_setup;
	self.nextthink = self.ltime + 0.1;
	if (self.enemy) return; // Door linking exceptions (self.enemy = already linked)

	cmins = self.mins; cmaxs = self.maxs; // Setup bounding box for first door (master)
	loopcondition = TRUE; // lets give the do/while a proper exit condition
	master = self; // Really important step, defining the master door
	linkdoor = self;
	while (loopcondition)  {
		self.owner = master; // Always point all doors in the list to the master door which is setup outside of the do/while loop
		if (self.health) master.health = self.health; // Make sure all linked doors have the same health/targetname/message
		if (self.targetname != "") master.targetname = self.targetname; // This is what causes all those woes of random doors opening for new mappers.  Sigh.
		if (self.message != "") master.message = self.message;
		linkdoor = find (linkdoor, classname, self.classname);
		if (!linkdoor) { // reached end of list?
			self.enemy = master;	// make the chain a loop
			loopcondition = FALSE;
			self = self.owner; // no more doors left to search, switch to the master door, it is always defined as the .owner field
			if (self.health == 0 && self.items == 0) { // Conditions for a automatic door open trigger.
				// Annoying that the targetname is being used like this because there could have been a better way to do this type of functionality.
				// == "" door has special trigger around to open door
				// != "" door requires trigger event to open
				if (self.targetname == "") self.spawnflags = self.spawnflags | DOOR_SPAWN_TRIGGER; 
				if (self.spawnflags & DOOR_SPAWN_TRIGGER) self.owner.trigger_field = func_door_spawn_field(cmins, cmaxs);
			}
		} else {
			// Check if the bounding boxes are touching
			if (EntitiesTouching(self,linkdoor)) {
				if (linkdoor.enemy) { // The .enemy field should be empty, otherwise its linked already which is a bad situation because the chains will be corrupt
					if ( !(linkdoor.spawnflags & DOOR_DONT_LINK)) {  // Exception: No link doors are setup to be linked to themselves!
						dprint("\b[CROSSLINK]\b really bad situation, must fix!\n");
						dprint("--------!----------------!-----------!---------\n");
						dprint(linkdoor.enemy.classname); 
						dprint("-!----------------!---!-------------------!----\n\n");
					} // Cross link will break the lots of later functions on.  Solution - ignore the crosslink entity and carry on.
				} else {
					self.enemy = linkdoor; // Setup the next entity (linkdoor) in the list (self.enemy) and move self forward to the new entity (linkdoor)
					self = linkdoor;
					if (linkdoor.mins_x < cmins_x) cmins_x = linkdoor.mins_x; // Expand touch trigger to include new door...and much much more...stupid engine.
					if (linkdoor.mins_y < cmins_y) cmins_y = linkdoor.mins_y;
					if (linkdoor.mins_z < cmins_z) cmins_z = linkdoor.mins_z;
					if (linkdoor.maxs_x > cmaxs_x) cmaxs_x = linkdoor.maxs_x;
					if (linkdoor.maxs_y > cmaxs_y) cmaxs_y = linkdoor.maxs_y;
					if (linkdoor.maxs_z > cmaxs_z) cmaxs_z = linkdoor.maxs_z;
				}
			}
		}
	}
};

// Phase 4 - Door CLOSED
void() func_door_hit_bottom = { // [FUNCTION]
	if (self.midstart) self.midstart = FALSE; // Always reset midstart flag (its not longer needed)
	if (self.estate == ESTATE_OFF) return;

	sound (self, CHAN_VOICE, self.noise1, self.volume, ATTN_NORM);
	self.state = STATE_BOTTOM;
	self.frame = 1 - self.frame;	//switch textures
};

// Phase 3 - Door closing
void() func_door_go_down = { // [FUNCTION]
	if (self.estate == ESTATE_OFF) return;

	if (self.max_health) {
		self.takedamage = DAMAGE_YES;
		self.health = self.max_health;
	}
	self.state = STATE_DOWN;
	sound (self, CHAN_VOICE, self.noise2, self.volume, ATTN_NORM);
	SUB_CalcMove (self.pos1, self.yaw_speed, func_door_hit_bottom); // Add - return speed can now be different, yaw_speed = speed if nothing defined
};

// Phase 2 - Door OPEN
void() func_door_hit_top = { // [FUNCTION]
	if (self.estate == ESTATE_OFF) return;

	sound (self, CHAN_VOICE, self.noise1, self.volume, ATTN_NORM);
	self.state = STATE_TOP;
	if (self.spawnflags & DOOR_TOGGLE) return; // don't come down automatically

	self.think = func_door_go_down;
	self.nextthink = self.ltime + self.wait;
};

// Phase 1 - Door opening
void() func_door_go_up = { // [FUNCTION]
	if (self.estate == ESTATE_OFF) return;
	if (self.state == STATE_UP) return;		// already going up
	if (self.state == STATE_TOP) { self.nextthink = self.ltime + self.wait; return; } // reset top wait time

	if (self.angletarget != "") func_door_angletarget(); // Check for custom movement using angletarget (entity target)
	sound (self, CHAN_VOICE, self.noise2, self.volume, ATTN_NORM);
	self.state = STATE_UP;
	SUB_CalcMove (self.pos2, self.speed, func_door_hit_top);
	SUB_UseTargets();
	self.frame = 1 - self.frame;	//switch textures
};

void() func_door_fire = { // [FUNCTION]
	local entity oself, starte;
	
	if (self.estate == ESTATE_BLOCK) return;

	if (self.owner != self) dprint ("\b[door_fire]\b self.owner != self\n");
	oself = starte = self; // Save for later (linked doors)
	if (self.midstart > 0) { // Check for mid start setup (waiting at pos2)
		do { // trigger all paired doors
			if (self.state != STATE_DOWN) func_door_go_down (); // Don't keep re-triggering midstart doors.  Let the door reset back to pos1 (start position).
			self = self.enemy;
			if (self == world) self = starte; // Prevent endless world loops
		} while ( self != starte );
		self = oself;
		return;
	}

	if (other.classtype == CT_TRIGDOORSTATE) { // Check for exact state requests
		if (other.state == 0) {
			if (self.state == STATE_DOWN || self.state == STATE_BOTTOM) return; // Is the door closing (DOWN) or closed (BOTTOM)?
		} else {
			if (self.state == STATE_UP || self.state == STATE_TOP) return; // Is the door opening (UP) or open (TOP)?
		}
	}

	if (self.items) sound (self, CHAN_VOICE, self.noise4, self.volume, ATTN_NORM); // play use key sound
	self.message = string_null;		// no more message
	if (self.spawnflags & DOOR_TOGGLE) {
		if (self.state == STATE_UP || self.state == STATE_TOP) {
			starte = self; // Reset
			do {
				func_door_go_down ();
				self = self.enemy;
				if (self == world) self = starte; // Prevent endless world loops
			} while ( self != starte );
			self = oself;
			return;
		}
	}
	
	starte = self; // Reset
	do { // trigger all paired doors
		func_door_go_up ();
		self = self.enemy;
		if (self == world) self = starte; // Prevent endless world loops
	} while (self != starte);
	self = oself;
};

void() func_door_use = { // [FUNCTION]
	local entity oself;

	if (self.spawnflags & ENT_STARTOFF) self.estate_on(); // Deal with STARTOFF functionality first
	else {
		if (self.estate & ESTATE_BLOCK) return; // Block USE functionality if state wrong
		
		self.message = string_null;	// Door messages are for touch functionality ONLY		
		self.owner.message = string_null;	
		self.enemy.message = string_null;
		oself = self;
		self = self.owner; // Switch to master door
		func_door_fire ();
		self = oself;
	}
};

void() func_door_killed = { // [FUNCTION]
	local entity oself;

	if (self.estate & ESTATE_BLOCK) return;
	
	oself = self;
	self = self.owner;
	self.health = self.max_health;
	self.takedamage = DAMAGE_NO;	// wil be reset upon return
	func_door_use ();
	self = oself;
};

void(float itemset, float taken, entity e, float used) key_message = {
	if (used) { // Key was used, let's say which one and tell the player that the key has been removed.
		if (itemset == 0) { // Currently only keys stored in self.items and self.moditems.  No need to check the other two inventory banks.
			if (!self.persistentkey) sprint(e, "You used the "); 
			if (taken == IT_KEY1) sprint(e, "Silver key");
			else sprint(e, "Gold key");
			if (self.persistentkey) sprint(e, " was kept after use!\n");
			sprint(e, "\n");
		} else if (itemset == 1) {
			if (!self.persistentkey) sprint(e, "You used the "); 
			if (taken == IT2_KEY_SKELETON) sprint(e, "Skeleton key");
			else sprint(e,"key"); // We don't know what it was, but it had to be a key of some sort.
			if (self.persistentkey) sprint(e, " was kept after use!\n");
			sprint(e, "\n");
		} else if (itemset == 2) {
			if (!self.persistentkey) sprint(e, "You used the ");
			if (taken == IT_CKEY1 && e.ckeyname1 != "") sprint(e, e.ckeyname1); // Use the key item netname to reference the custom key.  These netnames are updated when picking up the key.
			else if (taken == IT_CKEY2 && e.ckeyname2 != "") sprint(e, e.ckeyname2);
			else if (taken == IT_CKEY3 && e.ckeyname3 != "") sprint(e, e.ckeyname3);
			else if (taken == IT_CKEY4 && e.ckeyname4 != "") sprint(e, e.ckeyname4);
			else sprint(e,"key"); // We don't know what it was, but it had to be a key of some sort.
			if (self.persistentkey) sprint(e, " was kept after use!\n");
			sprint(e, "\n");
		}
	} else { // Locked, let's say what we need to go find to open this.
		if (itemset == 2) centerprint(e,self.message2); // Custom key needed message.  Use the message2 string instead of message1.
		else if (itemset == 0) { // Standard gold or silver key needed.
			if (taken == IT_KEY1) {
				if (self.message2 != "") centerprint(e, self.message2);
				else if (self.worldtype == 1) centerprint(e, "You need the silver runekey");
				else if (self.worldtype == 2) centerprint(e, "You need the silver keycard");
				else centerprint (e, "You need the silver key");
			} else {
				if (self.message2 != "") centerprint (e, self.message2);
				else if (self.worldtype == 1) centerprint(e, "You need the gold runekey");
				else if (self.worldtype == 2) centerprint(e, "You need the gold keycard");
				else centerprint(e, "You need the gold key");
			}
		}
	}
};

void(void() th_activate, entity attempter) keyuser_attempt = {
	local float keytake, itemset;

	if (self.items == 0) { // Does the door require any keys?
		if (self.owner.message != "") { // Any touch message to display?
			centerprint (attempter, self.owner.message);
			sound(attempter, CHAN_VOICE, self.noise, self.volume, ATTN_NORM); // Use custom lock sound (default = talktalk)
		}
	} else { // Check door for keys (silver/gold/custom)
		if (self.customkey == 5) { // Handle support for 'Any Key' option.  Itemset 0 = self.items, 1 = self.items2, 2 = self.moditems, 3 = self.perms
			keytake = 0;
			if (attempter.items & IT_KEY1) { keytake = IT_KEY1; itemset = 0; } // Start with weakest/lowest-value key and use it first if present.
			else if (attempter.items & IT_KEY2) { keytake = IT_KEY2; itemset = 0; }
			else if (attempter.moditems & IT_CKEY1) { keytake = IT_CKEY1; itemset = 2; }
			else if (attempter.moditems & IT_CKEY2) { keytake = IT_CKEY2; itemset = 2; }
			else if (attempter.moditems & IT_CKEY3) { keytake = IT_CKEY3; itemset = 2; }
			else if (attempter.moditems & IT_CKEY4) { keytake = IT_CKEY4; itemset = 2; }
			else if (attempter.items2 & IT2_KEY_SKELETON) { keytake = IT2_KEY_SKELETON; itemset = 1; } // Saved for last as it is the most valuable and can open any door.  Likely want to save it for later.

			if (keytake) { // Opened!
				if (itemset == 0) {
					if (!self.persistentkey) attempter.items = attempter.items - keytake;
					key_message(itemset,keytake,attempter,TRUE);
				} else if (itemset == 1) {
					if (!self.persistentkey) attempter.items2 = attempter.items2 - keytake;
					key_message(itemset,keytake,attempter,TRUE);		
				} else if (itemset == 2) {
					if (!self.persistentkey) attempter.moditems = attempter.moditems - keytake;
					key_message(itemset,keytake,attempter,TRUE);
				} // Currently no keys in perms so no need to check it.
			} else { // Still locked.
				key_message(2,0,attempter,FALSE);
				if (self.locksounds > 0) sound(self, CHAN_VOICE, self.noise, self.volume, ATTN_NORM); // Check for locksounds override
				else sound (self, CHAN_VOICE, self.noise3, self.volume, ATTN_NORM); // Default lock sound for silver/gold keys
				return;
			}
		} else {
			if (self.moditems > 0) { // Is this a custom locked door?
				if ( (self.moditems & attempter.moditems) != self.moditems ) {
					if (attempter.items2 & IT2_KEY_SKELETON) { // Opened!
						if (!self.persistentkey) attempter.items2 = attempter.items2 - IT2_KEY_SKELETON; // Remove custom key from player/client
						key_message(1,IT2_KEY_SKELETON,attempter,TRUE);
					} else { // Still locked.
						key_message(2,self.moditems,attempter,FALSE);
						if (self.locksounds > 0) sound (self, CHAN_VOICE, self.noise, self.volume, ATTN_NORM); // Check for locksounds override
						else sound (self, CHAN_VOICE, self.noise3, self.volume, ATTN_NORM); // Default lock sound (based on worldspawn)
						return;
					}
				} else { // Opened!
					if (!self.persistentkey) attempter.moditems = attempter.moditems - self.moditems; // Remove custom key from player/client
					key_message(2,self.moditems,attempter,TRUE);
				}
			} else {
				if ((self.items & attempter.items) != self.items) {
					if (attempter.items2 & IT2_KEY_SKELETON) { // Opened!
						if (!self.persistentkey) attempter.items2 = attempter.items2 - IT2_KEY_SKELETON; // Remove custom key from player/client
						key_message(1,IT2_KEY_SKELETON,attempter,TRUE);
					} else { // Still locked.
						key_message(0,self.owner.items,attempter,FALSE);
						if (self.locksounds > 0) sound (self, CHAN_VOICE, self.noise, self.volume, ATTN_NORM); // Check for locksounds override
						else sound (self, CHAN_VOICE, self.noise3, self.volume, ATTN_NORM); // Default lock sound for silver/gold keys
						return;
					}
				} else { // Opened!
					if (!self.persistentkey) attempter.items = attempter.items - self.items; // Take key from player inventory
					key_message(0,self.items,attempter,TRUE);
				}
			}
		}

		self.touch = SUB_Null; // Turn off touch function	
		if (self.enemy) self.enemy.touch = SUB_Null; // turn off touch on pair/master door
		th_activate();
	}
};

// Used for keys and messages
void() func_door_touch = { // [FUNCTION]
	if (self.estate & ESTATE_BLOCK) return;
	if ( !(other.flags & FL_CLIENT) ) return;
	if (self.owner.attack_finished > time) return;

	self.owner.attack_finished = time + 2; // Block retouch for 2 seconds
	keyuser_attempt(func_door_use,other);
};

void() func_door_on = { // [FUNCTION]
	if (self.estate == ESTATE_ON) return; // Stop re-triggering ON state

	self.spawnflags = self.spawnflags - (self.spawnflags & ENT_STARTOFF); // No longer need this spawnflag, remove it
	self.estate = ESTATE_ON;
	self.movetype = MOVETYPE_PUSH;
	self.solid = SOLID_BSP;
	setmodel (self, self.mdl);
	self.velocity = '0 0 0';
	self.frame = self.frame_override;	// Reset to default
	
	// Reset Door position if NOT key or working once
	if (self.items == 0 && self.wait != -1) {
		setorigin(self, self.pos1);
		self.state = STATE_BOTTOM;
		self.think = SUB_Null;
	}

	// reset health and damage trigger
	if (self.max_health > 0) {
		self.health = self.max_health;
		self.takedamage = DAMAGE_YES;
	}
};

void() func_door_off = { // [FUNCTION]
	if (self.estate == ESTATE_OFF) return; // Stop re-triggering OFF state

	self.estate = ESTATE_OFF;
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	setmodel (self, "");
	self.velocity = '0 0 0';
	self.takedamage = DAMAGE_NO;
	self.think = SUB_Null;
	StopSound(self,CHAN_VOICE); // Stop all movement sounds
	if (self.items == 0 && self.wait != -1) { // Reset Door position if NOT key or working once
		setorigin(self, self.pos2);
		self.state = STATE_BOTTOM;
	}
};

void() func_door_disable = { // [FUNCTION]
	self.takedamage = DAMAGE_NO; // Block damage function and show alternative texture
	self.frame = 1 - self.frame_override;	// Turn off alt textures
};

void() func_door_reset = { // [FUNCTION]
	if (self.spawnflags & ENT_STARTOFF) return; // If the door is still OFF then leave it
	
	if (self.items > 0 ) { // Restore key functionality
		self.touch = func_door_touch;
		if (self.enemy) self.enemy.touch = func_door_touch; // switch on master door as well
	}

	setorigin(self, self.pos1); // reset to original position
	self.state = STATE_BOTTOM;
	self.attack_finished = 0;
	self.frame = self.frame_override;	// Reset Alt textures
	if (self.midstart) self.midstart = FALSE; // Always reset midstart flag (position is wrong)
	self.estate = ESTATE_OFF; // Restore door to ON state
	self.estate_on();
	self.think = SUB_Null;
};

void() func_door_blocked = { // [FUNCTION]
	if (self.midstart) self.midstart = FALSE; // Always reset midstart flag (its no longer needed)
	T_Damage (other, self, self, self.dmg, DAMARMOR); // Do the block damage
	if (self.wait != -1) { // if a door has a negative wait, it would never come back if blocked, so let it just squash the object to death real fast.
		if (self.state == STATE_DOWN) func_door_go_up ();
		else func_door_go_down ();
	}
};

void() keyuser_setup = { // [FUNCTION]
	if (self.noise1 == "") self.noise1 = SOUND_EMPTY; // Setup all empty/silent sound files first
	if (self.noise2 == "") self.noise2 = SOUND_EMPTY;
	if (self.sounds == 1) { // noise1 : Moving/Open door (looping).  noise2 : Stop/Close door 
		self.noise1 = "doors/drclos4.wav";
		self.noise2 = "doors/doormv1.wav";
	} else if (self.sounds == 2) {
		self.noise1 = "doors/hydro2.wav";
		self.noise2 = "doors/hydro1.wav";
	} else if (self.sounds == 3) {
		self.noise1 = "doors/stndr2.wav";
		self.noise2 = "doors/stndr1.wav";
	} else if (self.sounds == 4) {
		self.noise1 = "doors/ddoor2.wav";
		self.noise2 = "doors/ddoor1.wav";
	} else if (self.sounds == 11) { // Sounds from func_plat (base sounds)
		self.noise1 = "plats/plat2.wav";
		self.noise2 = "plats/plat1.wav";
	} else if (self.sounds == 12) { // Sounds from func_plat (base sounds)
		self.noise1 = "plats/medplat2.wav";
		self.noise2 = "plats/medplat1.wav";
	}

	if (!self.worldtype) self.worldtype = world.worldtype; // Check for any self worldtype override
	if (self.noise3 == "") { // Allow for custom sounds by checking noise3/4 string content first.  Locked door sounds (silver, gold and custom keys).
		if (self.worldtype == 1) self.noise3 = "doors/runetry.wav";
		else if (self.worldtype == 2) self.noise3 = "doors/basetry.wav";
		else self.noise3 = "doors/medtry.wav";
	}

	if (self.noise4 == "") {
		if (self.worldtype == 1) self.noise4 = "doors/runeuse.wav";
		else if (self.worldtype == 2) self.noise4 = "doors/baseuse.wav";
		else self.noise4 = "doors/meduse.wav";
	}		

	if (self.noise == "") self.noise = SOUND_TALK;
	if (self.locksounds == 1) self.noise = "ad171/doors/rattle1.wav"; // locked sound (targetname + message)
	else if (self.locksounds == 2) self.noise = "ad171/doors/rattle2.wav";
	else if (self.locksounds == 3) self.noise = "ad171/doors/rattle6.wav";
	else if (self.locksounds == 13) self.noise = "misc/trigger1.wav";
	else if (self.locksounds == 14) self.noise = SOUND_EMPTY; 
	else if (self.locksounds == 16) self.noise = RND_SURPRISENEG;
	else if (self.locksounds == 21) self.noise = "ad171/doors/rattle_tech1.wav";
	else if (self.locksounds == 22) self.noise = "ad171/doors/rattle_tech2.wav";
	else if (self.locksounds == 23) self.noise = "ad171/doors/rattle_tech3.wav";
	else if (self.locksounds == 24) self.noise = "ad171/doors/rattle_tech4.wav";
	precache_sound (self.noise);
	precache_sound (self.noise1);
	precache_sound (self.noise2);
	precache_sound (self.noise3);
	precache_sound (self.noise4);

	self.items = self.moditems = 0; // Is the door locked via special keys (silver/gold).  Make sure any rogue entity keys are removed.
	if (self.spawnflags & DOOR_SILVER_KEY) self.items = IT_KEY1;
	else if (self.spawnflags & DOOR_GOLD_KEY) self.items = IT_KEY2;
	else if (self.customkey > 0) { // Check for custom key requirement (only supports 1-4 types)
		self.items = IT_KEY1 | IT_KEY2; // Need items for certain checks to work.
		if (self.customkey == 1) self.moditems = IT_CKEY1;
		else if (self.customkey == 2) self.moditems = IT_CKEY2;
		else if (self.customkey == 3) self.moditems = IT_CKEY3;
		else if (self.customkey == 4) self.moditems = IT_CKEY4;
		else if (self.customkey >= 5) { // Handle 'Any Key' support.  Any key will do.
			if (self.message2 == "") self.message2 = "Lock holds but is very worn.\nAny key should work.";
		}
		if (self.message2 == "") self.message2 = "You need a special type of key\nfor this lock.";
	}

	if (self.items > 0) { // key doors ONLY work once and have touch function 
		self.wait = -1;		// Work once
		self.health = 0;	// no shoot/damage
	}
};

// QUAKED func_door (0 .5 .8) ? STARTOPEN SPAWNTRIG DONTLINK GOLD SILVER TOGGLE STARTOFF x Not_Easy Not_Normal Not_Hard Not_DM
// -------- KEYS --------
// targetname : = "" door automatically opens, != "" requires trigger to open
// if using entity state system set SPAWN_TRIG spawnflags to fix this problem
// target   : name of target(s) to trigger at the start opening sequence
// angle    : determines the opening direction, use "360" for angle 0
// angletarget : Entity (path_corner) to move towards (custom direction)
// speed    : movement speed (def=100)
// yaw_speed: return movement speed (def=speed)
// wait     : wait before returning (def=3, -1 = never return)
// lip      : lip remaining at end of move. (def=8)
// height   : Exact distance to move (works like func_plat and uses angles)
// midstart : Start in 2nd position and wait for trigger, then work as spawned
// health   : Can be damaged instead of touched
// dmg      : damage to inflict when blocked. (def=2)
// message  : centerprint message when touched (removed when opened)
// sounds   : 0=silent 1=stone 2=base 3=chain 4=metal 5=custom 11=base plat 12=med plat
// locksounds : 0=talk 1=med1 2=med2 3=med3 13=trigger 14=silent 16=secret 21=base1 22=base2 23=base3 24=base4
// noise    : custom sound - door locked sound (targetname+message)
// noise1   : custom sound - Moving/Open door (looping)
// noise2   : custom sound - Stop/Close door 
// noise3   : custom sound - Silver/Gold key try lock
// noise4   : custom sound - Silver/Gold key OPEN
// volume   : Volume for all custom sounds played (def=1, range=0-1)
// persistentkey : Key required for this door is never removed from player
// customkey: custom key required to open door (1-4 supported values)
// message2 : custom key message (You need the custom key)
// bbmins   : custom size for generated trigger (def='-60 -60 -8')
// bbmaxs   : custom size for generated trigger (def='60 60 8')
// _dirt       : -1 = will be excluded from dirtmapping
// _minlight   : Minimum light level for any surface of the brush model
// _mincolor   : Minimum light color for any surface (def='1 1 1' RGB)
// _shadow     : Will cast shadows on other models and itself
// _shadowself : Will cast shadows on itself
// -------- SPAWNFLAGS --------
// STARTOPEN : door opens in reverse state (moved to dest at spawn)
// SPAWNTRIG : Will spawn trigger around door even if targetname SETUP
// DONTLINK  : Touching doors will not link into a single entity
// GOLD      : Requires gold key to open
// SILVER    : Requires silver key to open
// TOGGLE    : Door waits for trigger between states (if wait=-1 cannot be blocked)
// STARTOFF  : Starts off and waits for trigger
// -------- NOTES --------
// Door (bmodel) with two states
void() func_door = { // [ENTITY]
	if (check_bmodel_keys()) return;	// Check for bmodel errors

	keyuser_setup();
	SUB_BoundVolume(1);
	self.classtype = CT_FUNCDOOR; // Setup classtype and flag as BSP origin
	self.classgroup = CG_FUNCMOVER;
	self.bsporigin = TRUE;
	self.mdl = self.model;
	SetMovedir (); // Set angle/movedir and reset angles
	if (self.speed <=0) self.speed = 100;
	if (self.yaw_speed <=0) self.yaw_speed = self.speed; // Second movement speed can be different, yaw_speed
	if (!self.wait) self.wait = 3;
	if (!self.lip) self.lip = 8;
	if (!self.dmg) self.dmg = 2;
	self.state = STATE_BOTTOM;
	self.attack_finished = 0;
	if (!self.frame_override) self.frame_override = 0; // Default/Setup alternative texture frame
	self.frame = self.frame_override;
	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_PUSH;
	setmodel (self, self.mdl); // Add bmodel to world and work out movement positions
	setorigin (self, self.origin);	
	setsize (self, self.mins , self.maxs);
	self.pos1 = self.origin;
	self.oldorigin = bmodel_origin(self);
	if (check_nightmare() == TRUE) { entity_hide(self); return; } // Check for spawning conditions (nightmare, coop).  Needs to exist after entity has been added to work for BSPorigin.
	if (check_coop() == TRUE) { entity_hide(self); return; }

	if (self.items > 0 || self.message != "") self.touch = func_door_touch; // Only need to touch doors if require keys or centerprint messages
	self.blocked = func_door_blocked;
	if (CheckZeroVector(self.bbmins)) self.bbmins = '-60 -60 -8'; // Check for QC created trigger bounding box override
	if (CheckZeroVector(self.bbmaxs)) self.bbmaxs = '60 60 8';
	
	// Start open reverses pos1+2 which will screw up angletarget location
	// Disable this feature, reverse lifts can be setup easily if needed
	if (self.angletarget != "" && self.spawnflags & DOOR_START_OPEN) {
		dprint("\b[FUNC_DOOR]\b angletarget + start open not supported!\n");
		spawn_marker(self.oldorigin, SPNMARK_YELLOW);
		remove(self);
		return;
	}
	
	if (self.height > 0) self.pos2 = self.pos1 + (self.movedir*self.height); // Check if height is defined? (used by func_plat).  Much easier system to setup, instead of voodoo lip magic!
	else self.pos2 = self.pos1 + self.movedir*(fabs(self.movedir*self.size) - self.lip); // Default movement system = move direction * (size - lip)

	// DOOR_START_OPEN is design for an entity to be lit in the closed position but spawn in the open position, also reversed door functions.
	if (self.spawnflags & DOOR_START_OPEN) {
		setorigin (self, self.pos2);
		self.pos2 = self.pos1;
		self.pos1 = self.origin;
	}

	// Only enable damage trigger (die) if health set
	if (self.health) {
		self.max_health = self.health;
		self.takedamage = DAMAGE_YES;
		self.th_die = func_door_killed;
	}

	// MIDSTART is designed for doors pretending to be func_plats.  The door is moved to the 2nd position and paused until trigger
	// Once triggered the func_door will resume movement and go back to the first position and work as a regular elevator/door!
	if (self.midstart > 0) {
		if (self.targetname == "") dprint("\b[func_door]\b targetname required for midstart!\n"); // If cannot be triggered without a targetname
		if (SUB_HideIfNoTargetname()) return;

		if (self.angletarget == "") { // Have to wait for angletarget ent to spawn
			setorigin (self, self.pos2); // Move func_door into second position
			self.state = STATE_TOP;
		}
	}

	self.use = entity_state_use; // Setup Entity State functionality.  The 'USE' wrapper has to be setup, because after the doors are linked they will all have targetnames!
	self.estate_on = func_door_on;
	self.estate_off = func_door_off;
	self.estate_use = func_door_use; 
	self.estate_disable = func_door_disable;
	self.estate_reset = func_door_reset;
	
	// Check for any (mapper) entity state setups (OFF/DISABLE)
	// Need targetname defined (can't active bmodel otherwise)
	// Not an ideal way to do this because estate values could change
	if (self.targetname != "" && self.estate > 0) {
		if (self.estate == ESTATE_OFF) self.spawnflags = self.spawnflags | ENT_STARTOFF;
		//if (self.estate == ESTATE_DISABLE) // Unfortunately there is no start disabled functionality // TODO: Investigate
	} else self.estate = ESTATE_ON; // Default state

	// Light/Shadow switchable system, setup defaults
	if (self.switchshadstyle > 0) {
		dprint("\n[DOOR] Light style (");
		dprint(ftos(self.switchshadstyle));
		dprint(")\n\n");
		lightstyle(self.switchshadstyle, "a");
	}

	if (self.spawnflags & DOOR_DONT_LINK) {  // Doors cannot be linked until all bmodels have spawned and bounding box sizes established, check for exceptions first
		self.owner = self.enemy = self;
		if (self.angletarget != "") { // Need spawn delay if using angletarget (target not ready)
			self.think = func_door_final_setup; // Check for any final setup conditions
			self.nextthink = self.ltime + 0.1;
		} else func_door_final_setup(); // Original setup, no delay on spawn
	} else {
		self.think = func_door_link;
		self.nextthink = self.ltime + 0.1;
	} 
};

void() trigger_doorstate_use = { // [FUNCTION]
	if (self.estate & ESTATE_BLOCK) return;
	if (self.attack_finished > time) return;

	trigger_strs(self.target, self); // Fire target(s)
	if (self.wait < 0) self.attack_finished = LARGE_TIMER;	 // Setup to trigger once?
};

void() trigger_doorstate_delay = { // [FUNCTION]
	if (self.estate & ESTATE_BLOCK) return;

	if (self.spawnflags & ENT_STARTOFF) self.spawnflags = self.spawnflags - ENT_STARTOFF; // Remove the trigger delay function
	self.estate_use = trigger_counter_use; // Re-route use function to actual counter
};

void() trigger_doorstate_setup = { // [FUNCTION]
	self.lefty = FALSE; // entity check condition
	self.enemy = find(world, targetname, self.target); // Search for func_door targets
	while (self.enemy) { // Found any yet?
		if (self.enemy.classtype == CT_FUNCDOOR) { // Found a func_door?
			if (self.enemy.spawnflags & DOOR_TOGGLE) self.lefty = TRUE; // All func_door(s) require toggle spawnflag enabled
			else {
				dprint("\b[TRIG_DOORSTATE]\b ");
				dprint(self.enemy.targetname);
				dprint(" missing toggle spawnflag!\n");
			}
		} else { // The whole list needs to be door entities
			dprint("\b[TRIG_DOORSTATE]\b Target ("); dprint(self.target);
			dprint(") ("); dprint(self.enemy.classname);
			dprint(") Wrong!\n");
			self.lefty = FALSE;
		}
		
		// Keep looping through the find list
		self.enemy = find(self.enemy, targetname, self.target);
	}
	
	// Found any errors with setup?
	if (self.lefty == FALSE) {
		spawn_marker(self.oldorigin, SPNMARK_YELLOW);
		remove(self);
		return;
	}
	
	if (self.targetname != "") self.use = entity_state_use; // Finally setup Entity State functionality
	if (self.spawnflags & ENT_STARTOFF) self.estate_use = trigger_doorstate_delay; // The delay function is not switched off, its activate to use
	else self.estate_use = trigger_doorstate_use;
};

// QUAKED trigger_doorstate (0.5 0 0.5) (-8 -8 -16) (8 8 16) x x x x x x STARTOFF x Not_Easy Not_Normal Not_Hard
// -------- KEYS --------
// targetname : trigger this entity
// target  : ALL target(s) must be func_door entities with toggle spawnflag!
// state   : 0 or 1 func_door state (0=closed, 1=open)
// wait    : -1 = will only fire targets once
// -------- SPAWNFLAGS --------
// STARTOFF : Requires trigger to activate
// -------- NOTES --------
// Trigger func_door(s) to exact state (open/close)
void() trigger_doorstate = { // [ENTITY]
	self.classtype = CT_TRIGDOORSTATE;
	if (self.state < 0 || self.state > 1) self.state = 0;
	self.delay = self.sounds = 0;
	self.message = self.noise = "";
	self.nodebuginfo = TRUE;
	if (SUB_HideIfNoTarget()) return; // This entity is called a lot from pressure plate entities so it really needs to be setup right before use!  No target = disable, hide, and warning message
	if (check_nightmare() == TRUE) return; // Check for firing conditions (nightmare, coop)
	if (check_coop() == TRUE) return;

	self.think = trigger_doorstate_setup; // Double check targets are right type
	self.nextthink = time + 0.2;
};
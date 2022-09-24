//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by W. Josiah Jack, aka Qmaster
//
// Attributions: Arcane Dimensions (AD)
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
// Function count: 6
//
// Implements: Pressure Plates
//
// Description:
// Special type of button that activates when you walk on it and deactivates
// when you walk off.
//
// * Originally started as an extension of the func_button entity
// * Had too many spawning/setup conditions and was made into own entity
// * Having the trigger, touch and movement on one entity did not work
// * Split the trigger/touch into a separate spawn function, not v flexible
// * Entity Detection has to be volume, only players have floor touch bbox
// * Added a separate trigger/touch entity to detect different entity types
// * Trigger needed to keep track of multiple touching entities at once
// * Detecting intersection volumes without a touch function is cpu intense
//=============================================================================

float PSWITCH_STARTDIS = 32; // Switch starts in disabled state

void() func_pswitch_ready = { // [FUNCTION]
	if (self.estate & ESTATE_BLOCK) return; // Check for entity state changes

	self.frame = 0;
	self.state = STATE_UP;
};

void() func_pswitch_return = { // [FUNCTION]
	if (self.estate == ESTATE_OFF) return; // Check for entity state changes.  Do not block disable (let it move up).

	if (self.state == STATE_DOWN) {
		if (self.presstimersound < time) {
			self.presstimersound = time + 1;
			sound(self,CHAN_VOICE, self.noise1, self.volume,ATTN_NORM); // 2nd movement sound - going up
		}
		self.ltime = time;
		self.state = STATE_MOVING;
		SUB_CalcMove (self.pos1, self.speed, func_pswitch_ready);
	}
};

void() func_pswitch_finished = { // [FUNCTION]
	if (self.message != "") { // Check for any completed message
		msg_entity = self;
		WriteByte (MSG_ALL, SVC_CENTERPRINT); // Write message to all clients
		WriteString (MSG_ALL, self.message);
		if (self.wait < 0) self.message = "";
	}
	
	if (HasTargets(self)) { // Check for any completed trigger(s)
		SUB_UseTargets();
		if (self.wait < 0) clear_trigstrs(self);
	}

	self.frame = 1;
	self.state = STATE_DOWN;
	if (self.estate & ESTATE_BLOCK) return; // Check for entity state changes

	self.think = func_pswitch_return;
	self.nextthink = time + 0.2;
};

void() func_pswitch_use = { // [FUNCTION]
	if (self.estate & ESTATE_BLOCK) return; // Check for entity state changes
	if (self.state == STATE_MOVING) return; // Block trigger events if moving pressure plate

	// Is the pressure plate UP?
	if (self.state == STATE_UP) { // Move pressure pad into down position
		if (self.presstimersound < time) {
			self.presstimersound = time + 1;
			sound(self,CHAN_VOICE, self.noise, self.volume,ATTN_NORM); // 1st movement sound - going down
		}
		self.ltime = time;
		self.state = STATE_MOVING;
		SUB_CalcMove (self.pos2, self.speed, func_pswitch_finished);
	} else if (self.state == STATE_DOWN) { // Keep waiting in the down position
		self.think = func_pswitch_return;
		self.nextthink = time + 0.2;
	}
};

void() func_pswitch_on = { // [FUNCTION]
	if (self.estate == ESTATE_ON) return; // Stop re-triggering ON state

	self.spawnflags = self.spawnflags - (self.spawnflags & ENT_STARTOFF); // No longer need this spawnflag, remove it
	self.estate = ESTATE_ON;
	self.movetype = MOVETYPE_PUSH;
	self.solid = SOLID_BSP;
	setmodel(self, self.mdl);
	setorigin(self, self.pos1);
	self.state = STATE_UP; // Reset state and frame back to default
	self.frame = 0;
	self.think = SUB_Null;
};

void() func_pswitch_off = { // [FUNCTION]
	if (self.estate == ESTATE_OFF) return; // Stop re-triggering OFF state

	self.estate = ESTATE_OFF;
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	setmodel(self, "");
	StopSound(self,CHAN_VOICE); // Reset position and frame back to default
	setorigin(self, self.pos1);
	self.state = STATE_UP;
	self.think = SUB_Null;
	self.frame = 0;
};

// QUAKED func_pressureswitch (0 .5 .8) ? x x x x x x STARTOFF x Not_Easy Not_Normal Not_Hard Not_DM
// -------- KEYS --------
// targetname : trigger entity (works with entity state system)
// target : name of target(s) to trigger (only works with pressure relays)
// angle  : Always moves downward (needs to reflect gravity pressure)
// speed  : Move Speed (def=40)
// lip    : lip remaining at end of move. (def=4)
// sounds : 0=steam metal, 1=wooden, 2=metallic, 3=in-out, 4=Silent, 5=Custom
// noise  : custom sound - 1st movement
// noise1 : custom sound - 2nd movement ('buttons/switch21.wav')
// volume : Volume for all custom sounds played (def=1, range=0-1)
// message: Centerprint Message to display when triggered
// _dirt       : -1 = will be excluded from dirtmapping
// _minlight   : Minimum light level for any surface of the brush model
// _mincolor   : Minimum light color for any surface (def='1 1 1' RGB)
// _shadow     : Will cast shadows on other models and itself
// _shadowself : Will cast shadows on itself
// -------- SPAWNFLAGS --------
// STARTOFF : Starts off and waits for trigger
// -------- NOTES --------
// Pressure switch (bmodel) with touch state only
void() func_pressureswitch = { // [ENTITY]
	if (check_bmodel_keys()) return; // Check for bmodel errors
	
	if (self.noise == "") self.noise = SOUND_EMPTY; // Setup all empty/silent sound files first
	if (self.sounds == 0) self.noise = "buttons/airbut1.wav"; // Default 0 = air (base style) button
	else if (self.sounds == 1) self.noise = "buttons/switch21.wav";
	else if (self.sounds == 2) self.noise = "buttons/switch02.wav";
	else if (self.sounds == 3) self.noise = "buttons/switch04.wav";
	else if (self.sounds == 4) self.noise = SOUND_EMPTY;
	precache_sound(self.noise);
	if (self.noise1 == "") self.noise1 = self.noise;
	precache_sound(self.noise1);
	SUB_BoundSoundVolume(1);
	self.classtype = CT_FUNCPSWITCH;
	self.classgroup = CG_FUNCMOVER;
	self.bsporigin = TRUE;
	self.mdl = self.model;
	self.movedir = '0 0 -1'; // Pressure switches always move up/down
	self.angles = '0 0 0';
	if (!self.speed) self.speed = 40; // Default parameters and states
	if (!self.lip) self.lip = 4;
	self.state = STATE_UP;
	self.health = self.max_health = 0;
	self.takedamage = DAMAGE_NO;
	self.wait = -1;
	self.presstype = self.presstimersound = 0; // Reset all pressure switch variables
	self.movetype = MOVETYPE_PUSH; // Setup the pressure switch two different state positions.  Got to add switch to world for bmodel size parameter.
	self.solid = SOLID_BSP;
	setmodel(self, self.mdl);
	self.pos1 = self.origin;
	self.pos2 = self.pos1 + self.movedir*(fabs(self.movedir*self.size) - self.lip);
	if (self.spawnflags & BUTTON_STARTDIS && self.targetname == "") { // Cannot have a pressure switch start off or disabled with no targetname, how can it be actived!?!
		dprint("\b[PSWITCH]\b Starting DISABLED with no targetname!\n");
		self.oldorigin = bmodel_origin(self);
		spawn_marker(self.oldorigin,'0 0 0',0,SPNMARK_YELLOW);
		entity_hide(self);
		return;
	}

	if (self.spawnflags & ENT_STARTOFF && self.targetname == "") {
		dprint("\b[PSWITCH]\b Starting OFF with no targetname! Turned it on.\n");
		self.spawnflags = self.spawnflags - ENT_STARTOFF;
	}	

	if (check_nightmare() == TRUE) return; // Check for spawning conditions (nightmare, coop).  Needs to exist after entity has been added to work for BSPorigin.
	if (check_coop() == TRUE) return;

	if (self.targetname != "") self.use = entity_state_use; // Setup Entity State functionality
	self.estate_on = func_pswitch_on;
	self.estate_off = func_pswitch_off;
	self.estate_use = func_pswitch_use;
	if (self.spawnflags & ENT_STARTOFF) self.estate_off(); // Check for starting off or default=on
	else self.estate_on();
};
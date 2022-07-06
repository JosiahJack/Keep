//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
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
// Entity count: 0
// Function count: 22
//
// Implements: Trigger System
//
// Description:
// This defines the system used by all triggers to determine their touchability
// and other basic functionality such entity state system interaction.
//
// Allows for monster triggers and enableable/disableable triggers.
//=============================================================================

float TRIG_NOTOUCH = 1; // Touch functionality is disabled; will need special setup to avoid this!  Active in the delay/restore functions.
float TRIG_DEVMODE = 4; // Will only trigger in dev model.  Only affects trigger_ONCE & _MULTIPLE.
float TRIG_INVIEW = 8; // Player has to see trigger; only affects trigger_ONCE.
float TRIG_MODCHECK = 16; // Will remove entity if mod version wrong.  Only affects trigger_ONCE, _MULTIPLE & _HURT..  Is checked before any trigger is spawned into the map.
float TRIG_MONSTERS = 32; // Can be touched/triggered by monsters.  Used by many triggers to prevent monster use.  Will need special setup to avoid this!   Used in trigger_bmodel_touch function ONLY
float TRIG_NODAMAGE = 16384; // Added by functions, no map entity interaction.  Block trigger damage functionality.
float TRIG_ALWAYTOUCH = 32768; // Added by functions, no map entity interaction.  Always allow touch function to exist.

// Used by lots of different triggers for standard sounds
void() trigger_bmodel_sounds = { // [FUNCTION]
	if (self.sounds == 1) self.noise = "misc/secret.wav";
	else if (self.sounds == 2) self.noise = SOUND_TALK;
	else if (self.sounds == 3) self.noise = "misc/trigger1.wav";
	else if (self.sounds == 4) self.noise = SOUND_EMPTY;
	else if (self.sounds == 6) self.noise = RND_SURPRISENEG;
	else if (self.sounds == 7) self.noise = "drake/misc/secret2.wav";

	if (self.noise != "") precache_sound(self.noise); // precache any sounds that have been defined
	SUB_BoundVolume(1);
};

// Special sight trigger, Is the player *looking* at this trigger.  This sight trigger cannot be disabled or turned off atm.
void() trigger_bmodel_inview = { // [FUNCTION]
	local entity client, tself;
	local float play_dist, play_range, play_angle;
	
	if (self.attack_finished > time) return; // Is the trigger blocked? (trigger_once)
	
	// Checkclient needs an proper entity origin, bmodels are '0 0 0'.  Create a temporary entity to switch around too for checkclient.
	if (!self.attachment) {
		self.attachment = spawn();
		self.attachment.owner = self;
		self.oldorigin = bmodel_origin(self);
		setorigin(self.attachment, self.oldorigin);
	}
	
	tself = self; // Swap around self/attachment so checkclient can work properly
	self = self.attachment;
	client = checkclient(); // Find a client in current PVS
	self = tself;
	if (client.flags & FL_CLIENT) { // Found a player to check sight/distance for?
		if (visxray(self,client, VEC_ORIGIN, VEC_ORIGIN, FALSE)) {
			play_dist = vlen(self.oldorigin - client.origin); // Work out vector length between entity and player	
			if (!self.t_length) play_range = play_dist + 1; // Is there a distance check active? if not make sure it will pass
			else play_range = self.t_length;

			play_angle = viewangle(self.oldorigin, client.origin, 45, TRUE, client.v_angle_y); // The angle the player is facing towards the trigger (45 = forward)
		
			// Check distance is correct and facing angle focused
			if (play_dist < play_range && play_angle > 30 && play_angle < 60) {
				self.wait = -1;
				self.bmodel_act = activator;
				self.estate_fire();
				return;
			}
		}
	}

	self.nextthink = time + 0.1; // Keep checking, 0.1 standard entity timing
	self.think = trigger_bmodel_inview;
};

//  the trigger was just touched/killed/used
//  self.bmodel_act should be set to the activator so it can be held 
//  through a delay so wait for the delay time before firing
void() trigger_bmodel_fire = { // [FUNCTION]
	if (self.attack_finished > time) return; // Is the trigger blocked? (trigger_once)
	
	if (self.spawnflags & TRIG_DEVMODE && developer == 0) { // Check for developer mode only triggers
		if (self.classtype == CT_TRIGONCE || self.classtype == CT_TRIGMULTI) return; // This feature only work for ONCE/MULTIPLE triggers
	}
	
	// The Shotgun and Axe upgrades can make maps too easy, allow for triggers to not fire if the key is TRUE and inventory empty
	if ( self.bmodel_act.flags & FL_CLIENT ) {
		if (self.upgrade_axe && !(self.bmodel_act.moditems & IT_UPGRADE_AXE)) return;
		if (self.upgrade_ssg && !(self.bmodel_act.moditems & IT_UPGRADE_SSG) ) return;
		if (self.upgrade_lg && !(self.bmodel_act.moditems & IT_UPGRADE_LG) ) return;
	}
	
	// Trigger secrets only work for players
	if (self.classtype == CT_TRIGSECRET) {
		if (!(self.bmodel_act.flags & FL_CLIENT)) return; // If trigger_secret has NOTOUCH then check activator
		if (self.bmodel_act.movetype == MOVETYPE_NOCLIP) return;
		
		if (self.count > 0) { // The trigger can be reset, so double check and only let secrets be found once though triggered twice+.
			found_secrets = found_secrets + self.count;
			WriteByte (MSG_ALL, SVC_FOUNDSECRET);
			self.count = 0;	// Secrets only work once
		}
	} else if (self.classtype == CT_TRIGMULTI && self.count > 0) { // Switch off ability for trigger_mulitiple ONLY
		self.count = self.count - 1;
		if (self.count <= 0) self.wait = -1;
	}

	if (self.noise != "") sound (self, CHAN_VOICE, self.noise, self.volume, ATTN_NORM); // Play the sound ON the trigger, NOT the activator

	// One of the downside to trigger_multi and trigger_once is that they reset the activator global variable each time they are used.
	// This can causes problems with triggers that require client references for centerprint/sound cues (like trigger_secret)
	// The way to get around this problem is to use trigger_relay as this does not change the activator variable.
	activator = self.bmodel_act;
	SUB_UseTargets();

	// Is the trigger repeatable?
	if (self.wait > 0) {
		if (self.estate & ESTATE_BLOCK) return; // Double check trigger is turned on!?!  The sequence and timing for QC is not always perfect.  Always check stuff before resetting think/nextthink.

		self.attack_finished = time + self.wait; // Setup a re-trigger event
		self.nextthink = self.attack_finished;
		self.think = self.estate_on;
	} else {
		self.attack_finished = time + LARGE_TIMER; // TRIGGER_ONCE functionality
		self.estate_off();
	}
};

void() trigger_bmodel_use = { // [FUNCTION]
	if (self.estate & ESTATE_BLOCK) return; // There is no client test here because this can come from multiple entity types, the activator is passed on.

	self.bmodel_act = activator;
	self.estate_fire();
};

void() trigger_bmodel_touch = { // [FUNCTION]
	if (self.estate & ESTATE_BLOCK) return; // This is a client touch event, triggers that require other entity types need to have their own touch event
	if (!(self.spawnflags & TRIG_MONSTERS) && !(other.flags & FL_CLIENT)) return;

	TargetMovedir(self, FALSE); // Check for any target entity tracking
	if (!CheckZeroVector(self.movedir)) {
		makevectors(other.angles); // Did the trigger have an angle key setup?
		if (v_forward * self.movedir < 0) return;		
	}

	self.bmodel_act = other;
	self.estate_fire();
};

void() trigger_bmodel_anytouch = { // [FUNCTION]
	if (self.estate & ESTATE_BLOCK) return; // This will allow anything to touch it

	self.bmodel_act = other;
	self.estate_fire();
};

// The proto button setup of triggers using health
void() trigger_bmodel_killed = { // [FUNCTION]
	self.health = self.max_health; // Always reset health regardless if blocked or not
	if (self.estate & ESTATE_BLOCK) return;

	self.takedamage = DAMAGE_NO;
	self.bmodel_act = damage_attacker; 
	self.estate_fire();
};

// Setup touch/damage/bounding box functionality
void() trigger_bmodel_restore = { // [FUNCTION]
	// Damage functionality
	if (self.max_health > 0 && !(self.spawnflags & TRIG_NODAMAGE)) {
		self.health = self.max_health;
		self.takedamage = DAMAGE_YES;
		self.solid = SOLID_BBOX;
	} else if ( !(self.spawnflags & TRIG_NOTOUCH) || self.spawnflags & TRIG_ALWAYTOUCH) self.solid = SOLID_TRIGGER; // ALWAYSTOUCH was added because some triggers have re-used spawnflag 1 for other purposes and they still need touch.
	else self.solid = SOLID_NOT; // Turn off touch functionality

	setsize (self, self.bbmins, self.bbmaxs); // Restore bounding box (dev testing visual thing)

	if (check_nightmare() == TRUE) return; // Check for spawning conditions (nightmare, coop).  Needs to exist after entity has been added to work for BSPorigin.
	if (check_coop() == TRUE) return;
};

void() trigger_bmodel_delay = { // [FUNCTION]
	if (self.estate == ESTATE_DISABLE) return;
	
	self.spawnflags = self.spawnflags - (self.spawnflags & ENT_STARTOFF); // Remove the START OFF functionality now that it's started.
	self.estate_use = trigger_bmodel_use; // Reset USE and trigger_once conditions// Reset USE and trigger_once conditions
	self.attack_finished = 0;
	self.estate = ESTATE_ON;

	// Check if the player needs to be inview before triggering?  It would be weird to have this on multiple/secret triggers.
	if (self.classtype == CT_TRIGONCE && self.spawnflags & TRIG_INVIEW) {
		setsize (self, self.bbmins, self.bbmaxs); // Restore bounding box (dev testing visual thing)
		self.spawnflags = self.spawnflags | TRIG_NOTOUCH | TRIG_NODAMAGE; // Inview triggers are not touchable and cannot be damaged
		self.estate_use = trigger_bmodel_inview;
		self.estate_use();
		return;
	}
	
	// I would have never of guessed this was used throughout the original ID maps and there are countless cases of trigger_multiple entities being used like buttons that can be damaged but not touched.
	// I get the impression this was a prototype stage of development where everyone was waiting for func_button functionality to come online.
	if (self.health && !(self.spawnflags & TRIG_NODAMAGE)) {
		self.max_health = self.health; // save health for later
		self.th_die = trigger_bmodel_killed; // damage trigger
	} else {
		if ( !(self.spawnflags & TRIG_NOTOUCH) || self.spawnflags & TRIG_ALWAYTOUCH) {
			if (!self.touch) self.touch = trigger_bmodel_touch; // Setup touch functionality
		}
	}

	trigger_bmodel_restore(); // Setup touch/damage/bounding box functionality
};

void() trigger_bmodel_on = { // [FUNCTION]
	self.estate = ESTATE_ON;
	self.movetype = MOVETYPE_NONE;
	if (self.spawnflags & ENT_STARTOFF || self.attack_finished > time) self.solid = SOLID_NOT; // Check for delayed/trigger_once functionality?
	else trigger_bmodel_restore(); // Setup touch/damage/bounding box functionality
};

void() trigger_bmodel_off = { // [FUNCTION]
	self.oldorigin = bmodel_origin(self);
	self.estate = ESTATE_OFF;
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	setsize(self, VEC_ORIGIN, VEC_ORIGIN);
	self.estate_disable();
};

// Shutdown trigger completely
void() trigger_bmodel_disable = { // [FUNCTION]
	self.takedamage = DAMAGE_NO;
	self.think = SUB_Null;
};

// Reset trigger_once conditions
void() trigger_bmodel_reset = { // [FUNCTION]
	self.attack_finished = 0;
	self.estate_on();
};

void() trigger_bmodel_default = { // [FUNCTION]
	self.classgroup = CG_TRIGGERS;
	self.estate_on = trigger_bmodel_on;
	self.estate_off = trigger_bmodel_off;
	if (!self.estate_fire) self.estate_fire = trigger_bmodel_fire;
	self.estate_disable = trigger_bmodel_disable;
	self.estate_reset = trigger_bmodel_reset;
	self.estate = ESTATE_ON;
	SUB_BoundVolume(1);
};

void() trigger_bmodel_setup = { // [FUNCTION]
	trigger_bmodel_default();
	if (self.targetname != "") self.use = entity_state_use;
	self.estate_use = trigger_bmodel_delay;
	if (self.spawnflags & ENT_STARTOFF) {
		self.estate_use = trigger_bmodel_delay;
		self.estate_on = trigger_bmodel_delay;
		self.estate_off();
	} else self.estate_use(); // The original functionality of the trigger is to pass through
};

float() check_bmodel_notouch = { // [FUNCTION]
	// Cannot have a no touch AND no targetname setup!!!
	if (self.spawnflags & TRIG_NOTOUCH && self.targetname == "" && self.health < 1) {
		dprint("\b[TRIGGER]\b NO touch + NO targetname!\n");
		setmodel (self, self.model);
		self.oldorigin = bmodel_origin(self);
		spawn_marker(self.oldorigin, SPNMARK_YELLOW);
		entity_hide(self);
		return TRUE;
	} else return FALSE;
};

// Check if the right mod version is active
// return TRUE = delete trigger, everything ok, >= active version
// return FALSE = error, show trigger message, < active version
float() check_bmodel_modver = { // [FUNCTION]
	if (self.spawnflags & TRIG_MODCHECK) { // Is the trigger suppose to block/check the mod?
		if (CheckZeroVector(self.modver_check)) { // Is the mod ver/patch/beta check set to zero?  - no version check, then return TRUE (delete this trigger)
			entity_hide(self);
			return TRUE;
		} else {
			dprint("Test ("); dprint(vtos(self.modver_check));
			dprint(") Mod ("); dprint(ftos(mod_version));
			dprint(") Patch ("); dprint(ftos(mod_patch));
			dprint(") Beta ("); dprint(ftos(mod_beta));
			dprint(")\n");
			if (self.modver_check_x > mod_version) return FALSE; // Is the trigger version/patch number correct?
			else if (self.modver_check_y > mod_patch) return FALSE;
			else if (self.modver_check_z > mod_beta) return FALSE;
			else { entity_hide(self); return TRUE; } // Trigger no longer needed, current version is right
		}
	}
	return FALSE; // AD MOD is not active, keep the trigger
};

// Re-direction for map hacks (not used normally)
void() multi_trigger = { // [FUNCTION]
	trigger_bmodel_default();
	trigger_bmodel_fire();
};

void() multi_killed = { // [FUNCTION]
	trigger_bmodel_default();
	trigger_bmodel_killed();
};

void() multi_use = { // [FUNCTION]
	trigger_bmodel_default();
	trigger_bmodel_use();
};

void() multi_touch = { // [FUNCTION]
	trigger_bmodel_default();
	trigger_bmodel_touch();
};

void() multi_wait = { // [FUNCTION]
	if (!self.max_health) return;

	self.health = self.max_health;
	self.takedamage = DAMAGE_YES;
	self.solid = SOLID_BBOX;
};
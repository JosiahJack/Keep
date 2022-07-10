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
// Entity count: 5
// Function count: 10
//
// Implements: Entity State System
//
// Description:
// Quote from sock's Arcane Dimensions...
// When Quake first came out there were strict limitations on how many entities
// could exist and be active at the same time. The quick fix solution to this
// problem was to use the killtargets key so that entities could be removed. 
// This was a very powerful feature with very few restrictions on what it 
// could affect or destroy at the same time.
//
// The idea of the entity state system is to create a way to safely switch
// entities on, off or have then temporarily disabled. This will help prevent
// situations where entity chains are broken or strange errors occur because
// the touch function does not have an entity anymore.
//
// The entity state is a new key on entities which is designed to work in a
// passive mode until it is activated. All the entities listed below have a
// default value so that any existing map will still work as before.
//
// There are two methods for changing the entity state and the first method
// is an extra key on triggers entities (trigger _once, _multi, _relay etc)
//
// The ON state (default) will allow the entity to work as designed, be
// toggled and physically exist as per its setup.
//
// The OFF state will block all of the designed functionality and hide 
// the entity from interaction with the player.
//
// The DISABLE state blocks any toggle ability or entity functionality
// and turns off any visual aids like animated textures.
//
// The second method is via a brand new set of entities which can affect 
// multiple targets at once and are much easier (visually) to see what is
// going on because most editors draw target lines.
// ...end quote.
//=============================================================================

// These entity states are monitored and updated by the entity
void() entity_state_on = { 
	if (self.estate_on) self.estate_on(); 
	else self.estate = ESTATE_ON;
};

void() entity_state_off = { 
	if (self.estate_off) self.estate_off();
	else self.estate = ESTATE_OFF;
};

void() entity_state_disable = { 
	if (self.estate_disable) self.estate_disable();
	self.estate = ESTATE_DISABLE;
};

void() entity_state_reset = { 
	if (self.estate_reset) self.estate_reset();
};

void() entity_state_aframe = {
	if (!self.estate_aframe) return; // Only switch frames if the entity has a function defintion.  This will restrict to entities designed for this change.

	if (other.state == 0) self.frame = 0;
	else self.frame = 1;
};

void() entity_state_use = {
	// Does the firing entity have specific state requests?
	if (other.estate_trigger) {
		if (other.estate_trigger & ESTATE_ON) entity_state_on();
		else if (other.estate_trigger & ESTATE_OFF) entity_state_off();
		else if (other.estate_trigger & ESTATE_DISABLE) entity_state_disable();
		else if (other.estate_trigger & ESTATE_RESET) entity_state_reset();
		else if (other.estate_trigger & ESTATE_AFRAME) entity_state_aframe();
	} else {
		if (self.estate == ESTATE_DISABLE) return; // Check if disabled first

		if (self.estate_use) self.estate_use(); // Check for USE function
		else if (self.estate == ESTATE_OFF) entity_state_on(); // entity has a TOGGLE function
		else entity_state_off();
	}
};

// QUAKED trigger_entitystate_x (.7 .5 1) (-8 -8 -16) (8 8 16) x
// -------- KEYS --------
// target, target2, target3, target4  : target entities to affect x
// wait    : -1 = will only fire targets once
// delay   : delay before firing (after being triggered)
// cnt     : random amount of time to add to delay
// sounds  : 1=Secret,2=talk(def),3=switch,4=silent,5=custom,6=secret2
// noise   : custom sound to play when triggered
// volume  : Volume for all custom sounds played (def=1, range=0-1)
// -------- NOTES --------
// Switch the target(s) entity state X
void(string targstr) trigger_entitystate_target = {
	local entity t, stemp, otemp;

	t = find(world, targetname, targstr); // Start looking for targets to update
	stemp = self; otemp = other;	// Store self/other
	while(t) {
		if (t.flags & FLx_CREATURE)      { t = find(t,targetname,targstr); continue; } // Entity states not for players or monsters.
		if (!t.use || t.use == SUB_Null) { t = find(t,targetname,targstr); continue; } // Only change the state to ON/OFF/DISABLE
		
		self = t; other = stemp;		// Switch self/other
		entity_state_use();				// Update entity state
		self = stemp; other = otemp;	// Restore self/other
		t = find(t, targetname, targstr); // Are there anymore targets left in the list?
	}
};

void() trigger_entitystate_fire = {
	if (self.noise != "") sound(self, CHAN_VOICE, self.noise, self.volume, ATTN_NORM); // Play any trigger sounds
	if (self.target != "") trigger_entitystate_target(self.target);
	if (self.target2 != "") trigger_entitystate_target(self.target2);
	if (self.target3 != "") trigger_entitystate_target(self.target3);
	if (self.target4 != "") trigger_entitystate_target(self.target4);
	if (self.wait < 0) self.attack_finished = time + LARGE_TIMER; // TRIGGER_ONCE functionality
};	

void() trigger_entitystate_use = {
	if (self.attack_finished > time) return; // Is the trigger blocked? (trigger_once)

	// Check for delay fire functionality
	if (self.delay > 0) {
		self.think = trigger_entitystate_fire;
		if (self.cnt <= 0) self.cnt = 0;
		self.nextthink = time + self.delay + (random() * self.cnt);
	} else trigger_entitystate_fire(); // Fire/use straight away
};

void() trigger_entitystate_togglechecks = {
	self.classtype = CT_ESTATE;
	trigger_bmodel_sounds();			// Precache any sounds
	if (self.target == "") dprint("\b[ENTSTATE]\b Missing target!\n");
	if (self.targetname != "") self.use = trigger_entitystate_use;
};

void() trigger_entitystate_off = {
	trigger_entitystate_togglechecks();
	self.estate_trigger = ESTATE_OFF;
};

void() trigger_entitystate_on = {
	trigger_entitystate_togglechecks();
	self.estate_trigger = ESTATE_ON;
};

void() trigger_entitystate_disable = {
	trigger_entitystate_togglechecks();
	self.estate_trigger = ESTATE_DISABLE;
};

void() trigger_entitystate_reset = {
	trigger_entitystate_togglechecks();
	self.estate_trigger = ESTATE_RESET;
};

void() trigger_entitystate_aframe = {
	trigger_entitystate_togglechecks();
	self.estate_trigger = ESTATE_AFRAME;
};
//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
//
// Attributions: Frank Condello (aka pOx), Khreathor for the extras_r5 update
//
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
// Function count: 13
//
// Implements: Disableable Buttons and Parentable Switches
//
// Description:
// Disableable buttons.  Included for posterity and legacy support, but normal
// func_button supports this now.  Also has special switch that can be attached
// to func_train_ext entities as children.
//
// func_button_ext
// Simlilar to func_button, but can be disabled/enabled via triggers
// and allows for both touch and weapon hits to activate if specified.
//
// func_switch
// A two-state toggle that can use an alternate set of brushes as it's toggled
// state. You can "attach" a func_switch to a func_train_ext (switch goes where
// the train goes) but due to this, these don't move like buttons and are 
// always passthrough to avoid blocking issues (therefore, they can not be shot
// to activate).
//=============================================================================

float START_OFF = 1;
float ALWAYSTOUCH = 2;
float NOTONRETURN = 1;
float NOTOUCHRETURN = 2;

void() button_ext_wait;
void() button_ext_return;
void() switch_init;
void() switch_toggle;
void() switch_touch;

void() button_ext_wait = { // [FUNCTION]
	self.state = STATE_TOP;
	self.nextthink = self.ltime + self.wait;
	self.think = button_ext_return;
	activator = self.enemy;
	SUB_UseTargets();
};
	
void() button_ext_done = { // [FUNCTION]
	self.state = STATE_BOTTOM;
	if (self.health) self.takedamage = DAMAGE_YES;// can be shot again
	if (self.cnt) self.frame = 1; // Since it can be disabled before returning
	else self.frame = 0;// use normal textures
};

void() button_ext_return = { // [FUNCTION]
	self.state = STATE_DOWN;
	SUB_CalcMove (self.pos1, self.speed, button_ext_done);
	if (self.noise1) sound(self,CHAN_VOICE, self.noise1,1,ATTN_NORM);
};

void() button_ext_firedisabled = { // [FUNCTION]
	if (self.state != STATE_BOTTOM) return; // Don't fire unless it's totally reset
	
	if (self.noise2)sound(self,CHAN_VOICE, self.noise2,1,ATTN_NORM);
	if (self.event != "" && activator.classname == "player") centerprint (activator, self.event);
	self.state = STATE_UP; // Time out for a bit
	self.think = button_ext_done;
	self.nextthink = self.ltime + 1.0;
};

void() button_ext_fire = { // [FUNCTION]
	if (self.state != STATE_BOTTOM) return; // Don't fire unless it's totally reset
	
	self.frame = 1;// use alternate textures
	if (self.noise) sound(self,CHAN_VOICE, self.noise,1,ATTN_NORM);	
	self.state = STATE_UP;
	SUB_CalcMove (self.pos2, self.speed, button_ext_wait);
};

void() button_ext_use = { // [FUNCTION]
	self.enemy = activator;
	if (self.cnt) { // enable it
		self.cnt = FALSE;
		self.frame = 0;
	} else { // disable it
		self.cnt = TRUE;
		self.frame = 1;
	}
};

void() button_ext_touch = { // [FUNCTION]
	if (other.classname != "player") return;
	if (self.state != STATE_BOTTOM) return; // Don't fire unless it's totally reset
	
	self.takedamage = DAMAGE_NO;// don't allow shots before reset
	self.enemy = other;
	if (self.cnt) button_ext_firedisabled();
	else button_ext_fire();
};

void() button_ext_killed = { // [FUNCTION]
	self.enemy = damage_attacker;
	self.health = self.max_health;
	self.takedamage = DAMAGE_NO;
	
	if (self.cnt) button_ext_firedisabled();
	else button_ext_fire();
};

// QUAKED func_button_ext (0 .5 .8) ? START_OFF ALWAYSTOUCH
// "angle"			move direction
// "lip"			override the default 4 pixel lip remaining at end of move
// "speed"			override the default 40 speed
// "wait"			override the default 1 second wait (-1 = never return)
// "health"		if set, the button must be killed instead of touched
// "noise" 		Path to push noise
// "noise1"		Path to return noise
// "noise2"		Path to disabled noise
// "message" 		Print this message if used when disabled
// "target"		activate this entity when used
// "targetname" 	disable/enable buttons
// Spawnflags
// "START_OFF"		spanws in disabled state (must be triggered to be used)
// "ALWAYSTOUCH"	touch to activate, even if health>0
// NOTES:
// Setup is basically the same as func_button, but these work a little different...
// When a another trigger/button "uses" these, they will toggle between enabled
// and disabled mode - you can not press a disabled button (it just plays it's
// "disabled" sound). They can be disabled or enabled at any time, even
// while moving, but they will complete the move and return to the "up" position
// before enabling/disabling themselves in that case.
// They can not be fired again until they're "done" - they must be fully reset
// and enabled to be fired. The "active" texture frame (if it has texture frames)
// will only be displayed when the button is enabled, and fully in the "up"
// position (i.e. ready to be used).
void() func_button_ext = { // [ENTITY]
	if (self.noise) precache_sound(self.noise);
	if (self.noise1) precache_sound(self.noise1);
	if (self.noise2) precache_sound(self.noise2);
	SetMovedir();
	self.movetype = MOVETYPE_PUSH;
	self.solid = SOLID_BSP;
	setmodel(self, self.model);
	self.blocked = SUB_Null;
	self.use = button_ext_use;
	if (self.health) {
		self.max_health = self.health;
		self.th_die = button_ext_killed;
		self.takedamage = DAMAGE_YES;
		self.nobleed = TRUE;
		if (self.spawnflags & ALWAYSTOUCH) self.touch = button_ext_touch;
	} else self.touch = button_ext_touch;

	if (!self.speed) self.speed = 40;
	if (!self.wait) self.wait = 1;
	if (!self.lip) self.lip = 4;
	if (self.spawnflags & START_OFF) {
		self.cnt = TRUE;
		self.frame = 1;
	}

	// Not a "real" message
	if (self.message != "") {
		self.event = self.message;
		self.message = "";
	}

	self.state = STATE_BOTTOM;
	self.pos1 = self.origin;
	self.pos2 = self.pos1 + self.movedir*(fabs(self.movedir*self.size) - self.lip);
};

void() switch_wait = { // [FUNCTION]
	self.touch = switch_touch;
	switch_toggle();
};

void() switch_toggle = { // [FUNCTION]
	if (self.attack_finished > time) self.cnt = TRUE; // Don't toggle again until player moves off
	else self.cnt = FALSE;

	self.attack_finished = time + 0.1;
	if (self.cnt) return;

	if (self.state == STATE_UP) {
		if (self.noise) sound(self,CHAN_VOICE, self.noise,1,ATTN_NORM);
		self.state = STATE_DOWN;
		self.frame = 1; // alt texture
		if (self.mdl) setmodel(self, self.mdl);// alt model	
		activator = self.enemy;
		SUB_UseTargets();
		if (self.spawnflags & NOTOUCHRETURN) self.touch = SUB_Null; // Can't touch till reset
		
		// Check for auto-reset
		if (self.wait > 0) {	
			self.think = switch_wait;
			self.nextthink = time + self.wait;
		}
	} else {		
		if (self.noise1) sound(self,CHAN_VOICE, self.noise1,1,ATTN_NORM);
		self.state = STATE_UP;
		self.frame = 0;
		if (self.mdl) setmodel(self, self.weaponmodel);	
		if (!(self.spawnflags & NOTONRETURN)) {
			activator = self.enemy;
			SUB_UseTargets();
		}
		self.touch = switch_touch; // Make sure it can be touched
	}
};

void() switch_use = { // [FUNCTION]
	self.enemy = activator;
	switch_toggle();
};

void() switch_touch = { // [FUNCTION]
	if (other.classname != "player") return;
	
	if (self.movedir != '0 0 0') {
		makevectors(other.angles);
		if (v_forward * self.movedir < 0) self.attack_finished = time + 0.1;// not facing the right way
	}
	
	self.enemy = other;
	switch_toggle();
};

void() switch_init = { // [FUNCTION]
	local string temp;
		
	temp = self.target;
	self.target = self.event;
	train_ext_linkchild();
	self.target = temp;
	self.use = switch_use;
	self.touch = switch_touch;
};

// QUAKED func_switch (0 .5 .8) ? NOTONRETURN NOTOUCHRETURN
// A toggle (think light switch). Activates it's targets when touched, and changes
// it's texture frame and/or model. It can toggle back automatically or require a
// re-trigger/touch (default behaviour).
// "wait"			Returns to original state after "wait" seconds (default is -1, wait for re-trigger)
// "angle"			Angle player must be facing in order to activate by touch
// "noise" 		Path to push noise
// "noise1"		Path to optional reset noise ("noise" is used if ommited, use "misc/null.wav" for silent return)
// "target"		Activate this entity when used
// "event"			Parent train (ya, "event" is kind of a dumb key name for this...)
// "targetname" 	Toggle switch remotelty, or just for func_bspframe's sake
// Spawnflags
// "NOTONRETURN"	Don't use targets when returning to initial state
// "NOTOUCHRETURN" Only returns to initial state if triggered remotely, or after wait expires (like a button)
// NOTES:
// A func_bspframe entity that targets a func_switch is used as the alternate model frame.
// To avoid big headaches with child movement on trains, these are always pass-through
// objects - make'em small or flat. This also means you can't shoot'em, but a normal trigger
// with health can trigger a func_switch if you need that effect (won't work on a moving
// train of course)
// Although an alternate model can be used, the texture frame is also switched when toggled
// so simple animated switches can be made without the need for a func_bspframe.
void() func_switch = { // [ENTITY]
	if (self.noise) precache_sound(self.noise);
	if (!self.noise1) self.noise1 = self.noise;	
	if (self.noise1) precache_sound(self.noise1);

	if (self.angles != '0 0 0') SetMovedir();
	self.solid = SOLID_TRIGGER;
	self.movetype = MOVETYPE_NONE;
	setmodel(self, self.model);
	setsize (self, self.mins , self.maxs);
	setorigin(self, self.origin);
	self.weaponmodel = self.model;
	if (!self.wait) self.wait = -1;// Default is true toggle
	self.state = STATE_UP;
	
	// Attach to it's parent
	if (self.event) {
		self.think = switch_init;
		self.nextthink = time + 0.2;// start after first frame to allow train to move to it's startpoint
	} else {
		self.use = switch_use;
		self.touch = switch_touch;
	}
};
//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by W. Josiah Jack, aka Qmaster
//
// Attributions: All, see credits folder
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
// Function count: 7
//
// Implements: Switchable Shadow (lightmaps) Brush Entities
//
// Description:
// Requires Eric Waylishen's (ericw) updated compilers.  This allows for having
// toggleable shadows and flickering lights so that some entities such as
// torches don't have to be static only but can be destroyed and have their
// light dissappear as well.  This also allows for flooding light into a dark
// area when a wall crumbles or a door opens.
//
// The light/shadow lightscale is from A -> M (13 steps)
// The full range is A -> Z, but M -> Z is overbright
// Dividing fading times by 13 is just an awkward result
// It will be much easier if times are divided by 10
// especially as the game/mod tick timer is 0.1s
//=============================================================================

float SWITCH_ARRAY_OFF = 0;		// Off value for shadow (light off)
float SWITCH_ARRAY_ON = 9;		// On value for shadow (light on)
float SWITCH_ARRAY_MAX = 10;	// Maximum amount of shadow steps
float SWITCH_SHADOW_DOWN = -1;	// Direction for shadow fading controller
float SWITCH_SHADOW_UP = 1;
float FUNC_SHADOW_FADING = 1;	// Does the shadow fade in/out (trigger)
.float switchshadstyle;	// Switchable style for bmodels (shadows)
.entity	switchfader; // Controller for fading shadows on bmodels
string shad_str[10]; // The array is setup from world.qc before anything loads

void() switch_shadow_setuparray = { // [FUNCTION]
	shad_str[0] = "a";  shad_str[1] = "c"; // Missing B
	shad_str[2] = "d";  shad_str[3] = "e";
	shad_str[4] = "f";  shad_str[5] = "h"; // Missing G
	shad_str[6] = "i"; 	shad_str[7] = "j";
	shad_str[8] = "k";  shad_str[9] = "m"; // Missing L
};

void() switch_shadow_on = { // [FUNCTION]
	if (self.switchshadstyle < 1) return; // Check there is a shadow lightstyle first?  This usually 1-31 (QC defined) and 32-64 (Map defined).
	
	lightstyle(self.switchshadstyle, shad_str[SWITCH_ARRAY_OFF]);
};

void() switch_shadow_off = { // [FUNCTION]
	if (self.switchshadstyle < 1) return; // Check there is a shadow lightstyle first?  This usually 1-31 (QC defined) and 32-64 (Map defined).
	
	lightstyle(self.switchshadstyle, shad_str[SWITCH_ARRAY_ON]);
};

// QUAKED func_shadow (0 .5 .8) ? x FADING x x x x STARTOFF x Not_Easy Not_Normal Not_Hard Not_DM
// An Invisible bmodel that casts shadows
// -------- KEYS --------
// targetname  : trigger entity (works with entity state system)
// target      : Func bmodel entity to operate in sync with
// state       : Intended state to operate with (0=CLOSED, 1=OPEN)
// speed       : Fade in/out timer for the shadow (def=1s)
// _dirt       : -1 = will be excluded from dirtmapping
// _minlight   : Minimum light level for any surface of the brush model
// _mincolor   : Minimum light color for any surface (def='1 1 1' RGB)
// _shadow     : Will cast shadows on other models and itself
// _shadowself : Will cast shadows on itself
// _switchableshadow : 1 = Required parameter
// -------- SPAWNFLAGS --------
// FADING   : Will gradually fade over time (speed)
// STARTOFF : Starts off and waits for trigger
// -------- NOTES --------
// An Invisible bmodel that casts shadows. It is recommended to paint
// these with a special unique texture so they can be filtered or hidden
// from view in the editor. This function will not work if brushwork is
// painted with clip or skip textures. Recommend to use trigger.
void() func_shadow_controller = { // [FUNCTION]
	local entity tself;
	
	// There are 3 different states of the controller
	// 1. Doing nothing, waiting for changes
	// 2. Detecting changes, start fade process
	// 3. Busy Fading, keep track of direction
	self.think = func_shadow_controller;
	self.nextthink = time + 0.1;
	if (self.estate != self.owner.estate) self.estate = self.owner.estate; // Has the func_shadow entity state changed
	if (self.state != 0) {
		self.owner.count = self.owner.count + self.lip;
		if (self.owner.count <= SWITCH_ARRAY_OFF) { 
			self.owner.count = SWITCH_ARRAY_OFF;
			self.state = 0;
		} else if (self.owner.count >= SWITCH_ARRAY_ON) {
			self.owner.count = SWITCH_ARRAY_ON;
			self.state = 0;
		}
		// Switch around self because lightstyle function
		tself = self;
		self = self.owner;
		lightstyle(self.switchshadstyle, shad_str[self.count]);
		self = tself;
	}
};

void() func_shadow_setup_controller = { // [FUNCTION]
	dprint("func_shadow_setup_controller");
	self.switchfader = spawn();
	self.switchfader.classtype = CT_CONTROL;
	self.switchfader.owner = self; // Make sure link back to source entity
	self.switchfader.movetype = MOVETYPE_NONE;
	self.switchfader.solid = SOLID_NOT;
	setorigin(self.switchfader, self.oldorigin); // Move controller entity close to shadow entity
	setsize (self.switchfader, VEC_ORIGIN, VEC_ORIGIN);
	self.switchfader.state = 0; // Setup default state and keep monitoring for changes
	self.switchfader.think = func_shadow_controller;
	self.switchfader.nextthink = time + 0.1;
};

void() func_shadow_on = { // [FUNCTION]
	self.spawnflags = self.spawnflags - (self.spawnflags & ENT_STARTOFF); // No longer need this spawnflag, remove it
	self.estate = ESTATE_ON; // Setup final shadow style
	if (self.speed == FALSE) switch_shadow_on(); // if there is no fade timer, set absolute value
};

void() func_shadow_off = { // [FUNCTION]
	self.estate = ESTATE_OFF; // Setup final shadow style
	if (self.speed == FALSE) switch_shadow_off(); // if there is no fade timer, set absolute value
};

void() func_shadow = { // [ENTITY]
	if (check_bmodel_keys()) return;	// Check for bmodel errors

	self.classtype = CT_FUNCSHADOW;
	self.bsporigin = TRUE;
	self.angles = '0 0 0';
	self.mdl = self.model;
	setmodel(self, self.mdl);
	self.oldorigin = bmodel_origin(self); // Add bmodel to world and find origin location
	
	// Check if switchable shadow (lightmap) has been defined
	// The entity key points to a light map (32-64) if its active
	if (self.switchshadstyle == 0) { dprint("\b[FUNC_SHADOW]\b Missing _switchableshadow entity key! Set to 32.\n"); self.switchshadstyle = 32; }
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	setmodel(self, ""); // The Shadow bmodels need to be invisible

	// Check for fading function
	if (self.spawnflags & FUNC_SHADOW_FADING) {
		if (self.speed <= 0) self.speed = 1;
		func_shadow_setup_controller();
	} else self.speed = 0;

	if (self.targetname != "") self.use = entity_state_use; // Setup Entity State functionality
	self.estate_on = func_shadow_on;
	self.estate_off = func_shadow_off;
	if (self.spawnflags & ENT_STARTOFF) self.estate_off();
	else self.estate_on();
};

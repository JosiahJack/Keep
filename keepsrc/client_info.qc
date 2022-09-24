//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by W. Josiah Jack, aka Qmaster
//
// Attributions: ID1, Rogue, and Arcane Dimensions (AD)
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
// Entity count: 15
// Function count: 17
//
// Implements: Player starts and helper entities
//
// Description:
// Various entities and their supporting functions for starting locations,
// teleport destinations, targetting points, and other helpers.
//=============================================================================

void() info_null = { remove(self); };

// Hack tool.  Sometimes this entity is used as point or bmmodel entity; It depends on the mapper and what they are trying to do.
void() info_notnull = {};

void() info_target = {};

// New skyroom feature for QSS clients
void() info_skyroom = { remove(self); };

// QUAKED info_player_start (1 0 0) (-16 -16 -24) (16 16 24) x x x x x x x x Not_Easy Not_Normal Not_Hard Not_DM Dyn_Easy Dyn_Normal Dyn_Hard Dyn_Night
// { model(":progs/player.mdl"); }
// DEFAULT starting point for a player
// -------- KEYS --------
// target : triggered target(s) when used as a client destination
// angle  : Starting view angle
// -------- SPAWNFLAGS --------
// -------- NOTES --------
// DEFAULT starting point for a player
// Doesn't actually do anything, just searched for by name inside client.qc elsewhere
void() info_player_start = { 
	self.classtype = CT_SPAWNSP;
	self.estate = ESTATE_ON;
}; 

// QUAKED info_player_startdev (1 1 0.5) (-16 -16 -24) (16 16 24) x x x x x x x x Not_Easy Not_Normal Not_Hard Not_DM Dyn_Easy Dyn_Normal Dyn_Hard Dyn_Night
// { model(":progs/player.mdl"); }
// DEFAULT starting point for a DEVELOPER only
// -------- KEYS --------
// target : triggered target(s) when used as a client destination
// angle  : Starting view angle
// -------- SPAWNFLAGS --------
// -------- NOTES --------
// DEFAULT starting point for a DEVELOPER only
void() info_player_startdev = { 
	self.classtype = CT_SPAWNSP;
	self.estate = ESTATE_ON;
};

// QUAKED info_player_start2 (0.9 0 0) (-16 -16 -24) (16 16 24) x x x x x x x x Not_Easy Not_Normal Not_Hard Not_DM Dyn_Easy Dyn_Normal Dyn_Hard Dyn_Night
// { model(":progs/player.mdl"); }
// Starting point for players with runes or startspawn2 system
// -------- KEYS --------
// target : triggered target(s) when used as a client destination
// angle  : Starting view angle
// startspawn2 : Unique spawn location number matching a trigger_changelevel
// -------- SPAWNFLAGS --------
// -------- NOTES --------
// Starting point for players with runes or using the startspawn2 system
// The startspawn2 system lets players move between maps using exact location
void() info_player_start2 = { 
	self.classtype = CT_SPAWNSP;
	self.estate = ESTATE_ON;
};

//QUAKED info_player_coop (1 0 1) (-16 -16 -24) (16 16 24) x x x x x x STARTOFF x Not_Easy Not_Normal Not_Hard Not_DM
// { model(":progs/player.mdl"); }
// Starting position for coop games
// -------- KEYS --------
// target : triggered target(s) when used as a client destination
// angle  : Starting view angle
// -------- SPAWNFLAGS --------
// STARTOFF : Starts off
// -------- NOTES --------
// Starting position for coop games
void() info_player_coop = { 
	self.classtype = CT_SPAWNCOOP;
	if (self.spawnflags & MON_SPAWN_DELAY) self.estate = ESTATE_OFF;
	else self.estate = ESTATE_ON;
	// Setup Entity State functionality
	if (self.targetname != "") self.use = entity_state_use;
};

void() info_player_coop2 = {
	info_player_coop();
};

//QUAKED info_player_deathmatch (0 1 1) (-16 -16 -24) (16 16 24) x x x x x x STARTOFF x Not_Easy Not_Normal Not_Hard Not_DM
// { model(":progs/player.mdl"); }
// Starting position for deathmatch games
// -------- KEYS --------
// target : triggered target(s) when used as a client destination
// angle  : Starting view angle
// -------- SPAWNFLAGS --------
// STARTOFF : Starts off
// -------- NOTES --------
// Starting position for deathmatch games
void() info_player_deathmatch = { 
	self.classtype = CT_SPAWNDM;
	if (self.spawnflags & MON_SPAWN_DELAY) self.estate = ESTATE_OFF;
	else self.estate = ESTATE_ON;
	// Setup Entity State functionality
	if (self.targetname != "") self.use = entity_state_use;
};

// CTF Spawn Red Team - Soviets
void() info_player_team1 = { 
	self.classtype = CT_SPAWNDM;
	self.estate = ESTATE_ON;
};

// CTF Spawn Blue Team - Allies
void() info_player_team2 = { 
	self.classtype = CT_SPAWNDM;
	self.estate = ESTATE_ON;
};

//QUAKED info_teleport_destination (1 0.5 0.5) (-8 -8 -8) (8 8 32) x
// Destination marker for a teleporter
// -------- KEYS --------
// targetname : link to trigger_teleport
// target : fires when the entities is used as a destination
// angles : Pitch Yaw Roll (viewing angle after teleporting)
// -------- SPAWNFLAGS --------
// -------- NOTES --------
// Destination marker for a teleporter
void() info_teleport_angle = { // [FUNCTION]
	self.movetarget = find(world, targetname, self.angletarget); // Find angletarget entity in world
	if (self.movetarget) {
		if (self.bsporigin) self.dest1 = bmodel_origin(self); // Check for bmodel origin on self/angletarget entities
		else self.dest1 = self.origin;
		
		if (self.movetarget.bsporigin) self.dest2 = bmodel_origin(self.movetarget); // Find the destination origin
		else self.dest2 = self.movetarget.origin;
		
		self.dest1 = self.dest1 - self.view_ofs;				// Update Z axis for any editor offset information
		self.movedir = normalize(self.dest2 - self.dest1);		// Create directional vector from source to target
		self.mangle = vectoangles(self.movedir);				// Convert vector direction to angles
		spawn_marker(self.dest1, self.mangle,1,SPNMARK_YELLOW);	// Spawn a dev marker for visual reasons
	} else {
		dprint("\b[INFO_TELE]\b angletarget is missing!\n"); // Display console error and diamond in game
		if (self.bsporigin) spawn_marker(self.oldorigin,'0 0 0',0,SPNMARK_YELLOW);
		else spawn_marker(self.origin,'0 0 0',0,SPNMARK_YELLOW);
		
		self.angletarget = ""; // Reset angletarget field, its broken and not needed
	}
};

void() info_teleport_convert_updown = { // [FUNCTION]
	// Setup special mangle/movedir: editor -1 = UP and -2 = DOWN
	if (self.mangle == '0 -1 0') {
		self.mangle = '270 0 0'; self.movedir = '0 0 1';
	} else if (self.mangle == '0 -2 0') {
		self.mangle = '90 0 0'; self.movedir = '0 0 -1';
	}
};

void() info_teleport_destination = {
	self.classtype = CT_MISCTELEPORT;
	self.estate = ESTATE_ON;
	self.mangle = self.angles;	// Save for later
	self.angles = '0 0 0';		// Don't need to be zero, previous code
	self.view_ofs = '0 0 27';	// Z axis modifier for editor placement
	self.origin = self.origin + self.view_ofs;
	info_teleport_convert_updown();
	if (SUB_HideIfNoTargetname()) return;

	if (self.teledest < 0) { // Check for destination number errors
		dprint("\b[INFO_TELE]\b Dest value cannot be negative, set to 0.\n");
		spawn_marker(self.origin,'0 0 0',0,SPNMARK_YELLOW);
		self.teledest = 0;
	}

	// Check for angle target setup
	if (self.angletarget != "") {
		self.nextthink = time + 0.1 + random();
		self.think = info_teleport_angle;
	}
};

// QUAKED info_camera_destination (1 0.5 0.5) (-16 -16 -24) (16 16 32) x
// Marker for a Cinematic Camera System
// -------- KEYS --------
// targetname : link to misc_camera entity
// angles : Pitch Yaw Roll (facing angle)
// -------- SPAWNFLAGS --------
// -------- NOTES --------
// Marker for a Cinematic Camera System
void() info_camera_destination = {
	self.classtype = CT_MISCTELCAMERA;
	self.estate = ESTATE_ON;
};

// QUAKED info_teleportinstant_dest (.5 .5 .5) ? x
// Destination for an instant teleporter
// -------- KEYS --------
// targetname : link to trigger_teleport
// target     : fires when used as a destination (works only once)
// angletarget: targeting entity used for custom direction
// angles     : Pitch Yaw Roll (destination angle after teleporting)
// teledest   : Unique number for multiple teleporter destinations
// -------- SPAWNFLAGS --------
// -------- NOTES --------
// Destination for an instant teleporter
void() info_teleportinstant_dest = {
	if (check_bmodel_keys()) return;	// Check for bmodel errors

	self.classtype = CT_MISCTELINSTANT;
	self.estate = ESTATE_ON;
	self.mangle = self.angles;	// Save for later
	self.angles = '0 0 0';		// Zero'd to prevent bmodel twisting
	self.view_ofs = '0 0 0';	// Z axis modifier for editor placement
	info_teleport_convert_updown();
	self.solid = SOLID_NOT; // Stuff from InitTrigger
	self.movetype = MOVETYPE_NONE;
	self.mdl = self.model;		// Save model for later
	setmodel(self, self.mdl);	// set size and link into world
	self.bbmins = self.mins;	// Save bmodel bounds for later
	self.bbmaxs = self.maxs;
	self.bsporigin = TRUE;
	self.oldorigin = bmodel_origin(self); // Work out true volume origin
	setmodel(self, ""); // Don't need volume brush anymore
	setsize(self, VEC_ORIGIN, VEC_ORIGIN); 
	if (SUB_HideIfNoTargetname()) return;

	if (self.teledest < 0) { // Check for destination number errors
		dprint("\b[INFO_TELE]\b Dest value cannot be negative\n");
		spawn_marker(self.oldorigin,'0 0 0',0,SPNMARK_YELLOW);
		self.teledest = 0;
	}

	// Check for angle target setup
	if (self.angletarget != "") {
		self.nextthink = time + 0.1 + random();
		self.think = info_teleport_angle;
	}
};

// QUAKED info_intermission (1 0.5 0.5) (-16 -16 -16) (16 16 16) NO_INTERMIS SOLID x x x x x x Not_Easy Not_Normal Not_Hard Not_DM
// This is the camera point for the intermission
// -------- KEYS --------
// target : triggered target(s) when used as a viewing camera
// mangle : Pitch Yaw Roll
// fog_density : fog density (Must be >0 to activate feature)
// fog_colour  : fog colours (def=0.1 0.1 0.1)
// speed       : fog time to change (def=2s)
// -------- SPAWNFLAGS --------
// NO_INTERMIS : Will not display when proper intermission active
// SOLID       : Intermission camera interacts with world
// -------- NOTES --------
// mangle = up/down, angle, tilt left/right 'pitch roll yaw'
// up/left = negative value, down/right = positive value
void() info_intermission = {
	self.classtype = CT_CAMERA;
	self.estate = ESTATE_ON;
	setsize (self, VEC_ORIGIN, VEC_ORIGIN);
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	setmodel(self, MODEL_EMPTY);
	self.view_ofs = '0 0 0';
	self.owner = self;

	if (self.fog_density > 0) { // Check for any trigger fog parameters
		if (!self.speed) self.speed = 2;
		if (self.fog_density > 1) self.fog_density = 1; // Double check its within range
		if (VectorIsAllZeros(self.fog_colour)) self.fog_colour = '0.1 0.1 0.1';
	} else self.fog_density = 0; // Disable fog trigger if density not setup
};
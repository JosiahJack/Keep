//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
//
// Attributions: Quoth, Arcane Dimensions (AD), Qmaster
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
// Entity count: 25
// Function count: 4
//
// Implements: Corpses
//
// Description:
// Various dead bodies that are more than simple misc_models but have subtle
// animations such as dangling in the breeze.  Supports various legacy
// entity references.
//=============================================================================

// All dead bodies use the same on/off states
void() misc_deadbody_on = { // [FUNCTION]
	if (self.gibbed == TRUE) return;

	self.estate = ESTATE_ON;			// Show entity
	self.solid = SOLID_NOT;				// No world interaction
	self.movetype = MOVETYPE_NONE;		// Static item, no movement
	setmodel(self,self.mdl);			// Show model
	setsize (self, self.bbmins, self.bbmaxs);
	self.bodyonflr = MON_ONFLR;			// Let Shadow Axe interact
};

void() misc_deadbody_off = { // [FUNCTION]
	if (self.gibbed == TRUE) return;

	self.estate = ESTATE_OFF;		// Hide entity
	self.solid = SOLID_NOT;			// No world interaction
	self.movetype = MOVETYPE_NONE;	// Static item, no movement
	setmodel(self,"");				// Show model
	setsize (self, VEC_ORIGIN, VEC_ORIGIN);
	self.bodyonflr = "";			// No Shadows Axe interaction
};

void() misc_deadbody_setup = { // [FUNCTION]
	self.classtype = CT_MISCMODEL;
	self.classgroup = CG_MISCENT;
	self.oldorigin = self.origin;		// Store for later
	self.takedamage = DAMAGE_NO;		// No projectile interaction
	self.deadflag = DEAD_DEAD;			// Body is really dead!
	self.health = self.max_health = -1;
	self.blockudeath = TRUE;			// Body is dead, no human death noise
	self.gibbed = FALSE;				// Still in one piece!
	if (self.angles_y < 0) self.angles_y = rint(random()*360); // Check for random rotation
	if (self.targetname != "") self.use = entity_state_use; // Setup Entity State functionality
	self.estate_on = misc_deadbody_on;
	self.estate_off = misc_deadbody_off;
	if (self.spawnflags & ENT_STARTOFF) entity_state_off();
	else entity_state_on();
};

// QUAKED misc_player (1 .5 .25) (-16 -16 -24) (16 16 32) x x x x x x STARTOFF x
// -------- KEYS --------
// targetname : toggle state (use trigger ent for exact state)
// angle  : facing angle (-1 = random position)
// frame  : body pose (49=on back, 67-69=against wall, 60/84/93=face down, 102=on side)
// exactskin : -1= Random, 0-1 Original, 2-3 Green, 4-5 Yellow, 6-7 Red
// -------- SPAWNFLAGS --------
// STARTOFF : Always Starts off and waits for trigger
// -------- NOTES --------
// Dead Player MDL for poses
void() misc_player = { // [ENTITY]
	self.mdl = "progs/ad171/misc_player.mdl";		// Standard player model
	self.gib1mdl = "progs/ad171/w_soldiergun.mdl";	// Unique weapon
	self.gib2mdl = "progs/ad171/gib_soldfoot1.mdl";	// Upright foot
	self.gib3mdl = "progs/ad171/gib_soldfoot2.mdl";	// Fallen down foot
	precache_model (self.mdl);
	precache_model (self.gib1mdl);
	precache_model (self.gib2mdl);
	precache_model (self.gib3mdl);
	self.gib1sound = GIB_IMPACT_WOOD;
	if (self.bboxtype < 1) self.bboxtype = BBOX_SHORT; // uses short standard knight bounding box
	monster_bbox();
	if (self.exactskin < 0) self.exactskin = rint(0.5 + random()*7); // Setup random/exact skin choices
	if (self.exactskin > 7) self.exactskin = 7;
	self.skin = self.exactskin;
	misc_deadbody_setup();
};

// QUAKED misc_demon (1 .5 .25) (-32 -32 -24) (32 32 64) x x x x x x STARTOFF x
// -------- KEYS --------
// targetname : toggle state (use trigger ent for exact state)
// angle  : facing angle (-1 = random position)
// frame : body pose (53=on back - def)
// exactskin : -1= Random, 0= Original, 1= Green
// -------- SPAWNFLAGS --------
// STARTOFF : Always Starts off and waits for trigger
// -------- NOTES --------
// Dead demon/fiend for poses
void() misc_demon = { // [ENTITY]
	self.mdl = "progs/mon_demon.mdl";
	self.headmdl = "progs/h_demon.mdl";
	self.gib1mdl = "progs/ad171/gib_dmleg1.mdl";		// Left leg
	self.gib2mdl = "progs/ad171/gib_dmleg2.mdl";		// Right leg
	self.gib3mdl = "progs/ad171/gib_dmtail.mdl";		// Tail
	self.gib4mdl = "progs/ad171/gib_dmclaw1.mdl";		// Claw 1
	self.gib5mdl = "progs/ad171/gib_dmclaw2.mdl";		// Claw 2
	precache_model (self.mdl);
	precache_model (self.headmdl);
	precache_model (self.gib1mdl);
	precache_model (self.gib2mdl);
	precache_model (self.gib3mdl);
	precache_model (self.gib4mdl);		// Always precache extra models
	precache_model (self.gib5mdl);		// regardless if picked or not
	if (random() < 0.5) self.gib1mdl = self.gib4mdl; // Randomly swap in demon claws instead of legs
	if (random() < 0.5) self.gib2mdl = self.gib5mdl;
	if (self.bboxtype < 1) self.bboxtype = BBOX_WIDE; // Setup bounding box based on presets
	monster_bbox();
	if (self.frame < 0) self.frame = 0; // Default pose for dead demons
	if (self.frame == 0) self.frame = 53;
	if (self.exactskin < 0) { // Setup random/exact skin choices
		if (random() < 0.5) self.exactskin = 0;
		else self.exactskin = 1;
	}
	if (self.exactskin > 1) self.exactskin = 1;
	self.skin = self.exactskin;
	self.gib1skin = self.gib2skin = self.gib3skin = self.skin; // Sync gib model skin to demon skin.
	misc_deadbody_setup();	
};

// QUAKED misc_dknight (0.75 0.25 0) (-16 -16 -24) (16 16 40) x x x x x x STARTOFF x
// -------- KEYS --------
// targetname : toggle state (use trigger ent for exact state)
// angle  : facing angle (-1 = random position)
// frame : body pose (223=on front, 237-243=on back - def)
// -------- SPAWNFLAGS --------
// STARTOFF : Always Starts off and waits for trigger
// -------- NOTES --------
// Dead Death Knight for poses
void() misc_dknight = { // [ENTITY]
	self.mdl = "progs/ad171/mon_dknight.mdl";			// New Hell Knight
	self.headmdl = "progs/ad171/h_dknight.mdl";
	self.gib1mdl = "progs/ad171/w_dknightsword.mdl";	// Unique sword
	self.gib2mdl = "progs/ad171/gib_knfoot_l.mdl";	// left foot
	self.gib3mdl = "progs/ad171/gib_knfoot_r.mdl";	// right foot
	precache_model (self.mdl);
	precache_model (self.headmdl);
	precache_model (self.gib2mdl);
	precache_model (self.gib3mdl);
	precache_model (self.gib1mdl);
	self.gib1sound = GIB_IMPACT_METALA;
	if (random() < 0.5) self.gib2mdl = string_null;
	if (random() < 0.5) self.gib3mdl = string_null;
	if (self.bboxtype < 1) self.bboxtype = BBOX_TALL; // Setup bounding box based on presets
	monster_bbox();
	if (self.frame < 0) self.frame = 0; // Default pose for dead death knights
	if (self.frame == 0) self.frame = 243;
	misc_deadbody_setup();	
};

void(string modelstr, float frameno, float skinno) corpse_setup = { // [FUNCTION]
	if (self.mdl == "") self.mdl = modelstr;
	precache_model(self.mdl);
	setmodel(self,self.mdl);
	if (frameno >= 0) self.frame = frameno;
	if (skinno >= 0) self.skin = skinno;
	self.gib1sound = GIB_IMPACT_WOOD;
	if (self.bboxtype < 1) self.bboxtype = BBOX_TALL; // Setup bounding box based on presets
	monster_bbox();
	misc_deadbody_setup();
};

void() corpse_flayed1 = { corpse_setup("progs/quoth/corpse_flay.mdl",0,0); };  // [ENTITY]

void() corpse_flayed2 = { corpse_setup("progs/quoth/corpse_flay.mdl",0,1); }; // [ENTITY]

void() corpse_flayed3 = { corpse_setup("progs/quoth/corpse_flay.mdl",2,2); }; // [ENTITY]

void() corpse_flayed4 = { corpse_setup("progs/quoth/corpse_flay.mdl",1,1); }; // [ENTITY]

void() corpse_lynched1 = { corpse_setup("progs/quoth/corpse_lynch.mdl",0,0); }; // [ENTITY]

void() corpse_lynched2 = { corpse_setup("progs/quoth/corpse_lynch.mdl",0,0); }; // [ENTITY]

void() corpse_lynched3 = { corpse_setup("progs/quoth/corpse_lynch.mdl",1,2); }; // [ENTITY]

void() corpse_crucified1 = { corpse_setup("progs/quoth/corpse_imp.mdl",7,9); }; // [ENTITY]

void() corpse_crucified2 = { corpse_setup("progs/quoth/corpse_imp.mdl",8,10); }; // [ENTITY]

void() corpse_impaled_back1 = { corpse_setup("progs/quoth/corpse_imp.mdl",0,0); }; // [ENTITY]

void() corpse_impaled_back2 = { corpse_setup("progs/quoth/corpse_imp.mdl",0,1); }; // [ENTITY]

void() corpse_impaled_back3 = { corpse_setup("progs/quoth/corpse_imp.mdl",1,2); }; // [ENTITY]

void() corpse_impaled_front1 = { corpse_setup("progs/quoth/corpse_imp.mdl",2,0); }; // [ENTITY]

void() corpse_impaled_front2 = { corpse_setup("progs/quoth/corpse_imp.mdl",2,1); }; // [ENTITY]

void() corpse_impaled_front3 = { corpse_setup("progs/quoth/corpse_imp.mdl",3,3); }; // [ENTITY]

void() corpse_impaled_horizontal1 = { corpse_setup("progs/quoth/corpse_imp.mdl",4,0); }; // [ENTITY]

void() corpse_impaled_horizontal2 = { corpse_setup("progs/quoth/corpse_imp.mdl",4,1); }; // [ENTITY]

void() corpse_impaled_horizontal3 = { corpse_setup("progs/quoth/corpse_imp.mdl",5,4); }; // [ENTITY]

void() corpse_impaled_horizontal4 = { corpse_setup("progs/quoth/corpse_imp.mdl",6,5); }; // [ENTITY]

void() corpse_impaled_vertical1 = { corpse_setup("progs/quoth/corpse_imp.mdl",7,0); }; // [ENTITY]

void() corpse_impaled_vertical2 = { corpse_setup("progs/quoth/corpse_imp.mdl",7,1); }; // [ENTITY]

void() corpse_impaled_vertical3 = { corpse_setup("progs/quoth/corpse_imp.mdl",8,6); }; // [ENTITY]
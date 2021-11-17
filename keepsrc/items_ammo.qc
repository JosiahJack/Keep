//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by W. Josiah Jack, aka Qmaster
//
// Attributions: All
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
// Entity count: 12
// Function count: 2
//
// Implements: Ammo Entities
//
// Description:
// Contains the entity definitions for ammo item pickups and related helper
// functions.
//=============================================================================

void() item_ammo_setup = {
	self.frame = 0;
	self.touch2 = ammo_touch;
	self.classgroup = CG_AMMOITEM;
	self.bbmins = VEC_ITEM_MIN;
	self.bbmaxs = VEC_ITEM_MAX;
	if (self.respawn_time == 0) self.respawn_time = RESPAWN_AMMO;
	self.noise = AMMO_PICKUP;
	self.aused = 0;
	if (self.item_tossvel > 0) self.spawnflags = self.spawnflags - (self.spawnflags & A_LID); // Items that spawn from pots with toss velocity should not have any lid options (remove them).

	// Query console variable 'temp1' for model upgrade option.
	// Cannot use global vars because they don't exist at this point
	// Move the new centered ammo models to match old ammo origin
	// The default is to move all ammo items to suit original id maps
	if (!query_configflag(SVR_ITEMOFFSET)) {
		self.oldorigin = self.origin + '16 16 0';
		setorigin(self, self.oldorigin);
	}

	self.skin = (self.skin_override == 2); // Setup the skin parameter for ammo boxes
	if (self.classtype == CT_AMMOPOISON) self.skin = 0;
	if (world.no_item_rotate && self.angles_y == 0) self.angles_y = 360; // Will force all items to have an angle	
	if (self.angles_y <= 0) self.angles_y = rint(random()*359); // Setting the angle key in the editor to UP/DOWN = random rotation	

	// Setup lid attachment entity (defined in item setup)
	if (self.spawnflags & A_LID) {
		self.attachment = spawn();
		self.attachment.owner = self;
		setorigin(self.attachment, self.origin);
		self.attachment.solid = SOLID_NOT;
		self.attachment.movetype = MOVETYPE_NONE;
	}

	item_coopcheck();
	item_start ();
};

void() ammo_touch = {
	if (self.classtype == CT_AMMOSHELLS) {
		if (other.ammo_shells >= AMMO_MAXSHELLS) return;
		other.ammo_shells = other.ammo_shells + self.aflag;
	} else if (self.classtype == CT_AMMONAILS) {
		if (other.ammo_nails >= AMMO_MAXNAILS) return;
		other.ammo_nails = other.ammo_nails + self.aflag;
	} else if (self.classtype == CT_AMMOROCKETS) {
		if (other.ammo_rockets >= AMMO_MAXROCKETS) return;
		other.ammo_rockets = other.ammo_rockets + self.aflag;
	} else if (self.classtype == CT_AMMOCELLS) {
		if (other.ammo_cells >= AMMO_MAXCELLS) return;
		other.ammo_cells = other.ammo_cells + self.aflag;
	} else if (self.classtype == CT_AMMOPLASMA) {
		if (other.ammo_plasma >= AMMO_MAXPLASMA) return;
		other.ammo_plasma = other.ammo_plasma + self.aflag;
	} else if (self.classtype == CT_AMMOMULTIROCKETS) {
		if (other.ammo_multi_rockets >= AMMO_MAXMULTIROCKETS) return;
		other.ammo_multi_rockets = other.ammo_multi_rockets + self.aflag;
	} else if (self.classtype == CT_AMMOLAVANAILS) {
		if (other.ammo_lava_nails >= AMMO_MAXLAVANAILS) return;
		other.ammo_lava_nails = other.ammo_lava_nails + self.aflag;
	} else if (self.classtype == CT_AMMOPOISON) {
		if (other.ammo_poison >= AMMO_MAXPOISON) return;
		other.ammo_poison = other.ammo_poison + self.aflag;
	} else if (self.classtype == CT_AMMOBOLTS) {
		if (other.ammo_bolts >= AMMO_MAXBOLTS) return;
		other.ammo_bolts = other.ammo_bolts + self.aflag;
	} else if (self.classtype == CT_AMMOBLOODCRYSTALS) {
		if (other.ammo_bloodcrystals >= AMMO_MAXBLOOD) return;
		other.ammo_bloodcrystals = other.ammo_bloodcrystals + self.aflag;
	} else if (self.classtype == CT_AMMOVOIDSHARDS) {
		if (other.ammo_voidshards >= AMMO_MAXVOID) return;
		other.ammo_voidshards = other.ammo_voidshards + self.aflag;
	} else if (self.classtype == CT_AMMOELEMENTAL) {
		if (other.ammo_elemental >= AMMO_MAXMANA) return;
		other.ammo_elemental = other.ammo_elemental + self.aflag;
	}
	bound_other_ammo(other); // Check/cap ammo limits.
	sprint (other, "You got the ");
	sprint (other, self.netname);
	sprint (other, "\n");
	sound (other, CHAN_ITEM, "weapons/lock4.wav", 1, ATTN_NORM);
	Safe_stuffcmd (other, "bf\n");
	W_SetCurrentAmmo(other); // If changed current ammo, update it.
	activator = other;
	SUB_UseTargets();
	item_finished(); // Hide item and check for respawn.
	if (!self.respawn_trig) start_item_respawn();
};

void() item_shells = {
	ammo_checkrandomizer();
	if (self.spawnflags & A_LARGE) {
		item_setupmodel("progs/ad171/ammo_shells1.mdl",0);
		if (self.headmdl == "") self.headmdl = "progs/ad171/ammo_lidlarge.mdl";
		item_ammo_set(AMMO_SHELLS_LGR);
	} else {
		item_setupmodel("progs/ad171/ammo_shells0.mdl",0);
		if (self.headmdl == "") self.headmdl = "progs/ad171/ammo_lidsmall.mdl";
		item_ammo_set(AMMO_SHELLS_SML);
	}
	precache_model(self.headmdl);
	self.classtype = CT_AMMOSHELLS;
	if (self.netname == "") self.netname = "box of shells";
	self.respawn_style = PARTICLE_BURST_YELLOW + PARTICLE_BURST_RING;
	self.respawn_ofs = '0 0 24';
	self.respawn_effect = TRUE;
	self.frame_override = FALSE;

	// Randomly pick between having a lid or not
	if (self.frame_box == -1) {
		if (random() < 0.5) self.spawnflags = self.spawnflags | A_LID; // Add spawnflag so lid is spawned correctly
		self.frame_box = 0;
	}
	if (self.progspawnlist > 0) self.spawnflags = self.spawnflags - (self.spawnflags & A_LID); // Item progression list ammo cannot have lids!
	item_ammo_setup();
};

void() item_spikes = {
	ammo_checkrandomizer(); // Check for any random monster setups
	if (self.spawnflags & A_LARGE) {
		item_setupmodel("progs/ad171/ammo_nails1.mdl",0);
		if (self.headmdl == "") self.headmdl = "progs/ad171/ammo_lidlarge.mdl";
		item_ammo_set(AMMO_NAILS_LGR);
	} else {
		item_setupmodel("progs/ad171/ammo_nails0.mdl",0);
		if (self.headmdl == "") self.headmdl = "progs/ad171/ammo_lidsmall.mdl";
		item_ammo_set(AMMO_NAILS_SML);
	}
	precache_model(self.headmdl);
	self.classtype = CT_AMMONAILS;
	if (self.netname == "") self.netname = "box of nails";
	self.respawn_style = PARTICLE_BURST_WHITE + PARTICLE_BURST_RING;
	self.respawn_ofs = '0 0 24';
	self.respawn_effect = TRUE;
	self.frame_override = FALSE;

	// Randomly pick between having a lid or not
	if (self.frame_box < 0) {
		if (random() < 0.5) self.spawnflags = self.spawnflags | A_LID; // Add spawnflag so lid is spawned correctly
		self.frame_box = 0;
	}
	
	if (self.progspawnlist > 0) self.spawnflags = self.spawnflags - (self.spawnflags & A_LID); // Item progression list ammo cannot have lids!
	item_ammo_setup();
};

void() item_rockets = {
	ammo_checkrandomizer();
	if (self.spawnflags & A_LARGE) {
		item_setupmodel("progs/ad171/ammo_rockets1.mdl",0);
		item_ammo_set(AMMO_ROCKETS_LGR);
	} else {
		item_setupmodel("progs/ad171/ammo_rockets0.mdl",0);
		item_ammo_set(AMMO_ROCKETS_SML);
	}
	self.classtype = CT_AMMOROCKETS;
	if (self.netname == "") self.netname = "box of rockets";
	self.spawnflags = self.spawnflags - (self.spawnflags & A_LID);
	self.respawn_style = PARTICLE_BURST_WHITE + PARTICLE_BURST_RING;
	self.respawn_ofs = '0 0 24';
	self.respawn_effect = TRUE;
	self.frame_override = TRUE;
	item_ammo_setup();
};

void() item_cells = {
	ammo_checkrandomizer();
	if (self.spawnflags & A_LARGE) {
		item_setupmodel("progs/ad171/ammo_battery1.mdl",0);
		item_ammo_set(AMMO_CELLS_LGR);
	} else {
		item_setupmodel("progs/ad171/ammo_battery0.mdl",0);
		item_ammo_set(AMMO_CELLS_SML);
	}
	self.classtype = CT_AMMOCELLS;
	if (self.netname == "") self.netname = "battery";
	self.spawnflags = self.spawnflags - (self.spawnflags & A_LID);
	self.respawn_style = PARTICLE_BURST_GREEN + PARTICLE_BURST_RING;
	self.respawn_ofs = '0 0 24';
	self.respawn_effect = TRUE;
	self.frame_override = FALSE;
	item_ammo_setup();
};

void() item_lava_spikes ={
	ammo_checkrandomizer();
	if (self.spawnflags & A_LARGE) {
		item_setupmodel("maps/b_lnail1.bsp",0);
		item_ammo_set(AMMO_NAILS_LGR);
	} else {
		item_setupmodel("maps/b_lnail0.bsp",0);
		item_ammo_set(AMMO_NAILS_SML);
	}
	self.classtype = CT_AMMOLAVANAILS;
	if (self.netname == "") self.netname = "box of lava nails";
	self.respawn_style = PARTICLE_BURST_WHITE + PARTICLE_BURST_RING;
	self.respawn_ofs = '0 0 24';
	self.respawn_effect = TRUE;
	item_ammo_setup();
};

void() item_multi_rockets = {
	ammo_checkrandomizer();
	if (self.spawnflags & A_LARGE) {
		item_setupmodel("maps/b_mrock1.bsp",0);
		item_ammo_set(AMMO_ROCKETS_LGR);
	} else {
		item_setupmodel("maps/b_mrock0.bsp",0);
		item_ammo_set(AMMO_ROCKETS_SML);
	}
	self.classtype = CT_AMMOMULTIROCKETS;
	if (self.netname == "") self.netname = "box of multi rockets";
	if (self.spawnflags & A_LID) self.spawnflags = self.spawnflags - A_LID;
	self.frame_override = TRUE;
	self.respawn_style = PARTICLE_BURST_WHITE + PARTICLE_BURST_RING;
	self.respawn_ofs = '0 0 24';
	self.respawn_effect = TRUE;
	item_ammo_setup();
};

void() item_plasma = {
	ammo_checkrandomizer();
	if (self.spawnflags & A_LARGE) {
		item_setupmodel("maps/b_plas1.bsp",0);
		item_ammo_set(AMMO_CELLS_LGR);
	} else {
		item_setupmodel("maps/b_plas0.bsp",0);
		item_ammo_set(AMMO_CELLS_SML);
	}
	self.classtype = CT_AMMOPLASMA;
	if (self.netname == "") self.netname = "box of plasma";
	if (self.spawnflags & A_LID) self.spawnflags = self.spawnflags - A_LID;
	self.frame_override = TRUE;
	self.respawn_style = PARTICLE_BURST_BLUE + PARTICLE_BURST_RING;
	self.respawn_ofs = '0 0 24';
	self.respawn_effect = TRUE;
	item_ammo_setup();
};

void() item_bolts = {
	ammo_checkrandomizer();
	if (self.spawnflags & A_LARGE) {
		item_setupmodel("progs/qmaster/ammo_bolts1.mdl",0);
		item_ammo_set(AMMO_BOLTS_LGR);
	} else {
		item_setupmodel("progs/qmaster/ammo_bolts0.mdl",0);
		item_ammo_set(AMMO_BOLTS_SML);
	}
	self.classtype = CT_AMMOBOLTS;
	if (self.netname == "") self.netname = "box of crossbow bolts";
	self.respawn_style = PARTICLE_BURST_WHITE + PARTICLE_BURST_RING;
	self.respawn_ofs = '0 0 24';
	self.respawn_effect = TRUE;
	item_ammo_setup();
};

void() item_poison = {
	ammo_checkrandomizer();
	if (self.spawnflags & A_LARGE) {
		item_setupmodel("progs/its/item_poison1.mdl",0);
		item_ammo_set(AMMO_POISON_LGR);
	} else {
		item_setupmodel("progs/its/item_poison0.mdl",0);
		item_ammo_set(AMMO_POISON_SML);
	}
	self.classtype = CT_AMMOPOISON;
	if (self.netname == "") self.netname = "jar of poison";
	self.respawn_style = PARTICLE_BURST_WHITE + PARTICLE_BURST_RING;
	self.respawn_ofs = '0 0 24';
	self.respawn_effect = TRUE;
	item_ammo_setup();
};

void() item_bloodcrystals = {
	ammo_checkrandomizer();
	if (self.spawnflags & A_LARGE) {
		item_setupmodel("progs/aoa/ammo_bloodcrystals_big.mdl",0);
		item_ammo_set(AMMO_BLOOD_LGR);
	} else {
		item_setupmodel("progs/aoa/ammo_bloodcrystals.mdl",0);
		item_ammo_set(AMMO_BLOOD_SML);
	}
	self.ammo_bloodcrystals = self.aflag;
	self.classtype = CT_AMMOBLOODCRYSTALS;
	if (self.netname == "") self.netname = "quantity of blood crystals";
	self.respawn_style = PARTICLE_BURST_RED + PARTICLE_BURST_RING;
	self.respawn_ofs = '0 0 24';
	self.respawn_effect = TRUE;
	item_ammo_setup();
};

void() item_voidshards = {
	ammo_checkrandomizer();
	if (self.spawnflags & A_LARGE) {
		item_setupmodel("progs/aoa/ammo_voidshards_big.mdl",0);
		item_ammo_set(AMMO_VOID_LGR);
	} else {
		item_setupmodel("progs/aoa/ammo_voidshards.mdl",0);
		item_ammo_set(AMMO_VOID_SML);
	}
	self.ammo_voidshards = self.aflag;
	self.classtype = CT_AMMOVOIDSHARDS;
	if (self.netname == "") self.netname = "splintering of void shards";
	self.respawn_style = PARTICLE_BURST_PURPLE + PARTICLE_BURST_RING;
	self.respawn_ofs = '0 0 24';
	self.respawn_effect = TRUE;
	item_ammo_setup();
};

void() item_elemental = {
	ammo_checkrandomizer();
	if (self.spawnflags & A_LARGE) {
		item_setupmodel("progs/aoa/ammo_elemental_big.mdl",0);
		item_ammo_set(AMMO_MANA_LGR);
	} else {
		item_setupmodel("progs/aoa/ammo_elemental.mdl",0);
		item_ammo_set(AMMO_MANA_SML);
	}
	self.ammo_elemental = self.aflag;
	self.classtype = CT_AMMOELEMENTAL;
	if (self.netname == "") self.netname = "blessing of elemental mana";
	self.respawn_style = PARTICLE_BURST_RED + PARTICLE_BURST_RING;
	self.respawn_ofs = '0 0 24';
	self.respawn_effect = TRUE;
	item_ammo_setup();
};
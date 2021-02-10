void () weapon_rapier = {
	// Check for custom model setup?
	item_debugcustomdl();

	if (self.mdl == "") self.mdl = "progs/aoa/g_rapier.mdl";
	precache_model (self.mdl);
	self.weapon = IT_RAPIER;
	self.classtype = CT_RAPIER;
	if (self.netname == "") self.netname = "Ghost Rapier";
	// if (self.aflag == 0) self.aflag = AMMO_CELLS_WPN;
	// else if (self.aflag < 0) self.aflag = 0;
	//if (world.devdata & DEV_AMMO_N_HEALTH) world.deventity.ammo_cells = world.deventity.ammo_cells + self.aflag;
	weapon_start();
};

void () weapon_mace = {
	// Check for custom model setup?
	item_debugcustomdl();

	if (self.mdl == "") self.mdl = "progs/aoa/g_mace.mdl";
	precache_model (self.mdl);
	self.weapon = IT_MACE;
	self.classtype = CT_MACE;
	if (self.netname == "") self.netname = "Vampiric Mace";
	if (self.aflag == 0) self.aflag = AMMO_BLOOD_WPN;
	else if (self.aflag < 0) self.aflag = 0;
	if (world.devdata & DEV_AMMO_N_HEALTH) world.deventity.ammo_bloodcrystals = world.deventity.ammo_bloodcrystals + self.aflag;
	weapon_start();
};

void () weapon_ice = {
	// Check for custom model setup?
	item_debugcustomdl();

	if (self.mdl == "") self.mdl = "progs/aoa/g_ice.mdl";
	precache_model (self.mdl);
	self.weapon = IT_ICE;
	self.classtype = CT_ICE;
	if (self.netname == "") self.netname = "Elemental Tome";
	if (self.aflag == 0) self.aflag = AMMO_ELEMENTAL_WPN;
	else if (self.aflag < 0) self.aflag = 0;
	if (world.devdata & DEV_AMMO_N_HEALTH) world.deventity.ammo_elemental = world.deventity.ammo_elemental + self.aflag;
	weapon_start();
};

void () weapon_scimitar = {
	// Check for custom model setup?
	item_debugcustomdl();

	if (self.mdl == "") self.mdl = "progs/aoa/g_scimitar.mdl";
	precache_model (self.mdl);
	self.weapon = IT_SCIMITAR;
	self.classtype = CT_SCIMITAR;
	if (self.netname == "") self.netname = "Fire Scimitar";
	if (self.aflag == 0) self.aflag = AMMO_ELEMENTAL_WPN;
	else if (self.aflag < 0) self.aflag = 0;
	if (world.devdata & DEV_AMMO_N_HEALTH) world.deventity.ammo_elemental = world.deventity.ammo_elemental + self.aflag;
	weapon_start();
};

void () weapon_voidstaff = {
	// Check for custom model setup?
	item_debugcustomdl();

	if (self.mdl == "") self.mdl = "progs/aoa/g_voidstaff.mdl";
	precache_model (self.mdl);
	self.weapon = IT_VOID_STAFF;
	self.classtype = CT_VOID_STAFF;
	if (self.netname == "") self.netname = "Void Staff";
	if (self.aflag == 0) self.aflag = AMMO_VOID_WPN;
	else if (self.aflag < 0) self.aflag = 0;
	if (world.devdata & DEV_AMMO_N_HEALTH) world.deventity.ammo_voidshards = world.deventity.ammo_voidshards + self.aflag;
	weapon_start();
};

void () weapon_gungnir = {
	// Check for custom model setup?
	item_debugcustomdl();

	if (self.mdl == "") self.mdl = "progs/aoa/g_gungnir.mdl";
	precache_model (self.mdl);
	self.weapon = IT_GUNGNIR;
	self.classtype = CT_GUNGNIR;
	if (self.netname == "") self.netname = "Gungnir";
	if (self.aflag == 0) self.aflag = AMMO_VOID_WPN;
	else if (self.aflag < 0) self.aflag = 0;
	if (world.devdata & DEV_AMMO_N_HEALTH) world.deventity.ammo_voidshards = world.deventity.ammo_voidshards + self.aflag;
	weapon_start();
};

void () weapon_sanguinators = {
	// Check for custom model setup?
	item_debugcustomdl();

	if (self.mdl == "") self.mdl = "progs/aoa/g_sanguinators.mdl";
	precache_model (self.mdl);
	self.weapon = IT_SANGUINATORS;
	self.classtype = CT_SANGUINATORS;
	if (self.netname == "") self.netname = "Sanguinators";
	if (self.aflag == 0) self.aflag = AMMO_BLOOD_WPN;
	else if (self.aflag < 0) self.aflag = 0;
	if (world.devdata & DEV_AMMO_N_HEALTH) world.deventity.ammo_bloodcrystals = world.deventity.ammo_bloodcrystals + self.aflag;
	weapon_start();
};

void () weapon_flak = {
	// Check for custom model setup?
	item_debugcustomdl();

	if (self.mdl == "") self.mdl = "progs/aoa/g_flak.mdl";
	precache_model (self.mdl);
	self.weapon = IT_FLAK;
	self.classtype = CT_FLAK;
	if (self.netname == "") self.netname = "Flak Cannon";
	if (self.aflag == 0) self.aflag = AMMO_NAILS_WPN*2;
	else if (self.aflag < 0) self.aflag = 0;
	if (world.devdata & DEV_AMMO_N_HEALTH) world.deventity.ammo_nails = world.deventity.ammo_nails + self.aflag;
	weapon_start();
};

void() item_bloodcrystals = {
	// Check for any random monster setups
	if (ammo_checkrandomizer() == TRUE) return;

	// Check for custom model setup?
	item_debugcustomdl();

	if (self.spawnflags & A_LARGE) {
		if (self.mdl == "") self.mdl = "progs/aoa/ammo_bloodcrystals_big.mdl";
		if (self.aflag < 1) self.aflag = AMMO_BLOOD_LGR;
	} else {
		if (self.mdl == "") self.mdl = "progs/aoa/ammo_bloodcrystals.mdl";
		if (self.aflag < 1) self.aflag = AMMO_BLOOD_SML;
	}
	self.ammo_bloodcrystals = self.aflag;
	self.skin_override = 1;
	precache_model (self.mdl);
	self.classtype = CT_AMMOBLOODCRYSTALS;
	if (self.netname == "") self.netname = "quantity of blood crystals";
	self.respawn_style = PARTICLE_BURST_RED + PARTICLE_BURST_RING;
	self.respawn_ofs = '0 0 24';
	self.respawn_effect = TRUE;
	item_ammo_setup();
};

void() item_voidshards = {
	// Check for any random monster setups
	if (ammo_checkrandomizer() == TRUE) return;

	// Check for custom model setup?
	item_debugcustomdl();

	if (self.spawnflags & A_LARGE) {
		if (self.mdl == "") self.mdl = "progs/aoa/ammo_voidshards_big.mdl";
		if (self.aflag < 1) self.aflag = AMMO_VOID_LGR;
	} else {
		if (self.mdl == "") self.mdl = "progs/aoa/ammo_voidshards.mdl";
		if (self.aflag < 1) self.aflag = AMMO_VOID_SML;
	}
	self.ammo_voidshards = self.aflag;
	self.skin_override = 1;
	precache_model (self.mdl);
	self.classtype = CT_AMMOVOIDSHARDS;
	if (self.netname == "") self.netname = "splintering of void shards";
	self.respawn_style = PARTICLE_BURST_PURPLE + PARTICLE_BURST_RING;
	self.respawn_ofs = '0 0 24';
	self.respawn_effect = TRUE;
	item_ammo_setup();
};

void() item_elemental = {
	// Check for any random monster setups
	if (ammo_checkrandomizer() == TRUE) return;

	// Check for custom model setup?
	item_debugcustomdl();

	if (self.spawnflags & A_LARGE) {
		if (self.mdl == "") self.mdl = "progs/aoa/ammo_elemental_big.mdl";
		if (self.aflag < 1) self.aflag = AMMO_MANA_LGR;
	} else {
		if (self.mdl == "") self.mdl = "progs/aoa/ammo_elemental.mdl";
		if (self.aflag < 1) self.aflag = AMMO_MANA_SML;
	}
	self.ammo_elemental = self.aflag;
	self.skin_override = 1;
	precache_model (self.mdl);
	self.classtype = CT_AMMOELEMENTAL;
	if (self.netname == "") self.netname = "blessing of elemental mana";
	self.respawn_style = PARTICLE_BURST_RED + PARTICLE_BURST_RING;
	self.respawn_ofs = '0 0 24';
	self.respawn_effect = TRUE;
	item_ammo_setup();
};
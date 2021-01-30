void () weapon_rapier = {
	self.mdl = "progs/aoa/g_rapier.mdl";
	precache_model (self.mdl);
	self.weapon = IT_RAPIER;
	self.classtype = CT_RAPIER;
	self.netname = "Ghost Rapier";
	//if (world.devdata & DEV_AMMO_N_HEALTH) world.deventity.ammo_cells = world.deventity.ammo_cells + AMMO_CELLS_WPN;
	weapon_start();
};

void () weapon_mace = {
	self.mdl = "progs/aoa/g_mace.mdl";
	precache_model (self.mdl);
	self.weapon = IT_MACE;
	self.classtype = CT_MACE;
	self.netname = "Vampiric Mace";
	if (world.devdata & DEV_AMMO_N_HEALTH) world.deventity.ammo_bloodcrystals = world.deventity.ammo_bloodcrystals + AMMO_BLOOD_WPN;
	weapon_start();
};

void () weapon_ice = {
	self.mdl = "progs/aoa/g_ice.mdl";
	precache_model (self.mdl);
	self.weapon = IT_ICE;
	self.classtype = CT_ICE;
	self.netname = "Elemental Tome";
	if (world.devdata & DEV_AMMO_N_HEALTH) world.deventity.ammo_elemental = world.deventity.ammo_elemental + AMMO_ELEMENTAL_WPN;
	weapon_start();
};

void () weapon_scimitar = {
	self.mdl = "progs/aoa/g_scimitar.mdl";
	precache_model (self.mdl);
	self.weapon = IT_SCIMITAR;
	self.classtype = CT_SCIMITAR;
	self.netname = "Fire Scimitar";
	if (world.devdata & DEV_AMMO_N_HEALTH) world.deventity.ammo_elemental = world.deventity.ammo_elemental + AMMO_ELEMENTAL_WPN;
	weapon_start();
};

void () weapon_voidstaff = {
	self.mdl = "progs/aoa/g_voidstaff.mdl";
	precache_model (self.mdl);
	self.weapon = IT_VOID_STAFF;
	self.classtype = CT_VOID_STAFF;
	self.netname = "Void Staff";
	if (world.devdata & DEV_AMMO_N_HEALTH) world.deventity.ammo_voidshards = world.deventity.ammo_voidshards + AMMO_VOID_WPN;
	weapon_start();
};

void () weapon_gungnir = {
	self.mdl = "progs/aoa/g_gungnir.mdl";
	precache_model (self.mdl);
	self.weapon = IT_GUNGNIR;
	self.classtype = CT_GUNGNIR;
	self.netname = "Gungnir";
	if (world.devdata & DEV_AMMO_N_HEALTH) world.deventity.ammo_voidshards = world.deventity.ammo_voidshards + AMMO_VOID_WPN;
	weapon_start();
};

void () weapon_sanguinators = {
	self.mdl = "progs/aoa/g_sanguinators.mdl";
	precache_model (self.mdl);
	self.weapon = IT_SANGUINATORS;
	self.classtype = CT_SANGUINATORS;
	self.netname = "Sanguinators";
	if (world.devdata & DEV_AMMO_N_HEALTH) world.deventity.ammo_bloodcrystals = world.deventity.ammo_bloodcrystals + AMMO_BLOOD_WPN;
	weapon_start();
};

void () weapon_flak = {
	self.mdl = "progs/aoa/g_flak.mdl";
	precache_model (self.mdl);
	self.weapon = IT_FLAK;
	self.classtype = CT_FLAK;
	self.netname = "Flak Cannon";
	if (world.devdata & DEV_AMMO_N_HEALTH) world.deventity.ammo_nails = world.deventity.ammo_nails + AMMO_NAILS_WPN;
	weapon_start();
};

void() item_bloodcrystals = {
	if (self.spawnflags & A_LARGE) {
		self.mdl = "progs/aoa/ammo_bloodcrystals_big.mdl";
		if (self.aflag < 1) self.aflag = AMMO_BLOOD_LGR;
	} else {
		self.mdl = "progs/aoa/ammo_bloodcrystals.mdl";
		if (self.aflag < 1) self.aflag = AMMO_BLOOD_SML;
	}
	self.ammo_bloodcrystals = self.aflag;
	self.skin_override = 1;
	precache_model (self.mdl);
	self.classtype = CT_AMMOBLOODCRYSTALS;
	self.netname = "quantity of blood crystals";
	self.respawn_style = PARTICLE_BURST_RED + PARTICLE_BURST_RING;
	self.respawn_ofs = '0 0 24';
	self.respawn_effect = TRUE;
	item_ammo_setup();
};

void() item_voidshards = {
	if (self.spawnflags & A_LARGE) {
		self.mdl = "progs/aoa/ammo_voidshards_big.mdl";
		if (self.aflag < 1) self.aflag = AMMO_VOID_LGR;
	} else {
		self.mdl = "progs/aoa/ammo_voidshards.mdl";
		if (self.aflag < 1) self.aflag = AMMO_VOID_SML;
	}
	self.ammo_voidshards = self.aflag;
	self.skin_override = 1;
	precache_model (self.mdl);
	self.classtype = CT_AMMOVOIDSHARDS;
	self.netname = "splintering of void shards";
	self.respawn_style = PARTICLE_BURST_PURPLE + PARTICLE_BURST_RING;
	self.respawn_ofs = '0 0 24';
	self.respawn_effect = TRUE;
	item_ammo_setup();
};

void() item_elemental = {
	if (self.spawnflags & A_LARGE) {
		self.mdl = "progs/aoa/ammo_elemental_big.mdl";
		if (self.aflag < 1) self.aflag = AMMO_MANA_LGR;
	} else {
		self.mdl = "progs/aoa/ammo_elemental.mdl";
		if (self.aflag < 1) self.aflag = AMMO_MANA_SML;
	}
	self.ammo_elemental = self.aflag;
	self.skin_override = 1;
	precache_model (self.mdl);
	self.classtype = CT_AMMOELEMENTAL;
	self.netname = "blessed with elemental mana";
	self.respawn_style = PARTICLE_BURST_RED + PARTICLE_BURST_RING;
	self.respawn_ofs = '0 0 24';
	self.respawn_effect = TRUE;
	item_ammo_setup();
};
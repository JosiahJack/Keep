// Used by decapitation code to give headless "body double" the loot.
void(entity from, entity to) Pack_Copy =
{
    to.arsenal      = from.arsenal;
    to.war          = from.war;
    to.healamount   = from.healamount;
    to.healtype     = from.healtype;
    to.ammo_shells  = from.ammo_shells;
    to.ammo_nails   = from.ammo_nails;
    to.ammo_rockets = from.ammo_rockets;
    to.ammo_cells   = from.ammo_cells;
    to.ammo_super   = from.ammo_super;
    to.ammo_multi_rockets = from.ammo_multi_rockets;
    to.ammo_lava_nails = from.ammo_lava_nails;
    to.ammo_plasma = from.ammo_plasma;
    to.ammo_bolts = from.ammo_bolts;
    to.ammo_poison = from.ammo_poison;
};

float(entity who) Pack_Empty = {
	return (who.arsenal+who.war+who.healamount+who.healtype+who.ammo_shells
	+who.ammo_nails+who.ammo_rockets+who.ammo_cells+who.ammo_super
	+who.ammo_multi_rockets+who.ammo_lava_nails+who.ammo_plasma+who.ammo_bolts
	+who.ammo_poison);
};

//============
// --> QUAKED item_artifact_optimizer (0 .5 .8) (-16 -16 -24) (16 16 32)
// Buffs melee damage and gives
// life leech -- permanently.
//============

void () item_artifact_berserker = {
	self.mdl = "progs/drake/zerkhelm.mdl";
	precache_model (self.mdl);
	self.noise = "items/zerkhelm.wav";
	precache_sound (self.noise);
        self.netname = "Berserker Helm";
	self.items = 0;
	self.classtype = CT_ARTBERSERK;
	self.part_active = PARTICLE_STYLE_PENT;
	self.respawn_style = PARTICLE_BURST_RED + PARTICLE_BURST_CENTER;
	self.respawn_ofs = '0 0 16';
	artifact_setup();
};

//============
// --> QUAKED item_artifact_equalizer (0 .5 .8) (-16 -16 -24) (16 16 32)
// Nailguns fire two nails at the price
// of one -- permanently.
//
// Also fills nails to the maximum.
//============

void () item_artifact_equalizer = {
	self.mdl = "progs/drake/gemini.mdl";
	precache_model (self.mdl);
	self.noise = "items/equalize.wav";
	precache_sound (self.noise);
    self.netname = "Twin Shot";
	self.items = 0;
	self.classtype = CT_ARTEQUALIZER;
	self.part_active = PARTICLE_STYLE_SRING;
	self.respawn_style = PARTICLE_BURST_YELLOW + PARTICLE_BURST_CENTER;
	if (world.devdata & DEV_AMMO_N_HEALTH) world.deventity.ammo_nails = world.deventity.ammo_nails + AMMO_MAXNAILS;
	self.respawn_ofs = '0 0 16';
	artifact_setup();
};

//============
// --> QUAKED item_artifact_levitation (0 .5 .8) (-16 -16 -24) (16 16 32)
// Gives the player limited flying ability
//============
void () item_artifact_levitation = {
	self.mdl = "progs/drake/levitate.mdl";
	precache_model (self.mdl);
	self.noise = "items/levitate.wav";
	self.noise1 = "ambience/wingget.wav";
	self.noise2 = "ambience/wingend.wav";
	precache_sound (self.noise);
	precache_sound (self.noise1);
	precache_sound (self.noise2);
    self.netname = "Boots of Levitation";
	self.items = 0;
	self.classtype = CT_ARTLEVITATION;
	self.part_active = PARTICLE_STYLE_TOMEOFP;
	self.respawn_style = PARTICLE_BURST_WHITE + PARTICLE_BURST_RING;
	self.respawn_ofs = '0 0 16';
	artifact_setup();
};

// Original classname in Zerstorer.
// Note:  Replaced Zerstorer's Dark-Angel Wings with Boots of Levitation.
//void() item_wings = {self.classname = "item_artifact_levitation"; item_artifact_levitation(); };


//============
// --> QUAKED item_artifact_optimizer (0 .5 .8) (-16 -16 -24) (16 16 32)
// Shotguns fire faster -- permanently.
//
// Also fills shells to the maximum.
//============
void() item_artifact_optimizer = {
	self.mdl = "progs/drake/shotty.mdl";
	precache_model (self.mdl);
	self.noise = "items/optimize.wav";
	precache_sound (self.noise);
    self.netname = "Shotgun Optimizer";
	self.perms = POW_SHOTTYMAN;
	self.classtype = CT_ARTOPTIMIZER;
	self.part_active = PARTICLE_STYLE_ARMOR;
	self.respawn_style = PARTICLE_BURST_YELLOW + PARTICLE_BURST_CENTER;
	self.respawn_ofs = '0 0 16';
	if (world.devdata & DEV_AMMO_N_HEALTH) world.deventity.ammo_shells = world.deventity.ammo_shells + AMMO_MAXSHELLS;
	artifact_setup();
};


//============
// --> QUAKED item_sigil_bane (0 .5 .8) (-16 -16 -24) (16 16 32)
// Unique item for nsoe5.  Pick up to activate final fight with Bane.
//============
void() item_sigil_bane = {
	self.mdl = "progs/drake/end_bane.mdl";
	precache_model (self.mdl);
	self.noise = "misc/runekey.wav";
	precache_sound (self.noise);
    self.netname = "seal of Bane!";
	self.items = 0;
	self.classtype = CT_SIGILBANE;
	self.part_active = PARTICLE_STYLE_SIGIL;
	self.respawn_style = PARTICLE_BURST_PURPLE + PARTICLE_BURST_CENTER;
	self.respawn_ofs = '0 0 16';
	artifact_setup();
};

void() weapon_blaster = {
	self.mdl = "progs/w_blaster.mdl"; // set by world.qc, mapper can pick to use AD or original axe
	precache_model (self.mdl);
	//self.weapon = IT_BLASTER;
	self.classtype = CT_BLASTERWEP;
	self.netname = "Laser Blaster";
	if (world.devdata & DEV_AMMO_N_HEALTH) world.deventity.ammo_shells = world.deventity.ammo_shells + AMMO_SHELLS_WPN; //TODO: change to cells?
	weapon_start();
};

//==========================================================================
//
//  TREASURE
//
//==========================================================================

//- - - - - - - - -
// Updates gem color.
void(float gt) gem_colors =
{
    local   float   bit3, bit4;
    local   float   newskin;

    bit4 = self.cnt = (self.cnt + 1) & 7;

    bit3 = bit4 & 3;
    if (gt == 1)
    {   // 00001111
        newskin = (bit4 / 4);   //+ (self.worldtype * 2);
    }
    else if (gt == 2)
    {   // 00110011
        newskin = ((bit3 & 2) / 2);   //+ (self.worldtype * 2);
    }
    else if (gt == 3)
    {   // 21002100
        newskin = 2 - bit3;
        if (newskin < 0)
            newskin = 0;
    }
    else if (gt == 4)
    {   // 01210121
        if (bit3 == 3)
            newskin = 1;
        else
            newskin = bit3;
    }
    else if (gt == 5)
    {   // 01230123
        newskin = bit3;
    }
    else if (gt == 6)
    {   // 01233210
        if (bit4 & 4)
            newskin = 3 - bit3;
        else
            newskin = bit3;
    }
// PM:  Okay, so the gem model has a test fifth skin.
//    else if (gt == 7)
//    {   // ????????
//        newskin = (random() * 4) & 3;
//    }
    else
    {   // 40414243
        if (bit4 & 1)
            newskin = ((bit4 & 6) / 2) & 3;   
        else
            newskin = 4;
    }

    self.skin = newskin;
};

// Magic gem thinking -- change color every frame.
void() gem_pulse =
{
    self.nextthink = time + 0.1;
    self.think = gem_pulse;     // Must define here in case of dynamic spawn.
    gem_colors (self.worldtype);    // FIXME:  Confirm in item_treasure.
};

//- - - - - - - - -
// Moved 'Life_Up' to Potions section.

// Called when something bumps into item_treasure.
void() treasure_touch =
{
    if (other.health <= 0)
        return;

    if (!(other.xfl & XFL_ITEMS))
        return;

// Pickup effects.
    Safe_sprint (other, "You found ");
    Safe_sprint (other, self.netname);
    Safe_sprint (other, "\n");
    sound (other, CHAN_ITEM, "drake/items/treasure.wav", 1, ATTN_NORM);
    Safe_stuffcmd (other, "bf\n");

// Reward with max hp increase -- not in SoE!
// SoE:  Increase armor, ignoring max, like in classic Doom.
// Note:  If adding shops, add to gp in addition to armor/hp boost.
    if (!self.healamount)
        self.healamount = 5;
    if (self.healtype)
        T_Heal (other, self.healamount, TRUE);
    else
        T_Repair (other, self.healamount, TRUE);

	item_finished();
	check_item_respawn();

	activator = other;
	SUB_UseTargets();
};

//============
// --> QUAKED item_treasure (.83 .69 .22) (-16 -16 -24) (16 16 32) Gem Big
// Large gems or gold coins.
// Gems raise health by 3, ignoring max health.
// Coins raise armor by a like amount, up to an absolute limit of 250.
//
// Note:  In Drake, maximum health gets raised by 1 permanently.
//============
void() item_treasure =
{
    if (soul_evil)
    if (!self.healtype)
    if (!(self.xsf & XSF_CHEST_HACK))
    {   // Treasure type.
        if (self.spawnflags & 1)
            {self.healtype = 1;  self.spawnflags = self.spawnflags - 1;}
        else
            self.healtype = 0;

        // Size.
        if (self.spawnflags & 2)
            self.spawnflags = self.spawnflags - 2;
        else
            self.spawnflags = self.spawnflags | 1;
    }

    self.classname = "item_treasure";
    if (self.spawnflags & 1)
        {self.frame = 0;  self.healamount = 5;}
    else if (self.spawnflags & 2)
        {self.frame = 2;  self.healamount = 20;}
    else
        {self.frame = 1;  self.healamount = 10;}
    if (self.healtype) {
        if (self.worldtype)
            self.th_win = gem_pulse;

        self.netname = "a gem";
        self.mdl = "progs/drake/t_gem.mdl";   //"progs/soe_gem.mdl";
        if (self.skin < 0) {
            self.skin = random() * 4.999;
            self.skin = floor (self.skin);
        }
    } else {
        self.netname = "gold";
        self.mdl = "progs/drake/t_coin.mdl";  //"progs/soe_coin.mdl";
        self.skin = self.frame;
    }

	self.respawn_style = PARTICLE_BURST_WHITE + PARTICLE_BURST_RING;
	self.noise = SOUND_HEAL15;
	self.classtype = CT_HEALROT;
	self.respawn_effect = TRUE;
	self.respawn_ofs = '0 0 16';

	self.bbmins = '-16 -16 0';
	self.bbmaxs = '16 16 56';

    self.touch2 = treasure_touch;
	if (self.respawn_time == 0) self.respawn_time = RESPAWN_HEALTH;
    self.noise = "drake/items/treasure.wav";
	precache_model(self.mdl);
	precache_sound("drake/items/treasure.wav");

	// Query console variable 'temp1' for model upgrade option.
	// Cannot use global vars because they don't exist at this point
	// Move the new centered ammo models to match old ammo origin
	// The default is to move all ammo items to suit original id maps
	if (query_configflag(SVR_ITEMOFFSET) == FALSE) {
		self.oldorigin = self.origin + '16 16 0';
		setorigin(self, self.oldorigin);
	}

	// Setting the angle key in the editor to UP/DOWN = random rotation	
	if (self.angles_y < 0 || (self.angles_y == 0 && query_configflag(SVR_ITEMROTATE) == FALSE) ) 
		self.angles_y = rint(random()*359);

    // Check for coop errors
	item_coopcheck();
	item_start ();
};

//============
// --> QUAKED item_treasure_gem (.83 .69 .22) (-16 -16 -24) (16 16 32)
// Large gems
//============
void() item_treasure_gem =
{
	precache_sound("drake/items/treasure.wav");
    if (self.xsf & XSF_CHEST_HACK)
        self.skin       = -1;   // Random color.
    self.healtype = 1;
    item_treasure ();
};
//============
// --> QUAKED item_treasure_coin (.83 .69 .22) (-16 -16 -24) (16 16 32)
// Large gold coins
//============
void() item_treasure_coin = { precache_sound("drake/items/treasure.wav"); self.healtype = 0;  item_treasure();};

//============
// --> QUAKED item_armor_exotic (0 .5 .8) (-16 -16 0) (16 16 32)
// Custom Exotic Armor.
//
// spawnflags
// 1 = Courage armor (reflects missiles, frontal protection only.  Zerstorer)
// 2 = Dragonscale (red armor that morphs player into dragon.  Soul of Evil)
// 3 = Onyx armor (indestructible, 50% protection.  Inspired by DoomRL.)
// 4 = Power armor (as Onyx, plus power shield like in Quake2)
// 5 = Demonhide (cursed, increases damage taken, but regenerates hp)
// 6 = Spirit shroud (stealth, absorbs up to 25 damage, self-repairs)
// 7 = Chaos armor (variable protection, can teleport as Chaos device from Heretic)
// 8 = Jump armor (green armor with high jump and half health regeneration)
//============
void() item_armor_exotic = {
	// Check for custom model setup?
	item_debugcustomdl();

	if (self.count > 7) self.count = 7;

	// Courage
	if (self.count == 0) {
		// Setup default model
		if (self.mdl == "") { self.mdl = "progs/drake/courage.mdl"; self.skin = 0; }
		self.classtype = CT_ARMORCOURAGE;
		self.perms = POW_ARMORCOURAGE;
		if (self.netname == "") self.netname = "Courage Armor";
		if (self.armortype <= 0) self.armortype = ARMOR_COURAGE_TYPE;
		if (self.armorvalue <= 0) self.armorvalue = ARMOR_COURAGE_VALUE;
		self.respawn_style = PARTICLE_BURST_WHITE + PARTICLE_BURST_RING;
		if (!self.part_active) self.part_active = PARTICLE_STYLE_KEYWHITE;
		if (self.noise == "") self.noise = "items/armor1.wav";
		precache_sound (self.noise);
	}
	if (self.noise == "") self.noise = "items/armor1.wav";
	precache_sound (self.noise);
	// Dragonscale
	if (self.count == 1) {
		// Setup default model
		if (self.mdl == "") { self.mdl = "progs/drake/armor.mdl"; self.skin = 6; }
		self.classtype = CT_ARMORDRAGON;
		self.perms = POW_ARMORDRAGON;
		if (self.netname == "") self.netname = "Dragonscale Armor";
		if (self.armortype <= 0) self.armortype = ARMOR_DRAGON_TYPE;
		if (self.armorvalue <= 0) self.armorvalue = ARMOR_DRAGON_VALUE;
		self.respawn_style = PARTICLE_BURST_RED + PARTICLE_BURST_RING;
		if (!self.part_active) self.part_active = PARTICLE_STYLE_ALTAR;
		precache_sound (SOUND_ARTPENT1);
	}
	// Onyx
	if (self.count == 2) {
		// Setup default model
		if (self.mdl == "") { self.mdl = "progs/drake/armor.mdl"; self.skin = 4; }
		self.classtype = CT_ARMORONYX;
		self.perms = POW_ARMORONYX;
		if (self.netname == "") self.netname = "Onyx Armor";
		if (self.armortype <= 0) self.armortype = ARMOR_ONYX_TYPE;
		if (self.armorvalue <= 0) self.armorvalue = ARMOR_ONYX_VALUE;
		self.respawn_style = PARTICLE_BURST_WHITE + PARTICLE_BURST_RING;
		if (!self.part_active) self.part_active = PARTICLE_STYLE_BACKPACK;
	}
	// Power
	if (self.count == 3) {
		// Setup default model
		if (self.mdl == "") { self.mdl = "progs/drake/armor.mdl"; self.skin = 5; }
		self.classtype = CT_ARMORONYXPOWER;
		self.perms = POW_ARMORONYXPOWER;
		if (self.netname == "") self.netname = "Power Armor";
		if (self.armortype <= 0) self.armortype = ARMOR_ONYXPOWER_TYPE;
		if (self.armorvalue <= 0) self.armorvalue = ARMOR_ONYXPOWER_VALUE;
		self.respawn_style = PARTICLE_BURST_YELLOW + PARTICLE_BURST_RING;
		if (!self.part_active) self.part_active = PARTICLE_STYLE_KEYGOLD;
		precache_sound("me/me_soff.wav"); // shield off
		precache_sound("me/me_son.wav"); // shields up!
		precache_sound("me/me_fire1.wav"); // shield hit
		if (self.aflag < 1) self.aflag = AMMO_CELLS_WPN;
	}
	// Demon
	if (self.count == 4) {
		// Setup default model
		if (self.mdl == "") { self.mdl = "progs/drake/armor.mdl"; self.skin = 3; }
		self.classtype = CT_ARMORBERSERKER;
		self.perms = POW_ARMORBERSERKER;
		if (self.netname == "") self.netname = "Berserker Armor"; // formerly demonhide
		if (self.armortype <= 0) self.armortype = ARMOR_BERSERKER_TYPE;
		if (self.armorvalue <= 0) self.armorvalue = ARMOR_BERSERKER_VALUE;
		self.respawn_style = PARTICLE_BURST_RED + PARTICLE_BURST_RING;
		if (!self.part_active) self.part_active = PARTICLE_STYLE_PENT;
		precache_sound (SOUND_ARTQUAD1);
	}
	// Spirit Shroud
	if (self.count == 5) {
		// Setup default model
		if (self.mdl == "") { self.mdl = "progs/drake/armor.mdl"; self.skin = 7; }
		self.classtype = CT_ARMORSPIRIT;
		self.perms = POW_ARMORSPIRIT;
		if (self.netname == "") self.netname = "Spirit Shroud";
		if (self.armortype <= 0) self.armortype = ARMOR_SPIRIT_TYPE;
		if (self.armorvalue <= 0) self.armorvalue = ARMOR_SPIRIT_VALUE;
		self.respawn_style = PARTICLE_BURST_PURPLE + PARTICLE_BURST_RING;
		if (!self.part_active) self.part_active = PARTICLE_STYLE_SHARP;
		precache_sound (SOUND_ARTINV1);
	}
	// Chaos
	if (self.count == 6) {
		// Setup default model
		if (self.mdl == "") { self.mdl = "progs/drake/armor.mdl"; self.skin = 8; }
		self.classtype = CT_ARMORCHAOS;
		self.perms = POW_ARMORCHAOS;
		if (self.netname == "") self.netname = "Chaos Armor";
		if (self.armortype <= 0) self.armortype = ARMOR_CHAOS_TYPE;
		if (self.armorvalue <= 0) self.armorvalue = ARMOR_CHAOS_VALUE;
		self.respawn_style = PARTICLE_BURST_PURPLE + PARTICLE_BURST_RING;
		if (!self.part_active) self.part_active = PARTICLE_STYLE_PIERCE;
	}
	// Ninja
	if (self.count == 7) {
		// Setup default model
		if (self.mdl == "") { self.mdl = "progs/drake/armor.mdl"; self.skin = 9; }
		self.classtype = CT_ARMORNINJA;
		self.perms = POW_ARMORNINJA;
		if (self.netname == "") self.netname = "Ninja Fall Armor";
		if (self.armortype <= 0) self.armortype = ARMOR_NINJA_TYPE;
		if (self.armorvalue <= 0) self.armorvalue = ARMOR_NINJA_VALUE;
		self.respawn_style = PARTICLE_BURST_GREEN + PARTICLE_BURST_RING;
		if (!self.part_active) self.part_active = PARTICLE_STYLE_KEYGREEN;
	}
	
	// Setup default model
	if (self.mdl == "") { self.mdl = "progs/drake/armor.mdl"; } // Just in case
	precache_model (self.mdl);
	self.respawn_effect = TRUE;
	self.respawn_ofs = '0 0 24';
	item_armor_setup();
};

// Zerstorer's Courage Armor.
void() item_armor4 = { self.count = 0; self.classname = "item_armor_exotic"; item_armor_exotic(); };

//============
// --> QUAKED item_artifact_regeneration (0 .5 .8) (-16 -16 -24) (16 16 32)
// Raises health to maximum, then activates regeneration.
// Player can regenerate health at a rate of 50 per minute.
// Lasts until death or end of level.
//============
void() item_artifact_regeneration = {
	// Check for any random setups
	if (artifact_checkrandomizer() == TRUE) return;

	// Check for custom model setup?
	item_debugcustomdl();

	if (self.spawnflags & 1) {
		if (self.mdl == "") self.mdl = "progs/drake/regen2.mdl";
		self.perms = POW_REGENLESSER;
		if (self.netname == "") self.netname = "Lesser Rejuvenator";
	} else {
		if (self.mdl == "") self.mdl = "progs/drake/regen.mdl";
		self.perms = POW_REGEN;
		if (self.netname == "") self.netname = "Rejuvenator";
	}

	precache_model (self.mdl);
	if (self.noise == "") self.noise = "drake/items/regen.wav";
	precache_sound (self.noise);

	self.classtype = CT_ARTREGEN;
	if (self.skin == 1) {
		self.exactskin = self.skin;
		self.part_active = PARTICLE_STYLE_PENT;
		self.respawn_style = PARTICLE_BURST_RED + PARTICLE_BURST_CENTER;
		self.respawn_time = 30;
	} else {
		self.part_active = PARTICLE_STYLE_SUIT;
		self.respawn_style = PARTICLE_BURST_GREEN + PARTICLE_BURST_CENTER;
	}
	self.respawn_ofs = '0 0 16';
    artifact_setup();
};

//============
// --> QUAKED item_artifact_vitality (0 .5 .8) (-16 -16 -24) (16 16 32)
// Increases maximum health and health by 25.
// Maximum health boost lasts until end of level.
// FIXME:  Make heart like Zelda's Heart Containers (i.e., permanent).
//============
void() item_artifact_vitality = {
	// Check for any random setups
	if (artifact_checkrandomizer() == TRUE) return;

	// Check for custom model setup?
	item_debugcustomdl();

	if (self.mdl == "") self.mdl = "progs/drake/life_up.mdl";
	self.perms = POW_VITALITY;
	if (self.netname == "") self.netname = "Heart of Darkness";
	precache_model (self.mdl);
	if (self.noise == "") self.noise = "drake/items/life_up.wav";
	precache_sound (self.noise);
    self.max_health = 25;
	self.classtype = CT_ARTVITALITY;
	self.part_active = PARTICLE_STYLE_PENT;
	self.respawn_style = PARTICLE_BURST_RED + PARTICLE_BURST_CENTER;
	self.respawn_ofs = '0 0 16';
    artifact_setup();
};
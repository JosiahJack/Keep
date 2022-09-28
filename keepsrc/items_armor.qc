//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by W. Josiah Jack, aka Qmaster
//
// Attributions: ID1, Drake, Arcane Dimensions (AD)
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
// Entity count: 6
// Function count: 9
//
// Implements: Armor Item Pickups
//
// Description:
// The various armor items that can be picked up and their helper functions.
//=============================================================================

// Returns the damage absorbed by power armor.
// Called by 'T_Damage' in combat.qc.
float(entity targ, float damage, float drain) PowerArmor_Absorb = { // [FUNCTION]
    local   float   save, fuel;

    save = 0;
	save = ceil (damage * 0.5);   // Absorb half damage, round up.
	fuel = floor(targ.ammo_cells * 2);  // uses 1 cell per 2 damage
	if (save > fuel) save = fuel;
	if (drain) {
		targ.ammo_cells = targ.ammo_cells - ceil(save / 2);  // uses 1 cell per 2 damage
		if (targ.ammo_cells < 0) targ.ammo_cells = 0;
		//Update_PowerArmor (targ);
		Particle_Cube (targ, 241, 241);
		sound(targ,CHAN_AUTO,"zerstorer/me/me_fire1.wav",1,ATTN_NORM);
	}
    return save;
};

// Gives instructions to player.  Called on first pickup of usable armor.
void(entity ent) PowerArmor_Awaken = { // [FUNCTION]
    if (!(other.flags & FL_CLIENT)) return;

    sound(ent,CHAN_VOICE, "misc/talk.wav",1,ATTN_NORM);
    centerprint (ent, "Power Armor!\nPress 'L' to toggle.\nUses cells when hit.");
};

void(entity ent) BerserkerArmor_Awaken = { // [FUNCTION]
    if (!(other.flags & FL_CLIENT)) return;

    sound(ent,CHAN_VOICE, "misc/talk.wav",1,ATTN_NORM);
    centerprint (ent, "Demonhide Armor!\nPress 'K' to expend for Quad Damage!\nKills repair armor while equipped.");
};

void(entity ent) SpiritArmor_Awaken = { // [FUNCTION]
    if (!(other.flags & FL_CLIENT)) return;

    sound(ent,CHAN_VOICE, "misc/talk.wav",1,ATTN_NORM);
    centerprint (ent, "Spirit Shroud!\nPress 'J' to expend for Invisibility!");
};

void(entity ent) DragonArmor_Awaken = { // [FUNCTION]
    if (!(other.flags & FL_CLIENT)) return;

    sound(ent,CHAN_VOICE, "misc/talk.wav",1,ATTN_NORM);
    centerprint (ent, "Dragon Armor!\nPress 'H' to expend for Invulnerability.");
};

void(entity ent) OnyxArmor_Awaken = { // [FUNCTION]
    if (!(other.flags & FL_CLIENT)) return;

    sound(ent,CHAN_VOICE, "misc/talk.wav",1,ATTN_NORM);
    centerprint (ent, "Onyx Armor!\nAll damage permanently halved!");
};

float(entity armplayer, entity armitem) armor_pickupcondition = { return ((armplayer.armortype * armplayer.armorvalue) >= (armitem.armortype * armitem.armorvalue)); }; // [FUNCTION]

void() armor_touch = { // [FUNCTION]
	if (other.health <= 0) return;
    if (!(other.flags & FL_CLIENT)) return;

	// If not exotic, handle exclusivity for normal Armor 1, 2, or Inv(3)
	if (!self.perms)  {
		if (armor_pickupcondition(other, self)) return; // Cannot pickup armour if wearing something better!

		armour_touchrandomizer();
		other.items2 = other.items2 - (other.items2 & (IT2_ARMOR1 | IT2_ARMOR2 | IT2_ARMOR3)) + self.items2;		
		other.armortype = self.armortype; // Only normal armor affects actual armortype and armorvalue
		other.armorvalue = self.armorvalue;
	} else {
		if (other.perms & self.perms) return; // Already have this, don't give more than one of each
		
		if (self.classtype == CT_ARMORONYXPOWER && !(other.perms & POW_ARMORONYXPOWER)) PowerArmor_Awaken(other);
		if (self.classtype == CT_ARMORBERSERKER && !(other.perms & POW_ARMORBERSERKER)) BerserkerArmor_Awaken(other);
		if (self.classtype == CT_ARMORSPIRIT && !(other.perms & POW_ARMORSPIRIT)) SpiritArmor_Awaken(other);
		if (self.classtype == CT_ARMORDRAGON && !(other.perms & POW_ARMORDRAGON)) DragonArmor_Awaken(other);
		if (self.classtype == CT_ARMORONYX && !(other.perms & POW_ARMORONYX)) OnyxArmor_Awaken(other);
		other.perms = other.perms | self.perms; // perms are nonexclusive, we can have multiple types of armor on weehee! -Qmaster
		if (self.aflag > 0) other.ammo_cells = other.ammo_cells + self.aflag; // Add cells for power shield
	}
	sprint(other, "You got the ");
	sprint(other, self.netname);
	sprint(other, "\n");
	if (self.noise != SOUND_EMPTY) sound(other,CHAN_ITEM,self.noise,1,ATTN_NORM);
	Safe_stuffcmd (other, "bf\n");
	activator = other;
	SUB_UseTargets();
	if (self.progspawnlist) return; // Quick exit, no need for following stuff
	
	item_finished();
	if (!self.respawn_trig) start_item_respawn();
};

void() item_armor_setup = { // [FUNCTION]
	self.classgroup = CG_ARMOR;
	if (!self.part_active) self.part_active = PARTICLE_STYLE_ARMOR;
	self.touch2 = armor_touch;
	self.bbmins = VEC_ITEM_MIN;
	self.bbmaxs = '16 16 56';
	if (self.respawn_time == 0) self.respawn_time = RESPAWN_ARMOR;
	item_setupnoise("items/armor1.wav");
	item_coopcheck(); // Check for coop errors
	item_start();
};

// Green Armour with 100 armor value
void() item_armor1 = { // [ENTITY]
	if (armour_checkrandomizer() == TRUE) return; // Check for any random setups

	item_setupmodel("progs/ad171/armour.mdl",0);	
	self.classtype = CT_ARMOR1;
	self.items2 = IT2_ARMOR1;
	if (self.netname == "") self.netname = "Green Armor";
	if (self.armortype <= 0) self.armortype = ARMOR_GRN_TYPE;
	if (self.armorvalue <= 0) self.armorvalue = ARMOR_GRN_VALUE;
	self.respawn_effect = TRUE;
	self.respawn_style = PARTICLE_BURST_GREEN + PARTICLE_BURST_RING;
	self.respawn_ofs = '0 0 24';
	item_armor_setup();
};

// Yellow Armour with 150 armor value
void() item_armor2 = { // [ENTITY]
	if (armour_checkrandomizer() == TRUE) return;
	
	self.classtype = CT_ARMOR2;
	self.items2 = IT2_ARMOR2;
	if (self.armortype <= 0) self.armortype = ARMOR_YEL_TYPE;
	if (self.armorvalue <= 0) self.armorvalue = ARMOR_YEL_VALUE;
	self.respawn_effect = TRUE;
	self.respawn_ofs = '0 0 24';

	if (self.spawnflags & ARMOR_BLUE) { // Setup alternative colour
		item_setupmodel("progs/ad171/armour.mdl",3); 
		if (self.netname == "") self.netname = "Blue Armor";
		self.respawn_style = PARTICLE_BURST_BLUE + PARTICLE_BURST_RING;
	} else {
		item_setupmodel("progs/ad171/armour.mdl",1);
		if (self.netname == "") self.netname = "Yellow Armor";
		self.respawn_style = PARTICLE_BURST_YELLOW + PARTICLE_BURST_RING;
	}
	item_armor_setup();
};

// Red Armour with 200 armor value
void() item_armorInv = { // [ENTITY]
	if (armour_checkrandomizer() == TRUE) return;

	item_setupmodel("progs/ad171/armour.mdl",2);
	self.classtype = CT_ARMORINV;
	self.items2 = IT2_ARMOR3;
	if (self.netname == "") self.netname = "Red Armor";
	if (self.armortype <= 0) self.armortype = ARMOR_RED_TYPE;
	if (self.armorvalue <= 0) self.armorvalue = ARMOR_RED_VALUE;
	self.respawn_effect = TRUE;
	self.respawn_style = PARTICLE_BURST_RED + PARTICLE_BURST_RING;
	self.respawn_ofs = '0 0 24';
	item_armor_setup();
};

// --> QUAKED item_armor_exotic (0 .5 .8) (-16 -16 0) (16 16 32)
// Custom Exotic Armor.
// spawnflags
// 1 = Courage armor (reflects missiles, frontal protection only.  Zerstorer)
// 2 = Dragonscale (red armor that morphs player into dragon.  Soul of Evil)
// 3 = Onyx armor (indestructible, 50% protection.  Inspired by DoomRL.)
// 4 = Power armor (as Onyx, plus power shield like in Quake2)
// 5 = Demonhide (cursed, increases damage taken, but regenerates hp)
// 6 = Spirit shroud (stealth, absorbs up to 25 damage, self-repairs)
// 7 = Chaos armor (variable protection, can teleport as Chaos device from Heretic)
// 8 = Jump armor (green armor with high jump and half health regeneration)
void() item_armor_exotic = { // [ENTITY]
	if (self.count > 7) self.count = 7;
	item_setupnoise("items/armor1.wav");
	if (self.count == 1) { // Dragonscale
		item_setupmodel("progs/drake/armor.mdl",6);
		self.classtype = CT_ARMORDRAGON;
		self.perms = POW_ARMORDRAGON;
		if (self.netname == "") self.netname = "Dragonscale Armor";
		if (self.armortype <= 0) self.armortype = ARMOR_DRAGON_TYPE;
		if (self.armorvalue <= 0) self.armorvalue = ARMOR_DRAGON_VALUE;
		self.respawn_style = PARTICLE_BURST_RED + PARTICLE_BURST_RING;
		if (!self.part_active) self.part_active = PARTICLE_STYLE_ALTAR;
		precache_sound(SOUND_ARTPENT1);
	} else if (self.count == 2) { // Onyx
		item_setupmodel("progs/drake/armor.mdl",4);
		self.classtype = CT_ARMORONYX;
		self.perms = POW_ARMORONYX;
		if (self.netname == "") self.netname = "Onyx Armor";
		if (self.armortype <= 0) self.armortype = ARMOR_ONYX_TYPE;
		if (self.armorvalue <= 0) self.armorvalue = ARMOR_ONYX_VALUE;
		self.respawn_style = PARTICLE_BURST_WHITE + PARTICLE_BURST_RING;
		if (!self.part_active) self.part_active = PARTICLE_STYLE_BACKPACK;
	} else if (self.count == 3) { // Power
		item_setupmodel("progs/drake/armor.mdl",5);
		precache_sound("zerstorer/me/me_soff.wav");
		precache_sound("zerstorer/me/me_son.wav");
		self.classtype = CT_ARMORONYXPOWER;
		self.perms = POW_ARMORONYXPOWER;
		if (self.netname == "") self.netname = "Power Armor";
		if (self.armortype <= 0) self.armortype = ARMOR_ONYXPOWER_TYPE;
		if (self.armorvalue <= 0) self.armorvalue = ARMOR_ONYXPOWER_VALUE;
		self.respawn_style = PARTICLE_BURST_YELLOW + PARTICLE_BURST_RING;
		if (!self.part_active) self.part_active = PARTICLE_STYLE_KEYGOLD;
		precache_sound("zerstorer/me/me_fire1.wav"); // shield hit
		if (self.aflag < 1) self.aflag = AMMO_CELLS_WPN;
	} else if (self.count == 4) { // Demon
		item_setupmodel("progs/drake/armor.mdl",3);
		self.classtype = CT_ARMORBERSERKER;
		self.perms = POW_ARMORBERSERKER;
		if (self.netname == "") self.netname = "Demonhide Armor"; // formerly Bersker, confusing with Berserker Helm
		if (self.armortype <= 0) self.armortype = ARMOR_BERSERKER_TYPE;
		if (self.armorvalue <= 0) self.armorvalue = ARMOR_BERSERKER_VALUE;
		self.respawn_style = PARTICLE_BURST_RED + PARTICLE_BURST_RING;
		if (!self.part_active) self.part_active = PARTICLE_STYLE_PENT;
		precache_sound(SOUND_ARTQUAD1);
	} else if (self.count == 5) { // Spirit Shroud
		item_setupmodel("progs/drake/armor.mdl",7);
		self.classtype = CT_ARMORSPIRIT;
		self.perms = POW_ARMORSPIRIT;
		if (self.netname == "") self.netname = "Spirit Shroud";
		if (self.armortype <= 0) self.armortype = ARMOR_SPIRIT_TYPE;
		if (self.armorvalue <= 0) self.armorvalue = ARMOR_SPIRIT_VALUE;
		self.respawn_style = PARTICLE_BURST_PURPLE + PARTICLE_BURST_RING;
		if (!self.part_active) self.part_active = PARTICLE_STYLE_SHARP;
		precache_sound(SOUND_ARTINV1);
	} else if (self.count == 6) { // Chaos
		item_setupmodel("progs/drake/armor.mdl",8);
		self.classtype = CT_ARMORCHAOS;
		self.perms = POW_ARMORCHAOS;
		if (self.netname == "") self.netname = "Chaos Armor";
		if (self.armortype <= 0) self.armortype = ARMOR_CHAOS_TYPE;
		if (self.armorvalue <= 0) self.armorvalue = ARMOR_CHAOS_VALUE;
		self.respawn_style = PARTICLE_BURST_PURPLE + PARTICLE_BURST_RING;
		if (!self.part_active) self.part_active = PARTICLE_STYLE_PIERCE;
	} else if (self.count == 7) { // Ninja
		item_setupmodel("progs/drake/armor.mdl",9);
		self.classtype = CT_ARMORNINJA;
		self.perms = POW_ARMORNINJA;
		if (self.netname == "") self.netname = "Ninja Fall Armor";
		if (self.armortype <= 0) self.armortype = ARMOR_NINJA_TYPE;
		if (self.armorvalue <= 0) self.armorvalue = ARMOR_NINJA_VALUE;
		self.respawn_style = PARTICLE_BURST_GREEN + PARTICLE_BURST_RING;
		if (!self.part_active) self.part_active = PARTICLE_STYLE_KEYGREEN;
	} else { // Courage
		item_setupmodel("progs/drake/courage.mdl",0);
		self.classtype = CT_ARMORCOURAGE;
		self.perms = POW_ARMORCOURAGE;
		if (self.netname == "") self.netname = "Courage Armor";
		if (self.armortype <= 0) self.armortype = ARMOR_COURAGE_TYPE;
		if (self.armorvalue <= 0) self.armorvalue = ARMOR_COURAGE_VALUE;
		self.respawn_style = PARTICLE_BURST_WHITE + PARTICLE_BURST_RING;
		if (!self.part_active) self.part_active = PARTICLE_STYLE_KEYWHITE;
	}
	self.respawn_effect = TRUE;
	self.respawn_ofs = '0 0 24';
	item_armor_setup();
};

// Zerstorer's Courage Armor.
void() item_armor4 = { self.count = 0; self.classname = "item_armor_exotic"; item_armor_exotic(); }; // [ENTITY]

void() item_backpack_armour = { // [ENTITY]
	item_setupnoise("ad171/items/backpack_armour.wav");
	self.classtype = CT_ARMORITEMPACK;

	// Default armour amount is 15
	// Check for different armour types
	if (self.spawnflags & BACKPACK_GRNTYPE) {
		self.armortype = ARMOR_GRN_TYPE; self.exactskin = 1;
		if (self.armorvalue < 1) self.armorvalue = BACKARMGRN;
	} else if (self.spawnflags & BACKPACK_YELTYPE) {
		self.armortype = ARMOR_YEL_TYPE; self.exactskin = 4;
		if (self.armorvalue < 1) self.armorvalue = BACKARMYEL;
	} else if (self.spawnflags & BACKPACK_REDTYPE) {
		self.armortype = ARMOR_RED_TYPE; self.exactskin = 3;
		if (self.armorvalue < 1) self.armorvalue = BACKARMRED;
	} else { // default = shards, no armour type
		self.armortype = 0; self.exactskin = 4;
		if (self.armorvalue < 1) self.armorvalue = BACKARMGRN;
	}
	
	// make sure all ammo is removed from backpack
	if (self.spawnflags & BACKPACK_SHELLS) self.spawnflags = self.spawnflags - BACKPACK_SHELLS;
	if (self.spawnflags & BACKPACK_NAILS) self.spawnflags = self.spawnflags - BACKPACK_NAILS;
	if (self.spawnflags & BACKPACK_ROCKETS) self.spawnflags = self.spawnflags - BACKPACK_ROCKETS;
	if (self.spawnflags & BACKPACK_CELLS) self.spawnflags = self.spawnflags - BACKPACK_CELLS;
	
	item_backpack(); // Feed back into backpack function. Yummy!
};
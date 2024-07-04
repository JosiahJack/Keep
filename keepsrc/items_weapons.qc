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
// Entity count: 41
// Function count: 5
//
// Implements: Weapon Entities
//
// Description:
// Contains the entity definitions for weapon item pickups and related helper
// functions.
//=============================================================================

// Deathmatch Weapon Rules
void(entity targ, float new, float oldhackbank, float oldweapon) DM_Weapon = {
	local float oldrank, newrank;
	local vector retid;

	// change targ.weapon if desired
	oldrank = GetWepIDIndex(oldweapon, oldhackbank); // passed along old value so it corresponded, targ.weapon not changed yet
	newrank = GetWepIDIndex (new, targ.weaponismoditems); // But we already changed weaponismoditems before getting here
	if ( newrank > oldrank ) {
		retid = GetWepIT_FromID(new);
		targ.weapon = retid_x;
		targ.weaponismoditems = retid_y;
	}
};

void(entity targ) bound_other_ammo = {
	if (targ.ammo_shells > targ.maxshells) targ.ammo_shells = targ.maxshells;
	if (targ.ammo_nails > targ.maxnails) targ.ammo_nails = targ.maxnails;
	if (targ.ammo_rockets > targ.maxrockets) targ.ammo_rockets = targ.maxrockets;	
	if (targ.ammo_cells > targ.maxcells) targ.ammo_cells = targ.maxcells;
	if (targ.ammo_bolts > targ.maxbolts) targ.ammo_bolts = targ.maxbolts;
	if (targ.ammo_poison > targ.maxpoison) targ.ammo_poison = targ.maxpoison;
	if (targ.ammo_lava_nails > targ.maxlavanails) targ.ammo_lava_nails = targ.maxlavanails;
	if (targ.ammo_multi_rockets > targ.maxmultirockets) targ.ammo_multi_rockets = targ.maxmultirockets;
	if (targ.ammo_plasma > targ.maxplasma) targ.ammo_plasma = targ.maxplasma;	
	if (targ.ammo_bloodcrystals > targ.maxblood) targ.ammo_bloodcrystals = targ.maxblood;
	if (targ.ammo_voidshards > targ.maxvoid) targ.ammo_voidshards = targ.maxvoid;
	if (targ.ammo_elemental > targ.maxmana) targ.ammo_elemental = targ.maxmana;	
};

void(float amount) item_ammo_set = {
	if (self.aflag == 0) self.aflag = amount;
	else if (self.aflag < 0) self.aflag = 0;
	// else leave self.aflag at user specified value to allow for custom ammo amount.
};

void (entity comboOwner) EnableComboWeapons = { // [FUNCTION]
	if (!(comboOwner.flags & FL_CLIENT)) return;

	if (!(comboOwner.items & IT_LAVA_NAILGUN)) {
		if (comboOwner.ammo_lava_nails > 0 && (comboOwner.items & IT_NAILGUN)) {
			sprint(comboOwner,"Lava Enabled\n");
			comboOwner.items = (comboOwner.items | IT_LAVA_NAILGUN);
		}
	}

	if (!(comboOwner.items & IT_LAVA_SUPER_NAILGUN)) {
		if (comboOwner.ammo_lava_nails > 0 && (comboOwner.items & IT_SUPER_NAILGUN)) {
			sprint (comboOwner,"Super Lava Enabled!\n");
			comboOwner.items = (comboOwner.items | IT_LAVA_SUPER_NAILGUN);
		}
	}

	if (!(comboOwner.items & IT_MULTI_GRENADE)) {
		if (comboOwner.ammo_multi_rockets > 0
			&& ((comboOwner.items & IT_GRENADE_LAUNCHER)
				|| (comboOwner.items2 & IT2_PROXIMITY_GUN))) {
			sprint (comboOwner,"Multi Grenades Enabled\n");
			comboOwner.items = (comboOwner.items | IT_MULTI_GRENADE);
		}
	}

	if (!(comboOwner.items & IT_MULTI_ROCKET)) {
		if (comboOwner.ammo_multi_rockets > 0 && (comboOwner.items & IT_ROCKET_LAUNCHER)) {
			sprint(comboOwner,"Multi Rockets Enabled\n");
			comboOwner.items = (comboOwner.items | IT_MULTI_ROCKET);
		}
	}
	if (!(comboOwner.items & IT_PLASMA_GUN)) {
		if (comboOwner.ammo_plasma > 0 && (comboOwner.items & IT_LIGHTNING)) {
			sprint(comboOwner,"Plasma Lightning Gun Enabled\n");
			comboOwner.items = (comboOwner.items | IT_PLASMA_GUN);
		}
	}
};

void() weapon_start = { // [FUNCTION]
	self.classgroup = CG_WEAPON;
	self.touch2 = weapon_touch;
	self.bbmins = VEC_ITEM_MIN;
	self.bbmaxs = VEC_ITEM_MAX;
	if (self.noise == "") self.noise = "weapons/pkup.wav";
	if (self.respawn_time == 0) self.respawn_time = RESPAWN_WEAPON;
	if (self.netname == "") self.netname = "Weapon";
	item_start();
};

void() weapon_touch = { // [FUNCTION]
	local float best, new, leave, oldhackbank, oldweapon;
	
	best = W_BestWeapon(other); // if the player was using his best weapon change up to the new one if better	
	// Deathmatch/coop switch
	if (deathmatch == 2 || coop) leave = TRUE;
	else leave = FALSE;
	oldhackbank = self.weaponismoditems;
	other.weaponismoditems = FALSE;
	oldweapon = other.weapon;
	new = -1;

	//=======================================SELF.ITEMS1====================================================== 
	if (self.classtype == CT_SHOTGUN) {
		if (leave && (other.items & IT_SHOTGUN) ) return;
		new = IT_SHOTGUN;
		other.ammo_shells = other.ammo_shells + self.aflag;
		other.items = other.items | IT_SHOTGUN;
		other.weapon = IT_SHOTGUN;
	} else if (self.classtype == CT_SUPER_SHOTGUN) {
		if (leave && (other.items & IT_SUPER_SHOTGUN) ) return;
		new = IT_SUPER_SHOTGUN;
		other.ammo_shells = other.ammo_shells + self.aflag;
		other.items = other.items | IT_SUPER_SHOTGUN;
		other.weapon = IT_SUPER_SHOTGUN;
	} else if (self.classtype == CT_NAILGUN) {
		if (leave && (other.items & IT_NAILGUN) ) return;
		new = IT_NAILGUN;
		other.ammo_nails = other.ammo_nails + self.aflag;
		other.items = other.items | IT_NAILGUN;
		other.weapon = IT_NAILGUN;
	} else if (self.classtype == CT_SUPER_NAILGUN) {
		if (leave && (other.items & IT_SUPER_NAILGUN) ) return;
		new = IT_SUPER_NAILGUN;
		other.ammo_nails = other.ammo_nails + self.aflag;
		other.items = other.items | IT_SUPER_NAILGUN;
		other.weapon = IT_SUPER_NAILGUN;
	} else if (self.classtype == CT_GRENADE_LAUNCHER) {
		if (leave && (other.items & IT_GRENADE_LAUNCHER) ) return;
		new = IT_GRENADE_LAUNCHER;
		other.ammo_rockets = other.ammo_rockets + self.aflag;
		other.items = other.items | IT_GRENADE_LAUNCHER;
		other.weapon = IT_GRENADE_LAUNCHER;
	} else if (self.classtype == CT_ROCKET_LAUNCHER) {
		if (leave && (other.items & IT_ROCKET_LAUNCHER) ) return;
		new = IT_ROCKET_LAUNCHER;
		other.ammo_rockets = other.ammo_rockets + self.aflag;
		other.ammo_rockets = other.ammo_rockets + self.aflag;
		other.items = other.items | IT_ROCKET_LAUNCHER;
		other.weapon = IT_ROCKET_LAUNCHER;
	} else if (self.classtype == CT_LIGHTNING) {
		if (leave && (other.items & IT_LIGHTNING) ) return;
		new = IT_LIGHTNING;
		other.ammo_cells = other.ammo_cells + self.aflag;
		other.items = other.items | IT_LIGHTNING;
		other.weapon = IT_LIGHTNING;
	} else if (self.classtype == CT_AXE) {
		if (leave && (other.items & IT_AXE) ) return;
		new = IT_AXE;
		other.items = other.items | IT_AXE;
		other.weapon = IT_AXE;
	} else if (self.classtype == CT_LAVANG) {
		if (leave && (other.items & IT_LAVA_NAILGUN) ) return;
		new = IT_LAVA_NAILGUN;
		other.ammo_lava_nails = other.ammo_lava_nails + self.aflag;
		other.items = other.items | IT_LAVA_NAILGUN;
		other.weapon = IT_LAVA_NAILGUN;
	} else if (self.classtype == CT_LAVASNG) {
		if (leave && (other.items & IT_LAVA_SUPER_NAILGUN) ) return;
		new = IT_LAVA_SUPER_NAILGUN;
		other.ammo_lava_nails = other.ammo_lava_nails + self.aflag;
		other.items = other.items | IT_LAVA_SUPER_NAILGUN;
		other.weapon = IT_LAVA_SUPER_NAILGUN;
	} else if (self.classtype == CT_MULTI_GRENADE) {
		if (leave && (other.items & IT_MULTI_GRENADE) ) return;
		new = IT_MULTI_GRENADE;
		other.ammo_multi_rockets = other.ammo_multi_rockets + self.aflag;
		other.items = other.items | IT_MULTI_GRENADE;
		other.weapon = IT_MULTI_GRENADE;
	} else if (self.classtype == CT_MULTI_ROCKET) {
		if (leave && (other.items & IT_MULTI_ROCKET) ) return;
		new = IT_MULTI_ROCKET;
		other.ammo_multi_rockets = other.ammo_multi_rockets + self.aflag;
		other.items = other.items | IT_MULTI_ROCKET;
		other.weapon = IT_MULTI_ROCKET;
	} else if (self.classtype == CT_PLASMAGUN) { // Rogue
		if (leave && (other.items & IT_PLASMA_GUN) ) return;
		new = IT_PLASMA_GUN;
		other.ammo_plasma = other.ammo_plasma + self.aflag;
		other.items = other.items | IT_PLASMA_GUN;
		other.weapon = IT_PLASMA_GUN;
	} else if (self.classtype == CT_EXTRA_WEAPON) {
		if (leave && (other.items & IT_CROSSBOW) ) return;
		other.ammo_bolts = other.ammo_bolts + self.aflag;
		new = IT_CROSSBOW;
		other.items = other.items | IT_CROSSBOW;
		other.weapon = IT_CROSSBOW;
	}
	//
	//=======================================SELF.ITEMS2======================================================
	else if (self.classtype == CT_CHAINLIGHTGUN) {
		if (leave && (other.items2 & IT2_CHAINLIGHTNING) ) return;
		new = IT2_CHAINLIGHTNING;
		other.ammo_cells = other.ammo_cells + self.aflag;
		other.items2 = other.items2 | IT2_CHAINLIGHTNING;
		other.weapon = IT2_CHAINLIGHTNING;
	} else if (self.classtype == CT_PROXIMITY_GUN) {
		if (leave && (other.items2 & IT2_PROXIMITY_GUN) ) return;
		new = IT2_PROXIMITY_GUN;
		other.ammo_rockets = other.ammo_rockets + self.aflag;
		other.items2 = other.items2 | IT2_PROXIMITY_GUN;
		other.weapon = IT2_PROXIMITY_GUN;
	} else if (self.classtype == CT_MJOLNIR) {
		if (leave && (other.items2 & IT2_MJOLNIR) ) return;
		new = IT2_MJOLNIR;
		other.ammo_cells = other.ammo_cells + self.aflag;
		other.items2 = other.items2 | IT2_MJOLNIR;
		other.weapon = IT2_MJOLNIR;
	} else if (self.classtype == CT_LASER_CANNON) {
		if (leave && (other.items2 & IT2_LASER_CANNON) ) return;
		new = IT2_LASER_CANNON;
		other.ammo_cells = other.ammo_cells + self.aflag;
		other.items2 = other.items2 | IT2_LASER_CANNON;
		other.weapon = IT2_LASER_CANNON;
	} else if (self.classtype == CT_GRAPPLE) {
		if (leave && (other.items2 & IT2_GRAPPLE) ) return;
		new = IT2_GRAPPLE;
		other.items2 = other.items2 | IT2_GRAPPLE;
		other.weapon = IT2_GRAPPLE;
	} else if (self.classtype == CT_WAND) {
		if (leave && (other.items2 & IT2_WAND) ) return;
		new = IT2_WAND;
		other.items2 = other.items2 | IT2_WAND;
		other.weapon = IT2_WAND; // I shouldn't really need this should I?
	}
	//
	//=======================================SELF.MODITEMS======================================================
	else if (self.classtype == CT_UPGRADE_SSG) {				// OVERRIDE
		if (leave && (other.moditems & IT_UPGRADE_SSG) ) return;
		update_configflag(SVR_UPDSSG, TRUE);
		new = IT_UPGRADE_SSG;
		other.ammo_shells = other.ammo_shells + self.aflag;
		other.items = other.items | IT_SUPER_SHOTGUN; // make sure we give super shotgun
		other.moditems = other.moditems | IT_UPGRADE_SSG;
		other.weapon = IT_SUPER_SHOTGUN;
			} else if (self.classtype == CT_ICE) {				// HACKBANK!
				if (leave && (other.moditems & IT_ICE) ) return;
				other.weaponismoditems = TRUE;
				new = IT_ICE;
				other.ammo_elemental = other.ammo_elemental + self.aflag;
				other.moditems = other.moditems | IT_ICE;
				other.weapon = IT_ICE;
			} else if (self.classtype == CT_MACE) {				// HACKBANK!
				if (leave && (other.moditems & IT_MACE) ) return;
				other.weaponismoditems = TRUE;
				new = IT_MACE;
				other.ammo_bloodcrystals = other.ammo_bloodcrystals + self.aflag;
				other.moditems = other.moditems | IT_MACE;
				other.weapon = IT_MACE;
			} else if (self.classtype == CT_VOID_STAFF) {		// HACKBANK!
				if (leave && (other.moditems & IT_VOID_STAFF) ) return;
				other.weaponismoditems = TRUE;
				new = IT_VOID_STAFF;
				other.ammo_voidshards = other.ammo_voidshards + self.aflag;
				other.moditems = other.moditems | IT_VOID_STAFF;
				other.weapon = IT_VOID_STAFF;
			} else if (self.classtype == CT_FLAK) {				// HACKBANK!
				if (leave && (other.moditems & IT_FLAK) ) return;
				other.weaponismoditems = TRUE;
				new = IT_FLAK;
				other.ammo_nails = other.ammo_nails + self.aflag;
				other.ammo_rockets = other.ammo_rockets + (ceil(self.aflag/3));
				other.moditems = other.moditems | IT_FLAK;
				other.weapon = IT_FLAK;
	} else if (self.classtype == CT_UPGRADE_LG) {				// OVERRIDE
		if (leave && (other.moditems & IT_UPGRADE_LG) ) return;
		update_configflag(SVR_UPDLG, TRUE);
		new = IT_UPGRADE_LG;
		other.ammo_cells = other.ammo_cells + self.aflag;
		other.items = other.items | IT_LIGHTNING;
		other.moditems = other.moditems | IT_UPGRADE_LG;
		other.weapon = IT_LIGHTNING;
			} else if (self.classtype == CT_GUNGNIR) {			// HACKBANK!
				if (leave && (other.moditems & IT_GUNGNIR) ) return;
				other.weaponismoditems = TRUE;
				new = IT_GUNGNIR;
				other.ammo_voidshards = other.ammo_voidshards + self.aflag;
				other.moditems = other.moditems | IT_GUNGNIR;
				other.weapon = IT_GUNGNIR;
	} else if (self.classtype == CT_SANGUINATORS) {
		if (leave && (other.moditems & IT_SANGUINATORS) ) return;
		new = IT_SANGUINATORS;
		other.ammo_bloodcrystals = other.ammo_bloodcrystals + self.aflag;
		other.moditems = other.moditems | IT_SANGUINATORS;
		other.weapon = IT_SANGUINATORS;
	} else if (self.classtype == CT_SCIMITAR) {
		if (leave && (other.moditems & IT_SCIMITAR) ) return;
		new = IT_SCIMITAR;
		other.ammo_elemental = other.ammo_elemental + self.aflag;
		other.moditems = other.moditems | IT_SCIMITAR;
		other.weapon = IT_SCIMITAR;
	} else if (self.classtype == CT_RAPIER) { // Arms of Asgard weapons by Ryan "ryanscissorhands" Holaday
		if (leave && (other.moditems & IT_RAPIER) ) return;
		new = IT_RAPIER;
		other.moditems = other.moditems | IT_RAPIER;
		other.weapon = IT_RAPIER;
	} else if (self.classtype == CT_UPGRADE_AXE) {				// OVERRIDE
		if (leave && (other.moditems & IT_UPGRADE_AXE) ) return;
		update_configflag(SVR_UPDAXE, TRUE);
		new = IT_UPGRADE_AXE;
		other.items = other.items | IT_AXE;
		other.moditems = other.moditems | IT_UPGRADE_AXE;
		other.weapon = IT_AXE;
	} else if (self.classtype == CT_MIRV) {						// OVERRIDE
		if (leave && (other.moditems & CT_MIRV) ) return;
		new = IT_MIRV;
		other.ammo_rockets = other.ammo_rockets + (self.aflag);
		other.items = other.items | IT_ROCKET_LAUNCHER;
		other.moditems = other.moditems | IT_MIRV;
		other.weapon = IT_ROCKET_LAUNCHER;
	}
	//
	//==========================================SELF.PERMS======================================================
	else if (self.classtype == CT_AIRGUN) {				// HACKBANK!
		if (leave && (other.perms & IT_AIRGUN) ) return;
		new = IT_AIRGUN;
		other.weaponismoditems = TRUE;
		other.perms = other.perms | IT_AIRGUN;
		other.weapon = IT_AIRGUN;
	} else if (self.classtype == CT_FROSTBOW) {					// OVERRIDE
		if (leave && (other.perms & IT_FROSTBOW)) return;
		new = IT_FROSTBOW;
		other.ammo_bolts = other.ammo_bolts + self.aflag;
		other.items = other.items | IT_CROSSBOW;
		other.perms = other.perms | IT_FROSTBOW;
		other.weapon = IT_CROSSBOW;
	} else if (self.classtype == CT_SIDEWINDER) {				// OVERRIDE
		if (leave && (other.perms & IT_SIDEWINDER) ) return;
		new = IT_SIDEWINDER;
		other.ammo_rockets = other.ammo_rockets + self.aflag;
		other.items2 = other.items2 | IT2_PROXIMITY_GUN;
		other.perms = other.perms | IT_SIDEWINDER;
		other.weapon = IT2_PROXIMITY_GUN;
	} else if (self.classtype == CT_BLASTERWEP) {				// OVERRIDE
		if (leave && (other.perms & IT_BLASTER) ) return;
		new = IT_BLASTER;
		other.ammo_shells = other.ammo_shells + self.aflag;
		other.items = other.items | IT_SHOTGUN;
		other.perms = other.perms | IT_BLASTER;
		other.weapon = IT_SHOTGUN;
	} else if (self.classtype == CT_CHAINSAW) {					// OVERRIDE
		if (leave && (other.perms & IT_CHAINSAW) ) return;
		new = IT_CHAINSAW;
		other.items = other.items | IT_AXE;
		other.perms = other.perms | IT_CHAINSAW;
		other.weapon = IT_AXE;
	//
	//==========================================SELF.PERMS======================================================
	} else if (self.classtype == CT_RIOTCONTROLLER) {				// OVERRIDE
		if (leave && (other.items3 & IT3_RIOTCONTROLLER) ) return;
		new = IT3_RIOTCONTROLLER;
		other.ammo_shells = other.ammo_shells + self.aflag;
		other.items = other.items | IT_SUPER_SHOTGUN; // make sure we give super shotgun
		other.items3 = other.items3 | IT3_RIOTCONTROLLER;
		other.weapon = IT_SUPER_SHOTGUN;
	} else return;

	// Display weapon name
	if (self.classtype == CT_UPGRADE_AXE && other.moditems & IT_UPGRADE_AXE)
		sprint(other, "You got another axe to grind");
	else if (self.classtype == CT_SUPER_SHOTGUN && other.moditems & IT_UPGRADE_SSG)
		sprint(other, "You got a handful of Shells");
	else if (self.classtype == CT_RIOTCONTROLLER && other.items3 & IT3_RIOTCONTROLLER)
		sprint(other, "You got a drum mag for your double barrel");
	else if (self.classtype == CT_UPGRADE_SSG && other.moditems & IT_UPGRADE_SSG)
		sprint(other, "You got triple barrel boomstick");
	else if (self.classtype == CT_LIGHTNING && other.moditems & IT_UPGRADE_LG)
		sprint(other, "You got some AAA batteries");
	else if (self.classtype == CT_UPGRADE_LG && other.moditems & IT_UPGRADE_LG)
		sprint(other, "You got another burst of plasma");
	else {
		sprint(other, "You got the ");
		sprint(other, self.netname);
	}

	sound(other,CHAN_ITEM,self.noise,1,ATTN_NORM);
	sprint(other, "\n");
	Safe_stuffcmd(other, "bf\n"); // Screen flash
	bound_other_ammo (other); // Make sure no ammo is over limits
	if (detected_mod == MOD_ROGUE) EnableComboWeapons(other);
	if (new > 0 && deathmatch) DM_Weapon(other,new,oldhackbank,oldweapon); // Skip any weapon switch if no new weapon.  Check for best weapon (DM only) and switch to it!
	W_SetCurrentAmmo(other,TRUE);
	if (leave) self.state = TRUE; // Make sure any targets on the weapon are fired for co-op.  This is basically a run once check using state as a flag.  Ideally no weapon should use important target triggers!  Code idea from Bengt Jardrup.
	activator = other;
	SUB_UseTargets();
	if (leave) return; // If co-op active, exit
	item_finished(); // hide item and check for respawn
	if (!self.respawn_trig) start_item_respawn();
};

// Shadow Axe, extra dmg and gib zombies
void() weapon_upgrade_axe = {
	item_setupmodel(MODEL_GWEAP_UPAXE,4);
	self.weapon = IT_UPGRADE_AXE;
	self.classtype = CT_UPGRADE_AXE;
	if (self.netname == "") self.netname = "Shadow Axe";
	if (self.upgrade_axe != 0) self.upgrade_axe = FALSE;
	weapon_start();
};

// The Widowmaker Shotgun, extra dmg, triple shot
void() weapon_upgrade_ssg = {
	item_setupmodel(MODEL_GWEAP_UPSSG,0);
	self.weapon = IT_UPGRADE_SSG;
	self.classtype = CT_UPGRADE_SSG;
	if (self.netname == "") self.netname = "Widowmaker Shotgun";
	if (self.upgrade_ssg != 0) self.upgrade_ssg = FALSE;
	item_ammo_set(AMMO_SHELLS_WPN);
	if (world.devdata & DEV_AMMO_N_HEALTH) world.deventity.ammo_shells = world.deventity.ammo_shells + self.aflag;
	weapon_start();
};

void() weapon_riot_controller = {
	item_setupmodel("progs/zerstorer/g_dshot.mdl",0);
	self.weapon = IT_UPGRADE_SSG;
	self.classtype = CT_RIOTCONTROLLER;
	if (self.netname == "") self.netname = "Riot Controller";
	self.items3 = IT3_RIOTCONTROLLER;
	item_ammo_set(AMMO_SHELLS_WPN);
	if (world.devdata & DEV_AMMO_N_HEALTH) world.deventity.ammo_shells = world.deventity.ammo_shells + self.aflag;
	weapon_start();
}

void() weapon_upgrade_lg = {
	item_setupmodel(MODEL_GWEAP_UPLG,0);
	precache_model (MODEL_PROJ_PLASMA);
	self.weapon = IT_UPGRADE_LG;
	self.classtype = CT_UPGRADE_LG;
	if (self.netname == "") self.netname = "Plasma Gun"; // AD Plasma Gun, direct & splashdamage
	if (self.upgrade_lg != 0) self.upgrade_lg = FALSE;
	item_ammo_set(AMMO_CELLS_WPN);
	if (world.devdata & DEV_AMMO_N_HEALTH) world.deventity.ammo_cells = world.deventity.ammo_cells + self.aflag;
	weapon_start();
};

void() weapon_shotgun = {
	item_setupmodel(MODEL_GWEAP_SG,0);
	self.weapon = IT_SHOTGUN;
	self.classtype = CT_SHOTGUN;
	if (self.netname == "") self.netname = "Sawn-off Shotgun";
	item_ammo_set(25); // Changed to 25 to match normal axe+shotgun start
	if (world.devdata & DEV_AMMO_N_HEALTH) world.deventity.ammo_shells = world.deventity.ammo_shells + self.aflag;
	weapon_start();
};

void() weapon_supershotgun = {
	if (query_configflag(SVR_UPDSSG)) { weapon_upgrade_ssg(); return; } // Query console variable 'temp1' for model upgrade option.  Cannot use global vars because they don't exist at this point.

	item_setupmodel(MODEL_GWEAP_SSG,0);
	self.weapon = IT_SUPER_SHOTGUN;
	self.classtype = CT_SUPER_SHOTGUN;
	if (self.netname == "") self.netname = "Double-barrelled Shotgun";
	item_ammo_set(AMMO_SHELLS_WPN);
	if (world.devdata & DEV_AMMO_N_HEALTH) world.deventity.ammo_shells = world.deventity.ammo_shells + self.aflag;
	weapon_start();
};

void() weapon_nailgun = {
	item_setupmodel(MODEL_GWEAP_NG,0);
	self.weapon = IT_NAILGUN;
	self.classtype = CT_NAILGUN;
	if (self.netname == "") self.netname = "Nailgun";
	item_ammo_set(AMMO_NAILS_WPN);
	if (world.devdata & DEV_AMMO_N_HEALTH) world.deventity.ammo_nails = world.deventity.ammo_nails + self.aflag;
	weapon_start();
};

void() weapon_supernailgun = {
	item_setupmodel(MODEL_GWEAP_SNG,0);
	self.weapon = IT_SUPER_NAILGUN;
	self.classtype = CT_SUPER_NAILGUN;
	if (self.netname == "") self.netname = "Super Nailgun"; // Perforator
	item_ammo_set(AMMO_NAILS_WPN);
	if (world.devdata & DEV_AMMO_N_HEALTH) world.deventity.ammo_nails = world.deventity.ammo_nails + self.aflag;
	weapon_start();
};

void() weapon_grenadelauncher = {
	item_setupmodel(MODEL_GWEAP_GL,0);
	self.weapon = IT_GRENADE_LAUNCHER;
	self.classtype = CT_GRENADE_LAUNCHER;
	if (self.netname == "") self.netname = "Grenade Launcher";
	item_ammo_set(AMMO_ROCKETS_WPN);
	if (world.devdata & DEV_AMMO_N_HEALTH) world.deventity.ammo_rockets = world.deventity.ammo_rockets + self.aflag;
	weapon_start();
};

void() weapon_rocketlauncher = {
	item_setupmodel(MODEL_GWEAP_RL,0);
	self.weapon = IT_ROCKET_LAUNCHER;
	self.classtype = CT_ROCKET_LAUNCHER;
	if (self.netname == "") self.netname = "Rocket Launcher";
	item_ammo_set(AMMO_ROCKETS_WPN);
	if (world.devdata & DEV_AMMO_N_HEALTH) world.deventity.ammo_rockets = world.deventity.ammo_rockets + self.aflag;
	weapon_start();
};

void() weapon_lightning = {
	item_setupmodel(MODEL_GWEAP_LG,0);
	self.weapon = IT_LIGHTNING;
	self.classtype = CT_LIGHTNING;
	if (self.netname == "") self.netname = "Thunderbolt";
	item_ammo_set(AMMO_CELLS_WPN);
	if (world.devdata & DEV_AMMO_N_HEALTH) world.deventity.ammo_cells = world.deventity.ammo_cells + self.aflag;
	weapon_start();
};

void() weapon_grapple = {
	item_setupmodel("progs/drake/g_grpple.mdl",0);
	self.weapon = IT2_GRAPPLE;
	self.classtype = CT_GRAPPLE;
	if (self.netname == "") self.netname = "Grapple";
	weapon_start();
};

void() weapon_chainsaw = {
	item_setupmodel(g_chainsawmodel,0);
	self.classtype = CT_CHAINSAW;
	self.noise = "zerstorer/weapons/sawidle.wav";
	if (self.netname == "") self.netname = "Chainsaw";
	weapon_start();
};

void() weapon_axe = {
	item_setupmodel(g_axemodel,0); // Set by world.qc, mapper can pick to use AD or original axe.
	self.weapon = IT_AXE;
	self.classtype = CT_AXE;
	if (self.netname == "") self.netname = "Axe";
	weapon_start();
};

void() weapon_mjolnir = {
	item_setupmodel("progs/hipnotic/g_hammer.mdl",0);
	self.weapon = IT2_MJOLNIR;
	self.classtype = CT_MJOLNIR;
	if (self.netname == "") self.netname = "Mjolnir (Thor's Hammer)";
	item_ammo_set(60); // Drake changed from 30 to 60 since it has so much extra cool stuff.  Oddly, it uses 25 now and not 30 so, weird number here. -Qmaster	
	if (world.devdata & DEV_AMMO_N_HEALTH) world.deventity.ammo_cells = world.deventity.ammo_cells + self.aflag;
	self.absmin = '-16 -16 -8';
	weapon_start();
};

void() weapon_wand = {
	item_setupmodel("progs/drake/g_wand.mdl",0);
	self.weapon = IT2_WAND;
	self.classtype = CT_WAND;
	if (self.netname == "") self.netname = "Freyr's Wand (Light Bringer)";
	weapon_start();
};

void() weapon_crossbow = {
	item_setupmodel("progs/g_crossbow.mdl",0);
	self.weapon = IT_CROSSBOW;
	self.classtype = CT_EXTRA_WEAPON; 
	if (self.netname == "") self.netname = "Hodr's Crossbow (Fatal)";
	item_ammo_set(AMMO_BOLTS_WPN);
	if (world.devdata & DEV_AMMO_N_HEALTH) world.deventity.ammo_bolts = world.deventity.ammo_bolts + self.aflag;
	weapon_start();
};

void() weapon_buriza = {
	item_setupmodel("progs/drake/g_xbow.mdl",0);
	self.weapon = IT_FROSTBOW;
	self.classtype = CT_FROSTBOW;
	if (self.netname == "") self.netname = "Asgard Arbalest (Skadi's Breath)";
	item_ammo_set(AMMO_BOLTS_WPN);
	if (world.devdata & DEV_AMMO_N_HEALTH) world.deventity.ammo_bolts = world.deventity.ammo_bolts + self.aflag;
	weapon_start();
};

void() weapon_lava_nailgun = {
	item_setupmodel("progs/g_lava.mdl",0);
	self.weapon = IT_LAVA_NAILGUN;
	self.classtype = CT_LAVANG;
	if (self.netname == "") self.netname = "Lava Nailgun";
	item_ammo_set(AMMO_LAVA_NAILS_WPN);
	if (world.devdata & DEV_AMMO_N_HEALTH) world.deventity.ammo_lava_nails = world.deventity.ammo_lava_nails + self.aflag;
	weapon_start();
};

void() weapon_lava_super_nailgun = {
	item_setupmodel("progs/g_lava2.mdl",0);
	self.weapon = IT_LAVA_SUPER_NAILGUN;
	self.classtype = CT_LAVASNG;
	if (self.netname == "") self.netname = "Lava Super Nailgun";
	item_ammo_set(AMMO_LAVA_NAILS_WPN);
	if (world.devdata & DEV_AMMO_N_HEALTH) world.deventity.ammo_lava_nails = world.deventity.ammo_lava_nails + self.aflag;
	weapon_start();
};

void() weapon_sidewinder = {
	item_setupmodel("progs/madfox/mf_g_rock.mdl",0);
	self.weapon = IT2_PROXIMITY_GUN;
	self.perms = IT_SIDEWINDER;
	self.classtype = CT_SIDEWINDER;
	if (self.netname == "") self.netname = "Sidewinder";
	item_ammo_set(AMMO_ROCKETS_WPN);
	if (world.devdata & DEV_AMMO_N_HEALTH) world.deventity.ammo_rockets = world.deventity.ammo_rockets + self.aflag;
	weapon_start();
};

void() weapon_proximity_gun = {
	item_setupmodel("progs/hipnotic/g_prox.mdl",0);
	self.weapon = IT2_PROXIMITY_GUN;
	self.classtype = CT_PROXIMITY_GUN;
	if (self.netname == "") self.netname = "Proximity Grenade Launcher";
	item_ammo_set(AMMO_ROCKETS_WPN);
	if (world.devdata & DEV_AMMO_N_HEALTH) world.deventity.ammo_rockets = world.deventity.ammo_rockets + self.aflag;
	weapon_start();
};

void() weapon_laser_gun = {
	item_setupmodel(MODEL_GWEAP_LASER,0);
	self.weapon = IT2_LASER_CANNON;
	self.classtype = CT_LASER_CANNON;
	if (self.netname == "") self.netname = "Laser Cannon";
	item_ammo_set(AMMO_CELLS_WPN * 2);
	if (world.devdata & DEV_AMMO_N_HEALTH) world.deventity.ammo_cells = world.deventity.ammo_cells + self.aflag;
	weapon_start();
};

void() weapon_multi_grenade = {
	item_setupmodel("progs/g_rock.mdl",2);
	self.weapon = IT_MULTI_GRENADE;
	self.classtype = CT_MULTI_GRENADE;
	if (self.netname == "") self.netname = "Multi-Grenade Launcher";
	item_ammo_set(AMMO_MULTI_ROCKETS_WPN);
	if (world.devdata & DEV_AMMO_N_HEALTH) world.deventity.ammo_multi_rockets = world.deventity.ammo_multi_rockets + self.aflag;
	weapon_start();
};

void() weapon_multi_rocket = {
	item_setupmodel("progs/g_rock2.mdl",1);
	self.weapon = IT_MULTI_ROCKET;
	self.classtype = CT_MULTI_ROCKET;
	if (self.netname == "") self.netname = "Multi-Rocket Launcher";
	item_ammo_set(AMMO_MULTI_ROCKETS_WPN);
	if (world.devdata & DEV_AMMO_N_HEALTH) world.deventity.ammo_multi_rockets = world.deventity.ammo_multi_rockets + self.aflag;
	weapon_start();
};

void() weapon_plasmalightning = {
	item_setupmodel("progs/g_light.mdl",1);
	self.weapon = IT_PLASMA_GUN;
	self.classtype = CT_PLASMAGUN;
	if (self.netname == "") self.netname = "Plasma Thunderbolt";
	item_ammo_set(AMMO_PLASMA_WPN);
	if (world.devdata & DEV_AMMO_N_HEALTH) world.deventity.ammo_plasma = world.deventity.ammo_plasma + self.aflag;
	weapon_start();
};

void() weapon_chain_lightning = {
	item_setupmodel("progs/drake/g_light2.mdl",0);
	self.weapon = IT2_CHAINLIGHTNING;
	self.classtype = CT_CHAINLIGHTGUN;
	if (self.netname == "") self.netname = "Chain Lightning Gun";
	item_ammo_set(AMMO_CELLS_WPN);
	if (world.devdata & DEV_AMMO_N_HEALTH) world.deventity.ammo_cells = world.deventity.ammo_cells + self.aflag;
	weapon_start();
};

void() weapon_chainlightning = { weapon_chain_lightning(); }; // [ENTITY], Redirect, Zerstorer's name

void() weapon_blaster = {
	item_setupmodel("progs/w_blaster.mdl",0);
	self.weapon = IT_BLASTER;
	self.classtype = CT_BLASTERWEP;
	if (self.netname == "") self.netname = "Laser Blaster";
	item_ammo_set(AMMO_SHELLS_WPN);
	if (world.devdata & DEV_AMMO_N_HEALTH) world.deventity.ammo_shells = world.deventity.ammo_shells + AMMO_SHELLS_WPN;
	weapon_start();
};

void() weapon_rapier = {
	item_setupmodel("progs/aoa/g_rapier.mdl",0);
	self.weapon = IT_RAPIER;
	self.classtype = CT_RAPIER;
	if (self.netname == "") self.netname = "Ghost Rapier (Loki's Laevateinn)"; // Lævateinn
	weapon_start();
};

void() weapon_mace = {
	item_setupmodel("progs/aoa/g_mace.mdl",0);
	self.weapon = IT_MACE;
	self.classtype = CT_MACE;
	if (self.netname == "") self.netname = "Blood Mace (Baldr's Maul)";
	item_ammo_set(AMMO_BLOOD_WPN);
	if (world.devdata & DEV_AMMO_N_HEALTH) world.deventity.ammo_bloodcrystals = world.deventity.ammo_bloodcrystals + self.aflag;
	weapon_start();
};

void() weapon_ice = {
	item_setupmodel("progs/redfield/g_lightstaff.mdl",0);
	self.weapon = IT_ICE;
	self.classtype = CT_ICE;
	if (self.netname == "") self.netname = "Blizzard Sphere (Ran's Staff)";
	item_ammo_set(AMMO_ELEMENTAL_WPN);
	if (world.devdata & DEV_AMMO_N_HEALTH) world.deventity.ammo_elemental = world.deventity.ammo_elemental + self.aflag;
	weapon_start();
};

void() weapon_scimitar = {
	item_setupmodel("progs/aoa/g_scimitar.mdl",0);
	self.weapon = IT_SCIMITAR;
	self.classtype = CT_SCIMITAR;
	if (self.netname == "") self.netname = "Fire Scimitar (Surtr's Sword)";
	item_ammo_set(AMMO_ELEMENTAL_WPN);
	if (world.devdata & DEV_AMMO_N_HEALTH) world.deventity.ammo_elemental = world.deventity.ammo_elemental + self.aflag;
	weapon_start();
};

void() weapon_voidstaff = {
	item_setupmodel("progs/aoa/g_voidstaff.mdl",0);
	self.weapon = IT_VOID_STAFF;
	self.classtype = CT_VOID_STAFF;
	if (self.netname == "") self.netname = "Void Staff (Gridr's Gridarvolr)"; // Gríðarvölr
	item_ammo_set(AMMO_VOID_WPN);
	if (world.devdata & DEV_AMMO_N_HEALTH) world.deventity.ammo_voidshards = world.deventity.ammo_voidshards + self.aflag;
	weapon_start();
};

void() weapon_gungnir = {
	item_setupmodel("progs/aoa/g_gungnir.mdl",0);
	self.weapon = IT_GUNGNIR;
	self.classtype = CT_GUNGNIR;
	if (self.netname == "") self.netname = "Gungnir (Odin's Spear)";
	item_ammo_set(AMMO_VOID_WPN);
	if (world.devdata & DEV_AMMO_N_HEALTH) world.deventity.ammo_voidshards = world.deventity.ammo_voidshards + self.aflag;
	weapon_start();
};

void() weapon_sanguinators = {
	item_setupmodel("progs/aoa/g_sanguinators.mdl",0);
	self.weapon = IT_SANGUINATORS;
	self.classtype = CT_SANGUINATORS;
	if (self.netname == "") self.netname = "Sanguinators (Hel's Claws)";
	item_ammo_set(AMMO_BLOOD_WPN);
	if (world.devdata & DEV_AMMO_N_HEALTH) world.deventity.ammo_bloodcrystals = world.deventity.ammo_bloodcrystals + self.aflag;
	weapon_start();
};

void() weapon_flak = {
	item_setupmodel("progs/aoa/g_flak.mdl",0);
	self.weapon = IT_FLAK;
	self.classtype = CT_FLAK;
	if (self.netname == "") self.netname = "Flak Cannon";
	item_ammo_set(AMMO_NAILS_WPN*2);
	if (world.devdata & DEV_AMMO_N_HEALTH) world.deventity.ammo_nails = world.deventity.ammo_nails + self.aflag;
	weapon_start();
};

// --> QUAKED weapon_stinger (0 .5 .8) (-16 -16 0) (16 16 32)
// --> QUAKED weapon_mirv (0 .5 .8) (-16 -16 0) (16 16 32)
void() weapon_stinger = { // [ENTITY], Redirect from MIRV.
	item_setupmodel("progs/drake/g_mirv.mdl",0);
	precache_sound("drake/weapons/mirv1.wav");
	self.weapon = IT_MIRV;
	self.classtype = CT_MIRV;
	if (self.netname == "") self.netname = "MIRV Launcher";
	if (self.aflag == 0) self.aflag = 30;
	else if (self.aflag < 0) self.aflag = 0;
	if (world.devdata & DEV_AMMO_N_HEALTH) world.deventity.ammo_rockets = world.deventity.ammo_rockets + self.aflag;
	weapon_start();
};
// PM:  Alternate name for the stinger rocket launcher.
void() weapon_mirv = { self.classname = "weapon_stinger";  weapon_stinger(); };

void() weapon_supershotgun_upright = { // [ENTITY], Redirect, from Lieutenant map, rare usage.
	self.classname = "weapon_supershotgun";
	self.mdl = "progs/lieutenant/up-shot.mdl";
	weapon_supershotgun();
};

void() weapon_nailgun_upright = { // [ENTITY], Redirect, from Lieutenant map, rare usage.
	self.classname = "weapon_nailgun";
	self.mdl = "progs/lieutenant/up-nail.mdl";
	weapon_nailgun();
};

void() weapon_airgun = { // [ENTITY]
	item_setupmodel("progs/qmaster/g_airgun.mdl",0);
	self.weapon = IT_AIRGUN;
	self.classtype = CT_AIRGUN;
	if (self.netname == "") self.netname = "Airfist";
	weapon_start(); // Does not use ammo.
};

void() weapon_sword = {}; // TODO: Make this for Qmaster's epic episode
void() weapon_gshotgun = {}; // TODO: finish adding zerstorer quadshotgun
void() weapon_sprocket = {}; // TODO: finish adding nehahra sprocket
void() weapon_stunner = {}; // TODO: finish adding zerstorer ScREw Gun (SRE) aka stunner?  Drake had redirected to the MIRV as both this and that are guided player detonatable rockets.

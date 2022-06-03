//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
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
// Entity count: 0
// Function count: 23
//
// Implements: The Player, Level Start, Level Change, Savegame Variables
//
// Description:
// All basic player thinking, movement, jump handling, level save/load, change
// level functions, and other player movement related utilities.
//=============================================================================

float IT_ITEMRESET = IT_KEY1 + IT_KEY2 + IT_INVISIBILITY + IT_INVULNERABILITY + IT_SUIT + IT_QUAD;
float IT_MODRESET = IT_CKEY1 + IT_CKEY2 + IT_CKEY3 + IT_CKEY4 + IT_ARTLAVASHIELD + IT_ARTWETSUIT + IT_ARTBLASTBELT + IT_ARTJUMPBOOTS + IT_ARTSHARP + IT_ARTPIERCE + IT_ARTTOME;
float IT2_ITEMRESET = IT2_SHIELD + IT2_SUPERHEALTH + IT2_EARTHQUAKE + IT2_V_SPHERE + HIP_IT2_WETSUIT + HIP_IT2_EMPATHY_SHIELDS + HIP_IT2_HORN_OF_CONJURING + IT2_TRINITY;
float ALL_WEAPONS = IT_SHOTGUN + IT_SUPER_SHOTGUN + IT_NAILGUN + IT_SUPER_NAILGUN + IT_GRENADE_LAUNCHER + IT_ROCKET_LAUNCHER + IT_LIGHTNING + IT_AXE + IT_LAVA_NAILGUN + IT_LAVA_SUPER_NAILGUN + IT_MULTI_GRENADE + IT_MULTI_ROCKET + IT_PLASMA_GUN + IT_EXTRA_WEAPON;
float ALL_WEAPONS2 = IT2_CHAINLIGHTNING + IT2_PROXIMITY_GUN + IT2_MJOLNIR + IT2_LASER_CANNON + IT2_GRAPPLE + IT2_CROSS;// IT2_CROSS is the wand!  Don't add twice adding IT2_WAND and make garbage.
float ALL_WEAPONSMODITEMS = IT_UPGRADE_SSG + IT_UPGRADE_LG + IT_SANGUINATORS + IT_SCIMITAR + IT_RAPIER + IT_UPGRADE_AXE;
float ALL_WEAPONSMODITEMS_HACKBANK = IT_ICE + IT_MACE + IT_VOID_STAFF + IT_FLAK + IT_GUNGNIR;
float ALL_WEAPONSPERMS = IT_BLASTER + IT_CHAINSAW;

void() SetupIntermissionCamera;
void() CycleIntermissionCamera;
void() ClientDeBuff;
void() ClientPowerups;
void(entity targ, float powtimer, float novania) ResetPowerSystem;
void() GrappleService;
void() CheckSecretCamera;
void(entity inflictor, entity attacker, float damage) player_pain;
void() player_death;
void() player_stand1;
void() trigger_changelevel_finish;
void() trigger_changelevel_finish;
void() trigger_cdtrack_change;
void(entity targ) trigger_skybox_change;
void(entity targ) set_teamsurvivor;
float(float cam_angle1, float cam_angle2) camera_check_anglezero;
float(float baxis_start, float baxis_control, float baxis_end, float baxis_time) bezier_axis;
vector(vector bez_start, vector bez_control, vector bez_end, float bez_timemax, float bez_timeleft) bezier_curve;
void() misc_camera_filewrite;
void () earthquake_postthink;
void (entity ownerEntity) sphere_remove;
void() PlayerBallistaThink;

// USED : Load (map command) NEW MAP or NEW GAME
// This is a function called via the engine for new games and resets all parm data back to default values, followed by Decode.
// Cannot use any self keys in this functions, its called by engine BEFORE any client setup or insertion into the map!
void() SetNewParms = {
	local float sethealth;
	dprint("\b[CLIENT]\b SetNewParms\n");
	update_configflag(SVR_SPAWN_BIT1, FALSE); // Brand new game/map, reset start position settings
	update_configflag(SVR_SPAWN_BIT2, FALSE);
	update_configflag(SVR_SPAWN_BIT3, FALSE);
	fog_active = FALSE;
	skyfog_active = FALSE;
	parm1 = IT_SHOTGUN | IT_AXE;	// Default self.items, give shotgun and axe to start
	sethealth = 100;
	if (Client_QueryEvilmode()) sethealth = HEAL_EVILMAX; // Check for Evil NM+ skill level (Lower HP max)
	parm2 = encode(sethealth, 0, 0);		// Default Health, Armortype, Armorvalue in that order
	parm3 = encode(25,0,0);			// Default shells, nails, rockets in that order
	parm4 = 0;						// Ammo qty cells, bolts, poison in that order
	parm5 = 0;						// Ammo qty lava_nails, multi_rockets, plasma in that order
	parm8 = 1;						// Current selected weapon
	parm10 = 0;						// New MOD items
	parm11 = 0;						// self.items2
	parm12 = 0;						//
	parm13 = 0;						// permanent powerups (perms) from Drake, can be reset this level using world.take_perms > 0
	if (query_configflag(SVR_UPDAXE)) parm10 = parm10 | IT_UPGRADE_AXE; // Update new player inventory based on config flag
	if (query_configflag(SVR_UPDSSG)) parm10 = parm10 | IT_UPGRADE_SSG;
	if (query_configflag(SVR_UPDLG)) parm10 = parm10 | IT_UPGRADE_LG;

	if (Client_QueryEvilmode()) { // Skill 4 always starts with Shadow Axe!
		parm1 = parm1 | IT_AXE;
		parm10 = parm10 | IT_UPGRADE_AXE;
		parm8 = IT_AXE; // Start with shadow axe in Evil Mode
	} else if (world.no_axestart == TRUE) { // If a map wants NO axe start, then its likely been designed for it!  World entity is readable at this point.
		parm1 = parm8 = parm11 = parm10 = 0; // The No Axe start is also NO WEAPONS at all (including any from previous map).
	}

	if (mapvar_cvar) dprint("\b[CLIENT]\b LIVE Map Variables Detected\n"); // Are map variables live?
	else {
		dprint("\b[CLIENT]\b RESETTING Map Variables\n");
		parm6 = parm7 = parm9 = parm14 = parm15 = parm16 = 0; // Reset map variables ready for use
		mapvar_reset();
	}
};

// Used by trigger_changelevel.  Stores a copy of the parm data ready for death/level reset.
void() SetChangeParms = {
	local entity pack;
	local float had_regen;

    if ((self.perms & POW_ARMORBERSERKER) || (self.perms & POW_REGEN)) had_regen = TRUE; // Drake Special exotic armor stuff
    else had_regen = FALSE;

    if (self.perms & POW_ARMORSPIRIT && (self.items2 & IT2_ARMOR1 || self.items2 & IT2_ARMOR2 || self.items2 & IT2_ARMOR3)) self.armorvalue = 100; // Reset Drake exotic spirit armor.
	dprint("\n\b[CLIENT]\b SetChangeParms\n");
	if (self.health < 1) { SetNewParms(); return; }

	self.items = self.items - (self.items & IT_ITEMRESET); // remove temporary items (keys and powerups)
	parm1 = self.items;

	self.moditems = self.moditems - (self.moditems & IT_MODRESET); // Special mod items handling and bitstuffing
	if (self.selfweaponismoditems) self.moditems = self.moditems | WEAPON_HACKBANK1; // remember hack for secondary set of 24 weapons!  For AoA and any further weapon additions!
	else {
		if (self.moditems & WEAPON_HACKBANK1) self.moditems = self.moditems -  WEAPON_HACKBANK1;
	}
	parm10 = self.moditems;

	dprint("\b[CLIENT]\b MOD weapons ("); dprint(ftos(parm10)); dprint(")\n");
	self.items2 = self.items2 - (self.items2 & IT2_ITEMRESET);
	parm11 = self.items2; // save the good stuff!  multi-weapons and such
	Client_CheckMaxHP(self, TRUE, had_regen); // Make sure player HP is within Max range and not less 50%
	parm2 = encode(self.health, self.armortype, self.armorvalue);
	parm3 = encode(self.ammo_shells,self.ammo_nails,self.ammo_rockets);
	parm4 = encode(self.ammo_cells,self.ammo_bolts,self.ammo_poison);
	parm5 = encode(self.ammo_lava_nails,self.ammo_multi_rockets,self.ammo_plasma);
	parm6 = mapvar[0];
	parm7 = mapvar[1];
	parm8 = self.weapon;
	parm9 = mapvar[2];
	//parm10 is self.moditems above
	//parm11 is self.items2 above
	parm12 = self.serverflagstemp; // remember runes? .....  no, what runes?
	parm13 = self.perms; // Store permanent powerups and Drake stuff
	parm14 = mapvar[3];
	parm15 = mapvar[4];
	parm16 = mapvar[5];
	cvar_set("gamecfg",ftos(encode(self.ammo_bloodcrystals,self.ammo_voidshards,self.ammo_elemental)));
	//parm17 = encode(self.ammo_bloodcrystals,self.ammo_voidshards,self.ammo_elemental);
	cvar_set("savedgamecfg",ftos(self.items3));

	dprint("Beyond 16 Parms Set:\n");
	dprint("gamecfg: "); dprint(ftos(cvar("gamecfg"))); dprint("\n");
	dprint("savedgamecfg: "); dprint(ftos(cvar("savedgamecfg"))); dprint("\n");
};

// Used during load new map such as trigger_changelevel.  Not used when loading a saved file or quickload
void() DecodeWorldParms = {
	local float parm_items, tlow8, tmid8, thi8;
	
	parm_items = parm1;
	dprint("\b[CLIENT]\b Decode Worldspawn Inv Parms:\n");

	// Take first, then give.  That way mappers can give clean slate + gives.
	if (world.take_weapons > 0 || world.no_axestart) {
		if (world.take_weapons >= 9999999) {
			parm_items = parm_items - (parm_items & ALL_WEAPONS); // Take all, clean slate.
			parm13 = parm13 - (parm13 & ALL_WEAPONSPERMS);
			parm10 = parm10 - (parm10 & ALL_WEAPONSMODITEMS) - (parm10 & ALL_WEAPONSMODITEMS_HACKBANK);
			parm8 = 0;
			parm11 = parm11 - (parm11 & ALL_WEAPONS2);
			dprint("ALL WEAPONS REMOVED");
			if (Client_QueryEvilmode()) {
				dprint(", Evil Mode detected: Shadowaxe given");
				parm1 = parm1 | IT_AXE;
				parm10 = parm10 | IT_UPGRADE_AXE;
				parm8 = IT_AXE;
			}

			if (world.give_weapons) dprint(", and new weapons given...\n");
			else dprint("!\n");
		} else {
			dprint("Specific World Weapon Take ( ");
			if (world.take_weapons & IT_SHOTGUN) dprint("SG ");
			if (world.take_weapons & IT_SUPER_SHOTGUN) dprint("SSG ");
			if (world.take_weapons & IT_NAILGUN) dprint("NG ");
			if (world.take_weapons & IT_SUPER_NAILGUN) dprint("SNG ");
			if (world.take_weapons & IT_GRENADE_LAUNCHER) dprint("GL ");
			if (world.take_weapons & IT_ROCKET_LAUNCHER) dprint("RL ");
			if (world.take_weapons & IT_LIGHTNING) dprint("LG ");
			dprint(")\n");
			if (world.take_weapons & IT_SHOTGUN && parm_items & IT_SHOTGUN) {
				parm_items = parm_items - IT_SHOTGUN;
				parm13 = parm13 - (parm13 & IT_BLASTER);
			}
			if (world.take_weapons & IT_SUPER_SHOTGUN && parm_items & IT_SUPER_SHOTGUN) {
				parm_items = parm_items - IT_SUPER_SHOTGUN;
				parm10 = parm10 - (parm10 & IT_UPGRADE_SSG); // Player cannot have upgrades without base item
			}
			if (world.take_weapons & IT_NAILGUN && parm_items & IT_NAILGUN) parm_items = parm_items - IT_NAILGUN; 
			if (world.take_weapons & IT_SUPER_NAILGUN && parm_items & IT_SUPER_NAILGUN) parm_items = parm_items - IT_SUPER_NAILGUN; 
			if (world.take_weapons & IT_GRENADE_LAUNCHER && parm_items & IT_GRENADE_LAUNCHER) parm_items = parm_items - IT_GRENADE_LAUNCHER; 
			if (world.take_weapons & IT_ROCKET_LAUNCHER && parm_items & IT_ROCKET_LAUNCHER) parm_items = parm_items - IT_ROCKET_LAUNCHER; 
			if (world.take_weapons & IT_LIGHTNING && parm_items & IT_LIGHTNING) {
				parm_items = parm_items - IT_LIGHTNING;
				parm10 = parm10 - (parm10 & IT_UPGRADE_LG); // Player cannot have upgrades without base item
			}
		}
	}

	// Take first, then give.  That way mappers can give clean slate + gives.
	if (world.give_weapons) {
		dprint("Specific World Weapon Give ( "); 
		if (world.give_weapons & IT_SHOTGUN) dprint("SG ");
		if (world.give_weapons & IT_SUPER_SHOTGUN) dprint("SSG ");
		if (world.give_weapons & IT_NAILGUN) dprint("NG ");
		if (world.give_weapons & IT_SUPER_NAILGUN) dprint("SNG ");
		if (world.give_weapons & IT_GRENADE_LAUNCHER) dprint("GL ");
		if (world.give_weapons & IT_ROCKET_LAUNCHER) dprint("RL ");
		if (world.give_weapons & IT_LIGHTNING) dprint("LG ");
		dprint(")\n");
		parm_items = parm_items | (world.give_weapons & ALL_WEAPONS); // Adding weapons to existing inventory so we don't overwrite shadowaxe if evil gave it.
	}
	parm1 = parm_items; // Store result back to global variable
	
	// parm2 health | armortype | armorvalue
	tlow8 = decode(parm2,LOW8);
	tmid8 = decode(parm2,MID8);
	thi8 = decode(parm2,HI8);

	// Update player health (reset or minimum value)
	if (world.reset_health > 0 && world.reset_health <= HEAL_PLAYMAX) {
		dprint("\b[CLIENT]\b Health ("); dprint(ftos(tlow8)); dprint(") To (");
		tlow8 = world.reset_health; //uses low8 position
		parm2 = encode(tlow8,tmid8,thi8);
		dprint(ftos(tlow8)); dprint(")\n");	
	} else if (world.max_health && (tlow8 < world.max_health) ) {
		dprint("\b[CLIENT]\b Health ("); dprint(ftos(tlow8)); dprint(") To (");
		if (tlow8 < world.max_health) {
			tlow8 = world.max_health; //uses low8 position
			parm2 = encode(tlow8,tmid8,thi8);
		}
		dprint(ftos(tlow8)); dprint(")\n");	
	}
	
	// Update the inventory ammo quantities
	// currentammo = 1 to reset the inventory to worldspawn values
	// currentammo = 0 to use the worldspawn values as a minimum quantity

	// parm3 = shells | nails | rockets
	tlow8 = decode(parm3,LOW8);
	tmid8 = decode(parm3,MID8);
	thi8 = decode(parm3,HI8);
	if (world.ammo_shells || (world.currentammo && tlow8 > 0)) {
		dprint("\b[CLIENT]\b Ammo Shells ("); dprint(ftos(tlow8)); dprint(") To (");
		if (world.currentammo) tlow8 = world.ammo_shells;
		else if (tlow8 < world.ammo_shells) tlow8 = world.ammo_shells;
		if (world.maxshells > 0) {
			if (tlow8 > world.maxshells) tlow8 = world.maxshells;
		} else {
			if (tlow8 > AMMO_MAXSHELLS) tlow8 = AMMO_MAXSHELLS;
		}
		if (tlow8 < 0) tlow8 = 0;
		dprint(ftos(tlow8)); dprint(")\n");
		parm3 = encode(tlow8,tmid8,thi8); //store shells back in parm3
	}
	if (world.ammo_nails || (world.currentammo && tmid8 > 0)) {
		dprint("\b[CLIENT]\b Ammo Spikes ("); dprint(ftos(tmid8)); dprint(") To (");
		if (world.currentammo) tmid8 = world.ammo_nails;
		else if (tmid8 < world.ammo_nails) tmid8 = world.ammo_nails;
		if (world.maxnails > 0) {
			if (tmid8 > world.maxnails) tmid8 = world.maxnails;
		} else {
			if (tmid8 > AMMO_MAXNAILS) tmid8 = AMMO_MAXNAILS;
		}
		if (tmid8 < 0) tmid8 = 0;
		dprint(ftos(tmid8)); dprint(")\n");
		parm3 = encode(tlow8,tmid8,thi8); //store nails back in parm3
	}
	if (world.ammo_rockets || (world.currentammo && thi8 > 0)) {
		dprint("\b[CLIENT]\b Ammo Rockets ("); dprint(ftos(thi8)); dprint(") To (");
		if (world.currentammo) thi8 = world.ammo_rockets;
		else if (thi8 < world.ammo_rockets) thi8 = world.ammo_rockets;
		if (world.maxrockets > 0) {
			if (thi8 > world.maxrockets) thi8 = world.maxrockets;
		} else {
			if (thi8 > AMMO_MAXROCKETS) thi8 = AMMO_MAXROCKETS;
		}
		if (thi8 < 0) thi8 = 0;
		dprint(ftos(thi8)); dprint(")\n");
		parm3 = encode(tlow8,tmid8,thi8); //store rockets back in parm3
	}

	// parm4 = cells | bolts | poison
	tlow8 = decode(parm4,LOW8);
	tmid8 = decode(parm4,MID8);
	thi8 = decode(parm4,HI8);
	if (world.ammo_cells || (world.currentammo && tlow8 > 0)) {
		dprint("\b[CLIENT]\b Ammo Cells ("); dprint(ftos(tlow8)); dprint(") To (");
		if (world.currentammo) tlow8 = world.ammo_cells;
		else if (tlow8 < world.ammo_cells) tlow8 = world.ammo_cells;
		if (world.maxcells > 0) {
			if (tlow8 > world.maxcells) tlow8 = world.maxcells;
		} else {
			if (tlow8 > AMMO_MAXCELLS) tlow8 = AMMO_MAXCELLS;
		}
		if (tlow8 < 0) tlow8 = 0;
		dprint(ftos(tlow8)); dprint(")\n");	
		parm4 = encode(tlow8,tmid8,thi8); //store cells back in parm4
	}
	if (world.ammo_bolts) {
		dprint("\b[CLIENT]\b Ammo Bolts ("); dprint(ftos(tmid8)); dprint(") To (");
		if (world.currentammo) tmid8 = world.ammo_bolts;
		else if (tmid8 < world.ammo_bolts) tmid8 = world.ammo_bolts;
		if (world.maxbolts > 0) {
			if (tmid8 > world.maxbolts) tmid8 = world.maxbolts;
		} else {
			if (tmid8 > AMMO_MAXBOLTS) tmid8 = AMMO_MAXBOLTS;
		}
		if (tmid8 < 0) tmid8 = 0;
		dprint(ftos(tmid8)); dprint(")\n");
		parm4 = encode(tlow8,tmid8,thi8); //store bolts back in parm4
	}
	if (world.ammo_poison) {
		dprint("\b[CLIENT]\b Ammo Poison ("); dprint(ftos(thi8)); dprint(") To (");
		if (world.currentammo) thi8 = world.ammo_poison;
		else if (thi8 < world.ammo_poison) thi8 = world.ammo_poison;
		if (world.maxpoison > 0) {
			if (thi8 > world.maxpoison) thi8 = world.maxpoison;
		} else {
			if (thi8 > AMMO_MAXPOISON) thi8 = AMMO_MAXPOISON;
		}
		if (thi8 < 0) thi8 = 0;
		dprint(ftos(thi8)); dprint(")\n");
		parm4 = encode(tlow8,tmid8,thi8); //store poison back in parm4
	}

	// parm5 = lava_nails | multi_rockets | plasma
	tlow8 = decode(parm5,LOW8);
	tmid8 = decode(parm5,MID8);
	thi8 = decode(parm5,HI8);
	if (world.ammo_lava_nails || (world.currentammo && tlow8 > 0)) {
		dprint("\b[CLIENT]\b Ammo Lava Nails ("); dprint(ftos(tlow8)); dprint(") To (");
		if (world.currentammo) tlow8 = world.ammo_lava_nails;
		else if (tlow8 < world.ammo_lava_nails) tlow8 = world.ammo_lava_nails;
		if (world.maxlavanails > 0) {
			if (tlow8 > world.maxlavanails) tlow8 = world.maxlavanails;
		} else {
			if (tlow8 > AMMO_MAXLAVANAILS) tlow8 = AMMO_MAXLAVANAILS;
		}
		if (tlow8 < 0) tlow8 = 0;
		dprint(ftos(tlow8)); dprint(")\n");	
		parm5 = encode(tlow8,tmid8,thi8); //store lava_nails back in parm5
	}
	if (world.ammo_multi_rockets || (world.currentammo && tmid8 > 0)) {
		dprint("\b[CLIENT]\b Ammo Multi-Rockets ("); dprint(ftos(tmid8)); dprint(") To (");
		if (world.currentammo) tmid8 = world.ammo_multi_rockets;
		else if (tmid8 < world.ammo_multi_rockets) tmid8 = world.ammo_multi_rockets;
		if (world.maxmultirockets > 0) {
			if (tmid8 > world.maxmultirockets) tmid8 = world.maxmultirockets;
		} else {
			if (tmid8 > AMMO_MAXMULTIROCKETS) tmid8 = AMMO_MAXMULTIROCKETS;
		}
		if (tmid8 < 0) tmid8 = 0;
		dprint(ftos(tmid8)); dprint(")\n");
		parm5 = encode(tlow8,tmid8,thi8); //store multi_rockets back in parm5
	}
	if (world.ammo_plasma || (world.currentammo && thi8 > 0)) {
		dprint("\b[CLIENT]\b Ammo Plasma ("); dprint(ftos(thi8)); dprint(") To (");
		if (world.currentammo) thi8 = world.ammo_plasma;
		else if (thi8 < world.ammo_plasma) thi8 = world.ammo_plasma;
		if (world.maxplasma > 0) {
			if (thi8 > world.maxplasma) thi8 = world.maxplasma;
		} else {
			if (thi8 > AMMO_MAXPLASMA) thi8 = AMMO_MAXPLASMA;
		}
		if (thi8 < 0) thi8 = 0;
		dprint(ftos(thi8)); dprint(")\n");
		parm5 = encode(tlow8,tmid8,thi8); //store plasma back in parm5
	}

	tlow8 = decode(cvar("gamecfg"),LOW8);//cvar("parm17_hack"); //decode(parm17,LOW8);
	tmid8 = decode(cvar("gamecfg"),MID8);//cvar("parm18_hack");//decode(parm17,MID8);
	thi8 =  decode(cvar("gamecfg"),HI8);//cvar("parm19_hack"); //decode(parm17,HI8);
	if (world.ammo_bloodcrystals || (world.currentammo && tlow8 > 0)) {
		dprint("\b[CLIENT]\b Ammo Blood Crystals ("); dprint(ftos(tlow8)); dprint(") To (");
		if (world.currentammo) tlow8 = world.ammo_bloodcrystals;
		else if (tlow8 < world.ammo_bloodcrystals) tlow8 = world.ammo_bloodcrystals;
		if (world.maxblood > 0) {
			if (tlow8 > world.maxblood) tlow8 = world.maxblood;
		} else {
			if (tlow8 > AMMO_MAXBLOOD) tlow8 = AMMO_MAXBLOOD;
		}
		if (tlow8 < 0) tlow8 = 0;
		dprint(ftos(tlow8)); dprint(")\n");	
		cvar_set("gamecfg",ftos(encode(tlow8,tmid8,thi8)));
		//parm17 = encode(tlow8,tmid8,thi8); //store bloodcrystals back in parm17
	}
	if (world.ammo_voidshards || (world.currentammo && tmid8 > 0)) {
		dprint("\b[CLIENT]\b Ammo Void Shards ("); dprint(ftos(tmid8)); dprint(") To (");
		if (world.currentammo) tmid8 = world.ammo_voidshards;
		else if (tmid8 < world.ammo_voidshards) tmid8 = world.ammo_voidshards;
		if (world.maxvoid > 0) {
			if (tmid8 > world.maxvoid) tmid8 = world.maxvoid;
		} else {
			if (tmid8 > AMMO_MAXVOID) tmid8 = AMMO_MAXVOID;
		}
		if (tmid8 < 0) tmid8 = 0;
		dprint(ftos(tmid8)); dprint(")\n");
		cvar_set("gamecfg",ftos(encode(tlow8,tmid8,thi8)));
		//parm17 = encode(tlow8,tmid8,thi8); //store voidshards back in parm17
	}
	if (world.ammo_elemental || (world.currentammo && thi8 > 0)) {
		dprint("\b[CLIENT]\b Ammo Plasma ("); dprint(ftos(thi8)); dprint(") To (");
		if (world.currentammo) thi8 = world.ammo_elemental;
		else if (thi8 < world.ammo_elemental) thi8 = world.ammo_elemental;
		if (world.maxmana > 0) {
			if (thi8 > world.maxmana) thi8 = world.maxmana;
		} else {
			if (thi8 > AMMO_MAXMANA) thi8 = AMMO_MAXMANA;
		}
		if (thi8 < 0) thi8 = 0;
		dprint(ftos(thi8)); dprint(")\n");
		cvar_set("gamecfg",ftos(encode(tlow8,tmid8,thi8)));
		//parm17 = encode(tlow8,tmid8,thi8); //store elemental_mana back in parm17
	}

	// Update player armour type and quantity
	if (world.armortype > 0) {
		// Remove any previous armour types from the HUD
		parm11 = parm11 - (parm11 & (IT2_ARMOR1 | IT2_ARMOR2 | IT2_ARMOR3));
		// Setup any armour quantity first, limit check with armour type
		if (world.armorvalue > 0) {
			tlow8 = decode(parm2,LOW8); // health
			tmid8 = decode(parm2,MID8); // armortype
			parm2 = encode(tlow8,tmid8,world.armorvalue);
		}

		// Work through the different armour types, resetting armour quantity
		if (world.armortype == 1) {
			parm11 = parm11 | IT2_ARMOR1;
			tlow8 = decode(parm2,LOW8);
			tmid8 = decode(parm2,MID8);
			thi8 = ARMOR_GRN_TYPE * 100;  //parm9 = ARMOR_GRN_TYPE * 100;
			if (!world.armorvalue || thi8 > ARMOR_GRN_VALUE) thi8 = ARMOR_GRN_VALUE;
			dprint("\b[CLIENT]\b Green Armor ("); dprint(ftos(thi8)); dprint(")\n");
			parm2 = encode(tlow8,tmid8,thi8);

		} else if (world.armortype == 2) {
			parm11 = parm11 | IT2_ARMOR2;	
			tlow8 = decode(parm2,LOW8);
			tmid8 = decode(parm2,MID8);
			thi8 = ARMOR_YEL_TYPE * 100;  //parm9 = ARMOR_YEL_TYPE * 100;
			if (!world.armorvalue || thi8 > ARMOR_YEL_VALUE) thi8 = ARMOR_YEL_VALUE;
			dprint("\b[CLIENT]\b Yellow Armor ("); dprint(ftos(thi8)); dprint(")\n");
			parm2 = encode(tlow8,tmid8,thi8);

		} else if (world.armortype == 3) {
			parm11 = parm11 | IT2_ARMOR3;	
			tlow8 = decode(parm2,LOW8);
			tmid8 = decode(parm2,MID8);
			thi8 = ARMOR_RED_TYPE * 100;  //parm9 = ARMOR_RED_TYPE * 100;
			if (!world.armorvalue || thi8 > ARMOR_RED_VALUE) thi8 = ARMOR_RED_VALUE;
			dprint("\b[CLIENT]\b Red Armor ("); dprint(ftos(thi8)); dprint(")\n");
			parm2 = encode(tlow8,tmid8,thi8);

		} else {
			// Default is no armour
			tlow8 = decode(parm2,LOW8);
			//parm3 = 0;
			thi8 = decode(parm2,HI8);
			parm2 = encode(tlow8,0,thi8);
		}
	}

	if (world.take_perms > 0) { dprint("All permanent powerups removed by world!\n"); parm13 = 0; } // take away all permanent powerups
};

// USED : Load NEW MAP or trigger CHANGE LEVEL
// Double check the player inventory matches the server/config flags
// Check worldspawn for add/removal of upgrade items
void() SyncModInventory = {
	// Shadow Axe.  Check worldspawn for upgrade_axe first, add/deny inventory
	if (world.upgrade_axe < 0) {
		dprint("\b[MODINV]\b Worldspawn removing Axe Upgrade\n");
		parm10 = parm10 - (parm10 & IT_UPGRADE_AXE);
		update_configflag(SVR_UPDAXE, FALSE);
	} else if (world.upgrade_axe > 0) {
		dprint("\b[MODINV]\b Worldspawn adding Axe Upgrade\n");
		parm10 = parm10 | IT_UPGRADE_AXE;
		parm1 = parm1 | IT_AXE;
		update_configflag(SVR_UPDAXE, TRUE);
	} else if (parm10 & IT_UPGRADE_AXE) {
		// Finally syncing the player inventory to serverflags
		dprint("\b[MODINV]\b Inventory adding Axe Upgrade\n");
		update_configflag(SVR_UPDAXE, TRUE);
	}
	
	// Widowmaker Shotgun.  Check worldspawn for upgrade_ssg first, add/deny inventory
	if (world.upgrade_ssg < 0) {
		dprint("\b[MODINV]\b Worldspawn removing SSG Upgrade\n");
		parm10 = parm10 - (parm10 & IT_UPGRADE_SSG);
		update_configflag(SVR_UPDSSG, FALSE);
	}
	else if (world.upgrade_ssg > 0) {
		dprint("\b[MODINV]\b Worldspawn adding SSG Upgrade\n");
		parm10 = parm10 | IT_UPGRADE_SSG;
		parm1 = parm1 | IT_SUPER_SHOTGUN;
		update_configflag(SVR_UPDSSG, TRUE);
	} else if (parm10 & IT_UPGRADE_SSG) {
		// Syncing the player inventory to serverflags
		dprint("\b[MODINV]\b Inventory adding SSG Upgrade\n");
		update_configflag(SVR_UPDSSG, TRUE);
	}

	// Projectile Shotgun.  Check for worldspawn feature to turn off projectiles + casing
	if (world.no_sgprojectile > 0) 
		update_configflag(SVR_SHOTGPROJ, TRUE);
	if (world.no_sgcasing > 0)
		update_configflag(SVR_SHOTGCASE, TRUE);

	// AD Plasma Gun.  Check worldspawn for upgrade_lg first, add/deny inventory
	if (world.upgrade_lg < 0) {
		dprint("\b[MODINV]\b Worldspawn removing LG Upgrade\n");
		parm10 = parm10 - (parm10 & IT_UPGRADE_LG);
		update_configflag(SVR_UPDLG, FALSE);
	} else if (world.upgrade_lg > 0) {
		dprint("\b[MODINV]\b Worldspawn adding LG Upgrade\n");
		parm10 = parm10 | IT_UPGRADE_LG;
		parm1 = parm1 | IT_LIGHTNING;
		update_configflag(SVR_UPDLG, TRUE);
	} else if (parm10 & IT_UPGRADE_LG) {
		// Finally syncing the player inventory to serverflags
		dprint("\b[MODINV]\b Inventory adding LG Upgrade\n");
		update_configflag(SVR_UPDLG, TRUE);
	}
};

// USED : Load NEW MAP or trigger CHANGE LEVEL.  Not used when loading a saved file or quickload
void() DecodeLevelParms = {
	local float had_regen;

	dprint("\b[CLIENT]\b Decode (Level) Parms\n");
	mapvar_cvar = TRUE; // Map Variables are active (do not reset)
	if (serverflags & SVR_RUNE_ALL) {
		if (world.model == "maps/start.bsp") SetNewParms (); // If we have all 4, take away all runes when returning to info_player_start2 in start map
	}

	Client_SyncPrevEvilmode(); // Most Quake Engines resets the skill level to 0-3 only.  Make sure skill level/console variable are updated on load
	DecodeWorldParms(); // Decode worldspawn client inv updates
	sync_serverflags();	// update/sync serverflags to worldspawn
	SyncModInventory();	// update/sync mod inventory items
	self.items = parm1; // Read all current params into client variables
	self.health = decode(parm2,LOW8);
	self.armortype = decode(parm2,MID8);
	self.armorvalue = decode(parm2,HI8);
	self.ammo_shells = decode(parm3,LOW8);
	self.ammo_nails = decode(parm3,MID8);
	self.ammo_rockets = decode(parm3,HI8);
	self.ammo_cells = decode(parm4,LOW8);
	self.ammo_bolts = decode(parm4,MID8);
	self.ammo_poison = decode(parm4,HI8);
	self.ammo_lava_nails = decode(parm5,LOW8);
	self.ammo_multi_rockets = decode(parm5,MID8);
	self.ammo_plasma = decode(parm5,HI8);

	dprint("Beyond 16 Parms: gamecfg was "); dprint(ftos(cvar("gamecfg"))); dprint("\n");
	self.ammo_bloodcrystals = decode(cvar("gamecfg"),LOW8);// cvar("parm17_hack"); //decode(parm17,LOW8);
	dprint("Beyond 16 Parms: set player ammo_bloodcrystals to: "); dprint(ftos(self.ammo_bloodcrystals)); dprint("\n");
	self.ammo_voidshards = decode(cvar("gamecfg"),MID8);// cvar("parm18_hack");//decode(parm17,MID8);
	dprint("Beyond 16 Parms: set player ammo_voidshards to: "); dprint(ftos(self.ammo_voidshards)); dprint("\n");
	self.ammo_elemental = decode(cvar("gamecfg"),HI8);// cvar("parm19_hack");//decode(parm17,HI8);
	dprint("Beyond 16 Parms: set player ammo_elemental to: "); dprint(ftos(self.ammo_elemental)); dprint("\n");
	self.weapon = parm8;
	self.moditems = parm10;
	self.items2 = parm11;
	self.serverflagstemp = parm12;
	self.perms = parm13;

	// ----------Drake Special exotic armor stuff----------------------------------------------
    if ((self.perms & POW_ARMORBERSERKER) || (self.perms & POW_REGEN))	had_regen = TRUE;
    else																had_regen = FALSE;

	Client_CheckMaxHP(self, FALSE, had_regen); // Always make sure the HP read from parm is within range!  Parm is re-used when map restart command is issued
	Client_CheckEvilInv(self); // The AD inventory is reset with parm10 (could lose Shadow axe).  Check for evil skill and add shadow axe + make current weapon!
	dprint("\b[CLIENT]\b self.weapon == ");
	dprint(ftos(self.weapon));
	dprint("\n");
	dprint("\b[CLIENT]\b self.items == ");
	dprint(ftos(self.items));
	dprint("\n");
	dprint("\b[CLIENT]\b Reading Map Variables\n");
	mapvar[0] = parm6; // Read/Setup map variables (22 bits per parm * 6 = 132 total)
	mapvar[1] = parm7;
	mapvar[2] = parm9;
	mapvar[3] = parm14;
	mapvar[4] = parm15;
	mapvar[5] = parm16;
	if (CheckZeroVector(world.mapvar_update) == FALSE) mapvar_range(world.mapvar_update); // Check for any worldspawn map variable settings
	dprint("Beyond 16 Parms: gamecfg was "); dprint(ftos(cvar("savedgamecfg"))); dprint("\n");
	self.items3 = cvar("savedgamecfg");
	cvar_set("gamecfg","0"); // Reset these to keep player config.cfg clean
	cvar_set("savedgamecfg","0");
};

void() GotoNextMap = {
	if (cvar("samelevel")) changelevel (mapname); // if samelevel is set, stay on same level
	else changelevel (nextmap);
};

// A special function designed for MP only, will cycle around.  The first map of each episode until someone quits.  Gives the player runes as well to tell which to load.
void() NextLevel = {
	local entity o;

	if (mapname == "start") {
		if (!cvar("registered")) mapname = "e1m1";
		else if (query_configflag(SVR_RUNE_KEY1) == FALSE) {
			mapname = "e1m1";
			update_configflag(SVR_RUNE_KEY1, TRUE);
		} else if (query_configflag(SVR_RUNE_KEY2) == FALSE) {
			mapname = "e2m1";
			update_configflag(SVR_RUNE_KEY1, TRUE);
		} else if (query_configflag(SVR_RUNE_KEY3) == FALSE) {
			mapname = "e3m1";
			update_configflag(SVR_RUNE_KEY1, TRUE);
		} else if (query_configflag(SVR_RUNE_KEY4) == FALSE) {
			mapname = "e4m1";
			update_configflag(SVR_RUNE_KEY1, FALSE);
			update_configflag(SVR_RUNE_KEY2, FALSE);
			update_configflag(SVR_RUNE_KEY3, FALSE);
		}
		o = spawn();
		o.map = mapname;
	} else {
		o = find(world, classname, "trigger_changelevel"); // find a trigger changelevel		
		if (!o) { // go back to start if no trigger_changelevel
			mapname = "start";
			o = spawn();
			o.map = mapname;
		}
	}
	nextmap = o.map;
	gameover = TRUE;
	
	if (o.nextthink < time) {
		o.think = trigger_changelevel_finish;
		o.nextthink = time + 0.1;
	}
};

// Check death timers (time/frag limits) and decide if to load a new map or not
void() CheckRules = {
	local float timelimit, fraglimit;

	if (deathmatch == 0) return;	// Playing SP?
	if (gameover) return;			// someone else quit the game already
		
	timelimit = cvar("timelimit") * 60;
	fraglimit = cvar("fraglimit");
	if (timelimit && time >= timelimit) NextLevel();
	else if (fraglimit && self.frags >= fraglimit) NextLevel();
};

void() SetupSpawnCoopLocations = {
	local entity cooploc, prevloc;
	
	if (coop > 2) set_teamsurvivor(self);
		
	// The first spawn for coop is always the SP start location
	cooploc = find (world, classname, "info_player_coop");
	prevloc = world;
	
	// Any coop spawns exist?
	if (cooploc) {
		// Create a list
		while(cooploc) {
			// first spawn in chain? setup first and previous spawns
			if (!prevloc) { 
				coop_ent = cooploc; 
				coop_ent.count = 0;
			} else prevloc.owner = cooploc;

			prevloc = cooploc; // Save current spawn location to previous ready for loop
			coop_ent.count = coop_ent.count + 1;	
			cooploc = find(cooploc, classname, "info_player_coop");
		}
		// Close the chain
		prevloc.owner = coop_ent;
		dprint("\b[COOP]\b Spawn locations found (");
		dprint(ftos(coop_ent.count)); dprint(")\n");
	} else {
		// No coop spawns, use start location
		dprint("\b[COOP]\b Spawn locations Missing!\n");
		coop_ent = find (world, classname, "info_player_start");
		
		// no start location, WUT!?!
		if (!coop_ent) coop_ent = client_ent;
		coop_ent.owner = coop_ent;
	}
};

// Find a location for the player to spawn at
entity() SelectSpawnPoint = {
	local entity spot, spot2, thing;
	local float  pcount, start2;
	
	// Always use a player start as default position
	if (!lastspawn) lastspawn = find (world, classname, "info_player_start");

	// Test this first because its such a restrictive set of condition
	if (developer > 0 && coop == 0 && deathmatch == 0) {
		spot = find( world, classname, "info_player_startdev");
		if (spot) {
			dprint ("\b[CLIENT_SPAWN]\b Developer only start!\n");
			return spot;
		}
	}

	// Cycle through list of info_player_coop location
	if (coop > 0) {
		// Check for coop spawn list
		if (!coop_ent) return lastspawn;
		// If first entry of coop list start player then its broken
		else if (coop_ent.classtype == CT_SPAWNSP) return lastspawn;
		else {
			// Setup coop list if last location isstart player
			if (lastspawn.classtype == CT_SPAWNSP) lastspawn = coop_ent;
			// Move forward in coop spawn location list
			lastspawn = lastspawn.owner;
			// Check if spawn location is active?
			if (lastspawn.estate & ESTATE_BLOCK) {
				pcount = coop_ent.count;
				while(pcount > 0) {
					lastspawn = lastspawn.owner;
					if (lastspawn.estate == ESTATE_ON) pcount = -1;
					else pcount = pcount - 1;
				}
			}
			// Double check if spawn location free?
			if (lastspawn.estate & ESTATE_BLOCK) {
				// Default back to player start if not available
				lastspawn = find (world, classname, "info_player_start");
			}
			return lastspawn;
		}
	}
	// choose a info_player_deathmatch point
	else if (deathmatch > 0) {
		spot = lastspawn;
		while (1) {
			spot = find(spot, classname, "info_player_deathmatch");
			if (spot == world) spot = find (world, classname, "info_player_start");
			if (spot != world) {
				if (spot == lastspawn) return lastspawn;
				pcount = 0;
				thing = findradius(spot.origin, 32);
				while(thing) {
					if (thing.flags & FL_CLIENT) pcount = pcount + 1;
					thing = thing.chain;
				}
				if (pcount == 0) {
					lastspawn = spot;
					return spot;
				}
			}
		}
	}

	// Check for any info_player_start2 special spawn locations
	start2 = mathlib_bitvalue( query_configflag(SVR_SPAWN_BIT1), SVR_SPAWN_BIT1);
	start2 = start2 + mathlib_bitvalue( query_configflag(SVR_SPAWN_BIT2), SVR_SPAWN_BIT2)*2;
	start2 = start2 + mathlib_bitvalue( query_configflag(SVR_SPAWN_BIT3), SVR_SPAWN_BIT3)*4;
	if (start2 > 0) dprint("\b[CLIENT]\b Unique Info_Player_Start2 Active\n");
	
	// have a rune or new spawnflag option? Pick second spawn position
	if ( query_configflag(SVR_RUNE_ALL) || start2 > 0 ) {
		// Read any spawn location number (High/low bit flag, 0-3 values)
		spot = find (world, classname, "info_player_start2");
		if (spot) {
			spot2 = spot;
			while (spot) {
				if (spot.startspawn2 == start2) spot2 = spot;
				spot = find(spot, classname, "info_player_start2");
			}
			return spot2;
		}
	}
	
	// Last chance to find a spawn location before giving up!
	spot = find (world, classname, "info_player_start");
	if (!spot) dprint ("\b[CLIENT_SPAWN]\b missing info_player_start!\n");
	
	return spot;
};

float CMD_RESEND_ON_LOAD = 16;

void () RunCommandSpawn = {
	local entity cmd;
	cmd = find(cmd, classname, "info_command_spawn");
	if (cmd != world && cmd.spawnflags & CMD_RESEND_ON_LOAD) cmd.use();
};


// PutClientInServer - called each time a player is spawned
void() PutClientInServer = {
	local entity spot, pack;

	dprint("\b[CLIENT]\b PutClientInServer\n");
	client_ent = self;
	self.classname = "player";
	self.flags = FL_CLIENT;
	self.estate = ESTATE_ON;
	self.estate_off = SUB_Null;
	intermission_running = cinematic_running = cutscene = 0; // Reset intermission/cinematic stuff
	self.in_a_vehicle = FALSE; // Always start off not in a vehicle. Can force it later if wanted.
	localcmd("chase_active 0\n"); // Default to first person. No sense beating around the bush.
	
	if (Client_QueryEvilmode()) Client_SetupEvilmode(); // Check for Evil NM+ skill level (Lower HP max)
	else Client_ResetEvilmode(-1); // Update health/mega max and leave weapons alone

	// Setup entity chains for coop, dm and intermission
	SetupSpawnCoopLocations();
	SetupIntermissionCamera();
	spot = SelectSpawnPoint(); // Find a spawn location in the map
	if (spot.target) self.target2 = spot.target; // Fire targets on spawn location
	else self.target2 = "";
	
	if (spot.cameratarget) self.cameratarget = spot.cameratarget; // Copy over any cinematic camera start sequences
	self.headmdl = MODEL_PLAYER_HEAD;
	self.takedamage = DAMAGE_AIM;
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_WALK;
	self.classmove = MON_MOVEWALK;
	self.show_hostile = 0;
	self.gibhealth = -40;
	self.gibbed = FALSE;
	self.regen_time = FALSE;
	self.air_finished = time + WATER_AIR;
	self.dmg = WATER_DAMAGE;
	self.effects = 0;
	self.steplast = 1;
	self.jump_flag = 0;
	self.oldgravity = 0;				// Reset gravity effects

	// Drake variables
    self.mist = world;
    self.hook = world; // for grapple service
    self.mirv1 = world;
	
	self.super_damage_finished = self.super_time = 0;
	self.radsuit_finished = self.rad_time = 0;
	self.invisible_finished = self.invisible_time = 0;
	self.notrace = 0;	// fix for dying with the ring
	self.invincible_finished = self.invincible_time = 0;
	self.sharpshoot_finished = self.sharpshoot_time = 0;
	self.nailpiercer_finished = self.nailpiercer_time = 0;
	self.wetsuit_finished = self.wetsuit_time = 0;
	self.empathy_finished = self.empathy_time = 0;
	self.antigrav_finished = self.antigrav_time = 0;
	self.shield_finished = self.shield_time = 0;
	self.cross_finished = self.cross_time = 0;
	self.trinity_finished = self.trinity_time = 0;
	self.wing_finished = self.wing_time = 0;
	self.aura_finished = 0;
	self.water_blessed = 0;
	self.alignment = GOOD;
	self.tethered = FALSE;
	self.tetherfocus = world;

	// Check if Arcane Key Inventory message is blocked/suppressed
	if (world.ckeyhint == TRUE) self.ckeyhint = TRUE;

	self.steptype = FS_TYPEMEDIUM;		// Standard boots
	self.suppressCenterPrint = FALSE;	// No centerprint active
	ResetPowerSystem(self,0,FALSE);		// Remove powerup effects (not vania)
	ResetDebuffSystem(self);			// Reset/initialize debuff system
	self.enemy = world;
	DecodeLevelParms();

	// Evil Mode should always start with the Axe!
	if (Client_QueryEvilmode()) self.weapon = IT_AXE;
	else self.weapon = W_BestWeapon (self);	// Pick best weapon from inventory
	W_SetCurrentAmmo (self);			// Update hud icons and v_model
	self.attack_finished = time;
	self.th_pain = player_pain;
	self.th_die = player_death;
	self.deadflag = DEAD_NO;			// The player is alive!
	self.pausetime = 0;					// make sure player has 0 velocity when spawning
	update_hud_totals(HUD_MONSTERS);	// Make screen total is correct
	update_hud_totals(HUD_SECRETS);		// Update monsters and secrets

	// Reset randomizer counters
	self.randomshells = self.randomcells = 0;

	if (world.maxshells > 0) self.maxshells = world.maxshells;
	else self.maxshells = AMMO_MAXSHELLS;
	if (world.maxnails > 0) self.maxnails = world.maxnails;
	else self.maxnails = AMMO_MAXNAILS;
	if (world.maxrockets > 0) self.maxrockets = world.maxrockets;
	else self.maxrockets = AMMO_MAXROCKETS;
	if (world.maxcells > 0) self.maxcells = world.maxcells;
	else self.maxcells = AMMO_MAXCELLS;
	if (world.maxlavanails > 0) self.maxlavanails = world.maxlavanails;
	else self.maxlavanails = AMMO_MAXLAVANAILS;
	if (world.maxmultirockets > 0) self.maxmultirockets = world.maxmultirockets;
	else self.maxmultirockets = AMMO_MAXMULTIROCKETS;
	if (world.maxplasma > 0) self.maxplasma = world.maxplasma;
	else self.maxplasma = AMMO_MAXPLASMA;
	if (world.maxpoison > 0) self.maxpoison = world.maxpoison;
	else self.maxpoison = AMMO_MAXPOISON;
	if (world.maxbolts > 0) self.maxbolts = world.maxbolts;
	else self.maxbolts = AMMO_MAXBOLTS;
	if (world.maxblood > 0) self.maxblood = world.maxblood;
	else self.maxblood = AMMO_MAXBLOOD;
	if (world.maxvoid > 0) self.maxvoid = world.maxvoid;
	else self.maxvoid = AMMO_MAXVOID;
	if (world.maxmana > 0) self.maxmana = world.maxmana;
	else self.maxmana = AMMO_MAXMANA;

	self.origin = spot.origin + '0 0 1';
	if (spot.mangle) self.angles = spot.mangle;
	else self.angles = spot.angles;
	self.v_angle = self.angles;
	self.fixangle = TRUE;				// Turn this way immediately
	setmodel (self, MODEL_PLAYER_EYES); // Oh, this is a hack!
	modelindex_eyes = self.modelindex;
   	setmodel (self,"progs/hipnotic/playham.mdl");
  	modelindex_hammer = self.modelindex;
	setmodel (self, "progs/drake/playham0.mdl");
	modelindex_hamout = self.modelindex;
   	setmodel (self,"progs/drake/playsaw.mdl");
  	modelindex_saw = self.modelindex;
	setmodel (self, "");
	modelindex_null = self.modelindex; // For vehicles to fully hide player more so than just eyes.
	setmodel (self, MODEL_PLAYER);
	modelindex_player = self.modelindex;
	if (!modelindex_eyes) modelindex_eyes = modelindex_player;
	if (!modelindex_hammer) modelindex_hammer = modelindex_player;
	if (!modelindex_hamout) modelindex_hamout = modelindex_player;
	if (!modelindex_saw) modelindex_saw = modelindex_player;
	self.bbmins = VEC_HULL_MIN;
	self.bbmaxs = VEC_HULL_MAX;
	setsize (self, self.bbmins, self.bbmaxs);
	self.view_ofs = '0 0 22'; // Where the feet are! 22 units below!
	player_stand1 ();

	// Check for cinematic system startup (NO COOP!!!)
	//if (self.cameratarget != "" && coop == 0) {
	if (self.cameratarget != "") {
		// Find first camera
		self.enemy = find(world, targetname, self.cameratarget);
		if (self.enemy.classtype == CT_MISCCAM) {
			cam_focus = self.enemy;			// Camera
			cam_client = self;				// Player
			cam_startup = TRUE;				// Special start
			cam_active = CINECAM_SETUP;		// Lets begin!
		}
	} else {
		// Default
		if (deathmatch || coop) {
			makevectors(self.angles);
			spawn_tfog (self.origin + v_forward*20);
		}
		// Teleport effect + sound
		spawn_tdeath (self.origin, self); // gib anything in the way
	}

	// pOx extras_r4/extras_r5 func_water support
	self.fwatershift = TRUE;// catch runaway cshifts (changlevel/respawn while in func_water)
	self.oldgravity = 0;// use unmodified sv_gravity

	RunCommandSpawn();
};

void() PlayerJump;
void() WaterMove;
void() ClientDeath;

void() CheckWaterJump = {
	local vector start, end;

	// check for a jump-out-of-water
	makevectors (self.angles);
	start = self.origin;
	start_z = start_z + 8; 
	v_forward_z = 0;
	normalize(v_forward);
	end = start + v_forward*24;
	traceline (start, end, TRUE, self);
	
	if (trace_fraction < 1) {	// solid at waist
		start_z = start_z + self.maxs_z - 8;
		end = start + v_forward*24;
		self.movedir = trace_plane_normal * -50;
		traceline (start, end, TRUE, self);
		if (trace_fraction == 1) {	// open at eye level
			self.flags = self.flags | FL_WATERJUMP;
			self.velocity_z = 225;
			self.flags = self.flags - (self.flags & FL_JUMPRELEASED);
			self.teleport_time = time + 2;	// safety net
			return;
		}
	}
};

void(entity targ) Client_LadderSounds = {
	local float rndsound;
	if (query_configflag(SVR_FOOTSTEP) == TRUE) return;
	if (targ.entladder.sounds == 4) return;
	
	rndsound = random();
	if (rndsound < 0.25 && targ.entladder.noise1)  sound (targ, CHAN_BODY, targ.entladder.noise1, 1, ATTN_NORM);
	else if (rndsound < 0.5 && targ.entladder.noise2) sound (targ, CHAN_BODY, targ.entladder.noise2, 1, ATTN_NORM);
	else if (rndsound < 0.75 && targ.entladder.noise3) sound (targ, CHAN_BODY, targ.entladder.noise3, 1, ATTN_NORM);
	else if (targ.entladder.noise4) sound (targ, CHAN_BODY, targ.entladder.noise4, 1, ATTN_NORM);
};

void() CheckFuncWaterDeath;

// Called every frame before physics are run
void() PlayerPreThink = {
	// This is just a messy situation ...
	// The savegame data is not live until after frame 0 has finished.  The only variable read from a savegame early is skill level!
	// So instead of detecting Chaos mode changes at frame 0 and fixing them, have to wait for savegame data to be live and client/server stable
	// This function also detects savegames (framecount>0)
	if (chaoscount <= 2) {
		chaoscount = chaoscount + 1; // Increase counter early because of return later
		// Save games don't usually start at framecount 0
		if (framecount > RND_FRAMECOUNT) {
			Client_SyncPrevEvilmode(); // Catch quickload (read 'oskill') and reset skill level

			// Detect skill 4 + Chaos savegame!  Cannot kill player here, client is not properly setup
			if (rnd_CheckNoQuickLoad()) {
				dprint("\b[RND_SYNC]\b FC ("); dprint(ftos(framecount));
				dprint(") Skill 4 death detected!\n");
				chaoscount = 10; // Stop this function and wait for postclient
				framecount = framecount + RND_FRAMECOUNT; // Make sure death happens in PostClient check
			} else {
				dprint("\b[RND_SYNC]\b FC ("); dprint(ftos(framecount));
				dprint(") Save Game Found!\n"); // Save game found, highlight on dev console
			}
		}
		// Wait for frame1 to validate current/savegame chaos setup.  The Restart command cannot be done on frame 0.  It will break the client/server setup sequence
		if (chaoscount == 2) {
			// Returns true if restart required
			if (rnd_CheckSaveGameReboot()) {
				// Works better if restart here instead of above function.  Cannot use map or changelevel command because of savegame
				localcmd ("restart\n");
				prethink = postthink = TRUE; // Block any pre/post functions
				return; // Finish PlayerPreThink function
			}
		}
	}

	// Once the map has loaded (prethink) set loadflag (never saved)
	if (!prethink) {
		prethink = TRUE;			// prethink flag complete
		postthink = FALSE;			// postthink flag reset
		sync_configflag();			// Setup and sync serverflag
		self.air_finished = time + WATER_AIR; // Some clients load faster, prevent player gasping for air
		
		// Double check which engine is active?  A DP/FTE Quickload could be happening and the particle system needs to cope with the change
		ext_active = cvar("pr_checkextension");
		if (!ext_active) {
			// Revert to default = Fitz engine setup
			engine = ENG_FITZ;
			ext_dppart = ext_dpfog = ext_dpsurf = FALSE;
			ext_dprain = ext_dpsnow = FALSE;
		}
		
		// Check for trigger CD track/Skybox change.  Load/Quickload does not keep track of these changes, use a new global variable instead.
		if (trig_cdtrack > 0) trigger_cdtrack_change();
		if (trig_skybox != "") trigger_skybox_change(self);
	}

	if (intermission_running > 0) { impulse_notvalid(); CycleIntermissionCamera(); return; } // If Intermission system active check for button0-2 keys
	if (secloc_running > 0) { impulse_notvalid(); CheckSecretCamera(); return; } // If secret location camera active check for button0-2 keys
	if (self.entactive && self.entattachment) setorigin(self.entattachment, self.origin); // Update particle emitter origin attached to the player.  Cinematic camera uses player and this should be before it
	if (cinematic_running > 0 || cutscene > 0) { impulse_notvalid(); return; } // If cinematic camera system active
    if (cutscene > 0) { Cutscene_Think (); return; } // Check for Drake cutscene stuff.

	// Allowing weapon switch in a vehicle

	// Skill 4 - Detect ANY skill changes (player console)
	if (skill != oskill) {
		// Check if Evil skill enabled? (check skill NOT cvar)
		if (Client_QueryEvilskill()) {
			// Reset HP + Max/Mega and give Shadow Axe
			Client_SetupEvilmode();
			Client_DispEvilmsg();
		} else Client_ResetEvilmode(oskill); // Reset HP/Max (check worldspawn for override)
		oskill = skill; // Sync old and new skill variables
	}

	if (earthquake_active) {
		if ( self.flags & FL_ONGROUND ) {
			self.velocity_x = self.velocity_x + (random() * earthquake_intensity * 2) - earthquake_intensity;
			self.velocity_y = self.velocity_y + (random() * earthquake_intensity * 2) - earthquake_intensity;
			self.velocity_z = self.velocity_z + (random() * earthquake_intensity * 2) - earthquake_intensity;
		}
	}

	makevectors(self.v_angle);

	// func_water screen tinting
	if (self.fwatershift) {
		ResetDebuffScreen(self);
		self.fwatershift = FALSE;
	}

	// Both func_water and func_ladder require zero G to work properly.  Lucky for us, the Mission Pack build of Quake has a gravity modifier we can exploit.
	if (self.zerogtime < time) self.gravity = self.oldgravity;// reset normal gravity
	else self.gravity = 0.0001;// zero G (0 OR 1 is normal), pOx - END  - func_water & func_ladder support

	if (self.tethered && self.tetherfocus) PlayerBallistaThink();
	// TeamCheckLock(); // TODO: Implement Rogue's teamplay.qc stuff.
	// CheckMOTD(); // TODO: Implement Rogue's teamplay.qc stuff.
	CheckRules();
	Divine_Check(); // Lightning strike.
	WaterMove();
	if (self.movetype == MOVETYPE_FLY) {
		self.oldorigin = self.origin;
		if (vlen(self.velocity) >= 70) {
			self.waterlevel = 3;    // Swim mode gives player full 3D control.
			self.flags = self.flags - (self.flags & FL_ONGROUND); // If onground, moving will cause the pitch to center automatically if mouselook is off, so remove the flag while the player swims in mid-air.
			if (self.waterlevel < 2) self.velocity = self.velocity * 1.429;    // This negates the engine's underwater speed penalty.  Don't forget to undo the changes made here in PlayerPostThink.  Inspired by Hip's wetsuit code. But only in the air. 10/7 or 1.428571...
		} else {
			self.waterlevel = 0;    // So player doesn't sink while not moving.
			self.flags = self.flags | FL_ONGROUND; // While not in swim mode, the onground flag gives the player full control in the air, so make sure the flag is on.
		}
		self.flags = self.flags - (self.flags & FL_JUMPRELEASED); // Since the player is flying, make sure the jumpreleased flag is off at all times so when the player loses flight, he can't jump in mid-air in case the onground flag is on.
		// A 'groundentity' is the entity the player stands on.  If the groundentity
		// is not the world, the player is likely standing on something that
		// may move, such as an elevator, a train, trap door. etc.  If groundentity
		// moves, the player tags along for the ride.  The problem comes in if a
		// player, flying in mid-air, has a non-world, moving groundentity.  This
		// lets the groundentity pull the player along when it shouldn't.  To fix
		// this, always set the groundentity to the world, which can never move.
		self.groundentity = world;

		// The jump button works a bit differently while in flymode.
		if (self.button2) {
			if (self.waterlevel) { // Rise if in water.  Otherwise, slam on the brakes.
				if (self.liquidbase == CONTENT_WATER) self.velocity_z = 100; // Water rise
				else if (self.liquidbase == CONTENT_SLIME) self.velocity_z = 80; // Slime rise
				else self.velocity_z = 50; // Lava rise

				if (self.swim_flag < time) {
					self.swim_flag = time + 1;
					if (random() < 0.5) sound (self, CHAN_BODY, "misc/water1.wav", 1, ATTN_NORM); // Play swimming sound
					else sound (self, CHAN_BODY, "misc/water2.wav", 1, ATTN_NORM);
				}
				if (self.waterlevel < 2) self.velocity_z = self.velocity_z * 1.429; // This negates the engine's underwater speed penalty. 10/7 or 1.428571...
			} else { self.velocity_z = 0; }
		}
	} else {
		if (self.waterlevel == 2) CheckWaterJump (); // Not movetype_fly...normal movement and holding space to get out of the water.
		if (self.deadflag >= DEAD_DEAD) { ClientDeath (); return; }
	}

	if (self.deadflag == DEAD_DYING) { CheckFuncWaterDeath(); return; } // pOx - check cshift for dead players in func_water.  Dying, so do nothing after.

	// The jump boots can be setup to work a limited amount of uses before having to be reset by landing on the ground.
	// The starting (1st jump) sequence for the boots is always with a jump, but the player can fall off ledges without jumping.
	// Unfortunately Quake does not let the player jump if falling, but the jump boots should override this behaviour.
	// The engine will reset the fl_onground flag when the player falls off a ledge and this flag is used to determine the starting sequence
	// for the jump boots. This check is outside of the jump function so that the jump boots can always be reset regardless if jump starts the sequence.
	if (self.moditems & IT_ARTJUMPBOOTS && self.flags & FL_ONGROUND) self.jumpboots_onground = TRUE;

	// Rubicon Ladder Code - johnfitz
	// Modified by me to support diff climb sounds and on/off/toggle states. -sock
	if (self.onladder == LADDER_JUMP) {
		self.onladder = LADDER_NONE; // Reset ladder touch function
		if (ext_fteskin && self.entladder.skin == -16) {
			if (self.timeladder < time && self.velocity_x != 0 && self.velocity_y != 0) { // Only do the ladder sound if the player is moving (X/Y)
				self.timeladder = time + self.entladder.waitmin; // Reset timer for next sound to play
				Client_LadderSounds(self); // Check for any sounds and query if footsteps are active
			}
		} else if (self.button2) { // Is jump key being pressed?
			self.velocity = '0 0 0'; // Reset velocity upwards and all sideways movement so that the player stays on the ladder and climbs straight up with very little sidways movement.
			self.velocity_z = self.entladder.speed;
			self.gravity = 0.0000001;
			if (self.timeladder < time) {
				self.timeladder = time + self.entladder.waitmin; // Reset timer for next sound to play
				Client_LadderSounds(self); // Check for any sounds and query if footsteps are active
			}
		} else {
			self.flags = self.flags | FL_JUMPRELEASED; // Jump key released, stay floating on the ladder
			self.velocity = 0.9 * self.velocity;
			self.velocity_z = 0;
		}
	} else if (self.onladder == LADDER_VEL) {
		if (self.button2) { // Is jump key being pressed?
			self.blockladder = time + 0.1;
			self.flags = self.flags - FL_ONGROUND;
			PlayerJump ();
		} else self.flags = self.flags | FL_JUMPRELEASED;
		
		self.onladder = LADDER_NONE; // Reset ladder touch function
	} else {
		if (self.oldgravity > 0) self.gravity = self.oldgravity; // Reset any ladder gravity settings
		else self.gravity = 1;

		if (self.button2) PlayerJump (); // Original jump conditions.  Huh!
		else self.flags = self.flags | FL_JUMPRELEASED;
	}

	if (self.slowdowntime > time) { // Monster Hydra slowdown effect
		self.velocity_x = self.velocity_x * 0.5;
		self.velocity_y = self.velocity_y * 0.5;
		if (self.waterlevel >= 3) {
			self.velocity_z = self.velocity_z * 0.5;
		} else {
			if (self.velocity_z > 0) self.velocity_z = self.velocity_x * 0.5;
		}
	}
		
	// When the player/client starts in the map they don't want any velocity	
	if (time < self.pausetime) self.velocity = '0 0 0';
	if ((autocvar_player_legs_visibility) && (!cvar("chase_active")) && !( deathmatch || coop ) && !(self.invisible_finished > time)) {	// adds player�s legs to 1st person view  (meant for Single player only !)
		if (self.visible_legs_helper == 0) {
			self.visible_legs_helper = 1;
			self.legsattachment = player_legs (self);
		}
	}
	
	if (!self.vehicleattachment) self.vehicleattachment = player_vehicle(self); // Set up vehicle model attachment. Only done once ever.
};

enumflags {
	PLAYER_KEEPALIVE,
	PLAYER_MODELINDEX,
	PLAYER_ORIGIN,
	PLAYER_ORIGIN_Z,
	PLAYER_ANGLES_X,
	PLAYER_ANGLES_Y,
	PLAYER_ANGLES_Z,
	PLAYER_VELOCITY,
	PLAYER_VELOCITY_Z,
	PLAYER_FLAGS,
	PLAYER_WEAPON,
	PLAYER_ITEMS,
	PLAYER_HEALTH,
	PLAYER_ARMOR,
	PLAYER_MOVETYPE,
	PLAYER_VIEWOFS,
	PLAYER_BASEFRAME,
	PLAYER_FRAME,
	PLAYER_AMMO1,
	PLAYER_AMMO2,
	PLAYER_AMMO3,
	PLAYER_UNUSED1,
	PLAYER_UNUSED2
};
	
// Called every frame after physics are run
void() PlayerPostThink = {
	if (prethink == TRUE && postthink == FALSE) {
		if (self.flags & FL_CLIENT) { // Check for the player?  First couple of frames the player is not setup correctly.
			postthink = TRUE;			// postthink flag complete
			mapvar_cvar = TRUE;			// Map Variable are live

			// Cannot load skill 4 + Chaos save games!  Only kill the player once the client/server is setup.  This also catches the savegame resetting Chaos mode.
			if (rnd_CheckNoQuickLoad() && framecount > RND_FRAMECOUNT) {	
				self.deathtype = "loadingevil"; // Classic death message
				centerprint(self,"Cannot resurrect EVIL mode!?!\n");
				T_Damage(self, world, world, MEGADEATH, NOARMOR);
				return;
			}

			// if (!self.cshift_upd) self.cshift_time = -1; // Reset any screen cshift parameters, eng often leaves them
			if (world.water_alpha) { // Check worldspawn water alpha parameters?  Liquid alpha is used by the monster visible system
				liquid_alpha = world.water_alpha;
				Safe_stuffcmd(self, "\nr_wateralpha ");
				lftos(self, liquid_alpha ,1,3, BUFFER_STUFFCMD);
				Safe_stuffcmd(self, "\n");
				dprint("\b[CLIENT]\b Water Alpha (");
				lftos(self, liquid_alpha ,1,3, BUFFER_DPRINT);
				dprint(")\n");
				
			} else liquid_alpha = cvar("r_wateralpha");	

			autoaim_cvar = cvar("sv_aim"); // Check engine for actual autoaim setting.  Always reset with newgame and quickload.
			if (fog_active) change_fog(self); // Create fog controller and/or update engine fog.
			else setup_fog_controller();

			if (skyfog_active) change_skyfog(self); // Sky fog is a different system (only density)
			else setup_skyfog_controller();

			display_configflag(); // Update console with MOD settings
			display_version();

			// Warn about chaos mode	
			if (check_randflags() == TRUE) { // Is the randomizer active?
				sprint(self, "\n\bChaos\b mode ("); sprint(self, ftos(randomflags));
				sprint(self, ") is \benabled\b, be warned!\n");
				sprint(self, "Random Seed ("); sprint(self, ftos(randomorg));
				sprint(self, ") is active!\n\n");
			}
		}
	}

	SUB_PushFrameMovers(); // pOx - Advance frame based entities (noclip)
	self.SendFlags = self.SendFlags | PLAYER_ORIGIN; // CSQC ping

	// Special systems that pause the QC/Game
	if (intermission_running > 0) { earthquake_postthink(); return; } // Level intermission or finale, added hook for rogue earthquake sequence.
	if (secloc_running > 0) return;
	if (cinematic_running > 0) { // separate from `cutscene` and its implementation
		// The focalpoint system is about tracking an entity while the camera is stationary or moving and updating the player viewing angle.
		// The current (2019) community client engines default protocol's are 15 or 666, which unfortunately do not support smooth angle updates.
		// The ideal solution is protocol 999 with higher FP resolution, but this has to be set before the map is loaded and manually via the console which is not user friendly.
		// The updates to player angle/origin were tested in both pre/post QC functions and no difference in visuals could be detected
		// Some engines (QSS/FTE/DP) cope with angle updates better than others (Fitz/QS/MakV) and using protocol 999 certainly helps.
		if (cam_client == self && cam_locked) {
			// Camera tracking system?
			if (cam_movement) {
				if (cam_track.attack_finished < time) { // Finished moving the tracking entity?
					if (!CheckZeroVector(cam_track.enemy.origin)) setorigin(self, cam_track.enemy.origin); // Don't reset origin if at 0,0,0 (usually error)
					cam_movement = FALSE;
				} else { // Update camera (player) origin
					if (cam_bezier) { // Bezier Curve movement
						cam_track.delay = cam_track.wait - (cam_track.attack_finished - time);
						cam_track.origin = bezier_curve(cam_track.pos4, cam_track.pos5, cam_track.pos6, cam_track.wait, cam_track.delay);
						if (!CheckZeroVector(cam_track.origin)) setorigin(self, cam_track.origin); // Don't reset origin if at 0,0,0 (usually error)
					} else { // Linear movement
						if (!CheckZeroVector(cam_track.origin)) setorigin(self, cam_track.origin); // Don't reset origin if at 0,0,0 (usually error)
					}
				}
			}
			if (cam_focus.focalpoint > 0) { // Does the camera have to focus on angletarget?  Validation of angletarget done in misc_cam function
				self.angletarget = cam_focus.angletarget; // Move camera angletarget to player(camera) entity
				TargetMovedir(self, TRUE); // Update movedir, movetarget and dest1.  Targetmovedir function uses (self) for comparision
				cam_newangle = vectoangles(self.movedir); // Convert direction vector to angles.  This function returns integers! (engine code bug)

				//------- Camera Angle Smoothing V2 by Eric Wasylishen --------
				if (!cam_lastanglevalid) {
					cam_lastanglevalid = TRUE; // Initialize last angle (snap to the initial angle)
					cam_lastangle = cam_newangle;
				}
				cam_newangle = vectormod(cam_newangle); // Clamp angles to 0-360
				cam_lastangle = vectormod(cam_lastangle); // Clamp angles to 0-360

				// Need to check every axis (XYZ) for 0 boundary issues.  Function stored in misc_camera.qc (only used for camera's)
				if (camera_check_anglezero(cam_newangle_x, cam_lastangle_x)) {
					if (cam_newangle_x > cam_lastangle_x) cam_newangle_x -= 360; 	// To avoid breaking the interpolation, shift the larger number so it's negative
					else cam_lastangle_x -= 360;
				}
				if (camera_check_anglezero(cam_newangle_y, cam_lastangle_y)) {
					if (cam_newangle_y > cam_lastangle_y) cam_newangle_y -= 360;
					else cam_lastangle_y -= 360;
				}
				if (camera_check_anglezero(cam_newangle_z, cam_lastangle_z)) {
					if (cam_newangle_z > cam_lastangle_z) cam_newangle_z -= 360;
					else cam_lastangle_z -= 360;
				}
				cam_focus.angleblend = CINECAM_ANGLEBLEND; // Blend the last frame's angle with the target.  This controls how much of the target is mixed in, closer to 0 is slower.
				cam_angle = (cam_newangle * cam_focus.angleblend) + (cam_lastangle * (1 - cam_focus.angleblend));
				cam_angle = vectormod(cam_angle); // Clamp angles to 0-360
				cam_lastangle = cam_angle; // Store history of cam_angle for next frame's smoothing
				// ----------------End of Camera Angle smoothing --------------
				cam_angle_x = -cam_angle_x; // Got to reverse the pitch angle because the player angles and v_angle are upside down (special carmack code)
				self.angles = self.v_angle = cam_angle;
			} else {
				self.angles = self.v_angle = cam_angle; // Update the player model/view angles
				self.angles_z = 0; // Reduce drunk camera effect
			}
			self.fixangle = TRUE; // Force engine to update immediately
		}
		return;
	}

	if (self.deadflag) return; // Dead
	if (self.target2 != "") trigger_strs(self.target2, self); self.target2 = ""; // Any spawn targets to update?

	if (self.movetype == MOVETYPE_FLY && self.waterlevel && self.waterlevel < 2) self.velocity = self.velocity * 0.7; // flight adjustment we have boots of levitation
	W_WeaponFrame (); // Impulse commands and Quad updates

	if (map_fallspeeddebug == TRUE && developer > 1 && self.jump_flag != 0){ dprint(ftos(self.jump_flag)); dprint(" "); }// Show the player fall speed/velocity to the console.  Useful for showing what map unit heights affect damage values
	
	// Is the player sliding on top of an entity? (not on ground).  Need postthink check because player starts at 0,0,0 floating :P
	if (self.velocity_z == 0 && !(self.flags & FL_ONGROUND) && postthink) {
		if (self.jumptimer < time && self.movetype != MOVETYPE_NOCLIP ) { // Block players who jump and then noclip around!?!
			self.jumptimer = time + 0.1; // Slow down function, its running pre/post timing
			self.jumptouch = findradius(self.origin, 96); // Create a really small radius list, this is expensive!
			while (self.jumptouch) {
				if (self.jumptouch.classtype == CT_FUNCBREAKMDL) { // Found a breakable model?
					if (self.jumptouch.spawnflags & BREAK_NOSHOOT) { // Check for nodamage spawnflag exception!
						self.jumptimer = time + 2; // Slow down console message
						if (developer > 1) {
							dprint("[SLIDING] Unbreakable obj at ");
							dprint(vtos(self.jumptouch.origin));
							dprint("\n");
						}
					} else {
						// From the player origin down to the feet is 22 (def) units.  The breakable bbox edge (maxs) should be below feet
						if ( (self.jumptouch.origin_z + self.jumptouch.bbmaxs_z) < self.origin_z-self.view_ofs_z && vlen(self.jumptouch.origin - self.origin) <= 64) {
							self.jumptouch.jumpsquash = TRUE; // Squash the contents (monsters) of this breakable
							self.jumptouch.nodebuginfo = TRUE; // Force trigger break object! (no debug info)
							trigger_ent(self.jumptouch, self);
						}
					}
				}
				if (self.jumptouch.flags & FLx_CREATURE && self.jumptouch != self) {
					if (self.shroom_finished > time) { // Mario squash!
						makevectors (self.v_angle);
						self.finalangle = normalize(v_forward);
						self.finalangle_z = 0; // flatten out
						self.velocity = self.velocity + (self.finalangle * 200);
						sound(self,CHAN_VOICE,"qmaster/items/smb_stomp.wav",1,ATTN_NORM);
						self.velocity_z = self.velocity_z + SHROOM_JUMP_BOOST + 200; // Big Jump for Big Dude!
						T_Damage(self.jumptouch,self,self,400,DAMARMOR);
						break;
					}
				}
				self.jumptouch = self.jumptouch.chain; // Keep cycling through radius list
			}
		}
	}
	
	// check to see if player landed and play landing sound	
	
	
	if ((self.jump_flag < map_fallspeedlow) && (self.flags & FL_ONGROUND) && (self.health > 0)) {
		if (self.watertype == CONTENT_WATER) { // Landed deep (waist high) in water
			if (!(self.perms & POW_ARMORNINJA)) sound (self, CHAN_BODY, "player/h2ojump.wav", 1, ATTN_NORM); // Player hits water surface

			// Check if damage can be applied after hitting water surface.  Cannot check jump flag velocity because player hit water
			if (map_falldmgwater > 0 && !((self.perms & POW_ARMORNINJA) || self.water_blessed)) {
				T_Damage (self, world, world, map_falldmgwater, DAMARMOR);
				sound (self, CHAN_VOICE, "player/land.wav", 1, ATTN_NORM); // Play on different channel so it does not conflict, land.wav  = light huh sound (floor impact and no damage)
				self.deathtype = "falling";
			}
		}
		else if (self.jump_flag < map_fallspeedhigh) {
			if (!((self.perms & POW_ARMORNINJA) || self.water_blessed)) { // Prevent fall damage with Ninja Armor or Water Shrine desecration
				if (map_falldmg > 0) {
					T_Damage (self, world, world, map_falldmg, DAMARMOR);
					sound (self, CHAN_VOICE, "player/land2.wav", 1, ATTN_NORM); // land2.wav = heavy huh sound and nasty bone crunching sound
					self.deathtype = "falling";
				}
				else sound (self, CHAN_VOICE, "player/land.wav", 1, ATTN_NORM); // land.wav  = light huh sound (floor impact and no damage)
			}
		} else {
			if (!(self.perms & POW_ARMORNINJA)) sound (self, CHAN_VOICE, "player/land.wav", 1, ATTN_NORM); // land.wav  = light huh sound (floor impact and no damage)
		}
		self.jump_flag = 0;
	}

	if (self.touchedliquid < time && self.touchedsound != "") { // Check for any fake water exit sounds
		sound (self, CHAN_BODY, self.touchedsound, 1, ATTN_NORM);
		self.touchedsound = "";
	}
	if (!(self.flags & FL_ONGROUND)) self.jump_flag = self.velocity_z; // If flying through the air, store player Z velocity in jump flag
	ClientPowerups ();
	ClientDeBuff ();
    CheckMjolnir ();            // SoE:  Modified throwing hammer.
    if (self.hook) GrappleService (); // Update PM 7/24/09:  Added grappler weapon from DoE.
};

void() PlayerJump = {
	if (self.in_a_vehicle == TRUE) { // Jump out of the vehicle
		TakeTargetOutOfVehicle(self,TRUE,FALSE); // Jump, keep vehicle
		return;
	}

	if (self.flags & FL_WATERJUMP) return;

	if (self.waterlevel >= 2) {
		if (self.watertype == CONTENT_WATER) self.velocity_z = 100;
		else if (self.watertype == CONTENT_SLIME) self.velocity_z = 80;
		else self.velocity_z = 50;
		if (self.swim_flag < time) { // play swiming sound
			self.swim_flag = time + 1;
			if (random() < 0.5) sound (self, CHAN_BODY, "misc/water1.wav", 1, ATTN_NORM);
			else sound (self, CHAN_BODY, "misc/water2.wav", 1, ATTN_NORM);
		}
		if (self.shroom_finished > time) self.velocity_z = self.velocity_z + SHROOM_JUMP_BOOST; // Big Jump for Big Dude!
		return;
	}

    if (self.wing_finished) { // Levitation
        if (self.wing_sound <= time) {
            sound (self, CHAN_AUTO, "nehahra/player/flight.wav", 1, ATTN_NORM);
            self.wing_sound = time + 1;
        }
		// Gravity reversal was the simplest method to implement.  Using fancy math to get reverse standard gravity can cause problems if the player gets hit with other effects that change gravity field.
        self.gravity = 0 - fabs(self.gravity);
        return;
    }

	// sock: The jump boots idea by Jose Carlos Rodriguez (JCR) from modjam1.  This code was originally by JCR and modified by me to fit AD layout.  Switched over all the variables to constants and entity options. 
	if (self.moditems & IT_ARTJUMPBOOTS) { // Does the player have the jump boot powerup?
		if(self.flags & FL_ONGROUND) { // On the ground and starting to jump upward.  Reset jump counter and start sequence.
			// Stop constant re-jump, got to press key again
			if (!(self.flags & FL_JUMPRELEASED)) return;
			self.flags = self.flags - (self.flags & FL_JUMPRELEASED);
			self.button2 = 0; // Clear button as jump is happening
			self.jumpboots_sound = FALSE; // Reset 'out of jump power' sound
			self.flags = self.flags - (self.flags & FL_ONGROUND); // Reset onground and jump boots ground flags, not needed anymore.
			self.jumpboots_onground = FALSE; // Jumps boots don't really work until in the air.
			self.jumpboots_airlvl = self.jumpboots_airmax; // Reset maximum amount of air jumps (for level 1-4 item)
			if (self.shroom_finished > time) sound (self, CHAN_BODY, "qmaster/player/jumpmario.wav", 1, ATTN_NORM); // Combination sound of original jump + jump boots
			else sound (self, CHAN_BODY, SOUND_ARTJUMPBOOTS3A, 1, ATTN_NORM);
			self.velocity_z = self.velocity_z + map_jumpheight; // Start with original jump height
			if (self.shroom_finished > time) self.velocity_z = self.velocity_z + SHROOM_JUMP_BOOST; // Big Jump for Big Dude!
		} else {	
			// Still in the air (no ground contact).   Allow for infinite jumps (airmax = -1).  Check for more jumps (1-4) and reset velocity.  Allow for players falling of ledges (jumpboots_onground)
			if(self.jumpboots_airmax == -1 || self.jumpboots_airlvl >= 1 || self.jumpboots_onground) {
				if (!(self.flags & FL_JUMPRELEASED)) return; // Stop constant re-jump, got to press key again
				self.flags = self.flags - (self.flags & FL_JUMPRELEASED);
				self.button2 = 0; // Clear button as jump is happening
				self.jumpboots_sound = time + 0.4; // Reset 'out of jump power' sound
				if (self.jumpboots_onground) self.jumpboots_airlvl = self.jumpboots_airmax; // If the player is falling, allow for air jumps and reset level
				self.jumpboots_onground = FALSE;
				self.jumpboots_airlvl = self.jumpboots_airlvl - 1; // Count down on maximum jump level
				if (self.shroom_finished > time) sound (self, CHAN_BODY, "qmaster/player/jumpmario.wav", 1, ATTN_NORM); // Whoosh, more power
				else sound (self, CHAN_BODY, SOUND_ARTJUMPBOOTS3B, 1, ATTN_NORM);
				self.velocity_z = self.jumpboots_height; // Add jump boot height, different from basic jump
				if (self.shroom_finished > time) self.velocity_z = self.velocity_z + SHROOM_JUMP_BOOST; // Big Jump for Big Dude!
			} else {
				// No more power!	
				if (self.jumpboots_sound < time) { // played sound already?
					self.jumpboots_sound = time + 0.2; // Don't play the sound constantly
					sound (self, CHAN_BODY, SOUND_ARTJUMPBOOTS3C, 1, ATTN_NORM); // clickty click
				}
			}
		}
		if (self.jumpboots_forward > 0) { // Is there any additional forward motion?
			self.pos1 = self.origin;
			self.pos2 = self.velocity; // Work out what speed the player is going forward. 
			self.pos1_z = self.pos2_z = 0; // Flatten vectors by removing Z element
			self.pos3 = self.pos1 + self.pos2; // Add velocity to origin to create future position
			self.t_length = vlen(self.pos3 - self.pos1); // Use vector length function to calc distance
			if (self.t_length < self.jumpboots_forward) { // Check for min/max velocity first
				makevectors (self.v_angle); // Use the forward/right/up vector system
				self.finalangle = normalize(v_forward); // Normalize the result because its a multiplier
				self.velocity = self.velocity + (self.finalangle * (self.jumpboots_forward - self.t_length)); // Never increase the forward velocity beyond limit.  Otherwise the velocity could grow too fast
				if (self.shroom_finished > time) self.velocity_z = self.velocity_z + SHROOM_JUMP_BOOST; // Big Jump for Big Dude!
			}
		}
	} else if (self.onladder == LADDER_VEL) { // Velocity ladder jump logic
		// Can't block onground or jumprelease flag conditions. 
		self.flags = self.flags - (self.flags & FL_JUMPRELEASED); // Very precise order for this, Jumprelease and then onground
		self.flags = self.flags - FL_ONGROUND;	// don't stairwalk
		self.button2 = 0;
		if (self.shroom_finished > time) sound (self, CHAN_BODY, "qmaster/player/jumpmario.wav", 1, ATTN_NORM); 
		else sound (self, CHAN_BODY, SOUND_PLAYER_JUMP, 1, ATTN_NORM); // player jumping sound
		makevectors(self.v_angle); // Jump direction should be v_angle and not just up!
		self.velocity = v_forward * (map_jumpheight*1);
	} else {
		// Original ID1 jump logic
		if (!(self.flags & FL_ONGROUND)) return;
		if (!(self.flags & FL_JUMPRELEASED)) return;	// don't pogo stick

		self.flags = self.flags - (self.flags & FL_JUMPRELEASED); // Very precise order for this, Jumprelease and then onground
		self.flags = self.flags - FL_ONGROUND;	// don't stairwalk
		self.button2 = 0;
		if (self.shroom_finished > time) sound (self, CHAN_BODY, "qmaster/player/jumpmario.wav", 1, ATTN_NORM);
		else sound (self, CHAN_BODY, SOUND_PLAYER_JUMP, 1, ATTN_NORM); // player jumping sound
		self.velocity_z = self.velocity_z + map_jumpheight;
		if (self.shroom_finished > time) self.velocity_z = self.velocity_z + SHROOM_JUMP_BOOST; // Big Jump for Big Dude!
	}
};

// Deals with water, slime and lava
void() WaterMove = {
	if (developer > 1) dprint (ftos(self.waterlevel));
	if (self.movetype == MOVETYPE_NOCLIP) { self.air_finished = time + 10; return; } // Fix noclip water gasping bug by giving air to the player
	if (self.health < 0) return;

	if (self.waterlevel != 3) {
		if (self.air_finished < time) {
			if (!self.air_blessed) sound (self, CHAN_VOICE, "player/gasp2.wav", 1, ATTN_NORM);
		} else if (self.air_finished < time + 9) {
			if (!self.air_blessed) sound (self, CHAN_VOICE, "player/gasp1.wav", 1, ATTN_NORM);
		}
		self.air_finished = time + WATER_AIR;
		self.dmg = map_hazarddmg_x;
	} else if (self.air_finished < time && !self.air_blessed) {	// drown!
		if (self.pain_finished < time) {
			self.dmg = self.dmg + map_hazarddmg_x; // Keep increasing drowning damage
			if (self.dmg > 15) self.dmg = 10;
			T_Damage (self, world, world, self.dmg, DAMARMOR);
			self.pain_finished = time + 1;
		}
	}
	
	if (!self.waterlevel) {
		if (self.flags & FL_INWATER) {	
			sound (self, CHAN_BODY, "misc/outwater.wav", 1, ATTN_NORM); // play leave water sound
			self.flags = self.flags - FL_INWATER;
		}
		return;
	}

	if (self.watertype == CONTENT_LAVA && self.resist_fire < 1) {	// do damage
		if (self.moditems & IT_ARTLAVASHIELD) PlayLavaShieldSound(self); // Check for lava shield and play reminder it exists
		else {
			if (self.dmgtime < time && self.therm_finished < time) {
				if (self.radsuit_finished > time) self.dmgtime = time + 1;
				else self.dmgtime = time + 0.2;

				// Lava damage is crazy high the deeper you go
				if (self.funcwaterdmg_finished < time) T_Damage (self, world, world, map_hazarddmg_z*self.waterlevel*(1-self.resist_fire), DAMARMOR);
			}
		}
	} else if (self.watertype == CONTENT_SLIME && self.resist_acid < 1) {	// do damage
		if (self.dmgtime < time && self.radsuit_finished < time && self.therm_finished < time) {
			self.dmgtime = time + 1;
			if (self.funcwaterdmg_finished < time) T_Damage (self, world, world, map_hazarddmg_y*self.waterlevel * (1-self.resist_acid), DAMARMOR);
		}
	}
	
	if ( !(self.flags & FL_INWATER) ) {	 // player enter water sound
		if (self.infuncwater) self.funcwaterdmg_finished = time + 1;
		if (self.watertype == CONTENT_LAVA) {
			sound (self, CHAN_BODY, "player/inlava.wav", 1, ATTN_NORM);
			if (self.infuncwater) self.funcwaterdmg_finished = time + 0.2;
		}
		if (self.watertype == CONTENT_WATER)
			sound (self, CHAN_BODY, "player/inh2o.wav", 1, ATTN_NORM);
		if (self.watertype == CONTENT_SLIME)
			sound (self, CHAN_BODY, "player/slimbrn2.wav", 1, ATTN_NORM);

		self.flags = self.flags + FL_INWATER;
		self.dmgtime = 0;
	}
	
	if (!(self.flags & FL_WATERJUMP)) self.velocity = self.velocity - 0.8*self.waterlevel*frametime*self.velocity;
};

// CLIENT GAME EDGE FUNCTIONS
void() ClientRespawn = {
	rnd_ResetRandomSeed(RND_NORESETDEATH); // CLIENT DIED = Reset randomizer seed

	if (coop) {
		CopyToBodyQue (self);	// make a copy of the dead body for appearances sake
		setspawnparms (self);	// get the spawn parms as they were at level start
		PutClientInServer();	// respawn
	} else if (deathmatch) {
		CopyToBodyQue (self);	// make a copy of the dead body for appearances sake
		SetNewParms ();			// set default spawn parms
		PutClientInServer();	// respawn
	} else localcmd ("restart\n"); // restart the entire server
};

void() ClientDeath = {
	local float forward;

	self.tethered = FALSE;
	self.tetherfocus = world;
	CheckFuncWaterDeath(); // pOx - func_water support.  Check cshift for dead players in func_water
	if ((self.flags & FL_ONGROUND)) {
		forward = vlen (self.velocity);
		forward = forward - 20;
		if (forward <= 0)
			self.velocity = '0 0 0';
		else	
			self.velocity = forward * normalize(self.velocity);
	}

	// Wait for all buttons released
	if (self.deadflag == DEAD_DEAD) {
		if (self.button2 || self.button1 || self.button0) return;
		self.deadflag = DEAD_RESPAWNABLE;
		return;
	}

	// Wait for any button down
	if (!self.button2 && !self.button1 && !self.button0) return;
	self.button0 = self.button1 = self.button2 = 0;
	ClientRespawn();
};

void() set_suicide_frame; // In player.qc, this function cannot be moved, ref an exact frame in players model

// Player entered the suicide command
void() ClientKill = {
	bprint (self.netname);
	bprint (" suicides\n");
	set_suicide_frame ();
	self.modelindex = modelindex_player;
	self.frags = self.frags - 2; // Extra penalty
	ClientRespawn();
};

// Called when a player connects to a server
void() ClientConnect = {
	bprint (self.netname);
	bprint (" entered the game\n");
	if (intermission_running > 0) GotoNextMap (); // a client connecting during an intermission can cause problems
};

// Called when a player disconnects from a server
void() ClientDisconnect = {
	if (gameover) return; // If the level end trigger has been activated, just return since they aren't *really* leaving

	// let everyone else know
	bprint (self.netname);
	bprint (" left the game with ");
	bprint (ftos(self.frags));
	bprint (" frags\n");
	sound (self, CHAN_BODY, "player/tornoff2.wav", 1, ATTN_NONE);
	sphere_remove(self);
	// if (tag_token_owner == self) tag_token_drop (); // TODO: Add rogue's teamplay.qc stuff
	// TeamDropFlagOfPlayer(self); // TODO: Add rogue's teamplay.qc stuff
	self.steam = -50.000;
	self.team = FALSE;
	set_suicide_frame();
};
//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
//
// Attributions: Qmaster
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
// Entity count: 
// Function count: 
//
// Implements: Mod Map Detection and Handling
//
// Description:
// For broad compatibility, detect which maps are from original mission packs
// or other included mods and handle any discrepancies that might make them
// play differently than originally intended.
//
// This assigns detected_mod to world so that discrepancies can be handled as
// needed.
//=============================================================================

float detected_mod;
float MOD_KEEP = 0; // Map was made for the Keep mod.
float MOD_ID1 = 1; // Map is vanilla from original game.
float MOD_HIPNOTIC = 2; // Map is from Mission Pack 1: Scourge of Armagon.
float MOD_ROGUE = 3; // Map is from Mission Pack 2: Dissolution of Eternity.
float MOD_DRAKE = 4; // Map was made for a Drake pack such as Soul of Evil
float MOD_QUOTH = 5; // Map was made for Quoth or the Lost Chapters

string(float modval) DetectedModName = {
    if (modval == MOD_ID1) return "original Quake (ID1)";
    else if (modval == MOD_HIPNOTIC) return "Mission Pack 1 (Hipnotic)";
    else if (modval == MOD_ROGUE) return "Mission Pack 2 (Rogue)";
    else if (modval == MOD_DRAKE) return "Drake";
    else if (modval == MOD_QUOTH) return "Quoth";
    else return "Keep";
};

// Returns true if current 
float () DetectedMod = {
    float retval = MOD_KEEP;
	dprint("\b[MOD DETECT]\b ");
	dprint(world.model);
    if (world.model == "maps/r1m1.bsp") retval = MOD_ROGUE;
    if (world.model == "maps/r1m2.bsp") retval = MOD_ROGUE;
    if (world.model == "maps/r1m3.bsp") retval = MOD_ROGUE;
    if (world.model == "maps/r1m4.bsp") retval = MOD_ROGUE;
    if (world.model == "maps/r1m5.bsp") retval = MOD_ROGUE;
    if (world.model == "maps/r1m6.bsp") retval = MOD_ROGUE;
    if (world.model == "maps/r1m7.bsp") retval = MOD_ROGUE;
    if (world.model == "maps/r2m1.bsp") retval = MOD_ROGUE;
    if (world.model == "maps/r2m2.bsp") retval = MOD_ROGUE;
    if (world.model == "maps/r2m3.bsp") retval = MOD_ROGUE;
    if (world.model == "maps/r2m4.bsp") retval = MOD_ROGUE;
    if (world.model == "maps/r2m5.bsp") retval = MOD_ROGUE;
    if (world.model == "maps/r2m6.bsp") retval = MOD_ROGUE;
    if (world.model == "maps/r2m7.bsp") retval = MOD_ROGUE;
    if (world.model == "maps/r2m8.bsp") retval = MOD_ROGUE;
    if (world.model == "maps/ctf1.bsp") retval = MOD_ROGUE;
    if (world.model == "maps/hip1m1.bsp") retval = MOD_HIPNOTIC;
    if (world.model == "maps/hip1m2.bsp") retval = MOD_HIPNOTIC;
    if (world.model == "maps/hip1m3.bsp") retval = MOD_HIPNOTIC;
    if (world.model == "maps/hip1m4.bsp") retval = MOD_HIPNOTIC;
    if (world.model == "maps/hip1m5.bsp") retval = MOD_HIPNOTIC;
    if (world.model == "maps/hip2m1.bsp") retval = MOD_HIPNOTIC;
    if (world.model == "maps/hip2m2.bsp") retval = MOD_HIPNOTIC;
    if (world.model == "maps/hip2m3.bsp") retval = MOD_HIPNOTIC;
    if (world.model == "maps/hip2m4.bsp") retval = MOD_HIPNOTIC;
    if (world.model == "maps/hip2m5.bsp") retval = MOD_HIPNOTIC;
    if (world.model == "maps/hip2m6.bsp") retval = MOD_HIPNOTIC;
    if (world.model == "maps/hip3m1.bsp") retval = MOD_HIPNOTIC;
    if (world.model == "maps/hip3m2.bsp") retval = MOD_HIPNOTIC;
    if (world.model == "maps/hip3m3.bsp") retval = MOD_HIPNOTIC;
    if (world.model == "maps/hip3m4.bsp") retval = MOD_HIPNOTIC;
    if (world.model == "maps/hipdm1.bsp") retval = MOD_HIPNOTIC;
    if (world.model == "maps/hipend.bsp") retval = MOD_HIPNOTIC;
	if (retval != 0) dprint(" was made originally for ");
    else dprint(", could not detect a specific mod, using ");
	dprint(DetectedModName(retval));
	if (retval != 0) dprint("...\n             ...reconciling Keep-specific changes to accomodate as needed");
	dprint("\n");
    return retval;
};
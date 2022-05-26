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
// Function count: 1
//
// Implements: Impulse Commands System for keybinds and cheats
//
// Description:
// Handles custom keybinds, weapon changes, and cheat codes.
//=============================================================================

void() print_coins;
void() print_bones;
void() usecommand;
void() HonkHorn;

void() ImpulseCommands = {
	if (   (self.impulse >= 1 && self.impulse <= 8)
        || (self.impulse >= 60 && self.impulse <= 64)
        || (self.impulse >= 75 && self.impulse <= 90)
        || self.impulse == 47) W_ChangeWeapon (self);
	else if (self.impulse == 10) CycleWeaponCommand();
	else if (self.impulse == 12) CycleWeaponReverseCommand();
	else if (self.impulse == 55) HonkHorn();
	else if (self.impulse == 56) ToggleDragonArmor();
	else if (self.impulse == 57) ToggleSpiritShroud();
	else if (self.impulse == 58) ToggleBerserkerArmor(); // Quad time using Demonhide armor for seconds!
	else if (self.impulse == 59) TogglePowerShield(); // Uses cells to absorb damage when hit
	// Only these MOD options can be changed via the console
	else if (self.impulse == 100) toggleautoaim();		// Toggle auto aim
	else if (self.impulse == 105) toggleprojsize();		// Toggle player proj size
	else if (self.impulse == 110) togglezaware();		// Toggle Z aware monsters
	else if (self.impulse == 115) togglepixels();		// Toggle texture modes
	else if (self.impulse == 120) togglefootstep();		// Toggle footstep sound
	else if (self.impulse == 125) toggleliquiddmg();	// Toggle liquid damage
	else if (self.impulse == 130) toggleshotgunproj();	// Toggle SG Projectile
	else if (self.impulse == 135) toggleshotguncase();	// Toggle SG Casing
	else if (self.impulse == 137) toggletrackmissile();	// Toggle tracking missiles on death
	else if (self.impulse == 140) display_version();	// Display MOD config flag
	else if (self.impulse == 142) display_playinfo();	// Display Player information
	else if (self.impulse == 143) print_coins();	// Display total coins in coinpool
	else if (self.impulse == 144) print_bones();	// Display total gibs in gibpool
	else if (self.impulse == 145) StartIntermissionCamera();
	else if (self.impulse == 146) ToggleFlashlight(); // Quoth flash light
	else if (self.impulse == 150) togglecoopartifacts();// Toggle COOP can drop artifacts
	else if (self.impulse == 152) togglecoopweapons();	// Toggle COOP weapons to respawn
	else if (self.impulse == 154) togglecoophealth();	// Toggle COOP health to respawn
	else if (self.impulse == 155) togglecoopammoboxes();// Toggle COOP ammo boxes to respawn
	else if (self.impulse == 158) togglecooppowerups();	// Toggle COOP powerups to respawn
	else if (self.impulse == 159) usecommand(); // USE such as for purchases in versus mode coop 3
	else if (self.impulse == 160) toggleweather();		// Toggle Weather Systems
	else if (self.impulse == 162) togglehpmax(25);	// Cycle health in 25 increments, 25, 50, 75, ...250, 25. Skips 0.
	else if (self.impulse == 164) togglehpmax(50);	// Cycle health in 50 increments, 50, 100, ...250, 50... Skips 0.
	else if (self.impulse == 170) togglebodyremoval();	// Toggle monster body fade/removal
	else if (self.impulse == 175) display_customkeys();	// Display Custom Key inventory
	else if (self.impulse == 178) CycleThroughHuds();	// Cycle through different custom HUDS
	else if (self.impulse == 180) display_secrets();	// Display a list of secret locations
	else if (self.impulse == 182) display_secretlocs();	// Display secret locations
	else if (self.impulse == 184) display_monsleft();	// Display a list of monsters left
	else if (self.impulse == 185) display_monsqty();	// Display a table of monster type/qty
	else if (self.impulse == 186) display_ammostats();	// Display a list of Ammo Stats
	else if (self.impulse == 190) display_randomizer();	// Display current random seed
	else if (self.impulse == 192) display_randflags();	// Display current settings
	else if (self.impulse == 194) display_randupgrade();// Display weapon upgrades
	else if (self.impulse == 196) reset_randomizer();	// Reset seed for Chaos system
	else if (self.impulse == 200) toggleupgradeaxe();	// Toggle Axe Upgrade
	else if (self.impulse == 205) toggleupgradessg();	// Toggle Shotgun Upgrade
	else if (self.impulse == 210) toggleupgradelg();	// Toggle Lightning Upgrade
	else if (self.impulse == 220) display_configflag();	// Display MOD config flag
	else if (self.impulse == 222) showbits_configflag();// Show exact values of flag
	else if (self.impulse == 225) display_mapvar();		// Display all map variables
	else if (self.impulse == 230) toggleaipath();		// Display AI path extra info
	else if (self.impulse == 231) toggledevhelpers();	// Toggle Dev Helpers (mark/arrow)
	else if (self.impulse == 235) CycleParticleDebug();	// Cycle particle debug
	else if (self.impulse == 239) JumpBootsCheat();
	else if (self.impulse == 240) givesigil(SVR_RUNE_ALL);	// Give all sigils to player
	else if (self.impulse == 241) givesigil(SVR_RUNE_KEY1);	// Give various sigil to player
	else if (self.impulse == 242) givesigil(SVR_RUNE_KEY2);	// Will be reset on map load
	else if (self.impulse == 243) givesigil(SVR_RUNE_KEY3);	// Mainly used for testing
	else if (self.impulse == 244) givesigil(SVR_RUNE_KEY4);
	else if (self.impulse == 245) givekey(IT_KEY1 + IT_KEY2);	// Both
	else if (self.impulse == 246) LavaShieldCheat();
	// else if (self.impulse == 247) AirTankCheat();
	else if (self.impulse == 247) BlastBeltCheat();
	else if (self.impulse == 248) TomeOfPowerCheat();
	else if (self.impulse == 249 || self.impulse == 9 || self.impulse == 13) CheatCommand();
	else if (self.impulse == 250) SharpshooterCheat();
	else if (self.impulse == 251) NailPiercerCheat();
	else if (self.impulse == 252) EnvSuitCheat();
	else if (self.impulse == 253) PentagramCheat();
	else if (self.impulse == 254) InvisibleCheat();
	else if (self.impulse == 255) QuadDamageCheat();
	self.impulse = 0;
};
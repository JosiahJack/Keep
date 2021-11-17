//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
//
// Attributions: Rogue
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
// Function count: 0
//
// Implements: Rogue entity definitions
//
// Description:
// Definitions for rogue entities.
//=============================================================================

float earthquake_active;
float earthquake_intensity;

.vector dragonLastVelocity;
.vector elevatorDestination;
.float ammo_lava_nails;
.float ammo_multi_rockets;
.float ammo_plasma;
.float antigrav_finished;
.float antigrav_time;
.float AGping;
.float childrenSpawned;
.float dragonAttacking;
.float dragonDeathState;
.float dragonInRoom;
.float dragonInTransit;
.float dragonPainSequence;
.float elevatorOnFloor;
.float elevatorLastUse;
.float elevatorToFloor;
.float items2;
.float plat2Called;
.float plat2GoTo;
.float plat2GoTime;
.float plat2LastMove;
.float playerInRoom;
.float playerInTransit;
.float shield_finished;
.float shield_time;
.float shieldSoundTime;
.float lavaGunFired;
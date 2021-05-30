//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
//
// Attributions: Arms of Asgard (AoA) by ryanscissorhands
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
// Implements: AoA Weapon entity definitions
//
// Description:
// Definitions for AoA entities.
//=============================================================================

float FLAK_NAILUSAGE = 8;
float FLAK_ROCKETUSAGE = 2;
float GUNGNIR_DIVE_VOIDUSAGE = 3;

.float ammo_bloodcrystals;
.float ammo_voidshards;
.float ammo_elemental;

void() RyanscissorhandsChecks; //called every frame by PlayerPostThink() to ensure that the proper player model is being used while wielding weapons
void() W_FireScimitar; //the first attack in the scimitar's combo
void() W_FireRapier; //
void() W_FireIce; //
void() W_FireMace; //
void() W_FireVoidStaff; //
void() W_FireFlak; //
void() W_FireGungnir; //
void() W_FireSanguinators; //
void() StaffShot1;
void() VoidStaffProjectile;
void() precache_aoa;
void() LaunchBoulder;
void() GungnirVortex1;
float(entity target) CountFlakAmmo;
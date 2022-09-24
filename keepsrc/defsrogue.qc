//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by W. Josiah Jack, aka Qmaster
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
.float steam;
.float suicide_count;
.float ctf_flags;
.float ctf_killed;
.float ctf_flagsince;
.float ctf_lasthurtcarrier;
.float ctf_lastreturnedflag;
.float ctf_lastfraggedcarrier;
float TEAM1    = 5.000;
float TEAM2    = 14.000;
float TEAM3    = 1.000;
entity team1_lastspawn;
entity team2_lastspawn;
float nextteamupdtime /* = 0.000 */;
float TEAM_NORMAL_NODAMAGE    = 1.000;
float TEAM_NORMAL_DAMAGE    = 2.000;
float TEAM_DMATCH_TAG    = 3.000;
float TEAM_CTF    = 4.000;
float TEAM_CTF_ONEFLAG    = 5.000;
float TEAM_CTF_ALT    = 6.000;
float GAMECFG_ENABLE_RUNES    = 1.000;
float GAMECFG_TEAM_ARMOR_DMG    = 2.000;
float GAMECFG_TEAM_HEALTH_DMG    = 4.000;
float GAMECFG_USE_COLOR    = 8.000;
float GAMECFG_ALLOW_CHG    = 16.000;
float CTF_CAPTURE_BONUS    = 15.000;
float CTF_TEAM_BONUS    = 10.000;
float CTF_ALT_CAPTURE_BONUS    = 8.000;
float CTF_ALT_TEAM_BONUS    = 4.000;
float CTF_RECOVERY_BONUS    = 1.000;
float CTF_FRAG_CARRIER_BONUS    = 2.000;
float CTF_FLAG_RETURN_TIME    = 40.000;
float CTF_CARRIER_DANGER_PROTECT_BONUS    = 2.000;
float CTF_CARRIER_PROTECT_BONUS    = 1.000;
float CTF_FLAG_DEFENSE_BONUS    = 1.000;
float CTF_RETURN_FLAG_ASSIST_BONUS    = 1.000;
float CTF_FRAG_CARRIER_ASSIST_BONUS    = 2.000;
float CTF_TARGET_PROTECT_RADIUS    = 400.000;
float CTF_ATTACKER_PROTECT_RADIUS    = 400.000;
float CTF_CARRIER_DANGER_PROTECT_TIMEOUT    = 4.000;
float CTF_CARRIER_FLAG_SINCE_TIMEOUT    = 2.000;
float CTF_FRAG_CARRIER_ASSIST_TIMEOUT    = 6.000;
float CTF_RETURN_FLAG_ASSIST_TIMEOUT    = 4.000;
float CTF_UPDATE_TIME    = 120.000;
float CTF_FLAG_FLAG    = 1.000;
float CTF_FLAG_TEAM1    = 1.000;
float CTF_FLAG_TEAM2    = 2.000;
float CTF_FLAG_STUFF_COLOR    = 4.000;
float FLAG_AT_BASE    = 0.000;
float FLAG_CARRIED    = 1.000;
float FLAG_DROPPED    = 2.000;
entity theActor;
entity theMachine;
float actorStage /* = 0.000 */;
float STAGE_START    = 0.000;
float STAGE_TO_POINT1    = 1.000;
float STAGE_AT_POINT1    = 2.000;
float STAGE_TO_POINT2    = 3.000;
float STAGE_AT_POINT2    = 4.000;
float STAGE_FIRING    = 5.000;
entity tag_token_owner;
.float ltrailLastUsed;
.float orbitPosition;
.float tag_frags;
.float tag_message_time;
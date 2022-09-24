//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by W. Josiah Jack, aka Qmaster
//
// Attributions: Quoth and Preach
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
// Implements: Quoth entity definitions
//
// Description:
// Definitions for quoth entities.
//=============================================================================

float LIGHTNING_RANDOM = 1;
float LIGHTNING_BOOM = 2;
vector VEC_HULL_MIN = '-16 -16 -24';
vector VEC_HULL_MAX = '16 16 32';

.vector oldenemyorigin;
.vector spawnmaxs;
.entity eye;
.float activated_time;
.float awake;
.float carry_time;
.float coiled;
.float flashlight;
.float cross_finished;
.float cross_sound;
.float cross_start;
.float cross_time;
.float dangle;
.float dlord_firecnt;
.float dlord_searchtime;
.float dlord_playervis;
.float drole_searchtime;
.float drop;
.float gotbomb;
.float gug_slapped;
.float inv;
.float multiplier;
.float polyp_speed;
.float shield;
.float startonground;
.float trinity_finished;
.float trinity_start;
.float trinity_time;
.float vermis_grabbed;
.float carrymode;
.entity carry;
.vector origin2;
.float vsightmultiplier;
.float vmultiplier;
.string pathtarget;
.void() th_novis;
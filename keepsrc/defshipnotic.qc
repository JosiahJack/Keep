//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by W. Josiah Jack, aka Qmaster
//
// Attributions: Mission Pack 1 (Hipnotic) by Ritual Entertainment
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
// Implements: Hipnotic entity definitions
//
// Description:
// Definitions for hipnotic entities.
//=============================================================================

float UNDERWATER    			= 2.000;
float CHARMED_RADIUS    		= 1500.000;
float MAX_CHARMER_DISTANCE   	= 200.000;
float MIN_CHARMER_DISTANCE    	= 150.000;
float TOOCLOSE_CHARMER_DISTANCE = 120.000;
float ATTN_ARMAGON    = 0.500;
float SERVO_VOLUME    = 0.500;
float hipearthquake;
float quakeactive;
float discharged;
float NumProximityGrenades;
float visible_distance;
float modelindex_hammer;
.float horn_active;
.entity charmer;
.float charmed;
.float huntingcharmer;
.entity tesla_target;
.float tesla_numtargets;
.vector old_velocity;
.entity lastvictim;
.entity next_ent;
.entity spawnmaster;
.float col;
.float empathy_finished;
.float empathy_sound;
.float empathy_time;
.float gorging;
.float spawnsilent;
.float spawnmulti;
.float stoleweapon;
.float struck_by_mjolnir;
.float wetsuit_finished;
.float wetsuit_time;
.float spawnsolidtype;
.string spawnmodel;
.void() spawnthink;
entity bulletholes;
entity lastbullet;
float numbulletholes;
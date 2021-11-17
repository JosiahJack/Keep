//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
//
// Attributions: extras_r4 and extras_r5 (Khreathor update)
//				Written by Frank Condello <pox@planetquake.com>
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
// Implements: extras_r4 and extras_r5 related definitions
//
// Description:
// Prototypes and globals for extra junk...
//=============================================================================

float CAN_DROWN 		= 32768; // Make an enemy able to drown
float ABSOLUTE 			= 2;
float TANGENTIAL 		= 16;
float NOT_X 			= 2;
float NOT_Y 			= 4;
float NOT_Z 			= 8;
float EMITSOLID 		= 2;
float REMOVEONTOUCH 	= 4;
float DIEAFTERANIM 		= 8;
float SPINPARTICLES 	= 16;
float STAGGERFRAMES 	= 32;
float KILLINFWATER		= 64;
float USEEFFECTORS 		= 128;
float STARTSTOPPED 		= 256;
.float v1, v2;
.float h1, h2;
.float frate, frate2;
.float nfrms, nfrms2;
.float lspan, lspan2;
.float ppe;
.float stagcnt;
.float ang_ofs;
.float	infuncwater;	// In func_water flag (khreathor)
.float	inBSPwater;		// In regular water flag (khreathor)
.float	onsurface;		// Enemy near the surface (khreathor)
.float	drawntime;		// Delays between drawning damage (khreathor)
.float 	uwmuffle;		// underwater muffle playing flag
.float	outwsound;		// head out of water flag
.float	inwsound;		// head back in water flag
.float	drown_cnt;		// counter for drowning formula - see liquid_drown in extras_water.qc (khreathor)
.float	drown_dmg;		// damage for drowning formula - see liquid_drown in extras_water.qc (khreathor)
.float	nobleed; 		// No bleed triggers
.float fwatershift; 	// func_liquid
.float fwatershifttime;
.string cshift;
.string fmover;
.float drag;
.float laddertime;
.float ladderjump;
.float gravity;			// Actually a system global from the Mission Pack builds of Quake
.float oldgravity;
.float zerogtime;
.entity tempgoal; 		// Swimming monsters use
.float speed2;
.float wait2;
.string event, event2;
.string noise5;
.string	mdl2;
float START_ON = 1;
.string message2, killtarget2;
.vector neworigin;
.vector rotate;
.float  endtime;
.float  rotate_type;
.string path;
.string group;
.float	duration;
.float slowdowntime;

void() train_ext_linkchild;
void() SUB_PushFrameMovers;
void(string action, float value) ai_fish_movement;
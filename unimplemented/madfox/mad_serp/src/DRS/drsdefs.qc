/*
====================================
DRSDEFS.QC

Contains custom mod stuffs

====================================
*/

void(entity attacker, float damage) SUB_NullPain = {}; // DRS: Fix for compiler warnings when using SUB_Null on pain functions

// DRS: New player frame animation system
.vector pf_anidata; // Start, end, animation time
.float pf_state; // What is the player doing?
.float pf_anitime; // animation time.

// Player Frame Defs
// running (ax 0-5, gun 6-11)
// standing (gun 12-16, ax 17-28)
// pain (ax 29-34, gun 35-40)
// death (ax 41-49, guna 50-60, gunb 61-69, gunc 70-84, gund 85-93, gune 94-102)
// attacks (nail 103-104, light 105-106, rock 107-112, shot 113-118,
// ax 119-124, axb 125-130, axc 131-136, axd 137-142)
// vector, information format = Start Frame, End Frame, Animation Speed.

vector PFG_AXRUN = '0 5 0.1'; // Player Frame Group, Axe running
vector PFG_GUNRUN = '6 11 0.1'; // Gun Running
vector PFG_GUNSTAND = '12 16 0.1'; // Gun Standing
vector PFG_AXSTAND = '17 28 0.1'; // Axe Standing
vector PFG_AXPAIN = '29 34 0.1'; // Axe Pain
vector PFG_GUNPAIN = '35 40 0.1'; // Gun Pain
vector PFG_AXDIE = '41 49 0.1'; // Axe Death, falls backwards, ending on back
vector PFG_GUNDIEA = '50 60 0.1'; // Gun Death A, grabs face, falls forward
vector PFG_GUNDIEB = '61 69 0.1'; // Gun Death B, falls backward, sitting
vector PFG_GUNDIEC = '70 84 0.1'; // Gun Death C, flies forward, falling facedown (e.g. blownup.)
vector PFG_GUNDIED = '85 93 0.1'; // Gun Death D, crumples down, falling facedown
vector PFG_GUNDIEE = '94 102 0.1'; // Gun Death E, falls down, landing on side
vector PFG_NAILATT = '103 104 0.1'; // Nail Attack
vector PFG_LIGHTATT = '105 106 0.1'; // Lighting Attack (no model muzzleflash nail attack)
vector PFG_ROCKATT = '107 112 0.1'; // Rocket Attack, fired from shoulder height
vector PFG_SHOTATT = '113 118 0.1'; // Shotgun Attack, fired from hip.
vector PFG_AXATTA = '119 124 0.1'; // Axe Attack A, 1 handed, overhead swing
vector PFG_AXATTB = '125 130 0.1'; // Axe Attack B, 2 handed, left to right swing
vector PFG_AXATTC = '131 136 0.1'; // Axe Attack C, 2 handed, overhead smash
vector PFG_AXATTD = '137 142 0.1'; // Axe Attack D, 1 handed, right to left swing

float PF_STAND = 0; // Standing state
float PF_AXSTAND = 1; // Regular ax standing state
float PF_RUN = 2; // Regular running with guns state
float PF_AXRUN = 4; // Regular running with axe state
float PF_FIRE1 = 8; // Regular shotgun shooting state
float PF_FIRE2 = 16; // Regular rocket shooting state
float PF_FIRE3 = 32; // Regular nailgun shooting state
float PF_FIRE4 = 64; // Regular lightning shooting state
float PF_AXATTACK = 128; // axattack
float PF_PAIN = 256; // Car Smashed. XD
float PF_DYING = 512; // This is the end, my friend.  No animations played, handled via player_die stuffs.
float PF_CLEAR = 1024; // Allows the frame animation stuff in client.qc to know when you've finished gunshoot animations
float PF_RESETFIRE1 = 2048; // Reset fire1
float PF_RESETFIRE2 = 4096; // Reset fire2
float PF_RESETFIRE3 = 8192; // Reset fire3
float PF_RESETFIRE4 = 16384; // Reset fire4

// DRS: Note that .pf_state is set in client.qc in PlayerPostThink.
void() player_pthink;
void() Update_PF; // Update player frame in accordance with pf_state.  Defined in player.qc

.float g_fired; // testing
// DRS: New Weapon Animation system.


// DRS: Engine Extensions
float(string s) checkextension = #99; // Critical for checking for builtins

// DRS: This was added from fteextensions.qc
const float CLIENTTYPE_DISCONNECTED = 0;	/* Return value from clienttype() builtin. This entity is a player slot that is currently empty. */
const float CLIENTTYPE_REAL = 1;	/* This is a real player, and not a bot. */
const float CLIENTTYPE_BOT = 2;	/* This player slot does not correlate to a real player, any messages sent to this client will be ignored. */
const float CLIENTTYPE_NOTACLIENT = 3;	/* This entity is not even a player slot. This is typically an error condition. */

void(entity player) dropclient = #453; /* Part of DP_SV_DROPCLIENT*/
entity() spawnclient = #454; /* Part of DP_SV_BOTCLIENT*/
float(entity client) clienttype = #455; /* Part of DP_SV_BOTCLIENT*/

float engext_flags; // Engine extensions supported flags

const float MATHLIBS = 1; // Mathlib engine support.  Used by FBX
const float DP_SV_BOTCLIENT = 2; // botclient support.  Used by FBX.  Note that DP_SV_DROPCLIENT is considered part of this.

void () MathlibCheckBuiltins; // Redeclare because mathlib.qc is compiled later

// DRS: Call this in worldspawn, just like with the mathlib functions
void() CheckEngExt =
{
	local float checkext;

	MathlibCheckBuiltins(); // DRS: Check for mathlib engine builtins
	
	checkext = cvar("pr_checkextension");
	if(checkext)
	{
		if(checkextension("DP_SV_BOTCLIENT") && checkextension("DP_SV_DROPCLIENT"))
			engext_flags = engext_flags | DP_SV_BOTCLIENT;
	}
};

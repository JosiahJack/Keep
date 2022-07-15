//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by W. Josiah Jack, aka Qmaster
//
// Attributions: Qmaster, Drake
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
// Entity count: 1
// Function count: 
//
// Implements: Victory Trigger
//
// Description:
// Entity for firing triggers when all monsters have been killed.  Updated to
// include many different choices for partial value threshold, all monsters
//=============================================================================

float VICTORY_ALL_MONSTERS = 0;
float VICTORY_THRESHOLD_MONSTERS = 1;
float VICTORY_ANY_SOME_MONSTERS = 2;
float VICTORY_NONE_MONSTERS = 3;
float VICTORY_NONE_DENIZENS = 4;
float VICTORY_THRESHOLD_DENIZENS = 5;
float VICTORY_ANY_SOME_DENIZENS = 6;
float VICTORY_ALL_DENIZENS = 7;
float VICTORY_MANUAL_ONLY = 1; // Only trigger if targetted, not automatic on kill.

void() trigger_victory_fire = { // [FUNCTION]
	if (self.enemy) activator = self.enemy;
	SUB_UseTargets();
	if (self.wait < 0) self.wait = TRUE;
};

void() trigger_victory_check = { // [FUNCTION]
	local float goal, goalperc;

	if (self.wait > 0) return;
	if (self.filterstyle == VICTORY_ALL_MONSTERS) {
		if (killed_monsters < total_monsters) return;
	} else if (self.filterstyle == VICTORY_ALL_DENIZENS) {
		if (killed_denizens < total_denizens) return;
	} else if (self.filterstyle == VICTORY_NONE_MONSTERS) {
		if (killed_monsters > 0) return;
	} else if (self.filterstyle == VICTORY_NONE_DENIZENS) {
		if (killed_denizens > 0) return;
	} else if (self.filterstyle == VICTORY_ANY_SOME_MONSTERS) {
		if (killed_monsters <= 0) return;
	} else if (self.filterstyle == VICTORY_ANY_SOME_DENIZENS) {
		if (killed_denizens <= 0) return;
	}

	if (self.filterstyle == VICTORY_THRESHOLD_MONSTERS
		|| self.filterstyle == VICTORY_THRESHOLD_DENIZENS) {
		goalperc = SUB_ClampFloat(self.count,0,1);
	}

	if (self.filterstyle == VICTORY_THRESHOLD_MONSTERS) {
		goal = SUB_ClampFloat(ceil(total_monsters * goalperc),0,total_monsters);
		if (self.count >= 1) goal = ceil(self.count);
		goal = SUB_ClampFloat(goal,1,total_monsters);
		if (killed_monsters < goal) return;
	}

	if (self.filterstyle == VICTORY_THRESHOLD_DENIZENS) {
		goal = SUB_ClampFloat(ceil(total_denizens * goalperc),0,total_denizens);
		if (self.count >= 1) goal = ceil(self.count);
		goal = SUB_ClampFloat(goal,1,total_denizens);
		if (killed_denizens < goal) return;
	}

	trigger_victory_fire();
};

// --> QUAKED trigger_victory (.5 .5 .5) (-8 -8 -8) (8 8 8)
// Drake entity.
// Only be fired by killing the last monster on a level (i.e., 100% kills).
// It can contain killtargets, targets, delays, and messages.
void() trigger_victory = { // [ENTITY]
    if (self.filterstyle == VICTORY_NONE_MONSTERS || // Prevent immediate 
        self.filterstyle == VICTORY_NONE_DENIZENS) { // triggering on map start.
        self.spawnflags = self.spawnflags | VICTORY_MANUAL_ONLY;
    }

	// Allow forcing the effect manually.
	if (self.targetname != "") self.use = trigger_victory_check;
};
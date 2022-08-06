//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
//
// Attributions: Copper and Arcane Dimensions (AD)
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
// Function count: 12
//
// Implements: Evil Mode (Copper Nightmare's 50 health Max)
//
// Description:
// Wrestles with the engine to force a skill 4. The engine forces skill to be
// 0 to 3.  Sets maximum health to be 50 on skill 4 (which is a modified skill
// 3 since the engine has it's shenanigans).
//=============================================================================
void() Client_SetEvilFlag = { cvar_set("scratch4", "1"); };
void() Client_ClearEvilFlag = { cvar_set("scratch4", "0"); };
void() Client_SetEvilSkill = { cvar_set("skill", ftos(SKILL_EVIL)); skill = SKILL_EVIL; };

// The engine constantly changes skill to 0-3 only.  Read console variable and set evil skill again
void() Client_SyncEvilmode = {
	if (cvar("scratch4") > 0) { // Console variable set?
		dprint("\b[SKILL4]\b Re-sync skill to scratch4 cvar\n");	
		Client_SetEvilSkill();
		oskill = -1; // Force a re-sync in PlayerPreThink
	}
};

// This is designed to catch quickload/load games.  Detect changes with oskill that are written to savefiles
void() Client_SyncPrevEvilmode = {
	if (oskill >= SKILL_EVIL) { // Quickload skill check?
		dprint("\b[SKILL4]\b Detecting Quickload functions\n");
		Client_SetEvilFlag(); // Set evil...
		Client_SetEvilSkill(); // ...and skill cvar's
		oskill = -1; // Force a re-sync in PlayerPreThink
	}
};

// Basic check for EVIL mode (cvar + skill)
float() Client_QueryEvilmode = {
	if (cvar("scratch4") > 0 || skill >= SKILL_EVIL) return TRUE;
	else return FALSE;
};

float() Client_QueryEvilskill = {
	if (skill >= SKILL_EVIL) return TRUE;
	else return FALSE;
};

// Check HP for max limit and minimum (50%) balance for new games
void(entity targ, float hpminimum, float had_regen) Client_CheckMaxHP = {
	if (targ.health > targ.max_health) targ.health = targ.max_health; // Make sure current HP is not over limit
	if (hpminimum && targ.health < (targ.max_health/2)) targ.health = targ.max_health/2;
	if (had_regen) targ.health = targ.max_health; // We've regenerated health during the intermission ;)
};

// Evil mode should always have a shadow axe (default)
void(entity targ) Client_CheckEvilInv = {
	if (Client_QueryEvilmode()) { // Evil skill active?
		if (!(targ.moditems & IT_UPGRADE_AXE)) { // Make sure player always starts with shadow axe!?!
			targ.items = targ.items | IT_AXE;
			targ.moditems = targ.moditems | IT_UPGRADE_AXE; // Add shadow axe to extra inventory
			targ.weapon = IT_AXE; // Switch weapons and focus on Shadow Axe
			W_SetCurrentAmmo(targ,TRUE);
		}
	}
};

// Setup HP/Mega limits for Evil skill and add Shadow Axe!
void() Client_SetupEvilmode = {
	dprint("\b[SKILL4]\b EvilMode Enabled!\n");
	Client_SetEvilFlag(); // Set Evil skill flag
	if (self.perms & POW_VITALITY) self.max_health = HEAL_EVILMAX + 25;
	else self.max_health = HEAL_EVILMAX;
	
	self.mega_health = HEAL_PLAYMAX;
	Client_CheckMaxHP(self, FALSE, FALSE); // Current HP over limit?
	Client_CheckEvilInv(self);
};

// Reset HP/Mega back to skill 0-3 and check worldspawn for overrides.  prevskill is for players who switch skills to gain ShadowAxe!
void(float prevskill) Client_ResetEvilmode = {
	dprint("\b[SKILL4]\b EvilMode Disabled\n");
	// Clear Evil skill flag
	Client_ClearEvilFlag();
	// Check worldspawn for any previous default?
	if (world.player_health_z <= 0) {
		self.max_health = HEAL_PLAYMAX;
		self.mega_health = HEAL_MEGAMAX;
	} else {
		// Are there any skill level restriction?  1 = EASY, 2 = NORMAL, 4 = HARD, 8 = NIGHTMARE, 15 = ALL
		if ( (world.player_health_z & HP_EASY && skill == SKILL_EASY) ||
			 (world.player_health_z & HP_NORMAL && skill == SKILL_NORMAL) ||
			 (world.player_health_z & HP_HARD && skill == SKILL_HARD) ||
			 (world.player_health_z & HP_NIGHTMARE && skill >= SKILL_NIGHTMARE) ) {
			// Double check max is not negative or zero
			if (world.player_health_x <= 0) self.max_health = HEAL_PLAYMAX;
			else self.max_health = world.player_health_x;
			if (world.player_health_y <= 0) self.mega_health = HEAL_MEGAMAX;
			else self.mega_health = world.player_health_y;
		}
	}
	Client_CheckMaxHP(self, FALSE, FALSE); // Current HP over limit?
	if (prevskill >= SKILL_EVIL) { // Switching skill levels has consequences
		if (self.moditems & IT_UPGRADE_AXE) { // Shadow axe is removed and quake axe restored
			sprint(self, "Shadow Axe removed!\n");
			sprint(self, "You feel your power fading!\n");
			Safe_stuffcmd(self, "bf\n");
			self.moditems = self.moditems - (self.moditems & IT_UPGRADE_AXE);
			self.items = self.items | IT_AXE;
			self.weapon = IT_AXE;
			W_SetCurrentAmmo(self,TRUE);
		}
	}
};

// Show a random EVIL console/topleft message on start of map.  Just some funny EVIL messages
void() Client_DispEvilmsg = {
	local float rndmsg;

	rndmsg = floor(random()*10);
	sprint(self,"\<\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\>\n"); // Draw a line on the console and pick and a random message
	if (rndmsg < 1) sprint(self, "  -- Could you be \bEVIL\b incarnate? --");
	else if (rndmsg < 2) sprint(self, " -- Hear \bEVIL\b, speak \bEVIL\b, do \bEVIL\b! --");
	else if (rndmsg < 3) sprint(self, " - What is your bidding \bEVIL\b Acolyte? -");
	else if (rndmsg < 4) sprint(self, "  -- Embrace the \bEVIL\b within you! --");
	else if (rndmsg < 5) sprint(self, " -- Cut them down with \bEVIL\b intent! --");
	else if (rndmsg < 6) sprint(self, " -- \bChaos\b and \bEVIL\b are just divine! --");
	else if (rndmsg < 7) sprint(self, "-- Have you become an \bEVIL\b Believer? --");
	else if (rndmsg < 8) sprint(self, " -- \bEVIL\b deeds create great needs! --");
	else if (rndmsg < 9) sprint(self, " - After eons of time \bEVIL\b is alive! -");
	else sprint(self, "- \bEVIL\b hands find righteous purpose! -");
	sprint(self,"\n\n");
	Safe_stuffcmd(self, "bf\n");
};
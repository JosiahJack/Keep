//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
//
// Attributions: My own, though heavily inspired by Drake
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
// Entity count: 0 - Utility functions only.
// Function count: 9
//
// Implements: AI Behavior Values and Allegiance System
//
// Description:
// Determines monster behavior outside of normal circumstances
// Defaults to standard monster behavior of:
//	- angry on sight of player
//	- angry on hearing fighting (nearby monster notification)
//	- angry when targeted
//	- chases player we are angry with (self.enemy) for indefinite amount of time
//
// Allegiance System Variables
// We have 3 variables that determine behavior on a monster.
// Alignment, Temperament, and Vulnerability
//
// All 3 can be changed by the mapper per monster.
// All monsters default to 0 for all 3, which is Evil Angry Normal.
// Monsters now look for any other monster or player, not just players.
//=============================================================================

// All 3 are integers with the following ranges:

// Alignment (0 - 2)
float EVIL = 0; // (Default) - Typical bad monsters
float GOOD = 1; // Players are always good, useful for player allies
float NEUTRAL = 2; // Doesn't mind good or evil characters so long as they aren't hurt by them.  Neutral is what AD's passive is

// Temperament (0 - 4)
float TEMPRA_ANGRY = 0; // Default - Will attack on sight, or even just hearing fights nearby
float TEMPRA_COWARDLY = 1; // Will flee away unless cornered, with slight chance of fighting back when not cornered
float TEMPRA_PASSIVE = 2; // Will not respond if others are getting attacked.  Only respond and get angry if attacked directly.
float TEMPRA_CALM = 3; // Will attack on sight, will follow leaders. Forgetful
float TEMPRA_PSYCHOTIC = 4; // Attacks friends if they hit us

// Vulnerability (0 - 3)
//	- 0 Normal (Default)
//	- 1 Resistant
//	- 2 Seraphic
//	- 3 Undead
float VULN_NORMAL = 0;
float VULN_RESISTANT = 1;
float VULN_SERAPHIC = 2;
float VULN_UNDEAD = 3;

// The combination of these variables results in the following actions:
//	- Assault (Default) - attack! and chase
//	- Relax - keep doing what we were doing (walking, standing)
//	- Follow - follow the seen, if leader, else Relax
//	- Retreat - flee away
// These are merely conceptual.  The code names and handles these differently all over.

.float alignment;
.float temperament;
.float vulnerability;
//.float classgroup; Defined elsewhere
.float leader; // manual trick
.float calm_memory_finished;
.float passive_state; // Passive monster state 0=OFF, 1=ON, -1=NOT SET
					  // This is the AD system and it meshes with temperament.

float(entity decider, entity targ) Align_Match = { // [FUNCTION]
	if (!decider || !targ) return FALSE; // Can't match world.
    if (decider == targ) return TRUE; // we are ourself
	return (decider.alignment == targ.alignment);
};

float(entity targ) IsInsane = { // [FUNCTION]
	return (targ.temperament == TEMPRA_PSYCHOTIC || targ.ryuflags & RYU_INSANE);
};

float(entity targ) IsLoyal = { // [FUNCTION]
	return (targ.temperament == TEMPRA_COWARDLY || targ.temperament == TEMPRA_CALM || targ.relations >= 3);
};

float(entity decider, entity targ) Align_Opposing = { // [FUNCTION]
	if (!decider || !targ) return FALSE; // Can't oppose world.
    if (decider == targ) return TRUE; // we are ourself
	if (decider.alignment == NEUTRAL || targ.alignment == NEUTRAL) return FALSE;
	if (decider.alignment == GOOD && targ.alignment == EVIL) return TRUE;
	if (decider.alignment == EVIL && targ.alignment == GOOD) return TRUE;
	return FALSE;
};

float(entity decider, entity targ) Classgroup_Match = { // [FUNCTION]
	if (!decider || !targ) return FALSE; // Can't match world.
    if (decider == targ) return TRUE; // we are ourself
	return (decider.classgroup == targ.classgroup);
};

//  True if two entities are allies or at least non-hostile to each other.
float(entity decider, entity targ) Align_NonHostile = { // [FUNCTION]
    local entity pat;

	if (Align_Match(decider, targ) && !(IsInsane(decider))) return TRUE; // Same team
	if (decider.flags & FL_MONSTER){
		if (decider.enemy == targ) return FALSE;
		if (targ.enemy == decider) return FALSE;
	}
    return FALSE; // Not allies if either side is the world or other non-creature hazard.
};

float(entity targ, entity attacker) Ally_Check = { return Align_NonHostile(attacker, targ); };  // [FUNCTION], Drake compat, flipped inputs.

float(entity targ, entity attacker, float dmg, float touch) Align_DamageModifier = { // [FUNCTION]
	if (targ.vulnerability == VULN_SERAPHIC) return FALSE;  // No damage!

	if (Align_Match(attacker, targ) || touch) {
		if (targ.vulnerability == VULN_RESISTANT) return dmg * 0.5; // 50%
		if (targ.vulnerability == VULN_UNDEAD) {
			if (targ.classgroup == attacker.classgroup || attacker.classgroup == CG_ZOMBIE) {
				return FALSE; // No damage!
			} else {
				return dmg * 0.5; // 50%
			}
		}
	}
	return dmg; // VULN_NORMAL
};

float(entity targ) IsLeader = { // [FUNCTION]
	if (targ.leader) return TRUE; // Manual override
	if (targ.flags & FL_CLIENT) return TRUE;
	if (targ.classgroup == CG_DRAGON || targ.classgroup == CG_HARMLESS) return FALSE; // Can't follow dragons or denizens
	if (targ.bossflag) return TRUE;
	if (targ.classgroup == CG_DCAPTAIN || targ.classgroup == CG_BOSS) return TRUE;
	return FALSE;
};

void(entity tag) SetDefaultDenizenAttributes = { // [FUNCTION]
	if (!self.alignment) {
		self.alignment = NEUTRAL;
		self.gibhealth = MON_NEVERGIB;
	}
	if (!self.passive_state) self.passive_state = 1;
	if (!self.temperament) self.temperament = TEMPRA_PASSIVE;
	if (!self.vulnerability) self.vulnerability = VULN_RESISTANT;
};
//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
//
// Attributions: Arcane Dimensions (AD)
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
// Function count: 8
//
// Implements: Passive State System for denizens and friendly-ish monsters
//
// Description:
// Handles changing passive state switching, calming down, and checks if
// passive is possible.
//=============================================================================

.float		passive_mode;		// A monster with passive abilities
.float		passive_timer;		// When was the last time monster saw enemy?
.float		passive_resettimer;	// Time after not seeing enemy will reset
.float		passive_resethp;	// Reset HP when passive mode activated
.entity		passive_activator;	// The entity which triggered the event
.string		passive_eventon;	// Event trigger to fire when passive on
.string		passive_eventoff;	// Event trigger to fire when passive off

float MON_PASSIVESTATE_NEVER = -1;	// Never use passive system
float MON_PASSIVESTATE_OFF = 0;		// Passive state back to normal
float MON_PASSIVESTATE_ON = 1;		// Passive mode active
float MON_PASSIVESTATE_TOGGLE = 2;	// Toggle states (0>1 1>0)
float MON_PASSIVESTATE_RESET = 5;	// Going back to Passive mode

// TRUE = gets angry, don't get passive.  FALSE = we can be passive.
float(entity targ) check_passivestate_exception = {
	if (!(targ.flags & FL_MONSTER)) return TRUE;
	if (targ.health < 1) return TRUE;
	if (targ.spawnflags & MON_SPAWN_ANGRY) return TRUE;
	if (targ.passive_state == MON_PASSIVESTATE_NEVER) return TRUE;
	if (IsInsane(targ)) return TRUE;
	if (targ.ryuflags & RYU_FORCED) return TRUE; // Player made me shoot
	if (targ.alignment == GOOD) return TRUE; // already good, don't get lukewarm about it
	return FALSE;
};

// Make sure the passive mode flag is active and setup some defaults
void(entity targ) setup_passivestate = {
	if (check_passivestate_exception(targ)) return;
	
	// Check map worldspawn and monster for passive states.  Setup all default parameters for passive monsters
	if (map_passivestate || targ.passive_state == MON_PASSIVESTATE_ON || targ.ryuflags & RYU_CALM) {
		targ.passive_mode = TRUE;
		if (targ.alignment == EVIL) targ.alignment = NEUTRAL; // don't affect good monsters
		targ.passive_state = MON_PASSIVESTATE_ON;
		if (!targ.temperament) targ.temperament = TEMPRA_PASSIVE;
		if (targ.passive_resettimer < 0.05) targ.passive_resettimer = LARGE_TIMER;
		if (!targ.passive_resethp) targ.passive_resethp = FALSE;
	}
};

// Fire event trigger strings (empty check done in trigger_strs function)
void(entity targ) trigger_passivestate_event = {
	if (targ.passive_eventon != "" && targ.passive_state == MON_PASSIVESTATE_ON)
		trigger_strs(targ.passive_eventon, world);
	else if (targ.passive_eventoff != "" && targ.passive_state == MON_PASSIVESTATE_OFF)
		trigger_strs(targ.passive_eventoff, world);
};

// Decide if the passive monster can switch to aggressive state.  Return TRUE if need to stay passive, FALSE to carry on with changing to angry
float(entity targ) check_passivestate_switch = {
	if (targ.passive_state == MON_PASSIVESTATE_ON) {
		// Check for ambush flag exception, and that we aren't cowardly or passive temperament
		// if (sight_entity_time >= time - 0.1 && !(targ.spawnflags & MON_AMBUSH) && self.temperament != TEMPRA_PASSIVE && self.temperament != TEMPRA_COWARDLY) {
			// targ.passive_state = MON_PASSIVESTATE_OFF; // Get angry!
		// } else {
		if (IsInsane(self) || !(targ.spawnflags & MON_AMBUSH)) {
			targ.passive_state = MON_PASSIVESTATE_OFF; // Get angry!
		} else {
			if (!targ.enemy) {
				return TRUE; // Only join in combat if attacked directly (enemy active)
			} else {
				if (targ.enemy.flags & FL_MONSTER || targ.enemy.flags & FL_CLIENT) {
					targ.passive_state = MON_PASSIVESTATE_OFF; // If passive mode active, turn it off. No longer needed
					return FALSE;
				} else {
					return TRUE;
				}
			}
		}
	}
	return FALSE;
};

// Check if the monster is going back to passive mode
float(entity targ) check_passivestate_system = {
	if (check_passivestate_exception(targ)) return FALSE;

	// Check for enemy sight timer
	if (targ.passive_state == MON_PASSIVESTATE_ON) {
		// Reset timer if monster can see enemy
		if (enemy_vis) targ.passive_timer = time + targ.passive_resettimer;
		
		// If timer has expired, use reset function
		if (time > targ.passive_timer) targ.passive_state = MON_PASSIVESTATE_RESET;
	}

	// Check for monsters going back into passive state
	if (targ.passive_state == MON_PASSIVESTATE_RESET) {
		// Switch back to passive mode
		targ.passive_state = MON_PASSIVESTATE_ON;
		// Check for HP reset
		if (targ.passive_resethp) {
			dprint("\b[MONSTER]\b Passive HP reset!\n");
			targ.health = targ.max_health;
		}
		// Check for any turning on triggers
		trigger_passivestate_event(targ);
		
		// Disable the tether system with the tetherlock key otherwise the monster cannot return to patrols
		targ.tetherlock = FALSE;

		// Remove any enemy target system if active
		SUB_removeEnemyTarget(targ);
		targ.enemy = targ.goalentity = targ.movetarget = world;
		// Check for any targets before combat
		if (targ.target != "") targ.movetarget = find(world, targetname, targ.target); // Not used for entity I/O, no need to check other targets
		
		// Check for path corners (patrols) and return to stand/walk
		if (targ.movetarget.classtype == CT_PATHCORNER) {
			targ.goalentity = targ.movetarget;
			targ.think = targ.th_walk;
		} else targ.think = targ.th_stand;
		return TRUE;
	}
	return FALSE;
};

void(entity targ, float targstate) change_passivestate = {
	// Check for system exceptions
	if (check_passivestate_exception(targ)) return;
	
	// Check to see if monster is in combat (got an enemy)
	// - Need special state for this to happen correctly
	// - The exit from combat has to be done elsewhere (ai_run)
	if (targ.enemy) 
		targ.passive_state = MON_PASSIVESTATE_RESET;
	else {
		// check for toggle function first
		if (targstate == MON_PASSIVESTATE_TOGGLE) {
			// Very clumsy way to toggle states
			if (targ.passive_state == MON_PASSIVESTATE_OFF) 
				targ.passive_state = MON_PASSIVESTATE_ON;
			else targ.passive_state = MON_PASSIVESTATE_OFF;
		}
		else if (targstate == MON_PASSIVESTATE_OFF)
			targ.passive_state = MON_PASSIVESTATE_OFF;
		else if (targstate == MON_PASSIVESTATE_ON) 
			targ.passive_state = MON_PASSIVESTATE_ON;
		// State wrong, exit
		else return;

		// Check for any turning on/off triggers
		trigger_passivestate_event(targ);				
	}
};

//======================================================================
/*QUAKED trigger_monsterpassivestate (0.5 0 0.5) (-8 -8 -16) (8 8 16) x
Change the monster passive state
-------- KEYS --------
targetname : trigger entity (works with entity state system)
target  : this points to the monster(s) to affect
state   : 1 = ON, 0 = OFF, -1 = TOGGLE
wait    : -1 = trigger once only
-------- SPAWNFLAGS --------
-------- NOTES --------
Change the monster passive state
======================================================================*/
void() trigger_monsterpassivestate_use = {
	if (self.estate & ESTATE_BLOCK) return;

	// Loop around target(s) and update move speed
	self.enemy = find (world, targetname, self.target);
	while(self.enemy) {
		// All error checks in function
		change_passivestate(self.enemy, self.state);
		// Are there anymore targets left in the list?
		self.enemy = find (self.enemy, targetname, self.target);
	} 
	
	// Trigger once functionality?
	if (self.wait < 0) self.estate = ESTATE_OFF;
};

void() trigger_monsterpassivestate = {
	self.classtype = CT_TRIGMONATTACK;
	if (SUB_HideIfNoTarget()) return;
	
	if (self.state < -1 || self.state > 1) self.state = 0; // make sure state has the correct values
	if (check_nightmare() == TRUE) return; // Check for firing conditions (nightmare, coop)
	if (check_coop() == TRUE) return;

	if (self.targetname != "") self.use = entity_state_use; // Setup Entity State functionality
	self.estate_use = trigger_monsterpassivestate_use;
	self.estate = ESTATE_ON;
};

void() UpdateCharmerGoal = {
   local entity targ;
   local vector d;

   d = normalize ((self.origin - self.charmer.origin));
   if ( (self.huntingcharmer == TRUE) ) {
      targ = spawn();
      self.trigger_field = targ;
      setorigin (targ,self.charmer.origin);
      self.huntingcharmer = FL_SWIM;
      self.goalentity = targ;
   }
   if ( (self.huntingcharmer == FL_SWIM) ) {
      targ = self.trigger_field;
      traceline (self.origin,self.charmer.origin,TRUE,self);
      if ( (trace_fraction == TRUE) ) setorigin (targ,self.charmer.origin);
   } else {
      targ = self.trigger_field;
      setorigin (targ,(self.charmer.origin + (d * 300)));
   }
};

void() HuntCharmer = {
   self.huntingcharmer = TRUE;
   UpdateCharmerGoal();
   if (self.th_walk) self.think = self.th_walk;
	else self.think = SUB_Null;
   self.ideal_yaw = vectoyaw ((self.goalentity.origin - self.origin));
   self.nextthink = (time + 0.100);
};

void() FleeCharmer = {
   self.huntingcharmer = TRUE;
   UpdateCharmerGoal();
   self.huntingcharmer = MOVETYPE_WALK;
   if (self.th_walk) self.think = self.th_walk;
	else self.think = SUB_Null;
   self.nextthink = (time + 0.100);
};

void() StopHuntingCharmer = {
   self.goalentity = world;
   if ( (self.huntingcharmer > TRUE) ) remove (self.trigger_field);
   self.huntingcharmer = FALSE;
   if (self.th_stand) self.think = self.th_stand;
	else self.think = SUB_Null;
   self.nextthink = (time + 0.100);
};
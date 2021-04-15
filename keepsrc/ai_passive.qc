//======================================================================
// AI Passive mode functions
// * Ideal for NPC style monsters
//=====================================================================
.float		passive_mode;		// A monster with passive abilities
.float		passive_state;		// Passive monster state 0=OFF, 1=ON, -1=NOT SET
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

// Check exceptions and return true if found one
float(entity targ) check_passivestate_exception = {
	if (!(targ.flags & FL_MONSTER)) return TRUE;
	if (targ.health < 1) return TRUE;
	if (targ.spawnflags & MON_SPAWN_ANGRY) return TRUE;
	if (targ.passive_state == MON_PASSIVESTATE_NEVER) return TRUE;
	if (targ.temperament == 4) return TRUE; // PSYCHOTIC!
	if (targ.ryuflags & RYU_INSANE) return TRUE; // PSYCHOTIC!
	if (targ.ryuflags & RYU_FORCED) return TRUE; // Player made me shoot
	return FALSE;
};

// Make sure the passive mode flag is active and setup some defaults
void(entity targ) setup_passivestate = {
	// Check for system exceptions
	if (check_passivestate_exception(targ)) return;
	
	// Check map worldspawn and monster for passive states
	// Setup all default parameters for passive monsters
	if (map_passivestate || targ.passive_state == MON_PASSIVESTATE_ON || targ.ryuflags & RYU_CALM) {
		targ.passive_mode = TRUE;
		targ.passive_state = MON_PASSIVESTATE_ON;
		if (targ.passive_resettimer < 1) targ.passive_resettimer = LARGE_TIMER;
		if (!targ.passive_resethp) targ.passive_resethp = FALSE;
	}
};

// Check for passive state on bosses
void(entity targ) setup_passivestate_boss = { setup_passivestate(targ); };

//----------------------------------------------------------------------
// Fire event trigger strings (empty check done in trigger_strs function)
void(entity targ) trigger_passivestate_event = {
	if (targ.passive_eventon != "" && targ.passive_state == MON_PASSIVESTATE_ON)
		trigger_strs(targ.passive_eventon, world);
	else if (targ.passive_eventoff != "" && targ.passive_state == MON_PASSIVESTATE_OFF)
		trigger_strs(targ.passive_eventoff, world);
};

//----------------------------------------------------------------------
// Decide if the passive monster can switch to aggressive state
// Return TRUE if need to stay passive, FALSE to carry on with changing to angry
float(entity targ) check_passivestate_switch = {
	// Is the monster in passive mode?
	if (targ.passive_state == MON_PASSIVESTATE_ON) {
		// Check for ambush flag exception, and that we aren't cowardly or passive temperament
		if (sight_entity_time >= time - 0.1 && !(targ.spawnflags & MON_AMBUSH) && self.temperament != 2 && self.temperament != 1) {
			targ.passive_state = MON_PASSIVESTATE_OFF; // Get angry!
		} else {
			if (!targ.enemy) return TRUE; // Only join in combat if attacked directly (enemy active)
			else targ.passive_state = MON_PASSIVESTATE_OFF; // If passive mode active, turn it off. No longer needed
		}
	}
	return FALSE;
}

// Check if the monster is going back to passive mode
float(entity targ) check_passivestate_system = {
	if (check_passivestate_exception(targ)) return FALSE;

	// Check for enemy sight timer
	if (targ.passive_state == MON_PASSIVESTATE_ON) {
		// Reset timer if monster can see enemy
		if (enemy_vis) targ.passive_timer = time + targ.passive_resettimer;
		// If timer has expired, use reset function
		if (time > targ.passive_timer)
			targ.passive_state = MON_PASSIVESTATE_RESET;
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
		
		// Disable the tether system with the tetherlock key
		// otherwise the monster cannot return to patrols
		targ.tetherlock = FALSE;

		// Remove any enemy target system if active
		SUB_removeEnemyTarget(targ);
		targ.enemy = targ.goalentity = targ.movetarget = world;
		// Check for any targets before combat
		if (targ.target != "") 
			targ.movetarget = find(world, targetname, targ.target);
		// Check for path corners (patrols) and return to stand/walk
		if (targ.movetarget.classtype == CT_PATHCORNER) {
			targ.goalentity = targ.movetarget;
			targ.think = targ.th_walk;
		}
		else targ.think = targ.th_stand;
		return TRUE;
	}
	return FALSE;
};

//----------------------------------------------------------------------
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
void() trigger_monsterpassivestate_use =
{
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

//----------------------------------------------------------------------
void() trigger_monsterpassivestate = {
	self.classtype = CT_TRIGMONATTACK;
	if (self.target == "") {
		dprint("\b[MON_PASSIVESTATE]\b No target set, removing\n");
		remove(self);
	}
	
	// make sure state has the correct values
	if (self.state < -1 || self.state > 1) self.state = 0;

	// Check for firing conditions (nightmare, coop)
	if (check_nightmare() == TRUE) return;
	if (check_coop() == TRUE) return;

	// Setup Entity State functionality
	if (self.targetname != "") self.use = entity_state_use;
	self.estate_use = trigger_monsterpassivestate_use;
	self.estate = ESTATE_ON;
};
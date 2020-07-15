/*======================================================================
 AI Passive mode functions
 * Ideal for NPC style monsters
=====================================================================*/
.float		passive_mode;		// A monster with passive abilities
.float		passive_state;		// Passive monster state 0=OFF or 1=ON
.float		passive_timer;		// When was the last time monster saw enemy?
.float		passive_resettimer;	// Time after not seeing enemy will reset
.float		passive_resethp;	// Reset HP when passive mode activated
.entity		passive_activator;	// The entity which triggered the event
.string		passive_eventon;	// Event trigger to fire when passive on
.string		passive_eventoff;	// Event trigger to fire when passive off

float MON_PASSIVESTATE_OFF = 0;		// Passive state back to normal
float MON_PASSIVESTATE_ON = 1;		// Passive mode active
float MON_PASSIVESTATE_RESET = 2;	// Going back to Passive mode

//----------------------------------------------------------------------
// Check for passive system exceptions
void(entity targ) check_passivestate_exception =
{
	// Boss monsters cannot use the passive system
	if (targ.bossflag) targ.passive_state = MON_PASSIVESTATE_OFF;
};

//----------------------------------------------------------------------
// Make sure the passive mode flag is active and setup some defaults
void(entity targ) setup_passivemode =
{
	if (targ.passive_state == MON_PASSIVESTATE_ON) {
		targ.passive_mode = TRUE;
		if (targ.passive_resettimer < 1) targ.passive_resettimer = LARGE_TIMER;
		if (!targ.passive_resethp) targ.passive_resethp = FALSE;
	}
};

//----------------------------------------------------------------------
// Fire event trigger strings (empty check done in trigger_strs function)
void(entity targ) trigger_passivestate_event =
{
//	if (targ.passive_state == MON_PASSIVESTATE_ON)
//		trigger_strs(targ.passive_eventon, world);
//	else if (targ.passive_state == MON_PASSIVESTATE_OFF)
//		trigger_strs(targ.passive_eventoff, world);
};

//----------------------------------------------------------------------
// Decide if the passive monster can switch to aggressive state
// Return TRUE if need to exit, FALSE to carry on with function
float() check_passivestate_switch =
{
	// Is the monster in passive mode?
	if (self.passive_state == MON_PASSIVESTATE_ON) {
		// Check for ambush flag exception
		if (sight_entity_time >= time - 0.1 && !(self.spawnflags & MON_AMBUSH) )
			self.passive_state = MON_PASSIVESTATE_OFF;
		else {
			// Only join in combat if attacked directly (enemy active)
			if (!self.enemy) return TRUE;
			// If passive mode active, turn it off. No longer needed
			else self.passive_state = MON_PASSIVESTATE_OFF;
		}
	}
	return FALSE;
}

//----------------------------------------------------------------------
// Check if the monster is going back to passive mode
float() check_passivestate_system =
{
	// Make sure this only works with living monsters
	if (!(self.flags & FL_MONSTER) || self.health < 1) {
		self.passive_state = MON_PASSIVESTATE_OFF;
		return FALSE;
	}

	// Check for enemy sight timer
	if (self.passive_state == MON_PASSIVESTATE_ON) {
		// Reset timer if monster can see enemy
		if (enemy_vis) self.passive_timer = time + self.passive_resettimer;
		// If timer has expired, use reset function
		if (time > self.passive_timer)
			self.passive_state = MON_PASSIVESTATE_RESET;
	}

	// Check for monsters going back into passive state
	if (self.passive_state == MON_PASSIVESTATE_RESET) {
		// Switch back to passive mode
		self.passive_state = MON_PASSIVESTATE_ON;
		// Check for HP reset
		if (self.passive_resethp) {
			dprint("\b[MONSTER]\b Passive HP reset!\n");
			self.health = self.max_health;
		}
		// Check for any turning on triggers
		trigger_passivestate_event(self);
		
		// Disable the tether system with the tetherlock key
		// otherwise the monster cannot return to patrols
		self.tetherlock = FALSE;

		// Remove any enemy target system if active
		SUB_removeEnemyTarget();
		self.enemy = self.goalentity = self.movetarget = world;
		// Check for any targets before combat
		if (self.target != "") 
			self.movetarget = find(world, targetname, self.target);
		// Check for path corners (patrols) and return to stand/walk
		if (self.movetarget.classtype == CT_PATHCORNER) {
			self.goalentity = self.movetarget;
			self.think = self.th_walk;
		}
		else self.think = self.th_stand;
		return TRUE;
	}
	return FALSE;
};

/*======================================================================
/*QUAKED trigger_monsterpassivestate (0.5 0 0.5) (-8 -8 -16) (8 8 16) x
Change the monster passive state
-------- KEYS --------
targetname : trigger entity (works with entity state system)
target  : this points to the monster(s) to affect
state   : 0 = ON, 1 = OFF, -1 = TOGGLE
wait    : -1 = trigger once only
-------- SPAWNFLAGS --------
-------- NOTES --------
Change the monster passive state

======================================================================*/
void() trigger_monsterpassivestate_use =
{
	if (self.estate & ESTATE_BLOCK) return;
	// Cannot use passive mode with boss monsters
	// They have their own special behaviour already
	if (self.bossflag) return;

	// Loop around target(s) and update move speed
	self.enemy = find (world, targetname, self.target);
	while(self.enemy) {
		// only work with living monsters (ignore rest)
		if (self.enemy.flags & FL_MONSTER && self.enemy.health > 0) {
			// Add (defaults) extra variables
			setup_passivemode(self.enemy);
			// Check to see if monster is in combat (got an enemy)
			// - Need special state for this to happen correctly
			// - The exit from combat has to be done elsewhere (ai_run)
			if (self.enemy.enemy) 
				self.enemy.passive_state = MON_PASSIVESTATE_RESET;
			else {
				// check for toggle function first
				if (self.state < 0) {
					// Very clumsy way to toggle states
					if (self.enemy.passive_state == MON_PASSIVESTATE_OFF) 
						self.enemy.passive_state = MON_PASSIVESTATE_ON;
					else 
						self.enemy.passive_state = MON_PASSIVESTATE_OFF;
				}
				// Update the attack state (always overwrite)
				else self.enemy.passive_state = self.state;
				// Check for any turning on triggers
				trigger_passivestate_event(self.enemy);				
			}
		}
		// Are there anymore targets left in the list?
		self.enemy = find (self.enemy, targetname, self.target);
	} 
	
	// Trigger once functionality?
	if (self.wait < 0) self.estate = ESTATE_OFF;
};

//----------------------------------------------------------------------
void() trigger_monsterpassivestate =
{
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


/*
This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by the
Free Software Foundation; either version 2 of the License, or (at your
option) any later version.

This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software Foundation,
Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
*/

/*
	Written by Frank Condello <pox@planetquake.com>
	
	func_train_ext can have certain "children" objects that tag along,
	can change direction, or stop/resume at any time.
	
	These use "smart" waypoints and trigger relays that actually control most
	aspects of the train, but a simple train can still be setup by ignoring
	extra options.
	
	The last waypoint does not need a target. The train will either
	auto-reverse (if set) or wait for manual reverse/move triggers.	
*/
 
//============================================================================
 
float FORWARD = 0;
float REVERSE = 1;

float ALLOWPAUSE = 2;		// Triggers start/stop the train
float ALLOWCHANGEDIR = 4;	// Changedir triggers reverse direction
float AUTOREVERSE = 8;		// Reverse direction at endpoints
float BLOCKREVERSE = 16;	// Reverse direction if blocked
float STARTREVERSE = 32;	// Start in reverse

float FREEMOVE = 0;// Not at an endpoint (can move either way)
float RIGHTWAY = 1;// At an endpoint, and direction leads away (can move)
float WRONGWAY = 2;// At an endpoint, but direction leads into endpoint (can't move)

.entity next, previous, child;

//============================================================================

// QUAKED trigger_changedir (.5 .5 .5) (-8 -8 -8) (8 8 8) ?
// Causes func_train_ext and func_watertrain to change directions if ALLOWCHANGEDIR is
// set, or reverses the spin of func_emitter and func_emitter_volume. If the target is
// moving, it continues in opposite direction, if the target is stopped, it will move
// in opposite direction on the next movement trigger.


void() trigger_changedir =
{
	self.classname = "t_changedir";
	self.use = SUB_UseTargets;
};

// QUAKED trigger_forward (.5 .5 .5) (-8 -8 -8) (8 8 8) ?
// Causes func_train_ext and func_watertrain to move forward. It automatically changes
// direction if going the wrong way. Direction changes are made regardless if ALLOWCHANGEDIR
// is set or not.  It will also cause func_emitter and func_emitter_volume with avelocity
// to spin in the forward direction. This trigger will start motion if the target is stopped,
// but will never stop it.

void() trigger_forward =
{
	self.classname = "t_forward";
	self.use = SUB_UseTargets;
};

// QUAKED trigger_reverse (.5 .5 .5) (-8 -8 -8) (8 8 8) ?
// Causes func_train_ext and func_watertrain to move in reverse. It automatically changes
// direction if going the wrong way. Direction changes are made regardless if ALLOWCHANGEDIR
// is set or not. It will also cause func_emitter and func_emitter_volume with avelocity
// to spin in the reverse direction. This trigger will start motion if the target is stopped,
// but will never stop it.


void() trigger_reverse =
{
	self.classname = "t_reverse";
	self.use = SUB_UseTargets;
};

// QUAKED trigger_stop (.5 .5 .5) (-8 -8 -8) (8 8 8) ?
// Causes func_train_ext and func_watertrain to stop, or func_emitter and func_emitter_volume
// with avelocity to stop rotating. If the target is already stopped, this trigger is ignored.


void() trigger_stop =
{
	self.classname = "t_stop";
	self.use = SUB_UseTargets;
};

// QUAKED trigger_go (.5 .5 .5) (-8 -8 -8) (8 8 8) ?
// Causes func_train_ext and func_watertrain to start moving, or func_emitter and func_emitter_volume
// with avelocity to start rotating. If the target is already moving, this trigger is ignored.


void() trigger_go =
{
	self.classname = "t_go";
	self.use = SUB_UseTargets;
};

//============================================================================

// QUAKED train_ext_waypoint (0 .5 .8) (-8 -8 -8) (8 8 8) ?
// func_train_ext is "dumb" on it's own these entities really control the train.
// Used for func_watertrain as well.

// "speed"			Forward speed from this waypoint to the next (-1 is warp to next waypoint)
// "wait"			Time to pause at this waypoint when moving forward (-1 is wait for re-trigger, 0 is no pause)
// "noise" 		Override train's start/travel noise from this waypoint to the next when moving forward
// "noise1"		Override train's stop noise at this waypoint when moving forward (or between this waypoint and the next) 
// "event"			Targetname of entity to fire when the train hits this point when moving forward

// "speed2"		Reverse speed from this waypoint to the previous in (-1 is warp to previous)
// "wait2"			Time to pause at this waypoint when moving in reverse (-1 is wait for re-trigger, 0 is no pause)
// "noise2" 		Overrid etrain's start/travel noise from this waypoint to the previous when moving in reverse
// "noise3"		Override train's stop noise at this waypoint when moving in reverse (or between this waypoint to the previous)
// "event2"		Targetname of entity to fire when the train hits this point when moving in reverse

// "targetname"	This waypoint's name
// "target"		Name of the next waypoint

// NOTES:

// Always use unique sets of train_ext_waypoint for func_train_ext and func_watertrain.
// The waypoints are linked with one another and can only work with one train at a time.

// Speed propogates from waypoint to waypoint (if it's not set, the last speed is used).
// The first waypoint can also simply use the train's "speed" if set.

// If the reverse speed/event are not set, the forward direction speed/event are used.
// Reverse sounds default to the train's sounds if they are not set. (This only matters
// for trains that can go in reverse of course).


void() train_ext_waypoint =
{
	if (!self.targetname) objerror ("train_ext_waypoint: no targetname");
	
	if (self.wait < -1) self.wait = -1;
	if (self.speed < -1) self.speed = -1;
	if (self.noise) precache_sound(self.noise);
	if (self.noise1) precache_sound(self.noise1);
	
	// Set defaults for reverse direction
	if (self.wait2 < -1) self.wait2 = -1;
	if (self.speed2 < -1) self.speed2 = -1;
	if (!self.speed2 && self.speed) self.speed2 = self.speed;
	if (!self.event2 && self.event != string_null) self.event2 = self.event;
	if (self.noise2) precache_sound(self.noise2);
	if (self.noise3) precache_sound(self.noise3);
	
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_NONE;
	self.classname = "train_waypoint";
};

//============================================================================


// =============
// train_ext_linkchild

// Saves a list of child objects (parent.child.child.child...etc.).
// Always call this on frame 2 to ensure the train has spawned.
// NOTE: I've given up on solid children - too many tracking/blocking issues
// ==============

void() train_ext_linkchild =
{
	local entity	parent;
	
	// Find the parent train
	parent = find (world, targetname, self.target);
	if (parent.classname != "train_ext")
		objerror ("train_ext_linkchild: target is not a func_train_ext");

	// Set the train as this ent's owner
	self.owner = parent;
	
	// Copy off any other children
	if (parent.child) self.child = parent.child;
	
	// Make this ent a child
	parent.child = self;
	
	// Set start position
	setorigin (self, self.owner.origin);
};

//============================================================================

void() train_ext_next;
void() train_ext_previous;
void() train_ext_init;
void() train_ext_wait;
void() train_ext_use;

void() train_ext_playstopsound =
{
	local entity cchain;
	
	sound (self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
	
	// play child sounds
	if (!self.cshift) {
		cchain = self.child;
		while(cchain) {	
			if (cchain.cshift)// func_watertrain
				if (cchain.noise1)
					sound (cchain, CHAN_VOICE, cchain.noise1, 1, ATTN_NORM);	
			cchain = cchain.child;
		}
	}
};

void() train_ext_playtravelsound =
{
	local entity cchain;
	
	sound (self, CHAN_VOICE, self.noise2, 1, ATTN_NORM);
	
	// play child sounds
	if (!self.cshift) {
		cchain = self.child;
		while(cchain) {	
			if (cchain.cshift)// func_watertrain
				if (cchain.noise)
					sound (cchain, CHAN_VOICE, cchain.noise, 1, ATTN_NORM);	
			cchain = cchain.child;
		}
	}
};

void() train_ext_playchangedirsound = // Doesn't mute CHAN_VOICE
{
	local entity cchain;
	
	if (self.noise4) sound (self, CHAN_BODY, self.noise4, 1, ATTN_NORM);
	
	// play child sounds
	if (!self.cshift) {
		cchain = self.child;
		while(cchain) {
			if (cchain.cshift)// func_watertrain
				if (cchain.noise4)
					sound (cchain, CHAN_BODY, cchain.noise4, 1, ATTN_NORM);	
			cchain = cchain.child;
		}
	}
};

void() train_ext_playwrongwaysound =
{
	local entity cchain;
	
	if (self.noise5) sound (self, CHAN_VOICE, self.noise5, 1, ATTN_NORM);
	
	// play child sounds
	if (!self.cshift) {
		cchain = self.child;
		while(cchain) {
			if (cchain.cshift)// func_watertrain
				if (cchain.noise5)
					sound (cchain, CHAN_VOICE, cchain.noise5, 1, ATTN_NORM);	
			cchain = cchain.child;
		}
	}
};

void() train_ext_blocked =
{
	if (time < self.attack_finished) return;
	
	self.attack_finished = time + 0.5;
	T_Damage (other, self, self, self.dmg,DAMARMOR);
	
	// Change direction
	if (self.spawnflags & BLOCKREVERSE && self.deadflag == FREEMOVE) {
		if (self.state == REVERSE) {
			self.state = FORWARD;
			train_ext_next();
		} else {
			self.state = REVERSE;
			train_ext_previous();
		}
	}
};

void() train_ext_move =
{
	local entity cchain;
	
	// Warp to next waypoint
	if (self.speed == -1) {	
		setorigin (self, self.dest-self.mins);
		self.nextthink = self.ltime + 0.001;
	// Move to next waypoint
	} else {		
		train_ext_playtravelsound();
		if (self.cshift)// independant func_watertrain
			SUB_fCalcMove (self.dest-self.mins, self.speed, self.think);
		else
			SUB_CalcMove (self.dest-self.mins, self.speed, self.think);
	}
	
	// Update children
	if (!self.cshift) {// func_watertrain can't have children
		cchain = self.child;
		while(cchain) {
			if (self.speed == -1)
				setorigin (cchain, self.dest-self.mins);
			else 
				cchain.fmover = "moving";// SUB_PushFrameMovers takes care of child moves

			cchain = cchain.child;
		}
	}
};

void() train_ext_changedir =
{	
	train_ext_playchangedirsound();
	
	// Change direction	
	if (self.state == REVERSE) {
		self.state = FORWARD;
		self.think = train_ext_next;
	} else {
		self.state = REVERSE;
		self.think = train_ext_previous;
	}
	
	if (self.deadflag == WRONGWAY) {
		self.deadflag = RIGHTWAY;
//dprint("RIGHTWAY - train_ext_changedir\n");
	} else if (self.deadflag == RIGHTWAY) {
		self.deadflag = WRONGWAY;
//dprint("WRONGWAY - train_ext_changedir\n");
	}
};

void() train_ext_goforward =
{
	// Can't move this way
	if (self.deadflag == RIGHTWAY && self.state == REVERSE) {
		train_ext_playwrongwaysound();
		return;
	}
	
	if (self.state == REVERSE)
		train_ext_changedir();
	else if (self.velocity != '0 0 0')
		return;// already moving this way
	
	// Start moving
	train_ext_next();
};

void() train_ext_goreverse =
{
	// Can't move this way
	if (self.deadflag == RIGHTWAY && self.state == FORWARD) {
		train_ext_playwrongwaysound();
		return;
	}
	
	if (self.state == FORWARD)
		train_ext_changedir();
	else if (self.velocity != '0 0 0')
		return;// already moving this way
	
	// Start moving
	train_ext_previous();
};

void() train_ext_atend =
{		
	self.enemy = activator;
	
	// If we're stuck at the end and get a changdir, next use can move
	if (other.classname == "t_changedir") {
		if (self.spawnflags & ALLOWCHANGEDIR) {
			self.use = train_ext_use;
			train_ext_changedir();	
		}
		return;
	}
	else if (other.classname == "t_stop")
		return;// already stopped
	else if (other.classname == "t_forward") {
		self.use = train_ext_use;
		train_ext_goforward();
	} else if (other.classname == "t_reverse") {
		self.use = train_ext_use;
		train_ext_goreverse();
	} else// Trying to move beyond last point
	 	train_ext_playwrongwaysound();
};

void() train_ext_use =
{
	local entity cchain;
	
	if (self.think == train_ext_init) return;
	
	self.enemy = activator;
	
	//	
	// Changedir trigger
	//
	if (other.classname == "t_changedir") {
		
		if (self.spawnflags & ALLOWCHANGEDIR) {
			
			train_ext_changedir();
			
			// If moving, move in new direction right away
			if (self.velocity != '0 0 0') {
				
				if (self.state == REVERSE) {
					train_ext_previous();
				} else {
					train_ext_next();
				}
			}
			else if (self.deadflag == WRONGWAY) {// facing wrong way (can't move)
				self.use = train_ext_atend;
			}
			else {// Change the goal back to next waypoint
				if (self.state == REVERSE) {
					self.goalentity = self.goalentity.next;
				} else {
					self.goalentity = self.goalentity.previous;
				}
			}
		}
		
		return;
	}
	//
	// Move Trigger
	//
	else if (other.classname == "t_forward") {
		train_ext_goforward();
		return;
	}
	else if (other.classname == "t_reverse") {
		train_ext_goreverse();
		return;
	}
	// Moving - stop it (ignore go relays)
	else if ((self.velocity != '0 0 0') && (other.classname != "t_go")) {
		
		if (self.spawnflags & ALLOWPAUSE)
		{			
			train_ext_playstopsound();
			
			// Stop the train where ever it may be
			self.velocity = '0 0 0';
			
			if (!self.cshift) {

				// Stop children
				cchain = self.child;
				while(cchain) {
					cchain.velocity = '0 0 0';					
					cchain = cchain.child;
				}
			}

			self.nextthink = -1;
			self.deadflag = FREEMOVE;
			
			// Change the goal back to next waypoint
			if (self.state == REVERSE) {
				self.goalentity = self.goalentity.next;
			} else {
				self.goalentity = self.goalentity.previous;
			}
		}
		
		return;
	}
	// Stopped - start it back up (ignore stop relays)
	else if (other.classname != "t_stop")
	{	
		if (self.state == REVERSE)
			train_ext_previous();
		else
			train_ext_next();
	}
};

void() train_ext_checkeventstate =
{
	local string	temp;

	// Check if it's *at* the waypoint since it can start/stop inbetween
	if (self.origin == (self.goalentity.origin - self.mins))
	{
		// Fire events at this waypoint
		if (self.event) {
			activator = self.enemy;
			temp = self.target;
			self.target = self.event;
			SUB_UseTargets();
			self.target = temp;
		}
		
		// dprint("FIRE EVENT AT: ");
		// dprint(self.goalentity.targetname);
		// dprint(" : ");
		// dprint(self.event);
		// dprint("\n\n");

		// Check if this is the end of the line
		if (self.goalentity == self.aiment) {
			if (self.spawnflags & AUTOREVERSE && self.deadflag != WRONGWAY) {
				train_ext_playchangedirsound();
				self.deadflag = RIGHTWAY;
//dprint("RIGHTWAY - train_ext_checkeventstate\n");
				if (self.state == FORWARD)
					self.state = REVERSE;
				else
					self.state = FORWARD;
			} else if (self.deadflag == WRONGWAY) {// Trying to move beyond last point	
				train_ext_playwrongwaysound();
			} else {
				train_ext_playstopsound();
				self.deadflag = WRONGWAY;
//dprint("WRONGWAY - train_ext_checkeventstate\n");
				self.use = train_ext_atend;
			}
		} else {
			if (self.deadflag == RIGHTWAY) {
				self.deadflag = FREEMOVE;
//dprint("FREEMOVE - train_ext_checkeventstate\n");
			}
		}
	}
};

void() train_ext_wait =
{
	if (self.think == train_ext_init) return;
	
	if (self.state == REVERSE) {
		self.event = self.goalentity.event2;
		self.aiment = self.goalentity.previous;
		self.think = train_ext_previous;
	} else {
		self.event = self.goalentity.event;
		self.aiment = self.goalentity.next;
		self.think = train_ext_next;
	}
	
	train_ext_checkeventstate();
	
	if (self.wait) {

		train_ext_playstopsound();
		
		if (self.wait != -1) {
			if (!self.cshift)
				self.nextthink = self.ltime + self.wait;
			else
				self.nextthink = time + self.wait;
		}
		
	} else
		objerror ("func_train_ext: Waiting without wait time!");
};

void() train_ext_previous = // Reverse
{
	if (self.think == train_ext_init) return;

	// dprint("FROM:");
	// dprint(self.goalentity.targetname);
	// dprint(" TO:");
	// dprint(self.goalentity.previous.targetname);
	// dprint(" nextwait:");
	// dprint(ftos(self.goalentity.previous.wait2));
	// dprint("\n");

	// Trigger events & check if we can move	
	self.event = self.goalentity.event2;
	self.aiment = self.goalentity.previous;
	train_ext_checkeventstate();

	// Current speed
	self.speed = self.goalentity.speed2;
	
	// Save out the current sound overrides
	if (self.goalentity.noise2)
		self.noise2 = self.goalentity.noise2;
	else
		self.noise2 = self.noise;
	
	if (self.goalentity.noise3)
		self.noise3 = self.goalentity.noise3;
	else
		self.noise3 = self.noise1;
	
	// Get the next waypoint
	self.goalentity = self.goalentity.previous;
	// Save out the destination for this move
	self.dest = self.goalentity.origin;
	// Save the wait for the upcoming waypoint
	self.wait = self.goalentity.wait2;

	// Decide what to do after the move
	self.nextthink = -1;
	if (self.wait)
		self.think = train_ext_wait;
	else if (self.state == REVERSE)
		self.think = train_ext_previous;
	else
		self.think = train_ext_next;
		
	train_ext_move();
};

void() train_ext_next = // Forward
{
	if (self.think == train_ext_init) return;

	// dprint("FROM:");
	// dprint(self.goalentity.targetname);
	// dprint(" TO:");
	// dprint(self.goalentity.next.targetname);
	// dprint(" nextwait:");
	// dprint(ftos(self.goalentity.next.wait));
	// dprint("\n");

	// Trigger events & check if we can move
	self.event = self.goalentity.event;
	self.aiment = self.goalentity.next;
	train_ext_checkeventstate();
	
	// Current speed
	self.speed = self.goalentity.speed;
	
	// Save out the current sound overrides
	if (self.goalentity.noise)
		self.noise2 = self.goalentity.noise;
	else
		self.noise2 = self.noise;
	
	if (self.goalentity.noise1)
		self.noise3 = self.goalentity.noise1;
	else
		self.noise3 = self.noise1;
	
	// Get the next waypoint
	self.goalentity = self.goalentity.next;
	// Save out the destination for this move
	self.dest = self.goalentity.origin;
	// Save the wait for the upcoming waypoint
	self.wait = self.goalentity.wait;
	
	// Decide what to do after the move
	self.nextthink = -1;
	if (self.wait)
		self.think = train_ext_wait;
	else if (self.state == REVERSE)
		self.think = train_ext_previous;
	else
		self.think = train_ext_next;
		
	train_ext_move();
};
	
void() train_ext_init =
{
	local entity	way, stemp, wtemp;
	
	// Find the first waypoint
	way = find (world, targetname, self.target);
	
	// Be strict about this
	if (way.classname != "train_waypoint")
		 objerror ("train_ext_init: illegal target type");
	
	// First waypoint requires speed & target (or else we aint moving!)
	if (!way.target) objerror ("train_ext_init: first waypoint requires target");
	if (!way.speed) way.speed = self.speed;// copy train's speed
	if (!way.speed) objerror ("train_ext_init: first waypoint or train requires speed");
	
	wtemp = way;// Save the first waypoint
	stemp = self;// Save the train
	
	// Link all the waypoints 
	while(way != stemp)
	{	
		if (way.classname != "train_waypoint")
			objerror ("train_ext_init: illegal target type");
		
		self.next = way;
		way.previous = self;
		if (!way.speed) way.speed = self.speed;
		self = way;
		
		// On a non-looped path, "event" can hold an alternate start position
		if (stemp.event) {
			if (stemp.event == self.targetname)
				stemp.goalentity = self;
		}
		
		// Last waypoint doesn't need a target (train will stop/reverse here)
		if (!self.target) {
			self.next = self;// so train_next knows to stop
			wtemp.previous = wtemp;// so train_previous knows to stop
			way = stemp;// break
		}
		// Stop when we hit the first waypoint again (loop)
		else if (self.next == wtemp) {
			wtemp.previous = self;// connect the first waypoint to the last
			way = stemp;// break
		}
		// Get the next target
		else
			way = find(world, targetname, self.target);
	}
		
	// Restore self to the train
	self = stemp;
	
	// Prep goalentity so it points to start position
	if (!self.goalentity) self.goalentity = self.next;
	
	// Position the train at it's first waypoint
	setorigin (self, self.goalentity.origin-self.mins);
	
	// Start it up...
	self.nextthink = -1;
	self.think = train_ext_next;
		
	// Get direction for first move
	if (self.spawnflags & STARTREVERSE)
		self.state = REVERSE;
	else
		self.state = FORWARD;
	
	// Decide if we're facing a good way to start
	if (self.goalentity == self.next) {// At first waypoint

		if (self.state == REVERSE) {
			if (self.goalentity.previous == self.goalentity) {// endpoint - can't move
				self.deadflag = WRONGWAY;
				self.use = train_ext_atend;
			}
		} else
			self.deadflag = RIGHTWAY;


	} else if (self.goalentity.next == self.goalentity) {// At last waypoint
		
		if (self.state == FORWARD) {// have to be in reverse to allow move here
			self.deadflag = WRONGWAY;
			self.use = train_ext_atend;
		} else
			self.deadflag = RIGHTWAY;

	} else // somewhere in the middle
		self.deadflag = FREEMOVE;
	
//	self.velocity = '0 0 0';
	
	if (self.spawnflags & START_ON)
		self.nextthink = self.ltime + time + 0.1;
};

void() train_ext_precachenoise =
{
	if (!self.noise) self.noise = "misc/null.wav";
	if (!self.noise1) self.noise1 = "misc/null.wav";
	if (self.noise4) precache_sound(self.noise4);
	if (self.noise5)
		precache_sound(self.noise5);
	else
		self.noise5 = self.noise1;
	
	precache_sound(self.noise);
	precache_sound(self.noise1);
};

// QUAKED func_train_ext (0 .5 .8) ? START_ON ALLOWPAUSE ALLOWCHANGEDIR AUTOREVERSE BLOCKREVERSE STARTREVERSE

// "speed"			Speed of the train (can be overridden by waypoints)
// "dmg"			amonut of damage to inflict when blocked
// "noise" 		Start/travel noise (can be overridden by waypoints)
// "noise1"		Stop noise (can be overridden by waypoints)
// "noise4"		Noise to make when changing directions (DON'T USE A LOOPED WAV!!)
// "noise5"		Noise to make when trying to go wrong way at end of path (uses "noise1" if not set)
// "target"		First waypoint or start position
// "event"			Start at this waypoint (since you MUST use the first waypoint as the "target" on a non-looped path)
// "targetname" 	can be triggered and/or targeted by child objects

// Spawnflags:

// "START_ON"			Start the train immediately, even if targeted.
// "ALLOWPAUSE"		Re-Triggering will pause/resume the train at any point along it's path.
// "ALLOWCHANGEDIR"	Lets a changedir trigger reverse the train's direction at any time
// "AUTOREVERSE"		Train automatically reverses direction when it hits the last/first waypoint
					// (only makes sense if last waypoint has no target). It will NOT auto-reverse on
					// spawn if facing the wrong way (which is possible and valid).
// "BLOCKREVERSE"		Reverses train direction when blocked (after inflicting damage)
					// Don't use this on trains with non-looped paths without some way of getting it
					// back to the forward direction (AUTOREVERSE or ALLOWCHANGEDIR). Else it'll
					// get stuck when it reaches the start point again.
// "STARTREVERSE"		Start in reverse

// NOTES:

// A train without a targetname will start immediately (doesn't need "START_ON" to be set)
// but it can not be stopped, and can not have children objects.

// If your waypoints are not looped (i.e. the last point doesn't target the first), the train MUST
// target the first waypoint. Use the "event" target to have the train spanw at a different point
// along it's path ("event" is ignored if it's not on the same path.).

// If you have a train on a non looped waypoint path, and AUTOREVERSE is not set, the train will stop
// at the last waypoint. If ALLOWCHANGEDIR is set, and the train gets a t_changerdir trigger, you will
// then be able to re-trigger movement in the reverse direction. Otherwise re-triggering will just
// produce the wrong-way sound.


void() func_train_ext =
{
	if (!self.target) objerror ("func_train_ext without a target");
	if (!self.dmg) self.dmg = 2;
	if (self.speed<-1) self.speed = -1;
	
	train_ext_precachenoise();
	
	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_PUSH;
	self.blocked = train_ext_blocked;
	self.classname = "train_ext";
	setmodel (self, self.model);
	setsize (self, self.mins , self.maxs);
	setorigin (self, self.origin);
	
	// set start flag if not triggered
	if (!self.targetname) self.spawnflags = self.spawnflags | START_ON;
	
	self.use = train_ext_use;
	
	// start trains on the second frame, to make sure their targets have had a chance to spawn
	self.nextthink = self.ltime + 0.1;
	self.think = train_ext_init;
};

//============================================================================

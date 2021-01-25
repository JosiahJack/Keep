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
	
	Moving water volumes - honest and for true.

	Dependant on additions in client.qc.
	Uses frame-based movment routines in extra_subs.qc.

	------------------------------------------------------------------------------------
	GETTING THE INSIDE FACES TO DRAW PROPERLY:
	
	METHOD 1:
	Use a custom QBSP util with func_water support (this does NOT require an engine mod)
	(eQBSP v1.0b for MacOS supports this - code/binaries available from www.planetquake.com/paroxysm/)
	Avoid butting func_water surfaces right up against solid geometry or you'll get z-fighting
	artifacts where real water wouldn't (extend "hidden" edges into a solid wall).
	
	METHOD 2 (hackaround):
	Add thin (1 unit) brushes for visible edges, but make sure these brushes DON'T touch
	the main volume (1 unit away), or the face will be consumed by QBSP!
	
	NOTE:
	Software Quake seems to occasionally disagree with these, causing them to not render properly
	(looks like a Z buffer related problem). This is not limited to func_water, but the odd intersecting
	geometry sometimes required by func_water makes it more prone to expose this bug. TEST YOUR MAPS!
	These problems can usually be overcome by butting up the water edges with it's "container" geometry
	(Yes that's exaclty what I warned against previously). You can disable mirroring in eQBSP per-entity
	by setting the "_nomirror" key to a non-zero value, and use "METHOD 2" to backface the problem brush.
	
	Unavoidable differences between func_water and real water:
	1. Underwater surfaces don't warp
	2. Surface is always opaque
	
	------------------------------------------------------------------------------------
	NOTE:
	
	I've made no effort to make func_water's color shifts play nice with other entities that
	might use custom color shifts. It may make sense to store the cshift in a vector+float so
	it can be combined with other cshifts, but right now it's an easy-to-deal-with string.
	Real water overrides v_cshift anyway, so it makes sense to leave func_water as it is, and
	give it's cshift priorty over other entites (making it behave just like real water).
	
*/
 
//============================================================================
float EASEUNDERCURRENT = 16;
void() 	liquid_movetopos2;
void() 	liquid_movetopos1;

// Silly hack to ensure cshift happens for dead players
void() CheckFuncWaterDeath =
{
	local entity ent;
	local vector spot;
	
	spot = self.origin + self.view_ofs;
	ent = find(world, classname, "fliquid");

	while(ent)
	{	
		// FIXME! - do this right?
		if ( (spot_x<ent.absmax_x) &&
			 (spot_y<ent.absmax_y) &&
			 (spot_z<ent.absmax_z) &&
			 (spot_x>ent.absmin_x) && 
			 (spot_y>ent.absmin_y) && 
			 (spot_z>ent.absmin_z)) {
						
			// Do the color shift
			stuffcmd(self, "v_cshift ");
			stuffcmd(self, ent.cshift);
			stuffcmd(self, "\n");

			self.fwatershifttime = time+frametime;
			self.fwatershift = TRUE;			
			
			return;// Done (or else someone made a retarded map)
		}
		
		ent = find(ent, classname, "fliquid");
	}
};

//============================================================================

void() liquid_playmovesound =
{
	if (self.noise != string_null)
		sound (self.aiment, CHAN_VOICE, self.noise, 1.0, ATTN_NORM);
};

void() liquid_playreturnsound =
{
	if (self.noise1 != string_null)
		sound (self.aiment, CHAN_VOICE, self.noise1, 1.0, ATTN_NORM);
};

void() liquid_playstopsound =
{
	if (self.noise2 != string_null)
		sound (self.aiment, CHAN_VOICE, self.noise2, 1.0, ATTN_NORM);
};

void() liquid_at_pos1 =
{
	setorigin(self.aiment, self.aiment.pos1);
	liquid_playstopsound();
	self.state = STATE_BOTTOM;
	
	if (!self.targetname) {// Just keep bobbing between pos1 & pos2	
		if (self.wait > 0) {
			self.think = liquid_movetopos2;
			self.nextthink = time + self.wait;
		} else if (!self.wait)
			liquid_movetopos2();
	}
	
	
	if (self.target) {
		activator = self.enemy;
		SUB_UseTargets();
	}
};

void() liquid_at_pos2 =
{
	setorigin(self.aiment, self.aiment.pos2);
	liquid_playstopsound();
	self.state = STATE_TOP;
	
	if (self.wait > 0) {
		self.think = liquid_movetopos1;
		self.nextthink = time + self.wait;
	} else if (!self.wait)
		liquid_movetopos1();
	
	// Fire targets	
	if (self.target) {
		activator = self.enemy;
		SUB_UseTargets();
	}
};

void() liquid_movetopos1 =
{
	self.state = STATE_DOWN;
	setorigin(self.aiment, self.aiment.dest2);
	liquid_playreturnsound();
	// Frame-based move for non-clippers
	SUB_fCalcMove(self.pos1, self.speed2, liquid_at_pos1);
};

void() liquid_movetopos2 =
{
	self.state = STATE_UP;
	setorigin(self.aiment, self.aiment.dest1);
	liquid_playmovesound();
	// Frame-based move for non-clippers
	SUB_fCalcMove(self.pos2, self.speed, liquid_at_pos2);
};

void() liquid_use =
{	
	if (self.nextthink > time) return;// waiting or moving
	
	self.enemy = activator;
	
	if (self.state == STATE_BOTTOM)
		liquid_movetopos2();
	else if (self.state == STATE_TOP)
		liquid_movetopos1();
	
	// ...already started moving
};

/*
=======================================================
liquid_drown

(khreathor)
Drown function for monsters;
=======================================================
*/
void(entity entToDrown) liquid_drown =
{
	if(other.flags & FL_SWIM)
		return;
	
	if(entToDrown.takedamage == DAMAGE_NO)
		return;
	
	if(entToDrown.health < 0)
		return;
	
	if(entToDrown.classname == "monster_corpse")
		return;
	
	if(entToDrown.drawntime < time && entToDrown.spawnflags & CAN_DROWN)
	{
		sound (self, CHAN_BODY, "player/drown1.wav", 1, ATTN_NORM);
		DeathBubblesOnEntity(entToDrown,5);
		// drowning damage formula 5*(x^2/10 + 1) // (khreathor)
		entToDrown.drown_dmg = 5 * (entToDrown.drown_cnt * entToDrown.drown_cnt * 0.1 + 1);
		
		if(entToDrown.health < entToDrown.drown_dmg)
		{
			entToDrown.drown_dmg = entToDrown.health;
		}
		
		T_Damage (entToDrown, world, world, entToDrown.drown_dmg,DAMARMOR);
		//dprint("drown_cnt: ");
		//dprint(ftos(entToDrown.drown_cnt));
		//dprint(" | drown_dmg: ");
		//dprint(ftos(entToDrown.drown_dmg));
		//dprint("\n");
		entToDrown.drawntime = time + 1;
		entToDrown.drown_cnt = entToDrown.drown_cnt + 1;
	}
};

void(entity entToDrown) liquid_sound =
{
	if (other.fwatershifttime < time && other.watertype)
		{			
			other.watertype = self.watertype;
			other.waterlevel = 1;
			other.infuncwater = TRUE;
		}
		
		// C code will go nuts with the splash sound if we don't time out while in func_water
		other.fwatershifttime = time + 0.1;	
};

void() vanilla_water_check =
{
	local vector test_vec;
	
	test_vec = self.maxs - '0 0 16';
	test_vec_x = test_vec_y = 0;
	test_vec = self.origin + test_vec;
	
	if(pointcontents(test_vec) < -2)
	{
		if(!self.inBSPwater)
		{
			//dprint("under water \n");
			self.inBSPwater = TRUE;
		}
		
		if(self.spawnflags & CAN_DROWN)
		{
			self.drawntime = time + 12;
			self.drown_dmg = 0;
			self.drown_cnt = 1;
			liquid_drown(self);
		}
	}
	else if(self.inBSPwater)
	{
		//dprint("above water \n");
		self.inBSPwater = FALSE;
	}
};

void() liquid_touch =
{
	local float test;
	local vector test_vec;
	local float c;
	
	if (!(other.flags & FL_CLIENT)) {
		// Handle some special cases (always set think1 as death function!)
		if (other.classname == "drip") {
			setorigin(other, other.origin + '0 0 6');
			self = other;
			self.think1();
			return;
		}
		else if (other.classname == "spark") {
			self = other;
			self.think1();
			return;
		}
		// else if (other.classname == "particle" && other.owner.spawnflags & KILLINFWATER) {	
			// self = other;
			// self.think1();
			// return;
		// }
		
	// Trick the C code into playing the splash sound... (even though I find it annoying as hell)
		
		// These movetypes don't splash
		if (other.movetype == MOVETYPE_NONE ||
			other.movetype == MOVETYPE_PUSH	||
			other.movetype == MOVETYPE_NOCLIP)// MOVETYPE_WALK is always FL_CLIENT so don't worry about it
			return;
		
		// Check if monster in water (khreathor)
		if(other.flags & FL_MONSTER)
		{
			test_vec = other.maxs - '0 0 8';
			test_vec_x = test_vec_y = 0;
			test_vec = other.origin + test_vec;
			
			if (test_vec_z <= self.absmax_z + 4 && test_vec_z >= self.absmin_z - 4)
			{
				if(test_vec_x <= self.absmax_x + 4 && test_vec_x >= self.absmin_x - 4)
				{
					if(test_vec_y <= self.absmax_y + 4 && test_vec_y >= self.absmin_y - 4)
					{
						other.infuncwater = TRUE;
						if(!other.inwsound)
						{
							other.drawntime = time + 12;
							other.drown_dmg = 0;
							other.drown_cnt = 1;
							other.watertype = self.watertype;
							other.waterlevel = 1;
							other.inwsound = TRUE;
						}
						
						///	Check if on surface
						test_vec = test_vec + '0 0 8';
						if (test_vec_z >= self.absmax_z)
						{
							other.onSurface = TRUE;
						}
						else
						{
							other.onSurface = FALSE;
						}
						
						liquid_drown(other);
						return;
					}
				}
			}

			other.infuncwater = FALSE;
			other.onSurface = FALSE;
			
			if(other.inwsound)
			{
				other.watertype = self.watertype;
				other.waterlevel = 1;
				other.inwsound = FALSE;
			}
			return;
		}
		
		// Wait for the engine to assign CONTENT_EMPTY before changing watertype (just spawned)
		if (other.fwatershifttime < time && other.watertype)
		{			
			other.watertype = self.watertype;
			other.waterlevel = 1;
		}
		
		// C code will go nuts with the splash sound if we don't time out while in func_water
		other.fwatershifttime = time + 0.1;	
		return;
	}
	
	// Test Feet (if feet are below maxs and above mins, we're in)
	test = other.origin_z + other.mins_z + 1;
	if (test <= self.absmax_z && test >= self.absmin_z) {
		
		other.watertype = self.watertype;
		other.waterlevel = 1;
		
		// Test Torso
		test = other.origin_z + (other.mins_z + other.maxs_z) * 0.5;
		if (test <= self.absmax_z) {
			other.waterlevel = 2;
			other.zerogtime = time+0.05;// remove gravity in PreThink
		}
		
		// Test Eyes
		test = other.origin_z + other.view_ofs_z;
		if (test <= self.absmax_z) {
			other.waterlevel = 3;
			
			// Do the color shift
			stuffcmd(other, "v_cshift ");
			stuffcmd(other, self.cshift);
			stuffcmd(other, "\n");
	
			// Tell PreThink to clear the cshift when the player is out
			other.fwatershifttime = time+frametime;
			other.fwatershift = TRUE;
		}
		
		// Don't let water sweep ayway someone on a ladder (not if totally underwater though)
		if (other.laddertime > time) return;
		
		// Add drag and/or current
		if (self.spawnflags & EASEUNDERCURRENT) c = 4-other.waterlevel; else c = other.waterlevel;	
		if (self.drag) other.velocity = other.velocity + self.velocity*(self.drag*frametime)*c;
		if (self.mangle != '0 0 0') other.velocity = other.velocity + self.mangle*frametime*(c/3);
	}
};

// Water volumes may be large, so self.aiment bounces
// around to play sounds at appropriate places.
void() liquid_spawnnoisemaker =
{
	self.aiment = spawn();
	self.aiment.movetype = MOVETYPE_NOCLIP;
	self.aiment.solid = SOLID_NOT;
	
	// Middle of surface at pos1 (stop sound)
	self.aiment.pos1_z = self.maxs_z;
	self.aiment.pos1_x = (self.mins_x + self.maxs_x)*0.5;
	self.aiment.pos1_y = (self.mins_y + self.maxs_y)*0.5;
	// Center of volume at pos1 (move sound)
	self.aiment.dest1 = self.aiment.pos1;
	self.aiment.dest1_z = (self.mins_z + self.maxs_z)*0.5;
	
	// Middle of surface at pos2 (stop sound)
	self.aiment.pos2_z = self.maxs_z + self.height;
	self.aiment.pos2_x = (self.mins_x + self.maxs_x)*0.5;
	self.aiment.pos2_y = (self.mins_y + self.maxs_y)*0.5;
	// Center of volume at pos2 (return sound)
	self.aiment.dest2 = self.aiment.pos2;
	self.aiment.dest2_z = self.height + (self.mins_z + self.maxs_z)*0.5;
	
	// Get in position in case STARTSOUND is set
	setorigin(self.aiment, self.aiment.pos1);
};

/*QUAKED func_water (0 .5 .8)
Turns a brush into a liquid-mimic that can move up & down.

"watertype"		-3 = water, -4 = slime, -5 = lava
"height"		Number of units to move (negatve is down).
"speed"			Speed used when it moves to "height" position.
"speed2"		Speed used when moving back to original position (pos1). Same as "speed" if not defined.			
"wait"			Wait before returning to original position -1 = stay at pos2 until triggered again.
"noise"			Path to the WAV played when the water moves from pos1 to pos2 (should be looped).
"noise1"		Path to the WAV played when the water moves back to pos1 from pos2 (should be looped).
"noise2"		Path to the WAV played when the water stops moving.
"mangle"		Direction & speed of current
"drag"			Drag on player when water is moving (0 is no drag, 100 if full drag)
"cshift"		Custom RGB+I colour shift. Automatically set by watertype if ommited.
"targetname"	Can be triggered (just keeps bobbing between pos1 & pos2 otherwise).
"target"		Activate this entity after moving (top and bottom)

Spawnflags:

"EASEUNDERCURRENT"	Normally, the deeper you are, the more you are affected by current.
					This reverses that, making current is stronger at the surface.
					
NOTE:

func_water is an easy way to make rising/falling water, but func_watertrain is much more flexible
(it can do anything func_water can do, and then some, but it's more work to setup)

*/
void() func_water =
{
	if (self.noise != string_null)
		precache_sound (self.noise);
	if (self.noise1 != string_null)
		precache_sound (self.noise1);
	if (self.noise2 != string_null)
		precache_sound (self.noise2);
	
	self.solid = SOLID_TRIGGER;
	self.movetype = MOVETYPE_NONE;
	setmodel (self, self.model);
	setsize (self, self.mins , self.maxs);
	setorigin (self, self.origin);

	self.classname = "fliquid";
	self.touch = liquid_touch;

	if (self.watertype<-5 || self.watertype>-3)
		self.watertype = CONTENT_WATER;

	if (self.cshift == string_null) {
		if (self.watertype == CONTENT_WATER)
			self.cshift = "130 80 50 128";
		else if (self.watertype == CONTENT_SLIME)
			self.cshift = "0 25 5 150";
		else if (self.watertype == CONTENT_LAVA)
			self.cshift = "255 80 0 150";
	}
	
	// Cap drag force
	if (self.drag > 100) self.drag = 100;
	if (self.drag < 0) self.drag = 0;
	
	if (self.mangle != '0 0 0')
		self.mangle = self.mangle*50;
	
	if (!self.speed) self.speed = 10;
	if (!self.speed2) self.speed2 = self.speed;
	
	// pos1 is the original position, pos2 is the target position
	self.pos1 = self.origin;
	self.pos2 = self.origin;
	self.pos2_z = self.origin_z + self.height;
	
	// pos2 may actually be below pos1, but we'll just say pos1 = BOTTOM and pos2 = TOP
	self.state = STATE_BOTTOM;
	
	liquid_spawnnoisemaker();
	
	// Keeps bobbing between pos1 & pos2 if not triggered
	if (!self.targetname) {	
		if (self.wait <= 0)
			liquid_movetopos2();	
	} else {// wait for trigger
		self.use = liquid_use;
	}
};

//============================================================================

void() func_watertrain_init =
{
	local entity	targ;
	
	targ = find (world, targetname, self.target);
	
	// Attach to a "real" train
	if (targ.classname == "train_ext") {
		self.speed = 0;
		train_ext_linkchild();
	}
	// Become an independant watertrain
	else if (targ.classname == "train_waypoint") {
		if (!self.targetname) self.spawnflags = self.spawnflags | START_ON;
		if (self.speed<-1) self.speed = -1;
		self.use = train_ext_use;
		self.dmg = 0;// Doesn't block
		train_ext_init();
	}
	else
		objerror ("func_watertrain_init: illegal target type");
};

/*QUAKED func_watertrain (0 .5 .8) ? START_ON EASEUNDERCURRENT ALLOWPAUSE ALLOWCHANGEDIR AUTOREVERSE
Turns a brush into a liquid-mimic that travels like a func_train_ext. It can target an
existing func_train_ext to become a child of that train, or link directly with a chain of
train_ext_waypoint entities.

"watertype"		-3 = water, -4 = slime, -5 = lava
"speed"			Speed of the watertrain (can be overridden by waypoints)
"noise"			Path to the WAV played when the water moves (can be overridden by waypoints)
"noise1"		Path to the WAV played when the water stops moving (can be overridden by waypoints)
"noise4"		Noise to make when changing directions (DON'T USE A LOOPED WAV!!)
"noise5"		Noise to make when trying to go wrong way at end of path (uses "noise1" if not set)
"cshift"		Custom RGB+I colour shift. Automatically set by watertype if ommited.
"mangle"		Direction & speed of current (if any)
"drag"			Drag on player when water is moving (0 is no drag, 100 if full drag)
"target"		First waypoint (train_ext_waypoint), or parent (func_train_ext)
"event"			Start at this waypoint (since you MUST use the first waypoint as the "target" on a non-looped path)
"targetname"	Can be triggered (ignored if has parent)

Spawnflags:

"START_ON"			Start the train immediately, even if targeted.
"ALLOWPAUSE"		Re-Triggering will pause/resume the train at any point along it's path.
"ALLOWCHANGEDIR"	Lets a changedir trigger reverse the train's direction at any time
"AUTOREVERSE"		Train automatically reverses direction when it hits the last/first waypoint
					(only makes sense if last waypoint has no target).
"EASEUNDERCURRENT"	Normally, the deeper you are, the more you are affected by current.
					This reverses that, making current is stronger at the surface.
"STARTREVERSE"		Start in reverse

NOTES:

If a func_watertrain's target is a func_train_ext, the parent train controls all,
movement and overrides train-specific spawnflags.

func_watertrain uses a frame-based move that may lag/overshoot the engine controlled
parent train when the game is running slow. It will never go out-of-sync with the parent for
more than a couple frames, but you should be aware of this when mapping (extend hidden water
edges into solid geometry, and allow for some play in all directions).

*/
void() func_watertrain =
{
	if (!self.target) objerror ("func_watertrain without a target");
	
	if (self.watertype<-5 || self.watertype>-3)
		self.watertype = CONTENT_WATER;
		
	if (self.cshift == string_null) {
		if (self.watertype == CONTENT_WATER)
			self.cshift = "130 80 50 128";
		else if (self.watertype == CONTENT_SLIME)
			self.cshift = "0 25 5 150";
		else if (self.watertype == CONTENT_LAVA)
			self.cshift = "255 80 0 150";
	}
	
	// Cap drag force
	if (self.drag > 100) self.drag = 100;
	if (self.drag < 0) self.drag = 0;
	
	if (self.mangle != '0 0 0')
		self.mangle = self.mangle*50;
		
	self.classname = "fliquid";
	self.touch = liquid_touch;
	
	train_ext_precachenoise();
	
	self.solid = SOLID_TRIGGER;
	self.movetype = MOVETYPE_NONE;
	setmodel (self, self.model);
	setsize (self, self.mins , self.maxs);
	setorigin (self, self.origin);
		
	// wait for targets to spawn
	self.nextthink = time + 0.2;// start after first frame to allow train to move to it's startpoint
	self.think = func_watertrain_init;
};

//============================================================================

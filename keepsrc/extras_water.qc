//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
//
// Attributions: Frank Condello (aka pOx), Khreathor for the extras_r5 update
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
// Entity count: 2
// Function count: 13
//
// Implements: Moving Water Volumes
//
// Description:
// Moving water volumes - honest and for true.
// Dependant on additions in client.qc.
// Uses frame-based movment routines in extra_subs.qc.
//
// GETTING THE INSIDE FACES TO DRAW PROPERLY:
//
// METHOD 1:
// Use a custom QBSP util with func_water support (this does NOT require an 
// engine mod).  (eQBSP v1.0b for MacOS supports this - code/binaries available
// from www.planetquake.com/paroxysm/).  Avoid butting func_water surfaces
// right up against solid geometry or you'll get z-fighting artifacts where
// real water wouldn't (extend "hidden" edges into a solid wall).
//
// METHOD 2 (hackaround):
// Add thin (1 unit) brushes for visible edges, but make sure these brushes
// DON'T touch the main volume (1 unit away), or the face will be consumed by
// QBSP!
//
//
// Software Quake seems to occasionally disagree with these, causing them to
// not render properly (looks like a Z buffer related problem). This is not 
// limited to func_water, but the odd intersecting geometry sometimes required
// by func_water makes it more prone to expose this bug. TEST YOUR MAPS!  These
// problems can usually be overcome by butting up the water edges with it's
// "container" geometry.  (Yes that's exaclty what I warned against previously)
// You can disable mirroring in eQBSP per-entity by setting the "_nomirror" key
// to a non-zero value, and use "METHOD 2" to backface the problem brush.
//
// ericw's compilers also provide support for _mirrorinside 1 on brushes too.
//
// Unavoidable differences between func_water and real water:
// 1. Underwater surfaces don't warp
// 2. Surface is always opaque
//=============================================================================

float EASEUNDERCURRENT = 16;
void() 	liquid_movetopos2;
void() 	liquid_movetopos1;

// Silly hack to ensure cshift happens for dead players
void() CheckFuncWaterDeath = { // [FUNCTION]
	local entity ent;
	local vector spot;
	
	spot = self.origin + self.view_ofs;
	ent = find(world, classname, "fliquid");
	while(ent) {	
		if ( (spot_x<ent.absmax_x) && (spot_y<ent.absmax_y) && (spot_z<ent.absmax_z) && (spot_x>ent.absmin_x) &&  (spot_y>ent.absmin_y) &&  (spot_z>ent.absmin_z)) {
			// Do the color shift
			Safe_stuffcmd(self, "v_cshift ");
			Safe_stuffcmd(self, ent.cshift);
			Safe_stuffcmd(self, "\n");
			self.fwatershifttime = time+frametime;
			self.fwatershift = TRUE;			
			return;
		}
		ent = find(ent, classname, "fliquid");
	}
};

void() liquid_playmovesound = { // [FUNCTION]
	if (self.noise != "") sound (self.aiment, CHAN_VOICE, self.noise, 1.0, ATTN_NORM);
};

void() liquid_playreturnsound = { // [FUNCTION]
	if (self.noise1 != "") sound (self.aiment, CHAN_VOICE, self.noise1, 1.0, ATTN_NORM);
};

void() liquid_playstopsound = { // [FUNCTION]
	if (self.noise2 != "") sound (self.aiment, CHAN_VOICE, self.noise2, 1.0, ATTN_NORM);
};

void() liquid_at_pos1 = { // [FUNCTION]
	setorigin(self.aiment, self.aiment.pos1);
	liquid_playstopsound();
	self.state = STATE_BOTTOM;
	
	if (!self.targetname) {// Just keep bobbing between pos1 & pos2	
		if (self.wait > 0) {
			self.think = liquid_movetopos2;
			self.nextthink = time + self.wait;
		} else if (!self.wait) liquid_movetopos2();
	}

	if (self.target) {
		activator = self.enemy;
		SUB_UseTargets();
	}
};

void() liquid_at_pos2 = { // [FUNCTION]
	setorigin(self.aiment, self.aiment.pos2);
	liquid_playstopsound();
	self.state = STATE_TOP;
	
	if (self.wait > 0) {
		self.think = liquid_movetopos1;
		self.nextthink = time + self.wait;
	} else if (!self.wait) liquid_movetopos1();
	
	// Fire targets	
	if (self.target) {
		activator = self.enemy;
		SUB_UseTargets();
	}
};

void() liquid_movetopos1 = { // [FUNCTION]
	self.state = STATE_DOWN;
	setorigin(self.aiment, self.aiment.dest2);
	liquid_playreturnsound();
	SUB_CalcMove(self.pos1, self.speed2, liquid_at_pos1); // Frame-based move for non-clippers
};

void() liquid_movetopos2 = { // [FUNCTION]
	self.state = STATE_UP;
	setorigin(self.aiment, self.aiment.dest1);
	liquid_playmovesound();
	SUB_CalcMove(self.pos2, self.speed, liquid_at_pos2); // Frame-based move for non-clippers
};

void() liquid_use = { // [FUNCTION]
	if (self.nextthink > time) return;// waiting or moving
	
	self.enemy = activator;
	if (self.state == STATE_BOTTOM) liquid_movetopos2(); // Start moving
	else if (self.state == STATE_TOP) liquid_movetopos1(); // Start moving
};

// Drown function for monsters (khreathor)
void(entity entToDrown) liquid_drown = { // [FUNCTION]
	if (entToDrown.flags & FL_SWIM) return;
	if (!(entToDrown.flags & FL_CLIENT || entToDrown.flags & FL_MONSTER)) return;
	if (entToDrown.takedamage == DAMAGE_NO) return;
	if (entToDrown.health < 0) return;
	if (entToDrown.bodyonflr == MON_ONFLR) return;
	
	if (entToDrown.drawntime < time && entToDrown.spawnflags & CAN_DROWN) {
		sound (self, CHAN_BODY, "player/drown1.wav", 1, ATTN_NORM);
		death_bubbles(5);
		// drowning damage formula 5*(x^2/10 + 1) // (khreathor)
		entToDrown.drown_dmg = 5 * (entToDrown.drown_cnt * entToDrown.drown_cnt * 0.1 + 1);
		if (entToDrown.health < entToDrown.drown_dmg) entToDrown.drown_dmg = entToDrown.health;
		T_Damage (entToDrown, world, world, entToDrown.drown_dmg,DAMARMOR);
		entToDrown.drawntime = time + 1;
		entToDrown.drown_cnt = entToDrown.drown_cnt + 1;
	}
};

void(entity entToDrown) liquid_sound = { // [FUNCTION]
	if (other.fwatershifttime < time && other.watertype)
		{			
			other.watertype = self.watertype;
			other.waterlevel = 1;
			other.infuncwater = TRUE;
		}
		
		// C code will go nuts with the splash sound if we don't time out while in func_water
		other.fwatershifttime = time + 0.1;	
};

void() liquid_touch = { // [FUNCTION]
	local float test, c;
	local vector test_vec;
	
	if (!(other.flags & FL_CLIENT)) {
		// Handle some special cases (always set think1 as death function!)
		if (other.classtype == CT_MISCDRIP) {
			setorigin(other, other.origin + '0 0 6');
			self = other;
			self.touch();
			return;
		} else if (other.classtype == CT_TEMPSPARK) {
			self = other;
			misc_sparks_fade3();
			return;
		}

		// Trick the C code into playing the splash sound... (even though I find it annoying)

		if (other.movetype == MOVETYPE_NONE || other.movetype == MOVETYPE_PUSH || other.movetype == MOVETYPE_NOCLIP) return; // These movetypes don't splash.
		
		// Check if monster in water (khreathor)
		if (other.flags & FL_MONSTER) {
			test_vec = other.maxs - '0 0 8';
			test_vec_x = test_vec_y = 0;
			test_vec = other.origin + test_vec;
			if (test_vec_z <= self.absmax_z + 4 && test_vec_z >= self.absmin_z - 4) {
				if (test_vec_x <= self.absmax_x + 4 && test_vec_x >= self.absmin_x - 4) {
					if (test_vec_y <= self.absmax_y + 4 && test_vec_y >= self.absmin_y - 4) {
						other.infuncwater = TRUE;
						if (!other.inwsound)
						{
							other.drawntime = time + 12;
							other.drown_dmg = 0;
							other.drown_cnt = 1;
							other.watertype = self.watertype;
							other.waterlevel = 1;
							other.inwsound = TRUE;
						}
						
						// Check if on surface
						test_vec = test_vec + '0 0 8';
						if (test_vec_z >= self.absmax_z) other.onsurface = TRUE;
						else other.onsurface = FALSE;
						
						liquid_drown(other);
						return;
					}
				}
			}

			other.infuncwater = FALSE;
			other.onsurface = FALSE;
			if (other.inwsound) {
				other.watertype = self.watertype;
				other.waterlevel = 1;
				other.inwsound = FALSE;
			}
			return;
		}
		
		// Wait for the engine to assign CONTENT_EMPTY before changing watertype (just spawned)
		if (other.fwatershifttime < time && other.watertype) {			
			other.watertype = self.watertype;
			other.waterlevel = 1;
		}

		other.fwatershifttime = time + 0.1;	// C code will go nuts with the splash sound if we don't time out while in func_water
		return;
	}
	
	// Test Feet (if feet are below maxs and above mins, we're in)
	//test = other.origin_z + other.mins_z + 1;
	test = other.origin_z + 1;
	if (test <= self.absmax_z && ((test + other.view_ofs_z) >= self.absmin_z)) {
		other.watertype = self.watertype;
		other.waterlevel = 1;
		if (SUB_CheckPointInBounds(other.origin, self.absmax, self.absmin)) {
			other.waterlevel = 2;
			other.zerogtime = time+0.05; // remove gravity in PreThink
		}
		
		// Test Eyes
		if (SUB_CheckPointInBounds(other.origin + other.view_ofs, self.absmax, self.absmin)) {
			other.waterlevel = 3;
			other.infuncwater = TRUE;
			other.cshift_upd = TRUE;
			Safe_stuffcmd(other, "v_cshift "); // Do the color shift
			Safe_stuffcmd(other, self.cshift);
			Safe_stuffcmd(other, "\n");
			other.fwatershifttime = time+frametime; // Tell PreThink to clear the cshift when the player is out
			other.fwatershift = TRUE;
		} else {
			if (!self.burning && !self.poisoned && !self.bleeding) other.cshift_upd = FALSE;
		}

		if (other.onladder) return; // Don't let water sweep ayway someone on a ladder (not if totally underwater though)
		
		// Add drag and/or current
		if (self.spawnflags & EASEUNDERCURRENT) c = 4-other.waterlevel; else c = other.waterlevel;	
		if (self.drag) other.velocity = other.velocity + self.velocity*(self.drag*frametime)*c;
		if (self.mangle != '0 0 0') other.velocity = other.velocity + self.mangle*frametime*(c/3);
	} else other.infuncwater = FALSE;
};

// Water volumes may be large, so self.aiment bounces
// around to play sounds at appropriate places.
void() liquid_spawnnoisemaker = { // [FUNCTION]
	self.aiment = spawn();
	self.aiment.movetype = MOVETYPE_NOCLIP;
	self.aiment.solid = SOLID_NOT;
	self.aiment.pos1_z = self.maxs_z; // Middle of surface at pos1 (stop sound)
	self.aiment.pos1_x = (self.mins_x + self.maxs_x)*0.5;
	self.aiment.pos1_y = (self.mins_y + self.maxs_y)*0.5;
	self.aiment.dest1 = self.aiment.pos1; // Center of volume at pos1 (move sound)
	self.aiment.dest1_z = (self.mins_z + self.maxs_z)*0.5;
	self.aiment.pos2_z = self.maxs_z + self.height; // Middle of surface at pos2 (stop sound)
	self.aiment.pos2_x = (self.mins_x + self.maxs_x)*0.5;
	self.aiment.pos2_y = (self.mins_y + self.maxs_y)*0.5;
	self.aiment.dest2 = self.aiment.pos2; // Center of volume at pos2 (return sound)
	self.aiment.dest2_z = self.height + (self.mins_z + self.maxs_z)*0.5;
	setorigin(self.aiment, self.aiment.pos1); // Get in position in case STARTSOUND is set
};

// QUAKED func_water (0 .5 .8)
// Turns a brush into a liquid-mimic that can move up & down.
// "watertype"		-3 = water, -4 = slime, -5 = lava
// "height"		Number of units to move (negatve is down).
// "speed"			Speed used when it moves to "height" position.
// "speed2"		Speed used when moving back to original position (pos1). Same as "speed" if not defined.			
// "wait"			Wait before returning to original position -1 = stay at pos2 until triggered again.
// "noise"			Path to the WAV played when the water moves from pos1 to pos2 (should be looped).
// "noise1"		Path to the WAV played when the water moves back to pos1 from pos2 (should be looped).
// "noise2"		Path to the WAV played when the water stops moving.
// "mangle"		Direction & speed of current
// "drag"			Drag on player when water is moving (0 is no drag, 100 if full drag)
// "cshift"		Custom RGB+I colour shift. Automatically set by watertype if ommited.
// "targetname"	Can be triggered (just keeps bobbing between pos1 & pos2 otherwise).
// "target"		Activate this entity after moving (top and bottom)
// Spawnflags:
// "EASEUNDERCURRENT"	Normally, the deeper you are, the more you are affected by current.  This reverses that, making current is stronger at the surface.				
// An easy way to make rising/falling water, but func_watertrain is much more flexible (it can do anything func_water can do, and then some, but it's more work to setup)
void() func_water = { // [ENTITY]
	if (self.noise != "") precache_sound (self.noise);
	if (self.noise1 != "") precache_sound (self.noise1);
	if (self.noise2 != "") precache_sound (self.noise2);
	self.solid = SOLID_TRIGGER;
	self.movetype = MOVETYPE_NONE;
	setmodel (self, self.model);
	setsize (self, self.mins , self.maxs);
	setorigin (self, self.origin);
	self.classname = "fliquid";
	self.touch = liquid_touch;
	if (self.watertype<-5 || self.watertype>-3) self.watertype = CONTENT_WATER;
	if (self.cshift == "") {
		if (self.watertype == CONTENT_WATER) {
			self.cshift = "130 80 50 128";
			self.alpha = world.water_alpha;
		} else if (self.watertype == CONTENT_SLIME) {
			self.cshift = "0 25 5 150";
			self.alpha = world.slimealpha;
		} else if (self.watertype == CONTENT_LAVA) {
			self.cshift = "255 80 0 150";
			self.alpha = world.lavaalpha;
		}
	}

	if (self.drag > 100) self.drag = 100; // Cap drag force
	if (self.drag < 0) self.drag = 0;
	if (self.mangle != '0 0 0') self.mangle = self.mangle*50;
	if (!self.speed) self.speed = 10;
	if (!self.speed2) self.speed2 = self.speed;
	self.pos1 = self.origin; // pos1 is the original position
	self.pos2 = self.origin; // pos2 is the target position
	self.pos2_z = self.origin_z + self.height;
	self.state = STATE_BOTTOM; // pos2 may actually be below pos1, but we'll just say pos1 = BOTTOM and pos2 = TOP
	liquid_spawnnoisemaker();
	
	// Keeps bobbing between pos1 & pos2 if not triggered
	if (!self.targetname && self.wait <= 0) liquid_movetopos2();	
	else self.use = liquid_use; // Wait for trigger.
};

void() func_watertrain_init = {
	local entity targ;
	
	targ = find (world, targetname, self.target);
	if (targ.classname == "train_ext") { // Attach to a "real" train
		self.speed = 0;
		train_ext_linkchild();
	} else if (targ.classname == "train_waypoint") { // Become an independant watertrain
		if (!self.targetname) self.spawnflags = self.spawnflags | START_ON;
		if (self.speed<-1) self.speed = -1;
		self.use = train_ext_use;
		self.dmg = 0; // Doesn't block
		train_ext_init();
	} else objerror ("func_watertrain_init: illegal target type");
};

// QUAKED func_watertrain (0 .5 .8) ? START_ON EASEUNDERCURRENT ALLOWPAUSE ALLOWCHANGEDIR AUTOREVERSE
// Turns a brush into a liquid-mimic that travels like a func_train_ext. It can target an
// existing func_train_ext to become a child of that train, or link directly with a chain of
// train_ext_waypoint entities.
// "watertype"		-3 = water, -4 = slime, -5 = lava
// "speed"			Speed of the watertrain (can be overridden by waypoints)
// "noise"			Path to the WAV played when the water moves (can be overridden by waypoints)
// "noise1"		Path to the WAV played when the water stops moving (can be overridden by waypoints)
// "noise4"		Noise to make when changing directions (DON'T USE A LOOPED WAV!!)
// "noise5"		Noise to make when trying to go wrong way at end of path (uses "noise1" if not set)
// "cshift"		Custom RGB+I colour shift. Automatically set by watertype if ommited.
// "mangle"		Direction & speed of current (if any)
// "drag"			Drag on player when water is moving (0 is no drag, 100 if full drag)
// "target"		First waypoint (train_ext_waypoint), or parent (func_train_ext)
// "event"			Start at this waypoint (since you MUST use the first waypoint as the "target" on a non-looped path)
// "targetname"	Can be triggered (ignored if has parent)
// Spawnflags:
// "START_ON"			Start the train immediately, even if targeted.
// "ALLOWPAUSE"		Re-Triggering will pause/resume the train at any point along it's path.
// "ALLOWCHANGEDIR"	Lets a changedir trigger reverse the train's direction at any time
// "AUTOREVERSE"		Train automatically reverses direction when it hits the last/first waypoint (only makes sense if last waypoint has no target).
// "EASEUNDERCURRENT"	Normally, the deeper you are, the more you are affected by current.  This reverses that, making current is stronger at the surface.
// "STARTREVERSE"		Start in reverse
// If a func_watertrain's target is a func_train_ext, the parent train controls all, movement and overrides train-specific spawnflags.
// Uses a frame-based move that may lag/overshoot the engine controlled parent train when the game is running slow. It will never go out-of-sync with the parent for
// more than a couple frames, but you should be aware of this when mapping (extend hidden water edges into solid geometry, and allow for some play in all directions).
void() func_watertrain = { // [ENTITY]
	if (!self.target) objerror ("func_watertrain without a target");
	if (self.watertype<-5 || self.watertype>-3) self.watertype = CONTENT_WATER;
	if (self.cshift == "") {
		if (self.watertype == CONTENT_WATER) {
			self.cshift = "130 80 50 128";
			self.alpha = world.water_alpha;
		} else if (self.watertype == CONTENT_SLIME) {
			self.cshift = "0 25 5 150";
			self.alpha = world.slimealpha;
		} else if (self.watertype == CONTENT_LAVA) {
			self.cshift = "255 80 0 150";
			self.alpha = world.lavaalpha;
		}
	}
	
	
	if (self.drag > 100) self.drag = 100; // Cap drag force
	if (self.drag < 0) self.drag = 0;
	if (self.mangle != '0 0 0') self.mangle = self.mangle*50;	
	self.classname = "fliquid";
	self.touch = liquid_touch;
	train_ext_precachenoise();
	self.solid = SOLID_TRIGGER;
	self.movetype = MOVETYPE_NONE;
	setmodel (self, self.model);
	setsize (self, self.mins , self.maxs);
	setorigin (self, self.origin);
	self.nextthink = time + 0.2; // Start after first frame to allow train to move to it's startpoint and wait for targets to spawn
	self.think = func_watertrain_init; // 
};
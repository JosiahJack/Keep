//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by W. Josiah Jack, aka Qmaster
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
// Entity count: 3
// Function count: 10
//
// Implements: Static Props, Decorative Models
//
// Description:
// Custom models for use as decorative props.  Supports animated frames and
// skins.
//=============================================================================

float MISC_COLLISION = 2;		// misc_model has collision enabled
float MISC_MOVEMENT = 4;		// misc_model can be moved around
float MISC_DROPTOFLOOR = 8;		// misc_model will drop to floor
float MISC_MDLSETUP = 4096;		// misc_model setup (first time)
float MMLOOP_CONSTANT = 0;		// Animation/Skin/Rotation setup
float MMLOOP_TOGGLE = -1;
float MMLOOP_TRIGGER = -2;

// This is essentially a QC version of ChangeYaw() function that can cope with any axis as its take all parameters.
float(float curr_ang, float ideal_ang, float turn_speed) misc_model_turning = { // [FUNCTION]
	local float move_ang, ret_ang;

	curr_ang = rint(curr_ang); // Current/ideal as integers are easier to compare.  Having fine detailed angles leads to jittering.  
	if (curr_ang == 0) curr_ang = 360; // Make sure angle 0 = 360 (stops wrong turns).
	ideal_ang = rint(ideal_ang);
	if (ideal_ang == 0) ideal_ang = 360; // Make sure angle 0 = 360 (stops wrong turns).
	if (curr_ang == ideal_ang) return curr_ang; // Any change required? (very precise, 1 degree angle)
	move_ang = ideal_ang - curr_ang; // Find out angle difference (can be positive/negative)
	
	// Find out quickest angle movement (clockwise/counter) Differences greater than 180 are turning the wrong way.
	if (ideal_ang > curr_ang) {
		if (move_ang >= 180) move_ang = move_ang - 360;
	} else {
		if (move_ang <= -180) move_ang = move_ang + 360;
	}
	
	// Make sure the turning angle is not instant turning speed.  Find out the turning speed and direction (+/-).
	if (move_ang > 0) {
		if (move_ang > turn_speed) move_ang = turn_speed;
	} else {
		if (move_ang < -turn_speed) move_ang = -turn_speed;
	}

	ret_ang = anglemod(curr_ang + move_ang); // Add turning speed to current angles (+range check)
	return (ret_ang);
};

void() misc_model_findtarget = { // [FUNCTION]
	if (self.target != "") { // Any target (path_corner) defined?  Only works with path corner entities!
		self.goalentity = find(world, targetname, self.target); // Find the entity in world
		if (self.goalentity.classtype != CT_PATHCORNER) self.target = ""; // Reset if not a path corner
		else {
			self.dest1 = self.goalentity.origin - self.origin; // Directional vector (finishing point)
			self.finalangle = vectormod(vectoangles(self.dest1)); // Convert direction to facing angle + clamp 0-360
			self.t_length = vlen(self.dest1); // Total (map) distance to travel
			self.t_width = self.movespeed * self.speed; // Movement (map) distance per animation tick frame (count)
			self.dest2 = (normalize(self.dest1) * self.t_length); // Maximum vector distance to travel
			self.dest3 = self.dest2 / (self.t_length / self.t_width); // divide total distance by tick frame timing
			self.count = 0; // Movement counter (>t_length = end of movemnt)
		}
	}
	
	if (self.target == "") self.goalentity = world; // Something wrong, reset target/goalentity
};

void() misc_model_movetarget = { // [FUNCTION]
	if (self.count >= self.t_length) { // Has the model reached the path_corner?
		self.nodebuginfo = TRUE; // Suppress any console errors
		trigger_strs(self.goalentity.corner_event, self); // Check for any corner events?
		if (self.goalentity.corner_speed > 0) self.movespeed = self.goalentity.corner_speed; // Check for any speed change
		if (self.goalentity.wait < 0) self.corner_pause = TRUE; // Check for pause at path corner
		else self.corner_pause = FALSE;
		
		self.target = self.goalentity.target; // Setup next target (if it exists)
		misc_model_findtarget(); // Find next target (has exit condition)
	} else {
		self.state = STATE_ON; // Still moving, don't turn off function loop
		self.count = self.count + self.t_width; // Increase distance counter
		self.origin = self.origin + self.dest3; // Add distance segment for next point
		setorigin(self, self.origin); // Jump/move to next origin spot on path
		if (self.faceangle > 0) { // Find if model is turning towards target?
			// Z axis = pitch (twisting) ignore this for models
			// Y axis = classic angle/yaw
			// X axis = roll (up/down) for climbing towards path corners
			self.angles_y = misc_model_turning(self.angles_y, self.finalangle_y, self.yaw_speed);
			self.angles_x = misc_model_turning(self.angles_x, self.finalangle_x, self.yaw_speed);
		}
	}
};

void() misc_model_loop = { // [FUNCTION]
	if (self.estate & ESTATE_BLOCK) return; // Block off/disabled entity states

	if (self.pos1_z == NEGATIVE && self.waitmin != 0) { // Update FRAMES
		self.frame = self.framestart; // Update frame
		self.framestart = self.framestart + self.lip; // Move forward/backward
		if (self.lip > 0 && self.framestart > self.pos1_y) self.framestart = self.pos1_x;
		else if (self.lip < 0 && self.framestart < self.pos1_x) self.framestart = self.pos1_y;
		
		if (self.framestart < self.pos1_x || self.framestart > self.pos1_y) self.framestart = self.pos1_x; // Double Check for out of bounds
	}
	
	
	if (self.pos2_z == NEGATIVE && self.waitmin2 != 0) { // Update SKINS
		self.skin = self.skinstart; // Update frame
		self.skinstart = self.skinstart + self.lip; // Move forward/backward
		if (self.lip > 0 && self.skinstart > self.pos2_y) self.skinstart = self.pos2_x;
		else if (self.lip < 0 && self.skinstart < self.pos2_x) self.skinstart = self.pos2_y;
		
		if (self.skinstart < self.pos2_x || self.skinstart > self.pos2_y) self.skinstart = self.pos2_x; // Double Check for out of bounds
	}
	
	if (!VectorIsAllZeros(self.rotateangles) && self.waitmin3 != 0) { // Update rotation
		self.angles = self.angles + self.rotateangles;
		self.angles = vectormod(self.angles);
	}
	
	if (self.waitmin > 0) self.waitmin = self.waitmin - 1; // Decrease (RANGE+TRIGGER) counters for frame/skin animations
	if (self.waitmin2 > 0) self.waitmin2 = self.waitmin2 - 1;
	if (self.waitmin3 > 0) self.waitmin3 = self.waitmin3 - 1;
	if (self.waitmin == 0 && self.waitmin2 == 0 && self.waitmin3 == 0) self.state = STATE_OFF; // Check if frame, skin & rotation have finished counting down?
	if (self.target != "" && self.corner_pause == FALSE) { // Check for any movement
		if (!self.goalentity) misc_model_findtarget(); // First time movement? goalentity = world
		else misc_model_movetarget(); // Everything ready, keep moving
		
		if (self.corner_pause == FALSE) self.state = STATE_ON; // Paused at path_corner? no, keep moving!
	}
		
	// Keep looping (using frame setup)
	if (self.state == STATE_ON) {
		self.think = misc_model_loop;
		self.nextthink = time + self.speed;
	}
};

void() misc_model_use = { // [FUNCTION]
	local float trigsound;

	// Allow trigger to activate/turn on spawndelay misc model
	if (self.spawnflags & (MISC_STARTOFF | ENT_STARTOFF)) {
		self.spawnflags = self.spawnflags - (self.spawnflags & MISC_STARTOFF);
		self.spawnflags = self.spawnflags - (self.spawnflags & ENT_STARTOFF);
		entity_state_on();
		return;
	}
	
	if (self.estate & ESTATE_BLOCK) return; // Block off/disabled entity states

	trigsound = FALSE;
	self.corner_pause = FALSE; // No movement pause (ready to move)
	if (self.pos1_z == NEGATIVE) { // FRAME animation loops setup?
		if (self.frameloop == MMLOOP_TOGGLE) { // Toggle cannot switch off animation state because other types (frame/skin/rotate) maybe active and animating.
			if (self.state == STATE_ON) { // TOGGLE OFF frame loop ONLY!
				self.waitmin = 0;
				if (self.noise2 != "") sound(self,CHAN_VOICE, self.noise2, self.volume,ATTN_NORM); // Play OFF sound
			} else { // TOGGLE ON
				self.state = STATE_ON;	// Animation active
				self.waitmin = -1;		// Constant loop
				if (self.noise1 != "") sound(self,CHAN_VOICE, self.noise1, self.volume,ATTN_NORM); // Play ON sound
			}
		} else if (self.frameloop == MMLOOP_CONSTANT) { // Always switch ON animation
			self.state = STATE_ON;	// Animation active
			self.waitmin = -1;		// Constant loop
		} else if (self.frameloop == MMLOOP_TRIGGER) { // Animation for ONE time and stop
			trigsound = TRUE;		// Check for trigger sound
			self.state = STATE_ON;	// Animation active
			self.waitmin = 1;		// Loop once
		} else if (self.frameloop >= 1) { // Animation for fixed amount of time (cycles)
			trigsound = TRUE;				// Check for trigger sound
			self.state = STATE_ON;			// Animation active
			self.waitmin = self.frameloop;	// Loop fixed amount
		}
	}
	
	if (self.pos2_z == NEGATIVE) { // SKIN animation loops setup?
		if (self.skinloop == MMLOOP_TOGGLE) { // Toggle cannot switch off animation state because other types.  (frame/skin/rotate) maybe active and animating.
			if (self.state == STATE_ON) { // TOGGLE OFF skin loop ONLY!
				self.waitmin2 = 0;
				if (self.noise2 != "") sound(self,CHAN_VOICE, self.noise2, self.volume,ATTN_NORM); // Play OFF sound
			} else { // TOGGLE ON
				self.state = STATE_ON; // Animation active
				self.waitmin2 = -1; // Constant loop
				if (self.noise1 != "") sound(self,CHAN_VOICE, self.noise1, self.volume,ATTN_NORM); // Play ON sound
			}
		} else if (self.skinloop == MMLOOP_CONSTANT) { // Only switch on for constant if inactive
			self.state = STATE_ON;	// Animation active
			self.waitmin2 = -1;		// Constant loop
		} else if (self.skinloop == MMLOOP_TRIGGER) { // Animation for ONE time and stop
			trigsound = TRUE;		// Check for trigger sound
			self.state = STATE_ON;	// Animation active
			self.waitmin2 = 1;		// Loop once
		} else if (self.skinloop >= 1) { // Animation for fixed amount of time (cycles)
			trigsound = TRUE;				// Check for trigger sound
			self.state = STATE_ON;			// Animation active
			self.waitmin2 = self.skinloop;	// Loop fixed amount
		}
	} else {
		if (self.pos2_z > 0 && self.skin != self.pos2_z) self.skin = self.pos2_z; // Check for new skin numbers and only change if needed
	}

	if (!VectorIsAllZeros(self.rotateangles)) { // ROTATION animation loops setup
		if (self.rotateloop == MMLOOP_TOGGLE) { // Toggle cannot switch off animation state because other types.  (frame/skin/rotate) maybe active and animating.
			if (self.state == STATE_ON) { // TOGGLE OFF rotation loop ONLY!
				self.waitmin3 = 0;
				if (self.noise2 != "") sound(self,CHAN_VOICE, self.noise2, self.volume,ATTN_NORM); // Play OFF sound
			} else { // TOGGLE ON
				self.state = STATE_ON;	// Animation active
				self.waitmin3 = -1;		// Constant loop
				if (self.noise1 != "") sound(self,CHAN_VOICE, self.noise1, self.volume,ATTN_NORM); // Play ON sound
			}
		} else if (self.rotateloop == MMLOOP_CONSTANT) { // Only switch on for constant if inactive
			self.state = STATE_ON;	// Animation active
			self.waitmin3 = -1;		// Constant loop
		} else if (self.rotateloop == MMLOOP_TRIGGER) { // Animation for ONE time and stop
			trigsound = TRUE;		// Check for trigger sound
			self.state = STATE_ON;	// Animation active
			self.waitmin3 = 1;		// Loop once
		} else if (self.rotateloop >= 1) { // Animation for fixed amount of time (cycles)
			trigsound = TRUE;				// Check for trigger sound
			self.state = STATE_ON;			// Animation active
			self.waitmin3 = self.rotateloop;// Loop fixed amount
		}
	}

	if (self.yaw_speed > 0 && self.state == STATE_OFF) self.state = STATE_ON; // Any movement required for loop? If active, ignore retry
	if (trigsound == TRUE && self.noise != "") sound(self,CHAN_VOICE, self.noise, self.volume,ATTN_NORM); // Check for TRIGGER sound
	if (self.state == STATE_ON) misc_model_loop(); // Are there any animation loops setup?
};

void() misc_model_fade = { // [FUNCTION]
    self.owner.alpha = (time - self.owner.ltime) / self.alphastart; // Keep increasing alpha
    if (self.owner.alpha > 1) self.owner.alpha = 1; // Check for exit conditions
    else self.nextthink = time + FADEMODEL_TIME; // Keep looking, really fast!
};

void() misc_model_loopreset = { self.waitmin = self.waitmin2 = self.waitmin3 = 0; }; // [FUNCTION], Reset animation loop counters

void() misc_model_on = { // [FUNCTION]
	local float checkanim;
	
	if (self.spawnflags & MISC_MOVEMENT) spawn_marker(self.origin+'0 0 16','0 0 0',0,3); // Highlight movement models with dev diamond above model
	
	// Check if there is any spawn/on delay setup.  Useful for delay spawning models on to platform/doors.
	if (self.delay > 0) {
		self.think = misc_model_on; // Feed back into this function
		self.nextthink = time + self.delay;
		self.delay = 0; // The delay only works once.
		return;
	}
	
	// Setup any ALPHA fade in functionality
	if (self.alphastart >= 1 && self.attachment) {
		self.alpha = 0.01;		// Starting value (can't be zero)
		self.attachment.think = misc_model_fade;
		self.attachment.nextthink = time + 0.01;
		self.attachment.alphastart = self.alphastart;
		self.ltime = time;		// Setup local timer
		self.alphastart = 0;	// Only ONCE
	}

	self.estate = ESTATE_ON; // Enable model
	setmodel(self, self.mdl);
	
	// Restore model/size and check if collision needed
	if (self.spawnflags & MISC_COLLISION) {
		self.solid = SOLID_BBOX;
		if (VectorIsAllZeros(self.bbmins) && VectorIsAllZeros(self.bbmaxs)) setsize (self, self.mins , self.maxs); // Use model default size
		else setsize (self, self.bbmins , self.bbmaxs); // Override defaults with custom sizes
	} else setsize (self, VEC_ORIGIN, VEC_ORIGIN);
	
	setorigin(self, self.oldorigin + self.view_ofs); // Move model to exact location (allow for offset)

	// Is the model on a mover (func object)
	if (self.spawnflags & MISC_MOVEMENT) {
		self.movetype = MOVETYPE_TOSS; // Turn misc model into an item (can work with plats/doors)
		self.solid = SOLID_TRIGGER;
		setsize (self, VEC_ORIGIN, VEC_ORIGIN);
		self.velocity = '0 0 0';
		self.origin_z = self.origin_z + 1; // Make sure the misc model starts on the ground
		if (!droptofloor()) {
			dprint ("\n\b[Model]\b "); dprint (self.mdl); dprint (" stuck at ("); dprint (vtos(self.origin)); dprint ("), made non-solid.\n");
			self.solid = SOLID_NOT;
			self.movetype = MOVETYPE_NONE;
			return;
		} 
		self.touch = SUB_Null; // Make sure no touch function is active
		self.oldorigin = self.origin; // Save original for later on/off functions
	}

	misc_model_loopreset(); // Reset loop counters
	checkanim = FALSE;
	if (self.spawnflags & MISC_MDLSETUP) { // First time setup to cope with precise ANIMATION setup ON/OFF
		self.spawnflags = self.spawnflags - (self.spawnflags & MISC_MDLSETUP); // Remove the setup spawnflags, used only once
		if (self.state == STATE_ON) {
			checkanim = TRUE;
			if (self.frameloop == MMLOOP_TOGGLE) self.state = STATE_OFF; // TOGGLE requires opposite starting state to start ON
			else if (self.skinloop == MMLOOP_TOGGLE) self.state = STATE_OFF;
			else if (self.rotateloop == MMLOOP_TOGGLE) self.state = STATE_OFF;
		}
	} else if (self.aflag == TRUE) checkanim = TRUE; // DEFAULT Check animations if they exist (aflag)
	
	if (self.yaw_speed > 0) checkanim = TRUE; // If movement setup (target) start model loop
	if (checkanim == TRUE) misc_model_use(); // Are there any animation loops to setup?
	else {
		if (self.pos1_z < 0) self.frame = self.pos1_x; // Exact frame/skin numbers (check for negatives)
		else self.frame = self.pos1_z;
		if (self.pos2_z < 0) self.skin = self.pos2_x;
		else self.skin = self.pos2_z;
	}
};

// Turn off model/world interaction
void() misc_model_off = { // [FUNCTION]
	self.estate = ESTATE_OFF;				// Switch off entity
	self.state = STATE_OFF;					// Switch off animations
	misc_model_loopreset();					// Reset loop counter
	self.model = "";				// hide bmodel surface
	self.movetype = MOVETYPE_NONE;			// Create baseline
	self.solid = SOLID_NOT;
	self.nextthink = 0;
	self.spawnflags = self.spawnflags - (self.spawnflags & MISC_MDLSETUP); // Remove the setup spawnflags, used only once
};

void() misc_model_reset = { // [FUNCTION]
	misc_model_loopreset();
	self.skin = self.pos2_x;
	self.frame = self.pos1_x;
	if (self.spawnflags & (MISC_STARTOFF | ENT_STARTOFF)) entity_state_off();
	else entity_state_on();
};

float(float minrange, float maxrange, float checker) misc_model_CheckRange = { // [FUNCTION]
	local float retrange;

	if (minrange == maxrange) return minrange; // Obvious parameter errors
	if (maxrange < minrange) return maxrange;
	if (checker < minrange) retrange = minrange; // Double check the FRAME is within the specified range
	else if (checker > maxrange) retrange = maxrange;
	else retrange = checker; // No change, within range
	return retrange; // Final_Final_Final result!
};

// QUAKED misc_model (1 .5 .25) (-16 -16 -16) (16 16 16) x COLLISION MOVEMENT DROPFLOOR x STATIC STARTOFF x Not_Easy Not_Normal Not_Hard Not_DM
// -------- KEYS --------
// targetname  : toggle state (use trigger ent for exact state)
// mdl         : specify model to load, full path (progs/candle.mdl)
// angle       : facing angle of model (-1 = random position)
// angles      : 'pitch yaw roll' up/down, angle, tilt left/right 
// ideal_yaw   : = 1 Setup model with random Y axis rotation
// frame       : exact frame number (Quoth entity compatibility)
// skin        : exact skin number (Quoth entity compatibility)
// mangle      : 'pitch yaw roll' override (Quoth entity compatibility)
// view_ofs    : Extra offset for origin (ideal for light origin issues)
// delay       : Spawning delay for models on func movers (works once)
// sounds      : TRIGGER 1=Secret, 2=talk, 3=switch, 4=silent, 5=custom, 6=secret2
// noise       : Custom sound to play with animation TRIGGER
// locksounds  : TOGGLE 1=laser, 2=power, 4=silent, 5=custom
// noise1      : Custom sound to play when animation TOGGLE ON
// noise2      : Custom sound to play when animation TOGGLE OFF
// volume      : Volume for all custom sounds played (def=1, range=0-1)
// lip         : Frame/skin animation direction -2=random, -1=back, 1=forward(def)
// state       : Automatic start of frame/skin animations (0=ON, -1/1=OFF)
// speed       : Override for frame/skin animation speed (def=0.1s)
// pos1        : FRAME basic and range parameters
               // X=0, Y=0, Z=exact frame number
               // X->Y, Z=0 Randomly pick a frame from the X,Y range
               // X->Y, Z=-1 Animate between the X,Y range
// pos2        : SKIN basic and range parameters
               // X=0, Y=0, Z=exact skin number
               // X->Y, Z=0 Randomly pick a skin from the X,Y range
               // X->Y, Z=-1 Animate between the X,Y range
// framestart  : FRAME Starting point, 0=def, X=-1 Random, X=0+ Exact
// frameloop   : FRAME type, 0=Constant, 1+=Range+stop, -1=Toggle, -2=Trigger+wait
// skinstart   : SKIN Starting point, 0=def, X=-1 Random, X=0+ Exact
// skinloop    : SKIN type, 0=Constant, 1+=Range+stop, -1=Toggle, -2=Trigger+wait
// rotateloop  : ROTATE type, 0=Constant, 1+=Range+stop, -1=Toggle, -2=Trigger+wait
// rotateangles: ROTATE axis (XYZ) changing (+/-) angles over time
// alphastart  : ALPHA fade IN time for misc_model (1=Fade in over 1s)
// bbmins      : Model bounding box override (use with collision/dropfloor)
// bbmaxs      : Model bounding box override
// target      : Path_corner entities to start moving towards on spawn
// faceangle   : Turn model towards path_corner as it moves around (def=0)
// yaw_speed   : Turning speed of model towards path_corners (def=15)
// movespeed   : Movement speed of model towards path_corners (def=50)
// normalangle : 1=Turn the model towards the normal plane direction
// -------- SPAWNFLAGS --------
// COLLISION   : model bbox collision enabled
// MOVEMENT    : model can be moved around like an item
// DROPFLOOR   : Will drop to the floor below (terrain alignment)
// STATIC      : Turn entity into static upon spawn (frame 0)
// STARTOFF    : Always Starts off and waits for trigger
// -------- NOTES --------
// MDL files that can be setup with specific frame/skin and animate groups
void() misc_model = { // [ENTITY]
	if (!self.mdl) { dprint("\b[MISCMDL]\b Missing model to load. Making it a Shambler! ;) \n"); self.mdl = "progs/ad171/mon_shambler.mdl"; } // Is the model defined using the mdl key?
	if (self.sounds == 0) self.sounds = 5; // TRIGGER sound setup + volume (def=custom sound)
	trigger_bmodel_sounds();
	if (self.locksounds == 1) { // TOGGLE sound setup
		self.noise1 = "rrp/misc/laser_on.wav";
		self.noise2 = "rrp/misc/laseroff.wav";
	} else if (self.locksounds == 2) {
		self.noise1 = "ad171/ambience/power_on.wav";
		self.noise2 = "ad171/ambience/power_off.wav";
	}
	if (self.noise1 != "") precache_sound(self.noise1);
	if (self.noise2 != "") precache_sound(self.noise2);
	precache_model(self.mdl);
	self.classtype = CT_MISCMODEL;
	self.classgroup = CG_MISCENT;
	self.solid = SOLID_NOT;				// No world interaction
	self.movetype = MOVETYPE_NONE;		// Static item, no movement
	self.oldorigin = self.origin;		// Store for later
	self.estate = ESTATE_OFF; // Default entity states
	if (self.state == 0) self.state = STATE_ON; // Change default model state (def=on)
	else self.state = STATE_OFF;

	if (self.frame > 0) { self.pos1 = '0 0 0'; self.pos1_z = self.frame; } // Check for any skin/frame values (Quoth compatibility)
	if (self.skin > 0) { self.pos2 = '0 0 0'; self.pos2_z = self.skin; }
	if (!VectorIsAllZeros(self.mangle)) self.angles = self.mangle; // Check for a mangle override (Quoth compatibility)
	if (self.angles_y < 0 || self.ideal_yaw > 0) self.angles_y = rint(random()*360); // Random Rotation : UP/DOWN angle or use the ideal_yaw key
	self.mangle = self.angles; // Save angles (mangle not used)
	if (world.model == "maps/ad_sepulcher.bsp") { // MAP/CODE HACK Terrible way to fix this map.  If wrong engine then delete the misc_model detail).
		if (engine == ENG_DPEXT && ext_ftepart == FALSE) { remove(self); return; } // Running on DP engine?
		if (engine == ENG_FITZ) { remove(self); return; } // Running on Fitz (QS/MarkV) engines?
	}

	if (self.spawnflags & ENT_SPNSTATIC) {  // Check for static entity option first
		setmodel(self, self.mdl);
		if (self.pos1_z < 0) self.frame = self.pos1_x; // Exact frame/skin numbers (check for negatives)
		else self.frame = self.pos1_z;
		if (self.pos2_z < 0) self.frame = self.pos2_x;
		else self.skin = self.pos2_z;
		makestatic(self); // Goodbye entity!
		return;
	}

	self.aflag = FALSE; // No animation loops defined
	if (self.pos1_x != self.pos1_y) { // Has a FRAME range been defined?
		if (self.pos1_x > self.pos1_y) { // Make sure the range is the right way around.  X has to be the lowest number of the two (X/Y)
			self.frame_box = self.pos1_x;
			self.pos1_x = self.pos1_y;
			self.pos1_y = self.frame_box;
		}

		if (self.pos1_z == 0) { // Static FRAME range AND random pick
			if (self.pos1_x < 0) self.pos1_x = 0; // Double check lower limit is not negative
			self.pos1_z = SUB_RandomRange(self.pos1_x, self.pos1_y); // Find random range number
		} else { // Animated FRAME range
			self.pos1_z = NEGATIVE; // Always set this, only -1/0 are valid values
			self.aflag = TRUE;
			if (self.framestart == 0) self.framestart = self.pos1_x; // Default is start at beginning of range
			else if (self.framestart < 0) self.framestart = SUB_RandomRange(self.pos1_x, self.pos1_y); // Random starting position
			else self.framestart = misc_model_CheckRange(self.pos1_x, self.pos1_y, self.framestart); // Exact starting position
		}
	} else {
		if (self.pos1_z < 1) self.pos1 = '0 0 0'; // If no exact FRAME bas specified, reset FRAME to default = 0.
	}

	if (self.pos2_x != self.pos2_y) { // Has a SKIN range been defined?
		if (self.pos2_x > self.pos2_y) { // Make sure the range is the right way around.  X has to be the lowest number of the two (X/Y)
			self.frame_box = self.pos2_x;
			self.pos2_x = self.pos2_y;
			self.pos2_y = self.frame_box;
		}

		if (self.pos2_z == 0) { // Static SKIN range AND random pick
			if (self.pos2_x < 0) self.pos2_x = 0; // Double check lower limit is not negative
			self.pos2_z = SUB_RandomRange(self.pos2_x, self.pos2_y); // Find random range number + range checks
		} else { // Animated SKIN range
			self.pos2_z = NEGATIVE; // Always set this, only -1/0 are valid values
			self.aflag = TRUE;
			if (self.skinstart == 0) self.skinstart = self.pos2_x; // Default is start at beginning of range
			else if (self.skinstart < 0) self.skinstart = SUB_RandomRange(self.pos2_x, self.pos2_y); // Random starting position
			else self.skinstart = misc_model_CheckRange(self.pos2_x, self.pos2_y, self.skinstart); // Exact starting position
		}
	} else {
		if (self.pos2_z < 1) self.pos2 = '0 0 0'; // If no exact SKIN bas specified, reset SKIN to default = 0
	}

	if (!VectorIsAllZeros(self.rotateangles)) self.aflag = TRUE; // Any rotation angle setup?
	
	
	if (self.aflag == TRUE) { // Setup DEFAULT animation direction, speed and status
		if (self.speed < 0.05) self.speed = 0.1; // Default animation speed.
		if (self.lip <= -2) self.lip = -2;			// Check for animation diection errors, Randomly pick
		else if (self.lip >= 0) self.lip = TRUE;	// Def = forward (1)
		
		if (self.lip == -2) { // Randomly pick direction
			if (random() < 0.5) self.lip = NEGATIVE;
			else self.lip = TRUE;
		}
		
		self.spawnflags = self.spawnflags | MISC_MDLSETUP; // Special first time run setup for frame/skin/rotate loops

		// Check animation looping types are valid 0=Constant, 1+=Range+Stop, -1=Toggle, -2=Trigger+Wait
		if (self.frameloop < -2) self.frameloop = MMLOOP_CONSTANT;
		else self.frameloop = rint(self.frameloop);
		if (self.skinloop < -2) self.skinloop = MMLOOP_CONSTANT;
		else self.skinloop = rint(self.skinloop);
		if (self.rotateloop < -2) self.rotateloop = MMLOOP_CONSTANT;
		else self.rotateloop = rint(self.rotateloop);

		self.frame = self.framestart; // Setup first frame/skin position
		self.skin = self.skinstart;
	}
	
	if (self.target != "") { // Check for any path_corner movement?
		if (self.yaw_speed < 1) self.yaw_speed = 15; // Setup turning/move speed defaults
		if (self.movespeed < 1) self.movespeed = 50;
		self.delay = 0.1; // Cannot start moving on first frame, entity list not setup.  Wait 1 frame before searching for path_corner target.
		if (self.speed < 0.05) self.speed = 0.1; // Setup default animation speed (def=0.1)
		self.spawnflags = self.spawnflags - (self.spawnflags & MISC_MOVEMENT); // Cannot have movement + static for path_corner targets
		self.spawnflags = self.spawnflags - (self.spawnflags & ENT_SPNSTATIC);
	} else self.yaw_speed = 0; // no movement checks

	if (self.spawnflags & MISC_MOVEMENT) { // Cannot have movement AND static at the same time!
		self.spawnflags = self.spawnflags - (self.spawnflags & ENT_SPNSTATIC);
		if (self.delay <= 0) self.delay = 0.2; // make sure any func movers have spawned beforehand
	}
	
	if (self.spawnflags & MISC_DROPTOFLOOR) { // Check for drop to floor functionality
		self.movetype = MOVETYPE_TOSS; // Turn misc model into an item so it can fall down
		self.solid = SOLID_BBOX;
		setmodel(self, self.mdl);
		if (VectorIsAllZeros(self.bbmins)) setsize (self, VEC_ORIGIN, VEC_ORIGIN); // Check for any bounding box override (check min only).  Don't use model default, its usually broken or wrong.  Use a zero size so the model origin drops perfectly.
		else setsize (self, self.bbmins , self.bbmaxs); // Override defaults with custom sizes

		self.velocity = '0 0 0'; // Make sure no onspawn velocity
		if (VectorIsAllZeros(self.facevector)) self.facevector = '-90 0 0'; // Default surface normal is flat so check for default modifier
		traceline(self.origin, self.origin-'0 0 1024', FALSE, self); // Trace a line downward to get the surface normal
		self.origin_z = self.origin_z + 6; // Drop the model to the ground
		droptofloor();
		self.oldorigin = self.origin; // Save original for later on/off functions
		if (self.normalangle > 0) { // Normal plane facing angle required?
			// trace_plane_normal is always facing outward from ground surface
			// If turned into a model angle at this point it would be facing up!
			// Convert the trace plane normal into a facing angle
			self.finalangle = vectoangles(trace_plane_normal);
			// Take previous Yaw angle (could be random rotation)
			// Add 180 because v_up is opposite to regular angle stuff
			self.finalangle_z = anglemod(self.angles_y+180);
			// Flip X axis because its Quake C! ;)
			self.finalangle_x = -self.finalangle_x;
			// Turn into a v_forward/v_right/r_up vector set
			// v_forward is the original trace_plane_normal angle upward
			// v_right/v_up are on the norm surface, but 90 degrees apart
			makevectors(self.finalangle);
			self.angles = vectoangles(v_up);
		}
	}
	
	// Setup any ALPHA fade in functionality
	if (self.alphastart >= 1) {
		self.attachment = spawn();
		self.attachment.owner = self;
		self.attachment.origin = self.origin;	
		self.alpha = 0.01; // Starting value (can't be zero)
	}
	
	// Setup Entity State functionality
	if (self.targetname != "") self.use = entity_state_use;
	if (self.aflag == TRUE) self.estate_use = misc_model_use;
	self.estate_on = misc_model_on;
	self.estate_off = misc_model_off;
	self.estate_reset = misc_model_reset;
	if (self.spawnflags & (MISC_STARTOFF | ENT_STARTOFF)) entity_state_off();
	else entity_state_on();
};

void() misc_gtkmodel = { misc_model(); };  // [ENTITY], Re-direct, allows GTK editors to work with Q1 assets easier.

void() mapobject_custom = { self.mdl = self.model; misc_model(); };  // [ENTITY], Quoth Re-direct old custom model system to AD.
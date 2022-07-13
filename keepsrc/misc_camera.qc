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
// Function count: 18
//
// Implements: Cinematic Camera System
//
// Description:
// Cinematic camera control functions.
// camera_controller_cshift	- Updates console with new cshift parameters
// camera_tracking_finish		- Finish camera tracking movement 
// camera_controller_think		- Main cinematic controller loop
// camera_controller_setup		- Setup controller, movement and fakeplay ents
// misc_camera_use				- Trigger function for camera's
// misc_camera_colcheck			- Way to validate RGB background colours
// misc_camera					- Spawning function for camera system
//=============================================================================

float CINECAM_FUNC_PLAYER = 1;	// Camera spawnflags.  Setup fake player model
float CINECAM_FUNC_SKIPABLE = 2;// Allow cinematic to be skipable
float CINECAM_FUNC_FADEOUT = 4;	// Fade OUT pevious camera
float CINECAM_FUNC_FADEIN = 8;	// Fade IN next camera
float CINECAM_FUNC_FIXEDANGLE = 16;	// First camera defines fixed angle
float CINECAM_FUNC_ENDCAMERA = 32;	// Fade in/out only, no org/ang
float CINECAM_MINSHIFT = 0;		// v_cshift min/max values.  Minimun value for density
float CINECAM_MAXSHIFT = 255;	// Maximm value for density 
float CINECAM_FADEUP = 1;		// Fading directions
float CINECAM_FADEDOWN = 2;
float CINECAM_CONTIME = 0.05;	// Camera Controller loop tick rate (speed)
float CINECAM_OFF = 0;			// Camera System states.  Waiting for a camera
float CINECAM_STARTUP = 4;		// Save client info and start sequence
float CINECAM_FADEOUT = 6;		// Start fading out current view
float CINECAM_NEXTCAM = 8;		// Switch camera and focus
float CINECAM_FADEIN = 10;		// Start fading in current camera
float CINECAM_MESSAGE = 14;		// Show messages and setup timers
float CINECAM_WAIT = 16;		// Waiting player input
float CINECAM_EXIT = 20;		// Back to player position
float CINECAM_FADE = 25;		// Fade in or out camera
float CINECAM_SEQ_FIRST = 1;	// Camera Sequence number.  Starting with the player camera
float CINECAM_SEQ_ACTIVE = 2;	// Camera sequence now active
float CINECAM_SEQ_LAST = 4;		// Going back to player camera
float CINECAM_SKIP_OFF = 0;		// Camera Skip conditions.  No skip function available
float CINECAM_SKIP_ACTIVE = 1;	// Waiting for buttons (fire/jump)
float CINECAM_SKIP_DONE = 2;	// Cinematic finished, exit Asasp
float CINECAM_FIXANGLE_OFF = 0;		// Always reset camera angle
float CINECAM_FIXANGLE_ACTIVE = 1;	// Read first angle only
float CINECAM_FIXANGLE_DONE = 2;	// First angle read and done

void(entity targ, vector cs_col, float cs_den) camera_controller_cshift = { // [FUNCTION]
	Safe_stuffcmd(targ, "v_cshift ");
	Safe_stuffcmd(targ, ftos(rint(cs_col_x))); Safe_stuffcmd(targ, " ");
	Safe_stuffcmd(targ, ftos(rint(cs_col_y))); Safe_stuffcmd(targ, " ");
	Safe_stuffcmd(targ, ftos(rint(cs_col_z))); Safe_stuffcmd(targ, " ");
	Safe_stuffcmd(targ, ftos(rint(cs_den))); Safe_stuffcmd(targ, "\n");	
};

void() camera_tracking_finish = { // [FUNCTION]
	self.attack_finished = 0;
	self.velocity = '0 0 0';
};

float(entity targ) camera_check_buttons = { return ((targ.flags & FL_CLIENT) && (targ.button0 || targ.button1 || targ.button2)); }; // [FUNCTION], Check client + buttons, true if player and any button is pressed.

void(entity targ) camera_check_skip = { // [FUNCTION]
	if (cam_exit == CINECAM_SKIP_ACTIVE) { // Is cinematic skip function enabled?
		if (camera_check_buttons(targ)) { // Check for exit condition buttons (fire/jump)
			if (targ.flags & FL_CLIENT) targ.button0 = targ.button1 = targ.button2 = 0; // Don't need buttons anymore
			cam_exit = CINECAM_SKIP_DONE; // Start to exit cinematic ASAP
		}
	}
};

float(float cam_angle1, float cam_angle2) camera_check_anglezero = { // [FUNCTION]
	local float cam_anglesmall, cam_anglelarge, cam_angledist, cam_anglewrap; // Smallest / Largest camera angle, Camera small/large angle distance and wrap distance
	
	cam_anglelarge = mathlib_max(cam_angle1, cam_angle2); // Guard against interpolating across the 360<->0 discontinuity
	cam_anglesmall = mathlib_min(cam_angle1, cam_angle2);
	cam_angledist = cam_anglelarge - cam_anglesmall; // This is the distance between the yaws if we don't cross 360.
	cam_anglewrap = (360 - cam_anglelarge) + cam_anglesmall; // This is the distance if we do cross 360. i.e. "359" and "1" would have an angle_wrap of "2" and direct_dist of "358".
	if (cam_anglewrap < cam_angledist) return TRUE; // Is it shorter to cross the 360<->0 boundary?
	else return FALSE;
};

float(float baxis_start, float baxis_control, float baxis_end, float baxis_time) bezier_axis = { // [FUNCTION]
	local float baxis_1, baxis_2, baxis_3, baxis_return;

	baxis_1 = ((1 - baxis_time) * (1 - baxis_time)) * baxis_start; // Work out bezier curve position 
	baxis_2 = ((2 * baxis_time) * (1 - baxis_time)) * baxis_control;
	baxis_3 = (baxis_time * baxis_time) * baxis_end;
	baxis_return = baxis_1 + baxis_2 + baxis_3; // Add up parts and return result
	return baxis_return;
};

vector(vector bez_start, vector bez_control, vector bez_end, float bez_timemax, float bez_timeleft) bezier_curve = { // [FUNCTION]
	local vector bez_result;
	local float bez_time;

	bez_time = bez_timeleft / bez_timemax; // Normalize (0-1) the time value
	if (bez_time <= 0) bez_time = 0; // Make sure time is within normalized range (0-1)
	if (bez_time >= 1) bez_time = 1;
	bez_result_x = bezier_axis(bez_start_x, bez_control_x, bez_end_x, bez_time); // Work out each vector (XYZ) axis
	bez_result_y = bezier_axis(bez_start_y, bez_control_y, bez_end_y, bez_time);
	bez_result_z = bezier_axis(bez_start_z, bez_control_z, bez_end_z, bez_time);
	return bez_result;
};

// Bezier curve debug system (developer = 1 only).  Display the curve with yellow diamonds.
void() misc_camera_bezier_debug = { // [FUNCTION]
	if (self.nodebuginfo == TRUE) return; // Block debug info regardless (help reduce ents)

	self.attachment2 = find(world, targetname, self.controltarget); // Find the bezier curve CONTROL point
	self.attachment3 = find(world, targetname, self.target); // Find the bezier curve END point
	spawn_marker(self.origin,'0 0 0',0,SPNMARK_RED); // Display debug markers for start/control/end locations
	spawn_marker(self.attachment2.origin,'0 0 0',0,SPNMARK_GREEN);
	spawn_marker(self.attachment3.origin,'0 0 0',0,SPNMARK_RED);
	self.cnt = 0.1;
	while (self.cnt < 1) { // Loop through 10 points on each bezier curve
		self.finalangle = bezier_curve(self.origin, self.attachment2.origin, self.attachment3.origin, 1, self.cnt); // Work out bezier curve vector position
		spawn_marker(self.finalangle,'0 0 0',0,SPNMARK_YELLOW); // Spawn debug marker (yellow is wrong colour!)
		self.cnt = self.cnt + 0.1;
	}
};

// Main loop for cinematic controller (all states)
void() camera_controller_think = { // [FUNCTION]
	self.think = camera_controller_think;
	self.nextthink = time + CINECAM_CONTIME;

	// Check first if camera/client are setup
	if (cam_active == CINECAM_SETUP) {
		// Check there is a camera to focus on
		if (cam_focus.classtype != CT_MISCCAM) cam_active = CINECAM_OFF;
		else if (!(cam_client.flags & FL_CLIENT)) cam_active = CINECAM_OFF;
		else cam_active = CINECAM_STARTUP;
	}
	
	// Save player details and start cinematic system
	if (cam_active == CINECAM_STARTUP) {
		cinematic_running = TRUE; // Cinematic time!
		cam_locked = FALSE;		// No angle update
		cam_movement = FALSE;	// No movement tracking
		cam_fakeplay = FALSE;	// The invisible man
		cam_angle = '0 0 0';	// Reset angles
		cam_lastanglevalid = FALSE;	// Reset angle smoothing
		self.attachment = self.attachment2 = world; // Reset player location markers

		// Check for fake player model on first camera in chain
		if (cam_focus.spawnflags & CINECAM_FUNC_PLAYER) {
			cam_fakeplay = TRUE; // fake player model active
			if (cam_focus.modeltarget != "") { // Check for special player location entity
				self.attachment = find(world, targetname, cam_focus.modeltarget);
				if (self.attachment) { // Found the target entity?
					if (developer > 0 && !self.nodebuginfo) {
						spawn_marker(self.attachment.origin,'0 0 0',0,SPNMARK_RED); // Spawn a dev marker (can be blocked)
					}
					if (self.attachment.classtype == CT_MISCTELEPORT) { // Info_teleport_destination are fined tuned for trig_teleport
						self.attachment.origin = self.attachment.origin - '0 0 27';
						self.attachment.angles = self.attachment.mangle;
					}
				}
			}
		}

		// Check for any special returning position for the player
		if (cam_focus.returntarget != "") {
			self.attachment2 = find(world, targetname, cam_focus.returntarget);
			if (self.attachment2) { // Found the target entity?
				if (developer > 0 && !self.nodebuginfo) {
					spawn_marker(self.attachment2.origin,'0 0 0',0,SPNMARK_RED); // Spawn a dev marker (can be blocked)
				}
				// Info_teleport_destination are fined tuned for trig_teleport
				if (self.attachment2.classtype == CT_MISCTELEPORT) {
					self.attachment2.origin = self.attachment2.origin - '0 0 27';
					self.attachment2.angles = self.attachment2.mangle;
				}
			}
		}
		
		// Check for any exit/finished cinematic trigger(s)
		if (cam_focus.deathtarget == "") self.deathtarget = "";
		else self.deathtarget = cam_focus.deathtarget;

		// Check for cinematic skip functionality
		if (cam_focus.spawnflags & CINECAM_FUNC_SKIPABLE) cam_exit = CINECAM_SKIP_ACTIVE;		// Chck for button inputs
		else cam_exit = CINECAM_SKIP_OFF;		// No skip function

		// Check for constant fixed angles on all cameras
		if (cam_focus.spawnflags & CINECAM_FUNC_FIXEDANGLE) cam_fixangle = CINECAM_FIXANGLE_ACTIVE;	// Read first camera
		else cam_fixangle = CINECAM_FIXANGLE_OFF;	// Reset everytime

		cam_hudsize = cvar("viewsize"); // Save the current HUD settings for later
		cam_crosshair = cvar("crosshair");
		
		// Save player parameters
		self.pos4 = cam_client.origin;			// Model/entity location
		self.pos5 = cam_client.view_ofs;		// Origin offset
		self.pos6 = cam_client.velocity;		// Movement (Not used)
		self.finalangle = cam_client.angles;	// Model angle
		self.finaldest = cam_client.v_angle;	// Viewing angle
		self.weapon = cam_client.weapon;		// Current weapon
		self.currentammo = cam_client.currentammo;
		self.weaponmodel = cam_client.weaponmodel;
		self.weaponframe = cam_client.weaponframe;

		// Stop player falling/interacting with world
		cam_client.takedamage = DAMAGE_NO;
		cam_client.solid = SOLID_NOT;
		cam_client.movetype = MOVETYPE_NONE;
		setsize(cam_client, VEC_ORIGIN, VEC_ORIGIN);
		cam_client.velocity = cam_client.avelocity = '0 0 0'; // Stop any further movement (will translate to cinematics)
		cam_sequence = CINECAM_SEQ_FIRST; // Fade out of first camera (player)
		if (cam_startup) cam_active = CINECAM_NEXTCAM; // Skip the fade out from player camera for spawning players
		else cam_active = CINECAM_FADEOUT; // Start with fading out current player camera
	}

	// Sort out wait timers, centerprint messages and sounds
	if (cam_active == CINECAM_MESSAGE) {
		// Is cinematic skip done?
		if (cam_exit != CINECAM_SKIP_DONE) {
			// Check for any wait parameters (-1=wait for trigger)
			if (cam_focus.wait < 0) self.attack_finished = -1;
			else if (cam_focus.wait == 0) self.attack_finished = 0;
			else self.attack_finished = time + cam_focus.wait;
			
			// Center print message to display?
			if (cam_focus.message) {
				centerprint(cam_client, cam_focus.message);
				sound(cam_client,CHAN_VOICE, cam_focus.noise,1,ATTN_NORM); // Default talk sound(using sounds entity key)
			}
		}
		// Wait for player input or timer
		self.pain_finished = FALSE;
		cam_active = CINECAM_WAIT;
	}

	// Wait for timer or player input
	if (cam_active == CINECAM_WAIT) {
		// Is cinematic skip in progress?
		if (cam_exit == CINECAM_SKIP_DONE) {
			// Exit as quick as possible (no fading)
			cam_active = CINECAM_NEXTCAM;
			cam_sequence = CINECAM_SEQ_LAST;
		} else {
			// Waiting for a key press (jump/fire/use)
			// This has to be done before camera_check_skip
			// Otherwise the button values are reset
			if (self.attack_finished == -1) {
				if (camera_check_buttons(cam_client)) { // Any buttons pressed? (fire/jump)
					if (cam_client.flags & FL_CLIENT) cam_client.button0 = cam_client.button1 = cam_client.button2 = 0;
					self.pain_finished = TRUE;
				}
			} else if (self.attack_finished < time) self.pain_finished = TRUE; // Has the wait timer expired?
			else camera_check_skip(cam_client); // Check for skip functionality
		
			// Time to exit current camera?
			if (self.pain_finished) {
				// fade out current camera view angle
				cam_active = CINECAM_FADEOUT;
				self.pain_finished = FALSE;
				
				// Is there another camera?
				if (cam_focus.target == "") {
					// End of sequence, back to player
					cam_sequence = CINECAM_SEQ_LAST;
				} else {
					// search for target camera
					self.enemy = find(world, targetname, cam_focus.target);
					// Found a misc camera?
					if (self.enemy.classtype == CT_MISCCAM) {
						self.enemy.movetarget3 = cam_focus;
						cam_focus = self.enemy;
					} else cam_sequence = CINECAM_SEQ_LAST; // Next target is not a camera!?!
				}
			}
		}
	}

	// Fade OUT camera (player if first camera)
	if (cam_active == CINECAM_FADEOUT) {
		// Check if fade out is active (spawnflags)
		if (cam_focus.spawnflags & CINECAM_FUNC_FADEOUT) { // Start fading player view out to solid colour
			self.lip = CINECAM_MAXSHIFT / (cam_focus.waitmin / CINECAM_CONTIME); // Work out cshift density steps
			cam_colour = cam_focus.pos1;		// Fade In background
			self.count = CINECAM_MINSHIFT;		// Initial density
			self.cnt = CINECAM_FADEUP;			// Fade direction
			self.state = CINECAM_NEXTCAM;		// Next function
			cam_active = CINECAM_FADE;			// Start fade process
		}
		else cam_active = CINECAM_NEXTCAM;
	}
	
	// Switch to next camera (player if last camera)
	if (cam_active == CINECAM_NEXTCAM) {
		if (cam_focus.spawnflags & CINECAM_FUNC_FADEIN) camera_controller_cshift(cam_client, cam_focus.pos1, CINECAM_MAXSHIFT); // If fading IN active, update background colour before switch
		if (cam_focus.spawnflags & CINECAM_FUNC_ENDCAMERA) cam_sequence = CINECAM_SEQ_LAST; // Check for end of camera chain functionality
		
		// Check for last camera (back to player)
		if (cam_sequence == CINECAM_SEQ_LAST) {
			// Restore hud (saved in startup section)
			cvar_set("viewsize", ftos(cam_hudsize));
			cvar_set("crosshair", ftos(cam_crosshair));
			
			// Hide fake player entity
			cam_player.state = FALSE;
			setmodel(cam_player, MODEL_EMPTY);
			setsize(cam_player, VEC_ORIGIN, VEC_ORIGIN);
			cam_player.frame = 0;

			// Restore player core parameters
			setmodel(cam_client, MODEL_PLAYER);
			modelindex_player = cam_client.modelindex;
			setsize (cam_client, cam_client.bbmins, cam_client.bbmaxs);
			cam_client.solid = SOLID_SLIDEBOX;
			cam_client.movetype = MOVETYPE_WALK;
		
			// Check for return location entity
			if (self.attachment2) {
				// Read target entity (often has angle key)
				self.dest2 = self.attachment2.origin;
				self.dest3 = self.attachment2.angles;
			}
			else {
				// read origin/angles from player
				self.dest2 = self.pos4;
				self.dest3 = self.finaldest;
			}

			// Restore player origin/ofset parameters
			setorigin(cam_client, self.dest2);
			cam_client.view_ofs = self.pos5;
			// Do not restore the player with velocity as it can lead
			// to some unexpected deaths and chance of being stuck
			// Better to zero velocity so that the player can adjust
			cam_client.velocity = cam_client.avelocity = '0 0 0';
			// Restore weapon/ammo HUD stuff
			cam_client.weapon = self.weapon;
			cam_client.currentammo = self.currentammo;
			cam_client.weaponmodel = self.weaponmodel;
			cam_client.weaponframe = self.weaponframe;

			// Update player angles
			cam_angle = self.dest3;
			cam_client.angles = cam_client.v_angle = cam_angle;
			cam_client.angles_z = 0;	// No drunk camera angles
			cam_client.fixangle = TRUE;
			
			// Let the player move around before the fade has finished
			// Otherwise it will feel like the controls are broken
			cam_locked = FALSE;
			cam_movement = FALSE;
			cam_bezier = FALSE;
		} else { // Switch to Next cinematic camera
			setorigin(cam_client, cam_focus.origin);
			cam_client.view_ofs = cam_focus.view_ofs;
			if (cam_focus.angleblend <= 0 || cam_focus.angleblend >= 1) cam_focus.angleblend = CINECAM_ANGLEBLEND; // Setup Camera angle blend fraction
			cam_locked = TRUE; // Lock player viewing angle (done via PlayerPreThink).  Stops the player moving the cursor/head around.
			
			// Movement of Camera (Bezier)
			if (cam_focus.controltarget != "") {
				self.enemy = find(world, targetname, cam_focus.controltarget); // search for Control Point entity (info_target)
				self.oldenemy = find(world, targetname, cam_focus.target); // Need to know next camera location for bezier maths
				
				// Found a control AND next camera entity?  Must find both of these because of the math formula.
				if (self.enemy && self.oldenemy) {
					if (developer > 0) { // Show movement tracking entity
						setmodel(cam_track, MODEL_BROKEN); // Use the yellow diamond model
						setsize(cam_track, VEC_ORIGIN, VEC_ORIGIN);
					}

					cam_track.origin = cam_focus.origin; // Reset movement origin to starting position
					
					// Is the time or movement is too small?
					if (cam_focus.waitmin3 <= 0.1 || self.enemy.origin == cam_focus.origin) { // Move directly to movement location
						setorigin(cam_client, cam_focus.origin);
						cam_movement = FALSE;
					} else {  // Setup camera tracking entity to start at client
						setorigin(cam_track, cam_focus.origin);
						cam_track.angles = cam_focus.angles;
						cam_track.pos4 = cam_focus.origin; // Keep track of bezier curve start/control/end
						cam_track.pos5 = self.enemy.origin;
						cam_track.pos6 = self.oldenemy.origin;
						cam_track.wait = cam_focus.waitmin3;
						cam_track.velocity = '0 0 0';
						
						// The exact position of where the camera should be on the bezier curve can be calculated. Just need to move the origin instead of relying on velocity movement.
						cam_track.attack_finished = time + cam_track.wait;
						cam_track.think = camera_tracking_finish;
						cam_track.nextthink = time + cam_track.wait;
						cam_movement = TRUE; // Allow for updates (done via PlayerPreThink)
						cam_bezier = TRUE; 
					}
				}
			} else if (cam_focus.sighttarget != "") { // Movement of Camera (Linear)
				self.enemy = find(world, targetname, cam_focus.sighttarget); // search for target entity (info_target)
				if (self.enemy) { // Found a target?
					if (developer > 0) { // Show movement tracking entity
						setmodel(cam_track, MODEL_BROKEN); // Use the yellow diamond model
						setsize(cam_track, VEC_ORIGIN, VEC_ORIGIN);
					}

					// Is the time or movement is too small?
					if (cam_focus.waitmin3 <= 0.1 || self.enemy.origin == cam_focus.origin) {
						setorigin(cam_client, cam_focus.origin); // Move directly to movement location
						cam_movement = FALSE;
					} else {
						setorigin(cam_track, cam_focus.origin); // Setup camera tracking entity to start at client
						cam_track.angles = cam_focus.angles;
						cam_track.enemy = self.enemy; // Keep track of direction target entity
						cam_track.pos1 = cam_track.enemy.origin - cam_focus.origin; // Find out vector difference between two points
						cam_track.velocity = cam_track.pos1 * (1 / cam_focus.waitmin3); // velocity = vector difference * traveltime (waitmin3)
						
						// Setup switch off functionality
						// The camera tracking entity is set to noclip movetype
						// which means the velocity needs to be stopped otherwise
						// the entity will just keep moving forward
						cam_track.attack_finished = time + cam_focus.waitmin3;
						cam_track.think = camera_tracking_finish;
						cam_track.nextthink = time + cam_focus.waitmin3;
						cam_movement = TRUE; // Allow for updates (done via PlayerPreThink)
						cam_bezier = FALSE;
					}
				}
			}
			
			// Has the camera angletarget been setup?
			if (cam_fixangle != CINECAM_FIXANGLE_DONE) {
				if (cam_fixangle == CINECAM_FIXANGLE_ACTIVE) cam_fixangle = CINECAM_FIXANGLE_DONE; // Only update angles once per camera chain
				if (cam_focus.angletarget != "") { // Check for any special angle target setup?
					TargetMovedir(cam_focus, TRUE); // Find angle target of camera and return results: movetarget = angletarget entity, dest1 = angletarget.origin, movedir = vector movement direction
					if (self.movetarget) { // Angle target found?
						cam_focus.angles = vectoangles(self.movedir); // Convert direction vector to angles
						if (!cam_focus.cam_debugarrow && !self.nodebuginfo) { // Spawn a debug arrow if devmode (only once)
							spawn_marker(cam_focus.origin, cam_focus.angles,1,3);
							cam_focus.cam_debugarrow = TRUE;
						}

						cam_focus.angles_x = -cam_focus.angles_x; // Got to reverse the pitch angle because v_angle is upside down (special carmack code).
					} else cam_focus.focalpoint = 0; // Cannot have a focalpoint if no angletarget
				}
				cam_angle = cam_focus.angles; // Update camera from existing angles key
			}
			
			// First camera? Hide player and HUD
			if (cam_sequence == CINECAM_SEQ_FIRST) {
				cam_sequence = CINECAM_SEQ_ACTIVE;	// Move forward in seq
				cvar_set("viewsize", "120");		// Hide HUD
				cvar_set("crosshair", "0");			// No crosshair
				// This is SUPER important, the entity has to have a model!
				// If this is blank, the engine will not update the entity
				// when moving around by the cinematic system
				setmodel(cam_client, MODEL_EMPTY);	// Empty model
				cam_client.frame = 0;				// reset frame
				cam_client.weaponmodel = "";		// Remove weapon
				cam_client.weaponframe = 0;
				
				// Create fake player model for cinematics
				if (cam_fakeplay) {
					// Check for fake player location
					if (self.attachment) { // Read target entity (often has angle key).
						self.dest2 = self.attachment.origin;
						self.dest3 = self.attachment.angles;
					} else {// Read origin/angles from player.
						self.dest2 = self.pos4;
						self.dest3 = self.finalangle;
					}
					
					cam_player.solid = SOLID_NOT;
					cam_player.movetype = MOVETYPE_NONE;
					setorigin(cam_player, self.dest2);
					setmodel(cam_player, MODEL_PLAYER);
					setsize(cam_player, VEC_ORIGIN, VEC_ORIGIN);
					cam_player.angles = self.dest3;
					cam_player.fixangle = TRUE;
					cam_player.state = TRUE; // Setup animation loop
					cam_player.walkframe = cam_player.frame = 12;
					cam_player.think = cam_player.th_altstand;
					cam_player.nextthink = time + 0.1;
				}
			}
		}
		
		// Check for any trigger events when viewing the camera
		// The screen can be solid background colour at this point.  Anything could be spawned and would not be seen!
		// If the mapper wants stuff to trigger once, its best to use wait = -1 on trigger_relays instead.
		// Must use cam_seq check because can have single cam setup otherwise the triggers will be fired twice (camera exit)
		if (cam_sequence != CINECAM_SEQ_LAST && cam_focus.target2 != "") trigger_strs(cam_focus.target2, cam_client);	
		cam_active = CINECAM_FADEIN; // Fade IN function
	}
		
	// Fade IN camera (player if last camera)
	if (cam_active == CINECAM_FADEIN) {
		if (cam_focus.spawnflags & CINECAM_FUNC_FADEIN) { // Check if fade IN is active (spawnflags).  Start fading player view out to solid colour.
			self.lip = CINECAM_MAXSHIFT / (cam_focus.waitmin2 / CINECAM_CONTIME); // Work out cshift density steps.
			cam_colour = cam_focus.pos2;	// Fade In background
			self.count = CINECAM_MAXSHIFT;	// Initial density
			self.cnt = CINECAM_FADEDOWN;	// Fade direction
			if (cam_sequence == CINECAM_SEQ_LAST) self.state = CINECAM_EXIT; // Check for exit condition from cinematic system
			else self.state = CINECAM_MESSAGE;	// Next function1

			cam_active = CINECAM_FADE;		// Start fade process
		} else { // Skip over fade IN
			camera_controller_cshift(cam_client, cam_focus.pos2, CINECAM_MINSHIFT); // Reset cshift, otherwise screen could be background colour
			if (cam_sequence == CINECAM_SEQ_LAST) cam_active = CINECAM_EXIT; // Last camera in sequence?
			else cam_active = CINECAM_MESSAGE;
		}
	}

	// Exit and back to previous player position
	if (cam_active == CINECAM_EXIT) {
		cam_client.takedamage = DAMAGE_AIM; // Let player be damaged again
		if (cam_client.flags & FL_CLIENT) cam_client.button0 = cam_client.button1 = cam_client.button2 = 0; // Clear keys so no esc/jump/shoot functions are triggered
		cam_client.attack_finished = time + 0.1; // Make sure no weapon frame for 0.1s after cinematic
		cam_client.air_finished = time + WATER_AIR; // Restore air timer (>3s viewing camera and will get gasp sounds)
		cam_client.flags = cam_client.flags - (cam_client.flags & FL_ONGROUND); // Remove onground flag to make sure engine resets properly
		cinematic_running = FALSE; // Finally switch off cinematic system
		cam_active = CINECAM_OFF;
		if (self.deathtarget != "") trigger_strs(self.deathtarget, cam_client); // Check for any exit/finished cinematic triggers
		cam_client.think = player_stand1; // Make sure player animation restarts
		cam_client.nextthink = time + 0.1;
	}
	
	// Main fade in/out loop for active camera
	if (cam_active == CINECAM_FADE) {
		camera_check_skip(cam_client); // Check for skip function
		if (cam_exit == CINECAM_SKIP_DONE) { // Is cinematic skip done?
			if (self.cnt == CINECAM_FADEUP) self.count = CINECAM_MAXSHIFT; // Setup max/min values to trigger end of fade
			else self.count = CINECAM_MINSHIFT;
		}
		
		if (self.cnt == CINECAM_FADEUP) self.count = self.count + self.lip; // Increase/Decrease the screen density
		else self.count = self.count - self.lip;
		
		// Check for min/max values (exit condition)
		if (self.count >= CINECAM_MAXSHIFT) {
			self.count = CINECAM_MAXSHIFT;
			cam_active = self.state;
		} else if (self.count <= CINECAM_MINSHIFT) {
			self.count = CINECAM_MINSHIFT;
			cam_active = self.state;
		}

		camera_controller_cshift(cam_client, cam_colour, self.count); // Update v_cshift
	}
};

// When the fake player is displayed via the camera system.  This function keeps the model animated like the real player.
void() camera_player_animate = { // [FUNCTION]
	if (!self.state) return; // Stop animating if disabled

	self.walkframe = self.walkframe + 1;
	if (self.walkframe > 16) self.walkframe = 12;
	self.frame = self.walkframe;
	self.think = camera_player_animate;
	self.nextthink = time + 0.1;
};

// Check if the camera controller entity is setup and running and spawn the Controller.
void() camera_controller_setup = { // [FUNCTION]
	if (!cam_control) { // Does controller exist?
		cam_active = CINECAM_OFF; // Default state is off
		cam_control = spawn();					// Create an entity
		cam_control.owner = self;				// Link back to client
		cam_control.classtype = CT_CONTROL;
		cam_control.solid = SOLID_NOT;			// No world interaction
		cam_control.movetype = MOVETYPE_NONE;	// Static item, no movement
		setorigin(cam_control, '0 0 0');
		setmodel(cam_control, MODEL_EMPTY);
		setsize(cam_control, VEC_ORIGIN, VEC_ORIGIN);

		cam_player = spawn(); // Setup Fake Player Model.  The player entity is moved around between cameras.  For cinematics that require the player this placeholder entity will create the illusion of the player.
		cam_player.state = FALSE;
		cam_player.solid = SOLID_NOT;
		cam_player.movetype = MOVETYPE_NONE;
		setorigin(cam_player, cam_control.origin);
		setmodel(cam_player, MODEL_EMPTY);
		setsize(cam_player, VEC_ORIGIN, VEC_ORIGIN);
		cam_player.angles = '0 0 0';
		cam_player.view_ofs = '0 0 0';
		cam_player.th_altstand = camera_player_animate;

		cam_track = spawn(); // Setup Camera Tracking entity.  To prevent the player moving the camera while the cinematic is active, a simple entity does the camera movement and the player entity mirrors this origin instead
		cam_track.owner = cam_control;
		cam_track.classtype = CT_CONTROL;
		cam_track.solid = SOLID_NOT;
		cam_track.movetype = MOVETYPE_FLY;
		setorigin(cam_track, '0 0 0');
		setmodel(cam_track, MODEL_EMPTY);
		setsize(cam_track, VEC_ORIGIN, VEC_ORIGIN);
		cam_track.velocity = '0 0 0';

		cam_control.think = camera_controller_think; // Setup controller into loop
		cam_control.nextthink = time + CINECAM_CONTIME;
	}
};

void() misc_camera_use = { // [FUNCTION]
	if (frame_pause()) return; // Stop if cinematic/intermission running.

	self.enemy = world; // Find client first
	if (other.flags & FL_CLIENT) self.enemy = other;
	else if (activator.flags & FL_CLIENT) self.enemy = activator;

	if (!self.enemy) return; // No player available
	if (self.enemy.health < 1) return; // or is dead
	if (self.enemy.in_a_vehicle) return; // or in a vehicle

	if (coop > 0) { // Cinematics don't work with COOP?
		centerprint(self.enemy, self.message2); // There is a default message, but really this is something the mapper should (override) setup on the first camera.
		sound(self.enemy,CHAN_VOICE, self.noise,1,ATTN_NORM); // Default talk sound(using sounds entity key) // return; // Let's just see what happens shall we? -Qmaster
	}

	cam_focus = self;
	cam_client = self.enemy;
	cam_active = CINECAM_SETUP; // Start camera controller
};

// Make sure cshift colours are in range (0-255)
float(float cc_value) misc_camera_colrange = { // [FUNCTION]
	if (cc_value < 0) return 0;
	else if (cc_value > CINECAM_MAXSHIFT) return CINECAM_MAXSHIFT;
	else return cc_value;
};

// Make sure RBG colour ranges are correct
void(vector cc_check) misc_camera_colcheck = { // [FUNCTION]
	cc_check_x = misc_camera_colrange(cc_check_x);
	cc_check_y = misc_camera_colrange(cc_check_y);
	cc_check_z = misc_camera_colrange(cc_check_z);
};

// QUAKED misc_camera (1 0.5 0.5) (-16 -16 -16) (16 16 16) PLAYER SKIPABLE FADEOUT FADEIN FIXEDANGLE ENDCAMERA x x Not_Easy Not_Normal Not_Hard Not_DM
// In game cinematic camera (Does not work in deathmatch)
// -------- KEYS --------
// targetname   : Camera name for linking into target chains
// target       : Points to the next camera in a chain/sequence
// angletarget  : Direction the camera will face (use info_target)
// angles       : Direction the camera will face (Pitch Yaw Roll setup)
// focalpoint   : Always focus the camera on angletarget (=1 enabled)
// angleblend   : Blend between current/last camera angles (def=0.03 range=0-1)
// target2      : Additional target(s) to trigger when camera VIEWED
// deathtarget  : Additional target(s) to trigger when cinematic FINISHED
// modeltarget  : Location of fake player mdl (use info_camera_destination)
// returntarget : Location of returning player (use info_camera_destination)
// pos1         : Camera starting BACKGROUND colour (R/G/B)
// pos2         : Camara finishing BACKGROUND colour (R/G/B)
// waitmin      : Fade OUT previous camera, time (def=1s, minimum=0.1s)
// waitmin2     : Fade IN this camera, time (def=1s, minimum=0.1s)
// waitmin3     : Speed at which camera moves towards sighttarget
// sighttarget  : Position the camera will travel towards (use info_target)
// controltarget: Bezier Curve control point (has angletarget defaults)
// wait         : Time to wait while showing camera (-1 = wait for key)
// message      : message to centerprint when camera is viewed
// message2     : message to centerprint to client if coop is active
// sounds       : 1=Secret,2=talk(def),3=switch,4=silent,5=custom,6=secret2
// noise        : custom sound to play when messaged is centerprinted
// nodebuginfo  : All debug info displayed via developer=1 is blocked
// -------- SPAWNFLAGS --------
// PLAYER       : Show the player model when starting cinematics
// SKIPABLE     : Allow the cinematic to be skipped (exit after fade)
// FADEOUT      : Fade OUT previous camera (time = waitmin)
// FADEIN       : Fade IN this camera (time = waitmin2)
// FIXEDANGLE   : All cameras in a chain will use the first camera angle
// ENDCAMERA	 : Only the fade in/out work, the origin/angle are ignored
// -------- NOTES --------
// In game cinematic camera will fade/move based on times in seconds.
// The first fade (out) is from previous camera to background colour.
// The second fade (in) is to current camera view. The linear movement
// will start at the same time as the fade in process.
// Start -> Fade Out(waitmin1) -> Fade In(waitmin2) / Movement (waitmin3)
// Once 'Fade in' has finshed then the pause timer (wait) starts.
// Waitmin3 = Waitmin2 + Wait (Sync everything to finish together)
// To sync the final camera to a player start, finish 22 map units above
// angles = up/down, angle, tilt left/right 'pitch roll yaw'
// up/left = negative value, down/right = positive value
// deathtarget, modeltarget & returntarget have to be defined on first camera
// Be aware that coop is not properly supported, so be careful of trigger events
// and decide on a coop message2 if need be.
void() misc_camera = { // [ENTITY]
	if (deathmatch) { remove(self); return; } // Cinematics will not work in DM mode

	self.classtype = CT_MISCCAM; // Setup up class and movetypes
	self.estate = ESTATE_ON;
	setsize (self, VEC_ORIGIN, VEC_ORIGIN);
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	setmodel(self, MODEL_EMPTY);
	self.owner = self;
	if (self.sounds < 1) self.sounds = 2; // Precache any sounds for centerprint.  DEF=talktalk
	trigger_bmodel_sounds();
	if (self.waitmin < 0.1) self.waitmin = 1; // Cannot have a fade IN/OUT timer less than 0.1s.  The fade IN/OUT function is done via spawnflags.
	if (self.waitmin2 < 0.1) self.waitmin2 = 1;
	misc_camera_colcheck(self.pos1); // Check colour fade parameters are in range
	misc_camera_colcheck(self.pos2);
	if (self.waitmin3 < 0.1) self.waitmin3 = 2; // Time to move (linear) towards sighttarget, no angle change
	if (self.message2 == "") self.message2 = "Cinematic sequence in COOP,\nstarting, but might not work properly.\n"; // Default warning for cinematics and COOP mode
	if (self.controltarget != "") { // Found bezier curve setup
		if (self.angletarget == "") { // If no angle target setup, use next camera
			self.angletarget = self.target;
			self.focalpoint = TRUE; // Focus on next camera instead
		}
	}

	if (self.angletarget == "" && self.focalpoint) { // Cannot have a focalpoint if no angletarget is defined
		dprint("\b[MISC_CAM]\b No focalpoint entity defined!\n");
		self.focalpoint = 0; 
	}
	
	if (self.targetname != "") self.use = entity_state_use; // Setup Entity State functionality
	self.use = misc_camera_use;
	camera_controller_setup(); // Create camera controller
	if (self.controltarget != "" && !self.nodebuginfo) { // Check for bezier debug mode (display curves).  Can block debug info (start/control/end/arrows).
		self.think = misc_camera_bezier_debug;
		self.nextthink = time + 0.2;
	}
};

void(float filehandle, string entkey, string entval) misc_camera_str = { // [FUNCTION]
	local string expstr;

	if (entval == "") return;

	expstr = strcat("\"", entkey, "\" \"", entval, "\"\n");
	fputs(filehandle, expstr);
};

void(float filehandle, string entkey, float entval) misc_camera_float = { // [FUNCTION]
	if (entval == 0) return;

	misc_camera_str(filehandle, entkey, ftos(entval));
};

void(float filehandle, string entkey, vector entval) misc_camera_vec = { // [FUNCTION]
	local string expstr;

	if (CheckZeroVector(entval) == TRUE) return;

	expstr = strcat(ftos(entval_x), " ", ftos(entval_y), " ", ftos(entval_z));
	misc_camera_str(filehandle, entkey, expstr);
};

// Write a config/text file
// * generates file in the DATA subdirectory under MOD folder
// * Uses currently loaded map file with _cam extension added
// * requires the FRIK file system extensions (advanced engine only)
// * requires advanced FTE string commands (included in QSS/DP as well)
//
// Example use of sprintf
// string = sprintf("\"%s\" \"%s\"\n", entityfieldname(entno), getentityfieldstring(entno, self));
void() misc_camera_filewrite = { // [FUNCTION]
	local string camfile;
	local entity cament;
	local float camfilelen, charpos, camfh;

	if (!ext_active) return;		// Check for advanced engines
	if (!ext_frikfile) return;		// Check for Frik file system
	if (!ext_ftestrings) return;	// Check for advanced string functions
	if (world.model == "") return;	// Check for map name

	camfile = world.model; // Find out current map name
	camfilelen = strlen(camfile);
	charpos = strstrofs(camfile, "/", 0); // Search at beginning for directory prefix
	if (charpos > 0) camfile = substring(camfile, charpos+1, camfilelen); // Any prefix detected? (Cut directory)
	camfilelen = strlen(camfile); // Search for .bsp extension
	charpos = strstrofs(camfile, ".", 0);
	if (charpos > 0) camfile = substring(camfile, 0, charpos); // Any model (.bsp) extensions? (Cut it!)
	camfile = strcat(camfile, "_cam.txt"); // Add new file extension and file type
	camfh = fopen(camfile, FILE_WRITE); // Open new (overwrite) file ready for export
	cament = find(world, classname, "misc_camera"); // Search for any misc_camera entities
	while(cament) {
		fputs(camfh, "{\n"); // Open entity definition
		misc_camera_str(camfh, "classname", cament.classname); // Write all relevant fields to file
		misc_camera_vec(camfh, "origin", cament.origin);
		misc_camera_float(camfh, "spawnflags", cament.spawnflags);
		misc_camera_str(camfh, "targetname", cament.targetname);
		misc_camera_str(camfh, "target", cament.target);
		misc_camera_str(camfh, "angletarget", cament.angletarget);
		misc_camera_vec(camfh, "angles", cament.angles);
		misc_camera_float(camfh, "focalpoint", cament.focalpoint);
		misc_camera_float(camfh, "angleblend", cament.angleblend);
		misc_camera_str(camfh, "target2", cament.target2);
		misc_camera_str(camfh, "deathtarget", cament.deathtarget);
		misc_camera_str(camfh, "modeltarget", cament.modeltarget);
		misc_camera_str(camfh, "returntarget", cament.returntarget);
		misc_camera_vec(camfh, "pos1", cament.pos1);
		misc_camera_vec(camfh, "pos2", cament.pos2);
		misc_camera_float(camfh, "waitmin", cament.waitmin);
		misc_camera_float(camfh, "waitmin2", cament.waitmin2);
		misc_camera_float(camfh, "waitmin3", cament.waitmin3);
		misc_camera_str(camfh, "sighttarget", cament.sighttarget);
		misc_camera_str(camfh, "controltarget", cament.controltarget);
		misc_camera_float(camfh, "wait", cament.wait);
		misc_camera_str(camfh, "message", cament.message);
		misc_camera_str(camfh, "message2", cament.message2);
		misc_camera_float(camfh, "sounds", cament.sounds);
		misc_camera_str(camfh, "noise", cament.noise);
		misc_camera_float(camfh, "nodebuginfo", cament.nodebuginfo);
		misc_camera_float(camfh, "classtype", cament.classtype); // Extra fields that could be generated
		misc_camera_float(camfh, "estate", cament.estate);
		misc_camera_str(camfh, "model", cament.model);
		misc_camera_vec(camfh, "absmin", cament.absmin);
		misc_camera_vec(camfh, "absmax", cament.absmax);
		misc_camera_vec(camfh, "mins", cament.mins);
		misc_camera_vec(camfh, "maxs", cament.maxs);
		misc_camera_vec(camfh, "size", cament.size);
		misc_camera_str(camfh, "noise", cament.noise);
		misc_camera_float(camfh, "volume", cament.volume);
		//misc_camera_str(camfh, "use", cament.use); // This is a void() not a string
		fputs(camfh, "}\n"); // Close entity definition
		cament = find(cament, classname, "misc_camera"); // Next camera entity
	}
	fclose(camfh); // Close file
};
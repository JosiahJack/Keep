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
// Entity count: 
// Function count: 
//
// Implements: Global Fading Fog System
//
// Description:
// * Original idea from Honey mod by CZG
// * Written from scratch as Honey implementation is weird
// * Created special long float function for better accuracy
// * Fog functionality has to be active before controller can be setup
// * Creates a special entity (controller) to work in background
// * Controller is setup from client.qc / PlayerPostThink function
// * Added r_skyfog version as well (supported in most engines)
//=============================================================================

// Make value is not below or above limits and or negative!
float(float fogrange) fog_check_range = {
	if (fogrange < 0.01) return 0.01;
	if (fogrange > 1) return 1;
	return fabs(fogrange);
};

// Main fog functions
void(entity client) change_fog  = {
	if (!fog_control) return;
	
	Safe_stuffcmd(client, "\n\n\nfog "); // Update fog parameters to console buffer
	lftos(client, fog_control.fog_currden, 2,3, BUFFER_STUFFCMD); // Fog density can be in the range of 0-99
	Safe_stuffcmd(client, " "); 
	lftos(client, fog_control.fog_currcol_x, 1,3, BUFFER_STUFFCMD); 
	Safe_stuffcmd(client, " "); 
	lftos(client, fog_control.fog_currcol_y, 1,3, BUFFER_STUFFCMD); 
	Safe_stuffcmd(client, " "); 
	lftos(client, fog_control.fog_currcol_z, 1,3, BUFFER_STUFFCMD); 
	if (ext_dpfog) { // Extra fog parameters for DarkPlaces extended engines
		Safe_stuffcmd(client, " ");
		Safe_stuffcmd(client, fog_control.fog_dpextra);
	}
	Safe_stuffcmd(client, "\n");
};

// Main fog controller loop
void() fog_controller_think = {
	// Has there been a change detected?
	if (self.state == STATE_SETUP) {
		// If fog fade time too low, instantly switch
		if (self.fog_difftime <= FADEFOG_TIME) {
			self.state = STATE_OFF;
			self.fog_currden = self.fog_targden;
			self.fog_currcol = self.fog_targcol;
			change_fog(self.owner);
		} else {
			// Setup gradual fade of fog over time
			self.state = STATE_ON;
			// divide the fade time into segments (minimum 0.05)
			// Multiple the time by segments so diff is correct
			// Time segements less than 0.05 does not work v well
			self.fog_steptime = self.fog_difftime / FADEFOG_TIME;
			self.fog_difftime = self.fog_steptime * FADEFOG_TIME;
			self.fog_diffden = self.fog_targden - self.fog_currden; // Work out fade directions for density/colour
			self.fog_diffcol = self.fog_targcol - self.fog_currcol;
			self.fog_diffden = self.fog_diffden / self.fog_steptime; // Work out step ammount to fade smoothly over time
			self.fog_diffcol_x = self.fog_diffcol_x / self.fog_steptime;
			self.fog_diffcol_y = self.fog_diffcol_y / self.fog_steptime;
			self.fog_diffcol_z = self.fog_diffcol_z / self.fog_steptime;
		}
	} else if (self.fog_steptime < 0 && self.state != STATE_OFF) {
		self.state = STATE_OFF; // Is the fog fade over? Finite amount of steps
		self.fog_currden = self.fog_targden;
		self.fog_currcol = self.fog_targcol;

		// Density and colour should be capped at 1, but it seems
		// density can go much higher and is needed to make it solid
		// Removed the upper cap check - AD 1.7 Patch 2
		//self.fog_currden = fog_check_range(self.fog_currden);
		if (self.fog_currden < 0) self.fog_currden = 0;
		if (self.fog_currden > 99) self.fog_currden = 99;
		self.fog_currcol_x = fog_check_range(self.fog_currcol_x); // Check density and colour values are within range
		self.fog_currcol_y = fog_check_range(self.fog_currcol_y);
		self.fog_currcol_z = fog_check_range(self.fog_currcol_z);
		
		change_fog(self.owner);
	} else if (self.state == STATE_ON) {
		self.fog_steptime = self.fog_steptime - 1; // If the fade is active, keep adding steps
		self.fog_currden = self.fog_currden + self.fog_diffden;
		self.fog_currcol = self.fog_currcol + self.fog_diffcol;
		change_fog(self.owner);
	}
	
	self.think = fog_controller_think; // Keep on looping around using min time step
	self.nextthink = time + FADEFOG_TIME;
};

void(float gf_den, vector gf_col, float gf_time) fade_fog = { // [FUNCTION]
	if (!fog_control) return; // No controller active?

	if (gf_den < 0) gf_den = 0; // Fog density can be higher than 1, check larger range
	if (gf_den > 99) gf_den = 99;
	gf_col_x = fog_check_range(gf_col_x); // Check colour values are within range
	gf_col_y = fog_check_range(gf_col_y);
	gf_col_z = fog_check_range(gf_col_z);
	fog_control.fog_targden = gf_den; // Setup fog controller with new fog values
	fog_control.fog_targcol = gf_col;
	fog_control.fog_difftime = gf_time;
	fog_control.state = STATE_SETUP; // Force fog controller to calculate difference
};

// Setup the fog controller entity (called from client if defined)
void() setup_fog_controller = { // [FUNCTION]
	if (!fog_control) {
		// Start off with the fog controller disabled
		// if the worldspawn setup correctly then enable
		// the controller and allow fog changes
		fog_active = FALSE;
		fog_control = spawn();
		if (!fog_control) return;

		fog_control.owner = self;				// Link back to client
		fog_control.classtype = CT_CONTROL;
		fog_control.solid = SOLID_NOT;			// No world interaction
		fog_control.movetype = MOVETYPE_NONE;	// Static item, no movement
		setorigin(fog_control, '0 0 0');
		setsize(fog_control, VEC_ORIGIN, VEC_ORIGIN);
		
		if (world.fog_density <= 0) {
			fog_active = FALSE;						// out of sync
			fog_control.fog_currden = DEF_FOGDEN;	// Bad default
			fog_control.fog_targden = DEF_FOGDEN;	// Target
		} else {
			fog_active = TRUE;					// engine and QC insync
			fog_control.fog_currden = world.fog_density;
			fog_control.fog_targden = world.fog_density;
		}
		fog_control.fog_diffden = 0;			// Difference

		if (VectorIsAllZeros(world.fog_colour)) {
			fog_active = FALSE;						// out of sync
			fog_control.fog_currcol = DEF_FOGCOL;	// Bad Default
			fog_control.fog_targcol = DEF_FOGCOL;	// Target
		} else {
			fog_active = TRUE;					// engine and QC insync
			fog_control.fog_currcol = world.fog_colour;
			fog_control.fog_targcol = world.fog_colour;
		}
		fog_control.fog_diffcol = '0 0 0';		// Difference

		// Bat dip crazy DP extra fog parameters that no other engine uses; dpextra = alpha mindist maxdist top fadedepth (def=1 0 8192 1024 32)
		if (world.fog_dpextra == "") fog_control.fog_dpextra = DEF_FOGEXT;
		else fog_control.fog_dpextra = world.fog_dpextra;

		fog_control.state = STATE_OFF;	// Not fading atm
		fog_control.fog_difftime = 0;	// fading fog time (seconds)
		fog_control.fog_steptime = 0;	// How many steps to fade
		fog_control.think = fog_controller_think; // Setup think process to monitor for fog changes.  If this entity already exists, then its thinking!
		fog_control.nextthink = time + FADEFOG_TIME;
		if (fog_active) change_fog(self);
	}
};

// Main sky fog functions
void(entity client) change_skyfog = { // [FUNCTION]
	if (!skyfog_control) return;
	
	// Update fog parameters to console buffer
	Safe_stuffcmd(client, "\n\n\nr_skyfog ");
	// Fog density should be in the range of 0-1
	lftos(client, skyfog_control.skyfog_currden, 1,3, BUFFER_STUFFCMD);
	Safe_stuffcmd(client, "\n");
};

// Main sky fog controller loop
void() skyfog_controller_think = { // [FUNCTION]
	// Has there been a change detected?
	if (self.state == STATE_SETUP) {
		// If sky fog fade time too low, instantly switch
		if (self.skyfog_difftime <= FADEFOG_TIME) {
			self.state = STATE_OFF;
			self.skyfog_currden = self.skyfog_targden;
			change_skyfog(self.owner);
		} else {
			self.state = STATE_ON; // Setup gradual fade of sky fog over time
			// divide the fade time into segments (minimum 0.05)
			// Multiple the time by segments so diff is correct
			// Time segements less than 0.05 does not work v well
			self.skyfog_steptime = self.skyfog_difftime / FADEFOG_TIME;
			self.skyfog_difftime = self.skyfog_steptime * FADEFOG_TIME;
			self.skyfog_diffden = self.skyfog_targden - self.skyfog_currden; // Work out fade directions for density
			self.skyfog_diffden = self.skyfog_diffden / self.skyfog_steptime; // Work out step ammount to fade smoothly over time
		}
	} else if (self.skyfog_steptime < 0 && self.state != STATE_OFF) {
		self.state = STATE_OFF; // Is the fog fade over? Finite amount of steps
		self.skyfog_currden = self.skyfog_targden;
		self.skyfog_currden = fog_check_range(self.skyfog_currden); // Density should be capped at 1
		change_skyfog(self.owner);
	} else if (self.state == STATE_ON) {
		self.skyfog_steptime = self.skyfog_steptime - 1; // If the fade is active, keep adding steps
		self.skyfog_currden = self.skyfog_currden + self.skyfog_diffden;
		change_skyfog(self.owner);
	}

	self.think = skyfog_controller_think; // Keep on looping around using min time step
	self.nextthink = time + FADEFOG_TIME;
};

void(float gf_den, float gf_time) fade_skyfog = { // [FUNCTION]
	if (!skyfog_control) return; // No controller active?

	gf_den = fog_check_range(gf_den); // Check Sky Fog density is range 0 - 1
	skyfog_control.skyfog_targden = gf_den; // Setup sky fog controller with new fog values
	skyfog_control.skyfog_difftime = gf_time;
	skyfog_control.state = STATE_SETUP; // Force sky fog controller to calculate difference
};

// Setup the sky fog controller entity
void() setup_skyfog_controller = { // [FUNCTION]
	if (!skyfog_control) { // Start off with the sky fog controller disabled; if the worldspawn setup correctly then enable the controller and allow fog changes.
		skyfog_active = FALSE;
		skyfog_control = spawn();
		if (!skyfog_control) return;

		skyfog_control.owner = self;				// Link back to client
		skyfog_control.classtype = CT_CONTROL;
		skyfog_control.solid = SOLID_NOT;			// No world interaction
		skyfog_control.movetype = MOVETYPE_NONE;	// Static item, no movement
		setorigin(skyfog_control, '0 0 0');
		setsize(skyfog_control, VEC_ORIGIN, VEC_ORIGIN);
		
		if (world.skyfog_density <= 0) {
			skyfog_active = FALSE;						// out of sync
			skyfog_control.skyfog_currden = DEF_SKYFOGDEN;	// Bad default
			skyfog_control.skyfog_targden = DEF_SKYFOGDEN;	// Target
		} else {
			skyfog_active = TRUE;					// engine and QC insync
			skyfog_control.skyfog_currden = world.skyfog_density;
			skyfog_control.skyfog_targden = world.skyfog_density;
		}
		skyfog_control.skyfog_diffden = 0;	// Difference
		skyfog_control.state = STATE_OFF;	// Not fading atm
		skyfog_control.skyfog_difftime = 0;	// fading sky fog time (seconds)
		skyfog_control.skyfog_steptime = 0;	// How many steps to fade
		skyfog_control.think = skyfog_controller_think; // Setup think process to monitor for sky fog changes.  If this entity already exists, then its thinking!
		skyfog_control.nextthink = time + FADEFOG_TIME;
		if (skyfog_active) change_skyfog(self);
	}
};
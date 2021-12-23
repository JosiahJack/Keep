//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
//
// Attributions: All
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
// Entity count: 52
// Function count: 10
//
// Implements: Ambient Sounds and Triggerable Sound Effects
//
// Description:
// Ambient sounds that always play their sounds on loop and triggerable custom
// sound effects.  Also randomized sound effects that play intermittently.
//=============================================================================

float SOUND_PLAYONCE = 2;		// When triggered plays once
float SOUND_VOLUME_MIN = 0.05; // Minimum volume cutoff before it defaults to normal
float SOUND_VOLUME_MAX = 1.00; // Maximum volume for sounds or else engine error.
float SOUND_ALTVERSION = 4;
float SOUND_EXTENSION1 = 16;

// Volume has to be within range of 0-1, otherwise engine errors
void(float defvol) SUB_BoundVolume = { // [FUNCTION]
	if (self.volume == 0) self.volume = defvol;	// Default
	else if (self.volume < SOUND_VOLUME_MIN) self.volume = 0;	// Out of range
	else if (self.volume > SOUND_VOLUME_MAX) self.volume = 1;	// Out of range
};

void() ambient_sound_setup = { // [FUNCTION]
	SUB_BoundVolume(1);
	if (self.speed < 0) self.speed = ATTN_NONE;
	else if (self.speed == 0) self.speed = ATTN_NORM;
	ambientsound (self.origin, self.noise, self.volume, self.speed);
};

void() ambientsound_trigger_start = { // [FUNCTION]
	sound (self, CHAN_AUTO, self.noise, self.volume, self.distance);
};

// QUAKED ambient_custom_loop (0.3 0.1 0.6) (-16 -16 -8) (16 16 8) x
// -------- KEYS --------
// volume : volume of sound (default 1, capped at 1)
// noise : custom sound to play (looped)
// -------- SPAWNFLAGS --------
// -------- NOTES --------
// Custom ambient (must be looped) sound, CANNOT toggle/switch state
void() ambient_custom_loop = { // [ENTITY]
	// Check for sound file
	if (self.noise == "") {
		dprint("\b[ambient_custom_loop]\b Missing sound file, defaulting to ambience/wat_cave.wav\n");
		self.noise = "ambience/wat_cave.wav";
	}
	
	precache_sound (self.noise);
	if (self.volume < SOUND_VOLUME_MIN) self.volume = 1;

	// start right away if not triggered
	if(!self.targetname) {
		// Need to start on the second frame since that's when entities not called in world_spawn are created
		self.nextthink = time + 0.1;
		self.think = ambient_sound_setup;
	}
	else// wait for trigger
		self.use = ambientsound_trigger_start;
};

void() fx_ambientsound =  { // [ENTITY], Re-direct
	if (self.noise == "") {
		dprint("\b[fx_ambientsound]\b Missing sound file, defaulting to ambience/wat_cave.wav\n");
		self.noise = "ambience/wat_cave.wav";
	}
	ambient_custom_loop();
};

void() ambient_comp_hum = { // [ENTITY]
	self.noise = "ambience/comp1.wav";
	precache_sound (self.noise);
	if (self.volume < SOUND_VOLUME_MIN) self.volume = 1;
	ambient_sound_setup();
};

void() ambient_drip = { // [ENTITY]
	self.noise = "ambience/drip1.wav";
	precache_sound (self.noise);
	if (self.volume < SOUND_VOLUME_MIN) self.volume = 0.5;
	ambient_sound_setup();
};

void() ambient_drone = { // [ENTITY]
	self.noise = "ambience/drone6.wav";
	precache_sound (self.noise);
	if (self.volume < SOUND_VOLUME_MIN) self.volume = 0.5;
	ambient_sound_setup();
};

void() ambient_flouro_buzz = { // [ENTITY]
	self.noise = "ambience/buzz1.wav";
	precache_sound (self.noise);
	if (self.volume < SOUND_VOLUME_MIN) self.volume = 1;
	ambient_sound_setup();
};

void() ambient_light_buzz = { // [ENTITY]
	self.noise = "ambience/fl_hum1.wav";
	precache_sound (self.noise);
	if (self.volume < SOUND_VOLUME_MIN) self.volume = 0.5;
	ambient_sound_setup();
};

void() ambient_suck_wind = { // [ENTITY]
	self.noise = "ambience/suck1.wav";
	precache_sound (self.noise);
	if (self.volume < SOUND_VOLUME_MIN) self.volume = 1;
	ambient_sound_setup();
};

void() ambient_swamp1 = { // [ENTITY]
	self.noise = "ambience/swamp1.wav";
	precache_sound (self.noise);
	if (self.volume < SOUND_VOLUME_MIN) self.volume = 0.5;
	ambient_sound_setup();
};

void() ambient_swamp2 = { // [ENTITY]
	self.noise = "drake/ambience/swamp2.wav";
	precache_sound (self.noise);
	if (self.volume < SOUND_VOLUME_MIN) self.volume = 0.5;
	ambient_sound_setup();
};

void() ambient_thunder = { // [ENTITY]
	self.noise = "ambience/thunder1.wav";
	precache_sound (self.noise);
	if (self.volume < SOUND_VOLUME_MIN) self.volume = 0.5;
	ambient_sound_setup();
};

// Quoth MOD - Extra ambient sounds
void() ambient_generalpurpose = { // [ENTITY]
	// Check for sound file
	if (self.noise == "") {
		dprint("\b[AMBIENT_SOUND]\b Missing sound file at ");
		dprint(vtos(self.origin)); dprint("\n");
		spawn_marker(self.origin, SPNMARK_YELLOW);
		remove(self);
		return;
	}
	if (self.volume < SOUND_VOLUME_MIN) self.volume = 1.0;
	precache_sound (self.noise);
	ambient_sound_setup();
};

// Travil MOD - Extra ambient sounds
void() ambient_lavagurg = { // [ENTITY]
	self.noise = "travail/ambience/lavagurg.wav";
	precache_sound (self.noise);
	if (self.volume < SOUND_VOLUME_MIN) self.volume = 0.5;
	ambient_sound_setup();
};

void() ambient_hevifals = { // [ENTITY]
	self.noise = "travail/ambience/hevifals.wav";
	precache_sound (self.noise);
	self.volume = 0.5;
	ambient_sound_setup();
};

void() ambient_bublfals = { // [ENTITY]
	self.noise = "custents/ambient/runwater.wav";
	precache_sound (self.noise);
	if (self.volume < SOUND_VOLUME_MIN) self.volume = 0.5;
	ambient_sound_setup();
};

// Switch off sound emitter, clear next think.
void() ambient_custom_stop = { // [FUNCTION]
	if (self.state == STATE_OFF) return; // Cannot block via entity state because there is an 'off sound'.  Need to check against entity internal state for off state.

	self.state = STATE_OFF;
	self.think = SUB_Null;
	self.nextthink = time + 0.1;
	if (self.estate & ESTATE_DISABLE) return; // Catch play once/disable setting separate
	
	// Check for OFF sound, else play silence to clear sound
	if (self.noise1 != "") sound (self, self.impulse, self.noise1, self.volume, self.speed);
	else {
		if (!self.waitmin2) StopSound(self,self.impulse); // If aflag is defined, do not cut off sound
	}
};

void() ambient_custom_play = { // [FUNCTION]
	if (self.estate & ESTATE_BLOCK) return; // Block everything except ON entity state

	self.state = STATE_ON; // Internal state used for switch off sound
	if (self.t_width > 0) { // Check for random volume changes
		self.volume = self.t_width + (random() * self.t_length);
		if (self.volume > 1) self.volume = 1;
	}
	
	// Check for weather system?
	if (self.check_weather == TRUE) {
		if (query_weathersystem() == TRUE) sound (self, self.impulse, self.noise, self.volume, self.speed); // never has multiple sounds
	} else {
		// Check for multiple random sounds
		if (self.noise2 != "" && random() < 0.5) sound (self, self.impulse, self.noise2, self.volume, self.speed);
		else sound (self, self.impulse, self.noise, self.volume, self.speed);
		
		if (HasTargets(self)) SUB_UseTargets(); // If any targets defined, trigger them
	}
	
	// Keep playing sound?
	// If sound is setup to play once, don't turn off sound before finished
	// Let the sound play out and switch off ambient sound entity
	if (self.spawnflags & SOUND_PLAYONCE) self.estate = ESTATE_DISABLE;
	else {
		if (self.wait == 0) self.nextthink = time + self.delay; // Check for any random time element
		else self.nextthink = time + self.delay + random()*self.wait;
		self.think = ambient_custom_play;
	}
};

void() ambient_custom_use = { // [FUNCTION]
	if (self.spawnflags & ENT_STARTOFF) { // Deal with STARTOFF functionality first
		self.spawnflags = self.spawnflags - ENT_STARTOFF; // Remove spawnflag and switch ON entity
		self.estate_on();
	} else {
		if (self.estate & ESTATE_BLOCK) return; // Block USE functionality if state wrong

		if (self.state == STATE_OFF) self.estate_on(); // Toggle state of ambient sound to start/stop
		else self.estate_off();
	}
};

void() ambient_custom_on = { // [FUNCTION]
	self.estate = ESTATE_ON;
	ambient_custom_play();
};

void() ambient_custom_off = { // [FUNCTION]
	self.estate = ESTATE_OFF;
	ambient_custom_stop();
};

void() ambient_custom_disable = { // [FUNCTION]
	self.state = STATE_OFF;
	StopSound(self,self.impulse);
};

// QUAKED ambient_custom_sound (0.5 0.1 0.8) (-16 -16 -8) (16 16 8) x PLAYONCE x x x x STARTOFF x
// -------- KEYS --------
// targetname : trigger entity (works with entity state system)
// target  : targets to trigger each time sound is played
// volume  : volume of sound (default 1, capped at 1)
// noise   : primary sound (ad171/ambience/windgust1a.wav)
// noise1  : stop sound (ad171/ambience/switch_6off.wav)
// noise2  : random sound (ad171/ambience/windgust1b.wav)
// wait    : random time between sounds (default 20, =-1 no random element)
// delay   : minimum time between sounds (default 2)
// waitmin : Starting time (waitmin + random() x waitmin, =-1 no delay)
// waitmin2: 1 = Will not silence any playing sound if switching off
// impulse : channel on which to play sound (0-7) (0 automatic is default)
// speed   : attenuation -1=no attenuation, 1=normal (default), 2=idle, 3=static, 4=quiet
// -------- SPAWNFLAGS --------
// PLAYONCE : When triggered plays once
// STARTOFF : Starts off and waits for trigger
// -------- NOTES --------
// Play a sound on a periodic basis
void() ambient_custom_sound = { // [ENTITY]
	// Check for sound file
	if (self.noise == "") {
		dprint("\b[AMBIENT_SOUND]\b Missing sound file at ");
		dprint(vtos(self.origin)); dprint("\n");
		spawn_marker(self.origin, SPNMARK_YELLOW);
		remove(self);
		return;
	}
	precache_sound (self.noise);
	if (self.noise1 != "") precache_sound (self.noise1); // Is there an OFF sound defined (used for toggle sounds)
	if (self.noise2 != "") precache_sound (self.noise2); // Is there any random alternative sounds
	self.classtype = CT_SOUNDEMITTER;
	if (self.volume < SOUND_VOLUME_MIN) self.volume = 1;
	if (self.wait == 0) self.wait = 20;
	if (self.wait < 0) self.wait = 0;  // Setup defaults for sound waits (-1=no random element)
	if (self.delay <= 0) self.delay = 2;
	if (self.waitmin == 0) self.waitmin = 4;
	if (self.impulse <= 0) self.impulse = 1;

	// attenuation -1=no attenuation, 1=normal (default), 2=idle, 3=static, 4=quiet	
	if (self.speed < 0) self.speed = ATTN_NONE;
	else if (self.speed == 2) self.speed = ATTN_IDLE;
	else if (self.speed == 3) self.speed = ATTN_STATIC;
	else if (self.speed == 4) self.speed = ATTN_QUIET;
	else self.speed = ATTN_NORM;

	if (self.targetname != "") self.use = entity_state_use; // Setup Entity State functionality
	self.estate_on = ambient_custom_on;
	self.estate_off = ambient_custom_off;
	self.estate_use = ambient_custom_use;
	self.estate_disable = ambient_custom_disable;
	if (self.spawnflags & ENT_STARTOFF) self.estate_off();
	else {
		if (self.waitmin > 0) {
			self.nextthink = time + self.waitmin + random()*self.waitmin;
			self.think = self.estate_on;
		} else self.estate_on();
	}
};

void() ambient_custom_water = { // [ENTITY]
	if (self.noise == "") self.noise = "ad171/steps/water1.wav";
	if (self.volume < SOUND_VOLUME_MIN) self.volume = 0.75;
	ambient_custom_loop();
};

void() ambient_custom_rain = { // [ENTITY]
	if (self.count == 1) { // Long dripping water sound
		self.noise = "ad171/ambience/rain1_nl.wav";
		if (!self.speed) self.speed = 2;
		if (self.volume < SOUND_VOLUME_MIN) self.volume = 0.4;
		self.delay = 6.9; // Sound is 7s long, 0.1s for overlap
	} else { // Very short intense rain sound
		self.noise = "ad171/ambience/rain2_nl.wav";
		if (!self.speed) self.speed = 1;
		if (self.volume < SOUND_VOLUME_MIN) self.volume = 0.5;
		self.delay = 2.9; // Sound is 3s long, 0.1s for overlap
	}
	
	self.wait = -1;			// pretend loop, no pause
	self.waitmin = -1;		// No start delay
	self.check_weather = TRUE;	// Keep checking weather system
	self.spawnflags = ENT_STARTOFF; // Always start off, must be triggered
	ambient_custom_sound(); // Back into main function
};

void() ambient_custom_rumble = { // [ENTITY]
	precache_sound ("ad171/ambience/rumble1.wav");
	precache_sound ("ad171/ambience/rumble2.wav");
	precache_sound ("ad171/ambience/rumble3.wav");
	if (self.count < 0) self.count = random()*3; // Pick a random sound to start with	
	if (self.count <= 1) {
		self.noise = "ad171/ambience/rumble1.wav";
		if (self.lefty) { // Pick an alternative random sound
			if (random() < 0.5) self.noise2 = "ad171/ambience/rumble2.wav";
			else self.noise2 = "ad171/ambience/rumble3.wav";
		}
	} else if (self.count <= 2) {
		self.noise = "ad171/ambience/rumble2.wav";
		if (self.lefty) {
			if (random() < 0.5) self.noise2 = "ad171/ambience/rumble1.wav";
			else self.noise2 = "ad171/ambience/rumble3.wav";
		}
	} else {
		self.noise = "ad171/ambience/rumble3.wav";
		if (self.lefty) {
			if (random() < 0.5) self.noise2 = "ad171/ambience/rumble1.wav";
			else self.noise2 = "ad171/ambience/rumble2.wav";
		}
	}

	if (self.volume < SOUND_VOLUME_MIN) { self.t_width = 0.5; self.t_length = 0.5; }
	if (!self.speed) self.speed = 1;
	if (!self.delay) self.delay = 20;
	if (!self.wait) self.wait = 20;
	if (!self.waitmin) self.waitmin = 6 + random()*6;
	ambient_custom_sound(); // Back into main function
};

void() ambient_custom_wind = { // [ENTITY]
	precache_sound ("ad171/ambience/windgust1.wav");
	precache_sound ("ad171/ambience/windgust2.wav");
	precache_sound ("ad171/ambience/windgust3.wav");
	precache_sound ("ad171/ambience/windgust4.wav");
	precache_sound ("ad171/ambience/windgust5.wav");
	precache_sound ("ad171/ambience/windgust6.wav");
	if (self.count < 0) self.count = random()*6; // Pick a random sound to start with

	// Setup sound wav names
	if (self.count <= 1) {
		self.noise = "ad171/ambience/windgust1.wav";
		// Pick an alternative random sound
		if (self.lefty) {
			if (random() < 0.5) self.noise2 = "ad171/ambience/windgust2.wav";
			else self.noise2 = "ad171/ambience/windgust3.wav";
		}
	} else if (self.count <= 2) {
		self.noise = "ad171/ambience/windgust2.wav";
		if (self.lefty) {
			if (random() < 0.5) self.noise2 = "ad171/ambience/windgust1.wav";
			else self.noise2 = "ad171/ambience/windgust3.wav";
		}
	} else if (self.count <= 3) {
		self.noise = "ad171/ambience/windgust3.wav";
		if (self.lefty) {
			if (random() < 0.5) self.noise2 = "ad171/ambience/windgust1.wav";
			else self.noise2 = "ad171/ambience/windgust2.wav";
		}
	} else if (self.count <= 4) {
		self.noise = "ad171/ambience/windgust4.wav";
		if (self.lefty) {
			if (random() < 0.5) self.noise2 = "ad171/ambience/windgust5.wav";
			else self.noise2 = "ad171/ambience/windgust6.wav";
		}
	} else if (self.count <= 5) {
		self.noise = "ad171/ambience/windgust5.wav";
		if (self.lefty) {
			if (random() < 0.5) self.noise2 = "ad171/ambience/windgust4.wav";
			else self.noise2 = "ad171/ambience/windgust6.wav";
		}
	} else {
		self.noise = "ad171/ambience/windgust6.wav";
		if (self.lefty) {
			if (random() < 0.5) self.noise2 = "ad171/ambience/windgust4.wav";
			else self.noise2 = "ad171/ambience/windgust5.wav";
		}
	}

	if (self.volume < SOUND_VOLUME_MIN)  self.volume = 1;
	if (!self.speed) self.speed = 1;
	if (!self.delay) self.delay = 10;
	if (!self.wait) self.wait = 10;
	if (!self.waitmin) self.waitmin = 4 + random()*4;
	ambient_custom_sound(); // Back into main function
};

void() ambient_custom_wood = { // [ENTITY]
	// Always precache all sounds and then randomly pick one
	// load/save games will always generate new random selection
	// and that will produce cache errors everytime
	precache_sound ("ad171/ambience/woodcreak2a.wav");
	precache_sound ("ad171/ambience/woodcreak2b.wav");
	precache_sound ("ad171/ambience/woodcreak2c.wav");
	precache_sound ("ad171/ambience/woodcreak2d.wav");

	// Pick a random sound to start with
	if (self.count < 0) self.count = random()*4;
		
	if (self.count <= 1) {
		self.noise = "ad171/ambience/woodcreak2a.wav";
		// Pick an alternative random sound
		if (self.lefty) {
			if (random() < 0.5) self.noise2 = "ad171/ambience/woodcreak2b.wav";
			else self.noise2 = "ad171/ambience/woodcreak2c.wav";
		}
	} else if (self.count <= 2) {
		self.noise = "ad171/ambience/woodcreak2b.wav";
		if (self.lefty) {
			if (random() < 0.5) self.noise2 = "ad171/ambience/woodcreak2c.wav";
			else self.noise2 = "ad171/ambience/woodcreak2d.wav";
		}
	} else if (self.count <= 3) {
		self.noise = "ad171/ambience/woodcreak2c.wav";
		if (self.lefty) {
			if (random() < 0.5) self.noise2 = "ad171/ambience/woodcreak2a.wav";
			else self.noise2 = "ad171/ambience/woodcreak2d.wav";
		}
	} else {
		self.noise = "ad171/ambience/woodcreak2d.wav";
		if (self.lefty) {
			if (random() < 0.5) self.noise2 = "ad171/ambience/woodcreak2a.wav";
			else self.noise2 = "ad171/ambience/woodcreak2b.wav";
		}
	}

	if (self.volume < SOUND_VOLUME_MIN) self.volume = 1; // Default values for wood
	if (!self.speed) self.speed = 2;
	if (!self.delay) self.delay = 15;
	if (!self.wait) self.wait = 30;
	if (!self.waitmin) self.waitmin = 8 + random()*8;
	ambient_custom_sound(); // Back into main function
};

void() ambient_custom_chime = { // [ENTITY]
	if (self.noise == "") self.noise = "ad171/ambience/chimes.wav";
	if (!self.speed) self.speed = 2;
	if (self.volume < SOUND_VOLUME_MIN) self.volume = 1;
	if (!self.wait) self.wait = 10;
	if (!self.delay) self.delay = 10;
	if (!self.waitmin) self.waitmin = 10 + random()*10;
	if (!self.waitmin2) self.waitmin2 = -1;
	ambient_custom_sound(); // Back into main function
};

void() SuperDamageSound = { // [FUNCTION]
    if (self.super_damage_finished >= time) return;
	if (self.super_sound >= time) return;

	self.super_sound = time + 1;
	sound (self, CHAN_BODY, "items/damage3.wav", 1, ATTN_NORM);
};

void() ambient_drain = { // [ENTITY]
	self.noise = "nehahra/ambience/drain.wav";
	precache_sound (self.noise);
	if (self.volume < SOUND_VOLUME_MIN)self.volume = 0.5;
	ambient_sound_setup();
};

void() ambient_eerie = { // [ENTITY]
	self.noise = "nehahra/ambience/rych1.wav";
	precache_sound (self.noise);
	if (self.volume < SOUND_VOLUME_MIN) self.volume = 0.5;
	ambient_sound_setup();
};

void() ambient_factory = { // [ENTITY]
	self.noise = "nehahra/ambience/factory.wav";
	precache_sound (self.noise);
	if (self.volume <= 0) self.volume = 0.5;
	ambient_sound_setup();
};

void() ambient_fan_blowing = { // [ENTITY]
	self.noise = "nehahra/ambience/fanblow.wav";
	precache_sound (self.noise);
	if (self.volume < SOUND_VOLUME_MIN) self.volume = 0.5;
	ambient_sound_setup();
};

void() ambient_flies = { // [ENTITY]
	self.noise = "nehahra/ambience/bugs.wav";
	precache_sound (self.noise);
	if (self.volume < SOUND_VOLUME_MIN) self.volume = 0.5;
	ambient_sound_setup();
};

void() ambient_flys = { // [ENTITY]
	self.noise = "drake/misc/flys.wav";
	precache_sound (self.noise);
	if (self.volume < SOUND_VOLUME_MIN) self.volume = 0.5;
	ambient_sound_setup();
};

void() ambient_grinder = { // [ENTITY]
	self.noise = "quoth/ambience/grinder.wav";
	precache_sound (self.noise);
	if (self.volume < SOUND_VOLUME_MIN) self.volume = 1;
	ambient_sound_setup();
};

void() ambient_highwind = { // [ENTITY]
	self.noise = "quoth/necros/highwind.wav";
	precache_sound (self.noise);
	if (self.volume < SOUND_VOLUME_MIN) self.volume = 1;
	self.count = 99;
	ambient_sound_setup();
};

void() ambient_humming = { // [ENTITY]
	if (self.spawnflags & SOUND_ALTVERSION) {
		self.noise = "nehahra/ambience/maydn.wav"; // Support for Nehahra ambient_humming
		if (self.volume < SOUND_VOLUME_MIN) self.volume = 0.5;
	} else { 
		self.noise = "hipnotic/ambience/humming.wav";
		if (self.volume < SOUND_VOLUME_MIN) self.volume = 0.5;
	}
	precache_sound (self.noise);
	ambient_sound_setup();
};

void() ambient_hum1 = { // [ENTITY]
	self.noise = "ambience/hum1.wav";
	if (self.volume < SOUND_VOLUME_MIN) self.volume = 0.5;
	precache_sound (self.noise);
	ambient_sound_setup();
};

void() ambient_lapping = { // [ENTITY]
	self.noise = "quoth/necros/wat_amb.wav";
	precache_sound (self.noise);
	if (self.volume < SOUND_VOLUME_MIN) self.volume = 1;
	self.count = 99;
	ambient_sound_setup();
};

void() ambient_lapping2 = { // [ENTITY]
	self.noise = "ambience/wat_cave.wav";
	precache_sound (self.noise);
	if (self.volume < SOUND_VOLUME_MIN) self.volume = 1;
	self.count = 99;
	ambient_sound_setup();
};

void() ambient_machines = { // [ENTITY]
	self.noise = "nehahra/ambience/begths.wav";
	precache_sound (self.noise);
	if (self.volume < SOUND_VOLUME_MIN) self.volume = 1;
	ambient_sound_setup();
};

void() ambient_nehum = { // [ENTITY]
	self.noise = "nehahra/ambience/filt.wav";
	precache_sound (self.noise);
	if (self.volume < SOUND_VOLUME_MIN) self.volume = 1;
	ambient_sound_setup();
};

void() ambient_rain = { // [ENTITY]
	if (self.count == 0) self.noise = "rrp/ambient/rain.wav"; // Rain Runoff
	if (self.count == 1) self.noise = "ambience/rain3.wav"; // Steady Rain
	if (self.count == 2) self.noise = "zerstorer/ambience/rain.wav"; // Heavy Rain
	if (self.count > 2 || self.count < 0) self.noise = "ambience/rain3.wav";
	precache_sound (self.noise);
	if (self.volume < SOUND_VOLUME_MIN) self.volume = 1;
	ambient_sound_setup();
};

void() ambient_riftpower = { // [ENTITY]
	self.noise = "hipnotic/ambience/riftpowr.wav";
	precache_sound (self.noise);
	if (self.volume < SOUND_VOLUME_MIN) self.volume = 0.5;
	ambient_sound_setup();
};

void() ambient_running_lava = { // [ENTITY]
	self.noise = "ambience/runlava.wav";
	precache_sound (self.noise);
	if (self.volume < SOUND_VOLUME_MIN) self.volume = 0.5;
	ambient_sound_setup();
};

void() ambient_running_water = { ambient_bublfals(); };  // [ENTITY], Re-direct From custents, also used in travail as bublfals.wav

void() ambient_rushing = { // [ENTITY]
	self.noise = "drake/ambience/rushing.wav";
	precache_sound (self.noise);
	if (self.volume < SOUND_VOLUME_MIN) self.volume = 0.5;
	ambient_sound_setup();
};

void() ambient_sizzle = { // [ENTITY]
	self.noise = "nehahra/ambience/amsizl.wav";
	precache_sound (self.noise);
	if (self.volume < SOUND_VOLUME_MIN) self.volume = 0.5;
	ambient_sound_setup();
};

void() ambient_stargate_hum = { // [ENTITY]
	self.noise = "necros/sgatehum.wav";
	precache_sound (self.noise);
	if (self.volume < SOUND_VOLUME_MIN) self.volume = 1;
	self.count = 99;
	ambient_sound_setup();
};

void() ambient_swamp3 = { // [ENTITY]
	self.noise = "nehahra/ambience/swamp3.wav";
	precache_sound (self.noise);
	if (self.volume < SOUND_VOLUME_MIN) self.volume = 1;
	ambient_sound_setup();
};

void() ambient_teeth = { // [ENTITY]
	self.noise = "quoth/ambience/teeth.wav";
	precache_sound (self.noise);
	if (self.volume < SOUND_VOLUME_MIN) self.volume = 1;
	ambient_sound_setup();
};

void() ambient_teleport = { // [ENTITY]
	self.noise = "ambience/hum1.wav";
	precache_sound (self.noise);
	if (self.volume < SOUND_VOLUME_MIN) self.volume = 0.5;
	ambient_sound_setup();
};

void() ambient_thrum = { // [ENTITY]
	self.noise = "quoth/ambience/thrum.wav";
	precache_sound (self.noise);
	if (self.volume < SOUND_VOLUME_MIN) self.volume = 1;
	ambient_sound_setup();
};

void() ambient_waterfall = { // [ENTITY]
	self.noise = "drake/ambience/waterfal.wav";
	precache_sound (self.noise);
	if (self.volume < SOUND_VOLUME_MIN) self.volume = 0.5;
	ambient_sound_setup();
};

void() ambient_water_fall = { // [ENTITY]
	self.noise = "ne_ruins/ambience/wat_fall.wav";
	precache_sound (self.noise);
	if (self.volume < SOUND_VOLUME_MIN) self.volume = 1;
	self.count = 99;
	ambient_sound_setup();
};

void() ambient_whnoise = { // [ENTITY]
	self.noise = "nehahra/ambience/whn.wav";
	precache_sound (self.noise);
	if (self.volume < SOUND_VOLUME_MIN) self.volume = 1;
	ambient_sound_setup();
};

void() ambient_zzxzz = { // [ENTITY]
	self.noise = "nehahra/ambience/flash.wav";
	precache_sound (self.noise);
	if (self.volume < SOUND_VOLUME_MIN) self.volume = 1;
	ambient_sound_setup();
};
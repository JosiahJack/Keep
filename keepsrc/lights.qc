//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
//
// Attributions: All, though primarily Arcane Dimensions (AD)
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
// Entity count: 21
// Function count: 22
//
// Implements: Lights
//
// Description:
// Setups up light styles, switchable shadows, and defines basic lights.
//
// To help reduce signon buffer size, allow for light entities to be delay
// spawned (especially light models like candles).  Cannot use target key
// because compiler uses it for light styles, so use lighttarget.
//
// Only 32 switchable lights are allowed per map. The compiler re-uses the
// style key to keep track of the switchable lights which means they cannot
// have light style strings by default, so use customstyle_string.
//
// Rather than defined a completely new light style string, customstyle_remap
// allows for a light style to be a mirror/copy of another existing style.
//
// Setup all vanilla light styles into a small array (16 strings) called
// light_style_str.  These light styles can be referenced later for switchable
// lights.  Originally was setup in world.qc file but not as saved strings.
//=============================================================================

float LIGHT_STARTOFF = 1;
float LIGHT_NOSOUND = 2;
float LIGHT_QUOTHNOSTAT = 2;
float LIGHT_NOSTATIC = 4;
float LIGHT_FLAMEOFF = 2;
float LIGHT_CANDLESHADOW = 8;
float LIGHT_SWITCHFADE = 16;
float LIGHT_NOEFFECTS = 128;
float LIGHT_IDSTYLE = 12; // Protected default light styles
float LIGHT_COMPILERSTYLE = 32;
float LIGHT_MAXLIGHTSTYLE = 64;
float THUNDER_FLASH = 2;  // From temple2
.string	lighttarget;
.string customstyle_string;
.float customstyle_remap;
.float customstyle_update; // Determines how the customstyle is updated with trigger function, 0 always update, 1 no update, 2 only update if estate/light on.
float LIGHT_BSP2LIGHTSTYLE = 256; // Possible extended BSP2 standard ... who knows!
string light_style_str[LIGHT_MAXLIGHTSTYLE]; // The array is setup from world.qc before anything loads

// Allow the compile to change the starting point for target lights
void() light_style_boundary = { // [FUNCTION]
	if (world.compilerstyle_start == 0) mapstyle_start = LIGHT_COMPILERSTYLE; // Check worldspawn key for starting point of target lights
	else mapstyle_start = world.compilerstyle_start;
	
	if (mapstyle_start < LIGHT_IDSTYLE) mapstyle_start = LIGHT_IDSTYLE; // Make sure it does not overwrite default (0-11) ID styles
};

// These are identical in Half-Life: Alyx; over 25 years later the same strings are used to define light flickering!!
void() light_style_setuparray = { // [FUNCTION]
	local float loopint;
	
	light_style_str[0] = "m"; // 0 normal
	light_style_str[1] = "mmnmmommommnonmmonqnmmo"; // 1 FLICKER (first variety)
	light_style_str[2] = "abcdefghijklmnopqrstuvwxyzyxwvutsrqponmlkjihgfedcba"; // 2 SLOW STRONG PULSE
	light_style_str[3] = "mmmmmaaaaammmmmaaaaaabcdefgabcdefg"; // 3 CANDLE (first variety)
	light_style_str[4] = "mamamamamama"; // 4 FAST STROBE
	light_style_str[5] = "jklmnopqrstuvwxyzyxwvutsrqponmlkj"; // 5 GENTLE PULSE 1
	light_style_str[6] = "nmonqnmomnmomomno"; // 6 FLICKER (second variety)
	light_style_str[7] = "mmmaaaabcdefgmmmmaaaammmaamm"; // 7 CANDLE (second variety)
	light_style_str[8] = "mmmaaammmaaammmabcdefaaaammmmabcdefmmmaaaa"; // 8 CANDLE (third variety)
	light_style_str[9] = "aaaaaaaazzzzzzzz"; // 9 SLOW STROBE (fourth variety)
	light_style_str[10] = "mmamammmmammamamaaamammma"; // 10 FLUORESCENT FLICKER, as seen in Half-Life: Alyx, and Half-Life 2, and Half-Life, etc. etc.
	light_style_str[11] = "abcdefghijklmnopqrrqponmlkjihgfedcba"; // 11 SLOW PULSE NOT FADE TO BLACK
	loopint = LIGHT_IDSTYLE; // Setup default ("m") for all the custom map styles (12-63)
	while (loopint < LIGHT_MAXLIGHTSTYLE) {
		light_style_str[loopint] = "m";
		loopint = loopint + 1;
	}

	lightstyle(FALSE,"m");
	lightstyle(TRUE,"mmnmmommommnonmmonqnmmo");
	lightstyle(FL_SWIM,"abcdefghijklmnopqrstuvwxyzyxwvutsrqponmlkjihgfedcba");
	lightstyle(MOVETYPE_WALK,"mmmmmaaaaammmmmaaaaaabcdefgabcdefg");
	lightstyle(MOVETYPE_STEP,"mamamamamama");
	lightstyle(MOVETYPE_FLY,"jklmnopqrstuvwxyzyxwvutsrqponmlkj");
	lightstyle(MOVETYPE_TOSS,"nmonqnmomnmomomno");
	lightstyle(MOVETYPE_PUSH,"mmmaaaabcdefgmmmmaaaammmaamm");
	lightstyle(FL_CLIENT,"mmmaaammmaaammmabcdefaaaammmmabcdefmmmaaaa");
	lightstyle(MOVETYPE_FLYMISSILE,"aaaaaaaazzzzzzzz");
	lightstyle(MOVETYPE_BOUNCE,"mmamammmmammamamaaamammma");
	lightstyle(MOVETYPE_BOUNCEMISSILE,"abcdefghijklmnopqrrqponmlkjihgfedcba");
	lightstyle(63.000,"a");
};

void() play_light_sound = { // [FUNCTION]
	if (!self.owner) return;
	if (self.owner.estate & ESTATE_BLOCK) return;
	
	self.think = play_light_sound;
	self.nextthink = time + self.owner.waitmin;
	sound(self,CHAN_VOICE, self.owner.noise, self.owner.volume,ATTN_STATIC);
};

void() setup_light_sound = { // [FUNCTION]
	if (!self.volume) self.volume = 0.5;
	if ( !(self.spawnflags & LIGHT_NOSOUND) && self.noise != "") {
		if (self.targetname) {
			self.attachment = spawn();
			self.attachment.owner = self;
			setorigin(self.attachment, self.origin);
			self.attachment.nextthink = time + 1;
			self.attachment.think = play_light_sound;
		}
		else {
			ambientsound(self.origin, self.noise, self.volume,ATTN_QUIET);
		}
	}
};

void() setup_light_static = { // [FUNCTION]
	if (self.spawnflags & LIGHT_NOSTATIC) return; // Default = static, check for exception spawnflag

	if (self.mdl) setmodel(self, self.mdl); // Setup any models that are defined
	if (self.part_emitter && self.part_static == FALSE) return; // Cannot have static entities and particle emitters!

	makestatic (self); // Goodbye entity, no longer interactive with QC
};

// Setup particle static flag
void() setup_vanilla_nostatic = { // [FUNCTION]
	if (self.spawnflags & LIGHT_NOSTATIC) self.part_static = FALSE;
	else if (self.targetname != "") self.part_static = FALSE;
	else self.part_static = TRUE;	
};

// Need to change around spawnflags; 2 -> 4 bitflags
void() setup_quoth_nostatic = { // [FUNCTION]
	if (!(self.spawnflags & LIGHT_QUOTHNOSTAT)) return;

	self.spawnflags = self.spawnflags - (self.spawnflags & LIGHT_QUOTHNOSTAT);
	self.spawnflags = self.spawnflags | LIGHT_NOSTATIC;
};

void(float pe_style) setup_light_particle = { // [FUNCTION]
	if (self.spawnflags & LIGHT_NOEFFECTS) return;

	// Spawn particle emitter if particles active and not blocked
	if (query_configflag(SVR_PARTICLES) == SVR_PARTICLES ) {
		self.part_active = pe_style;
		if (self.spawnflags & LIGHT_STARTOFF) self.lip = PARTICLE_START_OFF;
		else self.lip = PARTICLE_START_ON;
		self.part_emitter = spawn_pemitter(self, self, self.part_active, self.lip);
	}
};

void() light_part_emitter_on = { // [FUNCTION]
	if (self.part_emitter) {
		if (ext_dppart && self.part_emitter.state == STATE_OFF) pointparticles(particleeffectnum(DPP_BURSTFLAME), self.origin, '0 0 0', 1);
		misc_particle_on(self.part_emitter);
	}

	if (self.attachment) {
		self.attachment.think = play_light_sound;
		self.attachment.nextthink = time + 0.1;
	}
};

void() light_on = { // [FUNCTION]
	self.estate = ESTATE_ON;
	if (self.mdl) setmodel(self, self.mdl); // Setup any models, like torches etc

	if (self.style > 0) { // Light style defined?
		if (self.style < LIGHT_MAXLIGHTSTYLE) lightstyle(self.style, light_style_str[self.style]); // Update light style (use array to get the latest)
	}

	light_part_emitter_on(); // Switch on particle emitters, if any.
};

void() light_off = { // [FUNCTION]
	self.estate = ESTATE_OFF;
	if (self.mdl) {
		self.modelindex = 0;
		self.model = "";
	}
	
	lightstyle(self.style, "a"); // Switch off light style
	if (self.attachment) StopSound(self.attachment,CHAN_VOICE); // Stop any sounds
};

void() light_customstyle_finish = { // [FUNCTION]
	// Check for style errors above compiler light boundary.  Only for lights with style range issues + customstyles remap/string.
	if (self.style >= mapstyle_start && self.targetname == "") {
		// The light entity is using a style number in the compiler generated (they always have targetname) target light zone.
		spawn_marker(self.origin,'0 0 0',0,SPNMARK_YELLOW); // If this issue is left, weird things will start happening to lightstyles, highlight error to mapper.
		dprint("\b[LIGHT]\b style ("); dprint(ftos(self.style));
		dprint(") cannot be used, error!  Don't use 12 - 62 for self.style!\n");
		remove(self);
		return;
	}

	// Style has to be different to re-map
	if (self.customstyle_remap > 0 && self.customstyle_remap == self.style) {
		spawn_marker(self.origin,'0 0 0',0,SPNMARK_YELLOW);
		dprint("\b[LIGHT]\b remap and style are the same!\n");
		remove(self);
		return;
	}

	// Any re-map custom style lights defined?
	if (self.customstyle_remap > 0 && self.style > 0) {
		if (self.customstyle_remap < LIGHT_MAXLIGHTSTYLE) self.customstyle_string = light_style_str[self.customstyle_remap]; // Copy string from array
		dprint("\b[LIGHT]\b ("); dprint(self.classname); // Show debug info for custom lightstyle remaps
		dprint(") style ("); dprint(ftos(self.style));
		dprint(") remap ("); dprint(ftos(self.customstyle_remap));
		dprint(")\n");
	}

	// Any custom style light string defined?
	// No style check, so that 0 (default, whole map) can be changed
	if (self.customstyle_string != "") {
		if (self.style >= 0 && self.style < LIGHT_MAXLIGHTSTYLE) light_style_str[self.style] = self.customstyle_string; // Save the light style to the array
		lightstyle(self.style, self.customstyle_string); // Define new light style to the engine

		// Only show debug info for new custom lightstyles not remaps
		if (self.customstyle_remap == 0) {
			dprint("\b[LIGHT]\b ("); dprint(self.classname);
			dprint(") style ("); dprint(ftos(self.style));
			dprint(") string ("); dprint(self.customstyle_string);
			dprint(")\n");
		}
	}
	
	// Is this a switchable light?
	if (self.targetname != "") {
		// Setup Entity State functionality
		self.use = entity_state_use;
		if (!self.estate_on) self.estate_on = light_on;
		if (!self.estate_off) self.estate_off = light_off;
		if (self.spawnflags & LIGHT_STARTOFF) self.estate_off();
		else self.estate_on();
	} else {
		if (self.classtype == CT_LIGHT) remove(self); // No more world interaction required (no targetname).  Either remove light or make it static (model exists).
		else if (self.classtype == CT_LIGHTSTATIC) setup_light_static();
	}
};

void() light_customstyle_start = { // [FUNCTION]
	// Need to check style and remap values are within range FIRST.  Will be serious crash because its an index for fixed size array.
	if (self.style < 0 || self.style >= LIGHT_MAXLIGHTSTYLE) {
		spawn_marker(self.origin,'0 0 0',0,SPNMARK_YELLOW);
		dprint("\b[LIGHT]\b light style ("); dprint(ftos(self.style));
		dprint(") out of range at location");
		dprint(vtos(self.origin));
		dprint(". Set to 0\n");
		self.style = 0;
	} else if (self.customstyle_remap < 0 || self.customstyle_remap >= LIGHT_MAXLIGHTSTYLE) {
		spawn_marker(self.origin,'0 0 0',0,SPNMARK_YELLOW);
		dprint("\b[LIGHT]\b customstyle_remap ("); dprint(ftos(self.customstyle_remap));
		dprint(") out of range at location");
		dprint(vtos(self.origin));
		dprint(". Set to 0\n");
		self.customstyle_remap = 0;
	}

	// All custom lightstyle strings must happen FIRST, so that
	// the array is setup with all the correct strings for remaps
	// Needs slight delay to make sure array has defaults setup
	// No style key check so that style 0 (whole map) can be changed
	if (self.customstyle_string != "") {
		// string has priority over remap
		self.customstyle_remap = 0;
		self.think = light_customstyle_finish;
		self.nextthink = time + 0.1;
	} else if (self.customstyle_remap > 0 && self.style > 0) {
		// Re-map lightstyles MUST happen after custom lightstyle strings
		// These lights will have problems being static because of timing
		// Static lights need to be converted early to work properly
		// Will be redefined later
		self.customstyle_string = "";
		self.think = light_customstyle_finish;
		self.nextthink = time + 0.3;
	} else if (self.targetname != "") light_customstyle_finish(); // Finally switchable lights with styles defined by the compiler.  These are not removeable or static because of interaction.  Will need entity state setup and 'use' functionality
	else {
		if (self.classtype == CT_LIGHT) remove(self); // DEFAULT = No world interaction because no targetname.  Either remove light or make it static (model exists).  This should be happening at spawntime + 0.0
		else if (self.classtype == CT_LIGHTSTATIC) setup_light_static();
	}
};

// QUAKED light (0 1 0) (-8 -8 -8) (8 8 8) LIGHTOFF x x x x x x x
// -------- KEYS --------
// targetname : toggle state (use trigger ent for exact state)
// light : sets brightness, 300 is default
// style : 0 = normal
        // 1 = flicker (first variety)
        // 2 = slow strong pulse
        // 3 = candle (first variety)
        // 4 = fast strobe
        // 5 = gentle pulse
        // 6 = flicker (second variety)
        // 7 = candle (second variety)
        // 8 = candle (third variety)
        // 9 = slow strobe
       // 10 = flourescent flicker
       // 11 = slow pulse, not fading to black
// styles 01-63 can be custom in map (use customstyle_string)
// styles 32-63 are assigned by the light program for switchable lights

// customstyle_remap  : Re-use another light style (0-63)
// customstyle_string : light value string made up of "a-z" letters

// _color : Light color - R/G/B (def='1 1 1')
// wait   : Fade distance multiplier (def=1)
// delay  : Attenuation 0=Linear, 1=inverse, 2=Squared, 3=NoFalloff, 4=Minlight, 5=Good Ambient
// mangle : Spotlight direction
// angle  : Spotlight cone angle (def=40)

// _dirt       : Dirt map (override)
// _dirtscale  : Dirt scale (override)
// _deviance   : Deviance
// _samples    : No. of Deviance lights (def=16)
// _surface    : Surface light texture name
// _surface_offset : Surface light offset (def=2)
// _softangle  : Spotlight soft angle (def=0)
// _anglescale : Light angle scale (def=0.5)
// -------- SPAWNFLAGS --------
// LIGHTOFF : Starts off and waits for trigger
// -------- NOTES --------
// Non-displayed light. If targeted, it will toggle between on or off.
void() light = { // [ENTITY]
	if (self.mdl != "") precache_model (self.mdl); // If any model defined, cache it
	self.classtype = CT_LIGHT;
	if (self.targetname && self.spawnflags & THUNDER_FLASH && !self.customstyle_string) self.customstyle_string = "mhkcgkhf"; // Custom style still overrides thunder spawnflag, it's too rare.  From temple2.
	light_customstyle_start(); // Check for any custom light styles
};

// QUAKED light_fluoro (0 1 0) (-8 -8 -8) (8 8 8) LIGHTOFF NO_SOUND x x x x x x
// -------- KEYS --------
// targetname : toggle state (use trigger ent for exact state)
// light      : sets brightness, 300 is default
// _color     : Light color - R/G/B (def='1 1 1')
// wait       : Fade distance multiplier (def=1)
// delay      : Attenuation 0=Linear, 1=inverse, 2=Squared, 3=NoFalloff, 4=Minlight, 5=Good Ambient
// mangle     : Spotlight direction
// angle      : Spotlight cone angle (def=40)

// _dirt      : Dirt map (override)
// _dirtscale : Dirt scale (override)
// _deviance  : Deviance
// _samples   : No. of Deviance lights (def=16)
// _surface   : Surface light texture name
// _surface_offset : Surface light offset (def=2)
// _softangle : Spotlight soft angle (def=0)
// _anglescale: Light angle scale (def=0.5)
// -------- SPAWNFLAGS --------
// LIGHTOFF   : Starts off and waits for trigger
// NO_SOUND   : No ambient sound
// -------- NOTES --------
// Non-displayed light. Makes steady fluorescent humming sound
void() light_fluoro = { // [ENTITY]
	if (self.noise == "") self.noise = "ambience/fl_hum1.wav"; // Allow for custom sound
	precache_sound(self.noise);
	self.classtype = CT_LIGHTSTATIC; // Default = static entity, check done in static function
	light_customstyle_start(); // Check for any custom light styles
	setup_vanilla_nostatic();
	setup_light_sound(); // Setup ambient sound/noise
};

// QUAKED light_fluorospark (0 1 0) (-8 -8 -8) (8 8 8) x NO_SOUND x x x x x x
// -------- KEYS --------
// targetname : toggle state (use trigger ent for exact state)
// light      : sets brightness, 300 is default
// _color     : Light color - R/G/B (def='1 1 1')
// wait       : Fade distance multiplier (def=1)
// delay      : Attenuation 0=Linear, 1=inverse, 2=Squared, 3=NoFalloff, 4=Minlight, 5=Good Ambient
// mangle     : Spotlight direction
// angle      : Spotlight cone angle (def=40)

// _dirt      : Dirt map (override)
// _dirtscale : Dirt scale (override)
// _deviance  : Deviance
// _samples   : No. of Deviance lights (def=16)
// _surface   : Surface light texture name
// _surface_offset : Surface light offset (def=2)
// _softangle : Spotlight soft angle (def=0)
// _anglescale: Light angle scale (def=0.5)
// -------- SPAWNFLAGS --------
// NO_SOUND   : No ambient sound
// -------- NOTES --------
// Non-displayed light. Makes sparking, broken fluorescent sound
void() light_fluorospark = { // [ENTITY]
	if (self.noise == "") self.noise = "ambience/buzz1.wav"; // Allow for custom sound
	precache_sound(self.noise);
	if (!self.style) self.style = 10; // Wait for worldspawn to be read correctly
	self.classtype = CT_LIGHTSTATIC; // Default = static entity, check done in static function
	setup_vanilla_nostatic();
	light_customstyle_start(); // Check for any custom light styles
	setup_light_sound(); // Setup ambient sound/noise
};

// QUAKED light_globe (0 1 0) (-8 -8 -8) (8 8 8) LIGHTOFF x NO_STATIC x x x X x { model(":progs/s_light.spr"); }
// -------- KEYS --------
// targetname : toggle state (use trigger ent for exact state)
// light      : sets brightness, 300 is default
// _color     : Light color - R/G/B (def='1 1 1')
// wait       : Fade distance multiplier (def=1)
// delay      : Attenuation 0=Linear, 1=inverse, 2=Squared, 3=NoFalloff, 4=Minlight, 5=Good Ambient
// mangle     : Spotlight direction
// angle      : Spotlight cone angle (def=40)

// _dirt      : Dirt map (override)
// _dirtscale : Dirt scale (override)
// _deviance  : Deviance
// _samples   : No. of Deviance lights (def=16)
// _surface   : Surface light texture name
// _surface_offset : Surface light offset (def=2)
// _softangle : Spotlight soft angle (def=0)
// _anglescale: Light angle scale (def=0.5)
// -------- SPAWNFLAGS --------
// LIGHTOFF   : Starts off and waits for trigger
// NO_STATIC  : Will not turn into static entity
// -------- NOTES --------
// Sphere globe light (sprite)
void() light_globe = { // [ENTITY]
	self.mdl = "progs/s_light.spr";
	precache_model (self.mdl);
	setmodel(self, self.mdl);
	setsize (self, VEC_ORIGIN, VEC_ORIGIN);
	self.classtype = CT_LIGHTSTATIC; // Default = static entity, check done in static function
	setup_vanilla_nostatic();
	light_customstyle_start(); // Check for any custom light styles
};

void() light_torch_on = { // [FUNCTION]
	self.frame = 0;
	self.estate = ESTATE_ON;
	if (self.style >= 0 && self.style < LIGHT_MAXLIGHTSTYLE) lightstyle(self.style, light_style_str[self.style]); // Light style defined? (use array to get the latest)
	else lightstyle(self.style,"m");
	light_part_emitter_on();
};

void() light_torch_off = { // [FUNCTION]
	self.frame = 1;
	self.estate = ESTATE_OFF;
	lightstyle(self.style, "a");
	if (self.attachment) StopSound(self.attachment,CHAN_VOICE);
};

// QUAKED light_torch_small_walltorch (0 .5 0) (-10 -10 -20) (10 10 20) LIGHTOFF NO_SOUND NO_STATIC x x x x NOPARTICLES { model(":progs/q15/flame.mdl"); }
// -------- KEYS --------
// targetname : toggle state (use trigger ent for exact state)
// light      : sets brightness, 300 is default
// _color     : Light color - R/G/B (def='1 1 1')
// wait       : Fade distance multiplier (def=1)
// delay      : Attenuation 0=Linear, 1=inverse, 2=Squared, 3=NoFalloff, 4=Minlight, 5=Good Ambient
// mangle     : Spotlight direction
// angle      : Spotlight cone angle (def=40)

// _dirt      : Dirt map (override)
// _dirtscale : Dirt scale (override)
// _deviance  : Deviance
// _samples   : No. of Deviance lights (def=16)
// _surface   : Surface light texture name
// _surface_offset : Surface light offset (def=2)
// _softangle : Spotlight soft angle (def=0)
// _anglescale: Light angle scale (def=0.5)
// -------- SPAWNFLAGS --------
// LIGHTOFF   : Starts off and waits for trigger
// NO_SOUND   : No ambient sound
// NO_STATIC  : Will not turn into static entity
// NOPARTICLES: No particle or effects active
// -------- NOTES --------
// Short wall torch
void() light_torch_small_walltorch = { // [ENTITY]
	if (self.mdl == "") self.mdl = "progs/q15/flame.mdl"; // // Allow for custom models.  Using the SMC/Q1.5 version as it has on/off frames
	precache_model (self.mdl);
	if (self.noise == "") self.noise = "ambience/fire1.wav"; // Allow for custom sounds
	precache_sound(self.noise);
	if (!self.waitmin) self.waitmin = 2.165; // Default for fire1 sound
	setmodel(self, self.mdl);
	setsize (self, VEC_ORIGIN, VEC_ORIGIN);
	if (self.angles_y < 0) self.angles_y = rint(random()*359); // Setting the angle key in the editor to UP/DOWN = random rotation.  I dunno, might be nice if there's a lot.
	self.classtype = CT_LIGHTSTATIC; // Default = static entity, check done in static function
	setup_vanilla_nostatic();
	setup_light_sound();
	setup_light_particle(PARTICLE_STYLE_FLAMET);
	self.estate_on = light_torch_on; // Custom estate on/off functions
	self.estate_off = light_torch_off;
	light_customstyle_start(); // Check for any custom light styles
};

// QUAKED light_flame_large_yellow (0 1 0) (-8 -8 -8) (8 8 8) LIGHTOFF NO_SOUND NO_STATIC x x x x NOPARTICLES { model(":progs/flame2.mdl"); }
// -------- KEYS --------
// targetname : toggle state (use trigger ent for exact state)
// light      : sets brightness, 300 is default
// _color     : Light color - R/G/B (def='1 1 1')
// wait       : Fade distance multiplier (def=1)
// delay      : Attenuation 0=Linear, 1=inverse, 2=Squared, 3=NoFalloff, 4=Minlight, 5=Good Ambient
// mangle     : Spotlight direction
// angle      : Spotlight cone angle (def=40)

// _dirt      : Dirt map (override)
// _dirtscale : Dirt scale (override)
// _deviance  : Deviance
// _samples   : No. of Deviance lights (def=16)
// _surface   : Surface light texture name
// _surface_offset : Surface light offset (def=2)
// _softangle : Spotlight soft angle (def=0)
// _anglescale: Light angle scale (def=0.5)
// -------- SPAWNFLAGS --------
// LIGHTOFF   : Starts off and waits for trigger
// NO_SOUND   : No ambient sound
// NO_STATIC  : Will not turn into static entity
// NOPARTICLES: No particle or effects active
// -------- NOTES --------
// Large yellow flame
void() light_flame_large_yellow = { // [ENTITY]
	if (self.mdl == "") self.mdl = "progs/flame2.mdl"; // Allow for custom models
	precache_model (self.mdl);
	if (self.noise == "") self.noise = "ambience/fire1.wav"; // Allow for custom sounds
	precache_sound(self.noise);
	if (!self.waitmin) self.waitmin = 2.165; // The default length of the ambient fire1 sound
	if (engine == ENG_DPEXT) self.effects = self.effects + EF_NOSHADOW; // If DP engine active remove model shadow
	setmodel(self, self.mdl);
	setsize (self, VEC_ORIGIN, VEC_ORIGIN);
	self.frame = 1;			// Switch to frame group 2 (larger flame)
	if (!self.alpha) self.alpha = 0.8;
	if (self.angles_y <= 0) self.angles_y = rint(random()*359); // Setting the angle key in the editor to UP/DOWN = random rotation	
	self.classtype = CT_LIGHTSTATIC; // Default = static entity, check done in static function
 	setup_vanilla_nostatic();
	setup_light_sound();
	setup_light_particle(PARTICLE_STYLE_FLAMEL);
	light_customstyle_start(); // Check for any custom light styles
};

// QUAKED light_flame_small_yellow (0 1 0) (-8 -8 -8) (8 8 8) LIGHTOFF NO_SOUND NO_STATIC x x x x NOPARTICLES { model(":progs/flame2.mdl"); }
// -------- KEYS --------
// targetname : toggle state (use trigger ent for exact state)
// light      : sets brightness, 300 is default
// _color     : Light color - R/G/B (def='1 1 1')
// wait       : Fade distance multiplier (def=1)
// delay      : Attenuation 0=Linear, 1=inverse, 2=Squared, 3=NoFalloff, 4=Minlight, 5=Good Ambient
// mangle     : Spotlight direction
// angle      : Spotlight cone angle (def=40)

// _dirt      : Dirt map (override)
// _dirtscale : Dirt scale (override)
// _deviance  : Deviance
// _samples   : No. of Deviance lights (def=16)
// _surface   : Surface light texture name
// _surface_offset : Surface light offset (def=2)
// _softangle : Spotlight soft angle (def=0)
// _anglescale: Light angle scale (def=0.5)
// -------- SPAWNFLAGS --------
// LIGHTOFF   : Starts off and waits for trigger
// NO_SOUND   : No ambient sound
// NO_STATIC  : Will not turn into static entity
// NOPARTICLES: No particle or effects active
// -------- NOTES --------
// Small yellow flames.
void() light_flame_small_yellow = { // [ENTITY]
	if (self.mdl == "") self.mdl = "progs/flame2.mdl"; // Allow for custom models
	precache_model (self.mdl);
	if (self.noise == "") self.noise = "ambience/fire1.wav"; // Allow for custom sounds
	precache_sound(self.noise);
	if (!self.waitmin) self.waitmin = 2.165; // The default length of the ambient fire1 sound
	if (engine == ENG_DPEXT) self.effects = self.effects + EF_NOSHADOW; // If DP engine active remove candle model shadow
	setmodel(self, self.mdl);
	setsize (self, VEC_ORIGIN, VEC_ORIGIN);
	if (!self.alpha) self.alpha = 0.8;
	if (self.angles_y <= 0) self.angles_y = rint(random()*359); // Setting the angle key in the editor to UP/DOWN = random rotation	
	self.classtype = CT_LIGHTSTATIC; // Default = static entity, check done in static function
	setup_vanilla_nostatic();
	setup_light_sound();
	self.part_active = PARTICLE_STYLE_FLAMES;
	setup_light_particle(PARTICLE_STYLE_FLAMES);
	light_customstyle_start(); // Check for any custom light styles
};

void() light_flame_small_white = { light_flame_small_yellow(); }; // [ENTITY], Duplicate of small yellow flame.

// QUAKED light_postlight (0 .5 0) (-8 -8 -32) (8 8 16) LIGHTOFF NOTSTATIC x x x x x x { model(":progs/quoth/lightpost.mdl"); }
// -------- KEYS --------
// targetname : toggle state (use trigger ent for exact state)
// light      : sets brightness, 300 is default
// _color     : Light color - R/G/B (def='1 1 1')
// wait       : Fade distance multiplier (def=1)
// delay      : Attenuation 0=Linear, 1=inverse, 2=Squared, 3=NoFalloff, 4=Minlight, 5=Good Ambient
// mangle     : Spotlight direction
// angle      : Spotlight cone angle (def=40)

// _dirt      : Dirt map (override)
// _dirtscale : Dirt scale (override)
// _deviance  : Deviance
// _samples   : No. of Deviance lights (def=16)
// _surface   : Surface light texture name
// _surface_offset : Surface light offset (def=2)
// _softangle : Spotlight soft angle (def=0)
// _anglescale: Light angle scale (def=0.5)
// -------- SPAWNFLAGS --------
// LIGHTOFF   : Starts off and waits for trigger
// NOTSTATIC  : Not static entity (useful for switchable lights)
// -------- NOTES --------
// light post (from Quoth)
void() light_postlight = { // [ENTITY]
	if (self.mdl == "") self.mdl = "progs/quoth/lightpost.mdl";
	precache_model (self.mdl);
	self.classtype = CT_LIGHTSTATIC; // Default = static entity, check done in static function
	setup_quoth_nostatic();
	setup_vanilla_nostatic();
	light_customstyle_start(); // Check for any custom light styles
};

// QUAKED light_tubelight (0 .5 0) (-8 -8 -32) (8 8 16) LIGHTOFF NOTSTATIC x x x x x x { model(":progs/quoth/lighttube.mdl"); }
// -------- KEYS --------
// targetname : toggle state (use trigger ent for exact state)
// light      : sets brightness, 300 is default
// _color     : Light color - R/G/B (def='1 1 1')
// wait       : Fade distance multiplier (def=1)
// delay      : Attenuation 0=Linear, 1=inverse, 2=Squared, 3=NoFalloff, 4=Minlight, 5=Good Ambient
// mangle     : Spotlight direction
// angle      : Spotlight cone angle (def=40)

// _dirt      : Dirt map (override)
// _dirtscale : Dirt scale (override)
// _deviance  : Deviance
// _samples   : No. of Deviance lights (def=16)
// _surface   : Surface light texture name
// _surface_offset : Surface light offset (def=2)
// _softangle : Spotlight soft angle (def=0)
// _anglescale: Light angle scale (def=0.5)
// -------- SPAWNFLAGS --------
// LIGHTOFF   : Starts off and waits for trigger
// NOTSTATIC  : Not static entity (useful for switchable lights)
// -------- NOTES --------
// light Tube (from Quoth)
void() light_tubelight = { // [ENTITY]
	if (self.mdl == "") self.mdl = "progs/quoth/lighttube.mdl";
	precache_model (self.mdl);
	self.classtype = CT_LIGHTSTATIC; // Default = static entity, check done in static function
	setup_quoth_nostatic();
	setup_vanilla_nostatic();
	light_customstyle_start(); // Check for any custom light styles
};

// QUAKED light_flame_pyre (0 .5 0) (-32 -32 -8) (32 32 56) LIGHTOFF NOSTATIC x x x x x NOPARTICLES { model(":progs/ad181/misc_flame_big.mdl"); }
// -------- KEYS --------
// targetname : toggle state (use trigger ent for exact state)
// light      : sets brightness, 300 is default
// _color     : Light color - R/G/B (def='1 1 1')
// wait       : Fade distance multiplier (def=1)
// delay      : Attenuation 0=Linear, 1=inverse, 2=Squared, 3=NoFalloff, 4=Minlight, 5=Good Ambient
// mangle     : Spotlight direction
// angle      : Spotlight cone angle (def=40)

// _dirt      : Dirt map (override)
// _dirtscale : Dirt scale (override)
// _deviance  : Deviance
// _samples   : No. of Deviance lights (def=16)
// _surface   : Surface light texture name
// _surface_offset : Surface light offset (def=2)
// _softangle : Spotlight soft angle (def=0)
// _anglescale: Light angle scale (def=0.5)
// -------- SPAWNFLAGS --------
// LIGHTOFF   : Starts off and waits for trigger
// NOTSTATIC  : Not static entity (useful for switchable lights)
// NOPARTICLES: No particle or effects active
// -------- NOTES --------
// Flame Pyre (from Quoth)
void() light_flame_pyre = { // [ENTITY]
	if (self.mdl == "") self.mdl = "progs/quoth/flame_pyre.mdl";
	precache_model (self.mdl);
	self.classtype = CT_LIGHTSTATIC; // Default = static entity, check done in static function
	setup_quoth_nostatic();
	setup_vanilla_nostatic();
	setup_light_sound();
	setup_light_particle(PARTICLE_STYLE_FLAMEL);
	light_customstyle_start(); // Check for any custom light styles
};

// QUAKED light_flame_brazier_short (0 .5 0) (-8 -8 -16) (8 8 8) LIGHTOFF NOTSTATIC x x x x x NOPARTICLES { model(":progs/quoth/brazshrt.mdl"); }
// -------- KEYS --------
// targetname : toggle state (use trigger ent for exact state)
// light      : sets brightness, 300 is default
// skin       : 0=knave(def), 1=rust, 2=redbrick, 3=copper, 4=altar, 5=wizmet
// _color     : Light color - R/G/B (def='1 1 1')
// wait       : Fade distance multiplier (def=1)
// delay      : Attenuation 0=Linear, 1=inverse, 2=Squared, 3=NoFalloff, 4=Minlight, 5=Good Ambient
// mangle     : Spotlight direction
// angle      : Spotlight cone angle (def=40)

// _dirt      : Dirt map (override)
// _dirtscale : Dirt scale (override)
// _deviance  : Deviance
// _samples   : No. of Deviance lights (def=16)
// _surface   : Surface light texture name
// _surface_offset : Surface light offset (def=2)
// _softangle : Spotlight soft angle (def=0)
// _anglescale: Light angle scale (def=0.5)
// -------- SPAWNFLAGS --------
// LIGHTOFF   : Starts off and waits for trigger
// NOTSTATIC  : Not static entity (useful for switchable lights)
// NOPARTICLES: No particle or effects active
// -------- NOTES --------
// Short brazier (from Quoth)
void() light_flame_brazier_short = { // [ENTITY]
	if (self.mdl == "") self.mdl = "progs/quoth/brazshrt.mdl";
	precache_model (self.mdl);
	self.classtype = CT_LIGHTSTATIC; // Default = static entity, check done in static function
	setup_quoth_nostatic();
	setup_vanilla_nostatic();
	setup_light_sound();
	setup_light_particle(PARTICLE_STYLE_FLAMES);
	light_customstyle_start(); // Check for any custom light styles
};

// QUAKED light_flame_brazier_tall (0 .5 0) (-8 -8 -64) (8 8 8) LIGHTOFF NOTSTATIC x x x x x NOPARTICLES{ model(":progs/quoth/braztall.mdl"); }
// -------- KEYS --------
// targetname : toggle state (use trigger ent for exact state)
// light      : sets brightness, 300 is default
// skin       : 0=knave(def), 1=rust, 2=redbrick, 3=copper, 4=altar, 5=wizmet
// _color     : Light color - R/G/B (def='1 1 1')
// wait       : Fade distance multiplier (def=1)
// delay      : Attenuation 0=Linear, 1=inverse, 2=Squared, 3=NoFalloff, 4=Minlight, 5=Good Ambient
// mangle     : Spotlight direction
// angle      : Spotlight cone angle (def=40)
// _dirt      : Dirt map (override)
// _dirtscale : Dirt scale (override)
// _deviance  : Deviance
// _samples   : No. of Deviance lights (def=16)
// _surface   : Surface light texture name
// _surface_offset : Surface light offset (def=2)
// _softangle : Spotlight soft angle (def=0)
// _anglescale: Light angle scale (def=0.5)
// -------- SPAWNFLAGS --------
// LIGHTOFF   : Starts off and waits for trigger
// NOTSTATIC  : Not static entity (useful for switchable lights)
// NOPARTICLES: No particle or effects active
// -------- NOTES --------
// Long brazier (from Quoth)
void() light_flame_brazier_tall = { // [ENTITY]
	if (self.mdl == "") self.mdl = "progs/quoth/braztall.mdl";
	precache_model (self.mdl);
	self.classtype = CT_LIGHTSTATIC;
	setup_quoth_nostatic(); // Default = static entity, check done in static function
	setup_vanilla_nostatic();
	setup_light_sound();
	setup_light_particle(PARTICLE_STYLE_FLAMES);
	light_customstyle_start(); // Check for any custom light styles
};

// QUAKED light_torch_long_walltorch (0 .5 0) (-8 -8 -48) (8 8 80) LIGHTOFF NOTSTATIC x x x x x NOPARTICLES { model(":progs/quoth/longtrch.mdl"); }
// -------- KEYS --------
// targetname : toggle state (use trigger ent for exact state)
// light      : sets brightness, 300 is default
// skin       : 0=knave(def), 1=rust, 2=redbrick, 3=copper, 4=altar, 5=wizmet
// _color     : Light color - R/G/B (def='1 1 1')
// wait       : Fade distance multiplier (def=1)
// delay      : Attenuation 0=Linear, 1=inverse, 2=Squared, 3=NoFalloff, 4=Minlight, 5=Good Ambient
// mangle     : Spotlight direction
// angle      : Spotlight cone angle (def=40)
// _dirt      : Dirt map (override)
// _dirtscale : Dirt scale (override)
// _deviance  : Deviance
// _samples   : No. of Deviance lights (def=16)
// _surface   : Surface light texture name
// _surface_offset : Surface light offset (def=2)
// _softangle : Spotlight soft angle (def=0)
// _anglescale: Light angle scale (def=0.5)
// -------- SPAWNFLAGS --------
// LIGHTOFF   : Starts off and waits for trigger
// NOTSTATIC  : Not static entity (useful for switchable liFghts)
// NOPARTICLES: No particle or effects active
// -------- NOTES --------
// Long wall torch (from Quoth)
void() light_torch_long_walltorch = { // [ENTITY]
	if (self.mdl == "") self.mdl = "progs/quoth/longtrch.mdl";
	precache_model (self.mdl);
	self.classtype = CT_LIGHTSTATIC; // Default = static entity, check done in static function
	setup_quoth_nostatic();
	setup_vanilla_nostatic();
	setup_light_sound();
	setup_light_particle(PARTICLE_STYLE_FLAMES);
	light_customstyle_start(); // Check for any custom light styles
};

// QUAKED light_fixture1 (0 .5 0) (-10 -10 -20) (10 10 20) LIGHTOFF NOTSTATIC x x x x x x { model(":progs/ad171/misc_fixture1.mdl"); }
// -------- KEYS --------
// targetname : toggle state (use trigger ent for exact state)
// light      : sets brightness, 300 is default
// fixangle   : angle the model should be facing; set it to face away from the wall
// _color     : Light color - R/G/B (def='1 1 1')
// wait       : Fade distance multiplier (def=1)
// delay      : Attenuation 0=Linear, 1=inverse, 2=Squared, 3=NoFalloff, 4=Minlight, 5=Good Ambient
// mangle     : Spotlight direction
// angle      : Spotlight cone angle (def=40)

// _dirt      : Dirt map (override)
// _dirtscale : Dirt scale (override)
// _deviance  : Deviance
// _samples   : No. of Deviance lights (def=16)
// _surface   : Surface light texture name
// _surface_offset : Surface light offset (def=2)
// _softangle : Spotlight soft angle (def=0)
// _anglescale: Light angle scale (def=0.5)
// -------- SPAWNFLAGS --------
// LIGHTOFF   : Starts off and waits for trigger
// NOTSTATIC  : Not static entity (useful for switchable lights)
// -------- NOTES --------
// light Fixture (from Rubicon)
void() light_fixture1 = { // [ENTITY]
	self.mdl = "progs/ad171/misc_fixture1.mdl";
	precache_model (self.mdl);
	self.angles_y = self.fixangle;
	self.classtype = CT_LIGHTSTATIC; // Default = static entity, check done in static function
	setup_quoth_nostatic();
	setup_vanilla_nostatic();
	light_customstyle_start(); // Check for any custom light styles
};

void() light_candle_on = { // [FUNCTION]
	self.estate = ESTATE_ON;
	self.frame = 1 + (self.t_width-1)*2;
	if (self.style >= 0 && self.style < LIGHT_MAXLIGHTSTYLE) lightstyle(self.style, light_style_str[self.style]); // Light style defined? (use array to get the latest)
};

void() light_candle_off = { // [FUNCTION]
	self.estate = ESTATE_OFF;
	self.frame = (self.t_width-1)*2;
	lightstyle(self.style, "a");
};

void() light_candle_setup = { // [FUNCTION]
	setmodel(self, self.mdl); // Setup model and no world interaction
	setsize(self,VEC_ORIGIN,VEC_ORIGIN);
	if (engine == ENG_DPEXT && !(self.spawnflags & LIGHT_CANDLESHADOW)) self.effects = self.effects + EF_NOSHADOW; // If DP engine active remove candle model shadow
	if (self.angles_y <= 0) self.angles_y = rint(random()*359); // Setting the angle key in the editor to UP/DOWN = random rotation.
	if (self.spawnflags & ENT_SPNSTATIC) makestatic(self); // Check for static option (default is now static if no target)
	else {
		self.estate_on = light_candle_on; // Custom estate on/off functions
		self.estate_off = light_candle_off;
		light_customstyle_start(); // Check for any custom light styles
	}

	if (self.spawnflags & LIGHT_FLAMEOFF) light_candle_off(); // Setup light
};

// QUAKED light_candle (0 1 0) (-4 -4 -16) (4 4 16) LIGHTOFF FLAMEOFF x SHADOWS x STATIC x x { model(":progs/ad171/misc_candle1.mdl"); }
// -------- KEYS --------
// targetname : toggle state (use trigger ent for exact state)
// angle      : 0=random angle, 1-360=specific
// height     : size of candle 1=short, 2=medium, 3=regular, -1=random
// t_width    : width of candle 1=regular, 2=fat, 3=thin, -1=random
// lip        : Moves model down to ground plane (default = 16)
// light      : sets brightness, 300 is default
// _color     : Light color - R/G/B (def='1 1 1')
// wait       : Fade distance multiplier (def=1)
// delay      : Attenuation 0=Linear, 1=inverse, 2=Squared, 3=NoFalloff, 4=Minlight, 5=Good Ambient
// mangle     : Spotlight direction
// angle      : Spotlight cone angle (def=40)

// _dirt      : Dirt map (override)
// _dirtscale : Dirt scale (override)
// _deviance  : Deviance
// _samples   : No. of Deviance lights (def=16)
// _surface   : Surface light texture name
// _surface_offset : Surface light offset (def=2)
// _softangle : Spotlight soft angle (def=0)
// _anglescale: Light angle scale (def=0.5)
// -------- SPAWNFLAGS --------
// LIGHTOFF   : Starts off and waits for trigger
// FLAMEOFF   : The candle is displayed off (no flame)
// SHADOWS    : Turn on shadows in DP engine
// STATIC     : Turn entity into static upon spawn (frame 0)
// -------- NOTES --------
// Wide variety of Candles (from Rogue Software)
void() light_candle = { // [ENTITY]
	precache_model ("progs/ad171/misc_candle1.mdl"); // Cannot have randomly selected models for prechache.  Quickload will re-run all spawn functions and try to select a different candle model which is not precached.
	precache_model ("progs/ad171/misc_candle2.mdl");
	precache_model ("progs/ad171/misc_candle3.mdl");

	// Check for size 1=small, 2=medium, 3=regular (def), -1=random
	if (self.height < 0) self.height = 1 + rint(random()*2);
	if (self.height == 1) self.mdl = "progs/ad171/misc_candle1.mdl";
	else if (self.height == 2) self.mdl = "progs/ad171/misc_candle2.mdl";
	else self.mdl = "progs/ad171/misc_candle3.mdl";
	
	// Check for width 1=regular (def), 2=fat, 3=thin, -1=random.  The models are split up into three groups of off/on.
	if (self.t_width < 0) self.t_width = 1 + rint(random()*2);
	else if (self.t_width == 0 || self.t_width > 3) self.t_width = 1;

	self.modelindex = 0;
	self.model = "";				// hide bmodel surface
	self.frame = 1 + (self.t_width-1)*2;	// Def = on state
	self.movetype = MOVETYPE_NONE;			// Create baseline
	self.solid = SOLID_NOT;
	self.nextthink = 0;

	// The model should not be setup flush to floor because it is a light source and will look really odd, setup entity 16 units above floor and the "lip" key will move it back down again.
	if (!self.lip) self.lip = 16;
	self.origin_z = self.origin_z - self.lip;

	// Check for static entity option first
	if (self.spawnflags & ENT_SPNSTATIC) light_candle_setup();
	else {
		if (self.lighttarget != "" && !self.style) { // Check for spawn delay on model (signon buffer issues).  Code left so light_candles can be switched on/off.
			self.targetname = self.lighttarget;
			self.estate = ESTATE_OFF; // Use the entity state system for max compatibility
			self.use = entity_state_use;
			self.estate_on = light_candle_setup;
		} else {
			if (self.targetname != "" && self.spawnflags & 1) {
				self.estate = ESTATE_OFF; // Use the entity state system for max compatibility
				self.use = entity_state_use;
				self.estate_on = light_candle_setup;
			} else light_candle_setup();
		}
	}
};

void() light_lantern = { // [ENTITY]
	if (self.mdl == "") self.mdl = "progs/rogue/lantern.mdl"; // Allow for custom models
	precache_model (self.mdl);
	setmodel(self, self.mdl);
	setsize (self, VEC_ORIGIN, VEC_ORIGIN);
	self.classtype = CT_LIGHTSTATIC; // Default = static entity, check done in static function
	setup_quoth_nostatic();
	setup_vanilla_nostatic();
	light_customstyle_start(); // Check for any custom light styles
};

void() light_lantern2 = { // [ENTITY]
	if (self.mdl == "") self.mdl = "progs/ad171/misc_lantern.mdl"; // Allow for custom models
	precache_model(self.mdl);
	if (self.noise == "") self.noise = "ambience/fire1.wav";
	precache_sound(self.noise);
	if (!self.waitmin) self.waitmin = 2.165;
	setmodel(self, self.mdl);
	setsize (self, VEC_ORIGIN, VEC_ORIGIN);
	if (self.angles_y < 0 || (self.angles_y == 0 && !query_configflag(SVR_ITEMROTATE))) self.angles_y = rint(random()*359); // Setting the angle key in the editor to UP/DOWN = random rotation	
	self.classtype = CT_LIGHTSTATIC; // Default = static entity, check done in static function
	setup_quoth_nostatic();
	setup_vanilla_nostatic();
	setup_light_sound();
	setup_light_particle(PARTICLE_STYLE_FLAMET);
	light_customstyle_start(); // Check for any custom light styles
};

// QUAKED light_beacon (0 1 0) (-8 -8 -36) (8 8 8) BLINKING
// Floor-mounted flashing red beacon.  Default light value is 300.  Default style is 0.
// Flags: 1 : "Blinking" if you want the beacon to blink (Set style to "16" to match the skin animation.)
void() light_beacon = { // [ENTITY]
	if (self.mdl == "") self.mdl = "progs/rrp/beacon.mdl"; // Allow for custom models
	precache_model (self.mdl);
	if (self.spawnflags & 1) self.skin = 1;
	self.angles_y = self.fixangle;
	setmodel(self, self.mdl);
	setsize (self, VEC_ORIGIN, VEC_ORIGIN);
	self.classtype = CT_LIGHTSTATIC; // Default = static entity, check done in static function
	setup_quoth_nostatic();
	setup_vanilla_nostatic();
	light_customstyle_start(); // Check for any custom light styles
};

void() misc_marshlight_move = { // [FUNCTION]
	if (self.attack_finished < time) { remove(self); return; } // Check if ready to be removed?

	// Setup gradual turn off of marsh lights
	if (self.owner.estate & ESTATE_BLOCK) {
		if (self.attack_finished == LARGE_TIMER) {
			self.attack_finished = time + random() + random()*2;
		}
	}

	self.think = misc_marshlight_move; // Keep moving the marsh light around
	self.nextthink = time + self.owner.speed;
	if (self.lefty > 1) self.lefty = self.lefty - 0.15; // Slow down movement over time (0.1s)
	if (self.lefty < 1) self.lefty = 1;
	self.pos1 = (self.owner.origin - self.origin) * 0.2; // Adjust velocity based on starting origin
	self.pos2 = self.velocity * 0.8;
	self.velocity = self.pos2 + self.pos1;
	if ( (random() < 0.03) && (self.ltime < time) ) { // Check for velocity/time reset
		self.ltime = time + self.owner.waitmin;	// Reset timer
		self.lefty = self.owner.waitmin2;		// Reset velocity
	}

	self.velocity = normalize(self.velocity); // Adjust velocity based on movement modifier
	self.velocity = self.velocity * (20 + (random()*8) * self.lefty);
	if (self.owner.pos1_z == -1) { // Update animation loops
		self.height = self.height + self.lip;
		if (self.lip == 1 && self.height > self.owner.pos1_y) self.height = self.owner.pos1_x;
		else if (self.lip == -1 && self.height < self.owner.pos1_x) self.height = self.owner.pos1_y;
		
		if (self.height < self.owner.pos1_x || self.height > self.owner.pos1_y) self.height = self.owner.pos1_x + (rint( random() * fabs(self.owner.pos1_y - self.owner.pos1_x) ) ); // Check for out of bounds, ERROR = Pick a random frame to snap too (base x + random)
		self.frame = self.height; // Update frame
	}
};

// Spawn a marsh light
void() misc_marshlight_spawn = { // [FUNCTION]
	if (self.estate & ESTATE_BLOCK) return; // Block functionality if state wrong

	self.movetarget = spawn();
	self.movetarget.classname = self.classname;
	self.movetarget.classtype = CT_BUBBLE;
	self.movetarget.classgroup = CG_TEMPENT;
	self.movetarget.owner = self;
	self.movetarget.attack_finished = LARGE_TIMER;

	if (self.bubble_count > 1) { // Created first light?
		if (random() < 0.2) setmodel(self.movetarget, self.headmdl); // Lower chance of large models
		else setmodel(self.movetarget, self.mdl);
	} else setmodel(self.movetarget, self.headmdl); // first light = large model/sprite
	
	self.movetarget.movetype = MOVETYPE_NOCLIP; // No world interaction
	self.movetarget.solid = SOLID_NOT;

	// Use color key if no custom models
	if (self.lefty) {
		self.movetarget.frame = self.color_x;
		self.movetarget.skin = 0;
	} else {
		self.movetarget.frame = self.movetarget.skin = 0; // Reset frame (pos1) and skin (pos2)
		if (self.pos1_x != self.pos1_y) { // FRAME (pos1).  Has a frame range been defined?
			self.movetarget.height = self.pos1_x + (rint(random() * fabs(self.pos1_y - self.pos1_x))); // Random starting position within range
			self.movetarget.frame = self.movetarget.height;
			if (self.pos1_z == -1 && self.lip == -2) { // Randomize animation loop direction
				if (random() < 0.5) self.movetarget.lip = -1;
				else self.movetarget.lip = 1;
			} else self.movetarget.lip = self.lip; // Fixed Animation loop direction
		} else {
			if (self.pos1_z >= 0) self.movetarget.frame = self.pos1_z; // if no range, check for exact value
		}

		if (self.pos2_x != self.pos2_y) self.movetarget.skin = self.pos2_x + (rint(random() * fabs(self.pos2_y - self.pos2_x))); // SKIN (po2).  Has a skin range been defined?  Randomly pick a new skin for each spawn
		else {
			if (self.pos2_z > 0) self.movetarget.skin = self.pos2_z; // if no range, check for exact value
		}
	}

	self.dest2_x = random() * self.finalangle_x;
	self.dest2_y = random() * self.finalangle_y;
	self.dest2_z = random() * self.finalangle_z;
	self.movetarget.avelocity = self.pos3 + self.dest2; // Setup random rotation velocity (base + modifier)
	self.movetarget.angles = vecrand(180, 180, FALSE); // Random angles starting position
	setsize(self.movetarget, VEC_ORIGIN, VEC_ORIGIN);
	self.movetarget.origin = self.origin + vecrand(0, self.distance, TRUE);
	setorigin(self.movetarget, self.movetarget.origin); // Starting origin +/- (def=20)
	self.movetarget.velocity = vecrand(0, self.distance, TRUE); // Setup starting velocity +/- (def=20)
	self.movetarget.nextthink = time + 0.1; // Keep moving around (randomly)
	self.movetarget.think = misc_marshlight_move;
	self.bubble_count =  self.bubble_count + 1; // Limited amount of marsh lights
	if (self.bubble_count < self.count) {
		self.think = misc_marshlight_spawn;
		self.nextthink = time + 0.1;
	}
};

void() misc_marshlight_on = { // [FUNCTION]
	if (self.estate == ESTATE_ON) return; // Block functionality if state wrong

	self.estate = ESTATE_ON;
	self.bubble_count = 0;
	self.nextthink = time + 0.5 + random();
	self.think = misc_marshlight_spawn;
};

void() misc_marshlight_off = { // [FUNCTION]
	self.estate = ESTATE_OFF;
	self.bubble_count = 0;
};

// QUAKED misc_marshlight (.5 .5 .75) (-8 -8 -8) (8 8 8) x x x x x x STARTOFF x
// -------- KEYS --------
// targetname : toggle state (use trigger ent for exact state)
// count      : Maximum amount of active marsh light entities (def=5)
// color      : 0=White, 1=Cyan, 2=Blue, 3=Green, 4=Orange, 5=Red, 6=Purple
// mdl        : Name of Small sprite (def='progs/s_marsh_small.spr')
// headmdl    : Name of Medium sprite (def='progs/s_marsh_med.spr')
// waitmin    : Reset movement timer (def=6s)
// waitmin2   : Reset Velocity movement (def=4.5s)
// distance   : Starting distance from center (def=20)
// speed      : Override for frame animation speed (def=0.1s)
// lip        : Frame animation direction -2=random, -1=back, 1=forward(def)
// pos1       : used for selection of frame(s) has several setups
             // X=0, Y=0, Z=exact frame number
             // X->Y, Z=0 Randomly pick a frame from the X,Y range
             // X->Y, Z=-1 Animate between the X,Y range
// pos2       : used for the selection of skin(s) has several setups
             // X=0, Y=0, Z=exact skin number
             // X->Y, Z=0 Randomly pick a skin from the X,Y range
// pos3       : Base rotation avelocity (def=0 0 0)
// finalangle : Random rotation avelocity (def=0 0 0)
// -------- SPAWNFLAGS --------
// STARTOFF : Starts off and waits for trigger
// -------- NOTES --------
// Marsh lights (Quoth item)
void() misc_marshlight = { // [ENTITY]
	if (self.mdl == "" && self.headmdl == "") self.lefty = TRUE; // Check for no custom models first
	if (self.mdl == "") self.mdl = SMARSH_SMALL; // Allow for custom sprites
	if (self.headmdl == "") self.headmdl = SMARSH_MED;
	precache_model (self.mdl); // Default cache - Quoth sprites
	precache_model (self.headmdl);
	self.classtype = CT_MISCMARSH;
	self.classgroup = CG_MISCENT;
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_NONE;
	setsize(self, VEC_ORIGIN, VEC_ORIGIN);
	self.color_x = rint(self.color_x); // Quoth uses this key for sprite skin colour selection.  Bad entity key to use, screws with coloured lighting
	if (self.color_x < 0 || self.color_x > 6) self.color_x = 0;
	self.bubble_count = 0;						// Active Marsh lights
	if (self.count <= 0) self.count = 5; 		// Maximum Marsh lights
	if (self.waitmin < 1) self.waitmin = 6;		// Reset timer
	if (self.waitmin2 < 1) self.waitmin2 = 4.5;	// Velocity Movement
	if (self.distance < 1) self.distance = 20;	// Starting distance
	if (self.speed <= 0) self.speed = 0.1;		// Animation speed
	
	// Check for animation diection errors
	if (self.lip <= -2) self.lip = -2;			// Randomly pick
	else if (self.lip >= 0) self.lip = 1;		// Def = forward (1)

	self.pos1 = CheckRangeVector(self.pos1); // Make sure frame/skin parameters are integers/positive
	self.pos2 = CheckRangeVector(self.pos2);
		
	// Has a frame range been defined?
	if (self.pos1_x != self.pos1_y) {
		// Make sure the range is the right way around.  X has to be the lowest number of the two (X/Y)
		if (self.pos1_x > self.pos1_y) {
			self.frame_box = self.pos1_x;
			self.pos1_x = self.pos1_y;
			self.pos1_y = self.frame_box;
		}
		
		if (self.pos1_z <= -1) self.pos1_z = -1; // Check for any errors
		else self.pos1_z = 0;
	}

	if (self.targetname != "") self.use = entity_state_use; // Setup Entity State functionality
	self.estate_on = misc_marshlight_on;
	self.estate_off = misc_marshlight_off;
	if (self.spawnflags & ENT_STARTOFF) self.estate_off();
	else self.estate_on();
};

void() light_marsh = { misc_marshlight(); }; // [ENTITY], Re-direct all Quoth light_marsh requests to misc_marshlight!
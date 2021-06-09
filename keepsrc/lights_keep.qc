void () light_lantern = {
	// Allow for custom models
	if (self.mdl == "") self.mdl = "progs/rogue/lantern.mdl";
	precache_model (self.mdl);
	self.angles_y = self.fixangle;

	setmodel (self, self.mdl);
	setsize (self, VEC_ORIGIN, VEC_ORIGIN);

	// Default = static entity, check done in static function
	self.classtype = CT_LIGHTSTATIC;
	setup_quoth_nostatic();
	setup_vanilla_nostatic();
	// Check for any custom light styles
	light_customstyle_start();
};

void () light_lantern2 = {
	// Allow for custom models
	if (self.mdl == "") self.mdl = "progs/ad171/misc_lantern.mdl";
	precache_model(self.mdl);
	if (self.noise == "") self.noise = "ambience/fire1.wav";
	precache_sound (self.noise);
	if (!self.waitmin) self.waitmin = 2.165;

	setmodel (self, self.mdl);
	setsize (self, VEC_ORIGIN, VEC_ORIGIN);
	// Setting the angle key in the editor to UP/DOWN = random rotation	
	if (self.angles_y < 0 || (self.angles_y == 0 && !query_configflag(SVR_ITEMROTATE)) ) 
		self.angles_y = rint(random()*359);

	// Default = static entity, check done in static function
	self.classtype = CT_LIGHTSTATIC;

	setup_quoth_nostatic();
	setup_vanilla_nostatic();
	setup_light_sound();
	setup_light_particle(PARTICLE_STYLE_FLAMET);

	// Check for any custom light styles
	light_customstyle_start();
};


//===============================================================================
//light_beacon
//===============================================================================
/*QUAKED light_beacon (0 1 0) (-8 -8 -36) (8 8 8) BLINKING
floor-mounted flashing red beacon
Default light value is 300
Default style is 0
Flags:
1 : "Blinking" if you want the beacon to blink (Set style to "16" to match the skin animation.) */

void() light_beacon = {
	if (self.spawnflags & 1) self.skin = 1;

	// Allow for custom models
	if (self.mdl == "") self.mdl = "progs/rrp/beacon.mdl";
	precache_model (self.mdl);
	self.angles_y = self.fixangle;

	setmodel (self, self.mdl);
	setsize (self, VEC_ORIGIN, VEC_ORIGIN);

	// Default = static entity, check done in static function
	self.classtype = CT_LIGHTSTATIC;
	setup_quoth_nostatic();
	setup_vanilla_nostatic();
	// Check for any custom light styles
	light_customstyle_start();
};

//======================================================================
/*QUAKED misc_marshlight (.5 .5 .75) (-8 -8 -8) (8 8 8) x x x x x x STARTOFF x
Marsh lights (Quoth item)
-------- KEYS --------
targetname : toggle state (use trigger ent for exact state)
count      : Maximum amount of active marsh light entities (def=5)
color      : 0=White, 1=Cyan, 2=Blue, 3=Green, 4=Orange, 5=Red, 6=Purple
mdl        : Name of Small sprite (def='progs/s_marsh_small.spr')
headmdl    : Name of Medium sprite (def='progs/s_marsh_med.spr')
waitmin    : Reset movement timer (def=6s)
waitmin2   : Reset Velocity movement (def=4.5s)
distance   : Starting distance from center (def=20)
speed      : Override for frame animation speed (def=0.1s)
lip        : Frame animation direction -2=random, -1=back, 1=forward(def)
pos1       : used for selection of frame(s) has several setups
             X=0, Y=0, Z=exact frame number
             X->Y, Z=0 Randomly pick a frame from the X,Y range
             X->Y, Z=-1 Animate between the X,Y range
pos2       : used for the selection of skin(s) has several setups
             X=0, Y=0, Z=exact skin number
             X->Y, Z=0 Randomly pick a skin from the X,Y range
pos3       : Base rotation avelocity (def=0 0 0)
finalangle : Random rotation avelocity (def=0 0 0)
-------- SPAWNFLAGS --------
STARTOFF : Starts off and waits for trigger
-------- NOTES --------
Marsh lights

======================================================================*/
void() misc_marshlight_move =
{
	// Check if ready to be removed?
	if (self.attack_finished < time) { remove(self); return; }
	// Setup gradual turn off of marsh lights
	if (self.owner.estate & ESTATE_BLOCK) {
		if (self.attack_finished == LARGE_TIMER) {
			self.attack_finished = time + random() + random()*2;
		}
	}
	
	// Keep moving the marsh light around
	self.think = misc_marshlight_move;
	self.nextthink = time + self.owner.speed;
	
	// Slow down movement over time (0.1s)
	if (self.lefty > 1) self.lefty = self.lefty - 0.15;
	if (self.lefty < 1) self.lefty = 1;

	// Adjust velocity based on starting origin
	self.pos1 = (self.owner.origin - self.origin) * 0.2;
	self.pos2 = self.velocity * 0.8;
	self.velocity = self.pos2 + self.pos1;
	
	// Check for velocity/time reset
	if ( (random() < 0.03) && (self.ltime < time) ) {
		self.ltime = time + self.owner.waitmin;	// Reset timer
		self.lefty = self.owner.waitmin2;		// Reset velocity
	}
	
	// Adjust velocity based on movement modifier
	self.velocity = normalize(self.velocity);
	self.velocity = self.velocity * (20 + (random()*8) * self.lefty);
	
	// Update animation loops
	if (self.owner.pos1_z == -1) {
		self.height = self.height + self.lip;
		if (self.lip == 1 && self.height > self.owner.pos1_y) 
			self.height = self.owner.pos1_x;
		else if (self.lip == -1 && self.height < self.owner.pos1_x) 
			self.height = self.owner.pos1_y;
		
		// Check for out of bounds
		if (self.height < self.owner.pos1_x || self.height > self.owner.pos1_y)
			// ERROR = Pick a random frame to snap too (base x + random)
			self.height = self.owner.pos1_x + (rint( random() * fabs(self.owner.pos1_y - self.owner.pos1_x) ) );
		
		// Update frame
		self.frame = self.height;
	}
};

//----------------------------------------------------------------------
void() misc_marshlight_spawn =
{
	// Block functionality if state wrong
	if (self.estate & ESTATE_BLOCK) return;
	
	// Spawn marsh light
	self.movetarget = spawn();
	self.movetarget.classname = self.classname;
	self.movetarget.classtype = CT_BUBBLE;
	self.movetarget.classgroup = CG_TEMPENT;
	self.movetarget.owner = self;
	self.movetarget.attack_finished = LARGE_TIMER;

	// Created first light?
	if (self.bubble_count > 1) {
		// Lower chance of large models
		if (random() < 0.2) setmodel(self.movetarget, self.headmdl);
		else setmodel(self.movetarget, self.mdl);
	}
	// first light = large model/sprite
	else setmodel(self.movetarget, self.headmdl);
	
	// No world interaction
	self.movetarget.movetype = MOVETYPE_NOCLIP;
	self.movetarget.solid = SOLID_NOT;

	// Use color key if no custom models
	if (self.lefty) {
		self.movetarget.frame = self.color_x;
		self.movetarget.skin = 0;
	}
	else {
		// Reset frame (pos1) and skin (pos2)
		self.movetarget.frame = self.movetarget.skin = 0;
		
		// ---------------------------------------------------------------
		// FRAME (pos1)
		// ---------------------------------------------------------------
		// Has a frame range been defined?
		if (self.pos1_x != self.pos1_y) {
			// Random starting position within range
			self.movetarget.height = self.pos1_x + (rint( random() * fabs(self.pos1_y - self.pos1_x) ) );
			self.movetarget.frame = self.movetarget.height;
			
			// Randomize animation loop direction
			if (self.pos1_z == -1 && self.lip == -2) {
				if (random() < 0.5) self.movetarget.lip = -1;
				else self.movetarget.lip = 1;
			}
			// Fixed Animation loop direction
			else self.movetarget.lip = self.lip;
		}
		else {
			// if no range, check for exact value
			if (self.pos1_z >= 0) self.movetarget.frame = self.pos1_z;
		}
		
		// ---------------------------------------------------------------
		// SKIN (po2)
		// ---------------------------------------------------------------
		// Has a skin range been defined?
		if (self.pos2_x != self.pos2_y) {
			// Randomly pick a new skin for each spawn
			self.movetarget.skin = self.pos2_x + (rint( random() * fabs(self.pos2_y - self.pos2_x) ) );
		}
		else {
			// if no range, check for exact value
			if (self.pos2_z > 0) self.movetarget.skin = self.pos2_z;
		}
	}
	
	// Setup random rotation velocity (base + modifier)
	self.dest2_x = random() * self.finalangle_x;
	self.dest2_y = random() * self.finalangle_y;
	self.dest2_z = random() * self.finalangle_z;
	self.movetarget.avelocity = self.pos3 + self.dest2;
	// Random angles starting position
	self.movetarget.angles = vecrand(180, 180, FALSE);
	
	// Starting origin +/- (def=20)
	setsize (self.movetarget, VEC_ORIGIN, VEC_ORIGIN);
	self.movetarget.origin = self.origin + vecrand(0, self.distance, TRUE);
	setorigin(self.movetarget, self.movetarget.origin);
	// Setup starting velocity +/- (def=20)
	self.movetarget.velocity = vecrand(0, self.distance, TRUE);
	
	// Keep moving around (randomly)
	self.movetarget.nextthink = time + 0.1;
	self.movetarget.think = misc_marshlight_move;

	// Limited amount of marsh lights
	self.bubble_count =  self.bubble_count + 1;
	if (self.bubble_count < self.count) {
		self.think = misc_marshlight_spawn;
		self.nextthink = time + 0.1;
	}
};

//----------------------------------------------------------------------
void() misc_marshlight_on =
{
	// Block functionality if state wrong
	if (self.estate == ESTATE_ON) return;

	self.estate = ESTATE_ON;
	self.bubble_count = 0;
	self.nextthink = time + 0.5 + random();
	self.think = misc_marshlight_spawn;
};

//----------------------------------------------------------------------
void() misc_marshlight_off =
{
	self.estate = ESTATE_OFF;
	self.bubble_count = 0;
};

//----------------------------------------------------------------------
void() misc_marshlight =
{
	// Check for no custom models first
	if (self.mdl == "" && self.headmdl == "") self.lefty = TRUE;
	// Allow for custom sprites
	if (self.mdl == "") self.mdl = SMARSH_SMALL;
	if (self.headmdl == "") self.headmdl = SMARSH_MED;

	// Default cache - Quoth sprites
	precache_model (self.mdl);
	precache_model (self.headmdl);
	
	self.classtype = CT_MISCMARSH;
	self.classgroup = CG_MISCENT;
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_NONE;
	setsize(self, VEC_ORIGIN, VEC_ORIGIN);

	// Quoth uses this key for sprite skin colour selection
	// Bad entity key to use, screws with coloured lighting
	self.color_x = rint(self.color_x);
	if (self.color_x < 0 || self.color_x > 6) self.color_x = 0;

	// Setup defaults
	self.bubble_count = 0;						// Active Marsh lights
	if (self.count <= 0) self.count = 5; 		// Maximum Marsh lights
	if (self.waitmin < 1) self.waitmin = 6;		// Reset timer
	if (self.waitmin2 < 1) self.waitmin2 = 4.5;	// Velocity Movement
	if (self.distance < 1) self.distance = 20;	// Starting distance
	if (self.speed <= 0) self.speed = 0.1;		// Animation speed
	
	// Check for animation diection errors
	if (self.lip <= -2) self.lip = -2;			// Randomly pick
	else if (self.lip >= 0) self.lip = 1;		// Def = forward (1)
	
	// Make sure frame/skin parameters are integers/positive
	self.pos1 = CheckRangeVector(self.pos1);
	self.pos2 = CheckRangeVector(self.pos2);
		
	// Has a frame range been defined?
	if (self.pos1_x != self.pos1_y) {
		// Make sure the range is the right way around
		// X has to be the lowest number of the two (X/Y)
		if (self.pos1_x > self.pos1_y) {
			self.frame_box = self.pos1_x;
			self.pos1_x = self.pos1_y;
			self.pos1_y = self.frame_box;
		}
		// Check for any errors
		if (self.pos1_z <= -1) self.pos1_z = -1;
		else self.pos1_z = 0;
	}
	
	// Setup Entity State functionality
	if (self.targetname != "") self.use = entity_state_use;
	self.estate_on = misc_marshlight_on;
	self.estate_off = misc_marshlight_off;
	if (self.spawnflags & ENT_STARTOFF) self.estate_off();
	else self.estate_on();
};

//----------------------------------------------------------------------
// Re-direct all Quoth light_marsh requests to misc_marshlight!
void() light_marsh = { misc_marshlight(); };
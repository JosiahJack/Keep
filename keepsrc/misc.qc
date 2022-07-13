//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
//
// Attributions: Arcane Dimensions (AD), Rubicon, and Qmaster
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
// Entity count: 13
// Function count: 53
//
// Implements: Miscellaneous Decorative Effects Emitters
//
// Description:
// Various entities for emitting effects such as sparks, smoke, sprites, etc.
//=============================================================================

float MISC_STARTOFF = 1;		// Start OFF (use DELAY instead!)
float MISC_FBALLSLIME = 32;		// Slime green fire ball
float MISC_DRIPSILENT = 2;		// misc_drip has no sound on splash
float MISC_DRIPBLOOD = 16;		// blood red drips
float MISC_DRIPSLIME = 32;		// slime green drips
float MISC_SMOKENODPMDL = 2;	// Do not draw smoke model
float MISC_SMOKENODPFX = 4;		// Do not produce any DP smoke effects
float MISC_SPARKBLUE = 2;		// misc_spark produces Blue sparks
float MISC_SPARKPALE = 4;		// misc_spark produces Pale Yellow sparks
float MISC_SPARKRED = 8;		// misc_spark produces Red sparks
float MISC_COLLISION = 2;		// misc_model has collision enabled
float MISC_MOVEMENT = 4;		// misc_model can be moved around
float MISC_SHAKEVIEWONLY = 2;	// No velocity movement

void() misc_model;
void() monster_bbox;
void() misc_lavaball_fly;
void() misc_bubble_bob;
void() misc_drip_spawn;
void() misc_drip_touch;
void() misc_spark_spawn;

void() misc_lavaball_reset = { // [FUNCTION]
	self.touch = SUB_Null;
	self.flags = 0;
	self.modelindex = 0;			// Make sure no model
	self.model = "";
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_NONE;
	setsize (self, VEC_ORIGIN, VEC_ORIGIN);
	self.velocity = self.avelocity = '0 0 0';
	self.nextthink = time + self.delay + (random() * self.wait);
	self.think = misc_lavaball_fly;
};

void() misc_lavaball_touch = { // [FUNCTION]
	local float touchdmg; // Put in a local so that lavaball can touch a few things before it dies and still preserve original self.dmg value.

	touchdmg = self.dmg;
	self.touch = SUB_Null;
	if (other.takedamage) { // Check for lava proections?
		if (self.spawnflags & MISC_FBALLSLIME) {
			if (other.resist_acid > 0) touchdmg = self.dmg * (1-other.resist_acid);
			if (other.flags & FL_CLIENT && other.items & IT_SUIT) sound(other,CHAN_ITEM,SOUND_ARTSUIT3, 0.5,ATTN_NORM); // Play envirosuit protection sound
			else T_Damage (other, self, self, touchdmg, DAMARMOR); // Default = pain!
		} else {
			if (other.resist_fire > 0) touchdmg = self.dmg * (1-other.resist_fire); // Default = pain!
			if (other.flags & FL_CLIENT && ((other.moditems & IT_ARTLAVASHIELD) || other.resist_fire >= 1) || other.therm_finished > time) sound(other,CHAN_ITEM,SOUND_ARTLSHIELD3, 0.5,ATTN_NORM); // Play lava shield protection sound
			else T_Damage (other, self, self, touchdmg, DAMARMOR); // Default = pain!
		}
	}
	misc_lavaball_reset();
};

void() misc_lavaball_fly = { // [FUNCTION]
	if (self.estate & ESTATE_BLOCK) return;
	
	setmodel(self, self.mdl);
	setorigin(self, self.oldorigin);
	self.flags = 0; // Remove all fly/onground flags
	self.solid = SOLID_TRIGGER;
	self.movetype = MOVETYPE_TOSS;
	setsize (self, VEC_ORIGIN, VEC_ORIGIN);

	// Check for any target entity tracking setup
	if (self.target == "") { // No need to track other targets, used for direction only
		// default misc_fireball movement
		self.velocity_x = (random() * 100) - 50;
		self.velocity_y = (random() * 100) - 50;
		self.velocity_z = self.speed + (random() * 200);
	} else {
		TargetMovedir(self, FALSE); // Setup tracking vector (using movedir) = traps.qc
		self.velocity = self.movedir * (self.speed + (random() * 200));
		self.velocity = self.velocity + (v_right * ((random() * 100) - 50)); // Add original XY (right) vector offset
	}

	self.nextthink = time + self.wait;	// Random time start
	self.think = misc_lavaball_reset;
	self.touch = misc_lavaball_touch;
};

void() misc_lavaball_on = { // [FUNCTION]
	self.estate = ESTATE_ON;
	self.nextthink = time + self.delay + (random() * self.wait);
	self.think = misc_lavaball_fly;
};

// QUAKED misc_fireball (0 .5 .8) (-8 -8 -8) (8 8 8) x x x x x SLIME STARTOFF x
// Lava Balls, with damage on impact
// -------- KEYS --------
// targetname : toggle state (use trigger ent for exact state)
// speed : vertical speed (default 1000)
// dmg   : impact damage (default 5)
// delay : base time between spawning fireballs (default 3)
// wait  : random time default 5 (= time + self.delay + (random() x self.wait) ) 
// -------- SPAWNFLAGS --------
// SLIME  : Green slime version (smoke trail)
// STARTOFF : Always Starts off and waits for trigger
// -------- NOTES --------
// Lava Balls, with damage on impact
void() misc_fireball = { // [ENTITY]
	if (self.spawnflags & MISC_FBALLSLIME) self.mdl = MODEL_PROJ_SLIME;
	else self.mdl = MODEL_PROJ_LAVA;
	precache_model (self.mdl);
	self.classtype = CT_FIREBALL;
	self.classgroup = CG_MISCENT;
	self.oldorigin = self.origin;
	if (self.speed <= 0) self.speed = 1000;
	if (self.dmg <= 0) {
		if (self.spawnflags & MISC_FBALLSLIME)
			self.dmg = 10; //half damage for slime balls
		else
			self.dmg = 20;
	}
	if (self.wait <= 0) self.wait = 5;
	if (self.delay <= 0) self.delay = 3;
	
	// Check for simple angle setup or target system
	if (self.target == "") {
		// Default angle is UP
		if (self.angles_y == 0) self.angles = '0 -1 0';
		SetMovedir();
	}
	else self.angletarget = self.target;
	// Setup Entity State functionality
	if (self.targetname != "") self.use = entity_state_use;
	self.estate_on = misc_lavaball_on;
	if (self.spawnflags & (MISC_STARTOFF | ENT_STARTOFF)) entity_state_off();
	else entity_state_on();
};

void() misc_slimeball = { // [ENTITY]
	self.spawnflags = self.spawnflags | MISC_FBALLSLIME;
	self.classname = "misc_fireball";
	misc_fireball();
};

void() misc_gibfountain_fly = { // [FUNCTION]
	if (self.estate & ESTATE_BLOCK) return;

	self.lefty = rint(self.count + random()*self.cnt);
	while (self.lefty > 0) { // Loop through gibs, better chance of different types	
		// Check for custom gib models
		if (self.pos1_z) {
			self.lip = random();
			if (self.lip < 0.3) self.aflag = 13;
			else if (self.lip < 0.6) self.aflag = 12;
			else self.aflag = 11;
		} else if (self.pos1_y) {
			if (random() < 0.5) self.aflag = 12;
			else self.aflag = 11;
		} else if (self.pos1_x) self.aflag = 11;
		else {
			if (self.style == 0) self.aflag = rint(1 + random()*4);
			else self.aflag = self.style;
		}

		ThrowGib(self.aflag, 1);
		self.lefty = self.lefty -1;
	}

	if (self.noise1 != "" && random() < 0.5) sound(self,CHAN_VOICE, self.noise1,1,ATTN_NORM); // Only need to play throw/fire sound once per timer cycle
	else sound(self,CHAN_VOICE, self.noise,1,ATTN_NORM);

	self.nextthink = time + self.delay + (random() * self.wait);
	self.think = misc_gibfountain_fly;
};

void() misc_gibfountain_on = { // [FUNCTION]
	self.estate = ESTATE_ON;
	self.spawnflags = self.spawnflags - (self.spawnflags & ENT_STARTOFF); // Spawn delay is no longer required, remove it
	if (self.lip) { // Display spawn direction with angle model
		self.lip = FALSE; // Once only
		if (self.target != "") TargetMovedir(self,FALSE); // Movement target only, no need to check other targets
		spawn_marker(self.origin,vectoangles(self.movedir),1,0);
	}

	misc_gibfountain_fly(); // Start spewing (no delay so it can be triggered properly)
};

// QUAKED misc_gibfountain (0 .5 .8) (-8 -8 -8) (8 8 8) x x x x x x STARTOFF x
// -------- KEYS --------
// targetname : toggle state (use trigger ent for exact state)
// gibtype    : 0=Blood (def) 1=Stone 10=Poison
// style      : 0=Random (def) 1=Arm/Leg 2=Torso 3=Slice 4=Small 5=Large
// count      : Quantity of gibs to throw at once (def=1)
// cnt        : Extra random quanity of gibs to throw (def=0)
// gib1mdl    : Custom Gib 1 model
// gib2mdl    : Custom Gib 2 model
// gib3mdl    : Custom Gib 3 model
// gib1skin   : Custom Gib 1 skin number (def=0)
// gib2skin   : Custom Gib 2 skin number (def=0)
// gib3skin   : Custom Gib 3 skin number (def=0)
// gib1frame  : Custom Gib 1 range to randomly pick from
// gib2frame  : Custom Gib 2 range to randomly pick from
// gib3frame  : Custom Gib 3 range to randomly pick from
// gib1sound  : Custom Gib 1 Impact sound(0=Light flesh, 1=Heavy flesh, 5=Acid,
// gib2sound  : Custom Gib 2 Impact sound 10-12=Pebbles, 20=Wood, 40=Metal1, 
// gib3sound  : Custom Gib 3 Impact sound 41=Metal2, 42=Chain, 50=Custom)
// gib1soundx : Custom Gib 1 Impact WAV file (must set gib1sound=50)
// gib1soundx : Custom Gib 2 Impact WAV file (must set gib2sound=50)
// gib1soundx : Custom Gib 3 Impact WAV file (must set gib3sound=50)
// sounds     : 1=Zerstorer(def) 4=Silent 5=Custom
// noise      : Custom sound 1 for launching gibs
// noise1     : Custom sound 2 for launching gibs (random selection)
// target     : targeting entity used for custom direction
// angle      : determines the firing direction (def=-1 UP)
// gibmins    : Bounding box override for gib model (def='0 0 0')
// gibmaxs    : Bounding box override for gib model (def='0 0 0')
// speed      : forward speed (def=600)
// gibvel     : Random Velocity X=Forward, Y=L/R, Z=U/D (def=200 100 0)
// gib1dmg    : Amount of damage (>1) to inflict on player when touching gibs
// gib1exp    : Sprite Explosion (1=small 2=medium 3=large 10+=plasma 20+=poison 30+=electric 40+=smoke)
// gibpartstyle  : Particle Colour (1=Yellow 2=Green 4=Red 8=Blue 16=Purple 32=Fire 64=White)
// gibpartoffset : Offset to particle origin (center of effect)
// gibpartbase   : Particle quantity, Base (minimum) value
// gibpartrnd    : Particle quantity, Random amount to add
// gibpartlife   : Time (seconds) which particles are active
// gibpartchance : % chance of particle effect being active while on floor
// gibAnimfinal  : Final animation frame (>0) to enable sequence
// gibAnimstart  : Starting animation frame for sequence
// gibAnimTimer  : Time (seconds) spent in final impact animation
// delay      : base time between spawning gibs (default 3)
// wait       : random time default 5 (= time + self.delay + (random() x self.wait) ) 
// -------- SPAWNFLAGS --------
// STARTOFF : Always Starts off and waits for trigger
// -------- NOTES --------
// Spew Gibs in target direction (Originally from Zerstorer MOD)
void() misc_gibfountain = { // [ENTITY]
	if (self.gibtype == GIBTYPE_STONE) { // Setup/load extra gib types (Check for previous precache)
		if (!gibstone) precache_stonegibs(); } // Only bother to precache if NOT done already
	else if (self.gibtype == GIBTYPE_POISON) {
		if (!gibpoison) precache_poisongibs(); }
	else self.gibtype = GIBTYPE_BLOOD; // Default=Blood

	// Check for custom gib model/skin/frame/sound assets
	self.pos1 = '0 0 0'; // Reset
	if (self.gib1mdl != "") {
		precache_model(self.gib1mdl);
		if (self.gib1skin < 1) self.gib1skin = 0;
		if (self.gib1frame < 1) self.gib1frame = 0;
		if (!(check_gibsound(self.gib1sound))) self.gib1sound = 0; // Verify custom gib impact sound is valid
		self.pos1_x = TRUE;
		if (self.gib2mdl != "") { // Custom Model 2 - Model 1 must exist first
			precache_model(self.gib2mdl);
			if (self.gib2skin < 1) self.gib2skin = 0;
			if (self.gib2frame < 1) self.gib2frame = 0;
			if (!(check_gibsound(self.gib2sound))) self.gib2sound = 0; // Verify custom gib impact sound is valid
			self.pos1_y = TRUE;
			if (self.gib3mdl != "") { // Custom Model 3 - Model 1/2 must exist first
				precache_model(self.gib3mdl);
				if (self.gib3skin < 1) self.gib3skin = 0;
				if (self.gib3frame < 1) self.gib3frame = 0;
				if (!(check_gibsound(self.gib3sound))) self.gib3sound = 0; // Verify custom gib impact sound is valid
				self.pos1_z = TRUE;
			}
		}
	}

	if (self.sounds < 1) self.sounds = 1; // Setup default sounds (Zerstorer)
	if (self.sounds == 1) { // Original Zerstorer toilet sounds
		self.noise = "zerstorer/gibfnt/gf_sprt1.wav";
		self.noise1 = "zerstorer/gibfnt/gf_sprt2.wav";
	} else if (self.sounds == 4) self.noise = self.noise1 = SOUND_EMPTY;  // Empty sound files
	
	if (self.noise != "") precache_sound(self.noise); // Check if any custom sounds have been defined
	if (self.noise1 != "") precache_sound(self.noise1);
	if (self.gib1soundx != "") precache_sound(self.gib1soundx);
	if (self.gib2soundx != "") precache_sound(self.gib2soundx);
	if (self.gib3soundx != "") precache_sound(self.gib3soundx);
	self.classtype = CT_MISCGIBF; // Entity defaults
	self.classgroup = CG_MISCENT;
	self.max_health = MON_GIBTARGET; // Special target system gibs
	if (self.wait <= 0) self.wait = 5;
	if (self.delay <= 0) self.delay = 3;
	if (self.waitmin <= 0) self.waitmin = 0.5;
	if (self.style < 1 || self.style > 9) self.style = 0;
	if (self.count < 1) self.count = 1;
	if (self.cnt < 1) self.cnt = 0;
	if (self.speed <= 0) self.speed = 600; // Default velocity (like misc_fireball)
	if (CheckZeroVector(self.gibvel)) self.gibvel = '200 100 0'; // Extra randomness to speed/velocity of gib (forward/right/up)
	if (CheckZeroVector(self.angles)) { // Direction system priority = ANGLES > TARGET > ANGLETARGET.  Check for empty angles setup?
		self.angles = '0 -1 0'; // No angles defined, create default direction.  Target/Angletarget are checked when gib is thrown/spawned
		if (self.target == "") self.target = self.angletarget; // priority = TARGET > ANGLETARGET.  Target has to be defined for gib to be thrown properly.
		else self.angletarget = self.target;
	}
	
	SetMovedir(); // Find movedir vector
	self.lefty = self.lip = TRUE; // lefty = random quantity, lip = display debug arrow
	if (self.targetname != "") self.use = entity_state_use; // Setup Entity State functionality
	self.estate_on = misc_gibfountain_on;
	if (self.spawnflags & ENT_STARTOFF) entity_state_off();
	else { // Random start timer (def=0.5 + random()*0.5)
		self.nextthink = time + self.waitmin + (self.waitmin * random());
		self.think = self.estate_on; 
	}
};

void() misc_bubble_remove = { // [FUNCTION]
	if (other.classtype == self.classtype) return;
	remove(self);
};

void() misc_bubble_split = { // [FUNCTION]
	local entity bubble;
	
	bubble = spawn();
	bubble.classname = self.classname;
	bubble.classtype = CT_BUBBLE;
	bubble.classgroup = CG_TEMPENT;
	setmodel(bubble, self.mdl);
	setorigin(bubble, self.origin);
	bubble.movetype = MOVETYPE_NOCLIP;
	bubble.solid = SOLID_NOT;
	bubble.velocity = self.velocity;
	bubble.nextthink = time + 0.5;
	bubble.think = misc_bubble_bob;
	bubble.touch = misc_bubble_remove;
	bubble.frame = 1;
	bubble.cnt = 10;
	setsize (bubble, '-8 -8 -8', '8 8 8');
	self.frame = 1;		// Smaller bubble
	self.cnt = 10;
	if (self.waterlevel != 3) remove (self);
};

void() misc_bubble_bob = { // [FUNCTION]
	local float rnd1, rnd2, rnd3;

	self.cnt = self.cnt + 1;
	if (self.cnt == 4) misc_bubble_split();
	if (self.cnt == 20) { remove(self); return; }

	rnd1 = self.velocity_x + (-10 + (random() * 20));
	rnd2 = self.velocity_y + (-10 + (random() * 20));
	rnd3 = self.velocity_z + 10 + random() * 10;
	if (rnd1 > 10) rnd1 = 5;
	if (rnd1 < -10) rnd1 = -5;
	if (rnd2 > 10) rnd2 = 5;
	if (rnd2 < -10) rnd2 = -5;
	if (rnd3 < 10) rnd3 = 15;
	if (rnd3 > 30) rnd3 = 25;
	self.velocity_x = rnd1;
	self.velocity_y = rnd2;
	self.velocity_z = rnd3;		
	self.nextthink = time + 0.5;
	self.think = misc_bubble_bob;
};

void() misc_bubble_spawn = { // [FUNCTION]
	local entity bubble;
	if (self.estate & ESTATE_BLOCK) return;
	
	bubble = spawn();
	bubble.classname = self.classname;
	bubble.classtype = CT_BUBBLE;
	bubble.classgroup = CG_TEMPENT;
	bubble.owner = self;
	setmodel(bubble, self.mdl);
	setorigin(bubble, self.origin);
	bubble.movetype = MOVETYPE_NOCLIP;
	bubble.solid = SOLID_NOT;
	bubble.velocity = '0 0 15';
	bubble.nextthink = time + 0.5;
	bubble.think = misc_bubble_bob;
	bubble.touch = misc_bubble_remove;
	bubble.frame = bubble.cnt = 0;
	setsize (bubble, '-8 -8 -8', '8 8 8');
	self.nextthink = time + random() + 0.5;
	self.think = misc_bubble_spawn;
};

// Map hack entry point
void() make_bubbles = { // [FUNCTION]
	self.mdl = SBUBBLE_DROWN;
	misc_bubble_spawn(); 
};

void() misc_bubble_on = { // [FUNCTION]
	self.estate = ESTATE_ON;
	self.nextthink = time + 1 + random();
	self.think = misc_bubble_spawn;
};

// QUAKED air_bubbles (0 .5 .8) (-8 -8 -8) (8 8 8) x x x x x x STARTOFF x
// -------- KEYS --------
// targetname : toggle state (use trigger ent for exact state)
// -------- SPAWNFLAGS --------
// STARTOFF : Always Starts off and waits for trigger
// -------- NOTES --------
// sprite based bubble that floats upward
void() air_bubbles = { // [ENTITY]
	if (deathmatch) { remove(self); return; }
	
	self.mdl = SBUBBLE_DROWN;
	precache_model (self.mdl);
	if (self.targetname != "") self.use = entity_state_use; // Setup Entity State functionality
	self.estate_on = misc_bubble_on;
	if (self.spawnflags & (MISC_STARTOFF | ENT_STARTOFF)) entity_state_off();
	else entity_state_on();
};

void() misc_drip_reset = { // [FUNCTION]
	self.touch = SUB_Null;
	self.frame = self.flags = 0;
	setmodel(self, "");
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_NONE;
	setsize (self, VEC_ORIGIN, VEC_ORIGIN);
	self.velocity = self.avelocity = '0 0 0';
	self.nextthink = time + random() + self.wait;
	self.think = misc_drip_spawn;
};

// splash animation (runs at 20fps)
void() s_splash1 = [0, s_splash2] { self.nextthink = time+0.05; }; // [FUNCTION]
void() s_splash2 = [1, s_splash3] { self.nextthink = time+0.05; }; // [FUNCTION]
void() s_splash3 = [2, s_splash4] { self.nextthink = time+0.05; }; // [FUNCTION]
void() s_splash4 = [3, s_splash5] { self.nextthink = time+0.05; }; // [FUNCTION]
void() s_splash5 = [4, s_splash6] { self.nextthink = time+0.05; }; // [FUNCTION]
void() s_splash6 = [5, misc_drip_reset] { self.nextthink = time+0.05; }; // [FUNCTION]

// splash animation (runs at 20fps)
void() s_splashremoves1 = [0, s_splashremoves2] { self.nextthink = time+0.05; }; // [FUNCTION]
void() s_splashremoves2 = [1, s_splashremoves3] { self.nextthink = time+0.05; }; // [FUNCTION]
void() s_splashremoves3 = [2, s_splashremoves4] { self.nextthink = time+0.05; }; // [FUNCTION]
void() s_splashremoves4 = [3, s_splashremoves5] { self.nextthink = time+0.05; }; // [FUNCTION]
void() s_splashremoves5 = [4, s_splashremoves6] { self.nextthink = time+0.05; }; // [FUNCTION]
void() s_splashremoves6 = [5, SUB_Remove] { self.nextthink = time+0.05; }; // [FUNCTION]

// Effects common to both drips that remove themselves and drips that move back to the start point.
void() misc_drip_touch_common = { // [FUNCTION]
	self.touch = SUB_Null;
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_NONE;
	if (self.owner.bubble_count > 0) self.owner.bubble_count = self.owner.bubble_count - 1;
	if (self.cnt) self.origin = self.pos1; // If water below, shift origin to water surface
	setorigin(self,self.origin + '0 0 8'); // Was 12
	if (!(self.spawnflags & MISC_DRIPSILENT)) { // play a random drip sound
		self.lip = random() * 3;
		if (self.lip < 1 && self.noise1 != "") sound(self,CHAN_AUTO,self.noise1,1,ATTN_STATIC);
		else if (self.lip < 2 && self.noise2 != "") sound(self,CHAN_AUTO,self.noise2,1,ATTN_STATIC);
		else if (self.noise3 != "") sound(self,CHAN_AUTO,self.noise3,1,ATTN_STATIC);
	}

	if (other != self.owner && self.owner.dmg && other.takedamage) { // Damage if our owner has dmg set
		spawn_touchblood (self,other,self.owner.dmg);
		T_Damage (other, self, self.owner, self.owner.dmg, DAMARMOR);
	}
	particle (self.origin+'0 0 1', '0 0 0.5', self.aflag+random()*4, 5+random()*5); // small particle effect when hitting something
	if (!self.headmdl || (self.headmdl != SBLOOD_SPLASH) && (self.headmdl != SSLIME_SPLASH) && (self.headmdl != SWATER_SPLASH)) self.headmdl = SWATER_SPLASH; // Switch to splash sprite and animate for 5 frames
	setmodel(self,self.headmdl);
};

void() misc_drip_touch = { // [FUNCTION]
	if (other.solid == SOLID_TRIGGER) return; // Trigger field, do nothing.

	misc_drip_touch_common();
	s_splash1();
};

// Keep checking while falling for liquid impact
void() misc_drip_water = { // [FUNCTION]
	if (self.attack_finished < time) misc_drip_reset();
	// Extremely simplified water surface check (pre-calculated)
	if (self.origin_z < self.pos1_z) misc_drip_touch();
	self.nextthink = time + 0.1;
};

// Setup new drip and wait for touch/death/water
void() misc_drip_spawn = { // [FUNCTION]
	if (self.estate & ESTATE_BLOCK) return; // Is the entity OFF or BLOCKED?

	setorigin(self, self.oldorigin); // Move drip to start position and setup sprite	
	setmodel(self, self.mdl);
	self.solid = SOLID_TRIGGER;
	if (self.cnt) self.movetype = MOVETYPE_NOCLIP;
	else self.movetype = MOVETYPE_FLY;
	setsize (self, VEC_ORIGIN, VEC_ORIGIN);
	self.velocity_z = -map_gravity * self.gravity;
	if (self.velocity_z < 1) self.velocity_z = -40;
	self.think = misc_drip_reset;
	self.nextthink = time + self.proj_trlife; // Drip only lasts 3s, don't want to travel forever
	self.touch = misc_drip_touch;
	if (self.cnt) { // Is there any water underneath drip?
		self.attack_finished = self.nextthink;
		self.nextthink = time + 0.1;
		self.think = misc_drip_water;
	}
};

void() misc_drip_on = { // [FUNCTION]
	self.estate = ESTATE_ON;
	self.nextthink = time + random() + self.wait;
	self.think = misc_drip_spawn;
};

// QUAKED misc_drip (0 .5 .8) (-8 -8 -8) (8 8 8) x SILENT x x BLOOD SLIME STARTOFF x
// -------- KEYS --------
// targetname : toggle state (use trigger ent for exact state)
// wait       : random time between drips (=random() + self.wait)
// -------- SPAWNFLAGS --------
// BLOOD    : Blood red drips
// SLIME    : Slime green drips
// SILENT   : Don't make any drip sound(good for multiple drips)
// STARTOFF : Always Starts off and waits for trigger
// -------- NOTES --------
// Falling water drip with splash and sound. (Based on code from RRP by ijed)
// - Rewritten to not keep spawning endless entities
// - Modified to have on/off/toggle state
void() misc_drip = { // [ENTITY]
	if (self.spawnflags & MISC_DRIPBLOOD) { // Pick type of drip sprite based on spawnflags
		if (self.spawnflags & 8) {
			if (self.mdl == "") self.mdl = "progs/s_dripred_lg.spr";
		} else {
			if (self.mdl == "") self.mdl = SBLOOD_DRIP;
		}

		if (self.headmdl == "") self.headmdl = SBLOOD_SPLASH;
		if (self.aflag <= 0) self.aflag = 64;
	} else if (self.spawnflags & MISC_DRIPSLIME) {
		if (self.spawnflags & 8) {
			if (self.mdl == "") self.mdl = "progs/s_dripgreen_lg.spr";
		} else {
			if (self.mdl == "") self.mdl = SSLIME_DRIP;
		}

		if (self.headmdl == "") self.headmdl = SSLIME_SPLASH;
		if (self.aflag <= 0) self.aflag = 48;
	} else {
		if (self.spawnflags & 8) {
			if (self.mdl == "") self.mdl = "progs/s_dripblue_lg.spr";
		} else {
			if (self.mdl == "") self.mdl = SWATER_DRIP;
		}

		if (self.headmdl == "") self.headmdl = SWATER_SPLASH;
		if (self.aflag < 0) self.aflag = 0;
	}

	precache_model(self.mdl); // Default cache - water
	precache_model(self.headmdl);
	self.noise1 = "rrp/misc/drip1.wav";
	self.noise2 = "rrp/misc/drip2.wav";
	self.noise3 = "rrp/misc/drip3.wav";
	precache_sound(self.noise1);
	precache_sound(self.noise2);
	precache_sound(self.noise3);
	if (self.wait <= 0) self.wait = 3; // default frequency to 3 seconds
	self.classtype = CT_MISCDRIP;
	self.classgroup = CG_MISCENT;
	self.solid = SOLID_NOT;
	if (self.gravity == 0) self.gravity = 1;
	self.movetype = MOVETYPE_NONE;
	setsize(self, VEC_ORIGIN, VEC_ORIGIN);
	self.height = pointcontents(self.origin); // Check point content for wierd setups (inside liquids/solids)
	if (self.height < CONTENT_SOLID) {
		dprint ("\b[MISCDRIP]\b Spawned inside liquid!\n");
		spawn_marker(self.origin,'0 0 0',0,SPNMARK_YELLOW);
		remove(self);
		return;
	} else if (self.height == CONTENT_SOLID) self.origin_z = self.origin_z - 2; // If flush against a ceiling, move slightly down

	if (self.proj_trlife <= 0) self.proj_trlife = 3;
	self.oldorigin = self.origin; // Setup drip particle in the correct start location
	setorigin(self, self.origin);
	self.pos1 = self.origin; // Find out bottom (world) position first
	traceline (self.pos1, self.pos1 + '0 0 -4096', TRUE, self);
	self.pos2 = trace_endpos;
	self.count = 8; // Only do loop test if water exists below
	if (trace_inwater) self.cnt = TRUE;
	else self.count = 0;

	while (self.count > 0) { // Binary divide the distance to find water surface
		if (fabs(self.pos2_z-self.pos1_z) < 8) self.count = 0; // Break out early from loop if <8 from water surface
		self.pos3 = self.pos1; // Calculate midway point between origin and endtrace
		self.pos3_z = self.pos1_z + ((self.pos2_z - self.pos1_z)*0.5);
		traceline (self.pos1, self.pos3, TRUE, self); // Test which half has water and shift top/bottom positions
		if (trace_inwater) self.pos2 = self.pos3;
		else self.pos1 = self.pos3;
		
		self.count = self.count - 1; // Only loop a limited amount of times
	}

	if (self.targetname != "") self.use = entity_state_use; // Setup Entity State functionality
	self.estate_on = misc_drip_on;
	if (self.spawnflags & (MISC_STARTOFF | ENT_STARTOFF)) entity_state_off();
	else entity_state_on();
};

void() fx_drip = { misc_drip(); };  // [ENTITY], Re-direct to correct entity name.

void() misc_drip_removetouch = { // [FUNCTION]
	if (other.solid == SOLID_TRIGGER) return; // Trigger field, do nothing.

	misc_drip_touch_common();
	self.think = s_splashremoves1;
	self.nextthink = time + 0.05;
};

void() misc_dripremovable_think = { // [FUNCTION]
	if (pointcontents(self.origin) < CONTENT_EMPTY) misc_drip_removetouch();
	self.nextthink = time + 0.1;
}

void() trigger_spawn_drips = { // [FUNCTION]
	local entity drip;

	if (self.bubble_count < self.count) {
		self.bubble_count = self.bubble_count + 1;
		drip = spawn();
		drip.owner = self;
		drip.classname = "misc_drip";
		drip.classtype = CT_MISCDRIP;
		drip.classgroup = CG_TEMPENT;
		drip.movetype = MOVETYPE_FLY;
		drip.solid = SOLID_TRIGGER;
		drip.headmdl = self.headmdl;
		setmodel(drip, self.path);
		setsize (drip, VEC_ORIGIN, VEC_ORIGIN);
		drip.origin_x = self.oldorigin_x + crandom()*self.t_width;
		drip.origin_y = self.oldorigin_y + crandom()*self.t_length;
		drip.origin_z = self.oldorigin_z;
		setorigin(drip, drip.origin);
		drip.velocity_z = -map_gravity;
		drip.nextthink = time + 0.5 + random()*0.5;
		drip.touch = misc_drip_removetouch;
		if (self.aflag > 0) {
			drip.nextthink = time + self.proj_trlife;
			drip.think = misc_drip_removetouch;
		} else drip.think = misc_dripremovable_think;
	}

	self.think = trigger_spawn_drips; // Keep spawning until told not too!
	self.nextthink = time + self.yaw_speed + random()*self.yaw_speed;
};

void() func_drips = { // [ENTITY]
	if (self.spawnflags & MISC_DRIPBLOOD) { // Pick type of drip sprite based on spawnflags
		if (self.spawnflags & 8) self.path = "progs/s_dripred_lg.spr";
		else self.path = SBLOOD_DRIP;

		self.headmdl = SBLOOD_SPLASH;
		self.aflag = 64;
	} else if (self.spawnflags & MISC_DRIPSLIME) {
		if (self.spawnflags & 8) self.path = "progs/s_dripgreen_lg.spr";
		else self.path = SSLIME_DRIP;

		self.headmdl = SSLIME_SPLASH;
		self.aflag = 48;
	} else {
		if (self.spawnflags & 8) self.path = "progs/s_dripblue_lg.spr";
		else self.path = SWATER_DRIP;

		self.headmdl = SWATER_SPLASH;
		self.aflag = 0;
	}

	precache_model(self.path); // Default cache - water
	precache_model(self.headmdl);
	if (!self.noise1) self.noise1 = "rrp/misc/drip1.wav";
	if (!self.noise2) self.noise2 = "rrp/misc/drip2.wav";
	if (!self.noise3) self.noise3 = "rrp/misc/drip3.wav";
	precache_sound(self.noise1);
	precache_sound(self.noise2);
	precache_sound(self.noise3);
	if (check_bmodel_keys()) return; // Check for bmodel errors

	InitTrigger();
	self.bubble_count = 0; // Reset counters
	if (!self.count) self.count = 5; // Max active drips
	self.oldorigin = bmodel_origin(self);
	self.oldorigin_z = self.maxs_z;
	self.t_width = (self.size_x/2);
	self.t_length = (self.size_y/2);
	if (self.yaw_speed <= 0) self.yaw_speed = 0.5; // Default spawn rate for drips
	if (self.wait <= 0) self.wait = 0.2; // Frequency
	if (self.proj_trlife <= 0) self.proj_trlife = 3; // Default lifetime if self.aflag is set > 0
	self.nextthink = time + self.wait;
	self.think = trigger_spawn_drips;
};

void() func_bubbles_reset = { // [FUNCTION]
	if (self.noise1 != "") self.target = self.noise1;
	if (self.noise2 != "") self.target2 = self.noise2;
	self.estate_on();
};

void() func_bubbles_on = { // [FUNCTION]
	self.estate = ESTATE_ON;
	self.solid = SOLID_TRIGGER;
	setsize (self, self.bbmins, self.bbmaxs); // Restore bounding box (dev testing visual thing)
	trigger_spawn_bubbles(); // Spawn bubbles inside volume brush
};

// brush based bubble source
void() func_bubbles = { // [ENTITY]
	if (check_bmodel_keys()) return;	// Check for bmodel errors

	InitTrigger();
	self.spawnflags = self.spawnflags | TRIG_SPAWNBUBBLES;
	trigger_setup_bubbles(); // Setup bubble model/counter/volume
	if (self.targetname != "") self.use = entity_state_use; // Setup Entity State functionality
	self.estate_on = func_bubbles_on;
	self.estate_off = trigger_bmodel_off;
	self.estate_disable = trigger_bmodel_disable;
	self.estate_reset = func_bubbles_reset;
	self.touch = SUB_Null; // do nothing, we are just here to blow bubbles
	if (self.spawnflags & ENT_STARTOFF) self.estate_off(); // Switch on OR off?
	else self.estate_on();
};

// Brush based sprite source.
void() func_sprite_emitter = { // [ENTITY]
	if (check_bmodel_keys()) return;	// Check for bmodel errors

	InitTrigger();
	self.spawnflags = self.spawnflags | TRIG_SPAWNBUBBLES;
	if (self.path != "") {
		self.mdl = self.path;
	} else { 
		if (self.mdl == "") self.mdl = PART_BUBBLE_BLUE;
	}
	precache_model(self.mdl);
	self.waitmin = self.bubble_count = 0;		// Reset counters
	if (!self.count) self.count = 5;			// max active bubbles
	if (!self.height) self.height = self.size_z;
	if (self.height < 64) self.height = 64;		// min top of volume
	self.oldorigin = bmodel_origin(self);
	self.oldorigin_z = self.mins_z;
	self.t_width = (self.size_x/2);
	self.t_length = (self.size_y/2);
	if (self.yaw_speed <= 0) self.yaw_speed = 0.5; // Default spawn rate
	if (self.old_velocity_x <= 0) self.old_velocity_x = 5; // Default float speed
	if (self.old_velocity_y <= 0) self.old_velocity_y = 10;
	if (self.old_velocity_z <= 0) self.old_velocity_z = 15;
	if (self.targetname != "") self.use = entity_state_use; // Setup Entity State functionality
	self.estate_on = func_bubbles_on;
	self.estate_off = trigger_bmodel_off;
	self.estate_disable = trigger_bmodel_disable;
	self.estate_reset = func_bubbles_reset;
	self.touch = SUB_Null; // do nothing, we are just here to blow bubbles
	if (self.spawnflags & ENT_STARTOFF) self.estate_off(); // Switch on OR off?
	else self.estate_on();
};

void() misc_smoke_model = { // [FUNCTION]
	self.count = self.count + 1;
	if (self.count > 59) self.count = 0;
	self.frame = self.count;
	self.think = misc_smoke_model;
	self.nextthink = time + 0.1;
};

void() misc_smoke_on = { // [FUNCTION]
	self.estate = ESTATE_ON;
	if (self.part_emitter) misc_particle_on(self.part_emitter); // Switch on particle emitter if was setup
	if (self.mdl != "") { // Restore model/size/skin
		setmodel(self, self.mdl);
		setsize (self, VEC_ORIGIN, VEC_ORIGIN);
		self.skin = self.exactskin;
		self.count = rint(random()*59);
		misc_smoke_model();
	}
};

void() misc_smoke_off = { // [FUNCTION]
	self.estate = ESTATE_OFF;
	if (self.mdl != "") self.model = ""; // Turn off model if setup
};

void() misc_smoke_setup = { // [FUNCTION]
	if (self.target != "") { // If target is setup, calculate new facing angle.  Used for angles only.
		if (!self.movetarget) self.movetarget = find(world, targetname, self.target);
		if (self.movetarget) {
			if (self.movetarget.bsporigin) self.dest1 = bmodel_origin(self.movetarget); // Check for a Bmodel object (special origin)
			else self.dest1 = self.movetarget.origin;
			
			self.movedir = normalize(self.dest1 - self.origin); // Calculate facing angle towards target
			self.angles = vectoangles(self.movedir);
			self.angles_y = self.angles_y + 180;
			if (self.part_emitter) self.part_emitter.dpp_vel = self.movedir*self.height; // Update velocity direction for DP effect
		}
	}

	if (self.targetname != "") self.use = entity_state_use; // Setup Entity State functionality
	self.estate_on = misc_smoke_on;
	self.estate_off = misc_smoke_off;
	if (self.spawnflags & (MISC_STARTOFF | ENT_STARTOFF)) entity_state_off();
	else entity_state_on();
};

// QUAKED misc_smoke (.5 .5 .75) (-8 -8 -8) (8 8 192) x NODPMDL NODPFX x x x STARTOFF x
// -------- KEYS --------
// targetname : toggle state (use trigger ent for exact state)
// target     : targeting entity used for custom direction
// angles     : 'pitch roll yaw' up/down, angle, tilt left/right 
// exactskin  : 0=Gunsmoke, 1=Soot, 2=Steam, 3=Toxin, 4=Plague, 5=Incense, 6=Lithium, 7=Flames
// alpha      : alpha value for model (def=0.65)
// wait       : time between generation of smoke particles (def=0.1, min=0.01)
// delay      : random amount of time delay ( time = wait + delay x random() )
// height     : Percentage of velocity distance travelled (def=1, range=0-1+)
// -------- SPAWNFLAGS --------
// NODPMDL    : Do not draw smoke model in DP engine
// NODPFX     : Do not draw DP smoke particle effect
// STARTOFF   : Always Starts off and waits for trigger
// -------- NOTES --------
// Smoke model, +DP only smoke effect (wait/delay/height DP only)
// angles = 'pitch roll yaw' up/down, angle, tilt left/right 
// up/left = negative value, down/right = positive value
void() misc_smoke = { // [ENTITY]
	self.mdl = "progs/ad181/misc_smoke.mdl";
	precache_model (self.mdl);
	self.classtype = CT_MISCSMOKE;
	self.classgroup = CG_MISCENT;
	self.solid = SOLID_NOT;				// No world interaction
	self.movetype = MOVETYPE_NONE;		// Static item, no movement
	if (!self.exactskin) self.exactskin = 0;	// Default = 0
	if (self.wait < 0.1) self.wait = 0.1;
	if (self.delay <= 0) self.delay = 0.1;
	if (self.height <= 0) self.height = 0.5 + random()*0.5;
	if (engine == ENG_DPEXT) { // If DP engine active remove particle shadow
		self.effects = self.effects + EF_NOSHADOW; // Originally had ef_additive but produced sorting errors
	} else {
		if (!self.alpha) self.alpha = 0.5+random()*0.25; // Setup alpha for non DP engines
	}

	makevectors(self.angles); // Calculate smoke particle movedir from angles
	self.movedir = v_up;
	if (CheckZeroVector(self.angles)) self.angles_y = rint(random()*360); // Setup some random Y axis rotation if nothing set
	if (ext_dppart) { // DP particle effects active?
		if (self.spawnflags & MISC_SMOKENODPMDL) self.mdl = ""; // Remove the model if spawnflag set
		if (query_configflag(SVR_PARTICLES) && !(self.spawnflags & MISC_SMOKENODPFX) ) { // Spawn particle emitter if particles active and not blocked
			self.part_active = PARTICLE_STYLE_SMOKE;
			if (self.spawnflags & (MISC_STARTOFF | ENT_STARTOFF)) self.part_emitter = spawn_pemitter(self, self, self.part_active, PARTICLE_START_OFF);
			else self.part_emitter = spawn_pemitter(self, self, self.part_active, PARTICLE_START_ON);
		}
	}

	self.nextthink = time + 0.1 + (rint(random()*10) * 0.1); // Setup target and delay starting model animation
	self.think = misc_smoke_setup;
};

void() misc_sparks_fade1 = [0, misc_sparks_fade2] { self.alpha = 0.8; self.nextthink = time + 0.05; }; // [FUNCTION]
void() misc_sparks_fade2 = [0, misc_sparks_fade3] { self.alpha = 0.6; self.nextthink = time + 0.05; }; // [FUNCTION]
void() misc_sparks_fade3 = [0, misc_sparks_fade4] { self.alpha = 0.4; self.nextthink = time + 0.05; }; // [FUNCTION]
void() misc_sparks_fade4 = [0, SUB_Remove       ] { self.alpha = 0.2; self.nextthink = time + 0.05; }; // [FUNCTION]

void() misc_spark_switchoff = { // [FUNCTION]
	SUB_UseTargets(); // Always switch off trigger (lights)
	if (self.estate & ESTATE_BLOCK) return; // Is the entity OFF or BLOCKED?

	if (self.wait > 0) { // Only spark once (wait for trigger)
		self.think = misc_spark_spawn;
		self.nextthink = time + self.wait + (random()*self.wait);
	}
};

void(vector pos, vector dir, float rubicon) make_spark = { // [FUNCTION]
	local entity spark;

	spark = spawn();
	spark.owner = self;
	spark.classtype = CT_TEMPSPARK;
	spark.classgroup = CG_TEMPENT;
	spark.movetype = MOVETYPE_BOUNCE;
	spark.solid = SOLID_TRIGGER;
	if (self.gravity == 1) spark.gravity = 0.3;
	if (rubicon) {
		setmodel(spark, "progs/rrp/spark.mdl"); // Precached by world. Just in case.
		spark.velocity_x = -40 + random() * 80; // Use purely random direction for Rubicon.
		spark.velocity_y = -40 + random() * 80;
		spark.velocity_z = -40 + random() * 80;
		spark.avelocity = '3000 3000 3000';
	} else {
		// AD uses different velocity and direction; supports movedir for pointing.
		setmodel(spark, "progs/ad171/misc_spark.mdl"); // Precached by world. Used by lightning tome effects.
		spark.velocity = vecrand(0,self.height,TRUE); // height defaults to 20
		spark.velocity = spark.velocity + (dir * self.speed); // speed defaults to 40
		spark.avelocity = '300 300 300';
	}

	if (self.gravity != 1) spark.velocity_z = spark.velocity_z * self.gravity;

	setorigin(spark, pos); // Weapons specify certain locations so pass value rather than use self.origin.
	setsize (spark, VEC_ORIGIN, VEC_ORIGIN);
	spark.classname = "spark";
	spark.nextthink = time + 0.5 + 1.5*random();
	spark.think = misc_sparks_fade1;
	if (random() < 0.33)	spark.skin = 0; // Some brightness variety
	else if (random() < 0.5)spark.skin = 1;
	else					spark.skin = 2;	

	if (self.exactskin > 0) spark.skin = self.exactskin; // Exact override
	if (engine == ENG_DPEXT) spark.effects = spark.effects + EF_NOSHADOW; // If DP engine active remove particle shadow
	if (self.spawnflags & MISC_SPARKBLUE) spark.skin = spark.skin + 3; // Alternative colours (blue, pale yellow & red)
	else if (self.spawnflags & MISC_SPARKPALE) spark.skin = spark.skin + 6;
	else if (self.spawnflags & MISC_SPARKRED) spark.skin = spark.skin + 9;

	newmis = spark;
};

void() misc_spark_spawn = { // [FUNCTION]
	local float loopvar;
	local entity spark;

	if (self.estate & ESTATE_BLOCK) return; // Is the entity OFF or BLOCKED?

	if (self.fixangle > 0) { // Check for random rotation, most be set for whole batch otherwise the sparks will all go in different directions
		self.angles = '0 0 0';
		self.angles_y = rint(random()*360);
		makevectors(self.angles);
		self.movedir = v_forward;
	}

	loopvar = (0.5 + random()*0.5)*self.cnt; // Work out how many sparks to spawn.  Different than Rubicon.
	while (loopvar > 0) {
		make_spark(self.origin, self.movedir, FALSE); // Pass value of FALSE since we are making AD variant sparks.  Velocity is different than Rubicon.
		loopvar = loopvar - 1;
	}
	
	if (self.noise != "") sound(self,CHAN_VOICE, self.noise,1,ATTN_STATIC); // Play any spark sound and switch ON any target lights
	if (self.target) { // Is there any target(s) to switch on, such as a light source to light up with spark emission.
		SUB_UseTargets();
		self.nextthink = time + 0.1 + random() * 0.2; // Setup timer to switch off
		self.think = misc_spark_switchoff;
	} else {
		if (self.wait > 0) { // Only spark once (wait for trigger)
			self.nextthink = time + 0.2 + self.wait + (random()*self.wait);
			self.think = misc_spark_spawn;
		}
	}
};

void() misc_spark_on = { // [FUNCTION]
	self.estate = ESTATE_ON;
	self.nextthink = time + 0.1 + random();
	self.think = misc_spark_spawn;
};

// QUAKED misc_spark (.5 .75 .5) (-8 -8 -8) (8 8 8) x BLUE PALE RED x x STARTOFF x
// Produces a burst of sparks at random intervals
// -------- KEYS --------
// targetname : toggle state (use trigger ent for exact state)
// target : If target is a light, will be switched on/off in sync
// wait   : time delay between bursts Def=2, spark once=-1
// cnt    : number of sparks in burst (0.5 + random() x 0.5) Def=16
// angle  : direction of sparks to follow, use "360" for 0
// fixangle: 1 = Random Y axis direction of sparks
// speed  : velocity speed of sparks (def=40)
// height : random velocity modifier (def=+/-20)
// sounds : 1=sparks, 4=silent, 5=custom
// noise  : custom sound for sparks
// -------- SPAWNFLAGS --------
// BLUE   : sparks are blue in colour (def=yellow)
// PALE   : sparks are pale yellow in colour (def=yellow)
// RED    : sparks are red in colour (def=yellow)
// STARTOFF : Always Starts off and waits for trigger
// -------- NOTES --------
// spark effect (based on code from Rubicon2 by JohnFitz)
// - Modified to have on/off/toggle state via triggers
// - extended parameters for angle/speed/custom sounds
// Produces a burst of sparks at random intervals
// If targeting a light, it must start switched off (lights spawnflag=1)
void() misc_spark = { // [ENTITY]
	self.mdl = "progs/ad171/misc_spark.mdl";
	precache_model (self.mdl);
	if (self.sounds == 1) self.noise = "ad171/misc/spark.wav";
	if (self.noise != "") precache_sound(self.noise);
	self.classtype = CT_MISCSPARK;
	self.classgroup = CG_MISCENT;
	self.solid = SOLID_NOT;				// No world interaction
	if (self.gravity == 0) self.gravity = 1;
	self.movetype = MOVETYPE_NONE;		// Static item, no movement
	if (!self.wait) self.wait = 2;		// -1 = spark once and turn off
	if (!self.cnt) self.cnt = 16;
	if (!self.speed) self.speed = 40;
	if (!self.height) self.height = 20;
	self.estate = ESTATE_OFF;
	if (CheckZeroVector(self.angles)) self.angles = '0 360 0'; // Always convert 0 angle to 360 for setmovedir function
	self.mangle = self.angles;
	SetMovedir();
	if (self.targetname != "") self.use = entity_state_use; // Setup Entity State functionality
	self.estate_on = misc_spark_on;
	if (self.spawnflags & (MISC_STARTOFF | ENT_STARTOFF)) entity_state_off();
	else entity_state_on();
};

void() misc_shake_think = { // [FUNCTION]
	local entity plyr;
	local float	d;

	if (self.attack_finished < time || self.estate & ESTATE_BLOCK) { // Is the shaking over?
		if (self.noise2) sound(self,CHAN_VOICE, self.noise2,1,ATTN_NORM);
		if (self.estate == ESTATE_ON) self.estate = ESTATE_OFF; // Check state before changing it, entity may be disabled
		return;
	}
	
	plyr = findradius(self.origin, self.count); // Create a list of entities to check for players
	while(plyr) {
		if (plyr.flags & FL_CLIENT) { // Only shake players (clients)	
			d = vlen(self.origin - plyr.origin); // Scale effect by distance
			d = (self.count - d)/self.count;
			if (d > 0) {
				plyr.punchangle_x = -1 * (random() + (0.025*self.dmg*d)); // shake up the view
				if (plyr.flags & FL_ONGROUND && !(self.spawnflags & MISC_SHAKEVIEWONLY)) { // push the player around
					d = self.dmg*d;
					plyr.velocity_x = plyr.velocity_x + (random()*d*2 - d);
					plyr.velocity_y = plyr.velocity_y + (random()*d*2 - d);
					plyr.velocity_z = plyr.velocity_z + (random()*d);
				}	
			}
		}
		plyr = plyr.chain; // Find next entity in chain
	}

	self.nextthink = time + 0.1; // Keep on shaking!
	self.think = misc_shake_think;
};

void() misc_shake_on = { // [FUNCTION]
	self.estate = ESTATE_ON;
	if (self.noise1) sound(self,CHAN_VOICE, self.noise1,1,ATTN_NORM); // Play earthquake LOOP sound
	self.attack_finished = time + self.wait;
	self.nextthink = time + 0.1; // keep checking for players to shake!
	self.think = misc_shake_think;
};

// QUAKED misc_shake (.5 .5 .9) (-16 -16 -8) (16 16 8) x VIEWONLY x x x x x x
// -------- KEYS --------
// targetname : toggle state (use trigger ent for exact state)
// count  : radius of shake (def = 200)
// wait   : duration of shake (def = 2s)
// dmg    : strength at center (def = 200)
// sounds : 1=loud rumble (no default)
// noise1 : noise to play when starting to shake
// noise2 : noise to play when stopping
// -------- SPAWNFLAGS --------
// VIEWONLY : Shakes the view, but player movement is not affected
// -------- NOTES --------
// Shake players view and/or velocity around center of entity.
// Always starts off, requires triggers to activate
// Screen Shake (based on code from RRP by ijed/supa)
// - Modified to have on/off/toggle state
// - added extra sound options
void() misc_shake = { // [ENTITY]
	if (self.sounds == 1) {
		self.noise1 = "ad171/misc/rumbleloop.wav";
		self.noise2 = "ad171/misc/rumbleoff.wav";
	} else {
		if (self.noise1 == "") self.noise1 = SOUND_EMPTY;
		if (self.noise2 == "") self.noise2 = SOUND_EMPTY;
	}
	precache_sound(self.noise1);
	precache_sound(self.noise2);
	self.classtype = CT_MISCSHAKE;
	self.classgroup = CG_MISCENT;
	if (!self.dmg) self.dmg = 120;
	if (self.count <= 0) self.count = 200;
	if (self.wait <= 0) self.wait = 2;
	self.attack_finished = 0;
	if (self.targetname != "") self.use = entity_state_use; // Setup Entity State functionality
	self.estate_on = misc_shake_on;
	self.estate = ESTATE_OFF;
};

void() misc_builtineffects_fire = { // [FUNCTION]
	if (self.estate & ESTATE_BLOCK) self.state = STATE_OFF; // Check if disabled/off first
	if (self.state == STATE_OFF) return;

	if (self.count == TE_TELEPORT) {
		spawn_tfog(self.movetarget.origin);
		if (self.wait > 0) { // Continuous mode?
			self.think = misc_builtineffects_fire;
			self.nextthink = time + self.wait + random()*self.delay;
		} else self.state = STATE_OFF; // Fire once and switch off

		return;
	}
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY); // Play builtin effects at target/self location
	WriteByte (MSG_BROADCAST, self.count);
	self.pos2 = self.origin;
	if (self.count == TE_LIGHTNING1 || self.count == TE_LIGHTNING2 || self.count == TE_LIGHTNING3) { // If lightning effect (self -> target)
		if (self.movetarget.bsporigin) self.pos1 = bmodel_origin(self.movetarget); // Check if target is a Bmodel? (different origin location)
		else self.pos1 = self.movetarget.origin;

		self.pos2 = self.pos1 - self.origin;
		self.t_width = vlen(self.pos2);
		if (self.t_width > 30) self.t_length = floor(self.t_width / 30) * 30; // The lightning model is made from 32 unit sections stitched together reduce the vector length down to 32 unit chunks so it does not poke through the destination object.
		else self.t_length = self.t_width;
		self.pos2 = normalize(self.pos2);
		self.pos2 = self.origin + (self.pos2 * self.t_length);
		WriteEntity (MSG_BROADCAST, self);
		WriteCoord (MSG_BROADCAST, self.origin_x);
		WriteCoord (MSG_BROADCAST, self.origin_y);
		WriteCoord (MSG_BROADCAST, self.origin_z);
	}
	WriteCoord (MSG_BROADCAST, self.pos2_x);
	WriteCoord (MSG_BROADCAST, self.pos2_y);
	WriteCoord (MSG_BROADCAST, self.pos2_z);

	// The effect sounds have to come after the write commands otherwise the engine will get confused and think the protocol has changed, there is an exact format for effects.
	if (self.count == TE_LIGHTNING1 || self.count == TE_LIGHTNING2 || 
		self.count == TE_LIGHTNING3) {
		if (self.waitmin < time) { // Stop the sound constantly playing
			sound(self.movetarget,CHAN_WEAPON,"weapons/lhit.wav",1,ATTN_NORM); // Play lightning sound(LG weapon hit)
			self.waitmin = time + 0.6;
		}
	} else if (self.count == TE_LAVASPLASH) sound(self.movetarget,CHAN_BODY,"boss1/out1.wav",1,ATTN_NORM);
	else if (self.count == TE_EXPLOSION || self.count == TE_TAREXPLOSION) sound(self.movetarget,CHAN_WEAPON,SOUND_REXP3,1,ATTN_NORM); // Play original explosion sound

	if (self.wait > 0) { // Continuous mode?
		self.think = misc_builtineffects_fire;
		self.nextthink = time + self.wait + random()*self.delay;
	} else self.state = STATE_OFF; // Fire once and switch off
};

void() misc_builtineffects_use = { // [FUNCTION]
	if (self.estate & ESTATE_BLOCK) return; // Check if disabled/off first

	if (self.state == STATE_OFF) self.state = STATE_ON; // Toggle shooter on/off
	else self.state = STATE_OFF;
	
	misc_builtineffects_fire();
};

void() misc_builtineffects_reset = { self.state = STATE_OFF; }; // [FUNCTION]

void() misc_builtineffects_setup = { // [FUNCTION]
	if (self.target != "") self.movetarget = find(world, targetname, self.target); // Find any target destinations
	else self.movetarget = self;
	
	if (self.count == TE_LIGHTNING1 || self.count == TE_LIGHTNING2 || self.count == TE_LIGHTNING3 && !self.movetarget) { // Lightning effects need source and target to work.  Check target is valid before trying to setup this effect.
			dprint("\b[MISC_EFFECTS]\b Missing target for lightning\n");
			spawn_marker(self.origin,'0 0 0',0,SPNMARK_YELLOW);
			remove(self);
	}

	if (self.targetname != "") self.use = entity_state_use; // Setup Entity State functionality
	self.estate_use = misc_builtineffects_use;
	self.estate_reset = misc_builtineffects_reset;
	self.estate = ESTATE_ON;
	self.state = STATE_OFF;
};

// QUAKED misc_builtineffect (0 .5 .8) (-8 -8 -8) (8 8 8) x
// -------- KEYS --------
// targetname : toggle state (use trigger ent for exact state)
// target  : destination of effect (self -> target)
// wait    : time between firing of effect (def=0)
// delay   : random time between firing of effect (def=0s)
// count   : type of effect to fire
          // 0=TE_SPIKE (def), 1=TE_SUPERSPIKE, 2=TE_GUNSHOT, 
		  // 3=TE_EXPLOSION (sprites), 4=TE_TAREXPLOSION (purple ver)
		  // 5=TE_LIGHTNING1 (Shambler ver), 6=TE_LIGHTNING2 (Player ver)
		  // 7=TE_WIZSPIKE, 8=TE_KNIGHTSPIKE, 9=TE_LIGHTNING3 (boss ver)
		  // 10=TE_LAVASPLASH (boss wakeup), 11=TE_TELEPORT (sparkles)
// -------- SPAWNFLAGS --------
// -------- NOTES --------
// Spawns a builtin particle effect, will toggle if active
// Always starts off, requires triggers to activate
void() misc_builtineffects = { // [ENTITY]
	if (self.count == TE_LAVASPLASH) precache_sound("boss1/out1.wav"); // Precache sounds for effects
	self.classtype = CT_PARTICLEEMIT;
	if (self.wait < 0) self.wait = 0;
	if (self.delay < 0) self.delay = 0;
	if (!self.count) self.count = 0;	// def=TE_SPIKE
	self.think = misc_builtineffects_setup;
	self.nextthink = time + 0.1 + random();
};
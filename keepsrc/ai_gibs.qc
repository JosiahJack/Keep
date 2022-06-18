//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by W. Josiah Jack, aka Qmaster
//
// Attributions: Primarily Arcane Dimensions (AD) and Drake, related to all
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
// Entity count: 0
// Function count: 14
//
// Implements: Gib effects and gore
//
// Description:
// All the functions used when a monster is gibbed into pieces or by gib
// fountains when spewing chunky meat.
//=============================================================================

.float		gibondeath;			// true/false always gib on death
.vector		gib_ofs;			// Vertical gib origin offset (override)
.string		gib1mdl;			// Gib 1 unique weapon/body part
.string		gib2mdl;			// Gib 2 unique weapon/body part
.string		gib3mdl;			// Gib 3 unique weapon/body part
.string		gib4mdl;			// Gib 4 unique weapon/body part
.string		gib5mdl;			// Gib 5 unique weapon/body part
.float		gib1skin;			// Special gib model unique skin no
.float		gib2skin;			// Special gib model unique skin no
.float		gib3skin;			// Special gib model unique skin no
.float		gib1frame;			// Frame range to randomly pick from
.float		gib2frame;			// Frame range to randomly pick from
.float		gib3frame;			// Frame range to randomly pick from
.float		gib1sound;			// Gib 1 - impact sound type
.float		gib2sound;			// Gib 2 - impact sound type
.float		gib3sound;			// Gib 3 - impact sound type
.vector		gib1origin;			// Gib 1 - Exact origin to spawn
.vector		gib2origin;			// Gib 2 - Exact origin to spawn
.vector		gib3origin;			// Gib 3 - Exact origin to spawn
.string		gib1soundx;			// Gib custom impact sound
.string		gib2soundx;			// Gib custom impact sound
.string		gib3soundx;			// Gib custom impact sound
.vector		gibvel;				// X=Forward RND, Y=Left/Right RND, Z=0
.vector		gibmins;			// Minimum bounding box for model
.vector		gibmaxs;			// Maximum bounding box for model
.float		gibdir;				// Override for gib velocity direction
.float		gibtype;			// What type of gibs (blood, stone, etc)
.float		blockudeath;		// ID udeath.wav sounds human, block it for non-humanoids
.float		gib1dmg;			// Special damage from touching
.float		gib1exp;			// Special damage particle explosion
.float		gibAnimTimer;		// Starting time for animation
.float		gibAnimstart;		// Starting frame no for animation
.float		gibAnimfinal;		// Final frame no for animation
.float		gibpartbase;		// Base quantity of particle from gibs
.float		gibpartrnd;			// Random quantity of particles from gibs
.float		gibpartlife;		// Lifetime of particles from gibs
.float		gibpartchance;		// The % percentage chance of particles
.float		gibpartstyle;		// Particle style
.vector		gibpartoffset;		// Offset to origin (center of particles)
float GIB_IMPACT_LIGHT = 0;		// Light fleshy impact (default)
float GIB_IMPACT_HEAVY = 1;		// Heavy fleshy impact
float GIB_IMPACT_ACID = 5;		// Fleshy acid burning sound (dangerous)
float GIB_IMPACT_STONE = 10;	// Light stones dropping
float GIB_IMPACT_STONE2 = 11;	// Dropping pebbles
float GIB_IMPACT_STONE3 = 12;	// Dropping pebbles
float GIB_IMPACT_WOOD = 20;		// Heavy crossbow/chainsaw
float GIB_IMPACT_METALA = 40;	// Short metal impact
float GIB_IMPACT_METALB = 41;	// Long metal impact
float GIB_IMPACT_CHAIN = 42;	// Blue metal flail
float GIB_IMPACT_CUSTOM = 50;	// Custom sound
float GIBTYPE_BLOOD = 0;		// Blood (default)
float GIBTYPE_STONE = 1;		// Stone/rubble
float GIBTYPE_WOOD = 2;			// Woodchip
float GIBTYPE_GLASS = 3;		// Glass impact sounds
float GIBTYPE_METAL = 4;		// Metal scraps
float GIBTYPE_CERAMIC = 5;		// Ceramic pot shards
float GIBTYPE_POISON = 10;		// Poisoned flesh
float GIBTYPE_ICE = 16;
float MON_BCOLOR_BROWN = 16;	// Brown dust/dirt
float MON_BCOLOR_RED = 73;		// Red index colour
float MON_BCOLOR_GREEN = 52;	// Green index
float MON_BCOLOR_YELLOW = 192;	// Bright yellow, not gold
float MON_BCOLOR_SILVER = 36;	// Silver/Ice
float MON_BCOLOR_WHITE = 4;		// Grey/white
string GIB_SOUND_HEAVY = "ad171/gibs/gibheavy1.wav";
string GIB_SOUND_HEAVY2 = "ad171/gibs/gibheavy2.wav";
string GIB_SOUND_METALA = "ad171/gibs/gibmetala.wav";
string GIB_SOUND_METALB = "ad171/gibs/gibmetalb.wav";
string GIB_SOUND_CHAIN = "ad171/gibs/gibchain.wav";
string GIB_SOUND_WOOD = "ad171/gibs/gibwood.wav";
string GIB_SOUND_UDEATH = "player/udeath.wav";
string GIB_SOUND_ACID = "ad171/gibs/gibacid.wav";
string GIB_SOUND_SDEATH = "ad171/gibs/stonedeath.wav";
string GIB1_BLOOD = "progs/ad171/gib_1.mdl";
string GIB2_BLOOD = "progs/ad171/gib_2.mdl";
string GIB3_BLOOD = "progs/ad171/gib_3.mdl";
string GIB4_BLOOD = "progs/ad171/gib_4.mdl";
string GIB5_BLOOD = "progs/q15/gib_5.mdl";
string GIB1_STONE = "progs/ad171/gib_s1.mdl";
string GIB2_STONE = "progs/ad171/gib_s2.mdl";
string GIB3_STONE = "progs/ad171/gib_s3.mdl";
string GIB4_STONE = "progs/ad171/gib_s4.mdl";
string GIB5_STONE = "progs/ad171/gib_s5.mdl";
string GIB1_POISON = "progs/ad171/gib_p1.mdl";
string GIB2_POISON = "progs/ad171/gib_p2.mdl";
string GIB3_POISON = "progs/ad171/gib_p3.mdl";
string GIB4_POISON = "progs/ad171/gib_p4.mdl";
string GIB5_POISON = "progs/ad171/gib_p5.mdl";
string GIB1_SOUND = "ad171/gibs/gib1.wav";
string GIB3_SOUND = "ad171/gibs/gib3.wav";
string GIB5_SOUND = "ad171/gibs/gib5.wav";
string GIBHIT1_SOUND = "ad171/gibs/gibhit1.wav";
string GIBHIT2_SOUND = "ad171/gibs/gibhit2.wav";
string GIBHIT3_SOUND = "ad171/gibs/gibhit3.wav";
string GIBHIT4_SOUND = "ad171/gibs/gibhit4.wav";
string GIBHIT5_SOUND = "ad171/gibs/gibhit5.wav";
string GIBHIT1_STONESOUND = "ad171/gibs/gibstone1.wav";
string GIBHIT3_STONESOUND = "ad171/gibs/gibstone3.wav";
string GIBHIT5_STONESOUND = "ad171/gibs/gibstone5.wav";
string GIBHIT1_METALSOUND = "quoth/impact/metal_i1.wav";
string GIBHIT3_METALSOUND = "quoth/impact/metal_i2.wav";
string GIBHIT5_METALSOUND = "quoth/impact/metal_i3.wav";
float GIB_FADETIME = 10;

float(entity e, float heal, float ignore) T_Repair;
void Rocket_Explosion2 (vector org, float x, float y);
float() can_eat_bones;
void MakeIcyExp (vector org);

// Only load extra gibs when there is a monster requiring them
// There are separate gib models because of particle trail colours
// These functions have to be called from monster spawn functions
// The gib system tests for the global variables defined below
// If the extra gibs are not active then default blood vers are used
void() precache_stonegibs = {
	gibstone = TRUE;
	precache_model (GIB1_STONE);			// New gib - arm/leg
	precache_model (GIB2_STONE);			// New gib - body
	precache_model (GIB3_STONE);			// New gib - slice
	precache_model (GIB4_STONE);			// New gib - small chunk/ball
	precache_model (GIB5_STONE);			// New gib - large chunk/ball
};

void() precache_poisongibs = {
	gibpoison = TRUE;
	precache_model (GIB1_POISON);			// New gib - arm/leg
	precache_model (GIB2_POISON);			// New gib - body
	precache_model (GIB3_POISON);			// New gib - slice
	precache_model (GIB4_POISON);			// New gib - small chunk/ball
	precache_model (GIB5_POISON);			// New gib - large chunk/ball
};

void() precache_bloodgibs = {
	gibblood = TRUE;
	precache_model (GIB1_BLOOD);			// New gib - arm/leg
	precache_model (GIB2_BLOOD);			// New gib - body
	precache_model (GIB3_BLOOD);			// New gib - slice
	precache_model (GIB4_BLOOD);			// New gib - small chunk/ball
	precache_model (GIB5_BLOOD);			// New gib - large chunk/ball
};

float(float gibsound) check_gibsound = {
	if (gibsound == GIB_IMPACT_HEAVY) return TRUE;
	else if (gibsound == GIB_IMPACT_METALA) return TRUE;
	else if (gibsound == GIB_IMPACT_METALB) return TRUE;
	else if (gibsound == GIB_IMPACT_CHAIN) return TRUE;
	else if (gibsound == GIB_IMPACT_WOOD) return TRUE;
	else if (gibsound == GIB_IMPACT_ACID) return TRUE;
	else if (gibsound == GIB_IMPACT_CUSTOM) return TRUE;
	else return FALSE;
};

//----------------------------------------------------------------------
void(entity gibent) DPP_blood_trail = {
	// Cannot add particle trails to the player!
	if (gibent.flags & FL_CLIENT) {
		dprint("\b[GIB]\b Cannot add particle trail to player!\n");
		return;
	}
	
	// Stone = dark black dust on the floor
	if (gibent.gibtype == GIBTYPE_STONE) {
		gibent.traileffectnum = particleeffectnum(DPP_TRSBLOOD);
	}
	// Nothing for wood at this moment
	else if (gibent.gibtype == GIBTYPE_WOOD) {}
	// Nothing for wood at this moment
	else if (gibent.gibtype == GIBTYPE_GLASS) {}
	// Nothing for wood at this moment
	else if (gibent.gibtype == GIBTYPE_METAL) {}
	// Nothing for ceramic at this moment
	else if (gibent.gibtype == GIBTYPE_CERAMIC) {}
	// Glowing green blobs splashed about
	else if (gibent.gibtype == GIBTYPE_POISON) {
		gibent.traileffectnum = particleeffectnum(DPP_TRPBLOOD);
	} else {
		gibent.traileffectnum = particleeffectnum(DPP_TRBLOOD);
	}
};

// Takes the angle between self and enemy and projects backwards
vector(float gibforce) DirectionForDamage = {
	local vector gvel;
	local float gftype;
	
	// Horrible hack!!! Need a way to override max_health.  Sometimes gibs are thrown when monsters are not dead.  This will create the correct velocity while alive
	if (self.gibdir < 0) gftype = self.gibdir;
	else gftype = self.max_health;
	
	// Gentle fountain, not much upward motion
	if (gftype == MON_GIBFOUNTAIN) {
		return NewVector(crandom()*100,crandom()*100,100+(100*random()));
	} else if (gftype == MON_GIBEXPLOSION) {
		return NewVector(crandom()*250,crandom()*250,400+(100*random())); // Party popper version, large explosion
	} else if (gftype == MON_XYGIBVELOCITY) {
		// Back to front vector so gib will travel away from enemy
		gvel = vectoangles(self.origin - self.enemy.origin);
		makevectors(gvel);
		gvel = v_forward * (50 + (100 * random()));
		gvel = gvel + (v_right * (200 * crandom()));
		gvel_z = 100 + (100 * random());
	} else if (gftype == MON_NOGIBVELOCITY) {
		// Back to front vector so gib will travel away from enemy
		gvel = vectoangles(self.origin - self.enemy.origin);
		makevectors(gvel);
		gvel = v_forward * (50 + (100 * random()));
		gvel = gvel + (v_right * (100 * crandom()));
		gvel_z = 30;
	} else if (gftype == MON_GIBTARGET) {
		// Designed for non monster entities (overwrites self entity keys).  Check for any angletarget entity tracking setup
		if (self.target != "") TargetMovedir(self, FALSE); // Converted from angletarget, not used to run entity I/O
		// default movedir movement
		gvel = self.movedir * (self.speed + (self.gibvel_x * random()));
		// Add Left/Right random velocity
		gvel = gvel + (v_right * (self.gibvel_y * crandom()));
		// Add Up/Down random velocity
		gvel = gvel + (v_up * (self.gibvel_z * crandom()));
		return gvel;
	} else {
		// Back to front vector so gib will travel away from enemy
		gvel = vectoangles(self.origin - self.enemy.origin);
		makevectors(gvel);
		gvel = v_forward * (50 + (100 * random()));
		gvel = gvel + (v_right * (100 * crandom()));
		gvel_z = 100 + (100 * random());
	}

	if (gibforce > -50) gvel = gvel * 1.25;
	return gvel;
};

// Only used when vomitus or other creature eats them now.
void() RemoveGib = {
	self.think = model_fade; // Fade away model, if active (default)
	if (self.owner.classtype == CT_MISCGIBF || self.owner.classgroup == CG_TEMPENT) self.nextthink = time + 0.1;
	else self.nextthink = time + 20;
	self.ltime = self.nextthink;
};

void() CheckFloorGib = {
	if (coop > 2 && numgamemasters > 0) return; // Need the money

	if (self.pain_finished > time) {
		// Check for particles from gib
		if (self.gibpartstyle > 0) {
			if (random() < self.gibpartchance) particle_explode(self.origin+self.gibpartoffset, self.gibpartbase+random()*self.gibpartrnd, self.gibpartlife+random(), self.gibpartstyle, 0);
		}

		// Check floor below gib (global function). Origin at base of model + 16 (typical step height)
		ent_floorcheck(self, FLOOR_TRACE_GIBS);

		// Should be used only by gibs spawned by a fountain.
		if (CheckZeroVector(self.velocity) && !CheckZeroVector(self.avelocity)) self.avelocity = '0 0 0';

		// Check for final impact animation
		if (self.gibAnimfinal > 0 && self.gibAnimTimer < time) {
			if (self.walkframe > self.gibAnimfinal) {
				self.gibAnimfinal = 0;
				RemoveGib(); // Go ahead and fade now
				return;
			} else {
				self.frame = self.gibAnimstart + self.walkframe;
				self.walkframe = self.walkframe + 1;
			}
		}
		self.think = CheckFloorGib; // Keep checking
		self.nextthink = time + 0.1;
	} else RemoveGib(); // Is it time for the gib to fade away?
};

float() Gib_Eaten;

void() TouchGib = {
	local vector dir;

	if (check_skycontent(self.origin)) { entity_remove(self, 0.1); return; } // Always check for sky and void functions first
	if (self.touchedvoid) return; // Marked for removal
    if (Gib_Eaten()) return; // This will remove self if TRUE.


	// Check if the gib can damage on touch
	if (self.gib1dmg > 0 && other.flags & FLx_CREATURE && other.takedamage) {
		T_Damage (other, self, self, self.gib1dmg, DAMARMOR);
		self.gib1dmg = 0;
		SpawnExplosion(self.gib1exp,self.origin,"");
		entity_remove(self, 0.1);
		return;
	}
	
	// Check rest of touch restrictions
	if (self.waitmin > time) return;			// Touch function disabled
	if (other == self.owner) return;			// Ignore original monster
	if (other.classgroup == CG_TEMPENT || IsProjectile(other)) return;	// Ignore other temp entities
	if (other.health < 0) return;

	self.waitmin = time + 2 + random() * 2; // Block multiple touch of impact sound
	if (self.pain_finished > time + 0.1) { // Is there any time left to setup floor checks
		self.think = CheckFloorGib;
		self.nextthink = time + 0.1;
	}
	
	if (other.classgroup == CG_FUNCMOVER) {
		if (self.waitmin2 > time) return;
		self.waitmin2 = LARGE_TIMER; // stop gibs constantly touching moving func bmodels let the impact sound work once and then stop
	}

	if (self.noise == "") { // Only need to pick the impact sound once.  No point to keep randomly picking
		self.volume = ATTN_GIB; // Setup defaults for gib impact sound
		self.noise = SOUND_EMPTY;
		if (self.weapon > 0) { // Check first for unique impact sound
			self.volume = ATTN_NORM;
			if (self.weapon == GIB_IMPACT_HEAVY) self.noise = GIB_SOUND_HEAVY;
			else if (self.weapon == GIB_IMPACT_METALA) self.noise = GIB_SOUND_METALA;
			else if (self.weapon == GIB_IMPACT_METALB) self.noise = GIB_SOUND_METALB;
			else if (self.weapon == GIB_IMPACT_CHAIN) self.noise = GIB_SOUND_CHAIN;
			else if (self.weapon == GIB_IMPACT_WOOD) self.noise = GIB_SOUND_WOOD;
			else if (self.weapon == GIB_IMPACT_ACID) self.noise = GIB_SOUND_ACID;
		} else {
			// Check default gib impact types (stone, metal, blood)
			if (self.gibtype == GIBTYPE_STONE) {
				self.lip = random() * 3;
				if (self.lip < 1) self.noise = GIBHIT1_STONESOUND;
				else if (self.lip < 2) self.noise = GIBHIT3_STONESOUND;
				else self.noise = GIBHIT5_STONESOUND;
			} else if (self.gibtype == GIBTYPE_METAL) {
				self.lip = random() * 3;
				if (self.lip < 1) self.noise = GIBHIT1_METALSOUND;
				else if (self.lip < 2) self.noise = GIBHIT3_METALSOUND;
				else self.noise = GIBHIT5_METALSOUND;
			} else if (self.gibtype == GIBTYPE_CERAMIC) {
				self.lip = random() * 4;
				if (self.lip < 1) self.noise = SOUND_IMP_CERAMIC1;
				else if (self.lip < 2) self.noise = SOUND_IMP_CERAMIC2;
				else if (self.lip < 3) self.noise = SOUND_IMP_CERAMIC3;
				else self.noise = SOUND_IMP_CERAMIC4;
			} else {
				self.lip = random() * 5;
				if (self.lip < 1) self.noise = GIBHIT1_SOUND;
				else if (self.lip < 2) self.noise = GIBHIT2_SOUND;
				else if (self.lip < 3) self.noise = GIBHIT3_SOUND;
				else if (self.lip < 4) self.noise = GIBHIT4_SOUND;
				else self.noise = GIBHIT5_SOUND;
			}
		}
	}
	if (self.noise != "") sound(self, CHAN_VOICE, self.noise, 1, self.volume); // Has any impact sounds been defined?
	if (other.flags & FLx_CREATURE) {
		self.flags = self.flags - (self.flags & FL_ONGROUND);
		self.velocity_x = self.velocity_x + other.velocity_x*2;
		self.velocity_y = self.velocity_y + other.velocity_y*2;
		self.velocity_z = vlen(self.velocity) * 0.5;
		self.avelocity = crandom() * '0 600 0';
	}
};

// Was originally in player.qc; moved here instead.  Spawns a gib model and throws it up into the air to bounce around.
void(float gib_no, float gib_qty) ThrowGib = {
	while (gib_qty > 0) {
		gibitem = spawn();
		gibitem.owner = self;
		gibitem.classname = "item_gib";
		gibitem.classtype = CT_TEMPGIB;
		gibitem.classgroup = CG_TEMPENT;
		gibitem.frame = gibitem.skin = 0;
		gibitem.physicsflags = gibitem.physicsflags | PHYS_GYRO_BOUYANT | PHYS_GYRO_MOTIONRESIST;

		// Make sure stone, metal, and glass don't float
		if (self.gibtype == GIBTYPE_STONE || self.gibtype == GIBTYPE_METAL || self.gibtype == GIBTYPE_GLASS || self.gibtype == GIBTYPE_CERAMIC) gibitem.physicsflags = 0;

		// Check for any touch/contact damage / explosions
		if (self.gib1dmg > 0) gibitem.gib1dmg = self.gib1dmg;
		if (self.gib1exp > 0) gibitem.gib1exp = self.gib1exp;
		if (self.gibtype) gibitem.gibtype = self.gibtype; // Setup gib type (particle trail)
		if (ext_dppart && self.gibtype == GIBTYPE_BLOOD) DPP_blood_trail(gibitem); // Create extra blood particles for DP engine
		
		if (gib_no == 1) {
			// Arm/leg joint (small)
			if (self.gibtype == GIBTYPE_STONE && gibstone) gibitem.mdl = GIB1_STONE;
			else if (self.gibtype == GIBTYPE_POISON && gibpoison) gibitem.mdl = GIB1_POISON;
			else gibitem.mdl = GIB1_BLOOD;
		} else if (gib_no == 2) {
			// Torso (large lump)
			if (self.gibtype == GIBTYPE_STONE && gibstone) gibitem.mdl = GIB2_STONE;
			else if (self.gibtype == GIBTYPE_POISON && gibpoison) gibitem.mdl = GIB2_POISON;
			else gibitem.mdl = GIB2_BLOOD;
		} else if (gib_no == 3) {
			// Slice (large and wedge like)
			if (self.gibtype == GIBTYPE_STONE && gibstone) gibitem.mdl = GIB3_STONE;
			else if (self.gibtype == GIBTYPE_POISON && gibpoison) gibitem.mdl = GIB3_POISON;
			else gibitem.mdl = GIB3_BLOOD;
		} else if (gib_no == 4) {
			// Blob (small and round)
			if (self.gibtype == GIBTYPE_STONE && gibstone) gibitem.mdl = GIB4_STONE;
			else if (self.gibtype == GIBTYPE_POISON && gibpoison) gibitem.mdl = GIB4_POISON;
			else gibitem.mdl = GIB4_BLOOD;
		} else if (gib_no == 5) {
			// Blob (large and round)
			if (self.gibtype == GIBTYPE_STONE && gibstone) gibitem.mdl = GIB5_STONE;
			else if (self.gibtype == GIBTYPE_POISON && gibpoison) gibitem.mdl = GIB5_POISON;
			else gibitem.mdl = GIB5_BLOOD;
		} else if (gib_no == 11) {
			// Custom Gib (defined by monster): custom model, skin and frame
			gibitem.mdl = self.gib1mdl;
			gibitem.weapon = self.gib1sound;
			if (self.gib1skin > 0) gibitem.skin = self.gib1skin;
			if (self.gib1frame) gibitem.frame = rint(random()*self.gib1frame);
			if (!(CheckZeroVector(self.gib1origin))) gibitem.oldorigin = self.gib1origin;
		} else if (gib_no == 12) {
			// Custom Gib (defined by monster): custom model, skin and frame
			gibitem.mdl = self.gib2mdl;
			gibitem.weapon = self.gib2sound;
			if (self.gib2skin > 0) gibitem.skin = self.gib2skin;
			if (self.gib2frame) gibitem.frame = rint(random()*self.gib2frame);
			if (!(CheckZeroVector(self.gib2origin))) gibitem.oldorigin = self.gib2origin;
		} else if (gib_no == 13) {
			// Custom Gib (defined by monster): custom model, skin and frame
			gibitem.mdl = self.gib3mdl;
			gibitem.weapon = self.gib3sound;
			if (self.gib3skin > 0) gibitem.skin = self.gib3skin;
			if (self.gib3frame) gibitem.frame = rint(random()*self.gib3frame);
			if (!(CheckZeroVector(self.gib3origin))) gibitem.oldorigin = self.gib3origin;
		} else if (gib_no == 14) gibitem.mdl = self.gib4mdl; // Extra Custom Gib (just models, no paramters)
		else if (gib_no == 15) gibitem.mdl = self.gib4mdl; // Extra Custom Gib (just models, no paramters)
		else if (gib_no == GIBTYPE_ICE) {
			gibitem.mdl = "progs/drake/ice_cube.mdl";
			gibitem.skin = 0;
			gibitem.alpha = 0.9;
		} else if (gib_no == 25) {
			// Special head gib (based on headmdl and skin no)
			gibitem.mdl = self.headmdl;
			gibitem.skin = self.skin;
		}

		// Check for any particles setup on gib
		if (self.gibpartstyle > 0) {
			if (self.gibpartbase > 0) gibitem.gibpartbase = self.gibpartbase;
			else gibitem.gibpartbase = 1;
			if (self.gibpartrnd > 0) gibitem.gibpartrnd = self.gibpartrnd;
			else gibitem.gibpartrnd = 1;
			if (self.gibpartlife > 0) gibitem.gibpartlife = self.gibpartlife;
			else gibitem.gibpartlife = 0.5;
			if (self.gibpartchance > 0) gibitem.gibpartchance = self.gibpartchance;
			else gibitem.gibpartchance = 0.5;
			gibitem.gibpartoffset = self.gibpartoffset;
			gibitem.gibpartstyle = self.gibpartstyle;
		}
		
		// Check for any animations on impact
		if (self.gibAnimfinal > 0) {
			gibitem.walkframe = 0;
			gibitem.gibAnimstart = self.gibAnimstart;
			gibitem.gibAnimfinal = self.gibAnimfinal;
			gibitem.gibAnimTimer = time + self.gibAnimTimer + random()*(self.gibAnimTimer*2);
		}

		// Bounce like a grenade have trigger/touch impact
		gibitem.movetype = MOVETYPE_BOUNCE;
		gibitem.solid = SOLID_TRIGGER;
		setmodel (gibitem, gibitem.mdl);
		// Allow for custom bounding box for gib models
		if (!(CheckZeroVector(self.gibmins))) setsize (gibitem, self.gibmins, self.gibmaxs);
		else setsize (gibitem, VEC_ORIGIN, VEC_ORIGIN);
		
		// 10 frames of different pose/sizes for regular gibs
		if (gib_no < 10) gibitem.frame = rint(random()*9);
		
		// Special head gib (plenty of upward motion)
		if (gib_no == 25) {
			gibitem.oldorigin = self.origin;
			setorigin(gibitem, gibitem.oldorigin);	
			gibitem.velocity_x = 50 * crandom();
			gibitem.velocity_y = 50 * crandom();
			gibitem.velocity_z = 200 + 100 * random();
			gibitem.gorging = TRUE; // don't eat heads
			gibitem.avelocity = '0 0 0';
			gibitem.avelocity_y = 200 + random() * 200;
			gibitem.angles_y = gibitem.ideal_yaw = random() * 360;
			gibitem.headmdl = "TRUE";
		} else {
			// Make sure gibs fountain items have correct origins
			if (self.classtype == CT_MISCGIBF) gibitem.oldorigin = self.origin;
			gibitem.healamount = 3 + (random() * 7);
			if (CheckZeroVector(gibitem.oldorigin)) {
				gibitem.oldorigin_x = crandom()*(self.bbmaxs_x*0.75);
				gibitem.oldorigin_y = crandom()*(self.bbmaxs_y*0.75);
				// This function was originally designed for monster bbox only.  Function has been expanded to use misc model (source) as well
				// Not every model is using the -24 unit monster floor setup.  Check for odd model setups first (zero and < 0 unit)
				if (self.bbmaxs_z == 0 && self.bbmins_z == 0) gibitem.oldorigin_z = 0;
				// If max is too small or negative, calc bbox and move downward.  This is option really relies on the gib_ofs option to compensate
				if (self.bbmaxs_z < 8) gibitem.oldorigin_z = 0 - (((self.bbmaxs_z-self.bbmins_z)*0.5)*random());
				else gibitem.oldorigin_z = (random()*self.bbmaxs_z)-12; // This is designed for monster models only
				gibitem.oldorigin = gibitem.oldorigin + self.origin + self.gib_ofs;
			}
			setorigin(gibitem, gibitem.oldorigin);
		
			// NEW Directional gib velocity with modifier
			gibitem.velocity = DirectionForDamage(self.health);
			gibitem.angles_y = gibitem.ideal_yaw = random() * 360;
			if (gib_no < 10) gibitem.avelocity = vecrand(100,200,FALSE);
			else gibitem.avelocity = crandom() * '0 300 0';
		}

		// Check for water content, adjust for water friction
		if (pointcontents(gibitem.oldorigin) == CONTENT_WATER) {
			gibitem.gravity = 0.35;
			gibitem.velocity_z = 0;
		}
	
		gibitem.touch = TouchGib;
		gibitem.nextthink = time + GIB_FADETIME + random() * GIB_FADETIME;
		gibitem.pain_finished = gibitem.nextthink;
		gibitem.think = RemoveGib;
		gibitem.th_die = SUB_Null;
		gibitem.th_pain = SUB_Null_pain;

		if (gibitem.physicsflags) {
			Gyro_Object_Activate(gibitem,MASS_GIB);
			if (gibitem.physicsflags & PHYS_GYRO_BOUYANT) Gyro_Object_SetBouyancy(gibitem,BOUY_GIB);
			if (gibitem.physicsflags & PHYS_GYRO_MOTIONRESIST) Gyro_Object_SetResistance(gibitem,RESIST_GIB);
		}
		gib_qty = gib_qty - 1;
	}
	newmis = gibitem; // Pass along last thrown gib for later.
};

// Explode monster into a shower of gibs (throw head as well)
void() monster_ThrowGib = {
	self.gibbed = TRUE; // Monster has offically gone to pieces ;)

	// New gib sounds.  Zombies have special gib sound because they always go that way!  Stone enemies are just a pile of rubble and dust!
	if (self.classgroup == CG_ZOMBIE)
		sound(self, CHAN_VOICE, "zombie/z_gib.wav", 1, ATTN_NORM);
	else if (self.classtype == CT_MONMANTICORE || self.classtype == CT_MONLICHFIEND) {
		if (random() < 0.5) sound(self, CHAN_VOICE, "qmaster/manticore/mon_manticore_death1.wav", 1, ATTN_NORM);
		else				sound(self, CHAN_VOICE, "qmaster/manticore/mon_manticore_gib.wav", 1, ATTN_NORM);
	} else if (self.gibtype == GIBTYPE_STONE)
		sound(self, CHAN_VOICE, GIB_SOUND_SDEATH, 1, ATTN_NORM);
	else {
		self.lip = random() * 4;
		if (self.lip < 1) sound (self, CHAN_VOICE, GIB1_SOUND, 1, ATTN_NORM);
		else if (self.lip < 2) sound (self, CHAN_VOICE, GIB3_SOUND, 1, ATTN_NORM);
		else {
			// Is the monster humanoid? (udeath is the original id gib sound)
			if (self.blockudeath) sound (self, CHAN_VOICE, GIB5_SOUND, 1, ATTN_NORM);
			else sound (self, CHAN_VOICE, GIB_SOUND_UDEATH, 1, ATTN_NORM);
		}
	}	
	// Some monsters have special death setups
	if (self.th_gibdie) { self.th_gibdie(); return; }
	
	// If any special gib models defined, throw them
	if (self.gib1mdl != "") ThrowGib(11, 1);
	if (self.gib2mdl != "") ThrowGib(12, 1);
	if (self.gib3mdl != "") ThrowGib(13, 1);

	// Work through each monster type (default = humanoid)
	// GIB 1 - arm/leg (small)
	// GIB 2 - torso (large)
	// GIB 3 - slice (medium)
	// GIB 4 - blob (small)
	// GIB 5 - blob (medium)
	if (self.classtype == CT_MONDEMON) { 
		ThrowGib(4, 1 + rint(random()*2));
		ThrowGib(5, 3 + rint(random()*2));
	} else if (self.classtype == CT_MONDROLE) { 
		ThrowGib(4, 2 + rint(random()*2));
		ThrowGib(5, 4 + rint(random()*2));
	} else if (self.classtype == CT_MONMANTICORE || self.classtype == CT_MONLICHFIEND) { 
		ThrowGib(4, 3 + rint(random()*2));
		ThrowGib(5, 5 + rint(random()*2));
		if (self.enemy) {
			SpawnMeatSpray (self, self.enemy, -150);
			SpawnMeatSpray (self, self.enemy, -100);
			SpawnMeatSpray (self, self.enemy, 150);
			SpawnMeatSpray (self, self.enemy, 100);
			if (self.skin == 1) { // Extra gibby
				SpawnMeatSpray (self, self.enemy, -200);
				SpawnMeatSpray (self, self.enemy, -50);
				SpawnMeatSpray (self, self.enemy, 200);
				SpawnMeatSpray (self, self.enemy, 50);
				ThrowGib(4, 1 + rint(random()*2));
				ThrowGib(5, 3 + rint(random()*2));
			}
		}
	} else if (self.classtype == 	CT_MONDOG) {
		ThrowGib(4, 1 + rint(random()*3));
		ThrowGib(5, 1 + rint(random()*2));
	} else if (self.classtype == CT_MONWRAITH) {
		ThrowGib(4, 3 + rint(random()*2));
	} else if (self.classtype == CT_MONSHAL) {
		ThrowGib(4, 2 + rint(random()*4));
		ThrowGib(5, 2 + rint(random()*2));
	} else if (self.classtype == CT_MONGOLEM) {
		ThrowGib(11, 4 + rint(random()*2));
		ThrowGib(12, 8 + rint(random()*2));
	} else if (self.classtype == CT_MONSCORPION) {
		ThrowGib(4, 2 + rint(random()*4));
		ThrowGib(5, 2 + rint(random()*2));
	} else if (self.classgroup == CG_SPIDER) {
		// Includes brown/green spiders and vorelings
		ThrowGib(4, rint(random()*3));
		ThrowGib(11, rint(random()*2));
	} else if (self.classgroup == CG_FISH) {
		ThrowGib(4, 3 + rint(random()*3));
		ThrowGib(5, 1);
	} else if (self.classtype == CT_MONBOIL) {
		ThrowGib(3, 1 + rint(random()*2));
		ThrowGib(4, 4 + rint(random()*2));
		ThrowGib(4, 5 + rint(random()*3));
	} else if (self.classgroup == CG_ZOMBIE) {
		ThrowGib(4, 3 + rint(random()*2));
	} else if (self.classgroup == CG_OGRE) {
		// Includes vanilla and new hunter ogres
		ThrowGib(4, 1 + rint(random()*3));
		ThrowGib(5, 2 + rint(random()*2));
	} else if (self.classgroup == CG_DCAPTAIN) {
		ThrowGib(3, 1);
		ThrowGib(4, 2 + rint(random()*4));
	} else if (self.classtype == CT_MONGARGOYLE) {
		ThrowGib(4, 2 + rint(random()*3));
		ThrowGib(5, 1 + rint(random()*2));
	} else if (self.classtype == CT_MONGAUNT) {
		ThrowGib(4, 3 + rint(random()*2));
		ThrowGib(5, 2 + rint(random()*2));
	} else if (self.classtype == CT_MONWIZARD) {
		ThrowGib(4, 1 + rint(random()*3));
	} else if (self.classtype == 	CT_MONSHAM) {
		ThrowGib(3, 1);
		ThrowGib(4, 2 + rint(random()*4));
		ThrowGib(5, 2 + rint(random()*4));
	} else if (self.classtype == 	CT_MONBOGLORD) {
		ThrowGib(11, 1);	// Claw 1
		ThrowGib(12, 1);	// Claw 2
		ThrowGib(13, 1);	// Foot 1
		ThrowGib(14, 1);	// Foot 2
		ThrowGib(4, 5 + rint(random()*5));
		ThrowGib(5, 10 + rint(random()*10));
	} else if (self.classtype == 	CT_MONMINOTAUR) {
		ThrowGib(3, 1);
		ThrowGib(4, 2 + rint(random()*4));
		ThrowGib(5, 2 + rint(random()*4));
	} else if (self.classtype == 	CT_MONHYDRA) {
		ThrowGib(25,1); // headmdl
		ThrowGib(11,5); // gib1mdl, lots of tentacles
		ThrowGib(4, 1);
	} else if (self.classtype == CT_MONWIZBOSS) {
		ThrowGib(25,1); // headmdl
		ThrowGib(4, 1 + rint(random()*3));
		self.health = self.health * 2.5;
		ThrowGib(5, 1 + rint(random()*3));
		self.health = self.gibhealth;
	} else if (self.classtype == CT_MONDRAKE) {
		ThrowGib(11,1); // Head, using gib1 for the dark green gib1skin
		ThrowGib(12,1 + rint(random()*3)); // Dark green chunks.
		ThrowGib(13,1);
		ThrowGib(14,1 + rint(random()*3));
	} else {
		// Default humanoid explosion
		if (random()<0.5) ThrowGib(2, 2);
		else ThrowGib(3, 1);
		ThrowGib(4, 2 + rint(random()*4));
	}				

	// Throw head last because all previous gibs rely on the origin
	if (self.headmdl != string_null) {
		if (self.max_health == MON_NOGIBVELOCITY) ThrowGib(4, rint(random()*4)); // If monster set for low velocity throw extra gibs instead
		else ThrowGib(25, 1); // Throw a head gib instead of switch to one
	}
	newmis.bodyonflr = MON_ONFLR; // Set the last thrown gib to be the respawn source.
	newmis.classname = self.classname;
	newmis.health = 0;
	newmis.flags = FL_MONSTER;
	newmis.gibbed = TRUE;
	newmis.alignment = self.alignment;
	newmis.bouncegrenade = self.bouncegrenade;
	newmis.classgroup = self.classgroup;
	newmis.classmove = self.classmove;
	newmis.classtype = self.classtype;
	newmis.yaw_speed = self.yaw_speed;
	newmis.liquidbase = self.liquidbase;
	newmis.liquidcheck = self.liquidcheck;
	newmis.max_health = self.max_health * 0.5;
	newmis.bbmins = self.bbmins;
	newmis.bbmaxs = self.bbmaxs;
	newmis.pos1 = self.origin; // Respawn point
	entity_hide (self); // Finally hide monster
};

// Check health for gib condition, and gib if so
void() monster_check_gib = {
	// There are always exceptions to the every rule! Spawns=Explode, Wraith/Wrath=Explode, Jim=Explode, SkullWiz=Fade away, Lost Souls=Explode etc. etc.
	if (self.gibhealth == MON_NEVERGIB) return;
	if (self.touchedvoid) { entity_hide(self); return; }
	if (self.gibbed) return; // Can only gib a monster once!
	if (self.gibondeath) self.health = self.gibhealth; // Make sure gibondeath has gib velocity (health value)
	if ( self.health < (self.gibhealth + 1) || self.gibondeath) { // Is it time to throw a gib party?
		monster_ThrowGib();
		monster_gibrandomizer();
	}
};

void(entity targ) ResetDebuffBurning;

// Drake - Checks if gib should be eaten.  TRUE = yes.
float() Gib_Eaten = {
    local float leave, gibs;

    if (other.health <= 0) return FALSE;   // Dead.
	if (can_eat_bones()) {
		sprint(other, "You got ");
		sprint(other, ftos(self.count));
		if (self.count == 1) sprint(other, " bone!\n");
		else sprint(other, " bones!\n");
		Safe_stuffcmd(other, "bf\n");
		bones = bones + self.count;
		sound (other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
		entity_hide(self); // Remove the gib
	}	
    if (self.healamount < 1) return FALSE;   // Gib has no food value.
	if (other.classtype != CT_MONVOMITUS) return FALSE; // only vomitus can eat gibs

    leave = 1;

	// Not including morphing into a dragon in Keep.  -Qmaster
    if (T_Heal (other, self.healamount, FALSE)) leave = 0;

    if ((!(other.xfl & XFL_HUNGRY)) && leave) return FALSE;

    if (self.headmdl != string_null) { // Do the eating effects for heads, assigned to "TRUE" on heads when heads are tossed
    	// The big crunch when eating a head!
        sound (other, CHAN_ITEM, "zerstorer/cube/bc_gulp.wav", 1, ATTN_NORM);
        gibs = 3;
        while (gibs > 0) {
            SpawnMeatSpray (self,other, 100 * crandom()); // Throw some meat chunks.
            gibs = gibs - 1;
        }

        // Removing head now can wreck links.  Do it next frame.
        ResetDebuffBurning(self);
        self.solid      = SOLID_NOT;
        self.touch      = SUB_Null;
        self.use        = SUB_Null;
        self.targetname = "";
        // Remove!
        self.nextthink  = 0.01;
        self.think      = RemoveGib;
    } else {
    	sound (other, CHAN_ITEM, "zerstorer/cube/bc_attck.wav", 1, ATTN_NORM);
        remove (self);
    }
    Safe_stuffcmd (other, "bf\n");
    return 1;
};

void(entity targ, entity attacker) Killed;

// Gib a body on the floor (special setup)
void(entity onflr, float impactdmg) monster_flrbody_gib = {
	local entity tself, tother;
	
	if (onflr.classgroup == CG_HARMLESS) return;

	onflr.bodyonflr = string_null;	// no more body gibbing
	tself = self; tother = other;	// save self/other
	self = onflr; other = tself;	// switch around
	if (onflr.classgroup == CG_ZOMBIE && (onflr.classtype != CT_MONMUMMY || self.tome_finished)) { // Mummy's are too powerful for this without tome.
		self.health = 0;
		Killed(onflr, tself);
	} else {
		self.max_health = MON_NOGIBVELOCITY; // use minimal velocity
		monster_ThrowGib();			// throw parts
	}

	self = tself; other = tother;	// switch back
	SpawnBlood (onflr, onflr.origin, '0 0 50', impactdmg*4,0);
	if (onflr.bodyonflrtrig) trigger_strs(onflr.bodyonflrtrig,self);
	entity_hide(onflr); // Hide/Remove original body/shadow
};
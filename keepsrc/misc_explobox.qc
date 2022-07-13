//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
//
// Attributions: ID1, Arcane Dimensions (AD), and Quoth
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
// Entity count: 8
// Function count: 8
//
// Implements: Exploding Boxes, Barrels, or Custom Brush Models
//
// Description:
// Entity that explodes when shot such as explosive crates, barrels, etc.
//=============================================================================

float MISC_EXPLBOX_MAX = 5;		// Maximum amount of skins available

void(string gibname, float dm) throwpolypgib;

void()	misc_ebox_0 = [0, misc_ebox_0] { // [FUNCTION]
	if (self.attack_finished < time) {
		self.lefty = 1 - self.lefty;
		self.skin = self.lefty + (self.skin_override * 2);  
		self.nextthink = time + 0.3; // Animate model skin slowly.
	}
};

void() misc_explod_delay = { // [FUNCTION]
	T_RadiusDamage (self, self, self.dmg, world, DAMAGEALL); // Explosive damage and sound+fx
	particle_explode(self.origin, 50+random()*50, 1, self.part_style, PARTICLE_BURST_UPWARD); // Particle explosion drifting upward
	particle (self.origin, '0 0 0', 0, 255); // Special type (hard-coded) of particle explosion that only works if particle count=255 :)
	if (HasTargets(self)) SUB_UseTargets(); // Check for any explosion triggers
	self.origin = self.origin + '0 0 32';
	if (self.classname == "misc_biobox_l" || self.classname == "misc_biobox_s") {
		SpawnExplosion(EXPLODE_POISON_MED, self.origin, self.noise);
		throwpolypgib("progs/quoth/polypgib.mdl", -40);
		throwpolypgib("progs/quoth/polypgib.mdl", -40);
		throwpolypgib("progs/quoth/polypgib.mdl", -40);
		throwpolypgib("progs/quoth/polypgib.mdl", -50);
		throwpolypgib("progs/quoth/polypgib.mdl", -50);
		throwpolypgib("progs/quoth/polypgib.mdl", -60);
		throwpolypgib("progs/quoth/polypgib.mdl", -60);
		throwpolypgib("progs/quoth/polypgib.mdl", -75);
		throwpolypgib("progs/quoth/polypgib.mdl", -75);
	} else {
		if (self.classname == "misc_plasmabox_l" || self.classname == "misc_plasmabox_s") {
			particle_explode(self.origin, 50+random()*50, 2, PARTICLE_BURST_BLUE, PARTICLE_BURST_UPWARD);
			SpawnExplosion(EXPLODE_PLASMA_BIG, self.origin, self.noise);
		} else SpawnExplosion(EXPLODE_SMALL, self.origin, self.noise);
	}
	entity_hide(self);
};

// Blow up the box
void() misc_explod_fire = { // [FUNCTION]
	local entity ent_explode;
	
	if (self.attack_finished > time) return;
	
	self.attack_finished = time + LARGE_TIMER;
	if (self.bsporigin) self.oldorigin = bmodel_origin(self); // Save origin for later
	else self.oldorigin = self.origin;
	
	self.estate_off(); // Switch off everything
	ent_explode = spawn();
	setorigin(ent_explode, self.oldorigin);
	ent_explode.noise = self.noise;
	ent_explode.classname = self.classname; // inherit classname for special type checks
	ent_explode.dmg = self.dmg;
	ent_explode.think = misc_explod_delay;
	ent_explode.nextthink = 0.01 + random()*0.1; // Stop recursive loops with T_RadiusDamage so delay each explosion so its not all at once.  Spawn the explosion/dmg/fx as a new entity func_explode does not want to set correct origin
};

void() misc_explobox_use = { // [FUNCTION]
	if (self.spawnflags & ENT_STARTOFF) { // If box is setup off, switch on first
		self.spawnflags = self.spawnflags - ENT_STARTOFF;
		self.estate_on();
	}
	else misc_explod_fire(); // No toggle function, just blow it up!
};

void() misc_explobox_on = { // [FUNCTION]
	if (self.attack_finished > time) return; // If the box has exploded, do nothing
	if (self.estate == ESTATE_ON) return; // Stop re-triggering ON state

	self.estate = ESTATE_ON;
	if (self.bsporigin) {
		self.solid = SOLID_BSP;
		self.movetype = MOVETYPE_PUSH;
	} else {
		self.solid = SOLID_BBOX;
		self.movetype = MOVETYPE_NONE;
	}
	setmodel(self, self.mdl);
	if (self.classname != "misc_biobox_l" || self.classname != "misc_biobox_s" || self.classname != "misc_plasmabox_l" || self.classname != "misc_plasmabox_s") self.skin = self.skin_override*2; // Set skin unless using special misc_biobox or plasmabox from Quoth
	setsize(self, self.bbmins, self.bbmaxs);
	self.th_die = misc_explod_fire;
	self.takedamage = DAMAGE_AIM;
	self.nextthink = time + 0.1;
	self.think = misc_ebox_0;
};

void() misc_explobox_off =  { // [FUNCTION]
	self.estate = ESTATE_OFF;
	self.solid = SOLID_NOT;
	self.model = "";
	self.takedamage = DAMAGE_NO;
	self.th_die = SUB_Null;
	self.think = SUB_Null;
};

void() misc_explobox_setup = { // [FUNCTION]
	if (self.noise == "") self.noise = SOUND_REXP3;
	precache_sound(self.noise);
	self.classtype = CT_EXPLO_BOX;
	self.classgroup = CG_MISCENT;
	if (self.health < 1) self.health = 15;		// ID def = 20
	if (self.dmg < 0) self.dmg = 0;
	else if (self.dmg == 0) self.dmg = 160;
	if (self.skin_override < 1 || self.skin_override > MISC_EXPLBOX_MAX) self.skin_override = 0; // Check and setup default box skin.  0=Original, 1=rubicon2, 2=plasma, 3=toxic, 4=Light wood, 5=dark wood
	if (self.skin_override == 2) self.part_style = PARTICLE_BURST_BLUE; // Setup particle explosion colour
	else if (self.skin_override == 3) self.part_style = PARTICLE_BURST_GREEN;
	else self.part_style = PARTICLE_BURST_WHITE;

	if (self.bsporigin) { // Setup exploding model
		self.mdl = self.model;		// Save model for later
		setmodel(self, self.mdl);	// set size and link into world
		self.bbmins = self.mins;	// Save bmodel bounds for later
		self.bbmaxs = self.maxs;
	} else {
		// Query console variable 'temp1' for model upgrade option.
		// Cannot use global vars because they don't exist at this point
		// Move the new centered exploding models to match old box origin
		// The default is to move all boxes to suit original id maps
		if (!query_configflag(SVR_ITEMOFFSET) && self.classname != "misc_biobox_l" && self.classname != "misc_biobox_s" && self.classname != "misc_plasmabox_l" && self.classname != "misc_plasmabox_s") {
			self.oldorigin = self.origin + '16 16 0';
			setorigin(self, self.oldorigin);
		}
		if (self.classname == "misc_barrel") {
			self.oldorigin = self.origin + '0 0 12';
			setorigin(self, self.oldorigin);
		}

		// Setting the angle key in the editor to UP/DOWN = random rotation	
		if (self.angles_y < 0 || (self.angles_y == 0 && !query_configflag(SVR_ITEMROTATE)) ) { 
			if (self.classname != "misc_biobox_l" && self.classname != "misc_biobox_s" && self.classname != "misc_plasmabox_l" && self.classname != "misc_plasmabox_s") {
				self.angles_y = rint(random()*359);
			}
		}

		// Temporarily enable model/bbox for collision test.  Finalize box location (check drop to floor)
		if ( !(self.spawnflags & ITEM_FLOATING) ) {
			setmodel(self, self.mdl);
			setsize(self, self.bbmins, self.bbmaxs);
			self.solid = SOLID_BBOX;
			self.movetype = MOVETYPE_TOSS;	
			self.origin_z = self.origin_z + 6;
			droptofloor();
			if (pointcontents(self.origin) == CONTENT_SOLID) {
				dprint (self.classname);
				dprint (" stuck at ("); dprint (vtos(self.origin)); dprint (")\n");
				spawn_marker(self.origin,'0 0 0',0,SPNMARK_YELLOW);
				remove(self);
				return;
			}
		}
	}

	// Setup Entity State functionality
	if (self.targetname != "") self.use = entity_state_use;
	self.estate_on = misc_explobox_on;
	self.estate_off = misc_explobox_off;
	self.estate_use = misc_explobox_use;
	if (self.spawnflags & ENT_STARTOFF) self.estate_off();
	else self.estate_on();
};

//QUAKED misc_explobox (0 0.5 0.8) (-16 -16 0) (16 16 64) x x x x x FLOAT STARTOFF
// { model(":progs/ad171/explode_box1.mdl"); }
// Large exploding box
// -------- KEYS --------
// target        : trigger events when box explodes
// skin_override : 0=original, 1=rubicon2, 3=plasma, 4=toxic, 5-6=wood
// noise         : Explosion sound(def=weapons/r_exp3.wav)
// health        : Amount of health before exploding (def=15)
// dmg           : Override radius damage (def=160)
// -------- SPAWNFLAGS --------
// FLOAT    : No drop to floor test
// STARTOFF : Starts off and waits for trigger
// -------- NOTES --------
// Large exploding box
void() misc_explobox = { // [ENTITY]
	if (self.mdl == "") self.mdl = "progs/ad171/explode_box1.mdl";	// maps/b_explob.bsp
	precache_model (self.mdl);
	self.bbmins = '-16 -16 0';
	self.bbmaxs = '16 16 64';
	misc_explobox_setup();
};

// QUAKED misc_explobox2 (0 0.5 0.8) (-16 -16 0) (16 16 32) x x x x x FLOAT STARTOFF
// { model(":progs/ad171/explode_box2.mdl"); }
// Small exploding box
// -------- KEYS --------
// target        : trigger events when box explodes
// skin_override : 0=original, 1=rubicon2, 3=plasma, 4=toxic, 5-6=wood
// noise         : Explosion sound(def=weapons/r_exp3.wav)
// health        : Amount of health before exploding (def=15)
// dmg           : Override radius damage (def=160)
// -------- SPAWNFLAGS --------
// FLOAT    : No drop to floor test
// STARTOFF : Starts off and waits for trigger
// -------- NOTES --------
// Small exploding box
void() misc_explobox2 = { // [ENTITY]
	if (self.mdl == "") self.mdl = "progs/ad171/explode_box2.mdl";
	precache_model (self.mdl);
	self.bbmins = '-16 -16 0';
	self.bbmaxs = '16 16 32';
	misc_explobox_setup();
};

void() misc_barrel = { // [ENTITY]
	if (self.mdl == "") self.mdl = "maps/nsoe2/b_barrel.bsp";
	precache_model (self.mdl);
	self.bbmins = '-16 -16 -20';
	self.bbmaxs = '16 16 16';
	misc_explobox_setup();
};

// QUAKED func_explobox (0 0.5 0.8) ? x x x x x x STARTOFF x
// Exploding box (bmodel)
// -------- KEYS --------
// target      : trigger events when box explodes
// noise       : Explosion sound(def=weapons/r_exp3.wav)
// health      : Amount of health before exploding (def=15)
// dmg         : Override radius damage (def=160)
// _dirt       : -1 = will be excluded from dirtmapping
// _minlight   : Minimum light level for any surface of the brush model
// _mincolor   : Minimum light color for any surface (def='1 1 1' RGB)
// _shadow     : Will cast shadows on other models and itself
// _shadowself : Will cast shadows on itself
// -------- SPAWNFLAGS --------
// STARTOFF : Starts off and waits for trigger
// -------- NOTES --------
// Exploding box (bmodel)
void() func_explobox = { // [ENTITY]
	if (check_bmodel_keys()) return;	// Check for bmodel errors
	
	self.mdl = self.model;					// Brushwork version
	self.bsporigin = TRUE;					// bmodel object
	self.angles = '0 0 0';					// Make sure no angle twist
	self.skin_override = 0;				// Only bsp skins
	self.spawnflags = self.spawnflags - (self.spawnflags & ITEM_FLOATING); // Cannot be setup floating (always remove flag)
	misc_explobox_setup();
};

// Vanilla ID map hack (not used directly anymore)
void() barrel_explode = { // [FUNCTION]
	self.enemy = spawn();
	setorigin(self.enemy, self.origin+'0 0 32');
	self.enemy.noise = SOUND_REXP3;
	self.enemy.dmg = 160;
	self.enemy.think = misc_explod_delay;
	self.enemy.nextthink = 0.01 + random()*0.1;
};

void() misc_biobox_l = { // [ENTITY]
	if (self.mdl == "") self.mdl = "maps/quoth/b_bio_l.bsp";
	precache_model (self.mdl);
	precache_model ("progs/quoth/polypgib.mdl");
	precache_sound("quoth/drole/explode3.wav");
	self.noise = "quoth/drole/explode3.wav";
	self.bbmins = '-16 -16 0';
	self.bbmaxs = '16 16 64';
	if (self.dmg < 0) self.dmg = 0;
	else if (self.dmg == 0) self.dmg = 80;
	self.skin_override = 3; // Green particle burst
	misc_explobox_setup();
};

void() misc_biobox_s = { // [ENTITY]
	if (self.mdl == "") self.mdl = "maps/quoth/b_bio_s.bsp";
	precache_model (self.mdl);
	precache_model ("progs/quoth/polypgib.mdl");
	precache_sound("quoth/drole/explode3.wav");
	self.noise = "quoth/drole/explode3.wav";
	self.bbmins = '-16 -16 0';
	self.bbmaxs = '16 16 32';
	if (self.dmg < 0) self.dmg = 0;
	else if (self.dmg == 0) self.dmg = 80;
	self.skin_override = 3; // Green particle burst
	misc_explobox_setup();
};

void() misc_plasmabox_l = { // [ENTITY]
	if (self.mdl == "") self.mdl = "maps/quoth/b_plas_l.bsp";
	precache_model (self.mdl);
	precache_sound("rogue/plasma/explode.wav");
	self.noise = "rogue/plasma/explode.wav";
	self.bbmins = '-16 -16 0';
	self.bbmaxs = '16 16 64';
	if (self.dmg < 0) self.dmg = 0;
	else if (self.dmg == 0) self.dmg = 200;
	self.skin_override = 2; // Blue particle burst
	misc_explobox_setup();
};

void() misc_plasmabox_s = { // [ENTITY]
	if (self.mdl == "") self.mdl = "maps/quoth/b_plas_s.bsp";
	precache_model (self.mdl);
	precache_sound("rogue/plasma/explode.wav");
	self.noise = "rogue/plasma/explode.wav";
	self.bbmins = '-16 -16 0';
	self.bbmaxs = '16 16 32';
	if (self.dmg < 0) self.dmg = 0;
	else if (self.dmg == 0) self.dmg = 200;
	self.skin_override = 2; // Blue particle burst
	misc_explobox_setup();
};
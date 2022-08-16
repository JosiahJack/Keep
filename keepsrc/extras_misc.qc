//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
//
// Attributions: Frank Condello (aka pOx), Khreathor for the extras_r5 update,
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
// Entity count: 4
// Function count: 5
//
// Implements: Miscellaneous Brush Entities
//
// Description:
// Various brush entities.
//=============================================================================

float HEAL = 1;
float BLEED = 2;

void() explobsp_explode = { // [FUNCTION]
	local entity new, stemp;
	
	self.takedamage = DAMAGE_NO;
	activator = damage_attacker;
	self.delay = 0.01;// Don't fire targets right away, since they might be inside
	SUB_UseTargets();
	new = spawn(); // Make an explosion at the center
	new.origin = self.dest;
	new.movetype = MOVETYPE_NONE;
	new.solid = SOLID_NOT;
	setorigin(new, new.origin);
	new.classname = "explo_box";
	T_RadiusDamage(new, new, self.dmg, world, DAMAGEALL);
	Tent_Explosion(new.origin);
	stemp = self;
	self = new;
	BecomeExplosion();
	self = stemp;
	if (self.mdl) setmodel(self, self.mdl); // Go into exploded frame, or disappear
	else remove(self);
};

void(entity inflictor, entity attacker, float damage) explobsp_hurt = { // [FUNCTION]
	if (self.spawnflags & HEAL) {
		self.health = self.max_health;
		return;
	}
};

// QUAKED func_explobsp (0 .5 .8) ?
// Basically just like misc_explobox, but uses whatever geometry ya like.
// The explosion occurs at the exact center of the brushes, so keep that in mind.
// "health" 		Maximum health
// "dmg" 			Amount of damage caused by explosion
// "target"		Activate this when exploding
// "targetname" 	Can be targeted by a func_bspframe or for exploding remotely
// "HEAL"			Only dies if one shot of damage is greater than health (heals small damage)
void() func_explobsp = { // [ENTITY]
	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_PUSH;
	self.bsporigin = TRUE;
	setmodel(self, self.model);
   	setsize(self, self.mins, self.maxs );
	precache_sound("weapons/r_exp3.wav");
	if (!self.health) self.health = 20;
	if (!self.dmg) self.dmg = 160;
	self.dest = (self.mins + self.maxs)*0.5; // Center of the volume
	self.th_pain = explobsp_hurt;
	self.th_die = explobsp_explode;
	self.use = explobsp_explode;
	self.takedamage = DAMAGE_AIM;
	self.nobleed = TRUE;
};

void() breakaway_break = { // [FUNCTION]
	self.takedamage = DAMAGE_NO;
	if (self.noise1) sound(self,CHAN_VOICE, self.noise1,1,ATTN_NORM);	
	activator = damage_attacker;
	self.delay = 0.01;// Don't fire targets right away, since they might be inside
	SUB_UseTargets();
	if (self.mdl) { // Go into exploded frame, or disappear
		self.frame = 0;
		setmodel(self, self.mdl);
	} else remove(self);
};

void(entity inflictor, entity attacker, float damage) breakaway_hurt = { // [FUNCTION]
	if (self.noise1) sound(self,CHAN_VOICE, self.noise1,1,ATTN_NORM);	
	if (self.spawnflags & HEAL) { self.health = self.max_health; return; }
	
	if (!self.frame && self.health <= self.frags) self.frame = 1;
};


// QUAKED func_breakaway (0 .5 .8) ? HEAL BLEED
// This is a simple BSP model that goes away (or becomes it's alternate frame) when killed.
// These can be used to mimic "gibbable" objects when combined with emitters, or on their
// own for small breakable panels.
// "health" 		Maximum health
// "frags"			Use alt texture when "health" equals or is less than this
// "noise"			noise to make when dying (breaking)
// "noise1"		noise to make when taking damage
// "target"		Activate this when dying (i.e. target an emitter to generate rubble)
// "targetname" 	Can be targeted by a func_bspframe or for triggering remotely
// "HEAL"			Only dies if one shot of damage is greater than health (heals small damage)
// "BLEED"			Show blood effect instead of sparks when shot
void() func_breakaway = { // [ENTITY]
	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_PUSH;
	self.bsporigin = TRUE;
	setmodel(self, self.model);
   	setsize(self, self.mins, self.maxs );
	if (self.noise)	precache_sound(self.noise);
	if (self.noise1) precache_sound(self.noise1);
	if (!self.health) self.health = 20;
	self.max_health = self.health;
	if (!(self.spawnflags & BLEED)) self.nobleed = TRUE;
	self.th_pain = breakaway_hurt;
	self.th_die = breakaway_break;
	self.use = breakaway_break;
	self.takedamage = DAMAGE_AIM;
};

// QUAKED func_nodraw (0 .5 .8) ? 1
// Like func_wall, but is invisible by default, and has no think/use.
// Spawnflags:
// "1" Show brush geometry
void() func_nodraw = { // [ENTITY]
	self.angles = '0 0 0';
	self.movetype = MOVETYPE_PUSH;
	self.bsporigin = TRUE;
	self.solid = SOLID_BSP;
	setmodel(self, self.model);
	if (!(self.spawnflags & 1)) self.model = "";
};


// Transfer mdl to owner
void() bspframe_init = { // [FUNCTION]
	local entity targ;
	
	targ = find (world, targetname, self.target);
	if (targ.classname == "func_switch" || targ.classname == "func_explobsp" || targ.classname == "func_breakaway") targ.mdl = self.mdl;
	remove(self);
};

// QUAKED func_bspframe (0 .5 .8) ?
// A little hack to allow alternate bsp model "frames" for certain ents
// "target"	The owner object
// When used on solid objects (like func_explobsp) insure these won't stick into nearby
// players/monsters
// when the parent object switches frames. (i.e. make this object smaller
// than the parent, or create
// a clip area that encompases both object frames)
void() func_bspframe = { // [ENTITY]
	if (!self.target) objerror("func_bspframe without target");
	self.angles = '0 0 0';
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.mdl = self.model;
	self.modelindex = 0;
	self.model = "";
	self.nextthink = time+0.1;
	self.think = bspframe_init;
};
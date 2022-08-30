//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
//
// Attributions: Quake 1.5 by BloodShot
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
// Function count: 9
//
// Implements: Miscellaneous Decorations
//
// Description:
// Various decorative entities from Quake 1.5.
//=============================================================================

float FLAG_REMOVE_PARTICLES = 2;
float FLAG_REMOVE_ACTOR = 4;
float FLAG_HIDE = 8;
float FLAG_SPAWN_PART = 16;

void() light_fluoropost_dead = { // [FUNCTION]
	local entity deadlight;
	local float oldz;
	
	precache_model ("progs/q15/lightp.mdl");
	deadlight = spawn();
	precache_sound("ambience/buzz1.wav");
	ambientsound(self.origin, "ambience/buzz1.wav", 0.5,ATTN_STATIC);
	setmodel(deadlight, "progs/q15/lightp.mdl");
	deadlight.skin = 1;
	deadlight.origin_z = self.origin_z;
	deadlight.origin_x = self.origin_x;
	deadlight.origin_y = self.origin_y;
	setsize(deadlight, '-8 -8  -10', '8 8 43');
	deadlight.solid = SOLID_BBOX;
	deadlight.movetype = MOVETYPE_NONE;
	oldz = self.origin_z;
	if (oldz - self.origin_z > 250) {
		dprint ("item fell out of level at ");
		dprint (vtos(self.origin));
		dprint ("\n");
		remove(self);
	}
};

void() light_break = { // [FUNCTION]
	local vector center;

	self.takedamage = DAMAGE_NO;
	self.classname = "light_destruct";
	sound(self,CHAN_VOICE, "misc/lightbrk.wav",1,ATTN_NORM);
	center = (self.absmin + self.absmax) * 0.5;		// added to bring the explosion to the center of the explo_box model
	setorigin(self, (self.absmin + self.absmax) * 0.5);
	T_RadiusDamage(self, self, 5, world,DAMAGEALL);
	BecomeExplosion();
	if (ext_dppart) pointparticles(particleeffectnum("secret"), center, '0 0 0', 1);
};

void() light_det = { // [FUNCTION]
	light_fluoropost_dead();
	lightstyle(self.style, "b");
	ambientsound(self.origin, "ambience/buzz1.wav", 0.5,ATTN_STATIC);
	self.think = light_break;
	self.nextthink = time;
	if (other.flags & FL_CLIENT) activator = other;
	SUB_UseTargets();
};

void() light_fluoropost = { // [ENTITY]
	local float	oldz;
	local vector center;
	
	center = (self.absmin + self.absmax) * 0.5;
	self.solid = SOLID_BBOX;
	self.movetype = MOVETYPE_NONE;
	precache_model ("progs/q15/lightp.mdl");
	precache_sound("ambience/buzz1.wav");
	setmodel(self, "progs/q15/lightp.mdl");
	setsize(self, '-8 -8  -10', '8 8 43');
	precache_sound("misc/lightbrk.wav");
	self.health = 20;
	self.th_die = light_det;
	self.takedamage = DAMAGE_YES;
	if (self.health == 20) {
		lightstyle(self.style, "m");
		precache_sound("ambience/fl_hum1.wav");
		ambientsound(self.origin, "ambience/fl_hum1.wav", 0.5,ATTN_STATIC);
	}
};

//Ceiling Light
void() light_ceil_dead = { // [FUNCTION]
	local entity deadlight;
	local float oldz;
	
	precache_model ("progs/q15/lightceil.mdl");
	deadlight = spawn();
	setmodel(deadlight, "progs/q15/lightceil.mdl");
	deadlight.skin = 1;
	deadlight.origin_z = self.origin_z;
	deadlight.origin_x = self.origin_x;
	deadlight.origin_y = self.origin_y;
	deadlight.solid = SOLID_BBOX;
	setsize(deadlight, '-8 -8 -8', '8 8 8');
	deadlight.movetype = MOVETYPE_NONE;
	precache_sound("ambience/buzz1.wav");
	ambientsound(self.origin, "ambience/buzz1.wav", 0.5,ATTN_STATIC);
	oldz = self.origin_z;
	droptofloor();
	if (oldz - self.origin_z > 250) {
		dprint ("item fell out of level at ");
		dprint (vtos(self.origin));
		dprint ("\n");
		remove(self);
	}
};

void() light_cdet = { // [FUNCTION]
	light_ceil_dead();
	lightstyle(self.style, "b");
	remove(self.owner);
	self.think = light_break;
	self.nextthink = time;
};

void() light_ceil = { // [ENTITY]
	local float	oldz;
	local vector center;
	local entity lightray;
	
	center = (self.absmin + self.absmax) * 0.5;
	self.solid = SOLID_BBOX;
	self.movetype = MOVETYPE_NONE;
	precache_model("progs/q15/lightceil.mdl");
	precache_model("progs/q15/p_lightbeams.mdl");
	setmodel(self,"progs/q15/lightceil.mdl");
	precache_sound("misc/lightbrk.wav");
	precache_sound("misc/siren.wav");
	lightray = spawn();
	setorigin(lightray, self.origin);
	lightray.solid = SOLID_NOT;
	setmodel(lightray, "progs/q15/p_lightbeams.mdl");
	lightray.movetype = MOVETYPE_FLY;
	lightray.alpha = 0.6;
	lightray.effects = EF_FULLBRIGHT;
	lightray.avelocity = '0 300 0';
	self.owner = lightray;
	self.health = 20;
	self.th_die = light_cdet;
	self.takedamage = DAMAGE_YES;
	if (self.health == 20) {
		lightstyle(self.style, "m");
		ambientsound(self.origin, "misc/siren.wav", 0.5,ATTN_STATIC);
	}
};

//New Ceiling fixture
void() light_fix_dead = { // [FUNCTION]
	local entity deadlight;
	local float oldz;
	
	deadlight = spawn();
	if (self.skin == 0) {
		precache_model ("progs/q15/lightfix.mdl");
		setmodel(deadlight, "progs/q15/lightfix.mdl");
	} else {
		precache_model ("progs/q15/lightfixalt.mdl");
		setmodel(deadlight, "progs/q15/lightfixalt.mdl");
	}
	precache_sound("ambience/buzz1.wav");
	ambientsound(self.origin, "ambience/buzz1.wav", 0.5,ATTN_STATIC);
	deadlight.skin = 1;
	deadlight.origin_z = self.origin_z;
	deadlight.origin_x = self.origin_x;
	deadlight.origin_y = self.origin_y;
	setsize(deadlight, VEC_HULL2_MIN, VEC_HULL2_MAX);
	deadlight.solid = SOLID_BBOX;
	deadlight.movetype = MOVETYPE_NONE;
}

void() light_fdet = { // [FUNCTION]
	light_fix_dead();
	lightstyle(self.style, "b");
	self.think = light_break;
	self.nextthink = time;
};

void() light_fix = { // [ENTITY]
	local float	oldz;
	local vector center;
	
	center = (self.absmin + self.absmax) * 0.5;
	self.solid = SOLID_BBOX;
	self.movetype = MOVETYPE_NONE;
	if (self.skin == 0) {
		precache_model ("progs/q15/lightfix.mdl");
		setmodel(self, "progs/q15/lightfix.mdl");
	} else {
		precache_model ("progs/q15/lightfixalt.mdl");
		setmodel(self, "progs/q15/lightfixalt.mdl");
	}
	precache_sound("misc/lightbrk.wav");
	self.health = 20;
	self.th_die = light_fdet;
	self.takedamage = DAMAGE_YES;
	if (self.health == 20) {
		lightstyle(self.style, "m");
		precache_sound("ambience/fl_hum1.wav");
		ambientsound(self.origin, "ambience/fl_hum1.wav", 0.5,ATTN_STATIC);
	}
};

void() actor_anim = { // [FUNCTION]
	if (self.frame < self.height) {
		self.frame++;
		self.think = actor_anim;
		self.nextthink = time + self.speed;
	} else if (ext_dppart && self.spawnflags & FLAG_REMOVE_PARTICLES) self.traileffectnum = particleeffectnum("");
}

void() actor_throw = { // [FUNCTION]
	newmis = spawn();
	setmodel(newmis, self.mdl);
	setsize (newmis, '-16 -16 -24', '16 16 40');
	setorigin(newmis, self.oldorigin + self.view_ofs);
	setmodel(self, "progs/null.spr");
	if (self.noise) sound(newmis,CHAN_AUTO,self.noise,1,ATTN_NORM);
	if (ext_dppart && self.partname) newmis.traileffectnum = particleeffectnum(self.partname);
	newmis.angles = self.angles;
	newmis.movetype = MOVETYPE_TOSS;
	newmis.velocity = self.velocity;
	newmis.frame = self.frame;
	newmis.height = self.height;
	newmis.speed = self.speed;
	newmis.spawnflags = self.spawnflags;
	if (self.spawnflags & FLAG_REMOVE_ACTOR) {
		newmis.solid = SOLID_TRIGGER;
		newmis.touch = SUB_Remove;
	}
	
	if (self.height) {
		newmis.think = actor_anim;
		newmis.nextthink = time;
	}
};

void() misc_actor = { // [ENTITY]
	if (deathmatch && !(self.spawnflags & 4096)) { remove(self); return; }
	
	if (!self.mdl) self.mdl = "progs/player.mdl";
	precache_model (self.mdl);
	if (self.noise) precache_sound(self.noise);
	self.solid = SOLID_NOT;				// No world interaction
	self.movetype = MOVETYPE_NONE;		// Static item, no movement
	self.oldorigin = self.origin;		// Store for later
	if (self.spawnflags & FLAG_HIDE) self.effects = self.effects | EF_NODRAW;
	setmodel(self, self.mdl);
	setsize (self, self.mins , self.maxs);
	setorigin(self, self.oldorigin + self.view_ofs);
	self.use = actor_throw;
};
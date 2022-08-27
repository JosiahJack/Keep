//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
//
// Attributions: Mission Pack 1 (Hipnotic)
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
// Entity count: 2
// Function count: 9
//
// Implements: Point Exploders
//
// Description:
// The entities here allow explosions to be spawned when targeted, once or
// multiple times.  Useful for special events.  Also defines the explosions
// used by Armagon's death sequence.
//=============================================================================

float EXPLODER_USE_PARTICLES = 1.000;

void(vector spot) R_Exp3;

void() big_explosion_think = { // [FUNCTION]
	self.frame = self.frame + 1;
	if (self.frame > 16) SUB_Remove();
	self.nextthink = time + 0.05;
	self.think = big_explosion_think;
};

void(vector org, float snd) spawn_big_explosion = { // [FUNCTION]
	local entity e;

	e = spawn();
	e.movetype = MOVETYPE_NONE;
	e.solid = SOLID_NOT;
	setmodel(e, "progs/quoth/bigexp.spr");
	setorigin(e, org);
	if (snd == 1) R_Exp3(org);
	e.alpha = 0.6;
	e.effects = 32;
	e.nextthink = time + 0.05;
	e.think = big_explosion_think;
};

void() small_explosion_think = { // [FUNCTION]
	self.frame = self.frame + 1;
	if (self.frame > 13) SUB_Remove();
	self.nextthink = time + 0.05;
	self.think = small_explosion_think;
};

void(vector org, float snd) spawn_small_explosion = { // [FUNCTION]
	local entity e;

	e = spawn();
	e.movetype = MOVETYPE_NONE;
	e.solid = SOLID_NOT;
	setmodel(e, "progs/quoth/smlexp.spr");
	setorigin(e, org);
	if (snd == 1) R_Exp3(org);
	e.alpha = 0.6;
	e.effects = 32;
	e.nextthink = time + 0.05;
	e.think = small_explosion_think;
};

void() exploder_fire = { // [FUNCTION]
   local entity temp;

   temp = self;
   activator = other;
   SUB_UseTargets();
   self = temp;
   other = self;
   if ( (self.dmg < 120) ) sound(self,CHAN_AUTO,"drake/misc/shortexp.wav",self.volume,self.speed);
   else sound(self,CHAN_AUTO,"drake/misc/longexpl.wav",self.volume,self.speed);

   T_RadiusDamage(self,self.owner,self.dmg,other,DAMAGEALL);
   if (self.spawnflags & EXPLODER_USE_PARTICLES) Tent_Explosion(self.origin);
   BecomeExplosion();
};

void() exploder_use = { // [FUNCTION]
   if (self.delay ) {
      self.nextthink = (time + self.delay);
      self.delay = FALSE;
      self.think = exploder_fire;
   } else exploder_fire();
};

void() func_exploder = { // [ENTITY]
	precache_sound("drake/misc/shortexp.wav");
	precache_sound("drake/misc/longexpl.wav");
	self.classname = "exploder";
	self.use = exploder_use;
	if (!self.owner) self.owner = find(world, classname, self.netname); // If netname is set, this explosion won't harm the netname, useful for protecting bosses
	if (!self.owner) self.owner = find(world, targetname, self.netname);
	if (self.dmg == 0 && self.classname != "func_explode") self.dmg = 120; // \/...Other than this damage caveat that is.
	if (self.dmg < 0) self.dmg = 0;
	if ( (self.speed <= 0) ) self.speed = 1;
	if (self.volume <= 0) self.volume = 1;
};

// Zerst�rer entity, redirects to Hipnotic version since it's the same..../\
void() func_explode = { // [ENTITY]
   func_exploder();
};

void() multi_exploder_fire = { // [FUNCTION]
   local entity temp;
   local entity expl;

   self.nextthink = (time + self.wait);
   if ( (self.state == FALSE) ) {
      self.state = TRUE;
      self.duration = (time + self.duration);
      temp = self;
      activator = other;
      SUB_UseTargets();
      self = temp;
      other = self;
   }
   if (time > self.duration) { remove(self); return; }

   expl = spawn();
   expl.owner = self.owner;
   expl.dmg = self.dmg;
   expl.origin_x = (self.absmin_x + (random() * (self.absmax_x - self.absmin_x)));
   expl.origin_y = (self.absmin_y + (random() * (self.absmax_y - self.absmin_y)));
   expl.origin_z = (self.absmin_z + (random() * (self.absmax_z - self.absmin_z)));
   sound(expl,CHAN_VOICE,"drake/misc/shortexp.wav",self.volume,self.speed);
   T_RadiusDamage(expl,self.owner,self.dmg,other,DAMAGEALL);
   if (self.spawnflags & EXPLODER_USE_PARTICLES) Tent_Explosion(expl.origin);
   temp = self;
   self = expl;
   BecomeExplosion();
   self = temp;
};

void(vector loc, float rad, float damage, float dur, float pause, float vol) multi_explosion = { // [FUNCTION]
   local entity temp;

   temp = self;
   self = spawn();
   self.origin = loc;
   self.dmg = damage;
   self.duration = dur;
   self.wait = pause;
   self.owner = world;
   self.absmin = (self.origin - (rad * '1 1 1'));
   self.absmax = (self.origin + (rad * '1 1 1'));
   self.think = multi_exploder_fire;
   self.volume = vol;
   multi_exploder_fire();
   self = temp;
};

void() multi_exploder_use = { // [FUNCTION]
   if (self.delay) {
      self.nextthink = (time + self.delay);
      self.delay = FALSE;
      self.think = multi_exploder_fire;
   } else {
      self.think = multi_exploder_fire;
      multi_exploder_fire();
   }
};

void() func_multi_exploder = { // [ENTITY]
   precache_sound("drake/misc/shortexp.wav");
   precache_sound("drake/misc/longexpl.wav");
   self.classname = "exploder";
   self.use = multi_exploder_use;
   setmodel(self,self.model);
	if (!self.owner) self.owner = find(world, classname, self.netname); // if netname is set, this explosion won't harm the netname, useful for protecting bosses
	if (!self.owner) self.owner = find(world, targetname, self.netname);
   self.movetype = MOVETYPE_NONE;
   self.modelindex = FALSE;
   self.model = "";
   if ( (self.dmg == FALSE) ) self.dmg = 120;
   if ( (self.dmg < FALSE) )  self.dmg = FALSE;
   if ( (self.duration == FALSE) ) self.duration = TRUE;
   if ( (self.speed == FALSE) ) self.speed = TRUE;
   if ( (self.volume == FALSE) ) self.volume = 0.500;
   if ( (self.wait == FALSE) ) self.wait = 0.250;
   self.state = FALSE;
};
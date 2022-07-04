//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
//
// Attributions: Rubicon by John Fitzgibbons
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
// Function count: 3
//
// Implements: Miscellaneous Decorative and Effects Entities
//
// Description:
// Sparks effect that is different than AD's version.
// A flag.
//=============================================================================

void() make_sparks;
void() misc_sparks_fade1;

// QUAKED misc_flag (1 0 0) (-8 -8 -8) (8 8 8) NOT_ANIMATED BIG
// A hanging banner, gently waving in the wind. Normal dimensions: 64 wide by 144 long.
// Flags: "Not Animated" Banner is not animated. "Big" Banner is twice as big: 128 wide by 288 long.
void() misc_flag = { // [ENTITY]
	precache_model ("progs/rubicon2/flag.mdl");
	setmodel (self, "progs/rubicon2/flag.mdl");
	self.frame = (self.spawnflags & 3);
	makestatic (self);
};

void() sparks_use = { // [FUNCTION]
	if (self.spawnflags & ENT_STARTOFF) self.spawnflags = self.spawnflags - ENT_STARTOFF;
	else self.spawnflags = self.spawnflags + ENT_STARTOFF;
};

void() spark_turnofflight = { // [FUNCTION]
	SUB_UseTargets();
	self.think = make_sparks;
	self.nextthink = time + (random() + 0.5)*self.wait - 0.15;
};

void() make_sparks = { // [FUNCTION]
	local entity spark;
	
	if (self.spawnflags & ENT_STARTOFF) {
		self.nextthink = time + 0.1;
		self.think = make_sparks;
	} else {
		local float i;
		i = -0.25*self.cnt + random()*0.5*self.cnt;
		while (i < self.cnt) {
			make_spark(self.origin, VEC_ORIGIN, TRUE);
			i = i + 1;
		}

		if (self.sounds == 1) sound (self, CHAN_AUTO, "rrp/misc/spark.wav", 1, ATTN_STATIC);
		SUB_UseTargets();
		self.nextthink = time + 0.1 + random() * 0.1;
		self.think = spark_turnofflight;
	}
};

// QUAKED misc_sparks (0 .5 .8) (-8 -8 -8) (8 8 8) ENT_STARTOFF SPARKS_BLUE SPARKS_PALE
// Produces a burst of yellow sparks at random intervals. If targeted, it will toggle between on or off.  If it targets a light, that light will flash allong with each burst of sparks. Note: targeted lights should be set to START_OFF.
// SPARKS_BLUE: sparks are blue in color
// SPARKS_PALE: sparks are pale yellow in color
// Keys:
// "wait" is the average delay between bursts (variance is 1/2 wait). Default is 2. 
// "cnt" is the average number of sparks in a burst (variance is 1/4 cnt). Default is 15.
// "sounds"
// 0)	no sound
// 1)	sparks
void() misc_sparks = { // [ENTITY]
	precache_model ("progs/rrp/spark.mdl");
	precache_sound ("rrp/misc/spark.wav");
	if (!self.movedir) self.movedir = '0 0 -30';
	if (!self.wait) self.wait = 2;
	if (!self.cnt) self.cnt = 15;
	self.use = sparks_use;
	self.nextthink = time + random()*0.1;
	self.think = make_sparks;
};
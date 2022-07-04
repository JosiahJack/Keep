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
// Entity count: 2
// Function count: 9
//
// Implements: Alternate Sparks and Sound Emitters
//
// Description:
// Variants of misc_spark and ambient_custom_sound that are different enough to
// not combine and redirect.  Includes a spark effect function for nailguns.
//=============================================================================

void() spark_spawn;
void() spark_pause;
void() sound_pause;
void() sound_play;

void() spark_touch = { // [FUNCTION]
	local float kill;
	
	if (self.wait == -1) kill = 0.4;
	else kill = 0.1;
			
	if (random() < kill) remove(self); // Remove some sparks on touch
};

void() spark_start = { // [FUNCTION]
	self.use = spark_pause;// next use stops it
	self.nextthink = time +  (random() + self.wait);
};

// Die in liquids
void() spark_think = { // [FUNCTION]
	if (self.attack_finished < time) { remove(self); return; }
	if (pointcontents(self.origin + '0 0 -8') < CONTENT_SOLID) { remove(self); return; }
	
	self.nextthink = time + 0.1;
};

void() spark_pause = { // [FUNCTION]
	// Wait around for next use
	self.nextthink = -1;
	self.use = spark_start;
};

void() spark_spawn = { // [FUNCTION]
	local entity spark;
	local float r;
	
	if (!(self.spawnflags & 2)) {
		r = rint(random() * 3);	// play a random spark sound	
		if (r == 1) sound (self, CHAN_AUTO, "misc/spark1.wav", 1, ATTN_NORM);
		else if (r == 2) sound (self, CHAN_AUTO, "misc/spark2.wav", 1, ATTN_NORM);
		else if (r == 0) sound (self, CHAN_AUTO, "misc/spark3.wav", 1, ATTN_NORM);
		else sound (self, CHAN_AUTO, "misc/spark4.wav", 1, ATTN_NORM);
	}

	spark = spawn();
	setorigin (spark, self.origin);
	spark.solid = SOLID_NOT;
	spark.movetype = MOVETYPE_BOUNCE;
	spark.classname = "spark";
	spark.think1 = SUB_Remove;// So triggers can kill it
	spark.velocity_x = (random() * 200) - 25; // set the spark velocity
	spark.velocity_y = (random() * 200) - 25;
	spark.velocity_z = 0;
	spark.touch = spark_touch;
	spark.attack_finished = time + random()*3; // random lifespan for sparks that aren't removed on touch
	spark.think = spark_think;
	spark.nextthink = time + 0.1;
	setmodel (spark, "progs/spark.spr");
	setsize (spark, VEC_ORIGIN, VEC_ORIGIN);
	self.nextthink = time +  (random() + self.wait);
};

// QUAKED fx_spark (0 .5 .8) (-8 -8 -8) (8 8 8) ? START_ON SILENT
// Throws sparks randomly 360� around the origin in the horizontal axis.
// Can toggle on/off with multiple triggers.
// "wait"			Seed for the frequency of the sparks (0 is pretty quick).
// "targetname"	Can be triggered.
// Spawnflags:
// "1"		Start right away even if triggered
// "2"		Don't make sound.
void() fx_spark = { // [ENTITY]
	precache_model("progs/spark.spr");

	if (self.wait < 0) self.wait = 0; // default frequency to 0
	self.think = spark_spawn;
	
	if (self.targetname != string_null && !(self.spawnflags & 1)) spark_pause();
	else spark_start();
};

// Special effect for the nailgun
void(float ox) spawn_ngspark = { // [FUNCTION]
	local entity spark;

	if (deathmatch || coop || self.waterlevel >= 3) return;

	spark = spawn();
	spark.owner = self;
	spark.solid = SOLID_NOT;// NOTE: SOLID_TRIGGER will make sound in func_water (doesn't matter for real water)
	spark.movetype = MOVETYPE_BOUNCE;
	spark.classname = "ngspark";
	makevectors(self.v_angle);
	spark.velocity = v_forward*60 + v_up * 260 + crandom()*v_right*200 + crandom()*v_up*20;
	spark.angles = vectoangles(spark.velocity);	
	spark.wait = -1; // Quickly kill these.
	spark.touch = spark_touch;
	spark.nextthink = time + random()*1;
	spark.think = SUB_Remove;
	setmodel (spark, "progs/spark.spr");
	setsize (spark, VEC_ORIGIN, VEC_ORIGIN);		
	setorigin (spark, self.origin + v_forward*36 + v_right*ox);
};

void() sound_start = { // [FUNCTION]
	self.use = sound_pause;// next use stops it
	self.think = sound_play;
	self.nextthink = time + 0.1;
}

void() sound_pause = { // [FUNCTION]
	// play the shutoff wav if we got one, then hang around until next use
	if (self.noise1 != string_null) sound (self, CHAN_VOICE, self.noise1, self.volume, self.distance);
	self.nextthink = -1;
	self.use = sound_start;
};

void() sound_play = { // [FUNCTION]
	if (self.state == 0) {// no more repeats - reset & pause
		self.state = self.count;		
		sound_pause();
		return;
	} else sound (self, CHAN_VOICE, self.noise, self.volume, self.distance);

	if (self.count > 0) self.state = self.state - 1; // reduce repititions by 1 if not infinite
	self.nextthink = time + (random()*self.cnt) + self.pausetime; // Set next play time
};

// QUAKED fx_sound (0 .5 .8) (-8 -8 -8) (8 8 8) ? START_ON
// Plays any sound with an optional (different) shutoff sound.
// Can trigger on/off, repeat, play n times, randomize, all sorts of fun stuff...
// "noise"			Path to the sound - example: "misc/null.wav"
// "noise1"		Path to the shutoff sound. Use "misc/null.wav" to abruptly mute "noise" when toggled off.  If "noise1" is empty, "noise" is allowed to finish when paused (or continue if it's a looped WAV).
// "distance"		Sound attenuation (defaults to ATTN_NORM).
// "volume"		Sound volume.
// "count"			Number of times to play the sound each time it's triggered (-1 is infinite loop).
// "pausetime"		Delay in seconds before playing the next loop (omit or set to 0 if "count" is 1)
// "cnt"			Random seed for repeats, this number is multiplied by random() and added to pausetime (0 is no random).
// "targetname"	Can be triggered.
// Spawnflags: "1" Start right away even if triggered
// Although you can use looping WAV files with fx_sound, you shouldn't rely on them looping for ever.
// Quake will stop playing a sound when it can no longer hear it (well, "see it" is more accurate).
// If an fx_sound is playing a looped WAV in this case, it will simply stop playing it. If you want
// a sound to loop, it's best to use a non-looping WAV and set it's paustime to the length of the sound.
// This won't stop Quake from muting the sound when it's nolonger in range, but at least it will start
// up again when it comes back into range (although it starts at the next loop time, so long sounds may
// still act weird).
// If you need a triggered looping sound (that can't be turned off once started) use fx_ambientsound.
void() fx_sound = { // [ENTITY]
	if (self.noise == string_null) self.noise = "drake/misc/secret2.wav";
	precache_sound(self.noise);
	if (self.noise1 != string_null) precache_sound(self.noise1);
	if (self.volume <= 0) self.volume = 1.0; // default volume to one if not specified
	if (self.distance < ATTN_NONE || self.distance > ATTN_STATIC) self.distance = ATTN_NORM; // default attenuation to NORM if out of range
	if (!self.count) self.count = -1; // Set infinite repeat if not specified	
	if (self.pausetime<0) self.pausetime = 0; // Paustime < 0 makes no sense
	self.state = self.count; // "state" holds the current number of repeats before pausing
	if (self.cnt < 0) self.cnt = 0; // Make sure random seed is valid

	// start sound when triggered
	if (self.targetname != string_null && !(self.spawnflags & 1)) self.use = sound_start;
	else {// Start immediately
		self.use = sound_pause;// next use stops it
		self.think = sound_play;
		self.nextthink = time + 1.0; // Quake refuses to play sounds immediately, so there is a one second delay here.
	}
};
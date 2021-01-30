/*
This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by the
Free Software Foundation; either version 2 of the License, or (at your
option) any later version.

This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software Foundation,
Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
*/

/*
	Written by Frank Condello <pox@planetquake.com>
	
	Audio/Visual effect mapping entities, and weapon effects.
*/

// SPARKS ======================================================================

void() spark_spawn;
void() spark_pause;

void() spark_touch =
{
	local float kill;
	
	if (self.wait == -1)// nailgun
		kill = 0.4;
	else
		kill = 0.1;
			
	if (random() < kill) // remove some sparks on touch
		remove(self);
};

void() spark_start =
{
	self.use = spark_pause;// next use stops it
	self.nextthink = time +  (random() + self.wait);
};

// Die in liquids
void() spark_think =
{
	if (self.attack_finished < time) {
		remove(self);
		return;
	}
	
	if (pointcontents(self.origin + '0 0 -8') < CONTENT_SOLID) {
		remove(self);
		return;
	}
	
	self.nextthink = time + 0.1;
};

void() spark_pause =
{
	// Wait around for next use
	self.nextthink = -1;
	self.use = spark_start;
};

void() spark_spawn =
{	
	local entity spark;
	local float r;
	
	if (!(self.spawnflags & 2)) {
		r = rint(random() * 3);	// play a random spark sound	
		if (r == 1)
			sound (self, CHAN_AUTO, "misc/spark1.wav", 1, ATTN_NORM);
		else if (r == 2)
			sound (self, CHAN_AUTO, "misc/spark2.wav", 1, ATTN_NORM);
		else if (r == 0)
			sound (self, CHAN_AUTO, "misc/spark3.wav", 1, ATTN_NORM);
		else
			sound (self, CHAN_AUTO, "misc/spark4.wav", 1, ATTN_NORM);
	}

	spark = spawn ();
	setorigin (spark, self.origin);
	spark.solid = SOLID_NOT;
	spark.movetype = MOVETYPE_BOUNCE;
	spark.classname = "spark";

	spark.think1 = SUB_Remove;// So triggers can kill it
	
	// set the spark velocity
	spark.velocity_x = (random() * 200) - 25;
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

/*QUAKED fx_spark (0 .5 .8) (-8 -8 -8) (8 8 8) ? START_ON SILENT
Throws sparks randomly 360¼ around the origin in the horizontal axis.
Can toggle on/off with multiple triggers.

"wait"			Seed for the frequency of the sparks (0 is pretty quick).
"targetname"	Can be triggered.

Spawnflags:

"1"		Start right away even if triggered
"2"		Don't make sound.

*/
void() fx_spark =
{	
	if (!(self.spawnflags & 2)) {
		precache_sound ("misc/spark1.wav");
		precache_sound ("misc/spark2.wav");
		precache_sound ("misc/spark3.wav");
		precache_sound ("misc/spark4.wav");
	}
	precache_model("progs/spark.spr");

	if (self.wait < 0)
		self.wait = 0; // default frequency to 0
	
	self.think = spark_spawn;
	
	if (self.targetname != string_null && !(self.spawnflags & 1))
		spark_pause();
	else
		spark_start();
};

// Special effect for the nailgun
void(float ox) spawn_ngspark =
{	
	if (deathmatch || coop || self.waterlevel >= 3)
		return;
		
	local entity spark;
	
	spark = spawn ();
	spark.owner = self;
	spark.solid = SOLID_NOT;// NOTE: SOLID_TRIGGER will make sound in func_water (doesn't matter for real water)
	spark.movetype = MOVETYPE_BOUNCE;
	spark.classname = "ngspark";

	makevectors (self.v_angle);

	spark.velocity = v_forward*60 + v_up * 260 + crandom()*v_right*200 + crandom()*v_up*20;

	spark.angles = vectoangles(spark.velocity);	
	spark.wait = -1;// quickly kill these
	
	spark.touch = spark_touch;
	spark.nextthink = time + random()*1;
	spark.think = SUB_Remove;
	setmodel (spark, "progs/spark.spr");
	setsize (spark, VEC_ORIGIN, VEC_ORIGIN);		
	setorigin (spark, self.origin + v_forward*36 + v_right*ox);
};

// CUSTOM SOUNDS ===================================================================

void() sound_pause;
void() sound_play;

void() sound_start =
{
	self.use = sound_pause;// next use stops it
	self.think = sound_play;
	self.nextthink = time + 0.1;
}

void() sound_pause =
{
	// play the shutoff wav if we got one, then hang around until next use
	if (self.noise1 != string_null)
		sound (self, CHAN_VOICE, self.noise1, self.volume, self.distance);
	self.nextthink = -1;
	self.use = sound_start;
};

void() sound_play = 
{
	if (self.state == 0) {// no more repeats - reset & pause
		self.state = self.count;		
		sound_pause();
		return;
	}
	else
		sound (self, CHAN_VOICE, self.noise, self.volume, self.distance);
	
	// reduce repititions by 1 if not infinite
	if (self.count > 0) self.state = self.state - 1;
	
	// Set next play time
	self.nextthink = time + (random()*self.cnt) + self.pausetime;
};

/*QUAKED fx_sound (0 .5 .8) (-8 -8 -8) (8 8 8) ? START_ON
Plays any sound with an optional (different) shutoff sound.
Can trigger on/off, repeat, play n times, randomize, all sorts of fun stuff...

"noise"			Path to the sound - example: "misc/mysound.wav"
"noise1"		Path to the shutoff sound. Use "misc/null.wav" to abruptly mute "noise" when toggled off.
				If "noise1" is empty, "noise" is allowed to finish when paused (or continue if it's a looped WAV).
"distance"		Sound attenuation (defaults to ATTN_NORM).
"volume"		Sound volume.
"count"			Number of times to play the sound each time it's triggered (-1 is infinite loop).
"pausetime"		Delay in seconds before playing the next loop (omit or set to 0 if "count" is 1)
"cnt"			Random seed for repeats, this number is multiplied by random() and added to pausetime (0 is no random).
"targetname"	Can be triggered.

Spawnflags:

"1" 		Start right away even if triggered

NOTES:

Although you can use looping WAV files with fx_sound, you shouldn't rely on them looping for ever.
Quake will stop playing a sound when it can no longer hear it (well, "see it" is more accurate).
If an fx_sound is playing a looped WAV in this case, it will simply stop playing it. If you want
a sound to loop, it's best to use a non-looping WAV and set it's paustime to the length of the sound.
This won't stop Quake from muting the sound when it's nolonger in range, but at least it will start
up again when it comes back into range (although it starts at the next loop time, so long sounds may
still act weird).

If you need a triggered looping sound (that can't be turned off once started) use fx_ambientsound.

BUGS:

For some reason, Quake refuses to play sounds immediately, so there is a one second delay from
worldspawn to when the sound actually starts.

*/
void() fx_sound =
{
	if (self.noise == string_null)
		objerror ("fx_sound without noise!");
	precache_sound (self.noise);
	
	if (self.noise1 != string_null)
		precache_sound (self.noise1);
	
	// default volume to one if not specified
	if(self.volume <= 0)
		self.volume = 1.0;

	// default attenuation to NORM if out of range
	if(self.distance < ATTN_NONE || self.distance > ATTN_STATIC)
		self.distance = ATTN_NORM;
	
	// Set infinite repeat if not specified	
	if (!self.count) self.count = -1;
	
	// Paustime < 0 makes no sense
	if (self.pausetime<0) self.pausetime = 0;
	
	// "state" holds the current number of repeats before pausing
	self.state = self.count;
	
	// Make sure random seed is valid
	if (self.cnt < 0) self.cnt = 0;

	// start sound when triggered
	if (self.targetname != string_null && !(self.spawnflags & 1)) {
		self.use = sound_start;
	}
	else {// Start immediately
		self.use = sound_pause;// next use stops it
		self.think = sound_play;
		self.nextthink = time + 1.0;// FIXME! - WTF?
	}
};

/*
=======================================================================
AMBIENT SOUNDS - BDW
=======================================================================

	QUAKED ambient_sound (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)	

	"classname" "ambient_sound"
	"noise" "path/filename.wav" - file to play as sound
	"volume" "#" - volume of sound (0-1) (default 0.5)
	"distance" "#" - attenuation. 0 is ATTN_NONE, 3 is ATTN_STATIC (default 1)

=======================================================================	
*/

void() ambient_sound =
{
	if (!self.noise)
	{
		objerror("no sound specified");
		return;
	}

	precache_sound (self.noise);

	if (!self.volume) 		// If the volume isn't set
		self.volume = 0.5;  	// then make it usual volume

	ambientsound (self.origin, self.noise, self.volume, self.distance);
};

//void() ambient_squitch1 = { self.noise = "ambience/squitch1.wav"; 	ambient_sound(); };	//creepy squitch
void() ambient_gurgle 	= { self.noise = "ambience/gurgle.wav"; 	ambient_sound(); };	//gurgling water
void() ambient_subaqua 	= { self.noise = "ambience/subaqua.wav"; 	ambient_sound(); };	//underwater
void() ambient_wind1 	= { self.noise = "ambience/wind1.wav"; 		ambient_sound(); };	//soft wind
void() ambient_wind3 	= { self.noise = "ambience/wind3.wav"; 		ambient_sound(); };	//hard wind
void() ambient_cave1 	= { self.noise = "ambience/cave1.wav"; 		ambient_sound(); };	//cave wind + drips


/*
========================

SQUITCH

========================
*/

void() snd_squitch_think =
{
	//local float r, vol;
	//r = random()*5;
	//vol = random()*0.5;

	if (random() < 0.5)
		sound(self, CHAN_VOICE, "1shot/squitch1.wav", self.volume, self.distance);
	else 
		sound(self, CHAN_VOICE, "1shot/squitch2.wav", self.volume, self.distance);

	self.think = snd_squitch_think;
	self.nextthink = time + 8 + random()*4;
};
void() bdw_sound_squitch =
{
	precache_sound("1shot/squitch1.wav");
	precache_sound("1shot/squitch2.wav");
	
	if (!self.volume)
		self.volume = 0.5;
	if (!self.distance)	//shouldn't really be an ATTN_NONE sound
		self.distance = ATTN_NORM;
	
	self.think = snd_squitch_think;
	self.nextthink = time + 1;
};

/*
========================

GHOSTY

========================
*/

void() snd_ghosty_think =
{
	local float r, vol;

	r = random()*5;

	vol = random()*0.5;

	if (r < 1)
		sound(self, CHAN_VOICE, "1shot/ghosty1.wav", vol, self.distance);
	else if (r < 2)
		sound(self, CHAN_VOICE, "1shot/ghosty2.wav", vol, self.distance);
	else if (r < 3)
		sound(self, CHAN_VOICE, "1shot/ghosty3.wav", vol, self.distance);
	else if (r < 4)
		sound(self, CHAN_VOICE, "1shot/ghosty4.wav", vol, self.distance);
	else
		sound(self, CHAN_VOICE, "1shot/ghosty5.wav", vol, self.distance);

	self.think = snd_ghosty_think;
	self.nextthink = time + 7 + random()*30;
};


void() bdw_sound_ghosty =
{
	precache_sound("1shot/ghosty1.wav");
	precache_sound("1shot/ghosty2.wav");
	precache_sound("1shot/ghosty3.wav");
	precache_sound("1shot/ghosty4.wav");
	precache_sound("1shot/ghosty5.wav");

	self.think = snd_ghosty_think;
	self.nextthink = time + 1;
};

/*
========================================================

bdw_sound_triggered

A simple entity that plays a single sound when triggered

========================================================
*/

void() sound_triggered_use =
{
	sound(self, CHAN_VOICE, self.noise, self.volume, self.distance);
	
	if (self.spawnflags & 1)
		self.use = SUB_Null;	//play once
};
	
void() bdw_sound_triggered =
{
	if (!self.noise)
	{
		objerror("no sound specified");
		return;
	}

	precache_sound(self.noise);
	
	if (!self.volume) 
		self.volume = 1; 
		
	self.use = sound_triggered_use;
};

	

//spawns a global ominous sound, use as a triggerfunction...
/*
void() bdw_ominous_sound =
{
	local entity snd;

	snd = spawn();

	sound(snd, CHAN_VOICE, "bdwsound/basss.wav", 1, ATTN_NONE);

	snd.think = SUB_Remove;
	snd.nextthink = time + 0.1;
};
*/

//bdw - old stuff...

//============================================================================
/*QUAKED ambient_suck_wind (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
*/
void() ambient_suck_wind =
{
	precache_sound ("ambience/suck1.wav");
	ambientsound (self.origin, "ambience/suck1.wav", 1, ATTN_STATIC);
};

/*QUAKED ambient_drone (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
*/
void() ambient_drone =
{
	precache_sound ("ambience/drone6.wav");
	ambientsound (self.origin, "ambience/drone6.wav", 0.5, ATTN_STATIC);
};

/*QUAKED ambient_flouro_buzz (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
*/
void() ambient_flouro_buzz =
{
	precache_sound ("ambience/buzz1.wav");
	ambientsound (self.origin, "ambience/buzz1.wav", 1, ATTN_STATIC);
};
/*QUAKED ambient_drip (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
*/
void() ambient_drip =
{
	precache_sound ("ambience/drip1.wav");
	ambientsound (self.origin, "ambience/drip1.wav", 0.5, ATTN_STATIC);
};
/*QUAKED ambient_comp_hum (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
*/
void() ambient_comp_hum =
{
	precache_sound ("ambience/comp1.wav");
	ambientsound (self.origin, "ambience/comp1.wav", 1, ATTN_STATIC);
};
/*QUAKED ambient_thunder (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
*/
void() ambient_thunder =
{
	precache_sound ("ambience/thunder1.wav");
	ambientsound (self.origin, "ambience/thunder1.wav", 0.5, ATTN_STATIC);
};
/*QUAKED ambient_light_buzz (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
*/
void() ambient_light_buzz =
{
	precache_sound ("ambience/fl_hum1.wav");
	ambientsound (self.origin, "ambience/fl_hum1.wav", 0.5, ATTN_STATIC);
};
/*QUAKED ambient_swamp1 (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
*/
void() ambient_swamp1 =
{
	precache_sound ("ambience/swamp1.wav");
	ambientsound (self.origin, "ambience/swamp1.wav", 0.5, ATTN_STATIC);
};
/*QUAKED ambient_swamp2 (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
*/
void() ambient_swamp2 =
{
	precache_sound ("ambience/swamp2.wav");
	ambientsound (self.origin, "ambience/swamp2.wav", 0.5, ATTN_STATIC);
};
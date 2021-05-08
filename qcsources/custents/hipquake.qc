/* Earthquake QuickC program
   By Jim Dose'  9/13/96
   Copyright (c)1996 Hipnotic Interactive, Inc.
   All rights reserved.
   Do not distribute.
*/
float Hearthquake;
float Hquakeactive;

void() StopEarthQuake =
{
	Hearthquake = 0;
};

void( float value ) EarthQuakeTime =
{
	value = value + time;
	if ( value > Hearthquake )
		Hearthquake = value;
};

void() earthquake_postthink =
{
	if ( Hearthquake > time )
	{
		if (Hquakeactive == 0)
		{
			sound (self, CHAN_VOICE, "misc/quake.wav", 1, ATTN_NONE);
			Hquakeactive = 1;
		}
		if ( self.flags & FL_ONGROUND )
			self.velocity = self.velocity + (random() * '0 0 150');
	}
	else
      {
		if (Hquakeactive == 1)
		{
			sound (self, CHAN_VOICE, "misc/quakeend.wav", 1, ATTN_NONE);
			Hquakeactive = 0;
		}
	}
};

void() earthquake_use =
{
	EarthQuakeTime( self.dmg );
};

/*QUAKED func_earthquake (0 0 0.5) (0 0 0) (32 32 32)
Causes an earthquake. Uses vertical movement. Triggers targets.

"dmg" is the duration of the earthquake.  Default is 0.8 seconds.
*/

void() func_earthquake =
{
	Hquakeactive = 0;
	precache_sound("misc/quake.wav");
	precache_sound("misc/quakeend.wav");
	self.classname = "earthquake";
	self.use = earthquake_use;
	self.think = SUB_Null;
	if ( !self.dmg )
		self.dmg = 0.8;
};
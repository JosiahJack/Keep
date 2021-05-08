/* Miscelanneous QuickC program
   Copyright (c)1996 Hipnotic Interactive, Inc.
   All rights reserved.
   Do not distribute.
*/

void() play_sound_use =
{
	if (self.spawnflags & 1)
	{
	      if (self.state == 0)
		{
			self.state = 1;
			sound (self, self.impulse, self.noise, self.volume, self.speed);
		}
		else
		{
			self.state = 0;
			sound (self, self.impulse, "misc/null.wav", self.volume, self.speed);
		}
	}
	else
      sound (self, self.impulse, self.noise, self.volume, self.speed);
};

void() PlaySoundThink =
{
	local float t;

	t = self.wait * random();
	if (t < self.delay)
		t = self.delay;
	self.nextthink = time + t;
	play_sound_use();
};

/*QUAKED play_sound_triggered (0.3 0.1 0.6) (-8 -8 -8) (8 8 8) toggle
play a sound when it is used
"toggle" determines whether sound should be stopped when triggered again
"volume" how loud (1 default full volume)
"noise" sound to play
"impulse" channel on which to play sound (0-7) (0 automatic is default)
"speed" attenuation factor
   -1 - no attenuation
    1 - normal
    2 - idle
    3 - static
*/
void() play_sound_triggered =
{
	precache_sound (self.noise);
	precache_sound ("misc/null.wav");
	if (self.volume == 0)
		self.volume = 1;
	if (self.speed == 0)
		self.speed = 1;
	if (self.speed == -1)
		self.speed = 0;
	if (self.spawnflags & 1)
		if (self.impulse == 0)
			self.impulse = 7;
	self.use = play_sound_use;
};

/*QUAKED play_sound (0.3 0.1 0.6) (-8 -8 -8) (8 8 8)
play a sound on a periodic basis
"volume" how loud (1 default full volume)
"noise" sound to play
"wait" random time between sounds (default 20)
"delay" minimum delay between sounds (default 2)
"impulse" channel on which to play sound (0-7) (0 automatic is default)
"speed" attenuation factor
   -1 - no attenuation
    1 - normal
    2 - idle
    3 - static
*/
void() play_sound =
{
	local float t;

	play_sound_triggered();
	if (self.wait == 0)
		self.wait = 20;
	if (self.delay == 0)
		self.delay = 2;
	self.think = PlaySoundThink;
	t = self.wait * random();
	if (t < self.delay)
		t = self.delay;
	self.nextthink = time + t;
};

/*QUAKED random_thunder (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
"wait" random time between strikes (default 20)
"delay" minimum delay between strikes (default 2)
"volume" how loud (1 default full volume)
"speed" attenuation factor
   -1 - no attenuation
    1 - normal
    2 - idle
    3 - static
*/
void() random_thunder =
{
	self.noise = "ambience/thunder1.wav";
	play_sound();
	self.impulse = 6;
};

/*QUAKED random_thunder_triggered (0.3 0.1 0.6) (-10 -10 -8) (10 10 8) toggle
"toggle" determines whether sound should be stopped when triggered again
"volume" how loud (1 default full volume)
"speed" attenuation factor
   -1 - no attenuation
    1 - normal
    2 - idle
    3 - static
*/
void() random_thunder_triggered =
{
	self.noise = "ambience/thunder1.wav";
	play_sound_triggered();
	self.impulse = 6;
};

/*QUAKED info_command (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
 Stuffs a command into the console to allow map designers
 to set server variables.

 "message" is the command to send to the console.
*/

void() info_command =
{
	if ( self.message )
		localcmd( self.message );
};

void() effect_teleport_use =
{
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_TELEPORT);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);

	sound (self, CHAN_VOICE, "misc/r_tele1.wav", 1, ATTN_NORM);
};

/*QUAKED effect_teleport (0.3 0.1 0.6) (-8 -8 -8) (8 8 8)
 Create a teleport effect when triggered
*/

void() effect_teleport =
{
	precache_sound("misc/r_tele1.wav");
	self.use = effect_teleport_use;
};

/*QUAKED wallsprite (0 1 0) (-8 -8 -8) (8 8 8)
Places a sprite on a wall.  Angles should be opposite of face.

"model" sprite to place on wall.  Default is "progs/s_blood1.spr".
*/
void() wallsprite =
{
	if ( !self.model )
	      self.model = "progs/s_blood1.spr";

	precache_model( self.model );
	setmodel (self, self.model );

	// QuakeEd doesn't save up and down angles properly.
	if (self.angles == '0 -1 0')
		self.angles = '-90 0 0';
	else if (self.angles == '0 -2 0')
		self.angles = '90 0 0';

	// Pull the sprite away from the wall slightly to
	// get rid of z sort errors.
	makevectors(self.angles);
	setorigin( self, self.origin - ( v_forward * 0.2 ) );
	makestatic (self);
};

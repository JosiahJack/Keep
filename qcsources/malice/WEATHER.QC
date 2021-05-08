/*
This source code has been reconstructed from PROGS.DAT and may not be
identical to the original source code.

Copyright (C) 1997 Epochalypse. Malice is a trade name of Quantum Axcess.
*/

void () rain_splash =
{
	local float x;

	if ((other.classname == "player") && (other.burning == TRUE))
	{
		other.burning = FALSE;
		other.extinguished = TRUE;
		other.effects = other.effects - (other.effects & EF_DIMLIGHT);
	}
	x = 35 + (random () * 10);
	particle (self.origin + '0 0 -15', VEC_ORIGIN, x, 10);
	remove (self);
};


void () rain_fall =
{
	local entity rain;

	rain = spawn ();
	rain.owner = self;
	rain.movetype = MOVETYPE_FLY;
	rain.solid = SOLID_TRIGGER;
	setmodel (rain, "progs/rain.mdl");
	setsize (rain, '0 0 -20', '0 0 -10');
	rain.velocity_z = -800;
	rain.touch = rain_splash;
	rain.nextthink = time + 1.00;
	rain.think = SUB_Remove;
	rain.origin_x = self.absmin_x + (random () * self.size_x);
	rain.origin_y = self.absmin_y + (random () * self.size_y);
	rain.origin_z = self.absmin_z + (random () * self.size_z);
};


void () makerain =
{
	local float temp;

	temp = self.health / 20;
	while (temp >= 0)
	{
		rain_fall ();
		temp = temp - 1;
	}
	self.nextthink = time + 0.07;
	self.think = makerain;
};


void () rain =
{
	precache_model ("progs/rain.mdl");
	setsize (self, VEC_ORIGIN, VEC_ORIGIN);
	setmodel (self, self.model);
	self.model = string_null;
	self.nextthink = time + 0.5;
	self.think = makerain;
	precache_sound ("ambience/stormy1.wav");
	ambientsound (self.origin, "ambience/stormy1.wav", 1.00, ATTN_NORM);
};

void () splash1 = [ 0, splash2 ]
{
};

void () splash2 = [ 1, splash3 ]
{
};

void () splash3 = [ 2, splash4 ]
{
};

void () splash4 = [ 3, splash5 ]
{
};

void () splash5 = [ 4, splash6 ]
{
};

void () splash6 = [ 5, SUB_Remove ]
{
};


void (float number,entity where) WaterSplash =
{
	local entity splash;
	local float k;

	while (k < number)
	{
		splash = spawn ();
		splash.movetype = MOVETYPE_NONE;
		splash.solid = SOLID_NOT;
		setmodel (splash, "progs/s_splash.spr");
		setorigin (splash, where.origin + (random () * '30 30 0'));
		splash.nextthink = time;
		splash.think = splash1;
		k = k + 1;
	}
};


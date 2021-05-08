/*
This source code has been reconstructed from PROGS.DAT and may not be
identical to the original source code.

Copyright (C) 1997 Epochalypse. Malice is a trade name of Quantum Axcess.
*/

float MAX_DROPS = 12;
void () streak;

void () WIPE_UP_BLOOD =
{
	num_blooddrops = num_blooddrops - 1;
	remove (self);
};


void () bd =
{
	if (self.aqua_sound)
	{
		self.think = bd;
		self.nextthink = time + 0.8;
		self.frame = self.frame + 1;
		if (self.frame > 6)
			WIPE_UP_BLOOD ();
	}
	else
	{
		self.think = bd;
		self.nextthink = time + 0.2;
		self.frame = self.frame - 1;
		if (self.frame <= self.warp_factor)
		{
			self.aqua_sound = TRUE;
			self.nextthink = time + 1.00;
		}
	}
};


void () blooddrops =
{
	local vector spot;
	local entity drop;

	if (random () > ((0.8 * (MAX_DROPS - num_blooddrops)) / MAX_DROPS))
		return;
	drop = spawn ();
	num_blooddrops = (num_blooddrops + 1);
	traceline (self.origin, '0 0 -4096', TRUE, self);
	spot_x = trace_endpos_x + (crandom () * 6);
	spot_y = trace_endpos_y + (crandom () * 6);
	spot_z = trace_endpos_z;
	setorigin (drop, spot);
	drop.angles = vectoangles (trace_plane_normal);
	drop.angles_x = drop.angles_x - 90;
	setmodel (drop, "progs/bdrop.mdl");
	setsize (drop, VEC_ORIGIN, VEC_ORIGIN);
	drop.solid = SOLID_NOT;
	drop.movetype = MOVETYPE_BOUNCE;
	drop.owner = self;
	drop.frame = 6;
	drop.aqua_sound = 0;
	drop.warp_factor = floor (random () * 6.99);
	drop.think = bd;
	drop.nextthink = time;
};


void () wallsplat =
{
	local vector dir;
	local vector direction;
	local float bcount;
	local entity drop;

	if (random () < 0.2)
	{
		streak ();
		return;
	}
	dir = (self.origin + '0 0 40') - (damage_attacker.origin + '0 0 20');
	makevectors (dir);
	bcount = floor ((2 * (MAX_DROPS - num_blooddrops)) / 3);
	while (bcount > 0)
	{
		if (num_blooddrops >= 12)
			return;
		direction = dir + ((crandom () * 30) * v_right) + ((crandom () * 30) * v_up);
		traceline (self.origin, direction * 2048, TRUE, self);
		drop = spawn ();
		num_blooddrops = num_blooddrops + 1;
		setorigin (drop, trace_endpos + trace_plane_normal);
		setmodel (drop, "progs/bdrop.mdl");
		setsize (drop, VEC_ORIGIN, VEC_ORIGIN);
		drop.solid = SOLID_NOT;
		drop.movetype = MOVETYPE_NONE;
		drop.owner = self;
		drop.frame = floor (random () * 6.99);
		drop.angles = vectoangles (trace_plane_normal);
		drop.angles_x = drop.angles_x - 90;
		drop.think = bd;
		drop.aqua_sound = TRUE;
		drop.nextthink = time + 1.00 + random ();
		bcount = bcount - 1;
	}
};


void () streak =
{
	local vector dir;
	local vector direction;
	local vector spiral;
	local vector UP;
	local vector RIGHT;
	local float bcount;
	local float tightness;
	local float hypo;
	local entity drop;

	tightness = (30 + (crandom () * 5));
	if ((random () < 0.5))
		tightness = (0 - tightness);
	hypo = (35 + (crandom () * 5));
	dir = ((self.origin + '0 0 40') - (damage_attacker.origin + '0 0 20'));
	makevectors (dir);
	UP = v_up;
	RIGHT = v_right;
	bcount = 0;
	while ((bcount < 7))
	{
		if ((num_blooddrops >= 12))
			return;
		makevectors (spiral);
		spiral_y = (spiral_y + tightness);
		direction = ((dir + ((hypo * RIGHT) * v_forward_x)) + ((hypo * UP) * v_forward_y));
		traceline (self.origin, (direction * IT_CELLS), TRUE, self);
		drop = spawn ();
		num_blooddrops = (num_blooddrops + 1);
		setorigin (drop, (trace_endpos + trace_plane_normal));
		setmodel (drop, "progs/bdrop.mdl");
		setsize (drop, VEC_ORIGIN, VEC_ORIGIN);
		drop.solid = SOLID_NOT;
		drop.movetype = MOVETYPE_NONE;
		drop.owner = self;
		drop.frame = bcount;
		drop.angles = vectoangles (trace_plane_normal);
		drop.angles_x = (drop.angles_x - 90);
		drop.think = bd;
		drop.aqua_sound = TRUE;
		drop.nextthink = ((time + 1.00) + random ());
		bcount = (bcount + 1);
	}
};


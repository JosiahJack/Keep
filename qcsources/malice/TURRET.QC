/*
This source code has been reconstructed from PROGS.DAT and may not be
identical to the original source code.

Copyright (C) 1997 Epochalypse. Malice is a trade name of Quantum Axcess.
*/

void () round =
{
	local vector scoped;
	local vector dir;

	dir = normalize (self.enemy.origin - self.origin);
	self.angles = vectoangles (dir);
	self.effects = self.effects | EF_MUZZLEFLASH;
	FireBullets (1, dir, '0.1 0.1 0');
	sound (self, CHAN_WEAPON, "misc/turret.wav", 1.00, ATTN_NORM);
};

void () burst1 = [ 0, burst2 ]
{
	round ();
};

void () burst2 = [ 1, burst3 ]
{
	round ();
};

void () burst3 = [ 2, burst4 ]
{
	round ();
};

void () burst4 = [ 3, burst5 ]
{
	round ();
};

void () burst5 = [ 4, burst6 ]
{
	round ();
};

void () burst6 = [ 5, trace_target ]
{
	round ();
};


void () trace_target =
{
	local entity being;
	local vector scoped;
	local vector dir;

	being = findradius (self.origin, 600);
	while (being)
	{
		if (((being.classname == "player") && visible (being)))
		{
			scoped = vectoangles (being.origin - self.origin);
			dir = normalize (being.origin - self.origin);
			self.enemy = being;
			if (random () < 0.06)
				burst1 ();
			self.angles = scoped;
		}
		being = being.chain;
	}
	self.nextthink = time + 0.01;
};


void () dead_tur =
{
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);
	sound (self, CHAN_VOICE, "weapons/fuelexp.wav", 1.00, ATTN_NORM);
	BecomeExplosion ();
};


void () monster_turret =
{
	if (deathmatch)
		remove (self);
	precache_model ("progs/turret.mdl");
	precache_sound ("misc/turret.wav");
	precache_sound ("weapons/fuelexp.wav");
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_BBOX;
	self.nextthink = time + 1.00;
	self.classname = "monster_turret";
	self.takedamage = DAMAGE_AIM;
	self.think = trace_target;
	setmodel (self, "progs/turret.mdl");
	setsize (self, '-20 -20 -20', '20 20 20');
	self.health = 50;
	dealwithskill ();
	self.th_die = dead_tur;
	droptofloor (0, 0);
};


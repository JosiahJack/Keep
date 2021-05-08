/*
This source code has been reconstructed from PROGS.DAT and may not be
identical to the original source code.

Copyright (C) 1997 Epochalypse. Malice is a trade name of Quantum Axcess.
*/

void () button_return;

void () button_wait =
{
	self.state = STATE_TOP;
	self.nextthink = self.ltime + self.wait;
	self.think = button_return;
	activator = self.enemy;
	SUB_UseTargets ();
	self.frame = 1;
};


void () button_done =
{
	self.state = STATE_BOTTOM;
};


void () button_return =
{
	self.state = STATE_DOWN;
	SUB_CalcMove (self.pos1, self.speed, button_done);
	self.frame = 0;
	if (self.health)
		self.takedamage = DAMAGE_YES;
};


void () button_blocked =
{
};


void () button_fire =
{
	if ((self.state == STATE_UP) || (self.state == STATE_TOP))
		return;
	sound (self, CHAN_VOICE, self.noise, 1.00, ATTN_NORM);
	self.state = STATE_UP;
	SUB_CalcMove (self.pos2, self.speed, button_wait);
};


void () button_use =
{
	self.enemy = activator;
	button_fire ();
};


void () button_touch =
{
	if ((other.classname != "player") && (other.classname != "cbot"))
		return;
	if (other.probe_active == TRUE)
		return;
	self.enemy = other;
	button_fire ();
};


void () button_killed =
{
	self.enemy = damage_attacker;
	self.health = self.max_health;
	self.takedamage = DAMAGE_NO;
	button_fire ();
};


void () func_button =
{
	local float gtemp;
	local float ftemp;

	if ((self.sounds == 0))
	{
		precache_sound ("buttons/airbut1.wav");
		self.noise = "buttons/airbut1.wav";
	}
	if ((self.sounds == 1))
	{
		precache_sound ("buttons/switch21.wav");
		self.noise = "buttons/switch21.wav";
	}
	if ((self.sounds == 2))
	{
		precache_sound ("buttons/switch02.wav");
		self.noise = "buttons/switch02.wav";
	}
	if ((self.sounds == 3))
	{
		precache_sound ("buttons/switch04.wav");
		self.noise = "buttons/switch04.wav";
	}
	SetMovedir ();
	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_PUSH;
	setmodel (self, self.model);
	self.blocked = button_blocked;
	self.use = button_use;
	if (self.health)
	{
		self.max_health = self.health;
		self.th_die = button_killed;
		self.takedamage = DAMAGE_YES;
	}
	else
		self.touch = button_touch;
	if (!self.speed)
		self.speed = 40;
	if (!self.wait)
		self.wait = 1.00;
	if (!self.lip)
		self.lip = DOOR_DONT_LINK;
	self.state = STATE_BOTTOM;
	self.pos1 = self.origin;
	self.pos2 = self.pos1 + (self.movedir * (fabs ((self.movedir * self.size)) - self.lip));
};


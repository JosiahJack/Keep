void () monster_hanger;
float ATTN_PROBE    = 0.5;
float PROBE_VOLUME    = 0.5;
void () probe_pulsetouch;

void (float ofs,float turn) Probe_laser_fire =
{
	local vector src;
	local vector vec;
	local vector targ;
	local vector ang;
	local entity missile;
	local float dist;

	ang = self.angles;
	ang_y = (ang_y + self.fixangle);
	if ((turn == 1))
		ang_y = (ang_y + 165);
	else
	{
		if ((turn == 2))
			ang_y = (ang_y - 165);
	}
	makevectors (ang);
	src = (((self.origin + '0 0 -10') + (v_right * ofs)) + v_forward);
	targ = (self.enemy.origin + self.enemy.view_ofs);
	if ((skill != 0))
	{
		dist = vlen ((targ - src));
		targ = (targ + (self.enemy.velocity * (dist / 1000)));
	}
	vec = (targ - src);
	vec = normalize (vec);
	dist = (vec * v_forward);
	if ((dist < self.worldtype))
		vec = v_forward;
	self.effects = (self.effects | EF_MUZZLEFLASH);
	sound (self, CHAN_WEAPON, "probe/shoot.wav", 1.00, ATTN_NORM);
	self.punchangle_x = -2;
	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	missile.classname = "missile";
	missile.velocity = (vec * 800);
	missile.angles = vectoangles (vec);
	missile.touch = probe_pulsetouch;
	missile.nextthink = (time + 5.00);
	missile.think = SUB_Remove;
	setmodel (missile, "progs/laser.mdl");
	setsize (missile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin (missile, src);
};


void () probe_pulsetouch =
{
	local vector org;

	if ((other == self.owner))
		return;
	if ((pointcontents (self.origin) == CONTENT_SKY))
	{
		remove (self);
		return;
	}
	org = (self.origin - (8 * normalize (self.velocity)));
	if (other.health)
	{
		SpawnBlood (org, (self.velocity * 0.2), 15, other);
		T_Damage (other, self, self.owner, 12);
	}
	else
	{
		sound (self, CHAN_WEAPON, "enforcer/enfstop.wav", 1.00, ATTN_NORM);
		self.origin = (self.origin - (8 * normalize (self.velocity)));
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_GUNSHOT);
		WriteCoord (MSG_BROADCAST, self.origin_x);
		WriteCoord (MSG_BROADCAST, self.origin_y);
		WriteCoord (MSG_BROADCAST, self.origin_z);
	}
	remove (self);
};


void (float angdelta,float delta) probe_turn =
{
	if ((fabs (angdelta) < 10))
		self.fixangle = delta;
	else
	{
		if ((angdelta > 5))
			self.fixangle = (self.fixangle + 9);
		else
		{
			if ((angdelta < -5))
				self.fixangle = (self.fixangle - 9);
			else
				self.fixangle = delta;
		}
	}
};


void () probe_think =
{
	local float delta;
	local float angdelta;

	
	local float r;

	setorigin (self.trigger_field, self.origin);
	self.trigger_field.angles = self.angles;
	self.trigger_field.frame = self.frame;
	self.trigger_field.angles_y = (self.trigger_field.angles_y + self.fixangle);
	enemy_yaw = vectoyaw ((self.enemy.origin - self.origin));
	self.ideal_yaw = enemy_yaw;
	delta = (self.ideal_yaw - self.angles_y);
	self.cnt = 0;
	if ((delta > 180))
		delta = (delta - 360);
	if ((delta < -180))
		delta = (delta + 360);
	if ((fabs (delta) > 90))
	{
		delta = 0;
		self.cnt = 1;
	}
	angdelta = (delta - self.fixangle);
	probe_turn (angdelta, delta);
	if ((self.health < 0))
		return;
	if ((time > self.super_time))
	{
		self.super_time = (time + 3.00);
		if ((random () < 0.5))
		{
			r = random ();
			if ((r < 0.25))
				sound (self, CHAN_VOICE, "probe/idle1.wav", 1.00, ATTN_PROBE);
			else
			{
				if ((r < 0.5))
					sound (self, CHAN_VOICE, "probe/idle2.wav", 1.00, ATTN_PROBE);
				else
				{
					if ((r < 0.75))
						sound (self, CHAN_VOICE, "probe/idle3.wav", 1.00, ATTN_PROBE);
					else
						sound (self, CHAN_VOICE, "probe/idle4.wav", 1.00, ATTN_PROBE);
				}
			}
		}
	}
};


void () probe_walkthink =
{
	local float delta;
	local float angdelta;
	local entity client;
	local float r;

	setorigin (self.trigger_field, self.origin);
	self.trigger_field.angles = self.angles;
	self.trigger_field.frame = self.frame;
	self.trigger_field.angles_y = (self.trigger_field.angles_y + self.fixangle);
	ChangeYaw ();
	delta = 0;
	self.cnt = 0;
	if ((delta > 180))
		delta = (delta - 360);
	if ((delta < -180))
		delta = (delta + 360);
	if ((fabs (delta) > 90))
	{
		delta = 0;
		self.cnt = 1;
	}
	angdelta = (delta - self.fixangle);
	probe_turn (angdelta, delta);
	if ((self.health < 0))
		return;
	if ((time > self.super_time))
	{
		self.super_time = (time + 3.00);
		if ((random () < 0.5))
		{
			r = random ();
			if ((r < 0.25))
				sound (self, CHAN_VOICE, "probe/idle1.wav", 1.00, ATTN_PROBE);
			else
			{
				if ((r < 0.5))
					sound (self, CHAN_VOICE, "probe/idle2.wav", 1.00, ATTN_PROBE);
				else
				{
					if ((r < 0.75))
						sound (self, CHAN_VOICE, "probe/idle3.wav", 1.00, ATTN_PROBE);
					else
						sound (self, CHAN_VOICE, "probe/idle4.wav", 1.00, ATTN_PROBE);
				}
			}
		}
	}
	client = checkclient ();
	if (!client)
		return;
	if (visible (client))
	{
		self.enemy = client;
		FoundTarget ();
	}
};

void () probe_stand_attack;
void () probe_stand1 = [ 0, probe_stand2 ]
{
	ai_stand ();
	probe_think ();
	self.nextthink = (time + 0.1);
};

void () probe_stand2 = [ 1, probe_stand3 ]
{
	probe_think ();
	self.nextthink = (time + 0.1);
};

void () probe_stand3 = [ 2, probe_stand4 ]
{
	probe_think ();
	self.nextthink = (time + 0.1);
};

void () probe_stand4 = [ 3, probe_stand5 ]
{
	probe_think ();
	self.nextthink = (time + 0.1);
};

void () probe_stand5 = [ 4, probe_stand6 ]
{
	ai_stand ();
	probe_think ();
	self.nextthink = (time + 0.1);
};

void () probe_stand6 = [ 5, probe_stand7 ]
{
	probe_think ();
	self.nextthink = (time + 0.1);
};

void () probe_stand7 = [ 6, probe_stand8 ]
{
	probe_think ();
	self.nextthink = (time + 0.1);
};

void () probe_stand8 = [ 7, probe_stand9 ]
{
	probe_think ();
	self.nextthink = (time + 0.1);
};

void () probe_stand9 = [ 8, probe_stand10 ]
{
	probe_think ();
	self.nextthink = (time + 0.1);
};

void () probe_stand10 = [ 9, probe_stand11 ]
{
	ai_stand ();
	probe_think ();
	self.nextthink = (time + 0.1);
};

void () probe_stand11 = [ 10, probe_stand12 ]
{
	probe_think ();
	self.nextthink = (time + 0.1);
};

void () probe_stand12 = [ 11, probe_stand13 ]
{
	probe_think ();
	self.nextthink = (time + 0.1);
};

void () probe_stand13 = [ 12, probe_stand1 ]
{
	ai_stand ();
	probe_think ();
	self.nextthink = (time + 0.1);
};

void () probe_walk1 = [ 0, probe_walk2 ]
{
	sound (self, CHAN_MALICE2, "probe/servo.wav", PROBE_VOLUME, ATTN_PROBE);
	movetogoal (10);
	probe_walkthink ();
};

void () probe_walk2 = [ 1, probe_walk3 ]
{
	movetogoal (10);
	probe_walkthink ();
};

void () probe_walk3 = [ 2, probe_walk4 ]
{
	sound (self, CHAN_MALICE, "probe/footfall.wav", 1.00, ATTN_PROBE);
	movetogoal (10);
	probe_walkthink ();
};

void () probe_walk4 = [ 3, probe_walk5 ]
{
	movetogoal (10);
	probe_walkthink ();
};

void () probe_walk5 = [ 4, probe_walk6 ]
{
	sound (self, CHAN_MALICE2, "probe/servo.wav", 1.00, ATTN_PROBE);
	movetogoal (10);
	probe_walkthink ();
};

void () probe_walk6 = [ 5, probe_walk7 ]
{
	movetogoal (10);
	probe_walkthink ();
};

void () probe_walk7 = [ 6, probe_walk8 ]
{
	sound (self, CHAN_MALICE, "probe/footfall.wav", 1.00, ATTN_PROBE);
	movetogoal (10);
	probe_walkthink ();
};

void () probe_walk8 = [ 7, probe_walk9 ]
{
	movetogoal (10);
	probe_walkthink ();
};

void () probe_walk9 = [ 8, probe_walk10 ]
{
	sound (self, CHAN_MALICE2, "probe/servo.wav", PROBE_VOLUME, ATTN_PROBE);
	movetogoal (10);
	probe_walkthink ();
};

void () probe_walk10 = [ 9, probe_walk11 ]
{
	movetogoal (10);
	probe_walkthink ();
};

void () probe_walk11 = [ 10, probe_walk12 ]
{
	sound (self, CHAN_MALICE, "probe/footfall.wav", 1.00, ATTN_PROBE);
	movetogoal (10);
	probe_walkthink ();
};

void () probe_walk12 = [ 11, probe_walk1 ]
{
	movetogoal (10);
	probe_walkthink ();
};

void () probe_walk13 = [ 12, probe_walk1 ]
{
	movetogoal (10);
	probe_walkthink ();
};

void () probe_run1 = [ 0, probe_run2 ]
{
	sound (self, CHAN_MALICE2, "probe/servo.wav", 1.00, ATTN_PROBE);
	ChangeYaw ();
	RUN_STRAIGHT = TRUE;
	ai_run (10);
	probe_think ();
};

void () probe_run2 = [ 1, probe_run3 ]
{
	ChangeYaw ();
	RUN_STRAIGHT = TRUE;
	ai_run (10);
	probe_think ();
};

void () probe_run3 = [ 2, probe_run4 ]
{
	sound (self, CHAN_MALICE, "probe/footfall.wav", PROBE_VOLUME, ATTN_PROBE);
	ChangeYaw ();
	RUN_STRAIGHT = TRUE;
	ai_run (10);
	probe_think ();
};

void () probe_run4 = [ 3, probe_run5 ]
{
	ChangeYaw ();
	RUN_STRAIGHT = TRUE;
	ai_run (10);
	probe_think ();
};

void () probe_run5 = [ 4, probe_run6 ]
{
	sound (self, CHAN_MALICE2, "probe/servo.wav", 1.00, ATTN_PROBE);
	ChangeYaw ();
	RUN_STRAIGHT = TRUE;
	ai_run (10);
	probe_think ();
};

void () probe_run6 = [ 5, probe_run7 ]
{
	ChangeYaw ();
	RUN_STRAIGHT = TRUE;
	ai_run (10);
	probe_think ();
};

void () probe_run7 = [ 6, probe_run8 ]
{
	sound (self, CHAN_MALICE, "probe/footfall.wav", 1.00, ATTN_PROBE);
	ChangeYaw ();
	RUN_STRAIGHT = TRUE;
	ai_run (10);
	probe_think ();
};

void () probe_run8 = [ 7, probe_run9 ]
{
	ChangeYaw ();
	RUN_STRAIGHT = TRUE;
	ai_run (10);
	probe_think ();
};

void () probe_run9 = [ 8, probe_run10 ]
{
	sound (self, CHAN_MALICE2, "probe/servo.wav", PROBE_VOLUME, ATTN_PROBE);
	ChangeYaw ();
	RUN_STRAIGHT = TRUE;
	ai_run (10);
	probe_think ();
};

void () probe_run10 = [ 9, probe_run11 ]
{
	ChangeYaw ();
	RUN_STRAIGHT = TRUE;
	ai_run (10);
	probe_think ();
};

void () probe_run11 = [ 10, probe_run12 ]
{
	sound (self, CHAN_MALICE, "probe/footfall.wav", 1.00, ATTN_PROBE);
	ChangeYaw ();
	RUN_STRAIGHT = TRUE;
	ai_run (10);
	probe_think ();
};

void () probe_run12 = [ 11, probe_run13 ]
{
	ChangeYaw ();
	RUN_STRAIGHT = TRUE;
	ai_run (10);
	probe_think ();
};

void () probe_run13 = [ 12, probe_run1 ]
{
	local float delta;

	ChangeYaw ();
	RUN_STRAIGHT = TRUE;
	ai_run (10);
	probe_think ();
	if (((self.cnt == 1) && (time > self.attack_finished)))
	{
		delta = (self.ideal_yaw - self.angles_y);
		if ((delta > 180))
			delta = (delta - 360);
		if ((delta < -180))
			delta = (delta + 360);
		return;
	}
	if ((self.lefty == 1))
	{
		self.lefty = 0;
		self.think = self.th_missile;
	}
};

void () probe_watk1 = [ 13, probe_watk2 ]
{
	ChangeYaw ();
	walkmove (self.angles_y, 14);
	probe_think ();
};

void () probe_watk2 = [ 14, probe_watk3 ]
{
	sound (self, CHAN_MALICE2, "probe/servo.wav", PROBE_VOLUME, ATTN_PROBE);
	ChangeYaw ();
	walkmove (self.angles_y, 14);
	probe_think ();
	Probe_laser_fire (-30, 0);
};

void () probe_watk3 = [ 15, probe_watk4 ]
{
	ChangeYaw ();
	walkmove (self.angles_y, 14);
	probe_think ();
};

void () probe_watk4 = [ 16, probe_watk5 ]
{
	sound (self, CHAN_MALICE, "probe/footfall.wav", 1.00, ATTN_PROBE);
	ChangeYaw ();
	walkmove (self.angles_y, 14);
	probe_think ();
};

void () probe_watk5 = [ 17, probe_watk6 ]
{
	ChangeYaw ();
	walkmove (self.angles_y, 14);
	probe_think ();
	Probe_laser_fire (30, 0);
};

void () probe_watk6 = [ 18, probe_watk7 ]
{
	ChangeYaw ();
	walkmove (self.angles_y, 14);
	probe_think ();
};

void () probe_watk7 = [ 19, probe_watk8 ]
{
	ChangeYaw ();
	walkmove (self.angles_y, 14);
	probe_think ();
};

void () probe_watk8 = [ 20, probe_watk9 ]
{
	ChangeYaw ();
	walkmove (self.angles_y, 14);
	probe_think ();
};

void () probe_watk9 = [ 21, probe_watk10 ]
{
	ChangeYaw ();
	walkmove (self.angles_y, 14);
	probe_think ();
};

void () probe_watk10 = [ 22, probe_run1 ]
{
	ChangeYaw ();
	walkmove (self.angles_y, 14);
	probe_think ();
	SUB_AttackFinished (1.00);
};

void () probe_plant1 = [ 0, probe_plant1 ]
{
	probe_stand_attack ();
	probe_think ();
};

void () probe_stop1 = [ 20, probe_stop2 ]
{
	probe_think ();
};

void () probe_stop2 = [ 21, probe_stop3 ]
{
	probe_think ();
};

void () probe_stop3 = [ 22, probe_plant1 ]
{
	sound (self, CHAN_MALICE, "probe/footfall.wav", 1.00, ATTN_PROBE);
	probe_think ();
};

void () probe_satk1 = [ 23, probe_satk2 ]
{
	probe_think ();
};

void () probe_satk2 = [ 24, probe_satk3 ]
{
	probe_think ();
	Probe_laser_fire (-30, 0);
	Probe_laser_fire (30, 0);
};

void () probe_satk3 = [ 25, probe_satk4 ]
{
	probe_think ();
};

void () probe_satk4 = [ 26, probe_satk5 ]
{
	probe_think ();
};

void () probe_satk5 = [ 27, probe_satk6 ]
{
	probe_think ();
};

void () probe_satk6 = [ 28, probe_plant1 ]
{
	probe_think ();
	SUB_AttackFinished (0.3);
};

void () probe_die1 = [ 13, probe_die2 ]
{
	probe_think ();
	ai_run_slide ();
	ai_run_slide ();
	FuelTankExplode ();
};

void () probe_die2 = [ 14, probe_die3 ]
{
	probe_think ();
	sound (self, CHAN_AUTO, "probe/death.wav", 1.00, ATTN_NORM);
	self.nextthink = (time + 0.2);
	ai_run_slide ();
};

void () probe_die3 = [ 15, SUB_Remove ]
{
	self.trigger_field.frame = self.frame;
};


void (entity attacker,float damage) probe_pain =
{
	if ((self.health <= 0))
		return;
	if ((damage < 25))
		return;
	if ((self.pain_finished > time))
		return;
	self.pain_finished = (time + 2.00);
	sound (self, CHAN_VOICE, "probe/pain.wav", 1.00, ATTN_NORM);
};


void () probe_missile_attack =
{
	local float n;

	n = random ();
	if ((n < PROBE_VOLUME))
		probe_watk1 ();
	else
		probe_satk1 ();
};


void () probe_stand_attack =
{
	local vector spot1;
	local vector spot2;

	spot1 = (self.origin + self.view_ofs);
	spot2 = (self.enemy.origin + self.enemy.view_ofs);
	traceline (spot1, spot2, FALSE, self);
	if ((trace_ent != self.enemy))
	{
		probe_run1 ();
		return;
	}
	if ((trace_inopen && trace_inwater))
	{
		probe_run1 ();
		return;
	}
	if ((time < self.attack_finished))
		return;
	self.state = STATE_TOP;
	if ((vlen ((spot2 - spot1)) > 450))
	{
		probe_run1 ();
		return;
	}
	probe_satk1 ();
	if ((self.cnt == 1))
	{
		probe_run1 ();
		return;
	}
};


float () ProbeCheckAttack =
{
	local vector spot1;
	local vector spot2;
	local entity targ;
	local float ang;
	local float delta;
	local float dist;

	self.lefty = 0;
	targ = self.enemy;
	spot1 = (self.origin + self.view_ofs);
	spot2 = (targ.origin + targ.view_ofs);
	traceline (spot1, spot2, FALSE, self);
	if ((trace_inopen && trace_inwater))
		return (FALSE);
	if ((time < self.attack_finished))
		return (FALSE);
	ang = (self.angles_y + self.fixangle);
	delta = (self.ideal_yaw - ang);
	dist = vlen ((spot2 - spot1));
	if ((((fabs (delta) > 10) && (dist > 200)) || (self.enemy.classname != "player")))
		return (FALSE);
	if ((dist < 400))
	{
		self.th_melee ();
		return (TRUE);
	}
	self.lefty = 1;
	return (FALSE);
};


void () monster_probe =
{
	local entity body;
	local float sk;

	if (!deathmatch)
	{
		self.lefty = 0;
		sk = cvar ("skill");
		precache_model ("progs/probebod.mdl");
		precache_model ("progs/probedom.mdl");
		precache_model ("progs/laser.mdl");
		precache_sound ("probe/shoot.wav");
		precache_sound ("probe/footfall.wav");
		precache_sound ("probe/servo.wav");
		precache_sound ("probe/death.wav");
		precache_sound ("probe/pain.wav");
		precache_sound ("enforcer/enfstop.wav");
		precache_sound ("probe/sight.wav");
		precache_sound ("probe/idle1.wav");
		precache_sound ("probe/idle2.wav");
		precache_sound ("probe/idle3.wav");
		precache_sound ("probe/idle4.wav");
		precache_sound ("weapons/fuelexp.wav");
		body = spawn ();
		body.origin = self.origin;
		body.origin = (body.origin - '0 0 64');
		self.solid = SOLID_SLIDEBOX;
		self.fixangle = FALSE;
		self.movetype = MOVETYPE_STEP;
		body.solid = SOLID_NOT;
		body.movetype = MOVETYPE_STEP;
		self.trigger_field = body;
		body.trigger_field = self;
		setmodel (body, "progs/probebod.mdl");
		setmodel (self, "progs/probedom.mdl");
		setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
		setorigin (self, self.origin);
		setorigin (body, body.origin);
		self.yaw_speed = 8;
		self.health = 200;
		dealwithskill ();
		self.worldtype = 0.75;
		self.state = STATE_TOP;
		self.super_time = 0.00;
		self.ltime = 0.00;
		self.th_stand = probe_stand1;
		self.th_walk = probe_walk1;
		self.th_run = probe_run1;
		self.th_die = probe_die1;
		self.th_missile = probe_missile_attack;
		self.th_melee = probe_missile_attack;
		self.th_pain = probe_pain;
		flymonster_start ();
	}
	else
		remove (self);
};


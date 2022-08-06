void() roo_stand1 = [1, roo_stand2]
{
	roo_stand();
};

void() roo_stand2 = [2, roo_stand3]
{
};

void() roo_stand3 = [3, roo_stand4]
{
};

void() roo_stand4 = [4, roo_stand5]
{
};

void() roo_stand5 = [5, roo_stand1]
{
};

void() roo_run1 = [6, roo_run2]
{
	roo_run(12);
};

void() roo_run2 = [7, roo_run3]
{
	roo_run(16);
};

void() roo_run3 = [8, roo_run4]
{
	roo_run(18);
};

void() roo_run4 = [9, roo_run5]
{
	roo_run(20);
};

void() roo_run5 = [10, roo_run6]
{
	roo_run(24);
};

void() roo_run6 = [11, roo_run7]
{
	roo_run(26);
};

void() roo_run7 = [12, roo_run8]
{
	roo_run(26);
};

void() roo_run8 = [12, roo_run9]
{
	roo_run(22);
};

void() roo_run9 = [13, roo_run10]
{
	roo_run(18);
};

void() roo_run10 = [14, roo_run1]
{
	roo_run(16);
	if (vlen(self.enemy.origin - self.origin) < 128)
	{
		self.angles_y = MoveToAngle(self.angles_y, self.angles_y + ((random() < 0.5) * 2 - 1) * 40, 1000);
	}
	else
	{
		self.angles_y = MoveToAngle(self.angles_y, self.angles_y + random() * 40 - 20, 1000);
	}
	if (vlen(self.origin - self.enemy.origin) > 384)
	{
		self.think = roo_stand1;
	}
	self.speed = random() * 0.5;
};

void() roo_stand = 
{
	local entity trav;
	trav = findradius(self.origin, 1024);
	while (trav != world)
	{
		if (trav.classname == "player")
		{
			self.enemy = trav;
			self.think = self.th_run;
			return;
		}
		trav = trav.chain;
	}
	if (random() * 10 >= 7)
	{
		if ((self.enemy = find(world, classname, "player")) != world)
		{
			self.enemy = trav;
			self.think = self.th_run;
			return;
		}
	}
};

void() roo_pain = 
{
	SpawnBlood(self.origin, '0 0 -5', 100);
	roo_stand1();
};

void(float dist) roo_run = 
{
	droptofloor();
	if (!walkmove(self.angles_y, dist))
	{
		self.angles_y = self.angles_y + ((random() > 0.5) * 2 - 1) * 135;
		self.angles_y = anglemod(self.angles_y);
		self.th_run;
		return;
	}
	self.nextthink = time + 0.05;
};

float() spawn_roo = 
{
	local float clear;
	local entity trav;
	local entity oself;
	local entity first_spawn;
	clear = 0;
	first_spawn = last_roo_spawn;
	while (!clear)
	{
		last_roo_spawn = find(last_roo_spawn, classname, "rally_spawn_kangaroo");
		if (last_roo_spawn == world)
		{
			last_roo_spawn = find(last_roo_spawn, classname, "rally_spawn_kangaroo");
		}
		clear = 1;
		trav = findradius(last_roo_spawn.origin, 32);
		while (trav != world && clear)
		{
			if (!(trav.solid == SOLID_NOT || trav.solid == SOLID_TRIGGER))
			{
				clear = 0;
			}
			trav = trav.chain;
		}
		if (!clear && first_spawn == last_roo_spawn)
		{
			return 0;
		}
	}
	oself = self;
	self = last_roo_spawn;
	rally_spawn_kangaroo();
	self = oself;
};

void() spawn_nailbox = 
{
	local entity nailbox;
	local entity oself;
	nailbox = spawn();
	setorigin(nailbox, self.origin + '0 0 32');
	nailbox.angles = '0 0 0';
	oself = self;
	self = nailbox;
	self.touch = ammo_touch;
	setmodel(self, "maps/b_nail0.bsp");
	self.aflag = 25;
	self.weapon = 2;
	self.netname = "nails";
	setsize(self, '0 0 0', '32 32 56');
	if (!droptofloor())
	{
		remove(self);
		self = oself;
		return;
	}
	PlaceItem();
	self.think = SUB_Remove;
	self.nextthink = time + 10;
	self = oself;
};

void() roo_die = 
{
	local vector impact;
	local float done;
	if (other.classname == "player")
	{
		impact = other.velocity;
	}
	else
	{
		impact = '0 0 0';
	}
	ThrowDudeGib("progs/gib1.mdl", impact);
	ThrowDudeGib("progs/gib2.mdl", impact);
	ThrowDudeGib("progs/gib2.mdl", impact);
	ThrowDudeGib("progs/gib3.mdl", impact);
	ThrowDudeGib("progs/gib3.mdl", impact);
	self.deadflag = DEAD_DEAD;
	sound(self, CHAN_VOICE, "player/gib.wav", 1, ATTN_NONE);
	self.solid = SOLID_NOT;
	if (other.classname != "player")
	{
		spawn_nailbox();
	}
	unspawned_roos = unspawned_roos + 1;
	done = 0;
	while (unspawned_roos > 0 && !done)
	{
		if (spawn_roo())
		{
			unspawned_roos = unspawned_roos - 1;
		}
		else
		{
			done = 1;
		}
	}
	remove(self);
};

void() roo_touch = 
{
	local float rnd;
	if (other.classname != "player")
	{
		return;
	}
	if (vlen(other.velocity) < MAX_SPEED / 3)
	{
		return;
	}
	sprint(other, "Road Kill!\nPouch bonus: ");
	if (other.weapon == IT_ROOBAR && other.ammo_roobar > 0)
	{
		other.currentammo = other.ammo_roobar = other.ammo_roobar - 2;
		sound(self, CHAN_AUTO, "rally/process/elect02.wav", 1, ATTN_NORM);
		other.veh_body.effects = other.veh_body.effects | EF_DIMLIGHT;
		other.last_crash = time;
	}
	rnd = random();
	if (rnd < 0.1)
	{
		sprint(other, "20 seconds of Protection!\n");
		sound(other, CHAN_VOICE, "items/protect.wav", 1, ATTN_NORM);
		other.items = other.items | IT_INVULNERABILITY;
		other.invincible_time = 1;
		other.invincible_finished = time + 20;
	}
	else
	{
		if (rnd < 0.3)
		{
			sprint(other, "Extra Traction!\n");
			other.racing_flags = other.racing_flags | QR_FULL_TRACTION;
			other.full_traction_time = time;
		}
		else
		{
			sprint(other, "3 rockets!\n");
			other.currentammo = other.ammo_rockets = other.ammo_rockets + 3;
		}
	}
	self.enemy = other;
	roo_die();
};

void() rally_spawn_kangaroo = 
{
	local entity roo;
	roo = spawn();
	roo.angles = self.angles;
	setorigin(roo, self.origin);
	roo.flags = roo.flags | FL_MONSTER;
	self = roo;
	self.classname = "rally_kangaroo";
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	self.takedamage = DAMAGE_AIM;
	setmodel(self, "models/kangaroo.mdl");
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
	self.health = 120;
	if (!droptofloor())
	{
		dprint("roo fell out of level at: ");
		dprint(vtos(self.origin));
		dprint("\n");
	}
	self.touch = roo_touch;
	self.th_stand = roo_stand1;
	self.th_walk = roo_stand1;
	self.th_run = roo_run1;
	self.th_die = roo_die;
	self.th_pain = roo_pain;
	walkmonster_start();
};


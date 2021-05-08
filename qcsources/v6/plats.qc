void() plat_spawn_inside_trigger = 
{
	local entity trigger;
	local vector tmin;
	local vector tmax;
	trigger = spawn();
	trigger.touch = plat_center_touch;
	trigger.movetype = MOVETYPE_NONE;
	trigger.solid = SOLID_TRIGGER;
	trigger.enemy = self;
	tmin = self.mins + '25 25 0';
	tmax = self.maxs - '25 25 -8';
	tmin_z = tmax_z - (self.pos1_z - self.pos2_z + DOOR_GOLD_KEY);
	if (self.spawnflags & PLAT_LOW_TRIGGER)
	{
		tmax_z = tmin_z + DOOR_GOLD_KEY;
	}
	if (self.size_x <= 50)
	{
		tmin_x = (self.mins_x + self.maxs_x) / WEAPON_ROCKET;
		tmax_x = tmin_x + WEAPON_SHOTGUN;
	}
	if (self.size_y <= 50)
	{
		tmin_y = (self.mins_y + self.maxs_y) / WEAPON_ROCKET;
		tmax_y = tmin_y + WEAPON_SHOTGUN;
	}
	setsize(trigger, tmin, tmax);
};

void() plat_hit_top = 
{
	sound(self, CHAN_VOICE, self.noise1, WEAPON_SHOTGUN, ATTN_NORM);
	self.state = STATE_TOP;
	self.think = plat_go_down;
	self.nextthink = self.ltime + AS_MELEE;
};

void() plat_hit_bottom = 
{
	sound(self, CHAN_VOICE, self.noise1, WEAPON_SHOTGUN, ATTN_NORM);
	self.state = STATE_BOTTOM;
};

void() plat_go_down = 
{
	sound(self, CHAN_VOICE, self.noise, WEAPON_SHOTGUN, ATTN_NORM);
	self.state = STATE_DOWN;
	SUB_CalcMove(self.pos2, self.speed, plat_hit_bottom);
};

void() plat_go_up = 
{
	sound(self, CHAN_VOICE, self.noise, WEAPON_SHOTGUN, ATTN_NORM);
	self.state = STATE_UP;
	SUB_CalcMove(self.pos1, self.speed, plat_hit_top);
};

void() plat_center_touch = 
{
	if (other.classname != "player")
	{
		return;
	}
	if (other.health <= MSG_BROADCAST)
	{
		return;
	}
	self = self.enemy;
	if (self.state == STATE_BOTTOM)
	{
		plat_go_up();
	}
	else
	{
		if (self.state == STATE_TOP)
		{
			self.nextthink = self.ltime + WEAPON_SHOTGUN;
		}
	}
};

void() plat_outside_touch = 
{
	if (other.classname != "player")
	{
		return;
	}
	if (other.health <= MSG_BROADCAST)
	{
		return;
	}
	self = self.enemy;
	if (self.state == STATE_TOP)
	{
		plat_go_down();
	}
};

void() plat_trigger_use = 
{
	if (self.think)
	{
		return;
	}
	plat_go_down();
};

void() plat_crush = 
{
	T_Damage(other, self, self, WEAPON_SHOTGUN);
	if (self.state == STATE_UP)
	{
		plat_go_down();
	}
	else
	{
		if (self.state == STATE_DOWN)
		{
			plat_go_up();
		}
		else
		{
			objerror("plat_crush: bad self.state\n");
		}
	}
};

void() plat_use = 
{
	self.use = SUB_Null;
	if (self.state != STATE_UP)
	{
		objerror("plat_use: not in up state");
	}
	plat_go_down();
};

void() func_plat = 
{
	local entity t;
	if (!(self.t_length))
	{
		self.t_length = 80;
	}
	if (!(self.t_width))
	{
		self.t_width = TE_LAVASPLASH;
	}
	if (self.sounds == MSG_BROADCAST)
	{
		self.sounds = WEAPON_ROCKET;
	}
	if (self.sounds == WEAPON_SHOTGUN)
	{
		precache_sound("plats/plat1.wav");
		precache_sound("plats/plat2.wav");
		self.noise = "plats/plat1.wav";
		self.noise1 = "plats/plat2.wav";
	}
	if (self.sounds == WEAPON_ROCKET)
	{
		precache_sound("plats/medplat1.wav");
		precache_sound("plats/medplat2.wav");
		self.noise = "plats/medplat1.wav";
		self.noise1 = "plats/medplat2.wav";
	}
	self.mangle = self.angles;
	self.angles = VEC_ORIGIN;
	self.classname = "plat";
	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_PUSH;
	setorigin(self, self.origin);
	setmodel(self, self.model);
	setsize(self, self.mins, self.maxs);
	self.blocked = plat_crush;
	if (!(self.speed))
	{
		self.speed = 150;
	}
	self.pos1 = self.origin;
	self.pos2 = self.origin;
	if (self.height)
	{
		self.pos2_z = self.origin_z - self.height;
	}
	else
	{
		self.pos2_z = self.origin_z - self.size_z + DOOR_GOLD_KEY;
	}
	self.use = plat_trigger_use;
	plat_spawn_inside_trigger();
	if (self.targetname)
	{
		self.state = STATE_UP;
		self.use = plat_use;
	}
	else
	{
		setorigin(self, self.pos2);
		self.state = STATE_BOTTOM;
	}
};

void() train_blocked = 
{
	if (time < self.attack_finished)
	{
		return;
	}
	self.attack_finished = time + 0.5;
	T_Damage(other, self, self, self.dmg);
};

void() train_use = 
{
	if (self.think != func_train_find)
	{
		return;
	}
	train_next();
};

void() train_wait = 
{
	if (self.wait)
	{
		self.nextthink = self.ltime + self.wait;
		sound(self, CHAN_VOICE, self.noise, WEAPON_SHOTGUN, ATTN_NORM);
	}
	else
	{
		self.nextthink = self.ltime + 0.1;
	}
	self.think = train_next;
};

void() train_next = 
{
	local entity targ;
	targ = find(world, targetname, self.target);
	self.target = targ.target;
	if (!(self.target))
	{
		objerror("train_next: no next target");
	}
	if (targ.wait)
	{
		self.wait = targ.wait;
	}
	else
	{
		self.wait = MSG_BROADCAST;
	}
	sound(self, CHAN_VOICE, self.noise1, WEAPON_SHOTGUN, ATTN_NORM);
	SUB_CalcMove(targ.origin - self.mins, self.speed, train_wait);
};

void() func_train_find = 
{
	local entity targ;
	targ = find(world, targetname, self.target);
	self.target = targ.target;
	setorigin(self, targ.origin - self.mins);
	if (!(self.targetname))
	{
		self.nextthink = self.ltime + 0.1;
		self.think = train_next;
	}
};

void() func_train = 
{
	if (!(self.speed))
	{
		self.speed = 100;
	}
	if (!(self.target))
	{
		objerror("func_train without a target");
	}
	if (!(self.dmg))
	{
		self.dmg = WEAPON_ROCKET;
	}
	if (self.sounds == MSG_BROADCAST)
	{
		self.noise = "misc/null.wav";
		precache_sound("misc/null.wav");
		self.noise1 = "misc/null.wav";
		precache_sound("misc/null.wav");
	}
	if (self.sounds == WEAPON_SHOTGUN)
	{
		self.noise = "plats/train2.wav";
		precache_sound("plats/train2.wav");
		self.noise1 = "plats/train1.wav";
		precache_sound("plats/train1.wav");
	}
	self.cnt = WEAPON_SHOTGUN;
	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_PUSH;
	self.blocked = train_blocked;
	self.use = train_use;
	self.classname = "train";
	setmodel(self, self.model);
	setsize(self, self.mins, self.maxs);
	setorigin(self, self.origin);
	self.nextthink = self.ltime + 0.1;
	self.think = func_train_find;
};

void() misc_teleporttrain = 
{
	if (!(self.speed))
	{
		self.speed = 100;
	}
	if (!(self.target))
	{
		objerror("func_train without a target");
	}
	self.cnt = WEAPON_SHOTGUN;
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_PUSH;
	self.blocked = train_blocked;
	self.use = train_use;
	self.avelocity = '100 200 300';
	self.noise = "misc/null.wav";
	precache_sound("misc/null.wav");
	self.noise1 = "misc/null.wav";
	precache_sound("misc/null.wav");
	precache_model2("progs/teleport.mdl");
	setmodel(self, "progs/teleport.mdl");
	setsize(self, self.mins, self.maxs);
	setorigin(self, self.origin);
	self.nextthink = self.ltime + 0.1;
	self.think = func_train_find;
};


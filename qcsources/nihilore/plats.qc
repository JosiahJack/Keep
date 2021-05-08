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
	tmin_z = tmax_z - (self.pos1_z - self.pos2_z + SECRET_NO_SHOOT);
	if (self.spawnflags & PLAT_LOW_TRIGGER)
	{
		tmax_z = tmin_z + SECRET_NO_SHOOT;
	}
	if (self.size_x <= 50)
	{
		tmin_x = (self.mins_x + self.maxs_x) / SILENT;
		tmax_x = tmin_x + PLAT_LOW_TRIGGER;
	}
	if (self.size_y <= 50)
	{
		tmin_y = (self.mins_y + self.maxs_y) / SILENT;
		tmax_y = tmin_y + PLAT_LOW_TRIGGER;
	}
	setsize(trigger, tmin, tmax);
};

void() plat_hit_top = 
{
	sound(self, CHAN_VOICE, self.noise1, PLAT_LOW_TRIGGER, ATTN_NORM);
	self.state = STATE_TOP;
	self.think = plat_go_down;
	self.nextthink = self.ltime + SVC_UPDATESTAT;
};

void() plat_hit_bottom = 
{
	sound(self, CHAN_VOICE, self.noise1, PLAT_LOW_TRIGGER, ATTN_NORM);
	self.state = STATE_BOTTOM;
};

void() plat_go_down = 
{
	sound(self, CHAN_VOICE, self.noise, PLAT_LOW_TRIGGER, ATTN_NORM);
	self.state = STATE_DOWN;
	SUB_CalcMove(self.pos2, self.speed, plat_hit_bottom);
};

void() plat_go_up = 
{
	sound(self, CHAN_VOICE, self.noise, PLAT_LOW_TRIGGER, ATTN_NORM);
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
			self.nextthink = self.ltime + PLAT_LOW_TRIGGER;
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
	T_Damage(other, self, self, PLAT_LOW_TRIGGER);
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
		self.t_width = SVC_SETVIEWANGLES;
	}
	if (self.sounds == MSG_BROADCAST)
	{
		self.sounds = SILENT;
	}
	if (self.sounds == PLAT_LOW_TRIGGER)
	{
		precache_sound("plats/plat1.wav");
		precache_sound("plats/plat2.wav");
		self.noise = "plats/plat1.wav";
		self.noise1 = "plats/plat2.wav";
	}
	if (self.sounds == SILENT)
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
		self.pos2_z = self.origin_z - self.size_z + SECRET_NO_SHOOT;
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
	if (self.owner)
	{
		sync_blocked();
		return;
	}
	if (self.classname != "train" && !(self.spawnflags & TRAIN_BLOCKABLE))
	{
		other.velocity = other.velocity + self.velocity * 2.5;
		return;
	}
	if (time < self.attack_finished)
	{
		return;
	}
	self.attack_finished = time + 0.5;
	T_Damage(other, self, self, self.dmg);
};

void() train_use = 
{
	if (self.classname == "smtrain")
	{
		if (self.think != func_smtrain_setup)
		{
			return;
		}
		smtrain_next();
	}
	else
	{
		if (self.think != func_train_find)
		{
			return;
		}
		train_next();
	}
};

void() train_wait = 
{
	if (self.wait)
	{
		if (self.noise)
		{
			sound(self, CHAN_VOICE, self.noise, PLAT_LOW_TRIGGER, ATTN_NORM);
		}
		else
		{
			sound(self, CHAN_VOICE, "misc/null.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
		}
		if (self.wait == CONTENT_EMPTY)
		{
			self.think = func_train_find;
			return;
		}
		self.nextthink = self.ltime + self.wait;
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
	local string temp;
	targ = find(world, targetname, self.target);
	self.target = targ.target;
	if (!(self.target))
	{
		objerror("train_next: no next target");
	}
	if (self.noise1)
	{
		sound(self, CHAN_VOICE, self.noise1, PLAT_LOW_TRIGGER, ATTN_NORM);
	}
	else
	{
		sound(self, CHAN_VOICE, "misc/null.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	}
	self.wait = targ.wait;
	if (self.goalentity.event)
	{
		temp = self.target;
		self.target = self.goalentity.event;
		self.message = self.goalentity.message;
		SUB_UseTargets();
		self.target = temp;
		self.message = string_null;
	}
	if (self.goalentity.duration < MSG_BROADCAST || self.goalentity.speed < MSG_BROADCAST)
	{
		setorigin(self, targ.origin - self.mins);
		self.nextthink = self.ltime + 0.05;
	}
	else
	{
		if (self.goalentity.duration > MSG_BROADCAST)
		{
			self.duration = self.goalentity.duration;
		}
		else
		{
			if (self.goalentity.speed > MSG_BROADCAST)
			{
				self.duration = MSG_BROADCAST;
				self.speed = self.goalentity.speed;
			}
		}
		if (self.duration)
		{
			SUB_CalcTimedMove(targ.origin - self.mins, self.duration, train_wait);
		}
		else
		{
			SUB_CalcMove(targ.origin - self.mins, self.speed, train_wait);
		}
	}
	self.goalentity = targ;
};

void() func_train_find = 
{
	local entity targ;
	targ = find(world, targetname, self.target);
	self.goalentity = targ;
	self.target = targ.target;
	setorigin(self, targ.origin - self.mins);
	if (!(self.targetname))
	{
		self.nextthink = self.ltime + 0.6;
		self.think = train_next;
	}
	if (self.count > MSG_BROADCAST)
	{
		generate_train_clones();
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
		self.dmg = SILENT;
	}
	if (self.sounds == MSG_BROADCAST)
	{
		if (!(self.noise))
		{
			self.noise = "misc/null.wav";
		}
		if (!(self.noise1))
		{
			self.noise1 = "misc/null.wav";
		}
	}
	if (self.sounds == PLAT_LOW_TRIGGER)
	{
		if (!(self.noise))
		{
			self.noise = "plats/train2.wav";
		}
		if (!(self.noise1))
		{
			self.noise1 = "plats/train1.wav";
		}
	}
	precache_sound(self.noise);
	precache_sound(self.noise1);
	if (self.spawnflags & TRAIN_SMOOTH)
	{
		self.classname = "smtrain";
	}
	else
	{
		self.classname = "train";
	}
	self.cnt = PLAT_LOW_TRIGGER;
	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_PUSH;
	self.blocked = train_blocked;
	self.use = train_use;
	setmodel(self, self.model);
	setsize(self, self.mins, self.maxs);
	setorigin(self, self.origin);
	if (self.classname == "smtrain")
	{
		self.think = func_smtrain_setup;
	}
	else
	{
		self.think = func_train_find;
	}
	self.nextthink = self.ltime + 0.6;
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
	self.cnt = PLAT_LOW_TRIGGER;
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


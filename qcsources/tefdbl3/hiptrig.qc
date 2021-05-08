void() keytrigger_use = 
{
	if (activator.classname != "player")
	{
		return;
	}
	if (self.attack_finished > time)
	{
		return;
	}
	self.attack_finished = time + FL_SWIM;
	if ((self.items & activator.items) != self.items)
	{
		if (self.message != "")
		{
			centerprint(activator, self.message);
		}
		else
		{
			if (self.owner.items == IT_KEY1)
			{
				if (world.worldtype == FL_SWIM)
				{
					centerprint(activator, "You need the silver keycard");
				}
				else
				{
					if (world.worldtype == 1)
					{
						centerprint(activator, "You need the silver runekey");
					}
					else
					{
						if (world.worldtype == 0)
						{
							centerprint(activator, "You need the silver key");
						}
					}
				}
			}
			else
			{
				if (world.worldtype == FL_SWIM)
				{
					centerprint(activator, "You need the gold keycard");
				}
				else
				{
					if (world.worldtype == 1)
					{
						centerprint(activator, "You need the gold runekey");
					}
					else
					{
						if (world.worldtype == 0)
						{
							centerprint(activator, "You need the gold key");
						}
					}
				}
			}
		}
		sound(self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
		return;
	}
	activator.items = activator.items - self.items;
	self.touch = SUB_Null;
	self.use = SUB_Null;
	self.nextthink = time + 0.1;
	self.think = SUB_Remove;
	self.message = "";
	sound(self, CHAN_VOICE, self.noise4, 1, ATTN_NORM);
	SUB_UseTargets();
};

void() keytrigger_touch = 
{
	activator = other;
	keytrigger_use();
};

void() trigger_usekey = 
{
	if (world.worldtype == 0)
	{
		precache_sound("doors/medtry.wav");
		precache_sound("doors/meduse.wav");
		self.noise3 = "doors/medtry.wav";
		self.noise4 = "doors/meduse.wav";
	}
	else
	{
		if (world.worldtype == 1)
		{
			precache_sound("doors/runetry.wav");
			precache_sound("doors/runeuse.wav");
			self.noise3 = "doors/runetry.wav";
			self.noise4 = "doors/runeuse.wav";
		}
		else
		{
			if (world.worldtype == FL_SWIM)
			{
				precache_sound("doors/basetry.wav");
				precache_sound("doors/baseuse.wav");
				self.noise3 = "doors/basetry.wav";
				self.noise4 = "doors/baseuse.wav";
			}
			else
			{
				dprint("no worldtype set!\n");
			}
		}
	}
	if (self.spawnflags & USE_GOLD_KEY)
	{
		self.items = IT_KEY2;
	}
	else
	{
		self.items = IT_KEY1;
	}
	self.use = keytrigger_use;
	self.touch = keytrigger_touch;
	InitTrigger();
};

void() remove_touch = 
{
	if (other.flags & self.cnt)
	{
		return;
	}
	other.touch = SUB_Null;
	other.model = "";
	remove(self);
};

void() trigger_remove = 
{
	self.cnt = FL_CLIENT | FL_MONSTER;
	if (self.spawnflags & 1)
	{
		self.cnt = self.cnt - FL_MONSTER;
	}
	if (self.spawnflags & FL_SWIM)
	{
		self.cnt = self.cnt - FL_CLIENT;
	}
	InitTrigger();
	self.touch = remove_touch;
};

void() trigger_gravity_touch = 
{
	if (other.classname != "player")
	{
		return;
	}
	if (self.gravity == CONTENT_EMPTY)
	{
		other.gravity = 1;
	}
	else
	{
		other.gravity = self.gravity;
	}
};

void() trigger_setgravity = 
{
	InitTrigger();
	self.touch = trigger_gravity_touch;
	if (!(self.gravity))
	{
		self.gravity = CONTENT_EMPTY;
	}
	else
	{
		self.gravity = (self.gravity - 1) / 100;
	}
};

void() trigger_command_use = 
{
	if (self.message)
	{
		localcmd(self.message);
	}
};

void() trigger_command = 
{
	self.use = oncount_use;
	self.think = SUB_Null;
};

void() trigger_decoy_touch = 
{
	if (other.classname != "monster_decoy")
	{
		return;
	}
	self.touch = SUB_Null;
	self.nextthink = time + 0.1;
	self.think = SUB_Remove;
	SUB_UseTargets();
};

void() trigger_decoy_use = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	InitTrigger();
	self.touch = trigger_decoy_touch;
};

void() trigger_waterfall_touch = 
{
	if (!(other.flags & FL_CLIENT))
	{
		return;
	}
	other.velocity = other.velocity + self.movedir;
	other.velocity_x = other.velocity_x + self.count * (random() - 0.5);
	other.velocity_y = other.velocity_y + self.count * (random() - 0.5);
};

void() trigger_waterfall = 
{
	InitTrigger();
	self.touch = trigger_waterfall_touch;
	if (self.count == 0)
	{
		self.count = 100;
	}
	if (self.speed == 0)
	{
		self.movedir = self.movedir * 50;
	}
	else
	{
		self.movedir = self.movedir * self.speed;
	}
};


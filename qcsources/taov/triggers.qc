void() multi_wait = 
{
	if (self.max_health)
	{
		self.health = self.max_health;
		self.takedamage = DAMAGE_YES;
		self.solid = SOLID_BBOX;
	}
};

void() InitTrigger = 
{
	if (self.angles != VEC_ORIGIN)
	{
		SetMovedir();
	}
	if (self.classname != "changelevel")
	{
		self.solid = SOLID_TRIGGER;
	}
	setmodel(self, self.model);
	self.movetype = MOVETYPE_NONE;
	self.modelindex = STATE_TOP;
	self.model = "";
};

void() trigger_push_touch = 
{
	if (other.fly_time > time || self.cnt == 1)
	{
		return;
	}
	if (other.fly_sound < time)
	{
		if (!(self.spawnflags & IT_RELIC3))
		{
			sound(other, CHAN_AUTO, "ambience/windfly.wav", PUSH_ONCE, ATTN_NORM);
		}
		if (self.spawnflags & IT_RELIC4)
		{
			sound(other, CHAN_AUTO, "player/jump.wav", PUSH_ONCE, ATTN_NORM);
		}
		other.fly_sound = time + 1.5;
	}
	other.velocity = VEC_ORIGIN;
	other.velocity = self.speed * self.movedir * TE_LAVASPLASH;
	makevectors(other.angles);
	other.velocity_z = self.height;
	if (other.flags & FL_ONGROUND)
	{
		other.flags = other.flags - FL_ONGROUND;
	}
	if (other.th_jump)
	{
		other.think = other.th_jump;
		other.nextthink = time + 0.1;
	}
	if (self.spawnflags & PUSH_ONCE)
	{
		remove(self);
		return;
	}
	other.fly_time = time + self.state;
};

void() trigger_push = 
{
	InitTrigger();
	if (self.spawnflags & IT_RELIC2)
	{
		self.cnt = 1;
	}
	if (!(self.spawnflags & IT_RELIC3))
	{
		precache_sound("ambience/windfly.wav");
	}
	if (self.spawnflags & IT_RELIC4)
	{
		precache_sound("player/jump.wav");
	}
	if (!(self.state))
	{
		self.state = PUSH_ONCE;
	}
	self.touch = trigger_push_touch;
	if (!(self.speed))
	{
		self.speed = 1000;
	}
};

void() multi_use = 
{
	self.enemy = activator;
	multi_trigger();
};

void() multi_killed = 
{
	self.enemy = damage_attacker;
	multi_trigger();
};

void() multi_trigger = 
{
	if (self.nextthink > time)
	{
		return;
	}
	self.takedamage = DAMAGE_NO;
	activator = self.enemy;
	SUB_UseTargets();
	if (self.wait > STATE_TOP)
	{
		self.think = multi_wait;
		self.nextthink = time + self.wait;
	}
	else
	{
		self.touch = SUB_Null;
		self.nextthink = time + 0.1;
		self.think = SUB_Remove;
	}
};

void() multi_touch = 
{
	if (other.classname != "player")
	{
		return;
	}
	self.enemy = other;
	multi_trigger();
};

void() trigger_multiple = 
{
	if (!(self.wait))
	{
		self.wait = 0.2;
	}
	self.use = multi_use;
	InitTrigger();
	if (self.health)
	{
		if (self.spawnflags & SPAWNFLAG_NOTOUCH)
		{
			objerror("health and notouch doesn't make sense\n");
		}
		self.max_health = self.health;
		self.th_die = multi_killed;
		self.takedamage = DAMAGE_YES;
		self.solid = SOLID_BBOX;
		setorigin(self, self.origin);
	}
	else
	{
		if (!(self.spawnflags & SPAWNFLAG_NOTOUCH))
		{
			self.touch = multi_touch;
		}
	}
};

void() trigger_once = 
{
	self.wait = CONTENT_EMPTY;
	trigger_multiple();
};

void() trigger_relay = 
{
	self.use = SUB_UseTargets;
};

void() changelevel_touch = 
{
	local string h;
	if (other.classname != "player")
	{
		return;
	}
	h = ftos(self.cnt);
	cvar_set("gamecfg", h);
	nextmap = self.map;
	changelevel(nextmap);
};

void() trigger_changelevel = 
{
	if (!(self.map))
	{
		objerror("changelevel trigger doesn't have a map set");
	}
	self.classname = "changelevel";
	self.solid = SOLID_BBOX;
	InitTrigger();
	self.touch = changelevel_touch;
};

void() counter_use = 
{
	local string junk;
	self.count = self.count - PUSH_ONCE;
	if (self.count < STATE_TOP)
	{
		return;
	}
	if (self.count != STATE_TOP)
	{
		if (activator.classname == "player" && (self.spawnflags & SPAWNFLAG_NOMESSAGE) == STATE_TOP)
		{
			if (self.count >= IT_RELIC3)
			{
				sprint(activator.owner, "There are more to go...");
			}
			else
			{
				if (self.count == AS_MELEE)
				{
					sprint(activator.owner, "Only 3 more to go...");
				}
				else
				{
					if (self.count == IT_RELIC2)
					{
						sprint(activator.owner, "Only 2 more to go...");
					}
					else
					{
						sprint(activator.owner, "Only 1 more to go...");
					}
				}
			}
		}
		return;
	}
	if (activator.classname == "player" && (self.spawnflags & SPAWNFLAG_NOMESSAGE) == STATE_TOP)
	{
		sprint(activator.owner, "Sequence completed!");
	}
	self.enemy = activator;
	multi_trigger();
};

void() trigger_counter = 
{
	self.wait = CONTENT_EMPTY;
	if (!(self.count))
	{
		self.count = IT_RELIC2;
	}
	self.use = counter_use;
};

void() camstyle_touch = 
{
	if (other.classname == "player")
	{
		other.owner.camerastyle = self.camerastyle;
	}
};

void() trigger_camstyle = 
{
	self.solid = SOLID_TRIGGER;
	setmodel(self, self.model);
	self.movetype = MOVETYPE_NONE;
	self.modelindex = STATE_TOP;
	self.model = "";
	self.touch = camstyle_touch;
};

void() pit_touch = 
{
	local entity temp;
	if (other.pitdeath == 1)
	{
		return;
	}
	if (other.classname == "player")
	{
		setorigin(other, other.lastpos);
		WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte(MSG_BROADCAST, TE_TELEPORT);
		WriteCoord(MSG_BROADCAST, other.origin_x);
		WriteCoord(MSG_BROADCAST, other.origin_y);
		WriteCoord(MSG_BROADCAST, other.origin_z);
		other.owner.telecam = 1;
	}
	else
	{
		if (other.flags & FL_MONSTER)
		{
			if (other.target)
			{
				temp = self;
				self = other;
				SUB_UseTargets();
				self = temp;
			}
			if (other.health > STATE_TOP)
			{
				killed_monsters = killed_monsters + PUSH_ONCE;
				WriteByte(MSG_ALL, SVC_KILLEDMONSTER);
			}
			remove(other);
			return;
		}
	}
	other.pitdeath = 1;
	if (other.health > STATE_TOP)
	{
		T_Damage(other, self, self, other.health);
	}
};

void() trigger_pit = 
{
	self.solid = SOLID_TRIGGER;
	setmodel(self, self.model);
	self.movetype = MOVETYPE_NONE;
	self.modelindex = STATE_TOP;
	self.model = "";
	self.touch = pit_touch;
};

void() teledoor_touch = 
{
	local entity t;
	local vector org;
	if (other.classname != "player" && other.health < PUSH_ONCE)
	{
		return;
	}
	t = find(world, targetname, self.target);
	if (!t)
	{
		objerror("couldn't find target for teledoor!");
	}
	setorigin(other, t.origin);
	other.angles = t.angles;
	other.fixangle = 1;
	other.owner.telecam = 1;
};

void() info_teledoor_destination = 
{
	self.solid = SOLID_NOT;
	setmodel(self, self.model);
	self.movetype = MOVETYPE_NONE;
	self.modelindex = STATE_TOP;
	self.model = "";
	if (!(self.targetname))
	{
		objerror("no targetname on teledoor destination.\n");
	}
};

void() trigger_teledoor = 
{
	self.solid = SOLID_TRIGGER;
	setmodel(self, self.model);
	self.movetype = MOVETYPE_NONE;
	self.modelindex = STATE_TOP;
	self.model = "";
	self.touch = teledoor_touch;
};

void() walktrigger_touch = 
{
	if (other.classname != "player" && other.health < PUSH_ONCE)
	{
		return;
	}
	other.fly_time = time;
	other.angles_y = self.angles_y;
	other.fixangle = 1;
	other.owner.forcewalk_finished = time + 0.1;
};

void() trigger_walk = 
{
	self.solid = SOLID_TRIGGER;
	setmodel(self, self.model);
	self.movetype = MOVETYPE_NONE;
	self.modelindex = STATE_TOP;
	self.model = "";
	self.touch = walktrigger_touch;
};

void() raintrigger_touch = 
{
	if (other.classname != "camera")
	{
		return;
	}
	if (self.cnt == PUSH_ONCE)
	{
		if (other.rain_on == 0)
		{
			other.rain_on = 1;
		}
	}
	else
	{
		if (other.rain_on == 1)
		{
			other.rain_on = 0;
		}
	}
};

void() trigger_rain = 
{
	precache_model("progs/rain.spr");
	precache_sound("ambience/rain.wav");
	self.solid = SOLID_TRIGGER;
	setmodel(self, self.model);
	self.movetype = MOVETYPE_NONE;
	self.modelindex = STATE_TOP;
	self.model = "";
	self.touch = raintrigger_touch;
};

void() safezonetrigger_touch = 
{
	if (other.classname != "player")
	{
		return;
	}
	if (self.cnt == PUSH_ONCE)
	{
		if (other.owner.safezone == 0)
		{
			other.owner.safezone = 1;
		}
	}
	else
	{
		if (other.owner.safezone == 1)
		{
			other.owner.safezone = 0;
		}
	}
};

void() trigger_safezone = 
{
	self.solid = SOLID_TRIGGER;
	setmodel(self, self.model);
	self.movetype = MOVETYPE_NONE;
	self.modelindex = STATE_TOP;
	self.model = "";
	self.touch = safezonetrigger_touch;
};


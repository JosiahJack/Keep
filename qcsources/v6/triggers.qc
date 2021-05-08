void() trigger_reactivate = 
{
	self.solid = SOLID_TRIGGER;
};

void() multi_wait = 
{
	if (self.max_health)
	{
		self.health = self.max_health;
		self.takedamage = DAMAGE_YES;
		self.solid = SOLID_BBOX;
	}
};

void() multi_trigger = 
{
	if (self.nextthink > time)
	{
		return;
	}
	if (self.ammo_shells && !deathmatch)
	{
		if (self.enemy.classname != "player")
		{
			return;
		}
		found_secrets = found_secrets + WEAPON_SHOTGUN;
		WriteByte(MSG_ALL, SVC_FOUNDSECRET);
		self.ammo_shells = MSG_BROADCAST;
	}
	if (self.noise)
	{
		sound(self, CHAN_VOICE, self.noise, WEAPON_SHOTGUN, ATTN_NORM);
	}
	self.takedamage = DAMAGE_NO;
	activator = self.enemy;
	SUB_UseTargets();
	if (self.noise3)
	{
		if (self.enemy.classname == "player")
		{
			stuffcmd(self.enemy, self.noise3);
		}
		else
		{
			if (self.enemy.enemy.classname == "player")
			{
				stuffcmd(self.enemy.enemy, self.noise3);
			}
		}
	}
	if (self.wait > MSG_BROADCAST)
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

void() multi_killed = 
{
	self.enemy = damage_attacker;
	multi_trigger();
};

void() multi_use = 
{
	self.enemy = activator;
	multi_trigger();
};

void() multi_touch = 
{
	if (other.classname != "player" && !(self.spawnflags & DOOR_DONT_LINK))
	{
		return;
	}
	if (self.movedir != VEC_ORIGIN)
	{
		makevectors(other.angles);
		if (v_forward * self.movedir < MSG_BROADCAST)
		{
			return;
		}
	}
	self.enemy = other;
	multi_trigger();
};

void() trigger_multiple = 
{
	self.nextthink = time + WEAPON_SHOTGUN;
	self.think = trigger_multiple_think;
	if (self.sounds == WEAPON_SHOTGUN && !(self.noise4))
	{
		precache_sound("misc/secret.wav");
		self.noise = "misc/secret.wav";
	}
	else
	{
		if (self.sounds == WEAPON_ROCKET)
		{
			precache_sound("misc/talk.wav");
			self.noise = "misc/talk.wav";
		}
		else
		{
			if (self.sounds == AS_MELEE)
			{
				precache_sound("misc/trigger1.wav");
				self.noise = "misc/trigger1.wav";
			}
		}
	}
	if (self.noise4)
	{
		precache_sound(self.noise4);
		self.noise = self.noise4;
	}
};

void() trigger_multiple_think = 
{
	if (skill == MSG_BROADCAST && (self.spawnflags & IT_SHELLS))
	{
		remove(self);
		return;
	}
	if (skill == WEAPON_SHOTGUN && (self.spawnflags & IT_NAILS))
	{
		remove(self);
		return;
	}
	if (skill >= WEAPON_ROCKET && (self.spawnflags & IT_ROCKETS))
	{
		remove(self);
		return;
	}
	if (deathmatch && (self.spawnflags & IT_CELLS))
	{
		remove(self);
		return;
	}
	if (self.spawnflags & WEAPON_ROCKET)
	{
		total_secrets = total_secrets + WEAPON_SHOTGUN;
		self.ammo_shells = WEAPON_SHOTGUN;
	}
	if (self.classname == "trigger_secret" && !deathmatch)
	{
		total_secrets = total_secrets + WEAPON_SHOTGUN;
		if (!(self.message))
		{
			self.message = "You found a secret area!";
		}
	}
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
			objerror("health and notouch don't make sense\n");
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

void() trigger_secret = 
{
	self.wait = CONTENT_EMPTY;
	if (!(self.sounds))
	{
		self.sounds = WEAPON_SHOTGUN;
	}
	if (self.sounds == WEAPON_SHOTGUN)
	{
		precache_sound("misc/secret.wav");
		self.noise = "misc/secret.wav";
	}
	else
	{
		if (self.sounds == WEAPON_ROCKET)
		{
			precache_sound("misc/talk.wav");
			self.noise = "misc/talk.wav";
		}
	}
	trigger_multiple();
};

void() counter_use = 
{
	local string junk;
	self.count = self.count - WEAPON_SHOTGUN;
	if (self.count < MSG_BROADCAST)
	{
		return;
	}
	if (self.count != MSG_BROADCAST)
	{
		if (activator.classname == "player" && (self.spawnflags & SPAWNFLAG_NOMESSAGE) == MSG_BROADCAST)
		{
			if (self.count >= DOOR_DONT_LINK)
			{
				centerprint(activator, "There are more to go...");
			}
			else
			{
				if (self.count == AS_MELEE)
				{
					centerprint(activator, "Only 3 more to go...");
				}
				else
				{
					if (self.count == WEAPON_ROCKET)
					{
						centerprint(activator, "Only 2 more to go...");
					}
					else
					{
						centerprint(activator, "Only 1 more to go...");
					}
				}
			}
		}
		return;
	}
	if (activator.classname == "player" && (self.spawnflags & SPAWNFLAG_NOMESSAGE) == MSG_BROADCAST)
	{
		centerprint(activator, "Sequence completed!");
	}
	self.enemy = activator;
	multi_trigger();
};

void() trigger_counter_think = 
{
	if (skill == MSG_BROADCAST && (self.spawnflags & IT_SHELLS))
	{
		remove(self);
		return;
	}
	if (skill == WEAPON_SHOTGUN && (self.spawnflags & IT_NAILS))
	{
		remove(self);
		return;
	}
	if (skill >= WEAPON_ROCKET && (self.spawnflags & IT_ROCKETS))
	{
		remove(self);
		return;
	}
	if (deathmatch && (self.spawnflags & IT_CELLS))
	{
		remove(self);
		return;
	}
	self.wait = CONTENT_EMPTY;
	if (!(self.count))
	{
		self.count = WEAPON_ROCKET;
	}
	self.use = counter_use;
};

void() trigger_counter = 
{
	self.think = trigger_counter_think;
	self.nextthink = time + WEAPON_SHOTGUN;
};

void() play_teleport = 
{
	local float v;
	local string tmpstr;
	v = random() * TE_LIGHTNING1;
	if (v < WEAPON_SHOTGUN)
	{
		tmpstr = "misc/r_tele1.wav";
	}
	else
	{
		if (v < WEAPON_ROCKET)
		{
			tmpstr = "misc/r_tele2.wav";
		}
		else
		{
			if (v < AS_MELEE)
			{
				tmpstr = "misc/r_tele3.wav";
			}
			else
			{
				if (v < DOOR_DONT_LINK)
				{
					tmpstr = "misc/r_tele4.wav";
				}
				else
				{
					tmpstr = "misc/r_tele5.wav";
				}
			}
		}
	}
	sound(self, CHAN_VOICE, tmpstr, WEAPON_SHOTGUN, ATTN_NORM);
	remove(self);
};

void(vector org) spawn_tfog = 
{
	s = spawn();
	s.origin = org;
	s.nextthink = time + 0.2;
	s.think = play_teleport;
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_TELEPORT);
	WriteCoord(MSG_BROADCAST, org_x);
	WriteCoord(MSG_BROADCAST, org_y);
	WriteCoord(MSG_BROADCAST, org_z);
};

void() tdeath_touch = 
{
	if (other == self.owner)
	{
		return;
	}
	if (other.classname == "player")
	{
		if (other.invincible_finished > time)
		{
			self.classname = "teledeath2";
		}
		if (self.owner.classname != "player")
		{
			T_Damage(self.owner, self, self, 50000);
			return;
		}
	}
	if (other.health)
	{
		T_Damage(other, self, self, 50000);
	}
};

void(vector org, entity death_owner) spawn_tdeath = 
{
	local entity death;
	death = spawn();
	death.classname = "teledeath";
	death.movetype = MOVETYPE_NONE;
	death.solid = SOLID_TRIGGER;
	death.angles = VEC_ORIGIN;
	setsize(death, death_owner.mins - '1 1 1', death_owner.maxs + '1 1 1');
	setorigin(death, org);
	death.touch = tdeath_touch;
	death.nextthink = time + 0.2;
	death.think = SUB_Remove;
	death.owner = death_owner;
	force_retouch = WEAPON_ROCKET;
};

void() teleport_touch = 
{
	local entity t;
	local vector org;
	if (self.targetname)
	{
		if (self.nextthink < time)
		{
			return;
		}
	}
	if (self.spawnflags & PLAYER_ONLY)
	{
		if (other.classname != "player")
		{
			return;
		}
	}
	if (other.health <= MSG_BROADCAST || other.solid != SOLID_SLIDEBOX)
	{
		return;
	}
	SUB_UseTargets();
	spawn_tfog(other.origin);
	t = find(world, targetname, self.target);
	if (!t)
	{
		objerror("couldn't find target");
	}
	makevectors(t.mangle);
	org = t.origin + DOOR_TOGGLE * v_forward;
	spawn_tfog(org);
	spawn_tdeath(t.origin, other);
	if (!(other.health))
	{
		other.origin = t.origin;
		other.velocity = v_forward * other.velocity_x + v_forward * other.velocity_y;
		return;
	}
	setorigin(other, t.origin);
	other.angles = t.mangle;
	if (other.classname == "player")
	{
		other.fixangle = WEAPON_SHOTGUN;
		other.teleport_time = time + 0.7;
		if (other.flags & FL_ONGROUND)
		{
			other.flags = other.flags - FL_ONGROUND;
		}
		other.velocity = v_forward * 300;
	}
	other.flags = other.flags - (other.flags & FL_ONGROUND);
};

void() info_teleport_destination = 
{
	self.mangle = self.angles;
	self.angles = VEC_ORIGIN;
	self.model = "";
	self.origin = self.origin + '0 0 27';
	if (!(self.targetname))
	{
		objerror("no targetname");
	}
};

void() teleport_use = 
{
	self.nextthink = time + 0.2;
	force_retouch = WEAPON_ROCKET;
	self.think = SUB_Null;
};

void() trigger_teleport = 
{
	local vector o;
	if (skill == MSG_BROADCAST && (self.spawnflags & IT_SHELLS))
	{
		remove(self);
		return;
	}
	if (skill == WEAPON_SHOTGUN && (self.spawnflags & IT_NAILS))
	{
		remove(self);
		return;
	}
	if (skill == WEAPON_ROCKET && (self.spawnflags & IT_ROCKETS))
	{
		remove(self);
		return;
	}
	if (deathmatch && (self.spawnflags & IT_CELLS))
	{
		remove(self);
		return;
	}
	InitTrigger();
	self.touch = teleport_touch;
	if (!(self.target))
	{
		objerror("no target");
	}
	self.use = teleport_use;
	if (!(self.spawnflags & SILENT))
	{
		precache_sound("ambience/hum1.wav");
		o = (self.mins + self.maxs) * 0.5;
		ambientsound(o, "ambience/hum1.wav", 0.5, ATTN_STATIC);
	}
};

void() trigger_skill_touch = 
{
	if (other.classname != "player")
	{
		return;
	}
	cvar_set("skill", self.message);
};

void() trigger_skill_use = 
{
	other = activator;
	trigger_skill_touch();
};

void() trigger_setskill = 
{
	if (skill == MSG_BROADCAST && (self.spawnflags & IT_SHELLS))
	{
		remove(self);
		return;
	}
	if (skill == WEAPON_SHOTGUN && (self.spawnflags & IT_NAILS))
	{
		remove(self);
		return;
	}
	if (skill == WEAPON_ROCKET && (self.spawnflags & IT_ROCKETS))
	{
		remove(self);
		return;
	}
	if (deathmatch && (self.spawnflags & IT_CELLS))
	{
		remove(self);
		return;
	}
	InitTrigger();
	self.touch = trigger_skill_touch;
	self.use = trigger_skill_use;
};

void() trigger_onlyregistered_touch = 
{
	if (other.classname != "player")
	{
		return;
	}
	if (self.attack_finished > time)
	{
		return;
	}
	self.attack_finished = time + WEAPON_ROCKET;
	if (cvar("registered"))
	{
		self.message = "";
		SUB_UseTargets();
		remove(self);
	}
	else
	{
		if (self.message != "")
		{
			centerprint(other, self.message);
			sound(other, CHAN_BODY, "misc/talk.wav", WEAPON_SHOTGUN, ATTN_NORM);
		}
	}
};

void() trigger_onlyregistered = 
{
	precache_sound("misc/talk.wav");
	InitTrigger();
	self.touch = trigger_onlyregistered_touch;
};

void() hurt_on = 
{
	self.solid = SOLID_TRIGGER;
	self.nextthink = CONTENT_EMPTY;
};

void() hurt_touch = 
{
	if (other.takedamage)
	{
		self.solid = SOLID_NOT;
		T_Damage(other, self, self, self.dmg);
		self.think = hurt_on;
		self.nextthink = time + WEAPON_SHOTGUN;
	}
	return;
};

void() trigger_hurt = 
{
	InitTrigger();
	self.touch = hurt_touch;
	if (!(self.dmg))
	{
		self.dmg = TE_LIGHTNING1;
	}
};

void() trigger_push_touch = 
{
	if (other.classname == "grenade")
	{
		other.velocity = self.speed * self.movedir * TE_LAVASPLASH;
	}
	else
	{
		if (other.health > MSG_BROADCAST)
		{
			other.velocity = self.speed * self.movedir * TE_LAVASPLASH;
			if (other.classname == "player")
			{
				if (other.fly_sound < time && !(self.spawnflags & WEAPON_ROCKET))
				{
					other.fly_sound = time + 1.5;
					sound(other, CHAN_AUTO, "ambience/windfly.wav", WEAPON_SHOTGUN, ATTN_NORM);
				}
			}
		}
	}
	if (self.spawnflags & PUSH_ONCE)
	{
		remove(self);
	}
};

void() trigger_push = 
{
	if (skill == MSG_BROADCAST && (self.spawnflags & IT_SHELLS))
	{
		remove(self);
		return;
	}
	if (skill == WEAPON_SHOTGUN && (self.spawnflags & IT_NAILS))
	{
		remove(self);
		return;
	}
	if (skill == WEAPON_ROCKET && (self.spawnflags & IT_ROCKETS))
	{
		remove(self);
		return;
	}
	if (deathmatch && (self.spawnflags & IT_CELLS))
	{
		remove(self);
		return;
	}
	InitTrigger();
	precache_sound("ambience/windfly.wav");
	self.touch = trigger_push_touch;
	if (!(self.speed))
	{
		self.speed = 1000;
	}
};

void() trigger_monsterjump_touch = 
{
	if ((other.flags & (FL_MONSTER | FL_FLY | FL_SWIM)) != FL_MONSTER)
	{
		return;
	}
	if (self.spawnflags & WEAPON_SHOTGUN && other.classname == "monster_ogre")
	{
		return;
	}
	other.velocity_x = self.movedir_x * self.speed;
	other.velocity_y = self.movedir_y * self.speed;
	if (!(other.flags & FL_ONGROUND))
	{
		return;
	}
	other.flags = other.flags - FL_ONGROUND;
	other.velocity_z = self.height;
	if (self.lip)
	{
		self.ammo_cells = self.ammo_cells + WEAPON_SHOTGUN;
		if (self.lip <= self.ammo_cells)
		{
			self.touch = SUB_Null;
			self.nextthink = time + 0.1;
			self.think = SUB_Remove;
		}
	}
};

void() trigger_monsterjump = 
{
	if (skill == MSG_BROADCAST && (self.spawnflags & IT_SHELLS))
	{
		remove(self);
		return;
	}
	if (skill == WEAPON_SHOTGUN && (self.spawnflags & IT_NAILS))
	{
		remove(self);
		return;
	}
	if (skill == WEAPON_ROCKET && (self.spawnflags & IT_ROCKETS))
	{
		remove(self);
		return;
	}
	if (deathmatch && (self.spawnflags & IT_CELLS))
	{
		remove(self);
		return;
	}
	self.ammo_cells = MSG_BROADCAST;
	if (!(self.speed))
	{
		self.speed = 200;
	}
	if (!(self.height))
	{
		self.height = 200;
	}
	if (self.angles == VEC_ORIGIN)
	{
		self.angles = '0 360 0';
	}
	InitTrigger();
	self.touch = trigger_monsterjump_touch;
};


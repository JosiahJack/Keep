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
	if (self.classname == "trigger_secret")
	{
		if (self.enemy.classname != "player")
		{
			return;
		}
		found_secrets = found_secrets + 1;
		WriteByte(MSG_ALL, SVC_FOUNDSECRET);
	}
	if (self.noise)
	{
		sound(self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
	}
	self.takedamage = DAMAGE_NO;
	activator = self.enemy;
	SUB_UseTargets();
	if (self.wait > 0)
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
	if (other.classname != "player")
	{
		return;
	}
	if (self.movedir != VEC_ORIGIN)
	{
		makevectors(other.angles);
		if (v_forward * self.movedir < 0)
		{
			return;
		}
	}
	self.enemy = other;
	multi_trigger();
};

void() trigger_multiple = 
{
	if (self.sounds == 1)
	{
		precache_sound("misc/secret.wav");
		self.noise = "misc/secret.wav";
	}
	else
	{
		if (self.sounds == FL_SWIM)
		{
			precache_sound("misc/talk.wav");
			self.noise = "misc/talk.wav";
		}
		else
		{
			if (self.sounds == MOVETYPE_WALK)
			{
				precache_sound("misc/trigger1.wav");
				self.noise = "misc/trigger1.wav";
			}
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
	total_secrets = total_secrets + 1;
	self.wait = CONTENT_EMPTY;
	if (!(self.message))
	{
		self.message = "You found a secret area!";
	}
	if (!(self.sounds))
	{
		self.sounds = 1;
	}
	if (self.sounds == 1)
	{
		precache_sound("misc/secret.wav");
		self.noise = "misc/secret.wav";
	}
	else
	{
		if (self.sounds == FL_SWIM)
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
	self.count = self.count - 1;
	if (self.count < 0)
	{
		return;
	}
	if (self.count != 0)
	{
		if (activator.classname == "player" && (self.spawnflags & SPAWNFLAG_NOMESSAGE) == 0)
		{
			if (self.count >= MOVETYPE_STEP)
			{
				centerprint(activator, "There are more to go...");
			}
			else
			{
				if (self.count == MOVETYPE_WALK)
				{
					centerprint(activator, "Only 3 more to go...");
				}
				else
				{
					if (self.count == FL_SWIM)
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
	if (activator.classname == "player" && (self.spawnflags & SPAWNFLAG_NOMESSAGE) == 0)
	{
		centerprint(activator, "Sequence completed!");
	}
	self.enemy = activator;
	multi_trigger();
};

void() trigger_counter = 
{
	self.wait = CONTENT_EMPTY;
	if (!(self.count))
	{
		self.count = FL_SWIM;
	}
	self.use = counter_use;
};

void() play_teleport = 
{
	local float v;
	local string tmpstr;
	v = random() * MOVETYPE_FLY;
	if (v < 1)
	{
		tmpstr = "misc/r_tele1.wav";
	}
	else
	{
		if (v < FL_SWIM)
		{
			tmpstr = "misc/r_tele2.wav";
		}
		else
		{
			if (v < MOVETYPE_WALK)
			{
				tmpstr = "misc/r_tele3.wav";
			}
			else
			{
				if (v < MOVETYPE_STEP)
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
	sound(self, CHAN_VOICE, tmpstr, 1, ATTN_NORM);
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
	force_retouch = FL_SWIM;
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
	if (other.health <= 0 || other.solid != SOLID_SLIDEBOX)
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
	org = t.origin + FL_MONSTER * v_forward;
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
		other.fixangle = 1;
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
	force_retouch = FL_SWIM;
	self.think = SUB_Null;
};

void() trigger_teleport = 
{
	local vector o;
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

void() trigger_setskill = 
{
	InitTrigger();
	self.touch = trigger_skill_touch;
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
	self.attack_finished = time + FL_SWIM;
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
			sound(other, CHAN_BODY, "misc/talk.wav", 1, ATTN_NORM);
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
		self.nextthink = time + 1;
	}
	return;
};

void() trigger_hurt = 
{
	InitTrigger();
	self.touch = hurt_touch;
	if (!(self.dmg))
	{
		self.dmg = MOVETYPE_FLY;
	}
};

void() trigger_push_touch = 
{
	if (other.classname == "grenade")
	{
		other.velocity = self.speed * self.movedir * MOVETYPE_BOUNCE;
	}
	else
	{
		if (other.health > 0)
		{
			other.velocity = self.speed * self.movedir * MOVETYPE_BOUNCE;
			if (other.classname == "player")
			{
				if (other.fly_sound < time)
				{
					other.fly_sound = time + 1.5;
					sound(other, CHAN_AUTO, "ambience/windfly.wav", 1, ATTN_NORM);
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
	other.velocity_x = self.movedir_x * self.speed;
	other.velocity_y = self.movedir_y * self.speed;
	if (!(other.flags & FL_ONGROUND))
	{
		return;
	}
	other.flags = other.flags - FL_ONGROUND;
	other.velocity_z = self.height;
};

void() trigger_monsterjump = 
{
	if (!(self.speed))
	{
		self.speed = MAX_NAILS;
	}
	if (!(self.height))
	{
		self.height = MAX_NAILS;
	}
	if (self.angles == VEC_ORIGIN)
	{
		self.angles = '0 360 0';
	}
	InitTrigger();
	self.touch = trigger_monsterjump_touch;
};

void() give_ammo = 
{
	if (self.targetname)
	{
		other = activator;
	}
	if (other.classname != "player")
	{
		return;
	}
	if (time < self.attack_finished)
	{
		return;
	}
	if (self.ammo_shells == 0)
	{
		if (self.ammo_nails == 0)
		{
			if (self.ammo_rockets == 0)
			{
				if (self.ammo_cells == 0)
				{
					return;
				}
			}
		}
	}
	if (self.ammo_shells > 0 && other.ammo_shells < MAX_SHELLS)
	{
		if (self.spawnflags & FL_SWIM)
		{
			other.ammo_shells = other.ammo_shells + 40;
		}
		else
		{
			other.ammo_shells = other.ammo_shells + 20;
		}
		self.ammo_shells = self.ammo_shells - 1;
	}
	if (self.ammo_nails > 0 && other.ammo_nails < MAX_NAILS)
	{
		if (self.spawnflags & FL_SWIM)
		{
			other.ammo_nails = other.ammo_nails + 50;
		}
		else
		{
			other.ammo_nails = other.ammo_nails + 25;
		}
		self.ammo_nails = self.ammo_nails - 1;
	}
	if (self.ammo_rockets > 0 && other.ammo_rockets < MAX_SHELLS)
	{
		if (self.spawnflags & FL_SWIM)
		{
			other.ammo_rockets = other.ammo_rockets + MOVETYPE_FLY;
		}
		else
		{
			other.ammo_rockets = other.ammo_rockets + FL_SWIM;
		}
		self.ammo_rockets = self.ammo_rockets - 1;
	}
	if (self.ammo_cells > 0 && other.ammo_cells < MAX_SHELLS)
	{
		if (self.spawnflags & FL_SWIM)
		{
			other.ammo_cells = other.ammo_cells + STAT_TOTALMONSTERS;
		}
		else
		{
			other.ammo_cells = other.ammo_cells + MOVETYPE_TOSS;
		}
		self.ammo_cells = self.ammo_cells - 1;
	}
	stemp = self;
	self = other;
	W_SetCurrentAmmo();
	self = stemp;
	sound(self, CHAN_VOICE, self.noise, 0.75, ATTN_NORM);
	if (!(self.targetname))
	{
		self.attack_finished = time + self.wait;
	}
	if (self.target)
	{
		SUB_UseTargets();
		self.target = string_null;
	}
};

void() give_health = 
{
	if (self.targetname)
	{
		other = activator;
	}
	if (other.classname != "player")
	{
		return;
	}
	if (time < self.attack_finished)
	{
		return;
	}
	if (self.dmg == 0 || other.health >= MAX_SHELLS)
	{
		return;
	}
	if (self.spawnflags & FL_SWIM)
	{
		other.health = other.health + 25;
	}
	else
	{
		other.health = other.health + 15;
	}
	self.dmg = self.dmg - 1;
	if (other.health > MAX_SHELLS)
	{
		other.health = MAX_SHELLS;
	}
	sound(self, CHAN_VOICE, self.noise, 0.75, ATTN_NORM);
	if (!(self.targetname))
	{
		self.attack_finished = time + self.wait;
	}
	if (self.target)
	{
		SUB_UseTargets();
		self.target = string_null;
	}
};

void() give_armour = 
{
	if (self.targetname)
	{
		other = activator;
	}
	if (other.classname != "player")
	{
		return;
	}
	if (time < self.attack_finished)
	{
		return;
	}
	if (self.armorvalue == 0 || other.armortype == 0)
	{
		return;
	}
	if (other.armorvalue >= MAX_SHELLS && other.armortype == 0.3)
	{
		return;
	}
	if (other.armorvalue >= 150 && other.armortype == 0.6)
	{
		return;
	}
	if (other.armorvalue >= MAX_NAILS && other.armortype == 0.8)
	{
		return;
	}
	if (other.armortype == 0.3)
	{
		other.armorvalue = other.armorvalue + 15;
		if (other.armorvalue > MAX_SHELLS)
		{
			other.armorvalue = MAX_SHELLS;
		}
		other.items = other.items - (other.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3)) + IT_ARMOR1;
	}
	else
	{
		if (other.armortype == 0.6)
		{
			other.armorvalue = other.armorvalue + MOVETYPE_BOUNCE;
			if (other.armorvalue > 150)
			{
				other.armorvalue = 150;
			}
			other.items = other.items - (other.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3)) + IT_ARMOR2;
		}
		else
		{
			other.armorvalue = other.armorvalue + MOVETYPE_FLY;
			if (other.armorvalue > MAX_NAILS)
			{
				other.armorvalue = MAX_NAILS;
			}
			other.items = other.items - (other.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3)) + IT_ARMOR3;
		}
	}
	self.armorvalue = self.armorvalue - 1;
	sound(self, CHAN_VOICE, self.noise, 0.75, ATTN_NORM);
	if (!(self.targetname))
	{
		self.attack_finished = time + self.wait;
	}
	if (self.target)
	{
		SUB_UseTargets();
		self.target = string_null;
	}
};

void() give_secret = 
{
	if (self.targetname)
	{
		other = activator;
	}
	if (other.classname != "player")
	{
		return;
	}
	if (self.wait == CONTENT_EMPTY)
	{
		return;
	}
	if (self.spawnflags & FL_SWIM)
	{
		self.ammo_shells = self.ammo_shells * 40;
		self.ammo_nails = self.ammo_nails * 50;
		self.ammo_rockets = self.ammo_rockets * MOVETYPE_FLY;
		self.ammo_cells = self.ammo_cells * STAT_TOTALMONSTERS;
		self.dmg = self.dmg * 25;
	}
	else
	{
		self.ammo_shells = self.ammo_shells * 20;
		self.ammo_nails = self.ammo_nails * 25;
		self.ammo_rockets = self.ammo_rockets * FL_SWIM;
		self.ammo_cells = self.ammo_cells * MOVETYPE_TOSS;
		self.dmg = self.dmg * 15;
	}
	other.ammo_shells = other.ammo_shells + self.ammo_shells;
	other.ammo_nails = other.ammo_nails + self.ammo_nails;
	other.ammo_rockets = other.ammo_rockets + self.ammo_rockets;
	other.ammo_cells = other.ammo_cells + self.ammo_cells;
	stemp = self;
	self = other;
	W_SetCurrentAmmo();
	self = stemp;
	other.health = other.health + self.dmg;
	if (other.health > MAX_SHELLS)
	{
		other.health = MAX_SHELLS;
	}
	if (other.armortype == 0.3)
	{
		self.armorvalue = self.armorvalue * 15;
		other.armorvalue = other.armorvalue + self.armorvalue;
		if (other.armorvalue > MAX_SHELLS)
		{
			other.armorvalue = MAX_SHELLS;
		}
	}
	else
	{
		if (other.armortype == 0.6)
		{
			self.armorvalue = self.armorvalue * MOVETYPE_BOUNCE;
			other.armorvalue = other.armorvalue + self.armorvalue;
			if (other.armorvalue > 150)
			{
				other.armorvalue = 150;
			}
		}
		else
		{
			if (other.armortype == 0.8)
			{
				self.armorvalue = self.armorvalue * MOVETYPE_FLY;
				other.armorvalue = other.armorvalue + self.armorvalue;
				if (other.armorvalue > MAX_NAILS)
				{
					other.armorvalue = MAX_NAILS;
				}
			}
		}
	}
	self.wait = CONTENT_EMPTY;
	sound(self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
	if (self.message)
	{
		centerprint(other, self.message);
	}
	if (self.target)
	{
		SUB_UseTargets();
		self.target = string_null;
	}
};

void() trigger_give = 
{
	if (!(self.targetname) || deathmatch)
	{
		if (deathmatch)
		{
			remove(self);
		}
	}
	if (!(self.cnt))
	{
		objerror(" no cnt value\n");
	}
	if (self.cnt < 1 && self.cnt > MOVETYPE_STEP)
	{
		objerror(" cnt value must be between 1 and 4\n");
	}
	if (!(self.wait))
	{
		self.wait = 1;
	}
	if (!(self.sounds))
	{
		self.sounds = 0;
	}
	if (self.cnt == MOVETYPE_STEP)
	{
		self.noise = "misc/secret.wav";
	}
	else
	{
		if (self.sounds == 1)
		{
			self.noise = "buttons/switch02.wav";
		}
		else
		{
			if (self.cnt == 1)
			{
				self.noise = "weapons/lock4.wav";
			}
			else
			{
				if (self.cnt == FL_SWIM)
				{
					if (self.spawnflags & FL_SWIM)
					{
						self.noise = "items/health1.wav";
					}
					else
					{
						self.noise = "items/r_item1.wav";
					}
				}
				else
				{
					self.noise = "items/armor1.wav";
				}
			}
		}
	}
	precache_sound(self.noise);
	self.aflag = 0;
	if (self.cnt == 1)
	{
		if (!(self.ammo_shells))
		{
			self.ammo_shells = 0;
			self.aflag = self.aflag + 1;
		}
		if (!(self.ammo_nails))
		{
			self.ammo_nails = 0;
			self.aflag = self.aflag + 1;
		}
		if (!(self.ammo_rockets))
		{
			self.ammo_rockets = 0;
			self.aflag = self.aflag + 1;
		}
		if (!(self.ammo_cells))
		{
			self.ammo_cells = 0;
			self.aflag = self.aflag + 1;
		}
		if (self.aflag == MOVETYPE_STEP)
		{
			objerror("trigger_give with cnt 1 and no ammo_* parms\n");
		}
		if (self.targetname)
		{
			self.use = give_ammo;
		}
		else
		{
			self.touch = give_ammo;
		}
	}
	else
	{
		if (self.cnt == FL_SWIM)
		{
			if (!(self.dmg))
			{
				objerror("trigger_give with cnt 2 and no dmg parm\n");
			}
			if (self.targetname)
			{
				self.use = give_health;
			}
			else
			{
				self.touch = give_health;
			}
		}
		else
		{
			if (self.cnt == MOVETYPE_WALK)
			{
				if (!(self.armorvalue))
				{
					objerror("trigger_give with cnt 3 and no armorvalue parm\n");
				}
				if (self.targetname)
				{
					self.use = give_armour;
				}
				else
				{
					self.touch = give_armour;
				}
			}
			else
			{
				if (!(self.ammo_shells))
				{
					self.ammo_shells = 0;
					self.aflag = self.aflag + 1;
				}
				if (!(self.ammo_nails))
				{
					self.ammo_nails = 0;
					self.aflag = self.aflag + 1;
				}
				if (!(self.ammo_rockets))
				{
					self.ammo_rockets = 0;
					self.aflag = self.aflag + 1;
				}
				if (!(self.ammo_cells))
				{
					self.ammo_cells = 0;
					self.aflag = self.aflag + 1;
				}
				if (!(self.dmg))
				{
					self.dmg = 0;
					self.aflag = self.aflag + 1;
				}
				if (!(self.armorvalue))
				{
					self.armorvalue = 0;
					self.aflag = self.aflag + 1;
				}
				if (self.aflag == MOVETYPE_TOSS)
				{
					objerror("trigger_give with cnt 4 and no ammo_*, dmg or armorvalue parms\n");
				}
				if (!(self.message))
				{
					self.message = "You found a supply dump!\n";
				}
				if (self.targetname)
				{
					self.use = give_secret;
				}
				else
				{
					self.touch = give_secret;
				}
			}
		}
	}
	InitTrigger();
};


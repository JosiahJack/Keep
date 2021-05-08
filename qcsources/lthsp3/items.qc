void() SUB_regen = 
{
	self.model = self.mdl;
	self.solid = SOLID_TRIGGER;
	sound(self, CHAN_VOICE, "items/itembk2.wav", AS_STRAIGHT, ATTN_NORM);
	setorigin(self, self.origin);
};

void() noclass = 
{
	dprint("noclass spawned at");
	dprint(vtos(self.origin));
	dprint("\n");
	remove(self);
};

void() PlaceItem = 
{
	local float oldz;
	self.mdl = self.model;
	self.flags = FL_ITEM;
	self.solid = SOLID_TRIGGER;
	self.movetype = MOVETYPE_TOSS;
	self.velocity = VEC_ORIGIN;
	self.origin_z = self.origin_z + TE_LIGHTNING2;
	oldz = self.origin_z;
	if (!droptofloor())
	{
		dprint("Bonus item fell out of level at ");
		dprint(vtos(self.origin));
		dprint("\n");
		remove(self);
		return;
	}
};

void() StartItem = 
{
	self.nextthink = time + 0.2;
	self.think = PlaceItem;
};

void() item_megahealth_rot = 
{
	if (self.owner.health > self.owner.max_health)
	{
		self.owner.health = self.owner.health - AS_STRAIGHT;
		self.nextthink = time + AS_STRAIGHT;
		return;
	}
	self.owner.items = self.owner.items - (self.owner.items & IT_SUPERHEALTH);
	if (deathmatch == AS_STRAIGHT)
	{
		self.nextthink = time + 20;
		self.think = SUB_regen;
	}
};

float(float base, float add, float max) AddAndBound = 
{
	base = base + add;
	if (base > max)
	{
		base = max;
	}
	return base;
};

void(string modelstring, string soundstring, float its) ItemSetup = 
{
	self.touch = ItemTouch;
	self.items = its;
	precache_model(modelstring);
	setmodel(self, modelstring);
	precache_sound(soundstring);
	self.noise = soundstring;
	setsize(self, '-16 -16 0', '16 16 56');
	StartItem();
};

void(entity forent, string a, string b, string c) Sprint3Strings = 
{
	sprint(forent, a);
	sprint(forent, b);
	sprint(forent, c);
};

void() ItemTouch = 
{
	local string str;
	local float ammototal;
	if (!(other.flags & FL_CLIENT))
	{
		return;
	}
	if (other.health <= MSG_BROADCAST)
	{
		return;
	}
	ammototal = self.ammo_shells + self.ammo_nails + self.ammo_rockets + self.ammo_cells + self.weapon;
	if (self.health)
	{
		if (self.spawnflags & AS_SLIDING)
		{
			other.health = ceil(other.health + self.health);
			if (other.health > 250)
			{
				other.health = 250;
			}
			other.items = other.items | IT_SUPERHEALTH;
			self.nextthink = time + TE_LIGHTNING1;
			self.think = item_megahealth_rot;
			self.owner = other;
		}
		else
		{
			if (other.health >= MAX_HEALTH)
			{
				return;
			}
			other.health = ceil(other.health + self.health);
			if (other.health > MAX_HEALTH)
			{
				other.health = MAX_HEALTH;
			}
		}
		str = ftos(self.health);
		Sprint3Strings(other, "[ ", str, " Health ]\n");
	}
	else
	{
		if (self.armorvalue)
		{
			if (other.armortype * other.armorvalue >= self.armortype * self.armorvalue)
			{
				return;
			}
			other.armortype = self.armortype;
			other.armorvalue = self.armorvalue;
			other.items = other.items - (other.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3)) + self.items;
			sprint(other, "[ Armour ]\n");
		}
		else
		{
			if (self.items & IT_KEY1 || (self.items & IT_KEY2))
			{
				if (other.items & self.items)
				{
					return;
				}
				other.items = other.items | self.items;
				Sprint3Strings(other, "[ ", self.netname, " ]\n");
			}
			else
			{
				if (self.classname == "item_sigil")
				{
					centerprint(other, "You got the rune!");
					serverflags = serverflags | (self.spawnflags & 15);
					self.classname = "";
				}
				else
				{
					if (self.classname == "powerup")
					{
						Sprint3Strings(other, "[ ", self.netname, " ]\n");
						other.items = other.items | self.items;
						if (self.items & IT_SUIT)
						{
							other.rad_time = self.rad_time;
							other.radsuit_finished = time + self.radsuit_finished;
						}
						else
						{
							if (self.items & IT_INVULNERABILITY)
							{
								other.invincible_time = self.invincible_time;
								other.invincible_finished = time + self.invincible_finished;
							}
							else
							{
								if (self.items & IT_INVISIBILITY)
								{
									other.invisible_time = self.invisible_time;
									other.invisible_finished = time + self.invisible_finished;
								}
								else
								{
									if (self.items & IT_QUAD)
									{
										other.super_time = self.super_time;
										other.super_damage_finished = time + self.super_damage_finished;
									}
								}
							}
						}
					}
					else
					{
						if (ammototal)
						{
							ammototal = other.ammo_shells + other.ammo_nails + other.ammo_rockets + other.ammo_cells + other.items;
							other.items = other.items - (other.items & self.weapon) + self.weapon;
							other.ammo_shells = AddAndBound(other.ammo_shells, self.ammo_shells, MAX_SHELLS);
							other.ammo_nails = AddAndBound(other.ammo_nails, self.ammo_nails, MAX_NAILS);
							other.ammo_rockets = AddAndBound(other.ammo_rockets, self.ammo_rockets, MAX_ROCKETS);
							other.ammo_cells = AddAndBound(other.ammo_cells, self.ammo_cells, MAX_CELLS);
							if (ammototal == other.ammo_shells + other.ammo_nails + other.ammo_rockets + other.ammo_cells + other.items)
							{
								return;
							}
							if (self.weapon)
							{
								if (coop)
								{
									if (other.items & self.weapon)
									{
										return;
									}
								}
								Sprint3Strings(other, "[ ", self.netname, " ]\n");
							}
							if (self.ammo_shells)
							{
								str = ftos(self.ammo_shells);
								Sprint3Strings(other, "[ ", str, " shells ]\n");
							}
							if (self.ammo_nails)
							{
								str = ftos(self.ammo_nails);
								Sprint3Strings(other, "[ ", str, " nails ]\n");
							}
							if (self.ammo_rockets)
							{
								str = ftos(self.ammo_rockets);
								Sprint3Strings(other, "[ ", str, " rockets ]\n");
							}
							if (self.ammo_cells)
							{
								str = ftos(self.ammo_cells);
								Sprint3Strings(other, "[ ", str, " cells ]\n");
							}
							W_SetCurrentAmmo(other);
						}
					}
				}
			}
		}
	}
	sound(other, CHAN_ITEM, self.noise, AS_STRAIGHT, ATTN_NORM);
	stuffcmd(other, "bf\n");
	activator = other;
	SUB_UseTargets();
	if (coop)
	{
		if (self.items & IT_KEY1 || (self.items & IT_KEY2) || (self.weapon && !(self.classname == "backpack")))
		{
			return;
		}
		else
		{
			if (!(self.health && (self.spawnflags & AS_SLIDING)))
			{
				remove(self);
			}
		}
	}
	self.solid = SOLID_NOT;
	self.model = string_null;
	if (deathmatch)
	{
		if (!(self.health && (self.spawnflags & AS_SLIDING)))
		{
			self.nextthink = time + self.ltime;
			self.think = SUB_regen;
		}
	}
};

void(string m, string s, float hlt) Health = 
{
	self.health = hlt;
	self.ltime = 20;
	ItemSetup(m, s, MSG_BROADCAST);
	setsize(self, VEC_ORIGIN, '32 32 56');
};

void() item_health = 
{
	if (self.spawnflags & AS_STRAIGHT)
	{
		Health("maps/b_bh10.bsp", "items/r_item1.wav", 15);
	}
	else
	{
		if (self.spawnflags & AS_SLIDING)
		{
			Health("maps/b_bh100.bsp", "items/r_item2.wav", MAX_CELLS);
		}
		else
		{
			Health("maps/b_bh25.bsp", "items/health1.wav", 25);
		}
	}
};

void(float sk, float tp, float val, float its) Armour = 
{
	self.skin = sk;
	self.armortype = tp;
	self.armorvalue = val;
	self.ltime = 20;
	ItemSetup("progs/armor.mdl", "items/armor1.wav", its);
};

void() item_armor1 = 
{
	Armour(MSG_BROADCAST, 0.3, MAX_CELLS, IT_ARMOR1);
};

void() item_armor2 = 
{
	Armour(AS_STRAIGHT, 0.6, 150, IT_ARMOR2);
};

void() item_armorInv = 
{
	Armour(AS_SLIDING, 0.8, MAX_NAILS, IT_ARMOR3);
};

float(float weaponfloat, string namestring, string modelstring, float ammofloat) Weapon = 
{
	self.weapon = weaponfloat;
	self.netname = namestring;
	self.ltime = SVC_INTERMISSION;
	ItemSetup(modelstring, "weapons/pkup.wav", MSG_BROADCAST);
	return ammofloat;
};

void() weapon_supershotgun = 
{
	self.ammo_shells = Weapon(IT_SUPER_SHOTGUN, "Super Shotgun", "progs/g_shot.mdl", TE_LIGHTNING1);
};

void() weapon_nailgun = 
{
	self.ammo_nails = Weapon(IT_NAILGUN, "Nailgun", "progs/g_nail.mdl", SVC_INTERMISSION);
};

void() weapon_supernailgun = 
{
	self.ammo_nails = Weapon(IT_SUPER_NAILGUN, "Perforator", "progs/g_nail2.mdl", SVC_INTERMISSION);
};

void() weapon_grenadelauncher = 
{
	self.ammo_rockets = Weapon(IT_GRENADE_LAUNCHER, "Grenade Launcher", "progs/g_rock.mdl", TE_LIGHTNING1);
};

void() weapon_rocketlauncher = 
{
	self.ammo_rockets = Weapon(IT_ROCKET_LAUNCHER, "Rocket Launcher", "progs/g_rock2.mdl", TE_LIGHTNING1);
};

void() weapon_lightning = 
{
	self.ammo_cells = Weapon(IT_LIGHTNING, "Thunderbolt", "progs/g_light.mdl", 15);
};

float(string namestring, string modelstring, string bigmdlstring, float am) Ammo = 
{
	if (self.spawnflags & AS_STRAIGHT)
	{
		modelstring = bigmdlstring;
		am = am * AS_SLIDING;
	}
	Weapon(MSG_BROADCAST, namestring, modelstring, MSG_BROADCAST);
	setsize(self, VEC_ORIGIN, '32 32 56');
	return am;
};

void() item_shells = 
{
	self.ammo_shells = Ammo("shells", "maps/b_shell0.bsp", "maps/b_shell1.bsp", 20);
};

void() item_spikes = 
{
	self.ammo_nails = Ammo("nails", "maps/b_nail0.bsp", "maps/b_nail1.bsp", 25);
};

void() item_rockets = 
{
	self.ammo_rockets = Ammo("rockets", "maps/b_rock0.bsp", "maps/b_rock1.bsp", TE_LIGHTNING1);
};

void() item_cells = 
{
	self.ammo_cells = Ammo("cells", "maps/b_batt0.bsp", "maps/b_batt1.bsp", TE_LIGHTNING2);
};

void() item_weapon = 
{
	if (self.spawnflags & AS_STRAIGHT)
	{
		self.ammo_shells = Ammo("shells", "maps/b_shell0.bsp", "maps/b_shell1.bsp", 20);
	}
	else
	{
		if (self.spawnflags & AS_MISSILE)
		{
			self.ammo_nails = Ammo("nails", "maps/b_nail0.bsp", "maps/b_nail1.bsp", 25);
		}
		else
		{
			if (self.spawnflags & AS_SLIDING)
			{
				self.ammo_rockets = Ammo("rockets", "maps/b_rock0.bsp", "maps/b_rock1.bsp", TE_LIGHTNING1);
			}
		}
	}
};

void(float keytype) Key = 
{
	local string n;
	local string m;
	local string s;
	if (world.worldtype == MSG_BROADCAST)
	{
		if (keytype == IT_KEY1)
		{
			n = "silver key";
			m = "progs/w_s_key.mdl";
		}
		else
		{
			n = "gold key";
			m = "progs/w_g_key.mdl";
		}
		s = "misc/medkey.wav";
	}
	else
	{
		if (world.worldtype == AS_STRAIGHT)
		{
			if (keytype == IT_KEY1)
			{
				n = "silver runekey";
				m = "progs/m_s_key.mdl";
			}
			else
			{
				n = "gold runekey";
				m = "progs/m_g_key.mdl";
			}
			s = "misc/runekey.wav";
		}
		else
		{
			if (world.worldtype == AS_SLIDING)
			{
				if (keytype == IT_KEY1)
				{
					n = "silver keycard";
					m = "progs/b_s_key.mdl";
				}
				else
				{
					n = "gold keycard";
					m = "progs/b_g_key.mdl";
				}
				s = "misc/basekey.wav";
			}
		}
	}
	self.netname = n;
	ItemSetup(m, s, keytype);
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
};

void() item_key1 = 
{
	Key(IT_KEY1);
};

void() item_key2 = 
{
	Key(IT_KEY2);
};

void() item_sigil = 
{
	local string m;
	if (!(self.spawnflags))
	{
		objerror("no spawnflags");
	}
	if (self.spawnflags & AS_STRAIGHT)
	{
		m = "progs/end1.mdl";
	}
	else
	{
		if (self.spawnflags & AS_SLIDING)
		{
			m = "progs/end2.mdl";
		}
		else
		{
			if (self.spawnflags & AS_MISSILE)
			{
				m = "progs/end3.mdl";
			}
			else
			{
				if (self.spawnflags & EF_DIMLIGHT)
				{
					m = "progs/end4.mdl";
				}
			}
		}
	}
	ItemSetup(m, "misc/runekey.wav", MSG_BROADCAST);
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
};

void(string namestring, string modelstring, string soundstring, float its, float tm) Powerup = 
{
	self.classname = "powerup";
	self.netname = namestring;
	self.ltime = tm;
	ItemSetup(modelstring, soundstring, its);
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
};

void() item_artifact_invulnerability = 
{
	self.invincible_time = AS_STRAIGHT;
	self.invincible_finished = SVC_INTERMISSION;
	Powerup("Penta", "progs/invulner.mdl", "items/protect.wav", IT_INVULNERABILITY, 300);
	precache_sound("items/protect2.wav");
	precache_sound("items/protect3.wav");
};

void() item_artifact_envirosuit = 
{
	self.rad_time = AS_STRAIGHT;
	self.radsuit_finished = SVC_INTERMISSION;
	Powerup("Biosuit", "progs/suit.mdl", "items/suit.wav", IT_SUIT, 60);
	precache_sound("items/suit2.wav");
};

void() item_artifact_invisibility = 
{
	self.invisible_time = AS_STRAIGHT;
	self.invisible_finished = SVC_INTERMISSION;
	Powerup("Invisibility", "progs/invisibl.mdl", "items/inv1.wav", IT_INVISIBILITY, 300);
	precache_sound("items/inv2.wav");
	precache_sound("items/inv3.wav");
};

void() item_artifact_super_damage = 
{
	self.super_time = AS_STRAIGHT;
	self.super_damage_finished = SVC_INTERMISSION;
	Powerup("Quad", "progs/quaddama.mdl", "items/damage.wav", IT_QUAD, 60);
	precache_sound("items/damage2.wav");
	precache_sound("items/damage3.wav");
};

void() DropBackpack = 
{
	local entity item;
	if (!(self.ammo_shells + self.ammo_nails + self.ammo_rockets + self.ammo_cells))
	{
		return;
	}
	item = spawn();
	item.origin = self.origin - '0 0 24';
	item.weapon = self.weapon;
	item.ammo_shells = self.ammo_shells;
	item.ammo_nails = self.ammo_nails;
	item.ammo_rockets = self.ammo_rockets;
	item.ammo_cells = self.ammo_cells;
	item.velocity_z = 300;
	item.velocity_x = -100 + random() * MAX_NAILS;
	item.velocity_y = -100 + random() * MAX_NAILS;
	item.flags = FL_ITEM;
	item.solid = SOLID_TRIGGER;
	item.movetype = MOVETYPE_TOSS;
	setmodel(item, "progs/backpack.mdl");
	setsize(item, '-16 -16 0', '16 16 56');
	item.touch = ItemTouch;
	item.nextthink = time + 120;
	item.think = SUB_Remove;
	item.classname = "backpack";
	item.noise = "weapons/pkup.wav";
};


void () W_SetCurrentAmmo;
void () UpdateAmmoBars;

void () SUB_regen =
{
	if ((self.netname == "Atom Smasher"))
		serverflags = (serverflags | 15);
	self.model = self.mdl;
	self.solid = SOLID_TRIGGER;
	sound (self, CHAN_AUTO, "items/itembk2.wav", 1.00, ATTN_NORM);
	setorigin (self, self.origin);
};


void () noclass =
{
	dprint ("noclass spawned at");
	dprint (vtos (self.origin));
	dprint ("\n");
	remove (self);
};


void () PlaceItem =
{
	local float oldz;

	self.mdl = self.model;
	self.flags = FL_ITEM;
	self.solid = SOLID_TRIGGER;
	self.movetype = MOVETYPE_TOSS;
	self.velocity = VEC_ORIGIN;
	self.origin_z = (self.origin_z + 6);
	oldz = self.origin_z;
	if (!droptofloor (0, 0))
	{
		dprint ("Bonus item fell out of level at ");
		dprint (vtos (self.origin));
		dprint ("\n");
		remove (self);
		return;
	}
};


void () StartItem =
{
	self.nextthink = (time + 0.2);
	self.think = PlaceItem;
};


float (entity e,float healamount,float ignore) T_Heal =
{
	if ((e.health <= 0))
		return (FALSE);
	if ((!ignore && (e.health >= other.max_health)))
		return (FALSE);
	healamount = ceil (healamount);
	e.health = (e.health + healamount);
	if ((!ignore && (e.health >= other.max_health)))
		e.health = other.max_health;
	if ((e.health > 250))
		e.health = 250;
	return (TRUE);
};

float H_ROTTEN    = 1;
float H_MEGA    = 2;
.float healamount;
.float healtype;
void () health_touch;

void () item_health =
{
	self.touch = health_touch;
	if ((self.spawnflags & H_ROTTEN))
	{
		precache_model ("maps/b_bh10.bsp");
		precache_sound ("items/health1.wav");
		precache_sound ("items/r_item1.wav");
		precache_sound ("items/r_item2.wav");
		setmodel (self, "maps/b_bh10.bsp");
		self.healamount = 15;
		self.healtype = 0;
	}
	else
	{
		precache_model ("maps/b_bh25.bsp");
		precache_sound ("items/health1.wav");
		precache_sound ("items/r_item1.wav");
		precache_sound ("items/r_item2.wav");
		setmodel (self, "maps/b_bh25.bsp");
		self.healamount = 25;
		self.healtype = 1;
	}
	setsize (self, VEC_ORIGIN, '32 32 56');
	StartItem ();
};


void () health_touch =
{
	local float amount;
	local string s;

	
	
	
	local float z;

	if ((other.probe_active == TRUE))
		return;
	if ((other.classname != "player"))
		return;
	if ((self.healtype == H_MEGA))
	{
		if ((other.health >= 250))
			return;
		if (!T_Heal (other, self.healamount, 1))
			return;
	}
	else
	{
		if (!T_Heal (other, self.healamount, FALSE))
			return;
	}
	if ((other.classname == "player"))
	{
		sprint (other, "You receive ");
		s = ftos (self.healamount);
		sprint (other, s);
		sprint (other, " health\n");
		stuffcmd (other, "bf\n");
	}
	z = random ();
	if ((z < 0.33))
		sound (other, CHAN_ITEM, "items/r_item1.wav", 1.00, ATTN_NORM);
	else
	{
		if ((z < 0.66))
			sound (other, CHAN_ITEM, "items/r_item2.wav", 1.00, ATTN_NORM);
		else
			sound (other, CHAN_ITEM, "items/health1.wav", 1.00, ATTN_NORM);
	}
	self.model = string_null;
	self.solid = SOLID_NOT;
	if ((deathmatch != 2))
	{
		if (deathmatch)
			self.nextthink = (time + 20);
		self.think = SUB_regen;
	}
	activator = other;
	SUB_UseTargets ();
};


void () bound_other_ammo =
{
	if ((other.ammo_shells2 > 100))
		other.ammo_shells2 = 100;
	if ((other.ammo_nails2 > 200))
		other.ammo_nails2 = 200;
	if ((other.ammo_rockets2 > 100))
		other.ammo_rockets2 = 100;
	if ((other.ammo_cells2 > 100))
		other.ammo_cells2 = 100;
};


float (float w) RankForWeapon =
{
	if ((w == IT_PUNISHER))
		return (1);
	if ((w == IT_ROCKET))
		return (2);
	if ((w == IT_MORTER))
		return (3);
	if ((w == IT_MINI))
		return (CAMPER);
	if ((w == IT_UZI))
		return (3);
	if ((w == IT_SHOT2))
		return (6);
	return (7);
};


void (float old,float new) Deathmatch_Weapon =
{
	local float or;
	local float nr;

	or = RankForWeapon (self.weapon);
	nr = RankForWeapon (new);
	if ((nr < or))
		self.weapon = new;
};

float () W_BestWeapon;

void () weapon_touch =
{
	local float hadammo;
	local float best;
	local float new;
	local float old;
	local entity stemp;
	local float leave;

	if ((other.probe_active == TRUE))
		return;
	if ((other.classname != "player"))
		return;
	if (((deathmatch == 2) || coop))
		leave = TRUE;
	else
		leave = FALSE;
	if ((self.classname == "weapon_nailgun"))
	{
		if ((leave && (other.items & IT_UZI)))
			return;
		hadammo = other.ammo_nails2;
		new = IT_UZI;
		other.ammo_nails2 = (other.ammo_nails2 + 30);
	}
	else
	{
		if ((self.classname == "weapon_supernailgun"))
		{
			if ((leave && (other.items & IT_MINI)))
				return;
			hadammo = other.ammo_nails2;
			new = IT_MINI;
			other.ammo_nails2 = (other.ammo_nails2 + 30);
		}
		else
		{
			if ((self.classname == "weapon_hellfire"))
			{
				if ((leave && (other.items & IT_SHOT)))
					return;
				hadammo = other.ammo_shells2;
				new = IT_SHOT;
				other.ammo_shells2 = (other.ammo_shells2 + 30);
			}
			else
			{
				if ((self.classname == "weapon_supershotgun"))
				{
					if ((leave && (other.items & IT_SHOT2)))
						return;
					hadammo = other.ammo_shells2;
					new = IT_SHOT2;
					other.ammo_shells2 = (other.ammo_shells2 + 30);
				}
				else
				{
					if ((self.classname == "weapon_rocketlauncher"))
					{
						if ((leave && (other.items & IT_ROCKET)))
							return;
						hadammo = other.ammo_rockets2;
						new = IT_ROCKET;
						other.ammo_rockets2 = (other.ammo_rockets2 + 5);
					}
					else
					{
						if ((self.classname == "weapon_grenadelauncher"))
						{
							if ((leave && (other.items & IT_MORTER)))
								return;
							hadammo = other.ammo_rockets2;
							new = IT_MORTER;
							other.ammo_rockets2 = (other.ammo_rockets2 + 6);
						}
						else
						{
							if ((self.classname == "weapon_lightning"))
							{
								if ((leave && (other.items & IT_PUNISHER)))
									return;
								hadammo = other.ammo_cells2;
								new = IT_PUNISHER;
								other.ammo_cells2 = (other.ammo_cells2 + 15);
							}
							else
								objerror ("weapon_touch: unknown classname");
						}
					}
				}
			}
		}
	}
	sprint (other, self.netname);
	sprint (other, " acquired\n");
	stuffcmd (other, "bf\n");
	sound (other, CHAN_ITEM, "weapons/reload11.wav", 1.00, ATTN_NORM);
	bound_other_ammo ();
	old = other.items;
	other.items = (other.items | new);
	stemp = self;
	self = other;
	if ((self.automount == TRUE))
	{
		if (!deathmatch)
			self.weapon = new;
		else
			Deathmatch_Weapon (old, new);
	}
	if ((self.weapon == IT_44))
		UpdateAmmoBars ();
	else
		W_SetCurrentAmmo ();
	self = stemp;
	if (leave)
		return;
	self.model = string_null;
	self.solid = SOLID_NOT;
	if ((deathmatch == 1))
		self.nextthink = (time + 30.00);
	self.think = SUB_regen;
	activator = other;
	SUB_UseTargets ();
};


void () weapon_supershotgun =
{
	precache_model ("progs/m_shot2.mdl");
	setmodel (self, "progs/m_shot2.mdl");
	self.weapon = IT_SHOT2;
	self.netname = "Vert-Barrel Shotgun";
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};


void () weapon_nailgun =
{
	precache_model ("progs/m_uzi.mdl");
	setmodel (self, "progs/m_uzi.mdl");
	self.weapon = IT_UZI;
	self.netname = "Uzi";
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};


void () weapon_hellfire =
{
	precache_model ("progs/m_hell.mdl");
	setmodel (self, "progs/m_hell.mdl");
	self.weapon = IT_SHOT;
	self.netname = "Hellfire";
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};


void () weapon_supernailgun =
{
	precache_model ("progs/m_mini.mdl");
	setmodel (self, "progs/m_mini.mdl");
	self.weapon = IT_MINI;
	self.netname = "Minigun";
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};


void () weapon_grenadelauncher =
{
	precache_model ("progs/m_morter.mdl");
	setmodel (self, "progs/m_morter.mdl");
	self.weapon = IT_MORTER;
	self.netname = "Mortar Gun";
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};


void () weapon_rocketlauncher =
{
	precache_model ("progs/m_rocket.mdl");
	setmodel (self, "progs/m_rocket.mdl");
	self.weapon = IT_ROCKET;
	self.netname = "Missile Launcher";
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};


void () weapon_lightning =
{
	precache_model ("progs/m_punish.mdl");
	setmodel (self, "progs/m_punish.mdl");
	self.weapon = IT_PUNISHER;
	self.netname = "Punisher";
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};


void () ammo_touch =
{
	local entity stemp;
	local float best;

	
	local string amnt;

	if ((other.probe_active == TRUE))
		return;
	if ((other.classname != "player"))
		return;
	if ((other.health <= 0))
		return;
	if ((self.weapon == 1))
	{
		if ((other.ammo_shells2 >= 100))
			return;
		other.ammo_shells2 = (other.ammo_shells2 + self.aflag);
	}
	if ((self.weapon == 2))
	{
		if ((other.ammo_nails2 >= 200))
			return;
		other.ammo_nails2 = (other.ammo_nails2 + self.aflag);
	}
	if ((self.weapon == 3))
	{
		if ((other.ammo_rockets2 >= 100))
			return;
		other.ammo_rockets2 = (other.ammo_rockets2 + self.aflag);
	}
	if ((self.weapon == CAMPER))
	{
		if ((other.ammo_cells2 >= 100))
			return;
		other.ammo_cells2 = (other.ammo_cells2 + self.aflag);
	}
	bound_other_ammo ();
	sprint (other, "Picked up ");
	amnt = ftos (self.aflag);
	sprint (other, amnt);
	sprint (other, " ");
	sprint (other, self.netname);
	sprint (other, "\n");
	stuffcmd (other, "bf\n");
	sound (other, CHAN_ITEM, "weapons/lock4.wav", 1.00, ATTN_NORM);
	stemp = self;
	self = other;
	if (((self.weapon == best) && (self.automount == TRUE)))
	{
		if ((W_BestWeapon () == IT_44))
			UpdateAmmoBars ();
		else
		{
			self.weapon = W_BestWeapon ();
			W_SetCurrentAmmo ();
		}
	}
	if ((self.weapon == IT_44))
		UpdateAmmoBars ();
	else
		W_SetCurrentAmmo ();
	self = stemp;
	self.model = string_null;
	self.solid = SOLID_NOT;
	if ((deathmatch == 1))
		self.nextthink = (time + 30.00);
	self.think = SUB_regen;
	activator = other;
	SUB_UseTargets ();
};

float WEAPON_BIG2    = 1;

void () item_shells =
{
	self.touch = ammo_touch;
	if ((self.spawnflags & WEAPON_BIG2))
	{
		precache_model ("maps/b_shell1.bsp");
		setmodel (self, "maps/b_shell1.bsp");
		self.aflag = 40;
	}
	else
	{
		precache_model ("maps/b_shell0.bsp");
		setmodel (self, "maps/b_shell0.bsp");
		self.aflag = 20;
	}
	self.weapon = 1;
	self.netname = "shotgun shells";
	setsize (self, VEC_ORIGIN, '32 32 56');
	StartItem ();
};


void () item_spikes =
{
	self.touch = ammo_touch;
	if ((self.spawnflags & WEAPON_BIG2))
	{
		precache_model ("maps/b_nail1.bsp");
		setmodel (self, "maps/b_nail1.bsp");
		self.aflag = 50;
	}
	else
	{
		precache_model ("maps/b_nail0.bsp");
		setmodel (self, "maps/b_nail0.bsp");
		self.aflag = 25;
	}
	self.weapon = 2;
	self.netname = "rounds";
	setsize (self, VEC_ORIGIN, '32 32 56');
	StartItem ();
};


void () item_rockets =
{
	self.touch = ammo_touch;
	if ((self.spawnflags & WEAPON_BIG2))
	{
		precache_model ("maps/b_rock1.bsp");
		setmodel (self, "maps/b_rock1.bsp");
		self.aflag = 10;
	}
	else
	{
		precache_model ("maps/b_rock0.bsp");
		setmodel (self, "maps/b_rock0.bsp");
		self.aflag = 5;
	}
	self.weapon = 3;
	self.netname = "missiles";
	setsize (self, VEC_ORIGIN, '32 32 56');
	StartItem ();
};


void () item_cells =
{
	self.touch = ammo_touch;
	if ((self.spawnflags & WEAPON_BIG2))
	{
		precache_model ("maps/b_batt1.bsp");
		setmodel (self, "maps/b_batt1.bsp");
		self.aflag = 12;
	}
	else
	{
		precache_model ("maps/b_batt0.bsp");
		setmodel (self, "maps/b_batt0.bsp");
		self.aflag = 6;
	}
	self.weapon = CAMPER;
	self.netname = "punisher cells";
	setsize (self, VEC_ORIGIN, '32 32 56');
	StartItem ();
};

float WEAPON_SHOTGUN    = 1;
float WEAPON_ROCKET    = 2;
float WEAPON_SPIKES    = 4;
float WEAPON_BIG    = 8;

void () item_weapon =
{
	self.touch = ammo_touch;
	if ((self.spawnflags & WEAPON_SHOTGUN))
	{
		if ((self.spawnflags & WEAPON_BIG))
		{
			precache_model ("maps/b_shell1.bsp");
			setmodel (self, "maps/b_shell1.bsp");
			self.aflag = 40;
		}
		else
		{
			setmodel (self, "maps/b_shell0.bsp");
			self.aflag = 20;
		}
		self.weapon = 1;
		self.netname = "shotgun shells";
	}
	if ((self.spawnflags & WEAPON_SPIKES))
	{
		if ((self.spawnflags & WEAPON_BIG))
		{
			precache_model ("maps/b_nail1.bsp");
			setmodel (self, "maps/b_nail1.bsp");
			self.aflag = 40;
		}
		else
		{
			setmodel (self, "maps/b_nail0.bsp");
			self.aflag = 20;
		}
		self.weapon = 2;
		self.netname = "rounds";
	}
	if ((self.spawnflags & WEAPON_ROCKET))
	{
		if ((self.spawnflags & WEAPON_BIG))
		{
			precache_model ("maps/b_rock1.bsp");
			setmodel (self, "maps/b_rock1.bsp");
			self.aflag = 10;
		}
		else
		{
			setmodel (self, "maps/b_rock0.bsp");
			self.aflag = 5;
		}
		self.weapon = 3;
		self.netname = "missiles";
	}
	setsize (self, VEC_ORIGIN, '32 32 56');
	StartItem ();
};


void () key_touch =
{
	local entity stemp;
	local float best;

	if ((other.classname != "player"))
		return;
	if ((other.health <= 0))
		return;
	if ((other.items & self.items))
		return;
	sprint (other, self.netname);
	sprint (other, " acquired\n");
	sound (other, CHAN_ITEM, self.noise, 1.00, ATTN_NORM);
	stuffcmd (other, "bf\n");
	other.items = (other.items | self.items);
	if (!coop)
	{
		self.solid = SOLID_NOT;
		self.model = string_null;
	}
	activator = other;
	SUB_UseTargets ();
};


void () item_key1 =
{
	setmodel (self, "progs/b_s_key.mdl");
	self.netname = "Access";
	self.noise = "misc/basekey.wav";
	self.touch = key_touch;
	self.items = IT_KEY1;
	setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
	StartItem ();
};


void () item_key2 =
{
	setmodel (self, "progs/b_g_key.mdl");
	self.netname = "Access";
	self.noise = "misc/basekey.wav";
	self.touch = key_touch;
	self.items = IT_KEY2;
	setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
	StartItem ();
};


void () BackpackTouch =
{
	local string s;
	local float best;
	local entity stemp;

	if ((other.classname != "player"))
		return;
	if ((other.health <= 0))
		return;
	if ((other.probe_active == TRUE))
		return;
	stemp = self;
	self = other;
	if ((self.automount == TRUE))
		best = W_BestWeapon ();
	self = stemp;
	other.ammo_shells2 = (other.ammo_shells2 + self.ammo_shells2);
	other.ammo_nails2 = (other.ammo_nails2 + self.ammo_nails2);
	other.ammo_rockets2 = (other.ammo_rockets2 + self.ammo_rockets2);
	other.ammo_cells2 = (other.ammo_cells2 + self.ammo_cells2);
	other.items = (other.items | self.items);
	bound_other_ammo ();
	sprint (other, "Picked up ");
	if (self.ammo_shells2)
	{
		s = ftos (self.ammo_shells2);
		sprint (other, s);
		sprint (other, " shotgun shells ");
	}
	if (self.ammo_nails2)
	{
		s = ftos (self.ammo_nails2);
		sprint (other, s);
		sprint (other, " rounds ");
	}
	if (self.ammo_rockets2)
	{
		s = ftos (self.ammo_rockets2);
		sprint (other, s);
		sprint (other, " missiles ");
	}
	if (self.ammo_cells2)
	{
		s = ftos (self.ammo_cells2);
		sprint (other, s);
		sprint (other, " punisher cells ");
	}
	sprint (other, "\n");
	stuffcmd (other, "bf\n");
	sound (other, CHAN_ITEM, "weapons/lock4.wav", 1.00, ATTN_NORM);
	stemp = self;
	self = other;
	if (((self.weapon == best) && (self.automount == TRUE)))
	{
		if ((W_BestWeapon () == IT_44))
			UpdateAmmoBars ();
		else
		{
			self.weapon = W_BestWeapon ();
			W_SetCurrentAmmo ();
		}
	}
	if ((self.weapon == IT_44))
		UpdateAmmoBars ();
	else
		W_SetCurrentAmmo ();
	self = stemp;
	remove (self);
};


void () DropBackpack =
{
	local entity item;

	if (!(((self.ammo_shells2 + self.ammo_nails2) + self.ammo_rockets2) + self.ammo_cells2))
		return;
	item = spawn ();
	setorigin (item, (self.origin - '0 0 24'));
	item.classname = "backpack";
	item.items = self.weapon;
	item.ammo_shells2 = self.ammo_shells2;
	item.ammo_nails2 = self.ammo_nails2;
	item.ammo_rockets2 = self.ammo_rockets2;
	item.ammo_cells2 = self.ammo_cells2;
	item.velocity_z = 300;
	item.velocity_x = (-200 + (random () * 200));
	item.velocity_y = (-200 + (random () * 200));
	item.flags = FL_ITEM;
	item.solid = SOLID_TRIGGER;
	item.movetype = MOVETYPE_TOSS;
	if ((self.classname != "player"))
	{
		if ((item.ammo_shells2 > 0))
			setmodel (item, "maps/b_shell0.bsp");
		else
		{
			if ((item.ammo_nails2 > 0))
				setmodel (item, "maps/b_nail0.bsp");
			else
			{
				if ((item.ammo_rockets2 > 0))
					setmodel (item, "maps/b_rock0.bsp");
				else
				{
					if ((item.ammo_cells2 > 0))
						setmodel (item, "maps/b_batt0.bsp");
				}
			}
		}
	}
	else
		setmodel (item, "progs/backpack.mdl");
	setsize (item, '-16 -16 0', '16 16 56');
	item.touch = BackpackTouch;
	item.nextthink = (time + 120);
	item.think = SUB_Remove;
};


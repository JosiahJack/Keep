void() SUB_regen = 
{
	self.model = self.mdl;
	self.solid = SOLID_TRIGGER;
	setorigin(self, self.origin);
};

void() item_health_touch = 
{
	if (other.classname != "player" || other.health < IT_RELIC1)
	{
		return;
	}
	if (!(other.owner))
	{
		return;
	}
	if (other.health >= other.max_health)
	{
		return;
	}
	sound(self, CHAN_ITEM, "misc/pickup.wav", IT_RELIC1, ATTN_NORM);
	sprint(other.owner, "You obtained a ");
	sprint(other.owner, self.classname);
	sprint(other.owner, "\n");
	other.health = other.health + self.cnt;
	if (other.health > other.max_health)
	{
		other.health = other.max_health;
	}
	self.model = string_null;
	self.solid = SOLID_NOT;
	self.think = SUB_regen;
	if (deathmatch)
	{
		self.nextthink = time + 60;
	}
};

void() item_health = 
{
	precache_model("progs/hpot.mdl");
	self.movetype = MOVETYPE_NONE;
	setmodel(self, "progs/hpot.mdl");
	self.mdl = self.model;
	setsize(self, VEC_ORIGIN, VEC_ORIGIN);
	self.solid = SOLID_TRIGGER;
	self.classname = "health potion";
	self.flags = FL_ITEM;
	self.angles_y = 90;
	self.touch = item_health_touch;
	if (!(self.cnt))
	{
		self.cnt = SVC_SIGNONNUM;
	}
	droptofloor();
};

void() item_mana_touch = 
{
	if (other.classname != "player")
	{
		return;
	}
	if (!(other.owner))
	{
		return;
	}
	if (other.owner.ammo_shells >= other.owner.char.max_mana)
	{
		return;
	}
	sound(self, CHAN_ITEM, "misc/pickup.wav", IT_RELIC1, ATTN_NORM);
	sprint(other.owner, "You obtained a ");
	sprint(other.owner, self.classname);
	sprint(other.owner, "\n");
	other.owner.ammo_shells = other.owner.ammo_shells + self.cnt;
	self.model = string_null;
	self.solid = SOLID_NOT;
	self.think = SUB_regen;
	if (deathmatch)
	{
		self.nextthink = time + SVC_INTERMISSION;
	}
};

void() item_mana = 
{
	precache_model("progs/mpot.mdl");
	self.movetype = MOVETYPE_NONE;
	setmodel(self, "progs/mpot.mdl");
	self.mdl = self.model;
	setsize(self, VEC_ORIGIN, VEC_ORIGIN);
	self.solid = SOLID_TRIGGER;
	self.classname = "mana potion";
	self.flags = FL_ITEM;
	self.angles_y = 90;
	self.touch = item_mana_touch;
	if (!(self.cnt))
	{
		self.cnt = SVC_SIGNONNUM;
	}
	droptofloor();
};

void() item_1up_touch = 
{
	if (other.classname != "player")
	{
		return;
	}
	if (!(other.owner))
	{
		return;
	}
	sound(self, CHAN_ITEM, "misc/pickup.wav", IT_RELIC1, ATTN_NORM);
	sprint(other.owner, "You obtained a ");
	sprint(other.owner, self.classname);
	sprint(other.owner, "!\n");
	other.owner.armorvalue = other.owner.armorvalue + IT_RELIC1;
	remove(self);
	return;
};

void() item_1up = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model("progs/freeman.mdl");
	self.movetype = MOVETYPE_NONE;
	setmodel(self, "progs/freeman.mdl");
	setsize(self, '-13 -14 -12', '14 15 13');
	self.solid = SOLID_TRIGGER;
	self.classname = "free live";
	self.flags = FL_ITEM;
	self.touch = item_1up_touch;
	self.alpha = 0.5;
	setorigin(self, self.origin);
};

void() DisplayArmorThink = 
{
	makevectors(self.owner.angles);
	if (self.mode == STATE_TOP)
	{
		if (self.attack_finished > time)
		{
			self.angles_z = self.angles_z + 1500 * frametime;
		}
		else
		{
			if (self.angles_z != STATE_TOP)
			{
				self.mode = IT_RELIC1;
				self.attack_finished = time + IT_RELIC1;
				self.angles_z = STATE_TOP;
			}
		}
	}
	else
	{
		if (self.mode == IT_RELIC1)
		{
			if (self.attack_finished < time)
			{
				self.angles_z = self.angles_z - 1500 * frametime;
				self.velocity_y = -150;
				if (self.alpha > 0.1)
				{
					self.alpha = self.alpha - 0.010000;
				}
				else
				{
					remove(self);
					return;
				}
			}
		}
	}
	if (self.mode == STATE_TOP || self.attack_finished > time)
	{
		setorigin(self, self.owner.origin + v_up * FL_GODMODE);
	}
	self.nextthink = time + 0.010000;
};

void(entity targ) DisplayArmor = 
{
	local entity armoru;
	armoru = spawn();
	setorigin(armoru, targ.origin + v_up * FL_GODMODE);
	setmodel(armoru, "progs/armorup.spr");
	setsize(armoru, VEC_ORIGIN, VEC_ORIGIN);
	armoru.solid = SOLID_NOT;
	armoru.owner = targ;
	armoru.takedamage = DAMAGE_NO;
	armoru.classname = "armorsign";
	armoru.movetype = MOVETYPE_NOCLIP;
	armoru.angles_y = -90;
	armoru.alpha = IT_RELIC1;
	armoru.attack_finished = time + IT_RELIC1;
	armoru.fixangle = 1;
	if (darkplaces)
	{
		armoru.effects = EF_NODEPTHTEST;
	}
	armoru.think = DisplayArmorThink;
	armoru.nextthink = time;
};

void() relic_touch = 
{
	if (other.classname != "player" || other.health <= STATE_TOP)
	{
		return;
	}
	if (self.items & IT_RELIC1)
	{
		bprint("Ledge Grab Obtained!\n");
	}
	else
	{
		if (self.items & IT_RELIC2)
		{
			bprint("Double Jump Obtained!\n");
		}
		else
		{
			if (self.items & IT_RELIC3)
			{
				bprint("Spin Slash Obtained!\n");
			}
			else
			{
				if (self.items & IT_RELIC4)
				{
					bprint("Wall Grab Obtained!\n");
				}
				else
				{
					if (self.items & IT_RELIC5)
					{
						bprint("Wall Run Obtained!\n");
					}
				}
			}
		}
	}
	relics = relics | self.items;
	remove(self);
	return;
};

void() item_relic = 
{
	precache_model("progs/filler.spr");
	self.movetype = MOVETYPE_FLY;
	setmodel(self, "progs/filler.spr");
	setsize(self, VEC_ORIGIN, VEC_ORIGIN);
	self.solid = SOLID_TRIGGER;
	self.classname = "relic1";
	self.flags = FL_ITEM;
	if (self.cnt == STATE_TOP)
	{
		self.items = IT_RELIC1;
	}
	else
	{
		if (self.cnt == IT_RELIC1)
		{
			self.items = IT_RELIC2;
		}
		else
		{
			if (self.cnt == IT_RELIC2)
			{
				self.items = IT_RELIC3;
			}
			else
			{
				if (self.cnt == AS_MELEE)
				{
					self.items = IT_RELIC4;
				}
				else
				{
					if (self.cnt == IT_RELIC3)
					{
						self.items = IT_RELIC5;
					}
				}
			}
		}
	}
	self.touch = relic_touch;
};

void() gold_think = 
{
	if (vlen(self.velocity) < IT_RELIC1 || (self.flags & FL_ONGROUND) || self.velocity_z == STATE_TOP || self.origin == self.oldorigin)
	{
		if (self.angles_x != STATE_TOP || self.angles_z != STATE_TOP)
		{
			self.avelocity = VEC_ORIGIN;
			self.angles_z = STATE_TOP;
			self.angles_x = STATE_TOP;
			sound(self, CHAN_BODY, "misc/gold.wav", IT_RELIC1, ATTN_NORM);
			self.frame = STATE_TOP;
			return;
		}
	}
	self.oldorigin = self.origin;
	frameskip(0.1);
};

void() gold_touch = 
{
	local string h;
	local float i;
	local float j;
	local float k;
	if (self.playerid & other.owner.playerid)
	{
		return;
	}
	if (!(self.flags & FL_ONGROUND))
	{
		return;
	}
	if (other.classname != "player")
	{
		return;
	}
	if (!(other.owner))
	{
		return;
	}
	self.playerid = self.playerid + other.owner.playerid;
	i = STATE_TOP;
	k = IT_RELIC1;
	j = IT_RELIC1;
	while (i < players - IT_RELIC1)
	{
		j = j * IT_RELIC2;
		k = k + j;
		i = i + IT_RELIC1;
	}
	sound(other, CHAN_AUTO, "misc/pickup.wav", IT_RELIC1, ATTN_NORM);
	self.cnt = other.owner.level * TE_LAVASPLASH + floor(random() * TE_LIGHTNING3);
	h = ftos(self.cnt);
	sprint(other.owner, "You have acquired ");
	sprint(other.owner, h);
	sprint(other.owner, " GP / (");
	other.owner.gold = other.owner.gold + self.cnt;
	h = ftos(other.owner.gold);
	sprint(other.owner, h);
	sprint(other.owner, ")\n");
	if (self.playerid >= k)
	{
		remove(self);
		return;
	}
};

void() drop_gold = 
{
	local entity goldg;
	if (deathmatch)
	{
		return;
	}
	goldg = spawn();
	goldg.movetype = MOVETYPE_TOSS;
	setorigin(goldg, self.origin);
	setmodel(goldg, "progs/gold.mdl");
	setsize(goldg, VEC_ORIGIN, VEC_ORIGIN);
	goldg.solid = SOLID_TRIGGER;
	goldg.classname = "gold";
	goldg.flags = FL_ITEM;
	goldg.frame = IT_RELIC1;
	goldg.touch = gold_touch;
	goldg.avelocity = '300 -80 500';
	goldg.think = gold_think;
	goldg.nextthink = time + 0.1;
};

void() item_gold = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	self = spawn();
	setmodel(self, "progs/gold.mdl");
	setsize(self, VEC_ORIGIN, VEC_ORIGIN);
	self.movetype = MOVETYPE_TOSS;
	self.solid = SOLID_TRIGGER;
	self.classname = "gold";
	self.flags = FL_ITEM;
	self.touch = gold_touch;
};


void() quoth_powerup_touch = 
{
	local float best;
	if (other.classname != "player")
	{
		return;
	}
	if (other.health <= MSG_BROADCAST)
	{
		return;
	}
	sprint(other, "You got the ");
	sprint(other, self.netname);
	sprint(other, "\n");
	if (deathmatch)
	{
		self.mdl = self.model;
		self.nextthink = time + 60;
		self.think = SUB_regen;
	}
	sound(other, CHAN_VOICE, self.noise, LIGHTNING_RANDOM, ATTN_NORM);
	stuffcmd(other, "bf\n");
	self.solid = SOLID_NOT;
	other.items2 = other.items2 | self.items2;
	self.model = string_null;
	if (self.classname == "item_artifact_trinity")
	{
		other.trinity_time = LIGHTNING_RANDOM;
		other.trinity_finished = time + SVC_INTERMISSION;
		other.trinity_start = LIGHTNING_RANDOM;
	}
	if (self.classname == "item_artifact_cross")
	{
		other.cross_time = LIGHTNING_RANDOM;
		other.cross_start = LIGHTNING_RANDOM;
		other.cross_finished = time + SVC_INTERMISSION;
	}
	activator = other;
	SUB_UseTargets();
};

void() item_artifact_trinity = 
{
	self.touch = quoth_powerup_touch;
	precache_model("progs/trinity.mdl");
	precache_sound("items2/trintake.wav");
	precache_sound("items2/trinuse.wav");
	precache_sound("items2/trinend.wav");
	self.noise = "items2/trintake.wav";
	setmodel(self, "progs/trinity.mdl");
	self.netname = "Trinity";
	self.items2 = IT_TRINITY;
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
	StartItem();
};

void() item_artifact_cross = 
{
	self.touch = quoth_powerup_touch;
	precache_model("progs/cross.mdl");
	precache_sound("items2/crostake.wav");
	precache_sound("items2/crosend.wav");
	self.noise = "items2/crostake.wav";
	setmodel(self, "progs/cross.mdl");
	self.netname = "Cross of Deflection";
	self.items2 = IT_CROSS;
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
	StartItem();
};

void() hammer_touch = 
{
	local float hadammo;
	local float best;
	local float new;
	local float old_item;
	local float leave;
	if (!(other.flags & FL_CLIENT))
	{
		return;
	}
	stemp = self;
	self = other;
	best = W_BestWeapon();
	self = stemp;
	if (deathmatch == LIGHTNING_BOOM || coop)
	{
		leave = LIGHTNING_RANDOM;
	}
	else
	{
		leave = MSG_BROADCAST;
	}
	if (leave && (other.items2 & IT_HAMMER))
	{
		return;
	}
	hadammo = other.ammo_nails;
	sprint(other, "You got the Hammer\n");
	sound(other, CHAN_ITEM, "weapons/pkup.wav", LIGHTNING_RANDOM, ATTN_NORM);
	stuffcmd(other, "bf\n");
	bound_other_ammo();
	old_item = other.items;
	other.items2 = other.items2 | IT_HAMMER;
	stemp = self;
	self = other;
	if (!deathmatch)
	{
		self.weapon = IT_AXE;
	}
	else
	{
		Deathmatch_Weapon(old_item, new);
	}
	W_SetCurrentAmmo();
	self = stemp;
	if (leave)
	{
		return;
	}
	self.model = string_null;
	self.solid = SOLID_NOT;
	if (deathmatch == LIGHTNING_RANDOM)
	{
		self.nextthink = time + SVC_INTERMISSION;
	}
	self.think = SUB_regen;
	activator = other;
	SUB_UseTargets();
};

void() weapon_hammer = 
{
	precache_model("progs/g_ham.mdl");
	setmodel(self, "progs/g_ham.mdl");
	self.touch = hammer_touch;
	setsize(self, '-16 -16 0', '16 16 56');
	StartItem();
};


void(entity Head) BreakChain = 
{
	local entity link;
	link = Head.goalentity;
	while (link != world)
	{
		Head = link.goalentity;
		remove(link);
		link = Head;
	}
};

void() LinkPos = 
{
	makevectors(self.enemy.angles);
	setorigin(self, self.owner.origin + (self.enemy.origin + v_up * 16 * !(self.enemy.button2) + v_forward * 16 - self.owner.origin) * self.weapon);
	self.nextthink = time + 0.1;
};

entity(entity head, entity tail, float num) MakeChain = 
{
	local entity link;
	local entity prevlink;
	local float linknum;
	linknum = num;
	num = num + 1;
	prevlink = world;
	while (linknum > 0)
	{
		link = spawn();
		link.goalentity = prevlink;
		prevlink = link;
		link.owner = head;
		link.enemy = tail;
		link.weapon = linknum / num;
		link.movetype = MOVETYPE_NOCLIP;
		link.solid = SOLID_NOT;
		link.angles_z = 51 * linknum;
		link.angles_y = 41 * linknum;
		link.angles_x = 31 * linknum;
		link.avelocity = '310 410 510';
		if (!(self.player_flag & ITEM_RUNE5_FLAG))
		{
			setmodel(link, "progs/bit.mdl");
		}
		setsize(link, '0 0 0', '0 0 0');
		makevectors(tail.angles);
		setorigin(link, head.origin + (tail.origin + v_up * 16 * !(tail.button2) + v_forward * 16 - head.origin) * link.weapon);
		link.nextthink = time + 0.1;
		link.think = LinkPos;
		linknum = linknum - 1;
	}
	return link;
};

void() HookVanish = [2, HookDrop2]
{
	self.nextthink = time + 0.05;
};

void() HookDrop2 = [1, HookDrop3]
{
	self.nextthink = time + 0.05;
};

void() HookDrop3 = [0, HookRemove]
{
	self.nextthink = time + 0.05;
};

void() HookRemove = 
{
	self.owner.hook_out = 0;
	sound(self.owner, CHAN_WEAPON, "weapons/null.wav", 1, ATTN_NORM);
	BreakChain(self);
	remove(self);
};

void() HookPull = 
{
	local vector vel;
	local vector spray;
	local float v;
	local float dorg;
	if (!(self.owner.button0) && (self.owner.weapon == IT_EXTRA_WEAPON && self.owner.weapon2 == WE_GRAPPLE) || self.owner.teleport_time > time || self.owner.deadflag)
	{
		HookVanish();
		return;
	}
	else
	{
		if (self.enemy.takedamage)
		{
			if (self.enemy.classname != "player" || !teamplay)
			{
				sound(self, CHAN_WEAPON, "blob/land1.wav", 1, ATTN_NORM);
				T_Damage(self.enemy, self, self.owner, 1);
				makevectors(self.v_angle);
				spray_x = 100 * crandom();
				spray_y = 100 * crandom();
				spray_z = 100 * crandom() + 50;
				SpawnBlood(self.origin, spray, 20);
				if (self.owner.enemy.teleport_time > time)
				{
					HookVanish();
				}
			}
			if (self.enemy.solid == SOLID_SLIDEBOX)
			{
				self.velocity = '0 0 0';
				setorigin(self, self.enemy.origin + self.enemy.mins + self.enemy.velocity + self.enemy.size * 0.5);
			}
			else
			{
				self.velocity = self.enemy.velocity;
			}
		}
		else
		{
			self.velocity = self.enemy.velocity;
		}
		if (self.enemy.solid == SOLID_NOT)
		{
			HookVanish();
			return;
		}
		makevectors(self.owner.angles);
		vel = self.origin - (self.owner.origin + v_up * 16 * !(self.owner.button2) + v_forward * 16);
		v = vlen(vel);
		if (v <= 100)
		{
			vel = normalize(vel) * v * 10;
		}
		if (v > 100)
		{
			vel = normalize(vel) * 1000;
		}
		dorg = vlen(self.owner.origin - self.dest);
		if (dorg > 10 && self.style == 3)
		{
			if (!(self.owner.player_flag & ITEM_RUNE5_FLAG))
			{
				sound(self.owner, CHAN_WEAPON, "weapons/chain2.wav", 1, ATTN_NORM);
			}
			self.style = 2;
		}
		if (dorg < 10 && self.style == 2)
		{
			if (!(self.owner.player_flag & ITEM_RUNE5_FLAG))
			{
				sound(self.owner, CHAN_WEAPON, "weapons/chain3.wav", 1, ATTN_NORM);
			}
			self.style = 3;
		}
		traceline(self.origin, self.owner.origin, 1, self);
		if (trace_fraction != 1)
		{
			HookVanish();
		}
		self.owner.velocity = vel;
		self.dest = self.owner.origin;
		self.nextthink = time + 0.1;
	}
};

void() HookGrab1 = [0, HookGrab2]
{
	self.nextthink = time + 0.05;
};

void() HookGrab2 = [1, HookGrab3]
{
	self.nextthink = time + 0.05;
};

void() HookGrab3 = [2, HookPull]
{
	self.nextthink = time + 0.05;
};

void() T_ChainTouch = 
{
	if (other == self.owner)
	{
		return;
	}
	if (self.owner.deadflag)
	{
		HookRemove();
		return;
	}
	if (other.classname == "no_hook" || other.classname == "func_hurt")
	{
		HookRemove();
		return;
	}
	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		HookRemove();
		return;
	}
	if (other.classname == "player" && teamplay && other.team == self.owner.team)
	{
		return;
	}
	if (other.takedamage)
	{
		if (other.classname == "player")
		{
			other.axhitme = 1;
		}
		else
		{
			if (!(self.owner.player_flag & ITEM_RUNE5_FLAG))
			{
				sound(self, CHAN_WEAPON, "player/axhit2.wav", 1, ATTN_NORM);
			}
		}
		T_Damage(other, self, self.owner, 10);
		SpawnBlood(self.origin, self.velocity, 10);
	}
	else
	{
		if (!(self.owner.player_flag & ITEM_RUNE5_FLAG))
		{
			sound(self, CHAN_WEAPON, "player/axhit2.wav", 1, ATTN_NORM);
		}
		self.avelocity = '0 0 0';
	}
	if (!(self.owner.button0))
	{
		HookRemove();
		return;
	}
	else
	{
		if (other.solid == SOLID_SLIDEBOX)
		{
			setorigin(self, other.origin + other.mins + other.size * 0.5);
			self.velocity = '0 0 0';
		}
		else
		{
			self.velocity = other.velocity;
		}
		self.weapon = other.nextthink - time;
		if (!(self.owner.player_flag & ITEM_RUNE5_FLAG))
		{
			sound(self.owner, CHAN_WEAPON, "weapons/chain2.wav", 1, ATTN_NORM);
		}
		self.style = 2;
		self.enemy = other;
		self.nextthink = time + 0.1;
		self.think = HookPull;
		self.touch = SUB_Null;
		HookGrab1();
	}
};

void() W_FireChain = 
{
	local entity hook;
	self.hook_out = 1;
	hook = spawn();
	hook.owner = self;
	hook.movetype = MOVETYPE_FLY;
	hook.solid = SOLID_BBOX;
	hook.classname = "grapple";
	makevectors(self.v_angle);
	hook.velocity = aim(self, 1000);
	hook.velocity = hook.velocity * 800;
	hook.angles = vectoangles(hook.velocity);
	hook.avelocity = '0 0 -500';
	hook.touch = T_ChainTouch;
	setmodel(hook, "progs/star.mdl");
	setsize(hook, '0 0 0', '0 0 0');
	setorigin(hook, self.origin + v_forward * 16 + '0 0 12');
	self.grpl = hook;
	hook.armorvalue = time + 5;
	hook.nextthink = time + 5;
	hook.think = SUB_Remove;
	if (!(self.player_flag & ITEM_RUNE5_FLAG))
	{
		sound(self, CHAN_WEAPON, "weapons/chain1.wav", 1, ATTN_NORM);
		sound(self, CHAN_AUTO, "weapons/ghfire.wav", 0.5, ATTN_NORM);
	}
	hook.goalentity = MakeChain(hook, self, 3);
};


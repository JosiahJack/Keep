void() damagethreshold_killed = 
{
	self.health = self.max_health;
	activator = damage_attacker;
	self.takedamage = DAMAGE_NO;
	SUB_UseTargets();
	self.takedamage = DAMAGE_YES;
	if (!(self.spawnflags & MULTI_USE))
	{
		remove(self);
	}
};

void() damagethreshold_pain = 
{
	self.health = self.max_health;
};

void() trigger_damagethreshold = 
{
	self.mangle = self.angles;
	self.angles = VEC_ORIGIN;
	self.classname = "damagethreshold";
	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_PUSH;
	setorigin(self, self.origin);
	setmodel(self, self.model);
	setsize(self, self.mins, self.maxs);
	if (self.spawnflags & INVISIBLE)
	{
		self.model = string_null;
	}
	if (!(self.health))
	{
		self.health = 60;
	}
	self.max_health = self.health;
	self.takedamage = DAMAGE_YES;
	self.blocked = SUB_Null;
	self.th_pain = damagethreshold_pain;
	self.th_die = damagethreshold_killed;
};

void() func_breakawaywall_use = 
{
	local float which;
	local float index;
	if (self.cnt != 0)
	{
		if (counter_GetCount(other) != self.cnt)
		{
			return;
		}
	}
	if (self.spawnflags & FL_SWIM)
	{
		WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte(MSG_BROADCAST, TE_EXPLOSION);
		WriteCoord(MSG_BROADCAST, self.origin_x);
		WriteCoord(MSG_BROADCAST, self.origin_y);
		WriteCoord(MSG_BROADCAST, self.origin_z);
	}
	if (self.target)
	{
		SUB_UseTargets();
	}
	if (self.spawnflags & 1)
	{
		BecomeExplosion();
	}
	else
	{
		remove(self);
	}
};

void() func_breakawaywall_die = 
{
	sound(self, CHAN_VOICE, "misc/rublexp.wav", 1, ATTN_NORM);
	ThrowGib("progs/rubble2.mdl", self.health, self.origin);
	ThrowGib("progs/rubble2.mdl", self.health, self.origin);
	ThrowGib("progs/rubble2.mdl", self.health, self.origin);
	func_breakawaywall_use();
};

void() func_breakawaywall = 
{
	self.mangle = self.angles;
	self.angles = VEC_ORIGIN;
	self.classname = "breakaway";
	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_PUSH;
	setorigin(self, self.origin);
	setmodel(self, self.model);
	setsize(self, self.mins, self.maxs);
	self.use = func_breakawaywall_use;
	if (self.health)
	{
		self.takedamage = DAMAGE_AIM;
		self.th_die = func_breakawaywall_die;
		self.classname = "func_wall";
		precache_sound("misc/rublexp.wav");
		precache_model("progs/rubble2.mdl");
	}
};


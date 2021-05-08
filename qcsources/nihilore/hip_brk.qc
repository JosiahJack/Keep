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
	if (self.cnt != SERVOBOD_NONE)
	{
		if (counter_GetCount(other) != self.cnt)
		{
			return;
		}
	}
	self.use = SUB_Null;
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	setorigin(self, self.neworigin);
	if (self.spawnflags & INVISIBLE)
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
	if (self.count)
	{
		self.cnt = SERVOBOD_NONE;
		rubble_use();
	}
	if (self.spawnflags & MULTI_USE)
	{
		BecomeBigExplosion();
		sound(self, CHAN_VOICE, "misc/shortexp.wav", MULTI_USE, ATTN_NORM);
	}
	else
	{
		remove(self);
	}
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
	self.neworigin = (self.absmin + self.absmax) * 0.5;
	if (self.spawnflags & MULTI_USE)
	{
		precache_sound("misc/shortexp.wav");
	}
	if (self.count)
	{
		precache_model("progs/rubble1.mdl");
		precache_model("progs/rubble2.mdl");
		precache_model("progs/rubble3.mdl");
		precache_sound("zombie/z_hit.wav");
		if (self.skin < SERVOBOD_NONE)
		{
			self.skin = floor(random() * 14);
		}
	}
};


void() ltrail_chain = 
{
	SUB_UseTargets();
	self.think = SUB_Null;
};

void() ltrail_fire = 
{
	local entity myTarget;
	if (self.classname != "ltrail_end")
	{
		sound(self, CHAN_VOICE, "weapons/lhit.wav", LT_TOGGLE, ATTN_NORM);
		myTarget = find(world, targetname, self.target);
		WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte(MSG_BROADCAST, TE_LIGHTNING2);
		WriteEntity(MSG_BROADCAST, self);
		WriteCoord(MSG_BROADCAST, self.origin_x);
		WriteCoord(MSG_BROADCAST, self.origin_y);
		WriteCoord(MSG_BROADCAST, self.origin_z);
		WriteCoord(MSG_BROADCAST, myTarget.origin_x);
		WriteCoord(MSG_BROADCAST, myTarget.origin_y);
		WriteCoord(MSG_BROADCAST, myTarget.origin_z);
		LightningDamage(self.origin, myTarget.origin, self, self.currentammo);
	}
	if (self.items < time)
	{
		self.think = ltrail_chain;
		self.nextthink = time + self.frags;
	}
	else
	{
		self.think = ltrail_fire;
		self.nextthink = time + 0.05;
	}
};

void() ltrail_start_fire = 
{
	if (self.spawnflags & LT_TOGGLE)
	{
		if (other.classname != "ltrail_end")
		{
			if (self.spawnflags & LT_ACTIVE)
			{
				self.spawnflags = self.spawnflags - LT_ACTIVE;
				return;
			}
			else
			{
				self.spawnflags = self.spawnflags + LT_ACTIVE;
			}
		}
		else
		{
			if (!(self.spawnflags & LT_ACTIVE))
			{
				return;
			}
		}
	}
	if (self.classname == "ltrail_start")
	{
		self.items = time + self.weapon;
		ltrail_fire();
		self.endtime = time;
	}
	else
	{
		if (self.classname == "ltrail_relay")
		{
			self.items = time + self.weapon;
			ltrail_fire();
		}
		else
		{
			self.think = ltrail_chain;
			self.nextthink = time + self.frags;
		}
	}
};

void() ltrail_start = 
{
	self.endtime = time;
	precache_sound("weapons/lhit.wav");
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_BBOX;
	self.use = ltrail_start_fire;
	if (self.currentammo == ELV_BUTN_DIR)
	{
		self.currentammo = 25;
	}
	if (self.weapon == ELV_BUTN_DIR)
	{
		self.weapon = 0.3;
	}
	if (self.frags == ELV_BUTN_DIR)
	{
		self.frags = 0.3;
	}
	if (self.spawnflags & LT_ACTIVE)
	{
		self.items = time + 100000000;
		self.think = ltrail_fire;
		self.nextthink = time + 0.1;
	}
};

void() ltrail_relay = 
{
	precache_sound("weapons/lhit.wav");
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_BBOX;
	self.use = ltrail_start_fire;
	if (self.currentammo == ELV_BUTN_DIR)
	{
		self.currentammo = 25;
	}
	if (self.weapon == ELV_BUTN_DIR)
	{
		self.weapon = 0.3;
	}
	if (self.frags == ELV_BUTN_DIR)
	{
		self.frags = 0.3;
	}
};

void() ltrail_end = 
{
	precache_sound("weapons/lhit.wav");
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_BBOX;
	self.use = ltrail_start_fire;
	if (self.currentammo == ELV_BUTN_DIR)
	{
		self.currentammo = 25;
	}
	if (self.weapon == ELV_BUTN_DIR)
	{
		self.weapon = 0.3;
	}
	if (self.frags == ELV_BUTN_DIR)
	{
		self.frags = 0.3;
	}
};


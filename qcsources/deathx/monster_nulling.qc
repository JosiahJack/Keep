void() monster_fish = 
{
	remove(self);
	return;
};

void() monster_army = 
{
	remove(self);
	return;
};

void() monster_dog = 
{
	remove(self);
	return;
};

void() monster_boss = 
{
	remove(self);
	return;
};

void() monster_demon1 = 
{
	remove(self);
	return;
};

void() monster_enforcer = 
{
	remove(self);
	return;
};

void() monster_hell_knight = 
{
	remove(self);
	return;
};

void() monster_knight = 
{
	remove(self);
	return;
};

void() monster_ogre = 
{
	remove(self);
	return;
};

void() monster_oldone = 
{
	remove(self);
	return;
};

void() monster_shalrath = 
{
	remove(self);
	return;
};

void() monster_shambler = 
{
	remove(self);
	return;
};

void() monster_tarbaby = 
{
	remove(self);
	return;
};

void() monster_wizard = 
{
	remove(self);
	return;
};

void() monster_zombie = 
{
	remove(self);
	return;
};

void() movetarget_f = 
{
	if (!(self.targetname))
	{
		objerror("monster_movetarget: no targetname");
	}
	self.solid = SOLID_TRIGGER;
	setsize(self, '-8 -8 -8', '8 8 8');
};

void() path_corner = 
{
	movetarget_f();
};

void() Laser_Touch = 
{
	local vector org;
	if (other == self.owner)
	{
		return;
	}
	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	sound(self, CHAN_WEAPON, "enforcer/enfstop.wav", 1, ATTN_STATIC);
	org = self.origin - 8 * normalize(self.velocity);
	if (other.health)
	{
		SpawnBlood(org, self.velocity * 0.2, 15);
		T_Damage(other, self, self.owner, 15);
	}
	else
	{
		WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte(MSG_BROADCAST, TE_GUNSHOT);
		WriteCoord(MSG_BROADCAST, org_x);
		WriteCoord(MSG_BROADCAST, org_y);
		WriteCoord(MSG_BROADCAST, org_z);
	}
	remove(self);
};

void(vector org, vector vec) LaunchLaser = 
{
	if (self.classname == "monster_enforcer")
	{
		sound(self, CHAN_WEAPON, "enforcer/enfire.wav", 1, ATTN_NORM);
	}
	vec = normalize(vec);
	newmis = spawn();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLY;
	newmis.solid = SOLID_BBOX;
	newmis.effects = EF_DIMLIGHT;
	setmodel(newmis, "progs/laser.mdl");
	setsize(newmis, '0 0 0', '0 0 0');
	setorigin(newmis, org);
	newmis.velocity = vec * 600;
	newmis.angles = vectoangles(newmis.velocity);
	newmis.nextthink = time + 5;
	newmis.think = SUB_Remove;
	newmis.touch = Laser_Touch;
};


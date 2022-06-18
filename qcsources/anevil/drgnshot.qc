void(vector org, float misspeed) PM_GetSpot = 
{
	local float dist;
	local float airtime;
	local vector move;
	local vector spot;
	if (self.state < IQ_ULTIMATE)
	{
		return self.enemy.origin;
	}
	dist = vlen(self.enemy.origin - org);
	airtime = dist / misspeed;
	move = self.enemy.velocity;
	move_z = MSG_BROADCAST;
	spot = self.enemy.origin + airtime * move;
	return spot_x;
};

void() PM_DragonFireTouch = 
{
	local entity fire;
	if (other.solid == SOLID_TRIGGER)
	{
		return;
	}
	if (PM_InWater(self))
	{
		PM_MakeSteam(self);
		return;
	}
	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	sound(self, CHAN_WEAPON, "dragon/firehit.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
	self.effects = self.effects | EF_MUZZLEFLASH;
	PM_BurnRadius(self, 70, TE_LIGHTNING2, IQ_GENIUS, 0.1, other);
	self.origin = self.origin - SPAWN_RESPAWN * normalize(self.velocity);
	if (other.takedamage)
	{
		if (other.classname == self.fireowner.classname)
		{
			PM_BurnDamage(other, self, MSG_BROADCAST, SVC_SETVIEWPORT, MSG_BROADCAST);
		}
		else
		{
			PM_BurnDamage(other, self, SVC_SETVIEWANGLES, SVC_SETVIEWPORT, 0.1);
		}
	}
	else
	{
		if (random() < 0.2)
		{
			fire = PM_NewFire(self.fireowner, self, self.origin);
			fire.owner = self.fireowner;
			PM_FireDrop(fire, MSG_BROADCAST);
		}
	}
	BecomeExplosion();
};

void(vector offset) PM_DragonFire = 
{
	local vector dir;
	local vector org;
	local vector spot;
	local float misspeed;
	misspeed = 1200;
	self.effects = self.effects | EF_MUZZLEFLASH;
	makevectors(self.angles);
	org = self.origin + v_forward * offset_x + v_right * offset_y + v_up * offset_z;
	spot = PM_GetSpot(org, misspeed);
	spot_x = spot_x + random() * 48 - 24;
	spot_y = spot_y + random() * 48 - 24;
	spot_z = spot_z + random() * 20 - SVC_SETVIEWANGLES;
	if (self.state > IQ_LOW)
	{
		if (PM_InLiquid(self.enemy))
		{
			spot_z = spot_z + self.enemy.maxs_z * 0.5;
		}
	}
	dir = normalize(spot - org);
	newmis = PM_NewFire(self, self, org);
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BBOX;
	newmis.owner = self;
	newmis.angles = vectoangles(dir) + '90 0 0';
	newmis.touch = PM_DragonFireTouch;
	newmis.nextthink = time;
	newmis.think = PM_CheckFire;
	newmis.burnend = time + TE_LIGHTNING2;
	setsize(newmis, VEC_ORIGIN, VEC_ORIGIN);
	if (PM_InWater(newmis))
	{
		PM_MakeSteam(newmis);
		return;
	}
	newmis.velocity = dir * misspeed;
};

void(vector offset) PM_DragonBolt = 
{
	local vector dir;
	local vector org;
	local vector spot;
	local float damage;
	self.effects = self.effects | EF_MUZZLEFLASH;
	makevectors(self.angles);
	org = self.origin + v_forward * offset_x + v_right * offset_y + v_up * offset_z;
	spot = self.enemy.origin;
	if (self.state > IQ_LOW)
	{
		if (PM_InLiquid(self.enemy))
		{
			spot_z = spot_z + self.enemy.mins_z * 0.5;
		}
	}
	dir = normalize(spot - org);
	traceline(org, org + dir * IT_ROCKETS, 1, self);
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_LIGHTNING2);
	WriteEntity(MSG_BROADCAST, self);
	WriteCoord(MSG_BROADCAST, org_x);
	WriteCoord(MSG_BROADCAST, org_y);
	WriteCoord(MSG_BROADCAST, org_z);
	WriteCoord(MSG_BROADCAST, trace_endpos_x);
	WriteCoord(MSG_BROADCAST, trace_endpos_y);
	WriteCoord(MSG_BROADCAST, trace_endpos_z);
	damage = random() * TE_LIGHTNING2;
	damage = ceil(damage) + IQ_GENIUS;
	PM_CheckForWater(self, org, 100);
	PM_CheckForWater(self, trace_endpos - dir * SPAWN_RESPAWN, 100);
	PM_TraceChain(org, dir, IT_ROCKETS * trace_fraction, damage);
};

void() PM_SpitTouch = 
{
	if (other == self.owner)
	{
		return;
	}
	if (other.solid == SOLID_TRIGGER)
	{
		return;
	}
	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	if (other.takedamage)
	{
		spawn_touchblood(TE_LIGHTNING3);
		T_Damage(other, self, self.owner, TE_LIGHTNING3);
	}
	else
	{
		WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte(MSG_BROADCAST, TE_WIZSPIKE);
		WriteCoord(MSG_BROADCAST, self.origin_x);
		WriteCoord(MSG_BROADCAST, self.origin_y);
		WriteCoord(MSG_BROADCAST, self.origin_z);
	}
	remove(self);
};

void(vector offset) PM_DragonSpit = 
{
	local vector dir;
	local vector org;
	local vector spot;
	local float misspeed;
	misspeed = 1000;
	makevectors(self.angles);
	org = self.origin + v_forward * offset_x + v_right * offset_y + v_up * offset_z;
	spot = PM_GetSpot(org, misspeed);
	dir = normalize(spot - org);
	newmis = spawn();
	setmodel(newmis, "progs/w_spike.mdl");
	setsize(newmis, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(newmis, org);
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BBOX;
	newmis.owner = self;
	newmis.angles = vectoangles(dir);
	newmis.touch = PM_SpitTouch;
	newmis.nextthink = time + TE_LIGHTNING2;
	newmis.think = SUB_Remove;
	newmis.velocity = dir * misspeed;
};

void() PM_BlastTouch = 
{
	if (other == self.owner)
	{
		return;
	}
	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	T_RadiusDamage(self, self.owner, TOOCLOSE_CHARMER_DISTANCE, self.owner);
	if (other.takedamage)
	{
		T_Damage(other, self, self.owner, 40);
	}
	self.origin = self.origin - SPAWN_RESPAWN * normalize(self.velocity);
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord(MSG_BROADCAST, self.origin_x);
	WriteCoord(MSG_BROADCAST, self.origin_y);
	WriteCoord(MSG_BROADCAST, self.origin_z);
	BecomeExplosion();
};

void(vector offset) PM_DragonBlast = 
{
	local vector dir;
	local vector org;
	self.effects = self.effects | EF_MUZZLEFLASH;
	makevectors(self.angles);
	org = self.origin + v_forward * offset_x + v_right * offset_y + v_up * offset_z;
	dir = normalize(self.enemy.origin - org);
	newmis = spawn();
	setmodel(newmis, "progs/k_spike.mdl");
	setsize(newmis, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(newmis, org);
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BBOX;
	newmis.effects = EF_DIMLIGHT;
	newmis.owner = self;
	newmis.angles = vectoangles(dir);
	newmis.touch = PM_BlastTouch;
	newmis.nextthink = time + TE_LIGHTNING2;
	newmis.think = PM_BlastTouch;
	newmis.velocity = dir * 1200;
};


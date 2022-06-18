void() PM_BurnTouch = 
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
	self.effects = self.effects | EF_MUZZLEFLASH;
	PM_BurnRadius(self, 70, TE_LIGHTNING2, IQ_GENIUS, 0.2, other);
	self.origin = self.origin - SPAWN_RESPAWN * normalize(self.velocity);
	if (other.takedamage)
	{
		PM_BurnDamage(other, self, TE_LIGHTNING2, TE_LIGHTNING3, 0.2);
	}
	else
	{
		if (random() < 0.1)
		{
			fire = PM_NewFire(self.fireowner, self, self.origin);
			PM_FireDrop(fire, MSG_BROADCAST);
		}
	}
	BecomeExplosion();
};

void() PM_MakeFlames = 
{
	local vector dir;
	dir = aim(self, 1000);
	dir_x = dir_x + crandom() * 0.160000;
	dir_y = dir_y + crandom() * 0.160000;
	dir_z = dir_z + crandom() * 0.080000;
	newmis = PM_NewFire(self, self, self.origin + '0 0 16');
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BBOX;
	setmodel(newmis, "progs/s_explod.spr");
	newmis.touch = PM_BurnTouch;
	newmis.nextthink = time;
	newmis.think = s_fire1;
	setsize(newmis, VEC_ORIGIN, VEC_ORIGIN);
	if (PM_InWater(newmis))
	{
		PM_MakeSteam(newmis);
		return;
	}
	newmis.velocity = dir * (random() * 600 + 600);
};

void() PM_Flamethrower = 
{
	local vector dir;
	local entity old;
	sound(self, CHAN_WEAPON, "weapons/spike2.wav", FIRE, ATTN_NORM);
	self.attack_finished = time + 0.2;
	self.currentammo = self.ammo_nails = self.ammo_nails - SVC_UPDATESTAT;
	PM_MakeFlames();
	PM_MakeFlames();
	PM_MakeFlames();
};

void(float ox) PM_FireFlameSpikes = 
{
	local vector dir;
	local entity old;
	sound(self, CHAN_WEAPON, "weapons/spike2.wav", FIRE, ATTN_NORM);
	self.attack_finished = time + 0.2;
	self.currentammo = self.ammo_nails = self.ammo_nails - IQ_NORMAL;
	dir = aim(self, 1000);
	newmis = PM_NewFire(self, self, self.origin + '0 0 16' + v_right * ox);
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BBOX;
	newmis.angles = vectoangles(dir) + '90 0 0';
	newmis.touch = PM_BurnTouch;
	newmis.nextthink = time;
	newmis.think = PM_CheckFire;
	newmis.burnend = time + TE_LIGHTNING2;
	setsize(newmis, VEC_ORIGIN, VEC_ORIGIN);
	self.punchangle_x = CONTENT_SOLID;
	if (PM_InWater(newmis))
	{
		PM_MakeSteam(newmis);
		return;
	}
	newmis.velocity = dir * 1000;
};


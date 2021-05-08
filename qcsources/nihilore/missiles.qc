entity(string mismodel, vector misorigin, vector misvelocity) launch_missile = 
{
	local entity missile;
	missile = spawn();
	missile.owner = self;
	missile.solid = SOLID_BBOX;
	setmodel(missile, mismodel);
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(missile, misorigin);
	missile.velocity = misvelocity;
	missile.avelocity = VEC_ORIGIN;
	missile.angles = vectoangles(missile.velocity);
	if (mismodel == "progs/laser.mdl")
	{
		missile.classname = "laser";
		missile.movetype = MOVETYPE_FLY;
		missile.effects = EF_DIMLIGHT;
		missile.nextthink = time + SVC_SETVIEWPORT;
		missile.attack_finished = missile.nextthink;
		missile.think = SUB_Remove;
		missile.touch = M_Laser_Touch;
		missile.ammo_shells = 15;
		missile.ammo_nails = MSG_BROADCAST;
	}
	else
	{
		if (mismodel == "progs/grenade.mdl")
		{
			missile.classname = "grenade";
			missile.movetype = MOVETYPE_BOUNCE;
			missile.avelocity = '300 300 300';
			missile.think = M_Grenade_Explode;
			missile.touch = M_Grenade_Touch;
			missile.ammo_shells = 100;
			missile.ammo_nails = MSG_BROADCAST;
			missile.gravity = self.gravity;
			missile.nextthink = time + SPAWN_SLEEPING + SPAWN_CRUCIFIED / missile.gravity;
			if (missile.nextthink < time + SPAWN_CRUCIFIED)
			{
				missile.nextthink = time + SPAWN_CRUCIFIED;
			}
			if (missile.nextthink > time + 15)
			{
				missile.nextthink = time + 15;
			}
			missile.attack_finished = missile.nextthink;
		}
		else
		{
			if (mismodel == "progs/missile.mdl")
			{
				missile.classname = "missile";
				missile.movetype = MOVETYPE_FLY;
				missile.effects = EF_DIMLIGHT;
				missile.nextthink = time + SVC_SETVIEWPORT;
				missile.attack_finished = missile.nextthink;
				missile.think = SUB_Remove;
				missile.touch = M_Missile_Touch;
				missile.ammo_shells = 100;
				missile.ammo_nails = MSG_BROADCAST;
			}
			else
			{
				if (mismodel == "progs/lavaball.mdl")
				{
					missile.classname = "lavaball";
					missile.solid = SOLID_TRIGGER;
					missile.movetype = MOVETYPE_TOSS;
					missile.avelocity = '300 300 300';
					missile.think = M_Grenade_Explode;
					missile.touch = M_Grenade_Explode;
					missile.ammo_shells = 100;
					missile.ammo_nails = MSG_BROADCAST;
					missile.gravity = self.gravity;
					missile.effects = EF_DIMLIGHT;
					missile.nextthink = time + SPAWN_SLEEPING + SPAWN_CRUCIFIED / missile.gravity;
					if (missile.nextthink < time + SPAWN_CRUCIFIED)
					{
						missile.nextthink = time + SPAWN_CRUCIFIED;
					}
					if (missile.nextthink > time + 15)
					{
						missile.nextthink = time + 15;
					}
					missile.attack_finished = missile.nextthink;
				}
				else
				{
					if (mismodel == "progs/spike.mdl" || mismodel == "progs/s_spike.mdl")
					{
						missile.classname = "spike";
						missile.movetype = MOVETYPE_FLY;
						setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
						missile.nextthink = time + TE_LIGHTNING2;
						missile.attack_finished = missile.nextthink;
						missile.think = SUB_Remove;
						missile.touch = M_Spike_Touch;
						if (mismodel == "progs/s_spike.mdl")
						{
							missile.ammo_shells = 18;
						}
						else
						{
							missile.ammo_shells = TE_LIGHTNING3;
						}
						missile.ammo_nails = MSG_BROADCAST;
					}
					else
					{
						if (mismodel == "progs/k_spike.mdl" || mismodel == "progs/w_spike.mdl")
						{
							if (mismodel == "progs/w_spike.mdl")
							{
								missile.classname = "wizspike";
							}
							else
							{
								missile.classname = "knightspike";
							}
							missile.movetype = MOVETYPE_FLY;
							setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
							missile.nextthink = time + TE_LIGHTNING2;
							missile.attack_finished = missile.nextthink;
							missile.think = SUB_Remove;
							missile.touch = M_Spike_Touch;
							missile.ammo_shells = TE_LIGHTNING3;
							missile.ammo_nails = MSG_BROADCAST;
						}
						else
						{
							if (mismodel == "progs/arrow.mdl")
							{
								missile.classname = "arrow";
								missile.movetype = MOVETYPE_TOSS;
								setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
								missile.nextthink = time + 0.05;
								missile.attack_finished = time + SVC_SETVIEWPORT;
								missile.gravity = self.gravity;
								missile.think = M_Arrow_Point;
								missile.touch = M_Arrow_Touch;
								missile.ammo_shells = 15;
								missile.ammo_nails = SVC_SETVIEWPORT;
							}
						}
					}
				}
			}
		}
	}
	return missile;
};

void(entity missile, float basedamage, float randdamage) setdmg_missile = 
{
	missile.ammo_shells = basedamage;
	missile.ammo_nails = randdamage;
};

void(entity missile, float misnextthink, <function> misthink, <function> mistouch, float basedamage, float randdamage) setup_missile = 
{
	missile.nextthink = time + misnextthink;
	missile.think = misthink;
	missile.touch = mistouch;
	missile.ammo_shells = basedamage;
	missile.ammo_nails = randdamage;
};

void(entity missile, vector mistarget, float targeting) target_missile = 
{
	local vector misvelocity;
	misvelocity = missile.velocity;
	if (targeting == SPAWN_CRUCIFIED)
	{
		missile.velocity = normalize(mistarget - missile.origin);
		missile.velocity = missile.velocity * misvelocity_x;
	}
	else
	{
		if (targeting == SPAWN_SLEEPING)
		{
			missile.velocity = normalize(mistarget - self.origin);
			missile.velocity = missile.velocity * misvelocity_x;
			missile.velocity_z = misvelocity_z;
		}
		else
		{
			if (targeting == SVC_UPDATESTAT)
			{
				missile.velocity = normalize(mistarget + '0 0 16' - missile.origin);
				missile.angles = vectoangles(missile.velocity);
				makevectors(missile.angles);
				missile.velocity = missile.velocity * misvelocity_x + v_up * misvelocity_z;
			}
			else
			{
				if (targeting == SPAWN_DEAD)
				{
					missile.velocity = normalize(mistarget - missile.origin);
					missile.velocity = missile.velocity * vlen(misvelocity);
				}
				else
				{
					if (targeting == SVC_SETVIEWPORT)
					{
						missile.velocity = mistarget - missile.origin;
						missile.angles = vectoangles(missile.velocity);
						makevectors(missile.angles);
						missile.velocity = mistarget + v_right * misvelocity_y + v_up * misvelocity_z;
						missile.velocity = normalize(missile.velocity - missile.origin);
						missile.velocity = missile.velocity * misvelocity_x;
					}
				}
			}
		}
	}
	missile.angles = vectoangles(missile.velocity);
};

void() s2_explode1 = [0, s2_explode2]
{
	self.nextthink = 0.05;
};

void() s2_explode2 = [1, s2_explode3]
{
	self.nextthink = 0.05;
};

void() s2_explode3 = [2, s2_explode4]
{
	self.nextthink = 0.05;
};

void() s2_explode4 = [3, s2_explode5]
{
	self.nextthink = 0.05;
};

void() s2_explode5 = [4, s2_explode6]
{
	self.nextthink = 0.05;
};

void() s2_explode6 = [5, s2_explode7]
{
	self.nextthink = 0.05;
	self.effects = MSG_BROADCAST;
};

void() s2_explode7 = [6, s2_explode8]
{
	self.nextthink = 0.05;
};

void() s2_explode8 = [7, s2_explode9]
{
	self.nextthink = 0.05;
};

void() s2_explode9 = [8, s2_explode10]
{
	self.nextthink = 0.05;
};

void() s2_explode10 = [9, s2_explode11]
{
	self.nextthink = 0.05;
};

void() s2_explode11 = [10, s2_explode12]
{
	self.nextthink = 0.05;
};

void() s2_explode12 = [11, s2_explode13]
{
	self.nextthink = 0.05;
};

void() s2_explode13 = [12, s2_explode14]
{
	self.nextthink = 0.05;
};

void() s2_explode14 = [13, s2_explode15]
{
	self.nextthink = 0.05;
};

void() s2_explode15 = [14, s2_explode16]
{
	self.nextthink = 0.05;
};

void() s2_explode16 = [15, s2_explode17]
{
	self.nextthink = 0.05;
};

void() s2_explode17 = [16, SUB_Remove]
{
	self.nextthink = 0.05;
};

void() s2dm_explode1 = [1, s2dm_explode2]
{
};

void() s2dm_explode2 = [3, s2dm_explode3]
{
};

void() s2dm_explode3 = [5, s2dm_explode4]
{
};

void() s2dm_explode4 = [7, s2dm_explode5]
{
};

void() s2dm_explode5 = [9, s2dm_explode6]
{
};

void() s2dm_explode6 = [11, s2dm_explode7]
{
};

void() s2dm_explode7 = [13, s2dm_explode8]
{
};

void() s2dm_explode8 = [15, SUB_Remove]
{
};

void() BecomeBigExplosion = 
{
	self.movetype = MOVETYPE_NONE;
	self.velocity = VEC_ORIGIN;
	self.touch = SUB_Null;
	setmodel(self, "progs/expl.spr");
	self.solid = SOLID_NOT;
	if (deathmatch)
	{
		s2dm_explode1();
	}
	else
	{
		s2_explode1();
	}
};

void() M_Grenade_Explode = 
{
	local float totaldmg;
	totaldmg = self.ammo_shells + random() * self.ammo_nails;
	T_RadiusDamage(self, self.owner, totaldmg, world);
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord(MSG_BROADCAST, self.origin_x);
	WriteCoord(MSG_BROADCAST, self.origin_y);
	WriteCoord(MSG_BROADCAST, self.origin_z);
	BecomeExplosion();
};

void() M_Grenade_Touch = 
{
	if (other == self.owner)
	{
		return;
	}
	if (other.takedamage == DAMAGE_AIM)
	{
		M_Grenade_Explode();
		return;
	}
	sound(self, CHAN_WEAPON, "weapons/bounce.wav", SPAWN_CRUCIFIED, ATTN_NORM);
	if (self.velocity == VEC_ORIGIN)
	{
		self.avelocity = VEC_ORIGIN;
	}
};

void() M_Laser_Touch = 
{
	local float totaldmg;
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
	totaldmg = self.ammo_shells + random() * self.ammo_nails;
	if (self.ammo_shells + self.ammo_nails == MSG_BROADCAST)
	{
		totaldmg = 15;
	}
	org = self.origin - SECRET_NO_SHOOT * normalize(self.velocity);
	if (other.health)
	{
		if (other.flags & FL_CLIENT || (other.flags & FL_MONSTER))
		{
			SpawnBlood(org, self.velocity * 0.2, totaldmg, other);
		}
		T_Damage(other, self, self.owner, totaldmg);
	}
	else
	{
		sound(self, CHAN_WEAPON, "enforcer/enfstop.wav", SPAWN_CRUCIFIED, ATTN_STATIC);
		WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte(MSG_BROADCAST, TE_GUNSHOT);
		WriteCoord(MSG_BROADCAST, org_x);
		WriteCoord(MSG_BROADCAST, org_y);
		WriteCoord(MSG_BROADCAST, org_z);
	}
	remove(self);
};

void() M_Missile_Touch = 
{
	local float totaldmg;
	if (other == self.owner)
	{
		return;
	}
	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	totaldmg = self.ammo_shells + random() * self.ammo_nails;
	if (other.health)
	{
		if (self.owner.classname == "monster_shalrath")
		{
			if (other.classname == "monster_zombie")
			{
				T_Damage(other, self, self, 110);
			}
			else
			{
				if (other.classname == "monster_axzombie")
				{
					T_Damage(other, self, self.owner, 200);
				}
			}
		}
		else
		{
			if (other.classname == "monster_shambler")
			{
				T_Damage(other, self, self.owner, totaldmg * 0.5 + SVC_SETVIEWANGLES);
			}
			else
			{
				T_Damage(other, self, self.owner, totaldmg + 20);
			}
		}
	}
	else
	{
		if (self.classname == "pulse")
		{
			sound(self, CHAN_VOICE, "enforcer/enfstop.wav", SPAWN_CRUCIFIED, ATTN_STATIC);
			remove(self);
			return;
		}
	}
	if (self.owner.classname == "monster_shalrath")
	{
		T_RadiusDamage(self, self.owner, totaldmg, world);
	}
	else
	{
		T_RadiusDamage(self, self.owner, totaldmg, other);
	}
	sound(self, CHAN_WEAPON, "weapons/r_exp3.wav", SPAWN_CRUCIFIED, ATTN_NORM);
	self.origin = self.origin - SECRET_NO_SHOOT * normalize(self.velocity);
	sound(self, CHAN_WEAPON, "weapons/r_exp3.wav", SPAWN_CRUCIFIED, ATTN_NORM);
	BecomeBigExplosion();
};

void() M_Spike_Touch = 
{
	local float rand;
	local float totaldmg;
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
		totaldmg = self.ammo_shells + random() * self.ammo_nails;
		T_Damage(other, self, self.owner, totaldmg);
		spawn_touchblood(totaldmg, other);
		remove(self);
		return;
	}
	else
	{
		WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
		if (self.classname == "wizspike")
		{
			WriteByte(MSG_BROADCAST, TE_WIZSPIKE);
		}
		else
		{
			if (self.classname == "knightspike")
			{
				WriteByte(MSG_BROADCAST, TE_KNIGHTSPIKE);
			}
			else
			{
				WriteByte(MSG_BROADCAST, TE_SPIKE);
			}
		}
		WriteCoord(MSG_BROADCAST, self.origin_x);
		WriteCoord(MSG_BROADCAST, self.origin_y);
		WriteCoord(MSG_BROADCAST, self.origin_z);
	}
	if (self.classname == "dspike" && random() < 0.33)
	{
		remove(self);
		return;
	}
	remove(self);
};

void() M_Arrow_Point = 
{
	self.nextthink = time + 0.05;
	self.angles = vectoangles(self.velocity);
};

void() M_Arrow_Touch = 
{
	local float rand;
	local float totaldmg;
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
		sound(other, CHAN_BODY, "weapons/arrowhit.wav", SPAWN_CRUCIFIED, ATTN_NORM);
		totaldmg = self.ammo_shells + random() * self.ammo_nails;
		if (other.flags & FL_CLIENT || (other.flags & FL_MONSTER))
		{
			spawn_touchblood(totaldmg, other);
		}
		T_Damage(other, self, self.owner, totaldmg);
		remove(self);
		return;
	}
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_SPIKE);
	WriteCoord(MSG_BROADCAST, self.origin_x);
	WriteCoord(MSG_BROADCAST, self.origin_y);
	WriteCoord(MSG_BROADCAST, self.origin_z);
	self.nextthink = time + SPAWN_CRUCIFIED + random() * SPAWN_CRUCIFIED;
	self.think = SUB_Remove;
};


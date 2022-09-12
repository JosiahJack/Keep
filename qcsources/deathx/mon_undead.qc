void(float v) anglemod = 
{
	while (v >= 360)
	{
		v = v - 360;
	}
	while (v < 0)
	{
		v = v + 360;
	}
	return v;
};

void() SetAngle = 
{
	local vector vlead;
	local vector evec;
	local vector d;
	local vector org;
	local vector eorg;
	local vector face_vec;
	local float fly;
	org = self.origin + '0 0 16';
	eorg = self.enemy.origin + '0 0 16';
	evec = self.enemy.velocity;
	evec_z = 0;
	face_vec = normalize(eorg + '0 0 8' - org);
	if (self.weapon == IT_NAILGUN || self.weapon == IT_SUPER_NAILGUN || self.weapon == IT_ROCKET_LAUNCHER)
	{
		fly = vlen(eorg - org) / 1000;
	}
	else
	{
		if (self.weapon == IT_GRENADE_LAUNCHER)
		{
			fly = vlen(eorg - org) / 600;
		}
		else
		{
			fly = 0;
		}
	}
	d = eorg + fly * evec;
	vlead = normalize(d - org);
	self.angles = vectoangles(face_vec);
	self.angles_x = self.angles_x / 3;
	if (face_vec_z < 0)
	{
		self.angles_x = self.angles_x * -1;
	}
	if (self.angles_x < -26.2)
	{
		self.angles_x = -26.2;
	}
	if (self.angles_x > 23)
	{
		self.angles_x = 23;
	}
};

entity() GetTarget = 
{
	local float rang;
	local float selrange;
	local entity selected;
	local entity head;
	selrange = 5001;
	selected = world;
	head = findradius(self.origin, 5000);
	while (head)
	{
		if (head.classname == "player" && head.health > 0 && head != self.own)
		{
			rang = vlen(self.origin - head.origin);
			if (rang < selrange)
			{
				if (!(head.items & IT_INVULNERABILITY || (head.items & IT_INVISIBILITY)) && visible(head) && infront(head))
				{
					self.canattack = 0;
				}
				if (random() < 0.75)
				{
					selected = head;
				}
			}
		}
		head = head.chain;
	}
	self.goalentity = selected;
	return selected;
};

void() undead_run1 = [6, undead_run2]
{
	movetogoal(10);
};

void() undead_run2 = [7, undead_run3]
{
	movetogoal(10);
};

void() undead_run3 = [8, undead_run4]
{
	movetogoal(10);
};

void() undead_run4 = [9, undead_run5]
{
	movetogoal(10);
};

void() undead_run5 = [10, undead_run6]
{
	movetogoal(10);
};

void() undead_run6 = [11, undead_run1]
{
	movetogoal(10);
	ZombieStandThink();
};

void() undead_stand1 = [12, undead_stand2]
{
	ZombieStandThink();
};

void() undead_stand2 = [13, undead_stand3]
{
	SetAngle();
};

void() undead_stand3 = [14, undead_stand4]
{
	ZombieStandThink();
};

void() undead_stand4 = [15, undead_stand5]
{
};

void() undead_stand5 = [16, undead_stand1]
{
	ZombieStandThink();
};

void() undead_fireshotgun = 
{
	local vector dir;
	local entity en;
	en = self.enemy;
	dir = en.origin - en.velocity * 0.2;
	dir = normalize(dir - self.origin);
	if (self.weapon == IT_SUPER_SHOTGUN)
	{
		sound(self, CHAN_WEAPON, "weapons/shotgn2.wav", 1, ATTN_NORM);
		ZombieThink();
		FireBullets(14, dir, '0.13 0.05 0');
		self.attack_finished = time + 0.76;
		return;
	}
	sound(self, CHAN_WEAPON, "weapons/guncock.wav", 1, ATTN_NORM);
	ZombieThink();
	FireBullets(4, dir, '0.030000 0.05 0');
	self.attack_finished = time + 0.6;
};

void() undead_shot1 = [113, undead_shot2]
{
	undead_fireshotgun();
	self.effects = self.effects | EF_MUZZLEFLASH;
};

void() undead_shot2 = [114, undead_shot3]
{
	SetAngle();
};

void() undead_shot3 = [115, undead_shot4]
{
};

void() undead_shot4 = [116, undead_shot5]
{
	SetAngle();
};

void() undead_shot5 = [117, undead_shot6]
{
};

void() undead_shot6 = [118, undead_stand1]
{
	SetAngle();
};

void() U_FireSuperSpikes = 
{
	local vector dir;
	local float tempx;
	self.attack_finished = time + 0.2;
	dir = self.enemy.origin - self.origin;
	tempx = vlen(dir);
	dir = dir + tempx / 1000 * self.enemy.velocity * 0.8;
	dir = normalize(dir);
	launch_spike(self.origin + '0 0 16', dir);
	newmis.touch = superspike_touch;
	setmodel(newmis, "progs/s_spike.mdl");
	setsize(newmis, VEC_ORIGIN, VEC_ORIGIN);
	self.punchangle_x = -2;
};

void(float ox) U_FireSpikes = 
{
	local vector dir;
	local float tempx;
	makevectors(self.v_angle);
	if (self.weapon == IT_SUPER_NAILGUN)
	{
		sound(self, CHAN_WEAPON, "weapons/spike2.wav", 1, ATTN_NORM);
		U_FireSuperSpikes();
		return;
	}
	sound(self, CHAN_WEAPON, "weapons/rocket1i.wav", 1, ATTN_NORM);
	self.attack_finished = time + 0.2;
	dir = self.enemy.origin - self.origin;
	tempx = vlen(dir);
	dir = dir + tempx / 1000 * self.enemy.velocity;
	dir_x = dir_x + (random() * 80 - 40);
	dir_y = dir_y + (random() * 80 - 40);
	dir_z = dir_z + (random() * 80 - 40);
	dir = normalize(dir);
	launch_spike(self.origin + '0 0 16' + v_right * ox, dir);
	self.punchangle_x = -2;
};

void() undead_nail1 = [103, undead_nail2]
{
	self.effects = self.effects | EF_MUZZLEFLASH;
	SetAngle();
	ZombieThink();
	U_FireSpikes(4);
	self.attack_finished = time + 0.3;
};

void() undead_nail2 = [104, undead_nail1]
{
	self.effects = self.effects | EF_MUZZLEFLASH;
	SetAngle();
	ZombieThink();
	U_FireSpikes(-4);
	self.attack_finished = time + 0.3;
};

void() U_FireLightning = 
{
	local vector org;
	local vector dir;
	local vector miss;
	if (self.waterlevel > 1 || pointcontents(self.origin) == CONTENT_WATER)
	{
		self.ammo_cells = 25;
		T_RadiusDamage(self, self, 35 * self.ammo_cells, world);
		self.ammo_cells = 0;
		return;
	}
	dir = self.enemy.origin - self.origin;
	if (vlen(dir) > 600)
	{
		return;
	}
	if (self.t_width < time)
	{
		sound(self, CHAN_WEAPON, "weapons/lhit.wav", 1, ATTN_NORM);
		self.t_width = time + 0.6;
	}
	self.effects = self.effects | EF_MUZZLEFLASH;
	org = self.origin + '0 0 16';
	miss_x = random() * 70 - 35;
	miss_y = random() * 70 - 35;
	miss_z = random() * 80 - 40;
	traceline(org, org + dir + miss, 1, self);
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_LIGHTNING2);
	WriteEntity(MSG_BROADCAST, self);
	WriteCoord(MSG_BROADCAST, org_x);
	WriteCoord(MSG_BROADCAST, org_y);
	WriteCoord(MSG_BROADCAST, org_z);
	WriteCoord(MSG_BROADCAST, trace_endpos_x);
	WriteCoord(MSG_BROADCAST, trace_endpos_y);
	WriteCoord(MSG_BROADCAST, trace_endpos_z);
	LightningDamage(self.origin, trace_endpos, self, 30);
};

void() undead_light1 = [105, undead_light2]
{
	SetAngle();
	U_FireLightning();
	self.attack_finished = time + 0.1;
};

void() undead_light2 = [106, undead_light1]
{
	SetAngle();
	U_FireLightning();
	self.attack_finished = time + 0.1;
	ZombieThink();
};

void() U_FireRocket = 
{
	local entity missile;
	local entity mpuff;
	local vector dir;
	local float tempx;
	local vector en;
	sound(self, CHAN_WEAPON, "weapons/sgun1.wav", 1, ATTN_NORM);
	missile = spawn();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	missile.classname = "missile";
	en = self.enemy.origin;
	en_x = en_x - 50 + random() * 100;
	en_y = en_y - 50 + random() * 100;
	en_z = en_z - 50 + random() * 100;
	dir = en - self.origin - '0 0 16';
	tempx = vlen(dir);
	dir = dir + tempx / 1000 * self.enemy.velocity * 0.7;
	dir = normalize(dir);
	missile.velocity = dir;
	missile.velocity = missile.velocity * 1000;
	missile.angles = vectoangles(missile.velocity);
	missile.touch = T_MissileTouch;
	missile.nextthink = time + 5;
	missile.think = SUB_Remove;
	setmodel(missile, "progs/missile.mdl");
	setsize(missile, '0 0 0', '0 0 0');
	setorigin(missile, self.origin + v_forward * 8 + '0 0 16');
};

void() U_FireGrenade = 
{
	local entity missile;
	local entity mpuff;
	self.effects = self.effects | EF_MUZZLEFLASH;
	sound(self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM);
	missile = spawn();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
	makevectors(self.angles);
	missile.velocity = v_forward * vlen(self.origin - self.enemy.origin) * (2 + random());
	if (self.enemy.origin_z > self.origin_z)
	{
		missile.velocity_z = missile.velocity_z + (self.enemy.origin_z - self.origin_z + vlen(self.origin - self.enemy.origin) * 0.5);
	}
	if (vlen(missile.velocity) < 20)
	{
		missile.velocity = missile.velocity * 5;
	}
	missile.avelocity = '300 300 300';
	missile.angles = vectoangles(missile.velocity);
	missile.touch = GrenadeTouch;
	missile.nextthink = time + 2.5;
	missile.think = GrenadeExplode;
	setmodel(missile, "progs/grenade.mdl");
	setsize(missile, '0 0 0', '0 0 0');
	setorigin(missile, self.origin + '0 0 16');
};

void() undead_rocket1 = [107, undead_rocket2]
{
	self.effects = self.effects | EF_MUZZLEFLASH;
};

void() undead_rocket2 = [108, undead_rocket3]
{
};

void() undead_rocket3 = [109, undead_rocket4]
{
	SetAngle();
};

void() undead_rocket4 = [110, undead_rocket5]
{
};

void() undead_rocket5 = [111, undead_rocket6]
{
	SetAngle();
};

void() undead_rocket6 = [112, undead_stand1]
{
	SetAngle();
};

void() undead_died1 = [85, undead_died2]
{
};

void() undead_died2 = [86, undead_died3]
{
};

void() undead_died3 = [87, undead_died4]
{
};

void() undead_died4 = [88, undead_died5]
{
};

void() undead_died5 = [89, undead_died6]
{
};

void() undead_died6 = [90, undead_died7]
{
};

void() undead_died7 = [91, undead_died8]
{
};

void() undead_died8 = [92, undead_died9]
{
};

void() undead_died9 = [93, undead_up1]
{
};

void() undead_up1 = [93, undead_up2]
{
	SetAngle();
};

void() undead_up2 = [92, undead_up3]
{
};

void() undead_up3 = [91, undead_up4]
{
	SetAngle();
};

void() undead_up4 = [90, undead_up5]
{
};

void() undead_up5 = [89, undead_up6]
{
	SetAngle();
};

void() undead_up6 = [88, undead_up7]
{
	SetAngle();
};

void() undead_up7 = [87, undead_up8]
{
	SetAngle();
};

void() undead_up8 = [86, undead_up9]
{
	SetAngle();
};

void() undead_up9 = [85, undead_stand1]
{
	SetAngle();
	self.health = 60;
};

float() UndeadCheckAttack = 
{
	if (self.attack_finished > time)
	{
		return 0;
	}
	if (self.enemy.health < 0)
	{
		return 0;
	}
	if (self.enemy.items & IT_INVISIBILITY)
	{
		return 0;
	}
	if (!infront(self.enemy))
	{
		return 0;
	}
	if (!visible(self.enemy))
	{
		return 0;
	}
	if (random() > 0.75)
	{
		return 0;
	}
	if (vlen(self.enemy.origin - self.origin) < 801)
	{
		if (random() > 0.5)
		{
			return 1;
		}
	}
	if (vlen(self.enemy.origin - self.origin) > 800)
	{
		return 2;
	}
	self.canattack = 1;
	return 1;
};

void() UndeadShoot = 
{
	if (!UndeadCheckAttack())
	{
		return;
	}
	if (self.canattack != 1)
	{
		return;
	}
	if (self.weapon == IT_SHOTGUN)
	{
		undead_shot1();
	}
	else
	{
		if (self.weapon == IT_SUPER_SHOTGUN)
		{
			undead_shot1();
		}
		else
		{
			if (self.weapon == IT_NAILGUN)
			{
				undead_nail1();
			}
			else
			{
				if (self.weapon == IT_SUPER_NAILGUN)
				{
					undead_nail1();
				}
				else
				{
					if (self.weapon == IT_ROCKET_LAUNCHER)
					{
						self.attack_finished = time + 1;
						U_FireRocket();
						undead_rocket1();
					}
					else
					{
						if (self.weapon == IT_GRENADE_LAUNCHER)
						{
							self.attack_finished = time + 1;
							U_FireGrenade();
							undead_rocket1();
						}
						else
						{
							if (self.weapon == IT_LIGHTNING)
							{
								undead_light1();
							}
						}
					}
				}
			}
		}
	}
};

void() GibZombie = 
{
	ThrowHead("progs/h_undead.mdl", self.health);
	ThrowGib("progs/gib1.mdl", self.health);
	ThrowGib("progs/gib2.mdl", self.health);
	ThrowGib("progs/gib3.mdl", self.health);
	ThrowGib("progs/gib1.mdl", self.health);
	ThrowGib("progs/gib2.mdl", self.health);
	ThrowGib("progs/gib3.mdl", self.health);
	self.deadflag = DEAD_DEAD;
	self.solid = SOLID_NOT;
	if (random() < 0.5)
	{
		sound(self, CHAN_VOICE, "player/gib.wav", 1, ATTN_NONE);
	}
	else
	{
		sound(self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NONE);
	}
	self.nextthink = time + 20;
	self.think = SUB_Remove;
};

void() ZombieThink = 
{
	if (pointcontents(self.origin) == CONTENT_LAVA || pointcontents(self.origin) == CONTENT_SLIME)
	{
		self.th_die();
	}
	if (self.air_finished < time && self.air_finished && self.dmgtime < time)
	{
		self.dmgtime = time + 1;
		T_Damage(self, world, world, 4 * self.waterlevel);
	}
	if (pointcontents(self.origin) == CONTENT_WATER && self.air_finished == 0)
	{
		self.air_finished = time + 12;
	}
	if (self.health < 0)
	{
		self.th_die();
	}
	if (self.health < 30)
	{
		self.health = 60;
		undead_died1();
		return;
	}
	if (self.attack_finished < time)
	{
		return;
	}
	if (!UndeadCheckAttack())
	{
		undead_stand1();
	}
};

void() ZombieStandThink = 
{
	SetAngle();
	if (self.goalentity)
	{
		if (!(vlen(self.origin - self.enemy.origin) < 300))
		{
			if (self.walkframe >= 6)
			{
				self.walkframe = 0;
			}
			self.frame = 6 + self.walkframe;
			self.velocity = v_forward * 16;
			movetogoal(12);
			self.walkframe = self.walkframe + 1;
		}
	}
	if (!(self.enemy) || !visible(self.enemy))
	{
		self.enemy = GetTarget();
	}
	if (pointcontents(self.origin) == CONTENT_LAVA || pointcontents(self.origin) == CONTENT_SLIME)
	{
		self.th_die();
	}
	if (self.health < 0)
	{
		self.th_die();
	}
	if (self.health < 30)
	{
		self.health = 60;
		undead_died1();
		return;
	}
	if (self.attack_finished < time && self.enemy != world && self.enemy.health > 0 && random() > 0.5)
	{
		UndeadShoot();
		return;
	}
};

void(entity loser) CreateBody = 
{
	local entity u;
	u = spawn();
	u.own = loser.enemy;
	u.classname = "undead";
	u.netname = "undead";
	u.health = 60;
	u.weapon = loser.weapon;
	u.weapon2 = loser.weapon2;
	u.takedamage = DAMAGE_AIM;
	u.solid = SOLID_SLIDEBOX;
	u.movetype = MOVETYPE_STEP;
	u.flags = 0;
	u.effects = 0;
	u.items = 0;
	if (u.weapon == IT_AXE)
	{
		u.weapon = IT_SHOTGUN;
	}
	if (u.weapon == IT_EXTRA_WEAPON)
	{
		if (u.weapon2 == WE_WACKY)
		{
			u.weapon = IT_ROCKET_LAUNCHER;
		}
		else
		{
			if (u.weapon2 == WE_CLUSTER)
			{
				u.weapon = IT_GRENADE_LAUNCHER;
			}
			else
			{
				if (u.weapon2 == WE_PLASMAGUN || u.weapon2 == WE_BFG)
				{
					u.weapon = IT_LIGHTNING;
				}
				else
				{
					u.weapon = IT_SHOTGUN;
				}
			}
		}
	}
	setorigin(u, loser.origin + '0 0 1');
	if (self.impulse == 19)
	{
		setorigin(u, loser.origin + '0 0 128');
	}
	setmodel(u, "progs/undead.mdl");
	setsize(u, VEC_HULL_MIN, VEC_HULL_MAX);
	u.velocity_z = -10;
	u.think = undead_up1;
	u.nextthink = time + 0.010000;
	u.th_stand = undead_stand1;
	u.th_die = GibZombie;
	u.th_missile = UndeadShoot;
};

void() SpawnUndead = 
{
	CreateBody(self);
};


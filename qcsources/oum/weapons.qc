void() W_Precache = 
{
	precache_sound("weapons/r_exp3.wav");
	precache_sound("weapons/rocket1i.wav");
	precache_sound("weapons/sgun1.wav");
	precache_sound("weapons/guncock.wav");
	precache_sound("weapons/ric1.wav");
	precache_sound("weapons/ric2.wav");
	precache_sound("weapons/ric3.wav");
	precache_sound("weapons/spike2.wav");
	precache_sound("weapons/tink1.wav");
	precache_sound("weapons/grenade.wav");
	precache_sound("weapons/bounce.wav");
	precache_sound("weapons/shotgn2.wav");
	precache_sound("weapons/sawidle.wav");
	precache_sound("weapons/sawridle.wav");
	precache_sound("weapons/sawatck.wav");
	precache_sound("weapons/sawguts.wav");
	precache_sound("misc/null.wav");
	Plasma_PreCache();
	Asha_PreCache();
};

float() crandom = 
{
	return FL_SWIM * (random() - 0.5);
};

void() W_FireAxe = 
{
	local vector source;
	local vector org;
	makevectors(self.v_angle);
	source = self.origin + '0 0 16';
	traceline(source, source + v_forward * FL_GODMODE, 0, self);
	if (trace_fraction == 1)
	{
		return;
	}
	org = trace_endpos - v_forward * MOVETYPE_STEP;
	if (trace_ent.takedamage)
	{
		trace_ent.axhitme = 1;
		SpawnBlood(org, VEC_ORIGIN, 20);
		T_Damage(trace_ent, self, self, 20);
	}
	else
	{
		sound(self, CHAN_WEAPON, "player/axhit2.wav", 1, ATTN_NORM);
		WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte(MSG_BROADCAST, TE_GUNSHOT);
		WriteCoord(MSG_BROADCAST, org_x);
		WriteCoord(MSG_BROADCAST, org_y);
		WriteCoord(MSG_BROADCAST, org_z);
	}
};

vector() wall_velocity = 
{
	local vector vel;
	vel = normalize(self.velocity);
	vel = normalize(vel + v_up * (random() - 0.5) + v_right * (random() - 0.5));
	vel = vel + FL_SWIM * trace_plane_normal;
	vel = vel * MAX_NAILS;
	return vel_x;
};

void(vector org, vector vel) SpawnMeatSpray = 
{
	local entity missile;
	local entity mpuff;
	missile = spawn();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_NOT;
	makevectors(self.angles);
	missile.velocity = vel;
	missile.velocity_z = missile.velocity_z + 250 + 50 * random();
	missile.avelocity = '3000 1000 2000';
	missile.nextthink = time + 1;
	missile.think = SUB_Remove;
	setmodel(missile, "progs/zom_gib.mdl");
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(missile, org);
};

void(vector org, vector vel, float damage) SpawnBlood = 
{
	particle(org, vel * 0.1, 73, damage * FL_SWIM);
};

void(float damage) spawn_touchblood = 
{
	local vector vel;
	vel = wall_velocity() * 0.2;
	SpawnBlood(self.origin + vel * 0.010000, vel, damage);
};

void(vector org, vector vel) SpawnChunk = 
{
	particle(org, vel * 0.020000, 0, MOVETYPE_BOUNCE);
};

void() W_FireSaw = 
{
	local vector source;
	local vector org;
	makevectors(self.v_angle);
	source = self.origin + '0 0 16';
	traceline(source, source + v_forward * FL_GODMODE, 0, self);
	if (trace_fraction == 1)
	{
		return;
	}
	org = trace_endpos - v_forward * MOVETYPE_STEP;
	if (trace_ent.takedamage)
	{
		trace_ent.axhitme = FL_SWIM;
		SpawnBlood(trace_endpos, '0 0 5', 20);
		SpawnMeatSpray(self.origin + v_forward * FL_INWATER, (random() * 300 - 150) * v_right + MAX_SHELLS * v_forward);
		if (deathmatch == 0)
		{
			T_Damage(trace_ent, self, self, 24);
		}
		else
		{
			T_Damage(trace_ent, self, self, SVC_INTERMISSION);
		}
		trace_ent.velocity = trace_ent.velocity * 0.5;
		sound(self, CHAN_WEAPON, "weapons/sawguts.wav", 1, ATTN_NORM);
		self.punchangle_x = -8;
	}
	else
	{
		sound(self, CHAN_WEAPON, "player/axhit2.wav", 1, ATTN_NORM);
		WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte(MSG_BROADCAST, TE_GUNSHOT);
		WriteCoord(MSG_BROADCAST, org_x);
		WriteCoord(MSG_BROADCAST, org_y);
		WriteCoord(MSG_BROADCAST, org_z);
	}
};

void() ClearMultiDamage = 
{
	multi_ent = world;
	multi_damage = 0;
};

void() ApplyMultiDamage = 
{
	if (!multi_ent)
	{
		return;
	}
	T_Damage(multi_ent, self, self, multi_damage);
};

void(entity hit, float damage) AddMultiDamage = 
{
	if (!hit)
	{
		return;
	}
	if (hit != multi_ent)
	{
		ApplyMultiDamage();
		multi_damage = damage;
		multi_ent = hit;
	}
	else
	{
		multi_damage = multi_damage + damage;
	}
};

void(float damage, vector dir) TraceAttack = 
{
	local vector vel;
	local vector org;
	vel = normalize(dir + v_up * crandom() + v_right * crandom());
	vel = vel + FL_SWIM * trace_plane_normal;
	vel = vel * MAX_NAILS;
	org = trace_endpos - dir * MOVETYPE_STEP;
	if (trace_ent.takedamage)
	{
		SpawnBlood(org, vel * 0.2, damage);
		AddMultiDamage(trace_ent, damage);
	}
	else
	{
		WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte(MSG_BROADCAST, TE_GUNSHOT);
		WriteCoord(MSG_BROADCAST, org_x);
		WriteCoord(MSG_BROADCAST, org_y);
		WriteCoord(MSG_BROADCAST, org_z);
	}
};

void(float shotcount, vector dir, vector spread) FireBullets = 
{
	local vector direction;
	local vector src;
	makevectors(self.v_angle);
	src = self.origin + v_forward * MOVETYPE_BOUNCE;
	src_z = self.absmin_z + self.size_z * 0.7;
	ClearMultiDamage();
	while (shotcount > 0)
	{
		direction = dir + crandom() * spread_x * v_right + crandom() * spread_y * v_up;
		traceline(src, src + direction * FL_WATERJUMP, 0, self);
		if (trace_fraction != 1)
		{
			TraceAttack(MOVETYPE_STEP, direction);
		}
		shotcount = shotcount - 1;
	}
	ApplyMultiDamage();
};

void() W_FireShotgun = 
{
	local vector dir;
	sound(self, CHAN_WEAPON, "weapons/guncock.wav", 1, ATTN_NORM);
	self.punchangle_x = CONTENT_SOLID;
	self.currentammo = self.ammo_shells = self.ammo_shells - 1;
	dir = aim(self, 100000);
	FireBullets(MOVETYPE_TOSS, dir, '0.040000 0.040000 0');
};

void() W_FireSuperShotgun = 
{
	local vector dir;
	if (self.currentammo == 1)
	{
		W_FireShotgun();
		return;
	}
	sound(self, CHAN_WEAPON, "weapons/shotgn2.wav", 1, ATTN_NORM);
	self.punchangle_x = CONTENT_SLIME;
	self.currentammo = self.ammo_shells = self.ammo_shells - FL_SWIM;
	dir = aim(self, 100000);
	FireBullets(14, dir, '0.14 0.080000 0');
	FireBullets(14, dir, '0.14 0.080000 0');
};

void() s_explode1 = [0, s_explode2]
{
};

void() s_explode2 = [1, s_explode3]
{
};

void() s_explode3 = [2, s_explode4]
{
};

void() s_explode4 = [3, s_explode5]
{
};

void() s_explode5 = [4, s_explode6]
{
};

void() s_explode6 = [5, SUB_Remove]
{
};

void() BecomeExplosion = 
{
	self.movetype = MOVETYPE_NONE;
	self.velocity = VEC_ORIGIN;
	self.touch = SUB_Null;
	setmodel(self, "progs/s_explod.spr");
	self.solid = SOLID_NOT;
	s_explode1();
};

void() T_MissileTouch = 
{
	local float damg;
	if (other == self.owner)
	{
		return;
	}
	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	damg = MAX_SHELLS + random() * 20;
	if (other.health)
	{
		if (other.classname == "monster_shambler" || deathmatch)
		{
			damg = damg * 0.5;
		}
		T_Damage(other, self, self.owner, damg);
	}
	T_RadiusDamage(self, self.owner, 120, other);
	self.origin = self.origin - FL_CLIENT * normalize(self.velocity);
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord(MSG_BROADCAST, self.origin_x);
	WriteCoord(MSG_BROADCAST, self.origin_y);
	WriteCoord(MSG_BROADCAST, self.origin_z);
	BecomeExplosion();
};

void() T_EnforcerMissileTouch = 
{
	local float damg;
	if (other == self.owner)
	{
		return;
	}
	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	damg = 20 + random() * FL_SWIM;
	if (other.health)
	{
		if (other.classname == "monster_shambler" || deathmatch)
		{
			damg = damg * 0.5;
		}
		T_Damage(other, self, self.owner, damg);
	}
	T_RadiusDamage(self, self.owner, 20, other);
	self.origin = self.origin - FL_CLIENT * normalize(self.velocity);
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord(MSG_BROADCAST, self.origin_x);
	WriteCoord(MSG_BROADCAST, self.origin_y);
	WriteCoord(MSG_BROADCAST, self.origin_z);
	BecomeExplosion();
};

void() W_FireRocket = 
{
	local entity missile;
	local entity mpuff;
	self.currentammo = self.ammo_rockets = self.ammo_rockets - 1;
	sound(self, CHAN_WEAPON, "weapons/sgun1.wav", 1, ATTN_NORM);
	self.punchangle_x = CONTENT_SOLID;
	missile = spawn();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	missile.classname = "missile";
	makevectors(self.v_angle);
	missile.velocity = aim(self, 1000);
	missile.velocity = missile.velocity * 1000;
	missile.angles = vectoangles(missile.velocity);
	missile.touch = T_MissileTouch;
	missile.nextthink = time + MOVETYPE_FLY;
	missile.think = SUB_Remove;
	setmodel(missile, "progs/missile.mdl");
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(missile, self.origin + v_forward * FL_CLIENT + '0 0 16');
};

void(vector p1, vector p2, entity from, float damage) LightningDamage = 
{
	local entity e1;
	local entity e2;
	local vector f;
	f = p2 - p1;
	normalize(f);
	f_x = 0 - f_y;
	f_y = f_x;
	f_z = 0;
	f = f * FL_INWATER;
	e2 = world;
	e1 = world;
	traceline(p1, p2, 0, self);
	if (trace_ent.takedamage)
	{
		particle(trace_endpos, '0 0 100', 225, damage * MOVETYPE_STEP);
		T_Damage(trace_ent, from, from, damage);
		if (self.classname == "player")
		{
			if (other.classname == "player")
			{
				trace_ent.velocity_z = trace_ent.velocity_z + 400;
			}
		}
		else
		{
			sound(trace_ent, CHAN_BODY, "enforcer/enfstop.wav", 1, ATTN_NORM);
		}
	}
	e1 = trace_ent;
	traceline(p1 + f, p2 + f, 0, self);
	if (trace_ent != e1 && trace_ent.takedamage)
	{
		particle(trace_endpos, '0 0 100', 225, damage * MOVETYPE_STEP);
		T_Damage(trace_ent, from, from, damage);
	}
	e2 = trace_ent;
	traceline(p1 - f, p2 - f, 0, self);
	if (trace_ent != e1 && trace_ent != e2 && trace_ent.takedamage)
	{
		particle(trace_endpos, '0 0 100', 225, damage * MOVETYPE_STEP);
		T_Damage(trace_ent, from, from, damage);
	}
};

void() W_FireLightning = 
{
	local vector org;
	local float cells;
	if (self.ammo_cells < 1)
	{
		W_GetBestWeapon();
		W_SetCurrentAmmo();
		return;
	}
	if (self.waterlevel > 1)
	{
		cells = self.ammo_cells;
		self.ammo_cells = 0;
		W_SetCurrentAmmo();
		T_RadiusDamage(self, self, 35 * cells, world);
		return;
	}
	if (self.t_width < time)
	{
		sound(self, CHAN_WEAPON, "weapons/lhit.wav", 1, ATTN_NORM);
		self.t_width = time + 0.6;
	}
	self.punchangle_x = CONTENT_SOLID;
	self.currentammo = self.ammo_cells = self.ammo_cells - 1;
	org = self.origin + '0 0 16';
	traceline(org, org + v_forward * 600, 1, self);
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_LIGHTNING2);
	WriteEntity(MSG_BROADCAST, self);
	WriteCoord(MSG_BROADCAST, org_x);
	WriteCoord(MSG_BROADCAST, org_y);
	WriteCoord(MSG_BROADCAST, org_z);
	WriteCoord(MSG_BROADCAST, trace_endpos_x);
	WriteCoord(MSG_BROADCAST, trace_endpos_y);
	WriteCoord(MSG_BROADCAST, trace_endpos_z);
	LightningDamage(self.origin, trace_endpos + v_forward * MOVETYPE_STEP, self, SVC_INTERMISSION);
};

void() GrenadeExplode = 
{
	T_RadiusDamage(self, self.owner, 120, world);
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord(MSG_BROADCAST, self.origin_x);
	WriteCoord(MSG_BROADCAST, self.origin_y);
	WriteCoord(MSG_BROADCAST, self.origin_z);
	BecomeExplosion();
};

void() GrenadeTouch = 
{
	if (other == self.owner)
	{
		return;
	}
	if (other.takedamage == DAMAGE_AIM)
	{
		GrenadeExplode();
		return;
	}
	sound(self, CHAN_WEAPON, "weapons/bounce.wav", 1, ATTN_NORM);
	if (self.velocity == VEC_ORIGIN)
	{
		self.avelocity = VEC_ORIGIN;
	}
};

void() W_FireGrenade = 
{
	local entity missile;
	local entity mpuff;
	self.currentammo = self.ammo_rockets = self.ammo_rockets - 1;
	sound(self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM);
	self.punchangle_x = CONTENT_SOLID;
	missile = spawn();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
	missile.classname = "grenade";
	makevectors(self.v_angle);
	if (self.v_angle_x)
	{
		missile.velocity = v_forward * 600 + v_up * MAX_NAILS + crandom() * v_right * MOVETYPE_BOUNCE + crandom() * v_up * MOVETYPE_BOUNCE;
	}
	else
	{
		missile.velocity = aim(self, 10000);
		missile.velocity = missile.velocity * 600;
		missile.velocity_z = MAX_NAILS;
	}
	missile.avelocity = '300 300 300';
	missile.angles = vectoangles(missile.velocity);
	missile.touch = GrenadeTouch;
	missile.nextthink = time + 2.5;
	missile.think = GrenadeExplode;
	setmodel(missile, "progs/grenade.mdl");
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(missile, self.origin);
};

void() HIP_LaserTouch = 
{
	local vector org;
	local vector spot1;
	local vector spot2;
	local vector oldvel;
	local float mag;
	local float r;
	self.owner = world;
	self.cnt = self.cnt + 1;
	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	oldvel = normalize(self.old_velocity);
	spot1 = self.origin - FL_INWATER * oldvel;
	spot2 = self.origin + FL_INWATER * oldvel;
	traceline(spot1, spot2, 0, self);
	self.origin = trace_endpos;
	org = self.origin;
	if (other.health)
	{
		if (self.enemy == other)
		{
			self.dmg = self.dmg / FL_SWIM;
		}
		spawn_touchblood(self.dmg);
		T_Damage(other, self, self.enemy, self.dmg);
	}
	else
	{
		if (self.cnt == MOVETYPE_WALK || random() < 0.15)
		{
			WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
			WriteByte(MSG_BROADCAST, TE_GUNSHOT);
			WriteCoord(MSG_BROADCAST, org_x);
			WriteCoord(MSG_BROADCAST, org_y);
			WriteCoord(MSG_BROADCAST, org_z);
		}
		else
		{
			self.dmg = 0.9 * self.dmg;
			self.velocity = oldvel + FL_SWIM * trace_plane_normal;
			self.velocity = normalize(self.velocity);
			self.velocity = self.speed * self.velocity;
			self.old_velocity = self.velocity;
			if (self.flags & FL_ONGROUND)
			{
				self.flags = self.flags - FL_ONGROUND;
			}
			r = random();
			if (r < 0.33)
			{
				sound(self, CHAN_WEAPON, "weapons/ric1.wav", 1, ATTN_STATIC);
			}
			else
			{
				if (r < 0.66)
				{
					sound(self, CHAN_WEAPON, "weapons/ric2.wav", 1, ATTN_STATIC);
				}
				else
				{
					sound(self, CHAN_WEAPON, "weapons/ric3.wav", 1, ATTN_STATIC);
				}
			}
			return;
		}
	}
	sound(self, CHAN_WEAPON, "weapons/tink1.wav", 1, ATTN_STATIC);
	remove(self);
};

void() HIP_LaserThink = 
{
	local float delta;
	if (time > self.attack_finished)
	{
		remove(self);
		return;
	}
	if (self.flags & FL_ONGROUND)
	{
		self.flags = self.flags - FL_ONGROUND;
	}
	self.velocity = self.old_velocity;
	self.angles = vectoangles(self.velocity);
	self.nextthink = time + 0.1;
};

void(vector org, vector vec) HIP_LaunchLaser = 
{
	vec = normalize(vec);
	newmis = spawn();
	newmis.owner = self;
	newmis.classname = "spike";
	newmis.enemy = self;
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BBOX;
	setmodel(newmis, "progs/spike.mdl");
	setsize(newmis, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(newmis, org);
	newmis.speed = 1000;
	newmis.dmg = STAT_TOTALMONSTERS;
	newmis.velocity = vec * newmis.speed;
	newmis.old_velocity = newmis.velocity;
	newmis.angles = vectoangles(newmis.velocity);
	newmis.avelocity = '0 0 400';
	newmis.nextthink = time;
	newmis.attack_finished = time + MOVETYPE_FLY;
	newmis.think = HIP_LaserThink;
	newmis.touch = HIP_LaserTouch;
	newmis.count = 0;
};

void(vector org, vector dir) launch_spike = 
{
	newmis = spawn();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BBOX;
	newmis.angles = vectoangles(dir);
	newmis.touch = spike_touch;
	newmis.classname = "spike";
	newmis.think = SUB_Remove;
	newmis.nextthink = time + MOVETYPE_TOSS;
	setmodel(newmis, "progs/spike.mdl");
	setsize(newmis, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(newmis, org);
	newmis.velocity = dir * 1000;
};

void() W_FireSuperSpikes = 
{
	local vector dir;
	local entity old;
	sound(self, CHAN_WEAPON, "weapons/spike2.wav", 1, ATTN_NORM);
	self.attack_finished = time + 0.2;
	self.currentammo = self.ammo_nails = self.ammo_nails - FL_SWIM;
	dir = aim(self, 1000);
	launch_spike(self.origin + '0 0 16', dir);
	newmis.touch = superspike_touch;
	setmodel(newmis, "progs/s_spike.mdl");
	setsize(newmis, VEC_ORIGIN, VEC_ORIGIN);
	self.punchangle_x = CONTENT_SOLID;
};

void(float ox) W_FireSpikes = 
{
	local vector dir;
	local entity old;
	makevectors(self.v_angle);
	if (self.ammo_nails >= FL_SWIM && self.guninuse == GUN_SUPER_NAILGUN)
	{
		W_FireSuperSpikes();
		return;
	}
	if (self.ammo_nails < 1)
	{
		W_GetBestWeapon();
		W_SetCurrentAmmo();
		return;
	}
	sound(self, CHAN_WEAPON, "weapons/rocket1i.wav", 1, ATTN_NORM);
	self.attack_finished = time + 0.2;
	self.currentammo = self.ammo_nails = self.ammo_nails - 1;
	dir = aim(self, 1000);
	HIP_LaunchLaser(self.origin + '0 0 16' + v_right * ox, dir);
	self.punchangle_x = CONTENT_SOLID;
};

void() spike_touch = 
{
	local float rand;
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
		spawn_touchblood(MOVETYPE_FLYMISSILE);
		T_Damage(other, self, self.owner, MOVETYPE_FLYMISSILE);
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
	remove(self);
};

void() superspike_touch = 
{
	local float rand;
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
		spawn_touchblood(18);
		T_Damage(other, self, self.owner, 18);
	}
	else
	{
		WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte(MSG_BROADCAST, TE_SUPERSPIKE);
		WriteCoord(MSG_BROADCAST, self.origin_x);
		WriteCoord(MSG_BROADCAST, self.origin_y);
		WriteCoord(MSG_BROADCAST, self.origin_z);
	}
	remove(self);
};

void() W_SetCurrentAmmo = 
{
	player_run();
	self.items = self.items - (self.items & (IT_SHELLS | IT_NAILS | IT_ROCKETS | IT_CELLS));
	if (self.items & IT_SUPER_SHOTGUN && (self.gunitems & GUN_SUPER_SHOTGUN) == 0)
	{
		self.gunitems = self.gunitems | GUN_SUPER_SHOTGUN;
	}
	if (self.items & IT_PLASMAGUN && (self.gunitems & GUN_PLASMAGUN) == 0)
	{
		self.gunitems = self.gunitems | GUN_PLASMAGUN;
	}
	if (self.items & IT_NAILGUN && (self.gunitems & GUN_NAILGUN) == 0 && (self.gunitems & GUN_SUPER_NAILGUN) == 0)
	{
		self.gunitems = self.gunitems | GUN_NAILGUN;
	}
	if (self.items & IT_ANTISHAMBLER && (self.gunitems & GUN_ANTISHAMBLER) == 0)
	{
		self.gunitems = self.gunitems | GUN_ANTISHAMBLER;
	}
	if (self.items & IT_GRENADE_LAUNCHER && (self.gunitems & GUN_GRENADE_LAUNCHER) == 0)
	{
		self.gunitems = self.gunitems | GUN_GRENADE_LAUNCHER;
	}
	if (self.items & IT_ROCKET_LAUNCHER && (self.gunitems & GUN_ROCKET_LAUNCHER) == 0)
	{
		self.gunitems = self.gunitems | GUN_ROCKET_LAUNCHER;
	}
	if (self.items & IT_LIGHTNING && (self.gunitems & GUN_LIGHTNING) == 0)
	{
		self.gunitems = self.gunitems | GUN_LIGHTNING;
	}
	if (self.guninuse == GUN_AXE)
	{
		self.skin = 0;
		self.currentammo = 0;
		self.weaponmodel = "progs/v_axe.mdl";
		sound(self, MOVETYPE_TOSS, "misc/null.wav", 1, ATTN_NORM);
		self.weaponframe = 0;
		self.weapon = IT_AXE;
	}
	else
	{
		if (self.guninuse == GUN_CHAINSAW)
		{
			self.skin = 1;
			self.currentammo = 0;
			self.weaponmodel = "progs/v_saw.mdl";
			sound(self, MOVETYPE_TOSS, "weapons/sawidle.wav", 1, ATTN_NORM);
			self.weaponframe = 0;
			self.weapon = IT_CHAINSAW;
		}
		else
		{
			if (self.guninuse == GUN_SHOTGUN)
			{
				self.skin = 0;
				self.currentammo = self.ammo_shells;
				self.weaponmodel = "progs/v_shot.mdl";
				self.weaponframe = 0;
				self.items = self.items | IT_SHELLS;
				sound(self, MOVETYPE_TOSS, "misc/null.wav", 1, ATTN_NORM);
				self.weapon = IT_SHOTGUN;
			}
			else
			{
				if (self.guninuse == GUN_SUPER_SHOTGUN)
				{
					self.skin = 0;
					self.currentammo = self.ammo_shells;
					self.weaponmodel = "progs/v_dshot.mdl";
					self.weaponframe = 0;
					self.items = self.items | IT_SHELLS;
					sound(self, MOVETYPE_TOSS, "misc/null.wav", 1, ATTN_NORM);
					self.weapon = IT_SUPER_SHOTGUN;
				}
				else
				{
					if (self.guninuse == GUN_NAILGUN)
					{
						self.skin = 0;
						self.currentammo = self.ammo_nails;
						self.weaponmodel = "progs/v_nail.mdl";
						self.weaponframe = 0;
						self.items = self.items | IT_NAILS;
						sound(self, MOVETYPE_TOSS, "misc/null.wav", 1, ATTN_NORM);
						self.weapon = IT_NAILGUN;
					}
					else
					{
						if (self.guninuse == GUN_SUPER_NAILGUN)
						{
							self.skin = 0;
							self.currentammo = self.ammo_nails;
							self.weaponmodel = "progs/v_nail2.mdl";
							self.weaponframe = 0;
							self.items = self.items | IT_NAILS;
							sound(self, MOVETYPE_TOSS, "misc/null.wav", 1, ATTN_NORM);
							self.weapon = IT_SUPER_NAILGUN;
						}
						else
						{
							if (self.guninuse == GUN_GRENADE_LAUNCHER)
							{
								self.skin = 0;
								self.currentammo = self.ammo_rockets;
								self.weaponmodel = "progs/v_rock.mdl";
								self.weaponframe = 0;
								self.items = self.items | IT_ROCKETS;
								sound(self, MOVETYPE_TOSS, "misc/null.wav", 1, ATTN_NORM);
								self.weapon = IT_GRENADE_LAUNCHER;
							}
							else
							{
								if (self.guninuse == GUN_ROCKET_LAUNCHER)
								{
									self.skin = 0;
									self.currentammo = self.ammo_rockets;
									self.weaponmodel = "progs/v_rock2.mdl";
									self.weaponframe = 0;
									self.items = self.items | IT_ROCKETS;
									sound(self, MOVETYPE_TOSS, "misc/null.wav", 1, ATTN_NORM);
									self.weapon = IT_ROCKET_LAUNCHER;
								}
								else
								{
									if (self.guninuse == GUN_LIGHTNING)
									{
										self.skin = 0;
										self.currentammo = self.ammo_cells;
										self.weaponmodel = "progs/v_light.mdl";
										self.weaponframe = 0;
										self.items = self.items | IT_CELLS;
										sound(self, MOVETYPE_TOSS, "misc/null.wav", 1, ATTN_NORM);
										self.weapon = IT_LIGHTNING;
									}
									else
									{
										if (self.guninuse == GUN_PLASMAGUN)
										{
											self.skin = 0;
											self.currentammo = self.ammo_cells;
											self.weaponmodel = "progs/v_plasma.mdl";
											self.weaponframe = 0;
											self.items = self.items | IT_CELLS;
											sound(self, MOVETYPE_TOSS, "misc/null.wav", 1, ATTN_NORM);
											self.weapon = IT_PLASMAGUN;
										}
										else
										{
											if (self.guninuse == GUN_ANTISHAMBLER)
											{
												self.skin = 0;
												self.currentammo = self.ammo_cells;
												self.weaponmodel = "progs/v_asha.mdl";
												self.weaponframe = 0;
												self.items = self.items | IT_CELLS;
												sound(self, MOVETYPE_TOSS, "misc/null.wav", 1, ATTN_NORM);
												self.weapon = IT_ANTISHAMBLER;
											}
											else
											{
												self.skin = 0;
												self.currentammo = 0;
												self.weaponmodel = string_null;
												self.weaponframe = 0;
												sound(self, MOVETYPE_TOSS, "misc/null.wav", 1, ATTN_NORM);
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
	}
};

void() W_GetBestWeapon = 
{
	local float git;
	git = self.gunitems;
	if (self.waterlevel <= 1 && self.ammo_cells >= 1 && (git & GUN_LIGHTNING))
	{
		self.guninuse = GUN_LIGHTNING;
		return;
	}
	if (self.waterlevel <= FL_SWIM && self.ammo_cells >= 1 && (git & GUN_PLASMAGUN))
	{
		self.guninuse = GUN_PLASMAGUN;
		return;
	}
	if (self.ammo_nails >= FL_SWIM && (git & GUN_SUPER_NAILGUN))
	{
		self.guninuse = GUN_SUPER_NAILGUN;
		return;
	}
	if (self.ammo_shells >= FL_SWIM && (git & GUN_SUPER_SHOTGUN))
	{
		self.guninuse = GUN_SUPER_SHOTGUN;
		return;
	}
	if (self.ammo_nails >= 1 && (git & GUN_NAILGUN))
	{
		self.guninuse = GUN_NAILGUN;
		return;
	}
	if (self.ammo_shells >= 1 && (git & GUN_SHOTGUN))
	{
		self.guninuse = GUN_SHOTGUN;
		return;
	}
	if (git & GUN_CHAINSAW)
	{
		self.guninuse = GUN_CHAINSAW;
		return;
	}
	self.guninuse = GUN_AXE;
	return;
};

float() W_CheckNoAmmo = 
{
	if (self.guninuse == GUN_AXE)
	{
		return 0;
	}
	if (self.guninuse == GUN_CHAINSAW)
	{
		return 0;
	}
	if (self.currentammo > 0 && self.guninuse != GUN_ANTISHAMBLER)
	{
		return 0;
	}
	if (self.guninuse == GUN_ANTISHAMBLER)
	{
		if (self.currentammo > MOVETYPE_WALK && self.ashamode == 0)
		{
			return 0;
		}
		if (self.currentammo > 0)
		{
			if (self.ashamode == 0)
			{
				self.ashamode = 1;
				sprint(self, "Rapid-fire mode\n");
			}
			return 0;
		}
	}
	W_GetBestWeapon();
	W_SetCurrentAmmo();
	return 1;
};

void() W_Attack = 
{
	local float r;
	if (W_CheckNoAmmo())
	{
		return;
	}
	makevectors(self.v_angle);
	self.show_hostile = time + 1;
	if (self.guninuse == GUN_AXE)
	{
		sound(self, CHAN_WEAPON, "weapons/ax1.wav", 1, ATTN_NORM);
		r = random();
		if (r < 0.25)
		{
			player_axe1();
		}
		else
		{
			if (r < 0.5)
			{
				player_axeb1();
			}
			else
			{
				if (r < 0.75)
				{
					player_axec1();
				}
				else
				{
					player_axed1();
				}
			}
		}
		self.attack_finished = time + 0.5;
	}
	else
	{
		if (self.guninuse == GUN_CHAINSAW)
		{
			player_chainsaw1();
			self.attack_finished = time + 0.55;
			sound(self, CHAN_AUTO, "weapons/sawatck.wav", 1, ATTN_NORM);
		}
		else
		{
			if (self.guninuse == GUN_SHOTGUN)
			{
				player_shot1();
				W_FireShotgun();
				self.attack_finished = time + 0.5;
			}
			else
			{
				if (self.guninuse == GUN_SUPER_SHOTGUN)
				{
					player_shot1();
					W_FireSuperShotgun();
					self.attack_finished = time + 0.9;
				}
				else
				{
					if (self.guninuse == GUN_NAILGUN)
					{
						player_nail1();
					}
					else
					{
						if (self.guninuse == GUN_SUPER_NAILGUN)
						{
							player_nail1();
						}
						else
						{
							if (self.guninuse == GUN_GRENADE_LAUNCHER)
							{
								player_rocket1();
								W_FireGrenade();
								self.attack_finished = time + 0.6;
							}
							else
							{
								if (self.guninuse == GUN_ROCKET_LAUNCHER)
								{
									player_rocket1();
									W_FireRocket();
									self.attack_finished = time + 0.8;
								}
								else
								{
									if (self.guninuse == GUN_PLASMAGUN)
									{
										player_shot1();
										W_FirePlasma();
										self.attack_finished = time + 0.05;
									}
									else
									{
										if (self.guninuse == GUN_LIGHTNING)
										{
											player_light1();
											self.attack_finished = time + 0.1;
											sound(self, CHAN_AUTO, "weapons/lstart.wav", 1, ATTN_NORM);
										}
										else
										{
											if (self.guninuse == GUN_ANTISHAMBLER)
											{
												player_rocket1();
												W_FireAsha();
												self.attack_finished = time + 1.5 - self.ashamode;
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
	}
};

void() W_ChangeWeapon = 
{
	local float it;
	local float am;
	local float fl;
	local float gg;
	it = self.items;
	am = 0;
	if (self.impulse == 1)
	{
		if (self.guninuse == GUN_CHAINSAW || parm12 == 0)
		{
			fl = IT_AXE;
			gg = GUN_AXE;
		}
		else
		{
			fl = IT_CHAINSAW;
			gg = GUN_CHAINSAW;
		}
	}
	else
	{
		if (self.impulse == FL_SWIM)
		{
			if (self.guninuse == GUN_SUPER_SHOTGUN || (self.gunitems & GUN_SUPER_SHOTGUN) == 0 || self.ammo_shells < FL_SWIM)
			{
				fl = IT_SHOTGUN;
				gg = GUN_SHOTGUN;
				if (self.ammo_shells < 1)
				{
					am = 1;
				}
			}
			else
			{
				fl = IT_SUPER_SHOTGUN;
				gg = GUN_SUPER_SHOTGUN;
				if (self.ammo_shells < FL_SWIM)
				{
					am = 1;
				}
			}
		}
		else
		{
			if (self.impulse == MOVETYPE_WALK)
			{
				fl = IT_ANTISHAMBLER;
				gg = GUN_ANTISHAMBLER;
				if (self.ammo_cells < 1)
				{
					am = 1;
				}
				else
				{
					if (self.gunitems & GUN_ANTISHAMBLER)
					{
						if (self.guninuse == GUN_ANTISHAMBLER)
						{
							self.ashamode = 1 - self.ashamode;
						}
						if (self.ammo_cells < MOVETYPE_STEP)
						{
							self.ashamode = 1;
						}
					}
				}
			}
			else
			{
				if (self.impulse == MOVETYPE_STEP)
				{
					if (self.guninuse == GUN_SUPER_NAILGUN || (self.gunitems & GUN_SUPER_NAILGUN) == 0)
					{
						fl = IT_NAILGUN;
						gg = GUN_NAILGUN;
						if (self.ammo_nails < 1)
						{
							am = 1;
						}
					}
					else
					{
						fl = IT_SUPER_NAILGUN;
						gg = GUN_SUPER_NAILGUN;
						if (self.ammo_nails < FL_SWIM)
						{
							am = 1;
						}
					}
				}
				else
				{
					if (self.impulse == MOVETYPE_FLY)
					{
						fl = IT_PLASMAGUN;
						gg = GUN_PLASMAGUN;
						if (self.ammo_cells < 1)
						{
							am = 1;
						}
					}
					else
					{
						if (self.impulse == MOVETYPE_TOSS)
						{
							fl = IT_GRENADE_LAUNCHER;
							gg = GUN_GRENADE_LAUNCHER;
							if (self.ammo_rockets < 1)
							{
								am = 1;
							}
						}
						else
						{
							if (self.impulse == MOVETYPE_PUSH)
							{
								fl = IT_ROCKET_LAUNCHER;
								gg = GUN_ROCKET_LAUNCHER;
								if (self.ammo_rockets < 1)
								{
									am = 1;
								}
							}
							else
							{
								if (self.impulse == FL_CLIENT)
								{
									fl = IT_LIGHTNING;
									gg = GUN_LIGHTNING;
									if (self.ammo_cells < 1)
									{
										am = 1;
									}
								}
							}
						}
					}
				}
			}
		}
	}
	self.impulse = 0;
	if (!(self.gunitems & gg))
	{
		sprint(self, "no weapon.\n");
		return;
	}
	if (am)
	{
		sprint(self, "not enough ammo.\n");
		return;
	}
	self.weapon = fl;
	self.guninuse = gg;
	if (self.guninuse == GUN_ANTISHAMBLER)
	{
		if (self.ashamode)
		{
			sprint(self, "Rapid-fire mode.\n");
		}
		else
		{
			sprint(self, "Slow-fire mode.\n");
		}
	}
	W_SetCurrentAmmo();
};

void() CheatCommand = 
{
	if (deathmatch || coop)
	{
		return;
	}
	self.ammo_rockets = MAX_SHELLS;
	self.ammo_nails = MAX_NAILS;
	self.ammo_shells = MAX_SHELLS;
	self.ammo_cells = MAX_SHELLS;
	self.items = self.items | IT_AXE | IT_SHOTGUN | IT_SUPER_SHOTGUN | IT_NAILGUN | IT_SUPER_NAILGUN | IT_GRENADE_LAUNCHER | IT_ROCKET_LAUNCHER | IT_LIGHTNING | IT_PLASMAGUN | IT_ANTISHAMBLER | IT_CHAINSAW;
	self.gunitems = self.gunitems | GUN_AXE | GUN_SHOTGUN | GUN_SUPER_SHOTGUN | GUN_NAILGUN | GUN_SUPER_NAILGUN | GUN_GRENADE_LAUNCHER | GUN_ROCKET_LAUNCHER | GUN_PLASMAGUN | GUN_LIGHTNING | GUN_ANTISHAMBLER | GUN_CHAINSAW;
	self.weapon = IT_ANTISHAMBLER;
	self.guninuse = GUN_ANTISHAMBLER;
	parm12 == 1;
	self.impulse = 0;
	W_SetCurrentAmmo();
};

void() CycleWeaponCommand = 
{
	local float it;
	local float am;
	local float git;
	it = self.items;
	git = self.gunitems;
	self.impulse = 0;
	while (1)
	{
		am = 0;
		if (self.guninuse == GUN_ANTISHAMBLER)
		{
			self.guninuse = GUN_AXE;
			self.weapon = IT_AXE;
		}
		else
		{
			if (self.guninuse == GUN_AXE && parm12 == 1)
			{
				self.guninuse = GUN_CHAINSAW;
				self.weapon == IT_CHAINSAW;
			}
			else
			{
				if (self.guninuse == GUN_AXE && parm12 == 0)
				{
					self.guninuse = GUN_SHOTGUN;
					self.weapon = IT_SHOTGUN;
					if (self.ammo_shells < 1)
					{
						am = 1;
					}
				}
				else
				{
					if (self.guninuse == GUN_CHAINSAW)
					{
						self.guninuse = GUN_SHOTGUN;
						self.weapon = IT_SHOTGUN;
						if (self.ammo_shells < 1)
						{
							am = 1;
						}
					}
					else
					{
						if (self.guninuse == GUN_SHOTGUN)
						{
							self.guninuse = GUN_SUPER_SHOTGUN;
							self.weapon = IT_SUPER_SHOTGUN;
							if (self.ammo_shells < FL_SWIM || !(git & GUN_SUPER_SHOTGUN))
							{
								am = 1;
							}
						}
						else
						{
							if (self.guninuse == GUN_SUPER_SHOTGUN)
							{
								self.guninuse = GUN_NAILGUN;
								self.weapon = IT_NAILGUN;
								if (self.ammo_nails < 1 || !(git & GUN_NAILGUN))
								{
									am = 1;
								}
							}
							else
							{
								if (self.guninuse == GUN_NAILGUN)
								{
									self.guninuse = GUN_SUPER_NAILGUN;
									self.weapon = IT_SUPER_NAILGUN;
									if (self.ammo_nails < FL_SWIM || !(git & GUN_SUPER_NAILGUN))
									{
										am = 1;
									}
								}
								else
								{
									if (self.guninuse == GUN_SUPER_NAILGUN)
									{
										self.guninuse = GUN_GRENADE_LAUNCHER;
										self.weapon = IT_GRENADE_LAUNCHER;
										if (self.ammo_rockets < 1 || !(git & GUN_GRENADE_LAUNCHER))
										{
											am = 1;
										}
									}
									else
									{
										if (self.guninuse == GUN_GRENADE_LAUNCHER)
										{
											self.guninuse = GUN_ROCKET_LAUNCHER;
											self.weapon = IT_ROCKET_LAUNCHER;
											if (self.ammo_rockets < FL_SWIM || !(git & GUN_ROCKET_LAUNCHER))
											{
												am = 1;
											}
										}
										else
										{
											if (self.guninuse == GUN_ROCKET_LAUNCHER)
											{
												self.guninuse = GUN_PLASMAGUN;
												self.weapon = IT_PLASMAGUN;
												if (self.ammo_cells < 1 || !(git & GUN_PLASMAGUN))
												{
													am = 1;
												}
											}
											else
											{
												if (self.guninuse == GUN_PLASMAGUN)
												{
													self.guninuse = GUN_LIGHTNING;
													self.weapon = IT_LIGHTNING;
													if (self.ammo_cells < 1 || !(git & GUN_LIGHTNING))
													{
														am = 1;
													}
												}
												else
												{
													if (self.guninuse == GUN_LIGHTNING)
													{
														self.guninuse = GUN_ANTISHAMBLER;
														self.weapon = IT_ANTISHAMBLER;
														if (self.ammo_cells < 1 || !(git & GUN_ANTISHAMBLER))
														{
															am = 1;
														}
														else
														{
															if (self.ammo_cells < MOVETYPE_STEP)
															{
																self.ashamode = 1;
															}
														}
													}
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
		if (am == 0)
		{
			W_SetCurrentAmmo();
			return;
		}
	}
};

void() ServerflagsCommand = 
{
	serverflags = serverflags * FL_SWIM + 1;
};

void() QuadCheat = 
{
	if (deathmatch || coop)
	{
		return;
	}
	self.super_time = 1;
	self.super_damage_finished = time + SVC_INTERMISSION;
	self.items = self.items | IT_QUAD;
	dprint("quad cheat\n");
};

void() ImpulseCommands = 
{
	if (self.impulse >= 1 && self.impulse <= FL_CLIENT)
	{
		W_ChangeWeapon();
	}
	if (self.impulse == MOVETYPE_FLYMISSILE)
	{
		CheatCommand();
	}
	if (self.impulse == MOVETYPE_BOUNCE)
	{
		CycleWeaponCommand();
	}
	if (self.impulse == MOVETYPE_BOUNCEMISSILE)
	{
		ServerflagsCommand();
	}
	if (self.impulse == 255)
	{
		QuadCheat();
	}
	self.impulse = 0;
};

void() W_WeaponFrame = 
{
	local float cells;
	if (time < self.attack_finished)
	{
		return;
	}
	ImpulseCommands();
	if (self.button0)
	{
		if (self.guninuse == GUN_ANTISHAMBLER && !(self.ashamode))
		{
			self.charging = 1;
			if (self.ashacharge < 1)
			{
				sound(self, CHAN_WEAPON, "misc/tesla.wav", 1, ATTN_NORM);
				self.ashacharge = 1;
			}
			self.ashacharge = self.ashacharge + 0.3;
			if (self.ashacharge > MOVETYPE_BOUNCE)
			{
				cells = self.ammo_cells;
				self.ammo_cells = 0;
				W_SetCurrentAmmo();
				WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
				WriteByte(MSG_BROADCAST, TE_EXPLOSION);
				WriteCoord(MSG_BROADCAST, self.origin_x);
				WriteCoord(MSG_BROADCAST, self.origin_y);
				WriteCoord(MSG_BROADCAST, self.origin_z);
				T_RadiusDamage(self, self, 35 * cells, world);
				return;
			}
		}
		else
		{
			SuperDamageSound();
			W_Attack();
		}
	}
	if (!(self.button0) && self.charging)
	{
		self.ashacharge = ceil(self.ashacharge);
		if (self.ashacharge > MOVETYPE_BOUNCE)
		{
			self.ashacharge = MOVETYPE_BOUNCE;
		}
		W_Attack();
		self.charging = 0;
		self.ashacharge = 0;
	}
};

void() SuperDamageSound = 
{
	if (self.super_damage_finished > time)
	{
		if (self.super_sound < time)
		{
			self.super_sound = time + 1;
			sound(self, CHAN_BODY, "items/damage3.wav", 1, ATTN_NORM);
		}
	}
	return;
};


float() crandom = 
{
	return WEAPON_ROCKET * (random() - 0.5);
};

void() W_FireHammer = 
{
	local vector source;
	local vector org;
	makevectors(self.v_angle);
	source = self.origin + '0 0 16';
	traceline(source, source + v_forward * TRIGGER_SPAWN, 0, self);
	if (trace_fraction == WEAPON_SHOTGUN)
	{
		return;
	}
	org = trace_endpos - v_forward * WEAPON_SPIKES;
	if (trace_ent.takedamage)
	{
		trace_ent.axhitme = WEAPON_SHOTGUN;
		SpawnBlood(org, VEC_ORIGIN, 20);
		T_Damage(trace_ent, self, self, 40);
	}
	else
	{
		sound(self, CHAN_WEAPON, "weapons/hamhit.wav", WEAPON_SHOTGUN, ATTN_NORM);
		WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte(MSG_BROADCAST, TE_GUNSHOT);
		WriteCoord(MSG_BROADCAST, org_x);
		WriteCoord(MSG_BROADCAST, org_y);
		WriteCoord(MSG_BROADCAST, org_z);
	}
};

void() W_FireAxe = 
{
	local vector source;
	local vector org;
	makevectors(self.v_angle);
	source = self.origin + '0 0 16';
	traceline(source, source + v_forward * TRIGGER_SPAWN, 0, self);
	if (trace_fraction == WEAPON_SHOTGUN)
	{
		return;
	}
	org = trace_endpos - v_forward * WEAPON_SPIKES;
	if (trace_ent.takedamage)
	{
		trace_ent.axhitme = WEAPON_SHOTGUN;
		SpawnBlood(org, VEC_ORIGIN, 20);
		T_Damage(trace_ent, self, self, 20);
	}
	else
	{
		sound(self, CHAN_WEAPON, "player/axhit2.wav", WEAPON_SHOTGUN, ATTN_NORM);
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
	vel = vel + WEAPON_ROCKET * trace_plane_normal;
	vel = vel * 200;
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
	missile.nextthink = time + WEAPON_SHOTGUN;
	missile.think = SUB_Remove;
	setmodel(missile, "progs/zom_gib.mdl");
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(missile, org);
};

void(vector org, vector vel, float damage) SpawnBlood = 
{
	particle(org, vel * 0.1, 73, damage * WEAPON_ROCKET);
};

void(vector org, vector vel, float damage) SpawnShieldHit = 
{
	particle(org, vel * 0.1, ED_MAXANGLE, damage * 0.8);
};

void(float damage) spawn_touchblood = 
{
	local vector vel;
	vel = wall_velocity() * 0.2;
	SpawnBlood(self.origin + vel * 0.010000, vel, damage);
};

void(vector org, vector vel) SpawnChunk = 
{
	particle(org, vel * 0.020000, MSG_BROADCAST, TE_LAVASPLASH);
};

void() ClearMultiDamage = 
{
	multi_ent = world;
	multi_damage = MSG_BROADCAST;
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
	vel = vel + WEAPON_ROCKET * trace_plane_normal;
	vel = vel * 200;
	org = trace_endpos - dir * WEAPON_SPIKES;
	if (trace_ent.takedamage)
	{
		SpawnBlood(org, vel * 0.2, damage);
		if (trace_ent.classname == "monster_death_lord" && trace_ent.shield == WEAPON_SHOTGUN)
		{
			SpawnShieldHit(org, vel * 0.2, damage);
		}
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
	src = self.origin + v_forward * TE_LAVASPLASH;
	src_z = self.absmin_z + self.size_z * 0.7;
	ClearMultiDamage();
	while (shotcount > MSG_BROADCAST)
	{
		direction = dir + crandom() * spread_x * v_right + crandom() * spread_y * v_up;
		traceline(src, src + direction * IT_CELLS, 0, self);
		if (trace_fraction != WEAPON_SHOTGUN)
		{
			TraceAttack(WEAPON_SPIKES, direction);
		}
		shotcount = shotcount - WEAPON_SHOTGUN;
	}
	ApplyMultiDamage();
};

void() W_FireShotgun = 
{
	local vector dir;
	sound(self, CHAN_WEAPON, "weapons/guncock.wav", WEAPON_SHOTGUN, ATTN_NORM);
	self.punchangle_x = CONTENT_SOLID;
	self.currentammo = self.ammo_shells = self.ammo_shells - WEAPON_SHOTGUN;
	dir = aim(self, 100000);
	FireBullets(AS_LOITER, dir, '0.040000 0.040000 0');
};

void() W_FireSuperShotgun = 
{
	local vector dir;
	if (self.currentammo == WEAPON_SHOTGUN)
	{
		W_FireShotgun();
		return;
	}
	sound(self, CHAN_WEAPON, "weapons/shotgn2.wav", WEAPON_SHOTGUN, ATTN_NORM);
	self.punchangle_x = CONTENT_SLIME;
	self.currentammo = self.ammo_shells = self.ammo_shells - WEAPON_ROCKET;
	dir = aim(self, 100000);
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
	damg = 100 + random() * 20;
	if (other.health)
	{
		if (other.classname == "monster_shambler")
		{
			damg = damg * 0.5;
		}
		T_Damage(other, self, self.owner, damg);
	}
	T_RadiusDamage(self, self.owner, 120, other);
	self.origin = self.origin - WEAPON_BIG * normalize(self.velocity);
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord(MSG_BROADCAST, self.origin_x);
	WriteCoord(MSG_BROADCAST, self.origin_y);
	WriteCoord(MSG_BROADCAST, self.origin_z);
	sound(self, CHAN_AUTO, "weapons/expl1.wav", WEAPON_SHOTGUN, ATTN_NORM);
	BecomeExplosion();
};

void() W_FireRocket = 
{
	local entity missile;
	local entity mpuff;
	self.currentammo = self.ammo_rockets = self.ammo_rockets - WEAPON_SHOTGUN;
	sound(self, CHAN_WEAPON, "weapons/sgun1.wav", WEAPON_SHOTGUN, ATTN_NORM);
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
	missile.nextthink = time + AS_BLINDFIRE;
	missile.think = SUB_Remove;
	setmodel(missile, "progs/missile.mdl");
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(missile, self.origin + v_forward * WEAPON_BIG + '0 0 16');
};

void(vector p1, vector p2, entity from, float damage) LightningDamage = 
{
	local entity e1;
	local entity e2;
	local vector f;
	f = p2 - p1;
	normalize(f);
	f_x = MSG_BROADCAST - f_y;
	f_y = f_x;
	f_z = MSG_BROADCAST;
	f = f * IT_GRENADE_LAUNCHER;
	e2 = world;
	e1 = world;
	traceline(p1, p2, 0, self);
	if (trace_ent.takedamage)
	{
		particle(trace_endpos, '0 0 100', 225, damage * WEAPON_SPIKES);
		T_Damage(trace_ent, from, from, damage);
		if (self.classname == "player")
		{
			if (other.classname == "player")
			{
				trace_ent.velocity_z = trace_ent.velocity_z + 400;
			}
		}
	}
	e1 = trace_ent;
	traceline(p1 + f, p2 + f, 0, self);
	if (trace_ent != e1 && trace_ent.takedamage)
	{
		particle(trace_endpos, '0 0 100', 225, damage * WEAPON_SPIKES);
		T_Damage(trace_ent, from, from, damage);
	}
	e2 = trace_ent;
	traceline(p1 - f, p2 - f, 0, self);
	if (trace_ent != e1 && trace_ent != e2 && trace_ent.takedamage)
	{
		particle(trace_endpos, '0 0 100', 225, damage * WEAPON_SPIKES);
		T_Damage(trace_ent, from, from, damage);
	}
};

void() W_FireLightning = 
{
	local vector org;
	local float cells;
	local vector impactpoint;
	local vector reflectionvector;
	local vector reflectionpoint;
	local entity impactentity;
	if (self.ammo_cells < WEAPON_SHOTGUN)
	{
		self.weapon = W_BestWeapon();
		W_SetCurrentAmmo();
		return;
	}
	if (self.waterlevel > WEAPON_SHOTGUN)
	{
		cells = self.ammo_cells;
		self.ammo_cells = MSG_BROADCAST;
		W_SetCurrentAmmo();
		T_RadiusDamage(self, self, 35 * cells, world);
		return;
	}
	if (self.t_width < time)
	{
		sound(self, CHAN_WEAPON, "weapons/lhit.wav", WEAPON_SHOTGUN, ATTN_NORM);
		self.t_width = time + 0.6;
	}
	self.punchangle_x = CONTENT_SOLID;
	self.currentammo = self.ammo_cells = self.ammo_cells - WEAPON_SHOTGUN;
	org = self.origin + '0 0 16';
	traceline(org, org + v_forward * 600, 0, self);
	if (trace_ent.classname == "monster_death_lord" && trace_ent.shield == WEAPON_SHOTGUN)
	{
		SpawnShieldHit(trace_endpos, trace_endpos + v_forward * WEAPON_SPIKES, SVC_INTERMISSION);
		WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte(MSG_BROADCAST, TE_LIGHTNING2);
		WriteEntity(MSG_BROADCAST, self);
		WriteCoord(MSG_BROADCAST, org_x);
		WriteCoord(MSG_BROADCAST, org_y);
		WriteCoord(MSG_BROADCAST, org_z);
		WriteCoord(MSG_BROADCAST, trace_endpos_x);
		WriteCoord(MSG_BROADCAST, trace_endpos_y);
		WriteCoord(MSG_BROADCAST, trace_endpos_z);
		impactentity = trace_ent;
		T_Damage(impactentity, self, self, SVC_INTERMISSION);
		impactpoint = trace_endpos;
		reflectionpoint = org;
		reflectionpoint_x = reflectionpoint_x + (50 * random() - 25) * WEAPON_ROCKET;
		reflectionpoint_y = reflectionpoint_y + (50 * random() - 25) * WEAPON_ROCKET;
		reflectionpoint_z = reflectionpoint_z + (50 * random() - 25) * WEAPON_ROCKET;
		reflectionvector = reflectionpoint - impactpoint;
		reflectionvector = normalize(reflectionvector);
		traceline(impactpoint, impactpoint + reflectionvector * 600, 1, impactentity);
		WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte(MSG_BROADCAST, TE_LIGHTNING2);
		WriteEntity(MSG_BROADCAST, impactentity);
		WriteCoord(MSG_BROADCAST, impactpoint_x);
		WriteCoord(MSG_BROADCAST, impactpoint_y);
		WriteCoord(MSG_BROADCAST, impactpoint_z);
		WriteCoord(MSG_BROADCAST, trace_endpos_x);
		WriteCoord(MSG_BROADCAST, trace_endpos_y);
		WriteCoord(MSG_BROADCAST, trace_endpos_z);
		traceline(impactpoint, impactpoint + reflectionvector * 600, 0, impactentity);
		T_Damage(trace_ent, impactentity, self, 15);
	}
	else
	{
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
		traceline(org, org + v_forward * 600, 0, self);
		if (trace_ent.classname == "monster_polyp")
		{
			LightningDamage(org, trace_endpos + v_forward * WEAPON_SPIKES, self, 60);
		}
		else
		{
			LightningDamage(org, trace_endpos + v_forward * WEAPON_SPIKES, self, SVC_INTERMISSION);
		}
	}
};

void() s_pexplode1 = [0, s_pexplode2]
{
	self.nextthink = time + 0.1;
};

void() s_pexplode2 = [1, s_pexplode3]
{
	self.nextthink = time + 0.1;
};

void() s_pexplode3 = [2, s_pexplode4]
{
	self.nextthink = time + 0.1;
};

void() s_pexplode4 = [3, s_pexplode5]
{
	self.nextthink = time + 0.1;
};

void() s_pexplode5 = [4, SUB_Remove]
{
	self.nextthink = time + 0.1;
};

void() BecomePlasmaExplosion = 
{
	self.movetype = MOVETYPE_NONE;
	self.velocity = VEC_ORIGIN;
	self.touch = SUB_Null;
	setmodel(self, "progs/s_plas.spr");
	self.solid = SOLID_NOT;
	s_pexplode1();
};

void() T_PlasmaTouch = 
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
	damg = 50;
	if (other.health)
	{
		if (other.classname == "monster_zombie")
		{
			damg = 120;
		}
		T_Damage(other, self, self.owner, damg);
	}
	T_RadiusDamage(self, self.owner, 50, other);
	self.origin = self.origin - WEAPON_BIG * normalize(self.velocity);
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_EXPLOSION2);
	WriteCoord(MSG_BROADCAST, self.origin_x);
	WriteCoord(MSG_BROADCAST, self.origin_y);
	WriteCoord(MSG_BROADCAST, self.origin_z);
	WriteByte(MSG_BROADCAST, 35);
	WriteByte(MSG_BROADCAST, WEAPON_BIG);
	sound(self, CHAN_AUTO, "weapons/plasexpl.wav", WEAPON_SHOTGUN, ATTN_NORM);
	BecomePlasmaExplosion();
};

void() Plasma_Trail = 
{
	particle(self.origin, VEC_ORIGIN, 40, AS_MELEE);
	particle(self.origin, VEC_ORIGIN, 37, TE_WIZSPIKE);
	self.nextthink = time + 0.05;
	self.think = Plasma_Trail;
	self.coiled = self.coiled + 0.05;
	if (self.coiled >= WEAPON_SPIKES)
	{
		SUB_Remove();
	}
};

void() W_FirePlasma = 
{
	local entity missile;
	local entity mpuff;
	self.currentammo = self.ammo_cells = self.ammo_cells - WEAPON_SHOTGUN;
	sound(self, CHAN_WEAPON, "weapons/lancfire.wav", WEAPON_SHOTGUN, ATTN_NORM);
	self.punchangle_x = CONTENT_SOLID;
	missile = spawn();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	missile.classname = "missile";
	makevectors(self.v_angle);
	missile.velocity = aim(self, 1400);
	missile.velocity = missile.velocity * 100;
	missile.angles = vectoangles(missile.velocity);
	missile.velocity = missile.velocity * 14;
	missile.touch = T_PlasmaTouch;
	missile.nextthink = time + 0.05;
	missile.think = Plasma_Trail;
	setmodel(missile, "progs/plasma.mdl");
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(missile, self.origin + v_forward * WEAPON_BIG + '0 0 16');
};

void() GrenadeExplode = 
{
	T_RadiusDamage(self, self.owner, 120, world);
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord(MSG_BROADCAST, self.origin_x);
	WriteCoord(MSG_BROADCAST, self.origin_y);
	WriteCoord(MSG_BROADCAST, self.origin_z);
	sound(self, CHAN_AUTO, "weapons/expl1.wav", WEAPON_SHOTGUN, ATTN_NORM);
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
	sound(self, CHAN_WEAPON, "weapons/bounce.wav", WEAPON_SHOTGUN, ATTN_NORM);
	if (self.velocity == VEC_ORIGIN)
	{
		self.avelocity = VEC_ORIGIN;
	}
};

void() W_FireGrenade = 
{
	local entity missile;
	local entity mpuff;
	self.currentammo = self.ammo_rockets = self.ammo_rockets - WEAPON_SHOTGUN;
	sound(self, CHAN_WEAPON, "weapons/grenade.wav", WEAPON_SHOTGUN, ATTN_NORM);
	self.punchangle_x = CONTENT_SOLID;
	missile = spawn();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
	missile.classname = "grenade";
	makevectors(self.v_angle);
	if (self.v_angle_x)
	{
		missile.velocity = v_forward * 600 + v_up * 200 + crandom() * v_right * TE_LAVASPLASH + crandom() * v_up * TE_LAVASPLASH;
	}
	else
	{
		missile.velocity = aim(self, 10000);
		missile.velocity = missile.velocity * 600;
		missile.velocity_z = 200;
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
	newmis.nextthink = time + AS_LOITER;
	setmodel(newmis, "progs/spike.mdl");
	setsize(newmis, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(newmis, org);
	newmis.velocity = dir * 1000;
};

void() W_FireSuperSpikes = 
{
	local vector dir;
	local entity old;
	sound(self, CHAN_WEAPON, "weapons/spike2.wav", WEAPON_SHOTGUN, ATTN_NORM);
	self.attack_finished = time + 0.2;
	self.currentammo = self.ammo_nails = self.ammo_nails - WEAPON_ROCKET;
	dir = aim(self, 1000);
	launch_spike(self.origin + '0 0 16', dir);
	newmis.touch = superspike_touch;
	setmodel(newmis, "progs/s_spike.mdl");
	setsize(newmis, VEC_ORIGIN, VEC_ORIGIN);
	self.punchangle_x = CONTENT_SOLID;
	if (self.trinity_finished >= time)
	{
		newmis.dmg = WEAPON_SHOTGUN;
	}
};

void(float ox) W_FireSpikes = 
{
	local vector dir;
	local entity old;
	makevectors(self.v_angle);
	if (self.ammo_nails >= WEAPON_ROCKET && self.weapon == IT_SUPER_NAILGUN)
	{
		W_FireSuperSpikes();
		return;
	}
	if (self.ammo_nails < WEAPON_SHOTGUN)
	{
		self.weapon = W_BestWeapon();
		W_SetCurrentAmmo();
		return;
	}
	sound(self, CHAN_WEAPON, "weapons/rocket1i.wav", WEAPON_SHOTGUN, ATTN_NORM);
	self.attack_finished = time + 0.2;
	self.currentammo = self.ammo_nails = self.ammo_nails - WEAPON_SHOTGUN;
	dir = aim(self, 1000);
	launch_spike(self.origin + '0 0 16' + v_right * ox, dir);
	if (self.trinity_finished >= time)
	{
		newmis.dmg = WEAPON_SHOTGUN;
	}
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
		spawn_touchblood(TE_LIGHTNING3);
		if (other.classname == "monster_death_lord" && other.shield == WEAPON_SHOTGUN)
		{
			SpawnShieldHit(self.origin, VEC_ORIGIN, TE_LIGHTNING3);
		}
		if (self.dmg == WEAPON_SHOTGUN)
		{
			T_Damage(other, self, self.owner, SVC_KILLEDMONSTER);
		}
		else
		{
			T_Damage(other, self, self.owner, TE_LIGHTNING3);
		}
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
		if (other.classname == "monster_death_lord" && other.shield == WEAPON_SHOTGUN)
		{
			SpawnShieldHit(self.origin, VEC_ORIGIN, 18);
		}
		if (self.dmg == WEAPON_SHOTGUN)
		{
			T_Damage(other, self, self.owner, 54);
		}
		else
		{
			T_Damage(other, self, self.owner, 18);
		}
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

void() big_explosion_think = 
{
	self.frame = self.frame + WEAPON_SHOTGUN;
	if (self.frame > IT_GRENADE_LAUNCHER)
	{
		SUB_Remove();
	}
	self.nextthink = time + 0.05;
	self.think = big_explosion_think;
};

void(vector org, float snd) spawn_big_explosion = 
{
	local entity e;
	e = spawn();
	e.movetype = MOVETYPE_NONE;
	e.solid = SOLID_NOT;
	setmodel(e, "progs/bigexp.spr");
	setorigin(e, org);
	if (snd == WEAPON_SHOTGUN)
	{
		sound(e, CHAN_AUTO, "weapons/expl1.wav", 0.2, ATTN_NORM);
	}
	e.alpha = 0.6;
	e.effects = TRIGGER_SPAWNSILENT;
	e.nextthink = time + 0.05;
	e.think = big_explosion_think;
};

void() small_explosion_think = 
{
	self.frame = self.frame + WEAPON_SHOTGUN;
	if (self.frame > TE_BEAM)
	{
		SUB_Remove();
	}
	self.nextthink = time + 0.05;
	self.think = small_explosion_think;
};

void(vector org, float snd) spawn_small_explosion = 
{
	local entity e;
	e = spawn();
	e.movetype = MOVETYPE_NONE;
	e.solid = SOLID_NOT;
	setmodel(e, "progs/smlexp.spr");
	setorigin(e, org);
	if (snd == WEAPON_SHOTGUN)
	{
		sound(e, CHAN_AUTO, "weapons/expl1.wav", 0.2, ATTN_NORM);
	}
	e.alpha = 0.6;
	e.effects = TRIGGER_SPAWNSILENT;
	e.nextthink = time + 0.05;
	e.think = small_explosion_think;
};

void() shaker_think = 
{
	self.nextthink = time + self.lip;
	self.think = shaker_think;
	if (self.ltime > time)
	{
		self.spawnmaster.punchangle_x = (time - self.ltime) * random() * self.multiplier;
		self.spawnmaster.punchangle_y = (time - self.ltime) * random() * self.multiplier;
		self.spawnmaster.punchangle_z = (time - self.ltime) * random() * self.multiplier;
	}
	if (self.ltime < time)
	{
		SUB_Remove();
	}
};

void(entity e, float magnitude, float interval, float mult) shake_player = 
{
	local entity qent;
	qent = spawn();
	qent.owner = self;
	qent.movetype = MOVETYPE_NONE;
	qent.solid = SOLID_NOT;
	qent.spawnmaster = e;
	qent.nextthink = time + 0.1;
	qent.think = shaker_think;
	qent.ltime = time + magnitude;
	qent.lip = interval;
	qent.multiplier = mult;
	setsize(qent, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(qent, e.origin);
};

void() bombthink = 
{
	local float z;
	local vector org;
	local entity debris;
	T_WeakRadiusDamage(self, self.owner, IT_NAILS, world);
	self.frame = self.frame + WEAPON_SHOTGUN;
	if (self.frame == 24)
	{
		spawn_big_explosion(self.origin, MSG_BROADCAST);
	}
	if (self.frame > 25)
	{
		SUB_Remove();
		return;
	}
	self.think = bombthink;
	self.nextthink = time + 0.1;
};

void() ringthink = 
{
	self.nextthink = time + 0.1;
	self.think = ringthink;
	self.frame = self.frame + WEAPON_SHOTGUN;
	if (self.frame > 20)
	{
		SUB_Remove();
	}
};

void() ringprethink = 
{
	self.nextthink = time + 0.1;
	self.think = ringthink;
	self.avelocity = '0 0 200';
	setmodel(self, "progs/shockwave.mdl");
};

void() W_Bomb = 
{
	local entity bomb;
	local entity t;
	local float dist;
	local entity ring;
	if (coop == WEAPON_SHOTGUN && self.gotbomb != CONTENT_EMPTY)
	{
		self.gotbomb = WEAPON_SHOTGUN;
	}
	bomb = spawn();
	bomb.solid = SOLID_NOT;
	setsize(bomb, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(bomb, self.origin);
	setmodel(bomb, "progs/boom.mdl");
	bomb.think = bombthink;
	bomb.nextthink = time + 0.1;
	bomb.owner = self;
	bomb.effects = EF_BRIGHTLIGHT + TRIGGER_SPAWNSILENT;
	bomb.glow_color = 239;
	bomb.glow_size = 1000;
	if (cvar("pr_checkextension"))
	{
		if (checkextension("DP_TE_CUSTOMFLASH"))
		{
			te_customflash(self.origin, 1000, AS_BLINDFIRE, '1 0.6 0.6');
			bomb.effects = TRIGGER_SPAWNSILENT;
		}
	}
	spawn_big_explosion(self.origin);
	t = findradius(self.origin, 10000);
	while (t)
	{
		if (t.classname == "player")
		{
			dist = vlen(self.origin - t.origin);
			if (dist < 700)
			{
				shake_player(t, 2.5, 0.010000, WEAPON_BIG);
			}
			else
			{
				if (dist < 1200)
				{
					shake_player(t, WEAPON_SHOTGUN, 0.010000, TE_WIZSPIKE);
				}
				else
				{
					shake_player(t, 0.5, 0.010000, TE_LAVASPLASH);
				}
			}
		}
		t = t.chain;
	}
	ring = spawn();
	setorigin(ring, self.origin);
	ring.think = ringprethink;
	ring.nextthink = time + 0.3;
	ring.movetype = MOVETYPE_FLY;
	ring.effects = TRIGGER_SPAWNSILENT;
	ring = spawn();
	setorigin(ring, self.origin);
	ring.think = ringprethink;
	ring.nextthink = time + 0.3;
	ring.movetype = MOVETYPE_FLY;
	ring.effects = TRIGGER_SPAWNSILENT;
	ring.angles = '0 90 0';
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord(MSG_BROADCAST, self.origin_x);
	WriteCoord(MSG_BROADCAST, self.origin_y);
	WriteCoord(MSG_BROADCAST, self.origin_z);
	if (self.invincible_finished)
	{
		self.items = self.items - IT_INVULNERABILITY;
		self.invincible_time = MSG_BROADCAST;
		self.invincible_finished = MSG_BROADCAST;
	}
	if (self.cross_finished)
	{
		self.items2 = self.items2 - IT_CROSS;
		self.cross_finished = MSG_BROADCAST;
		self.cross_time = MSG_BROADCAST;
		self.cross_start = WEAPON_ROCKET;
		stuffcmd(self, "v_cshift 0 0 0 0\n");
	}
	T_WeakRadiusDamage(bomb, self, IT_NAILS, self);
	T_Damage(self, self, self, -666);
	self.velocity_z = 700;
	sound(self, CHAN_AUTO, "weapons/bombfar.wav", WEAPON_SHOTGUN, ATTN_NONE);
	sound(self, CHAN_AUTO, "weapons/bomb.wav", WEAPON_SHOTGUN, 0.7);
};

void() W_SetCurrentAmmo = 
{
	player_run();
	self.items = self.items - (self.items & (IT_SHELLS | IT_NAILS | IT_ROCKETS | IT_CELLS));
	if (self.weapon == IT_AXE)
	{
		self.currentammo = MSG_BROADCAST;
		if (!(self.items2 & IT_HAMMER))
		{
			self.weaponmodel = "progs/v_axe.mdl";
		}
		else
		{
			self.weaponmodel = "progs/v_ham.mdl";
		}
		self.weaponframe = MSG_BROADCAST;
	}
	else
	{
		if (self.weapon == IT_SHOTGUN)
		{
			self.currentammo = self.ammo_shells;
			self.weaponmodel = "progs/v_shot.mdl";
			self.weaponframe = MSG_BROADCAST;
			self.items = self.items | IT_SHELLS;
		}
		else
		{
			if (self.weapon == IT_SUPER_SHOTGUN)
			{
				self.currentammo = self.ammo_shells;
				self.weaponmodel = "progs/v_shot2.mdl";
				self.weaponframe = MSG_BROADCAST;
				self.items = self.items | IT_SHELLS;
			}
			else
			{
				if (self.weapon == IT_NAILGUN)
				{
					self.currentammo = self.ammo_nails;
					self.weaponmodel = "progs/v_nail.mdl";
					self.weaponframe = MSG_BROADCAST;
					self.items = self.items | IT_NAILS;
				}
				else
				{
					if (self.weapon == IT_SUPER_NAILGUN)
					{
						self.currentammo = self.ammo_nails;
						self.weaponmodel = "progs/v_nail2.mdl";
						self.weaponframe = MSG_BROADCAST;
						self.items = self.items | IT_NAILS;
					}
					else
					{
						if (self.weapon == IT_GRENADE_LAUNCHER)
						{
							self.currentammo = self.ammo_rockets;
							self.weaponmodel = "progs/v_rock.mdl";
							self.weaponframe = MSG_BROADCAST;
							self.items = self.items | IT_ROCKETS;
						}
						else
						{
							if (self.weapon == IT_COOPBOMB)
							{
								self.currentammo = WEAPON_SHOTGUN;
								self.weaponmodel = "progs/v_bomb.mdl";
								self.weaponframe = MSG_BROADCAST;
							}
							else
							{
								if (self.weapon == IT_ROCKET_LAUNCHER)
								{
									self.currentammo = self.ammo_rockets;
									self.weaponmodel = "progs/v_rock2.mdl";
									self.weaponframe = MSG_BROADCAST;
									self.items = self.items | IT_ROCKETS;
								}
								else
								{
									if (self.weapon == IT_LIGHTNING)
									{
										self.currentammo = self.ammo_cells;
										self.weaponmodel = "progs/v_light.mdl";
										self.weaponframe = MSG_BROADCAST;
										self.items = self.items | IT_CELLS;
									}
									else
									{
										if (self.weapon == IT_PLASMA)
										{
											self.currentammo = self.ammo_cells;
											self.weaponmodel = "progs/v_lance.mdl";
											self.weaponframe = MSG_BROADCAST;
											self.items = self.items | IT_CELLS;
										}
										else
										{
											self.currentammo = MSG_BROADCAST;
											self.weaponmodel = "";
											self.weaponframe = MSG_BROADCAST;
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

float() W_BestWeapon = 
{
	local float it;
	it = self.items;
	if (self.waterlevel <= WEAPON_SHOTGUN && self.ammo_cells >= WEAPON_SHOTGUN && (it & IT_LIGHTNING))
	{
		return IT_LIGHTNING;
	}
	if (self.ammo_nails >= WEAPON_ROCKET && (it & IT_SUPER_NAILGUN))
	{
		return IT_SUPER_NAILGUN;
	}
	if (self.ammo_shells >= WEAPON_ROCKET && (it & IT_SUPER_SHOTGUN))
	{
		return IT_SUPER_SHOTGUN;
	}
	if (self.ammo_nails >= WEAPON_SHOTGUN && (it & IT_NAILGUN))
	{
		return IT_NAILGUN;
	}
	if (self.ammo_shells >= WEAPON_SHOTGUN && (it & IT_SHOTGUN))
	{
		return IT_SHOTGUN;
	}
	return IT_AXE;
};

float() W_CheckNoAmmo = 
{
	if (self.currentammo > MSG_BROADCAST)
	{
		return 1;
	}
	if (self.weapon == IT_AXE)
	{
		return 1;
	}
	self.weapon = W_BestWeapon();
	W_SetCurrentAmmo();
	return 0;
};

void() W_Attack = 
{
	local float r;
	if (!W_CheckNoAmmo())
	{
		return;
	}
	makevectors(self.v_angle);
	self.show_hostile = time + WEAPON_SHOTGUN;
	if (self.weapon == IT_AXE)
	{
		sound(self, CHAN_WEAPON, "weapons/ax1.wav", WEAPON_SHOTGUN, ATTN_NORM);
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
		if (self.weapon == IT_SHOTGUN)
		{
			player_shot1();
			W_FireShotgun();
			self.attack_finished = time + 0.5;
		}
		else
		{
			if (self.weapon == IT_SUPER_SHOTGUN)
			{
				player_shot1();
				W_FireSuperShotgun();
				self.attack_finished = time + 0.7;
			}
			else
			{
				if (self.weapon == IT_NAILGUN)
				{
					player_nail1();
				}
				else
				{
					if (self.weapon == IT_SUPER_NAILGUN)
					{
						player_nail1();
					}
					else
					{
						if (self.weapon == IT_GRENADE_LAUNCHER)
						{
							player_rocket1();
							W_FireGrenade();
							self.attack_finished = time + 0.6;
						}
						else
						{
							if (self.weapon == IT_COOPBOMB)
							{
								player_bomb1();
								sound(self, CHAN_AUTO, "player/h2odeath.wav", WEAPON_SHOTGUN, ATTN_NORM);
								self.attack_finished = time + WEAPON_ROCKET;
							}
							else
							{
								if (self.weapon == IT_ROCKET_LAUNCHER)
								{
									player_rocket1();
									W_FireRocket();
									self.attack_finished = time + 0.8;
								}
								else
								{
									if (self.weapon == IT_LIGHTNING)
									{
										player_light1();
										self.attack_finished = time + 0.1;
										sound(self, CHAN_AUTO, "weapons/lstart.wav", WEAPON_SHOTGUN, ATTN_NORM);
									}
									else
									{
										if (self.weapon == IT_PLASMA)
										{
											player_plasma1a();
											self.attack_finished = time + 0.2;
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
	it = self.items;
	am = MSG_BROADCAST;
	if (self.impulse == WEAPON_SHOTGUN)
	{
		fl = IT_AXE;
	}
	else
	{
		if (self.impulse == WEAPON_ROCKET)
		{
			fl = IT_SHOTGUN;
			if (self.ammo_shells < WEAPON_SHOTGUN)
			{
				am = WEAPON_SHOTGUN;
			}
		}
		else
		{
			if (self.impulse == AS_MELEE)
			{
				fl = IT_SUPER_SHOTGUN;
				if (self.ammo_shells < WEAPON_ROCKET)
				{
					am = WEAPON_SHOTGUN;
				}
			}
			else
			{
				if (self.impulse == WEAPON_SPIKES)
				{
					fl = IT_NAILGUN;
					if (self.ammo_nails < WEAPON_SHOTGUN)
					{
						am = WEAPON_SHOTGUN;
					}
				}
				else
				{
					if (self.impulse == AS_BLINDFIRE)
					{
						fl = IT_SUPER_NAILGUN;
						if (self.ammo_nails < WEAPON_ROCKET)
						{
							am = WEAPON_SHOTGUN;
						}
					}
					else
					{
						if (self.impulse == AS_LOITER)
						{
							if (self.weapon == IT_GRENADE_LAUNCHER)
							{
								fl = IT_COOPBOMB;
							}
							else
							{
								fl = IT_GRENADE_LAUNCHER;
							}
							if (self.ammo_rockets < WEAPON_SHOTGUN)
							{
								am = WEAPON_SHOTGUN;
							}
						}
						else
						{
							if (self.impulse == 251)
							{
								fl = IT_COOPBOMB;
							}
							else
							{
								if (self.impulse == TE_WIZSPIKE)
								{
									fl = IT_ROCKET_LAUNCHER;
									if (self.ammo_rockets < WEAPON_SHOTGUN)
									{
										am = WEAPON_SHOTGUN;
									}
								}
								else
								{
									if (self.impulse == WEAPON_BIG)
									{
										fl = IT_LIGHTNING;
										if (self.ammo_cells < WEAPON_SHOTGUN)
										{
											am = WEAPON_SHOTGUN;
										}
									}
									else
									{
										if (self.impulse == 250)
										{
											fl = IT_PLASMA;
											if (self.ammo_cells < WEAPON_SHOTGUN)
											{
												am = WEAPON_SHOTGUN;
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
	self.impulse = MSG_BROADCAST;
	if (!(self.items & fl))
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
	W_SetCurrentAmmo();
};

void() CheatCommand = 
{
	if (deathmatch || coop)
	{
		return;
	}
	self.ammo_rockets = 100;
	self.ammo_nails = 200;
	self.ammo_shells = 100;
	self.items = self.items | IT_AXE | IT_SHOTGUN | IT_SUPER_SHOTGUN | IT_NAILGUN | IT_SUPER_NAILGUN | IT_GRENADE_LAUNCHER | IT_PLASMA | IT_ROCKET_LAUNCHER;
	self.ammo_cells = 100;
	self.items = self.items | IT_LIGHTNING;
	self.weapon = IT_PLASMA;
	self.impulse = MSG_BROADCAST;
	W_SetCurrentAmmo();
};

void() KeysCheat = 
{
	if (deathmatch || coop)
	{
		return;
	}
	self.items = self.items | IT_KEY1 | IT_KEY2;
	self.impulse = MSG_BROADCAST;
	W_SetCurrentAmmo();
};

void() LanceCheat = 
{
	if (deathmatch)
	{
		return;
	}
	self.ammo_cells = 100;
	self.items = self.items | IT_PLASMA;
	self.weapon = IT_PLASMA;
	self.impulse = MSG_BROADCAST;
	W_SetCurrentAmmo();
};

void() CycleWeaponCommand = 
{
	local float it;
	local float am;
	it = self.items;
	self.impulse = MSG_BROADCAST;
	while (WEAPON_SHOTGUN)
	{
		am = MSG_BROADCAST;
		if (self.weapon == IT_PLASMA)
		{
			self.weapon = IT_AXE;
		}
		else
		{
			if (self.weapon == IT_AXE)
			{
				self.weapon = IT_SHOTGUN;
				if (self.ammo_shells < WEAPON_SHOTGUN)
				{
					am = WEAPON_SHOTGUN;
				}
			}
			else
			{
				if (self.weapon == IT_SHOTGUN)
				{
					self.weapon = IT_SUPER_SHOTGUN;
					if (self.ammo_shells < WEAPON_ROCKET)
					{
						am = WEAPON_SHOTGUN;
					}
				}
				else
				{
					if (self.weapon == IT_SUPER_SHOTGUN)
					{
						self.weapon = IT_NAILGUN;
						if (self.ammo_nails < WEAPON_SHOTGUN)
						{
							am = WEAPON_SHOTGUN;
						}
					}
					else
					{
						if (self.weapon == IT_NAILGUN)
						{
							self.weapon = IT_SUPER_NAILGUN;
							if (self.ammo_nails < WEAPON_ROCKET)
							{
								am = WEAPON_SHOTGUN;
							}
						}
						else
						{
							if (self.weapon == IT_SUPER_NAILGUN)
							{
								self.weapon = IT_GRENADE_LAUNCHER;
								if (self.ammo_rockets < WEAPON_SHOTGUN)
								{
									am = WEAPON_SHOTGUN;
								}
							}
							else
							{
								if (self.weapon == IT_GRENADE_LAUNCHER)
								{
									self.weapon = IT_COOPBOMB;
								}
								else
								{
									if (self.weapon == IT_COOPBOMB)
									{
										self.weapon = IT_ROCKET_LAUNCHER;
										if (self.ammo_cells < WEAPON_SHOTGUN)
										{
											am = WEAPON_SHOTGUN;
										}
									}
									else
									{
										if (self.weapon == IT_ROCKET_LAUNCHER)
										{
											self.weapon = IT_LIGHTNING;
											if (self.ammo_cells < WEAPON_SHOTGUN)
											{
												am = WEAPON_SHOTGUN;
											}
										}
										else
										{
											if (self.weapon == IT_LIGHTNING)
											{
												self.weapon = IT_PLASMA;
												if (self.ammo_cells < WEAPON_SHOTGUN)
												{
													am = WEAPON_SHOTGUN;
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
		if (it & self.weapon && am == MSG_BROADCAST)
		{
			W_SetCurrentAmmo();
			return;
		}
	}
};

void() CycleWeaponReverseCommand = 
{
	local float it;
	local float am;
	it = self.items;
	self.impulse = MSG_BROADCAST;
	while (WEAPON_SHOTGUN)
	{
		am = MSG_BROADCAST;
		if (self.weapon == IT_LIGHTNING)
		{
			self.weapon = IT_ROCKET_LAUNCHER;
			if (self.ammo_rockets < WEAPON_SHOTGUN)
			{
				am = WEAPON_SHOTGUN;
			}
		}
		else
		{
			if (self.weapon == IT_ROCKET_LAUNCHER)
			{
				self.weapon = IT_COOPBOMB;
			}
			else
			{
				if (self.weapon == IT_COOPBOMB)
				{
					self.weapon = IT_GRENADE_LAUNCHER;
					if (self.ammo_rockets < WEAPON_SHOTGUN)
					{
						am = WEAPON_SHOTGUN;
					}
				}
				else
				{
					if (self.weapon == IT_GRENADE_LAUNCHER)
					{
						self.weapon = IT_SUPER_NAILGUN;
						if (self.ammo_nails < WEAPON_ROCKET)
						{
							am = WEAPON_SHOTGUN;
						}
					}
					else
					{
						if (self.weapon == IT_SUPER_NAILGUN)
						{
							self.weapon = IT_NAILGUN;
							if (self.ammo_nails < WEAPON_SHOTGUN)
							{
								am = WEAPON_SHOTGUN;
							}
						}
						else
						{
							if (self.weapon == IT_NAILGUN)
							{
								self.weapon = IT_SUPER_SHOTGUN;
								if (self.ammo_shells < WEAPON_ROCKET)
								{
									am = WEAPON_SHOTGUN;
								}
							}
							else
							{
								if (self.weapon == IT_SUPER_SHOTGUN)
								{
									self.weapon = IT_SHOTGUN;
									if (self.ammo_shells < WEAPON_SHOTGUN)
									{
										am = WEAPON_SHOTGUN;
									}
								}
								else
								{
									if (self.weapon == IT_SHOTGUN)
									{
										self.weapon = IT_AXE;
									}
									else
									{
										if (self.weapon == IT_AXE)
										{
											self.weapon = IT_PLASMA;
											if (self.ammo_cells < WEAPON_SHOTGUN)
											{
												am = WEAPON_SHOTGUN;
											}
										}
										else
										{
											if (self.weapon == IT_PLASMA)
											{
												self.weapon = IT_LIGHTNING;
												if (self.ammo_cells < WEAPON_SHOTGUN)
												{
													am = WEAPON_SHOTGUN;
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
		if (it & self.weapon && am == MSG_BROADCAST)
		{
			W_SetCurrentAmmo();
			return;
		}
	}
};

void() ServerflagsCommand = 
{
	serverflags = serverflags * WEAPON_ROCKET + WEAPON_SHOTGUN;
};

void() QuadCheat = 
{
	if (deathmatch || coop)
	{
		return;
	}
	self.super_time = WEAPON_SHOTGUN;
	self.super_damage_finished = time + SVC_INTERMISSION;
	self.items = self.items | IT_QUAD;
	dprint("quad cheat\n");
};

void() TrinityCheat = 
{
	if (deathmatch || coop)
	{
		return;
	}
	self.trinity_time = WEAPON_SHOTGUN;
	self.trinity_start = WEAPON_SHOTGUN;
	self.trinity_finished = time + SVC_INTERMISSION;
	self.items2 = self.items2 | IT_TRINITY;
	dprint("trinity cheat\n");
};

void() CrossCheat = 
{
	if (deathmatch || coop)
	{
		return;
	}
	self.cross_time = WEAPON_SHOTGUN;
	self.cross_start = WEAPON_SHOTGUN;
	self.cross_finished = time + SVC_INTERMISSION;
	self.items2 = self.items2 | IT_CROSS;
	dprint("Cross Cheat\n");
};

void() HammerCheat = 
{
	if (deathmatch || coop)
	{
		return;
	}
	sound(other, CHAN_ITEM, "weapons/pkup.wav", WEAPON_SHOTGUN, ATTN_NORM);
	self.items2 = self.items2 | IT_HAMMER;
	self.weapon = IT_AXE;
	dprint("You got the Hammer\n");
};

void() BombCheat = 
{
	if (!coop)
	{
		return;
	}
	sound(self, CHAN_ITEM, "weapons/pkup.wav", WEAPON_SHOTGUN, ATTN_NORM);
	self.items = self.items | IT_COOPBOMB;
	self.weapon = IT_COOPBOMB;
	dprint("You got the Bomb\n");
	self.impulse = MSG_BROADCAST;
	W_SetCurrentAmmo();
};

void() ResetBombCounter = 
{
	if (!coop)
	{
		return;
	}
	sound(self, CHAN_ITEM, "player/axhit2.wav", WEAPON_SHOTGUN, ATTN_NORM);
	self.gotbomb = CONTENT_EMPTY;
	bprint("oMg sEcReT??!\n");
};

void() Genocide = 
{
	local entity head;
	if (deathmatch || coop)
	{
		return;
	}
	bprint("Genocide!\n");
	head = nextent(world);
	while (head != world)
	{
		if (head.health > MSG_BROADCAST && (head.flags & FL_MONSTER))
		{
			T_Damage(head, world, world, head.health + TE_LAVASPLASH);
		}
		head = nextent(head);
	}
};

void() MapIndexCheat = 
{
	if (deathmatch || coop)
	{
		return;
	}
	bprint(ftos(parm9));
	bprint("<-- mapindex\n");
};

void() ImpulseCommands = 
{
	if (self.impulse >= WEAPON_SHOTGUN && self.impulse <= WEAPON_BIG || self.impulse == 250)
	{
		W_ChangeWeapon();
	}
	if (self.impulse == TE_LIGHTNING3)
	{
		CheatCommand();
	}
	if (self.impulse == TE_LAVASPLASH)
	{
		CycleWeaponCommand();
	}
	if (self.impulse == TE_TELEPORT)
	{
		ServerflagsCommand();
	}
	if (self.impulse == TE_EXPLOSION2)
	{
		CycleWeaponReverseCommand();
	}
	if (self.impulse == 66)
	{
		BombCheat();
	}
	if (self.impulse == 65)
	{
		ResetBombCounter();
	}
	if (self.impulse == 99)
	{
		HammerCheat();
	}
	if (self.impulse == 205)
	{
		Genocide();
	}
	if (self.impulse == 255)
	{
		QuadCheat();
	}
	if (self.impulse == 249)
	{
		LanceCheat();
	}
	if (self.impulse == 253)
	{
		KeysCheat();
	}
	if (self.impulse == 111)
	{
		TrinityCheat();
	}
	if (self.impulse == 222)
	{
		CrossCheat();
	}
	if (self.impulse == 223)
	{
		MapIndexCheat();
	}
	self.impulse = MSG_BROADCAST;
};

void() W_WeaponFrame = 
{
	if (time < self.attack_finished)
	{
		return;
	}
	ImpulseCommands();
	if (self.button0)
	{
		SuperDamageSound();
		W_Attack();
	}
};

void() SuperDamageSound = 
{
	if (self.super_damage_finished > time)
	{
		if (self.super_sound < time)
		{
			self.super_sound = time + WEAPON_SHOTGUN;
			sound(self, CHAN_BODY, "items/damage3.wav", WEAPON_SHOTGUN, ATTN_NORM);
		}
	}
	return;
};

void() TrinitySound = 
{
	if (self.trinity_finished > time)
	{
		if (self.trinity_sound < time)
		{
			self.trinity_sound = time + 0.75;
			sound(self, CHAN_BODY, "items2/trinuse.wav", WEAPON_SHOTGUN, ATTN_NORM);
		}
	}
	return;
};


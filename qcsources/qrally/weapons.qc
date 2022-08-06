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
};

float() crandom = 
{
	return 2 * (random() - 0.5);
};

void() W_FireAxe = 
{
	local vector source;
	local vector org;
	source = self.origin + '0 0 16';
	traceline(source, source + v_forward * 64, 0, self);
	if (trace_fraction == 1)
	{
		return;
	}
	org = trace_endpos - v_forward * 4;
	if (trace_ent.takedamage)
	{
		trace_ent.axhitme = 1;
		SpawnBlood(org, '0 0 0', 20);
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
	vel = vel + 2 * trace_plane_normal;
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
	missile.nextthink = time + 1;
	missile.think = SUB_Remove;
	setmodel(missile, "progs/zom_gib.mdl");
	setsize(missile, '0 0 0', '0 0 0');
	setorigin(missile, org);
};

void(vector org, vector vel, float damage) SpawnBlood = 
{
	particle(org, vel * 0.1, 73, damage * 2);
};

void(float damage) spawn_touchblood = 
{
	local vector vel;
	vel = wall_velocity() * 0.2;
	SpawnBlood(self.origin + vel * 0.010000, vel, damage);
};

void(vector org, vector vel) SpawnChunk = 
{
	particle(org, vel * 0.020000, 0, 10);
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
	vel = vel + 2 * trace_plane_normal;
	vel = vel * 200;
	org = trace_endpos - dir * 4;
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
	src = self.origin + v_forward * 10;
	src_z = self.absmin_z + self.size_z * 0.7;
	ClearMultiDamage();
	while (shotcount > 0)
	{
		direction = dir + crandom() * spread_x * v_right + crandom() * spread_y * v_up;
		traceline(src, src + direction * 2048, 0, self);
		if (trace_fraction != 1)
		{
			TraceAttack(4, direction);
		}
		shotcount = shotcount - 1;
	}
	ApplyMultiDamage();
};

void() W_FireShotgun = 
{
	local vector dir;
	sound(self, CHAN_WEAPON, "weapons/guncock.wav", 1, ATTN_NORM);
	self.punchangle_x = -2;
	self.currentammo = self.ammo_shells = self.ammo_shells - 1;
	dir = aim(self, 100000);
	FireBullets(6, dir, '0.040000 0.040000 0');
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
	self.punchangle_x = -4;
	self.currentammo = self.ammo_shells = self.ammo_shells - 2;
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
	self.velocity = '0 0 0';
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
	damg = 50 + random() * 20;
	if (other.classname == "rally_kangaroo")
	{
		damg = damg * 5;
	}
	else
	{
		if (other.classname == "rally_dude")
		{
			damg = damg * 2;
		}
	}
	if (other.health)
	{
		if (other.classname == "monster_shambler")
		{
			damg = damg * 0.5;
		}
		T_Damage(other, self, self.owner, damg);
	}
	T_RadiusDamage(self, self.owner, 120, other);
	self.origin = self.origin - 8 * normalize(self.velocity);
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
	local entity missile_enemy;
	local vector dir;
	local vector old_forward;
	self.currentammo = self.ammo_rockets = self.ammo_rockets - 1;
	sound(self, CHAN_WEAPON, "weapons/sgun1.wav", 1, ATTN_NORM);
	self.punchangle_x = -2;
	missile = spawn();
	missile.last_idle = time;
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	old_forward = v_forward;
	dir = self.v_angle;
	dir_x = 0;
	makevectors(dir);
	dir = v_forward;
	if ((missile_enemy = FindSightEnemy(self.origin, dir, 1500, 45, "all", self)) != world)
	{
		if (missile_enemy.classname == "player")
		{
			commentary(missile_enemy, "process/buzztst1.wav");
		}
		missile.enemy = missile_enemy;
		missile.nextthink = time + frametime;
		missile.think = RocketSeek;
	}
	else
	{
		missile.nextthink = time + 5;
		missile.think = SUB_Remove;
	}
	v_forward = old_forward;
	missile.velocity = v_forward;
	missile.velocity = missile.velocity * (vlen(self.velocity) + 600);
	missile.angles = vectoangles(missile.velocity);
	missile.touch = T_MissileTouch;
	setmodel(missile, "models/missile.mdl");
	setsize(missile, '0 0 0', '0 0 0');
	setorigin(missile, self.veh_body.origin + v_forward * 8 + v_up * 8);
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
	f = f * 16;
	e2 = world;
	e1 = world;
	traceline(p1, p2, 0, self);
	if (trace_ent.takedamage)
	{
		particle(trace_endpos, '0 0 100', 225, damage * 4);
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
		particle(trace_endpos, '0 0 100', 225, damage * 4);
		T_Damage(trace_ent, from, from, damage);
	}
	e2 = trace_ent;
	traceline(p1 - f, p2 - f, 0, self);
	if (trace_ent != e1 && trace_ent != e2 && trace_ent.takedamage)
	{
		particle(trace_endpos, '0 0 100', 225, damage * 4);
		T_Damage(trace_ent, from, from, damage);
	}
};

void() W_FireLightning = 
{
	local vector org;
};

void() GrenadeExplode = 
{
	T_RadiusDamage(self.enemy, world, 60, self.enemy);
	if (self.enemy.classname == "player")
	{
		self.enemy.velocity = self.enemy.velocity + '0 0 1000';
		setorigin(self.enemy, self.enemy.origin + '0 0 4');
		if (self.enemy.flags & FL_ONGROUND)
		{
			self.enemy.flags = self.enemy.flags - FL_ONGROUND;
		}
		self.enemy.last_flags = self.enemy.flags;
		self.enemy.veh_body.roll_velocity_z = random() * 20 - 10;
		self.enemy.racing_flags = self.enemy.racing_flags | QR_MINE_EXPLODED;
	}
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord(MSG_BROADCAST, self.enemy.origin_x);
	WriteCoord(MSG_BROADCAST, self.enemy.origin_y);
	WriteCoord(MSG_BROADCAST, self.enemy.origin_z);
	BecomeExplosion();
	self.enemy.mine_attached = world;
};

void() GrenadeDetonateThink = 
{
	sound(self.enemy, CHAN_AUTO, "rally/minebeep.wav", 1, ATTN_NORM);
	if (time - self.last_engine < 5)
	{
		self.nextthink = time + 1;
	}
	else
	{
		if (time - self.last_engine < 6)
		{
			self.nextthink = time + 0.5;
		}
		else
		{
			if (time - self.last_engine < 7)
			{
				self.nextthink = time + 0.25;
			}
			else
			{
				if (time - self.last_engine < 8)
				{
					self.nextthink = time + 0.1;
				}
				else
				{
					if (deathmatch)
					{
						T_Damage(self.enemy, self, self, 80);
					}
					else
					{
						T_Damage(self.enemy, self, self, 30);
					}
					GrenadeExplode();
				}
			}
		}
	}
};

void() GrenadeTouch = 
{
	if (other.mine_attached != world)
	{
		return;
	}
	if (other.classname == "player")
	{
		self.solid = SOLID_NOT;
		sound(self, CHAN_AUTO, "rally/minebeep.wav", 1, ATTN_NORM);
		self.enemy = other;
		self.think = GrenadeDetonateThink;
		self.nextthink = time + 1;
		self.last_engine = time;
		self.effects = 0;
		setmodel(self, string_null);
		sprint(other, "Detonator will explode in 5 seconds\n");
		other.mine_attached = self;
		return;
	}
	sound(self, CHAN_WEAPON, "weapons/bounce.wav", 1, ATTN_NORM);
	if (self.velocity == '0 0 0')
	{
		self.avelocity = '0 0 0';
		self.angles = '0 0 0';
	}
};

void() GrenadeThink = 
{
	if (self.last_idle < time)
	{
		remove(self);
		return;
	}
	if (self.movetype == MOVETYPE_BOUNCE && self.oldorigin == self.origin)
	{
		self.movetype = MOVETYPE_NONE;
		self.solid = SOLID_TRIGGER;
		setorigin(self, self.origin + '0 0 4');
	}
	self.oldorigin = self.origin;
	self.nextthink = time + 0.5;
};

void() W_FireGrenade = 
{
	local entity missile;
	local entity mpuff;
	self.currentammo = self.ammo_rockets = self.ammo_rockets - 1;
	sound(self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM);
	self.punchangle_x = -2;
	missile = spawn();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
	missile.classname = "grenade";
	makevectors(self.veh_body.angles);
	missile.velocity = '0 0 200';
	missile.avelocity = '0 300 0';
	missile.touch = GrenadeTouch;
	missile.last_idle = time + 10;
	missile.oldorigin = missile.origin;
	missile.nextthink = time + 1;
	missile.think = GrenadeThink;
	setmodel(missile, "models/detnator.mdl");
	setsize(missile, '0 0 0', '0 0 0');
	setorigin(missile, self.origin);
};

void() MineExplode = 
{
	T_RadiusDamage(self, self.owner, 80, other);
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord(MSG_BROADCAST, self.origin_x);
	WriteCoord(MSG_BROADCAST, self.origin_y);
	WriteCoord(MSG_BROADCAST, self.origin_z);
	BecomeExplosion();
};

void() MineTouch = 
{
	if (other == self.owner)
	{
		return;
	}
	if (other.takedamage == DAMAGE_AIM)
	{
		T_Damage(other, self, self.owner, 80);
		MineExplode();
		return;
	}
	sound(self, CHAN_WEAPON, "weapons/bounce.wav", 1, ATTN_NORM);
	if (self.velocity == '0 0 0')
	{
		self.avelocity = '0 0 0';
	}
};

void(vector org, float right) SpawnMine = 
{
	local vector vel_norm;
	local entity missile;
	missile = spawn();
	missile.owner = self.owner;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
	missile.classname = "mine";
	vel_norm = normalize(v_forward * 3 + v_right * right);
	missile.velocity = vel_norm * vlen(self.velocity);
	missile.velocity_z = self.velocity_z;
	missile.avelocity = '300 300 300';
	missile.angles = vectoangles(missile.velocity);
	missile.touch = MineTouch;
	missile.last_idle = time;
	missile.oldorigin = missile.origin;
	missile.nextthink = time + 0.1;
	missile.think = MineThink;
	setmodel(missile, "models/mine.mdl");
	missile.frame = 1;
	setsize(missile, '-4 -4 0', '4 4 4');
	setorigin(missile, self.origin + v_right * 12 * right);
};

void() MineThink = 
{
	local vector old_vel;
	local float dist;
	local entity trav;
	if (self.last_idle < time - 3)
	{
		MineExplode();
		return;
	}
	if (self.frame != 1 && self.last_idle < time - 0.5)
	{
		if (random() < 0.15)
		{
			old_vel = self.velocity;
			old_vel = vectoangles(old_vel);
			makevectors(old_vel);
			SpawnMine(self.origin, 1);
			SpawnMine(self.origin, -1);
		}
		self.velocity_z = self.velocity_z * 0.75;
		self.frame = 1;
	}
	if (self.enemy == world)
	{
		trav = findradius(self.origin, 64);
		while (trav != world && trav.takedamage != DAMAGE_AIM)
		{
			trav = trav.chain;
		}
		if (trav != world && trav != self.owner)
		{
			other = trav;
			MineTouch();
			return;
		}
	}
	if (vlen(self.velocity) < 20)
	{
		self.think = SUB_Remove;
		self.nextthink = time + 5;
	}
	else
	{
		self.nextthink = time + 0.1;
	}
};

void() W_FireMine = 
{
	local entity missile;
	local entity mpuff;
	if (self.currentammo >= 3)
	{
		self.currentammo = self.ammo_rockets = self.ammo_rockets - 3;
	}
	else
	{
		self.ammo_rockets = 0;
		self.currentammo = 0;
	}
	sound(self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM);
	self.punchangle_x = -2;
	missile = spawn();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
	missile.classname = "mine";
	makevectors(self.veh_body.angles - self.body_roll);
	missile.velocity = v_forward * (100 + vlen(self.velocity) * 1.5);
	missile.velocity_z = 250;
	missile.avelocity = '300 300 300';
	missile.angles = vectoangles(missile.velocity);
	missile.touch = MineTouch;
	missile.last_idle = time;
	missile.oldorigin = missile.origin;
	missile.nextthink = time + 0.1;
	missile.think = MineThink;
	setmodel(missile, "models/mine.mdl");
	setsize(missile, '-4 -4 0', '4 4 4');
	setorigin(missile, self.origin);
};

void() LaserTouch = 
{
	if (other == self.owner)
	{
		return;
	}
	if (other.takedamage == DAMAGE_AIM)
	{
		spawn_touchblood(20);
		T_Damage(other, self, self.owner, 20);
		remove(self);
		return;
	}
	self.last_jump_z = time;
	sound(self, CHAN_AUTO, "rally/process/spark4.wav", 1, ATTN_NORM);
	if (self.velocity == '0 0 0')
	{
		remove(self);
	}
};

void(vector dir) spawn_laser = 
{
	local entity missile;
	local entity mpuff;
	local vector vect;
	missile = spawn();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
	missile.classname = "laser";
	vect = normalize(dir);
	missile.velocity = vect * (2000 + vlen(self.velocity) * 1.5);
	missile.angles = vectoangles(missile.velocity);
	missile.old_velocity = missile.velocity;
	missile.touch = LaserTouch;
	missile.last_jump_z = 0;
	missile.oldorigin = missile.origin;
	missile.nextthink = time + 0.75;
	missile.think = SUB_Remove;
	setmodel(missile, "progs/laser.mdl");
	setsize(missile, '0 0 0', '0 0 0');
	setorigin(missile, self.origin + vect * 4);
};

void() W_FireLaser = 
{
	if (self.currentammo >= 2)
	{
		self.currentammo = self.ammo_roobar = self.ammo_roobar - 2;
	}
	else
	{
		self.ammo_roobar = 0;
		self.currentammo = 0;
	}
	sound(self, CHAN_WEAPON, "enforcer/enfire.wav", 1, ATTN_NORM);
	self.punchangle_x = -2;
	makevectors(self.veh_body.angles - self.body_roll);
	v_forward_z = -1 * v_forward_z;
	if (fabs(v_forward_z) < 0.1)
	{
		v_forward_z = 0;
	}
	if (fabs(v_right_z) < 0.1)
	{
		v_right_z = 0;
	}
	spawn_laser(v_forward);
	spawn_laser(v_forward * 4 + v_right);
	spawn_laser(v_forward * 4 - v_right);
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
	newmis.nextthink = time + 6;
	setmodel(newmis, "progs/spike.mdl");
	setsize(newmis, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(newmis, org);
	newmis.velocity = dir * 1500;
};

void() W_FireSuperSpikes = 
{
	local vector dir;
	local entity old;
	dir = self.veh_body.angles;
	if (self.flags & FL_ONGROUND)
	{
		traceline(self.origin, self.origin - '0 0 64', 1, self);
		if (trace_plane_normal == '0 0 1')
		{
			dir_x = 0;
		}
	}
	dir_x = -1 * dir_x;
	makevectors(dir);
	self.currentammo = self.ammo_nails = self.ammo_nails - 1;
	self.attack_finished = time + 0.2;
	sound(self, CHAN_WEAPON, "weapons/spike2.wav", 1, ATTN_NORM);
	self.attack_finished = time + 0.2;
	traceline(self.origin + '0 0 8', self.origin + '0 0 8' + v_forward * 2048, 0, self);
	if (trace_ent != world)
	{
		if (trace_ent.takedamage != DAMAGE_NO)
		{
			spawn_touchblood(10);
			T_Damage(trace_ent, self, self, 40);
		}
	}
	else
	{
		if (trace_fraction < 1)
		{
			WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
			WriteByte(MSG_BROADCAST, TE_GUNSHOT);
			WriteCoord(MSG_BROADCAST, trace_endpos_x);
			WriteCoord(MSG_BROADCAST, trace_endpos_y);
			WriteCoord(MSG_BROADCAST, trace_endpos_z);
		}
	}
};

void(float ox) W_FireSpikes = 
{
	local vector dir;
	local entity old;
	if (self.ammo_nails < 1)
	{
		self.weapon = W_BestWeapon();
		W_SetCurrentAmmo();
		return;
	}
	if (self.weapon == IT_SUPER_NAILGUN)
	{
		W_FireSuperSpikes();
		return;
	}
	sound(self, CHAN_WEAPON, "weapons/rocket1i.wav", 1, ATTN_NORM);
	self.attack_finished = time + 0.2;
	self.currentammo = self.ammo_nails = self.ammo_nails - 1;
	dir = v_forward;
	launch_spike(self.veh_body.origin + v_right * ox, dir);
	self.punchangle_x = -2;
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
		spawn_touchblood(15);
		T_Damage(other, self, self.owner, 15);
		rand = random();
		if (rand < 0.3)
		{
			sound(other, CHAN_AUTO, "weapons/ric1.wav", 1, ATTN_NORM);
		}
		else
		{
			if (rand < 0.65)
			{
				sound(other, CHAN_AUTO, "weapons/ric2.wav", 1, ATTN_NORM);
			}
			else
			{
				sound(other, CHAN_AUTO, "weapons/ric3.wav", 1, ATTN_NORM);
			}
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
		T_Damage(other, self, self.owner, 30);
		rand = random();
		if (rand < 0.3)
		{
			sound(other, CHAN_AUTO, "weapons/ric1.wav", 1, ATTN_NORM);
		}
		else
		{
			if (rand < 0.65)
			{
				sound(other, CHAN_AUTO, "weapons/ric2.wav", 1, ATTN_NORM);
			}
			else
			{
				sound(other, CHAN_AUTO, "weapons/ric3.wav", 1, ATTN_NORM);
			}
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

void() W_SetCurrentAmmo = 
{
	self.items = self.items - (self.items & (IT_NAILS | IT_ROCKETS | IT_DETONATORS | IT_MINES | IT_CELLS));
	if (self.weapon == IT_ROOBAR)
	{
		self.currentammo = self.ammo_roobar;
		self.items = self.items | IT_CELLS;
		if (self.classname == "player")
		{
			if (rally_type_index > 1)
			{
				self.veh_body.modelindex = self.basemodel + 1;
			}
		}
	}
	else
	{
		if (self.weapon == IT_LASER_GUN)
		{
			self.currentammo = self.ammo_roobar;
			self.items = self.items | IT_CELLS;
			if (self.classname == "player")
			{
				if (rally_type_index > 1)
				{
					self.veh_body.modelindex = self.basemodel + 2;
				}
			}
		}
		else
		{
			if (self.weapon == IT_SUPER_NAILGUN)
			{
				self.currentammo = self.ammo_nails;
				self.items = self.items | IT_NAILS;
				if (self.classname == "player")
				{
					if (rally_type_index > 1)
					{
						self.veh_body.modelindex = self.basemodel + 3;
					}
				}
			}
			else
			{
				if (self.weapon == IT_MINE_LAUNCHER)
				{
					self.currentammo = self.ammo_rockets;
					self.items = self.items | IT_ROCKETS;
					if (self.classname == "player")
					{
						if (rally_type_index > 1)
						{
							self.veh_body.modelindex = self.basemodel + 4;
						}
					}
				}
				else
				{
					if (self.weapon == IT_DETONATOR)
					{
						self.currentammo = self.ammo_rockets;
						self.items = self.items | IT_ROCKETS;
						if (self.classname == "player")
						{
							if (rally_type_index > 1)
							{
								self.veh_body.modelindex = self.basemodel + 5;
							}
						}
					}
					else
					{
						if (self.weapon == IT_ROCKET_LAUNCHER)
						{
							self.currentammo = self.ammo_rockets;
							self.items = self.items | IT_ROCKETS;
							if (self.classname == "player")
							{
								if (rally_type_index > 1)
								{
									self.veh_body.modelindex = self.basemodel + 6;
								}
							}
						}
						else
						{
							if (self.weapon == IT_NULL)
							{
								self.currentammo = 0;
								if (self.classname == "player")
								{
									if (rally_type_index > 1)
									{
										self.veh_body.modelindex = self.basemodel;
									}
								}
							}
							else
							{
								self.currentammo = 0;
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
	if (self.ammo_rockets >= 1 && (it & IT_ROCKET_LAUNCHER))
	{
		return IT_ROCKET_LAUNCHER;
	}
	else
	{
		if (self.ammo_roobar >= 1 && (it & IT_ROOBAR))
		{
			return IT_ROOBAR;
		}
		else
		{
			if (self.ammo_rockets >= 1 && (it & IT_MINE_LAUNCHER))
			{
				return IT_MINE_LAUNCHER;
			}
			else
			{
				if (self.ammo_nails >= 2 && (it & IT_SUPER_NAILGUN))
				{
					return IT_SUPER_NAILGUN;
				}
				else
				{
					if (self.ammo_rockets >= 1 && (it & IT_DETONATOR))
					{
						return IT_DETONATOR;
					}
					else
					{
						if (self.ammo_roobar >= 1 && (it & IT_LASER_GUN))
						{
							return IT_LASER_GUN;
						}
					}
				}
			}
		}
	}
	return IT_NULL;
};

float() W_CheckNoAmmo = 
{
	if (self.currentammo > 0)
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
	local vector gun_aim;
	CheckDriverReady();
	if (!(self.flags & QR_START_READY) && self.ignition_time > time - SNDLEN_IGNITION)
	{
		return;
	}
	if (rally_type_index < 2)
	{
		return;
	}
	if (rally_type_index == 2 && self.last_lap < 1)
	{
		centerprint(self, "NO WEAPONS DURING FIRST LAP!");
		return;
	}
	if (!W_CheckNoAmmo())
	{
		return;
	}
	if (self.weapon == IT_NULL)
	{
		return;
	}
	gun_aim = self.veh_body.angles;
	if (self.angles_x != 0)
	{
		gun_aim_x = -1 * gun_aim_x;
	}
	gun_aim_x = gun_aim_x - 2;
	gun_aim_z = 0;
	makevectors(gun_aim);
	if (self.weapon == IT_SUPER_NAILGUN)
	{
		player_nail1();
	}
	else
	{
		if (self.weapon == IT_MINE_LAUNCHER)
		{
			player_rocket1();
			W_FireMine();
			self.attack_finished = time + 1;
		}
		else
		{
			if (self.weapon == IT_DETONATOR)
			{
				player_rocket1();
				W_FireGrenade();
				self.attack_finished = time + 0.6;
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
					if (self.weapon == IT_LASER_GUN)
					{
						player_rocket1();
						W_FireLaser();
						self.attack_finished = time + 0.5;
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
	am = 0;
	if (rally_type_index < 2)
	{
		return;
	}
	if (self.impulse == 1)
	{
		fl = IT_NULL;
	}
	if (self.impulse == 2)
	{
		fl = IT_ROOBAR;
		if (self.ammo_roobar < 1)
		{
			am = 1;
		}
	}
	else
	{
		if (self.impulse == 3)
		{
			fl = IT_LASER_GUN;
			if (self.ammo_roobar < 1)
			{
				am = 1;
			}
		}
		else
		{
			if (self.impulse == 4)
			{
				fl = IT_SUPER_NAILGUN;
				if (self.ammo_nails < 1)
				{
					am = 1;
				}
			}
			else
			{
				if (self.impulse == 5)
				{
					fl = IT_DETONATOR;
					if (self.ammo_rockets < 1)
					{
						am = 1;
					}
				}
				else
				{
					if (self.impulse == 6)
					{
						fl = IT_MINE_LAUNCHER;
						if (self.ammo_rockets < 1)
						{
							am = 1;
						}
					}
					else
					{
						if (self.impulse == 7)
						{
							fl = IT_ROCKET_LAUNCHER;
							if (self.ammo_rockets < 1)
							{
								am = 1;
							}
						}
					}
				}
			}
		}
	}
	self.impulse = 0;
	if (!(self.items & fl) && !(fl == IT_NULL))
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

void() GiveDukesLaunchers = 
{
	local entity trav;
	trav = world;
	while ((trav = find(trav, classname, "rally_dude")) != world)
	{
		trav.ammo_rockets = 100;
	}
};

void() CheatCommand = 
{
	if (rally_type_index == 4)
	{
		sprint(self, "That wasn't very wise..\n");
		self.health = 1;
		GiveDukesLaunchers();
		return;
	}
	if (deathmatch || coop)
	{
		return;
	}
	if (rally_type_index <= 1)
	{
		return;
	}
	self.ammo_rockets = 100;
	self.ammo_nails = 200;
	self.ammo_rockets = 100;
	self.ammo_roobar = 100;
	self.items = self.items | IT_ROOBAR | IT_LASER_GUN | IT_SUPER_NAILGUN | IT_MINE_LAUNCHER | IT_DETONATOR | IT_ROCKET_LAUNCHER | IT_KEY1 | IT_KEY2;
	self.weapon = IT_ROCKET_LAUNCHER;
	self.impulse = 0;
	W_SetCurrentAmmo();
};

void() CycleWeaponCommand = 
{
	local float it;
	local float am;
	local float i;
	if (rally_type_index < 2)
	{
		return;
	}
	it = self.items;
	self.impulse = 0;
	i = 0;
	while (i < 10)
	{
		am = 0;
		if (self.weapon == IT_ROCKET_LAUNCHER)
		{
			self.weapon = IT_ROOBAR;
			if (self.ammo_roobar < 1)
			{
				am = 1;
			}
		}
		else
		{
			if (self.weapon == IT_ROOBAR)
			{
				self.weapon = IT_LASER_GUN;
				if (self.ammo_roobar < 1)
				{
					am = 1;
				}
			}
			else
			{
				if (self.weapon == IT_LASER_GUN)
				{
					self.weapon = IT_SUPER_NAILGUN;
					if (self.ammo_nails < 1)
					{
						am = 1;
					}
				}
				else
				{
					if (self.weapon == IT_SUPER_NAILGUN)
					{
						self.weapon = IT_MINE_LAUNCHER;
						if (self.ammo_rockets < 1)
						{
							am = 1;
						}
					}
					else
					{
						if (self.weapon == IT_MINE_LAUNCHER)
						{
							self.weapon = IT_DETONATOR;
							if (self.ammo_rockets < 1)
							{
								am = 1;
							}
						}
						else
						{
							if (self.weapon == IT_DETONATOR)
							{
								self.weapon = IT_ROCKET_LAUNCHER;
								if (self.ammo_rockets < 1)
								{
									am = 1;
								}
							}
						}
					}
				}
			}
		}
		if (self.items & self.weapon && am == 0)
		{
			W_SetCurrentAmmo();
			return;
		}
		i = i + 1;
	}
};

void() ServerflagsCommand = 
{
	serverflags = serverflags * 2 + 1;
};

void() QuadCheat = 
{
	if (deathmatch || coop)
	{
		return;
	}
	self.super_time = 1;
	self.super_damage_finished = time + 30;
	self.items = self.items | IT_QUAD;
	dprint("quad cheat\n");
};

void() ID = 
{
};

void(entity player_ent) Chase_cam_setweapon = 
{
	local entity e;
	e = self;
	self = player_ent;
	W_SetCurrentAmmo();
	self = e;
};

void(entity cam_owner) Start_chase_cam = 
{
	local entity chase_cam;
	chase_cam = spawn();
	chase_cam.owner = cam_owner;
	cam_owner.chasecam = chase_cam;
	chase_cam.owner.speed = chase_cam.owner.speed | CHSCAM_ON;
	chase_cam.solid = SOLID_NOT;
	chase_cam.movetype = MOVETYPE_NOCLIP;
	chase_cam.angles = chase_cam.owner.angles;
	setmodel(chase_cam, "models/null.mdl");
	setsize(chase_cam, '0 0 0', '0 0 0');
	setorigin(chase_cam, chase_cam.owner.origin);
	chase_cam.last_roll = chase_cam.origin;
	chase_cam.classname = "chase_cam";
	chase_cam.nextthink = time + 0.05;
	chase_cam.think = Keep_cam_chasing_owner;
	msg_entity = chase_cam.owner;
	WriteByte(MSG_ONE, SVC_SETVIEWPORT);
	WriteEntity(MSG_ONE, chase_cam);
	Chase_cam_setweapon(cam_owner);
	chase_cam.ammo_shells = chasecam_dist;
	chase_cam.ammo_cells = 0;
};

void() Reable_chase_cam = 
{
	self.nextthink = time + 0.1;
	if (self.owner.health <= 0)
	{
		remove(self);
		return;
	}
	if (self.owner.waterlevel)
	{
		return;
	}
	Start_chase_cam(self.owner);
	remove(self);
};

void(float opt) Remove_chase_cam = 
{
	if (self.owner.speed & CHSCAM_ON)
	{
		self.owner.speed = self.owner.speed - CHSCAM_ON;
	}
	setmodel(self, "");
	self.velocity = '0 0 0';
	msg_entity = self.owner;
	Chase_cam_setweapon(self.owner);
	if (!opt)
	{
		self.nextthink = time + 0.1;
		self.think = Reable_chase_cam;
	}
	else
	{
		remove(self);
	}
};

void() Toggle_chase_cam = 
{
	if (self.speed & CHSCAM_FAR)
	{
		self.speed = self.speed - CHSCAM_FAR;
	}
	else
	{
		self.speed = self.speed + CHSCAM_FAR;
	}
	if (rally_type_index < 3)
	{
		self.chasecam_zoom = DEFAULT_CHASECAM_ZOOM;
	}
	else
	{
		self.chasecam_zoom = DEFAULT_CHASECAM_ZOOM / 2;
	}
};

void() Toggle_chase_type = 
{
	if (self.speed & CHSCAM_ALT)
	{
		self.speed = self.speed - CHSCAM_ALT;
		sprint(self, "View tracking: normal\n");
	}
	else
	{
		self.speed = self.speed | CHSCAM_ALT;
		sprint(self, "View tracking: strafeing\n");
	}
};

void() SDR_SightThink = 
{
	local vector org;
	makevectors(self.owner.veh_body.angles);
	org = self.owner.veh_body.origin + v_forward * 32;
	traceline(org, org + v_forward * 2048, 0, self);
	if (trace_fraction == 1)
	{
		setmodel(self, "");
		return;
	}
	if (trace_ent.takedamage)
	{
		setmodel(self, "progs/cross2.mdl");
	}
	else
	{
		setmodel(self, "progs/cross1.mdl");
	}
	self.angles = vectoangles(v_forward);
	setorigin(self, trace_endpos);
	self.nextthink = time + 0.05;
};

void() SDR_SightMake = 
{
	local entity cross;
	self.sight_out = 1;
	cross = spawn();
	cross.owner = self;
	cross.movetype = MOVETYPE_NOCLIP;
	cross.solid = SOLID_NOT;
	setmodel(cross, "progs/cross1.mdl");
	cross.classname = "laser_sight";
	setorigin(cross, self.origin);
	cross.think = SDR_SightThink;
	cross.nextthink = time + 0.05;
};

void() LaserTargeterTrack = 
{
	local vector dir;
	local vector src;
	if (!(self.owner.speed & LASERTARG_ON))
	{
		remove(self);
		return;
	}
	makevectors(self.owner.veh_body.angles);
	src = self.owner.origin + v_forward * 32;
	dir = v_forward;
	traceline(src, src + dir * 2048, 0, self.owner);
	src = 0.1 * src + 0.9 * trace_endpos;
	setorigin(self, src);
	self.nextthink = time + 0.1;
};

void(entity targ_owner) LaserTargeterToggle = 
{
	local entity e;
	if (targ_owner.speed & LASERTARG_ON)
	{
		targ_owner.speed = targ_owner.speed - LASERTARG_ON;
	}
	else
	{
		if (rally_type_index > 1)
		{
			targ_owner.speed = targ_owner.speed | LASERTARG_ON;
			e = spawn();
			e.owner = targ_owner;
			e.movetype = MOVETYPE_NONE;
			e.solid = SOLID_NOT;
			setmodel(e, "progs/s_bubble.spr");
			setsize(e, VEC_ORIGIN, VEC_ORIGIN);
			setorigin(e, e.owner.origin);
			e.nextthink = time + 0.1;
			e.think = LaserTargeterTrack;
		}
	}
};

void() Chase_cam_lvlstart_think = 
{
	local string s;
	if (self.owner.speed & CHSCAM_ON)
	{
		Start_chase_cam(self.owner);
	}
	if (self.owner.speed & LASERTARG_ON)
	{
		self.owner.speed = self.owner.speed - LASERTARG_ON;
		LaserTargeterToggle(self.owner);
	}
	remove(self);
};

void() Chase_cam_level_start = 
{
	local entity e;
	e = spawn();
	e.owner = self;
	e.movetype = MOVETYPE_NONE;
	e.solid = SOLID_NOT;
	setmodel(e, "");
	setsize(e, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(e, e.owner.origin);
	e.nextthink = time + 0.2;
	e.think = Chase_cam_lvlstart_think;
};

void(float imp) Choose_multiskin = 
{
	if (imp == 200)
	{
		self.skin = self.skin + 1;
		if (self.skin == 19)
		{
			self.skin = 0;
		}
	}
	else
	{
		self.skin = self.skin - 1;
		if (self.skin == -1)
		{
			self.skin = 18;
		}
	}
	if (self.skin == 0)
	{
		centerprint(self, "SKIN: the Good Guy Himself (1)");
	}
	else
	{
		if (self.skin == 1)
		{
			centerprint(self, "SKIN: Duke Nukem 3d (2)");
		}
		else
		{
			if (self.skin == 2)
			{
				centerprint(self, "SKIN: Mr. Toad (3)");
			}
			else
			{
				if (self.skin == 3)
				{
					centerprint(self, "SKIN: the Stormtrooper (4)");
				}
				else
				{
					if (self.skin == 4)
					{
						centerprint(self, "SKIN: Max (5)");
					}
					else
					{
						if (self.skin == 5)
						{
							centerprint(self, "SKIN: the Terminator (6)");
						}
						else
						{
							if (self.skin == 6)
							{
								centerprint(self, "SKIN: Judge Dredd (7)");
							}
							else
							{
								if (self.skin == 7)
								{
									centerprint(self, "SKIN: Camouflaged soldier (8)");
								}
								else
								{
									if (self.skin == 8)
									{
										centerprint(self, "SKIN: Captain Picard (9)");
									}
									else
									{
										if (self.skin == 9)
										{
											centerprint(self, "SKIN: the Wizzard (10)");
										}
										else
										{
											if (self.skin == 10)
											{
												centerprint(self, "SKIN: the Predator (11)");
											}
											else
											{
												if (self.skin == 11)
												{
													centerprint(self, "SKIN: Skeleton (12)");
												}
												else
												{
													if (self.skin == 12)
													{
														centerprint(self, "SKIN: Wan-Fu (13)");
													}
													else
													{
														if (self.skin == 13)
														{
															centerprint(self, "SKIN: Henry Rollins (14)");
														}
														else
														{
															if (self.skin == 14)
															{
																centerprint(self, "SKIN: He-Man (15)");
															}
															else
															{
																if (self.skin == 15)
																{
																	centerprint(self, "SKIN: Boba (16)");
																}
																else
																{
																	if (self.skin == 16)
																	{
																		centerprint(self, "SKIN: Superman (17)");
																	}
																	else
																	{
																		if (self.skin == 17)
																		{
																			centerprint(self, "SKIN: NYPD Cop (18)");
																		}
																		else
																		{
																			if (self.skin == 18)
																			{
																				centerprint(self, "SKIN: Red/Yellow women dude (19)");
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
					}
				}
			}
		}
	}
};

void() ImpulseCommands = 
{
	local string stemp;
	local entity e_credits;
	local entity dude;
	local entity oself;
	if (self.impulse == 0)
	{
		return;
	}
	if (self.racing_flags & QR_OBSERVER)
	{
		if (self.impulse == 150)
		{
			SetObserverSpot(self, -1);
			self.impulse = 0;
		}
		else
		{
			if (self.impulse == 151)
			{
				SetObserverSpot(self, 1);
				self.impulse = 0;
			}
		}
		return;
	}
	if (SetInterRaceTime)
	{
		inter_race_time = self.impulse;
		bprint("Inter-Race time set at: ");
		stemp = ftos(inter_race_time);
		bprint(stemp);
		bprint("\n");
		SetInterRaceTime = 0;
	}
	if (self.impulse >= 1 && self.impulse <= 8)
	{
		W_ChangeWeapon();
	}
	else
	{
		if (self.impulse == 9)
		{
			CheatCommand();
		}
		else
		{
			if (self.impulse == 10)
			{
				CycleWeaponCommand();
			}
			else
			{
				if (self.impulse == 11)
				{
					ServerflagsCommand();
				}
				else
				{
					if (self.impulse == 20)
					{
						if (self.car_index < 3)
						{
							sound(self, CHAN_AUTO, "rally/meepmeep.wav", 1, ATTN_STATIC);
						}
						else
						{
							sound(self, CHAN_AUTO, "rally/nexus/horn.wav", 1, ATTN_STATIC);
						}
					}
					else
					{
						if (self.impulse == 21)
						{
							if (find(world, classname, "credits"))
							{
								return;
							}
							e_credits = spawn();
							e_credits.classname = "credits";
							e_credits.think = StartDemoCredits;
							e_credits.nextthink = time + 0.5;
							e_credits.ammo_shells = 1;
							e_credits.ammo_cells = 1;
						}
						else
						{
							if (self.impulse == 30)
							{
								Toggle_chase_cam();
							}
							else
							{
								if (self.impulse == 31)
								{
									self.chasecam_zoom = self.chasecam_zoom + 10;
									stemp = ftos(self.chasecam_zoom);
									sprint(self, "Zoom set at: ");
									sprint(self, stemp);
									sprint(self, "\n");
								}
								else
								{
									if (self.impulse == 32)
									{
										self.chasecam_zoom = self.chasecam_zoom - 10;
										if (self.chasecam_zoom < 0)
										{
											self.chasecam_zoom = 0;
										}
										stemp = ftos(self.chasecam_zoom);
										sprint(self, "Zoom set at: ");
										sprint(self, stemp);
										sprint(self, "\n");
									}
									else
									{
										if (self.impulse == 40)
										{
											if (self.cam == CAM_INCAR)
											{
												stuffcmd(self, "cl_anglespeedkey 1.5\n");
											}
											if (self.cam == CAM_CHASEFAR)
											{
												stuffcmd(self, "fov 90\n");
												msg_entity = self;
												WriteByte(MSG_ONE, SVC_SETVIEWANGLES);
												WriteAngle(MSG_ONE, 20);
												WriteAngle(MSG_ONE, self.v_angle_y);
												WriteAngle(MSG_ONE, self.v_angle_z);
												self.cam = CAM_CHASECLOSE;
											}
											else
											{
												stuffcmd(self, "fov 110\n");
												msg_entity = self;
												WriteByte(MSG_ONE, SVC_SETVIEWANGLES);
												WriteAngle(MSG_ONE, 35);
												WriteAngle(MSG_ONE, self.v_angle_y);
												WriteAngle(MSG_ONE, self.v_angle_z);
												self.cam = CAM_CHASEFAR;
											}
										}
										else
										{
											if (self.impulse == 41)
											{
												stuffcmd(self, "cl_anglespeedkey 1.5\n");
												stuffcmd(self, "+mlook\n");
												stuffcmd(self, "-speed\n");
												stuffcmd(self, "fov 90\n");
												msg_entity = self;
												WriteByte(MSG_ONE, SVC_SETVIEWANGLES);
												WriteAngle(MSG_ONE, 20);
												WriteAngle(MSG_ONE, self.angles_y);
												WriteAngle(MSG_ONE, self.angles_z);
												self.cam = CAM_CHASECLOSE;
												CallClientPrefs(self);
											}
											else
											{
												if (self.impulse == 42)
												{
													stuffcmd(self, "cl_anglespeedkey 1.5\n");
													stuffcmd(self, "-speed\n");
													stuffcmd(self, "+mlook\n");
													stuffcmd(self, "fov 110\n");
													msg_entity = self;
													WriteByte(MSG_ONE, SVC_SETVIEWANGLES);
													WriteAngle(MSG_ONE, 35);
													WriteAngle(MSG_ONE, self.angles_y);
													WriteAngle(MSG_ONE, self.angles_z);
													self.cam = CAM_CHASEFAR;
													CallClientPrefs(self);
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
	if (self.impulse == 43 && !deathmatch)
	{
		stuffcmd(self, "fov 90\n");
		stuffcmd(self, "cl_anglespeedkey 6\n");
		stuffcmd(self, "+speed\n");
		centerprint(self, "In-Car view selected, use keys to steer\n\nPress C to change back to chasecam");
		self.cam = CAM_INCAR;
	}
	else
	{
		if (self.impulse == 50)
		{
			if (!deathmatch)
			{
				ToggleHeadlights();
			}
		}
		else
		{
			if (self.impulse == 55)
			{
				self.misc_flags = self.misc_flags | MISC_HORN_ON;
			}
			else
			{
				if (self.impulse == 56)
				{
					self.misc_flags = self.misc_flags - (self.misc_flags & MISC_HORN_ON);
				}
				else
				{
					if (self.impulse == 60)
					{
						SetInterRaceTime = 1;
					}
					else
					{
						if (self.impulse == 80)
						{
							self.accelerating = 1;
							self.reversing = 0;
							self.reversekey = 0;
						}
						else
						{
							if (self.impulse == 81)
							{
								self.accelerating = 0;
							}
							else
							{
								if (self.impulse == 85)
								{
									self.accelerating = 0;
									self.reversekey = 1;
									self.reversing = 1;
								}
								else
								{
									if (self.impulse == 86)
									{
										self.reversekey = 0;
									}
									else
									{
										if (self.impulse == 90)
										{
											self.zoomin = 1;
											self.zoomout = 0;
										}
										else
										{
											if (self.impulse == 91)
											{
												self.zoomin = 0;
											}
											else
											{
												if (self.impulse == 92)
												{
													self.zoomin = 0;
													self.zoomout = 1;
												}
												else
												{
													if (self.impulse == 93)
													{
														self.zoomout = 0;
													}
													else
													{
														if (self.impulse == 100)
														{
															self.start_challenge = 1;
															challenge = 1;
														}
														else
														{
															if (self.impulse == 101)
															{
																self.start_challenge = 2;
																challenge = 2;
															}
															else
															{
																if (self.impulse >= 120 && self.impulse <= 130)
																{
																	if (self.impulse == 130)
																	{
																		self.tracking_speed = 20;
																	}
																	else
																	{
																		self.tracking_speed = self.impulse - 120;
																	}
																	CallClientPrefs(self);
																}
																else
																{
																	if (self.impulse == 200)
																	{
																		self.veh_body.skin = self.veh_body.skin + 1;
																		if (self.veh_body.skin > self.num_skins)
																		{
																			self.veh_body.skin = 1;
																		}
																	}
																	else
																	{
																		if (self.impulse == 201 && !(self.racing_flags & QR_START_READY))
																		{
																			if (self.num_skins > 1 && self.skin == 0)
																			{
																				self.skin = 1;
																			}
																			else
																			{
																				self.car_index = self.car_index + 1;
																				self.skin = 0;
																				if (self.car_index > NUM_CARS)
																				{
																					self.car_index = 2;
																				}
																			}
																			SetCarDetails();
																		}
																		else
																		{
																			if (self.impulse == 210)
																			{
																				self.car_index = 2;
																				self.skin = 0;
																				SetCarDetails();
																				CallClientPrefs(self);
																			}
																			else
																			{
																				if (self.impulse == 211)
																				{
																					self.car_index = 2;
																					self.skin = 1;
																					SetCarDetails();
																					CallClientPrefs(self);
																				}
																				else
																				{
																					if (self.impulse == 212)
																					{
																						self.car_index = 3;
																						self.skin = 0;
																						SetCarDetails();
																						CallClientPrefs(self);
																					}
																					else
																					{
																						if (self.impulse == 213)
																						{
																							self.car_index = 4;
																							self.skin = 0;
																							SetCarDetails();
																							CallClientPrefs(self);
																						}
																						else
																						{
																							if (self.impulse == 214)
																							{
																								self.car_index = 4;
																								self.skin = 1;
																								SetCarDetails();
																								CallClientPrefs(self);
																							}
																							else
																							{
																								if (self.impulse == 215)
																								{
																									self.car_index = 5;
																									self.skin = 0;
																									SetCarDetails();
																									CallClientPrefs(self);
																								}
																								else
																								{
																									if (self.impulse == 216)
																									{
																										self.car_index = 5;
																										self.skin = 1;
																										SetCarDetails();
																										CallClientPrefs(self);
																									}
																									else
																									{
																										if (self.impulse == 220)
																										{
																											stuffcmd(self, "r_drawviewmodel 0\n");
																											CallClientPrefs(self);
																										}
																										else
																										{
																											if (self.impulse == 221)
																											{
																												stuffcmd(self, "r_drawviewmodel 1\n");
																												self.weaponmodel = "models/wheel.mdl";
																												CallClientPrefs(self);
																											}
																											else
																											{
																												if (self.impulse == 222)
																												{
																													stuffcmd(self, "r_drawviewmodel 1\n");
																													self.weaponmodel = "models/wheelsm.mdl";
																													CallClientPrefs(self);
																												}
																												else
																												{
																													if (self.impulse >= 230 && self.impulse <= 240)
																													{
																														self.chasecam_zoom = (self.impulse - 230) * 10;
																														CallClientPrefs(self);
																													}
																													else
																													{
																														if (self.impulse == 254)
																														{
																															dude = spawn();
																															dude.classname = "rally_spawn_dude";
																															dude.angles = self.angles;
																															setorigin(dude, self.origin + self.veh_dir * 64 + '0 0 32');
																															oself = self;
																															self = dude;
																															rally_spawn_dude();
																															self = oself;
																															remove(dude);
																														}
																														else
																														{
																															if (self.impulse == 255)
																															{
																																QuadCheat();
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
			}
		}
	}
	self.impulse = 0;
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
			self.super_sound = time + 1;
			sound(self, CHAN_BODY, "items/damage3.wav", 1, ATTN_NORM);
		}
	}
	return;
};

void() oldchasecam = 
{
	local vector spot2;
	local vector dir;
	local vector cam_angles;
	local float dist;
	local float cap;
	local float ftemp;
	local float vel_speed;
	local float dist2;
	local float f_f;
	local float f_r;
	if (self.owner.cam == CAM_CHASEFAR)
	{
		chasecam_dist = CHASECAM_FAR_x + self.owner.chasecam_zoom;
		chasecam_zofs = CHASECAM_FAR_z;
	}
	else
	{
		chasecam_dist = CHASECAM_CLOSE_x + self.owner.chasecam_zoom;
		chasecam_zofs = CHASECAM_CLOSE_z;
	}
	dir_y = self.owner.v_angle_y;
	makevectors(dir);
	f_f = vlen(v_forward * cvar("sv_maxspeed") - self.owner.velocity) / 8 + 64;
	f_r = vlen(v_right * cvar("sv_maxspeed") - self.owner.velocity) / 8;
	dir = v_forward;
	if (self.owner.speed & CHSCAM_ALT)
	{
		if (f_f < 160 || self.owner.v_angle_x < -45)
		{
			self.ammo_cells = 0;
		}
		else
		{
			if (f_r < 80)
			{
				self.ammo_cells = 1;
			}
			else
			{
				if (f_r > 560)
				{
					self.ammo_cells = 2;
				}
			}
		}
	}
	else
	{
		self.ammo_cells = 0;
	}
	makevectors(self.owner.v_angle);
	spot2 = self.owner.origin - v_forward * self.ammo_shells;
	if (!(self.ammo_cells))
	{
		if (self.owner.v_angle_x > 16)
		{
			spot2 = spot2 + dir * (self.owner.v_angle_x - 16);
			cap = chasecam_zofs - (self.owner.v_angle_x - 16) * 0.2;
			if (cap < 0)
			{
				cap = 0;
			}
			spot2_z = spot2_z + cap;
		}
		else
		{
			spot2_z = spot2_z + chasecam_zofs;
		}
	}
	else
	{
		if (self.ammo_cells == 1)
		{
			spot2 = spot2 - v_right * chasecam_zofs;
		}
		else
		{
			spot2 = spot2 + v_right * chasecam_zofs;
		}
	}
	traceline(self.owner.origin, spot2, 1, self.owner);
	spot2 = trace_endpos + v_forward * 2;
	self.ammo_shells = 10 + vlen(trace_endpos - self.owner.origin);
	traceline(spot2, spot2 + '0 0 32', 1, self.owner);
	if (trace_fraction < 1)
	{
		dir = trace_endpos - '0 0 32';
		traceline(spot2, spot2 - '0 0 32', 1, self.owner);
		if (trace_fraction == 1)
		{
			spot2 = dir;
		}
	}
	makevectors(self.owner.veh_body.angles - self.owner.body_roll);
	if (v_forward_z > 0)
	{
		spot2_z = spot2_z + v_forward_z * chasecam_dist * 0.5;
	}
	if (self.owner.chasecam_zoom <= 20 && v_forward_z < 0)
	{
		spot2_z = spot2_z - v_forward_z * 32;
	}
	dir = normalize(spot2 - self.origin);
	dist = vlen(spot2 - self.origin);
	self.roll_velocity = dir * dist * 10;
	if (vlen(self.roll_velocity * frametime) < dist)
	{
		self.last_roll = self.last_roll + self.roll_velocity * frametime;
	}
	else
	{
		self.last_roll = spot2;
	}
	self.last_roll_z = spot2_z;
	if (vlen(self.owner.origin - self.last_roll) > 256)
	{
		self.last_roll = self.owner.origin + normalize(self.last_roll - self.owner.origin) * 256;
	}
	dist2 = self.owner.chasecam_zoom;
	spot2 = self.owner.origin + normalize(self.last_roll - self.owner.origin) * dist2;
	ftemp = spot2_z;
	vel_speed = vlen(self.owner.velocity);
	if (spot2_z > self.origin_z)
	{
		spot2_z = self.origin_z + (6400 * (vel_speed / MAX_SPEED) + 20) * frametime;
		if (spot2_z > ftemp)
		{
			spot2_z = ftemp;
		}
		if (spot2_z - ftemp < -32)
		{
			spot2_z = ftemp - 32;
		}
	}
	else
	{
		spot2_z = self.origin_z - (6400 * (vel_speed / MAX_SPEED) + 20) * frametime;
		if (spot2_z < ftemp)
		{
			spot2_z = ftemp;
		}
		if (spot2_z - ftemp > 32)
		{
			spot2_z = ftemp + 32;
		}
	}
	setorigin(self, spot2);
	self.ammo_shells = self.ammo_shells + 4;
	if (self.ammo_shells > chasecam_dist)
	{
		self.ammo_shells = chasecam_dist;
	}
	if (self.oldorigin == self.origin)
	{
		if (dist > 30)
		{
			self.ammo_nails = self.ammo_nails + 1;
		}
	}
	if (self.ammo_nails > 3)
	{
		Start_chase_cam(self.owner);
		remove(self);
		return;
	}
	self.oldorigin = self.origin;
};

void() Keep_cam_chasing_owner = 
{
	local vector spot;
	local vector view_dir;
	local vector ideal_vec;
	local vector veh_vel;
	local vector cam_angles;
	local float veh_speed;
	local float ideal_dist;
	local float track_speed;
	if (self.owner.cam != CAM_INCAR && self.owner.cam != CAM_TEST)
	{
		setorigin(self, self.origin + self.owner.lastmove);
		if (self.owner.cam == CAM_CHASEFAR)
		{
			chasecam_dist = CHASECAM_FAR_x + self.owner.chasecam_zoom;
			chasecam_zofs = CHASECAM_FAR_z;
		}
		else
		{
			chasecam_dist = CHASECAM_CLOSE_x + self.owner.chasecam_zoom;
			chasecam_zofs = CHASECAM_CLOSE_z;
			track_speed = self.owner.tracking_speed;
		}
		if (chasecam_dist < 5)
		{
			chasecam_dist = 5;
		}
		makevectors(self.owner.v_angle);
		view_dir = v_forward;
		veh_speed = vlen(self.owner.velocity);
		if (self.owner.velocity != '0 0 0')
		{
			veh_vel = normalize(self.owner.velocity);
		}
		else
		{
			makevectors(self.owner.veh_body.angles);
			veh_vel = v_forward;
		}
		if (veh_speed > MAX_SPEED / 3 && self.owner.cam == CAM_CHASECLOSE && !(self.racing_flags & QR_RESPAWN_FLAG))
		{
			spot = self.owner.origin - (chasecam_dist + veh_speed / MAX_SPEED * (self.owner.chasecam_zoom * 0.5)) * veh_vel + '0 0 1' * chasecam_zofs;
			spot_z = self.origin_z;
			makevectors(self.owner.veh_body.angles - self.owner.body_roll);
			v_forward_z = -1 * v_forward_z;
			if (v_forward_z > 0)
			{
				spot_z = spot_z + v_forward_z * chasecam_dist * 0.5;
			}
			ideal_vec = normalize(spot - self.origin) * 120 * frametime;
			ideal_dist = vlen(spot - self.origin);
			if (ideal_dist > vlen(ideal_vec))
			{
				setorigin(self, self.origin + ideal_vec);
			}
			else
			{
				setorigin(self, spot);
			}
			ideal_dist = vlen(self.origin - self.owner.origin);
		}
		else
		{
			ideal_dist = chasecam_dist;
		}
		spot = self.owner.origin - ideal_dist * view_dir + '0 0 1' * chasecam_zofs;
		spot = self.owner.origin + normalize(spot - self.owner.origin) * ideal_dist;
		if (self.owner.cam == CAM_CHASECLOSE && !(self.racing_flags & QR_RESPAWN_FLAG))
		{
			ideal_dist = vlen(spot - self.origin);
			ideal_vec = normalize(spot - self.origin) * (self.owner.chasecam_zoom + track_speed * 20 + ideal_dist * 2.5 * (ideal_dist > 16)) * frametime;
			if (ideal_dist > vlen(ideal_vec))
			{
				setorigin(self, self.origin + ideal_vec);
			}
			else
			{
				setorigin(self, spot);
			}
		}
		else
		{
			setorigin(self, spot);
			self.racing_flags = self.racing_flags - (self.racing_flags & QR_RESPAWN_FLAG);
		}
		self.velocity = '0 0 0';
		traceline(self.origin, self.owner.origin, 0, self.owner);
		if (trace_fraction < 1)
		{
			ideal_vec = normalize(self.origin - self.owner.origin);
			setorigin(self, trace_endpos - ideal_vec * 4);
		}
		traceline(self.owner.origin, self.origin, 0, self.owner);
		if (trace_fraction < 1)
		{
			ideal_vec = normalize(self.origin - self.owner.origin);
			setorigin(self, trace_endpos - ideal_vec * 4);
		}
	}
	else
	{
		if (self.owner.cam == CAM_TEST)
		{
			setorigin(self, self.origin + self.owner.lastmove);
			makevectors(self.owner.veh_body.angles - self.owner.body_roll);
			spot = self.owner.origin - v_forward * 48 + v_up * 32;
			ideal_vec = normalize(spot - self.origin) * 40 * frametime;
			ideal_dist = vlen(spot - self.origin);
			if (ideal_dist > vlen(ideal_vec))
			{
				setorigin(self, self.origin + ideal_vec);
			}
			else
			{
				setorigin(self, spot);
			}
			cam_angles = normalize(self.owner.origin - self.origin);
			cam_angles = vectoangles(cam_angles);
			cam_angles_x = -1 * cam_angles_x;
			if (cam_angles_x > 180)
			{
				cam_angles_x = cam_angles_x - 360;
			}
			else
			{
				if (cam_angles_x < -180)
				{
					cam_angles_x = cam_angles_x + 360;
				}
			}
			msg_entity = self.owner;
			WriteByte(MSG_ONE, SVC_SETVIEWANGLES);
			WriteAngle(MSG_ONE, cam_angles_x);
			WriteAngle(MSG_ONE, cam_angles_y);
			WriteAngle(MSG_ONE, cam_angles_z);
			self.owner.last_heading = cam_angles_y;
		}
		else
		{
			self = self.owner;
			SetVehPosition(self.veh_body, self.chasecam, 0, -2, 7);
			self = self.chasecam;
			cam_angles = self.owner.veh_body.angles;
			cam_angles_x = -1 * cam_angles_x;
			cam_angles_x = cam_angles_x + 15;
			if (cam_angles_x > 180)
			{
				cam_angles_x = cam_angles_x - 360;
			}
			else
			{
				if (cam_angles_x < -180)
				{
					cam_angles_x = cam_angles_x + 360;
				}
			}
			msg_entity = self.owner;
			WriteByte(MSG_ONE, SVC_SETVIEWANGLES);
			WriteAngle(MSG_ONE, cam_angles_x);
			WriteAngle(MSG_ONE, cam_angles_y);
			WriteAngle(MSG_ONE, cam_angles_z);
			self.owner.fixangle = 1;
		}
	}
};


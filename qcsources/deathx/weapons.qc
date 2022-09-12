void(entity targ) range = 
{
	local vector spot1;
	local vector spot2;
	local float r;
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;
	r = vlen(spot1 - spot2);
	if (r < 120)
	{
		return RANGE_MELEE;
	}
	if (r < 500)
	{
		return RANGE_NEAR;
	}
	if (r < 1000)
	{
		return RANGE_MID;
	}
	return RANGE_FAR;
};

float(entity targ) visible = 
{
	local vector spot1;
	local vector spot2;
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;
	traceline(spot1, spot2, 1, self);
	if (trace_inopen && trace_inwater)
	{
		return 0;
	}
	if (trace_fraction == 1)
	{
		return 1;
	}
	return 0;
};

float(entity targ) infront = 
{
	local vector vec;
	local float dot;
	makevectors(self.angles);
	vec = normalize(targ.origin - self.origin);
	dot = vec * v_forward;
	if (dot > 0.010000)
	{
		return 1;
	}
	return 0;
};

void() W_Precache = 
{
	precache_model("progs/grenade1.mdl");
	precache_model("progs/g_bfg.mdl");
	precache_model("progs/g_light.mdl");
	precache_model("progs/g_sniper.mdl");
	precache_model("progs/g_rock2.mdl");
	precache_model("progs/g_nail.mdl");
	precache_model("progs/g_rock.mdl");
	precache_model("progs/g_nail2.mdl");
	precache_model("progs/g_shot.mdl");
	precache_model("progs/g_plasma.mdl");
	precache_model("progs/missile1.mdl");
	precache_model("progs/case.mdl");
	precache_model("progs/shelcase.mdl");
	precache_sound("weapons/shellhit.wav");
	precache_sound("weapons/casehit.wav");
	precache_model("progs/undead.mdl");
	precache_model("progs/h_undead.mdl");
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
	precache_sound("weapons/null.wav");
	precache_sound("items/inv1.wav");
	precache_sound("items/inv2.wav");
	precache_sound("items/inv3.wav");
	precache_sound("weapons/ghfire.wav");
	precache_sound("weapons/agfire.wav");
	precache_sound("weapons/agfail.wav");
	precache_sound("weapons/agwater.wav");
	precache_sound("weapons/agwfail.wav");
	precache_sound("blob/land1.wav");
	precache_sound("weapons/chain1.wav");
	precache_sound("weapons/chain2.wav");
	precache_sound("weapons/chain3.wav");
	precache_sound("weapons/bounce2.wav");
	precache_model("progs/rune1.mdl");
	precache_model("progs/rune2.mdl");
	precache_model("progs/rune3.mdl");
	precache_model("progs/rune4.mdl");
	precache_model("progs/rune5.mdl");
	precache_model("progs/bit.mdl");
	precache_model("progs/star.mdl");
	precache_model("progs/v_sniper.mdl");
	precache_model("progs/v_rockx.mdl");
	precache_model("progs/v_rockx2.mdl");
	precache_model("progs/v_bfg.mdl");
	precache_model("progs/v_4bshot.mdl");
	Plasma_PreCache();
	BFG_PreCache();
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
		SpawnBlood(org, '0 0 0', 30);
		T_Damage(trace_ent, self, self, 30);
	}
	else
	{
		if (!(self.player_flag & ITEM_RUNE5_FLAG))
		{
			sound(self, CHAN_WEAPON, "player/axhit2.wav", 1, ATTN_NORM);
		}
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
	shots = 0;
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

void() rebound = 
{
	self.velocity = normalize(self.velocity) * 2300;
	self.movetype = MOVETYPE_FLYMISSILE;
	self.solid = SOLID_TRIGGER;
	self.angles = vectoangles(self.velocity);
	self.think = SUB_Remove;
	self.nextthink = self.ltime;
	self.owner = world;
};

void() Bounce = 
{
	if (other.health)
	{
		self.solid = SOLID_TRIGGER;
		T_Damage(other, self, self.own, 160);
	}
	else
	{
		WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte(MSG_BROADCAST, TE_SUPERSPIKE);
		WriteCoord(MSG_BROADCAST, self.origin_x);
		WriteCoord(MSG_BROADCAST, self.origin_y);
		WriteCoord(MSG_BROADCAST, self.origin_z);
	}
	if (self.cnt > 6)
	{
		remove(self);
		return;
	}
	self.movetype = MOVETYPE_BOUNCE;
	self.solid = SOLID_TRIGGER;
	self.think = rebound;
	self.ltime = self.nextthink;
	self.nextthink = time + 0.05;
	self.cnt = self.cnt + 1;
	return;
};

void(vector dir) W_FireSnipe = 
{
	local entity sp00ge;
	sp00ge = spawn();
	sp00ge.owner = self;
	sp00ge.own = self;
	sp00ge.classname = "sniper_bullet";
	sp00ge.velocity = dir * 2300;
	sp00ge.avelocity = '0 0 0';
	sp00ge.movetype = MOVETYPE_FLYMISSILE;
	sp00ge.solid = SOLID_TRIGGER;
	sp00ge.touch = Bounce;
	sp00ge.angles = vectoangles(sp00ge.velocity);
	sp00ge.cnt = 0;
	sp00ge.nextthink = time + 3 + random() * 20;
	sp00ge.think = SUB_Remove;
	setmodel(sp00ge, "progs/spike.mdl");
	setsize(sp00ge, '0 0 0', '0 0 0');
	setorigin(sp00ge, self.origin);
};

void() W_FireShotgun = 
{
	local vector dir;
	if (!(self.player_flag & ITEM_RUNE5_FLAG))
	{
		sound(self, CHAN_WEAPON, "weapons/guncock.wav", 1, ATTN_NORM);
	}
	self.punchangle_x = -2;
	self.currentammo = self.ammo_shells = self.ammo_shells - 1;
	dir = aim(self, 10000);
	if (servervars & SV_SHELLEJECT)
	{
		eject_shell(self.origin + '0 0 16' + v_forward * 3, dir, 400, '0.3 0.3 0.3');
	}
	if (self.weapon == IT_EXTRA_WEAPON && self.weapon2 == WE_SNIPER_RIFLE)
	{
		W_FireSnipe(dir);
	}
	else
	{
		FireBullets(4, dir, '0.040000 0.030000 0');
	}
};

void() W_FireSuperShotgun = 
{
	local vector dir;
	if (self.currentammo < 2)
	{
		self.weapon = IT_SHOTGUN;
		W_SetCurrentAmmo();
		W_FireShotgun();
		return;
	}
	if (self.currentammo < 4 && self.quad_shot == 2)
	{
		self.quad_shot = 1;
		W_SetCurrentAmmo();
	}
	if (!(self.player_flag & ITEM_RUNE5_FLAG))
	{
		sound(self, CHAN_WEAPON, "weapons/shotgn2.wav", 1, ATTN_NORM);
	}
	self.punchangle_x = -4;
	self.currentammo = self.ammo_shells = self.ammo_shells - 2;
	if (self.quad_shot == 2)
	{
		self.punchangle_x = -12;
		self.currentammo = self.ammo_shells = self.ammo_shells - 2;
	}
	dir = aim(self, 100000);
	if (servervars & SV_SHELLEJECT)
	{
		eject_shell(self.origin + '0 4 16' + v_forward * 6, dir, 400, '0.3 0.3 0.3');
		eject_shell(self.origin + '0 -4 16' + v_forward * 6, dir, 400, '0.3 0.3 0.3');
		if (self.quad_shot == 2)
		{
			eject_shell(self.origin + '0 4 16' + v_forward * 6, dir, 400, '0.3 0.3 0.3');
			eject_shell(self.origin + '0 -4 16' + v_forward * 6, dir, 400, '0.3 0.3 0.3');
		}
	}
	if (self.quad_shot == 2)
	{
		FireBullets(32, dir, '0.2 0.15 0');
	}
	else
	{
		FireBullets(16, dir, '0.13 0.09 0');
	}
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

entity() HomeGetTarget = 
{
	local entity head;
	local entity selected;
	local float dist;
	local float temp;
	dist = 10000;
	selected = world;
	head = findradius(self.origin, dist);
	while (head)
	{
		if (head.health > 1 && head != self && head != self.owner && !(teamplay == 1 && head.team > 0 && head.team == self.owner.team && (head.movetype == MOVETYPE_WALK || head.movetype == MOVETYPE_STEP)) && !(coop >= 1) && head.classname != "door" && head.classname != "misc_explobox" && !(head.items & IT_INVISIBILITY) && head.classname != "trigger_once" && head.classname != "monster_oldone" && !(head.flags & FL_NOTARGET))
		{
			traceline(self.origin, head.origin, 1, self);
			if (trace_fraction >= 1 && vlen(head.origin - self.origin) < dist)
			{
				selected = head;
				dist = vlen(head.origin - self.origin);
			}
		}
		head = head.chain;
	}
	return selected;
};

void() HomingTouch = 
{
	self.owner.wacky = self.owner.wacky - 1;
	T_RadiusDamage(self, self.owner, 75, world);
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord(MSG_BROADCAST, self.origin_x);
	WriteCoord(MSG_BROADCAST, self.origin_y);
	WriteCoord(MSG_BROADCAST, self.origin_z);
	BecomeExplosion();
};

void() HomeOnTarget = 
{
	local vector needdir;
	local vector currdir;
	local float needspeed;
	local float maxspeed;
	local float acceleration;
	local float temps;
	local vector temp;
	if (self.armorvalue < time)
	{
		self.think = HomingTouch;
		self.nextthink = time + 0.1;
		return;
	}
	self.nextthink = time + 0.6;
	self.think = HomeOnTarget;
	if (self.enemy == world)
	{
		self.velocity = normalize(self.velocity) * 80;
		self.angles = vectoangles(self.velocity);
	}
	if (self.enemy != world)
	{
		traceline(self.origin, self.enemy.origin, 1, self);
	}
	else
	{
		self.enemy = HomeGetTarget();
		return;
	}
	if (trace_fraction < 1 || self.enemy.health < 1 || self.enemy == self.owner)
	{
		self.enemy = HomeGetTarget();
		return;
	}
	self.movetype = MOVETYPE_FLYMISSILE;
	temp = normalize(self.velocity) * 200;
	traceline(self.origin, self.origin + temp, 1, self);
	if (trace_fraction < 1)
	{
		maxspeed = 700;
		acceleration = 800;
	}
	else
	{
		maxspeed = 400;
		acceleration = 150;
	}
	needdir = normalize(self.enemy.origin - self.origin);
	currdir = normalize(self.velocity);
	self.angles = vectoangles(needdir);
	needspeed = vlen(needdir - currdir) * acceleration;
	self.movedir = needdir * needspeed;
	self.velocity = self.velocity + self.movedir;
	if (!infront(self.enemy))
	{
		self.velocity = normalize(self.velocity);
		self.velocity = self.velocity * 80;
	}
	if (vlen(self.velocity) > maxspeed)
	{
		self.velocity = normalize(self.velocity) * maxspeed;
	}
};

void(float num) Missile_Bomb = 
{
	local entity missile;
	local entity mpuff;
	sound(self, CHAN_WEAPON, "weapons/sgun1.wav", 1, ATTN_NORM);
	while (num > 0)
	{
		missile = spawn();
		missile.owner = self.owner;
		missile.solid = SOLID_BBOX;
		missile.classname = "hmissile";
		missile.velocity = normalize(self.velocity) * -1;
		missile.velocity = missile.velocity * (random() * 50);
		missile.angles = vectoangles(missile.velocity);
		missile.touch = HomingTouch;
		missile.movetype = MOVETYPE_FLYMISSILE;
		missile.armorvalue = time + 8;
		missile.nextthink = time + 0.5 + random() * 0.25;
		missile.think = HomeOnTarget;
		missile.enemy = world;
		setmodel(missile, "progs/missile1.mdl");
		setsize(missile, '0 0 0', '0 0 0');
		setorigin(missile, self.origin);
		num = num - 1;
	}
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
		self.classname = "wacky";
		if ("wacky")
		{
			self.owner.wacky = self.owner.wacky - 2;
		}
		remove(self);
		return;
	}
	damg = 100 + random() * 20;
	T_Damage(other, self, self.owner, damg);
	T_RadiusDamage(self, self.owner, 120, other);
	self.origin = self.origin - 8 * normalize(self.velocity);
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord(MSG_BROADCAST, self.origin_x);
	WriteCoord(MSG_BROADCAST, self.origin_y);
	WriteCoord(MSG_BROADCAST, self.origin_z);
	BecomeExplosion();
	if (self.classname == "wacky")
	{
		Missile_Bomb(2);
	}
};

void() Missile_Think = 
{
	if (self.armorvalue < time)
	{
		Missile_Bomb(2);
		GrenadeExplode();
		return;
	}
	self.velocity_x = self.velocity_x - 55 + random() * 110;
	self.velocity_y = self.velocity_y - 55 + random() * 110;
	self.velocity_z = self.velocity_z - 55 + random() * 110;
	self.angles = vectoangles(self.velocity);
	self.nextthink = time + 0.3;
	self.think = Missile_Think;
};

void() W_FireWacky = 
{
	local entity missile;
	local entity mpuff;
	self.currentammo = self.ammo_rockets = self.ammo_rockets - 3;
	if (!(self.player_flag & ITEM_RUNE5_FLAG))
	{
		sound(self, CHAN_WEAPON, "weapons/sgun1.wav", 1, ATTN_NORM);
	}
	self.punchangle_x = -2;
	missile = spawn();
	missile.classname = "wacky";
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	makevectors(self.v_angle);
	missile.velocity = aim(self, 400);
	missile.velocity = missile.velocity * 500;
	missile.velocity = missile.velocity + self.velocity * 0.5;
	missile.angles = vectoangles(missile.velocity);
	missile.touch = T_MissileTouch;
	missile.nextthink = time + 0.1;
	missile.think = Missile_Think;
	missile.armorvalue = time + 4;
	setmodel(missile, "progs/missile.mdl");
	setsize(missile, '0 0 0', '0 0 0');
	setorigin(missile, self.origin + v_forward * 8 + '0 0 16');
};

void() W_FireRocket = 
{
	local entity missile;
	local entity mpuff;
	self.currentammo = self.ammo_rockets = self.ammo_rockets - 1;
	if (!(self.player_flag & ITEM_RUNE5_FLAG))
	{
		sound(self, CHAN_WEAPON, "weapons/sgun1.wav", 1, ATTN_NORM);
	}
	self.punchangle_x = -2;
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
	missile.nextthink = time + 5;
	missile.think = SUB_Remove;
	setmodel(missile, "progs/missile.mdl");
	setsize(missile, '0 0 0', '0 0 0');
	setorigin(missile, self.origin + v_forward * 8 + '0 0 16');
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
	local float tmp;
	if (self.ammo_cells < 1)
	{
		self.weapon = W_BestWeapon();
		W_SetCurrentAmmo();
		return;
	}
	if (self.waterlevel > 1)
	{
		tmp = self.ammo_cells;
		self.ammo_cells = 0;
		W_SetCurrentAmmo();
		T_LightningRadiusDamage(self, self, 35 * tmp, world);
		return;
	}
	if (self.t_width < time)
	{
		if (!(self.player_flag & ITEM_RUNE5_FLAG))
		{
			sound(self, CHAN_WEAPON, "weapons/lhit.wav", 1, ATTN_NORM);
		}
		self.t_width = time + 0.6;
	}
	self.punchangle_x = -2;
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
	LightningDamage(self.origin, trace_endpos + v_forward * 4, self, 30);
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
	if (other.takedamage == DAMAGE_AIM && self.classname == "CB")
	{
		Cluster_Bomb(4);
		GrenadeExplode();
		return;
	}
	if (other.takedamage == DAMAGE_AIM)
	{
		GrenadeExplode();
		return;
	}
	sound(self, CHAN_WEAPON, "weapons/bounce.wav", 1, ATTN_NORM);
	self.velocity_z = self.velocity_z - 50 + random() * 100;
	self.velocity_y = self.velocity_y - 50 + random() * 100;
	self.velocity_x = self.velocity_x - 50 + random() * 100;
	if (self.velocity == '0 0 0')
	{
		self.avelocity = '0 0 0';
	}
};

void() GTouch = 
{
	if (other.takedamage == DAMAGE_AIM)
	{
		GrenadeExplode();
		return;
	}
	sound(self, CHAN_WEAPON, "weapons/bounce.wav", 1, ATTN_NORM);
	self.velocity_z = self.velocity_z - 50 + random() * 100;
	self.velocity_y = self.velocity_y - 50 + random() * 100;
	self.velocity_x = self.velocity_x - 50 + random() * 100;
	if (self.velocity == '0 0 0')
	{
		self.avelocity = '0 0 0';
	}
};

void(float bombs) Cluster_Bomb = 
{
	local entity missile;
	while (bombs > 0)
	{
		missile = spawn();
		missile.movetype = MOVETYPE_BOUNCE;
		missile.solid = SOLID_BBOX;
		missile.classname = "cgrenade";
		missile.owner = self.owner;
		missile.velocity = self.velocity * 0.25;
		if (self.velocity == '0 0 0')
		{
			missile.velocity_z = 400 + random() * 800;
			missile.velocity_y = 0 - 600 + random() * 1200;
			missile.velocity_x = 0 - 600 + random() * 1200;
			missile.avelocity = '300 300 300';
		}
		else
		{
			missile.velocity_z = missile.velocity_z - 200 + random() * 400;
			missile.velocity_y = missile.velocity_y - 500 + random() * 1000;
			missile.velocity_x = missile.velocity_x - 500 + random() * 1000;
			missile.avelocity = '300 300 300';
		}
		missile.angles = vectoangles(missile.velocity);
		missile.touch = GTouch;
		missile.nextthink = time + 2.5 - random() * 2;
		missile.think = GrenadeExplode;
		setmodel(missile, "progs/grenade.mdl");
		setsize(missile, '0 0 0', '0 0 0');
		setorigin(missile, self.origin);
		bombs = bombs - 1;
	}
};

void() Grenade_Think = 
{
	if (self.armorvalue < time)
	{
		Cluster_Bomb(4);
		GrenadeExplode();
		return;
	}
	self.nextthink = time + 0.25;
	self.think = Grenade_Think;
};

void() W_FireCluster = 
{
	local entity missile;
	local entity mpuff;
	self.currentammo = self.ammo_rockets = self.ammo_rockets - 5;
	if (!(self.player_flag & ITEM_RUNE5_FLAG))
	{
		sound(self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM);
	}
	self.punchangle_x = -2;
	missile = spawn();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
	missile.classname = "CB";
	makevectors(self.v_angle);
	if (self.v_angle_x)
	{
		missile.velocity = v_forward * 600 + v_up * 200 + crandom() * v_right * 10 + crandom() * v_up * 10;
		missile.velocity = missile.velocity + self.velocity * 0.5;
	}
	else
	{
		missile.velocity = aim(self, 10000);
		missile.velocity = missile.velocity * 600;
		missile.velocity = missile.velocity + self.velocity * 0.5;
		missile.velocity_z = 200;
	}
	missile.avelocity = '300 300 300';
	missile.angles = vectoangles(missile.velocity);
	missile.touch = GrenadeTouch;
	missile.armorvalue = time + 1;
	missile.nextthink = time + 1.1;
	missile.think = Grenade_Think;
	setmodel(missile, "progs/grenade1.mdl");
	setsize(missile, '0 0 0', '0 0 0');
	setorigin(missile, self.origin);
};

void() W_FireGrenade = 
{
	local entity missile;
	local entity mpuff;
	self.currentammo = self.ammo_rockets = self.ammo_rockets - 1;
	if (!(self.player_flag & ITEM_RUNE5_FLAG))
	{
		sound(self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM);
	}
	self.punchangle_x = -2;
	missile = spawn();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
	missile.classname = "grenade";
	makevectors(self.v_angle);
	if (self.v_angle_x)
	{
		missile.velocity = v_forward * 600 + v_up * 200 + crandom() * v_right * 10 + crandom() * v_up * 10;
		missile.velocity = missile.velocity + self.velocity * 0.5;
	}
	else
	{
		missile.velocity = aim(self, 10000);
		missile.velocity = missile.velocity * 600;
		missile.velocity = missile.velocity + self.velocity * 0.5;
		missile.velocity_z = 200;
	}
	missile.avelocity = '300 300 300';
	missile.angles = vectoangles(missile.velocity);
	missile.touch = GrenadeTouch;
	missile.nextthink = time + 2.5;
	missile.think = GrenadeExplode;
	setmodel(missile, "progs/grenade.mdl");
	setsize(missile, '0 0 0', '0 0 0');
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
	newmis.nextthink = time + 5;
	setmodel(newmis, "progs/spike.mdl");
	setsize(newmis, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(newmis, org);
	newmis.velocity = dir * 1000;
};

void() W_FireSuperSpikes = 
{
	local vector dir;
	local entity old;
	if (!(self.player_flag & ITEM_RUNE5_FLAG))
	{
		sound(self, CHAN_WEAPON, "weapons/spike2.wav", 1, ATTN_NORM);
	}
	self.attack_finished = time + 0.2;
	self.currentammo = self.ammo_nails = self.ammo_nails - 2;
	dir = aim(self, 1000);
	launch_spike(self.origin + '0 0 16', dir);
	newmis.touch = superspike_touch;
	setmodel(newmis, "progs/s_spike.mdl");
	setsize(newmis, VEC_ORIGIN, VEC_ORIGIN);
	self.punchangle_x = -2;
};

void(float ox) W_FireSpikes = 
{
	local vector dir;
	local entity old;
	makevectors(self.v_angle);
	if (self.ammo_nails >= 2 && self.weapon == IT_SUPER_NAILGUN)
	{
		W_FireSuperSpikes();
		return;
	}
	if (self.ammo_nails < 1)
	{
		self.weapon = W_BestWeapon();
		W_SetCurrentAmmo();
		return;
	}
	if (!(self.player_flag & ITEM_RUNE5_FLAG))
	{
		sound(self, CHAN_WEAPON, "weapons/rocket1i.wav", 1, ATTN_NORM);
	}
	self.attack_finished = time + 0.2;
	self.currentammo = self.ammo_nails = self.ammo_nails - 1;
	dir = aim(self, 1000);
	launch_spike(self.origin + '0 0 16' + v_right * ox, dir);
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
		spawn_touchblood(9);
		T_Damage(other, self, self.owner, 9);
	}
	else
	{
		WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte(MSG_BROADCAST, TE_SPIKE);
		WriteCoord(MSG_BROADCAST, self.origin_x);
		WriteCoord(MSG_BROADCAST, self.origin_y);
		WriteCoord(MSG_BROADCAST, self.origin_z);
	}
	remove(self);
};

void() spike_think = 
{
	spike_explode();
};

void() spike_explode = 
{
	local entity null_ent;
	if (self.owner.classname == "player" && random() > 0.8)
	{
		null_ent = spawn();
		null_ent.think = SUB_Remove;
		null_ent.nextthink = 0.010000;
		T_RadiusDamage(self, self.owner, 60, null_ent);
		sound(self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);
		WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte(MSG_BROADCAST, TE_EXPLOSION);
		WriteCoord(MSG_BROADCAST, self.origin_x);
		WriteCoord(MSG_BROADCAST, self.origin_y);
		WriteCoord(MSG_BROADCAST, self.origin_z);
		BecomeExplosion();
	}
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
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_SUPERSPIKE);
	WriteCoord(MSG_BROADCAST, self.origin_x);
	WriteCoord(MSG_BROADCAST, self.origin_y);
	WriteCoord(MSG_BROADCAST, self.origin_z);
	remove(self);
};

void() superspike_think = 
{
	superspike_explode();
};

void() superspike_explode = 
{
	local entity null_ent;
	if (self.owner.classname == "player" && random() > 0.8)
	{
		null_ent = spawn();
		null_ent.think = SUB_Remove;
		null_ent.nextthink = 0.010000;
		T_RadiusDamage(self, self.owner, 80, null_ent);
		sound(self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);
		WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte(MSG_BROADCAST, TE_EXPLOSION);
		WriteCoord(MSG_BROADCAST, self.origin_x);
		WriteCoord(MSG_BROADCAST, self.origin_y);
		WriteCoord(MSG_BROADCAST, self.origin_z);
		BecomeExplosion();
	}
};

void() TellWeapon = 
{
	if (self.weapon == IT_AXE)
	{
		sprint(self, "Axe\n");
		return;
	}
	if (self.weapon == IT_SHOTGUN)
	{
		sprint(self, "Shotgun\n");
		return;
	}
	if (self.weapon == IT_SUPER_SHOTGUN)
	{
		if (self.quad_shot != 2)
		{
			sprint(self, "Super Shotgun\n");
		}
		else
		{
			sprint(self, "Dual Super Shotguns\n");
		}
		return;
	}
	if (self.weapon == IT_NAILGUN)
	{
		sprint(self, "Nailgun\n");
		return;
	}
	if (self.weapon == IT_SUPER_NAILGUN)
	{
		sprint(self, "Super Nailgun\n");
		return;
	}
	if (self.weapon == IT_GRENADE_LAUNCHER)
	{
		sprint(self, "Grenade Launcher\n");
		return;
	}
	if (self.weapon == IT_ROCKET_LAUNCHER)
	{
		sprint(self, "Rocket Launcher\n");
		return;
	}
	if (self.weapon == IT_LIGHTNING)
	{
		sprint(self, "Lightning Gun\n");
		return;
	}
	if (self.weapon == IT_EXTRA_WEAPON)
	{
		if (self.weapon2 == WE_SNIPER_RIFLE)
		{
			sprint(self, "Sniper Rifle\n");
			return;
		}
		if (self.weapon2 == WE_GRAPPLE)
		{
			sprint(self, "Grappling Hook\n");
			return;
		}
		if (self.weapon2 == WE_AIRFIST)
		{
			sprint(self, "Air Fist\n");
			return;
		}
		if (self.weapon2 == WE_WACKY)
		{
			sprint(self, "Wacky Missiles\n");
			return;
		}
		if (self.weapon2 == WE_CLUSTER)
		{
			sprint(self, "Cluster Bomb Launcher\n");
			return;
		}
		if (self.weapon2 == WE_PLASMAGUN)
		{
			sprint(self, "Plasma Rifle\n");
			return;
		}
		if (self.weapon2 == WE_BFG)
		{
			sprint(self, "BFG 9000. Need I say more?\n");
			return;
		}
	}
};

void() W_SetCurrentAmmo = 
{
	player_run();
	self.items = self.items - (self.items & (IT_SHELLS | IT_NAILS | IT_ROCKETS | IT_CELLS));
	if (self.weapon == IT_AXE)
	{
		self.currentammo = 0;
		self.weaponmodel = "progs/v_axe.mdl";
		self.weaponframe = 0;
	}
	else
	{
		if (self.weapon == IT_SHOTGUN)
		{
			self.currentammo = self.ammo_shells;
			self.weaponmodel = "progs/v_shot.mdl";
			self.weaponframe = 0;
			self.items = self.items | IT_SHELLS;
		}
		else
		{
			if (self.weapon == IT_SUPER_SHOTGUN)
			{
				self.currentammo = self.ammo_shells;
				self.weaponmodel = "progs/v_shot2.mdl";
				self.weaponframe = 0;
				self.items = self.items | IT_SHELLS;
				if (self.quad_shot == 2)
				{
					self.weaponmodel = "progs/v_4bshot.mdl";
				}
			}
			else
			{
				if (self.weapon == IT_NAILGUN)
				{
					self.currentammo = self.ammo_nails;
					self.weaponmodel = "progs/v_nail.mdl";
					self.weaponframe = 0;
					self.items = self.items | IT_NAILS;
				}
				else
				{
					if (self.weapon == IT_SUPER_NAILGUN)
					{
						self.currentammo = self.ammo_nails;
						self.weaponmodel = "progs/v_nail2.mdl";
						self.weaponframe = 0;
						self.items = self.items | IT_NAILS;
					}
					else
					{
						if (self.weapon == IT_GRENADE_LAUNCHER)
						{
							self.currentammo = self.ammo_rockets;
							self.weaponmodel = "progs/v_rock.mdl";
							self.weaponframe = 0;
							self.items = self.items | IT_ROCKETS;
						}
						else
						{
							if (self.weapon == IT_ROCKET_LAUNCHER)
							{
								self.currentammo = self.ammo_rockets;
								self.weaponmodel = "progs/v_rock2.mdl";
								self.weaponframe = 0;
								self.items = self.items | IT_ROCKETS;
							}
							else
							{
								if (self.weapon == IT_LIGHTNING)
								{
									self.currentammo = self.ammo_cells;
									self.weaponmodel = "progs/v_light.mdl";
									self.weaponframe = 0;
									self.items = self.items | IT_CELLS;
								}
								else
								{
									if (self.weapon == IT_EXTRA_WEAPON)
									{
										if (self.weapon2 == WE_AIRFIST)
										{
											self.currentammo = 0;
											self.weaponmodel = "progs/v_airgun.mdl";
											self.weaponframe = 0;
										}
										else
										{
											if (self.weapon2 == WE_SNIPER_RIFLE)
											{
												self.currentammo = self.ammo_shells;
												self.weaponmodel = "progs/v_sniper.mdl";
												self.weaponframe = 0;
												self.items = self.items | IT_SHELLS;
											}
											else
											{
												if (self.weapon2 == WE_GRAPPLE)
												{
													self.currentammo = 0;
													self.weaponmodel = "progs/v_star.mdl";
													self.weaponframe = 0;
												}
												else
												{
													if (self.weapon2 == WE_CLUSTER)
													{
														self.currentammo = self.ammo_rockets;
														self.weaponmodel = "progs/v_rockx.mdl";
														self.weaponframe = 0;
														self.items = self.items | IT_ROCKETS;
													}
													else
													{
														if (self.weapon2 == WE_WACKY)
														{
															self.currentammo = self.ammo_rockets;
															self.weaponmodel = "progs/v_rockx2.mdl";
															self.weaponframe = 0;
															self.items = self.items | IT_ROCKETS;
														}
														else
														{
															if (self.weapon2 == WE_PLASMAGUN)
															{
																self.currentammo = self.ammo_cells;
																self.weaponmodel = "progs/v_plasma.mdl";
																self.weaponframe = 0;
																self.items = self.items | IT_CELLS;
															}
															else
															{
																if (self.weapon2 == WE_BFG)
																{
																	self.currentammo = self.ammo_cells;
																	self.weaponmodel = "progs/v_bfg.mdl";
																	self.weaponframe = 0;
																	self.items = self.items | IT_CELLS;
																}
															}
														}
													}
												}
											}
										}
									}
									else
									{
										self.currentammo = 0;
										self.weaponmodel = "";
										self.weaponframe = 0;
										bprint("ERROR - Error Code :\n");
										bprint(ftos(self.weapon));
										bprint(" ");
										bprint(ftos(self.weapon2));
										bprint("\n");
									}
								}
							}
						}
					}
				}
			}
		}
	}
	self.nxtupdate = time;
};

float() W_BestWeapon = 
{
	local float it;
	local float we;
	it = self.items;
	we = self.weapons;
	if (self.ammo_cells >= 1 && (it & IT_LIGHTNING) && self.waterlevel < 2)
	{
		return IT_LIGHTNING;
	}
	else
	{
		if (self.ammo_nails >= 2 && (it & IT_SUPER_NAILGUN))
		{
			return IT_SUPER_NAILGUN;
		}
		else
		{
			if (self.ammo_shells >= 2 && (it & IT_SUPER_SHOTGUN))
			{
				return IT_SUPER_SHOTGUN;
			}
			else
			{
				if (self.ammo_nails >= 1 && (it & IT_NAILGUN))
				{
					return IT_NAILGUN;
				}
				else
				{
					if (self.ammo_shells >= 1 && (it & IT_SHOTGUN))
					{
						return IT_SHOTGUN;
					}
				}
			}
		}
	}
	return IT_AXE;
};

float() W_CheckNoAmmo = 
{
	if (self.weapon != IT_EXTRA_WEAPON)
	{
		if (self.currentammo > 0)
		{
			return 1;
		}
	}
	else
	{
		if (self.weapon2 == WE_CLUSTER)
		{
			if (self.currentammo > 4)
			{
				return 1;
			}
		}
		else
		{
			if (self.weapon2 == WE_WACKY)
			{
				if (self.currentammo > 2)
				{
					return 1;
				}
			}
			else
			{
				if (self.weapon2 == WE_SNIPER_RIFLE)
				{
					if (self.currentammo > 0)
					{
						return 1;
					}
				}
				else
				{
					if (self.weapon2 == WE_PLASMAGUN)
					{
						if (self.currentammo > 0)
						{
							return 1;
						}
					}
					else
					{
						if (self.weapon2 == WE_BFG)
						{
							if (self.currentammo > 29)
							{
								return 1;
							}
						}
					}
				}
			}
		}
	}
	if (self.weapon == IT_AXE || (self.weapon == IT_EXTRA_WEAPON && (self.weapon2 == WE_GRAPPLE || self.weapon2 == WE_AIRFIST)))
	{
		return 1;
	}
	self.weapon = W_BestWeapon();
	if (self.axe_only_time > time)
	{
		self.weapon = IT_AXE;
	}
	TellWeapon();
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
	self.show_hostile = time + 1;
	if (self.weapon == IT_AXE)
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
		if (self.player_flag & ITEM_RUNE3_FLAG)
		{
			self.attack_finished = time + 0.25;
			HasteSound();
		}
		else
		{
			self.attack_finished = time + 0.5;
		}
	}
	else
	{
		if (self.weapon == IT_SHOTGUN)
		{
			player_shot1();
			W_FireShotgun();
			if (self.player_flag & ITEM_RUNE3_FLAG)
			{
				self.attack_finished = time + 0.3;
				HasteSound();
			}
			else
			{
				self.attack_finished = time + 0.6;
			}
		}
		else
		{
			if (self.weapon == IT_SUPER_SHOTGUN)
			{
				player_shot1();
				W_FireSuperShotgun();
				if (self.quad_shot != 2)
				{
					if (self.player_flag & ITEM_RUNE3_FLAG)
					{
						self.attack_finished = time + 0.35;
						HasteSound();
					}
					else
					{
						self.attack_finished = time + 0.7;
					}
				}
				if (self.quad_shot == 2)
				{
					if (self.player_flag & ITEM_RUNE3_FLAG)
					{
						self.attack_finished = time + 0.7;
						HasteSound();
					}
					else
					{
						self.attack_finished = time + 1.4;
					}
				}
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
							if (self.player_flag & ITEM_RUNE3_FLAG)
							{
								self.attack_finished = time + 0.3;
								HasteSound();
							}
							else
							{
								self.attack_finished = time + 0.6;
							}
						}
						else
						{
							if (self.weapon == IT_ROCKET_LAUNCHER)
							{
								player_rocket1();
								W_FireRocket();
								if (self.player_flag & ITEM_RUNE3_FLAG)
								{
									self.attack_finished = time + 0.4;
									HasteSound();
								}
								else
								{
									self.attack_finished = time + 0.8;
								}
							}
							else
							{
								if (self.weapon == IT_LIGHTNING)
								{
									player_light1();
									self.attack_finished = time + 0.1;
									if (!(self.player_flag & ITEM_RUNE5_FLAG))
									{
										sound(self, CHAN_AUTO, "weapons/lstart.wav", 1, ATTN_NORM);
									}
								}
								else
								{
									if (self.weapon == IT_EXTRA_WEAPON)
									{
										if (self.weapon2 == WE_AIRFIST)
										{
											launch_horn();
										}
										else
										{
											if (self.weapon2 == WE_SNIPER_RIFLE && self.snipe_wait < time)
											{
												player_shot1();
												W_FireShotgun();
												if (self.player_flag & ITEM_RUNE3_FLAG)
												{
													self.attack_finished = time + 2;
													HasteSound();
												}
												else
												{
													self.attack_finished = time + 4;
												}
											}
											else
											{
												if (self.weapon2 == WE_GRAPPLE)
												{
													if (!(self.hook_out))
													{
														player_chain1();
													}
													else
													{
														player_chain3();
													}
													self.attack_finished = time + 0.1;
												}
												else
												{
													if (self.weapon2 == WE_CLUSTER)
													{
														player_rocket1();
														W_FireCluster();
														if (self.player_flag & ITEM_RUNE3_FLAG)
														{
															self.attack_finished = time + 0.7;
															HasteSound();
														}
														else
														{
															self.attack_finished = time + 1.4;
														}
													}
													else
													{
														if (self.weapon2 == WE_WACKY)
														{
															if (self.wacky > 7)
															{
																return;
															}
															player_rocket1();
															self.wacky = self.wacky + 2;
															W_FireWacky();
															if (self.player_flag & ITEM_RUNE3_FLAG)
															{
																self.attack_finished = time + 1;
																HasteSound();
															}
															else
															{
																self.attack_finished = time + 1.75;
															}
														}
														else
														{
															if (self.weapon2 == WE_PLASMAGUN)
															{
																player_shot1();
																W_FirePlasma();
																if (self.player_flag & ITEM_RUNE3_FLAG)
																{
																	self.attack_finished = time + 0.05;
																	HasteSound();
																}
																else
																{
																	self.attack_finished = time + 0.09;
																}
															}
															else
															{
																if (self.weapon2 == WE_BFG)
																{
																	player_rocket1();
																	W_FireBFG();
																	if (self.player_flag & ITEM_RUNE3_FLAG)
																	{
																		self.attack_finished = time + 0.6;
																		HasteSound();
																	}
																	else
																	{
																		self.attack_finished = time + 1.2;
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

void() W_ChangeWeapon = 
{
	local float it;
	local float am;
	local float fl;
	local float fl2;
	it = self.items;
	am = 0;
	if (self.impulse == I_AXE)
	{
		fl = IT_AXE;
		if (self.weapon == IT_AXE)
		{
			fl = IT_EXTRA_WEAPON;
			fl2 = WE_GRAPPLE;
		}
		if (self.weapon2 == WE_GRAPPLE && self.weapon == IT_EXTRA_WEAPON)
		{
			fl = IT_EXTRA_WEAPON;
			fl2 = WE_AIRFIST;
		}
	}
	else
	{
		if (self.impulse == I_SHOTGUN)
		{
			fl = IT_SHOTGUN;
			if (self.weapon == IT_SHOTGUN)
			{
				fl = IT_EXTRA_WEAPON;
				fl2 = WE_SNIPER_RIFLE;
				self.snipe_wait = time + 1.25;
			}
			if (self.ammo_shells < 1)
			{
				am = 1;
			}
		}
		else
		{
			if (self.impulse == I_DSHOTGUN)
			{
				if (self.weapon == IT_SUPER_SHOTGUN && self.quad_shot > 0)
				{
					self.quad_shot = self.quad_shot + 1;
					if (self.quad_shot > 2)
					{
						self.quad_shot = 1;
					}
				}
				fl = IT_SUPER_SHOTGUN;
				if (self.ammo_shells < 2)
				{
					am = 1;
				}
			}
			else
			{
				if (self.impulse == I_NAILGUN)
				{
					fl = IT_NAILGUN;
					if (self.ammo_nails < 1)
					{
						am = 1;
					}
				}
				else
				{
					if (self.impulse == I_SNAILGUN)
					{
						fl = IT_SUPER_NAILGUN;
						if (self.ammo_nails < 2)
						{
							am = 1;
						}
					}
					else
					{
						if (self.impulse == I_GRENADE)
						{
							fl = IT_GRENADE_LAUNCHER;
							if (self.weapon == IT_GRENADE_LAUNCHER)
							{
								fl = IT_EXTRA_WEAPON;
								fl2 = WE_CLUSTER;
								if (self.ammo_rockets < 5)
								{
									am = 1;
								}
							}
							if (self.ammo_rockets < 1)
							{
								am = 1;
							}
						}
						else
						{
							if (self.impulse == I_ROCKET)
							{
								fl = IT_ROCKET_LAUNCHER;
								if (self.weapon == IT_ROCKET_LAUNCHER)
								{
									fl = IT_EXTRA_WEAPON;
									fl2 = WE_WACKY;
									if (self.ammo_rockets < 3)
									{
										am = 1;
									}
								}
								if (self.ammo_rockets < 1)
								{
									am = 1;
								}
							}
							else
							{
								if (self.impulse == I_LIGHTNING)
								{
									fl = IT_LIGHTNING;
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
	if (fl != IT_EXTRA_WEAPON)
	{
		if (!(self.items & fl))
		{
			sprint(self, "no weapon.\n");
			return;
		}
	}
	else
	{
		if (!(self.weapons & fl2))
		{
			sprint(self, "no weapon.\n");
			return;
		}
	}
	if (am)
	{
		sprint(self, "not enough ammo.\n");
		return;
	}
	self.weapon2 = fl2;
	self.weapon = fl;
	W_SetCurrentAmmo();
	TellWeapon();
};

void() W_ChangeWeapon2 = 
{
	local float it;
	local float am;
	local float fl;
	it = self.items;
	am = 0;
	if (self.quad_shot > 0)
	{
		self.quad_shot = 1;
	}
	if (self.impulse == I_AIRGUN)
	{
		fl = WE_AIRFIST;
	}
	else
	{
		if (self.impulse == I_GRAPPLE)
		{
			fl = WE_GRAPPLE;
		}
		else
		{
			if (self.impulse == I_SNIPER)
			{
				fl = WE_SNIPER_RIFLE;
				if (self.ammo_shells < 1)
				{
					am = 1;
				}
			}
			else
			{
				if (self.impulse == I_CLUSTER)
				{
					fl = WE_CLUSTER;
					if (self.ammo_rockets < 5)
					{
						am = 1;
					}
				}
				else
				{
					if (self.impulse == I_WACKY)
					{
						fl = WE_WACKY;
						if (self.ammo_rockets < 3)
						{
							am = 1;
						}
					}
					else
					{
						if (self.impulse == I_PLASMAGUN)
						{
							fl = WE_PLASMAGUN;
							if (self.ammo_cells < 1)
							{
								am = 1;
							}
						}
						else
						{
							if (self.impulse == I_BFG)
							{
								fl = WE_BFG;
								if (self.ammo_cells < 30)
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
	self.impulse = 0;
	if (!(self.weapons & fl))
	{
		sprint(self, "no weapon.\n");
		return;
	}
	if (am)
	{
		sprint(self, "not enough ammo.\n");
		return;
	}
	self.weapon = IT_EXTRA_WEAPON;
	self.weapon2 = fl;
	if (self.axe_only_time > time)
	{
		self.weapon = IT_AXE;
	}
	W_SetCurrentAmmo();
	TellWeapon();
};

void() CheatCommand = 
{
	if (deathmatch)
	{
		return;
	}
	self.ammo_rockets = 100;
	self.ammo_nails = 200;
	self.ammo_shells = 100;
	self.items = self.items | IT_AXE | IT_SHOTGUN | IT_SUPER_SHOTGUN | IT_NAILGUN | IT_SUPER_NAILGUN | IT_GRENADE_LAUNCHER | IT_ROCKET_LAUNCHER | IT_KEY1 | IT_KEY2 | IT_LIGHTNING;
	self.weapons = self.weapons | WE_CLUSTER | WE_WACKY | WE_BFG | WE_PLASMAGUN | WE_SNIPER_RIFLE;
	self.quad_shot = 1;
	self.ammo_cells = 200;
	self.weapon = IT_ROCKET_LAUNCHER;
	self.impulse = 0;
	W_SetCurrentAmmo();
	TellWeapon();
};

void() CycleWeaponReverseCommand = 
{
	local float it;
	local float am;
	if (self.flags & FL_OBSERVER)
	{
		return;
	}
	it = self.items;
	self.impulse = 0;
	while (1)
	{
		am = 0;
		if (self.weapon == IT_EXTRA_WEAPON && self.weapon2 == WE_BFG)
		{
			self.weapon = IT_LIGHTNING;
			if (self.ammo_cells < 1)
			{
				am = 1;
			}
		}
		else
		{
			if (self.weapon == IT_LIGHTNING)
			{
				self.weapon = IT_EXTRA_WEAPON;
				self.weapon2 = WE_PLASMAGUN;
				if (self.ammo_cells < 1)
				{
					am = 1;
				}
			}
			else
			{
				if (self.weapon == IT_EXTRA_WEAPON && self.weapon2 == WE_PLASMAGUN)
				{
					self.weapon = IT_EXTRA_WEAPON;
					self.weapon2 = WE_WACKY;
					if (self.ammo_rockets < 3)
					{
						am = 1;
					}
				}
				else
				{
					if (self.weapon == IT_EXTRA_WEAPON && self.weapon2 == WE_WACKY)
					{
						self.weapon = IT_ROCKET_LAUNCHER;
						if (self.ammo_rockets < 1)
						{
							am = 1;
						}
					}
					else
					{
						if (self.weapon == IT_ROCKET_LAUNCHER)
						{
							self.weapon = IT_EXTRA_WEAPON;
							self.weapon2 = WE_CLUSTER;
							if (self.ammo_rockets < 5)
							{
								am = 1;
							}
						}
						else
						{
							if (self.weapon == IT_EXTRA_WEAPON && self.weapon2 == WE_CLUSTER)
							{
								self.weapon = IT_GRENADE_LAUNCHER;
								if (self.ammo_rockets < 1)
								{
									am = 1;
								}
							}
							else
							{
								if (self.weapon == IT_GRENADE_LAUNCHER)
								{
									self.weapon = IT_SUPER_NAILGUN;
									if (self.ammo_nails < 2)
									{
										am = 1;
									}
								}
								else
								{
									if (self.weapon == IT_SUPER_NAILGUN)
									{
										self.weapon = IT_NAILGUN;
										if (self.ammo_nails < 1)
										{
											am = 1;
										}
									}
									else
									{
										if (self.weapon == IT_NAILGUN)
										{
											self.weapon = IT_SUPER_SHOTGUN;
											if (self.ammo_shells < 4)
											{
												am = 1;
											}
											if (self.quad_shot > 0)
											{
												self.quad_shot = 2;
											}
										}
										else
										{
											if (self.weapon == IT_SUPER_SHOTGUN && self.quad_shot == 2)
											{
												self.weapon = IT_SUPER_SHOTGUN;
												if (self.ammo_shells < 2)
												{
													am = 1;
												}
												if (self.quad_shot > 0)
												{
													self.quad_shot = 1;
												}
											}
											else
											{
												if (self.weapon == IT_SUPER_SHOTGUN)
												{
													self.weapon = IT_EXTRA_WEAPON;
													self.weapon2 = WE_SNIPER_RIFLE;
													if (self.ammo_shells < 1)
													{
														am = 1;
													}
													self.snipe_wait = time + 1.25;
												}
												else
												{
													if (self.weapon == IT_EXTRA_WEAPON && self.weapon2 == WE_SNIPER_RIFLE)
													{
														self.weapon = IT_SHOTGUN;
														if (self.ammo_shells < 1)
														{
															am = 1;
														}
													}
													else
													{
														if (self.weapon == IT_SHOTGUN)
														{
															self.weapon = IT_EXTRA_WEAPON;
															self.weapon2 = WE_AIRFIST;
														}
														else
														{
															if (self.weapon == IT_EXTRA_WEAPON && self.weapon2 == WE_AIRFIST)
															{
																self.weapon = IT_EXTRA_WEAPON;
																self.weapon2 = WE_GRAPPLE;
															}
															else
															{
																if (self.weapon == IT_EXTRA_WEAPON && self.weapon2 == WE_GRAPPLE)
																{
																	self.weapon = IT_AXE;
																}
																else
																{
																	if (self.weapon == IT_AXE)
																	{
																		self.weapon = IT_EXTRA_WEAPON;
																		self.weapon2 = WE_BFG;
																		if (self.ammo_cells < 30)
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
									}
								}
							}
						}
					}
				}
			}
		}
		if (self.weapon == IT_EXTRA_WEAPON && (self.weapon2 == WE_WACKY || self.weapon2 == WE_CLUSTER || self.weapon2 == WE_PLASMAGUN || self.weapon2 == WE_BFG || self.weapon2 == WE_SNIPER_RIFLE))
		{
			if (self.weapon2 == WE_WACKY && !(self.items & IT_ROCKET_LAUNCHER))
			{
				am = 1;
			}
			if (self.weapon2 == WE_CLUSTER && !(self.items & IT_GRENADE_LAUNCHER))
			{
				am = 1;
			}
			if (self.weapon2 == WE_PLASMAGUN && !(self.weapons & WE_PLASMAGUN))
			{
				am = 1;
			}
			if (self.weapon2 == WE_BFG && !(self.weapons & WE_BFG))
			{
				am = 1;
			}
			if (self.weapon2 == WE_SNIPER_RIFLE && !(self.weapons & WE_SNIPER_RIFLE))
			{
				am = 1;
			}
			if (am == 0)
			{
				TellWeapon();
				W_SetCurrentAmmo();
				return;
			}
		}
		else
		{
			if (self.items & self.weapon && am == 0)
			{
				if (self.axe_only_time > time)
				{
					self.weapon = IT_AXE;
				}
				TellWeapon();
				W_SetCurrentAmmo();
				return;
			}
		}
	}
};

void() CycleWeaponCommand = 
{
	local float it;
	local float am;
	if (self.observer)
	{
		return;
	}
	it = self.items;
	self.impulse = 0;
	while (1)
	{
		am = 0;
		if (self.weapon == IT_EXTRA_WEAPON && self.weapon2 == WE_BFG)
		{
			self.weapon = IT_AXE;
		}
		else
		{
			if (self.weapon == IT_AXE)
			{
				self.weapon = IT_EXTRA_WEAPON;
				self.weapon2 = WE_GRAPPLE;
			}
			else
			{
				if (self.weapon == IT_EXTRA_WEAPON && self.weapon2 == WE_GRAPPLE)
				{
					self.weapon = IT_EXTRA_WEAPON;
					self.weapon2 = WE_AIRFIST;
				}
				else
				{
					if (self.weapon == IT_EXTRA_WEAPON && self.weapon2 == WE_AIRFIST)
					{
						self.weapon = IT_SHOTGUN;
						if (self.ammo_shells < 1)
						{
							am = 1;
						}
					}
					else
					{
						if (self.weapon == IT_SHOTGUN)
						{
							self.weapon = IT_EXTRA_WEAPON;
							self.weapon2 = WE_SNIPER_RIFLE;
							if (self.ammo_shells < 1)
							{
								am = 1;
							}
							self.snipe_wait = time + 1.25;
						}
						else
						{
							if (self.weapon == IT_EXTRA_WEAPON && self.weapon2 == WE_SNIPER_RIFLE)
							{
								if (self.quad_shot > 0)
								{
									self.quad_shot = 1;
								}
								self.weapon = IT_SUPER_SHOTGUN;
								if (self.ammo_shells < 2)
								{
									am = 1;
								}
							}
							else
							{
								if (self.weapon == IT_SUPER_SHOTGUN && self.quad_shot == 1)
								{
									self.weapon = IT_SUPER_SHOTGUN;
									if (self.ammo_shells < 4)
									{
										am = 1;
									}
									self.quad_shot = 2;
								}
								else
								{
									if (self.weapon == IT_SUPER_SHOTGUN)
									{
										self.weapon = IT_NAILGUN;
										if (self.ammo_nails < 1)
										{
											am = 1;
										}
									}
									else
									{
										if (self.weapon == IT_NAILGUN)
										{
											self.weapon = IT_SUPER_NAILGUN;
											if (self.ammo_nails < 2)
											{
												am = 1;
											}
										}
										else
										{
											if (self.weapon == IT_SUPER_NAILGUN)
											{
												self.weapon = IT_GRENADE_LAUNCHER;
												if (self.ammo_rockets < 1)
												{
													am = 1;
												}
											}
											else
											{
												if (self.weapon == IT_GRENADE_LAUNCHER)
												{
													self.weapon = IT_EXTRA_WEAPON;
													self.weapon2 = WE_CLUSTER;
													if (self.ammo_rockets < 5)
													{
														am = 1;
													}
												}
												else
												{
													if (self.weapon == IT_EXTRA_WEAPON && self.weapon2 == WE_CLUSTER)
													{
														self.weapon = IT_ROCKET_LAUNCHER;
														if (self.ammo_rockets < 1)
														{
															am = 1;
														}
													}
													else
													{
														if (self.weapon == IT_ROCKET_LAUNCHER)
														{
															self.weapon = IT_EXTRA_WEAPON;
															self.weapon2 = WE_WACKY;
															if (self.ammo_rockets < 3)
															{
																am = 1;
															}
														}
														else
														{
															if (self.weapon == IT_EXTRA_WEAPON && self.weapon2 == WE_WACKY)
															{
																self.weapon = IT_EXTRA_WEAPON;
																self.weapon2 = WE_PLASMAGUN;
																if (self.ammo_cells < 1)
																{
																	am = 1;
																}
															}
															else
															{
																if (self.weapon == IT_EXTRA_WEAPON && self.weapon2 == WE_PLASMAGUN)
																{
																	self.weapon = IT_LIGHTNING;
																	if (self.ammo_cells < 1)
																	{
																		am = 1;
																	}
																}
																else
																{
																	if (self.weapon == IT_LIGHTNING)
																	{
																		self.weapon = IT_EXTRA_WEAPON;
																		self.weapon2 = WE_BFG;
																		if (self.ammo_cells < 30)
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
									}
								}
							}
						}
					}
				}
			}
		}
		if (self.weapon == IT_EXTRA_WEAPON && (self.weapon2 == WE_WACKY || self.weapon2 == WE_CLUSTER || self.weapon2 == WE_PLASMAGUN || self.weapon2 == WE_BFG || self.weapon2 == WE_SNIPER_RIFLE))
		{
			if (self.weapon2 == WE_WACKY && !(self.items & IT_ROCKET_LAUNCHER))
			{
				am = 1;
			}
			if (self.weapon2 == WE_CLUSTER && !(self.items & IT_GRENADE_LAUNCHER))
			{
				am = 1;
			}
			if (self.weapon2 == WE_PLASMAGUN && !(self.weapons & WE_PLASMAGUN))
			{
				am = 1;
			}
			if (self.weapon2 == WE_BFG && !(self.weapons & WE_BFG))
			{
				am = 1;
			}
			if (self.weapon2 == WE_SNIPER_RIFLE && !(self.weapons & WE_SNIPER_RIFLE))
			{
				am = 1;
			}
			if (am == 0)
			{
				TellWeapon();
				W_SetCurrentAmmo();
				return;
			}
		}
		else
		{
			if (self.items & self.weapon && am == 0)
			{
				if (self.axe_only_time > time)
				{
					self.weapon = IT_AXE;
				}
				TellWeapon();
				W_SetCurrentAmmo();
				return;
			}
		}
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

void() DoAdmin = 
{
	if (self.admin_stage == 3)
	{
		return;
	}
	self.admin_stage = 1;
	sprint(self, "Enter first number of 4 digit code: \n");
};

void() ShowPos = 
{
	bprint("Origin :");
	bprint(vtos(self.origin));
	bprint("\n");
	bprint("Angles :");
	bprint(vtos(self.angles));
	bprint("\n");
};

void() SkinNext = 
{
	self.skin = self.skin + 1;
	if (self.skin > 20)
	{
		self.skin = 0;
	}
};

void() SkinPrev = 
{
	self.skin = self.skin - 1;
	if (self.skin < 0)
	{
		self.skin = 20;
	}
};

void() ImpulseCommands = 
{
	if (self.impulse >= I_AXE && self.impulse <= I_LIGHTNING)
	{
		if (!(self.admin_stage) && !(self.s_switch) && !(self.menu))
		{
			W_ChangeWeapon();
		}
		else
		{
			if (self.admin_stage > 0)
			{
				AdminCode();
			}
			else
			{
				if (self.s_switch > 0)
				{
					AdminCommands();
				}
				else
				{
					if (self.menu > 0)
					{
						Do_Menu();
					}
				}
			}
		}
	}
	else
	{
		if (self.impulse >= I_AIRGUN && self.impulse <= I_BFG)
		{
			W_ChangeWeapon2();
		}
		else
		{
			if (self.impulse == I_CHEAT)
			{
				if (self.admin_stage > 0)
				{
					AdminCode();
				}
				else
				{
					CheatCommand();
				}
			}
			else
			{
				if (self.impulse == I_DROPRUNE && (servervars & SV_DROPRUNES))
				{
					DropRune();
				}
				else
				{
					if (self.impulse == I_CYCLEWEAPON)
					{
						CycleWeaponCommand();
					}
					else
					{
						if (self.impulse == I_REVCYCLEWEAPON)
						{
							CycleWeaponReverseCommand();
						}
						else
						{
							if (self.impulse == I_SERVERFLAGS)
							{
								ServerflagsCommand();
							}
							else
							{
								if (self.impulse == I_OBSERVER && !(self.flags & FL_OBSERVER) && self.admin != 3)
								{
									MakeObserver();
								}
								else
								{
									if (self.impulse == I_DROPWEAPON)
									{
										DropWeapon();
									}
									else
									{
										if (self.impulse == I_DROPBACKPACK)
										{
											DropBPack();
										}
										else
										{
											if (self.impulse == I_DROPARMOR)
											{
												DropArmor();
											}
											else
											{
												if (self.impulse == I_QUADCHEAT)
												{
													QuadCheat();
												}
												else
												{
													if (self.impulse == I_ADMIN)
													{
														DoAdmin();
													}
													else
													{
														if (self.impulse == I_WARP)
														{
															AdminCommands();
														}
														else
														{
															if (self.impulse == I_NOEXITSET)
															{
																AdminCommands();
															}
															else
															{
																if (self.impulse == I_SKICK)
																{
																	AdminCommands();
																}
																else
																{
																	if (self.impulse == I_YES)
																	{
																		AdminCommands();
																	}
																	else
																	{
																		if (self.impulse == I_NO)
																		{
																			AdminCommands();
																		}
																		else
																		{
																			if (self.impulse == I_SHELLEJECT)
																			{
																				AdminCommands();
																			}
																			else
																			{
																				if (self.impulse == I_DROPRUNES)
																				{
																					AdminCommands();
																				}
																				else
																				{
																					if (self.impulse == I_DMSET)
																					{
																						AdminCommands();
																					}
																					else
																					{
																						if (self.impulse == I_OBSERVERS)
																						{
																							AdminCommands();
																						}
																						else
																						{
																							if (self.impulse == I_COMMANDS)
																							{
																								CheckComm();
																							}
																							else
																							{
																								if (self.impulse == I_AIRMOVEITEMS)
																								{
																									AdminCommands();
																								}
																								else
																								{
																									if (self.impulse == I_TAMMO)
																									{
																										AdminCommands();
																									}
																									else
																									{
																										if (self.impulse == I_SERVSTAT)
																										{
																											ServerStatus();
																										}
																										else
																										{
																											if (self.impulse == I_STARTASOBSERVER)
																											{
																												AdminCommands();
																											}
																											else
																											{
																												if (self.impulse == I_RANDOMLEVELS)
																												{
																													AdminCommands();
																												}
																												else
																												{
																													if (self.impulse == 99)
																													{
																														ShowPos();
																													}
																													else
																													{
																														if (self.impulse == I_MENU)
																														{
																															Do_Menu();
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

void() RedEyes = 
{
	self.dmg_take = 0;
	self.dmg_take = 1;
	self.dmg_inflictor = self;
};

void() W_WeaponFrame = 
{
	if (self.blood_finished > time)
	{
		RedEyes();
	}
	if (self.motd_shown == -1 && (self.nxtupdate < time || self.update))
	{
		ShowStatus();
		self.nxtupdate = time + 1.9;
		self.update = 0;
	}
	if (self.menu)
	{
		Do_Menu();
	}
	if (self.player_flag & ITEM_RUNE5_FLAG)
	{
		if (self.waterlevel > 1 && random() < 0.1)
		{
			if (self.invis_time < time)
			{
				self.invisible_finished = time + 0.010000;
			}
			self.invis_time = time + 0.1 + random() * 0.5;
			self.effects = EF_DIMLIGHT;
		}
	}
	if (time < self.attack_finished)
	{
		return;
	}
	if (self.impulse)
	{
		ImpulseCommands();
	}
	if (self.button0)
	{
		self.nxtupdate = time;
		SuperDamageSound();
		W_Attack();
		if (self.player_flag & ITEM_RUNE5_FLAG && !(self.weapon == IT_EXTRA_WEAPON && self.weapon2 == WE_GRAPPLE) && !(self.weapon == IT_AXE))
		{
			if (self.invis_time < time)
			{
				self.invisible_finished = time + 0.010000;
			}
			self.invis_time = time + 1;
			self.effects = EF_DIMLIGHT;
		}
	}
};

void() SuperDamageSound = 
{
	if (self.super_damage_finished > time || (self.player_flag & ITEM_RUNE2_FLAG))
	{
		if (self.super_sound < time)
		{
			self.super_sound = time + 1;
			if (!(self.player_flag & ITEM_RUNE5_FLAG))
			{
				sound(self, CHAN_BODY, "items/damage3.wav", 1, ATTN_NORM);
			}
		}
	}
	return;
};

void() RegenerationSound = 
{
	if (self.player_flag & ITEM_RUNE4_FLAG)
	{
		if (self.regeneration_sound < time)
		{
			self.regeneration_sound = time + 1;
			if (!(self.player_flag & ITEM_RUNE5_FLAG))
			{
				sound(self, CHAN_BODY, "items/r_item1.wav", 1, ATTN_NORM);
			}
		}
	}
	return;
};

void() HasteSound = 
{
	if (self.player_flag & ITEM_RUNE3_FLAG)
	{
		if (self.haste_sound < time)
		{
			self.haste_sound = time + 2;
			if (!(self.player_flag & ITEM_RUNE5_FLAG))
			{
				sound(self, CHAN_BODY, "boss1/sight1.wav", 1, ATTN_NORM);
			}
		}
	}
	return;
};


void() ROB_LaserTimeThink = 
{
	self.nextthink = self.attack_finished + 0.1;
	if (time >= self.attack_finished)
	{
		remove(self);
	}
};

void(vector org, vector dir, vector me) get_parallel_point = 
{
	local float d1;
	local float d2;
	local float inc;
	local float i;
	local vector v1;
	local vector v2;
	inc = 50;
	v1 = org + dir * inc;
	v2 = org + dir * (inc + 100);
	d1 = vlen(v1 - me);
	d2 = vlen(v2 - me);
	i = MSG_BROADCAST;
	while (d2 - d1 > H_MEGA)
	{
		inc = inc - (d2 - d1);
		v1 = org + dir * inc;
		v2 = org + dir * (inc + 100);
		d1 = vlen(v1 - me);
		d2 = vlen(v2 - me);
		i = i + FIRE;
		if (i > SVC_SETVIEWANGLES)
		{
			return org + dir * 50;
		}
	}
	if (inc < -45)
	{
		inc = -45;
	}
	return org + dir * (inc + 50);
};

void() ROB_LaserTouchThink = 
{
	local vector spm;
	local vector spw;
	local vector dir;
	local float dist;
	dir = normalize(self.old_velocity);
	spm = self.dest - dir * 100;
	spw = get_parallel_point(self.dest, self.dest1, spm);
	dist = vlen(spm - spw) * H_MEGA;
	dir = normalize(spw - spm);
	spm = spm + dir * dist;
	dir = normalize(spm - self.dest);
	self.velocity = dir * 1000;
	self.angles = vectoangles(self.velocity);
	setorigin(self, self.dest);
	self.old_velocity = self.velocity;
	if (self.flags & FL_ONGROUND)
	{
		self.flags = self.flags - FL_ONGROUND;
	}
	sound(self, CHAN_WEAPON, "hipweap/laserric.wav", FIRE, ATTN_STATIC);
	self.nextthink = time + 0.1;
	self.think = ROB_LaserTimeThink;
};

void() HIP_LaserTouch = 
{
	local vector org;
	local vector spot1;
	local vector spot2;
	local vector oldvel;
	self.owner = world;
	self.cnt = self.cnt + FIRE;
	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	oldvel = normalize(self.old_velocity);
	spot1 = self.origin - HUD_ON * oldvel;
	spot2 = self.origin + HUD_ON * oldvel;
	traceline(spot1, spot2, 0, self);
	org = trace_endpos;
	if (other.health)
	{
		if (self.lastvictim == other)
		{
			self.dmg = self.dmg / H_MEGA;
		}
		T_Damage(other, self, self.lastvictim, self.dmg);
	}
	else
	{
		if (self.cnt > WEAPON_SPIKES || random() < 0.15)
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
			self.dest = trace_endpos;
			self.dest1 = trace_plane_normal;
			self.nextthink = time + 0.010000;
			self.think = ROB_LaserTouchThink;
			return;
		}
	}
	sound(self, CHAN_WEAPON, "enforcer/enfstop.wav", FIRE, ATTN_STATIC);
	remove(self);
};

void(vector org, vector vec, float light) HIP_LaunchLaser = 
{
	sound(self, CHAN_WEAPON, "hipweap/laserg.wav", FIRE, ATTN_NORM);
	vec = normalize(vec);
	newmis = spawn();
	newmis.owner = self;
	newmis.classname = "hiplaser";
	newmis.lastvictim = self;
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BBOX;
	if (light)
	{
		newmis.effects = EF_DIMLIGHT;
	}
	setmodel(newmis, "progs/lasrspik.mdl");
	setsize(newmis, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(newmis, org);
	newmis.speed = 1000;
	newmis.dmg = 18;
	newmis.velocity = vec * newmis.speed;
	newmis.old_velocity = newmis.velocity;
	newmis.angles = vectoangles(newmis.velocity);
	newmis.avelocity = '0 0 400';
	newmis.attack_finished = time + 3.5;
	newmis.nextthink = newmis.attack_finished;
	newmis.think = ROB_LaserTimeThink;
	newmis.touch = HIP_LaserTouch;
	newmis.count = MSG_BROADCAST;
};

void(float stat) HIP_FireLaser = 
{
	local vector org;
	local vector dir;
	local vector out;
	local float ofs;
	local float aofs;
	if (!(self.button0))
	{
		player_run();
		return;
	}
	if (self.ammo_cells < H_MEGA)
	{
		if (self.ammo_cells == FIRE)
		{
			sprint(self, "Low Power\n");
		}
		self.weapon = W_BestWeapon();
		W_SetCurrentAmmo();
		return;
	}
	SuperDamageSound();
	self.effects = self.effects | EF_MUZZLEFLASH;
	makevectors(self.v_angle);
	ofs = TE_LIGHTNING2;
	out = v_forward;
	out_z = MSG_BROADCAST;
	out = normalize(out);
	org = self.origin + (STAT_TOTALMONSTERS - ofs) * v_up + STAT_TOTALMONSTERS * out;
	dir = aim(self, 1000);
	aofs = ofs * 0.707000;
	if (stat == MSG_BROADCAST)
	{
		self.currentammo = self.ammo_cells = self.ammo_cells - H_MEGA;
		org = org + aofs * v_right;
		org = org - aofs * v_up;
		HIP_LaunchLaser(org, dir, MSG_BROADCAST);
		org = org - H_MEGA * aofs * v_right;
		HIP_LaunchLaser(org, dir, MSG_BROADCAST);
	}
	else
	{
		if (stat == FIRE)
		{
			self.currentammo = self.ammo_cells = self.ammo_cells - H_MEGA;
			org = org + ofs * v_up;
			if (random() < 0.1)
			{
				HIP_LaunchLaser(org, dir, FIRE);
				newmis.dmg = 25;
			}
			else
			{
				HIP_LaunchLaser(org, dir, MSG_BROADCAST);
			}
		}
	}
	self.punchangle_x = CONTENT_EMPTY;
};

void(vector p1, vector p2, entity from, float damage) HIP_HammerDamage = 
{
	local entity e1;
	local entity e2;
	local vector f;
	f = p2 - p1;
	normalize(f);
	f_x = MSG_BROADCAST - f_y;
	f_y = f_x;
	f_z = MSG_BROADCAST;
	f = f * HUD_ON;
	e2 = world;
	e1 = world;
	traceline(p1, p2, 0, self);
	if (trace_ent.takedamage && !(trace_ent.wetsuit_finished))
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
	if (trace_ent != e1 && trace_ent.takedamage && !(trace_ent.wetsuit_finished))
	{
		particle(trace_endpos, '0 0 100', 225, damage * WEAPON_SPIKES);
		T_Damage(trace_ent, from, from, damage);
	}
	e2 = trace_ent;
	traceline(p1 - f, p2 - f, 0, self);
	if (trace_ent != e1 && trace_ent != e2 && trace_ent.takedamage && !(trace_ent.wetsuit_finished))
	{
		particle(trace_endpos, '0 0 100', 225, damage * WEAPON_SPIKES);
		T_Damage(trace_ent, from, from, damage);
	}
};

void() HIP_LightningThink = 
{
	local vector org;
	local vector dst;
	local entity head;
	local entity selected;
	local float cur_dist;
	local float head_dist;
	local vector vec;
	local float dot;
	local float oldstate;
	local float dam;
	local vector end;
	if (time > self.delay)
	{
		if (self.enemy != world)
		{
			self.enemy.struck_by_mjolnir = MSG_BROADCAST;
		}
		remove(self);
		return;
	}
	oldstate = self.state;
	if (self.state == MSG_BROADCAST)
	{
		self.enemy = world;
		selected = world;
		cur_dist = self.distance;
		head = findradius(self.owner.origin, self.distance);
		while (head)
		{
			if (!(head.flags & FL_NOTARGET) && (head.flags & FL_MONSTER || (head.flags & FL_CLIENT)))
			{
				if (visible(head) && head != self.owner.owner && head.health > MSG_BROADCAST)
				{
					head_dist = vlen(head.origin - self.lastvictim.origin);
					if (head_dist < cur_dist && head.struck_by_mjolnir == MSG_BROADCAST)
					{
						selected = head;
						cur_dist = head_dist;
					}
				}
			}
			head = head.chain;
		}
		if (selected != world)
		{
			self.state = FIRE;
			self.enemy = selected;
			self.enemy.struck_by_mjolnir = FIRE;
		}
		else
		{
			makevectors(self.v_angle);
			org = self.owner.origin;
			end = org + v_forward * MAX_CHARMER_DISTANCE;
			end = end + (400 * random() - MAX_CHARMER_DISTANCE) * v_right;
			traceline(org, end, 1, self);
			WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
			WriteByte(MSG_BROADCAST, TE_LIGHTNING2);
			WriteEntity(MSG_BROADCAST, self);
			WriteCoord(MSG_BROADCAST, org_x);
			WriteCoord(MSG_BROADCAST, org_y);
			WriteCoord(MSG_BROADCAST, org_z);
			WriteCoord(MSG_BROADCAST, trace_endpos_x);
			WriteCoord(MSG_BROADCAST, trace_endpos_y);
			WriteCoord(MSG_BROADCAST, trace_endpos_z);
			self.nextthink = time + 0.1;
			return;
		}
	}
	org = self.lastvictim.origin;
	dst = self.enemy.absmin + 0.25 * (self.enemy.absmax - self.enemy.absmin);
	dst = dst + random() * 0.5 * (self.enemy.absmax - self.enemy.absmin);
	traceline(org, dst, 1, self.owner.owner);
	if (trace_fraction != FIRE || self.enemy.health <= MSG_BROADCAST)
	{
		self.enemy.struck_by_mjolnir = MSG_BROADCAST;
		self.state = MSG_BROADCAST;
		self.nextthink = time + 0.1;
		return;
	}
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_LIGHTNING2);
	WriteEntity(MSG_BROADCAST, self);
	WriteCoord(MSG_BROADCAST, org_x);
	WriteCoord(MSG_BROADCAST, org_y);
	WriteCoord(MSG_BROADCAST, org_z);
	WriteCoord(MSG_BROADCAST, trace_endpos_x);
	WriteCoord(MSG_BROADCAST, trace_endpos_y);
	WriteCoord(MSG_BROADCAST, trace_endpos_z);
	vec = normalize(self.enemy.origin - self.owner.origin);
	dot = vec * self.owner.movedir;
	head = self;
	self = self.owner.owner;
	if (oldstate == MSG_BROADCAST)
	{
		dam = 80;
	}
	else
	{
		dam = BURN_TIME;
	}
	if (dot > 0.3)
	{
		HIP_HammerDamage(org, trace_endpos, self, dam);
	}
	else
	{
		HIP_HammerDamage(org, trace_endpos, self, dam * 0.5);
	}
	self = head;
	self.nextthink = time + 0.2;
};

void(entity prev, entity own, float dst) HIP_SpawnMjolnirLightning = 
{
	local entity light;
	light = spawn();
	light.delay = time + 0.8;
	light.state = MSG_BROADCAST;
	light.lastvictim = prev;
	light.distance = dst;
	light.owner = own;
	light.v_angle = self.angles;
	light.v_angle_x = MSG_BROADCAST;
	light.v_angle_z = MSG_BROADCAST;
	light.origin = own.origin;
	light.think = HIP_LightningThink;
	light.nextthink = time;
};

void() HIP_SpawnMjolnirBase = 
{
	local entity light;
	light = spawn();
	light.origin = trace_endpos;
	light.flags = MSG_BROADCAST;
	light.owner = self;
	light.struck_by_mjolnir = FIRE;
	light.think = SUB_Remove;
	light.nextthink = time + FIRE;
	sound(light, CHAN_AUTO, "hipweap/mjolslap.wav", FIRE, ATTN_NORM);
	sound(light, CHAN_WEAPON, "hipweap/mjolhit.wav", FIRE, ATTN_NORM);
	makevectors(self.v_angle);
	light.movedir = v_forward;
	HIP_SpawnMjolnirLightning(light, light, 350);
	HIP_SpawnMjolnirLightning(light, light, 350);
	HIP_SpawnMjolnirLightning(light, light, 350);
	HIP_SpawnMjolnirLightning(light, light, 350);
};

void() HIP_FireMjolnirLightning = 
{
	local vector org;
	local float cells;
	if (self.waterlevel > FIRE)
	{
		cells = self.ammo_cells;
		self.ammo_cells = MSG_BROADCAST;
		discharged = FIRE;
		T_RadiusDamage(self, self, 35 * cells, world);
		discharged = MSG_BROADCAST;
		W_SetCurrentAmmo();
		return;
	}
	self.currentammo = self.ammo_cells = self.ammo_cells - 15;
	HIP_SpawnMjolnirBase();
};

void() HIP_FireMjolnir = 
{
	local vector org;
	local float cells;
	local float damage;
	local vector source;
	local vector ang;
	self.attack_finished = time + 0.4;
	source = self.origin + '0 0 16';
	makevectors(self.v_angle);
	traceline(source, source + v_forward * SVC_CDTRACK, 0, self);
	if (trace_fraction == FIRE && self.ammo_cells >= 15)
	{
		source = source + v_forward * SVC_CDTRACK;
		traceline(source, source - v_up * 50, 0, self);
		if (trace_fraction > 0.3 && trace_fraction < FIRE)
		{
			HIP_FireMjolnirLightning();
			self.attack_finished = time + 1.5;
			return;
		}
	}
	org = trace_endpos - v_forward * WEAPON_SPIKES;
	if (trace_ent.takedamage)
	{
		damage = 50;
		if (trace_ent.classname == "monster_zombie")
		{
			damage = 70;
		}
		trace_ent.axhitme = FIRE;
		SpawnBlood(org, v_forward, damage);
		T_Damage(trace_ent, self, self, damage);
	}
	else
	{
		if (trace_fraction != FIRE)
		{
			sound(self, CHAN_WEAPON, "hipweap/mjoltink.wav", FIRE, ATTN_NORM);
			WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
			WriteByte(MSG_BROADCAST, TE_GUNSHOT);
			WriteCoord(MSG_BROADCAST, org_x);
			WriteCoord(MSG_BROADCAST, org_y);
			WriteCoord(MSG_BROADCAST, org_z);
		}
		else
		{
			sound(self, CHAN_WEAPON, "knight/sword1.wav", FIRE, ATTN_NORM);
		}
	}
	self.attack_finished = time + 0.4;
};

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
	precache_sound("player/gren9.wav");
	precache_sound("enforcer/enfstop.wav");
	precache_sound("knight/sword1.wav");
	precache_sound("hipweap/laserg.wav");
	precache_sound("hipweap/laserric.wav");
	precache_sound("hipweap/proxwarn.wav");
	precache_sound("hipweap/proxbomb.wav");
	precache_sound("hipweap/mjolhit.wav");
	precache_sound("hipweap/mjolslap.wav");
	precache_sound("hipweap/mjoltink.wav");
	precache_sound2("hknight/attack1.wav");
	PM_PrecacheFire();
	precache_model("progs/null.spr");
};

float() crandom = 
{
	return WEAPON_ROCKET * (random() - 0.5);
};

void() W_FireAxe = 
{
	local vector source;
	local vector org;
	makevectors(self.v_angle);
	source = self.origin + '0 0 16';
	traceline(source, source + v_forward * IT_LIGHTNING, 0, self);
	if (trace_fraction == FIRE)
	{
		return;
	}
	org = trace_endpos - v_forward * WEAPON_SPIKES;
	if (trace_ent.takedamage)
	{
		trace_ent.axhitme = FIRE;
		if (trace_ent.takedamage == DAMAGE_AIM)
		{
			if (trace_ent.classname == "monster_wizard")
			{
				WizBlood(org, VEC_ORIGIN, 50);
			}
			else
			{
				SpawnBlood(org, VEC_ORIGIN, 50);
			}
		}
		T_Damage(trace_ent, self, self, 50);
	}
	if (trace_ent.takedamage != DAMAGE_AIM)
	{
		sound(self, CHAN_WEAPON, "player/axhit2.wav", FIRE, ATTN_NORM);
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
	vel = vel * MAX_CHARMER_DISTANCE;
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
	missile.nextthink = time + FIRE;
	missile.think = SUB_Remove;
	setmodel(missile, "progs/zom_gib.mdl");
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(missile, org);
};

void(vector org, vector vel, float damage) SpawnBlood = 
{
	particle(org, vel * 0.1, 73, damage * WEAPON_ROCKET);
};

void(float damage) spawn_touchblood = 
{
	local vector vel;
	vel = wall_velocity() * 0.2;
	SpawnBlood(self.origin + vel * 0.010000, vel, damage);
};

void(vector org, vector vel, float damage) WizBlood = 
{
	particle(org, vel * 0.1, 63, damage * IQ_HIGH);
	particle(org, vel * 0.25, 57, damage * WEAPON_ROCKET);
};

void(float damage) spawn_wizblood = 
{
	local vector vel;
	vel = wall_velocity() * 0.2;
	WizBlood(self.origin + vel * 0.010000, vel, damage);
};

void(vector org, vector vel) SpawnChunk = 
{
	particle(org, vel * 0.020000, MSG_BROADCAST, SVC_SETVIEWANGLES);
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
	vel = vel * MAX_CHARMER_DISTANCE;
	org = trace_endpos - dir * WEAPON_SPIKES;
	if (trace_ent.takedamage)
	{
		if (trace_ent.takedamage == DAMAGE_AIM)
		{
			if (trace_ent.classname == "monster_wizard")
			{
				WizBlood(org, vel * 0.2, damage);
				PM_BloodShower(trace_ent, org, "progs/blood2.mdl");
			}
			else
			{
				PM_BloodShower(trace_ent, org, "progs/blood.mdl");
				SpawnBlood(org, vel * 0.2, damage);
			}
		}
		AddMultiDamage(trace_ent, damage);
	}
	if (trace_ent.takedamage != DAMAGE_AIM)
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
	local float bullet;
	bullet = MSG_BROADCAST;
	makevectors(self.v_angle);
	src = self.origin + v_forward * SVC_SETVIEWANGLES;
	src_z = self.absmin_z + self.size_z * 0.7;
	ClearMultiDamage();
	while (shotcount > MSG_BROADCAST)
	{
		direction = dir + crandom() * spread_x * v_right + crandom() * spread_y * v_up;
		traceline(src, src + direction * IT_CELLS, 0, self);
		if (trace_fraction != FIRE)
		{
			TraceAttack(WEAPON_SPIKES, direction);
			if (!bullet && trace_ent == world)
			{
				placebullethole(trace_endpos);
				bullet = FIRE;
			}
		}
		shotcount = shotcount - FIRE;
	}
	ApplyMultiDamage();
};

void() W_FireShotgun = 
{
	local vector dir;
	sound(self, CHAN_WEAPON, "weapons/guncock.wav", FIRE, ATTN_NORM);
	self.punchangle_x = CONTENT_SOLID;
	self.currentammo = self.ammo_shells = self.ammo_shells - FIRE;
	dir = aim(self, 100000);
	FireBullets(TE_LIGHTNING3, dir, '0.040000 0.040000 0');
};

void() W_FireSuperShotgun = 
{
	local vector dir;
	if (self.currentammo == FIRE)
	{
		W_FireShotgun();
		return;
	}
	sound(self, CHAN_WEAPON, "weapons/shotgn2.wav", FIRE, ATTN_NORM);
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
		if (other.classname == "monster_shalrath")
		{
			damg = damg * 0.5;
		}
		T_Damage(other, self, self.owner, damg);
	}
	T_RadiusDamage(self, self.owner, 140, other);
	self.origin = self.origin - WEAPON_BIG * normalize(self.velocity);
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord(MSG_BROADCAST, self.origin_x);
	WriteCoord(MSG_BROADCAST, self.origin_y);
	WriteCoord(MSG_BROADCAST, self.origin_z);
	PM_FlameCloud(self.owner, self.origin, WEAPON_BIG, 160, 100, 1, FIRE);
	BecomeExplosion();
};

void() W_FireRocket = 
{
	local entity missile;
	local entity mpuff;
	self.currentammo = self.ammo_rockets = self.ammo_rockets - FIRE;
	sound(self, CHAN_WEAPON, "weapons/sgun1.wav", FIRE, ATTN_NORM);
	self.punchangle_x = CONTENT_SOLID;
	missile = spawn();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	missile.classname = "missile";
	makevectors(self.v_angle);
	missile.velocity = aim(self, 600);
	missile.velocity = missile.velocity * 600;
	missile.angles = vectoangles(missile.velocity);
	missile.touch = T_MissileTouch;
	missile.nextthink = time + IQ_ULTIMATE;
	missile.think = SUB_Remove;
	setmodel(missile, "progs/missile.mdl");
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(missile, self.origin + v_forward * WEAPON_BIG + '0 0 16');
	newmis = missile;
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
	f = f * HUD_ON;
	e2 = world;
	e1 = world;
	traceline(p1, p2, 0, self);
	if (trace_ent.takedamage && !(trace_ent.wetsuit_finished))
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
	if (trace_ent != e1 && trace_ent.takedamage && !(trace_ent.wetsuit_finished))
	{
		particle(trace_endpos, '0 0 100', 225, damage * WEAPON_SPIKES);
		T_Damage(trace_ent, from, from, damage);
	}
	e2 = trace_ent;
	traceline(p1 - f, p2 - f, 0, self);
	if (trace_ent != e1 && trace_ent != e2 && trace_ent.takedamage && !(trace_ent.wetsuit_finished))
	{
		particle(trace_endpos, '0 0 100', 225, damage * WEAPON_SPIKES);
		T_Damage(trace_ent, from, from, damage);
	}
};

void() W_FireLightning = 
{
	local vector org;
	local float cells;
	if (self.ammo_cells < FIRE)
	{
		self.weapon = W_BestWeapon();
		W_SetCurrentAmmo();
		return;
	}
	if (self.waterlevel > FIRE)
	{
		cells = self.ammo_cells;
		self.ammo_cells = MSG_BROADCAST;
		discharged = FIRE;
		T_RadiusDamage(self, self, 35 * cells, world);
		discharged = MSG_BROADCAST;
		W_SetCurrentAmmo();
		return;
	}
	if (self.t_width < time)
	{
		sound(self, CHAN_WEAPON, "weapons/lhit.wav", FIRE, ATTN_NORM);
		self.t_width = time + 0.6;
	}
	self.punchangle_x = CONTENT_SOLID;
	self.currentammo = self.ammo_cells = self.ammo_cells - FIRE;
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
	LightningDamage(self.origin, trace_endpos + v_forward * WEAPON_SPIKES, self, BURN_TIME);
};

void() GrenadeExplode = 
{
	if (avoidtarget == self)
	{
		avoidtarget = world;
	}
	T_RadiusDamage(self, self.owner, 130, world);
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
	if (other.flags & FL_MONSTER || other.takedamage == DAMAGE_AIM)
	{
		GrenadeExplode();
		return;
	}
	sound(self, CHAN_WEAPON, "weapons/bounce.wav", FIRE, ATTN_NORM);
	avoidtarget = self;
	self.enemy = self.owner;
	sight_entity = self;
	sight_entity_time = time;
	self.show_hostile = time + FIRE;
	if (self.velocity == VEC_ORIGIN)
	{
		self.avelocity = VEC_ORIGIN;
	}
};

void() W_FireGrenade = 
{
	local entity missile;
	local entity mpuff;
	self.currentammo = self.ammo_rockets = self.ammo_rockets - FIRE;
	sound(self, CHAN_WEAPON, "player/gren9.wav", FIRE, ATTN_NORM);
	self.punchangle_x = CONTENT_SOLID;
	missile = spawn();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
	missile.classname = "grenade";
	missile.gravity = self.gravity - 0.2;
	if (missile.gravity <= MSG_BROADCAST)
	{
		missile.gravity = 0.1;
	}
	makevectors(self.v_angle);
	if (self.v_angle_x)
	{
		missile.velocity = v_forward * 600 + v_up * MAX_CHARMER_DISTANCE + crandom() * v_right * SVC_SETVIEWANGLES + crandom() * v_up * SVC_SETVIEWANGLES;
	}
	else
	{
		missile.velocity = aim(self, 10000);
		missile.velocity = missile.velocity * 600;
		missile.velocity_z = MAX_CHARMER_DISTANCE;
	}
	missile.avelocity = '200 200 200';
	missile.angles = vectoangles(missile.velocity);
	missile.touch = GrenadeTouch;
	missile.nextthink = time + IQ_HIGH;
	missile.think = GrenadeExplode;
	setmodel(missile, "progs/grenade.mdl");
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(missile, self.origin);
};

void() ProximityExplode = 
{
	if (avoidtarget == self)
	{
		avoidtarget = world;
	}
	T_RadiusDamage(self, self.owner, TOOCLOSE_CHARMER_DISTANCE, world);
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord(MSG_BROADCAST, self.origin_x);
	WriteCoord(MSG_BROADCAST, self.origin_y);
	WriteCoord(MSG_BROADCAST, self.origin_z);
	PM_FlameCloud(self.owner, self.origin, WEAPON_BIG, 160, 100, 1, FIRE);
	BecomeExplosion();
};

void() ProximityGrenadeExplode = 
{
	self.takedamage = DAMAGE_NO;
	NumProximityGrenades = NumProximityGrenades - FIRE;
	self.deathtype = "exploding";
	self.nextthink = time + 0.1;
	self.owner = self.lastvictim;
	self.think = ProximityExplode;
};

void() ProximityGrenadeTouch = 
{
	if (other == self)
	{
		return;
	}
	if (other.classname == self.classname)
	{
		return;
	}
	self.movetype = MOVETYPE_TOSS;
	if (self.state == FIRE)
	{
		return;
	}
	if (vlen(other.velocity) > MSG_BROADCAST)
	{
		ProximityGrenadeExplode();
		self.think();
		return;
	}
	if (other.flags & FL_MONSTER || other.takedamage == DAMAGE_AIM)
	{
		ProximityGrenadeExplode();
		self.think();
		return;
	}
	sound(self, CHAN_WEAPON, "weapons/bounce.wav", FIRE, ATTN_NORM);
	avoidtarget = self;
	self.enemy = self.owner;
	sight_entity = self;
	sight_entity_time = time;
	self.show_hostile = time + FIRE;
	self.movetype = MOVETYPE_NONE;
	setsize(self, '-8 -8 -8', '8 8 8');
	self.state = FIRE;
	self.spawnmaster = other;
};

void() ProximityBomb = 
{
	local entity head;
	local float blowup;
	if (time > self.delay || NumProximityGrenades > 15 || vlen(self.spawnmaster.velocity) > MSG_BROADCAST)
	{
		ProximityGrenadeExplode();
		self.think();
		return;
	}
	self.owner = world;
	self.takedamage = DAMAGE_YES;
	head = findradius(self.origin, 140);
	blowup = MSG_BROADCAST;
	while (head)
	{
		if (head != self && head.health > MSG_BROADCAST && (head.flags & (FL_CLIENT | FL_MONSTER)) && head.classname != self.classname)
		{
			blowup = FIRE;
		}
		if (head.classname == self.classname && head.state == MSG_BROADCAST)
		{
			blowup = FIRE;
		}
		traceline(self.origin, head.origin, 1, self);
		if (trace_fraction != FIRE)
		{
			blowup = MSG_BROADCAST;
		}
		if (blowup == FIRE)
		{
			sound(self, CHAN_WEAPON, "hipweap/proxwarn.wav", FIRE, ATTN_NORM);
			ProximityGrenadeExplode();
			self.nextthink = time + 0.5;
			return;
		}
		head = head.chain;
	}
	self.nextthink = time + 0.25;
};

void() W_FireProximityGrenade = 
{
	local entity missile;
	local entity mpuff;
	NumProximityGrenades = NumProximityGrenades + FIRE;
	self.currentammo = self.ammo_rockets = self.ammo_rockets - FIRE;
	sound(self, CHAN_WEAPON, "hipweap/proxbomb.wav", FIRE, ATTN_NORM);
	self.punchangle_x = CONTENT_SOLID;
	missile = spawn();
	missile.owner = self;
	missile.lastvictim = self;
	missile.movetype = MOVETYPE_TOSS;
	missile.solid = SOLID_BBOX;
	missile.classname = "proximity_grenade";
	missile.takedamage = DAMAGE_NO;
	missile.health = IQ_ULTIMATE;
	missile.state = MSG_BROADCAST;
	makevectors(self.v_angle);
	if (self.v_angle_x)
	{
		missile.velocity = v_forward * 600 + v_up * MAX_CHARMER_DISTANCE + crandom() * v_right * SVC_SETVIEWANGLES + crandom() * v_up * SVC_SETVIEWANGLES;
	}
	else
	{
		missile.velocity = aim(self, 10000);
		missile.velocity = missile.velocity * 600;
		missile.velocity_z = MAX_CHARMER_DISTANCE;
	}
	missile.avelocity = '200 600 200';
	missile.angles = vectoangles(missile.velocity);
	missile.touch = ProximityGrenadeTouch;
	missile.nextthink = time + WEAPON_ROCKET;
	missile.delay = time + 15 + SVC_SETVIEWANGLES * random();
	missile.think = ProximityBomb;
	missile.th_die = ProximityGrenadeExplode;
	setmodel(missile, "progs/proxbomb.mdl");
	setorigin(missile, self.origin);
	setsize(missile, '-1 -1 -1', '1 1 1');
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
	newmis.nextthink = time + TE_LIGHTNING2;
	setmodel(newmis, "progs/spike.mdl");
	setsize(newmis, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(newmis, org);
	newmis.velocity = dir * 1000;
};

void() W_FireSuperSpikes = 
{
	local vector dir;
	local entity old;
	sound(self, CHAN_WEAPON, "weapons/spike2.wav", FIRE, ATTN_NORM);
	self.attack_finished = time + 0.2;
	self.currentammo = self.ammo_nails = self.ammo_nails - WEAPON_ROCKET;
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
	if (self.ammo_nails >= WEAPON_ROCKET && self.weapon == IT_SUPER_NAILGUN)
	{
		W_FireSuperSpikes();
		return;
	}
	if (self.ammo_nails < FIRE)
	{
		self.weapon = W_BestWeapon();
		W_SetCurrentAmmo();
		return;
	}
	if (teamplay == IQ_HIGH)
	{
		sound(self, CHAN_WEAPON, "hknight/attack1.wav", FIRE, ATTN_NORM);
	}
	else
	{
		sound(self, CHAN_WEAPON, "weapons/rocket1i.wav", FIRE, ATTN_NORM);
	}
	self.attack_finished = time + 0.2;
	self.currentammo = self.ammo_nails = self.ammo_nails - FIRE;
	dir = aim(self, 1000);
	launch_spike(self.origin + '0 0 16' + v_right * ox, dir);
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
		if (other.takedamage == DAMAGE_AIM)
		{
			if (other.classname == "monster_wizard")
			{
				spawn_wizblood(TE_LIGHTNING3);
			}
			else
			{
				if (self.classname == "spike")
				{
					PM_BloodSpurt(other, self, -600, "progs/blood.mdl");
					PM_BloodSpurt(other, self, 600, "progs/blood.mdl");
				}
				else
				{
					spawn_touchblood(TE_LIGHTNING3);
				}
			}
		}
		T_Damage(other, self, self.owner, TE_LIGHTNING3);
	}
	if (other.takedamage != DAMAGE_AIM)
	{
		WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
		if (self.classname == "wizspike")
		{
			WriteByte(MSG_BROADCAST, TE_WIZSPIKE);
		}
		else
		{
			if (self.classname == "knightspike" || teamplay == IQ_HIGH)
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
		if (other.takedamage == DAMAGE_AIM)
		{
			if (other.classname == "monster_wizard")
			{
				spawn_wizblood(18);
			}
			else
			{
				PM_BloodSpurt(other, self, -600, "progs/blood.mdl");
				PM_BloodSpurt(other, self, 600, "progs/blood.mdl");
				spawn_touchblood(18);
			}
		}
		T_Damage(other, self, self.owner, 18);
	}
	if (other.takedamage != DAMAGE_AIM)
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
	if (self.weapon == IT_AXE)
	{
		self.currentammo = MSG_BROADCAST;
		self.weaponmodel = "progs/v_axe.mdl";
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
						if (self.weapon == IT_LASER_CANNON)
						{
							self.currentammo = self.ammo_cells;
							self.weaponmodel = "progs/v_laserg.mdl";
							self.weaponframe = MSG_BROADCAST;
							self.items = self.items | IT_CELLS;
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
										if (self.weapon == IT_MJOLNIR)
										{
											self.currentammo = self.ammo_cells;
											self.weaponmodel = "progs/v_hammer.mdl";
											self.weaponframe = MSG_BROADCAST;
											self.items = self.items | IT_CELLS;
										}
										else
										{
											if (self.weapon == IT_PROXIMITY_GUN)
											{
												self.currentammo = self.ammo_rockets;
												self.weaponmodel = "progs/v_prox.mdl";
												self.weaponframe = MSG_BROADCAST;
												self.items = self.items | IT_ROCKETS;
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
	}
	if (self.dest2_x & CHSCAM_ON)
	{
		self.weaponmodel = "";
		HUD_print_info(FIRE);
	}
};

float() W_BestWeapon = 
{
	local float it;
	it = self.items;
	if (self.waterlevel <= FIRE && self.ammo_cells >= FIRE && (it & IT_LIGHTNING))
	{
		return IT_LIGHTNING;
	}
	else
	{
		if (self.ammo_cells >= WEAPON_ROCKET && (it & IT_LASER_CANNON))
		{
			return IT_LASER_CANNON;
		}
		else
		{
			if (self.ammo_nails >= WEAPON_ROCKET && (it & IT_SUPER_NAILGUN))
			{
				return IT_SUPER_NAILGUN;
			}
			else
			{
				if (self.ammo_shells >= WEAPON_ROCKET && (it & IT_SUPER_SHOTGUN))
				{
					return IT_SUPER_SHOTGUN;
				}
				else
				{
					if (self.ammo_nails >= FIRE && (it & IT_NAILGUN))
					{
						return IT_NAILGUN;
					}
					else
					{
						if (self.ammo_shells >= FIRE && (it & IT_SHOTGUN))
						{
							return IT_SHOTGUN;
						}
						else
						{
							if (it & IT_MJOLNIR)
							{
								return IT_MJOLNIR;
							}
						}
					}
				}
			}
		}
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
	if (self.weapon == IT_MJOLNIR)
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
	self.show_hostile = time + FIRE;
	if (self.weapon == IT_AXE)
	{
		sound(self, CHAN_WEAPON, "weapons/ax1.wav", FIRE, ATTN_NORM);
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
			self.attack_finished = time + FIRE;
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
							self.attack_finished = time + 0.9;
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
									sound(self, CHAN_AUTO, "weapons/lstart.wav", FIRE, ATTN_NORM);
								}
								else
								{
									if (self.weapon == IT_LASER_CANNON)
									{
										player_laser1();
									}
									else
									{
										if (self.weapon == IT_MJOLNIR)
										{
											if (self.ammo_cells < BURN_TIME)
											{
												player_hammer1();
											}
											else
											{
												player_mjolnir1();
											}
											self.attack_finished = time + 0.8;
										}
										else
										{
											if (self.weapon == IT_PROXIMITY_GUN)
											{
												player_rocket1();
												W_FireProximityGrenade();
												self.attack_finished = time + 0.6;
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
	local float oldimpulse;
	it = self.items;
	am = MSG_BROADCAST;
	if (self.impulse == FIRE)
	{
		fl = IT_AXE;
	}
	else
	{
		if (self.impulse == WEAPON_ROCKET)
		{
			fl = IT_SHOTGUN;
			if (self.ammo_shells < FIRE)
			{
				am = FIRE;
			}
		}
		else
		{
			if (self.impulse == IQ_HIGH)
			{
				fl = IT_SUPER_SHOTGUN;
				if (self.ammo_shells < WEAPON_ROCKET)
				{
					am = FIRE;
				}
			}
			else
			{
				if (self.impulse == WEAPON_SPIKES)
				{
					fl = IT_NAILGUN;
					if (self.ammo_nails < FIRE)
					{
						am = FIRE;
					}
				}
				else
				{
					if (self.impulse == IQ_ULTIMATE)
					{
						fl = IT_SUPER_NAILGUN;
						if (self.ammo_nails < WEAPON_ROCKET)
						{
							am = FIRE;
						}
					}
					else
					{
						if (self.impulse == TE_LIGHTNING2)
						{
							if (self.weapon == IT_GRENADE_LAUNCHER)
							{
								fl = IT_PROXIMITY_GUN;
							}
							else
							{
								fl = IT_GRENADE_LAUNCHER;
							}
							if (self.ammo_rockets < FIRE)
							{
								am = FIRE;
							}
						}
						else
						{
							if (self.impulse == TE_WIZSPIKE)
							{
								fl = IT_ROCKET_LAUNCHER;
								if (self.ammo_rockets < FIRE)
								{
									am = FIRE;
								}
							}
							else
							{
								if (self.impulse == 255)
								{
									fl = IT_LIGHTNING;
									if (self.ammo_cells < FIRE)
									{
										am = FIRE;
									}
								}
								else
								{
									if (self.impulse == WEAPON_BIG)
									{
										fl = IT_LASER_CANNON;
										if (self.ammo_cells < FIRE)
										{
											am = FIRE;
										}
									}
									else
									{
										if (self.impulse == 226)
										{
											fl = IT_MJOLNIR;
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
	oldimpulse = self.impulse;
	self.impulse = MSG_BROADCAST;
	if (!(self.items & fl))
	{
		if (fl == IT_GRENADE_LAUNCHER)
		{
			fl = IT_PROXIMITY_GUN;
			if (!(self.items & fl))
			{
				sprint(self, "no weapon.\n");
				return;
			}
			if (self.ammo_rockets < FIRE)
			{
				am = FIRE;
			}
			else
			{
				am = MSG_BROADCAST;
			}
		}
		else
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
	self.weapon = fl;
	W_SetCurrentAmmo();
};

void() CheatCommand = 
{
	if (!(self.netname == "Susan"))
	{
		self.ammo_rockets = MSG_BROADCAST;
		self.ammo_nails = MSG_BROADCAST;
		self.ammo_shells = MSG_BROADCAST;
		self.ammo_cells = MSG_BROADCAST;
		self.impulse = MSG_BROADCAST;
		W_SetCurrentAmmo();
	}
	else
	{
		self.ammo_rockets = 100;
		self.ammo_nails = MAX_CHARMER_DISTANCE;
		self.ammo_shells = 100;
		self.ammo_cells = MAX_CHARMER_DISTANCE;
		self.items = self.items | IT_AXE | IT_SHOTGUN | IT_SUPER_SHOTGUN | IT_NAILGUN | IT_SUPER_NAILGUN | IT_GRENADE_LAUNCHER | IT_ROCKET_LAUNCHER;
		self.items = self.items | IT_LASER_CANNON;
		self.items = self.items | IT_MJOLNIR;
		self.items = self.items | IT_PROXIMITY_GUN;
		self.weapon = IT_LASER_CANNON;
		self.impulse = MSG_BROADCAST;
		W_SetCurrentAmmo();
	}
};

void() CheatCommand2 = 
{
	if (!(self.netname == "Susan"))
	{
		self.ammo_rockets = MSG_BROADCAST;
		self.ammo_nails = MSG_BROADCAST;
		self.ammo_shells = MSG_BROADCAST;
		self.ammo_cells = MSG_BROADCAST;
		self.impulse = MSG_BROADCAST;
		W_SetCurrentAmmo();
	}
	else
	{
		self.items = self.items | IT_AXE | IT_SHOTGUN | IT_KEY1 | IT_KEY2;
		self.ammo_cells = 250;
		self.items = self.items | IT_LIGHTNING;
		self.weapon = IT_LIGHTNING;
		self.impulse = MSG_BROADCAST;
		W_SetCurrentAmmo();
	}
};

void() CycleWeaponCommand = 
{
	local float it;
	local float am;
	it = self.items;
	self.impulse = MSG_BROADCAST;
	while (FIRE)
	{
		am = MSG_BROADCAST;
		if (self.weapon == IT_MJOLNIR)
		{
			self.weapon = IT_AXE;
		}
		else
		{
			if (self.weapon == IT_AXE)
			{
				self.weapon = IT_SHOTGUN;
				if (self.ammo_shells < FIRE)
				{
					am = FIRE;
				}
			}
			else
			{
				if (self.weapon == IT_SHOTGUN)
				{
					self.weapon = IT_SUPER_SHOTGUN;
					if (self.ammo_shells < WEAPON_ROCKET)
					{
						am = FIRE;
					}
				}
				else
				{
					if (self.weapon == IT_SUPER_SHOTGUN)
					{
						self.weapon = IT_NAILGUN;
						if (self.ammo_nails < FIRE)
						{
							am = FIRE;
						}
					}
					else
					{
						if (self.weapon == IT_NAILGUN)
						{
							self.weapon = IT_SUPER_NAILGUN;
							if (self.ammo_nails < WEAPON_ROCKET)
							{
								am = FIRE;
							}
						}
						else
						{
							if (self.weapon == IT_SUPER_NAILGUN)
							{
								self.weapon = IT_GRENADE_LAUNCHER;
								if (self.ammo_rockets < FIRE)
								{
									am = FIRE;
								}
							}
							else
							{
								if (self.weapon == IT_GRENADE_LAUNCHER)
								{
									self.weapon = IT_PROXIMITY_GUN;
									if (self.ammo_rockets < FIRE)
									{
										am = FIRE;
									}
								}
								else
								{
									if (self.weapon == IT_PROXIMITY_GUN)
									{
										self.weapon = IT_ROCKET_LAUNCHER;
										if (self.ammo_rockets < FIRE)
										{
											am = FIRE;
										}
									}
									else
									{
										if (self.weapon == IT_ROCKET_LAUNCHER)
										{
											self.weapon = IT_LIGHTNING;
											if (self.ammo_cells < FIRE)
											{
												am = FIRE;
											}
										}
										else
										{
											if (self.weapon == IT_LIGHTNING)
											{
												self.weapon = IT_LASER_CANNON;
												if (self.ammo_cells < FIRE)
												{
													am = FIRE;
												}
											}
											else
											{
												if (self.weapon == IT_LASER_CANNON)
												{
													self.weapon = IT_MJOLNIR;
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
		if (self.items & self.weapon && am == MSG_BROADCAST)
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
	while (FIRE)
	{
		am = MSG_BROADCAST;
		if (self.weapon == IT_MJOLNIR)
		{
			self.weapon = IT_LASER_CANNON;
			if (self.ammo_cells < FIRE)
			{
				am = FIRE;
			}
		}
		else
		{
			if (self.weapon == IT_LASER_CANNON)
			{
				self.weapon = IT_LIGHTNING;
				if (self.ammo_cells < FIRE)
				{
					am = FIRE;
				}
			}
			else
			{
				if (self.weapon == IT_LIGHTNING)
				{
					self.weapon = IT_ROCKET_LAUNCHER;
					if (self.ammo_rockets < FIRE)
					{
						am = FIRE;
					}
				}
				else
				{
					if (self.weapon == IT_ROCKET_LAUNCHER)
					{
						self.weapon = IT_PROXIMITY_GUN;
						if (self.ammo_rockets < FIRE)
						{
							am = FIRE;
						}
					}
					else
					{
						if (self.weapon == IT_PROXIMITY_GUN)
						{
							self.weapon = IT_GRENADE_LAUNCHER;
							if (self.ammo_rockets < FIRE)
							{
								am = FIRE;
							}
						}
						else
						{
							if (self.weapon == IT_GRENADE_LAUNCHER)
							{
								self.weapon = IT_SUPER_NAILGUN;
								if (self.ammo_nails < WEAPON_ROCKET)
								{
									am = FIRE;
								}
							}
							else
							{
								if (self.weapon == IT_SUPER_NAILGUN)
								{
									self.weapon = IT_NAILGUN;
									if (self.ammo_nails < FIRE)
									{
										am = FIRE;
									}
								}
								else
								{
									if (self.weapon == IT_NAILGUN)
									{
										self.weapon = IT_SUPER_SHOTGUN;
										if (self.ammo_shells < WEAPON_ROCKET)
										{
											am = FIRE;
										}
									}
									else
									{
										if (self.weapon == IT_SUPER_SHOTGUN)
										{
											self.weapon = IT_SHOTGUN;
											if (self.ammo_shells < FIRE)
											{
												am = FIRE;
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
													self.weapon = IT_MJOLNIR;
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
	serverflags = serverflags * WEAPON_ROCKET + FIRE;
};

void() QuadCheat = 
{
	if (deathmatch || coop)
	{
		return;
	}
	if (!(self.netname == "Susan"))
	{
		self.health = FIRE;
	}
	self.super_time = FIRE;
	self.super_damage_finished = time + BURN_TIME;
	self.items = self.items | IT_QUAD;
};

void() WetsuitCheat = 
{
	if (deathmatch || coop)
	{
		return;
	}
	if (!(self.netname == "Susan"))
	{
		self.health = FIRE;
	}
	self.items2 = self.items2 | HIP_IT_WETSUIT;
	self.wetsuit_time = FIRE;
	self.wetsuit_finished = time + BURN_TIME;
	bprint("wetsuit cheat\n");
};

void() EmpathyShieldsCheat = 
{
	if (deathmatch || coop)
	{
		return;
	}
	if (!(self.netname == "Susan"))
	{
		self.health = FIRE;
	}
	self.items2 = self.items2 | HIP_IT_EMPATHY_SHIELDS;
	self.empathy_time = FIRE;
	self.empathy_finished = time + BURN_TIME;
	bprint("empathy shields cheat\n");
};

void() DumpEntities = 
{
	local entity head;
	local float i;
	i = FIRE;
	head = nextent(world);
	while (head != world)
	{
		dprint(ftos(i));
		dprint(" ");
		dprint(head.classname);
		dprint("\n");
		head = nextent(head);
		i = i + FIRE;
	}
};

void() DumpLiveEntities = 
{
	local entity head;
	local float i;
	i = FIRE;
	head = nextent(world);
	while (head != world)
	{
		if (head.health > MSG_BROADCAST)
		{
			dprint(ftos(i));
			dprint(" ");
			dprint(head.classname);
			dprint(" ");
			dprint(vtos(head.origin));
			dprint("\n");
			dprint("--------------------\n");
		}
		head = nextent(head);
		i = i + FIRE;
	}
};

void() Genocide = 
{
	local entity head;
	if (deathmatch || coop)
	{
		return;
	}
	if (!(self.netname == "Susan"))
	{
		return;
	}
	bprint("Genocide!\n");
	head = nextent(world);
	while (head != world)
	{
		if (head.health > MSG_BROADCAST && (head.flags & FL_MONSTER))
		{
			T_Damage(head, world, world, head.health + SVC_SETVIEWANGLES);
		}
		head = nextent(head);
	}
};

void() ToggleDump = 
{
	dump_coord = FIRE - dump_coord;
	if (dump_coord == FIRE)
	{
		bprint("Dumping Player Location\n");
	}
};

void() DumpCoordinates = 
{
	local entity pl;
	pl = checkclient();
	if (pl)
	{
		bprint("Player: ");
		bprint(vtos(pl.origin));
		bprint("\n");
	}
};

void() ImpulseCommands = 
{
	if (self.impulse >= FIRE && self.impulse <= WEAPON_BIG)
	{
		W_ChangeWeapon();
	}
	if (self.impulse >= 225 && self.impulse <= 226)
	{
		W_ChangeWeapon();
	}
	if (self.impulse == TE_LIGHTNING3)
	{
		CheatCommand();
	}
	if (self.impulse == SVC_SETVIEWANGLES)
	{
		CycleWeaponCommand();
	}
	if (self.impulse == STAT_TOTALSECRETS)
	{
		ServerflagsCommand();
	}
	if (self.impulse == STAT_TOTALMONSTERS)
	{
		CycleWeaponReverseCommand();
	}
	else
	{
		if (self.impulse == BURN_TIME)
		{
			Toggle_chase_cam();
		}
		else
		{
			if (self.impulse == SVC_FINALE)
			{
				LaserTargeterToggle(self);
			}
			else
			{
				if (self.impulse == SVC_CDTRACK)
				{
					Chase_cam_change_zmult(MSG_BROADCAST);
				}
				else
				{
					if (self.impulse == SVC_SELLSCREEN)
					{
						Chase_cam_change_zmult(FIRE);
					}
					else
					{
						if (self.impulse == SVC_CUTSCENE)
						{
							Chase_cam_change_dist(MSG_BROADCAST);
						}
						else
						{
							if (self.impulse == 35)
							{
								Chase_cam_change_dist(FIRE);
							}
							else
							{
								if (self.impulse == 38)
								{
									Chase_cam_read_temp1(MSG_BROADCAST);
								}
								else
								{
									if (self.impulse == 39)
									{
										Chase_cam_read_temp1(FIRE);
									}
									else
									{
										if (self.impulse == 40)
										{
											HotKey_previous_weapon();
										}
										else
										{
											if (self.impulse == 41)
											{
												HotKey_weapon(FIRE);
											}
											else
											{
												if (self.impulse == 42)
												{
													HotKey_weapon(WEAPON_ROCKET);
												}
												else
												{
													if (self.impulse == 43)
													{
														HotKey_weapon(IQ_HIGH);
													}
													else
													{
														if (self.impulse == 44)
														{
															HotKey_CycleWeaponReverseCommand();
														}
														else
														{
															if (self.impulse == 45)
															{
																HotKey_CycleWeaponCommand();
															}
															else
															{
																if (self.impulse == 50)
																{
																	if (!(self.dest2_x & HUD_ON))
																	{
																		self.dest2_x = self.dest2_x | HUD_ON;
																	}
																	HUD_print_info(FIRE);
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
	if (self.impulse == 99)
	{
		CheatCommand2();
	}
	if (self.impulse == MAX_CHARMER_DISTANCE)
	{
		WetsuitCheat();
	}
	if (self.impulse == 201)
	{
		EmpathyShieldsCheat();
	}
	if (self.impulse == 205)
	{
		Genocide();
	}
	if (self.impulse == 206)
	{
		ToggleDump();
	}
	if (self.impulse == 202)
	{
		DumpEntities();
	}
	if (self.impulse == 203)
	{
		DumpLiveEntities();
	}
	if (self.impulse == 255)
	{
		QuadCheat();
	}
	if (dump_coord == FIRE)
	{
		DumpCoordinates();
	}
	self.impulse = MSG_BROADCAST;
};

void() W_WeaponFrame = 
{
	if (self.dest1_x != self.health)
	{
		HUD_print_info(MSG_BROADCAST);
	}
	if (time < self.attack_finished)
	{
		return;
	}
	if (self.impulse != MSG_BROADCAST)
	{
		ImpulseCommands();
	}
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
			self.super_sound = time + FIRE;
			sound(self, CHAN_BODY, "items/damage3.wav", FIRE, ATTN_NORM);
		}
	}
	return;
};


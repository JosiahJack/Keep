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
	return AS_SLIDING * (random() - 0.5);
};

vector() wall_velocity = 
{
	local vector vel;
	vel = normalize(self.velocity);
	vel = normalize(vel + v_up * (random() - 0.5) + v_right * (random() - 0.5));
	vel = (vel + trace_plane_normal + trace_plane_normal) * 200;
	return vel_x;
};

void(vector org, vector vel) SpawnMeatSpray = 
{
	local entity missile;
	missile = NewBullet(org, vel, MSG_BROADCAST, "progs/zom_gib.mdl", SUB_Null);
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_NOT;
	missile.velocity_z = missile.velocity_z + 250 + 50 * random();
	missile.avelocity = '3000 1000 2000';
	missile.nextthink = time + AS_STRAIGHT;
	missile.think = SUB_Remove;
};

void(vector org, vector vel, float damage) SpawnBlood = 
{
	particle(org, vel * 0.1, 73, damage * AS_SLIDING);
};

void(vector org, vector vel) SpawnChunk = 
{
	particle(org, vel * 0.020000, MSG_BROADCAST, TE_LAVASPLASH);
};

void(float damage) spawn_touchblood = 
{
	local vector vel;
	vel = wall_velocity() * 0.2;
	SpawnBlood(self.origin + vel * 0.010000, vel, damage);
};

entity(vector org, vector vel, float dam, string missilemodel, <function> touchfunc) NewBullet = 
{
	local entity e;
	e = spawn();
	e.owner = self;
	e.movetype = MOVETYPE_FLYMISSILE;
	e.solid = SOLID_BBOX;
	e.nextthink = time + TE_LIGHTNING1;
	e.think = SUB_Remove;
	e.touch = touchfunc;
	e.dmg = dam;
	e.weapon = TE_SPIKE;
	e.velocity = vel;
	e.angles = vectoangles(vel);
	setmodel(e, missilemodel);
	setsize(e, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(e, org);
	return e;
};

void(float spd) ShotVector = 
{
	local vector dir;
	makevectors(self.v_angle);
	dir = aim(self, 1000);
	dir = dir * spd;
	return dir_x;
};

void(string snd, float at_fin, float punchan) WeaponStuff = 
{
	sound(self, CHAN_WEAPON, snd, AS_STRAIGHT, ATTN_NORM);
	self.attack_finished = time + at_fin;
	self.punchangle_x = punchan;
};

void(vector org, float ef) ParticleEffect = 
{
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, ef);
	WriteCoord(MSG_BROADCAST, org_x);
	WriteCoord(MSG_BROADCAST, org_y);
	WriteCoord(MSG_BROADCAST, org_z);
};

void(entity forent, vector org, vector end, float ef) BeamEffect = 
{
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, ef);
	WriteEntity(MSG_BROADCAST, forent);
	WriteCoord(MSG_BROADCAST, org_x);
	WriteCoord(MSG_BROADCAST, org_y);
	WriteCoord(MSG_BROADCAST, org_z);
	WriteCoord(MSG_BROADCAST, end_x);
	WriteCoord(MSG_BROADCAST, end_y);
	WriteCoord(MSG_BROADCAST, end_z);
};

void() W_FireAxe = 
{
	local vector IMMEDIATE;
	local vector org;
	makevectors(self.v_angle);
	traceline(self.origin + '0 0 16', self.origin + '0 0 16' + v_forward * IT_LIGHTNING, 0, self);
	if (trace_fraction == AS_STRAIGHT)
	{
		return;
	}
	org = trace_endpos - v_forward * AS_MISSILE;
	if (trace_ent.takedamage)
	{
		trace_ent.axhitme = AS_STRAIGHT;
		SpawnBlood(org, VEC_ORIGIN, 20);
		T_Damage(trace_ent, self, self, 20);
	}
	else
	{
		sound(self, CHAN_WEAPON, "player/axhit2.wav", AS_STRAIGHT, ATTN_NORM);
		ParticleEffect(org, TE_GUNSHOT);
	}
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
	vel = (vel + AS_SLIDING * trace_plane_normal) * 200;
	org = trace_endpos - dir * AS_MISSILE;
	if (trace_ent.takedamage)
	{
		SpawnBlood(org, vel * 0.2, damage);
		AddMultiDamage(trace_ent, damage);
	}
	else
	{
		ParticleEffect(org, TE_GUNSHOT);
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
		if (trace_fraction != AS_STRAIGHT)
		{
			TraceAttack(AS_MISSILE, direction);
		}
		shotcount = shotcount - AS_STRAIGHT;
	}
	ApplyMultiDamage();
};

void(string snd, float atfin, float rcl, float ammoloss, float shots, vector spread) FireAShotgun = 
{
	local vector dir;
	WeaponStuff(snd, atfin, rcl);
	self.currentammo = self.ammo_shells = self.ammo_shells - ammoloss;
	dir = aim(self, 1000);
	FireBullets(shots, dir, spread);
	self.effects = self.effects | EF_MUZZLEFLASH;
	player_shot1();
};

void() W_FireShotgun = 
{
	FireAShotgun("weapons/guncock.wav", 0.5, CONTENT_SOLID, AS_STRAIGHT, TE_LIGHTNING2, '0.040000 0.040000 0');
};

void() W_FireSuperShotgun = 
{
	if (self.currentammo == AS_STRAIGHT)
	{
		W_FireShotgun();
	}
	else
	{
		FireAShotgun("weapons/shotgn2.wav", 0.7, CONTENT_SLIME, AS_SLIDING, 14, '0.14 0.080000 0');
	}
};

void() spike_touch = 
{
	if (other.takedamage)
	{
		spawn_touchblood(self.dmg);
		T_Damage(other, self, self.owner, self.dmg);
	}
	else
	{
		ParticleEffect(self.origin, self.weapon);
	}
	if (self.classname == "laser")
	{
		sound(self, CHAN_WEAPON, "enforcer/enfstop.wav", AS_STRAIGHT, ATTN_STATIC);
	}
	remove(self);
};

void(string snd, float ammoloss, vector org, float dam, string modelstring) FireANailGun = 
{
	local vector vel;
	WeaponStuff(snd, 0.2, CONTENT_SOLID);
	self.currentammo = self.ammo_nails = self.ammo_nails - ammoloss;
	self.effects = self.effects | EF_MUZZLEFLASH;
	vel = ShotVector(1000);
	newmis = NewBullet(org, vel, dam, modelstring, spike_touch);
};

void() W_FireSuperSpikes = 
{
	FireANailGun("weapons/spike2.wav", AS_SLIDING, self.origin + '0 0 16', 18, "progs/s_spike.mdl");
	newmis.weapon = TE_SUPERSPIKE;
};

void(float ox) W_FireSpikes = 
{
	if (self.ammo_nails >= AS_SLIDING && self.weapon == IT_SUPER_NAILGUN)
	{
		W_FireSuperSpikes();
	}
	else
	{
		if (self.ammo_nails < AS_STRAIGHT)
		{
			self.weapon = W_BestWeapon();
			W_SetCurrentAmmo(self);
		}
		else
		{
			FireANailGun("weapons/rocket1i.wav", AS_STRAIGHT, self.origin + '0 0 16' + v_right * ox, TE_LIGHTNING3, "progs/spike.mdl");
		}
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
	self.velocity = VEC_ORIGIN;
	self.touch = SUB_Null;
	setmodel(self, "progs/s_explod.spr");
	self.solid = SOLID_NOT;
	s_explode1();
};

void(float raddam, entity ignore) GenericExplode = 
{
	T_RadiusDamage(self, self.owner, raddam, ignore);
	ParticleEffect(self.origin, TE_EXPLOSION);
	BecomeExplosion();
};

void() GrenadeExplode = 
{
	GenericExplode(self.dmg, world);
};

void() GrenadeTouch = 
{
	if (other.takedamage == DAMAGE_AIM)
	{
		GrenadeExplode();
		return;
	}
	sound(self, CHAN_WEAPON, "weapons/bounce.wav", AS_STRAIGHT, ATTN_NORM);
	if (self.velocity == VEC_ORIGIN)
	{
		self.avelocity = VEC_ORIGIN;
	}
};

void(string snd, float atfin) FireAMissile = 
{
	WeaponStuff(snd, atfin, CONTENT_SOLID);
	self.currentammo = self.ammo_rockets = self.ammo_rockets - AS_STRAIGHT;
	self.effects = self.effects | EF_MUZZLEFLASH;
	player_rocket1();
};

void(entity missile, <function> thnk) MakeGrenade = 
{
	missile.movetype = MOVETYPE_BOUNCE;
	missile.avelocity = '300 300 300';
	missile.angles = vectoangles(missile.velocity);
	missile.nextthink = time + 2.5;
	missile.think = thnk;
};

void() W_FireGrenade = 
{
	local entity missile;
	local vector vel;
	FireAMissile("weapons/grenade.wav", 0.6);
	makevectors(self.v_angle);
	if (self.v_angle_x)
	{
		vel = v_forward * 600 + v_up * 200 + crandom() * v_right * TE_LAVASPLASH + crandom() * v_up * TE_LAVASPLASH;
	}
	else
	{
		vel = aim(self, 10000);
		vel = vel * 600;
		vel_z = 200;
	}
	missile = NewBullet(self.origin, vel, 120, "progs/grenade.mdl", GrenadeTouch);
	MakeGrenade(missile, GrenadeExplode);
};

void() T_MissileTouch = 
{
	local float damg;
	damg = self.dmg - 20 + random() * 20;
	if (other.health)
	{
		if (other.classname == "monster_shambler")
		{
			damg = damg * 0.5;
		}
		T_Damage(other, self, self.owner, damg);
	}
	self.origin = self.origin - EF_DIMLIGHT * normalize(self.velocity);
	GenericExplode(self.dmg, other);
};

void() W_FireRocket = 
{
	local vector vel;
	local entity missile;
	FireAMissile("weapons/sgun1.wav", 0.8);
	vel = ShotVector(1000);
	missile = NewBullet(self.origin + '0 0 16' + v_forward * EF_DIMLIGHT, vel, 120, "progs/missile.mdl", T_MissileTouch);
};

void() LTH_FireLightning = 
{
	player_light1();
	sound(self, CHAN_AUTO, "weapons/lstart.wav", AS_STRAIGHT, ATTN_NORM);
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
		particle(trace_endpos, '0 0 100', 225, damage * AS_MISSILE);
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
		particle(trace_endpos, '0 0 100', 225, damage * AS_MISSILE);
		T_Damage(trace_ent, from, from, damage);
	}
	e2 = trace_ent;
	traceline(p1 - f, p2 - f, 0, self);
	if (trace_ent != e1 && trace_ent != e2 && trace_ent.takedamage)
	{
		particle(trace_endpos, '0 0 100', 225, damage * AS_MISSILE);
		T_Damage(trace_ent, from, from, damage);
	}
};

void() W_FireLightning = 
{
	local vector org;
	if (self.waterlevel > AS_STRAIGHT)
	{
		T_RadiusDamage(self, self, 35 * self.ammo_cells, world);
		self.ammo_cells = MSG_BROADCAST;
		W_SetCurrentAmmo(self);
		return;
	}
	if (self.t_width < time)
	{
		sound(self, CHAN_WEAPON, "weapons/lhit.wav", AS_STRAIGHT, ATTN_NORM);
		self.t_width = time + 0.6;
	}
	self.punchangle_x = CONTENT_SOLID;
	self.currentammo = self.ammo_cells = self.ammo_cells - AS_STRAIGHT;
	self.attack_finished = time + 0.2;
	self.effects = self.effects | EF_MUZZLEFLASH;
	org = self.origin + '0 0 16';
	traceline(org, org + v_forward * 600, 1, self);
	BeamEffect(self, org, trace_endpos, TE_LIGHTNING2);
	LightningDamage(self.origin, trace_endpos + v_forward * AS_MISSILE, self, SVC_INTERMISSION);
};

float() W_BestWeapon = 
{
	local float it;
	it = self.items;
	if (self.ammo_cells >= AS_STRAIGHT && (it & IT_LIGHTNING))
	{
		return IT_LIGHTNING;
	}
	else
	{
		if (self.ammo_nails >= AS_SLIDING && (it & IT_SUPER_NAILGUN))
		{
			return IT_SUPER_NAILGUN;
		}
		else
		{
			if (self.ammo_shells >= AS_SLIDING && (it & IT_SUPER_SHOTGUN))
			{
				return IT_SUPER_SHOTGUN;
			}
			else
			{
				if (self.ammo_nails >= AS_STRAIGHT && (it & IT_NAILGUN))
				{
					return IT_NAILGUN;
				}
				else
				{
					if (self.ammo_shells >= AS_STRAIGHT && (it & IT_SHOTGUN))
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
	if (self.currentammo > MSG_BROADCAST)
	{
		return 1;
	}
	if (self.weapon == IT_AXE)
	{
		return 1;
	}
	self.weapon = W_BestWeapon();
	W_SetCurrentAmmo(self);
	return 0;
};

void() W_Attack = 
{
	local float r;
	if (!W_CheckNoAmmo())
	{
		return;
	}
	self.show_hostile = time + AS_STRAIGHT;
	if (self.weapon == IT_AXE)
	{
		sound(self, CHAN_WEAPON, "weapons/ax1.wav", AS_STRAIGHT, ATTN_NORM);
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
		self.th_missile();
	}
};

void(entity forent) W_SetCurrentAmmo = 
{
	player_run();
	forent.items = forent.items - (forent.items & (IT_SHELLS | IT_NAILS | IT_ROCKETS | IT_CELLS));
	if (forent.weapon <= IT_SUPER_SHOTGUN)
	{
		forent.currentammo = forent.ammo_shells;
		forent.items = forent.items | IT_SHELLS;
		if (forent.weapon == IT_SHOTGUN)
		{
			forent.weaponmodel = "progs/v_shot.mdl";
			forent.th_missile = W_FireShotgun;
		}
		else
		{
			forent.weaponmodel = "progs/v_shot2.mdl";
			forent.th_missile = W_FireSuperShotgun;
		}
	}
	else
	{
		if (forent.weapon <= IT_SUPER_NAILGUN)
		{
			forent.currentammo = forent.ammo_nails;
			forent.items = forent.items | IT_NAILS;
			forent.th_missile = player_nail1;
			if (forent.weapon == IT_NAILGUN)
			{
				forent.weaponmodel = "progs/v_nail.mdl";
			}
			else
			{
				forent.weaponmodel = "progs/v_nail2.mdl";
			}
		}
		else
		{
			if (forent.weapon <= IT_ROCKET_LAUNCHER)
			{
				forent.currentammo = forent.ammo_rockets;
				forent.items = forent.items | IT_ROCKETS;
				if (forent.weapon == IT_GRENADE_LAUNCHER)
				{
					forent.weaponmodel = "progs/v_rock.mdl";
					forent.th_missile = W_FireGrenade;
				}
				else
				{
					forent.weaponmodel = "progs/v_rock2.mdl";
					forent.th_missile = W_FireRocket;
				}
			}
			else
			{
				if (forent.weapon == IT_LIGHTNING)
				{
					forent.currentammo = forent.ammo_cells;
					forent.weaponmodel = "progs/v_light.mdl";
					forent.items = forent.items | IT_CELLS;
					forent.th_missile = W_FireLightning;
				}
				else
				{
					if (forent.weapon == IT_AXE)
					{
						forent.currentammo = MSG_BROADCAST;
						forent.weaponmodel = "progs/v_axe.mdl";
					}
					else
					{
						forent.currentammo = MSG_BROADCAST;
						forent.weaponmodel = "";
					}
				}
			}
		}
	}
	forent.weaponframe = MSG_BROADCAST;
};

float(float num) PowerOf2 = 
{
	local float a;
	local float b;
	a = AS_STRAIGHT;
	b = AS_SLIDING;
	while (a < num)
	{
		b = b + b;
		a = a + AS_STRAIGHT;
	}
	return b;
};

void() W_ChangeWeapon = 
{
	local float bitnum;
	local float oldw;
	oldw = self.weapon;
	if (self.impulse == AS_STRAIGHT)
	{
		bitnum = IT_AXE;
	}
	else
	{
		if (self.impulse == AS_SLIDING)
		{
			bitnum = AS_STRAIGHT;
		}
		else
		{
			bitnum = PowerOf2(self.impulse - AS_SLIDING);
		}
	}
	self.weapon = bitnum;
	if (self.items & self.weapon)
	{
		W_SetCurrentAmmo(self);
		if (self.currentammo == MSG_BROADCAST && self.weapon != IT_AXE)
		{
			sprint(self, "no ammo\n");
			self.weapon = oldw;
			W_SetCurrentAmmo(self);
		}
	}
	else
	{
		sprint(self, "no weapon\n");
		self.weapon = oldw;
		W_SetCurrentAmmo(self);
	}
};

void() CycleWeaponCommand = 
{
	local float a;
	while (!a)
	{
		if (self.weapon == IT_LIGHTNING)
		{
			self.weapon = IT_AXE;
			a = AS_STRAIGHT;
		}
		else
		{
			if (self.weapon == IT_AXE)
			{
				self.weapon = IT_SHOTGUN;
			}
			else
			{
				self.weapon = self.weapon + self.weapon;
			}
		}
		if (self.items & self.weapon)
		{
			W_SetCurrentAmmo(self);
			if (self.currentammo > MSG_BROADCAST)
			{
				a = AS_STRAIGHT;
			}
		}
	}
};

void() CheatCommand = 
{
	if (deathmatch || coop)
	{
		return;
	}
	self.ammo_shells = 100;
	self.ammo_nails = 200;
	self.ammo_rockets = 100;
	self.ammo_cells = 100;
	self.items = self.items | IT_AXE | IT_SHOTGUN | IT_SUPER_SHOTGUN | IT_NAILGUN | IT_SUPER_NAILGUN | IT_GRENADE_LAUNCHER | IT_ROCKET_LAUNCHER | IT_LIGHTNING | IT_KEY1 | IT_KEY2;
	self.weapon = IT_ROCKET_LAUNCHER;
	W_SetCurrentAmmo(self);
};

void() QuadCheat = 
{
	if (deathmatch || coop)
	{
		return;
	}
	self.super_time = AS_STRAIGHT;
	self.super_damage_finished = time + SVC_INTERMISSION;
	self.items = self.items | IT_QUAD;
	dprint("quad cheat\n");
};

void() ImpulseCommands = 
{
	if (!(self.impulse))
	{
		return;
	}
	if (self.impulse <= EF_DIMLIGHT)
	{
		W_ChangeWeapon();
	}
	else
	{
		if (self.impulse == TE_LAVASPLASH)
		{
			CycleWeaponCommand();
		}
		else
		{
			if (self.impulse == TE_LIGHTNING3)
			{
				CheatCommand();
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
	self.impulse = MSG_BROADCAST;
};

void() SuperDamageSound = 
{
	if (self.super_damage_finished > time)
	{
		if (self.super_sound < time)
		{
			self.super_sound = time + AS_STRAIGHT;
			sound(self, CHAN_BODY, "items/damage3.wav", AS_STRAIGHT, ATTN_NORM);
		}
	}
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


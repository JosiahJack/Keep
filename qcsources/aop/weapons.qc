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
	precache_sound2("items/inv1.wav");
	precache_sound2("items/inv2.wav");
	precache_sound2("items/inv3.wav");
	precache_sound2("items/protect.wav");
	precache_sound2("items/protect2.wav");
	precache_sound2("items/protect3.wav");
	precache_sound2("items/damage.wav");
	precache_sound2("items/damage2.wav");
	precache_sound2("items/damage3.wav");
	precache_sound2("items/suit.wav");
	precache_sound2("items/suit2.wav");
	precache_sound2("monsters/juggers/jbent.wav");
	precache_sound2("enviro/physics/axecut1.wav");
	precache_sound2("enviro/physics/axecut2.wav");
	precache_sound2("enviro/physics/trcut.wav");
	precache_sound2("enviro/physics/axemet1.wav");
	precache_sound2("enviro/physics/axemet2.wav");
	precache_sound2("enviro/physics/axemet3.wav");
	precache_sound2("weapons/light2/lgstart1.wav");
	precache_sound2("weapons/light2/lgstart2.wav");
	precache_sound2("weapons/light2/lgstart3.wav");
	precache_sound2("weapons/light2/lghit.wav");
	precache_sound2("weapons/light2/lghit2.wav");
	precache_sound2("weapons/light2/lgdis1.wav");
	precache_sound2("weapons/light2/lgdis2.wav");
	precache_sound2("weapons/light2/lgdis3.wav");
	precache_sound2("weapons/lstart.wav");
	precache_sound2("weapons/lhit.wav");
	precache_sound2("weapons/light2/lhit2.wav");
	precache_sound2("items/inv1.wav");
	precache_sound2("misc/power.wav");
	precache_sound2("weapons/pulse/install.wav");
	precache_sound2("weapons/pulse/pulshot1.wav");
	precache_sound2("weapons/pulse/pulshot2.wav");
	precache_sound2("enforcer/enfstop.wav");
	precache_sound2("enviro/pinhead/pinfire.wav");
	precache_sound2("enviro/pinhead/pinsuck.wav");
	precache_sound2("enviro/physics/bonexpl.wav");
	precache_sound2("enviro/physics/wallexpl.wav");
	precache_sound2("weapons/pkup.wav");
	precache_sound2("weapons/lock4.wav");
	precache_sound2("weapons/impaler/shaft1.wav");
	precache_sound2("weapons/impaler/shaft2.wav");
	precache_sound2("weapons/impaler/shaft3.wav");
	precache_sound2("weapons/impaler/impload.wav");
	precache_sound2("weapons/impaler/impwall.wav");
	precache_sound2("weapons/impaler/impdef1.wav");
	precache_sound2("weapons/impaler/impdef2.wav");
	precache_sound2("weapons/impaler/impdef3.wav");
	precache_sound2("weapons/impaler/impale.wav");
	precache_sound2("weapons/impaler/mimpale.wav");
	precache_sound2("weapons/impaler/pimpale.wav");
	precache_sound2("weapons/impaler/impfire.wav");
	precache_sound2("weapons/impaler/impex.wav");
	precache_sound2("weapons/field/genactiv.wav");
	precache_sound2("weapons/field/genstop.wav");
	precache_sound2("weapons/field/genpulse.wav");
	precache_sound2("weapons/field/genlev.wav");
	precache_sound2("weapons/field/genhit1.wav");
	precache_sound2("weapons/field/genhit2.wav");
	precache_sound2("weapons/field/genhit3.wav");
	precache_sound2("player/walk1.wav");
	precache_sound2("player/walk2.wav");
	precache_sound2("player/walk3.wav");
	precache_sound2("player/walk4.wav");
	precache_sound2("player/walk5.wav");
	precache_sound2("player/walk6.wav");
	precache_sound2("player/walkh2o1.wav");
	precache_sound2("player/walkh2o2.wav");
	precache_sound2("misc/h2ohit1.wav");
	precache_sound2("misc/trigger1.wav");
	precache_sound2("monsters/spider/sactiv.wav");
};

float() crandom = 
{
	return AS_SLIDING * (random() - 0.5);
};

void() W_FireAxe = 
{
	local vector source;
	local vector org;
	local float r;
	r = random();
	makevectors(self.v_angle);
	source = self.origin + '0 0 16';
	traceline(source, source + v_forward * IT_LIGHTME, 0, self);
	if (trace_fraction == OPT_MOTD)
	{
		return;
	}
	org = trace_endpos - v_forward * WEAPON_SPIKES;
	if (trace_ent.takedamage)
	{
		if (trace_ent.classname == "monster_juggernaut" || trace_ent.classname == "monster_juggernaut2")
		{
			sound(self, CHAN_WEAPON, "monsters/juggers/jbent.wav", OPT_MOTD, ATTN_NORM);
		}
		else
		{
			if (trace_ent.classname == "monster_hell_knight" || trace_ent.classname == "monster_knight" || trace_ent.classname == "monster_dknight")
			{
				if (r < 0.3)
				{
					sound(trace_ent, CHAN_ITEM, "enviro/physics/axemet1.wav", OPT_MOTD, ATTN_NORM);
				}
				else
				{
					if (r < 0.6)
					{
						sound(trace_ent, CHAN_ITEM, "enviro/physics/axemet2.wav", OPT_MOTD, ATTN_NORM);
					}
					else
					{
						sound(trace_ent, CHAN_ITEM, "enviro/physics/axemet3.wav", OPT_MOTD, ATTN_NORM);
					}
				}
			}
			else
			{
				if (trace_ent.classname == "player" && trace_ent.armorvalue > MSG_BROADCAST)
				{
					if (r < 0.3)
					{
						sound(trace_ent, CHAN_ITEM, "enviro/physics/axemet1.wav", OPT_MOTD, ATTN_NORM);
					}
					else
					{
						if (r < 0.6)
						{
							sound(trace_ent, CHAN_ITEM, "enviro/physics/axemet2.wav", OPT_MOTD, ATTN_NORM);
						}
						else
						{
							sound(trace_ent, CHAN_ITEM, "enviro/physics/axemet3.wav", OPT_MOTD, ATTN_NORM);
						}
					}
				}
				else
				{
					if (r < 0.5)
					{
						sound(trace_ent, CHAN_ITEM, "enviro/physics/axecut1.wav", OPT_MOTD, ATTN_NORM);
						SpawnBlood(org, VEC_ORIGIN, 20, trace_ent);
						SpawnBlood(org, VEC_ORIGIN, 20, trace_ent);
						SpawnBlood(org, VEC_ORIGIN, 20, trace_ent);
					}
					else
					{
						sound(trace_ent, CHAN_ITEM, "enviro/physics/axecut2.wav", OPT_MOTD, ATTN_NORM);
						SpawnBlood(org, VEC_ORIGIN, 20, trace_ent);
					}
				}
			}
		}
		trace_ent.axhitme = OPT_MOTD;
		T_Damage(trace_ent, self, self, 20);
	}
	else
	{
		sound(self, CHAN_WEAPON, "player/axhit2.wav", OPT_MOTD, ATTN_NORM);
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
	vel = vel + AS_SLIDING * trace_plane_normal;
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
	missile.nextthink = time + OPT_MOTD;
	missile.think = SUB_Remove;
	setmodel(missile, "progs/zom_gib.mdl");
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(missile, org);
};

void(vector org, vector vel, float damage, entity targ) SpawnBlood = 
{
	local float r;
	r = random();
	if (targ.takedamage != DAMAGE_AIM || targ.classname == "misc_explobox" || targ.classname == "wall_explode" || targ.classname == "misc_explobox2")
	{
		WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte(MSG_BROADCAST, TE_GUNSHOT);
		WriteCoord(MSG_BROADCAST, org_x);
		WriteCoord(MSG_BROADCAST, org_y);
		WriteCoord(MSG_BROADCAST, org_z);
	}
	else
	{
		if (targ.classname == "monster_spider" || targ.classname == "monster_juggernaut" || targ.classname == "monster_juggernaut2")
		{
			particle(org, vel * 0.1, TE_LIGHTNING1, damage * AS_SLIDING);
		}
		else
		{
			r = random();
			if (r < 0.7)
			{
				particle(org, vel * 0.1, 73, damage * AS_SLIDING);
			}
			else
			{
				particle(org, vel * 0.1, 79, damage * OPT_MOTD);
				particle(org, vel * 0.25, 74, damage * TE_LIGHTNING1);
				particle(org, vel * 0.15, 69, damage * AS_SLIDING);
			}
		}
	}
};

void(float damage, entity targ) spawn_touchblood = 
{
	local vector vel;
	vel = wall_velocity() * 0.2;
	SpawnBlood(self.origin + vel * 0.010000, vel, damage, targ);
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
	vel = vel + AS_SLIDING * trace_plane_normal;
	vel = vel * 200;
	org = trace_endpos - dir * WEAPON_SPIKES;
	if (trace_ent.takedamage)
	{
		SpawnBlood(org, vel * 0.2, damage, trace_ent);
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
		if (trace_fraction != OPT_MOTD)
		{
			TraceAttack(WEAPON_SPIKES, direction);
		}
		shotcount = shotcount - OPT_MOTD;
	}
	ApplyMultiDamage();
};

void() W_FireShotgun = 
{
	local vector dir;
	sound(self, CHAN_WEAPON, "weapons/guncock.wav", OPT_MOTD, ATTN_NORM);
	self.punchangle_x = CONTENT_SOLID;
	self.currentammo = self.ammo_shells = self.ammo_shells - OPT_MOTD;
	dir = aim(self, 100000);
	FireBullets(TE_LIGHTNING2, dir, '0.040000 0.040000 0');
};

void() W_FireSuperShotgun = 
{
	local vector dir;
	if (self.currentammo == OPT_MOTD)
	{
		W_FireShotgun();
		return;
	}
	sound(self, CHAN_WEAPON, "weapons/shotgn2.wav", OPT_MOTD, ATTN_NORM);
	self.punchangle_x = CONTENT_SLIME;
	self.currentammo = self.ammo_shells = self.ammo_shells - AS_SLIDING;
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
		if (other.classname == "monster_shambler" || other.classname == "monster_legond")
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
	BecomeExplosion();
};

void() W_FireRocket = 
{
	local entity missile;
	local entity mpuff;
	self.currentammo = self.ammo_rockets = self.ammo_rockets - OPT_MOTD;
	sound(self, CHAN_WEAPON, "weapons/sgun1.wav", OPT_MOTD, ATTN_NORM);
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
	missile.nextthink = time + TE_LIGHTNING1;
	missile.think = SUB_Remove;
	setmodel(missile, "progs/missile.mdl");
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(missile, self.origin + v_forward * WEAPON_BIG + '0 0 16');
};

void() PulseHome = 
{
	local vector dir;
	local vector vtemp;
	vtemp = self.enemy.origin + '0 0 10';
	dir = normalize(vtemp - self.origin);
	self.velocity = dir * 800;
	if (!(self.enemy))
	{
		self.nextthink = time + TE_LIGHTNING1;
		self.think = SUB_Remove;
	}
	else
	{
		self.nextthink = time + 0.2;
		self.think = PulseHome;
	}
};

void(float dm) BecomePurpleExplosion = 
{
	local entity missile;
	local entity mpuff;
	local vector org;
	missile = spawn();
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
	missile.velocity = VelocityForDamage(dm);
	missile.avelocity_x = random() * 300;
	missile.avelocity_y = random() * 300;
	missile.avelocity_z = random() * 300;
	missile.touch = SUB_Remove;
	missile.nextthink = time + AS_MELEE;
	missile.think = SUB_Remove;
	if (other.classname == "monster_ogre" || other.classname == "monster_ogre_marksman" || other.classname == "monster_shambler" || other.classname == "monster_legond" || other.classname == "monster_blud" || other.classname == "monster_babyblud" || other.classname == "monster_shalrath" || other.classname == "monster_army" || other.classname == "monster_demon1" || other.classname == "monster_enforcer" || other.classname == "monster_lenforcer" || other.classname == "player")
	{
		setmodel(missile, "progs/blpulse.mdl");
	}
	else
	{
		setmodel(missile, "progs/wlpulse.mdl");
	}
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(missile, self.origin - v_forward * WEAPON_BIG);
};

void(float dm) BecomeBloodSpurt = 
{
	local entity missile;
	local entity mpuff;
	local vector org;
	missile = spawn();
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
	missile.velocity = VelocityForDamage(dm);
	missile.avelocity_x = random() * 300;
	missile.avelocity_y = random() * 300;
	missile.avelocity_z = random() * 300;
	missile.touch = SUB_Remove;
	missile.nextthink = time + AS_MELEE;
	missile.think = SUB_Remove;
	setmodel(missile, "progs/blpulse.mdl");
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(missile, self.origin - v_forward * WEAPON_BIG);
};

void() T_MediumPulseTouch = 
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
	if (other.classname == "monster_zombie")
	{
		damg = 55 + random() * TE_WIZSPIKE;
	}
	else
	{
		damg = 40 + random() * 20;
	}
	if (other.takedamage)
	{
		if (other.health <= damg && other.classname != "monster_juggernaut" && other.classname != "monster_juggernaut2" && other.solid != SOLID_BSP && other.movetype != MOVETYPE_NONE && other.classname != "player")
		{
			T_Damage(other, self, self.owner, 35 + damg + random() * 60);
			other.origin_z = other.origin_z + OPT_MOTD;
			other.flags = other.flags - (other.flags & FL_ONGROUND);
			makevectors(self.v_angle);
			if (other.classname == "monster_hell_knight" || other.classname == "monster_ogre" || other.classname == "monster_ogre_marksman" || other.classname == "monster_shambler" || other.classname == "monster_legond" || other.classname == "monster_blud" || other.classname == "monster_babyblud" || other.classname == "monster_shalrath")
			{
				other.velocity = aim(self, 25);
				other.velocity = '0 0 25' + self.velocity;
			}
			else
			{
				other.velocity = aim(self, 500);
				other.velocity = '0 0 150' + self.velocity;
			}
			other.movetype = MOVETYPE_TOSS;
			other.v_angle = self.angles;
		}
		T_Damage(other, self, self.owner, damg);
	}
	sound(self, CHAN_WEAPON, "enforcer/enfstop.wav", OPT_MOTD, ATTN_NORM);
	BecomePurpleExplosion(damg);
	BecomePurpleExplosion(damg);
	remove(self);
};

void() T_SinglePulseTouch = 
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
	if (other.classname == "monster_zombie")
	{
		damg = 55 + random() * TE_WIZSPIKE;
	}
	else
	{
		damg = 35 + random() * 25;
	}
	if (other.takedamage)
	{
		T_Damage(other, self, self.owner, damg);
		if (other.health <= MSG_BROADCAST && other.classname != "monster_juggernaut" && other.classname != "monster_juggernaut2" && other.solid != SOLID_BSP && other.movetype != MOVETYPE_NONE)
		{
			if (other.classname != "player")
			{
				other.origin_z = other.origin_z + OPT_MOTD;
			}
			other.flags = other.flags - (other.flags & FL_ONGROUND);
			makevectors(self.v_angle);
			if (other.classname == "monster_hell_knight" || other.classname == "monster_ogre" || other.classname == "monster_ogre_marksman" || other.classname == "monster_shambler" || other.classname == "monster_legond" || other.classname == "monster_blud" || other.classname == "monster_babyblud" || other.classname == "monster_shalrath")
			{
				other.velocity = aim(self, 25);
				other.velocity = '0 0 25' + self.velocity;
			}
			else
			{
				other.velocity = aim(self, 500);
				other.velocity = '0 0 150' + self.velocity;
			}
			if (other.classname != "player")
			{
				other.movetype = MOVETYPE_TOSS;
				other.v_angle = self.angles;
			}
		}
	}
	sound(self, CHAN_WEAPON, "enforcer/enfstop.wav", OPT_MOTD, ATTN_NORM);
	BecomePurpleExplosion(damg);
	BecomePurpleExplosion(damg);
	remove(self);
};

void() T_SmallPulseTouch = 
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
	if (other.classname == "monster_zombie")
	{
		damg = 55 + random() * TE_WIZSPIKE;
	}
	else
	{
		damg = 35 + random() * 25;
	}
	if (other.takedamage)
	{
		T_Damage(other, self, self.owner, damg);
		if (other.health <= MSG_BROADCAST && other.classname != "monster_juggernaut" && other.classname != "monster_juggernaut2" && other.solid != SOLID_BSP && other.movetype != MOVETYPE_NONE && other.classname != "player")
		{
			other.origin_z = other.origin_z + OPT_MOTD;
			other.flags = other.flags - (other.flags & FL_ONGROUND);
			makevectors(self.v_angle);
			if (other.classname == "monster_hell_knight" || other.classname == "monster_ogre" || other.classname == "monster_ogre_marksman" || other.classname == "monster_shambler" || other.classname == "monster_legond" || other.classname == "monster_blud" || other.classname == "monster_babyblud" || other.classname == "monster_shalrath")
			{
				other.velocity = aim(self, 25);
				other.velocity = '0 0 25' + self.velocity;
			}
			else
			{
				other.velocity = aim(self, 500);
				other.velocity = '0 0 150' + self.velocity;
			}
			other.movetype = MOVETYPE_TOSS;
			other.v_angle = self.angles;
			return;
		}
	}
	sound(self, CHAN_WEAPON, "enforcer/enfstop.wav", OPT_MOTD, ATTN_NORM);
	BecomePurpleExplosion(damg);
	BecomePurpleExplosion(damg);
	remove(self);
};

void() W_FireRifleM = 
{
	local entity missile;
	local entity mpuff;
	local vector dir;
	local vector vec;
	local vector offang;
	local vector offset;
	self.punchangle_x = CONTENT_SOLID;
	sound(self, CHAN_WEAPON, "weapons/pulse/pulshot1.wav", OPT_MOTD, ATTN_NORM);
	missile = spawn();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	missile.classname = "pulse";
	makevectors(self.v_angle);
	missile.velocity = aim(self, 1000);
	missile.velocity = missile.velocity * 1000;
	missile.angles = vectoangles(missile.velocity);
	missile.touch = T_MediumPulseTouch;
	missile.nextthink = time + TE_LIGHTNING1;
	missile.think = SUB_Remove;
	setmodel(missile, "progs/pulse.mdl");
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(missile, self.origin - v_right * IT_NAPALM + '0 0 8');
};

void() W_FireRifleL = 
{
	local entity missile;
	local entity mpuff;
	local vector dir;
	local vector vec;
	local vector offang;
	local vector offset;
	self.punchangle_x = CONTENT_SOLID;
	sound(self, CHAN_WEAPON, "weapons/pulse/pulshot1.wav", OPT_MOTD, ATTN_NORM);
	self.currentammo = self.ammo_cells = self.ammo_cells - WEAPON_ROCKET;
	missile = spawn();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	missile.classname = "pulse";
	makevectors(self.v_angle);
	missile.velocity = aim(self, 1000);
	missile.velocity = missile.velocity * 1000;
	missile.angles = vectoangles(missile.velocity);
	missile.touch = T_MediumPulseTouch;
	missile.nextthink = time + TE_LIGHTNING1;
	missile.think = SUB_Remove;
	setmodel(missile, "progs/pulse.mdl");
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(missile, self.origin + v_right * IT_NAPALM + '0 0 8');
};

void() W_FireRifleK = 
{
	local entity missile;
	local entity mpuff;
	local vector dir;
	local vector vec;
	local vector offang;
	local vector offset;
	self.punchangle_x = CONTENT_SOLID;
	sound(self, CHAN_WEAPON, "weapons/pulse/pulshot2.wav", OPT_MOTD, ATTN_NORM);
	missile = spawn();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	missile.classname = "pulse";
	makevectors(self.v_angle);
	missile.velocity = aim(self, 1000);
	missile.velocity = missile.velocity * 1000;
	missile.angles = vectoangles(missile.velocity);
	missile.touch = T_MediumPulseTouch;
	missile.nextthink = time + TE_LIGHTNING1;
	missile.think = SUB_Remove;
	setmodel(missile, "progs/pulse.mdl");
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(missile, self.origin - v_right * IT_SPEAR + '0 0 8');
};

void() W_FireRifleJ = 
{
	local entity missile;
	local entity mpuff;
	local vector dir;
	local vector vec;
	local vector offang;
	local vector offset;
	self.punchangle_x = CONTENT_SOLID;
	sound(self, CHAN_WEAPON, "weapons/pulse/pulshot1.wav", OPT_MOTD, ATTN_NORM);
	self.currentammo = self.ammo_cells = self.ammo_cells - WEAPON_ROCKET;
	missile = spawn();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	missile.classname = "pulse";
	makevectors(self.v_angle);
	missile.velocity = aim(self, 1000);
	missile.velocity = missile.velocity * 1000;
	missile.angles = vectoangles(missile.velocity);
	missile.touch = T_MediumPulseTouch;
	missile.nextthink = time + TE_LIGHTNING1;
	missile.think = SUB_Remove;
	setmodel(missile, "progs/pulse.mdl");
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(missile, self.origin + v_right * IT_SPEAR + '0 0 8');
};

void() W_FireRifleI = 
{
	local entity missile;
	local entity mpuff;
	local vector dir;
	local vector vec;
	local vector offang;
	local vector offset;
	self.punchangle_x = CONTENT_SOLID;
	sound(self, CHAN_WEAPON, "weapons/pulse/pulshot2.wav", OPT_MOTD, ATTN_NORM);
	missile = spawn();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	missile.classname = "pulse";
	makevectors(self.v_angle);
	missile.velocity = aim(self, 1000);
	missile.velocity = missile.velocity * 1000;
	missile.angles = vectoangles(missile.velocity);
	missile.touch = T_MediumPulseTouch;
	missile.nextthink = time + TE_LIGHTNING1;
	missile.think = SUB_Remove;
	setmodel(missile, "progs/pulse.mdl");
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(missile, self.origin - v_right * 48 + '0 0 8');
};

void() W_FireRifleH = 
{
	local entity missile;
	local entity mpuff;
	local vector dir;
	local vector vec;
	local vector offang;
	local vector offset;
	self.punchangle_x = CONTENT_SOLID;
	sound(self, CHAN_AUTO, "weapons/pulse/pulshot1.wav", OPT_MOTD, ATTN_NORM);
	sound(self, CHAN_WEAPON, "weapons/pulse/pulshot2.wav", OPT_MOTD, ATTN_NORM);
	self.currentammo = self.ammo_cells = self.ammo_cells - WEAPON_ROCKET;
	missile = spawn();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	missile.classname = "pulse";
	makevectors(self.v_angle);
	missile.velocity = aim(self, 1000);
	missile.velocity = missile.velocity * 1000;
	missile.angles = vectoangles(missile.velocity);
	missile.touch = T_MediumPulseTouch;
	missile.nextthink = time + TE_LIGHTNING1;
	missile.think = SUB_Remove;
	setmodel(missile, "progs/pulse.mdl");
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(missile, self.origin + v_right * 48 + '0 0 8');
};

void() W_FireRifleD = 
{
	local entity missile;
	local entity mpuff;
	local vector dir;
	local vector vec;
	local vector offang;
	local vector offset;
	self.punchangle_x = CONTENT_SOLID;
	sound(self, CHAN_AUTO, "weapons/pulse/pulshot1.wav", OPT_MOTD, ATTN_NORM);
	sound(self, CHAN_WEAPON, "weapons/pulse/pulshot2.wav", OPT_MOTD, ATTN_NORM);
	missile = spawn();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	missile.classname = "pulse";
	missile.enemy = self.enemy;
	makevectors(self.v_angle);
	missile.velocity = aim(self, 1000);
	missile.velocity = missile.velocity * 1000;
	missile.angles = vectoangles(missile.velocity);
	missile.touch = T_SmallPulseTouch;
	missile.nextthink = time + 0.3;
	missile.think = PulseHome;
	setmodel(missile, "progs/pulse.mdl");
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(missile, self.origin + v_right * 48 + '0 0 8');
};

void() W_FireRifleC = 
{
	local entity missile;
	local entity mpuff;
	local vector dir;
	local vector vec;
	local vector offang;
	local vector offset;
	self.punchangle_x = CONTENT_SOLID;
	sound(self, CHAN_AUTO, "weapons/pulse/pulshot1.wav", OPT_MOTD, ATTN_NORM);
	sound(self, CHAN_WEAPON, "weapons/pulse/pulshot2.wav", OPT_MOTD, ATTN_NORM);
	missile = spawn();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	missile.classname = "pulse";
	missile.enemy = self.enemy;
	makevectors(self.v_angle);
	missile.velocity = aim(self, 1000);
	missile.velocity = missile.velocity * 1000;
	missile.angles = vectoangles(missile.velocity);
	missile.touch = T_SmallPulseTouch;
	missile.nextthink = time + 0.2;
	missile.think = PulseHome;
	setmodel(missile, "progs/pulse.mdl");
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(missile, self.origin + v_right * IT_SPEAR + '0 0 8');
};

void() W_FireRifleB = 
{
	local entity missile;
	local entity mpuff;
	local vector dir;
	local vector vec;
	local vector offang;
	local vector offset;
	self.punchangle_x = CONTENT_SOLID;
	sound(self, CHAN_WEAPON, "weapons/pulse/pulshot2.wav", OPT_MOTD, ATTN_NORM);
	missile = spawn();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	missile.classname = "pulse";
	missile.enemy = self.enemy;
	makevectors(self.v_angle);
	missile.velocity = aim(self, 1000);
	missile.velocity = missile.velocity * 1000;
	missile.angles = vectoangles(missile.velocity);
	missile.touch = T_SmallPulseTouch;
	missile.nextthink = time + 0.1;
	missile.think = PulseHome;
	setmodel(missile, "progs/pulse.mdl");
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(missile, self.origin + v_right * IT_NAPALM + '0 0 8');
};

void() W_FireRifleA = 
{
	local vector dir;
	local vector vtemp;
	local entity missile;
	local entity mpuff;
	local vector vec;
	local vector offang;
	local vector offset;
	self.punchangle_x = CONTENT_SOLID;
	sound(self, CHAN_AUTO, "weapons/pulse/pulshot1.wav", OPT_MOTD, ATTN_NORM);
	self.currentammo = self.ammo_cells = self.ammo_cells - AS_MELEE;
	missile = spawn();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	setorigin(missile, self.origin + v_right * IT_NAPALM + '0 0 8');
	missile.classname = "pulse";
	vtemp = missile.origin + v_right * 12 + v_forward * IT_LIGHTME;
	makevectors(self.v_angle);
	dir = normalize(vtemp - missile.origin);
	missile.velocity = dir * 1000;
	missile.angles = vectoangles(missile.velocity);
	missile.touch = T_SinglePulseTouch;
	missile.nextthink = time + TE_LIGHTNING1;
	missile.think = SUB_Remove;
	setmodel(missile, "progs/pulse.mdl");
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
};

void() W_FireRifle2A = 
{
	local entity missile;
	local entity mpuff;
	local vector dir;
	local vector vtemp;
	local vector vec;
	local vector offang;
	local vector offset;
	self.punchangle_x = CONTENT_SOLID;
	missile = spawn();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	setorigin(missile, self.origin + v_right * IT_NAPALM + '0 0 8');
	missile.classname = "pulse";
	vtemp = missile.origin - v_right * 12 + v_forward * IT_LIGHTME;
	makevectors(self.v_angle);
	dir = normalize(vtemp - missile.origin);
	missile.velocity = dir * 1000;
	missile.angles = vectoangles(missile.velocity);
	missile.touch = T_SinglePulseTouch;
	missile.nextthink = time + TE_LIGHTNING1;
	missile.think = SUB_Remove;
	setmodel(missile, "progs/pulse.mdl");
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
};

void() W_FireRifle3A = 
{
	local entity missile;
	local entity mpuff;
	local vector dir;
	local vector vec;
	local vector offang;
	local vector offset;
	self.punchangle_x = CONTENT_SOLID;
	missile = spawn();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	setorigin(missile, self.origin + v_right * IT_NAPALM + '0 0 8');
	missile.classname = "pulse";
	makevectors(self.v_angle);
	missile.velocity = aim(self, 1000);
	missile.velocity = missile.velocity * 1000;
	missile.angles = vectoangles(missile.velocity);
	missile.touch = T_SinglePulseTouch;
	missile.nextthink = time + TE_LIGHTNING1;
	missile.think = SUB_Remove;
	setmodel(missile, "progs/pulse.mdl");
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
};

void() W_FireRifleTarget = 
{
	local entity missile;
	local entity mpuff;
	local vector dir;
	local vector vec;
	local vector offang;
	local vector offset;
	self.punchangle_x = CONTENT_SOLID;
	self.currentammo = self.ammo_cells = self.ammo_cells - WEAPON_SPIKES;
	missile = spawn();
	missile.owner = self;
	self.enemy = missile;
	missile.movetype = MOVETYPE_NOCLIP;
	missile.solid = SOLID_BBOX;
	missile.classname = "missile";
	makevectors(self.v_angle);
	missile.velocity = aim(self, 1000);
	missile.velocity = missile.velocity * 1000;
	missile.angles = vectoangles(missile.velocity);
	missile.nextthink = time + AS_MELEE;
	missile.think = SUB_Remove;
	setmodel(missile, "progs/null.mdl");
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(missile, self.origin + v_forward * WEAPON_BIG);
};

void(vector org, vector vel, float damage) ExtraBlood = 
{
	if (other.classname == "wall_explode")
	{
		SpawnBlood(org, vel, damage, other);
		return;
	}
	particle(org, '0 0 100', 225, damage * WEAPON_SPIKES);
};

void(float damage) spawn_extrablood = 
{
	local vector vel;
	vel = wall_velocity() * 0.2;
	ExtraBlood(self.origin + vel * 0.010000, vel, damage);
};

void(vector org, vector vel, float damage) SpawnSpark = 
{
	particle(org, vel * 0.1, 47, damage * WEAPON_ROCKET);
};

void(float damage) spawn_touchspark = 
{
	local vector vel;
	vel = wall_velocity() * 0.2;
	SpawnSpark(self.origin + vel * 0.010000, vel, damage);
};

vector(float dm) VelocityForJump = 
{
	local vector v;
	if (other.classname == "spark")
	{
		return VEC_ORIGIN_x;
	}
	else
	{
		if (other.classname == "missile")
		{
			return VEC_ORIGIN_x;
		}
		else
		{
			if (other.classname == "monster_shambler" && other.health > IT_NAPALM)
			{
				return VEC_ORIGIN_x;
			}
			else
			{
				if (other.classname == "monster_blud" && other.health > IT_NAPALM)
				{
					return VEC_ORIGIN_x;
				}
				else
				{
					if (other.classname == "monster_babyblud" && other.health > IT_NAPALM)
					{
						return VEC_ORIGIN_x;
					}
					else
					{
						if (other.classname == "monster_legond")
						{
							return VEC_ORIGIN_x;
						}
					}
				}
			}
		}
	}
	if (other.classname == "missile")
	{
		v_x = 50 * crandom();
		v_y = 50 * crandom();
		v_z = 50 + 50 * random();
	}
	else
	{
		if (self.owner.super_damage_finished > time && self.owner.classname == "player")
		{
			v_x = 1000 * crandom();
			v_y = 1000 * crandom();
			v_z = 2000 + 1000 * random();
		}
		else
		{
			if (other.classname == "monster_ogre" || other.classname == "monster_ogre_marksman")
			{
				v_x = 200 * crandom();
				v_y = 200 * crandom();
				v_z = 150 + 50 * random();
			}
			else
			{
				if (other.classname == "monster_hell_knight")
				{
					v_x = 200 * crandom();
					v_y = 200 * crandom();
					v_z = 150 + 50 * random();
				}
				else
				{
					v_x = 200 * crandom();
					v_y = 200 * crandom();
					v_z = 300 + 100 * random();
				}
			}
		}
	}
	if (other.classname == "player")
	{
		other.movetype = MOVETYPE_WALK;
	}
	v = v * 0.7;
	return v_x;
};

void(float dm) SpawnMeatBounce = 
{
	local entity missile;
	local entity mpuff;
	missile = spawn();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_NOT;
	makevectors(self.angles);
	missile.velocity = VelocityForJump(dm);
	missile.avelocity = '3000 1000 2000';
	missile.nextthink = time + WEAPON_SHOTGUN;
	missile.think = SUB_Remove;
	setmodel(missile, "progs/zom_gib.mdl");
	setorigin(missile, other.origin);
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
};

void(float dm) SpawnDischarge = 
{
	local entity missile;
	local entity mpuff;
	missile = spawn();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_NOT;
	makevectors(self.angles);
	missile.velocity = VelocityForJump(dm);
	missile.avelocity = '3000 1000 2000';
	missile.nextthink = time + 0.2;
	missile.think = SUB_Remove;
	setmodel(missile, "progs/bolt.mdl");
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(missile, self.origin);
};

void() gibhim = 
{
	local entity attacker;
	local float r;
	if (self.elec == MSG_BROADCAST)
	{
		self.effects = EF_MUZZLEFLASH;
		r = random();
		if (r < 0.3)
		{
			sound(self, CHAN_WEAPON, "weapons/light2/lgdis1.wav", WEAPON_SHOTGUN, ATTN_NORM);
		}
		else
		{
			if (r < 0.6)
			{
				sound(self, CHAN_WEAPON, "weapons/light2/lgdis2.wav", WEAPON_SHOTGUN, ATTN_NORM);
			}
			else
			{
				sound(self, CHAN_WEAPON, "weapons/light2/lgdis3.wav", WEAPON_SHOTGUN, ATTN_NORM);
			}
		}
		if (self.classname == "player")
		{
			self.modelindex = modelindex_bolt;
		}
		else
		{
			setmodel(self, "progs/bolt2.mdl");
		}
		self.frame = counter;
		self.elec = WEAPON_SHOTGUN;
		self.exptime = self.exptime + 0.1;
		spawn_touchspark(TE_LAVASPLASH);
	}
	else
	{
		if (self.elec == WEAPON_SHOTGUN)
		{
			if (self.classname == "monster_ogre")
			{
				setmodel(self, "progs/ogre.mdl");
			}
			else
			{
				if (self.classname == "monster_ogre_marksman")
				{
					setmodel(self, "progs/ogre.mdl");
				}
				else
				{
					if (self.classname == "monster_dknight")
					{
						setmodel(self, "progs/dknight.mdl");
					}
					else
					{
						if (self.classname == "monster_blud")
						{
							setmodel(self, "progs/blud.mdl");
						}
						else
						{
							if (self.classname == "monster_legond")
							{
								setmodel(self, "progs/legond.mdl");
							}
							else
							{
								if (self.classname == "monster_spider")
								{
									setmodel(self, "progs/spid.mdl");
								}
								else
								{
									if (self.classname == "monster_hbot")
									{
										setmodel(self, "progs/hbot.mdl");
									}
									else
									{
										if (self.classname == "monster_grenling")
										{
											setmodel(self, "progs/grenling.mdl");
										}
										else
										{
											if (self.classname == "monster_gren")
											{
												setmodel(self, "progs/grenling.mdl");
											}
											else
											{
												if (self.classname == "monster_knight")
												{
													setmodel(self, "progs/knight.mdl");
												}
												else
												{
													if (self.classname == "monster_shambler")
													{
														setmodel(self, "progs/shambler.mdl");
													}
													else
													{
														if (self.classname == "monster_demon1")
														{
															setmodel(self, "progs/demon.mdl");
														}
														else
														{
															if (self.classname == "monster_wizard")
															{
																setmodel(self, "progs/wizard.mdl");
															}
															else
															{
																if (self.classname == "monster_zombie")
																{
																	setmodel(self, "progs/zombie.mdl");
																}
																else
																{
																	if (self.classname == "monster_dog")
																	{
																		setmodel(self, "progs/dog.mdl");
																	}
																	else
																	{
																		if (self.classname == "monster_hell_knight")
																		{
																			setmodel(self, "progs/hknight.mdl");
																		}
																		else
																		{
																			if (self.classname == "monster_tarbaby")
																			{
																				setmodel(self, "progs/tarbaby.mdl");
																			}
																			else
																			{
																				if (self.classname == "monster_army")
																				{
																					setmodel(self, "progs/soldier.mdl");
																				}
																				else
																				{
																					if (self.classname == "monster_shalrath")
																					{
																						setmodel(self, "progs/shalrath.mdl");
																					}
																					else
																					{
																						if (self.classname == "monster_fish")
																						{
																							setmodel(self, "progs/fish.mdl");
																						}
																						else
																						{
																							if (self.classname == "monster_enforcer")
																							{
																								setmodel(self, "progs/enforcer.mdl");
																							}
																							else
																							{
																								if (self.classname == "monster_lenforcer")
																								{
																									setmodel(self, "progs/enforcer.mdl");
																								}
																								else
																								{
																									if (self.classname == "monster_babyblud")
																									{
																										setmodel(self, "progs/spawn.mdl");
																									}
																									else
																									{
																										if (self.classname == "player")
																										{
																											r = random();
																											self.modelindex = modelindex_player;
																											setmodel(self, "progs/player.mdl");
																											if (self.weapon == IT_AXE)
																											{
																												if (r < 0.3)
																												{
																													self.frame = SVC_FINALE;
																												}
																												else
																												{
																													if (r < 0.6)
																													{
																														self.frame = 35;
																													}
																													else
																													{
																														self.frame = 42;
																													}
																												}
																											}
																											else
																											{
																												if (r < 0.3)
																												{
																													self.frame = 61;
																												}
																												else
																												{
																													if (r < 0.6)
																													{
																														self.frame = 71;
																													}
																													else
																													{
																														self.frame = 87;
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
			self.effects = EF_DIMLIGHT;
			self.elec = MSG_BROADCAST;
			self.exptime = self.exptime + 0.1;
		}
	}
	if (self.exptime >= 1.6)
	{
		self.effects = self.effects - (self.effects & EF_DIMLIGHT);
		self.effects = self.effects - (self.effects & EF_MUZZLEFLASH);
		self.takedamage = DAMAGE_AIM;
		self.movetype = MOVETYPE_STEP;
		if (self.classname != "player")
		{
			T_RadiusDamage(self, self.owner, 120, world);
		}
		else
		{
			T_RadiusDamage(self, self.enemy, 120, world);
		}
		SpawnDischarge(120);
		SpawnDischarge(120);
		SpawnDischarge(120);
		r = random();
		if (r < 0.3)
		{
			sound(self, CHAN_WEAPON, "weapons/light2/lgdis1.wav", WEAPON_SHOTGUN, ATTN_NORM);
		}
		else
		{
			if (r < 0.6)
			{
				sound(self, CHAN_WEAPON, "weapons/light2/lgdis2.wav", WEAPON_SHOTGUN, ATTN_NORM);
			}
			else
			{
				sound(self, CHAN_WEAPON, "weapons/light2/lgdis3.wav", WEAPON_SHOTGUN, ATTN_NORM);
			}
		}
		self.exptime = MSG_BROADCAST;
		return;
	}
	self.nextthink = time + 0.1;
	self.think = gibhim;
};

void(float dm) rebound = 
{
	self.owner = self.owner;
	sound(self, CHAN_WEAPON, "weapons/light2/lghit.wav", WEAPON_SHOTGUN, ATTN_NORM);
	self.velocity = normalize(self.velocity);
	self.velocity = self.velocity * 1000;
	self.movetype = MOVETYPE_FLYMISSILE;
	self.angles = vectoangles(self.velocity);
	self.think = SUB_Remove;
	self.nextthink = time + 0.4;
	spawn_touchspark(WEAPON_SHOTGUN);
	self.bounced = self.bounced + WEAPON_SHOTGUN;
	if (self.bounced == TE_LIGHTNING1)
	{
		remove(self);
		return;
	}
	if (!(self.flags & FL_INWATER))
	{
		if (self.watertype == CONTENT_WATER)
		{
			sound(self, CHAN_WEAPON, "weapons/light2/lgdis1.wav", WEAPON_SHOTGUN, ATTN_NORM);
			SpawnDischarge(200);
			SpawnDischarge(200);
			SpawnDischarge(200);
			T_RadiusDamage(self, self.owner, 200, world);
			remove(self);
			return;
		}
		if (self.watertype == CONTENT_SLIME)
		{
			sound(self, CHAN_WEAPON, "weapons/light2/lgdis2.wav", WEAPON_SHOTGUN, ATTN_NORM);
			SpawnDischarge(150);
			SpawnDischarge(150);
			T_RadiusDamage(self, self.owner, 150, world);
			remove(self);
			return;
		}
		if (self.watertype == CONTENT_LAVA)
		{
			sound(self, CHAN_WEAPON, "weapons/light2/lgdis3.wav", WEAPON_SHOTGUN, ATTN_NORM);
			SpawnDischarge(100);
			SpawnDischarge(100);
			T_RadiusDamage(self, self.owner, 100, world);
			remove(self);
			return;
		}
	}
	self.owner = other;
};

void(float dm) ThrowMe = 
{
	if (other.movetype == MOVETYPE_PUSH)
	{
		return;
	}
	if (other.classname == "door")
	{
		return;
	}
	if (other.movetype == MOVETYPE_NONE)
	{
		return;
	}
	if (other.classname == "monster_wizard")
	{
		return;
	}
	if (other.classname == "monster_grenling" || other.classname == "monster_gren")
	{
		return;
	}
	if (other.classname == "monster_juggernaut" || other.classname == "monster_juggernaut2")
	{
		return;
	}
	if (other.classname == "monster_legond")
	{
		return;
	}
	if (other.health <= TE_LIGHTNING1 && other.classname == "player")
	{
		other.health = TE_LIGHTNING2;
	}
	other.velocity = VelocityForJump(dm);
	other.flags = other.flags - (other.flags & FL_ONGROUND);
	other.avelocity = crandom() * '0 600 0';
};

void(vector org, vector vel, float damage) LightningTouch = 
{
	local float away;
	local float dist;
	local float damg;
	local float rand;
	local string deathstring;
	if (other.solid == SOLID_TRIGGER)
	{
		return;
	}
	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	if (other.takedamage && other.classname != "monster_juggernaut" && other.classname != "monster_juggernaut2")
	{
		if (other.takedamage == DAMAGE_AIM)
		{
			spawn_extrablood(1000);
		}
		damg = IT_NAPALM;
		if (self.owner.super_damage_finished > time && other.health <= damg * WEAPON_SPIKES)
		{
			if (other.movetype == MOVETYPE_PUSH)
			{
				T_Damage(other, self, self.owner, damg);
				return;
			}
			if (other.classname == "door")
			{
				T_Damage(other, self, self.owner, damg);
				return;
			}
			if (other.movetype == MOVETYPE_NONE)
			{
				T_Damage(other, self, self.owner, damg);
				return;
			}
			ThrowMe(damg);
			if (other.classname != "player")
			{
				other.owner = self.owner;
			}
			else
			{
				other.enemy = self.owner;
			}
			remove(self);
			other.takedamage = DAMAGE_NO;
			other.think = gibhim;
			other.nextthink = time;
			return;
		}
		if (other.health <= damg)
		{
			if (other.movetype == MOVETYPE_PUSH)
			{
				T_Damage(other, self, self.owner, damg);
				return;
			}
			if (other.classname == "door")
			{
				T_Damage(other, self, self.owner, damg);
				return;
			}
			if (other.movetype == MOVETYPE_NONE)
			{
				T_Damage(other, self, self.owner, damg);
				return;
			}
			ThrowMe(damg);
			if (other.classname != "player")
			{
				other.owner = self.owner;
			}
			else
			{
				other.enemy = self.owner;
			}
			remove(self);
			other.takedamage = DAMAGE_NO;
			other.think = gibhim;
			other.nextthink = time;
			return;
		}
		else
		{
			T_Damage(other, self, self.owner, damg);
			if (other.takedamage == DAMAGE_AIM)
			{
				SpawnMeatBounce(damg);
			}
			ThrowMe(damg);
			remove(self);
		}
	}
	else
	{
		self.movetype = MOVETYPE_BOUNCE;
		self.think = rebound;
		self.ltime = self.nextthink;
		self.nextthink = time + 0.1;
		return;
	}
};

void() W_FireSuperLightning = 
{
	local entity missile;
	local entity mpuff;
	local vector org;
	local float cells;
	local float r;
	r = random();
	if (self.waterlevel > WEAPON_SHOTGUN)
	{
		cells = self.ammo_cells;
		self.ammo_cells = MSG_BROADCAST;
		W_SetCurrentAmmo();
		T_RadiusDamage(self, self, 35 * cells, world);
		return;
	}
	self.currentammo = self.ammo_cells = self.ammo_cells - WEAPON_SHOTGUN;
	self.punchangle_x = CONTENT_SOLID;
	missile = spawn();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	missile.classname = "lightme";
	makevectors(self.v_angle);
	missile.velocity = aim(self, 2000);
	missile.velocity = missile.velocity * 2000;
	missile.angles = vectoangles(missile.velocity);
	missile.touch = LightningTouch;
	missile.nextthink = time + TE_LIGHTNING1;
	missile.think = SUB_Remove;
	if (self.lightningmodel == WEAPON_SHOTGUN)
	{
		if (r <= 0.3)
		{
			sound(self, CHAN_WEAPON, "weapons/light2/lgstart2.wav", WEAPON_SHOTGUN, ATTN_NORM);
		}
		else
		{
			if (r <= 0.6)
			{
				sound(self, CHAN_WEAPON, "weapons/light2/lgstart3.wav", WEAPON_SHOTGUN, ATTN_NORM);
			}
			else
			{
				sound(self, CHAN_WEAPON, "weapons/light2/lgstart1.wav", WEAPON_SHOTGUN, ATTN_NORM);
			}
		}
		setmodel(missile, "progs/bolt2.mdl");
		self.lightningmodel = MSG_BROADCAST;
	}
	else
	{
		if (self.lightningmodel == MSG_BROADCAST)
		{
			setmodel(missile, "progs/bolt.mdl");
			self.lightningmodel = WEAPON_SHOTGUN;
		}
	}
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(missile, self.origin + VEC_ORIGIN - v_forward * MSG_BROADCAST);
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
	f = f * IT_NAPALM;
	e2 = world;
	e1 = world;
	traceline(p1, p2, 0, self);
	if (trace_ent.takedamage)
	{
		if (trace_ent.takedamage == DAMAGE_AIM)
		{
			if (trace_ent.classname != "monster_juggernaut")
			{
				particle(trace_endpos, '0 0 100', 225, damage * WEAPON_SPIKES);
			}
			else
			{
				if (trace_ent.classname != "monster_juggernaut2")
				{
					particle(trace_endpos, '0 0 100', 225, damage * WEAPON_SPIKES);
				}
			}
		}
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
		if (trace_ent.takedamage == DAMAGE_AIM)
		{
			if (trace_ent.classname != "monster_juggernaut")
			{
				particle(trace_endpos, '0 0 100', 225, damage * WEAPON_SPIKES);
			}
			else
			{
				if (trace_ent.classname != "monster_juggernaut2")
				{
					particle(trace_endpos, '0 0 100', 225, damage * WEAPON_SPIKES);
				}
			}
		}
		T_Damage(trace_ent, from, from, damage);
	}
	e2 = trace_ent;
	traceline(p1 - f, p2 - f, 0, self);
	if (trace_ent != e1 && trace_ent != e2 && trace_ent.takedamage)
	{
		if (trace_ent.takedamage == DAMAGE_AIM)
		{
			if (trace_ent.classname != "monster_juggernaut")
			{
				particle(trace_endpos, '0 0 100', 225, damage * WEAPON_SPIKES);
			}
			else
			{
				if (trace_ent.classname != "monster_juggernaut2")
				{
					particle(trace_endpos, '0 0 100', 225, damage * WEAPON_SPIKES);
				}
			}
		}
		T_Damage(trace_ent, from, from, damage);
	}
};

void() W_FireLightning = 
{
	local vector org;
	local float cells;
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
	LightningDamage(self.origin, trace_endpos + v_forward * WEAPON_SPIKES, self, SVC_INTERMISSION);
};

void() NapalmFlameThink = 
{
	local entity head;
	if (!(self.flags & FL_INWATER) && self.cnt == MSG_BROADCAST)
	{
		if (self.watertype == CONTENT_WATER)
		{
			BecomeExplosion();
			return;
		}
		if (self.watertype == CONTENT_SLIME)
		{
			BecomeExplosion();
			return;
		}
		if (self.watertype == CONTENT_LAVA)
		{
			BecomeExplosion();
			return;
		}
	}
	if (inside_nradius)
	{
		remove(world);
		print_self("NapalmFlameThink:", "recursive");
		return;
	}
	inside_nradius = 1;
	head = findradius(self.origin, 55);
	while (head)
	{
		if (head.takedamage)
		{
			T_Damage(head, self, self.owner.owner, WEAPON_ROCKET + random() * WEAPON_SPIKES);
		}
		head = head.chain;
	}
	inside_nradius = 0;
	self.nextthink = time + 0.35;
	self.cnt = self.cnt + WEAPON_SHOTGUN;
	if (self.cnt >= TE_LAVASPLASH + random() * TE_LIGHTNING1)
	{
		self.cnt = MSG_BROADCAST;
		BecomeExplosion();
		return;
	}
	self.think = NapalmFlameThink;
};

void() flameanimate1 = [1, flameanimate2]
{
};

void() flameanimate2 = [0, flameanimate3]
{
};

void() flameanimate3 = [1, flameanimate4]
{
};

void() flameanimate4 = [0, flameanimate5]
{
};

void() flameanimate5 = [1, flameanimate6]
{
};

void() flameanimate6 = [0, flameanimate1]
{
};

void() flamebanimate1 = [1, flamebanimate2]
{
};

void() flamebanimate2 = [0, flamebanimate3]
{
};

void() flamebanimate3 = [1, flamebanimate4]
{
};

void() flamebanimate4 = [0, flamebanimate5]
{
};

void() flamebanimate5 = [1, flamebanimate6]
{
};

void() flamebanimate6 = [0, flamebanimate7]
{
};

void() flamebanimate7 = [1, flamebanimate8]
{
};

void() flamebanimate8 = [0, flamebanimate9]
{
};

void() flamebanimate9 = [1, flamebanimate10]
{
};

void() flamebanimate10 = [0, flamebanimate11]
{
};

void() flamebanimate11 = [1, flamebanimate1]
{
};

void() MakeFlame = 
{
	if (other.takedamage)
	{
		T_Damage(other, self, self.owner.owner, IT_NAPALM);
		BecomeExplosion();
		return;
	}
	if (other.classname == "door")
	{
		BecomeExplosion();
		return;
	}
	if (other.movetype != MOVETYPE_PUSH)
	{
		BecomeExplosion();
		return;
	}
	if (other.takedamage && other.health <= MSG_BROADCAST)
	{
		BecomeExplosion();
		return;
	}
	if (other.classname == "monster_ogre" || other.classname == "monster_ogre_marksman" || other.classname == "monster_hell_knight")
	{
		setmodel(self, "progs/flameo2.mdl");
	}
	else
	{
		setmodel(self, "progs/flameo.mdl");
	}
	setsize(self, VEC_ORIGIN, VEC_ORIGIN);
	self.v_angle = VEC_ORIGIN;
	self.movetype = MOVETYPE_NONE;
	if (random() > 0.6 && self.cnt == MSG_BROADCAST)
	{
		flameanimate1();
	}
	else
	{
		flamebanimate1();
	}
	self.nextthink = time + 0.1;
	self.think = NapalmFlameThink;
	self.effects = self.effects | EF_DIMLIGHT;
	self.cnt = MSG_BROADCAST;
};

void() SpawnFireSpark = 
{
	local entity missile;
	local entity mpuff;
	missile = spawn();
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
	missile.owner = self;
	missile.classname = "flame";
	missile.velocity = VelocityForDamage(counter);
	missile.velocity_z = missile.velocity_z + 100 + 50 * random();
	missile.touch = MakeFlame;
	setmodel(missile, "progs/firesprk.mdl");
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(missile, self.origin);
};

void() NapalmCheckEnemyDead = 
{
	if (!(self.enemy))
	{
		BecomeExplosion();
		return;
	}
	if (self.enemy.velocity == VEC_ORIGIN)
	{
		self.nextthink = time + TE_LAVASPLASH + random() * TE_LIGHTNING1;
		self.think = BecomeExplosion;
		return;
	}
	self.origin = self.enemy.origin;
	self.cnt = self.cnt + 0.1;
	if (self.cnt > TE_LIGHTNING1)
	{
		BecomeExplosion();
		return;
	}
	self.nextthink = time + 0.1;
	self.think = NapalmCheckEnemyDead;
};

void() SpawnInternalFire2 = 
{
	self.origin = self.enemy.origin;
	self.nextthink = time + 0.1;
	self.think = NapalmCheckEnemyDead;
};

void() InternalFireThink = 
{
	local float damg;
	damg = 65 + random() * 75;
	if (self.enemy.classname == "monster_juggernaut" || self.enemy.classname == "monster_juggernaut2")
	{
		if (random() < 0.7)
		{
			BecomeExplosion();
			return;
		}
	}
	if (self.enemy.classname == "monster_legond")
	{
		BecomeExplosion();
		return;
	}
	if (self.enemy.classname == "monster_shambler")
	{
		BecomeExplosion();
		return;
	}
	if (self.enemy.classname == "monster_demon1")
	{
		BecomeExplosion();
		return;
	}
	if (self.enemy.classname == "misc_explobox")
	{
		BecomeExplosion();
		return;
	}
	if (self.enemy.classname == "misc_explobox2")
	{
		BecomeExplosion();
		return;
	}
	if (self.enemy.classname == "wall_explode")
	{
		BecomeExplosion();
		return;
	}
	if (self.enemy.health <= MSG_BROADCAST)
	{
		BecomeExplosion();
		return;
	}
	if (!(self.enemy))
	{
		BecomeExplosion();
		return;
	}
	if (!(self.flags & FL_INWATER))
	{
		if (self.watertype == CONTENT_WATER)
		{
			BecomeExplosion();
			return;
		}
		if (self.watertype == CONTENT_SLIME)
		{
			BecomeExplosion();
			return;
		}
		if (self.watertype == CONTENT_LAVA)
		{
			BecomeExplosion();
			return;
		}
	}
	if (!(self.enemy.flags & FL_INWATER))
	{
		if (self.enemy.watertype == CONTENT_WATER)
		{
			BecomeExplosion();
			return;
		}
		if (self.enemy.watertype == CONTENT_SLIME)
		{
			BecomeExplosion();
			return;
		}
		if (self.enemy.watertype == CONTENT_LAVA)
		{
			BecomeExplosion();
			return;
		}
	}
	if (self.enemy.health <= 48 && self.owner.owner.super_damage_finished > time && self.enemy.classname != "monster_zombie")
	{
		if (self.enemy.health > MSG_BROADCAST)
		{
			if (self.enemy.classname == "monster_ogre" || self.enemy.classname == "monster_ogre_marksman")
			{
				T_Damage(self.enemy, self, self.owner.owner, damg);
				BecomeExplosion();
				return;
			}
			T_Damage(self.enemy, self, self.owner.owner, damg);
			if (self.enemy.classname != "monster_juggernaut" && self.enemy.classname != "monster_juggernaut2" && self.enemy.classname != "monster_spider" && self.enemy.classname != "misc_explobox" && self.enemy.classname != "misc_explobox2" && self.enemy.classname != "wall_explode")
			{
				sound(self, CHAN_AUTO, "enviro/physics/bonexpl.wav", WEAPON_SHOTGUN, ATTN_NORM);
				if (self.enemy.classname == "monster_gren" || self.enemy.classname == "monster_grenling" || self.enemy.classname == "monster_wizard" || self.enemy.classname == "monster_dog")
				{
					ThrowGib("progs/grenbone.mdl", self.enemy.health - 40 - random() * 60);
					ThrowGib("progs/grenbone.mdl", self.enemy.health - 40 - random() * 60);
					ThrowGib("progs/grenbone.mdl", self.enemy.health - 40 - random() * 60);
					ThrowGib("progs/grenbone.mdl", self.enemy.health - 40 - random() * 60);
					ThrowGib("progs/grenbone.mdl", self.enemy.health - 40 - random() * 60);
					ThrowGib("progs/grenbone.mdl", self.enemy.health - 40 - random() * 60);
				}
				else
				{
					ThrowGib("progs/bone.mdl", self.enemy.health - 40 - random() * 60);
					ThrowGib("progs/bone2.mdl", self.enemy.health - 40 - random() * 60);
					ThrowGib("progs/bone.mdl", self.enemy.health - 40 - random() * 60);
				}
			}
			else
			{
				if (self.enemy.classname == "wall_explode")
				{
					sound(self, CHAN_AUTO, "enviro/physics/wallexpl.wav", WEAPON_SHOTGUN, ATTN_NORM);
				}
				else
				{
					sound(self, CHAN_AUTO, "weapons/r_exp3.wav", WEAPON_SHOTGUN, ATTN_NORM);
				}
			}
			self.cnt = MSG_BROADCAST;
			SpawnInternalFire2();
			return;
		}
	}
	else
	{
		if (self.enemy.health <= WEAPON_BIG && self.enemy.classname != "monster_zombie")
		{
			if (self.enemy.classname == "monster_ogre" || self.enemy.classname == "monster_ogre_marksman" && self.enemy.health - damg > -80)
			{
				T_Damage(self.enemy, self, self.owner.owner, damg);
				BecomeExplosion();
				return;
			}
			if (self.enemy.health > MSG_BROADCAST)
			{
				T_Damage(self.enemy, self, self.owner.owner, damg);
				if (self.enemy.classname != "monster_juggernaut" || self.enemy.classname != "monster_juggernaut2" || self.enemy.classname != "monster_spider" || self.enemy.classname != "misc_explobox" || self.enemy.classname != "misc_explobox2" || self.enemy.classname != "wall_explode")
				{
					sound(self, CHAN_AUTO, "enviro/physics/bonexpl.wav", WEAPON_SHOTGUN, ATTN_NORM);
					if (self.enemy.classname == "monster_gren" || self.enemy.classname == "monster_grenling" || self.enemy.classname == "monster_wizard" || self.enemy.classname == "monster_dog")
					{
						ThrowGib("progs/grenbone.mdl", self.enemy.health - 40 - random() * 60);
						ThrowGib("progs/grenbone.mdl", self.enemy.health - 40 - random() * 60);
						ThrowGib("progs/grenbone.mdl", self.enemy.health - 40 - random() * 60);
						ThrowGib("progs/grenbone.mdl", self.enemy.health - 40 - random() * 60);
						ThrowGib("progs/grenbone.mdl", self.enemy.health - 40 - random() * 60);
						ThrowGib("progs/grenbone.mdl", self.enemy.health - 40 - random() * 60);
					}
					else
					{
						ThrowGib("progs/bone.mdl", self.enemy.health - 80);
						ThrowGib("progs/xtragib.mdl", self.enemy.health - 80);
						ThrowGib("progs/bone2.mdl", self.enemy.health - 80);
					}
				}
				else
				{
					if (self.enemy.classname == "wall_explode")
					{
						sound(self, CHAN_AUTO, "enviro/physics/wallexpl.wav", WEAPON_SHOTGUN, ATTN_NORM);
					}
					else
					{
						sound(self, CHAN_AUTO, "weapons/r_exp3.wav", WEAPON_SHOTGUN, ATTN_NORM);
					}
				}
				SpawnInternalFire2();
				return;
			}
			else
			{
				if (self.enemy.classname != "monster_zombie")
				{
					T_Damage(self.enemy, self, self.owner, damg);
					BecomeExplosion();
					return;
				}
			}
		}
	}
	T_Damage(self.enemy, self, self.owner.owner, TE_WIZSPIKE + random() * WEAPON_SPIKES);
	if (self.enemy.health <= TE_LIGHTNING1 && self.enemy.classname == "player")
	{
		self.enemy.health = TE_LIGHTNING2;
	}
	self.nextthink = time + 0.25;
	if (self.cnt == MSG_BROADCAST)
	{
		flameanimate1();
	}
	self.cnt = self.cnt + WEAPON_SHOTGUN;
	if (self.cnt >= 18)
	{
		BecomeExplosion();
		return;
	}
	if (self.enemy.classname != "monster_zombie" && self.enemy.classname != "monster_juggernaut" && self.enemy.classname != "monster_juggernaut2")
	{
		self.origin = self.enemy.origin;
	}
	if (self.enemy.classname == "monster_zombie")
	{
		self.origin = self.enemy.origin - v_up * IT_NAPALM;
	}
	if (self.enemy.classname == "monster_juggernaut" || self.enemy.classname == "monster_juggernaut2")
	{
		self.origin = self.enemy.origin + v_up * IT_SPEAR;
	}
	self.think = InternalFireThink;
};

void() SpawnInternalFire = 
{
	local entity missile;
	local entity mpuff;
	missile = spawn();
	missile.movetype = MOVETYPE_NONE;
	missile.solid = SOLID_NOT;
	missile.owner = self;
	missile.enemy = other;
	missile.effects = EF_DIMLIGHT;
	missile.nextthink = time + 0.3;
	missile.think = InternalFireThink;
	missile.classname = "flame";
	if (other.classname == "monster_ogre" || other.classname == "monster_ogre_marksman" || other.classname == "monster_hell_knight")
	{
		setmodel(missile, "progs/flameo2.mdl");
	}
	else
	{
		setmodel(missile, "progs/flameo.mdl");
	}
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
	if (other.classname != "monster_zombie" && other.classname != "monster_juggernaut" || other.classname != "monster_juggernaut2")
	{
		setorigin(missile, other.origin);
	}
	if (other.classname == "monster_zombie")
	{
		setorigin(missile, other.origin - v_up * IT_NAPALM);
	}
	if (other.classname == "monster_juggernaut" || other.classname == "monster_juggernaut2")
	{
		setorigin(missile, other.origin - v_up * IT_SPEAR);
	}
};

void() BecomeBombExplosion = 
{
	sound(self, CHAN_WEAPON, "weapons/r_exp3.wav", WEAPON_SHOTGUN, ATTN_NORM);
	SpawnFireSpark();
	SpawnFireSpark();
	SpawnFireSpark();
	remove(self);
};

void() napalmrebound = 
{
	if (!(self.flags & FL_INWATER))
	{
		if (self.watertype == CONTENT_WATER)
		{
			sound(self, CHAN_WEAPON, "weapons/r_exp3.wav", WEAPON_SHOTGUN, ATTN_NORM);
			BecomeExplosion();
			return;
		}
		if (self.watertype == CONTENT_SLIME)
		{
			sound(self, CHAN_WEAPON, "weapons/r_exp3.wav", WEAPON_SHOTGUN, ATTN_NORM);
			BecomeExplosion();
			return;
		}
		if (self.watertype == CONTENT_LAVA)
		{
			sound(self, CHAN_WEAPON, "weapons/r_exp3.wav", WEAPON_SHOTGUN, ATTN_NORM);
			BecomeExplosion();
			return;
		}
	}
	sound(self, CHAN_WEAPON, "weapons/r_exp3.wav", WEAPON_SHOTGUN, ATTN_NORM);
	SpawnFireSpark();
	SpawnFireSpark();
	SpawnFireSpark();
	BecomeExplosion();
};

void() NapalmTouch = 
{
	if (other.takedamage && other.takedamage == DAMAGE_AIM && other.classname != "monster_spider" && other.classname != "monster_zombie" && other.classname != "monster_shambler" && other.classname != "monster_shalrath")
	{
		SpawnInternalFire();
	}
	self.origin = self.origin - WEAPON_BIG * normalize(self.velocity);
	self.think = napalmrebound;
	self.ltime = self.nextthink;
	self.nextthink = time;
};

void() W_FireNapalm = 
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
	missile.classname = "flame";
	missile.takedamage = DAMAGE_NO;
	makevectors(self.v_angle);
	if (self.v_angle_x)
	{
		missile.velocity = v_forward * 800 + v_up * 250 + crandom() * v_right * TE_LAVASPLASH + crandom() * v_up * TE_LAVASPLASH;
	}
	else
	{
		missile.velocity = aim(self, 10000);
		missile.velocity = missile.velocity * 600;
		missile.velocity_z = 200;
	}
	missile.avelocity = '300 300 300';
	missile.angles = vectoangles(missile.velocity);
	missile.touch = NapalmTouch;
	missile.nextthink = time + TE_LIGHTNING1;
	missile.think = SUB_Remove;
	setmodel(missile, "progs/nbomb.mdl");
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(missile, self.origin + v_right * TE_LIGHTNING2);
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
	sound(self, CHAN_WEAPON, "weapons/spike2.wav", WEAPON_SHOTGUN, ATTN_NORM);
	self.attack_finished = time + 0.2;
	self.currentammo = self.ammo_nails = self.ammo_nails - WEAPON_ROCKET;
	dir = aim(self, 1000);
	launch_spike(self.origin + '0 0 16', dir);
	newmis.classname = "superspike";
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
	if (self.ammo_nails < WEAPON_SHOTGUN)
	{
		self.weapon = W_BestWeapon();
		W_SetCurrentAmmo();
		return;
	}
	if (self.silencer == 1)
	{
		sound(self, CHAN_WEAPON, "weapons/rocket1i.wav", 0.2, ATTN_NORM);
	}
	else
	{
		sound(self, CHAN_WEAPON, "weapons/rocket1i.wav", WEAPON_SHOTGUN, ATTN_NORM);
	}
	self.attack_finished = time + 0.2;
	self.currentammo = self.ammo_nails = self.ammo_nails - WEAPON_SHOTGUN;
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
		spawn_touchblood(TE_LIGHTNING3, other);
		T_Damage(other, self, self.owner, TE_LIGHTNING3);
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
		spawn_touchblood(18, other);
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

void() W_FireSpear = 
{
	local entity missile;
	local float r;
	r = random();
	self.currentammo = self.ammo_rockets = self.ammo_rockets - WEAPON_SHOTGUN;
	missile = spawn();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	missile.classname = "spear";
	makevectors(self.v_angle);
	missile.velocity = aim(self, 2000);
	missile.velocity = missile.velocity * 2000;
	missile.angles = vectoangles(missile.velocity);
	missile.movedir = missile.velocity;
	missile.avelocity_z = crandom() * 500;
	missile.count = MSG_BROADCAST;
	missile.touch = T_SpearTouch;
	missile.nextthink = time + TE_LIGHTNING1;
	missile.think = SUB_Remove;
	setmodel(missile, "progs/impaler.mdl");
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(missile, self.origin + v_forward * WEAPON_BIG + '0 0 16');
	if (self.flags & FL_ONGROUND)
	{
		self.flags = self.flags - FL_ONGROUND;
		self.origin = self.origin + '0 0 1';
	}
	self.velocity = self.velocity - v_forward * (600 - self.armorvalue) + '0 0 50';
	self.punchangle_x = -10;
};

void() ReleaseHead = 
{
	self.origin = self.origin - v_forward * IT_NAPALM;
	self.movetype = MOVETYPE_BOUNCE;
	self.nextthink = CONTENT_EMPTY;
};

void() HeadCheckEnemyDead = 
{
	if (!(self.enemy))
	{
		return;
	}
	if (self.enemy.velocity == VEC_ORIGIN)
	{
		self.origin = self.owner.origin - v_forward * WEAPON_BIG - v_up * WEAPON_SPIKES;
		self.movetype = MOVETYPE_NONE;
		self.nextthink = time;
		self.think = ReleaseHead;
		return;
	}
	self.origin = self.owner.origin - v_forward * WEAPON_BIG - v_up * WEAPON_SPIKES;
	self.velocity = VEC_ORIGIN;
	self.nextthink = time + 0.1;
	self.think = HeadCheckEnemyDead;
};

void() ImpaleHead = 
{
	self.origin = self.owner.origin - v_forward * WEAPON_BIG - v_up * WEAPON_SPIKES;
	self.movetype = MOVETYPE_NONE;
	self.nextthink = time + 0.1;
	self.think = HeadCheckEnemyDead;
};

void() T_SpearTouch = 
{
	local float knockback;
	local float r;
	local entity missile;
	local entity new;
	if (other == self.owner)
	{
		return;
	}
	r = random();
	if (other.takedamage && (other.flags & (FL_CLIENT | FL_MONSTER)))
	{
		setmodel(self, "progs/impstuck.mdl");
		if (other.flags & FL_CLIENT)
		{
			knockback = 400 - other.armorvalue * AS_MELEE;
		}
		else
		{
			if (other.classname == "monster_dog")
			{
				knockback = 550;
			}
			else
			{
				if (other.classname == "monster_zombie")
				{
					knockback = 250;
				}
				else
				{
					if (other.classname == "monster_army")
					{
						knockback = 450;
					}
					else
					{
						if (other.classname == "monster_knight" || other.classname == "monster_dknight")
						{
							knockback = 250;
						}
						else
						{
							if (other.classname == "monster_enforcer" || other.classname == "monster_lenforcer")
							{
								knockback = 300;
							}
							else
							{
								if (other.classname == "monster_ogre" || other.classname == "monster_ogre_marksman")
								{
									knockback = 100;
								}
								else
								{
									if (other.classname == "monster_hell_knight")
									{
										knockback = 150;
									}
									else
									{
										if (other.classname == "monster_grenling" || other.classname == "monster_gren")
										{
											knockback = 550;
										}
										else
										{
											if (other.classname == "monster_shalrath")
											{
												knockback = 100;
											}
											else
											{
												knockback = MSG_BROADCAST;
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
		if (knockback > TE_LAVASPLASH)
		{
			if (other.flags & FL_ONGROUND)
			{
				other.flags = other.flags - FL_ONGROUND;
				other.origin = other.origin + '0 0 1';
			}
			makevectors(self.angles);
			other.velocity = other.velocity + v_forward * knockback;
			other.velocity_z = other.velocity_z + knockback / WEAPON_ROCKET;
		}
	}
	if (other.takedamage && (other.classname == "monster_juggernaut" || other.classname == "monster_juggernaut2" || other.classname == "monster_reactor" || other.classname == "monster_boss" || other.classname == "monster_oldone" || other.classname == "monster_legond" || other.classname == "monster_knight" || other.classname == "monster_dknight" || other.classname == "monster_hell_knight" || other.classname == "monster_shambler" || (other.classname == "player" && other.armorvalue > WEAPON_SHOTGUN)))
	{
		setmodel(self, "progs/impdef.mdl");
		T_Damage(other, self, self.owner, 50);
		if (r < 0.4)
		{
			sound(self, CHAN_WEAPON, "weapons/impaler/impdef1.wav", WEAPON_SHOTGUN, ATTN_NORM);
		}
		else
		{
			if (r < 0.7)
			{
				sound(self, CHAN_WEAPON, "weapons/impaler/impdef2.wav", WEAPON_SHOTGUN, ATTN_NORM);
			}
			else
			{
				sound(self, CHAN_WEAPON, "weapons/impaler/impdef3.wav", WEAPON_SHOTGUN, ATTN_NORM);
			}
		}
		if (other.health > MSG_BROADCAST)
		{
			T_Damage(other, self, self.owner, 50);
		}
		self.movetype = MOVETYPE_BOUNCE;
		self.velocity = self.velocity * 0.35;
		self.avelocity = '300 300 300';
		self.solid = SOLID_NOT;
		setsize(self, VEC_ORIGIN, VEC_ORIGIN);
		self.think = Spear_Bounce_Think;
		self.nextthink = time + 0.5;
		self.count = time + AS_MELEE;
	}
	else
	{
		if (other.classname == "monster_army" || other.classname == "monster_wizard" || other.classname == "monster_dog" && random() < 0.5 || other.classname == "monster_fish")
		{
			T_Damage(other, self, self.owner, 5000);
			missile = spawn();
			missile.owner = self.owner;
			missile.movetype = MOVETYPE_FLYMISSILE;
			missile.solid = SOLID_BBOX;
			missile.classname = "spear";
			makevectors(self.angles);
			missile.velocity = self.movedir;
			missile.angles = vectoangles(missile.velocity);
			missile.movedir = missile.velocity;
			missile.avelocity_z = crandom() * 500;
			missile.count = MSG_BROADCAST;
			missile.touch = T_SpearTouch;
			other.nextthink = time + WEAPON_SPIKES;
			other.think = SUB_Remove;
			setmodel(missile, "progs/impstuck.mdl");
			setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
			setorigin(missile, self.origin + v_forward);
			remove(self);
		}
		else
		{
			if (other.takedamage && (other.flags & (FL_CLIENT | FL_MONSTER)) && other.armorvalue == MSG_BROADCAST && (other.classname == "player" || other.classname == "monster_enforcer" || other.classname == "monster_lenforcer" || other.classname == "monster_ogre" || other.classname == "monster_ogre_marksman" || other.classname == "monster_demon1" || other.classname == "monster_blud" || other.classname == "monster_babyblud" || other.classname == "monster_grenling" || other.classname == "monster_gren" || other.classname == "monster_army" || other.classname == "monster_dog" || other.classname == "monster_wizard" || other.classname == "wall_explode"))
			{
				setmodel(self, "progs/impstuck.mdl");
				sound(self, CHAN_WEAPON, "weapons/impaler/impale.wav", WEAPON_SHOTGUN, ATTN_NORM);
				if (other.classname == "player" || other.classname == "monster_enforcer" || other.classname == "monster_lenforcer")
				{
					BecomeBloodSpurt(25);
					T_Damage(other, self, self.owner, 25);
					BecomeBloodSpurt(25);
				}
				if (!(other.classname == "monster_grenling" || other.classname == "monster_gren" || other.classname == "monster_army" || other.classname == "monster_dog" || other.classname == "monster_wizard" || other.classname == "monster_fish"))
				{
					BecomeBloodSpurt(25);
					T_Damage(other, self, self.owner, 25);
					BecomeBloodSpurt(25);
				}
				self.enemy = other;
				self.cnt = self.enemy.health;
				self.movetype = MOVETYPE_NONE;
				self.solid = SOLID_NOT;
				self.origin = self.origin + normalize(self.velocity) * SVC_INTERMISSION;
				self.v_angle = self.angles - self.enemy.angles;
				self.mangle = self.origin - self.enemy.origin;
				self.mangle_x = self.mangle_x * 0.05;
				self.mangle_y = self.mangle_y * 0.05;
				self.mangle_z = self.mangle_z * 0.1 + TE_LAVASPLASH;
				self.think = SpearThink;
				self.nextthink = time + 0.1;
				if (other.classname == "monster_grenling" || other.classname == "monster_gren" || other.classname == "monster_army" || other.classname == "monster_dog" || other.classname == "monster_wizard" || other.classname == "monster_fish")
				{
					T_Damage(other, self, self.owner, 5000);
					BecomeBloodSpurt(5000);
				}
			}
			else
			{
				if (other.takedamage)
				{
					setmodel(self, "progs/impdef.mdl");
					sound(self, CHAN_WEAPON, "weapons/impaler/impale.wav", WEAPON_SHOTGUN, ATTN_NORM);
					T_Damage(other, self, self.owner, 50);
					BecomePurpleExplosion(50);
					if (r < 0.4)
					{
						sound(self, CHAN_WEAPON, "weapons/impaler/impdef1.wav", WEAPON_SHOTGUN, ATTN_NORM);
					}
					else
					{
						if (r < 0.7)
						{
							sound(self, CHAN_WEAPON, "weapons/impaler/impdef2.wav", WEAPON_SHOTGUN, ATTN_NORM);
						}
						else
						{
							sound(self, CHAN_WEAPON, "weapons/impaler/impdef3.wav", WEAPON_SHOTGUN, ATTN_NORM);
						}
					}
					BecomePurpleExplosion(50);
					self.movetype = MOVETYPE_BOUNCE;
					self.velocity = self.velocity * 0.05;
					self.avelocity = '300 300 300';
					self.solid = SOLID_NOT;
					setsize(self, VEC_ORIGIN, VEC_ORIGIN);
					self.think = Spear_Bounce_Think;
					self.nextthink = time + 0.5;
					self.count = time + AS_MELEE;
				}
				else
				{
					if (other.classname == "door" || other.classname == "train" || other.classname == "plat" || (other.flags & (FL_CLIENT | FL_MONSTER)))
					{
						setmodel(self, "progs/impwall.mdl");
						BecomePurpleExplosion(50);
						sound(self, CHAN_WEAPON, "weapons/impaler/impwall.wav", WEAPON_SHOTGUN, ATTN_NORM);
						BecomePurpleExplosion(50);
						self.movetype = MOVETYPE_BOUNCE;
						self.velocity = self.velocity * 0.35;
						self.avelocity = '300 300 300';
						self.solid = SOLID_NOT;
						setsize(self, VEC_ORIGIN, VEC_ORIGIN);
						self.think = Spear_Bounce_Think;
						self.nextthink = time + 0.5;
						self.count = time + AS_MELEE;
					}
					else
					{
						setmodel(self, "progs/impwall.mdl");
						sound(self, CHAN_WEAPON, "weapons/impaler/impwall.wav", WEAPON_SHOTGUN, ATTN_NORM);
						BecomePurpleExplosion(50);
						makevectors(self.angles);
						self.origin = self.origin + normalize(self.velocity) * CONTENT_SLIME;
						self.movetype = MOVETYPE_NONE;
						self.solid = SOLID_NOT;
						self.nextthink = time + 0.1;
						self.think = SpearDig;
					}
				}
			}
		}
	}
};

void() SpearDig3 = 
{
	local float r;
	r = random();
	self.nextthink = time + r + WEAPON_SHOTGUN;
	self.think = SpearExplosion;
	BecomePurpleExplosion(counter);
	if (r < 0.3)
	{
		sound(self, CHAN_AUTO, "weapons/impaler/shaft1.wav", WEAPON_SHOTGUN, ATTN_NORM);
	}
	if (r < 0.6)
	{
		sound(self, CHAN_AUTO, "weapons/impaler/shaft2.wav", WEAPON_SHOTGUN, ATTN_NORM);
	}
	else
	{
		sound(self, CHAN_AUTO, "weapons/impaler/shaft3.wav", WEAPON_SHOTGUN, ATTN_NORM);
	}
	BecomePurpleExplosion(counter);
};

void() SpearDig2 = 
{
	local float r;
	r = random();
	self.nextthink = time + r;
	self.think = SpearDig3;
	BecomePurpleExplosion(counter);
	if (r < 0.3)
	{
		sound(self, CHAN_AUTO, "weapons/impaler/shaft1.wav", WEAPON_SHOTGUN, ATTN_NORM);
	}
	if (r < 0.6)
	{
		sound(self, CHAN_AUTO, "weapons/impaler/shaft2.wav", WEAPON_SHOTGUN, ATTN_NORM);
	}
	else
	{
		sound(self, CHAN_AUTO, "weapons/impaler/shaft3.wav", WEAPON_SHOTGUN, ATTN_NORM);
	}
	BecomePurpleExplosion(counter);
};

void() SpearDig = 
{
	local float r;
	r = random();
	self.nextthink = time + r;
	self.think = SpearDig2;
	BecomePurpleExplosion(counter);
	if (r < 0.3)
	{
		sound(self, CHAN_AUTO, "weapons/impaler/shaft1.wav", WEAPON_SHOTGUN, ATTN_NORM);
	}
	if (r < 0.6)
	{
		sound(self, CHAN_AUTO, "weapons/impaler/shaft2.wav", WEAPON_SHOTGUN, ATTN_NORM);
	}
	else
	{
		sound(self, CHAN_AUTO, "weapons/impaler/shaft3.wav", WEAPON_SHOTGUN, ATTN_NORM);
	}
	BecomePurpleExplosion(counter);
};

void() ImpaledGibs = 
{
	ThrowHead("progs/gib3.mdl", self.health);
	ThrowGib("progs/gib2.mdl", self.health);
	ThrowGib("progs/gib2.mdl", self.health);
	ThrowGib("progs/gib1.mdl", self.health);
	ThrowGib("progs/rawbone.mdl", self.health);
	ThrowGib("progs/xtragib.mdl", self.health);
	ThrowGib("progs/rawbone2.mdl", self.health);
	if (self.classname == "player")
	{
		self.impaled = 0;
	}
};

void() ImpaledExplosion = 
{
	if (self.enemy.health <= MSG_BROADCAST)
	{
		T_RadiusDamage(self, self.owner, 60, other);
		BecomeBloodSpurt(60);
		self.enemy.health = self.enemy.health - 60 - random() * 100;
		self.origin = self.origin - WEAPON_BIG * normalize(self.velocity);
		self.enemy.think = ImpaledGibs;
		self.enemy.nextthink = time;
		sound(self.enemy, CHAN_VOICE, "player/udeath.wav", WEAPON_SHOTGUN, ATTN_NORM);
		BecomeBloodSpurt(60);
		sound(self.enemy, CHAN_BODY, "weapons/impaler/impex.wav", WEAPON_SHOTGUN, ATTN_NORM);
	}
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord(MSG_BROADCAST, self.origin_x);
	WriteCoord(MSG_BROADCAST, self.origin_y);
	WriteCoord(MSG_BROADCAST, self.origin_z);
	BecomeExplosion();
};

void() SpearExplosion = 
{
	T_RadiusDamage(self, self.owner, 60, other);
	self.origin = self.origin - IT_NAPALM * normalize(self.velocity);
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord(MSG_BROADCAST, self.origin_x);
	WriteCoord(MSG_BROADCAST, self.origin_y);
	WriteCoord(MSG_BROADCAST, self.origin_z);
	BecomeExplosion();
};

void() SpearGo3 = 
{
	local float r;
	r = random();
	BecomeBloodSpurt(counter);
	self.nextthink = time + r + WEAPON_SHOTGUN;
	BecomeBloodSpurt(counter);
	self.think = ImpaledExplosion;
	BecomePurpleExplosion(counter);
	if (r < 0.3)
	{
		sound(self, CHAN_AUTO, "weapons/impaler/shaft1.wav", WEAPON_SHOTGUN, ATTN_NORM);
	}
	if (r < 0.6)
	{
		sound(self, CHAN_AUTO, "weapons/impaler/shaft2.wav", WEAPON_SHOTGUN, ATTN_NORM);
	}
	else
	{
		sound(self, CHAN_AUTO, "weapons/impaler/shaft3.wav", WEAPON_SHOTGUN, ATTN_NORM);
	}
	BecomePurpleExplosion(counter);
};

void() SpearGo2 = 
{
	local float r;
	r = random();
	BecomeBloodSpurt(counter);
	self.nextthink = time + WEAPON_SHOTGUN + r;
	BecomeBloodSpurt(counter);
	self.think = SpearGo3;
	BecomePurpleExplosion(counter);
	if (r < 0.3)
	{
		sound(self, CHAN_AUTO, "weapons/impaler/shaft1.wav", WEAPON_SHOTGUN, ATTN_NORM);
	}
	if (r < 0.6)
	{
		sound(self, CHAN_AUTO, "weapons/impaler/shaft2.wav", WEAPON_SHOTGUN, ATTN_NORM);
	}
	else
	{
		sound(self, CHAN_AUTO, "weapons/impaler/shaft3.wav", WEAPON_SHOTGUN, ATTN_NORM);
	}
	BecomePurpleExplosion(counter);
};

void() SpearGo = 
{
	local float r;
	r = random();
	BecomeBloodSpurt(counter);
	self.nextthink = time + WEAPON_SHOTGUN + r;
	BecomeBloodSpurt(counter);
	self.think = SpearGo2;
	BecomePurpleExplosion(counter);
	if (r < 0.3)
	{
		sound(self, CHAN_AUTO, "weapons/impaler/shaft1.wav", WEAPON_SHOTGUN, ATTN_NORM);
	}
	if (r < 0.6)
	{
		sound(self, CHAN_AUTO, "weapons/impaler/shaft2.wav", WEAPON_SHOTGUN, ATTN_NORM);
	}
	else
	{
		sound(self, CHAN_AUTO, "weapons/impaler/shaft3.wav", WEAPON_SHOTGUN, ATTN_NORM);
	}
	BecomePurpleExplosion(counter);
};

void() SpearThink = 
{
	local entity fork;
	setorigin(self, self.enemy.origin + self.mangle);
	self.angles = self.enemy.angles + self.v_angle;
	if (self.enemy.flags & FL_CLIENT || self.enemy.classname == "monster_enforcer" || self.enemy.classname == "player" || self.enemy.classname == "monster_lenforcer")
	{
		if (!(self.flags & FL_NOTARGET))
		{
			makevectors(self.angles);
			traceline(self.origin + v_forward * 20, self.origin, 1, self);
			if (trace_startsolid)
			{
				self.classname = "impaler";
				self.enemy.health = WEAPON_SHOTGUN;
				BecomeBloodSpurt(15);
				T_Damage(self.enemy, self, self.owner, 15);
				BecomeBloodSpurt(15);
				fork = spawn();
				fork.solid = SOLID_NOT;
				setorigin(fork, self.origin - v_forward * TE_LAVASPLASH);
				fork.nextthink = time;
				fork.think = SUB_Null;
				self.solid = SOLID_NOT;
				self.nextthink = time + 0.1;
				self.think = SpearGo;
				return;
			}
		}
	}
	if (self.enemy.flags & FL_ONGROUND && !(self.flags & FL_NOTARGET))
	{
		self.flags = FL_NOTARGET;
		BecomeBloodSpurt(37);
		T_Damage(self.enemy, self, self.owner, 37);
		BecomeBloodSpurt(37);
	}
	if (self.enemy.health <= MSG_BROADCAST || self.enemy.health > self.cnt || random() < 0.010000)
	{
		self.movetype = MOVETYPE_BOUNCE;
		self.velocity = self.velocity * 0.05;
		self.avelocity = '300 300 300';
		self.solid = SOLID_NOT;
		setsize(self, VEC_ORIGIN, VEC_ORIGIN);
		self.think = Spear_Bounce_Think;
		self.nextthink = time + 0.5;
		self.count = time + AS_MELEE;
		return;
	}
	self.cnt = self.enemy.health;
	self.count = self.count + WEAPON_SHOTGUN;
	if (random() * TE_LAVASPLASH < self.count)
	{
		SpawnBlood(self.origin, VEC_ORIGIN, self.count, self.enemy);
		BecomeBloodSpurt(self.count / WEAPON_ROCKET);
		T_Damage(self.enemy, self, self.owner, self.count / WEAPON_ROCKET);
		if (self.enemy.health <= TE_LIGHTNING1 && self.enemy.classname == "player")
		{
			T_Damage(self.enemy, self, self.owner, TE_LIGHTNING1);
		}
		BecomeBloodSpurt(self.count / WEAPON_ROCKET);
		self.count = MSG_BROADCAST;
	}
	self.nextthink = time + 0.1;
};

void() Spear_Bounce_Think = 
{
	if (self.velocity == VEC_ORIGIN || self.count < time)
	{
		remove(self);
	}
	else
	{
		self.nextthink = time + 0.1;
	}
};

void() impale = 
{
	if (self.classname == "monster_enforcer" || self.classname == "monster_lenforcer")
	{
		sound(self, CHAN_BODY, "player/udeath.wav", WEAPON_SHOTGUN, ATTN_NORM);
		BecomeBloodSpurt(counter);
		sound(self, CHAN_ITEM, "weapons/impaler/mimpale.wav", WEAPON_SHOTGUN, ATTN_NORM);
		BecomeBloodSpurt(counter);
		self.movetype = MOVETYPE_NONE;
		self.solid = SOLID_NOT;
		self.think = SUB_Null;
		self.ammo_shells = TE_LIGHTNING1;
		DropBackpack();
		if (random() < 0.2)
		{
			self.frame = 83;
		}
		else
		{
			if (random() < 0.4)
			{
				self.frame = 79;
			}
			else
			{
				if (random() < 0.6)
				{
					self.frame = 80;
				}
				else
				{
					if (random() < 0.8)
					{
						self.frame = 78;
					}
					else
					{
						self.frame = 84;
					}
				}
			}
		}
	}
	else
	{
		if (self.classname == "player")
		{
			self.impaled = 1;
			self.items = self.items - (self.items & IT_INVISIBILITY);
			self.invisible_finished = MSG_BROADCAST;
			self.invincible_finished = MSG_BROADCAST;
			self.super_damage_finished = MSG_BROADCAST;
			self.radsuit_finished = MSG_BROADCAST;
			self.modelindex = modelindex_player;
			if (deathmatch || coop)
			{
				DropBackpack();
			}
			self.weaponmodel = string_null;
			self.view_ofs = '0 0 -4';
			self.nextthink = CONTENT_EMPTY;
			self.deadflag = DEAD_DEAD;
			self.solid = SOLID_NOT;
			self.flags = self.flags - (self.flags & FL_ONGROUND);
			self.movetype = MOVETYPE_NONE;
			BecomeBloodSpurt(counter);
			DeathSound();
			BecomeBloodSpurt(counter);
			sound(self, CHAN_ITEM, "weapons/impaler/pimpale.wav", WEAPON_SHOTGUN, ATTN_NORM);
			BecomeBloodSpurt(counter);
			self.angles_x = MSG_BROADCAST;
			self.angles_z = MSG_BROADCAST;
			if (self.weapon == IT_AXE)
			{
				if (random() < 0.3)
				{
					self.frame = SVC_FINALE;
				}
				else
				{
					if (random() < 0.6)
					{
						self.frame = 35;
					}
					else
					{
						self.frame = 42;
					}
				}
			}
			else
			{
				if (random() < 0.3)
				{
					self.frame = 61;
				}
				else
				{
					if (random() < 0.6)
					{
						self.frame = 71;
					}
					else
					{
						self.frame = 87;
					}
				}
			}
		}
	}
};

void() W_SetCurrentAmmo = 
{
	if (self.exptime != MSG_BROADCAST)
	{
		return;
	}
	player_run();
	self.items = self.items - (self.items & (IT_SHELLS | IT_NAILS | IT_ROCKETS | IT_CELLS));
	if (self.flags & FL_IMPELWEAPON && self.weapon == IT_NAPALM)
	{
		self.currentammo = self.ammo_rockets;
		self.weaponframe = MSG_BROADCAST;
		self.items = self.items | IT_ROCKETS;
		self.weaponmodel = "progs/v_srock.mdl";
	}
	else
	{
		if (self.flags & FL_IMPELWEAPON && self.weapon == IT_LIGHTME)
		{
			self.currentammo = self.ammo_cells;
			self.weaponmodel = "progs/v_light2.mdl";
			self.weaponframe = MSG_BROADCAST;
			self.items = self.items | IT_CELLS;
		}
		else
		{
			if (self.flags & FL_IMPELWEAPON && self.weapon == IT_SPEAR)
			{
				self.currentammo = self.ammo_rockets;
				self.weaponmodel = "progs/v_implr.mdl";
				self.weaponframe = MSG_BROADCAST;
				self.items = self.items | IT_ROCKETS;
			}
			else
			{
				if (self.flags & FL_IMPELWEAPON && self.weapon == IT_PULSERIFLE && (self.impelitems & IT_PULSEPOWER2))
				{
					self.currentammo = self.ammo_cells;
					self.weaponmodel = "progs/null.mdl";
					self.weaponframe = MSG_BROADCAST;
					self.items = self.items | IT_CELLS;
				}
				else
				{
					if (self.flags & FL_IMPELWEAPON && (self.flags & FL_IMPELWEAPON) && self.weapon == IT_PULSERIFLE && (self.impelitems & IT_PULSEPOWER1))
					{
						self.currentammo = self.ammo_cells;
						self.weaponmodel = "progs/null.mdl";
						self.weaponframe = MSG_BROADCAST;
						self.items = self.items | IT_CELLS;
					}
					else
					{
						if (self.flags & FL_IMPELWEAPON && self.weapon == IT_PULSERIFLE)
						{
							self.currentammo = self.ammo_cells;
							self.weaponmodel = "progs/null.mdl";
							self.weaponframe = MSG_BROADCAST;
							self.items = self.items | IT_CELLS;
						}
						else
						{
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
															self.currentammo = MSG_BROADCAST;
															self.weaponmodel = string_null;
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

float() NoAmmo = 
{
	self.weapon = W_BestWeapon();
	self.flags = self.flags - (self.flags & FL_IMPELWEAPON);
	W_SetCurrentAmmo();
	return 0;
};

float() W_CheckNoAmmo = 
{
	if (self.currentammo < WEAPON_SHOTGUN && self.weapon == IT_SPEAR && (self.flags & FL_IMPELWEAPON))
	{
		return NoAmmo();
	}
	if (self.currentammo > MSG_BROADCAST)
	{
		return 1;
	}
	if (self.weapon == IT_AXE)
	{
		return 1;
	}
	return NoAmmo();
};

void() W_Attack = 
{
	local float r;
	if (self.exptime != MSG_BROADCAST)
	{
		return;
	}
	if (!W_CheckNoAmmo())
	{
		return;
	}
	makevectors(self.v_angle);
	self.show_hostile = time + WEAPON_SHOTGUN;
	if (!(self.flags & FL_IMPELWEAPON))
	{
		if (self.weapon == IT_AXE)
		{
			r = random();
			if (r < 0.7)
			{
				sound(self, CHAN_WEAPON, "weapons/ax1.wav", WEAPON_SHOTGUN, ATTN_NORM);
			}
			else
			{
				sound(self, CHAN_WEAPON, "zombie/z_shot1.wav", WEAPON_SHOTGUN, ATTN_NORM);
			}
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
			r = random();
			if (r < 0.5)
			{
				self.attack_finished = time + 0.4;
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
		if (self.weapon == IT_NAPALM)
		{
			if (self.cnt < AS_MELEE)
			{
				player_rocket1();
				W_FireNapalm();
				self.attack_finished = time + 0.6;
				self.cnt = self.cnt + WEAPON_SHOTGUN;
			}
			else
			{
				sound(self, CHAN_WEAPON, "weapons/pkup.wav", WEAPON_SHOTGUN, ATTN_NORM);
				self.attack_finished = time + 0.9;
				self.cnt = MSG_BROADCAST;
			}
		}
		else
		{
			if (self.weapon == IT_LIGHTME)
			{
				player_superlight1();
				if (self.ammo_cells < WEAPON_SHOTGUN)
				{
					self.ammo_cells = MSG_BROADCAST;
					W_SetCurrentAmmo();
				}
			}
			else
			{
				if (self.weapon == IT_SPEAR)
				{
					player_shotimp1();
					self.attack_finished = time + WEAPON_SHOTGUN;
				}
				else
				{
					if (self.weapon == IT_PULSERIFLE)
					{
						if (self.impelitems & IT_PULSEPOWER2)
						{
							if (self.currentammo < WEAPON_SPIKES)
							{
								self.weapon = W_BestWeapon();
								self.flags = self.flags - (self.flags & FL_IMPELWEAPON);
								W_SetCurrentAmmo();
								return;
							}
							player_rifle1();
							if (self.cnt == WEAPON_ROCKET)
							{
								W_FireRifleL();
								W_FireRifleM();
								self.attack_finished = time + 0.4;
								self.cnt = MSG_BROADCAST;
							}
							else
							{
								if (self.cnt == WEAPON_SHOTGUN)
								{
									W_FireRifleJ();
									W_FireRifleK();
									self.attack_finished = time + 0.1;
									self.cnt = WEAPON_ROCKET;
								}
								else
								{
									if (self.cnt == MSG_BROADCAST)
									{
										W_FireRifleH();
										W_FireRifleI();
										self.attack_finished = time + 0.1;
										self.cnt = WEAPON_SHOTGUN;
									}
								}
							}
						}
						else
						{
							if (self.impelitems & IT_PULSEPOWER1)
							{
								if (self.currentammo < AS_MELEE)
								{
									self.weapon = W_BestWeapon();
									self.flags = self.flags - (self.flags & FL_IMPELWEAPON);
									W_SetCurrentAmmo();
									return;
								}
								player_rifle1();
								W_FireRifleTarget();
								W_FireRifleD();
								W_FireRifleC();
								W_FireRifleB();
								self.attack_finished = time + 0.6;
							}
							else
							{
								if (self.currentammo < WEAPON_ROCKET)
								{
									self.weapon = W_BestWeapon();
									self.flags = self.flags - (self.flags & FL_IMPELWEAPON);
									W_SetCurrentAmmo();
									return;
								}
								player_rifle1();
								W_FireRifleA();
								W_FireRifle2A();
								W_FireRifle3A();
								self.attack_finished = time + 0.7;
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
	local float ii;
	it = self.items;
	am = MSG_BROADCAST;
	ii = MSG_BROADCAST;
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
					if (self.impulse == TE_LIGHTNING1)
					{
						fl = IT_SUPER_NAILGUN;
						if (self.ammo_nails < WEAPON_ROCKET)
						{
							am = WEAPON_SHOTGUN;
						}
					}
					else
					{
						if (self.impulse == TE_LIGHTNING2 && !(self.items & IT_GRENADE_LAUNCHER) && (self.impelitems & IT_NAPALM))
						{
							fl = IT_NAPALM;
							if (self.ammo_rockets < WEAPON_SHOTGUN)
							{
								am = WEAPON_SHOTGUN;
							}
							ii = WEAPON_SHOTGUN;
						}
						else
						{
							if (self.impulse == TE_LIGHTNING2 && self.weapon == IT_GRENADE_LAUNCHER && (self.impelitems & IT_NAPALM) && !(self.flags & FL_IMPELWEAPON))
							{
								fl = IT_NAPALM;
								if (self.ammo_rockets < WEAPON_SHOTGUN)
								{
									am = WEAPON_SHOTGUN;
								}
								ii = WEAPON_SHOTGUN;
							}
							else
							{
								if (self.impulse == TE_LIGHTNING2)
								{
									fl = IT_GRENADE_LAUNCHER;
									if (self.ammo_rockets < WEAPON_SHOTGUN)
									{
										am = WEAPON_SHOTGUN;
									}
								}
								else
								{
									if (self.impulse == TE_WIZSPIKE && !(self.items & IT_ROCKET_LAUNCHER) && (self.impelitems & IT_SPEAR))
									{
										ii = WEAPON_SHOTGUN;
										fl = IT_SPEAR;
										if (self.ammo_rockets < WEAPON_SHOTGUN)
										{
											am = WEAPON_SHOTGUN;
										}
									}
									else
									{
										if (self.impulse == TE_WIZSPIKE && self.weapon == IT_ROCKET_LAUNCHER && (self.impelitems & IT_SPEAR) && !(self.flags & FL_IMPELWEAPON))
										{
											ii = WEAPON_SHOTGUN;
											fl = IT_SPEAR;
											if (self.ammo_rockets < WEAPON_SHOTGUN)
											{
												am = WEAPON_SHOTGUN;
											}
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
												if (self.impulse == WEAPON_BIG && !(self.items & IT_LIGHTNING) && (self.impelitems & IT_LIGHTME))
												{
													ii = WEAPON_SHOTGUN;
													fl = IT_LIGHTME;
													if (self.ammo_cells < WEAPON_ROCKET)
													{
														am = WEAPON_SHOTGUN;
													}
												}
												else
												{
													if (self.impulse == WEAPON_BIG && self.weapon == IT_LIGHTNING && (self.impelitems & IT_LIGHTME) && !(self.flags & FL_IMPELWEAPON))
													{
														ii = WEAPON_SHOTGUN;
														fl = IT_LIGHTME;
														if (self.ammo_cells < WEAPON_ROCKET)
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
															if (self.impulse == 14 && (self.impelitems & IT_PULSEPOWER2))
															{
																if (self.weapon == IT_PULSERIFLE)
																{
																	return;
																}
																ii = WEAPON_SHOTGUN;
																fl = IT_PULSERIFLE;
																if (self.ammo_cells < WEAPON_SPIKES)
																{
																	am = WEAPON_SHOTGUN;
																}
															}
															else
															{
																if (self.impulse == 14 && (self.impelitems & IT_PULSEPOWER1))
																{
																	if (self.weapon == IT_PULSERIFLE)
																	{
																		return;
																	}
																	ii = WEAPON_SHOTGUN;
																	fl = IT_PULSERIFLE;
																	if (self.ammo_cells < AS_MELEE)
																	{
																		am = WEAPON_SHOTGUN;
																	}
																}
																else
																{
																	if (self.impulse == 14 && self.impelitems)
																	{
																		if (self.weapon == IT_PULSERIFLE)
																		{
																			return;
																		}
																		ii = WEAPON_SHOTGUN;
																		fl = IT_PULSERIFLE;
																		if (self.ammo_cells < WEAPON_ROCKET)
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
							}
						}
					}
				}
			}
		}
	}
	self.impulse = MSG_BROADCAST;
	if (ii)
	{
		if (!(self.impelitems & fl))
		{
			sprint(self, "no weapon.\n");
			return;
		}
	}
	else
	{
		if (!(self.items & fl))
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
	if (ii)
	{
		self.flags = self.flags | FL_IMPELWEAPON;
	}
	else
	{
		self.flags = self.flags - (self.flags & FL_IMPELWEAPON);
	}
	W_SetCurrentAmmo();
	if (self.flags & FL_IMPELWEAPON && (self.flags & FL_IMPELWEAPON) && self.weapon == IT_PULSERIFLE && (self.impelitems & IT_PULSEPOWER2))
	{
		sound(self, CHAN_AUTO, "weapons/pulse/install.wav", WEAPON_SHOTGUN, ATTN_NORM);
		sound(self, CHAN_WEAPON, "enviro/pinhead/pinfire.wav", WEAPON_SHOTGUN, ATTN_NORM);
		centerprint(self, "[ LEVEL III LASER SYSTEM SELECTED ]\n");
		stuffcmd(self, "bf\n");
	}
	else
	{
		if (self.flags & FL_IMPELWEAPON && (self.flags & FL_IMPELWEAPON) && self.weapon == IT_PULSERIFLE && (self.impelitems & IT_PULSEPOWER1))
		{
			sound(self, CHAN_AUTO, "weapons/pulse/install.wav", WEAPON_SHOTGUN, ATTN_NORM);
			sound(self, CHAN_WEAPON, "enviro/pinhead/pinfire.wav", WEAPON_SHOTGUN, ATTN_NORM);
			centerprint(self, "[ LEVEL II LASER SYSTEM SELECTED ]\n");
			stuffcmd(self, "bf\n");
		}
		else
		{
			if (self.flags & FL_IMPELWEAPON && self.weapon == IT_PULSERIFLE)
			{
				sound(self, CHAN_AUTO, "weapons/pulse/install.wav", WEAPON_SHOTGUN, ATTN_NORM);
				sound(self, CHAN_WEAPON, "enviro/pinhead/pinfire.wav", WEAPON_SHOTGUN, ATTN_NORM);
				centerprint(self, "[ LEVEL I LASER SYSTEM SELECTED ]\n");
				stuffcmd(self, "bf\n");
			}
		}
	}
};

void() CheatCommand = 
{
	if (deathmatch || coop == WEAPON_SHOTGUN)
	{
		return;
	}
	self.ammo_rockets = 100;
	self.ammo_nails = 200;
	self.ammo_shells = 100;
	self.ammo_cells = 200;
	self.items = self.items | IT_AXE | IT_SHOTGUN | IT_SUPER_SHOTGUN | IT_NAILGUN | IT_SUPER_NAILGUN | IT_GRENADE_LAUNCHER | IT_ROCKET_LAUNCHER | IT_LIGHTNING;
	self.impelitems = self.impelitems | IT_LIGHTME;
	self.impelitems = self.impelitems | IT_NAPALM;
	self.impelitems = self.impelitems | IT_PULSERIFLE;
	self.impelitems = self.impelitems | IT_SPEAR;
	self.weapon = IT_GRENADE_LAUNCHER;
	self.impulse = MSG_BROADCAST;
	W_SetCurrentAmmo();
	sound(self, CHAN_WEAPON, "weapons/pkup.wav", WEAPON_SHOTGUN, ATTN_NORM);
};

void() CycleWeaponCommand = 
{
	local float it;
	local float ii;
	local float am;
	it = self.items;
	ii = self.impelitems;
	self.impulse = MSG_BROADCAST;
	while (WEAPON_SHOTGUN)
	{
		am = MSG_BROADCAST;
		if (self.weapon == IT_PULSERIFLE && (self.flags & FL_IMPELWEAPON))
		{
			self.flags = self.flags - (self.flags & FL_IMPELWEAPON);
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
								if (self.weapon == IT_GRENADE_LAUNCHER && !(self.flags & FL_IMPELWEAPON))
								{
									self.weapon = IT_NAPALM;
									self.flags = self.flags | FL_IMPELWEAPON;
									if (self.ammo_rockets < WEAPON_SHOTGUN)
									{
										am = WEAPON_SHOTGUN;
									}
								}
								else
								{
									if (self.weapon == IT_NAPALM && (self.flags & FL_IMPELWEAPON))
									{
										self.weapon = IT_ROCKET_LAUNCHER;
										self.flags = self.flags - (self.flags & FL_IMPELWEAPON);
										if (self.ammo_rockets < WEAPON_SHOTGUN)
										{
											am = WEAPON_SHOTGUN;
										}
									}
									else
									{
										if (self.weapon == IT_ROCKET_LAUNCHER && !(self.flags & FL_IMPELWEAPON))
										{
											self.weapon = IT_SPEAR;
											self.flags = self.flags | FL_IMPELWEAPON;
											if (self.ammo_rockets < WEAPON_SHOTGUN)
											{
												am = WEAPON_SHOTGUN;
											}
										}
										else
										{
											if (self.weapon == IT_SPEAR && (self.flags & FL_IMPELWEAPON))
											{
												self.weapon = IT_LIGHTNING;
												self.flags = self.flags - (self.flags & FL_IMPELWEAPON);
												if (self.ammo_cells < WEAPON_SHOTGUN)
												{
													am = WEAPON_SHOTGUN;
												}
											}
											else
											{
												if (self.weapon == IT_LIGHTNING && !(self.flags & FL_IMPELWEAPON))
												{
													self.weapon = IT_LIGHTME;
													self.flags = self.flags | FL_IMPELWEAPON;
													if (self.ammo_cells < WEAPON_SHOTGUN)
													{
														am = WEAPON_SHOTGUN;
													}
												}
												else
												{
													if (self.weapon == IT_LIGHTME && (self.flags & FL_IMPELWEAPON))
													{
														self.weapon = IT_PULSERIFLE;
														if (self.impelitems & IT_PULSEPOWER2)
														{
															if (self.ammo_cells < WEAPON_SPIKES)
															{
																am = WEAPON_SHOTGUN;
															}
														}
														else
														{
															if (self.impelitems & IT_PULSEPOWER1)
															{
																if (self.ammo_cells < AS_MELEE)
																{
																	am = WEAPON_SHOTGUN;
																}
															}
															else
															{
																if (self.ammo_cells < WEAPON_ROCKET)
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
					}
				}
			}
		}
		if (it & self.weapon && am == MSG_BROADCAST && !(self.flags & FL_IMPELWEAPON) || (ii & self.weapon && am == MSG_BROADCAST && (self.flags & FL_IMPELWEAPON)))
		{
			W_SetCurrentAmmo();
			if (self.flags & FL_IMPELWEAPON && (self.flags & FL_IMPELWEAPON) && self.weapon == IT_PULSERIFLE && (self.impelitems & IT_PULSEPOWER2))
			{
				sound(self, CHAN_AUTO, "weapons/pulse/install.wav", WEAPON_SHOTGUN, ATTN_NORM);
				sound(self, CHAN_WEAPON, "enviro/pinhead/pinfire.wav", WEAPON_SHOTGUN, ATTN_NORM);
				centerprint(self, "[ LEVEL III LASER SYSTEM SELECTED ]\n");
				stuffcmd(self, "bf\n");
			}
			else
			{
				if (self.flags & FL_IMPELWEAPON && (self.flags & FL_IMPELWEAPON) && self.weapon == IT_PULSERIFLE && (self.impelitems & IT_PULSEPOWER1))
				{
					sound(self, CHAN_AUTO, "weapons/pulse/install.wav", WEAPON_SHOTGUN, ATTN_NORM);
					sound(self, CHAN_WEAPON, "enviro/pinhead/pinfire.wav", WEAPON_SHOTGUN, ATTN_NORM);
					centerprint(self, "[ LEVEL II LASER SYSTEM SELECTED ]\n");
					stuffcmd(self, "bf\n");
				}
				else
				{
					if (self.flags & FL_IMPELWEAPON && self.weapon == IT_PULSERIFLE)
					{
						sound(self, CHAN_AUTO, "weapons/pulse/install.wav", WEAPON_SHOTGUN, ATTN_NORM);
						sound(self, CHAN_WEAPON, "enviro/pinhead/pinfire.wav", WEAPON_SHOTGUN, ATTN_NORM);
						centerprint(self, "[ LEVEL I LASER SYSTEM SELECTED ]\n");
						stuffcmd(self, "bf\n");
					}
				}
			}
			return;
		}
	}
};

void() CycleWeaponReverseCommand = 
{
	self.impulse = MSG_BROADCAST;
};

void() ServerflagsCommand = 
{
	serverflags = serverflags * WEAPON_ROCKET + WEAPON_SHOTGUN;
};

void() InvulnCheat = 
{
	if (deathmatch || coop)
	{
		return;
	}
	if (self.items & IT_INVULNERABILITY)
	{
		return;
	}
	self.invincible_time = WEAPON_SHOTGUN;
	self.invincible_finished = time + SVC_INTERMISSION;
	self.items = self.items | IT_INVULNERABILITY;
	sprint(self, "Invulnerability activated!\n");
	stuffcmd(self, "bf\n");
	sound(self, CHAN_AUTO, "items/protect.wav", WEAPON_SHOTGUN, ATTN_NORM);
};

void() InvisCheat = 
{
	if (deathmatch || coop)
	{
		return;
	}
	if (self.items & IT_INVISIBILITY)
	{
		return;
	}
	self.invisible_time = WEAPON_SHOTGUN;
	self.invisible_finished = time + SVC_INTERMISSION;
	self.items = self.items | IT_INVISIBILITY;
	sprint(self, "Invisibility activated!\n");
	stuffcmd(self, "bf\n");
	sound(self, CHAN_AUTO, "items/inv1.wav", WEAPON_SHOTGUN, ATTN_NORM);
};

void() RadCheat = 
{
	if (deathmatch || coop)
	{
		return;
	}
	if (self.items & IT_SUIT)
	{
		return;
	}
	self.rad_time = WEAPON_SHOTGUN;
	self.radsuit_finished = time + SVC_INTERMISSION;
	self.items = self.items | IT_SUIT;
	sprint(self, "Radiation Suit activated!\n");
	stuffcmd(self, "bf\n");
	sound(self, CHAN_AUTO, "items/suit.wav", WEAPON_SHOTGUN, ATTN_NORM);
};

void() QuadCheat = 
{
	if (deathmatch || coop == WEAPON_SHOTGUN)
	{
		return;
	}
	if (self.items & IT_QUAD)
	{
		return;
	}
	self.super_time = WEAPON_SHOTGUN;
	self.super_damage_finished = time + SVC_INTERMISSION;
	self.items = self.items | IT_QUAD;
	sprint(self, "Quad Damage activated!\n");
	stuffcmd(self, "bf\n");
	sound(self, CHAN_AUTO, "items/damage.wav", WEAPON_SHOTGUN, ATTN_NORM);
};

void() KeyPowerCheat = 
{
	if (coop)
	{
		return;
	}
	self.items = self.items | IT_KEY1 | IT_KEY2;
	sprint(self, "ALL KEYS activated!\n");
	stuffcmd(self, "bf\n");
	sound(self, CHAN_AUTO, "misc/trigger1.wav", WEAPON_SHOTGUN, ATTN_NORM);
};

void() VersionInfo = 
{
	sprint(self, "Abyss of Pandemonium Shareware Vr 1.05\n");
	sprint(self, "Copyright (C) 1998 Impel Development Team\n\n");
	sprint(self, "View LICENSE.TXT for info!\n");
	stuffcmd(self, "bf\n");
	sound(self, CHAN_AUTO, "misc/trigger1.wav", WEAPON_SHOTGUN, ATTN_NORM);
};

void() PulsePowerCheat = 
{
	local float new;
	local entity stemp;
	if (deathmatch || coop)
	{
		return;
	}
	if (self.impelitems & IT_PULSEPOWER2)
	{
		return;
	}
	else
	{
		if (self.impelitems & IT_PULSEPOWER1)
		{
			new = IT_PULSEPOWER2;
			sound(self, CHAN_AUTO, "weapons/pulse/install.wav", WEAPON_SHOTGUN, ATTN_NORM);
			stuffcmd(self, "bf\n");
			sprint(self, "Level III Laser System upgrade!\n");
		}
		else
		{
			if (self.impelitems & IT_PULSERIFLE)
			{
				new = IT_PULSEPOWER1;
				sound(self, CHAN_AUTO, "weapons/pulse/install.wav", WEAPON_SHOTGUN, ATTN_NORM);
				stuffcmd(self, "bf\n");
				sprint(self, "Level II Laser System upgrade!\n");
			}
		}
	}
	self.impelitems = self.impelitems | new;
	W_SetCurrentAmmo();
};

void() FieldCheat = 
{
	if (deathmatch || coop)
	{
		return;
	}
	if (self.items & IT_FIELDGEN)
	{
		return;
	}
	self.field_generator_time = -150;
	self.field_generator_finished = time + SVC_INTERMISSION;
	self.field_generator_health = 200;
	self.items = self.items | IT_FIELDGEN;
	stuffcmd(self, "bf\n");
	sound(self, CHAN_AUTO, "weapons/field/genactiv.wav", WEAPON_SHOTGUN, ATTN_NORM);
};

void() ImpulseCommands = 
{
	if (self.impulse >= WEAPON_SHOTGUN && self.impulse <= WEAPON_BIG || self.impulse == 14)
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
	if (self.impulse == 12)
	{
		CycleWeaponCommand();
	}
	if (self.impulse == SVC_SELLSCREEN)
	{
		KeyPowerCheat();
	}
	if (self.impulse == 44)
	{
		VersionInfo();
	}
	if (self.impulse == 250)
	{
		FieldCheat();
	}
	if (self.impulse == 251)
	{
		PulsePowerCheat();
	}
	if (self.impulse == 252)
	{
		RadCheat();
	}
	if (self.impulse == 253)
	{
		InvisCheat();
	}
	if (self.impulse == 254)
	{
		InvulnCheat();
	}
	if (self.impulse == 255)
	{
		QuadCheat();
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


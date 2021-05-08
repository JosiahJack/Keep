void() player_run;
void (vector org,vector vel,float damage,entity vic) SpawnBlood;
void() BurnFucker;
void() Plasma_Charge;
void() FireUtil;
void (float number,entity where) WaterSplash;
void() Panic1;
float multi_damage;

void() W_Precache =
{
	precache_sound ("weapons/sgun1.wav");
	precache_sound ("weapons/r_exp3.wav");
	precache_sound ("weapons/ric1.wav");
	precache_sound ("weapons/ric2.wav");
	precache_sound ("weapons/ric3.wav");
	precache_sound ("weapons/tink1.wav");
	precache_sound ("weapons/plasma.wav");
	precache_sound ("weapons/hellfire.wav");
	precache_sound ("weapons/shot1.wav");
	precache_sound ("weapons/shot1b.wav");
	precache_sound ("weapons/shell1.wav");
	precache_sound ("weapons/shell2.wav");
	precache_sound ("weapons/shell3.wav");
	precache_sound ("weapons/casehit1.wav");
	precache_sound ("weapons/casehit2.wav");
	precache_sound ("weapons/casehit3.wav");
	precache_sound ("weapons/morter1.wav");
	precache_sound ("weapons/shot2.wav");
	precache_sound ("weapons/mini1.wav");
	precache_sound ("weapons/mini2.wav");
	precache_sound ("weapons/mini3.wav");
	precache_sound ("weapons/uzim.wav");
	precache_sound ("weapons/punish2.wav");
	precache_sound ("weapons/punish4.wav");
	precache_sound ("weapons/reload11.wav");
	precache_sound ("weapons/reload1.wav");
	precache_sound ("weapons/reload2.wav");
	precache_sound ("weapons/reload3.wav");
	precache_sound ("weapons/reload4.wav");
	precache_sound ("weapons/misfire1.wav");
	precache_sound ("weapons/misfire2.wav");
	precache_sound ("weapons/torpedo.wav");
	precache_sound ("misc/warning.wav");
	precache_sound ("misc/hiss.wav");
	precache_sound ("weapons/morthit.wav");
	precache_sound ("weapons/loadrock.wav");
	precache_sound ("weapons/minidown.wav");
};


void() NormalVars =
{
	self.hover_active = FALSE;
	self.chute_active = FALSE;
	self.probe_active = FALSE;
	stuffcmd (self, "fov 90\n");
	stuffcmd (self, "viewsize 100\n");
	stuffcmd (self, "r_drawviewmodel 1\n");
	stuffcmd (self, "cl_rollangle 2\n");
	stuffcmd (self, "cl_forwardspeed 360\n");
	self.cl_forwardspeed = CHT_NORMSPEED;
	stuffcmd (self, "cl_backspeed 360\n");
	stuffcmd (self, "cl_sidespeed 360\n");
	stuffcmd (self, "cl_bob 0.01\n");
	stuffcmd (self, "cl_bobup 0.5\n");
	stuffcmd (self, "cl_bobcycle 0.4\n");
	stuffcmd (self, "r_waterwarp 0\n");
	stuffcmd (self, "cl_movespeedkey 0.5\n");
	stuffcmd (self, "v_idlescale 0\n");
	stuffcmd (self, "v_kickpitch 1\n");
	stuffcmd (self, "v_kickroll 1\n");
	stuffcmd (self, "-right\n");
	stuffcmd (self, "-left\n");
	stuffcmd (self, "-lookup\n");
	stuffcmd (self, "-lookdown\n");
	stuffcmd (self, "cl_yawspeed 140\n");
	stuffcmd (self, "cl_pitchspeed 150\n");
	self.vars_flag = 1;
};


float () crandom =
{
	return ((2 * (random() - 0.5)));
};

void() s_sparked1;

void (vector org,vector dir) Spark =
{
	newmis = spawn();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_BOUNCE;
	newmis.solid = SOLID_BBOX;
	newmis.angles = vectoangles (dir);
	setmodel (newmis, "progs/s_spark.spr");
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);
	setorigin (newmis, org);
	makevectors (self.v_angle);
	newmis.velocity_x = (random() * 100);
	newmis.velocity_y = (random() * 100);
	newmis.velocity_z = (random() * 200);
	newmis.think = s_sparked1;
	newmis.nextthink = time;
};

void() shell1;

void (vector org,vector dir) ExplodeTip =
{
	local float x;

	newmis = spawn();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BBOX;
	newmis.angles = vectoangles (dir);
	if ((random() > 0.5))
		x = -1;
	else
		x = 1;
	newmis.velocity_x = ((random() * 60) * x);
	newmis.velocity_y = ((random() * 60) * x);
	newmis.velocity_z = ((random() * 100) * x);
	setmodel (newmis, "progs/s_expshl.spr");
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);
	setorigin (newmis, org);
	makevectors (self.v_angle);
	newmis.think = shell1;
	newmis.nextthink = time;
};

vector() wall_velocity =
{
	local vector vel;

	vel = normalize (self.velocity);
	vel = normalize (((vel + (v_up * (random() - 0.5))) + (v_right * (random() - 0.5))));
	vel = (vel + (2 * trace_plane_normal));
	vel = (vel * 200);
	return (vel);
};


void (vector org,vector vel) SpawnMeatSpray =
{
	local entity missile;
	local entity mpuff;

	missile = spawn();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_NOT;
	makevectors (self.angles);
	missile.velocity = vel;
	missile.velocity_z = ((missile.velocity_z + 250) + (50 * random()));
	missile.avelocity = '3000 1000 2000';
	missile.nextthink = (time + 1.00);
	missile.think = SUB_Remove;
	setmodel (missile, "progs/zom_gib.mdl");
	setsize (missile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin (missile, org);
};


void (vector org,vector vel,float damage,entity vic) SpawnBlood =
{
	if (deathmatch)
	{
		particle (org, (vel * 0.1), 73, (damage * 2));
		return;
	}
	if ((vic.classname == "monster_probe"))
		particle (org, (vel * 0.1), 104, damage);
	else
	{
		if ((vic.classname == "monster_rider"))
			particle (org, (vel * 0.1), 104, damage);
		else
		{
			if ((vic.classname == "monster_hunter"))
				particle (org, (vel * 0.1), 104, damage);
			else
			{
				if ((vic.classname == "monster_banshee"))
					particle (org, (vel * 0.1), 104, damage);
				else
				{
					if ((vic.classname == "monster_bossman"))
						particle (org, (vel * 0.1), 176, damage);
					else
					{
						if ((vic.classname == "monster_turret"))
							particle (org, (vel * 0.1), 104, damage);
						else
						{
							if ((vic.classname == "e_oj"))
								particle (org, (vel * 0.1), 32, damage);
							else
							{
								if ((vic.classname == "barrel"))
									particle (org, (vel * 0.1), 9, damage);
								else
								{
									if ((vic.classname == "breakable_bulb"))
										particle (org, (vel * 0.1), 9, damage);
									else
									{
										if ((vic.classname == "the_plant"))
											particle (org, (vel * 0.1), 56, damage);
										else
											particle (org, (vel * 0.1), 73, (damage * 2));
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


void (float damage,entity vic) spawn_touchblood =
{
	local vector vel;

	vel = (wall_velocity() * 0.2);
	SpawnBlood ((self.origin + (vel * 0.01)), vel, damage, vic);
};


void (vector org,vector vel) SpawnChunk =
{
	particle (org, (vel * 0.02), 0, 10);
};

entity multi_ent;

void() ClearMultiDamage =
{
	multi_ent = world;
	multi_damage = 0;
};


void() ApplyMultiDamage =
{
	if (!multi_ent)
		return;
	T_Damage (multi_ent, self, self, multi_damage);
};


void (entity hit,float damage) AddMultiDamage =
{
	if (!hit)
		return;
	if ((hit != multi_ent))
	{
		ApplyMultiDamage();
		multi_damage = damage;
		multi_ent = hit;
	}
	else
		multi_damage = (multi_damage + damage);
};


void (float damage,vector dir) TraceAttack =
{
	local vector vel;
	local vector org;
	local vector impact;
	local float dist;

	vel = normalize (((dir + (v_up * crandom())) + (v_right * crandom())));
	vel = (vel + (2 * trace_plane_normal));
	vel = (vel * 200);
	org = (trace_endpos - (dir * 4));
	if (trace_ent.takedamage)
	{
		if ((trace_ent.tools == (trace_ent.tools | UT_MINISUB)))
		{
			impact = normalize ((org - trace_ent.origin));
			makevectors (trace_ent.v_angle);
			dist = vlen ((impact - v_forward));
			if ((dist < 0.8))
			{
				damage = damage;
				particle (org, (vel * 0.1), 73, (damage * 2));
			}
			else
			{
				damage = (damage / 4);
				particle (org, (vel * 0.1), 104, (damage * 2));
			}
		}
		else
			SpawnBlood (org, (vel * 0.2), damage, trace_ent);
		AddMultiDamage (trace_ent, damage);
		if ((self.weapon == IT_SHOT))
		{
			if ((random() > 0.85))
				ExplodeTip (trace_endpos, dir);
		}
	}
	else
	{
		if ((self.weapon == IT_SHOT))
		{
			if ((random() > 0.85))
				ExplodeTip (trace_endpos, dir);
		}
		else
		{
			if ((random() < 0.25))
				Spark (trace_endpos, dir);
		}
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_GUNSHOT);
		WriteCoord (MSG_BROADCAST, org_x);
		WriteCoord (MSG_BROADCAST, org_y);
		WriteCoord (MSG_BROADCAST, org_z);
	}
};


void (float shotcount,vector dir,vector spread) FireBullets =
{
	local vector direction;
	local vector src;

	makevectors (self.v_angle);
	src = (self.origin + (v_forward * 10));
	src_z = (self.absmin_z + (self.size_z * 0.7));
	ClearMultiDamage();
	while ((shotcount > 0))
	{
		direction = ((dir + ((crandom() * spread_x) * v_right)) + ((crandom() * spread_y) * v_up));
		traceline (src, (src + (direction * IT_CELLS)), FALSE, self);
		if ((trace_fraction != 1))
			TraceAttack (4, direction);
		shotcount = (shotcount - 1);
	}
	ApplyMultiDamage();
};


void() ShellTouch =
{
	self.angles_x = 0;
	if ((random() < 0.33))
		sound (self, CHAN_WEAPON, "weapons/shell1.wav", 1.00, ATTN_NORM);
	else
	{
		if ((random() < 0.66))
			sound (self, CHAN_WEAPON, "weapons/shell2.wav", 1.00, ATTN_NORM);
		else
			sound (self, CHAN_WEAPON, "weapons/shell3.wav", 1.00, ATTN_NORM);
	}
};


void() CaseTouch =
{
	if ((other.classname == "player"))
		remove (self);
	if ((self.classname == "celshel"))
		self.frame = 1;
	self.angles_x = 0;
	if ((self.classname == "mortshell"))
		sound (self, CHAN_WEAPON, "weapons/morthit.wav", 1.00, ATTN_NORM);
	else
	{
		if ((random() < 0.33))
			sound (self, CHAN_WEAPON, "weapons/casehit1.wav", 1.00, ATTN_NORM);
		else
		{
			if ((random() < 0.66))
				sound (self, CHAN_WEAPON, "weapons/casehit2.wav", 1.00, ATTN_NORM);
			else
				sound (self, CHAN_WEAPON, "weapons/casehit3.wav", 1.00, ATTN_NORM);
		}
	}
};


void() BlowShell =
{
	local entity missile;

	missile = spawn();
	missile.enemy = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_TRIGGER; // ACC, used to be "SOLID_BBOX", replaced because client would collide with shells in DarkPlaces
	makevectors (self.v_angle);
	missile.velocity = aim (self, 1.00);
	missile.avelocity = (random() * '1000 0 0');
	missile.angles = vectoangles (missile.velocity);
	missile.touch = ShellTouch;
	missile.nextthink = (time + 1.00);
	missile.think = SUB_Remove;
	setmodel (missile, "progs/bshell1.mdl");
	setsize (missile, VEC_ORIGIN, VEC_ORIGIN);
	if ((self.weapon == IT_UZI))
	{
		missile.velocity = (((v_right * (-130 + (random() * -50))) + (v_forward * (70 + (random() * 50)))) + (v_up * (100 + (random() * 100))));
		setorigin (missile, (((self.origin + (v_right * 7)) + (v_forward * 14)) + '0 0 14'));
	}
	else
	{
		missile.velocity = (((v_right * (-120 + (random() * -50))) + (v_forward * (80 + (random() * 50)))) + (v_up * (50 + (random() * 200))));
		setorigin (missile, (((self.origin + (v_right * 7)) + (v_forward * 8)) + '0 0 11'));
	}
};


void() BlowCase =
{
	local entity missile;

	missile = spawn();
	missile.enemy = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_TRIGGER; // ACC, used to be "SOLID_BBOX", replaced because client would collide with shells in DarkPlaces
	makevectors (self.v_angle);
	missile.velocity = aim (self, 1.00);
	missile.avelocity = ('200 0 0' + (random() * '800 0 0'));
	missile.angles = vectoangles (missile.velocity);
	missile.think = SUB_Remove;
	if ((self.weapon == IT_MORTER))
	{
		missile.velocity = (((v_right * (-20 + (random() * -30))) + (v_forward * (random() * 150))) + (v_up * (400 + (random() * 200))));
		setmodel (missile, "progs/mortshel.mdl");
		setsize (missile, '0 0 -4', '0 0 4');
		setorigin (missile, (((self.origin + (v_forward * 20)) + (v_right * 9)) + '0 0 10'));
		missile.nextthink = (time + 4.00);
		missile.classname = "mortshell";
	}
	else
	{
		if ((self.weapon == IT_PUNISHER))
		{
			missile.velocity = (((v_right * (20 + (random() * 50))) + (v_forward * (random() * 100))) + (v_up * (100 + (random() * 200))));
			setmodel (missile, "progs/celshel.mdl");
			setsize (missile, '0 0 -4', '0 0 4');
			setorigin (missile, (((self.origin + (v_forward * 20)) + (v_right * 9)) + '0 0 10'));
			missile.nextthink = (time + 16.00);
			missile.avelocity = ('0 0 500' + (random() * '0 0 1000'));
			missile.classname = "celshel";
		}
		else
		{
			if ((self.weapon == IT_SHOT2))
			{
				missile.velocity = (((v_right * (50 + (random() * 50))) + (v_forward * (random() * 150))) + (v_up * (random() * 300)));
				setorigin (missile, (((self.origin + (v_forward * 24)) + (v_right * 8)) + '0 0 10'));
				setmodel (missile, "progs/shelcase.mdl");
			}
			else
			{
				if ((self.weapon == IT_44))
				{
					missile.velocity = (((v_right * (-50 + (random() * -50))) + (v_forward * (random() * 150))) + (v_up * (random() * 300)));
					setorigin (missile, (((self.origin + (v_forward * 24)) + (v_right * -8)) + '0 0 10'));
					setmodel (missile, "progs/bulcase.mdl");
					missile.touch = ShellTouch;
					missile.nextthink = (time + 2.00);
					setsize (missile, VEC_ORIGIN, VEC_ORIGIN);
					return;
				}
				else
				{
					missile.velocity = (((v_right * (-50 + (random() * -50))) + (v_forward * (random() * 150))) + (v_up * (random() * 300)));
					setorigin (missile, (((self.origin + (v_forward * 24)) + (v_right * -8)) + '0 0 10'));
					setmodel (missile, "progs/shelcase.mdl");
				}
			}
			missile.nextthink = (time + 2.00);
			setsize (missile, VEC_ORIGIN, VEC_ORIGIN);
		}
	}
	missile.touch = CaseTouch;
};


void() PlasTouch =
{
	local float amount;

	if ((other == self.owner))
		return;
	if ((pointcontents (self.origin) == CONTENT_SKY))
	{
		remove (self);
		return;
	}
	amount = (10 + (random() * 10));
	if (other.health)
		T_Damage (other, self, self.owner, amount);
	remove (self);
};


void() W_DeathFire =
{
	local entity plasma;

	sound (self, CHAN_WEAPON, "weapons/plasma.wav", 1.00, ATTN_NORM);
	plasma = spawn();
	plasma.owner = self;
	plasma.movetype = MOVETYPE_FLYMISSILE;
	plasma.solid = SOLID_BBOX;
	makevectors (self.v_angle);
	plasma.velocity = aim (self, 1.00);
	plasma.velocity = (plasma.velocity * 1500);
	plasma.angles = vectoangles (plasma.velocity);
	plasma.touch = PlasTouch;
	setmodel (plasma, "progs/comet.mdl");
	setsize (plasma, VEC_ORIGIN, VEC_ORIGIN);
	setorigin (plasma, ((self.origin + (v_forward * 20)) + '0 0 18'));
};


void() W_FireShotgun =
{
	local vector dir;

	self.count_shot_idle = 40;
	self.punchangle_x = -2;
	dir = aim (self, 100000);
	if ((self.weapon == IT_SHOT))
	{
		sound (self, CHAN_WEAPON, "weapons/shot1b.wav", 1.00, ATTN_NORM);
		self.currentammo = self.ammo_shells2 = self.ammo_shells2 - 2;
		
		FireBullets (12, dir, '0.04 0.04 0');
		BlowCase();
	}
	else
	{
		sound (self, CHAN_WEAPON, "weapons/shot1.wav", 1.00, ATTN_NORM);
		FireBullets (6, dir, '0.04 0.04 0');
		BlowCase();
	}
};


void() W_FireOozi =
{
	local vector dir;

	if ((self.mini_flag < time))
	{
		sound (self, CHAN_WEAPON, "weapons/uzim.wav", 1.00, ATTN_NORM);
		self.mini_flag = (time + 0.097);
	}
	self.punchangle_x = -2;
	self.currentammo = self.ammo_nails2 = self.ammo_nails2 - 1;
	
	dir = aim (self, 100000);
	FireBullets (6, dir, '0.001 0.001 0');
};


void() W_FireSuperShotgun =
{
	local vector dir;

	sound (self, CHAN_WEAPON, "weapons/shot2.wav", 1.00, ATTN_NORM);
	self.currentammo = self.ammo_shells2 = self.ammo_shells2 - 4;
	
	self.punchangle_x = -4;
	dir = aim (self, 100000);
	FireBullets (27, dir, '0.14 0.08 0');
	BlowCase();
	BlowCase();
};

void() s_explode1 = [ 0, s_explode2 ]
{
};

void() s_explode2 = [ 1, s_explode3 ]
{
};

void() s_explode3 = [ 2, s_explode4 ]
{
};

void() s_explode4 = [ 3, s_explode5 ]
{
};

void() s_explode5 = [ 4, s_explode6 ]
{
};

void() s_explode6 = [ 5, s_explode7 ]
{
};

void() s_explode7 = [ 6, s_explode8 ]
{
};

void() s_explode8 = [ 7, s_explode9 ]
{
};

void() s_explode9 = [ 8, s_explode10 ]
{
};

void() s_explode10 = [ 9, s_explode11 ]
{
};

void() s_explode11 = [ 10, SUB_Remove ]
{
};

void() s_sparked1 = [ 0, s_sparked2 ]
{
};

void() s_sparked2 = [ 1, s_sparked3 ]
{
};

void() s_sparked3 = [ 2, s_sparked4 ]
{
};

void() s_sparked4 = [ 3, s_sparked5 ]
{
};

void() s_sparked5 = [ 4, s_sparked6 ]
{
};

void() s_sparked6 = [ 5, SUB_Remove ]
{
};

void() plasma1 = [ 0, plasma2 ]
{
};

void() plasma2 = [ 1, plasma3 ]
{
};

void() plasma3 = [ 2, plasma4 ]
{
};

void() plasma4 = [ 3, plasma5 ]
{
};

void() plasma5 = [ 4, plasma6 ]
{
};

void() plasma6 = [ 5, SUB_Remove ]
{
};

void() trail1 = [ 0, trail2 ]
{
};

void() trail2 = [ 1, trail3 ]
{
};

void() trail3 = [ 2, trail4 ]
{
};

void() trail4 = [ 3, trail5 ]
{
};

void() trail5 = [ 4, trail6 ]
{
};

void() trail6 = [ 5, trail7 ]
{
};

void() trail7 = [ 6, trail8 ]
{
};

void() trail8 = [ 7, SUB_Remove ]
{
};

void() shell1 = [ 0, shell2 ]
{
};

void() shell2 = [ 1, shell3 ]
{
};

void() shell3 = [ 2, shell4 ]
{
};

void() shell4 = [ 3, shell5 ]
{
};

void() shell5 = [ 4, shell6 ]
{
};

void() shell6 = [ 5, shell7 ]
{
};

void() shell7 = [ 6, shell8 ]
{
};

void() shell8 = [ 7, SUB_Remove ]
{
};


void() BecomeExplosion =
{
	self.movetype = MOVETYPE_NOCLIP;
	self.velocity = '0 0 60';
	self.touch = SUB_Null;
	self.think = SUB_Null;
	self.solid = SOLID_NOT;
	setmodel (self, "progs/s_explod.spr");
	s_explode1();
};


void() RailExplosion =
{
	self.movetype = MOVETYPE_NONE;
	self.velocity = VEC_ORIGIN;
	self.touch = SUB_Null;
	self.solid = SOLID_NOT;
	setmodel (self, "progs/s_punish.spr");
	plasma1();
};


void() T_MissileTouch =
{
	local float damg;

	if ((other == self.owner))
		return;
	if ((pointcontents (self.origin) == CONTENT_SKY))
	{
		remove (self);
		return;
	}
	damg = (200 + (random() * 20));
	if (other.health)
		T_Damage (other, self, self.owner, damg);
	T_RadiusDamage (self, self.owner, 140, other);
	self.origin = (self.origin - (8 * normalize (self.velocity)));
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);
	BecomeExplosion();
};


void() T_TorpTouch =
{
	local float damg;

	self.owner.tube_wing = (self.owner.tube_wing - 1);
	if ((other == self.owner))
		return;
	damg = (200 + (random() * 50));
	if (other.health)
		T_Damage (other, self, self.owner, damg);
	T_RadiusDamage (self, self.owner, 200, other);
	self.origin = (self.origin - (8 * normalize (self.velocity)));
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);
	BecomeExplosion();
};


void() T_RailTouch =
{
	local float damg;

	if ((other == self.owner))
		return;
	if ((pointcontents (self.origin) == CONTENT_SKY))
	{
		remove (self);
		return;
	}
	if (other.health)
		T_Damage (other, self, self.owner, 60);
	T_RadiusDamage (self, self.owner, 90, other);
	sound (self, CHAN_WEAPON, "weapons/punish4.wav", 1.00, ATTN_NORM);
	self.origin = (self.origin - (8 * normalize (self.velocity)));
	RailExplosion();
};


void() w_firemini =
{
	local vector dir;

	if ((self.mini_flag < time))
	{
		if ((random() < 0.33))
		{
			sound (self, CHAN_WEAPON, "weapons/mini1.wav", 1.00, ATTN_NORM);
			self.mini_flag = (time + 0.55);
		}
		else
		{
			if ((random() < 0.66))
			{
				sound (self, CHAN_WEAPON, "weapons/mini2.wav", 1.00, ATTN_NORM);
				self.mini_flag = (time + 0.5);
			}
			else
			{
				sound (self, CHAN_WEAPON, "weapons/mini3.wav", 1.00, ATTN_NORM);
				self.mini_flag = (time + 0.2);
			}
		}
	}
	self.punchangle_x = -2;
	self.currentammo = self.ammo_nails2 = self.ammo_nails2 - 1;
	dir = aim (self, 100000);
	FireBullets (4, dir, '0.002 0.002 0');
};

void (vector org,vector dir) Flame_bomb;

void() MorterExplode =
{
	local vector dir;
	local vector org;

	makevectors (self.angles);
	dir = vectoangles (v_forward);
	dir_x = 0;
	dir_z = 0;
	org = (self.origin + (v_forward * -10));
	sound (self, CHAN_WEAPON, "weapons/r_exp3.wav", 1.00, ATTN_NORM);
	self.effects = (self.effects | EF_DIMLIGHT);
	BecomeExplosion();
	if ((pointcontents (self.origin) == CONTENT_WATER))
		return;
	Flame_bomb (org, (dir + '0 45 0'));
	Flame_bomb (org, (dir + '0 135 0'));
	Flame_bomb (org, (dir + '0 225 0'));
	Flame_bomb (org, (dir + '0 315 0'));
	if (deathmatch)
	{
		Flame_bomb (org, (('0 1 0' * random()) * 360));
		Flame_bomb (org, (('0 1 0' * random()) * 360));
		return;
	}
	Flame_bomb (org, dir);
	Flame_bomb (org, (dir + '0 90 0'));
	Flame_bomb (org, (dir + '0 180 0'));
	Flame_bomb (org, (dir + '0 270 0'));
};

void() CheckTouch;

void() MorterTouch =
{
	if ((pointcontents (self.origin) == CONTENT_SKY))
	{
		remove (self);
		return;
	}
	MorterExplode();
	T_RadiusDamage (self, self.owner, 90, other);
	if ((other == self.owner))
		return;
	if (other.health)
	{
		T_Damage (other, self, self.owner, 60);
		CheckTouch();
	}
};


void() blowupinface =
{
	MorterExplode();
	T_RadiusDamage (self, self.owner, 40, world);
};


void() BecomeReal =
{
	self.movetype = MOVETYPE_BOUNCE;
};


void() morter_misfire =
{
	local entity missile;

	sound (self, CHAN_BODY, "damage/pain1.wav", 1.00, ATTN_NORM);
	missile = spawn();
	missile.owner = self;
	missile.movetype = MOVETYPE_NOCLIP;
	missile.solid = SOLID_NOT;
	missile.classname = "grenade";
	makevectors (self.v_angle);
	missile.nextthink = time;
	missile.think = blowupinface;
	setmodel (missile, "progs/null.spr");
	setsize (missile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin (missile, ((self.origin + (v_right * 12)) + '0 0 18'));
	BlowCase();
};


void() W_FireMorter =
{
	
	
	local entity missile;

	self.currentammo = self.ammo_rockets2 = self.ammo_rockets2 - 2;
	sound (self, CHAN_WEAPON, "weapons/morter1.wav", 1.00, ATTN_NORM);
	self.punchangle_x = -2;
	if ((time > (self.mortmf_time + 3.5)))
		self.mortmf_count = 0;
	else
		self.mortmf_count = (self.mortmf_count + 1);
	self.mortmf_time = time;
	if ((((self.mortmf_count >= 7) && (self.count == 0)) && (random() < 0.6)))
	{
		self.mortmf_count = 0;
		morter_misfire();
		return;
	}
	missile = spawn();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	missile.classname = "grenade";
	makevectors (self.v_angle);
	if (self.v_angle_x)
	{
		if ((self.waterlevel >= 2))
			missile.velocity = ((((v_forward * 600) + (v_up * 50)) + ((crandom() * v_right) * 10)) + ((crandom() * v_up) * 10));
		else
			missile.velocity = ((((v_forward * 1200) + (v_up * 50)) + ((crandom() * v_right) * 10)) + ((crandom() * v_up) * 10));
	}
	else
	{
		missile.velocity = aim (self, 1.00);
		if ((self.waterlevel >= 2))
			missile.velocity = (missile.velocity * 500);
		else
			missile.velocity = (missile.velocity * 1000);
		missile.velocity_z = 50;
	}
	missile.angles = vectoangles (missile.velocity);
	missile.touch = MorterTouch;
	missile.nextthink = (time + 0.5);
	missile.think = BecomeReal;
	setmodel (missile, "progs/morter.mdl");
	setsize (missile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin (missile, ((self.origin + (v_right * 12)) + '0 0 18'));
	BlowCase();
};

void() spike_touch;
void() superspike_touch;

void() ChangeMotion =
{
	local entity smoke;
	local entity angle;

	self.think = ChangeMotion;
	self.nextthink = (time + 0.1);
	smoke = spawn();
	smoke.movetype = MOVETYPE_NONE;
	smoke.solid = SOLID_NOT;
	smoke.angles_x = (self.angles_x * -1);
	smoke.angles_y = self.angles_y;
	setmodel (smoke, "progs/s_plas.spr");
	setsize (smoke, VEC_ORIGIN, VEC_ORIGIN);
	setorigin (smoke, self.origin);
	smoke.nextthink = time;
	smoke.think = trail1;
};


void() W_FireRail =
{
	local entity missile;

	self.currentammo = self.ammo_cells2 = self.ammo_cells2 - 1;
	sound (self, CHAN_WEAPON, "weapons/punish2.wav", 1.00, ATTN_NORM);
	self.punchangle_x = -2;
	missile = spawn();
	missile.owner = self;
	missile.classname = "punisher";
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	makevectors (self.v_angle);
	missile.velocity = aim (self, 1000);
	if ((self.waterlevel >= 2))
		missile.velocity = (missile.velocity * 1100);
	else
		missile.velocity = (missile.velocity * 2200);
	missile.angles = vectoangles (missile.velocity);
	missile.touch = T_RailTouch;
	missile.nextthink = (time + 0.1);
	missile.think = ChangeMotion;
	setmodel (missile, "progs/comet.mdl");
	setsize (missile, VEC_ORIGIN, VEC_ORIGIN);
	if ((self.barrel2 == TRUE))
		setorigin (missile, (((self.origin + (v_right * 8)) + (v_forward * 20)) + '0 0 4'));
	else
		setorigin (missile, (((self.origin + (v_right * 18)) + (v_forward * 20)) + '0 0 4'));
	if ((self.punish_eject > 2))
	{
		BlowCase();
		self.punish_eject = 0;
	}
	else
		self.punish_eject = (self.punish_eject + 1.00);
};


void() W_FireRocket =
{
	local entity missile;

	self.currentammo = self.ammo_rockets2 = self.ammo_rockets2 - 1;
	
	self.punchangle_x = -2;
	missile = spawn();
	missile.owner = self;
	missile.classname = "stinger";
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	makevectors (self.v_angle);
	missile.velocity = aim (self, 1.00);
	if ((self.waterlevel >= 2))
		missile.velocity = (missile.velocity * 450);
	else
		missile.velocity = (missile.velocity * 650);
	missile.angles = vectoangles (missile.velocity);
	missile.touch = T_MissileTouch;
	missile.avelocity = '0 0 600';
	setmodel (missile, "progs/rocket.mdl");
	setsize (missile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin (missile, (((self.origin + (v_forward * 8)) + (v_right * 4.4)) + '0 0 18.3'));
};


void (vector org,vector dir) launch_spike =
{
	newmis = spawn();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BBOX;
	newmis.angles = vectoangles (dir);
	newmis.touch = spike_touch;
	newmis.classname = "spike";
	newmis.think = SUB_Remove;
	newmis.nextthink = (time + 6.00);
	setmodel (newmis, "progs/spike.mdl");
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);
	setorigin (newmis, org);
	newmis.velocity = (dir * 1000);
};


void() W_FireSuperSpikes =
{
	local vector dir;
	local entity old;

	sound (self, CHAN_WEAPON, "weapons/spike2.wav", 1.00, ATTN_NORM);
	self.attack_finished = (time + 0.2);
	self.currentammo = self.ammo_nails2 = self.ammo_nails2 - 2;
	
	dir = aim (self, 1000);
	launch_spike ((self.origin + '0 0 16'), dir);
	newmis.touch = superspike_touch;
	setmodel (newmis, "progs/s_spike.mdl");
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);
	self.punchangle_x = -2;
};

.float hit_z;

void() spike_touch =
{
	local float rand;

	if ((other == self.owner))
		return;
	if ((other.solid == SOLID_TRIGGER))
		return;
	if ((pointcontents (self.origin) == CONTENT_SKY))
	{
		remove (self);
		return;
	}
	if (other.takedamage)
	{
		spawn_touchblood (9, other);
		T_Damage (other, self, self.owner, 9);
	}
	else
	{
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		if ((self.classname == "wizspike"))
			WriteByte (MSG_BROADCAST, TE_WIZSPIKE);
		else
		{
			if ((self.classname == "knightspike"))
				WriteByte (MSG_BROADCAST, TE_KNIGHTSPIKE);
			else
				WriteByte (MSG_BROADCAST, TE_SPIKE);
		}
		WriteCoord (MSG_BROADCAST, self.origin_x);
		WriteCoord (MSG_BROADCAST, self.origin_y);
		WriteCoord (MSG_BROADCAST, self.origin_z);
	}
	remove (self);
};


void() superspike_touch =
{
	local float rand;

	if ((other == self.owner))
		return;
	if ((other.solid == SOLID_TRIGGER))
		return;
	if ((pointcontents (self.origin) == CONTENT_SKY))
	{
		remove (self);
		return;
	}
	if (other.takedamage)
	{
		spawn_touchblood (18, other);
		T_Damage (other, self, self.owner, 18);
	}
	else
	{
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_SUPERSPIKE);
		WriteCoord (MSG_BROADCAST, self.origin_x);
		WriteCoord (MSG_BROADCAST, self.origin_y);
		WriteCoord (MSG_BROADCAST, self.origin_z);
	}
	remove (self);
};


void() W_SetCurrentAmmo =
{
	UpdateAmmoBars();
	if ((self.tools == (self.tools | UT_BIGASSGUN)))
	{
		if ((self.speed & CHSCAM_ON))
		{
			self.weaponmodel = "";
			self.weaponframe = 0;
			return;
		}
		else
		{
			self.weaponmodel = "progs/w_bag.mdl";
			return;
		}
	}
	if ((self.weapon != IT_ROCKET))
		player_run();
	if ((self.tools == (self.tools | UT_MINISUB)))
	{
		if ((self.speed & CHSCAM_ON))
		{
			self.weaponmodel = "";
			self.weaponframe = 0;
		}
		return;
	}
	self.items = (self.items - (self.items & (((IT_SHELLS | IT_NAILS) | IT_ROCKETS) | IT_CELLS)));
	if ((self.weapon == IT_SHOT))
	{
		self.currentammo = self.ammo_shells2;
		self.weaponmodel = "progs/w_shot.mdl";
		self.weaponframe = 0;
		self.items = (self.items | IT_SHELLS);
		self.count = 0;
	}
	else
	{
		if ((self.weapon == IT_SHOT2))
		{
			self.currentammo = self.ammo_shells2;
			self.weaponmodel = "progs/w_shot2.mdl";
			self.weaponframe = 0;
			self.items = (self.items | IT_SHELLS);
			self.count = 0;
		}
		else
		{
			if ((self.weapon == IT_UZI))
			{
				self.currentammo = self.ammo_nails2;
				self.weaponmodel = "progs/w_uzi.mdl";
				self.weaponframe = 0;
				self.items = (self.items | IT_NAILS);
				self.count = 0;
			}
			else
			{
				if ((self.weapon == IT_ROCKET))
				{
					self.currentammo = self.ammo_rockets2;
					self.weaponmodel = "progs/w_rocket.mdl";
					self.items = (self.items | IT_ROCKETS);
				}
				else
				{
					if ((self.weapon == IT_MORTER))
					{
						self.currentammo = self.ammo_rockets2;
						self.weaponmodel = "progs/w_morter.mdl";
						self.weaponframe = 0;
						self.items = (self.items | IT_ROCKETS);
						self.count = 0;
					}
					else
					{
						if ((self.weapon == IT_MINI))
						{
							self.currentammo = self.ammo_nails2;
							self.weaponmodel = "progs/w_mini.mdl";
							self.weaponframe = 0;
							self.items = (self.items | IT_NAILS);
							self.count = 0;
						}
						else
						{
							if ((self.weapon == IT_PUNISHER))
							{
								self.currentammo = self.ammo_cells2;
								self.weaponmodel = "progs/w_punish.mdl";
								self.weaponframe = 0;
								self.items = (self.items | IT_CELLS);
							}
							else
							{
								if ((self.weapon == IT_44))
								{
									self.currentammo = 0;
									self.weaponmodel = "progs/w_44.mdl";
									self.count = 0;
								}
								else
									sprint (self, "W_Setcurrentammo\n");
							}
						}
					}
				}
			}
		}
	}
	if ((self.speed & CHSCAM_ON))
	{
		self.weaponmodel = "";
		self.weaponframe = 0;
	}
};


float() W_BestWeapon =
{
	local float it;

	it = self.items;
	if (((self.ammo_cells2 >= 1) && (it & IT_PUNISHER)))
		return (IT_PUNISHER);
	else
	{
		if (((self.ammo_rockets2 >= 1) && (it & IT_ROCKET)))
			return (IT_ROCKET);
		else
		{
			if (((self.ammo_rockets2 >= 2) && (it & IT_MORTER)))
				return (IT_MORTER);
			else
			{
				if (((self.ammo_nails2 >= 1) && (it & IT_MINI)))
					return (IT_MINI);
				else
				{
					if (((self.ammo_nails2 >= 1) && (it & IT_UZI)))
						return (IT_UZI);
					else
					{
						if (((self.ammo_shells2 >= 4) && (it & IT_SHOT2)))
							return (IT_SHOT2);
						else
						{
							if (((self.ammo_shells2 >= 2) && (it & IT_SHOT)))
								return (IT_SHOT);
							else
								return (IT_44);
						}
					}
				}
			}
		}
	}
};


float() W_CheckNoAmmo =
{
	if ((self.currentammo > 0))
		return (TRUE);
	if ((self.weapon == IT_44))
		return (TRUE);
	self.weapon = W_BestWeapon();
	W_SetCurrentAmmo();
	return (FALSE);
};

void() loadwep;

void() WeaponReload =
{
	if ((((self.attack_finished > time) || self.button0) || (self.tools == (self.tools | UT_MINISUB))))
		return;
	if ((self.tools == (self.tools | UT_BIGASSGUN)))
		return;
	if ((self.probe_active == TRUE))
		return;
	if ((self.weapon == IT_44))
	{
		if (!(self.speed & CHSCAM_ON))
			self.weaponmodel = "progs/w_44.mdl";
		self.count_shot_idle = 40;
		self.weaponframe = 6;
		loadwep();
		sound (self, CHAN_WEAPON, "weapons/reload1.wav", 1.00, ATTN_NORM);
		self.attack_finished = (time + 0.8);
	}
	if ((self.weapon == IT_SHOT))
	{
		sound (self, CHAN_WEAPON, "weapons/reload11.wav", 1.00, ATTN_NORM);
		self.weaponframe = 29;
		loadwep();
		self.attack_finished = (time + 0.4);
	}
	else
	{
		if ((self.weapon == IT_SHOT2))
		{
			sound (self, CHAN_WEAPON, "weapons/reload2.wav", 1.00, ATTN_NORM);
			self.weaponframe = 6;
			loadwep();
			self.attack_finished = (time + 0.8);
		}
		else
		{
			if ((self.weapon == IT_UZI))
			{
				sound (self, CHAN_WEAPON, "weapons/reload3.wav", 1.00, ATTN_NORM);
				self.weaponframe = 10;
				loadwep();
				self.attack_finished = (time + 0.5);
			}
			else
			{
				if ((self.weapon == IT_MORTER))
				{
					sound (self, CHAN_WEAPON, "weapons/reload4.wav", 1.00, ATTN_NORM);
					self.weaponframe = 7;
					loadwep();
					self.attack_finished = (time + 0.5);
				}
				else
				{
					if ((self.weapon == IT_MINI))
						sound (self, CHAN_WEAPON, "weapons/reload3.wav", 1.00, ATTN_NORM);
				}
			}
		}
	}
	self.count = 0;
};

void() player_rail1;
void() player_railb1;
void() player_dual1;
void() player_blast1;
void() player_shot1;
void() player_hellfire1;
void() player_oozi1;
void() player_rocket1;
void() player_bag1;
void() open_rocket1;
void() player_morter1;
void() W_FireTorpedo;

void() W_Attack =
{
	UpdateAmmoBars();
	makevectors (self.v_angle);
	self.show_hostile = (time + 1.00);
	if ((self.probe_active == TRUE))
	{
		makevectors (self.v_angle);
		self.velocity = aim (self, 1.00);
		self.velocity = (self.velocity * 200);
		return;
	}
	if ((self.tools == (self.tools | UT_BIGASSGUN)))
	{
		self.atomic_intensity = 0;
		sound (self, CHAN_WEAPON, "misc/intense.wav", 1.00, ATTN_NORM);
		player_bag1();
		return;
	}
	if ((self.tools == (self.tools | UT_MINISUB)))
	{
		if ((self.tube_wing > 1))
			return;
		else
		{
			W_FireTorpedo();
			self.attack_finished = (time + 0.5);
			return;
		}
	}
	if (!W_CheckNoAmmo())
		return;
	if ((self.weapon == IT_44))
	{
		if (!(self.speed & CHSCAM_ON))
			self.weaponmodel = "progs/w_44.mdl";
		self.count_shot_idle = 40;
		if ((self.count == 10))
		{
			sprint (self, "Reload\n");
			sound (self, CHAN_AUTO, "weapons/misfire1.wav", 1.00, ATTN_NORM);
			self.attack_finished = (time + 0.2);
			return;
		}
		else
		{
			player_shot1();
			W_FireShotgun();
			self.attack_finished = (time + 0.2);
			self.count = (self.count + 1);
		}
	}
	else
	{
		if ((self.weapon == IT_SHOT))
		{
			if ((self.count == 16))
			{
				sprint (self, "Reload\n");
				sound (self, CHAN_AUTO, "weapons/misfire1.wav", 1.00, ATTN_NORM);
				self.attack_finished = (time + 0.2);
				return;
			}
			else
			{
				if ((self.ammo_shells2 < 2))
				{
					self.weapon = IT_44;
					W_SetCurrentAmmo();
					return;
				}
				else
				{
					player_hellfire1();
					W_FireShotgun();
					self.attack_finished = (time + 0.2);
					self.count = (self.count + 1);
				}
			}
		}
		else
		{
			if ((self.weapon == IT_SHOT2))
			{
				if ((self.count == 8))
				{
					sprint (self, "Reload\n");
					self.attack_finished = (time + 0.4);
					sound (self, CHAN_AUTO, "weapons/misfire2.wav", 1.00, ATTN_NORM);
					return;
				}
				else
				{
					if ((self.ammo_shells2 < 4))
					{
						self.weapon = IT_44;
						W_SetCurrentAmmo();
						return;
					}
					else
					{
						player_blast1();
						W_FireSuperShotgun();
						self.attack_finished = (time + 0.5);
						self.count = (self.count + 1);
					}
				}
			}
			else
			{
				if ((self.weapon == IT_UZI))
					player_oozi1();
				else
				{
					if ((self.weapon == IT_MINI))
						player_oozi1();
					else
					{
						if ((self.weapon == IT_MORTER))
						{
							if ((self.count == 6))
							{
								sprint (self, "Reload\n");
								self.attack_finished = (time + 1.00);
								sound (self, CHAN_AUTO, "weapons/misfire2.wav", 1.00, ATTN_NORM);
								return;
							}
							else
							{
								if ((self.ammo_rockets2 < 2))
								{
									self.weapon = IT_44;
									W_SetCurrentAmmo();
									return;
								}
								player_morter1();
								W_FireMorter();
								self.attack_finished = (time + 1.00);
								self.count = (self.count + 1.00);
							}
						}
						else
						{
							if ((self.weapon == IT_ROCKET))
							{
								player_rocket1();
								self.attack_finished = (time + 1.15);
							}
							else
							{
								if ((self.weapon == IT_PUNISHER))
								{
									if ((self.barrel2 == FALSE))
										player_rail1();
									else
										player_railb1();
									W_FireRail();
									self.attack_finished = (time + 0.5);
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

	if (((self.tools == (self.tools | UT_BIGASSGUN)) || (self.tools == (self.tools | UT_MINISUB))))
		return;
	if ((self.probe_active == TRUE))
		return;
	it = self.items;
	am = FALSE;
	if ((self.impulse == 1))
	{
		if ((self.weapon == IT_44))
			return;
		fl = IT_44;
		self.count_shot_idle = 40;
	}
	else
	{
		if ((self.impulse == 2))
		{
			if ((self.weapon == IT_SHOT))
				return;
			fl = IT_SHOT;
			if ((self.ammo_shells2 < 2))
				am = TRUE;
		}
		else
		{
			if ((self.impulse == 3))
			{
				if ((self.weapon == IT_SHOT2))
					return;
				fl = IT_SHOT2;
				if ((self.ammo_shells2 < 4))
					am = TRUE;
			}
			else
			{
				if ((self.impulse == 4))
				{
					if ((self.weapon == IT_UZI))
						return;
					fl = IT_UZI;
					if ((self.ammo_nails2 < 1))
						am = TRUE;
				}
				else
				{
					if ((self.impulse == 5))
					{
						if ((self.weapon == IT_MINI))
							return;
						fl = IT_MINI;
						if ((self.ammo_nails2 < 1))
							am = TRUE;
					}
					else
					{
						if ((self.impulse == 6))
						{
							if ((self.weapon == IT_MORTER))
								return;
							fl = IT_MORTER;
							if ((self.ammo_rockets2 < 2))
								am = TRUE;
						}
						else
						{
							if ((self.impulse == 7))
							{
								if ((((self.weapon == IT_ROCKET) || (self.items != (self.items | IT_ROCKET))) || (self.ammo_rockets < 1)))
									return;
								open_rocket1();
								sound (self, CHAN_AUTO, "weapons/loadrock.wav", 1.00, ATTN_NORM);
								fl = IT_ROCKET;
								if ((self.ammo_rockets2 < 1))
									am = TRUE;
							}
							else
							{
								if ((self.impulse == 8))
								{
									if ((self.weapon == IT_PUNISHER))
										return;
									fl = IT_PUNISHER;
									if ((self.ammo_cells2 < 1))
										am = TRUE;
								}
							}
						}
					}
				}
			}
		}
	}
	self.impulse = 0;
	if (!(self.items & fl))
	{
		sprint (self, "no weapon.\n");
		return;
	}
	if (am)
	{
		sprint (self, "not enough ammo.\n");
		return;
	}
	self.weapon = fl;
	W_SetCurrentAmmo();
};


void() CheatCommand =
{
	if ((deathmatch || coop))
		return;
	self.ammo_rockets2 = 100;
	self.ammo_nails2 = 200;
	self.ammo_shells2 = 100;
	self.items = ((((((((((self.items | IT_44) | IT_ARMOR1) | IT_UZI) | IT_SHOT) | IT_SHOT2) | IT_ROCKET) | IT_MORTER) | IT_MINI) | IT_KEY1) | IT_KEY2);
	self.tools = ((((self.tools | UT_CHUTE) | UT_PROBE) | UT_HOVER) | UT_SCUBA);
	if (((self.hover_active == TRUE) || (self.probe_active == TRUE)))
		FireUtil();
	self.items = ((self.items - (self.items & ((IT_ARMOR1 | IT_ARMOR2) | IT_ARMOR3))) + IT_ARMOR1);
	self.util = UT_CHUTE;
	self.armorvalue = 9;
	self.ammo_cells2 = 100;
	self.items = (self.items | IT_PUNISHER);
	self.weapon = IT_ROCKET;
	self.impulse = 0;
	W_SetCurrentAmmo();
};


// ACC, supports both forward and backward cycle (the original code only supported next weapon)
void (float backward) CycleWeaponCommand =
	{
	local float it;
	local float am;

	if ((self.tools & UT_BIGASSGUN))
		return;
	if ((self.attack_finished > time) || self.button0)
		return;
	if (self.probe_active == TRUE)
		return;

	it = self.items;
	self.impulse = 0;

	while (TRUE)
		{
		am = FALSE;

		if (backward == FALSE)
			{
			if (self.weapon == IT_PUNISHER)
				self.weapon = IT_44;
			else if (self.weapon == IT_44)
				self.weapon = IT_SHOT;
			else if (self.weapon == IT_SHOT)
				self.weapon = IT_SHOT2;
			else if (self.weapon == IT_SHOT2)
				self.weapon = IT_UZI;
			else if (self.weapon == IT_UZI)
				self.weapon = IT_MINI;
			else if (self.weapon == IT_MINI)
				self.weapon = IT_MORTER;
			else if (self.weapon == IT_MORTER)
				self.weapon = IT_ROCKET;
			else if (self.weapon == IT_ROCKET)
				self.weapon = IT_PUNISHER;
			}
		else
			{
			if (self.weapon == IT_PUNISHER)
				self.weapon = IT_ROCKET;
			else if (self.weapon == IT_ROCKET)
				self.weapon = IT_MORTER;
			else if (self.weapon == IT_MORTER)
				self.weapon = IT_MINI;
			else if (self.weapon == IT_MINI)
				self.weapon = IT_UZI;
			else if (self.weapon == IT_UZI)
				self.weapon = IT_SHOT2;
			else if (self.weapon == IT_SHOT2)
				self.weapon = IT_SHOT;
			else if (self.weapon == IT_SHOT)
				self.weapon = IT_44;
			else if (self.weapon == IT_44)
				self.weapon = IT_PUNISHER;
			}

		if ((self.weapon == IT_SHOT) && (self.ammo_shells2 < 2))
			am = TRUE;
		else if ((self.weapon == IT_SHOT2) && (self.ammo_shells2 < 4))
			am = TRUE;
		else if ((self.weapon == IT_UZI) && (self.ammo_nails2 < 1))
			am = TRUE;
		else if ((self.weapon == IT_MINI) && (self.ammo_nails2 < 1))
			am = TRUE;
		else if ((self.weapon == IT_MORTER) && (self.ammo_rockets2 < 1))
			am = TRUE;
		else if ((self.weapon == IT_ROCKET) && (self.ammo_rockets2 < 1))
			am = TRUE;
		else if ((self.weapon == IT_PUNISHER) && (self.ammo_cells2 < 1))
			am = TRUE;

		if ((self.items & self.weapon) && (am == FALSE))
			{
			if (self.weapon == IT_ROCKET)
				{
				open_rocket1();
				sound (self, CHAN_BODY, "weapons/loadrock.wav", 1, ATTN_NORM);
				}
			else
				sound (self, CHAN_BODY, "misc/null.wav", 1, ATTN_NORM);
			W_SetCurrentAmmo();
			self.count_shot_idle = 40;
			return;
			}
		}
	};


void() ServerflagsCommand =
	{
	serverflags = (serverflags * 2) + 1;
	};

void(float backward) CycleUtil;	// ACC, now handles both previous and next toy (see utils.qc)

void() release_deathsquad;

void() ImpulseCommands =
	{
	local string sv;
	local float cmax_num;

	if ((self.impulse >= 1) && (self.impulse <= 8))
		W_ChangeWeapon();
	if (self.impulse == 9)
		CheatCommand();
	if (self.impulse == 10)	// ACC, new NextWeap
		CycleWeaponCommand(FALSE);
	if (self.impulse == 11)
		ServerflagsCommand();
	if (self.impulse == 12)	// ACC, used to be WeaponReload, moved to 16 since Quake ports use impulse 12 for cycle to previous weapon
		CycleWeaponCommand(TRUE);
	if (self.impulse == 13)
		FireUtil();
	if (self.impulse == 14)	// ACC, new NextToy
		CycleUtil(FALSE);
	if (self.impulse == 15)	// ACC, new PrevToy
		CycleUtil(TRUE);
	if (self.impulse == 16)	// ACC, new WeaponReload impulse (used to be 12)
		WeaponReload();
	if (self.impulse == 17)	// ACC, new Flashlight
		{
		sound (self, CHAN_VOICE, "utils/pickup.wav", 1.00, ATTN_NORM);
		FlashlightToggle();
		}
	if (self.impulse == 66)
		release_deathsquad();
	if (self.impulse == 100)
		{
		sound (self, CHAN_VOICE, "utils/pickup.wav", 1.00, ATTN_NORM);
		if (self.automount == FALSE)
			{
			self.automount = TRUE;
			stuffcmd (self, "echo Weapon AutoMount ON");
			}
		else
			{
			self.automount = FALSE;
			stuffcmd (self, "echo Weapon AutoMount OFF");
			}
		}
	if (self.impulse == 180)
		{
		bprint (vtos (self.origin));
		bprint ("\n");
		}
	if (self.impulse == 30)
		Toggle_chase_cam();
	self.impulse = 0;
	};

void() W_WeaponFrame =
	{
	if (time < self.attack_finished)
		return;
	ImpulseCommands();
	if (self.button0)
		W_Attack();
	};


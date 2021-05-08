void() info_null = 
{
	remove(self);
};

void() info_notnull = 
{
};

void() light_use = 
{
	if (self.spawnflags & START_OFF)
	{
		lightstyle(self.style, "m");
		self.spawnflags = self.spawnflags - START_OFF;
	}
	else
	{
		lightstyle(self.style, "a");
		self.spawnflags = self.spawnflags + START_OFF;
	}
};

void() light = 
{
	if (!(self.targetname))
	{
		remove(self);
		return;
	}
	if (self.style >= FL_MONSTER)
	{
		self.use = light_use;
		if (self.spawnflags & START_OFF)
		{
			lightstyle(self.style, "a");
		}
		else
		{
			lightstyle(self.style, "m");
		}
	}
};

void() light_fluoro = 
{
	if (self.style >= FL_MONSTER)
	{
		self.use = light_use;
		if (self.spawnflags & START_OFF)
		{
			lightstyle(self.style, "a");
		}
		else
		{
			lightstyle(self.style, "m");
		}
	}
	precache_sound("ambience/fl_hum1.wav");
	ambientsound(self.origin, "ambience/fl_hum1.wav", 0.5, ATTN_STATIC);
};

void() light_fluorospark = 
{
	if (!(self.style))
	{
		self.style = MOVETYPE_BOUNCE;
	}
	precache_sound("ambience/buzz1.wav");
	ambientsound(self.origin, "ambience/buzz1.wav", 0.5, ATTN_STATIC);
};

void() light_globe = 
{
	precache_model("progs/s_light.spr");
	setmodel(self, "progs/s_light.spr");
	makestatic(self);
};

void() FireAmbient = 
{
	precache_sound("ambience/fire1.wav");
	ambientsound(self.origin, "ambience/fire1.wav", 0.5, ATTN_STATIC);
};

void() light_torch_small_walltorch = 
{
	precache_model("progs/flame.mdl");
	setmodel(self, "progs/flame.mdl");
	FireAmbient();
	makestatic(self);
};

void() light_flame_large_yellow = 
{
	precache_model("progs/flame2.mdl");
	setmodel(self, "progs/flame2.mdl");
	self.frame = 1;
	FireAmbient();
	makestatic(self);
};

void() light_flame_small_yellow = 
{
	precache_model("progs/flame2.mdl");
	setmodel(self, "progs/flame2.mdl");
	FireAmbient();
	makestatic(self);
};

void() light_flame_small_white = 
{
	precache_model("progs/flame2.mdl");
	setmodel(self, "progs/flame2.mdl");
	FireAmbient();
	makestatic(self);
};

void() misc_fireball = 
{
	precache_model("progs/lavaball.mdl");
	self.classname = "fireball";
	self.nextthink = time + random() * MOVETYPE_FLY;
	self.think = fire_fly;
	if (!(self.speed))
	{
		self.speed == 1000;
	}
};

void() fire_fly = 
{
	local entity fireball;
	fireball = spawn();
	fireball.solid = SOLID_TRIGGER;
	fireball.movetype = MOVETYPE_TOSS;
	fireball.velocity = '0 0 1000';
	fireball.velocity_x = random() * 100 - 50;
	fireball.velocity_y = random() * 100 - 50;
	fireball.velocity_z = self.speed + random() * MAX_CHARMER_DISTANCE;
	fireball.classname = "fireball";
	setmodel(fireball, "progs/lavaball.mdl");
	setsize(fireball, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(fireball, self.origin);
	fireball.nextthink = time + MOVETYPE_FLY;
	fireball.think = SUB_Remove;
	fireball.touch = fire_touch;
	self.nextthink = time + random() * MOVETYPE_FLY + MOVETYPE_WALK;
	self.think = fire_fly;
};

void() fire_touch = 
{
	T_Damage(other, self, self, BOSS);
	remove(self);
};

void() barrel_explode = 
{
	self.takedamage = DAMAGE_NO;
	self.classname = "explo_box";
	T_RadiusDamage(self, self, 160, world);
	sound(self, CHAN_VOICE, "weapons/r_exp3.wav", 1, ATTN_NORM);
	particle(self.origin, VEC_ORIGIN, 75, 255);
	self.origin_z = self.origin_z + FL_MONSTER;
	BecomeExplosion();
};

void() misc_explobox = 
{
	local float oldz;
	self.solid = SOLID_BBOX;
	self.movetype = MOVETYPE_NONE;
	precache_model("maps/b_explob.bsp");
	setmodel(self, "maps/b_explob.bsp");
	precache_sound("weapons/r_exp3.wav");
	self.health = BOSS;
	self.th_die = barrel_explode;
	self.takedamage = DAMAGE_AIM;
	self.origin_z = self.origin_z + FL_SWIM;
	oldz = self.origin_z;
	droptofloor();
	if (oldz - self.origin_z > 250)
	{
		dprint("item fell out of level at ");
		dprint(vtos(self.origin));
		dprint("\n");
		remove(self);
	}
};

void() misc_explobox2 = 
{
	local float oldz;
	self.solid = SOLID_BBOX;
	self.movetype = MOVETYPE_NONE;
	precache_model2("maps/b_exbox2.bsp");
	setmodel(self, "maps/b_exbox2.bsp");
	precache_sound("weapons/r_exp3.wav");
	self.health = BOSS;
	self.th_die = barrel_explode;
	self.takedamage = DAMAGE_AIM;
	self.origin_z = self.origin_z + FL_SWIM;
	oldz = self.origin_z;
	droptofloor();
	if (oldz - self.origin_z > 250)
	{
		dprint("item fell out of level at ");
		dprint(vtos(self.origin));
		dprint("\n");
		remove(self);
	}
};

void() spikeshooter_use = 
{
	local entity lavaball;
	if (self.spawnflags & SPAWNFLAG_LASER)
	{
		if (!(self.spawnflags & SPAWNFLAG_SILENT))
		{
			sound(self, CHAN_VOICE, "enforcer/enfire.wav", 1, ATTN_NORM);
		}
		LaunchLaser(self.origin, self.movedir);
		newmis.spawnflags = self.spawnflags;
	}
	else
	{
		if (self.spawnflags & SPAWNFLAG_LAVABALL)
		{
			if (!(self.spawnflags & SPAWNFLAG_SILENT))
			{
				sound(self, CHAN_VOICE, "misc/spike.wav", 1, ATTN_NORM);
			}
			lavaball = spawn();
			lavaball.movetype = MOVETYPE_FLYMISSILE;
			lavaball.solid = SOLID_BBOX;
			lavaball.classname = "lavaball";
			lavaball.velocity = self.movedir * 300;
			lavaball.angles = vectoangles(lavaball.velocity);
			lavaball.owner = self;
			lavaball.touch = T_MissileTouch;
			setmodel(lavaball, "progs/lavarock.mdl");
			setsize(lavaball, '-4 -4 -4', '4 4 4');
			setorigin(lavaball, self.origin);
			lavaball.avelocity = '0 0 400';
			lavaball.nextthink = time + MOVETYPE_FLY;
			lavaball.think = SUB_Remove;
		}
		else
		{
			if (self.spawnflags & SPAWNFLAG_ROCKET)
			{
				if (!(self.spawnflags & SPAWNFLAG_SILENT))
				{
					sound(self, CHAN_VOICE, "weapons/sgun1.wav", 1, ATTN_NORM);
				}
				W_FireRocket();
				newmis.velocity = self.movedir * 1000;
				newmis.angles = vectoangles(newmis.velocity);
				setorigin(newmis, self.origin + self.movedir * FL_CLIENT);
			}
			else
			{
				if (!(self.spawnflags & SPAWNFLAG_SILENT))
				{
					sound(self, CHAN_VOICE, "weapons/spike2.wav", 1, ATTN_NORM);
				}
				launch_spike(self.origin, self.movedir);
				newmis.velocity = self.movedir * 500;
				if (self.spawnflags & SPAWNFLAG_SUPERSPIKE)
				{
					newmis.touch = superspike_touch;
				}
			}
		}
	}
};

void() shooter_think = 
{
	if (self.state)
	{
		spikeshooter_use();
	}
	self.nextthink = time + self.wait;
};

void() trap_spikeshooter = 
{
	SetMovedir();
	self.use = spikeshooter_use;
	if (self.spawnflags & SPAWNFLAG_LASER)
	{
		precache_model2("progs/laser.mdl");
		precache_sound2("enforcer/enfire.wav");
		precache_sound2("enforcer/enfstop.wav");
	}
	else
	{
		if (self.spawnflags & SPAWNFLAG_LAVABALL)
		{
			precache_model("progs/lavarock.mdl");
			precache_sound2("misc/spike.wav");
		}
		else
		{
			if (self.spawnflags & SPAWNFLAG_ROCKET)
			{
				precache_model("progs/missile.mdl");
				precache_sound("weapons/sgun1.wav");
			}
			else
			{
				precache_sound("weapons/spike2.wav");
			}
		}
	}
};

void() trap_shooter = 
{
	trap_spikeshooter();
	if (self.wait == 0)
	{
		self.wait = 1;
	}
	self.state = 1;
	self.nextthink = self.nextthink + self.wait + self.ltime;
	self.think = shooter_think;
};

void() trap_shooter_use = 
{
	self.state = 1 - self.state;
};

void() trap_switched_shooter = 
{
	trap_spikeshooter();
	if (self.wait == 0)
	{
		self.wait = 1;
	}
	self.nextthink = self.nextthink + self.wait + self.ltime;
	self.think = shooter_think;
	self.use = trap_shooter_use;
};

void() air_bubbles = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model("progs/s_bubble.spr");
	self.nextthink = time + 1;
	self.think = make_bubbles;
};

void() make_bubbles = 
{
	local entity bubble;
	bubble = spawn();
	setmodel(bubble, "progs/s_bubble.spr");
	setorigin(bubble, self.origin);
	bubble.movetype = MOVETYPE_NOCLIP;
	bubble.solid = SOLID_NOT;
	bubble.velocity = '0 0 15';
	bubble.nextthink = time + 0.5;
	bubble.think = bubble_bob;
	bubble.touch = bubble_remove;
	bubble.classname = "bubble";
	bubble.frame = 0;
	bubble.cnt = 0;
	setsize(bubble, '-8 -8 -8', '8 8 8');
	self.nextthink = time + random() + 0.5;
	self.think = make_bubbles;
};

void() bubble_split = 
{
	local entity bubble;
	bubble = spawn();
	setmodel(bubble, "progs/s_bubble.spr");
	setorigin(bubble, self.origin);
	bubble.movetype = MOVETYPE_NOCLIP;
	bubble.solid = SOLID_NOT;
	bubble.velocity = self.velocity;
	bubble.nextthink = time + 0.5;
	bubble.think = bubble_bob;
	bubble.touch = bubble_remove;
	bubble.classname = "bubble";
	bubble.frame = 1;
	bubble.cnt = MOVETYPE_BOUNCE;
	setsize(bubble, '-8 -8 -8', '8 8 8');
	self.frame = 1;
	self.cnt = MOVETYPE_BOUNCE;
	if (self.waterlevel != MOVETYPE_WALK)
	{
		remove(self);
	}
};

void() bubble_remove = 
{
	if (other.classname == self.classname)
	{
		return;
	}
	remove(self);
};

void() bubble_bob = 
{
	local float rnd1;
	local float rnd2;
	local float rnd3;
	local vector vtmp1;
	local vector modi;
	self.cnt = self.cnt + 1;
	if (self.cnt == MOVETYPE_STEP)
	{
		bubble_split();
	}
	if (self.cnt == BOSS)
	{
		remove(self);
	}
	rnd1 = self.velocity_x + (-10 + random() * BOSS);
	rnd2 = self.velocity_y + (-10 + random() * BOSS);
	rnd3 = self.velocity_z + MOVETYPE_BOUNCE + random() * MOVETYPE_BOUNCE;
	if (rnd1 > MOVETYPE_BOUNCE)
	{
		rnd1 = MOVETYPE_FLY;
	}
	if (rnd1 < -10)
	{
		rnd1 = CONTENT_LAVA;
	}
	if (rnd2 > MOVETYPE_BOUNCE)
	{
		rnd2 = MOVETYPE_FLY;
	}
	if (rnd2 < -10)
	{
		rnd2 = CONTENT_LAVA;
	}
	if (rnd3 < MOVETYPE_BOUNCE)
	{
		rnd3 = BAZOOKA;
	}
	if (rnd3 > SVC_INTERMISSION)
	{
		rnd3 = 25;
	}
	self.velocity_x = rnd1;
	self.velocity_y = rnd2;
	self.velocity_z = rnd3;
	self.nextthink = time + 0.5;
	self.think = bubble_bob;
};

void() viewthing = 
{
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	precache_model("progs/player.mdl");
	setmodel(self, "progs/player.mdl");
};

void() func_wall_use = 
{
	self.frame = 1 - self.frame;
};

void() func_wall = 
{
	self.angles = VEC_ORIGIN;
	self.movetype = MOVETYPE_PUSH;
	self.solid = SOLID_BSP;
	self.use = func_wall_use;
	setmodel(self, self.model);
};

void() func_illusionary = 
{
	self.angles = VEC_ORIGIN;
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	setmodel(self, self.model);
	makestatic();
};

void() func_episodegate = 
{
	if (!(serverflags & self.spawnflags))
	{
		return;
	}
	self.angles = VEC_ORIGIN;
	self.movetype = MOVETYPE_PUSH;
	self.solid = SOLID_BSP;
	self.use = func_wall_use;
	setmodel(self, self.model);
};

void() func_bossgate = 
{
	if ((serverflags & BAZOOKA) == BAZOOKA)
	{
		return;
	}
	self.angles = VEC_ORIGIN;
	self.movetype = MOVETYPE_PUSH;
	self.solid = SOLID_BSP;
	self.use = func_wall_use;
	setmodel(self, self.model);
};

void() ambient_suck_wind = 
{
	precache_sound("ambience/suck1.wav");
	ambientsound(self.origin, "ambience/suck1.wav", 1, ATTN_STATIC);
};

void() ambient_drone = 
{
	precache_sound("ambience/drone6.wav");
	ambientsound(self.origin, "ambience/drone6.wav", 0.5, ATTN_STATIC);
};

void() ambient_flouro_buzz = 
{
	precache_sound("ambience/buzz1.wav");
	ambientsound(self.origin, "ambience/buzz1.wav", 1, ATTN_STATIC);
};

void() ambient_drip = 
{
	precache_sound("ambience/drip1.wav");
	ambientsound(self.origin, "ambience/drip1.wav", 0.5, ATTN_STATIC);
};

void() ambient_comp_hum = 
{
	precache_sound("ambience/comp1.wav");
	ambientsound(self.origin, "ambience/comp1.wav", 1, ATTN_STATIC);
};

void() ambient_thunder = 
{
	precache_sound("ambience/thunder1.wav");
	ambientsound(self.origin, "ambience/thunder1.wav", 0.5, ATTN_STATIC);
};

void() ambient_light_buzz = 
{
	precache_sound("ambience/fl_hum1.wav");
	ambientsound(self.origin, "ambience/fl_hum1.wav", 0.5, ATTN_STATIC);
};

void() ambient_swamp1 = 
{
	precache_sound("ambience/swamp1.wav");
	ambientsound(self.origin, "ambience/swamp1.wav", 0.5, ATTN_STATIC);
};

void() ambient_swamp2 = 
{
	precache_sound("ambience/swamp2.wav");
	ambientsound(self.origin, "ambience/swamp2.wav", 0.5, ATTN_STATIC);
};

void() noise_think = 
{
	self.nextthink = time + 0.5;
	sound(self, 1, "enforcer/enfire.wav", 1, ATTN_NORM);
	sound(self, FL_SWIM, "enforcer/enfstop.wav", 1, ATTN_NORM);
	sound(self, MOVETYPE_WALK, "enforcer/sight1.wav", 1, ATTN_NORM);
	sound(self, MOVETYPE_STEP, "enforcer/sight2.wav", 1, ATTN_NORM);
	sound(self, MOVETYPE_FLY, "enforcer/sight3.wav", 1, ATTN_NORM);
	sound(self, MOVETYPE_TOSS, "enforcer/sight4.wav", 1, ATTN_NORM);
	sound(self, MOVETYPE_PUSH, "enforcer/pain1.wav", 1, ATTN_NORM);
};

void() misc_noisemaker = 
{
	precache_sound2("enforcer/enfire.wav");
	precache_sound2("enforcer/enfstop.wav");
	precache_sound2("enforcer/sight1.wav");
	precache_sound2("enforcer/sight2.wav");
	precache_sound2("enforcer/sight3.wav");
	precache_sound2("enforcer/sight4.wav");
	precache_sound2("enforcer/pain1.wav");
	precache_sound2("enforcer/pain2.wav");
	precache_sound2("enforcer/death1.wav");
	precache_sound2("enforcer/idle1.wav");
	self.nextthink = time + 0.1 + random();
	self.think = noise_think;
};


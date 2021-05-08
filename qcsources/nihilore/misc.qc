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
	if (self.style >= DOOR_TOGGLE)
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
	if (self.style >= DOOR_TOGGLE)
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
		self.style = SVC_SETVIEWANGLES;
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
	self.frame = START_OFF;
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
	self.nextthink = time + random() * SVC_SETVIEWPORT;
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
	fireball.velocity_z = self.speed + random() * 200;
	fireball.classname = "fireball";
	setmodel(fireball, "progs/lavaball.mdl");
	setsize(fireball, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(fireball, self.origin);
	fireball.nextthink = time + SVC_SETVIEWPORT;
	fireball.think = SUB_Remove;
	fireball.touch = fire_touch;
	self.nextthink = time + random() * SVC_SETVIEWPORT + SVC_UPDATESTAT;
	self.think = fire_fly;
};

void() fire_touch = 
{
	T_Damage(other, self, self, 20);
	remove(self);
};

void() barrel_explode = 
{
	self.takedamage = DAMAGE_NO;
	self.classname = "explo_box";
	T_RadiusDamage(self, self, 160, world);
	sound(self, CHAN_VOICE, "weapons/r_exp3.wav", START_OFF, ATTN_NORM);
	particle(self.origin, VEC_ORIGIN, 75, 255);
	self.origin_z = self.origin_z + DOOR_TOGGLE;
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
	self.health = 20;
	self.th_die = barrel_explode;
	self.takedamage = DAMAGE_AIM;
	self.origin_z = self.origin_z + SILENT;
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
	self.health = 20;
	self.th_die = barrel_explode;
	self.takedamage = DAMAGE_AIM;
	self.origin_z = self.origin_z + SILENT;
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
	if (self.spawnflags & SPAWNFLAG_LASER)
	{
		if (!(self.spawnflags & SPAWNFLAG_SILENT))
		{
			sound(self, CHAN_VOICE, "enforcer/enfire.wav", START_OFF, ATTN_NORM);
		}
		launch_missile("progs/laser.mdl", self.origin, self.movedir * self.speed);
	}
	else
	{
		if (self.spawnflags & SPAWNFLAG_LAVABALL)
		{
			if (!(self.spawnflags & SPAWNFLAG_SILENT))
			{
				sound(self, CHAN_VOICE, "weapons/spike2.wav", START_OFF, ATTN_NORM);
			}
			newmis = launch_missile("progs/lavaball.mdl", self.origin, self.movedir * (self.speed - 100 + random() * 200));
		}
		else
		{
			if (self.spawnflags & SPAWNFLAG_ROCKET)
			{
				if (!(self.spawnflags & SPAWNFLAG_SILENT))
				{
					sound(self, CHAN_VOICE, "weapons/sgun1.wav", START_OFF, ATTN_NORM);
				}
				launch_missile("progs/missile.mdl", self.origin, self.movedir * self.speed);
			}
			else
			{
				if (self.spawnflags & SPAWNFLAG_GRENADE)
				{
					if (!(self.spawnflags & SPAWNFLAG_SILENT))
					{
						sound(self, CHAN_VOICE, "weapons/grenade.wav", START_OFF, ATTN_NORM);
					}
					launch_missile("progs/grenade.mdl", self.origin, self.movedir * self.speed);
				}
				else
				{
					if (self.spawnflags & SPAWNFLAG_ARROW)
					{
						if (!(self.spawnflags & SPAWNFLAG_SILENT))
						{
							sound(self, CHAN_VOICE, "weapons/lncharow.wav", START_OFF, ATTN_NORM);
						}
						launch_missile("progs/arrow.mdl", self.origin, self.movedir * self.speed);
					}
					else
					{
						if (self.spawnflags & SPAWNFLAG_PPC)
						{
							if (self.waterlevel > START_OFF)
							{
								beam_water_burst(self.ammo_cells * SILENT);
								self.ammo_cells = MSG_BROADCAST;
								self.currentammo = MSG_BROADCAST;
								return;
							}
							newmis = spawn();
							newmis.solid = SOLID_NOT;
							newmis.movetype = MOVETYPE_FLY;
							newmis.currentammo = self.speed;
							setorigin(newmis, self.origin);
							newmis.owner = self;
							newmis.think = beam_generate;
							newmis.nextthink = time + 0.05;
						}
						else
						{
							if (!(self.spawnflags & SPAWNFLAG_SILENT))
							{
								sound(self, CHAN_VOICE, "weapons/spike2.wav", START_OFF, ATTN_NORM);
							}
							if (self.spawnflags & SPAWNFLAG_SUPERSPIKE)
							{
								launch_missile("progs/s_spike.mdl", self.origin, self.movedir * self.speed);
							}
							else
							{
								launch_missile("progs/spike.mdl", self.origin, self.movedir * self.speed);
							}
						}
					}
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
		if (!(self.speed))
		{
			self.speed = 600;
		}
	}
	else
	{
		if (self.spawnflags & SPAWNFLAG_LAVABALL)
		{
			precache_model("progs/lavaball.mdl");
			precache_sound("weapons/spike2.wav");
			if (!(self.speed))
			{
				self.speed = 900;
			}
		}
		else
		{
			if (self.spawnflags & SPAWNFLAG_ROCKET)
			{
				precache_model("progs/missile.mdl");
				precache_sound("weapons/sgun1.wav");
				if (!(self.speed))
				{
					self.speed = 1000;
				}
			}
			else
			{
				if (self.spawnflags & SPAWNFLAG_GRENADE)
				{
					precache_sound("weapons/grenade.wav");
					precache_model("progs/grenade.mdl");
					if (!(self.speed))
					{
						self.speed = 600;
					}
				}
				else
				{
					if (self.spawnflags & SPAWNFLAG_ARROW)
					{
						precache_model("progs/arrow.mdl");
						precache_sound("weapons/lncharow.wav");
						precache_sound("weapons/arrowhit.wav");
						if (!(self.speed))
						{
							self.speed = 700;
						}
					}
					else
					{
						if (self.spawnflags & SPAWNFLAG_PPC)
						{
							if (!(self.speed))
							{
								self.speed = 20;
							}
						}
						else
						{
							precache_sound("weapons/spike2.wav");
							if (!(self.speed))
							{
								self.speed = 500;
							}
						}
					}
				}
			}
		}
	}
	if (!(self.gravity))
	{
		self.gravity = START_OFF;
	}
	else
	{
		self.gravity = (self.gravity - START_OFF) / 100;
	}
};

void() trap_shooter = 
{
	trap_spikeshooter();
	if (self.wait == MSG_BROADCAST)
	{
		self.wait = START_OFF;
	}
	self.state = START_OFF;
	self.nextthink = self.nextthink + self.wait + self.ltime;
	self.think = shooter_think;
};

void() trap_shooter_use = 
{
	self.state = START_OFF - self.state;
};

void() trap_switched_shooter = 
{
	trap_spikeshooter();
	if (self.wait == MSG_BROADCAST)
	{
		self.wait = START_OFF;
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
	self.nextthink = time + START_OFF;
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
	bubble.frame = MSG_BROADCAST;
	bubble.cnt = MSG_BROADCAST;
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
	bubble.frame = START_OFF;
	bubble.cnt = SVC_SETVIEWANGLES;
	setsize(bubble, '-8 -8 -8', '8 8 8');
	self.frame = START_OFF;
	self.cnt = SVC_SETVIEWANGLES;
	if (self.waterlevel != SVC_UPDATESTAT)
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
	self.cnt = self.cnt + START_OFF;
	if (self.cnt == SECRET_1ST_DOWN)
	{
		bubble_split();
	}
	if (self.cnt == 20)
	{
		remove(self);
	}
	rnd1 = self.velocity_x + (-10 + random() * 20);
	rnd2 = self.velocity_y + (-10 + random() * 20);
	rnd3 = self.velocity_z + SVC_SETVIEWANGLES + random() * SVC_SETVIEWANGLES;
	if (rnd1 > SVC_SETVIEWANGLES)
	{
		rnd1 = SVC_SETVIEWPORT;
	}
	if (rnd1 < -10)
	{
		rnd1 = CONTENT_LAVA;
	}
	if (rnd2 > SVC_SETVIEWANGLES)
	{
		rnd2 = SVC_SETVIEWPORT;
	}
	if (rnd2 < -10)
	{
		rnd2 = CONTENT_LAVA;
	}
	if (rnd3 < SVC_SETVIEWANGLES)
	{
		rnd3 = 15;
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
	self.frame = START_OFF - self.frame;
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
	if ((serverflags & 15) == 15)
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
	ambientsound(self.origin, "ambience/suck1.wav", START_OFF, ATTN_STATIC);
};

void() ambient_drone = 
{
	precache_sound("ambience/drone6.wav");
	ambientsound(self.origin, "ambience/drone6.wav", 0.5, ATTN_STATIC);
};

void() ambient_flouro_buzz = 
{
	precache_sound("ambience/buzz1.wav");
	ambientsound(self.origin, "ambience/buzz1.wav", START_OFF, ATTN_STATIC);
};

void() ambient_drip = 
{
	precache_sound("ambience/drip1.wav");
	ambientsound(self.origin, "ambience/drip1.wav", 0.5, ATTN_STATIC);
};

void() ambient_comp_hum = 
{
	precache_sound("ambience/comp1.wav");
	ambientsound(self.origin, "ambience/comp1.wav", START_OFF, ATTN_STATIC);
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
	sound(self, START_OFF, "enforcer/enfire.wav", START_OFF, ATTN_NORM);
	sound(self, SILENT, "enforcer/enfstop.wav", START_OFF, ATTN_NORM);
	sound(self, SVC_UPDATESTAT, "enforcer/sight1.wav", START_OFF, ATTN_NORM);
	sound(self, SECRET_1ST_DOWN, "enforcer/sight2.wav", START_OFF, ATTN_NORM);
	sound(self, SVC_SETVIEWPORT, "enforcer/sight3.wav", START_OFF, ATTN_NORM);
	sound(self, TE_LIGHTNING2, "enforcer/sight4.wav", START_OFF, ATTN_NORM);
	sound(self, TE_WIZSPIKE, "enforcer/pain1.wav", START_OFF, ATTN_NORM);
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


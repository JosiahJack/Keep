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
		self.style = TE_LAVASPLASH;
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
	self.nextthink = time + random() * TE_LIGHTNING1;
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
	fireball.velocity_x = random() * MAX_CELLS - 50;
	fireball.velocity_y = random() * MAX_CELLS - 50;
	fireball.velocity_z = self.speed + random() * MAX_NAILS;
	fireball.classname = "fireball";
	setmodel(fireball, "progs/lavaball.mdl");
	setsize(fireball, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(fireball, self.origin);
	fireball.nextthink = time + TE_LIGHTNING1;
	fireball.think = SUB_Remove;
	fireball.touch = fire_touch;
	self.nextthink = time + random() * TE_LIGHTNING1 + AS_MELEE;
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
		sound(self, CHAN_VOICE, "enforcer/enfire.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
		LaunchLaser(self.origin, self.movedir);
	}
	else
	{
		sound(self, CHAN_VOICE, "weapons/spike2.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
		newmis = NewBullet(self.origin, self.movedir, TE_LIGHTNING3, "progs/spike.mdl", spike_touch);
		newmis.velocity = self.movedir * 500;
		if (self.spawnflags & SPAWNFLAG_SUPERSPIKE)
		{
			newmis.weapon = TE_SUPERSPIKE;
			newmis.dmg = 18;
			setmodel(newmis, "progs/s_spike.mdl");
		}
	}
};

void() shooter_think = 
{
	spikeshooter_use();
	self.nextthink = time + self.wait;
	newmis.velocity = self.movedir * 500;
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
		precache_sound("weapons/spike2.wav");
	}
};

void() trap_shooter = 
{
	trap_spikeshooter();
	if (self.wait == MSG_BROADCAST)
	{
		self.wait = SPAWNFLAG_SUPERSPIKE;
	}
	self.nextthink = self.nextthink + self.wait + self.ltime;
	self.think = shooter_think;
};

void() air_bubbles = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model("progs/s_bubble.spr");
	self.nextthink = time + SPAWNFLAG_SUPERSPIKE;
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
	bubble.frame = SPAWNFLAG_SUPERSPIKE;
	bubble.cnt = TE_LAVASPLASH;
	setsize(bubble, '-8 -8 -8', '8 8 8');
	self.frame = SPAWNFLAG_SUPERSPIKE;
	self.cnt = TE_LAVASPLASH;
	if (self.waterlevel != AS_MELEE)
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
	self.cnt = self.cnt + SPAWNFLAG_SUPERSPIKE;
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
	rnd3 = self.velocity_z + TE_LAVASPLASH + random() * TE_LAVASPLASH;
	if (rnd1 > TE_LAVASPLASH)
	{
		rnd1 = TE_LIGHTNING1;
	}
	if (rnd1 < -10)
	{
		rnd1 = CONTENT_LAVA;
	}
	if (rnd2 > TE_LAVASPLASH)
	{
		rnd2 = TE_LIGHTNING1;
	}
	if (rnd2 < -10)
	{
		rnd2 = CONTENT_LAVA;
	}
	if (rnd3 < TE_LAVASPLASH)
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
	self.frame = SPAWNFLAG_SUPERSPIKE - self.frame;
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
	ambientsound(self.origin, "ambience/suck1.wav", SPAWNFLAG_SUPERSPIKE, ATTN_STATIC);
};

void() ambient_drone = 
{
	precache_sound("ambience/drone6.wav");
	ambientsound(self.origin, "ambience/drone6.wav", 0.5, ATTN_STATIC);
};

void() ambient_flouro_buzz = 
{
	precache_sound("ambience/buzz1.wav");
	ambientsound(self.origin, "ambience/buzz1.wav", SPAWNFLAG_SUPERSPIKE, ATTN_STATIC);
};

void() ambient_drip = 
{
	precache_sound("ambience/drip1.wav");
	ambientsound(self.origin, "ambience/drip1.wav", 0.5, ATTN_STATIC);
};

void() ambient_comp_hum = 
{
	precache_sound("ambience/comp1.wav");
	ambientsound(self.origin, "ambience/comp1.wav", SPAWNFLAG_SUPERSPIKE, ATTN_STATIC);
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
	sound(self, SPAWNFLAG_SUPERSPIKE, "enforcer/enfire.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
	sound(self, SPAWNFLAG_LASER, "enforcer/enfstop.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
	sound(self, AS_MELEE, "enforcer/sight1.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
	sound(self, SECRET_1ST_DOWN, "enforcer/sight2.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
	sound(self, TE_LIGHTNING1, "enforcer/sight3.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
	sound(self, TE_LIGHTNING2, "enforcer/sight4.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
	sound(self, TE_WIZSPIKE, "enforcer/pain1.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
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


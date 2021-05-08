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
	precache_sound("ambient/fl_hum1.wav");
	ambientsound(self.origin, "ambience/fl_hum1.wav", 0.5, ATTN_STATIC);
};

void() light_fluorospark = 
{
	if (!(self.style))
	{
		self.style = MIN_ANGLE_DELTA;
	}
	precache_sound("ambient/buzz1.wav");
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
	precache_sound("ambient/fire1.wav");
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
	self.frame = WEAPON_SHOTGUN;
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
	self.nextthink = time + random() * AS_DODGING;
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
	fireball.nextthink = time + AS_DODGING;
	fireball.think = SUB_Remove;
	fireball.touch = fire_touch;
	self.nextthink = time + random() * AS_DODGING + SVC_UPDATESTAT;
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
	sound(self, CHAN_VOICE, "weapons/r_exp3.wav", WEAPON_SHOTGUN, ATTN_NORM);
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
	self.origin_z = self.origin_z + WEAPON_ROCKET;
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
	self.origin_z = self.origin_z + WEAPON_ROCKET;
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
			sound(self, CHAN_VOICE, "enforcer/enfire.wav", WEAPON_SHOTGUN, ATTN_NORM);
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
				sound(self, CHAN_VOICE, "misc/spike.wav", WEAPON_SHOTGUN, ATTN_NORM);
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
			lavaball.nextthink = time + AS_DODGING;
			lavaball.think = SUB_Remove;
		}
		else
		{
			if (self.spawnflags & SPAWNFLAG_ROCKET)
			{
				if (!(self.spawnflags & SPAWNFLAG_SILENT))
				{
					sound(self, CHAN_VOICE, "weapons/sgun1.wav", WEAPON_SHOTGUN, ATTN_NORM);
				}
				W_FireRocket();
				newmis.velocity = self.movedir * 1000;
				newmis.angles = vectoangles(newmis.velocity);
				setorigin(newmis, self.origin + self.movedir * DOOR_GOLD_KEY);
			}
			else
			{
				if (!(self.spawnflags & SPAWNFLAG_SILENT))
				{
					sound(self, CHAN_VOICE, "weapons/spike2.wav", WEAPON_SHOTGUN, ATTN_NORM);
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
	if (self.wait == MSG_BROADCAST)
	{
		self.wait = WEAPON_SHOTGUN;
	}
	self.state = WEAPON_SHOTGUN;
	self.nextthink = self.nextthink + self.wait + self.ltime;
	self.think = shooter_think;
};

void() trap_shooter_use = 
{
	self.state = WEAPON_SHOTGUN - self.state;
};

void() trap_switched_shooter = 
{
	trap_spikeshooter();
	if (self.wait == MSG_BROADCAST)
	{
		self.wait = WEAPON_SHOTGUN;
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
	self.nextthink = time + WEAPON_SHOTGUN;
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
	bubble.frame = WEAPON_SHOTGUN;
	bubble.cnt = MIN_ANGLE_DELTA;
	setsize(bubble, '-8 -8 -8', '8 8 8');
	self.frame = WEAPON_SHOTGUN;
	self.cnt = MIN_ANGLE_DELTA;
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
	self.cnt = self.cnt + WEAPON_SHOTGUN;
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
	rnd3 = self.velocity_z + MIN_ANGLE_DELTA + random() * MIN_ANGLE_DELTA;
	if (rnd1 > MIN_ANGLE_DELTA)
	{
		rnd1 = AS_DODGING;
	}
	if (rnd1 < -10)
	{
		rnd1 = CONTENT_LAVA;
	}
	if (rnd2 > MIN_ANGLE_DELTA)
	{
		rnd2 = AS_DODGING;
	}
	if (rnd2 < -10)
	{
		rnd2 = CONTENT_LAVA;
	}
	if (rnd3 < MIN_ANGLE_DELTA)
	{
		rnd3 = CTF_CAPTURE_BONUS;
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
	if ((serverflags & CTF_CAPTURE_BONUS) == CTF_CAPTURE_BONUS)
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
	precache_sound("ambient/suck1.wav");
	ambientsound(self.origin, "ambience/suck1.wav", START_OFF, ATTN_STATIC);
};

void() ambient_drone = 
{
	precache_sound("ambient/drone6.wav");
	ambientsound(self.origin, "ambience/drone6.wav", 0.5, ATTN_STATIC);
};

void() ambient_flouro_buzz = 
{
	precache_sound("ambient/buzz1.wav");
	ambientsound(self.origin, "ambience/buzz1.wav", START_OFF, ATTN_STATIC);
};

void() ambient_drip = 
{
	precache_sound("ambient/drip1.wav");
	ambientsound(self.origin, "ambience/drip1.wav", 0.5, ATTN_STATIC);
};

void() ambient_comp_hum = 
{
	precache_sound("ambient/comp1.wav");
	ambientsound(self.origin, "ambience/comp1.wav", START_OFF, ATTN_STATIC);
};

void() ambient_thunder = 
{
	precache_sound("ambient/thunder1.wav");
	ambientsound(self.origin, "ambience/thunder1.wav", 0.5, ATTN_STATIC);
};

void() ambient_light_buzz = 
{
	precache_sound("ambient/fl_hum1.wav");
	ambientsound(self.origin, "ambience/fl_hum1.wav", 0.5, ATTN_STATIC);
};

void() ambient_swamp1 = 
{
	precache_sound("ambient/swamp1.wav");
	ambientsound(self.origin, "ambience/swamp1.wav", 0.5, ATTN_STATIC);
};

void() ambient_swamp2 = 
{
	precache_sound("ambient/swamp2.wav");
	ambientsound(self.origin, "ambience/swamp2.wav", 0.5, ATTN_STATIC);
};

void() ambient_drips = 
{
	precache_sound("ambience/drips.wav");
	ambientsound(self.origin, "ambience/drips.wav", 0.5, ATTN_STATIC);
};

void() ambient_wind_drips = 
{
	precache_sound("ambience/wind_drips.wav");
	ambientsound(self.origin, "ambience/wind_drips.wav", 0.5, ATTN_STATIC);
};

void() ambient_wind_high = 
{
	precache_sound("ambience/wind_high.wav");
	ambientsound(self.origin, "ambience/wind_high.wav", 0.5, ATTN_STATIC);
};

void() ambient_wndloop1 = 
{
	precache_sound("ambience/wndloop1.wav");
	ambientsound(self.origin, "ambience/wndloop1.wav", 0.5, ATTN_STATIC);
};

void() ambient_wndloop2 = 
{
	precache_sound("ambience/wndloop2.wav");
	ambientsound(self.origin, "ambience/wndloop2.wav", 0.5, ATTN_STATIC);
};

void() ambient_wind2m = 
{
	precache_sound("ambience/wind2m.wav");
	ambientsound(self.origin, "ambience/wind2m.wav", 0.5, ATTN_STATIC);
};

void() ambient_gchime = 
{
	precache_sound("ambience/gchime.wav");
	ambientsound(self.origin, "ambience/gchime.wav", 0.5, ATTN_STATIC);
};

void() ambient_set3_3 = 
{
	precache_sound("ambience/set3_3.wav");
	ambientsound(self.origin, "ambience/set3_3.wav", 0.5, ATTN_STATIC);
};

void() ambient_nehquake = 
{
	precache_sound("ambience/nehquake.wav");
	ambientsound(self.origin, "ambience/nehquake.wav", 0.5, ATTN_STATIC);
};

void() ambient_wind_high2 = 
{
	precache_sound("ambience/wind_high2.wav");
	ambientsound(self.origin, "ambience/wind_high2.wav", 0.5, ATTN_STATIC);
};

void() ambient_wind_med = 
{
	precache_sound("ambience/wind_med.wav");
	ambientsound(self.origin, "ambience/wind_med.wav", 0.5, ATTN_STATIC);
};

void() ambient_wind_med2 = 
{
	precache_sound("ambience/wind_med2.wav");
	ambientsound(self.origin, "ambience/wind_med2.wav", 0.5, ATTN_STATIC);
};

void() ambient_wind_rumb = 
{
	precache_sound("ambience/wind_rumb.wav");
	ambientsound(self.origin, "ambience/wind_rumb.wav", 0.5, ATTN_STATIC);
};

void() ambient_wind_rumb2 = 
{
	precache_sound("ambience/wind_rumb2.wav");
	ambientsound(self.origin, "ambience/wind_rumb2.wav", 0.5, ATTN_STATIC);
};

void() ambient_quake = 
{
	precache_sound("ambience/quake.wav");
	ambientsound(self.origin, "ambience/quake.wav", 0.5, ATTN_STATIC);
};

void() ambient_contact = 
{
	precache_sound("ambience/contact.wav");
	ambientsound(self.origin, "ambience/contact.wav", 0.5, ATTN_STATIC);
};

void() ambient_shall_we_play = 
{
	precache_sound("ambience/shall_we_play.wav");
	ambientsound(self.origin, "ambience/shall_we_play.wav", 0.5, ATTN_STATIC);
};

void() ambient_mspawn1 = 
{
	precache_sound("ambience/mspawn1.wav");
	ambientsound(self.origin, "ambience/mspawn1.wav", 0.5, ATTN_STATIC);
};

void() noise_think = 
{
	self.nextthink = time + 0.5;
	sound(self, START_OFF, "enforcer/enfire.wav", START_OFF, ATTN_NORM);
	sound(self, WEAPON_ROCKET, "enforcer/enfstop.wav", START_OFF, ATTN_NORM);
	sound(self, SVC_UPDATESTAT, "enforcer/sight1.wav", START_OFF, ATTN_NORM);
	sound(self, SECRET_1ST_DOWN, "enforcer/sight2.wav", START_OFF, ATTN_NORM);
	sound(self, AS_DODGING, "enforcer/sight3.wav", START_OFF, ATTN_NORM);
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


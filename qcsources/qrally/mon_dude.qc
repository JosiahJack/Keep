void() dude_move = 
{
	if (!walkmove(self.v_angle_y, 320 * (time - self.last_idle)))
	{
		self.v_angle_y = self.v_angle_y + ((random() > 0.5) * 2 - 1) * 135;
		self.v_angle_y = anglemod(self.v_angle_y);
		self.last_cant_walk = time;
	}
	self.last_idle = time;
};

float(entity dude) DudeSpawnIsClose = 
{
	local entity trav;
	trav = findradius(dude.origin, 64);
	while (trav != world)
	{
		if (trav.classname == "rally_spawn_dude")
		{
			return 1;
		}
		trav = trav.chain;
	}
	return 0;
};

void() dude_run = 
{
	local vector look_angle;
	local vector org;
	local vector vec;
	local float look_heading_change;
	local float ideal_heading;
	local float ideal_dist;
	local float this_dist;
	local float found;
	local float enemy_ideal_yaw;
	local float cant_fire;
	local entity trav;
	self.think = dude_run;
	self.nextthink = time + 0.05;
	dude_move();
	if (self.frame == 0 || self.frame == 3)
	{
		cant_fire = 0;
		if (DudeSpawnIsClose(self))
		{
			droptofloor();
			cant_fire = 1;
		}
		found = 0;
		if (self.ammo_rockets == 0)
		{
			trav = find(world, classname, "weapon_rocketlauncher");
			while (!found && trav != world)
			{
				traceline(self.origin + '0 0 8', trav.origin, 1, world);
				if (trace_fraction == 1)
				{
					vec = normalize(trav.origin - self.origin);
					self.ideal_yaw = vectoyaw(vec);
					found = 1;
				}
				else
				{
					trav = find(trav, classname, "weapon_rocketlauncher");
				}
			}
			if (!found && self.last_guide_touch < time - 20 && self.last_cant_walk < time - 5)
			{
				trav = find(world, classname, "rally_dude_guide");
				while (!found && trav != world)
				{
					traceline(self.origin + '0 0 8', trav.origin, 1, world);
					if (trace_fraction == 1)
					{
						vec = normalize(trav.origin - self.origin);
						self.ideal_yaw = vectoyaw(vec);
						found = 1;
					}
					else
					{
						trav = find(trav, classname, "rally_dude_guide");
					}
					if (trav == world)
					{
						self.last_cant_walk = time;
					}
				}
			}
		}
		if (!found)
		{
			look_angle = self.v_angle;
			look_heading_change = 0;
			ideal_dist = 0;
			ideal_heading = self.v_angle_y;
			org = self.origin + '0 0 16';
			while (look_heading_change < 90)
			{
				look_angle_y = anglemod(self.v_angle_y + look_heading_change);
				makevectors(look_angle);
				traceline(org, org + v_forward * 512, 1, self);
				this_dist = vlen(org - trace_endpos);
				if (this_dist > ideal_dist)
				{
					ideal_dist = this_dist;
					ideal_heading = look_angle_y;
				}
				if (look_heading_change <= 0)
				{
					look_heading_change = -1 * look_heading_change + 30;
				}
				else
				{
					look_heading_change = -1 * look_heading_change;
				}
			}
			self.ideal_yaw = ideal_heading;
		}
		if (!cant_fire)
		{
			if (self.last_rev < time - 0.5)
			{
				trav = findradius(self.origin, 384);
				if (trav.classname == "player")
				{
					dude_fire_grenade();
				}
				while (trav != world && trav.classname != "player")
				{
					trav = trav.chain;
					if (trav.classname == "player")
					{
						dude_fire_grenade();
					}
				}
				if (trav.classname != "player")
				{
					if (random() < 0.05)
					{
						dude_fire_grenade();
					}
				}
			}
			if (self.ammo_rockets > 0)
			{
				if (self.last_rev < time - 1)
				{
					makevectors(self.angles);
					trav = FindSightEnemy(self.origin, v_forward, 900, 90, "player", self);
					if (trav != world)
					{
						dude_fire_rocket(trav);
					}
				}
			}
			if (self.enemy != world)
			{
				if (self.enemy.health <= 0 || vlen(self.origin - self.enemy.origin) > 512 || self.ammo_rockets == 0)
				{
					self.enemy = world;
				}
			}
			else
			{
				if (self.ammo_rockets > 0)
				{
					trav = findradius(self.origin, 900);
					while (trav != world)
					{
						if (trav.classname == "player")
						{
							self.enemy = trav;
							trav = world;
						}
						else
						{
							trav = trav.chain;
						}
					}
				}
			}
		}
	}
	self.v_angle_y = MoveToAngle(self.v_angle_y, self.ideal_yaw, 120);
	if (self.enemy != world)
	{
		vec = normalize(self.enemy.origin + self.enemy.velocity * (vlen(self.enemy.origin - self.origin) / 720) - self.origin);
		enemy_ideal_yaw = vectoyaw(vec);
		self.angles_y = MoveToAngle(self.angles_y, enemy_ideal_yaw, 999);
	}
	else
	{
		self.angles_y = MoveToAngle(self.angles_y, self.ideal_yaw, 120);
	}
	self.frame = self.frame + 1;
	if (self.frame >= 6)
	{
		self.frame = 0;
	}
};

void() dude_axpain1 = [18, dude_axpain2]
{
	PainSound();
	dude_move();
};

void() dude_axpain2 = [19, dude_axpain3]
{
	dude_move();
};

void() dude_axpain3 = [20, dude_axpain4]
{
	dude_move();
};

void() dude_axpain4 = [21, dude_axpain5]
{
	dude_move();
};

void() dude_axpain5 = [22, dude_axpain6]
{
	dude_move();
};

void() dude_axpain6 = [23, dude_run]
{
	dude_move();
};

void() dude_pain = 
{
	if (self.invisible_finished > time)
	{
		return;
	}
	dude_axpain1();
};

void() DudeDead = 
{
	self.nextthink = time + 10;
	self.think = SUB_Remove;
};

void() Awake_Boss = 
{
	local entity boss;
	local entity oself;
	local entity trav;
	boss = find(world, classname, "monster_boss");
	if (boss != world)
	{
		oself = self;
		self = boss;
		boss_awake();
		self = oself;
		if ((trav = find(world, classname, "door")) != world)
		{
			setorigin(trav, trav.origin - '0 0 1024');
		}
	}
};

void() CheckCultKills = 
{
	local string kills_str;
	local entity boss;
	local entity oself;
	local entity trav;
	local float rnd;
	if (cult_kills > NUM_DUKES || !challenge)
	{
		cult_kills = 0;
		rnd = random() * 5;
		if (rnd < 1)
		{
			bprint("Come get some of THIS!\n");
		}
		else
		{
			if (rnd < 2)
			{
				bprint("Time to kick ass and Gib Dukes!\n");
			}
		}
		return;
	}
	if (cult_kills == NUM_DUKES)
	{
		bprint("All Cult members have been TERMINATED!\n");
		Awake_Boss();
		return;
	}
	kills_str = ftos(NUM_DUKES - cult_kills);
	bprint("Cult members remaining: ");
	bprint(kills_str);
	bprint("\n");
	trav = find(world, classname, "player");
	while (trav != world)
	{
		trav.frags = cult_kills;
		trav = find(trav, classname, "player");
	}
};

void() replenish_dudes = 
{
	local float done;
	unspawned_dudes = unspawned_dudes + 1;
	done = 0;
	while (unspawned_dudes > 0 && !done)
	{
		if (spawn_dude())
		{
			unspawned_dudes = unspawned_dudes - 1;
		}
		else
		{
			done = 1;
		}
	}
};

void() DudeDie = 
{
	local float i;
	self.items = self.items - (self.items & IT_INVISIBILITY);
	self.invisible_finished = 0;
	self.invincible_finished = 0;
	self.super_damage_finished = 0;
	self.radsuit_finished = 0;
	if (deathmatch || coop && rally_type_index > 1)
	{
		DropBackpack();
	}
	self.last_engine1 = 0;
	self.last_engine2 = 0;
	self.view_ofs = '0 0 -8';
	self.deadflag = DEAD_DYING;
	self.solid = SOLID_NOT;
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	self.movetype = MOVETYPE_TOSS;
	if (self.velocity_z < 10)
	{
		self.velocity_z = self.velocity_z + random() * 300;
	}
	if (rally_type_index == 4)
	{
		cult_kills = cult_kills + 1;
		CheckCultKills();
	}
	if (self.health < -40)
	{
		GibPlayer();
		replenish_dudes();
		return;
	}
	DeathSound();
	self.angles_x = 0;
	self.angles_z = 0;
	i = cvar("temp1");
	if (!i)
	{
		i = 1 + floor(random() * 7);
	}
	if (i == 1)
	{
		dude_diea1();
	}
	else
	{
		if (i == 2)
		{
			dude_dieb1();
		}
		else
		{
			if (i == 3)
			{
				dude_diec1();
			}
			else
			{
				if (i == 4)
				{
					dude_died1();
				}
				else
				{
					if (i == 5)
					{
						dude_diee1();
					}
					else
					{
						dude_die_ax1();
					}
				}
			}
		}
	}
	replenish_dudes();
};

void() dude_diea1 = [33, dude_diea2]
{
};

void() dude_diea2 = [34, dude_diea3]
{
};

void() dude_diea3 = [35, dude_diea4]
{
};

void() dude_diea4 = [36, dude_diea5]
{
};

void() dude_diea5 = [37, dude_diea6]
{
};

void() dude_diea6 = [38, dude_diea7]
{
};

void() dude_diea7 = [39, dude_diea8]
{
};

void() dude_diea8 = [40, dude_diea9]
{
};

void() dude_diea9 = [41, dude_diea10]
{
};

void() dude_diea10 = [42, dude_diea11]
{
};

void() dude_diea11 = [43, dude_diea11]
{
	DudeDead();
};

void() dude_dieb1 = [44, dude_dieb2]
{
};

void() dude_dieb2 = [45, dude_dieb3]
{
};

void() dude_dieb3 = [46, dude_dieb4]
{
};

void() dude_dieb4 = [47, dude_dieb5]
{
};

void() dude_dieb5 = [48, dude_dieb6]
{
};

void() dude_dieb6 = [49, dude_dieb7]
{
};

void() dude_dieb7 = [50, dude_dieb8]
{
};

void() dude_dieb8 = [51, dude_dieb9]
{
};

void() dude_dieb9 = [52, dude_dieb9]
{
	DudeDead();
};

void() dude_diec1 = [53, dude_diec2]
{
};

void() dude_diec2 = [54, dude_diec3]
{
};

void() dude_diec3 = [55, dude_diec4]
{
};

void() dude_diec4 = [56, dude_diec5]
{
};

void() dude_diec5 = [57, dude_diec6]
{
};

void() dude_diec6 = [58, dude_diec7]
{
};

void() dude_diec7 = [59, dude_diec8]
{
};

void() dude_diec8 = [60, dude_diec9]
{
};

void() dude_diec9 = [61, dude_diec10]
{
};

void() dude_diec10 = [62, dude_diec11]
{
};

void() dude_diec11 = [63, dude_diec12]
{
};

void() dude_diec12 = [64, dude_diec13]
{
};

void() dude_diec13 = [65, dude_diec14]
{
};

void() dude_diec14 = [66, dude_diec15]
{
};

void() dude_diec15 = [67, dude_diec15]
{
	DudeDead();
};

void() dude_died1 = [68, dude_died2]
{
};

void() dude_died2 = [69, dude_died3]
{
};

void() dude_died3 = [70, dude_died4]
{
};

void() dude_died4 = [71, dude_died5]
{
};

void() dude_died5 = [72, dude_died6]
{
};

void() dude_died6 = [73, dude_died7]
{
};

void() dude_died7 = [74, dude_died8]
{
};

void() dude_died8 = [75, dude_died9]
{
};

void() dude_died9 = [76, dude_died9]
{
	DudeDead();
};

void() dude_diee1 = [77, dude_diee2]
{
};

void() dude_diee2 = [78, dude_diee3]
{
};

void() dude_diee3 = [79, dude_diee4]
{
};

void() dude_diee4 = [80, dude_diee5]
{
};

void() dude_diee5 = [81, dude_diee6]
{
};

void() dude_diee6 = [82, dude_diee7]
{
};

void() dude_diee7 = [83, dude_diee8]
{
};

void() dude_diee8 = [84, dude_diee9]
{
};

void() dude_diee9 = [85, dude_diee9]
{
	DudeDead();
};

void() dude_die_ax1 = [24, dude_die_ax2]
{
};

void() dude_die_ax2 = [25, dude_die_ax3]
{
};

void() dude_die_ax3 = [26, dude_die_ax4]
{
};

void() dude_die_ax4 = [27, dude_die_ax5]
{
};

void() dude_die_ax5 = [28, dude_die_ax6]
{
};

void() dude_die_ax6 = [29, dude_die_ax7]
{
};

void() dude_die_ax7 = [30, dude_die_ax8]
{
};

void() dude_die_ax8 = [31, dude_die_ax9]
{
};

void() dude_die_ax9 = [32, dude_die_ax9]
{
	DudeDead();
};

float() spawn_dude = 
{
	local float clear;
	local entity trav;
	local entity first_spot;
	clear = 0;
	first_spot = last_dude_spawn;
	while (!clear)
	{
		last_dude_spawn = find(last_dude_spawn, classname, "rally_spawn_dude");
		if (last_dude_spawn == world)
		{
			last_dude_spawn = find(last_dude_spawn, classname, "rally_spawn_dude");
		}
		clear = 1;
		trav = findradius(last_dude_spawn.origin, 64);
		while (trav != world && clear)
		{
			if (!(trav.solid == SOLID_NOT || trav.solid == SOLID_TRIGGER))
			{
				clear = 0;
			}
			trav = trav.chain;
		}
		if (!clear && last_dude_spawn == first_spot)
		{
			return 0;
		}
	}
	self = last_dude_spawn;
	rally_spawn_dude();
	return 1;
};

void(string gibname, vector impact) ThrowDudeGib = 
{
	local entity new;
	new = spawn();
	new.origin = self.origin;
	setmodel(new, gibname);
	setsize(new, '0 0 0', '0 0 0');
	new.velocity = impact * 1.5 + random() * '500 0 0' + random() * '0 500 0' + '-250 -250 220';
	new.movetype = MOVETYPE_BOUNCE;
	new.solid = SOLID_NOT;
	new.avelocity_x = random() * 600;
	new.avelocity_y = random() * 600;
	new.avelocity_z = random() * 600;
	new.think = SUB_Remove;
	new.ltime = time;
	new.nextthink = time + 10 + random() * 10;
	new.frame = 0;
	new.flags = 0;
};

void(vector impact_vec) GibDude = 
{
	ThrowDudeGib("progs/gib1.mdl", impact_vec);
	ThrowDudeGib("progs/gib2.mdl", impact_vec);
	ThrowDudeGib("progs/gib3.mdl", impact_vec);
	self.deadflag = DEAD_DEAD;
	if (damage_attacker.classname == "teledeath")
	{
		sound(self, CHAN_VOICE, "player/teledth1.wav", 1, ATTN_NONE);
		return;
	}
	if (damage_attacker.classname == "teledeath2")
	{
		sound(self, CHAN_VOICE, "player/teledth1.wav", 1, ATTN_NONE);
		return;
	}
	if (random() < 0.5)
	{
		sound(self, CHAN_VOICE, "player/gib.wav", 1, ATTN_NONE);
	}
	else
	{
		sound(self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NONE);
	}
	ThrowHead("progs/h_player.mdl", self.health);
};

void() dude_touch = 
{
	local float veh_speed;
	local float impact;
	if (other.classname != "player")
	{
		return;
	}
	makevectors(self.angles);
	impact = vlen(other.velocity - v_forward * 320);
	if (other.weapon == IT_ROOBAR && other.ammo_roobar > 0)
	{
		impact = impact * 4;
		other.currentammo = other.ammo_roobar = other.ammo_roobar - 4;
		sound(self, CHAN_AUTO, "rally/process/elect02.wav", 1, ATTN_NORM);
		other.veh_body.effects = other.veh_body.effects | EF_DIMLIGHT;
		other.last_crash = time;
	}
	if (impact < MAX_SPEED / 2)
	{
		if (random() < 0.5)
		{
			sound(self, CHAN_AUTO, "rally/dude/sevpain1.wav", 1, ATTN_NORM);
		}
		else
		{
			sound(self, CHAN_AUTO, "rally/dude/sevpain2.wav", 1, ATTN_NORM);
		}
		T_Damage(self, other, other, impact / 40);
	}
	else
	{
		if (random() < 0.5)
		{
			sound(self, CHAN_AUTO, "rally/dude/sevpain1.wav", 1, ATTN_NORM);
		}
		else
		{
			sound(self, CHAN_AUTO, "rally/dude/sevpain2.wav", 1, ATTN_NORM);
		}
		self.health = -0.2 * impact;
		GibDude(other.velocity);
		if (rally_type_index == 4)
		{
			cult_kills = cult_kills + 1;
			killed_monsters = killed_monsters + 1;
			WriteByte(MSG_ALL, SVC_KILLEDMONSTER);
			CheckCultKills();
		}
		spawn_dude();
	}
};

void() dude_fire_grenade = 
{
	local entity missile;
	local entity mpuff;
	sound(self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM);
	missile = spawn();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
	missile.classname = "grenade";
	missile.velocity = '0 0 200';
	missile.avelocity = '0 300 0';
	missile.touch = GrenadeTouch;
	missile.last_idle = time + 5;
	missile.oldorigin = missile.origin;
	missile.nextthink = time + 1;
	missile.think = GrenadeThink;
	setmodel(missile, "models/detnator.mdl");
	setsize(missile, '-4 -4 0', '4 4 12');
	setorigin(missile, self.origin);
	self.last_rev = time;
};

void(entity targ) dude_fire_rocket = 
{
	local entity missile;
	local entity mpuff;
	local entity missile_enemy;
	local vector dir;
	local vector old_forward;
	sound(self, CHAN_WEAPON, "weapons/sgun1.wav", 1, ATTN_NORM);
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
	missile_enemy = targ;
	if (targ != world)
	{
		sprint(missile_enemy, "Missile lock!\n");
		commentary(missile_enemy, "process/buzztst1.wav");
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
	missile.velocity = missile.velocity * 500;
	missile.angles = vectoangles(missile.velocity);
	missile.touch = T_MissileTouch;
	setmodel(missile, "models/missile.mdl");
	setsize(missile, '0 0 0', '0 0 0');
	setorigin(missile, self.origin + v_forward * 8);
	self.last_rev = time;
};

void() rally_spawn_dude = 
{
	local entity dude;
	if (challenge && rally_type_index == 4 && dukes_spawned >= NUM_DUKES)
	{
		return;
	}
	dukes_spawned = dukes_spawned + 1;
	dude = spawn();
	dude.angles = self.angles;
	dude.v_angle = dude.angles;
	setorigin(dude, self.origin);
	dude.flags = dude.flags | FL_MONSTER;
	self = dude;
	self.classname = "rally_dude";
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	self.takedamage = DAMAGE_AIM;
	setmodel(self, "models/dude.mdl");
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
	self.health = 200;
	if (!droptofloor())
	{
		dprint("dude fell out of level at: ");
		dprint(vtos(self.origin));
		dprint("\n");
	}
	self.ideal_yaw = self.angles_y;
	self.touch = dude_touch;
	self.th_stand = dude_run;
	self.th_walk = dude_run;
	self.th_run = dude_run;
	self.th_die = DudeDie;
	self.th_pain = dude_axpain1;
	self.last_rev = 0;
	self.last_guide_touch = -100;
	walkmonster_start();
};

void() dude_guide_touch = 
{
	if (other.classname == "rally_dude")
	{
		other.angles = self.angles;
		other.last_guide_touch = time;
	}
	self.solid = SOLID_TRIGGER;
	setorigin(self, self.origin);
};

void() rally_dude_guide = 
{
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
	self.solid = SOLID_TRIGGER;
	self.movetype = MOVETYPE_NONE;
	self.touch = dude_guide_touch;
};


void(entity o) spawn_dummy = 
{
	local entity s;
	s = spawn();
	s.origin = o.origin;
	s.velocity = o.velocity;
	s.angles = o.angles;
	s.health = o.health;
	s.weapon = o.weapon;
	s.classname = "dummy";
	s.movetype = MOVETYPE_NONE;
	s.solid = SOLID_NOT;
	s.weaponmodel = o.weaponmodel;
	s.flags = o.flags;
	setorigin(s, o.origin);
};

void() name_player = 
{
	local entity play;
	play = find(world, classname, "camera");
	play.classname = "player";
	stuffcmd(play, "-forward\n");
};

void() go_back = 
{
	local entity t;
	local entity c;
	local entity d;
	local vector org;
	local string val;
	t = find(world, classname, "dummy");
	if (!t)
	{
		objerror("couldn't find dummy");
	}
	c = find(world, classname, "camera");
	if (!c)
	{
		objerror("couldn't find camera");
	}
	setorigin(c, t.origin);
	c.velocity = t.velocity;
	c.view_ofs = '0 0 22';
	c.angles_x = t.angles_x;
	c.angles_y = t.angles_y;
	c.angles_z = 0;
	c.health = t.health;
	c.weapon = t.weapon;
	c.weaponmodel = t.weaponmodel;
	c.flags = t.flags;
	c.fixangle = 1;
	c.takedamage = DAMAGE_AIM;
	c.solid = SOLID_SLIDEBOX;
	c.movetype = MOVETYPE_WALK;
	c.think = SUB_Null;
	c.air_finished = time + TE_EXPLOSION2;
	d = spawn();
	d.nextthink = time + 0.1;
	d.think = name_player;
	val = ftos(c.cnt);
	cvar_set("viewsize", val);
	cvar_set("v_idlescale", "0");
	t.nextthink = time + 0.1;
	t.think = SUB_Remove;
	remove(self);
};

void() look_ahead = 
{
	self.angles = self.enemy.mangle;
	self.fixangle = 1;
	self.nextthink = time + 0.010000;
};

void() go_camera = 
{
	self.classname = "camera";
	self.velocity = VEC_ORIGIN;
	self.view_ofs = VEC_ORIGIN;
	self.angles = self.enemy.mangle;
	self.fixangle = 1;
	self.movetype = MOVETYPE_NONE;
	self.takedamage = DAMAGE_NO;
	self.solid = SOLID_NOT;
	self.weaponmodel = "";
	self.nextthink = time + 0.05;
	self.think = look_ahead;
	if (!(self.script))
	{
		dprint("trigger_camera needs a script number");
	}
	self.script_count = 0;
	self.cnt = cvar("viewsize");
	cvar_set("viewsize", "120");
	cvar_set("v_idlescale", "1");
	setorigin(self, self.enemy.origin);
};

void() camera_touch = 
{
	local entity t;
	if (self.targetname)
	{
		if (self.nextthink < time)
		{
			return;
		}
	}
	if (other.health <= 0 || other.classname != "player" || self.cnt == CONTENT_EMPTY)
	{
		return;
	}
	SUB_UseTargets();
	if (other.flags & FL_ONGROUND)
	{
		other.flags = other.flags - FL_ONGROUND;
	}
	spawn_dummy(other);
	t = find(world, targetname, self.target);
	if (!t)
	{
		objerror("couldn't find target");
	}
	other.enemy = t;
	other.script = self.script;
	other.script_delay = self.script_delay;
	other.nextthink = time + 0.05;
	other.think = go_camera;
	self.cnt = CONTENT_EMPTY;
	self.nextthink = time + 0.1;
	self.think = SUB_Remove;
};

void() info_movie_camera = 
{
};

void() camera_use = 
{
	self.nextthink = time + 100000;
	force_retouch = FL_SWIM;
	self.think = SUB_Null;
};

void() trigger_camera = 
{
	if (deathmatch || coop)
	{
		remove(self);
	}
	InitTrigger();
	self.touch = camera_touch;
	if (!(self.target))
	{
		objerror("no target");
	}
	self.use = camera_use;
};

void() Script_play = 
{
	local entity scrpt;
	scrpt = find(world, script_num, self.script);
	if (!scrpt)
	{
		dprint("Error: script not found!");
	}
	self.script_delay = scrpt.script_delay;
	self.script_time = time + 1;
	self.script_count = self.script_count + 1;
	centerprint(self, scrpt.message);
	if (self.script_count == self.script_delay)
	{
		self.script = scrpt.next_script;
		if (self.script != "0")
		{
			self.script_count = 0;
		}
		else
		{
			scrpt.nextthink = time + MOVETYPE_STEP;
			scrpt.think = go_back;
		}
	}
	return;
};

void() info_script = 
{
};

void() meat_pain = 
{
	self.health = 1000000;
};

void() misc_meat = 
{
	local entity meat1;
	local entity meat2;
	local entity meat3;
	local entity meathead;
	local vector org;
	meat1 = spawn();
	meat1.owner = self;
	meat1.movetype = MOVETYPE_BOUNCE;
	meat1.solid = SOLID_BBOX;
	meat1.takedamage = DAMAGE_AIM;
	meat1.touch = SUB_Null;
	meat1.velocity_z = 50 * random();
	meat1.avelocity = '100 300 200';
	org = self.origin + '20 5 5';
	meat1.classname = "gib";
	meat1.think = SUB_Null;
	meat1.health = 100000;
	meat1.th_pain = meat_pain;
	meat1.th_die = meat_pain;
	setmodel(meat1, "progs/gib3.mdl");
	setsize(meat1, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(meat1, org);
	meat2 = spawn();
	meat2.owner = self;
	meat2.movetype = MOVETYPE_BOUNCE;
	meat2.solid = SOLID_BBOX;
	meat2.takedamage = DAMAGE_AIM;
	meat2.touch = SUB_Null;
	meat2.velocity_z = 50 * random();
	meat2.avelocity = '200 100 300';
	org = self.origin + '10 20 5';
	meat2.classname = "gib";
	meat2.health = 100000;
	meat2.th_pain = meat_pain;
	meat2.th_die = meat_pain;
	meat2.think = SUB_Null;
	setmodel(meat2, "progs/gib2.mdl");
	setsize(meat2, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(meat2, org);
	meat3 = spawn();
	meat3.owner = self;
	meat3.movetype = MOVETYPE_BOUNCE;
	meat3.solid = SOLID_BBOX;
	meat3.takedamage = DAMAGE_AIM;
	meat3.touch = SUB_Null;
	meat3.velocity_z = 50 * random();
	meat3.avelocity = '500 10 200';
	org = self.origin + '-10 -20 5';
	meat3.classname = "gib";
	meat3.health = 100000;
	meat3.th_pain = meat_pain;
	meat3.th_die = meat_pain;
	meat3.think = SUB_Null;
	setmodel(meat3, "progs/gib2.mdl");
	setsize(meat3, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(meat3, org);
	meathead = spawn();
	meathead.owner = self;
	meathead.movetype = MOVETYPE_BOUNCE;
	meathead.solid = SOLID_BBOX;
	meathead.takedamage = DAMAGE_AIM;
	meathead.touch = SUB_Null;
	meathead.velocity_z = 50 * random();
	meathead.avelocity = '150 350 225';
	org = self.origin + '2 2 5';
	meathead.classname = "meat";
	meathead.health = 100000;
	meathead.th_pain = meat_pain;
	meathead.th_die = meat_pain;
	meathead.think = SUB_Null;
	setmodel(meathead, "progs/h_player.mdl");
	setsize(meathead, '-16 -16 0', '16 16 26');
	setorigin(meathead, org);
};

void() hostage_pain = 
{
	local float r;
	r = random();
	if (r < 0.1)
	{
		bprint("This Shambler;s claws are sharp!\n");
	}
	if (r > 0.9)
	{
		bprint("Hostage: Help me! Please!\n");
	}
	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
	ChangeYaw();
	ai_back(MOVETYPE_FLY);
	player_pain1();
};

void() HostageDie = 
{
	local entity sham;
	local entity olde;
	sham = find(world, classname, "monster_shambler");
	olde = find(world, netname, "hostage");
	if (olde.health < 0)
	{
		olde = find(world, netname, "hostage");
		if (olde.health < 0)
		{
			olde = find(world, classname, "camera");
			sham.oldenemy = olde;
		}
	}
	else
	{
		sham.oldenemy = olde;
	}
	self.health = -80;
	PlayerDie();
};

void() misc_hostage = 
{
	local entity body;
	makevectors(self.angles);
	body = spawn();
	setmodel(body, "progs/player.mdl");
	setsize(body, VEC_HULL_MIN, VEC_HULL_MAX);
	body.origin = self.origin + '0 0 1';
	setorigin(body, body.origin);
	body.classname = "player";
	body.netname = "hostage";
	body.health = MIN_CHARMER_DISTANCE;
	body.takedamage = DAMAGE_AIM;
	body.solid = SOLID_SLIDEBOX;
	body.movetype = MOVETYPE_STEP;
	body.show_hostile = 0;
	body.weapon = IT_SHOTGUN;
	body.weaponframe = 0;
	body.walkframe = 0;
	body.frame = TE_EXPLOSION2;
	body.th_pain = hostage_pain;
	body.th_die = HostageDie;
	body.th_stand = player_stand1;
	self = body;
	self.enemy = find(world, classname, "monster_shambler");
	self.yaw_speed = SVC_INTERMISSION;
	droptofloor();
	player_stand1();
};

void() warning_stop = 
{
	self.cnt = CONTENT_EMPTY;
	self.think = SUB_Remove;
};

void(entity play) warn_player = 
{
	if (play.view_ofs == VEC_ORIGIN)
	{
		return;
	}
	stuffcmd(play, "bf\n");
	sound(play, CHAN_AUTO, "items/inv2.wav", 1, ATTN_NORM);
	centerprint(play, "Reactor Overload!\nEvacuate Immediately\n");
	T_Damage(play, world, world, self.cnt);
};

void() warning_start = 
{
	local entity you;
	you = find(world, classname, "player");
	if (!you)
	{
		return;
	}
	if (you.view_ofs == VEC_ORIGIN)
	{
		return;
	}
	if (self.cnt > 0)
	{
		warn_player(you);
		self.cnt = self.cnt + 1;
		self.nextthink = time + MOVETYPE_STEP;
		self.think = warning_start;
	}
	else
	{
		remove(self);
	}
};

void() warning_touch = 
{
	if (other.health <= 0 || other.classname != "player")
	{
		return;
	}
	self.solid = SOLID_NOT;
	self.nextthink = time + FL_SWIM;
	self.think = warning_start;
};

void() overload_warning = 
{
	precache_sound("items/inv2.wav");
	self.cnt = 1;
	self.use = warning_stop;
	self.touch = warning_touch;
	self.model = string_null;
	setsize(self, VEC_ORIGIN, '32 32 56');
	StartItem();
};

void() big_bang = 
{
	local vector newo;
	local float x;
	local float y;
	local float z;
	if (self.wait == 1)
	{
		sound(self, CHAN_VOICE, "boss2/pop2.wav", 1, ATTN_NONE);
	}
	x = random() * FL_NOTARGET - FL_GODMODE;
	y = random() * FL_NOTARGET - FL_GODMODE;
	z = random() * FL_NOTARGET - FL_GODMODE;
	newo_x = self.origin_x + x;
	newo_y = self.origin_y + y;
	newo_z = self.origin_z + z;
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord(MSG_BROADCAST, newo_x);
	WriteCoord(MSG_BROADCAST, newo_y);
	WriteCoord(MSG_BROADCAST, newo_z);
	self.wait = self.wait - 1;
	if (self.wait < 0)
	{
		remove(self);
	}
	self.nextthink = time + 0.2 * random() + 0.1;
	self.think = big_bang;
};

void() misc_kaboom = 
{
	precache_sound2("boss2/pop2.wav");
	self.use = big_bang;
};

void() lava_splash = 
{
};

void() fade_away = 
{
	if (self.cnt == TE_EXPLOSION2)
	{
		lightstyle(0, "l");
	}
	else
	{
		if (self.cnt == MOVETYPE_BOUNCEMISSILE)
		{
			lightstyle(0, "k");
		}
		else
		{
			if (self.cnt == MOVETYPE_BOUNCE)
			{
				lightstyle(0, "j");
			}
			else
			{
				if (self.cnt == MOVETYPE_FLYMISSILE)
				{
					lightstyle(0, "i");
				}
				else
				{
					if (self.cnt == FL_CLIENT)
					{
						lightstyle(0, "h");
					}
					else
					{
						if (self.cnt == MOVETYPE_PUSH)
						{
							lightstyle(0, "g");
						}
						else
						{
							if (self.cnt == MOVETYPE_TOSS)
							{
								lightstyle(0, "f");
							}
							else
							{
								if (self.cnt == MOVETYPE_FLY)
								{
									lightstyle(0, "e");
								}
								else
								{
									if (self.cnt == MOVETYPE_STEP)
									{
										lightstyle(0, "d");
									}
									else
									{
										if (self.cnt == MOVETYPE_WALK)
										{
											lightstyle(0, "c");
										}
										else
										{
											if (self.cnt == FL_SWIM)
											{
												lightstyle(0, "b");
											}
											else
											{
												if (self.cnt == 1)
												{
													lightstyle(0, "a");
													return;
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
	self.cnt = self.cnt - 1;
	self.think = fade_away;
	self.nextthink = time + 0.5;
};

void() finale_touch = 
{
	local entity ls;
	local entity dim;
	if (other.health <= 0 || other.classname != "player" || self.cnt == CONTENT_EMPTY)
	{
		return;
	}
	ls = find(world, classname, "lava_splash");
	while (ls)
	{
		WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte(MSG_BROADCAST, TE_LAVASPLASH);
		WriteCoord(MSG_BROADCAST, ls.origin_x);
		WriteCoord(MSG_BROADCAST, ls.origin_y);
		WriteCoord(MSG_BROADCAST, ls.origin_z);
		remove(ls);
		ls = find(world, classname, "lava_splash");
	}
	sound(self, CHAN_VOICE, "boss1/out1.wav", 1, ATTN_NONE);
	dim = spawn();
	dim.cnt = TE_EXPLOSION2;
	dim.nextthink = time + 13;
	dim.think = fade_away;
	self.think = SUB_UseTargets;
	self.nextthink = time + MOVETYPE_STEP;
	self.cnt = CONTENT_EMPTY;
};

void() trigger_finale = 
{
	if (deathmatch || coop)
	{
		remove(self);
	}
	precache_sound("boss1/out1.wav");
	InitTrigger();
	self.touch = finale_touch;
	if (!(self.target))
	{
		objerror("no target");
	}
};


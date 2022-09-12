void() info_intermission = 
{
};

void() SetChangeParms = 
{
	self.items = self.items - (self.items & (IT_KEY1 | IT_KEY2 | IT_INVISIBILITY | IT_INVULNERABILITY | IT_SUIT | IT_QUAD));
	if (self.health > 100)
	{
		self.health = 100;
	}
	if (self.health < 50)
	{
		self.health = 50;
	}
	parm1 = self.items;
	parm2 = self.health;
	parm3 = self.armorvalue;
	if (self.ammo_shells < 25)
	{
		parm4 = 25;
	}
	else
	{
		parm4 = self.ammo_shells;
	}
	parm5 = self.ammo_nails;
	parm6 = self.ammo_rockets;
	parm7 = self.ammo_cells;
	parm8 = self.weapon;
	parm9 = self.armortype * 100;
	if (self.admin == 3)
	{
		parm10 = 2;
	}
	else
	{
		if (self.flags & FL_OBSERVER)
		{
			parm10 = 1;
		}
		else
		{
			parm10 = 0;
		}
	}
	parm11 = -1;
	parm12 = self.weapons;
	parm13 = self.weapon2;
	parm14 = servervars;
};

void() SetNewParms = 
{
	parm1 = IT_SHOTGUN | IT_AXE | IT_EXTRA_WEAPON;
	parm2 = 100;
	parm3 = 0;
	parm4 = 25;
	parm5 = 0;
	parm6 = 0;
	parm6 = 0;
	parm7 = 0;
	parm8 = 1;
	parm9 = 0;
	parm10 = 0;
	parm12 = WE_AIRFIST | WE_GRAPPLE;
	parm13 = 0;
};

void() DecodeLevelParms = 
{
	self.player_flag = self.player_flag | parm16;
	self.player_flag = self.player_flag - (self.player_flag & ITEM_RUNE_MASK);
	self.items = parm1;
	self.health = parm2;
	self.armorvalue = parm3;
	self.ammo_shells = parm4;
	self.ammo_nails = parm5;
	self.ammo_rockets = parm6;
	self.ammo_cells = parm7;
	self.weapon = parm8;
	self.armortype = parm9 * 0.010000;
	self.items = parm1;
	self.admin = parm10;
	if (self.motd == 0)
	{
		self.motd_shown = 0;
	}
	else
	{
		self.motd_shown = -1;
	}
	if (self.motd_shown == -1)
	{
		self.newbie = 0;
	}
	if (parm10 == 2)
	{
		MakeObserver();
		self.admin = 3;
	}
	else
	{
		if (parm10 == 1)
		{
			MakeObserver();
			self.admin = 0;
		}
	}
	self.weapons = parm12;
	self.weapon2 = parm13;
	if (servervars == 0)
	{
		servervars = parm14;
	}
	self.velocity = '0 0 0';
};

entity() FindIntermission = 
{
	local entity spot;
	local float cyc;
	spot = find(world, classname, "info_intermission");
	if (spot)
	{
		cyc = random() * 4;
		while (cyc > 1)
		{
			spot = find(spot, classname, "info_intermission");
			if (!spot)
			{
				spot = find(spot, classname, "info_intermission");
			}
			cyc = cyc - 1;
		}
		return spot;
	}
	spot = find(world, classname, "info_player_start");
	if (spot)
	{
		return spot;
	}
	spot = find(world, classname, "testplayerstart");
	if (spot)
	{
		return spot;
	}
	objerror("FindIntermission: no spot");
};

void() GotoNextMap = 
{
	if (cvar("samelevel"))
	{
		changelevel(mapname);
	}
	else
	{
		changelevel(nextmap);
	}
};

void() ExitIntermission = 
{
	if (deathmatch)
	{
		GotoNextMap();
		return;
	}
	intermission_exittime = time + 1;
	intermission_running = intermission_running + 1;
	if (intermission_running == 2)
	{
		if (world.model == "maps/e1m7.bsp")
		{
			WriteByte(MSG_ALL, SVC_CDTRACK);
			WriteByte(MSG_ALL, 2);
			WriteByte(MSG_ALL, 3);
			if (!cvar("registered"))
			{
				WriteByte(MSG_ALL, SVC_FINALE);
				WriteString(MSG_ALL, "As the corpse of the monstrous entity\nChthon sinks back into the lava whence\nit rose, you grip the Rune of Earth\nMagic tightly. Now that you have\nconquered the Dimension of the Doomed,\nrealm of Earth Magic, you are ready to\ncomplete your task in the other three\nhaunted lands of Quake. Or are you? If\nyou don't register Quake, you'll never\nknow what awaits you in the Realm of\nBlack Magic, the Netherworld, and the\nElder World!");
			}
			else
			{
				WriteByte(MSG_ALL, SVC_FINALE);
				WriteString(MSG_ALL, "As the corpse of the monstrous entity\nChthon sinks back into the lava whence\nit rose, you grip the Rune of Earth\nMagic tightly. Now that you have\nconquered the Dimension of the Doomed,\nrealm of Earth Magic, you are ready to\ncomplete your task. A Rune of magic\npower lies at the end of each haunted\nland of Quake. Go forth, seek the\ntotality of the four Runes!");
			}
			return;
		}
		else
		{
			if (world.model == "maps/e2m6.bsp")
			{
				WriteByte(MSG_ALL, SVC_CDTRACK);
				WriteByte(MSG_ALL, 2);
				WriteByte(MSG_ALL, 3);
				WriteByte(MSG_ALL, SVC_FINALE);
				WriteString(MSG_ALL, "The Rune of Black Magic throbs evilly in\nyour hand and whispers dark thoughts\ninto your brain. You learn the inmost\nlore of the Hell-Mother; Shub-Niggurath!\nYou now know that she is behind all the\nterrible plotting which has led to so\nmuch death and horror. But she is not\ninviolate! Armed with this Rune, you\nrealize that once all four Runes are\ncombined, the gate to Shub-Niggurath's\nPit will open, and you can face the\nWitch-Goddess herself in her frightful\notherworld cathedral.");
				return;
			}
			else
			{
				if (world.model == "maps/e3m6.bsp")
				{
					WriteByte(MSG_ALL, SVC_CDTRACK);
					WriteByte(MSG_ALL, 2);
					WriteByte(MSG_ALL, 3);
					WriteByte(MSG_ALL, SVC_FINALE);
					WriteString(MSG_ALL, "The charred viscera of diabolic horrors\nbubble viscously as you seize the Rune\nof Hell Magic. Its heat scorches your\nhand, and its terrible secrets blight\nyour mind. Gathering the shreds of your\ncourage, you shake the devil's shackles\nfrom your soul, and become ever more\nhard and determined to destroy the\nhideous creatures whose mere existence\nthreatens the souls and psyches of all\nthe population of Earth.");
					return;
				}
				else
				{
					if (world.model == "maps/e4m7.bsp")
					{
						WriteByte(MSG_ALL, SVC_CDTRACK);
						WriteByte(MSG_ALL, 2);
						WriteByte(MSG_ALL, 3);
						WriteByte(MSG_ALL, SVC_FINALE);
						WriteString(MSG_ALL, "Despite the awful might of the Elder\nWorld, you have achieved the Rune of\nElder Magic, capstone of all types of\narcane wisdom. Beyond good and evil,\nbeyond life and death, the Rune\npulsates, heavy with import. Patient and\npotent, the Elder Being Shub-Niggurath\nweaves her dire plans to clear off all\nlife from the Earth, and bring her own\nfoul offspring to our world! For all the\ndwellers in these nightmare dimensions\nare her descendants! Once all Runes of\nmagic power are united, the energy\nbehind them will blast open the Gateway\nto Shub-Niggurath, and you can travel\nthere to foil the Hell-Mother's plots\nin person.");
						return;
					}
				}
			}
		}
		GotoNextMap();
	}
	if (intermission_running == 3)
	{
		if (!cvar("registered"))
		{
			WriteByte(MSG_ALL, SVC_SELLSCREEN);
			return;
		}
		if ((serverflags & 15) == 15)
		{
			WriteByte(MSG_ALL, SVC_FINALE);
			WriteString(MSG_ALL, "Now, you have all four Runes. You sense\ntremendous invisible forces moving to\nunseal ancient barriers. Shub-Niggurath\nhad hoped to use the Runes Herself to\nclear off the Earth, but now instead,\nyou will use them to enter her home and\nconfront her as an avatar of avenging\nEarth-life. If you defeat her, you will\nbe remembered forever as the savior of\nthe planet. If she conquers, it will be\nas if you had never been born.");
			return;
		}
	}
	GotoNextMap();
};

void() IntermissionThink = 
{
	if (time < intermission_exittime)
	{
		return;
	}
	if (!(self.button0) && !(self.button1) && !(self.button2))
	{
		return;
	}
	ExitIntermission();
};

void() execute_changelevel = 
{
	local entity pos;
	intermission_running = 1;
	if (deathmatch)
	{
		intermission_exittime = time + 5;
	}
	else
	{
		intermission_exittime = time + 2;
	}
	WriteByte(MSG_ALL, SVC_CDTRACK);
	WriteByte(MSG_ALL, 3);
	WriteByte(MSG_ALL, 3);
	pos = FindIntermission();
	other = find(world, classname, "player");
	while (other != world)
	{
		other.view_ofs = '0 0 0';
		other.angles = other.v_angle = pos.mangle;
		other.fixangle = 1;
		other.nextthink = time + 0.5;
		other.takedamage = DAMAGE_NO;
		other.solid = SOLID_NOT;
		other.movetype = MOVETYPE_NONE;
		other.modelindex = 0;
		setorigin(other, pos.origin);
		other = find(other, classname, "player");
	}
	WriteByte(MSG_ALL, SVC_INTERMISSION);
};

void() changelevel_touch = 
{
	local entity pos;
	if (other.classname != "player")
	{
		return;
	}
	if (cvar("noexit") == 3)
	{
		return;
	}
	if (cvar("noexit") == 1 || (cvar("noexit") == 2 && mapname != "start"))
	{
		T_Damage(other, self, self, 50000);
		return;
	}
	if (coop || deathmatch)
	{
		bprint(other.netname);
		bprint(" exited the level\n");
	}
	NextLevel();
	SUB_UseTargets();
	if (self.spawnflags & 1 && deathmatch == 0)
	{
		GotoNextMap();
		return;
	}
	self.touch = SUB_Null;
	self.think = execute_changelevel;
	self.nextthink = time + 0.1;
};

void() trigger_changelevel = 
{
	if (!(self.map))
	{
		objerror("chagnelevel trigger doesn't have map");
	}
	InitTrigger();
	self.touch = changelevel_touch;
};

void() respawn = 
{
	CopyToBodyQue(self);
	SetNewParms();
	PutClientInServer();
};

void() ClientKill = 
{
	if (self.observer)
	{
		sprint(self, "Can' Suicide, Observer");
		return;
	}
	bprint(self.netname);
	bprint(" suicides\n");
	self.frags = self.frags - 2;
	set_suicide_frame();
	self.modelindex = modelindex_player;
	DropRune();
	respawn();
};

void(vector v) CheckSpawnPoint = 
{
	return 0;
};

entity() SelectSpawnPoint = 
{
	local entity spot;
	spot = find(world, classname, "testplayerstart");
	if (spot)
	{
		return spot;
	}
	lastspawn = find(lastspawn, classname, "info_player_deathmatch");
	if (lastspawn == world)
	{
		lastspawn = find(lastspawn, classname, "info_player_deathmatch");
	}
	if (lastspawn != world)
	{
		return lastspawn;
	}
	if (serverflags)
	{
		spot = find(world, classname, "info_player_start2");
		if (spot)
		{
			return spot;
		}
	}
	spot = find(world, classname, "info_player_start");
	if (!spot)
	{
		error("PutClientInServer: no info_player_start on level");
	}
	return spot;
};

void() PutClientInServer = 
{
	local entity spot;
	self.observer = 0;
	self.classname = "player";
	self.health = 100;
	self.takedamage = DAMAGE_AIM;
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_WALK;
	self.show_hostile = 0;
	self.max_health = 100;
	self.flags = FL_CLIENT;
	self.air_finished = time + 12;
	self.dmg = 2;
	self.super_damage_finished = 0;
	self.radsuit_finished = 0;
	self.invisible_finished = 0;
	self.invincible_finished = 0;
	self.effects = 0;
	self.invincible_time = 0;
	self.staydeadtime = 0;
	self.regen_time = 0;
	self.rune_notice_time = 0;
	self.armormax = 0;
	self.quad_shot = 0;
	self.vars = servervars;
	DecodeLevelParms();
	if (self.resurrect == 1)
	{
		self.ammo_cells = self.rcells;
		self.ammo_shells = self.rshells;
		self.ammo_rockets = self.rrockets;
		self.ammo_nails = self.rnails;
		self.items = self.ritems;
		self.weapons = self.rweapons;
		self.items = self.items - (self.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3));
		self.items = self.items - (self.items & (IT_INVULNERABILITY | IT_QUAD | IT_INVISIBILITY | IT_SUIT));
	}
	self.resurrect = 0;
	W_SetCurrentAmmo();
	self.attack_finished = time;
	self.th_pain = player_pain;
	self.th_die = PlayerDie;
	self.deadflag = DEAD_NO;
	self.pausetime = 0;
	spot = SelectSpawnPoint();
	self.origin = spot.origin + '0 0 1';
	self.angles = spot.angles;
	self.fixangle = 1;
	setmodel(self, "progs/eyes.mdl");
	modelindex_eyes = self.modelindex;
	setmodel(self, "progs/player.mdl");
	modelindex_player = self.modelindex;
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
	self.view_ofs = '0 0 22';
	player_stand1();
	makevectors(self.angles);
	if (self.newbie == 1)
	{
		MakeObserver();
		self.newbie = 0;
	}
	else
	{
		spawn_tfog(self.origin + v_forward * 20);
		spawn_tdeath(self.origin, self);
	}
};

void() info_player_start = 
{
};

void() info_player_start2 = 
{
};

void() testplayerstart = 
{
};

void() info_player_deathmatch = 
{
	local entity rspawn;
	if (deathmatch)
	{
		rspawn = spawn();
		rspawn.nextthink = time + 0.1;
		rspawn.think = SpawnRunes;
	}
};

void() info_player_coop = 
{
};

void(entity c) PrintClientScore = 
{
	if (c.frags > -10 && c.frags < 0)
	{
		bprint(" ");
	}
	else
	{
		if (c.frags >= 0)
		{
			if (c.frags < 100)
			{
				bprint(" ");
			}
			if (c.frags < 10)
			{
				bprint(" ");
			}
		}
	}
	bprint(ftos(c.frags));
	bprint(" ");
	bprint(c.netname);
	bprint("\n");
};

void() DumpScore = 
{
	local entity e;
	local entity sort;
	local entity walk;
	if (world.chain)
	{
		error("DumpScore: world.chain is set");
	}
	e = find(world, classname, "player");
	sort = world;
	while (e)
	{
		if (!sort)
		{
			sort = e;
			e.chain = world;
		}
		else
		{
			if (e.frags > sort.frags)
			{
				e.chain = sort;
				sort = e;
			}
			else
			{
				walk = sort;
				do
				{
					if (!(walk.chain))
					{
						e.chain = world;
						walk.chain = e;
					}
					else
					{
						if (walk.chain.frags < e.frags)
						{
							e.chain = walk.chain;
							walk.chain = e;
						}
						else
						{
							walk = walk.chain;
						}
					}
				} while (walk.chain != e);
			}
		}
		e = find(e, classname, "player");
	}
	bprint("\n");
	while (sort)
	{
		PrintClientScore(sort);
		sort = sort.chain;
	}
	bprint("\n");
};

void() NextLevel = 
{
	local entity o;
	if (mapname == "start")
	{
		if (!cvar("registered"))
		{
			mapname = "e1m1";
		}
		else
		{
			if (!(serverflags & 1))
			{
				mapname = "e1m1";
				serverflags = serverflags | 1;
			}
			else
			{
				if (!(serverflags & 2))
				{
					mapname = "e2m1";
					serverflags = serverflags | 2;
				}
				else
				{
					if (!(serverflags & 4))
					{
						mapname = "e3m1";
						serverflags = serverflags | 4;
					}
					else
					{
						if (!(serverflags & 8))
						{
							mapname = "e4m1";
							serverflags = serverflags - 7;
						}
					}
				}
			}
		}
		o = spawn();
		o.map = mapname;
	}
	else
	{
		o = spawn();
		o.map = RandomLevel(mapname);
		if (!o)
		{
			mapname = "start";
			o = spawn();
			o.map = mapname;
		}
	}
	nextmap = o.map;
	gameover = 1;
	if (o.nextthink < time)
	{
		o.think = execute_changelevel;
		o.nextthink = time + 0.1;
	}
};

void() NextLevelo = 
{
	local entity o;
	o = find(world, classname, "trigger_changelevel");
	if (!o || mapname == "start")
	{
		o = spawn();
		o.map = mapname;
	}
	nextmap = o.map;
	if (o.nextthink < time)
	{
		o.think = execute_changelevel;
		o.nextthink = time + 0.1;
	}
};

string(string old) RandomLevel = 
{
	local float r;
	local float idlvl;
	local float percent;
	local string smap;
	local string s;
	r = random();
	if (r > 0.833)
	{
		r = random() * 7;
		if (r >= 6 && old != "e1m1")
		{
			return "e1m1";
		}
		if (r >= 5 && old != "e1m2")
		{
			return "e1m2";
		}
		if (r >= 4 && old != "e1m3")
		{
			return "e1m3";
		}
		if (r >= 3 && old != "e1m4")
		{
			return "e1m4";
		}
		if (r >= 2 && old != "e1m5")
		{
			return "e1m5";
		}
		if (r >= 1 && old != "e1m6")
		{
			return "e1m6";
		}
		return "e1m8";
	}
	else
	{
		if (r > 0.666)
		{
			r = random() * 6;
			if (r >= 5 && old != "e2m1")
			{
				return "e2m1";
			}
			if (r >= 4 && old != "e2m2")
			{
				return "e2m2";
			}
			if (r >= 3 && old != "e2m3")
			{
				return "e2m3";
			}
			if (r >= 2 && old != "e2m4")
			{
				return "e2m4";
			}
			if (r >= 1 && old != "e2m5")
			{
				return "e2m5";
			}
			return "e2m7";
		}
		else
		{
			if (r > 0.5)
			{
				r = random() * 6;
				if (r >= 5 && old != "e3m1")
				{
					return "e3m1";
				}
				if (r >= 4 && old != "e3m2")
				{
					return "e3m2";
				}
				if (r >= 3 && old != "e3m3")
				{
					return "e3m3";
				}
				if (r >= 2 && old != "e3m5")
				{
					return "e3m5";
				}
				if (r >= 1 && old != "e3m6")
				{
					return "e3m6";
				}
				return "e3m7";
			}
			else
			{
				if (r > 0.333)
				{
					r = random() * 8;
					if (r >= 7 && old != "e4m1")
					{
						return "e4m1";
					}
					if (r >= 6 && old != "e4m2")
					{
						return "e4m2";
					}
					if (r >= 5 && old != "e4m3")
					{
						return "e4m3";
					}
					if (r >= 4 && old != "e4m4")
					{
						return "e4m4";
					}
					if (r >= 3 && old != "e4m5")
					{
						return "e4m5";
					}
					if (r >= 2 && old != "e4m6")
					{
						return "e4m6";
					}
					if (r >= 1 && old != "e4m7")
					{
						return "e4m7";
					}
					return "e4m8";
				}
				else
				{
					if (r > 0.1666)
					{
						r = random() * 5;
						if (r >= 4 && old != "dm2")
						{
							return "dm2";
						}
						if (r >= 3 && old != "dm3")
						{
							return "dm3";
						}
						if (r >= 2 && old != "dm4")
						{
							return "dm4";
						}
						if (r >= 1 && old != "dm5")
						{
							return "dm5";
						}
						return "dm6";
					}
					else
					{
						r = random() * 9;
						if (r >= 8 && old != "1dx1")
						{
							return "1dx1";
						}
						if (r >= 7 && old != "1dx2")
						{
							return "1dx2";
						}
						if (r >= 6 && old != "1dx3")
						{
							return "1dx3";
						}
						if (r >= 5 && old != "1dx4")
						{
							return "1dx4";
						}
						if (r >= 4 && old != "1dx5")
						{
							return "1dx5";
						}
						if (r >= 3 && old != "1dx6")
						{
							return "1dx6";
						}
						if (r >= 2 && old != "1dx7")
						{
							return "1dx7";
						}
						if (r >= 1 && old != "1dx8")
						{
							return "1dx8";
						}
						return "1dx9";
					}
				}
			}
		}
	}
	return "start";
};

void() DoNextLevel = 
{
	if (servervars & SV_RANDOMLEVELS)
	{
		NextLevel();
	}
	else
	{
		NextLevelo();
	}
};

void() CheckRules = 
{
	local float timelimit;
	local float fraglimit;
	if (gameover)
	{
		return;
	}
	timelimit = cvar("timelimit") * 60;
	fraglimit = cvar("fraglimit");
	if (timelimit && time >= timelimit)
	{
		DoNextLevel();
		return;
	}
	if (fraglimit && self.frags >= fraglimit)
	{
		DoNextLevel();
		return;
	}
};

void() PlayerDeathThink = 
{
	local entity old_self;
	local float forward;
	if (self.flags & FL_ONGROUND)
	{
		forward = vlen(self.velocity);
		forward = forward - 20;
		if (forward <= 0)
		{
			self.velocity = '0 0 0';
		}
		else
		{
			self.velocity = forward * normalize(self.velocity);
		}
	}
	if (self.deadflag == DEAD_DEAD)
	{
		if (self.button2 || self.button1 || self.button0)
		{
			return;
		}
		self.deadflag = DEAD_RESPAWNABLE;
		return;
	}
	if (!(self.button2) && !(self.button1) && !(self.button0))
	{
		return;
	}
	self.button0 = 0;
	self.button1 = 0;
	self.button2 = 0;
	respawn();
};

void() PlayerJump = 
{
	local vector start;
	local vector end;
	if (self.flags & FL_WATERJUMP)
	{
		return;
	}
	if (self.flags & FL_OBSERVER)
	{
		return;
	}
	if (self.waterlevel >= 2)
	{
		if (self.watertype == CONTENT_WATER)
		{
			self.velocity_z = 100;
		}
		else
		{
			if (self.watertype == CONTENT_SLIME)
			{
				self.velocity_z = 80;
			}
			else
			{
				self.velocity_z = 50;
			}
		}
		if (self.swim_flag < time && !(self.player_flag & ITEM_RUNE5_FLAG))
		{
			self.swim_flag = time + 1;
			if (!(self.observer))
			{
				if (random() < 0.5)
				{
					sound(self, CHAN_BODY, "misc/water1.wav", 1, ATTN_NORM);
				}
				else
				{
					sound(self, CHAN_BODY, "misc/water2.wav", 1, ATTN_NORM);
				}
			}
		}
		return;
	}
	if (!(self.flags & FL_ONGROUND))
	{
		return;
	}
	if (!(self.flags & FL_JUMPRELEASED))
	{
		return;
	}
	self.flags = self.flags - (self.flags & FL_JUMPRELEASED);
	self.flags = self.flags - FL_ONGROUND;
	self.button2 = 0;
	if (!(self.observer))
	{
		if (!(self.player_flag & ITEM_RUNE5_FLAG))
		{
			sound(self, CHAN_BODY, "player/plyrjmp8.wav", 1, ATTN_NORM);
		}
	}
	self.velocity_z = self.velocity_z + 270;
};

void() WaterMove = 
{
	if (self.movetype == MOVETYPE_NOCLIP)
	{
		return;
	}
	if (self.health < 0)
	{
		return;
	}
	if (!(self.observer))
	{
		if (!(self.player_flag & ITEM_RUNE8_FLAG))
		{
			if (self.waterlevel != 3)
			{
				if (self.air_finished < time)
				{
					if (!(self.player_flag & ITEM_RUNE5_FLAG))
					{
						sound(self, CHAN_VOICE, "player/gasp2.wav", 1, ATTN_NORM);
					}
				}
				else
				{
					if (self.air_finished < time + 9)
					{
						if (!(self.player_flag & ITEM_RUNE5_FLAG))
						{
							sound(self, CHAN_VOICE, "player/gasp1.wav", 1, ATTN_NORM);
						}
					}
				}
				self.air_finished = time + 12;
				self.dmg = 2;
			}
			else
			{
				if (self.air_finished < time)
				{
					if (self.pain_finished < time)
					{
						self.dmg = self.dmg + 2;
						if (self.dmg > 15)
						{
							self.dmg = 10;
						}
						T_Damage(self, world, world, self.dmg);
						self.pain_finished = time + 1;
					}
				}
			}
		}
		else
		{
			self.air_finished = 12;
		}
	}
	if (!(self.waterlevel))
	{
		if (self.flags & FL_INWATER)
		{
			if (!(self.player_flag & ITEM_RUNE5_FLAG))
			{
				sound(self, CHAN_BODY, "misc/outwater.wav", 1, ATTN_NORM);
			}
			self.flags = self.flags - FL_INWATER;
		}
		return;
	}
	if (!(self.player_flag & ITEM_RUNE8_FLAG))
	{
		if (self.watertype == CONTENT_LAVA)
		{
			if (self.dmgtime < time)
			{
				if (self.radsuit_finished > time)
				{
					self.dmgtime = time + 1;
				}
				else
				{
					self.dmgtime = time + 0.2;
				}
				T_Damage(self, world, world, 10 * self.waterlevel);
			}
		}
		else
		{
			if (self.watertype == CONTENT_SLIME)
			{
				if (self.dmgtime < time && self.radsuit_finished < time)
				{
					self.dmgtime = time + 1;
					T_Damage(self, world, world, 4 * self.waterlevel);
				}
			}
		}
	}
	if (!(self.flags & FL_INWATER))
	{
		if (!(self.observer))
		{
			if (!(self.player_flag & ITEM_RUNE5_FLAG))
			{
				if (self.watertype == CONTENT_LAVA)
				{
					sound(self, CHAN_BODY, "player/inlava.wav", 1, ATTN_NORM);
				}
				if (self.watertype == CONTENT_WATER)
				{
					sound(self, CHAN_BODY, "player/inh2o.wav", 1, ATTN_NORM);
				}
				if (self.watertype == CONTENT_SLIME)
				{
					sound(self, CHAN_BODY, "player/slimbrn2.wav", 1, ATTN_NORM);
				}
			}
		}
		self.flags = self.flags + FL_INWATER;
		self.dmgtime = 0;
	}
	if (!(self.flags & FL_WATERJUMP))
	{
		self.velocity = self.velocity - 0.8 * self.waterlevel * frametime * self.velocity;
	}
};

void() CheckWaterJump = 
{
	local vector start;
	local vector end;
	makevectors(self.angles);
	start = self.origin;
	start_z = start_z + 8;
	v_forward_z = 0;
	normalize(v_forward);
	end = start + v_forward * 24;
	traceline(start, end, 1, self);
	if (trace_fraction < 1)
	{
		start_z = start_z + self.maxs_z - 8;
		end = start + v_forward * 24;
		self.movedir = trace_plane_normal * -50;
		traceline(start, end, 1, self);
		if (trace_fraction == 1)
		{
			self.flags = self.flags | FL_WATERJUMP;
			self.velocity_z = 225;
			self.flags = self.flags - (self.flags & FL_JUMPRELEASED);
			self.teleport_time = time + 2;
			return;
		}
	}
};

void() PlayerPreThink = 
{
	local float mspeed;
	local float aspeed;
	local float r;
	local float snipwait;
	if (intermission_running)
	{
		IntermissionThink();
		return;
	}
	if (self.view_ofs == '0 0 0')
	{
		return;
	}
	makevectors(self.v_angle);
	CheckRules();
	WaterMove();
	if (self.weapon == IT_EXTRA_WEAPON && self.weapon2 == WE_SNIPER_RIFLE)
	{
		snipwait = vlen(self.velocity);
		if (self.hook_out)
		{
			if (snipwait > 500)
			{
				self.snipe_wait = time + 1.25;
			}
		}
		if (snipwait > 30 && !(self.hook_out))
		{
			self.snipe_wait = time + 1.25;
		}
	}
	if (self.observer)
	{
		ObserverThink();
	}
	if (self.waterlevel == 2)
	{
		CheckWaterJump();
	}
	if (self.deadflag >= DEAD_DEAD && self.blood_finished)
	{
		self.deadflag = DEAD_NO;
	}
	if (self.deadflag >= DEAD_DEAD)
	{
		PlayerDeathThink();
		return;
	}
	if (self.deadflag == DEAD_DYING)
	{
		return;
	}
	if (self.button2 && !(self.observer))
	{
		PlayerJump();
	}
	else
	{
		self.flags = self.flags | FL_JUMPRELEASED;
	}
	if (time < self.pausetime)
	{
		self.velocity = '0 0 0';
	}
};

void() CheckPowerups = 
{
	if (self.health <= 0)
	{
		return;
	}
	if (self.player_flag & ITEM_RUNE9_FLAG)
	{
		if (self.invisible_finished > time + 3)
		{
			self.invisible_finished = time + 3;
		}
		if (self.invincible_finished > time + 3)
		{
			self.invincible_finished = time + 3;
		}
		if (self.super_damage_finished > time + 3)
		{
			self.super_damage_finished = time + 3;
		}
		if (self.blood_finished > time + 3)
		{
			self.blood_finished = time + 3;
		}
	}
	if (self.invisible_finished)
	{
		if (self.invisible_sound < time && !(self.player_flag & ITEM_RUNE5_FLAG))
		{
			sound(self, CHAN_AUTO, "items/inv3.wav", 0.5, ATTN_IDLE);
			self.invisible_sound = time + (random() * 3 + 1);
		}
		if (self.invisible_finished < time + 3)
		{
			if (self.invisible_time == 1)
			{
				if (!(self.player_flag & ITEM_RUNE5_FLAG))
				{
					sprint(self, "Ring of Shadows magic is fading\n");
					stuffcmd(self, "bf\n");
					sound(self, CHAN_AUTO, "items/inv2.wav", 1, ATTN_NORM);
				}
				self.invisible_time = time + 1;
			}
			if (self.invisible_time < time)
			{
				self.invisible_time = time + 1;
				stuffcmd(self, "bf\n");
			}
		}
		if (self.invisible_finished < time)
		{
			self.items = self.items - (self.items & IT_INVISIBILITY);
			self.invisible_finished = 0;
			self.invisible_time = 0;
		}
		self.frame = 0;
		self.modelindex = modelindex_eyes;
	}
	else
	{
		self.modelindex = modelindex_player;
	}
	if (self.invincible_finished)
	{
		if (self.invincible_finished < time + 3)
		{
			if (self.invincible_time == 1)
			{
				sprint(self, "Protection is almost burned out\n");
				stuffcmd(self, "bf\n");
				if (!(self.player_flag & ITEM_RUNE5_FLAG))
				{
					sound(self, CHAN_AUTO, "items/protect2.wav", 1, ATTN_NORM);
				}
				self.invincible_time = time + 1;
			}
			if (self.invincible_time < time)
			{
				self.invincible_time = time + 1;
				stuffcmd(self, "bf\n");
			}
		}
		if (self.invincible_finished < time)
		{
			self.items = self.items - IT_INVULNERABILITY;
			self.invincible_time = 0;
			self.invincible_finished = 0;
		}
		if (self.invincible_finished > time)
		{
			self.effects = self.effects | EF_DIMLIGHT;
		}
		else
		{
			self.effects = self.effects - (self.effects & EF_DIMLIGHT);
		}
	}
	if (self.super_damage_finished)
	{
		if (self.super_damage_finished < time + 3)
		{
			if (self.super_time == 1)
			{
				if (!(self.bad_quad))
				{
					sprint(self, "Quad Damage is wearing off\n");
				}
				else
				{
					sprint(self, "You are feeling less of a llama\n");
				}
				stuffcmd(self, "bf\n");
				if (!(self.player_flag & ITEM_RUNE5_FLAG))
				{
					sound(self, CHAN_AUTO, "items/damage2.wav", 1, ATTN_NORM);
				}
				self.super_time = time + 1;
			}
			if (self.super_time < time)
			{
				self.super_time = time + 1;
				stuffcmd(self, "bf\n");
			}
		}
		if (self.super_damage_finished < time)
		{
			self.bad_quad = 0;
			self.items = self.items - IT_QUAD;
			self.super_damage_finished = 0;
			self.super_time = 0;
		}
		if (self.super_damage_finished > time)
		{
			self.effects = self.effects | EF_DIMLIGHT;
		}
		else
		{
			self.effects = self.effects - (self.effects & EF_DIMLIGHT);
		}
	}
	if (self.radsuit_finished)
	{
		self.air_finished = time + 12;
		if (self.radsuit_finished < time + 3)
		{
			if (self.rad_time == 1)
			{
				sprint(self, "Air supply in Biosuit expiring\n");
				stuffcmd(self, "bf\n");
				if (!(self.player_flag & ITEM_RUNE5_FLAG))
				{
					sound(self, CHAN_AUTO, "items/suit2.wav", 1, ATTN_NORM);
				}
				self.rad_time = time + 1;
			}
			if (self.rad_time < time)
			{
				self.rad_time = time + 1;
				stuffcmd(self, "bf\n");
			}
		}
		if (self.radsuit_finished < time)
		{
			self.items = self.items - IT_SUIT;
			self.rad_time = 0;
			self.radsuit_finished = 0;
		}
	}
	if (self.player_flag & ITEM_RUNE5_FLAG)
	{
		if (self.invis_time < time)
		{
			if (self.invis_time != -1)
			{
				self.invis_time = -1;
				sound(self, CHAN_AUTO, "items/inv1.wav", 1, ATTN_NORM);
				self.effects = 0;
			}
			self.items = self.items | IT_INVISIBILITY;
			self.invisible_finished = time + 50;
			self.invisible_time = 1;
		}
	}
	if (self.player_flag & ITEM_RUNE4_FLAG)
	{
		if (self.health < 150 && self.regen_time < time)
		{
			self.health = self.health + 3;
			self.regen_time = time + 0.55;
			RegenerationSound();
			if (self.health > 150)
			{
				self.health = 150;
			}
		}
	}
	if (self.armormax > 0 && self.armorvalue < self.armormax)
	{
		if (self.armor_time < time)
		{
			self.armorvalue = self.armorvalue + 1;
			self.armor_time = time + 0.55;
		}
	}
	if (self.blood_finished)
	{
		if (self.blood_finished < time + 3)
		{
			if (self.blood_time < time)
			{
				if (self.blood_finished > time + 2)
				{
					sprint(self, "Blood Lust is wearing off\n");
				}
				stuffcmd(self, "bf\n");
				if (!(self.player_flag & ITEM_RUNE5_FLAG))
				{
					sound(self, CHAN_AUTO, "items/blood2.wav", 1, ATTN_NORM);
				}
				self.blood_time = time + 1;
			}
			if (self.blood_time + 1 < time)
			{
				self.blood_time = time + 1;
				stuffcmd(self, "bf\n");
			}
		}
		if (self.blood_finished < time)
		{
			self.blood_finished = 0;
			self.blood_time = 0;
			self.effects = self.effects - (self.effects & EF_DIMLIGHT);
			if (self.die > 0)
			{
				GibPlayer();
			}
		}
		if (self.blood_finished > time)
		{
			self.effects = self.effects | EF_DIMLIGHT;
			if (self.health < 0 && self.health > -40)
			{
				self.health = 1;
				self.deadflag = 0;
				self.die = 1;
			}
		}
		else
		{
			self.effects = self.effects - (self.effects & EF_DIMLIGHT);
		}
	}
	if (self.shub_time)
	{
		self.items = self.items | IT_QUAD;
		self.super_damage_finished = self.shub_time;
		if (self.super_time != 1 && self.super_damage_finished > time + 3)
		{
			self.super_time = 1;
		}
		self.bad_quad = 1;
		self.frag = 2;
		self.max_health = 25;
		if (self.health > 25)
		{
			self.health = 25;
		}
		self.armorvalue = 0;
		self.armortype = 0;
		self.items = self.items - (self.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3));
		self.armormax = 0;
		self.effects = self.effects | EF_BRIGHTLIGHT;
	}
	if (self.shub_time < time && self.shub_time)
	{
		self.frag = 0;
		self.max_health = 100;
		self.health = 50;
		self.armorvalue = 0;
		self.armortype = 0;
		self.items = self.items - (self.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3));
		self.armormax = 0;
		self.effects = self.effects - (self.effects & EF_BRIGHTLIGHT);
		self.shub_time = 0;
		sprint(self, "You no longer serve Shub.\n");
	}
	if (self.frag_time < time && self.frag_time)
	{
		sprint(self, "Double frags have run out\n");
		self.frag_time = 0;
		self.frag = 0;
	}
	if (self.axe_only_time > time && self.weapon != IT_AXE)
	{
		self.weapon = IT_AXE;
		W_SetCurrentAmmo();
	}
	else
	{
		if (self.axe_only_time < time && self.axe_only_time)
		{
			sprint(self, "You don't need to use the axe anymore\n");
			self.axe_only_time = 0;
		}
	}
};

void() PlayerPostThink = 
{
	local float mspeed;
	local float aspeed;
	local float r;
	if (self.view_ofs == '0 0 0')
	{
		return;
	}
	MOTDCheck();
	if (self.deadflag)
	{
		return;
	}
	W_WeaponFrame();
	if (self.jump_flag < -300 && (self.flags & FL_ONGROUND) && self.health > 0)
	{
		if (self.watertype == CONTENT_WATER)
		{
			if (!(self.player_flag & ITEM_RUNE5_FLAG))
			{
				sound(self, CHAN_BODY, "player/h2ojump.wav", 1, ATTN_NORM);
			}
		}
		else
		{
			if (self.jump_flag < -650)
			{
				T_Damage(self, world, world, 5);
				if (self.health < 0)
				{
					self.deathtype = "falling";
				}
				if (!(self.player_flag & ITEM_RUNE5_FLAG))
				{
					if (self.blood_finished < time)
					{
						sound(self, CHAN_VOICE, "player/land2.wav", 1, ATTN_NORM);
					}
				}
			}
			else
			{
				if (!(self.player_flag & ITEM_RUNE5_FLAG))
				{
					sound(self, CHAN_VOICE, "player/land.wav", 1, ATTN_NORM);
				}
			}
		}
		self.jump_flag = 0;
	}
	if (!(self.flags & FL_ONGROUND))
	{
		self.jump_flag = self.velocity_z;
	}
	CheckPowerups();
};

void() ClientConnect = 
{
	bprint(self.netname);
	bprint(" entered the game\n");
	if (intermission_running)
	{
		ExitIntermission();
	}
	if (servervars & SV_STARTASOBSERVER)
	{
		self.newbie = 1;
	}
};

void() ClientDisconnect = 
{
	if (gameover)
	{
		return;
	}
	sprint(self, "Remember, peace through superior firepower\n");
	DropRune();
	bprint(self.netname);
	bprint(" left the game with ");
	bprint(ftos(self.frags));
	bprint(" frags\n");
	sound(self, CHAN_BODY, "player/tornoff2.wav", 1, ATTN_NONE);
	set_suicide_frame();
};

void(entity targ, entity attacker) ClientObituary = 
{
	local float rnum;
	local string deathstring;
	local string deathstring2;
	rnum = random();
	if (targ.classname == "player")
	{
		if (attacker.classname == "teledeath")
		{
			bprint(targ.netname);
			bprint(" was telefragged by ");
			bprint(attacker.owner.netname);
			bprint("\n");
			attacker.owner.frags = attacker.owner.frags + 1;
			return;
		}
		if (attacker.classname == "teledeath2")
		{
			bprint("Satan's power deflects ");
			bprint(targ.netname);
			bprint("'s telefrag\n");
			targ.frags = targ.frags - 1;
			return;
		}
		if (attacker.classname == "undead")
		{
			if (targ == attacker.own)
			{
				attacker.own.frags = attacker.own.frags - 1;
			}
			else
			{
				if (attacker.own != world)
				{
					attacker.own.frags = attacker.own.frags + 1;
				}
			}
			bprint(targ.netname);
			bprint(" was killed by ");
			bprint(attacker.own.netname);
			bprint("'s undead monster\n");
			return;
		}
		if (attacker.classname == "player")
		{
			if (targ == attacker)
			{
				attacker.frags = attacker.frags - 1;
				bprint(targ.netname);
				if (targ.weapon == 64 && targ.waterlevel > 1)
				{
					bprint(" discharges into the water.\n");
					return;
				}
				if (targ.weapon == 16)
				{
					bprint(" tries to put the pin back in\n");
				}
				else
				{
					if (rnum)
					{
						bprint(" becomes bored with life\n");
					}
					else
					{
						bprint(" checks if his weapon is loaded\n");
					}
				}
				return;
			}
			else
			{
				if (!(attacker.frag))
				{
					attacker.frags = attacker.frags + 1;
				}
				if (attacker.frag == 1)
				{
					attacker.frags = attacker.frags + 2;
				}
				if (targ.frag == 2)
				{
					attacker.frags = attacker.frags + 2;
				}
				rnum = attacker.weapon;
				if (rnum == IT_AXE)
				{
					deathstring = " was ax-murdered by ";
					deathstring2 = "\n";
				}
				else
				{
					if (rnum == IT_SHOTGUN)
					{
						deathstring = " chewed on ";
						deathstring2 = "'s boomstick\n";
					}
					else
					{
						if (rnum == IT_SUPER_SHOTGUN)
						{
							deathstring = " ate 2 loads of ";
							deathstring2 = "'s buckshot\n";
							if (attacker.quad_shot == 2)
							{
								deathstring = " ate *4* loads of ";
								deathstring2 = "'s buckshot\n";
							}
						}
						else
						{
							if (rnum == IT_NAILGUN)
							{
								deathstring = " was nailed by ";
								deathstring2 = "\n";
							}
							else
							{
								if (rnum == IT_SUPER_NAILGUN)
								{
									deathstring = " was punctured by ";
									deathstring2 = "\n";
								}
								else
								{
									if (rnum == IT_GRENADE_LAUNCHER)
									{
										deathstring = " eats ";
										deathstring2 = "'s pineapple\n";
										if (targ.health < -40)
										{
											deathstring = " was gibbed by ";
											deathstring2 = "'s grenade\n";
										}
									}
									else
									{
										if (rnum == IT_ROCKET_LAUNCHER)
										{
											deathstring = " rides ";
											deathstring2 = "'s rocket\n";
											if (targ.health < -40)
											{
												deathstring = " was gibbed by ";
												deathstring2 = "'s rocket\n";
											}
										}
										else
										{
											if (rnum == IT_LIGHTNING)
											{
												deathstring = " accepts ";
												if (attacker.waterlevel > 1)
												{
													deathstring2 = "'s discharge\n";
												}
												else
												{
													deathstring2 = "'s shaft\n";
												}
											}
											else
											{
												if (rnum == IT_EXTRA_WEAPON)
												{
													if (attacker.weapon2 == WE_AIRFIST)
													{
														deathstring = " was blown away by ";
														deathstring2 = "\n";
													}
													else
													{
														if (attacker.weapon2 == WE_WACKY)
														{
															deathstring = " was whacked by ";
															deathstring2 = "\n";
														}
														else
														{
															if (attacker.weapon2 == WE_CLUSTER)
															{
																deathstring = " was pulped by ";
																deathstring2 = "'s cluster bomb\n";
															}
															else
															{
																if (attacker.weapon2 == WE_GRAPPLE)
																{
																	deathstring = " was hooked by ";
																	deathstring2 = "\n";
																}
																else
																{
																	if (attacker.weapon2 == WE_SNIPER_RIFLE)
																	{
																		deathstring = " got sniped by ";
																		deathstring2 = "\n";
																	}
																	else
																	{
																		if (attacker.weapon2 == WE_PLASMAGUN)
																		{
																			deathstring = " got roasted by ";
																			deathstring2 = "'s Plasma Rifle\n";
																		}
																		else
																		{
																			if (attacker.weapon2 == WE_BFG)
																			{
																				deathstring = " saw ";
																				deathstring2 = "'s BFG blast\n";
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
													deathstring = " was killed by ";
												}
											}
										}
									}
								}
							}
						}
					}
				}
				bprint(targ.netname);
				bprint(deathstring);
				bprint(attacker.netname);
				bprint(deathstring2);
			}
			return;
		}
		else
		{
			if (!(targ.frag))
			{
				targ.frags = targ.frags - 1;
			}
			if (targ.frag == 1)
			{
				targ.frags = targ.frags - 2;
			}
			if (targ.frag == 2)
			{
				targ.frags = targ.frags - 3;
			}
			rnum = targ.watertype;
			bprint(targ.netname);
			if (attacker.classname == "trigger_discharge")
			{
				if (random() < 0.5)
				{
					bprint(" boils like a lobster\n");
				}
				else
				{
					bprint(" learns the meaning of 'sizzle fry'\n");
				}
				return;
			}
			if (rnum == -3)
			{
				if (random() < 0.5)
				{
					bprint(" sleeps with the fishes\n");
				}
				else
				{
					bprint(" sucks it down\n");
				}
				return;
			}
			else
			{
				if (rnum == -4)
				{
					if (random() < 0.5)
					{
						bprint(" gulped a load of slime\n");
					}
					else
					{
						bprint(" can't exist on slime alone\n");
					}
					return;
				}
				else
				{
					if (rnum == -5)
					{
						if (targ.health < -15)
						{
							bprint(" burst into flames\n");
							return;
						}
						if (random() < 0.5)
						{
							bprint(" turned into hot slag\n");
						}
						else
						{
							bprint(" visits the Volcano God\n");
						}
						return;
					}
				}
			}
			if (attacker.classname == "explo_box")
			{
				bprint(" blew up\n");
				return;
			}
			if (attacker.solid == SOLID_BSP && attacker != world)
			{
				bprint(" was squished\n");
				return;
			}
			if (targ.deathtype == "falling")
			{
				targ.deathtype = "";
				bprint(" fell to his death\n");
				return;
			}
			if (attacker.classname == "trap_shooter" || attacker.classname == "trap_spikeshooter")
			{
				bprint(" was spiked\n");
				return;
			}
			if (attacker.classname == "fireball")
			{
				bprint(" ate a lavaball\n");
				return;
			}
			if (attacker.classname == "trigger_changelevel")
			{
				bprint(" tried to leave\n");
				return;
			}
			bprint(" died\n");
		}
	}
};


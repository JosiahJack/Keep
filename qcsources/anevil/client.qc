void() mg_skinset = 
{
	local float sss;
	local float ss3;
	local float ss4;
	local float ss5;
	sss = random();
	ss3 = IQ_HIGH;
	ss4 = WEAPON_SPIKES;
	ss5 = IQ_ULTIMATE;
	if (sss < 0.66)
	{
		ss3 = WEAPON_ROCKET;
	}
	if (sss < 0.33)
	{
		ss3 = FIRE;
	}
	if (sss < 0.75)
	{
		ss4 = IQ_HIGH;
	}
	if (sss < 0.5)
	{
		ss4 = WEAPON_ROCKET;
	}
	if (sss < 0.25)
	{
		ss4 = FIRE;
	}
	if (sss < 0.8)
	{
		ss5 = WEAPON_SPIKES;
	}
	if (sss < 0.6)
	{
		ss5 = IQ_HIGH;
	}
	if (sss < 0.4)
	{
		ss5 = WEAPON_ROCKET;
	}
	if (sss < 0.2)
	{
		ss5 = FIRE;
	}
	self.skin = MSG_BROADCAST;
	if (teamplay == FIRE)
	{
		self.skin = ss3;
	}
	if (teamplay == WEAPON_ROCKET)
	{
		self.skin = ss3 + IQ_HIGH;
	}
	if (teamplay == IQ_HIGH)
	{
		self.skin = ss4 + TE_LIGHTNING2;
	}
	if (teamplay == WEAPON_SPIKES)
	{
		if (ss4 == WEAPON_SPIKES)
		{
			self.skin = MSG_BROADCAST;
		}
		else
		{
			self.skin = ss4 + SVC_SETVIEWANGLES;
		}
	}
	if (teamplay == IQ_ULTIMATE)
	{
		self.skin = ss5 + 13;
	}
	if (teamplay == TE_LIGHTNING2)
	{
		self.skin = ss5 + 18;
	}
};

void() CheckMOTD = 
{
	if (!deathmatch)
	{
		return;
	}
	if (self.motd_count < TE_LIGHTNING2 && self.motd_time < time)
	{
		self.motd_time = time + FIRE;
		self.motd_count = self.motd_count + FIRE;
		if (!teamplay)
		{
			centerprint(self, "Evilslaying not set\n");
		}
		if (teamplay == FIRE)
		{
			centerprint(self, "An Old, Old Evil\nSawn Off Mayhem\n");
		}
		if (teamplay == WEAPON_ROCKET)
		{
			centerprint(self, "An Old, Old Evil\nZombie Apocalypse\n");
		}
		if (teamplay == IQ_HIGH)
		{
			centerprint(self, "An Old, Old Evil\nOgres vs Anti-Paladins\n");
		}
		if (teamplay == WEAPON_SPIKES)
		{
			centerprint(self, "An Old, Old Evil\nWolfenquake\n");
		}
		if (teamplay == IQ_ULTIMATE)
		{
			centerprint(self, "An Old, Old Evil\nSpace Cakes!\n");
		}
		if (teamplay >= TE_LIGHTNING2)
		{
			centerprint(self, "An Old, Old Evil\nPerforator Quest\n");
		}
		return;
	}
};

void() info_intermission = 
{
};

void() SetChangeParms = 
{
	if (self.health <= MSG_BROADCAST)
	{
		SetNewParms();
		return;
	}
	self.items = self.items - (self.items & (IT_KEY1 | IT_KEY2 | IT_INVISIBILITY | IT_INVULNERABILITY | IT_SUIT | IT_QUAD));
	self.items2 = self.items2 - (self.items2 & (HIP_IT_WETSUIT | HIP_IT_EMPATHY_SHIELDS));
	self.gravity = FIRE;
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
	parm16 = self.dest2_x;
	parm14 = self.dest2_y;
	parm15 = self.dest2_z;
};

void() SetNewParms = 
{
	local float cv;
	parm1 = IT_SHOTGUN | IT_AXE | IT_GRENADE_LAUNCHER;
	parm2 = 100;
	parm3 = MSG_BROADCAST;
	if (deathmatch)
	{
		parm4 = MSG_BROADCAST;
	}
	else
	{
		parm4 = 25;
	}
	parm5 = MSG_BROADCAST;
	parm6 = MSG_BROADCAST;
	parm7 = MSG_BROADCAST;
	parm8 = FIRE;
	parm9 = MSG_BROADCAST;
	if (!parm14)
	{
		parm14 = 100;
	}
	if (!parm15)
	{
		parm15 = 0.22;
	}
	if (!parm16)
	{
		cv = cvar("temp1");
		if (cv == 100)
		{
			parm16 = CHSCAM_ON;
		}
		if (cv == 101)
		{
			parm16 = HUD_ON;
		}
		if (cv == 102)
		{
			parm16 = LASERTARG_ON;
		}
		if (cv == 103)
		{
			parm16 = CHSCAM_ON | LASERTARG_ON;
		}
		if (cv == 104)
		{
			parm16 = LASERTARG_ON | HUD_ON;
		}
		if (cv == 105)
		{
			parm16 = HUD_ON | CHSCAM_ON;
		}
		if (cv == 106)
		{
			parm16 = LASERTARG_ON | HUD_ON | CHSCAM_ON;
		}
	}
};

void() DecodeLevelParms = 
{
	if (world.model == "maps/start.bsp")
	{
		SetNewParms();
	}
	if (world.model == "maps/start2.bsp")
	{
		SetNewParms();
	}
	if (world.model == "maps/hip1m1.bsp")
	{
		SetNewParms();
	}
	if (world.model == "maps/hip2m1.bsp")
	{
		SetNewParms();
	}
	if (world.model == "maps/hip3m1.bsp")
	{
		SetNewParms();
	}
	if (deathmatch && teamplay)
	{
		SetNewParms();
	}
	self.items = parm1;
	self.health = parm2;
	self.armorvalue = parm3;
	self.ammo_shells = parm4;
	self.ammo_nails = parm5;
	self.ammo_rockets = parm6;
	self.ammo_cells = parm7;
	self.weapon = parm8;
	self.armortype = parm9 * 0.010000;
	self.biteme = 0;
	PM_KillFire(self);
	if (!(self.dest2_x))
	{
		self.dest2_x = parm16;
	}
	if (!(self.dest2_y))
	{
		self.dest2_y = parm14;
	}
	if (!(self.dest2_z))
	{
		self.dest2_z = parm15;
	}
	self.dest1_x = self.health;
};

entity() FindIntermission = 
{
	local entity spot;
	local float cyc;
	spot = find(world, classname, "info_intermission");
	if (spot)
	{
		cyc = random() * WEAPON_SPIKES;
		while (cyc > FIRE)
		{
			spot = find(spot, classname, "info_intermission");
			if (!spot)
			{
				spot = find(spot, classname, "info_intermission");
			}
			cyc = cyc - FIRE;
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
	intermission_exittime = time + FIRE;
	intermission_running = intermission_running + FIRE;
	if (intermission_running == WEAPON_ROCKET)
	{
		if (world.model == "maps/e1m7.bsp")
		{
			WriteByte(MSG_ALL, SVC_CDTRACK);
			WriteByte(MSG_ALL, WEAPON_ROCKET);
			WriteByte(MSG_ALL, IQ_HIGH);
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
				WriteByte(MSG_ALL, WEAPON_ROCKET);
				WriteByte(MSG_ALL, IQ_HIGH);
				WriteByte(MSG_ALL, SVC_FINALE);
				WriteString(MSG_ALL, "The Rune of Black Magic throbs evilly in\nyour hand and whispers dark thoughts\ninto your brain. You learn the inmost\nlore of the Hell-Mother; Shub-Niggurath!\nYou now know that she is behind all the\nterrible plotting which has led to so\nmuch death and horror. But she is not\ninviolate! Armed with this Rune, you\nrealize that once all four Runes are\ncombined, the gate to Shub-Niggurath's\nPit will open, and you can face the\nWitch-Goddess herself in her frightful\notherworld cathedral.");
				return;
			}
			else
			{
				if (world.model == "maps/e3m6.bsp")
				{
					WriteByte(MSG_ALL, SVC_CDTRACK);
					WriteByte(MSG_ALL, WEAPON_ROCKET);
					WriteByte(MSG_ALL, IQ_HIGH);
					WriteByte(MSG_ALL, SVC_FINALE);
					WriteString(MSG_ALL, "The charred viscera of diabolic horrors\nbubble viscously as you seize the Rune\nof Hell Magic. Its heat scorches your\nhand, and its terrible secrets blight\nyour mind. Gathering the shreds of your\ncourage, you shake the devil's shackles\nfrom your soul, and become ever more\nhard and determined to destroy the\nhideous creatures whose mere existence\nthreatens the souls and psyches of all\nthe population of Earth.");
					return;
				}
				else
				{
					if (world.model == "maps/e4m7.bsp")
					{
						WriteByte(MSG_ALL, SVC_CDTRACK);
						WriteByte(MSG_ALL, WEAPON_ROCKET);
						WriteByte(MSG_ALL, IQ_HIGH);
						WriteByte(MSG_ALL, SVC_FINALE);
						WriteString(MSG_ALL, "Despite the awful might of the Elder\nWorld, you have achieved the Rune of\nElder Magic, capstone of all types of\narcane wisdom. Beyond good and evil,\nbeyond life and death, the Rune\npulsates, heavy with import. Patient and\npotent, the Elder Being Shub-Niggurath\nweaves her dire plans to clear off all\nlife from the Earth, and bring her own\nfoul offspring to our world! For all the\ndwellers in these nightmare dimensions\nare her descendants! Once all Runes of\nmagic power are united, the energy\nbehind them will blast open the Gateway\nto Shub-Niggurath, and you can travel\nthere to foil the Hell-Mother's plots\nin person.");
						return;
					}
				}
			}
		}
		if (world.model == "maps/hip1m4.bsp")
		{
			WriteByte(MSG_ALL, SVC_CDTRACK);
			WriteByte(MSG_ALL, TE_LIGHTNING2);
			WriteByte(MSG_ALL, IQ_HIGH);
			WriteByte(MSG_ALL, SVC_FINALE);
			WriteString(MSG_ALL, "Deep within the bowels of the\nResearch Facility, you discover the\npassage that the followers of Quake\nhave used to enter our world.\nThe bastards used some type of\ngigantic teleporter to overload\none of our own slipgates!  As long as\nthis portal exists, Earth will never\nbe safe from Quake's cruel minions.");
			return;
		}
		else
		{
			if (world.model == "maps/hip2m5.bsp")
			{
				WriteByte(MSG_ALL, SVC_CDTRACK);
				WriteByte(MSG_ALL, TE_LIGHTNING2);
				WriteByte(MSG_ALL, IQ_HIGH);
				WriteByte(MSG_ALL, SVC_FINALE);
				WriteString(MSG_ALL, "After destroying the power generator,\nyou pass beyond the gate of Mortum's\nKeep.  A wave of nausea suddenly flows\nover you and you find yourself cast\nout into a liquid void.  You float\nlifelessly, yet aware, in a lavender\nsea of energy.");
				return;
			}
			else
			{
				if (world.model == "maps/hipend.bsp")
				{
					WriteByte(MSG_ALL, SVC_CDTRACK);
					WriteByte(MSG_ALL, WEAPON_ROCKET);
					WriteByte(MSG_ALL, IQ_HIGH);
					WriteByte(MSG_ALL, SVC_FINALE);
					WriteString(MSG_ALL, "After the last echoes of Armagon's\ndeath yell fade away, you breathe a\nheavy sigh of relief.  With the loss\nof his magic, Armagon's fortress\nbegins to collapse.  The rift he\ncreated to send his grisly troops\nthrough time slowly closes and seals\nitself forever.  In the chaos that\nensues, a wall collapses, revealing\none remaining time portal.  With your\nchances to escape rapidly growing\nslim, you race for the portal,\nmindless of your destination.  In a\nflash of light, you find yourself\nback at Command HQ, safe and sound.");
					return;
				}
			}
		}
		GotoNextMap();
	}
	if (intermission_running == IQ_HIGH)
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
		if (world.model == "maps/hip1m4.bsp")
		{
			WriteByte(MSG_ALL, SVC_FINALE);
			WriteString(MSG_ALL, "If you can find the source of the\nportal's power, you can shut it\ndown--possibly forever!  With only a\nmoment's consideration for your own\nsafety, you re-enter the dark domain,\nknowing Hell would be a better fate\nthan experiencing the reign of Quake.");
			return;
		}
		else
		{
			if (world.model == "maps/hip2m5.bsp")
			{
				WriteByte(MSG_ALL, SVC_FINALE);
				WriteString(MSG_ALL, "After what seems like an eternity,\nyou feel the presence of a diabolical\nintelligence.  You are held helpless\nfor a moment as your mind is open to\nthat of Armagon--Quake's General and\nmaster of this realm.  Recognizing\nyou as the one who foiled his\nattempt to conquer Earth, a hellish\nhowl fills your mind and blots out\nall consciousness.  When you awake,\nyou find yourself on the shores of\nreality, but in a time and place\nunknown to you.");
				return;
			}
			else
			{
				if (world.model == "maps/hipend.bsp")
				{
					WriteByte(MSG_ALL, SVC_FINALE);
					WriteString(MSG_ALL, "Congratulations!  You are victorious!\nThe minions of Quake have once again\nfallen before your mighty hand.\nIs this the last you will see of\nQuake's hellions?\n\nOnly time will tell...");
					intermission_exittime = time + 10000000;
					return;
				}
			}
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
	intermission_running = FIRE;
	if (deathmatch)
	{
		intermission_exittime = time + IQ_ULTIMATE;
	}
	else
	{
		intermission_exittime = time + WEAPON_ROCKET;
	}
	WriteByte(MSG_ALL, SVC_CDTRACK);
	WriteByte(MSG_ALL, TE_LIGHTNING3);
	WriteByte(MSG_ALL, IQ_HIGH);
	pos = FindIntermission();
	other = find(world, classname, "player");
	while (other != world)
	{
		PM_KillFire(other);
		other.view_ofs = VEC_ORIGIN;
		other.angles = other.v_angle = pos.mangle;
		other.fixangle = 1;
		other.nextthink = time + 0.5;
		other.takedamage = DAMAGE_NO;
		other.solid = SOLID_NOT;
		other.movetype = MOVETYPE_NONE;
		other.modelindex = MSG_BROADCAST;
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
	if (cvar("noexit") == FIRE || (cvar("noexit") == WEAPON_ROCKET && mapname != "start"))
	{
		T_Damage(other, self, self, 50000);
		return;
	}
	if (coop || deathmatch)
	{
		bprint(other.netname);
		bprint(" exited the level\n");
	}
	nextmap = self.map;
	SUB_UseTargets();
	if (self.spawnflags & FIRE && deathmatch == MSG_BROADCAST)
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
	if (coop)
	{
		CopyToBodyQue(self);
		setspawnparms(self);
		PutClientInServer();
	}
	else
	{
		if (deathmatch)
		{
			CopyToBodyQue(self);
			SetNewParms();
			PutClientInServer();
		}
		else
		{
			localcmd("restart\n");
		}
	}
};

void() ClientKill = 
{
	bprint(self.netname);
	bprint(" plays the Roman fool\n");
	set_suicide_frame();
	self.modelindex = modelindex_player;
	self.frags = self.frags - WEAPON_ROCKET;
	respawn();
};

void(vector v) CheckSpawnPoint = 
{
	return 0;
};

entity() SelectSpawnPoint = 
{
	local entity spot;
	local entity thing;
	local float pcount;
	spot = find(world, classname, "testplayerstart");
	if (spot)
	{
		return spot;
	}
	if (coop)
	{
		lastspawn = find(lastspawn, classname, "info_player_coop");
		if (lastspawn == world)
		{
			lastspawn = find(lastspawn, classname, "info_player_start");
		}
		if (lastspawn != world)
		{
			return lastspawn;
		}
	}
	else
	{
		if (deathmatch)
		{
			spot = lastspawn;
			while (FIRE)
			{
				spot = find(spot, classname, "info_player_deathmatch");
				if (spot != world)
				{
					if (spot == lastspawn)
					{
						return lastspawn;
					}
					pcount = MSG_BROADCAST;
					thing = findradius(spot.origin, SVC_CDTRACK);
					while (thing)
					{
						if (thing.classname == "player")
						{
							pcount = pcount + FIRE;
						}
						thing = thing.chain;
					}
					if (pcount == MSG_BROADCAST)
					{
						lastspawn = spot;
						return spot;
					}
				}
			}
		}
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
	spot = SelectSpawnPoint();
	self.classname = "player";
	self.health = 100;
	self.takedamage = DAMAGE_AIM;
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_WALK;
	self.show_hostile = MSG_BROADCAST;
	self.max_health = 100;
	self.flags = FL_CLIENT;
	self.air_finished = time + STAT_TOTALMONSTERS;
	self.dmg = WEAPON_ROCKET;
	self.super_damage_finished = MSG_BROADCAST;
	self.radsuit_finished = MSG_BROADCAST;
	self.invisible_finished = MSG_BROADCAST;
	self.invincible_finished = MSG_BROADCAST;
	self.effects = MSG_BROADCAST;
	self.invincible_time = MSG_BROADCAST;
	self.wetsuit_finished = MSG_BROADCAST;
	self.empathy_finished = MSG_BROADCAST;
	self.items2 = MSG_BROADCAST;
	self.gravity = FIRE;
	DecodeLevelParms();
	W_SetCurrentAmmo();
	self.attack_finished = time;
	self.th_pain = player_pain;
	self.th_die = PlayerDie;
	self.deadflag = DEAD_NO;
	self.pausetime = MSG_BROADCAST;
	self.origin = spot.origin + '0 0 1';
	self.angles = spot.angles;
	self.fixangle = 1;
	self.velocity = VEC_ORIGIN;
	setmodel(self, "progs/playham.mdl");
	modelindex_hammer = self.modelindex;
	setmodel(self, "progs/eyes.mdl");
	modelindex_eyes = self.modelindex;
	setmodel(self, "progs/player.mdl");
	modelindex_player = self.modelindex;
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
	self.view_ofs = '0 0 22';
	player_stand1();
	if (deathmatch)
	{
		mg_skinset();
	}
	if (deathmatch || coop)
	{
		makevectors(self.angles);
		spawn_tfog(self.origin + v_forward * 20);
	}
	spawn_tdeath(self.origin, self);
	Chase_cam_level_start();
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
};

void() info_player_coop = 
{
};

void() NextLevel = 
{
	local entity o;
	o = find(world, classname, "trigger_changelevel");
	if (!o)
	{
		mapname = "start";
		o = spawn();
		o.map = mapname;
	}
	nextmap = o.map;
	gameover = 1;
	if (o.nextthink < time)
	{
		o.think = execute_changelevel;
		o.nextthink = time + 0.1;
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
		NextLevel();
		return;
	}
	if (fraglimit && self.frags >= fraglimit)
	{
		NextLevel();
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
		if (forward <= MSG_BROADCAST)
		{
			self.velocity = VEC_ORIGIN;
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
	self.button0 = MSG_BROADCAST;
	self.button1 = MSG_BROADCAST;
	self.button2 = MSG_BROADCAST;
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
	if (self.waterlevel >= WEAPON_ROCKET)
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
		if (self.swim_flag < time)
		{
			self.swim_flag = time + FIRE;
			if (random() < 0.5)
			{
				sound(self, CHAN_BODY, "misc/water1.wav", FIRE, ATTN_NORM);
			}
			else
			{
				sound(self, CHAN_BODY, "misc/water2.wav", FIRE, ATTN_NORM);
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
	self.button2 = MSG_BROADCAST;
	sound(self, CHAN_BODY, "player/plyrjmp8.wav", FIRE, ATTN_NORM);
	self.velocity_z = self.velocity_z + 270;
};

void() WaterMove = 
{
	if (self.movetype == MOVETYPE_NOCLIP)
	{
		return;
	}
	if (self.health < MSG_BROADCAST)
	{
		return;
	}
	if (self.waterlevel != IQ_HIGH)
	{
		if (self.air_finished < time)
		{
			sound(self, CHAN_VOICE, "player/gasp2.wav", FIRE, ATTN_NORM);
		}
		else
		{
			if (self.air_finished < time + TE_LIGHTNING3)
			{
				sound(self, CHAN_VOICE, "player/gasp1.wav", FIRE, ATTN_NORM);
			}
		}
		self.air_finished = time + STAT_TOTALMONSTERS;
		self.dmg = WEAPON_ROCKET;
	}
	else
	{
		if (self.air_finished < time)
		{
			if (self.pain_finished < time)
			{
				self.dmg = self.dmg + WEAPON_ROCKET;
				if (self.dmg > 15)
				{
					self.dmg = SVC_SETVIEWANGLES;
				}
				T_Damage(self, world, world, self.dmg);
				self.pain_finished = time + FIRE;
			}
		}
	}
	if (!(self.waterlevel))
	{
		if (self.flags & FL_INWATER)
		{
			sound(self, CHAN_BODY, "misc/outwater.wav", FIRE, ATTN_NORM);
			self.flags = self.flags - FL_INWATER;
		}
		return;
	}
	if (self.watertype == CONTENT_LAVA)
	{
		if (self.dmgtime < time)
		{
			if (self.radsuit_finished > time)
			{
				self.dmgtime = time + FIRE;
			}
			else
			{
				self.dmgtime = time + 0.2;
			}
			T_Damage(self, world, world, SVC_SETVIEWANGLES * self.waterlevel);
		}
	}
	else
	{
		if (self.watertype == CONTENT_SLIME)
		{
			if (self.dmgtime < time && self.radsuit_finished < time)
			{
				self.dmgtime = time + FIRE;
				T_Damage(self, world, world, WEAPON_SPIKES * self.waterlevel);
			}
		}
	}
	if (!(self.flags & FL_INWATER))
	{
		if (self.watertype == CONTENT_LAVA)
		{
			sound(self, CHAN_BODY, "player/inlava.wav", FIRE, ATTN_NORM);
		}
		if (self.watertype == CONTENT_WATER)
		{
			sound(self, CHAN_BODY, "player/inh2o.wav", FIRE, ATTN_NORM);
		}
		if (self.watertype == CONTENT_SLIME)
		{
			sound(self, CHAN_BODY, "player/slimbrn2.wav", FIRE, ATTN_NORM);
		}
		self.flags = self.flags + FL_INWATER;
		self.dmgtime = MSG_BROADCAST;
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
	start_z = start_z + WEAPON_BIG;
	v_forward_z = MSG_BROADCAST;
	normalize(v_forward);
	end = start + v_forward * 24;
	traceline(start, end, 1, self);
	if (trace_fraction < FIRE)
	{
		start_z = start_z + self.maxs_z - WEAPON_BIG;
		end = start + v_forward * 24;
		self.movedir = trace_plane_normal * -50;
		traceline(start, end, 1, self);
		if (trace_fraction == FIRE)
		{
			self.flags = self.flags | FL_WATERJUMP;
			self.velocity_z = 225;
			self.flags = self.flags - (self.flags & FL_JUMPRELEASED);
			self.teleport_time = time + WEAPON_ROCKET;
			return;
		}
	}
};

void() PlayerPreThink = 
{
	local float mspeed;
	local float aspeed;
	local float r;
	if (intermission_running)
	{
		earthquake_prethink();
		IntermissionThink();
		return;
	}
	if (self.view_ofs == VEC_ORIGIN)
	{
		return;
	}
	if (self.origin_z < -1300 && world.model == "maps/hipdm1.bsp" && self.health > MSG_BROADCAST)
	{
		self.deathtype = "falling";
		if (self.invincible_finished >= time)
		{
			self.invincible_finished = MSG_BROADCAST;
			self.items = self.items - (self.items & IT_INVULNERABILITY);
			self.invincible_time = MSG_BROADCAST;
			self.invincible_finished = MSG_BROADCAST;
			self.effects = self.effects - (self.effects & EF_DIMLIGHT);
		}
		T_Damage(self, self, world, self.health + 1000);
	}
	if (self.movetype == MOVETYPE_NOCLIP || self.movetype == MOVETYPE_FLY && self.netname != "Susan")
	{
		self.deathtype = "cheating";
		if (self.invincible_finished >= time)
		{
			self.invincible_finished = MSG_BROADCAST;
			self.items = self.items - (self.items & IT_INVULNERABILITY);
			self.invincible_time = MSG_BROADCAST;
			self.invincible_finished = MSG_BROADCAST;
			self.effects = self.effects - (self.effects & EF_DIMLIGHT);
		}
		T_Damage(self, self, world, self.health + 1000);
	}
	earthquake_prethink();
	makevectors(self.v_angle);
	CheckRules();
	WaterMove();
	if (self.wetsuit_finished > time)
	{
		if (self.waterlevel == WEAPON_ROCKET)
		{
			self.velocity = self.velocity * 1.25;
		}
		if (self.waterlevel == IQ_HIGH)
		{
			self.velocity = self.velocity * 1.5;
		}
		if (self.waterlevel >= WEAPON_ROCKET)
		{
			if (self.swim_flag < time)
			{
				self.swim_flag = time + TE_WIZSPIKE;
				sound(self, CHAN_BODY, "misc/wetsuit.wav", FIRE, ATTN_NORM);
			}
			else
			{
				if (fabs(self.swim_flag - time - TE_LIGHTNING2) < 0.040000)
				{
					DeathBubbles(FIRE);
				}
				else
				{
					if (fabs(self.swim_flag - time - 5.5) < 0.040000)
					{
						DeathBubbles(FIRE);
					}
					else
					{
						if (fabs(self.swim_flag - time - IQ_ULTIMATE) < 0.040000)
						{
							DeathBubbles(FIRE);
						}
					}
				}
			}
		}
	}
	if (self.waterlevel == WEAPON_ROCKET)
	{
		CheckWaterJump();
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
	if (self.button2)
	{
		PlayerJump();
	}
	else
	{
		self.flags = self.flags | FL_JUMPRELEASED;
	}
	if (time < self.pausetime)
	{
		self.velocity = VEC_ORIGIN;
	}
	if (time > self.attack_finished && self.currentammo == MSG_BROADCAST && self.weapon != IT_AXE && self.weapon != IT_MJOLNIR)
	{
		self.weapon = W_BestWeapon();
		W_SetCurrentAmmo();
	}
};

void() CheckPowerups = 
{
	if (self.health <= MSG_BROADCAST)
	{
		return;
	}
	if (self.invisible_finished)
	{
		if (self.invisible_sound < time)
		{
			sound(self, CHAN_AUTO, "items/inv3.wav", 0.5, ATTN_IDLE);
			self.invisible_sound = time + (random() * IQ_HIGH + FIRE);
		}
		if (self.invisible_finished < time + IQ_HIGH)
		{
			if (self.invisible_time == FIRE)
			{
				sprint(self, "Ring of Shadows magic is fading\n");
				stuffcmd(self, "bf\n");
				sound(self, CHAN_AUTO, "items/inv2.wav", FIRE, ATTN_NORM);
				self.invisible_time = time + FIRE;
			}
			if (self.invisible_time < time)
			{
				self.invisible_time = time + FIRE;
				stuffcmd(self, "bf\n");
			}
		}
		if (self.invisible_finished < time)
		{
			self.items = self.items - IT_INVISIBILITY;
			self.invisible_finished = MSG_BROADCAST;
			self.invisible_time = MSG_BROADCAST;
		}
		self.frame = MSG_BROADCAST;
		self.modelindex = modelindex_eyes;
	}
	else
	{
		if (self.weapon == IT_MJOLNIR)
		{
			self.modelindex = modelindex_hammer;
		}
		else
		{
			self.modelindex = modelindex_player;
		}
	}
	if (self.invincible_finished)
	{
		if (self.invincible_finished < time + IQ_HIGH)
		{
			if (self.invincible_time == FIRE)
			{
				sprint(self, "Protection is almost burned out\n");
				stuffcmd(self, "bf\n");
				sound(self, CHAN_AUTO, "items/protect2.wav", FIRE, ATTN_NORM);
				self.invincible_time = time + FIRE;
			}
			if (self.invincible_time < time)
			{
				self.invincible_time = time + FIRE;
				stuffcmd(self, "bf\n");
			}
		}
		if (self.invincible_finished < time)
		{
			self.items = self.items - IT_INVULNERABILITY;
			self.invincible_time = MSG_BROADCAST;
			self.invincible_finished = MSG_BROADCAST;
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
		if (self.super_damage_finished < time + IQ_HIGH)
		{
			if (self.super_time == FIRE)
			{
				sprint(self, "Quad Damage is wearing off\n");
				stuffcmd(self, "bf\n");
				sound(self, CHAN_AUTO, "items/damage2.wav", FIRE, ATTN_NORM);
				self.super_time = time + FIRE;
			}
			if (self.super_time < time)
			{
				self.super_time = time + FIRE;
				stuffcmd(self, "bf\n");
			}
		}
		if (self.super_damage_finished < time)
		{
			self.items = self.items - IT_QUAD;
			self.super_damage_finished = MSG_BROADCAST;
			self.super_time = MSG_BROADCAST;
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
		self.air_finished = time + STAT_TOTALMONSTERS;
		if (self.radsuit_finished < time + IQ_HIGH)
		{
			if (self.rad_time == FIRE)
			{
				sprint(self, "Air supply in Biosuit expiring\n");
				stuffcmd(self, "bf\n");
				sound(self, CHAN_AUTO, "items/suit2.wav", FIRE, ATTN_NORM);
				self.rad_time = time + FIRE;
			}
			if (self.rad_time < time)
			{
				self.rad_time = time + FIRE;
				stuffcmd(self, "bf\n");
			}
		}
		if (self.radsuit_finished < time)
		{
			self.items = self.items - IT_SUIT;
			self.rad_time = MSG_BROADCAST;
			self.radsuit_finished = MSG_BROADCAST;
		}
	}
	if (self.wetsuit_finished)
	{
		self.air_finished = time + STAT_TOTALMONSTERS;
		if (self.wetsuit_finished < time + IQ_HIGH)
		{
			if (self.wetsuit_time == FIRE)
			{
				sprint(self, "Air supply in Wetsuit is running out\n");
				stuffcmd(self, "bf\n");
				sound(self, CHAN_AUTO, "items/suit2.wav", FIRE, ATTN_NORM);
				self.wetsuit_time = time + FIRE;
			}
			if (self.wetsuit_time < time)
			{
				self.wetsuit_time = time + FIRE;
				stuffcmd(self, "bf\n");
			}
		}
		if (self.wetsuit_finished < time)
		{
			self.items2 = self.items2 - HIP_IT_WETSUIT;
			self.wetsuit_time = MSG_BROADCAST;
			self.wetsuit_finished = MSG_BROADCAST;
		}
	}
	if (self.empathy_finished)
	{
		if (self.empathy_finished < time + IQ_HIGH)
		{
			if (self.empathy_time == FIRE)
			{
				sprint(self, "Empathy Shields are running out\n");
				stuffcmd(self, "bf\n");
				sound(self, CHAN_AUTO, "items/suit2.wav", FIRE, ATTN_NORM);
				self.empathy_time = time + FIRE;
			}
			if (self.empathy_time < time)
			{
				self.empathy_time = time + FIRE;
				stuffcmd(self, "bf\n");
			}
		}
		if (self.empathy_finished < time)
		{
			self.items2 = self.items2 - HIP_IT_EMPATHY_SHIELDS;
			self.empathy_time = MSG_BROADCAST;
			self.empathy_finished = MSG_BROADCAST;
		}
		if (self.empathy_finished > time)
		{
			self.effects = self.effects | EF_DIMLIGHT;
		}
		else
		{
			self.effects = self.effects - (self.effects & EF_DIMLIGHT);
		}
	}
	CheckMOTD();
};

void() PlayerPostThink = 
{
	local float mspeed;
	local float aspeed;
	local float r;
	if (self.view_ofs == VEC_ORIGIN)
	{
		earthquake_postthink();
		return;
	}
	if (self.wetsuit_finished > time)
	{
		if (self.waterlevel == WEAPON_ROCKET)
		{
			self.velocity = self.velocity * 0.8;
		}
		if (self.waterlevel == IQ_HIGH)
		{
			self.velocity = self.velocity * 0.66;
		}
	}
	earthquake_postthink();
	if (self.deadflag)
	{
		return;
	}
	W_WeaponFrame();
	if (self.jump_flag < -300 && (self.flags & FL_ONGROUND) && self.health > MSG_BROADCAST)
	{
		if (self.watertype == CONTENT_WATER)
		{
			sound(self, CHAN_BODY, "player/h2ojump.wav", FIRE, ATTN_NORM);
		}
		else
		{
			if (self.jump_flag < -650)
			{
				T_Damage(self, world, world, IQ_ULTIMATE);
				sound(self, CHAN_VOICE, "player/land2.wav", FIRE, ATTN_NORM);
				self.deathtype = "falling";
			}
			else
			{
				sound(self, CHAN_VOICE, "player/land.wav", FIRE, ATTN_NORM);
			}
		}
		self.jump_flag = MSG_BROADCAST;
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
};

void() ClientDisconnect = 
{
	if (gameover)
	{
		return;
	}
	bprint(self.netname);
	bprint(" left the game with ");
	bprint(ftos(self.frags));
	bprint(" frags\n");
	sound(self, CHAN_BODY, "player/tornoff2.wav", FIRE, ATTN_NONE);
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
			attacker.owner.frags = attacker.owner.frags + FIRE;
			return;
		}
		if (attacker.classname == "teledeath2")
		{
			bprint("Satan's power deflects ");
			bprint(targ.netname);
			bprint("'s telefrag\n");
			targ.frags = targ.frags - FIRE;
			return;
		}
		if (attacker.classname == "fire")
		{
			bprint(targ.netname);
			if (attacker.fireowner.classname == "player")
			{
				if (attacker.fireowner != targ)
				{
					bprint(" was cremated by ");
					bprint(attacker.fireowner.netname);
					bprint("\n");
					attacker.fireowner.frags = attacker.fireowner.frags + FIRE;
					return;
				}
			}
			if (attacker.fireowner.classname == "monster_army")
			{
				bprint(" was cremated by a Nazi\n");
				return;
			}
			bprint(" was incinerated\n");
			targ.frags = targ.frags - FIRE;
			return;
		}
		if (attacker.classname == "player")
		{
			if (targ == attacker)
			{
				attacker.frags = attacker.frags - FIRE;
				bprint(targ.netname);
				if (targ.weapon == IT_LIGHTNING && targ.waterlevel > FIRE)
				{
					bprint(" mixed lasers and water!\n");
					return;
				}
				if (targ.weapon == IT_GRENADE_LAUNCHER)
				{
					bprint(" tries to put the pin back in\n");
				}
				else
				{
					if (targ.weapon == IT_ROCKET_LAUNCHER)
					{
						bprint(" couldn't use the V2 rocket\n");
					}
					else
					{
						bprint(" dies a lonely death\n");
					}
				}
				return;
			}
			else
			{
				attacker.frags = attacker.frags + FIRE;
				if (empathyused == FIRE)
				{
					bprint(targ.netname);
					if (random() < 0.5)
					{
						bprint(" shares ");
					}
					else
					{
						bprint(" feels ");
					}
					bprint(attacker.netname);
					bprint("'s pain\n");
					return;
				}
				if (targ.dmg_inflictor.classname == "proximity_grenade")
				{
					bprint(targ.netname);
					if (random() < 0.5)
					{
						bprint(" got too friendly with ");
					}
					else
					{
						bprint(" did the rhumba with ");
					}
					bprint(attacker.netname);
					bprint("'s bomb\n");
					return;
				}
				rnum = attacker.weapon;
				if (rnum == IT_AXE)
				{
					deathstring = " was ax-murdered by ";
					deathstring2 = "\n";
				}
				if (rnum == IT_SHOTGUN)
				{
					deathstring = " chewed on ";
					deathstring2 = "'s boomstick\n";
				}
				if (rnum == IT_SUPER_SHOTGUN)
				{
					deathstring = " ate 2 loads of ";
					deathstring2 = "'s buckshot\n";
				}
				if (rnum == IT_NAILGUN)
				{
					deathstring = " was nailed by ";
					deathstring2 = "\n";
				}
				if (rnum == IT_SUPER_NAILGUN)
				{
					deathstring = " was punctured by ";
					deathstring2 = "\n";
				}
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
				if (rnum == IT_LIGHTNING)
				{
					deathstring = " accepts ";
					if (attacker.waterlevel > FIRE)
					{
						deathstring2 = "'s discharge\n";
					}
					else
					{
						deathstring2 = "'s shaft\n";
					}
				}
				if (rnum == IT_LASER_CANNON)
				{
					if (random() < 0.5)
					{
						deathstring = " was toasted by ";
					}
					else
					{
						deathstring = " was radiated by ";
					}
					deathstring2 = "'s laser\n";
				}
				if (rnum == IT_MJOLNIR)
				{
					deathstring = " was slammed by ";
					deathstring2 = "'s hammer\n";
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
			targ.frags = targ.frags - FIRE;
			rnum = targ.watertype;
			bprint(targ.netname);
			if (attacker.deathtype)
			{
				bprint(" ");
				bprint(attacker.deathtype);
				bprint("\n");
				return;
			}
			if (rnum == CONTENT_WATER)
			{
				if (random() < 0.5)
				{
					bprint(" visits Neptune's Palace\n");
				}
				else
				{
					bprint(" couldn't breathe\n");
				}
				return;
			}
			else
			{
				if (rnum == CONTENT_SLIME)
				{
					if (random() < 0.5)
					{
						bprint(" was poisoned by Toxic Waste\n");
					}
					else
					{
						bprint(" drank a load of Toxic Waste\n");
					}
					return;
				}
				else
				{
					if (rnum == CONTENT_LAVA)
					{
						if (targ.health < -15)
						{
							bprint(" becomes most crispy\n");
							return;
						}
						if (random() < 0.5)
						{
							bprint(" sizzles to death\n");
						}
						else
						{
							bprint(" visits the Volcano God\n");
						}
						return;
					}
				}
			}
			if (attacker.flags & FL_MONSTER)
			{
				if (attacker.classname == "explo_grunt")
				{
					bprint(" stood to close to the broken flamethrower\n");
				}
				if (attacker.classname == "monster_nazi")
				{
					bprint(" failed against the Nazis\n");
				}
				if (attacker.classname == "monster_army")
				{
					bprint(" was a grunt's target\n");
				}
				if (attacker.classname == "monster_demon1")
				{
					bprint(" was impaled by a Moonbeast's talon\n");
				}
				if (attacker.classname == "monster_dog")
				{
					bprint(" was savaged by a Rottweiler\n");
				}
				if (attacker.classname == "monster_dragon")
				{
					bprint(" was fried by a Dragon\n");
				}
				if (attacker.classname == "monster_enforcer")
				{
					bprint(" was riddled by a blaster\n");
				}
				if (attacker.classname == "monster_fish")
				{
					bprint(" sleeps with the Rotfish\n");
				}
				if (attacker.classname == "monster_hell_knight")
				{
					bprint(" was slain by an Anti-Paladin\n");
				}
				if (attacker.classname == "monster_knight")
				{
					bprint(" was slain by a Crusader\n");
				}
				if (attacker.classname == "monster_ogre")
				{
					bprint("'s corpse will be eaten by the Ogres\n");
				}
				if (attacker.classname == "monster_ogre_marksman")
				{
					bprint("'s body is to be eaten by the Ogres\n");
				}
				if (attacker.classname == "monster_ogremarksman")
				{
					bprint("'s body is to be eaten by the Ogres\n");
				}
				if (attacker.classname == "monster_oldone")
				{
					bprint(" became one with Shub-Niggurath\n");
				}
				if (attacker.classname == "monster_shalrath")
				{
					bprint(" tasted the Spider-Demon's venom\n");
				}
				if (attacker.classname == "monster_voreget")
				{
					bprint(" was shot by a Spider-Cultist\n");
				}
				if (attacker.classname == "monster_shambler")
				{
					bprint("'s life was lost to a Shambler\n");
				}
				if (attacker.classname == "monster_tarbaby")
				{
					bprint(" was slimed by a Spawn\n");
				}
				if (attacker.classname == "monster_vomit")
				{
					bprint(" was vomited on by a Vomitus\n");
				}
				if (attacker.classname == "monster_wizard")
				{
					bprint("'s soul was chilled by a Scrag\n");
				}
				if (attacker.classname == "monster_wizboss")
				{
					bprint(" was fried by the Fire God's minion\n");
				}
				if (attacker.classname == "monster_zombie")
				{
					bprint("'s guts amuse the Restless Dead\n");
				}
				if (attacker.classname == "monster_zomking")
				{
					bprint("'s brains are splattered\n");
				}
				if (attacker.classname == "monster_zomgod")
				{
					bprint(" will rot in Hell\n");
				}
				if (attacker.classname == "monster_spider")
				{
					bprint(" was dessicated by a spider\n");
				}
				if (attacker.classname == "monster_axeman")
				{
					bprint(" was hacked to death by a maniac\n");
				}
				if (attacker.classname == "monster_boss")
				{
					bprint(" was pulverized by Chthon\n");
				}
				if (attacker.classname == "shub")
				{
					bprint(" became one with Shub-Niggurath\n");
				}
				if (attacker.classname == "monster_reddragon")
				{
					if (targ.biteme)
					{
						bprint(" was mangled by a Red Dragon\n");
					}
					else
					{
						bprint(" was fried by a Red Dragon\n");
					}
				}
				if (attacker.classname == "monster_bluedragon")
				{
					if (targ.biteme)
					{
						bprint(" was mangled by a Blue Dragon\n");
					}
					else
					{
						bprint(" was electrocuted by a Blue Dragon\n");
					}
				}
				if (attacker.classname == "monster_greendragon")
				{
					if (targ.biteme)
					{
						bprint(" was mangled by a Green Dragon\n");
					}
					else
					{
						bprint(" was liquidated by a Green Dragon\n");
					}
				}
				if (attacker.classname == "monster_nightshade")
				{
					bprint(" was slain by the Nightshade\n");
				}
				if (attacker.classname == "monster_golddragon")
				{
					if (targ.biteme)
					{
						bprint(" was mangled by a Gold Dragon\n");
					}
					else
					{
						bprint(" was pulverized by a Gold Dragon\n");
					}
				}
				if (attacker.classname == "monster_gremlin")
				{
					bprint(" was outsmarted by a Gremlin\n");
				}
				if (attacker.classname == "monster_scourge")
				{
					bprint(" was stung by a Centroid\n");
				}
				if (attacker.classname == "monster_armagon")
				{
					bprint(" was outgunned by Armagon\n");
				}
				return;
			}
			if (attacker.classname == "explo_box")
			{
				bprint(" blew up\n");
				return;
			}
			if (attacker.solid == SOLID_BSP && attacker != world)
			{
				bprint(" was ground into pulp\n");
				return;
			}
			if (targ.deathtype == "falling")
			{
				targ.deathtype = "";
				bprint(" fell from a great height\n");
				return;
			}
			if (targ.deathtype == "cheating")
			{
				targ.deathtype = "";
				bprint(" is a lousy lamer\n");
				return;
			}
			if (attacker.classname == "trap_shooter" || attacker.classname == "trap_spikeshooter")
			{
				bprint(" was spiked\n");
				return;
			}
			if (attacker.classname == "fireball")
			{
				bprint(" was hit by a meteor\n");
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


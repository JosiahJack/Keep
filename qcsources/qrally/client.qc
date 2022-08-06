void() info_intermission = 
{
};

void() SetChangeParms = 
{
	if (self.health <= 0)
	{
		SetNewParms();
		return;
	}
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
	parm10 = challenge;
};

void() SetNewParms = 
{
	if (world.model == "maps/start.bsp")
	{
		parm1 = IT_SUPER_NAILGUN;
	}
	else
	{
		parm1 = IT_NULL;
	}
	parm2 = 100;
	parm3 = 0;
	parm4 = 0;
	parm5 = 0;
	parm6 = 0;
	parm7 = 0;
	parm8 = 0;
	parm9 = 0;
	parm10 = challenge;
	if (!deathmatch && !coop)
	{
		parm16 = 0;
	}
};

void() DecodeLevelParms = 
{
	local entity ent;
	if (serverflags)
	{
		if (world.model == "maps/start.bsp")
		{
			SetNewParms();
		}
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
	self.start_challenge = parm10;
	challenge = parm10;
	if (!deathmatch && !coop)
	{
		self.speed = parm16;
	}
	if (challenge == -1)
	{
		rally_type_index = 3;
		hold_flag = 0;
		ent = find(world, classname, "race_starter");
		if (ent != world)
		{
			remove(ent);
		}
	}
	else
	{
		if (challenge >= 1)
		{
			if (challenge == 2)
			{
				lightstyle(0, "a");
			}
			if (world.model == "maps/cult.bsp")
			{
				ent = spawn();
				ent.think = CultIntroThink;
				ent.nextthink = time + 0.1;
				ent.owner = self;
				ent.last_idle = time;
			}
			else
			{
				if (self.gun != world)
				{
					remove(self.gun);
				}
				rally_type_index = 1;
				racing_type = RT_TIME_TRIAL;
				self.currentammo = TIMETRIAL_STARTTIME;
				RemoveAllWeaponItems();
			}
		}
	}
};

void() FindIntermission = 
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
	spot = find(world, classname, "rally_observer_cam");
	if (spot)
	{
		cyc = random() * 4;
		while (cyc > 1)
		{
			spot = find(spot, classname, "rally_observer_cam");
			if (!spot)
			{
				spot = find(spot, classname, "rally_observer_cam");
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
		if (challenge > 0)
		{
			if (world.model == "maps/start.bsp")
			{
				nextmap = "qrally01";
			}
			else
			{
				if (world.model == "maps/qrally01.bsp")
				{
					nextmap = "qrally02";
				}
				else
				{
					if (world.model == "maps/qrally02.bsp")
					{
						nextmap = "qrally03";
					}
					else
					{
						if (world.model == "maps/qrally03.bsp")
						{
							nextmap = "cult";
						}
						else
						{
							nextmap = "start";
						}
					}
				}
			}
			changelevel(nextmap);
		}
		else
		{
			if (world.nexttrack != "")
			{
				changelevel(world.nexttrack);
			}
			else
			{
				if (nextmap == "")
				{
					nextmap = mapname;
				}
				changelevel(nextmap);
			}
		}
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
		if (world.model == "maps/cult.bsp")
		{
			WriteByte(MSG_ALL, SVC_CDTRACK);
			WriteByte(MSG_ALL, 2);
			WriteByte(MSG_ALL, 3);
			WriteByte(MSG_ALL, SVC_FINALE);
			WriteString(MSG_ALL, "Now that the Duke Cult has been\nterminated, their attempts to revive\nChthon, and destroy the Quake Community\nwith their combined evil forces has been\navoided. Thanks to your supurb driving\nskills, and advanced weaponry, the Quake\nCommunity will now thrive, and\ncontinue to knock down any other attempt to\nknock Quake from it's throne.\n\nAs a reward for your efforts\nand achievements, you are awarded\nyour very own vehicle of mass\ndestruction. You may now go forth, and\nconquer the world, QuakeRally style!\n\nWho needs a Ferrari, when\nyou have QuakeRally!");
			challenge = 0;
			return;
		}
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

void() CalcPlayerStats = 
{
	local entity plyr;
	plyr = find(world, classname, "player");
	while (plyr != world)
	{
		plyr.netname = "Xx";
		plyr = find(plyr, classname, "player");
	}
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
	other = find(world, classname, "player");
	while (other != world)
	{
		other.view_ofs = '0 0 0';
		other.takedamage = DAMAGE_NO;
		other.solid = SOLID_NOT;
		other.movetype = MOVETYPE_NONE;
		other.modelindex = 0;
		other = find(other, classname, "player");
	}
	CalcPlayerStats();
	WriteByte(MSG_ALL, SVC_INTERMISSION);
};

void() changelevel_touch = 
{
	local entity pos;
	if (other.classname != "player")
	{
		return;
	}
	if (cvar("noexit"))
	{
		T_Damage(other, self, self, 50000);
		return;
	}
	if (world.model == "maps/start.bsp")
	{
		challenge = other.start_challenge = self.start_challenge;
		if (self.map == "qrally04")
		{
			centerprint(other, "Map not available, to be released\nat a later date\n");
			return;
		}
	}
	bprint(other.netname);
	bprint(" exited the level\n");
	nextmap = self.map;
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
	if (rally_type_index == 4 && self.cult_cars <= 0)
	{
		stuffcmd(self, "restart\n");
	}
	if (coop)
	{
		setspawnparms(self);
		PutClientInServer();
	}
	else
	{
		SetNewParms();
		PutClientInServer();
	}
};

void() ClientKill = 
{
	bprint(self.netname);
	bprint(" suicides\n");
	set_suicide_frame();
	self.modelindex = modelindex_player;
	if (rally_type_index >= 3 && rally_type_index != 4)
	{
		self.frags = self.frags - 2;
	}
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
	if (deathmatch == 100)
	{
		spot = find(world, classname, "info_player_start");
		if (spot)
		{
			return spot;
		}
	}
	if (!hold_flag && self.last_marker_num > 0)
	{
		spot = self.last_marker;
		if (spot != world)
		{
			return spot;
		}
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

float() area_clear = 
{
	local entity trav;
	trav = findradius(self.origin, 64);
	while (trav != world)
	{
		if (trav != self && !(trav.solid == SOLID_NOT || trav.solid == SOLID_TRIGGER))
		{
			return 0;
		}
		trav = trav.chain;
	}
	return 1;
};

void() PutClientInServer = 
{
	local entity spot;
	local entity plyr;
	local vector VehBoxMin;
	local vector VehBoxMax;
	local vector plyrBoxMin;
	local vector plyrBoxMax;
	local float ftemp;
	self.classname = "player";
	self.health = 100;
	self.takedamage = DAMAGE_AIM;
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_WALK;
	self.show_hostile = 0;
	self.max_health = 100;
	self.flags = FL_CLIENT + FL_ONGROUND;
	self.air_finished = time + 12;
	self.dmg = 2;
	self.super_damage_finished = 0;
	self.radsuit_finished = 0;
	self.invisible_finished = 0;
	self.invincible_finished = 0;
	self.effects = 0;
	self.invincible_time = 0;
	if (self.mine_attached != world)
	{
		remove(self.mine_attached);
		self.mine_attached = world;
	}
	DecodeLevelParms();
	if (rally_type_index >= 2)
	{
		self.ammo_shells = 0;
		self.items = self.items | IT_SUPER_NAILGUN;
		if (rally_type_index == 4)
		{
			self.ammo_nails = 150;
		}
		else
		{
			self.ammo_nails = 50;
		}
		self.weapon = IT_SUPER_NAILGUN;
	}
	self.attack_finished = time;
	self.th_die = PlayerDie;
	self.deadflag = DEAD_NO;
	self.pausetime = 0;
	spot = SelectSpawnPoint();
	self.spawn_time = time;
	makevectors(spot.angles);
	setorigin(self, spot.origin + '0 0 16');
	ftemp = 0;
	while (!area_clear() && ftemp < 5)
	{
		setorigin(self, self.origin + v_forward * 48);
		ftemp = ftemp + 1;
	}
	if (ftemp == 5)
	{
		setorigin(self, spot.origin + '0 0 16');
	}
	self.angles = spot.angles;
	self.fixangle = 1;
	self.velocity = '0 0 0';
	setsize(self, VEH_MIN, VEH_MAX);
	self.view_ofs = '0 0 14';
	setmodel(self, "models/null.mdl");
	self.use_surface_angle = 1;
	if (self.veh_tail == world)
	{
		CreateVehicleEntities();
		if (!(self.speed & CHSCAM_ON))
		{
			self.speed = self.speed + CHSCAM_ON;
		}
		Start_chase_cam(self);
		if (current_leader != world)
		{
			plyr = current_leader;
			while (plyr.behind != world)
			{
				plyr = plyr.behind;
			}
			plyr.behind = self;
			self.ahead = plyr;
			self.behind = world;
			self.last_lap_time = time;
			self.racing_flags = self.racing_flags | QR_START_READY;
			self.racing_flags = self.racing_flags - (self.racing_flags & QR_OBSERVER);
		}
	}
	else
	{
		droptofloor();
		makevectors(spot.angles);
		setorigin(self.veh_tail, self.origin - v_forward * TAIL_DIST);
		self.veh_body.angles = '0 0 0';
		self.veh_body.avelocity = '0 0 0';
		self.veh_body.roll_velocity = '0 0 0';
		self.veh_body.veh_dir = '0 0 0';
		self.veh_tail.veh_dir = v_forward;
		self.oldorigin = self.origin;
		self.last_velocity = '0 0 0';
		self.body_roll = '0 0 0';
		plyr_angles_y = self.angles_y;
		self.racing_flags = self.racing_flags - (self.racing_flags & QR_JUST_LANDED);
		self.racing_flags = self.racing_flags | QR_RESPAWN_FLAG;
		setorigin(self.chasecam, self.origin);
		if (self.cam != CAM_INCAR)
		{
			msg_entity = self;
			WriteByte(MSG_ONE, SVC_SETVIEWANGLES);
			if (self.cam == CAM_CHASECLOSE)
			{
				WriteAngle(MSG_ONE, 15);
			}
			else
			{
				if (self.cam == CAM_CHASEFAR)
				{
					WriteAngle(MSG_ONE, 35);
				}
			}
			WriteAngle(MSG_ONE, self.angles_y);
			WriteAngle(MSG_ONE, self.angles_z);
		}
	}
	self.veh_body.last_velocity = '0 0 0';
	W_SetCurrentAmmo();
	self.health = 100;
	self.armorvalue = 0;
	self.last_engine_ratio = -1;
	self.yaw_speed = 0;
	if (!(self.racing_flags & QR_RACING))
	{
		self.last_lap = 0;
		self.fastest_lap = 999999;
		self.last_lap_time = 0;
		self.last_marker_num = 0;
		self.last_marker = world;
		self.racing_flags = self.racing_flags | QR_RACING;
	}
	if (deathmatch || coop)
	{
		makevectors(self.angles);
		spawn_tfog(self.origin + v_forward * 20);
	}
	spawn_tdeath(self.origin, self);
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
				serverflags = serverflags + 1;
			}
			else
			{
				if (!(serverflags & 2))
				{
					mapname = "e2m1";
					serverflags = serverflags + 2;
				}
				else
				{
					if (!(serverflags & 4))
					{
						mapname = "e3m1";
						serverflags = serverflags + 4;
					}
					else
					{
						if (!(serverflags & 8))
						{
							mapname = "e4m1";
							serverflags = serverflags + 8;
						}
						else
						{
							mapname = "start";
							serverflags = serverflags - 15;
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
		o = find(world, classname, "trigger_changelevel");
		if (!o)
		{
			if (!cvar("samelevel"))
			{
				mapname = "start";
			}
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

void() CheckRules = 
{
	local float timelimit;
	local float fraglimit;
	if (gameover)
	{
		return;
	}
	if (rally_type_index == 4)
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
	if (rally_type_index == 1 && racing_type == RT_TIME_TRIAL && (self.racing_flags & QR_OUT_OF_TIME))
	{
		stuffcmd(self, "restart\n");
	}
	else
	{
		respawn();
	}
};

void() PlayerJump = 
{
	local vector start;
	local vector end;
	if (self.flags & FL_WATERJUMP)
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
		if (self.swim_flag < time)
		{
			self.swim_flag = time + 1;
			if (random() < 0.5)
			{
				sound(self, CHAN_BODY, "misc/water1.wav", 1, ATTN_NORM);
			}
			else
			{
				sound(self, CHAN_BODY, "misc/water2.wav", 1, ATTN_NORM);
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
	sound(self, CHAN_BODY, "player/plyrjmp8.wav", 1, ATTN_NORM);
	self.velocity_z = self.velocity_z + 100;
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
	if (self.waterlevel != 3)
	{
		if (self.air_finished < time)
		{
			sound(self, CHAN_VOICE, "player/gasp2.wav", 1, ATTN_NORM);
		}
		else
		{
			if (self.air_finished < time + 9)
			{
				sound(self, CHAN_VOICE, "player/gasp1.wav", 1, ATTN_NORM);
			}
		}
		self.air_finished = time + 12;
		self.dmg = 2;
	}
	if (!(self.waterlevel))
	{
		if (self.flags & FL_INWATER)
		{
			sound(self, CHAN_BODY, "misc/outwater.wav", 1, ATTN_NORM);
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
				self.dmgtime = time + 1;
			}
			else
			{
				self.dmgtime = time + 0.2;
			}
			T_Damage(self, world, world, 20 * self.waterlevel);
		}
	}
	else
	{
		if (self.watertype == CONTENT_SLIME)
		{
			if (self.dmgtime < time && self.radsuit_finished < time)
			{
				self.dmgtime = time + 1;
				T_Damage(self, world, world, 8 * self.waterlevel);
			}
		}
	}
	if (!(self.flags & FL_INWATER))
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
	local float r;
	local vector v1;
	local vector v2;
	local entity water_think;
	if (self.racing_flags & QR_OBSERVER)
	{
		return;
	}
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
	if (self.health > 0 && self.waterlevel >= 2)
	{
		stuffcmd(self, "v_cshift 0 0 64 255\n");
		respawn();
		sound(self, CHAN_AUTO, "player/h2ojump.wav", 1, 1);
		water_think = spawn();
		water_think.owner = self;
		water_think.speed = 255;
		water_think.think = WaterScreenThink;
		water_think.nextthink = time + 1;
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
	if (time < self.pausetime)
	{
		self.velocity = '0 0 0';
	}
	VehiclePreThink();
};

void() CheckPowerups = 
{
	if (self.health <= 0)
	{
		return;
	}
	if (self.invisible_finished)
	{
		if (self.invisible_sound < time)
		{
			sound(self, CHAN_AUTO, "items/inv3.wav", 0.5, ATTN_IDLE);
			self.invisible_sound = time + (random() * 3 + 1);
		}
		if (self.invisible_finished < time + 3)
		{
			if (self.invisible_time == 1)
			{
				sprint(self, "Ring of Shadows magic is fading\n");
				stuffcmd(self, "bf\n");
				sound(self, CHAN_AUTO, "items/inv2.wav", 1, ATTN_NORM);
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
			self.items = self.items - IT_INVISIBILITY;
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
				sound(self, CHAN_AUTO, "items/protect2.wav", 1, ATTN_NORM);
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
				sprint(self, "Quad Damage is wearing off\n");
				stuffcmd(self, "bf\n");
				sound(self, CHAN_AUTO, "items/damage2.wav", 1, ATTN_NORM);
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
				sound(self, CHAN_AUTO, "items/suit2.wav", 1, ATTN_NORM);
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
};

void() PlayerPostThink = 
{
	local float mspeed;
	local float aspeed;
	local float r;
	local float zvel;
	local entity ent;
	local entity mine;
	if (self.racing_flags & QR_OBSERVER)
	{
		if (self.model != "")
		{
			setmodel(self, "");
		}
		ImpulseCommands();
		return;
	}
	if (rally_type_index == 4 && (self.flags & FL_GODMODE))
	{
		sprint(self, "Cheats never prosper..");
		self.health = 1;
	}
	aspeed = vlen(self.last_velocity);
	mspeed = vlen(self.velocity);
	if (mspeed < aspeed)
	{
		if (aspeed > MAX_SPEED / 3 && aspeed - mspeed > 200)
		{
			ent = findradius(self.origin, 196);
			while (ent != world && ent.classname != "player" && ent.classname != "rally_bot")
			{
				ent = ent.chain;
			}
			if (ent != world)
			{
				zvel = self.velocity_z;
				self.velocity = self.last_velocity * 0.9;
				self.velocity_z = zvel;
			}
		}
	}
	if (hold_flag)
	{
		setorigin(self, self.oldorigin);
	}
	if (self.classname == "player")
	{
		self.angles_y = plyr_angles_y;
	}
	if (self.view_ofs == '0 0 0')
	{
		return;
	}
	if (self.deadflag)
	{
		return;
	}
	W_WeaponFrame();
	if (!(self.flags & FL_ONGROUND))
	{
		self.jump_flag = self.velocity_z;
	}
	CheckPowerups();
	MoveVehicle();
};

void() ClientConnect = 
{
	local entity spot;
	local vector vec;
	local float make_observer;
	make_observer = 0;
	if (rally_type_index < 3)
	{
		if (current_leader != world)
		{
			make_observer = 1;
		}
	}
	if (make_observer)
	{
		self.racing_flags = self.racing_flags | QR_OBSERVER;
	}
	bprint(self.netname);
	bprint(" entered the game\n");
	self.veh_tail = world;
	if (intermission_running)
	{
		ExitIntermission();
	}
};

void() RestartMap = 
{
	changelevel(mapname);
};

void() ClientDisconnect = 
{
	local entity plyr;
	local entity restartent;
	local float pcount;
	if (gameover)
	{
		return;
	}
	DestroyVehicleParts();
	if (rally_type_index < 3 && current_leader != world)
	{
		if (cvar("deathmatch") && self.ahead == world && self.behind == world)
		{
			restartent = spawn();
			restartent.think = RestartMap;
			restartent.nextthink = time + 0.2;
			current_leader = world;
		}
		else
		{
			if (self.ahead != world)
			{
				if (self.behind != world)
				{
					self.ahead.behind = self.behind;
					self.behind.ahead = self.ahead;
				}
				else
				{
					self.ahead.behind = world;
				}
			}
			else
			{
				if (self.behind != world)
				{
					self.behind.ahead = world;
					current_leader = self.behind;
				}
				else
				{
					current_leader = world;
				}
			}
		}
	}
	else
	{
		pcount = 0;
		plyr = world;
		while ((plyr = find(plyr, classname, "player")) != world)
		{
			if (plyr != self)
			{
				pcount = pcount + 1;
			}
		}
		if (!pcount)
		{
			restartent = spawn();
			restartent.think = RestartMap;
			restartent.nextthink = time + 0.2;
			current_leader = world;
		}
	}
	bprint(self.netname);
	bprint(" left the game with ");
	bprint(ftos(self.frags));
	bprint(" frags\n");
	sound(self, CHAN_BODY, "player/tornoff2.wav", 1, ATTN_NONE);
	set_suicide_frame();
	if (rally_type_index <= 2 && starter != world)
	{
		plyr = find(world, classname, "player");
		while (plyr != world)
		{
			if (plyr != self && !(plyr.racing_flags & QR_START_READY) && !(plyr.racing_flags & QR_OBSERVER) && !(plyr.deadflag))
			{
				return;
			}
			plyr = find(plyr, classname, "player");
		}
		starter.racing_flags = starter.racing_flags - (starter.racing_flags & QR_NOT_RACING);
		starter.last_lap = 3;
	}
};

void(entity targ, entity attacker) ClientObituary = 
{
	local float rnum;
	local float rnd;
	local string deathstring;
	local string deathstring2;
	rnum = random();
	if (rally_type_index == 4)
	{
		return;
	}
	if (rally_type_index < 2)
	{
		return;
	}
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
		if (attacker.classname == "player")
		{
			if (targ == attacker)
			{
				if (rally_type_index >= 3)
				{
					attacker.frags = attacker.frags - 1;
				}
				bprint(targ.netname);
				if (targ.weapon == 64 && targ.waterlevel > 1)
				{
					bprint(" discharges into the water.\n");
					return;
				}
				bprint(" becomes bored with life\n");
				return;
			}
			else
			{
				targ.deathtype = "car_collision";
				if ("car_collision")
				{
					attacker.frags = attacker.frags + 1;
					rnum = random() * 3;
					if (rnum < 1)
					{
						bprint(attacker.netname);
						bprint(" demolished ");
						bprint(targ.netname);
					}
					else
					{
						if (rnum < 2)
						{
							bprint(targ.netname);
							bprint(" was rammed by ");
							bprint(attacker.netname);
						}
						else
						{
							bprint(targ.netname);
							bprint(" suffered a fatal collision with ");
							bprint(attacker.netname);
						}
					}
					bprint("\n");
					targ.deathtype = "";
				}
				else
				{
					attacker.frags = attacker.frags + 1;
					rnum = attacker.weapon;
					if (rnum == IT_ROOBAR)
					{
						deathstring = " was demolished by ";
						deathstring2 = "\n";
					}
					if (rnum == IT_SUPER_NAILGUN)
					{
						deathstring = " was smothered in ";
						deathstring2 = "'s nails\n";
					}
					if (rnum == IT_MINE_LAUNCHER)
					{
						deathstring = " was destroyed by ";
						deathstring2 = "'s mine\n";
					}
					if (rnum == IT_DETONATOR)
					{
						deathstring = " couldn't shake ";
						deathstring2 = "'s detonator\n";
					}
					if (rnum == IT_LASER_GUN)
					{
						deathstring = " was cooked by ";
						deathstring2 = "'s lasers\n";
					}
					if (rnum == IT_ROCKET_LAUNCHER)
					{
						deathstring = " rides ";
						deathstring2 = "'s rocket\n";
					}
					bprint(targ.netname);
					bprint(deathstring);
					bprint(attacker.netname);
					bprint(deathstring2);
				}
			}
			return;
		}
		else
		{
			targ.frags = targ.frags - 1;
			bprint(targ.netname);
			if (attacker.flags & FL_MONSTER)
			{
				bprint(" died\n");
				return;
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
			rnum = targ.watertype;
			if (rnum == -3)
			{
				rnd = random();
				if (rnd < 0.4)
				{
					bprint(" sleeps with the fishes\n");
				}
				else
				{
					if (rnd < 0.7)
					{
						bprint(" sucks it down\n");
					}
					else
					{
						bprint("'s car exploded underwater\n");
					}
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
			if (targ.deathtype == "falling")
			{
				targ.deathtype = "";
				bprint(" fell to his death\n");
				return;
			}
			if (targ.deathtype == "rolled_car")
			{
				targ.deathtype = "";
				rnd = random() * 3;
				if (rnd < 1)
				{
					bprint(" lost control\n");
				}
				else
				{
					if (rnd <= 2)
					{
						bprint(" crashed and burnt\n");
					}
					else
					{
						if (rnd <= 3)
						{
							bprint(" kissed the dirt\n");
						}
					}
				}
				return;
			}
			else
			{
				if (targ.deathtype == "repulsor_feedback")
				{
					targ.deathtype = "";
					bprint("'s repulsor overloaded\n");
					centerprint(targ, "Repsulor Feedback");
					return;
				}
			}
			bprint(" died\n");
		}
	}
};


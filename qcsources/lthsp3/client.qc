void() info_intermission = 
{
};

void() SetChangeParms = 
{
	self.items = self.items - (self.items & (IT_KEY1 | IT_KEY2 | IT_INVISIBILITY | IT_INVULNERABILITY | IT_SUIT | IT_QUAD));
	if (self.health > MAX_CELLS)
	{
		self.health = MAX_CELLS;
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
	parm9 = self.armortype * MAX_CELLS;
};

void() SetNewParms = 
{
	parm1 = IT_SHOTGUN | IT_AXE;
	parm2 = MAX_CELLS;
	parm3 = MSG_BROADCAST;
	parm4 = 25;
	parm5 = MSG_BROADCAST;
	parm6 = MSG_BROADCAST;
	parm6 = MSG_BROADCAST;
	parm8 = AS_STRAIGHT;
	parm9 = MSG_BROADCAST;
};

void() DecodeLevelParms = 
{
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
};

entity() FindIntermission = 
{
	local entity spot;
	local float cyc;
	spot = find(world, classname, "info_intermission");
	if (spot)
	{
		cyc = random() * AS_MISSILE;
		while (cyc > AS_STRAIGHT)
		{
			spot = find(spot, classname, "info_intermission");
			if (!spot)
			{
				spot = find(spot, classname, "info_intermission");
			}
			cyc = cyc - AS_STRAIGHT;
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
	intermission_exittime = time + AS_STRAIGHT;
	intermission_running = intermission_running + AS_STRAIGHT;
	if (intermission_running == AS_SLIDING)
	{
		if (world.model == "maps/e1m7.bsp")
		{
			WriteByte(MSG_ALL, SVC_CDTRACK);
			WriteByte(MSG_ALL, AS_SLIDING);
			WriteByte(MSG_ALL, AS_MELEE);
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
				WriteByte(MSG_ALL, AS_SLIDING);
				WriteByte(MSG_ALL, AS_MELEE);
				WriteByte(MSG_ALL, SVC_FINALE);
				WriteString(MSG_ALL, "The Rune of Black Magic throbs evilly in\nyour hand and whispers dark thoughts\ninto your brain. You learn the inmost\nlore of the Hell-Mother; Shub-Niggurath!\nYou now know that she is behind all the\nterrible plotting which has led to so\nmuch death and horror. But she is not\ninviolate! Armed with this Rune, you\nrealize that once all four Runes are\ncombined, the gate to Shub-Niggurath's\nPit will open, and you can face the\nWitch-Goddess herself in her frightful\notherworld cathedral.");
				return;
			}
			else
			{
				if (world.model == "maps/e3m6.bsp")
				{
					WriteByte(MSG_ALL, SVC_CDTRACK);
					WriteByte(MSG_ALL, AS_SLIDING);
					WriteByte(MSG_ALL, AS_MELEE);
					WriteByte(MSG_ALL, SVC_FINALE);
					WriteString(MSG_ALL, "The charred viscera of diabolic horrors\nbubble viscously as you seize the Rune\nof Hell Magic. Its heat scorches your\nhand, and its terrible secrets blight\nyour mind. Gathering the shreds of your\ncourage, you shake the devil's shackles\nfrom your soul, and become ever more\nhard and determined to destroy the\nhideous creatures whose mere existence\nthreatens the souls and psyches of all\nthe population of Earth.");
					return;
				}
				else
				{
					if (world.model == "maps/e4m7.bsp")
					{
						WriteByte(MSG_ALL, SVC_CDTRACK);
						WriteByte(MSG_ALL, AS_SLIDING);
						WriteByte(MSG_ALL, AS_MELEE);
						WriteByte(MSG_ALL, SVC_FINALE);
						WriteString(MSG_ALL, "Despite the awful might of the Elder\nWorld, you have achieved the Rune of\nElder Magic, capstone of all types of\narcane wisdom. Beyond good and evil,\nbeyond life and death, the Rune\npulsates, heavy with import. Patient and\npotent, the Elder Being Shub-Niggurath\nweaves her dire plans to clear off all\nlife from the Earth, and bring her own\nfoul offspring to our world! For all the\ndwellers in these nightmare dimensions\nare her descendants! Once all Runes of\nmagic power are united, the energy\nbehind them will blast open the Gateway\nto Shub-Niggurath, and you can travel\nthere to foil the Hell-Mother's plots\nin person.");
						return;
					}
				}
			}
		}
		GotoNextMap();
	}
	if (intermission_running == AS_MELEE)
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
	intermission_running = AS_STRAIGHT;
	if (deathmatch)
	{
		intermission_exittime = time + TE_LIGHTNING1;
	}
	else
	{
		intermission_exittime = time + AS_SLIDING;
	}
	WriteByte(MSG_ALL, SVC_CDTRACK);
	WriteByte(MSG_ALL, AS_MELEE);
	WriteByte(MSG_ALL, AS_MELEE);
	pos = FindIntermission();
	other = find(world, classname, "player");
	while (other != world)
	{
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
	if (cvar("noexit"))
	{
		T_Damage(other, self, self, 50000);
		return;
	}
	bprint(other.netname);
	bprint(" exited the level\n");
	nextmap = self.map;
	SUB_UseTargets();
	if (self.spawnflags & AS_STRAIGHT && deathmatch == MSG_BROADCAST)
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
	bprint(" suicides\n");
	set_suicide_frame();
	self.modelindex = modelindex_player;
	self.frags = self.frags - AS_SLIDING;
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
			lastspawn = find(lastspawn, classname, "info_player_deathmatch");
			if (lastspawn == world)
			{
				lastspawn = find(lastspawn, classname, "info_player_deathmatch");
			}
			if (lastspawn != world)
			{
				return lastspawn;
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
	self.classname = "player";
	self.health = MAX_CELLS;
	self.takedamage = DAMAGE_AIM;
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_WALK;
	self.show_hostile = MSG_BROADCAST;
	self.max_health = MAX_CELLS;
	self.flags = FL_CLIENT;
	self.air_finished = time + 12;
	self.dmg = AS_SLIDING;
	self.super_damage_finished = MSG_BROADCAST;
	self.radsuit_finished = MSG_BROADCAST;
	self.invisible_finished = MSG_BROADCAST;
	self.invincible_finished = MSG_BROADCAST;
	self.effects = MSG_BROADCAST;
	self.invincible_time = MSG_BROADCAST;
	DecodeLevelParms();
	W_SetCurrentAmmo(self);
	self.attack_finished = time;
	self.th_pain = player_pain;
	self.th_die = PlayerDie;
	self.deadflag = DEAD_NO;
	self.pausetime = MSG_BROADCAST;
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

void(entity c) PrintClientScore = 
{
	if (c.frags > -10 && c.frags < MSG_BROADCAST)
	{
		bprint(" ");
	}
	else
	{
		if (c.frags >= MSG_BROADCAST)
		{
			if (c.frags < MAX_CELLS)
			{
				bprint(" ");
			}
			if (c.frags < TE_LAVASPLASH)
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
	if (self.waterlevel >= AS_SLIDING)
	{
		if (self.watertype == CONTENT_WATER)
		{
			self.velocity_z = MAX_CELLS;
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
			self.swim_flag = time + AS_STRAIGHT;
			if (random() < 0.5)
			{
				sound(self, CHAN_BODY, "misc/water1.wav", AS_STRAIGHT, ATTN_NORM);
			}
			else
			{
				sound(self, CHAN_BODY, "misc/water2.wav", AS_STRAIGHT, ATTN_NORM);
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
	sound(self, CHAN_BODY, "player/plyrjmp8.wav", AS_STRAIGHT, ATTN_NORM);
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
	if (self.waterlevel != AS_MELEE)
	{
		if (self.air_finished < time)
		{
			sound(self, CHAN_VOICE, "player/gasp2.wav", AS_STRAIGHT, ATTN_NORM);
		}
		else
		{
			if (self.air_finished < time + TE_LIGHTNING3)
			{
				sound(self, CHAN_VOICE, "player/gasp1.wav", AS_STRAIGHT, ATTN_NORM);
			}
		}
		self.air_finished = time + 12;
		self.dmg = AS_SLIDING;
	}
	else
	{
		if (self.air_finished < time)
		{
			if (self.pain_finished < time)
			{
				self.dmg = self.dmg + AS_SLIDING;
				if (self.dmg > 15)
				{
					self.dmg = TE_LAVASPLASH;
				}
				T_Damage(self, world, world, self.dmg);
				self.pain_finished = time + AS_STRAIGHT;
			}
		}
	}
	if (!(self.waterlevel))
	{
		if (self.flags & FL_INWATER)
		{
			sound(self, CHAN_BODY, "misc/outwater.wav", AS_STRAIGHT, ATTN_NORM);
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
				self.dmgtime = time + AS_STRAIGHT;
			}
			else
			{
				self.dmgtime = time + 0.2;
			}
			T_Damage(self, world, world, TE_LAVASPLASH * self.waterlevel);
		}
	}
	else
	{
		if (self.watertype == CONTENT_SLIME)
		{
			if (self.dmgtime < time && self.radsuit_finished < time)
			{
				self.dmgtime = time + AS_STRAIGHT;
				T_Damage(self, world, world, AS_MISSILE * self.waterlevel);
			}
		}
	}
	if (!(self.flags & FL_INWATER))
	{
		if (self.watertype == CONTENT_LAVA)
		{
			sound(self, CHAN_BODY, "player/inlava.wav", AS_STRAIGHT, ATTN_NORM);
		}
		if (self.watertype == CONTENT_WATER)
		{
			sound(self, CHAN_BODY, "player/inh2o.wav", AS_STRAIGHT, ATTN_NORM);
		}
		if (self.watertype == CONTENT_SLIME)
		{
			sound(self, CHAN_BODY, "player/slimbrn2.wav", AS_STRAIGHT, ATTN_NORM);
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
	start_z = start_z + EF_DIMLIGHT;
	v_forward_z = MSG_BROADCAST;
	normalize(v_forward);
	end = start + v_forward * 24;
	traceline(start, end, 1, self);
	if (trace_fraction < AS_STRAIGHT)
	{
		start_z = start_z + self.maxs_z - EF_DIMLIGHT;
		end = start + v_forward * 24;
		self.movedir = trace_plane_normal * -50;
		traceline(start, end, 1, self);
		if (trace_fraction == AS_STRAIGHT)
		{
			self.flags = self.flags | FL_WATERJUMP;
			self.velocity_z = 225;
			self.flags = self.flags - (self.flags & FL_JUMPRELEASED);
			self.teleport_time = time + AS_SLIDING;
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
		IntermissionThink();
		return;
	}
	if (self.view_ofs == VEC_ORIGIN)
	{
		return;
	}
	makevectors(self.v_angle);
	CheckRules();
	WaterMove();
	if (self.waterlevel == AS_SLIDING)
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
			self.invisible_sound = time + (random() * AS_MELEE + AS_STRAIGHT);
		}
		if (self.invisible_finished < time + AS_MELEE)
		{
			if (self.invisible_time == AS_STRAIGHT)
			{
				sprint(self, "Ring of Shadows magic is fading\n");
				stuffcmd(self, "bf\n");
				sound(self, CHAN_AUTO, "items/inv2.wav", AS_STRAIGHT, ATTN_NORM);
				self.invisible_time = time + AS_STRAIGHT;
			}
			if (self.invisible_time < time)
			{
				self.invisible_time = time + AS_STRAIGHT;
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
		self.modelindex = modelindex_player;
	}
	if (self.invincible_finished)
	{
		if (self.invincible_finished < time + AS_MELEE)
		{
			if (self.invincible_time == AS_STRAIGHT)
			{
				sprint(self, "Protection is almost burned out\n");
				stuffcmd(self, "bf\n");
				sound(self, CHAN_AUTO, "items/protect2.wav", AS_STRAIGHT, ATTN_NORM);
				self.invincible_time = time + AS_STRAIGHT;
			}
			if (self.invincible_time < time)
			{
				self.invincible_time = time + AS_STRAIGHT;
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
		if (self.super_damage_finished < time + AS_MELEE)
		{
			if (self.super_time == AS_STRAIGHT)
			{
				sprint(self, "Quad Damage is wearing off\n");
				stuffcmd(self, "bf\n");
				sound(self, CHAN_AUTO, "items/damage2.wav", AS_STRAIGHT, ATTN_NORM);
				self.super_time = time + AS_STRAIGHT;
			}
			if (self.super_time < time)
			{
				self.super_time = time + AS_STRAIGHT;
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
		self.air_finished = time + 12;
		if (self.radsuit_finished < time + AS_MELEE)
		{
			if (self.rad_time == AS_STRAIGHT)
			{
				sprint(self, "Air supply in NBC Suit expiring\n");
				stuffcmd(self, "bf\n");
				sound(self, CHAN_AUTO, "items/suit2.wav", AS_STRAIGHT, ATTN_NORM);
				self.rad_time = time + AS_STRAIGHT;
			}
			if (self.rad_time < time)
			{
				self.rad_time = time + AS_STRAIGHT;
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
};

void() PlayerPostThink = 
{
	local float mspeed;
	local float aspeed;
	local float r;
	if (self.view_ofs == VEC_ORIGIN)
	{
		return;
	}
	if (self.deadflag)
	{
		return;
	}
	W_WeaponFrame();
	if (self.jump_flag < -300 && (self.flags & FL_ONGROUND) && self.health > MSG_BROADCAST)
	{
		if (self.watertype == CONTENT_WATER)
		{
			sound(self, CHAN_BODY, "player/h2ojump.wav", AS_STRAIGHT, ATTN_NORM);
		}
		else
		{
			if (self.jump_flag < -650)
			{
				T_Damage(self, world, world, TE_LIGHTNING1);
				sound(self, CHAN_VOICE, "player/land2.wav", AS_STRAIGHT, ATTN_NORM);
				self.deathtype = "falling";
			}
			else
			{
				sound(self, CHAN_VOICE, "player/land.wav", AS_STRAIGHT, ATTN_NORM);
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
	sound(self, CHAN_BODY, "player/tornoff2.wav", AS_STRAIGHT, ATTN_NONE);
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
			attacker.owner.frags = attacker.owner.frags + AS_STRAIGHT;
		}
		else
		{
			if (attacker.classname == "teledeath2")
			{
				bprint("Satan's power deflects ");
				bprint(targ.netname);
				bprint("'s telefrag\n");
				targ.frags = targ.frags - AS_STRAIGHT;
			}
			else
			{
				if (attacker.classname == "player")
				{
					if (targ == attacker)
					{
						attacker.frags = attacker.frags - AS_STRAIGHT;
						bprint(targ.netname);
						if (targ.weapon == IT_LIGHTNING && targ.waterlevel > AS_STRAIGHT)
						{
							bprint(" discharges into the water.\n");
						}
						else
						{
							if (targ.weapon == IT_GRENADE_LAUNCHER)
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
						}
					}
					else
					{
						attacker.frags = attacker.frags + AS_STRAIGHT;
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
												if (targ.health < -40)
												{
													deathstring = " was gibbed by ";
													deathstring2 = "'s grenade\n";
												}
												else
												{
													deathstring = " eats ";
													deathstring2 = "'s pineapple\n";
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
														if (attacker.waterlevel > AS_STRAIGHT)
														{
															deathstring2 = "'s discharge\n";
														}
														else
														{
															deathstring2 = "'s shaft\n";
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
				}
				else
				{
					targ.frags = targ.frags - AS_STRAIGHT;
					rnum = targ.watertype;
					bprint(targ.netname);
					if (rnum == CONTENT_WATER)
					{
						if (random() < 0.5)
						{
							bprint(" sleeps with the fishes\n");
						}
						else
						{
							bprint(" sucks it down\n");
						}
					}
					else
					{
						if (rnum == CONTENT_SLIME)
						{
							if (random() < 0.5)
							{
								bprint(" gulped a load of slime\n");
							}
							else
							{
								bprint(" can't exist on slime alone\n");
							}
						}
						else
						{
							if (rnum == CONTENT_LAVA)
							{
								if (targ.health < -15)
								{
									bprint(" burst into flames\n");
								}
								else
								{
									if (random() < 0.5)
									{
										bprint(" turned into hot slag\n");
									}
									else
									{
										bprint(" visits the Volcano God\n");
									}
								}
							}
							else
							{
								if (attacker.flags & FL_MONSTER)
								{
									if (attacker.classname == "monster_army")
									{
										bprint(" was shot by a Grunt\n");
									}
									else
									{
										if (attacker.classname == "monster_demon1")
										{
											bprint(" was eviscerated by a Fiend\n");
										}
										else
										{
											if (attacker.classname == "monster_dog")
											{
												bprint(" was mauled by a Rottweiler\n");
											}
											else
											{
												if (attacker.classname == "monster_fish")
												{
													bprint(" was fed to the Rotfish\n");
												}
												else
												{
													if (attacker.classname == "monster_knight")
													{
														bprint(" was slashed by a Knight\n");
													}
													else
													{
														if (attacker.classname == "monster_ogre")
														{
															bprint(" was destroyed by an Ogre\n");
														}
														else
														{
															if (attacker.classname == "monster_oldone")
															{
																bprint(" became one with Shub-Niggurath\n");
															}
															else
															{
																if (attacker.classname == "monster_shalrath")
																{
																	bprint(" was exploded by a Vore\n");
																}
																else
																{
																	if (attacker.classname == "monster_shambler")
																	{
																		bprint(" was smashed by a Shambler\n");
																	}
																	else
																	{
																		if (attacker.classname == "monster_tarbaby")
																		{
																			bprint(" was slimed by a Spawn\n");
																		}
																		else
																		{
																			if (attacker.classname == "monster_wizard")
																			{
																				bprint(" was scragged by a Scrag\n");
																			}
																			else
																			{
																				if (attacker.classname == "monster_zombie")
																				{
																					bprint(" joins the Zombies\n");
																				}
																				else
																				{
																					if (attacker.classname == "monster_sknight")
																					{
																						bprint(" was picked off by a Crossbowman\n");
																					}
																					else
																					{
																						if (attacker.classname == "monster_boss2")
																						{
																							bprint(" was creamed by an Enforcer Mk3\n");
																						}
																						else
																						{
																							if (attacker.classname == "monster_enforcer")
																							{
																								if (attacker.spawnflags & AS_SLIDING)
																								{
																									bprint(" was nailed by a Nailgun Enforcer\n");
																								}
																								else
																								{
																									bprint(" was blasted by an Enforcer\n");
																								}
																							}
																							else
																							{
																								if (attacker.classname == "monster_hell_knight")
																								{
																									if (attacker.spawnflags & AS_SLIDING)
																									{
																										bprint(" was slain by a Death Knight\n");
																									}
																									else
																									{
																										bprint(" was cut down by a Sabre Enforcer\n");
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
													}
												}
											}
										}
									}
								}
								else
								{
									if (attacker.classname == "explo_box")
									{
										bprint(" blew up\n");
									}
									else
									{
										if (attacker.solid == SOLID_BSP && attacker != world)
										{
											bprint(" was squished\n");
										}
										else
										{
											if (targ.deathtype == "falling")
											{
												targ.deathtype = "";
												bprint(" fell to his death\n");
											}
											else
											{
												if (attacker.classname == "trap_shooter" || attacker.classname == "trap_spikeshooter")
												{
													bprint(" was spiked\n");
												}
												else
												{
													if (attacker.classname == "fireball")
													{
														bprint(" ate a lavaball\n");
													}
													else
													{
														if (attacker.classname == "trigger_changelevel")
														{
															bprint(" tried to leave\n");
														}
														else
														{
															bprint(" died\n");
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
		}
	}
};


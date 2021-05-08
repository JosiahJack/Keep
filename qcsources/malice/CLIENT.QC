void () player_pain;
void () player_stand1;
void (vector org) spawn_tfog;
void (vector org,entity death_owner) spawn_tdeath;
void () Land1;
void () JumpFrame1;
float intermission_running;
float intermission_exittime;

void () info_intermission =
{
};


void () SetChangeParms =
{
	self.items = (self.items - (self.items & (IT_KEY1 | IT_KEY2)));
	if ((self.health > 100))
		self.health = 100;
	if ((self.health < 50))
		self.health = 50;
	parm1 = self.items;
	parm2 = self.health;
	if ((self.ammo_shells2 < 25))
		parm4 = 25;
	else
		parm4 = self.ammo_shells2;
	parm5 = self.ammo_nails2;
	parm6 = self.ammo_rockets2;
	parm7 = self.ammo_cells2;
	parm8 = self.weapon;
	parm9 = self.automount;
};


void () SetNewParms =
{
	parm1 = IT_44;
	parm2 = 100;
	parm3 = 0;
	parm4 = 0;
	parm5 = 0;
	parm6 = 0;
	parm6 = 0;
	parm8 = 1;
	parm9 = 1;
};


void () DecodeLevelParms =
{
	if (serverflags)
	{
		if ((world.model == "maps/start.bsp"))
			SetNewParms ();
	}
	self.items = parm1;
	self.health = parm2;
	self.ammo_shells2 = parm4;
	self.ammo_nails2 = parm5;
	self.ammo_rockets2 = parm6;
	self.ammo_cells2 = parm7;
	self.weapon = IT_44;
	self.automount = parm9;
};

entity () FindIntermission =
{
	local entity spot;
	local float cyc;

	spot = find (world, classname, "info_intermission");
	if (spot)
	{
		cyc = (random () * 4);
		while ((cyc > 1))
		{
			spot = find (spot, classname, "info_intermission");
			if (!spot)
				spot = find (spot, classname, "info_intermission");
			cyc = (cyc - 1);
		}
		return (spot);
	}
	spot = find (world, classname, "info_player_start");
	if (spot)
		return (spot);
	spot = find (world, classname, "testplayerstart");
	if (!spot)
		objerror ("FindIntermission: no spot");
	return (spot);
};


void () GotoNextMap =
{
	if (cvar ("samelevel"))
		changelevel (mapname);
	else
	{
		if (!CheckStartDemos ())
			changelevel (nextmap);
	}
};


void () ExitIntermission =
	{
	if (deathmatch)
		{
		GotoNextMap ();
		return;
		}
	intermission_exittime = time + 1.00;
	intermission_running = intermission_running + 1;
	if (intermission_running == 2)
		{
		if (world.model == "maps/e1m7.bsp")
			{
			WriteByte (MSG_ALL, SVC_CDTRACK);
			WriteByte (MSG_ALL, 2);
			WriteByte (MSG_ALL, 3);
			if (!cvar ("registered"))
				{
				WriteByte (MSG_ALL, SVC_FINALE);
				WriteString (MSG_ALL, "As the corpse of the monstrous entity\nChthon sinks back into the lava whence\nit rose, you grip the Rune of Earth\nMagic tightly. Now that you have\nconquered the Dimension of the Doomed,\nrealm of Earth Magic, you are ready to\ncomplete your task in...");
				}
			else
				{
				WriteByte (MSG_ALL, SVC_FINALE);
				WriteString (MSG_ALL, "As the corpse of the monstrous entity\nChthon sinks back into the lava whence\nit rose, you grip the Rune of Earth\nMagic tightly. Now that you have\nconquered the Dimension of the Doomed,\nrealm of Earth Magic, you are ready to\ncomplete your task. A...");
				}
			return;
			}
		else if ((world.model == "maps/e2m6.bsp"))
			{
			WriteByte (MSG_ALL, SVC_CDTRACK);
			WriteByte (MSG_ALL, 2);
			WriteByte (MSG_ALL, 3);
			WriteByte (MSG_ALL, SVC_FINALE);
			WriteString (MSG_ALL, "The Rune of Black Magic throbs evilly in\nyour hand and whispers dark thoughts\ninto your brain. You learn the inmost\nlore of the Hell-Mother; Shub-Niggurath!\nYou now know that she is behind all the\nterrible plotting which has led to so\nmuch death...");
			return;
			}
		else if ((world.model == "maps/e3m6.bsp"))
			{
			WriteByte (MSG_ALL, SVC_CDTRACK);
			WriteByte (MSG_ALL, 2);
			WriteByte (MSG_ALL, 3);
			WriteByte (MSG_ALL, SVC_FINALE);
			WriteString (MSG_ALL, "The charred viscera of diabolic horrors\nbubble viscously as you seize the Rune\nof Hell Magic. Its heat scorches your\nhand, and its terrible secrets blight\nyour mind. Gathering the shreds of your\ncourage, you shake the devil's shackles\nfrom your ...");
			return;
			}
		else if ((world.model == "maps/e4m7.bsp"))
			{
			WriteByte (MSG_ALL, SVC_CDTRACK);
			WriteByte (MSG_ALL, 2);
			WriteByte (MSG_ALL, 3);
			WriteByte (MSG_ALL, SVC_FINALE);
			WriteString (MSG_ALL, "Despite the awful might of the Elder\nWorld, you have achieved the Rune of\nElder Magic, capstone of all types of\narcane wisdom. Beyond good and evil,\nbeyond life and death, the Rune\npulsates, heavy with import. Patient and\npotent, the Elder Being...");
			return;
			}
		GotoNextMap ();
		}
	if (intermission_running == 3)
		{
		if (!cvar ("registered"))
			{
			WriteByte (MSG_ALL, SVC_SELLSCREEN);
			return;
			}
		if ((serverflags & 15) == 15)
			{
			WriteByte (MSG_ALL, SVC_FINALE);
			WriteString (MSG_ALL, "Now, you have all four Runes. You sense\ntremendous invisible forces moving to\nunseal ancient barriers. Shub-Niggurath\nhad hoped to use the Runes Herself to\nclear off the Earth, but now instead,\nyou will use them to enter her home and\nconfront he...");
			return;
			}
		}
	GotoNextMap ();
	};


void () IntermissionThink =
	{
	if (time < intermission_exittime)
		return;
	if ((!self.button0 && !self.button1) && !self.button2)
		return;
	ExitIntermission ();
	};


void () execute_changelevel =
	{
	local entity pos;

	intermission_running = 1;
	if (deathmatch)
		intermission_exittime = (time + 5.00);
	else
		intermission_exittime = (time + 2.00);
	WriteByte (MSG_ALL, SVC_CDTRACK);
	WriteByte (MSG_ALL, 3);
	WriteByte (MSG_ALL, 3);
	pos = FindIntermission ();
	other = find (world, classname, "player");
	while ((other != world))
		{
		stuffcmd (other, "v_cshift 0 0 0 0\n");
		other.view_ofs = VEC_ORIGIN;
		other.v_angle = pos.mangle;
		other.angles = pos.mangle;
		other.fixangle = TRUE;
		other.nextthink = (time + 0.5);
		other.takedamage = DAMAGE_NO;
		other.solid = SOLID_NOT;
		other.movetype = MOVETYPE_NONE;
		other.modelindex = 0;
		setorigin (other, pos.origin);
		other = find (other, classname, "player");
		}
	WriteByte (MSG_ALL, SVC_INTERMISSION);
	};


void () changelevel_touch =
{
	local entity pos;

	if ((other.classname != "player"))
		return;
	if ((other.probe_active == TRUE))
		return;
	if (cvar ("noexit"))
	{
		T_Damage (other, self, self, 50000);
		return;
	}
	if ((coop || deathmatch))
	{
		bprint (other.netname);
		bprint (" exited the level\n");
	}
	nextmap = self.map;
	SUB_UseTargets ();
	if (((self.spawnflags & 1) && (deathmatch == 0)))
	{
		GotoNextMap ();
		return;
	}
	self.touch = SUB_Null;
	self.think = execute_changelevel;
	self.nextthink = (time + 0.1);
};


void () trigger_changelevel =
{
	if (!self.map)
		objerror ("changelevel trigger doesn't have map");
	InitTrigger ();
	self.touch = changelevel_touch;
};


void () trigger_cutscene =
{
	self.map = "start";
	setmodel (self, "progs/null.spr");
	setsize (self, '-30 -30 -10', '30 30 10');
	self.solid = SOLID_TRIGGER;
	self.movetype = MOVETYPE_STEP;
	self.touch = changelevel_touch;
};

void () set_suicide_frame;

void () respawn =
{
	if (coop)
	{
		CopyToBodyQue (self);
		setspawnparms (self);
		PutClientInServer ();
	}
	else
	{
		if (deathmatch)
		{
			CopyToBodyQue (self);
			SetNewParms ();
			PutClientInServer ();
			self.armorvalue = 0;
			self.util = 0;
			self.tools = (self.tools - (self.tools & (((((UT_CHUTE | UT_HOVER) | UT_PROBE) | UT_SCUBA) | UT_MINISUB) | UT_BIGASSGUN)));
		}
		else
			localcmd ("restart\n");
	}
};


void () ClientKill =
{
	bprint (self.netname);
	bprint (" suicides\n");
	set_suicide_frame ();
	self.modelindex = modelindex_player;
	self.frags = (self.frags - 2);
	respawn ();
};


float (vector v) CheckSpawnPoint =
{
	return (FALSE);
};

entity () SelectSpawnPoint =
{
	local entity spot;

	spot = find (world, classname, "testplayerstart");
	if (spot)
		return (spot);
	if (coop)
	{
		lastspawn = find (lastspawn, classname, "info_player_coop");
		if ((lastspawn == world))
			lastspawn = find (lastspawn, classname, "info_player_start");
		if ((lastspawn != world))
			return (lastspawn);
	}
	else
	{
		if (deathmatch)
		{
			lastspawn = find (lastspawn, classname, "info_player_deathmatch");
			if ((lastspawn == world))
				lastspawn = find (lastspawn, classname, "info_player_deathmatch");
			if ((lastspawn != world))
				return (lastspawn);
		}
	}
	if (serverflags)
	{
		spot = find (world, classname, "info_player_start2");
		if (spot)
			return (spot);
	}
	spot = find (world, classname, "info_player_start");
	if (!spot)
		error ("PutClientInServer: no info_player_start on level");
	return (spot);
};

void () PlayerDie;
void () player_touch;
void () fadein;

void () PutClientInServer =
{
	local entity spot;

	self.classname = "player";
	self.health = 100;
	self.takedamage = DAMAGE_AIM;
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_WALK;
	self.touch = player_touch;
	self.show_hostile = FALSE;
	self.max_health = 100;
	self.flags = FL_CLIENT;
	self.air_finished = (time + 12.00);
	self.dmg = 2;
	self.effects = 0;
	self.weaponframe = 0;
	self.tube_wing = 0;
	self.atomic_intensity = 0;
	self.count = 0;
	self.barrel2 = FALSE;
	self.burning = FALSE;
	self.extinguished = FALSE;
	self.hover_active = FALSE;
	self.aqua_sound = (time + 9999999);
	self.aquamon = FALSE;
	self.probe_active = FALSE;
	self.count_shot_idle = 40;
	stuffcmd (self, "fov 90\n");
	if ((!deathmatch && !coop))
		fadein ();
	DecodeLevelParms ();
	W_SetCurrentAmmo ();
	self.items = (self.items - (self.items & ((IT_ARMOR1 | IT_ARMOR2) | IT_ARMOR3)));
	self.attack_finished = time;
	self.th_pain = player_pain;
	self.th_die = PlayerDie;
	self.deadflag = DEAD_NO;
	self.pausetime = 0.00;
	spot = SelectSpawnPoint ();
	self.origin = (spot.origin + '0 0 1');
	self.angles = spot.angles;
	self.fixangle = TRUE;
	setmodel (self, "progs/d_bag.mdl");
	modelindex_bag = self.modelindex;
	setmodel (self, "progs/d_hover.mdl");
	modelindex_hover = self.modelindex;
	setmodel (self, "progs/d_scuba.mdl");
	modelindex_scuba = self.modelindex;
	setmodel (self, "progs/player.mdl");
	modelindex_player = self.modelindex;
	setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
	self.view_ofs = '0 0 22';
	player_stand1 ();
	if ((deathmatch || coop))
	{
		makevectors (self.angles);
		spawn_tfog ((self.origin + (v_forward * 20)));
	}
	spawn_tdeath (self.origin, self);
	localcmd ("sv_maxspeed 600\n");
};


void () info_player_start =
{
};


void () info_player_start2 =
{
};


void () testplayerstart =
{
};


void () info_player_deathmatch =
{
};


void () info_player_coop =
{
};


void (entity c) PrintClientScore =
{
	if (((c.frags > -10) && (c.frags < 0)))
		bprint (" ");
	else
	{
		if ((c.frags >= 0))
		{
			if ((c.frags < 100))
				bprint (" ");
			if ((c.frags < 10))
				bprint (" ");
		}
	}
	bprint (ftos (c.frags));
	bprint (" ");
	bprint (c.netname);
	bprint ("\n");
};


void () DumpScore =
{
	local entity e;
	local entity sort;
	local entity walk;

	if (world.chain)
		error ("DumpScore: world.chain is set");
	e = find (world, classname, "player");
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
			if ((e.frags > sort.frags))
			{
				e.chain = sort;
				sort = e;
			}
			else
			{
				walk = sort;
				do
				{
					if (!walk.chain)
					{
						e.chain = world;
						walk.chain = e;
					}
					else
					{
						if ((walk.chain.frags < e.frags))
						{
							e.chain = walk.chain;
							walk.chain = e;
						}
						else
							walk = walk.chain;
					}
				} while ((walk.chain != e));
			}
		}
		e = find (e, classname, "player");
	}
	bprint ("\n");
	while (sort)
	{
		PrintClientScore (sort);
		sort = sort.chain;
	}
	bprint ("\n");
};


void () NextLevel =
{
	local entity o;

	o = find (world, classname, "trigger_changelevel");
	if ((!o || (mapname == "start")))
	{
		o = spawn ();
		o.map = mapname;
	}
	nextmap = o.map;
	if ((o.nextthink < time))
	{
		o.think = execute_changelevel;
		o.nextthink = (time + 0.1);
	}
};


void () CheckRules =
{
	local float timelimit;
	local float fraglimit;

	if (gameover)
		return;
	timelimit = (cvar ("timelimit") * 60);
	fraglimit = cvar ("fraglimit");
	if ((timelimit && (time >= timelimit)))
	{
		NextLevel ();
		return;
	}
	if ((fraglimit && (self.frags >= fraglimit)))
	{
		NextLevel ();
		return;
	}
};


void () PlayerDeathThink =
{
	local entity old_self;
	local float forward;

	if ((self.flags & FL_ONGROUND))
	{
		forward = vlen (self.velocity);
		forward = (forward - 20);
		if ((forward <= 0))
			self.velocity = VEC_ORIGIN;
		else
			self.velocity = (forward * normalize (self.velocity));
	}
	if ((self.deadflag == DEAD_DEAD))
	{
		if (((self.button2 || self.button1) || self.button0))
			return;
		self.deadflag = DEAD_RESPAWNABLE;
		return;
	}
	if (((!self.button2 && !self.button1) && !self.button0))
		return;
	self.button0 = 0;
	self.button1 = 0;
	self.button2 = 0;
	respawn ();
};


void () PlayerJump =
{
	local vector start;
	local vector end;

	if ((self.jump_release > time))
		return;
	if ((self.probe_active == TRUE))
		return;
	if ((self.flags & FL_WATERJUMP))
		return;
	if ((self.waterlevel >= 2))
	{
		if ((self.watertype == CONTENT_WATER))
		{
			if ((self.tools == (self.tools | UT_SCUBA)))
				self.velocity_z = 150;
			else
				self.velocity_z = 100;
		}
		else
		{
			if ((self.watertype == CONTENT_SLIME))
				self.velocity_z = 80;
			else
				self.velocity_z = 50;
		}
		if ((self.swim_flag < time))
		{
			self.swim_flag = (time + 1.00);
			if ((self.tools == (self.tools | UT_MINISUB)))
				return;
			if ((random () < 0.5))
				sound (self, CHAN_BODY, "misc/water1.wav", 1.00, ATTN_NORM);
			else
				sound (self, CHAN_BODY, "misc/water2.wav", 1.00, ATTN_NORM);
		}
		return;
	}
	if (!(self.flags & FL_ONGROUND))
	{
		if (((self.chute_active == FALSE) && !(self.flags & FL_INWATER)))
		{
			if ((self.hover_active == TRUE))
			{
				self.velocity = (v_forward * 800);
				self.jump_release = (time + 1.00);
				particle ((self.origin - '0 0 24'), (v_forward * -200), 42, 10);
				sound (self, CHAN_BODY, "utils/hovrboot.wav", 1.00, ATTN_NORM);
			}
			else
			{
				if ((((self.tools == (self.tools | UT_CHUTE)) && (self.deploy_wait < time)) && (self.flags & FL_JUMPRELEASED)))
				{
					if ((self.velocity_z > -300))
						return;
					PullCord ();
					self.jump_release = (time + 0.2);
				}
			}
		}
		return;
	}
	if (!(self.flags & FL_JUMPRELEASED))
		return;
	self.flags = (self.flags - FL_ONGROUND);
	self.flags = (self.flags - (self.flags & FL_JUMPRELEASED));
	self.button2 = 0;
	if ((self.hover_active == TRUE))
	{
		sound (self, CHAN_BODY, "utils/hovrjmp8.wav", 1.00, ATTN_NORM);
		self.velocity_z = (self.velocity_z + 500);
	}
	else
	{
		sound (self, CHAN_BODY, "player/plyrjmp8.wav", 1.00, ATTN_NORM);
		self.velocity_z = (self.velocity_z + 270);
	}
	if ((self.attack_finished < time))
		JumpFrame1 ();
	self.jump_release = (time + 0.5);
	self.deploy_wait = (time + 0.8);
};

.float dmgtime;

void () BreatheOut =
{
	local float x;

	if ((self.probe_active == TRUE))
		return;
	x = 1;
	if ((random () < 0.5))
		x = -1;
	make_bub ((((self.origin + ((v_forward * random ()) * 15)) + (v_up * 24)) + (((v_right * random ()) * 15) * x)));
	make_bub ((((self.origin + ((v_forward * random ()) * 15)) + (v_up * 25)) + (((v_right * random ()) * 15) * x)));
	make_bub ((((self.origin + ((v_forward * random ()) * 15)) + (v_up * 26)) + (((v_right * random ()) * 15) * x)));
	make_bub ((((self.origin + ((v_forward * random ()) * 15)) + (v_up * 27)) + (((v_right * random ()) * 15) * x)));
};


void () WaterMove =
{
	if ((self.movetype == MOVETYPE_NOCLIP))
		return;
	if ((self.health < 1))
		return;
	if ((self.waterlevel != 3))
	{
		if ((self.classname != "cbot"))
		{
			if ((((self.tools != (self.tools | UT_MINISUB)) && (self.tools != (self.tools | UT_SCUBA))) && (self.armorvalue <= 0)))
			{
				if ((self.air_finished < time))
					sound (self, CHAN_BODY, "player/gasp2.wav", 1.00, ATTN_NORM);
				else
				{
					if ((self.air_finished < (time + 9.00)))
						sound (self, CHAN_BODY, "player/gasp1.wav", 1.00, ATTN_NORM);
				}
				self.air_finished = (time + 12);
				self.dmg = 2;
			}
			else
				self.air_finished = (time + 12);
		}
	}
	else
	{
		if ((self.air_finished < time))
		{
			if ((self.pain_finished < time))
			{
				if ((self.tools == (self.tools | UT_MINISUB)))
				{
					self.pain_finished = (time + 12);
					return;
				}
				else
				{
					if (((self.tools == (self.tools | UT_SCUBA)) && (self.armorvalue > 0)))
					{
						BreatheOut ();
						sound (self, CHAN_BODY, "damage/scuba.wav", 1.00, ATTN_NORM);
						if ((self.deploy_wait < time))
						{
							self.armorvalue = (self.armorvalue - 1);
							self.deploy_wait = (time + 10.00);
							if ((self.armorvalue == 0))
								self.tools = (self.tools - (self.tools & UT_SCUBA));
						}
						self.pain_finished = (time + 5.00);
					}
					else
					{
						self.dmg = (self.dmg + 2);
						if ((self.dmg > 15))
							self.dmg = 10;
						T_Damage (self, world, world, self.dmg);
						self.pain_finished = (time + 1.00);
					}
				}
			}
		}
	}
	if (!self.waterlevel)
	{
		if ((self.flags & FL_INWATER))
		{
			self.flags = (self.flags - FL_INWATER);
			self.aqua_sound = (time + 100000000);
			self.aquamon = FALSE;
			self.deploy_wait = (time + 1.00);
			stuffcmd (self, "cl_forwardspeed 360\n");
			self.cl_forwardspeed = CHT_NORMSPEED;
			if ((self.modelindex != modelindex_bag))
				self.modelindex = modelindex_player;
			sound (self, CHAN_VOICE, "misc/outwater.wav", 1.00, ATTN_NORM);
			if ((self.tools == (self.tools | UT_MINISUB)))
				exit_vehicle ();
		}
		return;
	}
	if ((self.watertype == CONTENT_LAVA))
	{
		if ((self.dmgtime < time))
		{
			self.dmgtime = (time + 0.2);
			T_Damage (self, world, world, (10 * self.waterlevel));
		}
	}
	else
	{
		if ((self.watertype == CONTENT_SLIME))
		{
			if (((self.dmgtime < time) && (self.radsuit_finished < time)))
			{
				self.dmgtime = (time + 0.6);
				T_Damage (self, world, world, (4 * self.waterlevel));
			}
		}
	}
	if (!(self.flags & FL_INWATER))
	{
		if ((self.hover_active == TRUE))
		{
			self.velocity_z = 60;
			if ((self.chute_active == TRUE))
				self.chute_active = FALSE;
			return;
		}
		if ((self.watertype == CONTENT_LAVA))
			sound (self, CHAN_BODY, "player/inlava.wav", 1.00, ATTN_NORM);
		if ((self.watertype == CONTENT_WATER))
		{
			sound (self, CHAN_VOICE, "player/inh2o.wav", 1.00, ATTN_NORM);
			WaterSplash (5, self);
		}
		if ((self.watertype == CONTENT_SLIME))
			sound (self, CHAN_BODY, "player/slimbrn2.wav", 1.00, ATTN_NORM);
		self.flags = (self.flags + FL_INWATER);
		self.dmgtime = 0.00;
		self.chute_active = FALSE;
		if (!self.button0)
			player_run ();
		if (self.tools == (self.tools | UT_SCUBA))
		{
			stuffcmd (self, "cl_forwardspeed 420\n");
			self.cl_forwardspeed = CHT_SCUBASPEED;
		}
		self.tools = (self.tools - (self.tools & UT_FALLING));
	}
	if (!(self.flags & FL_WATERJUMP))
		self.velocity = (self.velocity - (((0.8 * self.waterlevel) * frametime) * self.velocity));
	if ((self.tools == (self.tools | UT_MINISUB)))
	{
		if ((self.velocity_x || self.velocity_y))
		{
			if ((random () < 0.06))
				make_bub ((self.origin + (v_forward * -60)));
		}
		else
		{
			if ((random () < 0.01))
				make_bub ((self.origin + (v_forward * -60)));
		}
	}
};


void () CheckWaterJump =
{
	local vector start;
	local vector end;

	makevectors (self.angles);
	start = self.origin;
	start_z = (start_z + 8);
	v_forward_z = 0;
	normalize (v_forward);
	end = (start + (v_forward * 24));
	traceline (start, end, TRUE, self);
	if ((trace_fraction < 1))
	{
		start_z = ((start_z + self.maxs_z) - 8);
		end = (start + (v_forward * 24));
		self.movedir = (trace_plane_normal * -50);
		traceline (start, end, TRUE, self);
		if ((trace_fraction == 1))
		{
			self.flags = (self.flags | FL_WATERJUMP);
			self.velocity_z = 225;
			self.flags = (self.flags - (self.flags & FL_JUMPRELEASED));
			self.teleport_time = (time + 2.00);
			return;
		}
	}
};


void () PlayerPreThink =
	{
	local float mspeed;
	local float aspeed;
	local float r;

	if (intermission_running)
		{
		IntermissionThink ();
		return;
		}
	if (self.view_ofs == VEC_ORIGIN)
		return;
	makevectors (self.v_angle);
	CheckRules ();
	WaterMove ();
	if (self.waterlevel == 2)
		{
		CheckWaterJump ();
		if (self.aquamon == FALSE)
			self.aqua_sound = time;
		}
	if (self.deadflag >= DEAD_DEAD)
		{
		PlayerDeathThink ();
		return;
		}
	if (self.deadflag == DEAD_DYING)
		return;

	if (self.button2)
		PlayerJump ();
	else
		self.flags = (self.flags | FL_JUMPRELEASED);

	if (time < self.pausetime)
		self.velocity = VEC_ORIGIN;
	if (self.vars_flag == 0)
		NormalVars ();
	if (self.probe_active == TRUE)
		probe_physics ();
	};


void () PlayerPostThink =
{
	local float mspeed;
	local float aspeed;
	local float r;
	local float amount;
	local vector path;

	if (deathmatch && (cvar ("temp1") == 1))
		{
		self.cheatcheck = self.cheatcheck + 1;
		if (self.cheatcheck >= 5)
			{
			self.cheatcheck = FALSE;
			preventcheat ();
			}
		}

	if (self.view_ofs == VEC_ORIGIN)
		return;
	if (self.deadflag)
		return;

	W_WeaponFrame ();

	if ((((self.jump_flag < -300) && (self.flags & FL_ONGROUND)) && (self.health > 0)))
	{
		if ((self.watertype == CONTENT_WATER))
			sound (self, CHAN_BODY, "player/h2ojump.wav", 1.00, ATTN_NORM);
		else
		{
			if ((self.jump_flag < -650))
			{
				if ((self.hover_active == TRUE))
				{
					sound (self, CHAN_BODY, "utils/hovrjmp8.wav", 1.00, ATTN_NORM);
					self.tools = (self.tools - (self.tools & UT_FALLING));
					player_run ();
				}
				else
				{
					amount = ((self.jump_flag * self.jump_flag) / 11000);
					if (deathmatch)
						T_Damage (self, world, world, (amount * 2));
					else
						T_Damage (self, world, world, amount);
					sound (self, CHAN_VOICE, "player/land2.wav", 1.00, ATTN_NORM);
					self.deathtype = "falling";
					self.tools = (self.tools - (self.tools & UT_FALLING));
					if ((self.health > 0))
						Land1 ();
				}
			}
			else
			{
				if ((self.hover_active == TRUE))
				{
					sound (self, CHAN_BODY, "utils/hovrjmp8.wav", 1.00, ATTN_NORM);
					self.tools = (self.tools - (self.tools & UT_FALLING));
				}
				else
				{
					sound (self, CHAN_VOICE, "player/land.wav", 1.00, ATTN_NORM);
					self.tools = (self.tools - (self.tools & UT_FALLING));
				}
				player_run ();
			}
		}
		self.jump_flag = FALSE;
		if ((self.hover_active == TRUE))
			self.velocity_z = (self.velocity_z + 200);
	}
	if (!(self.flags & FL_ONGROUND))
		self.jump_flag = self.velocity_z;
	if ((self.velocity_z < -300))
	{
		if ((!(self.tools & UT_FALLING) && !(self.flags & FL_INWATER)))
		{
			if ((self.hover_active != TRUE))
			{
				self.tools = (self.tools + UT_FALLING);
				Panic1 ();
			}
		}
	}
	if (((self.tools == (self.tools | UT_SCUBA)) || (self.tools == (self.tools | UT_MINISUB))))
	{
		if (!(self.flags & FL_INWATER))
			return;
		if ((self.waterlevel > 2))
		{
			if (((self.modelindex != modelindex_scuba) && (self.tools != (self.tools | UT_MINISUB))))
			{
				if ((self.tools != (self.tools | UT_BIGASSGUN)))
					self.modelindex = modelindex_scuba;
			}
			path = aim (self, 1);
			self.angles = vectoangles (path);
		}
	}
	if ((((self.aqua_sound < time) && (self.hover_active != TRUE)) && (self.tools != (self.tools | UT_MINISUB))))
	{
		sound (self, CHAN_VOICE, "ambience/subaqua.wav", 1.00, ATTN_NORM);
		self.aquamon = TRUE;
		self.aqua_sound = (time + 5.00);
	}
};


void () ClientConnect =
{
	bprint (self.netname);
	bprint (" entered the game\n");
	if (intermission_running)
		ExitIntermission ();
};


void () ClientDisconnect =
{
	if (gameover)
		return;
	if ((self.tools == (self.tools | UT_MINISUB)))
		exit_vehicle ();
	bprint (self.netname);
	bprint (" escaped with ");
	bprint (ftos (self.frags));
	bprint (" kills\n");
	sound (self, CHAN_BODY, "player/tornoff2.wav", 1.00, ATTN_NONE);
	set_suicide_frame ();
};


void (entity targ,entity attacker) ClientObituary =
{
	local float rnum;
	local string deathstring;
	local string deathstring2;

	rnum = random ();
	if ((targ.classname == "player"))
	{
		if ((attacker.classname == "teledeath"))
		{
			bprint (targ.netname);
			bprint (" was telefragged by ");
			bprint (attacker.owner.netname);
			bprint ("\n");
			attacker.owner.frags = (attacker.owner.frags + 1);
			return;
		}
		if ((attacker.classname == "teledeath2"))
		{
			bprint ("Satan's power deflects ");
			bprint (targ.netname);
			bprint ("'s telefrag\n");
			targ.frags = (targ.frags - 1);
			return;
		}
		if ((attacker.classname == "player"))
		{
			if (targ == attacker)
			{
				attacker.frags = (attacker.frags - 1);
				bprint (targ.netname);
				if (((targ.weapon == JUMP) && (targ.waterlevel > 1)))
				{
					bprint (" discharges into the water.\n");
					return;
				}
				if (targ.weapon == 16)
					bprint (" needs a safety catch\n");
				else
				{
					if (rnum)
						bprint (" just ate the trash\n");
					else
						bprint (" checks if his weapon is loaded\n");
				}
				return;
			}
			else
			{
				attacker.frags = attacker.frags + 1;
				rnum = attacker.weapon;
				if (attacker.tools == (attacker.tools | UT_BIGASSGUN))
					{
					deathstring = " has been ionized by ";
					deathstring2 = " particles\n";
					}
				else if (attacker.tools == (attacker.tools | UT_MINISUB))
					{
					deathstring = " eats ";
					deathstring2 = " big torp\n";
					}
				else if (rnum == IT_44)
					{
					deathstring = " was tipped off by ";
					deathstring2 = "\n";
					}
				else if (rnum == IT_UZI)
					{
					deathstring = " was uzed by ";
					deathstring2 = " uzi\n";
					}
				else if (rnum == IT_SHOT)
					{
					deathstring = " swallows ";
					deathstring2 = " fire\n";
					}
				else if (rnum == IT_SHOT2)
					{
					deathstring = " was in-verted by ";
					deathstring2 = "\n";
					}
				else if (rnum == IT_ROCKET)
					{
					deathstring = " was turned crusty by ";
					deathstring2 = "\n";
					if (targ.health < -40)
						{
						deathstring = " couldn't handle ";
						deathstring2 = " stinger\n";
						}
					}
				else if (rnum == IT_MORTER)
					{
					deathstring = " tastes ";
					deathstring2 = " napalm\n";
					if (targ.health < -40)
						{
						deathstring = " disliked ";
						deathstring2 = " napalm\n";
						}
					}
				else if (rnum == IT_MINI)
					{
					deathstring = " was reaped by ";
					deathstring2 = " minigun\n";
					}
				else if (rnum == IT_PUNISHER)
					{
					deathstring = " accepts ";
					deathstring2 = " punishment\n";
					}
				bprint (targ.netname);
				bprint (deathstring);
				bprint (attacker.netname);
				if ((deathstring2 != "\n"))
					bprint ("'s");
				bprint ("<");
				bprint (ftos (attacker.health));
				bprint (">");
				bprint (deathstring2);
			}
			return;
		}
		else
		{
			targ.frags = (targ.frags - 1);
			rnum = targ.watertype;
			bprint (targ.netname);
			if ((rnum == CONTENT_WATER))
			{
				if ((random () < 0.5))
					bprint (" feeds the fishes\n");
				else
					bprint (" gulps it down\n");
				return;
			}
			else
			{
				if ((rnum == CONTENT_SLIME))
				{
					if ((random () < 0.5))
						bprint (" pulched a load of slime\n");
					else
						bprint (" became one with the slime\n");
					return;
				}
				else
				{
					if ((rnum == CONTENT_LAVA))
					{
						if ((targ.health < -15))
						{
							bprint (" spontaneously combusted\n");
							return;
						}
						if ((random () < 0.5))
							bprint (" turned into molten slag\n");
						else
							bprint (" visits the Volcano God\n");
						return;
					}
				}
			}
			if ((attacker.flags & FL_MONSTER))
			{
				if ((attacker.classname == "monster_swat"))
					bprint (" was swatted like a fly\n");
				if ((attacker.classname == "monster_hanger"))
					bprint (" is all hung up\n");
				if ((attacker.classname == "monster_torcher"))
					bprint (" was torchered to death\n");
				if ((attacker.classname == "monster_probe"))
					bprint (" has been probed\n");
				if ((attacker.classname == "monster_banshee"))
					bprint (" is banshee fodder\n");
				if ((attacker.classname == "monster_rider"))
					bprint (" was ridden\n");
				if ((attacker.classname == "monster_riot"))
					bprint (" was skull-cracked\n");
				if ((attacker.classname == "monster_merc"))
					bprint (" was seduced by a mercbabe\n");
				if ((attacker.classname == "cbot"))
				{
					if ((random () < 0.5))
						bprint (" tried to flirt with vasquez\n");
					else
						bprint (" was laid down by vasquez\n");
				}
				if ((attacker.classname == "monster_bara"))
					bprint (" was chomped by a bara\n");
				if ((attacker.classname == "monster_blowfish"))
					bprint (" was blown by a blowfish\n");
				if ((attacker.classname == "monster_hunter"))
					bprint (" has become the hunted\n");
				if ((attacker.classname == "monster_baboon"))
					bprint (" tried to play with his monkey\n");
				if ((attacker.classname == "monster_frogman"))
					bprint (" was skewered by a frogman\n");
				if ((attacker.classname == "monster_bossman"))
					bprint (" broke the chain of command\n");
				if ((attacker.classname == "monster_turret"))
					bprint (" was burned down by BM's turrets\n");
				return;
			}
			if ((attacker.classname == "barrel"))
			{
				bprint (" blew up real good\n");
				return;
			}
			if (((attacker.solid == SOLID_BSP) && (attacker != world)))
			{
				bprint (" was squished like a rat\n");
				return;
			}
			if ((targ.deathtype == "falling"))
			{
				targ.deathtype = "";
				bprint (" is a pancake\n");
				return;
			}
			if (((attacker.classname == "trap_shooter") || (attacker.classname == "trap_spikeshooter")))
			{
				bprint (" was spiked\n");
				return;
			}
			if ((attacker.classname == "fireball"))
			{
				bprint (" tried to eat a lavaball\n");
				return;
			}
			if ((attacker.classname == "trigger_changelevel"))
			{
				bprint (" is a pansy\n");
				return;
			}
			bprint (" died\n");
		}
	}
};


float(float v) anglemod = 
{
	return v - floor(v / 360) * 360;
};

float(float y1, float y2) angcomp = 
{
	local float answer;
	y1 = anglemod(y1);
	y2 = anglemod(y2);
	answer = y1 - y2;
	if (answer > 180)
	{
		answer = answer - 360;
	}
	else
	{
		if (answer < -180)
		{
			answer = answer + 360;
		}
	}
	return answer;
};

void() rain_follow = 
{
	local entity y;
	if (self.owner.rain_on == 0)
	{
		if (self.classname == "rain1")
		{
			if (self.pain_finished < time)
			{
				sound(self, CHAN_AUTO, "ambience/rain.wav", IT_RELIC1, ATTN_NORM);
				self.pain_finished = time + 4.6;
			}
			setmodel(self, string_null);
			frameskip(0.1);
			return;
		}
		else
		{
			remove(self);
			return;
		}
	}
	makevectors(self.v_angle);
	self.cnt = self.cnt - AS_MELEE;
	self.state = self.state - IT_RELIC2;
	if (self.cnt < -150)
	{
		self.cnt = 100;
	}
	if (self.state < -200)
	{
		self.state = 200;
	}
	if (self.classname == "rain1")
	{
		setmodel(self, "progs/rain.spr");
		setorigin(self, self.owner.origin + v_right * FL_GODMODE + v_up * EF_ADDITIVE);
		if (self.pain_finished < time)
		{
			sound(self, CHAN_AUTO, "ambience/rain.wav", IT_RELIC1, ATTN_NORM);
			self.pain_finished = time + 4.6;
		}
	}
	else
	{
		if (self.classname == "rain2")
		{
			setorigin(self, self.owner.origin + v_right * 96 + v_up * self.cnt);
		}
		else
		{
			setorigin(self, self.owner.origin + v_right * FL_NOTARGET + v_up * self.state);
		}
	}
	if (self.attack_finished < time)
	{
		if (self.frame > IT_RELIC1)
		{
			self.frame = STATE_TOP;
		}
		else
		{
			self.frame = self.frame + IT_RELIC1;
		}
		self.attack_finished = time + 0.1;
	}
	frameskip(0.010000);
};

void() InitCamera = 
{
	local vector view;
	local vector ot;
	local vector spot;
	local float dif;
	local float bt;
	local entity y;
	local float r;
	local vector IMMEDIATE;
	local vector IMMEDIATE;
	local entity rain1;
	local entity rain2;
	local entity rain3;
	spot = self.goalentity.origin;
	spot_y = STATE_TOP;
	if (self.camshake_finished > time && framerate == STATE_TOP)
	{
		r = random() * IT_RELIC3;
		if (random() < 0.5)
		{
			self.punchangle_x = r;
		}
		else
		{
			self.punchangle_x = r * CONTENT_EMPTY;
		}
	}
	view = vectoangles(self.goalentity.origin - self.origin);
	ot = normalize(self.goalentity.origin - self.origin);
	bt = vlen(spot - self.origin);
	if (cvar("scratch3") == STATE_TOP && !coop && !deathmatch)
	{
		if (view_y > 250 && view_y < 290)
		{
			self.angles_y = view_y;
		}
		self.angles_x = view_x * CONTENT_EMPTY;
	}
	traceline(self.origin, self.origin + '0 0 32', 0, self);
	if (trace_fraction < IT_RELIC1)
	{
		self.cam_zcheck = 1;
	}
	if (self.cam_zcheck == 1 && (self.char.origin_z < self.origin_z || self.char.onground == 1))
	{
		self.cam_zcheck = 0;
	}
	traceline(self.origin, self.origin + '8 0 0', 0, self);
	if (trace_fraction < IT_RELIC1)
	{
		self.cam_xcheck = 1;
	}
	if (self.cam_xcheck == 1 && self.char.origin_x < self.origin_x)
	{
		self.cam_xcheck = 0;
	}
	traceline(self.origin, self.origin + '-8 0 0', 0, self);
	if (trace_fraction < IT_RELIC1)
	{
		self.cam_xcheck2 = 1;
	}
	if (self.cam_xcheck2 == 1 && self.char.origin_x > self.origin_x)
	{
		self.cam_xcheck2 = 0;
	}
	traceline(self.origin, self.origin + '0 8 0', 0, self);
	if (trace_fraction < IT_RELIC1)
	{
		self.cam_ycheck = 1;
	}
	if (self.camerastyle == STATE_TOP || self.camerastyle >= IT_RELIC2)
	{
		if (self.char.health > STATE_TOP)
		{
			if (self.goalentity != self.char)
			{
				self.goalentity = self.char;
			}
		}
		if (world.model == "maps/village.bsp")
		{
			ot = ot * (bt / AS_MELEE) * frametime;
		}
		else
		{
			if (cvar("scratch3") == STATE_TOP)
			{
				ot = ot * (bt * AS_MELEE) * frametime;
			}
			else
			{
				ot = ot * (bt * TE_LIGHTNING2) * frametime;
			}
		}
	}
	else
	{
		if (self.camerastyle == IT_RELIC1)
		{
			ot = VEC_ORIGIN;
		}
	}
	dif = angcomp(view_y, self.v_angle_y);
	if (fabs(dif) > self.camloose)
	{
		dif = angcomp(view_x * CONTENT_EMPTY, self.v_angle_x);
		view = self.lock_view.origin;
		if (self.camerastyle != AS_MELEE && self.cam_xcheck == 0 && self.cam_xcheck2 == 0)
		{
			view_x = ot_x + view_x;
		}
	}
	else
	{
		dif = angcomp(view_x * CONTENT_EMPTY, self.v_angle_x);
		view = self.lock_view.origin;
	}
	if (self.cam_zcheck == 0 && (self.camerastyle == STATE_TOP || self.camerastyle == AS_MELEE))
	{
		view_z = ot_z + view_z + self.camheight + SVC_INTERMISSION * frametime;
	}
	if (self.zoom_mode == IT_RELIC1)
	{
		if (self.camheight > STATE_TOP)
		{
			self.camheight = self.camheight - 0.1;
		}
		if (self.current_zoom > self.min_zoom && self.goalentity.origin_y < self.origin_y - 85)
		{
			self.current_zoom = self.current_zoom - IT_RELIC1;
			view_y = view_y - IT_RELIC2;
		}
	}
	else
	{
		if (self.zoom_mode == IT_RELIC2 && self.cam_ycheck == 0)
		{
			if (self.camheight < 0.5)
			{
				self.camheight = self.camheight + 0.1;
			}
			if (self.current_zoom < self.max_zoom)
			{
				self.current_zoom = self.current_zoom + IT_RELIC1;
				view_y = view_y + IT_RELIC2;
			}
		}
		else
		{
			if (self.current_zoom != STATE_TOP)
			{
				if (self.camheight != STATE_TOP)
				{
					self.camheight = STATE_TOP;
				}
				if (self.current_zoom < STATE_TOP)
				{
					self.current_zoom = self.current_zoom + IT_RELIC1;
					view_y = view_y + IT_RELIC2;
				}
				else
				{
					self.current_zoom = self.current_zoom - IT_RELIC1;
					view_y = view_y - IT_RELIC2;
				}
				self.cam_ycheck = 0;
			}
		}
	}
	if (self.rain_on == 1)
	{
		if (self.rain == 0)
		{
			self.rain = 1;
			if (!(self.rain_char))
			{
				rain1 = spawn();
				setmodel(rain1, "progs/rain.spr");
				setsize(rain1, VEC_ORIGIN, VEC_ORIGIN);
				setorigin(rain1, self.origin);
				if (darkplaces)
				{
					rain1.effects = EF_NODEPTHTEST;
				}
				rain1.classname = "rain1";
				rain1.movetype = MOVETYPE_NOCLIP;
				rain1.owner = self;
				rain1.frame = STATE_TOP;
				rain1.think = rain_follow;
				rain1.nextthink = time;
				rain1.drawonlytoclient = self;
				self.rain_char = rain1;
			}
			rain2 = spawn();
			setmodel(rain2, "progs/rain.spr");
			setsize(rain2, VEC_ORIGIN, VEC_ORIGIN);
			setorigin(rain2, self.origin);
			if (darkplaces)
			{
				rain2.effects = EF_NODEPTHTEST;
			}
			rain2.classname = "rain2";
			rain2.movetype = MOVETYPE_NOCLIP;
			rain2.owner = self;
			rain2.frame = IT_RELIC1;
			rain2.cnt = 100;
			rain2.think = rain_follow;
			rain2.nextthink = time;
			rain2.drawonlytoclient = self;
			rain3 = spawn();
			setmodel(rain3, "progs/rain.spr");
			setsize(rain3, VEC_ORIGIN, VEC_ORIGIN);
			setorigin(rain3, self.origin);
			if (darkplaces)
			{
				rain3.effects = EF_NODEPTHTEST;
			}
			rain3.classname = "rain3";
			rain3.movetype = MOVETYPE_NOCLIP;
			rain3.owner = self;
			rain3.frame = IT_RELIC1;
			rain3.state = 200;
			rain3.think = rain_follow;
			rain3.nextthink = time;
			rain3.drawonlytoclient = self;
		}
	}
	else
	{
		if (self.rain == 1)
		{
			self.rain = 0;
		}
	}
	if (self.telecam == 1)
	{
		view_x = self.char.origin_x;
		view_z = self.char.origin_z;
		self.telecam = 0;
	}
	if (!coop && !deathmatch)
	{
		if (framecount < SVC_SPAWNSTATIC)
		{
			self.angles_y = -90;
		}
	}
	else
	{
		if (self.angles_y != -90)
		{
			self.angles_y = -90;
		}
	}
	self.fixangle = 1;
	setorigin(self, view);
	setorigin(self.lock_view, view);
	self.test_org = self.origin;
};

void() ClientKill = 
{
};

void() ClientConnect = 
{
	local float i;
	local float j;
	players = players + IT_RELIC1;
	if (players > IT_RELIC3)
	{
		stuffcmd(self, "disconnect\n");
	}
	else
	{
		i = STATE_TOP;
		j = IT_RELIC1;
		while (i < self.colormap - IT_RELIC1)
		{
			j = j * IT_RELIC2;
			i = i + IT_RELIC1;
		}
		self.playerid = j;
		bprint("The honorable ");
		bprint(self.netname);
		bprint(" has joined.\n");
	}
};

void() ClientDisconnect = 
{
	players = players - IT_RELIC1;
	self.classname = "disconnected";
	if (self.char)
	{
		self.char.classname = "disconnected";
		remove(self.char);
	}
	if (self.lock_view)
	{
		remove(self.lock_view);
	}
	bprint(self.netname);
	bprint(" has left the realm.\n");
};

void() cursor_follow = 
{
	setorigin(self, self.owner.origin + v_up * 42);
	frameskip(0.010000);
};

void() PlayerPreThink = 
{
	local entity cursor;
	framerate = cvar("host_framerate");
	if (self.screenflash_finished > time && cvar("scratch1") == STATE_TOP && framerate == STATE_TOP)
	{
		if (self.screenflash_mode == 0)
		{
			self.weaponmodel = "progs/scrflash.mdl";
			self.screenflash_mode = 1;
		}
		else
		{
			self.weaponmodel = string_null;
			self.screenflash_mode = 0;
		}
	}
	else
	{
		if (self.screenflash_mode == 1 || framerate != STATE_TOP)
		{
			self.weaponmodel = string_null;
			self.screenflash_mode = 0;
		}
	}
	if (self.spawntime)
	{
		if (time > self.spawntime)
		{
			msg_entity = self;
			WriteByte(MSG_ONE, TE_LIGHTNING1);
			WriteEntity(MSG_ONE, self.lock_view);
			if (world.model == "maps/start.bsp")
			{
				stuffcmd(self, "gamecfg 0\n");
				stuffcmd(self, "viewsize 120\n");
				if (ext_snd_oggvorbis)
				{
					sound(self, CHAN_VOICE, "music/track2.ogg", IT_RELIC1, ATTN_NONE);
				}
				else
				{
					sound(self, CHAN_VOICE, "music/track2.wav", IT_RELIC1, ATTN_NONE);
				}
			}
			else
			{
				if (world.model == "maps/menu.bsp")
				{
					stuffcmd(self, "viewsize 120\n");
				}
				else
				{
					if (world.model == "maps/intro.bsp")
					{
						stuffcmd(self, "viewsize 120\n");
						if (ext_snd_oggvorbis)
						{
							sound(self, CHAN_VOICE, "music/track3.ogg", IT_RELIC1, ATTN_NONE);
						}
						else
						{
							sound(self, CHAN_VOICE, "music/track3.wav", IT_RELIC1, ATTN_NONE);
						}
					}
					else
					{
						stuffcmd(self, "viewsize 110\n");
					}
				}
			}
			stuffcmd(self, "sensitivity 0;crosshair 0;exec settings.cfg;\n");
			self.spawntime = STATE_TOP;
		}
	}
	if (self.char)
	{
		CheckImpulses();
		if (self.impulse != STATE_TOP)
		{
			self.impulse = STATE_TOP;
		}
		if (self.char.skin != self.skin)
		{
			self.char.skin = self.skin;
		}
		if (!deathmatch && !coop)
		{
			if (freeze_finished > time)
			{
				localcmd("host_framerate 0.001\n");
			}
			else
			{
				if (framerate != STATE_TOP)
				{
					localcmd("host_framerate 0\n");
				}
			}
		}
		if (self.shadow_time > time)
		{
			Shadows();
		}
		if (self.softshadow_time > time)
		{
			SoftShadows();
		}
		if (self.swordshadow_time > time)
		{
			SwordShadows();
		}
		if (self.speedline_time > time)
		{
			SpeedLine();
		}
		if (darkplaces)
		{
			if (!visible(self.char))
			{
				if (self.charcursor == world)
				{
					cursor = spawn();
					setmodel(cursor, "progs/cursor2.spr");
					setsize(cursor, VEC_ORIGIN, VEC_ORIGIN);
					setorigin(cursor, self.char.origin + v_up * 42);
					cursor.effects = EF_NODEPTHTEST;
					cursor.movetype = MOVETYPE_NOCLIP;
					cursor.owner = self.char;
					cursor.think = cursor_follow;
					cursor.nextthink = time;
					cursor.drawonlytoclient = self;
					self.charcursor = cursor;
				}
			}
			else
			{
				remove(self.charcursor);
				self.charcursor = world;
			}
		}
		if (self.char.health > STATE_TOP)
		{
			self.health = self.char.health;
		}
		if (self.char.health <= STATE_TOP && self.health != 1000)
		{
			self.health = 1000;
		}
		InitCamera();
	}
	else
	{
		if (self.angles_y != -90)
		{
			self.angles_y = -90;
			self.fixangle = 1;
		}
	}
};

void() PlayerPostThink = 
{
	local vector tree;
	local vector view;
	local entity e;
	if (self.currentammo != self.ammo_shells)
	{
		self.currentammo = self.ammo_shells;
	}
	if (self.origin != self.test_org && self.forcewalk_finished < time)
	{
		makevectors(self.angles);
		self.keyflags = STATE_TOP;
		tree = self.test_org - self.origin;
		if (tree_z < CONTENT_EMPTY)
		{
			self.keyflags = self.keyflags | KEY_UP;
		}
		else
		{
			if (tree_z > IT_RELIC1)
			{
				self.keyflags = self.keyflags | KEY_DOWN;
			}
		}
		if (v_right * tree < CONTENT_EMPTY)
		{
			self.keyflags = self.keyflags | KEY_RIGHT;
		}
		else
		{
			if (v_right * tree > IT_RELIC1)
			{
				self.keyflags = self.keyflags | KEY_LEFT;
			}
		}
	}
	else
	{
		self.keyflags = STATE_TOP;
	}
	setorigin(self, self.test_org);
	if (self.char)
	{
		ComboMeter();
		if (self.ammo_shells > self.char.max_mana)
		{
			self.ammo_shells = self.char.max_mana;
		}
		UnmakeSolidList();
		player_think();
	}
	if (self.button0 && world.model == "maps/start.bsp" && self.cnt == 0)
	{
		if (title1_finished > time)
		{
			return;
		}
		self.cnt = 1;
		sound(self, CHAN_VOICE, "misc/title2.wav", IT_RELIC1, ATTN_NONE);
		title1_finished = time + 1.5;
	}
	if (world.model == "maps/menu.bsp")
	{
		MenuCommands();
	}
	if (world.model == "maps/intro.bsp")
	{
		if (self.attack_finished < time)
		{
			bprint("Press attack to begin ...\n");
			self.attack_finished = time + TE_LIGHTNING2;
		}
		if (self.cnt == 0)
		{
			if (self.button0)
			{
				title1_finished = time + 1.5;
				self.cnt = 1;
				sound(self, CHAN_VOICE, "misc/title2.wav", IT_RELIC1, ATTN_NONE);
			}
		}
		else
		{
			if (title1_finished < time)
			{
				changelevel("menu");
			}
		}
		e = find(world, classname, "cameratarget");
		while (e)
		{
			view = vectoangles(e.origin - self.origin);
			self.angles = view;
			self.angles_x = view_x * CONTENT_EMPTY;
			self.fixangle = 1;
			e = find(e, classname, "cameratarget");
		}
	}
};

void() info_player_start = 
{
};

void() PutClientInServer = 
{
	local entity spawn_spot;
	spawn_spot = find(world, classname, "info_player_start");
	self.classname = "camera";
	self.health = decode(parm1, IT_RELIC1);
	self.takedamage = DAMAGE_NO;
	self.solid = SOLID_TRIGGER;
	if (!(self.lock_view))
	{
		self.lock_view = spawn();
	}
	setmodel(self.lock_view, "progs/null.spr");
	self.origin = spawn_spot.origin;
	setorigin(self.lock_view, spawn_spot.origin);
	self.movetype = MOVETYPE_NOCLIP;
	self.flags = FL_CLIENT;
	self.origin = spawn_spot.origin;
	setmodel(self, "progs/null.spr");
	setsize(self, VEC_ORIGIN, VEC_ORIGIN);
	self.view_ofs = '0 0 22';
	self.velocity = VEC_ORIGIN;
	self.modelindex = STATE_TOP;
	self.spawntime = time + 0.1;
	if (cvar("scratch3") == STATE_TOP)
	{
		self.camloose = IT_RELIC3;
	}
	else
	{
		self.camloose = STATE_TOP;
	}
	DecodeLevelParms();
	self.ammo_shells = decode(parm1, IT_RELIC2);
	if (deathmatch == 0)
	{
		self.armorvalue = decode(parm2, IT_RELIC1);
	}
	else
	{
		self.armorvalue = IT_RELIC1;
	}
	self.level = decode(parm1, AS_MELEE);
	self.skin = decode(parm2, IT_RELIC2);
	self.score = parm3;
	self.test_org = self.origin;
	if (world.model == "maps/start.bsp" || world.model == "maps/intro.bsp" || world.model == "maps/menu.bsp")
	{
		return;
	}
	self.zoom_mode = IT_RELIC2;
	self.current_zoom = STATE_TOP;
	self.min_zoom = -30;
	self.max_zoom = SVC_TEMPENTITY;
	if (players < IT_RELIC3)
	{
		Setup_Dummy();
	}
};

void() DisplayLevelThink = 
{
	makevectors(self.owner.angles);
	self.angles_x = self.angles_x + 100 * frametime;
	if (self.angles_x > 90)
	{
		remove(self);
		return;
	}
	setorigin(self, self.owner.origin + v_up * 48);
	self.nextthink = time + 0.010000;
};

void() DisplayLevel = 
{
	local entity levelu;
	levelu = spawn();
	setorigin(levelu, self.origin + v_up * 48);
	setmodel(levelu, "progs/levelup.spr");
	setsize(levelu, VEC_ORIGIN, VEC_ORIGIN);
	levelu.solid = SOLID_NOT;
	levelu.owner = self;
	levelu.takedamage = DAMAGE_NO;
	levelu.classname = "levelsign";
	levelu.movetype = MOVETYPE_NOCLIP;
	levelu.angles_y = -90;
	levelu.angles_x = -90;
	levelu.fixangle = 1;
	if (darkplaces)
	{
		levelu.effects = EF_NODEPTHTEST;
	}
	levelu.think = DisplayLevelThink;
	levelu.nextthink = time;
};

void() SetLevel = 
{
	local float NextLevelExp;
	local string h;
	if (self.owner.level < 99)
	{
		NextLevelExp = self.owner.level + SVC_PARTICLE * self.owner.level;
		if (self.owner.experience >= NextLevelExp)
		{
			sound(self, CHAN_AUTO, "misc/levelup.wav", IT_RELIC1, ATTN_NORM);
			self.owner.level = self.owner.level + IT_RELIC1;
			h = ftos(self.owner.level);
			self.max_health = 70 + TE_LAVASPLASH * (self.owner.level / IT_RELIC2);
			self.max_mana = 47 + TE_LAVASPLASH * (self.owner.level / AS_MELEE);
			self.owner.experience = STATE_TOP;
			sprint(self.owner, "çYou have ascended to level ");
			sprint(self.owner, h);
			sprint(self.owner, "\n");
			DisplayLevel();
			freeze_finished = time + TE_LIGHTNING1 * frametime;
		}
	}
};

void(float amount) GiveExperience = 
{
	local entity temp;
	if (self.enemy.classname != "player" || deathmatch == 1)
	{
		return;
	}
	temp = self;
	self = self.enemy;
	self.owner.experience = self.owner.experience + amount;
	if (self.classname == "player")
	{
		dprint("EXP Given to player\n");
	}
	else
	{
		error("EXP given to wrong entity! Debug with developer.. !!\n");
	}
	SetLevel();
	self = temp;
};


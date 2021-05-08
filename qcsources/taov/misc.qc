void(float howmuch) shake_camera = 
{
	local entity y;
	y = find(world, classname, "camera");
	while (y)
	{
		y.camshake_finished = time + howmuch;
		y = find(y, classname, "camera");
	}
	y = find(world, classname, "camera");
};

void() misc_model = 
{
	precache_model(self.model);
	setmodel(self, self.model);
};

void() ambience_speaker = 
{
	precache_sound(self.model);
	ambientsound(self.origin, self.model, IT_RELIC1, ATTN_STATIC);
};

void() model_tilt = 
{
	local vector v1;
	local vector v2;
	local vector l1;
	local vector l2;
	local vector v;
	local vector k;
	makevectors(self.angles);
	v1 = self.origin + v_forward * IT_RELIC5;
	v2 = self.origin + v_forward * -16;
	traceline(v1 + '0 0 64', v1 - '0 0 64', 1, self);
	l1 = trace_endpos;
	traceline(v2 + '0 0 64', v2 - '0 0 64', 1, self);
	l2 = trace_endpos;
	v = l1 - l2;
	k = vectoangles(v);
	self.angles_x = k_x;
};

void() ambience_river = 
{
	precache_sound("ambience/river.wav");
	ambientsound(self.origin, "ambience/river.wav", IT_RELIC1, ATTN_STATIC);
};

void() ambience_suffering = 
{
	precache_sound("misc/suffer.wav");
	ambientsound(self.origin, "misc/suffer.wav", IT_RELIC1, ATTN_STATIC);
};

void() ambience_heartbeat = 
{
	precache_sound("misc/heart.wav");
	ambientsound(self.origin, "misc/heart.wav", IT_RELIC1, ATTN_STATIC);
};

void() ambience_thunder = 
{
	precache_sound("ambience/thunder.wav");
	ambientsound(self.origin, "ambience/thunder.wav", IT_RELIC1, ATTN_NONE);
};

void() fire_remove1 = [0, fire_remove2]
{
	sound(self, CHAN_BODY, "misc/fireout.wav", IT_RELIC1, ATTN_NONE);
	self.nextthink = time + 0.05;
};

void() fire_remove2 = [1, fire_remove3]
{
	self.nextthink = time + 0.05;
};

void() fire_remove3 = [2, fire_remove4]
{
	self.nextthink = time + 0.05;
};

void() fire_remove4 = [3, fire_remove5]
{
	self.nextthink = time + 0.05;
};

void() fire_remove5 = [4, fire_remove6]
{
	self.nextthink = time + 0.05;
};

void() fire_remove6 = [5, fire_remove7]
{
	self.nextthink = time + 0.05;
};

void() fire_remove7 = [6, SUB_Remove]
{
	self.nextthink = time + 0.05;
};

void() BecomeFlame = 
{
	self.velocity = VEC_ORIGIN;
	self.movetype = MOVETYPE_NOCLIP;
	self.solid = SOLID_NOT;
	setorigin(self, self.origin + v_up * TE_LAVASPLASH);
	setmodel(self, "progs/fire.spr");
	fire_remove1();
};

void() shadow_tilt = 
{
	local vector v1;
	local vector v2;
	local vector l1;
	local vector l2;
	local vector v;
	local vector k;
	local vector p;
	p = self.owner.angles;
	p_y = 180;
	makevectors(p);
	v1 = self.owner.origin + v_forward * IT_RELIC5;
	v2 = self.owner.origin + v_forward * -16;
	traceline(v1 + '0 0 64', v1 - '0 0 64', 1, self);
	l1 = trace_endpos;
	traceline(v2 + '0 0 64', v2 - '0 0 64', 1, self);
	l2 = trace_endpos;
	v = l1 - l2;
	k = vectoangles(v);
	self.angles_x = k_x + 90;
};

void() shadow_think = 
{
	shadow_tilt();
	self.alpha = 0.5;
	self.origin_x = self.owner.origin_x;
	self.origin_y = self.owner.origin_y;
	traceline(self.owner.origin, self.origin - v_up * 9999, 1, self);
	self.origin_z = trace_endpos_z + IT_RELIC1;
	if (self.owner.health < IT_RELIC1 && self.owner.classname != "player")
	{
		remove(self);
		return;
	}
	setsize(self, VEC_ORIGIN, VEC_ORIGIN);
	self.nextthink = time + 0.010000;
};

void() spawn_shadow = 
{
	local entity s;
	s = spawn();
	s.owner = self;
	setorigin(s, s.owner.origin);
	setmodel(s, "progs/shadow.spr");
	setsize(s, VEC_ORIGIN, VEC_ORIGIN);
	s.movetype = MOVETYPE_NOCLIP;
	s.solid = SOLID_NOT;
	s.classname = "shadow";
	s.think = shadow_think;
	s.angles_x = 90;
	s.nextthink = time + 0.010000;
};

void() music_track1 = 
{
	if (cvar("temp1") == IT_RELIC1)
	{
		remove(self);
		return;
	}
	if (ext_snd_oggvorbis)
	{
		precache_sound("music/track1.ogg");
		ambientsound(VEC_ORIGIN, "music/track1.ogg", IT_RELIC1, ATTN_NONE);
	}
	else
	{
		precache_sound("music/track1.wav");
		ambientsound('-4096 4096 0', "music/track1.wav", 0.5, ATTN_NONE);
		ambientsound('4096 -4096 0', "music/track1.wav", 0.5, ATTN_NONE);
	}
	self.classname = "music";
};

void() music_track2 = 
{
	if (cvar("temp1") == IT_RELIC1)
	{
		remove(self);
		return;
	}
	if (ext_snd_oggvorbis)
	{
		precache_sound("music/track5.ogg");
		ambientsound(VEC_ORIGIN, "music/track5.ogg", IT_RELIC1, ATTN_NONE);
	}
	else
	{
		precache_sound("music/track5.wav");
		ambientsound('-4096 4096 0', "music/track5.wav", 0.5, ATTN_NONE);
		ambientsound('4096 -4096 0', "music/track5.wav", 0.5, ATTN_NONE);
	}
	self.classname = "music";
};

void() music_track3 = 
{
	if (cvar("temp1") == IT_RELIC1)
	{
		remove(self);
		return;
	}
	if (ext_snd_oggvorbis)
	{
		precache_sound("music/track6.ogg");
		ambientsound(VEC_ORIGIN, "music/track6.ogg", IT_RELIC1, ATTN_NONE);
	}
	else
	{
		precache_sound("music/track6.wav");
		ambientsound('-4096 4096 0', "music/track6.wav", 0.5, ATTN_NONE);
		ambientsound('4096 -4096 0', "music/track6.wav", 0.5, ATTN_NONE);
	}
	self.classname = "music";
};

void() music_track4 = 
{
	if (cvar("temp1") == IT_RELIC1)
	{
		remove(self);
		return;
	}
	if (ext_snd_oggvorbis)
	{
		precache_sound("music/track7.ogg");
		ambientsound(VEC_ORIGIN, "music/track7.ogg", IT_RELIC1, ATTN_NONE);
	}
	else
	{
		precache_sound("music/track7.wav");
		ambientsound('-4096 4096 0', "music/track7.wav", 0.5, ATTN_NONE);
		ambientsound('4096 -4096 0', "music/track7.wav", 0.5, ATTN_NONE);
	}
	self.classname = "music";
};

void() music_track5 = 
{
	if (cvar("temp1") == IT_RELIC1)
	{
		remove(self);
		return;
	}
	if (ext_snd_oggvorbis)
	{
		precache_sound("music/track8.ogg");
		ambientsound(VEC_ORIGIN, "music/track8.ogg", IT_RELIC1, ATTN_NONE);
	}
	else
	{
		precache_sound("music/track8.wav");
		ambientsound('-4096 4096 0', "music/track8.wav", 0.5, ATTN_NONE);
		ambientsound('4096 -4096 0', "music/track8.wav", 0.5, ATTN_NONE);
	}
	self.classname = "music";
};

void() music_track6 = 
{
	if (cvar("temp1") == IT_RELIC1)
	{
		remove(self);
		return;
	}
	if (ext_snd_oggvorbis)
	{
		precache_sound("music/track9.ogg");
		ambientsound(VEC_ORIGIN, "music/track9.ogg", IT_RELIC1, ATTN_NONE);
	}
	else
	{
		precache_sound("music/track9.wav");
		ambientsound('-4096 4096 0', "music/track9.wav", 0.5, ATTN_NONE);
		ambientsound('4096 -4096 0', "music/track9.wav", 0.5, ATTN_NONE);
	}
	self.classname = "music";
};

void() music_track7 = 
{
	if (cvar("temp1") == IT_RELIC1)
	{
		remove(self);
		return;
	}
	if (ext_snd_oggvorbis)
	{
		precache_sound("music/track10.ogg");
		ambientsound(VEC_ORIGIN, "music/track10.ogg", IT_RELIC1, ATTN_NONE);
	}
	else
	{
		precache_sound("music/track10.wav");
		ambientsound('-4096 4096 0', "music/track10.wav", 0.5, ATTN_NONE);
		ambientsound('4096 -4096 0', "music/track10.wav", 0.5, ATTN_NONE);
	}
	self.classname = "music";
};

void() music_track8 = 
{
	if (cvar("temp1") == IT_RELIC1)
	{
		remove(self);
		return;
	}
	if (ext_snd_oggvorbis)
	{
		precache_sound("music/track11.ogg");
		ambientsound(VEC_ORIGIN, "music/track11.ogg", IT_RELIC1, ATTN_NONE);
	}
	else
	{
		precache_sound("music/track11.wav");
		ambientsound('-4096 4096 0', "music/track11.wav", 0.5, ATTN_NONE);
		ambientsound('4096 -4096 0', "music/track11.wav", 0.5, ATTN_NONE);
	}
	self.classname = "music";
};

void() jblock_think = 
{
	self.enemy = find(world, classname, "player");
	if (self.enemy.origin_z > self.absmax_z + SVC_TEMPENTITY)
	{
		setorigin(self, self.origin);
		self.solid = SOLID_BSP;
	}
	else
	{
		self.solid = SOLID_NOT;
	}
	frameskip(0.1);
};

void() barrier_use = 
{
	if (self.mode == STATE_TOP)
	{
		self.solid = SOLID_BBOX;
		self.movetype = MOVETYPE_PUSH;
		setorigin(self, self.origin);
	}
	else
	{
		self.solid = SOLID_NOT;
	}
};

void() func_barrier = 
{
	if (coop || deathmatch)
	{
		remove(self);
		return;
	}
	if (!(self.targetname))
	{
		objerror("func_barrier with no target name found\n");
	}
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_PUSH;
	self.classname = "barrier";
	setmodel(self, self.model);
	setsize(self, self.mins, self.maxs);
	setorigin(self, self.origin);
	self.use = barrier_use;
	self.model = string_null;
};

void() bossmusic_think = 
{
	if (ext_snd_oggvorbis)
	{
		sound(self, CHAN_VOICE, "music/track9.ogg", IT_RELIC1, ATTN_NONE);
	}
	else
	{
		sound(self, CHAN_VOICE, "music/track9.wav", IT_RELIC1, ATTN_NONE);
	}
	self.nextthink = time + 51.2;
};

void() spawn_bossmusic = 
{
	local entity h;
	h = spawn();
	setmodel(h, string_null);
	h.solid = SOLID_NOT;
	h.classname = "bossmusic";
	h.movetype = MOVETYPE_NOCLIP;
	setorigin(h, self.origin);
	h.think = bossmusic_think;
	h.nextthink = time;
};

void() func_illusionary = 
{
	self.angles = VEC_ORIGIN;
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	setmodel(self, self.model);
	makestatic();
};

void() misc_title1_think = 
{
	if (title1_finished > time)
	{
		self.scale = self.scale + 0.010000;
	}
	if (self.mode == STATE_TOP)
	{
		if (self.origin_z > self.cnt2)
		{
			self.origin_z = self.origin_z - self.speed;
			self.speed = self.speed + 0.05;
		}
		else
		{
			self.cnt2 = self.cnt2 + 150;
			self.mode = IT_RELIC1;
		}
	}
	else
	{
		if (self.mode == IT_RELIC1)
		{
			self.origin_z = self.origin_z + self.speed;
			self.speed = self.speed - 0.1;
			if (self.speed <= STATE_TOP && self.origin_z <= self.cnt)
			{
				self.mode = IT_RELIC2;
				self.speed = STATE_TOP;
				if (title1_finished < time)
				{
					sound(self, CHAN_AUTO, "misc/title.wav", IT_RELIC1, ATTN_NONE);
				}
			}
		}
	}
	frameskip(0.010000);
};

void() misc_title1 = 
{
	precache_sound("misc/title.wav");
	precache_sound("misc/title2.wav");
	setmodel(self, "progs/title.spr");
	self.mode = STATE_TOP;
	self.speed = IT_RELIC1;
	self.cnt = self.origin_z;
	self.cnt2 = self.cnt;
	self.origin_z = self.origin_z + 300;
	self.think = misc_title1_think;
	self.nextthink = time;
	self.scale = STATE_TOP;
};

void() title2_think = 
{
	if (title1_finished > time)
	{
		self.mode = 1;
	}
	if (self.mode != 1)
	{
		if (self.attack_finished < time)
		{
			self.origin_x = self.cnt;
			self.attack_finished = time + 4.5;
		}
		self.origin_x = self.origin_x + IT_RELIC1;
	}
	else
	{
		self.origin_x = self.cnt2;
		if (self.scale > 0.010000)
		{
			self.scale = self.scale - 0.010000;
		}
	}
	if (title1_finished < time && self.mode == IT_RELIC1)
	{
		changelevel("menu");
	}
	frameskip(0.010000);
};

void() misc_title2 = 
{
	setmodel(self, "progs/title2.spr");
	self.think = title2_think;
	self.cnt2 = self.origin_x;
	self.origin_x = self.origin_x - 175;
	self.cnt = self.origin_x;
	self.nextthink = time + 0.1;
	self.scale = IT_RELIC1;
};

void() intro_dummy = 
{
	precache_model("progs/intro.spr");
	precache_model("progs/plyr.mdl");
	precache_sound("misc/title2.wav");
	if (ext_snd_oggvorbis)
	{
		precache_sound("music/track3.ogg");
	}
	else
	{
		precache_sound("music/track3.wav");
	}
	setmodel(self, "progs/plyr.mdl");
	setsize(self, '-19 -12 -19', '22 12 25');
	self.frame = TE_LIGHTNING1;
	self.classname = "cameratarget";
	droptofloor();
};

void() intro_text = 
{
	setmodel(self, "progs/intro.spr");
	self.movetype = MOVETYPE_NOCLIP;
	self.solid = SOLID_NOT;
	self.velocity_z = TE_LIGHTNING1;
};

void() func_wall_use = 
{
	remove(self);
	return;
};

void() func_wall = 
{
	self.angles = VEC_ORIGIN;
	self.movetype = MOVETYPE_PUSH;
	self.solid = SOLID_BSP;
	self.use = func_wall_use;
	setmodel(self, self.model);
};

void() MenuCommands = 
{
	local entity y;
	local entity h;
	if (self.keyflags & (KEY_DOWN | KEY_UP))
	{
		if (self.menu_debounce == 0)
		{
			y = find(world, classname, "menu");
			while (y)
			{
				if (y.menu_which == STATE_TOP)
				{
					if (self.keyflags & KEY_DOWN)
					{
						if (y.menu_choice < AS_MELEE)
						{
							y.menu_choice = y.menu_choice + IT_RELIC1;
						}
						else
						{
							y.menu_choice = STATE_TOP;
						}
					}
					else
					{
						if (self.keyflags & KEY_UP)
						{
							if (y.menu_choice > STATE_TOP)
							{
								y.menu_choice = y.menu_choice - IT_RELIC1;
							}
							else
							{
								y.menu_choice = AS_MELEE;
							}
						}
					}
				}
				else
				{
					if (y.menu_which == IT_RELIC1)
					{
						if (self.keyflags & KEY_DOWN)
						{
							if (y.menu_choice < TE_WIZSPIKE)
							{
								y.menu_choice = y.menu_choice + IT_RELIC1;
							}
							else
							{
								y.menu_choice = STATE_TOP;
							}
						}
						else
						{
							if (self.keyflags & KEY_UP)
							{
								if (y.menu_choice > STATE_TOP)
								{
									y.menu_choice = y.menu_choice - IT_RELIC1;
								}
								else
								{
									y.menu_choice = TE_WIZSPIKE;
								}
							}
						}
					}
				}
				sound(self, CHAN_AUTO, "misc/menu1.wav", IT_RELIC1, ATTN_NORM);
				y = find(y, classname, "menu");
			}
		}
		self.menu_debounce = 1;
		self.cnt2 = time + 0.05;
	}
	else
	{
		if (self.cnt2 < time)
		{
			self.menu_debounce = 0;
		}
	}
	if (self.button0)
	{
		if (self.menu_declick == 0)
		{
			h = find(world, classname, "cursor");
			y = find(world, classname, "menu");
			if (y.menu_which == STATE_TOP)
			{
				if (h.owner.menu_choice == STATE_TOP)
				{
					changelevel("map01");
				}
				else
				{
					if (h.owner.menu_choice == IT_RELIC1)
					{
						sprint(self, "Not yet implemented ...\n");
					}
					else
					{
						if (h.owner.menu_choice == IT_RELIC2)
						{
							h.owner.menu_which = IT_RELIC1;
							h.owner.menu_choice = STATE_TOP;
						}
						else
						{
							if (h.owner.menu_choice == AS_MELEE)
							{
								stuffcmd(self, "quit\n");
							}
						}
					}
				}
			}
			else
			{
				if (y.menu_which == IT_RELIC1)
				{
					if (h.owner.menu_choice == STATE_TOP)
					{
						if (menu_difficulty < IT_RELIC2)
						{
							menu_difficulty = menu_difficulty + IT_RELIC1;
							if (menu_difficulty == IT_RELIC1)
							{
								bprint("Difficulty: Hard\n");
								localcmd("skill 2\n");
							}
							else
							{
								if (menu_difficulty == IT_RELIC2)
								{
									bprint("Difficulty: Easy\n");
									localcmd("skill 0\n");
								}
							}
						}
						else
						{
							localcmd("skill 1\n");
							menu_difficulty = STATE_TOP;
							bprint("Difficulty: Medium\n");
						}
					}
					if (h.owner.menu_choice == IT_RELIC1)
					{
						if (menu_lives < IT_RELIC2)
						{
							menu_lives = menu_lives + IT_RELIC1;
							if (menu_lives == IT_RELIC1)
							{
								self.armorvalue = TE_LIGHTNING1;
								bprint("Lives: 5\n");
							}
							if (menu_lives == IT_RELIC2)
							{
								self.armorvalue = IT_RELIC1;
								bprint("Lives: 1\n");
							}
						}
						else
						{
							self.armorvalue = AS_MELEE;
							menu_lives = STATE_TOP;
							bprint("Lives: 3\n");
						}
					}
					if (h.owner.menu_choice == IT_RELIC2)
					{
						if (menu_music < IT_RELIC1)
						{
							localcmd("temp1 1\n");
							menu_music = menu_music + IT_RELIC1;
							bprint("Music: OFF\n");
						}
						else
						{
							localcmd("temp1 0\n");
							menu_music = STATE_TOP;
							bprint("Music: ON\n");
						}
					}
					if (h.owner.menu_choice == AS_MELEE)
					{
						if (menu_seizurefx < IT_RELIC1)
						{
							localcmd("scratch1 1\n");
							menu_seizurefx = menu_seizurefx + IT_RELIC1;
							bprint("Seizure Effects: OFF\n");
						}
						else
						{
							localcmd("scratch1 0\n");
							menu_seizurefx = STATE_TOP;
							bprint("Seizure Effects: ON\n");
						}
					}
					if (h.owner.menu_choice == IT_RELIC3)
					{
						if (menu_volume < AS_MELEE)
						{
							menu_volume = menu_volume + IT_RELIC1;
							if (menu_volume == IT_RELIC1)
							{
								bprint("Volume: Loud\n");
								stuffcmd(self, "volume 1\n");
							}
							if (menu_volume == IT_RELIC2)
							{
								bprint("Volume: Off\n");
								stuffcmd(self, "volume 0\n");
							}
							if (menu_volume == AS_MELEE)
							{
								bprint("Volume: Soft\n");
								stuffcmd(self, "volume 0.3\n");
							}
						}
						else
						{
							menu_volume = STATE_TOP;
							bprint("Volume: Normal\n");
							stuffcmd(self, "volume 0.5\n");
						}
					}
					if (h.owner.menu_choice == TE_LIGHTNING1)
					{
						if (menu_ccounter < IT_RELIC1)
						{
							localcmd("scratch2 1\n");
							menu_ccounter = menu_ccounter + IT_RELIC1;
							bprint("Combo Counter: OFF\n");
						}
						else
						{
							localcmd("scratch2 0\n");
							menu_ccounter = STATE_TOP;
							bprint("Combo Counter: ON\n");
						}
					}
					if (h.owner.menu_choice == TE_LIGHTNING2)
					{
						if (menu_camera < IT_RELIC1)
						{
							localcmd("scratch3 1\n");
							menu_camera = menu_camera + IT_RELIC1;
							bprint("Camera: Static\n");
						}
						else
						{
							localcmd("scratch3 0\n");
							menu_camera = STATE_TOP;
							bprint("Camera: Dynamic\n");
						}
					}
					if (h.owner.menu_choice == TE_WIZSPIKE)
					{
						h.owner.menu_which = STATE_TOP;
						h.owner.menu_choice = STATE_TOP;
					}
				}
			}
			sound(self, CHAN_AUTO, "misc/menu2.wav", IT_RELIC1, ATTN_NORM);
			self.menu_declick = 1;
		}
		h = find(h, classname, "cursor");
	}
	else
	{
		self.menu_declick = 0;
	}
};

void() cursor_think = 
{
	if (self.attack_finished < time)
	{
		if (self.frame < TE_TELEPORT)
		{
			self.frame = self.frame + IT_RELIC1;
		}
		else
		{
			self.frame = STATE_TOP;
		}
		self.attack_finished = time + 0.1;
		if (self.mode == 0)
		{
			self.scale = self.scale + 0.05;
			if (self.scale > 1.3)
			{
				self.mode = 1;
			}
		}
		else
		{
			self.scale = self.scale - 0.05;
			if (self.scale < 0.7)
			{
				self.mode = 0;
			}
		}
	}
	if (self.origin_y != self.owner.origin_y)
	{
		self.origin_y = self.owner.origin_y;
	}
	if (self.owner.menu_which == STATE_TOP)
	{
		self.origin_x = self.owner.origin_x + 57;
		if (self.owner.menu_choice == STATE_TOP)
		{
			self.origin_z = self.owner.origin_z - 50;
		}
		else
		{
			if (self.owner.menu_choice == IT_RELIC1)
			{
				self.origin_z = self.owner.origin_z - 65;
			}
			else
			{
				if (self.owner.menu_choice == IT_RELIC2)
				{
					self.origin_z = self.owner.origin_z - 80;
				}
				else
				{
					if (self.owner.menu_choice == AS_MELEE)
					{
						self.origin_z = self.owner.origin_z - 95;
					}
				}
			}
		}
	}
	else
	{
		if (self.owner.menu_which == IT_RELIC1)
		{
			if (self.owner.menu_choice != TE_WIZSPIKE)
			{
				self.origin_x = self.owner.origin_x + 65;
			}
			else
			{
				self.origin_x = self.owner.origin_x + 40;
			}
			if (self.owner.menu_choice == STATE_TOP)
			{
				self.origin_z = self.owner.origin_z - TE_LAVASPLASH;
			}
			else
			{
				if (self.owner.menu_choice == IT_RELIC1)
				{
					self.origin_z = self.owner.origin_z - SVC_SIGNONNUM;
				}
				else
				{
					if (self.owner.menu_choice == IT_RELIC2)
					{
						self.origin_z = self.owner.origin_z - 39;
					}
					else
					{
						if (self.owner.menu_choice == AS_MELEE)
						{
							self.origin_z = self.owner.origin_z - 52;
						}
						else
						{
							if (self.owner.menu_choice == IT_RELIC3)
							{
								self.origin_z = self.owner.origin_z - 65;
							}
							else
							{
								if (self.owner.menu_choice == TE_LIGHTNING1)
								{
									self.origin_z = self.owner.origin_z - 80;
								}
								else
								{
									if (self.owner.menu_choice == TE_LIGHTNING2)
									{
										self.origin_z = self.owner.origin_z - 95;
									}
									else
									{
										if (self.owner.menu_choice == TE_WIZSPIKE)
										{
											self.origin_z = self.owner.origin_z - 115;
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
	self.nextthink = time + 0.010000;
};

void() menuscreen_think = 
{
	if (self.menu_which == STATE_TOP)
	{
		setmodel(self, "progs/menu1.spr");
	}
	else
	{
		if (self.menu_which == IT_RELIC1)
		{
			setmodel(self, "progs/menu2.spr");
		}
	}
	self.nextthink = time + 0.010000;
};

void() misc_menu1 = 
{
	local entity cursor;
	precache_model("progs/menu1.spr");
	precache_model("progs/menu2.spr");
	precache_model("progs/cursor.spr");
	precache_sound("misc/menu1.wav");
	precache_sound("misc/menu2.wav");
	self.classname = "menu";
	self.think = menuscreen_think;
	self.nextthink = time + 0.010000;
	if (ext_snd_oggvorbis)
	{
		precache_sound("music/track4.ogg");
		ambientsound(VEC_ORIGIN, "music/track4.ogg", IT_RELIC1, ATTN_NONE);
	}
	else
	{
		precache_sound("music/track4.wav");
		ambientsound(VEC_ORIGIN, "music/track4.wav", IT_RELIC1, ATTN_NONE);
	}
	cursor = spawn();
	cursor.owner = self;
	cursor.classname = "cursor";
	setorigin(cursor, self.origin);
	setmodel(cursor, "progs/cursor.spr");
	cursor.scale = IT_RELIC1;
	cursor.think = cursor_think;
	cursor.nextthink = time + 0.010000;
};


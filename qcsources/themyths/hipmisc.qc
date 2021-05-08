void() play_sound_use = 
{
	if (self.spawnflags & 1)
	{
		if (self.state == 0)
		{
			self.state = 1;
			sound(self, self.impulse, self.noise, self.volume, self.speed);
		}
		else
		{
			self.state = 0;
			sound(self, self.impulse, "misc/null.wav", self.volume, self.speed);
		}
	}
	else
	{
		sound(self, self.impulse, self.noise, self.volume, self.speed);
	}
};

void() PlaySoundThink = 
{
	local float t;
	t = self.wait * random();
	if (t < self.delay)
	{
		t = self.delay;
	}
	self.nextthink = time + t;
	play_sound_use();
};

void() play_sound_triggered = 
{
	precache_sound(self.noise);
	precache_sound("misc/null.wav");
	if (self.volume == 0)
	{
		self.volume = 1;
	}
	if (self.speed == 0)
	{
		self.speed = 1;
	}
	if (self.speed == CONTENT_EMPTY)
	{
		self.speed = 0;
	}
	if (self.spawnflags & 1)
	{
		if (self.impulse == 0)
		{
			self.impulse = MOVETYPE_PUSH;
		}
	}
	self.use = play_sound_use;
};

void() play_sound = 
{
	local float t;
	play_sound_triggered();
	if (self.wait == 0)
	{
		self.wait = 20;
	}
	if (self.delay == 0)
	{
		self.delay = FL_SWIM;
	}
	self.think = PlaySoundThink;
	t = self.wait * random();
	if (t < self.delay)
	{
		t = self.delay;
	}
	self.nextthink = time + t;
};

void() random_thunder = 
{
	self.noise = "ambience/thunder1.wav";
	play_sound();
	self.impulse = MOVETYPE_TOSS;
};

void() random_thunder_triggered = 
{
	self.noise = "ambience/thunder1.wav";
	play_sound_triggered();
	self.impulse = MOVETYPE_TOSS;
};

void() ambient_humming = 
{
	if (self.volume == 0)
	{
		self.volume = SERVO_VOLUME;
	}
	precache_sound("ambient/humming.wav");
	ambientsound(self.origin, "ambient/humming.wav", self.volume, ATTN_STATIC);
};

void() ambient_rushing = 
{
	if (self.volume == 0)
	{
		self.volume = SERVO_VOLUME;
	}
	precache_sound("ambient/rushing.wav");
	ambientsound(self.origin, "ambient/rushing.wav", self.volume, ATTN_STATIC);
};

void() ambient_running_water = 
{
	if (self.volume == 0)
	{
		self.volume = SERVO_VOLUME;
	}
	precache_sound("ambient/runwater.wav");
	ambientsound(self.origin, "ambient/runwater.wav", self.volume, ATTN_STATIC);
};

void() ambient_fan_blowing = 
{
	if (self.volume == 0)
	{
		self.volume = SERVO_VOLUME;
	}
	precache_sound("ambient/fanblow.wav");
	ambientsound(self.origin, "ambient/fanblow.wav", self.volume, ATTN_STATIC);
};

void() ambient_waterfall = 
{
	if (self.volume == 0)
	{
		self.volume = SERVO_VOLUME;
	}
	precache_sound("ambient/waterfal.wav");
	ambientsound(self.origin, "ambient/waterfal.wav", self.volume, ATTN_STATIC);
};

void() ambient_riftpower = 
{
	if (self.volume == 0)
	{
		self.volume = SERVO_VOLUME;
	}
	precache_sound("ambient/riftpowr.wav");
	ambientsound(self.origin, "ambient/riftpowr.wav", self.volume, ATTN_STATIC);
};

void() info_command = 
{
	if (self.message)
	{
		localcmd(self.message);
	}
};

void() effect_teleport_use = 
{
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_TELEPORT);
	WriteCoord(MSG_BROADCAST, self.origin_x);
	WriteCoord(MSG_BROADCAST, self.origin_y);
	WriteCoord(MSG_BROADCAST, self.origin_z);
	sound(self, CHAN_VOICE, "misc/r_tele1.wav", 1, ATTN_NORM);
};

void() effect_teleport = 
{
	precache_sound("misc/r_tele1.wav");
	self.use = effect_teleport_use;
};

void(entity me, entity camera) UpdateCamera = 
{
	msg_entity = me;
	WriteByte(MSG_ONE, SVC_UPDATEENTITY | 15);
	WriteByte(MSG_ONE, FL_GODMODE);
	WriteEntity(MSG_ONE, camera);
	WriteCoord(MSG_ONE, camera.origin_x);
	WriteCoord(MSG_ONE, camera.origin_y);
	WriteCoord(MSG_ONE, camera.origin_z);
};

void() effect_finale_use = 
{
	local entity pos;
	local entity pl;
	local entity targ;
	local entity temp;
	if (self.state == 1)
	{
		return;
	}
	self.state = 1;
	pos = find(world, targetname, self.target);
	if (!pos)
	{
		error("no target in finale");
	}
	WriteByte(MSG_ALL, SVC_CUTSCENE);
	WriteString(MSG_ALL, "");
	if (!(self.spawnflags & FL_SWIM))
	{
		if (self.spawnflags & 1)
		{
			pl = find(world, classname, "player");
			targ = find(world, targetname, self.mdl);
			become_decoy(targ.target, pl.origin);
		}
		else
		{
			targ = find(world, targetname, self.mdl);
			become_decoy(targ.target, targ.origin);
		}
	}
	pl = find(world, classname, "player");
	while (pl != world)
	{
		pl.view_ofs = VEC_ORIGIN;
		other.v_angle = pos.mangle;
		pl.angles = pos.mangle;
		pl.mangle = pos.mangle;
		pl.fixangle = 1;
		pl.trigger_field = self;
		pl.nextthink = time + SERVO_VOLUME;
		pl.takedamage = DAMAGE_NO;
		pl.solid = SOLID_NOT;
		pl.movetype = MOVETYPE_NONE;
		pl.modelindex = 0;
		setorigin(pl, pos.origin);
		pl.origin = pos.origin;
		pl.oldorigin = pos.origin;
		UpdateCamera(pl, pl);
		UpdateCamera(pl, pl.trigger_field);
		pl = find(pl, classname, "player");
	}
	if (self.spawnfunction)
	{
		self.nextthink = time + self.wait;
		self.think = self.spawnfunction;
	}
};

void() effect_finale = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	setorigin(self, self.origin);
	self.angles = self.mangle;
	self.use = effect_finale_use;
	self.state = 0;
};

void() info_startendtext_use = 
{
	intermission_running = 1;
	ExitIntermission();
};

void() info_startendtext = 
{
	self.use = info_startendtext_use;
};


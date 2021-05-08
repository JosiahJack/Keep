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
	s.effects = o.effects;
	s.items = o.items;
	s.gunitems = o.gunitems;
	if (o.invincible_finished > time)
	{
		s.invincible_finished = o.invincible_finished - time;
	}
	else
	{
		o.invincible_finished = 0;
	}
	if (o.invisible_finished > time)
	{
		s.invisible_finished = o.invisible_finished - time;
	}
	else
	{
		o.invisible_finished = 0;
	}
	if (o.super_damage_finished > time)
	{
		s.super_damage_finished = o.super_damage_finished - time;
	}
	else
	{
		o.super_damage_finished = 0;
	}
	if (o.radsuit_finished > time)
	{
		s.radsuit_finished = o.radsuit_finished - time;
	}
	else
	{
		o.radsuit_finished = 0;
	}
	if (o.invincible_time == 1)
	{
		s.invincible_time = 1;
	}
	else
	{
		if (o.invincible_time > 1)
		{
			s.invincible_time = o.invincible_time - time;
		}
		else
		{
			o.invincible_time = 0;
		}
	}
	if (o.invisible_time == 1)
	{
		s.invisible_time = 1;
	}
	else
	{
		if (o.invisible_time > 1)
		{
			s.invisible_time = o.invisible_time - time;
		}
		else
		{
			o.invisible_time = 0;
		}
	}
	if (o.super_time > time)
	{
		s.super_time = 1;
	}
	else
	{
		if (o.super_time > 1)
		{
			s.super_time = o.super_time - time;
		}
		else
		{
			o.super_time = 0;
		}
	}
	if (o.rad_time == 1)
	{
		s.rad_time = 1;
	}
	else
	{
		if (o.rad_time > 1)
		{
			s.rad_time = o.rad_time - time;
		}
		else
		{
			o.rad_time = 0;
		}
	}
	setorigin(s, o.origin);
};

void() name_player = 
{
	local entity play;
	self.owner.classname = "player";
	stuffcmd(self.owner, "-forward\n");
	remove(self);
};

void() go_back = 
{
	local entity t;
	local entity c;
	local entity d;
	local entity cvars;
	local entity old;
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
	c.weaponframe = 0;
	c.weaponmodel = t.weaponmodel;
	c.flags = t.flags;
	c.effects = t.effects;
	c.items = t.items;
	c.gunitems = t.gunitems;
	if (t.invincible_finished > 0)
	{
		c.invincible_finished = time + t.invincible_finished;
	}
	if (t.invisible_finished > 0)
	{
		c.invisible_finished = time + t.invisible_finished;
	}
	if (t.super_damage_finished > 0)
	{
		c.super_damage_finished = time + t.super_damage_finished;
	}
	if (t.radsuit_finished > 0)
	{
		c.radsuit_finished = time + t.radsuit_finished;
	}
	if (t.invincible_time > 0)
	{
		c.invincible_time = time + t.invincible_time;
	}
	if (t.invisible_time > 0)
	{
		c.invisible_time = time + t.invisible_time;
	}
	if (t.super_time > 0)
	{
		c.super_time = time + t.super_time;
	}
	if (t.rad_time > 0)
	{
		c.rad_time = time + t.rad_time;
	}
	c.fixangle = 1;
	c.takedamage = DAMAGE_AIM;
	c.solid = SOLID_SLIDEBOX;
	c.movetype = MOVETYPE_WALK;
	c.think = SUB_Null;
	c.air_finished = time + STAT_TOTALMONSTERS;
	d = spawn();
	d.nextthink = time + 0.010000;
	d.owner = c;
	d.think = name_player;
	if (c.ideal_yaw == CONTENT_EMPTY)
	{
		cvars = find(world, classname, "cvar_done");
		while (cvars != world)
		{
			if (!(cvars.message))
			{
				cvars.message = cvars.model;
			}
			cvar_set(cvars.netname, cvars.script);
			old = cvars;
			cvars = find(cvars, classname, "cvar_done");
			remove(old);
		}
		c.ideal_yaw = 0;
	}
	val = ftos(c.cnt);
	cvar_set("viewsize", val);
	stuffcmd(c, "sizedown\nsizeup\n");
	t.nextthink = time + 0.1;
	t.think = SUB_Remove;
	remove(self);
};

void() look_ahead = 
{
	local vector v_ang;
	local vector looky;
	self.angles = self.oldorigin;
	self.velocity = self.mangle;
	self.fixangle = 1;
	cvar_set("viewsize", "120");
	if (self.delay == 0)
	{
		looky_x = self.movedir_x - self.origin_x;
		looky_y = self.movedir_y - self.origin_y;
		looky_z = self.origin_z - self.movedir_z;
		self.oldorigin = vectoangles(looky);
	}
};

void(vector tdest, float tspeed, entity cam) DHM_CalcMove = 
{
	local vector vdestdelta;
	local float len;
	local float traveltime;
	self.finaldest = tdest;
	self.think = DHM_CalcMoveDone;
	if (tdest == cam.origin)
	{
		cam.mangle = VEC_ORIGIN;
		cam.velocity = VEC_ORIGIN;
		self.nextthink = time + 0.010000;
		return;
	}
	vdestdelta = tdest - cam.origin;
	len = vlen(vdestdelta);
	traveltime = len / tspeed;
	if (traveltime < 0.1)
	{
		cam.mangle = VEC_ORIGIN;
		cam.velocity = VEC_ORIGIN;
		self.nextthink = time + 0.010000;
		return;
	}
	self.nextthink = time + traveltime;
	cam.velocity = cam.mangle = vdestdelta * (1 / traveltime);
};

void() wait_camera = 
{
	if (!(self.wait))
	{
		move_camera();
		return;
	}
	self.nextthink = time + self.wait;
	self.think = move_camera;
};

void() DHM_CalcMoveDone = 
{
	if (self.enemy.classname != "camera")
	{
		remove(self);
		return;
	}
	setorigin(self.enemy, self.finaldest);
	self.enemy.mangle = VEC_ORIGIN;
	self.enemy.velocity = VEC_ORIGIN;
	if (self.cnt == CONTENT_EMPTY)
	{
		remove(self);
		return;
	}
	self.nextthink = time + 0.010000;
	self.think = wait_camera;
};

void() move_camera = 
{
	local entity cpt;
	local entity fpt;
	local vector looky;
	if (self.enemy.classname != "camera")
	{
		remove(self);
		return;
	}
	cpt = find(world, targetname, self.target);
	if (!(cpt.target))
	{
		self.think = SUB_Null;
		self.enemy.velocity = VEC_ORIGIN;
		self.enemy.mangle = VEC_ORIGIN;
		DHM_CalcMoveDone();
		self.cnt = CONTENT_EMPTY;
	}
	if (cpt.focal_point)
	{
		fpt = find(world, targetname, cpt.focal_point);
		if (!fpt)
		{
			objerror("Couldn't find new focal point!");
		}
		self.enemy.movedir = fpt.origin;
		looky_x = self.enemy.movedir_x - self.enemy.origin_x;
		looky_y = self.enemy.movedir_y - self.enemy.origin_y;
		looky_z = self.enemy.origin_z - self.enemy.movedir_z;
		self.enemy.oldorigin = vectoangles(looky);
		self.enemy.angles = self.enemy.oldorigin;
	}
	if (cpt.delay)
	{
		self.enemy.delay = cpt.delay;
	}
	else
	{
		self.enemy.delay = 0;
	}
	self.target = cpt.target;
	self.wait = cpt.wait;
	if (cpt.speed)
	{
		self.speed = cpt.speed;
	}
	DHM_CalcMove(cpt.origin, self.speed, self.enemy);
};

void() go_camera = 
{
	local entity control;
	local vector looky;
	self.classname = "camera";
	self.velocity = VEC_ORIGIN;
	self.view_ofs = VEC_ORIGIN;
	looky_x = self.movedir_x - self.enemy.origin_x;
	looky_y = self.movedir_y - self.enemy.origin_y;
	looky_z = self.enemy.origin_z - self.movedir_z;
	self.oldorigin = vectoangles(looky);
	self.angles = self.oldorigin;
	if (self.enemy.delay)
	{
		self.delay = self.enemy.delay;
	}
	else
	{
		self.delay = 0;
	}
	self.mangle = VEC_ORIGIN;
	self.velocity = VEC_ORIGIN;
	self.dmg = 0;
	self.fixangle = 1;
	self.movetype = MOVETYPE_NOCLIP;
	self.takedamage = DAMAGE_NO;
	self.effects = 0;
	self.items = 0;
	self.weaponmodel = "";
	if (self.enemy.target)
	{
		control = spawn();
		control.classname = "camcontrol";
		control.enemy = self;
		control.target = self.enemy.target;
		control.speed = self.enemy.speed;
		control.nextthink = time + self.enemy.wait + 0.05;
		control.think = move_camera;
	}
	if (!(self.script))
	{
		dprint("trigger_camera needs a script number!");
	}
	self.script_count = 0;
	self.cnt = cvar("viewsize");
	cvar_set("viewsize", "120");
	stuffcmd(self, "sizedown\nsizeup\n");
	setorigin(self, self.enemy.origin);
};

void() camera_touch = 
{
	local entity t;
	local entity fpt;
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
	t = find(world, targetname, self.target);
	while (t != world && t.classname != "info_movie_camera")
	{
		t = find(t, targetname, self.target);
	}
	if (!t)
	{
		return;
	}
	if (other.flags & FL_ONGROUND)
	{
		other.flags = other.flags - FL_ONGROUND;
	}
	spawn_dummy(other);
	t = find(world, targetname, self.target);
	while (t != world && t.classname != "info_movie_camera")
	{
		t = find(t, targetname, self.target);
	}
	if (!t)
	{
		objerror("couldn't find target");
	}
	fpt = find(world, targetname, self.focal_point);
	if (!fpt)
	{
		objerror("You must have a focal point!\n");
	}
	else
	{
		other.movedir = fpt.origin;
	}
	other.enemy = t;
	other.script = self.script;
	other.script_delay = self.script_delay;
	fpt = self;
	self = other;
	go_camera();
	self = fpt;
	activator = self;
	SUB_UseTargets();
	self.cnt = CONTENT_EMPTY;
	self.nextthink = time + 0.1;
	self.think = SUB_Remove;
};

void() imc_touch = 
{
	local string temps;
	if (other.classname != "camera")
	{
		return;
	}
	temps = self.target;
	self.target = self.message;
	SUB_UseTargets();
	self.target = temps;
	if (self.cnt)
	{
		return;
	}
	self.think = SUB_Remove;
	self.nextthink = time + MOVETYPE_BOUNCE;
	self.solid = SOLID_NOT;
};

void() info_movie_camera = 
{
	self.solid = SOLID_TRIGGER;
	setorigin(self, self.origin);
	setsize(self, '-8 -8 -8', '8 8 8');
	self.touch = imc_touch;
};

void() camera_use = 
{
	self.nextthink = time + 100000;
	force_retouch = FL_SWIM;
	self.think = SUB_Null;
};

void() gocam_use = 
{
	local entity control;
	local entity temp;
	control = find(world, classname, "camcontrol");
	if (control == world)
	{
		dprint("Can't find camcontrol!\n");
	}
	temp = self;
	self = control;
	DHM_CalcMoveDone();
	self = temp;
	self.nextthink = time + 0.1;
	self.think = SUB_Remove;
};

void() trigger_gocamera = 
{
	self.use = gocam_use;
};

void() info_focal_point = 
{
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
		objerror("Camera trigger with no target");
	}
	self.use = camera_use;
};

void() Script_play = 
{
	local entity scrpt;
	local entity temp;
	scrpt = find(world, script_num, self.script);
	if (!scrpt)
	{
		dprint("Error: script not found!");
	}
	if (scrpt.target)
	{
		temp = self;
		self = scrpt;
		SUB_UseTargets();
		self.target = string_null;
		self = temp;
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
			scrpt.nextthink = time + MOVETYPE_WALK;
			scrpt.classname = "going_back";
			scrpt.think = go_back;
		}
	}
	return;
};

void() info_script = 
{
};

void() change_cvar = 
{
	local entity check;
	cvar_set(self.netname, self.message);
	bprint("\n\n\n\n");
	self.classname = "cvar_done";
	check = find(world, classname, "player");
	if (!check)
	{
		check = find(world, classname, "camera");
	}
	check.ideal_yaw = CONTENT_EMPTY;
	self.nextthink = time + 0.020000;
	self.think = SUB_UseTargets;
};

void() cvarset_touch = 
{
	if (self.cnt > time || other.health <= 0 || other.classname != "player")
	{
		return;
	}
	change_cvar();
};

void() trigger_cvarset = 
{
	if (deathmatch || coop)
	{
		remove(self);
	}
	InitTrigger();
	self.use = change_cvar;
};

void() gravity_use = 
{
	if (self.cnt == CONTENT_EMPTY)
	{
		self.cnt = 0;
	}
	else
	{
		self.cnt = CONTENT_EMPTY;
	}
};

void() gravity_touch = 
{
	if (self.cnt == CONTENT_EMPTY)
	{
		return;
	}
	if (other.deadflag < FL_SWIM)
	{
		if (other.velocity_z != 0)
		{
			if (other.movetype != MOVETYPE_FLYMISSILE)
			{
				if (other.classname != "BloodCube")
				{
					other.velocity_z = other.velocity_z + self.delay * frametime;
				}
			}
		}
	}
};

void() trigger_gravity = 
{
	local float worldGravity;
	InitTrigger();
	worldGravity = cvar("sv_gravity");
	self.delay = worldGravity - self.gravity;
	self.touch = gravity_touch;
	if (self.targetname)
	{
		self.cnt = CONTENT_EMPTY;
		self.use = gravity_use;
	}
};

void() q_trig = 
{
	SUB_UseTargets();
	remove(self);
};

void() kick_me = 
{
	local float n;
	local entity play;
	if (self.cnt < time)
	{
		remove(self);
	}
	play = find(world, classname, "player");
	if (!play)
	{
		return;
	}
	if (!(play.flags & FL_ONGROUND))
	{
		self.nextthink = time + 0.15;
		if (self.delay < time)
		{
			self.delay = time + MOVETYPE_WALK;
			sound(play, CHAN_AUTO, "misc/rumble.wav", 1, ATTN_NORM);
		}
		return;
	}
	if (self.delay < time)
	{
		self.delay = time + MOVETYPE_WALK;
		sound(play, CHAN_AUTO, "misc/rumble.wav", 1, ATTN_NORM);
	}
	n = self.dmg / FL_SWIM;
	play.punchangle_x = random() * self.dmg - n;
	play.punchangle_y = random() * self.dmg - n;
	play.punchangle_z = random() * self.dmg - n;
	self.nextthink = time + 0.15;
	self.think = kick_me;
};

void() tq_use = 
{
	local entity kicker;
	if (activator.health <= 0 || activator.classname != "player")
	{
		return;
	}
	kicker = spawn();
	kicker.cnt = time + self.wait;
	kicker.delay = 0;
	kicker.dmg = self.dmg;
	kicker.nextthink = time + 0.2;
	kicker.think = kick_me;
	q_trig();
};

void() tq_touch = 
{
	local entity kicker;
	if (other.health <= 0 || other.classname != "player")
	{
		return;
	}
	kicker = spawn();
	kicker.cnt = time + self.wait;
	kicker.delay = 0;
	kicker.dmg = self.dmg;
	kicker.nextthink = time + 0.2;
	kicker.think = kick_me;
	q_trig();
};

void() trigger_quake = 
{
	if (deathmatch || coop)
	{
		self.think = q_trig;
		self.nextthink = time + 0.5;
		return;
	}
	precache_sound2("misc/rumble.wav");
	InitTrigger();
	self.use = tq_use;
	self.touch = tq_touch;
};


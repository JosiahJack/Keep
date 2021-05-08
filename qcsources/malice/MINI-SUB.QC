void () TrackTarget;

void () SubTouch =
{
	if (!(other.flags & FL_INWATER))
		return;
	if ((other.classname != "player"))
		return;
	if (((other.tools == (other.tools | UT_MINISUB)) || (other.tools == (other.tools | UT_BIGASSGUN))))
		return;
	if ((other.probe_active == TRUE))
		return;
	if ((other.health <= 0))
		return;
	sound (other, CHAN_BODY, self.noise, 1.00, ATTN_NORM);
	sound (other, CHAN_VOICE, "sub/ping.wav", 0.3, ATTN_NORM);
	self.solid = SOLID_NOT;
	stuffcmd (other, "cl_forwardspeed 550\n");
	other.cl_forwardspeed = CHT_SUBSPEED;
	stuffcmd (other, "cl_bob 0\n");
	if (!(other.speed & CHSCAM_ON))
		other.weaponmodel = "progs/subpit.mdl";
	other.tools = (other.tools | UT_MINISUB);
	self.model = string_null;
	setmodel (other, "progs/mini-sub.mdl");
	setsize (other, VEC_HULL2_MIN, '32 32 32');
	setorigin (other, self.origin);
	makevectors (self.angles);
	other.angles = self.angles;
	other.angles_x = 0;
	other.angles_z = 0;
	other.fixangle = TRUE;
	other.walkframe = 0;
	remove (self);
};


void () become_active =
{
	if ((pointcontents (self.origin) == CONTENT_WATER))
	{
		self.solid = SOLID_BBOX;
		setsize (self, '-45 -45 -24', '45 45 32');
		self.movetype = MOVETYPE_NONE;
		self.owner = self;
		self.think = SUB_Null;
	}
	self.nextthink = time;
};


void () exit_vehicle =
{
	local entity sub;

	self.old_position = self.velocity;
	sound (self, CHAN_VOICE, "misc/null.wav", 1.00, ATTN_NORM);
	makevectors (self.v_angle);
	if ((self.waterlevel >= 2))
		self.velocity_z = 1000;
	else
		self.velocity_z = 500;
	self.velocity_x = self.old_position_x;
	self.velocity_y = self.old_position_y;
	setmodel (self, "progs/player.mdl");
	setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
	self.angles_x = 0;
	self.angles_z = 0;
	self.fixangle = TRUE;
	self.tools = (self.tools - (self.tools & UT_MINISUB));
	stuffcmd (self, "cl_bob 0.01\n");
	if (!(self.flags & FL_INWATER))
	{
		stuffcmd (self, "cl_forwardspeed 360\n");
		self.cl_forwardspeed = CHT_NORMSPEED;
	}
	else
	{
		if ((self.tools == (self.tools | UT_SCUBA)))
		{
			stuffcmd (self, "cl_forwardspeed 420\n");
			self.cl_forwardspeed = CHT_SCUBASPEED;
		}
		else
		{
			stuffcmd (self, "cl_forwardspeed 360\n");
			self.cl_forwardspeed = CHT_NORMSPEED;
		}
	}
	sub = spawn ();
	sub.movetype = MOVETYPE_TOSS;
	sub.solid = SOLID_BBOX;
	sub.touch = SubTouch;
	sub.enemy = self;
	sub.owner = self;
	makevectors (self.angles);
	sub.noise = "utils/hoveron.wav";
	sub.angles = self.angles;
	setmodel (sub, "progs/mini-sub.mdl");
	setorigin (sub, self.origin);
	sub.nextthink = (time + 0.5);
	sub.think = become_active;
	sub.colormap = self.colormap;
	sub.velocity_x = (self.old_position_x * -0.3);
	sub.velocity_y = (self.old_position_y * -0.3);
	sub.velocity_z = 300;
	self.walkframe = 0;
	self.air_finished = (time + 12);
	W_SetCurrentAmmo ();
	player_run ();
};


void () utility_prop =
{
	self.touch = SubTouch;
	precache_model ("progs/subpit.mdl");
	precache_model ("progs/mini-sub.mdl");
	precache_model ("progs/sight.mdl");
	precache_sound ("sub/throttle.wav");
	precache_sound ("sub/ping.wav");
	precache_sound ("damage/subpain.wav");
	precache_sound ("sub/locked.wav");
	precache_sound ("sub/lockon.wav");
	self.noise = "utils/hoveron.wav";
	setmodel (self, "progs/mini-sub.mdl");
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_BBOX;
	self.netname = "Mini-Sub";
	self.tools = UT_MINISUB;
	setsize (self, VEC_HULL2_MIN, '32 32 32');
	StartItem ();
};

void (vector where) make_bub;

void () HomeTarget =
{
	local vector dir;
	local vector plane;
	local vector trajectory;

	if ((self.owner.tools != (self.owner.tools | UT_MINISUB)))
	{
		self.nextthink = time;
		self.think = T_TorpTouch;
		return;
	}
	if ((self.enemy.health <= 0))
	{
		self.think = TrackTarget;
		self.nextthink = time;
		return;
	}
	dir = normalize ((self.enemy.origin - self.origin));
	plane = normalize (self.velocity);
	trajectory = normalize (((10 * plane) + dir));
	if ((self.enemy.tools == (self.enemy.tools | UT_MINISUB)))
		self.velocity = (trajectory * 376);
	else
	{
		if ((self.enemy.tools == (self.enemy.tools | UT_SCUBA)))
			self.velocity = (trajectory * 292);
		else
			self.velocity = (trajectory * 252);
	}
	self.angles = vectoangles (self.velocity);
	self.nextthink = time;
	if ((self.frame == 1))
		self.frame = 0;
	else
		self.frame = 1;
	if ((random () < 0.06))
		make_bub (self.origin);
	if ((pointcontents (self.origin) != CONTENT_WATER))
	{
		self.nextthink = (time + 0.8);
		self.think = BecomeReal;
	}
};


void () sightthink =
{
	local vector dir;

	dir = normalize ((self.owner.owner.origin - self.owner.enemy.origin));
	setorigin (self, (((dir * -7) + self.owner.owner.origin) + '0 0 22'));
	self.nextthink = time;
	self.angles_x = (0 - self.owner.owner.v_angle_x);
	self.angles_y = self.owner.owner.v_angle_y;
	self.angles_z = 0;
	if (((self.owner.owner.health < 1) || (self.owner.owner.tools != (self.owner.owner.tools | UT_MINISUB))))
	{
		self.think = SUB_Null;
		remove (self);
	}
};


void () makesight =
{
	local entity sight1;

	sight1 = spawn ();
	sight1.owner = self;
	sight1.solid = SOLID_NOT;
	sight1.classname = "grid";
	sight1.movetype = MOVETYPE_NOCLIP;
	setmodel (sight1, "progs/sight.mdl");
	setsize (sight1, VEC_ORIGIN, VEC_ORIGIN);
	sight1.think = sightthink;
	sight1.nextthink = time;
	self.holo_owner = sight1;
};


void () killdatarget =
{
	if (self.holo_owner)
		self.holo_owner.think = SUB_Remove;
	T_TorpTouch ();
};


void () TrackTarget =
{
	local entity targ;

	if ((self.owner.tools != (self.owner.tools | UT_MINISUB)))
	{
		self.nextthink = time;
		self.think = T_TorpTouch;
		return;
	}
	if (self.holo_owner)
		self.holo_owner.think = SUB_Remove;
	targ = findradius (self.origin, 1000);
	while (targ)
	{
		visible (targ);
		if ((((visible (targ) && (targ != self.owner)) && targ.takedamage) && (targ.classname != "breakable_bulb")))
		{
			if ((targ != world))
			{
				self.enemy = targ;
				self.think = HomeTarget;
				self.nextthink = time;
				sound (targ, CHAN_AUTO, "sub/locked.wav", 0.5, ATTN_IDLE);
				sound (self.owner, CHAN_AUTO, "sub/lockon.wav", 1.00, ATTN_IDLE);
				makesight ();
				return;
			}
		}
		targ = targ.chain;
	}
	self.nextthink = time;
	self.think = TrackTarget;
	if ((self.frame == 1))
		self.frame = 0;
	else
		self.frame = 1;
	if ((random () < 0.06))
		make_bub (self.origin);
	if ((pointcontents (self.origin) != CONTENT_WATER))
	{
		self.movetype = MOVETYPE_BOUNCE;
		self.nextthink = (time + 5.00);
		self.think = SUB_Remove;
	}
};


void () W_FireTorpedo =
{
	local entity missile;

	sound (self, CHAN_WEAPON, "weapons/torpedo.wav", 1.00, ATTN_NORM);
	self.old_position = self.origin;
	self.punchangle_x = -2;
	missile = spawn ();
	missile.owner = self;
	missile.classname = "torpedo";
	missile.colormap = self.colormap;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	makevectors (self.v_angle);
	missile.velocity = aim (self, 1000);
	missile.velocity = (missile.velocity * 200);
	missile.angles = vectoangles (missile.velocity);
	missile.touch = killdatarget;
	missile.nextthink = (time + 0.15);
	missile.think = TrackTarget;
	setmodel (missile, "progs/torpedo.mdl");
	setsize (missile, VEC_ORIGIN, VEC_ORIGIN);
	if ((self.tube_load == TRUE))
	{
		setorigin (missile, ((self.origin + (v_right * -25)) + '0 0 18'));
		self.tube_load = FALSE;
	}
	else
	{
		setorigin (missile, ((self.origin + (v_right * 25)) + '0 0 18'));
		self.tube_load = TRUE;
	}
	self.tube_wing = (self.tube_wing + 1);
};


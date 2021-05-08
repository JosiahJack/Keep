void() partspray_think = 
{
	particle(self.origin, self.movedir, self.color, self.count);
	if (!(self.targetname) || self.endtime > time)
	{
		self.nextthink = time + self.delay;
	}
};

void() partspray_use = 
{
	self.endtime = time + self.duration;
	partspray_think();
};

void() func_particlespray = 
{
	if (!(self.color))
	{
		self.color = 47;
	}
	if (self.count == MSG_BROADCAST)
	{
		self.count = 15;
	}
	if (self.delay == MSG_BROADCAST)
	{
		self.delay = 0.1;
	}
	self.classname = "particlespray";
	if (self.noise)
	{
		precache_sound(self.noise);
	}
	self.think = partspray_think;
	if (!(self.targetname))
	{
		self.nextthink = time + 0.1 + self.delay;
	}
	else
	{
		self.use = partspray_use;
	}
};

void() trigger_impulse_use = 
{
	activator = other;
	SUB_UseTargets();
	if (self.wait)
	{
		self.use = SUB_Null;
		self.think = trigger_impulse_reset;
		self.nextthink = time + self.wait;
	}
};

void() trigger_impulse_reset = 
{
	self.use = trigger_impulse_use;
	self.think = SUB_Null;
};

void() trigger_impulse = 
{
	if (!(self.impulse))
	{
		dprint("impulse trigger without impulse setting.\nat ");
		dprint(ftos(self.origin_x));
		dprint(" ");
		dprint(ftos(self.origin_y));
		dprint(" ");
		dprint(ftos(self.origin_z));
		dprint("\n");
		remove(self);
		return;
	}
	impulse_triggers = 1;
	self.use = trigger_impulse_use;
};

void() tti_use = 
{
	local string tmpstr;
	tmpstr = self.message;
	self.message = string_null;
	SUB_UseTargets();
	self.message = tmpstr;
	if (self.wait)
	{
		self.solid = SOLID_NOT;
		self.use = SUB_Null;
		self.think = tti_reset;
		self.nextthink = time + self.wait;
	}
};

void() tti_reset = 
{
	self.think = SUB_Null;
	self.use = tti_use;
	self.solid = SOLID_TRIGGER;
};

void() tti_touch = 
{
	if (other.flags & FL_CLIENT)
	{
		if (other.imp_touch < time)
		{
			centerprint(other, self.message);
		}
		other.imp_touch = time + 0.5;
	}
};

void() trigger_touch_impulse = 
{
	if (!(self.impulse))
	{
		dprint("impulse trigger without impulse setting.\nat ");
		dprint(ftos(self.origin_x));
		dprint(" ");
		dprint(ftos(self.origin_y));
		dprint(" ");
		dprint(ftos(self.origin_z));
		dprint("\n");
		remove(self);
		return;
	}
	InitTrigger();
	self.touch = tti_touch;
	self.use = tti_use;
};

void() interupt_touch = 
{
	if (other.flags & FL_CLIENT)
	{
		if (self.spawnflags & INT_MONSTONLY)
		{
			return;
		}
		if (other.health <= MSG_BROADCAST)
		{
			return;
		}
		self.endtime = time + 0.2;
		if (self.spawnflags & INT_SETACTIVATOR)
		{
			self.enemy = other;
			self.search_time = time + 0.2;
		}
	}
	else
	{
		if (other.flags & FL_MONSTER)
		{
			if (self.spawnflags & INT_PLAYERONLY)
			{
				return;
			}
			self.endtime = time + 0.2;
		}
	}
};

void() interupt_use = 
{
	local string ttemp1;
	local string ttemp2;
	local string ttemp3;
	local string ttemp4;
	local string mtemp;
	if (self.spawnflags & INT_ENTIN)
	{
		if (self.endtime > time)
		{
			if (self.spawnflags & INT_SETACTIVATOR && self.search_time > time)
			{
				activator = self.enemy;
			}
			SUB_UseTargets();
		}
		else
		{
			if (self.path)
			{
				if (self.noise)
				{
					sound(self, CHAN_VOICE, self.noise, SPAWN_CRUCIFIED, ATTN_NORM);
				}
				mtemp = self.message;
				ttemp1 = self.target;
				ttemp2 = self.target2;
				ttemp3 = self.target3;
				ttemp4 = self.target4;
				self.target = self.path;
				self.target4 = string_null;
				self.target3 = string_null;
				self.target2 = string_null;
				self.message = self.group;
				SUB_UseTargets();
				self.target = ttemp1;
				self.target2 = ttemp2;
				self.target3 = ttemp3;
				self.target4 = ttemp4;
				self.message = mtemp;
			}
		}
	}
	else
	{
		if (self.endtime < time)
		{
			SUB_UseTargets();
		}
		else
		{
			if (self.path)
			{
				if (self.spawnflags & INT_SETACTIVATOR && self.search_time > time)
				{
					activator = self.enemy;
				}
				if (self.noise)
				{
					sound(self, CHAN_VOICE, self.noise, SPAWN_CRUCIFIED, ATTN_NORM);
				}
				mtemp = self.message;
				ttemp1 = self.target;
				ttemp2 = self.target2;
				ttemp3 = self.target3;
				ttemp4 = self.target4;
				self.target = self.path;
				self.target4 = string_null;
				self.target3 = string_null;
				self.target2 = string_null;
				self.message = self.group;
				SUB_UseTargets();
				self.target = ttemp1;
				self.target2 = ttemp2;
				self.target3 = ttemp3;
				self.target4 = ttemp4;
				self.message = mtemp;
			}
		}
	}
};

void() trigger_interupt = 
{
	if (self.sounds == SPAWN_CRUCIFIED)
	{
		self.noise = "doors/basetry.wav";
	}
	else
	{
		if (self.sounds == SPAWN_SLEEPING)
		{
			self.noise = "doors/medtry.wav";
		}
		else
		{
			if (self.sounds == SVC_UPDATESTAT)
			{
				self.noise = "doors/runetry.wav";
			}
		}
	}
	if (self.noise)
	{
		precache_sound(self.noise);
	}
	self.touch = interupt_touch;
	self.use = interupt_use;
	InitTrigger();
};

void(string stepsound, float chancea, float vola, float volb) FootFall = 
{
	if (checkbottom(self) == 0)
	{
		return;
	}
	if (self.waterlevel != MSG_BROADCAST)
	{
		vola = vola * 0.5;
		volb = volb * 0.5;
	}
	if (random() < chancea)
	{
		sound(self, SVC_SETVIEWPORT, stepsound, vola, ATTN_NORM);
	}
	else
	{
		sound(self, SVC_SETVIEWPORT, stepsound, volb, ATTN_NORM);
	}
};

void() dummy_think = 
{
	if (self.flags & FL_GODMODE)
	{
		if (!(self.owner.flags & FL_GODMODE))
		{
			self.flags = self.flags - FL_GODMODE;
		}
	}
	else
	{
		if (self.owner.flags & FL_GODMODE)
		{
			self.flags = self.flags | FL_GODMODE;
		}
	}
	if (self.owner.trigger_field != self)
	{
		remove(self);
	}
	if (self.owner.flags & FL_ONGROUND)
	{
		self.owner.flags = self.owner.flags - (self.owner.flags & FL_ONGROUND);
	}
	droptofloor();
};

void() dummy_standb1 = [12, dummy_standb2]
{
	dummy_think();
};

void() dummy_standb2 = [13, dummy_standb3]
{
	dummy_think();
};

void() dummy_standb3 = [14, dummy_standb4]
{
	dummy_think();
};

void() dummy_standb4 = [15, dummy_standb5]
{
	dummy_think();
};

void() dummy_standb5 = [16, dummy_standb1]
{
	dummy_think();
};

void() dummy_stand1 = [17, dummy_stand2]
{
	dummy_think();
};

void() dummy_stand2 = [18, dummy_stand3]
{
	dummy_think();
};

void() dummy_stand3 = [19, dummy_stand4]
{
	dummy_think();
};

void() dummy_stand4 = [20, dummy_stand5]
{
	dummy_think();
};

void() dummy_stand5 = [21, dummy_stand6]
{
	dummy_think();
};

void() dummy_stand6 = [22, dummy_stand7]
{
	dummy_think();
};

void() dummy_stand7 = [23, dummy_stand8]
{
	dummy_think();
};

void() dummy_stand8 = [24, dummy_stand9]
{
	dummy_think();
};

void() dummy_stand9 = [25, dummy_stand10]
{
	dummy_think();
};

void() dummy_stand10 = [26, dummy_stand11]
{
	dummy_think();
};

void() dummy_stand11 = [27, dummy_stand12]
{
	dummy_think();
};

void() dummy_stand12 = [28, dummy_stand1]
{
	dummy_think();
};

void() dummy_pain1 = [29, dummy_pain2]
{
	dummy_think();
};

void() dummy_pain2 = [30, dummy_pain3]
{
	dummy_think();
};

void() dummy_pain3 = [31, dummy_pain4]
{
	dummy_think();
};

void() dummy_pain4 = [32, dummy_pain5]
{
	dummy_think();
};

void() dummy_pain5 = [33, dummy_pain6]
{
	dummy_think();
};

void() dummy_pain6 = [34, dummy_stand1]
{
	dummy_think();
};

void(entity attacker, float damage) dummy_pain = 
{
	T_Damage(self.owner, attacker, attacker, damage);
	self.owner.items = self.items;
	self.owner.armorvalue = self.armorvalue;
	self.owner.armortype = self.armortype;
	self.enemy = attacker;
	if (self.weapon == IT_AXE)
	{
		player_axpain1();
	}
	else
	{
		player_pain1();
	}
};

void() dummy_finalthink = 
{
	setorigin(self.owner, self.origin);
	remove(self);
};

void(entity dummy) dummy_lastright = 
{
	dummy.frame = MSG_BROADCAST;
	setmodel(dummy, "progs/s_null.spr");
	dummy.solid = SOLID_NOT;
	dummy.movetype = MOVETYPE_NONE;
	setsize(dummy, VEC_ORIGIN, VEC_ORIGIN);
	dummy.nextthink = time + 0.1;
	dummy.think = dummy_finalthink;
};

void() dummy_die = 
{
	local entity kilt;
	local entity kilr;
	self.owner.apocflags = self.apocflags;
	self.owner.health = self.health;
	kilt = self.owner;
	kilr = damage_attacker;
	dummy_remove(kilt);
	Killed(kilt, kilr);
};

void(entity dummy_owner, float dummywalk, float dummynodmg) dummy_setup = 
{
	local entity dummy;
	local entity tmpent;
	dummy_owner.apocflags = dummy_owner.apocflags | VIEW_RCAM;
	dummy_owner.dest1 = dummy_owner.angles;
	dummy_owner.solid = SOLID_NOT;
	dummy_owner.frame = MSG_BROADCAST;
	dummy_owner.takedamage = DAMAGE_YES;
	dummy_owner.solid = SOLID_NOT;
	dummy_owner.movetype = MOVETYPE_FLY;
	dummy = spawn();
	dummy.classname = "dummy_player";
	if (dummynodmg)
	{
		dummy.takedamage = DAMAGE_NO;
	}
	else
	{
		dummy.takedamage = DAMAGE_AIM;
	}
	dummy.solid = SOLID_SLIDEBOX;
	dummy.movetype = MOVETYPE_STEP;
	setmodel(dummy, "progs/player.mdl");
	setsize(dummy, VEC_HULL_MIN, VEC_HULL_MAX);
	setorigin(dummy, dummy_owner.origin);
	dummy.view_ofs = '0 0 22';
	dummy.frame = 17;
	dummy.angles = dummy_owner.dest1;
	dummy.health = dummy_owner.health;
	dummy.armorvalue = dummy_owner.armorvalue;
	dummy.armortype = dummy_owner.armortype;
	dummy.items = dummy_owner.items;
	dummy.owner = dummy_owner;
	dummy.skin = dummy_owner.skin;
	dummy.colormap = dummy_owner.colormap;
	dummy.team = dummy_owner.team;
	dummy.apocflags = dummy_owner.apocflags;
	dummy.th_pain = dummy_pain;
	dummy.th_die = dummy_die;
	dummy.walkframe = dummywalk;
	if (dummywalk == MSG_BROADCAST)
	{
		dummy.think = dummy_stand1;
	}
	else
	{
		dummy.think = dummy_standb1;
	}
	dummy.nextthink = time + 0.1;
	dummy_owner.view_ofs = '0 0 0.1';
	dummy_owner.frame = MSG_BROADCAST;
	dummy_owner.trigger_field = dummy;
	dummy_owner.modelindex = modelindex_null;
	setsize(dummy_owner, VEC_ORIGIN, VEC_ORIGIN);
	tmpent = nextent(world);
	while (tmpent)
	{
		if (tmpent.enemy == dummy_owner)
		{
			tmpent.enemy = dummy;
		}
		tmpent = nextent(tmpent);
	}
};

void(entity dummy_owner) dummy_remove = 
{
	local entity dummy;
	local entity tmpent;
	local vector dorg;
	local vector dangles;
	dummy = dummy_owner.trigger_field;
	dorg = dummy.origin;
	dangles = dummy.angles;
	tmpent = nextent(world);
	while (tmpent)
	{
		if (tmpent.enemy == dummy)
		{
			tmpent.enemy = dummy_owner;
		}
		tmpent = nextent(tmpent);
	}
	dummy_lastright(dummy);
	dummy_owner.trigger_field = world;
	dummy_owner.pausetime = time + 0.2;
	dummy_owner.apocflags = dummy_owner.apocflags - (dummy_owner.apocflags & VIEW_RCAM);
	msg_entity = dummy_owner;
	WriteByte(MSG_ONE, SVC_SETVIEWANGLES);
	WriteAngle(MSG_ONE, dangles_x);
	WriteAngle(MSG_ONE, dangles_y);
	WriteAngle(MSG_ONE, dangles_z);
	setorigin(dummy_owner, dorg);
	dummy_owner.takedamage = DAMAGE_AIM;
	dummy_owner.solid = SOLID_SLIDEBOX;
	dummy_owner.movetype = MOVETYPE_WALK;
	dummy_owner.modelindex = modelindex_player;
	dummy_owner.view_ofs = '0 0 22';
	setsize(dummy_owner, VEC_HULL_MIN, VEC_HULL_MAX);
};

void() rcam_use = 
{
	local entity tempself;
	local entity nextcam;
	local entity tmpent;
	if (!(activator.flags & FL_CLIENT))
	{
		return;
	}
	if (activator.cament)
	{
		tempself = self;
		self = activator;
		Cam_toggle();
		self = tempself;
	}
	if (self.target2 != string_null && self.target2 != "end" && (activator.apocflags & NEXT_RCAM))
	{
		activator.apocflags = activator.apocflags - (activator.apocflags & NEXT_RCAM);
		nextcam = find(world, targetname, self.target2);
		if (nextcam.classname != "func_remote_cam")
		{
			bprint("Next camera in loop,");
			bprint(self.target2);
			bprint(", not found");
			self.target2 = "end";
			rcam_use();
			return;
		}
		setmodel(self, self.mdl);
		activator.rcam = nextcam;
		if (nextcam.spawnflags & RCAM_FREEZE)
		{
			activator.apocflags = activator.apocflags | VIEW_SETVIEWANGLE;
		}
		else
		{
			activator.apocflags = activator.apocflags - (activator.apocflags & VIEW_SETVIEWANGLE);
		}
		activator.weaponmodel = nextcam.spawnmodel;
		setorigin(activator, nextcam.origin);
		msg_entity = activator;
		WriteByte(MSG_ONE, SVC_SETVIEWANGLES);
		WriteAngle(MSG_ONE, nextcam.idealpitch);
		WriteAngle(MSG_ONE, nextcam.angles_y);
		WriteAngle(MSG_ONE, nextcam.angles_z);
		if (nextcam.message)
		{
			centerprint(activator, nextcam.message);
		}
		if (nextcam.model == nextcam.mdl)
		{
			nextcam.frame = MSG_BROADCAST;
			setmodel(nextcam, "progs/s_null.spr");
			setmodel(activator, nextcam.mdl);
		}
		else
		{
			activator.frame = MSG_BROADCAST;
			setmodel(activator, "progs/s_null.spr");
		}
		return;
	}
	activator.apocflags = activator.apocflags - (activator.apocflags & NEXT_RCAM);
	if (activator.rcam != self)
	{
		activator.rcam = self;
		if (self.spawnflags & RCAM_FREEZE)
		{
			activator.apocflags = activator.apocflags | VIEW_SETVIEWANGLE;
		}
		activator.weaponmodel = self.spawnmodel;
		dummy_setup(activator, self.walkframe, self.spawnflags & RCAM_NODMG);
		setorigin(activator, self.origin);
		msg_entity = activator;
		WriteByte(MSG_ONE, SVC_SETVIEWANGLES);
		WriteAngle(MSG_ONE, self.idealpitch);
		WriteAngle(MSG_ONE, self.angles_y);
		WriteAngle(MSG_ONE, self.angles_z);
		if (self.message)
		{
			centerprint(activator, self.message);
		}
		if (self.model == self.mdl)
		{
			setmodel(self, "progs/s_null.spr");
			activator.frame = MSG_BROADCAST;
			setmodel(activator, self.mdl);
		}
	}
	else
	{
		activator.apocflags = activator.apocflags - (activator.apocflags & VIEW_SETVIEWANGLE);
		activator.rcam = world;
		dummy_remove(activator);
		tmpent = self;
		self = activator;
		W_SetCurrentAmmo();
		self = tmpent;
		if (activator.cament)
		{
			msg_entity = activator;
			WriteByte(MSG_ONE, SVC_SETVIEWPORT);
			WriteEntity(MSG_ONE, activator.cament);
			stuffcmd(activator, "cl_bob 0\n");
		}
		else
		{
			msg_entity = activator;
			WriteByte(MSG_ONE, SVC_SETVIEWPORT);
			WriteEntity(MSG_ONE, activator);
			stuffcmd(activator, "cl_bob 0.02\n");
		}
		setmodel(self, self.mdl);
	}
};

void() rcam_use_all = 
{
	local entity tmpent;
	tmpent = world;
	do
	{
		tmpent = nextent(tmpent);
		if (tmpent.flags & FL_CLIENT)
		{
			activator = tmpent;
			rcam_use();
		}
	} while (tmpent);
};

void() rcam_move = 
{
	setorigin(self, self.movetarget.origin + self.pos1);
	self.velocity = self.movetarget.velocity;
	self.nextthink = time + self.search_time;
};

void() rcam_track = 
{
	local vector tmpveca;
	tmpveca = self.origin - self.goalentity.origin;
	tmpveca = vectoangles(tmpveca);
	tmpveca_y = tmpveca_y - 180;
	camanglesmod(tmpveca);
	if (self.spawnflags & RCAM_MOVING)
	{
		rcam_move();
	}
	self.nextthink = time + self.search_time;
};

void() rcam_setup = 
{
	local vector tmpvec;
	local entity tmpent;
	if (self.target)
	{
		tmpent = find(world, targetname, self.target);
		tmpvec = self.origin - tmpent.origin;
		self.angles = vectoangles(tmpvec);
		self.angles_y = self.angles_y - 180;
		self.goalentity = tmpent;
		if (self.spawnflags & RCAM_SMOOTH)
		{
			self.search_time = 0.05;
		}
		else
		{
			self.search_time = 0.1;
		}
	}
	else
	{
		if (self.spawnflags & RCAM_TRACKING)
		{
			objerror("a target is needed for a tracking cam\n");
		}
	}
	if (self.spawnflags & RCAM_MOVING)
	{
		if (self.path)
		{
			tmpent = find(world, targetname, self.path);
		}
		else
		{
			objerror("a path is needed for a moving cam\n");
		}
		self.movetarget = tmpent;
		self.movetype = MOVETYPE_FLY;
		setsize(self, VEC_ORIGIN, VEC_ORIGIN);
		if (self.pos1 == '-1 -1 -1')
		{
			self.pos1 = tmpent.origin - self.origin;
		}
		setorigin(self, self.movetarget.origin + self.pos1);
	}
	if (self.spawnflags & RCAM_TRACKING)
	{
		self.think = rcam_track;
		self.nextthink = time + SPAWN_CRUCIFIED;
	}
	else
	{
		if (self.spawnflags & RCAM_MOVING)
		{
			self.think = rcam_move;
			self.nextthink = time + SPAWN_CRUCIFIED;
		}
		else
		{
			self.think = SUB_Null;
		}
	}
	if (self.spawnflags & RCAM_ALL)
	{
		self.use = rcam_use_all;
	}
	else
	{
		self.use = rcam_use;
	}
};

void() func_remote_cam = 
{
	precache_model("progs/s_null.spr");
	if (self.spawnmodel)
	{
		precache_model(self.spawnmodel);
	}
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_NONE;
	setsize(self, VEC_ORIGIN, VEC_ORIGIN);
	if (self.model)
	{
		precache_model(self.model);
		setmodel(self, self.model);
	}
	else
	{
		setmodel(self, "progs/s_null.spr");
	}
	self.mdl = self.model;
	if (self.target2)
	{
		self.spawnflags = self.spawnflags - (self.spawnflags & RCAM_EXITABLE);
	}
	self.walkframe = MSG_BROADCAST;
	camanglesmod(self.angles);
	self.think = rcam_setup;
	self.nextthink = time + 0.2;
};

void() rcam_impulse_controls = 
{
	local entity t;
	local vector testmin;
	local vector testmax;
	if (impulse_triggers)
	{
		t = find(world, classname, "trigger_impulse");
		while (t)
		{
			if (self.impulse == t.impulse)
			{
				stemp = self;
				activator = self;
				self = t;
				self.use();
				self = stemp;
			}
			t = find(t, classname, "trigger_impulse");
		}
	}
	if (self.imp_touch > time)
	{
		t = find(world, classname, "trigger_touch_impulse");
		while (t)
		{
			if (self.impulse == t.impulse)
			{
				if (self.trigger_field)
				{
					testmin = self.trigger_field.absmin;
					testmax = self.trigger_field.absmax;
				}
				else
				{
					testmin = self.absmin;
					testmax = self.absmax;
				}
				if (self.absmin_x < t.absmax_x && self.absmax_x > t.absmin_x)
				{
					if (self.absmin_y < t.absmax_y && self.absmax_y > t.absmin_y)
					{
						if (self.absmin_z < t.absmax_z && self.absmax_z > t.absmin_z)
						{
							activator = self;
							stemp = self;
							self = t;
							self.use();
							self = stemp;
						}
					}
				}
			}
			t = find(t, classname, "trigger_touch_impulse");
		}
	}
	self.impulse = MSG_BROADCAST;
};

void() trigger_combo_use = 
{
	if (lastnameused == self.targetname)
	{
		if (self.currentammo & SPAWN_CRUCIFIED)
		{
			self.currentammo = self.currentammo - SPAWN_CRUCIFIED;
		}
		else
		{
			self.currentammo = self.currentammo | SPAWN_CRUCIFIED;
		}
		if (self.noise1)
		{
			SUB_UseName(self.noise1);
		}
	}
	else
	{
		if (lastnameused == self.targetname2)
		{
			if (self.currentammo & SPAWN_SLEEPING)
			{
				self.currentammo = self.currentammo - SPAWN_SLEEPING;
			}
			else
			{
				self.currentammo = self.currentammo | SPAWN_SLEEPING;
			}
			if (self.noise2)
			{
				SUB_UseName(self.noise2);
			}
		}
		else
		{
			if (lastnameused == self.targetname3)
			{
				if (self.currentammo & SPAWN_DEAD)
				{
					self.currentammo = self.currentammo - SPAWN_DEAD;
				}
				else
				{
					self.currentammo = self.currentammo | SPAWN_DEAD;
				}
				if (self.noise3)
				{
					SUB_UseName(self.noise3);
				}
			}
			else
			{
				if (lastnameused == self.targetname4)
				{
					if (self.currentammo & SECRET_NO_SHOOT)
					{
						self.currentammo = self.currentammo - SECRET_NO_SHOOT;
					}
					else
					{
						self.currentammo = self.currentammo | SECRET_NO_SHOOT;
					}
					if (self.noise4)
					{
						SUB_UseName(self.noise4);
					}
				}
			}
		}
	}
	if (self.currentammo == self.spawnflags)
	{
		if (self.noise)
		{
			sound(self, CHAN_AUTO, self.noise, SPAWN_CRUCIFIED, ATTN_NORM);
		}
		SUB_UseTargets();
		remove(self);
	}
};

void() trigger_combo = 
{
	self.currentammo = MSG_BROADCAST;
	if (self.spawnflags > 15)
	{
		objerror("inappropriate combination flags set");
	}
	if (self.noise)
	{
		precache_sound(self.noise);
	}
	self.use = trigger_combo_use;
};

void() trigger_sequence_use = 
{
	local float seqfail;
	seqfail = 0;
	if (lastnameused == self.targetname)
	{
		if (self.currentammo == MSG_BROADCAST)
		{
			self.currentammo = SPAWN_CRUCIFIED;
		}
		else
		{
			seqfail = 1;
		}
	}
	else
	{
		if (lastnameused == self.targetname2)
		{
			if (self.currentammo == SPAWN_CRUCIFIED)
			{
				self.currentammo = SPAWN_SLEEPING;
			}
			else
			{
				seqfail = 1;
			}
		}
		else
		{
			if (lastnameused == self.targetname3)
			{
				if (self.currentammo == SPAWN_SLEEPING)
				{
					self.currentammo = SVC_UPDATESTAT;
				}
				else
				{
					seqfail = 1;
				}
			}
			else
			{
				if (lastnameused == self.targetname4)
				{
					if (self.currentammo == SVC_UPDATESTAT)
					{
						self.currentammo = SPAWN_DEAD;
					}
					else
					{
						seqfail = 1;
					}
				}
			}
		}
	}
	if (seqfail)
	{
		if (self.spawnflags & SEQ_FAILRESET)
		{
			self.currentammo = MSG_BROADCAST;
		}
		if (self.event)
		{
			SUB_UseName(self.event);
		}
		if (self.noise2)
		{
			sound(self, CHAN_AUTO, self.noise2, SPAWN_CRUCIFIED, ATTN_NORM);
		}
	}
	else
	{
		if (self.currentammo = self.weapon)
		{
			SUB_UseTargets();
			if (self.noise)
			{
				sound(self, CHAN_AUTO, self.noise, SPAWN_CRUCIFIED, ATTN_NORM);
			}
			if (self.spawnflags & SEQ_MULTIPLE)
			{
				self.currentammo = MSG_BROADCAST;
			}
			else
			{
				remove(self);
			}
		}
		else
		{
			if (self.noise1)
			{
				sound(self, CHAN_AUTO, self.noise1, SPAWN_CRUCIFIED, ATTN_NORM);
			}
		}
	}
};

void() trigger_sequence = 
{
	if (self.noise)
	{
		precache_sound(self.noise);
	}
	if (self.noise1)
	{
		precache_sound(self.noise1);
	}
	if (self.noise2)
	{
		precache_sound(self.noise2);
	}
	if (self.targetname4)
	{
		self.weapon = SPAWN_DEAD;
	}
	else
	{
		if (self.targetname3)
		{
			self.weapon = SVC_UPDATESTAT;
		}
		else
		{
			if (self.targetname2)
			{
				self.weapon = SPAWN_SLEEPING;
			}
			else
			{
				self.weapon = SPAWN_CRUCIFIED;
			}
		}
	}
	self.currentammo = MSG_BROADCAST;
	self.use = trigger_sequence_use;
};

void(entity attacker, float damage) glass_pain = 
{
	if (self.spawnflags & GLASS_ONEHIT)
	{
		self.health = self.max_health;
	}
};

void() glass_die = 
{
	local entity new;
	local vector tmpvec;
	local vector tmpmin;
	local vector tmpmax;
	local vector tmpsize;
	while (self.color > MSG_BROADCAST)
	{
		new = spawn();
		new.origin = self.origin;
		if (random() < 0.33)
		{
			setmodel(new, "progs/rubble3.mdl");
		}
		else
		{
			if (random() < 0.5)
			{
				setmodel(new, "progs/rubble2.mdl");
			}
			else
			{
				setmodel(new, "progs/rubble1.mdl");
			}
		}
		setsize(new, VEC_ORIGIN, VEC_ORIGIN);
		new.velocity_x = 70 * crandom();
		new.velocity_y = 70 * crandom();
		new.velocity_z = 140 + 70 * random();
		new.movetype = MOVETYPE_BOUNCE;
		new.solid = SOLID_BBOX;
		new.avelocity_x = random() * 600;
		new.avelocity_y = random() * 600;
		new.avelocity_z = random() * 600;
		new.nextthink = time + SPAWN_SLEEPING + random() * SVC_UPDATESTAT;
		new.think = SUB_Remove;
		new.skin = STAT_TOTALSECRETS;
		self.absmin = self.origin + self.mins;
		self.absmax = self.origin + self.maxs;
		tmpvec_x = self.absmin_x + random() * (self.absmax_x - self.absmin_x);
		tmpvec_y = self.absmin_y + random() * (self.absmax_y - self.absmin_y);
		tmpvec_z = self.absmin_z + random() * (self.absmax_z - self.absmin_z);
		setorigin(new, tmpvec);
		self.color = self.color - SPAWN_CRUCIFIED;
	}
	if (self.noise2)
	{
		sound(self, CHAN_VOICE, self.noise2, SPAWN_CRUCIFIED, ATTN_NORM);
	}
	if (self.event)
	{
		SUB_UseName(self.event);
	}
	remove(self);
};

void() func_glass = 
{
	local vector tmpvec;
	local float tmpflt;
	self.movetype = MOVETYPE_PUSH;
	self.solid = SOLID_BSP;
	self.mdl = self.model;
	setmodel(self, self.model);
	setsize(self, self.mins, self.maxs);
	setorigin(self, self.origin);
	self.model = string_null;
	precache_sound("misc/null.wav");
	if (self.health > MSG_BROADCAST)
	{
		if (!(self.color))
		{
			tmpvec = self.maxs - self.mins;
			tmpvec = tmpvec * 0.031;
			if (tmpvec_x < SPAWN_CRUCIFIED)
			{
				tmpvec_x = SPAWN_CRUCIFIED;
			}
			if (tmpvec_y < SPAWN_CRUCIFIED)
			{
				tmpvec_y = SPAWN_CRUCIFIED;
			}
			if (tmpvec_z < SPAWN_CRUCIFIED)
			{
				tmpvec_z = SPAWN_CRUCIFIED;
			}
			self.color = tmpvec_x * tmpvec_y * tmpvec_z;
		}
		else
		{
			if (self.color == CONTENT_EMPTY)
			{
				self.color = MSG_BROADCAST;
			}
		}
		if (self.color > SECRET_YES_SHOOT)
		{
			self.color = SECRET_YES_SHOOT;
		}
		self.takedamage = DAMAGE_YES;
		self.max_health = self.health;
		self.th_die = glass_die;
		self.th_pain = glass_pain;
		precache_model("progs/rubble1.mdl");
		precache_model("progs/rubble2.mdl");
		precache_model("progs/rubble3.mdl");
	}
	if (self.target)
	{
		if (!(self.speed))
		{
			self.speed = 100;
		}
		if (!(self.dmg))
		{
			self.dmg = SPAWN_SLEEPING;
		}
		if (self.sounds == SPAWN_CRUCIFIED)
		{
			if (!(self.noise))
			{
				self.noise = "plats/train2.wav";
			}
			if (!(self.noise1))
			{
				self.noise1 = "plats/train1.wav";
			}
			precache_sound(self.noise);
			precache_sound(self.noise1);
		}
		self.cnt = SPAWN_CRUCIFIED;
		self.blocked = train_blocked;
		self.use = train_use;
		if (self.spawnflags & GLASS_SMOOTH)
		{
			self.classname = "smtrain";
			self.think = func_smtrain_setup;
		}
		else
		{
			self.classname = "train";
			self.think = func_train_find;
		}
		self.nextthink = self.ltime + 0.6;
	}
	else
	{
		self.use = blocker_use;
		if (self.spawnflags & GLASS_STARTOFF)
		{
			self.state = MSG_BROADCAST;
			setorigin(self, self.origin + '8000 8000 8000');
		}
		else
		{
			self.state = SPAWN_CRUCIFIED;
			if (self.noise1)
			{
				sound(self, CHAN_VOICE, self.noise1, SPAWN_CRUCIFIED, ATTN_NORM);
			}
		}
	}
	if (!(self.noise))
	{
		self.noise = "misc/null.wav";
	}
	if (!(self.noise1))
	{
		self.noise1 = "misc/null.wav";
	}
	if (!(self.noise2))
	{
		self.noise2 = "misc/shatter.wav";
	}
	precache_sound(self.noise);
	precache_sound(self.noise1);
	precache_sound(self.noise2);
};

void() func_model_think = 
{
	self.frame = self.frame + SPAWN_CRUCIFIED;
	if (self.frame > self.walkframe + self.count)
	{
		self.frame = self.walkframe;
	}
	self.nextthink = time + self.wait;
};

void() func_model_use = 
{
	if (self.think == func_model_think)
	{
		self.think = SUB_Null;
		if (self.weaponframe >= MSG_BROADCAST)
		{
			self.frame = self.weaponframe;
		}
	}
	else
	{
		self.think = func_model_think;
		func_model_think();
	}
};

void() func_model = 
{
	precache_model(self.model);
	setmodel(self, self.model);
	if (!(self.spawnflags & SPAWN_CRUCIFIED))
	{
		makestatic(self);
		return;
	}
	if (self.wait < 0.05)
	{
		self.wait = 0.1;
	}
	if (self.count < SPAWN_SLEEPING)
	{
		self.count = SPAWN_CRUCIFIED;
	}
	else
	{
		self.count = self.count - SPAWN_CRUCIFIED;
	}
	if (self.walkframe)
	{
		self.frame = self.walkframe;
	}
	else
	{
		self.walkframe = MSG_BROADCAST;
		self.frame = MSG_BROADCAST;
	}
	if (self.weaponframe == MSG_BROADCAST)
	{
		self.weaponframe = CONTENT_EMPTY;
	}
	else
	{
		if (self.weaponframe < MSG_BROADCAST)
		{
			self.weaponframe = MSG_BROADCAST;
		}
	}
	self.use = func_model_use;
	if (!(self.spawnflags & SPAWN_SLEEPING))
	{
		self.think = func_model_think;
		self.nextthink = time + self.wait;
	}
	else
	{
		if (self.weaponframe >= MSG_BROADCAST)
		{
			self.frame = self.weaponframe;
		}
	}
};

void(vector from, vector onto) SUB_Dot = 
{
	return from * onto;
};

void(float a, float b) mod = 
{
	return a - floor(a / b) * b;
};

void(vector invec, vector refnorm) SUB_ReflectVector = 
{
	local vector outvec;
	local float refspeed;
	refspeed = vlen(invec);
	outvec = normalize(invec);
	outvec = outvec + SPAWN_SLEEPING * refnorm;
	if (outvec_x > SPAWN_CRUCIFIED)
	{
		outvec_x = SPAWN_SLEEPING - outvec_x;
	}
	if (outvec_x < CONTENT_EMPTY)
	{
		outvec_x = CONTENT_SOLID - outvec_x;
	}
	if (outvec_y > SPAWN_CRUCIFIED)
	{
		outvec_y = SPAWN_SLEEPING - outvec_y;
	}
	if (outvec_y < CONTENT_EMPTY)
	{
		outvec_y = CONTENT_SOLID - outvec_y;
	}
	if (outvec_z > SPAWN_CRUCIFIED)
	{
		outvec_z = SPAWN_SLEEPING - outvec_z;
	}
	if (outvec_z < CONTENT_EMPTY)
	{
		outvec_z = CONTENT_SOLID - outvec_z;
	}
	outvec = outvec * refspeed;
	return outvec_x;
};

float(float parmvala, float parmvalb, float parmvalc) SUB_PackParm = 
{
	local float parmout;
	parmout = MSG_BROADCAST;
	parmvala = floor(parmvala);
	parmvalb = floor(parmvalb);
	parmvalc = floor(parmvalc);
	if (parmvala < MSG_BROADCAST)
	{
		parmvala = MSG_BROADCAST;
	}
	else
	{
		if (parmvala > 255)
		{
			parmvala = 255;
		}
	}
	if (parmvalb < MSG_BROADCAST)
	{
		parmvalb = MSG_BROADCAST;
	}
	else
	{
		if (parmvalb > 255)
		{
			parmvalb = 255;
		}
	}
	if (parmvalc < MSG_BROADCAST)
	{
		parmvalc = MSG_BROADCAST;
	}
	else
	{
		if (parmvalc > 255)
		{
			parmvalc = 255;
		}
	}
	parmout = parmvala;
	parmvalb = parmvalb * BIT_9;
	parmout = parmout + parmvalb;
	parmvalc = parmvalc * BIT_17;
	parmout = parmout + parmvalc;
	return parmout;
};

float(float parmin, float valnum) SUB_UnpackParm = 
{
	local float valout;
	valout = MSG_BROADCAST;
	if (valnum == SPAWN_CRUCIFIED)
	{
		if (parmin < MSG_BROADCAST)
		{
			parmin = parmin * CONTENT_EMPTY;
		}
		if (parmin & BIT_1)
		{
			valout = valout + BIT_1;
		}
		if (parmin & BIT_2)
		{
			valout = valout + BIT_2;
		}
		if (parmin & BIT_3)
		{
			valout = valout + BIT_3;
		}
		if (parmin & BIT_4)
		{
			valout = valout + BIT_4;
		}
		if (parmin & BIT_5)
		{
			valout = valout + BIT_5;
		}
		if (parmin & BIT_6)
		{
			valout = valout + BIT_6;
		}
		if (parmin & BIT_7)
		{
			valout = valout + BIT_7;
		}
		if (parmin & BIT_8)
		{
			valout = valout + BIT_8;
		}
	}
	else
	{
		if (valnum == SPAWN_SLEEPING)
		{
			if (parmin < MSG_BROADCAST)
			{
				parmin = parmin * CONTENT_EMPTY;
			}
			if (parmin & BIT_9)
			{
				valout = valout + BIT_1;
			}
			if (parmin & BIT_10)
			{
				valout = valout + BIT_2;
			}
			if (parmin & BIT_11)
			{
				valout = valout + BIT_3;
			}
			if (parmin & BIT_12)
			{
				valout = valout + BIT_4;
			}
			if (parmin & BIT_13)
			{
				valout = valout + BIT_5;
			}
			if (parmin & BIT_14)
			{
				valout = valout + BIT_6;
			}
			if (parmin & BIT_15)
			{
				valout = valout + BIT_7;
			}
			if (parmin & BIT_16)
			{
				valout = valout + BIT_8;
			}
		}
		else
		{
			if (valnum == SVC_UPDATESTAT)
			{
				if (parmin < MSG_BROADCAST)
				{
					parmin = parmin * CONTENT_EMPTY;
				}
				if (parmin & BIT_17)
				{
					valout = valout + BIT_1;
				}
				if (parmin & BIT_18)
				{
					valout = valout + BIT_2;
				}
				if (parmin & BIT_19)
				{
					valout = valout + BIT_3;
				}
				if (parmin & BIT_20)
				{
					valout = valout + BIT_4;
				}
				if (parmin & BIT_21)
				{
					valout = valout + BIT_5;
				}
				if (parmin & BIT_22)
				{
					valout = valout + BIT_6;
				}
				if (parmin & BIT_23)
				{
					valout = valout + BIT_7;
				}
				if (parmin & BIT_24)
				{
					valout = valout + BIT_8;
				}
			}
			else
			{
				return MSG_BROADCAST;
				dprint("error unpacking parm value\n");
			}
		}
	}
	return valout;
};

void(vector vecin) camanglesmod = 
{
	self.idealpitch = vecin_x;
	self.angles_x = anglemod(vecin_x);
	if (self.angles_x > 270)
	{
		self.angles_x = self.angles_x - 360;
	}
	self.angles_x = self.angles_x * CONTENT_EMPTY;
	self.angles_y = anglemod(vecin_y);
};

void() beamhit1 = [0, beamhit2]
{
};

void() beamhit2 = [1, beamhit3]
{
};

void() beamhit3 = [2, beamhit4]
{
};

void() beamhit4 = [3, beamhit5]
{
};

void() beamhit5 = [4, SUB_Remove]
{
};

void() BecomeBeamHit = 
{
	self.movetype = MOVETYPE_NONE;
	self.velocity = VEC_ORIGIN;
	self.touch = SUB_Null;
	setmodel(self, "progs/beamhit.spr");
	self.solid = SOLID_NOT;
	beamhit1();
};

void() beamring1 = [1, beamring2]
{
	self.nextthink = time + 0.05;
};

void() beamring2 = [2, beamring3]
{
	self.nextthink = time + 0.05;
};

void() beamring3 = [4, beamring4]
{
	self.nextthink = time + 0.05;
};

void() beamring4 = [6, beamring5]
{
	self.nextthink = time + 0.05;
};

void() beamring5 = [8, beamring6]
{
	self.nextthink = time + 0.05;
};

void() beamring6 = [10, beamring7]
{
	self.nextthink = time + 0.05;
};

void() beamring7 = [12, beamring8]
{
	self.nextthink = time + 0.05;
};

void() beamring8 = [14, beamring9]
{
	self.nextthink = time + 0.05;
};

void() beamring9 = [16, SUB_Remove]
{
	self.nextthink = time + 0.05;
};

void() d_beamring1 = [2, d_beamring2]
{
};

void() d_beamring2 = [4, d_beamring3]
{
};

void() d_beamring3 = [8, d_beamring4]
{
};

void() d_beamring4 = [12, d_beamring5]
{
};

void() d_beamring5 = [16, SUB_Remove]
{
};

void(vector ringorg) MakeBeamRing = 
{
	local entity ringent;
	ringent = spawn();
	ringent.movetype = MOVETYPE_NONE;
	setmodel(ringent, "progs/dring.spr");
	ringent.solid = SOLID_NOT;
	setorigin(ringent, ringorg);
	ringent.angles = '90 0 0';
	ringent.frame = MSG_BROADCAST;
	if (deathmatch)
	{
		ringent.think = d_beamring1;
	}
	else
	{
		ringent.nextthink = time + 0.05;
		ringent.think = beamring1;
	}
	ringent = spawn();
	ringent.movetype = MOVETYPE_NONE;
	setmodel(ringent, "progs/dring.spr");
	ringent.solid = SOLID_NOT;
	setorigin(ringent, ringorg);
	ringent.angles = '-90 0 0';
	ringent.frame = MSG_BROADCAST;
	if (deathmatch)
	{
		ringent.think = d_beamring1;
	}
	else
	{
		ringent.nextthink = time + 0.05;
		ringent.think = beamring1;
	}
};

void() beam_touch = 
{
	local float totaldmg;
	if (other == self.owner)
	{
		return;
	}
	if (other.solid == SOLID_TRIGGER)
	{
		return;
	}
	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	if (other.takedamage)
	{
		totaldmg = self.currentammo * 1.25;
		totaldmg = ceil(totaldmg);
		if (other.health <= totaldmg)
		{
			T_Damage(other, self, self.owner, 99999);
			if (other.health <= MSG_BROADCAST)
			{
				MakeBeamRing(other.origin);
				WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
				WriteByte(MSG_BROADCAST, TE_TAREXPLOSION);
				WriteCoord(MSG_BROADCAST, other.origin_x);
				WriteCoord(MSG_BROADCAST, other.origin_y);
				WriteCoord(MSG_BROADCAST, other.origin_z);
				remove(self);
				return;
			}
		}
		else
		{
			T_Damage(other, self, self.owner, totaldmg);
		}
	}
	sound(self, CHAN_ITEM, "turret/beamhit.wav", SPAWN_CRUCIFIED, ATTN_NORM);
	BecomeBeamHit();
};

void(float burstcharge) beam_water_burst = 
{
	local entity current;
	local float totaldmg;
	local vector destvec;
	current = world;
	sound(self, CHAN_WEAPON, "hipweap/mjolhit.wav", SPAWN_CRUCIFIED, ATTN_NORM);
	do
	{
		current = nextent(current);
		if (current.takedamage)
		{
			destvec = current.origin;
			traceline(self.origin, destvec, 1, self);
			if (trace_fraction == SPAWN_CRUCIFIED && current.waterlevel > MSG_BROADCAST)
			{
				totaldmg = vlen(self.origin - destvec) * 0.3;
				totaldmg = burstcharge * burstcharge / totaldmg;
				if (current.health <= totaldmg)
				{
					T_Damage(current, self, self, 99999);
					if (other.health <= MSG_BROADCAST)
					{
						MakeBeamRing(other.origin);
						WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
						WriteByte(MSG_BROADCAST, TE_TAREXPLOSION);
						WriteCoord(MSG_BROADCAST, other.origin_x);
						WriteCoord(MSG_BROADCAST, other.origin_y);
						WriteCoord(MSG_BROADCAST, other.origin_z);
					}
				}
				else
				{
					T_Damage(current, self, self, totaldmg);
				}
			}
		}
	} while (current);
};

void() beam_generate = 
{
	local entity beamseg;
	beamseg = spawn();
	beamseg.owner = self.owner;
	beamseg.solid = SOLID_BBOX;
	setmodel(beamseg, "progs/beam.mdl");
	setsize(beamseg, VEC_ORIGIN, VEC_ORIGIN);
	makevectors(self.owner.v_angle);
	if (self.owner.flags & FL_CLIENT)
	{
		self.owner.attack_finished = time + 0.5;
		setorigin(beamseg, self.owner.origin + v_forward * STAT_TOTALMONSTERS + self.owner.dest2);
		beamseg.velocity = aim(self.owner, 800) * 800;
	}
	else
	{
		if (self.owner.flags & FL_MONSTER)
		{
			setorigin(beamseg, self.owner.origin);
			beamseg.velocity = normalize(self.owner.enemy.origin - self.owner.origin) * 800;
		}
		else
		{
			setorigin(beamseg, self.owner.origin);
			beamseg.velocity = self.owner.movedir * 800;
		}
	}
	beamseg.angles = vectoangles(beamseg.velocity);
	beamseg.speed = 800;
	beamseg.classname = "beam";
	beamseg.movetype = MOVETYPE_FLYMISSILE;
	beamseg.currentammo = self.currentammo;
	beamseg.touch = beam_touch;
	beamseg.think = SUB_Remove;
	beamseg.nextthink = time + TE_LIGHTNING2;
	sound(self.owner, CHAN_WEAPON, "weapons/lstart.wav", SPAWN_CRUCIFIED, ATTN_NORM);
	self.currentammo = self.currentammo / SPAWN_SLEEPING;
	if (self.owner.flags & FL_CLIENT && self.deadflag == DEAD_NO)
	{
		self.owner.punchangle_x = CONTENT_SKY;
		self.owner.velocity = self.velocity - v_forward * self.currentammo * SPAWN_SLEEPING;
	}
	if (self.currentammo < SPAWN_CRUCIFIED)
	{
		remove(self);
	}
	self.nextthink = time + 0.05;
};

void() W_FireBeam = 
{
	if (self.waterlevel > SPAWN_CRUCIFIED)
	{
		beam_water_burst(self.ammo_cells * SPAWN_SLEEPING);
		self.ammo_cells = MSG_BROADCAST;
		self.currentammo = MSG_BROADCAST;
		return;
	}
	newmis = spawn();
	newmis.solid = SOLID_NOT;
	newmis.movetype = MOVETYPE_FLY;
	newmis.currentammo = self.currentammo;
	setorigin(newmis, self.origin);
	newmis.owner = self;
	newmis.think = beam_generate;
	newmis.nextthink = time + 0.05;
	self.currentammo = self.ammo_cells = floor(self.ammo_cells * 0.75);
};

void() TimeThink = 
{
	local float timelimit;
	timelimit = cvar("timelimit") * 60;
	if (time >= timelimit)
	{
		NextLevel();
	}
	self.nextthink = time + SPAWN_CRUCIFIED;
};

void() TimeMake = 
{
	local entity timechecker;
	local float timelimit;
	timelimit = cvar("timelimit");
	if (!timelimit)
	{
		return;
	}
	timechecker = spawn();
	timechecker.classname = "timechecker";
	timechecker.think = TimeThink;
	timechecker.nextthink = time + 0.2;
};


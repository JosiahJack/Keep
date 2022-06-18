void() info_rotate = 
{
	self.nextthink = time + LIGHTNING_BOOM;
	self.think = SUB_Remove;
};

void() RotateTargets = 
{
	local entity ent;
	local vector vx;
	local vector vy;
	local vector vz;
	local vector org;
	makevectors(self.angles);
	ent = find(world, targetname, self.target);
	while (ent)
	{
		if (ent.rotate_type == OBJECT_SETORIGIN)
		{
			org = ent.oldorigin;
			vx = v_forward * org_x;
			vy = v_right * org_y;
			vy = vy * CONTENT_EMPTY;
			vz = v_up * org_z;
			ent.neworigin = vx + vy + vz;
			setorigin(ent, ent.neworigin + self.origin);
		}
		else
		{
			if (ent.rotate_type == OBJECT_ROTATE)
			{
				ent.angles = self.angles;
				org = ent.oldorigin;
				vx = v_forward * org_x;
				vy = v_right * org_y;
				vy = vy * CONTENT_EMPTY;
				vz = v_up * org_z;
				ent.neworigin = vx + vy + vz;
				setorigin(ent, ent.neworigin + self.origin);
			}
			else
			{
				org = ent.oldorigin;
				vx = v_forward * org_x;
				vy = v_right * org_y;
				vy = vy * CONTENT_EMPTY;
				vz = v_up * org_z;
				ent.neworigin = vx + vy + vz;
				ent.neworigin = self.origin - self.oldorigin + (ent.neworigin - ent.oldorigin);
				ent.velocity = (ent.neworigin - ent.origin) * 25;
			}
		}
		ent = find(ent, targetname, self.target);
	}
};

void() RotateTargetsFinal = 
{
	local entity ent;
	ent = find(world, targetname, self.target);
	while (ent)
	{
		ent.velocity = VEC_ORIGIN;
		if (ent.rotate_type == OBJECT_ROTATE)
		{
			ent.angles = self.angles;
		}
		ent = find(ent, targetname, self.target);
	}
};

void() SetTargetOrigin = 
{
	local entity ent;
	ent = find(world, targetname, self.target);
	while (ent)
	{
		if (ent.rotate_type == OBJECT_MOVEWALL)
		{
			setorigin(ent, self.origin - self.oldorigin + (ent.neworigin - ent.oldorigin));
		}
		else
		{
			setorigin(ent, ent.neworigin + self.origin);
		}
		ent = find(ent, targetname, self.target);
	}
};

void() LinkRotateTargets = 
{
	local entity ent;
	local vector tempvec;
	self.oldorigin = self.origin;
	ent = find(world, targetname, self.target);
	while (ent)
	{
		if (ent.classname == "rotate_object")
		{
			ent.rotate_type = OBJECT_ROTATE;
			ent.oldorigin = ent.origin - self.oldorigin;
			ent.neworigin = ent.origin - self.oldorigin;
			ent.owner = self;
		}
		else
		{
			if (ent.classname == "func_movewall")
			{
				ent.rotate_type = OBJECT_MOVEWALL;
				tempvec = (ent.absmin + ent.absmax) * 0.5;
				ent.oldorigin = tempvec - self.oldorigin;
				ent.neworigin = ent.oldorigin;
				ent.owner = self;
			}
			else
			{
				ent.rotate_type = OBJECT_SETORIGIN;
				ent.oldorigin = ent.origin - self.oldorigin;
				ent.neworigin = ent.origin - self.oldorigin;
			}
		}
		ent = find(ent, targetname, self.target);
	}
};

void(float amount) SetDamageOnTargets = 
{
	local entity ent;
	ent = find(world, targetname, self.target);
	while (ent)
	{
		if (ent.classname == "trigger_hurt")
		{
			hurt_setdamage(ent, amount);
		}
		else
		{
			if (ent.classname == "func_movewall")
			{
				ent.dmg = amount;
			}
		}
		ent = find(ent, targetname, self.target);
	}
};

void() rotate_entity_think = 
{
	local float t;
	t = time - self.ltime;
	self.ltime = time;
	if (self.state == STATE_SPEEDINGUP)
	{
		self.count = self.count + self.cnt * t;
		if (self.count > USE_COUNT)
		{
			self.count = USE_COUNT;
		}
		t = t * self.count;
	}
	else
	{
		if (self.state == STATE_SLOWINGDOWN)
		{
			self.count = self.count - self.cnt * t;
			if (self.count < MSG_BROADCAST)
			{
				RotateTargetsFinal();
				self.state = STATE_INACTIVE;
				self.think = SUB_Null;
				return;
			}
			t = t * self.count;
		}
	}
	self.angles = self.angles + self.rotate * t;
	self.angles = SUB_NormalizeAngles(self.angles);
	RotateTargets();
	self.nextthink = time + 0.020000;
};

void() rotate_entity_use = 
{
	self.frame = USE_COUNT - self.frame;
	if (self.state == STATE_ACTIVE)
	{
		if (self.spawnflags & TOGGLE)
		{
			if (self.speed)
			{
				self.count = USE_COUNT;
				self.state = STATE_SLOWINGDOWN;
			}
			else
			{
				self.state = STATE_INACTIVE;
				self.think = SUB_Null;
			}
		}
	}
	else
	{
		if (self.state == STATE_INACTIVE)
		{
			self.think = rotate_entity_think;
			self.nextthink = time + 0.020000;
			self.ltime = time;
			if (self.speed)
			{
				self.count = MSG_BROADCAST;
				self.state = STATE_SPEEDINGUP;
			}
			else
			{
				self.state = STATE_ACTIVE;
			}
		}
		else
		{
			if (self.state == STATE_SPEEDINGUP)
			{
				if (self.spawnflags & TOGGLE)
				{
					self.state = STATE_SLOWINGDOWN;
				}
			}
			else
			{
				self.state = STATE_SPEEDINGUP;
			}
		}
	}
};

void() rotate_entity_firstthink = 
{
	LinkRotateTargets();
	if (self.spawnflags & START_ON)
	{
		self.state = STATE_ACTIVE;
		self.think = rotate_entity_think;
		self.nextthink = time + 0.020000;
		self.ltime = time;
	}
	else
	{
		self.state = STATE_INACTIVE;
		self.think = SUB_Null;
	}
	self.use = rotate_entity_use;
};

void() func_rotate_entity = 
{
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_NONE;
	setmodel(self, self.model);
	setsize(self, self.mins, self.maxs);
	if (self.speed != MSG_BROADCAST)
	{
		self.cnt = USE_COUNT / self.speed;
	}
	self.think = rotate_entity_firstthink;
	self.nextthink = time + 0.1;
	self.ltime = time;
};

void() path_rotate = 
{
	if (self.noise)
	{
		precache_sound(self.noise);
	}
	if (self.noise1)
	{
		precache_sound(self.noise1);
	}
};

void() rotate_train_think = 
{
	local float t;
	local float timeelapsed;
	t = time - self.ltime;
	self.ltime = time;
	if (self.endtime && time >= self.endtime)
	{
		self.endtime = MSG_BROADCAST;
		if (self.state == STATE_MOVE)
		{
			setorigin(self, self.finaldest);
			self.velocity = VEC_ORIGIN;
		}
		if (self.think1)
		{
			self.think1();
		}
	}
	else
	{
		timeelapsed = (time - self.cnt) * self.duration;
		if (timeelapsed > USE_COUNT)
		{
			timeelapsed = USE_COUNT;
		}
		setorigin(self, self.dest1 + self.dest2 * timeelapsed);
	}
	self.angles = self.angles + self.rotate * t;
	self.angles = SUB_NormalizeAngles(self.angles);
	RotateTargets();
	self.nextthink = time + 0.020000;
};

void() rotate_train_use = 
{
	if (self.think1 != rotate_train_find)
	{
		if (self.velocity != VEC_ORIGIN)
		{
			return;
		}
		if (self.think1)
		{
			self.think1();
		}
	}
};

void() rotate_train_wait = 
{
	self.state = STATE_WAIT;
	if (self.goalentity.noise)
	{
		sound(self, CHAN_VOICE, self.goalentity.noise, USE_COUNT, ATTN_NORM);
	}
	else
	{
		sound(self, CHAN_VOICE, self.noise, USE_COUNT, ATTN_NORM);
	}
	if (self.goalentity.spawnflags & ANGLES)
	{
		self.rotate = VEC_ORIGIN;
		self.angles = self.finalangle;
	}
	if (self.goalentity.spawnflags & NO_ROTATE)
	{
		self.rotate = VEC_ORIGIN;
	}
	self.endtime = self.ltime + self.goalentity.wait;
	self.think1 = rotate_train_next;
};

void() rotate_train_stop = 
{
	self.state = STATE_STOP;
	if (self.goalentity.noise)
	{
		sound(self, CHAN_VOICE, self.goalentity.noise, USE_COUNT, ATTN_NORM);
	}
	else
	{
		sound(self, CHAN_VOICE, self.noise, USE_COUNT, ATTN_NORM);
	}
	if (self.goalentity.spawnflags & ANGLES)
	{
		self.rotate = VEC_ORIGIN;
		self.angles = self.finalangle;
	}
	if (self.goalentity.spawnflags & NO_ROTATE)
	{
		self.rotate = VEC_ORIGIN;
	}
	self.dmg = MSG_BROADCAST;
	self.think1 = rotate_train_next;
};

void() rotate_train_next = 
{
	local entity targ;
	local entity current;
	local vector vdestdelta;
	local float len;
	local float traveltime;
	local float div;
	local string temp;
	self.state = STATE_NEXT;
	current = self.goalentity;
	targ = find(world, targetname, self.path);
	if (targ.classname != "path_rotate")
	{
		objerror("Next target is not path_rotate");
	}
	if (self.goalentity.noise1)
	{
		self.noise1 = self.goalentity.noise1;
	}
	sound(self, CHAN_VOICE, self.noise1, USE_COUNT, ATTN_NORM);
	self.goalentity = targ;
	self.path = targ.target;
	if (!(self.path))
	{
		objerror("rotate_train_next: no next target");
	}
	if (targ.spawnflags & STOP)
	{
		self.think1 = rotate_train_stop;
	}
	else
	{
		if (targ.wait)
		{
			self.think1 = rotate_train_wait;
		}
		else
		{
			self.think1 = rotate_train_next;
		}
	}
	if (current.event)
	{
		temp = self.target;
		self.target = current.event;
		self.message = current.message;
		SUB_UseTargets();
		self.target = temp;
		self.message = string_null;
	}
	if (current.spawnflags & ANGLES)
	{
		self.rotate = VEC_ORIGIN;
		self.angles = self.finalangle;
	}
	if (current.spawnflags & ROTATION)
	{
		self.rotate = current.rotate;
	}
	if (current.spawnflags & DAMAGE)
	{
		self.dmg = current.dmg;
	}
	if (current.spawnflags & SET_DAMAGE)
	{
		SetDamageOnTargets(current.dmg);
	}
	if (current.speed == CONTENT_EMPTY)
	{
		setorigin(self, targ.origin);
		self.endtime = self.ltime + 0.010000;
		SetTargetOrigin();
		if (targ.spawnflags & ANGLES)
		{
			self.angles = targ.angles;
		}
		self.duration = USE_COUNT;
		self.cnt = time;
		self.dest2 = VEC_ORIGIN;
		self.dest1 = self.origin;
		self.finaldest = self.origin;
	}
	else
	{
		self.state = STATE_MOVE;
		self.finaldest = targ.origin;
		if (self.finaldest == self.origin)
		{
			self.velocity = VEC_ORIGIN;
			self.endtime = self.ltime + 0.1;
			self.duration = USE_COUNT;
			self.cnt = time;
			self.dest2 = VEC_ORIGIN;
			self.dest1 = self.origin;
			self.finaldest = self.origin;
			return;
		}
		vdestdelta = self.finaldest - self.origin;
		len = vlen(vdestdelta);
		if (current.spawnflags & MOVETIME)
		{
			traveltime = current.speed;
		}
		else
		{
			if (current.speed > MSG_BROADCAST)
			{
				self.speed = current.speed;
			}
			if (!(self.speed))
			{
				objerror("No speed is defined!");
			}
			traveltime = len / self.speed;
		}
		if (traveltime < 0.1)
		{
			self.velocity = VEC_ORIGIN;
			self.endtime = self.ltime + 0.1;
			if (targ.spawnflags & ANGLES)
			{
				self.angles = targ.angles;
			}
			return;
		}
		div = USE_COUNT / traveltime;
		if (targ.spawnflags & ANGLES)
		{
			self.finalangle = SUB_NormalizeAngles(targ.angles);
			self.rotate = (targ.angles - self.angles) * div;
		}
		self.endtime = self.ltime + traveltime;
		self.velocity = vdestdelta * div;
		self.duration = div;
		self.cnt = time;
		self.dest2 = vdestdelta;
		self.dest1 = self.origin;
	}
};

void() rotate_train_find = 
{
	local entity targ;
	self.state = STATE_FIND;
	LinkRotateTargets();
	targ = find(world, targetname, self.path);
	if (targ.classname != "path_rotate")
	{
		objerror("Next target is not path_rotate");
	}
	self.goalentity = targ;
	if (targ.spawnflags & ANGLES)
	{
		self.angles = targ.angles;
		self.finalangle = SUB_NormalizeAngles(targ.angles);
	}
	self.path = targ.target;
	setorigin(self, targ.origin);
	SetTargetOrigin();
	RotateTargetsFinal();
	self.think1 = rotate_train_next;
	if (!(self.targetname))
	{
		self.endtime = self.ltime + 0.1;
	}
	else
	{
		self.endtime = MSG_BROADCAST;
	}
	self.duration = USE_COUNT;
	self.cnt = time;
	self.dest2 = VEC_ORIGIN;
	self.dest1 = self.origin;
};

void() rotate_train = 
{
	objerror("rotate_train entities should be changed to rotate_object with\nfunc_rotate_train controllers\n");
};

void() func_rotate_train = 
{
	if (!(self.speed))
	{
		self.speed = 100;
	}
	if (!(self.target))
	{
		objerror("rotate_train without a target");
	}
	if (!(self.noise))
	{
		if (self.sounds == MSG_BROADCAST)
		{
			self.noise = "misc/null.wav";
		}
		if (self.sounds == USE_COUNT)
		{
			self.noise = "plats/train2.wav";
		}
	}
	if (!(self.noise1))
	{
		if (self.sounds == MSG_BROADCAST)
		{
			self.noise1 = "misc/null.wav";
		}
		if (self.sounds == USE_COUNT)
		{
			self.noise1 = "plats/train1.wav";
		}
	}
	precache_sound(self.noise);
	precache_sound(self.noise1);
	self.cnt = USE_COUNT;
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_STEP;
	self.use = rotate_train_use;
	setmodel(self, self.model);
	setsize(self, self.mins, self.maxs);
	setorigin(self, self.origin);
	self.ltime = time;
	self.nextthink = self.ltime + 0.1;
	self.endtime = self.ltime + 0.1;
	self.think = rotate_train_think;
	self.think1 = rotate_train_find;
	self.state = STATE_FIND;
	self.duration = USE_COUNT;
	self.cnt = 0.1;
	self.dest2 = VEC_ORIGIN;
	self.dest1 = self.origin;
	self.flags = self.flags | FL_ONGROUND;
};

void() movewall_touch = 
{
	if (time < self.owner.attack_finished)
	{
		return;
	}
	if (self.dmg)
	{
		T_Damage(other, self, self.owner, self.dmg);
		self.owner.attack_finished = time + 0.5;
	}
	else
	{
		if (self.owner.dmg)
		{
			T_Damage(other, self, self.owner, self.owner.dmg);
			self.owner.attack_finished = time + 0.5;
		}
	}
};

void() movewall_blocked = 
{
	local entity temp;
	if (time < self.owner.attack_finished)
	{
		return;
	}
	self.owner.attack_finished = time + 0.5;
	if (self.owner.classname == "func_rotate_door")
	{
		temp = self;
		self = self.owner;
		rotate_door_group_reversedirection();
		self = temp;
	}
	if (self.dmg)
	{
		T_Damage(other, self, self.owner, self.dmg);
		self.owner.attack_finished = time + 0.5;
	}
	else
	{
		if (self.owner.dmg)
		{
			T_Damage(other, self, self.owner, self.owner.dmg);
			self.owner.attack_finished = time + 0.5;
		}
	}
};

void() movewall_think = 
{
	self.ltime = time;
	self.nextthink = time + 0.020000;
};

void() func_movewall = 
{
	self.angles = VEC_ORIGIN;
	self.movetype = MOVETYPE_PUSH;
	if (self.spawnflags & NONBLOCKING)
	{
		self.solid = SOLID_NOT;
	}
	else
	{
		self.solid = SOLID_BSP;
		self.blocked = movewall_blocked;
	}
	if (self.spawnflags & TOUCH)
	{
		self.touch = movewall_touch;
	}
	setmodel(self, self.model);
	if (!(self.spawnflags & VISIBLE))
	{
		self.model = string_null;
	}
	self.think = movewall_think;
	self.nextthink = time + 0.020000;
	self.ltime = time;
};

void() rotate_object = 
{
	self.classname = "rotate_object";
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_NONE;
	setmodel(self, self.model);
	setsize(self, self.mins, self.maxs);
	self.think = SUB_Null;
};

void() rotate_door_think2 = 
{
	local float t;
	t = time - self.ltime;
	self.ltime = time;
	self.frame = USE_COUNT - self.frame;
	self.angles = self.dest;
	if (self.state == STATE_OPENING)
	{
		self.state = STATE_OPEN;
	}
	else
	{
		if (self.spawnflags & STAYOPEN)
		{
			rotate_door_group_reversedirection();
			return;
		}
		self.state = STATE_CLOSED;
	}
	sound(self, CHAN_VOICE, self.noise3, USE_COUNT, ATTN_NORM);
	self.think = SUB_Null;
	RotateTargetsFinal();
};

void() rotate_door_think = 
{
	local float t;
	t = time - self.ltime;
	self.ltime = time;
	if (time < self.endtime)
	{
		self.angles = self.angles + self.rotate * t;
		RotateTargets();
	}
	else
	{
		self.angles = self.dest;
		RotateTargets();
		self.think = rotate_door_think2;
	}
	self.nextthink = time + 0.010000;
};

void() rotate_door_reversedirection = 
{
	local vector start;
	self.frame = USE_COUNT - self.frame;
	if (self.state == STATE_CLOSING)
	{
		start = self.dest1;
		self.dest = self.dest2;
		self.state = STATE_OPENING;
	}
	else
	{
		start = self.dest2;
		self.dest = self.dest1;
		self.state = STATE_CLOSING;
	}
	sound(self, CHAN_VOICE, self.noise2, USE_COUNT, ATTN_NORM);
	self.rotate = (self.dest - start) * (USE_COUNT / self.speed);
	self.think = rotate_door_think;
	self.nextthink = time + 0.020000;
	self.endtime = time + self.speed - (self.endtime - time);
	self.ltime = time;
};

void() rotate_door_group_reversedirection = 
{
	local string name;
	if (self.group)
	{
		name = self.group;
		self = find(world, group, name);
		while (self)
		{
			rotate_door_reversedirection();
			self = find(self, group, name);
		}
	}
	else
	{
		rotate_door_reversedirection();
	}
};

void() rotate_door_use = 
{
	local entity t;
	local vector start;
	if (self.state != STATE_OPEN && self.state != STATE_CLOSED)
	{
		return;
	}
	if (!(self.cnt))
	{
		self.cnt = USE_COUNT;
		LinkRotateTargets();
	}
	self.frame = USE_COUNT - self.frame;
	if (self.state == STATE_CLOSED)
	{
		start = self.dest1;
		self.dest = self.dest2;
		self.state = STATE_OPENING;
	}
	else
	{
		start = self.dest2;
		self.dest = self.dest1;
		self.state = STATE_CLOSING;
	}
	sound(self, CHAN_VOICE, self.noise2, USE_COUNT, ATTN_NORM);
	self.rotate = (self.dest - start) * (USE_COUNT / self.speed);
	self.think = rotate_door_think;
	self.nextthink = time + 0.010000;
	self.endtime = time + self.speed;
	self.ltime = time;
};

void() func_rotate_door = 
{
	if (!(self.target))
	{
		objerror("rotate_door without target.");
	}
	self.dest1 = VEC_ORIGIN;
	self.dest2 = self.angles;
	self.angles = self.dest1;
	if (!(self.speed))
	{
		self.speed = LIGHTNING_BOOM;
	}
	self.cnt = MSG_BROADCAST;
	if (!(self.dmg))
	{
		self.dmg = LIGHTNING_BOOM;
	}
	else
	{
		if (self.dmg < MSG_BROADCAST)
		{
			self.dmg = MSG_BROADCAST;
		}
	}
	if (self.sounds == MSG_BROADCAST)
	{
		self.sounds = USE_COUNT;
	}
	if (self.sounds == USE_COUNT)
	{
		precache_sound("doors/latch2.wav");
		precache_sound("doors/winch2.wav");
		precache_sound("doors/drclos4.wav");
		self.noise1 = "doors/latch2.wav";
		self.noise2 = "doors/winch2.wav";
		self.noise3 = "doors/drclos4.wav";
	}
	if (self.sounds == LIGHTNING_BOOM)
	{
		precache_sound("doors/airdoor1.wav");
		precache_sound("doors/airdoor2.wav");
		self.noise2 = "doors/airdoor1.wav";
		self.noise1 = "doors/airdoor2.wav";
		self.noise3 = "doors/airdoor2.wav";
	}
	if (self.sounds == STATE_FIND)
	{
		precache_sound("doors/basesec1.wav");
		precache_sound("doors/basesec2.wav");
		self.noise2 = "doors/basesec1.wav";
		self.noise1 = "doors/basesec2.wav";
		self.noise3 = "doors/basesec2.wav";
	}
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_NONE;
	setmodel(self, self.model);
	setorigin(self, self.origin);
	setsize(self, self.mins, self.maxs);
	self.state = STATE_CLOSED;
	self.use = rotate_door_use;
	self.think = SUB_Null;
};


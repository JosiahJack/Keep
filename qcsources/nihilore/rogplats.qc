void() dn_and_wait_hit_top = 
{
	sound(self, CHAN_VOICE, self.noise1, DN_N_WAIT, ATTN_NORM);
	self.state = STATE_TOP;
};

void() dn_and_wait_hit_bottom = 
{
	sound(self, CHAN_VOICE, self.noise1, DN_N_WAIT, ATTN_NORM);
	self.state = STATE_BOTTOM;
	self.think = dn_and_wait_go_up;
	self.nextthink = self.ltime + self.health;
};

void() dn_and_wait_go_down = 
{
	sound(self, CHAN_VOICE, self.noise, DN_N_WAIT, ATTN_NORM);
	self.state = STATE_DOWN;
	SUB_CalcMove(self.pos2, self.speed, dn_and_wait_hit_bottom);
};

void() dn_and_wait_go_up = 
{
	sound(self, CHAN_VOICE, self.noise, DN_N_WAIT, ATTN_NORM);
	self.state = STATE_UP;
	SUB_CalcMove(self.pos1, self.speed, dn_and_wait_hit_top);
};

void() dn_and_wait_crush = 
{
	T_Damage(other, self, self, DN_N_WAIT);
	if (self.state == STATE_UP)
	{
		dn_and_wait_go_down();
	}
	else
	{
		if (self.state == STATE_DOWN)
		{
			dn_and_wait_go_up();
		}
		else
		{
			objerror("plat_new_crush: bad self.state\n");
		}
	}
};

void() dn_and_wait_use = 
{
	if (self.state != STATE_TOP)
	{
		return;
	}
	dn_and_wait_go_down();
};

void() toggle_hit_top = 
{
	sound(self, CHAN_VOICE, self.noise1, DN_N_WAIT, ATTN_NORM);
	self.state = STATE_TOP;
};

void() toggle_hit_bottom = 
{
	sound(self, CHAN_VOICE, self.noise1, DN_N_WAIT, ATTN_NORM);
	self.state = STATE_BOTTOM;
};

void() toggle_go_down = 
{
	sound(self, CHAN_VOICE, self.noise, DN_N_WAIT, ATTN_NORM);
	self.state = STATE_DOWN;
	SUB_CalcMove(self.pos2, self.speed, toggle_hit_bottom);
};

void() toggle_go_up = 
{
	sound(self, CHAN_VOICE, self.noise, DN_N_WAIT, ATTN_NORM);
	self.state = STATE_UP;
	SUB_CalcMove(self.pos1, self.speed, toggle_hit_top);
};

void() toggle_crush = 
{
	T_Damage(other, self, self, DN_N_WAIT);
	if (self.state == STATE_UP)
	{
		toggle_go_down();
	}
	else
	{
		if (self.state == STATE_DOWN)
		{
			toggle_go_up();
		}
		else
		{
			objerror("plat_new_crush: bad self.state\n");
		}
	}
};

void() toggle_use = 
{
	if (self.state == STATE_TOP)
	{
		toggle_go_down();
	}
	else
	{
		if (self.state == STATE_BOTTOM)
		{
			toggle_go_up();
		}
	}
};

void() elvtr_stop = 
{
	self.currentammo = self.weapon;
	sound(self, CHAN_VOICE, self.noise1, DN_N_WAIT, ATTN_NORM);
	self.state = STATE_BOTTOM;
	self.endtime = time;
};

void() elvtr_go = 
{
	self.neworigin = self.pos2;
	self.neworigin_z = self.pos2_z + self.height * self.weapon;
	sound(self, CHAN_VOICE, self.noise, DN_N_WAIT, ATTN_NORM);
	self.state = STATE_UP;
	SUB_CalcMove(self.neworigin, self.speed, elvtr_stop);
	self.endtime = time;
};

void() elvtr_crush = 
{
	self.weapon = self.currentammo;
	elvtr_go();
};

void() elvtr_use = 
{
	local float tempDist;
	local float elvPos;
	local float btnPos;
	if (self.endtime + PLT_TOGGLE > time)
	{
		return;
	}
	self.endtime = time;
	if (ELV_BUTN_DIR == ELV_BUTN_DIR)
	{
		return;
	}
	elvPos = (self.absmin_z + self.absmax_z) * 0.5;
	btnPos = (other.absmin_z + other.absmax_z) * 0.5;
	if (elvPos > btnPos)
	{
		tempDist = (elvPos - btnPos) / self.height;
		tempDist = ceil(tempDist);
		self.weapon = self.currentammo - tempDist;
		elvtr_go();
		return;
	}
	else
	{
		tempDist = btnPos - elvPos;
		if (tempDist > self.height)
		{
			tempDist = tempDist / self.height;
			tempDist = floor(tempDist);
			self.weapon = self.currentammo + tempDist;
			elvtr_go();
			return;
		}
	}
	if (ELV_BUTN_DIR == CONTENT_EMPTY)
	{
		if (self.currentammo > ELV_BUTN_DIR)
		{
			self.weapon = self.currentammo - DN_N_WAIT;
			elvtr_go();
		}
	}
	else
	{
		if (ELV_BUTN_DIR == DN_N_WAIT)
		{
			if (self.currentammo < self.cnt - DN_N_WAIT)
			{
				self.weapon = self.currentammo + DN_N_WAIT;
				elvtr_go();
			}
		}
	}
};

void() plat2_spawn_inside_trigger = 
{
	local entity trigger;
	local vector tmin;
	local vector tmax;
	trigger = spawn();
	trigger.touch = plat2_center_touch;
	trigger.movetype = MOVETYPE_NONE;
	trigger.solid = SOLID_TRIGGER;
	trigger.enemy = self;
	tmin = self.mins + '25 25 0';
	tmax = self.maxs - '25 25 -8';
	tmin_z = tmax_z - (self.pos1_z - self.pos2_z + START_AT_TOP);
	if (self.spawnflags & PLAT_LOW_TRIGGER)
	{
		tmax_z = tmin_z + START_AT_TOP;
	}
	if (self.size_x <= 50)
	{
		tmin_x = (self.mins_x + self.maxs_x) / PLT_TOGGLE;
		tmax_x = tmin_x + DN_N_WAIT;
	}
	if (self.size_y <= 50)
	{
		tmin_y = (self.mins_y + self.maxs_y) / PLT_TOGGLE;
		tmax_y = tmin_y + DN_N_WAIT;
	}
	setsize(trigger, tmin, tmax);
};

void() plat2_hit_top = 
{
	sound(self, CHAN_VOICE, self.noise1, DN_N_WAIT, ATTN_NORM);
	self.state = STATE_TOP;
	self.waitmin = time;
	if (self.walkframe == DN_N_WAIT)
	{
		self.think = plat2_go_down;
		self.nextthink = self.ltime + 1.5;
		self.walkframe = ELV_BUTN_DIR;
		self.waitmin = ELV_BUTN_DIR;
	}
	else
	{
		if (!(self.spawnflags & START_AT_TOP))
		{
			self.think = plat2_go_down;
			self.nextthink = self.ltime + self.delay;
			self.walkframe = ELV_BUTN_DIR;
		}
	}
};

void() plat2_hit_bottom = 
{
	sound(self, CHAN_VOICE, self.noise1, DN_N_WAIT, ATTN_NORM);
	self.state = STATE_BOTTOM;
	self.waitmin = time;
	if (self.walkframe == DN_N_WAIT)
	{
		self.think = plat2_go_up;
		self.nextthink = self.ltime + 1.5;
		self.walkframe = ELV_BUTN_DIR;
		self.waitmin = ELV_BUTN_DIR;
	}
	else
	{
		if (self.spawnflags & START_AT_TOP)
		{
			self.think = plat2_go_up;
			self.nextthink = self.ltime + self.delay;
			self.walkframe = ELV_BUTN_DIR;
		}
	}
};

void() plat2_go_down = 
{
	sound(self, CHAN_VOICE, self.noise, DN_N_WAIT, ATTN_NORM);
	self.state = STATE_DOWN;
	SUB_CalcMove(self.pos2, self.speed, plat2_hit_bottom);
};

void() plat2_go_up = 
{
	sound(self, CHAN_VOICE, self.noise, DN_N_WAIT, ATTN_NORM);
	self.state = STATE_UP;
	SUB_CalcMove(self.pos1, self.speed, plat2_hit_top);
};

void() plat2_use = 
{
	if (self.state > ELEVATOR)
	{
		self.state = self.state - SVC_SETVIEWANGLES;
	}
	self.use = SUB_Null;
};

void() plat2_center_touch = 
{
	local float otherState;
	local vector platPosition;
	if (other.classname != "player")
	{
		return;
	}
	if (other.health <= ELV_BUTN_DIR)
	{
		return;
	}
	self = self.enemy;
	if (self.waitmin + PLT_TOGGLE > time)
	{
		return;
	}
	if (self.state > ELEVATOR)
	{
		return;
	}
	if (self.attack_state > STATE_BOTTOM)
	{
		if (self.waitmax < time)
		{
			if (self.attack_state == STATE_UP)
			{
				plat2_go_up();
			}
			else
			{
				plat2_go_down();
			}
			self.attack_state = ELV_BUTN_DIR;
		}
		return;
	}
	if (self.state > STATE_BOTTOM)
	{
		return;
	}
	platPosition = (self.absmax + self.absmin) * 0.5;
	if (self.state == STATE_TOP)
	{
		otherState = STATE_TOP;
		if (platPosition_z > other.origin_z)
		{
			otherState = STATE_BOTTOM;
		}
	}
	else
	{
		otherState = STATE_BOTTOM;
		if (other.origin_z - platPosition_z > self.height)
		{
			otherState = STATE_TOP;
		}
	}
	if (self.state == otherState)
	{
		self.walkframe = ELV_BUTN_DIR;
		self.waitmax = time + 0.5;
	}
	else
	{
		self.waitmax = time + 0.1;
		self.walkframe = DN_N_WAIT;
	}
	if (self.state == STATE_BOTTOM)
	{
		self.attack_state = STATE_UP;
	}
	else
	{
		if (self.state == STATE_TOP)
		{
			self.attack_state = STATE_DOWN;
		}
	}
};

void() plat2_crush = 
{
	T_Damage(other, self, self, DN_N_WAIT);
	if (self.state == STATE_UP)
	{
		plat2_go_down();
	}
	else
	{
		if (self.state == STATE_DOWN)
		{
			plat2_go_up();
		}
		else
		{
			objerror("plat2_crush: bad self.state\n");
		}
	}
};

void() func_new_plat = 
{
	local float negativeHeight;
	negativeHeight = ELV_BUTN_DIR;
	if (!(self.t_length))
	{
		self.t_length = 80;
	}
	if (!(self.t_width))
	{
		self.t_width = SVC_SETVIEWANGLES;
	}
	if (self.sounds == ELV_BUTN_DIR)
	{
		self.sounds = PLT_TOGGLE;
	}
	if (self.sounds == DN_N_WAIT)
	{
		precache_sound("plats/plat1.wav");
		precache_sound("plats/plat2.wav");
		self.noise = "plats/plat1.wav";
		self.noise1 = "plats/plat2.wav";
	}
	if (self.sounds == PLT_TOGGLE)
	{
		precache_sound("plats/medplat1.wav");
		precache_sound("plats/medplat2.wav");
		self.noise = "plats/medplat1.wav";
		self.noise1 = "plats/medplat2.wav";
	}
	self.mangle = self.angles;
	self.angles = VEC_ORIGIN;
	self.classname = "plat";
	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_PUSH;
	setorigin(self, self.origin);
	setmodel(self, self.model);
	setsize(self, self.mins, self.maxs);
	if (!(self.speed))
	{
		self.speed = 150;
	}
	self.pos1 = self.origin;
	self.pos2 = self.origin;
	if (self.height < ELV_BUTN_DIR)
	{
		negativeHeight = DN_N_WAIT;
		self.height = ELV_BUTN_DIR - self.height;
	}
	if (self.height)
	{
		self.pos2_z = self.origin_z - self.height;
	}
	else
	{
		negativeHeight = DN_N_WAIT;
		self.height = self.size_z - START_AT_TOP;
		self.pos2_z = self.origin_z - self.height;
	}
	if (self.spawnflags & DN_N_WAIT)
	{
		self.use = dn_and_wait_use;
		self.blocked = dn_and_wait_crush;
		if (negativeHeight == DN_N_WAIT)
		{
			self.state = STATE_BOTTOM;
			setorigin(self, self.pos2);
		}
		else
		{
			self.state = STATE_TOP;
		}
		if (!(self.health))
		{
			self.health = STATE_OPEN;
		}
	}
	else
	{
		if (self.spawnflags & PLT_TOGGLE)
		{
			self.use = toggle_use;
			self.blocked = toggle_crush;
			if (negativeHeight == DN_N_WAIT)
			{
				setorigin(self, self.pos2);
				self.state = STATE_BOTTOM;
			}
			else
			{
				self.state = STATE_TOP;
			}
		}
		else
		{
			if (self.spawnflags & ELEVATOR)
			{
				self.currentammo = ELV_BUTN_DIR;
				self.weapon = ELV_BUTN_DIR;
				self.endtime = ELV_BUTN_DIR;
				if (self.spawnflags & START_AT_TOP)
				{
					self.pos1 = self.origin;
					self.pos2 = self.origin;
					self.pos2_z = self.origin_z - self.height * (self.cnt - DN_N_WAIT);
					self.currentammo = self.cnt - DN_N_WAIT;
				}
				else
				{
					self.pos1 = self.origin;
					self.pos2 = self.origin;
					self.pos1_z = self.origin_z + self.height * (self.cnt - DN_N_WAIT);
					self.currentammo = ELV_BUTN_DIR;
				}
				self.use = elvtr_use;
				self.blocked = elvtr_crush;
			}
			else
			{
				if (self.spawnflags & PLAT2)
				{
					plat2_spawn_inside_trigger();
					self.walkframe = ELV_BUTN_DIR;
					self.waitmin = ELV_BUTN_DIR;
					self.attack_state = ELV_BUTN_DIR;
					self.waitmax = ELV_BUTN_DIR;
					self.blocked = plat2_crush;
					if (!(self.delay))
					{
						self.delay = STATE_FIND;
					}
					if (negativeHeight == DN_N_WAIT)
					{
						self.state = STATE_BOTTOM;
						self.spawnflags = PLAT2;
						setorigin(self, self.pos2);
					}
					else
					{
						self.spawnflags = self.spawnflags | START_AT_TOP;
						self.state = STATE_TOP;
					}
					if (self.targetname)
					{
						self.use = plat2_use;
						self.state = self.state + SVC_SETVIEWANGLES;
					}
				}
			}
		}
	}
};


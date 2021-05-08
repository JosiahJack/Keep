void() door2_stop = 
{
	sound(self, CHAN_BODY, "doors/close1.wav", PUSH_ONCE, ATTN_NONE);
	self.think = SUB_Null;
	self.nextthink = time + 0.1;
	return;
};

void() door2_use = 
{
	sound(self, CHAN_BODY, "doors/door1.wav", PUSH_ONCE, ATTN_NONE);
	SUB_CalcMove(self.pos2, self.speed, door2_stop);
};

void() door_error = 
{
	if (!(self.targetname))
	{
		bprint("func_door2 without a targetname, your door is not operational!\n");
	}
	self.nextthink = time + PUSH_ONCE;
};

void() func_door2 = 
{
	precache_sound("doors/door1.wav");
	precache_sound("doors/close1.wav");
	if (!(self.targetname))
	{
		bprint("func_door2 without a targetname, your door is not operational!\n");
		self.think = door_error;
		self.nextthink = time + PUSH_ONCE;
		return;
	}
	if (!(self.speed))
	{
		self.speed = 50;
	}
	if (!(self.height))
	{
		self.height = 125;
	}
	self.angles = VEC_ORIGIN;
	self.movetype = MOVETYPE_PUSH;
	self.solid = SOLID_BSP;
	self.use = door2_use;
	setmodel(self, self.model);
	setsize(self, self.mins, self.maxs);
	self.pos1 = self.origin;
	self.pos2 = self.origin;
	if (self.height)
	{
		if (self.cnt == STATE_TOP)
		{
			self.pos2_z = self.origin_z + self.height;
		}
		else
		{
			self.pos2_z = self.origin_z - self.height;
		}
	}
};


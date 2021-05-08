void() pend_swing1 = [0, pend_swing2]
{
	if (self.spawnflags & PEND_Y)
	{
		setsize(self, '-8 -176 48', '8 -120 128');
	}
	else
	{
		if (self.spawnflags & PEND_X)
		{
			setsize(self, '-176 -8 48', '-120 8 128');
		}
	}
	self.nextthink = time + 0.17;
	impactVelocity = PEND_X;
};

void() pend_swing2 = [1, pend_swing3]
{
	if (self.spawnflags & PEND_Y)
	{
		setsize(self, '-8 -172 12', '8 -112 88');
	}
	else
	{
		if (self.spawnflags & PEND_X)
		{
			setsize(self, '-172 -8 12', '-112 8 88');
		}
	}
	self.nextthink = time + 0.15;
};

void() pend_swing3 = [2, pend_swing4]
{
	if (self.spawnflags & PEND_Y)
	{
		setsize(self, '-8 -160 -22', '8 -96 50');
	}
	else
	{
		if (self.spawnflags & PEND_X)
		{
			setsize(self, '-160 -8 -22', '-96 8 50');
		}
	}
	self.nextthink = time + 0.13;
};

void() pend_swing4 = [3, pend_swing5]
{
	sound(self, CHAN_AUTO, "pendulum/swing.wav", 0.5, ATTN_NORM);
	if (self.spawnflags & PEND_Y)
	{
		setsize(self, '-8 -138 -51', '8 -70 17');
	}
	else
	{
		if (self.spawnflags & PEND_X)
		{
			setsize(self, '-138 -8 -51', '-70 8 17');
		}
	}
	self.nextthink = time + 0.11;
};

void() pend_swing5 = [4, pend_swing6]
{
	if (self.spawnflags & PEND_Y)
	{
		setsize(self, '-8 -110 -72', '8 -38 -8');
	}
	else
	{
		if (self.spawnflags & PEND_X)
		{
			setsize(self, '-110 -8 -72', '-38 8 -8');
		}
	}
	self.nextthink = time + 0.09;
};

void() pend_swing6 = [5, pend_swing7]
{
	if (self.spawnflags & PEND_Y)
	{
		setsize(self, '-8 -76 -83', '8 0 -23');
	}
	else
	{
		if (self.spawnflags & PEND_X)
		{
			setsize(self, '-76 -8 -83', '0 8 -23');
		}
	}
	self.nextthink = time + 0.07;
};

void() pend_swing7 = [6, pend_swing8]
{
	if (self.spawnflags & PEND_Y)
	{
		setsize(self, '-8 -40 -88', '8 40 -32');
	}
	else
	{
		if (self.spawnflags & PEND_X)
		{
			setsize(self, '-40 -8 -88', '40 8 -32');
		}
	}
	self.nextthink = time + 0.05;
};

void() pend_swing8 = [7, pend_swing9]
{
	if (self.spawnflags & PEND_Y)
	{
		setsize(self, '-8 0 -83', '8 76 -23');
	}
	else
	{
		if (self.spawnflags & PEND_X)
		{
			setsize(self, '0 -8 -83', '76 8 -23');
		}
	}
	self.nextthink = time + 0.07;
};

void() pend_swing9 = [8, pend_swing10]
{
	if (self.spawnflags & PEND_Y)
	{
		setsize(self, '-8 38 -72', '8 100 -8');
	}
	else
	{
		if (self.spawnflags & PEND_X)
		{
			setsize(self, '38 -8 -72', '100 8 -8');
		}
	}
	self.nextthink = time + 0.09;
};

void() pend_swing10 = [9, pend_swing11]
{
	if (self.spawnflags & PEND_Y)
	{
		setsize(self, '-8 70 -51', '8 138 17');
	}
	else
	{
		if (self.spawnflags & PEND_X)
		{
			setsize(self, '70 -8 -51', '138 8 17');
		}
	}
	self.nextthink = time + 0.11;
};

void() pend_swing11 = [10, pend_swing12]
{
	if (self.spawnflags & PEND_Y)
	{
		setsize(self, '-8 96 -22', '8 160 50');
	}
	else
	{
		if (self.spawnflags & PEND_X)
		{
			setsize(self, '96 -8 -22', '160 8 50');
		}
	}
	self.nextthink = time + 0.13;
};

void() pend_swing12 = [11, pend_swing13]
{
	if (self.spawnflags & PEND_Y)
	{
		setsize(self, '-8 112 12', '8 172 88');
	}
	else
	{
		if (self.spawnflags & PEND_X)
		{
			setsize(self, '112 -8 12', '172 8 88');
		}
	}
	self.nextthink = time + 0.15;
};

void() pend_swing13 = [12, pend_swing14]
{
	if (self.spawnflags & PEND_Y)
	{
		setsize(self, '-8 120 48', '8 176 128');
	}
	else
	{
		if (self.spawnflags & PEND_X)
		{
			setsize(self, '120 -8 48', '176 8 128');
		}
	}
	self.nextthink = time + 0.17;
};

void() pend_swing14 = [12, pend_swing15]
{
	self.nextthink = time + 0.17;
};

void() pend_swing15 = [11, pend_swing16]
{
	if (self.spawnflags & PEND_Y)
	{
		setsize(self, '-8 112 12', '8 172 88');
	}
	else
	{
		if (self.spawnflags & PEND_X)
		{
			setsize(self, '112 -8 12', '172 8 88');
		}
	}
	self.nextthink = time + 0.15;
	impactVelocity = CONTENT_EMPTY;
};

void() pend_swing16 = [10, pend_swing17]
{
	if (self.spawnflags & PEND_Y)
	{
		setsize(self, '-8 96 -22', '8 160 50');
	}
	else
	{
		if (self.spawnflags & PEND_X)
		{
			setsize(self, '96 -8 -22', '160 8 50');
		}
	}
	self.nextthink = time + 0.13;
};

void() pend_swing17 = [9, pend_swing18]
{
	sound(self, CHAN_AUTO, "pendulum/swing.wav", 0.5, ATTN_NORM);
	if (self.spawnflags & PEND_Y)
	{
		setsize(self, '-8 70 -51', '8 138 17');
	}
	else
	{
		if (self.spawnflags & PEND_X)
		{
			setsize(self, '70 -8 -51', '138 8 17');
		}
	}
	self.nextthink = time + 0.11;
};

void() pend_swing18 = [8, pend_swing19]
{
	if (self.spawnflags & PEND_Y)
	{
		setsize(self, '-8 38 -72', '8 100 -8');
	}
	else
	{
		if (self.spawnflags & PEND_X)
		{
			setsize(self, '38 -8 -72', '100 8 -8');
		}
	}
	self.nextthink = time + 0.09;
};

void() pend_swing19 = [7, pend_swing20]
{
	if (self.spawnflags & PEND_Y)
	{
		setsize(self, '-8 0 -83', '8 76 -23');
	}
	else
	{
		if (self.spawnflags & PEND_X)
		{
			setsize(self, '0 -8 -83', '76 8 -23');
		}
	}
	self.nextthink = time + 0.07;
};

void() pend_swing20 = [6, pend_swing21]
{
	if (self.spawnflags & PEND_Y)
	{
		setsize(self, '-8 -40 -88', '8 40 -32');
	}
	else
	{
		if (self.spawnflags & PEND_X)
		{
			setsize(self, '-40 -8 -88', '40 8 -32');
		}
	}
	self.nextthink = time + 0.05;
};

void() pend_swing21 = [5, pend_swing22]
{
	if (self.spawnflags & PEND_Y)
	{
		setsize(self, '-8 -76 -83', '8 0 -23');
	}
	else
	{
		if (self.spawnflags & PEND_X)
		{
			setsize(self, '-76 -8 -83', '0 8 -23');
		}
	}
	self.nextthink = time + 0.07;
};

void() pend_swing22 = [4, pend_swing23]
{
	if (self.spawnflags & PEND_Y)
	{
		setsize(self, '-8 -110 -72', '8 -28 -8');
	}
	else
	{
		if (self.spawnflags & PEND_X)
		{
			setsize(self, '-110 -8 -72', '-28 8 -8');
		}
	}
	self.nextthink = time + 0.09;
};

void() pend_swing23 = [3, pend_swing24]
{
	if (self.spawnflags & PEND_Y)
	{
		setsize(self, '-8 -172 -51', '8 -70 17');
	}
	else
	{
		if (self.spawnflags & PEND_X)
		{
			setsize(self, '-172 -8 -51', '-70 8 17');
		}
	}
	self.nextthink = time + 0.11;
};

void() pend_swing24 = [2, pend_swing25]
{
	if (self.spawnflags & PEND_Y)
	{
		setsize(self, '-8 -160 -22', '8 -96 50');
	}
	else
	{
		if (self.spawnflags & PEND_X)
		{
			setsize(self, '-160 -8 -22', '-96 8 50');
		}
	}
	self.nextthink = time + 0.13;
};

void() pend_swing25 = [1, pend_swing26]
{
	if (self.spawnflags & PEND_Y)
	{
		setsize(self, '-8 -172 12', '8 -112 88');
	}
	else
	{
		if (self.spawnflags & PEND_X)
		{
			setsize(self, '-172 -8 12', '-112 8 88');
		}
	}
	self.nextthink = time + 0.15;
};

void() pend_swing26 = [0, pend_swing1]
{
	if (self.spawnflags & PEND_Y)
	{
		setsize(self, '-8 -176 48', '8 -120 128');
	}
	else
	{
		if (self.spawnflags & PEND_X)
		{
			setsize(self, '-176 -8 48', '-120 8 128');
		}
	}
	self.nextthink = time + 0.17;
};

void() pend_touch = 
{
	if (other.health < PEND_X || other.takedamage == DAMAGE_NO)
	{
		return;
	}
	if (self.attack_finished < time)
	{
		sound(self, CHAN_VOICE, "pendulum/hit.wav", PEND_X, ATTN_NORM);
		self.attack_finished = time + PEND_X;
	}
	T_Damage(other, self, self, self.currentammo);
	if (self.spawnflags & PEND_Y)
	{
		other.velocity_y = impactVelocity * -250;
	}
	else
	{
		if (self.spawnflags & PEND_X)
		{
			other.velocity_x = impactVelocity * 250;
		}
	}
	other.velocity_z = 200;
	SpawnMeatSpray(other.origin, other.velocity);
};

void() pend_use = 
{
	self.nextthink = time + self.delay;
	self.think = pend_swing1;
};

void() pendulum = 
{
	local vector center;
	precache_model("progs/pendulum.mdl");
	precache_sound("pendulum/swing.wav");
	precache_sound("pendulum/hit.wav");
	setmodel(self, "progs/pendulum.mdl");
	if (!(self.spawnflags))
	{
		self.spawnflags = self.spawnflags + PEND_Y;
	}
	if (self.spawnflags & PEND_Y)
	{
		setsize(self, '-8 -24 -100', '8 24 100');
		self.angles = VEC_ORIGIN;
		self.v_angle = VEC_ORIGIN;
	}
	else
	{
		if (self.spawnflags & PEND_X)
		{
			setsize(self, '-24 -8 -100', '24 8 100');
			self.angles = '0 270 0';
			self.v_angle = '0 270 0';
		}
		else
		{
			error("ERROR: Unimplemented Pendulum Type (pendulum.qc)");
		}
	}
	if (!(self.currentammo))
	{
		self.currentammo = STATE_OPEN;
	}
	if (!(self.delay))
	{
		self.delay = PEND_X;
	}
	impactVelocity = ELV_BUTN_DIR;
	self.solid = SOLID_TRIGGER;
	self.takedamage = DAMAGE_NO;
	self.touch = pend_touch;
	if (self.spawnflags & PEND_TRG)
	{
		self.use = pend_use;
	}
	else
	{
		self.nextthink = time + self.delay;
		self.think = pend_swing1;
	}
};


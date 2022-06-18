void() hango1 = [0, hango2]
{
	if (random() < 0.1)
	{
		sound(self, CHAN_VOICE, "zombie/idle_w2.wav", SPAWN_CRUCIFIED, ATTN_STATIC);
	}
};

void() hango2 = [1, hango3]
{
	self.nextthink = time + 0.1 + random() * 0.1;
};

void() hango3 = [2, hango4]
{
	self.nextthink = time + 0.1 + random() * 0.1;
};

void() hango4 = [3, hango5]
{
	self.nextthink = time + 0.1 + random() * 0.1;
};

void() hango5 = [4, hango6]
{
	self.nextthink = time + 0.1 + random() * 0.1;
};

void() hango6 = [5, hango7]
{
	self.nextthink = time + 0.1 + random() * 0.1;
};

void() hango7 = [6, hango8]
{
	self.nextthink = time + 0.1 + random() * 0.1;
};

void() hango8 = [7, hango9]
{
	self.nextthink = time + 0.1 + random() * 0.1;
};

void() hango9 = [8, hango10]
{
	self.nextthink = time + 0.1 + random() * 0.1;
};

void() hango10 = [9, hango11]
{
	self.nextthink = time + 0.1 + random() * 0.1;
};

void() hango11 = [10, hango12]
{
	self.nextthink = time + 0.1 + random() * 0.1;
};

void() hango12 = [11, hango13]
{
	self.nextthink = time + 0.1 + random() * 0.1;
};

void() hango13 = [12, hango14]
{
	self.nextthink = time + 0.1 + random() * 0.1;
};

void() hango14 = [13, hango15]
{
	self.nextthink = time + 0.1 + random() * 0.1;
};

void() hango15 = [14, hango16]
{
	self.nextthink = time + 0.1 + random() * 0.1;
};

void() hango16 = [15, hango1]
{
	self.nextthink = time + 0.1 + random() * 0.1;
};

void() decor_hang = 
{
	precache_model("progs/hang.mdl");
	precache_sound("zombie/idle_w2.wav");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/hang.mdl");
	if (self.spawnflags & SPAWN_ROTHANG)
	{
		setsize(self, '-8 -9 -25', '5 13 36');
	}
	else
	{
		setsize(self, '-9 -8 -25', '13 5 36');
	}
	self.health = 61;
	self.movetype = MOVETYPE_NONE;
	hango1();
};


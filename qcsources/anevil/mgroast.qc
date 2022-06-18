void() sizzle1 = [0, sizzle2]
{
	if (random() < 0.1)
	{
		sound(self, CHAN_VOICE, "zombie/idle_w2.wav", SPAWN_CRUCIFIED, ATTN_STATIC);
	}
};

void() sizzle2 = [1, sizzle3]
{
	self.nextthink = time + 0.1 + random() * 0.1;
};

void() sizzle3 = [2, sizzle4]
{
	self.nextthink = time + 0.1 + random() * 0.1;
};

void() sizzle4 = [3, sizzle5]
{
	self.nextthink = time + 0.1 + random() * 0.1;
};

void() sizzle5 = [4, sizzle6]
{
	self.nextthink = time + 0.1 + random() * 0.1;
};

void() sizzle6 = [5, sizzle7]
{
	self.nextthink = time + 0.1 + random() * 0.1;
};

void() sizzle7 = [6, sizzle8]
{
	self.nextthink = time + 0.1 + random() * 0.1;
};

void() sizzle8 = [7, sizzle9]
{
	self.nextthink = time + 0.1 + random() * 0.1;
};

void() sizzle9 = [8, sizzle10]
{
	self.nextthink = time + 0.1 + random() * 0.1;
};

void() sizzle10 = [9, sizzle11]
{
	self.nextthink = time + 0.1 + random() * 0.1;
};

void() sizzle11 = [10, sizzle12]
{
	self.nextthink = time + 0.1 + random() * 0.1;
};

void() sizzle12 = [11, sizzle13]
{
	self.nextthink = time + 0.1 + random() * 0.1;
};

void() sizzle13 = [12, sizzle14]
{
	self.nextthink = time + 0.1 + random() * 0.1;
};

void() sizzle14 = [13, sizzle15]
{
	self.nextthink = time + 0.1 + random() * 0.1;
};

void() sizzle15 = [14, sizzle16]
{
	self.nextthink = time + 0.1 + random() * 0.1;
};

void() sizzle16 = [15, sizzle17]
{
	self.nextthink = time + 0.1 + random() * 0.1;
};

void() sizzle17 = [16, sizzle18]
{
	self.nextthink = time + 0.1 + random() * 0.1;
};

void() sizzle18 = [17, sizzle19]
{
	self.nextthink = time + 0.1 + random() * 0.1;
};

void() sizzle19 = [18, sizzle1]
{
	self.nextthink = time + 0.1 + random() * 0.1;
};

void() decor_roast = 
{
	precache_model("progs/roast.mdl");
	precache_sound("zombie/idle_w2.wav");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/roast.mdl");
	if (self.spawnflags & SPAWN_ROTROA)
	{
		setsize(self, '-47 -16 -20', '44 9 43');
	}
	else
	{
		setsize(self, '-16 -47 -20', '9 44 43');
	}
	self.health = 61;
	self.movetype = MOVETYPE_NONE;
	sizzle1();
};


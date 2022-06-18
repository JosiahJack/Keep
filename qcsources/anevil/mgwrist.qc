void() twistn1 = [0, twistn2]
{
	if (random() < 0.1)
	{
		sound(self, CHAN_VOICE, "zombie/idle_w2.wav", SPAWN_CRUCIFIED, ATTN_STATIC);
	}
};

void() twistn2 = [1, twistn3]
{
	self.nextthink = time + 0.1 + random() * 0.1;
};

void() twistn3 = [2, twistn4]
{
	self.nextthink = time + 0.1 + random() * 0.1;
};

void() twistn4 = [3, twistn5]
{
	self.nextthink = time + 0.1 + random() * 0.1;
};

void() twistn5 = [4, twistn6]
{
	self.nextthink = time + 0.1 + random() * 0.1;
};

void() twistn6 = [5, twistn7]
{
	self.nextthink = time + 0.1 + random() * 0.1;
};

void() twistn7 = [6, twistn8]
{
	self.nextthink = time + 0.1 + random() * 0.1;
};

void() twistn8 = [7, twistn9]
{
	self.nextthink = time + 0.1 + random() * 0.1;
};

void() twistn9 = [8, twistn10]
{
	self.nextthink = time + 0.1 + random() * 0.1;
};

void() twistn10 = [9, twistn11]
{
	self.nextthink = time + 0.1 + random() * 0.1;
};

void() twistn11 = [10, twistn12]
{
	self.nextthink = time + 0.1 + random() * 0.1;
};

void() twistn12 = [11, twistn13]
{
	self.nextthink = time + 0.1 + random() * 0.1;
};

void() twistn13 = [12, twistn14]
{
	self.nextthink = time + 0.1 + random() * 0.1;
};

void() twistn14 = [13, twistn15]
{
	self.nextthink = time + 0.1 + random() * 0.1;
};

void() twistn15 = [14, twistn16]
{
	self.nextthink = time + 0.1 + random() * 0.1;
};

void() twistn16 = [15, twistn1]
{
	self.nextthink = time + 0.1 + random() * 0.1;
};

void() decor_wrist = 
{
	precache_model("progs/hang.mdl");
	precache_sound("zombie/idle_w2.wav");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/hang.mdl");
	if (self.spawnflags & SPAWN_ROTWRI)
	{
		setsize(self, '-5 -5 25', '10 8 56');
	}
	else
	{
		setsize(self, '-5 -5 25', '8 10 56');
	}
	self.health = 61;
	self.movetype = MOVETYPE_NONE;
	twistn1();
};


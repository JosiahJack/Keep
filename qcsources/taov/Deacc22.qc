void() light_reset = 
{
	if (deathmatch || coop)
	{
		return;
	}
	lightstyle(STATE_TOP, "m");
	lightstyle(PLAT_LOW_TRIGGER, "mmnmmommommnonmmonqnmmo");
	lightstyle(IT_RELIC2, "abcdefghijklmnopqrstuvwxyzyxwvutsrqponmlkjihgfedcba");
	lightstyle(AS_MELEE, "mmmmmaaaaammmmmaaaaaabcdefgabcdefg");
	lightstyle(IT_RELIC3, "mamamamamama");
	lightstyle(TE_LIGHTNING1, "jklmnopqrstuvwxyzyxwvutsrqponmlkj");
	lightstyle(TE_LIGHTNING2, "nmonqnmomnmomomno");
	lightstyle(TE_WIZSPIKE, "mmmaaaabcdefgmmmmaaaammmaamm");
	lightstyle(IT_RELIC4, "mmmaaammmaaammmabcdefaaaammmmabcdefmmmaaaa");
	lightstyle(TE_LIGHTNING3, "aaaaaaaazzzzzzzz");
	lightstyle(TE_LAVASPLASH, "mmamammmmammamamaaamammma");
	lightstyle(TE_TELEPORT, "abcdefghijklmnopqrrqponmlkjihgfedcba");
	lightstyle(63, "a");
};

void() full_bright = 
{
	if (deathmatch || coop)
	{
		return;
	}
	lightstyle(STATE_TOP, "z");
	lightstyle(PLAT_LOW_TRIGGER, "z");
	lightstyle(IT_RELIC2, "z");
	lightstyle(AS_MELEE, "z");
	lightstyle(IT_RELIC3, "z");
	lightstyle(TE_LIGHTNING1, "z");
	lightstyle(TE_LIGHTNING2, "z");
	lightstyle(TE_WIZSPIKE, "z");
	lightstyle(IT_RELIC4, "z");
	lightstyle(TE_LIGHTNING3, "z");
	lightstyle(TE_LAVASPLASH, "z");
	lightstyle(TE_TELEPORT, "z");
	lightstyle(63, "z");
};

float(float min, float max) RandomRange = 
{
	local float width;
	local float offset;
	local float result;
	width = max - min;
	offset = random() * width;
	result = offset + min;
	return result;
};

void() lightning_strike = 
{
	local vector targ;
	if (random() < 0.2 && lightning_strikes == STATE_TOP)
	{
		lightning_strikes = lightning_strikes + PLAT_LOW_TRIGGER;
		self.cnt = 1;
		targ = self.origin - '0 0 400';
		targ_x = targ_x + RandomRange(-50, 50);
		targ_y = targ_y + RandomRange(-50, 50);
		WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte(MSG_BROADCAST, TE_LIGHTNING1);
		WriteEntity(MSG_BROADCAST, self);
		WriteCoord(MSG_BROADCAST, self.origin_x);
		WriteCoord(MSG_BROADCAST, self.origin_y);
		WriteCoord(MSG_BROADCAST, self.origin_z);
		WriteCoord(MSG_BROADCAST, targ_x);
		WriteCoord(MSG_BROADCAST, targ_y);
		WriteCoord(MSG_BROADCAST, targ_z);
	}
	if (self.cnt == 1)
	{
		lightning_strikes = lightning_strikes - PLAT_LOW_TRIGGER;
		self.cnt = 0;
	}
	light_reset();
	self.think = lightning;
	self.nextthink = time + 0.1;
};

void() lightning = 
{
	if (random() < 0.1)
	{
		full_bright();
	}
	self.think = lightning_strike;
	self.nextthink = time + TE_LAVASPLASH * random() * 0.5;
};


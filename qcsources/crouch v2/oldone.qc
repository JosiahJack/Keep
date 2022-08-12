void() old_idle1 = [0, old_idle2]
{
};

void() old_idle2 = [1, old_idle3]
{
};

void() old_idle3 = [2, old_idle4]
{
};

void() old_idle4 = [3, old_idle5]
{
};

void() old_idle5 = [4, old_idle6]
{
};

void() old_idle6 = [5, old_idle7]
{
};

void() old_idle7 = [6, old_idle8]
{
};

void() old_idle8 = [7, old_idle9]
{
};

void() old_idle9 = [8, old_idle10]
{
};

void() old_idle10 = [9, old_idle11]
{
};

void() old_idle11 = [10, old_idle12]
{
};

void() old_idle12 = [11, old_idle13]
{
};

void() old_idle13 = [12, old_idle14]
{
};

void() old_idle14 = [13, old_idle15]
{
};

void() old_idle15 = [14, old_idle16]
{
};

void() old_idle16 = [15, old_idle17]
{
};

void() old_idle17 = [16, old_idle18]
{
};

void() old_idle18 = [17, old_idle19]
{
};

void() old_idle19 = [18, old_idle20]
{
};

void() old_idle20 = [19, old_idle21]
{
};

void() old_idle21 = [20, old_idle22]
{
};

void() old_idle22 = [21, old_idle23]
{
};

void() old_idle23 = [22, old_idle24]
{
};

void() old_idle24 = [23, old_idle25]
{
};

void() old_idle25 = [24, old_idle26]
{
};

void() old_idle26 = [25, old_idle27]
{
};

void() old_idle27 = [26, old_idle28]
{
};

void() old_idle28 = [27, old_idle29]
{
};

void() old_idle29 = [28, old_idle30]
{
};

void() old_idle30 = [29, old_idle31]
{
};

void() old_idle31 = [30, old_idle32]
{
};

void() old_idle32 = [31, old_idle33]
{
};

void() old_idle33 = [32, old_idle34]
{
};

void() old_idle34 = [33, old_idle35]
{
};

void() old_idle35 = [34, old_idle36]
{
};

void() old_idle36 = [35, old_idle37]
{
};

void() old_idle37 = [36, old_idle38]
{
};

void() old_idle38 = [37, old_idle39]
{
};

void() old_idle39 = [38, old_idle40]
{
};

void() old_idle40 = [39, old_idle41]
{
};

void() old_idle41 = [40, old_idle42]
{
};

void() old_idle42 = [41, old_idle43]
{
};

void() old_idle43 = [42, old_idle44]
{
};

void() old_idle44 = [43, old_idle45]
{
};

void() old_idle45 = [44, old_idle46]
{
};

void() old_idle46 = [45, old_idle1]
{
};

void() old_thrash1 = [46, old_thrash2]
{
	lightstyle(0, "m");
};

void() old_thrash2 = [47, old_thrash3]
{
	lightstyle(0, "k");
};

void() old_thrash3 = [48, old_thrash4]
{
	lightstyle(0, "k");
};

void() old_thrash4 = [49, old_thrash5]
{
	lightstyle(0, "i");
};

void() old_thrash5 = [50, old_thrash6]
{
	lightstyle(0, "g");
};

void() old_thrash6 = [51, old_thrash7]
{
	lightstyle(0, "e");
};

void() old_thrash7 = [52, old_thrash8]
{
	lightstyle(0, "c");
};

void() old_thrash8 = [53, old_thrash9]
{
	lightstyle(0, "a");
};

void() old_thrash9 = [54, old_thrash10]
{
	lightstyle(0, "c");
};

void() old_thrash10 = [55, old_thrash11]
{
	lightstyle(0, "e");
};

void() old_thrash11 = [56, old_thrash12]
{
	lightstyle(0, "g");
};

void() old_thrash12 = [57, old_thrash13]
{
	lightstyle(0, "i");
};

void() old_thrash13 = [59, old_thrash14]
{
	lightstyle(0, "k");
};

void() old_thrash14 = [60, old_thrash15]
{
	lightstyle(0, "m");
};

void() old_thrash15 = [61, old_thrash16]
{
	lightstyle(0, "m");
	self.cnt = self.cnt + 1;
	if (self.cnt != 3)
	{
		self.think = old_thrash1;
	}
};

void() old_thrash16 = [62, old_thrash17]
{
	lightstyle(0, "g");
};

void() old_thrash17 = [63, old_thrash18]
{
	lightstyle(0, "c");
};

void() old_thrash18 = [64, old_thrash19]
{
	lightstyle(0, "b");
};

void() old_thrash19 = [65, old_thrash20]
{
	lightstyle(0, "a");
};

void() old_thrash20 = [66, old_thrash20]
{
	finale_4();
};

void() finale_1 = 
{
	local entity pos;
	local entity pl;
	local entity timer;
	intermission_exittime = time + 10000000;
	intermission_running = 1;
	pos = find(world, classname, "info_intermission");
	if (!pos)
	{
		error("no info_intermission");
	}
	pl = find(world, classname, "misc_teleporttrain");
	if (!pl)
	{
		error("no teleporttrain");
	}
	remove(pl);
	WriteByte(MSG_ALL, SVC_FINALE);
	WriteString(MSG_ALL, "");
	pl = find(world, classname, "player");
	while (pl != world)
	{
		pl.view_ofs = '0 0 0';
		pl.angles = other.v_angle = pos.mangle;
		pl.fixangle = 1;
		pl.map = self.map;
		pl.nextthink = time + 0.5;
		pl.takedamage = DAMAGE_NO;
		pl.solid = SOLID_NOT;
		pl.movetype = MOVETYPE_NONE;
		pl.modelindex = 0;
		setorigin(pl, pos.origin);
		pl = find(pl, classname, "player");
	}
	timer = spawn();
	timer.nextthink = time + 1;
	timer.think = finale_2;
};

void() finale_2 = 
{
	local vector o;
	o = shub.origin - '0 100 0';
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_TELEPORT);
	WriteCoord(MSG_BROADCAST, o_x);
	WriteCoord(MSG_BROADCAST, o_y);
	WriteCoord(MSG_BROADCAST, o_z);
	sound(shub, CHAN_VOICE, "misc/r_tele1.wav", 1, ATTN_NORM);
	self.nextthink = time + 2;
	self.think = finale_3;
};

void() finale_3 = 
{
	shub.think = old_thrash1;
	sound(shub, CHAN_VOICE, "boss2/death.wav", 1, ATTN_NORM);
	lightstyle(0, "abcdefghijklmlkjihgfedcb");
};

void() finale_4 = 
{
	local vector oldo;
	local float x;
	local float y;
	local float z;
	local float r;
	local entity n;
	sound(self, CHAN_VOICE, "boss2/pop2.wav", 1, ATTN_NORM);
	oldo = self.origin;
	z = 16;
	while (z <= 144)
	{
		x = -64;
		while (x <= 64)
		{
			y = -64;
			while (y <= 64)
			{
				self.origin_x = oldo_x + x;
				self.origin_y = oldo_y + y;
				self.origin_z = oldo_z + z;
				r = random();
				if (r < 0.3)
				{
					ThrowGib("progs/gib1.mdl", -999);
				}
				else
				{
					if (r < 0.6)
					{
						ThrowGib("progs/gib2.mdl", -999);
					}
					else
					{
						ThrowGib("progs/gib3.mdl", -999);
					}
				}
				y = y + 32;
			}
			x = x + 32;
		}
		z = z + 96;
	}
	WriteByte(MSG_ALL, SVC_FINALE);
	WriteString(MSG_ALL, "Congratulations and well done! You have\nbeaten the hideous Shub-Niggurath, and\nher hundreds of ugly changelings and\nmonsters. You have proven that your\nskill and your cunning are greater than\nall the powers of Quake. You are the\nmaster now. Id Software salutes you.");
	n = spawn();
	setmodel(n, "progs/player.mdl");
	oldo = oldo - '32 264 0';
	setorigin(n, oldo);
	n.angles = '0 290 0';
	n.frame = 1;
	remove(self);
	WriteByte(MSG_ALL, SVC_CDTRACK);
	WriteByte(MSG_ALL, 3);
	WriteByte(MSG_ALL, 3);
	lightstyle(0, "m");
};

void() monster_oldone = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model2("progs/oldone.mdl");
	precache_sound2("boss2/death.wav");
	precache_sound2("boss2/idle.wav");
	precache_sound2("boss2/sight.wav");
	precache_sound2("boss2/pop2.wav");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/oldone.mdl");
	setsize(self, '-160 -128 -24', '160 128 256');
	self.health = 40000;
	self.think = old_idle1;
	self.nextthink = time + 0.1;
	self.takedamage = DAMAGE_YES;
	self.th_die = finale_1;
	shub = self;
	total_monsters = total_monsters + 1;
};


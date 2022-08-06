void() snow_fall = 
{
	precache_model2("progs/snow.spr");
	self.nextthink = time + SPAWNFLAG_SUPERSPIKE;
	self.think = make_snow;
};

void() make_snow = 
{
	local float rnd1;
	local float rnd2;
	local entity bubble;
	bubble = spawn();
	setmodel(bubble, "progs/snow.spr");
	setorigin(bubble, self.origin);
	rnd1 = bubble.origin_x + (-20 + random() * 40);
	rnd2 = bubble.origin_y + (-20 + random() * 40);
	bubble.origin_x = rnd1;
	bubble.origin_y = rnd2;
	bubble.movetype = MOVETYPE_NOCLIP;
	bubble.solid = SOLID_NOT;
	bubble.velocity = '0 0 -30';
	bubble.nextthink = time + 0.5;
	bubble.think = snow_bob;
	bubble.touch = snow_remove;
	bubble.classname = "bubble";
	bubble.frame = MSG_BROADCAST;
	bubble.cnt = MSG_BROADCAST;
	setsize(bubble, '-8 -8 -8', '8 8 8');
	self.nextthink = time + random() + 0.5;
	self.think = make_snow;
};

void() snow_remove = 
{
	if (other.classname == self.classname)
	{
		return;
	}
	remove(self);
};

void() snow_bob = 
{
	local float rnd1;
	local float rnd2;
	local float rnd3;
	local vector vtmp1;
	local vector modi;
	self.cnt = self.cnt + SPAWNFLAG_SUPERSPIKE;
	if (self.cnt == 20)
	{
		remove(self);
		return;
	}
	rnd1 = self.velocity_x + (-20 + random() * 40);
	rnd2 = self.velocity_y + (-20 + random() * 40);
	rnd3 = self.velocity_z - 20 - random() * 20;
	self.velocity_x = rnd1;
	self.velocity_y = rnd2;
	self.velocity_z = rnd3;
	self.nextthink = time + 0.5;
	self.think = snow_bob;
};

void() smallsnow_fall = 
{
	precache_model2("progs/smlsnow.spr");
	self.nextthink = time + random() * 15;
	self.think = premake_smallsnow;
};

void() premake_smallsnow = 
{
	make_smallsnow();
	make_smallsnow();
	make_smallsnow();
	make_smallsnow();
	make_smallsnow();
	make_smallsnow();
	make_smallsnow();
	make_smallsnow();
	make_smallsnow();
	make_smallsnow();
	make_smallsnow();
	make_smallsnow();
};

void() make_smallsnow = 
{
	local float rnd1;
	local float rnd2;
	local float rnd3;
	local entity bubble;
	bubble = spawn();
	setmodel(bubble, "progs/smlsnow.spr");
	setorigin(bubble, self.origin);
	rnd1 = bubble.origin_x + (-20 + random() * 40);
	rnd2 = bubble.origin_y + (-20 + random() * 40);
	rnd3 = bubble.origin_z + (-10 + random() * 20);
	bubble.origin_x = rnd1;
	bubble.origin_y = rnd2;
	bubble.origin_z = rnd3;
	bubble.movetype = MOVETYPE_NOCLIP;
	bubble.solid = SOLID_NOT;
	bubble.velocity = '0 0 -30';
	bubble.nextthink = time;
	bubble.think = snow_bob;
	bubble.touch = snow_remove;
	bubble.classname = "bubble";
	bubble.frame = MSG_BROADCAST;
	bubble.cnt = MSG_BROADCAST;
	setsize(bubble, '-8 -8 -8', '8 8 8');
	self.nextthink = time + random() * 15;
	self.think = premake_smallsnow;
};

void() smallsnow_remove = 
{
	if (other.classname == self.classname)
	{
		return;
	}
	remove(self);
};

void() smallsnow_bob = 
{
	local float rnd3;
	local vector vtmp1;
	local vector modi;
	self.cnt = self.cnt + SPAWNFLAG_SUPERSPIKE;
	if (self.cnt == TE_LAVASPLASH)
	{
		remove(self);
		return;
	}
	rnd3 = self.velocity_z - 100;
	self.velocity_z = rnd3;
	self.nextthink = time + 0.5;
	self.think = smallsnow_bob;
};

void() leaf_fall = 
{
	precache_model("progs/leaf.mdl");
	self.nextthink = time + SPAWNFLAG_SUPERSPIKE;
	self.think = make_leaf;
};

void() make_leaf = 
{
	local float rnd1;
	local float rnd2;
	local entity bubble;
	bubble = spawn();
	setmodel(bubble, "progs/leaf.mdl");
	setorigin(bubble, self.origin);
	rnd1 = bubble.origin_x + (-20 + random() * 40);
	rnd2 = bubble.origin_y + (-20 + random() * 40);
	bubble.origin_x = rnd1;
	bubble.origin_y = rnd2;
	bubble.movetype = MOVETYPE_NOCLIP;
	bubble.solid = SOLID_NOT;
	bubble.velocity = '0 0 -30';
	bubble.nextthink = time + 0.5;
	bubble.think = leaf_bob;
	bubble.touch = leaf_remove;
	bubble.classname = "leaf";
	bubble.frame = MSG_BROADCAST;
	bubble.cnt = MSG_BROADCAST;
	bubble.angles = bubble.v_angle;
	setsize(bubble, '-8 -8 -8', '8 8 8');
	self.nextthink = time + random() + 0.5;
	self.think = make_leaf;
};

void() leaf_remove = 
{
	if (other.classname == self.classname)
	{
		return;
	}
	remove(self);
};

void() leaf_bob = 
{
	local float rnd1;
	local float rnd2;
	local float rnd3;
	local vector vtmp1;
	local vector modi;
	self.cnt = self.cnt + SPAWNFLAG_SUPERSPIKE;
	if (self.cnt == TE_LAVASPLASH)
	{
		remove(self);
		return;
	}
	rnd1 = self.velocity_x + (-160 + random() * 320);
	rnd2 = self.velocity_y + (-160 + random() * 320);
	rnd3 = self.velocity_z - 20 - random() * 20;
	self.velocity_x = rnd1;
	self.velocity_y = rnd2;
	self.velocity_z = rnd3;
	self.angles = self.v_angle;
	self.nextthink = time + 0.5;
	self.think = leaf_bob;
};

void() lostbubbles = 
{
	precache_model2("progs/s_bubble.spr");
	self.nextthink = time + SPAWNFLAG_SUPERSPIKE;
	self.think = make_lostbubble;
};

void() make_lostbubble = 
{
	local entity bubble;
	bubble = spawn();
	setmodel(bubble, "progs/s_bubble.spr");
	setorigin(bubble, self.origin);
	bubble.movetype = MOVETYPE_NOCLIP;
	bubble.solid = SOLID_NOT;
	bubble.velocity = '0 0 -30';
	bubble.nextthink = time + 0.5;
	bubble.think = lostbubble_bob;
	bubble.touch = lostbubble_remove;
	bubble.classname = "bubble";
	bubble.frame = MSG_BROADCAST;
	bubble.cnt = MSG_BROADCAST;
	setsize(bubble, '-8 -8 -8', '8 8 8');
	self.nextthink = time + random() + 0.5;
	self.think = make_lostbubble;
};

void() lostbubble_split = 
{
	local entity bubble;
	bubble = spawn();
	setmodel(bubble, "progs/s_bubble.spr");
	setorigin(bubble, self.origin);
	bubble.movetype = MOVETYPE_NOCLIP;
	bubble.solid = SOLID_NOT;
	bubble.velocity = '0 0 -30';
	bubble.nextthink = time + 0.5;
	bubble.think = snow_bob;
	bubble.touch = snow_remove;
	bubble.classname = "bubble";
	bubble.frame = SPAWNFLAG_SUPERSPIKE;
	bubble.cnt = TE_LAVASPLASH;
	setsize(bubble, '-8 -8 -8', '8 8 8');
	self.frame = SPAWNFLAG_SUPERSPIKE;
	self.cnt = TE_LAVASPLASH;
};

void() lostbubble_remove = 
{
	if (other.classname == self.classname)
	{
		return;
	}
	remove(self);
};

void() lostbubble_bob = 
{
	local float rnd1;
	local float rnd2;
	local float rnd3;
	local vector vtmp1;
	local vector modi;
	self.cnt = self.cnt + SPAWNFLAG_SUPERSPIKE;
	if (self.cnt == DOOR_DONT_LINK)
	{
		bubble_split();
	}
	if (self.cnt == 20)
	{
		remove(self);
		return;
	}
	rnd1 = self.velocity_x + (-20 + random() * 40);
	rnd2 = self.velocity_y + (-20 + random() * 40);
	rnd3 = self.velocity_z - 20 - random() * 20;
	if (rnd1 > 20)
	{
		rnd1 = TE_LAVASPLASH;
	}
	if (rnd1 < -20)
	{
		rnd1 = -10;
	}
	if (rnd2 > 20)
	{
		rnd2 = TE_LAVASPLASH;
	}
	if (rnd2 < -20)
	{
		rnd2 = -10;
	}
	if (rnd3 < -20)
	{
		rnd3 = -30;
	}
	if (rnd3 > -60)
	{
		rnd3 = -50;
	}
	self.velocity_x = rnd1;
	self.velocity_y = rnd2;
	self.velocity_z = rnd3;
	self.nextthink = time + 0.5;
	self.think = lostbubble_bob;
};

void() rain_fall = 
{
	precache_model2("progs/drop.spr");
	precache_model2("progs/drop.spr");
	self.nextthink = time + SPAWNFLAG_SUPERSPIKE;
	self.think = make_drop;
};

void() s_rain1 = [0, s_rain2]
{
};

void() s_rain2 = [1, s_rain3]
{
};

void() s_rain3 = [2, s_rain1]
{
};

void() make_rain = 
{
	local entity rain;
	rain = spawn();
	setmodel(rain, "progs/drop.spr");
	setorigin(rain, self.origin);
	rain.movetype = MOVETYPE_NOCLIP;
	rain.solid = SOLID_NOT;
	rain.frame = MSG_BROADCAST;
	rain.think = SUB_Remove;
	rain.nextthink = time + SPAWNFLAG_SUPERSPIKE;
	rain.velocity = '0 0 -250';
};

void() premake_drop = 
{
	make_drop();
};

void() make_drop = 
{
	local float rnd1;
	local float rnd2;
	local float r;
	local entity bubble;
	bubble = spawn();
	setmodel(bubble, "progs/drop.spr");
	setorigin(bubble, self.origin);
	rnd1 = bubble.origin_x + (-120 + random() * 240);
	rnd2 = bubble.origin_y + (-120 + random() * 240);
	bubble.origin_x = rnd1;
	bubble.origin_y = rnd2;
	bubble.movetype = MOVETYPE_TOSS;
	bubble.solid = SOLID_BBOX;
	bubble.velocity = '0 0 -50';
	bubble.touch = drop_bob;
	bubble.classname = "bubble";
	bubble.frame = MSG_BROADCAST;
	bubble.cnt = MSG_BROADCAST;
	setsize(bubble, VEC_ORIGIN, VEC_ORIGIN);
	self.nextthink = time + 0.2;
	self.think = premake_drop;
};

void() s_splash1 = [0, s_splash2]
{
};

void() s_splash2 = [1, s_splash3]
{
};

void() s_splash3 = [2, s_splash4]
{
};

void() s_splash4 = [3, s_splash5]
{
};

void() s_splash5 = [4, SUB_Remove]
{
};

void() drop_bob = 
{
	s_splash1();
};


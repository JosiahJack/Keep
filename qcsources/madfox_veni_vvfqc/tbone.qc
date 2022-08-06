$frame 0 1 2 3 4 5 6 7 8  

void() tbone_stand1    =[  0,       tbone_stand2  ] {};
void() tbone_stand2    =[  1,       tbone_stand3  ] {};
void() tbone_stand3    =[  2,       tbone_stand4  ] {};
void() tbone_stand4    =[  3,       tbone_stand5  ] {};
void() tbone_stand5    =[  4,       tbone_stand6  ] {};
void() tbone_stand6    =[  5,       tbone_stand7  ] {};
void() tbone_stand7    =[  6,       tbone_stand8  ] {};
void() tbone_stand8    =[  7,       tbone_stand9  ] {};
void() tbone_stand9    =[  8,       tbone_stand1  ] {};



void() model_tbone =
{
        precache_model ("progs/tbone.spr");
	self.solid = SOLID_BBOX;
	self.movetype = MOVETYPE_NONE;

	setmodel (self, "progs/tbone.spr");

	setsize (self, '16 16 16', '24 24 24');
	self.think = tbone_stand1;
        self.nextthink = time + 0.1;
};


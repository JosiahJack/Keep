void() coil_stand1 = [30, coil_stand1]
{
	ai_stand();
};

void() coil_rise = [0, coil_rise02]
{
	sound(self, CHAN_WEAPON, "boss1/out1.wav", CHAN_WEAPON, ATTN_NORM);
};

void() coil_rise02 = [1, coil_rise03]
{
};

void() coil_rise03 = [2, coil_rise04]
{
};

void() coil_rise04 = [3, coil_rise05]
{
};

void() coil_rise05 = [4, coil_rise06]
{
};

void() coil_rise06 = [5, coil_rise07]
{
};

void() coil_rise07 = [6, coil_rise08]
{
};

void() coil_rise08 = [7, coil_rise09]
{
};

void() coil_rise09 = [8, coil_rise10]
{
};

void() coil_rise10 = [9, coil_rise11]
{
};

void() coil_rise11 = [10, coil_rise12]
{
};

void() coil_rise12 = [11, coil_rise13]
{
};

void() coil_rise13 = [12, coil_rise14]
{
};

void() coil_rise14 = [13, coil_rise15]
{
};

void() coil_rise15 = [14, coil_rise16]
{
};

void() coil_rise16 = [15, coil_rise17]
{
};

void() coil_rise17 = [16, coil_run]
{
};

void() coil_walk01 = [0, coil_walk02]
{
	ai_walk(20);
};

void() coil_walk02 = [0, coil_walk03]
{
	ai_face();
	ai_walk(20);
};

void() coil_walk03 = [0, coil_walk04]
{
	ai_walk(20);
};

void() coil_walk04 = [0, coil_walk01]
{
	ai_face();
	ai_walk(20);
};

void() coil_run = [16, coil_run01]
{
};

void() coil_run01 = [15, coil_run02]
{
};

void() coil_run02 = [14, coil_run03]
{
};

void() coil_run03 = [13, coil_run04]
{
};

void() coil_run04 = [12, coil_run05]
{
};

void() coil_run05 = [11, coil_run06]
{
};

void() coil_run06 = [10, coil_run07]
{
};

void() coil_run07 = [9, coil_run08]
{
};

void() coil_run08 = [8, coil_run09]
{
};

void() coil_run09 = [7, coil_run10]
{
};

void() coil_run10 = [6, coil_run11]
{
};

void() coil_run11 = [5, coil_run12]
{
};

void() coil_run12 = [4, coil_run13]
{
};

void() coil_run13 = [3, coil_run14]
{
};

void() coil_run14 = [2, coil_run15]
{
};

void() coil_run15 = [1, coil_run16]
{
};

void() coil_run16 = [0, coil_run17]
{
};

void() coil_run17 = [36, coil_run18]
{
};

void() coil_run18 = [35, coil_run19]
{
};

void() coil_run19 = [34, coil_run20]
{
};

void() coil_run20 = [33, coil_run21]
{
};

void() coil_run21 = [32, coil_run22]
{
};

void() coil_run22 = [31, coil_explode1]
{
};

void() coil_move = [1, coil_move1]
{
	ai_walk(TE_LAVASPLASH);
	ai_face();
};

void() coil_move1 = [2, coil_move2]
{
	ai_walk(MOVETYPE_TOSS);
	ai_face();
};

void() coil_move2 = [0, coil_whuh]
{
	ai_walk(TE_LAVASPLASH);
	ai_face();
};

void() coil_whuh = 
{
	if (random() > 0.1)
	{
		coil_move();
	}
	else
	{
		coil_awake();
	}
};

void() coil_pain01 = [9, coil_pain02]
{
	ai_pain(ATTN_NORM);
};

void() coil_pain02 = [10, coil_pain03]
{
	ai_pain(ATTN_NORM);
};

void() coil_pain03 = [11, coil_run]
{
	ai_pain(ATTN_NORM);
};

void() coil_explode1 = 
{
	remove(self);
};

void() coil_awake = 
{
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_LAVASPLASH);
	WriteCoord(MSG_BROADCAST, self.origin_x);
	WriteCoord(MSG_BROADCAST, self.origin_y);
	WriteCoord(MSG_BROADCAST, self.origin_z);
	self.yaw_speed = 20;
	coil_rise();
};

void() monster_coil = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_sound2("blob/death1.wav");
	precache_sound2("boss1/out1.wav");
	precache_model2("progs/coils.mdl");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/coils.mdl");
	setsize(self, VEC_HULL2_MIN, VEC_HULL2_MAX);
	self.health = 8000;
	self.th_stand = coil_stand1;
	self.th_walk = coil_walk01;
	self.th_run = coil_awake;
	self.th_die = coil_explode1;
	self.th_pain = coil_pain01;
	self.th_missile = coil_run;
	self.think = walkmonster_start;
	self.nextthink = time + 0.1 + random() * 0.1;
	total_monsters = total_monsters - ATTN_NORM;
};


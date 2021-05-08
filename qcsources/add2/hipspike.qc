void() monster_spikemine = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model("progs/demon.mdl");
	precache_model("progs/h_demon.mdl");
	precache_sound("demon/ddeath.wav");
	precache_sound("demon/dhit2.wav");
	precache_sound("demon/djump.wav");
	precache_sound("demon/dpain1.wav");
	precache_sound("demon/idle1.wav");
	precache_sound("demon/sight2.wav");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/demon.mdl");
	setsize(self, VEC_HULL2_MIN, VEC_HULL2_MAX);
};


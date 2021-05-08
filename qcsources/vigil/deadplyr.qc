void() misc_deadplayer = 
{
	precache_model("progs/player.mdl");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_NONE;
	setmodel(self, "progs/player.mdl");
	setsize(self, VEC_HULL_MIN, '16 16 40');
	self.frame = 93;
	self.angles = '0 90 180';
};


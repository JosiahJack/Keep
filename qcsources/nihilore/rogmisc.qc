void() light_lantern = 
{
	precache_model("progs/lantern.mdl");
	setmodel(self, "progs/lantern.mdl");
	makestatic(self);
};

void() light_candle = 
{
	precache_model("progs/candle.mdl");
	setmodel(self, "progs/candle.mdl");
	makestatic(self);
};


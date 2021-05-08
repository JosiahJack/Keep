/*
float RANDOM_ANGLES = 1;

void() deco_generic =
{
	self.solid = SOLID_BBOX;

	if (self.spawnflags & RANDOM_ANGLES)
		self.angles_y = random()*360;
};

void() chair_touch =
{
	local vector dir;

	if (!other.flags & FL_CLIENT)
		return;

	dir = normalize(self.origin - other.origin);
	dir_z = 0;

	dir = vectoangles(dir);
	walkmove(dir_y, 1);
};

void() bdw_misc_chair = 
{
	precache_model("models/h2misc/chair.mdl");

	self.movetype = MOVETYPE_TOSS;

	deco_generic();
	setmodel(self, "models/h2misc/chair.mdl");
	setsize(self, '-8 -8 0', '8 8 32');

	self.touch = chair_touch;
};

void() bdw_misc_stool = 
{
	precache_model("models/h2misc/stool.mdl");

	deco_generic();
	setmodel(self, "models/h2misc/stool.mdl");
	setsize(self, '-7 -7 0', '7 7 18');
};

void() bdw_misc_pew = 
{
	precache_model("models/h2misc/pew.mdl");

	deco_generic();
	setmodel(self, "models/h2misc/pew.mdl");
	setsize(self, '-14 -38 0', '14 38 45');
};

void() bdw_misc_bench = 
{
	precache_model("models/h2misc/bench.mdl");
	deco_generic();
	setmodel(self, "models/h2misc/bench.mdl");
	setsize(self, '-10 -32 0', '10 32 20');
};

void() beefslab_gib =
{
	MonsterGibLarge("progs/gib4.mdl");
	remove(self);
};

void() bdw_misc_beefslab = 
{
	precache_model("models/h2misc/beefslab.mdl");
	deco_generic();
	setmodel(self, "models/h2misc/beefslab.mdl");
	setsize(self, '-16 -16 0', '16 16 64');

	self.takedamage = DAMAGE_AIM;
	self.health = 100;
	self.th_die = beefslab_gib;
};
*/
/*===================

eye_candy

just an entity with a configurable model and frames

===================*/

void() eye_candy_frames =
{
	self.nextthink = time + self.delay;//0.1;
	if(self.spawnflags & 1) // count frames backwards
	{
		self.frame = self.frame - 1;
		if(self.frame < self.waitmin)
			self.frame = self.waitmax;
	}
	else
	{
		self.frame = self.frame + 1;
		if(self.frame > self.waitmax)
			self.frame = self.waitmin;
	}
};

void() eye_candy =
{
	local vector emin, emax, eangles;
	emin = self.mins;
	emax = self.maxs;
	eangles = self.angles;
	self.movetype = MOVETYPE_FLY;

	if(self.solid)
		self.solid = SOLID_BBOX;
	else
		self.solid = SOLID_NOT;
	if(self.model)
		precache_model(self.model);
	else
	{
		precache_model("progs/player.mdl");
		self.model = "progs/player.mdl";
	}
	setmodel(self, self.model);
	if(self.waitmin || self.waitmax) // also for rotating textures
	{
		self.frame = self.waitmin;
		if(!self.delay)	self.delay = 0.1;
		self.nextthink = time + self.delay;// 0.1;
		self.think = eye_candy_frames;
	}
	if(emin != '0 0 0' || emax != '0 0 0')
		setsize(self, self.mins, self.maxs);
	eangles_x = anglemod(eangles_x) * -1;
	eangles_y = anglemod(eangles_y);
	eangles_z = anglemod(eangles_z);
	self.angles = eangles;
};


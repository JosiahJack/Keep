// Nahuels light beam code (for positioning models into map via .ent files. Example: large window beams)
// Extended to have solid and non_solid models and specific size. As well as possibility to use animations by Seven.


.float sold;	// to make models solid
.vector sizemin;	// for setsize box
.vector sizemax;	// for setsize box


void () startanimation = 		// plays an unlimited loop for animated models
{					// Independent to animation frame quantity and start or end frame value (as it reads it from the .ent file)
	if (self.frame >= self.end_anim)
		self.frame = self.start_anim;

	self.frame = self.frame + 1;

	if (self.animation_random_time)
	{
		if (self.animation_base_time)
			self.nextthink = time + self.animation_base_time + random() * self.animation_random_time;
		else
			self.nextthink = time + 0.1 + random() * self.animation_random_time;
	}
	else
		self.nextthink = time + 0.1;
	self.think = startanimation; 
};


void () place_model = 
{
	precache_model (self.model);
	setmodel (self,self.model);
	if (!self.sold)
		self.sold = 0;
	if (self.sold != 1)
		self.solid = SOLID_NOT;
	else 
		self.solid = SOLID_BBOX;
	if ((!self.sizemin)||(!self.sizemax))
		setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
	else
		setsize (self, self.sizemin, self.sizemax);
	if (!self.count)
		self.count = 1;
	self.alpha = self.alpha;
	self.skin = self.skin;
	self.scale = self.count;
	if (self.animation)
	{
		self.frame = self.start_anim;
		startanimation();
	}
};


void () model_init =
{
	if (((autocvar_ent_00 == 1) && (self.cnt == 0)) || ((autocvar_ent_01 == 1) && (self.cnt == 1)) || ((autocvar_ent_02 == 1) && (self.cnt == 2)) || ((autocvar_ent_03 == 1) && (self.cnt == 3))
		 || ((autocvar_ent_04 == 1) && (self.cnt == 4)) || ((autocvar_ent_05 == 1) && (self.cnt == 5)) || ((autocvar_ent_06 == 1) && (self.cnt == 6)) || ((autocvar_ent_07 == 1) && (self.cnt == 7))
		 || ((autocvar_ent_08 == 1) && (self.cnt == 8)) || ((autocvar_ent_09 == 1) && (self.cnt == 9)))
	{
		self.think = place_model;
		self.nextthink = time + 0.01;
	}
		else remove(self);
};


void () item_luz =
{
	local float t;
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_NONE;
	self.pflags = PFLAGS_FULLDYNAMIC;
	t = self.speed;
	self.light_lev = t;
	if (!self.color)
	self.color = '1.5 1.5 1.5';
	if (!self.skin)
	self.skin = 200;
};


void () luz_init =
{
	if (((autocvar_ent_00 == 1) && (self.cnt == 0)) || ((autocvar_ent_01 == 1) && (self.cnt == 1)) || ((autocvar_ent_02 == 1) && (self.cnt == 2)) || ((autocvar_ent_03 == 1) && (self.cnt == 3))
		 || ((autocvar_ent_04 == 1) && (self.cnt == 4)) || ((autocvar_ent_05 == 1) && (self.cnt == 5)) || ((autocvar_ent_06 == 1) && (self.cnt == 6)) || ((autocvar_ent_07 == 1) && (self.cnt == 7))
		 || ((autocvar_ent_08 == 1) && (self.cnt == 8)) || ((autocvar_ent_09 == 1) && (self.cnt == 9)))
	{
		self.think = item_luz;
		self.nextthink = time + 0.01;
	}
		else remove(self);
};

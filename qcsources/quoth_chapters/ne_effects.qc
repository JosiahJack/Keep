//===============================================================================================

.float multiplier;
/*
0 = white

1 = bluish white

2 = blue

3 = green

4 = orange

5 = red

6 = purple

*/

void() bug_bob =
{
	self.nextthink = time + 0.1;
	self.think = bug_bob;
	if (self.multiplier > 1)

		self.multiplier = self.multiplier - 0.15;
	if (self.multiplier < 1)
		self.multiplier = 1;
	
	
	self.velocity = self.velocity * 0.8 + (self.oldorigin - self.origin) * 0.2;

	if (random() < 0.03 && self.ltime < time)
	{
		//self.velocity_x = 5 + (random() * -10);
		//self.velocity_y = 5 + (random() * -10);
		//self.velocity_z = 5 + (random() * -10);
		//self.nextthink = time + 1;
		self.ltime = time + 6;
		self.multiplier = 4.5;
	}
	
	self.velocity = normalize(self.velocity);
	self.velocity = self.velocity * ((20 + random() * 8) * self.multiplier);
	

};



void() make_bugs =
{
	local	entity	bug;
	local	vector	svec;
	
	bug = spawn();
	
	bug.oldorigin = self.origin;
	
	bug.movetype = MOVETYPE_NOCLIP;
	bug.solid = SOLID_NOT;
	
	bug.velocity_x = 20 + (random() * -40);
	bug.velocity_y = 20 + (random() * -40);
	bug.velocity_z = 20 + (random() * -40);
	
	bug.nextthink = time + 0.1;
	bug.think = bug_bob;
	bug.classname = "lightchunk";
	bug.frame = 0;
	bug.cnt = 0;
	
	if (self.count > 1)
		setmodel (bug, "progs/marshsm.spr");
	else
		setmodel (bug, "progs/marsh.spr");
	
	bug.frame = self.color;
	
	svec_x = 20 + (random() * -40);

	svec_y = 20 + (random() * -40);

	svec_z = 20 + (random() * -40);
	

	svec = self.origin + svec;
	

	setorigin (bug, svec);
	

	

	setsize (bug, '0 0 0', '0 0 0');

	if (self.count < 5)
	{
		self.nextthink = time + 0.1;
		self.think = make_bugs;
	}
	else
		remove(self);

	self.count = self.count + 1;
};



void() light_marsh =
{
	precache_model("progs/marsh.spr");
	precache_model("progs/marshsm.spr");
	make_bugs();

};

/*QUAKED light_globe (0 1 0) (-8 -8 -8) (8 8 8)
Sphere globe light.
Default light value is 300
Default style is 0
*/
void() light_globe =
{
	precache_model ("progs/s_light.spr");
	setmodel (self, "progs/s_light.spr");
	
	self.frame = self.color;
	
	makestatic (self);
};
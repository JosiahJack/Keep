void() mapgate_setup =
{
	

	if (self.spawnflags & 1)

	{
	

		if (parm9 & self.mapindex)
			SUB_UseTargets();
		
	}
	else
	{
	
		if (!(parm9 & self.mapindex))
			SUB_UseTargets();
		
	}

};


void() info_mapgate =
{
	self.nextthink = time + 1;
	self.think = mapgate_setup;
};



//========================================================================================


void() endgate_setup =
{
	
	if (!(self.spawnflags & 1))
	{
	
		if (parm9 == self.mapindex)
			SUB_UseTargets();
		
	}
	else
	{
	
		if (parm9 != self.mapindex)
			SUB_UseTargets();
		
	}

};


void() info_endgate =
{
	if (self.mapindex == 1)

		self.mapindex = 1;

	else if (self.mapindex == 2)
		self.mapindex = 3;
	else if (self.mapindex == 3)
		self.mapindex = 7;
	else if (self.mapindex == 4)
		self.mapindex = 15;
	else if (self.mapindex == 5)
		self.mapindex = 31;
	else if (self.mapindex == 6)
		self.mapindex = 63;
	else if (self.mapindex == 7)
		self.mapindex = 127;
	else if (self.mapindex == 8)
		self.mapindex = 255;
	else if (self.mapindex == 9)
		self.mapindex = 511;
	else if (self.mapindex == 10)
		self.mapindex = 1023;

	self.nextthink = time + 1;
	self.think = endgate_setup;
};
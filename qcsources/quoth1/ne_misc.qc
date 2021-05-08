void() mapgate_setup = 
{
	if (self.spawnflags & LIGHTNING_RANDOM)
	{
		if (parm9 & self.mapindex)
		{
			SUB_UseTargets();
		}
	}
	else
	{
		if (!(parm9 & self.mapindex))
		{
			SUB_UseTargets();
		}
	}
};

void() info_mapgate = 
{
	self.nextthink = time + LIGHTNING_RANDOM;
	self.think = mapgate_setup;
};

void() endgate_setup = 
{
	if (!(self.spawnflags & LIGHTNING_RANDOM))
	{
		if (parm9 == self.mapindex)
		{
			SUB_UseTargets();
		}
	}
	else
	{
		if (parm9 != self.mapindex)
		{
			SUB_UseTargets();
		}
	}
};

void() info_endgate = 
{
	if (self.mapindex == LIGHTNING_RANDOM)
	{
		self.mapindex = LIGHTNING_RANDOM;
	}
	else
	{
		if (self.mapindex == LIGHTNING_BOOM)
		{
			self.mapindex = AS_MELEE;
		}
		else
		{
			if (self.mapindex == AS_MELEE)
			{
				self.mapindex = TE_WIZSPIKE;
			}
			else
			{
				if (self.mapindex == SECRET_1ST_DOWN)
				{
					self.mapindex = 15;
				}
				else
				{
					if (self.mapindex == AS_BLINDFIRE)
					{
						self.mapindex = SVC_FINALE;
					}
					else
					{
						if (self.mapindex == AS_LOITER)
						{
							self.mapindex = 63;
						}
						else
						{
							if (self.mapindex == TE_WIZSPIKE)
							{
								self.mapindex = 127;
							}
							else
							{
								if (self.mapindex == SECRET_NO_SHOOT)
								{
									self.mapindex = 255;
								}
								else
								{
									if (self.mapindex == TE_LIGHTNING3)
									{
										self.mapindex = 511;
									}
									else
									{
										if (self.mapindex == TE_LAVASPLASH)
										{
											self.mapindex = 1023;
										}
									}
								}
							}
						}
					}
				}
			}
		}
	}
	self.nextthink = time + LIGHTNING_RANDOM;
	self.think = endgate_setup;
};


void () Hmmm_something_burning;

void (entity head7) Enolagay =
{
	local entity bomby;

	bomby = spawn ();
	bomby.owner = head7;
	setorigin (bomby, head7.origin);
	bomby.think = Hmmm_something_burning;
	bomby.nextthink = time;
};


void () Hmmm_something_burning =
{
	if ((self.owner.classname != "player"))
		return;
	if ((self.owner.warp_factor == 1))
		stuffcmd (self.owner, "fov 180\n");
	else
	{
		if ((self.owner.warp_factor == 2))
			stuffcmd (self.owner, "fov 175\n");
		else
		{
			if ((self.owner.warp_factor == 3))
				stuffcmd (self.owner, "fov 165\n");
			else
			{
				if ((self.owner.warp_factor == 4))
					stuffcmd (self.owner, "fov 150\n");
				else
				{
					if ((self.owner.warp_factor == 5))
						stuffcmd (self.owner, "fov 130\n");
					else
					{
						if ((self.owner.warp_factor == 6))
							stuffcmd (self.owner, "fov 110\n");
						else
						{
							if ((self.owner.warp_factor == 7))
								stuffcmd (self.owner, "fov 90\n");
							else
							{
								if ((self.owner.warp_factor == 8))
									stuffcmd (self.owner, "fov 80\n");
								else
								{
									if ((self.owner.warp_factor == 9))
										stuffcmd (self.owner, "fov 75\n");
									else
									{
										if ((self.owner.warp_factor == 10))
											stuffcmd (self.owner, "fov 70\n");
										else
										{
											if ((self.owner.warp_factor == 11))
												stuffcmd (self.owner, "fov 75\n");
											else
											{
												if ((self.owner.warp_factor == 12))
													stuffcmd (self.owner, "fov 80\n");
												else
												{
													if ((self.owner.warp_factor == 13))
														stuffcmd (self.owner, "fov 85\n");
													else
													{
														stuffcmd (self.owner, "fov 90\n");
														self.think = SUB_Null;
														return;
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
			}
		}
	}
	self.owner.warp_factor = (self.owner.warp_factor + 1);
	self.think = Hmmm_something_burning;
	self.nextthink = (time + 0.05);
};


void () UpdateAmmoBars =
{
	local float bar;
	local float percent;
	local float special_happy_count;

	special_happy_count = 0;
	percent = self.ammo_shells2;
	while ((special_happy_count < 4))
	{
		if ((special_happy_count == 1))
			percent = (self.ammo_nails2 / 2);
		else
		{
			if ((special_happy_count == 2))
				percent = self.ammo_rockets2;
			else
			{
				if ((special_happy_count == 3))
					percent = self.ammo_cells2;
			}
		}
		if ((percent > 90))
		{
			percent = rint (((100 - percent) / 10));
			bar = (((1 - percent) * 100) + 99);
		}
		else
		{
			if ((percent > 45))
			{
				percent = rint ((((90 - percent) * 9) / 45));
				bar = (((9 - percent) * 10) + 9);
			}
			else
			{
				percent = rint ((((45 - percent) * 9) / 45));
				bar = (9 - percent);
			}
		}
		if ((special_happy_count == 0))
			self.ammo_shells = bar;
		else
		{
			if ((special_happy_count == 1))
				self.ammo_nails = bar;
			else
			{
				if ((special_happy_count == 2))
					self.ammo_rockets = bar;
				else
				{
					if ((special_happy_count == 3))
						self.ammo_cells = bar;
				}
			}
		}
		special_happy_count = (special_happy_count + 1);
	}
};


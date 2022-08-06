void() MOTD = 
{
	if (world.model == "maps/start.bsp" && self.motd_count < EF_DIMLIGHT)
	{
		self.motd_time = time + OPT_MOTD;
		self.motd_count = self.motd_count + OPT_MOTD;
		return;
	}
	if (world.model == "maps/aopdm1.bsp" && self.motd_count < EF_DIMLIGHT)
	{
		self.motd_time = time + OPT_MOTD;
		self.motd_count = self.motd_count + OPT_MOTD;
		return;
	}
	if (world.model == "maps/aopdm2.bsp" && self.motd_count < TE_LIGHTNING2)
	{
		self.motd_time = time + OPT_MOTD;
		self.motd_count = self.motd_count + OPT_MOTD;
		return;
	}
	if (world.model == "maps/aopdm3.bsp" && self.motd_count < TE_LIGHTNING1)
	{
		self.motd_time = time + OPT_MOTD;
		self.motd_count = self.motd_count + OPT_MOTD;
		return;
	}
	if (world.model == "maps/aopdm4.bsp" && self.motd_count < WEAPON_SPIKES)
	{
		self.motd_time = time + OPT_MOTD;
		self.motd_count = self.motd_count + OPT_MOTD;
		return;
	}
	if (world.model == "maps/aopdm5.bsp" && self.motd_count < WEAPON_SPIKES)
	{
		self.motd_time = time + OPT_MOTD;
		self.motd_count = self.motd_count + OPT_MOTD;
		return;
	}
	if (world.model == "maps/aopdm6.bsp" && self.motd_count < WEAPON_SPIKES)
	{
		self.motd_time = time + OPT_MOTD;
		self.motd_count = self.motd_count + OPT_MOTD;
		return;
	}
	self.motd_time = MSG_BROADCAST;
};


void() info_command_run =
{
	local	entity	pent;
	
	pent = find (world, classname, "player");
	
	//bprint (pent.classname);
	//bprint ("Running Command...\n");
	//localcmd(self.message); //try different method
	stuffcmd (pent, self.message);
	
	//SUB_Remove();
	//self.nextthink = time + 0.1;
	//self.think = info_command_run;	
};


void() info_command =
{
	//info_command_run();
	self.nextthink = time + 0.6;
	self.think = info_command_run;
	
	//info_command_run();

	/*
	if (self.message)
		self.think = info_command_run;
	*/
	
	//setmodel (self, "progs/player.mdl");
};
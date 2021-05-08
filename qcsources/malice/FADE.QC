/*
This source code has been reconstructed from PROGS.DAT and may not be
identical to the original source code.

Copyright (C) 1997 Epochalypse. Malice is a trade name of Quantum Axcess.
*/

void () dofade;

void () fadein =
{
	local entity fadeboy;

	fadeboy = spawn ();
	fadeboy.owner = self;
	fadeboy.think = dofade;
	fadeboy.nextthink = time;
	fadeboy.warp_factor = 8;
	return;
};


void () dofade =
{
	if (self.warp_factor == 0)
		remove (self);
	else if (self.warp_factor == 1)
		stuffcmd (self.owner, "v_cshift 0 0 0 0");
	else if (self.warp_factor == 2)
		stuffcmd (self.owner, "v_cshift 0 0 0 40");
	else if (self.warp_factor == 3)
		stuffcmd (self.owner, "v_cshift 0 0 0 80");
	else if (self.warp_factor == 4)
		stuffcmd (self.owner, "v_cshift 0 0 0 120");
	else if (self.warp_factor == 5)
		stuffcmd (self.owner, "v_cshift 0 0 0 160");
	else if (self.warp_factor == 6)
		stuffcmd (self.owner, "v_cshift 0 0 0 200");
	else if (self.warp_factor == 7)
		stuffcmd (self.owner, "v_cshift 0 0 0 240");
	else if (self.warp_factor == 8)
		stuffcmd (self.owner, "v_cshift 0 0 0 256");
	self.warp_factor = self.warp_factor - 1;
	self.nextthink = time + 0.05;
};


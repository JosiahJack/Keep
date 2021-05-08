/*
This source code has been reconstructed from PROGS.DAT and may not be
identical to the original source code.

Copyright (C) 1997 Epochalypse. Malice is a trade name of Quantum Axcess.
*/

float CHT_NORMSPEED  = 510;
float CHT_SCUBASPEED = 554;
float CHT_SUBSPEED   = 658;
float CHT_HOVERSPEED = 700;

float () preventcheat =
{
	if (vlen (self.velocity) >= self.cl_forwardspeed)
	{
		if (self.cl_forwardspeed == CHT_NORMSPEED)
			stuffcmd (self, "cl_forwardspeed 360\n");
		else if (self.cl_forwardspeed == CHT_SCUBASPEED)
			stuffcmd (self, "cl_forwardspeed 420\n");
		else if (self.cl_forwardspeed == CHT_SUBSPEED)
			stuffcmd (self, "cl_forwardspeed 550\n");
		else if (self.cl_forwardspeed == CHT_HOVERSPEED)
			stuffcmd (self, "cl_forwardspeed 600\n");
		stuffcmd (self, "cl_backspeed 360\n");
		stuffcmd (self, "cl_sidespeed 360\n");
		return (TRUE);
	}
	else
		return (FALSE);
};


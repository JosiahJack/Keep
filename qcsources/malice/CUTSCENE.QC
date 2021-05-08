/*
This source code has been reconstructed from PROGS.DAT and may not be
identical to the original source code.

Copyright (C) 1997 Epochalypse. Malice is a trade name of Quantum Axcess.
*/

string nextmap;

float () CheckStartDemos =
{
	local entity sucka;

	if (coop || deathmatch)
	{
		if (world.model == "maps/d6.bsp")
			nextmap = "d7";
		else if (world.model == "maps/d9.bsp")
			nextmap = "d12";
		else if (world.model == "maps/d12.bsp")
			nextmap = "d13";
		return (FALSE);
	}
	sucka = find (world, classname, "player");
	if (cvar ("developer") != TRUE)
		stuffcmd (sucka, "clear\n");
	stuffcmd (sucka, "v_cshift 0 0 0 255\n");
	if (world.model == "maps/start.bsp")
	{
		stuffcmd (sucka, "playdemo cuts/cut0\n");
		return (TRUE);
	}
	else if (world.model == "maps/d2.bsp")
	{
		stuffcmd (sucka, "playdemo cuts/cut3\n");
		return (TRUE);
	}
	else if (world.model == "maps/d6.bsp")
	{
		stuffcmd (sucka, "playdemo cuts/cut4\n");
		return (TRUE);
	}
	else if (world.model == "maps/d9.bsp")
	{
		stuffcmd (sucka, "playdemo cuts/cut5\n");
		return (TRUE);
	}
	else if (world.model == "maps/d12.bsp")
	{
		stuffcmd (sucka, "playdemo cuts/cut6\n");
		return (TRUE);
	}
	else if (world.model == "maps/d13.bsp")
	{
		stuffcmd (sucka, "playdemo cuts/cut7\n");
		return (TRUE);
	}
	else if (world.model == "maps/d15.bsp")
	{
			stuffcmd (sucka, "playdemo cuts/cut8\n");
			return (TRUE);
	}
	else
		return (FALSE);
};


/*
This source code has been reconstructed from PROGS.DAT and may not be
identical to the original source code.

Copyright (C) 1997 Epochalypse. Malice is a trade name of Quantum Axcess.
*/

void () dealwithskill =
{
	local float sk;

	sk = cvar ("skill");
	if (sk == 0)
		self.health = self.health * 0.5;
	else if (sk == 1)
		self.health = self.health;
	else if (sk == 2)
		self.health = self.health * 2.5;
	else if (sk == 3)
		self.health = 1;
};


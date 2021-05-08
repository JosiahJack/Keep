/*
This source code has been reconstructed from PROGS.DAT and may not be
identical to the original source code.

Copyright (C) 1997 Epochalypse. Malice is a trade name of Quantum Axcess.
*/

void () monster_army =
{
	self.classname = "monster_swat";
	monster_swat ();
};


void () monster_knight =
{
	self.classname = "monster_riot";
	monster_riot ();
};


void () monster_dog =
{
	self.classname = "monster_baboon";
	monster_baboon ();
};


void () monster_enforcer =
{
	self.classname = "monster_merc";
	monster_merc ();
};


void () monster_ogre =
{
	self.classname = "monster_torcher";
	monster_torcher ();
};


void () monster_hell_knight =
{
	if (random () < 0.5)
	{
		self.classname = "monster_riot";
		monster_riot ();
	}
	else
	{
		self.classname = "monster_torcher";
		monster_torcher ();
	}
};


void () monster_wizard =
{
	self.classname = "monster_probe";
	monster_probe ();
};


void () monster_fish =
{
	if (random () < 0.5)
	{
		self.classname = "monster_bara";
		monster_bara ();
	}
	else
	{
		self.classname = "monster_frogman";
		monster_frogman ();
	}
};


void () monster_demon1 =
{
	self.classname = "monster_baboon";
	monster_baboon ();
};


void () monster_shalrath =
{
	self.classname = "monster_rider";
	monster_rider ();
};


void () monster_shambler =
{
	if (random () < 0.5)
	{
		self.classname = "monster_hunter";
		monster_hunter ();
	}
	else
	{
		self.classname = "monster_banshee";
		monster_banshee ();
	}
};


void () monster_zombie =
{
	self.classname = "monster_merc";
	monster_merc ();
};


void () monster_tarbaby =
{
	self.classname = "monster_rats";
	monster_rats ();
};


void () item_artifact_invulnerability =
{
	utility_hoverboard ();
};


void () item_artifact_envirosuit =
{
	utility_scuba ();
};


void () item_artifact_invisibility =
{
	utility_probe ();
};


void () item_artifact_super_damage =
{
	bigassgun ();
};


void () item_armor1 =
{
	fire_extinguisher ();
};


void () item_armor2 =
{
	fire_extinguisher ();
};


void () item_armorInv =
{
	utility_parachute ();
};


void () misc_explobox =
{
	self.classname = "barrel";
	if (random () < 0.5)
		thing_barrel ();
	else
		thing_barrel2 ();
};


void () misc_explobox2 =
{
	self.classname = "small";
	thing_crate1 ();
};


void () misc_lavaball =
{
	remove (self);
};


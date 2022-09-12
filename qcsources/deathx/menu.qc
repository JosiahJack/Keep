string() Menu_main = 
{
	return "MAIN\n1.  Console Help\n2.   Weapon Help\n3. Old Rune Help\n4. New Rune Help\n5.     Item Help\n\n\n\n";
};

string() Menu_Rune1 = 
{
	return "Old Runes\n1.       Earth rune\n2. Black Magic Rune\n3.  Hell Magic Rune\n4.       Elder Rune\n\n\n\n";
};

string() Menu_Rune2 = 
{
	return "New Runes\n1. Shadow Magic Rune\n2. Resurrection Rune\n3.   Necromancy Rune\n4.         Gaia Rune\n5.    Ignorance Rune\n\n\n";
};

string() Menu_Rune_Earth = 
{
	return "Old Runes : Earth Magic Rune\n1/2 Damage from all sources.\n";
};

string() Menu_Rune_Black = 
{
	return "Old Runes : Black Magic Rune\n2 Times the damage from your weapons.\n";
};

string() Menu_Rune_Hell = 
{
	return "Old Runes : Hell Magic Rune\nDouble Fire Rate.\n";
};

string() Menu_Rune_Regen = 
{
	return "Old Runes : Elder Magic Rune\nYour Health slowly regenerates.\n";
};

string() Menu_Rune_Shadow = 
{
	return "New Runes : Shadow Magic Rune\nInvisibility and reduced noise.\n";
};

string() Menu_Rune_Res = 
{
	return "New Runes : Resurrection Rune\nAfter dying you respawn with\nall your weapons.\n";
};

string() Menu_Rune_Necro = 
{
	return "New Runes : Necromany Rune\nAfter killing someone (not GIBBING)\nit creates a Bot that is your ally.\n";
};

string() Menu_Rune_Gaia = 
{
	return "New Runes : Gaia Rune\nProtection from the Elements, including\nLava, Drowning, and Acid\n";
};

string() Menu_Rune_Ignore = 
{
	return "New Runes : Ignorance Rune\nYou cannot pick up or be affected by\n special items such as the\nPentagram and Quad.\n";
};

string() Menu_Console = 
{
	return "Console Commands\nobserver: Puts you into observer mode\ncommands:              Lists commands\ndroparmor:           Drops your armor\ndropweapon:      Drops Current Weapon\ndropbackpack:         Drops some ammo\nserverstat:    Displays Server Status\n";
};

string() Menu_Weapon = 
{
	return "Weapon | alias\nAxe | axe              Grapple | grapple\nAirfist | airfist      Shotgun | shotgun\nSniper rifle | sniper       SSG | Supers\nQuad Barrel | quads    Nailgun | nailgun\nSNG | supernail             GL | grenade\nCuster Bombs | cluster       RL | rocket\nWacky Missles | wacky    Plasma | plasma\nLG | lightning                 BFG | bfg\n";
};

string() Menu_Item = 
{
	return "Special DeathX Items\n1.            BloodLust\n2.  Torn Flesh of Souls\n3.       Shub's Trinket\n";
};

string() Menu_Item_Bloodlust = 
{
	return "Items : BloodLust\n4X the damage and you can only\nbe killed by gibbing.\n";
};

string() Menu_Item_Torn_Flesh = 
{
	return "Items : Torn Flesh Of Souls\nA regenerating Armor.\n Maximum goes up by 20 per kill.\n";
};

string() Menu_Item_Shubs_Trinket = 
{
	return "Items : Shub's Trinket\nDoes Random Stuff...\nMaybe its something good maybe its\n something bad. We just don't know!\n";
};

string() Get_Menu_txt = 
{
	local string txt;
	if (self.menu == -1)
	{
		txt = Menu_main();
	}
	else
	{
		if (self.menu == 1)
		{
			txt = Menu_Console();
		}
		else
		{
			if (self.menu == 2)
			{
				txt = Menu_Weapon();
			}
			else
			{
				if (self.menu == 3)
				{
					if (self.menulevel == 0)
					{
						txt = Menu_Rune1();
					}
					else
					{
						if (self.menulevel == 1)
						{
							txt = Menu_Rune_Earth();
						}
						else
						{
							if (self.menulevel == 2)
							{
								txt = Menu_Rune_Black();
							}
							else
							{
								if (self.menulevel == 3)
								{
									txt = Menu_Rune_Hell();
								}
								else
								{
									if (self.menulevel == 4)
									{
										txt = Menu_Rune_Regen();
									}
								}
							}
						}
					}
				}
				else
				{
					if (self.menu == 4)
					{
						if (self.menulevel == 0)
						{
							txt = Menu_Rune2();
						}
						else
						{
							if (self.menulevel == 1)
							{
								txt = Menu_Rune_Shadow();
							}
							else
							{
								if (self.menulevel == 2)
								{
									txt = Menu_Rune_Res();
								}
								else
								{
									if (self.menulevel == 3)
									{
										txt = Menu_Rune_Necro();
									}
									else
									{
										if (self.menulevel == 4)
										{
											txt = Menu_Rune_Gaia();
										}
										else
										{
											if (self.menulevel == 5)
											{
												txt = Menu_Rune_Ignore();
											}
										}
									}
								}
							}
						}
					}
					else
					{
						if (self.menu == 5)
						{
							if (self.menulevel == 0)
							{
								txt = Menu_Item();
							}
							else
							{
								if (self.menulevel == 1)
								{
									txt = Menu_Item_Bloodlust();
								}
								else
								{
									if (self.menulevel == 2)
									{
										txt = Menu_Item_Torn_Flesh();
									}
									else
									{
										if (self.menulevel == 3)
										{
											txt = Menu_Item_Shubs_Trinket();
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
	return txt;
};

void() CheckImpulse = 
{
	if (self.impulse == 9)
	{
		self.menu = 0;
		self.menulevel = 0;
		self.impulse = 0;
		return;
	}
	if (self.impulse == 8)
	{
		if (self.menulevel > 0)
		{
			self.menulevel = 0;
		}
		else
		{
			self.menu = -1;
		}
		self.impulse = 0;
		return;
	}
	if (self.menu == -1 && self.impulse < 6)
	{
		self.menulevel = 0;
		self.menu = self.impulse;
	}
	else
	{
		if (self.menulevel == 0 && self.menu != -1)
		{
			self.menulevel = self.impulse;
		}
	}
	self.impulse = 0;
};

void() Do_Menu = 
{
	local string txt;
	if (self.menu == 0)
	{
		self.menu = -1;
	}
	if (self.impulse)
	{
		CheckImpulse();
	}
	txt = Get_Menu_txt();
	if (txt == "")
	{
		txt = "Invalid Menu\n";
	}
	if (self.menu > 0)
	{
		centerprint4(self, "---DeathX Online Help---\n", txt, "8. Back\n", "9. Quit\n");
	}
	else
	{
		if (self.menu == -1)
		{
			centerprint3(self, "---DeathX Online Help---\n", txt, "9. Quit\n");
		}
	}
};


string() RuneStatus = 
{
	local string crune;
	if (self.player_flag & ITEM_RUNE1_FLAG)
	{
		crune = "Earth Rune                              ";
	}
	else
	{
		if (self.player_flag & ITEM_RUNE2_FLAG)
		{
			crune = "Black Magic Rune                        ";
		}
		else
		{
			if (self.player_flag & ITEM_RUNE3_FLAG)
			{
				crune = "Hell Magic Rune                         ";
			}
			else
			{
				if (self.player_flag & ITEM_RUNE4_FLAG)
				{
					crune = "Elder Magic Rune                        ";
				}
				else
				{
					if (self.player_flag & ITEM_RUNE5_FLAG)
					{
						crune = "Shadow Magic Rune                       ";
					}
					else
					{
						if (self.player_flag & ITEM_RUNE6_FLAG)
						{
							crune = "Resurection Rune                        ";
						}
						else
						{
							if (self.player_flag & ITEM_RUNE7_FLAG)
							{
								crune = "Necromancy Rune                         ";
							}
							else
							{
								if (self.player_flag & ITEM_RUNE8_FLAG)
								{
									crune = "Gaia Rune                               ";
								}
								else
								{
									if (self.player_flag & ITEM_RUNE9_FLAG)
									{
										crune = "Ignorance Rune                          ";
									}
									else
									{
										crune = "";
									}
								}
							}
						}
					}
				}
			}
		}
	}
	return crune;
};

void() WeaponStatus = 
{
	local string wepn;
	if (self.weapon == IT_AXE)
	{
		wepn = "\nAxe                                     ";
	}
	else
	{
		if (self.weapon == IT_SHOTGUN)
		{
			wepn = "\nShotgun                                 ";
		}
		else
		{
			if (self.weapon == IT_SUPER_SHOTGUN)
			{
				if (self.quad_shot != 2)
				{
					wepn = "\nSuper Shotgun                           ";
				}
				else
				{
					wepn = "\nDual Super Shotguns                     ";
				}
			}
			else
			{
				if (self.weapon == IT_NAILGUN)
				{
					wepn = "\nNailgun                                 ";
				}
				else
				{
					if (self.weapon == IT_SUPER_NAILGUN)
					{
						wepn = "\nSuper Nailgun                           ";
					}
					else
					{
						if (self.weapon == IT_GRENADE_LAUNCHER)
						{
							wepn = "\nGrenade Launcher                        ";
						}
						else
						{
							if (self.weapon == IT_ROCKET_LAUNCHER)
							{
								wepn = "\nRocket Launcher                         ";
							}
							else
							{
								if (self.weapon == IT_LIGHTNING)
								{
									wepn = "\nLightning Gun                           ";
								}
								else
								{
									if (self.weapon == IT_EXTRA_WEAPON)
									{
										if (self.weapon2 == WE_SNIPER_RIFLE)
										{
											wepn = "\nSniper Rifle                            ";
										}
										else
										{
											if (self.weapon2 == WE_GRAPPLE)
											{
												wepn = "\nGrappling Hook                          ";
											}
											else
											{
												if (self.weapon2 == WE_AIRFIST)
												{
													wepn = "\nAir Fist                                ";
												}
												else
												{
													if (self.weapon2 == WE_WACKY)
													{
														wepn = "\nWacky Missiles                          ";
													}
													else
													{
														if (self.weapon2 == WE_CLUSTER)
														{
															wepn = "\nCluster Bomb Launcher                   ";
														}
														else
														{
															if (self.weapon2 == WE_PLASMAGUN)
															{
																wepn = "\nPlasma Rifle                            ";
															}
															else
															{
																if (self.weapon2 == WE_BFG)
																{
																	wepn = "\nBFG 9000                                ";
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
			}
		}
	}
	return wepn;
};

void() AmmoStatus = 
{
	local string cammo1;
	cammo1 = ftos(self.currentammo);
	return cammo1;
};

void() HealthStatus = 
{
	local string chealth;
	chealth = ftos(self.health);
	return chealth;
};

void() ArmorStatus = 
{
	local string carmor;
	carmor = ftos(self.armorvalue * self.armortype);
	return carmor;
};

void() DamageCap = 
{
	local float armor;
	local float helth;
	local float cap;
	local string ret;
	armor = self.armorvalue * self.armortype;
	helth = self.health;
	cap = helth + armor;
	if (self.player_flag & ITEM_RUNE1_FLAG)
	{
		cap = cap * 2;
	}
	ret = ftos(cap);
	return ret;
};

void(entity set, string mes) SetMsg = 
{
	return;
};

void() ShowHealth = 
{
	local string looks;
	if (self.health > 100)
	{
		looks = "\nCondition:                         Great";
	}
	else
	{
		if (self.health == 100)
		{
			looks = "\nCondition:                          Fine";
		}
		else
		{
			if (self.health > 90)
			{
				looks = "\nCondition:                     Scrachted";
			}
			else
			{
				if (self.health > 65)
				{
					looks = "\nCondition:                          Hurt";
				}
				else
				{
					if (self.health > 35)
					{
						looks = "\nCondition:                       Wounded";
					}
					else
					{
						if (self.health > 10)
						{
							looks = "\nCondition:                           Bad";
						}
						else
						{
							looks = "\nCondition:                         Awful";
						}
					}
				}
			}
		}
	}
	return looks;
};

void() ShowStatus = 
{
	local string rune;
	local string weapn;
	local string ammom;
	local string am;
	local string sh;
	rune = RuneStatus();
	centerprint2(self, "\n\n\n\n\n\n\n\n\n\n\n\n", rune);
};


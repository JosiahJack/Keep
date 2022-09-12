void() ServerStatus = 
{
	sprint(self, "\nCurrent Server Settings\n");
	sprint(self, "-----------------------\n");
	if (servervars & SV_DROPRUNES)
	{
		sprint(self, "DropRunes\n");
	}
	if (servervars & SV_SHELLEJECT)
	{
		sprint(self, "Shell Eject\n");
	}
	if (servervars & SV_TAMMO)
	{
		sprint(self, "Teleporting Ammo\n");
	}
	if (servervars & SV_AIRMOVEITEMS)
	{
		sprint(self, "AirFist Move Items\n");
	}
	if (servervars & SV_SKINS)
	{
		sprint(self, "Skins\n");
	}
	sprint(self, "-----------------------\n\n");
};

void(string ali, float imp) Do_Alias = 
{
	local string impu;
	impu = ftos(imp);
	stuffcmd(self, "alias ");
	stuffcmd(self, ali);
	stuffcmd(self, " \"impulse ");
	stuffcmd(self, impu);
	stuffcmd(self, "\"\n");
};

void() MOTDShow = 
{
	local string s;
	local string start_msg;
	local string server_message;
	if (servervars & SV_STARTASOBSERVER)
	{
		start_msg = "Fire to play\n";
	}
	server_message = GetServerMessage();
	self.motd_shown = self.motd_shown + 1;
	if (self.motd_shown == 1)
	{
		sprint(self, "ƒÂ·ÙËÌ·Ù„Ë ÂÿÙÚÂÌÂ Platinum ≈‰ÈÙÈÔÓ ˆ±∞\n");
		sprint(self, "This server is running v1.00 Unmodified\n");
		sprint(self, "No Bots Please\n");
		ServerStatus();
		if (self.admin == 3)
		{
			Commands_Admin();
		}
		else
		{
			Commands_Player();
		}
	}
	centerprint4(self, "ƒÂ·ÙËÌ·Ù„Ë ÂÿÙÚÂÌÂ Platinum ≈‰ÈÙÈÔÓ ˆ±∞\nNo Bots Please\nBy\nMutilator - WeAsL - Wolvie\n", server_message, start_msg, "Type 'menu' for online help.\n");
	if (!(self.done_binding))
	{
		Do_Alias("commands", I_COMMANDS);
		Do_Alias("serverstat", I_SERVSTAT);
		Do_Alias("observer", I_OBSERVER);
		Do_Alias("warp", I_WARP);
		Do_Alias("noexitset", I_NOEXITSET);
		Do_Alias("skick", I_SKICK);
		Do_Alias("yes", I_YES);
		Do_Alias("no", I_NO);
		Do_Alias("shelleject", I_SHELLEJECT);
		Do_Alias("runedrop", I_DROPRUNES);
		Do_Alias("airmove", I_AIRMOVEITEMS);
		Do_Alias("skins", I_SKINS);
		Do_Alias("teleammo", I_TAMMO);
		Do_Alias("dropweapon", I_DROPWEAPON);
		Do_Alias("dropbackpack", I_DROPBACKPACK);
		Do_Alias("droparmor", I_DROPARMOR);
		Do_Alias("droprune", I_DROPRUNE);
		Do_Alias("admin", I_ADMIN);
		Do_Alias("dmset", I_DMSET);
		Do_Alias("menu", I_MENU);
		Do_Alias("0", 10);
		Do_Alias("1", 1);
		Do_Alias("2", 2);
		Do_Alias("3", 3);
		Do_Alias("4", 4);
		Do_Alias("5", 5);
		Do_Alias("6", 6);
		Do_Alias("7", 7);
		Do_Alias("8", 8);
		Do_Alias("9", 9);
		Do_Alias("10", 10);
		Do_Alias("axe", I_AXE2);
		Do_Alias("grapple", I_GRAPPLE);
		Do_Alias("airfist", I_AIRGUN);
		Do_Alias("shotgun", I_DUAL);
		Do_Alias("sniper", I_SNIPER);
		Do_Alias("supers", I_SSGUN);
		Do_Alias("quads", I_QSHOT);
		Do_Alias("nailgun", I_NAILGUN);
		Do_Alias("supernail", I_SNAILGUN);
		Do_Alias("grenade", I_GRENADE);
		Do_Alias("cluster", I_CLUSTER);
		Do_Alias("rocket", I_ROCKET);
		Do_Alias("wacky", I_WACKY);
		Do_Alias("plasma", I_PLASMAGUN);
		Do_Alias("lightning", I_LIGHTNING);
		Do_Alias("bfg", I_BFG);
		self.done_binding = 1;
	}
};

void() MOTDCheck = 
{
	if (self.motd < time && self.motd_shown != -1)
	{
		MOTDShow();
		self.motd = time + 1.9;
		if (self.motd_shown == 3)
		{
			self.motd_shown = -1;
		}
	}
};

void() W_WarpEpisode1 = 
{
	if (self.impulse == 1)
	{
		changelevel("e1m1");
	}
	else
	{
		if (self.impulse == 2)
		{
			changelevel("e1m2");
		}
		else
		{
			if (self.impulse == 3)
			{
				changelevel("e1m3");
			}
			else
			{
				if (self.impulse == 4)
				{
					changelevel("e1m4");
				}
				else
				{
					if (self.impulse == 5)
					{
						changelevel("e1m5");
					}
					else
					{
						if (self.impulse == 6)
						{
							changelevel("e1m6");
						}
						else
						{
							if (self.impulse == 7)
							{
								changelevel("e1m7");
							}
							else
							{
								if (self.impulse == 8)
								{
									changelevel("e1m8");
								}
							}
						}
					}
				}
			}
		}
	}
	self.impulse = 0;
	self.s_switch = 0;
	self.s_episode = 0;
};

void() W_WarpEpisode2 = 
{
	if (self.impulse == 1)
	{
		changelevel("e2m1");
	}
	else
	{
		if (self.impulse == 2)
		{
			changelevel("e2m2");
		}
		else
		{
			if (self.impulse == 3)
			{
				changelevel("e2m3");
			}
			else
			{
				if (self.impulse == 4)
				{
					changelevel("e2m4");
				}
				else
				{
					if (self.impulse == 5)
					{
						changelevel("e2m5");
					}
					else
					{
						if (self.impulse == 6)
						{
							changelevel("e2m6");
						}
						else
						{
							if (self.impulse == 7)
							{
								changelevel("e2m7");
							}
						}
					}
				}
			}
		}
	}
	self.impulse = 0;
	self.s_switch = 0;
	self.s_episode = 0;
};

void() W_WarpEpisode3 = 
{
	if (self.impulse == 1)
	{
		changelevel("e3m1");
	}
	else
	{
		if (self.impulse == 2)
		{
			changelevel("e3m2");
		}
		else
		{
			if (self.impulse == 3)
			{
				changelevel("e3m3");
			}
			else
			{
				if (self.impulse == 4)
				{
					changelevel("e3m4");
				}
				else
				{
					if (self.impulse == 5)
					{
						changelevel("e3m5");
					}
					else
					{
						if (self.impulse == 6)
						{
							changelevel("e3m6");
						}
						else
						{
							if (self.impulse == 7)
							{
								changelevel("e3m7");
							}
						}
					}
				}
			}
		}
	}
	self.impulse = 0;
	self.s_switch = 0;
	self.s_episode = 0;
};

void() W_WarpEpisode4 = 
{
	if (self.impulse == 1)
	{
		changelevel("e4m1");
	}
	else
	{
		if (self.impulse == 2)
		{
			changelevel("e4m2");
		}
		else
		{
			if (self.impulse == 3)
			{
				changelevel("e4m3");
			}
			else
			{
				if (self.impulse == 4)
				{
					changelevel("e4m4");
				}
				else
				{
					if (self.impulse == 5)
					{
						changelevel("e4m5");
					}
					else
					{
						if (self.impulse == 6)
						{
							changelevel("e4m6");
						}
						else
						{
							if (self.impulse == 7)
							{
								changelevel("e4m7");
							}
							else
							{
								if (self.impulse == 8)
								{
									changelevel("e4m8");
								}
							}
						}
					}
				}
			}
		}
	}
	self.impulse = 0;
	self.s_switch = 0;
	self.s_episode = 0;
};

void() W_WarpDeath = 
{
	if (self.impulse == 1)
	{
		changelevel("dm1");
	}
	else
	{
		if (self.impulse == 2)
		{
			changelevel("dm2");
		}
		else
		{
			if (self.impulse == 3)
			{
				changelevel("dm3");
			}
			else
			{
				if (self.impulse == 4)
				{
					changelevel("dm4");
				}
				else
				{
					if (self.impulse == 5)
					{
						changelevel("dm5");
					}
					else
					{
						if (self.impulse == 6)
						{
							changelevel("dm6");
						}
					}
				}
			}
		}
	}
	self.impulse = 0;
	self.s_switch = 0;
	self.s_episode = 0;
};

void() W_WarpStart = 
{
	changelevel("start");
};

void() W_WarpX = 
{
	if (self.impulse == 1)
	{
		changelevel("1dx1");
	}
	else
	{
		if (self.impulse == 2)
		{
			changelevel("1dx2");
		}
		else
		{
			if (self.impulse == 3)
			{
				changelevel("1dx3");
			}
			else
			{
				if (self.impulse == 4)
				{
					changelevel("1dx4");
				}
				else
				{
					if (self.impulse == 5)
					{
						changelevel("1dx5");
					}
					else
					{
						if (self.impulse == 6)
						{
							changelevel("1dx6");
						}
						else
						{
							if (self.impulse == 7)
							{
								changelevel("1dx7");
							}
							else
							{
								if (self.impulse == 8)
								{
									changelevel("1dx8");
								}
								else
								{
									if (self.impulse == 9)
									{
										changelevel("1dx9");
									}
								}
							}
						}
					}
				}
			}
		}
	}
	self.impulse = 0;
	self.s_switch = 0;
	self.s_episode = 0;
};

void() AdminCode = 
{
	local entity e;
	local float temp;
	temp = self.impulse;
	if (temp == 10)
	{
		temp = 0;
	}
	if (self.admin_stage == 1)
	{
		self.admincode_1 = temp * 1000;
		self.admin_stage = 2;
		sprint(self, "Enter second number of 4 digit code:\n");
	}
	else
	{
		if (self.admin_stage == 2)
		{
			self.admincode_2 = temp * 100;
			self.admin_stage = 3;
			sprint(self, "Enter third number of 4 digit code:\n");
		}
		else
		{
			if (self.admin_stage == 3)
			{
				self.admincode_3 = temp * 10;
				self.admin_stage = 4;
				sprint(self, "Enter fourth number of 4 digit code: \n");
			}
			else
			{
				if (self.admin_stage == 4)
				{
					self.admincode_4 = temp;
					self.admincode = self.admincode_1 + self.admincode_2 + self.admincode_3 + self.admincode_4;
					self.admin_stage = 0;
					sprint(self, "admin code entered\n");
					self.try = self.try + 1;
				}
			}
		}
	}
	if (self.try > 2)
	{
		bprint(self.netname);
		bprint(" failed admin code 3 times\n");
		stuffcmd(self, "disconnect\n");
	}
	if (self.admincode)
	{
		if (self.admincode == admin_code_real)
		{
			self.admin = 3;
			self.frags = 0;
			self.try = 0;
			MakeObserver();
			stuffcmd(self, "color 0\n");
			sprint(self, "\nAdministration privileges enabled\n");
			Commands_Admin();
		}
		self.admincode = 0;
		self.admincode_1 = 0;
		self.admincode_2 = 0;
		self.admincode_3 = 0;
		self.admincode_4 = 0;
	}
	self.impulse = 0;
};

void() MakeObserver = 
{
	local entity e;
	self.observer_status = OBSERVER_BECOME_OBSERVER;
	ObserverBecomeObserver(self);
	self.currentammo = 0;
	self.weaponmodel = "";
	self.weaponframe = 0;
	self.weapon = IT_EXTRA_WEAPON;
	self.observer = 1;
	stuffcmd(self, "color 0\n");
	DropRune();
};

void() Commands_Admin = 
{
	local string st;
	sprint(self, "\n");
	sprint(self, "Available Commands:\n");
	sprint(self, "noexitset        warp\n");
	sprint(self, "commands         dmset\n");
	sprint(self, "skick            yes\n");
	sprint(self, "shelleject       no\n");
	sprint(self, "runedrop         airmove\n");
	sprint(self, "skins            teleammo\n");
	sprint(self, "menu             serverstat\n");
	sprint(self, "\n");
};

void() Commands_Player = 
{
	local string st;
	sprint(self, "\n");
	sprint(self, "Available Commands:\n");
	sprint(self, "observer     commands \n");
	sprint(self, "droparmor    dropweapon\n");
	sprint(self, "dropbackpack menu\n");
	sprint(self, "serverstat\n");
	sprint(self, "\n");
};

void() StartKick = 
{
	self.cnt = 1;
	self.kick = 3;
	self.kicker = find(world, classname, "player");
	while (self.kicker.not_exist)
	{
		self.kicker = find(self.kicker, classname, "player");
	}
	sprint(self, "Kick ");
	sprint(self, self.kicker.netname);
	sprint(self, "?\n");
};

void() DoKick = 
{
	localcmd("kick ");
	localcmd(self.kicker.netname);
	localcmd("\n");
	stuffcmd(self.kicker, "disconnect\n");
	self.kick = 0;
	self.cnt = 2;
};

void() NextKick = 
{
	self.kicker = find(self.kicker, classname, "player");
	while (self.kicker.not_exist)
	{
		self.kicker = find(self.kicker, classname, "player");
	}
	if (self.kicker != world)
	{
		sprint(self, "Kick ");
		sprint(self, self.kicker.netname);
		sprint(self, "?\n");
	}
	else
	{
		sprint(self, "End of player list\n");
		self.kick = 0;
		self.cnt = 0;
	}
};

void() ToggleNoExit = 
{
	local float exset;
	exset = cvar("noexit");
	bprint("NoExit is now ");
	if (exset == 0)
	{
		bprint("1\n");
		localcmd("noexit 1\n");
	}
	else
	{
		if (exset == 1)
		{
			bprint("2\n");
			localcmd("noexit 2\n");
		}
		else
		{
			if (exset == 2)
			{
				bprint("3\n");
				localcmd("noexit 3\n");
			}
			else
			{
				if (exset == 3)
				{
					bprint("0\n");
					localcmd("noexit 0\n");
				}
			}
		}
	}
};

void() DMToggle = 
{
	bprint("Deathmatch is now ");
	if (cvar("deathmatch") == 1)
	{
		bprint(" 2\n");
		localcmd("deathmatch 2\n");
	}
	else
	{
		if (cvar("deathmatch") == 2)
		{
			bprint(" 3\n");
			localcmd("deathmatch 3\n");
		}
		else
		{
			bprint(" 1\n");
			localcmd("deathmatch 1\n");
		}
	}
	deathmatch = cvar("deathmatch");
};

void() TeamToggle = 
{
	bprint("Teamplay is now ");
	if (cvar("teamplay") == 1)
	{
		bprint("OFF\n");
		localcmd("teamplay 0\n");
	}
	else
	{
		bprint("ON\n");
		localcmd("teamplay 1\n");
	}
};

void() WarpSelect = 
{
	if (self.s_switch == 2)
	{
		if (self.s_episode == 1)
		{
			W_WarpEpisode1();
		}
		if (self.s_episode == 2)
		{
			W_WarpEpisode2();
		}
		if (self.s_episode == 3)
		{
			W_WarpEpisode3();
		}
		if (self.s_episode == 4)
		{
			W_WarpEpisode4();
		}
		if (self.s_episode == 5)
		{
			W_WarpDeath();
		}
		if (self.s_episode == 6)
		{
			W_WarpX();
		}
		return;
	}
	if (self.impulse < 8)
	{
		if (self.impulse == 7)
		{
			self.s_switch = 0;
			self.impulse = 0;
			W_WarpStart();
			return;
		}
		self.s_episode = self.impulse;
		sprint(self, "Enter destination level: \n");
		self.s_switch = 2;
	}
};

void() Toggle_Skins = 
{
	if (servervars & SV_SKINS)
	{
		bprint("Skins OFF\n");
		servervars = servervars - SV_SKINS;
	}
	else
	{
		bprint("Skins ON\n");
		servervars = servervars + SV_SKINS;
	}
};

void() Toggle_Airfist = 
{
	if (servervars & SV_AIRMOVEITEMS)
	{
		bprint("AirFist Move Items OFF\n");
		servervars = servervars - SV_AIRMOVEITEMS;
	}
	else
	{
		bprint("AirFist Move Items ON\n");
		servervars = servervars + SV_AIRMOVEITEMS;
	}
};

void() Toggle_DropRunes = 
{
	if (servervars & SV_DROPRUNES)
	{
		bprint("Rune dropping OFF\n");
		servervars = servervars - SV_DROPRUNES;
	}
	else
	{
		bprint("Rune dropping ON\n");
		servervars = servervars + SV_DROPRUNES;
	}
};

void() Toggle_ShellEject = 
{
	if (servervars & SV_SHELLEJECT)
	{
		bprint("Shell Ejection OFF\n");
		servervars = servervars - SV_SHELLEJECT;
	}
	else
	{
		bprint("Shell Ejection ON\n");
		servervars = servervars + SV_SHELLEJECT;
	}
};

void() Toggle_RandomLevels = 
{
	if (servervars & SV_RANDOMLEVELS)
	{
		bprint("Random Levels OFF\n");
		servervars = servervars - SV_RANDOMLEVELS;
	}
	else
	{
		bprint("Random Levels ON\n");
		servervars = servervars + SV_RANDOMLEVELS;
	}
};

void() Toggle_StartAsObserver = 
{
	if (servervars & SV_STARTASOBSERVER)
	{
		bprint("Start As Observer OFF\n");
		servervars = servervars - SV_STARTASOBSERVER;
	}
	else
	{
		bprint("Start As OBserver ON\n");
		servervars = servervars + SV_STARTASOBSERVER;
	}
};

void() Toggle_TeleAmmo = 
{
	if (servervars & SV_TAMMO)
	{
		bprint("Teleporting Ammo OFF\n");
		servervars = servervars - SV_TAMMO;
	}
	else
	{
		bprint("Teleporting Ammo ON\n");
		servervars = servervars + SV_TAMMO;
	}
};

void() ClientCommands = 
{
};

void() CheckComm = 
{
	if (self.admin == 3)
	{
		AdminCommands();
	}
	else
	{
		Commands_Player();
	}
};

void() AdminCommands = 
{
	if (self.admin != 3)
	{
		return;
	}
	if (self.impulse == I_DMSET)
	{
		DMToggle();
	}
	else
	{
		if (self.impulse == I_NOEXITSET)
		{
			ToggleNoExit();
		}
		else
		{
			if (self.impulse == I_SKICK)
			{
				StartKick();
			}
			else
			{
				if (self.impulse == I_YES)
				{
					if (self.cnt == 1)
					{
						DoKick();
					}
				}
				else
				{
					if (self.impulse == I_NO)
					{
						if (self.cnt == 1)
						{
							NextKick();
						}
					}
					else
					{
						if (self.impulse == I_COMMANDS)
						{
							Commands_Admin();
						}
						else
						{
							if (self.impulse == I_DROPRUNES)
							{
								Toggle_DropRunes();
							}
							else
							{
								if (self.impulse == I_SHELLEJECT)
								{
									Toggle_ShellEject();
								}
								else
								{
									if (self.impulse == I_DROPRUNES)
									{
										Toggle_DropRunes();
									}
									else
									{
										if (self.impulse == I_AIRMOVEITEMS)
										{
											Toggle_Airfist();
										}
										else
										{
											if (self.impulse == I_TAMMO)
											{
												Toggle_TeleAmmo();
											}
											else
											{
												if (self.impulse == I_RANDOMLEVELS)
												{
													Toggle_RandomLevels();
												}
												else
												{
													if (self.impulse == I_STARTASOBSERVER)
													{
														Toggle_StartAsObserver();
													}
													else
													{
														if (self.impulse == I_WARP)
														{
															sprint(self, "Enter destination episode: \n");
															self.s_switch = 1;
														}
														else
														{
															if (self.impulse >= 1 && self.impulse <= 10)
															{
																WarpSelect();
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
};


entity() SelectRuneSpawnPoint = 
{
	runespawn = find(runespawn, classname, "info_player_deathmatch");
	if (runespawn == world)
	{
		runespawn = find(runespawn, classname, "info_player_deathmatch");
	}
	if (runespawn == world)
	{
		error("no info_player_deathmatch to spawn rune");
	}
	return runespawn;
};

void() RuneTouch = 
{
	local string s;
	local float best;
	local entity stemp;
	if (self.nextthink - time > 115)
	{
		return;
	}
	if (other.shub_time > time || other.np_time > time)
	{
		return;
	}
	if (other.classname != "player")
	{
		return;
	}
	if (other.health <= 0)
	{
		return;
	}
	if (other == self.owner && self.nextthink - time > 110)
	{
		return;
	}
	if (other.player_flag & ITEM_RUNE_MASK)
	{
		if (other.rune_notice_time < time)
		{
			sprint(other, "You already have a rune.\n");
			other.rune_notice_time = time + 10;
		}
		return;
	}
	other.player_flag = other.player_flag | self.player_flag;
	self.nxtupdate = time;
	if (self.player_flag & ITEM_RUNE1_FLAG)
	{
		SetMsg(other, "You got the Earth Magic Rune!\n\nRESISTANCE\n\nYou now take half damage!");
	}
	if (self.player_flag & ITEM_RUNE2_FLAG)
	{
		SetMsg(other, "You got the Black Magic Rune!\n\nSTRENGTH\n\nYou now dish out double damage!");
	}
	if (self.player_flag & ITEM_RUNE3_FLAG)
	{
		SetMsg(other, "You got the Hell Magic Rune!\n\nHASTE\n\nYou now fire twice fast!");
	}
	if (self.player_flag & ITEM_RUNE4_FLAG)
	{
		SetMsg(other, "You got the Elder Magic Rune!\n\nREGENERATION\n\nYou now regenerate!");
	}
	if (self.player_flag & ITEM_RUNE5_FLAG)
	{
		SetMsg(other, "You got the Shadow Magic Rune!\n\nSTEALTH\n\nYou are now stealthy!");
	}
	if (self.player_flag & ITEM_RUNE6_FLAG)
	{
		SetMsg(other, "You got the Ressurection Rune!\n\nRESURRECTION\n\nYou are revived with all your items!");
	}
	if (self.player_flag & ITEM_RUNE7_FLAG)
	{
		SetMsg(other, "You got the Necromancy Rune!\n\nRAISE THE DEAD\n\nYour victims will now fight for you!");
	}
	if (self.player_flag & ITEM_RUNE8_FLAG)
	{
		SetMsg(other, "You got the Gaia Rune!\n\nELEMENTAL PROTECTION\n\nYou now are protected from the elements!");
	}
	if (self.player_flag & ITEM_RUNE9_FLAG)
	{
		SetMsg(other, "You got the Ignorance Rune!\n\nWHAT YOU DON'T KNOW CAN'T HURT YOU\n\nYou now are Immune to special items!");
	}
	sound(other, CHAN_ITEM, "weapons/lock4.wav", 1, ATTN_NORM);
	stuffcmd(other, "bf\n");
	remove(self);
	other.update = 1;
};

void() RuneRespawn = 
{
	local entity oself;
	oself = self;
	self = SelectRuneSpawnPoint();
	Do_DropRune(oself.player_flag);
	remove(oself);
};

void(float flag) Do_DropRune = 
{
	local entity item;
	item = spawn();
	item.origin = self.origin - '0 0 24';
	item.player_flag = flag;
	item.velocity_z = 200 + random() * 500;
	item.velocity_x = -500 + random() * 1000;
	item.velocity_y = -500 + random() * 1000;
	item.flags = FL_ITEM;
	item.solid = SOLID_TRIGGER;
	item.movetype = MOVETYPE_TOSS;
	item.nextthink = time + 120;
	if (flag & ITEM_RUNE1_FLAG)
	{
		setmodel(item, "progs/end1.mdl");
	}
	else
	{
		if (flag & ITEM_RUNE2_FLAG)
		{
			setmodel(item, "progs/end2.mdl");
		}
		else
		{
			if (flag & ITEM_RUNE3_FLAG)
			{
				setmodel(item, "progs/end3.mdl");
			}
			else
			{
				if (flag & ITEM_RUNE4_FLAG)
				{
					setmodel(item, "progs/end4.mdl");
				}
				else
				{
					if (flag & ITEM_RUNE5_FLAG)
					{
						setmodel(item, "progs/rune1.mdl");
					}
					else
					{
						if (flag & ITEM_RUNE6_FLAG)
						{
							setmodel(item, "progs/rune2.mdl");
						}
						else
						{
							if (flag & ITEM_RUNE7_FLAG)
							{
								setmodel(item, "progs/rune3.mdl");
							}
							else
							{
								if (flag & ITEM_RUNE8_FLAG)
								{
									setmodel(item, "progs/rune4.mdl");
								}
								else
								{
									if (flag & ITEM_RUNE9_FLAG)
									{
										setmodel(item, "progs/rune5.mdl");
									}
								}
							}
						}
					}
				}
			}
		}
	}
	setsize(item, '-16 -16 0', '16 16 56');
	item.touch = RuneTouch;
	item.owner = self;
	item.think = RuneRespawn;
};

void() DropRune = 
{
	self.nxtupdate = time;
	if (self.player_flag & ITEM_RUNE1_FLAG)
	{
		SetMsg(self, "Dropped the Earth Magic Rune\n");
		Do_DropRune(ITEM_RUNE1_FLAG);
	}
	if (self.player_flag & ITEM_RUNE2_FLAG)
	{
		SetMsg(self, "Dropped the Black Magic Rune\n");
		Do_DropRune(ITEM_RUNE2_FLAG);
	}
	if (self.player_flag & ITEM_RUNE3_FLAG)
	{
		SetMsg(self, "Dropped the Hell Magic Rune\n");
		Do_DropRune(ITEM_RUNE3_FLAG);
	}
	if (self.player_flag & ITEM_RUNE4_FLAG)
	{
		SetMsg(self, "Dropped the Elder Magic Rune\n");
		Do_DropRune(ITEM_RUNE4_FLAG);
	}
	if (self.player_flag & ITEM_RUNE5_FLAG)
	{
		SetMsg(self, "Dropped the Shadow Magic Rune\n");
		self.invis_time = time + 4;
		if (self.items & IT_INVISIBILITY)
		{
			self.items = self.items - (self.items & IT_INVISIBILITY);
		}
		self.effects = 0;
		self.invisible_finished = 0;
		self.invisible_time = 0;
		setmodel(self, "progs/player.mdl");
		setsize(self, '-16 -16 -24', '16 16 32');
		Do_DropRune(ITEM_RUNE5_FLAG);
	}
	if (self.player_flag & ITEM_RUNE6_FLAG)
	{
		SetMsg(self, "Dropped the Resurrection Rune\n");
		Do_DropRune(ITEM_RUNE6_FLAG);
	}
	if (self.player_flag & ITEM_RUNE7_FLAG)
	{
		SetMsg(self, "Dropped the Necromancy Rune\n");
		Do_DropRune(ITEM_RUNE7_FLAG);
	}
	if (self.player_flag & ITEM_RUNE8_FLAG)
	{
		SetMsg(self, "Dropped the Gaia Rune\n");
		Do_DropRune(ITEM_RUNE8_FLAG);
		self.air_finished = time + 12;
	}
	if (self.player_flag & ITEM_RUNE9_FLAG)
	{
		SetMsg(self, "Dropped the Ignorance Rune\n");
		Do_DropRune(ITEM_RUNE9_FLAG);
	}
	self.player_flag = self.player_flag - (self.player_flag & ITEM_RUNE_MASK);
};

void() DoRandomRune = 
{
	local float rnd;
	rnd = random() * 9;
	self = SelectRuneSpawnPoint();
	if (rnd < 1 && !(RUNES & ITEM_RUNE1_FLAG))
	{
		Do_DropRune(ITEM_RUNE1_FLAG);
		RUNES = RUNES + ITEM_RUNE1_FLAG;
		maderunes = maderunes + 1;
	}
	else
	{
		if (rnd < 2 && !(RUNES & ITEM_RUNE2_FLAG))
		{
			Do_DropRune(ITEM_RUNE2_FLAG);
			RUNES = RUNES + ITEM_RUNE2_FLAG;
			maderunes = maderunes + 1;
		}
		else
		{
			if (rnd < 3 && !(RUNES & ITEM_RUNE3_FLAG))
			{
				Do_DropRune(ITEM_RUNE3_FLAG);
				RUNES = RUNES + ITEM_RUNE3_FLAG;
				maderunes = maderunes + 1;
			}
			else
			{
				if (rnd < 4 && !(RUNES & ITEM_RUNE4_FLAG))
				{
					Do_DropRune(ITEM_RUNE4_FLAG);
					RUNES = RUNES + ITEM_RUNE4_FLAG;
					maderunes = maderunes + 1;
				}
				else
				{
					if (rnd < 5 && !(RUNES & ITEM_RUNE5_FLAG))
					{
						Do_DropRune(ITEM_RUNE5_FLAG);
						RUNES = RUNES + ITEM_RUNE5_FLAG;
						maderunes = maderunes + 1;
					}
					else
					{
						if (rnd < 6 && !(RUNES & ITEM_RUNE6_FLAG))
						{
							Do_DropRune(ITEM_RUNE6_FLAG);
							RUNES = RUNES + ITEM_RUNE6_FLAG;
							maderunes = maderunes + 1;
						}
						else
						{
							if (rnd < 7 && !(RUNES & ITEM_RUNE7_FLAG))
							{
								Do_DropRune(ITEM_RUNE7_FLAG);
								RUNES = RUNES + ITEM_RUNE7_FLAG;
								maderunes = maderunes + 1;
							}
							else
							{
								if (rnd < 8 && !(RUNES & ITEM_RUNE8_FLAG))
								{
									Do_DropRune(ITEM_RUNE8_FLAG);
									RUNES = RUNES + ITEM_RUNE8_FLAG;
									maderunes = maderunes + 1;
								}
								else
								{
									if (rnd < 9 && !(RUNES & ITEM_RUNE9_FLAG))
									{
										Do_DropRune(ITEM_RUNE9_FLAG);
										RUNES = RUNES + ITEM_RUNE9_FLAG;
										maderunes = maderunes + 1;
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

void() SpawnRunes = 
{
	local entity oself;
	local float i;
	if (runespawned)
	{
		remove(self);
		return;
	}
	oself = self;
	i = random() * 20;
	while (i > 0)
	{
		self = SelectRuneSpawnPoint();
		i = i - 1;
	}
	if (MAX_RUNES == 0)
	{
		MAX_RUNES = 9;
	}
	maderunes = 0;
	while (maderunes < MAX_RUNES)
	{
		DoRandomRune();
	}
	runespawned = 1;
	remove(oself);
};


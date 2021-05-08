void() global_sound_one_use = 
{
	local float s_choice;
	local entity pent;
	pent = find(world, classname, "player");
	self.think = global_sound_one_use;
	if (random() < 0.5)
	{
		self.nextthink = time + WEAPON_BIG + AS_LOITER * random();
		s_choice = rint(random() * AS_MELEE);
		if (s_choice == MSG_BROADCAST)
		{
			sound(pent, CHAN_AUTO, "gamb/gd1.wav", WEAPON_SHOTGUN, ATTN_NONE);
		}
		else
		{
			if (s_choice == WEAPON_SHOTGUN)
			{
				sound(pent, CHAN_AUTO, "gamb/gd2.wav", WEAPON_SHOTGUN, ATTN_NONE);
			}
			else
			{
				if (s_choice == WEAPON_ROCKET)
				{
					sound(pent, CHAN_AUTO, "gamb/gd3.wav", WEAPON_SHOTGUN, ATTN_NONE);
				}
				else
				{
					sound(pent, CHAN_AUTO, "gamb/gd4.wav", WEAPON_SHOTGUN, ATTN_NONE);
				}
			}
		}
	}
	else
	{
		if (random() < 0.95)
		{
			self.nextthink = time + 15 + WEAPON_SPIKES * random();
			s_choice = rint(random() * AS_LOITER);
			if (s_choice == MSG_BROADCAST)
			{
				sound(pent, CHAN_AUTO, "gamb/tmna_t1.wav", WEAPON_SHOTGUN, ATTN_NONE);
			}
			else
			{
				if (s_choice == WEAPON_SHOTGUN)
				{
					sound(pent, CHAN_AUTO, "gamb/tmna_t2.wav", WEAPON_SHOTGUN, ATTN_NONE);
				}
				else
				{
					if (s_choice == WEAPON_ROCKET)
					{
						sound(pent, CHAN_AUTO, "gamb/tmna_t3.wav", WEAPON_SHOTGUN, ATTN_NONE);
					}
					else
					{
						if (s_choice == AS_MELEE)
						{
							sound(pent, CHAN_AUTO, "gamb/tmna_t4.wav", WEAPON_SHOTGUN, ATTN_NONE);
						}
						else
						{
							if (s_choice == WEAPON_SPIKES)
							{
								sound(pent, CHAN_AUTO, "gamb/tmna_t5.wav", WEAPON_SHOTGUN, ATTN_NONE);
							}
							else
							{
								if (s_choice == AS_BLINDFIRE)
								{
									sound(pent, CHAN_AUTO, "gamb/tmna_t6.wav", WEAPON_SHOTGUN, ATTN_NONE);
								}
								else
								{
									sound(pent, CHAN_AUTO, "gamb/tmna_t7.wav", WEAPON_SHOTGUN, ATTN_NONE);
								}
							}
						}
					}
				}
			}
		}
		else
		{
			sound(pent, CHAN_AUTO, "gamb/fancy_t1.wav", WEAPON_SHOTGUN, ATTN_NONE);
			self.nextthink = time + 18 + WEAPON_SPIKES * random();
		}
	}
};

void() global_sound_one = 
{
	local entity ssrc;
	precache_sound("gamb/gd1.wav");
	precache_sound("gamb/gd2.wav");
	precache_sound("gamb/gd3.wav");
	precache_sound("gamb/gd4.wav");
	precache_sound("gamb/tmna_t1.wav");
	precache_sound("gamb/tmna_t2.wav");
	precache_sound("gamb/tmna_t3.wav");
	precache_sound("gamb/tmna_t4.wav");
	precache_sound("gamb/tmna_t5.wav");
	precache_sound("gamb/tmna_t6.wav");
	precache_sound("gamb/tmna_t7.wav");
	precache_sound("gamb/fancy_t1.wav");
	ssrc = spawn();
	ssrc.nextthink = time + 0.3 + 0.6 * random();
	ssrc.think = global_sound_one_use;
};

void() ambient_grinder = 
{
	precache_sound("ambience/grinder.wav");
	ambientsound(self.origin, "ambience/grinder.wav", WEAPON_SHOTGUN, WEAPON_SHOTGUN);
};

void() ambient_teeth = 
{
	precache_sound("ambience/teeth.wav");
	ambientsound(self.origin, "ambience/teeth.wav", WEAPON_SHOTGUN, WEAPON_SHOTGUN);
};

void() ambient_thrum = 
{
	precache_sound("ambience/thrum.wav");
	ambientsound(self.origin, "ambience/thrum.wav", WEAPON_SHOTGUN, WEAPON_SHOTGUN);
};

void() ambient_highwind = 
{
	precache_sound("ambience/highwind.wav");
	ambientsound(self.origin, "ambience/highwind.wav", WEAPON_SHOTGUN, 1.5);
};

void() ambient_lapping = 
{
	precache_sound("ambience/lapping.wav");
	ambientsound(self.origin, "ambience/lapping.wav", WEAPON_SHOTGUN, 1.5);
};

void() ambient_lapping2 = 
{
	precache_sound("ambience/lapping2.wav");
	ambientsound(self.origin, "ambience/lapping2.wav", WEAPON_SHOTGUN, 1.5);
};

void() ambient_water_drip = 
{
	precache_sound("ambience/wat_drip.wav");
	ambientsound(self.origin, "ambience/wat_drip.wav", WEAPON_SHOTGUN, 1.5);
};

void() ambient_water_fall = 
{
	precache_sound("ambience/wat_fall.wav");
	ambientsound(self.origin, "ambience/wat_fall.wav", WEAPON_SHOTGUN, 1.5);
};

void() ambient_stargate_hum = 
{
	precache_sound("ambience/bigrot.wav");
	ambientsound(self.origin, "ambience/bigrot.wav", WEAPON_SHOTGUN, 1.5);
};


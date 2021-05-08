void() global_sound_one_use =
{
	local	float	s_choice;
	local	entity	pent;

	
	pent = find (world, classname, "player");
	

	self.think = global_sound_one_use;

	
	if (random() < 0.5)
	{
		self.nextthink = time + 8 + (6 * random());
		s_choice = rint(random() * 3);	
	
		if (s_choice == 0)
			sound (pent, CHAN_AUTO, "gamb/gd1.wav", 1, ATTN_NONE);
		else if (s_choice == 1)
			sound (pent, CHAN_AUTO, "gamb/gd2.wav", 1, ATTN_NONE);
		else if (s_choice == 2)
			sound (pent, CHAN_AUTO, "gamb/gd3.wav", 1, ATTN_NONE);
		else
			sound (pent, CHAN_AUTO, "gamb/gd4.wav", 1, ATTN_NONE);
	}
	else if (random() < 0.95)
	{
		self.nextthink = time + 15 + (4 * random());
		s_choice = rint(random() * 6);	
	
		if (s_choice == 0)
			sound (pent, CHAN_AUTO, "gamb/tmna_t1.wav", 1, ATTN_NONE);
		else if (s_choice == 1)
			sound (pent, CHAN_AUTO, "gamb/tmna_t2.wav", 1, ATTN_NONE);
		else if (s_choice == 2)
			sound (pent, CHAN_AUTO, "gamb/tmna_t3.wav", 1, ATTN_NONE);
		else if (s_choice == 3)
			sound (pent, CHAN_AUTO, "gamb/tmna_t4.wav", 1, ATTN_NONE);
		else if (s_choice == 4)
			sound (pent, CHAN_AUTO, "gamb/tmna_t5.wav", 1, ATTN_NONE);
		else if (s_choice == 5)
			sound (pent, CHAN_AUTO, "gamb/tmna_t6.wav", 1, ATTN_NONE);
		else
			sound (pent, CHAN_AUTO, "gamb/tmna_t7.wav", 1, ATTN_NONE);

	}
	else
	{
		sound (pent, CHAN_AUTO, "gamb/fancy_t1.wav", 1, ATTN_NONE);
		self.nextthink = time + 18 + (4 * random());
	}

};

void() global_sound_one =
{
	precache_sound ("gamb/gd1.wav");
	precache_sound ("gamb/gd2.wav");
	precache_sound ("gamb/gd3.wav");
	precache_sound ("gamb/gd4.wav");
	precache_sound ("gamb/tmna_t1.wav");
	precache_sound ("gamb/tmna_t2.wav");
	precache_sound ("gamb/tmna_t3.wav");
	precache_sound ("gamb/tmna_t4.wav");
	precache_sound ("gamb/tmna_t5.wav");
	precache_sound ("gamb/tmna_t6.wav");
	precache_sound ("gamb/tmna_t7.wav");
	precache_sound ("gamb/fancy_t1.wav");

	local	entity	ssrc;
	
	ssrc = spawn();

	
	ssrc.nextthink = time + 0.3 + (0.6 * random());
	ssrc.think = global_sound_one_use;
};



// Normal looping ambient sounds

/*QUAKED ambient_grinder (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
*/
void() ambient_grinder =
{
	precache_sound ("ambience/grinder.wav");
	ambientsound (self.origin, "ambience/grinder.wav", 1, 1);
};

/*QUAKED ambient_teeth (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
*/
void() ambient_teeth =
{
	precache_sound ("ambience/teeth.wav");
	ambientsound (self.origin, "ambience/teeth.wav", 1, 1);
};

/*QUAKED ambient_thrum (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
*/
void() ambient_thrum =
{
	precache_sound ("ambience/thrum.wav");
	ambientsound (self.origin, "ambience/thrum.wav", 1, 1);
};

void () bar_stand1 = [ 18, bar_stand2 ] { ai_stand (); };
void () bar_stand2 = [ 19, bar_stand3 ] { ai_stand (); };
void () bar_stand3 = [ 20, bar_stand4 ] { ai_stand (); };
void () bar_stand4 = [ 21, bar_stand5 ] { ai_stand (); };
void () bar_stand5 = [ 22, bar_stand6 ] { ai_stand (); };
void () bar_stand6 = [ 23, bar_stand7 ] { ai_stand (); };
void () bar_stand7 = [ 24, bar_stand8 ] { ai_stand (); };
void () bar_stand8 = [ 25, bar_stand9 ] { ai_stand (); };
void () bar_stand9 = [ 26, bar_stand10 ] { ai_stand (); };
void () bar_stand10 = [ 27, bar_stand11 ] { ai_stand (); };
void () bar_stand11 = [ 28, bar_stand12 ] { ai_stand (); };
void () bar_stand12 = [ 29, bar_stand13 ] { ai_stand (); };
void () bar_stand13 = [ 30, bar_stand14 ] { ai_stand (); };
void () bar_stand14 = [ 31, bar_stand15 ] { ai_stand (); };
void () bar_stand15 = [ 32, bar_stand16 ] { ai_stand (); };
void () bar_stand16 = [ 33, bar_stand17 ] { ai_stand (); };
void () bar_stand17 = [ 34, bar_stand18 ] { ai_stand (); };
void () bar_stand18 = [ 35, bar_stand1 ] { ai_stand (); };

void () bar_walk1 = [ 18, bar_walk2 ] { ai_walk (8); };
void () bar_walk2 = [ 19, bar_walk3 ] { ai_walk (8); };
void () bar_walk3 = [ 20, bar_walk4 ] { ai_walk (8); };
void () bar_walk4 = [ 21, bar_walk5 ] { ai_walk (8); };
void () bar_walk5 = [ 22, bar_walk6 ] { ai_walk (8); };
void () bar_walk6 = [ 23, bar_walk7 ] { ai_walk (8); };
void () bar_walk7 = [ 24, bar_walk8 ] { ai_walk (8); };
void () bar_walk8 = [ 25, bar_walk9 ] { ai_walk (8); };
void () bar_walk9 = [ 26, bar_walk10 ] { ai_walk (8); };
void () bar_walk10 = [ 27, bar_walk11 ] { ai_walk (8); };
void () bar_walk11 = [ 28, bar_walk12 ] { ai_walk (8); };
void () bar_walk12 = [ 29, bar_walk13 ] { ai_walk (8); };
void () bar_walk13 = [ 30, bar_walk14 ] { ai_walk (8); };
void () bar_walk14 = [ 31, bar_walk15 ] { ai_walk (8); };
void () bar_walk15 = [ 32, bar_walk16 ] { ai_walk (8); };
void () bar_walk16 = [ 33, bar_walk17 ] { ai_walk (8); };
void () bar_walk17 = [ 34, bar_walk18 ] { ai_walk (8); };
void () bar_walk18 = [ 35, bar_walk1 ] { ai_walk (8); };

void () bar_run1 = [ 18, bar_run2 ]
{
	ai_forward (20);
	ai_face ();
	if (random () < 0.50)
		sound (self, CHAN_VOICE, "blob/land1.wav", 1.00, ATTN_NORM);
};

void () bar_run2 = [ 19, bar_run3 ]
{
	ai_forward (20);
	ai_face ();
};

void () bar_run3 = [ 20, bar_run4 ]
{
	ai_forward (20);
	ai_face ();
};

void () bar_run4 = [ 21, bar_run5 ]
{
	ai_forward (20);
	ai_face ();
};

void () bar_run5 = [ 22, bar_run6 ]
{
	ai_run (20);
	ai_face ();
};

void () bar_run6 = [ 23, bar_run7 ]
{
	ai_forward (20);
	ai_face ();
};

void () bar_run7 = [ 24, bar_run8 ]
{
	ai_run (20);
	ai_face ();
};

void () bar_run8 = [ 25, bar_run9 ]
{
	ai_run (20);
	ai_face ();
};

void () bar_run9 = [ 26, bar_run10 ]
{
	ai_run (20);
	ai_face ();
};

void () bar_run10 = [ 27, bar_run11 ]
{
	ai_run (20);
	ai_face ();
	if (random () < 0.5)
		sound (self, CHAN_VOICE, "blob/land1.wav", 1.00, ATTN_NORM);
};

void () bar_run11 = [ 28, bar_run12 ]
{
	ai_run (20);
	ai_face ();
};

void () bar_run12 = [ 29, bar_run13 ]
{
	ai_run (20);
	ai_face ();
};

void () bar_run13 = [ 30, bar_run14 ]
{
	ai_run (20);
	ai_face ();
};

void () bar_run14 = [ 31, bar_run15 ]
{
	ai_run (20);
	ai_face ();
};

void () bar_run15 = [ 32, bar_run16 ]
{
	ai_run (20);
	ai_face ();
};

void () bar_run16 = [ 33, bar_run17 ]
{
	ai_run (20);
	ai_face ();
};

void () bar_run17 = [ 34, bar_run18 ]
{
	ai_run (20);
	ai_face ();
};

void () bar_run18 = [ 35, bar_run1 ]
{
	ai_run (20);
	ai_face ();
};


void () baracuda_melee =
	{
	local vector delta;
	local float ldmg;

	if (!self.enemy)
		return;

	delta = (self.enemy.origin + '0 0 20') - self.origin;
	sound (self, CHAN_WEAPON, "doors/airdoor2.wav", 1.00, ATTN_NORM);
	if (vlen (delta) > 80)
		return;
	sound (self, CHAN_VOICE, "shambler/smack.wav", 1.00, ATTN_NORM);
	ldmg = (random () + random ()) * 8;
	T_Damage (self.enemy, self, self, ldmg);
	};

void () bar_attack1 = [ 0, bar_attack2 ]
{
	ai_charge (20);
	sound (self, CHAN_VOICE, "hknight/idle.wav", 1.00, ATTN_NORM);
	sound (self, CHAN_WEAPON, "zombie/z_shot1.wav", 1.00, ATTN_NORM);
};

void () bar_attack2 = [ 1, bar_attack3 ]
{
	ai_charge (20);
};

void () bar_attack3 = [ 2, bar_attack4 ]
{
	ai_charge (20);
};

void () bar_attack4 = [ 3, bar_attack5 ]
{
	ai_charge (20);
};

void () bar_attack5 = [ 4, bar_attack6 ]
{
	baracuda_melee ();
};

void () bar_attack6 = [ 5, bar_attack7 ]
{
	ai_charge (20);
};

void () bar_attack7 = [ 6, bar_attack8 ]
{
	ai_charge (20);
};

void () bar_attack8 = [ 7, bar_attack9 ]
{
	ai_charge (20);
};

void () bar_attack9 = [ 8, bar_attack10 ]
{
	ai_charge (20);
};

void () bar_attack10 = [ 9, bar_attack11 ]
{
	ai_charge (20);
	sound (self, CHAN_VOICE, "hknight/idle.wav", 1.00, ATTN_NORM);
	sound (self, CHAN_WEAPON, "zombie/z_shot1.wav", 1.00, ATTN_NORM);
};

void () bar_attack11 = [ 10, bar_attack12 ]
{
	ai_charge (20);
};

void () bar_attack12 = [ 11, bar_attack13 ]
{
	ai_charge (20);
};

void () bar_attack13 = [ 12, bar_attack14 ]
{
	baracuda_melee ();
};

void () bar_attack14 = [ 13, bar_attack15 ]
{
	ai_charge (20);
};

void () bar_attack15 = [ 14, bar_attack16 ]
{
	ai_charge (20);
};

void () bar_attack16 = [ 15, bar_attack17 ]
{
	ai_charge (20);
};

void () bar_attack17 = [ 16, bar_attack18 ]
{
	ai_charge (20);
};

void () bar_attack18 = [ 17, bar_run1 ]
{
	ai_charge (20);
};

void () bar_death1 = [ 36, bar_death2 ] { sound (self, CHAN_VOICE, "fish/death.wav", 1.00, ATTN_NORM); };
void () bar_death2 = [ 37, bar_death3 ] { };
void () bar_death3 = [ 38, bar_death4 ] { };
void () bar_death4 = [ 39, bar_death5 ] { };
void () bar_death5 = [ 40, bar_death6 ] { };
void () bar_death6 = [ 41, bar_death7 ] { };
void () bar_death7 = [ 42, bar_death8 ] { };
void () bar_death8 = [ 43, bar_death9 ] { };
void () bar_death9 = [ 44, bar_death10 ] { };
void () bar_death10 = [ 45, bar_death11 ] { };
void () bar_death11 = [ 46, bar_death12 ] { };
void () bar_death12 = [ 47, bar_death13 ] { };
void () bar_death13 = [ 48, bar_death14 ] { };
void () bar_death14 = [ 49, bar_death15 ] { };
void () bar_death15 = [ 50, bar_death16 ] { };
void () bar_death16 = [ 51, bar_death17 ] { };
void () bar_death17 = [ 52, bar_death18 ] { };
void () bar_death18 = [ 53, bar_death19 ] { };
void () bar_death19 = [ 54, bar_death19 ] { self.solid = SOLID_NOT; };

void () bar_pain1 = [ 13, bar_pain2 ] { };
void () bar_pain2 = [ 14, bar_pain3 ] { ai_pain (6); };
void () bar_pain3 = [ 15, bar_pain4 ] { ai_pain (6); };
void () bar_pain4 = [ 16, bar_pain5 ] { ai_pain (6); };
void () bar_pain5 = [ 17, bar_run1 ] { ai_pain (6); };

void (entity attacker,float damage) baracuda_pain =
	{
	if (self.pain_finished > time)
		return;
	self.pain_finished = time + 3.00;
	sound (self, CHAN_VOICE, "blob/sight1.wav", 1.00, ATTN_NORM);
	bar_pain1 ();
	};


void () monster_bara =
	{
	if (!deathmatch)
		{
		precache_model ("progs/baracuda.mdl");
		precache_sound ("fish/death.wav");
		precache_sound ("fish/bite.wav");
		precache_sound ("fish/idle.wav");
		precache_sound ("hknight/idle.wav");
		precache_sound ("doors/airdoor2.wav");
		precache_sound ("zombie/z_shot1.wav");
		precache_sound ("shambler/smack.wav");
		precache_sound ("blob/land1.wav");
		precache_sound ("blob/sight1.wav");
		self.solid = SOLID_SLIDEBOX;
		self.movetype = MOVETYPE_STEP;
		setmodel (self, "progs/baracuda.mdl");
		setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
		self.health = 60;
		dealwithskill ();
		self.th_stand = bar_stand1;
		self.th_walk = bar_walk1;
		self.th_run = bar_run1;
		self.th_die = bar_death1;
		self.th_pain = baracuda_pain;
		self.th_melee = bar_attack1;
		swimmonster_start ();
		}
	else
		remove (self);
	};


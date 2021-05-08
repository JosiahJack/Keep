
void () CheckIdleSnd =
{
	if ((random () < 0.2))
	{
		if ((random () < 0.5))
			sound (self, CHAN_WEAPON, "hunter/idle1.wav", 1.00, ATTN_NORM);
		else
			sound (self, CHAN_WEAPON, "hunter/led.wav", 1.00, ATTN_NORM);
	}
};

void () hunt_stand1 = [ 71, hunt_stand2 ]
{
	ai_stand ();
	CheckIdleSnd ();
};

void () hunt_stand2 = [ 72, hunt_stand3 ]
{
	ai_stand ();
};

void () hunt_stand3 = [ 73, hunt_stand4 ]
{
	ai_stand ();
};

void () hunt_stand4 = [ 74, hunt_stand5 ]
{
	ai_stand ();
};

void () hunt_stand5 = [ 75, hunt_stand6 ]
{
	ai_stand ();
};

void () hunt_stand6 = [ 76, hunt_stand7 ]
{
	ai_stand ();
};

void () hunt_stand7 = [ 77, hunt_stand8 ]
{
	ai_stand ();
};

void () hunt_stand8 = [ 78, hunt_stand9 ]
{
	ai_stand ();
};

void () hunt_stand9 = [ 79, hunt_stand10 ]
{
	ai_stand ();
};

void () hunt_stand10 = [ 80, hunt_stand11 ]
{
	ai_stand ();
};

void () hunt_stand11 = [ 81, hunt_stand12 ]
{
	ai_stand ();
};

void () hunt_stand12 = [ 82, hunt_stand13 ]
{
	ai_stand ();
};

void () hunt_stand13 = [ 83, hunt_stand14 ]
{
	ai_stand ();
};

void () hunt_stand14 = [ 84, hunt_stand15 ]
{
	ai_stand ();
};

void () hunt_stand15 = [ 85, hunt_stand16 ]
{
	ai_stand ();
};

void () hunt_stand16 = [ 86, hunt_stand17 ]
{
	ai_stand ();
};

void () hunt_stand17 = [ 87, hunt_stand18 ]
{
	ai_stand ();
};

void () hunt_stand18 = [ 88, hunt_stand19 ]
{
	ai_stand ();
};

void () hunt_stand19 = [ 89, hunt_stand1 ]
{
	ai_stand ();
};

void () hunt_walk1 = [ 0, hunt_walk2 ]
{
	ai_walk (0);
	CheckIdleSnd ();
};

void () hunt_walk2 = [ 1, hunt_walk3 ]
{
	ai_walk (3);
};

void () hunt_walk3 = [ 2, hunt_walk4 ]
{
	ai_walk (4);
};

void () hunt_walk4 = [ 3, hunt_walk5 ]
{
	ai_walk (5);
};

void () hunt_walk5 = [ 4, hunt_walk6 ]
{
	ai_walk (6);
};

void () hunt_walk6 = [ 5, hunt_walk7 ]
{
	ai_walk (5);
};

void () hunt_walk7 = [ 6, hunt_walk8 ]
{
	ai_walk (4);
};

void () hunt_walk8 = [ 7, hunt_walk9 ]
{
	ai_walk (3);
};

void () hunt_walk9 = [ 8, hunt_walk10 ]
{
	ai_walk (2);
};

void () hunt_walk10 = [ 9, hunt_walk11 ]
{
	ai_walk (0);
};

void () hunt_walk11 = [ 10, hunt_walk12 ]
{
	ai_walk (2);
};

void () hunt_walk12 = [ 11, hunt_walk13 ]
{
	ai_walk (4);
};

void () hunt_walk13 = [ 12, hunt_walk14 ]
{
	ai_walk (5);
};

void () hunt_walk14 = [ 13, hunt_walk15 ]
{
	ai_walk (6);
};

void () hunt_walk15 = [ 14, hunt_walk16 ]
{
	ai_walk (5);
};

void () hunt_walk16 = [ 15, hunt_walk17 ]
{
	ai_walk (4);
};

void () hunt_walk17 = [ 16, hunt_walk18 ]
{
	ai_walk (3);
};

void () hunt_walk18 = [ 17, hunt_walk19 ]
{
	ai_walk (2);
};

void () hunt_walk19 = [ 18, hunt_walk1 ]
{
	ai_walk (1);
};

void () hunt_run1 = [ 0, hunt_run2 ]
{
	ai_run (5);
};

void () hunt_run2 = [ 1, hunt_run3 ]
{
	ai_run (3);
};

void () hunt_run3 = [ 2, hunt_run4 ]
{
	ai_run (4);
};

void () hunt_run4 = [ 3, hunt_run5 ]
{
	ai_run (5);
};

void () hunt_run5 = [ 4, hunt_run6 ]
{
	ai_run (6);
};

void () hunt_run6 = [ 5, hunt_run7 ]
{
	ai_run (5);
	sound (self, CHAN_WEAPON, "hunter/stomp.wav", 1.00, ATTN_NORM);
};

void () hunt_run7 = [ 6, hunt_run8 ]
{
	ai_run (4);
};

void () hunt_run8 = [ 7, hunt_run9 ]
{
	ai_run (3);
};

void () hunt_run9 = [ 8, hunt_run10 ]
{
	ai_run (3);
};

void () hunt_run10 = [ 9, hunt_run11 ]
{
	ai_run (5);
};

void () hunt_run11 = [ 10, hunt_run12 ]
{
	ai_run (3);
};

void () hunt_run12 = [ 11, hunt_run13 ]
{
	ai_run (4);
};

void () hunt_run13 = [ 12, hunt_run14 ]
{
	ai_run (5);
};

void () hunt_run14 = [ 13, hunt_run15 ]
{
	ai_run (6);
};

void () hunt_run15 = [ 14, hunt_run16 ]
{
	ai_run (5);
};

void () hunt_run16 = [ 15, hunt_run17 ]
{
	ai_run (4);
	sound (self, CHAN_WEAPON, "hunter/stomp.wav", 1.00, ATTN_NORM);
};

void () hunt_run17 = [ 16, hunt_run18 ]
{
	ai_run (3);
};

void () hunt_run18 = [ 17, hunt_run19 ]
{
	ai_run (3);
};

void () hunt_run19 = [ 18, hunt_run1 ]
{
	ai_run (5);
};


void () CheckLeash =
{
	local float delta;
	local vector ideal;

	ideal = vectoangles ((self.enemy.origin - self.origin));
	delta = fabs ((ideal_y - self.angles_y));
	if ((delta > 60))
	{
		ai_face ();
		hunt_run1 ();
	}
};


void () Unleash =
{
	local float delta;
	local vector ideal;
	local vector dir;
	local float gamma;

	ideal = vectoangles ((self.enemy.origin - self.origin));
	delta = fabs ((ideal_y - self.angles_y));
	if ((delta > 60))
	{
		ai_face ();
		hunt_run1 ();
		return;
	}
	gamma = ((50 * self.warp_factor) - 200);
	self.warp_factor = (self.warp_factor + 1);
	makevectors (self.angles);
	dir = normalize (((self.old_position + (v_right * gamma)) - self.origin));
	self.effects = (self.effects | EF_MUZZLEFLASH);
	FireBullets (20, dir, '0.1 0.1 0');
	sound (self, CHAN_WEAPON, "hunter/basegun.wav", 1.00, ATTN_NORM);
	BlowShell ();
};

void () hunt_fire1 = [ 19, hunt_fire2 ]
{
	CheckLeash ();
	ai_walk (4);
};

void () hunt_fire2 = [ 20, hunt_fire3 ]
{
	ai_walk (3);
};

void () hunt_fire3 = [ 21, hunt_fire4 ]
{
	ai_walk (2);
};

void () hunt_fire4 = [ 22, hunt_fire5 ]
{
	ai_walk (1);
};

void () hunt_fire5 = [ 23, hunt_fire6 ]
{
};

void () hunt_fire6 = [ 24, hunt_fire7 ]
{
};

void () hunt_fire7 = [ 25, hunt_fire8 ]
{
};

void () hunt_fire8 = [ 26, hunt_fire9 ]
{
};

void () hunt_fire9 = [ 27, hunt_fire10 ]
{
};

void () hunt_fire10 = [ 28, hunt_fire11 ]
{
	self.warp_factor = 0;
	self.old_position = self.enemy.origin;
	Unleash ();
};

void () hunt_fire11 = [ 29, hunt_fire12 ]
{
};

void () hunt_fire12 = [ 30, hunt_fire13 ]
{
	Unleash ();
};

void () hunt_fire13 = [ 31, hunt_fire14 ]
{
};

void () hunt_fire14 = [ 32, hunt_fire15 ]
{
	Unleash ();
};

void () hunt_fire15 = [ 33, hunt_fire16 ]
{
};

void () hunt_fire16 = [ 34, hunt_fire17 ]
{
	Unleash ();
};

void () hunt_fire17 = [ 35, hunt_fire18 ]
{
};

void () hunt_fire18 = [ 36, hunt_fire19 ]
{
	Unleash ();
};

void () hunt_fire19 = [ 37, hunt_fire20 ]
{
};

void () hunt_fire20 = [ 38, hunt_fire21 ]
{
	Unleash ();
};

void () hunt_fire21 = [ 39, hunt_fire22 ]
{
};

void () hunt_fire22 = [ 40, hunt_fire23 ]
{
	Unleash ();
};

void () hunt_fire23 = [ 41, hunt_fire24 ]
{
};

void () hunt_fire24 = [ 42, hunt_fire25 ]
{
	Unleash ();
};

void () hunt_fire25 = [ 43, hunt_fire26 ]
{
};

void () hunt_fire26 = [ 44, hunt_fire27 ]
{
	Unleash ();
};

void () hunt_fire27 = [ 45, hunt_fire28 ]
{
};

void () hunt_fire28 = [ 46, hunt_fire29 ]
{
};

void () hunt_fire29 = [ 47, hunt_fire30 ]
{
};

void () hunt_fire30 = [ 48, hunt_run6 ]
{
};


void () search_mon =
{
	if ((random () < 0.2))
		hunt_fire1 ();
};

void () hunt_smash1 = [ 49, hunt_smash2 ]
{
	ai_walk (4);
};

void () hunt_smash2 = [ 50, hunt_smash3 ]
{
	ai_walk (3);
};

void () hunt_smash3 = [ 51, hunt_smash4 ]
{
	ai_walk (2);
};

void () hunt_smash4 = [ 52, hunt_smash5 ]
{
	ai_walk (1);
};

void () hunt_smash5 = [ 53, hunt_smash6 ]
{
};

void () hunt_smash6 = [ 54, hunt_smash7 ]
{
};

void () hunt_smash7 = [ 55, hunt_smash8 ]
{
	T_RadiusDamage (self, self, 150, self);
	FuelTankExplode ();
};

void () hunt_smash8 = [ 56, hunt_smash9 ]
{
};

void () hunt_smash9 = [ 57, hunt_smash10 ]
{
};

void () hunt_smash10 = [ 58, hunt_run6 ]
{
};

void () hunt_death1 = [ 59, hunt_death2 ]
{
	sound (self, CHAN_WEAPON, "hunter/death.wav", 1.00, ATTN_NORM);
};

void () hunt_death2 = [ 60, hunt_death3 ]
{
};

void () hunt_death3 = [ 61, hunt_death4 ]
{
	self.solid = SOLID_NOT;
};

void () hunt_death4 = [ 62, hunt_death5 ]
{
};

void () hunt_death5 = [ 63, hunt_death6 ]
{
};

void () hunt_death6 = [ 64, hunt_death7 ]
{
};

void () hunt_death7 = [ 65, hunt_death8 ]
{
};

void () hunt_death8 = [ 66, hunt_death9 ]
{
};

void () hunt_death9 = [ 67, hunt_death10 ]
{
};

void () hunt_death10 = [ 68, hunt_death11 ]
{
};

void () hunt_death11 = [ 69, hunt_death12 ]
{
};

void () hunt_death12 = [ 70, hunt_death12 ]
{
};


void () hunt_pain =
{
	if ((random () < 0.5))
		sound (self, CHAN_WEAPON, "hunter/pain1.wav", 1.00, ATTN_NORM);
	else
		sound (self, CHAN_WEAPON, "hunter/pain2.wav", 1.00, ATTN_NORM);
};


void () monster_hunter =
{
	if (deathmatch)
		remove (self);
	precache_model ("progs/hunter.mdl");
	precache_model ("progs/h_shams.mdl");
	precache_sound ("hunter/stomp.wav");
	precache_sound ("hunter/basegun.wav");
	precache_sound ("hunter/idle1.wav");
	precache_sound ("hunter/led.wav");
	precache_sound ("hunter/pain1.wav");
	precache_sound ("hunter/pain2.wav");
	precache_sound ("hunter/sight1.wav");
	precache_sound ("hunter/sight2.wav");
	precache_sound ("hunter/death.wav");
	precache_sound ("weapons/fuelexp.wav");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel (self, "progs/hunter.mdl");
	setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
	self.health = 3000;
	dealwithskill ();
	self.th_stand = hunt_stand1;
	self.th_walk = hunt_walk1;
	self.th_run = hunt_run1;
	self.th_die = hunt_death1;
	self.th_pain = hunt_pain;
	self.th_melee = hunt_smash1;
	self.th_missile = search_mon;
	walkmonster_start ();
};


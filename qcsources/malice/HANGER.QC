void () hang_fire01;
void () hang_fire07;
void () hang_stand = [ 0, hang_stand1 ]
{
	ai_stand ();
};

void () hang_stand1 = [ 1, hang_stand2 ]
{
	ai_stand ();
};

void () hang_stand2 = [ 2, hang_stand3 ]
{
	ai_stand ();
};

void () hang_stand3 = [ 3, hang_stand4 ]
{
	ai_stand ();
};

void () hang_stand4 = [ 4, hang_stand5 ]
{
	ai_stand ();
};

void () hang_stand5 = [ 5, hang_stand6 ]
{
	ai_stand ();
};

void () hang_stand6 = [ 6, hang_stand ]
{
	ai_stand ();
};

void () hang_run = [ 0, hang_run1 ]
{
	ai_run (0);
	ai_face ();
};

void () hang_run1 = [ 1, hang_run2 ]
{
	ai_run (0);
	ai_face ();
};

void () hang_run2 = [ 2, hang_run3 ]
{
	ai_run (0);
	ai_face ();
};

void () hang_run3 = [ 3, hang_run4 ]
{
	ai_run (0);
	ai_face ();
};

void () hang_run4 = [ 4, hang_run5 ]
{
	ai_run (0);
	ai_face ();
};

void () hang_run5 = [ 5, hang_run6 ]
{
	ai_run (0);
	ai_face ();
};

void () hang_run6 = [ 6, hang_run ]
{
	ai_run (0);
	ai_face ();
};

void () hang_pain01 = [ 7, hang_pain02 ]
{
};

void () hang_pain02 = [ 8, hang_pain03 ]
{
};

void () hang_pain03 = [ 9, hang_pain04 ]
{
};

void () hang_pain04 = [ 10, hang_pain05 ]
{
};

void () hang_pain05 = [ 11, hang_pain06 ]
{
};

void () hang_pain06 = [ 12, hang_pain07 ]
{
};

void () hang_pain07 = [ 13, hang_run ]
{
};

void () hang_die01 = [ 14, hang_die02 ]
{
	if ((random () < 0.33))
		sound (self, CHAN_VOICE, "swat/death1.wav", 1.00, ATTN_NORM);
	else
	{
		if ((random () < 0.66))
			sound (self, CHAN_VOICE, "swat/death2.wav", 1.00, ATTN_NORM);
		else
			sound (self, CHAN_VOICE, "swat/death3.wav", 1.00, ATTN_NORM);
	}
};

void () hang_die02 = [ 15, hang_die03 ]
{
	self.solid = SOLID_NOT;
};

void () hang_die03 = [ 16, hang_die04 ]
{
};

void () hang_die04 = [ 17, hang_die05 ]
{
};

void () hang_die05 = [ 18, hang_die06 ]
{
	self.ammo_nails2 = 10;
	DropBackpack ();
};

void () hang_die06 = [ 19, hang_die06 ]
{
};


void () hang_gib =
{
	sound (self, CHAN_VOICE, "player/udeath.wav", 1.00, ATTN_NORM);
	ThrowHead ("progs/h_swat.mdl", self.health);
	ThrowGib ("progs/gib1.mdl", self.health);
	ThrowGib ("progs/gib2.mdl", self.health);
	ThrowGib ("progs/gib3.mdl", self.health);
	return;
};


void () hang_die =
{
	if ((self.health < -20))
		wallsplat ();
	if ((self.health < -45))
		hang_gib ();
	else
		hang_die01 ();
};


void (entity attacker,float damage) hang_pain =
{
	local float n;

	n = random ();
	if ((self.pain_finished > time))
		return;
	self.pain_finished = (time + 3.00);
	if ((random () < 0.33))
		sound (self, CHAN_VOICE, "swat/pain1.wav", 1.00, ATTN_NORM);
	else
	{
		if ((random () < 0.66))
			sound (self, CHAN_VOICE, "swat/pain2.wav", 1.00, ATTN_NORM);
		else
			sound (self, CHAN_VOICE, "swat/pain3.wav", 1.00, ATTN_NORM);
	}
	hang_pain01 ();
};


void () hang_fire =
{
	if ((random () > SERV_VOL))
		hang_fire01 ();
	else
		hang_fire07 ();
};

void () hang_fire01 = [ 20, hang_fire02 ]
{
	ai_face ();
	SwatMissile (0);
};

void () hang_fire02 = [ 21, hang_fire03 ]
{
	ai_face ();
	sound (self, CHAN_WEAPON, "swat/uzim.wav", 1.00, ATTN_NORM);
};

void () hang_fire03 = [ 20, hang_fire04 ]
{
	ai_face ();
	SwatMissile (0);
};

void () hang_fire04 = [ 21, hang_fire05 ]
{
	ai_face ();
	sound (self, CHAN_WEAPON, "swat/uzim.wav", 1.00, ATTN_NORM);
};

void () hang_fire05 = [ 20, hang_fire06 ]
{
	ai_face ();
	SwatMissile (0);
};

void () hang_fire06 = [ 21, hang_run ]
{
	ai_face ();
	sound (self, CHAN_WEAPON, "swat/uzim.wav", 1.00, ATTN_NORM);
};

void () hang_fire07 = [ 20, hang_fire08 ]
{
	ai_face ();
	SwatMissile (0);
};

void () hang_fire08 = [ 21, hang_fire09 ]
{
	ai_face ();
	sound (self, CHAN_WEAPON, "swat/uzim.wav", 1.00, ATTN_NORM);
};

void () hang_fire09 = [ 20, hang_fire10 ]
{
	ai_face ();
	SwatMissile (0);
};

void () hang_fire10 = [ 21, hang_run ]
{
	ai_face ();
	sound (self, CHAN_WEAPON, "swat/uzim.wav", 1.00, ATTN_NORM);
};

void () stretch_papa;
void () stretch_mama;
void () stretch_baby;
void () WeaveNewNewHemp;

void () WeaveNewHemp =
{
	local entity flax;

	flax = spawn ();
	flax.owner = self;
	flax.movetype = MOVETYPE_NONE;
	setmodel (flax, "progs/rope.mdl");
	setorigin (flax, (self.origin - '0 0 110'));
	flax.solid = SOLID_NOT;
	setsize (flax, VEC_ORIGIN, VEC_ORIGIN);
	flax.nextthink = (time + 0.1);
	flax.think = stretch_mama;
};


void () WeaveNewNewHemp =
{
	local entity flax;

	flax = spawn ();
	flax.owner = self;
	flax.movetype = MOVETYPE_NONE;
	setmodel (flax, "progs/rope.mdl");
	setorigin (flax, (self.origin - '0 0 110'));
	flax.solid = SOLID_NOT;
	setsize (flax, VEC_ORIGIN, VEC_ORIGIN);
	flax.nextthink = (time + 0.1);
	flax.think = stretch_papa;
};


void () stretch_papa =
{
	local float dist;

	if ((self.owner.owner.owner.health <= 0))
		return;
	dist = vlen ((self.owner.owner.owner.origin - self.origin));
	self.nextthink = (time + SERV_VOL);
	self.think = stretch_papa;
	if ((dist > 130))
	{
		self.frame = 6;
		self.think = SUB_Null;
	}
	else
	{
		if ((dist > 110))
			self.frame = 5;
		else
		{
			if ((dist > 90))
				self.frame = 4;
			else
			{
				if ((dist > 70))
					self.frame = 3;
				else
				{
					if ((dist > 50))
						self.frame = 2;
					else
						self.frame = 1;
				}
			}
		}
	}
};


void () stretch_mama =
{
	local float dist;

	if ((self.owner.owner.health <= 0))
		return;
	dist = vlen ((self.owner.owner.origin - self.origin));
	self.nextthink = (time + SERV_VOL);
	self.think = stretch_mama;
	if ((dist > 130))
	{
		self.frame = 6;
		self.think = SUB_Null;
		WeaveNewNewHemp ();
	}
	else
	{
		if ((dist > 110))
			self.frame = 5;
		else
		{
			if ((dist > 90))
				self.frame = 4;
			else
			{
				if ((dist > 70))
					self.frame = 3;
				else
				{
					if ((dist > 50))
						self.frame = 2;
					else
						self.frame = 1;
				}
			}
		}
	}
};


void () stretch_baby =
{
	local float dist;

	if ((self.owner.health <= 0))
		return;
	dist = vlen ((self.owner.origin - self.origin));
	self.nextthink = (time + SERV_VOL);
	self.think = stretch_baby;
	if ((dist > 130))
	{
		self.frame = 6;
		self.think = SUB_Null;
		WeaveNewHemp ();
	}
	else
	{
		if ((dist > 110))
			self.frame = 5;
		else
		{
			if ((dist > 90))
				self.frame = 4;
			else
			{
				if ((dist > 70))
					self.frame = 3;
				else
				{
					if ((dist > 50))
						self.frame = 2;
					else
						self.frame = 1;
				}
			}
		}
	}
};


void () WeaveHemp =
{
	local entity flax;

	flax = spawn ();
	flax.owner = self;
	flax.movetype = MOVETYPE_NONE;
	setmodel (flax, "progs/rope.mdl");
	setorigin (flax, self.origin);
	flax.solid = SOLID_NOT;
	setsize (flax, VEC_ORIGIN, VEC_ORIGIN);
	flax.nextthink = (time + 0.1);
	flax.think = stretch_baby;
};


void () monster_hanger =
{
	if (!deathmatch)
	{
		precache_sound ("swat/pain1.wav");
		precache_sound ("swat/pain2.wav");
		precache_sound ("swat/pain3.wav");
		precache_sound ("swat/death3.wav");
		precache_sound ("swat/death2.wav");
		precache_sound ("swat/death1.wav");
		precache_sound ("swat/sight1.wav");
		precache_sound ("swat/sight2.wav");
		precache_sound ("swat/uzim.wav");
		precache_model ("progs/hanger.mdl");
		precache_model ("progs/h_swat.mdl");
		precache_model ("progs/bshell1.mdl");
		precache_model ("progs/rope.mdl");
		self.solid = SOLID_SLIDEBOX;
		self.movetype = MOVETYPE_STEP;
		setmodel (self, "progs/hanger.mdl");
		setsize (self, VEC_HULL_MIN, '16 16 40');
		self.health = 80;
		dealwithskill ();
		self.th_stand = hang_stand;
		self.th_walk = hang_stand;
		self.th_run = hang_run;
		self.th_die = hang_die;
		self.th_pain = hang_pain;
		self.th_missile = hang_fire;
		self.th_melee = hang_fire;
		flymonster_start ();
		WeaveHemp ();
	}
	else
		remove (self);
};


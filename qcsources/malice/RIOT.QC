void () Riot_JumpTouch;

void () IdleComment =
{
	local float x;

	x = random ();
	if ((random () < 0.1))
	{
		if ((x < SERV_VOL))
			sound (self, CHAN_VOICE, "riot/idle1.wav", 1.00, ATTN_IDLE);
		else
			sound (self, CHAN_VOICE, "riot/idle2.wav", 1.00, ATTN_IDLE);
	}
};

void () riot_stand1 = [ 45, riot_stand2 ]
{
	ai_stand ();
	IdleComment ();
};

void () riot_stand2 = [ 46, riot_stand3 ]
{
	ai_stand ();
};

void () riot_stand3 = [ 47, riot_stand4 ]
{
	ai_stand ();
};

void () riot_stand4 = [ 48, riot_stand5 ]
{
	ai_stand ();
};

void () riot_stand5 = [ 49, riot_stand6 ]
{
	ai_stand ();
};

void () riot_stand6 = [ 50, riot_stand7 ]
{
	ai_stand ();
};

void () riot_stand7 = [ 51, riot_stand8 ]
{
	ai_stand ();
};

void () riot_stand8 = [ 52, riot_stand1 ]
{
	ai_stand ();
};

void () riot_jump1 = [ 24, riot_jump2 ]
{
	ai_forward (20);
};

void () riot_jump2 = [ 25, riot_jump3 ]
{
	ai_forward (20);
};

void () riot_jump3 = [ 26, riot_jump4 ]
{
	ai_forward (20);
	ai_face ();
};

void () riot_jump4 = [ 27, riot_jump5 ]
{
	ai_forward (20);
	ai_face ();
};

void () riot_jump5 = [ 28, riot_jump6 ]
{
	ai_face ();
	self.touch = Riot_JumpTouch;
	makevectors (self.angles);
	self.origin_z = (self.origin_z + 1);
	self.velocity = ((v_forward * 400) + '0 0 200');
	if ((self.flags & FL_ONGROUND))
		self.flags = (self.flags - FL_ONGROUND);
	sound (self, CHAN_VOICE, "riot/attack.wav", 1.00, ATTN_IDLE);
};

void () riot_jump6 = [ 29, riot_jump7 ]
{
};

void () riot_jump7 = [ 30, riot_jump6 ]
{
};

void () riot_jump8 = [ 31, riot_jump9 ]
{
};

void () riot_jump9 = [ 32, riot_jump10 ]
{
};

void () riot_jump10 = [ 33, riot_jump11 ]
{
};

void () riot_jump11 = [ 34, riot_jump12 ]
{
};

void () riot_jump12 = [ 35, riot_run1 ]
{
	ai_forward (6);
};

void () riot_run1;

void () Riot_JumpTouch =
{
	local float ldmg;

	if ((self.health <= 0))
		return;
	if (other.takedamage)
	{
		if ((vlen (self.velocity) > 300))
		{
			ldmg = (10 + (10 * random ()));
			T_Damage (other, self, self, ldmg);
		}
	}
	if (!checkbottom (self))
	{
		if ((self.flags & FL_ONGROUND))
		{
			self.touch = SUB_Null;
			self.think = riot_jump1;
			self.nextthink = (time + 0.1);
		}
		return;
	}
	self.touch = SUB_Null;
	self.think = riot_jump8;
	self.nextthink = (time + 0.1);
};


void () Kung_Fu =
{
	local vector dist;
	local float d;

	if (((self.origin_z + self.mins_z) > ((self.enemy.origin_z + self.enemy.mins_z) + (0.75 * self.enemy.size_z))))
		riot_run1 ();
	if (((self.origin_z + self.maxs_z) < ((self.enemy.origin_z + self.enemy.mins_z) + (0.25 * self.enemy.size_z))))
		riot_run1 ();
	dist = (self.enemy.origin - self.origin);
	dist_z = 0;
	d = vlen (dist);
	if ((d < 80))
		riot_run1 ();
	else
	{
		if ((d > 200))
			riot_run1 ();
		else
			riot_jump1 ();
	}
};

void () riot_walk1 = [ 101, riot_walk2 ]
{
	if ((random () < 0.05))
		sound (self, CHAN_VOICE, "riot/grunt1.wav", 1.00, ATTN_IDLE);
	ai_walk (4);
};

void () riot_walk2 = [ 102, riot_walk3 ]
{
	ai_walk (4);
};

void () riot_walk3 = [ 103, riot_walk4 ]
{
	ai_walk (4);
};

void () riot_walk4 = [ 104, riot_walk5 ]
{
	ai_walk (4);
};

void () riot_walk5 = [ 105, riot_walk6 ]
{
	ai_walk (1);
};

void () riot_walk6 = [ 106, riot_walk8 ]
{
	ai_walk (2);
};

void () riot_walk8 = [ 108, riot_walk9 ]
{
	ai_walk (4);
};

void () riot_walk9 = [ 109, riot_walk10 ]
{
	ai_walk (4);
};

void () riot_walk10 = [ 110, riot_walk11 ]
{
	ai_walk (4);
};

void () riot_walk11 = [ 111, riot_walk12 ]
{
	ai_walk (4);
};

void () riot_walk12 = [ 112, riot_walk13 ]
{
	ai_walk (4);
};

void () riot_walk13 = [ 113, riot_walk14 ]
{
	ai_walk (4);
};

void () riot_walk14 = [ 114, riot_walk15 ]
{
	ai_walk (1);
};

void () riot_walk15 = [ 115, riot_walk17 ]
{
	ai_walk (2);
};

void () riot_walk17 = [ 117, riot_walk18 ]
{
	ai_walk (4);
};

void () riot_walk18 = [ 118, riot_walk1 ]
{
	ai_walk (4);
};

void () riot_run1 = [ 0, riot_run2 ]
{
	if ((random () < 0.05))
		sound (self, CHAN_VOICE, "riot/grunt1.wav", 1.00, ATTN_IDLE);
	ai_run (15);
};

void () riot_run2 = [ 1, riot_run3 ]
{
	ai_run (20);
};

void () riot_run3 = [ 2, riot_run4 ]
{
	ai_run (20);
};

void () riot_run4 = [ 3, riot_run5 ]
{
	ai_run (20);
};

void () riot_run5 = [ 4, riot_run6 ]
{
	ai_run (20);
};

void () riot_run6 = [ 5, riot_run7 ]
{
	ai_run (20);
};

void () riot_run7 = [ 6, riot_run8 ]
{
	ai_run (20);
};

void () riot_run8 = [ 7, riot_run1 ]
{
	ai_run (20);
};

void () riot_runatk1 = [ 16, riot_runatk2 ]
{
	ai_charge (20);
};

void () riot_runatk2 = [ 17, riot_runatk3 ]
{
	ai_charge (20);
};

void () riot_runatk3 = [ 18, riot_runatk4 ]
{
	ai_charge (20);
	sound (self, CHAN_WEAPON, "knight/sword2.wav", 1.00, ATTN_NORM);
};

void () riot_runatk4 = [ 19, riot_runatk5 ]
{
	ai_charge (20);
	ai_melee ();
};

void () riot_runatk5 = [ 20, riot_runatk6 ]
{
	ai_charge (20);
	ai_melee ();
};

void () riot_runatk6 = [ 21, riot_runatk7 ]
{
	ai_charge (20);
};

void () riot_runatk7 = [ 22, riot_runatk8 ]
{
	ai_charge (20);
};

void () riot_runatk8 = [ 23, riot_run1 ]
{
	ai_charge (20);
};

void () riot_atk1 = [ 8, riot_atk2 ]
{
	ai_charge (20);
};

void () riot_atk2 = [ 9, riot_atk3 ]
{
	ai_charge (20);
};

void () riot_atk3 = [ 10, riot_atk4 ]
{
	ai_charge (20);
};

void () riot_atk4 = [ 11, riot_atk5 ]
{
	ai_charge (20);
};

void () riot_atk5 = [ 12, riot_atk6 ]
{
	ai_charge (20);
};

void () riot_atk6 = [ 13, riot_atk7 ]
{
	ai_charge (20);
	ai_melee ();
	sound (self, CHAN_WEAPON, "knight/sword1.wav", 1.00, ATTN_NORM);
};

void () riot_atk7 = [ 14, riot_atk8 ]
{
	ai_charge (20);
	ai_melee ();
};

void () riot_atk8 = [ 15, riot_run1 ]
{
	ai_charge (20);
};

void () riot_tornado1 = [ 36, riot_tornado2 ]
{
	ai_charge (20);
};

void () riot_tornado2 = [ 37, riot_tornado3 ]
{
	ai_charge (20);
};

void () riot_tornado3 = [ 38, riot_tornado4 ]
{
	ai_charge (20);
};

void () riot_tornado4 = [ 39, riot_tornado5 ]
{
	ai_charge (20);
};

void () riot_tornado5 = [ 40, riot_tornado6 ]
{
	ai_charge (20);
};

void () riot_tornado6 = [ 41, riot_tornado7 ]
{
	ai_charge (20);
	ai_melee ();
	sound (self, CHAN_WEAPON, "knight/sword1.wav", 1.00, ATTN_NORM);
};

void () riot_tornado7 = [ 42, riot_tornado8 ]
{
	ai_charge (20);
	ai_melee ();
};

void () riot_tornado8 = [ 43, riot_tornado9 ]
{
	ai_charge (20);
};

void () riot_tornado9 = [ 44, riot_run1 ]
{
	ai_charge (20);
};


void () riot_bash =
{
	local float r;

	r = random ();
	if ((r < 0.4))
		riot_atk1 ();
	else
	{
		if ((r < 0.8))
			riot_runatk1 ();
		else
			riot_tornado1 ();
	}
};

void () riot_decap1 = [ 92, riot_decap2 ]
{
	ThrowGib ("progs/h_riot.mdl", -100);
};

void () riot_decap2 = [ 93, riot_decap3 ]
{
};

void () riot_decap3 = [ 94, riot_decap4 ]
{
	self.solid = SOLID_NOT;
};

void () riot_decap4 = [ 93, riot_decap5 ]
{
};

void () riot_decap5 = [ 92, riot_decap6 ]
{
};

void () riot_decap6 = [ 93, riot_decap7 ]
{
};

void () riot_decap7 = [ 94, riot_decap8 ]
{
};

void () riot_decap8 = [ 95, riot_decap9 ]
{
};

void () riot_decap9 = [ 96, riot_decap10 ]
{
};

void () riot_decap10 = [ 97, riot_decap11 ]
{
};

void () riot_decap11 = [ 98, riot_decap12 ]
{
};

void () riot_decap12 = [ 99, riot_decap13 ]
{
};

void () riot_decap13 = [ 100, riot_decap13 ]
{
};

void () riot_painb1 = [ 53, riot_painb2 ]
{
	ai_pain (2);
};

void () riot_painb2 = [ 54, riot_painb3 ]
{
};

void () riot_painb3 = [ 55, riot_painb4 ]
{
};

void () riot_painb4 = [ 56, riot_painb5 ]
{
};

void () riot_painb5 = [ 57, riot_painb6 ]
{
};

void () riot_painb6 = [ 58, riot_painb7 ]
{
};

void () riot_painb7 = [ 59, riot_painb8 ]
{
};

void () riot_painb8 = [ 60, riot_painb9 ]
{
	ai_run (15);
};

void () riot_painb9 = [ 61, riot_painb10 ]
{
	ai_run (15);
};

void () riot_painb10 = [ 62, riot_run1 ]
{
	ai_run (15);
};


void (entity attacker,float damage) riot_pain =
{
	local float x;

	blooddrops ();
	if ((self.pain_finished > time))
		return;
	x = random ();
	if ((x < 0.33))
		sound (self, CHAN_VOICE, "riot/pain1.wav", 1.00, ATTN_NORM);
	else
	{
		if ((x < 0.66))
			sound (self, CHAN_VOICE, "riot/pain2.wav", 1.00, ATTN_NORM);
		else
			sound (self, CHAN_VOICE, "riot/grunt2.wav", 1.00, ATTN_NORM);
	}
	riot_painb1 ();
	self.pain_finished = (time + 2.00);
};

void () riot_die1 = [ 63, riot_die2 ]
{
};

void () riot_die2 = [ 64, riot_die3 ]
{
};

void () riot_die3 = [ 65, riot_die4 ]
{
	self.solid = SOLID_NOT;
};

void () riot_die4 = [ 66, riot_die5 ]
{
};

void () riot_die5 = [ 67, riot_die6 ]
{
};

void () riot_die6 = [ 68, riot_die7 ]
{
};

void () riot_die7 = [ 69, riot_die8 ]
{
};

void () riot_die8 = [ 70, riot_die8 ]
{
};

void () riot_ded1 = [ 81, riot_ded2 ]
{
};

void () riot_ded2 = [ 82, riot_ded3 ]
{
};

void () riot_ded3 = [ 83, riot_ded4 ]
{
	self.solid = SOLID_NOT;
};

void () riot_ded4 = [ 84, riot_ded5 ]
{
};

void () riot_ded5 = [ 85, riot_ded6 ]
{
};

void () riot_ded6 = [ 86, riot_ded7 ]
{
};

void () riot_ded7 = [ 87, riot_ded7 ]
{
};

void () riot_dieb1 = [ 71, riot_dieb2 ]
{
};

void () riot_dieb2 = [ 72, riot_dieb3 ]
{
};

void () riot_dieb3 = [ 73, riot_dieb4 ]
{
	self.solid = SOLID_NOT;
};

void () riot_dieb4 = [ 74, riot_dieb5 ]
{
};

void () riot_dieb5 = [ 75, riot_dieb6 ]
{
};

void () riot_dieb6 = [ 76, riot_dieb7 ]
{
};

void () riot_dieb7 = [ 77, riot_dieb8 ]
{
};

void () riot_dieb8 = [ 78, riot_dieb9 ]
{
};

void () riot_dieb9 = [ 79, riot_dieb10 ]
{
};

void () riot_dieb10 = [ 80, riot_dieb10 ]
{
};

void () riot_diec1 = [ 119, riot_diec2 ]
{
	self.nextthink = (time + 0.05);
};

void () riot_diec2 = [ 120, riot_diec3 ]
{
	self.nextthink = (time + 0.05);
};

void () riot_diec3 = [ 121, riot_diec4 ]
{
	self.solid = SOLID_NOT;
	self.nextthink = (time + 0.05);
};

void () riot_diec4 = [ 122, riot_diec5 ]
{
	self.nextthink = (time + 0.05);
};

void () riot_diec5 = [ 123, riot_diec6 ]
{
	self.nextthink = (time + 0.05);
};

void () riot_diec6 = [ 124, riot_diec7 ]
{
	self.nextthink = (time + 0.05);
};

void () riot_diec7 = [ 125, riot_diec8 ]
{
	self.nextthink = (time + 0.05);
};

void () riot_diec8 = [ 126, riot_diec9 ]
{
	self.nextthink = (time + 0.05);
};

void () riot_diec9 = [ 127, riot_diec10 ]
{
	self.nextthink = (time + 0.05);
};

void () riot_diec10 = [ 128, riot_diec11 ]
{
	self.nextthink = (time + 0.05);
};

void () riot_diec11 = [ 129, riot_diec12 ]
{
	self.nextthink = (time + 0.05);
};

void () riot_diec12 = [ 130, riot_diec13 ]
{
	self.nextthink = (time + 0.05);
};

void () riot_diec13 = [ 131, riot_diec14 ]
{
	self.nextthink = (time + 0.05);
};

void () riot_diec14 = [ 132, riot_diec15 ]
{
	self.nextthink = (time + 0.05);
};

void () riot_diec15 = [ 133, riot_diec16 ]
{
	self.nextthink = (time + 0.05);
};

void () riot_diec16 = [ 134, riot_diec17 ]
{
	self.nextthink = (time + 0.05);
};

void () riot_diec17 = [ 135, riot_diec18 ]
{
	self.nextthink = (time + 0.05);
};

void () riot_diec18 = [ 136, riot_diec19 ]
{
	self.nextthink = (time + 0.05);
};

void () riot_diec19 = [ 137, riot_diec20 ]
{
	self.nextthink = (time + 0.05);
};

void () riot_diec20 = [ 138, riot_diec21 ]
{
	self.nextthink = (time + 0.05);
};

void () riot_diec21 = [ 139, riot_diec22 ]
{
	self.nextthink = (time + 0.05);
};

void () riot_diec22 = [ 140, riot_diec23 ]
{
	self.nextthink = (time + 0.05);
};

void () riot_diec23 = [ 141, riot_diec24 ]
{
	self.nextthink = (time + 0.05);
};

void () riot_diec24 = [ 142, riot_diec25 ]
{
	self.nextthink = (time + 0.05);
};

void () riot_diec25 = [ 143, riot_diec26 ]
{
	self.nextthink = (time + 0.05);
};

void () riot_diec26 = [ 144, riot_diec27 ]
{
	self.nextthink = (time + 0.05);
};

void () riot_diec27 = [ 145, riot_diec28 ]
{
	self.nextthink = (time + 0.05);
};

void () riot_diec28 = [ 146, riot_diec29 ]
{
	self.nextthink = (time + 0.05);
};

void () riot_diec29 = [ 147, riot_diec29 ]
{
};


void () riot_die =
{
	local float r;

	r = random ();
	if ((self.health < -20))
		wallsplat ();
	if ((self.health < -55))
	{
		sound (self, CHAN_VOICE, "player/udeath.wav", 1.00, ATTN_NORM);
		if ((random () < SERV_VOL))
		{
			riot_decap1 ();
			return;
		}
		else
			ThrowHead ("progs/h_riot.mdl", self.health);
		ThrowGib ("progs/gib1.mdl", self.health);
		ThrowGib ("progs/gib2.mdl", self.health);
		ThrowGib ("progs/gib3.mdl", self.health);
		return;
	}
	sound (self, CHAN_VOICE, "riot/die1.wav", 1.00, ATTN_NORM);
	if ((r < 0.2))
		riot_die1 ();
	else
	{
		if ((r < 0.4))
			riot_dieb1 ();
		else
		{
			if ((r < 0.6))
				riot_ded1 ();
			else
				riot_diec1 ();
		}
	}
};


void () monster_riot =
{
	if (!deathmatch)
	{
		precache_model ("progs/riot.mdl");
		precache_model ("progs/h_riot.mdl");
		precache_sound ("riot/attack.wav");
		precache_sound ("riot/grunt1.wav");
		precache_sound ("riot/grunt2.wav");
		precache_sound ("riot/pain1.wav");
		precache_sound ("riot/pain2.wav");
		precache_sound ("riot/idle1.wav");
		precache_sound ("riot/idle2.wav");
		precache_sound ("riot/die1.wav");
		precache_sound ("knight/sword1.wav");
		precache_sound ("knight/sword2.wav");
		self.solid = SOLID_SLIDEBOX;
		self.movetype = MOVETYPE_STEP;
		self.tube_load = TRUE;
		setmodel (self, "progs/riot.mdl");
		setsize (self, VEC_HULL_MIN, '16 16 40');
		self.health = 95;
		dealwithskill ();
		self.th_stand = riot_stand1;
		self.th_walk = riot_walk1;
		self.th_run = riot_run1;
		self.th_melee = riot_bash;
		self.th_pain = riot_pain;
		self.th_die = riot_die;
		self.th_missile = Kung_Fu;
		walkmonster_start ();
	}
	else
		remove (self);
};


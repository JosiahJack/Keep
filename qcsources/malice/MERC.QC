void () merc_fire;
void () TelFX;
void () TeleBabe;
void () merc_tel1;
void () merc_stand1 = [ 12, merc_stand2 ]
{
	ai_stand ();
	self.nextthink = (time + 0.2);
};

void () merc_stand2 = [ 13, merc_stand3 ]
{
	ai_stand ();
	self.nextthink = (time + 0.2);
};

void () merc_stand3 = [ 14, merc_stand4 ]
{
	ai_stand ();
	self.nextthink = (time + 0.2);
};

void () merc_stand4 = [ 15, merc_stand5 ]
{
	ai_stand ();
	self.nextthink = (time + 0.2);
};

void () merc_stand5 = [ 16, merc_stand6 ]
{
	ai_stand ();
	self.nextthink = (time + 0.2);
};

void () merc_stand6 = [ 17, merc_stand1 ]
{
	ai_stand ();
	self.nextthink = (time + 0.2);
};

void () merc_astand1 = [ 18, merc_astand2 ]
{
	ai_stand ();
	self.nextthink = (time + 0.2);
};

void () merc_astand2 = [ 19, merc_astand3 ]
{
	ai_stand ();
	self.nextthink = (time + 0.2);
};

void () merc_astand3 = [ 20, merc_astand4 ]
{
	ai_stand ();
	self.nextthink = (time + 0.2);
};

void () merc_astand4 = [ 21, merc_astand5 ]
{
	ai_stand ();
	self.nextthink = (time + 0.2);
};

void () merc_astand5 = [ 22, merc_astand6 ]
{
	ai_stand ();
	self.nextthink = (time + 0.2);
};

void () merc_astand6 = [ 23, merc_astand1 ]
{
	ai_stand ();
	self.nextthink = (time + 0.2);
};

void () merc_walk1 = [ 54, merc_walk2 ]
{
	if ((random () < 0.2))
		sound (self, CHAN_VOICE, "mercbabe/idle.wav", 1.00, ATTN_IDLE);
	ai_walk (4);
};

void () merc_walk2 = [ 55, merc_walk3 ]
{
	ai_walk (6);
};

void () merc_walk3 = [ 56, merc_walk4 ]
{
	ai_walk (5);
};

void () merc_walk4 = [ 57, merc_walk5 ]
{
	ai_walk (4);
};

void () merc_walk5 = [ 58, merc_walk6 ]
{
	ai_walk (3);
};

void () merc_walk6 = [ 59, merc_walk7 ]
{
	ai_walk (3);
};

void () merc_walk7 = [ 60, merc_walk8 ]
{
	ai_walk (2);
};

void () merc_walk8 = [ 61, merc_walk9 ]
{
	ai_walk (4);
};

void () merc_walk9 = [ 62, merc_walk10 ]
{
	ai_walk (4);
};

void () merc_walk10 = [ 63, merc_walk11 ]
{
	ai_walk (4);
};

void () merc_walk11 = [ 64, merc_walk12 ]
{
	ai_walk (5);
};

void () merc_walk12 = [ 65, merc_walk13 ]
{
	ai_walk (3);
};

void () merc_walk13 = [ 66, merc_walk14 ]
{
	ai_walk (3);
};

void () merc_walk14 = [ 67, merc_walk1 ]
{
	ai_walk (2);
};

void () merc_run1 = [ 6, merc_run2 ]
{
	if ((random () < 0.2))
		sound (self, CHAN_VOICE, "mercbabe/idle.wav", 1.00, ATTN_IDLE);
	ai_run (20);
};

void () merc_run2 = [ 7, merc_run3 ]
{
	ai_run (20);
};

void () merc_run3 = [ 8, merc_run4 ]
{
	ai_run (20);
};

void () merc_run4 = [ 9, merc_run5 ]
{
	ai_run (20);
	ai_run_slide ();
};

void () merc_run5 = [ 10, merc_run6 ]
{
	ai_run (20);
};

void () merc_run6 = [ 11, merc_run1 ]
{
	ai_run (20);
};

void () merc_at1 = [ 42, merc_at2 ]
{
	merc_fire ();
	ai_walk (20);
};

void () merc_at2 = [ 43, merc_at3 ]
{
	ai_walk (20);
};

void () merc_at3 = [ 44, merc_at4 ]
{
	ai_walk (20);
};

void () merc_at4 = [ 45, merc_at5 ]
{
	merc_fire ();
	ai_walk (20);
};

void () merc_at5 = [ 46, merc_at6 ]
{
	ai_walk (20);
};

void () merc_at6 = [ 47, merc_run1 ]
{
	ai_walk (20);
};

void () merc_mel1 = [ 48, merc_mel2 ]
{
	merc_fire ();
};

void () merc_mel2 = [ 49, merc_mel3 ]
{
};

void () merc_mel3 = [ 50, merc_mel4 ]
{
	ai_face ();
};

void () merc_mel4 = [ 51, merc_mel5 ]
{
	merc_fire ();
};

void () merc_mel5 = [ 52, merc_mel6 ]
{
};

void () merc_mel6 = [ 53, merc_run1 ]
{
	ai_face ();
};

void () merc_atk1 = [ 36, merc_atk2 ]
{
	merc_fire ();
	ai_walk (20);
};

void () merc_atk2 = [ 37, merc_atk3 ]
{
	ai_walk (20);
	sound (self, CHAN_VOICE, "weapons/shot1.wav", 1.00, ATTN_NORM);
};

void () merc_atk3 = [ 38, merc_atk4 ]
{
	merc_fire ();
	ai_walk (20);
};

void () merc_atk4 = [ 39, merc_atk5 ]
{
	ai_walk (20);
	sound (self, CHAN_VOICE, "weapons/shot1.wav", 1.00, ATTN_NORM);
};

void () merc_atk5 = [ 40, merc_atk6 ]
{
	merc_fire ();
	ai_walk (20);
};

void () merc_atk6 = [ 41, merc_run1 ]
{
	ai_walk (20);
	sound (self, CHAN_VOICE, "weapons/shot1.wav", 1.00, ATTN_NORM);
};

void () merc_pain1 = [ 30, merc_pain2 ]
{
	ai_pain (1);
};

void () merc_pain2 = [ 31, merc_pain3 ]
{
};

void () merc_pain3 = [ 32, merc_pain4 ]
{
};

void () merc_pain4 = [ 33, merc_pain5 ]
{
};

void () merc_pain5 = [ 34, merc_pain6 ]
{
};

void () merc_pain6 = [ 35, merc_run1 ]
{
};

void () merc_paina1 = [ 109, merc_paina2 ]
{
	ai_pain (1);
};

void () merc_paina2 = [ 110, merc_paina3 ]
{
};

void () merc_paina3 = [ 111, merc_paina4 ]
{
};

void () merc_paina4 = [ 112, merc_paina5 ]
{
};

void () merc_paina5 = [ 113, merc_paina6 ]
{
};

void () merc_paina6 = [ 114, merc_paina7 ]
{
};

void () merc_paina7 = [ 115, merc_paina8 ]
{
};

void () merc_paina8 = [ 116, merc_paina9 ]
{
};

void () merc_paina9 = [ 117, merc_run1 ]
{
};

void () merc_painb1 = [ 79, merc_painb2 ]
{
};

void () merc_painb2 = [ 80, merc_painb3 ]
{
	ai_painforward (13);
};

void () merc_painb3 = [ 81, merc_painb4 ]
{
	ai_painforward (9);
};

void () merc_painb4 = [ 82, merc_painb5 ]
{
};

void () merc_painb5 = [ 83, merc_painb6 ]
{
};

void () merc_painb6 = [ 84, merc_painb7 ]
{
};

void () merc_painb7 = [ 85, merc_painb8 ]
{
};

void () merc_painb8 = [ 86, merc_painb9 ]
{
};

void () merc_painb9 = [ 87, merc_painb10 ]
{
};

void () merc_painb10 = [ 88, merc_painb11 ]
{
};

void () merc_painb11 = [ 89, merc_painb12 ]
{
};

void () merc_painb12 = [ 90, merc_painb13 ]
{
};

void () merc_painb13 = [ 91, merc_painb14 ]
{
};

void () merc_painb14 = [ 92, merc_run1 ]
{
};

void () merc_ded1 = [ 101, merc_ded2 ]
{
};

void () merc_ded2 = [ 102, merc_ded3 ]
{
	ai_back (1);
	self.solid = SOLID_NOT;
	self.ammo_shells2 = 5;
	DropBackpack ();
};

void () merc_ded3 = [ 103, merc_ded4 ]
{
	ai_back (2);
};

void () merc_ded4 = [ 104, merc_ded5 ]
{
	ai_back (3);
};

void () merc_ded5 = [ 105, merc_ded6 ]
{
	ai_back (4);
};

void () merc_ded6 = [ 106, merc_ded7 ]
{
	ai_back (2);
};

void () merc_ded7 = [ 107, merc_ded8 ]
{
};

void () merc_ded8 = [ 108, merc_ded8 ]
{
};


void () merc_shoot =
{
	local float r;

	r = random ();
	if ((r < 0.2))
		merc_atk1 ();
	else
	{
		if ((r < SERV_VOL))
			merc_at1 ();
		else
		{
			if ((self.burning == TRUE))
				merc_atk1 ();
			else
				merc_tel1 ();
		}
	}
};


void (entity attacker,float damage) merc_pain =
{
	local float r;

	blooddrops ();
	if ((self.pain_finished > time))
		return;
	r = random ();
	if ((r < 0.4))
	{
		self.pain_finished = (time + 1.1);
		merc_paina1 ();
		sound (self, CHAN_VOICE, "mercbabe/pain3.wav", 1.00, ATTN_NORM);
	}
	else
	{
		if ((r < 0.6))
		{
			self.pain_finished = (time + 1.1);
			merc_painb1 ();
			sound (self, CHAN_VOICE, "mercbabe/pain1.wav", 1.00, ATTN_NORM);
		}
		else
		{
			self.pain_finished = (time + 1.1);
			merc_pain1 ();
			if ((random () < SERV_VOL))
				sound (self, CHAN_VOICE, "mercbabe/pain2.wav", 1.00, ATTN_NORM);
			else
				sound (self, CHAN_VOICE, "mercbabe/pain3.wav", 1.00, ATTN_NORM);
		}
	}
};


void () merc_fire =
{
	local vector dir;
	local entity en;

	ai_face ();
	self.effects = (self.effects | EF_MUZZLEFLASH);
	sound (self, CHAN_WEAPON, "weapons/shot1.wav", 1.00, ATTN_NORM);
	en = self.enemy;
	dir = (en.origin - (en.velocity * 0.2));
	dir = normalize ((dir - self.origin));
	FireBullets (1, dir, '0.1 0.1 0');
};


void () merc_stand =
{
	if ((random () > SERV_VOL))
		merc_stand1 ();
	else
		merc_astand1 ();
};

void () merc_die1 = [ 68, merc_die2 ]
{
};

void () merc_die2 = [ 69, merc_die3 ]
{
};

void () merc_die3 = [ 70, merc_die4 ]
{
	self.solid = SOLID_NOT;
	self.ammo_shells2 = 5;
	DropBackpack ();
};

void () merc_die4 = [ 71, merc_die5 ]
{
};

void () merc_die5 = [ 72, merc_die6 ]
{
};

void () merc_die6 = [ 73, merc_die7 ]
{
};

void () merc_die7 = [ 74, merc_die8 ]
{
};

void () merc_die8 = [ 75, merc_die9 ]
{
};

void () merc_die9 = [ 76, merc_die10 ]
{
};

void () merc_die10 = [ 77, merc_die11 ]
{
};

void () merc_die11 = [ 78, merc_die11 ]
{
};

void () merc_cdie1 = [ 93, merc_cdie2 ]
{
};

void () merc_cdie2 = [ 94, merc_cdie3 ]
{
};

void () merc_cdie3 = [ 95, merc_cdie4 ]
{
	self.solid = SOLID_NOT;
	self.ammo_shells2 = 5;
	DropBackpack ();
	ai_back (4);
};

void () merc_cdie4 = [ 96, merc_cdie5 ]
{
	ai_back (4);
};

void () merc_cdie5 = [ 97, merc_cdie6 ]
{
	ai_back (4);
};

void () merc_cdie6 = [ 98, merc_cdie7 ]
{
	ai_back (4);
};

void () merc_cdie7 = [ 99, merc_cdie8 ]
{
};

void () merc_cdie8 = [ 100, merc_cdie8 ]
{
};


void () merc_die =
{
	local float r;

	r = random ();
	if ((self.health < -20))
		wallsplat ();
	if ((self.health < -35))
	{
		sound (self, CHAN_VOICE, "player/udeath.wav", 1.00, ATTN_NORM);
		ThrowHead ("progs/h_merc.mdl", self.health);
		ThrowGib ("progs/gib1.mdl", self.health);
		ThrowGib ("progs/gib2.mdl", self.health);
		ThrowGib ("progs/gib3.mdl", self.health);
		return;
	}
	sound (self, CHAN_VOICE, "mercbabe/death1.wav", 1.00, ATTN_NORM);
	if ((r < 0.4))
		merc_die1 ();
	else
	{
		if ((r < 0.7))
			merc_cdie1 ();
		else
			merc_ded1 ();
	}
};

void () merc_heh1 = [ 134, merc_heh2 ]
{
	ai_walk (20);
	self.nextthink = (time + 0.2);
};

void () merc_heh2 = [ 134, merc_heh3 ]
{
	ai_walk (20);
	self.nextthink = (time + 0.2);
};

void () merc_heh3 = [ 134, merc_heh4 ]
{
	ai_walk (20);
	self.nextthink = (time + 0.2);
};

void () merc_heh4 = [ 134, merc_heh5 ]
{
	ai_walk (20);
	self.nextthink = (time + 0.2);
};

void () merc_heh5 = [ 134, merc_heh6 ]
{
	ai_walk (20);
	self.nextthink = (time + 0.2);
};

void () merc_heh6 = [ 134, merc_heh7 ]
{
	ai_walk (20);
	self.nextthink = (time + 0.2);
};

void () merc_heh7 = [ 134, merc_heh8 ]
{
	ai_walk (20);
	self.nextthink = (time + 0.2);
};

void () merc_heh8 = [ 134, merc_heh9 ]
{
	ai_walk (20);
	self.nextthink = (time + 0.2);
};

void () merc_heh9 = [ 134, merc_heh10 ]
{
	ai_walk (20);
	self.nextthink = (time + 0.2);
};

void () merc_heh10 = [ 134, merc_heh11 ]
{
	ai_walk (20);
	self.nextthink = (time + 0.2);
};

void () merc_heh11 = [ 134, merc_heh12 ]
{
	ai_walk (20);
	self.nextthink = (time + 0.2);
};

void () merc_heh12 = [ 134, merc_heh13 ]
{
	ai_walk (20);
	self.nextthink = (time + 0.2);
};

void () merc_heh13 = [ 134, merc_heh14 ]
{
	ai_walk (20);
	self.nextthink = (time + 0.2);
};

void () merc_heh14 = [ 134, merc_heh15 ]
{
	ai_walk (20);
	self.nextthink = (time + 0.2);
};

void () merc_heh15 = [ 134, merc_spn1 ]
{
	ai_walk (20);
	self.nextthink = (time + 0.2);
};

void () merc_spn1;
void () merc_tel1 = [ 118, merc_tel2 ]
{
};

void () merc_tel2 = [ 119, merc_tel3 ]
{
};

void () merc_tel3 = [ 120, merc_tel4 ]
{
};

void () merc_tel4 = [ 121, merc_tel5 ]
{
};

void () merc_tel5 = [ 122, merc_tel6 ]
{
};

void () merc_tel6 = [ 123, merc_tel7 ]
{
};

void () merc_tel7 = [ 124, merc_tel8 ]
{
};

void () merc_tel8 = [ 125, merc_tel9 ]
{
};

void () merc_tel9 = [ 126, merc_heh1 ]
{
	TeleBabe ();
	self.solid = SOLID_NOT;
};


void () TeleBabe =
{
	local entity zip;

	self.effects = (self.effects | EF_MUZZLEFLASH);
	sound (self, CHAN_VOICE, "misc/r_tele1.wav", 1.00, ATTN_NORM);
	zip = spawn ();
	zip.nextthink = time;
	zip.think = TelFX;
	setsize (zip, VEC_ORIGIN, VEC_ORIGIN);
	setorigin (zip, self.origin);
};


void () TelFX =
{
	self.origin = (self.origin - (8 * normalize (self.velocity)));
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_TELEPORT);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);
	remove (self);
	return;
};

void () merc_spn1 = [ 127, merc_spn2 ]
{
	TeleBabe ();
	ai_face ();
	self.solid = SOLID_SLIDEBOX;
	setsize (self, VEC_HULL_MIN, '16 16 40');
};

void () merc_spn2 = [ 128, merc_spn3 ]
{
	ai_face ();
};

void () merc_spn3 = [ 129, merc_spn4 ]
{
};

void () merc_spn4 = [ 130, merc_spn5 ]
{
};

void () merc_spn5 = [ 131, merc_spn6 ]
{
};

void () merc_spn6 = [ 132, merc_spn7 ]
{
};

void () merc_spn7 = [ 133, merc_run1 ]
{
};


void () monster_merc =
{
	if (!deathmatch)
	{
		precache_model ("progs/mercbabe.mdl");
		precache_model ("progs/h_merc.mdl");
		precache_sound ("mercbabe/death1.wav");
		precache_sound ("mercbabe/idle.wav");
		precache_sound ("mercbabe/pain1.wav");
		precache_sound ("mercbabe/pain2.wav");
		precache_sound ("mercbabe/pain3.wav");
		precache_sound ("weapons/shot1.wav");
		precache_sound ("mercbabe/sight1.wav");
		self.solid = SOLID_SLIDEBOX;
		self.movetype = MOVETYPE_STEP;
		setmodel (self, "progs/mercbabe.mdl");
		setsize (self, VEC_HULL_MIN, '16 16 40');
		self.health = 100;
		dealwithskill ();
		self.th_stand = merc_stand;
		self.th_walk = merc_walk1;
		self.th_run = merc_run1;
		self.th_missile = merc_shoot;
		self.th_pain = merc_pain;
		self.th_die = merc_die;
		self.th_melee = merc_mel1;
		walkmonster_start ();
	}
	else
		remove (self);
};


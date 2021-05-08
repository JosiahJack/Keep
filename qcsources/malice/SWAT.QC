void (float offset) SwatMissile;
void () swat_fire01;
void () swat_fire07;

void () IdleSound =
{
	local float x;

	x = random ();
	if ((random () < 0.33))
	{
		if ((x < 0.33))
			sound (self, CHAN_VOICE, "swat/idle1.wav", 1.00, ATTN_IDLE);
		else
		{
			if ((x < 0.66))
				sound (self, CHAN_VOICE, "swat/idle2.wav", 1.00, ATTN_IDLE);
			else
				sound (self, CHAN_VOICE, "swat/idle3.wav", 1.00, ATTN_IDLE);
		}
	}
};

void () swat_stand = [ 0, swat_stand1 ]
{
	IdleSound ();
};

void () swat_stand1 = [ 1, swat_stand2 ]
{
};

void () swat_stand2 = [ 2, swat_stand3 ]
{
};

void () swat_stand3 = [ 3, swat_stand4 ]
{
};

void () swat_stand4 = [ 4, swat_stand5 ]
{
};

void () swat_stand5 = [ 5, swat_stand6 ]
{
};

void () swat_stand6 = [ 6, swat_stand7 ]
{
};

void () swat_stand7 = [ 7, swat_stand8 ]
{
};

void () swat_stand8 = [ 8, swat_stand9 ]
{
};

void () swat_stand9 = [ 9, swat_stand10 ]
{
};

void () swat_stand10 = [ 10, swat_stand11 ]
{
};

void () swat_stand11 = [ 11, swat_stand12 ]
{
};

void () swat_stand12 = [ 12, swat_stand13 ]
{
};

void () swat_stand13 = [ 13, swat_stand14 ]
{
};

void () swat_stand14 = [ 14, swat_stand15 ]
{
};

void () swat_stand15 = [ 15, swat_stand16 ]
{
};

void () swat_stand16 = [ 16, swat_stand17 ]
{
};

void () swat_stand17 = [ 17, swat_stand18 ]
{
};

void () swat_stand18 = [ 18, swat_stand19 ]
{
};

void () swat_stand19 = [ 19, swat_stand20 ]
{
	ai_stand ();
};

void () swat_stand20 = [ 20, swat_stand21 ]
{
	ai_stand ();
};

void () swat_stand21 = [ 21, swat_stand22 ]
{
	ai_stand ();
};

void () swat_stand22 = [ 22, swat_stand23 ]
{
	ai_stand ();
};

void () swat_stand23 = [ 23, swat_stand24 ]
{
	ai_stand ();
};

void () swat_stand24 = [ 24, swat_stand25 ]
{
	ai_stand ();
};

void () swat_stand25 = [ 25, swat_stand26 ]
{
	ai_stand ();
};

void () swat_stand26 = [ 26, swat_stand27 ]
{
	ai_stand ();
};

void () swat_stand27 = [ 27, swat_stand28 ]
{
	ai_stand ();
};

void () swat_stand28 = [ 28, swat_stand29 ]
{
	ai_stand ();
};

void () swat_stand29 = [ 29, swat_stand30 ]
{
	ai_stand ();
};

void () swat_stand30 = [ 28, swat_stand31 ]
{
	ai_stand ();
};

void () swat_stand31 = [ 27, swat_stand32 ]
{
	ai_stand ();
};

void () swat_stand32 = [ 26, swat_stand33 ]
{
	ai_stand ();
};

void () swat_stand33 = [ 25, swat_stand34 ]
{
	ai_stand ();
};

void () swat_stand34 = [ 24, swat_stand35 ]
{
	ai_stand ();
};

void () swat_stand35 = [ 23, swat_stand36 ]
{
	ai_stand ();
};

void () swat_stand36 = [ 22, swat_stand37 ]
{
	ai_stand ();
};

void () swat_stand37 = [ 21, swat_stand38 ]
{
	ai_stand ();
};

void () swat_stand38 = [ 20, swat_stand39 ]
{
	ai_stand ();
};

void () swat_stand39 = [ 19, swat_stand40 ]
{
	ai_stand ();
};

void () swat_stand40 = [ 18, swat_stand41 ]
{
	ai_stand ();
};

void () swat_stand41 = [ 17, swat_stand42 ]
{
	ai_stand ();
};

void () swat_stand42 = [ 16, swat_stand43 ]
{
	ai_stand ();
};

void () swat_stand43 = [ 15, swat_stand44 ]
{
	ai_stand ();
};

void () swat_stand44 = [ 14, swat_stand45 ]
{
	ai_stand ();
};

void () swat_stand45 = [ 13, swat_stand46 ]
{
	ai_stand ();
};

void () swat_stand46 = [ 12, swat_stand47 ]
{
	ai_stand ();
};

void () swat_stand47 = [ 11, swat_stand48 ]
{
	ai_stand ();
};

void () swat_stand48 = [ 10, swat_stand49 ]
{
	ai_stand ();
};

void () swat_stand49 = [ 9, swat_stand50 ]
{
	ai_stand ();
};

void () swat_stand50 = [ 8, swat_stand51 ]
{
	ai_stand ();
};

void () swat_stand51 = [ 7, swat_stand52 ]
{
	ai_stand ();
};

void () swat_stand52 = [ 6, swat_stand53 ]
{
	ai_stand ();
};

void () swat_stand53 = [ 5, swat_stand54 ]
{
	ai_stand ();
};

void () swat_stand54 = [ 4, swat_stand55 ]
{
	ai_stand ();
};

void () swat_stand55 = [ 3, swat_stand56 ]
{
	ai_stand ();
};

void () swat_stand56 = [ 2, swat_stand57 ]
{
	ai_stand ();
};

void () swat_stand57 = [ 1, swat_stand ]
{
	ai_stand ();
};

void () swat_run01 = [ 30, swat_run02 ]
{
	ai_walk (20);
};

void () swat_run02 = [ 31, swat_run03 ]
{
	ai_walk (20);
};

void () swat_run03 = [ 32, swat_run04 ]
{
	ai_walk (20);
	ai_face ();
};

void () swat_run04 = [ 33, swat_run05 ]
{
	ai_walk (20);
};

void () swat_run05 = [ 34, swat_run06 ]
{
	ai_walk (20);
};

void () swat_run06 = [ 35, swat_run07 ]
{
	ai_walk (20);
	ai_face ();
};

void () swat_run07 = [ 30, swat_run08 ]
{
	ai_walk (20);
};

void () swat_run08 = [ 31, swat_run09 ]
{
	ai_walk (20);
};

void () swat_run09 = [ 32, swat_run10 ]
{
	ai_run (20);
	ai_face ();
};

void () swat_run10 = [ 33, swat_run11 ]
{
	ai_run (20);
};

void () swat_run11 = [ 34, swat_run12 ]
{
	ai_run (20);
};

void () swat_run12 = [ 35, swat_run01 ]
{
	ai_run (20);
	ai_face ();
};

void () swat_walk01 = [ 30, swat_walk02 ]
{
	ai_walk (20);
};

void () swat_walk02 = [ 31, swat_walk03 ]
{
	ai_walk (20);
};

void () swat_walk03 = [ 32, swat_walk04 ]
{
	ai_walk (20);
};

void () swat_walk04 = [ 33, swat_walk05 ]
{
	ai_walk (20);
};

void () swat_walk05 = [ 34, swat_walk06 ]
{
	ai_walk (20);
};

void () swat_walk06 = [ 35, swat_walk07 ]
{
	ai_walk (20);
};

void () swat_walk07 = [ 30, swat_walk08 ]
{
	ai_walk (20);
};

void () swat_walk08 = [ 31, swat_walk09 ]
{
	ai_walk (20);
};

void () swat_walk09 = [ 32, swat_walk10 ]
{
	ai_walk (20);
};

void () swat_walk10 = [ 33, swat_walk11 ]
{
	ai_walk (20);
};

void () swat_walk11 = [ 34, swat_walk12 ]
{
	ai_walk (20);
};

void () swat_walk12 = [ 35, swat_walk01 ]
{
	ai_walk (20);
};

void () swat_pain01 = [ 38, swat_pain02 ]
{
};

void () swat_pain02 = [ 39, swat_pain03 ]
{
};

void () swat_pain03 = [ 40, swat_pain04 ]
{
};

void () swat_pain04 = [ 41, swat_pain05 ]
{
};

void () swat_pain05 = [ 42, swat_pain06 ]
{
};

void () swat_pain06 = [ 43, swat_pain07 ]
{
};

void () swat_pain07 = [ 44, swat_pain08 ]
{
};

void () swat_pain08 = [ 45, swat_run04 ]
{
};

void () swat_hurt01 = [ 87, swat_hurt02 ]
{
};

void () swat_hurt02 = [ 88, swat_hurt03 ]
{
};

void () swat_hurt03 = [ 89, swat_hurt04 ]
{
};

void () swat_hurt04 = [ 90, swat_hurt05 ]
{
};

void () swat_hurt05 = [ 91, swat_hurt06 ]
{
};

void () swat_hurt06 = [ 92, swat_hurt07 ]
{
};

void () swat_hurt07 = [ 93, swat_hurt08 ]
{
};

void () swat_hurt08 = [ 94, swat_run04 ]
{
};

void () swat_jug01 = [ 114, swat_jug02 ]
{
	sound (self, CHAN_VOICE, "swat/jug.wav", 1.00, ATTN_NORM);
	ai_forward (2);
};

void () swat_jug02 = [ 115, swat_jug03 ]
{
	self.solid = SOLID_NOT;
	ai_forward (2);
	self.nextthink = (time + 0.05);
};

void () swat_jug03 = [ 116, swat_jug04 ]
{
	self.nextthink = (time + 0.05);
	ai_forward (1);
};

void () swat_jug04 = [ 117, swat_jug05 ]
{
	self.nextthink = (time + 0.05);
	ai_forward (2);
};

void () swat_jug05 = [ 118, swat_jug06 ]
{
	self.ammo_nails2 = 10;
	DropBackpack ();
	self.nextthink = (time + 0.05);
	ai_forward (2);
};

void () swat_jug06 = [ 119, swat_jug07 ]
{
	self.nextthink = (time + 0.05);
	ai_forward (2);
};

void () swat_jug07 = [ 120, swat_jug08 ]
{
	self.nextthink = (time + 0.05);
	ai_forward (3);
};

void () swat_jug08 = [ 121, swat_jug09 ]
{
	self.nextthink = (time + 0.05);
	ai_forward (2);
};

void () swat_jug09 = [ 122, swat_jug10 ]
{
	self.nextthink = (time + 0.05);
	ai_forward (2);
};

void () swat_jug10 = [ 123, swat_jug11 ]
{
	self.nextthink = (time + 0.05);
	ai_forward (1);
};

void () swat_jug11 = [ 124, swat_jug12 ]
{
	self.nextthink = (time + 0.05);
};

void () swat_jug12 = [ 125, swat_jug13 ]
{
	self.nextthink = (time + 0.05);
};

void () swat_jug13 = [ 126, swat_jug14 ]
{
	self.nextthink = (time + 0.05);
};

void () swat_jug14 = [ 127, swat_jug15 ]
{
	self.nextthink = (time + 0.05);
};

void () swat_jug15 = [ 128, swat_jug16 ]
{
	self.nextthink = (time + 0.05);
};

void () swat_jug16 = [ 129, swat_jug17 ]
{
	self.nextthink = (time + 0.05);
};

void () swat_jug17 = [ 130, swat_jug18 ]
{
	self.nextthink = (time + 0.05);
};

void () swat_jug18 = [ 131, swat_jug19 ]
{
	self.nextthink = (time + 0.05);
};

void () swat_jug19 = [ 132, swat_jug20 ]
{
	self.nextthink = (time + 0.05);
};

void () swat_jug20 = [ 133, swat_jug21 ]
{
	self.nextthink = (time + 0.05);
};

void () swat_jug21 = [ 134, swat_jug22 ]
{
	self.nextthink = (time + 0.05);
};

void () swat_jug22 = [ 135, swat_jug23 ]
{
	self.nextthink = (time + 0.1);
};

void () swat_jug23 = [ 136, swat_jug24 ]
{
	self.nextthink = (time + 0.1);
};

void () swat_jug24 = [ 137, swat_jug25 ]
{
	self.nextthink = (time + 0.1);
};

void () swat_jug25 = [ 138, swat_jug26 ]
{
	self.nextthink = (time + 0.1);
};

void () swat_jug26 = [ 139, swat_jug27 ]
{
	self.nextthink = (time + 0.1);
};

void () swat_jug27 = [ 140, swat_jug28 ]
{
	self.nextthink = (time + 0.1);
};

void () swat_jug28 = [ 141, swat_jug29 ]
{
	self.nextthink = (time + 0.1);
};

void () swat_jug29 = [ 142, swat_jug30 ]
{
	self.nextthink = (time + 0.1);
};

void () swat_jug30 = [ 143, swat_jug31 ]
{
	self.nextthink = (time + 0.05);
};

void () swat_jug31 = [ 144, swat_jug32 ]
{
};

void () swat_jug32 = [ 145, swat_jug32 ]
{
};

void () swat_die01 = [ 46, swat_die02 ]
{
	sound (self, CHAN_VOICE, "swat/death1.wav", 1.00, ATTN_NORM);
};

void () swat_die02 = [ 47, swat_die03 ]
{
	self.solid = SOLID_NOT;
};

void () swat_die03 = [ 48, swat_die04 ]
{
};

void () swat_die04 = [ 49, swat_die05 ]
{
};

void () swat_die05 = [ 50, swat_die06 ]
{
	self.ammo_nails2 = 10;
	DropBackpack ();
};

void () swat_die06 = [ 51, swat_die07 ]
{
};

void () swat_die07 = [ 52, swat_die08 ]
{
};

void () swat_die08 = [ 53, swat_die09 ]
{
};

void () swat_die09 = [ 54, swat_die09 ]
{
};

void () swat_up01 = [ 46, swat_up02 ]
{
	self.health = 100;
};

void () swat_up02 = [ 47, swat_up03 ]
{
	self.health = 100;
};

void () swat_up03 = [ 48, swat_up04 ]
{
	self.health = 100;
};

void () swat_up04 = [ 49, swat_up05 ]
{
	self.health = 100;
};

void () swat_up05 = [ 50, swat_up06 ]
{
	self.health = 100;
};

void () swat_up06 = [ 51, swat_up07 ]
{
	self.health = 100;
};

void () swat_up07 = [ 52, swat_up08 ]
{
	self.health = 100;
};

void () swat_up08 = [ 53, swat_up09 ]
{
	self.health = 100;
};

void () swat_up09 = [ 54, swat_up10 ]
{
	self.health = 100;
};

void () swat_up10 = [ 104, swat_up11 ]
{
	self.health = 100;
};

void () swat_up11 = [ 105, swat_up12 ]
{
	self.health = 100;
};

void () swat_up12 = [ 106, swat_up13 ]
{
	self.health = 100;
};

void () swat_up13 = [ 107, swat_up14 ]
{
	self.health = 100;
};

void () swat_up14 = [ 108, swat_up15 ]
{
	self.health = 100;
};

void () swat_up15 = [ 109, swat_up16 ]
{
	self.health = 1;
};

void () swat_up16 = [ 110, swat_up17 ]
{
};

void () swat_up17 = [ 111, swat_up18 ]
{
};

void () swat_up18 = [ 112, swat_up19 ]
{
};

void () swat_up19 = [ 113, swat_run01 ]
{
};

void () swat_ded01 = [ 75, swat_ded02 ]
{
	sound (self, CHAN_VOICE, "swat/death2.wav", 1.00, ATTN_NORM);
};

void () swat_ded02 = [ 76, swat_ded03 ]
{
	self.solid = SOLID_NOT;
};

void () swat_ded03 = [ 77, swat_ded04 ]
{
};

void () swat_ded04 = [ 78, swat_ded05 ]
{
};

void () swat_ded05 = [ 79, swat_ded06 ]
{
};

void () swat_ded06 = [ 80, swat_ded07 ]
{
};

void () swat_ded07 = [ 81, swat_ded08 ]
{
};

void () swat_ded08 = [ 82, swat_ded09 ]
{
	self.ammo_nails2 = 10;
	DropBackpack ();
};

void () swat_ded09 = [ 83, swat_ded10 ]
{
};

void () swat_ded10 = [ 84, swat_ded11 ]
{
};

void () swat_ded11 = [ 85, swat_ded12 ]
{
};

void () swat_ded12 = [ 86, swat_ded12 ]
{
};

void () swat_aadie01 = [ 95, swat_aadie02 ]
{
	sound (self, CHAN_VOICE, "swat/death3.wav", 1.00, ATTN_NORM);
	ai_forward (10);
};

void () swat_aadie02 = [ 96, swat_aadie03 ]
{
	ai_forward (10);
	self.solid = SOLID_NOT;
};

void () swat_aadie03 = [ 97, swat_aadie04 ]
{
	ai_forward (10);
};

void () swat_aadie04 = [ 98, swat_aadie05 ]
{
	ai_forward (5);
};

void () swat_aadie05 = [ 99, swat_aadie06 ]
{
	self.ammo_nails2 = 10;
	DropBackpack ();
};

void () swat_aadie06 = [ 100, swat_aadie07 ]
{
};

void () swat_aadie07 = [ 101, swat_aadie08 ]
{
};

void () swat_aadie08 = [ 102, swat_aadie09 ]
{
};

void () swat_aadie09 = [ 103, swat_aadie09 ]
{
};

void () swat_gib01 = [ 55, swat_gib02 ]
{
	ThrowGib ("progs/h_swat.mdl", -100);
	sound (self, CHAN_VOICE, "player/udeath.wav", 1.00, ATTN_NORM);
};

void () swat_gib02 = [ 56, swat_gib03 ]
{
	self.solid = SOLID_NOT;
};

void () swat_gib03 = [ 57, swat_gib20 ]
{
};

void () swat_gib20 = [ 56, swat_gib21 ]
{
};

void () swat_gib21 = [ 55, swat_gib22 ]
{
};

void () swat_gib22 = [ 56, swat_gib23 ]
{
};

void () swat_gib23 = [ 57, swat_gib04 ]
{
};

void () swat_gib04 = [ 58, swat_gib05 ]
{
};

void () swat_gib05 = [ 59, swat_gib06 ]
{
};

void () swat_gib06 = [ 60, swat_gib07 ]
{
};

void () swat_gib07 = [ 61, swat_gib08 ]
{
};

void () swat_gib08 = [ 62, swat_gib09 ]
{
};

void () swat_gib09 = [ 63, swat_gib10 ]
{
};

void () swat_gib10 = [ 64, swat_gib11 ]
{
	self.ammo_nails2 = 10;
	DropBackpack ();
};

void () swat_gib11 = [ 65, swat_gib12 ]
{
};

void () swat_gib12 = [ 66, swat_gib12 ]
{
};

void () swat_gibb01 = [ 67, swat_gibb02 ]
{
	sound (self, CHAN_VOICE, "swat/arms.wav", 1.00, ATTN_NORM);
	ThrowGib ("progs/gib1.mdl", -100);
	ThrowGib ("progs/gib1.mdl", -100);
};

void () swat_gibb02 = [ 68, swat_gibb03 ]
{
	self.solid = SOLID_NOT;
};

void () swat_gibb03 = [ 67, swat_gibb04 ]
{
};

void () swat_gibb04 = [ 68, swat_gibb05 ]
{
};

void () swat_gibb05 = [ 69, swat_gibb06 ]
{
};

void () swat_gibb06 = [ 70, swat_gibb07 ]
{
};

void () swat_gibb07 = [ 71, swat_gibb08 ]
{
	self.ammo_nails2 = 10;
	DropBackpack ();
};

void () swat_gibb08 = [ 72, swat_gibb09 ]
{
};

void () swat_gibb09 = [ 73, swat_gibb10 ]
{
};

void () swat_gibb10 = [ 74, swat_gibb10 ]
{
};


void () swat_gib =
{
	if ((random () > 0.5))
		swat_gibb01 ();
	else
		swat_gib01 ();
};


void () swat_die =
{
	local float r;

	r = random ();
	if ((self.health < -20))
		wallsplat ();
	if ((self.health < -45))
		swat_gib ();
	else
	{
		if ((r < 0.3))
			swat_die01 ();
		else
		{
			if ((r > 0.5))
				swat_ded01 ();
			else
			{
				if ((r > 0.8))
					swat_aadie01 ();
				else
					swat_jug01 ();
			}
		}
	}
};


void (entity attacker,float damage) swat_pain =
{
	local float n;
	local float x;

	n = random ();
	x = random ();
	blooddrops ();
	if ((self.pain_finished > time))
		return;
	self.pain_finished = (time + 3.00);
	if ((x < 0.33))
		sound (self, CHAN_VOICE, "swat/pain1.wav", 1.00, ATTN_NORM);
	else
	{
		if ((x < 0.66))
			sound (self, CHAN_VOICE, "swat/pain2.wav", 1.00, ATTN_NORM);
		else
			sound (self, CHAN_VOICE, "swat/pain3.wav", 1.00, ATTN_NORM);
	}
	if ((n < 0.4))
		swat_pain01 ();
	else
	{
		if ((n < 0.8))
			swat_hurt01 ();
		else
			swat_up01 ();
	}
};


void () swat_fire =
{
	if ((random () > 0.5))
		swat_fire01 ();
	else
		swat_fire07 ();
};

void () swat_fire01 = [ 36, swat_fire02 ]
{
	ai_face ();
	SwatMissile (0);
};

void () swat_fire02 = [ 37, swat_fire03 ]
{
	ai_face ();
	sound (self, CHAN_WEAPON, "swat/uzim.wav", 1.00, ATTN_NORM);
};

void () swat_fire03 = [ 36, swat_fire04 ]
{
	ai_face ();
	SwatMissile (0);
};

void () swat_fire04 = [ 37, swat_fire05 ]
{
	ai_face ();
	sound (self, CHAN_WEAPON, "swat/uzim.wav", 1.00, ATTN_NORM);
};

void () swat_fire05 = [ 36, swat_fire06 ]
{
	ai_face ();
	SwatMissile (0);
};

void () swat_fire06 = [ 37, swat_run04 ]
{
	ai_face ();
	sound (self, CHAN_WEAPON, "swat/uzim.wav", 1.00, ATTN_NORM);
};

void () swat_fire07 = [ 36, swat_fire08 ]
{
	ai_face ();
	SwatMissile (0);
};

void () swat_fire08 = [ 37, swat_fire09 ]
{
	ai_face ();
	sound (self, CHAN_WEAPON, "swat/uzim.wav", 1.00, ATTN_NORM);
};

void () swat_fire09 = [ 36, swat_fire10 ]
{
	ai_face ();
	SwatMissile (0);
};

void () swat_fire10 = [ 37, swat_run04 ]
{
	ai_face ();
	sound (self, CHAN_WEAPON, "swat/uzim.wav", 1.00, ATTN_NORM);
};


void (float offset) SwatMissile =
{
	local vector offang;
	local vector org;
	local vector vec;

	self.effects = (self.effects | EF_MUZZLEFLASH);
	offang = vectoangles ((self.enemy.origin - self.origin));
	makevectors (offang);
	org = (self.origin - (30 * normalize (self.velocity)));
	vec = normalize (v_forward);
	vec_z = ((0 - vec_z) + ((random () - 0.5) * 0.1));
	launch_spike (org, vec);
	newmis.classname = "LaunchNails";
	setmodel (newmis, "progs/bshell1.mdl");
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);
	newmis.velocity = (vec * 1000);
	sound (self, CHAN_WEAPON, "swat/uzim.wav", 1.00, ATTN_NORM);
};


void () monster_swat =
{
	if (!deathmatch)
	{
		precache_sound ("swat/idle1.wav");
		precache_sound ("swat/idle2.wav");
		precache_sound ("swat/idle3.wav");
		precache_sound ("swat/pain1.wav");
		precache_sound ("swat/pain2.wav");
		precache_sound ("swat/pain3.wav");
		precache_sound ("swat/death3.wav");
		precache_sound ("swat/death2.wav");
		precache_sound ("swat/death1.wav");
		precache_sound ("swat/sight1.wav");
		precache_sound ("swat/sight2.wav");
		precache_sound ("swat/arms.wav");
		precache_sound2 ("swat/arms.wav");
		precache_sound ("swat/jug.wav");
		precache_sound ("swat/uzim.wav");
		precache_model ("progs/swat.mdl");
		precache_model ("progs/bshell1.mdl");
		precache_model ("progs/h_swat.mdl");
		self.solid = SOLID_SLIDEBOX;
		self.movetype = MOVETYPE_STEP;
		setmodel (self, "progs/swat.mdl");
		setsize (self, VEC_HULL_MIN, '16 16 40');
		self.health = 80;
		dealwithskill ();
		self.th_stand = swat_stand;
		self.th_walk = swat_walk01;
		self.th_run = swat_run01;
		self.th_die = swat_die;
		self.th_pain = swat_pain;
		self.th_missile = swat_fire;
		self.th_melee = swat_fire;
		self.nextthink = (self.nextthink + (random () * 2.00));
		self.think = walkmonster_start_go;
		total_monsters = (total_monsters + 1);
	}
	else
		remove (self);
};


void () thing_body =
{
	local float n;

	if (!deathmatch)
	{
		self.solid = SOLID_NOT;
		self.movetype = MOVETYPE_NONE;
		precache_model ("progs/swat.mdl");
		setmodel (self, "progs/swat.mdl");
		setsize (self, VEC_HULL_MIN, '16 16 40');
		droptofloor (0, 0);
		self.think = SUB_Null;
		n = random ();
		if ((n < 0.2))
			self.frame = 54;
		else
		{
			if ((n < 0.3))
				self.frame = 66;
			else
			{
				if ((n < 0.5))
					self.frame = 74;
				else
				{
					if ((n < 0.7))
						self.frame = 86;
					else
					{
						if ((n < 0.8))
							self.frame = 103;
						else
							self.frame = 145;
					}
				}
			}
		}
	}
	else
		remove (self);
};


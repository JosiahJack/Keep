void () blowfish_run1;

void () venom_touch =
{
	if ((other == self.owner))
		return;
	self.velocity = VEC_ORIGIN;
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	if ((pointcontents (self.origin) == CONTENT_SKY))
	{
		remove (self);
		return;
	}
	sound (self, CHAN_WEAPON, "blowfish/impact.wav", 1.00, ATTN_NORM);
	if (other.health)
	{
		T_Damage (other, self, self.owner, 30);
		remove (self);
	}
};


void () blowfish_venom =
{
	local vector trace1;
	local entity harp;

	harp = spawn ();
	harp.movetype = MOVETYPE_FLYMISSILE;
	harp.owner = self;
	harp.solid = SOLID_BBOX;
	trace1 = normalize ((self.origin - self.enemy.origin));
	harp.velocity = (trace1 * -600);
	harp.angles = vectoangles ((trace1 * -1));
	harp.touch = venom_touch;
	harp.nextthink = (time + 5.00);
	harp.think = SUB_Remove;
	setmodel (harp, "progs/harpoon.mdl");
	setsize (harp, VEC_ORIGIN, VEC_ORIGIN);
	setorigin (harp, ((self.origin + (v_forward * 14)) + '0 0 14'));
};

void () blowfish_fire1 = [ 44, blowfish_fire2 ]
{
};

void () blowfish_fire2 = [ 45, blowfish_fire3 ]
{
};

void () blowfish_fire3 = [ 46, blowfish_fire4 ]
{
};

void () blowfish_fire4 = [ 47, blowfish_fire5 ]
{
	ai_face ();
};

void () blowfish_fire5 = [ 48, blowfish_fire6 ]
{
	ai_face ();
};

void () blowfish_fire6 = [ 49, blowfish_fire7 ]
{
	ai_face ();
	sound (self, CHAN_VOICE, "blowfish/venom.wav", 1.00, ATTN_NORM);
	blowfish_venom ();
};

void () blowfish_fire7 = [ 50, blowfish_fire8 ]
{
	ai_face ();
};

void () blowfish_fire8 = [ 51, blowfish_fire9 ]
{
	ai_face ();
};

void () blowfish_fire9 = [ 52, blowfish_fire10 ]
{
	ai_face ();
};

void () blowfish_fire10 = [ 53, blowfish_fire11 ]
{
};

void () blowfish_fire11 = [ 54, blowfish_fire12 ]
{
};

void () blowfish_fire12 = [ 55, blowfish_run1 ]
{
};


void () blowfish_markfire1 =
{
	if ((random () < 0.4))
		blowfish_fire1 ();
	else
		ai_run (0);
};

void () blowfish_stand1 = [ 79, blowfish_stand2 ]
{
	ai_stand ();
	if ((random () < 0.2))
	{
		if ((random () < 0.5))
			sound (self, CHAN_VOICE, "blowfish/idle.wav", 1.00, ATTN_NORM);
		else
			sound (self, CHAN_VOICE, "blowfish/idle2.wav", 1.00, ATTN_NORM);
	}
};

void () blowfish_stand2 = [ 80, blowfish_stand3 ]
{
	ai_stand ();
};

void () blowfish_stand3 = [ 81, blowfish_stand4 ]
{
	ai_stand ();
};

void () blowfish_stand4 = [ 82, blowfish_stand5 ]
{
	ai_stand ();
};

void () blowfish_stand5 = [ 83, blowfish_stand6 ]
{
	ai_stand ();
};

void () blowfish_stand6 = [ 84, blowfish_stand7 ]
{
	ai_stand ();
};

void () blowfish_stand7 = [ 85, blowfish_stand8 ]
{
	ai_stand ();
};

void () blowfish_stand8 = [ 86, blowfish_stand9 ]
{
	ai_stand ();
};

void () blowfish_stand9 = [ 87, blowfish_stand1 ]
{
	ai_stand ();
};

void () blowfish_walk1 = [ 0, blowfish_walk2 ]
{
	ai_walk (8);
	if ((random () < 0.2))
	{
		if ((random () < 0.5))
			sound (self, CHAN_VOICE, "blowfish/idle.wav", 1.00, ATTN_NORM);
		else
			sound (self, CHAN_VOICE, "blowfish/idle2.wav", 1.00, ATTN_NORM);
	}
};

void () blowfish_walk2 = [ 1, blowfish_walk3 ]
{
	ai_walk (20);
};

void () blowfish_walk3 = [ 2, blowfish_walk4 ]
{
	ai_walk (20);
};

void () blowfish_walk4 = [ 3, blowfish_walk5 ]
{
	ai_walk (20);
};

void () blowfish_walk5 = [ 4, blowfish_walk6 ]
{
	ai_walk (20);
};

void () blowfish_walk6 = [ 5, blowfish_walk7 ]
{
	ai_walk (20);
};

void () blowfish_walk7 = [ 6, blowfish_walk8 ]
{
	ai_walk (20);
};

void () blowfish_walk8 = [ 7, blowfish_walk9 ]
{
	ai_walk (20);
};

void () blowfish_walk9 = [ 8, blowfish_walk10 ]
{
	ai_walk (20);
};

void () blowfish_walk10 = [ 9, blowfish_walk1 ]
{
	ai_walk (20);
};

void () blowfish_run1 = [ 0, blowfish_run2 ]
{
	ai_run (10);
	ai_face ();
	if ((random () < 0.5))
	{
		if ((random () < 0.5))
			sound (self, CHAN_VOICE, "blowfish/roam.wav", 1.00, ATTN_NORM);
		else
			sound (self, CHAN_VOICE, "blowfish/roam2.wav", 1.00, ATTN_NORM);
	}
};

void () blowfish_run2 = [ 1, blowfish_run3 ]
{
	ai_run (20);
};

void () blowfish_run3 = [ 2, blowfish_run4 ]
{
	ai_run (20);
};

void () blowfish_run4 = [ 3, blowfish_run5 ]
{
	ai_run (20);
};

void () blowfish_run5 = [ 4, blowfish_run6 ]
{
	ai_run (20);
};

void () blowfish_run6 = [ 5, blowfish_run7 ]
{
	ai_run (20);
};

void () blowfish_run7 = [ 6, blowfish_run8 ]
{
	ai_run (20);
};

void () blowfish_run8 = [ 7, blowfish_run9 ]
{
	ai_run (20);
};

void () blowfish_run9 = [ 8, blowfish_run10 ]
{
	ai_run (20);
};

void () blowfish_run10 = [ 9, blowfish_run1 ]
{
	ai_run (20);
};


void () blowfish_melee =
{
	local vector delta;
	local float ldmg;

	if (!self.enemy)
		return;
	delta = ((self.enemy.origin + '0 0 20') - self.origin);
	if ((vlen (delta) > 100))
		return;
	sound (self, CHAN_VOICE, "doors/airdoor2.wav", 1.00, ATTN_NORM);
	ldmg = ((random () + random ()) * 16);
	T_Damage (self.enemy, self, self, ldmg);
};

void () blowfish_attack1 = [ 18, blowfish_attack2 ]
{
	ai_charge (8);
};

void () blowfish_attack2 = [ 19, blowfish_attack3 ]
{
	ai_charge (8);
};

void () blowfish_attack3 = [ 20, blowfish_attack4 ]
{
	ai_charge (8);
};

void () blowfish_attack4 = [ 21, blowfish_attack5 ]
{
	ai_charge (8);
};

void () blowfish_attack5 = [ 22, blowfish_attack6 ]
{
	ai_charge (8);
};

void () blowfish_attack6 = [ 23, blowfish_attack7 ]
{
	ai_charge (8);
	blowfish_melee ();
};

void () blowfish_attack7 = [ 24, blowfish_attack8 ]
{
	ai_charge (8);
};

void () blowfish_attack8 = [ 25, blowfish_attack9 ]
{
	ai_charge (8);
};

void () blowfish_attack9 = [ 26, blowfish_attack10 ]
{
	ai_charge (8);
};

void () blowfish_attack10 = [ 27, blowfish_attack11 ]
{
	ai_charge (8);
};

void () blowfish_attack11 = [ 28, blowfish_attack12 ]
{
	ai_charge (8);
};

void () blowfish_attack12 = [ 29, blowfish_attack13 ]
{
	ai_charge (8);
};

void () blowfish_attack13 = [ 30, blowfish_attack14 ]
{
	ai_charge (8);
};

void () blowfish_attack14 = [ 31, blowfish_attack15 ]
{
	ai_charge (8);
	blowfish_melee ();
};

void () blowfish_attack15 = [ 32, blowfish_attack16 ]
{
	ai_charge (8);
};

void () blowfish_attack16 = [ 33, blowfish_attack17 ]
{
	ai_charge (8);
};

void () blowfish_attack17 = [ 34, blowfish_run1 ]
{
	ai_charge (8);
};

void () blowfish_bite1 = [ 10, blowfish_bite2 ]
{
	ai_charge (8);
};

void () blowfish_bite2 = [ 11, blowfish_bite3 ]
{
	ai_charge (8);
};

void () blowfish_bite3 = [ 12, blowfish_bite4 ]
{
	ai_charge (8);
};

void () blowfish_bite4 = [ 13, blowfish_bite5 ]
{
	ai_charge (8);
};

void () blowfish_bite5 = [ 14, blowfish_bite6 ]
{
	ai_charge (8);
};

void () blowfish_bite6 = [ 15, blowfish_bite7 ]
{
	ai_charge (8);
	blowfish_melee ();
};

void () blowfish_bite7 = [ 16, blowfish_bite8 ]
{
	ai_charge (8);
};

void () blowfish_bite8 = [ 17, blowfish_run1 ]
{
	ai_charge (8);
};

void () blowfish_death1 = [ 56, blowfish_death2 ]
{
	self.solid = SOLID_NOT;
};

void () blowfish_death2 = [ 57, blowfish_death3 ]
{
};

void () blowfish_death3 = [ 58, blowfish_death4 ]
{
};

void () blowfish_death4 = [ 59, blowfish_death5 ]
{
};

void () blowfish_death5 = [ 60, blowfish_death6 ]
{
};

void () blowfish_death6 = [ 61, blowfish_death7 ]
{
};

void () blowfish_death7 = [ 62, blowfish_death8 ]
{
};

void () blowfish_death8 = [ 63, blowfish_death9 ]
{
};

void () blowfish_death9 = [ 64, blowfish_death10 ]
{
};

void () blowfish_death10 = [ 65, blowfish_death11 ]
{
};

void () blowfish_death11 = [ 66, blowfish_death12 ]
{
	sound (self, CHAN_VOICE, "blowfish/death.wav", 1.00, ATTN_NORM);
};

void () blowfish_death12 = [ 67, blowfish_death13 ]
{
};

void () blowfish_death13 = [ 68, blowfish_death14 ]
{
};

void () blowfish_death14 = [ 69, blowfish_death15 ]
{
};

void () blowfish_death15 = [ 70, blowfish_death15 ]
{
	self.movetype = MOVETYPE_NONE;
};

void () blowfish_pain1 = [ 35, blowfish_pain2 ]
{
};

void () blowfish_pain2 = [ 36, blowfish_pain3 ]
{
	ai_pain (1);
};

void () blowfish_pain3 = [ 37, blowfish_pain4 ]
{
	ai_pain (1);
};

void () blowfish_pain4 = [ 38, blowfish_pain5 ]
{
};

void () blowfish_pain5 = [ 39, blowfish_pain6 ]
{
};

void () blowfish_pain6 = [ 40, blowfish_pain7 ]
{
};

void () blowfish_pain7 = [ 41, blowfish_pain8 ]
{
};

void () blowfish_pain8 = [ 42, blowfish_pain9 ]
{
};

void () blowfish_pain9 = [ 43, blowfish_run1 ]
{
};

void () blowfish_hurt1 = [ 71, blowfish_hurt2 ]
{
};

void () blowfish_hurt2 = [ 72, blowfish_hurt3 ]
{
	ai_pain (1);
};

void () blowfish_hurt3 = [ 73, blowfish_hurt4 ]
{
	ai_pain (1);
};

void () blowfish_hurt4 = [ 74, blowfish_hurt5 ]
{
};

void () blowfish_hurt5 = [ 75, blowfish_hurt6 ]
{
};

void () blowfish_hurt6 = [ 76, blowfish_hurt7 ]
{
};

void () blowfish_hurt7 = [ 77, blowfish_hurt8 ]
{
};

void () blowfish_hurt8 = [ 78, blowfish_run1 ]
{
};


void (entity attacker,float damage) blowfish_pain =
{
	if ((self.pain_finished > time))
		return;
	self.pain_finished = (time + 3.00);
	sound (self, CHAN_VOICE, "blowfish/pain.wav", 1.00, ATTN_NORM);
	if ((random () < 0.5))
		blowfish_pain1 ();
	else
		blowfish_hurt1 ();
};


void () blowfish_chomp =
{
	if ((random () < 0.5))
		blowfish_bite1 ();
	else
		blowfish_attack1 ();
};


void () monster_blow =
{
	if (deathmatch)
		remove (self);
	precache_model ("progs/blowfish.mdl");
	precache_model ("progs/harpoon.mdl");
	precache_sound ("doors/airdoor2.wav");
	precache_sound ("blowfish/idle.wav");
	precache_sound ("blowfish/idle2.wav");
	precache_sound ("blowfish/roam.wav");
	precache_sound ("blowfish/roam2.wav");
	precache_sound ("blowfish/pain.wav");
	precache_sound ("blowfish/death.wav");
	precache_sound ("blowfish/venom.wav");
	precache_sound ("blowfish/impact.wav");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel (self, "progs/blowfish.mdl");
	setsize (self, '-65 -65 -30', '65 65 30');
	self.health = 1500;
	dealwithskill ();
	self.th_stand = blowfish_stand1;
	self.th_walk = blowfish_walk1;
	self.th_run = blowfish_run1;
	self.th_die = blowfish_death1;
	self.th_pain = blowfish_pain;
	self.th_melee = blowfish_chomp;
	self.th_missile = blowfish_markfire1;
	swimmonster_start ();
};


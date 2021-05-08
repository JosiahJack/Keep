void() axe_stand1 = [6, axe_stand2]
{
	ai_stand();
};

void() axe_stand2 = [7, axe_stand3]
{
	ai_stand();
};

void() axe_stand3 = [8, axe_stand4]
{
	ai_stand();
};

void() axe_stand4 = [9, axe_stand5]
{
	ai_stand();
};

void() axe_stand5 = [10, axe_stand6]
{
	ai_stand();
};

void() axe_stand6 = [11, axe_stand7]
{
	ai_stand();
};

void() axe_stand7 = [12, axe_stand8]
{
	ai_stand();
};

void() axe_stand8 = [13, axe_stand9]
{
	ai_stand();
};

void() axe_stand9 = [14, axe_stand10]
{
	ai_stand();
};

void() axe_stand10 = [15, axe_stand11]
{
	ai_stand();
};

void() axe_stand11 = [16, axe_stand12]
{
	ai_stand();
};

void() axe_stand12 = [17, axe_stand1]
{
	ai_stand();
};

void() axe_walk1 = [0, axe_walk2]
{
	if (random() < 0.2)
	{
		sound(self, CHAN_VOICE, "axeman/axidle.wav", 1, ATTN_IDLE);
	}
	ai_walk(MOVETYPE_BOUNCE);
};

void() axe_walk2 = [1, axe_walk3]
{
	ai_walk(MOVETYPE_BOUNCE);
};

void() axe_walk3 = [2, axe_walk4]
{
	ai_walk(CTF_CAPTURE_BONUS);
};

void() axe_walk4 = [3, axe_walk5]
{
	ai_walk(MOVETYPE_BOUNCE);
};

void() axe_walk5 = [4, axe_walk6]
{
	ai_walk(MOVETYPE_BOUNCE);
};

void() axe_walk6 = [5, axe_walk1]
{
	ai_walk(CTF_CAPTURE_BONUS);
};

void() axe_run1 = [0, axe_run2]
{
	if (random() < 0.2)
	{
		sound(self, CHAN_VOICE, "axeman/aidle.wav", 1, ATTN_IDLE);
	}
	ai_run(24);
};

void() axe_run2 = [1, axe_run3]
{
	ai_run(45);
};

void() axe_run3 = [2, axe_run4]
{
	ai_run(SVC_FINALE);
};

void() axe_run4 = [3, axe_run5]
{
	ai_run(20);
};

void() axe_run5 = [4, axe_run6]
{
	ai_run(36);
};

void() axe_run6 = [5, axe_run1]
{
	ai_run(45);
};

void() axe_atk1 = [33, axe_atk2]
{
	sound(self, CHAN_WEAPON, "axeman/axe1.wav", 1, ATTN_NORM);
	ai_charge(0);
};

void() axe_atk2 = [34, axe_atk3]
{
	ai_charge(SVC_FOUNDSECRET);
	ai_melee();
};

void() axe_atk3 = [35, axe_atk4]
{
	ai_charge(FL_INWATER);
	ai_melee();
};

void() axe_atk4 = [36, axe_atk5]
{
	ai_charge(0);
	ai_melee();
};

void() axe_atk5 = [37, axe_atk6]
{
	ai_charge(MOVETYPE_TOSS);
};

void() axe_atk6 = [38, axe_run1]
{
	ai_charge(FL_CLIENT);
};

void() axe_atkb1 = [39, axe_atk2]
{
	sound(self, CHAN_WEAPON, "axeman/axe1.wav", 1, ATTN_NORM);
	ai_charge(0);
};

void() axe_atkb2 = [40, axe_atk3]
{
	ai_charge(SVC_FOUNDSECRET);
	ai_melee();
};

void() axe_atkb3 = [41, axe_atk4]
{
	ai_charge(FL_INWATER);
	ai_melee();
};

void() axe_atkb4 = [42, axe_atkb5]
{
	ai_charge(0);
};

void() axe_atkb5 = [43, axe_atkb6]
{
	ai_charge(MOVETYPE_TOSS);
};

void() axe_atkb6 = [44, axe_run1]
{
	ai_charge(FL_CLIENT);
};

void() axe_atkc1 = [33, axe_atkc2]
{
	sound(self, CHAN_WEAPON, "axeman/axe1.wav", 1, ATTN_NORM);
	ai_charge(0);
};

void() axe_atkc2 = [46, axe_atkc3]
{
	ai_charge(SVC_FOUNDSECRET);
};

void() axe_atkc3 = [47, axe_atkc4]
{
	ai_charge(FL_INWATER);
	ai_melee();
};

void() axe_atkc4 = [48, axe_atkc5]
{
	ai_charge(0);
	ai_melee();
};

void() axe_atkc5 = [49, axe_atkc6]
{
	ai_charge(MOVETYPE_TOSS);
};

void() axe_atkc6 = [50, axe_run1]
{
	ai_charge(FL_CLIENT);
};

void() axe_atkd1 = [51, axe_atkd2]
{
	sound(self, CHAN_WEAPON, "axeman/axe1.wav", 1, ATTN_NORM);
	ai_charge(0);
};

void() axe_atkd2 = [52, axe_atkd3]
{
	ai_charge(SVC_FOUNDSECRET);
	ai_melee();
};

void() axe_atkd3 = [53, axe_atkd4]
{
	ai_charge(FL_INWATER);
	ai_melee();
};

void() axe_atkd4 = [54, axe_atkd5]
{
	ai_charge(0);
};

void() axe_atkd5 = [55, axe_atkd6]
{
	ai_charge(MOVETYPE_TOSS);
};

void() axe_atkd6 = [56, axe_run1]
{
	ai_charge(FL_CLIENT);
};

void() axe_atk = 
{
	axeman_type = axeman_type + 1;
	if (axeman_type == 1)
	{
		axe_atkb1();
	}
	else
	{
		if (axeman_type == FL_SWIM)
		{
			axe_atkd1();
		}
		else
		{
			if (axeman_type == MOVETYPE_WALK)
			{
				if (random() < SERVO_VOLUME)
				{
					axe_atkc1();
				}
				else
				{
					axe_atk1();
				}
				axeman_type = 0;
			}
		}
	}
};

void() axe_pain1 = [18, axe_pain2]
{
	ai_painforward(0);
};

void() axe_pain2 = [19, axe_pain3]
{
	ai_painforward(MOVETYPE_TOSS);
};

void() axe_pain3 = [20, axe_pain4]
{
	ai_painforward(FL_CLIENT);
};

void() axe_pain4 = [21, axe_pain5]
{
	ai_painforward(MOVETYPE_STEP);
};

void() axe_pain5 = [22, axe_pain6]
{
	ai_painforward(FL_SWIM);
};

void() axe_pain6 = [23, axe_run1]
{
};

void(entity attacker, float damage) axe_pain = 
{
	if (self.pain_finished > time)
	{
		return;
	}
	sound(self, CHAN_VOICE, "axeman/apain.wav", 1, ATTN_NORM);
	axe_pain1();
	self.pain_finished = time + 1;
};

void() axe_die1 = [24, axe_die2]
{
};

void() axe_die2 = [25, axe_die3]
{
};

void() axe_die3 = [26, axe_die4]
{
	self.solid = SOLID_NOT;
};

void() axe_die4 = [27, axe_die5]
{
};

void() axe_die5 = [28, axe_die6]
{
};

void() axe_die6 = [29, axe_die7]
{
};

void() axe_die7 = [30, axe_die8]
{
};

void() axe_die8 = [31, axe_die9]
{
};

void() axe_die9 = [32, axe_die9]
{
};

void() axe_die = 
{
	if (self.health < -40)
	{
		sound(self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		ThrowHead("progs/h_knight.mdl", self.health);
		ThrowGib("progs/gib1.mdl", self.health);
		ThrowGib("progs/gib2.mdl", self.health);
		ThrowGib("progs/gib3.mdl", self.health);
		return;
	}
	sound(self, CHAN_VOICE, "axeman/adeath.wav", 1, ATTN_NORM);
	axe_die1();
};

void() monster_ax = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model("progs/axeman.mdl");
	precache_model("progs/h_knight.mdl");
	precache_sound("axeman/adeath.wav");
	precache_sound("axeman/apain.wav");
	precache_sound("axeman/asight.wav");
	precache_sound("axeman/axe1.wav");
	precache_sound("axeman/axe2.wav");
	precache_sound("axeman/aidle.wav");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/axeman.mdl");
	setsize(self, VEC_HULL_MIN, '16 16 40');
	self.health = MAX_CHARMER_DISTANCE;
	self.th_stand = axe_stand1;
	self.th_walk = axe_walk1;
	self.th_run = axe_run1;
	self.th_melee = axe_atk;
	self.th_pain = axe_pain;
	self.th_die = axe_die;
	walkmonster_start();
};

void() monster_axeman = 
{
	monster_ax();
};


void () baboon_leap2;
void () baboon_run1;
void () baboon_stand1;
void () baboon_find_enemy;
void () baboon_kill_lights2;

void () ChuckRock =
{
	local vector offang;
	local vector org;
	local vector vec;

	offang = vectoangles (self.enemy.origin - self.origin);
	makevectors (offang);
	org = self.origin;
	vec = normalize (v_forward);
	vec_z = 0 - vec_z;
	launch_spike (org, vec);
	newmis.classname = "LaunchSpike";
	setmodel (newmis, "progs/spike.mdl");
	newmis.model = string_null;
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);
	newmis.velocity = vec * 1000;
};


void (float side) baboon_bite =
{
	local float ldmg;
	local vector delta;

	ai_charge (10);
	ai_face ();
	walkmove (self.ideal_yaw, 12);
	delta = (self.enemy.origin - self.origin);
	if (vlen (delta) > 100)
		return;
	if (!CanDamage (self.enemy, self))
		return;
	if (random () < 0.50)
		sound (self, CHAN_WEAPON, "baboon/dhit1.wav", 1.00, ATTN_NORM);
	else
		sound (self, CHAN_WEAPON, "baboon/dhit2.wav", 1.00, ATTN_NORM);
	ldmg = ((random () + random ()) + random ()) * 8;
	T_Damage (self.enemy, self, self, ldmg);
	makevectors (self.angles);
	SpawnMeatSpray ((self.origin + (v_forward * 16)), (side * v_right));
};


void () Baboon_JumpTouch =
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
			self.think = baboon_leap2;
			self.nextthink = (time + 0.1);
		}
		return;
	}
	self.touch = SUB_Null;
	self.think = baboon_leap2;
	self.nextthink = (time + 0.1);
};

void () baboon_wail1 = [ 58, baboon_wail2 ]
{
	ai_stand ();
	self.nextthink = (time + 0.1);
	sound (self, CHAN_VOICE, "baboon/wail2.wav", 1.00, ATTN_NORM);
};

void () baboon_wail2 = [ 59, baboon_wail3 ]
{
	ai_stand ();
	self.nextthink = (time + 0.1);
};

void () baboon_wail3 = [ 60, baboon_wail4 ]
{
	ai_stand ();
	self.nextthink = (time + 0.1);
};

void () baboon_wail4 = [ 61, baboon_wail5 ]
{
	ai_stand ();
	self.nextthink = (time + 0.1);
};

void () baboon_wail5 = [ 62, baboon_wail6 ]
{
	ai_stand ();
	self.nextthink = (time + 0.1);
};

void () baboon_wail6 = [ 63, baboon_wail7 ]
{
	ai_stand ();
	self.nextthink = (time + 0.1);
};

void () baboon_wail7 = [ 64, baboon_wail8 ]
{
	ai_stand ();
	self.nextthink = (time + 0.1);
};

void () baboon_wail8 = [ 65, baboon_wail9 ]
{
	ai_stand ();
	self.nextthink = (time + 0.2);
};

void () baboon_wail9 = [ 66, baboon_wail10 ]
{
	ai_stand ();
	self.nextthink = (time + 0.2);
};

void () baboon_wail10 = [ 67, baboon_wail11 ]
{
	ai_stand ();
	self.nextthink = (time + 0.2);
};

void () baboon_wail11 = [ 66, baboon_wail12 ]
{
	ai_stand ();
	self.nextthink = (time + 0.2);
};

void () baboon_wail12 = [ 65, baboon_wail13 ]
{
	ai_stand ();
	self.nextthink = (time + 0.2);
};

void () baboon_wail13 = [ 64, baboon_wail14 ]
{
	ai_stand ();
	self.nextthink = (time + 0.1);
};

void () baboon_wail14 = [ 63, baboon_wail15 ]
{
	ai_stand ();
	self.nextthink = (time + 0.1);
};

void () baboon_wail15 = [ 62, baboon_wail16 ]
{
	ai_stand ();
	self.nextthink = (time + 0.1);
};

void () baboon_wail16 = [ 61, baboon_wail17 ]
{
	ai_stand ();
	self.nextthink = (time + 0.1);
};

void () baboon_wail17 = [ 60, baboon_wail18 ]
{
	ai_stand ();
	self.nextthink = (time + 0.1);
};

void () baboon_wail18 = [ 59, baboon_wail19 ]
{
	ai_stand ();
	self.nextthink = (time + 0.1);
};

void () baboon_wail19 = [ 58, baboon_stand2 ]
{
	ai_stand ();
	self.nextthink = (time + 0.1);
};

void () baboon_stand2;
void () baboon_stand1 = [ 10, baboon_stand2 ]
{
	ai_stand ();
	self.nextthink = (time + 0.2);
	if ((random () < 0.2))
		baboon_wail1 ();
	if ((random () < 0.2))
		sound (self, CHAN_VOICE, "baboon/monst18.wav", 1.00, ATTN_NORM);
};

void () baboon_stand2 = [ 11, baboon_stand3 ]
{
	ai_stand ();
	self.nextthink = (time + 0.2);
};

void () baboon_stand3 = [ 12, baboon_stand4 ]
{
	ai_stand ();
	self.nextthink = (time + 0.2);
};

void () baboon_stand4 = [ 13, baboon_stand5 ]
{
	ai_stand ();
	self.nextthink = (time + 0.2);
};

void () baboon_stand5 = [ 14, baboon_stand6 ]
{
	ai_stand ();
	self.nextthink = (time + 0.2);
};

void () baboon_stand6 = [ 15, baboon_stand7 ]
{
	ai_stand ();
	self.nextthink = (time + 0.2);
};

void () baboon_stand7 = [ 16, baboon_stand8 ]
{
	ai_stand ();
	self.nextthink = (time + 0.2);
};

void () baboon_stand8 = [ 17, baboon_stand9 ]
{
	ai_stand ();
	self.nextthink = (time + 0.2);
};

void () baboon_stand9 = [ 18, baboon_stand10 ]
{
	ai_stand ();
	self.nextthink = (time + 0.2);
};

void () baboon_stand10 = [ 19, baboon_stand11 ]
{
	ai_stand ();
	self.nextthink = (time + 0.2);
};

void () baboon_stand11 = [ 20, baboon_stand12 ]
{
	ai_stand ();
	self.nextthink = (time + 0.2);
};

void () baboon_stand12 = [ 21, baboon_stand13 ]
{
	ai_stand ();
	self.nextthink = (time + 0.2);
};

void () baboon_stand13 = [ 22, baboon_stand14 ]
{
	ai_stand ();
	self.nextthink = (time + 0.2);
};

void () baboon_stand14 = [ 23, baboon_stand15 ]
{
	ai_stand ();
	self.nextthink = (time + 0.2);
};

void () baboon_stand15 = [ 24, baboon_stand16 ]
{
	ai_stand ();
	self.nextthink = (time + 0.2);
};

void () baboon_stand16 = [ 25, baboon_stand17 ]
{
	ai_stand ();
	self.nextthink = (time + 0.2);
};

void () baboon_stand17 = [ 26, baboon_stand18 ]
{
	ai_stand ();
	self.nextthink = (time + 0.2);
};

void () baboon_stand18 = [ 27, baboon_stand19 ]
{
	ai_stand ();
	self.nextthink = (time + 0.2);
};

void () baboon_stand19 = [ 28, baboon_stand1 ]
{
	ai_stand ();
	self.nextthink = (time + 0.2);
};

void () baboon_walk1 = [ 30, baboon_walk2 ]
{
	ai_walk (14);
};

void () baboon_walk2 = [ 31, baboon_walk3 ]
{
	ai_walk (8);
};

void () baboon_walk3 = [ 32, baboon_walk4 ]
{
	ai_walk (22);
};

void () baboon_walk4 = [ 33, baboon_walk5 ]
{
	ai_walk (18);
};

void () baboon_walk5 = [ 34, baboon_walk6 ]
{
	ai_walk (12);
};

void () baboon_walk6 = [ 35, baboon_walk1 ]
{
	ai_walk (10);
};

void () baboon_run1 = [ 0, baboon_run2 ]
{
	ai_run (16);
};

void () baboon_run2 = [ 1, baboon_run3 ]
{
	ai_run (32);
};

void () baboon_run3 = [ 2, baboon_run4 ]
{
	ai_run (32);
};

void () baboon_run4 = [ 3, baboon_run5 ]
{
	ai_run (20);
};

void () baboon_run5 = [ 4, baboon_run6 ]
{
	ai_run (14);
};

void () baboon_run6 = [ 5, baboon_run7 ]
{
	ai_run (16);
};

void () baboon_run7 = [ 6, baboon_run8 ]
{
	ai_run (20);
};

void () baboon_run8 = [ 7, baboon_run9 ]
{
	ai_run (32);
};

void () baboon_run9 = [ 8, baboon_run10 ]
{
	ai_run (20);
};

void () baboon_run10 = [ 9, baboon_run ]
{
	ai_run (15);
};

void () baboon_run;
void () baboon_slash1 = [ 50, baboon_slash2 ]
{
	ai_face ();
};

void () baboon_slash2 = [ 51, baboon_slash3 ]
{
	ai_face ();
};

void () baboon_slash3 = [ 52, baboon_slash4 ]
{
	baboon_bite (-200);
};

void () baboon_slash4 = [ 53, baboon_slash5 ]
{
	baboon_bite (200);
};

void () baboon_slash5 = [ 54, baboon_slash6 ]
{
};

void () baboon_slash6 = [ 55, baboon_slash7 ]
{
};

void () baboon_slash7 = [ 56, baboon_run ]
{
};

void () baboon_atta1 = [ 43, baboon_atta2 ]
{
	ai_face ();
};

void () baboon_atta2 = [ 44, baboon_atta3 ]
{
	ai_face ();
};

void () baboon_atta3 = [ 45, baboon_atta4 ]
{
	ai_face ();
};

void () baboon_atta4 = [ 46, baboon_atta5 ]
{
	baboon_bite (-200);
};

void () baboon_atta5 = [ 47, baboon_atta6 ]
{
};

void () baboon_atta6 = [ 48, baboon_atta7 ]
{
};

void () baboon_atta7 = [ 49, baboon_run ]
{
};

void () baboon_kill_lights2 = [ 51, baboon_kill_lights3 ]
{
	ai_face ();
};

void () baboon_kill_lights3 = [ 52, baboon_kill_lights4 ]
{
	ChuckRock ();
};

void () baboon_kill_lights4 = [ 53, baboon_kill_lights5 ]
{
	ChuckRock ();
};

void () baboon_kill_lights5 = [ 54, baboon_kill_lights6 ]
{
};

void () baboon_kill_lights6 = [ 55, baboon_kill_lights7 ]
{
};

void () baboon_kill_lights7 = [ 56, baboon_run ]
{
};

void () baboon_leap1;

void () baboon_run =
{
	baboon_find_enemy ();
};


void () baboon_find_enemy =
{
	local vector spot1;
	local vector spot2;
	local entity targ;

	targ = findradius (self.origin, 1000);
	while (targ)
	{
		if ((random () < SERV_VOL))
		{
			if ((((targ.classname == "breakable_bulb") && visible (targ)) && (targ.health > 0)))
				self.enemy = targ;
			else
			{
				if ((((targ.classname == "player") && visible (targ)) && (targ.health > 0)))
					self.enemy = targ;
			}
		}
		targ = targ.chain;
	}
	self.goalentity = self.enemy;
	if ((self.enemy.classname == "player"))
		ai_face ();
	baboon_run1 ();
};


void () baboon_attack =
{
	if ((self.enemy.classname == "breakable_bulb"))
		baboon_kill_lights2 ();
	else
	{
		if ((random () < SERV_VOL))
			baboon_atta1 ();
		else
			baboon_slash1 ();
	}
};

void () baboon_leap1 = [ 0, baboon_leap11 ]
{
	ai_face ();
	self.touch = Baboon_JumpTouch;
	makevectors (self.angles);
	self.origin_z = (self.origin_z + 1);
	self.velocity = ((v_forward * 500) + '0 0 200');
	if ((self.flags & FL_ONGROUND))
		self.flags = (self.flags - FL_ONGROUND);
};

void () baboon_leap11 = [ 0, baboon_leap11 ]
{
};

void () baboon_leap2 = [ 1, baboon_leap3 ]
{
	ai_forward (32);
};

void () baboon_leap3 = [ 2, baboon_leap4 ]
{
	ai_forward (32);
};

void () baboon_leap4 = [ 3, baboon_leap5 ]
{
	ai_forward (20);
};

void () baboon_leap5 = [ 4, baboon_leap6 ]
{
	ai_forward (14);
};

void () baboon_leap6 = [ 5, baboon_leap7 ]
{
	ai_forward (16);
};

void () baboon_leap7 = [ 6, baboon_leap8 ]
{
	ai_forward (20);
};

void () baboon_leap8 = [ 7, baboon_leap9 ]
{
	ai_forward (32);
};

void () baboon_leap9 = [ 8, baboon_leap10 ]
{
	ai_forward (20);
};

void () baboon_leap10 = [ 9, baboon_run1 ]
{
	ai_forward (15);
};

void () baboon_pain1 = [ 36, baboon_pain2 ]
{
};

void () baboon_pain2 = [ 37, baboon_pain3 ]
{
};

void () baboon_pain3 = [ 38, baboon_pain4 ]
{
};

void () baboon_pain4 = [ 39, baboon_pain5 ]
{
};

void () baboon_pain5 = [ 40, baboon_pain6 ]
{
};

void () baboon_pain6 = [ 41, baboon_pain7 ]
{
};

void () baboon_pain7 = [ 42, baboon_run1 ]
{
};


void (entity attacker,float damage) baboon_pain =
{
	blooddrops ();
	if ((self.pain_finished > time))
		return;
	self.pain_finished = (time + 2.00);
	sound (self, CHAN_VOICE, "baboon/dpain1.wav", 1.00, ATTN_NORM);
	baboon_pain1 ();
};

void () baboon_die1 = [ 68, baboon_die2 ]
{
};

void () baboon_die2 = [ 69, baboon_die3 ]
{
};

void () baboon_die3 = [ 70, baboon_die4 ]
{
};

void () baboon_die4 = [ 71, baboon_die5 ]
{
};

void () baboon_die5 = [ 72, baboon_die6 ]
{
};

void () baboon_die6 = [ 73, baboon_die7 ]
{
};

void () baboon_die7 = [ 74, baboon_die8 ]
{
};

void () baboon_die8 = [ 75, baboon_die9 ]
{
};

void () baboon_die9 = [ 76, baboon_die9 ]
{
};

void () baboon_dieb1 = [ 77, baboon_dieb2 ]
{
};

void () baboon_dieb2 = [ 78, baboon_dieb3 ]
{
};

void () baboon_dieb3 = [ 79, baboon_dieb4 ]
{
};

void () baboon_dieb4 = [ 80, baboon_dieb5 ]
{
};

void () baboon_dieb5 = [ 81, baboon_dieb6 ]
{
};

void () baboon_dieb6 = [ 82, baboon_dieb7 ]
{
};

void () baboon_dieb7 = [ 83, baboon_dieb8 ]
{
};

void () baboon_dieb8 = [ 84, baboon_dieb9 ]
{
};

void () baboon_dieb9 = [ 85, baboon_dieb9 ]
{
};


void () baboon_die =
{
	if ((self.health < -20))
		wallsplat ();
	if ((self.health < -35))
	{
		sound (self, CHAN_VOICE, "player/udeath.wav", 1.00, ATTN_NORM);
		ThrowGib ("progs/gib3.mdl", self.health);
		ThrowGib ("progs/gib3.mdl", self.health);
		ThrowGib ("progs/gib3.mdl", self.health);
		ThrowHead("progs/h_baboon.mdl", self.health); // ACC, new model
		return;
	}
	sound (self, CHAN_VOICE, "baboon/monst10.wav", 1.00, ATTN_NORM);
	self.solid = SOLID_NOT;
	baboon_die1 ();
};


float () CheckBaboonMelee =
{
	if ((enemy_range == RANGE_MELEE))
	{
		self.attack_state = AS_MELEE;
		return (TRUE);
	}
	return (FALSE);
};


float () CheckBaboonJump =
{
	local vector dist;
	local float d;

	if (((self.origin_z + self.mins_z) > ((self.enemy.origin_z + self.enemy.mins_z) + (0.75 * self.enemy.size_z))))
		return (FALSE);
	if (((self.origin_z + self.maxs_z) < ((self.enemy.origin_z + self.enemy.mins_z) + (0.25 * self.enemy.size_z))))
		return (FALSE);
	dist = (self.enemy.origin - self.origin);
	dist_z = 0;
	d = vlen (dist);
	if ((d < 80))
		return (FALSE);
	if ((d > 150))
		return (FALSE);
	if ((random () > SERV_VOL))
		return (FALSE);
	return (TRUE);
};


float () BaboonCheckAttack =
{
	local vector vec;

	if (CheckBaboonMelee ())
	{
		self.attack_state = AS_MELEE;
		return (TRUE);
	}
	if (CheckBaboonJump ())
	{
		self.attack_state = AS_MISSILE;
		return (TRUE);
	}
	return (FALSE);
};


void () monster_baboon =
{
	if (!deathmatch)
	{
		precache_model ("progs/h_baboon.mdl"); // ACC, new model
		precache_model ("progs/baboon.mdl");
		precache_sound ("baboon/monst10.wav");
		precache_sound ("baboon/monst18.wav");
		precache_sound ("baboon/wail2.wav");
		precache_sound ("baboon/dpain1.wav");
		precache_sound ("baboon/dhit2.wav");
		precache_sound ("baboon/dhit1.wav");
		self.solid = SOLID_SLIDEBOX;
		self.movetype = MOVETYPE_STEP;
		setmodel (self, "progs/baboon.mdl");
		setsize (self, VEC_HULL2_MIN, '32 32 40');
		self.health = 120;
		dealwithskill ();
		self.th_stand = baboon_stand1;
		self.th_walk = baboon_walk1;
		self.th_run = baboon_find_enemy;
		self.th_pain = baboon_pain;
		self.th_die = baboon_die;
		self.th_melee = baboon_attack;
		self.th_missile = baboon_leap1;
		self.enemy = world;
		walkmonster_start ();
	}
	else
		remove (self);
};


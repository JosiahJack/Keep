void() boss2_stand = 
{
	self.think = boss2_stand;
	self.nextthink = time + 0.1;
	self.frame = self.frame + SPAWN_CRUCIFIED;
	if (self.frame > TE_LIGHTNING2 || self.frame < MSG_BROADCAST)
	{
		self.frame = MSG_BROADCAST;
	}
	ai_stand();
};

void() boss2_walk = 
{
	self.think = boss2_walk;
	self.nextthink = time + 0.1;
	self.frame = self.frame + SPAWN_CRUCIFIED;
	if (self.frame > 22 || self.frame < TE_WIZSPIKE)
	{
		self.frame = TE_WIZSPIKE;
	}
	else
	{
		if (self.frame == TE_WIZSPIKE)
		{
			if (random() < 0.2)
			{
				sound(self, CHAN_VOICE, "enforcer/idle1.wav", SPAWN_CRUCIFIED, ATTN_IDLE);
			}
		}
	}
	ai_walk(2.25);
};

void() boss2_run = 
{
	self.think = boss2_run;
	self.nextthink = time + 0.1;
	self.frame = self.frame + SPAWN_CRUCIFIED;
	if (self.frame > SVC_INTERMISSION || self.frame < SVC_TEMPENTITY)
	{
		self.frame = SVC_TEMPENTITY;
	}
	else
	{
		if (self.frame == SVC_TEMPENTITY)
		{
			if (random() < 0.2)
			{
				sound(self, CHAN_VOICE, "enforcer/idle1.wav", SPAWN_CRUCIFIED, ATTN_IDLE);
			}
		}
	}
	ai_run(12.125);
};

void() boss2_fire = 
{
	enforcer_bullet("weapons/spike2.wav", 1000, 15, "progs/s_spike.mdl");
};

void() boss2_nail = 
{
	self.think = boss2_nail;
	self.nextthink = time + 0.1;
	self.frame = self.frame + SPAWN_CRUCIFIED;
	if (self.frame > 38 || self.frame < SVC_FINALE)
	{
		self.frame = SVC_FINALE;
	}
	else
	{
		if (self.frame == 38)
		{
			boss2_run();
		}
		else
		{
			if (self.frame == 36)
			{
				boss2_fire();
			}
			else
			{
				if (self.frame == 37)
				{
					if (self.cnt <= AS_MELEE)
					{
						self.cnt = self.cnt + SPAWN_CRUCIFIED;
						self.frame = 35;
					}
					ai_face();
				}
				else
				{
					ai_face();
				}
			}
		}
	}
};

void() boss2_paina1 = [50, boss2_paina2]
{
};

void() boss2_paina2 = [51, boss2_paina3]
{
};

void() boss2_paina3 = [52, boss2_paina4]
{
};

void() boss2_paina4 = [53, boss2_run]
{
};

void() boss2_painc1 = [54, boss2_painc2]
{
	ai_back(TE_LAVASPLASH);
};

void() boss2_painc2 = [55, boss2_painc3]
{
	ai_back(20);
};

void() boss2_painc3 = [56, boss2_painc4]
{
	ai_back(TE_LAVASPLASH);
};

void() boss2_painc4 = [55, boss2_painc5]
{
};

void() boss2_painc5 = [54, boss2_run]
{
	ai_forward(TE_LIGHTNING1);
};

void(entity attacker, float damage) boss2_pain = 
{
	if (self.pain_finished > time)
	{
		return;
	}
	if (damage < random() * 60)
	{
		return;
	}
	if (random() < 0.5)
	{
		sound(self, CHAN_VOICE, "enforcer/pain1.wav", SPAWN_CRUCIFIED, ATTN_NORM);
	}
	else
	{
		sound(self, CHAN_VOICE, "enforcer/pain2.wav", SPAWN_CRUCIFIED, ATTN_NORM);
	}
	if (random() < 0.5)
	{
		self.pain_finished = time + SPAWN_CRUCIFIED;
		boss2_paina1();
	}
	else
	{
		self.pain_finished = time + SPAWN_CRUCIFIED;
		boss2_painc1();
	}
};

void() boss2_throwgun = 
{
	local entity item;
	item = spawn();
	item.origin = self.origin - '0 0 24';
	item.weapon = IT_SUPER_NAILGUN;
	item.ammo_nails = SVC_INTERMISSION;
	item.velocity_z = 300;
	item.velocity_x = -100 + random() * MAX_NAILS;
	item.velocity_y = -100 + random() * MAX_NAILS;
	item.flags = FL_ITEM;
	item.solid = SOLID_TRIGGER;
	item.movetype = MOVETYPE_TOSS;
	setmodel(item, "progs/g_nail2.mdl");
	setsize(item, '-16 -16 0', '16 16 56');
	item.touch = ItemTouch;
	item.noise = "weapons/pkup.wav";
	item.netname = "Perforator";
};

void() boss2_die1 = [39, boss2_die2]
{
};

void() boss2_die2 = [40, boss2_die3]
{
};

void() boss2_die3 = [41, boss2_die4]
{
	self.solid = SOLID_NOT;
	boss2_throwgun();
};

void() boss2_die4 = [42, boss2_die5]
{
};

void() boss2_die5 = [43, boss2_die6]
{
};

void() boss2_die6 = [44, boss2_die7]
{
};

void() boss2_die7 = [45, boss2_die8]
{
};

void() boss2_die8 = [46, boss2_die9]
{
};

void() boss2_die9 = [47, boss2_die10]
{
};

void() boss2_die10 = [48, boss2_die11]
{
};

void() boss2_die11 = [49, boss2_die11]
{
};

void() boss2_die = 
{
	if (self.health < -35)
	{
		sound(self, CHAN_VOICE, "player/udeath.wav", SPAWN_CRUCIFIED, ATTN_NORM);
		ThrowHead("progs/h_mega.mdl", self.health);
		ThrowGib("progs/gib1.mdl", self.health);
		ThrowGib("progs/gib2.mdl", self.health);
		ThrowGib("progs/gib3.mdl", self.health);
		ThrowGib("progs/gib3.mdl", self.health);
		ThrowGib("progs/gib1.mdl", self.health);
		boss2_throwgun();
		return;
	}
	sound(self, CHAN_VOICE, "enforcer/death1.wav", SPAWN_CRUCIFIED, ATTN_NORM);
	boss2_die1();
};

void() monster_boss2 = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model2("progs/enforce2.mdl");
	precache_model2("progs/h_mega.mdl");
	precache_model2("progs/g_nail2.mdl");
	precache_sound2("enforcer/death1.wav");
	precache_sound2("enforcer/idle1.wav");
	precache_sound2("enforcer/pain1.wav");
	precache_sound2("enforcer/pain2.wav");
	precache_sound2("enforcer/sight1.wav");
	precache_sound2("enforcer/sight2.wav");
	precache_sound2("enforcer/sight3.wav");
	precache_sound2("enforcer/sight4.wav");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/enforce2.mdl");
	setsize(self, VEC_HULL_MIN, '16 16 40');
	self.health = 150;
	self.armorvalue = 1000;
	self.armortype = 0.8;
	self.th_stand = boss2_stand;
	self.th_walk = boss2_walk;
	self.th_run = boss2_run;
	self.th_pain = boss2_pain;
	self.th_die = boss2_die;
	self.th_missile = boss2_nail;
	walkmonster_start();
};


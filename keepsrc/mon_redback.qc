void() redback_stand1 = [7, redback_stand2] {ai_stand();};
void() redback_stand2 = [8, redback_stand3] {ai_stand();};
void() redback_stand3 = [9, redback_stand4] {ai_stand();};
void() redback_stand4 = [10, redback_stand5] {ai_stand();};
void() redback_stand5 = [9, redback_stand6] {ai_stand();};
void() redback_stand6 = [8, redback_stand1] {ai_stand();};

void() redback_run1 = [0, redback_run2{
	if (random() < 0.15) {
		sound(self, CHAN_VOICE, "weapons/ax1.wav", 1, ATTN_IDLE); // vanilla sound
		if (self.flags & FL_ONGROUND) {
			traceline(self.origin, self.origin + v_forward * MAX_CHARMER_DISTANCE + '0 0 -250', 1, self);
			if (!trace_inwater) {
				self.flags = self.flags - (self.flags & FL_ONGROUND);
				makevectors(self.angles);
				self.velocity = self.velocity + v_forward * (MIN_CHARMER_DISTANCE + random() * 300);
				self.velocity_z = 300 + random() * 500;
			}
		}
	}
	if (random() < 0.1) {
		sound(self, CHAN_VOICE, "wizard/widle1.wav", 1, ATTN_IDLE);
	} else {
		if (random() < 0.1) sound(self, CHAN_VOICE, "wizard/widle2.wav", 1, ATTN_IDLE);
	}
	ai_run(MOVETYPE_BOUNCEMISSILE);
};
void() redback_run2 = [1, redback_run3] {ai_run(13);};
void() redback_run3 = [2, redback_run4] {ai_run(TE_EXPLOSION2);};
void() redback_run4 = [3, redback_run5] {ai_run(13);};
void() redback_run5 = [4, redback_run6] {ai_run(TE_EXPLOSION2);};
void() redback_run6 = [5, redback_run7]
{
	ai_run(13);
};

void() redback_run7 = [6, redback_run1]
{
	ai_run(TE_EXPLOSION2);
};

void() redback_atk1 = [11, redback_atk2]
{
	ai_face();
};

void() redback_atk2 = [12, redback_atk3]
{
	ai_face();
};

void() redback_atk3 = [13, redback_atk4]
{
	ai_face();
};

void() redback_atk4 = [12, redback_run1]
{
	ai_face();
	self.attack_finished = time + (1.8 - skill / FL_SWIM);
};

void() redback_pain1 = [7, redback_pain2]
{
};

void() redback_pain2 = [8, redback_pain3]
{
};

void() redback_pain3 = [9, redback_pain4]
{
};

void() redback_pain4 = [10, redback_pain5]
{
};

void() redback_pain5 = [9, redback_pain6]
{
};

void() redback_pain6 = [8, redback_run1]
{
	ai_pain(1);
};

void(entity attacker, float damage) redback_pain = 
{
	local float r;
	if (self.pain_finished > time)
	{
		return;
	}
	r = random();
	if (r < 0.5)
	{
		self.pain_finished = time + 0.6;
		redback_pain1();
		sound(self, CHAN_VOICE, "wizard/wsight.wav", 1, ATTN_NORM);
	}
};

void() redback_fire1 = 
{
	ai_face();
	sound(self, CHAN_WEAPON, "wizard/wsight.wav", 1, ATTN_NORM);
	hknight_shot(CONTENT_EMPTY);
	hknight_shot(1);
};

void() redback_fire2 = 
{
	local vector org;
	ai_face();
	if (random() > 0.5)
	{
		sound(self, CHAN_WEAPON, "demon/dhit2.wav", 1, ATTN_NORM);
	}
	else
	{
		sound(self, CHAN_WEAPON, "shambler/smack.wav", 1, ATTN_NORM);
	}
	SpawnBlood(self.enemy.origin, VEC_ORIGIN, 40);
	T_Damage(self.enemy, self, self, MOVETYPE_BOUNCE + random() * 20);
	redback_atk1();
};

void() redback_fire = 
{
	local float dist;
	if (self.attack_finished > time)
	{
		return;
	}
	self.attack_finished = time + (MOVETYPE_FLY - skill);
	if (vlen(self.origin - self.enemy.origin) > 110)
	{
		redback_fire1();
	}
	else
	{
		redback_fire2();
	}
	redback_atk1();
};

void() redback_die1 = [11, redback_die2]
{
	self.angles_x = self.angles_x + 60;
};

void() redback_die2 = [11, redback_die3]
{
	self.angles_x = self.angles_x + 60;
};

void() redback_die3 = [11, redback_die4]
{
	self.solid = SOLID_NOT;
	self.ammo_shells = MOVETYPE_FLY;
	DropBackpack();
	self.angles_x = self.angles_x + 45;
};

void() redback_die4 = [11, redback_die4]
{
};

void() redback_die = 
{
	if (self.health < -35)
	{
		sound(self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		ThrowGib("progs/zom_gib.mdl", self.health);
		ThrowGib("progs/zom_gib.mdl", self.health);
		ThrowGib("progs/gib3.mdl", self.health);
		ThrowGib("progs/zom_gib.mdl", self.health * FL_SWIM);
		remove(self);
		return;
	}
	sound(self, CHAN_VOICE, "shalrath/pain.wav", 1, ATTN_NORM);
	redback_die1();
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	self.velocity_z = 250 + random() * MAX_CHARMER_DISTANCE;
	setsize(self, '-16 -16 -5', '16 16 5');
};

void() monster_redback = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model("progs/redback.mdl");
	precache_model("progs/zom_gib.mdl");
	precache_model("progs/gib3.mdl");
	precache_model2("progs/k_spike.mdl");
	precache_sound2("hknight/attack1.wav");
	precache_sound("demon/dhit2.wav");
	precache_sound("wizard/wsight.wav");
	precache_sound("shambler/smack.wav");
	precache_sound("shalrath/pain.wav");
	precache_sound("wizard/wsight.wav");
	precache_sound("wizard/widle1.wav");
	precache_sound("wizard/widle2.wav");
	precache_sound("player/udeath.wav");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	self.classname = "monster_redback";
	setmodel(self, "progs/redback.mdl");
	setsize(self, '-16 -16 -22', '16 16 10');
	self.health = 40 + skill * 20;
	self.th_stand = redback_stand1;
	self.th_run = redback_run1;
	self.th_walk = SUB_Null;
	self.th_missile = redback_fire;
	self.th_pain = redback_pain;
	self.th_die = redback_die;
	walkmonster_start();
};


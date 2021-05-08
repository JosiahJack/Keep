/*
=============
SKULLWIZARD
=============
*/

//in quakeme, to get the number of the frame, take 1 off the number displayed, ie frame 1 in qme is actually frame 0.
//remember we only want every other frame, cos quake has shittier animation than hexen2.

//standing, frames 106 to 124

void() skullwiz_stand1 = [106, skullwiz_stand2] {ai_stand();};
void() skullwiz_stand2 = [108, skullwiz_stand3] {ai_stand();};
void() skullwiz_stand3 = [110, skullwiz_stand4] {ai_stand();};
void() skullwiz_stand4 = [112, skullwiz_stand5] {ai_stand();};
void() skullwiz_stand5 = [114, skullwiz_stand6] {ai_stand();};
void() skullwiz_stand6 = [116, skullwiz_stand7] {ai_stand();};
void() skullwiz_stand7 = [118, skullwiz_stand8] {ai_stand();};
void() skullwiz_stand8 = [120, skullwiz_stand9] {ai_stand();};
void() skullwiz_stand9 = [122, skullwiz_stand10] {ai_stand();};
void() skullwiz_stand10 = [124, skullwiz_stand1] {ai_stand();};

//walking, frames 125 to 148

void() skullwiz_walk1 = [125, skullwiz_walk2] 
{
	ai_walk(3);

	if (random() < 0.2)
		sound (self, CHAN_VOICE, "skullwiz/idle.wav", 1,  ATTN_IDLE);
};
void() skullwiz_walk2 = [127, skullwiz_walk3] {ai_walk(3);};
void() skullwiz_walk3 = [129, skullwiz_walk4] {ai_walk(3);};
void() skullwiz_walk4 = [131, skullwiz_walk5] {ai_walk(3);};
void() skullwiz_walk5 = [133, skullwiz_walk6] {ai_walk(3);};
void() skullwiz_walk6 = [135, skullwiz_walk7] {ai_walk(3);};
void() skullwiz_walk7 = [137, skullwiz_walk8] {ai_walk(3);};
void() skullwiz_walk8 = [139, skullwiz_walk9] {ai_walk(3);};
void() skullwiz_walk9 = [141, skullwiz_walk10] {ai_walk(3);};
void() skullwiz_walk10 = [143, skullwiz_walk11] {ai_walk(3);};
void() skullwiz_walk11 = [145, skullwiz_walk12] {ai_walk(3);};
void() skullwiz_walk12 = [147, skullwiz_walk1] {ai_walk(3);};

//running, same frames as walking

void() skullwiz_run1 = [125, skullwiz_run2] {ai_run(3);};
void() skullwiz_run2 = [127, skullwiz_run3] {ai_run(3);};
void() skullwiz_run3 = [129, skullwiz_run4] {ai_run(3);};
void() skullwiz_run4 = [131, skullwiz_run5] {ai_run(3);};
void() skullwiz_run5 = [133, skullwiz_run6] {ai_run(3);};
void() skullwiz_run6 = [135, skullwiz_run7] {ai_run(3);};
void() skullwiz_run7 = [137, skullwiz_run8] {ai_run(3);};
void() skullwiz_run8 = [139, skullwiz_run9] {ai_run(3);};
void() skullwiz_run9 = [141, skullwiz_run10] {ai_run(3);};
void() skullwiz_run10 = [143, skullwiz_run11] {ai_run(3);};
void() skullwiz_run11 = [145, skullwiz_run12] {ai_run(3);};
void() skullwiz_run12 = [147, skullwiz_run1] {ai_run(3);};

//pain, frames 45 to 56

void() skullwiz_pain1 = [45, skullwiz_pain2] {};
void() skullwiz_pain2 = [47, skullwiz_pain3] {};
void() skullwiz_pain3 = [49, skullwiz_pain4] {};
void() skullwiz_pain4 = [51, skullwiz_pain5] {};
void() skullwiz_pain5 = [53, skullwiz_pain6] {};
void() skullwiz_pain6 = [55, skullwiz_run1] {};

void(entity attacker, float damage) skullwiz_pain =
{
	if (self.pain_finished > time)
		return;

	sound (self, CHAN_VOICE, "skullwiz/pain.wav", 1,  ATTN_NORM);
	
	skullwiz_pain1();
	self.pain_finished = time + 1;
};

//death, frames 0 to 14, no frames skipped

void() skullwiz_death1 = [0, skullwiz_death2] {};
void() skullwiz_death2 = [1, skullwiz_death3] {};
void() skullwiz_death3 = [2, skullwiz_death4] {};
void() skullwiz_death4 = [3, skullwiz_death5] {};
void() skullwiz_death5 = [4, skullwiz_death6] {};
void() skullwiz_death6 = [5, skullwiz_death7] {};
void() skullwiz_death7 = [6, skullwiz_death8] 
{self.solid = SOLID_NOT;};
void() skullwiz_death8 = [7, skullwiz_death9] {};
void() skullwiz_death9 = [8, skullwiz_death10] {};
void() skullwiz_death10 = [9, skullwiz_death11] {};
void() skullwiz_death11 = [10, skullwiz_death12] {};
void() skullwiz_death12 = [11, skullwiz_death13] {};
void() skullwiz_death13 = [12, skullwiz_death14] {};
void() skullwiz_death14 = [13, skullwiz_death15] {};
void() skullwiz_death15 = [14, skullwiz_death15] {};

void() skullwiz_die =
{
// check for gib
	if (self.health < -40)
	{
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		ThrowHead ("progs/h_skull.mdl", self.health);
		ThrowGib ("progs/gib1.mdl", self.health);
		ThrowGib ("progs/gib2.mdl", self.health);
		ThrowGib ("progs/gib3.mdl", self.health);
		return;
	}

// regular death
	sound (self, CHAN_VOICE, "skullwiz/death.wav", 1, ATTN_NORM);
	skullwiz_death1();
};

void() SkullwizMissile =
{
	local entity missile;

	self.effects = self.effects | EF_MUZZLEFLASH;

	missile = spawn();

	missile.owner = self;

	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;

	missile.velocity = normalize(self.enemy.origin - self.origin);
	missile.velocity = missile.velocity * 500;
	missile.angles = vectoangles(missile.velocity);
	missile.touch = T_MissileTouch;

	// set missile duration
	missile.nextthink = time + 10;
	missile.think = SUB_Remove;

	setmodel (missile, "progs/skulshot.mdl");
	setsize (missile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin (missile, self.origin);
};

//attack, frames 69 to 83

void() skullwiz_missile1 = [69, skullwiz_missile2] {ai_face();};
void() skullwiz_missile2 = [71, skullwiz_missile3] {ai_face();};
void() skullwiz_missile3 = [73, skullwiz_missile4] {ai_face();};
void() skullwiz_missile4 = [75, skullwiz_missile5] {ai_face();};
void() skullwiz_missile5 = [77, skullwiz_missile6] {ai_face();};
void() skullwiz_missile6 = [79, skullwiz_missile7] {ai_face();SkullwizMissile();};
void() skullwiz_missile7 = [80, skullwiz_missile8] {ai_face();};
void() skullwiz_missile8 = [81, skullwiz_missile9] {ai_face();};
void() skullwiz_missile9 = [83, skullwiz_run1] {ai_face();};

/*QUAKED monster_skullwizard (1 0 0) (-16 -16 -24) (16 16 40) Ambush
*/
void() monster_skullwizard =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model ("progs/skullwiz.mdl");
	precache_model ("progs/skulshot.mdl");
	precache_model ("progs/h_skull.mdl");

	precache_sound ("skullwiz/death.wav");
	precache_sound ("skullwiz/pain.wav");
	precache_sound ("skullwiz/idle.wav");
	precache_sound ("skullwiz/sight.wav");	

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/skullwiz.mdl");

	setsize (self, '-16 -16 -24', '16 16 40');
	self.health = 200;

	self.th_stand = skullwiz_stand1;
	self.th_walk = skullwiz_walk1;
	self.th_run = skullwiz_run1;
	self.th_missile = skullwiz_missile1;
	self.th_melee = skullwiz_missile1;
	self.th_pain = skullwiz_pain1;
	self.th_die = skullwiz_die;
	
	walkmonster_start ();
};


	






	




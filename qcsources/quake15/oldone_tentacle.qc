/*
==============================================================================

oldone

==============================================================================
*/
$cd id1/models/oldone
$origin 0 0 24
$base base
$skin skin

$frame idle1 idle2 idle3 idle4 idle5 idle6 

$frame attack1 attack2 attack3 attack4 attack5 attack6 attack7 attack8 attack9 attack10 attack11 attack12 attack13
$frame attack14 attack15 attack16 attack17 attack18 attack19 attack20 attack21

$frame death1 death2 death3 death4 death5 death6 death7 death8 death9 death10 death11 death12 death13
$frame death14 death15 death16 death17




/*
================
oldone_bite

================
*/
void() oldone_atta1;

void() oldone_stand1	=[	$idle1, 	oldone_stand2	] {ai_stand();};
void() oldone_stand2	=[	$idle2, 	oldone_stand3	] {ai_stand();};
void() oldone_stand3	=[	$idle3, 	oldone_stand4	] {ai_stand();};
void() oldone_stand4	=[	$idle4, 	oldone_stand5	] {ai_stand();};
void() oldone_stand5	=[	$idle5, 	oldone_stand6	] {ai_stand();};
void() oldone_stand6	=[	$idle6, 	oldone_stand1	] {ai_stand();};

void() oldone_aim1	=[	$idle1, 	oldone_aim2	] { if (random() < 0.4) oldone_atta1();};
void() oldone_aim2	=[	$idle2, 	oldone_aim3	] {};
void() oldone_aim3	=[	$idle3, 	oldone_aim4	] {};
void() oldone_aim4	=[	$idle4, 	oldone_aim5	] {};
void() oldone_aim5	=[	$idle5, 	oldone_aim6	] {};
void() oldone_aim6	=[	$idle6, 	oldone_aim1	] {};

void() groundSmash =
{

	local	entity contact, shake;
	
	shake = spawn();
	setorigin(shake, self.origin + '0 0 15');
	shake.think = screenshake;
	shake.attack_finished = time + .3;
	shake.nextthink = time + 0.2;
	
	sound (self, CHAN_AUTO, "shambler/fall.wav", 1, ATTN_NORM);
	
	T_RadiusDamage (self, self.owner, 50, self.owner);
	remove(self);
	//pointparticles(particleeffectnum("rocket_explo_classic"), contact.origin, '0 0 0', 1);
	
};

void(vector org, vector vec) oldone_attack =
{
//	local	vector	vec;
	

	vec = normalize(vec);
	
	newmis = spawn();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLY;
	newmis.solid = SOLID_BBOX;
	/*
	newmis.effects = EF_DIMLIGHT;
	*/
		

	setorigin (newmis, org);

	newmis.velocity = vec * 3600;
	newmis.angles = vectoangles(newmis.velocity);
	
	newmis.velocity_z = 0;

	newmis.nextthink = time + .05;
	newmis.think = groundSmash;
	newmis.touch = groundSmash;
};

void() oldone_atta1	=[	$attack1,	oldone_atta2	] {ai_face();};
void() oldone_atta2	=[	$attack2,	oldone_atta3	] {ai_face();};
void() oldone_atta3	=[	$attack3,	oldone_atta4	] {ai_face();};
void() oldone_atta4	=[	$attack4,	oldone_atta5	] {ai_face();
//sound (self, CHAN_VOICE, "oldone/dattack1.wav", 1, ATTN_NORM);
};
void() oldone_atta5	=[	$attack5,	oldone_atta6	] {ai_face();};
void() oldone_atta6	=[	$attack6,	oldone_atta7	] {ai_face();};
void() oldone_atta7	=[	$attack7,	oldone_atta8	] {ai_face();};
void() oldone_atta8	=[	$attack8,	oldone_atta9	] {ai_face();};
void() oldone_atta9	=[	$attack9,	oldone_atta10	] {ai_face();};
void() oldone_atta10	=[	$attack10,	oldone_atta11	] {ai_face();};
void() oldone_atta11	=[	$attack11,	oldone_atta12	] {ai_face();};
void() oldone_atta12	=[	$attack12,	oldone_atta13	] {ai_face();};
void() oldone_atta13	=[	$attack13,	oldone_atta14	] {ai_face();};
void() oldone_atta14	=[	$attack14,	oldone_atta15	] {ai_face();};
void() oldone_atta15	=[	$attack15,	oldone_atta16	] {self.solid = SOLID_NOT;};
void() oldone_atta16	=[	$attack16,	oldone_atta17	] {oldone_attack(self.origin, self.enemy.origin - self.origin);};
void() oldone_atta17	=[	$attack17,	oldone_atta18	] {};
void() oldone_atta18	=[	$attack18,	oldone_atta19	] {ai_face();};
void() oldone_atta19	=[	$attack19,	oldone_atta20	] {ai_face();};
void() oldone_atta20	=[	$attack20,	oldone_atta21	] {ai_face();self.solid = SOLID_BBOX;};
void() oldone_atta21	=[	$attack21,	oldone_aim1	] {ai_face();};

void() oldone_die1		=[	$death1,	oldone_die2	] {};
void() oldone_die2		=[	$death2,	oldone_die3	] {};
void() oldone_die3		=[	$death3,	oldone_die4	] {};
void() oldone_die4		=[	$death4,	oldone_die5	] {};
void() oldone_die5		=[	$death5,	oldone_die6	] {};
void() oldone_die6		=[	$death6,	oldone_die7	] {};
void() oldone_die7		=[	$death7,	oldone_die8	] {};
void() oldone_die8		=[	$death8,	oldone_die9	] {};
void() oldone_die9		=[	$death9,	oldone_die10	] {};
void() oldone_die10		=[	$death10,	oldone_die11	] {};
void() oldone_die11		=[	$death11,	oldone_die12	] {};
void() oldone_die12		=[	$death12,	oldone_die13	] {};
void() oldone_die13		=[	$death13,	oldone_die14	] {};
void() oldone_die14		=[	$death14,	oldone_die15	] {};
void() oldone_die15		=[	$death15,	oldone_die16	] {};
void() oldone_die16		=[	$death16,	oldone_die17	] {};
void() oldone_die17		=[	$death17,	oldone_die17	] {};

void() oldone_pain =
{
	sound (self, CHAN_VOICE, "boss1/pain.wav", 1, ATTN_NORM);
	//oldone_atta1();
};

void() oldone_die =
{
// check for gib
	if (self.health < -135)
	{
		play_gibsound();
		ThrowGib ("progs/gib3.mdl", self.health);
		ThrowGib ("progs/gib3.mdl", self.health);
		ThrowGib ("progs/gib3.mdl", self.health);
		ThrowGib ("progs/gib3.mdl", self.health);
		ThrowGib ("progs/gib3.mdl", self.health);
		return;
	}

// regular death
	sound (self, CHAN_VOICE, "boss1/death.wav", 1, ATTN_NORM);
	self.solid = SOLID_NOT;

	oldone_die1 ();
};


//============================================================================

/*
==============
CheckoldoneMelee

Returns TRUE if a melee attack would hit right now
==============
*/
float()	CheckoldoneMelee =
{
	if (enemy_range == RANGE_MELEE)
	{	// FIXME: check canreach
		self.attack_state = AS_MELEE;
		return TRUE;
	}
	return FALSE;
};


void() oldone_rise1		=[	$death17,	oldone_rise2	] {self.solid = SOLID_BBOX;};
void() oldone_rise2		=[	$death16,	oldone_rise3	] {};
void() oldone_rise3		=[	$death15,	oldone_rise4	] {};
void() oldone_rise4		=[	$death14,	oldone_rise5	] {};
void() oldone_rise5		=[	$death13,	oldone_rise6	] {};
void() oldone_rise6		=[	$death12,	oldone_aim1	] {walkmonster_start();};


void() oldone_hide =
{
	
	//oldone_rise1();
};
//===========================================================================

/*QUAKED monster_oldone (1 0 0) (-32 -32 -24) (32 32 40) Ambush

*/
void() monster_oldone_tentacle =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model ("progs/oldone_tent.mdl");

	precache_sound ("oldone/dattack1.wav");
	precache_sound ("boss1/pain.wav");
	precache_sound ("boss1/death.wav");

	self.solid = SOLID_BBOX;
	self.movetype = MOVETYPE_NONE;

	setmodel (self, "progs/oldone_tent.mdl");

	setsize (self, '-12 -12 -24', '12 12 60');
	self.health = 135;
	self.scale = 0.5;
	
	//self.th_walk = oldone_walk1;
	self.th_run = oldone_aim1;
	self.th_pain = oldone_pain;
	self.th_die = oldone_die;
	self.th_melee = oldone_atta1;
	//self.th_missile = oldone_atta1;

	
	if (!self.targetname)
	{
		self.th_stand = oldone_stand1;
		walkmonster_start();
	}
	else
	{
		self.solid = SOLID_NOT;
		self.th_stand = oldone_stand1;
		self.frame = $death17;
		self.use = oldone_rise1;
	}
	
};

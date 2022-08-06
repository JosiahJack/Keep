$cd /raid/quake/id1/models/ckbow
$origin 0 0 24
$base base
$skin badass3

$frame standb1 standb2 standb3 standb4 standb5 standb6 standb7 standb8 standb9
$frame standb10

$frame walkc1 walkc2 walkc3 walkc4 walkc5 walkc6 walkc7 walkc8 walkc9 walkc10
$frame walkc11 walkc12 walkc13 walkc14

$frame runc1 runc2 runc3 runc4 runc5 runc6 runc7 runc8 runc9

$frame painc1 painc2 painc3 painc4 painc5 painc6 painc7 painc8 

$frame paind1 paind2 paind3 paind4 paind5 paind6 paind7 paind8 paind9
$frame paind10 paind11 paind12 paind13 paind14 paind15 

$frame shoot1 shoot2 shoot3 shoot4 shoot5 shoot6 shoot7 shoot8 shoot9

$frame deathc1 deathc2 deathc3 deathc4 deathc5 deathc6 deathc7 deathc8 deathc9
$frame deathc10 deathc11 deathc12 deathc13 deathc14 deathc15 deathc16 deathc17 
$frame deathc18

$frame deathd1 deathd2 deathd3 deathd4 deathd5 deathd6 deathd7 deathd8 deathd9
$frame deathd10 deathd11 deathd12 deathd13 deathd14 deathd15 deathd16 deathd17 
$frame deathd18 deathd19

void() ckbow_Touch =
{
	local vector org;
	
	if (other == self.owner)
		return;		// don't explode on owner

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	
	sound (self, CHAN_WEAPON, "weapons/cbow.wav", 1, ATTN_STATIC);
	org = self.origin - 8*normalize(self.velocity);

	if (other.health)
	{
		SpawnBlood (org, self.velocity*0.2, 15);
		T_Damage (other, self, self.owner, 15);
	}
	else
	{
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_GUNSHOT);
		WriteCoord (MSG_BROADCAST, org_x);
		WriteCoord (MSG_BROADCAST, org_y);
		WriteCoord (MSG_BROADCAST, org_z);
	}
	
	remove(self);	
};

void(vector org, vector vec) Launchckbow =
{
//	local	vector	vec;
		
	if (self.classname == "monster_knight2")
		sound (self, CHAN_WEAPON, "weapons/pling.wav", 1, ATTN_NORM);

	vec = normalize(vec);
	
	newmis = spawn();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLY;
	newmis.solid = SOLID_BBOX;
	newmis.effects = EF_DIMLIGHT;

	setmodel (newmis, "progs/arrow.mdl");
	setsize (newmis, '0 0 0', '0 0 0');		

	setorigin (newmis, org);

	newmis.velocity = vec * 600;
	newmis.angles = vectoangles(newmis.velocity);

	newmis.nextthink = time + 5;
	newmis.think = SUB_Remove;
	newmis.touch = ckbow_Touch;
};

void() ckbow_fire =
{
	local vector org;

	self.effects = self.effects | EF_MUZZLEFLASH;
	makevectors (self.angles);
	
	org = self.origin + v_forward * 30 + v_right * 4.5 + '0 0 16';

	Launchckbow(org, self.enemy.origin - self.origin);
};

void()	ckbow_stand1	=[	$standb1,	ckbow_stand2	] {ai_stand();};
void()	ckbow_stand2	=[	$standb2,	ckbow_stand3	] {ai_stand();};
void()	ckbow_stand3	=[	$standb3,	ckbow_stand4	] {ai_stand();};
void()	ckbow_stand4	=[	$standb4,	ckbow_stand5	] {ai_stand();};
void()	ckbow_stand5	=[	$standb5,	ckbow_stand6	] {ai_stand();};
void()	ckbow_stand6	=[	$standb6,	ckbow_stand7	] {ai_stand();};
void()	ckbow_stand7	=[	$standb7,	ckbow_stand8	] {ai_stand();};
void()	ckbow_stand8	=[	$standb8,	ckbow_stand9	] {ai_stand();};
void()	ckbow_stand9	=[	$standb9,	ckbow_stand10	] {ai_stand();};
void()	ckbow_stand10	=[	$standb10,      ckbow_stand1	] {ai_stand();};

void()	ckbow_walk1	=[	$walkc1,	ckbow_walk2	] {
if (random() < 0.2)
	sound (self, CHAN_VOICE, "knight/idle.wav", 1,  ATTN_IDLE);
ai_walk(3);};
void()	ckbow_walk2	=[	$walkc2,        ckbow_walk3	] {ai_walk(2);};
void()	ckbow_walk3	=[	$walkc3,	ckbow_walk4	] {ai_walk(3);};
void()	ckbow_walk4	=[	$walkc4,	ckbow_walk5	] {ai_walk(4);};
void()	ckbow_walk5	=[	$walkc5,	ckbow_walk6	] {ai_walk(3);};
void()	ckbow_walk6	=[	$walkc6,	ckbow_walk7	] {ai_walk(3);};
void()	ckbow_walk7	=[	$walkc7,	ckbow_walk8	] {ai_walk(3);};
void()	ckbow_walk8	=[	$walkc8,	ckbow_walk9	] {ai_walk(4);};
void()	ckbow_walk9	=[	$walkc9,	ckbow_walk10	] {ai_walk(3);};
void()	ckbow_walk10	=[	$walkc10,       ckbow_walk11	] {ai_walk(3);};
void()	ckbow_walk11	=[	$walkc11,       ckbow_walk12	] {ai_walk(2);};
void()	ckbow_walk12	=[	$walkc12,       ckbow_walk13	] {ai_walk(3);};
void()	ckbow_walk13	=[	$walkc13,       ckbow_walk14	] {ai_walk(4);};
void()	ckbow_walk14	=[	$walkc14,       ckbow_walk1	] {ai_walk(3);};

void()	ckbow_run1	=[	$runc1,		ckbow_run2	] {
if (random() < 0.2)
	sound (self, CHAN_VOICE, "knight/idle.wav", 1,  ATTN_IDLE);
ai_run(16);};
void()	ckbow_run2	=[	$runc2,		ckbow_run3	] {ai_run(20);};
void()	ckbow_run3	=[	$runc3,		ckbow_run4	] {ai_run(13);};
void()	ckbow_run4	=[	$runc4,		ckbow_run5	] {ai_run(7);};
void()	ckbow_run5	=[	$runc5,		ckbow_run6	] {ai_run(16);};
void()	ckbow_run6	=[	$runc6,		ckbow_run7	] {ai_run(20);};
void()	ckbow_run7	=[	$runc7,		ckbow_run8	] {ai_run(14);};
void()	ckbow_run8	=[	$runc8,		ckbow_run9	] {ai_run(6);};
void()	ckbow_run9	=[	$runc9,		ckbow_run1	] {ai_run(6);};

void()	ckbow_painc1	=[	$painc1,	ckbow_painc2	] {ai_painforward(0);};
void()	ckbow_painc2	=[	$painc2,	ckbow_painc3	] {ai_painforward(3);};
void()	ckbow_painc3	=[	$painc3,	ckbow_painc4	] {};
void()	ckbow_painc4	=[	$painc4,	ckbow_painc5	] {};
void()	ckbow_painc5	=[	$painc5,	ckbow_painc6	] {ai_painforward(2);};
void()	ckbow_painc6	=[	$painc6,	ckbow_painc7	] {ai_painforward(4);};
void()	ckbow_painc7	=[	$painc7,	ckbow_painc8	] {ai_painforward(2);};
void()	ckbow_painc8	=[	$painc8,	ckbow_run1	] {};

void()	ckbow_paind1	=[	$paind1,	ckbow_paind2	] {ai_painforward(0);};
void()	ckbow_paind2	=[	$paind2,	ckbow_paind3	] {ai_painforward(3);};
void()	ckbow_paind3	=[	$paind3,	ckbow_paind4	] {};
void()	ckbow_paind4	=[	$paind4,	ckbow_paind5	] {};
void()	ckbow_paind5	=[	$paind5,	ckbow_paind6	] {ai_painforward(2);};
void()	ckbow_paind6	=[	$paind6,	ckbow_paind7	] {ai_painforward(4);};
void()	ckbow_paind7	=[	$paind7,	ckbow_paind8	] {ai_painforward(2);};
void()	ckbow_paind8	=[	$paind8,	ckbow_paind9	] {ai_painforward(5);};
void()	ckbow_paind9	=[	$paind9,	ckbow_paind10	] {ai_painforward(5);};
void()	ckbow_paind10	=[	$paind10,	ckbow_paind11	] {ai_painforward(0);};
void()	ckbow_paind11	=[	$paind11,	ckbow_paind12	] {};
void()	ckbow_paind12	=[	$paind12,	ckbow_paind13	] {ai_painforward(4);};
void()	ckbow_paind13	=[	$paind13,	ckbow_paind14	] {ai_painforward(2);};
void()	ckbow_paind14	=[	$paind14,	ckbow_paind15	] {ai_painforward(5);};
void()	ckbow_paind15	=[	$paind15,	ckbow_run1	] {};

void(entity attacker, float damage)	ckbow_pain =
{
	local float r;

	if (self.pain_finished > time)
		return;
	r = random();

	sound (self, CHAN_VOICE, "knight/khurt.wav", 1, ATTN_NORM);
	if (r < 0.5)
	{
		ckbow_painc1 ();
		self.pain_finished = time + 2;
	}
	else
	{
		ckbow_paind1 ();
		self.pain_finished = time + 2;
	}
};

void() ckbow_shoot1   =[      $shoot1,                ckbow_shoot2  ] {ai_face();};
void() ckbow_shoot2   =[      $shoot2,                ckbow_shoot3  ] {ai_face();};
void() ckbow_shoot3   =[      $shoot3,                ckbow_shoot4  ] {ai_face();};
void() ckbow_shoot4   =[      $shoot4,                ckbow_shoot5  ] {ai_face();};
void() ckbow_shoot5   =[      $shoot5,                ckbow_shoot6  ] {ai_face();};
void() ckbow_shoot6   =[      $shoot6,                ckbow_shoot7  ] {ai_face();};
void() ckbow_shoot7   =[      $shoot7,                ckbow_shoot8  ] {ai_face();};
void() ckbow_shoot8   =[      $shoot8,                ckbow_shoot9  ] {ckbow_fire();};
void() ckbow_shoot9   =[      $shoot9,                ckbow_run1    ] {};

void()	ckbow_dieb1	=[	$deathc1,	ckbow_dieb2	] {};
void()	ckbow_dieb2	=[	$deathc2,	ckbow_dieb3	] {};
void()	ckbow_dieb3	=[	$deathc3,	ckbow_dieb4	] 	
{self.solid = SOLID_NOT;};
void()	ckbow_dieb4	=[	$deathc4,	ckbow_dieb5	] {};
void()	ckbow_dieb5	=[	$deathc5,	ckbow_dieb6	] {};
void()	ckbow_dieb6	=[	$deathc6,	ckbow_dieb7	] {};
void()	ckbow_dieb7	=[	$deathc7,	ckbow_dieb8	] {};
void()	ckbow_dieb8	=[	$deathc8,	ckbow_dieb9	] {};
void()	ckbow_dieb9	=[	$deathc9,	ckbow_dieb10    ] {};
void()	ckbow_dieb10    =[	$deathc10,	ckbow_dieb11    ] {};
void()	ckbow_dieb11    =[	$deathc11,	ckbow_dieb12    ] {};
void()	ckbow_dieb12    =[	$deathc12,      ckbow_dieb13	] {};
void()	ckbow_dieb13    =[	$deathc13,      ckbow_dieb14	] {};
void()	ckbow_dieb14    =[	$deathc14,      ckbow_dieb15	] {};
void()	ckbow_dieb15    =[	$deathc15,      ckbow_dieb16	] {};
void()	ckbow_dieb16    =[	$deathc16,      ckbow_dieb17    ] {};
void()	ckbow_dieb17    =[	$deathc17,	ckbow_dieb18    ] {};
void()	ckbow_dieb18    =[	$deathc18,	CorpseThink    ] {};

void()	ckbow_died1	=[	$deathd1,	ckbow_died2	] {};
void()	ckbow_died2	=[	$deathd2,	ckbow_died3	] {};
void()	ckbow_died3	=[	$deathd3,	ckbow_died4	] 	
{self.solid = SOLID_NOT;};
void()	ckbow_died4	=[	$deathd4,	ckbow_died5	] {};
void()	ckbow_died5	=[	$deathd5,	ckbow_died6	] {};
void()	ckbow_died6	=[	$deathd6,	ckbow_died7	] {};
void()	ckbow_died7	=[	$deathd7,	ckbow_died8	] {};
void()	ckbow_died8	=[	$deathd8,	ckbow_died9	] {};
void()	ckbow_died9	=[	$deathd9,	ckbow_died10    ] {};
void()	ckbow_died10    =[	$deathd10,	ckbow_died11    ] {};
void()	ckbow_died11    =[	$deathd11,	ckbow_died12    ] {};
void()	ckbow_died12    =[	$deathd12,      ckbow_died13	] {};
void()	ckbow_died13    =[	$deathd13,      ckbow_died14	] {};
void()	ckbow_died14    =[	$deathd14,      ckbow_died15	] {};
void()	ckbow_died15    =[	$deathd15,      ckbow_died16	] {};
void()	ckbow_died16    =[	$deathd16,      ckbow_died17    ] {};
void()	ckbow_died17    =[	$deathd17,	ckbow_died18    ] {};
void()	ckbow_died18    =[	$deathd18,	ckbow_died19    ] {};
void()	ckbow_died19    =[	$deathd19,	CorpseThink    ] {};

void() ckbow_die =
{
// check for gib
	if (self.health < -40)
	{
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		ThrowHead ("progs/h_knight.mdl", self.health);
		ThrowGib ("progs/gib1.mdl", self.health);
		ThrowGib ("progs/gib2.mdl", self.health);
		ThrowGib ("progs/gib3.mdl", self.health);
		return;
	}

// regular death
	sound (self, CHAN_VOICE, "knight/kdeath.wav", 1, ATTN_NORM);
	if (random() < 0.5)
 		ckbow_dieb1 ();
        else
                ckbow_died1 ();
};

/*QUAKED monster_knight2 (1 0 0) (-16 -16 -24) (16 16 40) Ambush
*/
void() monster_knight2 =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model ("progs/knight2.mdl");
	precache_model ("progs/h_knight.mdl");
	precache_model ("progs/arrow.mdl");

	precache_sound ("knight/kdeath.wav");
	precache_sound ("knight/khurt.wav");
	precache_sound ("knight/ksight.wav");
	precache_sound ("knight/sword1.wav");
	precache_sound ("knight/sword2.wav");
	precache_sound ("knight/idle.wav");
	precache_sound ("weapons/pling.wav");
	precache_sound ("weapons/cbow.wav");
	precache_sound ("player/udeath.wav");

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/knight2.mdl");

	setsize (self, '-16 -16 -24', '16 16 40');
	self.health = 120;

	self.th_stand = ckbow_stand1;
	self.th_walk = ckbow_walk1;
	self.th_run = ckbow_run1;
        self.th_missile = ckbow_shoot1;
	self.th_pain = ckbow_pain;
	self.th_die = ckbow_die;
	
	walkmonster_start ();
};

/*
==============================================================================

SOLDIER / PLAYER

==============================================================================
*/



void() ArcherLaser_Touch =
{
	local vector org;

	if (other == self.owner)
		return;		// don't explode on owner

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

//MED 01/16/97 added silent command

   if (!(self.spawnflags & SPAWNFLAG_SILENT))
      sound (self, CHAN_WEAPON, "enforcer/enfstop.wav", 1, ATTN_STATIC);
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

void(vector org, vector vec) LaunchArcherLaser =
{
	//local	vector	vec;

	sound (self, CHAN_WEAPON, "enforcer/enfire.wav", 1, ATTN_NORM);

	vec = normalize(vec);

	newmis = spawn();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLY;
	newmis.solid = SOLID_BBOX;
	newmis.effects = EF_DIMLIGHT;

	setmodel (newmis, "progs/laser.mdl");
	setsize (newmis, '0 0 0', '0 0 0');

	setorigin (newmis, org);

	newmis.velocity = vec * 600;
	newmis.angles = vectoangles(newmis.velocity);

	newmis.nextthink = time + 5;
	newmis.think = SUB_Remove;
	newmis.touch = ArcherLaser_Touch;
};



void() archer_fire =
{
	local vector org;

	self.effects = self.effects | EF_MUZZLEFLASH;
	makevectors (self.angles);

	org = self.origin + v_forward * 30 + v_right * 8.5 + '0 0 16';

	LaunchArcherLaser(org, self.enemy.origin - self.origin);
};

//============================================================================

void()	archer_stand1	=[	159,	archer_stand2	] {ai_stand();};
void()	archer_stand2	=[	161,	archer_stand3	] {ai_stand();};
void()	archer_stand3	=[	163,	archer_stand4	] {ai_stand();};
void()	archer_stand4	=[	165,	archer_stand5	] {ai_stand();};
void()	archer_stand5	=[	167,	archer_stand6	] {ai_stand();};
void()	archer_stand6	=[	169,	archer_stand7	] {ai_stand();};
void()	archer_stand7	=[	171,	archer_stand8	] {ai_stand();};
void()	archer_stand8	=[	173,	archer_stand9	] {ai_stand();};
void()	archer_stand9	=[	175,	archer_stand1	] {ai_stand();};


void()	archer_walk1	=[	77 ,	archer_walk2	] {
if (random() < 0.2)
	sound (self, CHAN_VOICE, "enforcer/idle1.wav", 1, ATTN_IDLE);
ai_walk(2);};
void()	archer_walk2	=[	79 ,	archer_walk3	] {ai_walk(4);};
void()	archer_walk3	=[	81 ,	archer_walk4	] {ai_walk(4);};
void()	archer_walk4	=[	83 ,	archer_walk5	] {ai_walk(3);};
void()	archer_walk5	=[	85 ,	archer_walk6	] {ai_walk(1);};
void()	archer_walk6	=[	87 ,	archer_walk7	] {ai_walk(2);};
void()	archer_walk7	=[	89 ,	archer_walk8	] {ai_walk(2);};
void()	archer_walk8	=[	91 ,	archer_walk9	] {ai_walk(1);};
void()	archer_walk9	=[	93 ,	archer_walk10	] {ai_walk(2);};
void()	archer_walk10	=[	95,	archer_walk11	] {ai_walk(4);};
void()	archer_walk11	=[	97,	archer_walk1	] {ai_walk(4);};

void()	archer_run1	=[	189  ,	archer_run2	] {
if (random() < 0.2)
	sound (self, CHAN_VOICE, "enforcer/idle1.wav", 1, ATTN_IDLE);
ai_run(18);};
void()	archer_run2	=[	191  ,	archer_run3	] {ai_run(14);};
void()	archer_run3	=[	193  ,	archer_run4	] {ai_run(7);};
void()	archer_run4	=[	195  ,	archer_run5	] {ai_run(12);};
void()	archer_run5	=[	197  ,	archer_run6	] {ai_run(14);};
void()	archer_run6	=[	199  ,	archer_run7	] {ai_run(14);};
void()	archer_run7	=[	201  ,	archer_run8	] {ai_run(7);};
void()	archer_run8	=[	203  ,	archer_run1	] {ai_run(11);};

// "draw" start
void()	archer_atk1	=[	30,	archer_atk2	] {ai_face();};
void()	archer_atk2	=[	32,	archer_atk3	] {ai_face();};
void()	archer_atk3	=[	34,	archer_atk4	] {ai_face();};
void()	archer_atk4	=[	36,	archer_atk5	] {ai_face();};
void()	archer_atk5	=[	38,	archer_atk6	] {ai_face();};
void()	archer_atk6	=[	40,	archer_atk7	] {ai_face();};
void()	archer_atk7	=[	42,	archer_atk8	] {ai_face();};
// "draw end"
// "fire" start - note uses all frames currently
void()	archer_atk8	=[	57,	archer_atk9	] {ai_face();};
void()	archer_atk9	=[	58,	archer_atk10	] {archer_fire();};
void()	archer_atk10	=[	59,	archer_atk11	] {ai_face();};
void()	archer_atk11	=[	60,	archer_atk12	] {ai_face();};
// "fire" end
// "TranB" start
void()	archer_atk12	=[	124,	archer_atk13	] {ai_face();};
void()	archer_atk13	=[	126,	archer_atk14	] {ai_face();};
void()	archer_atk14	=[	128,	archer_atk15	] {ai_face();};
void()	archer_atk15	=[	130,	archer_atk16	] {ai_face();};
void()	archer_atk16	=[	132,	archer_atk17	] {ai_face();};
void()	archer_atk17	=[	134,	archer_atk18	] {ai_face();};
void()	archer_atk18	=[	136,	archer_atk19	] {ai_face();};
void()	archer_atk19	=[	138,	archer_run1	] {ai_face();
SUB_CheckRefire (archer_atk1);
};


void()	archer_pain1	=[	61,	archer_pain2	] {};
void()	archer_pain2	=[	63,	archer_pain3	] {};
void()	archer_pain3	=[	65,	archer_pain4	] {};
void()	archer_pain4	=[	67,	archer_pain5	] {};
void()	archer_pain5	=[	69,	archer_pain6	] {};
void()	archer_pain6	=[	71,	archer_pain7	] {};
void()	archer_pain7	=[	73,	archer_pain8	] {};
void()	archer_pain8	=[	75,	archer_run1	] {};

void(entity attacker, float damage)	archer_pain =
{
	local float r;

	if (self.pain_finished > time)
	if (NotAGoonSlapper(attacker))
		return;

	r = random();

	if (r < 0.5)
		sound (self, CHAN_VOICE, "enforcer/pain1.wav", 1, ATTN_NORM);
	else
		sound (self, CHAN_VOICE, "enforcer/pain2.wav", 1, ATTN_NORM);
		
	self.pain_finished = time + 1;
	archer_pain1();	
};

//============================================================================




void()  archer_die1 	=[ 	8, 	archer_die2 	] {};
void()	archer_die2	=[	10,	archer_die3	] {};
void()	archer_die3	=[	12,	archer_die4	] {self.solid = SOLID_NOT;self.ammo_cells = 5;DropBackpack();};
void()	archer_die4	=[	14,	archer_die5	] {ai_forward(14);};
void()	archer_die5	=[	16,	archer_die6	] {ai_forward(2);};
void()	archer_die6	=[	18,	archer_die7	] {};
void()	archer_die7	=[	20,	archer_die8	] {};
void()	archer_die8	=[	22,	archer_die9	] {};
void()	archer_die9	=[	24,	archer_die10	] {BDW_BodyDropSound();ai_forward(3);};
void()	archer_die10	=[	26,	archer_die11	] {ai_forward(5);};
void()	archer_die11	=[	28,	archer_die12	] {ai_forward(5);};
void()	archer_die12	=[	29,	BDW_CorpseRemove] {ai_forward(5);};	//use last frame, no need to skip it

void() archer_die =
{
// check for gib
	if (self.health < -35)
	{
		self.skin = 0;
		MonsterGibMedium("progs/h_mega.mdl");
		return;
	}

// regular death
	sound (self, CHAN_VOICE, "enforcer/death1.wav", 1, ATTN_NORM);
   	archer_die1();
};


/*QUAKED monster_enforcer (1 0 0) (-16 -16 -24) (16 16 40) Ambush

*/

void() monster_super_grunt;

void() monster_archer =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model ("progs/archtest.mdl");
	precache_model2 ("progs/h_mega.mdl");
	precache_model2 ("progs/laser.mdl");

	precache_sound2 ("enforcer/death1.wav");
	precache_sound2 ("enforcer/enfire.wav");
	precache_sound2 ("enforcer/enfstop.wav");
	precache_sound2 ("enforcer/idle1.wav");
	precache_sound2 ("enforcer/pain1.wav");
	precache_sound2 ("enforcer/pain2.wav");
	precache_sound2 ("enforcer/sight1.wav");
	precache_sound2 ("enforcer/sight2.wav");
	precache_sound2 ("enforcer/sight3.wav");
	precache_sound2 ("enforcer/sight4.wav");

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/archtest.mdl");

	setsize (self, '-16 -16 -24', '16 16 40');
	self.health = 80;
	self.skin = 0;

	self.th_stand = archer_stand1;
	self.th_walk = archer_walk1;
	self.th_run = archer_run1;
	self.th_pain = archer_pain;
	self.th_die = archer_die;
	self.th_missile = archer_atk1;

	self.check_attack = CheckAttack;

	walkmonster_start();
};

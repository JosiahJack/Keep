



void() spider_stand1	=[	16,	spider_stand2	] {ai_stand();};
void() spider_stand2	=[	18,	spider_stand3	] {ai_stand();};
void() spider_stand3	=[	20,	spider_stand4	] {ai_stand();};
void() spider_stand4	=[	22,	spider_stand5	] {ai_stand();};
void() spider_stand5	=[	24,	spider_stand6	] {ai_stand();};
void() spider_stand6	=[	26,	spider_stand7	] {ai_stand();};
void() spider_stand7	=[	28,	spider_stand8	] {ai_stand();};
void() spider_stand8	=[	30,	spider_stand9	] {ai_stand();};
void() spider_stand9	=[	32,	spider_stand10	] {ai_stand();};
void() spider_stand10	=[	34,	spider_stand11	] {ai_stand();};
void() spider_stand11	=[	36,	spider_stand12	] {ai_stand();};
void() spider_stand12	=[	38,	spider_stand13	] {ai_stand();};
void() spider_stand13	=[	40,	spider_stand1	] {ai_stand();};


void() spider_walk1	=[	0,	spider_walk2	] 
{
	ai_walk(9);

	if (random() < 0.2)
    		sound (self, CHAN_VOICE, "spider/roam1pp.wav", 1, ATTN_IDLE);
};
void() spider_walk2	=[	2,	spider_walk3	] {ai_walk(9);};
void() spider_walk3	=[	4,	spider_walk4	] {ai_walk(9);};
void() spider_walk4	=[	6,	spider_walk5	] {ai_walk(9);};
void() spider_walk5	=[	8,	spider_walk6	] {ai_walk(9);};
void() spider_walk6	=[	10,	spider_walk7	] {ai_walk(9);};
void() spider_walk7	=[	12,	spider_walk8	] {ai_walk(9);};
void() spider_walk8	=[	14,	spider_walk1	] {ai_walk(9);};


void() spider_run1	=[	0,	spider_run2	] 
{
	ai_run(9);
	
	if (random() < 0.2)
    		sound (self, CHAN_VOICE, "spider/roam1pp.wav", 1, ATTN_IDLE);
};
void() spider_run2	=[	2,	spider_run3	] {ai_run(9);};
void() spider_run3	=[	4,	spider_run4	] {ai_run(9);};
void() spider_run4	=[	6,	spider_run5	] {ai_run(9);};
void() spider_run5	=[	8,	spider_run6	] {ai_run(9);};
void() spider_run6	=[	10,	spider_run7	] {ai_run(9);};
void() spider_run7	=[	12,	spider_run8	] {ai_run(9);};
void() spider_run8	=[	14,	spider_run1	] {ai_run(9);};

float() CheckSpiderMelee;

void() spider_atta1	=[	42,	spider_atta2	] {ai_face();sound(self, CHAN_VOICE, "spider/tear1pp.wav", 1, ATTN_NORM);};	//start melee prepare
void() spider_atta2	=[	44,	spider_atta3	] {ai_face();};
void() spider_atta3	=[	46,	spider_atta4	] {ai_face();};
void() spider_atta4	=[	48,	spider_atta5	] {ai_face();};
void() spider_atta5	=[	50,	spider_atta6	] {ai_face();};
void() spider_atta6	=[	52,	spider_atta7	] {ai_face();};	//end of melee prepare
void() spider_atta7	=[	54,	spider_atta8	] {ai_face();};	//start of melee loop
void() spider_atta8	=[	56,	spider_atta9	] {ai_face();};
void() spider_atta9	=[	58,	spider_atta10	] 
{
	local vector	delta;
	local float 	ldmg;

	if (!self.enemy)
		return;

	ai_face();

	if (!CanDamage (self.enemy, self))
		return;

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 50)
		return;

	sound(self, CHAN_WEAPON, "spider/thumppp.wav", 1, ATTN_NORM);
		
	ldmg = (random() + random() + random()) * 8;
	T_Damage (self.enemy, self, self, ldmg);
};
void() spider_atta10	=[	60,	spider_atta11	] {ai_face();};
void() spider_atta11	=[	62,	spider_run1	] 
{
	ai_face();

	if (self.enemy.health > 0)
	{
		if (CheckSpiderMelee())
			self.think = spider_atta7;
	}
};




void() Spider_JumpTouch;

void() spider_leap1	=[	64,		spider_leap2	] {ai_face();sound (self, CHAN_VOICE, "spider/hiss3pp.wav", 1, ATTN_NORM);};
void() spider_leap2	=[	66,		spider_leap3	] {ai_face();};
void() spider_leap3	=[	68,		spider_leap4	] 
{
	ai_face();
	
	self.touch = Spider_JumpTouch;
	makevectors (self.angles);
	self.origin_z = self.origin_z + 1;
	self.velocity = v_forward * 500 + '0 0 200';
	if (self.flags & FL_ONGROUND)
		self.flags = self.flags - FL_ONGROUND;
};
void() spider_leap4	=[	70,		spider_leap5	] {};
void() spider_leap5	=[	71,		spider_leap1	] {self.nextthink = time + 3;};	//fly through the air (note extra frame left in here)

void() spider_leap6	=[	72,		spider_leap7	] {};
void() spider_leap7	=[	74,		spider_leap8	] {};
void() spider_leap8	=[	76,		spider_leap9	] {};
void() spider_leap9	=[	78,		spider_run1	] {};

void() spider_leapscripted1	=[	64,		spider_leapscripted2	] 
{
	self.th_run = spider_run1;
	sound (self, CHAN_VOICE, "spider/hiss3pp.wav", 1, ATTN_NORM);
};
void() spider_leapscripted2	=[	66,		spider_leapscripted3	] {};
void() spider_leapscripted3	=[	68,		spider_leap4	] 
{	
	self.touch = Spider_JumpTouch;
	makevectors (self.angles);
	self.origin_z = self.origin_z + 1;
	
	if (self.height > 1)
	{
		self.velocity = v_forward * self.speed;
		self.velocity_z = self.height;
	}
	if (self.flags & FL_ONGROUND)
		self.flags = self.flags - FL_ONGROUND;
};



void() Spider_JumpTouch =
{
	local	float	ldmg;

	if (self.health <= 0)
		return;
		
	if (other.takedamage)
	if (other.classname != self.classname)	//BDW 14/09/00 this stops a group of fiends from taking each other out
	{
		if ( vlen(self.velocity) > 300 )
		{
			ldmg = 10 + 10*random();
			T_Damage (other, self, self, ldmg);	
		}
	}

	if (!checkbottom(self))
	{
		if (self.flags & FL_ONGROUND)
		{	
			// jump randomly to not get hung up
			//dprint ("popjump\n");

			self.touch = SUB_Null;
			self.think = spider_leap1;
			self.nextthink = time + 0.1;			
		}
		return;	// not on ground yet
	}

	self.touch = SUB_Null;
	self.think = spider_leap6;
	self.nextthink = time + 0.1;
};


void() spider_pain1	=[	80,	spider_pain2	] {};
void() spider_pain2	=[	82,	spider_pain3	] {};
void() spider_pain3	=[	84,	spider_pain4	] {};
void() spider_pain4	=[	86,	spider_pain5	] {};
void() spider_pain5	=[	88,	spider_run1	] {};

void() spider_paina1	=[	90,	spider_paina2	] {};
void() spider_paina2	=[	92,	spider_paina3	] {};
void() spider_paina3	=[	94,	spider_paina4	] {};
void() spider_paina4	=[	96,	spider_run1	] {};


void(entity attacker, float damage) spider_pain = 
{
	if (self.pain_finished > time)
	if (NotAGoonSlapper(attacker))	//bdw - always do pain on a goonslap
		return;

	if ( ((self.frame > 49) && (self.frame < 64)) || ((self.frame > 89) && (self.frame < 98)) )
		spider_paina1();
	else
		spider_pain1();

	sound(self, CHAN_VOICE, "spider/injur1pp.wav", 1, ATTN_NORM);

	self.pain_finished = time + 1;
};

void() spider_die1		=[	98,	spider_die2	] {sound(self, CHAN_VOICE, "spider/death.wav", 1, ATTN_NORM);};
void() spider_die2		=[	100,	spider_die3	] {};
void() spider_die3		=[	102,	spider_die4	] {};
void() spider_die4		=[	104,	spider_die5	] {};
void() spider_die5		=[	106,	spider_die6	] {};
void() spider_die6		=[	108,	spider_die7	] {};
void() spider_die7		=[	110,	spider_die8	] {};
void() spider_die8		=[	112,	spider_die9	] {};
void() spider_die9		=[	114,	spider_die10] {};
void() spider_die10		=[	116,	BDW_CorpseRemove] {};

void() spider_die = 
{
	// check for gib
	if (self.health < -35)
	{
		MonsterGibTiny("progs/newgib4.mdl");     	
	      	return;
	}

	self.solid = SOLID_NOT;
	spider_die1();
};

void() spider_bite1 = {};


/*
==============
CheckSpiderMelee

Returns TRUE if a melee attack would hit right now
==============
*/
float()	CheckSpiderMelee =
{
	local vector	spot1, spot2;
	local float		r;

	spot1 = self.origin + self.view_ofs;
	spot2 = self.enemy.origin + self.enemy.view_ofs;

	r = vlen (spot1 - spot2);

	if (r < 50)
	{
		self.attack_state = AS_MELEE;
		return TRUE;
	}
	return FALSE;
};

/*
==============
CheckSpiderJump

==============
*/
float()	CheckSpiderJump =
{
	local	vector	dist;
	local	float	d;

	if (random() < 0.9)
		return FALSE;

	if (self.origin_z + self.mins_z > self.enemy.origin_z + self.enemy.mins_z
	+ 0.75 * self.enemy.size_z)
		return FALSE;
		
	if (self.origin_z + self.maxs_z < self.enemy.origin_z + self.enemy.mins_z
	+ 0.25 * self.enemy.size_z)
		return FALSE;
		
	dist = self.enemy.origin - self.origin;
	dist_z = 0;
	
	d = vlen(dist);
	
	if (d < 80)
		return FALSE;
		
	if (d > 200)
		return FALSE;
		
	return TRUE;
};

float()	SpiderCheckAttack =
{
	
// if close enough for slashing, go for it
	if (CheckSpiderMelee ())
	{
		self.attack_state = AS_MELEE;
		return TRUE;
	}
	
	if (CheckSpiderJump ())
	{
		self.attack_state = AS_MISSILE;
		return TRUE;
	}
	
	return FALSE;
};

void() spider_sight =
{
	if (random() < 0.5)
		sound(self, CHAN_VOICE, "spider/hiss1pp.wav", 1, ATTN_NORM);
	else
		sound(self, CHAN_VOICE, "spider/hiss2pp.wav", 1, ATTN_NORM);
};



void() monster_spider_precache =
{
	precache_model ("progs/spider.mdl");

	precache_sound("spider/hiss3pp.wav");
	precache_sound("spider/hiss2pp.wav");
	precache_sound("spider/hiss1pp.wav");


	precache_sound("spider/death.wav");
	precache_sound("spider/injur1pp.wav");
	precache_sound("spider/roam1pp.wav");
	precache_sound("spider/thumppp.wav");
	precache_sound("spider/tear1pp.wav");


	
};

void() monster_spider_init =
{
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/spider.mdl");

	setsize (self, '-16 -16 -24', '16 16 24');
	self.health = 50;

	self.th_stand = spider_stand1;
	self.th_walk = spider_walk1;

	if (self.height)	//assumed the spider is set to do a scripted ambush jump (set height and speed)
	{
		self.spawnflags = self.spawnflags | M_NOSIGHT;
		self.th_run = spider_leapscripted1;
	}
	else
		self.th_run = spider_run1;

	self.th_pain = spider_pain;
	self.th_die = spider_die;
	self.th_melee = spider_atta1;
	self.th_missile = spider_leap1;

	self.sight_sound = spider_sight;
	self.check_attack = SpiderCheckAttack;
	self.classname = "monster_spider";
};

void() monster_spider =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	monster_spider_precache();
	
	//if (MonsterSpawnedLater(MONSTER_SPIDER))		
	//	return;
	
	monster_spider_init();
	walkmonster_start();
};



void() monster_spider_wallspider =
{

	precache_model ("progs/spider.mdl");
	setmodel(self, "progs/spider.mdl");

	self.angles_x = -90;
	
};
	












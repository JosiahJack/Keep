/*=============================================================================

BONES

===============================================================================

Convertions from the Quake3 model Bones. Texture file and mdl exported from Q3.
Head and body didn't fit, dew to vertice meshes, so I changed them.
Still the model looks shreak and thin. MadFox 17aug 2007.

Addition as the slash frames made the model vanish into the void loosing bouncing 
box. Change the slash subroutine into throwing a bone as projectile. 18sept.

===============================================================================
*/

$cd /raid/quake/id1/models/bones
$scale 1
$origin 0 0 12
$base base
$skin base

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9 walk10 walk11
$frame walk12 walk13 walk14 

$frame run1 run2 run3 run4 run5 run6 run7 run8

$frame pain1 pain2 pain3 pain4 pain5 pain6 

$frame painb1 painb2 painb3 painb4 painb5 painb6 painb7 painb8 painb9

$frame attack1 attack2 attack3 attack4 attack5 attack6 attack7 attack8 attack9
$frame attack10

$frame shut1 shut2 shut3 shut4 shut5 shut6 shut7 shut8 shut9 shut10 shut11
$frame shut12 shut13

$frame death1 death2 death3 death4 death5 death6 death7 death8 death9 death10
$frame death11 death12 death13 death14

$frame deathb1 deathb2 deathb3 deathb4 deathb5 deathb6 deathb7 deathb8 deathb9
$frame deathb10 deathb11 deathb12 deathb13 deathb14 deathb15 deathb16 deathb17 
$frame deathb18

//=============================================================================

float()	CheckBonesMelee;

void() Tbone_Touch = {
	local vector org;
	
	if (other == self.owner)
		return;		// don't explode on owner

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	
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


void(vector org, vector vec) TlaunchBone =
{
	local	vector	vec;
		
	if (self.classname == "monster_enforcer")
		sound (self, CHAN_WEAPON, "enforcer/enfire.wav", 1, ATTN_NORM);

	vec = normalize(vec);
	
	newmis = spawn();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLY;
	newmis.solid = SOLID_BBOX;
	newmis.effects = EF_DIMLIGHT;

	setmodel (newmis, "progs/tbone.spr");
	setsize (newmis, '0 0 0', '0 0 0');		
	setorigin (newmis, org);

	newmis.velocity = vec * 200;
	newmis.angles = vectoangles(newmis.velocity);

	newmis.nextthink = time + 0.5;
	newmis.think = SUB_Remove;
	newmis.touch = Tbone_Touch;
};

void() bone_shut =
{
	local vector org;

	self.effects = self.effects | EF_MUZZLEFLASH;
	makevectors (self.angles);
	
	org = self.origin + v_forward * 30 + v_right * 1.5 + '0 0 16';

	TlaunchBone(org, self.enemy.origin - self.origin);
};



void() OdLaser_Touch =
{
	local vector org;
	
	if (other == self.owner)
		return;		// don't explode on owner

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	
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

void(vector org, vector vec) OdLaunchLaser =
{
	local	vector	vec;
		
	if (self.classname == "monster_enforcer")
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
	newmis.touch = OdLaser_Touch;
};



void() bones_fire =
{
	local vector org;

	self.effects = self.effects | EF_MUZZLEFLASH;
	makevectors (self.angles);
	
	org = self.origin + v_forward * 30 + v_right * 8.5 + '0 0 16';

	OdLaunchLaser(org, self.enemy.origin - self.origin);
};


void() bones_stand1    =[   $stand1,     bones_stand2   ]  {ai_stand();};
void() bones_stand2    =[   $stand2,     bones_stand3   ]  {ai_stand();};
void() bones_stand3    =[   $stand3,     bones_stand4   ]  {ai_stand();};
void() bones_stand4    =[   $stand4,     bones_stand5   ]  {ai_stand();};
void() bones_stand5    =[   $stand5,     bones_stand6   ]  {ai_stand();};
void() bones_stand6    =[   $stand6,     bones_stand7   ]  {ai_stand();};
void() bones_stand7    =[   $stand7,     bones_stand8   ]  {ai_stand();};
void() bones_stand8    =[   $stand8,     bones_stand1   ]  {ai_stand();};

void() bones_walk1     =[   $walk1,      bones_walk2    ]  {
if (random() < 0.2)
	sound (self, CHAN_VOICE, "bones/taunt.wav", 1,  ATTN_IDLE);
ai_walk(3);};
void() bones_walk2     =[   $walk2,      bones_walk3    ]  {ai_walk(4);};
void() bones_walk3     =[   $walk3,      bones_walk4    ]  {ai_walk(6);};
void() bones_walk4     =[   $walk4,      bones_walk5    ]  {ai_walk(8);};
void() bones_walk5     =[   $walk5,      bones_walk6    ]  {ai_walk(3);};
void() bones_walk6     =[   $walk6,      bones_walk7    ]  {ai_walk(3);};
void() bones_walk7     =[   $walk7,      bones_walk8    ]  {ai_walk(5);};
void() bones_walk8     =[   $walk8,      bones_walk9    ]  {ai_walk(8);};
void() bones_walk9     =[   $walk9,      bones_walk10   ]  {ai_walk(3);};
void() bones_walk10    =[   $walk10,     bones_walk11   ]  {ai_walk(3);};
void() bones_walk11    =[   $walk11,     bones_walk12   ]  {ai_walk(2);};
void() bones_walk12    =[   $walk12,     bones_walk13   ]  {ai_walk(3);};
void() bones_walk13    =[   $walk13,     bones_walk14   ]  {ai_walk(8);};
void() bones_walk14    =[   $walk14,     bones_walk1    ]  {ai_walk(3);};

void() bones_run1      =[   $run1,       bones_run2     ]  {
if (random() < 0.2)
	sound (self, CHAN_VOICE, "bones/taunt.wav", 1,  ATTN_IDLE);
ai_run(16);};
void() bones_run2      =[   $run2,       bones_run3     ]  {ai_run(20);};
void() bones_run3      =[   $run3,       bones_run4     ]  {ai_run(13);};
void() bones_run4      =[   $run4,       bones_run5     ]  {ai_run(7);};
void() bones_run5      =[   $run5,       bones_run6     ]  {ai_run(16);};
void() bones_run6      =[   $run6,       bones_run7     ]  {ai_run(20);};
void() bones_run7      =[   $run7,       bones_run8     ]  {ai_run(14);};
void() bones_run8      =[   $run8,       bones_run1     ]  {ai_run(6);};

void() bones_pain1     =[   $pain1,      bones_pain2    ]  {
if (random() < 0.2)
	sound (self, CHAN_VOICE, "bones/pain1.wav", 1,  ATTN_IDLE);
ai_charge();};
void() bones_pain2     =[   $pain2,      bones_pain3    ]  {ai_charge(4);};
void() bones_pain3     =[   $pain3,      bones_pain4    ]  {ai_charge(3);};
void() bones_pain4     =[   $pain4,      bones_pain5    ]  {ai_charge(5);};
void() bones_pain5     =[   $pain5,      bones_pain6    ]  {ai_charge(4);};
void() bones_pain6     =[   $pain6,      bones_run1     ]  {ai_charge(8);};

void() bones_painb1    =[   $painb1,     bones_painb2   ]  {
if (random() < 0.2)
	sound (self, CHAN_VOICE, "bones/pain2.wav", 1,  ATTN_IDLE);
ai_charge();};
void() bones_painb2    =[   $painb2,     bones_painb3   ]  {ai_charge(4);};
void() bones_painb3    =[   $painb3,     bones_painb4   ]  {ai_charge(5);};
void() bones_painb4    =[   $painb4,     bones_painb5   ]  {ai_charge(3);};
void() bones_painb5    =[   $painb5,     bones_painb6   ]  {ai_charge(4);};
void() bones_painb6    =[   $painb6,     bones_painb7   ]  {ai_charge(5);};
void() bones_painb7    =[   $painb7,     bones_painb8   ]  {ai_charge(4);};
void() bones_painb8    =[   $painb8,     bones_painb9   ]  {ai_charge(3);};
void() bones_painb9    =[   $painb9,     bones_run1     ]  {ai_charge(8);};

void(entity attacker, float damage)	bones_pain =    
{
	local float r;

	if (self.pain_finished > time)
		return;

	r = random();
	
        if (r < 0.05)
	{
		bones_pain1 ();
		self.pain_finished = time + 5;
	}
	else if (r < 0.1)
	{
		bones_painb1 ();
		self.pain_finished = time + 5;
	}
	else if (r < 0.15)
		self.pain_finished = time + 0.5;
        
};

void() bones_atk1    =[   $attack1,      bones_atk2     ]   {
if (random() < 0.2)
	sound (self, CHAN_VOICE, "bones/taunt.wav", 1,  ATTN_IDLE);
ai_face();};
void() bones_atk2    =[   $attack2,      bones_atk3     ]   {ai_face();};
void() bones_atk3    =[   $attack3,      bones_atk4     ]   {ai_forward(5);};
void() bones_atk4    =[   $attack4,      bones_atk5     ]   {ai_face();};
void() bones_atk5    =[   $attack5,      bones_atk6     ]   {bones_fire();};
void() bones_atk6    =[   $attack6,      bones_atk7     ]   {ai_face();};
void() bones_atk7    =[   $attack7,      bones_atk8     ]   {ai_face();};
void() bones_atk8    =[   $attack8,      bones_atk9     ]   {ai_forward(5);};
void() bones_atk9    =[   $attack9,      bones_atk10    ]   {ai_face();};
void() bones_atk10   =[   $attack10,     bones_run1     ]   {ai_face();};


void() bones_shut1   =[   $shut1,        bones_shut2    ]   {
if (random() < 0.2)
	sound (self, CHAN_VOICE, "bones/taunt.wav", 1,  ATTN_IDLE);
ai_charge_side();};
void() bones_shut2   =[   $shut2,        bones_shut3    ]   {ai_forward(3);};
void() bones_shut3   =[   $shut3,        bones_shut4    ]   {ai_charge_side();};
void() bones_shut4   =[   $shut4,        bones_shut5    ]   {bone_shut();};
void() bones_shut5   =[   $shut5,        bones_shut6    ]   {ai_melee_side();};
void() bones_shut6   =[   $shut6,        bones_shut7    ]   {ai_melee_side();};
void() bones_shut7   =[   $shut7,        bones_shut8    ]   {ai_melee_side();};
void() bones_shut8   =[   $shut8,        bones_shut9    ]   {ai_melee_side();};
void() bones_shut9   =[   $shut9,        bones_shut10   ]   {ai_melee_side();};
void() bones_shut10  =[   $shut10,       bones_shut11   ]   {ai_forward(5);};
void() bones_shut11  =[   $shut11,       bones_shut12   ]   {ai_melee_side();};
void() bones_shut12  =[   $shut12,       bones_shut13   ]   {ai_charge_side();};
void() bones_shut13  =[   $shut13,       bones_run1     ]   {ai_charge(10);};

void() bones_die1    =[   $death1,       bones_die2     ]   {
if (random() < 0.2)
	sound (self, CHAN_VOICE, "bones/death1.wav", 1,  ATTN_IDLE);
}; 
void() bones_die2    =[   $death2,       bones_die3     ]   {};
void() bones_die3    =[   $death3,       bones_die4     ]   
{self.solid = SOLID_NOT;self.ammo_cells = 5;DropBonepack();};
void() bones_die4    =[   $death4,       bones_die5     ]   {};
void() bones_die5    =[   $death5,       bones_die6     ]   {};
void() bones_die6    =[   $death6,       bones_die7     ]   {};
void() bones_die7    =[   $death7,       bones_die8     ]   {};
void() bones_die8    =[   $death8,       bones_die9     ]   {};
void() bones_die9    =[   $death9,       bones_die10    ]   {};
void() bones_die10   =[   $death10,      bones_die11    ]   {};
void() bones_die11   =[   $death11,      bones_die12    ]   {};
void() bones_die12   =[   $death12,      bones_die13    ]   {};
void() bones_die13   =[   $death13,      bones_die14    ]   {};
void() bones_die14   =[   $death14,      CorpseThink    ]   {};
 
void() bones_dieb1   =[   $deathb1,      bones_dieb2    ]   {
if (random() < 0.2)
	sound (self, CHAN_VOICE, "bones/death2.wav", 1,  ATTN_IDLE);
};
void() bones_dieb2   =[   $deathb2,      bones_dieb3    ]   {};
void() bones_dieb3   =[   $deathb3,      bones_dieb4    ]   
{self.solid = SOLID_NOT;self.ammo_cells = 5;DropBonepack();};
void() bones_dieb4   =[   $deathb4,      bones_dieb5    ]   {};
void() bones_dieb5   =[   $deathb5,      bones_dieb6    ]   {};
void() bones_dieb6   =[   $deathb6,      bones_dieb7    ]   {};
void() bones_dieb7   =[   $deathb7,      bones_dieb8    ]   {};
void() bones_dieb8   =[   $deathb8,      bones_dieb9    ]   {};
void() bones_dieb9   =[   $deathb9,      bones_dieb10   ]   {};
void() bones_dieb10  =[   $deathb10,     bones_dieb11   ]   {};
void() bones_dieb11  =[   $deathb11,     bones_dieb12   ]   {};
void() bones_dieb12  =[   $deathb12,     bones_dieb13   ]   {};
void() bones_dieb13  =[   $deathb13,     bones_dieb14   ]   {};
void() bones_dieb14  =[   $deathb14,     bones_dieb15   ]   {};
void() bones_dieb15  =[   $deathb15,     bones_dieb16   ]   {};
void() bones_dieb16  =[   $deathb16,     bones_dieb17   ]   {};
void() bones_dieb17  =[   $deathb17,     bones_dieb18   ]   {};
void() bones_dieb18  =[   $deathb18,     CorpseThink   ]   {};

void() bones_die = {
	if (self.health < -35) { // check for gib
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		ThrowHead ("progs/b_head.mdl", self.health);
		ThrowGib ("progs/gib1.mdl", self.health);
		ThrowGib ("progs/gib2.mdl", self.health);
		ThrowGib ("progs/gib3.mdl", self.health);
		return;
	}

	// regular death
	sound (self, CHAN_VOICE, "bones/idle.wav", 1, ATTN_NORM);
	if (random() > 0.5)
		bones_die1 ();
	else
		bones_dieb1 ();
};

// QUAKED monster_bones (1 0 0) (-16 -16 -24) (16 16 40) Ambush
void() monster_bones = {
	if (deathmatch) {
		remove(self);
		return;
	}
	precache_model ("progs/bones.mdl");
	precache_model ("progs/b_head.mdl");
	precache_model ("progs/gib1.mdl");
	precache_model ("progs/gib2.mdl");
	precache_model ("progs/gib3.mdl");
	precache_model ("progs/laser.mdl");
	precache_model ("progs/beanes.mdl");
	precache_model ("progs/tbone.spr");
	precache_sound ("enforcer/enfstop.wav");
	precache_sound ("enforcer/enfire.wav");
	precache_sound ("bones/pain1.wav");
	precache_sound ("bones/pain2.wav");
	precache_sound ("bones/death1.wav");
	precache_sound ("bones/death2.wav");
	precache_sound ("bones/idle.wav");
	precache_sound ("bones/taunt.wav");
       
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/bones.mdl");
	setsize (self, '-16 -16 -24', '16 16 40');
	self.health = 150;

	self.th_stand   = bones_stand1;
	self.th_walk    = bones_walk1;
	self.th_run     = bones_run1;
	self.th_die     = bones_die;
	self.th_melee   = bones_shut1;
	self.th_missile = bones_atk1;
	self.th_pain    = bones_pain;

	walkmonster_start();
};

// Returns TRUE if a melee attack would hit right now
float()	CheckBonesMelee = {
	if (enemy_range == RANGE_MELEE) { // FIXME: check canreach
		self.attack_state = AS_MELEE;
		return TRUE;
	}
    bones_shut1();
	return FALSE;
};

void() Bones_CheckAttack = {
	local vector	spot1, spot2;	
	local entity	targ;
	local float		chance;
	
	if (enemy_range == RANGE_MELEE) return FALSE;
		chance = random(); 
		if(chance < 0.3) { 
			bones_atk1(); 
			return TRUE; 
		}
 
		if(chance < 0.6) { 
			bones_shut1(); 
			return TRUE; 
		} 
    }
};

void() tbone_stand1    =[  0,       tbone_stand2  ] {};
void() tbone_stand2    =[  1,       tbone_stand3  ] {};
void() tbone_stand3    =[  2,       tbone_stand4  ] {};
void() tbone_stand4    =[  3,       tbone_stand5  ] {};
void() tbone_stand5    =[  4,       tbone_stand6  ] {};
void() tbone_stand6    =[  5,       tbone_stand7  ] {};
void() tbone_stand7    =[  6,       tbone_stand8  ] {};
void() tbone_stand8    =[  7,       tbone_stand9  ] {};
void() tbone_stand9    =[  8,       tbone_stand1  ] {};

void() model_tbone = {
	self.solid = SOLID_BBOX;
	self.movetype = MOVETYPE_NONE;
	setmodel (self, "progs/madfox/tbone.spr");
	setsize (self, '16 16 16', '24 24 24');
	self.think = tbone_stand1;
	self.nextthink = time + 0.1;
};
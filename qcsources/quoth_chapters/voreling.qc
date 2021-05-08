.float		vltime;
.float		marked;

float() VLFindTargetUnder =
{
	local	entity	head;
	local	float	m, n;
	local	vector	o, p;



	head = findradius(self.origin, 1000);
	
	while (head)
	{
		
		if (head.classname == "player" && visible (head))
		{
			if (head.flags & FL_NOTARGET)
				return FALSE;
			if (head.items & IT_INVISIBILITY)
				return FALSE;
	
			o = self.origin;
			o_z = 0;
			p = head.origin;
			p_z = 0;
			
			m = vlen(p - o);
			
			if (self.marked == 0)
				self.vltime = time + 2;

			if (m < 192)
			{
				self.enemy = head;
				
				FoundTarget ();
				return TRUE;				
			}
			else if (m < 400)
			{
				self.marked = 1;
				
				if (self.vltime < time)
				{
					self.enemy = head;
				
					FoundTarget ();
					return TRUE;					
				}
			}
			else if (self.marked == 1 && self.vltime < time - 2)
			{
				self.enemy = head;
				
				FoundTarget ();
				return TRUE;					

			}
						
			
			

		}
	head = head.chain;	
	}
	
	//if (self.enemy.classname == "worldspawn")
	return FALSE;
		


};




float() VLFindTarget =
{
	local entity	client;
	local float		r;


	if (self.wait == 1)
		return FALSE;
		
// if the first spawnflag bit is set, the monster will only wake up on
// really seeing the player, not another monster getting angry

// spawnflags & 3 is a big hack, because zombie crucified used the first
// spawn flag prior to the ambush flag, and I forgot about it, so the second
// spawn flag works as well
	if (sight_entity_time >= time - 0.1 && !(self.spawnflags & 3) )
	{
		client = sight_entity;
		if (client.enemy == self.enemy)
			return;
	}
	else
	{
		client = checkclient ();
		if (!client)
			return FALSE;	// current check entity isn't in PVS
	}

	if (client == self.enemy)
		return FALSE;

	if (client.flags & FL_NOTARGET)
		return FALSE;
	if (client.items & IT_INVISIBILITY)
		return FALSE;

	r = range (client);
	if (r == RANGE_FAR)
		return FALSE;
		
	if (!visible (client))
		return FALSE;

	if (r == RANGE_NEAR)
	{
		if (client.show_hostile < time && !infront (client))
			return FALSE;
	}
	else if (r == RANGE_MID)
	{
		if ( /* client.show_hostile < time || */ !infront (client))
			return FALSE;
	}
	
//
// got one
//
	self.enemy = client;
	if (self.enemy.classname != "player")
	{
		self.enemy = self.enemy.enemy;
		if (self.enemy.classname != "player")
		{
			self.enemy = world;
			return FALSE;
		}
	}
	
	FoundTarget ();

	return TRUE;
};



void() ai_hang =
{
	if (VLFindTarget ())
		return;
	if (VLFindTargetUnder ())
		return;
};









/*
==============================================================================

Voreling

==============================================================================
*/
$cd id1/models/voreling
$origin 0 0 24
$base base
$skin skin
$scale 1

$frame idle1 idle2 idle3 idle4 idle5 idle6 idle7 idle8 idle9 idle10 idle11 idle12 idle13

$frame dangle1 dangle2 dangle3 dangle4 dangle5 dangle6

$frame fall1 fall2 fall3 fall4 fall5

$frame walk1 walk2 walk3 walk4 walk5

$frame run1 run2 run3 run4

$frame leap1 leap2 leap3 leap4 leap5 leap6

$frame bite1 bite2 bite3 bite4 bite5 bite6 bite7

$frame pain1 pain2

$frame deatha1 deatha2 deatha3 deatha4 deatha5 deatha6

$frame deathb1 deathb2 deathb3 deathb4 deathb5 deathb6 deathb7


void() voreling_pain;
void() VorelingBite;
void() voreling_run1;


void() voreling_stand1     =[      $idle1,       voreling_stand2    ] 
{
	
	ai_stand();
	if (random() < 0.25 && self.ltime < time && self.spawnflags & 1)
	{
		sound (self, CHAN_VOICE, "voreling/idle.wav", 1, 3);
		self.ltime = time + 1.8;
	}
};
void() voreling_stand2     =[      $idle2,       voreling_stand3    ] {ai_stand();};
void() voreling_stand3     =[      $idle3,       voreling_stand4    ] {ai_stand();};
void() voreling_stand4     =[      $idle4,       voreling_stand5    ] {ai_stand();};
void() voreling_stand5     =[      $idle5,       voreling_stand6    ] {ai_stand();};
void() voreling_stand6     =[      $idle6,       voreling_stand7    ] {ai_stand();};
void() voreling_stand7     =[      $idle7,       voreling_stand8    ] {ai_stand();};
void() voreling_stand8     =[      $idle8,       voreling_stand9    ] {ai_stand();};
void() voreling_stand9     =[      $idle9,       voreling_stand10   ] {ai_stand();};
void() voreling_stand10    =[      $idle10,      voreling_stand11   ] {ai_stand();};
void() voreling_stand11    =[      $idle11,      voreling_stand12   ] {ai_stand();};
void() voreling_stand12    =[      $idle12,      voreling_stand13   ] {ai_stand();};
void() voreling_stand13    =[      $idle13,      voreling_stand1    ] {ai_stand();};



void() voreling_ceiling1;



void() voreling_ceiling0     =[      $dangle1,       voreling_ceiling1    ]
{
	traceline (self.origin, self.origin + '0 0 1000', TRUE, self);
	setorigin (self, trace_endpos - '0 0 32');
	self.flags = self.flags | FL_ONGROUND;
};

void() voreling_ceiling1     =[      $dangle1,       voreling_ceiling2    ] 
{
	
	ai_hang();
	/*if (random() < 0.25 && self.ltime < time && self.spawnflags & 1)
	{
		sound (self, CHAN_VOICE, "voreling/idle.wav", 1, 3);
		self.ltime = time + 1.8;
	}*/
	
};
void() voreling_ceiling2     =[      $dangle2,       voreling_ceiling3    ] {ai_hang();};
void() voreling_ceiling3     =[      16,	     voreling_ceiling4    ] {ai_hang();}; //wtf?  frame error?
void() voreling_ceiling4     =[      $dangle4,       voreling_ceiling5    ] {ai_hang();};
void() voreling_ceiling5     =[      $dangle5,       voreling_ceiling6    ] {ai_hang();};
void() voreling_ceiling6     =[      $dangle6,       voreling_ceiling1    ] {ai_hang();};





void() voreling_walk1     =[      $walk1,       voreling_walk2    ] {ai_walk(6);};
void() voreling_walk2     =[      $walk2,       voreling_walk3    ] {ai_walk(4);};
void() voreling_walk3     =[      $walk3,       voreling_walk4    ] {ai_walk(6);};
void() voreling_walk4     =[      $walk4,       voreling_walk5    ] {ai_walk(4);};
void() voreling_walk5     =[      $walk5,       voreling_walk1    ] {ai_walk(5);};



void() voreling_run1     =[      $run1,       voreling_run2    ] {ai_run(20);};
void() voreling_run2     =[      $run2,       voreling_run3    ] {ai_run(19);};
void() voreling_run3     =[      $run3,       voreling_run4    ] {ai_run(18);};
void() voreling_run4     =[      $run4,       voreling_run1    ] {ai_run(17);};





void() voreling_attack1  	=[      $bite1,       voreling_attack2    ] {ai_charge(20);};
void() voreling_attack2  	=[      $bite2,       voreling_attack3    ] {ai_charge(16);};
void() voreling_attack3  	=[      $bite3,       voreling_attack4    ] {ai_charge(13);};
void() voreling_attack4   	=[      $bite4,       voreling_attack5    ] {ai_charge(17);};
void() voreling_attack5   	=[      $bite5,       voreling_attack6    ] {ai_charge(18);};
void() voreling_attack6		=[      $bite6,       voreling_attack7    ] {VorelingBite();};
void() voreling_attack7   	=[      $bite7,       voreling_run1       ] {};


void() voreling_pain1       =[      $pain1, voreling_run1      ] {};
void() voreling_pain2       =[      $pain2, voreling_run1      ] {};

void() voreling_deatha1      =[      $deatha1,        voreling_deatha2     ] {};
void() voreling_deatha2      =[      $deatha2,        voreling_deatha3     ] {};
void() voreling_deatha3      =[      $deatha3,        voreling_deatha4     ] {};
void() voreling_deatha4      =[      $deatha4,        voreling_deatha5     ] {};
void() voreling_deatha5      =[      $deatha5,        voreling_deatha6     ] {};
void() voreling_deatha6      =[      $deatha6,        monster_fade ] {self.nextthink = time + 0.1;};

void() voreling_deathb1      =[      $deathb1,        voreling_deathb2     ] {};
void() voreling_deathb2      =[      $deathb2,        voreling_deathb3     ] {};
void() voreling_deathb3      =[      $deathb3,        voreling_deathb4     ] {};
void() voreling_deathb4      =[      $deathb4,        voreling_deathb5     ] {};
void() voreling_deathb5      =[      $deathb5,        voreling_deathb6     ] {};
void() voreling_deathb6      =[      $deathb6,        voreling_deathb7     ] {};
void() voreling_deathb7      =[      $deathb7,        monster_fade ] {self.nextthink = time + 0.1;};

void() Voreling_JumpTouch;


void()	voreling_jump1	=[	$leap1,		voreling_jump2	] {ai_face();};
void()	voreling_jump2	=[	$leap2,		voreling_jump3	]
{
	ai_face();
	
	self.t_width = time + 0.1;
	self.touch = Voreling_JumpTouch;
	makevectors (self.angles);
	self.origin_z = self.origin_z + 1;
	self.velocity = v_forward * 750 + '0 0 180';
	self.movetype = MOVETYPE_TOSS;
	if (self.flags & FL_ONGROUND)
		self.flags = self.flags - FL_ONGROUND;
};
void()	voreling_jump3	=[	$leap5,		voreling_jump4	] {};
void()	voreling_jump4	=[ 	$leap6,		voreling_jump5	] {};
void()	voreling_jump5	=[ 	$leap6, 	voreling_fall1	] {
self.nextthink = time + 3;
// if three seconds pass, assume voreling is stuck and jump again
};







void() voreling_pain =
{
	if (self.pain_finished > time)
		return;

	sound (self, CHAN_VOICE, "voreling/pain.wav", 1, ATTN_NORM);
	
	if (random() < 0.5)
		voreling_pain1();
		
	else
		voreling_pain2();
		
	self.pain_finished = time + 3;
};


void(string gibname, float dm) ThrowLeg =
{
	local	entity new;

	new = spawn();
	new.origin = self.origin;
	setmodel (new, gibname);
	setsize (new, '0 0 0', '0 0 0');
	new.velocity = VelocityForDamage (dm);
	new.movetype = MOVETYPE_BOUNCE;
	new.solid = SOLID_NOT;
	new.avelocity_x = 0;
	new.avelocity_y = random()*600 - 1200;
	new.avelocity_z = 0;
	new.think = SUB_Remove;
	new.ltime = time;
	new.nextthink = time + 10 + random()*10;
	new.frame = 0;
	new.flags = 0;
};

void() voreling_die =
{
// check for gib
	if (self.health < -50)
	{
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		//ThrowHead ("progs/h_shal.mdl", self.health);
		ThrowLeg ("progs/vleg.mdl", self.health);
		ThrowLeg ("progs/vleg.mdl", self.health);
		ThrowLeg ("progs/vleg.mdl", self.health);
		SUB_Remove();
		return;
	}
	
	sound (self, CHAN_VOICE, "voreling/death.wav", 1, ATTN_NORM);
	

	if (self.health < -25)
		voreling_deathb1();
	else	
		voreling_deatha1();
	
	self.solid = SOLID_NOT;

};

/*
================
Biting Attack
================
*/

void() VorelingBite =
{
	local vector	delta;
	local float 	ldmg;

	if (!self.enemy)
		return;
	if (!CanDamage (self.enemy, self))
		return;

	ai_charge(20);
	
	
	delta = self.enemy.origin - self.origin;
	if (vlen(delta) > 64)
		return;
		
	ldmg = 3 + random() * 3;
	T_Damage (self.enemy, self, self, ldmg);
	SpawnMeatSpray (self.origin + v_forward*16, ((random() * 60) - 30) * v_right);
	sound (self, CHAN_VOICE, "voreling/bitestrt.wav", 1, ATTN_NORM);
	
};










float()	CheckVlingJump =
{
	local	vector	dist;
	local	float	d;

	if (self.origin_z + self.mins_z > self.enemy.origin_z + self.enemy.mins_z
	+ 0.75 * self.enemy.size_z)
		return FALSE;
		
	if (self.origin_z + self.maxs_z < self.enemy.origin_z + self.enemy.mins_z
	+ 0.25 * self.enemy.size_z)
		return FALSE;
		
	dist = self.enemy.origin - self.origin;
	dist_z = 0;
	
	d = vlen(dist);
	
	if (d < 100)
		return FALSE;
		
	if (d > 400)
		return FALSE;

		
	return TRUE;
};

void()	vling_jump =
{
	local	vector	vec;
	
	if (CheckVlingJump ())
	{
		voreling_jump1();
	}

};






void()	Voreling_JumpTouch =
{
	local	float	ldmg;


	
	if (self.health <= 0)
		return;
	
	if (self.t_width > time && other.classname == "monster_voreling")
		return;
	
	if (other.takedamage)
	{
		if ( vlen(self.velocity) > 400 )
		{
			ldmg = 7 + 4*random();
			if (other.classname == "monster_voreling")
				ldmg = 1;
			T_Damage (other, self, self, ldmg);
			self.touch = SUB_Null;
		}
	}

	sound (self, CHAN_BODY, "voreling/land.wav", 1, ATTN_NORM);
	
	if (other.takedamage == DAMAGE_AIM)
		sound (self, CHAN_VOICE, "voreling/bite.wav", 1, ATTN_NORM);

	if (!checkbottom(self))
	{
		if (self.flags & FL_ONGROUND)
		{	
			self.touch = SUB_Null;
			self.think = voreling_jump1;
			self.nextthink = time + 0.1;
		}
		return;	// not on ground yet
	}


	self.movetype = MOVETYPE_STEP;
	
	self.touch = SUB_Null;
	self.think = voreling_fall1;
	self.nextthink = time + 0.1;
};


void()	Voreling_DropTouch =
{
	local	float	ldmg;

	
	
	if (self.health <= 0)
		return;
		
	if (other.takedamage)
	{
		if (self.velocity_z > 100 || self.velocity_z < -100)
		{
			if (other != self.enemy)
				return;
			ldmg = 7 + 4*random();

			T_Damage (other, self, self, ldmg);	
			self.touch = SUB_Null;
			if (other.takedamage == DAMAGE_AIM)
				sound (self, CHAN_VOICE, "voreling/bite.wav", 1, ATTN_NORM);
				
			/*if (self.flags & FL_ONGROUND)
				self.flags = self.flags - FL_ONGROUND;

			self.velocity_x = 100 * random();
			self.velocity_y = 100 * random();
			self.velocity_z = 200 * random();*/

		}
	
	}

	if (!checkbottom(self))
	{
		if (self.flags & FL_ONGROUND)
		{	
			self.touch = SUB_Null;
			self.think = voreling_jump1;
			self.nextthink = time + 0.1;
		}
		return;	// not on ground yet
	}


	sound (self, CHAN_VOICE, "voreling/land.wav", 1, ATTN_NORM);
	self.touch = SUB_Null;
	self.think = voreling_run1;
	self.nextthink = time + 0.1;
};


void()	Voreling_FallCheck =
{

	if (self.health <= 0)
		return;
		
	if (checkbottom(self))
	{
		self.think = voreling_run1;		
		self.touch = SUB_Null;
		self.nextthink = time + 0.1;
	}


	return;
};






//void() voreling_drop1   =[      $dangle1,       voreling_drop2    ] {self.nextthink = time + 0.3;};

void() voreling_drop1   =[      $fall5,       voreling_fall1    ] 
{
	self.touch = Voreling_DropTouch;
	
	self.th_stand = voreling_stand1;
	self.th_walk = voreling_walk1;
	self.th_run = voreling_run1;
	self.th_die = voreling_die;
	self.th_pain = voreling_pain;
	self.th_melee = voreling_attack1;
	self.th_missile = vling_jump;
	
	
	
	self.flags = self.flags - FL_ONGROUND;
	self.velocity =  '0 0 -320';
	self.pain_finished = time + 1;
	
	if (self.health <= 0)
		self.th_die();
  
};



void() voreling_fall1   =[      $fall1,       voreling_fall2    ] {Voreling_FallCheck();};
void() voreling_fall2   =[      $fall2,       voreling_fall3    ] {Voreling_FallCheck();};
void() voreling_fall3   =[      $fall3,       voreling_fall4    ] {Voreling_FallCheck();};
void() voreling_fall4   =[      $fall4,       voreling_fall5    ] {Voreling_FallCheck();};
void() voreling_fall5   =[      $fall5,       voreling_fall2    ] {Voreling_FallCheck();};






void() vling_start =
{
	local vector	org;

	if (!(self.spawnflags & TRIGGER_SPAWNSILENT))
	{
	        org = self.origin + 16 * v_forward;
	        spawn_tfog (org);
	}

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	
	setmodel (self, "progs/voreling.mdl");
	setsize (self, '-16 -16 -24', '16 16 32');
	self.health = 65;
	
	self.yaw_speed = 25;

	monster_spawn();

        walkmonster_start_go();
};

void()  vling_begin =
{
	if (self.delay == 1)
		self.nextthink = time + random() * 0.4;
	else
		self.nextthink = time + 0.1 + random ()*0.1;
	self.think = vling_start;
};




//=================================================================

/*QUAKED monster_voreling (1 0 0) (-32 -32 -24) (32 32 48) Ambush
*/
void() monster_voreling =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model ("progs/voreling.mdl");
	precache_model ("progs/h_shal.mdl");
	precache_model ("progs/vleg.mdl");
	

	precache_sound ("voreling/death.wav");
	precache_sound ("voreling/idle.wav");
	precache_sound ("voreling/pain.wav");
	precache_sound ("voreling/sight.wav");
	
	precache_sound ("voreling/land.wav");
	precache_sound ("voreling/bite.wav");
	precache_sound ("voreling/bitestrt.wav");	
	



	if (self.dangle == 1)
	{
		self.th_stand = voreling_ceiling0;
		self.th_walk = voreling_drop1;
		self.th_run = voreling_drop1;
		self.th_die = voreling_drop1;
		self.th_pain = voreling_drop1;
		self.th_melee = voreling_drop1;
		self.th_missile = voreling_drop1;
	}
	else
	{
		self.th_stand = voreling_stand1;
		self.th_walk = voreling_walk1;
		self.th_run = voreling_run1;
		self.th_die = voreling_die;
		self.th_pain = voreling_pain;
		self.th_melee = voreling_attack1;
		self.th_missile = vling_jump;
		
	}

	if (self.spawnflags & TRIGGER_SPAWN)
	{
		self.use = vling_begin;
		total_monsters = total_monsters + 1;
		return;
	}

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	
	setmodel (self, "progs/voreling.mdl");
	setsize (self, '-16 -16 -24', '16 16 32');
	self.health = 65;
	
	self.yaw_speed = 25;
	
	self.think = walkmonster_start;
	self.nextthink = time + 0.1 + random ()*0.1;	

};

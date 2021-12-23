/*
==============================================================================

BALROG 

==============================================================================
*/

$cd /raid/quake/id1/models/balrog
$origin 0 -6 24
$base base		
$skin skin0
$skin skin1

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8 stand9
$frame stand10 stand11 stand12 stand13

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8
$frame walk9 walk10 walk11 walk12 walk13 walk14 walk15   

$frame run1 run2 run3 run4 run5 run6 run7 

$frame pain1 pain2 pain3 pain4 pain5 pain6 pain7 pain8 pain9

$frame paina1 paina2 paina3 paina4 paina5 

$frame atk1 atk2 atk3 atk4 atk5 atk6 atk7 atk8 atk9 atk10 atk11 atk12
$frame atk13 atk14

$frame die1 die2 die3 die4 die5 die6 die7 die8 die9 die10 die11 die12
$frame die13 die14 die15 die16 die17 die18 die19

/*
==============================================================================
BALROG LAVABALL CODE
==============================================================================
*/

void() RogLaser_Touch = {
	local vector org;
	
	if (other == self.owner) return; // don't explode on owner
	if (pointcontents(self.origin) == CONTENT_SKY) { remove(self); return; }
	
	sound (self, CHAN_WEAPON, SOUND_LASER_HIT, 1, ATTN_STATIC);
	org = self.origin - 8*normalize(self.velocity);

	if (other.health) {
		SpawnBlood (org, self.velocity*0.2, 15);
		T_Damage (other, self, self.owner, 15);
	} else {
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_GUNSHOT);
		WriteCoord (MSG_BROADCAST, org_x);
		WriteCoord (MSG_BROADCAST, org_y);
		WriteCoord (MSG_BROADCAST, org_z);
	}
	remove(self);	
};

void(vector org, vector vec) RogLaunchLaser = {	
	if (self.classname == "monster_enforcer")
		sound (self, CHAN_WEAPON, SOUND_LASER_FIRE, 1, ATTN_NORM);

	vec = normalize(vec);
	
	newmis = spawn();
	newmis.classname = "enforcer_laser";	//gnounc
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLY;
	newmis.solid = SOLID_BBOX;
	newmis.effects = EF_DIMLIGHT;

	setmodel (newmis, "progs/lavaball.mdl");
	setsize (newmis, '0 0 0', '0 0 0');		

	setorigin (newmis, org);

	newmis.velocity = vec * 600;
	newmis.angles = vectoangles(newmis.velocity);

	newmis.nextthink = time + 5;
	newmis.think = SUB_Remove;
	newmis.touch = RogLaser_Touch;
};



void() blrog_fire =
{
	local vector org;

	self.effects = self.effects | EF_MUZZLEFLASH;
//	makevectors2 (self.angles);
	
	org = self.origin + v_forward * 30 + v_right * 1 + '0 0 16';

	RogLaunchLaser(org, self.enemy.origin - self.origin);
};

/*
==============================================================================
BALROG CODE
==============================================================================
*/

void()	blrog_stand1	=[	$stand1,        blrog_stand2	] 
{
	if (random() < 0.2)
		sound (self, CHAN_VOICE, "rog/idle1.wav", 1, ATTN_IDLE);
      ai_stand();
};
void()	blrog_stand2	=[	$stand2,	blrog_stand3	] {ai_stand();};
void()	blrog_stand3	=[	$stand3,	blrog_stand4	] {ai_stand();};
void()	blrog_stand4	=[	$stand4,	blrog_stand5	] {ai_stand();};
void()	blrog_stand5	=[	$stand5,	blrog_stand6	] {ai_stand();};
void()	blrog_stand6	=[	$stand6,	blrog_stand7	] {ai_stand();};
void()	blrog_stand7	=[	$stand7,	blrog_stand8	] {ai_stand();};
void()	blrog_stand8	=[	$stand8,	blrog_stand9	] {ai_stand();};
void()	blrog_stand9	=[	$stand9,	blrog_stand10	] {ai_stand();};
void()	blrog_stand10	=[	$stand10,	blrog_stand11	] {ai_stand();};
void()	blrog_stand11	=[	$stand11,	blrog_stand12	] {ai_stand();};
void()	blrog_stand12	=[	$stand12,	blrog_stand13	] {ai_stand();};
void()	blrog_stand13	=[	$stand13,	blrog_stand1	] {ai_stand();};


void()	blrog_walk1	=[	$walk1, 	blrog_walk2	] 
{
	if (random() < 0.2)
		sound (self, CHAN_VOICE, "rog/idle1.wav", 1, ATTN_IDLE);
	ai_walk(2);
};
void()	blrog_walk2	=[	$walk2, 	blrog_walk3	] {ai_walk(3);};
void()	blrog_walk3	=[	$walk3, 	blrog_walk4	] {ai_walk(5);};
void()	blrog_walk4	=[	$walk4, 	blrog_walk5	] {ai_walk(6);};
void()	blrog_walk5	=[	$walk5, 	blrog_walk6	] {ai_walk(8);};
void()	blrog_walk6	=[	$walk6, 	blrog_walk7	] {ai_walk(5);};
void()	blrog_walk7	=[	$walk7, 	blrog_walk8	] {ai_walk(3);};
void()	blrog_walk8	=[	$walk8, 	blrog_walk9	] {ai_walk(2);};
void()	blrog_walk9	=[	$walk9, 	blrog_walk10	] {ai_walk(3);};
void()	blrog_walk10	=[	$walk10,	blrog_walk11	] {ai_walk(4);};
void()	blrog_walk11	=[	$walk11,	blrog_walk12	] {ai_walk(6);};
void()	blrog_walk12	=[	$walk12,	blrog_walk13	] {ai_walk(8);};
void()	blrog_walk13	=[	$walk13, 	blrog_walk14	] {ai_walk(5);};
void()	blrog_walk14	=[	$walk14,	blrog_walk15	] {ai_walk(3);};
void()	blrog_walk15	=[	$walk15,	blrog_walk1	] {ai_walk(2);};


void()	blrog_run1	=[	$run1,		blrog_run2	]          
{
	if (random() < 0.2)
		sound (self, CHAN_VOICE, "rog/bite.wav", 1, ATTN_IDLE);
	ai_run(11);
};
void()	blrog_run2	=[	$run2,		blrog_run3	] {ai_run(15);};
void()	blrog_run3	=[	$run3,		blrog_run4	] {ai_run(10);};
void()	blrog_run4	=[	$run4,		blrog_run5	] {ai_run(10);};
void()	blrog_run5	=[	$run5,		blrog_run6	] {ai_run(8);};
void()	blrog_run6	=[	$run6,		blrog_run7	] {ai_run(15);};
void()	blrog_run7	=[	$run7,		blrog_run1	] {ai_run(10);};

void()	blrog_atk1	=[	$atk1,  	blrog_atk2	] {ai_face();};
void()	blrog_atk2	=[	$atk2,  	blrog_atk3	] {ai_face();};
void()	blrog_atk3	=[	$atk3,  	blrog_atk4	] {ai_face();};
void()	blrog_atk4	=[	$atk4,  	blrog_atk5	] {ai_face();};
void()	blrog_atk5	=[	$atk5,  	blrog_atk6	] {ai_face();};
void()	blrog_atk6	=[	$atk6,  	blrog_atk7	] {ai_face();};
void()	blrog_atk7	=[	$atk7,  	blrog_atk8	] {ai_face();};
void()	blrog_atk8	=[	$atk8,  	blrog_atk9	] {blrog_fire();};
void()	blrog_atk9	=[	$atk9,  	blrog_atk10	] {ai_face();};
void()	blrog_atk10	=[	$atk10, 	blrog_atk11	] {ai_face();};
void()	blrog_atk11	=[	$atk11, 	blrog_atk12	] {ai_face();};
void()	blrog_atk12	=[	$atk12, 	blrog_atk13	] {ai_face();};
void()	blrog_atk13	=[	$atk13, 	blrog_atk14	] {ai_face();};
void()	blrog_atk14	=[	$atk14, 	blrog_run1	] {};

void()	blrog_pain1	=[	$pain1, 	blrog_pain2	] 
{
	if (random() < 0.2)
		sound (self, CHAN_VOICE, "rog/pain1.wav", 1, ATTN_IDLE);
	ai_walk(4);
};
void()	blrog_pain2	=[	$pain2, 	blrog_pain3	] {};
void()	blrog_pain3	=[	$pain3, 	blrog_pain4	] {};
void()	blrog_pain4	=[	$pain4, 	blrog_pain5	] {};
void()	blrog_pain5	=[	$pain5, 	blrog_pain6	] {};
void()	blrog_pain6	=[	$pain6, 	blrog_pain7	] {};
void()	blrog_pain7	=[	$pain7, 	blrog_pain8	] {};
void()	blrog_pain8	=[	$pain8, 	blrog_pain9	] {};
void()	blrog_pain9	=[	$pain9, 	blrog_run1	] {};

void()	blrog_paina1	=[	$paina1, 	blrog_paina2	] 
{
	if (random() < 0.2)
		sound (self, CHAN_VOICE, "rog/pain2.wav", 1, ATTN_IDLE);
	ai_walk(4);
};
void()	blrog_paina2	=[	$paina2, 	blrog_paina3	] {};
void()	blrog_paina3	=[	$paina3, 	blrog_paina4	] {};
void()	blrog_paina4	=[	$paina4, 	blrog_paina5	] {};
void()	blrog_paina5	=[	$paina5, 	blrog_run1	] {};

void(entity attacker, float damage)	blrog_pain =
{
	local float r;

	if (self.pain_finished > time)
		return;

	r = random();
	
	if (r < 0.85)
	{
		blrog_pain1 ();
		self.pain_finished = time + 1;
	}
	else
	{
		blrog_paina1 ();
		self.pain_finished = time + 1;
	}

};

void()	blrog_die1	=[	$die1,  	blrog_die2	] {};
void()	blrog_die2	=[	$die2,  	blrog_die3	] {};
void()	blrog_die3	=[	$die3,  	blrog_die4	] {self.solid = SOLID_NOT;};
void()	blrog_die4	=[	$die4,  	blrog_die5	] {};
void()	blrog_die5	=[	$die5,  	blrog_die6	] {};
void()	blrog_die6	=[	$die6,  	blrog_die7	] {};
void()	blrog_die7	=[	$die7,  	blrog_die8	] {};
void()	blrog_die8	=[	$die8,  	blrog_die9	] {};
void()	blrog_die9	=[	$die9,  	blrog_die10	] {};
void()	blrog_die10	=[	$die10, 	blrog_die11	] {};
void()	blrog_die11	=[	$die11, 	blrog_die12	] {};
void()	blrog_die12	=[	$die12, 	blrog_die13	] {};
void()	blrog_die13	=[	$die13, 	blrog_die14	] {};
void()	blrog_die14	=[	$die14, 	blrog_die15	] {};
void()	blrog_die15	=[	$die15, 	blrog_die16	] {};
void()	blrog_die16	=[	$die16, 	blrog_die17	] {};
void()	blrog_die17	=[	$die17, 	blrog_die18	] {};
void()	blrog_die18	=[	$die18, 	blrog_die19	] {};
void()	blrog_die19	=[	$die19, 	blrog_die19	] {};

void() blrog_die = {
	// regular death
	sound (self, CHAN_VOICE, "rog/death1.wav", 1, ATTN_NORM);
	blrog_die1();
	self.solid = SOLID_NOT;
};

void() blrog_pause = {
	sound ( self, CHAN_VOICE, "statue/see.wav", 1, ATTN_NORM);
   
	self.takedamage = DAMAGE_AIM;
	self.th_stand = blrog_stand1;
	self.th_walk = blrog_walk1;
	self.th_run = blrog_run1;
	self.th_melee = blrog_atk1;
	self.th_pain = blrog_pain;
	self.th_die = blrog_die;
	self.use = SUB_Null;
	self.think = blrog_run1;
	self.enemy = activator;
	self.nextthink = time + 0.1;
	self.think = FoundTarget;
	self.delay = 0;
};

void() blrog_pause1 = {
	self.takedamage = DAMAGE_NO;
	self.use = blrog_pause;
	self.think = blrog_pause1;
    self.nextthink = time + 0.1;
};

/*QUAKED monster_balrog (1 0 0) (-16 -16 -24) (16 16 40) Ambush*/

void() monster_balrog = {	
	// Check for any random monster setups
	if (monster_checkrandomizer() == TRUE) return;
	// Check all spawn exceptions (monsters.qc)
	if (monster_checkspawn() == TRUE) return;
	
	precache_model ("progs/madfox/mon_balrog.mdl");
	precache_model ("progs/h_guard.mdl");
	precache_model ("progs/gib1.mdl");
	precache_model ("progs/gib2.mdl");
	precache_model ("progs/gib3.mdl");

	if (self.spawnflags & 2) {
		// statue
		precache_model ( "progs/statgib1.mdl");
		precache_model ( "progs/statgib2.mdl");
		precache_model ( "progs/statgib3.mdl");
		precache_sound ( "rogue/statue/see.wav");
		precache_sound ( "ad171/statue/idle1.wav");
		precache_sound ( "rogue/statue/pain.wav");
		precache_sound ( "rogue/statue/death.wav");
	} else {
		precache_sound ("rog/death1.wav");
		precache_sound ("rog/idle1.wav");
		precache_sound ("rog/pain1.wav");
		precache_sound ("rog/pain2.wav");
		precache_sound ("rog/atck.wav");
		precache_sound ("rog/bite.wav");
    }

	precache_sound ("player/udeath.wav");		// gib death
	precache_sound (SOUND_LASER_HIT);
	precache_sound (SOUND_LASER_FIRE);

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/madfox/mon_balrog.mdl");

	setsize (self, '-16 -16 -24', '16 16 32');
	self.health = 200;
//	self.max_health = 200;

	if (self.spawnflags & 2) {
		 // statue
		if (self.frame == 0) self.frame = 44;
		self.skin = 1;

		if (!self.targetname) {
			dprint ("statue not targeted\n");
			dprint (self.classname);
			dprint (" at ");
			dprint (vtos(self.origin));
			dprint ("\n");
			return;
		}
					
		self.use = blrog_pause;
        self.th_stand = blrog_pause1;
        self.th_walk = blrog_pause1;
		self.th_run = blrog_pause1;
/*
        self.th_stand = blrog_pause1;
        self.th_walk = blrog_pause;
		self.th_run = blrog_pause;
		self.th_melee = blrog_atk1;
		self.th_pain = blrog_pause;
		self.th_die = blrog_die;
*/
	} else {
		self.th_stand = blrog_stand1;
		self.th_walk = blrog_walk1;
		self.th_run = blrog_run1;
		self.th_missile =  blrog_atk1; 
		self.th_pain = blrog_pain;
		self.th_die = blrog_die;
    } 
	monster_start ();
};
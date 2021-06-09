$cd keep/madfox/mon_fragy
$origin 0 0 24
$base base		
$skin skin

$frame djerk1 djerk2 djerk3 djerk4 djerk5 djerk6 djerk7 djerk8 djerk9 djerk10 djerk11 djerk12
$frame rach1 rach2 rach3 rach4 rach5 rach6 rach7 rach8 rach9 rach10 rach11 rach12
$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9
$frame pedle1 pedle2 pedle3 pedle4 pedle5 pedle6 pedle7 pedle8 pedle9
$frame padle1 padle2 padle3 padle4 padle5 padle6 padle7 padle8 padle9 padle10 padle11 padle12 padle13 padle14 padle15 padle16 padle17
$frame artk1 artk2 artk3 artk4 artk5 artk6 artk7 artk8 artk9
$frame pain1 pain2 pain3 pain4 pain5 pain6 pain7 pain8
$frame death1 death2 death3 death4 death5 death6 death7 death8 death9 death10 death11 death12 death13
$frame swim1 swim2 swim3 swim4 swim5 swim6 swim7 swim8 swim9 swim10 swim11 swim12 swim13
$frame frog1 frog2 frog3 frog4 frog5 frog6 frog7 frog8 frog9 frog10 frog11 frog12 frog13
$frame jump1 jump2 jump3 jump4 jump5 jump6 jump7 jump8 jump9 jump10 jump11 jump12 jump13 jump14 jump15 

void() frag_run1;
void() frag_jump1;

void()	Frag_JumpTouch = {
	local	float	ldmg;

	if (self.health <= 0) return;
		
	if (other.takedamage) {
		if ( vlen(self.velocity) > 300 ) {
			ldmg = 10 + 10*random();
			ldmg = Align_DamageModifier(other,self,ldmg, TRUE);
			T_Damage (other, self, self, ldmg, DAMARMOR);	
		}
	}

	if (!checkbottom(self)) {
		if (self.flags & FL_ONGROUND) {
		// jump randomly to not get hung up
		//dprint ("popjump\n");
		self.touch = SUB_Null;
		self.think = frag_jump1;
		self.nextthink = time + 0.1;

		//self.velocity_x = (random() - 0.5) * 600;
		//self.velocity_y = (random() - 0.5) * 600;
		//self.velocity_z = 200;
		//self.flags = self.flags - FL_ONGROUND;
		}
		return;	// not on ground yet
	}

	self.touch = SUB_Null;
	self.think = frag_run1;
	self.nextthink = time + 0.1;
};

void()	frag_stand1	=[	$djerk1,	frag_stand2	] {ai_stand();monster_idle_sound();};
void()	frag_stand2	=[	$djerk2,	frag_stand3	] {ai_stand();};
void()	frag_stand3	=[	$djerk3,	frag_stand4	] {ai_stand();};
void()	frag_stand4	=[	$djerk4,	frag_stand5	] {ai_stand();};
void()	frag_stand5	=[	$djerk5,	frag_stand6	] {ai_stand();};
void()	frag_stand6	=[	$djerk6,	frag_stand7	] {ai_stand();};
void()	frag_stand7	=[	$djerk7,	frag_stand8	] {ai_stand();};
void()	frag_stand8	=[	$djerk8,	frag_stand9	] {ai_stand();};
void()	frag_stand9	=[	$djerk9,	frag_stand10	] {ai_stand();};
void()	frag_stand10	=[	$djerk10,	frag_stand11	] {ai_stand();};
void()	frag_stand11	=[	$djerk11,	frag_stand12	] {ai_stand();};
void()	frag_stand12	=[	$djerk12,	frag_stand1	] {ai_stand();};

void()	frag_walk1	=[	$walk1, 	frag_walk2	] {ai_walk(1);monster_idle_sound();};
void()	frag_walk2	=[	$walk2, 	frag_walk3	] {ai_walk(3);};
void()	frag_walk3	=[	$walk3, 	frag_walk4	] {ai_walk(5);};
void()	frag_walk4	=[	$walk4, 	frag_walk5	] {ai_walk(6);};
void()	frag_walk5	=[	$walk5 ,	frag_walk6	] {ai_walk(8);};
void()	frag_walk6	=[	$walk6, 	frag_walk7	] {ai_walk(3);};
void()	frag_walk7	=[	$walk7, 	frag_walk8	] {ai_walk(5);};
void()	frag_walk8	=[	$walk8, 	frag_walk9	] {ai_walk(6);};
void()	frag_walk9	=[	$walk9, 	frag_walk1	] {ai_walk(8);};

void()	frag_run1	=[	$pedle1, 	frag_run2	] {ai_run(6);monster_idle_sound();};
void()	frag_run2	=[	$pedle2, 	frag_run3	] {ai_run(8);};
void()	frag_run3	=[	$pedle3, 	frag_run4	] {ai_run(10);};
void()	frag_run4	=[	$pedle4, 	frag_run5	] {ai_run(14);};
void()	frag_run5	=[	$pedle5 ,	frag_run6	] {ai_run(18);};
void()	frag_run6	=[	$pedle6, 	frag_run7	] {ai_run(20);};
void()	frag_run7	=[	$pedle7, 	frag_run8	] {ai_run(24);};
void()	frag_run8	=[	$pedle8, 	frag_run9	] {ai_run(10);};
void()	frag_run9	=[	$pedle9, 	frag_run1	] {ai_run(4);};

void()	frag_swim1	=[	$swim1, 	frag_swim2  ] {ai_run(4);};
void()	frag_swim2	=[	$swim2, 	frag_swim3	] {ai_run(4);};
void()	frag_swim3	=[	$swim3, 	frag_swim4	] {ai_run(4);};
void()	frag_swim4	=[	$swim4, 	frag_swim5	] {ai_run(4);};
void()	frag_swim5	=[	$swim5, 	frag_swim6	] {ai_run(8);};
void()	frag_swim6	=[	$swim6, 	frag_swim7	] {ai_run(12);};
void()	frag_swim7	=[	$swim7, 	frag_swim8	] {ai_run(18);};
void()	frag_swim8	=[	$swim8, 	frag_swim9	] {ai_run(20);};
void()	frag_swim9	=[	$swim9, 	frag_swim10	] {ai_run(24);};
void()	frag_swim10	=[	$swim10, 	frag_swim11	] {ai_run(16);};
void()	frag_swim11	=[	$swim11, 	frag_swim12	] {ai_run(10);};
void()	frag_swim12	=[	$swim12, 	frag_swim1	] {ai_run(4);};

void()	frag_atack1	=[	$artk1, 	frag_atack2	] {};
void()	frag_atack2	=[	$artk2, 	frag_atack3	] {};
void()	frag_atack3	=[	$artk3, 	frag_atack4	] {};
void()	frag_atack4	=[	$artk4, 	frag_atack5	] {};
void()	frag_atack5	=[	$artk5, 	frag_atack6	] {ai_melee();};
void()	frag_atack6	=[	$artk6, 	frag_atack7	] {ai_melee();};
void()	frag_atack7	=[	$artk7, 	frag_atack8	] {ai_melee();};
void()	frag_atack8	=[	$artk8, 	frag_atack9	] {ai_melee();};
void()	frag_atack9	=[	$artk9, 	frag_run1	] {};

void() frag_jump1 =[       $jump1,        frag_jump2        ] {};
void() frag_jump2 =[       $jump2,        frag_jump3        ] {
	ai_face();
	
	self.touch = Frag_JumpTouch;
	makevectors (self.angles);
	self.origin_z = self.origin_z + 1;
	self.velocity = v_forward * 300 + '0 0 200';
	if (self.flags & FL_ONGROUND)
		self.flags = self.flags - FL_ONGROUND;
};

void() frag_jump3 =[       $jump3,        frag_jump4        ] {sound (self, CHAN_VOICE, "ad171/gibs/gibhit1.wav", 1, ATTN_NORM);};
void() frag_jump4 =[       $jump4,        frag_jump5        ] {};
void() frag_jump5 =[       $jump5,        frag_jump6        ] {};
void() frag_jump6 =[       $jump6,        frag_jump7        ] {};
void() frag_jump7 =[       $jump7,        frag_jump8        ] {};
void() frag_jump8 =[       $jump8,        frag_jump9        ] {};
void() frag_jump9 =[       $jump9,        frag_jump10       ] {};
void() frag_jump10 =[      $jump10,       frag_jump11       ] {};
void() frag_jump11 =[      $jump11,       frag_jump12       ] {};
void() frag_jump12 =[      $jump12,       frag_jump13       ] {};
void() frag_jump13 =[      $jump13,       frag_jump14       ] {};
void() frag_jump14 =[      $jump14,       frag_jump15       ] {};
void() frag_jump15 =[      $jump15,       frag_run1         ] {sound (self, CHAN_VOICE, "quoth/voreling/land.wav", 1, ATTN_NORM);};

void()	frag_pain1	=[	$pain1, 	frag_pain2	] {};
void()	frag_pain2	=[	$pain2, 	frag_pain3	] {};
void()	frag_pain3	=[	$pain3, 	frag_pain4	] {};
void()	frag_pain4	=[	$pain4, 	frag_pain5	] {};
void()	frag_pain5	=[	$pain5, 	frag_pain6	] {};
void()	frag_pain6	=[	$pain6, 	frag_pain7	] {};
void()	frag_pain7	=[	$pain7, 	frag_pain8	] {};
void()	frag_pain8	=[	$pain8, 	frag_run1	] {};

void(entity inflictor, entity attacker, float damage) frag_pain = {
	if (self.pain_finished > time) return;
	
	sound (self, CHAN_VOICE, "knight/khurt.wav", 1, ATTN_NORM);
	frag_pain1 ();
	self.pain_finished = time + 1;
};

void() frag_grounddie2;

void() frag_die1 =[       $death1,        frag_die2        ] {monster_check_gib();if (pointcontents(self.origin) > CONTENT_WATER) {self.think = frag_grounddie2;}};
void() frag_die2 =[       $death2,        frag_die3        ] {self.solid = SOLID_NOT;};	
void() frag_die3 =[       $death3,        frag_die4        ] {};
void() frag_die4 =[       $death4,        frag_die5        ] {};
void() frag_die5 =[       $death5,        frag_die6        ] {};
void() frag_die6 =[       $death6,        frag_die7        ] {};
void() frag_die7 =[       $death7,        frag_die8        ] {};
void() frag_die8 =[       $death8,        frag_die9        ] {};
void() frag_die9 =[       $death9,        frag_die10       ] {};
void() frag_die10 =[      $death10,       frag_die11       ] {};
void() frag_die11 =[      $death11,       frag_die12       ] {};
void() frag_die12 =[      $death12,       frag_die13       ] {monster_death_postcheck();};
void() frag_die13 =[      $death13,       frag_die13       ] {monster_deadbody_check();};

void() frag_grounddie2 =[       $death2,        frag_grounddie3] {self.solid = SOLID_NOT;};	
void() frag_grounddie3 =[       $death4,        frag_grounddie4] {};
void() frag_grounddie4 =[       $death6,        frag_grounddie5] {};
void() frag_grounddie5 =[       $death8,        frag_grounddie6] {};
void() frag_grounddie6 =[      $death10,       frag_grounddie7 ] {};
void() frag_grounddie7 =[      $death12,       frag_grounddie8 ] {monster_death_postcheck();sound (self, CHAN_VOICE, "quoth/voreling/land.wav", 1, ATTN_NORM);};
void() frag_grounddie8 =[      $death13,       frag_grounddie8 ] {monster_deadbody_check();};

void() frag_die = {
	// Pre-check routine to tidy up extra entities
	monster_death_precheck();

	// regular death
	if (!self.gibbed) {
		if (pointcontents(self.origin) <= CONTENT_WATER) sound (self, CHAN_VOICE, "fish/death.wav", 1, ATTN_NORM);
		else sound (self, CHAN_VOICE, "quoth/voreling/death.wav", 1, ATTN_NORM);
		frag_die1 ();
	}
};

float()	CheckFragJump = {
	local	vector	dist;
	local	float	d;

	if (self.origin_z + self.mins_z > self.enemy.origin_z + self.enemy.mins_z + 0.75 * self.enemy.size_z) return FALSE;
	if (self.origin_z + self.maxs_z < self.enemy.origin_z + self.enemy.mins_z + 0.25 * self.enemy.size_z) return FALSE;
		
	dist = self.enemy.origin - self.origin;
	dist_z = 0;
	
	d = vlen(dist);
	if (d < 80) return FALSE;
	if (d > 150) return FALSE;
		
	return TRUE;
};

//QUAKED monster_fragy (1 0 0) (-16 -16 -24) (16 16 24) Ambush
void() monster_fragy = {
	// Check for any random monster setups
	if (monster_checkrandomizer() == TRUE) return;
	// Check all spawn exceptions (monsters.qc)
	if (monster_checkspawn() == TRUE) return;

	self.mdl = "progs/madfox/mon_fragy.mdl";
	precache_model (self.mdl);
	precache_sound ("fish/death.wav");
	precache_sound ("fish/bite.wav");
	precache_sound ("fish/idle.wav");
	precache_sound ("quoth/voreling/death.wav");
	precache_sound ("quoth/voreling/land.wav");
	precache_sound ("ad171/gibs/gibhit1.wav");

	self.idle_sound = "fish/idle.wav";

	self.solid = SOLID_NOT;				// No interaction with world
	self.movetype = MOVETYPE_NONE;		// Static item, no movement
	if (self.bboxtype < 1) self.bboxtype = BBOX_TINY;
	if (self.health < 1) self.health = 150;
	self.gibhealth = -40;
	self.gibbed = FALSE;
	self.blockudeath = TRUE;			// no humanoid death sound
	self.deathstring = " was slimed by a harmless Frog\n";
	self.no_liquiddmg = TRUE;			// Immune to slime/lava
	
	self.th_stand = frag_stand1;
	self.th_walk = frag_walk1;
	self.th_run = frag_run1;
	self.th_pain = frag_pain;
	self.th_die = frag_die;
	self.th_melee = frag_atack1;
    self.th_missile = frag_jump1;
	self.th_checkattack = FragCheckAttack;

	// Always reset Ammo Resistance to be consistent
	self.resist_shells = self.resist_nails = 0;
	self.resist_rockets = self.resist_cells = 0;

	// Check for random rotation setup and angle limits
	if (self.angles_y < 0) self.angles_y = rint(random()*359);
	if (self.angles_y > 360) self.angles_y = 360;

	// Standard DENIZEN AI
	if (!self.alignment) self.alignment = NEUTRAL;
	if (!self.passive_state) self.passive_state = 1;
	if (!self.temperament) self.temperament = TEMPRA_PASSIVE;
	if (!self.vulnerability) self.vulnerability = VULN_RESISTANT;

	self.classtype = CT_MONFROG;
	self.classgroup = CG_HARMLESS;
	self.classmove = MON_MOVEWALK;

	monster_start ();
};

void() monster_frog = {self.classname = "monster_fragy"; monster_fragy(); };
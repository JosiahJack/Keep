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

void() frag_stand1;
void() frag_walk1;
void() frag_walkb1;
void() frag_run1;
void() frag_jump1;
void() frag_flyatack1;
void() frag_standb1;
void() frag_swim1;
void() frag_swimwalk1;
void() frag_frog1;

// Changes whether we are a swimmer or a walker
void() frog_mode = {
	if (InWater(self.origin) || InSlime(self.origin)
        || InWater(self.origin + '0 0 -25') || InSlime (self.origin + '0 0 -25')) {
		if (!self.lefty && self.attack_finished < time) {
			self.attack_finished = time + 0.5;
			self.lefty = TRUE;
			if (self.enemy) self.think = frag_swim1;
			else if (self.movetarget) self.think = frag_swimwalk1;
			else self.think = frag_frog1;
			self.nextthink = time + 0.05;
		}
	} else {
		if (self.lefty && self.attack_finished < time) {
			self.attack_finished = time + 0.5;
			self.lefty = FALSE;
			if (self.enemy) self.think = frag_run1;
			else if (self.movetarget) self.think = frag_walk1;
			else self.think = frag_stand1;
		}
	}
};

void()	Frag_JumpTouch = {
	local	float	ldmg;

	if (self.attack_finished >= time) return;

	self.attack_finished = time + 0.2;
	if (!(other.flags & FLx_CREATURE)) return;
	if (self.health <= 0) return;
	if (!self.enemy) return;
		
	if (other.takedamage) {
		if (vlen(self.velocity) > 200 ) {
			ldmg = 10 + 10*random();
			ldmg = Align_DamageModifier(other,self,ldmg, TRUE);
			T_Damage(other, self, self, ldmg, DAMARMOR);	
		}
	}

	if (!checkbottom(self)) {
		if (self.flags & FL_ONGROUND) {
			// jump randomly to not get hung up
			self.touch = SUB_Null;
			self.think = frag_jump1;
			self.nextthink = time + 0.1;

			self.velocity_x = (random() - 0.5) * 50;
			self.velocity_y = (random() - 0.5) * 50;
			self.velocity_z = 80;
			self.flags = self.flags - FL_ONGROUND;
		}
		return;	// not on ground yet
	}

	self.touch = SUB_Null;
	if (self.enemy) self.think = frag_run1;
	else self.think = frag_walk1;

	self.nextthink = time + 0.1;
};

void()	frag_stand1	=[	$djerk1,	frag_stand2	] {ai_stand();if (random() < 0.5) self.think = frag_standb1; frog_mode();};
void()	frag_stand2	=[	$djerk2,	frag_stand3	] {ai_stand();monster_idle_sound(); frog_mode();};
void()	frag_stand3	=[	$djerk3,	frag_stand4	] {ai_stand(); frog_mode();};
void()	frag_stand4	=[	$djerk4,	frag_stand5	] {ai_stand(); frog_mode();};
void()	frag_stand5	=[	$djerk5,	frag_stand6	] {ai_stand(); frog_mode();};
void()	frag_stand6	=[	$djerk6,	frag_stand7	] {ai_stand(); frog_mode();};
void()	frag_stand7	=[	$djerk7,	frag_stand8	] {ai_stand(); frog_mode();};
void()	frag_stand8	=[	$djerk8,	frag_stand9	] {ai_stand(); frog_mode();};
void()	frag_stand9	=[	$djerk9,	frag_stand10] {ai_stand(); frog_mode();};
void()	frag_stand10=[	$djerk10,	frag_stand11] {ai_stand(); if (random() < 0.5) self.think = frag_flyatack1; frog_mode();};
void()	frag_stand11=[	$djerk11,	frag_stand12] {ai_stand(); frog_mode();};
void()	frag_stand12=[	$djerk12,	frag_stand1	] {ai_stand(); frog_mode();};

void()	frag_standb1 =[	$rach1,	frag_standb2	] {ai_stand();monster_idle_sound(); frog_mode();};
void()	frag_standb2 =[	$rach2,	frag_standb3	] {ai_stand(); frog_mode();};
void()	frag_standb3 =[	$rach3,	frag_standb4	] {ai_stand(); frog_mode();};
void()	frag_standb4 =[	$rach4,	frag_standb5	] {ai_stand(); frog_mode();};
void()	frag_standb5 =[	$rach5,	frag_standb6	] {ai_stand(); frog_mode();};
void()	frag_standb6 =[	$rach6,	frag_standb7	] {ai_stand(); frog_mode();};
void()	frag_standb7 =[	$rach7,	frag_standb8	] {ai_stand(); frog_mode();};
void()	frag_standb8 =[	$rach8,	frag_standb9	] {ai_stand(); frog_mode();};
void()	frag_standb9 =[	$rach9,	frag_standb10	] {ai_stand(); frog_mode();};
void()	frag_standb10=[	$rach10,frag_standb11	] {ai_stand(); frog_mode();};
void()	frag_standb11=[	$rach11,frag_standb12	] {ai_stand(); frog_mode();};
void()	frag_standb12=[	$rach12,frag_stand1	] {ai_stand();};

// Harmlessly eat a fly (same anim as attacking though).
void()	frag_flyatack1	=[	$artk1, frag_flyatack2	] {self.nextthink = time + 0.05;};
void()	frag_flyatack2	=[	$artk2, frag_flyatack3	] {self.nextthink = time + 0.05;};
void()	frag_flyatack3	=[	$artk3, frag_flyatack4	] {self.nextthink = time + 0.05;};
void()	frag_flyatack4	=[	$artk4, frag_flyatack5	] {self.nextthink = time + 0.05;};
void()	frag_flyatack5	=[	$artk5, frag_flyatack6	] {self.nextthink = time + 0.05;};
void()	frag_flyatack6	=[	$artk6, frag_flyatack7	] {self.nextthink = time + 0.05;};
void()	frag_flyatack7	=[	$artk7, frag_flyatack8	] {self.nextthink = time + 0.05;};
void()	frag_flyatack8	=[	$artk8, frag_flyatack9	] {self.nextthink = time + 0.05;};
void()	frag_flyatack9	=[	$artk9, frag_stand1	] {self.nextthink = time + 0.05;};

void()	frag_walk1	=[	$walk1, 	frag_walk2	] {ai_walk(1); if (random() < 0.5) self.think = frag_walkb1; frog_mode();};
void()	frag_walk2	=[	$walk2, 	frag_walk3	] {ai_walk(3);monster_idle_sound(); frog_mode();};
void()	frag_walk3	=[	$walk3, 	frag_walk4	] {ai_walk(4); frog_mode();};
void()	frag_walk4	=[	$walk4, 	frag_walk5	] {ai_walk(5); if (random() < 0.2) self.think = frag_jump1; frog_mode();};
void()	frag_walk5	=[	$walk5 ,	frag_walk6	] {ai_walk(7); frog_mode();};
void()	frag_walk6	=[	$walk6, 	frag_walk7	] {ai_walk(3); frog_mode();};
void()	frag_walk7	=[	$walk7, 	frag_walk8	] {ai_walk(4); frog_mode();};
void()	frag_walk8	=[	$walk8, 	frag_walk9	] {ai_walk(5); frog_mode();};
void()	frag_walk9	=[	$walk9, 	frag_walkb1	] {ai_walk(6); frog_mode();};

void()	frag_walkb1	=[	$padle1, 	frag_walkb2	] {ai_stand(); monster_idle_sound(); frog_mode();};
void()	frag_walkb2	=[	$padle2, 	frag_walkb3	] {ai_stand(); frog_mode();};
void()	frag_walkb3	=[	$padle3, 	frag_walkb4	] {ai_stand(); frog_mode();};
void()	frag_walkb4	=[	$padle4, 	frag_walkb5	] {ai_stand(); frog_mode();};
void()	frag_walkb5	=[	$padle5 ,	frag_walkb6	] {ai_stand(); frog_mode();};
void()	frag_walkb6	=[	$padle6, 	frag_walkb7	] {ai_stand(); frog_mode();};
void()	frag_walkb7	=[	$padle7, 	frag_walkb8	] {ai_walk(1); frog_mode();};
void()	frag_walkb8	=[	$padle8, 	frag_walkb9	] {ai_walk(2);sound(self,CHAN_VOICE,"ad171/gibs/gibhit1.wav",0.5,ATTN_NORM); frog_mode();};
void()	frag_walkb9	=[	$padle9, 	frag_walkb10] {ai_walk(4); frog_mode();};
void()	frag_walkb10=[	$padle10, 	frag_walkb11] {ai_walk(18); frog_mode();};
void()	frag_walkb11=[	$padle11, 	frag_walkb12] {ai_walk(12); frog_mode();};
void()	frag_walkb12=[	$padle12, 	frag_walkb13] {ai_walk(8); frog_mode();};
void()	frag_walkb13=[	$padle13, 	frag_walkb14] {ai_walk(8); frog_mode();};
void()	frag_walkb14=[	$padle14,	frag_walkb15] {ai_walk(8); frog_mode();};
void()	frag_walkb15=[	$padle15, 	frag_walkb16] {ai_walk(6); frog_mode();};
void()	frag_walkb16=[	$padle16, 	frag_walkb17] {ai_walk(4); frog_mode();};
void()	frag_walkb17=[	$padle17, 	frag_walk1	] {ai_walk(1); frog_mode();};

void()	frag_run1	=[	$pedle1, 	frag_run2	] {ai_run(6);monster_idle_sound(); frog_mode();};
void()	frag_run2	=[	$pedle2, 	frag_run3	] {ai_run(8); frog_mode();};
void()	frag_run3	=[	$pedle3, 	frag_run4	] {ai_run(10); frog_mode();};
void()	frag_run4	=[	$pedle4, 	frag_run5	] {ai_run(14); frog_mode();};
void()	frag_run5	=[	$pedle5 ,	frag_run6	] {ai_run(18); frog_mode();};
void()	frag_run6	=[	$pedle6, 	frag_run7	] {ai_run(20); frog_mode();};
void()	frag_run7	=[	$pedle7, 	frag_run8	] {ai_run(24); frog_mode();};
void()	frag_run8	=[	$pedle8, 	frag_run9	] {ai_run(10); frog_mode();};
void()	frag_run9	=[	$pedle9, 	frag_run1	] {ai_run(4); frog_mode();};

void()	frag_swimwalk1	=[	$frog1, frag_swimwalk2  ] {ai_fish_movement("ai_walk",2); monster_idle_sound(); frog_mode();};
void()	frag_swimwalk2	=[	$frog2, frag_swimwalk3  ] {ai_fish_movement("ai_walk",2); frog_mode();};
void()	frag_swimwalk3	=[	$frog3, frag_swimwalk4  ] {ai_fish_movement("ai_walk",4); frog_mode();};
void()	frag_swimwalk4	=[	$frog4, frag_swimwalk5  ] {ai_fish_movement("ai_walk",5); frog_mode();};
void()	frag_swimwalk5	=[	$frog5, frag_swimwalk6  ] {ai_fish_movement("ai_walk",6); frog_mode();};
void()	frag_swimwalk6	=[	$frog6, frag_swimwalk7  ] {ai_fish_movement("ai_walk",7); frog_mode();};
void()	frag_swimwalk7	=[	$frog7, frag_swimwalk8  ] {ai_fish_movement("ai_walk",8); frog_mode();};
void()	frag_swimwalk8	=[	$frog8, frag_swimwalk9  ] {ai_fish_movement("ai_walk",9); frog_mode();};
void()	frag_swimwalk9	=[	$frog9, frag_swimwalk10  ] {ai_fish_movement("ai_walk",12); frog_mode();};
void()	frag_swimwalk10	=[	$frog10, frag_swimwalk11  ] {ai_fish_movement("ai_walk",11); frog_mode();};
void()	frag_swimwalk11	=[	$frog11, frag_swimwalk12  ] {ai_fish_movement("ai_walk",10); frog_mode();};
void()	frag_swimwalk12	=[	$frog12, frag_swimwalk13  ] {ai_fish_movement("ai_walk",8); frog_mode();};
void()	frag_swimwalk13	=[	$frog13, frag_swimwalk1  ] {ai_fish_movement("ai_walk",4); frog_mode();};

void()	frag_frog1	=[	$frog1, 	frag_frog2  ] {ai_stand();monster_idle_sound();  frog_mode();};
void()	frag_frog2	=[	$frog2, 	frag_frog3  ] {ai_stand(); frog_mode();};
void()	frag_frog3	=[	$frog3, 	frag_frog4  ] {ai_stand(); frog_mode();};
void()	frag_frog4	=[	$frog4, 	frag_frog5  ] {ai_stand(); frog_mode();};
void()	frag_frog5	=[	$frog5, 	frag_frog6  ] {ai_stand(); frog_mode();};
void()	frag_frog6	=[	$frog6, 	frag_frog7  ] {ai_stand(); frog_mode();};
void()	frag_frog7	=[	$frog7, 	frag_frog8  ] {ai_stand(); frog_mode();};
void()	frag_frog8	=[	$frog8, 	frag_frog9  ] {ai_stand(); frog_mode();};
void()	frag_frog9	=[	$frog9, 	frag_frog10  ] {ai_stand(); frog_mode();};
void()	frag_frog10	=[	$frog10, 	frag_frog11  ] {ai_stand(); frog_mode();};
void()	frag_frog11	=[	$frog12, 	frag_frog12  ] {ai_stand(); frog_mode();};
void()	frag_frog12	=[	$frog13, 	frag_frog1  ] {ai_stand(); frog_mode();};

void()	frag_swim1	=[	$swim1, 	frag_swim2  ] {ai_fish_movement("ai_run",4);monster_idle_sound();  frog_mode();};
void()	frag_swim2	=[	$swim2, 	frag_swim3	] {ai_fish_movement("ai_run",4); frog_mode();};
void()	frag_swim3	=[	$swim3, 	frag_swim4	] {ai_fish_movement("ai_run",4); frog_mode();};
void()	frag_swim4	=[	$swim4, 	frag_swim5	] {ai_fish_movement("ai_run",4); frog_mode();};
void()	frag_swim5	=[	$swim5, 	frag_swim6	] {ai_fish_movement("ai_run",8); frog_mode();};
void()	frag_swim6	=[	$swim6, 	frag_swim7	] {ai_fish_movement("ai_run",12); frog_mode();};
void()	frag_swim7	=[	$swim7, 	frag_swim8	] {ai_fish_movement("ai_run",18); frog_mode();};
void()	frag_swim8	=[	$swim8, 	frag_swim9	] {ai_fish_movement("ai_run",20); frog_mode();};
void()	frag_swim9	=[	$swim9, 	frag_swim10	] {ai_fish_movement("ai_run",24); frog_mode();};
void()	frag_swim10	=[	$swim10, 	frag_swim11	] {ai_fish_movement("ai_run",16); frog_mode();};
void()	frag_swim11	=[	$swim11, 	frag_swim12	] {ai_fish_movement("ai_run",10); frog_mode();};
void()	frag_swim12	=[	$swim12, 	frag_swim1	] {ai_fish_movement("ai_run",4); frog_mode();};

void()	frag_atack1	=[	$artk1, 	frag_atack2	] {self.nextthink = time + 0.05;};
void()	frag_atack2	=[	$artk2, 	frag_atack3	] {self.nextthink = time + 0.05;};
void()	frag_atack3	=[	$artk3, 	frag_atack4	] {self.nextthink = time + 0.05;};
void()	frag_atack4	=[	$artk4, 	frag_atack5	] {self.nextthink = time + 0.05;};
void()	frag_atack5	=[	$artk5, 	frag_atack6	] {ai_melee();self.nextthink = time + 0.05;};
void()	frag_atack6	=[	$artk6, 	frag_atack7	] {self.nextthink = time + 0.05;};
void()	frag_atack7	=[	$artk7, 	frag_atack8	] {ai_melee();self.nextthink = time + 0.05;};
void()	frag_atack8	=[	$artk8, 	frag_atack9	] {self.nextthink = time + 0.05;};
void()	frag_atack9	=[	$artk9, 	frag_run1	] {self.nextthink = time + 0.05;};

void() frag_jump1 =[       $jump1,        frag_jump2        ] {
	if (lefty) {
		traceline (self.origin + self.view_ofs, self.origin + '0 0 -32', FALSE, self);
		if (trace_fraction == 1) self.think = frag_run1;
	}
};
void() frag_jump2 =[       $jump2,        frag_jump3        ] {
	ai_face();

	if (self.enemy) {
		self.touch = Frag_JumpTouch;
		makevectors(self.angles);
		self.origin_z = self.origin_z + 1;
		self.velocity = v_forward * 300 + '0 0 200';
		if (self.flags & FL_ONGROUND) self.flags = self.flags - FL_ONGROUND;
	} else {
		ai_walk(2);
	}
};
void() frag_jump3 =[       $jump3,        frag_jump4  ] {
	sound(self,CHAN_VOICE,"ad171/gibs/gibhit1.wav",1,ATTN_NORM);self.nextthink = time + 0.05;
	if (self.enemy) ai_run(2);
	else ai_walk(2);
};
void() frag_jump4 =[       $jump4,        frag_jump5  ] {self.nextthink = time + 0.08; if (self.enemy) ai_run(4); else ai_walk(4);};
void() frag_jump5 =[       $jump5,        frag_jump6  ] {self.nextthink = time + 0.08; if (self.enemy) ai_run(6); else ai_walk(6);};
void() frag_jump6 =[       $jump6,        frag_jump7  ] {self.nextthink = time + 0.08; if (self.enemy) ai_run(8); else ai_walk(8);};
void() frag_jump7 =[       $jump7,        frag_jump8  ] {self.nextthink = time + 0.08; if (self.enemy) ai_run(10); else ai_walk(10);};
void() frag_jump8 =[       $jump8,        frag_jump8b  ] {self.nextthink = time + 0.08; if (self.enemy) ai_run(12); else ai_walk(12);};
void() frag_jump8b =[       $jump8,        frag_jump8c  ] {self.nextthink = time + 0.08; if (self.enemy) ai_run(16); else ai_walk(16);};
void() frag_jump8c =[       $jump8,        frag_jump8d  ] {self.nextthink = time + 0.08; if (self.enemy) ai_run(12); else ai_walk(12);};
void() frag_jump8d =[       $jump9,        frag_jump9  ] {self.nextthink = time + 0.08; if (self.enemy) ai_run(10); else ai_walk(10);};
void() frag_jump9 =[       $jump9,        frag_jump10 ] {self.nextthink = time + 0.08; if (self.enemy) ai_run(4); else ai_walk(4);};
void() frag_jump10=[      $jump10,       frag_jump11 ] {self.nextthink = time + 0.08; if (self.enemy) ai_run(2); else ai_walk(2);};
void() frag_jump11=[      $jump11,       frag_jump12 ] {};
void() frag_jump12=[      $jump12,       frag_jump13 ] {};
void() frag_jump13=[      $jump13,       frag_jump14 ] {};
void() frag_jump14=[      $jump14,       frag_jump15 ] {};
void() frag_jump15=[      $jump15,       frag_walk1   ] {
	if (self.enemy) self.think = frag_run1;
	sound(self,CHAN_VOICE,"quoth/voreling/land.wav",1,ATTN_NORM);
	self.nextthink = time + 0.08;
};

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
	
	sound(self, CHAN_VOICE, "knight/khurt.wav", 1, ATTN_NORM);
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

void() monster_fragy_precache = {
	precache_model ("progs/madfox/mon_fragy.mdl");
	precache_sound ("fish/death.wav");
	precache_sound ("fish/bite.wav");
	precache_sound ("fish/idle.wav");
	precache_sound ("quoth/voreling/death.wav");
	precache_sound ("quoth/voreling/land.wav");
	precache_sound ("ad171/gibs/gibhit1.wav");
	precache_sound ("ad171/gibs/gibhit3.wav");
};

//QUAKED monster_fragy (1 0 0) (-16 -16 -24) (16 16 24) Ambush
void() monster_fragy = {
	if (monster_checkrandomizer() == TRUE) return; // Check for any random monster setups
	if (monster_checkspawn() == TRUE) return; // Check all spawn exceptions (monsters.qc)

	self.mdl = "progs/madfox/mon_fragy.mdl";
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
	Resist_ChangeType(self,-1); // Always reset Ammo Resistance to be consistent
	SetDefaultDenizenAttributes(self); // Standard DENIZEN AI
	self.classtype = CT_MONFROG;
	self.classgroup = CG_HARMLESS;
	self.classmove = MON_MOVEWALK;
	monster_start();
};

void() monster_frog = {self.classname = "monster_fragy"; monster_fragy(); };
/*
==============================================================================

Warlord

Model from: Dawn of Darkness Q2-TC (captain.md2)
Quake implementation by Seven

Monster properties:
Based on hellknight code
Additional features:
- can dodge/duck in several animations
- can throw grenades/multi-grenades, standard Hellknight projectiles and homing projectiles
- can perform shield-ram-attack which throws the player back
- can go into immune state

Warlord is fully adjustable via cvars.
Please see cvar descriptions in included smc_config.cfg sample.

==============================================================================
*/

$cd id1/models/hknight2
$origin 0 0 24
$base base
$skin skin

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8 stand9 stand10
$frame stand11 stand12 stand13 stand14 stand15 stand16 stand17 stand18 stand19 stand20
$frame stand21 stand22 stand23 stand24 stand25 stand26 stand27 stand28 stand29 stand30
$frame stand31 stand32 stand33 stand34 stand35 stand36 stand37 stand38 stand39 stand40
$frame stand41 stand42

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9
$frame walk10 walk11 walk12 

$frame run1 run2 run3 run4 run5 run6 run7 run8

$frame pain1 pain2 pain3 pain4 pain5

$frame painb1 painb2 painb3 painb4

$frame death1 death2 death3 death4 death5 death6 death7 death8
$frame death9 death10 death11 death12 death13

$frame deathb1 deathb2 deathb3 deathb4 deathb5 deathb6 deathb7 deathb8
$frame deathb9

$frame char_a1 char_a2 char_a3 char_a4 char_a5 char_a6 char_a7 char_a8
$frame char_a9 char_a10 char_a11 char_a12 char_a13 char_a14 char_a15 char_a16

$frame magica1 magica2 magica3 magica4 magica5 magica6 magica7 magica8
$frame magica9 magica10 magica11 magica12 magica13 magica14

$frame magicb1 magicb2 magicb3 magicb4 magicb5 magicb6 magicb7 magicb8
$frame magicb9 magicb10 magicb11 magicb12 magicb13

$frame char_b1 char_b2 char_b3 char_b4 char_b5 char_b6

$frame slice1 slice2 slice3 slice4 slice5 slice6 slice7 slice8 slice9 slice10

$frame smash1 smash2 smash3 smash4 smash5 smash6 smash7 smash8 smash9 smash10
$frame smash11

$frame w_attack1 w_attack2 w_attack3 w_attack4 w_attack5 w_attack6 w_attack7 
$frame w_attack8 w_attack9 w_attack10 w_attack11 w_attack12 w_attack13 w_attack14
$frame w_attack15 w_attack16 w_attack17 w_attack18 w_attack19 w_attack20 
$frame w_attack21 w_attack22 

$frame magicc1 magicc2 magicc3 magicc4 magicc5 magicc6 magicc7 magicc8
$frame magicc9 magicc10 magicc11

$frame throw1 throw2 throw3 throw4 throw5 throw6 throw7 throw8 throw9 throw10		// neue animation "throw"
$frame throw11 throw12 throw13 throw14 throw15 throw16 throw17 throw18 throw19 throw20
$frame throw21 throw22 throw23 throw24 throw25 throw26 throw27 throw28 throw29 throw30
$frame throw31 throw32 throw33

$frame block1 block2 block3 block4 block5 block6	// neue animation "block"

$frame dodge1 dodge2 dodge3 dodge4 dodge5		// neue animation "dodge"

$frame duck1 duck2 duck3 duck4 duck5 duck6		// neue animation "duck"

$frame shdeath1 shdeath2 shdeath3 shdeath4 shdeath5 shdeath6 shdeath7 shdeath8 shdeath9
$frame shdeath10 shdeath11 shdeath12

$frame naildth1 naildth2 naildth3 naildth4 naildth5 naildth6 naildth7 naildth8 naildth9
$frame naildth10 naildth11 naildth12 naildth13 naildth14 naildth15 naildth16 naildth17 naildth18 naildth19



void() hknight2_char_a1;
void() hknight2_run1;


void(float offset) hknight2_shot =
{
	local	vector	offang;
	local	vector	org, vec;
	
	offang = vectoangles (self.enemy.origin - self.origin);
	offang_y = offang_y + offset * 6;
	
	makevectors (offang);

	org = self.origin + self.mins + self.size*0.5 + v_up * 5 + v_forward * 20;

// set missile speed
	vec = normalize (v_forward);
	vec_z = 0 - vec_z + (random() - 0.5)*0.1;
	
	launch_enemy_spike (org, vec); 
	newmis.classname = "knight2spike";
	if (autocvar_warlord_spike_type)		// use different spike model 
		setmodel (newmis, "progs/k_spike2.mdl");
	else
		setmodel (newmis, "progs/k_spike.mdl");	// use Hellknights spike model 
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);
	newmis.traileffectnum = particleeffectnum("TR_WARLORDSPIKE");
	newmis.velocity = vec*300;
	sound7(self, CHAN_WEAPON, "warlord/attack1.wav", 1, ATTN_NORM, SNDSPD);
};

void() CheckForCharge2 =
{
// check for mad charge
if (!enemy_vis)
	return;
if (time < self.attack_finished)
	return;	
if ( fabs(self.origin_z - self.enemy.origin_z) > 30)
	return;		// too much height change
if ((vlen (self.origin - self.enemy.origin) < 80) || (vlen (self.origin - self.enemy.origin) > 300))
	return;		// use regular attack

// charge		
	SUB_AttackFinished (2);
	hknight2_char_a1 ();

};

void() CheckContinueCharge2 =
{
	if (time > self.attack_finished)
	{
		SUB_AttackFinished (3);
		hknight2_run1 ();
		return;		// done charging
	}
	if (random() > 0.5)
		sound7(self, CHAN_WEAPON, "knight/sword2.wav", 1, ATTN_NORM, SNDSPD);
	else
		sound7(self, CHAN_WEAPON, "knight/sword1.wav", 1, ATTN_NORM, SNDSPD);
};

//===========================================================================

void(float loudness) hknight2_footsteps =
{
if (autocvar_monsterfootsteps == 1)	// only play monster footsteps sound when cvar is 1
	{
	local float select;
	select = random();
	if (select <= 0.33)
		sound7(self, CHAN_AUTO, "walk/hknight1.wav", loudness, ATTN_IDLE, SNDSPD);
	else if (select <= 0.66)
		sound7(self, CHAN_AUTO, "walk/hknight2.wav", loudness, ATTN_IDLE, SNDSPD);
	else 
		sound7(self, CHAN_AUTO, "walk/hknight3.wav", loudness, ATTN_IDLE, SNDSPD);
	}
};


void()	hknight2_stand1	=[	$stand1,	hknight2_stand2	] {ai_stand();self.colormod = '1 1 1';self.nextthink = time + 0.06;};
void()	hknight2_stand2	=[	$stand2,	hknight2_stand3	] {ai_stand();self.nextthink = time + 0.06;};
void()	hknight2_stand3	=[	$stand3,	hknight2_stand4	] {ai_stand();self.nextthink = time + 0.06;};
void()	hknight2_stand4	=[	$stand4,	hknight2_stand5	] {ai_stand();self.nextthink = time + 0.06;};		// Mitte
void()	hknight2_stand5	=[	$stand5,	hknight2_stand6	] {ai_stand();self.nextthink = time + 0.06;
if (random() < 0.2)
	sound7(self, CHAN_VOICE, "warlord/growl.wav", 1, ATTN_NORM, SNDSPD);
};
void()	hknight2_stand6	=[	$stand6,	hknight2_stand7	] {ai_stand();self.nextthink = time + 0.06;};
void()	hknight2_stand7	=[	$stand7,	hknight2_stand8	] {ai_stand();self.nextthink = time + 0.06;};
void()	hknight2_stand8	=[	$stand8,	hknight2_stand9	] {ai_stand();self.nextthink = time + 0.06;};
void()	hknight2_stand9	=[	$stand9,	hknight2_stand10] {ai_stand();self.nextthink = time + 0.06;};
void()	hknight2_stand10=[	$stand10,	hknight2_stand11] {ai_stand();self.nextthink = time + 0.06;};
void()	hknight2_stand11=[	$stand11,	hknight2_stand12] {ai_stand();self.nextthink = time + 0.06;};
void()	hknight2_stand12=[	$stand12,	hknight2_stand13] {ai_stand();self.nextthink = time + 0.06;};
void()	hknight2_stand13=[	$stand13,	hknight2_stand14] {ai_stand();self.nextthink = time + 0.06;};
void()	hknight2_stand14=[	$stand14,	hknight2_stand15] {ai_stand();self.nextthink = time + 0.06;};
void()	hknight2_stand15=[	$stand15,	hknight2_stand16] {ai_stand();self.nextthink = time + 0.06;};
void()	hknight2_stand16=[	$stand16,	hknight2_stand17] {ai_stand();self.nextthink = time + 0.06;};
void()	hknight2_stand17=[	$stand17,	hknight2_stand18] {ai_stand();self.nextthink = time + 0.06;};
void()	hknight2_stand18=[	$stand18,	hknight2_stand19] {ai_stand();self.nextthink = time + 0.06;};
void()	hknight2_stand19=[	$stand19,	hknight2_stand20] {ai_stand();self.nextthink = time + 0.06;};
void()	hknight2_stand20=[	$stand20,	hknight2_stand21] {ai_stand();self.nextthink = time + 0.06;};
void()	hknight2_stand21=[	$stand21,	hknight2_stand22] {ai_stand();self.nextthink = time + 0.06;};
void()	hknight2_stand22=[	$stand22,	hknight2_stand23] {ai_stand();self.nextthink = time + 0.06;};
void()	hknight2_stand23=[	$stand23,	hknight2_stand24] {ai_stand();self.nextthink = time + 0.06;};
void()	hknight2_stand24=[	$stand24,	hknight2_stand25] {ai_stand();self.nextthink = time + 0.06;};
void()	hknight2_stand25=[	$stand25,	hknight2_stand26] {ai_stand();self.nextthink = time + 0.06;};
void()	hknight2_stand26=[	$stand26,	hknight2_stand27] {ai_stand();self.nextthink = time + 0.06;};
void()	hknight2_stand27=[	$stand27,	hknight2_stand28] {ai_stand();self.nextthink = time + 0.06;};
void()	hknight2_stand28=[	$stand28,	hknight2_stand29] {ai_stand();self.nextthink = time + 0.06;};
void()	hknight2_stand29=[	$stand29,	hknight2_stand30] {ai_stand();self.nextthink = time + 0.06;};
void()	hknight2_stand30=[	$stand30,	hknight2_stand31] {ai_stand();self.nextthink = time + 0.06;};
void()	hknight2_stand31=[	$stand31,	hknight2_stand32] {ai_stand();self.nextthink = time + 0.06;};
void()	hknight2_stand32=[	$stand32,	hknight2_stand33] {ai_stand();self.nextthink = time + 0.06;};
void()	hknight2_stand33=[	$stand33,	hknight2_stand34] {ai_stand();self.nextthink = time + 0.06;};
void()	hknight2_stand34=[	$stand34,	hknight2_stand35] {ai_stand();self.nextthink = time + 0.06;};
void()	hknight2_stand35=[	$stand35,	hknight2_stand36] {ai_stand();self.nextthink = time + 0.06;};
void()	hknight2_stand36=[	$stand36,	hknight2_stand37] {ai_stand();self.nextthink = time + 0.06;};
void()	hknight2_stand37=[	$stand37,	hknight2_stand38] {ai_stand();self.nextthink = time + 0.06;};
void()	hknight2_stand38=[	$stand38,	hknight2_stand39] {ai_stand();self.nextthink = time + 0.06;};
void()	hknight2_stand39=[	$stand39,	hknight2_stand40] {ai_stand();self.nextthink = time + 0.06;};
void()	hknight2_stand40=[	$stand40,	hknight2_stand41] {ai_stand();self.nextthink = time + 0.06;};
void()	hknight2_stand41=[	$stand41,	hknight2_stand42] {ai_stand();self.nextthink = time + 0.06;};
void()	hknight2_stand42=[	$stand42,	hknight2_stand1] {ai_stand();self.nextthink = time + 0.06;};

//===========================================================================

void()	hknight2_walk1	=[	$walk1,		hknight2_walk2	] {
if (random() < 0.11)
	sound7(self, CHAN_VOICE, "warlord/growl.wav", 1, ATTN_NORM, SNDSPD);
ai_walk(2);self.colormod = '1 1 1';};
void()	hknight2_walk2	=[	$walk2,		hknight2_walk3	] {ai_walk(4);};
void()	hknight2_walk3	=[	$walk3,		hknight2_walk4	] {ai_walk(5);};
void()	hknight2_walk4	=[	$walk4,		hknight2_walk5	] {ai_walk(4); hknight2_footsteps (0.8);};
void()	hknight2_walk5	=[	$walk5,		hknight2_walk6	] {ai_walk(4);};
void()	hknight2_walk6	=[	$walk6,		hknight2_walk7	] {ai_walk(5);};
void()	hknight2_walk7	=[	$walk7,		hknight2_walk8	] {ai_walk(5);};
void()	hknight2_walk8	=[	$walk8,		hknight2_walk9	] {ai_walk(4);};
void()	hknight2_walk9	=[	$walk9,		hknight2_walk10	] {ai_walk(5);};
void()	hknight2_walk10	=[	$walk10,	hknight2_walk11	] {ai_walk(4); hknight2_footsteps (0.8);};
void()	hknight2_walk11	=[	$walk11,	hknight2_walk12	] {ai_walk(5);};
void()	hknight2_walk12	=[	$walk12,	hknight2_walk1	] {ai_walk(4);};

//===========================================================================

void()	hknight2_run1	=[	$run1,		hknight2_run2	] {
if (random() < 0.1)
	sound7(self, CHAN_VOICE, "warlord/idle.wav", 1, ATTN_NORM, SNDSPD);
ai_run (20); CheckForCharge2 (); self.colormod = '1 1 1';};
void()	hknight2_run2	=[	$run2,		hknight2_run3	] {ai_run(25); hknight2_footsteps (1);};
void()	hknight2_run3	=[	$run3,		hknight2_run4	] {ai_run(18);};
void()	hknight2_run4	=[	$run4,		hknight2_run5	] {ai_run(16);};
void()	hknight2_run5	=[	$run5,		hknight2_run6	] {ai_run(18);};
void()	hknight2_run6	=[	$run6,		hknight2_run7	] {ai_run(25); hknight2_footsteps (1);};
void()	hknight2_run7	=[	$run7,		hknight2_run8	] {ai_run(18);};
void()	hknight2_run8	=[	$run8,		hknight2_run1	] {ai_run(13);};

//============================================================================

void()	hknight2_pain1	=[	$pain1,		hknight2_pain2	] {sound7(self, CHAN_VOICE, "warlord/pain2.wav", 1, ATTN_NORM, SNDSPD);self.colormod = '1 1 1';};
void()	hknight2_pain2	=[	$pain2,		hknight2_pain3	] {};
void()	hknight2_pain3	=[	$pain3,		hknight2_pain4	] {};
void()	hknight2_pain4	=[	$pain4,		hknight2_pain5	] {};
void()	hknight2_pain5	=[	$pain5,		hknight2_run1	] {};

//============================================================================

void()	hknight2_painb1	=[	$painb1,	hknight2_painb2	] {sound7(self, CHAN_VOICE, "warlord/pain1.wav", 1, ATTN_NORM, SNDSPD);self.colormod = '1 1 1';};
void()	hknight2_painb2	=[	$painb2,	hknight2_painb3	] {};
void()	hknight2_painb3	=[	$painb3,	hknight2_painb4	] {};
void()	hknight2_painb4	=[	$painb4,	hknight2_run1	] {};

//============================================================================


void() hknight2_dieburn1	=[	$deathb1,	hknight2_dieburn2	] {self.burnz_origin = 12;
burn_toggle_allround();
};
void() hknight2_dieburn2	=[	$deathb2,	hknight2_dieburn3	] {self.burnz_origin = 10;
};
void() hknight2_dieburn3	=[	$deathb3,	hknight2_dieburn4	] {self.burnz_origin = 6;
self.solid = SOLID_NOT;
};
void() hknight2_dieburn4	=[	$deathb4,	hknight2_dieburn5	] {self.burnz_origin = 3;
};
void() hknight2_dieburn5	=[	$deathb5,	hknight2_dieburn6	] {self.burnz_origin = 0;
};
void() hknight2_dieburn6	=[	$deathb6,	hknight2_dieburn7	] {self.burnz_origin = -2;
};
void() hknight2_dieburn7	=[	$deathb7,	hknight2_dieburn8	] {self.burnz_origin = -4;
};
void() hknight2_dieburn8	=[	$deathb8,	hknight2_dieburn9	] {self.burnz_origin = -6;
};
void() hknight2_dieburn9	=[	$deathb9,	hknight2_dieburn9	] {self.burnz_origin = -8;
};


var float autocvar_warlord = 5;     		// set cvar 'warlord' default to 5
var float autocvar_warlordcorpsehealth = 60;	// set cvar 'warlordcorpsehealth' default to 60
var float autocvar_warlordcorpseburnable = 0;	// set cvar 'warlordcorpseburnable' default to 0


//SSG DEATH

void()	hknight2_ssgdie1	=[	$shdeath1,	hknight2_ssgdie2	] {sound7(self, CHAN_VOICE, "player/gibsplit.wav", 1, ATTN_IDLE, SNDSPD);};
void()	hknight2_ssgdie2	=[	$shdeath2,	hknight2_ssgdie3	] {};
void()	hknight2_ssgdie3	=[	$shdeath3,	hknight2_ssgdie4	] {self.solid = SOLID_NOT;};
void()	hknight2_ssgdie4	=[	$shdeath4,	hknight2_ssgdie5	] {};
void()	hknight2_ssgdie5	=[	$shdeath5,	hknight2_ssgdie6	] {sound7(self, CHAN_VOICE, "warlord/shielddrop.wav", 1, ATTN_IDLE, SNDSPD);};
void()	hknight2_ssgdie6	=[	$shdeath6,	hknight2_ssgdie7	] {ai_back(1);};
void()	hknight2_ssgdie7	=[	$shdeath7,	hknight2_ssgdie8	] {};
void()	hknight2_ssgdie8	=[	$shdeath8,	hknight2_ssgdie9	] {};
void()	hknight2_ssgdie9	=[	$shdeath9,	hknight2_ssgdie10	] {};
void()	hknight2_ssgdie10	=[	$shdeath10,	hknight2_ssgdie11	] {};
void()	hknight2_ssgdie11	=[	$shdeath11,	hknight2_ssgdie12	] {sound7(self, CHAN_AUTO, "warlord/fall.wav", 1, ATTN_IDLE, SNDSPD);};
void()	hknight2_ssgdie12	=[	$shdeath12,	hknight2_ssgdie12	] {
	setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
		if (autocvar_warlordcorpseburnable == 1)		// corpses are burnable
		self.burnable_corpse = 1;
// 	auto_cvar 'knightcorpsehealth' has been set to  default = 60  in code above already
	self.delete_painskin = 1;		 	 // remove painskin 
	CopyMonsterToBodyQue(autocvar_warlordcorpsehealth, "progs/gib_warleg.mdl");};
//Above is corpse gibbing code - FIND CORPSE

//END SSG DEATH

//NG DEATH

void()	hknight2_naildie1	=[	$naildth1,	hknight2_naildie2	] {sound7(self, CHAN_VOICE, "soldier/decap.wav", 1, ATTN_IDLE, SNDSPD);};
void()	hknight2_naildie2	=[	$naildth2,	hknight2_naildie3	] {};
void()	hknight2_naildie3	=[	$naildth3,	hknight2_naildie4	] {self.solid = SOLID_NOT;};
void()	hknight2_naildie4	=[	$naildth4,	hknight2_naildie5	] {};
void()	hknight2_naildie5	=[	$naildth5,	hknight2_naildie6	] {};
void()	hknight2_naildie6	=[	$naildth6,	hknight2_naildie7	] {ai_back(1);};
void()	hknight2_naildie7	=[	$naildth7,	hknight2_naildie8	] {sound7(self, CHAN_VOICE, "warlord/shielddrop.wav", 1, ATTN_IDLE, SNDSPD);};
void()	hknight2_naildie8	=[	$naildth8,	hknight2_naildie9	] {};
void()	hknight2_naildie9	=[	$naildth9,	hknight2_naildie10	] {};
void()	hknight2_naildie10	=[	$naildth10,	hknight2_naildie11	] {};
void()	hknight2_naildie11	=[	$naildth11,	hknight2_naildie12	] {};
void()	hknight2_naildie12	=[	$naildth12,	hknight2_naildie13	] {};
void()	hknight2_naildie13	=[	$naildth13,	hknight2_naildie14	] {self.solid = SOLID_NOT;};
void()	hknight2_naildie14	=[	$naildth14,	hknight2_naildie15	] {};
void()	hknight2_naildie15	=[	$naildth15,	hknight2_naildie16	] {};
void()	hknight2_naildie16	=[	$naildth16,	hknight2_naildie17	] {ai_back(1);};
void()	hknight2_naildie17	=[	$naildth17,	hknight2_naildie18	] {};
void()	hknight2_naildie18	=[	$naildth18,	hknight2_naildie19	] {sound7(self, CHAN_AUTO, "warlord/fall.wav", 1, ATTN_IDLE, SNDSPD);if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
		pointparticles(particleeffectnum("blood_facepl"), self.origin, '0 0 0', 1);};
void()	hknight2_naildie19	=[	$naildth19,	hknight2_naildie19	] {
		if (autocvar_warlordcorpseburnable == 1)		// corpses are burnable
		self.burnable_corpse = 1;
// 	auto_cvar 'knightcorpsehealth' has been set to  default = 60  in code above already
	self.delete_painskin = 1;		 	 // remove painskin 
	CopyMonsterToBodyQue(autocvar_warlordcorpsehealth, "progs/gib_warnail_t.mdl");};
//Above is corpse gibbing code - FIND CORPSE


//END NG DEATH

//SNG DEATH

void()	hknight2_sngdie1	=[	$naildth1,	hknight2_sngdie2	] {sound7(self, CHAN_VOICE, "soldier/decap.wav", 1, ATTN_IDLE, SNDSPD);};
void()	hknight2_sngdie2	=[	$naildth2,	hknight2_sngdie3	] {sound7(self, CHAN_VOICE, "player/gib.wav", 1, ATTN_IDLE, SNDSPD);};
void()	hknight2_sngdie3	=[	$naildth3,	hknight2_sngdie4	] {self.solid = SOLID_NOT;};
void()	hknight2_sngdie4	=[	$naildth4,	hknight2_sngdie5	] {};
void()	hknight2_sngdie5	=[	$naildth5,	hknight2_sngdie6	] {};
void()	hknight2_sngdie6	=[	$naildth6,	hknight2_sngdie7	] {ai_back(1);};
void()	hknight2_sngdie7	=[	$naildth7,	hknight2_sngdie8	] {sound7(self, CHAN_AUTO, "warlord/shielddrop.wav", 1, ATTN_IDLE, SNDSPD);};
void()	hknight2_sngdie8	=[	$naildth8,	hknight2_sngdie9	] {};
void()	hknight2_sngdie9	=[	$naildth9,	hknight2_sngdie10	] {};
void()	hknight2_sngdie10	=[	$naildth10,	hknight2_sngdie11	] {};
void()	hknight2_sngdie11	=[	$naildth11,	hknight2_sngdie12	] {};
void()	hknight2_sngdie12	=[	$naildth12,	hknight2_sngdie13	] {};
void()	hknight2_sngdie13	=[	$naildth13,	hknight2_sngdie14	] {self.solid = SOLID_NOT;};
void()	hknight2_sngdie14	=[	$naildth14,	hknight2_sngdie15	] {};
void()	hknight2_sngdie15	=[	$naildth15,	hknight2_sngdie16	] {};
void()	hknight2_sngdie16	=[	$naildth16,	hknight2_sngdie17	] {ai_back(1);};
void()	hknight2_sngdie17	=[	$naildth17,	hknight2_sngdie18	] {};
void()	hknight2_sngdie18	=[	$naildth18,	hknight2_sngdie19	] {sound7(self, CHAN_AUTO, "warlord/fall.wav", 1, ATTN_IDLE, SNDSPD);if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
		pointparticles(particleeffectnum("blood_facepl"), self.origin, '0 0 0', 1);};
void()	hknight2_sngdie19	=[	$naildth19,	hknight2_sngdie19	] {
		if (autocvar_warlordcorpseburnable == 1)		// corpses are burnable
		self.burnable_corpse = 1;
// 	auto_cvar 'knightcorpsehealth' has been set to  default = 60  in code above already
	self.delete_painskin = 1;		 	 // remove painskin 
	CopyMonsterToBodyQue(autocvar_warlordcorpsehealth, "progs/gib_warleg1.mdl");};
//Above is corpse gibbing code - FIND CORPSE


//END SNG DEATH


void()	hknight2_die1	=[	$death1,	hknight2_die2	] {self.colormod = '1 1 1';self.nextthink = time + 0.12;};
void()	hknight2_die2	=[	$death2,	hknight2_die3	] {self.nextthink = time + 0.13;};
void()	hknight2_die3	=[	$death3,	hknight2_die4	] {self.solid = SOLID_NOT; ai_back(3);};
void()	hknight2_die4	=[	$death4,	hknight2_die5	] {ai_back(4);};
void()	hknight2_die5	=[	$death5,	hknight2_die6	] {ai_back(5);};
void()	hknight2_die6	=[	$death6,	hknight2_die7	] {ai_back(1);sound7(self, CHAN_AUTO, "warlord/fall.wav", 1, ATTN_IDLE, SNDSPD);};
void()	hknight2_die7	=[	$death7,	hknight2_die8	] {};
void()	hknight2_die8	=[	$death8,	hknight2_die9	] {};
void()	hknight2_die9	=[	$death9,	hknight2_die10	] {};
void()	hknight2_die10	=[	$death10,	hknight2_die11	] {};
void()	hknight2_die11	=[	$death11,	hknight2_die12	] {};
void()	hknight2_die12	=[	$death12,	hknight2_die13	] {self.nextthink = time + 0.03;};
void()	hknight2_die13	=[	$death13,	hknight2_die13	] {setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
local float zufall, zet, randomness;
	zet = 21;					// z-position of the wings (in relation to soul). Dependent on corpse size.
	setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
	if (autocvar_warlordcorpseburnable == 1)	// corpses are burnable
		self.burnable_corpse = 1;
// 	auto_cvar 'warlordcorpsehealth' has been set to  default = 60  in code above already
	self.delete_painskin = 1;		 	 // remove painskin
	CopyMonsterToBodyQue(autocvar_warlordcorpsehealth, "progs/h_warlord.mdl");
if (self.nodeathanim == 1)
	return;
if (self.grimrock_helper == 0)
{
// 	auto_cvar 'warlord' has been declared in code above already
	var float autocvar_warlordrandomness = 25;     	// set cvar 'warlordrandomness' default to 25%
	autocvar_warlordrandomness = autocvar_warlordrandomness * 0.01;
	if (autocvar_warlord == 1)		// if 'warlord' is set via autoexec.cfg to '1' start ghost effect
		{
		randomness = random();
		if (randomness <= autocvar_warlordrandomness)	// checks if death animation shall be started
			ghost_die ();
		}
	else if (autocvar_warlord == 2)				// if 'warlord' is set via autoexec.cfg to '2' start soul effect
		{
		randomness = random();
		if (randomness <= autocvar_warlordrandomness)	// checks if death animation shall be started
			soul ("progs/warlord.mdl", $death13, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
		}
	else if (autocvar_warlord == 3)				// if 'warlord' is set via autoexec.cfg to '3' start vengeance effect
		{
		randomness = random();
		if (randomness <= autocvar_warlordrandomness)	// checks if death animation shall be started
			vengeance_hknight2 ("progs/warlord.mdl", $death13); 
		}
	else if (autocvar_warlord == 5)		// if 'warlord' is set via autoexec.cfg to '5' start randomly one of these Death animations: 
		{				// (Ancient ghosts of the fallen ; Relieved souls of the enslaved ; Vengeance of the deceased)
		randomness = random();		// chance for effects (approx.): 36% / 26% / 38%
		if (randomness <= autocvar_warlordrandomness)	// checks if death animation shall be started --> depending on monsters _randomness
			{					
			zufall = random();
			if (zufall > 0.64)
				ghost_die ();
			else if (zufall < 0.26)
				soul ("progs/warlord.mdl", $death13, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
			else
				vengeance_hknight2 ("progs/warlord.mdl", $death13);
			}
		}
	else				// if 'warlord' is set via autoexec.cfg to another value (example '0'), do nothing !
	{
	}
}
else if (self.grimrock_helper == 1)	// this new code is the the ending of cvar value "6" (which was started in monsters _die function)
	{
	zufall = random();
	if (zufall > 0.64)
		ghost_die ();
	else if (zufall < 0.26)
		soul ("progs/warlord.mdl", $death13, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
	else
		vengeance_hknight2 ("progs/warlord.mdl", $death13);
	}
};

void()	hknight2_dieb1	=[	$deathb1,	hknight2_dieb2	] {ai_back(5);self.colormod = '1 1 1';};
void()	hknight2_dieb2	=[	$deathb2,	hknight2_dieb3	] {ai_back(5);};
void()	hknight2_dieb3	=[	$deathb3,	hknight2_dieb4	] {ai_back(5);self.solid = SOLID_NOT;};
void()	hknight2_dieb4	=[	$deathb4,	hknight2_dieb5	] {ai_back(3);};
void()	hknight2_dieb5	=[	$deathb5,	hknight2_dieb6	] {sound7(self, CHAN_AUTO, "warlord/fall.wav", 1, ATTN_IDLE, SNDSPD);};
void()	hknight2_dieb6	=[	$deathb6,	hknight2_dieb7	] {};
void()	hknight2_dieb7	=[	$deathb7,	hknight2_dieb8	] {};
void()	hknight2_dieb8	=[	$deathb8,	hknight2_dieb9	] {};
void()	hknight2_dieb9	=[	$deathb9,	hknight2_dieb9	] {setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
local float zufall, zet, randomness;
	zet = 21;					// z-position of the wings (in relation to soul). Dependent on corpse size.
	if (autocvar_warlordcorpseburnable == 1)	// corpses are burnable
		self.burnable_corpse = 1;
// 	auto_cvar 'warlordcorpsehealth' has been set to  default = 60  in code above already
	self.delete_painskin = 1;		 	 // remove painskin
	CopyMonsterToBodyQue(autocvar_warlordcorpsehealth, "progs/h_warlord.mdl");
if (self.nodeathanim == 1)
	return;
if (self.grimrock_helper == 0)
{
// 	auto_cvar 'warlord' has been declared in code above already
	var float autocvar_warlordrandomness = 25;     	// set cvar 'warlordrandomness' default to 25%
	autocvar_warlordrandomness = autocvar_warlordrandomness * 0.01;
	if (autocvar_warlord == 1)		// if 'warlord' is set via autoexec.cfg to '1' start ghost effect
		{
		randomness = random();
		if (randomness <= autocvar_warlordrandomness)	// checks if death animation shall be started
			ghost_die ();
		}
	else if (autocvar_warlord == 2)		// if 'warlord' is set via autoexec.cfg to '2' start soul effect
		{
		randomness = random();
		if (randomness <= autocvar_warlordrandomness)	// checks if death animation shall be started
			soul ("progs/warlord.mdl", $deathb9, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
		}
	else if (autocvar_warlord == 3)		// if 'warlord' is set via autoexec.cfg to '3' start vengeance effect
		{
		randomness = random();
		if (randomness <= autocvar_warlordrandomness)	// checks if death animation shall be started
			vengeance_hknight2 ("progs/warlord.mdl", $deathb9); 
		}
	else if (autocvar_warlord == 5)		// if 'warlord' is set via autoexec.cfg to '5' start randomly one of these Death animations: 
		{				// (Ancient ghosts of the fallen ; Relieved souls of the enslaved ; Vengeance of the deceased)
		randomness = random();		// chance for effects (approx.): 36% / 26% / 38%
		if (randomness <= autocvar_warlordrandomness)	// checks if death animation shall be started --> depending on monsters _randomness
			{					
			zufall = random();
			if (zufall > 0.64)
				ghost_die ();
			else if (zufall < 0.26)
				soul ("progs/warlord.mdl", $deathb9, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
			else
				vengeance_hknight2 ("progs/warlord.mdl", $deathb9);
			}
		}
	else				// if 'warlord' is set via autoexec.cfg to another value (example '0'), do nothing !
	{
	}
}
else if (self.grimrock_helper == 1)	// this new code is the the ending of cvar value "6" (which was started in monsters _die function)
	{
	zufall = random();
	if (zufall > 0.64)
		ghost_die ();
	else if (zufall < 0.26)
		soul ("progs/warlord.mdl", $deathb9, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
	else
		vengeance_hknight2 ("progs/warlord.mdl", $deathb9);
	}
};



void(float maxgibs, float gibscounter) producegibs_hknight2 =	// creates as many gib-sets as defined in cvar 'gibsmultiplier'
{
if (gibscounter >= maxgibs)
	return;
else
	{
	ThrowGib ("progs/w_wshield.mdl", self.health);
	ThrowGib ("progs/gib_warleg.mdl", self.health);
	ThrowGib ("progs/gib_warleg.mdl", self.health);
	ThrowGib ("progs/gib_wararm.mdl", self.health); 	
	}
gibscounter = gibscounter + 1;
producegibs_hknight2 (maxgibs, gibscounter);
};


void()	hknight2_lightning_death	=[	$death1,	hknight2_lightning_death1	] {
self.delete_painskin = 1;			  // remove painskin
if (autocvar_lightninggun_death_animation == 2)	  // start the "fade" effect instead of "coal" effect
	lightninggun_death_fade();
};

void()	hknight2_lightning_death1 =[	$death1,	hknight2_lightning_death1	] {
self.solid = SOLID_NOT;
self.baked = 1;
self.colormod = '0.25 0.22 0.22';	// skins gets darker (looks burned)
CopyMonsterToBodyQue(1, "progs/h_warlord.mdl");
};


void() hknight2_die =
{
self.touch = SUB_Null;
if (autocvar_lightninggun_death_animation)		// if 'lightninggun_death_animation' is enabled
	{
	if (self.enemy.weapon == IT_LIGHTNING && (self.enemy.meleeing == 0))		// when enemy was killed with lightning gun, go into baked mode
		{
		hknight2_lightning_death();
		return;
		}
	}
	else if (!self.shocked && self.enemy.weapon == IT_LIGHTNING && self.sticky != 1)
	{
		lg_death1();
		return;
	}
	
local float maxgibs, gibscounter;
// check for gib
	if (self.health < -40)
	{
		self.delete_painskin = 1;	// remove painskin
		gibbed_monsters = gibbed_monsters + 1;
		if (autocvar_slowmotion >= 1)	// start slowmotion when gibbing living enemies
			{
			if (random () <= (autocvar_slowmotion_randomness_warlord * 0.01))
				{
				the_matrix = 1;
				matrixcounter = time + (autocvar_slowmotion_intensity * autocvar_slowmotion_duration);	// Attention: formula needed to take the intensity into account. Time increase is much more when slowmo is active ! (time + 1 will be approx. 3seconds with slowmo 0.33 !)
				}
			}
		play_gibsound();
		var float autocvar_gibsmultiplier = 1;         	// set cvar 'gibsmultiplier' default to 1
		//Comment below section to stop gibsmultiplier from overriding unique gib models
			/*if (autocvar_gibsmultiplier == 1)		// if 'gibsmultiplier' doesnt exist in autoexec.cfg, or if 'gibsmultiplier' is set via autoexec.cfg to '1'
				{
				ThrowHead ("progs/h_warlord.mdl", self.health);
				ThrowGib ("progs/w_wshield.mdl", self.health);
				ThrowGib ("progs/gib_warleg.mdl", self.health);
				ThrowGib ("progs/w_wsword.mdl", self.health); 
				if (autocvar_heartgib >= 1)		// if 'heartgib' doesnt exist in autoexec.cfg, or if 'heartgib' is set via autoexec.cfg to '1' or higher
					ThrowHeart ("progs/gibheart.mdl", self.health);
				if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
					pointparticles(particleeffectnum("blood_monster_gib"), self.origin, '0 0 0', 1);
				return;
				}*/
			//else 							// if 'gibsmultiplier' is set via autoexec.cfg to any other value than '1'
				//{						// --> produce more gibs
				ThrowHead ("progs/h_warlord.mdl", self.health);
				if (autocvar_heartgib >= 1)		// if 'heartgib' doesnt exist in autoexec.cfg, or if 'heartgib' is set via autoexec.cfg to '1' or higher
					ThrowHeart ("progs/gibheart.mdl", self.health);
				maxgibs = autocvar_gibsmultiplier;
				gibscounter = 0;
				gibdeath_effects();
				producegibs_hknight2 (maxgibs, gibscounter);
				return;
				//}
	}

// regular death

local float zufall, randomness;
// auto_cvar 'warlord' has been declared in code above already
var float autocvar_warlordrandomness = 25;     	// set cvar 'warlordrandomness' default to 25%
autocvar_warlordrandomness = autocvar_warlordrandomness * 0.01;
if (autocvar_warlord == 4)		// if 'warlord' is set via autoexec.cfg to '4' start Death animation with "Legend of Grimrock" effect
	{
	randomness = random();
	if (randomness <= autocvar_warlordrandomness)	// checks if death animation shall be started
		{
		//Gyro_Object_ClearPhysics(self);	// ENABLE this line if you want to disable GYRO during new "Legend of Grimrock" animation !!
		self.delete_painskin = 1;		// remove painskin
		hknight2_dieburn1();
		return;			// jump out of this function !!
		}
	}
if (autocvar_warlord == 6)		// if 'warlord' is set via autoexec.cfg to '6' start random Death animation (all 4 effects !!)
	{				// chance for effects (approx.): 25% / 25% / 25% / 25%  
	randomness = random();
	if (randomness <= autocvar_warlordrandomness)	// checks if death animation shall be started --> depending on monsters _randomness
		{					
		zufall = random();
		if (zufall <= 0.26)
			{
			//Gyro_Object_ClearPhysics(self);   // ENABLE this line if you want to disable GYRO during new "Legend of Grimrock" animation !!
			self.delete_painskin = 1;	    // remove painskin
			hknight2_dieburn1();
			return;		// jump out of this function !!
			}		// if zufall is bigger than 0.26, use new code inside  upcoming function  for other 3 death animations
		else 
			self.grimrock_helper = 1;	// this float helps me to manipulate the other 3 death animations
		}
	else
		self.grimrock_helper = 2;	// this float helps me to manipulate the other 3 death animations
	}

// if 'warlord' has another value is checked inside prior function (= death animation function)

	if (autocvar_slowmotion >= 3)	// start slowmotion when regular killing living enemies
		{
		if (random () <= (autocvar_slowmotion_randomness_warlord * 0.01))
			{
			the_matrix = 1;
			matrixcounter = time + (autocvar_slowmotion_intensity * autocvar_slowmotion_duration);	// Attention: formula needed to take the intensity into account. Time increase is much more when slowmo is active ! (time + 1 will be approx. 3seconds with slowmo 0.33 !)
			}
		}
	sound7(self, CHAN_VOICE, "warlord/death1.wav", 1, ATTN_NORM, SNDSPD);
	if (random() > 0.5)
		hknight2_die1 ();
	else
		hknight2_dieb1 ();
		
	//FATALITY
	
	if (self.enemy.meleeing == 0) //check before all fatalities to make sure attack type is not a kick
	{
		if (self.enemy.weapon == IT_SUPER_SHOTGUN)
			{
				if (random() < 0.8)
				{
					if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
						pointparticles(particleeffectnum("blood_monster_gib"), self.origin, '0 0 0', 1);
					ThrowGib ("progs/chop.mdl", self.health);
					ThrowGib ("progs/chop.mdl", self.health);
					ThrowGib ("progs/chop.mdl", self.health);
					self.delete_painskin = 1;
					if (self.skin == 0)
					{
						setmodel (self, self.model = "progs/warlordblast.mdl");
						//self.monstermodel = 2;
						self.skin = 0;
						ThrowGib ("progs/h_warlordblast.mdl", self.health);
						ThrowGib ("progs/gib_wararm.mdl", self.health);
					}
					else
					{
						setmodel (self, self.model = "progs/warlordblast.mdl");
						//self.monstermodel = 2;
						ThrowGib ("progs/h_warlordblast1.mdl", self.health);
						ThrowGib ("progs/gib_wararm.mdl", self.health);
						self.skin = 1;
					}

					hknight2_ssgdie1();
				}
			}
		if (self.enemy.weapon == IT_NAILGUN)
			{
				if (random() < 0.8)
				{
					if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
						pointparticles(particleeffectnum("blood_facepl"), self.origin, '0 0 0', 1);
					ThrowGib ("progs/chop.mdl", self.health);
					ThrowGib ("progs/chop.mdl", self.health);
					ThrowGib ("progs/chop.mdl", self.health);
					self.delete_painskin = 1;
					if (self.skin == 0)
					{
						setmodel (self, self.model = "progs/warlordnail.mdl");
						//self.monstermodel = 2;
						self.skin = 0;
					}
					else
					{
						setmodel (self, self.model = "progs/warlordnail.mdl");
						//self.monstermodel = 2;
						self.skin = 1;
					}

					hknight2_naildie1();
				}
			}
		if (self.enemy.weapon == IT_SUPER_NAILGUN)
			{
				if (random() < 0.8)
				{
					if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
						pointparticles(particleeffectnum("blood_monster_gib"), self.origin, '0 0 0', 1);
					ThrowGib ("progs/chop.mdl", self.health);
					ThrowGib ("progs/chop.mdl", self.health);
					StickGib ("progs/gib_warnail_t.mdl");
					ThrowGib ("progs/gib_warleg.mdl", self.health);
					ThrowGib ("progs/w_wshield.mdl", self.health);
					ThrowWeapon ("progs/w_wsword.mdl", self.health);
					self.delete_painskin = 1;
					if (self.skin == 0)
					{
						setmodel (self, self.model = "progs/warlord_supernail.mdl");
						//self.monstermodel = 2;
						self.skin = 0;
					}
					else
					{
						setmodel (self, self.model = "progs/warlord_supernail.mdl");
						//self.monstermodel = 2;
						self.skin = 1;
					}

					hknight2_sngdie1();
				}
			}
		setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
	}
};



void() hknight2_multigrenade_touch;

void() hknight2_minigrenade_explode =
{
	T_RadiusDamage (self, self.owner, autocvar_warlord_spike_grenade, self.owner);	// make Warlord immune to his own multigrenades	   // default 50

var float autocvar_explosiondebris = 0;
if ( autocvar_explosiondebris == 0 )
{
	if (other.health)
		pointparticles(particleeffectnum("multigrenade_explosion_nodebris"), self.origin, '0 0 0', 1);
	else
		pointparticles(particleeffectnum("multigrenade_explosion"), self.origin, '0 0 0', 1);
}
else
	pointparticles(particleeffectnum("multigrenade_explosion"), self.origin, '0 0 0', 1);

sound7(self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM, SNDSPD);
BecomeExplosion ();
};


void(float offsetAngle) hknight2_minigrenade_launch =
{
	local	entity missile;
	local	float	tempRand;
	
	missile = spawn ();
	missile.owner = self.owner;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
	missile.classname = "MiniGrenade";
		
// set missile speed	
	missile.v_angle = self.v_angle;
	missile.v_angle_y = missile.v_angle_y + offsetAngle;
	makevectors (missile.v_angle);
		
	missile.velocity = v_forward*100 + v_up*400;
	tempRand = (crandom()*60) - 30;
	missile.velocity = missile.velocity + tempRand * v_forward;
	tempRand = (crandom()*40) - 20;
	missile.velocity = missile.velocity + tempRand * v_right;
	tempRand = (crandom()*60) - 30;
	missile.velocity = missile.velocity + tempRand * v_up;

	missile.avelocity = '300 300 300';
	missile.angles = vectoangles(missile.velocity);
	missile.touch = hknight2_multigrenade_touch;
	
	setmodel (missile, "progs/h_grenade2.mdl");
	setsize (missile, '0 0 0', '0 0 0');		
	setorigin (missile, self.origin);
	missile.scale = 0.7;	

// set missile duration
	missile.nextthink = time + 1 + (crandom() * 0.5);
	missile.think = hknight2_minigrenade_explode;
};


void() hknight2_multigrenade_explode =
{
	hknight2_minigrenade_launch(0);
	hknight2_minigrenade_launch(72);
	hknight2_minigrenade_launch(144);
	hknight2_minigrenade_launch(216);
	hknight2_minigrenade_launch(288);
	remove (self);
};


void() hknight2_multigrenade_touch =
{
	if (other == self.owner)
		return;		// don't explode on owner
	if (other.takedamage == DAMAGE_AIM)
	{
		hknight2_minigrenade_explode();
		return;
	}
	// bounce sound
	sound7(self, CHAN_WEAPON, "weapons/bounce.wav", 1, ATTN_NORM, SNDSPD);	
	if (self.velocity == '0 0 0')
		self.avelocity = '0 0 0';
};



void() hknight2_grenade_explode =
{
	T_RadiusDamage (self, self.owner, autocvar_warlord_grenade, world);	   // default 40
	sound7(self, CHAN_VOICE, "weapons/r_exp3.wav", 1, ATTN_NORM, SNDSPD);

	var float autocvar_explosiondebris = 0;
	if ( autocvar_explosiondebris == 0 )
	{
		if (other.health)
			pointparticles(particleeffectnum("multigrenade_explosion_nodebris"), self.origin, '0 0 0', 1);
		else
			pointparticles(particleeffectnum("grenade_explosion"), self.origin, '0 0 0', 1);
	}
	else
		pointparticles(particleeffectnum("grenade_explosion"), self.origin, '0 0 0', 1);

	self.velocity = '0 0 0';
	self.touch = SUB_Null;
	setmodel (self, "progs/s_explod.spr");
	self.solid = SOLID_NOT;
	s_explode1 ();
};


void() hknight2_grenade_touch =
{
	if (other == self.owner)
		return;		// don't explode on owner
	if (other.takedamage == DAMAGE_AIM)
	{
		hknight2_grenade_explode ();
		return;
	}
	sound7(self, CHAN_VOICE, "weapons/bounce.wav", 1, ATTN_NORM, SNDSPD);	// bounce sound
	if (self.velocity == '0 0 0')
		self.avelocity = '0 0 0';
};


void() hknight2_throw =
{
	local vector distancedelta, nozdistancedelta, org, follow; 
	local	entity missile;
	
	sound7(self, CHAN_WEAPON, "warlord/throw.wav", 1, ATTN_NORM, SNDSPD);

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;

	makevectors (self.angles);
	org = self.origin + /* self.view_ofs +*/ v_right * 12 + v_up * 11 + v_forward * 20;
		
// set missile speed	

	follow = self.enemy.velocity*0.2;		// "guess" players future position to make it harder to dodge
	follow_z = 0;	

	distancedelta = (self.enemy.origin + follow) - org; 	//work out distance vector  
	nozdistancedelta = distancedelta;  		//copy to no height distance vector 
	nozdistancedelta_z = 0;  			//remove height 
	
	missile.velocity = normalize(distancedelta); 	//set the velocity to the distance
	missile.velocity = missile.velocity * 525;   	//give it some power 
	missile.velocity_z = missile.velocity_z + 150 + vlen(nozdistancedelta)*0.22*(1 + (0.3*(random()))); 

	missile.avelocity = '300 300 300';
	missile.angles = vectoangles(missile.velocity);
	
// set missile duration and type

	if (autocvar_warlord_grenade_type == 2)			// use multi-grenades
	{
		missile.touch = hknight2_multigrenade_touch;
		missile.nextthink = time + 2.5;
		missile.think = hknight2_multigrenade_explode;
		setmodel (missile, "progs/h_grenade2.mdl");
	}
	else							// use regular grenades
	{
		missile.touch = hknight2_grenade_touch;
		missile.nextthink = time + 2.5;
		missile.think = hknight2_grenade_explode;
		setmodel (missile, "progs/h_grenade1.mdl");
	}
	setsize (missile, '0 0 0', '0 0 0');		
	setorigin (missile, org);	
	missile.scale = 1.2;	
};


void()	hknight2_throwgrenade1	=[	$throw1,	hknight2_throwgrenade2	] {ai_face();self.nextthink = time + 0.06;self.colormod = '1 1 1';};
void()	hknight2_throwgrenade2	=[	$throw2,	hknight2_throwgrenade3	] {ai_face();self.nextthink = time + 0.06;};
void()	hknight2_throwgrenade3	=[	$throw3,	hknight2_throwgrenade4	] {ai_face();self.nextthink = time + 0.06;};
void()	hknight2_throwgrenade4	=[	$throw4,	hknight2_throwgrenade5	] {ai_face();self.nextthink = time + 0.06;};
void()	hknight2_throwgrenade5	=[	$throw5,	hknight2_throwgrenade6	] {ai_face();self.nextthink = time + 0.06;};
void()	hknight2_throwgrenade6	=[	$throw6,	hknight2_throwgrenade7	] {ai_face();self.nextthink = time + 0.06;};
void()	hknight2_throwgrenade7	=[	$throw7,	hknight2_throwgrenade8	] {ai_face();self.nextthink = time + 0.06;};
void()	hknight2_throwgrenade8	=[	$throw8,	hknight2_throwgrenade9	] {ai_face();self.nextthink = time + 0.06;};
void()	hknight2_throwgrenade9	=[	$throw9,	hknight2_throwgrenade10] {ai_face();self.nextthink = time + 0.06;};
void()	hknight2_throwgrenade10=[	$throw10,	hknight2_throwgrenade11] {ai_face();self.nextthink = time + 0.06;};
void()	hknight2_throwgrenade11=[	$throw11,	hknight2_throwgrenade12] {ai_face();self.nextthink = time + 0.06;};
void()	hknight2_throwgrenade12=[	$throw12,	hknight2_throwgrenade13] {ai_face();self.nextthink = time + 0.06;};
void()	hknight2_throwgrenade13=[	$throw13,	hknight2_throwgrenade14] {ai_face();self.nextthink = time + 0.06;};
void()	hknight2_throwgrenade14=[	$throw14,	hknight2_throwgrenade15] {ai_face();self.nextthink = time + 0.06;};
void()	hknight2_throwgrenade15=[	$throw15,	hknight2_throwgrenade16] {ai_face();self.nextthink = time + 0.06;};
void()	hknight2_throwgrenade16=[	$throw16,	hknight2_throwgrenade17] {ai_face();self.nextthink = time + 0.06;};
void()	hknight2_throwgrenade17=[	$throw17,	hknight2_throwgrenade18] {ai_face();self.nextthink = time + 0.06;};
void()	hknight2_throwgrenade18=[	$throw18,	hknight2_throwgrenade19] {ai_face();self.nextthink = time + 0.06;};
void()	hknight2_throwgrenade19=[	$throw19,	hknight2_throwgrenade20] {ai_face();self.nextthink = time + 0.06;};
void()	hknight2_throwgrenade20=[	$throw20,	hknight2_throwgrenade21] {ai_face();self.nextthink = time + 0.06; hknight2_throw (); hknight2_footsteps (0.7);};
void()	hknight2_throwgrenade21=[	$throw21,	hknight2_throwgrenade22] {ai_face();self.nextthink = time + 0.06;};
void()	hknight2_throwgrenade22=[	$throw22,	hknight2_throwgrenade23] {ai_face();self.nextthink = time + 0.06;};
void()	hknight2_throwgrenade23=[	$throw23,	hknight2_throwgrenade24] {ai_face();self.nextthink = time + 0.06;};
void()	hknight2_throwgrenade24=[	$throw24,	hknight2_throwgrenade25] {ai_face();self.nextthink = time + 0.06;};
void()	hknight2_throwgrenade25=[	$throw25,	hknight2_throwgrenade26] {ai_face();self.nextthink = time + 0.06;};
void()	hknight2_throwgrenade26=[	$throw26,	hknight2_throwgrenade27] {ai_face();self.nextthink = time + 0.06;};
void()	hknight2_throwgrenade27=[	$throw27,	hknight2_throwgrenade28] {ai_face();self.nextthink = time + 0.06;};
void()	hknight2_throwgrenade28=[	$throw28,	hknight2_throwgrenade29] {ai_face();self.nextthink = time + 0.06;};
void()	hknight2_throwgrenade29=[	$throw29,	hknight2_throwgrenade30] {ai_face();self.nextthink = time + 0.06;};
void()	hknight2_throwgrenade30=[	$throw30,	hknight2_throwgrenade31] {ai_face();self.nextthink = time + 0.06;};
void()	hknight2_throwgrenade31=[	$throw31,	hknight2_throwgrenade32] {ai_face();self.nextthink = time + 0.06;};
void()	hknight2_throwgrenade32=[	$throw32,	hknight2_throwgrenade33] {ai_face();self.nextthink = time + 0.06;};
void()	hknight2_throwgrenade33=[	$throw33,	hknight2_run1] {ai_face();};


float() hknight2_throwdistance =
{
local vector spot1, spot2;
local float r;	
	spot1 = self.origin + self.view_ofs;
	spot2 = self.enemy.origin + self.enemy.view_ofs;
	
	r = vlen (spot1 - spot2);
	if ((r > 190) && (r < 500))
		return TRUE;
	else
		return FALSE;
/*	
	if (r < 120)
		return RANGE_MELEE;
	if (r < 500)
		return RANGE_NEAR;
	if (r < 1000)
		return RANGE_MID;
	return RANGE_FAR;
*/
};


void() hknight2_homing_teleport =		//  Teleport Face to a slightly other position near its origin  (harder to hit)
{
local vector spot, vec;

// Select teleport destination within a 55 radius.
	spot = self.origin + (randomvec()*55);
	vec = normalize(spot - self.origin);
	traceline (self.origin, spot, TRUE, self);	// look through monsters
	spot = trace_endpos - vec*13;

// Check for walls and obstacles.
	if (PM_InWall(self, spot))
		return;
	if (!PM_TraceCheck(self, spot))
		return;

// Check if target is not blocked.
	traceline (spot, self.enemy.origin, FALSE, self);
	if (trace_fraction < 1.0)
		if (trace_ent != self.enemy)
			return;

// Teleport and face opponent!
	setorigin(self, spot);
	self.angles_y = vectoyaw(self.enemy.origin - spot);
};

void() hknight2_homing_pain =
{
	if (self.pain_finished > time)
		return;

	self.pain_finished = time + 0.5;
	sound7(self, CHAN_VOICE, "warlord/homing_pain.wav", 1, ATTN_NORM, SNDSPD);
	hknight2_homing_teleport ();
};


void() hknight2_homing_death =
{
	pointparticles(particleeffectnum("Afrit_death_explode"), self.origin, '0 0 0', 1); 	// FIXME:  placeholder
	sound7(self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM, SNDSPD);				// FIXME:  placeholder
	remove (self);
};


void() hknight2_homing_touch =
{
	if (other.takedamage)
		{
		if (other.classname != "player")
			{
			hknight2_homing_teleport ();
			return;
			}
		T_Damage (other, self, self.owner, autocvar_warlord_homing_missile);	 // default 15	
		sound7(self, CHAN_WEAPON, "warlord/homing_touch.wav", 1, ATTN_NORM, SNDSPD);	 // To abort the homing fly-sound. Use same channel !!!!
		remove(self);
		}
//var float autocvar_warlord_homing_behaviour = 0;	// set cvar 'warlord_homing_behaviour' default to 0.   0= Homing projectile will vanish, when hitting walls/meshes    1= Homing projectile will NOT vanish, when hitting walls/meshes (= must be shot/destroyed to vanish)
	if (autocvar_warlord_homing_behaviour == 0)
		{
		if (!((other.model == "progs/spike.mdl") || (other.model == "progs/s_spike.mdl") || (other.model == "progs/grenade.mdl") || (other.model == "progs/missile.mdl")))
			{
			pointparticles(particleeffectnum("Afrit_death_explode"), self.origin, '0 0 0', 1); 	// FIXME:  placeholder
			sound7(self, CHAN_WEAPON, "warlord/homing_touch.wav", 1, ATTN_NORM, SNDSPD);	 // To abort the homing fly-sound. Use same channel !!!!
			remove(self);
			}
		}
};


void() hknight2_homing_think =
{
if (self.enemy.health < 1)	// to avoid endless homing above players corpse
	remove (self);
	
	if (vlen((self.enemy.origin + '0 0 16') - self.origin) <= 70)		// to make it touchable again
	{
		traceline ((self.enemy.origin + '0 0 16'), self.origin, FALSE, self);
		if (trace_fraction == 1.0)
			self.movetype = MOVETYPE_FLYMISSILE;
	}

	if (self.origin == self.old_origin)					// when it got stuck
	{
		sound7(self, CHAN_WEAPON, "warlord/homing_touch.wav", 1, ATTN_NORM, SNDSPD);	 // To abort the face fly-sound. Use same channel !!!!
//		T_RadiusDamage (self, self.owner, 33, self.owner);	
		remove (self);
	}
	self.old_origin = self.origin;

local vector dir, offang, vec;
	dir = normalize((self.enemy.origin + '0 0 16') - self.origin);
	offang = vectoangles ((self.enemy.origin + '0 0 12') - self.origin);
	makevectors (offang);
	
// set homing-missile angles
	vec = normalize (v_forward);
	vec_z = vec_z * -1;
	self.angles = vectoangles(vec);  	// adjust the Face to always face the player !

	self.frame = self.frame + 1;		// Face animation
//	if (self.frame >= 44)			//  DS
	if (self.frame >= 19)			//  D3
		self.frame = 0;

	self.touch = hknight2_homing_touch; 			

	self.velocity = dir * 230;			// speed of Face.  Vore: 250;
	self.nextthink = time + 0.15;			// inertia of homing effect.  Vore: 0.2
	self.think = hknight2_homing_think;	
};


void (vector face_spawn_pos, vector face_spawn_vel) launch_hknight2_homing =
{
	newmis = spawn ();
	newmis.owner = self;
	newmis.enemy = self.enemy;
	if (autocvar_warlord_homing_behaviour == 0)
		newmis.movetype = MOVETYPE_FLYMISSILE;
	else
		newmis.movetype = MOVETYPE_NOCLIP;
	newmis.solid = SOLID_BBOX;

	newmis.velocity = face_spawn_vel * 230;	
	newmis.angles = vectoangles (newmis.velocity);
	
	newmis.scale = 0.7;
	newmis.glow_color = 75;
	newmis.glow_size = 666;
	
//	newmis.frame = 14;			// start frame is 14    DS
	newmis.frame = 0;			// start frame is 0	D3
	newmis.classname = "hknight2_homing";
	newmis.think = hknight2_homing_think;	
	newmis.nextthink = time + 0.27;		// to move completely out of warlords model (to avoid touch function with it)
	setmodel (newmis, "progs/face.mdl");		
	setsize (newmis, '-9 -9 -9', '9 9 9');
	
	newmis.traileffectnum = particleeffectnum("TR_WARLORDHOMING");
	newmis.health = 30;
	newmis.takedamage = DAMAGE_AIM;
	setorigin (newmis, face_spawn_pos);
	newmis.th_pain = hknight2_homing_pain;
	newmis.th_die = hknight2_homing_death;

	sound7(newmis, CHAN_WEAPON, "warlord/homing.wav", 1, ATTN_NORM, SNDSPD);
};


void() hknight2_homing_shot() =
{
	local vector offang, org, vec;
	
	offang = vectoangles (self.enemy.origin - self.origin);
	makevectors (offang);
	org = self.origin + /* self.view_ofs +*/ v_right * 9 + v_up * 12 + v_forward * 17;

// set homing-missile speed
	vec = normalize (v_forward);
	vec_z = vec_z * -1;
	
	launch_hknight2_homing (org, vec); 
};


//============================================================================

void()	hknight2_magica1 =[	$magica1,	hknight2_magica2	] {ai_face();self.colormod = '1 1 1';};
void()	hknight2_magica2 =[	$magica2,	hknight2_magica3	] {ai_face();};
void()	hknight2_magica3 =[	$magica3,	hknight2_magica4	] {ai_face();};
void()	hknight2_magica4 =[	$magica4,	hknight2_magica5	] {ai_face();};
void()	hknight2_magica5 =[	$magica5,	hknight2_magica6	] {ai_face();};
void()	hknight2_magica6 =[	$magica6,	hknight2_magica7	] {ai_face();hknight2_footsteps (0.7);};
void()	hknight2_magica7 =[	$magica7,	hknight2_magica8	] {hknight2_shot(-2);};
void()	hknight2_magica8 =[	$magica8,	hknight2_magica9	] {hknight2_shot(-1);};
void()	hknight2_magica9 =[	$magica9,	hknight2_magica10] {hknight2_shot(0);};
void()	hknight2_magica10 =[	$magica10,	hknight2_magica11] {hknight2_shot(1);};
void()	hknight2_magica11 =[	$magica11,	hknight2_magica12] {hknight2_shot(2);};
void()	hknight2_magica12 =[	$magica12,	hknight2_magica13] {hknight2_shot(3);};
void()	hknight2_magica13 =[	$magica13,	hknight2_magica14] {ai_face();};
void()	hknight2_magica14 =[	$magica14,	hknight2_run1	] {ai_face();};

//============================================================================

void()	hknight2_magicb1 =[	$magicb1,	hknight2_magicb2	] {ai_face();self.colormod = '1.4 1 1';};
void()	hknight2_magicb2 =[	$magicb2,	hknight2_magicb3	] {ai_face();self.colormod = '1.8 1 1';};
void()	hknight2_magicb3 =[	$magicb3,	hknight2_magicb4	] {ai_face();self.colormod = '2.2 1 1';};
void()	hknight2_magicb4 =[	$magicb4,	hknight2_magicb5	] {ai_face();self.colormod = '2.6 1 1';};
void()	hknight2_magicb5 =[	$magicb5,	hknight2_magicb6	] {ai_face();self.colormod = '3 1 1';};
void()	hknight2_magicb6 =[	$magicb6,	hknight2_magicb7	] {ai_face();self.colormod = '3.5 1 1'; hknight2_footsteps (0.7);};
void()	hknight2_magicb7 =[	$magicb7,	hknight2_magicb8	] {ai_face();sound7(self, CHAN_WEAPON, "warlord/homing_shot.wav", 1, ATTN_NORM, SNDSPD);};
void()	hknight2_magicb8 =[	$magicb8,	hknight2_magicb9	] {ai_face();};
void()	hknight2_magicb9 =[	$magicb9,	hknight2_magicb10] {hknight2_homing_shot();};
void()	hknight2_magicb10 =[	$magicb10,	hknight2_magicb11] {};
void()	hknight2_magicb11 =[	$magicb11,	hknight2_magicb12] {};
void()	hknight2_magicb12 =[	$magicb12,	hknight2_magicb13] {self.colormod = '2 1 1';};
void()	hknight2_magicb13 =[	$magicb13,	hknight2_run1] {ai_face();self.colormod = '1 1 1';};

//============================================================================


void() ram_scan =
{
	local vector dir, spot1, spot2;
	local float r;	

	spot1 = self.origin + self.view_ofs;
	spot2 = self.enemy.origin + self.enemy.view_ofs;
	r = vlen (spot1 - spot2);
	if (r < 60)
	{
		sound7(self, CHAN_AUTO, "warlord/fall.wav", 1, ATTN_IDLE, SNDSPD);

		local float ldmg;
		ldmg = rint(autocvar_warlord_ram_attack + (5 * random()));  	// damage can vary between 5 and 10 hitpoints
		T_Damage (self.enemy, self, self, ldmg); 

		dir = (self.origin - '0 0 7') - self.enemy.origin;
		dir = normalize(dir);
		self.enemy.rammed = 1;
		ramdirection = dir;
	}
};


//===========================================================================

void()	hknight2_char_a1	=[	$char_a1,	hknight2_char_a2	] {ai_charge(1);self.colormod = '1 1 1';};
void()	hknight2_char_a2	=[	$char_a2,	hknight2_char_a3	] {ai_charge(1);};
void()	hknight2_char_a3	=[	$char_a3,	hknight2_char_a4	] {ai_charge(3);};
void()	hknight2_char_a4	=[	$char_a4,	hknight2_char_a5	] {ai_charge(15); hknight2_footsteps (0.9);};
void()	hknight2_char_a5	=[	$char_a5,	hknight2_char_a6	] {ai_charge(17);};
void()	hknight2_char_a6	=[	$char_a6,	hknight2_char_a7	] {ai_charge(20);sound7(self, CHAN_AUTO, "warlord/ram.wav", 1, ATTN_NORM, SNDSPD);};
void()	hknight2_char_a7	=[	$char_a7,	hknight2_char_a8	] {ai_charge(20); ai_melee(); hknight2_footsteps (0.9);};
void()	hknight2_char_a8	=[	$char_a8,	hknight2_char_a9	] {ai_charge(20); ai_melee();};
void()	hknight2_char_a9	=[	$char_a9,	hknight2_char_a10	] {ai_charge(20); ai_melee();};
void()	hknight2_char_a10=[	$char_a10,	hknight2_char_a11	] {ai_charge(20); ai_melee(); ram_scan();};	// shield HIT  !!!
void()	hknight2_char_a11=[	$char_a11,	hknight2_char_a12	] {ai_charge(18); ai_melee();};
void()	hknight2_char_a12=[	$char_a12,	hknight2_char_a13	] {ai_charge(16);};
void()	hknight2_char_a13=[	$char_a13,	hknight2_char_a14	] {ai_charge(6); hknight2_footsteps (0.8);};
void()	hknight2_char_a14=[	$char_a14,	hknight2_char_a15	] {ai_charge(2);};
void()	hknight2_char_a15=[	$char_a15,	hknight2_char_a16	] {ai_charge(2);};
void()	hknight2_char_a16=[	$char_a16,	hknight2_run1	] {ai_charge(2);};

//===========================================================================

void()	hknight2_char_b1	=[	$char_b1,	hknight2_char_b2	]
{CheckContinueCharge2 (); ai_charge(1); self.colormod = '1 1 1';};
void()	hknight2_char_b2	=[	$char_b2,	hknight2_char_b3	] {ai_charge(10);};
void()	hknight2_char_b3	=[	$char_b3,	hknight2_char_b4	] {ai_charge(15); ai_melee(); hknight2_footsteps (0.7);};
void()	hknight2_char_b4	=[	$char_b4,	hknight2_char_b5	] {ai_charge(22); ai_melee();};
void()	hknight2_char_b5	=[	$char_b5,	hknight2_char_b6	] {ai_charge(18); ai_melee();};
void()	hknight2_char_b6	=[	$char_b6,	hknight2_char_b1	] {ai_charge(8); ai_melee();};

//===========================================================================

void()	hknight2_slice1	=[	$slice1,	hknight2_slice2	] {ai_charge(2);self.colormod = '1 1 1';};
void()	hknight2_slice2	=[	$slice2,	hknight2_slice3	] {ai_charge(2);};
void()	hknight2_slice3	=[	$slice3,	hknight2_slice4	] {ai_charge(2);};
void()	hknight2_slice4	=[	$slice4,	hknight2_slice5	] {ai_charge(3);
if (random()<0.5)
	sound7(self, CHAN_AUTO, "warlord/attack2.wav", 1, ATTN_NORM, SNDSPD);};
void()	hknight2_slice5	=[	$slice5,	hknight2_slice6	] {ai_charge(7); ai_melee();};
void()	hknight2_slice6	=[	$slice6,	hknight2_slice7	] {ai_charge(15); ai_melee();};
void()	hknight2_slice7	=[	$slice7,	hknight2_slice8	] {ai_charge(20); ai_melee(); hknight2_footsteps (0.8);};
void()	hknight2_slice8	=[	$slice8,	hknight2_slice9	] {ai_charge(3); ai_melee();};
void()	hknight2_slice9	=[	$slice9,	hknight2_slice10] {ai_melee();};
void()	hknight2_slice10=[	$slice10,	hknight2_run1	] {ai_charge(1);};

//===========================================================================

void()	hknight2_smash1	=[	$smash1,	hknight2_smash2	] {ai_charge(1);self.colormod = '1 1 1';};
void()	hknight2_smash2	=[	$smash2,	hknight2_smash3	] {ai_charge(1);};
void()	hknight2_smash3	=[	$smash3,	hknight2_smash4	] {ai_charge(1);};
void()	hknight2_smash4	=[	$smash4,	hknight2_smash5	] {ai_charge(2);
if (random()<0.5)
	sound7(self, CHAN_AUTO, "warlord/attack2.wav", 1, ATTN_NORM, SNDSPD);};
void()	hknight2_smash5	=[	$smash5,	hknight2_smash6	] {ai_charge(10); ai_melee();};
void()	hknight2_smash6	=[	$smash6,	hknight2_smash7	] {ai_charge(15); ai_melee();};
void()	hknight2_smash7	=[	$smash7,	hknight2_smash8	] {ai_charge(15); ai_melee(); hknight2_footsteps (0.8);};
void()	hknight2_smash8	=[	$smash8,	hknight2_smash9	] {ai_charge(7); ai_melee();};
void()	hknight2_smash9	=[	$smash9,	hknight2_smash10] {ai_charge(3); ai_melee();};
void()	hknight2_smash10=[	$smash10,	hknight2_smash11] {ai_charge(0); hknight2_footsteps (0.8);};
void()	hknight2_smash11=[	$smash11,	hknight2_run1	] {ai_charge(0);};

//============================================================================

void()	hknight2_watk1	=[	$w_attack1,	hknight2_watk2	] {ai_charge(1);self.colormod = '1 1 1';};
void()	hknight2_watk2	=[	$w_attack2,	hknight2_watk3	] {ai_charge(1);
if (random()<0.5)
	sound7(self, CHAN_AUTO, "warlord/attack3.wav", 1, ATTN_NORM, SNDSPD);};
void()	hknight2_watk3	=[	$w_attack3,	hknight2_watk4	] {ai_charge(10); hknight2_footsteps (0.7);};
void()	hknight2_watk4	=[	$w_attack4,	hknight2_watk5	] {ai_charge(5);ai_melee();};
void()	hknight2_watk5	=[	$w_attack5,	hknight2_watk6	] {ai_melee();};
void()	hknight2_watk6	=[	$w_attack6,	hknight2_watk7	] {ai_melee();};
void()	hknight2_watk7	=[	$w_attack7,	hknight2_watk8	] {ai_charge(1);};
void()	hknight2_watk8	=[	$w_attack8,	hknight2_watk9	] {ai_charge(1);};
void()	hknight2_watk9	=[	$w_attack9,	hknight2_watk10	] {ai_charge(1);};
void()	hknight2_watk10	=[	$w_attack10,	hknight2_watk11	] {ai_charge(1);};
void()	hknight2_watk11	=[	$w_attack11,	hknight2_watk12	] {ai_charge(10);};
void()	hknight2_watk12	=[	$w_attack12,	hknight2_watk13	] {ai_charge(15); ai_melee();};
void()	hknight2_watk13	=[	$w_attack13,	hknight2_watk14	] {ai_charge(10); ai_melee(); hknight2_footsteps (0.7);};
void()	hknight2_watk14	=[	$w_attack14,	hknight2_watk15	] {ai_charge(0); ai_melee();};
void()	hknight2_watk15	=[	$w_attack15,	hknight2_watk16	] {ai_charge(0);};
void()	hknight2_watk16	=[	$w_attack16,	hknight2_watk17	] {ai_charge(1); hknight2_footsteps (0.7);};
void()	hknight2_watk17	=[	$w_attack17,	hknight2_watk18	] {ai_charge(1);};
void()	hknight2_watk18	=[	$w_attack18,	hknight2_watk19	] {ai_charge(1);};
void()	hknight2_watk19	=[	$w_attack19,	hknight2_watk20	] {ai_charge(1); ai_melee(); hknight2_footsteps (0.7);};
void()	hknight2_watk20	=[	$w_attack20,	hknight2_watk21	] {ai_charge(10); ai_melee();};
void()	hknight2_watk21	=[	$w_attack21,	hknight2_watk22	] {ai_charge(10); ai_melee();};
void()	hknight2_watk22	=[	$w_attack22,	hknight2_run1	] {ai_charge(2);};

//============================================================================


void()	hknight2_duck1 =[	$duck1,		hknight2_duck2] {ai_face(); self.nextthink = time + 0.11;};
void()	hknight2_duck2 =[	$duck2,		hknight2_duck3] {ai_face(); self.nextthink = time + 0.11;};
void()	hknight2_duck3 =[	$duck3,		hknight2_duck4] {ai_face(); self.nextthink = time + 0.6;};	// am weitesten zusammengekauert !!!!!
void()	hknight2_duck4 =[	$duck4,		hknight2_duck5] {ai_face(); self.nextthink = time + 0.11;};
void()	hknight2_duck5 =[	$duck5,		hknight2_duck6] {ai_face(); self.nextthink = time + 0.11;};
void()	hknight2_duck6 =[	$duck6,		hknight2_run1 ] {ai_face(); self.nextthink = time + 0.11;self.takedamage = DAMAGE_AIM;};


void()	hknight2_dodge1 =[	$dodge1,	hknight2_dodge2	] {ai_face(); self.nextthink = time + 0.1;};
void()	hknight2_dodge2 =[	$dodge2,	hknight2_dodge3	] {ai_face(); self.nextthink = time + 0.5;};	// am weitesten zur Seite gelehnt !!!!!
void()	hknight2_dodge3 =[	$dodge3,	hknight2_dodge4	] {ai_face(); self.nextthink = time + 0.11;};
void()	hknight2_dodge4 =[	$dodge4,	hknight2_dodge5	] {ai_face(); self.nextthink = time + 0.11;};
void()	hknight2_dodge5 =[	$dodge5,	hknight2_run1	] {ai_face(); self.nextthink = time + 0.11;self.takedamage = DAMAGE_AIM;};

void()	hknight2_block1 =[	$block1,	hknight2_block2	] {ai_face(); self.nextthink = time + 0.11;};
void()	hknight2_block2 =[	$block2,	hknight2_block3	] {ai_face(); self.nextthink = time + 0.11;};
void()	hknight2_block3 =[	$block3,	hknight2_block4	] {ai_face(); self.nextthink = time + 0.6;};	// am weitesten nach hinten gelehnt !!!!!
void()	hknight2_block4 =[	$block4,	hknight2_block5	] {ai_face(); self.nextthink = time + 0.11;};
void()	hknight2_block5 =[	$block5,	hknight2_block6	] {ai_face(); self.nextthink = time + 0.11;};
void()	hknight2_block6 =[	$block6,	hknight2_run1	] {ai_face(); self.nextthink = time + 0.11;self.takedamage = DAMAGE_AIM;};


void() hknight2_dodge =
{
local float zufall;
self.takedamage = DAMAGE_YES; 			// grenades bounces off of him
	zufall = random();
	if (zufall < 0.27)
		hknight2_duck1 ();		// ducken mit dem Schild 
	else if (zufall < 0.55)
		hknight2_block1 ();		// block animation 
	else
		hknight2_dodge1 ();		// dodge animationen (zur seite)
};


void(entity attacker, float damage)	hknight2_pain =
{
self.colormod = '1 1 1';
self.touch = SUB_Null;
	if (self.dodging)
		{
		self.dodging = 0;
		hknight2_dodge ();
		return;
		}

	if (self.dodge_finished > time)
		return;
		
	if (self.pain_finished > time)
		return;

	if (time - self.pain_finished > 5)
	{	// allways go into pain frame if it has been a while
		if (autocvar_slowmotion >= 4)	// start slowmotion when hurting enemies
		{
			if (random () <= (autocvar_slowmotion_randomness_warlord * 0.01))
				{
				the_matrix = 1;
				matrixcounter = time + (autocvar_slowmotion_intensity * autocvar_slowmotion_duration);	// Attention: formula needed to take the intensity into account. Time increase is much more when slowmo is active ! (time + 1 will be approx. 3seconds with slowmo 0.33 !)
				}
		}
		if (random() < 0.5)
			hknight2_pain1 ();
		else
			hknight2_painb1 ();
		self.pain_finished = time + 1.5;
		return;
	}
	
	if ((random()*30 > damage) )
		return;		// didn't flinch

	if (autocvar_slowmotion >= 4)	// start slowmotion when hurting enemies
	{
		if (random () <= (autocvar_slowmotion_randomness_warlord * 0.01))
			{
			the_matrix = 1;
			SNDSPD = 70;
			matrixcounter = time + (autocvar_slowmotion_intensity * autocvar_slowmotion_duration);	// Attention: formula needed to take the intensity into account. Time increase is much more when slowmo is active ! (time + 1 will be approx. 3seconds with slowmo 0.33 !)
			}
	}

	self.pain_finished = time + 1.5;
	if (random() < 0.5)
		hknight2_pain1 ();
	else
		hknight2_painb1 ();
};


float	hknight2_type;

void() hknight2_melee =
{
	hknight2_type = hknight2_type + 1;

	sound7(self, CHAN_WEAPON, "warlord/slash1.wav", 1, ATTN_NORM, SNDSPD);
	if (hknight2_type == 1)
		hknight2_slice1 ();
	else if (hknight2_type == 2)
		hknight2_smash1 ();
	else if (hknight2_type == 3)
	{
		hknight2_watk1 ();
		hknight2_type = 0;
	}
};


void() hknight2_random_ranged_attack =		// adds random ranged attacks
{						
local   float   grenade_distance, zufall;
grenade_distance = FALSE;
grenade_distance = grenade_distance + hknight2_throwdistance();
zufall = random();
if ((grenade_distance) && (autocvar_warlord_grenade_type))		// if good range, throw grenade instead of magic-missile attack
	{
	if (zufall < 0.33)
		hknight2_throwgrenade1 ();
	else if (zufall < 0.77)
		hknight2_magica1 ();		// regular magic missiles
	else
		{
		if (autocvar_warlord_homing_projectile)
			hknight2_magicb1 ();		// homing missile (23% chance)
		else
			hknight2_magica1 ();		// regular magic missiles
		}
	}	
else					// do not throw grenades
	{
	if (zufall < 0.72)
		hknight2_magica1 ();		// regular magic missiles
	else
		{
		if (autocvar_warlord_homing_projectile)
			hknight2_magicb1 ();		// homing missile (27% chance)
		else
			hknight2_magica1 ();		// regular magic missiles
		}
	}	
};


/*QUAKED monster_hell_knight2 (1 0 0) (-16 -16 -24) (16 16 40) Ambush
*/
void() monster_hell_knight2 =
{
self.classname = "monster_hell_knight2";
	if (deathmatch)
	{
		remove(self);
		return;
	}
	
	
	
	precache_model ("progs/warlord.mdl");		// all files precached in worldspawn() due to savegame-bug
	precache_model ("progs/h_warlord.mdl");
	
	precachegibs_warlord();
	
	precache_model ("progs/k_spike2.mdl");
	precache_model ("progs/h_grenade2.mdl");	// multi
	precache_model ("progs/h_grenade1.mdl");	
	precache_model ("progs/face.mdl");

	precache_sound("warlord/attack1.wav");		// all files precached in worldspawn() due to savegame-bug
	precache_sound("warlord/attack2.wav");	
	precache_sound("warlord/attack3.wav");	
	precache_sound("warlord/death1.wav");
	precache_sound("warlord/pain1.wav");
	precache_sound("warlord/pain2.wav");
	precache_sound("warlord/sight1.wav");
	precache_sound("warlord/slash1.wav");
	precache_sound("warlord/idle.wav");
	precache_sound("warlord/growl.wav");
	precache_sound("warlord/ram.wav");
	precache_sound("warlord/throw.wav");
	precache_sound("warlord/fall.wav");
	precache_sound("warlord/homing.wav");
	precache_sound("warlord/homing_shot.wav");
	precache_sound("warlord/homing_pain.wav");
	precache_sound("warlord/homing_touch.wav");
	precache_sound("walk/hknight1.wav");
	precache_sound("walk/hknight2.wav");
	precache_sound("walk/hknight3.wav");

	precache_sound("knight/sword1.wav");
	precache_sound("knight/sword2.wav");
	
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	
	setmodel (self, "progs/warlord.mdl");

	var float autocvar_warlordmultiskin = 35;	// set cvar 'warlordmultiskin' default to 35.  Select chance for 2 available skins. Examples: "0"= always use skin 1.  "100"= always use skin 2.   "50"= use both skins 1 and 2 randomly (50/50 %).  "75"= 75% chance to use skin 2 and 25% to use skin 1
	local float zufal;
	zufal = autocvar_warlordmultiskin * 0.01;
	if (random() <= zufal)
		self.skin = 1;
	else
		self.skin = 0;

	self.monstermodel = 0;

	setsize (self, '-16 -16 -24', '16 16 40');
	self.health = autocvar_warlord_health;		// default 250
	self.health_initial = self.health;

	self.colormod = '1 1 1';

	self.th_stand = hknight2_stand1;
	self.th_walk = hknight2_walk1;
	self.th_run = hknight2_run1;
	self.th_melee = hknight2_melee;

  	self.th_missile = hknight2_random_ranged_attack;

	self.th_pain = hknight2_pain;
	self.th_die = hknight2_die;
  
  	self.alpha = autocvar_monstertransparency * 0.01;

	if (autocvar_painskin_transparency)
	{
		entity pain_skin_entity;

		pain_skin_entity = spawn();
		pain_skin_entity.solid = SOLID_NOT;
		pain_skin_entity.movetype = MOVETYPE_NOCLIP;	
		pain_skin_entity.owner = self;
		setmodel (pain_skin_entity,self.model);
		setsize (pain_skin_entity, VEC_HULL2_MIN, VEC_HULL2_MAX);	
		setorigin (pain_skin_entity, '0 0 0');
		pain_skin_entity.skin = self.skin;
		pain_skin_entity.colormod_x = self.colormod_x;
		pain_skin_entity.colormod_y = self.colormod_y;
		pain_skin_entity.colormod_z = self.colormod_z;
		pain_skin_entity.monstermodel = self.monstermodel;
		pain_skin_entity.frame = self.frame;	
		pain_skin_entity.alpha = autocvar_painskin_transparency;
		pain_skin_entity.think = pain_skin_entity_think;
		pain_skin_entity.nextthink = time;

		setattachment(pain_skin_entity, self, "test");	
	}

	walkmonster_start ();

do_the_cloning();

var float autocvar_warlordmass = 2700;
MonsterPhysics (self, autocvar_warlordmass);
};


void() monster_hell_knight2_start =
{
	local entity clone;
	self.scale = 1;
	clone = spawn();
	copyentity (self,clone);
	clone.think = monster_hell_knight2;
	clone.nextthink = time + 0.0001;
};




///////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////  below code added by Seven  //////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////
/*
==============================================================================

Creates "Vengeance of the deceased" effect.    

Modelname and Modelframe is taken from call after regular death animations:    
void(string modelname, float modelframe) vengeance;
Example: 
vengeance ("progs/soldier.mdl", $death10);

This function must be declared at the end of defs.qc (example):
void(string modelname, float modelframe) vengeance_hknight2; 

==============================================================================
*/


void() vengeance_hknight2_end1 = {					// end sequence
	self.alpha = -1;
	te_customflash (self.origin, 500, 0.7, '1 0 0');
	self.nextthink = time + 0.2;
      self.think = SUB_Remove;
};


void() vengeance_hknight2_touch = {       // player receives 1-3 damage when he gets touched by vengeance effect

	local float ldmg;
	ldmg = rint(0.5 + (3 * random()));  	// chances=  33%: 1 damage /  33%: 2 damage  /  33%: 3 damage

	T_Damage (self.enemy, self, self, ldmg); 	// analog to meele attack dog/fiend
//      T_Damage (other, self, self, ldmg); 		// analog to jump damage dog/fiend

	self.touch = SUB_Null; 			// um nicht endlos damage zu kriegen !

	self.think = vengeance_hknight2_end1; 
	self.nextthink = time + 0.1;   
};


void() vengeance_hknight2_skull =			//  calls skull in skull.qc   
{
	local	vector	offang, org;
	
	offang = vectoangles (self.enemy.origin - self.origin);
	makevectors (offang);
	org = self.origin + self.mins + self.size*0.5 + v_forward * 20;   
	org_z = org_z + 10;   		 // to adjust spawning coordinate of skull. Depending on the monster it spawnes.

	launch_vengeance_skull (org); 	
	newmis.classname = "skull";
	setmodel (newmis, "progs/skull.mdl");
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);	

	newmis.scale = 0.9;		//  set size of the skull here.  Depending on the monster it spawnes. ;)

	precache_sound("vengeance/skull.wav");	
	precache_sound("vengeance/skulltouch.wav");  
};


									//  from here on: run sequence. 

void() vengeance_hknight2_run1 =[	$run1,	vengeance_hknight2_run2 ]   {
	ai_face();
 	movetogoal (19);  // orig(20)
self.touch = vengeance_hknight2_touch;
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight2_run2 =[	$run2,	vengeance_hknight2_run3 ]   {
	ai_face();
 	movetogoal (24);   // orig(25)
self.touch = vengeance_hknight2_touch;
	self.alpha = 0.37;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight2_run3 =[	$run3,	vengeance_hknight2_run4 ]    {
	ai_face();
 	movetogoal (17);   // orig(18)
self.touch = vengeance_hknight2_touch;
	self.alpha = 0.34;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight2_run4 =[	$run4,	vengeance_hknight2_run5 ]    {
	ai_face();
 	movetogoal (15);    // orig(16)
self.touch = vengeance_hknight2_touch;
	self.alpha = 0.31;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight2_run5 =[	$run5,	vengeance_hknight2_run6 ]    {
	ai_face();
 	movetogoal (13);   // orig(14)
self.touch = vengeance_hknight2_touch;
	self.alpha = 0.28;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight2_run6 =[	$run6,	vengeance_hknight2_run7 ]    {
	ai_face();
 	movetogoal (24);   // orig(25)
self.touch = vengeance_hknight2_touch;
	self.alpha = 0.25;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight2_run7 =[	$run7,	vengeance_hknight2_random ]    {
	ai_face();
 	movetogoal (20);   // orig(21)
self.touch = vengeance_hknight2_touch;
	self.alpha = 0.22;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};


							//  from here on: attack/jump sequenz. 

void() vengeance_hknight2_chara1 =[ $char_a4,	vengeance_hknight2_chara2 ]    {
	ai_face();
 	movetogoal (13);    // orig(20)
self.touch = vengeance_hknight2_touch;
	self.alpha = 0.2;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight2_chara2 =[ $char_a5,	vengeance_hknight2_chara3 ]    {
	ai_face();
 	movetogoal (19);   // orig(25)
self.touch = vengeance_hknight2_touch; 
	self.alpha = 0.17;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight2_chara3 =[ $char_a6,	vengeance_hknight2_chara4 ]    {
	ai_face();
 	movetogoal (20);   // orig(18)
self.touch = vengeance_hknight2_touch;
	self.alpha = 0.14;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight2_chara4 =[ $char_a7,	vengeance_hknight2_chara5 ]    {
	ai_face();
 	movetogoal (20);   // orig(16)
self.touch = vengeance_hknight2_touch;
sound7(self, CHAN_VOICE, "warlord/slash1.wav", 1, 4);
	self.alpha = 0.11;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight2_chara5 =[ $char_a8,	vengeance_hknight2_chara6 ]    {
	ai_face();
 	movetogoal (20);   // orig(14)
self.touch = vengeance_hknight2_touch;
	self.alpha = 0.08;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight2_chara6 =[ $char_a9,	vengeance_hknight2_end1 ]    {
	ai_face();
 	movetogoal (19);   // orig(20)
self.touch = vengeance_hknight2_touch;
	makevectors (self.angles);
	self.origin_z = self.origin_z + 1;
	self.velocity = v_forward * 130 + '0 0 10';
	self.alpha = 0.05;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};


							//  from here on: skull spawn sequenz. 

void() vengeance_hknight2_skull1 =[ $magica2,	vengeance_hknight2_skull2 ]    {
	ai_face();
self.touch = vengeance_hknight2_touch;
	self.alpha = 0.2;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight2_skull2 =[ $magica3,	vengeance_hknight2_skull3 ]    {
sound7(self, CHAN_VOICE, "vengeance/hknightmag.wav", 0.8, ATTN_NORM, SNDSPD);	
	ai_face();
self.touch = vengeance_hknight2_touch; 
	self.alpha = 0.2;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight2_skull3 =[ $magica4,	vengeance_hknight2_skull4 ]    {
	ai_face();
self.touch = vengeance_hknight2_touch;
	self.alpha = 0.2;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight2_skull4 =[ $magica5,	vengeance_hknight2_skull5 ]    {
	ai_face();
self.touch = vengeance_hknight2_touch;
	self.alpha = 0.2;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight2_skull5 =[ $magica6,	vengeance_hknight2_skull6 ]    {
	ai_face();
self.touch = vengeance_hknight2_touch;
	self.alpha = 0.2;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight2_skull6 =[ $magica7,	vengeance_hknight2_skull7 ]    {
	ai_face();
self.touch = vengeance_hknight2_touch;
	self.alpha = 0.2;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight2_skull7 =[ $magica8,	vengeance_hknight2_skull8 ]    {
	ai_face();
self.touch = vengeance_hknight2_touch;
	self.alpha = 0.15;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight2_skull8 =[ $magica8,	vengeance_hknight2_end1 ]    {
	ai_face();
	movetogoal (2);
self.touch = vengeance_hknight2_touch;
	self.alpha = 0.1;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
vengeance_hknight2_skull();
};



void()	vengeance_hknight2_random 	= {		// random final animation selection
	self.alpha = 0.22;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.01;
		if (random() > 0.3)
			self.think = vengeance_hknight2_chara1;
		else
			self.think = vengeance_hknight2_skull1;
};


										//  from here on: ressurection sequence 1. 

void() vengeance_hknight211 =[	$death11,	vengeance_hknight212 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight212 =[	$death10,	vengeance_hknight213 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight213 =[	$death9,	vengeance_hknight214 	]  {
	walkmove ( (self.angles_y+180), 11);  
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight214 =[	$death8,	vengeance_hknight215 	]  {
	walkmove ( (self.angles_y+180), 10);  
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight215 =[	$death7,	vengeance_hknight216 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight216 =[	$death6,	vengeance_hknight217 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight217 =[	$death5,	vengeance_hknight218 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight218 =[	$death4,	vengeance_hknight219 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight219 =[	$death3,	vengeance_hknight2110 	]  {
sound7(self, CHAN_WEAPON, "warlord/sight1.wav", 1, ATTN_NORM, SNDSPD);
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight2110 =[ $death2,	vengeance_hknight2111 	]  {
	walkmove ( (self.angles_y+180), 8);  
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight2111 =[ $death1,	vengeance_hknight2_stand1 ]  {
	walkmove ( (self.angles_y+180), 10);  
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight2_stand1 =[ $walk6,	vengeance_hknight2_run1 ]  {    // needed to make the animation fluent
	self.alpha = 0.4;	 								 // $walk6 fills the frame gap	
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};


											//  from here on: ressurection sequence 2. 

void() vengeance_hknight221 =[	$deathb8,	vengeance_hknight222 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight222 =[	$deathb7,	vengeance_hknight223 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight223 =[	$deathb6,	vengeance_hknight224 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight224 =[	$deathb5,	vengeance_hknight225 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight225 =[	$deathb4,	vengeance_hknight226 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight226 =[	$deathb3,	vengeance_hknight227 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight227 =[	$deathb2,	vengeance_hknight228 	]  {
sound7(self, CHAN_WEAPON, "warlord/sight1.wav", 1, ATTN_NORM, SNDSPD);
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight228 =[ $deathb1,	vengeance_hknight2_stand2 ]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight2_stand2 =[	$char_a2,	vengeance_hknight2_stand21 ]  {    // needed to make the animation fluent
	self.alpha = 0.4;										    // $char_a2 fills the frame gap
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight2_stand21 =[ $char_a1,	vengeance_hknight2_run1 ]  {    // needed to make the animation fluent
	self.alpha = 0.4;	 									 // $char_a2 fills the frame gap
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};



								// from here on:  sequence where the corpse overbrights 
void()	vengeance_hknight2_bright05 	= {
	self.alpha = 0.3;
	self.colormod = '6 1 1';
	self.glow_color = 75;
	self.glow_size = 450;
	self.nextthink = time + 0.1;
		if (self.frame == $death13)
			self.think = vengeance_hknight211;
		else
			self.think = vengeance_hknight221;
};
void()	vengeance_hknight2_bright04 	= {
	self.alpha = 0.3;
	self.colormod = '5 1 1';
	self.glow_color = 75;
	self.glow_size = 350;
	self.nextthink = time + 0.1;
	self.think = vengeance_hknight2_bright05;
};
void()	vengeance_hknight2_bright03 	= {
	self.alpha = 0.3;
	self.colormod = '4 1 1';
	self.glow_color = 75;
	self.glow_size = 270;
	self.nextthink = time + 0.1;
	self.think = vengeance_hknight2_bright04;
};
void()	vengeance_hknight2_bright02 	= {
	self.alpha = 0.3;
	self.colormod = '3 1 1';
	self.glow_color = 75;
	self.glow_size = 185;
	self.nextthink = time + 0.1;
	self.think = vengeance_hknight2_bright03;
}; 
void()	vengeance_hknight2_bright01 	= {
	self.alpha = 0.3;
	self.colormod = '2 1 1';
	self.glow_color = 75;
	self.glow_size = 100;
	self.nextthink = time + 0.1;
	self.think = vengeance_hknight2_bright02;
};
void()	vengeance_hknight2_bright00 	= {  			// delay for 0.3 seconds before overbright process really begins
	self.alpha = 0.3;
	self.glow_color = 75;
	self.glow_size = 10;
	self.nextthink = time + 0.3;
	self.think = vengeance_hknight2_bright01;
};



void(string modelname, float modelframe) vengeance_hknight2 =
{

local vector v;  			// v  was necessary at the begining of effect development, but isnt anymore now.

v_x = (self.origin_x);
v_y = (self.origin_y);
v_z = (self.origin_z);

//	precache_model ("progs/skull.mdl");		// precached in worldspawn() due to savegame-bug
//	precache_sound("vengeance/hknightmag.wav");	// precached in worldspawn() due to savegame-bug

      self.origin = v; 
   	self.touch = SUB_Null;                
	self.movetype = MOVETYPE_FLY;
	
	setmodel (self, "progs/warlord.mdl"); 

	setsize (self, '-16 -16 -24', '16 16 40');
	self.frame = modelframe;	 // modelframe is depending on the individual monster (included in vengeance call)

	var float autocvar_vengeancedamage = 0;   // set cvar 'vengeancedamage' default to 0
	if (autocvar_vengeancedamage == 0)	  	// if 'vengeancedamage' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '0'
		self.solid = SOLID_NOT;			// vengeance effect is NOT solid and cannot hurt the player
	else
		self.solid = SOLID_SLIDEBOX;    	// if value is NOT "0", player get hurt from this effect (see func "vengeance_hknight2_touch")!

	vengeance_hknight2_bright00 ();		// starts the animation
};


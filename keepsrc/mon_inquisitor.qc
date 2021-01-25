/*==============================================================================
INQUISITOR - For Twilight of the Idols map by Tronyn, for Stair of Grief Episode
==============================================================================*/

// Idle 70-72
void()	inquisitor_idle1	=[70,	inquisitor_idle2	] {ai_stand();  self.gravity = 1;};
void()	inquisitor_idle2	=[71,	inquisitor_idle3	] {ai_stand();};
void()	inquisitor_idle3	=[72,	inquisitor_idle1	] {ai_stand();};

// Walk 206-217
void()	inquisitor_walk1	=[206,	inquisitor_walk2	] {ai_walk(5); self.gravity = 1;};
void()	inquisitor_walk2	=[207,	inquisitor_walk3	] {ai_walk(4);};
void()	inquisitor_walk3	=[208,	inquisitor_walk4	] {ai_walk(3);};
void()	inquisitor_walk4	=[209,	inquisitor_walk5	] {ai_walk(5);};
void()	inquisitor_walk5	=[210,	inquisitor_walk6	] {ai_walk(6);};
void()	inquisitor_walk6	=[211,	inquisitor_walk7	] {ai_walk(5);};
void()	inquisitor_walk7	=[212,	inquisitor_walk8	] {ai_walk(5);};
void()	inquisitor_walk8	=[213,	inquisitor_walk9	] {ai_walk(4);};
void()	inquisitor_walk9	=[214,	inquisitor_walk10	] {ai_walk(4);};
void()	inquisitor_walk10	=[215,	inquisitor_walk11	] {ai_walk(3);};
void()	inquisitor_walk11	=[216,	inquisitor_walk12	] {ai_walk(3);};
void()	inquisitor_walk12	=[217,	inquisitor_walk1	] {ai_walk(6);};

void() inquisitor_flightland1;

void() InquisitorCheckSetDown = {
	// Should we stop flying?
	if (self.turrettimer < time) {
		self.think = inquisitor_flightland1;
		self.gravity = 1;
		self.nextthink = 0.1;
	} else {
		self.gravity = 0;
	}
};

// Fly 105-119
void()	inquisitor_run1	=[105,		inquisitor_run2	] {ai_run(13); InquisitorCheckSetDown (); self.gravity = 0;};
void()	inquisitor_run2	=[106,		inquisitor_run3	] {ai_run(13);};
void()	inquisitor_run3	=[107,		inquisitor_run4	] {ai_run(13);InquisitorCheckSetDown ();};
void()	inquisitor_run4	=[108,		inquisitor_run5	] {ai_run(13);};
void()	inquisitor_run5	=[109,		inquisitor_run6	] {ai_run(13);InquisitorCheckSetDown ();};
void()	inquisitor_run6	=[110,		inquisitor_run7	] {ai_run(13);};
void()	inquisitor_run7	=[111,		inquisitor_run8	] {ai_run(13);InquisitorCheckSetDown ();};
void()	inquisitor_run8	=[112,		inquisitor_run9	] {ai_run(13);};
void()	inquisitor_run9	=[113,		inquisitor_run10] {ai_run(13);InquisitorCheckSetDown ();};
void()	inquisitor_run10=[114,		inquisitor_run11] {ai_run(13);};
void()	inquisitor_run11=[115,		inquisitor_run12] {ai_run(13);InquisitorCheckSetDown ();};
void()	inquisitor_run12=[116,		inquisitor_run13] {ai_run(13);};
void()	inquisitor_run13=[117,		inquisitor_run14] {ai_run(13);InquisitorCheckSetDown ();};
void()	inquisitor_run14=[118,		inquisitor_run15] {ai_run(13);};
void()	inquisitor_run15=[119,		inquisitor_run1 ] {ai_run(13);InquisitorCheckSetDown ();};

// FlyAscend 89-104
// TouchDownFromFly 152-167
void()	inquisitor_flightland1=[152,inquisitor_flightland2] {ai_run(0); self.gravity = 1; };
void()	inquisitor_flightland2=[153,inquisitor_flightland3] {ai_run(0);};
void()	inquisitor_flightland3=[154,inquisitor_flightland4] {ai_run(0);};
void()	inquisitor_flightland4=[155,inquisitor_flightland5] {ai_run(0);};
void()	inquisitor_flightland5=[156,inquisitor_flightland6] {ai_run(0);};
void()	inquisitor_flightland6=[157,inquisitor_flightland7] {ai_run(0);};
void()	inquisitor_flightland7=[158,inquisitor_flightland8] {ai_run(0);};
void()	inquisitor_flightland8=[159,inquisitor_flightland9] {ai_run(0);};
void()	inquisitor_flightland9=[160,inquisitor_flightland10] {ai_run(0);};
void()	inquisitor_flightland10=[161,inquisitor_flightland11] {ai_run(0);};
void()	inquisitor_flightland11=[162,inquisitor_flightland12] {ai_run(0);};
void()	inquisitor_flightland12=[163,inquisitor_flightland13] {ai_run(0);};
void()	inquisitor_flightland13=[164,inquisitor_flightland14] {ai_run(0);};
void()	inquisitor_flightland14=[165,inquisitor_flightland15] {ai_run(0);};
void()	inquisitor_flightland15=[166,inquisitor_flightland16] {ai_run(0);};
void()	inquisitor_flightland16=[167,inquisitor_standrun1] {ai_run(0);};

void() InquisitorCheckAttack;

// StandRun 70-72
void()	inquisitor_standrun1=[70,		inquisitor_standrun2 ] {ai_run(0); InquisitorCheckAttack();  self.gravity = 1;};
void()	inquisitor_standrun2=[71,		inquisitor_standrun3 ] {ai_run(0);};
void()	inquisitor_standrun3=[72,		inquisitor_standrun1 ] {ai_run(0);};

// AttackStopPalmOut 51-72


// AttackStaffPlantHuge 0-12
// Shockwave knock players and monsters back, Cast multiple poison clouds that move around slowly
void()	inquisitor_magica1 =[0,	inquisitor_magica2	] {ai_face();};
void()	inquisitor_magica2 =[1,	inquisitor_magica3	] {ai_face();};
void()	inquisitor_magica3 =[2,	inquisitor_magica4	] {ai_face();};
void()	inquisitor_magica4 =[3,	inquisitor_magica5	] {ai_face();};
void()	inquisitor_magica5 =[4,	inquisitor_magica6	] {ai_face();};
void()	inquisitor_magica6 =[5,	inquisitor_magica7	] {ai_face();};
void()	inquisitor_magica7 =[6,	inquisitor_magica8	] {ai_face();};
void()	inquisitor_magica8 =[7,	inquisitor_magica9	] {ai_face();};
void()	inquisitor_magica9 =[8,	inquisitor_magica10	] {ai_face();};
void()	inquisitor_magica10=[9,	inquisitor_magica11	] {ai_face();};
void()	inquisitor_magica11=[10,inquisitor_magica12	] {ai_face();};
void()	inquisitor_magica12=[11,inquisitor_magica13	] {ai_face();};
void()	inquisitor_magica13=[12,inquisitor_standrun1] {ai_face();};

// AttackHoldStaffOut 13-27
void()	inquisitor_magicb1=[13,inquisitor_magicb2	] {ai_face();};
void()	inquisitor_magicb2=[14,inquisitor_magicb3	] {ai_face();};
void()	inquisitor_magicb3=[15,inquisitor_magicb4	] {ai_face();};
void()	inquisitor_magicb4=[16,inquisitor_magicb5	] {ai_face();};
void()	inquisitor_magicb5=[17,inquisitor_magicb6	] {ai_face();};
void()	inquisitor_magicb6=[18,inquisitor_magicb7	] {ai_face();};
void()	inquisitor_magicb7=[19,inquisitor_magicb8	] {ai_face();};
void()	inquisitor_magicb8=[20,inquisitor_magicb9	] {ai_face();};
void()	inquisitor_magicb9=[21,inquisitor_magicb10	] {ai_face();};
void()	inquisitor_magicb10=[22,inquisitor_magicb11	] {ai_face();};
void()	inquisitor_magicb11=[23,inquisitor_magicb12	] {ai_face();};
void()	inquisitor_magicb12=[24,inquisitor_magicb13	] {ai_face();};
void()	inquisitor_magicb13=[25,inquisitor_magicb14	] {ai_face();};
void()	inquisitor_magicb14=[26,inquisitor_magicb15	] {ai_face();};
void()	inquisitor_magicb15=[27,inquisitor_standrun1] {ai_face();};

// AttackRaiseHandsPalmOutAfter 29-50
void()	inquisitor_magicc1=	[29,inquisitor_magicc2]  {ai_face();};
void()	inquisitor_magicc2=	[30,inquisitor_magicc3]  {ai_face();};
void()	inquisitor_magicc3=	[31,inquisitor_magicc4]  {ai_face();};
void()	inquisitor_magicc4=	[32,inquisitor_magicc5]  {ai_face();};
void()	inquisitor_magicc5=	[33,inquisitor_magicc6]  {ai_face();};
void()	inquisitor_magicc6=	[34,inquisitor_magicc7]  {ai_face();};
void()	inquisitor_magicc7=	[35,inquisitor_magicc8]  {ai_face();};
void()	inquisitor_magicc8=	[36,inquisitor_magicc9]  {ai_face();};
void()	inquisitor_magicc9=	[37,inquisitor_magicc10] {ai_face();};
void()	inquisitor_magicc10=[38,inquisitor_magicc11] {ai_face();};
void()	inquisitor_magicc11=[39,inquisitor_magicc12] {ai_face();};
void()	inquisitor_magicc12=[40,inquisitor_magicc13] {ai_face();};
void()	inquisitor_magicc13=[41,inquisitor_magicc14] {ai_face();};
void()	inquisitor_magicc14=[42,inquisitor_magicc15] {ai_face();};
void()	inquisitor_magicc15=[43,inquisitor_magicc16] {ai_face();};
void()	inquisitor_magicc16=[44,inquisitor_magicc17] {ai_face();};
void()	inquisitor_magicc17=[45,inquisitor_magicc18] {ai_face();};
void()	inquisitor_magicc18=[46,inquisitor_magicc19] {ai_face();};
void()	inquisitor_magicc19=[47,inquisitor_magicc20] {ai_face();};
void()	inquisitor_magicc20=[48,inquisitor_magicc21] {ai_face();};
void()	inquisitor_magicc21=[49,inquisitor_magicc22] {ai_face();};
void()	inquisitor_magicc22=[50,inquisitor_standrun1]  {ai_face();};

void() inquisitor_bbomb_die1 = [0,inquisitor_bbomb_die2] {setmodel(self,"progs/ad171/s_burst_poison.spr"); T_RadiusDamage(self, self.owner,9,self.owner,DAMAGEALL);};
void() inquisitor_bbomb_die2 = [1,inquisitor_bbomb_die2] {};
void() inquisitor_bbomb_die3 = [2,inquisitor_bbomb_die2] {};
void() inquisitor_bbomb_die4 = [3,inquisitor_bbomb_die2] {};
void() inquisitor_bbomb_die5 = [4,inquisitor_bbomb_die2] {};
void() inquisitor_bbomb_die6 = [5,inquisitor_bbomb_die2] {};
void() inquisitor_bbomb_die7 = [6,inquisitor_bbomb_die1] { self.think = SUB_Remove; self.nextthink = time + 0.05;};

void() inquisitor_bbomb_burstcheck = {
	if (self.attack_finished < time) {
		self.think = inquisitor_bbomb_die1;
		self.nextthink = 0.1;
	}
};

void() inquisitor_bbomb_charge1 = [8,inquisitor_bbomb_charge2] {inquisitor_bbomb_burstcheck();};
void() inquisitor_bbomb_charge2 = [7,inquisitor_bbomb_charge3] {inquisitor_bbomb_burstcheck();};
void() inquisitor_bbomb_charge3 = [6,inquisitor_bbomb_charge4] {inquisitor_bbomb_burstcheck();};
void() inquisitor_bbomb_charge4 = [5,inquisitor_bbomb_die1] {inquisitor_bbomb_burstcheck();};

void() inquisitor_bilebomb_at_enemys_feet = {
	local entity missile;
	local vector org;

	self.effects = self.effects | EF_MUZZLEFLASH;
	missile = spawn();
	missile.owner = self;
	missile.movetype = MOVETYPE_NONE;
	missile.solid = SOLID_NOT;
	org = self.enemy.origin;
	missile.nextthink = time + 0.05;
	missile.think = inquisitor_bbomb_charge1;
	missile.attack_finished = time + 1.5;
	setmodel(missile,"progs/drake/s_spark.spr");
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(missile, org );
};

// AttackCastCircleSpell 71-88
void()	inquisitor_magicd1=	[71,inquisitor_magicd2]  {ai_face();};
void()	inquisitor_magicd2=	[72,inquisitor_magicd3]  {ai_face();};
void()	inquisitor_magicd3=	[73,inquisitor_magicd4]  {ai_face();};
void()	inquisitor_magicd4=	[74,inquisitor_magicd5]  {ai_face();};
void()	inquisitor_magicd5=	[75,inquisitor_magicd6]  {ai_face(); inquisitor_bilebomb_at_enemys_feet();};
void()	inquisitor_magicd6=	[76,inquisitor_magicd7]  {ai_face();};
void()	inquisitor_magicd7=	[77,inquisitor_magicd8]  {ai_face();};
void()	inquisitor_magicd8=	[78,inquisitor_magicd9]  {ai_face(); inquisitor_bilebomb_at_enemys_feet();};
void()	inquisitor_magicd9=	[79,inquisitor_magicd10] {ai_face();};
void()	inquisitor_magicd10=[80,inquisitor_magicd11] {ai_face();};
void()	inquisitor_magicd11=[81,inquisitor_magicd12] {ai_face();};
void()	inquisitor_magicd12=[82,inquisitor_magicd13] {ai_face(); inquisitor_bilebomb_at_enemys_feet();};
void()	inquisitor_magicd13=[83,inquisitor_magicd14] {ai_face();};
void()	inquisitor_magicd14=[84,inquisitor_magicd15] {ai_face();};
void()	inquisitor_magicd15=[85,inquisitor_magicd16] {ai_face();};
void()	inquisitor_magicd16=[86,inquisitor_magicd17] {ai_face();};
void()	inquisitor_magicd17=[87,inquisitor_magicd18] {ai_face();};
void()	inquisitor_magicd18=[88,inquisitor_standrun1] {ai_face();};

void() inquisitor_die = {
	// Pre-check routine to tidy up extra entities
	monster_death_precheck();
};

void() inquisitor_shieldon = {
	self.shield = 1;
	self.effects = EF_BRIGHTFIELD;
	self.takedamage = DAMAGE_NO;
};

void() inquisitor_shieldoff = {
	self.shield = 0;
	self.effects = 0;
	self.takedamage = DAMAGE_AIM;
};

// PainDownToHunch 185-205
void()	inquisitor_pain1=[185,inquisitor_pain2] { inquisitor_shieldon(); };
void()	inquisitor_pain2=[186,inquisitor_pain3] {};
void()	inquisitor_pain3=[187,inquisitor_pain4] {};
void()	inquisitor_pain4=[188,inquisitor_pain5] {};
void()	inquisitor_pain5=[189,inquisitor_pain6] {};
void()	inquisitor_pain6=[190,inquisitor_pain7] {};
void()	inquisitor_pain7=[191,inquisitor_pain8] {};
void()	inquisitor_pain8=[192,inquisitor_pain9] {};
void()	inquisitor_pain9=[193,inquisitor_pain10] {};
void()	inquisitor_pain10=[194,inquisitor_pain11] {};
void()	inquisitor_pain11=[195,inquisitor_pain12] {};
void()	inquisitor_pain12=[196,inquisitor_pain13] {};
void()	inquisitor_pain13=[197,inquisitor_pain14] {};
void()	inquisitor_pain14=[198,inquisitor_pain15] {};
void()	inquisitor_pain15=[199,inquisitor_pain16] {};
void()	inquisitor_pain16=[200,inquisitor_pain17] {};
void()	inquisitor_pain17=[201,inquisitor_pain18] {};
void()	inquisitor_pain18=[202,inquisitor_pain19] {};
void()	inquisitor_pain19=[203,inquisitor_pain20] {};
void()	inquisitor_pain20=[204,inquisitor_pain21] {};
void()	inquisitor_pain21=[205,inquisitor_pain22] {};

// HunchIdle 168-184
// Not used currently

// RiseFromHunchToFly 120-151
void()	inquisitor_pain22=[120,inquisitor_pain23] {};
void()	inquisitor_pain23=[121,inquisitor_pain24] {};
void()	inquisitor_pain24=[122,inquisitor_pain25] {};
void()	inquisitor_pain25=[123,inquisitor_pain26] {};
void()	inquisitor_pain26=[124,inquisitor_pain27] {};
void()	inquisitor_pain27=[125,inquisitor_pain28] {};
void()	inquisitor_pain28=[126,inquisitor_pain29] {};
void()	inquisitor_pain29=[127,inquisitor_pain30] {};
void()	inquisitor_pain30=[128,inquisitor_pain31] {};
void()	inquisitor_pain31=[129,inquisitor_pain32] {};
void()	inquisitor_pain32=[130,inquisitor_pain33] { inquisitor_shieldoff(); self.turrettimer = time + (random() * 15) + 8;};
void()	inquisitor_pain33=[131,inquisitor_pain34] {};
void()	inquisitor_pain34=[132,inquisitor_pain35] {};
void()	inquisitor_pain35=[133,inquisitor_pain36] {};
void()	inquisitor_pain36=[134,inquisitor_pain37] {};
void()	inquisitor_pain37=[135,inquisitor_pain38] {};
void()	inquisitor_pain38=[136,inquisitor_pain39] {};
void()	inquisitor_pain39=[137,inquisitor_pain40] {};
void()	inquisitor_pain40=[138,inquisitor_pain41] {};
void()	inquisitor_pain41=[139,inquisitor_pain42] {};
void()	inquisitor_pain42=[140,inquisitor_pain43] {};
void()	inquisitor_pain43=[141,inquisitor_pain44] {};
void()	inquisitor_pain44=[142,inquisitor_pain45] {};
void()	inquisitor_pain45=[143,inquisitor_pain46] {};
void()	inquisitor_pain46=[144,inquisitor_pain47] {};
void()	inquisitor_pain47=[145,inquisitor_pain48] {};
void()	inquisitor_pain48=[146,inquisitor_pain49] {};
void()	inquisitor_pain49=[147,inquisitor_pain50] {};
void()	inquisitor_pain50=[148,inquisitor_pain51] {};
void()	inquisitor_pain51=[149,inquisitor_pain52] {};
void()	inquisitor_pain52=[150,inquisitor_pain53] {};
void()	inquisitor_pain53=[151,inquisitor_run1] {}; // go to fly

void(entity inflictor, entity attacker, float damage) inquisitor_pain = {
	if (self.health > 4500 && self.count == 0) return; // stage 1
	if (self.health > 3000 && self.count == 1) return; // stage 2
	if (self.health > 1500 && self.count == 2) return; // stage 3

	if (self.count >= 3) return;  // stage 4
	self.count = self.count + 1;
	inquisitor_pain1();
}

void() InquisitorCheckAttack = {
	local float rnd;

	rnd = random() * 100;
	// What should we do now, 25% chance good enough for all attacks?
	if (rnd < 25)
		inquisitor_magica1();
	else if (rnd < 50)
		inquisitor_magicb1();
	else if (rnd < 75)
		inquisitor_magicc1();
	else
		inquisitor_magicd1();
};

/*======================================================================
 QUAKED monster_inquisitor (1 0 0) (-16 -16 -24) (16 16 40) Ambush
======================================================================*/
void() monster_inquisitor =
{
	if (deathmatch) { remove(self); return; }

	self.mdl = "progs/inquisitor.mdl";
	precache_model (self.mdl);

	// small bile drop
	precache_model ("progs/quoth2pt2full/bilefrag.mdl"); // frames 0-5

	// large bilebomb
	precache_model ("progs/quoth2pt2full/bilebomb.mdl"); // frames 0-5

	// blobby burst effect
	precache_model ("progs/quoth2pt2full/greenexp.spr"); // frames 0-5

	// burst effect
	precache_model ("progs/quoth2pt2full/s_vp_pll.spr"); // frames 53-57

	// poison cloud that moves around randomly
	precache_model ("progs/ad171/s_exp_poison_med.spr"); // grow 0-2, cloud 2-5, dissipate 5-13

	// poison burst
	precache_model ("progs/drake/s_fancy.spr"); // small puff 15-20, poison burst 115-119, puff 147-149

	// poison drip
	precache_model ("progs/ad171/s_dripgreen.spr"); // frame 0

	// poison drip splash
	precache_model ("progs/ad171/s_dripsplgreen.spr"); // frames 0-5

	// poison burst good
	precache_model ("progs/ad171/s_burst_poison.spr"); // frames 0-6

	// poison burst good small yellowish
	precache_model ("progs/ad171/s_exp_poison_small.spr"); // frames 0-12

	// sparkle
	precache_model ("progs/drake/s_spark.spr"); // frames 8-5 reverse
	
	self.idle_sound = "ad171/skullwiz/idle1.wav";
	precache_sound (self.idle_sound);
	self.pain_sound = "ad171/skullwiz/pain2.wav";
	precache_sound (self.pain_sound);
	self.sight_sound = "ad171/skullwis/idle2.wav";
	precache_sound (self.sight_sound);
	self.death_sound = "ad171/skullwis/fadeaway.wav";
	precache_sound (self.death_sound);

	precache_sound ("ad171/skullwis/poison_hit.wav");
	
	self.solid = SOLID_NOT;				// No interaction with world until spawned
	self.movetype = MOVETYPE_NONE;		// Static item, no movement until spawned
	if (self.bboxtype < 1) self.bboxtype = BBOX_TALL;  // -16 -16 -24, 16 16 40
	if (self.health < 1) self.health = 6000;
	self.pain_flinch = 100;					// Medium pain threshold
	self.pain_timeout = 5;				// High
	self.no_liquiddmg = TRUE;
	self.count = 0; //reset pain states
	
	// Always reset Ammo Resistance to be consistent
	self.resist_shells = self.resist_nails = 0;
	self.resist_rockets = self.resist_cells = 0;

	self.pain_longanim = FALSE;		// can't be chopped with shadow axe
	self.classgroup = CG_WIZARD;	// Creepy dudes

	self.th_stand = inquisitor_idle1;		// Idling on feet
	self.th_walk = inquisitor_walk1;		// Walking
	self.th_run = inquisitor_standrun1;			// Running
	self.th_missile = InquisitorCheckAttack;	// Fire
	self.th_pain = inquisitor_pain;		// Stumble and pain
	self.th_die = inquisitor_die;			// Face meets floor

	if (self.deathstring == "") self.deathstring = " was poisoned to death by the Inquisitor\n";
	self.classtype = CT_MONINQUISITOR;
	self.classmove = MON_MOVEFLY;
	monster_start();
};
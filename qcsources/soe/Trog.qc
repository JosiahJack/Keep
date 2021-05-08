/*
============================================================================

Da Mage, vII

============================================================================
*/

$cd /progs/necro
$origin 0 0 24
$base wizbase	
$skin wizbase

$frame die1 die2 die3 die4 die5 die6 die7 die8 die9 die10
$frame die11 die12 die13 die14 die15 die16 die17 die18 die19 die20

$frame decap1 decap2 decap3 decap4 decap5 decap6 decap7 decap8 decap9 decap10
$frame decap11 decap12 decap13 decap14 decap15 decap16 decap17 decap18 decap19 decap20

// warlock frames
$frame haat1 haat2 haat3 haat4 haat5 haat6 haat7 haat8
$frame hapn1 hapn2 hapn3 hapn4 hapn5 hapn6 hapn7 hapn8
$frame harn1 harn2 harn3 harn4 harn5 harn6 harn7 harn8 harn9 harn10 harn11 harn12
$frame hast1 hast2 hast3 hast4 hast5 hast6 hast7 hast8 hast9 hast10 hast11 hast12

// acolyte
$frame siat1 siat2 siat3 siat4 siat5 siat6 siat7 siat8 siat9 siat10 siat11 siat12
$frame sipn1 sipn2 sipn3 sipn4 sipn5 sipn6 sipn7 sipn8
$frame sirn1 sirn2 sirn3 sirn4 sirn5 sirn6 sirn7 sirn8 sirn9 sirn10 sirn11 sirn12
$frame sist1 sist2 sist3 sist4 sist5 sist6 sist7 sist8 sist9 sist10 sist11 sist12

// sorceror
$frame stat1 stat2 stat3 stat4 stat5 stat6 stat7 stat8
$frame stpn1 stpn2 stpn3 stpn4 stpn5 stpn6 stpn7 stpn8
$frame strn1 strn2 strn3 strn4 strn5 strn6 strn7 strn8 strn9 strn10 strn11 strn12
$frame stst1 stst2 stst3 stst4 stst5 stst6 stst7 stst8 stst9 stst10 stst11 stst12
// prototypes
// void() fwiz_missile;
void() fwiz_idlesound;
// void() wiz_gib;
void() warlock_fire;
void() acolyte_fire;

void()	ac_stand1	=[	$sist1,		ac_stand2	] {ai_stand(); fwiz_idlesound();};
void()	ac_stand2	=[	$sist2,		ac_stand3	] {ai_stand();};
void()	ac_stand3	=[	$sist3,		ac_stand4	] {ai_stand();};
void()	ac_stand4	=[	$sist4,		ac_stand5	] {ai_stand();};
void()	ac_stand5	=[	$sist1,		ac_stand6	] {ai_stand();};
void()	ac_stand6	=[	$sist2,		ac_stand7	] {ai_stand();};
void()	ac_stand7	=[	$sist3,		ac_stand8	] {ai_stand();};
void()	ac_stand8	=[	$sist4,		ac_stand9	] {ai_stand();};
void()	ac_stand9	=[	$sist1,		ac_stand10	] {ai_stand();};
void()	ac_stand10	=[	$sist2,		ac_stand11	] {ai_stand();};
void()	ac_stand11	=[	$sist3,		ac_stand12	] {ai_stand();};
void()	ac_stand12	=[	$sist4,		ac_stand1	] {ai_stand();};

void()	sor_stand1	=[	$stst1,		sor_stand2	] {ai_stand(); fwiz_idlesound();};
void()	sor_stand2	=[	$stst2,		sor_stand3	] {ai_stand();};
void()	sor_stand3	=[	$stst3,		sor_stand4	] {ai_stand();};
void()	sor_stand4	=[	$stst4,		sor_stand5	] {ai_stand();};
void()	sor_stand5	=[	$stst5,		sor_stand6	] {ai_stand();};
void()	sor_stand6	=[	$stst6,		sor_stand7	] {ai_stand();};
void()	sor_stand7	=[	$stst7,		sor_stand8	] {ai_stand();};
void()	sor_stand8	=[	$stst8,		sor_stand9	] {ai_stand();};
void()	sor_stand9	=[	$stst9,		sor_stand10	] {ai_stand();};
void()	sor_stand10	=[	$stst10,		sor_stand11	] {ai_stand();};
void()	sor_stand11	=[	$stst11,		sor_stand12	] {ai_stand();};
void()	sor_stand12	=[	$stst12,		sor_stand1	] {ai_stand();};

void()	war_stand1	=[	$hast1,		war_stand2	] {ai_stand(); fwiz_idlesound();};
void()	war_stand2	=[	$hast2,		war_stand3	] {ai_stand();};
void()	war_stand3	=[	$hast3,		war_stand4	] {ai_stand();};
void()	war_stand4	=[	$hast4,		war_stand5	] {ai_stand();};
void()	war_stand5	=[	$hast5,		war_stand6	] {ai_stand();};
void()	war_stand6	=[	$hast6,		war_stand7	] {ai_stand();};
void()	war_stand7	=[	$hast7,		war_stand8	] {ai_stand();};
void()	war_stand8	=[	$hast8,		war_stand9	] {ai_stand();};
void()	war_stand9	=[	$hast9,		war_stand10	] {ai_stand();};
void()	war_stand10	=[	$hast10,		war_stand11	] {ai_stand();};
void()	war_stand11	=[	$hast11,		war_stand12	] {ai_stand();};
void()	war_stand12	=[	$hast12,		war_stand1	] {ai_stand();};

void()	ac_walk1	=[	$sirn2,		ac_walk2	] {ai_walk(8); fwiz_idlesound();};
void()	ac_walk2	=[	$sirn4,		ac_walk3	] {ai_walk(8);};
void()	ac_walk3	=[	$sirn6,		ac_walk4	] {ai_walk(8);};
void()	ac_walk4	=[	$sirn8,		ac_walk5	] {ai_walk(8);};
void()	ac_walk5	=[	$sirn10,		ac_walk6	] {ai_walk(8);};
void()	ac_walk6	=[	$sirn12,		ac_walk1	] {ai_walk(8);};

void()	ac_run1	=[	$sirn1,		ac_run2	] {ai_run(16); fwiz_idlesound();};
void()	ac_run2	=[	$sirn2,		ac_run3	] {ai_run(16);};
void()	ac_run3	=[	$sirn3,		ac_run4	] {ai_run(16);};
void()	ac_run4	=[	$sirn4,		ac_run5	] {ai_run(16);};
void()	ac_run5	=[	$sirn5,		ac_run6	] {ai_run(16);};
void()	ac_run6	=[	$sirn6,		ac_run7	] {ai_run(16);};
void()	ac_run7	=[	$sirn7,		ac_run8	] {ai_run(16); fwiz_idlesound();};
void()	ac_run8	=[	$sirn8,		ac_run9	] {ai_run(16);};
void()	ac_run9	=[	$sirn9,		ac_run10	] {ai_run(16);};
void()	ac_run10	=[	$sirn10,		ac_run11	] {ai_run(16);};
void()	ac_run11	=[	$sirn11,		ac_run12	] {ai_run(16);};
void()	ac_run12	=[	$sirn12,		ac_run1	] {ai_run(16);};

void()	sor_walk1	=[	$strn2,		sor_walk2	] {ai_walk(8); fwiz_idlesound();};
void()	sor_walk2	=[	$strn4,		sor_walk3	] {ai_walk(8);};
void()	sor_walk3	=[	$strn6,		sor_walk4	] {ai_walk(8);};
void()	sor_walk4	=[	$strn8,		sor_walk5	] {ai_walk(8);};
void()	sor_walk5	=[	$strn10,		sor_walk6	] {ai_walk(8);};
void()	sor_walk6	=[	$strn12,		sor_walk1	] {ai_walk(8);};

void()	sor_run1		=[	$strn1,		sor_run2		] {ai_run(16); fwiz_idlesound();};
void()	sor_run2		=[	$strn2,		sor_run3		] {ai_run(16);};
void()	sor_run3		=[	$strn3,		sor_run4		] {ai_run(16);};
void()	sor_run4		=[	$strn4,		sor_run5		] {ai_run(16);};
void()	sor_run5		=[	$strn5,		sor_run6		] {ai_run(16);};
void()	sor_run6		=[	$strn6,		sor_run7		] {ai_run(16);};
void()	sor_run7		=[	$strn7,		sor_run8		] {ai_run(16); fwiz_idlesound();};
void()	sor_run8		=[	$strn8,		sor_run9		] {ai_run(16);};
void()	sor_run9		=[	$strn9,		sor_run10	] {ai_run(16);};
void()	sor_run10	=[	$strn10,		sor_run11	] {ai_run(16);};
void()	sor_run11	=[	$strn11,		sor_run12	] {ai_run(16);};
void()	sor_run12	=[	$strn12,		sor_run1		] {ai_run(16);};

void()	war_walk1	=[	$harn2,		war_walk2	] {ai_walk(8); fwiz_idlesound();};
void()	war_walk2	=[	$harn4,		war_walk3	] {ai_walk(8);};
void()	war_walk3	=[	$harn6,		war_walk4	] {ai_walk(8);};
void()	war_walk4	=[	$harn8,		war_walk5	] {ai_walk(8);};
void()	war_walk5	=[	$harn10,		war_walk6	] {ai_walk(8);};
void()	war_walk6	=[	$harn12,		war_walk1	] {ai_walk(8);};

void()	war_run1		=[	$harn1,		war_run2		] {ai_run(16); fwiz_idlesound();};
void()	war_run2		=[	$harn2,		war_run3		] {ai_run(16);};
void()	war_run3		=[	$harn3,		war_run4		] {ai_run(16);};
void()	war_run4		=[	$harn4,		war_run5		] {ai_run(16);};
void()	war_run5		=[	$harn5,		war_run6		] {ai_run(16);};
void()	war_run6		=[	$harn6,		war_run7		] {ai_run(16);};
void()	war_run7		=[	$harn7,		war_run8		] {ai_run(16); fwiz_idlesound();};
void()	war_run8		=[	$harn8,		war_run9		] {ai_run(16);};
void()	war_run9		=[	$harn9,		war_run10	] {ai_run(16);};
void()	war_run10	=[	$harn10,		war_run11	] {ai_run(16);};
void()	war_run11	=[	$harn11,		war_run12	] {ai_run(16);};
void()	war_run12	=[	$harn12,		war_run1		] {ai_run(16);};

void()	war_attack1	=[	$haat1,	war_attack2	] {ai_face();};
void()	war_attack2	=[	$haat2,	war_attack3	] {ai_face();};
void()	war_attack3	=[	$haat3,	war_attack4	] {ai_face(); warlock_fire();};
void()	war_attack4	=[	$haat4,	war_attack5	] {ai_face();};
void()	war_attack5	=[	$haat5,	war_attack6	]
{
	ai_face();
	if (skill > 2)
		warlock_fire();
};
void()	war_attack6	=[	$haat6,	war_attack7	] {ai_face();};
void()	war_attack7	=[	$haat7,	war_attack8	] {ai_face();};
void()	war_attack8	=[	$haat8,	war_run1		] {ai_face();};

void()	sor_attack1	=[	$stat1,	sor_attack2	] {ai_face();};
void()	sor_attack2	=[	$stat2,	sor_attack3	] {ai_face(); Trog_FireBall();};
void()	sor_attack3	=[	$stat3,	sor_attack4	] {ai_face();};
void()	sor_attack4	=[	$stat4,	sor_attack5	]
{
	ai_face();
	if (skill > 2)
		Trog_FireBall();
};
void()	sor_attack5	=[	$stat5,	sor_attack6	] {ai_face();};
void()	sor_attack6	=[	$stat6,	sor_attack7	] {ai_face();};
void()	sor_attack7	=[	$stat7,	sor_attack8	] {ai_face();};
void()	sor_attack8	=[	$stat8,	sor_run1		] {ai_face();};

void()	ac_attack1	=[	$siat1,	ac_attack2	] {ai_face();};
void()	ac_attack2	=[	$siat2,	ac_attack3	] {ai_face();};
void()	ac_attack3	=[	$siat3,	ac_attack4	] {ai_face();};
void()	ac_attack4	=[	$siat4,	ac_attack5	] {ai_face();};
void()	ac_attack5	=[	$siat5,	ac_attack6	] {ai_face(); acolyte_fire();};
void()	ac_attack6	=[	$siat6,	ac_attack7	] {ai_face();};
void()	ac_attack7	=[	$siat7,	ac_attack8	] {ai_face(); acolyte_fire();};
void()	ac_attack8	=[	$siat8,	ac_attack9	] {ai_face();};
void()	ac_attack9	=[	$siat9,	ac_attack10	] {ai_face();};
void()	ac_attack10	=[	$siat10,	ac_attack11	] {ai_face();};
void()	ac_attack11	=[	$siat11,	ac_attack12	] {ai_face();};
void()	ac_attack12	=[	$siat12,	ac_run1	] {ai_face();};

// void()	war_shove1	=	{};
// Shoves the player back a ways
// In order to do this, I need to:
// 1. Turn off victim's FL_ONGROUND flag
// 2. Give victim a suitable velocity in the right direction

// void()	sor_whack1	=	{};
// Clouts the player with that staff

// Slashes the player with sickle, makes him ickle?
void()	ac_slice1	=[	$siat1,	ac_slice2	] {ai_face();};
void()	ac_slice2	=[	$siat2,	ac_slice3	] {ai_face();};
void()	ac_slice3	=[	$siat3,	ac_slice4	] {ai_face();};
void()	ac_slice4	=[	$siat4,	ac_slice5	] {ai_face(); sound (self, CHAN_WEAPON, "knight/sword1.wav", 1, ATTN_NORM);};
void()	ac_slice5	=[	$siat5,	ac_slice6	] {ai_face(); ai_melee();};
void()	ac_slice6	=[	$siat6,	ac_slice7	]
{
	ai_face();
	ai_melee();
	// IF can damage player THEN increase disease rating
};
void()	ac_slice7	=[	$siat7,	ac_slice8	] {ai_face(); ai_melee();};
void()	ac_slice8	=[	$siat8,	ac_slice9	] {ai_face();};
void()	ac_slice9	=[	$siat9,	ac_slice10	] {ai_face();};
void()	ac_slice10	=[	$siat10,	ac_slice11	] {ai_face();};
void()	ac_slice11	=[	$siat11,	ac_slice12	] {ai_face();};
void()	ac_slice12	=[	$siat12,	ac_run1	] {ai_face();};

void() warlock_MissileTouch =
{
	local float	damg;

	if (other == self.owner)
		return;		// don't explode on owner

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

	damg = 50 + random()*20;
	
	if (other.health)
	{
		if (other.classname == "monster_warlock")
			damg = 0;			// totally immune
		T_Damage (other, self, self.owner, damg );
	}

	// don't do radius damage to the other, because all the damage
	// was done in the impact
	T_RadiusDamage (self, self.owner, 120, other);

//	sound (self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);
	self.origin = self.origin - 8*normalize(self.velocity);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);

	BecomeExplosion ();
};

/*
================
warlock_fire

Warlocks fire red bolts that act like half-power rockets.
================
*/
void() warlock_fire =
{
	local	entity missile, mpuff;
	local	vector vec, dst;
	
	sound (self, CHAN_WEAPON, "fwiz/dsbospit.wav", 1, ATTN_NORM);
	self.effects = self.effects | EF_MUZZLEFLASH;

	self.punchangle_x = -2;

	missile = spawn ();
	missile.owner = self;
	missile.enemy = self.enemy;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
		
// set missile speed	

	dst = self.enemy.origin - 13*self.movedir;
	
	vec = normalize(dst - self.origin);
	missile.velocity = vec * 500;
	missile.angles = vectoangles(missile.velocity);
	
	missile.touch = warlock_MissileTouch;
	
// set missile duration
	missile.nextthink = time + 0.8;
	missile.think = SUB_Remove;

	setmodel (missile, "progs/fbolt2.mdl");
	setsize (missile, '0 0 0', '0 0 0');		
	setorigin (missile, self.origin + v_forward*8 + '0 0 16');
};

void() acolyte_firethink =
{
	local vector		vec;
	local vector		dst;

	if (self.owner.health > 0)
	{
		self.owner.effects = self.owner.effects | EF_MUZZLEFLASH;

		makevectors (self.enemy.angles);	
		dst = self.enemy.origin - 13*self.movedir;
	
		vec = normalize(dst - self.origin);
		sound (self, CHAN_WEAPON, "wizard/wattack.wav", 1, ATTN_NORM);
		launch_spike (self.origin, vec);
		newmis.velocity = vec*600;
		newmis.owner = self.owner;
		newmis.classname = "acospike";
		setmodel (newmis, "progs/w_spike.mdl");
		setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);		
	}

	remove (self);
};

void() acolyte_fire =
{
	// fires plague darts. If enough hit, your health starts to rot (a la Megahealth)
	// must find a health box to cure it
	local	entity	missile;
	
	sound (self, CHAN_WEAPON, "wizard/wattack.wav", 1, ATTN_NORM);
	self.v_angle = self.angles;
	makevectors (self.angles);

	missile = spawn ();
	missile.owner = self;
	missile.nextthink = time + 0.6;
	setsize (missile, '0 0 0', '0 0 0');		
	setorigin (missile, self.origin + '0 0 30' + v_forward*14 + v_right*14);
	missile.enemy = self.enemy;
	missile.nextthink = time + 0.8;
	missile.think = acolyte_firethink;
	missile.movedir = VEC_ORIGIN;
};

void()	ac_pain1	=[	$sipn1,		ac_pain2	]{};
void()	ac_pain2	=[	$sipn2,		ac_pain3	]{};
void()	ac_pain3	=[	$sipn3,		ac_pain4	]{};
void()	ac_pain4	=[	$sipn4,		ac_pain5	]{self.pain_finished = 1;};
void()	ac_pain5	=[	$sipn5,		ac_pain6	]{};
void()	ac_pain6	=[	$sipn6,		ac_pain7	]{};
void()	ac_pain7	=[	$sipn7,		ac_pain8	]{};
void()	ac_pain8	=[	$sipn8,		ac_run1	]{};

void()	sor_pain1	=[	$stpn1,		sor_pain2	]{};
void()	sor_pain2	=[	$stpn2,		sor_pain3	]{};
void()	sor_pain3	=[	$stpn3,		sor_pain4	]{};
void()	sor_pain4	=[	$stpn4,		sor_pain5	]{self.pain_finished = 1;};
void()	sor_pain5	=[	$stpn5,		sor_pain6	]{};
void()	sor_pain6	=[	$stpn6,		sor_pain7	]{};
void()	sor_pain7	=[	$stpn7,		sor_pain8	]{};
void()	sor_pain8	=[	$stpn8,		sor_run1	]{};

void()	war_pain1	=[	$hapn1,		war_pain2	]{};
void()	war_pain2	=[	$hapn2,		war_pain3	]{};
void()	war_pain3	=[	$hapn3,		war_pain4	]{};
void()	war_pain4	=[	$hapn4,		war_pain5	]{self.pain_finished = 1;};
void()	war_pain5	=[	$hapn5,		war_pain6	]{};
void()	war_pain6	=[	$hapn6,		war_pain7	]{};
void()	war_pain7	=[	$hapn7,		war_pain8	]{};
void()	war_pain8	=[	$hapn8,		war_run1	]{};

void()	fwiz_death1	=[	$die1,		fwiz_death2	] {
   sound (self, CHAN_VOICE, "fwiz/fwiz_d1.wav", 1, ATTN_NORM);
};
void()	fwiz_death2	=[	$die2,		fwiz_death3	] {};
void()	fwiz_death3	=[	$die3,		fwiz_death4	]{self.solid = SOLID_NOT;};
void()	fwiz_death4	=[	$die4,		fwiz_death5	] {};
void()	fwiz_death5	=[	$die5,		fwiz_death6	] {};
void()	fwiz_death6	=[	$die6,		fwiz_death7	] {};
void()	fwiz_death7	=[	$die7,		fwiz_death8	] {};
void()	fwiz_death8	=[	$die8,		fwiz_death9	] {};
void()	fwiz_death9	=[	$die9,		fwiz_death10	] {};
void()	fwiz_death10	=[	$die10,		fwiz_death11	] {};
void()	fwiz_death11	=[	$die11,		fwiz_death12	] {};
void()	fwiz_death12	=[	$die12,		fwiz_death13	] {};
void()	fwiz_death13	=[	$die13,		fwiz_death14	] {};
void()	fwiz_death14	=[	$die14,		fwiz_death15	] {};
void()	fwiz_death15	=[	$die15,		fwiz_death16	] {};
void()	fwiz_death16	=[	$die16,		fwiz_death17	] {};
void()	fwiz_death17	=[	$die17,		fwiz_death18	] {};
void()	fwiz_death18	=[	$die18,		fwiz_death19	] {};
void()	fwiz_death19	=[	$die19,		fwiz_death20	] {};
void()	fwiz_death20	=[	$die20,		fwiz_death20	] {ai_dike();};

void()	fwiz_gib1	=[	$decap1,		fwiz_gib2	] {};
void()	fwiz_gib2	=[	$decap2,		fwiz_gib3	]
{
	sound (self, CHAN_VOICE, "player/teledth1.wav", 1, ATTN_NORM);
	ThrowHead ("progs/h_zombie.mdl", self.health*10);
};
void()	fwiz_gib3	=[	$decap3,		fwiz_gib4	]{self.solid = SOLID_NOT;};
void()	fwiz_gib4	=[	$decap4,		fwiz_gib5	] {};
void()	fwiz_gib5	=[	$decap5,		fwiz_gib6	] {};
void()	fwiz_gib6	=[	$decap6,		fwiz_gib7	] {};
void()	fwiz_gib7	=[	$decap7,		fwiz_gib8	] {};
void()	fwiz_gib8	=[	$decap8,		fwiz_gib9	] {};
void()	fwiz_gib9	=[	$decap9,		fwiz_gib10	] {};
void()	fwiz_gib10	=[	$decap10,	fwiz_gib11	] {};
void()	fwiz_gib11	=[	$decap11,	fwiz_gib12	] {};
void()	fwiz_gib12	=[	$decap12,	fwiz_gib13	] {};
void()	fwiz_gib13	=[	$decap13,	fwiz_gib14	] {};
void()	fwiz_gib14	=[	$decap14,	fwiz_gib15	] {};
void()	fwiz_gib15	=[	$decap15,	fwiz_gib16	] {};
void()	fwiz_gib16	=[	$decap16,	fwiz_gib17	] {};
void()	fwiz_gib17	=[	$decap17,	fwiz_gib18	] {};
void()	fwiz_gib18	=[	$decap18,	fwiz_gib19	] {};
void()	fwiz_gib19	=[	$decap19,	fwiz_gib20	] {};
void()	fwiz_gib20	=[	$decap20,	fwiz_gib20	]
{
	sound (self, CHAN_VOICE, "player/tornoff2.wav", 1, ATTN_NORM);
	ThrowGib ("progs/gib2.mdl", self.health);
	ThrowGib ("progs/gib2.mdl", self.health);
	ThrowGib ("progs/gib2.mdl", self.health);
	return;
};

void() fwiz_die =
{
// check for gib
	if (self.health < -40)
	{
		fwiz_gib1();
		return;
	}

	fwiz_death1 ();
};

void() fwiz_idlesound =
{
local float wr;
	wr = random() * 20;

	if (self.waitmin < time)
	{
	 	self.waitmin = time + 10;
	 	if ((wr > 7.0) && (wr < 10))
			sound (self, CHAN_AUTO, "fwiz/fwiz_i1.wav", 1, ATTN_NORM);
		else if ((wr > 4.0) && (wr < 7.0))
			sound (self, CHAN_AUTO, "fwiz/fwiz_i2.wav", 1, ATTN_NORM);
		else if ((wr > 1.0) && (wr < 4.0))
			sound (self, CHAN_AUTO, "fwiz/fwiz_i3.wav", 1, ATTN_NORM);
	}
};

void(entity attacker, float damage) fwiz_pain =
{
	if (self.pain_finished)
	{
		sound (self, CHAN_VOICE, "fwiz/fwiz_p1.wav", 1, ATTN_NORM);
		if (random()*70 > damage)
			return;		// didn't flinch

		self.pain_finished = 0;
		if (damage >= 40)
		{
			if (self.ammo_shells == 0)
				ac_pain1();
			if (self.ammo_shells == 1)
				sor_pain1();
			if (self.ammo_shells == 2)
				war_pain1();
		}
	}
};

/*QUAKED monster_fragwiz (1 0 0) (-16 -16 -24) (16 16 40) Ambush
The magi for Coven of Ebony:

acolyte	Grunt equivalent. Fires plague darts that make you very sick if enough hit.
sorceror	Tougher version, fires big fat lightning balls.
warlock	Hard bastard. Shoots strange red exploding firebolts.
*/
void(float mode) monster_fragwiz =
{
	local float i;
	i = cvar("temp1");

	if (notHere() || ((mode < 0) || (mode > 3)) || deathmatch || i == 1)
	{
		remove(self);
		return;
	}
	self.ammo_shells = mode;

	precache_model ("progs/necro.mdl");
	precache_model ("progs/trogball.mdl");
	precache_model ("progs/fbolt2.mdl");
	precache_model ("progs/h_zombie.mdl");
	precache_model ("progs/w_spike.mdl");

	precache_sound ("fwiz/fwiz_i1.wav");	// idle
	precache_sound ("fwiz/fwiz_i2.wav");
	precache_sound ("fwiz/fwiz_i3.wav");
	precache_sound ("fwiz/fwiz_s1.wav");	// sight
	precache_sound ("fwiz/fwiz_p1.wav");	// pain
	precache_sound ("fwiz/fwiz_d1.wav");	// death
	precache_sound ("trog/frblatck.wav");	// sorceror fire sounds
	precache_sound ("trog/frblfly.wav");
	precache_sound ("fwiz/dsbospit.wav");	// warlock fire sound
	precache_sound ("player/teledth1.wav");
	precache_sound ("player/tornoff2.wav");	// decapitation :)
	precache_sound ("wizard/wattack.wav");
	precache_sound ("knight/sword1.wav");
	precache_sound ("hknight/hit.wav");

	self.th_pain = fwiz_pain;
	self.th_die = fwiz_die;

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	self.pain_finished = 1;

	if(mode == 2)	// warlock
	{
		self.health = 600;
		self.th_stand = war_stand1;
		self.th_walk = war_walk1;
		self.th_run = war_run1;
		self.th_missile = war_attack1;
		self.th_melee = ac_slice1;
	}
	else if (mode == 1)
	{
		self.health = 400;
		self.th_stand = sor_stand1;
		self.th_walk = sor_walk1;
		self.th_run = sor_run1;
		self.th_missile = sor_attack1;
		self.th_melee = ac_slice1;
		self.classname = "monster_sorceror";
	}
	else
	{
		self.health = 200;
		self.th_stand = ac_stand1;
		self.th_walk = ac_walk1;
		self.th_run = ac_run1;
		self.th_missile = ac_attack1;
		self.th_melee = ac_slice1;
	}

	setmodel (self, "progs/necro.mdl");

	setsize (self, '-16 -16 -24', '16 16 40');

	walkmonster_start ();
};

void() monster_acolyte =
{
	monster_fragwiz(0);
};

void() monster_sorceror =
{
	monster_fragwiz(1);
};

void() monster_warlock =
{
	monster_fragwiz(2);
};
/*
==============================================================================

Spider

Model by Psionic
Quake implementation (incl. sounds) by Seven

Monster properties:
3 different melee attacks
1 long jump attack (like the demon)
1 ranged attack: Spits out webs that glues the player to the ground for a short (adjustable) time
Has an adjustable chance to resist shotguns and nailguns attacks
Has an adjustable chance of hiding/sneeking inside the ground (= suprise attack)
Fully adjustable replacement monster for all Quake monsters (via cvar)

==============================================================================
*/

$cd id1/models/spider
$origin 0 0 24
$base base
$skin skin

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9 walk10
$frame walk11 walk12 walk13 walk14 walk15 walk16 walk17 walk18 walk19 walk20
$frame walk21 walk22 walk23 walk24

$frame run1 run2 run3 run4 run5 run6 run7 run8 run9 run10
$frame run11 run12

$frame underground1 underground2 underground3 underground4 underground5 underground6 underground7 underground8 underground9 underground10
$frame underground11 underground12 underground13 underground14 underground15 underground16 underground17 underground18 underground19 underground20
$frame underground21 underground22 underground23 underground24 underground25 underground26 underground27 underground28 underground29 underground30
$frame underground31 underground32 underground33 underground34 underground35 underground36 underground37 underground38 underground39 underground40
$frame underground41 underground42 underground43 underground44 underground45

$frame jumpz1 jumpz2 jumpz3 jumpz4 jumpz5 jumpz6 jumpz7 jumpz8 jumpz9 jumpz10
$frame jumpz11 jumpz12 jumpz13 jumpz14 jumpz15 jumpz16 jumpz17 jumpz18

$frame jumpnoz1 jumpnoz2 jumpnoz3 jumpnoz4 jumpnoz5 jumpnoz6 jumpnoz7 jumpnoz8 jumpnoz9 jumpnoz10
$frame jumpnoz11 jumpnoz12 jumpnoz13 jumpnoz14 jumpnoz15 jumpnoz16 jumpnoz17 jumpnoz18

$frame frontup1 frontup2 frontup3 frontup4 frontup5 frontup6 frontup7 frontup8 frontup9 frontup10
$frame frontup11 frontup12 frontup13 frontup14 frontup15 frontup16 frontup17 frontup18 frontup19 frontup20
$frame frontup21 frontup22 frontup23 frontup24 frontup25 frontup26 frontup27 frontup28

$frame crouchlook1 crouchlook2 crouchlook3 crouchlook4 crouchlook5 crouchlook6 crouchlook7 crouchlook8 crouchlook9 crouchlook10
$frame crouchlook11 crouchlook12 crouchlook13 crouchlook14 crouchlook15 crouchlook16 crouchlook17 crouchlook18 crouchlook19 crouchlook20
$frame crouchlook21 crouchlook22 crouchlook23 crouchlook24 crouchlook25 crouchlook26 crouchlook27 crouchlook28

$frame headbang1 headbang2 headbang3 headbang4 headbang5 headbang6 headbang7 headbang8 headbang9 headbang10
$frame headbang11 headbang12 headbang13

$frame bitea1 bitea2 bitea3 bitea4 bitea5 bitea6 bitea7 bitea8 bitea9 bitea10
$frame bitea11 bitea12 bitea13

$frame biteb1 biteb2 biteb3 biteb4 biteb5 biteb6 biteb7 biteb8 biteb9 biteb10
$frame biteb11 biteb12 biteb13 biteb14 biteb15 biteb16 biteb17 biteb18

$frame stomp1 stomp2 stomp3 stomp4 stomp5 stomp6 stomp7 stomp8 stomp9 stomp10
$frame stomp11 stomp12 stomp13 stomp14 stomp15 stomp16 stomp17 stomp18 stomp19 stomp20
$frame stomp21 stomp22 stomp23 stomp24 stomp25 stomp26 stomp27 stomp28 stomp29 stomp30
$frame stomp31 stomp32 stomp33 stomp34 stomp35 stomp36 stomp37 stomp38

$frame legattack1 legattack2 legattack3 legattack4 legattack5 legattack6 legattack7 legattack8 legattack9 legattack10
$frame legattack11 legattack12 legattack13 legattack14 legattack15 legattack16 legattack17 legattack18 legattack19 legattack20
$frame legattack21 legattack22 legattack23

$frame pain1 pain2 pain3 pain4 pain5 pain6 pain7 pain8 pain9 pain10
$frame pain11 pain12 pain13 pain14 pain15 pain16

$frame look1 look2 look3 look4 look5 look6 look7 look8 look9 look10
$frame look11 look12 look13 look14 look15 look16 look17 look18 look19 look20
$frame look21 look22 look23 look24 look25 look26 look27 look28 look29 look30
$frame look31 look32 look33 look34 look35 look36 look37 look38 look39 look40

$frame idle1 idle2 idle3 idle4 idle5 idle6 idle7 idle8 idle9 idle10
$frame idle11 idle12 idle13 idle14 idle15 idle16 idle17 idle18 idle19 idle20
$frame idle21 idle22 idle23 idle24 idle25 idle26 idle27 idle28 idle29 idle30
$frame idle31 idle32 idle33 idle34 idle35 idle36 idle37 idle38 idle39 idle40
$frame idle41 idle42 idle43 idle44 idle45 idle46 idle47 idle48

$frame death1 death2 death3 death4 death5 death6 death7 death8 death9 death10
$frame death11 death12 death13 death14 death15 death16 death17 death18 death19


void(float loudness) spider_footsteps =
{
if (autocvar_monsterfootsteps == 1)	// only play monster footsteps sound when cvar is 1
	{
	local float select;
	select = random();
	if (select <= 0.5)
		sound(self, CHAN_AUTO, "spider/spider_walk1.wav", loudness, ATTN_IDLE);
	else 
		sound(self, CHAN_AUTO, "spider/spider_walk2.wav", loudness, ATTN_IDLE);
	}
};


void(float hitpoints) spider_damage =
{
local vector delta;
local float ldmg, directio;
	if (!self.enemy)
		return;

	ai_charge(2);

	if (!CanDamage (self.enemy, self))
		return;

	delta = self.enemy.origin - self.origin;
	if (vlen(delta) > 85)
		return;
	
	if (self.spider_is_shambler)
		ldmg = (random() + random() + random()) * hitpoints * 2;
	else	
		ldmg = (random() + random() + random()) * hitpoints;
	T_Damage (self.enemy, self, self, ldmg);
	
	makevectors (self.angles);
	directio = crandom () * 200;
	particle (self.origin + v_forward*66 + v_up*15, directio * v_right, 73, ldmg*1.5);	// spawn a little blood
};	



/*
==============
CheckSpiderMelee
Returns TRUE if a melee attack would hit right now   (Reduced standard Range_Melee to "77" due to monster size !)
==============
*/
float()	CheckSpiderMelee =
{
local vector	delta;
	delta = self.enemy.origin - self.origin;
	if (self.spider_is_shambler)
		{
		if (vlen(delta) < 100)		// for shambler sized spider
			return TRUE;
		}
	else
		{
		if (vlen(delta) < 77)
			return TRUE;
		}
	return FALSE;
};


/*
==============
CheckSpiderJump
Returns TRUE if a long jump attack would hit right now
==============
*/
float()	CheckSpiderJump =
{
	local	vector	dist, spot1, spot2;
	local	float	d;
	local 	entity	targ;

	targ = self.enemy;
	
// see if any entities are in the way of the jump
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;

	traceline (spot1, spot2, FALSE, self);

	if (trace_ent != targ)
		return FALSE;		// don't have a clear sight

	if (!autocvar_spider_improved_jump_behaviour)
	{
		if (self.origin_z + self.mins_z > self.enemy.origin_z + self.enemy.mins_z + 0.75 * self.enemy.size_z)
			return FALSE;
		
		if (self.origin_z + self.maxs_z < self.enemy.origin_z + self.enemy.mins_z + 0.25 * self.enemy.size_z)
			return FALSE;
	}
	else
	{
		if (self.origin_z + self.mins_z > self.enemy.origin_z + self.enemy.mins_z + 0.75 * self.enemy.size_z)
			self.enemy_is_higher = 0;	// enemy is lower
		else if (self.origin_z + self.maxs_z < self.enemy.origin_z + self.enemy.mins_z + 0.25 * self.enemy.size_z)
			self.enemy_is_higher = 2;	// enemy is higher
		else
			self.enemy_is_higher = 1;	// enemy has approx same z-pos
	}
		
	dist = self.enemy.origin - self.origin;
	dist_z = 0;
	
	d = vlen(dist);
	
	if (d < 130)
		return FALSE;
	else if (d > 222)
	{
		if (random() < 0.05)		// often FALSE
			return TRUE;
	}
	else 
		{
		if (random() < 0.052)		// spider does not jump too often !
			return TRUE;
		}
};	


/*
==============
CheckSpiderRanged
Returns TRUE if a ranged attack would hit right now
==============
*/
float()	CheckSpiderRanged =
{
	local vector	spot1, spot2;	
	local entity	targ;

	targ = self.enemy;
	
// see if any entities are in the way of the shot
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;

	traceline (spot1, spot2, FALSE, self);

	if (trace_ent != targ)
		return FALSE;		// don't have a clear shot

	if (time < self.attack_finished)
		return FALSE;
		
	if (enemy_range == RANGE_FAR)
		return FALSE;
		
	if (enemy_range == RANGE_MELEE)
		return FALSE;

	if (random() < 0.05)		// spider does not shoot too often !
		{
		SUB_AttackFinished (2 + random());
		return TRUE;
		}
	return FALSE;
};


/*
=================
SpiderCheckAttack
Returns TRUE if any attack would hit right now
=================
*/
float()	SpiderCheckAttack =
{
// if close enough for melee, go for it
	if (CheckSpiderMelee ())
	{
		self.attack_state = AS_MELEE;
		return TRUE;
	}

// if jump would fit
	if (CheckSpiderJump ())
	{
		self.attack_state = AS_MISSILE;
		return TRUE;
	}

// if web-shot would fit
	if (CheckSpiderRanged ())
	{
		self.attack_state = AS_MISSILE;
		self.webshot = 1;
		return TRUE;
	}

	return FALSE;
};


void()	spider_idle1;
void()	spider_look1;

void()	spider_jump1	=[	$jumpz1,	spider_jump2	] {ai_stand();self.nextthink = time + 0.08;};
void()	spider_jump2	=[	$jumpz2,	spider_jump3	] {ai_stand();self.nextthink = time + 0.08;};
void()	spider_jump3	=[	$jumpz3,	spider_jump4	] {ai_stand();self.nextthink = time + 0.08;};
void()	spider_jump4	=[	$jumpz4,	spider_jump5	] {ai_stand();self.nextthink = time + 0.08;};
void()	spider_jump5	=[	$jumpz5,	spider_jump6	] {ai_stand();self.nextthink = time + 0.08;};
void()	spider_jump6	=[	$jumpz6,	spider_jump7	] {ai_stand();self.nextthink = time + 0.08;};
void()	spider_jump7	=[	$jumpz7,	spider_jump8	] {ai_stand();self.nextthink = time + 0.08;};
void()	spider_jump8	=[	$jumpz8,	spider_jump9	] {ai_stand();self.nextthink = time + 0.05;};
void()	spider_jump9	=[	$jumpz9,	spider_jump10	] {ai_stand();self.nextthink = time + 0.05;};
void()	spider_jump10	=[	$jumpz10,	spider_jump11	] {ai_stand();self.nextthink = time + 0.05;};
void()	spider_jump11	=[	$jumpz11,	spider_jump12	] {ai_stand();self.nextthink = time + 0.05;};
void()	spider_jump12	=[	$jumpz12,	spider_jump13	] {ai_stand();self.nextthink = time + 0.05;};
void()	spider_jump13	=[	$jumpz13,	spider_jump14	] {ai_stand();self.nextthink = time + 0.05;};
void()	spider_jump14	=[	$jumpz14,	spider_jump15	] {ai_stand();self.nextthink = time + 0.05;};
void()	spider_jump15	=[	$jumpz15,	spider_jump16	] {ai_stand();self.nextthink = time + 0.05; spider_footsteps (1);};
void()	spider_jump16	=[	$jumpz16,	spider_jump17	] {ai_stand();self.nextthink = time + 0.05; spider_footsteps (1);};
void()	spider_jump17	=[	$jumpz17,	spider_jump18	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_jump18	=[	$jumpz18,	spider_jump1	] {ai_stand();self.nextthink = time + 0.07;
local float zufall;
zufall = random();
	if (zufall > 0.75)
		spider_idle1 ();	// 25% chance to go into standard idle animation
	else if (zufall < 0.55)
		spider_look1 ();	// 55% chance to go into look animation
};


void()	spider_idle1	=[	$idle1,	spider_idle2	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_idle2	=[	$idle2,	spider_idle3	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_idle3	=[	$idle3,	spider_idle4	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_idle4	=[	$idle4,	spider_idle5	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_idle5	=[	$idle5,	spider_idle6	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_idle6	=[	$idle6,	spider_idle7	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_idle7	=[	$idle7,	spider_idle8	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_idle8	=[	$idle8,	spider_idle9	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_idle9	=[	$idle9,	spider_idle10	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_idle10	=[	$idle10,	spider_idle11	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_idle11	=[	$idle11,	spider_idle12	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_idle12	=[	$idle12,	spider_idle13	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_idle13	=[	$idle13,	spider_idle14	] {ai_stand();self.nextthink = time + 0.07;
if (random() < 0.35)
	sound (self, CHAN_VOICE, "spider/spider_idle.wav", 1, ATTN_IDLE);
};
void()	spider_idle14	=[	$idle14,	spider_idle15	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_idle15	=[	$idle15,	spider_idle16	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_idle16	=[	$idle16,	spider_idle17	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_idle17	=[	$idle17,	spider_idle18	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_idle18	=[	$idle18,	spider_idle19	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_idle19	=[	$idle19,	spider_idle20	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_idle20	=[	$idle20,	spider_idle21	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_idle21	=[	$idle21,	spider_idle22	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_idle22	=[	$idle22,	spider_idle23	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_idle23	=[	$idle23,	spider_idle24	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_idle24	=[	$idle24,	spider_idle25	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_idle25	=[	$idle25,	spider_idle26	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_idle26	=[	$idle26,	spider_idle27	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_idle27	=[	$idle27,	spider_idle28	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_idle28	=[	$idle28,	spider_idle29	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_idle29	=[	$idle29,	spider_idle30	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_idle30	=[	$idle30,	spider_idle31	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_idle31	=[	$idle31,	spider_idle32	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_idle32	=[	$idle32,	spider_idle33	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_idle33	=[	$idle33,	spider_idle34	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_idle34	=[	$idle34,	spider_idle35	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_idle35	=[	$idle35,	spider_idle36	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_idle36	=[	$idle36,	spider_idle37	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_idle37	=[	$idle37,	spider_idle38	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_idle38	=[	$idle38,	spider_idle39	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_idle39	=[	$idle39,	spider_idle40	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_idle40	=[	$idle40,	spider_idle41	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_idle41	=[	$idle41,	spider_idle42	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_idle42	=[	$idle42,	spider_idle43	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_idle43	=[	$idle43,	spider_idle44	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_idle44	=[	$idle44,	spider_idle45	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_idle45	=[	$idle45,	spider_idle46	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_idle46	=[	$idle46,	spider_idle47	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_idle47	=[	$idle47,	spider_idle48	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_idle48	=[	$idle48,	spider_idle1	] {ai_stand();self.nextthink = time + 0.07;
local float zufall;
zufall = random();
	if (zufall > 0.5)
		spider_look1 ();	// 50% chance to go into look animation
	else if (zufall < 0.22)
		spider_jump1 ();	// 22% chance to do a little jump
};


void()	spider_look1	=[	$look1,	spider_look2	] {ai_stand();self.nextthink = time + 0.07;
        self.th_stand = spider_look1;
};
void()	spider_look2	=[	$look2,	spider_look3	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_look3	=[	$look3,	spider_look4	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_look4	=[	$look4,	spider_look5	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_look5	=[	$look5,	spider_look6	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_look6	=[	$look6,	spider_look7	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_look7	=[	$look7,	spider_look8	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_look8	=[	$look8,	spider_look9	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_look9	=[	$look9,	spider_look10	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_look10	=[	$look10	spider_look11	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_look11	=[	$look11,	spider_look12	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_look12	=[	$look12,	spider_look13	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_look13	=[	$look13,	spider_look14	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_look14	=[	$look14,	spider_look15	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_look15	=[	$look15,	spider_look16	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_look16	=[	$look16,	spider_look17	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_look17	=[	$look17,	spider_look18	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_look18	=[	$look18,	spider_look19	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_look19	=[	$look19,	spider_look20	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_look20	=[	$look20,	spider_look21	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_look21	=[	$look21,	spider_look22	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_look22	=[	$look22,	spider_look23	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_look23	=[	$look23,	spider_look24	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_look24	=[	$look24,	spider_look25	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_look25	=[	$look25,	spider_look26	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_look26	=[	$look26,	spider_look27	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_look27	=[	$look27,	spider_look28	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_look28	=[	$look28,	spider_look29	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_look29	=[	$look29,	spider_look30	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_look30	=[	$look30,	spider_look31	] {ai_stand();self.nextthink = time + 0.07;
if (random() < 0.35)
	sound (self, CHAN_VOICE, "spider/spider_idle.wav", 1, ATTN_IDLE);
};
void()	spider_look31	=[	$look31,	spider_look32	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_look32	=[	$look32,	spider_look33	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_look33	=[	$look33,	spider_look34	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_look34	=[	$look34,	spider_look35	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_look35	=[	$look35,	spider_look36	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_look36	=[	$look36,	spider_look37	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_look37	=[	$look37,	spider_look38	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_look38	=[	$look38,	spider_look39	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_look39	=[	$look39,	spider_look40	] {ai_stand();self.nextthink = time + 0.07;};
void()	spider_look40	=[	$look40,	spider_look1	] {ai_stand();self.nextthink = time + 0.07;
local float zufall;
zufall = random();
	if (zufall > 0.72)
		spider_idle1 ();	// 28% chance to go into standard idle animation
	else if (zufall < 0.22)
		spider_jump1 ();	// 22% chance to do a little jump
};


void()	spider_run1;

void()	spider_underground1	=[	$underground1,	spider_underground2	] {ai_stand();self.nextthink = time + 0.05;
	self.alpha = 1; };
void()	spider_underground2	=[	$underground2,	spider_underground3	] {ai_stand();self.nextthink = time + 0.05;};
void()	spider_underground3	=[	$underground3,	spider_underground4	] {ai_stand();self.nextthink = time + 0.05;};
void()	spider_underground4	=[	$underground4,	spider_underground5	] {ai_stand();self.nextthink = time + 0.05;};
void()	spider_underground5	=[	$underground5,	spider_underground6	] {ai_stand();self.nextthink = time + 0.05;
	pointparticles(particleeffectnum("spider_outbreak"), self.origin, '0 0 0', 1); };
void()	spider_underground6	=[	$underground6,	spider_underground7	] {ai_stand();self.nextthink = time + 0.05;
	pointparticles(particleeffectnum("spider_outbreak"), self.origin, '0 0 0', 1); };
void()	spider_underground7	=[	$underground7,	spider_underground8	] {ai_stand();self.nextthink = time + 0.05;
	pointparticles(particleeffectnum("spider_outbreak"), self.origin, '0 0 0', 1); };
void()	spider_underground8	=[	$underground8,	spider_underground9	] {ai_stand();self.nextthink = time + 0.05;
	pointparticles(particleeffectnum("spider_outbreak"), self.origin, '0 0 0', 1); };
void()	spider_underground9	=[	$underground9,	spider_underground10	] {ai_stand();self.nextthink = time + 0.05;
	pointparticles(particleeffectnum("spider_outbreak"), self.origin, '0 0 0', 1); };
void()	spider_underground10	=[	$underground10,	spider_underground11	] {ai_stand();self.nextthink = time + 0.05;
	pointparticles(particleeffectnum("spider_outbreak"), self.origin, '0 0 0', 1); };
void()	spider_underground11	=[	$underground11,	spider_underground12	] {ai_stand();self.nextthink = time + 0.05;
	pointparticles(particleeffectnum("spider_outbreak"), self.origin, '0 0 0', 1); };
void()	spider_underground12	=[	$underground12,	spider_underground13	] {ai_stand();self.nextthink = time + 0.05;
	pointparticles(particleeffectnum("spider_outbreak"), self.origin, '0 0 0', 1); };
void()	spider_underground13	=[	$underground13,	spider_underground14	] {ai_stand();self.nextthink = time + 0.05;
	pointparticles(particleeffectnum("spider_outbreak"), self.origin, '0 0 0', 1); };
void()	spider_underground14	=[	$underground14,	spider_underground15	] {ai_stand();self.nextthink = time + 0.05;
	pointparticles(particleeffectnum("spider_outbreak"), self.origin, '0 0 0', 1); };
void()	spider_underground15	=[	$underground15,	spider_underground16	] {ai_stand();self.nextthink = time + 0.05;
	pointparticles(particleeffectnum("spider_outbreak"), self.origin, '0 0 0', 1); };
void()	spider_underground16	=[	$underground16,	spider_underground17	] {ai_stand();self.nextthink = time + 0.05;
	pointparticles(particleeffectnum("spider_outbreak"), self.origin, '0 0 0', 1); };
void()	spider_underground17	=[	$underground17,	spider_underground18	] {ai_stand();self.nextthink = time + 0.05;
	pointparticles(particleeffectnum("spider_outbreak"), self.origin, '0 0 0', 1); };
void()	spider_underground18	=[	$underground18,	spider_underground19	] {ai_stand();self.nextthink = time + 0.05;
	pointparticles(particleeffectnum("spider_outbreak"), self.origin, '0 0 0', 1); };
void()	spider_underground19	=[	$underground19,	spider_underground20	] {ai_stand();self.nextthink = time + 0.05;
	pointparticles(particleeffectnum("spider_outbreak"), self.origin, '0 0 0', 1); };
void()	spider_underground20	=[	$underground20,	spider_underground21	] {ai_stand();self.nextthink = time + 0.05;
	pointparticles(particleeffectnum("spider_outbreak"), self.origin, '0 0 0', 1); };
void()	spider_underground21	=[	$underground21,	spider_underground22	] {ai_stand();self.nextthink = time + 0.05;
	pointparticles(particleeffectnum("spider_outbreak"), self.origin, '0 0 0', 1); };
void()	spider_underground22	=[	$underground22,	spider_underground23	] {ai_stand();self.nextthink = time + 0.05;
	pointparticles(particleeffectnum("spider_outbreak"), self.origin, '0 0 0', 1); };
void()	spider_underground23	=[	$underground23,	spider_underground24	] {ai_stand();self.nextthink = time + 0.05;
	pointparticles(particleeffectnum("spider_outbreak"), self.origin, '0 0 0', 1); };
void()	spider_underground24	=[	$underground24,	spider_underground25	] {ai_stand();self.nextthink = time + 0.05;
	pointparticles(particleeffectnum("spider_outbreak"), self.origin, '0 0 0', 1); };
void()	spider_underground25	=[	$underground25,	spider_underground26	] {ai_stand();self.nextthink = time + 0.05;
	pointparticles(particleeffectnum("spider_outbreak"), self.origin, '0 0 0', 1); };
void()	spider_underground26	=[	$underground26,	spider_underground27	] {ai_stand();self.nextthink = time + 0.05;
	pointparticles(particleeffectnum("spider_outbreak"), self.origin, '0 0 0', 1); };
void()	spider_underground27	=[	$underground27,	spider_underground28	] {ai_stand();self.nextthink = time + 0.05;
	pointparticles(particleeffectnum("spider_outbreak"), self.origin, '0 0 0', 1); };
void()	spider_underground28	=[	$underground28,	spider_underground29	] {ai_stand();self.nextthink = time + 0.05;
	pointparticles(particleeffectnum("spider_outbreak"), self.origin, '0 0 0', 1); };
void()	spider_underground29	=[	$underground29,	spider_underground30	] {ai_stand();self.nextthink = time + 0.05;
	pointparticles(particleeffectnum("spider_outbreak"), self.origin, '0 0 0', 1); };
void()	spider_underground30	=[	$underground30,	spider_underground31	] {ai_stand();self.nextthink = time + 0.04;};
void()	spider_underground31	=[	$underground31,	spider_underground32	] {ai_stand();self.nextthink = time + 0.04;};
void()	spider_underground32	=[	$underground32,	spider_underground33	] {ai_stand();self.nextthink = time + 0.04;};
void()	spider_underground33	=[	$underground33,	spider_underground34	] {ai_stand();self.nextthink = time + 0.04;};
void()	spider_underground34	=[	$underground34,	spider_underground35	] {ai_stand();self.nextthink = time + 0.04;};
void()	spider_underground35	=[	$underground35,	spider_underground36	] {ai_stand();self.nextthink = time + 0.04;};
void()	spider_underground36	=[	$underground36,	spider_underground37	] {ai_stand();self.nextthink = time + 0.04;};
void()	spider_underground37	=[	$underground37,	spider_underground38	] {ai_stand();self.nextthink = time + 0.04;};
void()	spider_underground38	=[	$underground38,	spider_underground39	] {ai_stand();self.nextthink = time + 0.04;};
void()	spider_underground39	=[	$underground39,	spider_underground40	] {ai_stand();self.nextthink = time + 0.04;};
void()	spider_underground40	=[	$underground40,	spider_underground41	] {ai_stand();self.nextthink = time + 0.04;
	self.takedamage = DAMAGE_AIM;
	self.solid = SOLID_SLIDEBOX;
};
void()	spider_underground41	=[	$underground41,	spider_underground42	] {ai_stand();self.nextthink = time + 0.04;};
void()	spider_underground42	=[	$underground42,	spider_underground43	] {ai_stand();self.nextthink = time + 0.04;};
void()	spider_underground43	=[	$underground43,	spider_underground44	] {ai_stand();self.nextthink = time + 0.04;};
void()	spider_underground44	=[	$underground44,	spider_underground45	] {ai_stand();self.nextthink = time + 0.04;};
void()	spider_underground45	=[	$underground45,	spider_run1		] {ai_stand();self.nextthink = time + 0.04;
	self.th_run = spider_run1;
        self.th_stand = spider_look1;
};


void()	spider_wait_underground	=[	$underground1,		spider_wait_underground	] {ai_stand();
	self.takedamage = DAMAGE_NO;		// during emerging out of underground, spider is invulnerable
	self.solid = SOLID_NOT;			// in case player uses notarget cheat
	self.alpha = -1;			// in case spider stands ontop of a slim bridge
	self.th_run = spider_underground1;
};


void()	spider_stand_random =		// spider can emerge from underground or regular stand
{			
	local float hidechance;		
	hidechance = autocvar_spider_hide_underground * 0.01;
	if (random() < hidechance)
		spider_wait_underground ();	// underground sneeking
	else
		spider_look1 ();		// regular standing
};


void()	spider_walk1;

void()	spider_jump_walk1	=[	$jumpz1,	spider_jump_walk2	] {ai_walk(0);self.nextthink = time + 0.08;};
void()	spider_jump_walk2	=[	$jumpz2,	spider_jump_walk3	] {ai_walk(0);self.nextthink = time + 0.08;};
void()	spider_jump_walk3	=[	$jumpz3,	spider_jump_walk4	] {ai_walk(0);self.nextthink = time + 0.08;};
void()	spider_jump_walk4	=[	$jumpz4,	spider_jump_walk5	] {ai_walk(0);self.nextthink = time + 0.08;};
void()	spider_jump_walk5	=[	$jumpz5,	spider_jump_walk6	] {ai_walk(0);self.nextthink = time + 0.08;};
void()	spider_jump_walk6	=[	$jumpz6,	spider_jump_walk7	] {ai_walk(0);self.nextthink = time + 0.08;};
void()	spider_jump_walk7	=[	$jumpz7,	spider_jump_walk8	] {ai_walk(0);self.nextthink = time + 0.08;};
void()	spider_jump_walk8	=[	$jumpz8,	spider_jump_walk9	] {ai_walk(0);self.nextthink = time + 0.05;};
void()	spider_jump_walk9	=[	$jumpz9,	spider_jump_walk10 ] {ai_walk(3);self.nextthink = time + 0.05;};
void()	spider_jump_walk10 =[	$jumpz10,	spider_jump_walk11 ] {ai_walk(3);self.nextthink = time + 0.05;};
void()	spider_jump_walk11 =[	$jumpz11,	spider_jump_walk12 ] {ai_walk(2);self.nextthink = time + 0.05;};
void()	spider_jump_walk12 =[	$jumpz12,	spider_jump_walk13 ] {ai_walk(2);self.nextthink = time + 0.05;};
void()	spider_jump_walk13 =[	$jumpz13,	spider_jump_walk14 ] {ai_walk(2);self.nextthink = time + 0.05;};
void()	spider_jump_walk14 =[	$jumpz14,	spider_jump_walk15 ] {ai_walk(2);self.nextthink = time + 0.05;};
void()	spider_jump_walk15 =[	$jumpz15,	spider_jump_walk16 ] {ai_walk(2);self.nextthink = time + 0.05;spider_footsteps (1);};
void()	spider_jump_walk16 =[	$jumpz16,	spider_jump_walk17 ] {ai_walk(1);self.nextthink = time + 0.05;spider_footsteps (1);};
void()	spider_jump_walk17 =[	$jumpz17,	spider_jump_walk18 ] {ai_walk(0);self.nextthink = time + 0.07;};
void()	spider_jump_walk18 =[	$jumpz18,	spider_walk9	 ] {ai_walk(0);self.nextthink = time + 0.07;};


void()	spider_walk1	=[	$walk1,		spider_walk2	] {
if (random() < 0.3)
	sound (self, CHAN_VOICE, "spider/spider_idle.wav", 1, ATTN_IDLE);
ai_walk(2);spider_footsteps (1);
        self.th_stand = spider_look1;	// necessary due to initial random stand function !!
};
void()	spider_walk2	=[	$walk2,	spider_walk3	] {ai_walk(2);};
void()	spider_walk3	=[	$walk3,	spider_walk4	] {ai_walk(2);};
void()	spider_walk4	=[	$walk4,	spider_walk5	] {ai_walk(2);};
void()	spider_walk5	=[	$walk5,	spider_walk6	] {ai_walk(2);};
void()	spider_walk6	=[	$walk6,	spider_walk7	] {ai_walk(2);};
void()	spider_walk7	=[	$walk7,	spider_walk8	] {ai_walk(2);};
void()	spider_walk8	=[	$walk8,	spider_walk9	] {ai_walk(2);
if (random() < 0.2)
	spider_jump_walk1 ();	// 20% chance to do a little jump
};
void()	spider_walk9	=[	$walk9,	spider_walk10	] {ai_walk(2);};
void()	spider_walk10	=[	$walk10,	spider_walk11	] {ai_walk(2);};
void()	spider_walk11	=[	$walk11,	spider_walk12	] {ai_walk(2);};
void()	spider_walk12	=[	$walk12,	spider_walk13	] {ai_walk(2);};
void()	spider_walk13	=[	$walk13,	spider_walk14	] {ai_walk(2);spider_footsteps (1);};
void()	spider_walk14	=[	$walk14,	spider_walk15	] {ai_walk(2);};
void()	spider_walk15	=[	$walk15,	spider_walk16	] {ai_walk(2);};
void()	spider_walk16	=[	$walk16,	spider_walk17	] {ai_walk(2);};
void()	spider_walk17	=[	$walk17,	spider_walk18	] {ai_walk(2);};
void()	spider_walk18	=[	$walk18,	spider_walk19	] {ai_walk(2);};
void()	spider_walk19	=[	$walk19,	spider_walk20	] {ai_walk(2);};
void()	spider_walk20	=[	$walk20,	spider_walk21	] {ai_walk(2);};
void()	spider_walk21	=[	$walk21,	spider_walk22	] {ai_walk(2);};
void()	spider_walk22	=[	$walk22,	spider_walk23	] {ai_walk(2);};
void()	spider_walk23	=[	$walk23,	spider_walk24	] {ai_walk(2);};
void()	spider_walk24	=[	$walk24,	spider_walk1	] {ai_walk(2);};


void()	spider_run1	=[	$run1,	spider_run2	] {
if (random() < 0.3)
	sound (self, CHAN_VOICE, "spider/spider_idle.wav", 1, ATTN_IDLE);
ai_run(9);self.nextthink = time + 0.04;spider_footsteps (1);};
void()	spider_run2	=[	$run2,	spider_run3	] {ai_run(9);self.nextthink = time + 0.04;};
void()	spider_run3	=[	$run3,	spider_run4	] {ai_run(9);self.nextthink = time + 0.04;};
void()	spider_run4	=[	$run4,	spider_run5	] {ai_run(9);self.nextthink = time + 0.04;};
void()	spider_run5	=[	$run5,	spider_run6	] {ai_run(9);self.nextthink = time + 0.04;};
void()	spider_run6	=[	$run6,	spider_run7	] {ai_run(9);self.nextthink = time + 0.04;};
void()	spider_run7	=[	$run7,	spider_run8	] {ai_run(9);self.nextthink = time + 0.04;spider_footsteps (1);};
void()	spider_run8	=[	$run8,	spider_run9	] {ai_run(9);self.nextthink = time + 0.04;};
void()	spider_run9	=[	$run9,	spider_run10 ] {ai_run(9);self.nextthink = time + 0.04;};
void()	spider_run10 =[	$run10, 	spider_run11 ] {ai_run(9);self.nextthink = time + 0.04;};
void()	spider_run11 =[	$run11, 	spider_run12 ] {ai_run(9);self.nextthink = time + 0.04;};
void()	spider_run12 =[	$run12, 	spider_run1	] {ai_run(9);self.nextthink = time + 0.04;};


void()	spider_bitea1	=[	$bitea1,		spider_bitea2	]{
sound (self, CHAN_WEAPON, "spider/spider_bite.wav", 1, ATTN_NORM);
ai_charge(0);self.nextthink = time + 0.08;};
void()	spider_bitea2	=[	$bitea2,	spider_bitea3	] {ai_charge(0);self.nextthink = time + 0.08;};
void()	spider_bitea3	=[	$bitea3,	spider_bitea4	] {ai_charge(0);self.nextthink = time + 0.08;};
void()	spider_bitea4	=[	$bitea4,	spider_bitea5	] {ai_charge(0);self.nextthink = time + 0.08;};
void()	spider_bitea5	=[	$bitea5,	spider_bitea6	] {ai_charge(0);self.nextthink = time + 0.08;};
void()	spider_bitea6	=[	$bitea6,	spider_bitea7	] {ai_charge(0);self.nextthink = time + 0.08;};
void()	spider_bitea7	=[	$bitea7,	spider_bitea8	] {ai_charge(0);self.nextthink = time + 0.08;};
void()	spider_bitea8	=[	$bitea8,	spider_bitea9	] {ai_charge(3);self.nextthink = time + 0.08;};
void()	spider_bitea9	=[	$bitea9,	spider_bitea10	] {ai_charge(5); spider_damage(autocvar_spider_melee);self.nextthink = time + 0.08;};	// default 7
void()	spider_bitea10	=[	$bitea10,	spider_bitea11	] {ai_charge(3);self.nextthink = time + 0.08;};
void()	spider_bitea11	=[	$bitea11,	spider_bitea12	] {ai_charge(2);self.nextthink = time + 0.08;};
void()	spider_bitea12	=[	$bitea12,	spider_bitea13	] {ai_charge(1);self.nextthink = time + 0.08;};
void()	spider_bitea13	=[	$bitea13,	spider_run1		] {ai_charge(0);self.nextthink = time + 0.08;};


void()	spider_headbang1	=[	$headbang1,		spider_headbang2	]{
ai_charge(0);self.nextthink = time + 0.09;};
void()	spider_headbang2	=[	$headbang2,		spider_headbang3	] {ai_charge(0);self.nextthink = time + 0.09;};
void()	spider_headbang3	=[	$headbang3,		spider_headbang4	] {ai_charge(0);self.nextthink = time + 0.09;};
void()	spider_headbang4	=[	$headbang4,		spider_headbang5	] {ai_charge(0);self.nextthink = time + 0.09;};
void()	spider_headbang5	=[	$headbang5,		spider_headbang6	] {ai_charge(0);self.nextthink = time + 0.09;};
void()	spider_headbang6	=[	$headbang6,		spider_headbang7	] {ai_charge(0);self.nextthink = time + 0.08;
sound (self, CHAN_WEAPON, "spider/spider_headbang.wav", 1, ATTN_NORM);
};
void()	spider_headbang7	=[	$headbang7,		spider_headbang8	] {ai_charge(1);self.nextthink = time + 0.07;};
void()	spider_headbang8	=[	$headbang8,		spider_headbang9	] {ai_charge(2);self.nextthink = time + 0.07;};
void()	spider_headbang9	=[	$headbang9,		spider_headbang10	] {ai_charge(2); spider_damage(autocvar_spider_melee - 1);self.nextthink = time + 0.07;};	// default 7
void()	spider_headbang10	=[	$headbang10,	spider_headbang11	] {ai_charge(1);self.nextthink = time + 0.07;};
void()	spider_headbang11	=[	$headbang11,	spider_headbang12	] {ai_charge(0);self.nextthink = time + 0.07;};
void()	spider_headbang12	=[	$headbang12,	spider_headbang13	] {ai_charge(0);self.nextthink = time + 0.09;};
void()	spider_headbang13	=[	$headbang13,	spider_run1		] {ai_charge(0);self.nextthink = time + 0.09;};


void()	spider_legattack1	=[	$legattack1,	spider_legattack2	]{
sound (self, CHAN_WEAPON, "spider/spider_legattack.wav", 1, ATTN_NORM);
ai_charge(0);self.nextthink = time + 0.06;};
void()	spider_legattack2	=[	$legattack2,	spider_legattack3	] {ai_charge(0);self.nextthink = time + 0.06;};
void()	spider_legattack3	=[	$legattack3,	spider_legattack4	] {ai_charge(0);self.nextthink = time + 0.06;};
void()	spider_legattack4	=[	$legattack4,	spider_legattack5	] {ai_charge(0);self.nextthink = time + 0.06;};
void()	spider_legattack5	=[	$legattack5,	spider_legattack6	] {ai_charge(0);self.nextthink = time + 0.06;};
void()	spider_legattack6	=[	$legattack6,	spider_legattack7	] {ai_charge(0);self.nextthink = time + 0.06;};
void()	spider_legattack7	=[	$legattack7,	spider_legattack8	] {ai_charge(0);self.nextthink = time + 0.06;};
void()	spider_legattack8	=[	$legattack8,	spider_legattack9	] {ai_charge(0);self.nextthink = time + 0.06;};
void()	spider_legattack9	=[	$legattack9,	spider_legattack10	] {ai_charge(0);self.nextthink = time + 0.06;};
void()	spider_legattack10 =[	$legattack10,	spider_legattack11	] {ai_charge(0);self.nextthink = time + 0.06;};
void()	spider_legattack11 =[	$legattack11,	spider_legattack12	] {ai_charge(0);self.nextthink = time + 0.05;};
void()	spider_legattack12 =[	$legattack12,	spider_legattack13	] {ai_charge(0);self.nextthink = time + 0.05;};
void()	spider_legattack13 =[	$legattack13,	spider_legattack14	] {ai_charge(2);self.nextthink = time + 0.05;};
void()	spider_legattack14 =[	$legattack14,	spider_legattack15	] {ai_charge(2); spider_damage(autocvar_spider_melee - 1);self.nextthink = time + 0.05;};	// default 7
void()	spider_legattack15 =[	$legattack15,	spider_legattack16	] {ai_charge(2);self.nextthink = time + 0.05;};
void()	spider_legattack16 =[	$legattack16,	spider_legattack17	] {ai_charge(2);self.nextthink = time + 0.05;};
void()	spider_legattack17 =[	$legattack17,	spider_legattack18	] {ai_charge(1);self.nextthink = time + 0.05;};
void()	spider_legattack18 =[	$legattack18,	spider_legattack19	] {ai_charge(1);self.nextthink = time + 0.06;};
void()	spider_legattack19 =[	$legattack19,	spider_legattack20	] {ai_charge(0);self.nextthink = time + 0.06;spider_footsteps (1);};
void()	spider_legattack20 =[	$legattack20,	spider_legattack21	] {ai_charge(0);self.nextthink = time + 0.06;};
void()	spider_legattack21 =[	$legattack21,	spider_legattack22	] {ai_charge(0);self.nextthink = time + 0.06;};
void()	spider_legattack22 =[	$legattack22,	spider_legattack23	] {ai_charge(0);self.nextthink = time + 0.06;spider_footsteps (1);};
void()	spider_legattack23 =[	$legattack23,	spider_run1		] {ai_charge(0);self.nextthink = time + 0.06;};


void()	spider_melee_random =		// spider has 3 different melee attacks
{					
local float zufall;
	zufall = random();
		if (zufall > 0.6)
			spider_bitea1 ();		// 40% chance for bite attack
		else if (zufall < 0.3)
			spider_headbang1 ();	// 30% chance for headbang/thorns attack
		else
			spider_legattack1 ();	// 30% chance for legattack
};


void()	Spider_JumpTouch;

void()	spider_leap1 	=[	$legattack1,	spider_leap2	] {ai_face();self.nextthink = time + 0.06;};
void()	spider_leap2	=[	$legattack2,	spider_leap3	] {ai_face();self.nextthink = time + 0.06;};
void()	spider_leap3	=[	$legattack3,	spider_leap4	] {ai_face();self.nextthink = time + 0.06;
sound (self, CHAN_VOICE, "spider/spider_jump.wav", 1, ATTN_NORM);
};
void()	spider_leap4	=[	$legattack4,	spider_leap5	] {ai_face();self.nextthink = time + 0.06;
	self.touch = Spider_JumpTouch;
	makevectors (self.angles);
	self.origin_z = self.origin_z + 1;
	if (autocvar_spider_improved_jump_behaviour)
	{
		if (self.enemy_is_higher == 2)		// enemy is higher
			self.velocity = v_forward * 400 + '0 0 375';
		else if (self.enemy_is_higher == 1)	// enemy has approx same z-pos
			self.velocity = v_forward * 600 + '0 0 250';
		else					// enemy is lower
			self.velocity = v_forward * 400 + '0 0 150';
	}
	else
		self.velocity = v_forward * 600 + '0 0 250';
	if (self.flags & FL_ONGROUND)
		self.flags = self.flags - FL_ONGROUND;
};
void()	spider_leap5	=[	$legattack5,	spider_leap6	] {self.nextthink = time + 0.06;};
void()	spider_leap6	=[	$legattack6,	spider_leap7	] {self.nextthink = time + 0.06;};
void()	spider_leap7	=[	$legattack7,	spider_leap8	] {self.nextthink = time + 0.06;};
void()	spider_leap8	=[	$legattack8,	spider_leap9	] {self.nextthink = time + 0.06;};
void()	spider_leap9	=[	$legattack9,	spider_leap10	] {self.nextthink = time + 0.06;};
void()	spider_leap10	=[	$legattack10,	spider_leap11	] {self.nextthink = time + 0.06;};
void()	spider_leap11	=[	$legattack11,	spider_leap12	] {self.nextthink = time + 0.05;};
void()	spider_leap12	=[	$legattack12,	spider_leap13	] {self.nextthink = time + 0.05;};
void()	spider_leap13	=[	$legattack13,	spider_leap14	] {self.nextthink = time + 0.05;};
void()	spider_leap14	=[	$legattack14,	spider_leap15	] {self.nextthink = time + 0.05;};
void()	spider_leap15	=[	$legattack15,	spider_leap16	] {self.nextthink = time + 0.05;};
void()	spider_leap16	=[	$legattack16,	spider_leap17	] {self.nextthink = time + 0.05;
if (!autocvar_spider_improved_jump_behaviour)
	self.nextthink = time + 1; 	// if one second pass, assume spider is stuck and jump again
else
	self.nextthink = time + 0.5; 	// dont wait so long
};
void()	spider_leap17	=[	$legattack17,	spider_leap18	] {self.nextthink = time + 0.05;spider_footsteps (1);};
void()	spider_leap18	=[	$legattack18,	spider_leap19	] {self.nextthink = time + 0.05;};
void()	spider_leap19	=[	$legattack19,	spider_leap20	] {self.nextthink = time + 0.05;};
void()	spider_leap20	=[	$legattack20,	spider_leap21	] {self.nextthink = time + 0.05;};
void()	spider_leap21	=[	$legattack21,	spider_leap22	] {self.nextthink = time + 0.05;};
void()	spider_leap22	=[	$legattack22,	spider_leap23	] {self.nextthink = time + 0.05;spider_footsteps (1);};
void()	spider_leap23	=[	$legattack23,	spider_run1	] {self.nextthink = time + 0.05;};


void()	Spider_JumpTouch =
{
	local	float	ldmg;
	if (self.health <= 0)
		return;
	if (other.takedamage)
	{
		if ( vlen(self.velocity) > 400 )
		{
			ldmg = autocvar_spider_jump + 5*random();	// default 15
			if (other.classname == "player")
				T_Damage (other, self, self, ldmg);	
		}
	}

	if (!checkbottom(self))
	{
		if (self.flags & FL_ONGROUND)
		{	// jump randomly to not get hung up
			//dprint ("popjump\n");
			self.touch = SUB_Null;
			self.think = spider_leap1;
			self.nextthink = time + 0.1;
		}
		return;	// not on ground yet
	}

	self.touch = SUB_Null;
	self.think = spider_leap18;
	self.nextthink = time + 0.1;
};


void() spider_web_touch =
{
	if (other == self.owner)
		return;
	if (other.solid == SOLID_TRIGGER)
		return;	
	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
// hit something that bleeds
	if (other.takedamage)
	{
		if (other.classname == "player")
		{
			other.pausetime = time + autocvar_spider_web_paralyzetime;	// player cannot walk during this time
			T_Damage (other, self, self.owner, autocvar_spider_web);	// default 1
			sound (self, CHAN_WEAPON, "spider/spider_impact.wav", 1, ATTN_NORM);
			if (autocvar_spider_paralyze_effect == 2)
			  	pointparticles(particleeffectnum("spider_paralyze_player2"), other.origin, '0 0 0', 1);	// spawn paralyze particle effect around player
			else
			  	pointparticles(particleeffectnum("spider_paralyze_player1"), other.origin, '0 0 0', 1);	// spawn paralyze particle effect around player
		}
	}
	else
	{	
		pointparticles(particleeffectnum("web_touch"), self.origin, '0 0 0', 1); 
		sound (self, CHAN_WEAPON, "spider/spider_impact.wav", 1, ATTN_NORM);
	}
	remove(self);
};


void() spider_webshot =
{
	local	vector	offang, org, vec;
	local	entity	web;

	offang = vectoangles (self.enemy.origin - self.origin);
	makevectors (offang);
	if (self.spider_is_shambler)
		org = self.origin + v_up * 3 + v_forward * 12;
	else
		org = self.origin + v_up * -9 + v_forward * 7;
	
	web = spawn();
	web.classname = "web";
	setorigin (web, org);
	setmodel (web, "progs/web.mdl");
	web.scale = 0.7;
	setsize (web, VEC_ORIGIN, VEC_ORIGIN);		
	web.movetype = MOVETYPE_FLYMISSILE;
	web.solid = SOLID_BBOX;
	vec = normalize ((self.enemy.origin + '0 0 15') - org);
	web.velocity = vec*500;
	web.angles = vectoangles(vec);
	web.traileffectnum = particleeffectnum("web_trail");

	web.owner = self;
	web.enemy = self.enemy;
	web.touch = spider_web_touch;

	web.think = SUB_Remove;
	web.nextthink = time + 5;

	sound (self, CHAN_WEAPON, "spider/spider_spit.wav", 1, ATTN_NORM);
};


void()	spider_web1	=[	$frontup1,	spider_web2	] {ai_face();self.nextthink = time + 0.05;};
void()	spider_web2	=[	$frontup2,	spider_web3	] {ai_face();self.nextthink = time + 0.05;};
void()	spider_web3	=[	$frontup3,	spider_web4	] {ai_face();self.nextthink = time + 0.05;};
void()	spider_web4	=[	$frontup4,	spider_web5	] {ai_face();self.nextthink = time + 0.05;};
void()	spider_web5	=[	$frontup5,	spider_web6	] {ai_face();self.nextthink = time + 0.05;};
void()	spider_web6	=[	$frontup6,	spider_web7	] {ai_face();self.nextthink = time + 0.05;};
void()	spider_web7	=[	$frontup7,	spider_web8	] {ai_face();self.nextthink = time + 0.05;};
void()	spider_web8	=[	$frontup8,	spider_web9	] {ai_face();self.nextthink = time + 0.05;};
void()	spider_web9	=[	$frontup9,	spider_web10 ] {ai_face();self.nextthink = time + 0.05;};
void()	spider_web10 =[	$frontup10,	spider_web11 ] {ai_face();self.nextthink = time + 0.05;};
void()	spider_web11 =[	$frontup11,	spider_web12 ] {ai_face();self.nextthink = time + 0.05;};
void()	spider_web12 =[	$frontup12,	spider_web13 ] {ai_face();self.nextthink = time + 0.05;};
void()	spider_web13 =[	$frontup13,	spider_web14 ] {ai_face();self.nextthink = time + 0.05;};
void()	spider_web14 =[	$frontup14,	spider_web15 ] {ai_face();self.nextthink = time + 0.05;};
void()	spider_web15 =[	$frontup15,	spider_web16 ] {ai_face();self.nextthink = time + 0.05;};
void()	spider_web16 =[	$frontup16,	spider_web17 ] {ai_face();self.nextthink = time + 0.05;};
void()	spider_web17 =[	$frontup17,	spider_web18 ] {ai_face();self.nextthink = time + 0.05; spider_webshot();};
void()	spider_web18 =[	$frontup18,	spider_web19 ] {ai_face();self.nextthink = time + 0.05;};
void()	spider_web19 =[	$frontup19,	spider_web20 ] {ai_face();self.nextthink = time + 0.05;};
void()	spider_web20 =[	$frontup20,	spider_web21 ] {ai_face();self.nextthink = time + 0.05;};
void()	spider_web21 =[	$frontup21,	spider_web22 ] {ai_face();self.nextthink = time + 0.05;};
void()	spider_web22 =[	$frontup22,	spider_web23 ] {ai_face();self.nextthink = time + 0.05;};
void()	spider_web23 =[	$frontup23,	spider_web24 ] {ai_face();self.nextthink = time + 0.05;};
void()	spider_web24 =[	$frontup24,	spider_web25 ] {ai_face();self.nextthink = time + 0.05;};
void()	spider_web25 =[	$frontup25,	spider_web26 ] {ai_face();self.nextthink = time + 0.05;};
void()	spider_web26 =[	$frontup26,	spider_web27 ] {ai_face();self.nextthink = time + 0.05;};
void()	spider_web27 =[	$frontup27,	spider_web28 ] {ai_face();self.nextthink = time + 0.05;};
void()	spider_web28 =[	$frontup28,	spider_run1	] {ai_face();self.nextthink = time + 0.05;};


void()	spider_ranged =
{					
	if(self.webshot == 1)
		{
		spider_web1 ();
		self.webshot = 0;	// reset
		}
	else
		spider_leap1 ();
};


// PAIN ===========================================================================

void()	spider_pain1	=[	$pain1,	spider_pain2	] {ai_back(3);self.nextthink = time + 0.07;};
void()	spider_pain2	=[	$pain2,	spider_pain3	] {ai_back(3);self.nextthink = time + 0.07;};
void()	spider_pain3	=[	$pain3,	spider_pain4	] {ai_back(2);self.nextthink = time + 0.07;};
void()	spider_pain4	=[	$pain4,	spider_pain5	] {ai_back(1);self.nextthink = time + 0.07;};
void()	spider_pain5	=[	$pain5,	spider_pain6	] {ai_back(1);self.nextthink = time + 0.07;};
void()	spider_pain6	=[	$pain6,	spider_pain7	] {self.nextthink = time + 0.07;};
void()	spider_pain7	=[	$pain7,	spider_pain8	] {self.nextthink = time + 0.07;};
void()	spider_pain8	=[	$pain8,	spider_pain9	] {self.nextthink = time + 0.07;};
void()	spider_pain9	=[	$pain9,	spider_pain10	] {self.nextthink = time + 0.07;};
void()	spider_pain10	=[	$pain10,	spider_pain11	] {self.nextthink = time + 0.07;spider_footsteps (0.8);};
void()	spider_pain11	=[	$pain11,	spider_pain12	] {self.nextthink = time + 0.07;};
void()	spider_pain12	=[	$pain12,	spider_pain13	] {self.nextthink = time + 0.07;};
void()	spider_pain13	=[	$pain13,	spider_pain14	] {self.nextthink = time + 0.07;};
void()	spider_pain14	=[	$pain14,	spider_pain15	] {self.nextthink = time + 0.07;};
void()	spider_pain15	=[	$pain15,	spider_pain16	] {ai_forward(3);self.nextthink = time + 0.07;};
void()	spider_pain16	=[	$pain16,	spider_run1	] {ai_forward(3);self.nextthink = time + 0.07;};


void(entity attacker, float damage) spider_pain =
{
	if (self.pain_finished > time)
		return;
		
	if (autocvar_slowmotion >= 4)	// start slowmotion when hurting enemies
	{
		if (random () <= (autocvar_slowmotion_randomness_spider * 0.01))
			{
			the_matrix = 1;
			matrixcounter = time + (autocvar_slowmotion_intensity * autocvar_slowmotion_duration);	// Attention: formula needed to take the intensity into account. Time increase is much more when slowmo is active ! (time + 1 will be approx. 3seconds with slowmo 0.33 !)
			}
	}

	sound (self, CHAN_VOICE, "spider/spider_pain.wav", 1, ATTN_NORM);
	spider_pain1 ();
	self.pain_finished = time + 2;
};



// DEATH ===========================================================================

void() spider_dieburn1	=[	$death1,	spider_dieburn2	] {self.burnz_origin = 10;
burn_toggle_allround();
};
void() spider_dieburn2	=[	$death2,	spider_dieburn3	] {self.burnz_origin = 8;
};
void() spider_dieburn3	=[	$death3,	spider_dieburn4	] {self.burnz_origin = 5;
self.solid = SOLID_NOT;
};
void() spider_dieburn4	=[	$death4,	spider_dieburn5	] {self.burnz_origin = 3;
};
void() spider_dieburn5	=[	$death5,	spider_dieburn6	] {self.burnz_origin = 0;
};
void() spider_dieburn6	=[	$death6,	spider_dieburn7	] {self.burnz_origin = -2;
};
void() spider_dieburn7	=[	$death7,	spider_dieburn8	] {self.burnz_origin = -5;
};
void() spider_dieburn8	=[	$death8,	spider_dieburn9	] {self.burnz_origin = -7;
};
void() spider_dieburn9	=[	$death9,	spider_dieburn9	] {self.burnz_origin = -9;
};


var float autocvar_spider = 3;     		// set cvar 'spider' default to 3
var float autocvar_spidercorpsehealth = 60;	// set cvar 'spidercorpsehealth' default to 60
var float autocvar_spidercorpseburnable = 0;	// set cvar 'spidercorpseburnable' default to 0

void()	spider_die1	=[	$death1,	spider_die2	] {};
void()	spider_die2	=[	$death2,	spider_die3	] {
	sound (self, CHAN_VOICE, "spider/spider_death.wav", 1, ATTN_NORM);
};
void()	spider_die3	=[	$death3,	spider_die4	] {self.solid = SOLID_NOT;};
void()	spider_die4	=[	$death4,	spider_die5	] {};
void()	spider_die5	=[	$death5,	spider_die6	] {};
void()	spider_die6	=[	$death6,	spider_die7	] {};
void()	spider_die7	=[	$death7,	spider_die8	] {};
void()	spider_die8	=[	$death8,	spider_die9	] {};
void()	spider_die9	=[	$death9,	spider_die10 ] {};
void()	spider_die10 =[	$death10,	spider_die11 ] {};
void()	spider_die11 =[	$death11,	spider_die12 ] {};
void()	spider_die12 =[	$death12,	spider_die13 ] {};
void()	spider_die13 =[	$death13,	spider_die14 ] {};
void()	spider_die14 =[	$death14,	spider_die15 ] {};
void()	spider_die15 =[	$death15,	spider_die16 ] {};
void()	spider_die16 =[	$death16,	spider_die17 ] {};
void()	spider_die17 =[	$death17,	spider_die18 ] {};
void()	spider_die18 =[	$death18,	spider_die19 ] {};
void()	spider_die19 =[	$death19,	spider_die19 ] {
local float zufall, zet, randomness;
	zet = 19;					// z-position of the wings (in relation to soul). Dependent on corpse size.    
	if (autocvar_spidercorpseburnable == 1)		// corpses are burnable
		self.burnable_corpse = 1;
// 	auto_cvar 'spidercorpsehealth' has been set to  default = 60  in code above already
	if (self.spider_is_shambler)
		CopyMonsterToBodyQue(autocvar_spidercorpsehealth, "progs/h_spider_shambler.mdl");
	else
		CopyMonsterToBodyQue(autocvar_spidercorpsehealth, "progs/h_spider.mdl");
if (self.nodeathanim == 1)
	return;
if (self.grimrock_helper == 0)
{
// 	auto_cvar 'spider' has been declared in code above already
	var float autocvar_spiderrandomness = 35;     	// set cvar 'spiderrandomness' default to 35%
	autocvar_spiderrandomness = autocvar_spiderrandomness * 0.01;
	if (autocvar_spider == 1)		// if 'spider' is set via autoexec.cfg to '1' start ghost effect
		{
		randomness = random();
		if (randomness <= autocvar_spiderrandomness)	// checks if death animation shall be started
			ghost_die ();
		}
	else if (autocvar_spider == 2)	// if 'spider' is set via autoexec.cfg to '2' start soul effect
		{
		randomness = random();
		if (randomness <= autocvar_spiderrandomness)	// checks if death animation shall be started
			{
			if (self.spider_is_shambler)
				soul ("progs/spider_shambler.mdl", $death19, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
			else
				soul ("progs/spider.mdl", $death19, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
			}
		}
	else if (autocvar_spider == 3)	// if 'spider' is set via autoexec.cfg to '3' start vengeance effect
		{
		randomness = random();
		if (randomness <= autocvar_spiderrandomness)	// checks if death animation shall be started
			vengeance_spider ("progs/spider.mdl", $death19); 
		}
	else if (autocvar_spider == 5)		// if 'spider' is set via autoexec.cfg to '5' start randomly one of these Death animations: 
		{				// (Ancient ghosts of the fallen ; Relieved souls of the enslaved ; Vengeance of the deceased)	
		randomness = random();		// chance for effects (approx.): 36% / 26% / 38%
		if (randomness <= autocvar_spiderrandomness)	// checks if death animation shall be started --> depending on monsters _randomness
			{					
			zufall = random();
			if (zufall > 0.64)
				ghost_die ();
			else if (zufall < 0.26)
				{
				if (self.spider_is_shambler)
					soul ("progs/spider_shambler.mdl", $death19, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
				else
					soul ("progs/spider.mdl", $death19, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
				}
			else
				vengeance_spider ("progs/spider.mdl", $death19);
			}
		}
	else				// if 'spider' is set via autoexec.cfg to another value (example '0'), do nothing !
	{
	}
}
else if (self.grimrock_helper == 1)	// this new code is the the ending of cvar value "6" (which was started in monsters _die function)
	{
	zufall = random();
	if (zufall > 0.64)
		ghost_die ();
	else if (zufall < 0.26)
		{
		if (self.spider_is_shambler)
			soul ("progs/spider_shambler.mdl", $death19, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
		else
			soul ("progs/spider.mdl", $death19, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
		}
	else
		vengeance_spider ("progs/spider.mdl", $death19);
	}
};


void(float maxgibs, float gibscounter) producegibs_spider =		// creates as many gib-sets as defined in cvar 'gibsmultiplier'
{
if (gibscounter >= maxgibs)
	return;
else
	{
	if (self.spider_is_shambler)
		{
		ThrowGibSpider ("progs/gib_spider1_shambler.mdl", self.health, self.skin);
		ThrowGibSpider ("progs/gib_spider2_shambler.mdl", self.health, self.skin);
		ThrowGibSpider ("progs/gib_spider3_shambler.mdl", self.health, self.skin);   	
		}
	else
		{
		ThrowGibSpider ("progs/gib_spider1.mdl", self.health, self.skin);
		ThrowGibSpider ("progs/gib_spider2.mdl", self.health, self.skin);
		ThrowGibSpider ("progs/gib_spider3.mdl", self.health, self.skin);   	
		}
	}

gibscounter = gibscounter + 1;
producegibs_spider (maxgibs, gibscounter);
};


void()	spider_lightning_death	=[	$pain5,	spider_lightning_death1	] {
if (autocvar_lightninggun_death_animation == 2)	  // start the "fade" effect instead of "coal" effect
	lightninggun_death_fade();
};

void()	spider_lightning_death1	=[	$pain5,	spider_lightning_death1	] {
self.solid = SOLID_NOT;
self.baked = 1;
self.colormod = '0.30 0.25 0.25';	// skins gets darker (looks burned)
if (self.spider_is_shambler)
	CopyMonsterToBodyQue(1, "progs/h_spider_shambler.mdl");
else
	CopyMonsterToBodyQue(1, "progs/h_spider.mdl");
};


void() spider_die =
{
if (autocvar_lightninggun_death_animation)		// if 'lightninggun_death_animation' is enabled
	{
	if (self.enemy.weapon == IT_LIGHTNING)		// when enemy was killed with lightning gun, go into baked mode
		{
		spider_lightning_death();
		return;
		}
	}
local float maxgibs, gibscounter;
// check for gib
	if (self.health < -40)
	{
		if (autocvar_slowmotion >= 1)	// start slowmotion when gibbing living enemies
			{
			if (random () <= (autocvar_slowmotion_randomness_spider * 0.01))
				{
				the_matrix = 1;
				matrixcounter = time + (autocvar_slowmotion_intensity * autocvar_slowmotion_duration);	// Attention: formula needed to take the intensity into account. Time increase is much more when slowmo is active ! (time + 1 will be approx. 3seconds with slowmo 0.33 !)
				}
			}
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		var float autocvar_gibsmultiplier = 1;         	// set cvar 'gibsmultiplier' default to 1
			if (autocvar_gibsmultiplier == 1)	// if 'gibsmultiplier' doesnt exist in autoexec.cfg, or if 'gibsmultiplier' is set via autoexec.cfg to '1'
				{
				if (self.spider_is_shambler)
					{
					ThrowHead ("progs/h_spider_shambler.mdl", self.health);
					ThrowGibSpider ("progs/gib_spider1_shambler.mdl", self.health, self.skin);
					ThrowGibSpider ("progs/gib_spider2_shambler.mdl", self.health, self.skin);
					ThrowGibSpider ("progs/gib_spider3_shambler.mdl", self.health, self.skin);   	
					}
				else
					{
					ThrowHead ("progs/h_spider.mdl", self.health);
					ThrowGibSpider ("progs/gib_spider1.mdl", self.health, self.skin);
					ThrowGibSpider ("progs/gib_spider2.mdl", self.health, self.skin);
					ThrowGibSpider ("progs/gib_spider3.mdl", self.health, self.skin);   	
					}
				if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
					pointparticles(particleeffectnum("blood_monster_gib"), self.origin, '0 0 0', 1);
				return;
				}
			else 							// if 'gibsmultiplier' is set via autoexec.cfg to any other value than '1'
				{						// --> produce more gibs
				if (self.spider_is_shambler)
					ThrowHead ("progs/h_spider_shambler.mdl", self.health);
				else
					ThrowHead ("progs/h_spider.mdl", self.health);
				maxgibs = autocvar_gibsmultiplier;
				gibscounter = 0;
				if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
					pointparticles(particleeffectnum("blood_monster_gib"), self.origin, '0 0 0', 1);
				producegibs_spider (maxgibs, gibscounter);
				return;
				}
	}

// regular death

local float zufall, randomness;
// auto_cvar 'spider' has been declared in code above already
var float autocvar_spiderrandomness = 35;     	// set cvar 'spiderrandomness' default to 35%
autocvar_spiderrandomness = autocvar_spiderrandomness * 0.01;
if (autocvar_spider == 4)		// if 'spider' is set via autoexec.cfg to '4' start Death animation with "Legend of Grimrock" effect
	{
	randomness = random();
	if (randomness <= autocvar_spiderrandomness)	// checks if death animation shall be started
		{
		//Gyro_Object_ClearPhysics(self);	// ENABLE this line if you want to disable GYRO during new "Legend of Grimrock" animation !!
		spider_dieburn1();
		return;			// jump out of this function !!
		}
	}
if (autocvar_spider == 6)		// if 'spider' is set via autoexec.cfg to '6' start random Death animation (all 4 effects !!)
	{				// chance for effects (approx.): 25% / 25% / 25% / 25%  
	randomness = random();
	if (randomness <= autocvar_spiderrandomness)	// checks if death animation shall be started --> depending on monsters _randomness
		{					
		zufall = random();
		if (zufall <= 0.26)
			{
			//Gyro_Object_ClearPhysics(self);   // ENABLE this line if you want to disable GYRO during new "Legend of Grimrock" animation !!
			spider_dieburn1();
			return;		// jump out of this function !!
			}		// if zufall is bigger than 0.26, use new code inside  upcoming function  for other 3 death animations
		else 
			self.grimrock_helper = 1;	// this float helps me to manipulate the other 3 death animations
		}
	else
		self.grimrock_helper = 2;	// this float helps me to manipulate the other 3 death animations
	}
	
// if 'spider' has another value is checked inside prior function (= death animation function)

	if (autocvar_slowmotion >= 3)	// start slowmotion when regular killing living enemies
		{
		if (random () <= (autocvar_slowmotion_randomness_spider * 0.01))
			{
			the_matrix = 1;
			matrixcounter = time + (autocvar_slowmotion_intensity * autocvar_slowmotion_duration);	// Attention: formula needed to take the intensity into account. Time increase is much more when slowmo is active ! (time + 1 will be approx. 3seconds with slowmo 0.33 !)
			}
		}
	spider_die1 ();
};





/*QUAKED monster_spider (1 0 0) (-16 -16 -24) (16 16 16) Ambush
*/

void() monster_spider =
{
self.classname = "monster_spider";
	if (deathmatch)
	{
		remove(self);
		return;
	}
/*	precache_model ("progs/spider.mdl");	// all files precached in worldspawn() due to savegame-bug
	precache_model ("progs/h_spider.mdl");
	precache_model ("progs/gib_spider1.mdl");
	precache_model ("progs/gib_spider2.mdl");
	precache_model ("progs/gib_spider3.mdl");
	precache_model ("progs/web.mdl");

	precache_sound ("spider/spider_walk1.wav");
	precache_sound ("spider/spider_walk2.wav");
	precache_sound ("spider/spider_sight.wav");
	precache_sound ("spider/spider_idle.wav");
	precache_sound ("spider/spider_bite.wav");
	precache_sound ("spider/spider_headbang.wav");
	precache_sound ("spider/spider_legattack.wav");
	precache_sound ("spider/spider_jump.wav");
	precache_sound ("spider/spider_spit.wav");
	precache_sound ("spider/spider_impact.wav");
	precache_sound ("spider/spider_pain.wav");
	precache_sound ("spider/spider_death.wav");
*/
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	
	setmodel (self, "progs/spider.mdl");
	if (!self.skin)
		self.skin = 0;
	self.monstermodel = 0;

	setsize (self, '-16 -16 -24', '16 16 16');	// make its bbox small, so it gets hard to hit
	if (!self.health)
		self.health = autocvar_spider_health;		// default 111
	self.health_initial = self.health;

	self.colormod = '1 1 1';

	self.th_stand = spider_stand_random;
	self.th_walk = spider_walk1;
	self.th_run = spider_run1;
	self.th_melee = spider_melee_random;		// 3 possible melee attacks
	self.th_missile = spider_ranged;		// jump or web attack
	self.th_pain = spider_pain;
	self.th_die = spider_die;
	
	self.alpha = autocvar_monstertransparency * 0.01;

	walkmonster_start ();
	
do_the_cloning();

var float autocvar_spidermass = 2000;
MonsterPhysics (self, autocvar_spidermass);	
};


/*QUAKED monster_spider (1 0 0) (-36 -36 -32) (36 36 40) Ambush
*/

void() monster_spider_shambler =		// use a bigger model for shambler replacement (also bigger bbox and higher projectile spawn)
{
self.classname = "monster_spider";
	if (deathmatch)
	{
		remove(self);
		return;
	}
/*	precache_model ("progs/spider_shambler.mdl");	// all files precached in worldspawn() due to savegame-bug
	precache_model ("progs/h_spider_shambler.mdl");
	precache_model ("progs/gib_spider1_shambler.mdl");
	precache_model ("progs/gib_spider2_shambler.mdl");
	precache_model ("progs/gib_spider3_shambler.mdl");
	precache_model ("progs/web.mdl");

	precache_sound ("spider/spider_walk1.wav");
	precache_sound ("spider/spider_walk2.wav");
	precache_sound ("spider/spider_sight.wav");
	precache_sound ("spider/spider_idle.wav");
	precache_sound ("spider/spider_bite.wav");
	precache_sound ("spider/spider_headbang.wav");
	precache_sound ("spider/spider_legattack.wav");
	precache_sound ("spider/spider_jump.wav");
	precache_sound ("spider/spider_spit.wav");
	precache_sound ("spider/spider_impact.wav");
	precache_sound ("spider/spider_pain.wav");
	precache_sound ("spider/spider_death.wav");
*/
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	
	setmodel (self, "progs/spider_shambler.mdl");
	self.skin = 0;
	self.monstermodel = 0;

	setsize (self, '-36 -36 -32', '36 36 40');	// make its bbox bigger
	self.health = autocvar_shambler_health;		// default 600
	self.health_initial = self.health;
	self.spider_is_shambler = 1;			// to mark it as shambler replacement for usage in later qc code

	self.colormod = '1 1 1';

	self.th_stand = spider_stand_random;
	self.th_walk = spider_walk1;
	self.th_run = spider_run1;
	self.th_melee = spider_melee_random;		// 3 possible melee attacks
	self.th_missile = spider_ranged;		// jump or web attack
	self.th_pain = spider_pain;
	self.th_die = spider_die;
	
	self.alpha = autocvar_monstertransparency * 0.01;

	walkmonster_start ();
	
do_the_cloning();

MonsterPhysics (self, 3000);	
};


void() monster_spider_start =
{
	local entity clone;
	self.scale = 1;
	clone = spawn();
	copyentity (self,clone);
	clone.think = monster_spider;
	clone.nextthink = time + 0.0001;
};


void() monster_spider_shambler_start =
{
	local entity clone;
	self.scale = 1;
	clone = spawn();
	copyentity (self,clone);
	clone.think = monster_spider_shambler;
	clone.nextthink = time + 0.0001;
};



/*
==============================================================================

Creates "Vengeance of the deceased" effect.    

Modelname and Modelframe is taken from call after regular death animations:    
void(string modelname, float modelframe) vengeance;
Example: 
vengeance ("progs/soldier.mdl", $death10);

This function must be declared at the end of defs.qc:
void(string modelname, float modelframe) vengeance_spider; 

==============================================================================
*/


void() vengeance_spider_end1 = {					// end sequence
	self.alpha = -1;
	te_customflash (self.origin, 500, 0.7, '1 0 0');
	self.nextthink = time + 0.2;
	self.think = SUB_Remove;
};


void() vengeance_spider_touch = {       	// player receives 1-3 damage when he gets touched by vengeance effect  (if cvar is enabled)

      local float ldmg;
	ldmg = rint(0.5 + (3 * random()));  	// chances=  33%: 1 damage /  33%: 2 damage  /  33%: 3 damage

      T_Damage (self.enemy, self, self, ldmg);      	// analog to meele attack dog/fiend
//    T_Damage (other, self, self, ldmg); 		// analog to jump damage dog/fiend

	self.touch = SUB_Null;   // um nicht endlos damage zu kriegen !

	self.think = vengeance_spider_end1;  
	self.nextthink = time + 0.1;    	
};

										//  from here on: run sequence. 

void() vengeance_spider_run1 =[	$run1,	vengeance_spider_run2 ]   {
	ai_face();
 	movetogoal (8); 
self.touch = vengeance_spider_touch;  
	self.alpha = 0.4;
	self.nextthink = time + 0.04;
};
void() vengeance_spider_run2 =[	$run2,	vengeance_spider_run3 ]   {
	ai_face();
 	movetogoal (8); 
self.touch = vengeance_spider_touch;  
	self.alpha = 0.39;
	self.nextthink = time + 0.04;
};
void() vengeance_spider_run3 =[	$run3,	vengeance_spider_run4 ]    {
	ai_face();
 	movetogoal (8); 
self.touch = vengeance_spider_touch;  
	self.alpha = 0.38;
	self.nextthink = time + 0.04;
};
void() vengeance_spider_run4 =[	$run4,	vengeance_spider_run5 ]    {
	ai_face();
 	movetogoal (8); 
self.touch = vengeance_spider_touch;  
	self.alpha = 0.37;
	self.nextthink = time + 0.04;
};
void() vengeance_spider_run5 =[	$run5,	vengeance_spider_run6 ]    {
	ai_face();
 	movetogoal (8); 
self.touch = vengeance_spider_touch;  
	self.alpha = 0.36;
	self.nextthink = time + 0.04;
};
void() vengeance_spider_run6 =[	$run6,	vengeance_spider_run7 ]   {
	ai_face();
 	movetogoal (8); 
self.touch = vengeance_spider_touch;  
	self.alpha = 0.35;
	self.nextthink = time + 0.04;
};
void() vengeance_spider_run7 =[	$run7,	vengeance_spider_run8 ]   {
	ai_face();
 	movetogoal (8); 
self.touch = vengeance_spider_touch;  
	self.alpha = 0.34;
	self.nextthink = time + 0.04;
};
void() vengeance_spider_run8 =[	$run8,	vengeance_spider_run9 ]    {
	ai_face();
 	movetogoal (8); 
self.touch = vengeance_spider_touch;  
	self.alpha = 0.33;
	self.nextthink = time + 0.04;
};
void() vengeance_spider_run9 =[	$run9,	vengeance_spider_run10 ]    {
	ai_face();
 	movetogoal (8); 
self.touch = vengeance_spider_touch;  
	self.alpha = 0.32;
	self.nextthink = time + 0.04;
};
void() vengeance_spider_run10 =[ $run10,	vengeance_spider_run11 ]    {
	ai_face();
 	movetogoal (8); 
self.touch = vengeance_spider_touch;  
	self.alpha = 0.31;
	self.nextthink = time + 0.04;
};
void() vengeance_spider_run11 =[ $run11,	vengeance_spider_run12 ]    {
	ai_face();
 	movetogoal (8); 
self.touch = vengeance_spider_touch;  
	self.alpha = 0.3;
	self.nextthink = time + 0.04;
};
void() vengeance_spider_run12 =[ $run12,	vengeance_spider_jump1 ]    {
	ai_face();
 	movetogoal (8); 
self.touch = vengeance_spider_touch;  
	self.alpha = 0.28;
	self.nextthink = time + 0.04;
};

										//  from here on: attack/jump sequenz. 

void() vengeance_spider_jump1 =[	$legattack2,	vengeance_spider_jump2 ]    {
	ai_face();
self.touch = vengeance_spider_touch;  
	self.alpha = 0.24;
	self.nextthink = time + 0.09;
};
void() vengeance_spider_jump2 =[	$legattack4,	vengeance_spider_jump3 ]    {
sound (self, CHAN_VOICE, "spider/spider_jump.wav", 1, ATTN_NORM);	
	ai_face();
 	movetogoal (8); 
self.touch = vengeance_spider_touch;  
	self.alpha = 0.21;
	self.nextthink = time + 0.09;
};
void() vengeance_spider_jump3 =[	$legattack6,	vengeance_spider_jump4 ]    {
	ai_face();
 	movetogoal (12); 
self.touch = vengeance_spider_touch;  
	self.alpha = 0.18;
	self.nextthink = time + 0.09;
};
void() vengeance_spider_jump4 =[	$legattack8,	vengeance_spider_jump5 ]    {
	ai_face();
 	movetogoal (20); 
self.touch = vengeance_spider_touch;  
	self.alpha = 0.15;
	self.nextthink = time + 0.09;
};
void() vengeance_spider_jump5 =[	$legattack10,	vengeance_spider_jump6 ]    {
	ai_face();
 	movetogoal (30); 
self.touch = vengeance_spider_touch;  
	makevectors (self.angles);
	self.origin_z = self.origin_z + 1;
	self.velocity = v_forward * 325 + '0 0 125';
	self.alpha = 0.12;
	self.nextthink = time + 0.09;
};
void() vengeance_spider_jump6 =[	$legattack11,	vengeance_spider_end1 ]    {
self.touch = vengeance_spider_touch;  
	self.alpha = 0.08;
	self.nextthink = time + 0.09;
};


									//  from here on: ressurection sequenz. 

void() vengeance_spider1 =[	$death18,	vengeance_spider2 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.05;
};
void() vengeance_spider2 =[	$death17,	vengeance_spider3 	]  {
	self.nextthink = time + 0.05;
};
void() vengeance_spider3 =[	$death16,	vengeance_spider4 	]  {
	self.nextthink = time + 0.05;
};
void() vengeance_spider4 =[	$death15,	vengeance_spider5 	]  {
sound (self, CHAN_WEAPON, "spider/spider_sight.wav", 1, ATTN_NORM);
	self.nextthink = time + 0.05;
};
void() vengeance_spider5 =[	$death14,	vengeance_spider6 	]  {
	self.nextthink = time + 0.05;
};
void() vengeance_spider6 =[	$death13,	vengeance_spider7 	]  {
	self.nextthink = time + 0.05;
};
void() vengeance_spider7 =[	$death12,	vengeance_spider8 	]  {
	self.nextthink = time + 0.05;
};
void() vengeance_spider8 =[	$death11,	vengeance_spider9 ]  {
	self.nextthink = time + 0.05;
};
void() vengeance_spider9 =[	$death10,	vengeance_spider10 ]  {    
	self.nextthink = time + 0.05;
};
void() vengeance_spider10 =[	$death9,	vengeance_spider11	]  {
	self.nextthink = time + 0.05;
};
void() vengeance_spider11 =[	$death8,	vengeance_spider12	]  {
	self.nextthink = time + 0.05;
};
void() vengeance_spider12 =[	$death7,	vengeance_spider13 	]  {
	self.nextthink = time + 0.05;
};
void() vengeance_spider13 =[	$death6,	vengeance_spider14 	]  {
	self.nextthink = time + 0.05;
};
void() vengeance_spider14 =[	$death5,	vengeance_spider15 	]  {
	self.nextthink = time + 0.05;
};
void() vengeance_spider15 =[	$death4,	vengeance_spider16 	]  {
	self.nextthink = time + 0.05;
};
void() vengeance_spider16 =[	$death3,	vengeance_spider17 	]  {
	self.nextthink = time + 0.05;
};
void() vengeance_spider17 =[	$death2,	vengeance_spider18 	]  {
	self.nextthink = time + 0.05;
};
void() vengeance_spider18 =[	$death1,	vengeance_spider_run1 ]  {
	self.nextthink = time + 0.05;
};


								// from here on:  sequence where the corpse overbrights 
void()	vengeance_spider_bright05	= {
	self.colormod = '6 1 1';
	self.glow_color = 75;
	self.glow_size = 450;
	self.nextthink = time + 0.1;
	self.think = vengeance_spider1;
};
void()	vengeance_spider_bright04 	= {
	self.colormod = '5 1 1';
	self.glow_color = 75;
	self.glow_size = 350;
	self.nextthink = time + 0.1;
	self.think = vengeance_spider_bright05;
};
void()	vengeance_spider_bright03 	= {
	self.colormod = '4 1 1';
	self.glow_color = 75;
	self.glow_size = 270;
	self.nextthink = time + 0.1;
	self.think = vengeance_spider_bright04;
};
void()	vengeance_spider_bright02 	= {
	self.colormod = '3 1 1';
	self.glow_color = 75;
	self.glow_size = 185;
	self.nextthink = time + 0.1;
	self.think = vengeance_spider_bright03;
}; 
void()	vengeance_spider_bright01	= {
	self.colormod = '2 1 1';
	self.glow_color = 75;
	self.glow_size = 100;
	self.nextthink = time + 0.1;
	self.think = vengeance_spider_bright02;
};
void()	vengeance_spider_bright00 	= {  			// delay for 0.3 seconds before overbright process really begins
	self.alpha = 0.3;
	self.glow_color = 75;
	self.glow_size = 10;
	self.nextthink = time + 0.3;
	self.think = vengeance_spider_bright01;
};



void(string modelname, float modelframe) vengeance_spider =
{

local vector v;  			// v  was necessary at the begining of effect development, but isnt anymore now.
v_x = (self.origin_x);
v_y = (self.origin_y);
v_z = (self.origin_z);

      self.origin = v; 
   	self.touch = SUB_Null;                
	self.movetype = MOVETYPE_FLY;
	
	if (self.spider_is_shambler)
		{
		setmodel (self, "progs/spider_shambler.mdl"); 
		setsize (self, '-32 -32 -32', '32 32 40');
		}
	else
		{
		setmodel (self, "progs/spider.mdl"); 
		setsize (self, '-16 -16 -24', '16 16 16');
		}

	self.frame = modelframe;	 // modelframe is depending on the individual monster (included in vengeance call)

	var float autocvar_vengeancedamage = 0;   // set cvar 'vengeancedamage' default to 0
	if (autocvar_vengeancedamage == 0)	  	// if 'vengeancedamage' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '0'
		self.solid = SOLID_NOT;			// vengeance effect is NOT solid and cannot hurt the player
	else
		self.solid = SOLID_SLIDEBOX;    	// if value is NOT "0", player get hurt from this effect (see func "vengeance_spider_touch")!

	vengeance_spider_bright00 ();			// starts the animation
};



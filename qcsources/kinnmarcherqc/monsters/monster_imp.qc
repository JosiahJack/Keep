



void()	imp_stand1	=[	35,		imp_stand2	] 
{
	if (random() < 0.1)
	{
		if (self.voice_finished < time)
		{
			sound(self, CHAN_VOICE, "imp/gk_idle1.wav", 1, ATTN_IDLE);
			self.voice_finished = time + 5;
		}
	}

	ai_stand();
};
void()	imp_stand2	=[	37,		imp_stand3	] {ai_stand();};
void()	imp_stand3	=[	39,		imp_stand4	] {ai_stand();};
void()	imp_stand4	=[	41,		imp_stand5	] {ai_stand();};
void()	imp_stand5	=[	43,		imp_stand6	] {ai_stand();};
void()	imp_stand6	=[	45,		imp_stand7	] {ai_stand();};
void()	imp_stand7	=[	47,		imp_stand8	] {ai_stand();};
void()	imp_stand8	=[	49,		imp_stand9	] {ai_stand();};
void()	imp_stand9	=[	51,		imp_stand10	] {ai_stand();};
void()	imp_stand10	=[	53,		imp_stand1	] {ai_stand();};

void()	imp_perch1	=[	78,		imp_perch2	] 
{
	if (random() < 0.1)
	{
		if (self.voice_finished < time)
		{
			sound(self, CHAN_VOICE, "imp/gk_idle1.wav", 1, ATTN_IDLE);
			self.voice_finished = time + 5;
		}
	}

	ai_stand();
	self.pain_finished = time + 1.5;
};
void()	imp_perch2	=[	80,		imp_perch3	] {ai_stand();};
void()	imp_perch3	=[	82,		imp_perch4	] {ai_stand();};
void()	imp_perch4	=[	84,		imp_perch5	] {ai_stand();};
void()	imp_perch5	=[	86,		imp_perch6	] {ai_stand();};
void()	imp_perch6	=[	88,		imp_perch7	] {ai_stand();};
void()	imp_perch7	=[	90,		imp_perch8	] {ai_stand();};
void()	imp_perch8	=[	92,		imp_perch9	] {ai_stand();};
void()	imp_perch9	=[	94,		imp_perch10	] {ai_stand();};
void()	imp_perch10	=[	96,		imp_perch11	] {ai_stand();};
void()	imp_perch11	=[	98,		imp_perch12	] {ai_stand();};
void()	imp_perch12	=[	100,		imp_perch1	] {ai_stand();};

void()	imp_walk1	=[	35,		imp_walk2	] 
{
	ai_walk(10);

	if (random() < 0.2)
		sound(self, CHAN_VOICE, "imp/dsbgact.wav", 1, ATTN_IDLE);

};
void()	imp_walk2	=[	37,		imp_walk3	] {ai_walk(10);};
void()	imp_walk3	=[	39,		imp_walk4	] {ai_walk(10);};
void()	imp_walk4	=[	41,		imp_walk5	] {ai_walk(10);};
void()	imp_walk5	=[	43,		imp_walk6	] {ai_walk(10);};
void()	imp_walk6	=[	45,		imp_walk7	] {ai_walk(10);};
void()	imp_walk7	=[	47,		imp_walk8	] {ai_walk(10);};
void()	imp_walk8	=[	49,		imp_walk9	] {ai_walk(10);};
void()	imp_walk9	=[	51,		imp_walk10	] {ai_walk(10);};
void()	imp_walk10	=[	53,		imp_walk1	] {ai_walk(10);};


void()	imp_run1	=[	35,		imp_run2	] 
{
	ai_run(20);

	if (random() < 0.2)
		sound(self, CHAN_VOICE, "imp/dsbgact.wav", 1, ATTN_IDLE);

};
void()	imp_run2	=[	37,		imp_run3	] {ai_run(20);};
void()	imp_run3	=[	39,		imp_run4	] {ai_run(20);};
void()	imp_run4	=[	41,		imp_run5	] {ai_run(20);};
void()	imp_run5	=[	43,		imp_run6	] {ai_run(20);};
void()	imp_run6	=[	45,		imp_run7	] {ai_run(20);};
void()	imp_run7	=[	47,		imp_run8	] {ai_run(20);};
void()	imp_run8	=[	49,		imp_run9	] {ai_run(20);};
void()	imp_run9	=[	51,		imp_run10	] {ai_run(20);};
void()	imp_run10	=[	53,		imp_run1	] {ai_run(20);};

/*
void() imp_swoop15;

void() ImpSwoopTouch =
{
	local float ldmg;

	if (self.health <= 0)
		return;

	if (other.solid == SOLID_TRIGGER)
		return;

	if (other.takedamage)
	if (other.classname != self.classname)	//BDW 14/09/00 this stops a group of fiends from taking each other out
	{		
		ldmg = 40 + 10*random();
		T_Damage (other, self, self, ldmg);	
	}

	self.touch = SUB_Null;
	self.velocity = '0 0 0';
	self.movetype = MOVETYPE_STEP;
	self.yaw_speed = 10;


	self.think = imp_swoop15;
	self.nextthink = time + 0.1;
};

void(float vel) ai_imp_swoop =
{
	local vector vec;

	ai_face();

	makevectors(self.angles);	

	self.velocity = v_forward * vel;

	vec = (self.enemy.origin + self.enemy.view_ofs) - (self.origin + self.view_ofs);

	//dprint(ftos(vec_z));

	if (vec_z < -64)
		self.velocity_z = -100;
	else if (vec_z > 0)
		self.velocity_z = 100;

	
};
*/
/*
//in...
void()	imp_swoop1	=[	102,		imp_swoop2	] {ai_charge(20);};
void()	imp_swoop2	=[	104,		imp_swoop3	] {ai_charge(20);};
void()	imp_swoop3	=[	106,		imp_swoop4	] {ai_charge(20);};
void()	imp_swoop4	=[	108,		imp_swoop5	] {ai_charge(20);};
void()	imp_swoop5	=[	110,		imp_swoop6	] {ai_charge(20);};
void()	imp_swoop6	=[	112,		imp_swoop7	] 
{
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	self.movetype = MOVETYPE_FLY;
	self.yaw_speed = 20;
	self.touch = ImpSwoopTouch;

	ai_imp_swoop(250);

};
void()	imp_swoop7	=[	114,		imp_swoop8	] {ai_imp_swoop(300);};
void()	imp_swoop8	=[	116,		imp_swoop9	] {ai_imp_swoop(350);};
void()	imp_swoop9	=[	118,		imp_swoop10	] {ai_imp_swoop(400);};
void()	imp_swoop10	=[	120,		imp_swoop11	] {ai_imp_swoop(450);};

//loop...
void()	imp_swoop11	=[	122,		imp_swoop12	] {ai_imp_swoop(500);};
void()	imp_swoop12	=[	123,		imp_swoop13	] {ai_imp_swoop(500);};
void()	imp_swoop13	=[	124,		imp_swoop14	] {ai_imp_swoop(500);};
void()	imp_swoop14	=[	125,		imp_swoop11	] {ai_imp_swoop(500);};

//out...
void()	imp_swoop15	=[	126,		imp_swoop16	] {ai_charge(20);};
void()	imp_swoop16	=[	128,		imp_swoop17	] {ai_charge(20);};
void()	imp_swoop17	=[	130,		imp_swoop18	] {ai_charge(20);};
void()	imp_swoop18	=[	132,		imp_swoop19	] {ai_charge(20);};
void()	imp_swoop19	=[	134,		imp_swoop20	] {ai_charge(20);};
void()	imp_swoop20	=[	136,		imp_swoop21	] {ai_charge(20);};
void()	imp_swoop21	=[	138,		imp_swoop22	] {ai_charge(20);};
void()	imp_swoop22	=[	140,		imp_run1	] {ai_charge(20);};
*/

void() ImpMissileExplode =
{
	//T_RadiusDamage (self, self.owner, 30, world);

	/*
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);
	BecomeExplosion();
	*/

	local vector org;

	org = self.origin - 8*normalize(self.velocity);	

	self.movetype = MOVETYPE_NONE;
	self.touch = SUB_Null;
	self.solid = SOLID_NOT;

	self.velocity = '0 0 0';	
	
	setmodel(self, "sprites/imp/impexp.spr");
	setsize(self, '0 0 0', '0 0 0');
	setorigin(self, org);

	self.frame = 0;
	self.idleweaponframe = 6;
	self.think = BDW_SpriteGenericPlayOnce;
	self.nextthink = time + 0.05;

	sound(self, CHAN_VOICE, "shuffler/expsmall.wav", 1, ATTN_NORM);
};

void() ImpMissileTouch =
{
	local float ldmg;

	if (other == self.owner)
		return;		// don't explode on owner

	if (other.solid == SOLID_TRIGGER)
		return;	// trigger field, do nothing

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

	// hit something that bleeds
	if (other.takedamage)
	{
		spawn_touchblood(15);

		if (other.monsterflags & MF_ZOMBIE_GIB)
			T_Damage (other, self, self.owner, other.health + 10);
		else
		{
			ldmg = 15 + random()*10;
			T_Damage (other, self, self.owner, ldmg);
		}
	}	

	ImpMissileExplode();
};


//float IMPMAXLOBSPEED = 600;

void() ImpLaunchMissileNEW =
{
	local vector org, vel;
	local entity o;
	
	makevectors (self.angles);
	org = self.origin + v_forward*24 + v_right*16 + '0 0 10';	//origin of missile

//bdw - this is based on some crappy old lob ai code i found here:
//http://www.gamers.org/pub/idgames2/quakec/code_examples/lob_ai.txt

//replace this with something better when you can be bothered...
	
		
//-------------------------------------------------------- New Code --------
        local   float   dist;   // Distance between attacker and target.
        local   float   base;   // This dictates how fast the projectile
                                //   will fly up when it is launched.
        local   float   g;      // Gravity -- g = 1 is Earth gravity.

//------------------------------------------------------//
//  800 is normal (Earth) gravity.  800 * 0.00125 = 1.  //
//------------------------------------------------------//
        g = (cvar("sv_gravity")) * 0.00125;   // Find gravity in terms of g.
//--------------------------------------------------------------------------		
	
	
	
	
	// set missile speed
	
	
		vel = normalize(self.enemy.origin - org);
		vel = vel * 600;
		//missile.velocity_z = 200;
		
		//-------------------------------------------------------- New Code --------
		        dist = vlen(self.enemy.origin - org);
		//--------------------------------------------------------------//
		// The monster will lob a projectile that is guaranteed to hit  //
		// a stationary target within a radius of 1000.  If the target  //
		// is moving, it may aim the projectile a bit lower to counter  //
		// any attempt to run underneath the grenade.                   //               //
		//--------------------------------------------------------------//
		        if (self.enemy.velocity_x || self.enemy.velocity_y)
		                if (random() < 0.9)
		                        dist = dist - random()*300;
		        if (dist > 900)
		                base = 200+((dist - (200 - (dist * 0.2)))*0.5);
		        else if (dist > 700)
		                base = 200+((dist - (200 - (dist * 0.15)))*0.5);
		        else if (dist > 500)
		                base = 200+((dist - (200 - (dist * 0.1)))*0.5);
		        else if (dist > 200)
		                base = 200+((dist - 200)*0.5);
		        else
		                base = 200;
		
		        vel_z = (vel_z + (base * g));
//---------------------------------------------------------------- END -----
	
	
	
	
		
		
		//imp
		
		o = self.owner;
		
		o.owner = self;
		
		o.solid = SOLID_BBOX;
		o.movetype = MOVETYPE_BOUNCE;
		
		setsize (o, '0 0 0', '0 0 0');
		
		setorigin(o, org);	
		o.velocity = vel;
		o.touch = ImpMissileTouch;
		
		o.nextthink = time + 10;
		o.think = SUB_Remove;
		
		self.owner = world;	//disown fireball (won't blow up when imp killed)

	
	
	


}

void() ImpLaunchMissile =
{
	local	entity 	o, en;
	local	vector	dir, org;
	local float fast, t;

	fast = 600;

	makevectors(self.angles);
	
	org = self.origin + v_forward*24 + v_right*16 + '0 0 10';	//origin of missile

	en = self.enemy;
	t = (vlen(en.origin - self.origin)) / fast;	//rough calculation of time to reach enemy
	dir = en.velocity * t * 0.3;				//0.3 tones it down substantially
	dir_z = 0;							//jumping produces sillyness
	dir = dir + en.origin + '0 0 20' - org;		//vector to hit him slightly below the face

//todo? add a angle spread (see shuffler shot or similar)

	dir = normalize(dir);
	
	o = self.owner;

	o.owner = self;

	o.solid = SOLID_BBOX;
	o.movetype = MOVETYPE_FLYMISSILE;

	setsize (o, '0 0 0', '0 0 0');

	setorigin(o, org);	
	o.velocity = dir * fast;
	o.touch = ImpMissileTouch;

	o.nextthink = time + 10;
	o.think = SUB_Remove;

	self.owner = world;	//disown fireball (won't blow up when imp killed)
};

void(vector ofs, float sc) imp_pre_fireball =
{
	local vector org;

	makevectors(self.angles);

	org = self.origin + v_forward*ofs_x + v_right*ofs_y;
	org_z = org_z + ofs_z;

	setorigin(self.owner, org);
	//self.owner.scale = sc;	//scale removed, but i should make a sprite that shows it growing...
};

void() imp_fire1 = [14, imp_fire2] 
{
	local entity o;

	ai_face();
	sound (self, CHAN_WEAPON, "imp/dsfirsht.wav", 1, ATTN_NORM);
	//self.effects = self.effects | EF_MUZZLEFLASH;


	self.owner = spawn();
	o = self.owner;
	o.nextthink = time + 1;
	o.think = SUB_Remove;
	o.effects = EF_DIMLIGHT;

	setmodel (o, "sprites/imp/impball.spr");

	imp_pre_fireball('16 16 0', 0.2);

	self.pain_finished = time + 1.5;		//don't go into pain whilst firing
	self.monster_fight_time = time + 1.5;	//don't get distracted whilst spawning fireballs
};
void() imp_fire2 = [16, imp_fire3] {ai_face();imp_pre_fireball('13 16 0', 0.4);};
void() imp_fire3 = [18, imp_fire4] {ai_face();imp_pre_fireball('4 24 2', 0.6);};
void() imp_fire4 = [20, imp_fire5] {ai_face();imp_pre_fireball('-7 28 15', 0.8);};
void() imp_fire5 = [22, imp_fire6] {ai_face();imp_pre_fireball('-25 26 28', 1);};
void() imp_fire6 = [24, imp_fire7] {ai_face();imp_pre_fireball('-38 12 45', 1);};
void() imp_fire7 = [26, imp_fire8] {ai_face();imp_pre_fireball('-38 9 45', 1);};
void() imp_fire8 = [28, imp_fire9] {ai_face();imp_pre_fireball('-17 36 30', 1);};
void() imp_fire9 = [30, imp_fire10] {ai_face();ImpLaunchMissileNEW();};
void() imp_fire10 = [32, imp_fire11] {ai_face();};
void() imp_fire11 = [34, imp_run1] {ai_face();};




//imp doesn't appear to have specific pain anim, so this is cobbled together...

void()	imp_pain1	=[	2,		imp_pain2	] {};
void()	imp_pain2	=[	3,		imp_pain3	] {};
void()	imp_pain3	=[	2,		imp_pain4	] {};
void()	imp_pain4	=[	1,		imp_pain5	] {};
void()	imp_pain5	=[	0,		imp_run1	] {};



void()	imp_death1	=[	0,		imp_death2	] 
{
	self.velocity_x = -200 + 400*random();
	self.velocity_y = -200 + 400*random();
	self.velocity_z = 100 + 100*random();
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	sound (self, CHAN_VOICE, "imp/gk_deth1.wav", 1, ATTN_NORM);	
};
void()	imp_death2	=[	2,		imp_death3	] {};
void()	imp_death3	=[	4,		imp_death4	]{self.solid = SOLID_NOT;};
void()	imp_death4	=[	6,		imp_death5	] {};
void()	imp_death5	=[	8,		imp_death6	] {};
void()	imp_death6	=[	10,		imp_death7	] {};
void()	imp_death7	=[	12,		imp_death8	] {};
void()	imp_death8	=[	13,		BDW_CorpseRemove	] {};


void() imp_pain = 
{
	if (self.health <= 0)
		return;		// allready dying, don't go into pain frame

	if (self.pain_finished > time)
		return;
	
	imp_pain1();
	sound (self, CHAN_VOICE, "imp/gk_pain1.wav", 1, ATTN_NORM);

	self.pain_finished = time + 1;
};



void() imp_die = 
{
	if (self.owner)	//get rid of missile
	{	
		self.owner.think = ImpMissileExplode;
		self.owner.nextthink = time + 0.1;
	}

	if (self.health < -40)
	{
		MonsterGibMedium("progs/h_imp.mdl");
		return;
	}
	
	imp_death1();
};


float() ImpCheckAttack =
{
	local vector	spot1, spot2;
	local entity	targ;
	local float		chance;

	targ = self.enemy;

// see if any entities are in the way of the shot
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;

	traceline (spot1, spot2, FALSE, self);

   	if (trace_ent != targ)
      	return FALSE;     // don't have a clear shot

	if (trace_inopen && trace_inwater)
		return FALSE;			// sight line crossed contents
	


	if (time < self.attack_finished)
		return FALSE;

	if (enemy_range == RANGE_FAR)
		return FALSE;

	if (enemy_range == RANGE_MELEE)
	{
		//chance = 0.9;
		self.attack_state = AS_MISSILE;	//always go mad with fireballs at melee range
		return TRUE;
	}
	else if (enemy_range == RANGE_NEAR)
	{		
		chance = 0.3;
	}
	else if (enemy_range == RANGE_MID)
	{		
		chance = 0.1;
	}
	else
		chance = 0;

	if (random() < chance)
	{
		self.attack_state = AS_MISSILE;	//fireballs
		SUB_AttackFinished (1 + 2*random());
		return TRUE;
	}

	return FALSE;
};


void() imp_sight = 
{
	sound(self, CHAN_VOICE, "imp/gk_sght1.wav", 1, ATTN_NORM);
	
};

void() imp_perch_rise1 = [55,	imp_perch_rise2] {};
void() imp_perch_rise2 = [57,	imp_perch_rise3] {};
void() imp_perch_rise3 = [59,	imp_perch_rise4] {};
void() imp_perch_rise4 = [61,	imp_perch_rise5] {};
void() imp_perch_rise5 = [63,	imp_perch_rise6] {};
void() imp_perch_rise6 = [65,	imp_perch_rise7] {};
void() imp_perch_rise7 = [67,	imp_perch_rise8] {};
void() imp_perch_rise8 = [69,	imp_perch_rise9] {};
void() imp_perch_rise9 = [71,	imp_perch_rise10] {};
void() imp_perch_rise10 = [73, imp_perch_rise11] {};
void() imp_perch_rise11 = [75, imp_perch_rise12] {};
void() imp_perch_rise12 = [77, imp_run1] {};

void() imp_perch_rise =
{
	self.th_stand = imp_stand1;
	self.th_run = imp_run1;

	imp_perch_rise1();

	self.pain_finished = time + 1.5;	//don't go into pain whilst rising
	self.attack_finished = time + 1.5;	//don't attack immediately after rising
};

void() monster_imp_precache =
{
	precache_model ("progs/imp.mdl");
	precache_model ("progs/h_imp.mdl");


	precache_model ("sprites/imp/impball.spr");
	precache_model ("sprites/imp/impexp.spr");


	precache_sound ("imp/dsbgact.wav");		//doom imp idle
	precache_sound ("imp/gk_sght1.wav");	//gek sight
	precache_sound ("imp/gk_idle1.wav");	//gek idle
	precache_sound ("imp/gk_pain1.wav");	//gek pain
	precache_sound ("imp/gk_deth1.wav");	//gek death


	precache_sound ("imp/dsfirsht.wav");	//doom imp fireball

	//precache_sound ("imp/pain75_1.wav");		
	//precache_sound ("imp/pain100_1.wav");		

	precache_sound("shuffler/expsmall.wav");	
};

void() monster_imp_init =
{
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/imp.mdl");
	setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
	self.health = 220;
	
	self.th_walk = imp_walk1;	
	self.th_missile = imp_fire1;
	//self.th_melee = imp_swoop1;
	self.th_pain = imp_pain;
	self.th_die = imp_die;

	if ( (self.monsterflags & MF_SHUFFLER_MINION) || (self.classname == "monster_imp_perching") )
	{
		self.th_stand = imp_perch1;
		self.th_run = imp_perch_rise;
	}
	else
	{
		self.th_stand = imp_stand1;
		self.th_run = imp_run1;
	}

	self.sight_sound = imp_sight;
	self.check_attack = ImpCheckAttack;
	self.flags = self.flags | FL_FLY;
	self.classname = "monster_imp";
};

/*QUAKED monster_imp (1 0 0) (-32 -32 -24) (32 32 64) Ambush
*/
void() monster_imp =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}

	monster_imp_precache();
	
	if (MonsterSpawnedLater(MONSTER_IMP))	
		return;
	
	monster_imp_init();		
	bdw_monster_start ();
};

//centre of perching imp should be 40 units out from perching edge, and 24 units above it
void() monster_imp_perching =
{
	monster_imp();
};




/*
==============================================================================

SHAL-RATH

==============================================================================
*/
$cd id1/models/shalrath
$origin 0 0 24
$base base
$skin skin
$scale 0.7

$frame attack1 attack2 attack3 attack4 attack5 attack6 attack7 attack8
$frame attack9 attack10 attack11

$frame pain1 pain2 pain3 pain4 pain5

$frame death1 death2 death3 death4 death5 death6 death7

$frame	walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9 walk10
$frame	walk11 walk12

$frame	puff1 puff2 puff3 puff4 puff5 puff6 puff7 puff8 puff9 puff10
$frame	puff11 puff12 puff13 puff14 puff15 puff16

$frame jump1 jump2

void(entity inflictor, entity attacker, float damage) shalrath_boss_pain;
void() shal_boss_spawner;
void() shal_boss_attack1;
void() ShalBossGrenade;
void() ShalBossMissile;
void() ShalBossNova;
void() ShalBossNovaTouch;

void()	ring_grow1	=	[0,		ring_grow2] {};
void()	ring_grow2	=	[1,		ring_grow3] {};
void()	ring_grow3	=	[2,		ring_grow4] {};
void()	ring_grow4	=	[3,		ring_grow5] {};
void()	ring_grow5	=	[4,		ring_grow6] {};
void()	ring_grow6	=	[5,		ring_grow7] {};
void()	ring_grow7	=	[6,		SUB_Remove] {};

void() shal_boss_stand     =[      $walk1,       shal_boss_stand    ] {ai_stand();};

void() shal_boss_walk1     =[      $walk2,       shal_boss_walk2    ] {if (random() < 0.2) sound (self, CHAN_VOICE, "shalrath/idle.wav", 1, ATTN_IDLE); ai_walk(6);};
void() shal_boss_walk2     =[      $walk3,       shal_boss_walk3    ] {ai_walk(4);};
void() shal_boss_walk3     =[      $walk4,       shal_boss_walk4    ] {ai_walk(0);};
void() shal_boss_walk4     =[      $walk5,       shal_boss_walk5    ] {ai_walk(0);};
void() shal_boss_walk5     =[      $walk6,       shal_boss_walk6    ] {ai_walk(0);};
void() shal_boss_walk6     =[      $walk7,       shal_boss_walk7    ] {ai_walk(0);};
void() shal_boss_walk7     =[      $walk8,       shal_boss_walk8    ] {ai_walk(5);};
void() shal_boss_walk8     =[      $walk9,       shal_boss_walk9    ] {ai_walk(6);};
void() shal_boss_walk9     =[      $walk10,      shal_boss_walk10   ] {ai_walk(5);};
void() shal_boss_walk10    =[      $walk11,      shal_boss_walk11   ] {ai_walk(0);};
void() shal_boss_walk11    =[      $walk12,      shal_boss_walk12   ] {ai_walk(4);};
void() shal_boss_walk12    =[      $walk1,       shal_boss_walk1    ] {ai_walk(5);};

void() shal_boss_run1     =[      $walk2,       shal_boss_run2    ] { if (random() < 0.2) sound (self, CHAN_VOICE, "shalrath/idle.wav", 1, ATTN_IDLE); ai_run(6);};
void() shal_boss_run2     =[      $walk3,       shal_boss_run3    ] {ai_run(14);};
void() shal_boss_run3     =[      $walk4,       shal_boss_run4    ] {ai_run(0);shambler_walking_quake();};
void() shal_boss_run4     =[      $walk5,       shal_boss_run5    ] {ai_run(0);};
void() shal_boss_run5     =[      $walk6,       shal_boss_run6    ] {ai_run(0);};
void() shal_boss_run6     =[      $walk7,       shal_boss_run7    ] {ai_run(0);shambler_walking_quake();};
void() shal_boss_run7     =[      $walk8,       shal_boss_run8    ] {ai_run(15);if (self.health < 1800 && random() < .4) shal_boss_attack1();};
void() shal_boss_run8     =[      $walk9,       shal_boss_run9    ] {ai_run(16);};
void() shal_boss_run9     =[      $walk10,       shal_boss_run10    ] {ai_run(15);shambler_walking_quake();};
void() shal_boss_run10    =[      $walk11,       shal_boss_run11    ] {ai_run(0);};
void() shal_boss_run11    =[      $walk12,       shal_boss_run12    ] {ai_run(14);};
void() shal_boss_run12    =[      $walk1,       shal_boss_run1    ] {ai_run(15);};

void() shal_boss_jump1     =[      $attack11,       shal_boss_jump2    ] {ai_face();};
void() shal_boss_jump2     =[      $attack10,       shal_boss_jump3    ] {ai_face();shambler_walking_quake();};
void() shal_boss_jump3     =[      $attack9,       shal_boss_jump4    ] {ai_face();};
void() shal_boss_jump4     =[      $attack4,       shal_boss_jump5    ] {ai_face();sound (self, CHAN_VOICE, "shalrath/death.wav", 1, ATTN_NORM);};
void() shal_boss_jump5     =[      $attack3,       shal_boss_jump6    ] {ai_face();self.enemy.punchangle_x = -2;self.velocity = '0 0 500';};
void() shal_boss_jump6     =[      $attack2,       shal_boss_jump7    ] {ai_face();};
void() shal_boss_jump7     =[      $attack1,       shal_boss_jump8    ] {ai_face();};
void() shal_boss_jump8     =[      $jump2,       shal_boss_jump9    ] {ai_face();};
void() shal_boss_jump9     =[      $jump1,       shal_boss_jump10   ] {ai_face();};
void() shal_boss_jump10    =[      $jump2,       shal_boss_jump11   ] {ai_face();};
void() shal_boss_jump11    =[      $jump1,       shal_boss_jump12   ] {ai_face();};
void() shal_boss_jump12    =[      $jump2,       shal_boss_jump13   ] {ai_face();};
void() shal_boss_jump13    =[      $jump1,       shal_boss_jump14   ] {ai_face();};
void() shal_boss_jump14    =[      $jump2,       shal_boss_jump15   ] {ai_face();};
void() shal_boss_jump15    =[      $jump1,       shal_boss_jump16   ] {ai_face();ShalBossNova();};
void() shal_boss_jump16    =[      $jump2,       shal_boss_run1     ] {ai_face();self.enemy.punchangle_y = -8;};

void() shal_boss_attack1     =[      $attack1,       shal_boss_attack2    ] { if (self.health < 1200 && crandom() < 0.2 && enemy_range == RANGE_MELEE) shal_boss_jump1();
sound (self, CHAN_VOICE, "q15/shalrath/bossattack.wav", 1, ATTN_NORM);
ai_face();
};
void() shal_boss_attack2     =[      $attack2,       shal_boss_attack3    ] {ai_face();};
void() shal_boss_attack3     =[      $attack3,       shal_boss_attack4    ] {ai_face();};
void() shal_boss_attack4     =[      $attack4,       shal_boss_attack5    ] {ai_face();};
void() shal_boss_attack5     =[      $attack5,       shal_boss_attack6    ] {ai_face();};
void() shal_boss_attack6     =[      $attack6,       shal_boss_attack7    ] {ai_face();if (self.health < 1500) ShalBossGrenade();};
void() shal_boss_attack7     =[      $attack7,       shal_boss_attack8    ] {ai_face();if (self.health < 1000) ShalBossGrenade();};
void() shal_boss_attack8     =[      $attack8,       shal_boss_attack9    ] {ai_face();if (self.health < 1500) ShalBossGrenade();shal_boss_spawner();};
void() shal_boss_attack9     =[      $attack9,       shal_boss_attack10   ] {if (random() < .2) ShalBossMissile();
										else if (random() > .2 && random() < .5) if (self.health < 1800) {shal_boss_spawner();shal_boss_spawner();} else shal_boss_spawner();
										else {ShalBossGrenade();ShalBossGrenade();ShalBossGrenade();}};
void() shal_boss_attack10    =[      $attack10,      shal_boss_attack11   ] {ai_face();if (self.health < 1900) {ShalBossGrenade();ShalBossGrenade();}};
void() shal_boss_attack11    =[      $attack11,      shal_boss_run1   ] {};

void() shal_boss_pain1       =[      $pain1, shal_boss_pain2      ] {if (random() < 0.1 && self.health < 1400) shal_boss_jump1();};
void() shal_boss_pain2       =[      $pain2, shal_boss_pain3      ] {};
void() shal_boss_pain3       =[      $pain3, shal_boss_pain4      ] {};
void() shal_boss_pain4       =[      $pain4, shal_boss_pain5      ] {};
void() shal_boss_pain5       =[      $pain5, shal_boss_run1      ] {};


void() Shal_Gib = {
	ThrowGib(11, 2); // gib1mdl
	ThrowGib(12, 1); // gib2mdl
	ThrowGib(25, 1); // headmdl	
	ThrowGib(3, 4);
	ThrowGib(4, 15);
	ThrowGib(5, 14);

	// Squishy sound
	if (random() < 0.25)
		sound(self, CHAN_VOICE, "player/gib.wav", 1, ATTN_NORM);
	else if (random() < 0.5 && random() < 0.75)
		sound(self, CHAN_VOICE, "player/udeath2.wav", 1, ATTN_NORM);
	else
		sound(self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
};

void() shal_boss_death1      =[      $puff1,        shal_boss_death2     ] {sound (self, CHAN_VOICE, "shalrath/pain.wav", 1, ATTN_NORM);};
void() shal_boss_death2      =[      $puff2,        shal_boss_death3     ] {};
void() shal_boss_death3      =[      $puff3,        shal_boss_death4     ] {};
void() shal_boss_death4      =[      $puff4,        shal_boss_death5     ] {};
void() shal_boss_death5      =[      $puff5,        shal_boss_death6     ] {sound (self, CHAN_VOICE, "shalrath/death.wav", 1, ATTN_NORM);};
void() shal_boss_death6      =[      $puff6,        shal_boss_death7     ] {};
void() shal_boss_death7      =[      $puff7,        shal_boss_death8     ] {};
void() shal_boss_death8      =[      $puff8,        shal_boss_death9     ] {sound (self, CHAN_VOICE, "shalrath/death.wav", 1, ATTN_NORM);};
void() shal_boss_death9      =[      $puff9,        shal_boss_death10     ] {};
void() shal_boss_death10      =[      $puff10,        shal_boss_death11     ] {};
void() shal_boss_death11      =[      $puff11,        shal_boss_death12     ] {sound (self, CHAN_VOICE, "shalrath/pain.wav", 1, ATTN_NORM);};
void() shal_boss_death12      =[      $puff12,        shal_boss_death13     ] {};
void() shal_boss_death13      =[      $puff13,        shal_boss_death14     ] {sound (self, CHAN_VOICE, "shalrath/death.wav", 1, ATTN_NORM);};
void() shal_boss_death14      =[      $puff14,        shal_boss_death15     ] {};
void() shal_boss_death15      =[      $puff15,        shal_boss_death16     ] {};
void() shal_boss_death16      =[      16,        shal_boss_death17     ] {Shal_Gib();setmodel (self, "progs/q15/shalrath_death.mdl"); setsize (self, '-46 -40 -24', '46 40 100');};
void() shal_boss_death17      =[      16,        shal_boss_death18    ] {};
void() shal_boss_death18      =[      17,        shal_boss_death19    ] {};
void() shal_boss_death19      =[      18,        shal_boss_death20    ] {};
void() shal_boss_death20     =[      19,        shal_boss_death21    ] {};
void() shal_boss_death21     =[      20,        shal_boss_death22    ] {};
void() shal_boss_death22     =[      21,        shal_boss_death23    ] {};
void() shal_boss_death23     =[      22,        shal_boss_death23    ] {
	self.model = ""; // hide real monster
	self.think = SUB_Null; // don't repeat the last death frame for eternity (monsters)
	setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
};
/*void() shal_boss_death1      =[      $death1,        shal_boss_death2     ] {};
void() shal_boss_death2      =[      $death2,        shal_boss_death3     ] {};
void() shal_boss_death3      =[      $death3,        shal_boss_death4     ] {};
void() shal_boss_death4      =[      $death4,        shal_boss_death5     ] {};
void() shal_boss_death5      =[      $death5,        shal_boss_death6     ] {};
void() shal_boss_death6      =[      $death6,        shal_boss_death7     ] {};
void() shal_boss_death7      =[      $death7,        shal_boss_death7    ] {};*/

void(entity inflictor, entity attacker, float damage) shalrath_boss_pain = {
	if (self.pain_finished > time) return;

	sound (self, CHAN_VOICE, "shalrath/pain.wav", 1, ATTN_NORM);
	shal_boss_pain1();
	self.pain_finished = time + 3;
};

void() shalrath_boss_die = {
	sound (self, CHAN_VOICE, "shalrath/death.wav", 1, ATTN_NORM);
	shal_boss_death1();
	self.solid = SOLID_NOT;
};

void() ShalBossGrenadeExplode;
void() ShalBossGrenadeTouch;
void() ShalBossMissileTouch;
void() ShalBossHome;

void() ShalBossMissile = {
	local	entity 	missile;
	local	vector	dir;
	local	float	dist, flytime;

	dir = normalize((self.enemy.origin + '0 0 10') - self.origin);
	dist = vlen (self.enemy.origin - self.origin);
	flytime = dist * 0.002;
	if (flytime < 0.1) flytime = 0.1;
	self.effects = self.effects | EF_MUZZLEFLASH;
	sound (self, CHAN_WEAPON, "q15/shalrath/bossattack2.wav", 1, ATTN_NORM);
	missile = spawn ();
	missile.owner = self;
	missile.solid = SOLID_BBOX;
	missile.movetype = MOVETYPE_FLYMISSILE;
	setmodel (missile, "progs/v_spike.mdl");
	setsize (missile, '0 0 0', '0 0 0');
	missile.origin = self.origin + '0 0 60';
	missile.velocity = dir * 400;
	missile.avelocity = '300 300 300';
	missile.nextthink = flytime + time;
	missile.think = ShalBossHome;
	missile.enemy = self.enemy;
	missile.touch = ShalBossMissileTouch;
};

void() ShalBossGrenade = {
	local vector distancedelta; 
	local vector nozdistancedelta; 
	local vector	vec, dst, follow;
	local	entity missile;
	
	makevectors (self.enemy.angles);	
	follow = self.enemy.velocity*3.3;		// "guess" players future position to make it harder to dodge
	follow_z = 0;	
	dst = (self.enemy.origin + follow) - 13*self.movedir;
	vec = normalize(dst - self.origin);
	self.effects = self.effects | EF_MUZZLEFLASH;
	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;	
	makevectors (self.angles);
	sound (self, CHAN_WEAPON, "q15/shalrath/voregren.wav", 1, ATTN_NORM);
	sound (self, CHAN_ITEM, "q15/shalrath/voretick.wav", 1, ATTN_NORM);
	distancedelta = self.enemy.origin - self.origin; //work out distance vector  
	nozdistancedelta = distancedelta;  //copy to no height distance vector 
	nozdistancedelta_z = 0;  //remove height 
	missile.velocity = normalize(distancedelta); //set the velocity to the distance
	missile.velocity = vec * 350 + v_right*(random(90));   //give it more power 	
	missile.velocity_z = vec_z + 250 + vlen(nozdistancedelta)*0.22*(1 + (0.3*(random()))); 
	missile.avelocity = '300 300 300';
	missile.angles = vectoangles(missile.velocity);
	missile.touch = ShalBossGrenadeTouch;
	missile.nextthink = time + 2.2;	// set missile duration
	missile.think = ShalBossGrenadeExplode;
	setmodel (missile, "progs/v_spike.mdl");
	setsize (missile, '0 0 0', '0 0 0');	
	missile.scale = 1.2;	
	setorigin (missile, self.origin + '0 0 60');
};

void() ShalBossNova = {
	local	entity missile;
	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLY;
	missile.solid = SOLID_BBOX;
	missile.nextthink = time + .2;
	missile.think = ShalBossNovaTouch;
	setorigin (missile, self.origin + '0 0 -117');
};

void() ShalBossHome = {
	local vector	dir, vtemp;
	vtemp = self.enemy.origin + '0 0 10';
	if (self.enemy.health < 1) { remove(self); return; }
	dir = normalize(vtemp - self.origin);
	if (skill == 3)
		self.velocity = dir * 350;
	else
		self.velocity = dir * 250;
	self.nextthink = time + 0.2;
	self.think = ShalBossHome;
};

void() ShalBossMissileTouch = {
	if (other == self.owner) return;		// don't explode on owner

	if (other.classname == "monster_zombie") T_Damage (other, self, self, 110, DAMARMOR);
	if (other.classname == "monster_voreling") {
		sound (self, CHAN_WEAPON, "ad171/wraith/bounce.wav", 1, ATTN_NORM);
	} else {
		//T_RadiusDamage (self, self.owner, 40, world);
		T_Damage (other, self, self, 25,DAMARMOR);
		sound (self, CHAN_WEAPON, "q15/shalrath/voreball.wav", 1, ATTN_NORM);
		if (ext_dppart) pointparticles(particleeffectnum("voreball_explosion"), self.origin, '0 0 0', 1);
	}
	self.velocity = '0 0 0';
	self.touch = SUB_Null;
	setmodel (self, "progs/drake/s_explod.spr");
	self.solid = SOLID_NOT;
	s_explode1 ();
};

void() ShalBossGrenadeTouch = {
	if (other == self.owner) return;		// don't explode on owner
	
	self.velocity = self.velocity * 1.4;
	if (other.classname == "monster_zombie") T_Damage (other, self, self, 110,DAMARMOR);
	if (other.classname == "monster_voreling") {
		sound (self, CHAN_WEAPON, "ad171/wraith/bounce.wav", 1, ATTN_NORM);
	} else if (other.takedamage == DAMAGE_AIM) {
		ShalBossGrenadeExplode();
		return;
	}
};

void() ShalBossGrenadeExplode = {
	sound (self, CHAN_WEAPON, "q15/shalrath/voreexp.wav", 1, ATTN_NORM);
	if (ext_dppart) pointparticles(particleeffectnum("voreball_explosion"), self.origin, '0 0 0', 1);
	T_RadiusDamage (self, self.owner, 90, world, DAMAGEALL);
	self.touch = SUB_Null;
	setmodel (self, "progs/drake/s_explod.spr");
	self.solid = SOLID_NOT;
	s_explode1 ();
};

void() ShalBossNovaTouch = {
	local	entity shockwavefind; //creates head entity
	shockwavefind = findradius(self.owner.origin, 300);
	
	while(shockwavefind) {
		if (shockwavefind.takedamage) { // if head has health, attack it
			if(shockwavefind != self.owner) { // don't attack thunderbolt owner!!
				//if (shockwavefind.classname != "monster_voreling")
				//{
					//if (ext_dppart) pointparticles(particleeffectnum("voreball_explosion"), self.origin, '0 0 0', 1);
					//T_RadiusDamage (self, self.owner, 190, self.owner);
					//T_Damage (shockwavefind, self, self.owner, 20);
				//}
				if (shockwavefind.classname == "monster_voreling") {
					//T_RadiusDamage (self, self.owner, 190, self.owner);
					T_Damage (shockwavefind, self, self.owner, 40, DAMARMOR);
				} else {
					T_Damage (shockwavefind, self, self.owner, 20, DAMARMOR);
				}
			}
		}
		shockwavefind = shockwavefind.chain; // go to next enemy
	}
	sound (self, CHAN_AUTO, "q15/shalrath/earthshake.wav", 1, ATTN_NONE);
	if (ext_dppart) pointparticles(particleeffectnum("vore_shockwave"), self.origin, '0 0 0', 1);
	if(shockwavefind.classname == "player") self.owner.enemy.punchangle_x = -10;
	self.velocity = '0 0 0';
	self.touch = SUB_Null;
	setmodel (self, "progs/q15/ring_shockwave.mdl");
	self.scale = 6;
	self.solid = SOLID_NOT;
	ring_grow1 ();
};

//Enemy spawner
void() shal_boss_spawner = {
	local vector distancedelta; 
	local vector nozdistancedelta; 
	local	entity missile;
	
	self.effects = self.effects | EF_MUZZLEFLASH;
	missile = spawn ();
	missile.owner = self;
	missile.enemy = self.enemy;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
	makevectors (self.angles);	
	sound (self, CHAN_WEAPON, "q15/shalrath/firesum.wav", 1, ATTN_NORM);
	distancedelta = self.enemy.origin - self.origin; //work out distance vector  
	nozdistancedelta = distancedelta;  //copy to no height distance vector 
	nozdistancedelta_z = 0;  //remove height 
	missile.velocity = normalize(distancedelta); //set the velocity to the distance
	missile.velocity = missile.velocity * 150 + v_right*(random(90));   //give it more power 
    //  missile.velocity_z = missile.velocity_z + vlen(nozdistancedelta)*0.7;  //add extra height for extra distance	
	missile.velocity_z = missile.velocity_z + 350 + vlen(nozdistancedelta)*0.22*(1 + (0.3*(random()))); 
	missile.avelocity = '300 300 300';
	missile.angles = vectoangles(missile.velocity);
	//missile.touch = FuryBossSpawnTouch;
	missile.bbmins = VEC_HULLE_MIN;			// Small egg size
	missile.bbmaxs = VEC_HULLE_MAX;
	// set missile duration
	missile.nextthink = time + 2.5;
	missile.think = Hatch_Egg;				// Eventually hatch
	setmodel (missile, "progs/ad171/proj_shalshell.mdl");
	missile.scale = 3;	
	setsize (missile, missile.bbmins, missile.bbmaxs);
	setorigin (missile, self.origin);
};


void() ShalSpawnerExplode = {
	//if (ext_dppart) pointparticles(particleeffectnum("gibacid"), self.origin, '0 0 0', 1);

	self.velocity = '0 0 0';
	self.touch = SUB_Null;
	//setmodel (self, "progs/drake/s_explod.spr");
	self.scale = 5;
	self.solid = SOLID_NOT;
	s_explode1 ();
};

void() monster_shalrath_boss_precache = {
	precache_model("progs/q15/shalrath_boss.mdl");
	precache_model("progs/q15/shalrath_death.mdl");
	precache_model("progs/q15/h_shalboss.mdl");
	precache_model("progs/v_spike.mdl");
	precache_model("progs/ad171/proj_shalshell.mdl");
	precache_model("progs/q15/ring_shockwave.mdl");
	precache_model("progs/q15/gib_shalclawb.mdl");
	precache_model("progs/q15/gib_shalleg_b.mdl");
	precache_sound("q15/shalrath/bossattack.wav");
	precache_sound("q15/shalrath/bossattack2.wav");
	precache_sound("shalrath/death.wav");
	precache_sound("shalrath/idle.wav");
	precache_sound("shalrath/pain.wav");
	precache_sound("q15/shalrath/bosssight.wav");
	precache_sound("q15/shalrath/firesum.wav");
	precache_sound("ad171/wraith/attack3.wav");
	precache_sound("q15/shalrath/voreexp.wav");
	precache_sound("q15/shalrath/voretick.wav");
	precache_sound("q15/shalrath/voreball.wav");
	precache_sound("q15/shalrath/voregren.wav");
	precache_sound("q15/shalrath/earthshake.wav");
	precache_sound("ad171/wraith/bounce.wav");
	precache_sound("kinn/shuffler/expsmall.wav");
	precache_sound("player/udeath2.wav");
};

//QUAKED monster_shalrath_boss (1 0 0) (-32 -32 -24) (32 32 48) Ambush
void() monster_shalrath_boss = {
	if (monster_checkrandomizer() == TRUE) return; // Check for any random monster setups
	if (monster_checkspawn() == TRUE) return; // Check for any random monster setups

	self.mdl = "progs/q15/shalrath_boss.mdl";	// Extra skin
	self.headmdl = "progs/q15/h_shalboss.mdl";
	self.sight_sound = "q15/shalrath/bosssight.wav";
	self.gib1mdl = "progs/q15/gib_shalclawb.mdl";
	self.gib2mdl = "progs/q15/gib_shalleg_b.mdl";
	self.solid = SOLID_NOT;			// No interaction with world
	self.movetype = MOVETYPE_NONE;	// Static item, no movement
	if (self.bboxtype < 1) self.bboxtype = BBOX_WIDE;
	if (self.health < 1) {
		if (skill == 3 || coop) {
			self.health = 4700;
		} else if (skill == 2) {
			self.health = 4300;
		} else {
			self.health = 2500;
		}
	}
	self.gibhealth = MON_NEVERGIB;	// Cannot gib boss
	self.gibbed = FALSE;			// Still in one piece
	self.pain_flinch = 130;			// take a lot of damage before pain
	self.pain_timeout = 3;			// Really high pain tolerance
	self.steptype = FS_TYPELIGHT;	// Light tap feet
	self.blockudeath = TRUE;		// no humanoid death sound
	self.th_stand = shal_boss_stand;
	self.th_walk = shal_boss_walk1;
	self.th_run = shal_boss_run1;
	self.th_die = shalrath_boss_die;
	self.th_pain = shalrath_boss_pain;
	self.th_missile = shal_boss_attack1;
	self.th_melee = shal_boss_jump1;
	setsize (self, '-46 -40 -24', '46 40 100');
	if (self.deathstring == "") self.deathstring = "is a permanent addition to the Vore Queen's hive\n";
	Resist_ChangeType(self,-1); // Always reset Ammo Resistance to be consistent
	self.classtype = CT_MONSHALBOSS;
	self.classgroup = CG_SPIDER;
	self.classmove = MON_MOVEWALK;
	monster_start();
};
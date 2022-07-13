/*==============================================================================
INQUISITOR - For Twilight of the Idols map by Tronyn, for Stair of Grief Episode
==============================================================================*/

// Idle 70-72
void()	inquisitor_idle1	= [70,	inquisitor_idle2	] { ai_stand(); ai_down(4); };
void()	inquisitor_idle2	= [71,	inquisitor_idle3	] { ai_stand(); ai_down(4); };
void()	inquisitor_idle3	= [72,	inquisitor_idle1	] { ai_stand(); ai_down(4); };

// Walk 206-217
void()	inquisitor_walk1	= [206,	inquisitor_walk2	] { ai_walk(5); ai_down(4); };
void()	inquisitor_walk2	= [207,	inquisitor_walk3	] { ai_walk(4); ai_down(4); };
void()	inquisitor_walk3	= [208,	inquisitor_walk4	] { ai_walk(3); ai_down(4); };
void()	inquisitor_walk4	= [209,	inquisitor_walk5	] { ai_walk(5); ai_down(4); };
void()	inquisitor_walk5	= [210,	inquisitor_walk6	] { ai_walk(6); ai_down(4); };
void()	inquisitor_walk6	= [211,	inquisitor_walk7	] { ai_walk(5); ai_down(4); };
void()	inquisitor_walk7	= [212,	inquisitor_walk8	] { ai_walk(5); ai_down(4); };
void()	inquisitor_walk8	= [213,	inquisitor_walk9	] { ai_walk(4); ai_down(4); };
void()	inquisitor_walk9	= [214,	inquisitor_walk10	] { ai_walk(4); ai_down(4); };
void()	inquisitor_walk10	= [215,	inquisitor_walk11	] { ai_walk(3); ai_down(4); };
void()	inquisitor_walk11	= [216,	inquisitor_walk12	] { ai_walk(3); ai_down(4); };
void()	inquisitor_walk12	= [217,	inquisitor_walk1	] { ai_walk(6); ai_down(4); };

void() inquisitor_flightland1;

void() inquisitor_flight_attack = {
	throwpolypgib("progs/quoth/bilefrag.mdl", -40);
	throwpolypgib("progs/quoth/bilefrag.mdl", -50);
	throwpolypgib("progs/quoth/bilefrag.mdl", -60);
	throwpolypgib("progs/quoth/bilefrag.mdl", -75);
};

void() inquisitor_ascend1;

void() InquisitorCheckSetDown = {
	// Should we stop flying?
	if (self.flight_finished < time) {
		self.think = inquisitor_flightland1;
		self.nextthink = 0.1;
	} else {
		if (self.attack_finished < time) {
			self.attack_finished = time + 0.6; // fairly quick
			inquisitor_flight_attack();
		}
		self.gravity = 0;
		if ((self.origin_z - self.enemy.origin_z) < 192) inquisitor_ascend1();
	}
};

// Fly 105-119
void()	inquisitor_run1	= [105,		inquisitor_run2	] { flat_goal(13);InquisitorCheckSetDown(); self.gravity = 0; self.movetype = MOVETYPE_FLY; };
void()	inquisitor_run2	= [106,		inquisitor_run3	] { flat_goal(13);InquisitorCheckSetDown(); };
void()	inquisitor_run3	= [107,		inquisitor_run4	] { flat_goal(13);InquisitorCheckSetDown(); };
void()	inquisitor_run4	= [108,		inquisitor_run5	] { flat_goal(13);InquisitorCheckSetDown(); };
void()	inquisitor_run5	= [109,		inquisitor_run6	] { flat_goal(13);InquisitorCheckSetDown(); };
void()	inquisitor_run6	= [110,		inquisitor_run7	] { flat_goal(13);InquisitorCheckSetDown(); };
void()	inquisitor_run7	= [111,		inquisitor_run8	] { flat_goal(13);InquisitorCheckSetDown(); };
void()	inquisitor_run8	= [112,		inquisitor_run9	] { flat_goal(13);InquisitorCheckSetDown(); };
void()	inquisitor_run9	= [113,		inquisitor_run10] { flat_goal(13);InquisitorCheckSetDown(); };
void()	inquisitor_run10= [114,		inquisitor_run11] { flat_goal(13);InquisitorCheckSetDown(); };
void()	inquisitor_run11= [115,		inquisitor_run12] { flat_goal(13);InquisitorCheckSetDown(); };
void()	inquisitor_run12= [116,		inquisitor_run13] { flat_goal(13);InquisitorCheckSetDown(); };
void()	inquisitor_run13= [117,		inquisitor_run14] { flat_goal(13);InquisitorCheckSetDown(); };
void()	inquisitor_run14= [118,		inquisitor_run15] { flat_goal(13);InquisitorCheckSetDown(); };
void()	inquisitor_run15= [119,		inquisitor_run1 ] { flat_goal(13);InquisitorCheckSetDown(); };

// FlyAscend 89-104
void() inquisitor_ascend1= [89, inquisitor_ascend2] {};
void() inquisitor_ascend2= [90, inquisitor_ascend3] { SUB_RemoveFlags(self,FL_ONGROUND); ai_up(2); };
void() inquisitor_ascend3= [91, inquisitor_ascend4] { ai_up(3);inquisitor_flight_attack(); };
void() inquisitor_ascend4= [92, inquisitor_ascend5] { ai_up(4); };
void() inquisitor_ascend5= [93, inquisitor_ascend6] { ai_up(5); };
void() inquisitor_ascend6= [94, inquisitor_ascend7] { ai_up(6);inquisitor_flight_attack(); };
void() inquisitor_ascend7= [95, inquisitor_ascend8] { ai_up(8); };
void() inquisitor_ascend8= [96, inquisitor_ascend9] { ai_up(10); };
void() inquisitor_ascend9= [97, inquisitor_ascend10] { ai_up(12);inquisitor_flight_attack(); };
void() inquisitor_ascend10= [98, inquisitor_ascend11] { ai_up(8); };
void() inquisitor_ascend11= [99, inquisitor_ascend12] { ai_up(6);inquisitor_flight_attack(); };
void() inquisitor_ascend12= [100, inquisitor_ascend13] { ai_up(4); };
void() inquisitor_ascend13= [101, inquisitor_ascend14] { ai_up(2); };
void() inquisitor_ascend14= [102, inquisitor_ascend15] { ai_up(2); };
void() inquisitor_ascend15= [103, inquisitor_ascend16] {};
void() inquisitor_ascend16= [104, inquisitor_run1] {};

void() inquisitor_wavetargets = {
	// Check for boss wave boundary event
	if (self.health > 0) {
		// Check for wave boundary triggers
		self.noise = "";
		if (self.bosswave == 1) { self.noise = self.noise1; self.noise1 = ""; }
		else if (self.bosswave == 2) { self.noise = self.noise2; self.noise2 = ""; }
		else if (self.bosswave == 3) { self.noise = self.noise3; self.noise3 = ""; }
		
		// Is there any trigger for the wave boundary?
		if (self.noise != "") trigger_strs(self.noise, self);
	}
};

// TouchDownFromFly 152-167
void()	inquisitor_flightland1= [152,inquisitor_flightland2] { ai_down(4); self.gravity = 1; self.velocity_z = -1 * (100 + 100*random()); };
void()	inquisitor_flightland2= [153,inquisitor_flightland3] { ai_down(4); };
void()	inquisitor_flightland3= [154,inquisitor_flightland4] { ai_down(4); };
void()	inquisitor_flightland4= [155,inquisitor_flightland5] { ai_down(4); };
void()	inquisitor_flightland5= [156,inquisitor_flightland6] { ai_down(4); };
void()	inquisitor_flightland6= [157,inquisitor_flightland7] { ai_down(4); };
void()	inquisitor_flightland7= [158,inquisitor_flightland8] { ai_down(4); };
void()	inquisitor_flightland8= [159,inquisitor_flightland9] { ai_down(4); };
void()	inquisitor_flightland9= [160,inquisitor_flightland10] { ai_down(4); };
void()	inquisitor_flightland10= [161,inquisitor_flightland11] { ai_down(4); };
void()	inquisitor_flightland11= [162,inquisitor_flightland12] { ai_down(4); };
void()	inquisitor_flightland12= [163,inquisitor_flightland13] { ai_down(4); };
void()	inquisitor_flightland13= [164,inquisitor_flightland14] { ai_down(4); };
void()	inquisitor_flightland14= [165,inquisitor_flightland15] { ai_down(4); };
void()	inquisitor_flightland15= [166,inquisitor_flightland16] { ai_down(4); self.movetype = MOVETYPE_STEP; };
void()	inquisitor_flightland16= [167,inquisitor_standrun1] { ai_down(4); };

void() InquisitorCheckAttack;

// StandRun 70-72
void()	inquisitor_standrun1= [70,		inquisitor_standrun2 ] { ai_run(0); InquisitorCheckAttack();  self.gravity = 1; };
void()	inquisitor_standrun2= [71,		inquisitor_standrun3 ] { ai_run(0); };
void()	inquisitor_standrun3= [72,		inquisitor_standrun1 ] { ai_run(0); };

// AttackStopPalmOut 51-72
void() inquisitor_stormcloud = {
	local entity cloud;
	local vector offs;
	local float notfound;

	offs_x = crandom() * 32;
	offs_y = crandom() * 32;
	offs_z = 128;

	if (self.minion_count > self.minion_maxcount) {
		if (random() < 0.5) return; // still chance to spawn some
	}

	if (skill < 2) {
		if (random() < 0.25) return; // less clouds on lower skills
	} else if (skill == 0) {
		if (random() < 0.5) return; // half as many clouds on Easy
	}
	
	cloud = spawn();
	setorigin(cloud,self.origin + offs);
	cloud.spawnflags = cloud.spawnflags | MISC_DRIPSLIME | MISC_DRIPSILENT | 8;
	// cloud.noise1 = "rrp/misc/drip1.wav";
	// cloud.noise2 = "rrp/misc/drip2.wav";
	// cloud.noise3 = "rrp/misc/drip3.wav"; Too many sounds for this!
	cloud.path = "progs/s_dripgreen_lg.spr";
	cloud.headmdl = SSLIME_SPLASH;
	cloud.aflag = 48;
	cloud.dmg = 2;
	cloud.think = spawn_raincloud;
	cloud.nextthink = time + 0.05;
	cloud.owner = self; // Tell the cloud we need to adjust the count...
	self.minion_count = self.minion_count + 1; // Limit total clouds.  Cloud death reduces this count by 1
};

// AttackStaffPlantHuge 0-12
// Shockwave knock players and monsters back, Cast multiple poison clouds that move around slowly
void()	inquisitor_magica1 = [0,	inquisitor_magica2	] { ai_face(); ai_down(4); };
void()	inquisitor_magica2 = [1,	inquisitor_magica3	] { ai_face(); ai_down(4); };
void()	inquisitor_magica3 = [2,	inquisitor_magica4	] { ai_face(); ai_down(4); };
void()	inquisitor_magica4 = [3,	inquisitor_magica5	] { ai_face(); ai_down(4); };
void()	inquisitor_magica5 = [4,	inquisitor_magica6	] { ai_face(); ai_down(4); };
void()	inquisitor_magica6 = [5,	inquisitor_magica7	] { ai_face(); ai_down(4); };
void()	inquisitor_magica7 = [6,	inquisitor_magica8	] { ai_face(); ai_down(4); };
void()	inquisitor_magica8 = [7,	inquisitor_magica9	] { ai_face(); ai_down(4); };
void()	inquisitor_magica9 = [8,	inquisitor_magica10	] { ai_face(); ai_down(4); };
void()	inquisitor_magica10= [9,	inquisitor_magica11	] { ai_face(); ai_down(4); ai_shockwave(MONAI_STOMPIMPACT, MONAI_STOMPDAMAGE, MONAI_STOMPICERADIUS, MONAI_STOMPUP, 100); };
void()	inquisitor_magica11= [10,inquisitor_magica12	] { ai_face();inquisitor_stormcloud(); ai_down(4); 	sound(world,CHAN_AUTO,"drake/bane/thunder.wav",1,ATTN_NONE); };
void()	inquisitor_magica12= [11,inquisitor_magica13	] { ai_face();inquisitor_stormcloud(); ai_down(4); };
void()	inquisitor_magica13= [12,inquisitor_standrun1] { ai_face();inquisitor_stormcloud(); ai_down(4); };

void(vector boneofs) inquisitor_firebones = {
	local vector org, dir;

	if (self.health < 1) return;

	self.attack_speed = SPEED_WRAITHBONE + (skill * SPEED_WBONESKILL);
	makevectors(self.angles);

	// Generate spike/bone at final animation position
	org = self.origin + attack_vector(boneofs);
	dir = SUB_orgEnemyTarget() + v_right*(8*3);
	dir = normalize(dir - org);
	launch_projectile(org,dir,NO_SPIN,CT_PROJ_WPOISON,self.attack_speed+random()*25);
	dir = SUB_orgEnemyTarget() - v_right*(8*3);
	dir = normalize(dir - org);
	launch_projectile(org,dir,NO_SPIN,CT_PROJ_WPOISON,self.attack_speed+random()*25);
	dir = SUB_orgEnemyTarget() + v_up*8;
	dir = normalize(dir - org);
	launch_projectile(org,dir,NO_SPIN,CT_PROJ_WPOISON,self.attack_speed+random()*25);
	dir = SUB_orgEnemyTarget() - v_up*8;
	dir = normalize(dir - org);
	launch_projectile(org,dir,NO_SPIN,CT_PROJ_WPOISON,self.attack_speed+random()*25);
};

// AttackHoldStaffOut 13-27
void()	inquisitor_magicb1= [13,inquisitor_magicb2	] { ai_face(); ai_down(4); };
void()	inquisitor_magicb2= [14,inquisitor_magicb3	] { ai_face(); ai_down(4); };
void()	inquisitor_magicb3= [15,inquisitor_magicb4	] { ai_face(); ai_down(4); };
void()	inquisitor_magicb4= [16,inquisitor_magicb5	] { ai_face(); ai_down(4); };
void()	inquisitor_magicb5= [17,inquisitor_magicb6	] { ai_face(); ai_down(4); };
void()	inquisitor_magicb6= [18,inquisitor_magicb7	] { ai_face(); ai_down(4); };
void()	inquisitor_magicb7= [19,inquisitor_magicb8	] { ai_face(); ai_down(4); };
void()	inquisitor_magicb8= [20,inquisitor_magicb9	] { ai_face(); ai_down(4); };
void()	inquisitor_magicb9= [21,inquisitor_magicb10	] { ai_face();inquisitor_firebones('60 4 14'); ai_down(4); };
void()	inquisitor_magicb10= [22,inquisitor_magicb11	] { ai_face(); ai_down(4); };
void()	inquisitor_magicb11= [23,inquisitor_magicb12	] { ai_face(); ai_down(4); };
void()	inquisitor_magicb12= [24,inquisitor_magicb13	] { ai_face(); ai_down(4); };
void()	inquisitor_magicb13= [25,inquisitor_magicb14	] { ai_face(); ai_down(4); };
void()	inquisitor_magicb14= [26,inquisitor_magicb15	] { ai_face(); ai_down(4); };
void()	inquisitor_magicb15= [27,inquisitor_standrun1] { ai_face(); ai_down(4); };

void() inquisitor_fireflamewall = {
	local vector org, eorg, torg, dir, ang;
	local float targetang, fire_life;

	if (!self.enemy) return; //Cannot find target!
	if (self.health < 1) return; // we're dead Jim!

	makevectors(self.angles);	
	org = self.origin + attack_vector(self.attack_offset);
	eorg = org + attack_vector('16 0 16'); // Setup explosion origin (infront)
	
	// Quiet sfx + dust/smoke
	sound(self,CHAN_WEAPON,"ad181/justice/flame_fire.wav",1,ATTN_NORM);	
	if (random() > 0.5) SpawnProjectileSmoke(eorg, 200, 50, 250);
	M_LaunchFlameWall(org,FLAME_GREEN);
};

void() inquisitor_magicc24;

// AttackRaiseHandsPalmOutAfter 29-50
void()	inquisitor_magicc1=	[29,inquisitor_magicc2]  { ai_face(); ai_down(4); };
void()	inquisitor_magicc2=	[30,inquisitor_magicc3]  { ai_face(); ai_down(4); };
void()	inquisitor_magicc3=	[31,inquisitor_magicc4]  { ai_face(); ai_down(4); };
void()	inquisitor_magicc4=	[32,inquisitor_magicc5]  { ai_face(); ai_down(4); };
void()	inquisitor_magicc5=	[33,inquisitor_magicc6]  { ai_face(); ai_down(4); };
void()	inquisitor_magicc6=	[34,inquisitor_magicc7]  { ai_face(); ai_down(4); };
void()	inquisitor_magicc7=	[35,inquisitor_magicc8]  { ai_face(); ai_down(4); };
void()	inquisitor_magicc8=	[36,inquisitor_magicc9]  { ai_face(); ai_down(4); };
void()	inquisitor_magicc9=	[37,inquisitor_magicc10] { ai_face(); ai_down(4); };
void()	inquisitor_magicc10= [38,inquisitor_magicc11] { ai_face(); ai_down(4); };
void()	inquisitor_magicc11= [39,inquisitor_magicc12] { ai_face(); ai_down(4); };
void()	inquisitor_magicc12= [40,inquisitor_magicc13] { ai_face(); ai_down(4); };
void()	inquisitor_magicc13= [41,inquisitor_magicc14] { ai_face(); ai_down(4); };
void()	inquisitor_magicc14= [42,inquisitor_magicc15] { ai_face(); ai_down(4); };
void()	inquisitor_magicc15= [43,inquisitor_magicc16] {
	ai_face(); ai_down(4); 
	local float total;

	self.attack_count = SpriteCount_Flame(self.proj_attqty);
	total = self.attack_count;
	while (self.attack_count) {
		if ((self.attack_count / total) < 0.5)
			self.lefty = 1;
		else
			self.lefty = -1;
		inquisitor_fireflamewall();
		self.attack_count = self.attack_count - 1;
	}
	if (skill == 0) inquisitor_magicc24();
};
void()	inquisitor_magicc16= [44,inquisitor_magicc17] { ai_face(); ai_down(4); };
void()	inquisitor_magicc17= [43,inquisitor_magicc18] { ai_face(); ai_down(4); };
void()	inquisitor_magicc18= [42,inquisitor_magicc19] { ai_face(); ai_down(4); };
void()	inquisitor_magicc19= [43,inquisitor_magicc20] {
	ai_face(); ai_down(4); 
	self.attack_count = SpriteCount_Flame(self.proj_attqty);
	while (self.attack_count) {
		inquisitor_fireflamewall();
		self.attack_count = self.attack_count - 1;
	}
	if (skill < 2) inquisitor_magicc24();
};
void()	inquisitor_magicc20= [44,inquisitor_magicc21] { ai_face(); ai_down(4); };
void()	inquisitor_magicc21= [43,inquisitor_magicc22] { ai_face(); ai_down(4); };
void()	inquisitor_magicc22= [42,inquisitor_magicc23] { ai_face(); ai_down(4); };
void()	inquisitor_magicc23= [43,inquisitor_magicc24] {
	ai_face(); ai_down(4); 
	self.attack_count = SpriteCount_Flame(self.proj_attqty);
	while (self.attack_count) {
		inquisitor_fireflamewall();
		self.attack_count = self.attack_count - 1;
	}
};
void()	inquisitor_magicc24= [44,inquisitor_magicc25] { ai_face(); ai_down(4); };
void()	inquisitor_magicc25= [45,inquisitor_magicc26] { ai_face(); ai_down(4); };
void()	inquisitor_magicc26= [46,inquisitor_magicc27] { ai_face(); ai_down(4); };
void()	inquisitor_magicc27= [47,inquisitor_magicc28] { ai_face(); ai_down(4); };
void()	inquisitor_magicc28= [48,inquisitor_magicc29] { ai_face(); ai_down(4); };
void()	inquisitor_magicc29= [49,inquisitor_magicc30] { ai_face(); ai_down(4); };
void()	inquisitor_magicc30= [50,inquisitor_standrun1]  { ai_face(); ai_down(4); };

void() inquisitor_bbomb_die1 = [0,inquisitor_bbomb_die2] { setmodel(self,"progs/ad171/s_burst_poison.spr"); T_RadiusDamage(self, self.owner,9,self.owner,DAMAGEALL); self.nextthink = time + 0.15; };
void() inquisitor_bbomb_die2 = [1,inquisitor_bbomb_die3] { particle (self.origin, VEC_ORIGIN, MON_BCOLOR_GREEN + rint(random()*7), 16);	sound(world,CHAN_AUTO,"quoth/gug/bile.wav",1,ATTN_NONE);  self.nextthink = time + 0.15; };
void() inquisitor_bbomb_die3 = [2,inquisitor_bbomb_die4] { particle (self.origin, VEC_ORIGIN, MON_BCOLOR_GREEN + rint(random()*7), 14); self.nextthink = time + 0.15; };
void() inquisitor_bbomb_die4 = [3,inquisitor_bbomb_die5] { particle (self.origin, VEC_ORIGIN, MON_BCOLOR_GREEN + rint(random()*7), 12); self.nextthink = time + 0.15; };
void() inquisitor_bbomb_die5 = [4,inquisitor_bbomb_die6] { particle (self.origin, VEC_ORIGIN, MON_BCOLOR_GREEN + rint(random()*7), 10); self.nextthink = time + 0.15; };
void() inquisitor_bbomb_die6 = [5,inquisitor_bbomb_die7] { particle (self.origin, VEC_ORIGIN, MON_BCOLOR_GREEN + rint(random()*7), 8); self.nextthink = time + 0.15; };
void() inquisitor_bbomb_die7 = [6,inquisitor_bbomb_die7] { particle (self.origin, VEC_ORIGIN, MON_BCOLOR_GREEN + rint(random()*7), 6); entity_remove(self, 0.1); return; };

void() inquisitor_bbomb_burstcheck = {
	if (self.attack_finished < time) {
		self.think = inquisitor_bbomb_die1;
		self.nextthink = 0.1;
	}
};

void() inquisitor_bbomb_charge1 = [8,inquisitor_bbomb_charge2] { inquisitor_bbomb_burstcheck(); self.nextthink = time + 0.15; };
void() inquisitor_bbomb_charge2 = [7,inquisitor_bbomb_charge3] { inquisitor_bbomb_burstcheck(); self.nextthink = time + 0.15; };
void() inquisitor_bbomb_charge3 = [6,inquisitor_bbomb_charge4] { inquisitor_bbomb_burstcheck(); self.nextthink = time + 0.15; };
void() inquisitor_bbomb_charge4 = [5,inquisitor_bbomb_die1] { inquisitor_bbomb_burstcheck(); self.nextthink = time + 0.15; };

void() inquisitor_bilebomb_at_enemys_feet = {
	local entity missile;
	local vector org;
	local float dist;

	// Do shot straight at player always
	// ?();

	// Only do bilebomb at enemy's feet if they are close enough, don't cheese player from across the map
	dist = vlen(self.origin - self.enemy.origin);
	if (dist > 2048) return; // Too far away

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
void()	inquisitor_magicd1=	[71,inquisitor_magicd2]  { ai_face(); ai_down(4); };
void()	inquisitor_magicd2=	[72,inquisitor_magicd3]  { ai_face(); ai_down(4); };
void()	inquisitor_magicd3=	[73,inquisitor_magicd4]  { ai_face(); ai_down(4); };
void()	inquisitor_magicd4=	[74,inquisitor_magicd5]  { ai_face(); ai_down(4); };
void()	inquisitor_magicd5=	[75,inquisitor_magicd6]  { ai_face(); ai_down(4);  inquisitor_bilebomb_at_enemys_feet(); };
void()	inquisitor_magicd6=	[76,inquisitor_magicd7]  { ai_face(); ai_down(4); };
void()	inquisitor_magicd7=	[77,inquisitor_magicd8]  { ai_face(); ai_down(4); };
void()	inquisitor_magicd8=	[78,inquisitor_magicd9]  { ai_face(); ai_down(4);  inquisitor_bilebomb_at_enemys_feet(); };
void()	inquisitor_magicd9=	[79,inquisitor_magicd10] { ai_face(); ai_down(4); };
void()	inquisitor_magicd10= [80,inquisitor_magicd11] { ai_face(); ai_down(4); };
void()	inquisitor_magicd11= [81,inquisitor_magicd12] { ai_face(); ai_down(4); };
void()	inquisitor_magicd12= [82,inquisitor_magicd13] { ai_face(); ai_down(4);  inquisitor_bilebomb_at_enemys_feet(); };
void()	inquisitor_magicd13= [83,inquisitor_magicd14] { ai_face(); ai_down(4); };
void()	inquisitor_magicd14= [84,inquisitor_magicd15] { ai_face(); ai_down(4); };
void()	inquisitor_magicd15= [85,inquisitor_magicd16] { ai_face(); ai_down(4); };
void()	inquisitor_magicd16= [86,inquisitor_magicd17] { ai_face(); ai_down(4); };
void()	inquisitor_magicd17= [87,inquisitor_magicd18] { ai_face(); ai_down(4); };
void()	inquisitor_magicd18= [88,inquisitor_standrun1] { ai_face(); ai_down(4); };

void() inquisitor_pain1;

void() inquisitor_die = {
	inquisitor_pain1(); // hunch it, prep for burst!
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

void() inquisitor_hunch_idle1;

// PainDownToHunch 185-205
void()	inquisitor_pain1= [185,inquisitor_pain2] { inquisitor_shieldon(); self.gravity = 1; self.velocity_z = -1 * (100 + 100*random()); };
void()	inquisitor_pain2= [186,inquisitor_pain3] { ai_down(4); };
void()	inquisitor_pain3= [187,inquisitor_pain4] { ai_down(4); };
void()	inquisitor_pain4= [188,inquisitor_pain5] { ai_down(4); };
void()	inquisitor_pain5= [189,inquisitor_pain6] { ai_down(4); };
void()	inquisitor_pain6= [190,inquisitor_pain7] { ai_down(4); };
void()	inquisitor_pain7= [191,inquisitor_pain8] { ai_down(4); };
void()	inquisitor_pain8= [192,inquisitor_pain9] { ai_down(4); };
void()	inquisitor_pain9= [193,inquisitor_pain10] { ai_down(4); };
void()	inquisitor_pain10= [194,inquisitor_pain11] { ai_down(4); };
void()	inquisitor_pain11= [195,inquisitor_pain12] { ai_down(4); };
void()	inquisitor_pain12= [196,inquisitor_pain13] { ai_down(4); };
void()	inquisitor_pain13= [197,inquisitor_pain14] { ai_down(4); };
void()	inquisitor_pain14= [198,inquisitor_pain15] { ai_down(4); };
void()	inquisitor_pain15= [199,inquisitor_pain16] { ai_down(4); };
void()	inquisitor_pain16= [200,inquisitor_pain17] { ai_down(4); };
void()	inquisitor_pain17= [201,inquisitor_pain18] { ai_down(4); };
void()	inquisitor_pain18= [202,inquisitor_pain19] { ai_down(4); };
void()	inquisitor_pain19= [203,inquisitor_pain20] { ai_down(4); };
void()	inquisitor_pain20= [204,inquisitor_pain21] { ai_down(4); };
void()	inquisitor_pain21= [205,inquisitor_pain22] { if (self.health < 1) { inquisitor_hunch_idle1(); } };

// HunchIdle 168-184
void()	inquisitor_hunch_idle1= [168,inquisitor_hunch_idle2] { ai_down(4); };
void()	inquisitor_hunch_idle2= [169,inquisitor_hunch_idle3] { ai_down(4); };
void()	inquisitor_hunch_idle3= [170,inquisitor_hunch_idle4] { ai_down(4); };
void()	inquisitor_hunch_idle4= [171,inquisitor_hunch_idle5] { ai_down(4); };
void()	inquisitor_hunch_idle5= [172,inquisitor_hunch_idle6] { ai_down(4); };
void()	inquisitor_hunch_idle6= [173,inquisitor_hunch_idle7] { ai_down(4); };
void()	inquisitor_hunch_idle7= [174,inquisitor_hunch_idle8] { ai_down(4); };
void()	inquisitor_hunch_idle8= [175,inquisitor_hunch_idle9] { ai_down(4); };
void()	inquisitor_hunch_idle9= [176,inquisitor_hunch_idle10] { ai_down(4); };
void()	inquisitor_hunch_idle10= [177,inquisitor_hunch_idle11] { ai_down(4); };
void()	inquisitor_hunch_idle11= [178,inquisitor_hunch_idle12] { ai_down(4); };
void()	inquisitor_hunch_idle12= [179,inquisitor_hunch_idle13] { ai_down(4); };
void()	inquisitor_hunch_idle13= [180,inquisitor_hunch_idle14] { ai_down(4); };
void()	inquisitor_hunch_idle14= [181,inquisitor_hunch_idle15] { ai_down(4); };
void()	inquisitor_hunch_idle15= [182,inquisitor_hunch_idle16] { ai_down(4); };
void()	inquisitor_hunch_idle16= [183,inquisitor_hunch_idle17] { ai_down(4); };
void()	inquisitor_hunch_idle17= [184,inquisitor_hunch_idle17] {
	nour_lightningdeath(PARTICLE_BURST_GREEN); // No more inquisitor!
};

// We yet live?  Ok, let's fly up and scare the pants off the player
// RiseFromHunchToFly 120-151
void()	inquisitor_pain22= [120,inquisitor_pain23] {};
void()	inquisitor_pain23= [121,inquisitor_pain24] {};
void()	inquisitor_pain24= [122,inquisitor_pain25] {};
void()	inquisitor_pain25= [123,inquisitor_pain26] {};
void()	inquisitor_pain26= [124,inquisitor_pain27] {};
void()	inquisitor_pain27= [125,inquisitor_pain28] {};
void()	inquisitor_pain28= [126,inquisitor_pain29] {};
void()	inquisitor_pain29= [127,inquisitor_pain30] {};
void()	inquisitor_pain30= [128,inquisitor_pain31] {};
void()	inquisitor_pain31= [129,inquisitor_pain32] {};
void()	inquisitor_pain32= [130,inquisitor_pain33] { inquisitor_shieldoff(); self.turrettimer = time + (random() * 15) + 8; };
void()	inquisitor_pain33= [131,inquisitor_pain34] { SUB_RemoveFlags(self,FL_ONGROUND); };
void()	inquisitor_pain34= [132,inquisitor_pain35] { ai_up(2); };
void()	inquisitor_pain35= [133,inquisitor_pain36] { ai_up(3); };
void()	inquisitor_pain36= [134,inquisitor_pain37] { ai_up(4); };
void()	inquisitor_pain37= [135,inquisitor_pain38] { ai_up(5); };
void()	inquisitor_pain38= [136,inquisitor_pain39] { ai_up(6); };
void()	inquisitor_pain39= [137,inquisitor_pain40] { ai_up(7); };
void()	inquisitor_pain40= [138,inquisitor_pain41] { ai_up(8); };
void()	inquisitor_pain41= [139,inquisitor_pain42] { ai_up(9); };
void()	inquisitor_pain42= [140,inquisitor_pain43] { ai_up(10); };
void()	inquisitor_pain43= [141,inquisitor_pain44] { ai_up(12); };
void()	inquisitor_pain44= [142,inquisitor_pain45] { ai_up(14); };
void()	inquisitor_pain45= [143,inquisitor_pain46] { ai_up(16); };
void()	inquisitor_pain46= [144,inquisitor_pain47] { ai_up(14); };
void()	inquisitor_pain47= [145,inquisitor_pain48] { ai_up(10); };
void()	inquisitor_pain48= [146,inquisitor_pain49] { ai_up(8); };
void()	inquisitor_pain49= [147,inquisitor_pain50] { ai_up(6); };
void()	inquisitor_pain50= [148,inquisitor_pain51] { ai_up(4); };
void()	inquisitor_pain51= [149,inquisitor_pain52] { ai_up(3); };
void()	inquisitor_pain52= [150,inquisitor_pain53] { ai_up(2); };
void()	inquisitor_pain53= [151,inquisitor_run1] {
	ai_up(1);
	self.flight_finished = time + 15 + (random() * 20); // 15-35sec flight time go to fly
};

void(entity inflictor, entity attacker, float damage) inquisitor_pain = {
	if (self.flight_finished > time) return;
	if (self.health > 6000) return; // not ready to have waves happen
	if (self.health > 4500 && self.bosswave == 1) return;
	if (self.health > 3000 && self.bosswave == 2) return;
	if (self.health > 1500 && self.bosswave == 3) return;

	// Health increments of 1500 for performing a pain hunch, then flight afterwards
	if (self.health <= 6000 && self.bosswave == 0) { self.bosswave = self.bosswave + 1; 	inquisitor_wavetargets(); } // stage 1
	if (self.health <= 4500 && self.bosswave == 1) { self.bosswave = self.bosswave + 1; 	inquisitor_wavetargets(); } // stage 2
	if (self.health <= 3000 && self.bosswave == 2) { self.bosswave = self.bosswave + 1; 	inquisitor_wavetargets(); } // stage 3
	if (self.bosswave == 3) inquisitor_hunch_idle1();
	else inquisitor_pain1();
};

void() monster_inquisitor_precache = {
	precache_model("progs/inquisitor.mdl");
	PreCache_GreenFlame();
	precache_model(MODEL_PROJ_WPOISON);	// Poison nails (spider)
	precache_model ("progs/quoth/bilefrag.mdl"); // Small bile drop:  frames 0-5
	precache_model ("progs/quoth/bilebomb.mdl"); // Large bilebomb:  frames 0-5
	precache_model ("progs/quoth/greenexp.spr"); // Blobby burst effect:  frames 0-5
	precache_model ("progs/quoth/s_vp_pll.spr"); // Burst effect:  frames 53-57
	precache_model ("progs/ad171/s_exp_poison_med.spr"); // Poison cloud that moves around randomly:  grow 0-2, cloud 2-5, dissipate 5-13
	precache_model ("progs/drake/s_fancy.spr"); // Poison burst:  small puff 15-20, poison burst 115-119, puff 147-149
	precache_model ("progs/ad171/s_dripgreen.spr"); // Poison drip:  frame 0
	precache_model ("progs/ad171/s_dripsplgreen.spr"); // Poison drip splash:  frames 0-5
	precache_model ("progs/ad171/s_burst_poison.spr"); // Poison burst good:  frames 0-6
	precache_model ("progs/ad171/s_exp_poison_small.spr"); // Poison burst good small yellowish:  frames 0-12
	precache_model ("progs/drake/s_spark.spr"); // Sparkle:  frames 8-5 reverse
	precache_model ("progs/qmaster/astorm.spr"); // Rain storm
	precache_model ("progs/s_dripgreen_lg.spr"); // Large green drip
	precache_model(MODEL_PROJ_RINGSHOCK);	// Ground shockwave
	precache_sound("ad171/skullwiz/idle1.wav");
	precache_sound("ad171/skullwiz/pain2.wav");
	precache_sound("drake/archer/sight2.wav");
	precache_sound("ad171/skullwiz/fadeaway.wav");
	precache_sound("ad181/justice/flame_fire.wav");
	precache_sound("drake/bane/thunder.wav");
	precache_sound("quoth/gug/bile.wav");
	precache_sound("ad171/eidolon/elec_arch1.wav");
	precache_sound("ad171/eidolon/elec_arch2.wav");
	precache_sound("quoth/dguard/hit.wav");
	precache_sound("ad171/eidolon/implode_death.wav");
	if (ext_dppart) particleeffectnum(DPP_TEPLASMA);
};

// QUAKED monster_inquisitor (1 0 0) (-16 -16 -24) (16 16 40) Ambush
void() monster_inquisitor = {
	// Check all spawn exceptions (monsters.qc)
	if (monster_checkspawn() == TRUE) return;

	self.mdl = "progs/inquisitor.mdl";
	self.idle_sound = "ad171/skullwiz/idle1.wav";
	self.pain_sound = "ad171/skullwiz/pain2.wav";
	self.death_sound = "ad171/skullwiz/fadeaway.wav";
	self.solid = SOLID_NOT;				// No interaction with world until spawned
	self.movetype = MOVETYPE_NONE;		// Static item, no movement until spawned
	if (self.bboxtype < 1) {
		self.bbmins = '-16 -16 -56';	// Special Size
		self.bbmaxs = '16 16 44';
		self.bboxtype = BBOX_CUSTOM;
	}
	if (self.health < 1) self.health = 7500;
	self.pain_flinch = 100;					// Medium pain threshold
	self.pain_timeout = 5;				// High
	self.no_liquiddmg = TRUE;
	self.bosswave = 0; // Reset pain states
	self.steptype = FS_FLYING; // We change from walking to flying sometimes
	self.poisonous = TRUE; // Oh yeah, definitely!
	self.minion_maxcount = 8 + skill; // More clouds on hard! (Spawn faster too, 3 at once per staf slame)
	if (CheckZeroVector(self.proj_attqty)) self.proj_attqty = '7 3 16';
	Resist_ChangeType(self,-1); // Always reset Ammo Resistance to be consistent
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
void() rilke1;
void() hack1;
void() test1;
void() test2;
void() open1;
void() digst_close1;
void() standcatch;
void() flytrap_close1;
void() flytrap_melee1;
void() flytrap_digest1;
void() flytrap_walk2;

float() flytrap_findvictim = {
	local entity e;
	local float dist;

	dist = 64;
	
	if (self.temperament == TEMPRA_COWARDLY) {
		dist = 256;
		e = findradius(self.origin,dist);
		while (e) {
			if (e != self) {
				if (e.flags & FLx_CREATURE) {
					if (IsLeader(e) && e.deadflag != DEAD_DYING && e.deadflag != DEAD_DEAD) {
						self.count = 400 + (200 * random()); // 4-6 seconds or so
						self.enemy = e;
						if (self.classtype == CT_MONFLYTRAP)
							flytrap_close1();
						else
							digst_close1(); // 2 to skip click sound for switch activated
						return TRUE;
					}
				}
			}
			e = e.chain;
		}
	} else {
		e = findradius(self.origin,dist);
		while (e) {
			if (e != self) {
				if (e.flags & FLx_CREATURE && e.deadflag != DEAD_DYING && e.deadflag != DEAD_DEAD) {
					self.enemy = e;
					if (self.classtype == CT_MONFLYTRAP)
						flytrap_melee1();
					else
						hack1();
					return TRUE;
				}
			}
			e = e.chain;
		}
	}
	self.enemy = world;
	return FALSE;
};

// Stand
void() welt1 = [ 0,  welt2  ] { flytrap_findvictim(); };
void() welt2 = [ 1,  welt3  ] { monster_idle_sound(); };
void() welt3 = [ 2,  welt4  ] { flytrap_findvictim(); };
void() welt4 = [ 3,  welt5  ] {};
void() welt5 = [ 4,  welt6  ] { flytrap_findvictim(); };
void() welt6 = [ 5,  welt7  ] {};
void() welt7 = [ 6,  welt8  ] { flytrap_findvictim(); };
void() welt8 = [ 7,  welt9  ] {};
void() welt9 = [ 8,  welt10 ] { flytrap_findvictim(); };
void() welt10 = [ 9,  welt11 ] {};
void() welt11 = [ 10, welt12 ] { flytrap_findvictim(); };
void() welt12 = [ 11, welt13 ] {};
void() welt13 = [ 12, welt14 ] { flytrap_findvictim(); };
void() welt14 = [ 13, welt15 ] {};
void() welt15 = [ 14, welt16 ] { flytrap_findvictim(); };
void() welt16 = [ 15, welt17 ] {};
void() welt17 = [ 16, welt18 ] { flytrap_findvictim(); };
void() welt18 = [ 17, welt19 ] {};
void() welt19 = [ 18, welt20 ] { flytrap_findvictim(); };
void() welt20 = [ 19, welt21 ] {};
void() welt21 = [ 20, catch10 ] { flytrap_findvictim(); };

void() flytrap_digest;
void() digst1;

// Melee
void() hack1 = [ 21,  hack2  ] {
	if (self.enemy) self.count = self.enemy.health; // remember health for later
}; 
void() hack2 = [ 22,  hack3  ] {
	local vector dir;

	T_RadiusDamage(self,self,20,self,DAMAGEALL);
	if (self.enemy.health < self.count) {
		dprint("Sucking em in!\n");
		// Ok we hit them, reel em in
		dir = normalize(self.origin - self.enemy.origin) * 80;
		self.enemy.velocity = dir;
	}
};
void() hack3 = [ 23,  hack4  ] {};
void() hack4 = [ 24,  hack5  ] { sound(self,CHAN_VOICE,"ad171/lostsoul/bite.wav",1,ATTN_NORM);flytrap_digest(); };
void() hack5 = [ 25,  hack6  ] {};
void() hack6 = [ 26,  hack7  ] {};
void() hack7 = [ 27,  hack8  ] {};
void() hack8 = [ 20,  welt1  ] {};

// Readers?
void() flytrap_digest = {
	if (self.enemy.health < 1 && self.enemy.flags & FL_MONSTER) {
		if (vlen(self.enemy.origin - self.origin) < 64) {
			self.count = self.enemy.max_health;
			monster_remove_kill(self.enemy,FALSE,FALSE);
			self.enemy = world;
			ThrowGib(1,2);
			ThrowGib(2,1);
			ThrowGib(3,1);
			if (self.classtype == CT_MONFLYTRAP)
				flytrap_digest1();
			else
				digst1();
			return;
		}
	} else self.count = 0; // reset
};

void() digst_close1 = [	119 , digst_close2] {};
void() digst_close2 = [	118 , digst_close3] {};
void() digst_close3 = [	117 , digst_close4] {};
void() digst_close4 = [	116 , digst_close5] {};
void() digst_close5 = [	115 , digst_close6] {};
void() digst_close6 = [	114 , digst_close7] {};
void() digst_close7 = [	113 , digst_close8] {};
void() digst_close8 = [	112 , digst_close9] {};
void() digst_close9 = [	111 , digst1] {};

// Post-Melee
void() digst1 = [ 28,       digst2  ] { self.takedamage = DAMAGE_NO; if (self.temperament != TEMPRA_COWARDLY) sound(self,CHAN_VOICE,"zerstorer/cube/bc_gulp.wav",1,ATTN_NORM); };
void() digst2 = [ 29,       digst3  ] {};
void() digst3 = [ 30,       digst4  ] {};
void() digst4 = [ 31,       digst5  ] {};
void() digst5 = [ 32,       digst6  ] {};
void() digst6 = [ 33,       digst7  ] {};
void() digst7 = [ 34,       digst8  ] {};
void() digst8 = [ 35,       digst9  ] { if (self.temperament != TEMPRA_COWARDLY) sound(self,CHAN_VOICE,"zerstorer/cube/bc_gulp.wav",1,ATTN_NORM); };
void() digst9 = [ 36,       digst10 ] {};
void() digst10 = [ 37,       digst11 ] {};
void() digst11 = [ 38,       digst12 ] {};
void() digst12 = [ 39,       digst1 ] {
	local entity e;

	if (self.temperament == TEMPRA_COWARDLY) {
		self.enemy = world;
		e = findradius(self.origin,256);
		while (e) {
			if (e != self) {
				if (e.flags & FLx_CREATURE) {
					if (IsLeader(e) && e.deadflag != DEAD_DYING && e.deadflag != DEAD_DEAD) {
						self.enemy = e;
						digst1(); // Continue hiding
					}
				}
			}
			e = e.chain;
		}
		if (self.enemy == world) {
			self.count = 0;
			self.takedamage = DAMAGE_AIM;
			open1();
		}
	} else {
		if (self.count < 100) {
			self.count = 0;
			self.takedamage = DAMAGE_AIM;
			open1(); // Open back up
		}
	}
	self.count = self.count - 100;
};

void() open1 = [ 111, open2  ] {};
void() open2 = [ 112, open3  ] {};
void() open3 = [ 113, open4  ] {};
void() open4 = [ 114, open5  ] {};
void() open5 = [ 115, open6  ] {};
void() open6 = [ 116, open7  ] {};
void() open7 = [ 117, open8  ] {};
void() open8 = [ 118, open9  ] {};
void() open9 = [ 119, rilke1  ] { if (random() < 0.5)self.idletimer = time + 5 + (random() * 3); };

void() test1 = [ 40, test2  ] {
	sound(self,CHAN_AUTO,"ad171/ambience/switch_2.wav",1,ATTN_NORM);
};
void() test2 = [ 41, test3  ] { if (self.enemy) self.count = self.enemy.health; };
void() test3 = [ 42, test4  ] {
	local vector dir;

	ai_melee();
	if (self.enemy) {
		if (self.enemy.health < self.count) {
			// Ok we hit them, reel em in
			dprint("Reeling em in!\n");
			dir = normalize(self.origin - self.enemy.origin) * 80;
			self.enemy.velocity = dir;
		}
	}
};
void() test4 = [ 43, test5  ] { T_RadiusDamage(self,self,20,self,DAMAGEALL); };
void() test5 = [ 44, test6  ] { sound(self,CHAN_VOICE,"ad171/lostsoul/bite.wav",1,ATTN_NORM);flytrap_digest(); };
void() test6 = [ 45, test7  ] {};
void() test7 = [ 46, test8  ] {};
void() test8 = [ 47, test9  ] {};
void() test9 = [ 48, test10 ] { monster_idle_sound(); };
void() test10 = [ 49, test11 ] {};
void() test11 = [ 50, test12 ] {};
void() test12 = [ 51, test13 ] {};
void() test13 = [ 52, test14 ] {};
void() test14 = [ 53, test15 ] {};
void() test15 = [ 54, test16 ] {};
void() test16 = [ 55, test17 ] {};
void() test17 = [ 56, test18 ] {};
void() test18 = [ 57, test19 ] {};
void() test19 = [ 118, catch12] {};

void() rilke1 = [ 58,  rilke2  ] { flytrap_findvictim(); };
void() rilke2 = [ 59,  rilke3  ] {};
void() rilke3 = [ 60,  rilke4  ] { flytrap_findvictim(); };
void() rilke4 = [ 61,  rilke5  ] { monster_idle_sound(); };
void() rilke5 = [ 62,  rilke6  ] { flytrap_findvictim(); };
void() rilke6 = [ 63,  rilke7  ] {};
void() rilke7 = [ 64,  rilke8  ] { flytrap_findvictim(); };
void() rilke8 = [ 65,  rilke9  ] {};
void() rilke9 = [ 66,  rilke10 ] { flytrap_findvictim(); };
void() rilke10 = [ 67,  rilke11 ] {};
void() rilke11 = [ 68, rilke12 ] { flytrap_findvictim(); };
void() rilke12 = [ 69, rilke13 ] {};
void() rilke13 = [ 70, rilke14 ] { flytrap_findvictim(); };
void() rilke14 = [ 71, rilke15 ] {};
void() rilke15 = [ 72, rilke16 ] { flytrap_findvictim(); };
void() rilke16 = [ 73, rilke17 ] {};
void() rilke17 = [ 74, rilke18 ] { flytrap_findvictim(); };
void() rilke18 = [ 75, rilke19 ] {};
void() rilke19 = [ 76, rilke20 ] { flytrap_findvictim(); };
void() rilke20 = [ 77, rilke21 ] {};
void() rilke21 = [ 78, rilke22 ] { flytrap_findvictim(); };
void() rilke22 = [ 79, rilke23 ] {};
void() rilke23 = [ 80, rilke24 ] { flytrap_findvictim(); };
void() rilke24 = [ 81, rilke25 ] {};
void() rilke25 = [ 82, rilke26 ] { flytrap_findvictim(); };
void() rilke26 = [ 83, rilke27 ] {};
void() rilke27 = [ 84, rilke1  ] {
	if (random() < 0.2) welt1();
	flytrap_findvictim();
};

void() fault1 = [ 85,  fault2  ] {};
void() fault2 = [ 86,  fault3  ] { ThrowGib(1,2); };
void() fault3 = [ 87,  fault4  ] { ThrowGib(2,1); };
void() fault4 = [ 88,  fault5  ] { ThrowGib(3,1); };
void() fault5 = [ 89,  fault6  ] {};
void() fault6 = [ 90,  fault7  ] { ThrowGib(1,1); };
void() fault7 = [ 91,  fault8  ] { self.solid = SOLID_NOT; self.takedamage = DAMAGE_NO; };
void() fault8 = [ 92,  fault9  ] {};
void() fault9 = [ 93,  fault10 ] {};
void() fault10 = [ 94,  fault11 ] { ThrowGib(2,1); };
void() fault11 = [ 95,  fault12 ] {};
void() fault12 = [ 96,  fault13 ] {};
void() fault13 = [ 97,  fault14 ] {};
void() fault14 = [ 98, fault15 ] {};
void() fault15 = [ 99, fault16 ] {};
void() fault16 = [ 100, fault17 ] { ThrowGib(3,1); };
void() fault17 = [ 101, fault18 ] {};
void() fault18 = [ 102, fault19 ] {};
void() fault19 = [ 103, fault20 ] {};
void() fault20 = [ 104, fault21 ] {};
void() fault21 = [ 105, fault22 ] {};
void() fault22 = [ 106, fault23 ] { monster_death_postcheck(); };
void() fault23 = [ 107, fault1 ]      { monster_deadbody_check(); };

void() flytrap_ground_die = {
	monster_death_precheck(); // Pre-check routine to tidy up extra entities
	sound(self,CHAN_VOICE,"quoth/voreling/death.wav",1,ATTN_NORM);	
	if (!self.gibbed) fault1();
};

void(entity inflictor, entity attacker, float damage) catch1 = [ 108,catch2 ] { sound(self,CHAN_VOICE,"ad171/swampling/idle2.wav",1,ATTN_NORM); };
void() catch2 = [ 109,  catch3  ] {};
void() catch3 = [ 110,  catch4  ] {};
void() catch4 = [ 111,  catch5  ] {};
void() catch5 = [ 112,  catch6  ] {};
void() catch6 = [ 113,  catch7  ] {};
void() catch7 = [ 114,  catch8  ] {};
void() catch8 = [ 115,  catch9  ] {};
void() catch9 = [ 116,  catch10 ] {};
void() catch10 = [ 117,  catch11 ] {};
void() catch11 = [ 118, catch12 ] {};
void() catch12 = [ 119, catch13 ] {};
void() catch13 = [ 120, catch14 ] {};
void() catch14 = [ 121, catch15 ] {};
void() catch15 = [ 122, catch16 ] {};
void() catch16 = [ 123, standcatch  ] {};

void() standcatch = [ 123, standcatch  ] {
	self.use = test1;
	flytrap_findvictim();
	rilke27();
};

void() monster_flytrap_ground_precache = {
    precache_model ("progs/madfox/mon_flytrap.mdl");
	precache_sound("ad171/ambience/switch_2.wav");
	precache_sound("ad171/lostsoul/bite.wav");
	precache_sound("quoth/voreling/death.wav");
	precache_sound("ad171/swampling/idle2.wav");
	precache_sound("ad171/swampling/idle3.wav");
	precache_sound("zerstorer/cube/bc_gulp.wav");
};

void() monster_flytrap_ground = {
	self.mdl = "progs/madfox/mon_flytrap.mdl";
	self.idle_sound = "ad171/swampling/idle3.wav";
	self.solid = SOLID_BBOX;
	self.movetype = MOVETYPE_NONE;
	self.classname = "monster_flytrap_ground";
	self.classtype = CT_MONFLYTRAPGROUND;
	self.th_melee = hack1;
	self.th_stand =  self.th_run = standcatch;  
	self.th_die = flytrap_ground_die;
	self.th_pain = catch1;
	if (self.health < 1) self.health = 150;
	self.gibhealth = -40;
	self.bbmins = '16 16 16';	// Special Size
	self.bbmaxs = '24 24 24';
	self.bboxtype = BBOX_CUSTOM;
	self.alignment = GOOD;
	self.vulnerability = VULN_NORMAL;
	self.use = test1;
  	if (self.deathstring == "") self.deathstring = " was ingested by a Mechanized Venus Fly Trap\n";
	self.classmove = MON_MOVENONE;
	Resist_ChangeType(self,-1); // Always reset Ammo Resistance to 0 to be consistent.
	monster_start();
};

void() info_fli = {
	self.classname = "monster_flytrap_ground";
	monster_flytrap_ground();
};

void() flytrap_stand1 = [ 64,  flytrap_stand2  ] { flytrap_findvictim(); };
void() flytrap_stand2 = [ 65,  flytrap_stand3  ] { monster_idle_sound(); };
void() flytrap_stand3 = [ 66,  flytrap_stand4  ] { flytrap_findvictim(); };
void() flytrap_stand4 = [ 67,  flytrap_stand5  ] {};
void() flytrap_stand5 = [ 68,  flytrap_stand6  ] { flytrap_findvictim(); };
void() flytrap_stand6 = [ 69,  flytrap_stand7  ] {};
void() flytrap_stand7 = [ 70,  flytrap_stand8  ] { flytrap_findvictim(); };
void() flytrap_stand8 = [ 71,  flytrap_stand9  ] {};
void() flytrap_stand9 = [ 72,  flytrap_stand10  ] {
	if (random() < 0.2) flytrap_walk2();
	flytrap_findvictim();
};
void() flytrap_stand10 = [ 73,  flytrap_stand11  ] {};
void() flytrap_stand11 = [ 74,  flytrap_stand12  ] { flytrap_findvictim(); };
void() flytrap_stand12 = [ 75,  flytrap_stand13  ] {};
void() flytrap_stand13 = [ 76,  flytrap_stand14  ] { flytrap_findvictim(); };
void() flytrap_stand14 = [ 77,  flytrap_stand15  ] {};
void() flytrap_stand15 = [ 78,  flytrap_stand16  ] { flytrap_findvictim(); };
void() flytrap_stand16 = [ 79,  flytrap_stand1  ] {};

void() flytrap_walk1 = [ 48,  flytrap_walk2  ] { flytrap_findvictim();	if (random() < 0.2) flytrap_stand10(); };
void() flytrap_walk2 = [ 49,  flytrap_walk3  ] { monster_idle_sound(); };
void() flytrap_walk3 = [ 50,  flytrap_walk4  ] { flytrap_findvictim(); };
void() flytrap_walk4 = [ 51,  flytrap_walk5  ] {};
void() flytrap_walk5 = [ 52,  flytrap_walk6  ] { flytrap_findvictim(); };
void() flytrap_walk6 = [ 53,  flytrap_walk7  ] {};
void() flytrap_walk7 = [ 54,  flytrap_walk8  ] { flytrap_findvictim(); };
void() flytrap_walk8 = [ 55,  flytrap_walk9  ] {};
void() flytrap_walk9 = [ 56,  flytrap_walk10  ] { flytrap_findvictim(); };
void() flytrap_walk10 = [ 57,  flytrap_walk11  ] {};
void() flytrap_walk11 = [ 58,  flytrap_walk12  ] { flytrap_findvictim(); };
void() flytrap_walk12 = [ 59,  flytrap_walk13  ] {};
void() flytrap_walk13 = [ 60,  flytrap_walk14  ] { flytrap_findvictim(); };
void() flytrap_walk14 = [ 61,  flytrap_walk15  ] {};
void() flytrap_walk15 = [ 62,  flytrap_walk16  ] { flytrap_findvictim(); };
void() flytrap_walk16 = [ 63,  flytrap_walk1  ] {};

void() flytrap_open1;
void() flytrap_digest1;

void() flytrap_close1 = [	14 , flytrap_close2] {}
void() flytrap_close2 = [	15 , flytrap_close3] {};
void() flytrap_close3 = [	16 , flytrap_close4] {};
void() flytrap_close4 = [	17 , flytrap_close5] {};
void() flytrap_close5 = [	18 , flytrap_close6] {};
void() flytrap_close6 = [	19 , flytrap_close7] {};
void() flytrap_close7 = [	20 , flytrap_close8] {};
void() flytrap_close8 = [	21 , flytrap_close9] {};
void() flytrap_close9 = [	22 , flytrap_close10] { self.takedamage = DAMAGE_NO; };
void() flytrap_close10 = [	23 , flytrap_close11] {};
void() flytrap_close11 = [	24 , flytrap_close12] {};
void() flytrap_close12 = [	25 , flytrap_close13] {};
void() flytrap_close13 = [	26 , flytrap_close14] {};
void() flytrap_close14 = [	27 , flytrap_close15] {};
void() flytrap_close15 = [	28 , flytrap_digest1] {};

void() flytrap_digest1 = [	29 , flytrap_digest2] { self.takedamage = DAMAGE_NO; }
void() flytrap_digest2 = [	30 , flytrap_digest3] {};
void() flytrap_digest3 = [	31 , flytrap_digest4] {};
void() flytrap_digest4 = [	32 , flytrap_digest5] {};
void() flytrap_digest5 = [	33 , flytrap_digest6] {};
void() flytrap_digest6 = [	32 , flytrap_digest7] {};
void() flytrap_digest7 = [	31 , flytrap_digest8] {};
void() flytrap_digest8 = [	30 , flytrap_digest9] {};
void() flytrap_digest9 = [	29 , flytrap_digest10] {};
void() flytrap_digest10 = [	30 , flytrap_digest11] {};
void() flytrap_digest11 = [	31 , flytrap_digest12] {};
void() flytrap_digest12 = [	32 , flytrap_digest13] {};
void() flytrap_digest13 = [	33 , flytrap_digest14] {};
void() flytrap_digest14 = [	32 , flytrap_digest15] {};
void() flytrap_digest15 = [	31 , flytrap_digest16] {};
void() flytrap_digest16 = [	30 , flytrap_digest1] {
	local entity e;

	if (self.temperament == TEMPRA_COWARDLY) {
		self.enemy = world;
		e = findradius(self.origin,256);
		while (e) {
			if (e != self) {
				if (e.flags & FLx_CREATURE) {
					if (IsLeader(e) && e.deadflag != DEAD_DYING && e.deadflag != DEAD_DEAD) {
						self.enemy = e;
						flytrap_digest1(); // Continue hiding
					}
				}
			}
			e = e.chain;
		}
		if (self.enemy == world) {
			self.count = 0;
			self.takedamage = DAMAGE_AIM;
			flytrap_open1();
		}
	} else {
		if (self.count < 100) {
			self.count = 0;
			self.takedamage = DAMAGE_AIM;
			flytrap_open1(); // Open back up
		}
	}
	self.count = self.count - 100;
};

void() flytrap_open1 = [ 34,  flytrap_open2  ] {};
void() flytrap_open2 = [ 35,  flytrap_open3  ] {};
void() flytrap_open3 = [ 36,  flytrap_open4  ] {};
void() flytrap_open4 = [ 37,  flytrap_open5  ] {};
void() flytrap_open5 = [ 38,  flytrap_open6  ] {};
void() flytrap_open6 = [ 39,  flytrap_open7  ] {};
void() flytrap_open7 = [ 40,  flytrap_open8  ] {};
void() flytrap_open8 = [ 41,  flytrap_open9  ] {};
void() flytrap_open9 = [ 42,  flytrap_open10  ] {};
void() flytrap_open10 = [ 43,  flytrap_open11  ] {};
void() flytrap_open11 = [ 44,  flytrap_open12  ] {};
void() flytrap_open12 = [ 45,  flytrap_open13  ] {};
void() flytrap_open13 = [ 46,  flytrap_open14  ] {};
void() flytrap_open14 = [ 47,  flytrap_walk1  ] { if (random() < 0.5)self.idletimer = time + 5 + (random() * 3); };

void() flytrap_melee1 = [ 80,  flytrap_melee2  ] {};
void() flytrap_melee2 = [ 81,  flytrap_melee3  ] {};
void() flytrap_melee3 = [ 82,  flytrap_melee4  ] {};
void() flytrap_melee4 = [ 83,  flytrap_melee5  ] {};
void() flytrap_melee5 = [ 84,  flytrap_melee6  ] {};
void() flytrap_melee6 = [ 85,  flytrap_melee7  ] { sound(self,CHAN_VOICE,"ad171/lostsoul/bite.wav",1,ATTN_NORM); };
void() flytrap_melee7 = [ 86,  flytrap_melee8  ] { T_RadiusDamage(self,self,20,self,DAMAGEALL); };
void() flytrap_melee8 = [ 87,  flytrap_melee9  ] { flytrap_digest(); };
void() flytrap_melee9 = [ 88,  flytrap_melee10  ] {};
void() flytrap_melee10 = [ 89,  flytrap_melee11  ] {};
void() flytrap_melee11 = [ 90,  flytrap_melee12 ] {};
void() flytrap_melee12 = [ 91,  flytrap_melee13  ] {};
void() flytrap_melee13 = [ 92,  flytrap_melee14  ] {};
void() flytrap_melee14 = [ 93,  flytrap_melee15  ] {};
void() flytrap_melee15 = [ 94,  flytrap_melee16  ] {};
void() flytrap_melee16 = [ 95,  flytrap_walk1  ] {};

void(entity inflictor, entity attacker, float damage) flytrap_pain1 = [ 96,  flytrap_pain2  ] { sound(self,CHAN_VOICE,"ad171/swampling/idle2.wav",1,ATTN_NORM); };
void() flytrap_pain2 = [ 97,  flytrap_pain3  ] {};
void() flytrap_pain3 = [ 98,  flytrap_pain4  ] {};
void() flytrap_pain4 = [ 99,  flytrap_pain5  ] {};
void() flytrap_pain5 = [ 100,  flytrap_pain6  ] {};
void() flytrap_pain6 = [ 101,  flytrap_pain7  ] {};
void() flytrap_pain7 = [ 102,  flytrap_pain8  ] {};
void() flytrap_pain8 = [ 103,  flytrap_pain9  ] {};
void() flytrap_pain9 = [ 104,  flytrap_pain10  ] {};
void() flytrap_pain10 = [ 105,  flytrap_pain11  ] {};
void() flytrap_pain11 = [ 106,  flytrap_pain12  ] {};
void() flytrap_pain12 = [ 107,  flytrap_walk1  ] {};

void() flytrap_death1 = [ 108, flytrap_death2 ] {};
void() flytrap_death2 = [ 109,  flytrap_death3  ] {};
void() flytrap_death3 = [ 110,  flytrap_death4  ] {};
void() flytrap_death4 = [ 111,  flytrap_death5  ] {};
void() flytrap_death5 = [ 112,  flytrap_death6  ] { self.solid = SOLID_NOT; self.takedamage = DAMAGE_NO; };
void() flytrap_death6 = [ 113,  flytrap_death7  ] {};
void() flytrap_death7 = [ 114,  flytrap_death8 ] {};
void() flytrap_death8 = [ 115,  flytrap_death9 ] {};
void() flytrap_death9 = [ 116,  flytrap_death10 ] {};
void() flytrap_death10 = [ 117,  flytrap_death11 ] {};
void() flytrap_death11 = [ 118,  flytrap_death12 ] {};
void() flytrap_death12 = [ 119, flytrap_death13 ] {};
void() flytrap_death13 = [ 120, flytrap_death14 ] {};
void() flytrap_death14 = [ 121, flytrap_death15 ] {};
void() flytrap_death15 = [ 122, flytrap_death16 ] {};
void() flytrap_death16 = [ 123, flytrap_death17 ] {};
void() flytrap_death17 = [ 124, flytrap_death18 ] {};
void() flytrap_death18 = [ 125, flytrap_death19 ] { ThrowGib(1,2); };
void() flytrap_death19 = [ 126, flytrap_death20 ] { ThrowGib(2,2); };
void() flytrap_death20 = [ 127, flytrap_death21 ] {};
void() flytrap_death21 = [ 128, flytrap_death22 ] { ThrowGib(3,1); };
void() flytrap_death22 = [ 129, flytrap_death23 ] { ThrowGib(1,1);monster_death_postcheck(); };
void() flytrap_death23 = [ 130, flytrap_death23 ]      { monster_deadbody_check(); };

void() flytrap_die = {
	monster_death_precheck(); // Pre-check routine to tidy up extra entities
	sound(self,CHAN_VOICE,"quoth/voreling/death.wav",1,ATTN_NORM);	
	if (!self.gibbed) flytrap_death1();
};

void() monster_flytrap_precache = {
    precache_model("progs/madfox/mon_flytrap_standing.mdl");
	precache_sound("ad171/ambience/switch_2.wav");
	precache_sound("ad171/lostsoul/bite.wav");
	precache_sound("quoth/voreling/death.wav");
	precache_sound("ad171/swampling/idle2.wav");
	precache_sound("ad171/swampling/idle3.wav");
	precache_sound("zerstorer/cube/bc_gulp.wav");
};

void() monster_flytrap = {
	self.mdl = "progs/madfox/mon_flytrap_standing.mdl";
	self.idle_sound = "ad171/swampling/idle3.wav";
	self.solid = SOLID_BBOX;
	self.movetype = MOVETYPE_NONE;
	self.classtype = CT_MONFLYTRAP;
	self.th_melee = flytrap_walk1;
	self.th_stand = self.th_run = flytrap_walk1;
	self.th_die = flytrap_die;
	self.th_pain = flytrap_pain1;
	if (self.health < 1) self.health = 150;
	self.gibhealth = -40;
	self.bbmins = '16 16 16';	// Special Size
	self.bbmaxs = '24 24 24';
	self.bboxtype = BBOX_CUSTOM;
	self.alignment = GOOD;
	self.vulnerability = VULN_NORMAL;
	if (self.deathstring == "") self.deathstring = " was ingested by a Venus Fly Trap\n";
	self.classmove = MON_MOVESTATIC;
	Resist_ChangeType(self,-1); // Always reset Ammo Resistance to 0 to be consistent.
	monster_start();
};
//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by W. Josiah Jack, aka Qmaster
//
// Attributions: Travail
//
//
// Distribution / Copyright / Permissions 
//
// Please do not use any of these assets in ANY COMMERCIAL PROJECT.
// and remember to give credit if you use any of these assets. Please credit
// the appropriate authors of the various content used.  Refer to the credits
// folder.
//				  
// The QC files in this MOD are based on 1.06 source files by ID Software.
// These files are released under the terms of GNU General Public License v2 or
// later. You may use the source files as a base to build your own MODs as long
// as you release them under the same license and make the source available.
// Please also give proper credit. Check http://www.gnu.org for details.
//
// Quake is a registered trademark of id Software, Inc.
//
// All of these resources may be electronically distributed only at 
// NO CHARGE to the recipient.
//
// Stats:
// Entity count: 1
// Function count: 403
//
// Implements: Uber Scrag
//
// Description:
// Tough scrag boss that can spawn more scrags.  Loses part of itself as it
// becomes significantly damaged.
//=============================================================================

$frame unfurl1 unfurl2 unfurl3 unfurl4 unfurl5
$frame unfurl6 unfurl7 unfurl8 unfurl9 unfurl10
$frame unfurl11
$frame flya1 flya2 flya3 flya4 flya5
$frame flya6 flya7 flya8
$frame flyb1 flyb2 flyb3 flyb4 flyb5
$frame flyb6 flyb7 flyb8
$frame flyc1 flyc2 flyc3 flyc4 flyc5
$frame flyc6 flyc7 flyc8
$frame figeighta1 figeighta2 figeighta3 figeighta4 figeighta5
$frame figeighta6 figeighta7 figeighta8 figeighta9 figeighta10
$frame figeighta11 figeighta12 figeighta13 figeighta14 figeighta15
$frame figeighta16 figeighta17 figeighta18 figeighta19 figeighta20
$frame figeighta21 figeighta22 figeighta23 figeighta24
$frame figeightb1 figeightb2 figeightb3 figeightb4 figeightb5
$frame figeightb6 figeightb7 figeightb8 figeightb9 figeightb10
$frame figeightb11 figeightb12 figeightb13 figeightb14 figeightb15
$frame figeightb16 figeightb17 figeightb18 figeightb19 figeightb20
$frame figeightb21 figeightb22 figeightb23 figeightb24
$frame figeightc1 figeightc2 figeightc3 figeightc4 figeightc5
$frame figeightc6 figeightc7 figeightc8 figeightc9 figeightc10
$frame figeightc11 figeightc12 figeightc13 figeightc14 figeightc15
$frame figeightc16 figeightc17 figeightc18 figeightc19 figeightc20
$frame figeightc21 figeightc22 figeightc23 figeightc24
$frame flinga1 flinga2 flinga3 flinga4 flinga5
$frame flinga6 flinga7 flinga8 flinga9 flinga10
$frame flinga11 flinga12 flinga13 flinga14
$frame flingb1 flingb2 flingb3 flingb4 flingb5
$frame flingb6 flingb7 flingb8 flingb9 flingb10
$frame flingb11 flingb12 flingb13 flingb14
$frame flingc1 flingc2 flingc3 flingc4 flingc5
$frame flingc6 flingc7 flingc8 flingc9 flingc10
$frame flingc11 flingc12 flingc13 flingc14
$frame zapa1 zapa2 zapa3 zapa4 zapa5
$frame zapa6 zapa7 zapa8 zapa9 zapa10
$frame zapb1 zapb2 zapb3 zapb4 zapb5
$frame zapb6 zapb7 zapb8 zapb9 zapb10
$frame zapc1 zapc2 zapc3 zapc4 zapc5
$frame zapc6 zapc7 zapc8 zapc9 zapc10
$frame paina1 paina2 paina3 paina4 paina5
$frame paina6 paina7
$frame painb1 painb2 painb3 painb4 painb5
$frame painb6 painb7
$frame painc1 painc2 painc3 painc4 painc5
$frame painc6 painc7
$frame dieloop1 dieloop2 dieloop3 dieloop4 dieloop5
$frame dieloop6 dieloop7 dieloop8 dieloop9 dieloop10
$frame dieloop11 dieloop12 dieloop13 dieloop14 dieloop15
$frame dieloop16 dieloop17 dieloop18 dieloop19 dieloop20
$frame dieloop21 dieloop22 dieloop23
$frame dieend1 dieend2 dieend3 dieend4 dieend5
$frame dieend6 dieend7 dieend8 dieend9 dieend10
$frame dieend11

void(float offset) ubs_shot1;
void() spawnwiz;
void() ubs_shot2;
void() ubs_dodge;
void() ubs_side;

void() ubs_countscraglets = {
	local entity head;

	self.ident = 0;
	head = findradius (self.origin, 2000);
	while (head) {
		if ((head.classname == "monster_wizard")) self.ident = self.ident + 1;
		head = head.chain;
	}
};


void() ubscheckdist = {
	local vector dist, dist2, org;
	local float d, d2, cond;
	local entity head;

	if (self.cnt) return;

	self.cnt = TRUE;

	dist = (self.enemy.origin - self.origin);
	dist_z = 0;
	d = vlen (dist);
	if (d < 450) {
		if (visible (self.enemy)) ai_run ((((1 / d) * 5000) * -1));
	}
	cond = FALSE;
	if (d < 450 && d > 0) {
		if (!visible (self.enemy)) cond = TRUE;
	}

	if (cond) {
		ai_run (SECRET_YES_SHOOT);
	} else {
		if (((d > 450) && (d <= 600))) {
			ai_run (SECRET_1ST_DOWN);
		} else {
			if ((d >= 600)) ai_run ((20 * (d / 500)));
		}
	}
	head = findradius (self.origin, 500);
	while (head) {
		if ((head.classname == "missile")) ubs_dodge();
		head = head.chain;
	}
	ubs_countscraglets();
	self.cnt = FALSE;
};

void() ubshome;
void() ubshome2;

void() ubs_shot2 = {
	local vector offang, org, vec;

	offang = vectoangles ((self.enemy.origin - self.origin));
	makevectors(offang);
	org = (self.origin + v_forward * 64);
	vec = normalize (v_forward);
	launch_spike (org, vec);
	newmis.classname = "spawnspike";
	setmodel(newmis, "progs/travail/utele.mdl");
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);
	newmis.avelocity = '700 40 40';
	newmis.velocity = (vec * 300);
	sound(self,CHAN_WEAPON,"travail/ubs/spawnfr.wav",1,ATTN_NORM);
	newmis.enemy = self.owner.enemy;
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.think = ubshome2;
	newmis.nextthink = (time + 0.2);
};

void(float setting) ubs_spread = {
	local vector offang, org, vec;
	local float offset;

	offang = vectoangles ((self.enemy.origin - self.origin));
	if ((setting != 1)) {
		offang_x = (offang_x + ((random () * -50) + 25));
		offang_y = (offang_y + ((random () * -50) + 25));
		offang_z = (offang_z + ((random () * -50) + 25));
	}
	makevectors(offang);
	org = (((self.origin + self.mins) + (self.size * 0.5)) + (v_forward * 20));
	vec = normalize (v_forward);
	vec_z = ((0 - vec_z) + ((random () - 0.5) * 0.1));
	launch_spike (org, vec);
	newmis.classname = "wizspike";
	setmodel(newmis, "progs/w_spike.mdl");
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);
	newmis.velocity = (vec * 500);
	sound(self,CHAN_WEAPON,"travail/ubs/attack1.wav",1,ATTN_NORM);
	newmis.think = ubshome;
	newmis.nextthink = (time + 0.4);
	newmis.enemy = self.enemy;
};

void(float dist, float damage) ubs_zap = {
	local vector org, dir, horg;
	local float cells;
	local entity head, plasmapoint;

	self.effects = self.effects | EF_MUZZLEFLASH;
	ai_face();
	org = self.origin + '0 0 40';
	dir = self.enemy.origin + '0 0 16' - org;
	dir = normalize (dir);
	traceline (org, self.origin + dir*dist, FALSE, self);
	Tent_Beam(TE_LIGHTNING1,self,org,trace_endpos);
	if ((trace_ent.classgroup == CG_ZOMBIE)) damage = 70;
	if ((trace_ent.health <= damage)) damage = 60;
	if (trace_ent.takedamage) T_Damage (trace_ent, self, self, damage);
};

void() ubs_shot1_touch = {
	self.think = SUB_Null;
	if ((other == self.owner)) ubshome();
	T_Damage (other, self, self.owner, 15);
	Tent_Explosion(self.origin);
	BecomeExplosion();
};

void() ubs_shot1_touch2 = {
	self.think = SUB_Null;
	if ((other == self.owner)) self.think = ubshome2;
	self.owner.ident = (self.owner.ident + 1);
	self.nextthink = (time + 0.1);
	spawnwiz();
	BecomeExplosion();
};

void() ubshome = {
	local vector dir, vtemp, dist;
	local float d;

	self.angles = vectoangles(self.velocity); //point in direction of movement

	dist = (self.enemy.origin - self.origin);
	dist_z = 0;
	d = vlen (dist);
	traceline (self.origin, self.enemy.origin, TRUE, self);
	if ((trace_fraction == 1)) {
		if (self.enemy.health < 1) self.think = SUB_Null;
		vtemp = (self.enemy.origin + '0 0 10');
		dir = normalize ((vtemp - self.origin));
		if ((skill == 3)) self.velocity = (dir * 430);

		if ((self.classname == "wizspike")) {
			self.velocity = (dir * 400);
		} else {
			self.velocity = (dir * 300);
		}
		self.nextthink = (time + 0.1);
		self.think = ubshome;
		self.enemy = self.owner.enemy;
		if (((self.temp6 == 15) && (self.classname != "wizspike"))) {
			self.think = SUB_Null;
			self.nextthink = (time + 0.1);
		}
		if ((self.classname != "wizspike")) self.temp6 = (self.temp6 + 1);
	}
	if ((self.classname == "wizspike")) {
		self.angles = vectoangles (self.velocity);
		if ((self.temp6 == 12)) self.think = SUB_Null;
		self.temp6 = (self.temp6 + 1);
	}
};

void() ubshome2 = {
	local vector dir, vtemp, dist;
	local float d;

	dist = (self.enemy.origin - self.origin);

	d = vlen (dist);
	traceline (self.origin, self.enemy.origin, TRUE, self);
	if ((trace_fraction == 1)) {
		if (!IsAlive(self.enemy)) self.think = SUB_Null;
		vtemp = (self.enemy.origin + '0 0 20');
		dir = normalize ((vtemp - self.origin));
		self.velocity = (dir * 300);
		self.enemy = self.owner.enemy;
	}
	if ((d >= 256)) self.think = ubshome2;
	if ((d < 256)) self.think = spawnwiz;
	self.nextthink = (time + 0.1);

	if ((self.skin == 0)) {
		self.skin = 1;
	} else {
		if ((self.skin == 1)) {
			self.skin = 0;
		}
	}
};

void(float offset) ubs_shot1 = {
	local entity missile;
	local vector dir;
	local float dist, flytime;

	dir = normalize (((self.enemy.origin + '0 0 10') - self.origin));
	dist = vlen ((self.enemy.origin - self.origin));
	flytime = (dist * 0.002);
	if ((flytime < 0.1)) flytime = 0.1;
	self.effects = (self.effects | EF_MUZZLEFLASH);
	sound(self,CHAN_WEAPON,"shalrath/attack2.wav",1,ATTN_NORM);
	missile = spawn();
	missile.owner = self;
	missile.solid = SOLID_BBOX;
	missile.movetype = MOVETYPE_FLYMISSILE;
	setmodel(missile, "progs/v_spike.mdl");
	setsize (missile, VEC_ORIGIN, VEC_ORIGIN);
	missile.origin = (self.origin + '0 0 10');
	missile.velocity = (dir * 400);
	missile.avelocity = '800 200 200';
	missile.touch = ubs_shot1_touch;
	missile.think = ubshome;
	missile.nextthink = (time + 0.6);
	missile.enemy = self.enemy;
	missile.movetype = MOVETYPE_FLYMISSILE;
};

void(entity missile, float mspeed, float accuracy) UbsMissile = {
	local vector vec, move;
	local float fly;

	makevectors(self.angles);
	vec = (((self.enemy.origin + self.enemy.mins) + (self.enemy.size * 0.7)) - missile.origin);
	fly = (vlen (vec) / mspeed);
	move = self.enemy.velocity;
	move_z = MSG_BROADCAST;
	vec = (vec + (move * fly));
	vec = normalize (vec);
	vec = ((vec + ((accuracy * v_up) * (random () - 0.5))) + ((accuracy * v_right) * (random () - 0.5)));
	missile.velocity = (vec * mspeed);
	missile.angles = VEC_ORIGIN;
	missile.angles_y = vectoyaw (missile.velocity);
	missile.nextthink = (time + TE_LIGHTNING1);
	missile.think = SUB_Remove;
};

void() ubs_run;

void() ubsAttackFinished = {
	if (((enemy_range >= RANGE_MID) || !enemy_vis)) {
		self.attack_state = AS_STRAIGHT;
		self.think = ubs_run;
	}
};

void() ubs_FastFire = {
	local vector vec, dst;

	if (IsAlive(self.owner)) {
		self.owner.effects = (self.owner.effects | EF_MUZZLEFLASH);
		makevectors(self.enemy.angles);
		dst = (self.enemy.origin - (13 * self.movedir));
		vec = normalize ((dst - self.origin));
		sound(self,CHAN_WEAPON,"wizard/wattack.wav",1,ATTN_NORM);
		launch_spike (self.origin, vec);
		newmis.velocity = (vec * 600);
		newmis.owner = self.owner;
		newmis.classname = "wizspike";
		setmodel(newmis, "progs/w_spike.mdl");
		setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);
	}
	remove (self);
};

void() ubs_StartFast = {
	local entity missile;

	sound(self,CHAN_WEAPON,"wizard/wattack.wav",1,ATTN_NORM);
	self.v_angle = self.angles;
	makevectors(self.angles);
	missile = spawn();
	missile.owner = self;
	missile.nextthink = (time + 0.6);
	setsize (missile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(missile, (((self.origin + '0 0 30') + (v_forward * 14)) + (v_right * 14)));
	missile.enemy = self.enemy;
	missile.nextthink = (time + 0.8);
	missile.think = ubs_FastFire;
	missile.movedir = v_right;
	missile = spawn();
	missile.owner = self;
	missile.nextthink = (time + 1);
	setsize (missile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(missile, (((self.origin + '0 0 30') + (v_forward * 14)) + (v_right * -14)));
	missile.enemy = self.enemy;
	missile.nextthink = (time + 0.3);
	missile.think = ubs_FastFire;
	missile.movedir = (VEC_ORIGIN - v_right);
};

void() ubs_idlesound = {
	local float wr;

	wr = (random () * TE_LIGHTNING1);
	if ((self.waitmin < time))
	{
		self.waitmin = (time + 2);
		if ((wr > 4.5))
		{
			sound(self,CHAN_VOICE, "travail/ubs/widle1.wav",1,ATTN_NONE);
		}
		if ((wr < 1.5))
		{
			sound(self,CHAN_VOICE, "travail/ubs/widle2.wav",1,ATTN_NONE);
		}
	}
	return;
};

void() ubs_unfurl1 = [$unfurl1, ubs_unfurl2 ]
{
	sound(self,CHAN_VOICE, "travail/ubs/wsight.wav",1,ATTN_NONE);
	self.takedamage = DAMAGE_AIM;
	self.ideal_yaw = self.angles * '0 1 0';
	self.view_ofs = '0 0 25';

	self.flags = self.flags | FL_FLY;
	self.flags = self.flags | FL_MONSTER;
};
void() ubs_unfurl2 = [$unfurl2, ubs_unfurl3 ] {};
void() ubs_unfurl3 = [$unfurl3, ubs_unfurl4 ] {};
void() ubs_unfurl4 = [$unfurl4, ubs_unfurl5 ] {};
void() ubs_unfurl5 = [$unfurl5, ubs_unfurl6 ] {};
void() ubs_unfurl6 = [$unfurl6, ubs_unfurl7 ] {};
void() ubs_unfurl7 = [$unfurl7, ubs_unfurl8 ] {};
void() ubs_unfurl8 = [$unfurl8, ubs_unfurl9 ] {};
void() ubs_unfurl9 = [$unfurl9, ubs_unfurl10 ] {};
void() ubs_unfurl10 = [$unfurl10, ubs_unfurl11 ] {};
void() ubs_unfurl11 = [$unfurl11, ubs_runa1 ]
{
	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
	self.ubs_point = SelectUBSPoint();
	self.pausetime = 99999999;
	self.th_run();
};

void() ubs_standa1 = [$flya1, ubs_standa2 ] { ai_stand(); };
void() ubs_standa2 = [$flya2, ubs_standa3 ] { ai_stand(); };
void() ubs_standa3 = [$flya3, ubs_standa4 ] { ai_stand(); };
void() ubs_standa4 = [$flya4, ubs_standa5 ] { ai_stand(); };
void() ubs_standa5 = [$flya5, ubs_standa6 ] { ai_stand(); };
void() ubs_standa6 = [$flya6, ubs_standa7 ] { ai_stand(); };
void() ubs_standa7 = [$flya7, ubs_standa8 ] { ai_stand(); };
void() ubs_standa8 = [$flya8, ubs_stand ] { ai_stand(); };

void() ubs_standb1 = [$flyb1, ubs_standb2 ] { ai_stand(); };
void() ubs_standb2 = [$flyb2, ubs_standb3 ] { ai_stand(); };
void() ubs_standb3 = [$flyb3, ubs_standb4 ] { ai_stand(); };
void() ubs_standb4 = [$flyb4, ubs_standb5 ] { ai_stand(); };
void() ubs_standb5 = [$flyb5, ubs_standb6 ] { ai_stand(); };
void() ubs_standb6 = [$flyb6, ubs_standb7 ] { ai_stand(); };
void() ubs_standb7 = [$flyb7, ubs_standb8 ] { ai_stand(); };
void() ubs_standb8 = [$flyb8, ubs_stand ] { ai_stand(); };

void() ubs_standc1 = [$flyc1, ubs_standc2 ] { ai_stand(); };
void() ubs_standc2 = [$flyc2, ubs_standc3 ] { ai_stand(); };
void() ubs_standc3 = [$flyc3, ubs_standc4 ] { ai_stand(); };
void() ubs_standc4 = [$flyc4, ubs_standc5 ] { ai_stand(); };
void() ubs_standc5 = [$flyc5, ubs_standc6 ] { ai_stand(); };
void() ubs_standc6 = [$flyc6, ubs_standc7 ] { ai_stand(); };
void() ubs_standc7 = [$flyc7, ubs_standc8 ] { ai_stand(); };
void() ubs_standc8 = [$flyc8, ubs_stand ] { ai_stand(); };

void() ubs_stand = {
	if (self.health <= 500)
		ubs_standc1();
	else if (self.health <= 1000)
		ubs_standb1();
	else
		ubs_standa1();
};



void() ubs_walka1 = [$flya1, ubs_walka2 ] { ai_walk (SECRET_NO_SHOOT); ubs_idlesound(); };
void() ubs_walka2 = [$flya2, ubs_walka3 ] { ai_walk (SECRET_NO_SHOOT); };
void() ubs_walka3 = [$flya3, ubs_walka4 ] { ai_walk (SECRET_NO_SHOOT); };
void() ubs_walka4 = [$flya4, ubs_walka5 ] { ai_walk (SECRET_NO_SHOOT); };
void() ubs_walka5 = [$flya5, ubs_walka6 ] { ai_walk (SECRET_NO_SHOOT); };
void() ubs_walka6 = [$flya6, ubs_walka7 ] { ai_walk (SECRET_NO_SHOOT); };
void() ubs_walka7 = [$flya7, ubs_walka8 ] { ai_walk (SECRET_NO_SHOOT); };
void() ubs_walka8 = [$flya8, ubs_walk ] { ai_walk (SECRET_NO_SHOOT); };

void() ubs_walkb1 = [$flyb1, ubs_walkb2 ] { ai_walk (SECRET_NO_SHOOT); ubs_idlesound(); };
void() ubs_walkb2 = [$flyb2, ubs_walkb3 ] { ai_walk (SECRET_NO_SHOOT); };
void() ubs_walkb3 = [$flyb3, ubs_walkb4 ] { ai_walk (SECRET_NO_SHOOT); };
void() ubs_walkb4 = [$flyb4, ubs_walkb5 ] { ai_walk (SECRET_NO_SHOOT); };
void() ubs_walkb5 = [$flyb5, ubs_walkb6 ] { ai_walk (SECRET_NO_SHOOT); };
void() ubs_walkb6 = [$flyb6, ubs_walkb7 ] { ai_walk (SECRET_NO_SHOOT); };
void() ubs_walkb7 = [$flyb7, ubs_walkb8 ] { ai_walk (SECRET_NO_SHOOT); };
void() ubs_walkb8 = [$flyb8, ubs_walk ] { ai_walk (SECRET_NO_SHOOT); };

void() ubs_walkc1 = [$flyc1, ubs_walkc2 ] { ai_walk (SECRET_NO_SHOOT); ubs_idlesound(); };
void() ubs_walkc2 = [$flyc2, ubs_walkc3 ] { ai_walk (SECRET_NO_SHOOT); };
void() ubs_walkc3 = [$flyc3, ubs_walkc4 ] { ai_walk (SECRET_NO_SHOOT); };
void() ubs_walkc4 = [$flyc4, ubs_walkc5 ] { ai_walk (SECRET_NO_SHOOT); };
void() ubs_walkc5 = [$flyc5, ubs_walkc6 ] { ai_walk (SECRET_NO_SHOOT); };
void() ubs_walkc6 = [$flyc6, ubs_walkc7 ] { ai_walk (SECRET_NO_SHOOT); };
void() ubs_walkc7 = [$flyc7, ubs_walkc8 ] { ai_walk (SECRET_NO_SHOOT); };
void() ubs_walkc8 = [$flyc8, ubs_walk ] { ai_walk (SECRET_NO_SHOOT); };

void() ubs_walk = {
	if (self.health <= 500)
		ubs_walkc1();
	else if (self.health <= 1000)
		ubs_walkb1();
	else
		ubs_walka1();
};



void() ubs_sidea1 = [$flya1, ubs_sidea2 ] { ai_run (20); self.attack_state = AS_SLIDING; ubs_zap (500, (1 + skill)); };
void() ubs_sidea2 = [$flya2, ubs_sidea3 ] { ai_run (24); ubs_zap (500, (1 + skill)); };
void() ubs_sidea3 = [$flya3, ubs_sidea4 ] { ai_run (24); ubs_zap (500, (1 + skill)); };
void() ubs_sidea4 = [$flya4, ubs_sidea5 ] { ai_run (24); ubs_zap (500, (1 + skill)); };
void() ubs_sidea5 = [$flya5, ubs_sidea6 ] { ai_run (24); ubs_zap (500, (1 + skill)); };
void() ubs_sidea6 = [$flya6, ubs_sidea7 ] { ai_run (24); ubs_zap (500, (1 + skill)); };
void() ubs_sidea7 = [$flya7, ubs_sidea8 ] { ai_run (24); ubs_zap (500, (1 + skill)); };
void() ubs_sidea8 = [$flya8, ubs_run ] { ai_run (24); ubs_zap (500, (1 + skill)); };

void() ubs_sideb1 = [$flyb1, ubs_sideb2 ] { ai_run (20); self.attack_state = AS_SLIDING; ubs_zap (500, (1 + skill)); };
void() ubs_sideb2 = [$flyb2, ubs_sideb3 ] { ai_run (24); ubs_zap (500, (1 + skill)); };
void() ubs_sideb3 = [$flyb3, ubs_sideb4 ] { ai_run (24); ubs_zap (500, (1 + skill)); };
void() ubs_sideb4 = [$flyb4, ubs_sideb5 ] { ai_run (24); ubs_zap (500, (1 + skill)); };
void() ubs_sideb5 = [$flyb5, ubs_sideb6 ] { ai_run (24); ubs_zap (500, (1 + skill)); };
void() ubs_sideb6 = [$flyb6, ubs_sideb7 ] { ai_run (24); ubs_zap (500, (1 + skill)); };
void() ubs_sideb7 = [$flyb7, ubs_sideb8 ] { ai_run (24); ubs_zap (500, (1 + skill)); };
void() ubs_sideb8 = [$flyb8, ubs_run ] { ai_run (24); ubs_zap (500, (1 + skill)); };

void() ubs_sidec1 = [$flyc1, ubs_sidec2 ] { ai_run (20); self.attack_state = AS_SLIDING; ubs_zap (500, (1 + skill)); };
void() ubs_sidec2 = [$flyc2, ubs_sidec3 ] { ai_run (24); ubs_zap (500, (1 + skill)); };
void() ubs_sidec3 = [$flyc3, ubs_sidec4 ] { ai_run (24); ubs_zap (500, (1 + skill)); };
void() ubs_sidec4 = [$flyc4, ubs_sidec5 ] { ai_run (24); ubs_zap (500, (1 + skill)); };
void() ubs_sidec5 = [$flyc5, ubs_sidec6 ] { ai_run (24); ubs_zap (500, (1 + skill)); };
void() ubs_sidec6 = [$flyc6, ubs_sidec7 ] { ai_run (24); ubs_zap (500, (1 + skill)); };
void() ubs_sidec7 = [$flyc7, ubs_sidec8 ] { ai_run (24); ubs_zap (500, (1 + skill)); };
void() ubs_sidec8 = [$flyc8, ubs_run ] { ai_run (24); ubs_zap (500, (1 + skill)); };

void() ubs_side = {
	sound(self,CHAN_VOICE, "travail/ubs/elec.wav",1,ATTN_NORM);
	self.attack_finished = (time + 1);

	if (self.health <= 500)
		ubs_sidec1();
	else if (self.health <= 1000)
		ubs_sideb1();
	else
		ubs_sidea1();
};



void() ubs_dodgea1 = [$flya1, ubs_dodgea2 ] { ai_run (30); self.attack_state = AS_SLIDING; };
void() ubs_dodgea2 = [$flya2, ubs_dodgea3 ] { ai_run (30); };
void() ubs_dodgea3 = [$flya3, ubs_dodgea4 ] { ai_run (30); };
void() ubs_dodgea4 = [$flya4, ubs_dodgea5 ] { ai_run (30); };
void() ubs_dodgea5 = [$flya5, ubs_dodgea6 ] { ai_run (30); };
void() ubs_dodgea6 = [$flya6, ubs_dodgea7 ] { ai_run (30); };
void() ubs_dodgea7 = [$flya7, ubs_dodgea8 ] { ai_run (30); };
void() ubs_dodgea8 = [$flya8, ubs_run ] { ai_run (30); self.attack_state = AS_STRAIGHT; };

void() ubs_dodgeb1 = [$flyb1, ubs_dodgeb2 ] { ai_run (30); self.attack_state = AS_SLIDING; };
void() ubs_dodgeb2 = [$flyb2, ubs_dodgeb3 ] { ai_run (30); };
void() ubs_dodgeb3 = [$flyb3, ubs_dodgeb4 ] { ai_run (30); };
void() ubs_dodgeb4 = [$flyb4, ubs_dodgeb5 ] { ai_run (30); };
void() ubs_dodgeb5 = [$flyb5, ubs_dodgeb6 ] { ai_run (30); };
void() ubs_dodgeb6 = [$flyb6, ubs_dodgeb7 ] { ai_run (30); };
void() ubs_dodgeb7 = [$flyb7, ubs_dodgeb8 ] { ai_run (30); };
void() ubs_dodgeb8 = [$flyb8, ubs_run ] { ai_run (30); self.attack_state = AS_STRAIGHT; };

void() ubs_dodgec1 = [$flyc1, ubs_dodgec2 ] { ai_run (30); self.attack_state = AS_SLIDING; };
void() ubs_dodgec2 = [$flyc2, ubs_dodgec3 ] { ai_run (30); };
void() ubs_dodgec3 = [$flyc3, ubs_dodgec4 ] { ai_run (30); };
void() ubs_dodgec4 = [$flyc4, ubs_dodgec5 ] { ai_run (30); };
void() ubs_dodgec5 = [$flyc5, ubs_dodgec6 ] { ai_run (30); };
void() ubs_dodgec6 = [$flyc6, ubs_dodgec7 ] { ai_run (30); };
void() ubs_dodgec7 = [$flyc7, ubs_dodgec8 ] { ai_run (30); };
void() ubs_dodgec8 = [$flyc8, ubs_run ] { ai_run (30); self.attack_state = AS_STRAIGHT; };

void() ubs_dodge = {
	if (self.health <= 500)
		ubs_dodgec1();
	else if (self.health <= 1000)
		ubs_dodgeb1();
	else
		ubs_dodgea1();
};

void() ubs_runa1 = [$flya1, ubs_runa2 ] { ubs_idlesound(); ubscheckdist(); self.attack_state = AS_STRAIGHT; ai_face(); };
void() ubs_runa2 = [$flya2, ubs_runa3 ] { ubscheckdist(); ai_face(); };
void() ubs_runa3 = [$flya3, ubs_runa4 ] { ubscheckdist(); ai_face(); };
void() ubs_runa4 = [$flya4, ubs_runa5 ] { ubscheckdist(); ai_face(); };
void() ubs_runa5 = [$flya5, ubs_runa6 ] { ubscheckdist(); ai_face(); };
void() ubs_runa6 = [$flya6, ubs_runa7 ] { ubscheckdist(); ai_face(); };
void() ubs_runa7 = [$flya7, ubs_runa8 ] { ubscheckdist(); ai_face(); };
void() ubs_runa8 = [$flya8, ubs_run ] { ubscheckdist(); ai_face(); };

void() ubs_runb1 = [$flyb1, ubs_runb2 ] { ubs_idlesound(); ubscheckdist(); self.attack_state = AS_STRAIGHT; };
void() ubs_runb2 = [$flyb2, ubs_runb3 ] { ubscheckdist(); };
void() ubs_runb3 = [$flyb3, ubs_runb4 ] { ubscheckdist(); };
void() ubs_runb4 = [$flyb4, ubs_runb5 ] { ubscheckdist(); };
void() ubs_runb5 = [$flyb5, ubs_runb6 ] { ubscheckdist(); };
void() ubs_runb6 = [$flyb6, ubs_runb7 ] { ubscheckdist(); };
void() ubs_runb7 = [$flyb7, ubs_runb8 ] { ubscheckdist(); };
void() ubs_runb8 = [$flyb8, ubs_run ] { ubscheckdist(); };

void() ubs_runc1 = [$flyc1, ubs_runc2 ] { ubs_idlesound(); ubscheckdist(); self.attack_state = AS_STRAIGHT; };
void() ubs_runc2 = [$flyc2, ubs_runc3 ] { ubscheckdist(); };
void() ubs_runc3 = [$flyc3, ubs_runc4 ] { ubscheckdist(); };
void() ubs_runc4 = [$flyc4, ubs_runc5 ] { ubscheckdist(); };
void() ubs_runc5 = [$flyc5, ubs_runc6 ] { ubscheckdist(); };
void() ubs_runc6 = [$flyc6, ubs_runc7 ] { ubscheckdist(); };
void() ubs_runc7 = [$flyc7, ubs_runc8 ] { ubscheckdist(); };
void() ubs_runc8 = [$flyc8, ubs_run ]   { ubscheckdist(); };

void() ubs_run = {
	if (self.health <= 500)
		ubs_runc1();
	else if (self.health <= 1000)
		ubs_runb1();
	else
		ubs_runa1();
};

void() ubs_fasta1 = [$flinga1, ubs_fasta2 ] { ai_face(); };
void() ubs_fasta2 = [$flinga2, ubs_fasta3 ] { ai_face(); };
void() ubs_fasta3 = [$flinga3, ubs_fasta4 ] { ai_face(); };
void() ubs_fasta4 = [$flinga4, ubs_fasta5 ] { ai_face(); };
void() ubs_fasta5 = [$flinga5, ubs_fasta6 ] { ai_face(); };
void() ubs_fasta6 = [$flinga6, ubs_fasta7 ] { ai_face(); };
void() ubs_fasta7 = [$flinga7, ubs_fasta8 ] { ai_face(); ubs_shot1 (0); };
void() ubs_fasta8 = [$flinga8, ubs_fasta9 ] {};
void() ubs_fasta9 = [$flinga9, ubs_fasta10 ] { ubscheckdist(); };
void() ubs_fasta10 = [$flinga10, ubs_fasta11 ] { ubscheckdist(); };
void() ubs_fasta11 = [$flinga11, ubs_fasta12 ] { ubscheckdist(); };
void() ubs_fasta12 = [$flinga12, ubs_fasta13 ] { ubscheckdist(); };
void() ubs_fasta13 = [$flinga13, ubs_fasta14 ] { ubscheckdist(); };
void() ubs_fasta14 = [$flinga14, ubs_run ] { SUB_AttackFinished (1); };

void() ubs_fastb1 = [$flingb1, ubs_fastb2 ] { ai_face(); };
void() ubs_fastb2 = [$flingb2, ubs_fastb3 ] { ai_face(); };
void() ubs_fastb3 = [$flingb3, ubs_fastb4 ] { ai_face(); };
void() ubs_fastb4 = [$flingb4, ubs_fastb5 ] { ai_face(); };
void() ubs_fastb5 = [$flingb5, ubs_fastb6 ] { ai_face(); };
void() ubs_fastb6 = [$flingb6, ubs_fastb7 ] { ai_face(); };
void() ubs_fastb7 = [$flingb7, ubs_fastb8 ] { ai_face(); ubs_shot1 (0); };
void() ubs_fastb8 = [$flingb8, ubs_fastb9 ] {};
void() ubs_fastb9 = [$flingb9, ubs_fastb10 ] { ubscheckdist(); };
void() ubs_fastb10 = [$flingb10, ubs_fastb11 ] { ubscheckdist(); };
void() ubs_fastb11 = [$flingb11, ubs_fastb12 ] { ubscheckdist(); };
void() ubs_fastb12 = [$flingb12, ubs_fastb13 ] { ubscheckdist(); };
void() ubs_fastb13 = [$flingb13, ubs_fastb14 ] { ubscheckdist(); };
void() ubs_fastb14 = [$flingb14, ubs_run ] { SUB_AttackFinished (1); };

void() ubs_fastc1 = [$flingc1, ubs_fastc2 ] { ai_face(); };
void() ubs_fastc2 = [$flingc2, ubs_fastc3 ] { ai_face(); };
void() ubs_fastc3 = [$flingc3, ubs_fastc4 ] { ai_face(); };
void() ubs_fastc4 = [$flingc4, ubs_fastc5 ] { ai_face(); };
void() ubs_fastc5 = [$flingc5, ubs_fastc6 ] { ai_face(); };
void() ubs_fastc6 = [$flingc6, ubs_fastc7 ] { ai_face(); };
void() ubs_fastc7 = [$flingc7, ubs_fastc8 ] { ai_face(); ubs_shot1 (0); };
void() ubs_fastc8 = [$flingc8, ubs_fastc9 ] {};
void() ubs_fastc9 = [$flingc9, ubs_fastc10 ] { ubscheckdist(); };
void() ubs_fastc10 = [$flingc10, ubs_fastc11 ] { ubscheckdist(); };
void() ubs_fastc11 = [$flingc11, ubs_fastc12 ] { ubscheckdist(); };
void() ubs_fastc12 = [$flingc12, ubs_fastc13 ] { ubscheckdist(); };
void() ubs_fastc13 = [$flingc13, ubs_fastc14 ] { ubscheckdist(); };
void() ubs_fastc14 = [$flingc14, ubs_run ] { SUB_AttackFinished (1); };

void() ubs_fast = {
	if (self.health <= 500)
		ubs_fastc1();
	else if (self.health <= 1000)
		ubs_fastb1();
	else
		ubs_fasta1();
};

void() ubs_makewiza1 = [$flinga1, ubs_makewiza2 ] {
	Tent_LavaSplash(self.origin,-32,"travail/ubs/spawnst.wav");
};
void() ubs_makewiza2 = [$flinga2, ubs_makewiza3 ] {};
void() ubs_makewiza3 = [$flinga3, ubs_makewiza4 ] {};
void() ubs_makewiza4 = [$flinga4, ubs_makewiza5 ] {};
void() ubs_makewiza5 = [$flinga5, ubs_makewiza6 ] {};
void() ubs_makewiza6 = [$flinga6, ubs_makewiza7 ] {};
void() ubs_makewiza7 = [$flinga7, ubs_makewiza8 ] { ubs_shot2(); };
void() ubs_makewiza8 = [$flinga8, ubs_makewiza9 ] {};
void() ubs_makewiza9 = [$flinga9, ubs_makewiza10 ] {};
void() ubs_makewiza10 = [$flinga10, ubs_makewiza11 ] {};
void() ubs_makewiza11 = [$flinga11, ubs_makewiza12 ] {};
void() ubs_makewiza12 = [$flinga12, ubs_makewiza13 ] {};
void() ubs_makewiza13 = [$flinga13, ubs_makewiza14 ] {};
void() ubs_makewiza14 = [$flinga14, ubs_run ] { ubscheckdist(); SUB_AttackFinished (2); ubsAttackFinished(); };

void() ubs_makewizb1 = [$flingb1, ubs_makewizb2 ] {
	Tent_LavaSplash(self.origin,-32,"travail/ubs/spawnst.wav");
};
void() ubs_makewizb2 = [$flingb2, ubs_makewizb3 ] {};
void() ubs_makewizb3 = [$flingb3, ubs_makewizb4 ] {};
void() ubs_makewizb4 = [$flingb4, ubs_makewizb5 ] {};
void() ubs_makewizb5 = [$flingb5, ubs_makewizb6 ] {};
void() ubs_makewizb6 = [$flingb6, ubs_makewizb7 ] {};
void() ubs_makewizb7 = [$flingb7, ubs_makewizb8 ] { ubs_shot2(); };
void() ubs_makewizb8 = [$flingb8, ubs_makewizb9 ] {};
void() ubs_makewizb9 = [$flingb9, ubs_makewizb10 ] {};
void() ubs_makewizb10 = [$flingb10, ubs_makewizb11 ] {};
void() ubs_makewizb11 = [$flingb11, ubs_makewizb12 ] {};
void() ubs_makewizb12 = [$flingb12, ubs_makewizb13 ] {};
void() ubs_makewizb13 = [$flingb13, ubs_makewizb14 ] {};
void() ubs_makewizb14 = [$flingb14, ubs_run ] { ubscheckdist(); SUB_AttackFinished (SPAWNFLAG_LASER); ubsAttackFinished(); };

void() ubs_makewizc1 = [$flingc1, ubs_makewizc2 ] {
	Tent_LavaSplash(self.origin,-32,"travail/ubs/spawnst.wav");
};
void() ubs_makewizc2 = [$flingc2, ubs_makewizc3 ] {};
void() ubs_makewizc3 = [$flingc3, ubs_makewizc4 ] {};
void() ubs_makewizc4 = [$flingc4, ubs_makewizc5 ] {};
void() ubs_makewizc5 = [$flingc5, ubs_makewizc6 ] {};
void() ubs_makewizc6 = [$flingc6, ubs_makewizc7 ] {};
void() ubs_makewizc7 = [$flingc7, ubs_makewizc8 ] { ubs_shot2(); };
void() ubs_makewizc8 = [$flingc8, ubs_makewizc9 ] {};
void() ubs_makewizc9 = [$flingc9, ubs_makewizc10 ] {};
void() ubs_makewizc10 = [$flingc10, ubs_makewizc11 ] {};
void() ubs_makewizc11 = [$flingc11, ubs_makewizc12 ] {};
void() ubs_makewizc12 = [$flingc12, ubs_makewizc13 ] {};
void() ubs_makewizc13 = [$flingc13, ubs_makewizc14 ] {};
void() ubs_makewizc14 = [$flingc14, ubs_run ] { ubscheckdist(); SUB_AttackFinished (2); ubsAttackFinished(); };

void() ubs_makewiz = {
	if (self.health <= 500)
		ubs_makewizc1();
	else if (self.health <= 1000)
		ubs_makewizb1();
	else
		ubs_makewiza1();
};

void() ubs_spreada1 = [$figeighta1, ubs_spreada2 ] { ai_face(); };
void() ubs_spreada2 = [$figeighta2, ubs_spreada3 ] { ai_face(); };
void() ubs_spreada3 = [$figeighta3, ubs_spreada4 ] { ai_face(); };
void() ubs_spreada4 = [$figeighta4, ubs_spreada5 ] { ai_face(); };
void() ubs_spreada5 = [$figeighta5, ubs_spreada6 ] { ai_face(); };
void() ubs_spreada6 = [$figeighta6, ubs_spreada7 ] { ai_face(); ubs_spread (1); };
void() ubs_spreada7 = [$figeighta7, ubs_spreada8 ] { ai_face(); ubs_spread (0); };
void() ubs_spreada8 = [$figeighta8, ubs_spreada9 ] { ai_face(); ubs_spread (0); };
void() ubs_spreada9 = [$figeighta9, ubs_spreada10 ] { ai_face(); ubs_spread (0); };
void() ubs_spreada10 = [$figeighta10, ubs_spreada11 ] { ai_face(); ubs_spread (0); };
void() ubs_spreada11 = [$figeighta11, ubs_spreada12 ] { ai_face(); };
void() ubs_spreada12 = [$figeighta12, ubs_spreada13 ] { ai_face(); ubs_spread (1); };
void() ubs_spreada13 = [$figeighta13, ubs_spreada14 ] { ai_face(); ubs_spread (0); };
void() ubs_spreada14 = [$figeighta14, ubs_spreada15 ] { ai_face(); ubs_spread (0); };
void() ubs_spreada15 = [$figeighta15, ubs_spreada16 ] { ai_face(); ubs_spread (0); };
void() ubs_spreada16 = [$figeighta16, ubs_spreada17 ] { ai_face(); ubs_spread (0); };
void() ubs_spreada17 = [$figeighta17, ubs_spreada18 ] { ai_face(); };
void() ubs_spreada18 = [$figeighta18, ubs_spreada19 ] { ai_face(); };
void() ubs_spreada19 = [$figeighta19, ubs_spreada20 ] { ai_face(); };
void() ubs_spreada20 = [$figeighta20, ubs_spreada21 ] { ai_face(); };
void() ubs_spreada21 = [$figeighta21, ubs_spreada22 ] { ai_face(); };
void() ubs_spreada22 = [$figeighta22, ubs_spreada23 ] { ai_face(); };
void() ubs_spreada23 = [$figeighta23, ubs_spreada24 ] { ai_face(); };
void() ubs_spreada24 = [$figeighta24, ubs_run ] { ubscheckdist(); SUB_AttackFinished (2); ubsAttackFinished(); };

void() ubs_spreadb1 = [$figeightb1, ubs_spreadb2 ] { ai_face(); };
void() ubs_spreadb2 = [$figeightb2, ubs_spreadb3 ] { ai_face(); };
void() ubs_spreadb3 = [$figeightb3, ubs_spreadb4 ] { ai_face(); };
void() ubs_spreadb4 = [$figeightb4, ubs_spreadb5 ] { ai_face(); };
void() ubs_spreadb5 = [$figeightb5, ubs_spreadb6 ] { ai_face(); };
void() ubs_spreadb6 = [$figeightb6, ubs_spreadb7 ] { ai_face(); ubs_spread (1); };
void() ubs_spreadb7 = [$figeightb7, ubs_spreadb8 ] { ai_face(); ubs_spread (0); };
void() ubs_spreadb8 = [$figeightb8, ubs_spreadb9 ] { ai_face(); ubs_spread (0); };
void() ubs_spreadb9 = [$figeightb9, ubs_spreadb10 ] { ai_face(); ubs_spread (0); };
void() ubs_spreadb10 = [$figeightb10, ubs_spreadb11 ] { ai_face(); ubs_spread (0); };
void() ubs_spreadb11 = [$figeightb11, ubs_spreadb12 ] { ai_face(); };
void() ubs_spreadb12 = [$figeightb12, ubs_spreadb13 ] { ai_face(); ubs_spread (1); };
void() ubs_spreadb13 = [$figeightb13, ubs_spreadb14 ] { ai_face(); ubs_spread (0); };
void() ubs_spreadb14 = [$figeightb14, ubs_spreadb15 ] { ai_face(); ubs_spread (0); };
void() ubs_spreadb15 = [$figeightb15, ubs_spreadb16 ] { ai_face(); ubs_spread (0); };
void() ubs_spreadb16 = [$figeightb16, ubs_spreadb17 ] { ai_face(); ubs_spread (0); };
void() ubs_spreadb17 = [$figeightb17, ubs_spreadb18 ] { ai_face(); };
void() ubs_spreadb18 = [$figeightb18, ubs_spreadb19 ] { ai_face(); };
void() ubs_spreadb19 = [$figeightb19, ubs_spreadb20 ] { ai_face(); };
void() ubs_spreadb20 = [$figeightb20, ubs_spreadb21 ] { ai_face(); };
void() ubs_spreadb21 = [$figeightb21, ubs_spreadb22 ] { ai_face(); };
void() ubs_spreadb22 = [$figeightb22, ubs_spreadb23 ] { ai_face(); };
void() ubs_spreadb23 = [$figeightb23, ubs_spreadb24 ] { ai_face(); };
void() ubs_spreadb24 = [$figeightb24, ubs_run ] { ubscheckdist(); SUB_AttackFinished (2); ubsAttackFinished(); };

void() ubs_spreadc1 = [$figeightc1, ubs_spreadc2 ] { ai_face(); };
void() ubs_spreadc2 = [$figeightc2, ubs_spreadc3 ] { ai_face(); };
void() ubs_spreadc3 = [$figeightc3, ubs_spreadc4 ] { ai_face(); };
void() ubs_spreadc4 = [$figeightc4, ubs_spreadc5 ] { ai_face(); };
void() ubs_spreadc5 = [$figeightc5, ubs_spreadc6 ] { ai_face(); };
void() ubs_spreadc6 = [$figeightc6, ubs_spreadc7 ] { ai_face(); ubs_spread (1); };
void() ubs_spreadc7 = [$figeightc7, ubs_spreadc8 ] { ai_face(); ubs_spread (0); };
void() ubs_spreadc8 = [$figeightc8, ubs_spreadc9 ] { ai_face(); ubs_spread (0); };
void() ubs_spreadc9 = [$figeightc9, ubs_spreadc10 ] { ai_face(); ubs_spread (0); };
void() ubs_spreadc10 = [$figeightc10, ubs_spreadc11 ] { ai_face(); ubs_spread (0); };
void() ubs_spreadc11 = [$figeightc11, ubs_spreadc12 ] { ai_face(); };
void() ubs_spreadc12 = [$figeightc12, ubs_spreadc13 ] { ai_face(); ubs_spread (1); };
void() ubs_spreadc13 = [$figeightc13, ubs_spreadc14 ] { ai_face(); ubs_spread (0); };
void() ubs_spreadc14 = [$figeightc14, ubs_spreadc15 ] { ai_face(); ubs_spread (0); };
void() ubs_spreadc15 = [$figeightc15, ubs_spreadc16 ] { ai_face(); ubs_spread (0); };
void() ubs_spreadc16 = [$figeightc16, ubs_spreadc17 ] { ai_face(); ubs_spread (0); };
void() ubs_spreadc17 = [$figeightc17, ubs_spreadc18 ] { ai_face(); };
void() ubs_spreadc18 = [$figeightc18, ubs_spreadc19 ] { ai_face(); };
void() ubs_spreadc19 = [$figeightc19, ubs_spreadc20 ] { ai_face(); };
void() ubs_spreadc20 = [$figeightc20, ubs_spreadc21 ] { ai_face(); };
void() ubs_spreadc21 = [$figeightc21, ubs_spreadc22 ] { ai_face(); };
void() ubs_spreadc22 = [$figeightc22, ubs_spreadc23 ] { ai_face(); };
void() ubs_spreadc23 = [$figeightc23, ubs_spreadc24 ] { ai_face(); };
void() ubs_spreadc24 = [$figeightc24, ubs_run ] { ubscheckdist(); SUB_AttackFinished (2); ubsAttackFinished(); };

void() ubs_spreadx = {
	if (self.health <= 500)
		ubs_spreadc1();
	else if (self.health <= 1000)
		ubs_spreadb1();
	else
		ubs_spreada1();
};



void() ubs_paina1 = [$paina1, ubs_paina2 ] { ubscheckdist(); self.attack_state = AS_STRAIGHT; };
void() ubs_paina2 = [$paina2, ubs_paina3 ] { ubscheckdist(); };
void() ubs_paina3 = [$paina3, ubs_paina4 ] { ubscheckdist(); };
void() ubs_paina4 = [$paina4, ubs_paina5 ] { ubscheckdist(); };
void() ubs_paina5 = [$paina5, ubs_paina6 ] { ubscheckdist(); };
void() ubs_paina6 = [$paina6, ubs_paina7 ] { ubscheckdist(); };
void() ubs_paina7 = [$paina7, ubs_run ] { ubscheckdist(); };

void() ubs_painb1 = [$painb1, ubs_painb2 ] { ubscheckdist(); self.attack_state = AS_STRAIGHT; };
void() ubs_painb2 = [$painb2, ubs_painb3 ] { ubscheckdist(); };
void() ubs_painb3 = [$painb3, ubs_painb4 ] { ubscheckdist(); };
void() ubs_painb4 = [$painb4, ubs_painb5 ] { ubscheckdist(); };
void() ubs_painb5 = [$painb5, ubs_painb6 ] { ubscheckdist(); };
void() ubs_painb6 = [$painb6, ubs_painb7 ] { ubscheckdist(); };
void() ubs_painb7 = [$painb7, ubs_run ] { ubscheckdist(); };

void() ubs_painc1 = [$painc1, ubs_painc2 ] { ubscheckdist(); self.attack_state = AS_STRAIGHT; };
void() ubs_painc2 = [$painc2, ubs_painc3 ] { ubscheckdist(); };
void() ubs_painc3 = [$painc3, ubs_painc4 ] { ubscheckdist(); };
void() ubs_painc4 = [$painc4, ubs_painc5 ] { ubscheckdist(); };
void() ubs_painc5 = [$painc5, ubs_painc6 ] { ubscheckdist(); };
void() ubs_painc6 = [$painc6, ubs_painc7 ] { ubscheckdist(); };
void() ubs_painc7 = [$painc7, ubs_run ] { ubscheckdist(); };

void() Suckup_Think = {
	local	entity	head;

	self.movetype = MOVETYPE_NOCLIP;
	self.solid = SOLID_NOT;
	self.velocity = 3 * (self.owner.origin - self.origin);
	head = findradius(self.origin, 32);
	if (head == self.owner || !self.owner.model) {
		spawn_tfog (self.origin);
		remove(self);
		return;
	}

	self.think = Suckup_Think;
	self.nextthink = time + 0.1;
};

void(string gibname, float dm, vector gibpos) ThrowUBSGib = {
	local	entity new;

	new = spawn();
	new.owner = self;
	new.origin = gibpos;
	setmodel(new, gibname);
	setsize (new, '0 0 0', '0 0 0');
	new.velocity = VelocityForDamage (dm);
	new.movetype = MOVETYPE_BOUNCE;
	new.solid = SOLID_NOT;
	new.avelocity_x = random()*600;
	new.avelocity_y = random()*600;
	new.avelocity_z = random()*600;
	new.think = Suckup_Think;
	new.ltime = time;
	new.nextthink = time + 1 + random()*2;
	new.frame = 0;
	new.flags = 0;
};

void() ubs_dieend1 = [$dieend1, ubs_dieend2 ] { sound(self,CHAN_VOICE, "travail/ubs/wdeath2.wav",1,ATTN_NONE); };
void() ubs_dieend2 = [$dieend2, ubs_dieend3 ] {};
void() ubs_dieend3 = [$dieend3, ubs_dieend4 ] {};
void() ubs_dieend4 = [$dieend4, ubs_dieend5 ] {};
void() ubs_dieend5 = [$dieend5, ubs_dieend6 ] {};
void() ubs_dieend6 = [$dieend6, ubs_dieend7 ] {};
void() ubs_dieend7 = [$dieend7, ubs_dieend8 ] {};
void() ubs_dieend8 = [$dieend8, ubs_dieend9 ] {};
void() ubs_dieend9 = [$dieend9, ubs_dieend10 ] {};
void() ubs_dieend10 = [$dieend10, ubs_dieend11 ] {};
void() ubs_dieend11 = [$dieend11, ubs_dieend12 ] {};
void() ubs_dieend12 = [$dieend11, ubs_dieend13 ] {
	setorigin(self,self.origin);
	spawn_tfog(self.origin);
	monster_death_postcheck(); 
};
void() ubs_dieend13 = [$dieend11, ubs_dieend13 ] { monster_deadbody_check(); };

void() ubs_killdie = {
	local entity wizkill;

	wizkill = nextent(world);
	while (wizkill != world) {
		if (wizkill.classtype == CT_MONWIZARD) {
			spawn_tfog (self.origin);
			spawn_tfog (wizkill.origin);
			Tent_Beam(TE_LIGHTNING2,self,self.origin,wizkill.origin);
			sound(wizkill,CHAN_VOICE,"player/udeath.wav",1,ATTN_NORM);
			T_Damage(wizkill,self,self,wizkill.health - wizkill.gibhealth + 1,NOARMOR);
		}
		wizkill = nextent(wizkill);
	}
	monster_death_precheck(); // Pre-check routine to tidy up extra entities.
	ubs_dieend1();
};

void() ubs_death1 = [$dieloop1, ubs_death2 ] { sound(self,CHAN_VOICE, "travail/ubs/wdeath1.wav",1,ATTN_NONE); };
void() ubs_death2 = [$dieloop2, ubs_death3 ] {};
void() ubs_death3 = [$dieloop3, ubs_death4 ] {};
void() ubs_death4 = [$dieloop4, ubs_death5 ] {};
void() ubs_death5 = [$dieloop5, ubs_death6 ] {};
void() ubs_death6 = [$dieloop6, ubs_death7 ] {};
void() ubs_death7 = [$dieloop7, ubs_death8 ] {};
void() ubs_death8 = [$dieloop8, ubs_death9 ] {};
void() ubs_death9 = [$dieloop9, ubs_death10 ] {};
void() ubs_death10 = [$dieloop10, ubs_death11 ] {};
void() ubs_death11 = [$dieloop11, ubs_death12 ] { ubs_killdie(); };
void() ubs_death12 = [$dieloop12, ubs_death13 ] {};
void() ubs_death13 = [$dieloop13, ubs_death14 ] {};
void() ubs_death14 = [$dieloop14, ubs_death15 ] {};
void() ubs_death15 = [$dieloop15, ubs_death16 ] {};
void() ubs_death16 = [$dieloop16, ubs_death17 ] {};
void() ubs_death17 = [$dieloop17, ubs_death18 ] {};
void() ubs_death18 = [$dieloop18, ubs_death19 ] {};
void() ubs_death19 = [$dieloop19, ubs_death20 ] {};
void() ubs_death20 = [$dieloop20, ubs_death21 ] {};
void() ubs_death21 = [$dieloop21, ubs_death22 ] {};
void() ubs_death22 = [$dieloop22, ubs_death23 ] {};
void() ubs_death23 = [$dieloop23, ubs_death1 ] { ubs_killdie(); };

void() ubs_die = {
	self.movetype = MOVETYPE_FLY;
	self.velocity = '0 0 0';
	setsize (self, '-16 -16 -16', '16 16 16');
	ubs_death1();
};



void() flap_land1 = [ 18, flap_land2 ] {};
void() flap_land2 = [ 19, flap_land3 ] {};
void() flap_land3 = [ 20, flap_land4 ] {};
void() flap_land4 = [ 21, flap_land5 ] {};
void() flap_land5 = [ 22, flap_land6 ] {};
void() flap_land6 = [ 23, flap_land6 ] { self.nextthink = time + 10 + random()*10; self.think = SUB_Remove; };

void() Flap_Think = {
	if (self.velocity == '0 0 0') flap_land1();
};

void() flap_drop1 = [ 0, flap_drop2 ] { flap_Think(); };
void() flap_drop2 = [ 1, flap_drop3 ] { flap_Think(); };
void() flap_drop3 = [ 2, flap_drop4 ] { flap_Think(); };
void() flap_drop4 = [ 3, flap_drop5 ] { flap_Think(); };
void() flap_drop5 = [ 4, flap_drop6 ] { flap_Think(); };
void() flap_drop6 = [ 5, flap_drop7 ] { flap_Think(); };
void() flap_drop7 = [ 6, flap_drop8 ] { flap_Think(); };
void() flap_drop8 = [ 7, flap_drop9 ] { flap_Think(); };
void() flap_drop9 = [ 8, flap_drop10 ] { flap_Think(); };
void() flap_drop10 = [ 9, flap_float1 ] { flap_Think(); };

void() flap_float1 = [ 10, flap_float2 ] { flap_Think(); };
void() flap_float2 = [ 11, flap_float3 ] { flap_Think(); };
void() flap_float3 = [ 12, flap_float4 ] { flap_Think(); };
void() flap_float4 = [ 13, flap_float5 ] { flap_Think(); };
void() flap_float5 = [ 14, flap_float6 ] { flap_Think(); };
void() flap_float6 = [ 15, flap_float7 ] { flap_Think(); };
void() flap_float7 = [ 16, flap_float8 ] { flap_Think(); };
void() flap_float8 = [ 17, flap_float1 ] { flap_Think(); };

void() Toss_Flap = {
	local entity new;

	self.ubs_deflapped = 1;
	new = spawn();
	new.origin = self.origin + v_forward*32;
	setmodel(new, "progs/travail/uberskinflap.mdl");
	setsize (new, '0 0 0', '0 0 0');
	new.velocity_x = -200 + 400*random();
	new.velocity_y = -200 + 400*random();
	new.velocity_z = 100 + 100*random();
	new.movetype = MOVETYPE_TOSS;
	new.solid = SOLID_NOT;
	new.think = flap_drop1;
	new.nextthink = time + 0.01;
	new.frame = 0;
	new.flags = 0;
};

void(entity inflictor, entity attacker, float damage) ubs_Pain = {
	if (self.health <= 500) {
		if (self.ubs_deflapped != 1) {
			Toss_Flap();
			sound(self,CHAN_VOICE, "travail/ubs/wpain.wav",1,ATTN_NONE);
			ubs_painc1();
			self.pain_finished = time + 2;
		}
	}

	if (self.pain_finished > time)
		return;

	self.pain_finished = time + 2;

	sound(self,CHAN_VOICE, "travail/ubs/wpain.wav",1,ATTN_NONE);

	if (((random () * 70) > damage)) return;
	if (self.health <= 500)
		ubs_painc1();
	else if (self.health <= 1000)
		ubs_painb1();
	else
		ubs_paina1();
};

void() ubs_Missile = {
	local vector dir, vtemp, dist;
	local float d, rndl;
	local entity head;

	dist = (self.enemy.origin - self.origin);
        dist_z = 0; // Damage? Huh?
	rnd1 = random();
	d = vlen (dist);
	if (((((d >= 200) && (d < 500)) && (rnd1 < 0.4)) && (self.attack_finished < time))) {
		self.attack_finished = (time + 0.4);
		if (self.health <= 500)
			ubs_spreadc1();
		else if (self.health <= 1000)
			ubs_spreadb1();
		else
			ubs_spreada1();
	} else if ((((d > 400) && (self.attack_finished < time)) && (rnd1 < 0.4))) {
		self.attack_finished = (time + 1);
		if (self.health <= 500)
			ubs_fastc1();
		else if (self.health <= 1000)
			ubs_fastb1();
		else
			ubs_fasta1();
	}
	else if (((((d > 400) && (self.attack_finished < time)) && (rnd1 >= 0.4)) && (self.ident >= SECRET_1ST_DOWN)))
	{
		self.attack_finished = (time + 1);
		if (self.health <= 500)
			ubs_fastc1();
		else if (self.health <= 1000)
			ubs_fastb1();
		else
			ubs_fasta1();
	} else if ((((d > 400) && (rnd1 >= 0.4)) && (self.ident < SECRET_1ST_DOWN))) {
		self.attack_finished = (time + 1);
		if (self.health <= 500)
			ubs_makewizc1();
		else if (self.health <= 1000)
			ubs_makewizb1();
		else
			ubs_makewiza1();
	} else {
		return;

	}
};

void() ubs_awake = {
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/travail/uberscrag.mdl");
	setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
	if (self.health <= 0) self.health = 2500 + skill*500;
	self.gibhealth = MON_NEVERGIB;
	self.th_stand = ubs_stand;
	self.th_walk = ubs_walk;
	self.th_run = ubs_run;
	self.th_missile = ubs_Missile;
	self.th_pain = ubs_Pain;
	self.th_die = ubs_die;
	self.yaw_speed = 25;
	self.enemy = activator;
	spawn_tfog (self.origin);
	ubs_unfurl1();
};

void() monster_ubs_precache = {
	precache_model ("progs/travail/uberscrag.mdl");
	precache_model ("progs/travail/uberskinflap.mdl");
	precache_model ("progs/w_spike.mdl");
	precache_model ("progs/v_spike.mdl");
	monster_wizard_precache();
	precache_model ("progs/w_spike.mdl");
	precache_model ("progs/travail/utele.mdl");
	precache_sound("travail/ubs/hit.wav");
	precache_sound("travail/ubs/attack1.wav");
	precache_sound("travail/ubs/wdeath1.wav");
	precache_sound("travail/ubs/wdeath2.wav");
	precache_sound("travail/ubs/widle1.wav");
	precache_sound("travail/ubs/widle2.wav");
	precache_sound("travail/ubs/wpain.wav");
	precache_sound("travail/ubs/wsight.wav");
	precache_sound("travail/ubs/elec.wav");
	precache_sound("travail/ubs/spawnfr.wav");
	precache_sound("travail/ubs/spawnst.wav");
	precache_sound("wizard/hit.wav");
	precache_sound("wizard/wattack.wav");
	precache_sound("wizard/wdeath.wav");
	precache_sound("wizard/widle1.wav");
	precache_sound("wizard/widle2.wav");
	precache_sound("wizard/wsight.wav");
	precache_sound("wizard/wpain.wav");
	precache_sound("shalrath/attack2.wav");
};

void() monster_ubs = {
	if (monster_checkspawn() == TRUE) return; // Check all spawn exceptions (monsters.qc)

	self.mdl = ("progs/travail/uberscrag.mdl");
	if (self.deathstring == "") self.deathstring = " was splayed by the Uber Scrag\n";
	Resist_ChangeType(self,-1);
	self.touch = monster_touch;	// 1998-09-16 Sliding/not-jumping on monsters/boxes/players fix by Maddes/Kryten
	self.th_stand = self.th_walk = self.th_run = SUB_Null;
	self.th_missile = self.th_die = SUB_Null;
	self.th_pain = SUB_Null_pain;
	monster_start();
	if (self.targetname == "") ubs_awake();
	else self.use = ubs_awake;
};

void() spawnwiz = {
	local entity newwiz;
	local vector tempvec;

	self.touch = SUB_Null;
	self.think = SUB_Null;
	if ((pointcontents (self.origin) == CONTENT_EMPTY)) {
		if (other == self.owner) {
			self.think = ubshome2;
			self.nextthink = (time + 0.1);
			return;
		}
		self.owner.ident = (self.owner.ident + 1);
		BeMonsterFromString("monster_wizard");
	}
};
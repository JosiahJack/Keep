//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by W. Josiah Jack, aka Qmaster
//
// Attributions: Quoth, Kell
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
// Function count: 116
//
// Implements: Vermis
//
// Description:
// Absolutetly massive, yet stationary worm boss that flings exloding purple
// blobs, can bite and pick you up and hurl you.  Can start hidden and burst
// from its hole that it lives in.  When it dies it retracts back whence it
// came.
//=============================================================================

void() vermis_start_go = {
	if (!(self.spawnflags & 64)) self.origin_z = self.origin_z + 1;
	self.takedamage = DAMAGE_AIM;
	self.ideal_yaw = self.angles * '0 1 0';
	if (!(self.yaw_speed)) self.yaw_speed = 15;
	self.view_ofs = '0 0 25';
	self.use = monster_use;
	self.flags = self.flags | FL_MONSTER;
	self.flags = self.flags | FL_FLY;
	self.pausetime = 100000000;
	self.th_stand();
	self.nextthink = self.nextthink + random() * 0.5;
	if ((self.spawnflags & 64) && (self.spawnflags & 128)) {
		if ((activator.flags & FL_CLIENT)) {
			if(!Invisible(activator)) {
				self.enemy = activator;
				self.nextthink = time + 0.1;
				self.think = FoundTarget;
				return;
			}
		}
	}
	if (self.awake == 1 && self.enemy.flags & FL_CLIENT) {
		if (!Invisible(self.enemy)) {
			self.nextthink = time + 0.1;
			self.think = FoundTarget;
			return;
		}
	}
	self.think = self.th_stand;
	self.nextthink = time + 0.1;
};

void() vermis_start = {
	if (!(self.spawnflags & 64)) {
		self.nextthink = self.nextthink + random() * 0.5;
		self.think = vermis_start_go;
	} else {
		vermis_start_go();
	}
};

void() vermis_touch = {
	if (other.flags & FL_CLIENT && Align_Opposing(self,other)) {
		T_Damage(other,self,self,3 + (2 * random()),DAMARMOR);
		self.touch = SUB_Null;
	}
};

void() vermis_coil1 = [2, vermis_coil1] { self.height = 8; };

void() vermis_idle2 = {
	self.nextthink = time + 0.1;
	self.think = vermis_idle2;
	SUB_ReverseFrame(53,71);
	if (self.frame == 53) { vermis_idle1(); return; }

	ai_stand();
};

void() vermis_idle1 = {
	self.nextthink = time + 0.1;
	self.think = vermis_idle1;
	SUB_AdvanceFrame(52,71);
	if (self.frame == 71) { vermis_idle2(); return; }

	ai_stand();
};

void() vermis_run1 = {
	self.nextthink = time + 0.1;
	self.think = vermis_run1;
	SUB_AdvanceFrame(92,121);
	ai_vermis_run();
};

void() vermis_wake_things = {
	self.spawnmaxs_z = self.spawnmaxs_z + self.height;
	setsize(self, '-64 -64 -512', self.spawnmaxs);
	self.touch = vermis_touch;
};

void() vermis_wake1 = {
	self.nextthink = time + 0.1;
	self.think = vermis_wake1;
	SUB_AdvanceFrame(2,51);
	if (self.frame < 50) ai_shotcheck();
	if (self.frame == 2) {
		self.spawnmaxs = '64 64 -64';
		setsize(self, '-64 -64 -512', self.spawnmaxs);
		self.touch = vermis_touch;
	} else if (self.frame == 3) {
		vermis_wake_things();
		self.coiled = 0;
	} else if (self.frame < 37) vermis_wake_things();
	else if (self.frame == 50) self.th_stand = vermis_idle1; 
	else if (self.frame == 51) {
		ai_shotcheck();
		self.touch = SUB_Null; 
		self.think = vermis_run1;
	}
};

void() vermis_trans2 = {
	self.nextthink = time + 0.1;
	self.think = vermis_trans2;
	SUB_AdvanceFrame(22,51);
	ai_shotcheck();
	if (self.frame == 50) self.th_stand = vermis_idle1;
	else if (self.frame > 50) vermis_run1();
};

void() vermis_trans1 = {
	self.nextthink = time + 0.1;
	self.think = vermis_trans1;
	SUB_AdvanceFrame(212,216);
	ai_shotcheck();
	if (self.frame == 216) vermis_trans2();
};

void(vector offset) vermis_shoot = {
	local entity missile;
	local vector org, vec, enemorg;
	local float t, dist, numspores;

	if (visible(self.enemy))
		dist = vlen(self.enemy.origin - self.origin);
	else
		dist = vlen(self.oldenemyorigin - self.origin);

	numspores = 1;
	if (dist < 450) numspores = 5;
	else if (dist < 800) numspores = 8;
	else numspores = 13;

	self.effects = self.effects | EF_MUZZLEFLASH;
	makevectors(self.angles);
	org = self.origin + v_right * offset_x + v_forward * offset_y + v_up * offset_z;
	enemy_vis = visible(self.enemy);
	enemorg = SUB_orgEnemyTarget();
	if (enemy_vis) {
		t = vlen(enemorg - org) / 1800;
		vec = self.enemy.velocity;
		vec_z = 0;
		vec = normalize(enemorg + t * vec - org);
	} else {
		enemorg = self.oldenemyorigin;
		vec = normalize(enemorg - org);
	}
	vec = vec * 600 + (400 * random() - 200) * v_right + (300 * random() - 150) * v_up;
	while (numspores > 0) {
		Launch_VermisSpore(vec,org);
		numspores = numspores - 1;
	}
};

void() vermis_shoot1 = [122, vermis_shoot2] {
	ai_shotcheck();
	sound(self,CHAN_WEAPON,"quoth/vermis/spore.wav", 1, 0.5);
};
void() vermis_shoot2 = [123, vermis_shoot3] { ai_shotcheck(); };
void() vermis_shoot3 = [124, vermis_shoot4] { ai_shotcheck(); };
void() vermis_shoot4 = [125, vermis_shoot5] { ai_shotcheck(); };
void() vermis_shoot5 = [126, vermis_shoot6] { ai_shotcheck(); };
void() vermis_shoot6 = [127, vermis_shoot7] { ai_shotcheck(); };
void() vermis_shoot7 = [128, vermis_shoot8] { ai_shotcheck(); };
void() vermis_shoot8 = [129, vermis_shoot9] { ai_shotcheck(); };
void() vermis_shoot9 = [130, vermis_shoot10] { ai_shotcheck(); };
void() vermis_shoot10 = [131, vermis_shoot11] { ai_shotcheck(); vermis_shoot('0 209 73'); };
void() vermis_shoot11 = [132, vermis_shoot12] { ai_shotcheck(); };
void() vermis_shoot12 = [133, vermis_shoot13] { ai_shotcheck(); };
void() vermis_shoot13 = [134, vermis_shoot14] { ai_shotcheck(); };
void() vermis_shoot14 = [135, vermis_shoot15] { ai_shotcheck(); };
void() vermis_shoot15 = [136, vermis_shoot16] { ai_shotcheck(); };
void() vermis_shoot16 = [137, vermis_shoot17] { ai_shotcheck(); };
void() vermis_shoot17 = [138, vermis_shoot18] { ai_shotcheck(); };
void() vermis_shoot18 = [139, vermis_shoot19] { ai_shotcheck(); };
void() vermis_shoot19 = [140, vermis_shoot20] { ai_shotcheck(); };
void() vermis_shoot20 = [141, vermis_run1] { ai_shotcheck(); };

void(vector offset) vermis_grab = {
	local vector org;
	local float dist;

	if (self.vermis_grabbed > time) return;
	if (self.enemy.flags & FL_FLY || self.enemy.flags & FL_SWIM) return;

	if (self.enemy.flags & FL_MONSTER) T_Damage(self.enemy,self,self.owner, 15 + 5 * random(),DAMARMOR);
	makevectors(self.angles);
	org = self.origin + v_right * offset_x + v_forward * offset_y + v_up * offset_z;
	dist = vlen(self.enemy.origin - org);
	if (dist < 155) {
		self.enemy.vermis_grabbed = 1;
		sound(self,CHAN_VOICE, "quoth/vermis/grabbed.wav", 1, 0.5);
		T_Damage(self.enemy, self, self, SVC_FINALE + 4 * random(),DAMARMOR);
		return;
	}
	sound(self,CHAN_VOICE, "quoth/vermis/grndhit.wav", 1, 0.5);
};

void(vector offset1, vector offset2) vermis_move = {
	local vector reqvel, position1, position2;
	local float dist;

	makevectors(self.angles);
	if (self.enemy.vermis_grabbed != 1) return;

	SUB_RemoveFlags(self.enemy,FL_ONGROUND);
	if (offset1_x == 666) offset1 = self.enemy.origin;
	position1 = self.origin + v_right * offset1_x
							+ v_forward * offset1_y
							+ v_up * offset1_z;
	position2 = self.origin + v_right * offset2_x
							+ v_forward * offset2_y
							+ v_up * offset2_z;
	setorigin(self.enemy,position1);
	self.enemy.oldorigin = self.origin;
	dist = vlen(position2 - position1);
	reqvel = normalize(position2 - position1) * dist * TE_LAVASPLASH;
	self.enemy.velocity = reqvel;
	self.enemy.teleport_time = time + 0.2;
};

void() dummy_think = {
	self.owner.vermis_grabbed = 0;
	self.owner.spawnmaster = world;
	self.owner.velocity = self.velocity;
	entity_remove(self,0.1);
};

void() vermis_launch = {
	if (self.enemy.vermis_grabbed != 1) return;

	makevectors(self.angles);
	self.enemy.vermis_grabbed = 2;
	SUB_AttackFinished(1);
	if (self.enemy.health <= 0) self.enemy.velocity = v_forward * 700 + v_up * 50;
	else {
		self.enemy.spawnmaster = spawn();
		setsize(self.enemy.spawnmaster, VEC_HULL_MIN, '16 16 40');
		setorigin(self.enemy.spawnmaster, self.enemy.origin);
		self.enemy.spawnmaster.movetype = MOVETYPE_BOUNCE;
		self.enemy.spawnmaster.velocity = v_forward * 700 + v_up * 50;
		self.enemy.spawnmaster.nextthink = time + 1;
		self.enemy.spawnmaster.think = dummy_think;
		self.enemy.spawnmaster.owner = self.enemy;
		self.enemy.spawnmaster.classname = "dummy";
	}
	if (self.enemy.flags & FL_MONSTER) self.enemy.velocity = v_forward * 700 + v_up * 50;
	self.vermis_grabbed = time + 2;
};

void() vermis_grabmis1 = [217, vermis_grabmis2] { ai_shotcheck(); };
void() vermis_grabmis2 = [217, vermis_run1] { ai_shotcheck(); SUB_AttackFinished(0.2); };

void() vermis_grab1 = [142, vermis_grab2] {
	self.drop = self.yaw_speed;
	self.yaw_speed = 25;
	ai_shotcheck();
	sound(self,CHAN_AUTO,"quoth/vermis/grab.wav", 1, 0.5);
};
void() vermis_grab2 = [143, vermis_grab3] { ai_shotcheck(); };
void() vermis_grab3 = [144, vermis_grab4] { ai_shotcheck(); };
void() vermis_grab4 = [145, vermis_grab5] { ai_shotcheck(); };
void() vermis_grab5 = [146, vermis_grab6] {
	ai_shotcheck();
	vermis_grab('14 174 24');
	vermis_move('666 0 0', '14 174 24');
};
void() vermis_grab6 = [147, vermis_grab7] { vermis_move('19 208 -7', '18 203 -14'); };
void() vermis_grab7 = [148, vermis_grab8] { vermis_move('18 203 -14', '16 193 -5'); };
void() vermis_grab8 = [149, vermis_grab9] {
	vermis_move('16 193 -5', '14 182 11');
	if (!self.enemy.vermis_grabbed) self.think = vermis_grabmis1;

};
void() vermis_grab9 = [150, vermis_grab10] { vermis_move('14 182 11', '11 172 34'); };
void() vermis_grab10 = [151, vermis_grab11] { vermis_move('11 172 34', '9 166 59'); };
void() vermis_grab11 = [152, vermis_grab12] { vermis_move('9 166 59', '8 164 92'); };
void() vermis_grab12 = [153, vermis_grab13] { vermis_move('8 164 92', '6 156 136'); };
void() vermis_grab13 = [154, vermis_grab14] { vermis_move('6 156 136', '5 133 187'); };
void() vermis_grab14 = [155, vermis_grab15] { vermis_move('5 133 187', '4 89 236'); };
void() vermis_grab15 = [156, vermis_grab16] { vermis_move('4 89 236', '5 23 273'); };
void() vermis_grab16 = [157, vermis_grab17] { vermis_move('5 23 273', '3 -38 331'); };
void() vermis_grab17 = [158, vermis_grab18] { vermis_move('3 -38 331', '3 -38 331'); };
void() vermis_grab18 = [159, vermis_grab19] { vermis_launch(); };
void() vermis_grab19 = [160, vermis_grab20] {};
void() vermis_grab20 = [161, vermis_run1] {};

void() vermis_melee = {
	if (self.vermis_grabbed > time) return;

	if (!(self.enemy.flags & FL_FLY)) vermis_grab1();
};

void(entity inflictor, entity attacker, float damage) vermis_pain = {
	if (self.lefty) return;

	self.lefty = 1;
	if (self.coiled) vermis_wake1();
	else vermis_trans1();
};

void() vermis_death1 = [162, vermis_death2] {};
void() vermis_death2 = [163, vermis_death3] {};
void() vermis_death3 = [164, vermis_death4] {};
void() vermis_death4 = [165, vermis_death5] {};
void() vermis_death5 = [166, vermis_death6] {};
void() vermis_death6 = [167, vermis_death7] {};
void() vermis_death7 = [168, vermis_death8] {};
void() vermis_death8 = [169, vermis_death9] {};
void() vermis_death9 = [170, vermis_death10] {};
void() vermis_death10 = [171, vermis_death11] {};
void() vermis_death11 = [172, vermis_death12] {};
void() vermis_death12 = [173, vermis_death13] {};
void() vermis_death13 = [174, vermis_death14] {};
void() vermis_death14 = [175, vermis_death15] {};
void() vermis_death15 = [176, vermis_death16] {};
void() vermis_death16 = [177, vermis_death17] {};
void() vermis_death17 = [178, vermis_death18] {};
void() vermis_death18 = [179, vermis_death19] {};
void() vermis_death19 = [180, vermis_death20] {};
void() vermis_death20 = [181, vermis_death21] {};
void() vermis_death21 = [182, vermis_death22] {};
void() vermis_death22 = [183, vermis_death23] {};
void() vermis_death23 = [184, vermis_death24] {};
void() vermis_death24 = [185, vermis_death25] {};
void() vermis_death25 = [186, vermis_death26] {};
void() vermis_death26 = [187, vermis_death27] {};
void() vermis_death27 = [188, vermis_death28] {};
void() vermis_death28 = [189, vermis_death29] {};
void() vermis_death29 = [190, vermis_death30] { self.movetype = MOVETYPE_NOCLIP; };
void() vermis_death30 = [191, vermis_death31] {};
void() vermis_death31 = [192, vermis_death32] {};
void() vermis_death32 = [193, vermis_death33] {};
void() vermis_death33 = [194, vermis_death34] {};
void() vermis_death34 = [195, vermis_death35] { self.velocity = '0 0 -10'; };
void() vermis_death35 = [196, vermis_death36] { self.velocity = '0 0 -20'; };
void() vermis_death36 = [197, vermis_death37] { self.velocity = '0 0 -40'; };
void() vermis_death37 = [198, vermis_death38] { self.velocity = '0 0 -80'; };
void() vermis_death38 = [199, vermis_death39] { self.velocity = '0 0 -160'; };
void() vermis_death39 = [200, vermis_death40] { self.velocity = '0 0 -320'; };
void() vermis_death40 = [201, vermis_death41] { self.velocity = '0 0 -400'; };
void() vermis_death41 = [202, vermis_death42] { self.velocity = '0 0 -450'; };
void() vermis_death42 = [203, vermis_death43] {};
void() vermis_death43 = [204, vermis_death44] {};
void() vermis_death44 = [205, vermis_death45] {};
void() vermis_death45 = [206, vermis_death46] {};
void() vermis_death46 = [207, vermis_death47] {};
void() vermis_death47 = [208, vermis_death48] {};
void() vermis_death48 = [209, vermis_death49] {};
void() vermis_death49 = [210, vermis_death50] {};
void() vermis_death50 = [211, vermis_death51] {};
void() vermis_death51 = [210, vermis_death52] {};
void() vermis_death52 = [209, vermis_death47] {
	if (self.inv == 1) entity_remove(self,0.1);
	self.inv = 1;
};

void() vermis_die = {
	monster_death_precheck(); // Pre-check routine to tidy up extra entities.
	sound(self,CHAN_WEAPON,"quoth/vermis/death.wav", 1, 0);
	self.solid = SOLID_NOT;
	if (self.enemy) self.enemy.vermis_grabbed = 0;
	vermis_death1();
};

void() monster_vermis_precache = {
	precache_model("progs/quoth/vermis.mdl");
	precache_model("progs/quoth/spore.mdl");
	precache_sound("quoth/vermis/grab.wav");
	precache_sound("quoth/vermis/death.wav");
	precache_sound("quoth/vermis/grabbed.wav");
	precache_sound("quoth/vermis/grndhit.wav");
	precache_sound("quoth/vermis/spore.wav");
	precache_sound("quoth/vermis/pop.wav");
	precache_sound("quoth/vermis/splash1.wav");
	precache_sound("quoth/vermis/splash2.wav");
	precache_sound("quoth/vermis/splash3.wav");
	precache_sound("quoth/vermis/sight.wav");
	precache_sound("quoth/vermis/sight2.wav");
};

void() monster_vermis = {
	if (monster_checkspawn() == TRUE) return; // Check all spawn exceptions (monsters.qc)

	self.mdl = "progs/quoth/vermis.mdl";
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_NOCLIP;
	if (self.health <= 0) self.health = 3000;
	self.gibhealth = MON_NEVERGIB;
	Resist_ChangeType(self,-1); // Always reset Ammo Resistance to be consistent
	if (self.coiled) {
		self.th_stand = vermis_coil1;
		setsize(self, '-64 -64 -512', '64 64 -64');
	} else {
		self.th_stand = vermis_idle1;
		setsize(self, '-64 -64 -512', '64 64 256');
	}

	self.th_stand = vermis_start;
	self.th_run = vermis_run1;
	self.th_missile = vermis_shoot1;
	self.th_melee = vermis_melee;
	self.th_pain = vermis_pain;
	self.th_die = vermis_die;
	if (self.deathstring == "") self.deathstring = " was eradicated by a Vermis\n";
	self.classtype = CT_MONVERMIS;
	self.classgroup = CG_BOSS;
	self.classmove = FALSE;
	monster_start();
};
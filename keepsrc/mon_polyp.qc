//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \ 
// |  \ |___ |___ |        |  | \__/ |__/ 
//
// Compiled by W. Josiah Jack, aka Qmaster
//
// Attributions: Quoth, Preach
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
// Function count: 106
//
// Implements:  Polyp
//
// Description:
// Green gelatinous blob that flies through the air biting you and is capable
// of disappearing for a time and reappearing where you least expect it most.
// Poisonous and its death gibs hurt to touch.
//=============================================================================

void() polyp_float1;
void(entity inflictor, entity attacker, float damage) polyp_wake1;
void() polyp_wake1_prethink = { local entity blank; local float blankf; polyp_wake1(blank,blank,blankf); };
void(entity inflictor, entity attacker, float damage) polyp_pain;
void() polyp_walkfly1;
void() polyp_visible1;
void() polyp_missile;
void() polyp_die1;
void() polyp_jump5;

void() polypcheckdist = {
	local vector dist;
	local float d;
	local vector oldorg;
	local vector reqvel;
	local float speedmulti;
	local float d2;

	oldorg = self.origin;
	self.velocity = VEC_ORIGIN;
	self.polyp_speed = self.polyp_speed * 0.95;
	if (self.polyp_speed < 14)
		self.polyp_speed = 35;

	self.attack_state = AS_STRAIGHT;
	dist = self.enemy.origin - self.origin;
	dist_z = 0;
	d = vlen(dist);
	d2 = 0;
	if (d < 200 && visible(self.enemy)) {
		self.attack_state = AS_SLIDING;
		ai_run(self.polyp_speed * -1.5);
		d2 = fabs(self.polyp_speed * -1.5) + 2;
	} else {
		if (d < 200 && !visible(self.enemy)) {
			ai_run(self.polyp_speed);
			d2 = fabs(self.polyp_speed);
		} else {
			if (d > 200 && d <= 400) {
				ai_run(self.polyp_speed * (d / 400));
				self.attack_state = AS_SLIDING;
				d2 = fabs(self.polyp_speed * (d / 400)) + 2;
				ai_run(self.polyp_speed);
				self.attack_state = AS_STRAIGHT;
				d2 = d2 + fabs(self.polyp_speed);
			} else {
				if (d >= 400) {
					ai_run(self.polyp_speed * 2);
					d2 = fabs(self.polyp_speed * 2);
				}
			}
		}
	}
	d = vlen(self.origin - oldorg);
	if (d <= d2) {
		self.movetype = MOVETYPE_FLY;
		speedmulti = vlen(self.origin - oldorg);
		reqvel = normalize(self.origin - oldorg) * speedmulti * TE_WIZSPIKE;
		setorigin(self, oldorg);
		self.velocity = reqvel;
	}
};

void() polyp_stand0 = [10, polyp_stand1] {
	setmodel(self, "progs/quoth/polyp.mdl");
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
	self.view_ofs = '0 0 -8';
	self.th_stand = polyp_float1;
	self.origin_z = self.origin_z + 1;
	droptofloor();
};
void() polyp_stand1 = [0, polyp_stand2] { ai_stand(); };
void() polyp_stand2 = [1, polyp_stand3] { ai_stand(); };
void() polyp_stand3 = [2, polyp_stand4] { ai_stand(); };
void() polyp_stand4 = [3, polyp_stand5] { ai_stand(); };
void() polyp_stand5 = [4, polyp_stand6] { ai_stand(); };
void() polyp_stand6 = [5, polyp_stand7] { ai_stand(); };
void() polyp_stand7 = [6, polyp_stand8] { ai_stand(); };
void() polyp_stand8 = [7, polyp_stand9] { ai_stand(); };
void() polyp_stand9 = [8, polyp_stand10] { ai_stand(); };
void() polyp_stand10 = [9, polyp_stand11] { ai_stand(); };
void() polyp_stand11 = [10, polyp_stand1] { ai_stand(); };

void(entity inflictor, entity attacker, float damage) polyp_wake1 = [133, polyp_wake2] { self.th_pain = polyp_pain; };
void() polyp_wake2 = [134, polyp_wake3] {};
void() polyp_wake3 = [135, polyp_wake4] {};
void() polyp_wake4 = [136, polyp_wake5] {};
void() polyp_wake5 = [137, polyp_wake6] {};
void() polyp_wake6 = [138, polyp_wake7] { self.movetype = MOVETYPE_FLY; self.flags = self.flags - (self.flags & FL_ONGROUND); self.velocity = '0 0 25'; };
void() polyp_wake7 = [139, polyp_wake8] { self.velocity = '0 0 50'; };
void() polyp_wake8 = [140, polyp_wake9] { self.velocity = '0 0 175'; };
void() polyp_wake9 = [141, polyp_wake10] { self.velocity = '0 0 125'; };
void() polyp_wake10 = [142, polyp_wake11] { self.velocity = '0 0 75'; };
void() polyp_wake11 = [143, polyp_wake12] { self.velocity = '0 0 50'; };
void() polyp_wake12 = [144, polyp_wake13] { self.velocity = '0 0 25'; };
void() polyp_wake13 = [145, polyp_wake14] { self.velocity = '0 0 15'; };
void() polyp_wake14 = [146, polyp_hover1] {
	self.count = time + 2 + 1 * random();
	self.movetype = MOVETYPE_STEP;
	self.velocity = VEC_ORIGIN;
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
	self.th_pain = polyp_pain;
	self.th_walk = polyp_walkfly1;
	self.flags = self.flags | FL_FLY;
};

void() polyp_float1 = [153, polyp_float2] {
	setmodel(self, "progs/quoth/polyp.mdl");
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
	self.count = time + 2 + 1 * random();
	ai_stand();
	if (random() < 0.05)
		sound(self,CHAN_VOICE, "quoth/polyp/idle.wav", 1, AS_MELEE);
};
void() polyp_float2 = [154, polyp_float3] { self.count = time + 2 + 1 * random(); ai_stand(); };
void() polyp_float3 = [155, polyp_float4] { self.count = time + 2 + 1 * random(); ai_stand(); };
void() polyp_float4 = [156, polyp_float1] { self.count = time + 2 + 1 * random(); ai_stand(); };

void() polyp_walk1 = [11, polyp_walk2] {
	self.velocity = VEC_ORIGIN;
	ai_turn();
	self.flags = self.flags - (self.flags & FL_FLY);
	setmodel(self, "progs/quoth/polyp.mdl");
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
	self.velocity = VEC_ORIGIN;
};
void() polyp_walk2 = [12, polyp_walk3] { ai_turn(); };
void() polyp_walk3 = [13, polyp_walk4] { ai_turn(); };
void() polyp_walk4 = [14, polyp_walk5] { ai_turn(); };
void() polyp_walk5 = [15, polyp_walk6] { ai_turn(); };
void() polyp_walk6 = [16, polyp_walk7] { ai_turn(); };
void() polyp_walk7 = [17, polyp_walk8] { ai_turn(); };
void() polyp_walk8 = [18, polyp_walk9] { ai_turn(); };
void() polyp_walk9 = [19, polyp_walk10] { ai_turn(); };
void() polyp_walk10 = [20, polyp_walk11] { ai_turn(); };
void() polyp_walk11 = [21, polyp_walk12] { ai_chargenoturn(2); };
void() polyp_walk12 = [22, polyp_walk13] { ai_chargenoturn(2); };
void() polyp_walk13 = [23, polyp_walk14] { ai_chargenoturn(2); };
void() polyp_walk14 = [24, polyp_walk15] { ai_chargenoturn(2); };
void() polyp_walk15 = [25, polyp_walk16] { ai_chargenoturn(2); };
void() polyp_walk16 = [26, polyp_walk17] { ai_chargenoturn(2); };
void() polyp_walk17 = [27, polyp_walk18] { ai_chargenoturn(2); };
void() polyp_walk18 = [28, polyp_walk19] { ai_chargenoturn(2); };
void() polyp_walk19 = [29, polyp_walk20] { ai_chargenoturn(2); };
void() polyp_walk20 = [30, polyp_walk21] { ai_chargenoturn(2); };
void() polyp_walk21 = [31, polyp_walk22] { ai_chargenoturn(2); };
void() polyp_walk22 = [32, polyp_walk23] { ai_chargenoturn(2); };
void() polyp_walk23 = [33, polyp_walk24] { ai_chargenoturn(2); };
void() polyp_walk24 = [34, polyp_walk25] { ai_chargenoturn(2); };
void() polyp_walk25 = [35, polyp_walk1] { ai_chargenoturn(2); };

void() polyp_walkfly1 = [153, polyp_walkfly2] {
	ai_runwalkfly(6,ai_walk);
	setmodel(self, "progs/quoth/polyp.mdl");
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
	self.velocity = VEC_ORIGIN;
};
void() polyp_walkfly2 = [154, polyp_walkfly3] { ai_runwalkfly(6,ai_walk); };
void() polyp_walkfly3 = [155, polyp_walkfly4] { ai_runwalkfly(6,ai_walk); };
void() polyp_walkfly4 = [156, polyp_walkfly1] { ai_runwalkfly(6,ai_walk); };

void() polyp_invisible_sound = {
	if (self.ltime < time) {
		sound(self,CHAN_VOICE, "quoth/polyp/idle2.wav", 1, 1.5);
		self.ltime = time + 1;
	}
	return;
};

void() polyp_ihover0 = [0, polyp_ihover1] {
	setmodel(self, "progs/null.spr");  //formerly progs/quoth/s_null.spr
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
	polypcheckdist();
};
void() polyp_ihover1 = [0, polyp_ihover2] {
	polypcheckdist();
	polyp_invisible_sound();
	if (self.count < time)
		self.think = polyp_visible1;
};
void() polyp_ihover2 = [0, polyp_ihover3] { polypcheckdist();polyp_invisible_sound(); };
void() polyp_ihover3 = [0, polyp_ihover4] { polypcheckdist();polyp_invisible_sound(); };
void() polyp_ihover4 = [0, polyp_ihover1] { polypcheckdist();polyp_invisible_sound(); };

void() polyp_visible1 = [0, polyp_visible2] {
	local vector org;

	SUB_RemoveFlags(self,FL_NOTARGET);
	org = self.origin;
	sound(self,CHAN_AUTO,"quoth/polyp/decloak.wav",1,ATTN_NORM);
	self.frame = 0;
	setmodel(self, "progs/quoth/polyp_t3.mdl");
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
	self.count = time + 2 + 2 * random();
	self.th_missile = polyp_missile;
	self.th_die = polyp_die1;
	self.th_run = polyp_hover1;
};
void() polyp_visible2 = [0, polyp_visible3] {	self.frame = 0; setmodel(self, "progs/quoth/polyp_t2.mdl");setsize(self, VEC_HULL_MIN, VEC_HULL_MAX); };
void() polyp_visible3 = [0, polyp_hover0a] {	self.frame = 0; setmodel(self, "progs/quoth/polyp_t1.mdl");setsize(self, VEC_HULL_MIN, VEC_HULL_MAX); };

void() polyp_invisible = [0, polyp_invisible2] {
	local vector org;

	self.flags = self.flags | FL_NOTARGET;
	org = self.origin;
	sound(self,CHAN_AUTO,"quoth/polyp/cloak.wav",1,ATTN_NORM);
	self.frame = 0;
	setmodel(self, "progs/quoth/polyp_t1.mdl");
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
	self.th_missile = SUB_Null;
	self.th_run = SUB_Null;
	self.count = time + 2 + 2 * random();
};
void() polyp_invisible2 = [0, polyp_invisible3] {	self.frame = 0; setmodel(self, "progs/quoth/polyp_t2.mdl");setsize(self, VEC_HULL_MIN, VEC_HULL_MAX); };
void() polyp_invisible3 = [0, polyp_ihover0] {	self.frame = 0; setmodel(self, "progs/quoth/polyp_t3.mdl");setsize(self, VEC_HULL_MIN, VEC_HULL_MAX); };

void() polyp_hover0 = [156, polyp_hover1] {
	local vector dist;
	local float d;

	self.count = time + 2 + 2 * random();
	polypcheckdist();
	dist = self.enemy.origin - self.origin;
	d = vlen(dist);
	if (d > 256)
		self.count = 0;
};

void() polyp_hover0a = [0, polyp_hover2] {
	setmodel(self, "progs/quoth/polyp.mdl");
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
	polypcheckdist();
	if (self.count < time) self.think = polyp_invisible;
};

void() polyp_hover1 = [153, polyp_hover2] {
	if (self.flags & FL_ONGROUND) self.flags = self.flags - (self.flags & FL_ONGROUND);
	polypcheckdist();
	if (self.count < time) self.think = polyp_invisible;
};
void() polyp_hover2 = [154, polyp_hover3] { polypcheckdist(); };
void() polyp_hover3 = [155, polyp_hover4] { polypcheckdist(); };
void() polyp_hover4 = [156, polyp_hover1] { polypcheckdist(); };

void() airthink = {
	local entity head;

	self.nextthink = time + 0.1;
	self.cnt = self.cnt + 1;
	if (self.cnt >= 5) {
		self.think = SUB_Remove;
	} else {
		self.think = airthink;
	}
	head = findradius(self.origin, self.cnt * 22);
	while (head) {
		if (head.takedamage == DAMAGE_AIM && visible(head)) T_Damage(head, self, self.owner, 1,DAMARMOR);
		head = head.chain;
	}
};

void() airtouch = {
	Tent_Point(TE_GUNSHOT,self.origin);
	if (other.takedamage == DAMAGE_AIM) {
		other.velocity = other.velocity + self.velocity * 0.4 + '0 0 70';
		if (random() < 0.4) T_Damage(other, self, self.owner, 1,DAMARMOR);
	}
	SUB_Remove();
	return;
};

void() polyp_air = {
	local entity missile;
	local vector vec;

	missile = spawn();
	missile.classgroup = CG_PROJALL;
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	missile.classname = "airchunk";
	vec = normalize(self.enemy.origin - self.origin);
	missile.velocity = normalize(vec);
	missile.velocity = missile.velocity * 750;
	missile.angles = vectoangles(self.enemy.origin - self.origin);
	missile.touch = airtouch;
	missile.nextthink = time + 0.1;
	missile.think = airthink;
	setmodel(missile, "progs/quoth/air.mdl");
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(missile, self.origin + v_forward * SECRET_NO_SHOOT + '0 0 16');
};

void() polyp_air1 = [153, polyp_air2] {
	if (self.count < time) self.think = polyp_invisible;
	ai_face();
	polyp_air();
	sound(self,CHAN_WEAPON,"quoth/polyp/blast.wav",1,ATTN_NORM);
};
void() polyp_air2 = [154, polyp_air3] { ai_face();polyp_air(); };
void() polyp_air3 = [155, polyp_air4] { ai_face();polyp_air(); };
void() polyp_air4 = [156, polyp_air5] { ai_face();polyp_air(); };
void() polyp_air5 = [155, polyp_hover1] { ai_face();polyp_air(); };

void() polyp_fly1 = [153, polyp_fly2] {};
void() polyp_fly2 = [154, polyp_fly3] {};
void() polyp_fly3 = [155, polyp_fly4] {};
void() polyp_fly4 = [156, polyp_fly1] {
	self.cnt = self.cnt + 1;
	if (self.cnt == SECRET_1ST_DOWN) polyp_jump5();
};

void() polyp_jump1 = [147, polyp_jump2] { ai_face(); };
void() polyp_jump2 = [148, polyp_jump3] { ai_face(); };
void() polyp_jump3 = [149, polyp_jump4] { ai_face(); };
void() polyp_jump4 = [150, polyp_jump5] { ai_face(); };
void() polyp_jump5 = [151, polyp_jump6] {
	self.movetype = MOVETYPE_BOUNCE;
	self.touch = Tar_JumpTouch;
	makevectors(self.angles);
	self.origin_z = self.origin_z + 1;
	self.velocity = v_forward * 600 + '0 0 200';
	self.velocity_z = self.velocity_z + random() * 150;
	SUB_RemoveFlags(self,FL_ONGROUND);
	self.cnt = 0;
};
void() polyp_jump6 = [152, polyp_fly1] {};

void() pgibtouch = {
	self.think = SUB_Remove;
	self.nextthink = time + random() * 5;
	if (other.takedamage == DAMAGE_AIM) {
		sound(self,CHAN_WEAPON,"zombie/z_hit.wav",1,ATTN_NORM);
		T_Damage(other, self, self.owner.owner, self.dmg,DAMARMOR);
		SUB_Remove();
	}
};

void(string gibname, float dm) throwpolypgib = {
	local entity new;

	new = spawn();
	new.classgroup = CG_PROJALL;
	new.origin = self.origin;
	setmodel(new, gibname);
	setsize(new, VEC_ORIGIN, VEC_ORIGIN);
	new.classname = "polypgib";
	new.owner = self;
	new.dmg = 5;
	new.velocity = VelocityForDamage(dm);
	new.movetype = MOVETYPE_BOUNCE;
	new.solid = SOLID_BBOX;
	if (new.owner.classtype == CT_MONINQUISITOR) {
		setsize(new,'-8 -8 -8', '8 8 8');
		new.dmg = 5 + (random() * 5);
	}
	new.avelocity_x = random() * 600;
	new.avelocity_y = random() * 600;
	new.avelocity_z = random() * 600;
	new.think = SUB_Remove;
	new.nextthink = time + 5 + random() * 5;
	new.touch = pgibtouch;
	new.frame = 0;
};

void() polyp_die1 = [157, polyp_die2] {
	self.nextthink = time + 0.2;
	self.velocity = VEC_ORIGIN;
};
void() polyp_die2 = [157, polyp_hover1] {
	sound(self,CHAN_VOICE, "quoth/polyp/gibsplt1.wav",1,ATTN_NORM);
	throwpolypgib("progs/quoth/polypgib.mdl", -40);
	throwpolypgib("progs/quoth/polypgib.mdl", -40);
	throwpolypgib("progs/quoth/polypgib.mdl", -40);
	throwpolypgib("progs/quoth/polypgib.mdl", -50);
	throwpolypgib("progs/quoth/polypgib.mdl", -50);
	throwpolypgib("progs/quoth/polypgib.mdl", -60);
	throwpolypgib("progs/quoth/polypgib.mdl", -60);
	throwpolypgib("progs/quoth/polypgib.mdl", -75);
	throwpolypgib("progs/quoth/polypgib.mdl", -75);
	entity_remove(self,0.1);
};

void() polyp_die = {
	// Pre-check routine to tidy up extra entities
	monster_death_precheck();
	self.takedamage = DAMAGE_NO;
	polyp_die1();
};

void() polyp_missile = {
	if (self.fly_sound > time) return;
	if (random() < 0.3) return;

	self.fly_sound = time + 1.4;
	polyp_air1();
};

void(entity inflictor, entity attacker, float damage) polyp_pain = {
	if (self.flags & FL_NOTARGET) polyp_visible1();
	else return;
};

void() monster_polyp_precache = {
	precache_model("progs/quoth/polyp.mdl");
	precache_model("progs/quoth/polyp_t1.mdl");
	precache_model("progs/quoth/polyp_t2.mdl");
	precache_model("progs/quoth/polyp_t3.mdl");
	precache_model("progs/null.spr");  //formerly progs/quoth/s_null.spr
	precache_model("progs/quoth/polypgib.mdl");
	precache_model("progs/quoth/air.mdl");
	precache_sound("quoth/polyp/idle2.wav");
	precache_sound("zombie/z_hit.wav");
	precache_sound("quoth/polyp/cloak.wav");
	precache_sound("quoth/polyp/decloak.wav");
	precache_sound("quoth/polyp/gibsplt1.wav");
	precache_sound("quoth/polyp/blast.wav");
	precache_sound("quoth/polyp/sight.wav");
	precache_sound("quoth/polyp/idle.wav");
};

void() monster_polyp = {
	if (monster_checkrandomizer() == TRUE) return; // Check for any random monster setups
	if (monster_checkspawn() == TRUE) return; // Check all spawn exceptions (monsters.qc)

	self.mdl = "progs/quoth/polyp.mdl";
	self.solid = SOLID_NOT;				// No interaction with world
	self.movetype = MOVETYPE_NONE;		// Static item, no movement
	if (self.bboxtype < 1) self.bboxtype = BBOX_TINY;
	if (self.health < 1) self.health = 150;
	self.gibhealth = MON_NEVERGIB;		// Cannot be gibbed by weapons
	self.gibbed = FALSE;
	self.pain_flinch = 20;
	Resist_ChangeType(self,-1); // Always reset Ammo Resistance to be consistent
	if (self.deathstring == "") self.deathstring = " was popped by a polyp\n";
	self.th_run = polyp_hover0;
	self.th_missile = polyp_missile;
	self.th_die = polyp_die1;
	self.yaw_speed = SVC_INTERMISSION;
	if (self.startonground == 1) {
		self.th_pain = polyp_wake1;
		self.th_stand = polyp_stand0;
		self.th_walk = polyp_walk1;
	} else {
		self.th_pain = polyp_pain;
		self.th_stand = polyp_float1;
		self.th_walk = polyp_walkfly1;
	}
	self.classtype = CT_MONPOLYP;
	self.classgroup = CG_SPAWN;
	self.classmove = MON_MOVEFLY;
	monster_start();
};
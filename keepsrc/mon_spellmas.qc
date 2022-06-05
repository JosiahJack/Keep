void(float dist) spell_ai = {
	if (self.style == 1) {
		ai_stand();
	} else {
		if (self.style == 2) {
			ai_walk(dist);
		} else {
			if (self.style == 3) {
				ai_run(dist * 2);
				ai_face();
			}
		}
	}
};

void() spell_walk1 = [0, spell_walk2] {
	self.effects = MSG_BROADCAST;
	if (random() < 0.2) sound(self, CHAN_VOICE, "boss2/idle.wav", EQ_RANDOM, ATTN_IDLE);
	spell_ai(TE_LIGHTNING2);
};
void() spell_walk2 = [1, spell_walk3]{spell_ai(4);};
void() spell_walk3 = [2, spell_walk4]{spell_ai(3);};
void() spell_walk4 = [3, spell_walk5]{spell_ai(TE_LIGHTNING1);};
void() spell_walk5 = [4, spell_walk6]{spell_ai(TE_LIGHTNING2);};
void() spell_walk6 = [5, spell_walk1]{spell_ai(4);};

void() spell_stand = {self.style = EQ_RANDOM;spell_walk1();};

void() spell_walk = {self.style = 2;spell_walk1();};

void() spell_run = {self.style = 3;spell_walk1();};

void() Spell_MissileTouch = {
	local float damg;
	if (other == self.owner) return;
	if (pointcontents(self.origin) == CONTENT_SKY){remove(self);return;}
	damg = 50 + random() * 20;
	if (other.health) T_Damage(other, self, self.owner, damg,DAMARMOR);
	T_RadiusDamage(self, self.owner, 120, other,DAMAGEALL);
	self.origin = self.origin - SECRET_NO_SHOOT * normalize(self.velocity);
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord(MSG_BROADCAST, self.origin_x);
	WriteCoord(MSG_BROADCAST, self.origin_y);
	WriteCoord(MSG_BROADCAST, self.origin_z);
	BecomeExplosion();
};

void() Spell_launch_lava = {
	local vector vec;

	sound(self, CHAN_WEAPON, "shalrath/attack2.wav", EQ_RANDOM, ATTN_NORM);
	vec = self.enemy.origin - self.origin;
	vec = normalize(vec - '0 0 148');
	newmis = spawn();
	newmis.owner = self;
	newmis.solid = SOLID_BBOX;
	newmis.movetype = MOVETYPE_FLYMISSILE;
	setmodel(newmis, "progs/lavaball.mdl");
	setsize(newmis, VEC_ORIGIN, VEC_ORIGIN);
	newmis.origin = self.origin + '0 0 148';
	newmis.velocity = vec * 600;
	newmis.avelocity = '500 500 500';
	newmis.touch = Spell_MissileTouch;
	self.effects = MSG_BROADCAST;
};

void() spell_attacka1 = [7, spell_attacka2]{ai_face();};
void() spell_attacka2 = [8, spell_attacka3]{ai_face();};
void() spell_attacka3 = [9, spell_attacka4]{ai_face();};
void() spell_attacka4 = [10, spell_attacka5]{ai_face();};
void() spell_attacka5 = [11, spell_attacka6]{self.effects = EF_DIMLIGHT;ai_face();};
void() spell_attacka6 = [12, spell_attacka7]{ai_face();};
void() spell_attacka7 = [13, spell_attacka8]{ai_face();};
void() spell_attacka8 = [14, spell_attacka9]{Spell_launch_lava();ai_face();};
void() spell_attacka9 = [15, spell_run]{ai_face();};

void() Spell_push = {
	local vector delta;
	local float ldmg;
	if (!(self.enemy.flags & FLx_CREATURE)) return;

	delta = self.enemy.origin - self.origin;
	ldmg = random() * 25;
	T_Damage(self.enemy, self, self, ldmg,DAMARMOR);
	sound(self, CHAN_WEAPON, "wizard/wsight.wav", EQ_RANDOM, ATTN_NORM);
	self.enemy.flags = self.enemy.flags - (self.enemy.flags & FL_ONGROUND);
	self.enemy.velocity = delta * TE_LAVASPLASH;
	self.enemy.velocity_z = 100;
};

void() spell_attackb1 = [16, spell_attackb2]{ai_face();};
void() spell_attackb2 = [17, spell_attackb3]{ai_face();};
void() spell_attackb3 = [18, spell_attackb4]{ai_face();};
void() spell_attackb4 = [19, spell_attackb5]{ai_face();};
void() spell_attackb5 = [20, spell_attackb6]{ai_face();Spell_push();};
void() spell_attackb6 = [21, spell_attackb7]{ai_face();};
void() spell_attackb7 = [22, spell_attackb8]{ai_face();};
void() spell_attackb8 = [23, spell_attackb9]{ai_face();};
void() spell_attackb9 = [24, spell_run]{ai_face();};

void() spell_attack = {
	local vector delta;
	delta = self.enemy.origin - self.origin;
	if (vlen(delta) <= 90) {
		spell_attackb1();
	} else {
		if (vlen(delta) <= 300 && random() < 0.5)
			spell_attackb1();
		else
			spell_attacka1();
	}
};

void() spell_pain1 = [25, spell_pain2]{};
void() spell_pain2 = [26, spell_pain3]{};
void() spell_pain3 = [27, spell_pain4]{};
void() spell_pain4 = [28, spell_run]{};

void(entity inflictor, entity attacker, float damage) spell_pain = {
	if (self.pain_finished > time) return;

	sound(self, SPAWNFLAG_LASER, "wizard/wdeath.wav", EQ_RANDOM, EQ_RANDOM);
	spell_pain1();
	self.pain_finished = time + AS_MELEE;
};

void() spell_death1 = [29, spell_death2]{};
void() spell_death2 = [30, spell_death3]{};
void() spell_death3 = [31, spell_death4]{};
void() spell_death4 = [32, spell_death5]{};
void() spell_death5 = [33, spell_death6]{};
void() spell_death6 = [34, spell_death7]{self.solid = SOLID_NOT;};
void() spell_death7 = [35, spell_death8]{};
void() spell_death8 = [36, spell_death9]{};
void() spell_death9 = [37, spell_death10]{};
void() spell_death10 = [38, spell_death11]{};
void() spell_death11 = [39, spell_death12]{};
void() spell_death12 = [40, spell_death13]{};
void() spell_death13 = [41, spell_death14]{};
void() spell_death14 = [42, spell_death15]{};
void() spell_death15 = [43, spell_death16]{};
void() spell_death16 = [44, spell_death17]{};
void() spell_death17 = [45, spell_death18]{};
void() spell_death18 = [46, spell_death19]{};
void() spell_death19 = [47, spell_death20]{};
void() spell_death20 = [48, spell_death21]{};
void() spell_death21 = [49, spell_death22]{};
void() spell_death22 = [50, spell_death23]{monster_death_postcheck();};
void() spell_death23 = [51, spell_death23]{monster_deadbody_check();};

void() spell_die = {
	self.effects = 0;
	// Pre-check routine to tidy up extra entities
	monster_death_precheck();

	if (!self.gibbed) {
		sound(self, CHAN_VOICE, "blob/death1.wav", 1, ATTN_NORM);
		spell_death1();
	}
};

void() monster_spellmaster_precache = {
	precache_model("progs/madfox/mon_spellmas.mdl");
	precache_model("progs/lavaball.mdl");
	precache_sound("wizard/wdeath.wav");
	precache_sound("wizard/wsight.wav");
	precache_sound("blob/death1.wav");
	precache_sound("boss2/idle.wav");
	precache_sound("shalrath/attack2.wav");
	precache_sound("shalrath/sight.wav");
};

void() monster_spellmaster = {
	if (monster_checkspawn() == TRUE) return; // Check all spawn exceptions (monsters.qc)

	self.mdl = "progs/madfox/mon_spellmas.mdl";
	self.th_stand = spell_stand;
	self.th_walk = spell_walk;
	self.th_run = spell_run;
	self.th_die = spell_die;
	self.th_pain = spell_pain;
	self.th_missile = spell_attack;
	Resist_ChangeType(self,-1); // Always reset Ammo Resistance to be consistent
	self.solid = SOLID_NOT;					// No interaction with world
	self.movetype = MOVETYPE_NONE;			// Static item, no movement
	self.bbmins = '-32 -32 -24';	// Special Size
	self.bbmaxs = '32 32 192';
	self.bboxtype = BBOX_CUSTOM;
	if (self.health < 1) self.health = 2400;
	self.gibhealth = -40;
	self.gibbed = FALSE;
	if (self.deathstring == "") self.deathstring = " was remapped by a Baseboss\n";
	self.classtype = CT_MONSPELLMAS;
	self.classgroup = CG_BOSS;
	self.classmove = MON_MOVEWALK;
	monster_start();
};
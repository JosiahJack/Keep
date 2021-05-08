void() mangaGrenadeExplode = 
{
	T_RadiusDamage(self, self.owner, 40, world);
	sound(self, CHAN_VOICE, "weapons/r_exp3.wav", 1, ATTN_NORM);
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord(MSG_BROADCAST, self.origin_x);
	WriteCoord(MSG_BROADCAST, self.origin_y);
	WriteCoord(MSG_BROADCAST, self.origin_z);
	self.velocity = VEC_ORIGIN;
	self.touch = SUB_Null;
	setmodel(self, "progs/s_explod.spr");
	self.solid = SOLID_NOT;
	s_explode1();
};

void() mangaGrenadeTouch = 
{
	if (other == self.owner)
	{
		return;
	}
	if (other.takedamage == DAMAGE_AIM)
	{
		mangaGrenadeExplode();
		return;
	}
	sound(self, CHAN_VOICE, "weapons/bounce.wav", 1, ATTN_NORM);
	if (self.velocity == VEC_ORIGIN)
	{
		self.avelocity = VEC_ORIGIN;
	}
};

void() mangaFireGrenade = 
{
	local entity missile;
	local entity mpuff;
	self.effects = self.effects | EF_MUZZLEFLASH;
	sound(self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM);
	missile = spawn();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
	makevectors(self.angles);
	missile.velocity = normalize(self.enemy.origin - self.origin);
	missile.velocity = missile.velocity * 600;
	missile.velocity_z = MAX_CHARMER_DISTANCE;
	missile.avelocity = '300 300 300';
	missile.angles = vectoangles(missile.velocity);
	missile.touch = mangaGrenadeTouch;
	missile.nextthink = time + 2.5;
	missile.think = mangaGrenadeExplode;
	setmodel(missile, "progs/grenade.mdl");
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(missile, self.origin);
};

void(float side) highkick = 
{
	local vector delta;
	local float ldmg;
	if (!(self.enemy))
	{
		return;
	}
	if (!CanDamage(self.enemy, self))
	{
		return;
	}
	ai_charge(MOVETYPE_BOUNCE);
	delta = self.enemy.origin - self.origin;
	if (vlen(delta) > 100)
	{
		return;
	}
	random();
	ldmg = (random() + random() + random()) * MOVETYPE_STEP;
	T_Damage(self.enemy, self, self, ldmg);
	if (side)
	{
		makevectors(self.angles);
		if (side == 1)
		{
			SpawnMeatSpray(self.origin + v_forward * FL_INWATER, crandom() * 100 * v_right);
		}
		else
		{
			SpawnMeatSpray(self.origin + v_forward * FL_INWATER, side * v_right);
		}
	}
};

void() manga_stand1 = [1, manga_stand2]
{
	ai_stand();
};

void() manga_stand2 = [2, manga_stand3]
{
	ai_stand();
};

void() manga_stand3 = [3, manga_stand4]
{
	ai_stand();
};

void() manga_stand4 = [4, manga_stand5]
{
	ai_stand();
};

void() manga_stand5 = [5, manga_stand6]
{
	if (random() < 0.2)
	{
		sound(self, CHAN_VOICE, "kungfu.wav", 1, ATTN_IDLE);
	}
	ai_stand();
};

void() manga_stand6 = [6, manga_stand7]
{
	ai_stand();
};

void() manga_stand7 = [7, manga_stand8]
{
	ai_stand();
};

void() manga_stand8 = [8, manga_stand1]
{
	ai_stand();
};

void() manga_walk1 = [9, manga_walk2]
{
	ai_walk(FL_SWIM);
};

void() manga_walk2 = [10, manga_walk3]
{
	ai_walk(FL_SWIM);
};

void() manga_walk3 = [11, manga_walk4]
{
	ai_walk(FL_SWIM);
	if (random() < 0.2)
	{
		sound(self, CHAN_VOICE, "kungfu.wav", 1, ATTN_IDLE);
	}
};

void() manga_walk4 = [12, manga_walk5]
{
	ai_walk(FL_SWIM);
};

void() manga_walk5 = [13, manga_walk6]
{
	ai_walk(FL_SWIM);
};

void() manga_walk6 = [14, manga_walk7]
{
	ai_walk(MOVETYPE_FLY);
	if (random() < 0.1)
	{
		sound(self, CHAN_VOICE, "hiyaa.wav", 1, ATTN_IDLE);
	}
};

void() manga_walk7 = [15, manga_walk8]
{
	ai_walk(FL_SWIM);
};

void() manga_walk8 = [16, manga_walk9]
{
	ai_walk(FL_SWIM);
};

void() manga_walk9 = [17, manga_walk10]
{
	ai_walk(FL_SWIM);
};

void() manga_walk10 = [18, manga_walk11]
{
	ai_walk(FL_SWIM);
};

void() manga_walk11 = [19, manga_walk12]
{
	ai_walk(FL_SWIM);
};

void() manga_walk12 = [20, manga_walk13]
{
	ai_walk(FL_SWIM);
};

void() manga_walk13 = [21, manga_walk14]
{
	ai_walk(FL_SWIM);
};

void() manga_walk14 = [22, manga_walk15]
{
	ai_walk(FL_SWIM);
};

void() manga_walk15 = [23, manga_walk16]
{
	ai_walk(FL_SWIM);
};

void() manga_walk16 = [24, manga_walk17]
{
	ai_walk(FL_SWIM);
};

void() manga_walk17 = [25, manga_walk18]
{
	ai_walk(FL_SWIM);
};

void() manga_walk18 = [26, manga_walk1]
{
	ai_walk(FL_SWIM);
};

void() manga_run1 = [9, manga_run2]
{
	ai_run(MOVETYPE_FLYMISSILE);
	if (random() < 0.2)
	{
		sound(self, CHAN_VOICE, "ohdju.wav", 1, ATTN_IDLE);
	}
};

void() manga_run2 = [11, manga_run3]
{
	ai_run(SHALRATH);
};

void() manga_run3 = [13, manga_run4]
{
	ai_run(FL_CLIENT);
};

void() manga_run4 = [15, manga_run5]
{
	ai_run(LAVAMAN);
};

void() manga_run5 = [17, manga_run6]
{
	ai_run(FL_INWATER);
};

void() manga_run6 = [19, manga_run7]
{
	ai_run(MOVETYPE_STEP);
};

void() manga_run7 = [21, manga_run8]
{
	ai_run(SHAMBLER);
};

void() manga_run8 = [23, manga_run9]
{
	ai_run(FISH);
};

void() manga_run9 = [25, manga_run1]
{
	ai_run(FISH);
};

void() manga_swing1 = [27, manga_swing2]
{
	ai_charge(MOVETYPE_BOUNCEMISSILE);
	sound(self, CHAN_WEAPON, "hiyaa.wav", 1, ATTN_NORM);
};

void() manga_swing2 = [28, manga_swing3]
{
	ai_charge(1);
};

void() manga_swing3 = [29, manga_swing4]
{
	ai_charge(MOVETYPE_STEP);
};

void() manga_swing4 = [30, manga_swing5]
{
	ai_charge(SHAMBLER);
};

void() manga_swing5 = [31, manga_swing6]
{
	ai_charge(MOVETYPE_FLYMISSILE);
	highkick(0);
	self.angles_y = self.angles_y + random() * 25;
};

void() manga_swing6 = [32, manga_swing7]
{
	highkick(MAX_CHARMER_DISTANCE);
	self.angles_y = self.angles_y + random() * 25;
};

void() manga_swing7 = [33, manga_swing8]
{
	highkick(0);
	self.angles_y = self.angles_y + random() * 25;
};

void() manga_swing8 = [34, manga_swing9]
{
	highkick(0);
	self.angles_y = self.angles_y + random() * 25;
};

void() manga_swing9 = [35, manga_swing10]
{
	highkick(0);
	self.angles_y = self.angles_y + random() * 25;
};

void() manga_swing10 = [36, manga_swing11]
{
	highkick(-200);
	self.angles_y = self.angles_y + random() * 25;
};

void() manga_swing11 = [37, manga_swing12]
{
	highkick(0);
	self.angles_y = self.angles_y + random() * 25;
};

void() manga_swing12 = [38, manga_swing13]
{
	ai_charge(MOVETYPE_WALK);
};

void() manga_swing13 = [39, manga_swing14]
{
	ai_charge(FL_CLIENT);
};

void() manga_swing14 = [40, manga_run1]
{
	ai_charge(MOVETYPE_FLYMISSILE);
};

void() manga_smash1 = [27, manga_smash2]
{
	ai_charge(MOVETYPE_TOSS);
};

void() manga_smash2 = [28, manga_smash3]
{
	ai_charge(0);
};

void() manga_smash3 = [29, manga_smash4]
{
	ai_charge(0);
};

void() manga_smash4 = [30, manga_smash5]
{
	ai_charge(1);
	sound(self, CHAN_WEAPON, "tchak.wav", 1, ATTN_NORM);
};

void() manga_smash5 = [31, manga_smash6]
{
	ai_charge(MOVETYPE_STEP);
};

void() manga_smash6 = [32, manga_smash7]
{
	ai_charge(MOVETYPE_STEP);
	highkick(0);
};

void() manga_smash7 = [33, manga_smash8]
{
	ai_charge(MOVETYPE_STEP);
	highkick(0);
};

void() manga_smash8 = [34, manga_smash9]
{
	ai_charge(MOVETYPE_BOUNCE);
	highkick(0);
};

void() manga_smash9 = [35, manga_smash10]
{
	ai_charge(SHAMBLER);
	highkick(0);
};

void() manga_smash10 = [36, manga_smash11]
{
	highkick(1);
};

void() manga_smash11 = [37, manga_smash12]
{
	ai_charge(FL_SWIM);
	highkick(0);
	self.nextthink = self.nextthink + random() * 0.2;
};

void() manga_smash12 = [38, manga_smash13]
{
	ai_charge();
};

void() manga_smash13 = [39, manga_smash14]
{
	ai_charge(MOVETYPE_STEP);
};

void() manga_smash14 = [40, manga_run1]
{
	ai_charge(SHALRATH);
};

void() manga_nail1 = [42, manga_nail2]
{
	ai_face();
};

void() manga_nail2 = [43, manga_nail3]
{
	ai_face();
};

void() manga_nail3 = [44, manga_nail4]
{
	ai_face();
};

void() manga_nail4 = [45, manga_nail5]
{
	ai_face();
};

void() manga_nail5 = [46, manga_nail6]
{
	ai_face();
};

void() manga_nail6 = [47, manga_nail7]
{
	ai_face();
};

void() manga_nail7 = [48, manga_nail8]
{
	ai_face();
};

void() manga_nail8 = [49, manga_nail9]
{
	ai_face();
	mangaFireGrenade();
};

void() manga_nail9 = [50, manga_nail10]
{
	ai_face();
};

void() manga_nail10 = [51, manga_run1]
{
	ai_face();
};

void() manga_pain1 = [53, manga_pain2]
{
};

void() manga_pain2 = [54, manga_pain3]
{
};

void() manga_pain3 = [55, manga_pain4]
{
};

void() manga_pain4 = [56, manga_pain5]
{
};

void() manga_pain5 = [57, manga_pain6]
{
};

void() manga_pain6 = [58, manga_run1]
{
};

void(entity attacker, float damage) manga_pain = 
{
	local float r;
	if (self.pain_finished > time)
	{
		return;
	}
	sound(self, CHAN_VOICE, "ha.wav", 1, ATTN_NORM);
	manga_pain1();
	self.pain_finished = time + 1;
};

void() manga_die1 = [59, manga_die2]
{
};

void() manga_die2 = [60, manga_die3]
{
};

void() manga_die3 = [61, manga_die4]
{
	self.solid = SOLID_NOT;
	self.ammo_rockets = FL_SWIM;
	DropBackpack();
};

void() manga_die4 = [62, manga_die5]
{
};

void() manga_die5 = [63, manga_die6]
{
};

void() manga_die6 = [64, manga_die7]
{
};

void() manga_die7 = [65, manga_die8]
{
};

void() manga_die8 = [66, manga_die9]
{
};

void() manga_die9 = [67, manga_die10]
{
};

void() manga_die10 = [68, manga_die11]
{
};

void() manga_die11 = [69, manga_die12]
{
};

void() manga_die12 = [70, manga_die13]
{
};

void() manga_die13 = [71, manga_die14]
{
};

void() manga_die14 = [72, manga_die15]
{
};

void() manga_die15 = [73, manga_die16]
{
};

void() manga_die16 = [74, manga_die17]
{
};

void() manga_die17 = [75, manga_die18]
{
};

void() manga_die18 = [76, manga_die18]
{
};

void() manga_die = 
{
	if (self.health < -80)
	{
		sound(self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		ThrowHead("progs/gib3.mdl", self.health);
		ThrowGib("progs/gib3.mdl", self.health);
		ThrowGib("progs/gib3.mdl", self.health);
		ThrowGib("progs/gib3.mdl", self.health);
		return;
	}
	sound(self, CHAN_VOICE, "died.wav", 1, ATTN_NORM);
	manga_die1();
};

void() manga_melee = 
{
	if (random() > 0.5)
	{
		manga_smash1();
	}
	else
	{
		manga_swing1();
	}
};

void() monster_manga = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	self.monster_type = MANGA;
	precache_model("progs/manga3.mdl");
	precache_model("progs/h_ogre.mdl");
	precache_model("progs/grenade.mdl");
	precache_sound("hiyaa.wav");
	precache_sound("tchak.wav");
	precache_sound("kungfu.wav");
	precache_sound("ohdju.wav");
	precache_sound("ha.wav");
	precache_sound("died.wav");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/manga3.mdl");
	setsize(self, '-20 -20 0', '20 20 80');
	self.health = 250;
	self.th_stand = manga_stand1;
	self.th_walk = manga_walk1;
	self.th_run = manga_run1;
	self.th_die = manga_die;
	self.th_melee = manga_melee;
	self.th_missile = manga_nail1;
	self.th_pain = manga_pain;
	walkmonster_start();
};


void() OgreGrenadeExplode = 
{
	T_RadiusDamage(self, self.owner, 40, world);
	sound(self, CHAN_VOICE, "weapons/r_exp3.wav", WEAPON_SHOTGUN, ATTN_NORM);
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

void() OgreGrenadeTouch = 
{
	if (other == self.owner)
	{
		return;
	}
	if (other.takedamage == DAMAGE_AIM)
	{
		OgreGrenadeExplode();
		return;
	}
	sound(self, CHAN_VOICE, "weapons/bounce.wav", WEAPON_SHOTGUN, ATTN_NORM);
	if (self.velocity == VEC_ORIGIN)
	{
		self.avelocity = VEC_ORIGIN;
	}
};

void() OgreFireGrenade = 
{
	local entity missile;
	local entity mpuff;
	self.effects = self.effects | EF_MUZZLEFLASH;
	sound(self, CHAN_WEAPON, "weapons/grenade.wav", WEAPON_SHOTGUN, ATTN_NORM);
	missile = spawn();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
	makevectors(self.angles);
	missile.velocity = normalize(self.enemy.origin - self.origin);
	missile.velocity = missile.velocity * 600;
	missile.velocity_z = 200;
	missile.avelocity = '300 300 300';
	missile.angles = vectoangles(missile.velocity);
	missile.touch = OgreGrenadeTouch;
	missile.nextthink = time + 2.5;
	missile.think = OgreGrenadeExplode;
	setmodel(missile, "progs/grenade.mdl");
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(missile, self.origin);
};

void(float side) chainsaw = 
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
	ai_charge(TE_LAVASPLASH);
	delta = self.enemy.origin - self.origin;
	if (vlen(delta) > 100)
	{
		return;
	}
	random();
	ldmg = (random() + random() + random()) * DOOR_DONT_LINK;
	T_Damage(self.enemy, self, self, ldmg);
	if (side)
	{
		makevectors(self.angles);
		if (side == WEAPON_SHOTGUN)
		{
			SpawnMeatSpray(self.origin + v_forward * SECRET_YES_SHOOT, crandom() * 100 * v_right);
		}
		else
		{
			SpawnMeatSpray(self.origin + v_forward * SECRET_YES_SHOOT, side * v_right);
		}
	}
};

void() ogre_stand1 = [0, ogre_stand2]
{
	ai_stand();
};

void() ogre_stand2 = [1, ogre_stand3]
{
	ai_stand();
};

void() ogre_stand3 = [2, ogre_stand4]
{
	ai_stand();
};

void() ogre_stand4 = [3, ogre_stand5]
{
	ai_stand();
};

void() ogre_stand5 = [4, ogre_stand6]
{
	if (random() < 0.2)
	{
		sound(self, CHAN_VOICE, "ogre/ogidle.wav", WEAPON_SHOTGUN, ATTN_IDLE);
	}
	ai_stand();
};

void() ogre_stand6 = [5, ogre_stand7]
{
	ai_stand();
};

void() ogre_stand7 = [6, ogre_stand8]
{
	ai_stand();
};

void() ogre_stand8 = [7, ogre_stand9]
{
	ai_stand();
};

void() ogre_stand9 = [8, ogre_stand1]
{
	ai_stand();
};

void() ogre_walk1 = [9, ogre_walk2]
{
	ai_walk(AS_MELEE);
};

void() ogre_walk2 = [10, ogre_walk3]
{
	ai_walk(SPAWNFLAG_LASER);
};

void() ogre_walk3 = [11, ogre_walk4]
{
	ai_walk(SPAWNFLAG_LASER);
	if (random() < 0.2)
	{
		sound(self, CHAN_VOICE, "ogre/ogidle.wav", WEAPON_SHOTGUN, ATTN_IDLE);
	}
};

void() ogre_walk4 = [12, ogre_walk5]
{
	ai_walk(SPAWNFLAG_LASER);
};

void() ogre_walk5 = [13, ogre_walk6]
{
	ai_walk(SPAWNFLAG_LASER);
};

void() ogre_walk6 = [14, ogre_walk7]
{
	ai_walk(TE_LIGHTNING1);
	if (random() < 0.1)
	{
		sound(self, CHAN_VOICE, "ogre/ogdrag.wav", WEAPON_SHOTGUN, ATTN_IDLE);
	}
};

void() ogre_walk7 = [15, ogre_walk8]
{
	ai_walk(AS_MELEE);
};

void() ogre_walk8 = [16, ogre_walk9]
{
	ai_walk(SPAWNFLAG_LASER);
};

void() ogre_walk9 = [17, ogre_walk10]
{
	ai_walk(AS_MELEE);
};

void() ogre_walk10 = [18, ogre_walk11]
{
	ai_walk(WEAPON_SHOTGUN);
};

void() ogre_walk11 = [19, ogre_walk12]
{
	ai_walk(SPAWNFLAG_LASER);
};

void() ogre_walk12 = [20, ogre_walk13]
{
	ai_walk(AS_MELEE);
};

void() ogre_walk13 = [21, ogre_walk14]
{
	ai_walk(AS_MELEE);
};

void() ogre_walk14 = [22, ogre_walk15]
{
	ai_walk(AS_MELEE);
};

void() ogre_walk15 = [23, ogre_walk16]
{
	ai_walk(AS_MELEE);
};

void() ogre_walk16 = [24, ogre_walk1]
{
	ai_walk(DOOR_DONT_LINK);
};

void() ogre_run1 = [25, ogre_run2]
{
	ai_run(TE_LIGHTNING3);
	if (random() < 0.2)
	{
		sound(self, CHAN_VOICE, "ogre/ogidle2.wav", WEAPON_SHOTGUN, ATTN_IDLE);
	}
};

void() ogre_run2 = [26, ogre_run3]
{
	ai_run(12);
};

void() ogre_run3 = [27, ogre_run4]
{
	ai_run(SECRET_NO_SHOOT);
};

void() ogre_run4 = [28, ogre_run5]
{
	ai_run(22);
};

void() ogre_run5 = [29, ogre_run6]
{
	ai_run(SECRET_YES_SHOOT);
};

void() ogre_run6 = [30, ogre_run7]
{
	ai_run(DOOR_DONT_LINK);
};

void() ogre_run7 = [31, ogre_run8]
{
	ai_run(13);
};

void() ogre_run8 = [32, ogre_run1]
{
	ai_run(24);
};

void() ogre_swing1 = [33, ogre_swing2]
{
	ai_charge(TE_TELEPORT);
	sound(self, CHAN_WEAPON, "ogre/ogsawatk.wav", WEAPON_SHOTGUN, ATTN_NORM);
};

void() ogre_swing2 = [34, ogre_swing3]
{
	ai_charge(WEAPON_SHOTGUN);
};

void() ogre_swing3 = [35, ogre_swing4]
{
	ai_charge(DOOR_DONT_LINK);
};

void() ogre_swing4 = [36, ogre_swing5]
{
	ai_charge(13);
};

void() ogre_swing5 = [37, ogre_swing6]
{
	ai_charge(TE_LIGHTNING3);
	chainsaw(MSG_BROADCAST);
	self.angles_y = self.angles_y + random() * 25;
};

void() ogre_swing6 = [38, ogre_swing7]
{
	chainsaw(200);
	self.angles_y = self.angles_y + random() * 25;
};

void() ogre_swing7 = [39, ogre_swing8]
{
	chainsaw(MSG_BROADCAST);
	self.angles_y = self.angles_y + random() * 25;
};

void() ogre_swing8 = [40, ogre_swing9]
{
	chainsaw(MSG_BROADCAST);
	self.angles_y = self.angles_y + random() * 25;
};

void() ogre_swing9 = [41, ogre_swing10]
{
	chainsaw(MSG_BROADCAST);
	self.angles_y = self.angles_y + random() * 25;
};

void() ogre_swing10 = [42, ogre_swing11]
{
	chainsaw(-200);
	self.angles_y = self.angles_y + random() * 25;
};

void() ogre_swing11 = [43, ogre_swing12]
{
	chainsaw(MSG_BROADCAST);
	self.angles_y = self.angles_y + random() * 25;
};

void() ogre_swing12 = [44, ogre_swing13]
{
	ai_charge(AS_MELEE);
};

void() ogre_swing13 = [45, ogre_swing14]
{
	ai_charge(SECRET_NO_SHOOT);
};

void() ogre_swing14 = [46, ogre_zcheck]
{
	ai_charge(TE_LIGHTNING3);
};

void() ogre_smash1 = [47, ogre_smash2]
{
	ai_charge(TE_LIGHTNING2);
	sound(self, CHAN_WEAPON, "ogre/ogsawatk.wav", WEAPON_SHOTGUN, ATTN_NORM);
};

void() ogre_smash2 = [48, ogre_smash3]
{
	ai_charge(MSG_BROADCAST);
};

void() ogre_smash3 = [49, ogre_smash4]
{
	ai_charge(MSG_BROADCAST);
};

void() ogre_smash4 = [50, ogre_smash5]
{
	ai_charge(WEAPON_SHOTGUN);
};

void() ogre_smash5 = [51, ogre_smash6]
{
	ai_charge(DOOR_DONT_LINK);
};

void() ogre_smash6 = [52, ogre_smash7]
{
	ai_charge(DOOR_DONT_LINK);
	chainsaw(MSG_BROADCAST);
};

void() ogre_smash7 = [53, ogre_smash8]
{
	ai_charge(DOOR_DONT_LINK);
	chainsaw(MSG_BROADCAST);
};

void() ogre_smash8 = [54, ogre_smash9]
{
	ai_charge(TE_LAVASPLASH);
	chainsaw(MSG_BROADCAST);
};

void() ogre_smash9 = [55, ogre_smash10]
{
	ai_charge(13);
	chainsaw(MSG_BROADCAST);
};

void() ogre_smash10 = [56, ogre_smash11]
{
	chainsaw(WEAPON_SHOTGUN);
};

void() ogre_smash11 = [57, ogre_smash12]
{
	ai_charge(SPAWNFLAG_LASER);
	chainsaw(MSG_BROADCAST);
	self.nextthink = self.nextthink + random() * 0.2;
};

void() ogre_smash12 = [58, ogre_smash13]
{
	ai_charge();
};

void() ogre_smash13 = [59, ogre_smash14]
{
	ai_charge(DOOR_DONT_LINK);
};

void() ogre_smash14 = [60, ogre_zcheck]
{
	ai_charge(12);
};

void() ogre_retreatcheck = 
{
	local float dist;
	dist = vlen(self.pos1 - self.enemy.origin);
	if (dist > 1000)
	{
		self.ammo_cells = MSG_BROADCAST;
		remove(self.goalentity);
		self.goalentity = self.enemy;
		ogre_run1();
	}
	else
	{
		ogre_retreat1();
	}
};

void() ogre_retreat1 = [25, ogre_retreat2]
{
	ai_run(TE_LIGHTNING3);
	if (random() < 0.2)
	{
		sound(self, CHAN_VOICE, "ogre/ogidle2.wav", WEAPON_SHOTGUN, ATTN_IDLE);
	}
};

void() ogre_retreat2 = [26, ogre_retreat3]
{
	ai_run(12);
};

void() ogre_retreat3 = [27, ogre_retreat4]
{
	ai_run(SECRET_NO_SHOOT);
};

void() ogre_retreat4 = [28, ogre_retreat5]
{
	ai_run(22);
};

void() ogre_retreat5 = [29, ogre_retreat6]
{
	ai_run(SECRET_YES_SHOOT);
};

void() ogre_retreat6 = [30, ogre_retreat7]
{
	ai_run(DOOR_DONT_LINK);
};

void() ogre_retreat7 = [31, ogre_retreat8]
{
	ai_run(13);
};

void() ogre_retreat8 = [32, ogre_retreatcheck]
{
	ai_run(24);
};

void() runtargthink = 
{
	local vector randvect;
	randvect_x = random() - 0.5;
	randvect_y = random() - 0.5;
	randvect_z = random() - 0.5;
	randvect = 1000 * normalize(randvect);
	setorigin(self, self.origin + randvect);
	self.nextthink = time + TE_LIGHTNING1;
};

void() ogre_zcheck = 
{
	local vector dir;
	local float randnumb;
	if (self.ammo_cells)
	{
		ogre_retreat1();
		return;
	}
	randnumb = IT_LIGHTNING * random() + DOOR_TOGGLE;
	if (self.enemy.origin_z - self.origin_z > randnumb)
	{
		self.pos1 = self.enemy.origin;
		self.goalentity = spawn();
		self.goalentity.owner = self;
		self.goalentity.movetype = MOVETYPE_FLY;
		self.goalentity.solid = SOLID_NOT;
		self.goalentity.classname = "runtarg";
		self.goalentity.nextthink = time + TE_LIGHTNING1;
		self.goalentity.think = runtargthink;
		setsize(self.goalentity, VEC_ORIGIN, VEC_ORIGIN);
		dir = self.enemy.origin - self.origin;
		dir_z = MSG_BROADCAST;
		dir = 1000 * normalize(dir);
		setorigin(self.goalentity, self.origin + dir);
		self.ammo_cells = WEAPON_SHOTGUN;
		ogre_retreat1();
	}
	else
	{
		ogre_run1();
	}
};

void() ogre_nail1 = [61, ogre_nail2]
{
	ai_face();
};

void() ogre_nail2 = [62, ogre_nail3]
{
	ai_face();
};

void() ogre_nail3 = [62, ogre_nail4]
{
	ai_face();
};

void() ogre_nail4 = [63, ogre_nail5]
{
	ai_face();
	OgreFireGrenade();
};

void() ogre_nail5 = [64, ogre_nail6]
{
	ai_face();
};

void() ogre_nail6 = [65, ogre_nail7]
{
	ai_face();
};

void() ogre_nail7 = [66, ogre_zcheck]
{
	ai_face();
};

void() ogre_paincheck = 
{
	if (self.ammo_cells)
	{
		ogre_retreat1();
	}
	else
	{
		ogre_run1();
	}
};

void() ogre_pain1 = [67, ogre_pain2]
{
};

void() ogre_pain2 = [68, ogre_pain3]
{
};

void() ogre_pain3 = [69, ogre_pain4]
{
};

void() ogre_pain4 = [70, ogre_pain5]
{
};

void() ogre_pain5 = [71, ogre_paincheck]
{
};

void() ogre_painb1 = [72, ogre_painb2]
{
};

void() ogre_painb2 = [73, ogre_painb3]
{
};

void() ogre_painb3 = [74, ogre_paincheck]
{
};

void() ogre_painc1 = [75, ogre_painc2]
{
};

void() ogre_painc2 = [76, ogre_painc3]
{
};

void() ogre_painc3 = [77, ogre_painc4]
{
};

void() ogre_painc4 = [78, ogre_painc5]
{
};

void() ogre_painc5 = [79, ogre_painc6]
{
};

void() ogre_painc6 = [80, ogre_paincheck]
{
};

void() ogre_paind1 = [81, ogre_paind2]
{
};

void() ogre_paind2 = [82, ogre_paind3]
{
	ai_pain(TE_LAVASPLASH);
};

void() ogre_paind3 = [83, ogre_paind4]
{
	ai_pain(TE_LIGHTNING3);
};

void() ogre_paind4 = [84, ogre_paind5]
{
	ai_pain(SECRET_1ST_DOWN);
};

void() ogre_paind5 = [85, ogre_paind6]
{
};

void() ogre_paind6 = [86, ogre_paind7]
{
};

void() ogre_paind7 = [87, ogre_paind8]
{
};

void() ogre_paind8 = [88, ogre_paind9]
{
};

void() ogre_paind9 = [89, ogre_paind10]
{
};

void() ogre_paind10 = [90, ogre_paind11]
{
};

void() ogre_paind11 = [91, ogre_paind12]
{
};

void() ogre_paind12 = [92, ogre_paind13]
{
};

void() ogre_paind13 = [93, ogre_paind14]
{
};

void() ogre_paind14 = [94, ogre_paind15]
{
};

void() ogre_paind15 = [95, ogre_paind16]
{
};

void() ogre_paind16 = [96, ogre_paincheck]
{
};

void() ogre_paine1 = [97, ogre_paine2]
{
};

void() ogre_paine2 = [98, ogre_paine3]
{
	ai_pain(TE_LAVASPLASH);
};

void() ogre_paine3 = [99, ogre_paine4]
{
	ai_pain(TE_LIGHTNING3);
};

void() ogre_paine4 = [100, ogre_paine5]
{
	ai_pain(SECRET_1ST_DOWN);
};

void() ogre_paine5 = [101, ogre_paine6]
{
};

void() ogre_paine6 = [102, ogre_paine7]
{
};

void() ogre_paine7 = [103, ogre_paine8]
{
};

void() ogre_paine8 = [104, ogre_paine9]
{
};

void() ogre_paine9 = [105, ogre_paine10]
{
};

void() ogre_paine10 = [106, ogre_paine11]
{
};

void() ogre_paine11 = [107, ogre_paine12]
{
};

void() ogre_paine12 = [108, ogre_paine13]
{
};

void() ogre_paine13 = [109, ogre_paine14]
{
};

void() ogre_paine14 = [110, ogre_paine15]
{
};

void() ogre_paine15 = [111, ogre_paincheck]
{
};

void(entity attacker, float damage) ogre_pain = 
{
	local float r;
	if (self.pain_finished > time)
	{
		return;
	}
	sound(self, CHAN_VOICE, "ogre/ogpain1.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
	r = random();
	if (r < 0.25)
	{
		ogre_pain1();
		self.pain_finished = time + SPAWNFLAG_SUPERSPIKE;
	}
	else
	{
		if (r < 0.5)
		{
			ogre_painb1();
			self.pain_finished = time + SPAWNFLAG_SUPERSPIKE;
		}
		else
		{
			if (r < 0.75)
			{
				ogre_painc1();
				self.pain_finished = time + SPAWNFLAG_SUPERSPIKE;
			}
			else
			{
				if (r < 0.88)
				{
					ogre_paind1();
					self.pain_finished = time + SPAWNFLAG_LASER;
				}
				else
				{
					ogre_paine1();
					self.pain_finished = time + SPAWNFLAG_LASER;
				}
			}
		}
	}
};

void() ogre_die1 = [112, ogre_die2]
{
};

void() ogre_die2 = [113, ogre_die3]
{
};

void() ogre_die3 = [114, ogre_die4]
{
	self.solid = SOLID_NOT;
	self.ammo_rockets = SPAWNFLAG_LASER;
	DropBackpack();
};

void() ogre_die4 = [115, ogre_die5]
{
};

void() ogre_die5 = [116, ogre_die6]
{
};

void() ogre_die6 = [117, ogre_die7]
{
};

void() ogre_die7 = [118, ogre_die8]
{
};

void() ogre_die8 = [119, ogre_die9]
{
};

void() ogre_die9 = [120, ogre_die10]
{
};

void() ogre_die10 = [121, ogre_die11]
{
};

void() ogre_die11 = [122, ogre_die12]
{
};

void() ogre_die12 = [123, ogre_die13]
{
};

void() ogre_die13 = [124, ogre_die14]
{
};

void() ogre_die14 = [125, ogre_die14]
{
};

void() ogre_bdie1 = [126, ogre_bdie2]
{
};

void() ogre_bdie2 = [127, ogre_bdie3]
{
	ai_forward(TE_LIGHTNING1);
};

void() ogre_bdie3 = [128, ogre_bdie4]
{
	self.solid = SOLID_NOT;
	self.ammo_rockets = SPAWNFLAG_LASER;
	DropBackpack();
};

void() ogre_bdie4 = [129, ogre_bdie5]
{
	ai_forward(SPAWNFLAG_SUPERSPIKE);
};

void() ogre_bdie5 = [130, ogre_bdie6]
{
	ai_forward(AS_MELEE);
};

void() ogre_bdie6 = [131, ogre_bdie7]
{
	ai_forward(TE_WIZSPIKE);
};

void() ogre_bdie7 = [132, ogre_bdie8]
{
	ai_forward(25);
};

void() ogre_bdie8 = [133, ogre_bdie9]
{
};

void() ogre_bdie9 = [134, ogre_bdie10]
{
};

void() ogre_bdie10 = [135, ogre_bdie10]
{
};

void() ogre_die = 
{
	if (self.health < -80)
	{
		sound(self, CHAN_VOICE, "player/udeath.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
		ThrowHead("progs/h_ogre.mdl", self.health);
		ThrowGib("progs/gib3.mdl", self.health);
		ThrowGib("progs/gib3.mdl", self.health);
		ThrowGib("progs/gib3.mdl", self.health);
		return;
	}
	sound(self, CHAN_VOICE, "ogre/ogdth.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
	self.ammo_cells = MSG_BROADCAST;
	if (random() < 0.5)
	{
		ogre_die1();
	}
	else
	{
		ogre_bdie1();
	}
};

void() ogre_melee = 
{
	if (random() > 0.5)
	{
		ogre_smash1();
	}
	else
	{
		ogre_swing1();
	}
};

void() monster_ogre = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model("progs/ogre.mdl");
	precache_model("progs/h_ogre.mdl");
	precache_model("progs/grenade.mdl");
	precache_sound("ogre/ogdrag.wav");
	precache_sound("ogre/ogdth.wav");
	precache_sound("ogre/ogidle.wav");
	precache_sound("ogre/ogidle2.wav");
	precache_sound("ogre/ogpain1.wav");
	precache_sound("ogre/ogsawatk.wav");
	precache_sound("ogre/ogwake.wav");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/ogre.mdl");
	setsize(self, VEC_HULL2_MIN, VEC_HULL2_MAX);
	self.health = 200;
	self.th_stand = ogre_stand1;
	self.th_walk = ogre_walk1;
	self.th_run = ogre_run1;
	self.th_die = ogre_die;
	self.th_melee = ogre_melee;
	self.th_missile = ogre_nail1;
	self.th_pain = ogre_pain;
	self.wad = "monster";
	walkmonster_start();
};

void() monster_ogre_marksman = 
{
	monster_ogre();
};


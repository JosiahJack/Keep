void() hellknight_block1 = [9, hellknight_block1]
{
	if (!(self.enemy.owner))
	{
		return;
	}
	if (self.enemy.owner.attack_finished < time && (self.flags & FL_ONGROUND))
	{
		hellknight_run1();
		return;
	}
	self.block_finished = time + 0.15;
	self.nextthink = time + 0.1;
};

void() hellknight_stand1 = [0, hellknight_stand2]
{
	ai_stand();
};

void() hellknight_stand2 = [1, hellknight_stand3]
{
	ai_stand();
};

void() hellknight_stand3 = [2, hellknight_stand4]
{
	ai_stand();
};

void() hellknight_stand4 = [3, hellknight_stand5]
{
	ai_stand();
};

void() hellknight_stand5 = [4, hellknight_stand6]
{
	ai_stand();
};

void() hellknight_stand6 = [5, hellknight_stand7]
{
	ai_stand();
};

void() hellknight_stand7 = [6, hellknight_stand8]
{
	ai_stand();
};

void() hellknight_stand8 = [7, hellknight_stand9]
{
	ai_stand();
};

void() hellknight_stand9 = [8, hellknight_stand1]
{
	ai_stand();
};

void() hellknight_walk1 = [9, hellknight_walk2]
{
	ai_walk(IT_RELIC4);
};

void() hellknight_walk2 = [10, hellknight_walk3]
{
	ai_walk(IT_RELIC4);
};

void() hellknight_walk3 = [11, hellknight_walk4]
{
	ai_walk(IT_RELIC4);
};

void() hellknight_walk4 = [12, hellknight_walk5]
{
	ai_walk(IT_RELIC4);
};

void() hellknight_walk5 = [13, hellknight_walk6]
{
	ai_walk(IT_RELIC4);
};

void() hellknight_walk6 = [14, hellknight_walk7]
{
	ai_walk(IT_RELIC4);
};

void() hellknight_walk7 = [15, hellknight_walk8]
{
	ai_walk(IT_RELIC4);
};

void() hellknight_walk8 = [16, hellknight_walk9]
{
	ai_walk(IT_RELIC4);
};

void() hellknight_walk9 = [17, hellknight_walk10]
{
	ai_walk(IT_RELIC4);
};

void() hellknight_walk10 = [18, hellknight_walk11]
{
	ai_walk(IT_RELIC4);
};

void() hellknight_walk11 = [19, hellknight_walk12]
{
	ai_walk(IT_RELIC4);
};

void() hellknight_walk12 = [20, hellknight_walk13]
{
	ai_walk(IT_RELIC4);
};

void() hellknight_walk13 = [21, hellknight_walk14]
{
	ai_walk(IT_RELIC4);
};

void() hellknight_walk14 = [22, hellknight_walk15]
{
	ai_walk(IT_RELIC4);
};

void() hellknight_walk15 = [23, hellknight_walk16]
{
	ai_walk(IT_RELIC4);
};

void() hellknight_walk16 = [24, hellknight_walk17]
{
	ai_walk(IT_RELIC4);
};

void() hellknight_walk17 = [25, hellknight_walk18]
{
	ai_walk(IT_RELIC4);
};

void() hellknight_walk18 = [26, hellknight_walk19]
{
	ai_walk(IT_RELIC4);
};

void() hellknight_walk19 = [27, hellknight_walk20]
{
	ai_walk(IT_RELIC4);
};

void() hellknight_walk20 = [28, hellknight_walk1]
{
	ai_walk(IT_RELIC4);
};

void() hellknight_run1 = [29, hellknight_run2]
{
	ai_walk(SVC_LIGHTSTYLE);
};

void() hellknight_run2 = [30, hellknight_run3]
{
	ai_walk(SVC_LIGHTSTYLE);
};

void() hellknight_run3 = [31, hellknight_run4]
{
	ai_walk(SVC_LIGHTSTYLE);
};

void() hellknight_run4 = [32, hellknight_run5]
{
	ai_walk(SVC_LIGHTSTYLE);
};

void() hellknight_run5 = [33, hellknight_run6]
{
	ai_walk(SVC_LIGHTSTYLE);
};

void() hellknight_run6 = [34, hellknight_run7]
{
	ai_walk(SVC_LIGHTSTYLE);
};

void() hellknight_run7 = [35, hellknight_run8]
{
	ai_walk(SVC_LIGHTSTYLE);
};

void() hellknight_run8 = [36, hellknight_run1]
{
	ai_walk(SVC_LIGHTSTYLE);
};

void() hellknight_pain1 = [37, hellknight_pain2]
{
};

void() hellknight_pain2 = [38, hellknight_pain3]
{
};

void() hellknight_pain3 = [39, hellknight_pain4]
{
};

void() hellknight_pain4 = [40, hellknight_pain5]
{
};

void() hellknight_pain5 = [41, hellknight_walk1]
{
};

void() hellknight_pain = 
{
	if (random() < 0.5)
	{
		sound(self, CHAN_VOICE, "hknight/pain.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	}
	else
	{
		sound(self, CHAN_VOICE, "hknight/pain2.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	}
	hellknight_pain1();
	monster_pain(self.enemy);
};

void() hellknight_deatha1 = [42, hellknight_deatha2]
{
	monster_death();
};

void() hellknight_deatha2 = [43, hellknight_deatha3]
{
	monster_death();
};

void() hellknight_deatha3 = [44, hellknight_deatha4]
{
	monster_death();
};

void() hellknight_deatha4 = [45, hellknight_deatha5]
{
	monster_death();
};

void() hellknight_deatha5 = [46, hellknight_deatha6]
{
	monster_death();
};

void() hellknight_deatha6 = [47, hellknight_deatha7]
{
	monster_death();
};

void() hellknight_deatha7 = [48, hellknight_deatha8]
{
	monster_death();
};

void() hellknight_deatha8 = [49, hellknight_deatha9]
{
	monster_death();
};

void() hellknight_deatha9 = [50, hellknight_deatha10]
{
	monster_death();
};

void() hellknight_deatha10 = [51, hellknight_deatha11]
{
	monster_death();
};

void() hellknight_deatha11 = [52, hellknight_deatha12]
{
	monster_death();
};

void() hellknight_deatha12 = [53, hellknight_deatha12]
{
	monster_death();
};

void() hellknight_deathb1 = [54, hellknight_deathb2]
{
	monster_death();
};

void() hellknight_deathb2 = [55, hellknight_deathb3]
{
	monster_death();
};

void() hellknight_deathb3 = [56, hellknight_deathb4]
{
	monster_death();
};

void() hellknight_deathb4 = [57, hellknight_deathb5]
{
	monster_death();
};

void() hellknight_deathb5 = [58, hellknight_deathb6]
{
	monster_death();
};

void() hellknight_deathb6 = [59, hellknight_deathb7]
{
	monster_death();
};

void() hellknight_deathb7 = [60, hellknight_deathb8]
{
	monster_death();
};

void() hellknight_deathb8 = [61, hellknight_deathb9]
{
	monster_death();
};

void() hellknight_deathb9 = [62, hellknight_deathb9]
{
	monster_death();
};

void() hellknight_die = 
{
	if (self.gaveexp != 1)
	{
		self.movetype = MOVETYPE_TOSS;
		GiveExperience(85);
		self.gaveexp = 1;
		sound(self, CHAN_VOICE, "hknight/death.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	}
	if (self.damage_type == TE_LIGHTNING1)
	{
		sound(self, CHAN_BODY, "misc/guts.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
		ThrowBodyPart("progs/hknig_c1.mdl");
		ThrowBodyPart("progs/hknig_c2.mdl");
		remove(self);
		return;
	}
	if (self.knockback != IT_RELIC2 && self.knockback != AS_MELEE)
	{
		self.velocity = no;
	}
	if (random() < 0.5)
	{
		hellknight_deatha1();
	}
	else
	{
		hellknight_deathb1();
	}
};

void() hellknight_attacka1 = [63, hellknight_attacka2]
{
	ai_forward(TE_LIGHTNING1);
	frameskip(0.15);
};

void() hellknight_attacka2 = [64, hellknight_attacka3]
{
	ai_forward(TE_LIGHTNING1);
	frameskip(0.07);
};

void() hellknight_attacka3 = [65, hellknight_attacka4]
{
	ai_forward(TE_LIGHTNING1);
	frameskip(0.07);
};

void() hellknight_attacka4 = [66, hellknight_attacka5]
{
	ai_forward(TE_LIGHTNING1);
	frameskip(0.07);
	sound(self, CHAN_WEAPON, "hknight/swing.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
};

void() hellknight_attacka5 = [67, hellknight_attacka6]
{
	ai_forward(TE_LIGHTNING1);
	FireMelee(TE_LIGHTNING2, SVC_CLIENTDATA, STATE_TOP, 40, TE_LIGHTNING1, STATE_TOP, STATE_TOP);
};

void() hellknight_attacka6 = [68, hellknight_attacka7]
{
	ai_forward(TE_LIGHTNING1);
	frameskip(0.07);
};

void() hellknight_attacka7 = [69, hellknight_attacka8]
{
	ai_forward(TE_LIGHTNING1);
	frameskip(0.07);
};

void() hellknight_attacka8 = [70, hellknight_attacka9]
{
	ai_forward(TE_LIGHTNING1);
	frameskip(0.07);
};

void() hellknight_attacka9 = [71, hellknight_attacka10]
{
	ai_forward(TE_LIGHTNING1);
	frameskip(0.07);
};

void() hellknight_attacka10 = [72, hellknight_attacka11]
{
	ai_forward(TE_LIGHTNING1);
	frameskip(0.07);
	sound(self, CHAN_WEAPON, "hknight/swing.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
};

void() hellknight_attacka11 = [73, hellknight_attacka12]
{
	ai_forward(TE_LIGHTNING1);
	frameskip(0.07);
};

void() hellknight_attacka12 = [74, hellknight_attacka13]
{
	ai_forward(TE_LIGHTNING1);
	FireMelee(TE_LIGHTNING2, SVC_CLIENTDATA, AS_MELEE, 45, TE_LIGHTNING1, STATE_TOP, STATE_TOP);
};

void() hellknight_attacka13 = [75, hellknight_attacka14]
{
	ai_forward(TE_LIGHTNING1);
	frameskip(0.07);
};

void() hellknight_attacka14 = [76, hellknight_attacka15]
{
	ai_forward(TE_LIGHTNING1);
	frameskip(0.07);
};

void() hellknight_attacka15 = [77, hellknight_attacka16]
{
	ai_forward(TE_LIGHTNING1);
	frameskip(0.07);
};

void() hellknight_attacka16 = [78, hellknight_walk1]
{
	ai_forward(TE_LIGHTNING1);
	frameskip(0.07);
};

void() hellknight_attackb1 = [106, hellknight_attackb2]
{
	ai_forward(TE_LIGHTNING1);
	frameskip(0.15);
};

void() hellknight_attackb2 = [107, hellknight_attackb3]
{
	ai_forward(TE_LIGHTNING1);
	frameskip(0.07);
};

void() hellknight_attackb3 = [108, hellknight_attackb4]
{
	ai_forward(TE_LIGHTNING1);
	frameskip(0.07);
	sound(self, CHAN_WEAPON, "hknight/swing.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
};

void() hellknight_attackb4 = [109, hellknight_attackb5]
{
	ai_forward(TE_LIGHTNING1);
	frameskip(0.07);
};

void() hellknight_attackb5 = [110, hellknight_attackb6]
{
	ai_forward(TE_LIGHTNING1);
	FireMelee(TE_LAVASPLASH, SVC_CLIENTDATA, AS_MELEE, 45, TE_LIGHTNING1, STATE_TOP, STATE_TOP);
};

void() hellknight_attackb6 = [111, hellknight_walk1]
{
	ai_forward(TE_LIGHTNING1);
	frameskip(0.07);
};

void() hellknight_slice1 = [112, hellknight_slice2]
{
	ai_forward(TE_LIGHTNING1);
	frameskip(0.15);
};

void() hellknight_slice2 = [113, hellknight_slice3]
{
	ai_forward(TE_LIGHTNING1);
	frameskip(0.07);
};

void() hellknight_slice3 = [114, hellknight_slice4]
{
	ai_forward(TE_LIGHTNING1);
	frameskip(0.07);
};

void() hellknight_slice4 = [115, hellknight_slice5]
{
	ai_forward(TE_LIGHTNING1);
	frameskip(0.07);
};

void() hellknight_slice5 = [116, hellknight_slice6]
{
	FireMelee(TE_LIGHTNING2, SVC_SPAWNSTATIC, STATE_TOP, 35, STATE_TOP, STATE_TOP, STATE_TOP);
	sound(self, CHAN_WEAPON, "hknight/swing.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
};

void() hellknight_slice6 = [117, hellknight_slice7]
{
	FireMelee(IT_RELIC3, SVC_SPAWNSTATIC, STATE_TOP, 35, STATE_TOP, STATE_TOP, STATE_TOP);
};

void() hellknight_slice7 = [118, hellknight_slice8]
{
	FireMelee(AS_MELEE, SVC_SPAWNSTATIC, STATE_TOP, 35, STATE_TOP, STATE_TOP, STATE_TOP);
};

void() hellknight_slice8 = [119, hellknight_slice9]
{
	frameskip(0.05);
};

void() hellknight_slice9 = [120, hellknight_slice10]
{
	frameskip(0.07);
};

void() hellknight_slice10 = [121, hellknight_walk1]
{
	frameskip(0.07);
};

void() hellknight_smash1 = [122, hellknight_smash2]
{
	ai_forward(TE_LIGHTNING1);
	frameskip(0.15);
};

void() hellknight_smash2 = [123, hellknight_smash3]
{
	ai_forward(TE_LIGHTNING1);
	frameskip(0.07);
};

void() hellknight_smash3 = [124, hellknight_smash4]
{
	ai_forward(TE_LIGHTNING1);
	frameskip(0.07);
};

void() hellknight_smash4 = [125, hellknight_smash5]
{
	ai_forward(TE_LIGHTNING1);
	frameskip(0.07);
};

void() hellknight_smash5 = [126, hellknight_smash6]
{
	ai_forward(TE_LIGHTNING1);
	frameskip(0.07);
};

void() hellknight_smash6 = [127, hellknight_smash7]
{
	ai_forward(TE_LIGHTNING1);
	frameskip(0.07);
};

void() hellknight_smash7 = [128, hellknight_smash8]
{
	ai_forward(TE_LIGHTNING1);
	frameskip(0.07);
	sound(self, CHAN_WEAPON, "hknight/swing.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
};

void() hellknight_smash8 = [129, hellknight_smash9]
{
	ai_forward(TE_LIGHTNING1);
	FireMelee(TE_LIGHTNING1, SVC_CLIENTDATA, AS_MELEE, 45, TE_LIGHTNING1, STATE_TOP, STATE_TOP);
};

void() hellknight_smash9 = [130, hellknight_smash10]
{
	FireMelee(TE_LIGHTNING1, SVC_CLIENTDATA, AS_MELEE, 45, TE_LIGHTNING1, STATE_TOP, STATE_TOP);
};

void() hellknight_smash10 = [131, hellknight_smash11]
{
	frameskip(0.07);
};

void() hellknight_smash11 = [132, hellknight_walk1]
{
	frameskip(0.07);
};

void() hellknight_jump = [33, hellknight_jump]
{
	if (self.flags & FL_ONGROUND)
	{
		hellknight_walk1();
	}
};

void() hellknight_attack = 
{
	local float r;
	r = random();
	if (r < 0.25)
	{
		hellknight_attacka1();
	}
	else
	{
		if (r < 0.5)
		{
			hellknight_attackb1();
		}
		else
		{
			if (r < 0.75)
			{
				hellknight_slice1();
			}
			else
			{
				hellknight_smash1();
			}
		}
	}
};

void() hk_eball_think = 
{
	if (self.alpha > 0.010000)
	{
		self.alpha = self.alpha - 0.030000;
	}
	else
	{
		remove(self);
		return;
	}
	self.scale = self.scale + 0.010000;
	if (self.attack_finished < time)
	{
		self.angles_z = self.angles_z + random() * 360;
		self.attack_finished = time + 0.05;
	}
	frameskip(0.010000);
};

void() HellKnight_Lightning = 
{
	local vector org;
	local entity temp;
	local float r;
	makevectors(self.angles);
	sound(self, CHAN_WEAPON, "spells/thunder.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	MakeSolidList();
	org = self.origin + '0 0 20' + v_forward * 35;
	traceline(org, org + v_forward * 350, 0, self);
	if (trace_ent.takedamage)
	{
		temp = spawn();
		temp.movetype = MOVETYPE_NONE;
		temp.solid = SOLID_NOT;
		temp.classname = "sprite";
		temp.alpha = 0.5;
		if (r < 0.5)
		{
			temp.frame = STATE_TOP;
		}
		else
		{
			temp.frame = PLAT_LOW_TRIGGER;
		}
		temp.effects = EF_MUZZLEFLASH;
		temp.think = SUB_Remove;
		temp.nextthink = time + 0.1;
		setmodel(temp, "progs/lsprite.spr");
		setsize(temp, no, no);
		setorigin(temp, trace_ent.origin);
		if (trace_ent.block_finished < time)
		{
			T_Damage(trace_ent, self, self, TE_LIGHTNING1);
		}
		else
		{
			if (trace_ent.classname == "player")
			{
				if (self.angles_y > 90 && self.angles_y < 270)
				{
					trace_ent.angles_y = STATE_TOP;
				}
				else
				{
					trace_ent.angles_y = 180;
				}
			}
		}
		sound(trace_ent, CHAN_BODY, "weapons/lhit.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	}
	else
	{
		temp = spawn();
		temp.movetype = MOVETYPE_NONE;
		temp.solid = SOLID_NOT;
		temp.classname = "sprite";
		temp.alpha = 0.75;
		temp.effects = EF_MUZZLEFLASH;
		setmodel(temp, "progs/hk_eball.spr");
		setsize(temp, no, no);
		temp.origin_x = trace_endpos_x;
		temp.origin_y = trace_endpos_y;
		temp.origin_z = trace_endpos_z;
		temp.think = hk_eball_think;
		temp.alpha = PLAT_LOW_TRIGGER;
		temp.scale = PLAT_LOW_TRIGGER;
		temp.angles_y = -90;
		temp.nextthink = time;
	}
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_LIGHTNING1);
	WriteEntity(MSG_BROADCAST, self);
	WriteCoord(MSG_BROADCAST, org_x);
	WriteCoord(MSG_BROADCAST, org_y);
	WriteCoord(MSG_BROADCAST, org_z);
	WriteCoord(MSG_BROADCAST, trace_endpos_x);
	WriteCoord(MSG_BROADCAST, trace_endpos_y);
	WriteCoord(MSG_BROADCAST, trace_endpos_z);
	UnmakeSolidList();
};

void() hellknight_lightning1 = [93, hellknight_lightning2]
{
	if (random() < 0.5)
	{
		sound(self, CHAN_VOICE, "hknight/cast1.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	}
	else
	{
		sound(self, CHAN_VOICE, "hknight/cast2.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	}
	if (difficulty < IT_RELIC2)
	{
		self.nextthink = time + 0.4;
	}
	else
	{
		self.nextthink = time + 0.2;
	}
};

void() hellknight_lightning2 = [94, hellknight_lightning3]
{
};

void() hellknight_lightning3 = [95, hellknight_lightning4]
{
};

void() hellknight_lightning4 = [96, hellknight_lightning5]
{
};

void() hellknight_lightning5 = [97, hellknight_lightning6]
{
	HellKnight_Lightning();
};

void() hellknight_lightning6 = [98, hellknight_lightning7]
{
};

void() hellknight_lightning7 = [99, hellknight_lightning8]
{
};

void() hellknight_lightning8 = [100, hellknight_lightning9]
{
	if (difficulty < IT_RELIC2)
	{
		self.nextthink = time + 0.2;
	}
};

void() hellknight_lightning9 = [101, hellknight_lightning10]
{
};

void() hellknight_lightning10 = [102, hellknight_lightning11]
{
};

void() hellknight_lightning11 = [103, hellknight_lightning12]
{
	HellKnight_Lightning();
};

void() hellknight_lightning12 = [104, hellknight_lightning13]
{
};

void() hellknight_lightning13 = [105, hellknight_walk1]
{
};

void() hellknight_grabbed1 = [37, hellknight_grabbed2]
{
	self.grab_finished = time + 0.5;
};

void() hellknight_grabbed2 = [37, hellknight_grabbed2]
{
	if (self.grab_finished < time || self.grabbed == 0)
	{
		self.th_walk();
		return;
	}
};

void() monster_hell_knight = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model("progs/hknight.mdl");
	precache_model("progs/hknig_c1.mdl");
	precache_model("progs/hknig_c2.mdl");
	precache_model("progs/hk_eball.spr");
	precache_sound("hknight/death.wav");
	precache_sound("hknight/swing.wav");
	precache_sound("hknight/pain.wav");
	precache_sound("hknight/pain2.wav");
	precache_sound("hknight/cast1.wav");
	precache_sound("hknight/cast2.wav");
	precache_sound("spells/thunder.wav");
	precache_sound("knight/sword1.wav");
	precache_sound("knight/sword2.wav");
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/hknight.mdl");
	setsize(self, VEC_HULL_MIN, '16 16 40');
	if (difficulty < IT_RELIC2)
	{
		self.health = 220;
	}
	else
	{
		self.health = 330;
	}
	self.netname = "solid";
	self.takedamage = DAMAGE_AIM;
	self.solid = SOLID_NOT;
	self.classname = "hellknight";
	self.th_stand = hellknight_stand1;
	self.th_walk = hellknight_walk1;
	self.th_run = hellknight_run1;
	self.th_melee = hellknight_attack;
	self.th_magic = hellknight_lightning1;
	self.th_pain = hellknight_pain;
	self.th_die = hellknight_die;
	self.th_jump = hellknight_jump;
	self.th_grab = hellknight_grabbed1;
	self.th_block = hellknight_block1;
	if (!(self.ai_blockfreq))
	{
		if (difficulty == STATE_TOP)
		{
			self.ai_blockfreq = 0.05;
		}
		else
		{
			if (difficulty == PLAT_LOW_TRIGGER)
			{
				self.ai_blockfreq = 0.15;
			}
			else
			{
				self.ai_blockfreq = 0.3;
			}
		}
	}
	spawn_shadow();
	enemy_start();
};


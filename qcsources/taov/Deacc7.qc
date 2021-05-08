void() esquid_particle_think = 
{
	if (self.attack_finished < time)
	{
		remove(self);
	}
	particle(self.origin, no, 42, TE_LIGHTNING2);
	self.nextthink = time + 0.010000;
};

void() esquid_particle = 
{
	local entity spark;
	sound(self, CHAN_AUTO, "esquid/pain.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	spark = spawn();
	spark.angles_y = random() * 360;
	makevectors(spark.angles);
	spark.velocity = v_forward * 50;
	spark.velocity_z = 250;
	spark.owner = self;
	spark.movetype = MOVETYPE_BOUNCE;
	spark.solid = SOLID_NOT;
	spark.classname = "spark";
	setmodel(spark, string_null);
	setsize(spark, no, no);
	makevectors(self.angles);
	setorigin(spark, self.origin);
	spark.attack_finished = time + PLAT_LOW_TRIGGER;
	spark.think = esquid_particle_think;
	spark.nextthink = time + 0.010000;
};

void() esquid_stand1 = [30, esquid_stand1]
{
	ai_stand();
};

void() esquid_run1 = [30, esquid_run2]
{
	ai_walk(TE_LIGHTNING1);
};

void() esquid_run2 = [31, esquid_run3]
{
	ai_walk(TE_LIGHTNING1);
};

void() esquid_run3 = [32, esquid_run4]
{
	ai_walk(TE_LIGHTNING1);
};

void() esquid_run4 = [33, esquid_run5]
{
	ai_walk(TE_LIGHTNING1);
};

void() esquid_run5 = [34, esquid_run6]
{
	ai_walk(TE_LIGHTNING1);
};

void() esquid_run6 = [35, esquid_run7]
{
	ai_walk(TE_LIGHTNING1);
};

void() esquid_run7 = [36, esquid_run8]
{
	ai_walk(TE_LIGHTNING1);
};

void() esquid_run8 = [37, esquid_run9]
{
	ai_walk(TE_LIGHTNING1);
};

void() esquid_run9 = [38, esquid_run10]
{
	ai_walk(TE_LIGHTNING1);
};

void() esquid_run10 = [39, esquid_run11]
{
	ai_walk(TE_LIGHTNING1);
};

void() esquid_run11 = [40, esquid_run12]
{
	ai_walk(TE_LIGHTNING1);
};

void() esquid_run12 = [41, esquid_run13]
{
	ai_walk(TE_LIGHTNING1);
};

void() esquid_run13 = [42, esquid_run14]
{
	ai_walk(TE_LIGHTNING1);
};

void() esquid_run14 = [43, esquid_run15]
{
	ai_walk(TE_LIGHTNING1);
};

void() esquid_run15 = [44, esquid_run16]
{
	ai_walk(TE_LIGHTNING1);
};

void() esquid_run16 = [45, esquid_run17]
{
	ai_walk(TE_LIGHTNING1);
};

void() esquid_run17 = [46, esquid_run18]
{
	ai_walk(TE_LIGHTNING1);
};

void() esquid_run18 = [47, esquid_run19]
{
	ai_walk(TE_LIGHTNING1);
};

void() esquid_run19 = [48, esquid_run20]
{
	ai_walk(TE_LIGHTNING1);
};

void() esquid_run20 = [49, esquid_run21]
{
	ai_walk(TE_LIGHTNING1);
};

void() esquid_run21 = [50, esquid_run22]
{
	ai_walk(TE_LIGHTNING1);
};

void() esquid_run22 = [51, esquid_run23]
{
	ai_walk(TE_LIGHTNING1);
};

void() esquid_run23 = [52, esquid_run24]
{
	ai_walk(TE_LIGHTNING1);
};

void() esquid_run24 = [53, esquid_run25]
{
	ai_walk(TE_LIGHTNING1);
};

void() esquid_run25 = [54, esquid_run26]
{
	ai_walk(TE_LIGHTNING1);
};

void() esquid_run26 = [55, esquid_run27]
{
	ai_walk(TE_LIGHTNING1);
};

void() esquid_run27 = [56, esquid_run28]
{
	ai_walk(TE_LIGHTNING1);
};

void() esquid_run28 = [57, esquid_run29]
{
	ai_walk(TE_LIGHTNING1);
};

void() esquid_run29 = [58, esquid_run30]
{
	ai_walk(TE_LIGHTNING1);
};

void() esquid_run30 = [59, esquid_run31]
{
	ai_walk(TE_LIGHTNING1);
};

void() esquid_run31 = [60, esquid_run32]
{
	ai_walk(TE_LIGHTNING1);
};

void() esquid_run32 = [61, esquid_run33]
{
	ai_walk(TE_LIGHTNING1);
};

void() esquid_run33 = [62, esquid_run34]
{
	ai_walk(TE_LIGHTNING1);
};

void() esquid_run34 = [63, esquid_run35]
{
	ai_walk(TE_LIGHTNING1);
};

void() esquid_run35 = [64, esquid_run36]
{
	ai_walk(TE_LIGHTNING1);
};

void() esquid_run36 = [65, esquid_run37]
{
	ai_walk(TE_LIGHTNING1);
};

void() esquid_run37 = [66, esquid_run38]
{
	ai_walk(TE_LIGHTNING1);
};

void() esquid_run38 = [67, esquid_run39]
{
	ai_walk(TE_LIGHTNING1);
};

void() esquid_run39 = [68, esquid_run40]
{
	ai_walk(TE_LIGHTNING1);
};

void() esquid_run40 = [69, esquid_run41]
{
	ai_walk(TE_LIGHTNING1);
};

void() esquid_run41 = [70, esquid_run42]
{
	ai_walk(TE_LIGHTNING1);
};

void() esquid_run42 = [71, esquid_run43]
{
	ai_walk(TE_LIGHTNING1);
};

void() esquid_run43 = [72, esquid_run44]
{
	ai_walk(TE_LIGHTNING1);
};

void() esquid_run44 = [73, esquid_run45]
{
	ai_walk(TE_LIGHTNING1);
};

void() esquid_run45 = [74, esquid_run46]
{
	ai_walk(TE_LIGHTNING1);
};

void() esquid_run46 = [75, esquid_run1]
{
	ai_walk(TE_LIGHTNING1);
};

void() esquid_pain = 
{
	esquid_particle();
	monster_pain(self.enemy);
};

void() esquid_death1 = [0, esquid_death2]
{
	monster_death();
};

void() esquid_death2 = [1, esquid_death3]
{
	monster_death();
};

void() esquid_death3 = [2, esquid_death4]
{
	monster_death();
};

void() esquid_death4 = [3, esquid_death5]
{
	monster_death();
};

void() esquid_death5 = [4, esquid_death6]
{
	monster_death();
};

void() esquid_death6 = [5, esquid_death7]
{
	monster_death();
};

void() esquid_death7 = [6, esquid_death8]
{
	monster_death();
	esquid_particle();
};

void() esquid_death8 = [7, esquid_death9]
{
	monster_death();
};

void() esquid_death9 = [8, esquid_death10]
{
	monster_death();
	esquid_particle();
};

void() esquid_death10 = [9, esquid_death11]
{
	monster_death();
};

void() esquid_death11 = [10, esquid_death12]
{
	monster_death();
	esquid_particle();
};

void() esquid_death12 = [11, esquid_death13]
{
	monster_death();
};

void() esquid_death13 = [12, esquid_death14]
{
	monster_death();
	esquid_particle();
};

void() esquid_death14 = [13, esquid_death15]
{
	monster_death();
};

void() esquid_death15 = [14, esquid_death16]
{
	monster_death();
	esquid_particle();
};

void() esquid_death16 = [15, esquid_death17]
{
	monster_death();
};

void() esquid_death17 = [16, esquid_death18]
{
	monster_death();
	esquid_particle();
};

void() esquid_death18 = [17, esquid_death19]
{
	monster_death();
};

void() esquid_death19 = [18, esquid_death20]
{
	monster_death();
	esquid_particle();
};

void() esquid_death20 = [19, esquid_death21]
{
	monster_death();
};

void() esquid_death21 = [20, esquid_death22]
{
	monster_death();
	esquid_particle();
};

void() esquid_death22 = [21, esquid_death23]
{
	monster_death();
};

void() esquid_death23 = [22, esquid_death24]
{
	sound(self, CHAN_AUTO, "esquid/deflate.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	monster_death();
};

void() esquid_death24 = [23, esquid_death25]
{
	monster_death();
};

void() esquid_death25 = [24, esquid_death26]
{
	monster_death();
};

void() esquid_death26 = [25, esquid_death27]
{
	monster_death();
};

void() esquid_death27 = [26, esquid_death28]
{
	monster_death();
};

void() esquid_death28 = [27, esquid_death29]
{
	monster_death();
};

void() esquid_death29 = [28, esquid_death30]
{
	monster_death();
};

void() esquid_death30 = [29, esquid_death30]
{
	monster_death();
};

void() esquid_die = 
{
	if (self.gaveexp != 1)
	{
		GiveExperience(IT_RELIC4);
		self.movetype = MOVETYPE_TOSS;
		self.avelocity = '300 -300 0';
		self.gaveexp = 1;
		sound(self, CHAN_AUTO, "esquid/death.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	}
	if (self.knockback != IT_RELIC2 && self.knockback != AS_MELEE)
	{
		self.velocity = no;
		self.flags = self.flags - (self.flags & FL_ONGROUND);
		self.velocity = self.velocity + TE_LIGHTNING3 * v_forward * IT_RELIC4;
		self.velocity = self.velocity + 90 * '0 0 3';
	}
	esquid_death1();
};

void() lit_think = 
{
	local entity head;
	local entity temp;
	local vector org;
	local float r;
	if (self.owner.health < PLAT_LOW_TRIGGER || self.owner.enemy.flypain)
	{
		remove(self);
		return;
	}
	if (self.frame < AS_MELEE)
	{
		self.frame = self.frame + PLAT_LOW_TRIGGER;
		self.alpha = self.alpha + 0.05;
	}
	else
	{
		self.frame = STATE_TOP;
	}
	org = self.origin - v_up * IT_RELIC4;
	if (self.attack_finished < time)
	{
		if (self.cnt < IT_RELIC3)
		{
			sound(self, CHAN_BODY, "esquid/charge.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
			self.cnt = self.cnt + PLAT_LOW_TRIGGER;
		}
		else
		{
			head = searchradius(self.origin, 999);
			while (head)
			{
				if (range(self.owner.enemy) <= RANGE_MID && visible(self.owner.enemy))
				{
					if (head.deadflag == DEAD_NO && head == self.owner.enemy)
					{
						temp = spawn();
						temp.movetype = MOVETYPE_NONE;
						temp.solid = SOLID_NOT;
						temp.classname = "sprite";
						temp.alpha = 0.5;
						r = random();
						if (r < 0.5)
						{
							temp.frame = STATE_TOP;
						}
						else
						{
							temp.frame = PLAT_LOW_TRIGGER;
						}
						temp.effects = EF_MUZZLEFLASH;
						setmodel(temp, "progs/lsprite.spr");
						setsize(temp, no, no);
						setorigin(temp, head.origin);
						temp.think = SUB_Remove;
						temp.nextthink = time + 0.1;
						WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
						WriteByte(MSG_BROADCAST, TE_LIGHTNING2);
						WriteEntity(MSG_BROADCAST, head);
						WriteCoord(MSG_BROADCAST, org_x);
						WriteCoord(MSG_BROADCAST, org_y);
						WriteCoord(MSG_BROADCAST, org_z);
						WriteCoord(MSG_BROADCAST, head.origin_x);
						WriteCoord(MSG_BROADCAST, head.origin_y);
						WriteCoord(MSG_BROADCAST, head.origin_z);
						head.knockback = AS_MELEE;
						if (head.block_finished < time)
						{
							T_Damage(head, self, self.owner, TE_TELEPORT);
						}
						else
						{
							if (head.classname == "player")
							{
								head.effects = EF_MUZZLEFLASH;
								head.think = player_blockbrk1;
							}
						}
						sound(self, CHAN_WEAPON, "esquid/attack.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
					}
				}
				head = head.chain;
			}
			self.cnt = STATE_TOP;
			remove(self);
			return;
		}
		self.attack_finished = time + 0.5;
	}
	setorigin(self, self.owner.origin - v_up * TE_LIGHTNING1);
	self.nextthink = time + 0.1;
};

void() esquid_lightning = 
{
	local entity lit;
	if (self.attack_finished < time)
	{
		lit = spawn();
		lit.owner = self;
		lit.movetype = MOVETYPE_NOCLIP;
		lit.solid = SOLID_NOT;
		lit.classname = "lit";
		setmodel(lit, "progs/esquidcr.spr");
		lit.alpha = STATE_TOP;
		setsize(lit, no, no);
		setorigin(lit, self.origin - v_up * TE_LIGHTNING1);
		lit.think = lit_think;
		lit.nextthink = time + 0.1;
		self.attack_finished = time + AS_MELEE + random() * TE_LIGHTNING2;
	}
};

void() monster_esquid = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model("progs/esquid.mdl");
	precache_model("progs/esquidcr.spr");
	precache_sound("esquid/pain.wav");
	precache_sound("esquid/death.wav");
	precache_sound("esquid/deflate.wav");
	precache_sound("esquid/charge.wav");
	precache_sound("esquid/attack.wav");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/esquid.mdl");
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
	if (difficulty < IT_RELIC2)
	{
		self.health = 215;
	}
	else
	{
		self.health = 247;
	}
	self.netname = "solid";
	self.takedamage = DAMAGE_YES;
	self.solid = SOLID_NOT;
	self.classname = "esquid";
	self.noblood = 1;
	self.th_stand = esquid_stand1;
	self.th_walk = esquid_run1;
	self.th_pain = esquid_pain;
	self.th_die = esquid_die;
	self.th_missile = esquid_lightning;
	spawn_shadow();
	enemy_start();
};


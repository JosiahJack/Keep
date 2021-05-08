void() archer_forceface = 
{
	local vector view;
	if (self.enemy && visible(self.enemy) && self.enemy.health > STATE_TOP)
	{
		view = vectoangles(self.enemy.origin - self.origin);
		self.angles_y = view_y;
	}
};

void() archer_stand1 = [35, archer_stand2]
{
	ai_stand();
};

void() archer_stand2 = [36, archer_stand3]
{
	ai_stand();
};

void() archer_stand3 = [37, archer_stand4]
{
	ai_stand();
};

void() archer_stand4 = [38, archer_stand5]
{
	ai_stand();
};

void() archer_stand5 = [39, archer_stand6]
{
	ai_stand();
};

void() archer_stand6 = [40, archer_stand1]
{
	ai_stand();
};

void() archer_move1 = [41, archer_move2]
{
	ai_walk(IT_RELIC4);
};

void() archer_move2 = [42, archer_move3]
{
	ai_walk(IT_RELIC4);
};

void() archer_move3 = [43, archer_move4]
{
	ai_walk(IT_RELIC4);
};

void() archer_move4 = [44, archer_move5]
{
	ai_walk(IT_RELIC4);
};

void() archer_move5 = [45, archer_move6]
{
	ai_walk(IT_RELIC4);
};

void() archer_move6 = [46, archer_move7]
{
	ai_walk(IT_RELIC4);
};

void() archer_move7 = [47, archer_move8]
{
	ai_walk(IT_RELIC4);
};

void() archer_move8 = [48, archer_move1]
{
	ai_walk(IT_RELIC4);
};

void() arrow_think = 
{
	self.angles = vectoangles(self.velocity);
	self.nextthink = time + 0.1;
};

void() arrow_remove = 
{
	if (self.alpha > 0.1)
	{
		self.alpha = self.alpha - 0.1;
	}
	if (self.cnt < TE_LAVASPLASH)
	{
		self.cnt = self.cnt + PLAT_LOW_TRIGGER;
	}
	else
	{
		remove(self);
		return;
	}
	self.nextthink = time + 0.1;
};

void() archer_arrow_touch = 
{
	local entity effect;
	local vector dir;
	if (other.solid == SOLID_BSP && self.velocity != no)
	{
		self.movetype = MOVETYPE_FLY;
		self.velocity = no;
		sound(self, CHAN_BODY, "archer/arrowhit.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
		self.think = arrow_remove;
		self.nextthink = time + 0.1;
		self.touch = SUB_Null;
	}
	if (other.classname == "player" && !(other.flypain) && other.takedamage != DAMAGE_NO)
	{
		if (other.block_finished > time)
		{
			if (sprite_count < TE_LAVASPLASH)
			{
				effect = spawn();
				setorigin(effect, other.origin);
				setmodel(effect, "progs/block.spr");
				effect.effects = EF_NODEPTHTEST;
				effect.movetype = MOVETYPE_NONE;
				effect.think = fx_think;
				effect.nextthink = time;
				effect.solid = SOLID_NOT;
				sprite_count = sprite_count + PLAT_LOW_TRIGGER;
			}
			if (other.classname == "player")
			{
				if (self.angles_y > 90 && self.angles_y < 270)
				{
					other.angles_y = STATE_TOP;
				}
				else
				{
					other.angles_y = 180;
				}
				other.effects = EF_MUZZLEFLASH;
				other.think = player_block;
				other.nextthink = time + 0.1;
				sound(other, CHAN_BODY, "player/block.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
			}
			self.avelocity = '500 1000 0';
			self.movetype = MOVETYPE_BOUNCE;
			self.touch = SUB_Null;
			self.velocity = no;
			self.think = arrow_remove;
			self.nextthink = time + 0.1;
		}
		else
		{
			effect = spawn();
			setorigin(effect, other.origin);
			setmodel(effect, "progs/hit.spr");
			effect.movetype = MOVETYPE_NONE;
			effect.think = fx_think;
			effect.nextthink = time;
			effect.solid = SOLID_NOT;
			other.paincount = IT_RELIC2;
			T_Damage(other, self, self, AS_MELEE);
			ThrowBloodSplat(dir, other.origin, other);
			sound(self, CHAN_BODY, "archer/arrowhit.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
			sound(self, CHAN_WEAPON, "player/swordhit.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
			remove(self);
			return;
		}
	}
};

void() archer_arrow = 
{
	local entity missile;
	local float dist;
	local float base;
	local float g;
	g = cvar("sv_gravity") * 0.001250;
	dist = vlen(self.enemy.origin - self.origin);
	missile = spawn();
	missile.owner = self;
	missile.movetype = MOVETYPE_TOSS;
	missile.solid = SOLID_TRIGGER;
	makevectors(self.angles);
	missile.velocity = normalize(self.enemy.origin - self.origin);
	missile.velocity = missile.velocity * 600;
	if (self.mode == STATE_TOP)
	{
		missile.cnt = 175;
	}
	else
	{
		missile.cnt = 100;
	}
	if (self.enemy.velocity_x || self.enemy.velocity_y)
	{
		if (random() < 0.9)
		{
			dist = dist - random() * 300;
		}
	}
	if (self.mode == STATE_TOP)
	{
		if (dist > 900)
		{
			base = missile.cnt + (dist - (200 - dist * 0.2)) * 0.5;
		}
		else
		{
			if (dist > 700)
			{
				base = missile.cnt + (dist - (200 - dist * 0.15)) * 0.5;
			}
			else
			{
				if (dist > 500)
				{
					base = missile.cnt + (dist - (200 - dist * 0.1)) * 0.5;
				}
				else
				{
					if (dist > 200)
					{
						base = missile.cnt + (dist - 200) * 0.5;
					}
					else
					{
						base = missile.cnt;
					}
				}
			}
		}
	}
	else
	{
		if (dist > 900)
		{
			base = missile.cnt + (dist - (200 - dist * 0.2)) * 0.5 * 1.2;
		}
		else
		{
			if (dist > 700)
			{
				base = missile.cnt + (dist - (200 - dist * 0.15)) * 0.5 * 1.2;
			}
			else
			{
				if (dist > 500)
				{
					base = missile.cnt + (dist - (200 - dist * 0.1)) * 0.5 * 1.2;
				}
				else
				{
					if (dist > 200)
					{
						base = missile.cnt + (dist - 200) * 0.5 * 1.2;
					}
					else
					{
						base = missile.cnt * 1.2;
					}
				}
			}
		}
	}
	missile.velocity_z = missile.velocity_z + base * g;
	missile.think = arrow_think;
	missile.nextthink = time;
	missile.touch = archer_arrow_touch;
	missile.alpha = PLAT_LOW_TRIGGER;
	setmodel(missile, "progs/arrow.mdl");
	setsize(missile, no, no);
	if (self.mode == STATE_TOP)
	{
		setorigin(missile, self.origin + v_up * IT_RELIC5);
	}
	else
	{
		setorigin(missile, self.origin + v_up * 48);
	}
};

void() archer_fire1 = [1, archer_fire2]
{
	archer_forceface();
};

void() archer_fire2 = [2, archer_fire3]
{
	archer_forceface();
};

void() archer_fire3 = [3, archer_fire4]
{
	archer_forceface();
};

void() archer_fire4 = [4, archer_fire5]
{
	archer_forceface();
};

void() archer_fire5 = [5, archer_fire6]
{
	archer_forceface();
};

void() archer_fire6 = [6, archer_fire7]
{
	archer_forceface();
};

void() archer_fire7 = [7, archer_fire8]
{
	archer_forceface();
};

void() archer_fire8 = [8, archer_fire9]
{
	archer_forceface();
};

void() archer_fire9 = [9, archer_fire10]
{
	archer_forceface();
};

void() archer_fire10 = [10, archer_fire11]
{
	archer_forceface();
};

void() archer_fire11 = [11, archer_fire12]
{
	archer_forceface();
};

void() archer_fire12 = [12, archer_fire13]
{
};

void() archer_fire13 = [13, archer_fire14]
{
};

void() archer_fire14 = [14, archer_fire15]
{
	archer_arrow();
	sound(self, CHAN_WEAPON, "archer/arrowuse.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
};

void() archer_fire15 = [15, archer_fire16]
{
};

void() archer_fire16 = [16, archer_move1]
{
};

void() archer_fireb1 = [17, archer_fireb2]
{
	archer_forceface();
};

void() archer_fireb2 = [18, archer_fireb3]
{
	archer_forceface();
};

void() archer_fireb3 = [19, archer_fireb4]
{
	archer_forceface();
};

void() archer_fireb4 = [20, archer_fireb5]
{
	archer_forceface();
};

void() archer_fireb5 = [21, archer_fireb6]
{
	archer_forceface();
};

void() archer_fireb6 = [22, archer_fireb7]
{
	archer_forceface();
};

void() archer_fireb7 = [23, archer_fireb8]
{
	archer_forceface();
};

void() archer_fireb8 = [24, archer_fireb9]
{
	archer_forceface();
};

void() archer_fireb9 = [25, archer_fireb10]
{
	archer_forceface();
};

void() archer_fireb10 = [26, archer_fireb11]
{
	archer_forceface();
};

void() archer_fireb11 = [27, archer_fireb12]
{
	archer_forceface();
};

void() archer_fireb12 = [28, archer_fireb13]
{
};

void() archer_fireb13 = [29, archer_fireb14]
{
};

void() archer_fireb14 = [30, archer_fireb15]
{
};

void() archer_fireb15 = [31, archer_fireb16]
{
};

void() archer_fireb16 = [32, archer_fireb17]
{
	self.nextthink = time + PLAT_LOW_TRIGGER;
};

void() archer_fireb17 = [33, archer_fireb18]
{
	archer_arrow();
	sound(self, CHAN_WEAPON, "archer/arrowuse.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
};

void() archer_fireb18 = [34, archer_move1]
{
};

void() archer_pain1 = [49, archer_pain2]
{
};

void() archer_pain2 = [50, archer_pain3]
{
};

void() archer_pain3 = [51, archer_pain4]
{
};

void() archer_pain4 = [52, archer_pain5]
{
};

void() archer_pain5 = [53, archer_pain6]
{
};

void() archer_pain6 = [54, archer_move1]
{
};

void() archer_pain = 
{
	if (random() < 0.5)
	{
		sound(self, CHAN_VOICE, "archer/pain1.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	}
	else
	{
		sound(self, CHAN_VOICE, "archer/pain2.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	}
	archer_pain1();
	monster_pain(self.enemy);
};

void() archer_grabbed1 = [53, archer_grabbed2]
{
	self.grab_finished = time + 0.5;
};

void() archer_grabbed2 = [53, archer_grabbed2]
{
	if (self.grab_finished < time || self.grabbed == 0)
	{
		self.th_run();
		return;
	}
};

void() archer_death1 = [55, archer_death1]
{
	monster_death();
};

void() archer_die = 
{
	if (self.gaveexp != 1)
	{
		GiveExperience(SVC_UPDATEFRAGS);
		self.gaveexp = 1;
		self.movetype = MOVETYPE_TOSS;
		self.avelocity = '300 300 0';
		sound(self, CHAN_VOICE, "archer/death.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	}
	if (self.knockback != IT_RELIC2 && self.knockback != AS_MELEE)
	{
		self.velocity = no;
		self.flags = self.flags - (self.flags & FL_ONGROUND);
		self.velocity = self.velocity + TE_LIGHTNING3 * v_forward * IT_RELIC4;
		self.velocity = self.velocity + 90 * '0 0 3';
	}
	archer_death1();
};

void() monster_archer = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model("progs/archer.mdl");
	precache_model("progs/arrow.mdl");
	precache_sound("archer/arrowhit.wav");
	precache_sound("archer/arrowuse.wav");
	precache_sound("archer/pain1.wav");
	precache_sound("archer/pain2.wav");
	precache_sound("archer/death.wav");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/archer.mdl");
	if (difficulty < IT_RELIC2)
	{
		if (self.mode == STATE_TOP)
		{
			self.health = 75;
		}
		else
		{
			self.health = SVC_SIGNONNUM;
		}
	}
	else
	{
		if (self.mode == STATE_TOP)
		{
			self.health = 113;
		}
		else
		{
			self.health = 45;
		}
	}
	self.netname = "solid";
	self.takedamage = DAMAGE_AIM;
	self.solid = SOLID_NOT;
	self.classname = "archer";
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
	self.th_stand = archer_stand1;
	self.th_run = archer_move1;
	self.th_grab = archer_grabbed1;
	self.th_pain = archer_pain;
	self.th_die = archer_die;
	if (self.mode == STATE_TOP)
	{
		self.th_missile = archer_fire1;
	}
	else
	{
		self.th_missile = archer_fireb1;
		if (!(self.awareness))
		{
			self.awareness = AS_MELEE;
		}
	}
	spawn_shadow();
	enemy_start();
};


void() bosshead_deaththink = 
{
	local float ox;
	local float oy;
	local float oz;
	local entity effect;
	local entity fx;
	if (vlen(self.velocity) < PLAT_LOW_TRIGGER || (self.flags & FL_ONGROUND) || self.velocity_z == STATE_TOP || (self.flags & FL_PARTIALGROUND))
	{
		if (self.cnt2 == STATE_TOP)
		{
			shake_camera(0.5);
			self.effects = STATE_TOP;
			self.angles_x = STATE_TOP;
			self.cnt2 = PLAT_LOW_TRIGGER;
			self.nextthink = time + AS_MELEE;
			return;
		}
		if (self.cnt2 < TE_LAVASPLASH)
		{
			shake_camera(0.1);
			ox = self.origin_x + random() * EF_ADDITIVE - IT_RELIC5;
			oy = self.origin_y + random() * EF_ADDITIVE - IT_RELIC5;
			oz = self.origin_z + random() * IT_RELIC5;
			sound(self, CHAN_BODY, "misc/explode.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
			WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
			WriteByte(MSG_BROADCAST, TE_EXPLOSION);
			WriteCoord(MSG_BROADCAST, ox);
			WriteCoord(MSG_BROADCAST, oy);
			WriteCoord(MSG_BROADCAST, oz);
			ThrowRubble();
			if (self.cnt2 == PLAT_LOW_TRIGGER)
			{
				GiveExperience(9999);
			}
			self.cnt2 = self.cnt2 + PLAT_LOW_TRIGGER;
		}
		else
		{
			self.enemy.owner.screenflash_finished = time + 0.5;
			effect = spawn();
			setorigin(effect, self.origin);
			setmodel(effect, "progs/explode1.mdl");
			effect.movetype = MOVETYPE_NONE;
			effect.think = explodemodel_think;
			if (darkplaces)
			{
				effect.effects = EF_NODEPTHTEST;
			}
			effect.nextthink = time;
			effect.alpha = PLAT_LOW_TRIGGER;
			effect.solid = SOLID_NOT;
			sound(self, CHAN_BODY, "spells/fhit.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
			fx = spawn();
			setorigin(fx, self.origin);
			setmodel(fx, "progs/efxflash.spr");
			fx.movetype = MOVETYPE_NONE;
			fx.alpha = PLAT_LOW_TRIGGER;
			if (darkplaces)
			{
				fx.effects = EF_NODEPTHTEST;
			}
			fx.think = efxflashe_think;
			fx.nextthink = time;
			fx.solid = SOLID_NOT;
			remove(self);
			return;
		}
	}
	self.velocity_z = -25;
	self.nextthink = time + 0.3;
};

void() bosshead_death = 
{
	setmodel(self, "progs/bosshd.mdl");
	setsize(self, '-58 -60 -34', '77 55 61');
	self.avelocity = '-360 193 502';
	self.movetype = MOVETYPE_TOSS;
	self.solid = SOLID_SLIDEBOX;
	self.deadflag = DEAD_DEAD;
	self.takedamage = DAMAGE_NO;
	self.think = bosshead_deaththink;
	self.nextthink = time + 0.1;
};

void() bosshead_pain = 
{
	self.cnt = time + 0.5;
	sound(self, CHAN_VOICE, "boss1/pain.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	self.velocity = no;
	GiveExperience(PLAT_LOW_TRIGGER);
};

void() bosshead_think = 
{
	local vector view;
	local entity head;
	local entity effect;
	MakeSolidList();
	head = searchradius(self.origin, TE_LAVASPLASH);
	while (head)
	{
		if (head != self && visible(head) && head.takedamage && self.cnt < time)
		{
			if (self.flags & FL_MONSTER && !(head.flags & FL_MONSTER) || !(self.flags & FL_MONSTER))
			{
				if (head.block_finished < time)
				{
					head.knockback = AS_MELEE;
					T_Damage(head, self, self, IT_RELIC4);
					sound(head, CHAN_AUTO, "boss1/out1.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
					WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
					WriteByte(MSG_BROADCAST, TE_LAVASPLASH);
					WriteCoord(MSG_BROADCAST, head.origin_x);
					WriteCoord(MSG_BROADCAST, head.origin_y);
					WriteCoord(MSG_BROADCAST, head.origin_z);
					self.backtime = time + 0.5;
				}
				else
				{
					if (head.classname == "player")
					{
						if (self.angles_y > 90 && self.angles_y < 270)
						{
							head.angles_y = STATE_TOP;
						}
						else
						{
							head.angles_y = 180;
						}
						head.think = player_block;
						head.nextthink = time + 0.1;
						head.block_finished = time + 0.5;
					}
					if (sprite_count < TE_LAVASPLASH)
					{
						effect = spawn();
						setorigin(effect, head.origin);
						setmodel(effect, "progs/block.spr");
						effect.movetype = MOVETYPE_NONE;
						effect.think = fx_think;
						effect.nextthink = time;
						effect.solid = SOLID_NOT;
						sprite_count = sprite_count + PLAT_LOW_TRIGGER;
					}
					sound(self, CHAN_BODY, "player/block.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
				}
				self.cnt = time + PLAT_LOW_TRIGGER;
			}
		}
		head = head.chain;
	}
	UnmakeSolidList();
	if (self.beams_shot < PLAT_LOW_TRIGGER)
	{
		view = vectoangles(self.enemy.origin - self.origin);
		self.angles_y = view_y;
		self.angles_x = view_x;
	}
	if (self.attack_finished < time && self.mode == STATE_TOP)
	{
		self.mode = PLAT_LOW_TRIGGER;
	}
	if (self.mode == STATE_TOP)
	{
		if (range(self.enemy) == RANGE_CLOSE)
		{
			self.backtime = time + 0.2;
		}
		if (self.backtime < time)
		{
			if (self.origin_x < self.enemy.origin_x)
			{
				self.velocity_x = self.velocity_x + TE_LIGHTNING1;
			}
			if (self.origin_x > self.enemy.origin_x)
			{
				self.velocity_x = self.velocity_x - TE_LIGHTNING1;
			}
			if (self.origin_y < self.enemy.origin_y)
			{
				self.velocity_y = self.velocity_y + TE_LIGHTNING1;
			}
			if (self.origin_y > self.enemy.origin_y)
			{
				self.velocity_y = self.velocity_y - TE_LIGHTNING1;
			}
			if (self.origin_z < self.enemy.origin_z)
			{
				self.velocity_z = self.velocity_z + TE_LIGHTNING1;
			}
			if (self.origin_z > self.enemy.origin_z)
			{
				self.velocity_z = self.velocity_z - TE_LIGHTNING1;
			}
		}
		else
		{
			if (self.origin_x < self.enemy.origin_x)
			{
				self.velocity_x = self.velocity_x - TE_LIGHTNING1;
			}
			if (self.origin_x > self.enemy.origin_x)
			{
				self.velocity_x = self.velocity_x + TE_LIGHTNING1;
			}
			if (self.origin_y < self.enemy.origin_y)
			{
				self.velocity_y = self.velocity_y - TE_LIGHTNING1;
			}
			if (self.origin_y > self.enemy.origin_y)
			{
				self.velocity_y = self.velocity_y + TE_LIGHTNING1;
			}
			if (self.origin_z < self.enemy.origin_z)
			{
				self.velocity_z = self.velocity_z - TE_LIGHTNING1;
			}
			if (self.origin_z > self.enemy.origin_z)
			{
				self.velocity_z = self.velocity_z + TE_LIGHTNING1;
			}
		}
	}
	else
	{
		if (self.mode == PLAT_LOW_TRIGGER)
		{
			self.velocity_x = self.velocity_x / 1.01;
			self.velocity_y = self.velocity_y / 1.01;
			self.velocity_z = self.velocity_z / 1.01;
			if (vlen(self.velocity) < PLAT_LOW_TRIGGER)
			{
				self.mode = IT_RELIC2;
				self.attack_finished = time + 1.5;
				effect = spawn();
				setorigin(effect, self.origin);
				setmodel(effect, "progs/chrgebm.spr");
				effect.movetype = MOVETYPE_NONE;
				effect.solid = SOLID_NOT;
				effect.alpha = 0.2;
				effect.think = chargebeam_effect;
				effect.nextthink = time + 0.010000;
				sound(effect, CHAN_AUTO, "spells/charge.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
			}
		}
		else
		{
			if (self.mode == IT_RELIC2 && self.attack_finished < time)
			{
				if (self.beams_shot < TE_TELEPORT)
				{
					if (self.beams_shot > STATE_TOP)
					{
						Firebeam(PLAT_LOW_TRIGGER, STATE_TOP);
					}
					self.beams_shot = self.beams_shot + PLAT_LOW_TRIGGER;
				}
				else
				{
					self.beams_shot = STATE_TOP;
					self.attack_finished = time + AS_MELEE;
					self.mode = STATE_TOP;
				}
				frameskip(0.1);
				return;
			}
		}
	}
	if (self.flags & FL_ONGROUND)
	{
		self.flags = self.flags - FL_ONGROUND;
	}
	if (self.flags & FL_PARTIALGROUND)
	{
		self.flags = self.flags - FL_PARTIALGROUND;
	}
	frameskip(0.010000);
};

void() boss_face = 
{
	local vector view;
	view = vectoangles(self.enemy.origin - self.origin);
	self.angles_y = view_y;
};

float(entity targ) boss_range = 
{
	local float r;
	r = vlen(self.origin - targ.origin);
	if (r < 250)
	{
		return RANGE_MELEE;
	}
	else
	{
		return RANGE_FAR;
	}
};

void() boss_idle1 = [0, boss_idle1]
{
	local vector view;
	local float r;
	local float rand_fb;
	if (self.enemy)
	{
		boss_face();
		if (self.enemy.watertype != CONTENT_LAVA && self.attack_finished < time)
		{
			r = boss_range(self.enemy);
			if (random() < 0.5 && self.counter_finished < time)
			{
				Fireball(IT_RELIC2, 100);
				Fireball(IT_RELIC2, 100);
				self.counter_finished = time + TE_LIGHTNING1;
			}
			if (r == RANGE_MELEE)
			{
				if (self.level > PLAT_LOW_TRIGGER)
				{
					self.attack_finished = time + AS_MELEE;
					self.level = STATE_TOP;
				}
				else
				{
					boss_attack1();
					self.level = self.level + PLAT_LOW_TRIGGER;
				}
			}
			else
			{
				if (self.level > AS_MELEE)
				{
					self.attack_finished = time + TE_LIGHTNING2;
					self.level = STATE_TOP;
				}
				else
				{
					boss_rockdrop1();
					self.level = self.level + PLAT_LOW_TRIGGER;
				}
			}
		}
	}
	if (self.stand_finished < time)
	{
		self.walkframe = self.walkframe + PLAT_LOW_TRIGGER;
		self.stand_finished = time + 0.1;
	}
	self.frame = SVC_UPDATECOLORS + self.walkframe;
	if (self.walkframe > SVC_INTERMISSION)
	{
		self.walkframe = STATE_TOP;
	}
	frameskip(0.010000);
	self.takedamage = DAMAGE_AIM;
	self.velocity = no;
};

void() boss_rockdrop = 
{
	local entity y;
	local entity oldself;
	y = find(world, classname, "bossboulderspawner");
	while (y)
	{
		self.cnt = floor(random() * AS_MELEE);
		if (self.cnt == y.cnt)
		{
			oldself = self;
			self = y;
			if (self.use)
			{
				self.use();
			}
			self = oldself;
		}
		y = find(y, classname, "bossboulderspawner");
	}
	y = find(world, classname, "bossboulderspawner");
};

void() boss_rockdrop1 = [96, boss_rockdrop2]
{
	local entity y;
	y = find(world, classname, "camera");
	while (y)
	{
		y.camshake_finished = time + PLAT_LOW_TRIGGER;
		y = find(y, classname, "camera");
	}
	y = find(world, classname, "camera");
	sound(self, CHAN_VOICE, "boss1/sight1.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
};

void() boss_rockdrop2 = [97, boss_rockdrop3]
{
};

void() boss_rockdrop3 = [98, boss_rockdrop4]
{
	boss_rockdrop();
};

void() boss_rockdrop4 = [99, boss_rockdrop5]
{
};

void() boss_rockdrop5 = [100, boss_rockdrop6]
{
};

void() boss_rockdrop6 = [101, boss_rockdrop7]
{
	boss_rockdrop();
};

void() boss_rockdrop7 = [102, boss_rockdrop8]
{
};

void() boss_rockdrop8 = [103, boss_rockdrop9]
{
};

void() boss_rockdrop9 = [104, boss_rockdrop10]
{
	boss_rockdrop();
};

void() boss_rockdrop10 = [105, boss_idle1]
{
};

void() BossMelee = 
{
	FireMelee(SVC_CLIENTDATA, STATE_TOP, AS_MELEE, 100, TE_LIGHTNING1, STATE_TOP, PLAT_LOW_TRIGGER);
	remove(self);
	return;
};

void() boss_attack1 = [57, boss_attack2]
{
	frameskip(0.080000);
};

void() boss_attack2 = [58, boss_attack3]
{
	frameskip(0.080000);
};

void() boss_attack3 = [59, boss_attack4]
{
	frameskip(0.080000);
};

void() boss_attack4 = [60, boss_attack5]
{
	frameskip(0.080000);
};

void() boss_attack5 = [61, boss_attack6]
{
	frameskip(0.080000);
};

void() boss_attack6 = [62, boss_attack7]
{
	frameskip(0.080000);
};

void() boss_attack7 = [63, boss_attack8]
{
	frameskip(0.080000);
};

void() boss_attack8 = [64, boss_attack9]
{
	frameskip(0.080000);
};

void() boss_attack9 = [65, boss_attack10]
{
	local entity h;
	makevectors(self.angles);
	h = spawn();
	setmodel(h, string_null);
	setsize(h, no, no);
	setorigin(h, self.origin + v_up * 200 + v_forward * 200);
	h.movetype = MOVETYPE_NOCLIP;
	h.solid = SOLID_NOT;
	h.flags = FL_MONSTER;
	h.owner = self;
	h.angles_y = self.angles_y;
	h.think = BossMelee;
	h.nextthink = time;
	frameskip(0.080000);
};

void() boss_attack10 = [66, boss_attack11]
{
	frameskip(0.080000);
};

void() boss_attack11 = [67, boss_attack12]
{
	frameskip(0.080000);
};

void() boss_attack12 = [68, boss_attack13]
{
	frameskip(0.080000);
};

void() boss_attack13 = [69, boss_attack14]
{
	frameskip(0.080000);
};

void() boss_attack14 = [70, boss_attack15]
{
	frameskip(0.080000);
};

void() boss_attack15 = [71, boss_attack16]
{
	frameskip(0.080000);
};

void() boss_attack16 = [72, boss_attack17]
{
	frameskip(0.080000);
};

void() boss_attack17 = [73, boss_attack18]
{
	frameskip(0.080000);
};

void() boss_attack18 = [74, boss_attack19]
{
	frameskip(0.080000);
};

void() boss_attack19 = [75, boss_attack20]
{
	frameskip(0.080000);
};

void() boss_attack20 = [76, boss_attack21]
{
	local entity h;
	makevectors(self.angles);
	h = spawn();
	setmodel(h, string_null);
	setsize(h, no, no);
	setorigin(h, self.origin + v_up * 200 + v_forward * 200);
	h.movetype = MOVETYPE_NOCLIP;
	h.solid = SOLID_NOT;
	h.flags = FL_MONSTER;
	h.owner = self;
	h.angles = self.angles;
	h.think = BossMelee;
	h.nextthink = time;
	frameskip(0.080000);
};

void() boss_attack21 = [77, boss_attack22]
{
	frameskip(0.080000);
};

void() boss_attack22 = [78, boss_attack23]
{
	frameskip(0.080000);
};

void() boss_attack23 = [79, boss_idle1]
{
	frameskip(0.080000);
};

void() boss_death1 = [48, boss_death2]
{
	sound(self, CHAN_VOICE, "boss1/death.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
};

void() boss_death2 = [49, boss_death3]
{
};

void() boss_death3 = [50, boss_death4]
{
};

void() boss_death4 = [51, boss_death5]
{
};

void() boss_death5 = [52, boss_death6]
{
};

void() boss_death6 = [53, boss_death7]
{
};

void() boss_death7 = [54, boss_death8]
{
};

void() boss_death8 = [55, boss_death9]
{
};

void() boss_death9 = [56, boss_death10]
{
};

void() boss_death10 = [56, boss_death10]
{
	local entity form;
	sound(self, CHAN_BODY, "boss1/out1.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_LAVASPLASH);
	WriteCoord(MSG_BROADCAST, self.origin_x);
	WriteCoord(MSG_BROADCAST, self.origin_y);
	WriteCoord(MSG_BROADCAST, self.origin_z);
	SUB_UseTargets();
	form = spawn();
	setmodel(form, "progs/bossh.mdl");
	setsize(form, '-58 -60 -34', '77 55 61');
	setorigin(form, self.origin - v_up * FL_GODMODE);
	form.movetype = MOVETYPE_FLY;
	form.netname = "solid";
	form.takedamage = DAMAGE_YES;
	form.solid = SOLID_SLIDEBOX;
	form.health = 150;
	form.flags = FL_MONSTER | FL_BOSS;
	form.deadflag = DEAD_NO;
	form.classname = "bosshead";
	form.th_pain = bosshead_pain;
	form.th_die = bosshead_death;
	form.noblood = 1;
	form.enemy = self.enemy;
	form.think = bosshead_think;
	form.attack_finished = time + AS_MELEE;
	form.nextthink = time;
	remove(self);
	return;
};

void() boss_fbeam1 = [90, boss_fbeam2]
{
	if (self.beams_shot < SVC_INTERMISSION)
	{
		Firebeam(PLAT_LOW_TRIGGER, 100);
		Firebeam(PLAT_LOW_TRIGGER, 200);
		self.beams_shot = self.beams_shot + PLAT_LOW_TRIGGER;
	}
	else
	{
		self.beams_shot = STATE_TOP;
		boss_idle1();
	}
	frameskip(0.030000);
};

void() boss_fbeam2 = [91, boss_fbeam3]
{
	frameskip(0.030000);
};

void() boss_fbeam3 = [92, boss_fbeam4]
{
	frameskip(0.030000);
};

void() boss_fbeam4 = [93, boss_fbeam5]
{
	frameskip(0.030000);
};

void() boss_fbeam5 = [94, boss_fbeam6]
{
	frameskip(0.030000);
};

void() boss_fbeam6 = [95, boss_fbeam1]
{
	frameskip(0.030000);
};

void() boss_pain1 = [80, boss_pain2]
{
	self.velocity = no;
};

void() boss_pain2 = [81, boss_pain3]
{
};

void() boss_pain3 = [82, boss_pain4]
{
};

void() boss_pain4 = [83, boss_pain5]
{
};

void() boss_pain5 = [84, boss_pain6]
{
};

void() boss_pain6 = [85, boss_pain7]
{
};

void() boss_pain7 = [86, boss_pain8]
{
};

void() boss_pain8 = [87, boss_pain9]
{
};

void() boss_pain9 = [88, boss_pain10]
{
};

void() boss_pain10 = [89, boss_idle1]
{
};

void() boss_pain = 
{
	local entity effect;
	self.cnt2 = self.cnt2 + PLAT_LOW_TRIGGER;
	if (self.attack_finished > time)
	{
		sound(self, CHAN_VOICE, "boss1/pain.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
		self.mode = STATE_TOP;
		boss_pain1();
	}
	if (combo > TE_LIGHTNING3 || self.cnt2 > IT_RELIC5 && self.mode != PLAT_LOW_TRIGGER)
	{
		self.mode = PLAT_LOW_TRIGGER;
		self.cnt2 = STATE_TOP;
		self.attack_finished = time;
		effect = spawn();
		setorigin(effect, self.origin + v_up * 100);
		setmodel(effect, "progs/chrgebm.spr");
		effect.movetype = MOVETYPE_NONE;
		effect.solid = SOLID_NOT;
		effect.alpha = 0.2;
		effect.think = chargebeam_effect;
		effect.nextthink = time + 0.010000;
		effect = spawn();
		setorigin(effect, self.origin + v_up * 200);
		setmodel(effect, "progs/chrgebm.spr");
		effect.movetype = MOVETYPE_NONE;
		effect.solid = SOLID_NOT;
		effect.alpha = 0.2;
		effect.think = chargebeam_effect;
		effect.nextthink = time + 0.010000;
		sound(effect, CHAN_AUTO, "spells/charge.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
		self.think = boss_fbeam1;
		self.nextthink = time + IT_RELIC2;
	}
	GiveExperience(PLAT_LOW_TRIGGER);
};

void() boss_die = 
{
	self.deadflag = DEAD_DEAD;
	self.takedamage = DAMAGE_NO;
	GiveExperience(9999);
	boss_death1();
};

void() boulder_touch = 
{
	if (self.velocity_z == STATE_TOP)
	{
		return;
	}
	if (other.takedamage && other.classname != "boss")
	{
		if (other.block_finished < time)
		{
			T_Damage(other, self, self, TE_LIGHTNING2);
		}
		else
		{
			sound(other, CHAN_BODY, "player/block.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
		}
		ThrowRubble();
		sound(self, CHAN_BODY, "misc/rocks.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
		remove(self);
		return;
	}
};

void() boulder_remove = 
{
	if (self.mode == PLAT_LOW_TRIGGER || self.level > 99)
	{
		if (self.alpha > 0.1)
		{
			self.alpha = self.alpha - 0.1;
		}
		else
		{
			remove(self);
			return;
		}
	}
	else
	{
		if (self.flags & FL_ONGROUND)
		{
			self.mode = PLAT_LOW_TRIGGER;
		}
	}
	self.level = self.level + PLAT_LOW_TRIGGER;
	frameskip(0.1);
};

void() boulder_spawner_use = 
{
	local entity bould;
	bould = spawn();
	setmodel(bould, "progs/boulder.mdl");
	setsize(bould, '-27 -13 -1', '12 20 1');
	setorigin(bould, self.origin);
	bould.alpha = PLAT_LOW_TRIGGER;
	bould.movetype = MOVETYPE_TOSS;
	bould.solid = SOLID_TRIGGER;
	bould.classname = "bossboulder";
	bould.angles_y = bould.angles_x = bould.angles_z = random() * 360;
	bould.touch = boulder_touch;
	bould.think = boulder_remove;
	bould.nextthink = time;
};

void() boulder_spawner_think = 
{
	local entity targ;
	if (self.velocity_z == STATE_TOP)
	{
		if (self.enemy)
		{
			if (self.origin_x < self.enemy.origin_x)
			{
				self.velocity_x = self.velocity_x + 50;
			}
			if (self.origin_x > self.enemy.origin_x)
			{
				self.velocity_x = self.velocity_x - 50;
			}
			if (self.origin_y < self.enemy.origin_y)
			{
				self.velocity_y = self.velocity_y + 50;
			}
			if (self.origin_y > self.enemy.origin_y)
			{
				self.velocity_y = self.velocity_y - 50;
			}
			if (self.airtight_finished < time)
			{
				self.velocity_x = self.velocity_x / 1.2;
				self.velocity_y = self.velocity_y / 1.2;
			}
			self.airtight_finished = time + random() * SVC_SIGNONNUM;
		}
		else
		{
			targ = find(world, classname, "player");
			while (targ)
			{
				if (targ.health > STATE_TOP)
				{
					self.enemy = targ;
				}
				targ = find(targ, classname, "player");
			}
			targ = find(world, classname, "player");
		}
		self.cnt = floor(random() * AS_MELEE);
	}
	else
	{
		self.velocity_z = STATE_TOP;
	}
	frameskip(0.1);
};

void() spawn_boulder_spawner = 
{
	local entity b;
	local entity targ;
	b = spawn();
	setmodel(b, string_null);
	setsize(b, '-27 -13 -1', '12 20 1');
	setorigin(b, self.origin + v_up * FL_GODMODE);
	b.movetype = MOVETYPE_FLY;
	b.velocity_z = 999999;
	b.use = boulder_spawner_use;
	b.classname = "bossboulderspawner";
	b.think = boulder_spawner_think;
	b.nextthink = time + PLAT_LOW_TRIGGER;
	targ = find(world, classname, "player");
	while (targ)
	{
		if (targ.health > STATE_TOP)
		{
			self.enemy = targ;
		}
		targ = find(targ, classname, "player");
	}
	targ = find(world, classname, "player");
};

void() boss_rise1 = [0, boss_rise2]
{
	sound(self, CHAN_WEAPON, "boss1/out1.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	boss_face();
	spawn_boulder_spawner();
	spawn_boulder_spawner();
	spawn_boulder_spawner();
	spawn_boulder_spawner();
	spawn_boulder_spawner();
	spawn_boulder_spawner();
	spawn_boulder_spawner();
	spawn_boulder_spawner();
};

void() boss_rise2 = [1, boss_rise3]
{
	boss_face();
};

void() boss_rise3 = [2, boss_rise4]
{
	boss_face();
};

void() boss_rise4 = [3, boss_rise5]
{
	boss_face();
};

void() boss_rise5 = [4, boss_rise6]
{
	boss_face();
};

void() boss_rise6 = [5, boss_rise7]
{
	boss_face();
};

void() boss_rise7 = [6, boss_rise8]
{
	boss_face();
};

void() boss_rise8 = [7, boss_rise9]
{
	boss_face();
};

void() boss_rise9 = [8, boss_rise10]
{
	boss_face();
};

void() boss_rise10 = [9, boss_rise11]
{
	boss_face();
};

void() boss_rise11 = [10, boss_rise12]
{
	boss_face();
};

void() boss_rise12 = [11, boss_rise13]
{
	boss_face();
};

void() boss_rise13 = [12, boss_rise14]
{
	boss_face();
};

void() boss_rise14 = [13, boss_rise15]
{
	boss_face();
};

void() boss_rise15 = [14, boss_rise16]
{
	boss_face();
};

void() boss_rise16 = [15, boss_rise17]
{
	boss_face();
};

void() boss_rise17 = [16, boss_idle1]
{
	boss_face();
};

void() boss_awake = 
{
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_LAVASPLASH);
	WriteCoord(MSG_BROADCAST, self.origin_x);
	WriteCoord(MSG_BROADCAST, self.origin_y);
	WriteCoord(MSG_BROADCAST, self.origin_z);
	self.enemy = activator;
	if (cvar("temp1") == STATE_TOP)
	{
		spawn_bossmusic();
	}
	boss_rise1();
};

void() monster_boss = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	if (ext_snd_oggvorbis)
	{
		precache_sound("music/track9.ogg");
	}
	else
	{
		precache_sound("music/track9.wav");
	}
	precache_model("progs/boss.mdl");
	precache_model("progs/bossh.mdl");
	precache_model("progs/bosshd.mdl");
	precache_model("progs/boulder.mdl");
	precache_model("progs/rubble1.mdl");
	precache_model("progs/rubble2.mdl");
	precache_model("progs/rubble3.mdl");
	precache_sound("boss1/out1.wav");
	precache_sound("boss1/sight1.wav");
	precache_sound("boss1/throw.wav");
	precache_sound("boss1/pain.wav");
	precache_sound("boss1/death.wav");
	precache_sound("misc/rocks.wav");
	precache_sound("misc/explode.wav");
	self.use = boss_awake;
	setmodel(self, "progs/boss.mdl");
	setsize(self, '-121 -89 11', '120 83 277');
	self.movetype = MOVETYPE_NONE;
	self.netname = "solid";
	self.takedamage = DAMAGE_NO;
	self.solid = SOLID_NOT;
	self.classname = "boss";
	self.health = 1000;
	self.deadflag = DEAD_NO;
	self.noblood = 1;
	self.flags = FL_MONSTER | FL_BOSS;
	self.th_die = boss_die;
	self.th_stand = boss_idle1;
	self.th_pain = boss_pain;
};


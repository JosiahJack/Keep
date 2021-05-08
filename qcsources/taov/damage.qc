void(entity attackerb) player_damage_physics = 
{
	makevectors(self.angles);
	if (self.knockback == IT_RELIC1)
	{
		self.velocity = VEC_ORIGIN;
		self.velocity_z = 300;
		if (attackerb.angles_y == STATE_TOP)
		{
			self.velocity_x = 100;
		}
		else
		{
			self.velocity_x = -100;
		}
		if (self.flags & FL_ONGROUND)
		{
			self.flags = self.flags - FL_ONGROUND;
		}
		if (deathmatch == 0)
		{
			self.paincount = IT_RELIC2;
		}
	}
	else
	{
		if (self.knockback == IT_RELIC2)
		{
			self.velocity = VEC_ORIGIN;
			self.velocity_z = 490;
			if (self.flags & FL_ONGROUND)
			{
				self.flags = self.flags - FL_ONGROUND;
			}
			if (deathmatch == 0)
			{
				self.paincount = IT_RELIC2;
			}
		}
		else
		{
			if (self.knockback == AS_MELEE)
			{
				self.velocity = VEC_ORIGIN;
				self.velocity_z = 300;
				if (attackerb.angles_y == STATE_TOP)
				{
					self.velocity_x = 300;
				}
				else
				{
					self.velocity_x = -300;
				}
				if (self.flags & FL_ONGROUND)
				{
					self.flags = self.flags - FL_ONGROUND;
				}
				if (deathmatch == 0)
				{
					self.paincount = IT_RELIC2;
				}
			}
			else
			{
				if (self.knockback == IT_RELIC3)
				{
					self.velocity = VEC_ORIGIN;
					self.velocity_z = 200;
					if (attackerb.angles_y == STATE_TOP)
					{
						self.velocity_x = 50;
					}
					else
					{
						self.velocity_x = -50;
					}
					if (self.flags & FL_ONGROUND)
					{
						self.flags = self.flags - FL_ONGROUND;
					}
					if (deathmatch == 0)
					{
						self.paincount = IT_RELIC2;
					}
				}
				else
				{
					if (self.knockback == TE_LIGHTNING1)
					{
						self.velocity = VEC_ORIGIN;
						self.velocity_z = 350;
						if (attackerb.angles_y == STATE_TOP)
						{
							self.velocity_x = 200;
						}
						else
						{
							self.velocity_x = -200;
						}
						if (self.flags & FL_ONGROUND)
						{
							self.flags = self.flags - FL_ONGROUND;
						}
						if (deathmatch == 0)
						{
							self.paincount = IT_RELIC2;
						}
					}
				}
			}
		}
	}
};

void(entity targ, entity attacker) Killed = 
{
	local entity oself;
	oself = self;
	self = targ;
	self.enemy = attacker;
	if (self.flags & FL_MONSTER && self.bump_kills == 0)
	{
		if (self.target)
		{
			SUB_UseTargets();
		}
		if (self.classname != "archer" && self.mode != IT_RELIC1)
		{
			killed_monsters = killed_monsters + IT_RELIC1;
			WriteByte(MSG_ALL, SVC_KILLEDMONSTER);
		}
		if (random() < 0.25)
		{
			drop_gold();
		}
		self.bump_kills = 1;
	}
	if (self.th_die)
	{
		self.th_die();
	}
	if (deathmatch == 1 && targ.classname == "player" && attacker.classname == "player")
	{
		bprint(attacker.owner.netname);
		bprint(" has slayen ");
		bprint(targ.owner.netname);
		bprint("\n");
		attacker.owner.frags = attacker.owner.frags + IT_RELIC1;
	}
	makevectors(self.angles);
	if (self.knockback == IT_RELIC1)
	{
		self.velocity = VEC_ORIGIN;
		self.velocity_z = 300;
		if (attacker.angles_y == STATE_TOP)
		{
			self.velocity_x = 100;
		}
		else
		{
			self.velocity_x = -100;
		}
		if (self.flags & FL_ONGROUND)
		{
			self.flags = self.flags - FL_ONGROUND;
		}
	}
	else
	{
		if (self.knockback == IT_RELIC2)
		{
			self.velocity = VEC_ORIGIN;
			self.velocity_z = 490;
			if (self.flags & FL_ONGROUND)
			{
				self.flags = self.flags - FL_ONGROUND;
			}
		}
		else
		{
			if (self.knockback == AS_MELEE)
			{
				self.velocity = VEC_ORIGIN;
				self.velocity_z = 300;
				if (attacker.angles_y == STATE_TOP)
				{
					self.velocity_x = 300;
				}
				else
				{
					self.velocity_x = -300;
				}
				if (self.flags & FL_ONGROUND)
				{
					self.flags = self.flags - FL_ONGROUND;
				}
			}
			else
			{
				if (self.knockback == IT_RELIC3)
				{
					self.velocity = VEC_ORIGIN;
					self.velocity_z = 200;
					if (attacker.angles_y == STATE_TOP)
					{
						self.velocity_x = 50;
					}
					else
					{
						self.velocity_x = -50;
					}
					if (self.flags & FL_ONGROUND)
					{
						self.flags = self.flags - FL_ONGROUND;
					}
				}
				else
				{
					if (self.knockback == TE_LIGHTNING1)
					{
						self.velocity = VEC_ORIGIN;
						self.velocity_z = 350;
						if (attacker.angles_y == STATE_TOP)
						{
							self.velocity_x = 200;
						}
						else
						{
							self.velocity_x = -200;
						}
						if (self.flags & FL_ONGROUND)
						{
							self.flags = self.flags - FL_ONGROUND;
						}
					}
				}
			}
		}
	}
	if (self.classname == "player")
	{
		self.owner.health = 1000;
		self.deadflag = DEAD_DEAD;
		self.takedamage = DAMAGE_NO;
	}
	else
	{
		self.deadflag = DEAD_DYING;
	}
	self.touch = SUB_Null;
	self = oself;
};

void(entity targ, entity inflictor, entity attacker, float damage) T_Damage = 
{
	local entity oldself;
	local float save;
	local float rs;
	rs = random() * 100;
	if (!(targ.takedamage) && targ.nopain_time > time || targ.invunerability_finished > time || targ.flypain == 1)
	{
		return;
	}
	if (targ.flags & FL_MONSTER && (attacker.flags & FL_MONSTER))
	{
		return;
	}
	damage_attacker = attacker;
	save = ceil(targ.skin * (damage / TE_LIGHTNING1));
	if (save >= damage && damage > STATE_TOP)
	{
		damage = IT_RELIC1;
		save = STATE_TOP;
	}
	if (attacker.flags & FL_MONSTER && (targ.flags & FL_MONSTER))
	{
		targ.health = targ.health - IT_RELIC1;
	}
	else
	{
		if (targ.classname == "vigil")
		{
			if (targ.skin > STATE_TOP)
			{
				targ.health = targ.health - damage + save;
			}
			else
			{
				targ.health = targ.health - damage;
			}
		}
		else
		{
			if (targ.classname == "zombieboss" || targ.classname == "zombie")
			{
				if (targ.damage_type != IT_RELIC2)
				{
					if (damage < targ.health)
					{
						targ.health = targ.health - damage;
					}
					if (targ.health < targ.state)
					{
						targ.health = targ.state;
					}
				}
				else
				{
					targ.health = targ.health - damage * 1.5;
					targ.state = targ.health;
				}
			}
			else
			{
				targ.health = targ.health - damage;
			}
		}
	}
	if (attacker.flags & FL_MONSTER && attacker.attackedname != "breakable")
	{
		attacker.ai_reattack = 1;
	}
	if (targ.health < IT_RELIC1)
	{
		attacker.ai_reattack = 0;
		Killed(targ, attacker);
		return;
	}
	oldself = self;
	self = targ;
	if (attacker.takedamage && attacker != self.enemy)
	{
		self.enemy = attacker;
		if (self.flags & FL_MONSTER && !(self.flags & FL_BOSS))
		{
			HuntTarget();
		}
	}
	if (self.classname == "player")
	{
		player_damage_physics(attacker);
	}
	if (self.th_pain)
	{
		if (self.health > STATE_TOP)
		{
			self.th_pain();
		}
	}
	attacker.attack_type = STATE_TOP;
	targ.damage_type = STATE_TOP;
	targ.knockback = STATE_TOP;
	self = oldself;
};

void() wall_velocity = 
{
	local vector vel;
	vel = normalize(self.velocity);
	vel = normalize(vel + v_up * (random() - 0.5) + v_right * (random() - 0.5));
	vel = vel + IT_RELIC2 * trace_plane_normal;
	vel = vel * 200;
	return vel_x;
};

float() crandom = 
{
	return IT_RELIC2 * (random() - 0.5);
};

void() BloodSplatThink = 
{
	if (self.flags & FL_ONGROUND || (self.flags & FL_PARTIALGROUND) || self.mode > 999)
	{
		if (self.cnt == 0)
		{
			sound(self, CHAN_AUTO, "misc/blood.wav", IT_RELIC1, ATTN_NORM);
			self.origin_z = self.origin_z + IT_RELIC1;
			self.attack_finished = time + 0.5;
			self.angles_x = 90;
			self.cnt = 1;
		}
	}
	if (self.cnt == 1)
	{
		setmodel(self, "progs/blood2.spr");
		setsize(self, VEC_ORIGIN, VEC_ORIGIN);
		self.scale = self.scale + 0.030000;
		if (self.attack_finished < time)
		{
			if (self.alpha > STATE_TOP)
			{
				self.alpha = self.alpha - 0.040000;
			}
			else
			{
				if (blood_count > STATE_TOP)
				{
					blood_count = blood_count - IT_RELIC1;
				}
				remove(self);
				return;
			}
		}
	}
	self.mode = self.mode + IT_RELIC1;
	frameskip(0.010000);
};

void() BloodSplatTouch = 
{
	self.touch = SUB_Null;
	self.mode = 1000;
	self.think = BloodSplatThink;
	self.nextthink = time + 0.1;
};

void(vector dir, vector org, entity own) ThrowBloodSplat = 
{
	local entity splat;
	if (blood_count < TE_LAVASPLASH)
	{
		splat = spawn();
		splat.movetype = MOVETYPE_TOSS;
		splat.solid = SOLID_NOT;
		dir = normalize(dir);
		splat.velocity = dir * (450 + 50 * random());
		splat.velocity_x = splat.velocity_x + crandom() * 40;
		splat.velocity_y = splat.velocity_y + crandom() * 40;
		splat.velocity_z = splat.velocity_z + 120 + 50 * random();
		splat.avelocity = '2500 1000 4500';
		splat.alpha = IT_RELIC1;
		splat.think = BloodSplatThink;
		splat.nextthink = time + 0.1;
		splat.classname = "blood";
		setmodel(splat, "progs/blood.spr");
		setsize(splat, VEC_ORIGIN, VEC_ORIGIN);
		setorigin(splat, org);
		blood_count = blood_count + IT_RELIC1;
	}
};

void() ThrowBodyPart_HitFloor = 
{
	if (self.mode == 1)
	{
		self.alpha = self.alpha - 0.05;
		if (self.alpha < 0.1)
		{
			remove(self);
			return;
		}
	}
	if (vlen(self.velocity) < IT_RELIC1 || (self.flags & FL_ONGROUND) || (self.flags & FL_PARTIALGROUND) || self.origin == self.oldorigin)
	{
		sound(self, CHAN_BODY, "misc/hitgrond.wav", IT_RELIC1, ATTN_NORM);
		self.angles_x = STATE_TOP;
		self.angles_z = STATE_TOP;
		self.avelocity = VEC_ORIGIN;
		self.cnt = STATE_TOP;
		return;
	}
	if (self.cnt > 50)
	{
		self.mode = 1;
	}
	self.cnt = self.cnt + IT_RELIC1;
	self.nextthink = time + 0.1;
};

void() ThrowBodyPart_Touch = 
{
	if (other.solid != SOLID_BSP)
	{
		return;
	}
	sound(self, CHAN_BODY, "misc/hitgrond.wav", IT_RELIC1, ATTN_NORM);
	self.angles_x = STATE_TOP;
	self.angles_z = STATE_TOP;
	self.avelocity = VEC_ORIGIN;
	self.touch = SUB_Null;
	self.think = SUB_Null;
	self.nextthink = time;
};

void(string gibname) ThrowBodyPart = 
{
	local entity head;
	local float r;
	r = random() * 200;
	head = spawn();
	head.solid = SOLID_TRIGGER;
	head.movetype = MOVETYPE_TOSS;
	head.angles_y = random() * 360;
	makevectors(head.angles);
	head.alpha = IT_RELIC1;
	head.owner = world;
	head.velocity = v_forward * r;
	head.velocity_z = 310;
	head.touch = ThrowBodyPart_Touch;
	head.origin_z = head.origin_z + IT_RELIC1;
	if (head.flags & FL_ONGROUND)
	{
		head.flags = head.flags - FL_ONGROUND;
	}
	head.think = ThrowBodyPart_HitFloor;
	head.nextthink = time;
	head.avelocity = '250 100 100';
	setmodel(head, gibname);
	setorigin(head, self.origin);
	setsize(head, VEC_HULL_MIN, VEC_HULL_MAX);
};

void() ThrowGib_Remove = 
{
	self.alpha = self.alpha - 0.05;
	if (self.alpha < 0.1)
	{
		remove(self);
		return;
	}
	frameskip(0.1);
};

void(string gibname) ThrowGib = 
{
	local entity head;
	head = spawn();
	head.solid = SOLID_TRIGGER;
	head.movetype = MOVETYPE_BOUNCE;
	head.angles_y = random() * 360;
	makevectors(head.angles);
	head.owner = world;
	head.velocity = v_forward * 50;
	head.velocity_z = 200;
	head.alpha = IT_RELIC1;
	if (head.flags & FL_ONGROUND)
	{
		head.flags = head.flags - FL_ONGROUND;
	}
	head.think = ThrowGib_Remove;
	head.nextthink = time + IT_RELIC1;
	head.avelocity = '5000 1000 3000';
	setmodel(head, gibname);
	setorigin(head, self.origin);
	setsize(head, VEC_ORIGIN, VEC_ORIGIN);
};

void(string gibname, vector org, entity own) ThrowHead = 
{
	local entity gib;
	gib = spawn();
	gib.owner = self;
	gib.movetype = MOVETYPE_BOUNCE;
	gib.solid = SOLID_NOT;
	gib.angles_y = random() * 360;
	makevectors(gib.angles);
	gib.velocity = v_forward * 100;
	gib.velocity_z = 400;
	if (gib.flags & FL_ONGROUND)
	{
		gib.flags = gib.flags - FL_ONGROUND;
	}
	gib.avelocity = crandom() * '0 600 0';
	setmodel(gib, gibname);
	setsize(gib, '-16 -16 0', '16 16 56');
	setorigin(gib, org);
};

void(float damg, float dist, float knokback, float rsize, float snd, float flsh, float ignoreair) FireMelee = 
{
	local entity head;
	local entity effect;
	local entity spark;
	local vector dir;
	local vector h;
	local vector IMMEDIATE;
	local entity oself;
	MakeSolidList();
	makevectors(self.angles);
	head = searchradius(self.origin + v_forward * dist, rsize);
	while (head)
	{
		if (head.takedamage && head.flypain == 0 && head != self && head.nopain_time < time && head.deadflag != DEAD_DEAD && visible(head) && (coop == 1 && head.classname != "player" && self.classname == "player" || (coop == 0 || (self.flags & FL_MONSTER))))
		{
			if (head.block_finished < time)
			{
				if (self.flags & FL_MONSTER && !(head.flags & FL_MONSTER) || !(self.flags & FL_MONSTER))
				{
					if (flsh == IT_RELIC1 && self.owner)
					{
						self.owner.screenflash_finished = time + 0.1;
					}
					if (deathmatch == 1)
					{
						damg = damg / AS_MELEE;
					}
					if (sprite_count < IT_RELIC4)
					{
						effect = spawn();
						if (head.solid != SOLID_BSP)
						{
							setorigin(effect, head.origin);
						}
						else
						{
							h = head.absmin + (head.absmax - head.absmin) * 0.5;
							setorigin(effect, h);
						}
						if (self.angles_y == STATE_TOP)
						{
							setmodel(effect, "progs/hit2.spr");
						}
						else
						{
							setmodel(effect, "progs/hit.spr");
						}
						if (darkplaces)
						{
							effect.effects = EF_NODEPTHTEST;
						}
						effect.movetype = MOVETYPE_NOCLIP;
						effect.think = fx_think;
						effect.nextthink = time;
						effect.solid = SOLID_NOT;
						sprite_count = sprite_count + IT_RELIC1;
					}
					if (snd == STATE_TOP)
					{
						sound(self, CHAN_BODY, "player/swordhit.wav", IT_RELIC1, ATTN_NORM);
					}
					else
					{
						if (snd == IT_RELIC1)
						{
							sound(self, CHAN_BODY, "player/kickhit.wav", IT_RELIC1, ATTN_NORM);
						}
						else
						{
							if (snd == IT_RELIC2)
							{
								sound(self, CHAN_BODY, "player/jmphit.wav", IT_RELIC1, ATTN_NORM);
							}
							else
							{
								if (snd == AS_MELEE)
								{
									sound(self, CHAN_BODY, "player/hit.wav", IT_RELIC1, ATTN_NORM);
								}
								else
								{
									if (snd == IT_RELIC3)
									{
										sound(self, CHAN_BODY, "player/bighit.wav", IT_RELIC1, ATTN_NORM);
									}
									else
									{
										if (snd == TE_LIGHTNING1)
										{
											sound(self, CHAN_BODY, "player/bigcut.wav", IT_RELIC1, ATTN_NORM);
										}
										else
										{
											if (snd == TE_LIGHTNING2)
											{
												sound(self, CHAN_BODY, "player/hugekick.wav", IT_RELIC1, ATTN_NORM);
											}
										}
									}
								}
							}
						}
					}
					if (head.grabbed == 1)
					{
						head.grabbed = 0;
					}
					if (head.noblood == 0)
					{
						ThrowBloodSplat(dir, head.origin, head);
					}
					if (self.classname == "player")
					{
						if (deathmatch == 0)
						{
							self.owner.ammo_shells = self.owner.ammo_shells + IT_RELIC1;
							combo = combo + IT_RELIC1;
						}
						else
						{
							self.owner.ammo_shells = self.owner.ammo_shells + IT_RELIC2;
							self.owner.dm_combo = self.owner.dm_combo + IT_RELIC1;
						}
					}
					if (head.solid != SOLID_BSP && head.angles == self.angles)
					{
						head.angles_y = head.angles_y + 180;
						if (head.angles_y == 360)
						{
							head.angles_y = STATE_TOP;
						}
					}
					head.knockback = knokback;
					if (knokback == IT_RELIC2)
					{
						head.nopain_time = time + 0.3;
					}
					head.damage_type = self.attack_type;
					T_Damage(head, self, self, damg);
					if (self.flags & FL_MONSTER)
					{
						self.attack_type = STATE_TOP;
					}
					if (self.classname == "player" && head.solid != SOLID_BSP && head.classname != "breakable")
					{
						self.enemy = head;
					}
					self.attackedname = head.classname;
					if (!(self.flags & FL_ONGROUND) && ignoreair == 0)
					{
						head.aircombo_finished = time + 0.5;
						self.velocity_x = head.velocity_x;
						self.velocity_z = STATE_TOP;
						self.velocity_z = head.velocity_z = self.velocity_z + 150;
					}
				}
			}
			else
			{
				if (head.solid != SOLID_BSP)
				{
					if (self.angles_y > 90 && self.angles_y < 270)
					{
						head.angles_y = STATE_TOP;
					}
					else
					{
						head.angles_y = 180;
					}
				}
				if (sprite_count < TE_LAVASPLASH)
				{
					effect = spawn();
					setorigin(effect, head.origin);
					setmodel(effect, "progs/block.spr");
					if (darkplaces)
					{
						effect.effects = EF_NODEPTHTEST;
					}
					effect.movetype = MOVETYPE_NONE;
					effect.think = fx_think;
					effect.nextthink = time;
					effect.solid = SOLID_NOT;
					sprite_count = sprite_count + IT_RELIC1;
				}
				spark = spawn();
				spark.angles_y = random() * 360;
				makevectors(spark.angles);
				spark.velocity = v_forward * 100;
				spark.velocity_z = 100;
				spark.owner = head;
				spark.movetype = MOVETYPE_BOUNCE;
				spark.solid = SOLID_NOT;
				spark.classname = "spark";
				setmodel(spark, "progs/null.spr");
				setsize(spark, VEC_ORIGIN, VEC_ORIGIN);
				makevectors(head.angles);
				setorigin(spark, head.origin + v_forward * SVC_LIGHTSTYLE);
				spark.attack_finished = time + 0.8;
				spark.think = sparkeffect;
				spark.nextthink = time + 0.010000;
				makevectors(self.angles);
				if (head.classname == "player")
				{
					head.knockback = knokback;
					head.effects = EF_MUZZLEFLASH;
					if (head.knockback == IT_RELIC2 || head.knockback == AS_MELEE || head.knockback == TE_LIGHTNING1)
					{
						head.think = player_blockbrk1;
					}
					else
					{
						head.think = player_block;
						head.counter_finished = time + 0.3;
					}
					head.knockback = STATE_TOP;
					head.nextthink = time + 0.1;
				}
				if (self.flags & FL_MONSTER)
				{
					self.velocity = VEC_ORIGIN;
					self.flags = self.flags - (self.flags & FL_ONGROUND);
					self.velocity = self.velocity + TE_LIGHTNING3 * v_forward * -8;
					self.velocity = self.velocity + 90 * '0 0 2';
					if (self.th_pain)
					{
						self.paincount = self.paincount - IT_RELIC1;
						self.th_pain();
					}
				}
				if (!(self.flags & FL_ONGROUND))
				{
					head.knockback = knokback;
					if (head.flags & FL_MONSTER)
					{
						oself = self;
						self = head;
						monster_pain(oself);
						self = oself;
						head.aircombo_finished = time + 0.5;
						if (ignoreair == 0)
						{
							self.velocity_x = head.velocity_x;
							self.velocity_z = STATE_TOP;
							self.velocity_z = head.velocity_z = self.velocity_z + 150;
						}
					}
					else
					{
						if (head.classname == "player" && head.onground == 0)
						{
							oself = self;
							self = head;
							player_damage_physics(oself);
							self = oself;
							head.knockback = STATE_TOP;
						}
					}
				}
				sound(self, CHAN_BODY, "player/block.wav", IT_RELIC1, ATTN_NORM);
			}
		}
		head = head.chain;
	}
	UnmakeSolidList();
};


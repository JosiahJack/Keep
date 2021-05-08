void() chargeparticle_think = 
{
	if (self.attack_finished < time || !(self.owner))
	{
		remove(self);
		return;
	}
	if (self.cnt == STATE_TOP)
	{
		particle(self.origin, VEC_ORIGIN, 208, TE_LAVASPLASH);
		particle(self.origin, VEC_ORIGIN, 208, TE_LAVASPLASH);
		setmodel(self, "progs/s_bluep.spr");
		if (self.frame < PLAT_LOW_TRIGGER)
		{
			self.frame = self.frame + PLAT_LOW_TRIGGER;
		}
		else
		{
			self.frame = STATE_TOP;
		}
	}
	if (self.cnt == PLAT_LOW_TRIGGER)
	{
		particle(self.origin, VEC_ORIGIN, 70, TE_LAVASPLASH);
		particle(self.origin, VEC_ORIGIN, 70, TE_LAVASPLASH);
		setmodel(self, "progs/s_redp.spr");
		if (self.frame < PLAT_LOW_TRIGGER)
		{
			self.frame = self.frame + PLAT_LOW_TRIGGER;
		}
		else
		{
			self.frame = STATE_TOP;
		}
	}
	if (self.origin_x < self.owner.origin_x)
	{
		self.velocity_x = self.velocity_x + SVC_SIGNONNUM * frametime * 75;
	}
	if (self.origin_x > self.owner.origin_x)
	{
		self.velocity_x = self.velocity_x - SVC_SIGNONNUM * frametime * 75;
	}
	if (self.origin_y < self.owner.origin_y)
	{
		self.velocity_y = self.velocity_y + SVC_SIGNONNUM * frametime * 75;
	}
	if (self.origin_y > self.owner.origin_y)
	{
		self.velocity_y = self.velocity_y - SVC_SIGNONNUM * frametime * 75;
	}
	if (self.origin_z < self.owner.origin_z)
	{
		self.velocity_z = self.velocity_z + SVC_SIGNONNUM * frametime * 75;
	}
	if (self.origin_z > self.owner.origin_z)
	{
		self.velocity_z = self.velocity_z - SVC_SIGNONNUM * frametime * 75;
	}
	self.nextthink = time + 0.010000;
};

void(float w) spawn_chargeparticle = 
{
	local entity part;
	local float x;
	local float y;
	local float z;
	x = random() * FL_NOTARGET - FL_GODMODE;
	y = random() * FL_NOTARGET - FL_GODMODE;
	z = random() * FL_NOTARGET - FL_GODMODE;
	part = spawn();
	part.owner = self;
	part.movetype = MOVETYPE_NOCLIP;
	part.solid = SOLID_NOT;
	part.classname = "particle";
	if (darkplaces)
	{
		part.effects = EF_NODEPTHTEST;
	}
	setorigin(part, part.owner.origin + v_forward * x + v_up * y + v_right * z);
	part.alpha = 0.7;
	part.attack_finished = time + 0.2;
	part.cnt = w;
	part.think = chargeparticle_think;
	part.nextthink = time + 0.010000;
};

void() spawn_magicfog = 
{
	local vector org;
	local entity s;
	s = spawn();
	org = self.origin;
	s.origin = org;
	s.nextthink = time + 0.1;
	s.think = SUB_Remove;
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_TELEPORT);
	WriteCoord(MSG_BROADCAST, org_x);
	WriteCoord(MSG_BROADCAST, org_y);
	WriteCoord(MSG_BROADCAST, org_z);
};

void() FireBallHomeIn = 
{
	local entity head;
	local entity effect;
	MakeSolidList();
	head = searchradius(self.origin, SVC_SIGNONNUM);
	while (head)
	{
		if (head.takedamage && self.owner != head && head == self.enemy)
		{
			effect = spawn();
			setorigin(effect, head.origin + v_up * SVC_UPDATEFRAGS);
			setmodel(effect, "progs/fire.spr");
			effect.movetype = MOVETYPE_NONE;
			effect.think = firesprite_think;
			effect.nextthink = time;
			effect.solid = SOLID_NOT;
			if (deathmatch == 1)
			{
				self.mode = self.mode / AS_MELEE;
			}
			if (head.block_finished < time)
			{
				head.damage_type = IT_RELIC2;
				T_Damage(head, self.owner, self.owner, self.mode);
				if (self.owner.classname == "player")
				{
					if (deathmatch == 0)
					{
						combo = combo + PLAT_LOW_TRIGGER;
					}
					else
					{
						self.owner.owner.dm_combo = self.owner.owner.dm_combo + PLAT_LOW_TRIGGER;
					}
				}
			}
			else
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
			sound(self, CHAN_BODY, "spells/fhit.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
			remove(self);
			return;
		}
		head = head.chain;
	}
	UnmakeSolidList();
	if (self.enemy == world || self.velocity == VEC_ORIGIN || self.origin == self.oldorigin || self.enemy.health <= STATE_TOP)
	{
		effect = spawn();
		setorigin(effect, self.origin + v_up * SVC_UPDATEFRAGS);
		setmodel(effect, "progs/fire.spr");
		effect.movetype = MOVETYPE_NONE;
		effect.think = firesprite_think;
		effect.nextthink = time;
		effect.solid = SOLID_NOT;
		sound(self, CHAN_BODY, "spells/fhit.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
		remove(self);
		return;
	}
	if (self.fireballhome_finished < time)
	{
		self.velocity_x = self.velocity_x / IT_RELIC2;
		self.velocity_y = self.velocity_y / IT_RELIC2;
		self.fireballhome_finished = time + 1.5;
	}
	if (self.origin_x < self.enemy.origin_x)
	{
		self.velocity_x = self.velocity_x + SVC_SIGNONNUM * frametime * 75;
	}
	if (self.origin_x > self.enemy.origin_x)
	{
		self.velocity_x = self.velocity_x - SVC_SIGNONNUM * frametime * 75;
	}
	if (self.origin_y < self.enemy.origin_y)
	{
		self.velocity_y = self.velocity_y + SVC_SIGNONNUM * frametime * 75;
	}
	if (self.origin_y > self.enemy.origin_y)
	{
		self.velocity_y = self.velocity_y - SVC_SIGNONNUM * frametime * 75;
	}
	if (self.origin_z < self.enemy.origin_z)
	{
		self.velocity_z = self.velocity_z + SVC_SIGNONNUM * frametime * 75;
	}
	if (self.origin_z > self.enemy.origin_z)
	{
		self.velocity_z = self.velocity_z - SVC_SIGNONNUM * frametime * 75;
	}
	if (self.flags & FL_ONGROUND)
	{
		self.flags = self.flags - FL_ONGROUND;
	}
	self.oldorigin = self.origin;
};

void() FireballWallTouch = 
{
	local entity effect;
	if (other != self.owner)
	{
		effect = spawn();
		setorigin(effect, self.origin + v_up * SVC_UPDATEFRAGS);
		setmodel(effect, "progs/fire.spr");
		effect.movetype = MOVETYPE_NONE;
		effect.think = firesprite_think;
		effect.nextthink = time;
		effect.solid = SOLID_NOT;
		sound(self, CHAN_BODY, "spells/fhit.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
		remove(self);
		return;
	}
};

void() FireBallThink = 
{
	local entity head;
	local entity effect;
	head = find(world, netname, "solid");
	while (head)
	{
		if (head.takedamage && self.owner != head && visible(head) && head.health > STATE_TOP)
		{
			if (self.owner.classname == "player")
			{
				if (deathmatch == 0)
				{
					if (head.goalentity != world && (head.flags & FL_MONSTER))
					{
						self.enemy = head;
					}
				}
				else
				{
					if (head.classname == "player")
					{
						self.enemy = head;
					}
				}
			}
			else
			{
				if (self.owner.flags & FL_MONSTER)
				{
					if (head.classname == "player")
					{
						self.enemy = head;
					}
				}
			}
		}
		head = find(head, netname, "solid");
	}
	if (self.enemy)
	{
		FireBallHomeIn();
	}
	if (self.cnt > 200)
	{
		effect = spawn();
		setorigin(effect, self.origin + v_up * SVC_UPDATEFRAGS);
		setmodel(effect, "progs/fire.spr");
		effect.movetype = MOVETYPE_NONE;
		effect.think = firesprite_think;
		effect.nextthink = time;
		effect.solid = SOLID_NOT;
		remove(self);
		return;
	}
	if (self.owner.classname == "player")
	{
		self.cnt = self.cnt + PLAT_LOW_TRIGGER;
	}
	else
	{
		self.cnt = self.cnt + AS_MELEE;
	}
	self.nextthink = time + 0.010000;
};

void(float damg, float hight) Fireball = 
{
	local entity missile;
	makevectors(self.angles);
	sound(self, CHAN_BODY, "spells/fball.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	missile = spawn();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_SLIDEBOX;
	missile.classname = "fireball";
	makevectors(self.angles);
	missile.velocity = aim(self, 800);
	missile.velocity = missile.velocity * 800;
	missile.angles = vectoangles(missile.velocity);
	missile.avelocity = '600 300 150';
	missile.mode = damg;
	missile.touch = FireballWallTouch;
	missile.nextthink = time + 0.1;
	missile.think = FireBallThink;
	setmodel(missile, "progs/fball.mdl");
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(missile, self.origin + v_forward * IT_RELIC4 + v_up * hight);
};

void() LightningThink = 
{
	local entity temp;
	local entity head;
	local vector source;
	local vector org;
	local float r;
	r = random();
	MakeSolidList();
	source = self.origin;
	traceline(source, source - v_up * 300, 0, self);
	org = trace_endpos - v_up * IT_RELIC4;
	head = searchradius(org, 60);
	while (head)
	{
		if (head.takedamage && self.owner != head && (coop == 1 && head.classname != "player" && self.owner.classname == "player" || (self.owner.flags & FL_MONSTER) || coop == 0))
		{
			if (self.owner.flags & FL_MONSTER && !(head.flags & FL_MONSTER) || !(self.owner.flags & FL_MONSTER))
			{
				if (self.owner.classname == "player")
				{
					if (deathmatch == 0)
					{
						combo = combo + PLAT_LOW_TRIGGER;
					}
					else
					{
						self.owner.owner.dm_combo = self.owner.owner.dm_combo + PLAT_LOW_TRIGGER;
					}
				}
				if (head.classname == "player")
				{
					head.paincount = STATE_TOP;
				}
				sound(self, CHAN_BODY, "weapons/lhit.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
				head.velocity = '0 0 50';
				head.damage_type = IT_RELIC3;
				if (self.owner.classname == "player")
				{
					if (deathmatch == 0)
					{
						T_Damage(head, self.owner, self.owner, IT_RELIC2);
					}
					else
					{
						T_Damage(head, self.owner, self.owner, PLAT_LOW_TRIGGER);
					}
				}
				else
				{
					T_Damage(head, self.owner, self.owner, PLAT_LOW_TRIGGER);
				}
				self.cnt = self.cnt + PLAT_LOW_TRIGGER;
			}
		}
		head = head.chain;
	}
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
	temp.think = SUB_Remove;
	temp.nextthink = time + 0.010000;
	setmodel(temp, "progs/lightnin.spr");
	setsize(temp, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(temp, self.origin - v_up * 65);
	UnmakeSolidList();
	if (self.attack_finished < time)
	{
		lightning_count = lightning_count - PLAT_LOW_TRIGGER;
		remove(self);
		return;
	}
	frameskip(0.07);
};

void() LightningStorm = 
{
	local entity missile;
	local float r;
	if (random() < 0.25 && self.classname == "player")
	{
		self.owner.screenflash_finished = time + 0.020000;
	}
	if (lightning_count < SVC_SIGNONNUM)
	{
		r = random();
		missile = spawn();
		missile.owner = self;
		missile.movetype = MOVETYPE_NOCLIP;
		missile.solid = SOLID_NOT;
		missile.classname = "lightning";
		missile.angles_y = random() * 360;
		makevectors(missile.angles);
		missile.velocity = aim(self, 500);
		missile.velocity = missile.velocity * 500;
		missile.angles = vectoangles(missile.velocity);
		missile.alpha = 0.5;
		missile.think = LightningThink;
		missile.nextthink = time + 0.010000;
		missile.attack_finished = time + 0.3;
		missile.avelocity = '400 600 200';
		setmodel(missile, "progs/lball.spr");
		setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
		setorigin(missile, self.origin + '0 0 110');
		if (self.classname == "player")
		{
			self.owner.attack_finished = time + 0.2;
		}
		else
		{
			missile.owner.attack_finished = time + 0.2;
		}
		self.lcount = self.lcount + PLAT_LOW_TRIGGER;
		lightning_count = lightning_count + PLAT_LOW_TRIGGER;
	}
};

void() iced_think = 
{
	if (self.attack_finished < time)
	{
		self.cnt2 = self.cnt2 + PLAT_LOW_TRIGGER;
		if (self.cnt2 > TE_LIGHTNING1)
		{
			sound(self, CHAN_BODY, "spells/shatter.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
			remove(self);
			return;
		}
		self.attack_finished = time + 0.1;
	}
	self.nextthink = time + 0.010000;
};

void() iced_particle = 
{
	particle(self.origin, VEC_ORIGIN, 208, IT_RELIC4);
	particle(self.origin, VEC_ORIGIN, 208, IT_RELIC4);
	if (!(self.velocity))
	{
		remove(self);
		return;
	}
	self.nextthink = time + 0.1;
};

void() icefield_think = 
{
	local entity head;
	local entity effect;
	local entity effect2;
	droptofloor();
	if (self.attack_finished < time)
	{
		if (self.frame < SVC_UPDATECOLORS)
		{
			self.frame = self.frame + PLAT_LOW_TRIGGER;
			self.cnt2 = self.cnt2 + IT_RELIC3;
		}
		self.attack_finished = time + 0.080000;
	}
	if (self.pain_finished < time)
	{
		if (self.frame > STATE_TOP)
		{
			self.frame = self.frame - PLAT_LOW_TRIGGER;
			self.cnt2 = self.cnt2 - IT_RELIC3;
		}
		else
		{
			remove(self);
			return;
		}
	}
	MakeSolidList();
	head = searchradius(self.origin, self.cnt2);
	while (head)
	{
		if (self.owner != head && head.takedamage && head.iced_time < time && visible(head) && (coop == 1 && head.classname != "player" && self.owner.classname == "player" || (self.owner.flags & FL_MONSTER) || coop == 0))
		{
			if (self.owner.flags & FL_MONSTER && !(head.flags & FL_MONSTER) || !(self.owner.flags & FL_MONSTER))
			{
				if (head.flags & FL_ONGROUND || head.onground == 1)
				{
					if (head.th_pain)
					{
						effect = spawn();
						setorigin(effect, head.origin);
						setmodel(effect, "progs/iced.mdl");
						effect.movetype = MOVETYPE_NONE;
						effect.think = iced_think;
						effect.nextthink = time;
						effect.solid = SOLID_NOT;
						effect.alpha = 0.2;
						effect2 = spawn();
						setorigin(effect2, head.origin + v_up * IT_RELIC5);
						setmodel(effect2, "progs/null.spr");
						effect2.movetype = MOVETYPE_BOUNCE;
						effect2.think = iced_particle;
						effect2.nextthink = time;
						effect2.angles_y = random() * 360;
						makevectors(effect2.angles);
						effect2.velocity = v_forward * 80;
						sound(self, CHAN_BODY, "spells/freeze.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
						head.paincount = STATE_TOP;
						head.velocity = VEC_ORIGIN;
						effect.angles_x = effect.angles_y = effect.angles_z = random() * 360;
						head.damage_type = AS_MELEE;
						if (deathmatch == 0)
						{
							T_Damage(head, self.owner, self.owner, AS_MELEE);
						}
						else
						{
							T_Damage(head, self.owner, self.owner, PLAT_LOW_TRIGGER);
						}
						if (self.owner.classname == "player")
						{
							if (deathmatch == 0)
							{
								combo = combo + PLAT_LOW_TRIGGER;
							}
							else
							{
								self.owner.owner.dm_combo = self.owner.owner.dm_combo + PLAT_LOW_TRIGGER;
							}
						}
						head.iced_time = time + 0.5;
					}
				}
			}
		}
		head = head.chain;
	}
	UnmakeSolidList();
	self.nextthink = time + 0.010000;
};

void() chargeice_effect = 
{
	if (self.frame > IT_RELIC3)
	{
		self.frame = self.frame + PLAT_LOW_TRIGGER;
		if (self.frame > TE_LIGHTNING3)
		{
			remove(self);
		}
		self.nextthink = time + 0.1;
		return;
	}
	if (self.mode < time)
	{
		if (self.frame < IT_RELIC3)
		{
			self.frame = self.frame + PLAT_LOW_TRIGGER;
		}
		else
		{
			remove(self);
			return;
		}
		self.mode = time + 0.080000;
	}
	spawn_chargeparticle(STATE_TOP);
	self.nextthink = time + 0.010000;
};

void() IceField = 
{
	local entity effect;
	local entity missile;
	makevectors(self.angles);
	effect = spawn();
	setorigin(effect, self.origin + v_right * IT_RELIC5);
	setmodel(effect, "progs/chargice.spr");
	effect.movetype = MOVETYPE_NONE;
	effect.solid = SOLID_NOT;
	effect.frame = TE_LIGHTNING1;
	effect.alpha = 0.6;
	effect.think = chargeice_effect;
	effect.nextthink = time;
	sound(effect, CHAN_AUTO, "spells/flnch.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	sound(effect, CHAN_VOICE, "spells/iceyair.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	missile = spawn();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLY;
	missile.solid = SOLID_NOT;
	missile.classname = "icefield";
	missile.alpha = 0.3;
	missile.think = icefield_think;
	missile.nextthink = time + 0.010000;
	missile.pain_finished = time + TE_LAVASPLASH;
	if (darkplaces)
	{
		missile.effects = EF_NODEPTHTEST;
	}
	setmodel(missile, "progs/icef.mdl");
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(missile, self.origin);
};

void() chargebeam_effect = 
{
	if (self.mode < time)
	{
		if (self.frame < TE_WIZSPIKE)
		{
			self.frame = self.frame + PLAT_LOW_TRIGGER;
		}
		else
		{
			remove(self);
			return;
		}
		self.mode = time + 0.1;
	}
	spawn_chargeparticle(PLAT_LOW_TRIGGER);
	self.nextthink = time + 0.010000;
};

void() firebeam_think = 
{
	local entity head;
	local entity effect;
	if (self.attack_finished < time)
	{
		if (self.frame < TE_LIGHTNING1)
		{
			self.alpha = self.alpha - 0.1;
			self.frame = self.frame + PLAT_LOW_TRIGGER;
		}
		else
		{
			remove(self);
			return;
		}
	}
	if (self.frame == STATE_TOP)
	{
		MakeSolidList();
		head = searchradius(self.origin, 50);
		while (head)
		{
			if (head != self && visible(head) && head.takedamage && self.owner != head && head.deadflag != DEAD_DEAD && (coop == 1 && head.classname != "player" && self.owner.classname == "player" || (self.owner.flags & FL_MONSTER) || coop == 0))
			{
				if (self.owner.flags & FL_MONSTER && !(head.flags & FL_MONSTER) || !(self.owner.flags & FL_MONSTER))
				{
					if (sprite_count < TE_LIGHTNING1)
					{
						effect = spawn();
						setorigin(effect, head.origin + v_up * SVC_UPDATEFRAGS);
						setmodel(effect, "progs/fire.spr");
						effect.movetype = MOVETYPE_NONE;
						effect.think = firesprite_think;
						effect.nextthink = time;
						effect.solid = SOLID_NOT;
						sprite_count = sprite_count + PLAT_LOW_TRIGGER;
					}
					if (deathmatch == 1)
					{
						self.mode = PLAT_LOW_TRIGGER;
					}
					head.airdamage_finished = time + 0.2;
					head.damage_type = IT_RELIC2;
					T_Damage(head, self.owner, self.owner, self.mode);
					if (self.owner.classname == "player")
					{
						if (deathmatch == 0)
						{
							combo = combo + PLAT_LOW_TRIGGER;
						}
						else
						{
							self.owner.owner.dm_combo = self.owner.owner.dm_combo + PLAT_LOW_TRIGGER;
						}
					}
					head.velocity = '0 0 75';
					if (head.flags & FL_ONGROUND)
					{
						head.flags = head.flags - FL_ONGROUND;
					}
					if (self.owner.angles_y == STATE_TOP)
					{
						head.velocity_x = 50;
					}
					else
					{
						head.velocity_x = -50;
					}
					sound(self, CHAN_BODY, "spells/fhit.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
				}
			}
			head = head.chain;
		}
		UnmakeSolidList();
	}
	self.nextthink = time + 0.1;
};

void() beameffect_think = 
{
	makevectors(self.owner.angles);
	setorigin(self, self.owner.origin + v_forward * 36 + '0 0 12');
	if (self.frame < TE_WIZSPIKE)
	{
		self.frame = self.frame + PLAT_LOW_TRIGGER;
	}
	else
	{
		self.frame = STATE_TOP;
	}
	if (self.owner.beams_shot < PLAT_LOW_TRIGGER)
	{
		remove(self);
		return;
	}
	self.nextthink = time + 0.010000;
};

void() Firebeam_Muzzle = 
{
	local entity effect;
	local vector ang;
	ang = self.angles;
	if (self.flags & FL_MONSTER)
	{
		ang_x = ang_x * CONTENT_EMPTY;
	}
	makevectors(ang);
	effect = spawn();
	effect.owner = self;
	effect.movetype = MOVETYPE_NONE;
	effect.solid = SOLID_NOT;
	effect.classname = "firebeameffect";
	effect.think = beameffect_think;
	effect.nextthink = time + 0.1;
	effect.alpha = 0.5;
	effect.angles_y = self.angles_y - 180;
	effect.angles_x = ang_x;
	effect.angles_z = self.angles_z;
	effect.effects = EF_DIMLIGHT | EF_ADDITIVE;
	setmodel(effect, "progs/beam1.mdl");
	setsize(effect, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(effect, self.origin + v_forward * 36 + '0 0 12');
};

void(float damg, float hight) Firebeam = 
{
	local entity beam;
	local vector ang;
	if (self.flags & FL_MONSTER)
	{
		ang = self.angles;
		ang_x = ang_x * CONTENT_EMPTY;
		makevectors(ang);
	}
	else
	{
		makevectors(self.angles);
	}
	if (self.firebeamSound_finished < time)
	{
		self.firebeamSound_finished = time + 0.4;
		sound(self, CHAN_BODY, "spells/fbeam.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	}
	beam = spawn();
	beam.owner = self;
	beam.movetype = MOVETYPE_NOCLIP;
	beam.solid = SOLID_NOT;
	beam.classname = "firebeam";
	beam.velocity = aim(self, 500);
	beam.velocity = beam.velocity * 500;
	beam.angles = vectoangles(beam.velocity);
	beam.alpha = 0.5;
	beam.attack_finished = time + 0.5;
	beam.nextthink = time + 0.010000;
	beam.think = firebeam_think;
	beam.mode = damg;
	beam.effects = EF_ADDITIVE;
	setmodel(beam, "progs/beam2.mdl");
	setsize(beam, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(beam, self.origin + v_forward * 55 + v_up * hight);
};

void() TwisterThink = 
{
	local entity head;
	local vector vdestdelta;
	local float len;
	local float traveltime;
	local float r;
	local entity temp;
	r = random();
	if (self.mode == STATE_TOP)
	{
		if (self.frame < SVC_TEMPENTITY)
		{
			self.frame = self.frame + PLAT_LOW_TRIGGER;
		}
		else
		{
			self.mode = PLAT_LOW_TRIGGER;
		}
	}
	else
	{
		if (self.mode == PLAT_LOW_TRIGGER)
		{
			makevectors(self.mangle);
			if (random() < 0.030000)
			{
				self.mangle_y = self.mangle_y + random() * 360;
			}
			self.velocity = v_forward * 100;
			self.flags = self.flags - FL_ONGROUND;
			len = vlen(vdestdelta);
			traveltime = len / 400;
			head = findradius(self.origin, 115);
			while (head)
			{
				self.enemy = head;
				if (visible(head) && (head.flags & FL_MONSTER || deathmatch == 1) && head != self.owner)
				{
					vdestdelta = self.origin - self.enemy.origin;
					len = vlen(vdestdelta);
					traveltime = len / 600;
					self.enemy.flags = self.enemy.flags - (self.enemy.flags & FL_ONGROUND);
					self.enemy.velocity = vdestdelta * (PLAT_LOW_TRIGGER / traveltime);
				}
				head = head.chain;
			}
			if (self.frame < 47)
			{
				self.frame = self.frame + PLAT_LOW_TRIGGER;
			}
			else
			{
				self.frame = SVC_SETPAUSE;
			}
			if (self.attack_finished < time)
			{
				self.mode = IT_RELIC2;
				self.frame = 49;
			}
		}
		else
		{
			if (self.frame < 73)
			{
				self.frame = self.frame + PLAT_LOW_TRIGGER;
				self.velocity_z = 50;
			}
			else
			{
				remove(self);
				return;
			}
		}
	}
	MakeSolidList();
	head = searchradius(self.origin, 50);
	while (head)
	{
		if (head.takedamage && self.owner != head && self.mode == PLAT_LOW_TRIGGER && head.twister_damage_finished < time && (coop == 1 && head.classname != "player" && self.owner.classname == "player" || (self.owner.flags & FL_MONSTER) || coop == 0))
		{
			if (self.owner.flags & FL_MONSTER && !(head.flags & FL_MONSTER) || !(self.owner.flags & FL_MONSTER))
			{
				if (self.owner.classname == "player")
				{
					if (deathmatch == 0)
					{
						combo = combo + PLAT_LOW_TRIGGER;
					}
					else
					{
						self.owner.owner.dm_combo = self.owner.owner.dm_combo + PLAT_LOW_TRIGGER;
					}
				}
				head.paincount = STATE_TOP;
				head.knockback = STATE_TOP;
				head.damage_type = PLAT_LOW_TRIGGER;
				if (head.movetype == MOVETYPE_FLY || head.movetype == MOVETYPE_NOCLIP)
				{
					T_Damage(head, self.owner, self.owner, AS_MELEE);
				}
				if (self.owner.classname == "player")
				{
					if (deathmatch == 0)
					{
						T_Damage(head, self.owner, self.owner, TE_LIGHTNING1);
					}
					else
					{
						T_Damage(head, self.owner, self.owner, IT_RELIC2);
					}
				}
				else
				{
					T_Damage(head, self.owner, self.owner, AS_MELEE);
				}
				sound(self, CHAN_VOICE, "player/swordhit.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
				head.twister_damage_finished = time + 0.5;
				if (head.enemy != world && head.movetype != MOVETYPE_NOCLIP && (head.flags & FL_MONSTER))
				{
					head.enemy = world;
					temp = self;
					self = head;
					if (self.th_stand)
					{
						self.th_stand();
					}
					self = temp;
				}
				head.velocity = VEC_ORIGIN;
				self.velocity_z = head.velocity_z + 75;
				if (head.flags & FL_ONGROUND)
				{
					head.flags = head.flags - (head.flags & FL_ONGROUND);
				}
			}
		}
		head = head.chain;
	}
	UnmakeSolidList();
	frameskip(0.1);
};

void() Twister = 
{
	local entity missile;
	local float r;
	r = random();
	missile = spawn();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLY;
	missile.solid = SOLID_NOT;
	missile.classname = "twister";
	missile.angles_y = random() * 360;
	makevectors(missile.angles);
	missile.velocity = aim(self, SVC_SIGNONNUM);
	missile.velocity = missile.velocity * SVC_SIGNONNUM;
	missile.angles = vectoangles(missile.velocity);
	missile.alpha = 0.7;
	missile.think = TwisterThink;
	missile.nextthink = time + 0.1;
	missile.attack_finished = time + TE_LAVASPLASH;
	setmodel(missile, "progs/twister.mdl");
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(missile, self.origin);
	if (self.classname == "player")
	{
		self.owner.attack_finished = time + PLAT_LOW_TRIGGER;
	}
	else
	{
		missile.owner.attack_finished = time + PLAT_LOW_TRIGGER;
	}
};


float(float pitch) turret_frame = 
{
	return floor(pitch / 5.625);
};

float(float pitch) turret_fireframe = 
{
	return turret_frame(pitch) + SVC_TEMPENTITY;
};

void() CheckTurretAttack = 
{
	local vector spot1;
	local vector spot2;
	local entity targ;
	local float chance;
	targ = self.enemy;
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;
	traceline(spot1, spot2, 0, self);
	if (trace_ent != targ)
	{
		return 0;
	}
	if (trace_inopen && trace_inwater)
	{
		return 0;
	}
	if (time < self.attack_finished)
	{
		return 0;
	}
	if (enemy_range == RANGE_MELEE)
	{
		chance = 0.9;
	}
	else
	{
		if (enemy_range == RANGE_NEAR)
		{
			chance = 0.5;
		}
		else
		{
			if (enemy_range == RANGE_MID)
			{
				chance = 0.2;
			}
			else
			{
				chance = 0.05;
			}
		}
	}
	if (random() < chance)
	{
		self.th_missile();
		if (self.spawnflags & TUR_LASERS)
		{
			SUB_AttackFinished(1.5 + SERVOBOD_RIGHT * random());
		}
		if (self.spawnflags & TUR_ROCKETS)
		{
			SUB_AttackFinished(1.5 + SERVOBOD_LEFT * random());
		}
		if (self.spawnflags & TUR_PPC)
		{
			SUB_AttackFinished(SERVOBOD_RIGHT + SERVOBOD_RIGHT * random());
		}
		else
		{
			SUB_AttackFinished(SERVOBOD_BOTH + 1.5 * random());
		}
		return 1;
	}
	return 0;
};

void() turret_face = 
{
	local vector tmpvec;
	local float idealframe;
	tmpvec = vectoangles(self.origin - (self.enemy.origin + self.enemy.view_ofs));
	if (tmpvec_x > self.rotate_type)
	{
		if (tmpvec_x > self.rotate_type + TE_LIGHTNING2)
		{
			self.rotate_type = self.rotate_type + TE_LIGHTNING2;
		}
		else
		{
			self.rotate_type = tmpvec_x;
		}
	}
	else
	{
		if (tmpvec_x < self.rotate_type)
		{
			if (tmpvec_x < self.rotate_type - TE_LIGHTNING2)
			{
				self.rotate_type = self.rotate_type - TE_LIGHTNING2;
			}
			else
			{
				self.rotate_type = tmpvec_x;
			}
		}
	}
	self.frame = turret_frame(self.rotate_type);
	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
	ChangeYaw();
};

void() turret_still = [0, turret_still]
{
	self.frame = turret_frame(self.rotate_type);
	FindTarget();
};

void() turret_ret1 = [16, turret_ret1]
{
	if (self.frame >= 15)
	{
		turret_ret2();
		return;
	}
	self.frame = self.frame + SERVOBOD_BOTH;
	self.nextthink = time + 0.05;
};

void() turret_ret2 = [16, turret_ret3]
{
	self.nextthink = time + 0.05;
};

void() turret_ret3 = [17, turret_ret4]
{
	self.nextthink = time + 0.05;
};

void() turret_ret4 = [18, turret_ret5]
{
	self.nextthink = time + 0.05;
};

void() turret_ret5 = [19, turret_ret6]
{
	self.solid = SOLID_NOT;
	self.nextthink = time + 0.05;
};

void() turret_ret6 = [20, turret_ret7]
{
	self.nextthink = time + 0.05;
};

void() turret_ret7 = [21, turret_ret8]
{
	self.nextthink = time + 0.05;
};

void() turret_ret8 = [22, turret_retracted]
{
	if (!(self.currentammo))
	{
		self.think = SUB_Null;
	}
	self.nextthink = time + 0.05;
};

void() turret_unret1 = [21, turret_unret2]
{
	self.nextthink = time + 0.05;
};

void() turret_unret2 = [20, turret_unret3]
{
	self.nextthink = time + 0.05;
};

void() turret_unret3 = [19, turret_unret4]
{
	self.nextthink = time + 0.05;
};

void() turret_unret4 = [18, turret_unret5]
{
	self.solid = SOLID_SLIDEBOX;
	setmodel(self, "progs/turret.mdl");
	self.nextthink = time + 0.05;
};

void() turret_unret5 = [17, turret_unret6]
{
	self.nextthink = time + 0.05;
};

void() turret_unret6 = [16, turret_unret7]
{
	self.nextthink = time + 0.05;
};

void() turret_unret7 = [0, turret_unret7]
{
	if (self.frame > turret_frame(self.rotate_type) + SERVOBOD_BOTH)
	{
		self.frame = self.frame - SERVOBOD_RIGHT;
	}
	else
	{
		self.frame = turret_frame(self.rotate_type);
		turret_active();
	}
};

void() turret_retracted = [22, turret_retracted]
{
	if (FindTarget())
	{
		turret_unret1();
	}
};

void() turret_active = [0, turret_active]
{
	local vector delta;
	local float axis;
	local float direct;
	local float ang_rint;
	local float ang_floor;
	local float ang_ceil;
	enemy_infront = infront(self.enemy);
	enemy_range = range(self.enemy);
	enemy_yaw = vectoyaw(self.enemy.origin - self.origin);
	self.frame = turret_frame(self.rotate_type);
	if (self.enemy.health <= SERVOBOD_NONE || self.enemy.deadflag != SERVOBOD_NONE)
	{
		self.enemy = world;
		if (self.oldenemy.health > SERVOBOD_NONE)
		{
			self.enemy = self.oldenemy;
			HuntTarget();
		}
		else
		{
			self.th_stand();
			return;
		}
	}
	self.show_hostile = time + SERVOBOD_BOTH;
	enemy_vis = visible(self.enemy);
	if (enemy_vis)
	{
		self.search_time = time + SVC_SETVIEWPORT;
	}
	if (coop && self.search_time < time)
	{
		if (FindTarget())
		{
			return;
		}
	}
	if (self.attack_state == AS_MISSILE || self.attack_state == AS_MELEE)
	{
		ai_run_missile();
		return;
	}
	CheckTurretAttack();
};

void() turret_bullet1 = [0, turret_bullet2]
{
	local vector dir;
	turret_face();
	self.frame = turret_fireframe(self.rotate_type);
	sound(self, CHAN_WEAPON, "turret/plasbult.wav", SERVOBOD_BOTH, ATTN_NORM);
	self.effects = self.effects | EF_MUZZLEFLASH;
	dir = self.enemy.origin - self.enemy.velocity * 0.3 * random();
	dir = normalize(dir - self.origin);
	FireBullets(SERVOBOD_RIGHT, dir, VEC_ORIGIN);
};

void() turret_bullet2 = [0, turret_bullet3]
{
	turret_face();
	self.nextthink = time + 0.05;
};

void() turret_bullet3 = [0, turret_bullet4]
{
	local vector dir;
	turret_face();
	self.frame = turret_fireframe(self.rotate_type);
	sound(self, CHAN_WEAPON, "turret/plasbult.wav", SERVOBOD_BOTH, ATTN_NORM);
	self.effects = self.effects | EF_MUZZLEFLASH;
	dir = self.enemy.origin - self.enemy.velocity * 0.3 * random();
	dir = normalize(dir - self.origin);
	FireBullets(SERVOBOD_RIGHT, dir, VEC_ORIGIN);
};

void() turret_bullet4 = [0, turret_bullet5]
{
	turret_face();
	self.nextthink = time + 0.05;
};

void() turret_bullet5 = [0, turret_active]
{
	local vector dir;
	turret_face();
	self.frame = turret_fireframe(self.rotate_type);
	sound(self, CHAN_WEAPON, "turret/plasbult.wav", SERVOBOD_BOTH, ATTN_NORM);
	self.effects = self.effects | EF_MUZZLEFLASH;
	dir = self.enemy.origin - self.enemy.velocity * 0.3 * random();
	dir = normalize(dir - self.origin);
	FireBullets(SERVOBOD_RIGHT, dir, VEC_ORIGIN);
};

void() turret_laser1 = [0, turret_laser2]
{
	turret_face();
	self.frame = turret_fireframe(self.rotate_type);
	sound(self, CHAN_WEAPON, "enforcer/enfire.wav", SERVOBOD_BOTH, ATTN_NORM);
	self.effects = self.effects | EF_MUZZLEFLASH;
	newmis = launch_missile("progs/laser.mdl", self.origin, '600 0 0');
	target_missile(newmis, self.enemy.origin, SERVOBOD_BOTH);
};

void() turret_laser2 = [0, turret_laser3]
{
	turret_face();
};

void() turret_laser3 = [0, turret_laser4]
{
	turret_face();
};

void() turret_laser4 = [0, turret_laser5]
{
	turret_face();
};

void() turret_laser5 = [0, turret_active]
{
	turret_face();
	self.frame = turret_fireframe(self.rotate_type);
	sound(self, CHAN_WEAPON, "enforcer/enfire.wav", SERVOBOD_BOTH, ATTN_NORM);
	self.effects = self.effects | EF_MUZZLEFLASH;
	newmis = launch_missile("progs/laser.mdl", self.origin, '600 0 0');
	target_missile(newmis, self.enemy.origin, SERVOBOD_BOTH);
};

void() turret_rocket1 = [0, turret_active]
{
	turret_face();
	self.frame = turret_fireframe(self.rotate_type);
	sound(self, CHAN_WEAPON, "weapons/sgun1.wav", SERVOBOD_BOTH, ATTN_NORM);
	self.effects = self.effects | EF_MUZZLEFLASH;
	newmis = launch_missile("progs/missile.mdl", self.origin, '1000 0 0');
	target_missile(newmis, self.enemy.origin, SERVOBOD_BOTH);
	setdmg_missile(newmis, 15, 15);
};

void() turret_beam1 = [0, turret_beam2]
{
	turret_face();
	sound(self, CHAN_WEAPON, "turret/beamchrg.wav", SERVOBOD_BOTH, ATTN_NORM);
	self.nextthink = time + 0.2;
};

void() turret_beam2 = [0, turret_beam3]
{
	sound(self, CHAN_WEAPON, "turret/beamchrg.wav", SERVOBOD_BOTH, ATTN_NORM);
	turret_face();
	self.nextthink = time + 0.2;
};

void() turret_beam3 = [0, turret_beam4]
{
	sound(self, CHAN_WEAPON, "turret/beamchrg.wav", SERVOBOD_BOTH, ATTN_NORM);
	turret_face();
	self.nextthink = time + 0.2;
};

void() turret_beam4 = [0, turret_beam5]
{
	turret_face();
	self.frame = turret_fireframe(self.rotate_type);
	if (self.waterlevel > SERVOBOD_BOTH)
	{
		beam_water_burst(20);
		return;
	}
	newmis = spawn();
	newmis.solid = SOLID_NOT;
	newmis.movetype = MOVETYPE_FLY;
	newmis.currentammo = SVC_SETVIEWANGLES;
	setorigin(newmis, self.origin);
	newmis.owner = self;
	newmis.think = beam_generate;
	newmis.nextthink = time + 0.05;
};

void() turret_beam5 = [0, turret_beam6]
{
	turret_face();
};

void() turret_beam6 = [0, turret_beam7]
{
	turret_face();
};

void() turret_beam7 = [0, turret_active]
{
	turret_face();
};

void() turret_fire1 = [0, turret_fire2]
{
	turret_face();
	if (infront(self.enemy))
	{
		self.think = turret_fire2;
	}
	self.nextthink = time + 0.05;
};

void() turret_fire2 = [0, turret_fire3]
{
	turret_face();
	self.nextthink = time + 0.05;
};

void() turret_fire3 = [0, turret_fire4]
{
	turret_face();
	self.nextthink = time + 0.05;
};

void() turret_fire4 = [0, turret_fire4]
{
	turret_face();
	if (self.spawnflags & TUR_LASERS)
	{
		turret_laser1();
	}
	else
	{
		if (self.spawnflags & TUR_ROCKETS)
		{
			turret_rocket1();
		}
		else
		{
			if (self.spawnflags & TUR_PPC)
			{
				turret_beam1();
			}
			else
			{
				turret_bullet1();
			}
		}
	}
};

void(entity attacker, float damage) turret_pain = 
{
	if (self.pain_finished > time)
	{
		return;
	}
	self.pain_finished = time + SERVOBOD_BOTH;
	sound(self, CHAN_VOICE, "turret/beamchrg.wav", SERVOBOD_BOTH, ATTN_NORM);
	ThrowGib("progs/turetgib.mdl", SERVOBOD_NONE - damage);
};

void() turret_die = 
{
	local entity dedtur;
	self.use = SUB_Null;
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord(MSG_BROADCAST, self.origin_x);
	WriteCoord(MSG_BROADCAST, self.origin_y);
	WriteCoord(MSG_BROADCAST, self.origin_z);
	dedtur = spawn();
	dedtur.solid = SOLID_NOT;
	dedtur.movetype = MOVETYPE_NONE;
	dedtur.angles = self.angles;
	setorigin(dedtur, self.origin);
	setmodel(dedtur, "progs/dedturet.mdl");
	setsize(self, '-10 -10 -3', '10 10 12');
	dedtur.skin = self.skin;
	ThrowHead("progs/h_turret.mdl", self.health);
	ThrowGib("progs/turetgib.mdl", self.health);
	ThrowGib("progs/turetgib.mdl", self.health);
	ThrowGib("progs/turetgib.mdl", self.health);
	ThrowGib("progs/turetgib.mdl", self.health);
};

void() turret_use = 
{
	if (self.currentammo)
	{
		self.currentammo = 0;
		if (self.spawnflags & TUR_RETRACT || (self.spawnflags & TUR_OFFRET))
		{
			turret_ret1();
		}
		else
		{
			self.think = SUB_Null;
		}
	}
	else
	{
		self.currentammo = 1;
		if (self.spawnflags & TUR_RETRACT || (self.spawnflags & TUR_OFFRET))
		{
			turret_unret1();
		}
		else
		{
			turret_still();
		}
	}
};

void() turret_setup = 
{
	local vector endorg;
	traceline(self.origin, self.origin + '0 0 2000', 1, self);
	endorg = trace_endpos;
	endorg_z = endorg_z - STAT_TOTALMONSTERS;
	setorigin(self, endorg);
	if (self.spawnflags & TUR_STARTOFF)
	{
		if (self.spawnflags & TUR_RETRACT || (self.spawnflags & TUR_OFFRET))
		{
			self.frame = 22;
			self.solid = SOLID_NOT;
		}
		else
		{
			self.frame = turret_frame(self.rotate_type);
		}
		self.currentammo = 0;
		self.think = SUB_Null;
	}
	else
	{
		if (self.spawnflags & TUR_RETRACT)
		{
			self.solid = SOLID_NOT;
			turret_retracted();
		}
		else
		{
			turret_still();
		}
		self.nextthink = self.nextthink + random() * 0.5;
	}
};

void() monster_turret = 
{
	precache_model("progs/turret.mdl");
	precache_model("progs/h_turret.mdl");
	precache_model("progs/dedturet.mdl");
	precache_model("progs/turetgib.mdl");
	precache_sound("turret/beamchrg.wav");
	precache_sound("turret/beammode.wav");
	if (self.spawnflags & TUR_LASERS)
	{
		precache_model("progs/laser.mdl");
		precache_sound("enforcer/enfire.wav");
		precache_sound("enforcer/enfstop.wav");
	}
	else
	{
		if (self.spawnflags & TUR_LASERS)
		{
			precache_model("progs/missile.mdl");
			precache_sound("weapons/sgun1.wav");
		}
		else
		{
			if (self.spawnflags & TUR_PPC)
			{
				precache_model("progs/beam.mdl");
				precache_sound("turret/beamhit.wav");
				precache_sound("hipweap/mjolhit.wav");
			}
			else
			{
				precache_sound("turret/plasbult.wav");
			}
		}
	}
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/turret.mdl");
	setsize(self, '-12 -12 -6', '12 12 12');
	if (self.health < SERVOBOD_BOTH)
	{
		self.health = 100;
	}
	self.max_health = self.health;
	if (self.rotate_type < SERVOBOD_NONE || self.rotate_type > 90)
	{
		self.rotate_type = SERVOBOD_NONE;
	}
	self.currentammo = 1;
	if (self.spawnflags & TUR_RETRACT)
	{
		self.th_stand = turret_ret1;
		self.th_walk = turret_ret1;
	}
	else
	{
		self.th_stand = turret_still;
		self.th_walk = turret_still;
	}
	self.th_run = turret_active;
	self.th_pain = turret_pain;
	self.th_die = turret_die;
	self.th_missile = turret_fire1;
	total_monsters = total_monsters + SERVOBOD_BOTH;
	self.takedamage = DAMAGE_AIM;
	self.ideal_yaw = self.angles * '0 1 0';
	self.yaw_speed = SVC_INTERMISSION;
	self.view_ofs = '0 0 -0.1';
	self.use = turret_use;
	self.flags = self.flags | FL_FLY;
	self.flags = self.flags | FL_MONSTER;
	self.pausetime = 100000000;
	self.nextthink = self.nextthink + random() * 0.5;
	self.think = turret_setup;
};


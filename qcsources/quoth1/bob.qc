void() bob_rotor = 
{
	self.frame = self.count;
	self.count = self.count + LIGHTNING_RANDOM;
	if (self.count > AS_BLINDFIRE)
	{
		self.count = MSG_BROADCAST;
	}
};

void() bob_supplementary = 
{
	local float zspd;
	local float d;
	local float dist;
	local vector vec;
	if (self.flags & FL_ONGROUND)
	{
		self.flags = self.flags - (self.flags & FL_ONGROUND);
	}
	self.dangle = self.dangle + LIGHTNING_RANDOM;
	if (self.dangle > TE_TELEPORT)
	{
		self.dangle = MSG_BROADCAST;
	}
	if (self.dangle <= LIGHTNING_RANDOM)
	{
		zspd = AS_BLINDFIRE;
	}
	else
	{
		if (self.dangle <= AS_MELEE)
		{
			zspd = TE_LAVASPLASH;
		}
		else
		{
			if (self.dangle <= AS_BLINDFIRE)
			{
				zspd = AS_BLINDFIRE;
			}
			else
			{
				if (self.dangle <= TE_WIZSPIKE)
				{
					zspd = CONTENT_LAVA;
				}
				else
				{
					if (self.dangle <= TE_LIGHTNING3)
					{
						zspd = -10;
					}
					else
					{
						if (self.dangle <= TE_TELEPORT)
						{
							zspd = CONTENT_LAVA;
						}
					}
				}
			}
		}
	}
	d = vlen(self.origin - self.enemy.origin);
	if (self.attack_state != AS_SLIDING && d < 400)
	{
		self.attack_state = AS_SLIDING;
	}
	if (self.attack_state != AS_STRAIGHT && d >= 400 || self.style > time)
	{
		self.attack_state = AS_STRAIGHT;
	}
	self.velocity_z = self.velocity_z + zspd;
	if (self.enemy)
	{
		dist = vlen(self.origin - self.oldorigin);
		if (dist < TE_LAVASPLASH)
		{
			self.drop = self.drop + LIGHTNING_RANDOM;
		}
		if (!visible(self.enemy))
		{
			self.drop = self.drop + LIGHTNING_RANDOM;
		}
		if (self.drop >= TE_LAVASPLASH)
		{
			self.style = time + AS_BLINDFIRE;
			self.drop = MSG_BROADCAST;
		}
	}
	self.oldorigin = self.origin;
};

void() bob_idlesound = 
{
	local float wr;
	wr = random() * AS_BLINDFIRE;
	if (self.waitmin < time)
	{
		self.waitmin = time + AS_LOITER;
		if (random() > 0.5)
		{
			sound(self, CHAN_VOICE, "bob/idle1.wav", LIGHTNING_RANDOM, ATTN_NORM);
		}
	}
	return;
};

void() bob_stand1 = [24, bob_stand1]
{
	ai_stand();
	self.velocity_z = MSG_BROADCAST;
	bob_supplementary();
	self.waitmin = time + AS_LOITER;
	bob_rotor();
};

void() bob_walk1 = [24, bob_walk1]
{
	ai_walkfly(SECRET_NO_SHOOT);
	bob_idlesound();
	self.velocity_z = MSG_BROADCAST;
	bob_supplementary();
	bob_rotor();
};

void() bob_run1 = [24, bob_run1]
{
	ai_runfly(26);
	bob_idlesound();
	bob_supplementary();
	bob_rotor();
	if (self.angles_x != MSG_BROADCAST)
	{
		self.angles_x = MSG_BROADCAST;
	}
	if (self.angles_z != MSG_BROADCAST)
	{
		self.angles_z = MSG_BROADCAST;
	}
};

void() bob_laser_touch = 
{
	local vector org;
	if (other == self.owner)
	{
		return;
	}
	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	org = self.origin - SECRET_NO_SHOOT * normalize(self.velocity);
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_KNIGHTSPIKE);
	WriteCoord(MSG_BROADCAST, self.origin_x);
	WriteCoord(MSG_BROADCAST, self.origin_y);
	WriteCoord(MSG_BROADCAST, self.origin_z);
	T_Damage(other, self, self.owner, AS_BLINDFIRE + AS_BLINDFIRE * random());
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_NONE;
	self.velocity = VEC_ORIGIN;
	sound(self, CHAN_VOICE, "enforcer/enfstop.wav", LIGHTNING_RANDOM, LIGHTNING_RANDOM);
	SUB_Remove();
};

void() bob_fire = 
{
	local entity newlaser;
	local float vcomp;
	local vector org;
	local vector vec;
	sound(self, CHAN_WEAPON, "enforcer/enfire.wav", LIGHTNING_RANDOM, 0.8);
	self.effects = EF_MUZZLEFLASH;
	newlaser = spawn();
	newlaser.owner = self;
	newlaser.movetype = MOVETYPE_FLYMISSILE;
	newlaser.solid = SOLID_BBOX;
	org = self.origin - '0 0 6';
	setmodel(newlaser, "progs/laser.mdl");
	setsize(newlaser, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(newlaser, org);
	vec = self.enemy.origin + '0 0 12';
	vec = normalize(vec - org);
	newlaser.velocity = vec * 800;
	newlaser.angles = vectoangles(newlaser.velocity);
	newlaser.nextthink = time + AS_BLINDFIRE;
	newlaser.think = SUB_Remove;
	newlaser.touch = bob_laser_touch;
	newlaser.classname = "enforcershot";
};

void() bob_slow0 = [24, bob_slow1]
{
	ai_face();
	sound(self, CHAN_VOICE, "bob/fire.wav", LIGHTNING_RANDOM, 0.8);
	bob_rotor();
};

void() bob_slow1 = [24, bob_slow2]
{
	local float d;
	local float checkloop;
	local float tloop;
	local float dist;
	local vector porg;
	local vector vec;
	local vector norg;
	ai_face();
	self.movetype = MOVETYPE_FLY;
	makevectors(self.angles);
	while (checkloop != LIGHTNING_RANDOM && tloop < TE_EXPLOSION2)
	{
		self.rotate = v_right * (random() * 100 - 50) * 3.2;
		self.rotate = self.rotate + v_forward * -100;
		d = self.enemy.origin_z - self.origin_z;
		if (d > -128 && tloop < AS_LOITER)
		{
			self.rotate_z = 150;
		}
		dist = vlen(self.origin - (self.origin + self.rotate * 1.5 * 0.5));
		vec = normalize(self.rotate);
		porg = self.origin + vec * dist;
		traceline(self.origin, porg, 0, self);
		norg = trace_endpos;
		vec = self.enemy.origin - norg;
		traceline(norg, norg + vec, 0, self);
		if (trace_ent == self.enemy)
		{
			checkloop = LIGHTNING_RANDOM;
		}
		if (checkloop != LIGHTNING_RANDOM)
		{
			self.rotate = v_forward * -40;
		}
		tloop = tloop + LIGHTNING_RANDOM;
	}
	self.velocity = self.rotate * 0.4;
	bob_rotor();
};

void() bob_slow2 = [24, bob_slow3]
{
	ai_face();
	self.velocity = self.rotate * 0.6;
	bob_rotor();
};

void() bob_slow3 = [24, bob_slow4]
{
	ai_face();
	self.velocity = self.rotate * 0.8;
	bob_rotor();
};

void() bob_slow4 = [24, bob_slow5]
{
	ai_face();
	self.velocity = self.rotate * LIGHTNING_RANDOM;
	bob_rotor();
};

void() bob_slow5 = [24, bob_slow6]
{
	ai_face();
	self.velocity = self.rotate * 1.2;
	bob_fire();
	bob_rotor();
};

void() bob_slow6 = [24, bob_slow7]
{
	ai_face();
	self.velocity = self.rotate * 1.4;
	bob_fire();
	bob_rotor();
};

void() bob_slow7 = [24, bob_slow8]
{
	ai_face();
	self.velocity = self.rotate * 1.3;
	bob_fire();
	bob_rotor();
};

void() bob_slow8 = [24, bob_slow9]
{
	ai_face();
	self.velocity = self.rotate * 1.1;
	bob_fire();
	bob_rotor();
};

void() bob_slow9 = [24, bob_slow10]
{
	ai_face();
	self.velocity = self.rotate * 0.5;
	bob_rotor();
};

void() bob_slow10 = [24, bob_run1]
{
	ai_face();
	if (random() < 0.8)
	{
		SUB_AttackFinished(1.8 * random());
	}
	else
	{
		SUB_AttackFinished(0.3 * random());
	}
	bob_rotor();
};

void() bob_fast0 = [24, bob_fast1]
{
	ai_face();
	sound(self, CHAN_VOICE, "bob/fire.wav", LIGHTNING_RANDOM, 0.8);
	bob_rotor();
};

void() bob_fast1 = [24, bob_fast2]
{
	local float d;
	local float checkloop;
	local float tloop;
	local float dist;
	local vector porg;
	local vector vec;
	local vector norg;
	ai_face();
	self.movetype = MOVETYPE_FLY;
	makevectors(self.angles);
	while (checkloop != LIGHTNING_RANDOM && tloop < TE_EXPLOSION2)
	{
		self.rotate = v_right * (random() * 100 - 50) * 3.2;
		self.rotate = self.rotate + v_forward * -100;
		d = self.enemy.origin_z - self.origin_z;
		if (d > -128 && tloop < AS_LOITER)
		{
			self.rotate_z = 150;
		}
		dist = vlen(self.origin - (self.origin + self.rotate * 1.5 * 0.5));
		vec = normalize(self.rotate);
		porg = self.origin + vec * dist;
		traceline(self.origin, porg, 0, self);
		norg = trace_endpos;
		vec = self.enemy.origin - norg;
		traceline(norg, norg + vec, 0, self);
		if (trace_ent == self.enemy)
		{
			checkloop = LIGHTNING_RANDOM;
		}
		if (checkloop != LIGHTNING_RANDOM)
		{
			self.rotate = v_forward * -40;
		}
		tloop = tloop + LIGHTNING_RANDOM;
	}
	self.velocity = self.rotate * 1.5;
	bob_rotor();
};

void() bob_fast2 = [24, bob_fast3]
{
	ai_face();
	bob_rotor();
};

void() bob_fast3 = [24, bob_fast4]
{
	ai_face();
	bob_rotor();
};

void() bob_fast4 = [24, bob_fast5]
{
	ai_face();
	self.velocity = self.rotate * LIGHTNING_RANDOM;
	bob_rotor();
};

void() bob_fast5 = [24, bob_fast6]
{
	ai_face();
	bob_fire();
	bob_rotor();
};

void() bob_fast6 = [24, bob_fast7]
{
	ai_face();
	bob_fire();
	bob_rotor();
};

void() bob_fast7 = [24, bob_fast8]
{
	ai_face();
	bob_fire();
	bob_rotor();
};

void() bob_fast8 = [24, bob_fast9]
{
	ai_face();
	bob_fire();
	bob_rotor();
};

void() bob_fast9 = [24, bob_fast10]
{
	ai_face();
	self.velocity = self.rotate * 0.5;
	bob_rotor();
};

void() bob_fast10 = [24, bob_run1]
{
	ai_face();
	if (random() < 0.8)
	{
		SUB_AttackFinished(1.8 * random());
	}
	else
	{
		SUB_AttackFinished(0.3 * random());
	}
	bob_rotor();
};

void() bob_Missile = 
{
	if (skill >= LIGHTNING_BOOM)
	{
		bob_fast0();
	}
	else
	{
		bob_slow0();
	}
};

void(vector org) spawn_smoke = 
{
	local entity e;
	e = spawn();
	e.movetype = MOVETYPE_TOSS;
	e.solid = SOLID_NOT;
	setmodel(e, "progs/air.mdl");
	setorigin(e, org);
	e.velocity_x = 300 * random() - 150;
	e.velocity_y = 300 * random() - 150;
	e.velocity_z = 200 * random();
	e.nextthink = time + LIGHTNING_RANDOM;
	e.think = SUB_Remove;
};

void() bob_die1 = [24, bob_die2]
{
	self.frame = self.frame + LIGHTNING_RANDOM;
	if (self.frame > 15)
	{
		self.frame = TE_LAVASPLASH;
	}
	self.touch = bob_die4;
	self.duration = time + 1.5;
	if (self.cnt == MSG_BROADCAST)
	{
		if (random() > 0.5)
		{
			self.lefty = LIGHTNING_RANDOM;
		}
		spawn_big_explosion(self.origin, MSG_BROADCAST);
		spawn_smoke(self.origin);
		sound(self, CHAN_WEAPON, "bob/s_explode.wav", LIGHTNING_RANDOM, ATTN_NORM);
		WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte(MSG_BROADCAST, TE_EXPLOSION);
		WriteCoord(MSG_BROADCAST, self.origin_x);
		WriteCoord(MSG_BROADCAST, self.origin_y);
		WriteCoord(MSG_BROADCAST, self.origin_z);
		self.avelocity_x = 50 * random() - 100;
		self.avelocity_z = 50 * random() - 100;
	}
	makevectors(self.angles);
	self.velocity = v_forward * 300;
	self.velocity = self.velocity + v_up * -30;
	if (self.lefty == LIGHTNING_RANDOM)
	{
		self.angles_y = self.angles_y + TE_LAVASPLASH;
	}
	else
	{
		self.angles_y = self.angles_y - TE_LAVASPLASH;
	}
	self.nextthink = time + 0.1;
	self.cnt = self.cnt + LIGHTNING_RANDOM;
	if (self.cnt < SECRET_1ST_DOWN)
	{
		self.think = bob_die1;
	}
};

void() bob_die2 = [24, bob_die3]
{
	self.frame = self.frame + LIGHTNING_RANDOM;
	if (self.frame > 15)
	{
		self.frame = TE_LAVASPLASH;
	}
	if (random() > 0.7)
	{
		spawn_small_explosion(self.origin, MSG_BROADCAST);
		sound(self, CHAN_BODY, "bob/s_explode.wav", 0.8, ATTN_NORM);
	}
	if (random() > 0.4)
	{
		spawn_smoke(self.origin);
	}
	self.solid = SOLID_BBOX;
	makevectors(self.angles);
	self.velocity = self.velocity * 0.2 + v_forward * 100 * 0.8;
	self.velocity = normalize(self.velocity);
	self.velocity = self.velocity * 300;
	self.velocity = self.velocity - '0 0 200';
	if (self.lefty == LIGHTNING_RANDOM)
	{
		self.angles_y = self.angles_y + TE_LAVASPLASH;
	}
	else
	{
		self.angles_y = self.angles_y - TE_LAVASPLASH;
	}
	self.nextthink = time + 0.1;
	if (time < self.duration)
	{
		self.think = bob_die2;
	}
};

void() bob_die3 = [24, bob_die4]
{
	self.frame = self.frame + LIGHTNING_RANDOM;
	if (self.frame > 15)
	{
		self.frame = TE_LAVASPLASH;
	}
	sound(self, CHAN_WEAPON, "bob/s_explode.wav", LIGHTNING_RANDOM, ATTN_NORM);
	spawn_smoke(self.origin);
	spawn_smoke(self.origin);
	spawn_small_explosion(self.origin, MSG_BROADCAST);
	self.movetype = MOVETYPE_TOSS;
	self.nextthink = time + 0.2;
};

void() bob_die4 = [24, bob_die4]
{
	sound(self, CHAN_WEAPON, "bob/explode.wav", LIGHTNING_RANDOM, ATTN_NORM);
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord(MSG_BROADCAST, self.origin_x);
	WriteCoord(MSG_BROADCAST, self.origin_y);
	WriteCoord(MSG_BROADCAST, self.origin_z);
	spawn_big_explosion(self.origin, MSG_BROADCAST);
	SUB_Remove();
};

void() bob_die = 
{
	self.movetype = MOVETYPE_FLY;
	self.solid = SOLID_NOT;
	self.frame = TE_LAVASPLASH;
	sound(self, CHAN_VOICE, "bob/death.wav", LIGHTNING_RANDOM, ATTN_NORM);
	bob_die1();
};

void() bob_pain1 = [24, bob_pain1]
{
	self.frame = self.count;
	if (self.count > AS_BLINDFIRE && self.count < TE_LIGHTNING3)
	{
		self.count = self.count + LIGHTNING_RANDOM;
	}
	else
	{
		if (self.count >= TE_LIGHTNING3)
		{
			self.count = MSG_BROADCAST;
		}
	}
	self.frame = self.count;
	if (self.inv == MSG_BROADCAST)
	{
		self.angles_x = random() * 50 - 25;
		self.angles_z = random() * 50 - 25;
	}
	else
	{
		if (self.inv > MSG_BROADCAST && self.inv < AS_LOITER)
		{
			self.angles_x = self.angles_x * 0.8;
			self.angles_z = self.angles_z * 0.8;
		}
		else
		{
			if (self.inv >= AS_LOITER)
			{
				self.angles_x = MSG_BROADCAST;
				self.angles_z = MSG_BROADCAST;
				self.think = bob_run1;
			}
		}
	}
	self.inv = self.inv + LIGHTNING_RANDOM;
};

void(entity attacker, float damage) bob_Pain = 
{
	if (random() < 0.85 && time > self.pain_finished)
	{
		self.count = AS_LOITER;
		sound(self, CHAN_VOICE, "bob/pain.wav", LIGHTNING_RANDOM, ATTN_NORM);
		self.inv = MSG_BROADCAST;
		self.pain_finished = time + SECRET_1ST_DOWN + LIGHTNING_BOOM * random();
		bob_pain1();
	}
};

void() guntouch = 
{
	local vector vec;
	if (other != self.spawnmaster)
	{
		return;
	}
	self.velocity = self.spawnmaster.velocity;
	if (self.spawnmaster.enemy)
	{
		vec = self.spawnmaster.enemy.origin - self.origin;
		vec = vectoangles(vec);
		self.angles = vec;
	}
	else
	{
		self.angles = self.spawnmaster.angles;
	}
};

void() gunthink = 
{
	local vector vec;
	makevectors(self.spawnmaster.angles);
	if (self.origin != self.spawnmaster.origin)
	{
		setorigin(self, self.spawnmaster.origin - v_up * TE_TELEPORT);
	}
	self.velocity = self.spawnmaster.velocity;
	if (self.spawnmaster.enemy)
	{
		vec = self.spawnmaster.enemy.origin - self.origin;
		vec = vectoangles(vec);
		self.angles = vec;
	}
	else
	{
		self.angles = self.spawnmaster.angles;
	}
	if (self.aflag <= time)
	{
		if (self.lefty)
		{
			sound(self, CHAN_VOICE, "bob/hover.wav", 0.3, 2.3);
		}
		else
		{
			sound(self, CHAN_BODY, "bob/hover.wav", 0.3, 2.3);
		}
		self.aflag = time + 0.2;
		self.skin = self.skin + LIGHTNING_RANDOM;
		if (self.skin > LIGHTNING_BOOM)
		{
			self.skin = MSG_BROADCAST;
		}
		self.lefty = LIGHTNING_RANDOM - self.lefty;
	}
	if (self.spawnmaster.health <= MSG_BROADCAST)
	{
		SUB_Remove();
	}
	self.nextthink = time + 0.010000;
	self.think = gunthink;
};

void() bob_start = 
{
	local vector org;
	local entity gun;
	if (!(self.spawnflags & TRIGGER_SPAWNSILENT))
	{
		org = self.origin + SECRET_YES_SHOOT * v_forward;
		spawn_tfog(org);
	}
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_FLY;
	setmodel(self, "progs/bob.mdl");
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
	self.health = 200;
	gun = spawn();
	gun.solid = SOLID_TRIGGER;
	gun.movetype = MOVETYPE_FLY;
	setmodel(gun, "progs/bobblaster.mdl");
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
	setorigin(gun, self.origin);
	self.eye = gun;
	gun.spawnmaster = self;
	gun.think = gunthink;
	gun.nextthink = time + 0.1;
	monster_spawn();
	flymonster_start_go();
};

void() bob_begin = 
{
	if (self.spawndelay > MSG_BROADCAST)
	{
		self.nextthink = time + self.spawndelay;
	}
	else
	{
		if (self.spawndelay == CONTENT_EMPTY)
		{
			self.nextthink = time + random() * 0.4;
		}
		else
		{
			self.nextthink = time + 0.1;
		}
	}
	self.think = bob_start;
};

void() monster_bob = 
{
	local entity gun;
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model("progs/bob.mdl");
	precache_model("progs/bobblaster.mdl");
	precache_model("progs/h_wizard.mdl");
	precache_model2("progs/laser.mdl");
	precache_model("progs/air.mdl");
	precache_model("progs/smlexp.spr");
	precache_model("progs/bigexp.spr");
	precache_sound2("enforcer/enfstop.wav");
	precache_sound2("enforcer/enfire.wav");
	precache_sound("bob/idle1.wav");
	precache_sound("bob/explode.wav");
	precache_sound("bob/s_explode.wav");
	precache_sound("bob/fire.wav");
	precache_sound("bob/death.wav");
	precache_sound("bob/sight.wav");
	precache_sound("bob/pain.wav");
	precache_sound("bob/hover.wav");
	self.th_stand = bob_stand1;
	self.th_walk = bob_walk1;
	self.th_run = bob_run1;
	self.th_missile = bob_Missile;
	self.th_pain = bob_Pain;
	self.th_die = bob_die;
	self.oldorigin = self.origin;
	if (self.spawnflags & TRIGGER_SPAWN)
	{
		self.use = bob_begin;
		total_monsters = total_monsters + LIGHTNING_RANDOM;
		return;
	}
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_FLY;
	setmodel(self, "progs/bob.mdl");
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
	self.health = 200;
	gun = spawn();
	gun.solid = SOLID_TRIGGER;
	gun.movetype = MOVETYPE_FLY;
	setmodel(gun, "progs/bobblaster.mdl");
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
	setorigin(gun, self.origin);
	self.eye = gun;
	gun.spawnmaster = self;
	gun.think = gunthink;
	gun.nextthink = time + 0.1;
	flymonster_start();
};


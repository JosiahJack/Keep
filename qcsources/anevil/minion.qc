void() PM_FreeSlaves = 
{
	local entity head;
	self.lip = MSG_BROADCAST;
	head = nextent(world);
	while (head)
	{
		if (head.owner == self)
		{
			head.owner = head;
		}
		head = nextent(head);
	}
};

void(string gibname, float dm) PM_TempHead = 
{
	local entity new;
	new = spawn();
	setmodel(new, gibname);
	setsize(new, '-16 -16 0', '16 16 56');
	setorigin(new, self.origin);
	new.velocity = VelocityForDamage(dm);
	new.movetype = MOVETYPE_BOUNCE;
	new.solid = SOLID_NOT;
	new.avelocity = crandom() * '0 600 0';
	new.think = SUB_Remove;
	new.ltime = time;
	new.nextthink = time + NONBLOCKING + random() * NONBLOCKING;
	new.frame = MSG_BROADCAST;
	new.flags = MSG_BROADCAST;
};

void(string gibname, float dm) PM_TempGib = 
{
	local entity new;
	new = spawn();
	setmodel(new, gibname);
	setsize(new, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(new, self.origin);
	new.velocity = VelocityForDamage(dm);
	new.movetype = MOVETYPE_BOUNCE;
	new.solid = SOLID_NOT;
	new.avelocity_x = random() * 600;
	new.avelocity_y = random() * 600;
	new.avelocity_z = random() * 600;
	new.think = SUB_Remove;
	new.ltime = time;
	new.nextthink = time + LIGHTNING_BOOM + random() * LIGHTNING_BOOM;
	new.frame = MSG_BROADCAST;
	new.flags = MSG_BROADCAST;
};

void() minion_die = 
{
	if (self.owner)
	{
		if (self.owner != self)
		{
			self.owner.lip = self.owner.lip - USE_COUNT;
		}
	}
	sound(self, CHAN_VOICE, "zombie/z_gib.wav", USE_COUNT, ATTN_NORM);
	PM_TempHead("progs/h_zombie.mdl", self.health);
	PM_TempGib("progs/gib1.mdl", self.health);
	PM_TempGib("progs/gib2.mdl", self.health);
	PM_TempGib("progs/gib3.mdl", self.health);
	remove(self);
};

void() PM_MinionGo = 
{
	self.takedamage = DAMAGE_AIM;
	self.ideal_yaw = self.angles * '0 1 0';
	if (!(self.yaw_speed))
	{
		self.yaw_speed = 20;
	}
	self.view_ofs = '0 0 25';
	self.use = monster_use;
	self.flags = self.flags | FL_MONSTER;
	self.pausetime = time + 999999;
	if (self.enemy)
	{
		if (self.enemy.health > MSG_BROADCAST)
		{
			FoundTarget();
			return;
		}
	}
	self.enemy = world;
	self.th_stand();
};

void() PM_CreateMinion = 
{
	if (self.owner.lip >= self.owner.height)
	{
		remove(self);
		return;
	}
	if (self.owner == self)
	{
		remove(self);
		return;
	}
	if (!(self.owner.enemy))
	{
		remove(self);
		return;
	}
	if (random() < 0.5)
	{
		remove(self);
		return;
	}
	self.movetype = MOVETYPE_STEP;
	self.solid = SOLID_NOT;
	setsize(self, VEC_HULL_MIN, '16 16 40');
	setorigin(self, self.origin + '0 0 41');
	droptofloor();
	if (walkmove(MSG_BROADCAST, MSG_BROADCAST))
	{
		if (self.owner.enemy)
		{
			self.enemy = self.owner.enemy;
			self.angles = vectoangles(self.enemy.origin - self.origin);
		}
		self.angles_x = MSG_BROADCAST;
		self.angles_z = MSG_BROADCAST;
		self.fixangle = 1;
		spawn_tfog(self.origin);
		self.movetype = MOVETYPE_STEP;
		self.solid = SOLID_SLIDEBOX;
		setmodel(self, "progs/zombie.mdl");
		setsize(self, VEC_HULL_MIN, '16 16 40');
		self.health = 60;
		self.th_stand = zombie_stand1;
		self.th_walk = zombie_walk1;
		self.th_run = zombie_run1;
		self.th_pain = zombie_pain;
		self.th_die = minion_die;
		self.th_missile = zombie_missile;
		self.classname = "monster_zombie";
		self.nextthink = time;
		self.think = PM_MinionGo;
		self.owner.lip = self.owner.lip + USE_COUNT;
		return;
	}
	remove(self);
};

void() PM_SpawnTouch = 
{
	if (other == self.owner)
	{
		return;
	}
	if (other.solid == SOLID_TRIGGER)
	{
		return;
	}
	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	if (other.takedamage)
	{
		spawn_touchblood(SVC_SETVIEWANGLES);
		T_Damage(other, self, self.owner, SVC_SETVIEWANGLES);
		remove(self);
	}
	else
	{
		sound(self, CHAN_WEAPON, "wizard/hit.wav", USE_COUNT, ATTN_NORM);
		spawn_touchblood(SVC_SETVIEWANGLES);
		self.solid = SOLID_NOT;
		self.touch = SUB_Null;
		self.nextthink = time + LIGHTNING_BOOM;
		self.think = PM_CreateMinion;
	}
};

void(vector offset, float spread) PM_Spawn = 
{
	local vector dir;
	local vector org;
	makevectors(self.angles);
	org = self.origin + v_forward * offset_x + v_right * offset_y + v_up * offset_z;
	dir = normalize(self.enemy.origin - org);
	dir = dir + v_right * spread;
	dir = normalize(dir);
	newmis = spawn();
	setmodel(newmis, "progs/zom_gib.mdl");
	setsize(newmis, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(newmis, org);
	newmis.takedamage = DAMAGE_NO;
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BBOX;
	newmis.owner = self;
	newmis.angles = vectoangles(dir);
	newmis.touch = PM_SpawnTouch;
	newmis.nextthink = time + STATE_OPENING;
	newmis.think = SUB_Remove;
	newmis.velocity = dir * 1000;
};

void() PM_PrecacheMinion = 
{
	precache_model("progs/zombie.mdl");
	precache_model("progs/h_zombie.mdl");
	precache_model("progs/zom_gib.mdl");
	precache_sound("zombie/z_idle.wav");
	precache_sound("zombie/z_idle1.wav");
	precache_sound("zombie/z_shot1.wav");
	precache_sound("zombie/z_gib.wav");
	precache_sound("zombie/z_pain.wav");
	precache_sound("zombie/z_pain1.wav");
	precache_sound("zombie/z_fall.wav");
	precache_sound("zombie/z_miss.wav");
	precache_sound("zombie/z_hit.wav");
	precache_sound("zombie/idle_w2.wav");
};


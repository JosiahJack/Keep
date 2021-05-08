void() buzzsaw_stand1 = [0, buzzsaw_stand1]
{
	if (self.pain_finished < time)
	{
		sound(self, CHAN_VOICE, "buzz/buzz1.wav", 0.2, ATTN_NORM);
		self.pain_finished = time + USE_GOLD_KEY;
	}
	self.angles_x = self.angles_x - 60;
	self.avelocity_x = 60;
};

void() buzzsaw_fly = 
{
	local vector dir;
	if (self.pain_finished < time)
	{
		sound(self, CHAN_VOICE, "buzz/buzz1.wav", 0.2, ATTN_NORM);
		self.pain_finished = time + USE_GOLD_KEY;
	}
	dir = self.goalentity.origin - self.origin;
	dir = normalize(dir);
	dir = dir * self.speed;
	setorigin(self, self.origin + dir);
	self.angles_x = self.angles_x - 60;
	self.avelocity_x = 60;
};

void() buzzsaw_fly1 = [1, buzzsaw_fly1]
{
	buzzsaw_fly();
};

void() buzzsaw_touch = 
{
	local vector sprayDir;
	if (other.classname == "player" || (other.flags & FL_MONSTER))
	{
		if (self.attack_finished < time)
		{
			sound(self, CHAN_WEAPON, "buzz/buzz.wav", USE_GOLD_KEY, ATTN_NORM);
			self.attack_finished = time + TOUCH;
		}
		T_Damage(other, self, self, self.currentammo);
		sprayDir = normalize(self.goalentity.origin - self.origin);
		sprayDir = sprayDir * 200;
		SpawnMeatSpray(self.origin, sprayDir);
		other.velocity = sprayDir;
		other.velocity_z = 200;
	}
};

void() buzzsaw_use = 
{
	self.touch = buzzsaw_touch;
	if (self.target)
	{
		self.movetarget = find(world, targetname, self.target);
		self.goalentity = self.movetarget;
		self.th_stand = buzzsaw_fly1;
		self.th_walk = buzzsaw_fly1;
		self.th_run = buzzsaw_fly1;
		self.think = buzzsaw_fly1;
		self.nextthink = time + 0.1;
	}
	else
	{
		self.nextthink = time + 0.1;
		self.think = buzzsaw_stand1;
	}
	self.use = SUB_Null;
};

void() buzzsaw = 
{
	precache_model("progs/buzzsaw.mdl");
	precache_sound("buzz/buzz.wav");
	precache_sound("buzz/buzz1.wav");
	setmodel(self, "progs/buzzsaw.mdl");
	self.takedamage = DAMAGE_NO;
	self.solid = SOLID_TRIGGER;
	self.movetype = MOVETYPE_FLY;
	if (self.angles_y == OBJECT_ROTATE || self.angles_y == 180)
	{
		setsize(self, '-18 0 -18', '18 0 18');
	}
	else
	{
		if (self.angles_y == 90 || self.angles_y == 270)
		{
			setsize(self, '0 -18 -18', '0 18 18');
		}
		else
		{
			objerror("Buzzsaw: Not at 90 degree angle!");
		}
	}
	setorigin(self, self.origin);
	if (!(self.speed))
	{
		self.speed = SVC_SETVIEWANGLES;
	}
	if (!(self.currentammo))
	{
		self.currentammo = SVC_SETVIEWANGLES;
	}
	self.pain_finished = time + random() * TOUCH;
	if (!(self.targetname))
	{
		self.think = buzzsaw_use;
		self.nextthink = time + 0.2;
	}
	else
	{
		self.use = buzzsaw_use;
	}
};


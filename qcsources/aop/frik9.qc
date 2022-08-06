float() claw_hasowner = 
{
	local entity pinhead;
	pinhead = find(world, classname, "misc_pinhead");
	while (pinhead)
	{
		if (self.owner == pinhead)
		{
			return 1;
		}
		pinhead = find(pinhead, classname, "misc_pinhead");
	}
	return 0;
};

void() killclaw = 
{
	if (claw_hasowner())
	{
		self.owner.flags = MSG_BROADCAST;
	}
	remove(self);
};

void() claw_close = 
{
	if (self.frame < TE_LIGHTNING1)
	{
		self.frame = self.frame + SPAWNFLAG_SUPERSPIKE;
	}
	if (self.count < time)
	{
		killclaw();
	}
	self.nextthink = time + 0.030000;
};

void() claw_retract = 
{
	sound(self, CHAN_BODY, "enviro/pinhead/pinback.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
	self.velocity = normalize(self.owner.origin - self.origin) * 500;
	self.solid = SOLID_NOT;
	self.count = time + (time - self.ltime);
	self.think = claw_close;
	self.nextthink = time;
	self.frame = SPAWNFLAG_SUPERSPIKE;
};

void(entity e) pullorg = 
{
	local entity claw;
	local vector org;
	local float counter2;
	org = e.origin;
	counter2 = SPAWNFLAG_SUPERSPIKE;
	claw = find(world, classname, "claw");
	while (claw)
	{
		if (claw.enemy == e)
		{
			org = org + claw.owner.origin;
			counter2 = counter2 + SPAWNFLAG_SUPERSPIKE;
		}
		claw = find(claw, classname, "claw");
	}
	org = org * (SPAWNFLAG_SUPERSPIKE / counter2);
	org_x = org_x + crandom() * TE_LAVASPLASH;
	org_y = org_y + crandom() * TE_LAVASPLASH;
	org_z = org_z + crandom() * TE_LAVASPLASH;
	return org_x;
};

void() claw_pull = 
{
	local vector org;
	sound(self, CHAN_VOICE, "enviro/pinhead/pinpull.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
	setorigin(self, self.enemy.origin + self.mangle);
	if (self.frame < TE_LIGHTNING1)
	{
		self.frame = self.frame + SPAWNFLAG_SUPERSPIKE;
	}
	self.nextthink = time + random() / SPAWNFLAG_LASER;
	org = pullorg(self.enemy);
	if (self.enemy.flags & FL_ONGROUND)
	{
		self.enemy.flags = self.enemy.flags - FL_ONGROUND;
		self.enemy.origin = self.enemy.origin + '0 0 1';
	}
	self.velocity = normalize(org - self.origin);
	if (vlen(org - self.origin) > 20)
	{
		self.velocity = self.velocity * 500;
	}
	else
	{
		self.velocity = self.velocity * 50;
	}
	self.enemy.velocity = self.velocity;
	if (!claw_hasowner())
	{
		killclaw();
	}
	else
	{
		if (self.enemy.health <= MSG_BROADCAST)
		{
			killclaw();
		}
		else
		{
			if (self.enemy.health < TE_LIGHTNING1)
			{
				sound(self, CHAN_VOICE, "enviro/pinhead/pinsuck.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
				T_Damage(self.enemy, self, self.owner, 10000);
			}
			else
			{
				if (random() < 0.1)
				{
					if (random() < 0.5)
					{
						sound(self, CHAN_WEAPON, "enviro/pinhead/pinrip.wav", 0.5, ATTN_NORM);
					}
					if (self.owner.dmg > MSG_BROADCAST)
					{
						T_Damage(self.enemy, self, self.owner, self.owner.dmg);
					}
				}
			}
		}
	}
};

void() claw_touch = 
{
	if (other.solid == SOLID_TRIGGER)
	{
		return;
	}
	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		claw_retract();
		return;
	}
	if (other.takedamage)
	{
		self.enemy = other;
		self.origin = self.origin + normalize(self.velocity) * SVC_INTERMISSION;
		self.mangle = self.origin - self.enemy.origin;
		self.mangle_x = self.mangle_x * 0.05;
		self.mangle_y = self.mangle_y * 0.05;
		self.mangle_z = self.mangle_z * 0.1 + TE_LAVASPLASH;
		self.think = claw_pull;
		self.nextthink = time;
		sound(self, CHAN_AUTO, "enviro/pinhead/pinhit.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
	}
	else
	{
		WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte(MSG_BROADCAST, TE_GUNSHOT);
		WriteCoord(MSG_BROADCAST, self.origin_x);
		WriteCoord(MSG_BROADCAST, self.origin_y);
		WriteCoord(MSG_BROADCAST, self.origin_z);
		sound(self, CHAN_ITEM, "enviro/pinhead/pindef.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
		claw_retract();
	}
};

void(vector org, vector dir) fire_claw = 
{
	launch_spike(org, dir);
	setmodel(newmis, "progs/claw.mdl");
	setsize(newmis, VEC_ORIGIN, VEC_ORIGIN);
	newmis.touch = claw_touch;
	newmis.classname = "claw";
	newmis.enemy = world;
	newmis.think = claw_retract;
	newmis.nextthink = time + self.ltime / TE_LAVASPLASH;
	newmis.ltime = time;
	self.flags = SPAWNFLAG_SUPERSPIKE;
	self.enemy = newmis;
	sound(self, CHAN_VOICE, "enviro/pinhead/pinfire.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
};

void() pinhead_use = 
{
	local entity head;
	local float dist;
	local vector dir;
	if (self.flags)
	{
		return;
	}
	self.enemy = world;
	dist = self.ltime * 100 + 100;
	if (self.goalentity)
	{
		traceline(self.origin, self.goalentity.origin + '0 0 16', 1, self);
		if (trace_fraction >= SPAWNFLAG_SUPERSPIKE && vlen(self.goalentity.origin + '0 0 16' - self.origin) < dist)
		{
			self.enemy = self.goalentity;
		}
		else
		{
			self.enemy = world;
		}
	}
	else
	{
		head = findradius(self.origin, dist);
		while (head)
		{
			if (head.flags & (FL_CLIENT | FL_MONSTER) && head.takedamage && vlen(head.origin + '0 0 16' - self.origin) < dist)
			{
				traceline(self.origin, head.origin + '0 0 16', 1, self);
				if (trace_fraction >= SPAWNFLAG_SUPERSPIKE)
				{
					self.enemy = head;
					dist = vlen(head.origin + '0 0 16' - self.origin);
					dir = normalize(self.enemy.origin + '0 0 16' - self.origin);
				}
			}
			head = head.chain;
		}
	}
	if (self.enemy != world)
	{
		fire_claw(self.origin, dir);
	}
};

void() pinhead_think = 
{
	self.nextthink = time + SPAWNFLAG_SUPERSPIKE;
	self.use();
};

void() misc_pinhead_triggered = 
{
	self.classname = "misc_pinhead";
	precache_model2("progs/claw.mdl");
	precache_sound2("enviro/pinhead/pinback.wav");
	precache_sound2("enviro/pinhead/pindef.wav");
	precache_sound2("enviro/pinhead/pinfire.wav");
	precache_sound2("enviro/pinhead/pinhit.wav");
	precache_sound2("enviro/pinhead/pinpull.wav");
	precache_sound2("enviro/pinhead/pinrip.wav");
	precache_sound2("enviro/pinhead/pinsuck.wav");
	self.use = pinhead_use;
	if (self.ltime == MSG_BROADCAST)
	{
		self.ltime = SPAWNFLAG_LASER;
	}
	if (self.dmg == MSG_BROADCAST)
	{
		self.dmg = AS_MELEE;
	}
};

void() misc_pinhead = 
{
	misc_pinhead_triggered();
	self.nextthink = random();
	self.think = pinhead_think;
};


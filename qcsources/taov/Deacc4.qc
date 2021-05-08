void() bat_think = 
{
	local entity head;
	local vector source;
	if (!(self.enemy))
	{
		head = findradius(self.origin, self.count);
		while (head)
		{
			if (head.classname == "player" && head.health > STATE_TOP && head.flypain == 0)
			{
				if (head != self)
				{
					self.enemy = head;
					if (self.origin_x < self.enemy.origin_x)
					{
						self.velocity_x = self.speed;
					}
					else
					{
						self.velocity_x = self.speed * CONTENT_EMPTY;
					}
				}
			}
			head = head.chain;
		}
	}
	else
	{
		if (self.origin_z > self.enemy.origin_z)
		{
			self.velocity_z = self.speed * CONTENT_EMPTY;
		}
		else
		{
			self.velocity_z = self.speed;
		}
		if (self.origin_y > self.enemy.origin_y)
		{
			self.velocity_y = self.speed * CONTENT_EMPTY;
		}
		else
		{
			self.velocity_y = self.speed;
		}
		if (self.frame < SVC_SPAWNSTATIC)
		{
			self.frame = self.frame + PLAT_LOW_TRIGGER;
		}
		else
		{
			self.frame = PLAT_LOW_TRIGGER;
		}
	}
	if (self.velocity_x == STATE_TOP && self.enemy != world)
	{
		remove(self);
	}
	frameskip(0.010000);
};

void() bat_die = 
{
	local entity effect;
	GiveExperience(IT_RELIC2);
	effect = spawn();
	setorigin(effect, self.origin + v_up * SVC_UPDATEFRAGS);
	setmodel(effect, "progs/fire.spr");
	effect.movetype = MOVETYPE_NONE;
	effect.think = firesprite_think;
	effect.nextthink = time;
	effect.solid = SOLID_NOT;
	sound(self, CHAN_BODY, "spells/fhit.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	remove(self);
};

void() bat_touch = 
{
	local entity effect;
	if (other.takedamage && other.classname == "player" && other.health > STATE_TOP)
	{
		T_Damage(other, self, self, AS_MELEE);
	}
	effect = spawn();
	setorigin(effect, self.origin + v_up * SVC_UPDATEFRAGS);
	setmodel(effect, "progs/fire.spr");
	effect.movetype = MOVETYPE_NONE;
	effect.think = firesprite_think;
	effect.nextthink = time;
	effect.solid = SOLID_NOT;
	sound(self, CHAN_BODY, "spells/fhit.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	remove(self);
};

void() monster_bat = 
{
	precache_sound("bat/die.wav");
	precache_model("progs/bat.mdl");
	setmodel(self, "progs/bat.mdl");
	self.health = PLAT_LOW_TRIGGER;
	self.movetype = MOVETYPE_FLY;
	self.solid = SOLID_TRIGGER;
	self.takedamage = DAMAGE_AIM;
	self.classname = "bat";
	self.netname = "solid";
	setsize(self, '-1 -1 -1', '1 1 1');
	if (!(self.speed))
	{
		self.speed = 150;
	}
	if (!(self.count))
	{
		self.count = 150;
	}
	self.touch = bat_touch;
	self.think = bat_think;
	self.nextthink = time + 0.1;
	self.th_die = bat_die;
	spawn_shadow();
};


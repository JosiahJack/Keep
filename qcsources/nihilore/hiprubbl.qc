void() hipRubbleTouch = 
{
	if (self.ltime < self.pausetime)
	{
		return;
	}
	if (other.takedamage)
	{
		T_Damage(other, self, self.owner, SVC_SETVIEWANGLES);
		sound(self, CHAN_WEAPON, "zombie/z_hit.wav", LIGHTNING_RANDOM, ATTN_NORM);
		self.pausetime = self.ltime + 0.1;
	}
};

void(string rubblename) hipThrowRubble = 
{
	local entity new;
	new = spawn();
	new.origin = self.origin;
	setmodel(new, rubblename);
	setsize(new, VEC_ORIGIN, VEC_ORIGIN);
	new.velocity_x = 70 * crandom();
	new.velocity_y = 70 * crandom();
	new.velocity_z = 140 + 70 * random();
	new.movetype = MOVETYPE_BOUNCE;
	new.solid = SOLID_BBOX;
	new.avelocity_x = random() * 600;
	new.avelocity_y = random() * 600;
	new.avelocity_z = random() * 600;
	new.think = SUB_Remove;
	new.touch = hipRubbleTouch;
	new.ltime = time;
	new.nextthink = time + 13 + random() * SVC_SETVIEWANGLES;
	self.pausetime = time;
	new.frame = SERVOBOD_NONE;
	new.flags = SERVOBOD_NONE;
	if (self.skin < SERVOBOD_NONE)
	{
		new.skin = floor(random() * 14);
	}
	else
	{
		new.skin = self.skin;
	}
};

void() rubble_use = 
{
	local float which;
	local float index;
	index = SERVOBOD_NONE;
	do
	{
		which = self.cnt;
		if (self.cnt == SERVOBOD_NONE)
		{
			which = LIGHTNING_RANDOM + SERVOBOD_LEFT * random();
			which = floor(which);
		}
		if (which == LIGHTNING_RANDOM)
		{
			hipThrowRubble("progs/rubble1.mdl");
		}
		else
		{
			if (which == LIGHTNING_BOOM)
			{
				hipThrowRubble("progs/rubble3.mdl");
			}
			else
			{
				hipThrowRubble("progs/rubble2.mdl");
			}
		}
		index = index + LIGHTNING_RANDOM;
	} while (index < self.count);
};

void() func_rubble = 
{
	precache_model("progs/rubble1.mdl");
	precache_model("progs/rubble2.mdl");
	precache_model("progs/rubble3.mdl");
	precache_sound("zombie/z_hit.wav");
	self.classname = "rubble";
	self.cnt = SERVOBOD_NONE;
	self.use = rubble_use;
};

void() func_rubble1 = 
{
	precache_model("progs/rubble1.mdl");
	precache_sound("zombie/z_hit.wav");
	self.classname = "rubble1";
	self.cnt = LIGHTNING_RANDOM;
	self.use = rubble_use;
};

void() func_rubble2 = 
{
	precache_model("progs/rubble3.mdl");
	precache_sound("zombie/z_hit.wav");
	self.classname = "rubble2";
	self.cnt = LIGHTNING_BOOM;
	self.use = rubble_use;
};

void() func_rubble3 = 
{
	precache_model("progs/rubble2.mdl");
	precache_sound("zombie/z_hit.wav");
	self.classname = "rubble3";
	self.cnt = SERVOBOD_LEFT;
	self.use = rubble_use;
};


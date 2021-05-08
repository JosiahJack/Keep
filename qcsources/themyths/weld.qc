void(vector org, vector dir) WeldFire = 
{
	local entity weld;
	weld = spawn();
	weld.owner = self;
	weld.movetype = MOVETYPE_FLYMISSILE;
	weld.solid = SOLID_BBOX;
	weld.touch = WeldTouch;
	weld.classname = "weld_blob";
	weld.think = SUB_Remove;
	weld.nextthink = time + MOVETYPE_TOSS;
	weld.velocity = dir * 1000;
	weld.angles = vectoangles(weld.velocity);
	weld.angles_x = weld.angles_x + 90;
	burn_pain_sound_1 = "player/lburn1.wav";
	burn_pain_sound_2 = "player/lburn2.wav";
	burn_extinguish_sound = "player/slimbrn2.wav";
	burn_light_sound = "ambience/fire1.wav";
	weld_explode_sound = "dragon/hit.wav";
	weld_fire_sound_1 = "weapons/spike2.wav";
	weld_fire_sound_2 = "hknight/idle.wav";
	if (time >= weld.owner.weld_light_time)
	{
		weld.effects = weld.effects | EF_DIMLIGHT;
		weld.owner.weld_light_time = time + 0.2;
	}
	setmodel(weld, "progs/flame2.mdl");
	setsize(weld, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(weld, org - '0 0 6' + dir * FL_CLIENT);
	sound(weld.owner, CHAN_WEAPON, weld_fire_sound_1, 0.6, ATTN_NORM);
	sound(weld, CHAN_BODY, weld_fire_sound_2, 1, ATTN_NORM);
};

void() WeldExplode1 = [0, WeldExplode2]
{
};

void() WeldExplode2 = [3, WeldExplode3]
{
};

void() WeldExplode3 = [4, SUB_Remove]
{
};

void() WeldTouch = 
{
	local float r;
	local float d;
	local float db;
	local entity e;
	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	if (self.waterlevel > 1)
	{
		remove(self);
		return;
	}
	if (self.enemy.items & IT_SUIT)
	{
		remove(self);
		return;
	}
	if (self.enemy.classname == "monster_dragon")
	{
		remove(self);
		return;
	}
	if (other.takedamage)
	{
		spawn_touchblood(MOVETYPE_FLYMISSILE);
	}
	e = findradius(self.origin, WELD_DAMAGE_RADIUS);
	while (e)
	{
		if (e.takedamage)
		{
			if (e.takedamage != DAMAGE_AIM)
			{
				T_Damage(e, self, self.owner, MOVETYPE_BOUNCE);
			}
			else
			{
				r = random();
				db = MOVETYPE_BOUNCE + (SERVO_VOLUME - r) * MOVETYPE_TOSS;
				d = vlen(e.origin + '0 0 16' - self.origin);
				if (d < WELD_DAMAGE_RADIUS - MOVETYPE_STEP * db)
				{
					d = db;
				}
				else
				{
					if (d < WELD_DAMAGE_RADIUS)
					{
						d = (WELD_DAMAGE_RADIUS - d) * 0.25;
					}
					else
					{
						d = 0;
					}
				}
				if (d)
				{
					T_Damage(e, self, self.owner, d);
					if (r > 0.85)
					{
						if (d > MOVETYPE_FLY)
						{
							BurnSetOnFire(e, self.owner);
						}
					}
				}
			}
		}
		e = e.chain;
	}
	self.origin = self.origin - MOVETYPE_STEP * normalize(self.velocity);
	self.movetype = MOVETYPE_NONE;
	self.velocity = VEC_ORIGIN;
	self.touch = SUB_Null;
	self.solid = SOLID_NOT;
	self.think = SUB_Remove;
	self.nextthink = time + MOVETYPE_STEP;
	setmodel(self, "progs/s_explod.spr");
	setorigin(self, self.origin);
	sound(self, CHAN_BODY, weld_explode_sound, 1, ATTN_NORM);
	WeldExplode1();
};


void() BurnMakeBubble = 
{
	local entity bubble;
	bubble = spawn();
	bubble.movetype = MOVETYPE_NOCLIP;
	bubble.solid = SOLID_NOT;
	bubble.velocity = '0 0 15';
	bubble.nextthink = time + SERVO_VOLUME;
	bubble.think = bubble_bob;
	bubble.classname = "bubble";
	bubble.owner = self.owner;
	bubble.frame = 0;
	bubble.cnt = 0;
	setmodel(bubble, "progs/s_bubble.spr");
	setorigin(bubble, self.owner.origin + '0 0 24');
	setsize(bubble, '-8 -8 -8', '8 8 8');
	self.nextthink = time + GYRO_TURBULENCEMOD_AIR + random() * 0.2;
	self.think = BurnMakeBubble;
	self.air_finished = self.air_finished + 1;
	if (self.air_finished >= self.bubble_count)
	{
		remove(self);
	}
	if (self.waterlevel > 1)
	{
		remove(self);
	}
};

void(float num_bubbles) BurnSteam = 
{
	local entity steam;
	steam = spawn();
	steam.movetype = MOVETYPE_NONE;
	steam.solid = SOLID_NOT;
	steam.nextthink = time + GYRO_TURBULENCEMOD_AIR;
	steam.think = BurnMakeBubble;
	steam.air_finished = 0;
	steam.owner = self.enemy;
	steam.bubble_count = num_bubbles;
	setorigin(steam, self.enemy.origin);
	sound(steam.owner, CHAN_BODY, burn_extinguish_sound, 1, ATTN_NORM);
};

void() BurnThink = 
{
	local float damage;
	local float r;
	local entity e;
	local vector vf;
	local vector vr;
	if (self.enemy.deadflag != DEAD_NO)
	{
		if (self.enemy.burn_burning)
		{
			self.enemy.burn_burning = 0;
		}
		else
		{
			if (self.enemy.deadflag == DEAD_DEAD)
			{
				remove(self.burn_flame);
				setorigin(self, self.origin - '0 0 12');
				BecomeExplosion();
				return;
			}
		}
	}
	if (time > self.burn_damage_time)
	{
		if (self.enemy.waterlevel > 1)
		{
			BurnSteam(FL_CLIENT);
			self.enemy.burn_burning = 0;
		}
		if (self.enemy.burn_burning)
		{
			damage = 0;
			if (self.enemy.burn_burning & 1)
			{
				damage = damage + MOVETYPE_WALK;
				if (time > self.burn_lifetime1)
				{
					self.enemy.burn_burning = self.enemy.burn_burning - 1;
				}
			}
			if (self.enemy.burn_burning & FL_SWIM)
			{
				damage = damage + MOVETYPE_WALK;
				if (time > self.burn_lifetime2)
				{
					self.enemy.burn_burning = self.enemy.burn_burning - FL_SWIM;
				}
			}
			if (self.enemy.burn_burning & MOVETYPE_STEP)
			{
				damage = damage + MOVETYPE_WALK;
				if (time > self.burn_lifetime4)
				{
					self.enemy.burn_burning = self.enemy.burn_burning - MOVETYPE_STEP;
				}
			}
			r = random();
			if (damage > 0 && self.enemy.health > 0)
			{
				T_Damage(self.enemy, self, self.owner, damage);
			}
			e = findradius(self.enemy.origin + '0 0 18', 50);
			while (e)
			{
				if (e != self.enemy)
				{
					if (e.takedamage == DAMAGE_AIM)
					{
						T_Damage(e, self, self.enemy, MOVETYPE_TOSS + r * MOVETYPE_STEP);
						if (r > SERVO_VOLUME)
						{
							BurnSetOnFire(e, self.enemy);
						}
					}
				}
				e = e.chain;
			}
		}
		self.burn_damage_time = time + 1;
	}
	if (self.enemy.burn_burning)
	{
		makevectors(self.enemy.v_angle);
		vf = crandom() * FL_SWIM * v_forward;
		vr = crandom() * MOVETYPE_STEP * v_right;
		self.origin = self.enemy.origin + '0 0 18' - MOVETYPE_PUSH * v_forward + vf + vr;
		self.burn_flame.origin = self.enemy.origin + '0 0 18' - MOVETYPE_PUSH * v_forward - vf - vr;
		if (self.enemy.deadflag != DEAD_NO)
		{
			self.origin = self.origin - '0 0 12';
			self.burn_flame.origin = self.burn_flame.origin - '0 0 12';
		}
		setorigin(self, self.origin);
		setorigin(self.burn_flame, self.burn_flame.origin);
		self.nextthink = time + 0.020000;
		return;
	}
	remove(self.burn_flame);
	remove(self);
};

void(entity victim, entity attacker) BurnSetOnFire = 
{
	local entity flame;
	local float r;
	local entity flame2;
	if (victim.waterlevel > 1)
	{
		return;
	}
	if (victim.invincible_finished >= time)
	{
		return;
	}
	if (victim.classname == "monster_dragon")
	{
		remove(self);
		return;
	}
	if (victim.th_die == barrel_explode)
	{
		return;
	}
	if (victim.items & IT_SUIT)
	{
		remove(self);
		return;
	}
	if (victim.health <= 0)
	{
		return;
	}
	if (!(victim.burn_burning))
	{
		flame = spawn();
		flame.owner = attacker;
		flame.enemy = victim;
		flame.movetype = MOVETYPE_NONE;
		flame.velocity = VEC_ORIGIN;
		flame.solid = SOLID_NOT;
		flame.ltime = time + MOVETYPE_BOUNCE;
		flame.classname = "burn_flame";
		flame.origin = victim.origin + '-4 0 18';
		flame.think = BurnThink;
		flame.nextthink = time + GYRO_TURBULENCEMOD_AIR;
		flame.effects = flame.effects | EF_DIMLIGHT;
		setmodel(flame, "progs/flame2.mdl");
		flame.frame = 1;
		setsize(flame, VEC_ORIGIN, VEC_ORIGIN);
		setorigin(flame, victim.origin + '-4 0 18');
		victim.burn_flame = flame;
		flame2 = spawn();
		flame2.owner = attacker;
		flame2.enemy = victim;
		flame2.movetype = MOVETYPE_NONE;
		flame2.velocity = VEC_ORIGIN;
		flame2.solid = SOLID_NOT;
		flame2.ltime = time + 15;
		flame2.origin = victim.origin + '4 0 18';
		flame2.think = SUB_Null;
		setmodel(flame2, "progs/flame2.mdl");
		flame2.frame = 1;
		setsize(flame2, VEC_ORIGIN, VEC_ORIGIN);
		setorigin(flame2, victim.origin + '4 0 18');
		victim.burn_flame2 = flame2;
		flame.burn_flame = flame2;
	}
	else
	{
		flame = victim.burn_flame;
	}
	if (victim.burn_burning == MOVETYPE_PUSH)
	{
		if (flame.burn_lifetime1 <= flame.burn_lifetime2)
		{
			if (flame.burn_lifetime1 <= flame.burn_lifetime4)
			{
				flame.burn_lifetime1 = time + 15;
			}
		}
		else
		{
			if (flame.burn_lifetime2 <= flame.burn_lifetime4)
			{
				if (flame.burn_lifetime2 <= flame.burn_lifetime1)
				{
					flame.burn_lifetime2 = time + 15;
				}
			}
			else
			{
				flame.burn_lifetime4 = time + 15;
			}
		}
	}
	else
	{
		if (!(victim.burn_burning & 1))
		{
			flame.burn_lifetime1 = time + 15;
			victim.burn_burning = victim.burn_burning | 1;
		}
		else
		{
			if (!(victim.burn_burning & FL_SWIM))
			{
				flame.burn_lifetime2 = time + 15;
				victim.burn_burning = victim.burn_burning | FL_SWIM;
			}
			else
			{
				flame.burn_lifetime4 = time + 15;
				victim.burn_burning = victim.burn_burning | MOVETYPE_STEP;
			}
		}
	}
	sound(flame, CHAN_WEAPON, burn_light_sound, 1, ATTN_NORM);
};

void() BurnPainSound = 
{
	if (time < self.burn_painsound_time)
	{
		return;
	}
	if (random() > SERVO_VOLUME)
	{
		sound(self, CHAN_VOICE, burn_pain_sound_1, 1, ATTN_NORM);
	}
	else
	{
		sound(self, CHAN_VOICE, burn_pain_sound_2, 1, ATTN_NORM);
	}
	self.burn_painsound_time = time + 0.8;
};


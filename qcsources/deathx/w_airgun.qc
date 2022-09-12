void(entity e, float strength, float percent, float inRange, float eSpeed, float inDamage) Airg = 
{
	local float dist;
	local vector delta;
	local float ldmg;
	local vector dir;
	while (e)
	{
		if (visible(e))
		{
			if (self.waterlevel > 2 || hornInfront(e))
			{
				if (e.movetype != MOVETYPE_NONE)
				{
					if (e.movetype != MOVETYPE_PUSH)
					{
						if (e.movetype != MOVETYPE_NOCLIP)
						{
							if ((e.AIRG_Flags & AIRG_EXCLUDEENTITY) != AIRG_EXCLUDEENTITY)
							{
								if (e.movetype == MOVETYPE_STEP || e.movetype == MOVETYPE_WALK || e.movetype == MOVETYPE_BOUNCE || e.movetype == MOVETYPE_FLYMISSILE)
								{
									if (e != self)
									{
										if (e.flags & FL_FLY)
										{
											if (e.movetype == MOVETYPE_STEP)
											{
												e.movetype = MOVETYPE_FLY;
												e.AIRG_FlyTracker = spawn();
												e.AIRG_Flags = e.AIRG_Flags + AIRG_STEPCONVERTEDTOFLY;
												e.AIRG_FlyTracker.owner = e;
												e.AIRG_FlyTracker.nextthink = time + 2;
												e.AIRG_FlyTracker.think = removeFlyMode;
											}
											else
											{
												if (e.AIRG_Flags & AIRG_STEPCONVERTEDTOFLY)
												{
													e.AIRG_FlyTracker.nextthink = time + 2;
												}
											}
										}
										delta = e.origin - self.origin + self.view_ofs;
										dist = vlen(delta);
										percent = (inRange - dist) / inRange;
										if (e.flags & FL_ONGROUND)
										{
											setorigin(e, e.origin + '0 0 1');
											e.flags = e.flags - FL_ONGROUND;
											if (delta_z < 0)
											{
												delta_z = delta_z / -2;
											}
											delta = delta * 0.7;
											if (delta_z < 100)
											{
												delta_z = 100;
											}
										}
										delta = normalize(delta);
										delta = delta * percent * strength;
										if (self.waterlevel > 2)
										{
											if (percent >= 0.5)
											{
												if (e.classname == "player")
												{
													if (self.radsuit_finished == 0)
													{
														self.air_finished = time - 1;
													}
												}
											}
											if (hornInfront(e))
											{
												delta = delta * 0.8;
											}
											else
											{
												delta = delta * 0.5;
												percent = percent * 0.5;
											}
										}
										if (e.classname == "hmissile")
										{
											e.think = HomingTouch;
										}
										if (e.movetype == MOVETYPE_FLYMISSILE)
										{
											eSpeed = vlen(e.velocity);
											e.velocity = normalize(delta) * eSpeed;
										}
										else
										{
											e.velocity = e.velocity + delta;
											ldmg = percent * inDamage;
											if (e.movetype != MOVETYPE_WALK)
											{
												dir = e.origin - (self.absmin + self.absmax) * 0.5;
												dir = normalize(dir);
												e.velocity = e.velocity + dir * ldmg * 8;
											}
											T_Damage(e, self, self, ldmg);
										}
									}
								}
							}
						}
					}
				}
			}
		}
		e = e.chain;
	}
};

void(entity e, float strength, float percent, float inRange, float eSpeed, float inDamage) Airg2 = 
{
	local float dist;
	local vector delta;
	local float ldmg;
	local vector dir;
	while (e)
	{
		if (visible(e))
		{
			if (self.waterlevel > 2 || hornInfront(e))
			{
				if (e.movetype != MOVETYPE_NONE)
				{
					if (e.movetype != MOVETYPE_PUSH)
					{
						if (e.movetype != MOVETYPE_NOCLIP)
						{
							if ((e.AIRG_Flags & AIRG_EXCLUDEENTITY) != AIRG_EXCLUDEENTITY)
							{
								if (e != self)
								{
									if (e.flags & FL_FLY)
									{
										if (e.movetype == MOVETYPE_STEP)
										{
											e.movetype = MOVETYPE_FLY;
											e.AIRG_FlyTracker = spawn();
											e.AIRG_Flags = e.AIRG_Flags + AIRG_STEPCONVERTEDTOFLY;
											e.AIRG_FlyTracker.owner = e;
											e.AIRG_FlyTracker.nextthink = time + 2;
											e.AIRG_FlyTracker.think = removeFlyMode;
										}
										else
										{
											if (e.AIRG_Flags & AIRG_STEPCONVERTEDTOFLY)
											{
												e.AIRG_FlyTracker.nextthink = time + 2;
											}
										}
									}
									delta = e.origin - self.origin + self.view_ofs;
									dist = vlen(delta);
									percent = (inRange - dist) / inRange;
									if (e.flags & FL_ONGROUND)
									{
										setorigin(e, e.origin + '0 0 1');
										e.flags = e.flags - FL_ONGROUND;
										if (delta_z < 0)
										{
											delta_z = delta_z / -2;
										}
										delta = delta * 0.7;
										if (delta_z < 100)
										{
											delta_z = 100;
										}
									}
									delta = normalize(delta);
									delta = delta * percent * strength;
									if (self.waterlevel > 2)
									{
										if (percent >= 0.5)
										{
											if (e.classname == "player")
											{
												if (self.radsuit_finished == 0)
												{
													self.air_finished = time - 1;
												}
											}
										}
										if (hornInfront(e))
										{
											delta = delta * 0.8;
										}
										else
										{
											delta = delta * 0.5;
											percent = percent * 0.5;
										}
									}
									if (e.classname == "hmissile")
									{
										e.think = HomingTouch;
									}
									if (e.movetype == MOVETYPE_FLYMISSILE)
									{
										eSpeed = vlen(e.velocity);
										e.velocity = normalize(delta) * eSpeed;
									}
									else
									{
										e.velocity = e.velocity + delta;
										ldmg = percent * inDamage;
										if (e.movetype != MOVETYPE_WALK)
										{
											dir = e.origin - (self.absmin + self.absmax) * 0.5;
											dir = normalize(dir);
											e.velocity = e.velocity + dir * ldmg * 8;
										}
										T_Damage(e, self, self, ldmg);
									}
								}
							}
						}
					}
				}
			}
		}
		e = e.chain;
	}
};

void() launch_horn = 
{
	local entity e;
	local vector dir;
	local float eSpeed;
	local float dist;
	local float percent;
	local float nearAWall;
	local float strength;
	local float inDamage;
	strength = 1000;
	inDamage = 20;
	nearAWall = 0;
	if (!(self.button0))
	{
		player_run();
		return;
	}
	self.attack_finished = time + attackTime;
	if (self.AIRG_FireCount == 0 || self.AIRG_Timeout < time)
	{
		self.AIRG_Timeout = time + shotTimeout + attackTime;
		self.AIRG_FireCount = 1;
	}
	else
	{
		if (self.AIRG_FireCount >= maxFireRate)
		{
			if (self.waterlevel > 2)
			{
				if (!(self.player_flag & ITEM_RUNE5_FLAG))
				{
					sound(self, CHAN_AUTO, "weapons/agwfail.wav", 1, ATTN_NORM);
				}
			}
			else
			{
				if (!(self.player_flag & ITEM_RUNE5_FLAG))
				{
					sound(self, CHAN_AUTO, "weapons/agfail.wav", 1, ATTN_NORM);
				}
			}
			player_failedairgun1();
			return;
		}
		else
		{
			self.AIRG_FireCount = self.AIRG_FireCount + 1;
		}
	}
	if (self.waterlevel > 2)
	{
		inRange = inRange * 0.8;
		inDamage = inDamage * 2;
	}
	makevectors(self.v_angle);
	e = findradius(self.origin, inRange);
	if (servervars & SV_AIRMOVEITEMS)
	{
		Airg2(e, strength, percent, inRange, eSpeed, inDamage);
	}
	else
	{
		Airg(e, strength, percent, inRange, eSpeed, inDamage);
	}
	if (self.waterlevel > 2)
	{
		DeathBubbles(numBubbles);
	}
	makevectors(self.v_angle);
	dir = self.origin + self.view_ofs;
	traceline(dir, dir + v_forward * 64, 0, self);
	if (trace_fraction != 1 && !(trace_ent.takedamage))
	{
		nearAWall = 1;
	}
	if (self.waterlevel > 2)
	{
		hornBlastSprite(nearAWall, 50, -50, 300, -20, 0.5);
		hornBlastSprite(nearAWall, 50, 50, 300, 20, 0.5);
	}
	else
	{
		hornBlastSprite(nearAWall, 50, -50, 300, -20, 1);
		hornBlastSprite(nearAWall, 50, 50, 300, 20, 1);
	}
	if (self.flags & FL_ONGROUND)
	{
		setorigin(self, self.origin + '0 0 1');
		self.flags = self.flags - FL_ONGROUND;
	}
	if (nearAWall)
	{
		recoil = recoil + recoil * (1 - trace_fraction) * 3;
	}
	self.velocity = self.velocity + v_forward * recoil * -1;
	if (self.waterlevel > 2)
	{
		if (!(self.player_flag & ITEM_RUNE5_FLAG))
		{
			sound(self, CHAN_AUTO, "weapons/agwater.wav", 1, ATTN_NORM);
		}
	}
	else
	{
		if (!(self.player_flag & ITEM_RUNE5_FLAG))
		{
			sound(self, CHAN_AUTO, "weapons/agfire.wav", 1, ATTN_NORM);
		}
	}
	player_airgun1();
};

float(entity e) hornInfront = 
{
	local vector vec;
	local float dot;
	makevectors(self.v_angle);
	vec = normalize(e.origin - self.origin - self.view_ofs);
	dot = vec * v_forward;
	if (dot > 0.8)
	{
		return 1;
	}
	return 0;
};

void() run_ablast1 = [0, run_ablast2]
{
};

void() run_ablast2 = [1, run_ablast3]
{
};

void() run_ablast3 = [2, run_ablast4]
{
};

void() run_ablast4 = [3, run_ablast5]
{
};

void() run_ablast5 = [4, run_ablast6]
{
};

void() run_ablast6 = [5, run_ablast1]
{
	remove(self);
};

void() run_ablastWater1 = [0, run_ablastWater2]
{
};

void() run_ablastWater2 = [0, run_ablastWater3]
{
};

void() run_ablastWater3 = [1, run_ablastWater4]
{
};

void() run_ablastWater4 = [1, run_ablastWater5]
{
};

void() run_ablastWater5 = [2, run_ablastWater6]
{
};

void() run_ablastWater6 = [2, run_ablastWater7]
{
};

void() run_ablastWater7 = [3, run_ablastWater8]
{
};

void() run_ablastWater8 = [3, run_ablastWater9]
{
};

void() run_ablastWater9 = [4, run_ablastWater10]
{
};

void() run_ablastWater10 = [4, run_ablastWater1]
{
	remove(self);
};

void(float nearAWall, float adjustForward, float adjustRight, float adjustUp, float positionRight, float spriteSpeed) hornBlastSprite = 
{
	local entity sprite;
	local entity oldself;
	oldself = self;
	sprite = spawn();
	sprite.solid = SOLID_NOT;
	if (oldself.waterlevel > 2)
	{
		sprite.movetype = MOVETYPE_NOCLIP;
	}
	else
	{
		sprite.movetype = MOVETYPE_BOUNCE;
	}
	setmodel(sprite, "progs/s_ablast.spr");
	sprite.velocity = v_forward * random() * adjustForward + v_right * random() * adjustRight + v_up * random() * adjustUp;
	sprite.velocity = sprite.velocity * spriteSpeed;
	if (nearAWall)
	{
		setorigin(sprite, self.origin + self.view_ofs + v_right * positionRight);
	}
	else
	{
		setorigin(sprite, self.origin + self.view_ofs + v_forward * 30 + v_right * positionRight);
	}
	setsize(sprite, '-8 -8 -8', '8 8 8');
	self = sprite;
	if (oldself.waterlevel > 2)
	{
		run_ablastWater1();
	}
	else
	{
		run_ablast1();
	}
	self = oldself;
};

void() removeFlyMode = 
{
	self.owner.movetype = MOVETYPE_STEP;
	self.owner.AIRG_Flags = self.owner.AIRG_Flags - AIRG_STEPCONVERTEDTOFLY;
	remove(self);
};


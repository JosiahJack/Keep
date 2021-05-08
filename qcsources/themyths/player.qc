void() player_stand1 = [17, player_stand1]
{
	self.weaponframe = 0;
	if (self.velocity_x || self.velocity_y)
	{
		self.walkframe = 0;
		player_run();
		return;
	}
	if (self.weapon == IT_AXE)
	{
		if (self.walkframe >= STAT_TOTALMONSTERS)
		{
			self.walkframe = 0;
		}
		self.frame = 17 + self.walkframe;
	}
	else
	{
		if (self.weapon == IT_MJOLNIR)
		{
			if (self.walkframe >= STAT_TOTALMONSTERS)
			{
				self.walkframe = 0;
			}
			self.frame = MOVETYPE_TOSS + self.walkframe;
		}
		else
		{
			if (self.walkframe >= MOVETYPE_FLY)
			{
				self.walkframe = 0;
			}
			self.frame = STAT_TOTALMONSTERS + self.walkframe;
		}
	}
	self.walkframe = self.walkframe + 1;
};

void() player_run = [6, player_run]
{
	local float r;
	self.weaponframe = 0;
	if (!(self.velocity_x) && !(self.velocity_y))
	{
		self.walkframe = 0;
		player_stand1();
		return;
	}
	if (self.weapon == IT_AXE)
	{
		if (self.walkframe == MOVETYPE_TOSS)
		{
			self.walkframe = 0;
		}
		self.frame = 0 + self.walkframe;
	}
	else
	{
		if (self.weapon == IT_MJOLNIR)
		{
			if (self.walkframe == MOVETYPE_TOSS)
			{
				self.walkframe = 0;
			}
			self.frame = self.walkframe;
		}
		else
		{
			if (self.walkframe == MOVETYPE_TOSS)
			{
				self.walkframe = 0;
			}
			self.frame = self.frame + self.walkframe;
		}
	}
	if (footsteps == 1)
	{
		self.spawnsilent = self.spawnsilent + vlen(self.origin - self.old_velocity);
		self.old_velocity = self.origin;
		if (self.flags & FL_ONGROUND)
		{
			if (self.spawnsilent > 95)
			{
				if (self.spawnsilent > 190)
				{
					self.spawnsilent = 0;
				}
				else
				{
					self.spawnsilent = 0.5 * (self.spawnsilent - 95);
				}
				r = random();
				if (r < 0.14)
				{
					sound(self, CHAN_VOICE, "misc/foot1.wav", 0.5, ATTN_NORM);
				}
				else
				{
					if (r < 0.290000)
					{
						sound(self, CHAN_VOICE, "misc/foot2.wav", 0.5, ATTN_NORM);
					}
					else
					{
						if (r < 0.43)
						{
							sound(self, CHAN_VOICE, "misc/foot3.wav", 0.5, ATTN_NORM);
						}
						else
						{
							if (r < 0.580000)
							{
								sound(self, CHAN_VOICE, "misc/foot4.wav", 0.5, ATTN_NORM);
							}
							else
							{
								if (r < 0.72)
								{
									sound(self, CHAN_VOICE, "misc/foot5.wav", 0.5, ATTN_NORM);
								}
								else
								{
									if (r < 0.86)
									{
										sound(self, CHAN_VOICE, "misc/foot6.wav", 0.5, ATTN_NORM);
									}
									else
									{
										sound(self, CHAN_VOICE, "misc/foot7.wav", 0.5, ATTN_NORM);
									}
								}
							}
						}
					}
				}
			}
		}
	}
	self.walkframe = self.walkframe + 1;
};

void() player_shot1 = [113, player_shot2]
{
	self.weaponframe = 1;
	self.effects = self.effects | EF_MUZZLEFLASH;
};

void() player_shot2 = [114, player_shot3]
{
	self.weaponframe = FL_SWIM;
};

void() player_shot3 = [115, player_shot4]
{
	self.weaponframe = MOVETYPE_WALK;
};

void() player_shot4 = [116, player_shot5]
{
	self.weaponframe = MOVETYPE_STEP;
};

void() player_shot5 = [117, player_shot6]
{
	self.weaponframe = MOVETYPE_FLY;
};

void() player_shot6 = [118, player_run]
{
	self.weaponframe = MOVETYPE_TOSS;
};

void() player_axe1 = [119, player_axe2]
{
	self.weaponframe = 1;
};

void() player_axe2 = [120, player_axe3]
{
	self.weaponframe = FL_SWIM;
};

void() player_axe3 = [121, player_axe4]
{
	self.weaponframe = MOVETYPE_WALK;
	W_FireAxe();
};

void() player_axe4 = [122, player_run]
{
	self.weaponframe = MOVETYPE_STEP;
};

void() player_axeb1 = [125, player_axeb2]
{
	self.weaponframe = MOVETYPE_FLY;
};

void() player_axeb2 = [126, player_axeb3]
{
	self.weaponframe = MOVETYPE_TOSS;
};

void() player_axeb3 = [127, player_axeb4]
{
	self.weaponframe = MOVETYPE_PUSH;
	W_FireAxe();
};

void() player_axeb4 = [128, player_run]
{
	self.weaponframe = FL_CLIENT;
};

void() player_axec1 = [131, player_axec2]
{
	self.weaponframe = 1;
};

void() player_axec2 = [132, player_axec3]
{
	self.weaponframe = FL_SWIM;
};

void() player_axec3 = [133, player_axec4]
{
	self.weaponframe = MOVETYPE_WALK;
	W_FireAxe();
};

void() player_axec4 = [134, player_run]
{
	self.weaponframe = MOVETYPE_STEP;
};

void() player_axed1 = [137, player_axed2]
{
	self.weaponframe = MOVETYPE_FLY;
};

void() player_axed2 = [138, player_axed3]
{
	self.weaponframe = MOVETYPE_TOSS;
};

void() player_axed3 = [139, player_axed4]
{
	self.weaponframe = MOVETYPE_PUSH;
	W_FireAxe();
};

void() player_axed4 = [140, player_run]
{
	self.weaponframe = FL_CLIENT;
};

void() player_nail1 = [103, player_nail2]
{
	self.effects = self.effects | EF_MUZZLEFLASH;
	if (!(self.button0))
	{
		player_run();
		return;
	}
	self.weaponframe = self.weaponframe + 1;
	if (self.weaponframe == MOVETYPE_FLYMISSILE)
	{
		self.weaponframe = 1;
	}
	SuperDamageSound();
	W_FireSpikes(MOVETYPE_STEP);
	self.attack_finished = time + 0.2;
};

void() player_nail2 = [104, player_nail1]
{
	self.effects = self.effects | EF_MUZZLEFLASH;
	if (!(self.button0))
	{
		player_run();
		return;
	}
	self.weaponframe = self.weaponframe + 1;
	if (self.weaponframe == MOVETYPE_FLYMISSILE)
	{
		self.weaponframe = 1;
	}
	SuperDamageSound();
	W_FireSpikes(CONTENT_SLIME);
	self.attack_finished = time + 0.2;
};

void() player_light1 = [105, player_light2]
{
	self.effects = self.effects | EF_MUZZLEFLASH;
	if (!(self.button0))
	{
		player_run();
		return;
	}
	self.weaponframe = self.weaponframe + 1;
	if (self.weaponframe == MOVETYPE_FLY)
	{
		self.weaponframe = 1;
	}
	SuperDamageSound();
	W_FireLightning();
	self.attack_finished = time + 0.2;
};

void() player_light2 = [106, player_light1]
{
	self.effects = self.effects | EF_MUZZLEFLASH;
	if (!(self.button0))
	{
		player_run();
		return;
	}
	self.weaponframe = self.weaponframe + 1;
	if (self.weaponframe == MOVETYPE_FLY)
	{
		self.weaponframe = 1;
	}
	SuperDamageSound();
	W_FireLightning();
	self.attack_finished = time + 0.2;
};

void() player_hammer1 = [32, player_hammer2]
{
	self.weaponframe = 1;
};

void() player_hammer2 = [33, player_hammer3]
{
	self.weaponframe = FL_SWIM;
};

void() player_hammer3 = [34, player_hammer4]
{
	self.weaponframe = MOVETYPE_WALK;
};

void() player_hammer4 = [35, player_hammer5]
{
	self.weaponframe = MOVETYPE_STEP;
	HIP_FireMjolnir();
};

void() player_hammer5 = [36, player_hammer6]
{
	self.weaponframe = MOVETYPE_STEP;
};

void() player_hammer6 = [37, player_run]
{
	self.weaponframe = MOVETYPE_STEP;
};

void() player_mjolnir1 = [38, player_mjolnir2]
{
	self.weaponframe = 1;
};

void() player_mjolnir2 = [39, player_mjolnir3]
{
	self.weaponframe = FL_SWIM;
};

void() player_mjolnir3 = [40, player_mjolnir4]
{
	self.weaponframe = MOVETYPE_WALK;
};

void() player_mjolnir4 = [41, player_mjolnir5]
{
	self.weaponframe = MOVETYPE_STEP;
	HIP_FireMjolnir();
};

void() player_mjolnir5 = [42, player_mjolnir6]
{
	self.weaponframe = MOVETYPE_STEP;
};

void() player_mjolnir6 = [43, player_run]
{
	self.weaponframe = MOVETYPE_STEP;
};

void() player_laser1 = [103, player_laser3]
{
	self.attack_finished = time + GYRO_TURBULENCEMOD_AIR;
	self.weaponframe = 1;
	self.nextthink = time + GYRO_TURBULENCEMOD_AIR;
	HIP_FireLaser(0);
};

void() player_laser2 = [104, player_laser3]
{
	self.attack_finished = time + GYRO_TURBULENCEMOD_AIR;
	self.weaponframe = FL_SWIM;
	self.nextthink = time + GYRO_TURBULENCEMOD_AIR;
};

void() player_laser3 = [104, player_laser1]
{
	self.attack_finished = time + GYRO_TURBULENCEMOD_AIR;
	self.weaponframe = MOVETYPE_STEP;
	self.nextthink = time + GYRO_TURBULENCEMOD_AIR;
	HIP_FireLaser(1);
};

void() player_laser4 = [103, player_laser1]
{
	self.attack_finished = time + GYRO_TURBULENCEMOD_AIR;
	self.weaponframe = MOVETYPE_FLY;
	self.nextthink = time + GYRO_TURBULENCEMOD_AIR;
};

void() player_rocket1 = [107, player_rocket2]
{
	self.weaponframe = 1;
	self.effects = self.effects | EF_MUZZLEFLASH;
};

void() player_rocket2 = [108, player_rocket3]
{
	self.weaponframe = FL_SWIM;
};

void() player_rocket3 = [109, player_rocket4]
{
	self.weaponframe = MOVETYPE_WALK;
};

void() player_rocket4 = [110, player_rocket5]
{
	self.weaponframe = MOVETYPE_STEP;
};

void() player_rocket5 = [111, player_rocket6]
{
	self.weaponframe = MOVETYPE_FLY;
};

void() player_rocket6 = [112, player_run]
{
	self.weaponframe = MOVETYPE_TOSS;
};

void() PainSound = 
{
	local float rs;
	if (self.health < 0)
	{
		return;
	}
	if (damage_attacker.classname == "teledeath")
	{
		sound(self, CHAN_VOICE, "player/teledth1.wav", 1, ATTN_NONE);
		return;
	}
	if (self.watertype == CONTENT_WATER && self.waterlevel == MOVETYPE_WALK)
	{
		DeathBubbles(1);
		if (random() > 0.5)
		{
			sound(self, CHAN_VOICE, "player/drown1.wav", 1, ATTN_NORM);
		}
		else
		{
			sound(self, CHAN_VOICE, "player/drown2.wav", 1, ATTN_NORM);
		}
		return;
	}
	if (self.watertype == CONTENT_SLIME)
	{
		if (random() > 0.5)
		{
			sound(self, CHAN_VOICE, "player/lburn1.wav", 1, ATTN_NORM);
		}
		else
		{
			sound(self, CHAN_VOICE, "player/lburn2.wav", 1, ATTN_NORM);
		}
		return;
	}
	if (self.watertype == CONTENT_LAVA)
	{
		if (random() > 0.5)
		{
			sound(self, CHAN_VOICE, "player/lburn1.wav", 1, ATTN_NORM);
		}
		else
		{
			sound(self, CHAN_VOICE, "player/lburn2.wav", 1, ATTN_NORM);
		}
		return;
	}
	if (self.pain_finished > time)
	{
		self.axhitme = 0;
		return;
	}
	self.pain_finished = time + 0.5;
	if (self.axhitme == 1)
	{
		self.axhitme = 0;
		sound(self, CHAN_VOICE, "player/axhit1.wav", 1, ATTN_NORM);
		return;
	}
	rs = rint(random() * MOVETYPE_FLY + 1);
	self.noise = "";
	if (rs == 1)
	{
		self.noise = "player/pain1.wav";
	}
	else
	{
		if (rs == FL_SWIM)
		{
			self.noise = "player/pain2.wav";
		}
		else
		{
			if (rs == MOVETYPE_WALK)
			{
				self.noise = "player/pain3.wav";
			}
			else
			{
				if (rs == MOVETYPE_STEP)
				{
					self.noise = "player/pain4.wav";
				}
				else
				{
					if (rs == MOVETYPE_FLY)
					{
						self.noise = "player/pain5.wav";
					}
					else
					{
						self.noise = "player/pain6.wav";
					}
				}
			}
		}
	}
	sound(self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
	return;
};

void() player_pain1 = [35, player_pain2]
{
	PainSound();
	self.weaponframe = 0;
};

void() player_pain2 = [36, player_pain3]
{
};

void() player_pain3 = [37, player_pain4]
{
};

void() player_pain4 = [38, player_pain5]
{
};

void() player_pain5 = [39, player_pain6]
{
};

void() player_pain6 = [40, player_run]
{
};

void() player_axpain1 = [29, player_axpain2]
{
	PainSound();
	self.weaponframe = 0;
};

void() player_axpain2 = [30, player_axpain3]
{
};

void() player_axpain3 = [31, player_axpain4]
{
};

void() player_axpain4 = [32, player_axpain5]
{
};

void() player_axpain5 = [33, player_axpain6]
{
};

void() player_axpain6 = [34, player_run]
{
};

void() player_hampain1 = [18, player_hampain2]
{
	PainSound();
	self.weaponframe = 0;
};

void() player_hampain2 = [19, player_hampain3]
{
};

void() player_hampain3 = [20, player_hampain4]
{
};

void() player_hampain4 = [21, player_hampain5]
{
};

void() player_hampain5 = [22, player_hampain6]
{
};

void() player_hampain6 = [23, player_run]
{
};

void() player_pain = 
{
	if (self.weaponframe)
	{
		return;
	}
	if (self.invisible_finished > time)
	{
		return;
	}
	if (self.weapon == IT_AXE)
	{
		player_axpain1();
	}
	else
	{
		if (self.weapon == IT_MJOLNIR)
		{
			player_hampain1();
		}
		else
		{
			player_pain1();
		}
	}
};

void() DeathBubblesSpawn = 
{
	local entity bubble;
	if (self.owner.waterlevel != MOVETYPE_WALK)
	{
		return;
	}
	bubble = spawn();
	setmodel(bubble, "progs/s_bubble.spr");
	setorigin(bubble, self.owner.origin + '0 0 24');
	bubble.movetype = MOVETYPE_NOCLIP;
	bubble.solid = SOLID_NOT;
	bubble.velocity = '0 0 15';
	bubble.nextthink = time + 0.5;
	bubble.think = bubble_bob;
	bubble.classname = "bubble";
	bubble.frame = 0;
	bubble.cnt = 0;
	setsize(bubble, '-8 -8 -8', '8 8 8');
	self.nextthink = time + GYRO_TURBULENCEMOD_AIR;
	self.think = DeathBubblesSpawn;
	self.air_finished = self.air_finished + 1;
	if (self.air_finished >= self.bubble_count)
	{
		remove(self);
	}
};

void(float num_bubbles) DeathBubbles = 
{
	local entity bubble_spawner;
	bubble_spawner = spawn();
	setorigin(bubble_spawner, self.origin);
	bubble_spawner.movetype = MOVETYPE_NONE;
	bubble_spawner.solid = SOLID_NOT;
	bubble_spawner.nextthink = time + GYRO_TURBULENCEMOD_AIR;
	bubble_spawner.think = DeathBubblesSpawn;
	bubble_spawner.air_finished = 0;
	bubble_spawner.owner = self;
	bubble_spawner.bubble_count = num_bubbles;
	return;
};

void() DeathSound = 
{
	local float rs;
	if (self.waterlevel == MOVETYPE_WALK)
	{
		DeathBubbles(20);
		sound(self, CHAN_VOICE, "player/h2odeath.wav", 1, ATTN_NONE);
		return;
	}
	rs = rint(random() * MOVETYPE_STEP + 1);
	if (rs == 1)
	{
		self.noise = "player/death1.wav";
	}
	if (rs == FL_SWIM)
	{
		self.noise = "player/death2.wav";
	}
	if (rs == MOVETYPE_WALK)
	{
		self.noise = "player/death3.wav";
	}
	if (rs == MOVETYPE_STEP)
	{
		self.noise = "player/death4.wav";
	}
	if (rs == MOVETYPE_FLY)
	{
		self.noise = "player/death5.wav";
	}
	sound(self, CHAN_VOICE, self.noise, 1, ATTN_NONE);
	return;
};

void() PlayerDead = 
{
	self.nextthink = CONTENT_EMPTY;
	self.deadflag = DEAD_DEAD;
};

vector(float dm) VelocityForDamage = 
{
	local vector v;
	if (vlen(damage_inflictor.velocity) > 0)
	{
		v = 0.2 * damage_inflictor.velocity;
		v = v + 25 * normalize(self.origin - damage_inflictor.origin);
		v_z = 100 + 100 * random();
		v_x = v_x + 50 * crandom();
		v_y = v_y + 50 * crandom();
	}
	else
	{
		v_x = 100 * crandom();
		v_y = 100 * crandom();
		v_z = MAX_CHARMER_DISTANCE + 100 * random();
	}
	if (dm > -50)
	{
		v = v * 0.7;
	}
	else
	{
		if (dm > -200)
		{
			v = v * FL_SWIM;
		}
		else
		{
			v = v * MOVETYPE_BOUNCE;
		}
	}
	return v_x;
};

void(string gibname, float dm) ThrowGib = 
{
	local entity new;
	new = spawn();
	new.origin = self.origin;
	setmodel(new, gibname);
	setsize(new, VEC_ORIGIN, VEC_ORIGIN);
	new.velocity = VelocityForDamage(dm);
	new.movetype = MOVETYPE_BOUNCE;
	new.solid = SOLID_NOT;
	new.avelocity_x = random() * 600;
	new.avelocity_y = random() * 600;
	new.avelocity_z = random() * 600;
	new.think = SUB_Remove;
	new.ltime = time;
	new.nextthink = time + MOVETYPE_BOUNCE + random() * MOVETYPE_BOUNCE;
	new.frame = 0;
	new.flags = 0;
};

void() HeadThink = 
{
	self.nextthink = CONTENT_EMPTY;
	if (world.worldtype != FL_SWIM)
	{
		if (random() < GYRO_TURBULENCEMOD_AIR)
		{
			sound(self, MOVETYPE_TOSS, "misc/flys.wav", 0.7, ATTN_STATIC);
		}
	}
};

void(string gibname, float dm) ThrowHead = 
{
	setmodel(self, gibname);
	self.frame = 0;
	self.nextthink = time + 1.5;
	self.movetype = MOVETYPE_BOUNCE;
	self.takedamage = DAMAGE_NO;
	self.solid = SOLID_NOT;
	self.view_ofs = '0 0 8';
	setsize(self, '-16 -16 0', '16 16 56');
	self.velocity = VelocityForDamage(dm);
	self.origin_z = self.origin_z - 24;
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	self.avelocity = crandom() * '0 600 0';
	self.gorging = 1;
	self.think = HeadThink;
};

void() GibPlayer = 
{
	ThrowHead("progs/h_player.mdl", self.health);
	ThrowGib("progs/gib1.mdl", self.health);
	ThrowGib("progs/gib2.mdl", self.health);
	ThrowGib("progs/gib3.mdl", self.health);
	self.deadflag = DEAD_DEAD;
	if (damage_attacker.classname == "teledeath")
	{
		sound(self, CHAN_VOICE, "player/teledth1.wav", 1, ATTN_NONE);
		return;
	}
	if (damage_attacker.classname == "teledeath2")
	{
		sound(self, CHAN_VOICE, "player/teledth1.wav", 1, ATTN_NONE);
		return;
	}
	if (random() < 0.5)
	{
		sound(self, CHAN_VOICE, "player/gib.wav", 1, ATTN_NONE);
	}
	else
	{
		sound(self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NONE);
	}
};

void() PlayerDie = 
{
	local float i;
	self.items = self.items - (self.items & IT_INVISIBILITY);
	self.invisible_finished = 0;
	self.invincible_finished = 0;
	self.super_damage_finished = 0;
	self.radsuit_finished = 0;
	self.wetsuit_finished = 0;
	self.modelindex = modelindex_player;
	self.empathy_finished = 0;
	self.items2 = self.items2 - (self.items2 & HIP_IT_EMPATHY_SHIELDS);
	if (deathmatch || coop)
	{
		DropBackpack();
	}
	self.weaponmodel = "";
	self.view_ofs = '0 0 -8';
	self.deadflag = DEAD_DYING;
	self.solid = SOLID_NOT;
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	self.movetype = MOVETYPE_TOSS;
	if (self.velocity_z < MOVETYPE_BOUNCE)
	{
		self.velocity_z = self.velocity_z + random() * 300;
	}
	if (self.health < -40)
	{
		GibPlayer();
		return;
	}
	DeathSound();
	self.angles_x = 0;
	self.angles_z = 0;
	if (self.weapon == IT_AXE)
	{
		player_die_ax1();
		return;
	}
	else
	{
		if (self.weapon == IT_MJOLNIR)
		{
			self.modelindex = modelindex_hammer;
			player_die_ham1();
			return;
		}
	}
	i = cvar("temp1");
	if (!i)
	{
		i = 1 + floor(random() * MOVETYPE_TOSS);
	}
	if (i == 1)
	{
		player_diea1();
	}
	else
	{
		if (i == FL_SWIM)
		{
			player_dieb1();
		}
		else
		{
			if (i == MOVETYPE_WALK)
			{
				player_diec1();
			}
			else
			{
				if (i == MOVETYPE_STEP)
				{
					player_died1();
				}
				else
				{
					player_diee1();
				}
			}
		}
	}
};

void() set_suicide_frame = 
{
	if (self.model != "progs/player.mdl")
	{
		return;
	}
	self.frame = 60;
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_TOSS;
	self.deadflag = DEAD_DEAD;
	self.nextthink = CONTENT_EMPTY;
};

void() player_diea1 = [50, player_diea2]
{
};

void() player_diea2 = [51, player_diea3]
{
};

void() player_diea3 = [52, player_diea4]
{
};

void() player_diea4 = [53, player_diea5]
{
};

void() player_diea5 = [54, player_diea6]
{
};

void() player_diea6 = [55, player_diea7]
{
};

void() player_diea7 = [56, player_diea8]
{
};

void() player_diea8 = [57, player_diea9]
{
};

void() player_diea9 = [58, player_diea10]
{
};

void() player_diea10 = [59, player_diea11]
{
};

void() player_diea11 = [60, player_diea11]
{
	PlayerDead();
};

void() player_dieb1 = [61, player_dieb2]
{
};

void() player_dieb2 = [62, player_dieb3]
{
};

void() player_dieb3 = [63, player_dieb4]
{
};

void() player_dieb4 = [64, player_dieb5]
{
};

void() player_dieb5 = [65, player_dieb6]
{
};

void() player_dieb6 = [66, player_dieb7]
{
};

void() player_dieb7 = [67, player_dieb8]
{
};

void() player_dieb8 = [68, player_dieb9]
{
};

void() player_dieb9 = [69, player_dieb9]
{
	PlayerDead();
};

void() player_diec1 = [70, player_diec2]
{
};

void() player_diec2 = [71, player_diec3]
{
};

void() player_diec3 = [72, player_diec4]
{
};

void() player_diec4 = [73, player_diec5]
{
};

void() player_diec5 = [74, player_diec6]
{
};

void() player_diec6 = [75, player_diec7]
{
};

void() player_diec7 = [76, player_diec8]
{
};

void() player_diec8 = [77, player_diec9]
{
};

void() player_diec9 = [78, player_diec10]
{
};

void() player_diec10 = [79, player_diec11]
{
};

void() player_diec11 = [80, player_diec12]
{
};

void() player_diec12 = [81, player_diec13]
{
};

void() player_diec13 = [82, player_diec14]
{
};

void() player_diec14 = [83, player_diec15]
{
};

void() player_diec15 = [84, player_diec15]
{
	PlayerDead();
};

void() player_died1 = [85, player_died2]
{
};

void() player_died2 = [86, player_died3]
{
};

void() player_died3 = [87, player_died4]
{
};

void() player_died4 = [88, player_died5]
{
};

void() player_died5 = [89, player_died6]
{
};

void() player_died6 = [90, player_died7]
{
};

void() player_died7 = [91, player_died8]
{
};

void() player_died8 = [92, player_died9]
{
};

void() player_died9 = [93, player_died9]
{
	PlayerDead();
};

void() player_diee1 = [94, player_diee2]
{
};

void() player_diee2 = [95, player_diee3]
{
};

void() player_diee3 = [96, player_diee4]
{
};

void() player_diee4 = [97, player_diee5]
{
};

void() player_diee5 = [98, player_diee6]
{
};

void() player_diee6 = [99, player_diee7]
{
};

void() player_diee7 = [100, player_diee8]
{
};

void() player_diee8 = [101, player_diee9]
{
};

void() player_diee9 = [102, player_diee9]
{
	PlayerDead();
};

void() player_die_ax1 = [41, player_die_ax2]
{
};

void() player_die_ax2 = [42, player_die_ax3]
{
};

void() player_die_ax3 = [43, player_die_ax4]
{
};

void() player_die_ax4 = [44, player_die_ax5]
{
};

void() player_die_ax5 = [45, player_die_ax6]
{
};

void() player_die_ax6 = [46, player_die_ax7]
{
};

void() player_die_ax7 = [47, player_die_ax8]
{
};

void() player_die_ax8 = [48, player_die_ax9]
{
};

void() player_die_ax9 = [49, player_die_ax9]
{
	PlayerDead();
};

void() player_die_ham1 = [24, player_die_ham2]
{
};

void() player_die_ham2 = [25, player_die_ham3]
{
};

void() player_die_ham3 = [26, player_die_ham4]
{
};

void() player_die_ham4 = [27, player_die_ham5]
{
};

void() player_die_ham5 = [28, player_die_ham6]
{
};

void() player_die_ham6 = [29, player_die_ham7]
{
};

void() player_die_ham7 = [30, player_die_ham8]
{
};

void() player_die_ham8 = [31, player_die_ham8]
{
	PlayerDead();
};


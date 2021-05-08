void() player_stand1 = [28, player_stand1]
{
	if (self.velocity_x || self.velocity_y)
	{
		self.walkframe = 0;
		player_run();
		return;
	}
	if (self.guninuse == GUN_CHAINSAW)
	{
		self.weaponframe = self.weaponframe + 1;
		if (self.weaponframe >= MOVETYPE_FLY)
		{
			self.weaponframe = 0;
			if (self.view_ofs != VEC_ORIGIN)
			{
				sound(self, CHAN_AUTO, "weapons/sawridle.wav", 1, ATTN_NORM);
			}
		}
		if (self.walkframe >= MOVETYPE_FLY)
		{
			self.walkframe = 0;
		}
		self.frame = SVC_TEMPENTITY + self.walkframe;
		self.walkframe = self.walkframe + 1;
		return;
	}
	else
	{
		self.weaponframe = 0;
	}
	if (self.guninuse == GUN_AXE)
	{
		if (self.walkframe >= STAT_TOTALMONSTERS)
		{
			self.walkframe = 0;
		}
		self.frame = SVC_FOUNDSECRET + self.walkframe;
	}
	else
	{
		if (self.walkframe >= MOVETYPE_FLY)
		{
			self.walkframe = 0;
		}
		self.frame = 18 + self.walkframe;
	}
	self.walkframe = self.walkframe + 1;
};

void() player_run = [6, player_run]
{
	if (!(self.velocity_x) && !(self.velocity_y))
	{
		self.walkframe = 0;
		player_stand1();
		return;
	}
	if (self.guninuse == GUN_CHAINSAW)
	{
		self.weaponframe = self.weaponframe + 1;
		if (self.weaponframe >= MOVETYPE_FLY)
		{
			self.weaponframe = 0;
			if (self.view_ofs != VEC_ORIGIN)
			{
				sound(self, CHAN_AUTO, "weapons/sawridle.wav", 1, ATTN_NORM);
			}
		}
		if (self.walkframe == MOVETYPE_TOSS)
		{
			self.walkframe = 0;
		}
		self.frame = STAT_TOTALMONSTERS + self.walkframe;
		self.walkframe = self.walkframe + 1;
		return;
	}
	else
	{
		self.weaponframe = 0;
	}
	if (self.guninuse == GUN_AXE)
	{
		if (self.walkframe == MOVETYPE_TOSS)
		{
			self.walkframe = 0;
		}
		self.frame = 0 + self.walkframe;
	}
	else
	{
		if (self.walkframe == MOVETYPE_TOSS)
		{
			self.walkframe = 0;
		}
		self.frame = self.frame + self.walkframe;
	}
	self.walkframe = self.walkframe + 1;
};

void() player_shot1 = [141, player_shot2]
{
	self.weaponframe = 1;
	self.effects = self.effects | EF_MUZZLEFLASH;
};

void() player_shot2 = [142, player_shot3]
{
	self.weaponframe = FL_SWIM;
};

void() player_shot3 = [143, player_shot4]
{
	self.weaponframe = MOVETYPE_WALK;
};

void() player_shot4 = [144, player_shot5]
{
	self.weaponframe = MOVETYPE_STEP;
};

void() player_shot5 = [145, player_shot6]
{
	self.weaponframe = MOVETYPE_FLY;
};

void() player_shot6 = [146, player_run]
{
	self.weaponframe = 0;
};

void() W_FireRC = 
{
	local vector dir;
	local vector back;
	if (self.currentammo == 1)
	{
		W_FireShotgun();
		return;
	}
	if (self.weaponframe < MOVETYPE_WALK)
	{
		sound(self, CHAN_WEAPON, "weapons/shotgn2.wav", 1, ATTN_NORM);
	}
	self.punchangle_x = CONTENT_SLIME;
	if (!(self.flags & FL_ONGROUND))
	{
		self.velocity = self.velocity - v_forward * 20;
	}
	self.currentammo = self.ammo_shells = self.ammo_shells - 1;
	makevectors(self.v_angle);
	dir = v_forward;
	if (deathmatch)
	{
		FireBullets(18, dir, '0.13 0.09 0');
	}
	else
	{
		FireBullets(13, dir, '0.120000 0.080000 0');
	}
};

void() player_rc1 = [141, player_rc2]
{
	self.weaponframe = 1;
	W_FireRC();
	self.effects = self.effects | EF_MUZZLEFLASH;
};

void() player_rc2 = [142, player_rc3]
{
	self.weaponframe = FL_SWIM;
};

void() player_rc3 = [143, player_rc4]
{
	self.weaponframe = MOVETYPE_WALK;
};

void() player_rc4 = [144, player_rc5]
{
	self.weaponframe = MOVETYPE_STEP;
	W_FireRC();
	self.effects = self.effects | EF_MUZZLEFLASH;
};

void() player_rc5 = [145, player_rc6]
{
	self.weaponframe = MOVETYPE_FLY;
};

void() player_rc6 = [146, player_run]
{
	self.weaponframe = MOVETYPE_TOSS;
};

void() player_axe1 = [147, player_axe2]
{
	self.weaponframe = 1;
};

void() player_axe2 = [148, player_axe3]
{
	self.weaponframe = FL_SWIM;
};

void() player_axe3 = [149, player_axe4]
{
	self.weaponframe = MOVETYPE_WALK;
	W_FireAxe();
};

void() player_axe4 = [150, player_run]
{
	self.weaponframe = MOVETYPE_STEP;
};

void() player_axeb1 = [153, player_axeb2]
{
	self.weaponframe = MOVETYPE_FLY;
};

void() player_axeb2 = [154, player_axeb3]
{
	self.weaponframe = MOVETYPE_TOSS;
};

void() player_axeb3 = [155, player_axeb4]
{
	self.weaponframe = MOVETYPE_PUSH;
	W_FireAxe();
};

void() player_axeb4 = [156, player_run]
{
	self.weaponframe = FL_CLIENT;
};

void() player_axec1 = [159, player_axec2]
{
	self.weaponframe = 1;
};

void() player_axec2 = [160, player_axec3]
{
	self.weaponframe = FL_SWIM;
};

void() player_axec3 = [161, player_axec4]
{
	self.weaponframe = MOVETYPE_WALK;
	W_FireAxe();
};

void() player_axec4 = [162, player_run]
{
	self.weaponframe = MOVETYPE_STEP;
};

void() player_axed1 = [165, player_axed2]
{
	self.weaponframe = MOVETYPE_FLY;
};

void() player_axed2 = [166, player_axed3]
{
	self.weaponframe = MOVETYPE_TOSS;
};

void() player_axed3 = [167, player_axed4]
{
	self.weaponframe = MOVETYPE_PUSH;
	W_FireAxe();
};

void() player_axed4 = [168, player_run]
{
	self.weaponframe = FL_CLIENT;
};

void() player_chainsaw1 = [131, player_chainsaw2]
{
	self.weaponframe = MOVETYPE_FLY;
	W_FireSaw();
};

void() player_chainsaw2 = [132, player_chainsaw3]
{
	self.weaponframe = MOVETYPE_TOSS;
	if (!(self.button0))
	{
		player_run();
		return;
	}
};

void() player_chainsaw3 = [131, player_chainsaw4]
{
	self.weaponframe = MOVETYPE_PUSH;
	W_FireSaw();
};

void() player_chainsaw4 = [132, player_chainsaw5]
{
	self.weaponframe = FL_CLIENT;
	if (!(self.button0))
	{
		player_run();
		return;
	}
};

void() player_chainsaw5 = [131, player_chainsaw6]
{
	self.weaponframe = MOVETYPE_FLYMISSILE;
	W_FireSaw();
};

void() player_chainsaw6 = [132, player_run]
{
	self.weaponframe = MOVETYPE_BOUNCE;
};

void() player_nail1 = [129, player_nail2]
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

void() player_nail2 = [130, player_nail1]
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

void() player_light1 = [133, player_light2]
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

void() player_light2 = [134, player_light1]
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

void() player_chain1 = [135, player_chain2]
{
	self.weaponframe = 1;
	self.effects = self.effects | EF_MUZZLEFLASH;
};

void() player_chain2 = [136, player_chain3]
{
	self.weaponframe = FL_SWIM;
};

void() player_chain3 = [137, player_chain4]
{
	self.weaponframe = MOVETYPE_WALK;
};

void() player_chain4 = [138, player_run]
{
	self.weaponframe = MOVETYPE_STEP;
};

void() player_rocket1 = [135, player_rocket2]
{
	self.weaponframe = 1;
	self.effects = self.effects | EF_MUZZLEFLASH;
};

void() player_rocket2 = [136, player_rocket3]
{
	self.weaponframe = FL_SWIM;
};

void() player_rocket3 = [137, player_rocket4]
{
	self.weaponframe = MOVETYPE_WALK;
};

void() player_rocket4 = [138, player_rocket5]
{
	self.weaponframe = MOVETYPE_STEP;
};

void() player_rocket5 = [139, player_rocket6]
{
	self.weaponframe = MOVETYPE_FLY;
};

void() player_rocket6 = [140, player_run]
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

void() player_pain1 = [46, player_pain2]
{
	PainSound();
	self.weaponframe = 0;
};

void() player_pain2 = [47, player_pain3]
{
};

void() player_pain3 = [48, player_pain4]
{
};

void() player_pain4 = [49, player_pain5]
{
};

void() player_pain5 = [50, player_pain6]
{
};

void() player_pain6 = [51, player_run]
{
};

void() player_swpain1 = [52, player_pain2]
{
	PainSound();
	self.weaponframe = 0;
};

void() player_swpain2 = [53, player_pain3]
{
};

void() player_swpain3 = [54, player_pain4]
{
};

void() player_swpain4 = [55, player_pain5]
{
};

void() player_swpain5 = [56, player_pain6]
{
};

void() player_swpain6 = [57, player_run]
{
};

void() player_axpain1 = [40, player_axpain2]
{
	PainSound();
	self.weaponframe = 0;
};

void() player_axpain2 = [41, player_axpain3]
{
};

void() player_axpain3 = [42, player_axpain4]
{
};

void() player_axpain4 = [43, player_axpain5]
{
};

void() player_axpain5 = [44, player_axpain6]
{
};

void() player_axpain6 = [45, player_run]
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
	if (self.guninuse == GUN_AXE)
	{
		player_axpain1();
	}
	else
	{
		if (self.guninuse == GUN_CHAINSAW)
		{
			player_swpain1();
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
	self.nextthink = time + 0.1;
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
	bubble_spawner.nextthink = time + 0.1;
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

vector(float dm, vector dir) VelocityForDamage = 
{
	local vector v;
	local vector gib_dir;
	gib_dir = normalize(dir);
	v_x = 90 * gib_dir_x + (random() * 70 - 35);
	v_y = 90 * gib_dir_y + (random() * 70 - 35);
	v_z = MAX_NAILS + MAX_SHELLS * random();
	if (dm > -50)
	{
		v = v * 0.9;
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

void(string gibname, float dm, vector dir) ThrowGib = 
{
	local entity new;
	local entity cube;
	new = spawn();
	new.origin = self.origin;
	setmodel(new, gibname);
	setsize(new, VEC_ORIGIN, VEC_ORIGIN);
	new.velocity = VelocityForDamage(dm, dir);
	new.movetype = MOVETYPE_BOUNCE;
	new.solid = SOLID_TRIGGER;
	new.avelocity_x = random() * 600;
	new.avelocity_y = random() * 600;
	new.avelocity_z = random() * 600;
	new.think = SUB_Remove;
	new.ltime = time;
	new.nextthink = time + MOVETYPE_BOUNCE + random() * MOVETYPE_BOUNCE;
	new.frame = 0;
	new.flags = 0;
};

void(string gibname, float dm, vector dir) ThrowHead = 
{
	setmodel(self, gibname);
	self.frame = 0;
	self.nextthink = CONTENT_EMPTY;
	self.think = SUB_Null;
	self.movetype = MOVETYPE_BOUNCE;
	self.takedamage = DAMAGE_NO;
	self.skin = 0;
	if (self.classname != "player")
	{
		self.solid = SOLID_TRIGGER;
	}
	else
	{
		self.solid = SOLID_NOT;
	}
	self.view_ofs = '0 0 8';
	setsize(self, '-16 -16 0', '16 16 56');
	self.velocity = VelocityForDamage(dm, dir);
	self.origin_z = self.origin_z - 24;
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	self.avelocity = crandom() * '0 600 0';
};

void() GibPlayer = 
{
	ThrowHead("progs/h_player.mdl", self.health, self.dest);
	ThrowGib("progs/gib1.mdl", self.health, self.dest);
	ThrowGib("progs/gib2.mdl", self.health, self.dest);
	ThrowGib("progs/gib3.mdl", self.health, self.dest);
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
	self.modelindex = modelindex_player;
	if (deathmatch || coop)
	{
		DropBackpack();
	}
	self.weaponmodel = string_null;
	self.view_ofs = '0 0 -8';
	self.deadflag = DEAD_DYING;
	self.lefty = time + 0.5;
	self.solid = SOLID_NOT;
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	self.movetype = MOVETYPE_TOSS;
	if (self.velocity_z < MOVETYPE_BOUNCE)
	{
		self.velocity_z = self.velocity_z + random() * 300;
	}
	sound(self, CHAN_WEAPON, "misc/null.wav", 1, ATTN_NORM);
	if (self.health < -40)
	{
		GibPlayer();
		return;
	}
	DeathSound();
	self.angles_x = 0;
	self.angles_z = 0;
	if (self.guninuse == GUN_AXE)
	{
		player_die_ax1();
		return;
	}
	if (self.guninuse == GUN_CHAINSAW)
	{
		player_die_sw1();
		return;
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
	self.frame = 86;
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_TOSS;
	self.deadflag = DEAD_DEAD;
	self.nextthink = CONTENT_EMPTY;
};

void() player_diea1 = [76, player_diea2]
{
};

void() player_diea2 = [77, player_diea3]
{
};

void() player_diea3 = [78, player_diea4]
{
};

void() player_diea4 = [79, player_diea5]
{
};

void() player_diea5 = [80, player_diea6]
{
};

void() player_diea6 = [81, player_diea7]
{
};

void() player_diea7 = [82, player_diea8]
{
};

void() player_diea8 = [83, player_diea9]
{
};

void() player_diea9 = [84, player_diea10]
{
};

void() player_diea10 = [85, player_diea11]
{
};

void() player_diea11 = [86, player_diea11]
{
	PlayerDead();
};

void() player_dieb1 = [87, player_dieb2]
{
};

void() player_dieb2 = [88, player_dieb3]
{
};

void() player_dieb3 = [89, player_dieb4]
{
};

void() player_dieb4 = [90, player_dieb5]
{
};

void() player_dieb5 = [91, player_dieb6]
{
};

void() player_dieb6 = [92, player_dieb7]
{
};

void() player_dieb7 = [93, player_dieb8]
{
};

void() player_dieb8 = [94, player_dieb9]
{
};

void() player_dieb9 = [95, player_dieb9]
{
	PlayerDead();
};

void() player_diec1 = [96, player_diec2]
{
};

void() player_diec2 = [97, player_diec3]
{
};

void() player_diec3 = [98, player_diec4]
{
};

void() player_diec4 = [99, player_diec5]
{
};

void() player_diec5 = [100, player_diec6]
{
};

void() player_diec6 = [101, player_diec7]
{
};

void() player_diec7 = [102, player_diec8]
{
};

void() player_diec8 = [103, player_diec9]
{
};

void() player_diec9 = [104, player_diec10]
{
};

void() player_diec10 = [105, player_diec11]
{
};

void() player_diec11 = [106, player_diec12]
{
};

void() player_diec12 = [107, player_diec13]
{
};

void() player_diec13 = [108, player_diec14]
{
};

void() player_diec14 = [109, player_diec15]
{
};

void() player_diec15 = [110, player_diec15]
{
	PlayerDead();
};

void() player_died1 = [111, player_died2]
{
};

void() player_died2 = [112, player_died3]
{
};

void() player_died3 = [113, player_died4]
{
};

void() player_died4 = [114, player_died5]
{
};

void() player_died5 = [115, player_died6]
{
};

void() player_died6 = [116, player_died7]
{
};

void() player_died7 = [117, player_died8]
{
};

void() player_died8 = [118, player_died9]
{
};

void() player_died9 = [119, player_died9]
{
	PlayerDead();
};

void() player_diee1 = [120, player_diee2]
{
};

void() player_diee2 = [121, player_diee3]
{
};

void() player_diee3 = [122, player_diee4]
{
};

void() player_diee4 = [123, player_diee5]
{
};

void() player_diee5 = [124, player_diee6]
{
};

void() player_diee6 = [125, player_diee7]
{
};

void() player_diee7 = [126, player_diee8]
{
};

void() player_diee8 = [127, player_diee9]
{
};

void() player_diee9 = [128, player_diee9]
{
	PlayerDead();
};

void() player_die_ax1 = [58, player_die_ax2]
{
};

void() player_die_ax2 = [59, player_die_ax3]
{
};

void() player_die_ax3 = [60, player_die_ax4]
{
};

void() player_die_ax4 = [61, player_die_ax5]
{
};

void() player_die_ax5 = [62, player_die_ax6]
{
};

void() player_die_ax6 = [63, player_die_ax7]
{
};

void() player_die_ax7 = [64, player_die_ax8]
{
};

void() player_die_ax8 = [65, player_die_ax9]
{
};

void() player_die_ax9 = [66, player_die_ax9]
{
	PlayerDead();
};

void() player_die_sw1 = [67, player_die_sw2]
{
};

void() player_die_sw2 = [68, player_die_sw3]
{
};

void() player_die_sw3 = [69, player_die_sw4]
{
};

void() player_die_sw4 = [70, player_die_sw5]
{
};

void() player_die_sw5 = [71, player_die_sw6]
{
};

void() player_die_sw6 = [72, player_die_sw7]
{
};

void() player_die_sw7 = [73, player_die_sw8]
{
};

void() player_die_sw8 = [74, player_die_sw9]
{
};

void() player_die_sw9 = [75, player_die_sw9]
{
	PlayerDead();
};


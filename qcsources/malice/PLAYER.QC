void () bubble_bob;
void () blooddrops;
void () wallsplat;
void () player_shot_lower1;

void () check_shot_idle =
{
	if (((self.weapon != IT_44) || (self.weaponmodel == "")))
	{
		self.weaponframe = 0;
		return;
	}
	if ((self.weaponframe == 21))
	{
		if ((self.tools != (self.tools | UT_MINISUB)))
			self.weaponmodel = "";
		self.weaponframe = 0;
		return;
	}
	if ((((self.count_shot_idle <= 0) && (self.tools != (self.tools | UT_BIGASSGUN))) && (self.weaponframe < 18)))
		self.weaponframe = 17;
	if (((self.count_shot_idle <= 0) && (self.tools != (self.tools | UT_BIGASSGUN))))
	{
		self.weaponframe = (self.weaponframe + 1);
		return;
	}
	if ((self.weaponframe != 0))
	{
		self.weaponframe = 0;
		return;
	}
	if ((self.count_shot_idle > 40))
		self.count_shot_idle = 40;
	if ((((self.count_shot_idle > 5) && self.velocity_x) && self.velocity_y))
		self.count_shot_idle = 5;
	self.count_shot_idle = (self.count_shot_idle - 1);
	return;
};

void () player_stand1 = [ 17, player_stand1 ]
{
	check_shot_idle ();
	if ((self.velocity_x || self.velocity_y))
	{
		self.walkframe = 0;
		if ((self.tools == (self.tools | UT_MINISUB)))
			sound (self, CHAN_BODY, "sub/throttle.wav", 1.00, ATTN_NORM);
		player_run ();
		return;
	}
	if ((self.tools == (self.tools | UT_MINISUB)))
		return;
	if ((self.walkframe >= 5))
		self.walkframe = 0;
	self.frame = (12 + self.walkframe);
	self.walkframe = (self.walkframe + 1);
};

void () player_run = [ 6, player_run ]
{
	check_shot_idle ();
	if ((!self.velocity_x && !self.velocity_y))
	{
		self.walkframe = 0;
		player_stand1 ();
		return;
	}
	if ((self.tools == (self.tools | UT_MINISUB)))
	{
		if ((self.walkframe == 3))
			self.walkframe = 0;
		self.frame = (0 + self.walkframe);
		self.walkframe = (self.walkframe + 1);
		return;
	}
	if ((self.walkframe == 6))
		self.walkframe = 0;
	self.frame = (self.frame + self.walkframe);
	self.walkframe = (self.walkframe + 1);
};

void () player_hellfire1 = [ 115, player_hellfire2 ]
{
	self.weaponframe = 19;
	self.effects = (self.effects | EF_MUZZLEFLASH);
};

void () player_hellfire2 = [ 116, player_hellfire3 ]
{
	self.weaponframe = 20;
};

void () player_hellfire3 = [ 117, player_hellfire4 ]
{
	self.weaponframe = 21;
};

void () player_hellfire4 = [ 118, player_hellfire5 ]
{
	self.weaponframe = 22;
};

void () player_hellfire5 = [ 119, player_hellfire6 ]
{
	self.weaponframe = 23;
};

void () player_hellfire6 = [ 120, player_hellfire7 ]
{
	self.weaponframe = 24;
};

void () player_hellfire7 = [ 6, player_hellfire8 ]
{
	self.weaponframe = 25;
};

void () player_hellfire8 = [ 7, player_hellfire9 ]
{
	self.weaponframe = 26;
};

void () player_hellfire9 = [ 8, player_run ]
{
	self.weaponframe = 27;
};

void () player_shot1 = [ 115, player_shot2 ]
{
	self.weaponframe = 1;
	self.effects = (self.effects | EF_MUZZLEFLASH);
};

void () player_shot2 = [ 116, player_shot3 ]
{
	self.weaponframe = 2;
};

void () player_shot3 = [ 117, player_shot4 ]
{
	self.weaponframe = 3;
};

void () player_shot4 = [ 118, player_shot5 ]
{
	self.weaponframe = 4;
};

void () player_shot5 = [ 119, player_run ]
{
	self.weaponframe = 5;
};

void () vulcan_slow1 = [ 6, vulcan_slow2 ]
{
	self.weaponframe = 9;
	sound (self, CHAN_WEAPON, "weapons/minidown.wav", 1.00, ATTN_NORM);
};

void () vulcan_slow2 = [ 7, vulcan_slow3 ]
{
	self.weaponframe = 10;
};

void () vulcan_slow3 = [ 8, vulcan_slow4 ]
{
	self.weaponframe = 11;
};

void () vulcan_slow4 = [ 9, vulcan_slow5 ]
{
	self.weaponframe = 12;
};

void () vulcan_slow5 = [ 10, vulcan_slow6 ]
{
	self.weaponframe = 13;
};

void () vulcan_slow6 = [ 11, vulcan_slow7 ]
{
	self.weaponframe = 14;
};

void () vulcan_slow7 = [ 6, vulcan_slow8 ]
{
	self.weaponframe = 15;
};

void () vulcan_slow8 = [ 7, vulcan_slow9 ]
{
	self.weaponframe = 16;
};

void () vulcan_slow9 = [ 8, vulcan_slow10 ]
{
	self.weaponframe = 17;
};

void () vulcan_slow10 = [ 9, vulcan_slow11 ]
{
	self.weaponframe = 18;
};

void () vulcan_slow11 = [ 10, vulcan_slow12 ]
{
	self.weaponframe = 19;
};

void () vulcan_slow12 = [ 11, player_run ]
{
	self.weaponframe = 0;
};

void () player_fbag1 = [ 103, player_fbag2 ]
{
	self.weaponframe = 30;
};

void () player_fbag2 = [ 104, player_fbag3 ]
{
	self.weaponframe = 31;
};

void () player_fbag3 = [ 105, player_fbag4 ]
{
	self.weaponframe = 32;
};

void () player_fbag4 = [ 106, player_fbag5 ]
{
	self.weaponframe = 33;
};

void () player_fbag5 = [ 107, player_fbag6 ]
{
	self.weaponframe = 34;
};

void () player_fbag6 = [ 108, player_run ]
{
	self.weaponframe = 35;
};

void () player_bag1 = [ 6, player_bag2 ]
{
	self.weaponframe = 1;
	Plasma_Charge ();
};

void () player_bag2 = [ 7, player_bag3 ]
{
	self.weaponframe = 2;
	Plasma_Charge ();
};

void () player_bag3 = [ 8, player_bag4 ]
{
	self.weaponframe = 3;
	Plasma_Charge ();
};

void () player_bag4 = [ 9, player_bag5 ]
{
	self.weaponframe = 4;
	Plasma_Charge ();
};

void () player_bag5 = [ 10, player_bag6 ]
{
	self.weaponframe = 5;
	Plasma_Charge ();
};

void () player_bag6 = [ 11, player_bag7 ]
{
	self.weaponframe = 6;
	Plasma_Charge ();
};

void () player_bag7 = [ 6, player_bag8 ]
{
	self.weaponframe = 7;
	Plasma_Charge ();
};

void () player_bag8 = [ 7, player_bag9 ]
{
	self.weaponframe = 8;
	Plasma_Charge ();
};

void () player_bag9 = [ 8, player_bag10 ]
{
	self.weaponframe = 9;
	Plasma_Charge ();
};

void () player_bag10 = [ 9, player_bag11 ]
{
	self.weaponframe = 20;
	Plasma_Charge ();
};

void () player_bag11 = [ 10, player_bag12 ]
{
	self.weaponframe = 21;
	Plasma_Charge ();
};

void () player_bag12 = [ 11, player_bag13 ]
{
	self.weaponframe = 22;
	Plasma_Charge ();
};

void () player_bag13 = [ 6, player_bag14 ]
{
	self.weaponframe = 23;
	Plasma_Charge ();
};

void () player_bag14 = [ 7, player_bag15 ]
{
	self.weaponframe = 24;
	Plasma_Charge ();
};

void () player_bag15 = [ 8, player_bag16 ]
{
	self.weaponframe = 25;
	Plasma_Charge ();
};

void () player_bag16 = [ 9, player_bag17 ]
{
	self.weaponframe = 26;
	Plasma_Charge ();
};

void () player_bag17 = [ 10, player_bag18 ]
{
	self.weaponframe = 27;
	Plasma_Charge ();
};

void () player_bag18 = [ 11, player_bag19 ]
{
	self.weaponframe = SVC_FOUNDSECRET;
	Plasma_Charge ();
};

void () player_bag19 = [ 6, player_bag10 ]
{
	self.weaponframe = 29;
	Plasma_Charge ();
};

void () player_shot_lower1 = [ 6, player_shot_lower2 ]
{
	self.weaponframe = 18;
};

void () player_shot_lower2 = [ 7, player_shot_lower3 ]
{
	self.weaponframe = 19;
};

void () player_shot_lower3 = [ 8, player_shot_lower4 ]
{
	self.weaponframe = 20;
};

void () player_shot_lower4 = [ 9, player_run ]
{
	self.weaponframe = 21;
};

void () player_rail1 = [ 115, player_rail2 ]
{
	self.weaponframe = 1;
	self.effects = (self.effects | EF_MUZZLEFLASH);
	self.barrel2 = TRUE;
};

void () player_rail2 = [ 116, player_rail3 ]
{
	self.weaponframe = 2;
};

void () player_rail3 = [ 117, player_rail4 ]
{
	self.weaponframe = 3;
};

void () player_rail4 = [ 118, player_run ]
{
	self.weaponframe = 4;
};

void () player_railb1 = [ 115, player_railb2 ]
{
	self.weaponframe = 5;
	self.effects = (self.effects | EF_MUZZLEFLASH);
	self.barrel2 = FALSE;
};

void () player_railb2 = [ 116, player_railb3 ]
{
	self.weaponframe = 6;
};

void () player_railb3 = [ 117, player_railb4 ]
{
	self.weaponframe = 7;
};

void () player_railb4 = [ 118, player_run ]
{
	self.weaponframe = 8;
};

void () player_blast1 = [ 115, player_blast2 ]
{
	self.weaponframe = 1;
	self.effects = (self.effects | EF_MUZZLEFLASH);
};

void () player_blast2 = [ 116, player_blast3 ]
{
	self.weaponframe = 2;
};

void () player_blast3 = [ 117, player_blast4 ]
{
	self.weaponframe = 3;
};

void () player_blast4 = [ 118, player_blast5 ]
{
	self.weaponframe = 4;
};

void () player_blast5 = [ 119, player_blast6 ]
{
	self.weaponframe = 5;
};

void () player_blast6 = [ 120, player_run ]
{
	self.weaponframe = 0;
};

void () player_dual1 = [ 115, player_dual2 ]
{
	self.weaponframe = 6;
	self.effects = (self.effects | EF_MUZZLEFLASH);
	if ((!self.button0 || (self.ammo_shells2 == 0)))
	{
		player_run ();
		return;
	}
};

void () player_dual2 = [ 116, player_dual3 ]
{
	self.weaponframe = 7;
	if ((!self.button0 || (self.ammo_shells2 == 0)))
	{
		player_run ();
		return;
	}
};

void () player_dual3 = [ 117, player_dual4 ]
{
	self.weaponframe = 8;
	W_FireSuperShotgun ();
	if ((!self.button0 || (self.ammo_shells2 == 0)))
	{
		player_run ();
		return;
	}
};

void () player_dual4 = [ 118, player_dual5 ]
{
	self.weaponframe = 9;
	if ((!self.button0 || (self.ammo_shells2 == 0)))
	{
		player_run ();
		return;
	}
};

void () player_dual5 = [ 119, player_dual6 ]
{
	self.weaponframe = 10;
	W_FireSuperShotgun ();
	if ((!self.button0 || (self.ammo_shells2 == 0)))
	{
		player_run ();
		return;
	}
};

void () player_dual6 = [ 120, player_run ]
{
	self.weaponframe = 11;
	if ((!self.button0 || (self.ammo_shells2 == 0)))
	{
		player_run ();
		return;
	}
};


void () Uzi_1 =
{
	UpdateAmmoBars ();
	if ((self.ammo_nails2 < 1))
	{
		self.weapon = IT_44;
		W_SetCurrentAmmo ();
		player_run ();
		return;
	}
	if (((self.count >= 32) && (self.weapon == IT_UZI)))
	{
		sprint (self, "Reload\n");
		sound (self, CHAN_AUTO, "weapons/misfire2.wav", 1.00, ATTN_NORM);
		self.weaponframe = 0;
		self.attack_finished = (time + 0.2);
		player_run ();
		return;
	}
	else
	{
		BlowShell ();
		self.count = (self.count + 1);
		self.weaponframe = (self.weaponframe + 1);
		self.effects = (self.effects | EF_MUZZLEFLASH);
		if (!self.button0)
		{
			if ((self.weapon == IT_MINI))
				vulcan_slow1 ();
			else
				player_run ();
			return;
		}
		if ((self.weaponframe >= 7))
			self.weaponframe = 1;
		if ((self.weapon == IT_UZI))
		{
			W_FireOozi ();
			self.attack_finished = (time + 0.2);
		}
		else
		{
			w_firemini ();
			self.attack_finished = (time + 0.04);
		}
	}
};

void () player_oozi1 = [ 109, player_oozi2 ]
{
	Uzi_1 ();
};

void () player_oozi2 = [ 110, player_oozi3 ]
{
	Uzi_1 ();
};

void () player_oozi3 = [ 111, player_oozi4 ]
{
	Uzi_1 ();
};

void () player_oozi4 = [ 112, player_oozi5 ]
{
	Uzi_1 ();
};

void () player_oozi5 = [ 113, player_oozi6 ]
{
	Uzi_1 ();
};

void () player_oozi6 = [ 114, player_oozi1 ]
{
	Uzi_1 ();
};

void () open_rocket1 = [ 121, open_rocket2 ]
{
	self.weaponframe = 12;
};

void () open_rocket2 = [ 122, open_rocket3 ]
{
	self.weaponframe = 13;
};

void () open_rocket3 = [ 123, open_rocket4 ]
{
	self.weaponframe = 14;
};

void () open_rocket4 = [ 124, open_rocket5 ]
{
	self.weaponframe = 6;
};

void () open_rocket5 = [ 125, open_rocket6 ]
{
	self.weaponframe = 7;
};

void () open_rocket6 = [ 126, open_rocket7 ]
{
	self.weaponframe = 8;
};

void () open_rocket7 = [ 6, open_rocket8 ]
{
	self.weaponframe = 9;
};

void () open_rocket8 = [ 7, open_rocket9 ]
{
	self.weaponframe = 10;
};

void () open_rocket9 = [ 8, player_run ]
{
	self.weaponframe = 11;
};

void () player_rocket1 = [ 103, player_rocket2 ]
{
	self.weaponframe = 5;
	sound (self, CHAN_WEAPON, "weapons/hellfire.wav", 1.00, ATTN_NORM);
	W_FireRocket ();
};

void () player_rocket2 = [ 104, player_rocket3 ]
{
	self.weaponframe = 6;
};

void () player_rocket3 = [ 8, player_rocket4 ]
{
	self.weaponframe = 7;
	sound (self, CHAN_AUTO, "weapons/loadrock.wav", 1.00, ATTN_NORM);
};

void () player_rocket4 = [ 9, player_rocket5 ]
{
	self.weaponframe = 8;
};

void () player_rocket5 = [ 10, player_rocket6 ]
{
	self.weaponframe = 9;
};

void () player_rocket6 = [ 11, player_rocket7 ]
{
	self.weaponframe = 10;
};

void () player_rocket7 = [ 6, player_run ]
{
	self.weaponframe = 11;
};

void () player_morter1 = [ 103, player_morter2 ]
{
	self.weaponframe = 1;
	self.effects = (self.effects | EF_MUZZLEFLASH);
};

void () player_morter2 = [ 104, player_morter3 ]
{
	self.weaponframe = 2;
};

void () player_morter3 = [ 105, player_morter4 ]
{
	self.weaponframe = 3;
};

void () player_morter4 = [ 106, player_morter5 ]
{
	self.weaponframe = 4;
};

void () player_morter5 = [ 107, player_morter6 ]
{
	self.weaponframe = 5;
};

void () player_morter6 = [ 108, player_run ]
{
	self.weaponframe = 6;
};


void () PainSound =
{
	local float rs;

	if ((self.health <= 0))
		return;
	if ((damage_attacker.classname == "teledeath"))
	{
		sound (self, CHAN_BODY, "player/teledth1.wav", 1.00, ATTN_NONE);
		return;
	}
	if ((self.tools == (self.tools | UT_MINISUB)))
	{
		sound (self, CHAN_BODY, "damage/subpain.wav", 1.00, ATTN_NORM);
		return;
	}
	if (((self.watertype == CONTENT_WATER) && (self.waterlevel == 3)))
	{
		if ((random () > 0.5))
			sound (self, CHAN_BODY, "player/drown1.wav", 1.00, ATTN_NORM);
		else
			sound (self, CHAN_BODY, "player/drown2.wav", 1.00, ATTN_NORM);
		return;
	}
	rs = rint (((random () * 10) + 1));
	self.noise = "";
	if ((rs == 1))
		self.noise = "damage/pain1.wav";
	else
	{
		if ((rs == 2))
			self.noise = "damage/pain2.wav";
		else
		{
			if ((rs == 3))
				self.noise = "damage/pain3.wav";
			else
			{
				if ((rs == 4))
					self.noise = "damage/pain4.wav";
				else
				{
					if ((rs == 5))
						self.noise = "damage/pain5.wav";
					else
					{
						if ((rs == 6))
							self.noise = "damage/pain6.wav";
						else
						{
							if ((rs == 7))
								self.noise = "damage/pain7.wav";
							else
							{
								if ((rs == 8))
									self.noise = "damage/pain8.wav";
								else
								{
									if ((rs == 9))
										self.noise = "damage/pain9.wav";
									else
										self.noise = "damage/pain10.wav";
								}
							}
						}
					}
				}
			}
		}
	}
	sound (self, CHAN_BODY, self.noise, 1.00, ATTN_NORM);
	return;
};

void () player_pain1 = [ 35, player_pain2 ]
{
	PainSound ();
	self.weaponframe = 0;
};

void () player_pain2 = [ 36, player_pain3 ]
{
};

void () player_pain3 = [ 37, player_pain4 ]
{
};

void () player_pain4 = [ 38, player_pain5 ]
{
};

void () player_pain5 = [ 39, player_pain6 ]
{
};

void () player_pain6 = [ 40, player_run ]
{
};

void () player_axpain1 = [ 29, player_axpain2 ]
{
	PainSound ();
	self.weaponframe = 0;
};

void () player_axpain2 = [ 30, player_axpain3 ]
{
};

void () player_axpain3 = [ 31, player_axpain4 ]
{
};

void () player_axpain4 = [ 32, player_axpain5 ]
{
};

void () player_axpain5 = [ 33, player_axpain6 ]
{
};

void () player_axpain6 = [ 34, player_run ]
{
};


void () player_pain =
{
	if (self.weaponframe)
		return;
	player_pain1 ();
	if ((!self.waterlevel && !self.burning))
		blooddrops ();
};

void () player_diea1;
void () player_dieb1;
void () player_diec1;
void () player_died1;
void () player_diee1;

void () DeathSound =
{
	local float rs;

	if ((self.waterlevel == 3))
	{
		sound (self, CHAN_VOICE, "player/h2odeath.wav", 1.00, ATTN_NONE);
		return;
	}
	rs = rint (((random () * 5) + 1));
	if ((rs == 1))
		self.noise = "damage/death1.wav";
	if ((rs == 2))
		self.noise = "damage/death2.wav";
	if ((rs == 3))
		self.noise = "damage/death3.wav";
	if ((rs == 4))
		self.noise = "damage/death4.wav";
	if ((rs == 5))
		self.noise = "damage/death5.wav";
	if ((rs == 6))
		self.noise = "damage/death6.wav";
	sound (self, CHAN_VOICE, self.noise, 1.00, ATTN_NONE);
	return;
};


void () PlayerDead =
{
	self.nextthink = -1.00;
	self.deadflag = DEAD_DEAD;
};

vector (float dm) VelocityForDamage =
{
	local vector v;

	v_x = (100 * crandom ());
	v_y = (100 * crandom ());
	v_z = (200 + (100 * random ()));
	if ((dm > -50))
		v = (v * 0.7);
	else
	{
		if ((dm > -200))
			v = (v * 2);
		else
			v = (v * 10);
	}
	return (v);
};


void (string gibname,float dm) ThrowGib =
{
	local entity new;

	new = spawn ();
	new.origin = self.origin;
	setmodel (new, gibname);
	setsize (new, VEC_ORIGIN, VEC_ORIGIN);
	new.velocity = VelocityForDamage (dm);
	new.movetype = MOVETYPE_BOUNCE;
	new.solid = SOLID_NOT;
	new.avelocity_x = (random () * 600);
	new.avelocity_y = (random () * 600);
	new.avelocity_z = (random () * 600);
	new.think = SUB_Remove;
	new.ltime = time;
	new.nextthink = ((time + 10.00) + (random () * 10));
	new.frame = 0;
	new.flags = 0;
};


void (string gibname,float dm) ThrowHead =
{
	setmodel (self, gibname);
	self.frame = 0;
	self.nextthink = -1.00;
	self.movetype = MOVETYPE_BOUNCE;
	self.takedamage = DAMAGE_NO;
	self.solid = SOLID_NOT;
	self.view_ofs = '0 0 8';
	setsize (self, '-16 -16 0', '16 16 56');
	self.velocity = VelocityForDamage (dm);
	self.origin_z = (self.origin_z - 24);
	self.flags = (self.flags - (self.flags & FL_ONGROUND));
	self.avelocity = (crandom () * '0 600 0');
};


void () GibPlayer =
{
	ThrowHead ("progs/h_player.mdl", self.health);
	ThrowGib ("progs/gib1.mdl", self.health);
	ThrowGib ("progs/gib2.mdl", self.health);
	ThrowGib ("progs/gib3.mdl", self.health);
	self.deadflag = DEAD_DEAD;
	if ((damage_attacker.classname == "teledeath"))
	{
		sound (self, CHAN_VOICE, "player/teledth1.wav", 1.00, ATTN_NONE);
		return;
	}
	if ((damage_attacker.classname == "teledeath2"))
	{
		sound (self, CHAN_VOICE, "player/teledth1.wav", 1.00, ATTN_NONE);
		return;
	}
	if ((random () < 0.5))
		sound (self, CHAN_VOICE, "player/gib.wav", 1.00, ATTN_NONE);
	else
		sound (self, CHAN_VOICE, "player/udeath.wav", 1.00, ATTN_NONE);
};


void () PlayerDie =
{
	local entity body;
	local float i;

	if ((self.tools == (self.tools | UT_BIGASSGUN)))
	{
		serverflags = 0;
		body = find (world, netname, "Atom Smasher");
		if (((body != world) && deathmatch))
		{
			body.think = SUB_regen;
			body.nextthink = (time + 60);
		}
	}
	NormalVars ();
	if ((self.tools == (self.tools | UT_MINISUB)))
		exit_vehicle ();
	stuffcmd (self, "cl_forwardspeed 360\n");
	self.cl_forwardspeed = CHT_NORMSPEED;
	self.tools = 0;
	self.util = 0;
	self.items = (self.items - (self.items & ((IT_ARMOR1 | IT_ARMOR2) | IT_ARMOR3)));
	if ((deathmatch || coop))
		DropBackpack ();
	self.weaponmodel = "";
	self.view_ofs = '0 0 -8';
	self.deadflag = DEAD_DYING;
	self.solid = SOLID_NOT;
	self.flags = (self.flags - (self.flags & FL_ONGROUND));
	self.movetype = MOVETYPE_TOSS;
	if ((self.velocity_z < 10))
		self.velocity_z = (self.velocity_z + (random () * 300));
	if (((self.health < -20) && !self.waterlevel))
		wallsplat ();
	if ((self.health < -40))
	{
		GibPlayer ();
		return;
	}
	DeathSound ();
	self.angles_x = 0;
	self.angles_z = 0;
	i = (1 + floor ((random () * 6)));
	if ((i == 1))
		player_diea1 ();
	else
	{
		if ((i == 2))
			player_dieb1 ();
		else
		{
			if ((i == 3))
				player_diec1 ();
			else
			{
				if ((i == 4))
					player_died1 ();
				else
					player_diee1 ();
			}
		}
	}
};


void () set_suicide_frame =
{
	self.frame = 60;
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_TOSS;
	self.deadflag = DEAD_DEAD;
	self.nextthink = -1.00;
};

void () player_diea1 = [ 50, player_diea2 ]
{
};

void () player_diea2 = [ 51, player_diea3 ]
{
};

void () player_diea3 = [ 52, player_diea4 ]
{
};

void () player_diea4 = [ 53, player_diea5 ]
{
};

void () player_diea5 = [ 54, player_diea6 ]
{
};

void () player_diea6 = [ 55, player_diea7 ]
{
};

void () player_diea7 = [ 56, player_diea8 ]
{
};

void () player_diea8 = [ 57, player_diea9 ]
{
};

void () player_diea9 = [ 58, player_diea10 ]
{
};

void () player_diea10 = [ 59, player_diea11 ]
{
};

void () player_diea11 = [ 60, player_diea11 ]
{
	PlayerDead ();
};

void () player_dieb1 = [ 61, player_dieb2 ]
{
};

void () player_dieb2 = [ 62, player_dieb3 ]
{
};

void () player_dieb3 = [ 63, player_dieb4 ]
{
};

void () player_dieb4 = [ 64, player_dieb5 ]
{
};

void () player_dieb5 = [ 65, player_dieb6 ]
{
};

void () player_dieb6 = [ 66, player_dieb7 ]
{
};

void () player_dieb7 = [ 67, player_dieb8 ]
{
};

void () player_dieb8 = [ 68, player_dieb9 ]
{
};

void () player_dieb9 = [ 69, player_dieb9 ]
{
	PlayerDead ();
};

void () player_diec1 = [ 70, player_diec2 ]
{
};

void () player_diec2 = [ 71, player_diec3 ]
{
};

void () player_diec3 = [ 72, player_diec4 ]
{
};

void () player_diec4 = [ 73, player_diec5 ]
{
};

void () player_diec5 = [ 74, player_diec6 ]
{
};

void () player_diec6 = [ 75, player_diec7 ]
{
};

void () player_diec7 = [ 76, player_diec8 ]
{
};

void () player_diec8 = [ 77, player_diec9 ]
{
};

void () player_diec9 = [ 78, player_diec10 ]
{
};

void () player_diec10 = [ 79, player_diec11 ]
{
};

void () player_diec11 = [ 80, player_diec12 ]
{
};

void () player_diec12 = [ 81, player_diec13 ]
{
};

void () player_diec13 = [ 82, player_diec14 ]
{
};

void () player_diec14 = [ 83, player_diec15 ]
{
};

void () player_diec15 = [ 84, player_diec15 ]
{
	PlayerDead ();
};

void () player_died1 = [ 85, player_died2 ]
{
};

void () player_died2 = [ 86, player_died3 ]
{
};

void () player_died3 = [ 87, player_died4 ]
{
};

void () player_died4 = [ 88, player_died5 ]
{
};

void () player_died5 = [ 89, player_died6 ]
{
};

void () player_died6 = [ 90, player_died7 ]
{
};

void () player_died7 = [ 91, player_died8 ]
{
};

void () player_died8 = [ 92, player_died9 ]
{
};

void () player_died9 = [ 93, player_died9 ]
{
	PlayerDead ();
};

void () player_diee1 = [ 94, player_diee2 ]
{
};

void () player_diee2 = [ 95, player_diee3 ]
{
};

void () player_diee3 = [ 96, player_diee4 ]
{
};

void () player_diee4 = [ 97, player_diee5 ]
{
};

void () player_diee5 = [ 98, player_diee6 ]
{
};

void () player_diee6 = [ 99, player_diee7 ]
{
};

void () player_diee7 = [ 100, player_diee8 ]
{
};

void () player_diee8 = [ 101, player_diee9 ]
{
};

void () player_diee9 = [ 102, player_diee9 ]
{
	PlayerDead ();
};


void () FallScream =
{
	if (((self.hover_active != TRUE) && (self.chute_active != TRUE)))
	{
		if ((random () < 0.5))
			sound (self, CHAN_VOICE, "damage/fall1.wav", 1.00, ATTN_NORM);
		else
			sound (self, CHAN_VOICE, "damage/fall2.wav", 1.00, ATTN_NORM);
	}
};


void () velo =
{
	if ((self.velocity_z > -300))
		player_run ();
};

void () Panic1 = [ 133, Panic2 ]
{
};

void () Panic2 = [ 134, Panic3 ]
{
	velo ();
};

void () Panic3 = [ 135, Panic4 ]
{
};

void () Panic4 = [ 136, Panic5 ]
{
	velo ();
};

void () Panic5 = [ 137, Panic6 ]
{
};

void () Panic6 = [ 138, Panic7 ]
{
	velo ();
};

void () Panic7 = [ 139, Panic8 ]
{
};

void () Panic8 = [ 140, Panic9 ]
{
	velo ();
};

void () Panic9 = [ 141, Panic10 ]
{
};

void () Panic10 = [ 142, Panic11 ]
{
	velo ();
	FallScream ();
};

void () Panic11 = [ 143, Panic12 ]
{
};

void () Panic12 = [ 144, Panic13 ]
{
	velo ();
};

void () Panic13 = [ 149, Panic14 ]
{
};

void () Panic14 = [ 150, Panic15 ]
{
	velo ();
};

void () Panic15 = [ 151, Panic16 ]
{
};

void () Panic16 = [ 152, Panic17 ]
{
	velo ();
};

void () Panic17 = [ 153, Panic18 ]
{
};

void () Panic18 = [ 154, Panic19 ]
{
	velo ();
};

void () Panic19 = [ 155, Panic20 ]
{
};

void () Panic20 = [ 156, Panic21 ]
{
	velo ();
};

void () Panic21 = [ 157, Panic19 ]
{
};

void () Land1 = [ 145, Land2 ]
{
};

void () Land2 = [ 146, Land3 ]
{
};

void () Land3 = [ 147, Land4 ]
{
};

void () Land4 = [ 148, player_run ]
{
};

void () JumpFrame1 = [ 127, JumpFrame2 ]
{
};

void () JumpFrame2 = [ 128, JumpFrame3 ]
{
};

void () JumpFrame3 = [ 129, JumpFrame4 ]
{
};

void () JumpFrame4 = [ 130, JumpFrame4 ]
{
	if ((self.flags & FL_ONGROUND))
		player_run ();
};


void () Plasma_Charge =
{
	local float x;

	x = random ();
	if ((self.button0 == 1))
	{
		if ((self.atomic_intensity >= (x + 0.6)))
			sound (self, CHAN_WEAPON, "misc/warning.wav", 1.00, ATTN_NORM);
		if ((self.atomic_intensity >= (x + 0.8)))
		{
			OverLoad ();
			return;
		}
		else
			self.atomic_intensity = (self.atomic_intensity + 0.04);
		self.attack_finished = (time + 0.2);
	}
	else
	{
		W_FireBigassGun (self.atomic_intensity);
		player_fbag1 ();
		self.attack_finished = (time + 1.00);
		return;
	}
};

void () loadwep = [ 121, loadwep2 ]
{
	self.weaponframe = (self.weaponframe + 1);
};

void () loadwep2 = [ 122, loadwep3 ]
{
	self.weaponframe = (self.weaponframe + 1);
};

void () loadwep3 = [ 123, loadwep4 ]
{
	self.weaponframe = (self.weaponframe + 1);
};

void () loadwep4 = [ 124, loadwep5 ]
{
	self.weaponframe = (self.weaponframe + 1);
};

void () loadwep5 = [ 125, loadwep6 ]
{
	self.weaponframe = (self.weaponframe + 1);
	if ((self.weapon == IT_MORTER))
		player_run ();
};

void () loadwep6 = [ 126, loadwep7 ]
{
	self.weaponframe = (self.weaponframe + 1);
};

void () loadwep7 = [ 6, loadwep8 ]
{
	self.weaponframe = (self.weaponframe + 1);
	if ((self.weapon == IT_UZI))
		player_run ();
};

void () loadwep8 = [ 7, loadwep9 ]
{
	self.weaponframe = (self.weaponframe + 1);
};

void () loadwep9 = [ 8, loadwep10 ]
{
	self.weaponframe = (self.weaponframe + 1);
	if (((self.weapon == IT_44) || (self.weapon == IT_SHOT2)))
		player_run ();
};

void () loadwep10 = [ 9, loadwep11 ]
{
	self.weaponframe = (self.weaponframe + 1);
	if ((self.weapon == IT_SHOT))
		player_run ();
};

void () loadwep11 = [ 10, loadwep12 ]
{
	self.weaponframe = (self.weaponframe + 1);
};

void () loadwep12 = [ 11, player_run ]
{
	self.weaponframe = (self.weaponframe + 1);
};


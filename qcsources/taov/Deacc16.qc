void() player_spawn = 
{
};

void() Setup_Dummy = 
{
	local entity dummy;
	local entity spoint;
	local float f;
	f = cvar("gamecfg");
	dummy = spawn();
	spoint = find(world, classname, "player_spawn");
	while (spoint)
	{
		if (spoint.cnt == f)
		{
			setorigin(dummy, spoint.origin);
		}
		spoint = find(spoint, classname, "player_spawn");
	}
	setmodel(dummy, "progs/plyr.mdl");
	setsize(dummy, VEC_HULL_MIN, VEC_HULL_MAX);
	dummy.solid = SOLID_TRIGGER;
	dummy.owner = self;
	if (deathmatch == 0)
	{
		dummy.health = decode(parm1, PLAT_LOW_TRIGGER);
		dummy.max_health = 70 + TE_LAVASPLASH * (self.level / IT_RELIC2);
		dummy.max_mana = 47 + TE_LAVASPLASH * (self.level / AS_MELEE);
	}
	else
	{
		dummy.max_health = 100;
		dummy.health = 100;
		dummy.max_mana = 100;
	}
	if (dummy.health > dummy.max_health)
	{
		dummy.health = dummy.max_health;
	}
	dummy.takedamage = DAMAGE_AIM;
	dummy.classname = "player";
	dummy.netname = "solid";
	dummy.speed = 75;
	dummy.movetype = MOVETYPE_STEP;
	if (dummy.angles_y != STATE_TOP || dummy.angles_y != 180)
	{
		dummy.angles_y = 180;
	}
	dummy.fixangle = 1;
	dummy.colormap = self.colormap;
	self.char = dummy;
	dummy.think = player_move;
	dummy.nextthink = time;
	dummy.th_pain = player_pain;
	dummy.th_grab = player_grab1;
	dummy.th_die = player_die;
	dummy.th_stand = player_move;
	self.currentammo = self.ammo_shells;
	self.items = self.items | FL_ITEM;
	relics = relics | IT_RELIC1 | IT_RELIC2 | IT_RELIC3 | IT_RELIC4 | IT_RELIC5;
	self.telecam = 1;
};

void() speedline_think = 
{
	local vector view;
	makevectors(self.angles);
	view = vectoangles(self.owner.origin - self.origin);
	if (self.owner.velocity_z == STATE_TOP && view_x == 270 && self.owner.onground == 1)
	{
		view_x = STATE_TOP;
	}
	if (self.owner.frame == 91 || self.owner.frame == 92 && view_x == STATE_TOP)
	{
		view_x = 270;
	}
	if (self.owner.angles_y == STATE_TOP)
	{
		self.angles_z = view_x;
	}
	else
	{
		self.angles_z = view_x * CONTENT_EMPTY;
	}
	if (self.attack_finished < time)
	{
		if (random() < 0.5)
		{
			if (self.frame < IT_RELIC2)
			{
				self.frame = self.frame + PLAT_LOW_TRIGGER;
			}
			else
			{
				self.frame = STATE_TOP;
			}
		}
		else
		{
			self.frame = random() * AS_MELEE;
		}
		self.attack_finished = time + 0.05;
	}
	if (self.alpha > STATE_TOP)
	{
		self.alpha = self.alpha - 0.010000;
	}
	else
	{
		remove(self);
		return;
	}
	frameskip(0.010000);
};

void() SpeedLine = 
{
	local entity speedl;
	if (self.nextspeed_time > time)
	{
		return;
	}
	makevectors(self.char.angles);
	speedl = spawn();
	speedl.owner = self.char;
	speedl.classname = "speedline";
	speedl.movetype = MOVETYPE_NOCLIP;
	speedl.solid = SOLID_NOT;
	speedl.alpha = 0.5;
	speedl.angles_y = -90;
	setmodel(speedl, "progs/speed.spr");
	setorigin(speedl, self.char.origin);
	speedl.frame = random() * AS_MELEE;
	speedl.think = speedline_think;
	speedl.nextthink = time + 0.010000;
	self.nextspeed_time = time + 0.15;
};

void() shadows_think = 
{
	if (self.alpha > 0.1)
	{
		self.alpha = self.alpha - 0.1;
	}
	else
	{
		remove(self);
		return;
	}
	frameskip(0.040000);
};

void() Shadows = 
{
	local entity shadows;
	if (self.nextshadow_time > time)
	{
		return;
	}
	shadows = spawn();
	shadows.owner = self.char;
	shadows.classname = "shadows";
	shadows.movetype = MOVETYPE_NOCLIP;
	shadows.solid = SOLID_NOT;
	shadows.skin = PLAT_LOW_TRIGGER;
	shadows.alpha = PLAT_LOW_TRIGGER;
	shadows.effects = EF_ADDITIVE;
	setmodel(shadows, "progs/plyr.mdl");
	shadows.frame = self.char.frame;
	shadows.angles = self.char.angles;
	setorigin(shadows, self.char.origin);
	shadows.think = shadows_think;
	shadows.nextthink = time + 0.040000;
	self.nextshadow_time = time + 0.1;
};

void() SoftShadows = 
{
	local entity shadows;
	if (self.nextshadow_time > time)
	{
		return;
	}
	shadows = spawn();
	shadows.owner = self.char;
	shadows.classname = "shadows";
	shadows.movetype = MOVETYPE_NOCLIP;
	shadows.solid = SOLID_NOT;
	shadows.effects = EF_ADDITIVE;
	shadows.alpha = 0.5;
	shadows.skin = self.owner.skin;
	setmodel(shadows, "progs/plyr.mdl");
	shadows.frame = self.char.frame;
	shadows.angles = self.char.angles;
	setorigin(shadows, self.char.origin);
	shadows.colormap = self.char.owner.colormap;
	shadows.think = shadows_think;
	shadows.nextthink = time + 0.040000;
	self.nextshadow_time = time + 0.1;
};

void() SwordShadows = 
{
	local entity shadows;
	if (self.nextshadow_time > time)
	{
		return;
	}
	shadows = spawn();
	shadows.owner = self;
	shadows.classname = "shadows";
	shadows.movetype = MOVETYPE_NOCLIP;
	shadows.solid = SOLID_NOT;
	shadows.alpha = 0.1;
	if (darkplaces)
	{
		shadows.effects = EF_ADDITIVE;
	}
	setmodel(shadows, "progs/swordfx.mdl");
	shadows.frame = self.char.frame;
	shadows.angles = self.char.angles;
	setorigin(shadows, self.char.origin);
	shadows.think = SUB_Remove;
	shadows.nextthink = time + 0.15;
	self.nextshadow_time = time + 0.080000;
};

void() LegShadowThink = 
{
	if (self.attack_finished < time)
	{
		if (self.frame < IT_RELIC3)
		{
			self.frame = self.frame + PLAT_LOW_TRIGGER;
			if (self.alpha > 0.010000)
			{
				self.alpha = self.alpha - 0.010000;
			}
		}
		else
		{
			remove(self);
			return;
		}
		self.attack_finished = time + 0.1;
	}
	setorigin(self, self.owner.origin);
	frameskip(0.010000);
};

void() LegShadow = 
{
	local entity shadows;
	shadows = spawn();
	shadows.owner = self;
	shadows.classname = "shadows";
	shadows.movetype = MOVETYPE_NOCLIP;
	shadows.solid = SOLID_NOT;
	shadows.alpha = 0.2;
	setmodel(shadows, "progs/shdowleg.mdl");
	if (darkplaces)
	{
		shadows.effects = EF_ADDITIVE;
	}
	shadows.angles = self.angles;
	setorigin(shadows, self.origin);
	shadows.think = LegShadowThink;
	shadows.nextthink = time + 0.1;
	self.nextshadow_time = time + 0.080000;
};

void() ComboMeter = 
{
	local string h;
	if (cvar("scratch2") == PLAT_LOW_TRIGGER)
	{
		return;
	}
	if (self.char.scorecalc == 1)
	{
		return;
	}
	if (self.combometer_finished < time)
	{
		if (self.combocompare3 != self.combocompare2)
		{
			if (self.combostep == 1)
			{
				if (deathmatch == 0)
				{
					self.combocompare3 = combo;
				}
				else
				{
					self.combocompare3 = self.dm_combo;
				}
				self.combostep = 0;
				self.combometer_finished = time + PLAT_LOW_TRIGGER;
			}
		}
		if (self.combocompare2 != self.combocompare1)
		{
			if (self.combostep == 0)
			{
				self.combostep = 1;
				if (deathmatch == 0)
				{
					self.combocompare2 = combo;
				}
				else
				{
					self.combocompare2 = self.dm_combo;
				}
				self.combometer_finished = time + PLAT_LOW_TRIGGER;
			}
		}
		if (deathmatch == 0)
		{
			self.combocompare1 = combo;
		}
		else
		{
			self.combocompare1 = self.dm_combo;
		}
		if (self.combocompare1 > STATE_TOP && self.combocompare1 == self.combocompare2 && self.combocompare2 == self.combocompare3)
		{
			if (deathmatch == 0)
			{
				if (combo > AS_MELEE && combo < TE_WIZSPIKE)
				{
					centerprint(self, "                     Not bad!");
				}
				else
				{
					if (combo > TE_WIZSPIKE && combo < TE_LAVASPLASH)
					{
						centerprint(self, "                     Nicely done!");
					}
					else
					{
						if (combo > TE_LIGHTNING3 && combo < SVC_CLIENTDATA)
						{
							centerprint(self, "                     Great strikes!");
						}
						else
						{
							if (combo > SVC_UPDATEFRAGS && combo < SVC_SPAWNSTATIC)
							{
								centerprint(self, "                     Amazing display!");
							}
							else
							{
								if (combo > SVC_DAMAGE && combo < SVC_INTERMISSION)
								{
									centerprint(self, "                     Spectacular effort!");
								}
								else
								{
									if (combo > SVC_SPAWNSTATICSOUND && combo < 50)
									{
										centerprint(self, "                     Unstoppable skills!");
									}
									else
									{
										if (combo > 49 && combo < 75)
										{
											centerprint(self, "                     Legendary force!");
										}
										else
										{
											if (combo > 74 && combo < 99)
											{
												centerprint(self, "                     Fearsome talents!");
											}
											else
											{
												if (combo > 98)
												{
													centerprint(self, "                     God-like warrior!");
												}
												else
												{
													centerprint(self, "");
												}
											}
										}
									}
								}
							}
						}
					}
				}
				self.score = self.score + combo * TE_LIGHTNING2;
				self.combocompare3 = STATE_TOP;
				self.combocompare2 = STATE_TOP;
				self.combocompare1 = STATE_TOP;
				self.combostep = STATE_TOP;
				combo = STATE_TOP;
			}
			else
			{
				if (self.dm_combo > AS_MELEE && self.dm_combo < TE_WIZSPIKE)
				{
					centerprint(self, "                     Try harder!");
				}
				else
				{
					if (self.dm_combo > TE_WIZSPIKE && self.dm_combo < TE_LAVASPLASH)
					{
						centerprint(self, "                     Skillful!");
					}
					else
					{
						if (self.dm_combo > TE_LIGHTNING3 && self.dm_combo < SVC_CLIENTDATA)
						{
							centerprint(self, "                     You showed them!");
						}
						else
						{
							if (self.dm_combo > SVC_UPDATEFRAGS && self.dm_combo < SVC_SPAWNSTATIC)
							{
								centerprint(self, "                     Victory is yours!");
							}
							else
							{
								if (self.dm_combo > SVC_DAMAGE && self.dm_combo < SVC_INTERMISSION)
								{
									centerprint(self, "                     Keep it up, sir!");
								}
								else
								{
									if (self.dm_combo > SVC_SPAWNSTATICSOUND && self.dm_combo < 50)
									{
										centerprint(self, "                     Nobody can stop you!");
									}
									else
									{
										if (self.dm_combo > 49 && self.dm_combo < 75)
										{
											centerprint(self, "                     Force of legends!");
										}
										else
										{
											if (self.dm_combo > 74 && self.dm_combo < 99)
											{
												centerprint(self, "                     Simply fearsome!");
											}
											else
											{
												if (self.dm_combo > 98)
												{
													centerprint(self, "                     God amongst others!");
												}
												else
												{
													centerprint(self, "");
												}
											}
										}
									}
								}
							}
						}
					}
				}
				self.score = self.score + self.dm_combo * TE_LIGHTNING2;
				self.combocompare3 = STATE_TOP;
				self.combocompare2 = STATE_TOP;
				self.combocompare1 = STATE_TOP;
				self.combostep = STATE_TOP;
				self.dm_combo = STATE_TOP;
			}
		}
		self.combometer_finished = time + PLAT_LOW_TRIGGER;
	}
	if (deathmatch == 0)
	{
		if (combo > PLAT_LOW_TRIGGER)
		{
			h = ftos(combo);
			centerprint3(self, "                     ", h, " Strikes");
		}
	}
	else
	{
		if (self.dm_combo > PLAT_LOW_TRIGGER)
		{
			h = ftos(self.dm_combo);
			centerprint3(self, "                     ", h, " Strikes");
		}
	}
};

void() invunerable_field_think = 
{
	if (self.owner.invunerability_finished < time)
	{
		remove(self);
		return;
	}
	setorigin(self, self.owner.origin);
	frameskip(0.010000);
};

void() invunerable_field = 
{
	local entity h;
	h = spawn();
	h.owner = self;
	h.movetype = MOVETYPE_NONE;
	h.solid = SOLID_NOT;
	h.effects = EF_BRIGHTFIELD;
	setmodel(h, "progs/null.spr");
	sound(h, CHAN_AUTO, "player/invun.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	h.think = invunerable_field_think;
	h.nextthink = time;
};

void() Respawn_Dummy = 
{
	self.attack_finished = time + TE_LAVASPLASH;
	self.flypain = 1;
	self.movetype = MOVETYPE_STEP;
	self.owner.armorvalue = self.owner.armorvalue - PLAT_LOW_TRIGGER;
	self.angles_x = STATE_TOP;
	if (self.pitdeath == 0)
	{
		self.think = player_fflip1;
	}
	else
	{
		self.think = player_getup1;
	}
	invunerable_field();
	self.invunerability_finished = time + TE_LIGHTNING1;
	self.nextthink = time + 0.1;
};

void() SpellBubbleThink = 
{
	if (self.owner.currentspell == SPELL_FIREBALL)
	{
		if (self.frame != STATE_TOP)
		{
			self.frame = STATE_TOP;
		}
	}
	else
	{
		if (self.owner.currentspell == SPELL_LIGHTNING)
		{
			if (self.frame != PLAT_LOW_TRIGGER)
			{
				self.frame = PLAT_LOW_TRIGGER;
			}
		}
		else
		{
			if (self.owner.currentspell == SPELL_ICE)
			{
				if (self.frame != IT_RELIC2)
				{
					self.frame = IT_RELIC2;
				}
			}
			else
			{
				if (self.owner.currentspell == SPELL_BEAM)
				{
					if (self.frame != AS_MELEE)
					{
						self.frame = AS_MELEE;
					}
				}
				else
				{
					if (self.owner.currentspell == SPELL_TWISTER)
					{
						if (self.frame != IT_RELIC3)
						{
							self.frame = IT_RELIC3;
						}
					}
				}
			}
		}
	}
	if (self.owner.magicmenu == 0)
	{
		self.owner.bubbleshow = 0;
		remove(self);
		return;
	}
	self.nextthink = time + 0.010000;
};

void() SpellBubble = 
{
	local entity mg;
	makevectors(self.char.angles);
	mg = spawn();
	mg.owner = self;
	mg.classname = "spellbubble";
	mg.movetype = MOVETYPE_NONE;
	if (darkplaces)
	{
		mg.effects = EF_NODEPTHTEST;
	}
	mg.solid = SOLID_NOT;
	mg.drawonlytoclient = self.char.owner;
	setmodel(mg, "progs/spells.spr");
	setsize(mg, VEC_ORIGIN, VEC_ORIGIN);
	if (mg.owner.currentspell == SPELL_FIREBALL)
	{
		mg.frame = STATE_TOP;
		sprint(mg.owner, "Fireball Selected\n");
	}
	else
	{
		if (mg.owner.currentspell == SPELL_LIGHTNING)
		{
			mg.frame = PLAT_LOW_TRIGGER;
			sprint(mg.owner, "Lightning Storm Selected\n");
		}
		else
		{
			if (mg.owner.currentspell == SPELL_ICE)
			{
				mg.frame = IT_RELIC2;
				sprint(mg.owner, "Ice Field Selected\n");
			}
			else
			{
				if (mg.owner.currentspell == SPELL_BEAM)
				{
					mg.frame = AS_MELEE;
					sprint(mg.owner, "Fire Beam Selected\n");
				}
				else
				{
					if (mg.owner.currentspell == SPELL_TWISTER)
					{
						mg.frame = IT_RELIC3;
						sprint(mg.owner, "Twister Selected\n");
					}
				}
			}
		}
	}
	if (self.char.angles_y == STATE_TOP)
	{
		setorigin(mg, mg.owner.char.origin + v_up * 60 + v_forward * TE_LAVASPLASH);
	}
	else
	{
		setorigin(mg, mg.owner.char.origin + v_up * 60 - v_forward * TE_LAVASPLASH);
	}
	mg.think = SpellBubbleThink;
	mg.nextthink = time + 0.1;
};

void() player_checkledge = 
{
	local float ledgegrab_ok;
	local entity oself;
	local entity grab;
	local vector source;
	makevectors(self.char.angles);
	source = self.char.origin;
	traceline(source, source + v_forward * SVC_SPAWNSTATIC + v_up * 75, 0, self);
	grab = spawn();
	grab.owner = self.char;
	grab.movetype = MOVETYPE_FLY;
	grab.solid = SOLID_NOT;
	grab.classname = "ledgegrab";
	grab.origin_x = trace_endpos_x;
	grab.origin_y = trace_endpos_y;
	grab.origin_z = trace_endpos_z;
	setmodel(grab, string_null);
	setsize(grab, VEC_ORIGIN, VEC_ORIGIN);
	grab.origin_y = self.char.origin_y;
	oself = self;
	self = grab;
	droptofloor();
	if (walkmove(STATE_TOP, STATE_TOP))
	{
		if (self.origin_z > self.owner.origin_z + SVC_INTERMISSION && self.origin_z < self.owner.origin_z + 45)
		{
			ledgegrab_ok = 1;
		}
	}
	else
	{
		ledgegrab_ok = 0;
	}
	self = oself;
	if (ledgegrab_ok == 1)
	{
		if (self.wallrun == 1)
		{
			self.wallrun = 0;
		}
		self.wallgrab = 0;
		self.char.djump_spincnt = IT_RELIC3;
		self.ledgegrab = 1;
		self.doublejump = 1;
		self.char.running = 0;
		self.char.velocity = VEC_ORIGIN;
		self.char.movetype = MOVETYPE_NONE;
		self.char.attack_finished = time + 0.5;
		self.char.angles_x = STATE_TOP;
		self.softshadow_time = time;
		self.char.think = player_ledgegrab1;
		self.char.nextthink = time;
		sound(self, CHAN_WEAPON, "player/ledge.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
		self.camloose = STATE_TOP;
	}
	if (grab != world)
	{
		remove(grab);
	}
	return;
};

void() player_think = 
{
	local entity oself;
	local entity oldself;
	local vector source;
	local float ct;
	if (self.char.flags & FL_ONGROUND)
	{
		self.doublejump = 1;
		self.char.onground = 1;
	}
	else
	{
		self.char.onground = 0;
	}
	if (self.keyflags & (KEY_LEFT | KEY_RIGHT) && self.char.pain_finished < time && self.char.block_finished < time && self.attack_finished < time && self.magicmenu == 0 && self.char.tired_finished < time && self.char.deadflag != DEAD_DEAD && self.char.grabbed == 0 && self.combo_finished < time && self.char.guardbreak_finished < time)
	{
		oldself = self;
		self = self.char;
		while (!walkmove(self.angles_y, self.speed * frametime) && runaway < 100)
		{
			runaway = runaway + PLAT_LOW_TRIGGER;
		}
		self = oldself;
	}
	if (self.char.frame >= SVC_UPDATECOLORS && self.char.frame <= SVC_FOUNDSECRET && self.char.grabbed == 0)
	{
		oself = self;
		self = self.char;
		player_grab();
		self = oself;
	}
	if (self.forcewalk_finished > time && self.char.onground == 1)
	{
		oldself = self;
		self = self.char;
		walkmove(self.angles_y, self.speed * frametime);
		self.flags = self.flags - FL_ONGROUND;
		makevectors(self.angles);
		self.velocity = aim(self, 1000);
		self.velocity = self.velocity * 1000;
		self = oldself;
	}
	if (self.wallgrab == 1)
	{
		self.doublejump = 0;
		if (self.button2 && self.char.attack_finished < time)
		{
			self.zoom_mode = STATE_TOP;
			self.walljump = 1;
			self.wallgrab = 0;
			self.char.think = player_move;
			self.char.nextthink = time + 0.010000;
			self.char.velocity_z = 350;
			oself = self;
			self = self.char;
			player_yell();
			self = oself;
			if (self.char.angles_y == STATE_TOP)
			{
				self.char.velocity_x = -180;
				self.char.angles_y = 180;
			}
			else
			{
				self.char.velocity_x = 180;
				self.char.angles_y = STATE_TOP;
			}
		}
	}
	if (self.char.watertype == CONTENT_LAVA)
	{
		if (self.dmgtime < time && self.char.takedamage && self.char.invunerability_finished < time)
		{
			self.dmgtime = time + 0.35;
			self.char.health = self.char.health - PLAT_LOW_TRIGGER;
			if (self.char.health < PLAT_LOW_TRIGGER)
			{
				Killed(self.char, world);
			}
		}
	}
	if (self.aircombo_finished > time && self.char.enemy != world && self.char.enemy.classname != "" && self.char.enemy.health > STATE_TOP && !(self.char.enemy.flags & FL_ONGROUND) && self.char.enemy.aircombo_finished > time)
	{
		if (self.char.frame != 89)
		{
			ct = vlen(self.char.enemy.origin - self.char.origin);
			if (self.char.enemy.origin_y > self.char.origin_y)
			{
				self.char.velocity_y = self.char.velocity_y + ct * SVC_CLIENTDATA * frametime;
			}
			else
			{
				self.char.velocity_y = self.char.velocity_y + ct * SVC_CLIENTDATA * frametime * CONTENT_EMPTY;
			}
		}
		else
		{
			self.char.velocity_y = STATE_TOP;
		}
	}
	if (self.magicmenu == 1)
	{
		if (self.bubbleshow == 0)
		{
			SpellBubble();
			self.bubbleshow = 1;
		}
		if (self.keyflags & (KEY_UP | KEY_DOWN))
		{
			if (self.keyflags & KEY_UP && self.FL_MGCPRESSED == 0)
			{
				sound(self, CHAN_ITEM, "player/mmenu1.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
				if (self.currentspell == SPELL_FIREBALL)
				{
					sprint(self, "Twister Selected\n");
					self.currentspell = SPELL_TWISTER;
				}
				else
				{
					if (self.currentspell == SPELL_TWISTER)
					{
						sprint(self, "Firebeam Selected\n");
						self.currentspell = SPELL_BEAM;
					}
					else
					{
						if (self.currentspell == SPELL_BEAM)
						{
							sprint(self, "Ice Field Selected\n");
							self.currentspell = SPELL_ICE;
						}
						else
						{
							if (self.currentspell == SPELL_ICE)
							{
								sprint(self, "Lightning Storm Selected\n");
								self.currentspell = SPELL_LIGHTNING;
							}
							else
							{
								if (self.currentspell == SPELL_LIGHTNING)
								{
									sprint(self, "Fireball Selected\n");
									self.currentspell = SPELL_FIREBALL;
								}
							}
						}
					}
				}
			}
			else
			{
				if (self.keyflags & KEY_DOWN && self.FL_MGCPRESSED == 0)
				{
					sound(self, CHAN_ITEM, "player/mmenu1.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
					if (self.currentspell == SPELL_FIREBALL)
					{
						sprint(self, "Lightning Storm Selected\n");
						self.currentspell = SPELL_LIGHTNING;
					}
					else
					{
						if (self.currentspell == SPELL_LIGHTNING)
						{
							sprint(self, "Ice Field Selected\n");
							self.currentspell = SPELL_ICE;
						}
						else
						{
							if (self.currentspell == SPELL_ICE)
							{
								sprint(self, "Fire Beam Selected\n");
								self.currentspell = SPELL_BEAM;
							}
							else
							{
								if (self.currentspell == SPELL_BEAM)
								{
									sprint(self, "Twister Selected\n");
									self.currentspell = SPELL_TWISTER;
								}
								else
								{
									if (self.currentspell == SPELL_TWISTER)
									{
										sprint(self, "Fireball Selected\n");
										self.currentspell = SPELL_FIREBALL;
									}
								}
							}
						}
					}
				}
			}
			self.FL_MGCPRESSED = 1;
		}
		else
		{
			self.FL_MGCPRESSED = 0;
		}
	}
	if (self.keyflags & KEY_LEFT && self.char.angles_y == STATE_TOP || (self.keyflags & KEY_RIGHT && self.char.angles_y == 180) && self.ledgegrab == 0 && self.char.angles_x == STATE_TOP && self.char.onground == 0 || self.wallgrab == 1)
	{
		if (relics & IT_RELIC1)
		{
			player_checkledge();
		}
	}
	if (self.button0 && self.button2 && self.safezone == 0 && self.attack_finished < time && self.char.tired_finished < time && self.ledgegrab == 0 && self.wallgrab == 0 && self.char.deadflag != DEAD_DEAD && self.char.movetype != MOVETYPE_FLY && self.wallrun == 0 && self.forcewalk_finished < time && self.char.fly_time < time && self.char.guardbreak_finished < time)
	{
		if (!(self.char.flypain))
		{
			if (self.char.block_finished < time || self.char.velocity_z < 80)
			{
				if (self.ammo_shells > STATE_TOP)
				{
					if (self.char.angles_y == 45 || self.char.angles_y == -45)
					{
						self.char.angles_y = STATE_TOP;
					}
					if (self.char.angles_y == 225 || self.char.angles_y == -225)
					{
						self.char.angles_y = 180;
					}
					self.char.velocity_x = STATE_TOP;
					self.char.flypain = 0;
					self.char.movetype = MOVETYPE_STEP;
					self.char.think = player_spinatk1;
					self.char.block_finished = time;
					self.char.charge_count = STATE_TOP;
					self.char.angles_z = STATE_TOP;
					self.char.angles_x = STATE_TOP;
					self.char.nextthink = time + 0.1;
					self.char.idle_count = STATE_TOP;
					self.magicmenu = 0;
					self.attack_finished = time + IT_RELIC2;
				}
				else
				{
					if (self.spinattack_msg < time)
					{
						sprint(self, "Not enough mana for spin attack!\n");
						self.spinattack_msg = time + 0.5;
					}
				}
			}
		}
	}
	if (self.button0 && self.char.tired_finished < time && self.char.deadflag != DEAD_DEAD && self.forcewalk_finished < time && self.char.fly_time < time && self.safezone == 0 && self.char.guardbreak_finished < time)
	{
		if (self.char.angles_y == 45 || self.char.angles_y == -45)
		{
			self.char.angles_y = STATE_TOP;
		}
		if (self.char.angles_y == 225 || self.char.angles_y == -225)
		{
			self.char.angles_y = 180;
		}
		self.char.idle_count = STATE_TOP;
		if (self.magicmenu == 1)
		{
			self.char.angles_y = self.char.turn_y;
			sound(self, CHAN_ITEM, "player/mmenu1.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
			self.magicmenu = 0;
		}
		player_fire();
		self.FL_ATKPRESSED = 1;
	}
	else
	{
		self.FL_ATKPRESSED = 0;
		if (self.char.charge_count == TE_LIGHTNING2)
		{
			self.char.think = player_chargeatk1;
			self.attack_finished = time + 99;
		}
		self.char.charge_count = STATE_TOP;
	}
	if (self.keyflags & KEY_LEFT && self.char.angles_y == STATE_TOP || (self.keyflags & KEY_RIGHT && self.char.angles_y == 180) && self.magicmenu == 0 && self.char.tired_finished < time && self.char.deadflag != DEAD_DEAD && self.char.grabbed == 0 && self.char.invunerability_finished < time && self.safezone == 0)
	{
		if (self.dbltime == STATE_TOP)
		{
			self.dbltime = time + 0.5;
		}
		else
		{
			if (self.dbltime < STATE_TOP)
			{
				if (STATE_TOP - self.dbltime >= time && self.char.pain_finished < time && self.char.onground == 1 && self.attack_finished < time)
				{
					if (self.button0)
					{
						if (self.char.angles_y == 45 || self.char.angles_y == -45)
						{
							self.char.angles_y = STATE_TOP;
						}
						if (self.char.angles_y == 225 || self.char.angles_y == -225)
						{
							self.char.angles_y = 180;
						}
						self.char.think = player_dashatk1;
						self.char.angles_x = STATE_TOP;
						self.char.charge_count = STATE_TOP;
						self.char.nextthink = time + 0.1;
						self.swordshadow_time = time + 0.4;
						self.attack_finished = time + 0.5;
					}
					else
					{
						if (self.char.block_finished < time)
						{
							self.char.running = 1;
							self.zoom_mode = IT_RELIC2;
						}
					}
				}
				else
				{
					self.dbltime = time;
				}
			}
		}
	}
	else
	{
		if (self.dbltime > STATE_TOP)
		{
			if (self.dbltime >= time)
			{
				self.dbltime = STATE_TOP - (time + 0.5);
			}
			else
			{
				self.dbltime = STATE_TOP;
			}
		}
		else
		{
			if (self.dbltime < STATE_TOP)
			{
				if (STATE_TOP - self.dbltime < time)
				{
					self.dbltime = STATE_TOP;
				}
			}
		}
	}
	if (self.char.onground == 0 && self.ledgegrab == 0 && self.char.health > STATE_TOP)
	{
		if (self.button2 && self.forcewalk_finished < time && self.char.fly_time < time && self.char.guardbreak_finished < time)
		{
			if (self.backflip_finished < time && self.char.deadflag != DEAD_DEAD)
			{
				if (self.char.frame != 137 && self.doublejump == 0 && self.FL_JMPPRESSED == 0 && self.char.pain_finished < time && self.attack_finished < time && self.char.aircombo_count == STATE_TOP && (relics & IT_RELIC2))
				{
					sound(self.char, CHAN_WEAPON, "player/djump.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
					self.char.djump_spincnt = STATE_TOP;
					self.doublejump = 1;
					self.char.think = player_doublejump1;
					self.doublejump_finished = time + 0.4;
				}
				if (self.char.pain_finished > time && self.char.velocity_z > STATE_TOP || self.char.bflipwall_finished > time)
				{
					self.backflip_finished = time + 0.7;
					self.char.think = player_bflip1;
					self.char.aircombo_count = STATE_TOP;
				}
			}
			self.FL_JMPPRESSED = 1;
		}
		else
		{
			self.FL_JMPPRESSED = 0;
		}
	}
	if (self.char.onground == 0 && !(self.char.flypain) && self.attack_finished < time && self.backflip_finished < time && self.wallgrab == 0 && self.walljump == 0 && self.char.deadflag != DEAD_DEAD && self.char.movetype != MOVETYPE_FLY && self.wallrun == 0 && self.ledgegrab == 0 && self.noaircontrol_finished < time && self.char.fly_time < time && self.char.guardbreak_finished < time)
	{
		if (self.keyflags & (KEY_LEFT | KEY_RIGHT))
		{
			if (self.keyflags & KEY_RIGHT)
			{
				if (self.char.running == 0)
				{
					self.char.velocity_x = STATE_TOP - self.char.speed * 1.5 / 1.2;
				}
				else
				{
					self.char.velocity_x = STATE_TOP - self.char.speed * 1.5;
				}
				self.char.angles_y = 180;
			}
			else
			{
				if (self.char.running == 0)
				{
					self.char.velocity_x = self.char.speed * 1.5 / 1.2;
				}
				else
				{
					self.char.velocity_x = self.char.speed * 1.5;
				}
				self.char.angles_y = STATE_TOP;
			}
		}
		if (self.keyflags & (KEY_UP | KEY_DOWN) && self.magicmenu == 0 && self.char.tired_finished < time && self.char.deadflag != DEAD_DEAD && self.char.aircombo_count == STATE_TOP)
		{
			if (self.keyflags & KEY_UP)
			{
				if (self.char.angles_y == STATE_TOP || self.char.angles_y == 45)
				{
					self.char.angles_y = -45;
				}
				if (self.char.angles_y == 180 || self.char.angles_y == -225)
				{
					self.char.angles_y = 225;
				}
				if (self.char.running == 0)
				{
					self.char.velocity_y = STATE_TOP - self.char.speed * 1.5 / 1.2;
				}
				else
				{
					self.char.velocity_y = STATE_TOP - self.char.speed * 1.5;
				}
			}
			else
			{
				if (self.char.angles_y == STATE_TOP || self.char.angles_y == -45)
				{
					self.char.angles_y = 45;
				}
				if (self.char.angles_y == 180 || self.char.angles_y == 225)
				{
					self.char.angles_y = -225;
				}
				if (self.char.aircombo_count == STATE_TOP)
				{
					if (self.char.running == 0)
					{
						self.char.velocity_y = self.char.speed * 1.5 / 1.2;
					}
					else
					{
						self.char.velocity_y = self.char.speed;
					}
				}
			}
		}
	}
	if (self.button0 && self.char.onground == 0 && self.char.deadflag != DEAD_DEAD && self.char.grabbed == 0 && self.char.aircombo_count == TE_WIZSPIKE && self.char.enemy != world)
	{
		if (self.char.frame >= 83 && self.char.frame < 87)
		{
			self.char.perform_flyingswallow = 1;
			self.noblock_finished = time + TE_LIGHTNING1;
		}
	}
	if (self.char.onground == 1 && self.char.deadflag != DEAD_DEAD && self.char.grabbed == 0 && self.combo_finished < time)
	{
		self.char.aircombo_count = STATE_TOP;
		if (self.button2 && self.char.pain_finished < time && self.attack_finished < time && self.char.block_finished < time && self.char.tired_finished < time && self.forcewalk_finished < time && self.conversation == 0 && self.char.guardbreak_finished < time)
		{
			if (self.FL_JMPPRESSED == 0)
			{
				if (self.magicmenu == 0)
				{
					traceline(self.char.origin, self.char.origin + v_up * 45, 0, self);
					if (trace_fraction == 1)
					{
						if (self.char.movetype != MOVETYPE_STEP)
						{
							self.char.movetype = MOVETYPE_STEP;
						}
						self.doublejump = 0;
						self.char.idle_count = STATE_TOP;
						self.char.velocity = VEC_ORIGIN;
						self.char.lastpos = self.char.origin;
						self.char.velocity_z = 425;
						self.char.frame = 88;
						sound(self.char, CHAN_BODY, "player/jump.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
					}
				}
				else
				{
					self.char.angles_y = self.char.turn_y;
					sound(self, CHAN_ITEM, "player/mmenu1.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
					self.magicmenu = 0;
				}
			}
			self.FL_JMPPRESSED = 1;
		}
		else
		{
			self.FL_JMPPRESSED = 0;
		}
		if (self.magicmenu == 0)
		{
			self.char.flags = self.char.flags - FL_ONGROUND;
			if (self.char.block_finished > time || self.char.velocity_time < time)
			{
				if (self.attack_finished > time || self.combo_finished > time)
				{
					self.char.velocity_x = STATE_TOP;
					self.char.velocity_y = STATE_TOP;
					return;
				}
			}
			if (self.keyflags & (KEY_LEFT | KEY_RIGHT) && self.char.pain_finished < time && self.char.block_finished < time && self.char.tired_finished < time && self.attack_finished < time && self.char.deadflag != DEAD_DEAD && self.wallgrab == 0 && self.char.grabbed == 0 && self.combo_finished < time && self.wallrun == 0 && self.char.guardbreak_finished < time)
			{
				if (self.keyflags & KEY_RIGHT)
				{
					if (self.char.running == 0)
					{
						self.char.velocity_x = STATE_TOP - self.char.speed / 1.5;
					}
					else
					{
						self.char.velocity_x = STATE_TOP - self.char.speed * 1.5;
					}
					self.char.angles_y = 180;
				}
				else
				{
					if (self.char.running == 0)
					{
						self.char.velocity_x = self.char.speed / 1.5;
					}
					else
					{
						self.char.velocity_x = self.char.speed * 1.5;
					}
					self.char.angles_y = STATE_TOP;
				}
			}
			else
			{
				if (self.char.running != 0)
				{
					self.char.running = 0;
				}
				if (self.char.velocity_time < time)
				{
					self.char.velocity_x = STATE_TOP;
				}
			}
			if (self.keyflags & (KEY_UP | KEY_DOWN) && self.char.pain_finished < time && self.char.block_finished < time && self.char.tired_finished < time && self.attack_finished < time && self.char.deadflag != DEAD_DEAD && self.wallgrab == 0 && self.char.grabbed == 0 && self.combo_finished < time && self.wallrun == 0 && self.conversation == 0 && self.char.guardbreak_finished < time)
			{
				if (self.keyflags & KEY_UP)
				{
					if (self.char.angles_y == STATE_TOP || self.char.angles_y == 45)
					{
						self.char.angles_y = -45;
					}
					if (self.char.angles_y == 180 || self.char.angles_y == -225)
					{
						self.char.angles_y = 225;
					}
					self.char.velocity_y = STATE_TOP - self.char.speed;
				}
				else
				{
					if (self.char.angles_y == STATE_TOP || self.char.angles_y == -45)
					{
						self.char.angles_y = 45;
					}
					if (self.char.angles_y == 180 || self.char.angles_y == 225)
					{
						self.char.angles_y = -225;
					}
					self.char.velocity_y = self.char.speed;
				}
			}
			else
			{
				if (self.char.velocity_time < time)
				{
					self.char.velocity_y = STATE_TOP;
				}
			}
		}
	}
	if (self.keyflags & KEY_UP)
	{
		if (self.FL_MP1PRESSED == 0)
		{
			self.moveprog1 = self.moveprog1 + PLAT_LOW_TRIGGER;
			self.moveprog1_finished = time + 0.2;
		}
		self.FL_MP1PRESSED = 1;
	}
	else
	{
		if (!(self.keyflags & KEY_UP))
		{
			self.FL_MP1PRESSED = 0;
		}
	}
	if (self.keyflags & KEY_DOWN)
	{
		if (self.FL_MP2PRESSED == 0)
		{
			self.moveprog2 = self.moveprog2 + PLAT_LOW_TRIGGER;
			self.moveprog2_finished = time + 0.2;
		}
		self.FL_MP2PRESSED = 1;
	}
	else
	{
		if (!(self.keyflags & KEY_DOWN))
		{
			self.FL_MP2PRESSED = 0;
		}
	}
	if (self.keyflags & KEY_LEFT)
	{
		if (self.FL_MP3PRESSED == 0)
		{
			self.moveprog3 = self.moveprog3 + PLAT_LOW_TRIGGER;
			self.moveprog3_finished = time + 0.2;
		}
		self.FL_MP3PRESSED = 1;
	}
	else
	{
		if (!(self.keyflags & KEY_LEFT))
		{
			self.FL_MP3PRESSED = 0;
		}
	}
	if (self.keyflags & KEY_RIGHT)
	{
		if (self.FL_MP4PRESSED == 0)
		{
			self.moveprog4 = self.moveprog4 + PLAT_LOW_TRIGGER;
			self.moveprog4_finished = time + 0.2;
		}
		self.FL_MP4PRESSED = 1;
	}
	else
	{
		if (!(self.keyflags & KEY_RIGHT))
		{
			self.FL_MP4PRESSED = 0;
		}
	}
	if (self.moveprog1_finished < time)
	{
		self.moveprog1 = STATE_TOP;
	}
	if (self.moveprog2_finished < time)
	{
		self.moveprog2 = STATE_TOP;
	}
	if (self.moveprog3_finished < time)
	{
		self.moveprog3 = STATE_TOP;
	}
	if (self.moveprog4_finished < time)
	{
		self.moveprog4 = STATE_TOP;
	}
	if (self.combo_finished < time)
	{
		self.char.swing_count = STATE_TOP;
	}
};

void() wallrunning_check = 
{
	local vector source;
	local float direct;
	makevectors(self.angles);
	source = self.origin;
	if (self.running == 1 && self.owner.wallrun == 0 && (self.frame == 88 || self.frame == 89))
	{
		if (self.owner.keyflags & KEY_UP && (self.owner.keyflags & KEY_LEFT || (self.owner.keyflags & KEY_RIGHT)))
		{
			traceline(source, source + '0 -25 -16', 0, self);
			if (self.owner.keyflags & KEY_RIGHT)
			{
				direct = PLAT_LOW_TRIGGER;
			}
			else
			{
				if (self.owner.keyflags & KEY_LEFT)
				{
					direct = IT_RELIC2;
				}
			}
		}
		if (trace_fraction == PLAT_LOW_TRIGGER)
		{
			return;
		}
		if (trace_ent.solid != SOLID_BSP)
		{
			return;
		}
		if (fabs(v_forward * trace_plane_normal) < 0.7)
		{
			return;
		}
		if (trace_plane_normal_z == 0)
		{
			self.owner.wallrun = 1;
			if (direct == PLAT_LOW_TRIGGER)
			{
				self.angles_y = 180;
				self.wallrun_height = 150;
				self.think = player_wallrun_right1;
			}
			else
			{
				if (direct == IT_RELIC2)
				{
					self.angles_y = STATE_TOP;
					self.wallrun_height = 150;
					self.think = player_wallrun_left1;
				}
			}
			self.nextthink = time;
		}
	}
};

void() wallgrab_check = 
{
	local vector source;
	makevectors(self.angles);
	source = self.origin;
	if (self.angles_y == STATE_TOP || self.angles_y == 180 && self.wallgrab == 0 && self.owner.ledgegrab == 0 && self.onground == 0 && (self.frame == 88 || self.frame == 89 || self.frame == 197))
	{
		traceline(source, source + v_forward * SVC_SIGNONNUM + v_up * SVC_SPAWNBASELINE, 0, self);
		if (trace_fraction == 1 || trace_ent.solid != SOLID_BSP)
		{
			return;
		}
		traceline(source, source + v_forward * SVC_SIGNONNUM - v_up * SVC_SPAWNBASELINE, 0, self);
		if (trace_fraction == 1 || trace_ent.solid != SOLID_BSP)
		{
			return;
		}
		if (self.owner.keyflags & KEY_LEFT && self.angles_y == STATE_TOP || (self.owner.keyflags & KEY_RIGHT && self.angles_y == 180))
		{
			if (trace_plane_normal_z == 0)
			{
				self.owner.camloose = STATE_TOP;
				self.owner.aircombo_count = STATE_TOP;
				if (self.owner.wallrun == 1)
				{
					self.owner.wallrun = 0;
				}
				self.think = player_wallgrab;
				self.nextthink = time;
			}
		}
	}
};

void() player_jumpframe = 
{
	if (self.charge_count != IT_RELIC3)
	{
		self.charge_count = IT_RELIC3;
	}
	if (self.owner.walljump == 1)
	{
		self.owner.softshadow_time = time + 0.1;
	}
	if (self.onground == 0 || self.velocity_z > 100)
	{
		if (self.aircombo_count == STATE_TOP || self.aircombo_count == IT_RELIC3 || self.aircombo_count == TE_WIZSPIKE || self.aircombo_count >= IT_RELIC4)
		{
			if (self.velocity_z < 400)
			{
				self.frame = 88;
			}
			if (self.velocity_z < 100)
			{
				self.frame = 89;
			}
		}
		else
		{
			if (self.aircombo_count == PLAT_LOW_TRIGGER || self.aircombo_count == AS_MELEE)
			{
				self.frame = 93;
			}
			else
			{
				if (self.aircombo_count == IT_RELIC2)
				{
					self.frame = 95;
				}
			}
		}
	}
	if (relics & IT_RELIC5)
	{
		wallrunning_check();
	}
	if (relics & IT_RELIC4)
	{
		wallgrab_check();
	}
};

void() player_grab = 
{
	local entity head;
	local entity check;
	local entity oself;
	local float cg;
	local vector source;
	if (self.running == 1 || self.grabbed == 1)
	{
		self.running = 0;
	}
	MakeSolidList();
	makevectors(self.angles);
	head = searchradius(self.origin, 40);
	while (head)
	{
		if (head.takedamage && head != self && self.grabbed == 0 && head.grabbed == 0 && self.invunerability_finished < time && self.onground == 1 && visible(head) && head.deadflag == DEAD_NO && head.twister_damage_finished < time && (head.flags & FL_ONGROUND && deathmatch == 0 && (head.flags & FL_MONSTER) || (deathmatch == 1 && (head.frame == 134 || head.frame == 135))))
		{
			if (head.th_grab)
			{
				self.enemy = head;
				check = spawn();
				check.movetype = MOVETYPE_FLY;
				check.owner = self;
				setmodel(check, string_null);
				setsize(check, self.enemy.mins, self.enemy.maxs);
				setorigin(check, self.origin + v_forward * SVC_SIGNONNUM);
				check.origin_y = self.origin_y;
				setorigin(check, check.origin);
				oself = self;
				self = check;
				droptofloor();
				if (self.origin_x < self.owner.origin_x)
				{
					self.angles_y = STATE_TOP;
				}
				else
				{
					self.angles_y = 180;
				}
				cg = walkmove(self.angles_y, PLAT_LOW_TRIGGER);
				source = self.origin;
				self = oself;
				if (!(self.origin_z < head.origin_z + AS_MELEE) && !(self.origin_z > head.origin_z - AS_MELEE) && !visible(head))
				{
					cg = 0;
				}
				if (self.origin_z < check.origin_z + AS_MELEE && self.origin_z > check.origin_z - AS_MELEE && visible(check))
				{
					if (cg)
					{
						self.owner.attack_finished = time;
						self.owner.zoom_mode = STATE_TOP;
						self.grabbed = 1;
						self.th_grab();
						oself = self;
						self = head;
						self.angles = check.angles;
						self.fixangle = 1;
						setorigin(self, check.origin);
						if (deathmatch == 0)
						{
							self.grabbed = 1;
							self.th_grab();
						}
						else
						{
							self.th_pain();
						}
						self = oself;
						sound(self, CHAN_WEAPON, "player/grab.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
					}
				}
				if (check != world)
				{
					remove(check);
					return;
				}
			}
		}
		head = head.chain;
	}
	UnmakeSolidList();
};

void() splash_particle = 
{
	local entity h;
	h = spawn();
	h.movetype = MOVETYPE_NOCLIP;
	h.solid = SOLID_NOT;
	setmodel(h, "progs/null.spr");
	setsize(h, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(h, self.origin);
};

void() player_move = [0, player_move]
{
	local vector source;
	local float onefoot;
	if (self.tired_finished > time)
	{
		player_tired1();
	}
	if (!(self.shadow))
	{
		spawn_shadow();
		self.shadow = 1;
	}
	if (self.owner.magicmenu == 0)
	{
		if (self.velocity_x || self.velocity_y && (self.owner.keyflags & (KEY_LEFT | KEY_RIGHT | KEY_UP | KEY_DOWN)) || self.owner.forcewalk_finished > time)
		{
			if (self.running == 0)
			{
				if (self.owner.camloose != IT_RELIC3 || self.owner.camloose != STATE_TOP)
				{
					if (self.owner.keyflags & KEY_UP && !(self.owner.keyflags & KEY_LEFT) && !(self.owner.keyflags & KEY_RIGHT) || (self.owner.keyflags & KEY_DOWN && !(self.owner.keyflags & KEY_LEFT) && !(self.owner.keyflags & KEY_RIGHT)))
					{
						self.owner.camloose = STATE_TOP;
					}
					else
					{
						self.owner.camloose = IT_RELIC3;
					}
				}
				if (self.walkframe == PLAT_LOW_TRIGGER || self.walkframe == TE_LIGHTNING2 && self.onground == 1)
				{
					sound(self, CHAN_BODY, "player/run.wav", 0.5, ATTN_NORM);
				}
				if (self.walkframe > TE_TELEPORT)
				{
					self.walkframe = STATE_TOP;
				}
				self.frame = SVC_UPDATECOLORS + self.walkframe;
				frameskip(0.060000);
			}
			else
			{
				if (self.owner.camloose != IT_RELIC3)
				{
					self.owner.camloose = IT_RELIC3;
				}
				if (self.walkframe == PLAT_LOW_TRIGGER || self.walkframe == IT_RELIC3 && self.onground == 1)
				{
					sound(self, CHAN_BODY, "player/run.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
				}
				if (self.walkframe > TE_LIGHTNING1)
				{
					self.walkframe = STATE_TOP;
				}
				if (self.owner.zoom_mode != IT_RELIC2)
				{
					self.owner.zoom_mode = IT_RELIC2;
				}
				self.frame = SVC_SPAWNSTATICSOUND + self.walkframe;
			}
			if (self.idle_count != STATE_TOP)
			{
				self.idle_count = STATE_TOP;
			}
			if (self.charge_count != STATE_TOP)
			{
				self.charge_count = STATE_TOP;
			}
		}
		else
		{
			if (self.owner.camloose != STATE_TOP)
			{
				self.owner.camloose = STATE_TOP;
			}
			if (self.owner.button0 && self.invunerability_finished < time && self.safezone == 0 && self.forcewalk_finished < time && self.char.fly_time < time)
			{
				if (self.charge_count < TE_LIGHTNING2)
				{
					self.charge_count = self.charge_count + PLAT_LOW_TRIGGER;
				}
				if (self.charge_count == AS_MELEE)
				{
					self.frame = 174;
				}
				else
				{
					if (self.charge_count == IT_RELIC3)
					{
						self.frame = 175;
					}
					else
					{
						if (self.charge_count == TE_LIGHTNING1)
						{
							self.frame = 176;
						}
						else
						{
							if (self.charge_count == TE_LIGHTNING2)
							{
								self.frame = 177;
							}
						}
					}
				}
			}
			if (self.charge_count < IT_RELIC3)
			{
				makevectors(self.angles);
				source = self.origin;
				traceline(source, source + v_forward * SVC_PARTICLE - v_up * SVC_SIGNONNUM, 0, self);
				if (trace_fraction == PLAT_LOW_TRIGGER)
				{
					onefoot = 1;
				}
				traceline(source, source - v_forward * SVC_PARTICLE - v_up * SVC_SIGNONNUM, 0, self);
				if (trace_fraction == PLAT_LOW_TRIGGER)
				{
					onefoot = 1;
				}
				if (onefoot == 1)
				{
					if (self.walkframe > TE_LIGHTNING1)
					{
						self.walkframe = STATE_TOP;
					}
					self.frame = 198 + self.walkframe;
				}
				else
				{
					if (self.idle_count <= 150)
					{
						if (self.walkframe > TE_LIGHTNING1)
						{
							self.walkframe = STATE_TOP;
						}
						self.frame = TE_TELEPORT + self.walkframe;
					}
					else
					{
						if (self.idle_count > 150)
						{
							if (self.walkframe > SVC_LIGHTSTYLE)
							{
								self.walkframe = STATE_TOP;
							}
							self.frame = 161 + self.walkframe;
							frameskip(0.05);
						}
					}
				}
			}
			self.idle_count = self.idle_count + PLAT_LOW_TRIGGER;
			if (self.angles_y == 45 || self.angles_y == -45)
			{
				self.angles_y = STATE_TOP;
			}
			if (self.angles_y == 225 || self.angles_y == -225)
			{
				self.angles_y = 180;
			}
		}
		self.walkframe = self.walkframe + PLAT_LOW_TRIGGER;
		if (!(self.flags & FL_ONGROUND))
		{
			if (self.block_finished > time)
			{
				player_block();
			}
			else
			{
				player_jumpframe();
			}
		}
	}
	else
	{
		self.frame = 116;
	}
	if (self.onground == 1)
	{
		self.owner.aircombo_finished = time;
		self.owner.wallrun = 0;
		self.owner.attack_finished = time;
		self.owner.walljump = 0;
		self.owner.noaircontrol_finished = time;
	}
	self.pain_finished = time;
	self.paincount = STATE_TOP;
	self.flypain = 0;
	self.takedamage = DAMAGE_AIM;
	self.owner.noblock_finished = time;
	self.spin_finished = 0;
	if (self.deadflag != DEAD_NO)
	{
		self.health = self.max_health;
		self.takedamage = DAMAGE_AIM;
		self.owner.ammo_shells = STATE_TOP;
		self.deadflag = DEAD_NO;
	}
	self.runatk_speed = STATE_TOP;
	self.owner.wallgrab = 0;
	self.angles_z = STATE_TOP;
	self.angles_x = STATE_TOP;
	if (self.owner.zoom_mode != STATE_TOP && self.grabbed == 0 && self.running == 0)
	{
		self.owner.zoom_mode = STATE_TOP;
	}
	self.grabbed = 0;
	self.grab_count = STATE_TOP;
	self.beams_shot = STATE_TOP;
	self.pitdeath = 0;
	self.owner.swordshadow_time = time;
	self.owner.softshadow_time = time;
	if (self.movetype != MOVETYPE_STEP && self.owner.ledgegrab == 0)
	{
		self.movetype = MOVETYPE_STEP;
	}
};

void() player_yell = 
{
	local float r;
	local float h;
	h = random();
	r = random();
	if (self.classname != "player")
	{
		objerror("Camera should not yell.\n");
	}
	if (h < 0.4 && self.voice_finished < time)
	{
		if (r < 0.25)
		{
			sound(self, CHAN_VOICE, "player/yell1.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
		}
		else
		{
			if (r < 0.5)
			{
				sound(self, CHAN_VOICE, "player/yell2.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
			}
			else
			{
				if (r < 0.75)
				{
					sound(self, CHAN_VOICE, "player/yell3.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
				}
				else
				{
					sound(self, CHAN_VOICE, "player/yell4.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
				}
			}
		}
		self.voice_finished = time + 0.8;
	}
};

void() player_fire = 
{
	local float r;
	local entity oself;
	if (self.attack_finished > time || self.FL_ATKPRESSED == 1 || self.char.flypain || self.char.pain_finished > time || self.ledgegrab == 1 || self.char.movetype == MOVETYPE_FLY)
	{
		return;
	}
	if (self.wallrun == 1 && self.doublejump == 1 || self.char.invunerability_finished > time)
	{
		return;
	}
	if (self.char.angles_x != STATE_TOP)
	{
		self.char.angles_x = STATE_TOP;
	}
	if (self.wallrun == 1)
	{
		wallrun_divingswallow_init();
		return;
	}
	self.char.attack_type = STATE_TOP;
	if (self.char.counter_finished > time && deathmatch == 0)
	{
		self.char.block_finished = time;
		self.char.think = player_counter1;
		self.swordshadow_time = time + 0.7;
		self.attack_finished = time + 0.7;
		return;
	}
	if (self.char.block_finished > time)
	{
		return;
	}
	r = random();
	if (self.char.onground == 1)
	{
		if (self.char.grabbed == 0)
		{
			if (self.moveprog2 > STATE_TOP && (self.moveprog3 > STATE_TOP || self.moveprog4 > STATE_TOP))
			{
				self.char.sword_spincnt = STATE_TOP;
				self.char.think = player_swordspin1;
				self.attack_finished = time + AS_MELEE;
				self.noblock_finished = time + AS_MELEE;
				return;
			}
			if (self.char.swing_count == STATE_TOP)
			{
				if (!(self.char.running))
				{
					oself = self;
					self = self.char;
					player_yell();
					self = oself;
					if (self.zoom_mode != STATE_TOP)
					{
						self.zoom_mode = STATE_TOP;
					}
					self.swordshadow_time = time + 0.4;
					self.char.think = player_attacka1;
					self.attack_finished = time + 0.5;
					self.char.swing_count = PLAT_LOW_TRIGGER;
					self.combo_finished = time + 0.65;
				}
				else
				{
					oself = self;
					self = self.char;
					player_yell();
					self = oself;
					if (self.zoom_mode != STATE_TOP)
					{
						self.zoom_mode = STATE_TOP;
					}
					self.char.running = 0;
					self.shadow_time = time + 0.5;
					self.char.think = player_runatk1;
					self.attack_finished = time + 0.8;
					self.noblock_finished = time + 0.8;
				}
			}
			else
			{
				if (self.char.swing_count == PLAT_LOW_TRIGGER)
				{
					oself = self;
					self = self.char;
					player_yell();
					self = oself;
					if (self.zoom_mode != STATE_TOP)
					{
						self.zoom_mode = STATE_TOP;
					}
					self.char.swing_count = IT_RELIC2;
					self.char.think = player_attackb1;
					self.swordshadow_time = time + 0.3;
					self.attack_finished = time + 0.4;
					self.combo_finished = time + 0.55;
				}
				else
				{
					if (self.char.swing_count == IT_RELIC2)
					{
						oself = self;
						self = self.char;
						player_yell();
						self = oself;
						if (self.zoom_mode != STATE_TOP)
						{
							self.zoom_mode = STATE_TOP;
						}
						self.char.swing_count = STATE_TOP;
						self.swordshadow_time = time + 0.8;
						self.char.think = player_attackc1;
						self.attack_finished = time + 0.7;
					}
				}
			}
		}
		else
		{
			if (self.char.grab_count == STATE_TOP)
			{
				self.char.think = player_grabatk1;
				self.attack_finished = time + 0.4;
				self.char.grab_count = PLAT_LOW_TRIGGER;
			}
			else
			{
				if (self.char.grab_count == PLAT_LOW_TRIGGER)
				{
					self.char.think = player_grabatk5;
					self.attack_finished = time + 0.6;
					self.char.grab_count = IT_RELIC2;
				}
				else
				{
					if (self.char.grab_count == IT_RELIC2)
					{
						oself = self;
						self = self.char;
						player_yell();
						self = oself;
						self.char.think = player_grabatk11;
						self.attack_finished = time + 1.1;
						self.char.grab_count = STATE_TOP;
					}
				}
			}
		}
	}
	else
	{
		if (self.pain_finished < time)
		{
			if (self.wallgrab == 0)
			{
				if (self.keyflags & KEY_DOWN)
				{
					if (relics & IT_RELIC3 && (self.char.aircombo_count == IT_RELIC3 || self.char.frame == 197))
					{
						oself = self;
						self = self.char;
						player_yell();
						self = oself;
						self.char.aircombo_count = TE_LIGHTNING2;
						self.attack_finished = time + 999;
						self.noblock_finished = time + 999;
						self.swordshadow_time = time + PLAT_LOW_TRIGGER;
						self.char.think = player_jatkspecial1;
					}
					else
					{
						oself = self;
						self = self.char;
						player_yell();
						self = oself;
						self.char.aircombo_count = TE_LIGHTNING1;
						sound(self.char, CHAN_WEAPON, "player/fast.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
						self.attack_finished = time + 999;
						self.char.think = player_jumpatk1;
						self.char.velocity_z = STATE_TOP;
						self.noblock_finished = time + 999;
						self.char.velocity_z = self.char.velocity_z - 250;
					}
					self.aircombo_finished = time + 999;
				}
				else
				{
					if (self.keyflags & KEY_UP)
					{
						if (!(self.char.flypain) && self.char.aircombo_count != IT_RELIC3 && self.backflip_finished < time)
						{
							self.char.aircombo_count = IT_RELIC3;
							self.attack_finished = time + 0.55;
							self.softshadow_time = time + 0.6;
							self.aircombo_finished = time + 0.3;
							self.char.think = player_airuppercut1;
						}
					}
					else
					{
						if (self.aircombo_finished < time && self.backflip_finished < time)
						{
							oself = self;
							self = self.char;
							player_yell();
							self = oself;
							if (self.zoom_mode != STATE_TOP)
							{
								self.zoom_mode = STATE_TOP;
							}
							if (self.char.aircombo_count == STATE_TOP)
							{
								self.aircombo_finished = time + 0.1;
								self.char.think = player_jumpatkb1;
								self.char.aircombo_count = PLAT_LOW_TRIGGER;
							}
							else
							{
								if (self.char.aircombo_count == PLAT_LOW_TRIGGER)
								{
									self.aircombo_finished = time + 0.15;
									self.char.think = player_jumpatkb2;
									self.char.aircombo_count = IT_RELIC2;
								}
								else
								{
									if (self.char.aircombo_count == IT_RELIC2 && self.char.frame != 94)
									{
										self.swordshadow_time = time + 0.2;
										self.char.think = player_jumpatkb4;
										self.char.aircombo_count = STATE_TOP;
										self.aircombo_finished = time + 999;
									}
								}
							}
						}
					}
				}
			}
		}
	}
};

void() player_grab1 = [138, player_grab2]
{
	if (self.onground == 0)
	{
		player_move();
	}
	self.velocity = VEC_ORIGIN;
};

void() player_grab2 = [139, player_grab2]
{
	makevectors(self.angles);
	if (self.grabbed != 1)
	{
		self.grabbed = 1;
	}
	self.velocity = VEC_ORIGIN;
	MakeSolidList();
	traceline(self.origin, self.origin + v_forward * 35, 0, self);
	if (self.enemy.health < PLAT_LOW_TRIGGER || self.onground == 0 || self.enemy != trace_ent)
	{
		player_move();
		return;
	}
	UnmakeSolidList();
	if (self.origin_x < self.enemy.origin_x)
	{
		self.angles_y = STATE_TOP;
	}
	else
	{
		self.angles_y = 180;
	}
};

void() player_grabatk1 = [140, player_grabatk2]
{
	player_yell();
};

void() player_grabatk2 = [141, player_grabatk3]
{
};

void() player_grabatk3 = [142, player_grabatk4]
{
};

void() player_grabatk4 = [143, player_grab2]
{
	sound(self, CHAN_BODY, "player/motion2.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	FireMelee(SVC_LIGHTSTYLE, SVC_SPAWNSTATIC, STATE_TOP, SVC_SPAWNSTATIC, AS_MELEE, STATE_TOP, PLAT_LOW_TRIGGER);
};

void() player_grabatk5 = [144, player_grabatk6]
{
};

void() player_grabatk6 = [145, player_grabatk7]
{
	player_yell();
};

void() player_grabatk7 = [146, player_grabatk8]
{
	sound(self, CHAN_BODY, "player/motion2.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	FireMelee(IT_RELIC4, SVC_SPAWNSTATIC, STATE_TOP, SVC_SPAWNSTATIC, AS_MELEE, STATE_TOP, PLAT_LOW_TRIGGER);
};

void() player_grabatk8 = [144, player_grabatk9]
{
};

void() player_grabatk9 = [145, player_grabatk10]
{
	player_yell();
};

void() player_grabatk10 = [146, player_grab2]
{
	sound(self, CHAN_BODY, "player/motion2.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	FireMelee(IT_RELIC4, SVC_SPAWNSTATIC, STATE_TOP, SVC_SPAWNSTATIC, AS_MELEE, STATE_TOP, PLAT_LOW_TRIGGER);
};

void() player_grabatk11 = [147, player_grabatk12]
{
};

void() player_grabatk12 = [148, player_grabatk13]
{
	self.velocity = VEC_ORIGIN;
	self.velocity_z = 200;
	self.velocity_x = STATE_TOP;
	self.velocity_y = STATE_TOP;
	self.flags = self.flags - (self.flags & FL_ONGROUND);
};

void() player_grabatk13 = [149, player_grabatk14]
{
	player_yell();
};

void() player_grabatk14 = [150, player_grabatk15]
{
	sound(self, CHAN_BODY, "player/motion1.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	FireMelee(TE_LIGHTNING3, SVC_INTERMISSION, STATE_TOP, SVC_SPAWNSTATIC, PLAT_LOW_TRIGGER, STATE_TOP, PLAT_LOW_TRIGGER);
};

void() player_grabatk15 = [151, player_grabatk16]
{
	sound(self, CHAN_BODY, "player/motion2.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	FireMelee(TE_LAVASPLASH, SVC_INTERMISSION, AS_MELEE, SVC_SPAWNSTATIC, IT_RELIC3, STATE_TOP, PLAT_LOW_TRIGGER);
};

void() player_grabatk16 = [151, player_grabatk16]
{
	if (self.flags & FL_ONGROUND)
	{
		player_grabatk17();
	}
	self.grabbed = 0;
};

void() player_grabatk17 = [152, player_grabatk18]
{
	frameskip(0.5);
};

void() player_grabatk18 = [153, player_move]
{
};

void() forwardflip_move = 
{
	if (self.angles_y == 45 || self.angles_y == -45)
	{
		self.angles_y = STATE_TOP;
	}
	if (self.angles_y == 225 || self.angles_y == -225)
	{
		self.angles_y = 180;
	}
	self.velocity = VEC_ORIGIN;
	self.velocity_z = 300;
	if (self.angles_y == STATE_TOP || self.angles_y == 360)
	{
		self.velocity_x = 75;
	}
	else
	{
		self.velocity_x = -75;
	}
	self.flags = self.flags - (self.flags & FL_ONGROUND);
};

void() player_fflip1 = [204, player_fflip2]
{
};

void() player_fflip2 = [205, player_fflip3]
{
};

void() player_fflip3 = [206, player_fflip4]
{
	self.nextthink = time + 0.2;
};

void() player_fflip4 = [207, player_fflip5]
{
	forwardflip_move();
	player_yell();
};

void() player_fflip5 = [208, player_fflip6]
{
};

void() player_fflip6 = [209, player_fflip7]
{
};

void() player_fflip7 = [210, player_fflip8]
{
};

void() player_fflip8 = [211, player_fflip8]
{
	if (self.onground == 1)
	{
		player_move();
	}
};

void() backflip_move = 
{
	if (self.angles_y == 45 || self.angles_y == -45)
	{
		self.angles_y = STATE_TOP;
	}
	if (self.angles_y == 225 || self.angles_y == -225)
	{
		self.angles_y = 180;
	}
	self.velocity = VEC_ORIGIN;
	self.velocity_z = self.velocity_z + 175;
	if (self.angles_y == STATE_TOP || self.angles_y == 360)
	{
		self.velocity_x = -135;
	}
	else
	{
		self.velocity_x = 135;
	}
};

void() player_bflip1 = [1, player_bflip2]
{
	self.angles_x = STATE_TOP;
	self.angles_z = STATE_TOP;
	self.owner.softshadow_time = time + 0.3;
	backflip_move();
	player_yell();
};

void() player_bflip2 = [2, player_bflip3]
{
	backflip_move();
	sound(self, CHAN_AUTO, "player/motion2.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
};

void() player_bflip3 = [3, player_bflip4]
{
	backflip_move();
};

void() player_bflip4 = [4, player_move]
{
	sound(self, CHAN_AUTO, "player/motion1.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
};

void() tired_check = 
{
	if (self.owner.zoom_mode != PLAT_LOW_TRIGGER)
	{
		self.owner.zoom_mode = PLAT_LOW_TRIGGER;
	}
	if (self.tired_finished < time)
	{
		player_move();
		self.owner.attack_finished = time;
		self.attack_finished = time;
	}
};

void() player_tired1 = [5, player_tired1]
{
	if (self.walkframe > IT_RELIC3)
	{
		self.walkframe = STATE_TOP;
	}
	if (self.attack_finished < time)
	{
		sound(self, CHAN_VOICE, "player/breath.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
		self.attack_finished = time + PLAT_LOW_TRIGGER;
	}
	self.frame = TE_LIGHTNING1 + self.walkframe;
	self.walkframe = self.walkframe + PLAT_LOW_TRIGGER;
	tired_check();
};

void() player_counter1 = [73, player_counter2]
{
	frameskip(0.05);
};

void() player_counter2 = [74, player_counter3]
{
	frameskip(0.05);
};

void() player_counter3 = [75, player_counter4]
{
	frameskip(0.05);
};

void() player_counter4 = [76, player_counter5]
{
	frameskip(0.05);
	sound(self, CHAN_AUTO, "player/motion2.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
};

void() player_counter5 = [77, player_counter6]
{
	frameskip(0.05);
};

void() player_counter6 = [78, player_counter7]
{
	frameskip(0.05);
};

void() player_counter7 = [79, player_counter8]
{
	frameskip(0.05);
	self.attack_type = TE_LIGHTNING1;
	FireMelee(SVC_CLIENTDATA, 70, PLAT_LOW_TRIGGER, 35, TE_LIGHTNING1, STATE_TOP, STATE_TOP);
	sound(self, CHAN_WEAPON, "player/sword.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
};

void() player_counter8 = [80, player_counter9]
{
	frameskip(0.05);
};

void() player_counter9 = [81, player_counter10]
{
	frameskip(0.05);
};

void() player_counter10 = [82, player_move]
{
	frameskip(0.2);
};

void() spinattack_particle_think = 
{
	if (self.attack_finished < time)
	{
		remove(self);
		return;
	}
	if (self.oldorigin)
	{
		self.rel_height_z = self.rel_height_z + (self.origin_z - self.oldorigin_z);
	}
	setorigin(self, self.owner.origin + self.rel_height - v_up * EF_ADDITIVE);
	self.oldorigin = self.origin;
	self.velocity_z = 150;
	makevectors(self.angles);
	particle(self.origin + v_forward * 50, VEC_ORIGIN, SVC_LIGHTSTYLE, SVC_SIGNONNUM);
	frameskip(0.05);
};

void() spinattack = 
{
	local entity head;
	local entity effect;
	head = searchradius(self.origin, 60);
	while (head)
	{
		if (head.takedamage && head != self && head.spin_finished < time && visible(head) && (coop == 1 && head.classname != "player" && self.classname == "player" || (coop == 0 || (self.flags & FL_MONSTER))))
		{
			if (head.th_pain)
			{
				head.paincount = STATE_TOP;
				head.velocity = VEC_ORIGIN;
				head.spin_finished = time + 0.2;
				if (self.owner.ammo_shells >= SVC_CLIENTDATA)
				{
					if (sprite_count < TE_LIGHTNING1)
					{
						effect = spawn();
						setorigin(effect, head.origin + v_up * SVC_SPAWNBASELINE);
						setmodel(effect, "progs/jhit.spr");
						effect.movetype = MOVETYPE_NONE;
						effect.think = fx_think;
						if (darkplaces)
						{
							effect.effects = EF_NODEPTHTEST;
						}
						effect.nextthink = time;
						effect.solid = SOLID_NOT;
						sprite_count = sprite_count + PLAT_LOW_TRIGGER;
					}
					if (deathmatch == 0)
					{
						combo = combo + PLAT_LOW_TRIGGER;
					}
					else
					{
						self.owner.dm_combo = self.owner.dm_combo + PLAT_LOW_TRIGGER;
					}
					sound(self, CHAN_WEAPON, "player/bigcut.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
					if (head.health > STATE_TOP)
					{
						self.owner.ammo_shells = self.owner.ammo_shells - SVC_CLIENTDATA;
					}
					head.damage_type = TE_LIGHTNING1;
					if (deathmatch == 0)
					{
						T_Damage(head, self, self, SVC_SIGNONNUM);
					}
					else
					{
						T_Damage(head, self, self, SVC_SIGNONNUM / 3.5);
					}
					head.damage_type = STATE_TOP;
				}
				else
				{
					if (self.owner.ammo_shells > STATE_TOP)
					{
						if (sprite_count < TE_LIGHTNING1)
						{
							effect = spawn();
							setorigin(effect, head.origin + v_up * SVC_SPAWNBASELINE);
							setmodel(effect, "progs/jhit.spr");
							effect.movetype = MOVETYPE_NONE;
							effect.think = fx_think;
							if (darkplaces)
							{
								effect.effects = EF_NODEPTHTEST;
							}
							effect.nextthink = time;
							effect.solid = SOLID_NOT;
							sprite_count = sprite_count + PLAT_LOW_TRIGGER;
						}
						if (deathmatch == 0)
						{
							combo = combo + PLAT_LOW_TRIGGER;
						}
						else
						{
							self.owner.dm_combo = self.owner.dm_combo + PLAT_LOW_TRIGGER;
						}
						sound(self, CHAN_WEAPON, "player/swordhit.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
						if (deathmatch == 0)
						{
							T_Damage(head, self, self, self.owner.ammo_shells + TE_LIGHTNING1);
						}
						else
						{
							T_Damage(head, self, self, self.owner.ammo_shells + TE_LIGHTNING1 / 3.5);
						}
						self.owner.ammo_shells = STATE_TOP;
					}
				}
				if (self.spin_finished == 0)
				{
					self.spin_finished = 1;
				}
			}
		}
		head = head.chain;
	}
	if (self.onground == 0)
	{
		if (self.angles_y == STATE_TOP)
		{
			self.velocity_x = self.speed * IT_RELIC2;
		}
		else
		{
			if (self.angles_y == 180)
			{
				self.velocity_x = STATE_TOP - self.speed * IT_RELIC2;
			}
		}
		self.velocity_z = self.velocity_z / 0.5 * frametime;
		self.aircombo_count = STATE_TOP;
	}
	self.owner.swordshadow_time = time + PLAT_LOW_TRIGGER;
};

void() spinattack_particle = 
{
	local entity parti;
	parti = spawn();
	parti.owner = self;
	parti.movetype = MOVETYPE_NOCLIP;
	parti.solid = SOLID_NOT;
	setorigin(parti, self.origin);
	setorigin(parti, self.origin - v_up * EF_ADDITIVE);
	parti.avelocity = '0 500 0';
	parti.angles_y = random() * 360;
	parti.attack_finished = time + 0.5;
	parti.think = spinattack_particle_think;
	parti.nextthink = time + 0.010000;
};

void() player_spinatk1 = [63, player_spinatk2]
{
	frameskip(0.080000);
	sound(self, CHAN_VOICE, "player/spinatk.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	spinattack_particle();
};

void() player_spinatk2 = [64, player_spinatk3]
{
	frameskip(0.080000);
	spinattack();
};

void() player_spinatk3 = [65, player_spinatk4]
{
	frameskip(0.080000);
};

void() player_spinatk4 = [66, player_spinatk5]
{
	frameskip(0.080000);
	spinattack();
	spinattack_particle();
};

void() player_spinatk5 = [67, player_spinatk6]
{
	frameskip(0.080000);
};

void() player_spinatk6 = [68, player_spinatk7]
{
	frameskip(0.080000);
	spinattack();
};

void() player_spinatk7 = [69, player_spinatk8]
{
	frameskip(0.080000);
	spinattack_particle();
};

void() player_spinatk8 = [70, player_spinatk9]
{
	frameskip(0.080000);
	spinattack();
};

void() player_spinatk9 = [71, player_spinatk10]
{
	frameskip(0.080000);
};

void() player_spinatk10 = [72, player_move]
{
	frameskip(0.080000);
	spinattack();
	spinattack_particle();
};

void() player_kickforward = 
{
	self.velocity_time = time + 0.2;
	if (self.angles_y == STATE_TOP)
	{
		self.velocity_x = self.speed;
	}
	else
	{
		if (self.angles_y == 180)
		{
			self.velocity_x = STATE_TOP - self.speed;
		}
	}
};

void() player_kick1 = [83, player_kick2]
{
	sound(self, CHAN_AUTO, "player/motion1.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	self.velocity_z = 250;
	player_kickforward();
	player_yell();
};

void() player_kick2 = [84, player_kick3]
{
	LegShadow();
	FireMelee(TE_LAVASPLASH, SVC_SETPAUSE, AS_MELEE, EF_ADDITIVE, IT_RELIC3, STATE_TOP, PLAT_LOW_TRIGGER);
	player_kickforward();
	frameskip(0.15);
};

void() player_kick3 = [85, player_kick4]
{
	player_kickforward();
	if (self.onground == 1)
	{
		player_move();
	}
};

void() player_kick4 = [86, player_kick5]
{
	player_kickforward();
	if (self.onground == 1)
	{
		player_move();
	}
};

void() player_kick5 = [87, player_move]
{
	player_kickforward();
	frameskip(0.15);
	player_kickforward();
	if (self.perform_flyingswallow == 1)
	{
		self.movetype = MOVETYPE_NONE;
		self.think = player_airdivings1;
		self.nextthink = time + 0.2;
	}
	if (self.onground == 1)
	{
		player_move();
	}
};

void() runattack_forward = 
{
	local entity effect;
	makevectors(self.angles);
	if (self.onground == 1)
	{
		if (sprite_count < TE_LIGHTNING1)
		{
			if (random() < 0.5)
			{
				effect = spawn();
				setorigin(effect, self.origin - v_up * IT_RELIC5 - v_forward * SVC_SETPAUSE);
				setmodel(effect, "progs/dust.spr");
				effect.solid = SOLID_NOT;
				effect.owner = self;
				effect.movetype = MOVETYPE_FLY;
				effect.velocity_z = 100;
				effect.think = dust_think;
				effect.nextthink = time + 0.010000;
				sprite_count = sprite_count + PLAT_LOW_TRIGGER;
			}
			else
			{
				effect = spawn();
				setorigin(effect, self.origin - v_up * IT_RELIC5 + v_forward * IT_RELIC3);
				setmodel(effect, "progs/dust.spr");
				effect.solid = SOLID_NOT;
				effect.owner = self;
				effect.movetype = MOVETYPE_FLY;
				effect.velocity_z = 100;
				effect.think = dust_think;
				effect.nextthink = time + 0.010000;
				sprite_count = sprite_count + PLAT_LOW_TRIGGER;
			}
		}
	}
	self.velocity_time = time + 0.2;
	self.runatk_speed = self.runatk_speed + EF_ADDITIVE;
	self.owner.speedline_time = time + 0.1;
	model_tilt();
	if (self.angles_y == STATE_TOP)
	{
		self.velocity_x = self.speed * IT_RELIC3 - self.runatk_speed;
	}
	else
	{
		if (self.angles_y == 180)
		{
			self.velocity_x = STATE_TOP - self.speed * IT_RELIC3 + self.runatk_speed;
		}
	}
	self.velocity_y = STATE_TOP;
	while (!walkmove(self.angles_y, self.speed * frametime) && runaway < 100)
	{
		runaway = runaway + PLAT_LOW_TRIGGER;
	}
};

void() player_runatk1 = [35, player_runatk2]
{
	sound(self, CHAN_BODY, "player/skid.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	runattack_forward();
};

void() player_runatk2 = [36, player_runatk3]
{
	runattack_forward();
	sound(self, CHAN_WEAPON, "player/sword3.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	player_yell();
};

void() player_runatk3 = [37, player_runatk4]
{
	runattack_forward();
};

void() player_runatk4 = [38, player_runatk5]
{
	runattack_forward();
	self.attack_type = TE_LIGHTNING1;
	FireMelee(IT_RELIC2, SVC_CLIENTDATA, STATE_TOP, SVC_INTERMISSION, STATE_TOP, STATE_TOP, PLAT_LOW_TRIGGER);
};

void() player_runatk5 = [39, player_runatk6]
{
	runattack_forward();
	self.attack_type = TE_LIGHTNING1;
	FireMelee(IT_RELIC3, SVC_CLIENTDATA, STATE_TOP, SVC_INTERMISSION, STATE_TOP, STATE_TOP, PLAT_LOW_TRIGGER);
};

void() player_runatk6 = [39, player_runatk7]
{
	runattack_forward();
	self.attack_type = TE_LIGHTNING1;
	FireMelee(TE_LIGHTNING2, SVC_CLIENTDATA, PLAT_LOW_TRIGGER, SVC_INTERMISSION, STATE_TOP, STATE_TOP, PLAT_LOW_TRIGGER);
};

void() player_runatk7 = [39, player_runatk8]
{
	runattack_forward();
	self.attack_type = TE_LIGHTNING1;
	FireMelee(IT_RELIC4, SVC_CLIENTDATA, AS_MELEE, SVC_INTERMISSION, TE_LIGHTNING1, PLAT_LOW_TRIGGER, PLAT_LOW_TRIGGER);
};

void() player_runatk8 = [39, player_move]
{
	self.velocity_x = STATE_TOP;
};

void() player_attacka1 = [40, player_attacka2]
{
	sound(self, CHAN_WEAPON, "player/sword.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	self.nextthink = time + 0.15;
};

void() player_attacka2 = [41, player_attacka3]
{
	FireMelee(TE_LAVASPLASH, 45, STATE_TOP, SVC_SPAWNSTATIC, STATE_TOP, STATE_TOP, STATE_TOP);
};

void() player_attacka3 = [42, player_attacka4]
{
	frameskip(0.080000);
};

void() player_attacka4 = [43, player_attacka4]
{
	if (self.owner.combo_finished < time)
	{
		player_move();
	}
};

void() player_attackb1 = [44, player_attackb2]
{
	sound(self, CHAN_WEAPON, "player/sword.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
};

void() player_attackb2 = [45, player_attackb3]
{
	FireMelee(TE_WIZSPIKE, 45, STATE_TOP, SVC_SPAWNSTATIC, STATE_TOP, STATE_TOP, STATE_TOP);
	frameskip(0.080000);
};

void() player_attackb3 = [46, player_attackb4]
{
	FireMelee(TE_WIZSPIKE, 45, STATE_TOP, SVC_SPAWNSTATIC, STATE_TOP, STATE_TOP, STATE_TOP);
	frameskip(0.060000);
};

void() player_attackb4 = [47, player_attackb4]
{
	if (self.owner.combo_finished < time)
	{
		player_move();
	}
};

void() swordstareffect_think = 
{
	if (self.frame < AS_MELEE)
	{
		self.frame = self.frame + PLAT_LOW_TRIGGER;
	}
	else
	{
		remove(self);
	}
	self.nextthink = time + 0.1;
};

void() swordstareffect = 
{
	local entity effect;
	makevectors(self.angles);
	effect = spawn();
	setorigin(effect, self.origin + v_forward * 54 + v_up * SVC_SETPAUSE);
	setmodel(effect, "progs/star.spr");
	effect.solid = SOLID_NOT;
	effect.movetype = MOVETYPE_NOCLIP;
	effect.think = swordstareffect_think;
	effect.nextthink = time + 0.1;
};

void() player_attackc1 = [48, player_attackc2]
{
	frameskip(0.040000);
};

void() player_attackc2 = [49, player_attackc3]
{
	frameskip(0.040000);
	sound(self, CHAN_BODY, "player/swrdspin.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
};

void() player_attackc3 = [50, player_attackc4]
{
	frameskip(0.040000);
	FireMelee(AS_MELEE, 45, STATE_TOP, SVC_SIGNONNUM, STATE_TOP, STATE_TOP, STATE_TOP);
};

void() player_attackc4 = [51, player_attackc5]
{
	frameskip(0.040000);
};

void() player_attackc5 = [52, player_attackc6]
{
	frameskip(0.030000);
	FireMelee(AS_MELEE, 45, STATE_TOP, SVC_SIGNONNUM, STATE_TOP, STATE_TOP, STATE_TOP);
};

void() player_attackc6 = [53, player_attackc7]
{
	frameskip(0.030000);
};

void() player_attackc7 = [54, player_attackc8]
{
	swordstareffect();
	self.nextthink = time + 0.2;
	sound(self, CHAN_WEAPON, "player/sword2.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	FireMelee(SVC_SPAWNSTATIC, 45, PLAT_LOW_TRIGGER, SVC_SIGNONNUM, STATE_TOP, STATE_TOP, STATE_TOP);
};

void() player_attackc8 = [55, player_attackc9]
{
	frameskip(0.030000);
};

void() player_attackc9 = [56, player_move]
{
	frameskip(0.030000);
};

void() dashattack_forward = 
{
	self.velocity_time = time + 0.3;
	self.velocity_y = STATE_TOP;
	if (self.angles_y == STATE_TOP)
	{
		self.velocity_x = self.speed * 1.8 / 1.5;
	}
	else
	{
		if (self.angles_y == 180)
		{
			self.velocity_x = STATE_TOP - self.speed * 1.8 / 1.5;
		}
	}
	while (!walkmove(self.angles_y, self.speed * frametime) && runaway < 100)
	{
		runaway = runaway + PLAT_LOW_TRIGGER;
	}
};

void() player_dashatk1 = [57, player_dashatk2]
{
	frameskip(0.07);
	dashattack_forward();
};

void() player_dashatk2 = [58, player_dashatk3]
{
	frameskip(0.07);
	dashattack_forward();
};

void() player_dashatk3 = [59, player_dashatk4]
{
	frameskip(0.07);
	dashattack_forward();
	sound(self, CHAN_WEAPON, "player/sword3.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
};

void() player_dashatk4 = [60, player_dashatk5]
{
	frameskip(0.07);
	dashattack_forward();
	self.attack_type = TE_LIGHTNING1;
	FireMelee(TE_LAVASPLASH, SVC_SIGNONNUM, IT_RELIC2, SVC_INTERMISSION, IT_RELIC2, STATE_TOP, PLAT_LOW_TRIGGER);
};

void() player_dashatk5 = [61, player_dashatk6]
{
	frameskip(0.07);
	dashattack_forward();
	self.attack_type = TE_LIGHTNING1;
	FireMelee(TE_LAVASPLASH, SVC_SIGNONNUM, IT_RELIC2, SVC_INTERMISSION, IT_RELIC2, STATE_TOP, PLAT_LOW_TRIGGER);
};

void() player_dashatk6 = [62, player_move]
{
	frameskip(0.07);
	dashattack_forward();
	self.attack_type = TE_LIGHTNING1;
	FireMelee(TE_LAVASPLASH, SVC_SIGNONNUM, IT_RELIC2, SVC_INTERMISSION, IT_RELIC2, STATE_TOP, PLAT_LOW_TRIGGER);
};

void() player_chargeatkforward = 
{
	self.velocity = VEC_ORIGIN;
	self.velocity_z = 100;
	self.velocity_time = time + 0.2;
	if (self.angles_y == STATE_TOP)
	{
		self.velocity_x = self.speed * 1.5;
	}
	else
	{
		if (self.angles_y == 180)
		{
			self.velocity_x = STATE_TOP - self.speed * 1.5;
		}
	}
};

void() firecolumn_animate = 
{
	local entity head;
	local entity effect;
	droptofloor();
	MakeSolidList();
	head = searchradius(self.origin, 40);
	while (head)
	{
		if (head != self && visible(head) && head.takedamage && self.owner != head && (coop == 1 && head.classname != "player" || (coop == 0 || (self.flags & FL_MONSTER))))
		{
			if (sprite_count < TE_LAVASPLASH)
			{
				effect = spawn();
				setorigin(effect, head.origin + v_up * SVC_UPDATEFRAGS);
				setmodel(effect, "progs/fire.spr");
				effect.movetype = MOVETYPE_NONE;
				effect.think = firesprite_think;
				effect.nextthink = time;
				effect.solid = SOLID_NOT;
				head.knockback = TE_LIGHTNING1;
				head.damage_type = IT_RELIC2;
				if (deathmatch == 0)
				{
					T_Damage(head, self.owner, self.owner, TE_WIZSPIKE);
				}
				else
				{
					T_Damage(head, self.owner, self.owner, IT_RELIC2);
				}
				sound(self, CHAN_BODY, "spells/fhit.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
				sprite_count = sprite_count + PLAT_LOW_TRIGGER;
				if (deathmatch == 0)
				{
					combo = combo + PLAT_LOW_TRIGGER;
					self.owner.ammo_shells = self.owner.ammo_shells + PLAT_LOW_TRIGGER;
				}
				else
				{
					self.owner.dm_combo = self.owner.dm_combo + PLAT_LOW_TRIGGER;
					self.owner.ammo_shells = self.owner.ammo_shells + AS_MELEE;
				}
			}
		}
		head = head.chain;
	}
	UnmakeSolidList();
	if (self.frame < SVC_DAMAGE)
	{
		self.frame = self.frame + PLAT_LOW_TRIGGER;
	}
	else
	{
		remove(self);
		return;
	}
	if (self.frame < TE_LIGHTNING3)
	{
		frameskip(0.020000);
	}
	else
	{
		frameskip(0.040000);
	}
};

void() player_chargeatk1 = [178, player_chargeatk2]
{
	self.owner.swordshadow_time = time + 0.3;
	sound(self, CHAN_AUTO, "player/sword3.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	player_yell();
	player_chargeatkforward();
};

void() player_chargeatk2 = [179, player_chargeatk3]
{
	player_chargeatkforward();
};

void() player_chargeatk3 = [180, player_chargeatk4]
{
	player_chargeatkforward();
};

void() player_chargeatk4 = [181, player_chargeatk5]
{
	player_chargeatkforward();
};

void() player_chargeatk5 = [182, player_chargeatk5]
{
	local entity fc;
	if (self.onground == 1)
	{
		makevectors(self.angles);
		fc = spawn();
		fc.owner = self;
		fc.movetype = MOVETYPE_FLYMISSILE;
		fc.solid = SOLID_NOT;
		fc.classname = "firecolumn";
		fc.think = firecolumn_animate;
		fc.nextthink = time + 0.010000;
		fc.alpha = 0.3;
		fc.angles_y = -90;
		setmodel(fc, "progs/firecolm.mdl");
		setsize(fc, VEC_ORIGIN, VEC_ORIGIN);
		setorigin(fc, self.origin + v_forward * 55 + v_up * EF_ADDITIVE);
		sound(fc, CHAN_WEAPON, "player/firec.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
		fc.effects = EF_DIMLIGHT;
		self.attack_finished = time + 0.5;
		self.nextthink = time + 0.5;
		self.think = player_move;
		self.owner.camshake_finished = time + 0.5;
	}
	self.owner.noblock_finished = time + TE_LIGHTNING1;
};

void() jatk_particle_think = 
{
	particle(self.origin, VEC_ORIGIN, 111, TE_LIGHTNING2);
	if (self.attack_finished < time)
	{
		remove(self);
	}
	self.nextthink = time + 0.010000;
};

void() jatk_particle = 
{
	local entity spark;
	spark = spawn();
	spark.angles_y = random() * 360;
	makevectors(spark.angles);
	spark.velocity = v_forward * 100;
	spark.velocity_z = 150;
	spark.owner = self;
	spark.movetype = MOVETYPE_FLY;
	spark.solid = SOLID_NOT;
	spark.classname = "spark";
	setmodel(spark, string_null);
	setsize(spark, VEC_ORIGIN, VEC_ORIGIN);
	makevectors(self.angles);
	setorigin(spark, self.origin - v_up * EF_ADDITIVE);
	spark.attack_finished = time + 0.2;
	spark.think = jatk_particle_think;
	spark.nextthink = time + 0.010000;
};

void() jatkspecial_muzzle_think = 
{
	if (self.owner.frame != 160 && self.owner.frame != 90 && self.owner.frame != 91)
	{
		remove(self);
		return;
	}
	makevectors(self.owner.angles);
	setorigin(self, self.owner.origin - v_up * 36 + v_forward * TE_LAVASPLASH);
	if (!coop && !deathmatch)
	{
		jatk_particle();
	}
	self.avelocity = '0 1000 0';
	frameskip(0.010000);
};

void() jatkspecial_muzzle = 
{
	local entity s;
	makevectors(self.angles);
	s = spawn();
	s.owner = self;
	setorigin(s, self.origin - v_up * SVC_INTERMISSION + v_forward * TE_LAVASPLASH);
	setmodel(s, "progs/jatkspc.mdl");
	setsize(s, VEC_ORIGIN, VEC_ORIGIN);
	s.movetype = MOVETYPE_FLY;
	s.alpha = 0.7;
	s.effects = EF_ADDITIVE;
	s.solid = SOLID_NOT;
	s.think = jatkspecial_muzzle_think;
	s.nextthink = time + 0.1;
};

void() jatkspecial = 
{
	self.velocity = VEC_ORIGIN;
	if (self.angles_y == STATE_TOP)
	{
		self.velocity_x = self.speed / IT_RELIC2;
	}
	else
	{
		if (self.angles_y == 180)
		{
			self.velocity_x = STATE_TOP - self.speed / IT_RELIC2;
		}
	}
	self.velocity_z = self.velocity_z + 200;
};

void() player_jatkspecial1 = [154, player_jatkspecial2]
{
	jatkspecial();
	frameskip(0.060000);
	FireMelee(AS_MELEE, SVC_CLIENTDATA, STATE_TOP, 35, STATE_TOP, STATE_TOP, PLAT_LOW_TRIGGER);
	sound(self, CHAN_ITEM, "player/swrdspin.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
};

void() player_jatkspecial2 = [155, player_jatkspecial3]
{
	jatkspecial();
	frameskip(0.060000);
	FireMelee(AS_MELEE, SVC_CLIENTDATA, STATE_TOP, 35, STATE_TOP, STATE_TOP, PLAT_LOW_TRIGGER);
};

void() player_jatkspecial3 = [156, player_jatkspecial4]
{
	jatkspecial();
	frameskip(0.060000);
	FireMelee(AS_MELEE, SVC_CLIENTDATA, STATE_TOP, 35, STATE_TOP, STATE_TOP, PLAT_LOW_TRIGGER);
};

void() player_jatkspecial4 = [157, player_jatkspecial5]
{
	jatkspecial();
	frameskip(0.060000);
	FireMelee(AS_MELEE, SVC_CLIENTDATA, STATE_TOP, 35, STATE_TOP, STATE_TOP, PLAT_LOW_TRIGGER);
};

void() player_jatkspecial5 = [158, player_jatkspecial6]
{
	jatkspecial();
	frameskip(0.060000);
};

void() player_jatkspecial6 = [159, player_jatkspecial7]
{
	jatkspecial();
	frameskip(0.060000);
};

void() player_jatkspecial7 = [160, player_jumpatk2]
{
	self.velocity = VEC_ORIGIN;
	self.velocity_z = self.velocity_z - 250;
	player_yell();
	sound(self, CHAN_BODY, "player/fast.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	jatkspecial_muzzle();
	frameskip(0.15);
};

void() effect_think = 
{
	droptofloor();
	if (self.frame < AS_MELEE)
	{
		self.frame = self.frame + PLAT_LOW_TRIGGER;
	}
	else
	{
		remove(self);
	}
	frameskip(0.07);
};

void() jumpatk_grounded = 
{
	local entity effect;
	effect = spawn();
	setorigin(effect, self.origin);
	setmodel(effect, "progs/grounded.mdl");
	effect.solid = SOLID_NOT;
	setsize(effect, '-21 -21 -16', '22 23 31');
	effect.movetype = MOVETYPE_FLY;
	effect.think = effect_think;
	effect.alpha = 0.8;
	effect.effects = EF_ADDITIVE;
	effect.nextthink = time + 0.1;
};

void() player_hsblked = [250, player_hsblked]
{
	local vector view;
	view = vectoangles(self.enemy.origin - self.origin);
	self.angles_y = view_y;
	self.fixangle = 1;
	if (self.onground == 1)
	{
		if (self.angles_y > 90 && self.angles_y < 270)
		{
			self.angles_y = 180;
		}
		else
		{
			self.angles_y = STATE_TOP;
		}
		player_move();
		return;
	}
	frameskip(0.010000);
};

void() player_jumpatk1 = [90, player_jumpatk2]
{
	frameskip(0.05);
	self.velocity_y = STATE_TOP;
};

void() player_jumpatk2 = [91, player_jumpatk2]
{
	local entity head;
	local entity effect;
	local entity fx;
	local vector no;
	local float rsize;
	self.owner.speedline_time = time + 0.1;
	if (self.aircombo_count != TE_LIGHTNING2)
	{
		rsize = SVC_SIGNONNUM;
	}
	else
	{
		rsize = 40;
		if (self.angles_y == STATE_TOP)
		{
			self.velocity_x = self.speed / 1.5;
		}
		else
		{
			if (self.angles_y == 180)
			{
				self.velocity_x = STATE_TOP - self.speed / 1.5;
			}
		}
	}
	MakeSolidList();
	head = searchradius(self.origin - v_up * SVC_SPAWNSTATIC, rsize);
	while (head)
	{
		if (head.takedamage && head.nopain_time < time && head != self && visible(head) && (coop == 1 && head.classname != "player" && self.classname == "player" || (coop == 0 || (self.flags & FL_MONSTER))))
		{
			if (sprite_count < TE_LIGHTNING1)
			{
				if (head.block_finished < time)
				{
					if (self.aircombo_count == TE_LIGHTNING2)
					{
						effect = spawn();
						setorigin(effect, head.origin);
						setmodel(effect, "progs/explode1.mdl");
						effect.movetype = MOVETYPE_NONE;
						effect.think = explodemodel_think;
						if (darkplaces)
						{
							effect.effects = EF_NODEPTHTEST;
						}
						effect.nextthink = time;
						effect.alpha = PLAT_LOW_TRIGGER;
						effect.solid = SOLID_NOT;
						sound(self, CHAN_BODY, "spells/fhit.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
						fx = spawn();
						setorigin(fx, head.origin);
						setmodel(fx, "progs/efxflash.spr");
						fx.movetype = MOVETYPE_NONE;
						fx.alpha = PLAT_LOW_TRIGGER;
						if (darkplaces)
						{
							fx.effects = EF_NODEPTHTEST;
						}
						fx.think = efxflashe_think;
						fx.nextthink = time;
						fx.solid = SOLID_NOT;
						sprite_count = sprite_count + PLAT_LOW_TRIGGER;
					}
					else
					{
						effect = spawn();
						setorigin(effect, head.origin + v_up * SVC_SPAWNBASELINE);
						setmodel(effect, "progs/jhit.spr");
						effect.movetype = MOVETYPE_NONE;
						effect.think = fx_think;
						if (darkplaces)
						{
							effect.effects = EF_NODEPTHTEST;
						}
						effect.nextthink = time;
						effect.solid = SOLID_NOT;
						sound(self, CHAN_WEAPON, "player/jmphit.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
						sprite_count = sprite_count + PLAT_LOW_TRIGGER;
					}
				}
				else
				{
					if (self.aircombo_count != TE_LIGHTNING2 || deathmatch == 1)
					{
						if (sprite_count < TE_LAVASPLASH)
						{
							effect = spawn();
							setorigin(effect, head.origin);
							setmodel(effect, "progs/block.spr");
							if (darkplaces)
							{
								effect.effects = EF_NODEPTHTEST;
							}
							effect.movetype = MOVETYPE_NONE;
							effect.think = fx_think;
							effect.nextthink = time;
							effect.solid = SOLID_NOT;
							sprite_count = sprite_count + PLAT_LOW_TRIGGER;
						}
						if (head.classname == "player")
						{
							if (self.angles_y > 90 && self.angles_y < 270)
							{
								head.angles_y = STATE_TOP;
							}
							else
							{
								head.angles_y = 180;
							}
							head.effects = EF_MUZZLEFLASH;
							head.think = player_block;
							head.nextthink = time + 0.1;
							head.counter_finished = time + 0.5;
						}
						self.velocity_z = 270;
						sound(head, CHAN_BODY, "player/block.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
						self.enemy = head;
						player_hsblked();
						return;
					}
				}
				if (self.owner.zoom_mode != PLAT_LOW_TRIGGER)
				{
					self.owner.zoom_mode = PLAT_LOW_TRIGGER;
				}
				head.nopain_time = time + 0.3;
				if (deathmatch == 0)
				{
					combo = combo + PLAT_LOW_TRIGGER;
				}
				else
				{
					self.owner.dm_combo = self.owner.dm_combo + PLAT_LOW_TRIGGER;
				}
				self.owner.screenflash_finished = time + 0.1;
				if (head.noblood == 0)
				{
					ThrowBloodSplat(no, head.origin, head);
					ThrowBloodSplat(no, head.origin, head);
					ThrowBloodSplat(no, head.origin, head);
					ThrowBloodSplat(no, head.origin, head);
				}
				if (head.classname == "breakable")
				{
					T_Damage(head, self, self, 50);
				}
				else
				{
					if (self.aircombo_count == TE_LIGHTNING2)
					{
						head.knockback = TE_LIGHTNING1;
						head.damage_type = IT_RELIC2;
						self.attack_type = IT_RELIC2;
						if (deathmatch == 1)
						{
							T_Damage(head, self, self, SVC_PARTICLE);
						}
						else
						{
							T_Damage(head, self, self, 50);
						}
					}
					else
					{
						head.knockback = AS_MELEE;
						head.damage_type = TE_LIGHTNING1;
						self.attack_type = TE_LIGHTNING1;
						if (deathmatch == 1)
						{
							T_Damage(head, self, self, TE_LAVASPLASH);
						}
						else
						{
							T_Damage(head, self, self, SVC_INTERMISSION);
						}
					}
				}
				if (deathmatch == 0)
				{
					self.owner.ammo_shells = self.owner.ammo_shells + AS_MELEE;
				}
				else
				{
					self.owner.ammo_shells = self.owner.ammo_shells + TE_LIGHTNING2;
				}
			}
		}
		head = head.chain;
	}
	if (self.onground == 1)
	{
		jumpatk_grounded();
		player_jumpatk3();
		self.owner.camshake_finished = time + 0.2;
		sound(self, CHAN_WEAPON, "player/jmpflor.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
		return;
	}
	UnmakeSolidList();
	self.velocity_y = STATE_TOP;
	self.owner.shadow_time = time + 0.1;
};

void() player_jumpatk3 = [92, player_jumpatk4]
{
	self.speedline_time = time;
	model_tilt();
	self.nextthink = time + 0.3;
};

void() player_jumpatk4 = [107, player_move]
{
	self.speedline_time = time;
	self.nextthink = time + 0.2;
};

void() airuppercut = 
{
	local entity head;
	local entity effect;
	local vector dir;
	local entity spark;
	local entity oself;
	head = searchradius(self.origin + v_forward * IT_RELIC4 + v_up * SVC_SPAWNSTATIC, 40);
	while (head)
	{
		if (head.takedamage && head != self && visible(head) && (coop == 1 && head.classname != "player" && self.classname == "player" || (coop == 0 || (self.flags & FL_MONSTER))))
		{
			if (head.th_pain)
			{
				if (head.block_finished < time)
				{
					if (sprite_count < TE_LIGHTNING1)
					{
						effect = spawn();
						setorigin(effect, head.origin + v_up * SVC_SPAWNBASELINE);
						setmodel(effect, "progs/jhit.spr");
						effect.movetype = MOVETYPE_NONE;
						effect.think = fx_think;
						if (darkplaces)
						{
							effect.effects = EF_NODEPTHTEST;
						}
						effect.nextthink = time;
						effect.solid = SOLID_NOT;
						sprite_count = sprite_count + PLAT_LOW_TRIGGER;
					}
					if (self.owner.zoom_mode != PLAT_LOW_TRIGGER)
					{
						self.owner.zoom_mode = PLAT_LOW_TRIGGER;
					}
					sound(self, CHAN_WEAPON, "player/bigcut.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
					if (head.noblood == 0)
					{
						ThrowBloodSplat(dir, head.origin, head);
						ThrowBloodSplat(dir, head.origin, head);
					}
					head.aircombo_finished = time + 0.5;
					head.paincount = STATE_TOP;
					head.knockback = IT_RELIC3;
					if (deathmatch == 0)
					{
						T_Damage(head, self, self, TE_WIZSPIKE);
					}
					else
					{
						T_Damage(head, self, self, IT_RELIC2);
					}
					if (deathmatch == 0)
					{
						self.owner.ammo_shells = self.owner.ammo_shells + PLAT_LOW_TRIGGER;
						combo = combo + PLAT_LOW_TRIGGER;
					}
					else
					{
						self.owner.ammo_shells = self.owner.ammo_shells + AS_MELEE;
						self.owner.dm_combo = self.owner.dm_combo + PLAT_LOW_TRIGGER;
					}
				}
				else
				{
					if (head.solid != SOLID_BSP)
					{
						if (self.angles_y > 90 && self.angles_y < 270)
						{
							head.angles_y = STATE_TOP;
						}
						else
						{
							head.angles_y = 180;
						}
					}
					if (sprite_count < TE_LAVASPLASH)
					{
						effect = spawn();
						setorigin(effect, head.origin);
						setmodel(effect, "progs/block.spr");
						if (darkplaces)
						{
							effect.effects = EF_NODEPTHTEST;
						}
						effect.movetype = MOVETYPE_NONE;
						effect.think = fx_think;
						effect.nextthink = time;
						effect.solid = SOLID_NOT;
						sprite_count = sprite_count + PLAT_LOW_TRIGGER;
					}
					spark = spawn();
					spark.angles_y = random() * 360;
					makevectors(spark.angles);
					spark.velocity = v_forward * 100;
					spark.velocity_z = 100;
					spark.owner = head;
					spark.movetype = MOVETYPE_BOUNCE;
					spark.solid = SOLID_NOT;
					spark.classname = "spark";
					setmodel(spark, "progs/null.spr");
					setsize(spark, no, no);
					makevectors(head.angles);
					setorigin(spark, head.origin + v_forward * SVC_LIGHTSTYLE);
					spark.attack_finished = time + 0.8;
					spark.think = sparkeffect;
					spark.nextthink = time + 0.010000;
					if (!(self.flags & FL_ONGROUND))
					{
						if (head.flags & FL_MONSTER)
						{
							head.knockback = IT_RELIC3;
							oself = self;
							self = head;
							monster_pain(oself);
							self = oself;
							head.aircombo_finished = time + 0.5;
							self.velocity_x = head.velocity_x;
							self.velocity_z = STATE_TOP;
							self.velocity_z = head.velocity_z = self.velocity_z + 150;
						}
					}
					sound(self, CHAN_BODY, "player/block.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
				}
			}
		}
		head = head.chain;
	}
	if (self.owner.walljump == 1)
	{
		self.owner.walljump = 0;
	}
	self.velocity = no;
	self.velocity_z = 150;
	if (self.angles_y == STATE_TOP)
	{
		self.velocity_x = self.speed * 1.3;
	}
	else
	{
		if (self.angles_y == 180)
		{
			self.velocity_x = STATE_TOP - self.speed * 1.3;
		}
	}
};

void() player_airuppercut1 = [101, player_airuppercut2]
{
	frameskip(0.05);
	player_yell();
};

void() player_airuppercut2 = [102, player_airuppercut3]
{
	frameskip(0.05);
	sound(self, CHAN_AUTO, "player/motion1.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
};

void() player_airuppercut3 = [103, player_airuppercut4]
{
	airuppercut();
};

void() player_airuppercut4 = [103, player_airuppercut5]
{
	airuppercut();
};

void() player_airuppercut5 = [103, player_airuppercut6]
{
	airuppercut();
};

void() player_airuppercut6 = [104, player_airuppercut7]
{
	self.velocity_x = STATE_TOP;
};

void() player_airuppercut7 = [105, player_move]
{
};

void() player_jumpatkb1 = [93, player_move]
{
	if (self.onground == 1)
	{
		player_move();
	}
	FireMelee(TE_LAVASPLASH, SVC_SIGNONNUM, PLAT_LOW_TRIGGER, SVC_SIGNONNUM, PLAT_LOW_TRIGGER, STATE_TOP, STATE_TOP);
	sound(self, CHAN_AUTO, "player/motion1.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
};

void() player_jumpatkb2 = [94, player_jumpatkb3]
{
	if (self.onground == 1)
	{
		player_move();
	}
	frameskip(0.05);
};

void() player_jumpatkb3 = [95, player_move]
{
	if (self.onground == 1)
	{
		player_move();
	}
	FireMelee(TE_LAVASPLASH, SVC_SIGNONNUM, PLAT_LOW_TRIGGER, SVC_SIGNONNUM, PLAT_LOW_TRIGGER, STATE_TOP, STATE_TOP);
	self.nextthink = time + 0.2;
	sound(self, CHAN_AUTO, "player/motion2.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
};

void() player_jumpatkb4 = [96, player_jumpatkb5]
{
	if (self.onground == 1)
	{
		player_move();
	}
	frameskip(0.030000);
};

void() player_jumpatkb5 = [97, player_jumpatkb6]
{
	if (self.onground == 1)
	{
		player_move();
	}
	frameskip(0.030000);
};

void() player_jumpatkb6 = [98, player_jumpatkb7]
{
	if (self.onground == 1)
	{
		player_move();
	}
	frameskip(0.030000);
};

void() player_jumpatkb7 = [99, player_jumpatkb8]
{
	if (self.onground == 1)
	{
		player_move();
	}
	frameskip(0.030000);
};

void() player_jumpatkb8 = [100, player_move]
{
	if (self.onground == 1)
	{
		player_move();
	}
	sound(self, CHAN_WEAPON, "player/sword.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	FireMelee(SVC_CLIENTDATA, SVC_SIGNONNUM, PLAT_LOW_TRIGGER, SVC_INTERMISSION, STATE_TOP, STATE_TOP, STATE_TOP);
};

void() PainSound = 
{
	local float rs;
	rs = rint(random() * AS_MELEE + PLAT_LOW_TRIGGER);
	self.noise = "";
	if (rs == PLAT_LOW_TRIGGER)
	{
		self.noise = "player/pain1.wav";
	}
	else
	{
		if (rs == IT_RELIC2)
		{
			self.noise = "player/pain2.wav";
		}
		else
		{
			if (rs == AS_MELEE)
			{
				self.noise = "player/pain3.wav";
			}
			else
			{
				self.noise = "player/pain4.wav";
			}
		}
	}
	sound(self, CHAN_VOICE, self.noise, PLAT_LOW_TRIGGER, ATTN_NORM);
	return;
};

void() player_hit1 = [106, player_move]
{
	if (deathmatch == 1)
	{
		self.nextthink = time + 0.5;
		return;
	}
	if (self.armorlevel == STATE_TOP)
	{
		self.nextthink = time + PLAT_LOW_TRIGGER;
	}
	else
	{
		if (self.armorlevel == PLAT_LOW_TRIGGER)
		{
			self.nextthink = time + 0.7;
		}
		else
		{
			if (self.armorlevel == IT_RELIC2)
			{
				self.nextthink = time + 0.5;
			}
			else
			{
				if (self.armorlevel == AS_MELEE)
				{
					self.nextthink = time + 0.3;
				}
			}
		}
	}
};

void() player_hit2 = [107, player_move]
{
	if (deathmatch == 1)
	{
		self.nextthink = time + 0.5;
		return;
	}
	if (self.armorlevel == STATE_TOP)
	{
		self.nextthink = time + PLAT_LOW_TRIGGER;
	}
	else
	{
		if (self.armorlevel == PLAT_LOW_TRIGGER)
		{
			self.nextthink = time + 0.7;
		}
		else
		{
			if (self.armorlevel == IT_RELIC2)
			{
				self.nextthink = time + 0.5;
			}
			else
			{
				if (self.armorlevel == AS_MELEE)
				{
					self.nextthink = time + 0.3;
				}
			}
		}
	}
};

void() player_hit3 = [108, player_hit4]
{
	self.angles_z = STATE_TOP;
	self.nextthink = time + 0.3;
	if (!deathmatch)
	{
		self.takedamage = DAMAGE_NO;
	}
};

void() player_hit4 = [109, player_hit4]
{
	self.angles_x = STATE_TOP;
	makevectors(self.angles);
	traceline(self.origin, self.origin - v_forward * SVC_UPDATECOLORS, 0, self);
	if (trace_fraction < PLAT_LOW_TRIGGER && trace_ent.solid == SOLID_BSP)
	{
		PainSound();
		self.takedamage = DAMAGE_NO;
		self.wallhit_count = STATE_TOP;
		player_walled2();
		return;
	}
	if (self.onground == 1)
	{
		PainSound();
		self.takedamage = DAMAGE_NO;
		player_hit5();
	}
};

void() player_knockedup1 = [242, player_knockedup1]
{
	if (self.velocity_z > STATE_TOP)
	{
		self.angles_x = -90;
	}
	else
	{
		if (self.angles_x < 90)
		{
			self.angles_x = self.angles_x + TE_LIGHTNING2;
		}
	}
	if (self.onground == 1)
	{
		PainSound();
		sound(self, CHAN_BODY, "player/jmpflor.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
		self.angles_x = STATE_TOP;
		player_hit4();
		return;
	}
	frameskip(0.010000);
};

void() player_knockedfar1 = [242, player_knockedfar1]
{
	local vector v;
	v = self.angles;
	v_x = STATE_TOP;
	makevectors(v);
	traceline(self.origin, self.origin - v_forward * SVC_UPDATECOLORS, 0, self);
	if (trace_fraction < PLAT_LOW_TRIGGER && trace_ent.solid == SOLID_BSP)
	{
		PainSound();
		self.wallhit_count = STATE_TOP;
		self.takedamage = DAMAGE_NO;
		player_walled2();
		return;
	}
	if (self.velocity_z > STATE_TOP)
	{
		self.angles_x = -45;
	}
	else
	{
		if (self.angles_x < 90)
		{
			self.angles_x = self.angles_x + AS_MELEE;
		}
	}
	if (self.onground == 1)
	{
		PainSound();
		sound(self, CHAN_BODY, "player/jmpflor.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
		self.angles_x = STATE_TOP;
		player_hit4();
		return;
	}
	frameskip(0.010000);
};

void() player_walled2 = [243, player_walled2]
{
	if (self.wallhit_count >= IT_RELIC4)
	{
		self.movetype = MOVETYPE_STEP;
		player_walled3();
		self.wallhit_count = STATE_TOP;
		return;
	}
	else
	{
		self.owner.softshadow_time = time;
		self.movetype = MOVETYPE_NONE;
		self.angles_x = STATE_TOP;
		self.angles_z = STATE_TOP;
		self.velocity = no;
		if (self.wallhit_count == PLAT_LOW_TRIGGER)
		{
			sound(self, CHAN_BODY, "player/jmpflor.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
		}
		self.wallhit_count = self.wallhit_count + PLAT_LOW_TRIGGER;
	}
	frameskip(0.1);
};

void() player_walled4 = [246, player_getupb1]
{
	model_tilt();
	self.owner.softshadow_time = time;
	self.angles_z = STATE_TOP;
	self.angles_x = STATE_TOP;
	self.nextthink = time + 0.5;
};

void() player_walled3 = [0, player_walled3]
{
	if (self.angles_x > -90)
	{
		self.angles_x = self.angles_x - AS_MELEE;
	}
	if (self.walkframe > PLAT_LOW_TRIGGER)
	{
		self.walkframe = STATE_TOP;
	}
	self.frame = 244 + self.walkframe;
	self.walkframe = self.walkframe + PLAT_LOW_TRIGGER;
	if (self.onground == 1)
	{
		PainSound();
		self.takedamage = DAMAGE_NO;
		player_walled4();
		sound(self, CHAN_BODY, "player/owhit.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
		return;
	}
	frameskip(0.010000);
};

void() player_twist = [241, player_twist]
{
	local vector v;
	if (self.velocity_z > STATE_TOP)
	{
		self.angles_x = -25;
	}
	else
	{
		if (self.angles_x < 45)
		{
			self.angles_x = self.angles_x + PLAT_LOW_TRIGGER;
		}
	}
	self.angles_z = self.angles_z + SVC_SPAWNSTATIC;
	if (self.onground == 1)
	{
		PainSound();
		self.takedamage = DAMAGE_NO;
		if (random() < 0.5)
		{
			player_hit3();
			sound(self, CHAN_BODY, "player/jmpflor.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
		}
		else
		{
			if (self.angles_y > 90 && self.angles_y < 270)
			{
				self.angles_y = STATE_TOP;
			}
			else
			{
				self.angles_y = 180;
			}
			player_walled4();
			sound(self, CHAN_BODY, "player/owhit.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
			return;
		}
	}
	v = self.angles;
	v_x = v_x + SVC_SIGNONNUM;
	makevectors(v);
	traceline(self.origin, self.origin - v_forward * SVC_UPDATECOLORS, 0, self);
	if (trace_fraction < PLAT_LOW_TRIGGER && trace_ent.solid == SOLID_BSP)
	{
		PainSound();
		self.takedamage = DAMAGE_NO;
		self.wallhit_count = STATE_TOP;
		player_walled2();
	}
	frameskip(0.010000);
};

void() player_getup1 = [111, player_getup2]
{
	self.getup_finished = time + 0.5;
	self.angles_z = STATE_TOP;
};

void() player_getup2 = [112, player_getup3]
{
};

void() player_getup3 = [113, player_getup4]
{
};

void() player_getup4 = [114, player_getup5]
{
	self.pain_finished = time;
};

void() player_getup5 = [115, player_move]
{
};

void() player_hit5 = [110, player_getup1]
{
	model_tilt();
	self.owner.softshadow_time = time;
	self.nextthink = time + 0.7;
};

void() player_getupb1 = [247, player_getupb2]
{
	self.getup_finished = time + 0.5;
	self.angles_z = STATE_TOP;
};

void() player_getupb2 = [248, player_getupb3]
{
};

void() player_getupb3 = [249, player_getupb4]
{
	self.pain_finished = time;
};

void() player_getupb4 = [115, player_move]
{
};

void() player_pain = 
{
	local float rs;
	makevectors(self.angles);
	self.owner.camerastyle = STATE_TOP;
	self.owner.goalentity = self;
	self.owner.shadow_time = time;
	self.owner.ledgegrab = 0;
	self.owner.swordshadow_time = time;
	self.owner.wallrun = 0;
	self.block_finished = time;
	self.angles_z = STATE_TOP;
	self.angles_x = STATE_TOP;
	self.movetype = MOVETYPE_STEP;
	self.charge_count = STATE_TOP;
	self.owner.zoom_mode = STATE_TOP;
	self.beams_shot = STATE_TOP;
	rs = random() * 100;
	if (self.angles_y > 90 && self.angles_y < 270)
	{
		self.angles_y = 180;
	}
	else
	{
		self.angles_y = STATE_TOP;
	}
	if (self.enemy != world && deathmatch == 0)
	{
		self.enemy.grabbed = 0;
	}
	self.tired_finished = time;
	self.owner.magicmenu = 0;
	if (self.flypain)
	{
		return;
	}
	PainSound();
	if (deathmatch == 1)
	{
		if (self.knockback == STATE_TOP)
		{
			if (random() < 0.5)
			{
				player_hit1();
			}
			else
			{
				player_hit2();
			}
			self.pain_finished = time + 0.8;
		}
		if (self.knockback == PLAT_LOW_TRIGGER)
		{
			if (self.onground == 0)
			{
				if (random() < 0.5)
				{
					player_hit1();
				}
				else
				{
					player_hit2();
				}
				self.pain_finished = time + 1.3;
			}
			else
			{
				self.think = player_knockedfar1;
				self.nextthink = time + 0.1;
				self.pain_finished = time + 999;
				self.velocity = no;
				self.flags = self.flags - (self.flags & FL_ONGROUND);
				self.velocity = self.velocity - TE_LIGHTNING3 * v_forward * IT_RELIC4;
				self.velocity = self.velocity + 90 * '0 0 3';
			}
		}
		else
		{
			if (self.knockback == IT_RELIC2 || self.knockback == AS_MELEE || self.knockback == TE_LIGHTNING1)
			{
				self.owner.softshadow_time = time + 999;
				if (self.knockback == IT_RELIC2)
				{
					self.think = player_knockedup1;
					self.nextthink = time + 0.1;
				}
				else
				{
					if (self.knockback == AS_MELEE)
					{
						self.think = player_twist;
						self.nextthink = time + 0.1;
					}
					else
					{
						if (self.knockback == TE_LIGHTNING1)
						{
							self.think = player_knockedfar1;
							self.nextthink = time + 0.1;
						}
						else
						{
							player_hit3();
						}
					}
				}
				self.pain_finished = time + 999;
			}
			else
			{
				if (self.knockback == IT_RELIC3)
				{
					if (self.onground == 0)
					{
						player_knockedup1();
					}
					else
					{
						if (random() < 0.5)
						{
							player_hit1();
						}
						else
						{
							player_hit2();
						}
					}
					self.pain_finished = time + PLAT_LOW_TRIGGER;
				}
			}
		}
		return;
	}
	if (self.airdamage_finished > time)
	{
		if (random() < 0.5)
		{
			self.paincount = STATE_TOP;
		}
		else
		{
			self.paincount = PLAT_LOW_TRIGGER;
		}
	}
	if (self.paincount == STATE_TOP)
	{
		player_hit1();
		if (self.armorlevel == STATE_TOP)
		{
			self.pain_finished = time + PLAT_LOW_TRIGGER;
		}
		else
		{
			if (self.armorlevel == PLAT_LOW_TRIGGER)
			{
				self.pain_finished = time + 0.7;
			}
			else
			{
				if (self.armorlevel == IT_RELIC2)
				{
					self.pain_finished = time + 0.5;
				}
				else
				{
					if (self.armorlevel == AS_MELEE)
					{
						self.pain_finished = time + 0.3;
					}
				}
			}
		}
	}
	if (self.paincount == PLAT_LOW_TRIGGER)
	{
		player_hit2();
		if (self.armorlevel == STATE_TOP)
		{
			self.pain_finished = time + PLAT_LOW_TRIGGER;
		}
		else
		{
			if (self.armorlevel == PLAT_LOW_TRIGGER)
			{
				self.pain_finished = time + 0.7;
			}
			else
			{
				if (self.armorlevel == IT_RELIC2)
				{
					self.pain_finished = time + 0.5;
				}
				else
				{
					if (self.armorlevel == AS_MELEE)
					{
						self.pain_finished = time + 0.3;
					}
				}
			}
		}
	}
	if (self.paincount == IT_RELIC2)
	{
		if (self.knockback == PLAT_LOW_TRIGGER)
		{
			self.think = player_knockedfar1;
			self.nextthink = time + 0.1;
		}
		else
		{
			if (self.knockback == IT_RELIC2)
			{
				self.velocity_x = STATE_TOP;
				self.think = player_knockedup1;
				self.nextthink = time + 0.1;
			}
			else
			{
				if (self.knockback == AS_MELEE)
				{
					self.think = player_twist;
					self.nextthink = time + 0.1;
				}
				else
				{
					if (self.knockback == IT_RELIC3)
					{
						self.think = player_knockedup1;
						self.nextthink = time + 0.1;
					}
					else
					{
						if (self.knockback == TE_LIGHTNING1)
						{
							self.think = player_knockedfar1;
							self.nextthink = time + 0.1;
						}
						else
						{
							player_hit3();
							self.velocity = no;
							self.flags = self.flags - (self.flags & FL_ONGROUND);
							self.velocity = self.velocity - TE_LIGHTNING3 * v_forward * IT_RELIC4;
							self.velocity = self.velocity + 90 * '0 0 3';
						}
					}
				}
			}
		}
		self.pain_finished = time + 999;
		self.owner.softshadow_time = time + 999;
		self.flypain = 1;
	}
	self.attack_finished = time;
	self.owner.attack_finished = time;
	self.paincount = self.paincount + PLAT_LOW_TRIGGER;
};

void() player_die1 = [108, player_die2]
{
	self.angles_x = STATE_TOP;
};

void() player_die2 = [109, player_die2]
{
	self.angles_x = STATE_TOP;
	if (self.onground == 1)
	{
		player_die3();
	}
};

void() player_die3 = [110, player_die3]
{
	local string h;
	model_tilt();
	if (self.owner.armorvalue > STATE_TOP)
	{
		self.respawn_count = self.respawn_count + PLAT_LOW_TRIGGER;
		if (self.respawn_count >= SVC_SIGNONNUM)
		{
			if (self.tired_finished > time)
			{
				self.tired_finished = time;
			}
			Respawn_Dummy();
			self.respawn_count = STATE_TOP;
		}
	}
	else
	{
		h = ftos(self.owner.score);
		if (deathmatch == 0)
		{
			if (self.scorecalc == 0)
			{
				if (killed_monsters > STATE_TOP)
				{
					self.owner.score = self.owner.score + self.owner.level * AS_MELEE * (killed_monsters * TE_LAVASPLASH);
				}
				self.scorecalc = 1;
			}
			centerprint4(self.owner, "Çáíå ïöåò\n………… …………\n\nYou have been vanquished by the enemy ...\n\n", "Æéîáì Óãïòåº ", h, "‘\n");
		}
		else
		{
			if (self.respawn_count == STATE_TOP)
			{
				sprint(self.owner, "Your current score is: ");
				sprint(self.owner, h);
				sprint(self.owner, "\n");
			}
			if (self.respawn_count >= SVC_SIGNONNUM)
			{
				if (self.tired_finished > time)
				{
					self.tired_finished = time;
				}
				Respawn_Dummy();
				self.owner.armorvalue = PLAT_LOW_TRIGGER;
				self.respawn_count = STATE_TOP;
			}
			self.respawn_count = self.respawn_count + PLAT_LOW_TRIGGER;
		}
	}
};

void() player_die = 
{
	if (self.angles_y == 45 || self.angles_y == -45)
	{
		self.angles_y = STATE_TOP;
	}
	if (self.angles_y == 225 || self.angles_y == -225)
	{
		self.angles_y = 180;
	}
	if (self.movetype != MOVETYPE_STEP)
	{
		self.movetype = MOVETYPE_STEP;
	}
	self.angles_z = STATE_TOP;
	self.owner.magicmenu = 0;
	self.pain_finished = time + 999;
	self.takedamage = DAMAGE_NO;
	if (deathmatch)
	{
		self.flypain = 1;
		self.deadflag = DEAD_DEAD;
	}
	self.velocity = no;
	sound(self, CHAN_VOICE, "player/death.wav", PLAT_LOW_TRIGGER, ATTN_NONE);
	if (self.pitdeath == 0)
	{
		self.flags = self.flags - (self.flags & FL_ONGROUND);
		self.velocity = self.velocity + TE_LIGHTNING3 * v_forward * IT_RELIC4;
		self.velocity = self.velocity + 90 * '0 0 3';
	}
	player_die1();
};

void() player_block1 = [134, player_block1]
{
	if (self.angles_x != STATE_TOP)
	{
		self.angles_x = STATE_TOP;
	}
	if (self.angles_y == 360)
	{
		self.angles_y = STATE_TOP;
	}
	if (self.block_finished < time)
	{
		player_move();
	}
	if (self.onground == 0)
	{
		player_block3();
	}
};

void() player_block2 = [135, player_block2]
{
	if (self.angles_x != STATE_TOP)
	{
		self.angles_x = STATE_TOP;
	}
	if (self.angles_y == 360)
	{
		self.angles_y = STATE_TOP;
	}
	if (self.block_finished < time)
	{
		player_move();
	}
	if (self.onground == 0)
	{
		player_block3();
	}
};

void() player_block3 = [136, player_block3]
{
	if (self.onground == 1)
	{
		player_block2();
		if (self.angles_y == 45 || self.angles_y == -45)
		{
			self.angles_y = STATE_TOP;
		}
		if (self.angles_y == 225 || self.angles_y == -225)
		{
			self.angles_y = 180;
		}
	}
	if (self.block_finished < time)
	{
		player_move();
	}
};

void() player_blockbrk_movement = 
{
	local entity effect;
	makevectors(self.angles);
	if (self.onground == 1)
	{
		if (sprite_count < TE_LIGHTNING1)
		{
			if (random() < 0.5)
			{
				effect = spawn();
				setorigin(effect, self.origin - v_up * IT_RELIC5 - v_forward * SVC_SETPAUSE);
				setmodel(effect, "progs/dust.spr");
				effect.solid = SOLID_NOT;
				effect.owner = self;
				effect.movetype = MOVETYPE_FLY;
				effect.velocity_z = 100;
				effect.think = dust_think;
				effect.nextthink = time + 0.010000;
				sprite_count = sprite_count + PLAT_LOW_TRIGGER;
			}
			else
			{
				effect = spawn();
				setorigin(effect, self.origin - v_up * IT_RELIC5 + v_forward * IT_RELIC3);
				setmodel(effect, "progs/dust.spr");
				effect.solid = SOLID_NOT;
				effect.owner = self;
				effect.movetype = MOVETYPE_FLY;
				effect.velocity_z = 100;
				effect.think = dust_think;
				effect.nextthink = time + 0.010000;
				sprite_count = sprite_count + PLAT_LOW_TRIGGER;
			}
		}
	}
	self.block_finished = time;
	self.owner.noblock_finished = time + 0.2;
	self.guardbreak_finished = time + 0.2;
	self.velocity_time = time + 0.2;
	self.velocity_y = STATE_TOP;
	if (self.angles_y == 180)
	{
		self.velocity_x = self.speed * IT_RELIC2;
	}
	else
	{
		if (self.angles_y == STATE_TOP)
		{
			self.velocity_x = STATE_TOP - self.speed * IT_RELIC2;
		}
	}
	self.flags = self.flags - (self.flags & FL_ONGROUND);
};

void() player_blockbrk1 = [251, player_blockbrk2]
{
	player_blockbrk_movement();
	if (self.onground == 1)
	{
		sound(self, CHAN_BODY, "player/skid.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	}
	PainSound();
};

void() player_blockbrk2 = [251, player_blockbrk3]
{
	player_blockbrk_movement();
};

void() player_blockbrk3 = [252, player_blockbrk4]
{
	player_blockbrk_movement();
};

void() player_blockbrk4 = [253, player_blockbrk5]
{
};

void() player_blockbrk5 = [254, player_block]
{
};

void() player_block = 
{
	if (self.onground == 1)
	{
		if (random() < 0.5)
		{
			player_block1();
		}
		else
		{
			player_block2();
		}
	}
	else
	{
		player_block3();
	}
};

void() player_fireball1 = [121, player_fireball2]
{
	spawn_magicfog();
};

void() player_fireball2 = [122, player_move]
{
	self.angles_y = self.turn_y;
	Fireball(SVC_CLIENTDATA, SVC_UPDATECOLORS);
	Fireball(SVC_CLIENTDATA, SVC_UPDATEFRAGS);
	if (self.owner.ammo_shells >= TE_LAVASPLASH)
	{
		self.owner.ammo_shells = self.owner.ammo_shells - TE_LAVASPLASH;
	}
	else
	{
		if (self.owner.ammo_shells >= TE_LAVASPLASH / 1.5)
		{
			self.owner.ammo_shells = self.owner.ammo_shells - TE_LAVASPLASH / 1.5;
		}
	}
	self.nextthink = time + 0.5;
};

void() player_lightning1 = [117, player_lightning2]
{
	spawn_magicfog();
};

void() player_lightning2 = [118, player_lightning3]
{
	sound(self, CHAN_AUTO, "spells/lightn.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
};

void() player_lightning3 = [119, player_lightning3]
{
	if (self.lcount == STATE_TOP)
	{
		if (self.owner.ammo_shells >= 45)
		{
			self.owner.ammo_shells = self.owner.ammo_shells - 45;
		}
		else
		{
			if (self.owner.ammo_shells >= 45 / 1.5)
			{
				self.owner.ammo_shells = self.owner.ammo_shells - 45 / 1.5;
			}
		}
	}
	if (self.lcount > 50)
	{
		player_lightning4();
	}
	else
	{
		LightningStorm();
	}
	self.lcount = self.lcount + PLAT_LOW_TRIGGER;
	if (self.owner.zoom_mode != IT_RELIC2)
	{
		self.owner.zoom_mode = IT_RELIC2;
	}
};

void() player_lightning4 = [120, player_move]
{
};

void() player_icefield1 = [123, player_icefield1]
{
	local entity effect;
	if (self.owner.zoom_mode != IT_RELIC2)
	{
		self.owner.zoom_mode = IT_RELIC2;
	}
	self.owner.attack_finished = time + 3.5;
	if (self.icefield_count == STATE_TOP)
	{
		spawn_magicfog();
		effect = spawn();
		setorigin(effect, self.origin + v_up * 50);
		setmodel(effect, "progs/chargice.spr");
		effect.movetype = MOVETYPE_NONE;
		effect.solid = SOLID_NOT;
		effect.alpha = 0.2;
		effect.think = chargeice_effect;
		effect.nextthink = time + 0.010000;
		sound(effect, CHAN_AUTO, "spells/charge.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	}
	if (self.icefield_count > TE_WIZSPIKE)
	{
		player_icefield2();
		return;
	}
	self.icefield_count = self.icefield_count + PLAT_LOW_TRIGGER;
};

void() player_icefield2 = [124, player_icefield3]
{
};

void() player_icefield3 = [125, player_icefield4]
{
};

void() player_icefield4 = [126, player_move]
{
	self.owner.noblock_finished = time + 999;
	if (self.owner.ammo_shells >= SVC_INTERMISSION)
	{
		self.owner.ammo_shells = self.owner.ammo_shells - SVC_INTERMISSION;
	}
	else
	{
		if (self.owner.ammo_shells >= SVC_INTERMISSION / 1.5)
		{
			self.owner.ammo_shells = self.owner.ammo_shells - SVC_INTERMISSION / 1.5;
		}
	}
	IceField();
	self.nextthink = time + IT_RELIC2;
};

void() swordstareffect_2 = 
{
	local entity effect;
	effect = spawn();
	effect.owner = self;
	setorigin(effect, self.origin - v_up * SVC_SPAWNBASELINE + v_right * SVC_INTERMISSION);
	setmodel(effect, "progs/star.spr");
	effect.solid = SOLID_NOT;
	effect.movetype = MOVETYPE_NOCLIP;
	effect.think = swordstareffect_think;
	effect.nextthink = time + 0.1;
};

void() player_magicd1 = [127, player_magicd2]
{
	spawn_magicfog();
	self.owner.zoom_mode = PLAT_LOW_TRIGGER;
};

void() player_magicd2 = [128, player_magicd3]
{
};

void() player_magicd3 = [129, player_magicd4]
{
};

void() player_magicd4 = [130, player_magicd5]
{
	sound(self, CHAN_BODY, "player/shwing.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
};

void() player_magicd5 = [131, player_magicd6]
{
	local entity effect;
	makevectors(self.angles);
	effect = spawn();
	setorigin(effect, self.origin);
	setmodel(effect, "progs/chrgebm.spr");
	effect.movetype = MOVETYPE_NONE;
	effect.solid = SOLID_NOT;
	effect.alpha = 0.2;
	effect.think = chargebeam_effect;
	effect.nextthink = time + 0.010000;
	sound(effect, CHAN_AUTO, "spells/charge.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	swordstareffect_2();
	self.nextthink = time + PLAT_LOW_TRIGGER;
};

void() player_magicd6 = [132, player_magicd7]
{
	self.angles_y = self.turn_y;
	self.owner.zoom_mode = IT_RELIC2;
};

void() player_magicd7 = [133, player_magicd7]
{
	if (self.beams_shot == STATE_TOP)
	{
		Firebeam_Muzzle();
		if (self.owner.ammo_shells >= 100)
		{
			self.owner.ammo_shells = self.owner.ammo_shells - 100;
		}
		else
		{
			if (self.owner.ammo_shells >= 100 / 1.5)
			{
				self.owner.ammo_shells = self.owner.ammo_shells - 100 / 1.5;
			}
		}
	}
	if (self.beams_shot < 35)
	{
		Firebeam(TE_LIGHTNING1, SVC_LIGHTSTYLE);
		self.beams_shot = self.beams_shot + PLAT_LOW_TRIGGER;
	}
	else
	{
		self.beams_shot = STATE_TOP;
		player_move();
	}
	self.owner.camshake_finished = time + 0.1;
};

void() player_twister1 = [117, player_twister2]
{
	spawn_magicfog();
};

void() player_twister2 = [118, player_twister3]
{
	sound(self, CHAN_AUTO, "spells/twister.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
};

void() player_twister3 = [119, player_twister3]
{
	if (self.tcount == STATE_TOP)
	{
		if (self.owner.ammo_shells >= 75)
		{
			self.owner.ammo_shells = self.owner.ammo_shells - 75;
		}
		else
		{
			if (self.owner.ammo_shells >= 75 / 1.5)
			{
				self.owner.ammo_shells = self.owner.ammo_shells - 75 / 1.5;
			}
		}
	}
	if (self.tcount > 50)
	{
		player_twister4();
	}
	else
	{
		self.owner.attack_finished = time + PLAT_LOW_TRIGGER;
	}
	if (self.tcount < IT_RELIC3)
	{
		Twister();
	}
	self.tcount = self.tcount + PLAT_LOW_TRIGGER;
	self.owner.noblock_finished = time + 999;
	if (self.owner.zoom_mode != IT_RELIC2)
	{
		self.owner.zoom_mode = IT_RELIC2;
	}
};

void() player_twister4 = [120, player_move]
{
};

void() spark_think = 
{
	particle(self.origin, no, 111, IT_RELIC3);
	if (self.attack_finished < time)
	{
		remove(self);
		return;
	}
	self.nextthink = time + 0.1;
};

void() divingswallow_hit = 
{
	local entity head;
	local entity effect;
	local vector dir;
	makevectors(self.angles);
	head = searchradius(self.origin + v_forward * IT_RELIC5, 40);
	while (head)
	{
		if (head.takedamage && head != self && visible(head) && (coop == 1 && head.classname != "player" && self.classname == "player" || (coop == 0 || (self.flags & FL_MONSTER))))
		{
			if (head.th_pain)
			{
				if (head.noblood == 0)
				{
					ThrowBloodSplat(dir, head.origin, head);
				}
				if (self.owner.wallrun == 0)
				{
					self.bflipwall_finished = time + 0.3;
				}
				head.paincount = STATE_TOP;
				head.velocity = no;
				head.flags = head.flags - (head.flags & FL_ONGROUND);
				head.velocity = self.velocity;
				if (self.aircombo_count == IT_RELIC4)
				{
					if (sprite_count < TE_LIGHTNING1)
					{
						effect = spawn();
						setorigin(effect, head.origin + v_forward * SVC_CLIENTDATA);
						setmodel(effect, "progs/divs_hit.mdl");
						effect.movetype = MOVETYPE_NOCLIP;
						effect.alpha = PLAT_LOW_TRIGGER;
						effect.solid = SOLID_NOT;
						if (self.angles_y != STATE_TOP)
						{
							effect.angles_x = self.angles_x * CONTENT_EMPTY;
						}
						else
						{
							effect.angles_x = self.angles_x;
						}
						effect.think = divingshit_think;
						effect.nextthink = time;
						sprite_count = sprite_count + PLAT_LOW_TRIGGER;
					}
					head.knockback = TE_LIGHTNING1;
					self.owner.camshake_finished = time + 0.2;
					sound(self, CHAN_WEAPON, "player/hugekick.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
					self.owner.screenflash_finished = time + 0.1;
					if (deathmatch == 0)
					{
						T_Damage(head, self, self, SVC_SIGNONNUM);
					}
					else
					{
						T_Damage(head, self, self, IT_RELIC4);
					}
					if (deathmatch == 0)
					{
						self.owner.ammo_shells = self.owner.ammo_shells + AS_MELEE;
					}
					else
					{
						self.owner.ammo_shells = self.owner.ammo_shells + TE_LIGHTNING2;
					}
					self.think = player_bflip1;
					self.owner.backflip_finished = time + 0.7;
				}
				else
				{
					if (sprite_count < TE_LIGHTNING1)
					{
						effect = spawn();
						setorigin(effect, head.origin + v_up * SVC_SPAWNBASELINE);
						setmodel(effect, "progs/jhit.spr");
						effect.movetype = MOVETYPE_NONE;
						effect.think = fx_think;
						if (darkplaces)
						{
							effect.effects = EF_NODEPTHTEST;
						}
						effect.nextthink = time;
						effect.solid = SOLID_NOT;
						sprite_count = sprite_count + PLAT_LOW_TRIGGER;
					}
					if (deathmatch == 0)
					{
						T_Damage(head, self, self, IT_RELIC4);
					}
					else
					{
						T_Damage(head, self, self, AS_MELEE);
					}
					sound(self, CHAN_WEAPON, "player/kickhit.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
					if (deathmatch == 0)
					{
						self.owner.ammo_shells = self.owner.ammo_shells + PLAT_LOW_TRIGGER;
					}
					else
					{
						self.owner.ammo_shells = self.owner.ammo_shells + IT_RELIC2;
					}
				}
				if (deathmatch == 0)
				{
					combo = combo + PLAT_LOW_TRIGGER;
				}
				else
				{
					self.owner.dm_combo = self.owner.dm_combo + PLAT_LOW_TRIGGER;
				}
			}
		}
		head = head.chain;
	}
};

void() player_walljumpkickslide = [107, player_walljumpkickslide]
{
	local entity effect;
	if (self.runatk_speed > SVC_CLIENTDATA)
	{
		player_move();
		return;
	}
	makevectors(self.angles);
	if (self.onground == 1)
	{
		if (sprite_count < TE_LIGHTNING1)
		{
			if (random() < 0.5)
			{
				effect = spawn();
				setorigin(effect, self.origin - v_up * IT_RELIC5 - v_forward * SVC_SETPAUSE);
				setmodel(effect, "progs/dust.spr");
				effect.solid = SOLID_NOT;
				effect.owner = self;
				effect.movetype = MOVETYPE_FLY;
				effect.velocity_z = 100;
				effect.think = dust_think;
				effect.nextthink = time + 0.010000;
				sprite_count = sprite_count + PLAT_LOW_TRIGGER;
			}
			else
			{
				effect = spawn();
				setorigin(effect, self.origin - v_up * IT_RELIC5 + v_forward * IT_RELIC3);
				setmodel(effect, "progs/dust.spr");
				effect.solid = SOLID_NOT;
				effect.owner = self;
				effect.movetype = MOVETYPE_FLY;
				effect.velocity_z = 100;
				effect.think = dust_think;
				effect.nextthink = time + 0.010000;
				sprite_count = sprite_count + PLAT_LOW_TRIGGER;
			}
		}
	}
	self.velocity_time = time + 0.2;
	self.owner.attack_finished = time + 0.2;
	self.runatk_speed = self.runatk_speed + TE_LIGHTNING1;
	model_tilt();
	if (self.angles_y == STATE_TOP)
	{
		self.velocity_x = self.speed * IT_RELIC2 - self.runatk_speed;
	}
	else
	{
		if (self.angles_y == 180)
		{
			self.velocity_x = STATE_TOP - self.speed * IT_RELIC2 + self.runatk_speed;
		}
	}
	self.velocity_y = STATE_TOP;
	while (!walkmove(self.angles_y, self.speed * frametime) && runaway < 100)
	{
		runaway = runaway + PLAT_LOW_TRIGGER;
	}
};

void() player_walljumpkick1 = [93, player_walljumpkick1]
{
	self.owner.noblock_finished = time + TE_LIGHTNING1;
	if (self.angles_y == STATE_TOP)
	{
		self.velocity_x = 500;
	}
	else
	{
		self.velocity_x = -500;
	}
	self.velocity_z = -250;
	self.owner.zoom_mode = IT_RELIC2;
	divingswallow_hit();
	self.owner.attack_finished = time + 0.2;
	self.owner.shadow_time = time + 0.1;
	makevectors(self.angles);
	traceline(self.origin, self.origin + v_forward * SVC_SPAWNSTATIC, 1, self);
	if (trace_fraction < PLAT_LOW_TRIGGER && trace_ent.solid == SOLID_BSP && self.divingswallow_wallcheck_finished < time)
	{
		self.owner.backflip_finished = time + 0.7;
		player_bflip1();
		self.aircombo_count = STATE_TOP;
	}
	if (self.onground == 1)
	{
		self.angles_x = STATE_TOP;
		player_walljumpkickslide();
		sound(self, CHAN_BODY, "player/skid.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
		return;
	}
	self.owner.speedline_time = time + 0.2;
	frameskip(0.05);
};

void() player_wallgrab = [137, player_wallgrab]
{
	local entity spark;
	local vector source;
	local vector org;
	self.aircombo_count = STATE_TOP;
	self.owner.softshadow_time = time;
	if (self.owner.wallgrab == 0)
	{
		sound(self, CHAN_WEAPON, "player/wallgrab.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
		self.owner.wallgrab = 1;
		self.attack_finished = time + 0.2;
	}
	if (self.angles_y == 45 || self.angles_y == -45)
	{
		self.angles_y = STATE_TOP;
	}
	if (self.angles_y == 225 || self.angles_y == -225)
	{
		self.angles_y = 180;
	}
	makevectors(self.angles);
	spark = spawn();
	spark.owner = self;
	spark.movetype = MOVETYPE_NOCLIP;
	spark.solid = SOLID_NOT;
	spark.classname = "swordspark";
	setmodel(spark, string_null);
	spark.think = spark_think;
	spark.nextthink = time + 0.1;
	spark.velocity_z = SVC_SIGNONNUM;
	spark.attack_finished = time + 0.4;
	setorigin(spark, self.origin + v_forward * SVC_SPAWNSTATIC);
	if (self.owner.zoom_mode != STATE_TOP)
	{
		self.owner.zoom_mode = STATE_TOP;
	}
	self.velocity = '0 0 15';
	if (self.onground == 1)
	{
		player_move();
	}
	if (self.owner.button0 && self.attack_finished < time && self.invunerability_finished < time && self.safezone == 0)
	{
		self.owner.walljump = 1;
		self.owner.wallgrab = 0;
		self.divingswallow_wallcheck_finished = time + 0.2;
		player_walljumpkick1();
		player_yell();
		if (self.angles_y == STATE_TOP)
		{
			self.velocity_x = -500;
			self.angles_y = 180;
		}
		else
		{
			self.velocity_x = 500;
			self.angles_y = STATE_TOP;
		}
		self.angles_x = -15;
		sound(self, CHAN_BODY, "player/fast.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
		self.velocity_z = 50;
		return;
	}
	if (self.wallsound_finished < time)
	{
		sound(self, CHAN_AUTO, "player/swrdwall.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
		self.wallsound_finished = time + 0.5;
	}
	makevectors(self.angles);
	source = self.origin;
	traceline(source, source + v_forward * 35, 0, self);
	org = trace_endpos + v_up * IT_RELIC3;
	if (trace_fraction == PLAT_LOW_TRIGGER)
	{
		player_move();
		self.owner.wallgrab = 0;
	}
};

void() player_ledgehoist = 
{
	self.velocity = no;
	if (!(deathmatch || coop))
	{
		self.velocity_z = 200;
	}
	else
	{
		self.velocity_z = 250;
	}
	if (self.frame == 194 || self.frame == 195 || self.frame == 196)
	{
		if (self.angles_y == STATE_TOP)
		{
			self.velocity_x = self.speed * AS_MELEE;
		}
		else
		{
			if (self.angles_y == 180)
			{
				self.velocity_x = STATE_TOP - self.speed * AS_MELEE;
			}
		}
	}
};

void() player_ledgeclimb1 = [191, player_ledgeclimb2]
{
	player_ledgehoist();
};

void() player_ledgeclimb2 = [192, player_ledgeclimb3]
{
	player_ledgehoist();
};

void() player_ledgeclimb3 = [193, player_ledgeclimb4]
{
	player_ledgehoist();
};

void() player_ledgeclimb4 = [194, player_ledgeclimb5]
{
	player_ledgehoist();
};

void() player_ledgeclimb5 = [195, player_ledgeclimb6]
{
	player_ledgehoist();
};

void() player_ledgeclimb6 = [196, player_move]
{
	player_ledgehoist();
	self.velocity = no;
	self.owner.noaircontrol_finished = time + 9999;
	self.owner.ledgegrab = 0;
};

void() player_ledgegrab1 = [183, player_ledgegrab1]
{
	self.owner.zoom_mode = PLAT_LOW_TRIGGER;
	if (self.walkframe > TE_WIZSPIKE)
	{
		self.walkframe = STATE_TOP;
	}
	self.frame = 183 + self.walkframe;
	self.walkframe = self.walkframe + PLAT_LOW_TRIGGER;
	if (self.angles_y == 45 || self.angles_y == -45)
	{
		self.angles_y = STATE_TOP;
	}
	if (self.angles_y == 225 || self.angles_y == -225)
	{
		self.angles_y = 180;
	}
	self.velocity = no;
	if (self.attack_finished < time)
	{
		if (self.owner.keyflags & KEY_UP && !(self.owner.keyflags & KEY_LEFT || (self.owner.keyflags & KEY_RIGHT)))
		{
			self.movetype = MOVETYPE_FLY;
			sound(self, CHAN_WEAPON, "player/climb.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
			player_ledgeclimb1();
			return;
		}
		else
		{
			if (self.owner.keyflags & KEY_DOWN && !(self.owner.keyflags & KEY_LEFT || (self.owner.keyflags & KEY_RIGHT)))
			{
				player_move();
				self.owner.ledgegrab = 0;
				self.movetype = MOVETYPE_STEP;
			}
		}
	}
};

void() player_doublejump1 = [197, player_doublejump1]
{
	self.angles_x = self.angles_x - 45;
	if (self.djump_spincnt == STATE_TOP)
	{
		self.djump_spincnt = PLAT_LOW_TRIGGER;
		player_yell();
		self.walkframe = STATE_TOP;
		self.velocity_z = STATE_TOP;
		self.velocity_z = self.velocity_z + 300;
	}
	if (relics & IT_RELIC3)
	{
		if (self.djump_spincnt > IT_RELIC3)
		{
			self.angles_x = STATE_TOP;
			player_move();
			return;
		}
	}
	else
	{
		if (self.djump_spincnt > PLAT_LOW_TRIGGER)
		{
			self.angles_x = STATE_TOP;
			player_move();
			return;
		}
	}
	if (self.walkframe == STATE_TOP && (relics & IT_RELIC3))
	{
		sound(self, CHAN_BODY, "player/swrdspin.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	}
	else
	{
		if (self.walkframe == IT_RELIC2)
		{
			if (self.invunerability_finished < time && (relics & IT_RELIC3) && self.owner.safezone == 0)
			{
				self.owner.aircombo_finished = time + 0.2;
				FireMelee(IT_RELIC2, STATE_TOP, STATE_TOP, 50, STATE_TOP, STATE_TOP, STATE_TOP);
			}
		}
		else
		{
			if (self.walkframe > TE_LIGHTNING2)
			{
				self.djump_spincnt = self.djump_spincnt + PLAT_LOW_TRIGGER;
				if (relics & IT_RELIC4)
				{
					wallgrab_check();
				}
				self.walkframe = CONTENT_EMPTY;
			}
		}
	}
	if (self.onground == 1)
	{
		self.angles_x = STATE_TOP;
		player_move();
		return;
	}
	self.owner.softshadow_time = time + PLAT_LOW_TRIGGER;
	self.walkframe = self.walkframe + PLAT_LOW_TRIGGER;
	frameskip(0.020000);
};

void() player_airdivings1 = 
{
	local vector view;
	local float bt;
	self.owner.noblock_finished = time + 0.2;
	self.movetype = MOVETYPE_STEP;
	view = vectoangles(self.enemy.origin - self.origin);
	bt = vlen(self.enemy.origin - self.origin);
	if (self.frame != 93)
	{
		self.frame = 93;
		sound(self, CHAN_BODY, "player/fast.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	}
	makevectors(self.angles);
	traceline(self.origin, self.origin + v_forward * SVC_SPAWNSTATIC, 0, self);
	if (trace_fraction < PLAT_LOW_TRIGGER && trace_ent.solid == SOLID_BSP)
	{
		self.owner.backflip_finished = time + 0.7;
		player_bflip1();
		self.aircombo_count = STATE_TOP;
	}
	if (!visible(self.enemy) || (self.origin_x > self.enemy.origin_x && self.angles_y == STATE_TOP) || (self.origin_x < self.enemy.origin_x && self.angles_y == 180) || self.origin == self.oldorigin || self.enemy.deadflag == DEAD_DEAD)
	{
		self.think = player_bflip1;
		self.owner.backflip_finished = time + 0.7;
	}
	self.angles_x = view_x * CONTENT_EMPTY;
	self.oldorigin = self.origin;
	makevectors(self.angles);
	self.velocity = aim(self, 750);
	self.velocity = self.velocity * 750;
	self.angles = vectoangles(self.velocity);
	if (self.enemy.origin_y > self.origin_y)
	{
		self.velocity_y = self.velocity_y + bt * 100 * frametime;
	}
	else
	{
		self.velocity_y = self.velocity_y + bt * 100 * frametime * CONTENT_EMPTY;
	}
	self.owner.zoom_mode = IT_RELIC2;
	if (self.aircombo_count != IT_RELIC4)
	{
		self.aircombo_count = IT_RELIC4;
	}
	divingswallow_hit();
	self.owner.attack_finished = time + 0.2;
	self.owner.shadow_time = time + 0.1;
	self.owner.speedline_time = time + 0.2;
	frameskip(0.1);
};

void() wallrunning_think = 
{
	local vector source;
	local float n;
	makevectors(self.angles);
	source = self.origin;
	if (self.angles_y == STATE_TOP || self.angles_y == 180 && self.wallgrab == 0 && self.owner.wallrun == 1)
	{
		traceline(source, source + v_forward * SVC_SIGNONNUM + v_up * SVC_SPAWNBASELINE, 0, self);
		if (trace_fraction == 1 || trace_ent.solid != SOLID_BSP)
		{
			n = PLAT_LOW_TRIGGER;
		}
		traceline(source, source + v_forward * SVC_SIGNONNUM - v_up * SVC_SPAWNBASELINE, 0, self);
		if (trace_fraction == 1 || trace_ent.solid != SOLID_BSP)
		{
			n = PLAT_LOW_TRIGGER;
		}
		if (self.owner.keyflags & KEY_LEFT && self.angles_y == STATE_TOP || (self.owner.keyflags & KEY_RIGHT && self.angles_y == 180))
		{
			if (trace_plane_normal_z == 0 && n == STATE_TOP)
			{
				self.owner.camloose = STATE_TOP;
				self.owner.aircombo_count = STATE_TOP;
				if (self.owner.wallrun == 1)
				{
					self.owner.wallrun = 0;
				}
				self.think = player_wallgrab;
				self.nextthink = time;
			}
		}
	}
};

void() player_wallrun_right1 = [0, player_wallrun_right1]
{
	local vector source;
	makevectors(self.angles);
	source = self.origin;
	traceline(source, source + '0 -25 -16', 0, self);
	self.angles_y = 180;
	if (self.walkframe > AS_MELEE)
	{
		sound(self, CHAN_BODY, "player/wrun1.wav", PLAT_LOW_TRIGGER, ATTN_NONE);
		self.walkframe = STATE_TOP;
	}
	if (self.walkframe == IT_RELIC2)
	{
		sound(self, CHAN_BODY, "player/wrun2.wav", PLAT_LOW_TRIGGER, ATTN_NONE);
	}
	self.frame = 233 + self.walkframe;
	self.walkframe = self.walkframe + PLAT_LOW_TRIGGER;
	self.velocity_x = -180;
	self.velocity_z = self.wallrun_height;
	self.wallrun_height = self.wallrun_height - TE_LAVASPLASH;
	self.wallrun_finished = time + 0.1;
	if (trace_fraction == 1 || self.onground == 1 || self.wallrun_height < STATE_TOP || !(self.owner.keyflags & KEY_RIGHT))
	{
		player_move();
	}
	wallrunning_think();
};

void() player_wallrun_left1 = [0, player_wallrun_left1]
{
	local vector source;
	makevectors(self.angles);
	source = self.origin;
	traceline(source, source + '0 -25 -16', 0, self);
	self.angles_y = STATE_TOP;
	if (self.walkframe > AS_MELEE)
	{
		sound(self, CHAN_BODY, "player/wrun1.wav", PLAT_LOW_TRIGGER, ATTN_NONE);
		self.walkframe = STATE_TOP;
	}
	if (self.walkframe == IT_RELIC2)
	{
		sound(self, CHAN_BODY, "player/wrun2.wav", PLAT_LOW_TRIGGER, ATTN_NONE);
	}
	self.frame = 237 + self.walkframe;
	self.walkframe = self.walkframe + PLAT_LOW_TRIGGER;
	self.velocity_x = 180;
	self.velocity_z = self.wallrun_height;
	self.wallrun_height = self.wallrun_height - TE_LAVASPLASH;
	self.wallrun_finished = time + 0.1;
	if (trace_fraction == 1 || self.onground == 1 || self.wallrun_height < STATE_TOP || !(self.owner.keyflags & KEY_LEFT))
	{
		player_move();
	}
	wallrunning_think();
};

float(entity targ) wallrun_divingswallow_infront = 
{
	local vector vec;
	local float dot;
	makevectors(self.char.angles);
	vec = normalize(targ.origin - self.char.origin);
	dot = vec * v_forward;
	if (dot > STATE_TOP)
	{
		return 1;
	}
	else
	{
		return 0;
	}
};

float(entity targ) visibleds = 
{
	traceline(self.char.origin, targ.origin, 1, self);
	if (trace_fraction == PLAT_LOW_TRIGGER || (targ.solid == SOLID_BSP && targ.takedamage != DAMAGE_NO))
	{
		return 1;
	}
	else
	{
		return 0;
	}
};

void() wallrun_divingswallow_init = 
{
	local entity targ;
	local vector view;
	makevectors(self.char.angles);
	targ = find(world, netname, "solid");
	while (targ)
	{
		if (targ.health > STATE_TOP && visibleds(targ) && wallrun_divingswallow_infront(targ) && targ.origin_z < self.char.origin_z && self.char.wallrun_finished > time)
		{
			if (deathmatch == 0 && (targ.flags & FL_MONSTER) || (deathmatch == 1 && (targ.owner.flags & FL_CLIENT)))
			{
				self.char.enemy = targ;
				self.velocity = no;
				self.char.think = player_wallrunningjumpkick1;
				self.char.nextthink = time;
			}
		}
		targ = find(targ, netname, "solid");
	}
	targ = find(world, netname, "solid");
};

void() player_wallrunningjumpkickslide = [107, player_wallrunningjumpkickslide]
{
	local entity effect;
	if (self.runatk_speed > IT_RELIC3)
	{
		if (self.angles_y > STATE_TOP && self.angles_y < 180)
		{
			self.angles_y = 180;
		}
		else
		{
			self.angles_y = STATE_TOP;
		}
		player_move();
		return;
	}
	self.runatk_speed = self.runatk_speed + PLAT_LOW_TRIGGER;
	self.owner.attack_finished = time + 0.2;
	self.velocity = no;
};

void() player_wallrunningjumpkick1 = [137, player_wallrunningjumpkick2]
{
	sound(self, CHAN_WEAPON, "player/wallgrab.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	self.angles_y = -90;
	self.fixangle = 1;
	self.velocity = no;
	self.movetype = MOVETYPE_NONE;
	frameskip(0.3);
};

void() player_wallrunningjumpkick2 = [137, player_wallrunningjumpkick3]
{
	local vector view;
	view = vectoangles(self.enemy.origin - self.origin);
	self.angles_y = view_y;
	sound(self, CHAN_BODY, "player/fast.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	frameskip(0.010000);
};

void() player_wallrunningjumpkick3 = [93, player_wallrunningjumpkick3]
{
	local vector v;
	self.movetype = MOVETYPE_STEP;
	makevectors(self.angles);
	self.owner.noblock_finished = time + TE_LIGHTNING1;
	self.velocity = aim(self, 500);
	self.velocity = self.velocity * 500;
	self.velocity_z = -250;
	self.angles_x = -15;
	v = self.angles;
	v_x = v_x + SVC_CLIENTDATA;
	makevectors(v);
	traceline(self.origin, self.origin + v_forward * SVC_SPAWNSTATIC, 0, self);
	if (trace_fraction < PLAT_LOW_TRIGGER && trace_ent.solid == SOLID_BSP)
	{
		self.owner.backflip_finished = time + 0.7;
		player_bflip1();
		self.aircombo_count = STATE_TOP;
	}
	if (self.onground == 1)
	{
		self.angles_x = STATE_TOP;
		player_wallrunningjumpkickslide();
		sound(self, CHAN_BODY, "player/skid.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
		return;
	}
	divingswallow_hit();
	self.runatk_speed = STATE_TOP;
	self.owner.attack_finished = time + 0.2;
	self.owner.shadow_time = time + 0.1;
	frameskip(0.05);
};

void() player_swordspin1 = [212, player_swordspin2]
{
	frameskip(0.05);
};

void() player_swordspin2 = [213, player_swordspin3]
{
	frameskip(0.05);
};

void() player_swordspin3 = [214, player_swordspin4]
{
	player_yell();
	sound(self, CHAN_WEAPON, "player/swrdspin.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	self.owner.swordshadow_time = time + PLAT_LOW_TRIGGER;
	frameskip(0.020000);
};

void() player_swordspin4 = [215, player_swordspin5]
{
	FireMelee(PLAT_LOW_TRIGGER, 35, STATE_TOP, SVC_SIGNONNUM, STATE_TOP, STATE_TOP, PLAT_LOW_TRIGGER);
	frameskip(0.020000);
};

void() player_swordspin5 = [216, player_swordspin6]
{
	frameskip(0.020000);
};

void() player_swordspin6 = [217, player_swordspin7]
{
	if (self.sword_spincnt > TE_LIGHTNING1)
	{
		player_swordspin22();
		return;
	}
	sound(self, CHAN_WEAPON, "player/swrdspin.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	self.sword_spincnt = self.sword_spincnt + PLAT_LOW_TRIGGER;
	frameskip(0.020000);
};

void() player_swordspin7 = [217, player_swordspin8]
{
	frameskip(0.020000);
};

void() player_swordspin8 = [218, player_swordspin9]
{
	frameskip(0.020000);
};

void() player_swordspin9 = [219, player_swordspin10]
{
	FireMelee(PLAT_LOW_TRIGGER, 35, STATE_TOP, SVC_SIGNONNUM, STATE_TOP, STATE_TOP, PLAT_LOW_TRIGGER);
	frameskip(0.020000);
};

void() player_swordspin10 = [220, player_swordspin11]
{
	frameskip(0.020000);
};

void() player_swordspin11 = [221, player_swordspin12]
{
	frameskip(0.020000);
};

void() player_swordspin12 = [222, player_swordspin13]
{
	frameskip(0.020000);
};

void() player_swordspin13 = [223, player_swordspin5]
{
	FireMelee(PLAT_LOW_TRIGGER, 35, STATE_TOP, SVC_SIGNONNUM, STATE_TOP, STATE_TOP, PLAT_LOW_TRIGGER);
	frameskip(0.020000);
};

void() player_swordspin22 = [213, player_swordspin23]
{
	frameskip(0.05);
};

void() player_swordspin23 = [224, player_smashdown1]
{
	frameskip(0.05);
};

void() smashdown_move = 
{
	if (self.angles_y == STATE_TOP || self.angles_y == 360)
	{
		self.velocity_x = 75;
	}
	else
	{
		self.velocity_x = -75;
	}
	self.flags = self.flags - (self.flags & FL_ONGROUND);
};

void() player_smashdown1 = [225, player_smashdown2]
{
	frameskip(0.05);
};

void() player_smashdown2 = [226, player_smashdown3]
{
	frameskip(0.05);
};

void() player_smashdown3 = [227, player_smashdown4]
{
	frameskip(0.05);
};

void() player_smashdown4 = [228, player_smashdown5]
{
	self.velocity_z = 150;
	player_yell();
	smashdown_move();
	frameskip(0.1);
};

void() player_smashdown5 = [229, player_smashdown6]
{
	smashdown_move();
	frameskip(0.1);
};

void() player_smashdown6 = [230, player_smashdown7]
{
	smashdown_move();
	sound(self, CHAN_WEAPON, "player/sword3.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	frameskip(0.05);
};

void() player_smashdown7 = [231, player_smashdown8]
{
	smashdown_move();
	self.owner.swordshadow_time = time + 0.05;
	self.attack_type = TE_LIGHTNING1;
	FireMelee(SVC_UPDATENAME, 45, AS_MELEE, SVC_SIGNONNUM, TE_LIGHTNING1, PLAT_LOW_TRIGGER, PLAT_LOW_TRIGGER);
	frameskip(0.05);
};

void() player_smashdown8 = [232, player_move]
{
	smashdown_move();
	frameskip(0.2);
};


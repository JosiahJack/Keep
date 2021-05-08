void() CheckImpulses = 
{
	local string h;
	if (self.char.health <= STATE_TOP)
	{
		return;
	}
	if (self.impulse == PLAT_LOW_TRIGGER && self.safezone == 0 && (self.char.flags & FL_ONGROUND) && self.attack_finished < time && self.char.pain_finished < time && self.char.tired_finished < time && self.char.grabbed == 0 && self.char.invunerability_finished < time && self.forcewalk_finished < time)
	{
		if (self.magicmenu == 0)
		{
			if (self.char.angles_y == 45 || self.char.angles_y == -45)
			{
				self.char.angles_y = STATE_TOP;
			}
			if (self.char.angles_y == 225 || self.char.angles_y == -225)
			{
				self.char.angles_y = 180;
			}
			self.char.turn_y = self.char.angles_y;
			self.char.angles_y = -180;
			self.char.running = 0;
			self.magicmenu = 1;
			sound(self, CHAN_ITEM, "player/mmenu1.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
		}
		else
		{
			if (self.currentspell == SPELL_FIREBALL)
			{
				if (self.ammo_shells >= TE_LAVASPLASH)
				{
					sound(self, CHAN_ITEM, "player/mmenu2.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
					self.char.angles_y = self.char.turn_y;
					self.attack_finished = time + 0.6;
					self.char.think = player_fireball1;
					self.char.nextthink = time + 0.1;
				}
				else
				{
					if (self.ammo_shells >= TE_LAVASPLASH / 1.5)
					{
						sound(self, CHAN_ITEM, "player/mmenu2.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
						self.char.angles_y = self.char.turn_y;
						self.attack_finished = time + 0.6;
						self.char.think = player_fireball1;
						self.char.nextthink = time + 0.1;
						self.char.tired_finished = time + AS_MELEE;
					}
					else
					{
						sprint(self, "Not enough mana.\n");
						self.char.angles_y = self.char.turn_y;
					}
				}
			}
			else
			{
				if (self.currentspell == SPELL_LIGHTNING)
				{
					if (self.ammo_shells >= 45)
					{
						sound(self, CHAN_ITEM, "player/mmenu2.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
						self.char.angles_y = -180;
						self.char.lcount = STATE_TOP;
						self.attack_finished = time + PLAT_LOW_TRIGGER;
						self.char.think = player_lightning1;
						self.char.nextthink = time + 0.1;
					}
					else
					{
						if (self.ammo_shells >= 45 / 1.5)
						{
							sound(self, CHAN_ITEM, "player/mmenu2.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
							self.char.angles_y = -180;
							self.char.lcount = STATE_TOP;
							self.attack_finished = time + PLAT_LOW_TRIGGER;
							self.char.think = player_lightning1;
							self.char.nextthink = time + 0.1;
							self.char.tired_finished = time + TE_LIGHTNING2;
						}
						else
						{
							sprint(self, "Not enough mana.\n");
							self.char.angles_y = self.char.turn_y;
						}
					}
				}
				else
				{
					if (self.currentspell == SPELL_ICE)
					{
						if (self.ammo_shells >= SVC_INTERMISSION)
						{
							sound(self, CHAN_ITEM, "player/mmenu2.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
							self.char.angles_y = -180;
							self.char.icefield_count = STATE_TOP;
							self.attack_finished = time + PLAT_LOW_TRIGGER;
							self.char.think = player_icefield1;
							self.char.nextthink = time + 0.1;
						}
						else
						{
							if (self.ammo_shells >= SVC_INTERMISSION / 1.5)
							{
								sound(self, CHAN_ITEM, "player/mmenu2.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
								self.char.angles_y = -180;
								self.char.icefield_count = STATE_TOP;
								self.attack_finished = time + PLAT_LOW_TRIGGER;
								self.char.think = player_icefield1;
								self.char.nextthink = time + 0.1;
								self.char.tired_finished = time + TE_WIZSPIKE;
							}
							else
							{
								sprint(self, "Not enough mana.\n");
								self.char.angles_y = self.char.turn_y;
							}
						}
					}
					else
					{
						if (self.currentspell == SPELL_BEAM)
						{
							if (self.ammo_shells >= 100)
							{
								sound(self, CHAN_ITEM, "player/mmenu2.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
								self.char.angles_y = -180;
								self.attack_finished = time + 999;
								self.char.beams_shot = STATE_TOP;
								self.char.think = player_magicd1;
								self.char.nextthink = time + 0.1;
							}
							else
							{
								if (self.ammo_shells >= 100 / 1.5)
								{
									sound(self, CHAN_ITEM, "player/mmenu2.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
									self.char.angles_y = -180;
									self.attack_finished = time + 999;
									self.char.beams_shot = STATE_TOP;
									self.char.think = player_magicd1;
									self.char.nextthink = time + 0.1;
									self.char.tired_finished = time + TE_LIGHTNING3;
								}
								else
								{
									sprint(self, "Not enough mana.\n");
									self.char.angles_y = self.char.turn_y;
								}
							}
						}
						else
						{
							if (self.currentspell == SPELL_TWISTER)
							{
								if (self.ammo_shells >= 75)
								{
									sound(self, CHAN_ITEM, "player/mmenu2.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
									self.char.angles_y = -180;
									self.attack_finished = time + TE_LIGHTNING1;
									self.char.tcount = STATE_TOP;
									self.char.think = player_twister1;
									self.char.nextthink = time + 0.1;
								}
								else
								{
									if (self.ammo_shells >= 75 / 1.5)
									{
										sound(self, CHAN_ITEM, "player/mmenu2.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
										self.char.angles_y = -180;
										self.char.tcount = STATE_TOP;
										self.attack_finished = time + TE_LIGHTNING1;
										self.char.think = player_twister1;
										self.char.nextthink = time + 0.1;
										self.char.tired_finished = time + IT_RELIC4;
									}
									else
									{
										sprint(self, "Not enough mana.\n");
										self.char.angles_y = self.char.turn_y;
									}
								}
							}
						}
					}
				}
			}
			self.magicmenu = 0;
		}
	}
	if (self.impulse == IT_RELIC2 && self.char.invunerability_finished < time && self.safezone == 0 && self.forcewalk_finished < time)
	{
		if (self.char.pain_finished > time || self.char.tired_finished > time || self.wallrun == 1 || (self.char.onground == 0 && self.doublejump == 1 && self.char.djump_spincnt < IT_RELIC3))
		{
			return;
		}
		self.softshadow_time = time;
		self.char.movetype = MOVETYPE_STEP;
		self.char.angles_x = STATE_TOP;
		if (self.ledgegrab == 1)
		{
			self.ledgegrab = 0;
			self.char.velocity_x = STATE_TOP;
		}
		if (self.char.enemy)
		{
			if (self.char.enemy.grabbed == 1)
			{
				self.char.enemy.grabbed = 0;
			}
			self.char.grabbed = 0;
		}
		if (self.magicmenu == 1)
		{
			self.char.angles_y = self.char.turn_y;
			sound(self, CHAN_ITEM, "player/mmenu1.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
			self.magicmenu = 0;
		}
		if (self.char.angles_y == 45 || self.char.angles_y == -45)
		{
			self.char.angles_y = STATE_TOP;
		}
		if (self.char.angles_y == 225 || self.char.angles_y == -225)
		{
			self.char.angles_y = 180;
		}
		if (self.keyflags & KEY_LEFT && self.char.angles_y == STATE_TOP || (self.keyflags & KEY_RIGHT && self.char.angles_y == 180) && self.char.aircombo_count != TE_WIZSPIKE && self.char.aircombo_count != IT_RELIC4 && self.wallgrab == 0)
		{
			if (self.attack_finished < time)
			{
				self.char.enemy = world;
				self.char.perform_flyingswallow = 0;
				self.noblock_finished = time + 0.4;
				self.char.idle_count = STATE_TOP;
				self.char.attack_type = STATE_TOP;
				self.char.think = player_kick1;
				self.attack_finished = time + 0.6;
				self.char.nextthink = time;
				self.char.aircombo_count = TE_WIZSPIKE;
			}
		}
		else
		{
			if (self.noblock_finished < time || self.wallgrab == 1)
			{
				self.char.idle_count = STATE_TOP;
				self.attack_finished = time;
				self.char.flypain = 0;
				self.char.takedamage = DAMAGE_AIM;
				self.char.block_finished = time + 9999;
				self.char.think = player_block;
				self.char.nextthink = time;
				sound(self, CHAN_BODY, "player/motion2.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
			}
		}
	}
	if (self.impulse == AS_MELEE)
	{
		if (self.char.block_finished < time || self.char.flypain)
		{
			return;
		}
		self.char.block_finished = time;
		sound(self, CHAN_BODY, "player/motion1.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	}
	if (self.impulse == IT_RELIC3)
	{
		h = ftos(self.gold);
		sprint(self, "Current gold: ");
		sprint(self, h);
		sprint(self, "\n");
		h = ftos(self.char.armorlevel);
		sprint(self, "Current armor level: ");
		sprint(self, h);
		sprint(self, "\n");
	}
	if (self.impulse == TE_LIGHTNING1)
	{
		self.gold = self.gold + 5000;
	}
	if (self.impulse == TE_LIGHTNING2)
	{
		self.char.think = player_blockbrk1;
		self.char.nextthink = time + 0.010000;
	}
};


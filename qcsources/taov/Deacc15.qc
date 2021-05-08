void() npc_default = 
{
	local vector view;
	local entity y;
	MakeSolidList();
	if (!(self.enemy))
	{
		y = find(world, classname, "player");
		while (y)
		{
			if (y.classname == "player" && visible(y) && range(y) < RANGE_NEAR)
			{
				self.enemy = y;
				self.enemy.owner.safezone = 1;
			}
			y = find(y, classname, "player");
		}
		if (self.state < time)
		{
			if (random() < 0.5)
			{
				if (random() < 0.35)
				{
					self.angles_y = self.angles_y + SVC_CLIENTDATA;
				}
				else
				{
					self.angles_y = self.angles_y - SVC_CLIENTDATA;
				}
			}
			self.state = time + AS_MELEE + random() * AS_MELEE;
		}
		if (self.th_walk)
		{
			self.npcmove_finished = time + TE_LIGHTNING1 + random() * TE_LIGHTNING1;
		}
	}
	else
	{
		if (range(self.enemy) < RANGE_NEAR)
		{
			view = vectoangles(self.enemy.origin - self.origin);
			self.angles_y = view_y;
			self.fixangle = 1;
			if (self.enemy.owner.button0 && self.pain_finished < time || self.mode == PLAT_LOW_TRIGGER)
			{
				if (self.enemy.owner.button0 && self.mode == STATE_TOP)
				{
					self.selection = 1;
					sound(self, CHAN_AUTO, "misc/menu2.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
				}
				if (self.npc_talk)
				{
					self.mode = PLAT_LOW_TRIGGER;
					self.npc_talk();
				}
			}
		}
		else
		{
			self.mode = STATE_TOP;
			if (self.npc_talk)
			{
				self.npc_talk();
			}
			self.enemy.owner.conversation = 0;
			self.enemy.owner.safezone = 0;
			self.enemy = world;
		}
	}
	UnmakeSolidList();
	frameskip(0.010000);
};

void() blacksmith_chat = 
{
	local float aprice;
	local string h;
	if (self.mode == STATE_TOP && self.enemy.owner.conversation == 1)
	{
		centerprint(self.enemy.owner, "Take care Vigil, I bid you well in your quest.");
	}
	else
	{
		if (self.mode == PLAT_LOW_TRIGGER)
		{
			self.enemy.owner.conversation = 1;
			if (self.enemy.armorlevel == STATE_TOP)
			{
				aprice = 1500;
			}
			else
			{
				if (self.enemy.armorlevel == PLAT_LOW_TRIGGER)
				{
					aprice = 7250;
				}
				else
				{
					if (self.enemy.armorlevel == IT_RELIC2)
					{
						aprice = 15000;
					}
					else
					{
						if (self.enemy.armorlevel == AS_MELEE)
						{
							aprice = 30000;
						}
					}
				}
			}
			if (self.chatrefresh_finished < time)
			{
				if (self.cnt == STATE_TOP)
				{
					if (self.attack_finished < time && self.enemy.armorlevel < IT_RELIC3)
					{
						sprint(self.enemy.owner, "Armor Upgrade Cost: ");
						h = ftos(aprice);
						sprint(self.enemy.owner, h);
						sprint(self.enemy.owner, " (");
						h = ftos(self.enemy.owner.gold);
						sprint(self.enemy.owner, h);
						sprint(self.enemy.owner, ")\n");
						self.attack_finished = time + AS_MELEE;
					}
					centerprint(self.enemy.owner, "Greetings Vigil! Glad you've returned to Kharlia,\nhow may I help you?\n\n\n--------------------\n\n Buy an armor upgrade\n                 Leave\n");
				}
				else
				{
					if (self.cnt == PLAT_LOW_TRIGGER)
					{
						centerprint(self.enemy.owner, "Greetings Vigil! Glad you've returned to Kharlia,\nhow may I help you?\n\n\n--------------------\n\n  Buy an armor upgrade\n                Leave\n");
					}
				}
				self.chatrefresh_finished = time + 0.1;
			}
			if (self.enemy.owner.keyflags & KEY_UP)
			{
				if (self.selection_up == 0)
				{
					self.cnt = self.cnt + PLAT_LOW_TRIGGER;
					sound(self, CHAN_AUTO, "misc/menu1.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
				}
				self.chatrefresh_finished = time;
				self.selection_up = 1;
			}
			else
			{
				self.selection_up = 0;
			}
			if (self.enemy.owner.keyflags & KEY_DOWN)
			{
				if (self.selection_down == 0)
				{
					self.cnt = self.cnt - PLAT_LOW_TRIGGER;
					sound(self, CHAN_AUTO, "misc/menu1.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
				}
				self.chatrefresh_finished = time;
				self.selection_down = 1;
			}
			else
			{
				self.selection_down = 0;
			}
			if (self.enemy.owner.button0)
			{
				if (self.selection == 0)
				{
					if (self.cnt == STATE_TOP)
					{
						if (self.enemy.owner.gold >= aprice && self.enemy.armorlevel < IT_RELIC3)
						{
							sprint(self.enemy.owner, "Your armor level has increased!\n");
							self.enemy.armorlevel = self.enemy.armorlevel + PLAT_LOW_TRIGGER;
							DisplayArmor(self.enemy);
							sound(self.enemy.owner, CHAN_AUTO, "misc/levelup2.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
							self.enemy.owner.gold = self.enemy.owner.gold - aprice;
						}
						else
						{
							sound(self, CHAN_AUTO, "misc/menu2.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
						}
					}
					if (self.cnt == PLAT_LOW_TRIGGER)
					{
						self.mode = STATE_TOP;
						self.cnt = STATE_TOP;
						self.enemy.owner.conversation = 0;
						centerprint(self.enemy.owner, "\n");
						self.pain_finished = time + PLAT_LOW_TRIGGER;
						sound(self, CHAN_AUTO, "misc/menu2.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
					}
				}
				self.selection = 1;
			}
			else
			{
				self.selection = 0;
			}
			if (self.cnt > PLAT_LOW_TRIGGER)
			{
				self.cnt = STATE_TOP;
			}
			if (self.cnt < STATE_TOP)
			{
				self.cnt = PLAT_LOW_TRIGGER;
			}
		}
	}
};

void() npc_bsmith = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model("progs/bsmith.mdl");
	precache_sound("misc/menu1.wav");
	precache_sound("misc/menu2.wav");
	setmodel(self, "progs/bsmith.mdl");
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
	self.movetype = MOVETYPE_STEP;
	self.takedamage = DAMAGE_NO;
	self.solid = SOLID_SLIDEBOX;
	self.classname = "bsmith";
	self.npc_talk = blacksmith_chat;
	self.goalentity = world;
	self.think = npc_default;
	self.nextthink = time + 0.1;
	droptofloor();
};


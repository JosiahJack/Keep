void() mg_shell = 
{
	self.classname = "item_shells";
	self.touch = ammo_touch;
	precache_model("maps/b_shell1.bsp");
	setmodel(self, "maps/b_shell1.bsp");
	self.aflag = 50;
	self.weapon = USE_COUNT;
	self.netname = "shells";
	setsize(self, VEC_ORIGIN, '32 32 56');
	StartItem();
};

void() mg_nail = 
{
	self.classname = "item_spikes";
	self.touch = ammo_touch;
	precache_model("maps/b_nail1.bsp");
	setmodel(self, "maps/b_nail1.bsp");
	self.aflag = 75;
	self.weapon = LIGHTNING_BOOM;
	self.netname = "nails";
	setsize(self, VEC_ORIGIN, '32 32 56');
	StartItem();
};

void() mg_rock = 
{
	self.classname = "item_rockets";
	self.touch = ammo_touch;
	precache_model("maps/b_rock1.bsp");
	setmodel(self, "maps/b_rock1.bsp");
	self.aflag = STATE_OPEN;
	self.weapon = STATE_FIND;
	self.netname = "rockets";
	setsize(self, VEC_ORIGIN, '32 32 56');
	StartItem();
};

void() mg_cell = 
{
	self.classname = "item_cells";
	self.touch = ammo_touch;
	precache_model("maps/b_batt1.bsp");
	setmodel(self, "maps/b_batt1.bsp");
	self.aflag = 25;
	self.weapon = NONBLOCKING;
	self.netname = "cells";
	setsize(self, VEC_ORIGIN, '32 32 56');
	StartItem();
};

void() mg_db = 
{
	self.classname = "weapon_supershotgun";
	precache_model("progs/g_shot.mdl");
	setmodel(self, "progs/g_shot.mdl");
	self.weapon = IT_SUPER_SHOTGUN;
	self.netname = "Combat Shotgun";
	self.touch = weapon_touch;
	setsize(self, '-16 -16 0', '16 16 56');
	StartItem();
};

void() mg_ng = 
{
	self.classname = "weapon_nailgun";
	precache_model("progs/g_nail.mdl");
	setmodel(self, "progs/g_nail.mdl");
	self.weapon = IT_NAILGUN;
	self.netname = "Nailgun";
	self.touch = weapon_touch;
	setsize(self, '-16 -16 0', '16 16 56');
	StartItem();
};

void() mg_sng = 
{
	self.classname = "weapon_supernailgun";
	precache_model("progs/g_nail2.mdl");
	setmodel(self, "progs/g_nail2.mdl");
	self.weapon = IT_SUPER_NAILGUN;
	self.netname = "Perforator";
	self.touch = weapon_touch;
	setsize(self, '-16 -16 0', '16 16 56');
	StartItem();
};

void() mg_gl = 
{
	self.classname = "weapon_grenadelauncher";
	precache_model("progs/g_rock.mdl");
	setmodel(self, "progs/g_rock.mdl");
	self.weapon = STATE_FIND;
	self.netname = "Grenade Launcher";
	self.touch = weapon_touch;
	setsize(self, '-16 -16 0', '16 16 56');
	StartItem();
};

void() mg_mine = 
{
	self.classname = "weapon_proximity_gun";
	precache_model("progs/g_prox.mdl");
	setmodel(self, "progs/g_prox.mdl");
	self.weapon = STATE_FIND;
	self.netname = "Proximity Gun";
	self.items = IT_PROXIMITY_GUN;
	self.touch = weapon_touch;
	setsize(self, '-16 -16 0', '16 16 56');
	StartItem();
};

void() mg_rl = 
{
	self.classname = "weapon_rocketlauncher";
	precache_model("progs/g_rock2.mdl");
	setmodel(self, "progs/g_rock2.mdl");
	self.weapon = STATE_FIND;
	self.netname = "Personal V2 Rocket Launcher";
	self.touch = weapon_touch;
	setsize(self, '-16 -16 0', '16 16 56');
	StartItem();
};

void() mg_lc = 
{
	precache_model("progs/g_laserg.mdl");
	setmodel(self, "progs/g_laserg.mdl");
	self.weapon = STATE_FIND;
	self.netname = "Laser Cannon";
	self.classname = "weapon_laser_gun";
	self.items = IT_LASER_CANNON;
	self.touch = weapon_touch;
	setsize(self, '-16 -16 0', '16 16 56');
	StartItem();
};

void() mg_weapon = 
{
	local float rand;
	local float teamtits;
	local string teamst;
	if (world.team)
	{
		teamtits = world.team;
		teamst = ftos(teamtits);
		cvar_set("teamplay", teamst);
	}
	else
	{
		teamtits = cvar("teamplay");
	}
	rand = random();
	if (teamtits == USE_COUNT)
	{
		mg_db();
	}
	else
	{
		if (teamtits == LIGHTNING_BOOM)
		{
			if (rand > 0.5)
			{
				mg_gl();
			}
			else
			{
				mg_mine();
			}
		}
		else
		{
			if (teamtits == STATE_FIND)
			{
				if (rand > 0.5)
				{
					mg_gl();
				}
				else
				{
					mg_ng();
				}
			}
			else
			{
				if (teamtits == NONBLOCKING)
				{
					if (rand < 0.4)
					{
						mg_ng();
					}
					else
					{
						if (rand < 0.8)
						{
							mg_db();
						}
						else
						{
							if (rand < 0.95)
							{
								mg_gl();
							}
							else
							{
								mg_rl();
							}
						}
					}
				}
				else
				{
					if (teamtits == STATE_OPEN)
					{
						if (rand < 0.95)
						{
							mg_lc();
						}
						else
						{
							mg_mine();
						}
					}
					else
					{
						mg_sng();
					}
				}
			}
		}
	}
};

void() mg_ammo = 
{
	local float rand;
	local float teamtits;
	local string teamst;
	if (world.team)
	{
		teamtits = world.team;
		teamst = ftos(teamtits);
		cvar_set("teamplay", teamst);
	}
	else
	{
		teamtits = cvar("teamplay");
	}
	rand = random();
	if (teamtits == USE_COUNT)
	{
		mg_shell();
	}
	else
	{
		if (teamtits == LIGHTNING_BOOM)
		{
			mg_rock();
		}
		else
		{
			if (teamtits == STATE_FIND)
			{
				if (rand > 0.5)
				{
					mg_nail();
				}
				else
				{
					mg_rock();
				}
			}
			else
			{
				if (teamtits == NONBLOCKING)
				{
					if (rand < 0.4)
					{
						mg_nail();
					}
					else
					{
						if (rand < 0.8)
						{
							mg_shell();
						}
						else
						{
							mg_rock();
						}
					}
				}
				else
				{
					if (teamtits == STATE_OPEN)
					{
						if (rand < 0.95)
						{
							mg_cell();
						}
						else
						{
							mg_rock();
						}
					}
					else
					{
						mg_nail();
					}
				}
			}
		}
	}
};


void() trinket_touch = 
{
	local float select;
	if (other.classname != "player")
	{
		return;
	}
	if (other.health <= 0)
	{
		return;
	}
	if (other.shub_time > time || other.np_time > time)
	{
		return;
	}
	if (other.player_flag & ITEM_RUNE9_FLAG)
	{
		return;
	}
	select = random() * 7;
	sprint(other, "Shub's Trinket - ");
	if (select < 1)
	{
		other.health = 200;
		other.armorvalue = 200;
		if (!(other.armormax))
		{
			other.armortype = 0.8;
			other.items = other.items - (other.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3));
			other.items = other.items + IT_ARMOR3;
		}
		else
		{
			other.armormax = 200;
		}
		sprint(other, "Armor and Health\n");
	}
	else
	{
		if (select < 2)
		{
			other.ammo_shells = 100;
			other.ammo_nails = 200;
			other.ammo_cells = 200;
			other.ammo_rockets = 100;
			sprint(other, "Ammo\n");
		}
		else
		{
			if (select < 2.5)
			{
				other.weapons = other.weapons | (WE_CLUSTER | WE_WACKY | WE_BFG | WE_PLASMAGUN | WE_SNIPER_RIFLE);
				other.items = other.items | (IT_ROCKET_LAUNCHER | IT_GRENADE_LAUNCHER | IT_SUPER_SHOTGUN | IT_LIGHTNING | IT_SUPER_NAILGUN | IT_NAILGUN);
				other.ammo_cells = other.ammo_cells + 30;
				other.ammo_nails = other.ammo_nails + 30;
				other.ammo_shells = other.ammo_shells + 30;
				other.ammo_rockets = other.ammo_rockets + 30;
				if (!(other.quad_shot))
				{
					other.quad_shot = 1;
				}
				bound_other_ammo();
				sprint(other, "Weapons\n");
			}
			else
			{
				if (select < 3.5)
				{
					other.items = other.items | IT_QUAD;
					other.super_damage_finished = time + 30;
					other.super_time = 1;
					sprint(other, "Quad\n");
				}
				else
				{
					if (select < 4.5)
					{
						other.frag = 1;
						other.frag_time = time + 30;
						sprint(other, "Double Frags\n");
					}
					else
					{
						if (select < 5.5)
						{
							other.items = other.items | IT_QUAD;
							other.super_damage_finished = time + 30;
							other.super_time = 1;
							other.bad_quad = 1;
							sprint(other, "Wimpy!\n");
						}
						else
						{
							if (select < 6)
							{
								other.np_time = time + 30;
								sprint(other, "No Pickup\n");
							}
							else
							{
								if (select < 6.5)
								{
									other.axe_only_time = time + 30;
									sprint(other, "Axe Only\n");
									if (other.grpl)
									{
										stemp = self;
										self = other.grpl;
										HookVanish();
										self = stemp;
									}
								}
								else
								{
									if (select < 7)
									{
										other.items = other.items | IT_QUAD;
										other.super_damage_finished = time + 30;
										other.super_time = 1;
										other.bad_quad = 1;
										other.frag = 2;
										other.max_health = 25;
										if (other.health > 25)
										{
											other.health = 25;
										}
										other.armorvalue = 0;
										other.armortype = 0;
										other.items = other.items - (other.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3));
										other.armormax = 0;
										other.effects = other.effects | EF_BRIGHTLIGHT;
										other.shub_time = time + 30;
										bprint(other.netname);
										bprint(" IS AN INITIATE OF SHUB!!!! FRAG HIS ASS!\n");
									}
								}
							}
						}
					}
				}
			}
		}
	}
	stuffcmd(other, "bf\n");
	stemp = self;
	self = other;
	W_SetCurrentAmmo();
	self = stemp;
	self.model = string_null;
	self.solid = SOLID_NOT;
	activator = other;
	SUB_UseTargets();
	if (deathmatch == 1)
	{
		self.nextthink = time + 50;
		self.think = SUB_regen;
	}
};

void() item_artifact_trinket = 
{
	self.touch = trinket_touch;
	precache_model("progs/trinket.mdl");
	setmodel(self, "progs/trinket.mdl");
	self.netname = "Shub's Trinket";
	setsize(self, '-16 -16 -24', '16 16 32');
	StartItem();
};


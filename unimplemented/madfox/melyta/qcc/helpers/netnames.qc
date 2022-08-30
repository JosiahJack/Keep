//call like getNetName(IT_ARMOR3); and it returns "Red Armor"
//or getNetName(self.items) or getNetname(self.weapon)
//called from dropBackpack() and startItem(). fills in any netnames that are missing. and overrides the others.
string getNetname(float item_number) =
{//gnounc
	switch(item_number) 
	{
		case IT_AXE:
			return "Axe";
		case IT_SHOTGUN:
			return "Shotgun";
		case IT_SUPER_SHOTGUN:
			return "Super Shotgun";
		case IT_NAILGUN:
			return "Nailgun";
		case IT_SUPER_NAILGUN:
			return "Perforator";
		case IT_GRENADE_LAUNCHER:
			return "Grenade Launcher";
		case IT_ROCKET_LAUNCHER:
			return "Rocket Launcher";
		case IT_LIGHTNING:
			return "Lightning Gun";
		case IT_EXTRA_WEAPON:
			return "Extra Weapon";
		case IT_SHELLS:
			return "Shells";
		case IT_NAILS:
			return "Nails";
		case IT_ROCKETS:
			return "Rockets";
		case IT_CELLS:
			return "Cells";
		case IT_ARMOR1:
			return "Green Armor";
		case IT_ARMOR2:
			return "Yellow Armor";
		case IT_ARMOR3:
			return "Red Armor";
		case IT_SUPERHEALTH:
			return "Mega Health";
		case IT_KEY1:
		{	if (world.worldtype == 0)
				return "Silver key";
			if (world.worldtype == 1)
				return "Silver runkey";
			if (world.worldtype == 2)
				return "Silver keycard";
		}
		case IT_KEY2:
		{	if (world.worldtype == 0)
				return "Gold key";
			if (world.worldtype == 1)
				return "Gold runkey";
			if (world.worldtype == 2)
				return "Gold keycard";
		}
		case IT_INVISIBILITY:
			return "Ring of Shadows";
		case IT_INVULNERABILITY:
			return "Pentagram of Protection";
		case IT_SUIT:
			return "Biohazard Suit";
		case IT_QUAD:
			return "Quad Damage";

		default:
			return string_null;
	}
};

string getMapname(string m) =
{
	switch(m) 
	{
		case "start":
			return "Introduction...";
		case "e1m1":
			return "The Slipgate Complex";
		case "e1m2":
			return "Castle of the Damned";
		case "e1m3":
			return "The Necropolis";
		case "e1m4":
			return "The Gristly Grotto";
		case "e1m5":
			return "Gloom Keep";
		case "e1m6":
			return "The Door to Chthon";
		case "e1m7":
			return "The House of Chthon";
		case "e1m8":
			return "Ziggurat Vertigo";

		case "e2m1":
			return "The Installation";
		case "e2m2":
			return "The Ogre Citadel";
		case "e2m3":
			return "The Crypt of Decay";
		case "e2m4":
			return "The Ebon Fortress";
		case "e2m5":
			return "The Wizard's Manse";
		case "e2m6":
			return "The Dismal Oubliette";
		case "e2m7":
			return "The Underearth";

		case "e3m1":
			return "Termination Central";
		case "e3m2":
			return "The Vaults of Zin";
		case "e3m3":
			return "The Tomb of Terror";
		case "e3m4":
			return "Satan's Dark Delight";
		case "e3m5":
			return "The Wind Tunnels";
		case "e3m6":
			return "Chambers of Torment";
		case "e3m7":
			return "The Haunted Halls";

		case "e4m1":
			return "The Sewage System";
		case "e4m2":
			return "The Tower of Despair";
		case "e4m3":
			return "The Elder God Shrine";
		case "e4m4":
			return "The Palace of Hate";
		case "e4m5":
			return "Hell's Atrium";
		case "e4m6":
			return "The Pain Maze";
		case "e4m7":
			return "Azure Agony";
		case "e4m8":
			return "The Nameless City";
		case "end":
			return "Shub-Niggurath's Pit";

		case "dm1":
			return "Place of two Deaths";
		case "dm2":
			return "Claustrophobopolis";
		case "dm3":
			return "The Abandoned Base";
		case "dm4":
			return "The Bad Place";
		case "dm5":
			return "The Cistern";
		case "dm6":
			return "The Dark Zone";

		default:
			return string_null;
	}
};

float getAmmotypeByWeapon(float it_num)
{
	switch(it_num)
	{
		case IT_AXE:
			return 0;
		case IT_SHOTGUN:
			return IT_SHELLS;
		case IT_SUPER_SHOTGUN:
			return IT_SHELLS;
		case IT_NAILGUN:
			return IT_NAILS;
		case IT_SUPER_NAILGUN:
			return IT_NAILS;
		case IT_GRENADE_LAUNCHER:
			return IT_ROCKETS;
		case IT_ROCKET_LAUNCHER:
			return IT_ROCKETS;
		case IT_LIGHTNING:
			return IT_CELLS;
		default:
			return IT_SHELLS;
	}
};

string getModelByNum(float it_num)
{
	switch(it_num)
	{
		case IT_AXE:
			return "progs/v_axe.mdl";
		case IT_SHOTGUN:
			return "progs/v_shot.mdl";
		case IT_SUPER_SHOTGUN:
			return "progs/v_shot2.mdl";
		case IT_NAILGUN:
			return "progs/v_nail.mdl";
		case IT_SUPER_NAILGUN:
			return "progs/v_nail2.mdl";
		case IT_GRENADE_LAUNCHER:
			return "progs/v_rock.mdl";
		case IT_ROCKET_LAUNCHER:
			return "progs/v_rock2.mdl";
		case IT_LIGHTNING:
			return "progs/v_light.mdl";
		case IT_SHELLS:
			return "maps/b_shell0.bsp";	//b_shell1.bsp is big shells.
		case IT_NAILS:
			return "maps/b_nail0.bsp";
		case IT_ROCKETS:
			return "maps/b_rock0.bsp";
		case IT_CELLS:
			return "maps/b_batt0.bsp";
		case IT_ARMOR1:
			return "progs/armor.mdl";
		case IT_ARMOR2:
			return "progs/armor.mdl";
		case IT_ARMOR3:
			return "progs/armor.mdl";
		case IT_SUPERHEALTH:
			return "maps/b_bh100.bsp";
		case IT_KEY1:
		{
			if (world.worldtype == 0)
				return "progs/w_s_key.mdl";

			else if(world.worldtype == 1)
				return "progs/m_s_key.mdl";

			else if(world.worldtype == 2)
				return "progs/b_s_key.mdl";
		}
		case IT_KEY2:
		{
			if (world.worldtype == 0)
				return "progs/w_g_key.mdl";

			else if(world.worldtype == 1)
				return "progs/m_g_key.mdl";

			else if(world.worldtype == 2)
				return "progs/b_g_key.mdl";
		}
		case IT_INVISIBILITY:
			return "progs/invisibl.mdl";
		case IT_INVULNERABILITY:
			return "progs/invulner.mdl";
		case IT_SUIT:
			return "progs/suit.mdl";
		case IT_QUAD:
			return "progs/quaddama.mdl";
		default :
			return string_null;
	}
};

/*  Copyright (C) 1996-1997  Id Software, Inc.

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    See file, 'COPYING', for details.
*/
/*
This file handles info displays
*/
// 2001-04-22 Option: Random map rotation by Maddes
//            extending information display function (server)
// 2000-07-16 Option: Sudden death for fraglimit and timelimit by Maddes
//            for defining information display function (server)
// 1999-10-17 Delayed powerups on map start by Maddes
//            defining information display function (server)
// 1999-06-03 Resume function by Jim Steers/Maddes
//            defining information display function (server)
// 1999-05-02 Teleporting objects by Lord Sméagol/Maddes
//            defining information display function (server)
// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes
//            defining information display functions (server)
// 1999-02-04 Option: Drop Quad/Ring by Zoid/Maddes
//            defining information display functions (server)
// 1999-02-03 Option: Map rotation by Maddes
//            defining information display function (server)
// 1999-02-03 Option: Players can not carry weapons/ammo/armor between levels in deathmatch by Maddes
//            defining information display functions (server)
// 1999-02-02 Enhanced info system by Maddes
//            file added
//            information display functions (client and server)

#include "directives.qh"	// 2001-04-22 by Maddes

//
// client information
//
void() AutoAimInfo =
{
	local string	text;

	sprint(self,"Auto-Aiming: ");

	if (self.autoaim_off) sprint(self,"off");
	else sprint(self,"on");

	sprint(self," (");
	text = ftos(IMPULSE_TOGGLE_AIM);
	sprint(self,text);
	sprint(self,")\n");
};

void() ClientInfo =
{
	sprint(self,"… Ãìéåîô Éîæïòíáôéïî …\n");	// Client Information
	AutoAimInfo();		// 1997-12-26 auto-aim toggle by Maddes
	DisplaySkinName(self);		// 1997-12-30 skin support by Maddes
};

//
// server information
//

// 2000-07-16 Option: Sudden death for fraglimit and timelimit by Maddes  start
void() SuddenDeathInfo =
{
	if (!deathmatch)
		return;

	sprint(self,"Sudden Death/Overtime: ");
	if (savedgamecfg & SAVEDGAMECFG_SUDDEN_DEATH) sprint(self,"on");
	else sprint(self,"off");

	sprint(self,"\n");
};
// 2000-07-16 Option: Sudden death for fraglimit and timelimit by Maddes  end

// 1999-10-17 Delayed powerups on map start by Maddes  start
void() DelayedPowerupsInfo =
{
	if (!deathmatch)
		return;

	sprint(self,"Delayed powerups on map start: ");
	if (savedgamecfg & SAVEDGAMECFG_DELAYED_POWERUPS) sprint(self,"on");
	else sprint(self,"off");

	sprint(self,"\n");
};
// 1999-10-17 Delayed powerups on map start by Maddes  end

// 1999-06-03 Resume function by Jim Steers/Maddes  start
void() ResumeInfo =
{
	if (!deathmatch)
		return;

	sprint(self,"Resume: ");
	if (resume) sprint(self,"on");
	else sprint(self,"off");

	if (resume != (savedgamecfg & SAVEDGAMECFG_RESUME))
		sprint(self," (changed for next map)");

	sprint(self,"\n");
};
// 1999-06-03 Resume function by Jim Steers/Maddes  end

// 1999-02-03 Option: Players can not carry weapons/ammo/armor between levels in deathmatch by Maddes  start
void() ItemCarryInfo =
{
	if (!deathmatch)
		return;

	sprint(self,"Respawn \"naked\" on new map: ");
	if (savedgamecfg & SAVEDGAMECFG_RESPAWN_NAKED_ON_NEW_MAP) sprint(self,"on\n");
	else sprint(self,"off\n");
};
// 1999-02-03 Option: Players can not carry weapons/ammo/armor between levels in deathmatch by Maddes  end

// 1999-02-03 Option: Map rotation by Maddes  start
void() MapRotationInfo =
{
	local float		follow_map;
	local string	text;

	if (!deathmatch)
		return;

	sprint(self,"Map rotation: ");

	if (samelevel == 1)
	{
		sprint(self,"repeat map\n");
	}
// 2001-04-22 Option: Random map rotation by Maddes  start
	else if (samelevel > 1)
	{
		sprint(self,"random between #1 - #");
		text = ftos(samelevel);
		sprint(self,text);
		sprint(self,"\n");
	}
// 2001-04-22 Option: Random map rotation by Maddes  end
	else if (samelevel < 0)
	{
		sprint(self,"next is #");
		follow_map = fabs(samelevel);
		text = ftos(follow_map);
		sprint(self,text);
		sprint(self,"\n");
	}
	else
	{
		sprint(self,"disabled\n");
	}
};
// 1999-02-03 Option: Map rotation by Maddes  end

void() MonsterSkinInfo =
{
	local string	text;
	local float	max_skin;

	max_skin = (savedgamecfg & SAVEDGAMECFG_MONSTER_SKIN_NUMBERS_BITS) / SAVEDGAMECFG_MONSTER_SKIN_NUMBERS_BIT1;
	sprint(self,"Monster skins: ");
	text = ftos(max_skin + 1);
	sprint(self,text);
	sprint(self," (max ");
	text = ftos(SAVEDGAMECFG_MONSTER_SKIN_NUMBERS_MAX + 1);
	sprint(self,text);
	if (!deathmatch)
	{
		sprint(self,", ");
		text = ftos(IMPULSE_MONSTER_SKINS_MORE);
		sprint(self,text);
		sprint(self,"/");
		text = ftos(IMPULSE_MONSTER_SKINS_LESS);
		sprint(self,text);
	}
	sprint(self,")\n");

	sprint(self,"        usage: ");
	if (savedgamecfg & SAVEDGAMECFG_MONSTER_RANDOM_SKINS) sprint(self,"random");
	else sprint(self,"skill dependent");
	if (!deathmatch)
	{
		sprint(self," (");
		text = ftos(IMPULSE_MONSTER_SKINS_RANDOM);
		sprint(self,text);
		sprint(self,")");
	}
	sprint(self,"\n");
};


void() PlayerSkinInfo =
{
	local string	text;
	local float	max_skin;

	max_skin = (savedgamecfg & SAVEDGAMECFG_SKIN_NUMBERS_BITS) / SAVEDGAMECFG_SKIN_NUMBERS_BIT1;
	sprint(self,"Player skins: ");
	text = ftos(max_skin + 1);
	sprint(self,text);
	sprint(self," (max ");
	text = ftos(SAVEDGAMECFG_SKIN_NUMBERS_MAX + 1);
	sprint(self,text);
	if (!deathmatch)
	{
		sprint(self,", ");
		text = ftos(IMPULSE_SKINS_MORE);
		sprint(self,text);
		sprint(self,"/");
		text = ftos(IMPULSE_SKINS_LESS);
		sprint(self,text);
	}
	sprint(self,")\n");

	// event skins
	sprint(self," event skins: ");
	if (savedgamecfg & SAVEDGAMECFG_EVENT_SKINS)
		sprint(self,"enabled");
	else
		sprint(self,"disabled");
	if (!deathmatch)
	{
		sprint(self," (");
		text = ftos(IMPULSE_EVENT_SKINS);
		sprint(self,text);
		sprint(self,")");
	}
	sprint(self,"\n");

	// event skins list
	if (savedgamecfg & SAVEDGAMECFG_EVENT_SKINS)
	{
		// biosuit
		sprint(self,"     biosuit: #");
		text = ftos(SKINS_BIOSUIT + 1);
		sprint(self,text);
		sprint(self," (");
		if (max_skin < SKINS_BIOSUIT)
			sprint(self,"inactive");
		else
			sprint(self,"active");
		sprint(self,", not selectable");
		if (SKINS_BIOSUIT == 21)
			sprint(self,", MultiSkin Pro compatible");
		sprint(self,")\n");
	}
};

// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes  start
void() AxeOnlyDM4Info =
{
	if (!deathmatch)
		return;

	if (deathmatch != 4)
		return;

	sprint(self,"Axe-only in DM4 mode: ");
	if (axeonly) sprint(self,"on");
	else sprint(self,"off");

	if (axeonly != (savedgamecfg & SAVEDGAMECFG_RESUME))
		sprint(self," (changed for next map)");

	sprint(self,"\n");
};
// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes  end

void() ServerInfo =
{
	sprint(self,"… Óåòöåò Éîæïòíáôéïî …\n");	// Server Information
	MonsterSkinInfo();
	PlayerSkinInfo();
	MapRotationInfo();				// 1999-02-03 Option: Map rotation by Maddes
	ItemCarryInfo();				// 1999-02-03 Option: Players can not carry weapons/ammo/armor between levels in deathmatch by Maddes

	AxeOnlyDM4Info();	// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes

	ResumeInfo();		// 1999-06-03 Resume function by Jim Steers/Maddes

	DelayedPowerupsInfo();	// 1999-10-17 Delayed powerups on map start by Maddes

	SuddenDeathInfo();	// 2000-07-16 Option: Sudden death for fraglimit and timelimit by Maddes
};

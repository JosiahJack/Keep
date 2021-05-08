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
This file is useful for finding map and other bugs
*/
// 1999-10-23 Possibility to test simultaneous shooting of players in the same frame by Maddes
//            adding counter display function
// 1999-02-20 Functions to locate map bugs by Maddes
//            file added
//            map information functions

#include "directives.qh"	// 2001-04-22 by Maddes

// 1999-10-23 Possibility to test simultaneous shooting of players in the same frame by Maddes  start
#ifdef DEBUG_SHOTS
void() DebugShowCounter =
{
	dprint(self.netname);
	dprint(": ");
	dprint(ftos(self.count));
	dprint("\n");

	remove(self);
};
#endif
// 1999-10-23 Possibility to test simultaneous shooting of players in the same frame by Maddes  end

#ifdef DEBUG_MAPS
void() PrintPosition =
{
	local string	text;
	local float	d;

	d = 1/frametime;
	text = ftos(d);
	sprint(self, "FPS: ");
	sprint(self, text);
	sprint(self, "\n");

	text = vtos(self.origin);
	sprint(self, "origin: ");
	sprint(self, text);
	sprint(self, "\n");

	text = vtos(self.v_angle);
	d = self.angles_y;
	if (d < 0)
		d = d + 360;

	sprint(self, "v_angle:" );
	sprint(self, text);
	sprint(self, ", facing " );
	if ((d >= 22.5) && (d < 67.5))
		sprint(self, "NorthEast" );
	else if ((d >= 67.5) && (d < 112.5))
		sprint(self, "North" );
	else if ((d >= 112.5) && (d < 157.5))
		sprint(self, "NorthWest" );
	else if ((d >= 157.5) && (d < 202.5))
		sprint(self, "West" );
	else if ((d >= 202.5) && (d < 247.5))
		sprint(self, "SouthWest" );
	else if ((d >= 247.5) && (d < 292.5))
		sprint(self, "South" );
	else if ((d >= 292.5) && (d < 337.5))
		sprint(self, "SouthEast" );
	else
		sprint(self, "East" );
	bprint( "\n");
};

void() PrintNearMonsters =
{
	local entity	found;

	found = findradius(self.origin, 512);
	while (found)
	{
		if ((found.classname != "player") && (found.health > 0))
		{
			local string	text;
			local float	separate;

			separate = 0;

			sprint(self, found.classname);
			sprint(self, " at ");
			text = vtos(found.origin);
			sprint(self, text);

			if (found.targetname)
			{
				if (separate) sprint(self, "/");
				else sprint(self, " (");
				sprint(self, "targetname \"");
				sprint(self, found.targetname);
				sprint(self, "\"");
				separate=1;
			}

			if (found.target)
			{
				if (separate) sprint(self, "/");
				else sprint(self, " (");
				sprint(self, "target \"");
				sprint(self, found.target);
				sprint(self, "\"");
				separate=1;
			}

			if (separate) sprint(self, ")");

			sprint(self, "\n");
		}
		found = found.chain;
	}
};

void(entity ent) ToggleTriggerModel =
{
	if (ent.modelindex != 0)
	{
		ent.model = "";
		ent.modelindex = 0;
	}
	else
	{
		setmodel(ent, ent.mdl);
	}
};

void() ToggleTriggerVisibility =
{
	local entity	found;

	found = find(world, classname, "trigger_changelevel");
	while (found)
	{
		ToggleTriggerModel(found);
		found = find(found, classname, "trigger_changelevel");
	}

	found = find(world, classname, "trigger_multiple");
	while (found)
	{
		ToggleTriggerModel(found);
		found = find(found, classname, "trigger_multiple");
	}

	found = find(world, classname, "trigger_once");
	while (found)
	{
		ToggleTriggerModel(found);
		found = find(found, classname, "trigger_once");
	}

	found = find(world, classname, "trigger_relay");
	while (found)
	{
		ToggleTriggerModel(found);
		found = find(found, classname, "trigger_relay");
	}

	found = find(world, classname, "trigger_secret");
	while (found)
	{
		ToggleTriggerModel(found);
		found = find(found, classname, "trigger_secret");
	}

	found = find(world, classname, "trigger_counter");
	while (found)
	{
		ToggleTriggerModel(found);
		found = find(found, classname, "trigger_counter");
	}

	found = find(world, classname, "trigger_teleport");
	while (found)
	{
		ToggleTriggerModel(found);
		found = find(found, classname, "trigger_teleport");
	}

	found = find(world, classname, "trigger_setskill");
	while (found)
	{
		ToggleTriggerModel(found);
		found = find(found, classname, "trigger_setskill");
	}

	found = find(world, classname, "trigger_onlyregistered");
	while (found)
	{
		ToggleTriggerModel(found);
		found = find(found, classname, "trigger_onlyregistered");
	}

	found = find(world, classname, "trigger_hurt");
	while (found)
	{
		ToggleTriggerModel(found);
		found = find(found, classname, "trigger_hurt");
	}

	found = find(world, classname, "trigger_push");
	while (found)
	{
		ToggleTriggerModel(found);
		found = find(found, classname, "trigger_push");
	}

	found = find(world, classname, "trigger_monsterjump");
	while (found)
	{
		ToggleTriggerModel(found);
		found = find(found, classname, "trigger_monsterjump");
	}
};
#endif

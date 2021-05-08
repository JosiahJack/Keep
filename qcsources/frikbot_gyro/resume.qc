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
This file handles resume

Beware! As players can only be identified by their
names, there is a lot of space for cheating
*/
// 2000-06-29 Avoid warnings with FrikQCC by Maddes
//            always returning a value in CheckResume()
// 1999-06-03 Resume function by Jim Steers/Maddes
//            file added
//            defining resume functions

#include "directives.qh"

void() CreateResume =
{
	if (!deathmatch)
		return;

	if (!resume)
		return;

	local entity	new_backup;

	// create a resume entity
	new_backup = spawn();
	new_backup.classname = "player_backup";
	new_backup.think = SUB_Remove;		// cleared after four
	new_backup.nextthink = time + 240;	// minutes of absence
	new_backup.netname = self.netname;
	new_backup.frags = self.frags;
};

float() CheckResume =
{
	if (!deathmatch)
// 2000-06-29 Avoid warnings with FrikQCC by Maddes  start
//		return;
		return FALSE;
// 2000-06-29 Avoid warnings with FrikQCC by Maddes  end

	if (!resume)
// 2000-06-29 Avoid warnings with FrikQCC by Maddes  start
//		return;
		return FALSE;
// 2000-06-29 Avoid warnings with FrikQCC by Maddes  end

	local entity	backup;

	// search resume entity
	backup = find(world, classname, "player_backup");
	while(backup)
	{
		if (backup.netname == self.netname)
		{
			self.frags = backup.frags;	// restore fragcount
			return TRUE;
		}
		backup = find(backup, classname, "player_backup");
	}

	// create a resume entity when not found
	CreateResume();

	return FALSE;
};

void() UpdateResume =
{
	if (!deathmatch)
		return;

	if (!resume)
		return;

	local entity	backup;

	// search resume entity
	backup = find(world, classname, "player_backup");
	while(backup)
	{
		if (backup.netname == self.netname)
		{
			backup.frags = self.frags;	// store fragcount
			backup.nextthink = time + 240;
			return;
		}
		backup = find(backup, classname, "player_backup");
	}

	// create a resume entity when not found
	// necessary when player changes name during the game
	// unfortunately it's not possible to kill the resume entity of the previous name
	// and can be abused by renaming back and forth
//	CreateResume();
};

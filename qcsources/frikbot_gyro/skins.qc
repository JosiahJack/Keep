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
This file handles skin selections
*/
// 2000-06-29 Avoid warnings with FrikQCC by Maddes
//            always returning a value in GetSkinName()
// 1998-01-04 event skin support by Maddes
//            recognizing biosuit skin
// 1997-12-30 skin support by Maddes
//            file added
//            skin select and print functions

#include "directives.qh"

void(entity ent, float prev_or_next) ChangeSkin =
{
	local float	skin_new;			// For calculating issues
	local float	number;				// For calculating issues
	local string	text;				// For printing issues
	local float	max_skin;
	local float	event_skins;			// 1998-01-04 event skin support by Maddes

	if (ent.classname != "player")
		return;

	max_skin = (savedgamecfg & SAVEDGAMECFG_SKIN_NUMBERS_BITS) / SAVEDGAMECFG_SKIN_NUMBERS_BIT1;
	event_skins = savedgamecfg & SAVEDGAMECFG_EVENT_SKINS;	// 1998-01-04 event skin support by Maddes

	skin_new = ent.skin_selected + prev_or_next;	// Add or Subtract the skin-number

	while ( (skin_new < 0)
		|| (event_skins && skin_new == SKINS_BIOSUIT)	// 1998-01-04 event skin support by Maddes  recognize biosuit
		|| (skin_new > max_skin) )
	{
		if (skin_new < 0)				// Cant be below zero (normally Quake Guy)
		{
			skin_new = 0;
			prev_or_next = 1;			// change direction
			sprint(ent,"No skin before #1\n");	// Print "No skins before #1" plus new-line
		}
		else if (skin_new > max_skin)	// Cant be equal to maximum skins
		{
			skin_new = max_skin;
			prev_or_next = -1;			// change direction

			number = max_skin + 1;
// 1998-01-04 event skin support by Maddes  start  correct number
			if (event_skins && number > SKINS_BIOSUIT)		// biosuit
			{
				number = number - 1;
			}
// 1998-01-04 event skin support by Maddes  end  correct number
			text = ftos(number);			// Convert float to string for printing number
			sprint(ent,"Last skin is #");		// Print "Last skin is #<number>" plus new-line
			sprint(ent,text);
			sprint(ent,"\n");
		}
		else
		{
			skin_new = skin_new + prev_or_next;	// Add or Subtract the skin-number
		}
	}

	ent.skin_selected = skin_new;

	SetSkin(ent);

	DisplaySkinName(ent);
};

void(entity ent) SetSkin =
{
// 1998-01-04 event skin support by Maddes  start
	local float	event_skins;
	event_skins = savedgamecfg & SAVEDGAMECFG_EVENT_SKINS;
// 1998-01-04 event skin support by Maddes  end

	if (ent.invisible_finished)		// eyes model does not need multiple skins
		ent.skin = 0;
// 1998-01-04 event skin support by Maddes  start
	else if (event_skins && ent.radsuit_finished)		// biosuit
		ent.skin = SKINS_BIOSUIT;
// 1998-01-04 event skin support by Maddes  end
	else
		ent.skin = ent.skin_selected;
};

void(entity ent) DisplaySkinName =
{
	local float	number;			// For calculating issues
	local string	text;			// For printing issues
	local float	max_skin;
	local float	event_skins;			// 1998-01-04 event skin support by Maddes

	if (ent.classname != "player")
		return;

	max_skin = (savedgamecfg & SAVEDGAMECFG_SKIN_NUMBERS_BITS) / SAVEDGAMECFG_SKIN_NUMBERS_BIT1;
	event_skins = savedgamecfg & SAVEDGAMECFG_EVENT_SKINS;	// 1998-01-04 event skin support by Maddes

	number = ent.skin_selected + 1;		// skin number

// 1998-01-04 event skin support by Maddes  start  correct number
	if (event_skins)
	{
		// biosuit
		if (number > SKINS_BIOSUIT)
			number = number - 1;
		if (max_skin >= SKINS_BIOSUIT)
			max_skin = max_skin - 1;
	}
// 1998-01-04 event skin support by Maddes  end  correct number

	if (!max_skin)
		return;

	sprint(ent,"Skin: #");			// Print "Skin: #<number>"
	text = ftos(number);			// Convert float to string for printing number
	sprint(ent,text);

	text = GetSkinName(ent);
	if (text)
	{
		sprint(ent," \"");		// Print ""<name>""
		sprint(ent,text);
		sprint(ent,"\"");
	}

	if (max_skin)
	{
		sprint(self," (max ");			// Print " (max <max>"
		text = ftos(max_skin + 1);
		sprint(self,text);

		sprint(self,", ");			// Print ", imp/imp)" + new line
		text = ftos(IMPULSE_SKIN_NEXT);
		sprint(self,text);
		sprint(self,"/");
		text = ftos(IMPULSE_SKIN_PREV);
		sprint(self,text);

		sprint(ent,")");
	}
	sprint(ent,"\n");
};

string(entity ent) GetSkinName =
{
	if (ent.classname != "player")
// 2000-06-29 Avoid warnings with FrikQCC by Maddes  start
//		return;
		return "UNKNOWN";
// 2000-06-29 Avoid warnings with FrikQCC by Maddes  end

// Here you enter what skin number goes with what text, just type the name of the skin where you see <name>
// and don't forget to remove the comment characters "//" from the line
	if      (ent.skin_selected ==  0) return("Quake Guy");
	else if (ent.skin_selected ==  1) return("Bot Skill 0 Skin");
	else if (ent.skin_selected ==  2) return("Bot Skill 1 Skin");
	else if (ent.skin_selected ==  3) return("Bot Skill 2 Skin");
	else if (ent.skin_selected ==  4) return("Bot Skill 3 Skin");
	else if (ent.skin_selected ==  5) return("Imperial Stormtrooper");
	else if (ent.skin_selected ==  6) return("Mandalorian Commando");
	else if (ent.skin_selected ==  7) return("Executor");
	else if (ent.skin_selected ==  8) return("Punisher");
	else if (ent.skin_selected ==  9) return("Jules Winfield");
	else if (ent.skin_selected == 10) return("Vincent Vega");
	else if (ent.skin_selected == 11) return("Predator");
	else if (ent.skin_selected == 12) return("Klingon");
	else if (ent.skin_selected == 13) return("Crow");
	else if (ent.skin_selected == 14) return("Spawn");
	else if (ent.skin_selected == 15) return("Terminator");
	else if (ent.skin_selected == 16) return("Hulk");
	else if (ent.skin_selected == 17) return("Cyclops");
	else if (ent.skin_selected == 18) return("Cable");
	else if (ent.skin_selected == 19) return("Ghostbuster");
	else if (ent.skin_selected == 20) return("Ranger");
	else if (ent.skin_selected == 21) return("BioSuit");
	else if (ent.skin_selected == 22) return("Boosk");
	else if (ent.skin_selected == 23) return("X-Wing Pilot");
	else if (ent.skin_selected == 24) return("Doom Marine");
	else if (ent.skin_selected == 25) return("MoD");
	else if (ent.skin_selected == 26) return("Lobo");
	else if (ent.skin_selected == 27) return("Toad");
	else if (ent.skin_selected == 28) return("Duke Nukem");
	else if (ent.skin_selected == 29) return("Wolf");
	else if (ent.skin_selected == 30) return("Guybrush Threepwood");
	else if (ent.skin_selected == 31) return("Star Trek: TNG");
// 2000-06-29 Avoid warnings with FrikQCC by Maddes  start
//	return;
	return "UNKNOWN";
// 2000-06-29 Avoid warnings with FrikQCC by Maddes  end
};

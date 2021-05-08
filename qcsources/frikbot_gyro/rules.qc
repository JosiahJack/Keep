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
This file handles game rules
*/
// 2000-07-16 Option: Sudden death for fraglimit and timelimit by Maddes
//            adding sudden death funtionality to CheckRules() function
// 2000-07-15 Restructured fraglimit and timelimit by Maddes
//            file renamed from timer.qc to rules.qc
//            removing timelimit check in timewarning function
//            defining new CheckRules() function
// 1998-09-15 Two minute warning by Maddes
//            file added
//            time warnung function

#include "directives.qh"

float nexttimewarning;

void() TimeWarning =
{
	local float	timelimit;
	local float	startwarn;
	local float	timeleft;
	local float	minutes, seconds;
	local string	mintext, sectext;

// 2000-07-15 Restructured fraglimit and timelimit by Maddes  start
/*
	if (gameover)	// someone else quit the game already
	{
		remove(self);
		return;
	}

	self.nextthink = time + 0.05;

	if (!deathmatch)
	{
		return;
	}
*/
// 2000-07-15 Restructured fraglimit and timelimit by Maddes  end

	timelimit = cvar("timelimit") * 60;
	if (!timelimit)
	{
		return;
	}

// 2000-07-15 Restructured fraglimit and timelimit by Maddes  start
/*
	if (time >= timelimit)
	{
		bprint("\nΤινεμινιτ θιτ ­ Νατγθ οφες\n");	// "Timelimit hit - Match over"
		sound(self, CHAN_VOICE, "doors/airdoor2.wav", 1.0, ATTN_NONE);
		NextLevel ();
		remove(self);
		return;
	}
*/
// 2000-07-15 Restructured fraglimit and timelimit by Maddes  end

	startwarn = rint(timelimit / 3);	// start warning not before 33% of timelimit
	if (startwarn < 60)
	{
		startwarn = 60;			// always 1 minute warning
	}

	timeleft = ceil(timelimit - time);	// calc time left

	if ((timeleft == nexttimewarning) && (timeleft <= startwarn))	// 1 frame per second needed :)
	{
		// display warning
		bprint("… Τινεμινιτ θιτ ιξ ");	// "* Timelimit hit in "

		minutes = floor(timeleft / 60);
		seconds = timeleft - (minutes * 60);

		if (minutes)
		{
			mintext = ftos(minutes);
			bprint(mintext);
			if (minutes == 1)
			{
				bprint(" minute");
			}
			else
			{
				bprint(" minutes");
			}
			if (seconds)
			{
				bprint(" and ");
			}
		}
		if (seconds)
		{
			sectext = ftos(seconds);
			bprint(sectext);
			if (seconds == 1)
			{
				bprint(" second");
			}
			else
			{
				bprint(" seconds");
			}
		}
		bprint("\n");

		if (timeleft > 5)
		{
			sound(self, CHAN_VOICE, "misc/talk.wav", 0.6, ATTN_NONE);
		}
		else
		{
			sound(self, CHAN_VOICE, "misc/talk.wav", 0.9, ATTN_NONE);
		}
	}

	// calculate next warning
	if (timeleft > 1800)		// 30 minutes
	{
		nexttimewarning = 1800;
	}
	else if (timeleft > 1200)	// 20 minutes
	{
		nexttimewarning = 1200;
	}
	else if (timeleft > 600)	// 10 minutes
	{
		nexttimewarning = 600;
	}
	else if (timeleft > 300)	// 5 minutes
	{
		nexttimewarning = 300;
	}
	else if (timeleft > 120)	// 2 minutes
	{
		nexttimewarning = 120;
	}
	else if (timeleft > 60)		// 1 minute
	{
		nexttimewarning = 60;
	}
	else if (timeleft > 30)		// 30 seconds
	{
		nexttimewarning = 30;
	}
	else if (timeleft > 20)		// 20 seconds
	{
		nexttimewarning = 20;
	}
	else if (timeleft > 10)		// 10 seconds
	{
		nexttimewarning = 10;
	}
	else if (timeleft > 5)		// 5 seconds
	{
		nexttimewarning = 5;
	}
	else				// countdown from then on
	{
		nexttimewarning = timeleft - 1;
	}
};

float	suddendeath;	// 2000-07-16 Option: Sudden death for fraglimit and timelimit by Maddes

// 2000-07-15 Restructured fraglimit and timelimit by Maddes  start
void() CheckRules =
{
	if (gameover)		// someone else quit the game already
	{
		return;
	}

	// check if limits exist at all
	local float	timelimit;
	local float	fraglimit;

	timelimit = cvar("timelimit") * 60;	// timelimit in seconds
	fraglimit = cvar("fraglimit");
	if(!timelimit)		// no timelimit set
	{
		if (!fraglimit)	// AND no fraglimit set
		{
			return;
		}
	}

// 2000-07-16 Option: Sudden death for fraglimit and timelimit by Maddes  start
	// check for suddendeath situation
	local float	winners;
	winners = 0;
// 2000-07-16 Option: Sudden death for fraglimit and timelimit by Maddes  end

	// determine current highscore for fraglimit
	local float	highfrags;
	highfrags = 0;

	other = find (world, classname, "player");
	highfrags = other.frags;
	while (other != world)
	{
// 2000-07-16 Option: Sudden death for fraglimit and timelimit by Maddes  start
		if (other.frags == highfrags)
		{
			winners = winners + 1;
		}
// 2000-07-16 Option: Sudden death for fraglimit and timelimit by Maddes  end
		else if (other.frags > highfrags)
		{
			highfrags = other.frags;
			winners = 1;	// 2000-07-16 Option: Sudden death for fraglimit and timelimit by Maddes
		}
		other = find (other, classname, "player");
	}
// 2000-07-16 Option: Sudden death for fraglimit and timelimit by Maddes  start
	if ((savedgamecfg & SAVEDGAMECFG_SUDDEN_DEATH) && (winners > 1))	// sudden death situation
	{
		if (!suddendeath)
		{
			suddendeath = time;	// remember start of sudden death
		}
	}
	else
	{
		suddendeath = 0;	// clear state
	}
// 2000-07-16 Option: Sudden death for fraglimit and timelimit by Maddes  end

	// if fraglimit NOT hit then clear fraglimit
	if (!(fraglimit && highfrags >= fraglimit))
	{
		fraglimit = 0;
	}

	// if timelimit NOT hit then clear timelimit
	if (!(timelimit && time >= timelimit))
	{
		timelimit = 0;
	}

	// check if any limit at all
	if (!timelimit)		// timelimit NOT hit
	{
		if (!fraglimit)	// AND fraglimit NOT hit
		{
			TimeWarning();
			return;
		}
	}

// 2000-07-16 Option: Sudden death for fraglimit and timelimit by Maddes  start
	if (suddendeath)	// limit hit during suddendeath situation
	{
		if (time >= suddendeath)
		{
			bprint("\n");
			if (timelimit)
			{
				bprint("Overtime ­ ");
			}
			bprint("Sudden Death\n");
	
			sound(self, CHAN_VOICE, "misc/talk.wav", 0.9, ATTN_NONE);
			suddendeath = time + 30;
		}
	}
	else
	{
// 2000-07-16 Option: Sudden death for fraglimit and timelimit by Maddes  end
		if (fraglimit)
		{
			bprint("\nΖςαημινιτ θιτ ­ Νατγθ οφες\n");	// "Fraglimit hit - Match over"
		}
		if (timelimit)
		{
			bprint("\nΤινεμινιτ θιτ ­ Νατγθ οφες\n");	// "Timelimit hit - Match over"
		}
		sound(self, CHAN_VOICE, "doors/airdoor2.wav", 1.0, ATTN_NONE);
		NextLevel ();
	}	// 2000-07-16 Option: Sudden death for fraglimit and timelimit by Maddes
};
// 2000-07-15 Restructured fraglimit and timelimit by Maddes  end

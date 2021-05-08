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

//qb: add urqp items
// 2001-11-18 Random number function
//            adding new QuakeC function
// 2001-10-20 Extension System by Lord Havoc
//            checking if extension_find() exists
// 2001-09-25 New BuiltIn Function: etof() by Maddes
//            checking if etof() exists
// 2001-09-25 New BuiltIn Function: ftoe() by Maddes
//            checking if ftoe() exists
// 2001-09-20 QuakeC string manipulation by FrikaC
//            checking if functions exists
// 2001-09-20 QuakeC file access by FrikaC
//            checking if functions exists
// 2001-09-18 New BuiltIn Function: cvar_create() by LordHavoc/Maddes
//            checking if cvar_create() exists
// 2001-09-18 New BuiltIn Function: cvar_free() by Maddes
//            checking if cvar_free() exists
// 2001-09-16 New BuiltIn Function: cmd_find() by Maddes
//            checking if cmd_find() exists
// 2001-09-16 New BuiltIn Function: cvar_find() by Maddes
//            checking if cvar_find() exists
// 2001-09-16 New BuiltIn Function: cvar_string() by Maddes
//            checking if cvar_string() exists
// 2001-09-14 Enhanced BuiltIn Function System (EBFS) by Maddes
//            checking if builtin_find() exists
// 2001-09-10 FrikBot support by FrikaC
//            calling FrikBot routines
// 2001-08-01 No silmultaneous shots fix by Maddes
//            calling new damage functions after all entities have been processed
// 2000-07-15 Restructured fraglimit and timelimit by Maddes
//            removing timewarning entity spawning
//            and adding necessary endframe code
// 2000-07-14 Debug function for client view bug by Maddes
//            displaying that debug code is available
// 2000-01-09 QCExec by FrikaC/Maddes
//            adding example code
// 2000-01-02 EndFrame function by Maddes
//            adding example code
// 1999-10-23 Possibility to test simultaneous shooting of players in the same frame by Maddes
//            displaying that debug code is available
// 1999-10-15 Rearranged use of console variables again by Maddes
//            reading new cvars on worldspawn and once every frame
// 1999-08-08 Quad cheat sound fix by Carlos H. P. da Silva
//            precaching quad sounds
// 1999-06-04 Rearranged use of console variables by Maddes
//            reading "SAVEDx" on worldspawn and once every frame
// 1999-06-03 Resume function by Jim Steers/Maddes
//            reading "SAVEDGAMECFG" on worldspawn for resume
// 1999-02-20 Functions to locate map bugs by Maddes  start
//            displaying that debug code is available
// 1999-02-19 Enhanced debugging support by Maddes
//            reading "DEVELOPER" on worldspawn and once every frame
// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes
//            reading "SAVEDGAMECFG" on worldspawn for axe-only matches in DM4 mode
// 1999-02-03 Checking for additional cvars of Quake 1.07+ by Maddes  start
//            testing if cvar "SCRATCH1" exists
// 1999-02-03 Option: Map rotation by Maddes
//            reading cvar "SAMELEVEL" every frame
// 1999-02-02 Option: Toggle for previous optional functions by Maddes (no compiling needed anymore)
//            reading "SAVEDGAMECFG" on worldspawn for use with monster skins
// 1999-02-01 Removing unnecessary use of "TEMP1" for testing player death scenes by Maddes (needed for new options)
//            reading "TEMP1" on worldspawn and once every frame
// 1998-09-15 Two minute warning by Maddes
//            spawning timer entity in deathmatch
// 1998-09-17 Skill variable is not correctly set on worldspawn and can be changed through gameplay fix by Maddes
//            reading cvar "skill" only on worldspawn (map start)
// 1997-12-30 skin support by Maddes
//            preserving the skin on the dead player
// 1997-12-25 ftos() workaround by Maddes
//            testing quake.exe on ftos()

#include "directives.qh"

void() InitBodyQueue;

// 2000-01-02 EndFrame function by Maddes  start
float	endframe;
void()	EndFrameCode;
// 2000-01-02 EndFrame function by Maddes  end

void() main =
{
	dprint ("main function\n");
	
// these are just commands the the prog compiler to copy these files

	precache_file ("progs.dat");
	precache_file ("gfx.wad");
	precache_file ("quake.rc");
	precache_file ("default.cfg");

	precache_file ("end1.bin");
	precache_file2 ("end2.bin");

	precache_file ("demo1.dem");
	precache_file ("demo2.dem");
	precache_file ("demo3.dem");

//
// these are all of the lumps from the cached.ls files
//
	precache_file ("gfx/palette.lmp");
	precache_file ("gfx/colormap.lmp");

	precache_file2 ("gfx/pop.lmp");

	precache_file ("gfx/complete.lmp");
	precache_file ("gfx/inter.lmp");

	precache_file ("gfx/ranking.lmp");
	precache_file ("gfx/vidmodes.lmp");
	precache_file ("gfx/finale.lmp");
	precache_file ("gfx/conback.lmp");
	precache_file ("gfx/qplaque.lmp");

	precache_file ("gfx/menudot1.lmp");
	precache_file ("gfx/menudot2.lmp");
	precache_file ("gfx/menudot3.lmp");
	precache_file ("gfx/menudot4.lmp");
	precache_file ("gfx/menudot5.lmp");
	precache_file ("gfx/menudot6.lmp");

	precache_file ("gfx/menuplyr.lmp");
	precache_file ("gfx/bigbox.lmp");
	precache_file ("gfx/dim_modm.lmp");
	precache_file ("gfx/dim_drct.lmp");
	precache_file ("gfx/dim_ipx.lmp");
	precache_file ("gfx/dim_tcp.lmp");
	precache_file ("gfx/dim_mult.lmp");
	precache_file ("gfx/mainmenu.lmp");
	
	precache_file ("gfx/box_tl.lmp");
	precache_file ("gfx/box_tm.lmp");
	precache_file ("gfx/box_tr.lmp");
	
	precache_file ("gfx/box_ml.lmp");
	precache_file ("gfx/box_mm.lmp");
	precache_file ("gfx/box_mm2.lmp");
	precache_file ("gfx/box_mr.lmp");
	
	precache_file ("gfx/box_bl.lmp");
	precache_file ("gfx/box_bm.lmp");
	precache_file ("gfx/box_br.lmp");
	
	precache_file ("gfx/sp_menu.lmp");
	precache_file ("gfx/ttl_sgl.lmp");
	precache_file ("gfx/ttl_main.lmp");
	precache_file ("gfx/ttl_cstm.lmp");
	
	precache_file ("gfx/mp_menu.lmp");
	
	precache_file ("gfx/netmen1.lmp");
	precache_file ("gfx/netmen2.lmp");
	precache_file ("gfx/netmen3.lmp");
	precache_file ("gfx/netmen4.lmp");
	precache_file ("gfx/netmen5.lmp");
	
	precache_file ("gfx/sell.lmp");
	
	precache_file ("gfx/help0.lmp");
	precache_file ("gfx/help1.lmp");
	precache_file ("gfx/help2.lmp");
	precache_file ("gfx/help3.lmp");
	precache_file ("gfx/help4.lmp");
	precache_file ("gfx/help5.lmp");

	precache_file ("gfx/pause.lmp");
	precache_file ("gfx/loading.lmp");

	precache_file ("gfx/p_option.lmp");
	precache_file ("gfx/p_load.lmp");
	precache_file ("gfx/p_save.lmp");
	precache_file ("gfx/p_multi.lmp");

// sounds loaded by C code
	precache_sound ("misc/menu1.wav");
	precache_sound ("misc/menu2.wav");
	precache_sound ("misc/menu3.wav");

	precache_sound ("ambience/water1.wav");
	precache_sound ("ambience/wind2.wav");

// shareware
	precache_file ("maps/start.bsp");

	precache_file ("maps/e1m1.bsp");
	precache_file ("maps/e1m2.bsp");
	precache_file ("maps/e1m3.bsp");
	precache_file ("maps/e1m4.bsp");
	precache_file ("maps/e1m5.bsp");
	precache_file ("maps/e1m6.bsp");
	precache_file ("maps/e1m7.bsp");
	precache_file ("maps/e1m8.bsp");

// registered
	precache_file2 ("gfx/pop.lmp");

	precache_file2 ("maps/e2m1.bsp");
	precache_file2 ("maps/e2m2.bsp");
	precache_file2 ("maps/e2m3.bsp");
	precache_file2 ("maps/e2m4.bsp");
	precache_file2 ("maps/e2m5.bsp");
	precache_file2 ("maps/e2m6.bsp");
	precache_file2 ("maps/e2m7.bsp");

	precache_file2 ("maps/e3m1.bsp");
	precache_file2 ("maps/e3m2.bsp");
	precache_file2 ("maps/e3m3.bsp");
	precache_file2 ("maps/e3m4.bsp");
	precache_file2 ("maps/e3m5.bsp");
	precache_file2 ("maps/e3m6.bsp");
	precache_file2 ("maps/e3m7.bsp");

	precache_file2 ("maps/e4m1.bsp");
	precache_file2 ("maps/e4m2.bsp");
	precache_file2 ("maps/e4m3.bsp");
	precache_file2 ("maps/e4m4.bsp");
	precache_file2 ("maps/e4m5.bsp");
	precache_file2 ("maps/e4m6.bsp");
	precache_file2 ("maps/e4m7.bsp");
	precache_file2 ("maps/e4m8.bsp");

	precache_file2 ("maps/end.bsp");

	precache_file2 ("maps/dm1.bsp");
	precache_file2 ("maps/dm2.bsp");
	precache_file2 ("maps/dm3.bsp");
	precache_file2 ("maps/dm4.bsp");
	precache_file2 ("maps/dm5.bsp");
	precache_file2 ("maps/dm6.bsp");
};


entity	lastspawn;

//=======================
/*QUAKED worldspawn (0 0 0) ?
Only used for the world entity.
Set message to the level name.
Set sounds to the cd track to play.

World Types:
0: medieval
1: metal
2: base
*/
//=======================
void() worldspawn =
{
	local string	tmpstr;	// used for many things
							// 1999-10-20 Custom gravity for maps by RocketMan/Maddes  start

	developer = cvar("developer");	// 1999-02-19 Enhanced debugging support by Maddes

#ifdef DEBUG
	dprint("DEBUG: Additional debug information is available.\n");
#endif
// 1999-10-23 Possibility to test simultaneous shooting of players in the same frame by Maddes  end
#ifdef DEBUG_SHOTS
	dprint("DEBUG: Debug code for testing simultaneous shots is available (IMPULSES: ");
	dprint(ftos(IMPULSE_DEBUG_SHOTS));
	dprint(")\n");
#endif
// 1999-10-23 Possibility to test simultaneous shooting of players in the same frame by Maddes  end
// 1999-02-20 Functions to locate map bugs by Maddes  start
#ifdef DEBUG_MAPS
	dprint("DEBUG: Debug code for testing maps is available (IMPULSES: ");
	dprint(ftos(IMPULSE_PLAYER_POSITION));
	dprint(", ");
	dprint(ftos(IMPULSE_LIVING_MONSTERS));
	dprint(", ");
	dprint(ftos(IMPULSE_TRIGGER_VISIBILITY));
	dprint(")\n");
#endif
// 1999-02-20 Functions to locate map bugs by Maddes  end
// 2000-07-14 Debug function for client view bug by Maddes  start
#ifdef DEBUG_CLIENTVIEW
	dprint("DEBUG: Debug code for client view bug is available (IMPULSE: ");
	dprint(ftos(IMPULSE_DEBUG_CLIENTVIEW));
	dprint(")\n");
#endif
// 2000-07-14 Debug function for client view bug by Maddes  end

// 2001-09-14 Enhanced BuiltIn Function System (EBFS) by Maddes  start
	qc_builtin_find = cvar("pr_builtin_find");
	if (qc_builtin_find)
	{
		if (qc_builtin_find != 100)
		{
			dprint("Builtin function \"builtin_find\" is #");
			dprint(ftos(qc_builtin_find));
			dprint(" and not #100 - IGNORED!!!\n");
			qc_builtin_find = 0;
		}
	}

	// check for additional builtin functions
	qc_cmd_find = 0;		// 2001-09-16 New BuiltIn Function: cmd_find() by Maddes
	qc_cvar_find = 0;		// 2001-09-16 New BuiltIn Function: cvar_find() by Maddes
	qc_cvar_string = 0;		// 2001-09-16 New BuiltIn Function: cvar_string() by Maddes
	qc_cvar_create = 0;		// 2001-09-18 New BuiltIn Function: cvar_create() by LordHavoc/Maddes
	qc_cvar_free = 0;		// 2001-09-18 New BuiltIn Function: cvar_free() by Maddes

// 2001-09-20 QuakeC string manipulation by FrikaC  start
	qc_stof = 0;
	qc_strlen = 0;
	qc_strcat = 0;
	qc_substring = 0;
	qc_stov = 0;
	qc_zone = 0;
	qc_unzone = 0;
// 2001-09-20 QuakeC string manipulation by FrikaC  end

// 2001-09-20 QuakeC file access by FrikaC  start
	qc_file_open = 0;
	qc_file_close = 0;
	qc_file_read = 0;
	qc_file_write = 0;
// 2001-09-20 QuakeC file access by FrikaC  end

	qc_etof = 0;	// 2001-09-25 New BuiltIn Function: etof() by Maddes
	qc_ftoe = 0;	// 2001-09-25 New BuiltIn Function: ftoe() by Maddes
	qc_extension_find = 0;	// 2001-10-20 Extension System by Lord Havoc

	if (qc_builtin_find)
	{
// 2001-09-16 New BuiltIn Function: cmd_find() by Maddes  start
		qc_cmd_find = builtin_find("cmd_find");
		if (qc_cmd_find)
		{
			if (qc_cmd_find != 101)
			{
				dprint("Builtin function \"cmd_find\" is #");
				dprint(ftos(qc_cmd_find));
				dprint(" and not #101 - IGNORED!!!\n");
				qc_cmd_find = 0;
			}
		}
// 2001-09-16 New BuiltIn Function: cmd_find() by Maddes  end

// 2001-09-16 New BuiltIn Function: cvar_find() by Maddes  start
		qc_cvar_find = builtin_find("cvar_find");
		if (qc_cvar_find)
		{
			if (qc_cvar_find != 102)
			{
				dprint("Builtin function \"cvar_find\" is #");
				dprint(ftos(qc_cvar_find));
				dprint(" and not #102 - IGNORED!!!\n");
				qc_cvar_find = 0;
			}
		}
// 2001-09-16 New BuiltIn Function: cvar_find() by Maddes  end

// 2001-09-16 New BuiltIn Function: cvar_string() by Maddes  start
		qc_cvar_string = builtin_find("cvar_string");
		if (qc_cvar_string)
		{
			if (qc_cvar_string != 103)
			{
				dprint("Builtin function \"cvar_string\" is #");
				dprint(ftos(qc_cvar_string));
				dprint(" and not #103 - IGNORED!!!\n");
				qc_cvar_string = 0;
			}
		}
// 2001-09-16 New BuiltIn Function: cvar_string() by Maddes  end

// 2001-09-18 New BuiltIn Function: cvar_create() by LordHavoc/Maddes  start
		qc_cvar_create = builtin_find("cvar_create");
		if (qc_cvar_create)
		{
			if (qc_cvar_create != 93)
			{
				dprint("Builtin function \"cvar_create\" is #");
				dprint(ftos(qc_cvar_create));
				dprint(" and not #104 - IGNORED!!!\n");
				qc_cvar_create = 0;
			}
		}
// 2001-09-18 New BuiltIn Function: cvar_create() by LordHavoc/Maddes  end

// 2001-09-18 New BuiltIn Function: cvar_free() by Maddes  start
		qc_cvar_free = builtin_find("cvar_free");
		if (qc_cvar_free)
		{
			if (qc_cvar_free != 105)
			{
				dprint("Builtin function \"cvar_free\" is #");
				dprint(ftos(qc_cvar_free));
				dprint(" and not #105 - IGNORED!!!\n");
				qc_cvar_free = 0;
			}
		}
// 2001-09-18 New BuiltIn Function: cvar_free() by Maddes  end


// 2001-09-20 QuakeC string manipulation by FrikaC  start
		qc_stof = builtin_find("stof");
		if (qc_stof)
		{
			if (qc_stof != 81)
			{
				dprint("Builtin function \"stof\" is #");
				dprint(ftos(qc_stof));
				dprint(" and not #81 - IGNORED!!!\n");
				qc_stof = 0;
			}
		}

		qc_strlen = builtin_find("strlen");
		if (qc_strlen)
		{
			if (qc_strlen != 114)
			{
				dprint("Builtin function \"strlen\" is #");
				dprint(ftos(qc_strlen));
				dprint(" and not #114 - IGNORED!!!\n");
				qc_strlen = 0;
			}
		}

		qc_strcat = builtin_find("strcat");
		if (qc_strcat)
		{
			if (qc_strcat != 115)
			{
				dprint("Builtin function \"strcat\" is #");
				dprint(ftos(qc_strcat));
				dprint(" and not #115 - IGNORED!!!\n");
				qc_strcat = 0;
			}
		}

		qc_substring = builtin_find("substring");
		if (qc_substring)
		{
			if (qc_substring != 116)
			{
				dprint("Builtin function \"substring\" is #");
				dprint(ftos(qc_substring));
				dprint(" and not #116 - IGNORED!!!\n");
				qc_substring = 0;
			}
		}

		qc_stov = builtin_find("stov");
		if (qc_stov)
		{
			if (qc_stov != 117)
			{
				dprint("Builtin function \"stov\" is #");
				dprint(ftos(qc_stov));
				dprint(" and not #117 - IGNORED!!!\n");
				qc_stov = 0;
			}
		}

		qc_zone = builtin_find("zone");
		if (qc_zone)
		{
			if (qc_zone != 118)
			{
				dprint("Builtin function \"zone\" is #");
				dprint(ftos(qc_zone));
				dprint(" and not #118 - IGNORED!!!\n");
				qc_zone = 0;
			}
		}

		qc_unzone = builtin_find("unzone");
		if (qc_unzone)
		{
			if (qc_unzone != 119)
			{
				dprint("Builtin function \"unzone\" is #");
				dprint(ftos(qc_unzone));
				dprint(" and not #119 - IGNORED!!!\n");
				qc_unzone = 0;
			}
		}
// 2001-09-20 QuakeC string manipulation by FrikaC  end

// 2001-09-20 QuakeC file access by FrikaC  start
		qc_file_open = builtin_find("file_open");
		if (qc_file_open)
		{
			if (qc_file_open != 110)
			{
				dprint("Builtin function \"file_open\" is #");
				dprint(ftos(qc_file_open));
				dprint(" and not #110 - IGNORED!!!\n");
				qc_file_open = 0;
			}
		}

		qc_file_close = builtin_find("file_close");
		if (qc_file_close)
		{
			if (qc_file_close != 111)
			{
				dprint("Builtin function \"file_close\" is #");
				dprint(ftos(qc_file_close));
				dprint(" and not #111 - IGNORED!!!\n");
				qc_file_close = 0;
			}
		}

		qc_file_read = builtin_find("file_read");
		if (qc_file_read)
		{
			if (qc_file_read != 112)
			{
				dprint("Builtin function \"file_read\" is #");
				dprint(ftos(qc_file_read));
				dprint(" and not #112 - IGNORED!!!\n");
				qc_file_read = 0;
			}
		}

		qc_file_write = builtin_find("file_write");
		if (qc_file_write)
		{
			if (qc_file_write != 113)
			{
				dprint("Builtin function \"file_write\" is #");
				dprint(ftos(qc_file_write));
				dprint(" and not #113 - IGNORED!!!\n");
				qc_file_write = 0;
			}
		}
// 2001-09-20 QuakeC file access by FrikaC  end

// 2001-09-25 New BuiltIn Function: etof() by Maddes  start
		qc_etof = builtin_find("etof");
		if (qc_etof)
		{
			if (qc_etof != 108)
			{
				dprint("Builtin function \"etof\" is #");
				dprint(ftos(qc_etof));
				dprint(" and not #108 - IGNORED!!!\n");
				qc_etof = 0;
			}
		}
// 2001-09-25 New BuiltIn Function: etof() by Maddes  end

// 2001-09-25 New BuiltIn Function: ftoe() by Maddes  start
		qc_ftoe = builtin_find("ftoe");
		if (qc_ftoe)
		{
			if (qc_ftoe != 109)
			{
				dprint("Builtin function \"ftoe\" is #");
				dprint(ftos(qc_ftoe));
				dprint(" and not #109 - IGNORED!!!\n");
				qc_ftoe = 0;
			}
		}
// 2001-09-25 New BuiltIn Function: ftoe() by Maddes  end

// 2001-10-20 Extension System by Lord Havoc  start
		qc_extension_find = builtin_find("extension_find");
		if (qc_extension_find)
		{
			if (qc_extension_find != 99)
			{
				dprint("Builtin function \"extension_find\" is #");
				dprint(ftos(qc_extension_find));
				dprint(" and not #99 - IGNORED!!!\n");
				qc_extension_find = 0;
			}
		}
// 2001-10-20 Extension System by Lord Havoc  end
	}
// 2001-09-14 Enhanced BuiltIn Function System (EBFS) by Maddes  end

// 2001-10-20 Extension System by Lord Havoc  start
/*
	if (qc_extension_find)
	{
		// check for extensions here
	}
*/
// 2001-10-20 Extension System by Lord Havoc  end

// 2000-05-02 Network versioning system (NVS) by Maddes  start
#ifdef EXAMPLE_NVS
	self.nvs_svc = 0;

	// NVS server <-> progs.dat/QuakeC handshake
	if (qc_nvs_initsvcmsg)		// only useful when NVS_InitSVCMsg() is available
	{
		self.nvs_svc = 0.99;	// recommended version

#ifdef DEBUG
		// --> Warning!!! This if-clause should be removed in the public release of your PROGS.DAT
		//     check for testing PROGS.DAT with different NVS version
		if (developer)
		{
			self.nvs_svc = cvar("nvs_test_version");	// only accessible with "set"-capable engine
			dprint("PROGS.DAT: SSVC will be set to ");
			dprint(ftos(self.nvs_svc));
			dprint(" for debugging\n");
		}
#endif
	}

	// set server to recommended NVS version...
	tmpstr = ftos(self.nvs_svc);
	cvar_set ("nvs_current_ssvc", tmpstr);

	// ...and read supported NVS version
	self.nvs_svc = cvar("nvs_current_ssvc");

	if (self.nvs_svc < 0.50)
	{
//		error("Server doesn't support required NVS version 0.50\nNVS version 0.99 is recommended\nPlease visit http://www.quake-info-pool.net/ or http://www.quakesrc.org/\n");
		dprint("Server doesn't support required NVS version 0.50\nNVS version 0.99 is recommended\nPlease visit http://www.quake-info-pool.net/ or http://www.quakesrc.org/\n");	// remove me
	}

	// Please note that .nvs_svc of clients is set properly by the engine on client connect and every single frame
#endif
// 2000-05-02 Network versioning system (NVS) by Maddes  end

	lastspawn = world;
	BotInit();	// 2001-09-10 FrikBot support by FrikaC
	InitBodyQueue ();

	// custom map attributes
// 1999-10-20 Custom gravity for maps by RocketMan/Maddes  start
	if (self.gravity)
	{
		tmpstr = ftos(self.gravity);
		cvar_set ("sv_gravity", tmpstr);
		dprint ("Custom gravity set to ");
		dprint (tmpstr);
		dprint ("\n");
	}
	else
	{
// 1999-10-20 Custom gravity for maps by RocketMan/Maddes  end
	if (self.model == "maps/e1m8.bsp")
		cvar_set ("sv_gravity", "100");
	else
		cvar_set ("sv_gravity", "800");

// 1999-10-20 Custom gravity for maps by RocketMan/Maddes  start
		self.gravity = cvar("sv_gravity");
	}
// 1999-10-20 Custom gravity for maps by RocketMan/Maddes  end

	// the area based ambient sounds MUST be the first precache_sounds

	// player precaches	
	W_Precache ();			// get weapon precaches

	// sounds used from C physics code
	precache_sound ("demon/dland2.wav");		// landing thud
	precache_sound ("misc/h2ohit1.wav");		// landing splash

// setup precaches always needed
	precache_sound ("items/itembk2.wav");		// item respawn sound
	precache_sound ("player/plyrjmp8.wav");		// player jump
	precache_sound ("player/land.wav");			// player landing
	precache_sound ("player/land2.wav");		// player hurt landing
	precache_sound ("player/drown1.wav");		// drowning pain
	precache_sound ("player/drown2.wav");		// drowning pain
	precache_sound ("player/gasp1.wav");		// gasping for air
	precache_sound ("player/gasp2.wav");		// taking breath
	precache_sound ("player/h2odeath.wav");		// drowning death

	precache_sound ("misc/talk.wav");			// talk
	precache_sound ("player/teledth1.wav");		// telefrag
	precache_sound ("misc/r_tele1.wav");		// teleport sounds
	precache_sound ("misc/r_tele2.wav");
	precache_sound ("misc/r_tele3.wav");
	precache_sound ("misc/r_tele4.wav");
	precache_sound ("misc/r_tele5.wav");
	precache_sound ("weapons/lock4.wav");		// ammo pick up
	precache_sound ("weapons/pkup.wav");		// weapon up
	precache_sound ("items/armor1.wav");		// armor up
	precache_sound ("weapons/lhit.wav");		//lightning
	precache_sound ("weapons/lstart.wav");		//lightning start
	precache_sound ("items/damage3.wav");

	precache_sound ("misc/power.wav");			//lightning for boss

// player gib sounds
	precache_sound ("player/gib.wav");			// player gib sound
	precache_sound ("player/udeath.wav");		// player gib sound
	precache_sound ("player/tornoff2.wav");		// gib sound

// player pain sounds

	precache_sound ("player/pain1.wav");
	precache_sound ("player/pain2.wav");
	precache_sound ("player/pain3.wav");
	precache_sound ("player/pain4.wav");
	precache_sound ("player/pain5.wav");
	precache_sound ("player/pain6.wav");

// player death sounds
	precache_sound ("player/death1.wav");
	precache_sound ("player/death2.wav");
	precache_sound ("player/death3.wav");
	precache_sound ("player/death4.wav");
	precache_sound ("player/death5.wav");

// ax sounds	
	precache_sound ("weapons/ax1.wav");			// ax swoosh
	precache_sound ("player/axhit1.wav");		// ax hit meat
	precache_sound ("player/axhit2.wav");		// ax hit world

	precache_sound ("player/h2ojump.wav");		// player jumping into water
	precache_sound ("player/slimbrn2.wav");		// player enter slime
	precache_sound ("player/inh2o.wav");		// player enter water
	precache_sound ("player/inlava.wav");		// player enter lava
	precache_sound ("misc/outwater.wav");		// leaving water sound

	precache_sound ("player/lburn1.wav");		// lava burn
	precache_sound ("player/lburn2.wav");		// lava burn

	precache_sound ("misc/water1.wav");			// swimming
	precache_sound ("misc/water2.wav");			// swimming

	precache_model ("progs/player.mdl");
	precache_model ("progs/eyes.mdl");
	precache_model ("progs/h_player.mdl");
	precache_model ("progs/gib1.mdl");
	precache_model ("progs/gib2.mdl");
	precache_model ("progs/gib3.mdl");

	precache_model ("progs/s_bubble.spr");	// drowning bubbles
//	precache_model ("progs/s_explod.spr");	// sprite explosion
	precache_model ("progs/explod2.spr");	// pOx - new explosion

	precache_model ("progs/v_axe.mdl");
	precache_model ("progs/v_shot.mdl");
	precache_model ("progs/v_nail.mdl");
	precache_model ("progs/v_rock.mdl");
	precache_model ("progs/v_shot2.mdl");
	precache_model ("progs/v_nail2.mdl");
	precache_model ("progs/v_rock2.mdl");

	precache_model ("progs/bolt.mdl");		// for lightning gun
	precache_model ("progs/bolt2.mdl");		// for lightning gun
	precache_model ("progs/bolt3.mdl");		// for boss shock
	precache_model ("progs/lavaball.mdl");	// for testing
	
	precache_model ("progs/missile.mdl");
	precache_model ("progs/grenade.mdl");
	precache_model ("progs/spike.mdl");
	precache_model ("progs/s_spike.mdl");

	precache_model ("progs/backpack.mdl");

	precache_model ("progs/zom_gib.mdl");

	precache_model ("progs/v_light.mdl");
	
	extra_precache();// pOx - precache new stuff

//
// Setup light animation tables. 'a' is total darkness, 'z' is maxbright.
//

	// 0 normal
	lightstyle(0, "m");
	
	// 1 FLICKER (first variety)
	lightstyle(1, "mmnmmommommnonmmonqnmmo");
	
	// 2 SLOW STRONG PULSE
	lightstyle(2, "abcdefghijklmnopqrstuvwxyzyxwvutsrqponmlkjihgfedcba");
	
	// 3 CANDLE (first variety)
	lightstyle(3, "mmmmmaaaaammmmmaaaaaabcdefgabcdefg");
	
	// 4 FAST STROBE
	lightstyle(4, "mamamamamama");
	
	// 5 GENTLE PULSE 1
	lightstyle(5,"jklmnopqrstuvwxyzyxwvutsrqponmlkj");
	
	// 6 FLICKER (second variety)
	lightstyle(6, "nmonqnmomnmomomno");
	
	// 7 CANDLE (second variety)
	lightstyle(7, "mmmaaaabcdefgmmmmaaaammmaamm");
	
	// 8 CANDLE (third variety)
	lightstyle(8, "mmmaaammmaaammmabcdefaaaammmmabcdefmmmaaaa");
	
	// 9 SLOW STROBE (fourth variety)
	lightstyle(9, "aaaaaaaazzzzzzzz");
	
	// 10 FLUORESCENT FLICKER
	lightstyle(10, "mmamammmmammamamaaamammma");

	// 11 SLOW PULSE NOT FADE TO BLACK
	lightstyle(11, "abcdefghijklmnopqrrqponmlkjihgfedcba");
	
	// styles 32-62 are assigned by the light program for switchable lights

	// 63 testing
	lightstyle(63, "a");

// 1998-09-15 Two minute warning by Maddes  start
	if (deathmatch)
	{
//		local entity	timer;	// 2000-07-15 Restructured fraglimit and timelimit by Maddes

		precache_sound ("doors/airdoor2.wav");

// 2000-07-15 Restructured fraglimit and timelimit by Maddes  start
/*
		timer = spawn();
		timer.think = TimeWarning;
		timer.nextthink = time + 0.05;
*/
// 2000-07-15 Restructured fraglimit and timelimit by Maddes  end
	}
// 1998-09-15 Two minute warning by Maddes  end

// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes  start
	if (deathmatch)
	{
		// invulnerability (pentagram)
		precache_model ("progs/invulner.mdl");
		precache_sound ("items/protect.wav");
		precache_sound ("items/protect2.wav");
		precache_sound ("items/protect3.wav");

		precache_sound ("boss1/sight1.wav");
	}

	axeonly = savedgamecfg & SAVEDGAMECFG_DM4_AXEONLY;	// axe only match
// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes  end

	resume = savedgamecfg & SAVEDGAMECFG_RESUME;	// 1999-06-03 Resume function by Jim Steers/Maddes

// 1999-08-08 Quad cheat sound fix by Carlos H. P. da Silva  start
//            also needed for "1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes"
	// super_damage (quad)
	precache_model ("progs/quaddama.mdl");
	precache_sound ("items/damage.wav");
	precache_sound ("items/damage2.wav");
	precache_sound ("items/damage3.wav");
// 1999-08-08 Quad cheat sound fix by Carlos H. P. da Silva  end
};

void() StartFrame =
{
	BotFrame(); // FrikBot
// 2000-01-02 EndFrame function by Maddes  start
	if (!endframe)
	{
		if (framecount)			// skip start of very first frame
		{
			EndFrameCode();
		}
	}
// 2000-01-02 EndFrame function by Maddes  end

	developer = cvar("developer");	// 1999-02-19 Enhanced debugging support by Maddes

	teamplay = cvar("teamplay");
//	skill = cvar("skill");		// 1998-09-17 Skill variable can be changed through gameplay fix by Maddes
	framecount = framecount + 1;
};

/*
==============================================================================

BODY QUE

==============================================================================
*/

entity	bodyqueue_head;

void() bodyqueue =
{	// just here so spawn functions don't complain after the world
	// creates bodyqueues
};

void() InitBodyQueue =
{	
	bodyqueue_head = spawn();
	bodyqueue_head.classname = "bodyqueue";
	bodyqueue_head.owner = spawn();
	bodyqueue_head.owner.classname = "bodyqueue";
	bodyqueue_head.owner.owner = spawn();
	bodyqueue_head.owner.owner.classname = "bodyqueue";
	bodyqueue_head.owner.owner.owner = spawn();
	bodyqueue_head.owner.owner.owner.classname = "bodyqueue";
	bodyqueue_head.owner.owner.owner.owner = bodyqueue_head;
};


// make a body que entry for the given ent so the ent can be
// respawned elsewhere
void(entity ent) CopyToBodyQueue =
{
	bodyqueue_head.skin = ent.skin;			// 1997-12-30 skin support by Maddes  copy the skin on the dead player
	bodyqueue_head.angles = ent.angles;
	bodyqueue_head.model = ent.model;
	bodyqueue_head.modelindex = ent.modelindex;
	bodyqueue_head.frame = ent.frame;
	bodyqueue_head.colormap = ent.colormap;
	bodyqueue_head.movetype = ent.movetype;
	bodyqueue_head.velocity = ent.velocity;
	bodyqueue_head.flags = 0;
	setorigin (bodyqueue_head, ent.origin);
	setsize (bodyqueue_head, ent.mins, ent.maxs);
	bodyqueue_head = bodyqueue_head.owner;
};

// 2000-01-02 EndFrame function by Maddes  start
void() EndFrame =
{
	endframe = 1;

	EndFrameCode();
};

// 2001-08-01 No silmultaneous shots fix by Maddes  start
void(entity damage_collector) ProcessDamageCollector;
void(entity damage_collector) RemoveDamageCollector;
// 2001-08-01 No silmultaneous shots fix by Maddes  end

void() EndFrameCode =
{
// 2001-08-01 No silmultaneous shots fix by Maddes  start
	local	entity	damage_collector;
	local	entity	last_damage_collector;

	// searching for existing damage collector entities
	damage_collector = find (world, classname, "damage_collector");
	while ( damage_collector != world )
	{
		ProcessDamageCollector(damage_collector);

		last_damage_collector = damage_collector;
		damage_collector = find (damage_collector, classname, "damage_collector");

		RemoveDamageCollector(last_damage_collector);
	}
// 2001-08-01 No silmultaneous shots fix by Maddes  end

// 2000-07-15 Restructured fraglimit and timelimit by Maddes  start
	if (deathmatch)
	{
		CheckRules();
	}
// 2000-07-15 Restructured fraglimit and timelimit by Maddes  end

#ifdef EXAMPLE_ENDFRAME
	if (framecount < 11)	// the first ten frames are enough to demonstrate
	{
		dprint("ENDFRAME: for frame #");
		dprint(ftos(framecount));
		if (endframe)
		{
			dprint(" (supported by engine)\n");
		}
		else
		{
			dprint(" (emulated by QuakeC)\n");
		}
	}
#endif
};
// 2000-01-02 EndFrame function by Maddes  end

// 2000-01-09 QCExec by FrikaC/Maddes  start
#ifdef DEBUG_QCEXEC
void() eshow =
{
	eprint(self);
	if (other) eprint(other);
};

void() stringtest =
{
	local string	dummy_string;
	local float		dummy_float;

	dummy_string = cvar_string("hostname");
	dummy_string = strzone(dummy_string);
	dummy_float = cvar("pr_zone_min_strings");

	dprint(ftos(dummy_float));
	dprint(" / ");
	dprint(dummy_string);
	dprint("\n");

	dummy_string = strunzone(dummy_string);
};
#endif
// 2000-01-09 QCExec by FrikaC/Maddes  end

// 2001-11-18 Random number function  start
/*
General solution to always get a valid random number of a given range and stepsize.

All possible values have the same chance of being calculated.
(Ok, the last value has a slighlty higher chance :)

It works for negative and positive parameters, only the stepsize should fit the range:
  end > start : positive stepsize
  start > end : negative stepsize

Note that the typical "result = START + floor( random() * ( COUNT - 0.01 ) )"
only works for positive integer ranges with stepsize +1.
*/
float(float start, float end, float stepsize) rnd_number =
{
	local float	rcnt;
	local float	rnd;
	local float result;

	// calculate the number of possible different values
	rcnt = floor( fabs( ( end - start ) / stepsize ) ) + 1;

	// calculate the random part of the result value
	rnd = floor( random() * rcnt );
	if ( rnd == rcnt )
	{
		rnd = rnd - 1;
	}

	// calculate the result value
	result = start + ( rnd * stepsize );

	return result;
};
// 2001-11-18 Random number function  end


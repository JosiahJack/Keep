/*
This source code has been reconstructed from PROGS.DAT and may not be
identical to the original source code.

Copyright (C) 1997 Epochalypse. Malice is a trade name of Quantum Axcess.
*/

float SEARCH    = 2;
float CAMPER    = 4;
float WITHDRAW  = 8;
float OTFATTACK = 16;
float ATTACK    = 32;
float JUMP      = 64;

float modelindex_eyes;
float modelindex_player;
float cbotnum;
.float goal_status;
.float botmode;
.entity origin_save;
.string oldgoalname;
.vector old_posn;
.float watchdog_time;
.float prioritise_time;
.float other_item_time;
.float camp_time;
.float blasttime;
.float sighted_time;
.float ideal_pitch;
.float pi1;
.float pi2;
.float pi3;
.float pi4;
.float pi5;
.float pi6;
.float pi7;
.float pi8;
.float pi9;

void (entity me) CBot_Create;

void () CN_Client_Init_Think =
{
};

string () choosename =
{
	if (cbotnum == 0)
		return ("One");
	else if (cbotnum == 1)
		return ("Two");
	else if (cbotnum == 2)
		return ("Three");
	else
		return ("");
};


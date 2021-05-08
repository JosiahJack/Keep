/*
This source code has been reconstructed from PROGS.DAT and may not be
identical to the original source code.

Copyright (C) 1997 Epochalypse. Malice is a trade name of Quantum Axcess.
*/

void (vector tdest,float tspeed,void() func) SUB_CalcMove;
void (entity ent,vector tdest,float tspeed,void() func) SUB_CalcMoveEnt;
void (vector destangle,float tspeed,void() func) SUB_CalcAngleMove;
void () SUB_CalcMoveDone;
void () SUB_CalcAngleMoveDone;
void () SUB_Null;
void () SUB_UseTargets;
void () SUB_Remove;
void (entity targ,entity inflictor,entity attacker,float damage) T_Damage;
float (entity e,float healamount,float ignore) T_Heal;
float (entity targ,entity inflictor) CanDamage;

void () proof =
{
	sprint (self, "-----MALICE  by team Epochalypse 1997-------");
	sprint (self, " ");
	sprint (self, " ");
	sprint (self, "Tan Sian Yue      models/animation,levels...");
	sprint (self, "Dan Janis         levels....................");
	sprint (self, "John Anderson     quakeC,sfx,music..........");
	sprint (self, "Aaron Webster     level textures,models.....");
	sprint (self, "Lucas Pope        skin art,models,cutscenes.");
	sprint (self, " ");
	sprint (self, "--------------------------------------------");
};


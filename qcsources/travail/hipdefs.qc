/* Level pack definitons
   Copyright (c)1996 Hipnotic Interactive, Inc.
   All rights reserved.
   Do not distribute.
*/

//added update stat message
float SVC_UPDATESTAT = 3;
//added total monster message
float STAT_TOTALMONSTERS = 12;

//
// Hipnotic entries
//
// spawn variables
.void()     spawnfunction;
.string     spawnclassname;
.float      spawnsolidtype;
.string     spawnmodel;
.void()     spawnthink;
.entity     spawnmaster;
.vector     spawnmins;
.vector     spawnmaxs;
.float      spawnsilent;
.float      spawnmulti;

//
// Hipnotic's Prototypes
//
void (entity srcent, entity destent) SUB_CopyEntity;

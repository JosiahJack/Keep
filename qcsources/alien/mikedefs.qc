/*
====================================
MIKE DEFS. defs for add-ons
====================================
*/
.float poisoned;							//attached to an entity if it has been posioned by monster_alien
entity scent;							//The "track" entities placed for monster_alien to follow
vector (vector org, float misspeed) MissileTarget;
float tr_num;							//Current number of the "track" entities that have been spawned
float avoid;
.float retreat;
.float onfire;							//Affected by the flame thrower. Set to 1 if the entity is onfire
.string mtdest;							//Teleport dest for the moving teleport entity
.string target1;							//Target value for the moving teleport
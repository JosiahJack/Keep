 // Global Variables and Constants

float FALSE;
float TRUE = 1;
float FL_FLY = 1;
float FL_SWIM = 2;
float FL_CLIENT = 8;
float FL_INWATER = 16;
float FL_MONSTER = 32;
float FL_GODMODE = 64;
float FL_NOTARGET = 128;
float FL_ITEM = 256;
float FL_ONGROUND = 512;
float FL_PARTIALGROUND = 1024;
float FL_WATERJUMP = 2048;
float FL_JUMPRELEASED = 4096;
float MOVETYPE_NONE;
float MOVETYPE_WALK = 3;
float MOVETYPE_STEP = 4;
float MOVETYPE_FLY = 5;
float MOVETYPE_TOSS = 6;
float MOVETYPE_PUSH = 7;
float MOVETYPE_NOCLIP = 8;
float MOVETYPE_FLYMISSILE = 9;
float MOVETYPE_BOUNCE = 10;
float MOVETYPE_BOUNCEMISSILE = 11;
float SOLID_NOT;
float SOLID_TRIGGER = 1;
float SOLID_BBOX = 2;
float SOLID_SLIDEBOX = 3;
float SOLID_BSP = 4;
float RANGE_MELEE;
float RANGE_NEAR = 1;
float RANGE_MID = 2;
float RANGE_FAR = 3;
float DEAD_NO;
float DEAD_DYING = 1;
float DEAD_DEAD = 2;
float DEAD_RESPAWNABLE = 3;
float DAMAGE_NO;
float DAMAGE_YES = 1;
float DAMAGE_AIM = 2;
float IT_AXE = 4096;
float IT_SHOTGUN = 1;
float IT_SUPER_SHOTGUN = 2;
float IT_NAILGUN = 4;
float IT_SUPER_NAILGUN = 8;
float IT_GRENADE_LAUNCHER = 16;
float IT_ROCKET_LAUNCHER = 32;
float IT_LIGHTNING = 64;
float IT_EXTRA_WEAPON = 128;
float IT_SHELLS = 256;
float IT_NAILS = 512;
float IT_ROCKETS = 1024;
float IT_CELLS = 2048;
float IT_ARMOR1 = 8192;
float IT_ARMOR2 = 16384;
float IT_ARMOR3 = 32768;
float IT_SUPERHEALTH = 65536;
float IT_KEY1 = 131072;
float IT_KEY2 = 262144;
float IT_INVISIBILITY = 524288;
float IT_INVULNERABILITY = 1048576;
float IT_SUIT = 2097152;
float IT_QUAD = 4194304;
float CONTENT_EMPTY = -1;
float CONTENT_SOLID = -2;
float CONTENT_WATER = -3;
float CONTENT_SLIME = -4;
float CONTENT_LAVA = -5;
float CONTENT_SKY = -6;
float STATE_TOP;
float STATE_BOTTOM = 1;
float STATE_UP = 2;
float STATE_DOWN = 3;
vector VEC_ORIGIN;  // system
vector VEC_HULL_MIN = '-16 -16 -24';  // system
vector VEC_HULL_MAX = '16 16 32';  // system
vector VEC_HULL2_MIN = '-32 -32 -24';  // system
vector VEC_HULL2_MAX = '32 32 64';  // system
float SVC_TEMPENTITY = 23;
float SVC_KILLEDMONSTER = 27;
float SVC_FOUNDSECRET = 28;
float SVC_INTERMISSION = 30;
float SVC_FINALE = 31;
float SVC_CDTRACK = 32;
float SVC_SELLSCREEN = 33;
float TE_SPIKE;
float TE_SUPERSPIKE = 1;
float TE_GUNSHOT = 2;
float TE_EXPLOSION = 3;
float TE_TAREXPLOSION = 4;
float TE_LIGHTNING1 = 5;
float TE_LIGHTNING2 = 6;
float TE_WIZSPIKE = 7;
float TE_KNIGHTSPIKE = 8;
float TE_LIGHTNING3 = 9;
float TE_LAVASPLASH = 10;
float TE_TELEPORT = 11;
float CHAN_AUTO;
float CHAN_WEAPON = 1;
float CHAN_VOICE = 2;
float CHAN_ITEM = 3;
float CHAN_BODY = 4;
float ATTN_NONE;
float ATTN_NORM = 1;
float ATTN_IDLE = 2;
float ATTN_STATIC = 3;
float UPDATE_GENERAL;
float UPDATE_STATIC = 1;
float UPDATE_BINARY = 2;
float UPDATE_TEMP = 3;
float EF_BRIGHTFIELD = 1;
float EF_MUZZLEFLASH = 2;
float EF_BRIGHTLIGHT = 4;
float EF_DIMLIGHT = 8;
float MSG_BROADCAST;
float MSG_ONE = 1;
float MSG_ALL = 2;
float MSG_INIT = 3;
float movedist;  // system
float gameover;  // system
string string_null;  // system
float empty_float;  // system
entity newmis;  // system
entity activator;  // system
entity damage_attacker;  // system
float framecount;  // system
float skill;  // system
float AS_STRAIGHT = 1;
float AS_SLIDING = 2;
float AS_MELEE = 3;
float AS_MISSILE = 4;
float SVC_UPDATESTAT = 3;
float STAT_TOTALMONSTERS = 12;
float enemy_vis;  // system
float enemy_infront;  // system
float enemy_range;  // system
float enemy_yaw;  // system
float current_yaw;  // system
entity sight_entity;  // system
float sight_entity_time;  // system
float H_ROTTEN = 1;
float H_MEGA = 2;
float WEAPON_BIG2 = 1;
float WEAPON_SHOTGUN = 1;
float WEAPON_ROCKET = 2;
float WEAPON_SPIKES = 4;
float WEAPON_BIG = 8;
entity multi_ent;  // system
float multi_damage;  // system
entity lastspawn;  // system
entity bodyque_head;  // system
float modelindex_eyes;  // system
float modelindex_player;  // system
float intermission_running;  // system
float intermission_exittime;  // system
string nextmap;  // system
float DOOR_START_OPEN = 1;
float DOOR_DONT_LINK = 4;
float DOOR_GOLD_KEY = 8;
float DOOR_SILVER_KEY = 16;
float DOOR_TOGGLE = 32;
float SECRET_OPEN_ONCE = 1;
float SECRET_1ST_LEFT = 2;
float SECRET_1ST_DOWN = 4;
float SECRET_NO_SHOOT = 8;
float SECRET_YES_SHOOT = 16;
entity stemp;  // system
entity otemp;  // system
entity s;  // system
entity old;  // system
float SPAWNFLAG_NOMESSAGE = 1;
float SPAWNFLAG_NOTOUCH = 1;
float PLAYER_ONLY = 1;
float SILENT = 2;
float PUSH_ONCE = 1;
float PLAT_LOW_TRIGGER = 1;
float START_OFF = 1;
float SPAWNFLAG_SUPERSPIKE = 1;
float SPAWNFLAG_LASER = 2;
float SPAWN_CRUCIFIED = 1;
entity le1;  // system
entity le2;  // system
float lightning_end;  // system
float hknight_type;  // system
entity shub;  // system
float COUNTER_TOGGLE = 1;
float COUNTER_LOOP = 2;
float COUNTER_STEP = 4;
float COUNTER_RESET = 8;
float COUNTER_RANDOM = 16;
float COUNTER_FINISHCOUNT = 32;
float COUNTER_START_ON = 64;
float MULTI_USE = 1;
float INVISIBLE = 2;
float USE_PARTICLES = 1;
float USE_COUNT = 1;

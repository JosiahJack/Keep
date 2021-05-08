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
float MOVETYPE_ANGLENOCLIP = 1;
float MOVETYPE_ANGLECLIP = 2;
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
float RANGE_CLOSE;
float RANGE_MELEE = 1;
float RANGE_NEAR = 2;
float RANGE_MID = 3;
float RANGE_FAR = 4;
float DEAD_NO;
float DEAD_DYING = 1;
float DEAD_DEAD = 2;
float DEAD_RESPAWNABLE = 3;
float DAMAGE_NO;
float DAMAGE_YES = 1;
float DAMAGE_AIM = 2;
float CONTENT_EMPTY = -1;
float CONTENT_SOLID = -2;
float CONTENT_WATER = -3;
float CONTENT_SLIME = -4;
float CONTENT_LAVA = -5;
float CONTENT_SKY = -6;
float STATE_RAISED;
float STATE_LOWERED = 1;
float STATE_UP = 2;
float STATE_DOWN = 3;
vector VEC_ORIGIN;
vector VEC_HULL_MIN = '-16 -16 -24';
vector VEC_HULL_MAX = '16 16 32';
vector VEC_HULL2_MIN = '-32 -32 -24';
vector VEC_HULL2_MAX = '32 32 64';
float SVC_BAD;
float SVC_NOP = 1;
float SVC_DISCONNECT = 2;
float SVC_UPDATESTAT = 3;
float SVC_VERSION = 4;
float SVC_SETVIEW = 5;
float SVC_SOUND = 6;
float SVC_TIME = 7;
float SVC_PRINT = 8;
float SVC_STUFFTEXT = 9;
float SVC_SETANGLE = 10;
float SVC_SERVERINFO = 11;
float SVC_LIGHTSTYLE = 12;
float SVC_UPDATENAME = 13;
float SVC_UPDATEFRAGS = 14;
float SVC_CLIENTDATA = 15;
float SVC_STOPSOUND = 16;
float SVC_UPDATECOLORS = 17;
float SVC_PARTICLE = 18;
float SVC_DAMAGE = 19;
float SVC_SPAWNSTATIC = 20;
float SVC_SPAWNBINARY = 21;
float SVC_SPAWNBASELINE = 22;
float SVC_TEMPENTITY = 23;
float SVC_SETPAUSE = 24;
float SVC_SIGNONNUM = 25;
float SVC_CENTERPRINT = 26;
float SVC_KILLEDMONSTER = 27;
float SVC_FOUNDSECRET = 28;
float SVC_SPAWNSTATICSOUND = 29;
float SVC_INTERMISSION = 30;
float SVC_FINALE = 31;
float SVC_CDTRACK = 32;
float SVC_SELLSCREEN = 33;
float SVC_CUTSCENE = 34;
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
float AS_STRAIGHT = 1;
float AS_SLIDING = 2;
float AS_MELEE = 3;
float AS_MISSILE = 4;
entity activator;  // system
string string_null;  // system
float EF_NODEPTHTEST = 8192;
float EF_ADDITIVE = 32;
float EF_NOSHADOW = 4096;
float KEY_UP = 1;
float KEY_DOWN = 2;
float KEY_LEFT = 4;
float KEY_RIGHT = 8;
entity damage_attacker;  // system
float frameskip_delay;  // system
entity frameskip_ent;  // system
float combo;  // system
float SPELL_FIREBALL;
float SPELL_LIGHTNING = 1;
float SPELL_ICE = 2;
float SPELL_BEAM = 4;
float SPELL_TWISTER = 8;
float ext_snd_oggvorbis;  // system
float darkplaces;  // system
float STATE_TOP;
float STATE_BOTTOM = 1;
float players;  // system
float menu_difficulty;  // system
float menu_lives;  // system
float menu_music;  // system
float menu_seizurefx;  // system
float menu_volume;  // system
float menu_ccounter;  // system
float menu_camera;  // system
float freeze_finished;  // system
float lightning_count;  // system
float sprite_count;  // system
float blood_count;  // system
float FL_BOSS = 8192;
float relics;  // system
float IT_RELIC1 = 1;
float IT_RELIC2 = 2;
float IT_RELIC3 = 4;
float IT_RELIC4 = 8;
float IT_RELIC5 = 16;
float framecount;  // system
float developer;  // system
float difficulty;  // system
float title1_finished;  // system
float runaway;  // system
float framerate;  // system
float SPAWNFLAG_NOMESSAGE = 1;
float SPAWNFLAG_NOTOUCH = 1;
float PUSH_ONCE = 1;
string nextmap;  // system
float movedist;  // system
float PLAT_LOW_TRIGGER = 1;
float lightning_strikes;  // system

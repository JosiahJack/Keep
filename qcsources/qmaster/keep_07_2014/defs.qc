entity self;
entity other;
entity world;
float time /* = 0.000 */;
float frametime /* = 0.000 */;
float force_retouch /* = 0.000 */;
string mapname /* = "" */;
float deathmatch /* = 0.000 */;
float coop /* = 0.000 */;
float teamplay /* = 0.000 */;
float serverflags /* = 0.000 */;
float total_secrets /* = 0.000 */;
float total_monsters /* = 0.000 */;
float found_secrets /* = 0.000 */;
float killed_monsters /* = 0.000 */;
float parm1 /* = 0.000 */;
float parm2 /* = 0.000 */;
float parm3 /* = 0.000 */;
float parm4 /* = 0.000 */;
float parm5 /* = 0.000 */;
float parm6 /* = 0.000 */;
float parm7 /* = 0.000 */;
float parm8 /* = 0.000 */;
float parm9 /* = 0.000 */;
float parm10 /* = 0.000 */;
float parm11 /* = 0.000 */;
float parm12 /* = 0.000 */;
float parm13 /* = 0.000 */;
float parm14 /* = 0.000 */;
float parm15 /* = 0.000 */;
float parm16 /* = 0.000 */;
vector v_forward /* = '0.000 0.000 0.000' */;
vector v_up /* = '0.000 0.000 0.000' */;
vector v_right /* = '0.000 0.000 0.000' */;
float trace_allsolid /* = 0.000 */;
float trace_startsolid /* = 0.000 */;
float trace_fraction /* = 0.000 */;
vector trace_endpos /* = '0.000 0.000 0.000' */;
vector trace_plane_normal /* = '0.000 0.000 0.000' */;
float trace_plane_dist /* = 0.000 */;
entity trace_ent;
float trace_inopen /* = 0.000 */;
float trace_inwater /* = 0.000 */;
entity msg_entity;
void () main;
void () StartFrame;
void () PlayerPreThink;
void () PlayerPostThink;
void () ClientKill;
void () ClientConnect;
void () PutClientInServer;
void () ClientDisconnect;
void () SetNewParms;
void () SetChangeParms;
void end_sys_globals;
.string target2;
.string target3;
.string target4;
.string target5;
.string target6;
.string target7;
.string target8;
.string target9;
.string target10;
.float pts;
.float modelindex;
.vector absmin;
.vector absmax;
.float ltime;
.float movetype;
.float solid;
.vector origin;
.vector oldorigin;
.vector velocity;
.vector angles;
.vector avelocity;
.vector punchangle;
.string classname;
.string model;
.float frame;
.float skin;
.float effects;
.vector mins;
.vector maxs;
.vector size;
.void() touch;
.void() use;
.void() think;
.void() blocked;
.float nextthink;
.entity groundentity;
.float health;
.float frags;
.float weapon;
.string weaponmodel;
.float weaponframe;
.float currentammo;
.float ammo_shells;
.float ammo_nails;
.float ammo_rockets;
.float ammo_cells;
.float items;
.float takedamage;
.entity chain;
.float deadflag;
.vector view_ofs;
.float button0;
.float button1;
.float button2;
.float impulse;
.float fixangle;
.vector v_angle;
.float idealpitch;
.string netname;
.entity enemy;
.float flags;
.float colormap;
.float team;
.float max_health;
.float teleport_time;
.float armortype;
.float armorvalue;
.float waterlevel;
.float watertype;
.float ideal_yaw;
.float yaw_speed;
.entity aiment;
.entity goalentity;
.float spawnflags;
.string target;
.string targetname;
.float dmg_take;
.float dmg_save;
.entity dmg_inflictor;
.entity owner;
.vector movedir;
.string message;
.float sounds;
.string noise;
.string noise1;
.string noise2;
.string noise3;
void end_sys_fields;

float bodyfade;
float gibfade;
.float items2;
.float ammo_shells1;
.float ammo_nails1;
.float ammo_rockets1;
.float ammo_cells1;
.float ammo_lava_nails;
.float ammo_multi_rockets;
.float ammo_plasma;
.float gravity;

float FALSE    = 0.000;
float TRUE    = 1.000;
float COOP_ONLY =   1.000;
float COOP_NOT =    2.000;
float FL_FLY    = 1.000;
float FL_SWIM    = 2.000;
float FL_CLIENT    = 8.000;
float FL_INWATER    = 16.000;
float FL_MONSTER    = 32.000;
float FL_GODMODE    = 64.000;
float FL_NOTARGET    = 128.000;
float FL_ITEM    = 256.000;
float FL_ONGROUND    = 512.000;
float FL_PARTIALGROUND    = 1024.000;
float FL_WATERJUMP    = 2048.000;
float FL_JUMPRELEASED    = 4096.000;
float FL_NOSELECT	= 8192.000;
float MOVETYPE_NONE    = 0.000;
float MOVETYPE_WALK    = 3.000;
float MOVETYPE_STEP    = 4.000;
float MOVETYPE_FLY    = 5.000;
float MOVETYPE_TOSS    = 6.000;
float MOVETYPE_PUSH    = 7.000;
float MOVETYPE_NOCLIP    = 8.000;
float MOVETYPE_FLYMISSILE    = 9.000;
float MOVETYPE_BOUNCE    = 10.000;
float MOVETYPE_BOUNCEMISSILE    = 11.000;
float SOLID_NOT    = 0.000;
float SOLID_TRIGGER    = 1.000;
float SOLID_BBOX    = 2.000;
float SOLID_SLIDEBOX    = 3.000;
float SOLID_BSP    = 4.000;
float RANGE_MELEE    = 0.000;
float RANGE_NEAR    = 1.000;
float RANGE_MID    = 2.000;
float RANGE_FAR    = 3.000;
float DEAD_NO    = 0.000;
float DEAD_DYING    = 1.000;
float DEAD_DEAD    = 2.000;
float DEAD_RESPAWNABLE    = 3.000;
float DAMAGE_NO    = 0.000;
float DAMAGE_YES    = 1.000;
float DAMAGE_AIM    = 2.000;
//=======================================SELF.ITEMS1======================================================
float IT_SHOTGUN    		= 1.000;		//Correct for standard HUD & HIP & DOE			W
float IT_SUPER_SHOTGUN   	= 2.000;		//Correct for standard HUD & HIP & DOE			W
float IT_NAILGUN    		= 4.000;		//Correct for standard HUD & HIP & DOE			W
float IT_SUPER_NAILGUN    	= 8.000;		//Correct for standard HUD & HIP & DOE			W
float IT_GRENADE_LAUNCHER    	= 16.000;		//Correct for standard HUD & HIP & DOE			W
float IT_ROCKET_LAUNCHER    	= 32.000;		//Correct for standard HUD & HIP & DOE			W
float IT_LIGHTNING    		= 64.000;		//Correct for standard HUD & HIP & DOE			W
float IT_SHELLS    		= 128.000;		//Correct for DOE HUD					I
float IT_NAILS    		= 256.000;		//Correct for DOE HUD					I
float IT_ROCKETS    		= 512.000;		//Correct for DOE HUD					I
float IT_CELLS    		= 1024.000;		//Correct for DOE HUD					I
float IT_AXE    		= 2048.000;		//Correct for DOE HUD					W
float IT_LAVA_NAILGUN    	= 4096.000;		//Correct for DOE HUD (okay for standard and HIP)	W
float IT_LAVA_SUPER_NAILGUN    	= 8192.000;		//Correct for DOE HUD (okay for standard and HIP)	W
float IT_MULTI_GRENADE    	= 16384.000;		//Correct for DOE HUD (okay for standard and HIP)	W
float IT_MULTI_ROCKET    	= 32768.000;		//Correct for DOE HUD (okay for standard and HIP)	W
float IT_PLASMA_GUN   	 	= 65536.000;		//Correct for DOE HUD					W
float IT_KEY1    		= 131072.000;		//Correct for standard HUD & HIP & DOE			I
float IT_KEY2    		= 262144.000;		//Correct for standard HUD & HIP & DOE			I
float IT_INVISIBILITY    	= 524288.000;		//Correct for standard HUD & HIP & DOE			I
float IT_INVULNERABILITY    	= 1048576.000;		//Correct for standard HUD & HIP & DOE			I
float IT_SUIT    		= 2097152.000;		//Correct for standard HUD & HIP & DOE			I
float IT_QUAD    		= 4194304.000;		//Correct for standard HUD & HIP & DOE			I
float IT_GRAPPLE    		= 8388608.000;		//Correct for DOE HUD					W
//=======================================SELF.ITEMS2======================================================
float IT2_ARMOR1    		= 1.000;		//Correct for DOE HUD					I
float IT2_ARMOR2    		= 2.000;		//Correct for DOE HUD					I
float IT2_ARMOR3    		= 4.000;		//Correct for DOE HUD					I
float IT2_LAVA_NAILS    	= 8.000;		//Correct for DOE HUD					I
float IT2_PLASMA_AMMO   	= 16.000;		//Correct for DOE HUD					I
float IT2_MULTI_ROCKETS    	= 32.000;		//Correct for DOE HUD					I
float IT2_SHIELD    		= 64.000;		//Correct for DOE HUD					I
float IT2_ANTIGRAV    		= 128.000;		//Correct for DOE HUD					I(available for a new weapon)
float IT2_SUPERHEALTH    	= 256.000;		//Correct for DOE HUD					I(available for a new weapon)
float IT2_EARTHQUAKE    	= 512.000;		//Correct for DOE HUD					I(available for a new weapon)
float IT2_V_SPHERE    		= 1024.000;		//Correct for DOE HUD					I(available for a new weapon)
float IT2_KEY_SKELETON    	= 2048.000;		//Keep specific						I
float IT2_KEY3    		= 4096.000;		//Keep specific						I
float HIP_IT2_WETSUIT    	= 8192.000;		//Keep specific (modified from HIP)			I
float HIP_IT2_EMPATHY_SHIELDS   = 16384.000;		//Keep specific (modified from HIP)			I
float HIP_IT2_HORN_OF_CONJURING = 32768.000;		//Keep specific (modified from HIP)			I
			   	//= 65536.000;		EMPTY SLOT (skipped...same as IT_PLASMA_GUN)		I
float IT2_PROXIMITY_GUN    	= 131072.000;		//Keep specific.Unique number for self.weapon calls 	W
float IT2_MJOLNIR 		= 262144.000;		//Keep specific	""					W
float IT2_LASER_CANNON    	= 524288.000;		//Keep specific	""					W
				//= 1048576.000;	EMPTY SLOT						(available for a new weapon)
				//= 2097152.000;	EMPTY SLOT						(available for a new weapon)
				//= 4194304.000;	EMPTY SLOT						(available for a new weapon)
				//= 8388608.000; 	EMPTY SLOT
//========================================================================================================
float CONTENT_EMPTY    = -1.000;
float CONTENT_SOLID    = -2.000;
float CONTENT_WATER    = -3.000;
float CONTENT_SLIME    = -4.000;
float CONTENT_LAVA    = -5.000;
float CONTENT_SKY    = -6.000;
float CONTENT_SLICK    = -7.000;
float STATE_TOP    = 0.000;
float STATE_BOTTOM    = 1.000;
float STATE_UP    = 2.000;
float STATE_DOWN    = 3.000;
vector VEC_ORIGIN    = '0.000 0.000 0.000';
vector VEC_HULL_MIN    = '-16.000 -16.000 -24.000';
vector VEC_HULL_MAX    = '16.000 16.000 32.000';
vector VEC_HULL2_MIN    = '-32.000 -32.000 -24.000';
vector VEC_HULL2_MAX    = '32.000 32.000 64.000';
float SVC_UPDATESTAT    = 3.000;
float SVC_TEMPENTITY    = 23.000;
float SVC_KILLEDMONSTER    = 27.000;
float SVC_FOUNDSECRET    = 28.000;
float SVC_INTERMISSION    = 30.000;
float SVC_FINALE    = 31.000;
float SVC_CDTRACK    = 32.000;
float SVC_SELLSCREEN    = 33.000;
float SVC_CUTSCENE    = 34.000;
float STAT_TOTALSECRETS    = 11.000;
float STAT_TOTALMONSTERS    = 12.000;
float TE_SPIKE    = 0.000;
float TE_SUPERSPIKE    = 1.000;
float TE_GUNSHOT    = 2.000;
float TE_EXPLOSION    = 3.000;
float TE_TAREXPLOSION    = 4.000;
float TE_LIGHTNING1    = 5.000;
float TE_LIGHTNING2    = 6.000;
float TE_WIZSPIKE    = 7.000;
float TE_KNIGHTSPIKE    = 8.000;
float TE_LIGHTNING3    = 9.000;
float TE_LAVASPLASH    = 10.000;
float TE_TELEPORT    = 11.000;
float TE_EXPLOSION2    = 12.000;
float TE_BEAM    = 13.000;
float CHAN_AUTO    = 0.000;
float CHAN_WEAPON    = 1.000;
float CHAN_VOICE    = 2.000;
float CHAN_ITEM    = 3.000;
float CHAN_BODY    = 4.000;
float ATTN_NONE    = 0.000;
float ATTN_NORM    = 1.000;
float ATTN_IDLE    = 2.000;
float ATTN_STATIC    = 3.000;
float UPDATE_GENERAL    = 0.000;
float UPDATE_STATIC    = 1.000;
float UPDATE_BINARY    = 2.000;
float UPDATE_TEMP    = 3.000;
float EF_BRIGHTFIELD    = 1.000;
float EF_MUZZLEFLASH    = 2.000;
float EF_BRIGHTLIGHT    = 4.000;
float EF_DIMLIGHT    = 8.000;
float MSG_BROADCAST    = 0.000;
float MSG_ONE    = 1.000;
float MSG_ALL    = 2.000;
float MSG_INIT    = 3.000;

.string classmonster;
.float disabled;
float elv_button_dir;

float movedist /* = 0.000 */;
float gameover /* = 0.000 */;
string string_null /* = "" */;
entity newmis;
entity activator;
entity damage_attacker;
float framecount /* = 0.000 */;
float skill /* = 0.000 */;

float earthquake_active /* = 0.000 */;
float earthquake_intensity /* = 0.000 */;
float cutscene_running /* = 0.000 */;
entity tag_token_owner;

.string wad;
.string map;
.float worldtype;
.string killtarget;
.float light_lev;
.float style;
.void() th_stand;
.void() th_walk;
.void() th_run;
.void() th_missile;
.void() th_melee;
.void(entity attacker, float damage) th_pain;
.void() th_die;
.entity oldenemy;
.float speed;
.float lefty;
.float search_time;
.float attack_state;
float AS_STRAIGHT    = 1.000;
float AS_SLIDING    = 2.000;
float AS_MELEE    = 3.000;
float AS_MISSILE    = 4.000;
.float walkframe;
.float attack_finished;
.float pain_finished;
.float invincible_finished;
.float invisible_finished;
.float super_damage_finished;
.float radsuit_finished;
.float invincible_time;
.float invincible_sound;
.float invisible_time;
.float invisible_sound;
.float super_time;
.float super_sound;
.float rad_time;
.float fly_sound;

// Rogue stuff
.float shield_finished;
.float antigrav_finished;
.float shield_time;
.float antigrav_time;
.entity shield_entity;

.float axhitme;
.float show_hostile;
.float jump_flag;
.float swim_flag;
.float air_finished;
.float bubble_count;
.string deathtype;
.string mdl;
.vector mangle;
.float t_length;
.float t_width;
.vector dest;
.vector dest1;
.vector dest2;
.float wait;
.float delay;
.entity trigger_field;
.string noise4;
.float pausetime;
.entity movetarget;
.float aflag;
.float dmg;
.float cnt;
.void() think1;
.vector finaldest;
.vector finalangle;
.float count;
.float lip;
.float state;
.vector pos1;
.vector pos2;
.float height;
.float waitmin;
.float waitmax;
.float distance;
.float volume;

// Rogue stuff again
.float elevatorLastUse;
.float elevatorOnFloor;
.float elevatorToFloor;
.vector elevatorDestination;
.float plat2Called;
.float plat2LastMove;
.float plat2GoTime;
.float plat2GoTo;
.float orbitPosition;
.float playerInRoom;
.float playerInTransit;
.float dragonInRoom;
.float dragonInTransit;
.float dragonAttacking;
.float dragonPainSequence;
.vector dragonLastVelocity;
.float AGping;
.float childrenSpawned;
.float ltrailLastUsed;
.float shield_death_time;
.float shieldSoundTime;
.float dragonDeathState;
.float tag_frags;
.float tag_message_time;

// Quoth stuff
float condebug;
float AS_BLINDFIRE = 5;
float AS_LOITER = 6;
float IT_PLASMA = 8388608;
float TRIGGER_SPAWNSILENT = 32;
float TRIGGER_SPAWN = 64;
float TRIGGER_AWAKE = 128;
float CORPSE_TIME_GLOBAL = 60;
float CHAN_IDLE = 5;
float REVERSE = 1;
float LIGHTNING_BOOM = 2;
.float items_stasis;
.float badhealth;
.float coiled;
.float drole_searchtime;
.float spawndelay;
.vector oldenemyorigin;
.float startonground;
.float mlah;
.float corpse_time;
.float carry_time;
.float gug_slapped;
.void() th_novis;
.float trinity_finished;
.float trinity_time;
.float trinity_sound;
.float trinity_start;
.float cross_finished;
.float cross_time;
.float cross_sound;
.float cross_start;
.float shield;
.float dangle;
.float marked;
.float vltime;
.float client_gaunt_swoop_time;
.vector origin2;
.vector origin3;
.float idlesound_time;
.float swoop;
.float perch;
.entity carry;
.float carry_time;
.float carrymode;
.float oldhealth;
.float multiplier;
.float vmultiplier;
.float vsightmultiplier;
.float rememberweapon;
.string pathtarget;

// Kinn stuff (from the Marcher Fortress)
.void() sight_sound;
.string group;
.string target1;
.string target2;
.string target3;
.string target4;
.string target5;
.float delay1;
.float delay2;
.float delay3;
.float delay4;
.float delay5;
.float count1;
.float count2;
.float count3;
.float count4;
.float count5;
.vector dest3;
.vector dest4;
.vector dest5;
.vector angles1;
.vector angles2;
entity monster_list;
float MONSTER_KNIGHT			= 1;
float MONSTER_OGRE			= 2;
float MONSTER_FLAK_OGRE			= 4;
float MONSTER_HELL_KNIGHT		= 8;
float MONSTER_HELL_KNIGHT_WRAITH 	= 16;
float MONSTER_ZOMBIE			= 32;
float MONSTER_SCRAG			= 64;
float MONSTER_IMP			= 128;
float MONSTER_FIEND			= 256;
float MONSTER_VORE			= 512;
float MONSTER_SHAMBLER			= 1024;
float MONSTER_BLOB			= 2048;
float MONSTER_BLACK_SHUFFLER		= 4096;
float MONSTER_DOG			= 8192;
float MONSTER_GRUNT			= 16384;
float MONSTER_ENFORCER			= 32768;
float MONSTER_SUPER_GRUNT 		= 65536;
//					= 131072;
float MONSTER_WHITE_SHUFFLER		= 262144;
float MONSTER_SPIDER			= 524288;
float MONSTER_FISH			= 1048576;
//					= 2097152;
//					= 4194304;
//					= 8388608;
float MF_COMMANDER	= 1;	// beefier version
float MF_CHAMPION	= 2;	// really beefy version
float MF_GUIDED		= 4;	//being guided by a trigger_monsterguide
float MF_FADING		= 8;	//currently dead and in the process of fading into the ground - don't do anything to it!
float MF_SHUFFLER_CHARGE= 16;	//shuffler charging - obsolete now
float MF_GOON_SLAP 	= 32;	//shuffler slapping his goons about
float MF_COUNT_FRAGS	= 64;	//add kills to self.frags - useful for shuffler
float MF_GREATER_DEMON	= 128;	//indicates a large, powerful monster - used in shuffler slap
float MF_ZOMBIE_GIB	= 256;	//gibs like a zombie - used in some monster damage calculations
float MF_SHUFFLER_MINION= 512;	//spawned by a shuffler
float MF_GANG_SPAWNED	= 1024;	//spawned by a gangspawner
float MF_SMOOTH_FLIGHT	= 2048;	//flymonsters/swimmonsters move using entirely velocity changes
float MF_TFRAG_PRIORITY = 4096;	//give monsters priority when telefragging
float M_AMBUSH			= 1;
float M_GROUP			= 2;	//collect 6 of these into a single edict (replaces M_NOJUMP)
float M_SPAWNED			= 4;	//spawn into the level even if not grouped (replaces M_NOSIGHT)
float M_SPAWNSILENT		= 8;	//for monster group spawners
float M_SPAWNANGRY		= 16;	//this lets you make grouped monsters angry on spawning
float M_SPAWNNODROP		= 32;	//does not droptofloor on spawn
float M_REMOVECORPSE		= 64;	//remove corpse after a while - gangspawned monsters have this as default
float M_MISSILETARGET		= 128;	//other monsters will never get angry, unless they can reach it according to self.max_attack_height
float M_NOGUIDE			= 4096;		//will not use monsterguide triggers
float M_NOJUMP			= 8192;		//will not use monsterjump triggers - useful if you don't want all monsters to jump
float M_NOSIGHT			= 16384;	//no sight sound on spotting player for first time
float M_NOTARGET		= 32768;	//other monsters will not start a fight with this one
float GIB_FLESH = 1;
float GIB_METAL = 2;
float GF1_WEAPON_TWEAKS = 2;		//nail firing positions changed to match weapon model better, lightning position smoothed
float GF1_ID_MAPNAME	= 4;
float GF1_MONSTER_FRIENDLY_DMG = 32;	//if enabled, monsters do not take damage from each other if they have the same classname (like in doom)
float GF1_IMPACTS 	= 64;		//enable impact sounds like bodydrops etc.
float GF1_ALT_GIBS	= 128;		//different gib stylies
float GF1_NO_GROUPING	= 256;		//don't group monsters/items
float GF1_CORPSE_STAY	= 512;		//all corpses stay behind, like classic quake - use in high-capacity engines
float GF1_CORPSE_REMOVE_ALL = 1024;	//remove all corpses immediately
float GF1_GIBS_CHANGED	= 2048;		//hack to support changed gibs
float GF1_MAP_RESET_HACK = 4096;	//hack to keep position after killing self if you want
float SPAWN_SILENT	= 1;
float SPAWN_NODROP	= 2;
float SPAWN_FACEINWARD	= 4; 	//radial spawners
float SPAWN_FACEOUTWARD	= 8;	//radial spawners
float SPAWN_ANGRY 	= 16;	//already angry at player
float SPAWN_CORPSESTAY 	= 32;	//force corpses to remain
float gameflags1;			//stored in saved1 cvar
.float monstertype;
.float voice_finished;
.float idleweaponframe;
.float monsterflags;
.float monster_fight_time;
.float() check_attack;
.float mass;
.float spawnhack;

//Survival
float survival; /* = 0.000 */

//Okay so there are a lot of stolen things from other mods in my keep mod, lets see what mod we are in based on the .bsp
float checkmod_id1;
float checkmod_hipnotic;
//float checkmod_rogue;
//float checkmod_custents;
//float checkmod_contract;
//float checkmod_kinnmarcher;
//float checkmod_quoth;


// Built-in functions (can be overridden if you assign a different function to the parm #, e.g. "void () makevectors2 = #1;")
void (vector ang) makevectors = #1; 
void (entity e, vector o) setorigin = #2; 
void (entity e, string m) setmodel = #3; 
void (entity e, vector min, vector max) setsize = #4; 

void () break = #6; 
float () random = #7; 
void (entity e, float chan, string samp, float vol, float atten) sound = #8; 
vector (vector v) normalize = #9; 
void (string e) error = #10; 
void (string e) objerror = #11; 
float (vector v) vlen = #12; 
float (vector v) vectoyaw = #13; 
entity () spawn = #14; 
void (entity e) remove = #15; 
void (vector v1, vector v2, float nomonsters, entity forent) traceline = #16; 
entity () checkclient = #17; 
entity (entity start, .string fld, string match) find = #18; 
string (string s) precache_sound = #19; 
string (string s) precache_model = #20; 
void (entity client, string s) stuffcmd = #21; 
entity (vector org, float rad) findradius = #22; 
void (string s) bprint = #23; 
void (entity client, string s) sprint = #24; 
void (string s) dprint = #25; 
string (float f) ftos = #26; 
string (vector v) vtos = #27; 
void () coredump = #28; 
void () traceon = #29; 
void () traceoff = #30; 
void (entity e) eprint = #31; 
float (float yaw, float dist) walkmove = #32;


float () droptofloor = #34; 
void (float style, string value) lightstyle = #35; 
float (float v) rint = #36; 
float (float v) floor = #37; 
float (float v) ceil = #38; 

float (entity e) checkbottom = #40; 
float (vector v) pointcontents = #41; 

float (float f) fabs = #43; 
vector (entity e, float speed) aim = #44; 
float (string s) cvar = #45; 
void (string s) localcmd = #46; 
entity (entity e) nextent = #47; 
void (vector o, vector d, float color, float count) particle = #48; 
void () ChangeYaw = #49; 

vector (vector v) vectoangles = #51; 
void (float to, float f) WriteByte = #52; 
void (float to, float f) WriteChar = #53; 
void (float to, float f) WriteShort = #54; 
void (float to, float f) WriteLong = #55; 
void (float to, float f) WriteCoord = #56; 
void (float to, float f) WriteAngle = #57; 
void (float to, string s) WriteString = #58; 
void (float to, entity s) WriteEntity = #59; 



void (entity ent) changepitch = #63; //dp

string (entity ent) etos = #65; //dp

void (float step) movetogoal = #67; 
string (string s) precache_file = #68; 
void (entity e) makestatic = #69; 
void (string s) changelevel = #70; 

void (string var, string val) cvar_set = #72; 
void (entity client, string s) centerprint = #73; 
void (vector pos, string samp, float vol, float atten) ambientsound = #74; 
string (string s) precache_model2 = #75; 
string (string s) precache_sound2 = #76; 
string (string s) precache_file2 = #77; 
void (entity e) setspawnparms = #78; 

//dp defs follow:

entity (.string fld, string match) findchain = #402;
entity (.float fld, float match) findchainflags = #450;

entity (.entity fld, entity match) findchainentity = #403;

entity (.float fld, float match) findchainfloat = #403;

entity (entity start, .float fld, float match) findflags = #449;

entity (entity start, .entity fld, entity match) findentity = #98;

entity (entity start, .float fld, float match) findfloat = #98;

float (string pattern, float caseinsensitive, float quiet) search_begin = #444;

void (float handle) search_end = #445;

float (float handle) search_getsize = #446;

string (float handle, float num) search_getfilename = #447;
vector (vector org) getlight = #92;

float (entity e, float s) getsurfacenumpoints = #434;

vector (entity e, float s, float n) getsurfacepoint = #435;

vector (entity e, float s) getsurfacenormal = #436;

string (entity e, float s) getsurfacetexture = #437;

float (entity e, vector p) getsurfacenearpoint = #438;

vector (entity e, float s, vector p) getsurfaceclippedpoint = #439;


float (entity ent) wasfreed = #353;

void (entity from, entity to) copyentity = #400;


void (entity e, entity tagentity, string tagname) setattachment = #443; 

string (string s) cvar_string = #448;

entity (float entnum) edict_num = #459;

float (float s) asin = #471; 
float (float c) acos = #472; 
float (float t) atan = #473; 
float (float c, float s) atan2 = #474; 
float (float a) tan = #475; 

string (string s) cvar_defstring = #482;

float (string name) gecko_create = #487;

void (string name) gecko_destroy = #488;

void (string name, string URI) gecko_navigate = #489;

float (string name, float key, float eventtype) gecko_keyevent = #490;

void (string name, float x, float y) gecko_mousemove = #491;

void (string name, float w, float h) gecko_resize = #492;

vector (string name) gecko_get_texture_extent = #493;


float () numentityfields = #496;

string (float fieldnum) entityfieldname = #497;

float (float fieldnum) entityfieldtype = #498;

string (float fieldnum, entity ent) getentityfieldstring = #499;
float (float fieldnum, entity ent, string s) putentityfieldstring = #500;

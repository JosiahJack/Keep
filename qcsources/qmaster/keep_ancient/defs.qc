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
float FALSE    = 0.000;
float TRUE    = 1.000;
float COOP_ONLY =   1;
float COOP_NOT =    2;
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
float IT_AXE    = 4096.000;
float IT_SHOTGUN    = 1.000;
float IT_SUPER_SHOTGUN    = 2.000;
float IT_NAILGUN    = 4.000;
float IT_SUPER_NAILGUN    = 8.000;
float IT_GRENADE_LAUNCHER    = 16.000;
float IT_ROCKET_LAUNCHER    = 32.000;
float IT_LIGHTNING    = 64.000;
float IT_EXTRA_WEAPON    = 128.000;
float IT_SHELLS    = 256.000;
float IT_NAILS    = 512.000;
float IT_ROCKETS    = 1024.000;
float IT_CELLS    = 2048.000;
float IT_ARMOR1    = 8192.000;
float IT_ARMOR2    = 16384.000;
float IT_ARMOR3    = 32768.000;
float IT_SUPERHEALTH    = 65536.000;
float IT_KEY1    = 131072.000;
float IT_KEY2    = 262144.000;
float IT_KEY3    = 300000.000;
float IT_INVISIBILITY    = 524288.000;
float IT_INVULNERABILITY    = 1048576.000;
float IT_SUIT    = 2097152.000;
float IT_QUAD    = 4194304.000;
float IT_KEY_SKELETON    = 8388608;
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
float SVC_TEMPENTITY    = 23.000;
float SVC_KILLEDMONSTER    = 27.000;
float SVC_FOUNDSECRET    = 28.000;
float SVC_INTERMISSION    = 30.000;
float SVC_FINALE    = 31.000;
float SVC_CDTRACK    = 32.000;
float SVC_SELLSCREEN    = 33.000;
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
float CTF_FLAG_RETURN_TIME    = 40.000;
float CTF_CAPTURE_BONUS    = 15.000;
float CTF_TARGET_PROTECT_RADIUS    = 400.000;
/*===== Keep Defs =====*/
float slippery_active = 0.000;
.float objweight;
.float objbouy;
.float objresist;
.float objaero;
float TEAM2    = 14.000;
.string monster_type;
.float monster_health;
.string classmonster;
.string player_model;
.float player_health;
.float player_weapon;
.vector model_size_mins;
.vector model_size_maxs;
.entity monster_model;
.string monster_mdl;
.entity pointer;
.float disabled;
/*=== End Keep Defs ===*/
float movedist /* = 0.000 */;
float gameover /* = 0.000 */;
string string_null /* = "" */;
float empty_float /* = 0.000 */;
entity newmis;
entity activator;
entity damage_attacker;
float framecount /* = 0.000 */;
float skill /* = 0.000 */;
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



float (float yaw, float dist) droptofloor = #34; 
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

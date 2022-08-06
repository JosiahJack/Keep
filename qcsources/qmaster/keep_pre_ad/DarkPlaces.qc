
.float disableclientprediction;

float MOVE_NORMAL = 0;	
float MOVE_NOMONSTERS = 1;

float MOVE_MISSILE = 2; 
float (string s) checkextension = #99;
.float buttonchat;

.float buttonuse;
float   EF_ADDITIVE     = 32;

float   EF_BLUE         = 64;

float   EF_DOUBLESIDED = 32768;

float   EF_FLAME        = 1024;

float   EF_FULLBRIGHT   = 512;

float   EF_NODEPTHTEST       = 8192;
float   EF_NODRAW       = 16;

float   EF_NOGUNBOB     = 256;

float   EF_NOSHADOW     = 4096;

float   EF_RED          = 128;

float   EF_STARDUST     = 2048;


.float alpha;

.vector colormod;

float EF_DELTA = 8388608;

.entity exteriormodeltoclient;


.float glow_color;

.float glow_size;

.float glow_trail;

float EF_LOWPRECISION = 4194304;

.float scale;

.entity viewmodelforclient;
float GECKO_BUTTON_DOWN         = 0;

float GECKO_BUTTON_UP           = 1;
float GECKO_BUTTON_PRESS        = 2;

float GECKO_BUTTON_DOUBLECLICK  = 3;


/*

float (string name) gecko_create = #487;

void (string name) gecko_destroy = #488;

void (string name, string URI) gecko_navigate = #489;

float (string name, float key, float eventtype) gecko_keyevent = #490;

void (string name, float x, float y) gecko_mousemove = #491;

void (string name, float w, float h) gecko_resize = #492;

vector (string name) gecko_get_texture_extent = #493;

string(string name, string query) Gecko_Query;
.entity tag_entity; 
.float tag_index;
void (entity e, entity tagentity, string tagname) setattachment = #443; 
.float button3;

.float button4;

.float button5;

.float button6;

.float button7;

.float button8;
float MOVETYPE_FOLLOW = 12;

float DEG2RAD = 0.0174532925199432957692369076848861271344287188854172545609719144;

float RAD2DEG = 57.2957795130823208767981548141051703324054724665643215491602438612;

float PI      = 3.1415926535897932384626433832795028841971693993751058209749445923;

float (float s) asin = #471; 
float (float c) acos = #472; 
float (float t) atan = #473; 
float (float c, float s) atan2 = #474; 
float (float a) tan = #475; 
.float idealpitch;

.float pitch_speed;

void (entity ent) changepitch = #63;

void (entity from, entity to) copyentity = #400;

string (string s) cvar_defstring = #482;

string (string s) cvar_string = #448;
entity (float entnum) edict_num = #459;

float (entity ent) wasfreed = #353;
float () numentityfields = #496;

string (float fieldnum) entityfieldname = #497;

float (float fieldnum) entityfieldtype = #498;

string (float fieldnum, entity ent) getentityfieldstring = #499;

float (float fieldnum, entity ent, string s) putentityfieldstring = #500;
float FIELD_STRING   = 1;

float FIELD_FLOAT    = 2;

float FIELD_VECTOR   = 3;

float FIELD_ENTITY   = 4;

float FIELD_FUNCTION = 6;
string (entity ent) etos = #65;

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

float SPA_POSITION = 0;

float SPA_S_AXIS = 1;

float SPA_T_AXIS = 2;

float SPA_R_AXIS = 3;
float SPA_TEXCOORDS0 = 4;

float SPA_LIGHTMAP0_TEXCOORDS = 5;

float SPA_LIGHTMAP0_COLOR = 6;

vector (entity e, float s, float n, float a) getsurfacepointattribute = #486;
float (entity ent, string tagname) gettagindex = #451;

vector (entity ent, float tagindex) gettaginfo = #452;
float (float a, float b) min = #94;

float (float a, float b, float c) min3 = #94;

float (float a, float b, float c, float d) min4 = #94;

float (float a, float b, float c, float d, float e) min5 = #94;

float (float a, float b, float c, float d, float e, float f) min6 = #94;

float (float a, float b, float c, float d, float e, float f, float g) min7 = #94;

float (float a, float b, float c, float d, float e, float f, float g, float h) min8 = #94;

float (float a, float b) max = #95;
float(float a, float b, float c) max3 = #95;

float (float a, float b, float c, float d) max4 = #95;

float (float a, float b, float c, float d, float e) max5 = #95;

float (float a, float b, float c, float d, float e, float f) max6 = #95;

float (float a, float b, float c, float d, float e, float f, float g) max7 = #95;

float (float a, float b, float c, float d, float e, float f, float g, float h) max8 = #95;

float (float minimum, float val, float maximum) bound = #96;
.
float (entity num) num_for_edict = #512;
vector () randomvec = #91;

float (float val) sin = #60;

float (float val) cos = #61;

float (float val) sqrt = #62;

float (float a, float b) pow = #97;

//string(float uselocaltime, string format, ...) strftime = #478;

float(string s) strlennocol = #476;
string(string s) strdecolorize = #477; 
string(string s) strtolower = #480;
string(string s) strtoupper = #481; 
//float(string s, string separator1, ...) tokenizebyseparator = #479;

void(vector v1, vector min, vector max, vector v2, float nomonsters, entity forent) tracebox = #90;

void(entity ent, entity ignore) tracetoss = #64;

float MOVE_HITMODEL = 4;

float MOVE_WORLDONLY = 3;

vector(vector forward, vector up) vectoangles2 = #51;
void(vector dir) vectorvectors = #432;
string(string filename) whichpack = #503;
string(string in) uri_escape = #510;

string(string in) uri_unescape = #511;
float(string name, string value) registercvar = #93;

float SOLID_CORPSE = 5;

float CLIENTTYPE_DISCONNECTED = 0;

float CLIENTTYPE_REAL = 1;

float CLIENTTYPE_BOT = 2;

float CLIENTTYPE_NOTACLIENT = 3;
entity() spawnclient = #454;
float(entity clent) clienttype = #455;
.float clientcolors; 
.float() customizeentityforclient; 
.entity drawonlytoclient;

void(entity clent) dropclient = #453;
void(vector org, string modelname, float startframe, float endframe, float framerate) effect = #404;
//float svc_effect = #52; 
//float svc_effect2 = #53; 
.void(float nOriginalContents, float nNewContents) contentstransition;
.void(vector vImpactVelocity) movetypesteplandevent;
void(vector origin, string sample, float volume, float attenuation) pointsound = #483;
.float modelflags;
float EF_NOMODELFLAGS = 8388608; 
float MF_ROCKET  =   1;

float MF_GRENADE =   2;

float MF_GIB     =   4;

float MF_ROTATE  =   8; 
float MF_TRACER  =  16; //scrag spit effect
float MF_ZOMGIB  =  32;

float MF_TRACER2 =  64; // death knight magic effect
float MF_TRACER3 = 128; // vore star effect
.string netaddress;
.entity nodrawtoclient;
.float ping;

float(string effectname) particleeffectnum = #335;
void(entity ent, float effectnum, vector start, vector end) trailparticles = #336;

void(float effectnum, vector org, vector vel, float howmany) pointparticles = #337;
float svc_trailparticles = 60; 
float svc_pointparticles = 61; 
float svc_pointparticles1 = 62; 
.vector punchvector;

.vector movement;
void() SV_PlayerPhysics;
//void(string s, ...) print = #339;
void(entity ent, float colors) setcolor = #401;
void(float color) SV_ChangeTeam;
void(float to, string s, float sz) WritePicture = #501;
string(void) ReadPicture = #501;
void(float to, string s) WriteUnterminatedString = #456;
void(vector org, vector velocity, float howmany) te_blood = #405;
float TE_BLOOD = 50;
void(vector mincorner, vector maxcorner, float explosionspeed, float howmany) te_bloodshower = #406;
float TE_BLOODSHOWER = 52;

void(vector org, float radius, float lifetime, vector color) te_customflash = #417;
float TE_CUSTOMFLASH = 73;
void(vector org, vector color) te_explosionrgb = #407;

float TE_EXPLOSIONRGB = 53;
void(vector org, vector vel, float howmany) te_flamejet = #457;
float TE_FLAMEJET = 74;
void(vector mincorner, vector maxcorner, vector vel, float howmany, float color, float gravityflag, float randomveljitter) te_particlecube = #408;
float TE_PARTICLECUBE = 54;
void(vector mincorner, vector maxcorner, vector vel, float howmany, float color) te_particlerain = #409;

float TE_PARTICLERAIN = 55;
void(vector mincorner, vector maxcorner, vector vel, float howmany, float color) te_particlesnow = #410;
float TE_PARTICLESNOW = 56;
void(vector org) te_plasmaburn = #433;

float TE_PLASMABURN = 75;
void(vector org) te_gunshotquad = #412;

void(vector org) te_spikequad = #413;
void(vector org) te_superspikequad = #414;

void(vector org) te_explosionquad = #415;

float   TE_GUNSHOTQUAD  = 57;
float   TE_SPIKEQUAD    = 58; 
float   TE_SUPERSPIKEQUAD = 59; 
float   TE_EXPLOSIONQUAD = 70;
void(vector org) te_smallflash = #416;
float TE_SMALLFLASH = 72;

void(vector org, vector vel, float howmany) te_spark = #411;
float TE_SPARK = 51.000;
void(vector org) te_gunshot = #418;
void(vector org) te_spike = #419;

void(vector org) te_superspike = #420;

void(vector org) te_explosion = #421;

void(vector org) te_tarexplosion = #422;

void(vector org) te_wizspike = #423;

void(vector org) te_knightspike = #424;

void(vector org) te_lavasplash = #425;

void(vector org) te_teleport = #426;

void(vector org, float color, float colorlength) te_explosion2 = #427;
void(entity own, vector start, vector end) te_lightning1 = #428;

void(entity own, vector start, vector end) te_lightning2 = #429;
void(entity own, vector start, vector end) te_lightning3 = #430;

void(entity own, vector start, vector end) te_beam = #431;
.float dphitcontentsmask;
float trace_dpstartcontents;
float trace_dphitcontents;
float trace_dphitq3surfaceflags;
float DPCONTENTS_SOLID = 1; 
float DPCONTENTS_WATER = 2;

float DPCONTENTS_SLIME = 4;

float DPCONTENTS_LAVA = 8;

float DPCONTENTS_SKY = 16;

float DPCONTENTS_BODY = 32;
float DPCONTENTS_CORPSE = 64;
float DPCONTENTS_NODROP = 128;
float DPCONTENTS_PLAYERCLIP = 256;
float DPCONTENTS_MONSTERCLIP = 512;
float DPCONTENTS_DONOTENTER = 1024;
float DPCONTENTS_LIQUIDSMASK = 14;
float Q3SURFACEFLAG_NODAMAGE = 1;

float Q3SURFACEFLAG_SLICK = 2;
float Q3SURFACEFLAG_SKY = 4;
float Q3SURFACEFLAG_LADDER = 8;
float Q3SURFACEFLAG_NOIMPACT = 16;
float Q3SURFACEFLAG_NOMARKS = 32;
float Q3SURFACEFLAG_FLESH = 64;
float Q3SURFACEFLAG_METALSTEPS = 4096;
float Q3SURFACEFLAG_NOSTEPS = 8192;
.float viewzoom;
float(float number, float quantity) bitshift = #218;
float(string s) stof = #81;
float(string filename, float mode) fopen = #110;
void(float fhandle) fclose = #111;
string(float fhandle) fgets = #112;
//void(float fhandle, string s, ...) fputs = #113;
float(string s) strlen = #114;
//string(string s1, string s2, ...) strcat = #115;
string(string s, float start, float length) substring = #116;

vector(string s) stov = #117; 

//string(string s, ...) strzone = #118; 

void(string s) strunzone = #119;
float FILE_READ = 0;

float FILE_APPEND = 1;

float FILE_WRITE = 2;
void(string s) SV_ParseClientCommand;
void(entity e, string s) clientcommand = #440;

float(string s) tokenize = #441;

string(float n) argv = #442;

void() RestoreGame;

.string playermodel; 

.string playerskin;
float EF_SELECTABLE = 16384;
.float cursor_active; 
.vector cursor_screen;
.vector cursor_trace_start;
.vector cursor_trace_endpos;
.entity cursor_trace_ent;
.float light_lev; 
.vector color; 
.float style; 
.float pflags; 
.vector angles; 
.float skin; 
float PFLAGS_NOSHADOW = 1; 
float PFLAGS_CORONA = 2; 
float PFLAGS_FULLDYNAMIC = 128; 
float(string str, string sub, float startpos) strstrofs = #221;

float(string str, float ofs) str2chr = #222;

//string(float c, ...) chr2str = #223;

//string(float ccase, float calpha, float cnum, string s, ...) strconv = #224;

//string(float chars, string s, ...) strpad = #225;

//string(string info, string key, string value, ...) infoadd = #226;

string(string info, string key) infoget = #227;

float(string s1, string s2, float len) strncmp = #228;

float(string s1, string s2) strcasecmp = #229;

float(string s1, string s2, float len) strncasecmp = #230;

float() buf_create = #460;

void(float bufhandle) buf_del = #461;

float(float bufhandle) buf_getsize = #462;

void(float bufhandle_from, float bufhandle_to) buf_copy = #463;

void(float bufhandle, float sortpower, float backward) buf_sort = #464;

string(float bufhandle, string glue) buf_implode = #465;
string(float bufhandle, float string_index) bufstr_get = #466;

void(float bufhandle, float string_index, string str) bufstr_set = #467;

float(float bufhandle, string str, float order) bufstr_add = #468;

void(float bufhandle, float string_index) bufstr_free = #469;

string(string search, string replace, string subject) strreplace = #484;

string(string search, string replace, string subject) strireplace = #485;
//.
float(float caseinsensitive, string s, ...) crc16 = #494;
void SV_Shutdown();
//void(float index, float type, .void field) SV_AddStat (EXT_CSQC)
 void(float index, float type, ...) addstat = #232;
// core functions from standard quake
void(vector ang) makevectors = #1;
void(entity e, vector o) setorigin = #2;
void(entity e, string m) setmodel = #3;
void(entity e, vector min, vector max) setsize = #4;
void(entity e, vector min, vector max) setabssize = #5;
void() break = #6;
float() random = #7;
void(entity e, float chan, string samp) sound = #8;
vector(vector v) normalize = #9;
void(string e) error = #10;
void(string e) objerror = #11;
float(vector v) vlen = #12;
float(vector v) vectoyaw = #13;
entity() spawn = #14;
void(entity e) remove = #15;
float(vector v1, vector v2, float tryents) traceline = #16;
entity() checkclient = #17;
entity(entity start, .string fld, string match) find = #18;
void(string s) precache_sound = #19;
void(string s) precache_model = #20;
entity(vector org, float rad) findradius = #22;

string(float f) ftos = #26;
string(vector v) vtos = #27;
void() coredump = #28;
void() traceon = #29;
void() traceoff = #30;
void(entity e) eprint = #31;
float(float yaw, float dist) walkmove = #32;

float() droptofloor = #34;
void(float style, string value) lightstyle = #35;
float(float v) rint = #36;
float(float v) floor = #37;
float(float v) ceil = #38;

float(entity e) checkbottom = #40;
float(vector v) pointcontents = #41;

float(float f) fabs = #43;
float(string s) cvar = #45;
void(string s) localcmd = #46;
entity(entity e) nextent = #47;
void(vector o, vector d, float color, float count) particle = #48;
void() ChangeYaw = #49;

vector(vector v) vectoangles = #51;

string(string s) precache_file = #68;
void(entity e) makestatic = #69;

void(string var, string val) cvar_set = #72;

void(vector pos, string samp, float vol, float atten) ambientsound = #74;
string(string s) precache_model2 = #75;
string(string s) precache_sound2 = #76;
string(string s) precache_file2 = #77;



// core ext_csqc functions
void() R_ClearScene = #300;
void(float mask) R_AddEntities = #301;
void(entity ent) R_AddEntity = #302;
float(float property, ...) R_SetView = #303;
void() R_RenderScene = #304;
void(vector org, float radius, vector lightcolours) R_AddDynamicLight = #305;
void(string texturename, float flag, float is2d, float lines) R_BeginPolygon = #306;
void(vector org, vector texcoords, vector rgb, float alpha) R_PolygonVertex = #307;
void() R_EndPolygon = #308;

vector (vector v) cs_unproject = #310;
vector (vector v) cs_project = #311;

void(float width, vector pos1, vector pos2, float flag) drawline = #315;
float(string name) iscachedpic = #316;
string(string name) precache_pic = #317;
vector(string picname) draw_getimagesize = #318;
void(string name) freepic = #319;
float(vector position, float character, vector scale, vector rgb, float alpha, float flag) drawcharacter = #320;
float(vector position, string text, vector scale, vector rgb, float alpha, float flag) drawstring = #321;
float(vector position, string pic, vector size, vector rgb, float alpha, float flag) drawpic = #322;
float(vector position, vector size, vector rgb, float alpha, float flag) drawfill = #323;
void(float x, float y, float width, float height) drawsetcliparea = #324;
void(void) drawresetcliparea = #325;
float drawcolorcodedstring(vector position, string text, vector scale, vector rgb, float alpha, float flag) = #326;

float (float statnum) getstat_float = #330;
float (float statnum) getstat_float_truncated = #331;
string (float statnum) getstat_string = #332;

void(entity e, float mdlindex) setmodelindex = #333;
string(float mdlindex) modelnameforindex = #334;
float(string effectname) particleeffectnum = #335;
void(entity ent, float effectnum, vector start, vector end) trailparticles = #336;
void(float effectnum, vector origin, vector dir, float count) pointparticles = #337;
void(string s, ...) centerprint = #338;
void(string s, ...) print = #339;
string(float keynum) keynumtostring = #340;
float(string keyname) stringtokeynum = #341;
string(float keynum) getkeybind = #342;
void(float usecursor) setcursormode = #343;
vector() getmousepos = #344;
float(float framenum) getinputstate = #345;
void(float sens) setsensitivityscaler = #346;
void() runstandardplayerphysics = #347;
string(float playernum, string keyname) getplayerkeyvalue = #348;
float() isdemo = #349;
float() isserver = #350;
void(vector origin, vector forward, vector right, vector up) SetListener = #351;
void(string cmdname) registercommand = #352;
float(entity ent) wasfreed = #353;
string(string key) serverkey = #354;

float() ReadByte = #360;
float() ReadChar = #361;
float() ReadShort = #362;
float() ReadLong = #363;
float() ReadCoord = #364;
float() ReadAngle = #365;
string() ReadString = #366;	//warning: this returns a temporary!
float() ReadFloat = #367;
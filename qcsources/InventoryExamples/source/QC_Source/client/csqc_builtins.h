void (vector ang)							makevectors = #1;
void(entity e, vector o) setorigin	= #2;
void (entity e, string m)						setmodel = #3;

void ()									break = #6;
float ()								random = #7;
void (entity e, float chan, string samp, float vol, float atten)	sound = #8;
vector (vector v)							normalize = #9;
void (string e)								error = #10;
void (string e)								objerror = #11;
float (vector v)							vlen = #12;
float (vector v)							vectoyaw = #13;
entity ()								spawn = #14;
void (entity e)								remove = #15;

void (vector v1, vector v2, float nomonsters, entity forent)		traceline = #16;

entity (entity start, .string fld, string match)			find = #18;
string (string s)							precache_sound = #19;
string (string s)							precache_model = #20;

void (string s)								dprint = #25;
string (float f)							ftos = #26;
string (vector v)							vtos = #27;
void ()									coredump = #28;
void ()									traceon = #29;
void ()									traceoff = #30;
void (entity e)								eprint = #31;

float (float v)								rint = #36;
float (float v)								floor = #37;
float (float v)								ceil = #38;

float (vector v)							pointcontents = #41;
float (float f)								fabs = #43;

float (string s)							cvar = #45;
void (string s, ...)							localcmd = #46;
entity (entity e)							nextent = #47;

vector (vector v)							vectoangles = #51;

void (string var, string val)						cvar_set = #72;


float()									ReadByte = #360;
float()									ReadChar = #361;
float()									ReadShort = #362;
float()									ReadLong = #363;
float()									ReadCoord = #364;
float()									ReadAngle = #365;
string()								ReadString = #366;	//warning: this returns a temporary!

float(string s)								stof = #81;


void (vector v1, vector min, vector max, vector v2, float nomonsters, entity forent)	tracebox = #90;
float (string name, string value)					registercvar = #93;

entity (entity start, .entity fld, entity match)			findentity = #98;
entity (entity start, .float fld, float match)				findfloat = #98;

float (string s)							checkextension = #99;

float (string filename, float mode)					fopen = #110;
void (float fhandle)							fclose = #111;
string (float fhandle)							fgets = #112;
void (float fhandle, string s)						fputs = #113;
float (string s)							strlen = #114;
string (...)								strcat = #115;
string (string s, float start, float length)				substring = #116;
vector (string s)							stov = #117;
string (string s)							strzone = #118;
void (string s)								strunzone = #119;

void ()									R_ClearScene = #300;
void (float mask)							R_AddEntities = #301;
void (entity e)								R_AddEntity = #302;
float (float property, ...)						R_SetView = #303;
void ()									R_RenderScene = #304;
void (vector org, float radius, vector rgb)				R_AddDynamicLight = #305;
void ()									R_CalcRefDef = #306;

vector (vector v)							cs_unproject = #310;
vector (vector v)							cs_project = #311;

void	drawline(float width, vector pos1, vector pos2, vector rgb, float alpha, float flags) = #315;
float	iscachedpic(string name)	= #316;
string	precache_pic(string name, ...)	= #317;
vector	drawgetimagesize(string pic) = #318;
void	freepic(string name)		= #319;
float	drawcharacter(vector position, float character, vector scale, vector rgb, float alpha, float flag) = #320;
float	drawstring(vector position, string text, vector scale, vector rgb, float alpha, float flag) = #321;
float	drawpic(vector position, string pic, vector size, vector rgb, float alpha, float flag) = #322;
float	drawfill(vector position, vector size, vector rgb, float alpha, float flag) = #323;
void	drawsetcliparea(float x, float y, float width, float height) = #324;
void	drawresetcliparea(void) = #325;


float (float statnum)							getstatf = #330;
float (float statnum)							getstati = #331;
string (float statnum)							getstats = #332;

void (entity e, float i)						setmodelindex = #333;
string (float i)							modelnameforindex = #334;

float(string efname)							particleseffectforname = #335;
void(entity ent, float effectnum, vector start, vector end, ...)	trailparticles = #336;
void (float efnum, vector org, vector vel, float countmultiplier)	pointparticles = #337;

void (string s, ...)							cprint = #338;
void (string s, ...)							print = #339;



void (float scale)							setsensitivityscale = #347;


void (float framenum)							RetrieveMovementFrame = #345;
void ()									DefaultPlayerPhysics = #347;

string (float playernum, string key)					getplayerkey = #348;
void (string cmdname)							registercmd = #352;
vector ()								getmousepos = #344;

string (string s) 							uncolorstring = #170;

float ()								playernum = #354;

void (vector org, vector forward, vector right, vector up)		setlistener = #351;

float (vector start, vector end, float ignore, float csqcents)		selecttraceline = #355;
float ()								isdemo = #349;
float ()								isserver = #350;

void (float f)								setwantsmousemove = #343;
string (float key)							getkeybind = #342;
string (float f)							chr = #78;

vector (vector org)							getlight = #92;

entity (.string fld, string match)					findchain = #402;
entity (.float fld, float match)					findchainflags = #450;
entity (.entity fld, entity match)					findchainentity = #403;
entity (.float fld, float match)					findchainfloat = #403;
entity (entity start, .entity fld, float match)				findflags = #449;

float (string pattern, float caseinsensitive, float quiet)		search_begin = #444;
void (float handle)							search_end = #445;
float (float handle)							search_getsize = #446;
string (float handle, float num)					search_getfilename = #447;


float (entity e, float s)						getsurfacenumpoints = #434;
vector (entity e, float s, float n)					getsurfacepoint = #435;
vector (entity e, float s)						getsurfacenormal = #436;
string (entity e, float s)						getsurfacetexture = #437;
float (entity e, vector p)						getsurfacenearpoint = #438;
vector (entity e, float s, vector p)					getsurfaceclippedpoint = #439;

float (float a, float b) min = #94;
float (float a, float b, float c) min3 = #94;
float (float a, float b, float c, float d) min4 = #94;
float (float a, float b, float c, float d, float e) min5 = #94;
float (float a, float b, float c, float d, float e, float f) min6 = #94;
float (float a, float b, float c, float d, float e, float f, float g) min7 = #94;
float (float a, float b, float c, float d, float e, float f, float g, float h) min8 = #94;
float (float a, float b) max = #95;
float (float a, float b, float c) max3 = #95;
float (float a, float b, float c, float d) max4 = #95;
float (float a, float b, float c, float d, float e) max5 = #95;
float (float a, float b, float c, float d, float e, float f) max6 = #95;
float (float a, float b, float c, float d, float e, float f, float g) max7 = #95;
float (float a, float b, float c, float d, float e, float f, float g, float h) max8 = #95;
float (float minimum, float val, float maximum) bound = #96;

vector () randomvec = #91;

float (float val)		sin = #60;
float (float val)		cos = #61;
float (float val)		sqrt = #62;
float (float a, float b)	pow = #97;

void (vector org, string modelname, float startframe, float endframe, float framerate) effect = #404;

void (vector org, vector velocity, float howmany) te_blood = #405;
void (vector mincorner, vector maxcorner, float explosionspeed, float howmany) te_bloodshower = #406;
void (vector org, float radius, float lifetime, vector color) te_customflash = #417;
void(vector org, vector color) te_explosionrgb = #407;
void(vector mincorner, vector maxcorner, vector vel, float howmany, float color, float gravityflag, float randomveljitter) te_particlecube = #408;
void(vector mincorner, vector maxcorner, vector vel, float howmany, float color) te_particlerain = #409;
void(vector mincorner, vector maxcorner, vector vel, float howmany, float color) te_particlesnow = #410;
void(vector org) te_plasmaburn = #433;
void(vector org) te_gunshotquad = #412;
void(vector org) te_spikequad = #413;
void(vector org) te_superspikequad = #414;
void(vector org) te_explosionquad = #415;
void(vector org) te_smallflash = #416;
void(vector org, vector vel, float howmany) te_spark = #411;

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

float (entity ent, string tagname)	gettagindex = #451;
vector (entity ent, float tagindex)	gettaginfo = #452;

float (string s)	tokenize = #441;
string (float argnum)	argv = #442;

string (string s) cvar_string = #448;

float ()						buf_create = #460;
void (float bufhandle)					buf_del = #461;
float (float bufhandle)					buf_getsize = #462;
void (float bufhandle_from, float bufhandle_to)		buf_copy = #463;
void (float bufhandle, float sortpower, float backward)	buf_sort = #464;
string (float bufhandle, string glue)			buf_implode = #465;
string (float bufhandle, float string_index)		bufstr_get = #466;
void (float bufhandle, float string_index, string str)	bufstr_set = #467;
float (float bufhandle, string str, float order)	bufstr_add = #468;
void (float bufhandle, float string_index)		bufstr_free = #469;

float () onground = #355;

void(string texturename, ...) R_BeginPolygon = #306;
void(vector org, vector texcoords, vector rgb, float alpha) R_PolygonVertex = #307;
void() R_EndPolygon = #308;

float(string s, float num) charindex = #356;
void(entity e) r_addentity = #301;
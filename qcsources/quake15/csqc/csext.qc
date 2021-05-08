
//DP_SV_POINTPARTICLES
//idea: Spike
//darkplaces implementation: LordHavoc
//function definitions:
float(string effectname) particleeffectnum = #335; // same as in CSQC
void(entity ent, float effectnum, vector start, vector end) trailparticles = #336; // same as in CSQC
void(float effectnum, vector org, vector vel, float howmany) pointparticles = #337; // same as in CSQC
//SVC definitions:
//float svc_trailparticles = 60; // [short] entnum [short] effectnum [vector] start [vector] end
//float svc_pointparticles = 61; // [short] effectnum [vector] start [vector] velocity [short] count
//float svc_pointparticles1 = 62; // [short] effectnum [vector] start, same as svc_pointparticles except velocity is zero and count is 1
//description:
//provides the ability to spawn non-standard particle effects, typically these are defined in a particle effect information file such as effectinfo.txt in darkplaces.
//this is a port of particle effect features from clientside QC (EXT_CSQC) to server QC, as these effects are potentially useful to all games even if they do not make use of EXT_CSQC.
//warning: server must have same order of effects in effectinfo.txt as client does or the numbers would not match up, except for standard quake effects which are always the same numbers.
void(...) localcmd = #46;
float(string s) tokenize = #441;
string(float argnum) argv = #442;
float(string s) cvar = #45;                  // return cvar.value
float(string s) stof   = #81;
string(float f) ftos            = #26;
float(string st) strlen = #114;
entity() spawn                  = #14;
string(string s) cvar_string = #448;
string (vector v) vtos = #27; 
string(string s, float start, float length) substring = #116;
entity (entity start, .string fld, string match) find = #18; 
void (entity e) remove = #15; 
void(string s) cprint	= #23;
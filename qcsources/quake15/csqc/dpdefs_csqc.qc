
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



//DarkPlaces supported extension list that only work in CSQC

// DP_CSQC_SPAWNPARTICLE
// idea: VorteX
// darkplaces implementation: VorteX
// constant definitions:
// particle base behavior:
float PT_ALPHASTATIC = 1;
float PT_STATIC = 2;
float PT_SPARK = 3;
float PT_BEAM = 4;
float PT_RAIN = 5;
float PT_RAINDECAL = 6;
float PT_SNOW = 7;
float PT_BUBBLE = 8;
float PT_BLOOD = 9;
float PT_SMOKE = 10;
float PT_DECAL = 11;
float PT_ENTITYPARTICLE = 12;
// particle blendtypes:
float PBLEND_ALPHA = 0;
float PBLEND_ADD = 1;
float PBLEND_INVMOD = 2;
// particle orientation:
float PARTICLE_BILLBOARD = 0;
float PARTICLE_SPARK = 1;
float PARTICLE_ORIENTED_DOUBLESIDED = 2;
float PARTICLE_BEAM = 3;
// global definitions:
float particle_type; // one of PT_
float particle_blendmode; // one of PBLEND_ values
float particle_orientation; // one of PARTICLE_ values
vector particle_color1; 
vector particle_color2;
float particle_tex; // number of chunk in particlefont
float particle_size;
float particle_sizeincrease; 
float particle_alpha;
float particle_alphafade;
float particle_time;
float particle_gravity;
float particle_bounce;
float particle_airfriction;
float particle_liquidfriction;
float particle_originjitter;
float particle_velocityjitter;
float particle_qualityreduction; // enable culling of this particle when FPS is low
float particle_stretch;
vector particle_staincolor1;
vector particle_staincolor2;
float particle_staintex;
float particle_stainalpha;
float particle_stainsize;
float particle_delayspawn;
float particle_delaycollision;
float particle_angle;
float particle_spin;
// builtin definitions:
float(float max_themes) initparticlespawner = #522; // check fields/globals for integration and enable particle spawner, return 1 is succeded, otherwise returns 0
void() resetparticle = #523; // reset p_ globals to default theme #0
void(float theme) particletheme = #524; // restore p_ globals from saved theme
float() particlethemesave = #525; // save p_ globals to new particletheme and return it's index
void(float theme) particlethemeupdate = #525; // save p_ globals to new particletheme and return it's index
void(float theme) particlethemefree = #526; // delete a particle theme
float(vector org, vector vel) particle = #527; // returns 0 when failed, 1 when spawned
float(vector org, vector vel, float theme) quickparticle = #527; // not reading globals, just theme, returns 0 when failed, 1 when spawned
float(vector org, vector vel, float delay, float collisiondelay) delayedparticle = #528;
float(vector org, vector vel, float delay, float collisiondelay, float theme) quickdelayedparticle = #528;
// description: this builtin provides an easy and flexible way to spawn particles, 
// it is not created as replace for DP_SV_POINTPARTICLES but as an addition to it. 
// With this extension you can create a specific particles like rain particles, or entity particles
// notes: 
// 1) 0 is default particle template, it could be changed
// 2) color vectors could have value 0-255 of each component
// restrictions: max themes could be between 4 and 2048
// warning: you should call initparticlespawner() at very beginning BEFORE all other particle spawner functions
// function to query particle info
// don't remove this function as it protects all particle_ globals from FTEQCC/FRIKQCC non-referenced removal optimisation
/*void() printparticle =
{
	// vortex: this also protects from 'non-referenced' optimisation on some compilers
	print("PARTICLE:\n");
	print(strcat("  type: ", ftos(particle_type), "\n"));
	print(strcat("  blendmode: ", ftos(particle_blendmode), "\n"));
	print(strcat("  orientation: ", ftos(particle_orientation), "\n"));
	print(strcat("  color1: ", vtos(particle_color1), "\n"));
	print(strcat("  color2: ", vtos(particle_color2), "\n"));
	print(strcat("  tex: ", ftos(particle_tex), "\n"));
	print(strcat("  size: ", ftos(particle_size), "\n"));
	print(strcat("  sizeincrease: ", ftos(particle_sizeincrease), "\n"));
	print(strcat("  alpha: ", ftos(particle_alpha), "\n"));
	print(strcat("  alphafade: ", ftos(particle_alphafade), "\n"));
	print(strcat("  time: ", ftos(particle_time), "\n"));
	print(strcat("  gravity: ", ftos(particle_gravity), "\n"));
	print(strcat("  bounce: ", ftos(particle_bounce), "\n"));
	print(strcat("  airfriction: ", ftos(particle_airfriction), "\n"));
	print(strcat("  liquidfriction: ", ftos(particle_liquidfriction), "\n"));
	print(strcat("  originjitter: ", ftos(particle_originjitter), "\n"));
	print(strcat("  velocityjitter: ", ftos(particle_velocityjitter), "\n"));
	print(strcat("  qualityreduction: ", ftos(particle_qualityreduction), "\n"));
	print(strcat("  stretch: ", ftos(particle_stretch), "\n"));
	print(strcat("  staincolor1: ", vtos(particle_staincolor1), "\n"));
	print(strcat("  staincolor2: ", vtos(particle_staincolor2), "\n"));
	print(strcat("  staintex: ", ftos(particle_staintex), "\n"));
	print(strcat("  stainalpha: ", ftos(particle_stainalpha), "\n"));
	print(strcat("  stainsize: ", ftos(particle_stainsize), "\n"));
	print(strcat("  delayspawn: ", ftos(particle_delayspawn), "\n"));
	print(strcat("  delaycollision: ", ftos(particle_delaycollision), "\n"));
	print(strcat("  angle: ", ftos(particle_angle), "\n"));
	print(strcat("  spin: ", ftos(particle_spin), "\n"));
}*/

// DP_CSQC_ENTITYTRANSPARENTSORTING_OFFSET
// idea: VorteX
// darkplaces implementation: VorteX
float RF_USETRANSPARENTOFFSET = 64; // enables transparent origin offsetting
// global definitions
float transparent_offset; // should be set before entity is added
// description: offset a model's meshes origin used for transparent sorting. Could be used to tweak sorting bugs on very large transparent entities or hacking transparent sorting order for certain objects
// example: transparent_offset = 1000000; // entity always appear on background of other transparents
// note: offset is done in view forward axis

// DP_CSQC_ENTITYNOCULL
// idea: VorteX
// darkplaces implementation: VorteX
const float RF_NOCULL = 128;
// description: when renderflag is set, engine will not use culling methods for this entity, e.g. it will always be drawn
// useful for large outdoor objects (like asteriods on sky horizont or sky models)
// also useful when culling is done at CSQC side

// DP_CSQC_SETPAUSE
// idea: VorteX
// darkplaces implementation: VorteX
// builtin definitions:
void(float ispaused) setpause = #531;
// description: provides ability to set pause in local games (similar to one set once console is activated)
// not stopping sound/cd track, useful for inventory screens, ingame menus with input etc.

// DP_CSQC_QUERYRENDERENTITY
// idea: VorteX
// darkplaces implementation: VorteX
// constant definitions:
// render entity fields:
float E_ACTIVE 	    = 0; // float 0/1
float E_ORIGIN      = 1; // vector
float E_FORWARD     = 2; // vector
float E_RIGHT       = 3; // vector
float E_UP          = 4; // vector
float E_SCALE       = 5; // float
float E_ORIGINANDVECTORS = 6; // returns origin, + sets v_* vectors to orientation
float E_ALPHA       = 7; // float
float E_COLORMOD    = 8; // vector
float E_PANTSCOLOR  = 9; // vector
float E_SHIRTCOLOR  = 10; // vector
float E_SKIN        = 11; // float
float E_MINS        = 12; // vector
float E_MAXS        = 13; // vector
float E_ABSMIN      = 14; // vector
float E_ABSMAX      = 15; // vector
float E_LIGHT       = 16; // vector - modellight
// builtin definitions:
float(float entitynum, float fldnum) getentity = #504;
vector(float entitynum, float fldnum) getentityvec = #504;
// description: allows to query parms from render entities, especially useful with attaching CSQC ents to
// server entities networked and interpolated by engine (monsters, players), number of entity is it's SVQC number
// you can send it via tempentity/CSQC entity message. Note that this builtin doesnt know about entity removing/reallocating
// so it's meaning to work for short period of time, dont use it on missiles/grenades whatever will be removed next five seconds
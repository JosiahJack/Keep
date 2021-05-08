// edict.movetype values
float	MOVETYPE_NONE			= 0;	// never moves
//float	MOVETYPE_ANGLENOCLIP	= 1;
//float	MOVETYPE_ANGLECLIP		= 2;
float	MOVETYPE_WALK			= 3;	// players only
float	MOVETYPE_STEP			= 4;	// discrete, not real time unless fall
float	MOVETYPE_FLY			= 5;
float	MOVETYPE_TOSS			= 6;	// gravity
float	MOVETYPE_PUSH			= 7;	// no clip to world, push and crush
float	MOVETYPE_NOCLIP			= 8;
float	MOVETYPE_FLYMISSILE		= 9;	// fly with extra size against monsters
float	MOVETYPE_BOUNCE			= 10;
float	MOVETYPE_BOUNCEMISSILE	= 11;	// bounce with extra size



var float autocvar_casingejectpos;
var float autocvar_weapon_position_right;
var float autocvar_weapon_position_fully_adjustable;
var float autocvar_weapon_position_adjustable_projectile_casing_offset;
var float autocvar_casingdropsound;
var float autocvar_casinglifetime;

 .vector		view_ofs;
 
void() SUB_Null = {};
 float	FL_ONGROUND				= 512;
 
 .float gravity;
 .float cansplash;
 
  float(vector v) pointcontents		= #41;
  
  float	CONTENT_SOLID			= -2;
  
  .vector velocity_old;
  
  
//Handler for client-side shell casing model
.float casetype;

float CASING_SHELL = 1;
float CASING_NAIL = 2;
float CASING_ROCKET = 3;

var float autocvar_gibsduration;
//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by W. Josiah Jack, aka Qmaster
//
// Attributions: Matthew "Quake Matt" Lawrence
//
//
// Distribution / Copyright / Permissions 
//
// Please do not use any of these assets in ANY COMMERCIAL PROJECT.
// and remember to give credit if you use any of these assets. Please credit
// the appropriate authors of the various content used.  Refer to the credits
// folder.
//				  
// The QC files in this MOD are based on 1.06 source files by ID Software.
// These files are released under the terms of GNU General Public License v2 or
// later. You may use the source files as a base to build your own MODs as long
// as you release them under the same license and make the source available.
// Please also give proper credit. Check http://www.gnu.org for details.
//
// Quake is a registered trademark of id Software, Inc.
//
// All of these resources may be electronically distributed only at 
// NO CHARGE to the recipient.
//
// Stats:
// Entity count: 0
// Function count: 8
// Builtin Function count: 3
//
// Implements: Gyro Physics System main routines
//
// Description:
// Implements the physics starter functions for enabling Gyro physics on an
// entity.  Gyro physics is a library of specialty forces to apply to any
// entity.  Such forces include buoyancy, turbulence, air resistance, rotating
// to orient with velocity direction, etc.
//
// Matt's Gyro Notepad
// ----- Todo List --------------------
// Seriously reconsider the turbulence subsystem
// Optimise the loop-rounds for the aerodynamics subsystem
//
// ----- Coding Concerns --------------------
// My power estimation function really needs further testing
// Quadratic falloff is not mathematically accurate
// Should forces use classname, or do they need a new gyro_force_name field?
// What happens if a force is made into a physics object?
// What happens if a force or object is created during Gyro's execution? (from the feedback function)
// Falloff combiners haven't been tested fully (other than multiply)
// Should I combine global and object turbulence into one subsystem?

// Qmaster Updates:
// removed unneeded debug checks in lieu of dprint requiring developer 1
// replaced bprint with dprint
// simplified initialization bits
// used global engine check rather than have duplicate and possible inconsistency
// removed a lot of horrible whitespace
// changed \" instances to single quote '
// removed some prints that weren't called ever
//
// Added buoyancy to gibs by default.
// Added slight resistance in liquids to grenade projectiles.
//=============================================================================

void(entity ent) Burn_Null;

//===== User Tweakable Parameters ====================
//----- Natural Bouyancy Settings --------------------
float	GYRO_BOUYANCYMOD_AIR = 0.0;
float	GYRO_BOUYANCYMOD_WATER = 1.0;
float	GYRO_BOUYANCYMOD_SLIME = 1.2;
float	GYRO_BOUYANCYMOD_LAVA = 1.4;

//----- Natural Resistance Settings --------------------
float	GYRO_RESISTANCEMOD_AIR = 0.1;
float	GYRO_RESISTANCEMOD_WATER = 1.0;
float	GYRO_RESISTANCEMOD_SLIME = 1.2;
float	GYRO_RESISTANCEMOD_LAVA = 1.4;

//----- Natural Turbulence Settings --------------------
float	GYRO_TURBULENCEMOD_AIR = 0.1;
float	GYRO_TURBULENCEMOD_WATER = 1.0;
float	GYRO_TURBULENCEMOD_SLIME = 1.2;
float	GYRO_TURBULENCEMOD_LAVA = 1.4;

//----- Core Non-Constant Settings --------------------
float	GYRO_TICKRATE = 0.03;
float	GYRO_POWERCONSTANT = 800;

//----- Force Channels --------------------
float	GYRO_CHANNEL_DEFAULT	= 1;
float	GYRO_CHANNEL_EXPLOSION	= 2;
float	GYRO_CHANNEL_METAL		= 4;
float	GYRO_CHANNEL_ORGANIC	= 8;
float	GYRO_CHANNEL_MAGIC		= 16;

//===== Variable and Function Declaration ====================
//----- Global Variable Declarations --------------------
float	gyro_runtimer;
float	gyro_framegrav;
float	gyro_framemaxvel;
float	gyro_framemaxvelneg;
float	gyro_displayintro;

//----- Entity Motion Effectors --------------------
.vector	gyro_velocityeffect;
.vector	gyro_avelocityeffect;
.vector	gyro_dampeningeffect;
.vector	gyro_adampeningeffect;
.float	gyro_antigravityeffect;

//----- General Function Protoypes --------------------
void() Gyro_RunPhysics;
void() Gyro_RunForces;
void(entity targ) AddToTotals;
void(entity thekilled, entity attacker) AddToKills;
void(entity e) FliquidList_Remove;

//===== Physics Object Variables ====================
//----- Mass and Bouyancy --------------------
.float	gyro_object_mass;
.float	gyro_object_bouyancy_air;
.float	gyro_object_bouyancy_water;
.float	gyro_object_bouyancy_slime;
.float	gyro_object_bouyancy_lava;

//----- Air and Water Resistance --------------------
.float	gyro_object_resistance_air;
.float	gyro_object_resistance_water;
.float	gyro_object_resistance_slime;
.float	gyro_object_resistance_lava;

//----- Hover Tap Level and Strength --------------------
.float	gyro_object_hover_tap;
.float	gyro_object_hover_dist;
.float	gyro_object_hover_power;

//----- Object-Level Turbulence --------------------
.float	gyro_object_angleturb;
.float	gyro_object_turbulence_air;
.float	gyro_object_turbulence_water;
.float	gyro_object_turbulence_slime;
.float	gyro_object_turbulence_lava;
.float	gyro_object_turbulence_smooth;
.vector	gyro_object_turbulence_velocity;

//----- Global-Level Turbulence --------------------
vector	gyro_globalturbulence;
.float	gyro_object_globalturb_air;
.float	gyro_object_globalturb_water;
.float	gyro_object_globalturb_slime;
.float	gyro_object_globalturb_lava;
.float	gyro_object_globalturb_smooth;
.vector	gyro_object_globalturb_velocity;

//----- Misc Physics Subsystems --------------------
.float	gyro_object_pointcontent;
.float	gyro_object_aerodynamics;
.float	gyro_object_thrust;

//----- Mixed Physics Object Flags --------------------
.float	gyro_object_channels;
.float	gyro_object_flags;
float	GYRO_OBJECTFLAG_FLOATING		= 1;
float	GYRO_OBJECTFLAG_BOUYANCY		= 2;
float	GYRO_OBJECTFLAG_RESISTANCE	= 4;
float	GYRO_OBJECTFLAG_TURBULENCE	= 8;
float	GYRO_OBJECTFLAG_GLOBALTURB	= 16;

//----- Object Feedback System --------------------
string	gyro_feedback_name;
float	gyro_feedback_power;
float	gyro_feedback_channels;
.void()	gyro_feedback;

//===== Force Entity Variables =============================
//----- General Force-Related Variables --------------------
.entity	gyro_force_ignore;
.entity	gyro_force_attach;
.float	gyro_force_update;
.float	gyro_force_channels;
.vector	gyro_force_bounds;
.vector	gyro_force_boundsmin;
.vector	gyro_force_boundsmax;

//----- Force Scale and Decay Variables --------------------
.float	gyro_force_rangescale;
.float	gyro_force_rangescalerate;
.float	gyro_force_powerscale;
.float	gyro_force_powerscalerate;

//----- Mixed Force Entity Flags and Properties --------------------
.float	gyro_force_flags;
float	GYRO_FORCEFLAG_INSTANT		= 1;
float	GYRO_FORCEFLAG_IGNOREWALLS	= 2;
float	GYRO_FORCEFLAG_AIRONLY		= 4;
float	GYRO_FORCEFLAG_WATERONLY		= 8;
float	GYRO_FORCEFLAG_GROUNDPOUND	= 16;
float	GYRO_FORCEFLAG_PERSISTENT		= 32;

//----- Force Falloff Settings --------------------
.float	gyro_force_falloff_combine;
.float	gyro_force_falloff1_type;
.float	gyro_force_falloff1_rad1;
.float	gyro_force_falloff1_rad2;
.vector	gyro_force_falloff1_axis;
.float	gyro_force_falloff2_type;
.float	gyro_force_falloff2_rad1;
.float	gyro_force_falloff2_rad2;
.vector	gyro_force_falloff2_axis;
.float	gyro_force_falloff3_type;
.float	gyro_force_falloff3_rad1;
.float	gyro_force_falloff3_rad2;
.vector	gyro_force_falloff3_axis;
.float	gyro_force_falloff4_type;
.float	gyro_force_falloff4_rad1;
.float	gyro_force_falloff4_rad2;
.vector	gyro_force_falloff4_axis;

//----- Falloff Types and Flags --------------------
float	GYRO_FALLOFF_TYPE_NONE		= 0;
float	GYRO_FALLOFF_TYPE_AREA		= 1;
float	GYRO_FALLOFF_TYPE_CONE		= 2;
float	GYRO_FALLOFF_METHOD_LINEAR	= 32;
float	GYRO_FALLOFF_METHOD_QUADRATIC	= 64;
float	GYRO_FALLOFF_METHOD_CONSTANT	= 128;

//----- Falloff Combination Methods --------------------
float	GYRO_FALLOFF_COMBINE_MULTIPLY	= 0;
float	GYRO_FALLOFF_COMBINE_MINIMUM	= 1;
float	GYRO_FALLOFF_COMBINE_SUBTRACT	= 2;

//----- Force Affector Settings --------------------
.float	gyro_force_affector1_type;
.float	gyro_force_affector1_power;
.float	gyro_force_affector1_absolute;
.vector	gyro_force_affector1_offset;
.vector	gyro_force_affector1_axis;
.vector	gyro_force_affector1_modx;
.vector	gyro_force_affector1_mody;
.vector	gyro_force_affector1_modz;
.float	gyro_force_affector2_type;
.float	gyro_force_affector2_power;
.float	gyro_force_affector2_absolute;
.vector	gyro_force_affector2_offset;
.vector	gyro_force_affector2_axis;
.vector	gyro_force_affector2_modx;
.vector	gyro_force_affector2_mody;
.vector	gyro_force_affector2_modz;
.float	gyro_force_affector3_type;
.float	gyro_force_affector3_power;
.float	gyro_force_affector3_absolute;
.vector	gyro_force_affector3_offset;
.vector	gyro_force_affector3_axis;
.vector	gyro_force_affector3_modx;
.vector	gyro_force_affector3_mody;
.vector	gyro_force_affector3_modz;
.float	gyro_force_affector4_type;
.float	gyro_force_affector4_power;
.float	gyro_force_affector4_absolute;
.vector	gyro_force_affector4_offset;
.vector	gyro_force_affector4_axis;
.vector	gyro_force_affector4_modx;
.vector	gyro_force_affector4_mody;
.vector	gyro_force_affector4_modz;

//----- Affector Types --------------------
float	GYRO_AFFECTOR_NONE		= 0;
float	GYRO_AFFECTOR_POINT		= 1;
float	GYRO_AFFECTOR_POINTMOD	= 2;
float	GYRO_AFFECTOR_DIRECTIONAL	= 3;
float	GYRO_AFFECTOR_ANTIGRAVITY	= 4;
float	GYRO_AFFECTOR_RESISTANCE	= 5;

float MAX_GYRO_OBJECTS = 256; // Added by Qmaster to mitigate large maps and to
							  // prevent runaway loop errors as gibs and such
							  // accumulate.

//===== Object Linked-List Control ====================
//----- List Variable Declarations --------------------
float	gyro_objectlist_size;
entity	gyro_objectlist_head;
.entity	gyro_objectlist_next;
.entity	gyro_objectlist_prev;
.float	gyro_objectlist_inlist;

//===== Force Linked-List Control ====================
//----- List Variable Declarations --------------------
float	gyro_forcelist_size;
entity	gyro_forcelist_head;
.entity	gyro_forcelist_next;
.entity	gyro_forcelist_prev;
.float	gyro_forcelist_inlist;

//----- Adding to the Physics Object List --------------------
void(entity e) Gyro_ObjectList_Add = { // [FUNCTION]
	if (e.gyro_objectlist_inlist) return;

	e.gyro_objectlist_inlist = TRUE;
	e.gyro_objectlist_next = gyro_objectlist_head;
	if (gyro_objectlist_head) gyro_objectlist_head.gyro_objectlist_prev = e;
	gyro_objectlist_head = e;
	gyro_objectlist_size = gyro_objectlist_size + 1;
};

//----- Removing from the Physics Object List --------------------
void(entity e) Gyro_ObjectList_Remove = { // [FUNCTION]
	if (!e.gyro_objectlist_inlist) return;

	if (e.gyro_objectlist_prev)	e.gyro_objectlist_prev.gyro_objectlist_next = e.gyro_objectlist_next;
	else						gyro_objectlist_head = e.gyro_objectlist_next;

	if (e.gyro_objectlist_next) e.gyro_objectlist_next.gyro_objectlist_prev = e.gyro_objectlist_prev;
	e.gyro_objectlist_inlist = FALSE;
	e.gyro_objectlist_next = world;
	e.gyro_objectlist_prev = world;
	gyro_objectlist_size = gyro_objectlist_size - 1;
};

//----- Adding to the Physics Object List --------------------
void(entity e) Gyro_ForceList_Add = { // [FUNCTION]
	if (e.gyro_forcelist_inlist) return;

	e.gyro_forcelist_inlist = TRUE;
	e.gyro_forcelist_next = gyro_forcelist_head;
	if (gyro_forcelist_head) gyro_forcelist_head.gyro_forcelist_prev = e;
	gyro_forcelist_head = e;
	gyro_forcelist_size = gyro_forcelist_size + 1;
};

//----- Removing from the Physics Object List --------------------
void(entity e) Gyro_ForceList_Remove = { // [FUNCTION]
	if (!e.gyro_forcelist_inlist)
		return;
	if (e.gyro_forcelist_prev)	e.gyro_forcelist_prev.gyro_forcelist_next = e.gyro_forcelist_next;
	else						gyro_forcelist_head = e.gyro_forcelist_next;

	if (e.gyro_forcelist_next) e.gyro_forcelist_next.gyro_forcelist_prev = e.gyro_forcelist_prev;
	e.gyro_forcelist_inlist = FALSE;
	e.gyro_forcelist_next = world;
	e.gyro_forcelist_prev = world;
	gyro_forcelist_size = gyro_forcelist_size - 1;
};

//===== Gyro Utility Functions ====================
//----- Perform a Power Estimation --------------------
float(string s) Gyro_CheckExtension = #99; // [FUNCTION]
float(float x, float y) Gyro_PowerAccurate = #97; // [FUNCTION]
float(float x, float y) Gyro_PowerEstimation = { // [FUNCTION]
	local float	z;

	if (ext_active) return Gyro_PowerAccurate(x, y);

	z = 1 - x;
	z = (z * z) + z;
	z = 1.0 / ((y * z) + 1.0);
	return z;
};

//----- Safe 'Remove' Function Replacement --------------------
void(entity e) Gyro_RemoveEntity	= #15; // [FUNCTION]
void(entity e) remove = { // [FUNCTION]
	if (!e) return;
	if (e == world) return;
	if (e.flags & FL_CLIENT) return;

	// Check for activate mosnters? Tidy up kill counter
	if (e.flags & FL_MONSTER && e.health > 0) { 
		if (e.nomonstercount) AddToTotals(e); // If a monster marked with no monster count dies update HUD totals to reflect death properly
		AddToKills(e,activator);
	}
	Burn_Null(e);
	e.targetname = "";
	if (e.use) e.use = SUB_Null;
	Gyro_ObjectList_Remove(e);
	Gyro_ForceList_Remove(e);
	FliquidList_Remove(e);
	Gyro_RemoveEntity(e); // The actual remove = #15; remove()
	totaledicts = totaledicts - 1;
	if (totaledicts < 2) totaledicts = 2; // Always world and player.
};

//===== Primary Control Routines ====================
//----- Initialise Variables: Called only on the First Frame in world.qc --------------------
void() Gyro_InitialiseVariables = {	// [FUNCTION]
	//----- Prepare Internal Settings --------------------
	gyro_runtimer = 0;
	gyro_displayintro = TRUE;
};

//----- Main Gyro Loop: Called every Frame --------------------
void() Gyro_Run = { // [FUNCTION]
	gyro_runtimer = time - (GYRO_TICKRATE * 0.5);
	while (gyro_runtimer < time) { // Iterate at a Fixed Rate
		gyro_runtimer = gyro_runtimer + GYRO_TICKRATE; // Control Gyro Timer System
		gyro_framegrav = cvar("sv_gravity"); // Set Per-Frame Globals
		gyro_framemaxvel = cvar("sv_maxvelocity");
		gyro_framemaxvelneg = 0.0 - gyro_framemaxvel;
		Gyro_RunForces();
		Gyro_RunPhysics();
		if (gyro_displayintro) {
			if ((time > 1.6) && (time < 2.4)) {
				dprint("Gyro 2.1a (April 2007) by Matt is running...updated to 2.2a (April 2021) by Qmaster\nTickrate (ms): ");
				dprint(ftos(GYRO_TICKRATE * 1000));
				dprint("\n");
				gyro_displayintro = FALSE;
			}
		}
	}
};
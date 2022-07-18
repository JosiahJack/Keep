//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
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
// Function count: 38
//
// Implements: Gyro Physics Systems API functions
//
// Description:
// Functions for adding specific forces, activating, and deactivating physics
// on specific entities.
//=============================================================================

void(entity targ, float fl) SUB_RemoveFlags;
float(vector spot) GetContents;

//----- Activate a Physics Object --------------------
void(entity e, float mass) Gyro_Object_Activate = {
	local float	reactive;

	if (!e) return;

	if (mass == 0) mass = 1; // give it SOMETHING

	//----- Prepare Object for Physics Operations --------------------
	Gyro_ObjectList_Add(e);
	if (e.gyro_object_mass == 0) {
		e.gyro_object_mass = mass;
		e.gyro_object_channels = 1;
		reactive = FALSE;
	} else {
		reactive = TRUE;
	}
	
	//----- Zero or Below Mass is not Allowed --------------------
	// if (e.gyro_object_mass <= 0.0) {
		// dprint("Gyro Warning: Entity physics not activated for '");
		// dprint(e.classname);
		// dprint("'\nMass cannot be set to zero or below\n");
	// }
	
	//----- Zero-Set Motion Effects --------------------
	e.gyro_velocityeffect = '0.0 0.0 0.0';
	e.gyro_avelocityeffect = '0.0 0.0 0.0';
	e.gyro_dampeningeffect = '1.0 1.0 1.0';
	e.gyro_adampeningeffect = '1.0 1.0 1.0';
	e.gyro_antigravityeffect = 0.0;
	
	//----- Print Debugging Information --------------------
	// dprint("Gyro Debug: Entity physics activated for '");
	// dprint(e.classname);
	// dprint("'\nMass: ");
	// dprint(ftos(e.gyro_object_mass));
	// if (reactive == TRUE) dprint(", inactive settings have been restored");
	// dprint("\n");
};

//----- Deactivate a Physics Object --------------------
void(entity e) Gyro_Object_Deactivate = {
	if (!e) return;

	//----- Remove Entity from Physics List --------------------
	Gyro_ObjectList_Remove(e);
	
	//----- Print Debugging Information --------------------
	dprint("Gyro Debug: Entity physics deactivated for '");
	dprint(e.classname);
	dprint("'\nPhysics settings preserved but inactive\n");
};

//----- Remove All Physics Propeties from an Object --------------------
void(entity e) Gyro_Object_ClearPhysics = {
	if (!e) return;

	//----- Strip Physics Settings and Remove from Physics List --------------------
	e.gyro_object_mass = 0.0;
	e.gyro_object_bouyancy_air = 0.0;
	e.gyro_object_bouyancy_water = 0.0;
	e.gyro_object_bouyancy_slime = 0.0;
	e.gyro_object_bouyancy_lava = 0.0;
	
	e.gyro_object_resistance_air = 1.0;
	e.gyro_object_resistance_water = 1.0;
	e.gyro_object_resistance_slime = 1.0;
	e.gyro_object_resistance_lava = 1.0;
	
	e.gyro_object_turbulence_air = 0.0;
	e.gyro_object_turbulence_water = 0.0;
	e.gyro_object_turbulence_slime = 0.0;
	e.gyro_object_turbulence_lava = 0.0;
	e.gyro_object_turbulence_smooth = 0.0;
	e.gyro_object_turbulence_velocity = '0 0 0';
	
	e.gyro_object_globalturb_air = 0.0;
	e.gyro_object_globalturb_water = 0.0;
	e.gyro_object_globalturb_slime = 0.0;
	e.gyro_object_globalturb_lava = 0.0;
	e.gyro_object_globalturb_smooth = 0.0;
	e.gyro_object_globalturb_velocity = '0 0 0';
	
	e.gyro_object_hover_tap = 0;
	e.gyro_object_hover_dist = 0.0;
	e.gyro_object_hover_power = 0.0;
	
	e.gyro_object_aerodynamics = 0.0;
	e.gyro_object_angleturb = 0.0;
	e.gyro_object_thrust = 0.0;
	e.gyro_object_flags = 0;
	
	e.gyro_feedback = SUB_Null;
	Gyro_ObjectList_Remove(e);
	
	//----- Print Debugging Information --------------------
	dprint("Gyro Debug: Entity physics cleared for '");
	dprint(e.classname);
	dprint("'\nAll physics settings removed\n");
};

//===== Object Force-Channels and Feedback ===================
//----- Set an Object's Force Channels --------------------
void(entity e, float channels) Gyro_Object_SetChannels = {
	if (!e) return;

	e.gyro_object_channels = channels;
};

//----- Add Channels to an Object --------------------
void(entity e, float channels) Gyro_Object_AddChannels = { e.gyro_object_channels = e.gyro_object_channels | channels; };

//----- Remove Channels from an Object --------------------
void(entity e, float channels) Gyro_Object_RemoveChannels = { e.gyro_object_channels = e.gyro_object_channels - (e.gyro_object_channels & channels); };

//----- Call an Object's Feedback Function --------------------
void(entity e) Gyro_Object_CallFeedback = {
	local entity oldself;

	if (!e) return;

	if (e.gyro_feedback) {
		oldself = self;
		self = e;
		self.gyro_feedback();
		self = oldself;
	}
};

//===== Bouyancy and Floatation Subsystem ====================
//----- Per-Frame Bouyancy Loop --------------------
void(entity e) Gyro_RunPhysics_Bouyancy = {
	local float	org_content, bouypower, inwater, top_bouyancy;

	if (!(e.gyro_object_flags & GYRO_OBJECTFLAG_BOUYANCY)) return;
	
	//----- Get Motion Values for Current Pointcontents --------------------
	org_content = e.gyro_object_pointcontent;
	if (org_content == -3) {
		bouypower = e.gyro_object_bouyancy_water;
		inwater = TRUE;
	} else if (org_content == -4) {
		bouypower = e.gyro_object_bouyancy_slime;
		inwater = TRUE;
	} else if (org_content == -5) {
		bouypower = e.gyro_object_bouyancy_lava;
		inwater = TRUE;
	} else {
		bouypower = e.gyro_object_bouyancy_air;
	}

	//----- Reset Object Floating on Surface Flag --------------------
	e.gyro_object_flags = e.gyro_object_flags - (e.gyro_object_flags & GYRO_OBJECTFLAG_FLOATING);
	
	//----- Check Z-Position for Surface Floating --------------------
	if ((e.gyro_velocityeffect_z < 60.0) && (e.gyro_velocityeffect_z > -60.0)) {
		local float top_content;
		top_content = pointcontents(e.origin + '0.0 0.0 2.4');
		if (top_content != org_content) {
			//----- Get Bouyancy Strength of Top Content --------------------
			if (top_content == -3) top_bouyancy = e.gyro_object_bouyancy_water;
			else if (top_content == -4) top_bouyancy = e.gyro_object_bouyancy_slime;
			else if (top_content == -5) top_bouyancy = e.gyro_object_bouyancy_lava;
			else top_bouyancy = e.gyro_object_bouyancy_air;
			
			//----- Get Bouyancy Strength of Middle Content --------------------
			local float	mid_bouyancy, mid_content;
			mid_content = pointcontents(e.origin + '0.0 0.0 1.2');
			if (mid_content == top_content) mid_bouyancy = top_bouyancy;
			else mid_bouyancy = bouypower;
			
			//----- Set Bouyancy and Resistance to Keep Object Afloat --------------------
			bouypower = (bouypower + top_bouyancy + mid_bouyancy) / 3.0;
			e.gyro_dampeningeffect_z = e.gyro_dampeningeffect_z * Gyro_PowerEstimation(0.2, GYRO_TICKRATE);
			e.gyro_object_flags = e.gyro_object_flags | GYRO_OBJECTFLAG_FLOATING;
		}
	}
	
	//----- Call Gyro Feedback Function --------------------
	if (e.gyro_feedback) {
		if (inwater) {
			//----- Set Feedback Variables --------------------
			gyro_feedback_channels = 0;
			gyro_feedback_power = bouypower * e.gyro_object_mass;
			if (org_content == -3)		gyro_feedback_name = "water";
			else if (org_content == -4)	gyro_feedback_name = "slime";
			else if (org_content == -5)	gyro_feedback_name = "lava";
			
			//----- Call Feedback Function --------------------
			Gyro_Object_CallFeedback(e);
		}
	}
	
	//----- Add Bouyancy to Velocity Buffer --------------------
	e.gyro_velocityeffect_z = e.gyro_velocityeffect_z + (bouypower * gyro_framegrav * GYRO_TICKRATE);
};

//----- Deactivate Bouyancy on Entity e --------------------
void(entity e) Gyro_Object_RemoveBouyancy = {
	//----- Remove Bouyancy from Object --------------------
	e.gyro_object_bouyancy_air = 0.0;
	e.gyro_object_bouyancy_water = 0.0;
	e.gyro_object_bouyancy_slime = 0.0;
	e.gyro_object_bouyancy_lava = 0.0;
	e.gyro_object_flags = e.gyro_object_flags - (e.gyro_object_flags & GYRO_OBJECTFLAG_BOUYANCY);
	
	//----- Print Debugging Information --------------------
	dprint("Gyro Debug: Entity bouyancy removed from '");
	dprint(e.classname);
	dprint("'\n");
};

//----- Give an Entity Bouyancy in Air, Water, Slime and Lava --------------------
void(entity e, float bouyforce, float mod_air, float mod_water, float mod_slime, float mod_lava) Gyro_Object_SetBouyancyMod = {
	local float	bouypower;

	//----- No Bouyancy: Call Deactivation Macro --------------------
	if (bouyforce == 0) return Gyro_Object_RemoveBouyancy(e);

	
	//----- Calculate Basic Bouyancy Power --------------------
	bouypower = bouyforce / e.gyro_object_mass;
	
	//----- Apply All Bouyancy Settings to Object --------------------
	e.gyro_object_bouyancy_air = bouypower * mod_air;
	e.gyro_object_bouyancy_water = bouypower * mod_water;
	e.gyro_object_bouyancy_slime = bouypower * mod_slime;
	e.gyro_object_bouyancy_lava = bouypower * mod_lava;
	e.gyro_object_flags = e.gyro_object_flags | GYRO_OBJECTFLAG_BOUYANCY;
	
	//----- Print Debugging Information --------------------
	// dprint("Gyro Debug: Entity bouyancy activated for '");
	// dprint(e.classname);
	// dprint("'\nMass: ");
	// dprint(ftos(e.gyro_object_mass));
	// dprint(", Bouyancy: ");
	// dprint(ftos(bouyforce));
	// dprint("\n");
};

//----- Give an Object Bouyancy with Global Modifiers --------------------
void(entity e, float bouyforce) Gyro_Object_SetBouyancy = {
	Gyro_Object_SetBouyancyMod(e, bouyforce, GYRO_BOUYANCYMOD_AIR, GYRO_BOUYANCYMOD_WATER, GYRO_BOUYANCYMOD_SLIME, GYRO_BOUYANCYMOD_LAVA);
};

//===== Motion Resistance Subsystem ====================
//----- Run Air and Water Resistance on Entity e --------------------
void(entity e) Gyro_RunPhysics_Resistance = {
	local float	resistpower;

	//----- Early Exit Conditions --------------------
	if (!(e.gyro_object_flags & GYRO_OBJECTFLAG_RESISTANCE)) return;
	
	//----- Get Motion Values for Current Pointcontents --------------------
	if (e.gyro_object_pointcontent == CONTENT_WATER)		resistpower = e.gyro_object_resistance_water;
	else if (e.gyro_object_pointcontent == CONTENT_SLIME)	resistpower = e.gyro_object_resistance_slime;
	else if (e.gyro_object_pointcontent == CONTENT_LAVA)	resistpower = e.gyro_object_resistance_lava;
	else resistpower = e.gyro_object_resistance_air;
	
	//----- Apply Resistance Values to Effect Buffers --------------------
	resistpower = Gyro_PowerEstimation(resistpower, GYRO_TICKRATE);
	e.gyro_dampeningeffect = e.gyro_dampeningeffect * resistpower;
	e.gyro_adampeningeffect = e.gyro_adampeningeffect * resistpower;
};

//----- Deactivate Motion Resistance on Entity e --------------------
void(entity e) Gyro_Object_RemoveResistance = {
	//----- Set to Zero Resistance Effect --------------------
	e.gyro_object_resistance_air = 1.0;
	e.gyro_object_resistance_water = 1.0;
	e.gyro_object_resistance_slime = 1.0;
	e.gyro_object_resistance_lava = 1.0;
	e.gyro_object_flags = e.gyro_object_flags - (e.gyro_object_flags & GYRO_OBJECTFLAG_RESISTANCE);
	
	//----- Print Debugging Information --------------------
	//dprint("Gyro Debug: Entity motion resistance removed from '");
	//dprint(e.classname);
	//dprint("'\n");
};

//----- Apply Motion Resistance Settings to an Object --------------------
void(entity e, float resforce, float mod_air, float mod_water, float mod_slime, float mod_lava) Gyro_Object_SetResistanceMod = {
	if (!e) return;
	//----- Zero Resistance: Run Deactivation Function --------------------
	if (resforce == 0) return Gyro_Object_RemoveResistance(e);
	
	//----- Set Motion Resistance for All Environments --------------------
	if (mod_air > 0) e.gyro_object_resistance_air = 1.0 / (((resforce * mod_air * 10.0) / e.gyro_object_mass) + 1.0);
	dprint("SetResistanceMod made it to here\n");
	dprint("air restistance was "); dprint(ftos(resforce)); dprint(", "); dprint(ftos(mod_air));
	dprint("\n");
	if (mod_water > 0) e.gyro_object_resistance_water = 1.0 / (((resforce * mod_water * 10.0) / e.gyro_object_mass) + 1.0);
	if (mod_slime > 0) e.gyro_object_resistance_slime = 1.0 / (((resforce * mod_slime * 10.0) / e.gyro_object_mass) + 1.0);
	if (mod_lava > 0) e.gyro_object_resistance_lava = 1.0 / (((resforce * mod_lava * 10.0) / e.gyro_object_mass) + 1.0);
	if (mod_air > 0 || mod_water > 0 || mod_slime > 0 || mod_lava > 0) e.gyro_object_flags = e.gyro_object_flags | GYRO_OBJECTFLAG_RESISTANCE;
	
	//----- Print Debugging Information --------------------
	// dprint("Gyro Debug: Entity motion resistance activated for '");
	// dprint(e.classname);
	// dprint("'\nMass: ");
	// dprint(ftos(e.gyro_object_mass));
	// dprint(", Resistance: ");
	// dprint(ftos(resforce));
	// dprint("\n");
};

//----- Give an Object Globally-Defined Motion Resistance --------------------
void(entity e, float resforce) Gyro_Object_SetResistance = {
	if (!e) return;

	Gyro_Object_SetResistanceMod(e, resforce, GYRO_RESISTANCEMOD_AIR,
								 GYRO_RESISTANCEMOD_WATER,
								 GYRO_RESISTANCEMOD_SLIME,
								 GYRO_RESISTANCEMOD_LAVA);
};
void(entity e, float resforce) Gyro_Object_SetLiquidResistance = {
	if (!e) return;

	Gyro_Object_SetResistanceMod(newmis,resforce,0, // No air resistance.
								 GYRO_RESISTANCEMOD_WATER,
								 GYRO_RESISTANCEMOD_SLIME,
								 GYRO_RESISTANCEMOD_LAVA); 
}

// Seperated this out as its own function for reuse by the rope system. -Qmaster
vector(vector moveangle, vector angles) Gyro_Aerodynamics_Turnangle = {
	local vector turnangle;

	turnangle = moveangle - angles;
	while (turnangle_x > 180.0) turnangle_x = turnangle_x - 360.0;
	while (turnangle_x < -180.0) turnangle_x = turnangle_x + 360.0;
	while (turnangle_y > 180.0) turnangle_y = turnangle_y - 360.0;
	while (turnangle_y < -180.0) turnangle_y = turnangle_y + 360.0;
	while (turnangle_z > 180.0) turnangle_z = turnangle_z - 360.0;
	while (turnangle_z < -180.0) turnangle_z = turnangle_z + 360.0;
	return turnangle;
};

//===== Aerodynamics Subsystem ====================
//----- Per-Frame Aerodynamic Rotation --------------------
void(entity e) Gyro_RunPhysics_Aerodynamics = {
	local float	movespeed, aeropower, avelmult, adampmult;
	local vector turnangle, moveangle;

	if (e.gyro_object_aerodynamics == 0) return;
	if (e.velocity == '0 0 0') return;
	
	//----- Calculate Object Movement Angle/Velocity --------------------
	movespeed = vlen(e.velocity);
	if (e.gyro_object_aerodynamics > 0) {
		aeropower = e.gyro_object_aerodynamics * 0.01;
		moveangle = vectoangles(e.velocity);
	} else {
		aeropower = e.gyro_object_aerodynamics * (-0.01);
		moveangle = vectoangles('0 0 0' - e.velocity);
	}
	
	//----- Alter Movement Propeties for Surface Floating  --------------------
	if (e.gyro_object_flags & GYRO_OBJECTFLAG_FLOATING) {
		moveangle_x = 0.0;
		movespeed = movespeed + 200;
	}
	
	//----- Aerodynamic Multipliers for AVelocity and ADampening --------------------
	avelmult = movespeed * aeropower;
	adampmult = 1.0 / ((movespeed * aeropower * 0.2) + 1.0);
	
	//----- Subtract Actual Angles from Movement Angles --------------------
	turnangle = Gyro_Aerodynamics_Turnangle(moveangle,e.angles);
	
	//----- Compute and Set Angular Velocity --------------------
	e.gyro_avelocityeffect = e.gyro_avelocityeffect + (turnangle * avelmult * GYRO_TICKRATE);
	e.gyro_adampeningeffect = e.gyro_adampeningeffect * Gyro_PowerEstimation(adampmult, GYRO_TICKRATE);
};

//----- Deactivate Aerodynamics on Entity e --------------------
void(entity e) Gyro_Object_RemoveAerodynamics = {
	e.gyro_object_aerodynamics = 0.0; // Remove Aerodynamics from Object
	
	//----- Print Debugging Information --------------------
	dprint("Gyro Debug: Entity aerodynamics removed from '");
	dprint(e.classname);
	dprint("'\n");
};

//----- Give Object Aerodynamic Propeties --------------------
void(entity e, float aeroforce) Gyro_Object_SetAerodynamics = {
	//----- Deactivate Aerodynamics --------------------
	if (aeroforce == 0) return Gyro_Object_RemoveAerodynamics(e);
	
	//----- Determine and Set Object Aerodynamics --------------------
	e.gyro_object_aerodynamics = aeroforce / e.gyro_object_mass;
	
	//----- Print Debugging Information --------------------
	// dprint("Gyro Debug: Entity aerodynamics activated for '");
	// dprint(e.classname);
	// dprint("'\nMass: ");
	// dprint(ftos(e.gyro_object_mass));
	// dprint(", Aerodynamics: ");
	// dprint(ftos(aeroforce));
	// dprint("\n");
};

//===== Thrust Propulsion Subsystem ====================
//----- Rocket-Style Thrust Applicator --------------------
void(entity e) Gyro_RunPhysics_Thrust = {
	local vector gyrothrust;

	if (e.gyro_object_thrust == 0) return;
	
	//----- Apply Thrust to Object --------------------
	makevectors(e.angles);
	gyrothrust = v_forward;
	gyrothrust_z = 0 - gyrothrust_z;
	e.gyro_velocityeffect = e.gyro_velocityeffect + (gyrothrust * e.gyro_object_thrust * GYRO_TICKRATE * GYRO_POWERCONSTANT);
};

//----- Deactivate Thrust on Entity e --------------------
void(entity e) Gyro_Object_RemoveThrust = {
	//----- Set to Zero Thrust --------------------
	e.gyro_object_thrust = 0.0;
	
	//----- Print Debugging Information --------------------
	dprint("Gyro Debug: Entity thrust removed from '");
	dprint(e.classname);
	dprint("'\n");
};

//----- Apply Thrust to an Object --------------------
void(entity e, float thrustforce) Gyro_Object_SetThrust = {
	//----- Deactivate Thrust if Zero Power --------------------
	if (thrustforce == 0) return Gyro_Object_RemoveThrust(e);
	
	//----- Determine and Set Object Thrust --------------------
	e.gyro_object_thrust = thrustforce / e.gyro_object_mass;
	
	//----- Print Debugging Information --------------------
	// dprint("Gyro Debug: Entity thrust activated for '");
	// dprint(e.classname);
	// dprint("'\nMass: ");
	// dprint(ftos(e.gyro_object_mass));
	// dprint(", Thrust: ");
	// dprint(ftos(thrustforce));
	// dprint("\n");
};

//===== Hover/Levitation Subsystem ====================
//----- Process a Single Hover Tap --------------------
vector(vector taporigin, vector tapdir, float tapdist) Gyro_RunHoverTap = {
	traceline(taporigin, taporigin - (tapdir * tapdist), TRUE, world);
	return (tapdir * (1.0 - trace_fraction));
};

//----- Run the Hover Subsystem on an Entity --------------------
void(entity e) Gyro_RunPhysics_Hover = {
	local vector totalpush, tapoffset;
	local float tapsleft, z_dampen;

	if (e.gyro_object_hover_tap <= 0) return;
	if (e.gyro_object_hover_dist <= 0) return;
	if (e.gyro_object_hover_power <= 0) return;
	
	//----- Prepare to Loop over all Taps --------------------
	tapsleft = ceil(e.gyro_object_hover_tap);
	
	//----- Loop Until Exhausted Taps --------------------
	while(tapsleft) {
		//----- Process Two Opposing Taps --------------------
		if (tapsleft > 1) {
			tapoffset_x = random() - 0.5;
			tapoffset_y = random() - 0.5;
			tapoffset_z = 0.0;
			totalpush = totalpush + Gyro_RunHoverTap(e.origin, '0 0 1' + tapoffset, e.gyro_object_hover_dist);
			totalpush = totalpush + Gyro_RunHoverTap(e.origin, '0 0 1' - tapoffset, e.gyro_object_hover_dist);
			tapsleft = tapsleft - 2;
		} else {
			//----- Process a Single Tap --------------------
			totalpush = totalpush + Gyro_RunHoverTap(e.origin, '0 0 1', e.gyro_object_hover_dist);
			tapsleft = tapsleft - 1;
		}
	}
	
	//----- Scale and Apply Final Hover Force --------------------
	totalpush = totalpush * (1.0 / ceil(e.gyro_object_hover_tap));
	z_dampen = Gyro_PowerEstimation(1.0 - (vlen(totalpush) * 0.7), GYRO_TICKRATE);
	e.gyro_velocityeffect = e.gyro_velocityeffect + (totalpush * e.gyro_object_hover_power * gyro_framegrav * GYRO_TICKRATE);
	e.gyro_dampeningeffect_z = e.gyro_dampeningeffect_z * z_dampen;
};

//----- Deactivate Hovering on Entity e --------------------
void(entity e) Gyro_Object_RemoveHover = {
	//----- Remove All Hover Settings --------------------
	e.gyro_object_hover_tap = 0;
	e.gyro_object_hover_dist = 0.0;
	e.gyro_object_hover_power = 0.0;
	
	//----- Print Debugging Information --------------------
	dprint("Gyro Debug: Entity hover removed from '");
	dprint(e.classname);
	dprint("'\n");
};

//----- Apply Hover Propeties to an Object --------------------
void(entity e, float hoverforce, float hoverdist, float hovertap) Gyro_Object_SetHover = {
	//----- Deactivate Thrust if Zero Power --------------------
	if (hoverforce <= 0) return Gyro_Object_RemoveThrust(e);
	if (hoverdist <= 0) return Gyro_Object_RemoveThrust(e);
	if (hovertap <= 0) return Gyro_Object_RemoveThrust(e);
	
	//----- Set Object Hovering Parameters --------------------
	hovertap = ceil(hovertap);
	e.gyro_object_hover_tap = hovertap;
	e.gyro_object_hover_dist = hoverdist;
	e.gyro_object_hover_power = hoverforce / e.gyro_object_mass;
	
	//----- Print Debugging Information --------------------
	dprint("Gyro Debug: Entity thrust activated for '");
	dprint(e.classname);
	dprint("'\nMass: ");
	dprint(ftos(e.gyro_object_mass));
	dprint(", Strength: ");
	dprint(ftos(hoverforce));
	dprint(", Tap: ");
	dprint(ftos(hovertap));
	dprint("\n");
};

//============================================================
//===== Object-Level Turbulence Subsystem ====================
//============================================================
//----- Per-Frame Turbulence Loop --------------------
void(entity e) Gyro_RunPhysics_Turbulence = {
	local float	turbpower;
	local vector	extravel;

	if (!(e.gyro_object_flags & GYRO_OBJECTFLAG_TURBULENCE)) return;
	
	//----- Find Turbulence Power based on Pointcontent --------------------
	if (e.gyro_object_pointcontent == -3)		turbpower = e.gyro_object_turbulence_water;
	else if (e.gyro_object_pointcontent == -4)	turbpower = e.gyro_object_turbulence_slime;
	else if (e.gyro_object_pointcontent == -5)	turbpower = e.gyro_object_turbulence_lava;
	else										turbpower = e.gyro_object_turbulence_air;

	turbpower = turbpower * GYRO_POWERCONSTANT * GYRO_TICKRATE;
	
	if (turbpower <= 0.0) return;
	
	//----- Zero Smoothness for Totally Random Movement --------------------
	if (e.gyro_object_turbulence_smooth <= 0.0) {
		e.gyro_object_turbulence_velocity_x = (random() - 0.5) * turbpower;
		e.gyro_object_turbulence_velocity_y = (random() - 0.5) * turbpower;
		e.gyro_object_turbulence_velocity_z = (random() - 0.5) * turbpower;
	} else {
		//----- Apply Smooth Turbulence --------------------
		if (e.gyro_object_turbulence_smooth < 1.0) {
			extravel_x = (random() - 0.5) * turbpower;
			extravel_y = (random() - 0.5) * turbpower;
			extravel_z = (random() - 0.5) * turbpower;
			e.gyro_object_turbulence_velocity = (e.gyro_object_turbulence_velocity * e.gyro_object_turbulence_smooth) + (extravel * (1 - e.gyro_object_turbulence_smooth));
		}
	}
	
	//----- Apply Final Turbulence Effect to Object --------------------
	if (pointcontents(e.origin + e.gyro_object_turbulence_velocity) != -2) {
		if (e.gyro_object_flags & GYRO_OBJECTFLAG_FLOATING) e.gyro_object_turbulence_velocity_z = 0;
		e.gyro_velocityeffect = e.gyro_velocityeffect + e.gyro_object_turbulence_velocity;
	}
};

//----- Remove Turbulence Settings --------------------
void(entity e) Gyro_Object_RemoveTurbulence = {
	//----- Remove All Turbulence Settings --------------------
	e.gyro_object_turbulence_air = 0.0;
	e.gyro_object_turbulence_water = 0.0;
	e.gyro_object_turbulence_slime = 0.0;
	e.gyro_object_turbulence_lava = 0.0;
	e.gyro_object_turbulence_smooth = 0.0;
	e.gyro_object_turbulence_velocity = '0 0 0';
	e.gyro_object_flags = e.gyro_object_flags - (e.gyro_object_flags & GYRO_OBJECTFLAG_TURBULENCE);
	
	//----- Print Debugging Information --------------------
	dprint("Gyro Debug: Entity turbulence removed from '");
	dprint(e.classname);
	dprint("'\n");
};

//----- Set Object-Level Turbulence on an Entity --------------------
void(entity e, float turbforce, float smoothness, float airmod, float watermod, float slimemod, float lavamod) Gyro_Object_SetTurbulenceMod = {
	//----- Deactivate with Zero Turbulence --------------------
	if (turbforce <= 0.0) return Gyro_Object_RemoveTurbulence(e);
	
	//----- Apply Turbulence Settings to Object --------------------
	turbforce = turbforce / e.gyro_object_mass;
	e.gyro_object_turbulence_air = turbforce * airmod;
	e.gyro_object_turbulence_water = turbforce * watermod;
	e.gyro_object_turbulence_slime = turbforce * slimemod;
	e.gyro_object_turbulence_lava = turbforce * lavamod;
	e.gyro_object_flags = e.gyro_object_flags | GYRO_OBJECTFLAG_TURBULENCE;
	e.gyro_object_turbulence_smooth = smoothness;
	
	//----- Print Debugging Information --------------------
	// dprint("Gyro Debug: Entity turbulence activated for \"");
	// dprint(e.classname);
	// dprint("\"\nMass: ");
	// dprint(ftos(e.gyro_object_mass));
	// dprint(", Turbulence: ");
	// dprint(ftos(turbforce));
	// dprint(", Smoothness: ");
	// dprint(ftos(smoothness*100));
	// dprint("%\n");
};

//----- Set Object-Level Turbulence with Default Modifiers --------------------
void(entity e, float turbforce, float smoothness) Gyro_Object_SetTurbulence = { Gyro_Object_SetTurbulenceMod(e, turbforce, smoothness, GYRO_TURBULENCEMOD_AIR, GYRO_TURBULENCEMOD_WATER, GYRO_TURBULENCEMOD_SLIME, GYRO_TURBULENCEMOD_LAVA); };

//===== Global-Level Turbulence Subsystem ====================
//----- Run Global Turbulence every Frame --------------------
void(entity e) Gyro_RunPhysics_GlobalTurb = {
	local float	turbpower;

	if (!(e.gyro_object_flags & GYRO_OBJECTFLAG_GLOBALTURB)) return;
	
	//----- Find Turbulence Power based on Pointcontent --------------------
	if (e.gyro_object_pointcontent == -3)		turbpower = e.gyro_object_globalturb_water;
	else if (e.gyro_object_pointcontent == -4)	turbpower = e.gyro_object_globalturb_slime;
	else if (e.gyro_object_pointcontent == -5)	turbpower = e.gyro_object_globalturb_lava;
	else										turbpower = e.gyro_object_globalturb_air;

	turbpower = turbpower * GYRO_POWERCONSTANT * GYRO_TICKRATE;
	
	if (turbpower <= 0.0) return;
	
	if (e.gyro_object_globalturb_smooth <= 0.0) 
		e.gyro_object_globalturb_velocity = gyro_globalturbulence * turbpower; // Zero Smoothness for Totally Random Movement
	else if (e.gyro_object_globalturb_smooth < 1.0)
		e.gyro_object_globalturb_velocity = (e.gyro_object_globalturb_velocity * e.gyro_object_globalturb_smooth) + (turbpower * gyro_globalturbulence * (1 - e.gyro_object_globalturb_smooth));  // apply Smooth Turbulence
	
	//----- Apply Final Turbulence Effect to Object --------------------
	if (pointcontents(e.origin + e.gyro_object_globalturb_velocity) != -2) {
		if (e.gyro_object_flags & GYRO_OBJECTFLAG_FLOATING) e.gyro_object_globalturb_velocity_z = 0;
		e.gyro_velocityeffect = e.gyro_velocityeffect + e.gyro_object_globalturb_velocity;
	}
};

//----- Remove Global-Turbulence Settings --------------------
void(entity e) Gyro_Object_RemoveGlobalTurb = {
	//----- Remove All Turbulence Settings --------------------
	e.gyro_object_globalturb_air = 0.0;
	e.gyro_object_globalturb_water = 0.0;
	e.gyro_object_globalturb_slime = 0.0;
	e.gyro_object_globalturb_lava = 0.0;
	e.gyro_object_globalturb_smooth = 0.0;
	e.gyro_object_globalturb_velocity = '0 0 0';
	e.gyro_object_flags = e.gyro_object_flags - (e.gyro_object_flags & GYRO_OBJECTFLAG_GLOBALTURB);
	
	//----- Print Debugging Information --------------------
	dprint("Gyro Debug: Entity global-turbulence removed from '");
	dprint(e.classname);
	dprint("'\n");
};

//----- Apply Global-Turblulence Settings to an Object --------------------
void(entity e, float turbforce, float smoothness, float airmod, float watermod, float slimemod, float lavamod) Gyro_Object_SetGlobalTurbMod = {
	//----- Deactivate with Zero Turbulence --------------------
	if (turbforce <= 0.0) return Gyro_Object_RemoveGlobalTurb(e);
	
	//----- Apply Turbulence Settings to Object --------------------
	turbforce = turbforce / e.gyro_object_mass;
	e.gyro_object_globalturb_air = turbforce * airmod;
	e.gyro_object_globalturb_water = turbforce * watermod;
	e.gyro_object_globalturb_slime = turbforce * slimemod;
	e.gyro_object_globalturb_lava = turbforce * lavamod;
	e.gyro_object_globalturb_smooth = smoothness;
	e.gyro_object_flags = e.gyro_object_flags | GYRO_OBJECTFLAG_GLOBALTURB;
	
	//----- Print Debugging Information --------------------
	// dprint("Gyro Debug: Entity global-turbulence activated for '");
	// dprint(e.classname);
	// dprint("'\nMass: ");
	// dprint(ftos(e.gyro_object_mass));
	// dprint(", Turbulence: ");
	// dprint(ftos(turbforce));
	// dprint("\n");
};

//----- Use Default Settings to Set Global-Turbulence --------------------
void(entity e, float turbforce, float smoothness) Gyro_Object_SetGlobalTurb = { Gyro_Object_SetGlobalTurbMod(e, turbforce, smoothness, GYRO_TURBULENCEMOD_AIR, GYRO_TURBULENCEMOD_WATER, GYRO_TURBULENCEMOD_SLIME, GYRO_TURBULENCEMOD_LAVA); };

//=======================================================
//===== Angular Turbulence Subsystem ====================
//=======================================================
//----- Simple Angular Turbulence Loop --------------------
void(entity e) Gyro_RunPhysics_AngleTurb = {
	local float turbeffect;

	if (e.gyro_object_angleturb == 0) return;
	
	//----- Alter Object's Turbulence Angular Effect --------------------
	turbeffect = e.gyro_object_angleturb * GYRO_TICKRATE * 360.0;
	e.gyro_avelocityeffect_x = e.gyro_avelocityeffect_x + ((random() - 0.5) * turbeffect);
	e.gyro_avelocityeffect_y = e.gyro_avelocityeffect_y + ((random() - 0.5) * turbeffect);
	e.gyro_avelocityeffect_z = e.gyro_avelocityeffect_z + ((random() - 0.5) * turbeffect);
};

// ---- Remove Angular Turbulence Settings --------------------
void(entity e) Gyro_Object_RemoveAngleTurb = {
	e.gyro_object_angleturb = 0.0;
	dprint("Gyro Debug: Entity angular-turbulence removed from '");
	dprint(e.classname);
	dprint("'\n");
};

//----- Set Object-Level Turbulence on an Entity --------------------
void(entity e, float turbforce) Gyro_Object_SetAngleTurb = {
	//----- Deactivate with Zero Turbulence --------------------
	if (turbforce <= 0.0) return Gyro_Object_RemoveAngleTurb(e);
	
	//----- Apply Turbulence Settings to Object --------------------
	e.gyro_object_angleturb = turbforce / e.gyro_object_mass;

	// dprint("Gyro Debug: Entity angular-turbulence activated for '");
	// dprint(e.classname);
	// dprint("'\nMass: ");
	// dprint(ftos(e.gyro_object_mass));
	// dprint(", Turbulence: ");
	// dprint(ftos(turbforce));
	// dprint("\n");
};

//===================================================
//===== Primary Physics Iterator ====================
//===================================================
//----- Run Physics Code every Frame --------------------
void() Gyro_RunPhysics = {
	local entity gyrohead;
	local float gyroheadcount, movespeed;

	//----- Update Global-Turbulence Vector --------------------
	gyro_globalturbulence_x = random() - 0.5;
	gyro_globalturbulence_y = random() - 0.5;
	gyro_globalturbulence_z = random() - 0.5;
	
	//----- Loop Over all Physics Objects --------------------
	gyrohead = gyro_objectlist_head;
	while (gyrohead) {
		//----- Pre-find Object Pointcontents --------------------
		gyrohead.gyro_object_pointcontent = GetContents(gyrohead.origin);

		//----- Run Individual Physics Subsystems --------------------
		Gyro_RunPhysics_Bouyancy(gyrohead);
		Gyro_RunPhysics_Resistance(gyrohead);
		Gyro_RunPhysics_Aerodynamics(gyrohead);
		Gyro_RunPhysics_Thrust(gyrohead);
		Gyro_RunPhysics_Hover(gyrohead);
		Gyro_RunPhysics_Turbulence(gyrohead);
		Gyro_RunPhysics_AngleTurb(gyrohead);
		Gyro_RunPhysics_GlobalTurb(gyrohead);
		
		//----- Grounded Objects have no Velocity --------------------
		if ((gyrohead.flags & FL_ONGROUND) && (gyrohead.movetype != 3)) {
			gyrohead.velocity = '0 0 0';
			gyrohead.avelocity = '0 0 0';
		}

		//dprint("Gryo buoyancy:: contents: ");
		//dprint(ftos(gyrohead.gyro_object_pointcontent));
		//dprint(", z vel pre: "); dprint(ftos(gyrohead.velocity_z));


		//----- Apply Standard Motion Effects --------------------
		gyrohead.velocity_x = gyrohead.velocity_x * gyrohead.gyro_dampeningeffect_x;
		gyrohead.velocity_y = gyrohead.velocity_y * gyrohead.gyro_dampeningeffect_y;
		gyrohead.velocity_z = gyrohead.velocity_z * gyrohead.gyro_dampeningeffect_z;
		gyrohead.avelocity_x = gyrohead.avelocity_x * gyrohead.gyro_adampeningeffect_x;
		gyrohead.avelocity_y = gyrohead.avelocity_y * gyrohead.gyro_adampeningeffect_y;
		gyrohead.avelocity_z = gyrohead.avelocity_z * gyrohead.gyro_adampeningeffect_z;
		gyrohead.velocity = gyrohead.velocity + gyrohead.gyro_velocityeffect;
		gyrohead.avelocity = gyrohead.avelocity + gyrohead.gyro_avelocityeffect;
		
		//----- Apply Anti-Gravity Effect to Non-Flying Objects --------------------
		if ((gyrohead.gyro_antigravityeffect > 0.0) && (gyrohead.movetype != 9)) {
			if (gyrohead.gyro_antigravityeffect > 1.0) gyrohead.gyro_antigravityeffect = 1.0;
			gyrohead.velocity_z = gyrohead.velocity_z + (gyrohead.gyro_antigravityeffect * gyro_framegrav * GYRO_TICKRATE);
		}
		
		//----- Lift Objects off Ground --------------------
		if ((gyrohead.flags & FL_ONGROUND) && (gyrohead.movetype != 3)) {
			movespeed = vlen(gyrohead.velocity);
			if (movespeed > (gyro_framegrav * GYRO_TICKRATE * 1.2)) {
				if (gyrohead.velocity_z < 0) gyrohead.velocity_z = 0 - gyrohead.velocity_z;
				if (gyrohead.velocity_z < 100) gyrohead.velocity_z = 100;
				SUB_RemoveFlags(gyrohead,FL_ONGROUND);
			} else {
				gyrohead.velocity = '0 0 0';
				gyrohead.avelocity = '0 0 0';
			}
		}
		
		//----- Perform Motion Correction to avoid Max Velocity --------------------
		if (gyrohead.velocity_x > gyro_framemaxvel) gyrohead.velocity = gyrohead.velocity * (gyro_framemaxvel / gyrohead.velocity_x);
		if (gyrohead.velocity_x < gyro_framemaxvelneg) gyrohead.velocity = gyrohead.velocity * (gyro_framemaxvelneg / gyrohead.velocity_x);
		if (gyrohead.velocity_y > gyro_framemaxvel) gyrohead.velocity = gyrohead.velocity * (gyro_framemaxvel / gyrohead.velocity_y);
		if (gyrohead.velocity_y < gyro_framemaxvelneg) gyrohead.velocity = gyrohead.velocity * (gyro_framemaxvelneg / gyrohead.velocity_y);
		if (gyrohead.velocity_z > gyro_framemaxvel) gyrohead.velocity = gyrohead.velocity * (gyro_framemaxvel / gyrohead.velocity_z);
		if (gyrohead.velocity_z < gyro_framemaxvelneg) gyrohead.velocity = gyrohead.velocity * (gyro_framemaxvelneg / gyrohead.velocity_z);

		//----- Reset Motion Effects --------------------
		gyrohead.gyro_velocityeffect = '0.0 0.0 0.0';
		gyrohead.gyro_avelocityeffect = '0.0 0.0 0.0';
		gyrohead.gyro_dampeningeffect = '1.0 1.0 1.0';
		gyrohead.gyro_adampeningeffect = '1.0 1.0 1.0';
		gyrohead.gyro_antigravityeffect = 0.0;
		
		//----- Continue Looping Over Objects --------------------
		gyroheadcount = gyroheadcount + 1;
		gyrohead = gyrohead.gyro_objectlist_next;
		//dprint(", z vel post: "); dprint(ftos(gyrohead.velocity_z)); dprint("\n");
	}
};
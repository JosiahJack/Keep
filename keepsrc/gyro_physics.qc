
//=================================================================
//===== Physics Object Activation/Deactivation ====================
//=================================================================

//----- Activate a Physics Object --------------------
void(entity e, float mass) Gyro_Object_Activate =
{
	//----- Prepare Object for Physics Operations --------------------
	local float	reactive;
	Gyro_ObjectList_Add(e);
	if (e.gyro_object_mass == 0)
	{
		e.gyro_object_mass = mass;
		e.gyro_object_channels = 1;
		reactive = FALSE;
	}
	else
		reactive = TRUE;
	
	//----- Zero or Below Mass is not Allowed --------------------
	if (e.gyro_object_mass <= 0.0)
	{
		if (GYRO_OBJECTDEBUG > 0)
		{
			gyro_framedebug = TRUE;
			bprint("Gyro Warning: Entity physics not activated for \"");
			bprint(e.classname);
			bprint("\"\nMass cannot be set to zero or below\n");
		}
	}
	
	//----- Zero-Set Motion Effects --------------------
	e.gyro_velocityeffect = '0.0 0.0 0.0';
	e.gyro_avelocityeffect = '0.0 0.0 0.0';
	e.gyro_dampeningeffect = '1.0 1.0 1.0';
	e.gyro_adampeningeffect = '1.0 1.0 1.0';
	e.gyro_antigravityeffect = 0.0;
	
	//----- Print Debugging Information --------------------
	if (GYRO_OBJECTDEBUG > 0)
	{
		gyro_framedebug = TRUE;
		bprint("Gyro Debug: Entity physics activated for \"");
		bprint(e.classname);
		bprint("\"\nMass: ");
		bprint(ftos(e.gyro_object_mass));
		if (reactive == TRUE)
			bprint(", inactive settings have been restored");
		bprint("\n");
	}
};


//----- Deactivate a Physics Object --------------------
void(entity e) Gyro_Object_Deactivate =
{
	//----- Remove Entity from Physics List --------------------
	Gyro_ObjectList_Remove(e);
	
	//----- Print Debugging Information --------------------
	if (GYRO_OBJECTDEBUG > 0)
	{
		gyro_framedebug = TRUE;
		bprint("Gyro Debug: Entity physics deactivated for \"");
		bprint(e.classname);
		bprint("\"\nPhysics settings preserved but inactive\n");
	}
};


//----- Remove All Physics Propeties from an Object --------------------
void(entity e) Gyro_Object_ClearPhysics =
{
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
	
	e.gyro_feedback = Gyro_Null;
	Gyro_ObjectList_Remove(e);
	
	//----- Print Debugging Information --------------------
	if (GYRO_OBJECTDEBUG > 0)
	{
		gyro_framedebug = TRUE;
		bprint("Gyro Debug: Entity physics cleared for \"");
		bprint(e.classname);
		bprint("\"\nAll physics settings removed\n");
	}
};



//============================================================
//===== Object Force-Channels and Feedback ====================
//============================================================

//----- Set an Object's Force Channels --------------------
void(entity e, float channels) Gyro_Object_SetChannels =
{
	e.gyro_object_channels = channels;
};

//----- Add Channels to an Object --------------------
void(entity e, float channels) Gyro_Object_AddChannels =
{
	e.gyro_object_channels = e.gyro_object_channels | channels;
};

//----- Remove Channels from an Object --------------------
void(entity e, float channels) Gyro_Object_RemoveChannels =
{
	e.gyro_object_channels = e.gyro_object_channels - (e.gyro_object_channels & channels);
};

//----- Call an Object's Feedback Function --------------------
void(entity e) Gyro_Object_CallFeedback =
{
	if (e.gyro_feedback)
	{
		local entity	oldself;
		oldself = self;
		self = e;
		self.gyro_feedback();
		self = oldself;
	}
};

//----- Feedback Debugging Helper Function --------------------
void() Gyro_Object_FeedbackDebug =
{
	bprint("Feedback function called for \"");
	bprint(self.classname);
	bprint("\"\nCalled by: ");
	bprint(gyro_feedback_name);
	bprint(", Power: ");
	bprint(ftos(gyro_feedback_power));
	bprint(", Channels: ");
	bprint(ftos(gyro_feedback_channels));
	bprint("\n");
};



//============================================================
//===== Bouyancy and Floatation Subsystem ====================
//============================================================

//----- Per-Frame Bouyancy Loop --------------------
void(entity e) Gyro_RunPhysics_Bouyancy =
{
	//----- Early Exit Conditions --------------------
	if (!e.gyro_object_flags & GYRO_OBJECTFLAG_BOUYANCY)
		return;
	
	//----- Get Motion Values for Current Pointcontents --------------------
	local float		org_content, bouypower, inwater;
	org_content = e.gyro_object_pointcontent;
	if (org_content == -3)
	{
		bouypower = e.gyro_object_bouyancy_water;
		inwater = TRUE;
	}
	else if (org_content == -4)
	{
		bouypower = e.gyro_object_bouyancy_slime;
		inwater = TRUE;
	}
	else if (org_content == -5)
	{
		bouypower = e.gyro_object_bouyancy_lava;
		inwater = TRUE;
	}
	else
		bouypower = e.gyro_object_bouyancy_air;
	
	//----- Reset Object Floating on Surface Flag --------------------
	e.gyro_object_flags = e.gyro_object_flags - (e.gyro_object_flags & GYRO_OBJECTFLAG_FLOATING);
	
	//----- Check Z-Position for Surface Floating --------------------
	if ((e.gyro_velocityeffect_z < 60.0) && (e.gyro_velocityeffect_z > -60.0))
	{
		local float top_content;
		top_content = pointcontents(e.origin + '0.0 0.0 2.4');
		if (top_content != org_content)
		{
			//----- Get Bouyancy Strength of Top Content --------------------
			local float	top_bouyancy;
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
	if (e.gyro_feedback)
	{
		if (inwater)
		{
			//----- Set Feedback Variables --------------------
			gyro_feedback_channels = 0;
			gyro_feedback_power = bouypower * e.gyro_object_mass;
			if (org_content == -3)
				gyro_feedback_name = "water";
			else if (org_content == -4)
				gyro_feedback_name = "slime";
			else if (org_content == -5)
				gyro_feedback_name = "lava";
			
			//----- Call Feedback Function --------------------
			Gyro_Object_CallFeedback(e);
		}
	}
	
	//----- Add Bouyancy to Velocity Buffer --------------------
	e.gyro_velocityeffect_z = e.gyro_velocityeffect_z + (bouypower * gyro_framegrav * GYRO_TICKRATE);
};


//----- Deactivate Bouyancy on Entity e --------------------
void(entity e) Gyro_Object_RemoveBouyancy =
{
	//----- Remove Bouyancy from Object --------------------
	e.gyro_object_bouyancy_air = 0.0;
	e.gyro_object_bouyancy_water = 0.0;
	e.gyro_object_bouyancy_slime = 0.0;
	e.gyro_object_bouyancy_lava = 0.0;
	e.gyro_object_flags = e.gyro_object_flags - (e.gyro_object_flags & GYRO_OBJECTFLAG_BOUYANCY);
	
	//----- Print Debugging Information --------------------
	if (GYRO_OBJECTDEBUG > 1)
	{
		gyro_framedebug = TRUE;
		bprint("Gyro Debug: Entity bouyancy removed from \"");
		bprint(e.classname);
		bprint("\"\n");
	}
};


//----- Give an Entity Bouyancy in Air, Water, Slime and Lava --------------------
void(entity e, float bouyforce, float mod_air, float mod_water, float mod_slime, float mod_lava) Gyro_Object_SetBouyancyMod =
{
	//----- No Bouyancy: Call Deactivation Macro --------------------
	if (bouyforce == 0)
		return Gyro_Object_RemoveBouyancy(e);
	
	//----- Calculate Basic Bouyancy Power --------------------
	local float	bouypower;
	bouypower = bouyforce / e.gyro_object_mass;
	
	//----- Apply All Bouyancy Settings to Object --------------------
	e.gyro_object_bouyancy_air = bouypower * mod_air;
	e.gyro_object_bouyancy_water = bouypower * mod_water;
	e.gyro_object_bouyancy_slime = bouypower * mod_slime;
	e.gyro_object_bouyancy_lava = bouypower * mod_lava;
	e.gyro_object_flags = e.gyro_object_flags | GYRO_OBJECTFLAG_BOUYANCY;
	
	//----- Print Debugging Information --------------------
	if (GYRO_OBJECTDEBUG > 1)
	{
		gyro_framedebug = TRUE;
		bprint("Gyro Debug: Entity bouyancy activated for \"");
		bprint(e.classname);
		bprint("\"\nMass: ");
		bprint(ftos(e.gyro_object_mass));
		bprint(", Bouyancy: ");
		bprint(ftos(bouyforce));
		bprint("\n");
	}
};


//----- Give an Object Bouyancy with Global Modifiers --------------------
void(entity e, float bouyforce) Gyro_Object_SetBouyancy =
{
	Gyro_Object_SetBouyancyMod(e, bouyforce, GYRO_BOUYANCYMOD_AIR, GYRO_BOUYANCYMOD_WATER, GYRO_BOUYANCYMOD_SLIME, GYRO_BOUYANCYMOD_LAVA);
};



//======================================================
//===== Motion Resistance Subsystem ====================
//======================================================

//----- Run Air and Water Resistance on Entity e --------------------
void(entity e) Gyro_RunPhysics_Resistance =
{
	//----- Early Exit Conditions --------------------
	if (!e.gyro_object_flags & GYRO_OBJECTFLAG_RESISTANCE)
		return;
	
	//----- Get Motion Values for Current Pointcontents --------------------
	local float	resistpower;
	if (e.gyro_object_pointcontent == -3)
		resistpower = e.gyro_object_resistance_water;
	else if (e.gyro_object_pointcontent == -4)
		resistpower = e.gyro_object_resistance_slime;
	else if (e.gyro_object_pointcontent == -5)
		resistpower = e.gyro_object_resistance_lava;
	else
		resistpower = e.gyro_object_resistance_air;
	
	//----- Apply Resistance Values to Effect Buffers --------------------
	resistpower = Gyro_PowerEstimation(resistpower, GYRO_TICKRATE);
	e.gyro_dampeningeffect = e.gyro_dampeningeffect * resistpower;
	e.gyro_adampeningeffect = e.gyro_adampeningeffect * resistpower;
};


//----- Deactivate Motion Resistance on Entity e --------------------
void(entity e) Gyro_Object_RemoveResistance =
{
	//----- Set to Zero Resistance Effect --------------------
	e.gyro_object_resistance_air = 1.0;
	e.gyro_object_resistance_water = 1.0;
	e.gyro_object_resistance_slime = 1.0;
	e.gyro_object_resistance_lava = 1.0;
	e.gyro_object_flags = e.gyro_object_flags - (e.gyro_object_flags & GYRO_OBJECTFLAG_RESISTANCE);
	
	//----- Print Debugging Information --------------------
	if (GYRO_OBJECTDEBUG > 1)
	{
		gyro_framedebug = TRUE;
		bprint("Gyro Debug: Entity motion resistance removed from \"");
		bprint(e.classname);
		bprint("\"\n");
	}
};


//----- Apply Motion Resistance Settings to an Object --------------------
void(entity e, float resforce, float mod_air, float mod_water, float mod_slime, float mod_lava) Gyro_Object_SetResistanceMod =
{
	//----- Zero Resistance: Run Deactivation Function --------------------
	if (resforce == 0)
		return Gyro_Object_RemoveResistance(e);
	
	//----- Set Motion Resistance for All Environments --------------------
	e.gyro_object_resistance_air = 1.0 / (((resforce * mod_air * 10.0) / e.gyro_object_mass) + 1.0);
	e.gyro_object_resistance_water = 1.0 / (((resforce * mod_water * 10.0) / e.gyro_object_mass) + 1.0);
	e.gyro_object_resistance_slime = 1.0 / (((resforce * mod_slime * 10.0) / e.gyro_object_mass) + 1.0);
	e.gyro_object_resistance_lava = 1.0 / (((resforce * mod_lava * 10.0) / e.gyro_object_mass) + 1.0);
	e.gyro_object_flags = e.gyro_object_flags | GYRO_OBJECTFLAG_RESISTANCE;
	
	//----- Print Debugging Information --------------------
	if (GYRO_OBJECTDEBUG > 1)
	{
		gyro_framedebug = TRUE;
		bprint("Gyro Debug: Entity motion resistance activated for \"");
		bprint(e.classname);
		bprint("\"\nMass: ");
		bprint(ftos(e.gyro_object_mass));
		bprint(", Resistance: ");
		bprint(ftos(resforce));
		bprint("\n");
	}
};


//----- Give an Object Globally-Defined Motion Resistance --------------------
void(entity e, float resforce) Gyro_Object_SetResistance =
{
	Gyro_Object_SetResistanceMod(e, resforce, GYRO_RESISTANCEMOD_AIR, GYRO_RESISTANCEMOD_WATER, GYRO_RESISTANCEMOD_SLIME, GYRO_RESISTANCEMOD_LAVA);
};



//=================================================
//===== Aerodynamics Subsystem ====================
//=================================================

//----- Per-Frame Aerodynamic Rotation --------------------
void(entity e) Gyro_RunPhysics_Aerodynamics =
{
	//----- Early Exit --------------------
	if (e.gyro_object_aerodynamics == 0)
		return;
	if (e.velocity == '0 0 0')
		return;
	
	//----- Calculate Object Movement Angle/Velocity --------------------
	local float		movespeed, aeropower, avelmult, adampmult;
	local vector	moveangle;
	movespeed = vlen(e.velocity);
	if (e.gyro_object_aerodynamics > 0)
	{
		aeropower = e.gyro_object_aerodynamics * 0.01;
		moveangle = vectoangles(e.velocity);
	}
	else
	{
		aeropower = e.gyro_object_aerodynamics * (-0.01);
		moveangle = vectoangles('0 0 0' - e.velocity);
	}
	
	//----- Alter Movement Propeties for Surface Floating  --------------------
	if (e.gyro_object_flags & GYRO_OBJECTFLAG_FLOATING)
	{
		moveangle_x = 0.0;
		movespeed = movespeed + 200;
	}
	
	//----- Aerodynamic Multipliers for AVelocity and ADampening --------------------
	avelmult = movespeed * aeropower;
	adampmult = 1.0 / ((movespeed * aeropower * 0.2) + 1.0);
	
	//----- Subtract Actual Angles from Movement Angles --------------------
	local vector	turnangle;
	turnangle = moveangle - e.angles;
	while (turnangle_x > 180.0)
		turnangle_x = turnangle_x - 360.0;
	while (turnangle_x < -180.0)
		turnangle_x = turnangle_x + 360.0;
	while (turnangle_y > 180.0)
		turnangle_y = turnangle_y - 360.0;
	while (turnangle_y < -180.0)
		turnangle_y = turnangle_y + 360.0;
	while (turnangle_z > 180.0)
		turnangle_z = turnangle_z - 360.0;
	while (turnangle_z < -180.0)
		turnangle_z = turnangle_z + 360.0;
	
	//----- Compute and Set Angular Velocity --------------------
	e.gyro_avelocityeffect = e.gyro_avelocityeffect + (turnangle * avelmult * GYRO_TICKRATE);
	e.gyro_adampeningeffect = e.gyro_adampeningeffect * Gyro_PowerEstimation(adampmult, GYRO_TICKRATE);
};


//----- Deactivate Aerodynamics on Entity e --------------------
void(entity e) Gyro_Object_RemoveAerodynamics =
{
	//----- Remove Aerodynamics from Object --------------------
	e.gyro_object_aerodynamics = 0.0;
	
	//----- Print Debugging Information --------------------
	if (GYRO_OBJECTDEBUG > 1)
	{
		gyro_framedebug = TRUE;
		bprint("Gyro Debug: Entity aerodynamics removed from \"");
		bprint(e.classname);
		bprint("\"\n");
	}
};


//----- Give Object Aerodynamic Propeties --------------------
void(entity e, float aeroforce) Gyro_Object_SetAerodynamics =
{
	//----- Deactivate Aerodynamics --------------------
	if (aeroforce == 0)
		return Gyro_Object_RemoveAerodynamics(e);
	
	//----- Determine and Set Object Aerodynamics --------------------
	e.gyro_object_aerodynamics = aeroforce / e.gyro_object_mass;
	
	//----- Print Debugging Information --------------------
	if (GYRO_OBJECTDEBUG > 1)
	{
		gyro_framedebug = TRUE;
		bprint("Gyro Debug: Entity aerodynamics activated for \"");
		bprint(e.classname);
		bprint("\"\nMass: ");
		bprint(ftos(e.gyro_object_mass));
		bprint(", Aerodynamics: ");
		bprint(ftos(aeroforce));
		bprint("\n");
	}
};



//======================================================
//===== Thrust Propulsion Subsystem ====================
//======================================================

//----- Rocket-Style Thrust Applicator --------------------
void(entity e) Gyro_RunPhysics_Thrust =
{
	//----- Early Exit --------------------
	if (e.gyro_object_thrust == 0)
		return;
	
	//----- Apply Thrust to Object --------------------
	local vector	gyrothrust;
	makevectors (e.angles);
	gyrothrust = v_forward;
	gyrothrust_z = 0 - gyrothrust_z;
	e.gyro_velocityeffect = e.gyro_velocityeffect + (gyrothrust * e.gyro_object_thrust * GYRO_TICKRATE * GYRO_POWERCONSTANT);
	
};


//----- Deactivate Thrust on Entity e --------------------
void(entity e) Gyro_Object_RemoveThrust =
{
	//----- Set to Zero Thrust --------------------
	e.gyro_object_thrust = 0.0;
	
	//----- Print Debugging Information --------------------
	if (GYRO_OBJECTDEBUG > 1)
	{
		gyro_framedebug = TRUE;
		bprint("Gyro Debug: Entity thrust removed from \"");
		bprint(e.classname);
		bprint("\"\n");
	}
};


//----- Apply Thrust to an Object --------------------
void(entity e, float thrustforce) Gyro_Object_SetThrust =
{
	//----- Deactivate Thrust if Zero Power --------------------
	if (thrustforce == 0)
		return Gyro_Object_RemoveThrust(e);
	
	//----- Determine and Set Object Thrust --------------------
	e.gyro_object_thrust = thrustforce / e.gyro_object_mass;
	
	//----- Print Debugging Information --------------------
	if (GYRO_OBJECTDEBUG > 1)
	{
		gyro_framedebug = TRUE;
		bprint("Gyro Debug: Entity thrust activated for \"");
		bprint(e.classname);
		bprint("\"\nMass: ");
		bprint(ftos(e.gyro_object_mass));
		bprint(", Thrust: ");
		bprint(ftos(thrustforce));
		bprint("\n");
	}
};



//=====================================================
//===== Hover/Levitation Subsystem ====================
//=====================================================

//----- Process a Single Hover Tap --------------------
vector(vector taporigin, vector tapdir, float tapdist) Gyro_RunHoverTap =
{
	traceline(taporigin, taporigin - (tapdir * tapdist), TRUE, world);
	return (tapdir * (1.0 - trace_fraction));
};


//----- Run the Hover Subsystem on an Entity --------------------
void(entity e) Gyro_RunPhysics_Hover =
{
	//----- Early Exit Conditions --------------------
	if (e.gyro_object_hover_tap <= 0)
		return;
	if (e.gyro_object_hover_dist <= 0)
		return;
	if (e.gyro_object_hover_power <= 0)
		return;
	
	//----- Prepare to Loop over all Taps --------------------
	local vector	totalpush;
	local float		tapsleft;
	tapsleft = ceil(e.gyro_object_hover_tap);
	
	//----- Loop Until Exhausted Taps --------------------
	while(tapsleft)
	{
		//----- Process Two Opposing Taps --------------------
		if (tapsleft > 1)
		{
			local vector	tapoffset;
			tapoffset_x = random() - 0.5;
			tapoffset_y = random() - 0.5;
			tapoffset_z = 0.0;
			totalpush = totalpush + Gyro_RunHoverTap(e.origin, '0 0 1' + tapoffset, e.gyro_object_hover_dist);
			totalpush = totalpush + Gyro_RunHoverTap(e.origin, '0 0 1' - tapoffset, e.gyro_object_hover_dist);
			tapsleft = tapsleft - 2;
		}
		
		//----- Process a Single Tap --------------------
		else
		{
			totalpush = totalpush + Gyro_RunHoverTap(e.origin, '0 0 1', e.gyro_object_hover_dist);
			tapsleft = tapsleft - 1;
		}
	}
	
	//----- Scale and Apply Final Hover Force --------------------
	local float	z_dampen;
	totalpush = totalpush * (1.0 / ceil(e.gyro_object_hover_tap));
	z_dampen = Gyro_PowerEstimation(1.0 - (vlen(totalpush) * 0.7), GYRO_TICKRATE);
	e.gyro_velocityeffect = e.gyro_velocityeffect + (totalpush * e.gyro_object_hover_power * gyro_framegrav * GYRO_TICKRATE);
	e.gyro_dampeningeffect_z = e.gyro_dampeningeffect_z * z_dampen;
};


//----- Deactivate Hovering on Entity e --------------------
void(entity e) Gyro_Object_RemoveHover =
{
	//----- Remove All Hover Settings --------------------
	e.gyro_object_hover_tap = 0;
	e.gyro_object_hover_dist = 0.0;
	e.gyro_object_hover_power = 0.0;
	
	//----- Print Debugging Information --------------------
	if (GYRO_OBJECTDEBUG > 1)
	{
		gyro_framedebug = TRUE;
		bprint("Gyro Debug: Entity hover removed from \"");
		bprint(e.classname);
		bprint("\"\n");
	}
};


//----- Apply Hover Propeties to an Object --------------------
void(entity e, float hoverforce, float hoverdist, float hovertap) Gyro_Object_SetHover =
{
	//----- Deactivate Thrust if Zero Power --------------------
	if (hoverforce <= 0)
		return Gyro_Object_RemoveThrust(e);
	if (hoverdist <= 0)
		return Gyro_Object_RemoveThrust(e);
	if (hovertap <= 0)
		return Gyro_Object_RemoveThrust(e);
	
	//----- Set Object Hovering Parameters --------------------
	hovertap = ceil(hovertap);
	e.gyro_object_hover_tap = hovertap;
	e.gyro_object_hover_dist = hoverdist;
	e.gyro_object_hover_power = hoverforce / e.gyro_object_mass;
	
	//----- Print Debugging Information --------------------
	if (GYRO_OBJECTDEBUG > 1)
	{
		gyro_framedebug = TRUE;
		bprint("Gyro Debug: Entity thrust activated for \"");
		bprint(e.classname);
		bprint("\"\nMass: ");
		bprint(ftos(e.gyro_object_mass));
		bprint(", Strength: ");
		bprint(ftos(hoverforce));
		bprint(", Tap: ");
		bprint(ftos(hovertap));
		bprint("\n");
	}
};



//============================================================
//===== Object-Level Turbulence Subsystem ====================
//============================================================

//----- Per-Frame Turbulence Loop --------------------
void(entity e) Gyro_RunPhysics_Turbulence =
{
	//----- Early Exit --------------------
	if (!e.gyro_object_flags & GYRO_OBJECTFLAG_TURBULENCE)
		return;
	
	//----- Find Turbulence Power based on Pointcontent --------------------
	local float	turbpower;
	if (e.gyro_object_pointcontent == -3)
		turbpower = e.gyro_object_turbulence_water;
	else if (e.gyro_object_pointcontent == -4)
		turbpower = e.gyro_object_turbulence_slime;
	else if (e.gyro_object_pointcontent == -5)
		turbpower = e.gyro_object_turbulence_lava;
	else
		turbpower = e.gyro_object_turbulence_air;
	turbpower = turbpower * GYRO_POWERCONSTANT * GYRO_TICKRATE;
	
	//----- Early Exit --------------------
	if (turbpower <= 0.0)
		return;
	
	//----- Zero Smoothness for Totally Random Movement --------------------
	if (e.gyro_object_turbulence_smooth <= 0.0)
	{
		e.gyro_object_turbulence_velocity_x = (random() - 0.5) * turbpower;
		e.gyro_object_turbulence_velocity_y = (random() - 0.5) * turbpower;
		e.gyro_object_turbulence_velocity_z = (random() - 0.5) * turbpower;
	}
	
	//----- Apply Smooth Turbulence --------------------
	else
	{
		if (e.gyro_object_turbulence_smooth < 1.0)
		{
			local vector	extravel;
			extravel_x = (random() - 0.5) * turbpower;
			extravel_y = (random() - 0.5) * turbpower;
			extravel_z = (random() - 0.5) * turbpower;
			e.gyro_object_turbulence_velocity = (e.gyro_object_turbulence_velocity * e.gyro_object_turbulence_smooth) + (extravel * (1 - e.gyro_object_turbulence_smooth));
		}
	}
	
	//----- Apply Final Turbulence Effect to Object --------------------
	if (pointcontents(e.origin + e.gyro_object_turbulence_velocity) != -2)
	{
		if (e.gyro_object_flags & GYRO_OBJECTFLAG_FLOATING)
			e.gyro_object_turbulence_velocity_z = 0;
		e.gyro_velocityeffect = e.gyro_velocityeffect + e.gyro_object_turbulence_velocity;
	}
};


//----- Remove Turbulence Settings --------------------
void(entity e) Gyro_Object_RemoveTurbulence =
{
	//----- Remove All Turbulence Settings --------------------
	e.gyro_object_turbulence_air = 0.0;
	e.gyro_object_turbulence_water = 0.0;
	e.gyro_object_turbulence_slime = 0.0;
	e.gyro_object_turbulence_lava = 0.0;
	e.gyro_object_turbulence_smooth = 0.0;
	e.gyro_object_turbulence_velocity = '0 0 0';
	e.gyro_object_flags = e.gyro_object_flags - (e.gyro_object_flags & GYRO_OBJECTFLAG_TURBULENCE);
	
	//----- Print Debugging Information --------------------
	if (GYRO_OBJECTDEBUG > 1)
	{
		gyro_framedebug = TRUE;
		bprint("Gyro Debug: Entity turbulence removed from \"");
		bprint(e.classname);
		bprint("\"\n");
	}
};


//----- Set Object-Level Turbulence on an Entity --------------------
void(entity e, float turbforce, float smoothness, float airmod, float watermod, float slimemod, float lavamod) Gyro_Object_SetTurbulenceMod =
{
	//----- Deactivate with Zero Turbulence --------------------
	if (turbforce <= 0.0)
		return Gyro_Object_RemoveTurbulence(e);
	
	//----- Apply Turbulence Settings to Object --------------------
	turbforce = turbforce / e.gyro_object_mass;
	e.gyro_object_turbulence_air = turbforce * airmod;
	e.gyro_object_turbulence_water = turbforce * watermod;
	e.gyro_object_turbulence_slime = turbforce * slimemod;
	e.gyro_object_turbulence_lava = turbforce * lavamod;
	e.gyro_object_flags = e.gyro_object_flags | GYRO_OBJECTFLAG_TURBULENCE;
	e.gyro_object_turbulence_smooth = smoothness;
	
	//----- Print Debugging Information --------------------
	if (GYRO_OBJECTDEBUG > 1)
	{
		gyro_framedebug = TRUE;
		bprint("Gyro Debug: Entity turbulence activated for \"");
		bprint(e.classname);
		bprint("\"\nMass: ");
		bprint(ftos(e.gyro_object_mass));
		bprint(", Turbulence: ");
		bprint(ftos(turbforce));
		bprint(", Smoothness: ");
		bprint(ftos(smoothness*100));
		bprint("%\n");
	}
};


//----- Set Object-Level Turbulence with Default Modifiers --------------------
void(entity e, float turbforce, float smoothness) Gyro_Object_SetTurbulence =
{
	Gyro_Object_SetTurbulenceMod(e, turbforce, smoothness, GYRO_TURBULENCEMOD_AIR, GYRO_TURBULENCEMOD_WATER, GYRO_TURBULENCEMOD_SLIME, GYRO_TURBULENCEMOD_LAVA);
};



//============================================================
//===== Global-Level Turbulence Subsystem ====================
//============================================================

//----- Run Global Turbulence every Frame --------------------
void(entity e) Gyro_RunPhysics_GlobalTurb =
{
	//----- Early Exit --------------------
	if (!e.gyro_object_flags & GYRO_OBJECTFLAG_GLOBALTURB)
		return;
	
	//----- Find Turbulence Power based on Pointcontent --------------------
	local float	turbpower;
	if (e.gyro_object_pointcontent == -3)
		turbpower = e.gyro_object_globalturb_water;
	else if (e.gyro_object_pointcontent == -4)
		turbpower = e.gyro_object_globalturb_slime;
	else if (e.gyro_object_pointcontent == -5)
		turbpower = e.gyro_object_globalturb_lava;
	else
		turbpower = e.gyro_object_globalturb_air;
	turbpower = turbpower * GYRO_POWERCONSTANT * GYRO_TICKRATE;
	
	//----- Early Exit --------------------
	if (turbpower <= 0.0)
		return;
	
	//----- Zero Smoothness for Totally Random Movement --------------------
	if (e.gyro_object_globalturb_smooth <= 0.0)
		e.gyro_object_globalturb_velocity = gyro_globalturbulence * turbpower;
	
	//----- Apply Smooth Turbulence --------------------
	else if (e.gyro_object_globalturb_smooth < 1.0)
		e.gyro_object_globalturb_velocity = (e.gyro_object_globalturb_velocity * e.gyro_object_globalturb_smooth) + (turbpower * gyro_globalturbulence * (1 - e.gyro_object_globalturb_smooth));
	
	//----- Apply Final Turbulence Effect to Object --------------------
	if (pointcontents(e.origin + e.gyro_object_globalturb_velocity) != -2)
	{
		if (e.gyro_object_flags & GYRO_OBJECTFLAG_FLOATING)
			e.gyro_object_globalturb_velocity_z = 0;
		e.gyro_velocityeffect = e.gyro_velocityeffect + e.gyro_object_globalturb_velocity;
	}
};


//----- Remove Global-Turbulence Settings --------------------
void(entity e) Gyro_Object_RemoveGlobalTurb =
{
	//----- Remove All Turbulence Settings --------------------
	e.gyro_object_globalturb_air = 0.0;
	e.gyro_object_globalturb_water = 0.0;
	e.gyro_object_globalturb_slime = 0.0;
	e.gyro_object_globalturb_lava = 0.0;
	e.gyro_object_globalturb_smooth = 0.0;
	e.gyro_object_globalturb_velocity = '0 0 0';
	e.gyro_object_flags = e.gyro_object_flags - (e.gyro_object_flags & GYRO_OBJECTFLAG_GLOBALTURB);
	
	//----- Print Debugging Information --------------------
	if (GYRO_OBJECTDEBUG > 1)
	{
		gyro_framedebug = TRUE;
		bprint("Gyro Debug: Entity global-turbulence removed from \"");
		bprint(e.classname);
		bprint("\"\n");
	}
};


//----- Apply Global-Turblulence Settings to an Object --------------------
void(entity e, float turbforce, float smoothness, float airmod, float watermod, float slimemod, float lavamod) Gyro_Object_SetGlobalTurbMod =
{
	//----- Deactivate with Zero Turbulence --------------------
	if (turbforce <= 0.0)
		return Gyro_Object_RemoveGlobalTurb(e);
	
	//----- Apply Turbulence Settings to Object --------------------
	turbforce = turbforce / e.gyro_object_mass;
	e.gyro_object_globalturb_air = turbforce * airmod;
	e.gyro_object_globalturb_water = turbforce * watermod;
	e.gyro_object_globalturb_slime = turbforce * slimemod;
	e.gyro_object_globalturb_lava = turbforce * lavamod;
	e.gyro_object_globalturb_smooth = smoothness;
	e.gyro_object_flags = e.gyro_object_flags | GYRO_OBJECTFLAG_GLOBALTURB;
	
	//----- Print Debugging Information --------------------
	if (GYRO_OBJECTDEBUG > 1)
	{
		gyro_framedebug = TRUE;
		bprint("Gyro Debug: Entity global-turbulence activated for \"");
		bprint(e.classname);
		bprint("\"\nMass: ");
		bprint(ftos(e.gyro_object_mass));
		bprint(", Turbulence: ");
		bprint(ftos(turbforce));
		bprint("\n");
	}
};


//----- Use Default Settings to Set Global-Turbulence --------------------
void(entity e, float turbforce, float smoothness) Gyro_Object_SetGlobalTurb =
{
	Gyro_Object_SetGlobalTurbMod(e, turbforce, smoothness, GYRO_TURBULENCEMOD_AIR, GYRO_TURBULENCEMOD_WATER, GYRO_TURBULENCEMOD_SLIME, GYRO_TURBULENCEMOD_LAVA);
};



//=======================================================
//===== Angular Turbulence Subsystem ====================
//=======================================================

//----- Simple Angular Turbulence Loop --------------------
void(entity e) Gyro_RunPhysics_AngleTurb =
{
	//----- Early Exit --------------------
	if (e.gyro_object_angleturb == 0)
		return;
	
	//----- Alter Object's Turbulence Angular Effect --------------------
	local float turbeffect;
	turbeffect = e.gyro_object_angleturb * GYRO_TICKRATE * 360.0;
	e.gyro_avelocityeffect_x = e.gyro_avelocityeffect_x + ((random() - 0.5) * turbeffect);
	e.gyro_avelocityeffect_y = e.gyro_avelocityeffect_y + ((random() - 0.5) * turbeffect);
	e.gyro_avelocityeffect_z = e.gyro_avelocityeffect_z + ((random() - 0.5) * turbeffect);
};


//----- Remove Angular Turbulence Settings --------------------
void(entity e) Gyro_Object_RemoveAngleTurb =
{
	e.gyro_object_angleturb = 0.0;
	if (GYRO_OBJECTDEBUG > 1)
	{
		gyro_framedebug = TRUE;
		bprint("Gyro Debug: Entity angular-turbulence removed from \"");
		bprint(e.classname);
		bprint("\"\n");
	}
};


//----- Set Object-Level Turbulence on an Entity --------------------
void(entity e, float turbforce) Gyro_Object_SetAngleTurb =
{
	//----- Deactivate with Zero Turbulence --------------------
	if (turbforce <= 0.0)
		return Gyro_Object_RemoveAngleTurb(e);
	
	//----- Apply Turbulence Settings to Object --------------------
	e.gyro_object_angleturb = turbforce / e.gyro_object_mass;
	if (GYRO_OBJECTDEBUG > 1)
	{
		gyro_framedebug = TRUE;
		bprint("Gyro Debug: Entity angular-turbulence activated for \"");
		bprint(e.classname);
		bprint("\"\nMass: ");
		bprint(ftos(e.gyro_object_mass));
		bprint(", Turbulence: ");
		bprint(ftos(turbforce));
		bprint("\n");
	}
};



//===================================================
//===== Primary Physics Iterator ====================
//===================================================

//----- Run Physics Code every Frame --------------------
void() Gyro_RunPhysics =
{
	//----- Update Global-Turbulence Vector --------------------
	gyro_globalturbulence_x = random() - 0.5;
	gyro_globalturbulence_y = random() - 0.5;
	gyro_globalturbulence_z = random() - 0.5;
	
	//----- Loop Over all Physics Objects --------------------
	local entity	gyrohead;
	local float		gyroheadcount;
	gyrohead = gyro_objectlist_head;
	while (gyrohead)
	{
		//----- Pre-find Object Pointcontents --------------------
		gyrohead.gyro_object_pointcontent = pointcontents(gyrohead.origin);
		
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
		if ((gyrohead.flags & FL_ONGROUND) && (gyrohead.movetype != 3))
		{
			gyrohead.velocity = '0 0 0';
			gyrohead.avelocity = '0 0 0';
		}
		
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
		if ((gyrohead.gyro_antigravityeffect > 0.0) && (gyrohead.movetype != 9))
		{
			if (gyrohead.gyro_antigravityeffect > 1.0)
				gyrohead.gyro_antigravityeffect = 1.0;
			gyrohead.velocity_z = gyrohead.velocity_z + (gyrohead.gyro_antigravityeffect * gyro_framegrav * GYRO_TICKRATE);
		}
		
		//----- Lift Objects off Ground --------------------
		if ((gyrohead.flags & FL_ONGROUND) && (gyrohead.movetype != 3))
		{
			local float	movespeed;
			movespeed = vlen(gyrohead.velocity);
			if (movespeed > (gyro_framegrav * GYRO_TICKRATE * 1.2))
			{
				if (gyrohead.velocity_z < 0)
					gyrohead.velocity_z = 0 - gyrohead.velocity_z;
				if (gyrohead.velocity_z < 100)
					gyrohead.velocity_z = 100;
				gyrohead.flags = gyrohead.flags - FL_ONGROUND;
			}
			else
			{
				gyrohead.velocity = '0 0 0';
				gyrohead.avelocity = '0 0 0';
			}
		}
		
		//----- Perform Motion Correction to avoid Max Velocity --------------------
		if (GYRO_MOTIONCORRECTION)
		{
			if (gyrohead.velocity_x > gyro_framemaxvel)
				gyrohead.velocity = gyrohead.velocity * (gyro_framemaxvel / gyrohead.velocity_x);
			if (gyrohead.velocity_x < gyro_framemaxvelneg)
				gyrohead.velocity = gyrohead.velocity * (gyro_framemaxvelneg / gyrohead.velocity_x);
			if (gyrohead.velocity_y > gyro_framemaxvel)
				gyrohead.velocity = gyrohead.velocity * (gyro_framemaxvel / gyrohead.velocity_y);
			if (gyrohead.velocity_y < gyro_framemaxvelneg)
				gyrohead.velocity = gyrohead.velocity * (gyro_framemaxvelneg / gyrohead.velocity_y);
			if (gyrohead.velocity_z > gyro_framemaxvel)
				gyrohead.velocity = gyrohead.velocity * (gyro_framemaxvel / gyrohead.velocity_z);
			if (gyrohead.velocity_z < gyro_framemaxvelneg)
				gyrohead.velocity = gyrohead.velocity * (gyro_framemaxvelneg / gyrohead.velocity_z);
		}
		
		//----- Reset Motion Effects --------------------
		gyrohead.gyro_velocityeffect = '0.0 0.0 0.0';
		gyrohead.gyro_avelocityeffect = '0.0 0.0 0.0';
		gyrohead.gyro_dampeningeffect = '1.0 1.0 1.0';
		gyrohead.gyro_adampeningeffect = '1.0 1.0 1.0';
		gyrohead.gyro_antigravityeffect = 0.0;
		
		//----- Continue Looping Over Objects --------------------
		gyroheadcount = gyroheadcount + 1;
		gyrohead = gyrohead.gyro_objectlist_next;
	}
};

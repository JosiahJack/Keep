
//=================================================================
//===== Force Creation and Management Routines ====================
//=================================================================

//----- Create and Return an Empty Force --------------------
entity(string forcename, vector org) Gyro_Force_Create =
{
	//----- Display Debug Message --------------------
	if (GYRO_FORCEDEBUG > 0)
	{
		gyro_framedebug = TRUE;
		bprint("Gyro Debug: Empty force entity \"");
		bprint(forcename);
		bprint("\" created\n");
	}
	
	//----- Create an Empty Force --------------------
	local entity	f;
	f = spawn();
	Gyro_ForceList_Add(f);
	setorigin(f, org);
	
	//----- Set Initial Values and Return --------------------
	f.classname = forcename;
	f.gyro_force_falloff_combine = GYRO_FALLOFF_COMBINE_MULTIPLY;
	f.gyro_force_rangescale = 1.0;
	f.gyro_force_rangescalerate = 0.0;
	f.gyro_force_powerscale = 1.0;
	f.gyro_force_powerscalerate = 0.0;
	f.gyro_force_channels = 1;
	f.gyro_force_update = TRUE;
	return f;
};


//----- Remove a Force from the List and the Engine --------------------
void(entity f) Gyro_Force_Remove =
{
	//----- Display Debug Message --------------------
	if (GYRO_FORCEDEBUG > 0)
	{
		gyro_framedebug = TRUE;
		bprint("Gyro Debug: Removed force entity \"");
		bprint(f.classname);
		bprint("\"\n");
	}
	
	//----- Remove --------------------
	remove(f);
};


//----- Update the Bounding Box of an Area Falloff --------------------
void(entity f, vector fallaxis) Gyro_Force_Update_AreaBounds =
{
	//----- Apply Scale to Falloff --------------------
	fallaxis = fallaxis * f.gyro_force_rangescale;
	
	//----- Find X Bound --------------------
	if (fallaxis_x > 0)
	{
		if ((fallaxis_x < f.gyro_force_bounds_x) || (f.gyro_force_bounds_x == 0))
			f.gyro_force_bounds_x = fallaxis_x;
	}
	
	//----- Find Y Bound --------------------
	if (fallaxis_y > 0)
	{
		if ((fallaxis_y < f.gyro_force_bounds_y) || (f.gyro_force_bounds_y == 0))
			f.gyro_force_bounds_y = fallaxis_y;
	}
	
	//----- Find Z Bound --------------------
	if (fallaxis_z > 0)
	{
		if ((fallaxis_z < f.gyro_force_bounds_z) || (f.gyro_force_bounds_z == 0))
			f.gyro_force_bounds_z = fallaxis_z;
	}
};


//----- Update the Bounding Box of a Cone/Cylinder Falloff --------------------
void(entity f, vector fallaxis, float rad1, float rad2) Gyro_Force_Update_ConeBounds =
{
	//----- Scale Falloff Values --------------------
	if (f.gyro_force_rangescale != 1.0)
	{
		fallaxis = fallaxis * f.gyro_force_rangescale;
		rad1 = rad1 * f.gyro_force_rangescale;
		rad2 = rad2 * f.gyro_force_rangescale;
	}
	
	//----- Calculate Maximum Bounding Box --------------------
	fallaxis_x = fabs(fallaxis_x) + rad2;
	fallaxis_y = fabs(fallaxis_y) + rad2;
	fallaxis_z = fabs(fallaxis_z) + rad2;
	if (rad1 > fallaxis_x)
		fallaxis_x = rad2;
	if (rad1 > fallaxis_y)
		fallaxis_y = rad2;
	if (rad1 > fallaxis_z)
		fallaxis_z = rad2;
	
	//----- Update Bounds --------------------
	if ((fallaxis_x < f.gyro_force_bounds_x) || (f.gyro_force_bounds_x == 0))
		f.gyro_force_bounds_x = fallaxis_x;
	if ((fallaxis_y < f.gyro_force_bounds_y) || (f.gyro_force_bounds_y == 0))
		f.gyro_force_bounds_y = fallaxis_y;
	if ((fallaxis_z < f.gyro_force_bounds_z) || (f.gyro_force_bounds_z == 0))
		f.gyro_force_bounds_z = fallaxis_z;
};


//----- Update Pre-Computed Force Variables --------------------
void(entity f) Gyro_Force_Update =
{
	//----- Don't Bother if Zero-Scaled --------------------
	if (f.gyro_force_rangescale == 0.0)
		return;
	
	//----- Compute Force Bounds from Falloff --------------------
	f.gyro_force_bounds = '0 0 0';
	
	if (f.gyro_force_falloff1_type & GYRO_FALLOFF_TYPE_AREA)
		Gyro_Force_Update_AreaBounds(f, f.gyro_force_falloff1_axis);
	else if (f.gyro_force_falloff1_type & GYRO_FALLOFF_TYPE_CONE)
		Gyro_Force_Update_ConeBounds(f, f.gyro_force_falloff1_axis, f.gyro_force_falloff1_rad1, f.gyro_force_falloff1_rad2);
	
	if (f.gyro_force_falloff2_type & GYRO_FALLOFF_TYPE_AREA)
		Gyro_Force_Update_AreaBounds(f, f.gyro_force_falloff2_axis);
	else if (f.gyro_force_falloff2_type & GYRO_FALLOFF_TYPE_CONE)
		Gyro_Force_Update_ConeBounds(f, f.gyro_force_falloff2_axis, f.gyro_force_falloff2_rad1, f.gyro_force_falloff2_rad2);
	
	if (f.gyro_force_falloff3_type & GYRO_FALLOFF_TYPE_AREA)
		Gyro_Force_Update_AreaBounds(f, f.gyro_force_falloff3_axis);
	else if (f.gyro_force_falloff3_type & GYRO_FALLOFF_TYPE_CONE)
		Gyro_Force_Update_ConeBounds(f, f.gyro_force_falloff3_axis, f.gyro_force_falloff3_rad1, f.gyro_force_falloff3_rad2);
	
	if (f.gyro_force_falloff4_type & GYRO_FALLOFF_TYPE_AREA)
		Gyro_Force_Update_AreaBounds(f, f.gyro_force_falloff4_axis);
	else if (f.gyro_force_falloff4_type & GYRO_FALLOFF_TYPE_CONE)
		Gyro_Force_Update_ConeBounds(f, f.gyro_force_falloff4_axis, f.gyro_force_falloff4_rad1, f.gyro_force_falloff4_rad2);
	
	
	//----- Debugging Output --------------------
	if ((GYRO_FORCEDEBUG > 1) && (f.gyro_force_rangescalerate == 0.0))
	{
		gyro_framedebug = TRUE;
		bprint("Gyro Debug: Bounding box calculated for \"");
		bprint(f.classname);
		bprint("\"\nX: ");
		bprint(ftos(f.gyro_force_bounds_x));
		bprint(", Y: ");
		bprint(ftos(f.gyro_force_bounds_y));
		bprint(", Z: ");
		bprint(ftos(f.gyro_force_bounds_z));
		bprint("\n");
	}
};


//----- Detach a Force from it's Previous Owner --------------------
void(entity f) Gyro_Force_Detach =
{
	//----- Update Host and Origin --------------------
	if ((f.gyro_force_attach.modelindex != 0) && (f.gyro_force_attach.origin != '0 0 0'))
		f.origin = f.gyro_force_attach.origin;
	f.gyro_force_attach = world;
	
	//----- Debug Info --------------------
	if (GYRO_FORCEDEBUG > 1)
	{
		gyro_framedebug = TRUE;
		bprint("Gyro Debug: Force has been detached \"");
		bprint(f.classname);
		bprint("\"\n");
	}
};


//----- Attach the Force to an Entity --------------------
void(entity f, entity e) Gyro_Force_Attach =
{
	//----- Detatch if Target is World --------------------
	if (e == world)
		return Gyro_Force_Detach(f);
	
	//----- Set Entity e as Host Entity --------------------
	f.gyro_force_attach = e;
	if (GYRO_FORCEDEBUG > 1)
	{
		gyro_framedebug = TRUE;
		bprint("Gyro Debug: Force has been attached \"");
		bprint(f.classname);
		bprint("\"\nOwner: \"");
		bprint(e.classname);
		bprint("\"\n");
	}
};


//----- Assign an Ignore Entity to a Force --------------------
void(entity f, entity e) Gyro_Force_Ignore =
{
	//----- Set Entity e as Owner --------------------
	f.gyro_force_ignore = e;
	if (GYRO_FORCEDEBUG > 1)
	{
		gyro_framedebug = TRUE;
		bprint("Gyro Debug: Force is ignoring \"");
		bprint(f.classname);
		bprint("\"\nOwner: \"");
		bprint(e.classname);
		bprint("\"\n");
	}
};



//============================================================
//===== Controlling Object Force-Channels ====================
//============================================================

//----- Set an Channels for a Force to Respond to --------------------
void(entity f, float channels) Gyro_Force_SetChannels =
{
	f.gyro_force_channels = channels;
};

//----- Add Channels to an Object --------------------
void(entity f, float channels) Gyro_Force_AddChannels =
{
	f.gyro_force_channels = f.gyro_force_channels | channels;
};

//----- Remove Channels from an Object --------------------
void(entity f, float channels) Gyro_Force_RemoveChannels =
{
	f.gyro_force_channels = f.gyro_force_channels - (f.gyro_force_channels & channels);
};



//============================================================
//===== Power and Range Scaling and Decay ====================
//============================================================

//----- Directly Set the Force Range Scale --------------------
void(entity f, float scale) Gyro_Force_SetRangeScale =
{
	//----- Not Allowed Zero or Negative Scales --------------------
	if (scale <= 0.0)
	{
		if (GYRO_FORCEDEBUG > 0)
		{
			gyro_framedebug = TRUE;
			bprint("Gyro Warning: Range scale not set for \"");
			bprint(f.classname);
			bprint("\"\nScale may not be a zero or negative value\n");
		}
		return;
	}
	
	//----- Scale Force and Flag for Update --------------------
	f.gyro_force_rangescale = scale;
	f.gyro_force_update = TRUE;
	
	//----- Debug Message --------------------
	if (GYRO_FORCEDEBUG > 1)
	{
		gyro_framedebug = TRUE;
		bprint("Gyro Debug: Range scale set for \"");
		bprint(f.classname);
		bprint("\"\nScale: ");
		bprint(ftos(scale));
		bprint("\n");
	}
};

//----- Define a Growth/Decay rate for Range Scale --------------------
void(entity f, float scalerate) Gyro_Force_SetRangeScaleRate =
{
	//----- Set Scale Rate on Force Entity --------------------
	f.gyro_force_rangescalerate = scalerate;
	
	//----- Debug Message --------------------
	if (GYRO_FORCEDEBUG > 1)
	{
		gyro_framedebug = TRUE;
		bprint("Gyro Debug: Range scale rate set for \"");
		bprint(f.classname);
		bprint("\"\nScale rate: ");
		bprint(ftos(scalerate));
		bprint("\n");
	}
};

//----- Direct Access to the Scale of a Force's General Power --------------------
void(entity f, float scale) Gyro_Force_SetPowerScale =
{
	//----- Not Allowed Zero or Negative Scales --------------------
	if (scale <= 0.0)
	{
		if (GYRO_FORCEDEBUG > 0)
		{
			gyro_framedebug = TRUE;
			bprint("Gyro Warning: Power scale not set for \"");
			bprint(f.classname);
			bprint("\"\nScale may not be a zero or negative value\n");
		}
		return;
	}
	
	//----- Set the Force's Power Scaler --------------------
	f.gyro_force_powerscale = scale;
	
	//----- Debug Message --------------------
	if (GYRO_FORCEDEBUG > 1)
	{
		gyro_framedebug = TRUE;
		bprint("Gyro Debug: Power scale set for \"");
		bprint(f.classname);
		bprint("\"\nScale: ");
		bprint(ftos(scale));
		bprint("\n");
	}
};

//----- Adjustment Rate of a Force's Power Scale --------------------
void(entity f, float scalerate) Gyro_Force_SetPowerScaleRate =
{
	//----- Set Scale Rate on Force Entity --------------------
	f.gyro_force_powerscalerate = scalerate;
	
	//----- Debug Message --------------------
	if (GYRO_FORCEDEBUG > 1)
	{
		gyro_framedebug = TRUE;
		bprint("Gyro Debug: Power scale rate set for \"");
		bprint(f.classname);
		bprint("\"\nScale rate: ");
		bprint(ftos(scalerate));
		bprint("\n");
	}
};


//============================================================
//===== Assigning Special Flags to Forces ====================
//============================================================

//----- Clear All Propeties from a Force --------------------
void(entity f) Gyro_Force_ClearProperties =
{
	f.gyro_force_flags = 0;
	if (GYRO_FORCEDEBUG > 1)
	{
		gyro_framedebug = TRUE;
		bprint("Gyro Debug: All properties removed from \"");
		bprint(f.classname);
		bprint("\"\n");
	}
};

	
//----- Instant Force only lasts One Gyro Frame --------------------
void(entity f) Gyro_Force_AddProperty_Instant =
{
	f.gyro_force_flags = f.gyro_force_flags | GYRO_FORCEFLAG_INSTANT;
	if (GYRO_FORCEDEBUG > 1)
	{
		gyro_framedebug = TRUE;
		bprint("Gyro Debug: Instant property added to \"");
		bprint(f.classname);
		bprint("\"\n");
	}
};

//----- Removal of Instant Force Property --------------------
void(entity f) Gyro_Force_RemoveProperty_Instant =
{
	f.gyro_force_flags = f.gyro_force_flags - (f.gyro_force_flags & GYRO_FORCEFLAG_INSTANT);
	if (GYRO_FORCEDEBUG > 1)
	{
		gyro_framedebug = TRUE;
		bprint("Gyro Debug: Instant property removed from \"");
		bprint(f.classname);
		bprint("\"\n");
	}
};


//----- Instruct Force to Ignore Obstructing Walls --------------------
void(entity f) Gyro_Force_AddProperty_IgnoreWalls =
{
	f.gyro_force_flags = f.gyro_force_flags | GYRO_FORCEFLAG_IGNOREWALLS;
	if (GYRO_FORCEDEBUG > 1)
	{
		gyro_framedebug = TRUE;
		bprint("Gyro Debug: Ignore-walls property added to \"");
		bprint(f.classname);
		bprint("\"\n");
	}
};

//----- Stop Force from Ignoring Obstructing Walls --------------------
void(entity f) Gyro_Force_RemoveProperty_IgnoreWalls =
{
	f.gyro_force_flags = f.gyro_force_flags - (f.gyro_force_flags & GYRO_FORCEFLAG_IGNOREWALLS);
	if (GYRO_FORCEDEBUG > 1)
	{
		gyro_framedebug = TRUE;
		bprint("Gyro Debug: Ignore-walls property removed from \"");
		bprint(f.classname);
		bprint("\"\n");
	}
};


//----- Force Only Effects Objects not Underwater --------------------
void(entity f) Gyro_Force_AddProperty_AirOnly =
{
	f.gyro_force_flags = f.gyro_force_flags | GYRO_FORCEFLAG_AIRONLY;
	if (GYRO_FORCEDEBUG > 1)
	{
		gyro_framedebug = TRUE;
		bprint("Gyro Debug: Air-only property added to \"");
		bprint(f.classname);
		bprint("\"\n");
	}
};

//----- Remove Air-Only Force Property --------------------
void(entity f) Gyro_Force_RemoveProperty_AirOnly =
{
	f.gyro_force_flags = f.gyro_force_flags - (f.gyro_force_flags & GYRO_FORCEFLAG_AIRONLY);
	if (GYRO_FORCEDEBUG > 1)
	{
		gyro_framedebug = TRUE;
		bprint("Gyro Debug: Air-only property removed from \"");
		bprint(f.classname);
		bprint("\"\n");
	}
};


//----- Force Only Effects Objects in Water, Slime or Lava --------------------
void(entity f) Gyro_Force_AddProperty_WaterOnly =
{
	f.gyro_force_flags = f.gyro_force_flags | GYRO_FORCEFLAG_WATERONLY;
	if (GYRO_FORCEDEBUG > 1)
	{
		gyro_framedebug = TRUE;
		bprint("Gyro Debug: Water-only property added to \"");
		bprint(f.classname);
		bprint("\"\n");
	}
};

//----- Remove Water-Only Property from Force --------------------
void(entity f) Gyro_Force_RemoveProperty_WaterOnly =
{
	f.gyro_force_flags = f.gyro_force_flags - (f.gyro_force_flags & GYRO_FORCEFLAG_WATERONLY);
	if (GYRO_FORCEDEBUG > 1)
	{
		gyro_framedebug = TRUE;
		bprint("Gyro Debug: Water-only property removed from \"");
		bprint(f.classname);
		bprint("\"\n");
	}
};


//----- Force will only Affect Objects on the Ground --------------------
void(entity f) Gyro_Force_AddProperty_GroundPound =
{
	f.gyro_force_flags = f.gyro_force_flags | GYRO_FORCEFLAG_GROUNDPOUND;
	if (GYRO_FORCEDEBUG > 1)
	{
		gyro_framedebug = TRUE;
		bprint("Gyro Debug: Ground-pound property added to \"");
		bprint(f.classname);
		bprint("\"\n");
	}
};

//----- Remove Ground-Pound Property --------------------
void(entity f) Gyro_Force_RemoveProperty_GroundPound =
{
	f.gyro_force_flags = f.gyro_force_flags - (f.gyro_force_flags & GYRO_FORCEFLAG_GROUNDPOUND);
	if (GYRO_FORCEDEBUG > 1)
	{
		gyro_framedebug = TRUE;
		bprint("Gyro Debug: Ground-pound property removed from \"");
		bprint(f.classname);
		bprint("\"\n");
	}
};


//----- Force is not Removed Along with Attach Host --------------------
void(entity f) Gyro_Force_AddProperty_Persistent =
{
	f.gyro_force_flags = f.gyro_force_flags | GYRO_FORCEFLAG_PERSISTENT;
	if (GYRO_FORCEDEBUG > 1)
	{
		gyro_framedebug = TRUE;
		bprint("Gyro Debug: Persistent property added to \"");
		bprint(f.classname);
		bprint("\"\n");
	}
};

//----- Remove Persistence Property --------------------
void(entity f) Gyro_Force_RemoveProperty_Persistent =
{
	f.gyro_force_flags = f.gyro_force_flags - (f.gyro_force_flags & GYRO_FORCEFLAG_PERSISTENT);
	if (GYRO_FORCEDEBUG > 1)
	{
		gyro_framedebug = TRUE;
		bprint("Gyro Debug: Persistent property removed from \"");
		bprint(f.classname);
		bprint("\"\n");
	}
};



//==============================================================
//===== Falloff Application to Empty Forces ====================
//==============================================================

//----- General Force Falloff Applicator --------------------
float(entity f, float falltype, vector fallaxis, float rad1, float rad2) Gyro_Force_ApplyFalloff =
{
	//----- Entity is not a Force --------------------
	if (!f.gyro_forcelist_inlist)
	{
		if (GYRO_FORCEDEBUG > 0)
		{
			gyro_framedebug = TRUE;
			bprint("Gyro Warning: Falloff not applied to \"");
			bprint(f.classname);
			bprint("\"\nThe entity is not recognised as a force\n");
			return 0;
		}
	}
	
	//----- Correct Negative Falloff Axis --------------------
	if (falltype & GYRO_FALLOFF_TYPE_AREA)
	{
		if (fallaxis_x < 0.0) fallaxis_x = 0.0 - fallaxis_x;
		if (fallaxis_y < 0.0) fallaxis_y = 0.0 - fallaxis_y;
		if (fallaxis_z < 0.0) fallaxis_z = 0.0 - fallaxis_z;
	}
	
	//----- Apply to First Falloff Slot --------------------
	if (!f.gyro_force_falloff1_type)
	{
		f.gyro_force_falloff1_type = falltype;
		f.gyro_force_falloff1_axis = fallaxis;
		f.gyro_force_falloff1_rad1 = rad1;
		f.gyro_force_falloff1_rad2 = rad2;
		f.gyro_force_update = TRUE;
		return 1;
	}
	
	//----- Apply to Second Falloff Slot --------------------
	else if (!f.gyro_force_falloff2_type)
	{
		f.gyro_force_falloff2_type = falltype;
		f.gyro_force_falloff2_axis = fallaxis;
		f.gyro_force_falloff2_rad1 = rad1;
		f.gyro_force_falloff2_rad2 = rad2;
		f.gyro_force_update = TRUE;
		return 1;
	}
	
	//----- Apply to Third Falloff Slot --------------------
	else if (!f.gyro_force_falloff3_type)
	{
		f.gyro_force_falloff3_type = falltype;
		f.gyro_force_falloff3_axis = fallaxis;
		f.gyro_force_falloff3_rad1 = rad1;
		f.gyro_force_falloff3_rad2 = rad2;
		f.gyro_force_update = TRUE;
		return 1;
	}
	
	//----- Apply to Fourth Falloff Slot --------------------
	else if (!f.gyro_force_falloff4_type)
	{
		f.gyro_force_falloff4_type = falltype;
		f.gyro_force_falloff4_axis = fallaxis;
		f.gyro_force_falloff4_rad1 = rad1;
		f.gyro_force_falloff4_rad2 = rad2;
		f.gyro_force_update = TRUE;
		return 1;
	}
	
	//----- No Slots Left: Falloff not Applied --------------------
	if (GYRO_FORCEDEBUG > 0)
	{
		gyro_framedebug = TRUE;
		bprint("Gyro Warning: Falloff not applied to \"");
		bprint(f.classname);
		bprint("\"\nThe force cannot support more falloff controllers\n");
	}
	return 0;
};


//----- Area-Based Falloff Component --------------------
void(entity f, vector falloff_area, float falloff_flags) Gyro_Force_ApplyFalloff_Area =
{
	//----- Apply Falloff --------------------
	if (Gyro_Force_ApplyFalloff(f, GYRO_FALLOFF_TYPE_AREA | falloff_flags, falloff_area, 0, 0))
	{
		//----- Debug Message on Success --------------------
		if (GYRO_FORCEDEBUG > 1)
		{
			gyro_framedebug = TRUE;
			bprint("Gyro Debug: Area falloff applied to \"");
			bprint(f.classname);
			bprint("\"\nArea: ");
			bprint(vtos(falloff_area));
			bprint("\n");
		}
	}
};


//----- Cone/Cylinder Falloff Component --------------------
void(entity f, vector falloff_dir, float rad1, float rad2, float falloff_flags) Gyro_Force_ApplyFalloff_Cone =
{
	//----- Apply Falloff --------------------
	if (Gyro_Force_ApplyFalloff(f, GYRO_FALLOFF_TYPE_CONE | falloff_flags, falloff_dir, rad1, rad2))
	{
		//----- Debug Message on Success --------------------
		if (GYRO_FORCEDEBUG > 1)
		{
			gyro_framedebug = TRUE;
			bprint("Gyro Debug: Area falloff applied to \"");
			bprint(f.classname);
			bprint("\"\nVec: ");
			bprint(vtos(falloff_dir));
			bprint(", Start: ");
			bprint(ftos(rad1));
			bprint(", End: ");
			bprint(ftos(rad2));
			bprint("\n");
		}
	}
};


//----- User-Level Area Falloff Application --------------------
void(entity f, vector falloff_area) Gyro_Force_ApplyFalloff_AreaLinear =
	{ Gyro_Force_ApplyFalloff_Area(f, falloff_area, GYRO_FALLOFF_METHOD_LINEAR); };

void(entity f, vector falloff_area) Gyro_Force_ApplyFalloff_AreaQuadratic =
	{ Gyro_Force_ApplyFalloff_Area(f, falloff_area, GYRO_FALLOFF_METHOD_QUADRATIC); };

void(entity f, vector falloff_area) Gyro_Force_ApplyFalloff_AreaConstant =
	{ Gyro_Force_ApplyFalloff_Area(f, falloff_area, GYRO_FALLOFF_METHOD_CONSTANT); };

void(entity f, vector falloff_dir, float rad1, float rad2) Gyro_Force_ApplyFalloff_ConeLinear =
	{ Gyro_Force_ApplyFalloff_Cone(f, falloff_dir, rad1, rad2, GYRO_FALLOFF_METHOD_LINEAR); };

void(entity f, vector falloff_dir, float rad1, float rad2) Gyro_Force_ApplyFalloff_ConeQuadratic =
	{ Gyro_Force_ApplyFalloff_Cone(f, falloff_dir, rad1, rad2, GYRO_FALLOFF_METHOD_QUADRATIC); };

void(entity f, vector falloff_dir, float rad1, float rad2) Gyro_Force_ApplyFalloff_ConeConstant =
	{ Gyro_Force_ApplyFalloff_Cone(f, falloff_dir, rad1, rad2, GYRO_FALLOFF_METHOD_CONSTANT); };


//----- Set Falloff Combination Method to Multiply --------------------
void(entity f) Gyro_Force_FalloffCombine_Multiply =
{
	f.gyro_force_falloff_combine = GYRO_FALLOFF_COMBINE_MULTIPLY;
	if (GYRO_FORCEDEBUG > 1)
	{
		gyro_framedebug = TRUE;
		bprint("Gyro Debug: Falloff combination set for \"");
		bprint(f.classname);
		bprint("\"\nCombination method: Multiply\n");
	}
};

//----- Set Falloff Combination Method to Minimum --------------------
void(entity f) Gyro_Force_FalloffCombine_Minimum =
{
	f.gyro_force_falloff_combine = GYRO_FALLOFF_COMBINE_MINIMUM;
	if (GYRO_FORCEDEBUG > 1)
	{
		gyro_framedebug = TRUE;
		bprint("Gyro Debug: Falloff combination set for \"");
		bprint(f.classname);
		bprint("\"\nCombination method: Minimum\n");
	}
};

//----- Set Falloff Combination Method to Subtract --------------------
void(entity f) Gyro_Force_FalloffCombine_Subtract =
{
	f.gyro_force_falloff_combine = GYRO_FALLOFF_COMBINE_SUBTRACT;
	if (GYRO_FORCEDEBUG > 1)
	{
		gyro_framedebug = TRUE;
		bprint("Gyro Debug: Falloff combination set for \"");
		bprint(f.classname);
		bprint("\"\nCombination method: Subtract\n");
	}
};



//======================================================
//===== Affector Component Creation ====================
//======================================================

//----- General Force Affector Applicator --------------------
float(entity f, float afftype, float affpower, float absolute, vector offset, vector axis, vector amodx, vector amody, vector amodz) Gyro_Force_ApplyAffector =
{
	//----- Entity is not a Force --------------------
	if (!f.gyro_forcelist_inlist)
	{
		if (GYRO_FORCEDEBUG > 0)
		{
			gyro_framedebug = TRUE;
			bprint("Gyro Warning: Affector not applied to \"");
			bprint(f.classname);
			bprint("\"\nThe entity is not recognised as a force\n");
			return 0;
		}
	}
	
	//----- Apply to First Affector Slot --------------------
	if (!f.gyro_force_affector1_type)
	{
		f.gyro_force_affector1_type = afftype;
		f.gyro_force_affector1_power = affpower;
		f.gyro_force_affector1_absolute = absolute;
		f.gyro_force_affector1_offset = offset;
		f.gyro_force_affector1_axis = axis;
		f.gyro_force_affector1_modx = amodx;
		f.gyro_force_affector1_mody = amody;
		f.gyro_force_affector1_modz = amodz;
		f.gyro_force_update = TRUE;
		return 1;
	}
	
	//----- Apply to Second Affector Slot --------------------
	else if (!f.gyro_force_affector2_type)
	{
		f.gyro_force_affector2_type = afftype;
		f.gyro_force_affector2_power = affpower;
		f.gyro_force_affector2_absolute = absolute;
		f.gyro_force_affector2_offset = offset;
		f.gyro_force_affector2_axis = axis;
		f.gyro_force_affector2_modx = amodx;
		f.gyro_force_affector2_mody = amody;
		f.gyro_force_affector2_modz = amodz;
		f.gyro_force_update = TRUE;
		return 1;
	}
	
	//----- Apply to Third Affector Slot --------------------
	else if (!f.gyro_force_affector3_type)
	{
		f.gyro_force_affector3_type = afftype;
		f.gyro_force_affector3_power = affpower;
		f.gyro_force_affector3_absolute = absolute;
		f.gyro_force_affector3_offset = offset;
		f.gyro_force_affector3_axis = axis;
		f.gyro_force_affector3_modx = amodx;
		f.gyro_force_affector3_mody = amody;
		f.gyro_force_affector3_modz = amodz;
		f.gyro_force_update = TRUE;
		return 1;
	}
	
	//----- Apply to Fourth Affector Slot --------------------
	else if (!f.gyro_force_affector4_type)
	{
		f.gyro_force_affector4_type = afftype;
		f.gyro_force_affector4_power = affpower;
		f.gyro_force_affector4_absolute = absolute;
		f.gyro_force_affector4_offset = offset;
		f.gyro_force_affector4_axis = axis;
		f.gyro_force_affector4_modx = amodx;
		f.gyro_force_affector4_mody = amody;
		f.gyro_force_affector4_modz = amodz;
		f.gyro_force_update = TRUE;
		return 1;
	}
	
	//----- No Slots Left: Affector not Applied --------------------
	if (GYRO_FORCEDEBUG > 0)
	{
		gyro_framedebug = TRUE;
		bprint("Gyro Warning: Affector not applied to \"");
		bprint(f.classname);
		bprint("\"\nThe force cannot support more affectors\n");
	}
	return 0;
};


//----- Force Radiating from a Point with XYZ Modification --------------------
void(entity f, vector org_offset, vector aff_axis, float aff_power, float absolute, vector modx, vector mody, vector modz) Gyro_Force_ApplyAffector_PointMod =
{
	//----- Attempt to Apply Affector --------------------
	if (Gyro_Force_ApplyAffector(f, GYRO_AFFECTOR_POINTMOD, aff_power, absolute, org_offset, aff_axis, modx, mody, modz))
	{
		//----- Debug Message on Success --------------------
		if (GYRO_FORCEDEBUG > 1)
		{
			gyro_framedebug = TRUE;
			bprint("Gyro Debug: Point-Mod affector applied to \"");
			bprint(f.classname);
			bprint("\"\nStrength: ");
			bprint(ftos(aff_power));
			bprint("\n");
		}
	}
};


//----- Simple Force Affector Radiating from a Point --------------------
void(entity f, vector org_offset, vector aff_axis, float aff_power, float absolute) Gyro_Force_ApplyAffector_Point =
{
	//----- Attempt to Apply Affector --------------------
	if (Gyro_Force_ApplyAffector(f, GYRO_AFFECTOR_POINT, aff_power, absolute, org_offset, aff_axis, '0 0 0', '0 0 0', '0 0 0'))
	{
		//----- Debug Message on Success --------------------
		if (GYRO_FORCEDEBUG > 1)
		{
			gyro_framedebug = TRUE;
			bprint("Gyro Debug: Point affector applied to \"");
			bprint(f.classname);
			bprint("\"\nStrength: ");
			bprint(ftos(aff_power));
			bprint("\n");
		}
	}
};


//----- A Simple Sphere Force based around the Origin --------------------
void(entity f, float aff_power, float absolute) Gyro_Force_ApplyAffector_Sphere =
{
	Gyro_Force_ApplyAffector_Point(f, '0 0 0', '1 1 1', aff_power, absolute);
};


//----- A Simple Force that Pushes in a Single Direction --------------------
void(entity f, vector aff_axis, float aff_power, float absolute) Gyro_Force_ApplyAffector_Directional =
{
	//----- Attempt to Apply Affector --------------------
	aff_axis = normalize(aff_axis);
	if (Gyro_Force_ApplyAffector(f, GYRO_AFFECTOR_DIRECTIONAL, aff_power, absolute, '0 0 0', aff_axis, '0 0 0', '0 0 0', '0 0 0'))
	{
		//----- Debug Message on Success --------------------
		if (GYRO_FORCEDEBUG > 1)
		{
			gyro_framedebug = TRUE;
			bprint("Gyro Debug: Directional affector applied to \"");
			bprint(f.classname);
			bprint("\"\nStrength: ");
			bprint(ftos(aff_power));
			bprint("\n");
		}
	}
};


//----- Anti-Gravity Force Lifts Objects up by Gravity Level --------------------
void(entity f, float gravpower, float absolute) Gyro_Force_ApplyAffector_AntiGravity =
{
	//----- Attempt to Apply Affector --------------------
	if (Gyro_Force_ApplyAffector(f, GYRO_AFFECTOR_ANTIGRAVITY, gravpower, absolute, '0 0 0', '1 1 1', '0 0 0', '0 0 0', '0 0 0'))
	{
		//----- Debug Message on Success --------------------
		if (GYRO_FORCEDEBUG > 1)
		{
			gyro_framedebug = TRUE;
			bprint("Gyro Debug: Anti-gravity affector applied to \"");
			bprint(f.classname);
			bprint("\"\nStrength: ");
			bprint(ftos(gravpower));
			bprint("\n");
		}
	}
};


//----- Resistive Force Slows an Object Based on Mass --------------------
void(entity f, vector aff_axis, float respower, float absolute) Gyro_Force_ApplyAffector_Resistance =
{
	//----- Attempt to Apply Affector --------------------
	if (Gyro_Force_ApplyAffector(f, GYRO_AFFECTOR_RESISTANCE, respower, absolute, '0 0 0', aff_axis, '0 0 0', '0 0 0', '0 0 0'))
	{
		//----- Debug Message on Success --------------------
		if (GYRO_FORCEDEBUG > 1)
		{
			gyro_framedebug = TRUE;
			bprint("Gyro Debug: Resistance affector applied to \"");
			bprint(f.classname);
			bprint("\"\nStrength: ");
			bprint(ftos(respower));
			bprint("\n");
		}
	}
};



//=======================================================
//===== Force Solvers and Subsystems ====================
//=======================================================

//----- Calculate a Single Falloff Component Result --------------------
float(vector org_diff, float fall_type, vector fall_vector) Gyro_Force_Solver_Falloff =
{
	//----- Basic Falloff Solvers --------------------
	if (fall_type & GYRO_FALLOFF_TYPE_AREA)
	{
		//----- Early Exit for Zero Falloff --------------------
		if (fall_vector == '0 0 0')
			return 1.0;
		
		//----- Bring Offset Vector X into 0..1 Range --------------------
		if (fall_vector_x == 0.0)
			org_diff_x = 0.0;
		else
			org_diff_x = org_diff_x / fall_vector_x;
		
		//----- Bring Offset Vector Y into 0..1 Range --------------------
		if (fall_vector_y == 0.0)
			org_diff_y = 0.0;
		else
			org_diff_y = org_diff_y / fall_vector_y;
		
		//----- Bring Offset Vector Z into 0..1 Range --------------------
		if (fall_vector_z == 0.0)
			org_diff_z = 0.0;
		else
			org_diff_z = org_diff_z / fall_vector_z;
		
		//----- Compute and Return Falloff from Transformed Offset --------------------
		local float	fallout;
		fallout = 1.0 - vlen(org_diff);
		if (fallout < 0.0)
			return 0.0;
		if (fall_type & GYRO_FALLOFF_METHOD_CONSTANT)
			return 1.0;
		else if (fall_type & GYRO_FALLOFF_METHOD_QUADRATIC)
			return fallout * fallout;
		return fallout;
	}
};


//----- Calculate an Area Falloff Component Result --------------------
float(vector org_diff, float fall_type, vector fall_vector) Gyro_Force_Solver_AreaFalloff =
{
	//----- Early Exit for Zero Falloff --------------------
	if (fall_vector == '0 0 0')
		return 1.0;
	
	//----- Bring Offset Vector X into 0..1 Range --------------------
	if (fall_vector_x == 0.0)
		org_diff_x = 0.0;
	else
		org_diff_x = org_diff_x / fall_vector_x;
	
	//----- Bring Offset Vector Y into 0..1 Range --------------------
	if (fall_vector_y == 0.0)
		org_diff_y = 0.0;
	else
		org_diff_y = org_diff_y / fall_vector_y;
	
	//----- Bring Offset Vector Z into 0..1 Range --------------------
	if (fall_vector_z == 0.0)
		org_diff_z = 0.0;
	else
		org_diff_z = org_diff_z / fall_vector_z;
	
	//----- Compute and Return Falloff from Transformed Offset --------------------
	local float	fallout;
	fallout = 1.0 - vlen(org_diff);
	if (fallout < 0.0)
		return 0.0;
	if (fall_type & GYRO_FALLOFF_METHOD_CONSTANT)
		return 1.0;
	else if (fall_type & GYRO_FALLOFF_METHOD_QUADRATIC)
		return fallout * fallout;
	return fallout;
};


//----- Calculate the Result for a Conical Falloff Component --------------------
float(vector org_diff, float fall_type, vector fall_vector, float rad1, float rad2) Gyro_Force_Solver_ConeFalloff =
{
	//----- Early Exit for Zero Falloff --------------------
	if (fall_vector == '0 0 0')
		return 0.0;
	
	//----- Project Point onto Axis Vector --------------------
	local float	dotprodlen;
	dotprodlen = org_diff * normalize(fall_vector);
	if (dotprodlen < 0.0)
		return 0.0;
	
	//----- Compute Projected Distance % along Axis --------------------
	local float	axisdistperc;
	axisdistperc = dotprodlen / vlen(fall_vector);
	if (axisdistperc > 1.0)
		return 0.0;
	
	//----- Compute Vector Dist Perpendicular to Axis --------------------
	local float	perpdist;
	perpdist = vlen((fall_vector * axisdistperc) - org_diff);
	
	//----- Find Radius of Cone at Perpendicular Intersection --------------------
	local float	radlen;
	radlen = (rad1 * (1 - axisdistperc)) + (rad2 * axisdistperc);
	if (perpdist > radlen)
		return 0.0;
	
	//--- Return Falloff Value
	local float	fallout;
	fallout = 1 - (perpdist / radlen);
	if (fall_type & GYRO_FALLOFF_METHOD_CONSTANT)
		return 1.0;
	else if (fall_type & GYRO_FALLOFF_METHOD_QUADRATIC)
		return fallout * fallout;
	return fallout;
};


//----- Apply a Single Affector Component to an Object --------------------
void(entity f, entity e, float atype, float apower, float absolute, vector aoffset, vector aaxis, vector amodx, vector amody, vector amodz) Gyro_Force_Solver_Affector =
{
	//----- Radial Point-Based Affectors --------------------
	if ((atype == GYRO_AFFECTOR_POINT) || (atype == GYRO_AFFECTOR_POINTMOD))
	{
		//----- Early Exit Conditions --------------------
		if (apower == 0)
			return;
		if (aaxis == '0 0 0')
			return;
		
		//----- Calculate Base Difference Vector --------------------
		local vector	off_diff;
		off_diff = normalize(e.origin - (f.origin + aoffset));
		
		//----- Apply Axis-Scaling Vector to Difference --------------------
		if (aaxis != '1 1 1')
		{
			off_diff_x = off_diff_x * aaxis_x;
			off_diff_y = off_diff_y * aaxis_y;
			off_diff_z = off_diff_z * aaxis_z;
		}
		
		//----- Apply Individual Vector Modifications to Difference --------------------
		if (atype == GYRO_AFFECTOR_POINTMOD)
		{
			local vector	off_diff_temp;
			off_diff_temp_x = (off_diff_x * amodx_x) + (off_diff_y * amodx_y) + (off_diff_z * amodx_z);
			off_diff_temp_y = (off_diff_x * amody_x) + (off_diff_y * amody_y) + (off_diff_z * amody_z);
			off_diff_temp_z = (off_diff_x * amodz_x) + (off_diff_y * amodz_y) + (off_diff_z * amodz_z);
			off_diff = off_diff_temp;
		}
		
		//----- Update Object's Motion Effect --------------------
		if (absolute)
			apower = apower * e.gyro_object_mass;
		if (f.gyro_force_flags & GYRO_FORCEFLAG_INSTANT)
			e.gyro_velocityeffect = e.gyro_velocityeffect + (off_diff * (apower / e.gyro_object_mass) * f.gyro_force_powerscale * GYRO_POWERCONSTANT);
		else
			e.gyro_velocityeffect = e.gyro_velocityeffect + (off_diff * (apower / e.gyro_object_mass) * f.gyro_force_powerscale * GYRO_POWERCONSTANT * GYRO_TICKRATE);
	}
	
	//----- Single Absolute Direction Affector --------------------
	else if (atype == GYRO_AFFECTOR_DIRECTIONAL)
	{
		//----- Early Exit Conditions --------------------
		if (apower == 0)
			return;
		if (aaxis == '0 0 0')
			return;
		
		//----- Update Object's Motion Effect --------------------
		if (absolute)
			apower = apower * e.gyro_object_mass;
		if (f.gyro_force_flags & GYRO_FORCEFLAG_INSTANT)
			e.gyro_velocityeffect = e.gyro_velocityeffect + (aaxis * (apower / e.gyro_object_mass) * f.gyro_force_powerscale * GYRO_POWERCONSTANT);
		else
			e.gyro_velocityeffect = e.gyro_velocityeffect + (aaxis * (apower / e.gyro_object_mass) * f.gyro_force_powerscale * GYRO_POWERCONSTANT * GYRO_TICKRATE);
	}
	
	//----- Simple Anti-Gravity Affector --------------------
	else if (atype == GYRO_AFFECTOR_ANTIGRAVITY)
	{
		if (apower <= 0)
			return;
		if (absolute)
			apower = apower * e.gyro_object_mass;
		e.gyro_antigravityeffect = e.gyro_antigravityeffect + ((apower / e.gyro_object_mass) * f.gyro_force_powerscale);
	}
	
	//----- Object Motion Resistance Affector --------------------
	else if (atype == GYRO_AFFECTOR_RESISTANCE)
	{
		//----- Calculate Base Dampening Multiplier --------------------
		if (apower <= 0)
			return;
		if (absolute)
			apower = apower * e.gyro_object_mass;
		local float	resistpower;
		resistpower = 1.0 / (((apower / e.gyro_object_mass) * 8.0) + 1.0);
		if (!f.gyro_force_flags & GYRO_FORCEFLAG_INSTANT)
			resistpower = Gyro_PowerEstimation(resistpower, GYRO_TICKRATE);
		
		//----- Apply Multiplier to each Axis --------------------
		e.gyro_dampeningeffect_x = e.gyro_dampeningeffect_x * (1.0 - ((1.0 - resistpower) * aaxis_x));
		e.gyro_dampeningeffect_y = e.gyro_dampeningeffect_y * (1.0 - ((1.0 - resistpower) * aaxis_y));
		e.gyro_dampeningeffect_z = e.gyro_dampeningeffect_z * (1.0 - ((1.0 - resistpower) * aaxis_z));
		e.gyro_adampeningeffect = e.gyro_adampeningeffect * resistpower;
	}
};


//----- Primary Solver Applies Force f to Entity e --------------------
void(entity f, entity e) Gyro_Force_Solver =
{
	//----- Don't Affect Ignored Entity --------------------
	if (e == f.gyro_force_ignore)
		return;
	
	//----- Air-Only Check Disallows Water-Bound Objects --------------------
	if (f.gyro_force_flags & GYRO_FORCEFLAG_AIRONLY)
	{
		local float	pconts1;
		pconts1 = pointcontents(e.origin);
		if ((pconts1 == -3) || (pconts1 == -4) || (pconts1 == -5))
			return;
	}
	
	//----- Water-Only will not Affect Objects not Underwater --------------------
	if (f.gyro_force_flags & GYRO_FORCEFLAG_WATERONLY)
	{
		local float	pconts2;
		pconts2 = pointcontents(e.origin);
		if (!((pconts2 == -3) || (pconts2 == -4) || (pconts2 == -5)))
			return;
	}
	
	//----- Ground-Pound only Affects Grounded Objects --------------------
	if (f.gyro_force_flags & GYRO_FORCEFLAG_GROUNDPOUND)
	{
		if (!e.flags & FL_ONGROUND)
			return;
	}
	
	//----- Ignore Zero-Scaled Forces --------------------
	if (f.gyro_force_rangescale == 0.0)
		return;
	if (f.gyro_force_powerscale == 0.0)
		return;
	
	//----- Check for Obstructions --------------------
	if (!f.gyro_force_flags & GYRO_FORCEFLAG_IGNOREWALLS)
	{
		traceline(f.origin, e.origin, TRUE, world);
		if (trace_fraction < 1.0)
			return;
	}
	
	//----- Pre-compute Falloff Variables --------------------
	local float	totalfalloff, fall1, fall2, fall3, fall4;
	local vector	org_diff;
	org_diff = e.origin - f.origin;
	fall1 = 1.0;
	fall2 = 1.0;
	fall3 = 1.0;
	fall4 = 1.0;
	
	//----- Run a Solver for all Four Falloffs --------------------
	if (f.gyro_force_falloff1_type & GYRO_FALLOFF_TYPE_AREA)
		fall1 = Gyro_Force_Solver_AreaFalloff(org_diff, f.gyro_force_falloff1_type, f.gyro_force_falloff1_axis * f.gyro_force_rangescale);
	else if (f.gyro_force_falloff1_type & GYRO_FALLOFF_TYPE_CONE)
		fall1 = Gyro_Force_Solver_ConeFalloff(org_diff, f.gyro_force_falloff1_type, f.gyro_force_falloff1_axis * f.gyro_force_rangescale, f.gyro_force_falloff1_rad1 * f.gyro_force_rangescale, f.gyro_force_falloff1_rad2 * f.gyro_force_rangescale);
	
	if (f.gyro_force_falloff2_type & GYRO_FALLOFF_TYPE_AREA)
		fall2 = Gyro_Force_Solver_AreaFalloff(org_diff, f.gyro_force_falloff2_type, f.gyro_force_falloff2_axis * f.gyro_force_rangescale);
	else if (f.gyro_force_falloff2_type & GYRO_FALLOFF_TYPE_CONE)
		fall2 = Gyro_Force_Solver_ConeFalloff(org_diff, f.gyro_force_falloff1_type, f.gyro_force_falloff2_axis * f.gyro_force_rangescale, f.gyro_force_falloff2_rad1 * f.gyro_force_rangescale, f.gyro_force_falloff2_rad2 * f.gyro_force_rangescale);
	
	if (f.gyro_force_falloff3_type & GYRO_FALLOFF_TYPE_AREA)
		fall3 = Gyro_Force_Solver_AreaFalloff(org_diff, f.gyro_force_falloff3_type, f.gyro_force_falloff3_axis * f.gyro_force_rangescale);
	else if (f.gyro_force_falloff3_type & GYRO_FALLOFF_TYPE_CONE)
		fall3 = Gyro_Force_Solver_ConeFalloff(org_diff, f.gyro_force_falloff3_type, f.gyro_force_falloff3_axis * f.gyro_force_rangescale, f.gyro_force_falloff3_rad1 * f.gyro_force_rangescale, f.gyro_force_falloff3_rad2 * f.gyro_force_rangescale);
	
	if (f.gyro_force_falloff4_type & GYRO_FALLOFF_TYPE_AREA)
		fall4 = Gyro_Force_Solver_AreaFalloff(org_diff, f.gyro_force_falloff4_type, f.gyro_force_falloff4_axis * f.gyro_force_rangescale);
	else if (f.gyro_force_falloff4_type & GYRO_FALLOFF_TYPE_CONE)
		fall4 = Gyro_Force_Solver_ConeFalloff(org_diff, f.gyro_force_falloff4_type, f.gyro_force_falloff4_axis * f.gyro_force_rangescale, f.gyro_force_falloff4_rad1 * f.gyro_force_rangescale, f.gyro_force_falloff4_rad2 * f.gyro_force_rangescale);
	
	//----- Combine the Falloff Results --------------------
	if (f.gyro_force_falloff_combine == GYRO_FALLOFF_COMBINE_MULTIPLY)
		totalfalloff = fall1 * fall2 * fall3 * fall4;
	else if (f.gyro_force_falloff_combine == GYRO_FALLOFF_COMBINE_MINIMUM)
	{
		if (fall1 > fall2)
			fall1 = fall2;
		if (fall3 > fall4)
			fall3 = fall4;
		if (fall1 < fall3)
			totalfalloff = fall1;
		else
			totalfalloff = fall3;
	}
	else if (f.gyro_force_falloff_combine == GYRO_FALLOFF_COMBINE_SUBTRACT)
		totalfalloff = (fall1 + fall2 + fall3 + fall4) - 3.0;
	
	//----- Return if Falloff Nullifies Force --------------------
	if (totalfalloff <= 0.0)
		return;
	
	//----- Apply Affector Components to Object --------------------
	local vector	oldveleffect;
	oldveleffect = e.gyro_velocityeffect;
	if (f.gyro_force_affector1_type)
		Gyro_Force_Solver_Affector(f, e, f.gyro_force_affector1_type, f.gyro_force_affector1_power * totalfalloff, f.gyro_force_affector1_absolute, f.gyro_force_affector1_offset, f.gyro_force_affector1_axis, f.gyro_force_affector1_modx, f.gyro_force_affector1_mody, f.gyro_force_affector1_modz);
	if (f.gyro_force_affector2_type)
		Gyro_Force_Solver_Affector(f, e, f.gyro_force_affector2_type, f.gyro_force_affector2_power * totalfalloff, f.gyro_force_affector2_absolute, f.gyro_force_affector2_offset, f.gyro_force_affector2_axis, f.gyro_force_affector2_modx, f.gyro_force_affector2_mody, f.gyro_force_affector2_modz);
	if (f.gyro_force_affector3_type)
		Gyro_Force_Solver_Affector(f, e, f.gyro_force_affector3_type, f.gyro_force_affector3_power * totalfalloff, f.gyro_force_affector3_absolute, f.gyro_force_affector3_offset, f.gyro_force_affector3_axis, f.gyro_force_affector3_modx, f.gyro_force_affector3_mody, f.gyro_force_affector3_modz);
	if (f.gyro_force_affector4_type)
		Gyro_Force_Solver_Affector(f, e, f.gyro_force_affector4_type, f.gyro_force_affector4_power * totalfalloff, f.gyro_force_affector4_absolute, f.gyro_force_affector4_offset, f.gyro_force_affector4_axis, f.gyro_force_affector4_modx, f.gyro_force_affector4_mody, f.gyro_force_affector4_modz);
	
	//----- Call Object Feedback --------------------
	if (e.gyro_feedback)
	{
		gyro_feedback_name = f.classname;
		gyro_feedback_channels = f.gyro_force_channels & e.gyro_object_channels;
		if (f.gyro_force_flags & GYRO_FORCEFLAG_INSTANT)
			gyro_feedback_power = ((vlen(oldveleffect - e.gyro_velocityeffect)) / GYRO_POWERCONSTANT) * e.gyro_object_mass;
		else
			gyro_feedback_power = ((vlen(oldveleffect - e.gyro_velocityeffect) / GYRO_TICKRATE) / GYRO_POWERCONSTANT) * e.gyro_object_mass;
		Gyro_Object_CallFeedback(e);
	}
};



//=================================================
//===== Primary Force Iterator ====================
//=================================================

//----- Check if Entity e is within Force f's Bounds --------------------
float(entity f, entity e) Gyro_Force_CheckBounds =
{
	//----- Test X-Axis Bounds --------------------
	if (f.gyro_force_bounds_x > 0)
	{
		if (e.origin_x > f.gyro_force_boundsmax_x)
			return 0;
		if (e.origin_x < f.gyro_force_boundsmin_x)
			return 0;
	}
	
	//----- Test Y-Axis Bounds --------------------
	if (f.gyro_force_bounds_y > 0)
	{
		if (e.origin_y > f.gyro_force_boundsmax_y)
			return 0;
		if (e.origin_y < f.gyro_force_boundsmin_y)
			return 0;
	}
	
	//----- Test Z-Axis Bounds --------------------
	if (f.gyro_force_bounds_z > 0)
	{
		if (e.origin_z > f.gyro_force_boundsmax_z)
			return 0;
		if (e.origin_z < f.gyro_force_boundsmin_z)
			return 0;
	}
	return 1;
};


//----- Run Force Code every Frame --------------------
void() Gyro_RunForces =
{
	//----- Loop Over Every Force --------------------
	local entity	forcehead, gyrohead, oldforce;
	local float		forceheadcount;
	forcehead = gyro_forcelist_head;
	while (forcehead)
	{
		//----- Run Update Function on Changed Forces --------------------
		if (forcehead.gyro_force_update)
		{
			Gyro_Force_Update(forcehead);
			forcehead.gyro_force_update = FALSE;
		}
		
		//----- Control Attached Forces --------------------
		if (forcehead.gyro_force_attach)
		{
			if ((forcehead.gyro_force_attach.origin == '0 0 0') && (forcehead.gyro_force_attach.modelindex == 0))
			{
				if (forcehead.gyro_force_flags & GYRO_FORCEFLAG_PERSISTENT)
					Gyro_Force_Detach(forcehead);
				else
				{
					oldforce = forcehead;
					forceheadcount = forceheadcount + 1;
					forcehead = forcehead.gyro_forcelist_next;
					Gyro_Force_Remove(oldforce);
					continue;
				}
			}
			else
				forcehead.origin = forcehead.gyro_force_attach.origin;
			
		}
		
		//----- Clean Invalid Ignore Field --------------------
		if (forcehead.gyro_force_ignore)
		{
			if ((forcehead.gyro_force_ignore.origin == '0 0 0') && (forcehead.gyro_force_ignore.modelindex == 0))
				forcehead.gyro_force_ignore = world;
		}
		
		//----- Set Force Bounds for this Frame --------------------
		forcehead.gyro_force_boundsmax = forcehead.origin + forcehead.gyro_force_bounds;
		forcehead.gyro_force_boundsmin = forcehead.origin - forcehead.gyro_force_bounds;
		
		//----- Cycle Over Physics Objects --------------------
		gyrohead = gyro_objectlist_head;
		while (gyrohead)
		{
			//----- Only Process when Force and Object Channels Match --------------------
			if (forcehead.gyro_force_channels & gyrohead.gyro_object_channels)
			{
				//----- Check if Object within Force Bounds --------------------
				if (Gyro_Force_CheckBounds(forcehead, gyrohead))
				{
					//----- Run Force Solver on Object --------------------
					Gyro_Force_Solver(forcehead, gyrohead);
				}
			}
			
			//----- Continue Looping over Objects --------------------
			gyrohead = gyrohead.gyro_objectlist_next;
		}
		
		//----- Update Force Range and Power Scale --------------------
		if (forcehead.gyro_force_powerscalerate != 0.0)
			forcehead.gyro_force_powerscale = forcehead.gyro_force_powerscale + (forcehead.gyro_force_powerscalerate * GYRO_TICKRATE);
		if (forcehead.gyro_force_rangescalerate != 0.0)
		{
			forcehead.gyro_force_rangescale = forcehead.gyro_force_rangescale + (forcehead.gyro_force_rangescalerate * GYRO_TICKRATE);
			forcehead.gyro_force_update = TRUE;
		}
		
		//----- Continue Looping over Forces --------------------
		oldforce = forcehead;
		forceheadcount = forceheadcount + 1;
		forcehead = forcehead.gyro_forcelist_next;
		
		//----- Remove Zero and Instant Forces --------------------
		if (oldforce.gyro_force_flags & GYRO_FORCEFLAG_INSTANT)
			Gyro_Force_Remove(oldforce);
		else if (!oldforce.gyro_force_flags & GYRO_FORCEFLAG_PERSISTENT)
		{
			if (oldforce.gyro_force_rangescale <= 0.0)
				Gyro_Force_Remove(oldforce);
			else if (oldforce.gyro_force_powerscale <= 0.0)
				Gyro_Force_Remove(oldforce);
		}
		
		//----- Disallow Negative Force Scales --------------------
		else
		{
			if (oldforce.gyro_force_rangescale < 0.0)
				oldforce.gyro_force_rangescale = 0.0;
			else if (oldforce.gyro_force_powerscale < 0.0)
				oldforce.gyro_force_powerscale = 0.0;
		}
	}
};

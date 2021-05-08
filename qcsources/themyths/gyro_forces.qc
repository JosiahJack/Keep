entity(string forcename, vector org) Gyro_Force_Create = 
{
	local entity f;
	if (GYRO_FORCEDEBUG > GYRO_AFFECTOR_NONE)
	{
		gyro_framedebug = 1;
		bprint("Gyro Debug: Empty force entity \"");
		bprint(forcename);
		bprint("\" created\n");
	}
	f = spawn();
	Gyro_ForceList_Add(f);
	setorigin(f, org);
	f.classname = forcename;
	f.gyro_force_falloff_combine = GYRO_FALLOFF_COMBINE_MULTIPLY;
	f.gyro_force_rangescale = GYRO_AFFECTOR_POINT;
	f.gyro_force_rangescalerate = GYRO_AFFECTOR_NONE;
	f.gyro_force_powerscale = GYRO_AFFECTOR_POINT;
	f.gyro_force_powerscalerate = GYRO_AFFECTOR_NONE;
	f.gyro_force_channels = GYRO_AFFECTOR_POINT;
	f.gyro_force_update = 1;
	return f;
};

void(entity f) Gyro_Force_Remove = 
{
	if (GYRO_FORCEDEBUG > GYRO_AFFECTOR_NONE)
	{
		gyro_framedebug = 1;
		bprint("Gyro Debug: Removed force entity \"");
		bprint(f.classname);
		bprint("\"\n");
	}
	remove(f);
};

void(entity f, vector fallaxis) Gyro_Force_Update_Bounds = 
{
	fallaxis = fallaxis * f.gyro_force_rangescale;
	if (fallaxis_x > GYRO_AFFECTOR_NONE)
	{
		if (fallaxis_x < f.gyro_force_bounds_x || f.gyro_force_bounds_x == GYRO_AFFECTOR_NONE)
		{
			f.gyro_force_bounds_x = fallaxis_x;
		}
	}
	if (fallaxis_y > GYRO_AFFECTOR_NONE)
	{
		if (fallaxis_y < f.gyro_force_bounds_y || f.gyro_force_bounds_y == GYRO_AFFECTOR_NONE)
		{
			f.gyro_force_bounds_y = fallaxis_y;
		}
	}
	if (fallaxis_z > GYRO_AFFECTOR_NONE)
	{
		if (fallaxis_z < f.gyro_force_bounds_z || f.gyro_force_bounds_z == GYRO_AFFECTOR_NONE)
		{
			f.gyro_force_bounds_z = fallaxis_z;
		}
	}
};

void(entity f) Gyro_Force_Update = 
{
	f.gyro_force_bounds = VEC_ORIGIN;
	if (f.gyro_force_falloff1_type)
	{
		Gyro_Force_Update_Bounds(f, f.gyro_force_falloff1_axis);
	}
	if (f.gyro_force_falloff2_type)
	{
		Gyro_Force_Update_Bounds(f, f.gyro_force_falloff2_axis);
	}
	if (f.gyro_force_falloff3_type)
	{
		Gyro_Force_Update_Bounds(f, f.gyro_force_falloff3_axis);
	}
	if (f.gyro_force_falloff4_type)
	{
		Gyro_Force_Update_Bounds(f, f.gyro_force_falloff4_axis);
	}
	if (GYRO_FORCEDEBUG > GYRO_AFFECTOR_POINT && f.gyro_force_rangescalerate == GYRO_AFFECTOR_NONE)
	{
		gyro_framedebug = 1;
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

float(entity f) Gyro_Force_Detach = 
{
	if (f.gyro_force_owner.modelindex != GYRO_AFFECTOR_NONE && f.gyro_force_owner.origin != VEC_ORIGIN)
	{
		f.origin = f.gyro_force_owner.origin;
	}
	f.gyro_force_owner = world;
	if (GYRO_FORCEDEBUG > GYRO_AFFECTOR_POINT)
	{
		gyro_framedebug = 1;
		bprint("Gyro Debug: Force has been detached \"");
		bprint(f.classname);
		bprint("\"\n");
	}
};

void(entity f, entity e) Gyro_Force_Attach = 
{
	if (e == world)
	{
		return Gyro_Force_Detach(f);
	}
	f.gyro_force_owner = e;
	if (GYRO_FORCEDEBUG > GYRO_AFFECTOR_POINT)
	{
		gyro_framedebug = 1;
		bprint("Gyro Debug: Force has been attached \"");
		bprint(f.classname);
		bprint("\"\nOwner: \"");
		bprint(e.classname);
		bprint("\"\n");
	}
};

void(entity f, float channels) Gyro_Force_SetChannels = 
{
	f.gyro_force_channels = channels;
};

void(entity f, float channels) Gyro_Force_AddChannels = 
{
	f.gyro_force_channels = f.gyro_force_channels | channels;
};

void(entity f, float channels) Gyro_Force_RemoveChannels = 
{
	f.gyro_force_channels = f.gyro_force_channels - (f.gyro_force_channels & channels);
};

void(entity f, float scale) Gyro_Force_SetRangeScale = 
{
	if (scale <= GYRO_AFFECTOR_NONE)
	{
		if (GYRO_FORCEDEBUG > GYRO_AFFECTOR_NONE)
		{
			gyro_framedebug = 1;
			bprint("Gyro Warning: Range scale not set for \"");
			bprint(f.classname);
			bprint("\"\nScale may not be a zero or negative value\n");
		}
		return;
	}
	f.gyro_force_rangescale = scale;
	f.gyro_force_update = 1;
	if (GYRO_FORCEDEBUG > GYRO_AFFECTOR_POINT)
	{
		gyro_framedebug = 1;
		bprint("Gyro Debug: Range scale set for \"");
		bprint(f.classname);
		bprint("\"\nScale: ");
		bprint(ftos(scale));
		bprint("\n");
	}
};

void(entity f, float scalerate) Gyro_Force_SetRangeScaleRate = 
{
	f.gyro_force_rangescalerate = scalerate;
	if (GYRO_FORCEDEBUG > GYRO_AFFECTOR_POINT)
	{
		gyro_framedebug = 1;
		bprint("Gyro Debug: Range scale rate set for \"");
		bprint(f.classname);
		bprint("\"\nScale rate: ");
		bprint(ftos(scalerate));
		bprint("\n");
	}
};

void(entity f, float scale) Gyro_Force_SetPowerScale = 
{
	if (scale <= GYRO_AFFECTOR_NONE)
	{
		if (GYRO_FORCEDEBUG > GYRO_AFFECTOR_NONE)
		{
			gyro_framedebug = 1;
			bprint("Gyro Warning: Power scale not set for \"");
			bprint(f.classname);
			bprint("\"\nScale may not be a zero or negative value\n");
		}
		return;
	}
	f.gyro_force_powerscale = scale;
	if (GYRO_FORCEDEBUG > GYRO_AFFECTOR_POINT)
	{
		gyro_framedebug = 1;
		bprint("Gyro Debug: Power scale set for \"");
		bprint(f.classname);
		bprint("\"\nScale: ");
		bprint(ftos(scale));
		bprint("\n");
	}
};

void(entity f, float scalerate) Gyro_Force_SetPowerScaleRate = 
{
	f.gyro_force_powerscalerate = scalerate;
	if (GYRO_FORCEDEBUG > GYRO_AFFECTOR_POINT)
	{
		gyro_framedebug = 1;
		bprint("Gyro Debug: Power scale rate set for \"");
		bprint(f.classname);
		bprint("\"\nScale rate: ");
		bprint(ftos(scalerate));
		bprint("\n");
	}
};

void(entity f) Gyro_Force_ClearProperties = 
{
	f.gyro_force_flags = GYRO_AFFECTOR_NONE;
	if (GYRO_FORCEDEBUG > GYRO_AFFECTOR_POINT)
	{
		gyro_framedebug = 1;
		bprint("Gyro Debug: All properties removed from \"");
		bprint(f.classname);
		bprint("\"\n");
	}
};

void(entity f) Gyro_Force_AddProperty_Instant = 
{
	f.gyro_force_flags = f.gyro_force_flags | GYRO_FORCEFLAG_INSTANT;
	if (GYRO_FORCEDEBUG > GYRO_AFFECTOR_POINT)
	{
		gyro_framedebug = 1;
		bprint("Gyro Debug: Instant property added to \"");
		bprint(f.classname);
		bprint("\"\n");
	}
};

void(entity f) Gyro_Force_RemoveProperty_Instant = 
{
	f.gyro_force_flags = f.gyro_force_flags - (f.gyro_force_flags & GYRO_FORCEFLAG_INSTANT);
	if (GYRO_FORCEDEBUG > GYRO_AFFECTOR_POINT)
	{
		gyro_framedebug = 1;
		bprint("Gyro Debug: Instant property removed from \"");
		bprint(f.classname);
		bprint("\"\n");
	}
};

void(entity f) Gyro_Force_AddProperty_IgnoreWalls = 
{
	f.gyro_force_flags = f.gyro_force_flags | GYRO_FORCEFLAG_IGNOREWALLS;
	if (GYRO_FORCEDEBUG > GYRO_AFFECTOR_POINT)
	{
		gyro_framedebug = 1;
		bprint("Gyro Debug: Ignore-walls property added to \"");
		bprint(f.classname);
		bprint("\"\n");
	}
};

void(entity f) Gyro_Force_RemoveProperty_IgnoreWalls = 
{
	f.gyro_force_flags = f.gyro_force_flags - (f.gyro_force_flags & GYRO_FORCEFLAG_IGNOREWALLS);
	if (GYRO_FORCEDEBUG > GYRO_AFFECTOR_POINT)
	{
		gyro_framedebug = 1;
		bprint("Gyro Debug: Ignore-walls property removed from \"");
		bprint(f.classname);
		bprint("\"\n");
	}
};

void(entity f) Gyro_Force_AddProperty_AirOnly = 
{
	f.gyro_force_flags = f.gyro_force_flags | GYRO_FORCEFLAG_AIRONLY;
	if (GYRO_FORCEDEBUG > GYRO_AFFECTOR_POINT)
	{
		gyro_framedebug = 1;
		bprint("Gyro Debug: Air-only property added to \"");
		bprint(f.classname);
		bprint("\"\n");
	}
};

void(entity f) Gyro_Force_RemoveProperty_AirOnly = 
{
	f.gyro_force_flags = f.gyro_force_flags - (f.gyro_force_flags & GYRO_FORCEFLAG_AIRONLY);
	if (GYRO_FORCEDEBUG > GYRO_AFFECTOR_POINT)
	{
		gyro_framedebug = 1;
		bprint("Gyro Debug: Air-only property removed from \"");
		bprint(f.classname);
		bprint("\"\n");
	}
};

void(entity f) Gyro_Force_AddProperty_WaterOnly = 
{
	f.gyro_force_flags = f.gyro_force_flags | GYRO_FORCEFLAG_WATERONLY;
	if (GYRO_FORCEDEBUG > GYRO_AFFECTOR_POINT)
	{
		gyro_framedebug = 1;
		bprint("Gyro Debug: Water-only property added to \"");
		bprint(f.classname);
		bprint("\"\n");
	}
};

void(entity f) Gyro_Force_RemoveProperty_WaterOnly = 
{
	f.gyro_force_flags = f.gyro_force_flags - (f.gyro_force_flags & GYRO_FORCEFLAG_WATERONLY);
	if (GYRO_FORCEDEBUG > GYRO_AFFECTOR_POINT)
	{
		gyro_framedebug = 1;
		bprint("Gyro Debug: Water-only property removed from \"");
		bprint(f.classname);
		bprint("\"\n");
	}
};

float(entity f, float falltype, vector fallaxis) Gyro_Force_ApplyFalloff = 
{
	if (fallaxis_x < GYRO_AFFECTOR_NONE)
	{
		fallaxis_x = GYRO_AFFECTOR_NONE - fallaxis_x;
	}
	if (fallaxis_y < GYRO_AFFECTOR_NONE)
	{
		fallaxis_y = GYRO_AFFECTOR_NONE - fallaxis_y;
	}
	if (fallaxis_z < GYRO_AFFECTOR_NONE)
	{
		fallaxis_z = GYRO_AFFECTOR_NONE - fallaxis_z;
	}
	if (!(f.gyro_forcelist_inlist))
	{
		if (GYRO_FORCEDEBUG > GYRO_AFFECTOR_NONE)
		{
			gyro_framedebug = 1;
			bprint("Gyro Warning: Falloff not applied to \"");
			bprint(f.classname);
			bprint("\"\nThe entity is not recognised as a force\n");
			return GYRO_AFFECTOR_NONE;
		}
	}
	if (!(f.gyro_force_falloff1_type))
	{
		f.gyro_force_falloff1_type = falltype;
		f.gyro_force_falloff1_axis = fallaxis;
		f.gyro_force_update = 1;
		return GYRO_AFFECTOR_POINT;
	}
	else
	{
		if (!(f.gyro_force_falloff2_type))
		{
			f.gyro_force_falloff2_type = falltype;
			f.gyro_force_falloff2_axis = fallaxis;
			f.gyro_force_update = 1;
			return GYRO_AFFECTOR_POINT;
		}
		else
		{
			if (!(f.gyro_force_falloff3_type))
			{
				f.gyro_force_falloff3_type = falltype;
				f.gyro_force_falloff3_axis = fallaxis;
				f.gyro_force_update = 1;
				return GYRO_AFFECTOR_POINT;
			}
			else
			{
				if (!(f.gyro_force_falloff4_type))
				{
					f.gyro_force_falloff4_type = falltype;
					f.gyro_force_falloff4_axis = fallaxis;
					f.gyro_force_update = 1;
					return GYRO_AFFECTOR_POINT;
				}
			}
		}
	}
	if (GYRO_FORCEDEBUG > GYRO_AFFECTOR_NONE)
	{
		gyro_framedebug = 1;
		bprint("Gyro Warning: Falloff not applied to \"");
		bprint(f.classname);
		bprint("\"\nThe force cannot support more falloff controllers\n");
	}
	return GYRO_AFFECTOR_NONE;
};

void(entity f, vector falloff_area) Gyro_Force_ApplyFalloff_Linear = 
{
	if (Gyro_Force_ApplyFalloff(f, GYRO_FALLOFF_LINEAR, falloff_area))
	{
		if (GYRO_FORCEDEBUG > GYRO_AFFECTOR_POINT)
		{
			gyro_framedebug = 1;
			bprint("Gyro Debug: Linear falloff applied to \"");
			bprint(f.classname);
			bprint("\"\nArea: ");
			bprint(vtos(falloff_area));
			bprint("\n");
		}
	}
};

void(entity f, vector falloff_area) Gyro_Force_ApplyFalloff_Quadratic = 
{
	if (Gyro_Force_ApplyFalloff(f, GYRO_FALLOFF_QUADRATIC, falloff_area))
	{
		if (GYRO_FORCEDEBUG > GYRO_AFFECTOR_POINT)
		{
			gyro_framedebug = 1;
			bprint("Gyro Debug: Quadratic falloff applied to \"");
			bprint(f.classname);
			bprint("\"\nArea: ");
			bprint(vtos(falloff_area));
			bprint("\n");
		}
	}
};

void(entity f, vector falloff_area) Gyro_Force_ApplyFalloff_Constant = 
{
	if (Gyro_Force_ApplyFalloff(f, GYRO_FALLOFF_CONSTANT, falloff_area))
	{
		if (GYRO_FORCEDEBUG > GYRO_AFFECTOR_POINT)
		{
			gyro_framedebug = 1;
			bprint("Gyro Debug: Constant falloff applied to \"");
			bprint(f.classname);
			bprint("\"\nArea: ");
			bprint(vtos(falloff_area));
			bprint("\n");
		}
	}
};

void(entity f) Gyro_Force_FalloffCombine_Multiply = 
{
	f.gyro_force_falloff_combine = GYRO_FALLOFF_COMBINE_MULTIPLY;
	if (GYRO_FORCEDEBUG > GYRO_AFFECTOR_POINT)
	{
		gyro_framedebug = 1;
		bprint("Gyro Debug: Falloff combination set for \"");
		bprint(f.classname);
		bprint("\"\nCombination method: Multiply\n");
	}
};

void(entity f) Gyro_Force_FalloffCombine_Minimum = 
{
	f.gyro_force_falloff_combine = GYRO_FALLOFF_COMBINE_MINIMUM;
	if (GYRO_FORCEDEBUG > GYRO_AFFECTOR_POINT)
	{
		gyro_framedebug = 1;
		bprint("Gyro Debug: Falloff combination set for \"");
		bprint(f.classname);
		bprint("\"\nCombination method: Minimum\n");
	}
};

void(entity f) Gyro_Force_FalloffCombine_Subtract = 
{
	f.gyro_force_falloff_combine = GYRO_FALLOFF_COMBINE_SUBTRACT;
	if (GYRO_FORCEDEBUG > GYRO_AFFECTOR_POINT)
	{
		gyro_framedebug = 1;
		bprint("Gyro Debug: Falloff combination set for \"");
		bprint(f.classname);
		bprint("\"\nCombination method: Subtract\n");
	}
};

float(entity f, float afftype, float affpower, float absolute, vector offset, vector axis, vector amodx, vector amody) Gyro_Force_ApplyAffector = 
{
	amodz = ?/00000896\?;
	if (!(f.gyro_forcelist_inlist))
	{
		if (GYRO_FORCEDEBUG > GYRO_AFFECTOR_NONE)
		{
			gyro_framedebug = 1;
			bprint("Gyro Warning: Affector not applied to \"");
			bprint(f.classname);
			bprint("\"\nThe entity is not recognised as a force\n");
			return GYRO_AFFECTOR_NONE;
		}
	}
	if (!(f.gyro_force_affector1_type))
	{
		f.gyro_force_affector1_type = afftype;
		f.gyro_force_affector1_power = affpower;
		f.gyro_force_affector1_absolute = absolute;
		f.gyro_force_affector1_offset = offset;
		f.gyro_force_affector1_axis = axis;
		f.gyro_force_affector1_modx = amodx;
		f.gyro_force_affector1_mody = amody;
		f.gyro_force_affector1_modz = amodz;
		f.gyro_force_update = 1;
		return GYRO_AFFECTOR_POINT;
	}
	else
	{
		if (!(f.gyro_force_affector2_type))
		{
			f.gyro_force_affector2_type = afftype;
			f.gyro_force_affector2_power = affpower;
			f.gyro_force_affector2_absolute = absolute;
			f.gyro_force_affector2_offset = offset;
			f.gyro_force_affector2_axis = axis;
			f.gyro_force_affector2_modx = amodx;
			f.gyro_force_affector2_mody = amody;
			f.gyro_force_affector2_modz = amodz;
			f.gyro_force_update = 1;
			return GYRO_AFFECTOR_POINT;
		}
		else
		{
			if (!(f.gyro_force_affector3_type))
			{
				f.gyro_force_affector3_type = afftype;
				f.gyro_force_affector3_power = affpower;
				f.gyro_force_affector3_absolute = absolute;
				f.gyro_force_affector3_offset = offset;
				f.gyro_force_affector3_axis = axis;
				f.gyro_force_affector3_modx = amodx;
				f.gyro_force_affector3_mody = amody;
				f.gyro_force_affector3_modz = amodz;
				f.gyro_force_update = 1;
				return GYRO_AFFECTOR_POINT;
			}
			else
			{
				if (!(f.gyro_force_affector4_type))
				{
					f.gyro_force_affector4_type = afftype;
					f.gyro_force_affector4_power = affpower;
					f.gyro_force_affector4_absolute = absolute;
					f.gyro_force_affector4_offset = offset;
					f.gyro_force_affector4_axis = axis;
					f.gyro_force_affector4_modx = amodx;
					f.gyro_force_affector4_mody = amody;
					f.gyro_force_affector4_modz = amodz;
					f.gyro_force_update = 1;
					return GYRO_AFFECTOR_POINT;
				}
			}
		}
	}
	if (GYRO_FORCEDEBUG > GYRO_AFFECTOR_NONE)
	{
		gyro_framedebug = 1;
		bprint("Gyro Warning: Affector not applied to \"");
		bprint(f.classname);
		bprint("\"\nThe force cannot support more affectors\n");
	}
	return GYRO_AFFECTOR_NONE;
};

void(entity f, vector org_offset, vector aff_axis, float aff_power, float absolute, vector modx, vector mody, vector modz) Gyro_Force_ApplyAffector_PointMod = 
{
	(amodz = ?/00000896\?) = modz;
	if (Gyro_Force_ApplyAffector(f, GYRO_AFFECTOR_POINTMOD, aff_power, absolute, org_offset, aff_axis, modx, mody))
	{
		if (GYRO_FORCEDEBUG > GYRO_AFFECTOR_POINT)
		{
			gyro_framedebug = 1;
			bprint("Gyro Debug: Point-Mod affector applied to \"");
			bprint(f.classname);
			bprint("\"\nStrength: ");
			bprint(ftos(aff_power));
			bprint("\n");
		}
	}
};

void(entity f, vector org_offset, vector aff_axis, float aff_power, float absolute) Gyro_Force_ApplyAffector_Point = 
{
	(amodz = ?/00000896\?) = VEC_ORIGIN;
	if (Gyro_Force_ApplyAffector(f, GYRO_AFFECTOR_POINT, aff_power, absolute, org_offset, aff_axis, VEC_ORIGIN, VEC_ORIGIN))
	{
		if (GYRO_FORCEDEBUG > GYRO_AFFECTOR_POINT)
		{
			gyro_framedebug = 1;
			bprint("Gyro Debug: Point affector applied to \"");
			bprint(f.classname);
			bprint("\"\nStrength: ");
			bprint(ftos(aff_power));
			bprint("\n");
		}
	}
};

void(entity f, float aff_power, float absolute) Gyro_Force_ApplyAffector_Sphere = 
{
	Gyro_Force_ApplyAffector_Point(f, VEC_ORIGIN, '1 1 1', aff_power, absolute);
};

void(entity f, vector aff_axis, float aff_power, float absolute) Gyro_Force_ApplyAffector_Directional = 
{
	aff_axis = normalize(aff_axis);
	(amodz = ?/00000896\?) = VEC_ORIGIN;
	if (Gyro_Force_ApplyAffector(f, GYRO_AFFECTOR_DIRECTIONAL, aff_power, absolute, VEC_ORIGIN, aff_axis, VEC_ORIGIN, VEC_ORIGIN))
	{
		if (GYRO_FORCEDEBUG > GYRO_AFFECTOR_POINT)
		{
			gyro_framedebug = 1;
			bprint("Gyro Debug: Directional affector applied to \"");
			bprint(f.classname);
			bprint("\"\nStrength: ");
			bprint(ftos(aff_power));
			bprint("\n");
		}
	}
};

void(entity f, float gravpower, float absolute) Gyro_Force_ApplyAffector_AntiGravity = 
{
	(amodz = ?/00000896\?) = VEC_ORIGIN;
	if (Gyro_Force_ApplyAffector(f, GYRO_AFFECTOR_ANTIGRAVITY, gravpower, absolute, VEC_ORIGIN, '1 1 1', VEC_ORIGIN, VEC_ORIGIN))
	{
		if (GYRO_FORCEDEBUG > GYRO_AFFECTOR_POINT)
		{
			gyro_framedebug = 1;
			bprint("Gyro Debug: Anti-gravity affector applied to \"");
			bprint(f.classname);
			bprint("\"\nStrength: ");
			bprint(ftos(gravpower));
			bprint("\n");
		}
	}
};

void(entity f, vector aff_axis, float respower, float absolute) Gyro_Force_ApplyAffector_Resistance = 
{
	(amodz = ?/00000896\?) = VEC_ORIGIN;
	if (Gyro_Force_ApplyAffector(f, GYRO_AFFECTOR_RESISTANCE, respower, absolute, VEC_ORIGIN, aff_axis, VEC_ORIGIN, VEC_ORIGIN))
	{
		if (GYRO_FORCEDEBUG > GYRO_AFFECTOR_POINT)
		{
			gyro_framedebug = 1;
			bprint("Gyro Debug: Resistance affector applied to \"");
			bprint(f.classname);
			bprint("\"\nStrength: ");
			bprint(ftos(respower));
			bprint("\n");
		}
	}
};

float(vector org_diff, float fall_type, vector fall_vector) Gyro_Force_Solver_Falloff = 
{
	local float fallout;
	if (fall_type == GYRO_FALLOFF_LINEAR || fall_type == GYRO_FALLOFF_QUADRATIC || fall_type == GYRO_FALLOFF_CONSTANT)
	{
		if (fall_vector == VEC_ORIGIN)
		{
			return GYRO_AFFECTOR_POINT;
		}
		if (fall_vector_x == GYRO_AFFECTOR_NONE)
		{
			org_diff_x = GYRO_AFFECTOR_NONE;
		}
		else
		{
			org_diff_x = org_diff_x / fall_vector_x;
		}
		if (fall_vector_y == GYRO_AFFECTOR_NONE)
		{
			org_diff_y = GYRO_AFFECTOR_NONE;
		}
		else
		{
			org_diff_y = org_diff_y / fall_vector_y;
		}
		if (fall_vector_z == GYRO_AFFECTOR_NONE)
		{
			org_diff_z = GYRO_AFFECTOR_NONE;
		}
		else
		{
			org_diff_z = org_diff_z / fall_vector_z;
		}
		fallout = GYRO_AFFECTOR_POINT - vlen(org_diff);
		if (fallout < GYRO_AFFECTOR_NONE)
		{
			return GYRO_AFFECTOR_NONE;
		}
		if (fall_type == GYRO_FALLOFF_CONSTANT)
		{
			return GYRO_AFFECTOR_POINT;
		}
		else
		{
			if (fall_type == GYRO_FALLOFF_QUADRATIC)
			{
				return fallout * fallout;
			}
		}
		return fallout;
	}
};

void(entity f, entity e, float atype, float apower, float absolute, vector aoffset, vector aaxis, vector amodx) Gyro_Force_Solver_Affector = 
{
	local vector amody;
	local vector amodz;
	local vector off_diff;
	local vector off_diff_temp;
	local float resistpower;
	amody = amodz = ?/00000896\?;
	amodz = ?/00000967\?;
	if (atype == GYRO_AFFECTOR_POINT || atype == GYRO_AFFECTOR_POINTMOD)
	{
		if (apower == GYRO_AFFECTOR_NONE)
		{
			return;
		}
		if (aaxis == VEC_ORIGIN)
		{
			return;
		}
		off_diff = normalize(e.origin - (f.origin + aoffset));
		if (aaxis != '1 1 1')
		{
			off_diff_x = off_diff_x * aaxis_x;
			off_diff_y = off_diff_y * aaxis_y;
			off_diff_z = off_diff_z * aaxis_z;
		}
		if (atype == GYRO_AFFECTOR_POINTMOD)
		{
			off_diff_temp_x = off_diff_x * amodx_x + off_diff_y * amodx_y + off_diff_z * amodx_z;
			off_diff_temp_y = off_diff_x * amody_x + off_diff_y * amody_y + off_diff_z * amody_z;
			off_diff_temp_z = off_diff_x * amodz_x + off_diff_y * amodz_y + off_diff_z * amodz_z;
			off_diff = off_diff_temp;
		}
		if (absolute)
		{
			apower = apower * e.gyro_object_mass;
		}
		if (f.gyro_force_flags & GYRO_FORCEFLAG_INSTANT)
		{
			e.gyro_velocityeffect = e.gyro_velocityeffect + off_diff * (apower / e.gyro_object_mass) * f.gyro_force_powerscale * GYRO_POWERCONSTANT;
		}
		else
		{
			e.gyro_velocityeffect = e.gyro_velocityeffect + off_diff * (apower / e.gyro_object_mass) * f.gyro_force_powerscale * GYRO_POWERCONSTANT * GYRO_TICKRATE;
		}
	}
	else
	{
		if (atype == GYRO_AFFECTOR_DIRECTIONAL)
		{
			if (apower == GYRO_AFFECTOR_NONE)
			{
				return;
			}
			if (aaxis == VEC_ORIGIN)
			{
				return;
			}
			if (absolute)
			{
				apower = apower * e.gyro_object_mass;
			}
			if (f.gyro_force_flags & GYRO_FORCEFLAG_INSTANT)
			{
				e.gyro_velocityeffect = e.gyro_velocityeffect + aaxis * (apower / e.gyro_object_mass) * f.gyro_force_powerscale * GYRO_POWERCONSTANT;
			}
			else
			{
				e.gyro_velocityeffect = e.gyro_velocityeffect + aaxis * (apower / e.gyro_object_mass) * f.gyro_force_powerscale * GYRO_POWERCONSTANT * GYRO_TICKRATE;
			}
		}
		else
		{
			if (atype == GYRO_AFFECTOR_ANTIGRAVITY)
			{
				if (apower <= GYRO_AFFECTOR_NONE)
				{
					return;
				}
				if (absolute)
				{
					apower = apower * e.gyro_object_mass;
				}
				e.gyro_antigravityeffect = e.gyro_antigravityeffect + apower / e.gyro_object_mass * f.gyro_force_powerscale;
			}
			else
			{
				if (atype == GYRO_AFFECTOR_RESISTANCE)
				{
					if (apower <= GYRO_AFFECTOR_NONE)
					{
						return;
					}
					if (absolute)
					{
						apower = apower * e.gyro_object_mass;
					}
					if (f.gyro_force_flags & GYRO_FORCEFLAG_INSTANT)
					{
						resistpower = GYRO_AFFECTOR_POINT - apower / e.gyro_object_mass;
					}
					else
					{
						resistpower = Gyro_PowerEstimation(GYRO_AFFECTOR_POINT - apower / e.gyro_object_mass, GYRO_TICKRATE);
					}
					e.gyro_dampeningeffect_x = e.gyro_dampeningeffect_x * (GYRO_AFFECTOR_POINT - (GYRO_AFFECTOR_POINT - resistpower) * aaxis_x);
					e.gyro_dampeningeffect_y = e.gyro_dampeningeffect_y * (GYRO_AFFECTOR_POINT - (GYRO_AFFECTOR_POINT - resistpower) * aaxis_y);
					e.gyro_dampeningeffect_z = e.gyro_dampeningeffect_z * (GYRO_AFFECTOR_POINT - (GYRO_AFFECTOR_POINT - resistpower) * aaxis_z);
					e.gyro_adampeningeffect = e.gyro_adampeningeffect * resistpower;
				}
			}
		}
	}
};

void(entity f, entity e) Gyro_Force_Solver = 
{
	local float pconts1;
	local float pconts2;
	local vector org_diff;
	local float totalfalloff;
	local float fallofftest;
	local vector oldveleffect;
	if (f.gyro_force_owner == e)
	{
		return;
	}
	if (f.gyro_force_flags & GYRO_FORCEFLAG_AIRONLY)
	{
		pconts1 = pointcontents(e.origin);
		if (pconts1 == CONTENT_WATER || pconts1 == CONTENT_SLIME || pconts1 == CONTENT_LAVA)
		{
			return;
		}
	}
	if (f.gyro_force_flags & GYRO_FORCEFLAG_WATERONLY)
	{
		pconts2 = pointcontents(e.origin);
		if (!(pconts2 == CONTENT_WATER || pconts2 == CONTENT_SLIME || pconts2 == CONTENT_LAVA))
		{
			return;
		}
	}
	if (!(f.gyro_force_flags & GYRO_FORCEFLAG_IGNOREWALLS))
	{
		traceline(f.origin, e.origin, 1, world);
		if (trace_fraction < GYRO_AFFECTOR_POINT)
		{
			return;
		}
	}
	org_diff = e.origin - f.origin;
	totalfalloff = GYRO_AFFECTOR_POINT;
	if (f.gyro_force_falloff_combine == GYRO_FALLOFF_COMBINE_MULTIPLY)
	{
		if (f.gyro_force_falloff1_type)
		{
			totalfalloff = totalfalloff * Gyro_Force_Solver_Falloff(org_diff, f.gyro_force_falloff1_type, f.gyro_force_falloff1_axis * f.gyro_force_rangescale);
		}
		if (f.gyro_force_falloff2_type)
		{
			totalfalloff = totalfalloff * Gyro_Force_Solver_Falloff(org_diff, f.gyro_force_falloff2_type, f.gyro_force_falloff2_axis * f.gyro_force_rangescale);
		}
		if (f.gyro_force_falloff3_type)
		{
			totalfalloff = totalfalloff * Gyro_Force_Solver_Falloff(org_diff, f.gyro_force_falloff3_type, f.gyro_force_falloff3_axis * f.gyro_force_rangescale);
		}
		if (f.gyro_force_falloff4_type)
		{
			totalfalloff = totalfalloff * Gyro_Force_Solver_Falloff(org_diff, f.gyro_force_falloff4_type, f.gyro_force_falloff4_axis * f.gyro_force_rangescale);
		}
	}
	else
	{
		if (f.gyro_force_falloff_combine == GYRO_FALLOFF_COMBINE_MINIMUM)
		{
			if (f.gyro_force_falloff1_type)
			{
				fallofftest = Gyro_Force_Solver_Falloff(org_diff, f.gyro_force_falloff1_type, f.gyro_force_falloff1_axis * f.gyro_force_rangescale);
				if (fallofftest < totalfalloff)
				{
					totalfalloff = fallofftest;
				}
			}
			if (f.gyro_force_falloff2_type)
			{
				fallofftest = Gyro_Force_Solver_Falloff(org_diff, f.gyro_force_falloff2_type, f.gyro_force_falloff2_axis * f.gyro_force_rangescale);
				if (fallofftest < totalfalloff)
				{
					totalfalloff = fallofftest;
				}
			}
			if (f.gyro_force_falloff3_type)
			{
				fallofftest = Gyro_Force_Solver_Falloff(org_diff, f.gyro_force_falloff3_type, f.gyro_force_falloff3_axis * f.gyro_force_rangescale);
				if (fallofftest < totalfalloff)
				{
					totalfalloff = fallofftest;
				}
			}
			if (f.gyro_force_falloff4_type)
			{
				fallofftest = Gyro_Force_Solver_Falloff(org_diff, f.gyro_force_falloff4_type, f.gyro_force_falloff4_axis * f.gyro_force_rangescale);
				if (fallofftest < totalfalloff)
				{
					totalfalloff = fallofftest;
				}
			}
		}
		else
		{
			if (f.gyro_force_falloff_combine == GYRO_FALLOFF_COMBINE_SUBTRACT)
			{
				if (f.gyro_force_falloff1_type)
				{
					totalfalloff = totalfalloff - (GYRO_AFFECTOR_POINT - Gyro_Force_Solver_Falloff(org_diff, f.gyro_force_falloff1_type, f.gyro_force_falloff1_axis * f.gyro_force_rangescale));
				}
				if (f.gyro_force_falloff2_type)
				{
					totalfalloff = totalfalloff - (GYRO_AFFECTOR_POINT - Gyro_Force_Solver_Falloff(org_diff, f.gyro_force_falloff2_type, f.gyro_force_falloff2_axis * f.gyro_force_rangescale));
				}
				if (f.gyro_force_falloff3_type)
				{
					totalfalloff = totalfalloff - (GYRO_AFFECTOR_POINT - Gyro_Force_Solver_Falloff(org_diff, f.gyro_force_falloff3_type, f.gyro_force_falloff3_axis * f.gyro_force_rangescale));
				}
				if (f.gyro_force_falloff4_type)
				{
					totalfalloff = totalfalloff - (GYRO_AFFECTOR_POINT - Gyro_Force_Solver_Falloff(org_diff, f.gyro_force_falloff4_type, f.gyro_force_falloff4_axis * f.gyro_force_rangescale));
				}
			}
		}
	}
	if (totalfalloff <= GYRO_AFFECTOR_NONE)
	{
		return;
	}
	oldveleffect = e.gyro_velocityeffect;
	if (f.gyro_force_affector1_type)
	{
		(amody = amodz = ?/00000896\?) = f.gyro_force_affector1_mody;
		(amodz = ?/00000967\?) = f.gyro_force_affector1_modz;
		Gyro_Force_Solver_Affector(f, e, f.gyro_force_affector1_type, f.gyro_force_affector1_power * totalfalloff, f.gyro_force_affector1_absolute, f.gyro_force_affector1_offset, f.gyro_force_affector1_axis, f.gyro_force_affector1_modx);
	}
	if (f.gyro_force_affector2_type)
	{
		(amody = amodz = ?/00000896\?) = f.gyro_force_affector2_mody;
		(amodz = ?/00000967\?) = f.gyro_force_affector2_modz;
		Gyro_Force_Solver_Affector(f, e, f.gyro_force_affector2_type, f.gyro_force_affector2_power * totalfalloff, f.gyro_force_affector2_absolute, f.gyro_force_affector2_offset, f.gyro_force_affector2_axis, f.gyro_force_affector2_modx);
	}
	if (f.gyro_force_affector3_type)
	{
		(amody = amodz = ?/00000896\?) = f.gyro_force_affector3_mody;
		(amodz = ?/00000967\?) = f.gyro_force_affector3_modz;
		Gyro_Force_Solver_Affector(f, e, f.gyro_force_affector3_type, f.gyro_force_affector3_power * totalfalloff, f.gyro_force_affector3_absolute, f.gyro_force_affector3_offset, f.gyro_force_affector3_axis, f.gyro_force_affector3_modx);
	}
	if (f.gyro_force_affector4_type)
	{
		(amody = amodz = ?/00000896\?) = f.gyro_force_affector4_mody;
		(amodz = ?/00000967\?) = f.gyro_force_affector4_modz;
		Gyro_Force_Solver_Affector(f, e, f.gyro_force_affector4_type, f.gyro_force_affector4_power * totalfalloff, f.gyro_force_affector4_absolute, f.gyro_force_affector4_offset, f.gyro_force_affector4_axis, f.gyro_force_affector4_modx);
	}
	if (e.gyro_feedback)
	{
		gyro_feedback_name = f.classname;
		gyro_feedback_power = vlen(oldveleffect - e.gyro_velocityeffect) / GYRO_TICKRATE / GYRO_POWERCONSTANT * e.gyro_object_mass;
		gyro_feedback_channels = f.gyro_force_channels & e.gyro_object_channels;
		Gyro_Object_CallFeedback(e);
	}
};

float(entity f, entity e) Gyro_Force_CheckBounds = 
{
	if (f.gyro_force_bounds_x > GYRO_AFFECTOR_NONE)
	{
		if (e.origin_x > f.gyro_force_boundsmax_x)
		{
			return GYRO_AFFECTOR_NONE;
		}
		if (e.origin_x < f.gyro_force_boundsmin_x)
		{
			return GYRO_AFFECTOR_NONE;
		}
	}
	if (f.gyro_force_bounds_y > GYRO_AFFECTOR_NONE)
	{
		if (e.origin_y > f.gyro_force_boundsmax_y)
		{
			return GYRO_AFFECTOR_NONE;
		}
		if (e.origin_y < f.gyro_force_boundsmin_y)
		{
			return GYRO_AFFECTOR_NONE;
		}
	}
	if (f.gyro_force_bounds_z > GYRO_AFFECTOR_NONE)
	{
		if (e.origin_z > f.gyro_force_boundsmax_z)
		{
			return GYRO_AFFECTOR_NONE;
		}
		if (e.origin_z < f.gyro_force_boundsmin_z)
		{
			return GYRO_AFFECTOR_NONE;
		}
	}
	return GYRO_AFFECTOR_POINT;
};

void() Gyro_RunForces = 
{
	local entity forcehead;
	local entity gyrohead;
	local entity oldforce;
	local float forceheadcount;
	forcehead = gyro_forcelist_head;
	while (forcehead)
	{
		if (forcehead.gyro_force_update)
		{
			Gyro_Force_Update(forcehead);
			forcehead.gyro_force_update = 0;
		}
		if (forcehead.gyro_force_owner)
		{
			if (forcehead.gyro_force_owner.origin == VEC_ORIGIN && forcehead.gyro_force_owner.modelindex == GYRO_AFFECTOR_NONE)
			{
				Gyro_Force_Detach(forcehead);
			}
			else
			{
				forcehead.origin = forcehead.gyro_force_owner.origin;
			}
		}
		forcehead.gyro_force_boundsmax = forcehead.origin + forcehead.gyro_force_bounds;
		forcehead.gyro_force_boundsmin = forcehead.origin - forcehead.gyro_force_bounds;
		gyrohead = gyro_objectlist_head;
		while (gyrohead)
		{
			if (forcehead.gyro_force_channels & gyrohead.gyro_object_channels)
			{
				if (Gyro_Force_CheckBounds(forcehead, gyrohead))
				{
					Gyro_Force_Solver(forcehead, gyrohead);
				}
			}
			gyrohead = gyrohead.gyro_objectlist_next;
		}
		if (forcehead.gyro_force_powerscalerate != GYRO_AFFECTOR_NONE)
		{
			forcehead.gyro_force_powerscale = forcehead.gyro_force_powerscale + forcehead.gyro_force_powerscalerate * GYRO_TICKRATE;
		}
		if (forcehead.gyro_force_rangescalerate != GYRO_AFFECTOR_NONE)
		{
			forcehead.gyro_force_rangescale = forcehead.gyro_force_rangescale + forcehead.gyro_force_rangescalerate * GYRO_TICKRATE;
			forcehead.gyro_force_update = 1;
		}
		oldforce = forcehead;
		forceheadcount = forceheadcount + GYRO_AFFECTOR_POINT;
		forcehead = forcehead.gyro_forcelist_next;
		if (oldforce.gyro_force_rangescale <= GYRO_AFFECTOR_NONE)
		{
			Gyro_Force_Remove(oldforce);
		}
		if (oldforce.gyro_force_powerscale <= GYRO_AFFECTOR_NONE)
		{
			Gyro_Force_Remove(oldforce);
		}
		else
		{
			if (oldforce.gyro_force_flags & GYRO_FORCEFLAG_INSTANT)
			{
				Gyro_Force_Remove(oldforce);
			}
		}
	}
};


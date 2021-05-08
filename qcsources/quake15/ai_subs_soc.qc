
/*======================================================================
 visxray (variable options)
  Returns TRUE if there is no blocking, FALSE if something in the way
  Custom options for variable source/target offsets and monster blocking
  (nomonsters) TRUE = no block, FALSE = blocked
  self is excluded from any trace starting points
======================================================================*/
float(entity targ, vector s_offset, vector t_offset, float nomonsters) visxray =
{
	local vector	spot1, spot2;

	// Bmodels don't have proper origins
	if (self.bsporigin) spot1 = bmodel_origin(self) + s_offset;
	else spot1 = self.origin + s_offset;

	spot2 = targ.origin + t_offset;
	traceline (spot1, spot2, nomonsters, self);	// custom options
	
	// Does the world define any water transparency
	if (liquid_alpha == 1) {	
		// sight line crossed contents
		if (trace_inopen && trace_inwater) return FALSE;
	}

	// monster blocking changes which test to use
	if (nomonsters) {
		// Has the traceline gone from source>target without anything blocking?
		if (trace_fraction == 1) return TRUE;
		return FALSE;
	}
	else {
		// Is the entity hit by the traceline the targ destination?
		if (trace_ent == targ) return TRUE;
		return FALSE;
	}
};


float(vector source, vector targ, float offset, float reverse, float dst_ang) viewangle =
{
	local float targ_dir, targ_ang;

	// Calculate vector angle between two points (source, target)
	if (reverse) targ_dir = vectoyaw(source - targ);
	else targ_dir = vectoyaw(targ - source);

	targ_ang = anglemod( (dst_ang - targ_dir) + offset );
	return targ_ang;
};

void() ai_resetangles =
{
	// There is a chance when finished a monster jump that some
	// of the angles (X/Z) values are wrong and need resetting
	// Should only be used after jump functions
	self.angles_x = self.angles_z = 0;
};

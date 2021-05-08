void(entity e, float mass) Gyro_Object_Activate = 
{
	local float reactive;
	Gyro_ObjectList_Add(e);
	if (e.gyro_object_mass == GYRO_AFFECTOR_NONE)
	{
		e.gyro_object_mass = mass;
		e.gyro_object_channels = GYRO_AFFECTOR_POINT;
		reactive = 0;
	}
	else
	{
		reactive = 1;
	}
	if (e.gyro_object_mass <= GYRO_AFFECTOR_NONE)
	{
		if (GYRO_OBJECTDEBUG > GYRO_AFFECTOR_NONE)
		{
			gyro_framedebug = 1;
			bprint("Gyro Warning: Entity physics not activated for \"");
			bprint(e.classname);
			bprint("\"\nMass cannot be set to zero or below\n");
		}
	}
	e.gyro_velocityeffect = VEC_ORIGIN;
	e.gyro_avelocityeffect = VEC_ORIGIN;
	e.gyro_dampeningeffect = '1 1 1';
	e.gyro_adampeningeffect = '1 1 1';
	e.gyro_antigravityeffect = GYRO_AFFECTOR_NONE;
	if (GYRO_OBJECTDEBUG > GYRO_AFFECTOR_NONE)
	{
		gyro_framedebug = 1;
		bprint("Gyro Debug: Entity physics activated for \"");
		bprint(e.classname);
		bprint("\"\nMass: ");
		bprint(ftos(e.gyro_object_mass));
		if (reactive == 1)
		{
			bprint(", inactive settings have been restored");
		}
		bprint("\n");
	}
};

void(entity e) Gyro_Object_Deactivate = 
{
	Gyro_ObjectList_Remove(e);
	if (GYRO_OBJECTDEBUG > GYRO_AFFECTOR_NONE)
	{
		gyro_framedebug = 1;
		bprint("Gyro Debug: Entity physics deactivated for \"");
		bprint(e.classname);
		bprint("\"\nPhysics settings preserved but inactive\n");
	}
};

void(entity e) Gyro_Object_ClearPhysics = 
{
	e.gyro_object_mass = GYRO_AFFECTOR_NONE;
	e.gyro_object_bouyancy_air = GYRO_AFFECTOR_NONE;
	e.gyro_object_bouyancy_water = GYRO_AFFECTOR_NONE;
	e.gyro_object_bouyancy_slime = GYRO_AFFECTOR_NONE;
	e.gyro_object_bouyancy_lava = GYRO_AFFECTOR_NONE;
	e.gyro_object_resistance_air = GYRO_AFFECTOR_POINT;
	e.gyro_object_resistance_water = GYRO_AFFECTOR_POINT;
	e.gyro_object_resistance_slime = GYRO_AFFECTOR_POINT;
	e.gyro_object_resistance_lava = GYRO_AFFECTOR_POINT;
	e.gyro_object_turbulence_air = GYRO_AFFECTOR_NONE;
	e.gyro_object_turbulence_water = GYRO_AFFECTOR_NONE;
	e.gyro_object_turbulence_slime = GYRO_AFFECTOR_NONE;
	e.gyro_object_turbulence_lava = GYRO_AFFECTOR_NONE;
	e.gyro_object_globalturb_air = GYRO_AFFECTOR_NONE;
	e.gyro_object_globalturb_water = GYRO_AFFECTOR_NONE;
	e.gyro_object_globalturb_slime = GYRO_AFFECTOR_NONE;
	e.gyro_object_globalturb_lava = GYRO_AFFECTOR_NONE;
	e.gyro_object_hover_tap = GYRO_AFFECTOR_NONE;
	e.gyro_object_hover_dist = GYRO_AFFECTOR_NONE;
	e.gyro_object_hover_power = GYRO_AFFECTOR_NONE;
	e.gyro_object_aerodynamics = GYRO_AFFECTOR_NONE;
	e.gyro_object_angleturb = GYRO_AFFECTOR_NONE;
	e.gyro_object_thrust = GYRO_AFFECTOR_NONE;
	e.gyro_object_flags = GYRO_AFFECTOR_NONE;
	Gyro_ObjectList_Remove(e);
	if (GYRO_OBJECTDEBUG > GYRO_AFFECTOR_NONE)
	{
		gyro_framedebug = 1;
		bprint("Gyro Debug: Entity physics cleared for \"");
		bprint(e.classname);
		bprint("\"\nAll physics settings removed\n");
	}
};

void(entity e, float channels) Gyro_Object_SetChannels = 
{
	e.gyro_object_channels = channels;
};

void(entity e, float channels) Gyro_Object_AddChannels = 
{
	e.gyro_object_channels = e.gyro_object_channels | channels;
};

void(entity e, float channels) Gyro_Object_RemoveChannels = 
{
	e.gyro_object_channels = e.gyro_object_channels - (e.gyro_object_channels & channels);
};

void(entity e) Gyro_Object_CallFeedback = 
{
	local entity oldself;
	if (e.gyro_feedback)
	{
		oldself = self;
		self = e;
		self.gyro_feedback();
		self = oldself;
	}
};

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

void(entity e) Gyro_RunPhysics_Bouyancy = 
{
	local float org_content;
	local float bouypower;
	local float inwater;
	local float top_content;
	local vector IMMEDIATE;
	local float top_bouyancy;
	local float mid_bouyancy;
	local float mid_content;
	if (!(e.gyro_object_flags & GYRO_OBJECTFLAG_BOUYANCY))
	{
		return;
	}
	org_content = e.gyro_object_pointcontent;
	if (org_content == CONTENT_WATER)
	{
		bouypower = e.gyro_object_bouyancy_water;
		inwater = 1;
	}
	else
	{
		if (org_content == CONTENT_SLIME)
		{
			bouypower = e.gyro_object_bouyancy_slime;
			inwater = 1;
		}
		else
		{
			if (org_content == CONTENT_LAVA)
			{
				bouypower = e.gyro_object_bouyancy_lava;
				inwater = 1;
			}
			else
			{
				bouypower = e.gyro_object_bouyancy_air;
			}
		}
	}
	e.gyro_object_flags = e.gyro_object_flags - (e.gyro_object_flags & GYRO_OBJECTFLAG_FLOATING);
	if (e.gyro_velocityeffect_z < 60 && e.gyro_velocityeffect_z > -60)
	{
		top_content = pointcontents(e.origin + '0 0 2.4');
		if (top_content != org_content)
		{
			if (top_content == CONTENT_WATER)
			{
				top_bouyancy = e.gyro_object_bouyancy_water;
			}
			else
			{
				if (top_content == CONTENT_SLIME)
				{
					top_bouyancy = e.gyro_object_bouyancy_slime;
				}
				else
				{
					if (top_content == CONTENT_LAVA)
					{
						top_bouyancy = e.gyro_object_bouyancy_lava;
					}
					else
					{
						top_bouyancy = e.gyro_object_bouyancy_air;
					}
				}
			}
			mid_content = pointcontents(e.origin + '0 0 1.2');
			if (mid_content == top_content)
			{
				mid_bouyancy = top_bouyancy;
			}
			else
			{
				mid_bouyancy = bouypower;
			}
			bouypower = (bouypower + top_bouyancy + mid_bouyancy) / GYRO_AFFECTOR_DIRECTIONAL;
			e.gyro_dampeningeffect_z = e.gyro_dampeningeffect_z * Gyro_PowerEstimation(0.6, GYRO_TICKRATE);
			e.gyro_object_flags = e.gyro_object_flags | GYRO_OBJECTFLAG_FLOATING;
		}
	}
	if (e.gyro_feedback)
	{
		if (inwater)
		{
			gyro_feedback_channels = GYRO_AFFECTOR_NONE;
			gyro_feedback_power = bouypower * e.gyro_object_mass;
			if (org_content == CONTENT_WATER)
			{
				gyro_feedback_name = "water";
			}
			else
			{
				if (org_content == CONTENT_SLIME)
				{
					gyro_feedback_name = "slime";
				}
				else
				{
					if (org_content == CONTENT_LAVA)
					{
						gyro_feedback_name = "lava";
					}
				}
			}
			Gyro_Object_CallFeedback(e);
		}
	}
	e.gyro_velocityeffect_z = e.gyro_velocityeffect_z + bouypower * gyro_framegrav * GYRO_TICKRATE;
};

float(entity e) Gyro_Object_RemoveBouyancy = 
{
	e.gyro_object_bouyancy_air = GYRO_AFFECTOR_NONE;
	e.gyro_object_bouyancy_water = GYRO_AFFECTOR_NONE;
	e.gyro_object_bouyancy_slime = GYRO_AFFECTOR_NONE;
	e.gyro_object_bouyancy_lava = GYRO_AFFECTOR_NONE;
	e.gyro_object_flags = e.gyro_object_flags - (e.gyro_object_flags & GYRO_OBJECTFLAG_BOUYANCY);
	if (GYRO_OBJECTDEBUG > GYRO_AFFECTOR_POINT)
	{
		gyro_framedebug = 1;
		bprint("Gyro Debug: Entity bouyancy removed from \"");
		bprint(e.classname);
		bprint("\"\n");
	}
};

void(entity e, float bouyforce, float mod_air, float mod_water, float mod_slime, float mod_lava) Gyro_Object_SetBouyancyMod = 
{
	local float bouypower;
	if (bouyforce == GYRO_AFFECTOR_NONE)
	{
		return Gyro_Object_RemoveBouyancy(e);
	}
	bouypower = bouyforce / e.gyro_object_mass;
	e.gyro_object_bouyancy_air = bouypower * mod_air;
	e.gyro_object_bouyancy_water = bouypower * mod_water;
	e.gyro_object_bouyancy_slime = bouypower * mod_slime;
	e.gyro_object_bouyancy_lava = bouypower * mod_lava;
	e.gyro_object_flags = e.gyro_object_flags | GYRO_OBJECTFLAG_BOUYANCY;
	if (GYRO_OBJECTDEBUG > GYRO_AFFECTOR_POINT)
	{
		gyro_framedebug = 1;
		bprint("Gyro Debug: Entity bouyancy activated for \"");
		bprint(e.classname);
		bprint("\"\nMass: ");
		bprint(ftos(e.gyro_object_mass));
		bprint(", Bouyancy: ");
		bprint(ftos(bouyforce));
		bprint("\n");
	}
};

void(entity e, float bouyforce) Gyro_Object_SetBouyancy = 
{
	Gyro_Object_SetBouyancyMod(e, bouyforce, GYRO_BOUYANCYMOD_AIR, GYRO_BOUYANCYMOD_WATER, GYRO_BOUYANCYMOD_SLIME, GYRO_BOUYANCYMOD_LAVA);
};

void(entity e) Gyro_RunPhysics_Resistance = 
{
	local float resistpower;
	if (!(e.gyro_object_flags & GYRO_OBJECTFLAG_RESISTANCE))
	{
		return;
	}
	if (e.gyro_object_pointcontent == CONTENT_WATER)
	{
		resistpower = e.gyro_object_resistance_water;
	}
	else
	{
		if (e.gyro_object_pointcontent == CONTENT_SLIME)
		{
			resistpower = e.gyro_object_resistance_slime;
		}
		else
		{
			if (e.gyro_object_pointcontent == CONTENT_LAVA)
			{
				resistpower = e.gyro_object_resistance_lava;
			}
			else
			{
				resistpower = e.gyro_object_resistance_air;
			}
		}
	}
	resistpower = Gyro_PowerEstimation(resistpower, GYRO_TICKRATE);
	e.gyro_dampeningeffect = e.gyro_dampeningeffect * resistpower;
	e.gyro_adampeningeffect = e.gyro_adampeningeffect * resistpower;
};

float(entity e) Gyro_Object_RemoveResistance = 
{
	e.gyro_object_resistance_air = GYRO_AFFECTOR_POINT;
	e.gyro_object_resistance_water = GYRO_AFFECTOR_POINT;
	e.gyro_object_resistance_slime = GYRO_AFFECTOR_POINT;
	e.gyro_object_resistance_lava = GYRO_AFFECTOR_POINT;
	e.gyro_object_flags = e.gyro_object_flags - (e.gyro_object_flags & GYRO_OBJECTFLAG_RESISTANCE);
	if (GYRO_OBJECTDEBUG > GYRO_AFFECTOR_POINT)
	{
		gyro_framedebug = 1;
		bprint("Gyro Debug: Entity motion resistance removed from \"");
		bprint(e.classname);
		bprint("\"\n");
	}
};

void(entity e, float resforce, float mod_air, float mod_water, float mod_slime, float mod_lava) Gyro_Object_SetResistanceMod = 
{
	local float respower;
	if (resforce == GYRO_AFFECTOR_NONE)
	{
		return Gyro_Object_RemoveResistance(e);
	}
	respower = resforce / e.gyro_object_mass;
	e.gyro_object_resistance_air = GYRO_AFFECTOR_POINT - respower * mod_air;
	e.gyro_object_resistance_water = GYRO_AFFECTOR_POINT - respower * mod_water;
	e.gyro_object_resistance_slime = GYRO_AFFECTOR_POINT - respower * mod_slime;
	e.gyro_object_resistance_lava = GYRO_AFFECTOR_POINT - respower * mod_lava;
	e.gyro_object_flags = e.gyro_object_flags | GYRO_OBJECTFLAG_RESISTANCE;
	if (GYRO_OBJECTDEBUG > GYRO_AFFECTOR_POINT)
	{
		gyro_framedebug = 1;
		bprint("Gyro Debug: Entity motion resistance activated for \"");
		bprint(e.classname);
		bprint("\"\nMass: ");
		bprint(ftos(e.gyro_object_mass));
		bprint(", Resistance: ");
		bprint(ftos(resforce));
		bprint("\n");
	}
};

void(entity e, float resforce) Gyro_Object_SetResistance = 
{
	Gyro_Object_SetResistanceMod(e, resforce, GYRO_RESISTANCEMOD_AIR, GYRO_RESISTANCEMOD_WATER, GYRO_RESISTANCEMOD_SLIME, GYRO_RESISTANCEMOD_LAVA);
};

void(entity e) Gyro_RunPhysics_Aerodynamics = 
{
	local float movespeed;
	local float aeropower;
	local float avelmult;
	local float adampmult;
	local vector moveangle;
	local vector turnangle;
	if (e.gyro_object_aerodynamics == GYRO_AFFECTOR_NONE)
	{
		return;
	}
	if (e.velocity == VEC_ORIGIN)
	{
		return;
	}
	movespeed = vlen(e.velocity);
	if (e.gyro_object_aerodynamics > GYRO_AFFECTOR_NONE)
	{
		aeropower = e.gyro_object_aerodynamics * 0.010000;
		moveangle = vectoangles(e.velocity);
	}
	else
	{
		aeropower = e.gyro_object_aerodynamics * -0.010000;
		moveangle = vectoangles(VEC_ORIGIN - e.velocity);
	}
	if (e.gyro_object_flags & GYRO_OBJECTFLAG_FLOATING)
	{
		moveangle_x = GYRO_AFFECTOR_NONE;
		movespeed = movespeed + 200;
	}
	avelmult = movespeed * aeropower;
	adampmult = GYRO_AFFECTOR_POINT / (movespeed * aeropower * 0.2 + GYRO_AFFECTOR_POINT);
	turnangle = moveangle - e.angles;
	if (turnangle_x >= 180)
	{
		turnangle_x = turnangle_x - 360;
	}
	else
	{
		if (turnangle_x < -180)
		{
			turnangle_x = turnangle_x + 360;
		}
	}
	if (turnangle_y >= 180)
	{
		turnangle_y = turnangle_y - 360;
	}
	else
	{
		if (turnangle_y < -180)
		{
			turnangle_y = turnangle_y + 360;
		}
	}
	if (turnangle_z >= 180)
	{
		turnangle_z = turnangle_z - 360;
	}
	else
	{
		if (turnangle_z < -180)
		{
			turnangle_z = turnangle_z + 360;
		}
	}
	e.gyro_avelocityeffect = e.gyro_avelocityeffect + turnangle * avelmult * GYRO_TICKRATE;
	e.gyro_adampeningeffect = e.gyro_adampeningeffect * Gyro_PowerEstimation(adampmult, GYRO_TICKRATE);
};

float(entity e) Gyro_Object_RemoveAerodynamics = 
{
	e.gyro_object_aerodynamics = GYRO_AFFECTOR_NONE;
	if (GYRO_OBJECTDEBUG > GYRO_AFFECTOR_POINT)
	{
		gyro_framedebug = 1;
		bprint("Gyro Debug: Entity aerodynamics removed from \"");
		bprint(e.classname);
		bprint("\"\n");
	}
};

void(entity e, float aeroforce) Gyro_Object_SetAerodynamics = 
{
	if (aeroforce == GYRO_AFFECTOR_NONE)
	{
		return Gyro_Object_RemoveAerodynamics(e);
	}
	e.gyro_object_aerodynamics = aeroforce / e.gyro_object_mass;
	if (GYRO_OBJECTDEBUG > GYRO_AFFECTOR_POINT)
	{
		gyro_framedebug = 1;
		bprint("Gyro Debug: Entity aerodynamics activated for \"");
		bprint(e.classname);
		bprint("\"\nMass: ");
		bprint(ftos(e.gyro_object_mass));
		bprint(", Aerodynamics: ");
		bprint(ftos(aeroforce));
		bprint("\n");
	}
};

void(entity e) Gyro_RunPhysics_Thrust = 
{
	local vector gyrothrust;
	if (e.gyro_object_thrust == GYRO_AFFECTOR_NONE)
	{
		return;
	}
	makevectors(e.angles);
	gyrothrust = v_forward;
	gyrothrust_z = GYRO_AFFECTOR_NONE - gyrothrust_z;
	e.gyro_velocityeffect = e.gyro_velocityeffect + gyrothrust * e.gyro_object_thrust * GYRO_TICKRATE * GYRO_POWERCONSTANT;
};

float(entity e) Gyro_Object_RemoveThrust = 
{
	e.gyro_object_thrust = GYRO_AFFECTOR_NONE;
	if (GYRO_OBJECTDEBUG > GYRO_AFFECTOR_POINT)
	{
		gyro_framedebug = 1;
		bprint("Gyro Debug: Entity thrust removed from \"");
		bprint(e.classname);
		bprint("\"\n");
	}
};

void(entity e, float thrustforce) Gyro_Object_SetThrust = 
{
	if (thrustforce == GYRO_AFFECTOR_NONE)
	{
		return Gyro_Object_RemoveThrust(e);
	}
	e.gyro_object_thrust = thrustforce / e.gyro_object_mass;
	if (GYRO_OBJECTDEBUG > GYRO_AFFECTOR_POINT)
	{
		gyro_framedebug = 1;
		bprint("Gyro Debug: Entity thrust activated for \"");
		bprint(e.classname);
		bprint("\"\nMass: ");
		bprint(ftos(e.gyro_object_mass));
		bprint(", Thrust: ");
		bprint(ftos(thrustforce));
		bprint("\n");
	}
};

vector(vector taporigin, vector tapdir, float tapdist) Gyro_RunHoverTap = 
{
	traceline(taporigin, taporigin - tapdir * tapdist, 1, world);
	return tapdir * (GYRO_AFFECTOR_POINT - trace_fraction);
};

void(entity e) Gyro_RunPhysics_Hover = 
{
	local vector totalpush;
	local float tapsleft;
	local vector tapoffset;
	local vector IMMEDIATE;
	local float z_dampen;
	if (e.gyro_object_hover_tap <= GYRO_AFFECTOR_NONE)
	{
		return;
	}
	if (e.gyro_object_hover_dist <= GYRO_AFFECTOR_NONE)
	{
		return;
	}
	if (e.gyro_object_hover_power <= GYRO_AFFECTOR_NONE)
	{
		return;
	}
	tapsleft = ceil(e.gyro_object_hover_tap);
	while (tapsleft)
	{
		if (tapsleft > GYRO_AFFECTOR_POINT)
		{
			tapoffset_x = random() - 0.5;
			tapoffset_y = random() - 0.5;
			tapoffset_z = GYRO_AFFECTOR_NONE;
			totalpush = totalpush + Gyro_RunHoverTap(e.origin, '0 0 1' + tapoffset, e.gyro_object_hover_dist);
			totalpush = totalpush + Gyro_RunHoverTap(e.origin, '0 0 1' - tapoffset, e.gyro_object_hover_dist);
			tapsleft = tapsleft - GYRO_AFFECTOR_POINTMOD;
		}
		else
		{
			totalpush = totalpush + Gyro_RunHoverTap(e.origin, '0 0 1', e.gyro_object_hover_dist);
			tapsleft = tapsleft - GYRO_AFFECTOR_POINT;
		}
	}
	totalpush = totalpush * (GYRO_AFFECTOR_POINT / ceil(e.gyro_object_hover_tap));
	z_dampen = Gyro_PowerEstimation(GYRO_AFFECTOR_POINT - vlen(totalpush) * 0.8, GYRO_TICKRATE);
	e.gyro_velocityeffect = e.gyro_velocityeffect + totalpush * e.gyro_object_hover_power * gyro_framegrav * GYRO_TICKRATE;
	e.gyro_dampeningeffect_z = e.gyro_dampeningeffect_z * z_dampen;
};

void(entity e) Gyro_Object_RemoveHover = 
{
	e.gyro_object_hover_tap = GYRO_AFFECTOR_NONE;
	e.gyro_object_hover_dist = GYRO_AFFECTOR_NONE;
	e.gyro_object_hover_power = GYRO_AFFECTOR_NONE;
	if (GYRO_OBJECTDEBUG > GYRO_AFFECTOR_POINT)
	{
		gyro_framedebug = 1;
		bprint("Gyro Debug: Entity hover removed from \"");
		bprint(e.classname);
		bprint("\"\n");
	}
};

void(entity e, float hoverforce, float hoverdist, float hovertap) Gyro_Object_SetHover = 
{
	if (hoverforce <= GYRO_AFFECTOR_NONE)
	{
		return Gyro_Object_RemoveThrust(e);
	}
	if (hoverdist <= GYRO_AFFECTOR_NONE)
	{
		return Gyro_Object_RemoveThrust(e);
	}
	if (hovertap <= GYRO_AFFECTOR_NONE)
	{
		return Gyro_Object_RemoveThrust(e);
	}
	hovertap = ceil(hovertap);
	e.gyro_object_hover_tap = hovertap;
	e.gyro_object_hover_dist = hoverdist;
	e.gyro_object_hover_power = hoverforce / e.gyro_object_mass;
	if (GYRO_OBJECTDEBUG > GYRO_AFFECTOR_POINT)
	{
		gyro_framedebug = 1;
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

void(entity e) Gyro_RunPhysics_Turbulence = 
{
	local float turbpower;
	if (!(e.gyro_object_flags & GYRO_OBJECTFLAG_TURBULENCE))
	{
		return;
	}
	if (e.gyro_object_pointcontent == CONTENT_WATER)
	{
		turbpower = e.gyro_object_turbulence_water;
	}
	else
	{
		if (e.gyro_object_pointcontent == CONTENT_SLIME)
		{
			turbpower = e.gyro_object_turbulence_slime;
		}
		else
		{
			if (e.gyro_object_pointcontent == CONTENT_LAVA)
			{
				turbpower = e.gyro_object_turbulence_lava;
			}
			else
			{
				turbpower = e.gyro_object_turbulence_air;
			}
		}
	}
	turbpower = turbpower * GYRO_POWERCONSTANT * GYRO_TICKRATE;
	e.gyro_velocityeffect_x = e.gyro_velocityeffect_x + (random() - 0.5) * turbpower;
	e.gyro_velocityeffect_y = e.gyro_velocityeffect_y + (random() - 0.5) * turbpower;
	if (!(e.gyro_object_flags & GYRO_OBJECTFLAG_FLOATING))
	{
		e.gyro_velocityeffect_z = e.gyro_velocityeffect_z + (random() - 0.5) * turbpower;
	}
};

float(entity e) Gyro_Object_RemoveTurbulence = 
{
	e.gyro_object_turbulence_air = GYRO_AFFECTOR_NONE;
	e.gyro_object_turbulence_water = GYRO_AFFECTOR_NONE;
	e.gyro_object_turbulence_slime = GYRO_AFFECTOR_NONE;
	e.gyro_object_turbulence_lava = GYRO_AFFECTOR_NONE;
	e.gyro_object_flags = e.gyro_object_flags - (e.gyro_object_flags & GYRO_OBJECTFLAG_TURBULENCE);
	if (GYRO_OBJECTDEBUG > GYRO_AFFECTOR_POINT)
	{
		gyro_framedebug = 1;
		bprint("Gyro Debug: Entity turbulence removed from \"");
		bprint(e.classname);
		bprint("\"\n");
	}
};

void(entity e, float turbforce, float airmod, float watermod, float slimemod, float lavamod) Gyro_Object_SetTurbulenceMod = 
{
	if (turbforce <= GYRO_AFFECTOR_NONE)
	{
		return Gyro_Object_RemoveTurbulence(e);
	}
	turbforce = turbforce / e.gyro_object_mass;
	e.gyro_object_turbulence_air = turbforce * airmod;
	e.gyro_object_turbulence_water = turbforce * watermod;
	e.gyro_object_turbulence_slime = turbforce * slimemod;
	e.gyro_object_turbulence_lava = turbforce * lavamod;
	e.gyro_object_flags = e.gyro_object_flags | GYRO_OBJECTFLAG_TURBULENCE;
	if (GYRO_OBJECTDEBUG > GYRO_AFFECTOR_POINT)
	{
		gyro_framedebug = 1;
		bprint("Gyro Debug: Entity turbulence activated for \"");
		bprint(e.classname);
		bprint("\"\nMass: ");
		bprint(ftos(e.gyro_object_mass));
		bprint(", Turbulence: ");
		bprint(ftos(turbforce));
		bprint("\n");
	}
};

void(entity e, float turbforce) Gyro_Object_SetTurbulence = 
{
	Gyro_Object_SetTurbulenceMod(e, turbforce, GYRO_TURBULENCEMOD_AIR, GYRO_TURBULENCEMOD_WATER, GYRO_TURBULENCEMOD_SLIME, GYRO_TURBULENCEMOD_LAVA);
};

void(entity e) Gyro_RunPhysics_GlobalTurb = 
{
	local float turbpower;
	if (!(e.gyro_object_flags & GYRO_OBJECTFLAG_GLOBALTURB))
	{
		return;
	}
	if (e.gyro_object_pointcontent == CONTENT_WATER)
	{
		turbpower = e.gyro_object_turbulence_water;
	}
	else
	{
		if (e.gyro_object_pointcontent == CONTENT_SLIME)
		{
			turbpower = e.gyro_object_turbulence_slime;
		}
		else
		{
			if (e.gyro_object_pointcontent == CONTENT_LAVA)
			{
				turbpower = e.gyro_object_turbulence_lava;
			}
			else
			{
				turbpower = e.gyro_object_turbulence_air;
			}
		}
	}
	turbpower = turbpower * GYRO_POWERCONSTANT * GYRO_TICKRATE;
	e.gyro_velocityeffect_x = e.gyro_velocityeffect_x + gyro_globalturbulence_x * turbpower;
	e.gyro_velocityeffect_y = e.gyro_velocityeffect_y + gyro_globalturbulence_y * turbpower;
	if (!(e.gyro_object_flags & GYRO_OBJECTFLAG_FLOATING))
	{
		e.gyro_velocityeffect_z = e.gyro_velocityeffect_z + gyro_globalturbulence_z * turbpower;
	}
};

float(entity e) Gyro_Object_RemoveGlobalTurb = 
{
	e.gyro_object_turbulence_air = GYRO_AFFECTOR_NONE;
	e.gyro_object_turbulence_water = GYRO_AFFECTOR_NONE;
	e.gyro_object_turbulence_slime = GYRO_AFFECTOR_NONE;
	e.gyro_object_turbulence_lava = GYRO_AFFECTOR_NONE;
	e.gyro_object_flags = e.gyro_object_flags - (e.gyro_object_flags & GYRO_OBJECTFLAG_GLOBALTURB);
	if (GYRO_OBJECTDEBUG > GYRO_AFFECTOR_POINT)
	{
		gyro_framedebug = 1;
		bprint("Gyro Debug: Entity global-turbulence removed from \"");
		bprint(e.classname);
		bprint("\"\n");
	}
};

void(entity e, float turbforce, float airmod, float watermod, float slimemod, float lavamod) Gyro_Object_SetGlobalTurbMod = 
{
	if (turbforce <= GYRO_AFFECTOR_NONE)
	{
		return Gyro_Object_RemoveGlobalTurb(e);
	}
	turbforce = turbforce / e.gyro_object_mass;
	e.gyro_object_turbulence_air = turbforce * airmod;
	e.gyro_object_turbulence_water = turbforce * watermod;
	e.gyro_object_turbulence_slime = turbforce * slimemod;
	e.gyro_object_turbulence_lava = turbforce * lavamod;
	e.gyro_object_flags = e.gyro_object_flags | GYRO_OBJECTFLAG_GLOBALTURB;
	if (GYRO_OBJECTDEBUG > GYRO_AFFECTOR_POINT)
	{
		gyro_framedebug = 1;
		bprint("Gyro Debug: Entity global-turbulence activated for \"");
		bprint(e.classname);
		bprint("\"\nMass: ");
		bprint(ftos(e.gyro_object_mass));
		bprint(", Turbulence: ");
		bprint(ftos(turbforce));
		bprint("\n");
	}
};

void(entity e, float turbforce) Gyro_Object_SetGlobalTurb = 
{
	Gyro_Object_SetGlobalTurbMod(e, turbforce, GYRO_TURBULENCEMOD_AIR, GYRO_TURBULENCEMOD_WATER, GYRO_TURBULENCEMOD_SLIME, GYRO_TURBULENCEMOD_LAVA);
};

void(entity e) Gyro_RunPhysics_AngleTurb = 
{
	local float turbeffect;
	if (e.gyro_object_angleturb == GYRO_AFFECTOR_NONE)
	{
		return;
	}
	turbeffect = e.gyro_object_angleturb * GYRO_TICKRATE * 360;
	e.gyro_avelocityeffect_x = e.gyro_avelocityeffect_x + (random() - 0.5) * turbeffect;
	e.gyro_avelocityeffect_y = e.gyro_avelocityeffect_y + (random() - 0.5) * turbeffect;
	e.gyro_avelocityeffect_z = e.gyro_avelocityeffect_z + (random() - 0.5) * turbeffect;
};

float(entity e) Gyro_Object_RemoveAngleTurb = 
{
	e.gyro_object_angleturb = GYRO_AFFECTOR_NONE;
	if (GYRO_OBJECTDEBUG > GYRO_AFFECTOR_POINT)
	{
		gyro_framedebug = 1;
		bprint("Gyro Debug: Entity angular-turbulence removed from \"");
		bprint(e.classname);
		bprint("\"\n");
	}
};

void(entity e, float turbforce) Gyro_Object_SetAngleTurb = 
{
	if (turbforce <= GYRO_AFFECTOR_NONE)
	{
		return Gyro_Object_RemoveAngleTurb(e);
	}
	e.gyro_object_angleturb = turbforce / e.gyro_object_mass;
	if (GYRO_OBJECTDEBUG > GYRO_AFFECTOR_POINT)
	{
		gyro_framedebug = 1;
		bprint("Gyro Debug: Entity angular-turbulence activated for \"");
		bprint(e.classname);
		bprint("\"\nMass: ");
		bprint(ftos(e.gyro_object_mass));
		bprint(", Turbulence: ");
		bprint(ftos(turbforce));
		bprint("\n");
	}
};

void() Gyro_RunPhysics = 
{
	local entity gyrohead;
	local float gyroheadcount;
	local float movespeed;
	gyro_globalturbulence_x = random() - 0.5;
	gyro_globalturbulence_y = random() - 0.5;
	gyro_globalturbulence_z = random() - 0.5;
	gyrohead = gyro_objectlist_head;
	while (gyrohead)
	{
		gyrohead.gyro_object_pointcontent = pointcontents(gyrohead.origin);
		Gyro_RunPhysics_Bouyancy(gyrohead);
		Gyro_RunPhysics_Resistance(gyrohead);
		Gyro_RunPhysics_Aerodynamics(gyrohead);
		Gyro_RunPhysics_Thrust(gyrohead);
		Gyro_RunPhysics_Hover(gyrohead);
		Gyro_RunPhysics_Turbulence(gyrohead);
		Gyro_RunPhysics_AngleTurb(gyrohead);
		Gyro_RunPhysics_GlobalTurb(gyrohead);
		gyrohead.velocity_x = gyrohead.velocity_x * gyrohead.gyro_dampeningeffect_x;
		gyrohead.velocity_y = gyrohead.velocity_y * gyrohead.gyro_dampeningeffect_y;
		gyrohead.velocity_z = gyrohead.velocity_z * gyrohead.gyro_dampeningeffect_z;
		gyrohead.avelocity_x = gyrohead.avelocity_x * gyrohead.gyro_adampeningeffect_x;
		gyrohead.avelocity_y = gyrohead.avelocity_y * gyrohead.gyro_adampeningeffect_y;
		gyrohead.avelocity_z = gyrohead.avelocity_z * gyrohead.gyro_adampeningeffect_z;
		gyrohead.velocity = gyrohead.velocity + gyrohead.gyro_velocityeffect;
		gyrohead.avelocity = gyrohead.avelocity + gyrohead.gyro_avelocityeffect;
		if (gyrohead.gyro_antigravityeffect > GYRO_AFFECTOR_NONE && gyrohead.movetype != TE_LIGHTNING3)
		{
			if (gyrohead.gyro_antigravityeffect > GYRO_AFFECTOR_POINT)
			{
				gyrohead.gyro_antigravityeffect = GYRO_AFFECTOR_POINT;
			}
			gyrohead.velocity_z = gyrohead.velocity_z + gyrohead.gyro_antigravityeffect * gyro_framegrav * GYRO_TICKRATE;
		}
		if (gyrohead.flags & FL_ONGROUND && gyrohead.movetype != GYRO_AFFECTOR_DIRECTIONAL)
		{
			movespeed = vlen(gyrohead.velocity);
			if (movespeed > gyro_framegrav * GYRO_TICKRATE * GYRO_TURBULENCEMOD_SLIME)
			{
				gyrohead.velocity_z = movespeed;
				gyrohead.flags = gyrohead.flags - FL_ONGROUND;
			}
		}
		if (gyrohead.flags & FL_ONGROUND && gyrohead.movetype != GYRO_AFFECTOR_DIRECTIONAL)
		{
			gyrohead.velocity = VEC_ORIGIN;
			gyrohead.avelocity = VEC_ORIGIN;
		}
		if (GYRO_MOTIONCORRECTION)
		{
			if (gyrohead.velocity_x > gyro_framemaxvel)
			{
				gyrohead.velocity = gyrohead.velocity * (gyro_framemaxvel / gyrohead.velocity_x);
			}
			if (gyrohead.velocity_x < gyro_framemaxvelneg)
			{
				gyrohead.velocity = gyrohead.velocity * (gyro_framemaxvelneg / gyrohead.velocity_x);
			}
			if (gyrohead.velocity_y > gyro_framemaxvel)
			{
				gyrohead.velocity = gyrohead.velocity * (gyro_framemaxvel / gyrohead.velocity_y);
			}
			if (gyrohead.velocity_y < gyro_framemaxvelneg)
			{
				gyrohead.velocity = gyrohead.velocity * (gyro_framemaxvelneg / gyrohead.velocity_y);
			}
			if (gyrohead.velocity_z > gyro_framemaxvel)
			{
				gyrohead.velocity = gyrohead.velocity * (gyro_framemaxvel / gyrohead.velocity_z);
			}
			if (gyrohead.velocity_z < gyro_framemaxvelneg)
			{
				gyrohead.velocity = gyrohead.velocity * (gyro_framemaxvelneg / gyrohead.velocity_z);
			}
		}
		gyrohead.gyro_velocityeffect = VEC_ORIGIN;
		gyrohead.gyro_avelocityeffect = VEC_ORIGIN;
		gyrohead.gyro_dampeningeffect = '1 1 1';
		gyrohead.gyro_adampeningeffect = '1 1 1';
		gyrohead.gyro_antigravityeffect = GYRO_AFFECTOR_NONE;
		gyroheadcount = gyroheadcount + GYRO_AFFECTOR_POINT;
		gyrohead = gyrohead.gyro_objectlist_next;
	}
};


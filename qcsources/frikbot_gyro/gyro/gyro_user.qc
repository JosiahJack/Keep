
//=============================================
//===== Gyro User Settings ====================
//=============================================

//----- Apply User Settings on Startup --------------------
void() Gyro_UserSettings =
{
	//----- Tickrate Settings --------------------
	GYRO_AUTOTICKRATE = TRUE;
	GYRO_TICKRATE = 0.03;
	
	//----- Misc Settings --------------------
	GYRO_MOTIONCORRECTION = TRUE;
	GYRO_POWERCONSTANT = 800.0;
	
	//----- Debug Modes --------------------
	GYRO_FORCEDEBUG = 1;
	GYRO_OBJECTDEBUG = 1;
	
	
	//----- Natural Bouyancy Settings --------------------
	GYRO_BOUYANCYMOD_AIR	= 0.0;
	GYRO_BOUYANCYMOD_WATER	= 1.0;
	GYRO_BOUYANCYMOD_SLIME	= 1.2;
	GYRO_BOUYANCYMOD_LAVA	= 1.4;
	
	//----- Natural Resistance Settings --------------------
	GYRO_RESISTANCEMOD_AIR		= 0.1;
	GYRO_RESISTANCEMOD_WATER	= 1.0;
	GYRO_RESISTANCEMOD_SLIME		= 1.2;
	GYRO_RESISTANCEMOD_LAVA		= 1.4;
	
	//----- Natural Turbulence Settings --------------------
	GYRO_TURBULENCEMOD_AIR		= 0.1;
	GYRO_TURBULENCEMOD_WATER	= 1.0;
	GYRO_TURBULENCEMOD_SLIME		= 1.2;
	GYRO_TURBULENCEMOD_LAVA		= 1.4;
};



//==============================================
//===== Gyro User Constants ====================
//==============================================

//----- Force Channels --------------------
float	GYRO_CHANNEL_DEFAULT		= 1;
float	GYRO_CHANNEL_EXPLOSION	= 2
float	GYRO_CHANNEL_METAL		= 4;
float	GYRO_CHANNEL_ORGANIC		= 8;
float	GYRO_CHANNEL_MAGIC		= 16;



//================================================
//===== Physics Object Macros ====================
//================================================

//----- Grenade/Metal Object Physics Macro --------------------
void(entity e, float mass) Gyro_ObjectMacro_Grenade =
{
	Gyro_Object_Activate(e, mass);
	Gyro_Object_SetBouyancy(e, mass*0.6);
	Gyro_Object_SetResistance(e, mass*0.4);
	Gyro_Object_SetAerodynamics(e, mass*0.8);
};


//----- Gib and Gore Object Macro --------------------
void(entity e, float mass) Gyro_ObjectMacro_Gib =
{
	Gyro_Object_Activate(e, mass);
	Gyro_Object_SetBouyancy(e, mass*1.2);
	Gyro_Object_SetResistance(e, mass*0.6);
	Gyro_Object_SetAerodynamics(e, mass*0.6);
	Gyro_Object_SetTurbulence(e, mass*0.24, 0.95);
	Gyro_Object_SetGlobalTurb(e, mass*0.16, 0.95);
};


//----- Thrust-Powered Rocket Macro --------------------
void(entity e, float mass, float thrustpower) Gyro_ObjectMacro_Rocket =
{
	Gyro_Object_Activate(e, mass);
	Gyro_Object_SetBouyancy(e, mass*0.8);
	Gyro_Object_SetResistanceMod(e, mass, 0.02, 1.0, 1.2, 1.4);
	Gyro_Object_SetAerodynamics(e, mass*8.0);
	Gyro_Object_SetThrust(e, thrustpower);
};


//----- Unpredictable 'Drunk Missile' Macro --------------------
void(entity e, float mass, float thrustpower) Gyro_ObjectMacro_DrunkMissile =
{
	Gyro_Object_Activate(e, mass);
	Gyro_Object_SetBouyancy(e, mass*0.8);
	Gyro_Object_SetResistance(e, mass*1.2);
	Gyro_Object_SetAerodynamics(e, mass*8.0);
	Gyro_Object_SetAngleTurb(e, mass*40.0);
	Gyro_Object_SetThrust(e, thrustpower);
};



//==============================================
//===== Force Entity Macros ====================
//==============================================

//----- Instant-Force Explosion Macro --------------------
entity(vector org, float radius, float power) Gyro_ForceMacro_Explosion =
{
	local entity	force;
	force = Gyro_Force_Create("explosion", org);
	Gyro_Force_ApplyFalloff_AreaLinear(force, '1 1 1' * radius);
	Gyro_Force_ApplyAffector_Point(force, '0 0 -16', '1 1 1', power, FALSE);
	Gyro_Force_AddProperty_Instant(force);
	return force;
};


//----- Dampening Field Macro - Halts Objects in Mid-Air --------------------
entity(vector org, float radius, float duration) Gyro_ForceMacro_DampeningField =
{
	local entity	force;
	force = Gyro_Force_Create("dampenfield", org);
	Gyro_Force_ApplyFalloff_AreaConstant(force, '1 1 1' * radius);
	Gyro_Force_ApplyAffector_Resistance(force, '1 1 1', 2, TRUE);
	Gyro_Force_ApplyAffector_AntiGravity(force, 1, TRUE);
	Gyro_Force_SetRangeScaleRate(force, -1 / duration);
	return force;
};


//----- Instant-Thumper Macro - Blasts Many Objects into the Air --------------------
entity(vector org, float radius, float power) Gyro_ForceMacro_Thumper =
{
	local entity	force;
	force = Gyro_Force_Create("thumper", org);
	Gyro_Force_ApplyFalloff_AreaLinear(force, '1 1 1' * radius);
	Gyro_Force_ApplyAffector_Directional(force, '0 0 1', power, FALSE);
	Gyro_Force_AddProperty_GroundPound(force);
	Gyro_Force_AddProperty_IgnoreWalls(force);
	Gyro_Force_AddProperty_Instant(force);
	return force;
};


//----- Whirlwind Macro --------------------
entity(vector org, float radius, float power, float duration) Gyro_ForceMacro_Whirlwind =
{
	local entity	force;
	force = Gyro_Force_Create("whirlwind", org + '0 0 32');
	Gyro_Force_ApplyFalloff_AreaLinear(force, '1 1 0' * radius);
	Gyro_Force_ApplyFalloff_AreaLinear(force, '0 0 1' * radius * 0.5);
	Gyro_Force_FalloffCombine_Minimum(force);
	Gyro_Force_SetPowerScaleRate(force, -1 / duration);
	
	Gyro_Force_ApplyAffector_PointMod(force, '0 0 0', '1 1 0', power, FALSE, '0 -1 0', '1 0 0', '0 0 0');
	Gyro_Force_ApplyAffector_Point(force, '0 0 0', '1 1 1', power*(-1.2), FALSE);
	Gyro_Force_ApplyAffector_AntiGravity(force, power, FALSE);
	Gyro_Force_ApplyAffector_Resistance(force, '1 1 1', power, FALSE);
	return force;
};


//----- Gravity Bomb - Disrupts the Gravity for a Short While --------------------
entity(float duration) Gyro_ForceMacro_GravityBomb =
{
	local entity	grav, bomb;
	grav = Gyro_Force_Create("gravbomb", '0 0 0');
	Gyro_Force_ApplyFalloff_AreaConstant(grav, '0 0 0');
	Gyro_Force_ApplyAffector_AntiGravity(grav, 4.0, TRUE);
	Gyro_Force_AddProperty_IgnoreWalls(grav);
	Gyro_Force_SetPowerScaleRate(grav, -1 / duration);
	
	bomb = Gyro_Force_Create("gravbomb_push", '0 0 0');
	Gyro_Force_ApplyFalloff_AreaConstant(bomb, '0 0 0');
	Gyro_Force_ApplyAffector_Directional(bomb, '0 0 1', 0.2, TRUE);
	Gyro_Force_AddProperty_IgnoreWalls(bomb);
	Gyro_Force_AddProperty_Instant(bomb);
	return grav;
};


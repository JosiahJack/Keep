void() Gyro_UserSettings = 
{
	GYRO_AUTOTICKRATE = 1;
	GYRO_TICKRATE = 0.030000;
	GYRO_MOTIONCORRECTION = 1;
	GYRO_POWERCONSTANT = 800;
	GYRO_FORCEDEBUG = GYRO_AFFECTOR_POINT;
	GYRO_OBJECTDEBUG = GYRO_AFFECTOR_POINT;
};

void(entity e, float mass) Gyro_ObjectMacro_Grenade = 
{
	Gyro_Object_Activate(e, mass);
	Gyro_Object_SetBouyancy(e, mass * 0.6);
	Gyro_Object_SetResistance(e, mass * 0.6);
	Gyro_Object_SetAerodynamics(e, mass * 0.8);
};

void(entity e, float mass) Gyro_ObjectMacro_Gib = 
{
	Gyro_Object_Activate(e, mass);
	Gyro_Object_SetBouyancy(e, mass * GYRO_TURBULENCEMOD_SLIME);
	Gyro_Object_SetResistance(e, mass * 0.8);
	Gyro_Object_SetAerodynamics(e, mass * 0.6);
	Gyro_Object_SetTurbulence(e, mass * 0.240000);
	Gyro_Object_SetGlobalTurb(e, mass * 0.160000);
};

void(entity e, float mass, float thrustpower) Gyro_ObjectMacro_Rocket = 
{
	Gyro_Object_Activate(e, mass);
	Gyro_Object_SetBouyancy(e, mass * 0.8);
	Gyro_Object_SetResistanceMod(e, mass, 0.020000, GYRO_CHANNEL_DEFAULT, GYRO_TURBULENCEMOD_SLIME, GYRO_TURBULENCEMOD_LAVA);
	Gyro_Object_SetAerodynamics(e, mass * GYRO_CHANNEL_METAL);
	Gyro_Object_SetThrust(e, thrustpower);
};

void(entity e, float mass, float thrustpower) Gyro_ObjectMacro_DrunkMissile = 
{
	Gyro_Object_Activate(e, mass);
	Gyro_Object_SetBouyancy(e, mass * 0.8);
	Gyro_Object_SetResistance(e, mass * GYRO_TURBULENCEMOD_SLIME);
	Gyro_Object_SetAerodynamics(e, mass * GYRO_CHANNEL_ORGANIC);
	Gyro_Object_SetAngleTurb(e, mass * 40);
	Gyro_Object_SetThrust(e, thrustpower);
};

void(vector org, float radius, float power) Gyro_ForceMacro_Explosion = 
{
	local entity force;
	force = Gyro_Force_Create("explosion", org);
	Gyro_Force_ApplyFalloff_Linear(force, '1 1 1' * radius);
	Gyro_Force_ApplyAffector_Point(force, '0 0 -16', '1 1 1', power, 0);
	Gyro_Force_AddProperty_Instant(force);
	return force;
};

void(vector org, float radius, float duration) Gyro_ForceMacro_DampeningField = 
{
	local entity force;
	force = Gyro_Force_Create("dampenfield", org);
	Gyro_Force_ApplyFalloff_Constant(force, '1 1 1' * radius);
	Gyro_Force_ApplyAffector_Resistance(force, '1 1 1', GYRO_CHANNEL_EXPLOSION, 1);
	Gyro_Force_ApplyAffector_AntiGravity(force, GYRO_CHANNEL_DEFAULT, 1);
	Gyro_Force_SetRangeScaleRate(force, CONTENT_EMPTY / duration);
	return force;
};

void(vector org, float radius, float power) Gyro_ForceMacro_Thumper = 
{
	local entity force;
	force = Gyro_Force_Create("thumper", org);
	Gyro_Force_ApplyFalloff_Linear(force, '1 1 1' * radius);
	Gyro_Force_ApplyAffector_Directional(force, '0 0 1', power, 0);
	Gyro_Force_AddProperty_IgnoreWalls(force);
	Gyro_Force_AddProperty_Instant(force);
	return force;
};

void(vector org, float radius, float power, float duration) Gyro_ForceMacro_Whirlwind = 
{
	local entity force;
	force = Gyro_Force_Create("whirlwind", org + '0 0 32');
	Gyro_Force_ApplyFalloff_Linear(force, '1 1 0' * radius);
	Gyro_Force_ApplyFalloff_Linear(force, '0 0 1' * radius * 0.5);
	Gyro_Force_FalloffCombine_Minimum(force);
	Gyro_Force_SetPowerScaleRate(force, CONTENT_EMPTY / duration);
	Gyro_Force_ApplyAffector_PointMod(force, VEC_ORIGIN, '1 1 0', power, 0, '0 -1 0', '1 0 0', VEC_ORIGIN);
	Gyro_Force_ApplyAffector_Point(force, VEC_ORIGIN, '1 1 1', power * -1.2, 0);
	Gyro_Force_ApplyAffector_AntiGravity(force, power, 0);
	Gyro_Force_ApplyAffector_Resistance(force, '1 1 1', power, 0);
	return force;
};

void(float duration) Gyro_ForceMacro_GravityBomb = 
{
	local entity grav;
	local entity bomb;
	grav = Gyro_Force_Create("gravbomb", VEC_ORIGIN);
	Gyro_Force_ApplyFalloff_Constant(grav, VEC_ORIGIN);
	Gyro_Force_ApplyAffector_AntiGravity(grav, GYRO_CHANNEL_METAL, 1);
	Gyro_Force_AddProperty_IgnoreWalls(grav);
	Gyro_Force_SetPowerScaleRate(grav, CONTENT_EMPTY / duration);
	bomb = Gyro_Force_Create("gravbomb_push", VEC_ORIGIN);
	Gyro_Force_ApplyFalloff_Constant(bomb, VEC_ORIGIN);
	Gyro_Force_ApplyAffector_Directional(bomb, '0 0 1', 0.2, 1);
	Gyro_Force_AddProperty_IgnoreWalls(bomb);
	Gyro_Force_AddProperty_Instant(bomb);
	return grav;
};


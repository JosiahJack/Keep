// For weapon and damage forces, check the corresponding functions in "weapons.qc" and "combat.qc"


void(entity gibentity) GibPhysics =
{
local float gibbouyancy;

var float autocvar_gyroset = 2;     	// set cvar 'gyroset' default to 2
	if (autocvar_gyroset == 0)	// if 'gyroset' is set to '0', Gyro is not enabled
		return;

var float autocvar_gibmass = 800;
	Gyro_Object_Activate(gibentity, autocvar_gibmass);

gibbouyancy = autocvar_gibmass + 150;

	Gyro_Object_SetBouyancy(gibentity, gibbouyancy);
	Gyro_Object_SetResistance(gibentity, autocvar_gibmass); 
	Gyro_Object_SetTurbulence(gibentity, 260, 0.98);
	Gyro_Object_SetGlobalTurb(gibentity, 160, 0.98);
};


void(entity hydraentity) HydraPhysics =
{
local float hydrabouyancy;

var float autocvar_gyroset = 2;     	// set cvar 'gyroset' default to 2
	if (autocvar_gyroset == 0)	// if 'gyroset' is set to '0', Gyro is not enabled
		return;

	Gyro_Object_Activate(hydraentity, 3000);

hydrabouyancy = 3000 + 300;

	Gyro_Object_SetBouyancy(hydraentity, hydrabouyancy);
	Gyro_Object_SetResistance(hydraentity, 10000); 
	Gyro_Object_SetTurbulence(hydraentity, 260, 0.98);
	Gyro_Object_SetGlobalTurb(hydraentity, 160, 0.98);
};


void(entity monsterentity, float mass) MonsterPhysics =
{
var float autocvar_gyroset = 2;     	// set cvar 'gyroset' default to 2
	if (autocvar_gyroset < 2)	// if 'gyroset' is set '2' Gyro is not enabled on monsters
		return;

	Gyro_Object_Activate(monsterentity, mass);
};


void(entity bagentity) BackpackPhysics =
{
local float bagbouyancy;

var float autocvar_gyroset = 2;     	// set cvar 'gyroset' default to 2
	if (autocvar_gyroset == 0)	// if 'gyroset' is set to '0', Gyro is not enabled
		return;

var float autocvar_backpackmass = 1500;
	Gyro_Object_Activate(bagentity, autocvar_backpackmass);

bagbouyancy = autocvar_backpackmass + 300;

	Gyro_Object_SetBouyancy(bagentity, bagbouyancy);
	Gyro_Object_SetResistance(bagentity, autocvar_backpackmass); 
	Gyro_Object_SetTurbulence(bagentity, 260, 0.98);
	Gyro_Object_SetGlobalTurb(bagentity, 160, 0.98);
};



/*
void(entity itementity, float mass) ItemPhysics =
{
	Gyro_Object_Activate(itementity, mass);
};
*/

void() RyanscissorhandsChecks; //called every frame by PlayerPostThink() to ensure that the proper player model is being used while wielding weapons
void() W_FireScimitar; //the first attack in the scimitar's combo
void() W_FireRapier; //
void() W_FireIce; //
void() W_FireMace; //
void() W_FireVoidStaff; //
void() W_FireFlak; //
void() W_FireGungnir; //
void() W_FireSanguinators; //
void() StaffShot1;
void() VoidStaffProjectile;
void() precache_aoa;
void() LaunchBoulder;
void() GungnirVortex1;
.float ammo_bloodcrystals;
.float ammo_voidshards;
.float ammo_elemental;

float(entity target) CountFlakAmmo;

//==========================================================================
//  fire.h -- by Patrick Martin                 Last updated:  5-1-2001
//--------------------------------------------------------------------------
//  This is the header file for the fire*.qc files.
//  Constants, fields, and prototypes are defined here.
//==========================================================================

//-----------------//
//  NEW CONSTANTS  //
//-----------------//
// Default radii for fire damage.
float   RADIUS_SMALL_BURN   = 50;
float   RADIUS_LARGE_BURN   = 70;
float   RADIUS_FIRE_SPLASH  = 80;

// Default radius distance multiplier.  (Range:  0-1)
float   X_DELTA         = 1;

// Default burn damage.  (x = die, y = base, z = max. burn damage)
vector  DMG_ONFIRE      = '4 1 50';

// Misc. values.
float   ZOMBIE_HEALTH   = 60;


//--------------------//
//  NEW EDICT FIELDS  //
//--------------------//
.float  burnout;        // Max. burn damage before fire is extinguished.
.entity burner;         // The fire burning on an entity.
.entity flamer;         // Like 'owner' except projectiles do not pass thru.


//--------------//
//  PROTOTYPES  //
//--------------//

//
//  fire1.qc
//  The core burn code.
//
void() PM_PrecacheFire;
void(entity ent) PM_KillFire;

void(entity fire) PM_MakeSmoke;
void(entity fire) PM_BecomeSmoke;
void(entity fire) PM_BecomeSteam;
void(entity fire) PM_PlayFireHitSound;
void(vector spot) PM_MakeExplosion;
entity(entity attacker, entity victim, vector spot) PM_NewFire;

float(entity ent) PM_IsBurning;
float(entity ent) PM_FireResistant;

void(entity victim, entity fire, float damage) PM_NapalmDamage;
void(entity victim, entity fire, float multiplier, vector hit_damage,
    vector burn_damage) PM_BurnDamage;
void(entity fire, float radius, vector hit_damage, vector burn_damage,
    float fade, float no_resist, entity ignore) PM_BurnRadius;
void(entity fire, float radius, float chance, vector burn_damage,
    entity ignore) PM_IgniteRadius;
float(float radius, float factor, float damage) PM_DistanceFactor;

void() PM_CheckFire;
void() PM_CheckTossFire;
void() PM_FireDropTouch;
void(entity attacker, entity victim, vector spot, vector hit_damage,
    vector burn_damage, float chance) PM_FireDrop;

vector(entity ent) PM_FireSpot;
float() PM_FlameOut;
void() PM_Burn;
void(entity victim, entity attacker, vector burn_damage) PM_Ignite;


//
//  fire2.qc
//  Generic fire-based attacks.
//
void() PM_CloudBurst;
void(entity attacker, vector org, vector cloud, vector timers,
    vector hit_damage, vector burn_damage, vector chance, vector vel)
    PM_FlameCloud;

void() PM_FireballTouch;
void(entity attacker, vector org, vector dir, float sped,
    vector hit_damage, vector burn_damage, vector chance, float toss)
    PM_FireFlamer;
void(entity attacker, vector org, vector dir, vector hit_damage,
    vector burn_damage, vector chance) PM_FireInstantFlamer;

void() s_napalm1;
void() s_napalm2;
void() s_napalm3;
void() s_napalm4;
void() s_napalm5;
void() s_napalm6;
void() PM_FlamethrowerTouch;
void(entity attacker, vector org, vector dir, float sped,
    vector fry_damage, vector hit_damage, vector burn_damage,
    vector chance) PM_FireFlamethrower;


//
//  weapons.qc
//
void() BecomeExplosion;
void() s_explode1;


//===========================/  END OF FILE  /===========================//

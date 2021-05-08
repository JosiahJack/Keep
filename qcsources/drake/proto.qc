//===========================================================================
//  Prototypes

//- - - - - - - - - - - - - - - - - - -
// PM:  It can be a huge annoyance to change or remove functions, then
// hunt down their prototypes when compiler errors or warnings show up.
// Most function prototypes used in Drake will be found here.
// The basic idea is if a section of code needs a prototype to call
// a function found in another file, it is placed here.
//
// Exceptions:
// * FrikBot stuff!  That mess stays with the bot files.
// * Hip's rotation stuff!  I don't want to touch that right now!
//- - - - - - - - - - - - - - - - - - -

// ai.qc - - - - - -
void() SwapTarget;
void() FoundTarget;
float (entity targ) visible;
float (entity targ, entity src) visible2;   // FIXME:  Remove.
float (entity targ) infront;
float (entity targ) range;
float(entity targ) FindNewMaster;
float() MatchingIdeal;      // New in Drake.
float() FacingIdeal;
void() ai_face;
void(float dist) ai_run;
void(float dist) ai_back;

// align.qc - - - -
float(entity targ, entity attacker) Ally_Check;     // Here for FrikBot.

// ammo.qc - - - - -
float(float am) ShellGame;
void(entity ent, float am) Update_Cells;
void(entity e) bind_ammo;
string(float gun) weapon_name;
void() weapon_leave;    // Used by weapons and few custom artifacts.
void() DropBackpack;
void(entity from, entity to) Pack_Copy;

// armor.qc - - - -
float(entity ent) Armor_Exotic;

// baha.qc - - - - -
void() baha_run;        // These four are called in player.qc.
void() baha_fire1;
void() baha_pain;
void() baha_die;

// check.qc - - - -
float(entity e) IsDead;
float(entity e) IsMissile;

// chest.qc - - - -
void() CheckOnTop;
void() chest_push;

// client.qc - - - -
float(entity who) Use_ChaosDevice;

// combat.qc - - - -
// Damage function prototypes.
void(entity targ, entity inflictor, entity attacker, float damage,
    float dflags, string dtype) T_NewDamage;
void(entity inflictor, entity attacker, float damage, entity ignore,
    float dflags, string dtype) T_NewRadiusDamage;
void(entity inflictor, entity attacker, float damage, entity ignore,
    float dflags, string dtype, float radius, float attn) T_RadiusDamage_II;

// cool.qc - - - - -
void(float damage, vector spot, float secs) Quake_Level;
void(entity attacker, float radius, float damage, vector spot, float dflags,
    float secs, vector tilt)  Quake_Spawn;
void(entity ent) Divine_Check;

// cutscene.qc - - -
void() Cutscene_Think;

// dmsp.qc - - - - -
void() DMSP_checkSpawnSize;
void() DMSP_countdown;
void() DMSP_monsterspawner;
void() DMSP_precaches;

// fire.qc - - - - -
void() BecomeBigBang;
void(float ents) Ember_Shower;
void(entity ent) Burn_Null;
void(entity ent) Burn_Check;
void(entity victim, entity attacker, float burn) Burn_Add;

// func.qc - - - - -
void() train_next;
void() func_train_find;

// fx.qc - - - - - -
void() BecomeExplosion;     // Formerly in weapons.qc
void(entity ent, float color1, float color2) Particle_Cube;

// gibs.qc - - - - -
void() Gib_Touch;
void(string gibname, float dm) ThrowGib;
void(string gibname, float dm) ThrowHead;

// hook.qc - - - - -
entity(entity attacker) Grapple_Pull_Who;

// hp.qc - - - - - -
// FIXME:  Remove?
void(entity ent) Regen_ClientReset;

// impulse.qc - - -
float(float fl) Gamemode_Set;
void() W_UseArmor;      // For special armors such as Dragonscale.
void() W_WeaponFrame;

// items.qc - - - -
void() monster_item_drop;

// light.qc - - - -
void(entity targ, entity inflictor, entity attacker, vector org,
    float damage, string dtype) BoltDamage;

// math.qc - - - - -
vector(vector dir, vector norm, float ob, float stop) Vec_Reflect;

// misc.qc - - - - -
void() barrel_die;

void() make_bubbles;
void() bubble_remove;
void() bubble_bob;

void() misc_glitter;
void() Glitter_Spawner;

// monsters.qc - - -
void() monster_death_use;
void() monster_touch;
//float(entity ent) M_RespawnCheck;
//void() monster_respawn;
void() monster_1up;
void() monster_purse_reset;
void() monster_start_go;

// player.qc - - - -
void() player_run;
void() SuperDamageSound;    // Was in 'weapons.qc'.

// pow.qc - - - - -
void(entity ent) WaterRise;
void(entity ent) WaterSwim;         // Used by WorldScan.
void(entity ent) CheckArtifacts;    // ditto.

// reflect.qc - - -
float() Reflected;
float(float damage) Reflected_Damage;
//float(entity ent) HasReflection;
void(entity ent) ReflectSound;

// revive.qc - - - -
float(entity ent, entity god) monster_revive;
float(float hp) mass_revive;

// ryu.qc - - - - -
// Aside from dragons, used by players in dragon form and hell hounds.
vector() Ryu_Offset;
void(vector start, vector dir, float sped, float up, float damage) Ryu_Fire;

// subs.qc - - - - -
void() SUB_UseTargets;

// summon.qc - - - -
// FIXME:  ???
entity(string text) summon_data;
float(entity parent, entity mold, vector spot, float los, float() google)
    summon_func;
float(vector spot, float los, float() google) replicate;
//void(float who) cache_monster;
//float(entity parent, vector spot, float mtype) SpawnMonster;
float(entity parent, vector spot, float mtype, float() google) SpawnMonster;
float(entity parent, float mtype) SpawnMonster_Attack;
float(entity parent, float mtype) SpawnMonster_Circle;
float(entity parent, vector spot, float mtype) SpawnMonster_Point;
void(float mtype, float loop) SpawnMonster_Horde;
void(entity client) Pets_Free;
void() Impulse_Monster;     // Debug tool
void() Cheat_Monster;       // Debug tool

// swap.qc - - - - -
void(vector p1, vector p2, vector ang, float cork) Rail_Trail;

// triggers.qc - - -
void(vector org) spawn_tfog;
void() void_touch;
void() trigger_void_spawn;

// war.qc - - - - -
float(entity ent) Transform_Ok;
void(entity ent) War_Transform;     // Morphing stuff.

// weapons.qc - - -
// rockets
void() T_MissileExplode;
void() T_MissileTouch;
void(vector org, vector dir) Rocket_Launch;
// spikes
void(vector org, vector dir) launch_spike;
void(vector org, vector dir) launch_superspike;

// world.qc - - - -
void(string text, float dur) PlayMusic;
void() IntermissionMusic;
void() NextLevel;   // Used by combat.qc for dmsp check.


//==========================================================================
//  Monsters

// Used in spawn.qc.
void() monster_ogre;
void() monster_demon1;
void() monster_shambler;
void() monster_dog;
void() monster_zombie;
void() monster_shalrath;        // For SoE fix hack.
void() monster_super_wrath;     // For SoE fix hack.

void() dragon_cache;    // For item_artifact_dragon.

void() wrath_cache;
void() imp_cache;
void() kolem_cache;


//===========================/  END OF FILE  /===========================//

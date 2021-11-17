//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
//
// Attributions: Mission Pack 1 (Hipnotic)
//
//
// Distribution / Copyright / Permissions 
//
// Please do not use any of these assets in ANY COMMERCIAL PROJECT.
// and remember to give credit if you use any of these assets. Please credit
// the appropriate authors of the various content used.  Refer to the credits
// folder.
//				  
// The QC files in this MOD are based on 1.06 source files by ID Software.
// These files are released under the terms of GNU General Public License v2 or
// later. You may use the source files as a base to build your own MODs as long
// as you release them under the same license and make the source available.
// Please also give proper credit. Check http://www.gnu.org for details.
//
// Quake is a registered trademark of id Software, Inc.
//
// All of these resources may be electronically distributed only at 
// NO CHARGE to the recipient.
//
// Stats:
// Entity count: 2
// Function count: 2
//
// Implements: Damage Threshold and Breakaway (Dissappearing) Wall 
//
// Description:
// Damage threshold will only trigger if the damage it receives is great
// enough.  Resets health if it's not enough.
//
// Early implementation of breakables that is very limited.  Use AD's system
// instead with func_breakable.  This will simply dissappear when targeted.
// Could be used in conjunction with the particle field to have dust effect
// when dissappearing, though this wasn't ever used in Hipnotic originally.
//=============================================================================

float MULTI_USE    = 1.000;
float INVISIBLE    = 2.000;

void () damagethreshold_killed = { // [FUNCTION]
   self.health = self.max_health;
   activator = damage_attacker;
   self.takedamage = DAMAGE_NO;
   SUB_UseTargets ();
   self.takedamage = DAMAGE_YES;
   if ( !(self.spawnflags & MULTI_USE) ) remove (self);
};

void (entity inflictor, entity attacker, float damage) damagethreshold_pain = { // [FUNCTION]
   self.health = self.max_health;
};

void () trigger_damagethreshold = { // [ENTITY]
   self.mangle = self.angles;
   self.angles = VEC_ORIGIN;
   self.classname = "damagethreshold";
   self.solid = SOLID_BSP;
   self.movetype = MOVETYPE_PUSH;
   setorigin (self,self.origin);
   setmodel (self,self.model);
   setsize (self,self.mins,self.maxs);
   if ( (self.spawnflags & INVISIBLE) ) self.model = string_null;
   if ( !self.health ) self.health = 60.000;
   self.max_health = self.health;
   self.takedamage = DAMAGE_YES;
   self.blocked = SUB_Null;
   self.th_pain = damagethreshold_pain;
   self.th_die = damagethreshold_killed;
};

void () func_breakawaywall = { // [ENTITY]
   self.mangle = self.angles;
   self.angles = VEC_ORIGIN;
   self.classname = "breakaway";
   self.solid = SOLID_BSP;
   self.movetype = MOVETYPE_PUSH;
   setorigin (self,self.origin);
   setmodel (self,self.model);
   setsize (self,self.mins,self.maxs);
   self.use = SUB_Remove;
};
//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
//
// Attributions: Mission Pack 2 (Rogue)
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
// Entity count: 1
// Function count: 7
//
// Implements: Vengeance Sphere
//
// Description:
// Special power up that in Rogue was deathmatch only.  In Keep you have to be
// explicit and turn on the spawnflags to not have in any difficulty.
//
// Spawns a floating orb that orbits your head and will hurt enemies that touch
// you exploding on them.
//=============================================================================

void() sphere_impact = { // [FUNCTION]
   if (other.health) T_Damage(other,self,self,1000.000,DAMARMOR);
   T_RadiusDamage(self,self,300.000,other,DAMAGEALL);
   self.origin = (self.origin - (FL_CLIENT * normalize (self.velocity)));
   WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
   WriteByte (MSG_BROADCAST,TE_EXPLOSION);
   WriteCoord (MSG_BROADCAST,self.origin_x);
   WriteCoord (MSG_BROADCAST,self.origin_y);
   WriteCoord (MSG_BROADCAST,self.origin_z);
   BecomeExplosion();
};

void(entity ownerEntity) sphere_remove = { // [FUNCTION]
   local entity theSphere;

   theSphere = find (world,classname,"Vengeance");
   while ( (theSphere != world) ) {
      if ( (theSphere.owner == self) ) {
         bprint (theSphere.owner.netname);
         bprint (" is denied Vengeance.\n");
         remove (theSphere);
         theSphere = find (world,classname,"Vengeance");
      } else {
         theSphere = find (theSphere,classname,"Vengeance");
      }
   }
};

void() sphere_attack = { // [FUNCTION]
   self.solid = SOLID_TRIGGER;
   self.touch = sphere_impact;
   if ( (self.enemy.health < TRUE) ) {
      sprint(self.owner,"You are denied Vengeance");
      remove(self);
      return;
   }

   ai_track (self.enemy,650.000);
   self.nextthink = (time + 0.100);
   self.think = sphere_attack;
};

void() sphere_think = { // [FUNCTION]
   if ((self.shieldSoundTime < time)) {
      sound (self,CHAN_VOICE,"rogue/sphere/sphere.wav",TRUE,ATTN_NORM);
      self.shieldSoundTime = (time + MOVETYPE_STEP);
   }

   if (time > self.delay) {
      if (self.owner.items2 & IT2_V_SPHERE) self.owner.items2 = (self.owner.items2 - IT2_V_SPHERE);
      sprint (self.owner,"Vengeance Sphere Lost\n");
      remove (self);
      return;
   }

   if (self.owner.health < TRUE) {
      if (self.owner.items2 & IT2_V_SPHERE) self.owner.items2 = (self.owner.items2 - IT2_V_SPHERE);
      if (self.owner.enemy.flags & FL_CLIENT) {
         self.enemy = self.owner.enemy;
         sphere_attack();
         return;
      }

      if (self.owner.enemy.owner.flags & FL_CLIENT) {
         self.enemy = self.owner.enemy.owner;
         sphere_attack();
         return;
      }

      remove(self);
      return;
   }

   ai_orbit(self.owner,16,'0.000 0.000 48.000');
   self.think = sphere_think;
   self.nextthink = (time + 0.100);
};

void() sphere_spawn = { // [FUNCTION]
   local entity missile;

   missile = spawn();
   missile.movetype = MOVETYPE_FLYMISSILE;
   missile.solid = SOLID_NOT;
   missile.classname = "Vengeance";
   missile.owner = other;
   missile.weapon = FALSE;
   missile.delay = (time + SVC_INTERMISSION);
   setmodel (missile,"progs/rogue/sphere.mdl");
   setsize (missile,VEC_ORIGIN,VEC_ORIGIN);
   setorigin (missile,self.origin);
   missile.avelocity = '40.000 40.000 40.000';
   missile.think = sphere_think;
   missile.nextthink = (time + 0.100);
};

void() item_sphere = { // [ENTITY]
	item_setupmodel("progs/rogue/sphere.mdl",0);
	item_setupnoise("rogue/sphere/sphere.wav");
	self.noise1 = self.noise2 = "rogue/sphere/sphere.wav";
	precache_sound (self.noise1);
	precache_sound (self.noise2);
	self.items2 = IT2_V_SPHERE;
	self.avelocity = '40.000 40.000 40.000';
	if (self.netname == "") self.netname = "Vengeance Sphere";
	self.classtype = CT_ARTSPHERE;
	self.part_active = PARTICLE_STYLE_SRING;
	self.respawn_style = PARTICLE_BURST_YELLOW + PARTICLE_BURST_CENTER;
	self.respawn_ofs = '0 0 6';
	artifact_setup();
};
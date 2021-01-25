float MA_SUCCESSFUL   =  0.00000;
float MA_BLOCKED   =  -1.00000;
float MA_CROSSED   =  -2.00000;
float MA_NOWEAPON   =  -3.00000;
float MA_TOOSOON   =  -4.00000;
float MA_TOOFAR   =  -5.00000;
float MA_NOATTACK   =  -6.00000;
float MA_MELEE   =  1.00000;
float MA_MISSILE   =  2.00000;
float MA_BOTH   =  3.00000;
float MA_FAR_MELEE   =  4.00000;
float MA_SHORT_MISSILE   =  8.00000;

float  (float AttackType,float ChanceModifier)Hexen2CheckMonsterAttack =  {
local vector spot1 = '0.00000 0.00000 0.00000';
local vector spot2 = '0.00000 0.00000 0.00000';
local entity targ;
local float chance = 0.00000;
   targ = self.enemy;
   if ( (self.classname == "monster_hydra") ) {

      if ( (self.enemy.watertype != CONTENT_WATER) ) {

         if ( (self.search_time < time) ) {

            self.monster_stage = 0.00000;
            self.enemy = world;
            return ( 0.00000 );

         }
         return ( 0.00000 );
      } else {

         self.search_time = (time + 5.00000);

      }

   }
   spot1 = (self.origin + self.view_ofs);
   spot2 = (targ.origin + targ.view_ofs);
   traceline ( spot1, spot2, FALSE, self);
   // if ( (trace_ent.thingtype >= THINGTYPE_WEBS) ) {
      // traceline ( trace_endpos, spot2, FALSE, trace_ent);
   // }
   if ( (trace_ent != targ) ) {
      if ( (((trace_ent.health > 25.00000) || !trace_ent.takedamage) || ((trace_ent.flags & FL_MONSTER) && (trace_ent.classname != "player_sheep"))) ) {
         return ( MA_BLOCKED );
      }
   }
   if ( (trace_inopen && trace_inwater) ) return ( MA_CROSSED );

   if ( (enemy_range == RANGE_MELEE) ) {
      if ( (AttackType & MA_SHORT_MISSILE) ) {
         if ( (random() < 0.50000) ) {
            self.th_missile ( );
            return ( MA_SUCCESSFUL );
         }
      }
      if ( self.th_melee ) {
         if ( (AttackType & MA_MELEE) ) {
            self.th_melee ( );
            return ( MA_SUCCESSFUL );
         } else {
            return ( MA_NOWEAPON );
         }
      }
   }
   if ( (!self.th_missile || !(AttackType & (MA_MISSILE | MA_FAR_MELEE))) ) return ( MA_NOWEAPON );
   if ( (time < self.attack_finished) ) return ( MA_TOOSOON );
   if ( (enemy_range == RANGE_FAR) ) return ( MA_TOOFAR );
   if ( (enemy_range == RANGE_MELEE) ) {
      chance = 0.90000;
      self.attack_finished = 0.00000;
   } else {
      if ( (enemy_range == RANGE_NEAR) ) {
         if ( self.th_melee ) {
            chance = 0.20000;
         } else {
            chance = 0.40000;
         }
      } else {
         if ( (enemy_range == RANGE_MID) ) {
            if ( self.th_melee ) {
               chance = 0.05000;
            } else {
               chance = 0.10000;
            }
         } else {
            chance = 0.00000;
         }
      }
   }
   chance = (chance * ChanceModifier);
   if ( (chance > 0.95000) ) {
      chance = 0.95000;
   }
   if ( (random() < chance) ) {
      if ( self.th_melee ) {
         if ( (AttackType & MA_FAR_MELEE) ) {
            self.th_melee ( );
         } else {
            self.th_missile ( );

         }
      } else {

         self.th_missile ( );

      }
      SUB_AttackFinished ( random(8.00000,0.00000));
      return ( MA_SUCCESSFUL );

   }
   return ( MA_NOATTACK );
};

float  (float maxdist)check_z_move =  {
local float goaldist = 0.00000;
local entity targ;
   if ( ((self.enemy != world) && visible ( self.enemy)) ) {
      targ = self.enemy;
   } else {
      if ( (self.goalentity != world) ) {
         targ = self.goalentity;
      } else {
         return ( FALSE );
      }
   }
   if ( (targ.origin_z != self.absmin_z) ) {
      goaldist = (((targ.absmin_z + targ.absmax_z) * 0.50000) - ((self.absmax_z + self.absmin_z) * 0.50000));
      maxdist = fabs ( maxdist);
      if ( (fabs ( goaldist) > maxdist) ) {
         if ( (goaldist > 0.00000) ) {
            goaldist = maxdist;
         } else {
            goaldist = (maxdist * -1.00000);
         }
      }
      if (!walkmove(self.angles_y, goaldist)) return (FALSE);
   }
   return (TRUE);
};
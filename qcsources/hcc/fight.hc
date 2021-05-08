void (entity a,entity b,entity c,float d)T_Damage;
float (entity a,entity b)CanDamage;
float  (float v)anglemod;
void  (vector dest3)ChooseTurn;
void  ()ai_face;
float  (float AttackType,float ChanceModifier)CheckMonsterAttack;
float enemy_vis   =  0.00000;
float enemy_infront   =  0.00000;
float enemy_range   =  0.00000;
float enemy_yaw   =  0.00000;
float MAX_MELEE   =  1.00000;
float MAX_MISSILE   =  2.00000;
float MAX_BOTH   =  3.00000;
float MAX_FAR_MELEE   =  4.00000;
float MAX_SHORT_MISSILE   =  8.00000;

float  ()CheckAttack =  {
local vector spot1 = '0.00000 0.00000 0.00000';
local vector spot2 = '0.00000 0.00000 0.00000';
local entity targ;
local float chance = 0.00000;
   targ = self.enemy;
   spot1 = (self.origin + self.view_ofs);
   spot2 = ((targ.absmin + targ.absmax) * 0.50000);
   traceline ( spot1, spot2, FALSE, self);
   if ( (trace_ent.thingtype >= THINGTYPE_WEBS) ) {

      traceline ( trace_endpos, spot2, FALSE, trace_ent);

   }
   if ( (trace_ent != targ) ) {

      if ( (((trace_ent.health > 25.00000) || !trace_ent.takedamage) || ((trace_ent.flags & FL_MONSTER) && (trace_ent.classname != "player_sheep"))) ) {

         return ( FALSE );

      }

   }
   if ( (trace_inopen && trace_inwater) ) {

      return ( FALSE );

   }
   if ( (enemy_range == RANGE_MELEE) ) {

      if ( self.th_melee ) {

         self.th_melee ( );
         return ( TRUE );

      }

   }
   if ( !self.th_missile ) {

      return ( FALSE );

   }
   if ( (time < self.attack_finished) ) {

      return ( FALSE );

   }
   if ( (enemy_range == RANGE_FAR) ) {

      return ( FALSE );

   }
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
   if ( (random() < chance) ) {

      self.th_missile ( );
      SUB_AttackFinished ( random(0.00000,2.00000));
      return ( TRUE );

   }
   return ( FALSE );
};


void  ()ai_face =  {
   self.ideal_yaw = vectoyaw ( (self.goalentity.origin - self.origin));
   ChangeYaw ( );
};

float  (entity targ)visible;
float  (entity targ)infront;
float  (entity targ)range;

void  (float d)ai_charge =  {
   ai_face ( );
   movetogoal ( d);
};


void  ()ai_charge_side =  {
local vector dtemp = '0.00000 0.00000 0.00000';
local float heading = 0.00000;
   self.ideal_yaw = vectoyaw ( (self.goalentity.origin - self.origin));
   ChangeYaw ( );
   makevectors ( self.angles);
   dtemp = (self.enemy.origin - (30.00000 * v_right));
   heading = vectoyaw ( (dtemp - self.origin));
   walkmove ( heading, 20.00000, FALSE);
};


void  ()ai_melee =  {
local vector org1 = '0.00000 0.00000 0.00000';
local vector org2 = '0.00000 0.00000 0.00000';
local float ldmg = 0.00000;
   if ( !self.enemy ) {

      return ;

   }
   org1 = (self.origin + self.proj_ofs);
   org2 = self.enemy.origin;
   if ( (vlen ( (org2 - org1)) > 60.00000) ) {

      return ;

   }
   traceline ( org1, org2, FALSE, self);
   if ( (trace_ent != self.enemy) ) {

      org2 = ((self.enemy.absmin + self.enemy.absmax) * 0.50000);
      traceline ( org1, org2, FALSE, self);

   }
   if ( !trace_ent.takedamage ) {

      return ;

   }
   ldmg = random(9.00000);
   T_Damage ( trace_ent, self, self, ldmg);
};


void  ()ai_melee_side =  {
local vector delta = '0.00000 0.00000 0.00000';
local float ldmg = 0.00000;
   if ( !self.enemy ) {

      return ;

   }
   ai_charge_side ( );
   delta = (self.enemy.origin - self.origin);
   if ( (vlen ( delta) > 60.00000) ) {

      return ;

   }
   if ( !CanDamage ( self.enemy, self) ) {

      return ;

   }
   ldmg = random(9.00000);
   T_Damage ( self.enemy, self, self, ldmg);
};


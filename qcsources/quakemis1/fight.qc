float (float v) anglemod;

void () knight_atk1;

void () knight_runatk1;

void () ogre_smash1;

void () ogre_swing1;

void () sham_smash1;

void () sham_swingr1;

void () sham_swingl1;
float () DemonCheckAttack;

void (float side) Demon_Melee;

void (vector dest3) ChooseTurn;

void () ai_face;
float enemy_vis /* = 0.000 */;
float enemy_infront /* = 0.000 */;
float enemy_range /* = 0.000 */;
float enemy_yaw /* = 0.000 */;

void () knight_attack = {

   local float len;

   len = vlen (((self.enemy.origin + self.enemy.view_ofs) - (self.origin + self.view_ofs)));
   if ( (len < 80.000) ) {

      knight_atk1 ();

   } else {

      knight_runatk1 ();

   }

};
float () CheckAttack = {

   local vector spot1;
   local vector spot2;
   local entity targ;
   local float chance;

   targ = self.enemy;
   spot1 = (self.origin + self.view_ofs);
   spot2 = (targ.origin + targ.view_ofs);
   traceline (spot1,spot2,FALSE,self);
   if ( ((trace_ent != targ) && !self.charmed) ) {

      return ( FALSE );

   }
   if ( (trace_inopen && trace_inwater) ) {

      return ( FALSE );

   }
   if ( (enemy_range == RANGE_MELEE) ) {

      if ( self.th_melee ) {

         if ( (self.classname == "monster_knight") ) {

            knight_attack ();

         } else {

            self.th_melee ();

         }
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

      chance = 0.900;
      self.attack_finished = FALSE;

   } else {

      if ( (enemy_range == RANGE_NEAR) ) {

         if ( self.th_melee ) {

            chance = 0.200;

         } else {

            chance = 0.400;

         }

      } else {

         if ( (enemy_range == RANGE_MID) ) {

            if ( self.th_melee ) {

               chance = 0.050;

            } else {

               chance = 0.100;

            }

         } else {

            chance = FALSE;

         }

      }

   }
   if ( (random () < chance) ) {

      self.th_missile ();
      SUB_AttackFinished ((FL_SWIM * random ()));
      return ( TRUE );

   }
   return ( FALSE );

};

void () ai_face = {

   self.ideal_yaw = vectoyaw ((self.enemy.origin - self.origin));
   ChangeYaw ();

};
float (entity targ) infront;
float (entity targ) range;

void (float d) ai_charge = {

   ai_face ();
   movetogoal (d);

};

void () ai_charge_side = {

   local vector dtemp;
   local float heading;

   self.ideal_yaw = vectoyaw ((self.enemy.origin - self.origin));
   ChangeYaw ();
   makevectors (self.angles);
   dtemp = (self.enemy.origin - (SVC_INTERMISSION * v_right));
   heading = vectoyaw ((dtemp - self.origin));
   walkmove (heading,20.000);

};

void () ai_melee = {

   local vector delta;
   local float ldmg;

   if ( !self.enemy ) {

      return ;

   }
   delta = (self.enemy.origin - self.origin);
   if ( (vlen (delta) > 60.000) ) {

      return ;

   }
   ldmg = (((random () + random ()) + random ()) * MOVETYPE_WALK);
   T_Damage (self.enemy,self,self,ldmg);

};

void () ai_melee_side = {

   local vector delta;
   local float ldmg;

   if ( !self.enemy ) {

      return ;

   }
   ai_charge_side ();
   delta = (self.enemy.origin - self.origin);
   if ( (vlen (delta) > 60.000) ) {

      return ;

   }
   if ( !CanDamage (self.enemy,self) ) {

      return ;

   }
   ldmg = (((random () + random ()) + random ()) * MOVETYPE_WALK);
   T_Damage (self.enemy,self,self,ldmg);

};
float () SoldierCheckAttack = {

   local vector spot1;
   local vector spot2;
   local entity targ;
   local float chance;

   targ = self.enemy;
   spot1 = (self.origin + self.view_ofs);
   spot2 = (targ.origin + targ.view_ofs);
   traceline (spot1,spot2,FALSE,self);
   if ( (trace_inopen && trace_inwater) ) {

      return ( FALSE );

   }
   if ( (trace_ent != targ) ) {

      return ( FALSE );

   }
   if ( (time < self.attack_finished) ) {

      return ( FALSE );

   }
   if ( (enemy_range == RANGE_FAR) ) {

      return ( FALSE );

   }
   if ( (enemy_range == RANGE_MELEE) ) {

      chance = 0.900;

   } else {

      if ( (enemy_range == RANGE_NEAR) ) {

         chance = 0.400;

      } else {

         if ( (enemy_range == RANGE_MID) ) {

            chance = 0.050;

         } else {

            chance = FALSE;

         }

      }

   }
   if ( (random () < chance) ) {

      self.th_missile ();
      SUB_AttackFinished ((TRUE + random ()));
      if ( (random () < 0.300) ) {

         self.lefty = !self.lefty;

      }
      return ( TRUE );

   }
   return ( FALSE );

};
float () ShamCheckAttack = {

   local vector spot1;
   local vector spot2;
   local entity targ;
   local float chance;

   if ( (enemy_range == RANGE_MELEE) ) {

      if ( CanDamage (self.enemy,self) ) {

         self.attack_state = AS_MELEE;
         return ( TRUE );

      }

   }
   if ( (time < self.attack_finished) ) {

      return ( FALSE );

   }
   if ( !enemy_vis ) {

      return ( FALSE );

   }
   targ = self.enemy;
   spot1 = (self.origin + self.view_ofs);
   spot2 = (targ.origin + targ.view_ofs);
   if ( (vlen ((spot1 - spot2)) > 600.000) ) {

      return ( FALSE );

   }
   traceline (spot1,spot2,FALSE,self);
   if ( (trace_inopen && trace_inwater) ) {

      return ( FALSE );

   }
   if ( (trace_ent != targ) ) {

      return ( FALSE );

   }
   if ( (enemy_range == RANGE_FAR) ) {

      return ( FALSE );

   }
   self.attack_state = AS_MISSILE;
   SUB_AttackFinished ((FL_SWIM + (FL_SWIM * random ())));
   return ( TRUE );

};
float () OgreCheckAttack = {

   local vector spot1;
   local vector spot2;
   local entity targ;
   local float chance;

   if ( (enemy_range == RANGE_MELEE) ) {

      if ( CanDamage (self.enemy,self) ) {

         self.attack_state = AS_MELEE;
         return ( TRUE );

      }

   }
   if ( (time < self.attack_finished) ) {

      return ( FALSE );

   }
   if ( !enemy_vis ) {

      return ( FALSE );

   }
   targ = self.enemy;
   spot1 = (self.origin + self.view_ofs);
   spot2 = (targ.origin + targ.view_ofs);
   traceline (spot1,spot2,FALSE,self);
   if ( (trace_inopen && trace_inwater) ) {

      return ( FALSE );

   }
   if ( (trace_ent != targ) ) {

      return ( FALSE );

   }
   if ( (time < self.attack_finished) ) {

      return ( FALSE );

   }
   if ( (enemy_range == RANGE_FAR) ) {

      return ( FALSE );

   } else {

      if ( (enemy_range == RANGE_NEAR) ) {

         chance = 0.100;

      } else {

         if ( (enemy_range == RANGE_MID) ) {

            chance = 0.050;

         } else {

            chance = FALSE;

         }

      }

   }
   self.attack_state = AS_MISSILE;
   SUB_AttackFinished ((TRUE + (FL_SWIM * random ())));
   return ( TRUE );

};

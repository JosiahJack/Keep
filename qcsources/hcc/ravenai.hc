
float  ()LocateTarget =  {
   return ( FindTarget ( TRUE) );
};

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

float  (float AttackType,float ChanceModifier)CheckMonsterAttack =  {
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
   if ( (trace_ent.thingtype >= THINGTYPE_WEBS) ) {

      traceline ( trace_endpos, spot2, FALSE, trace_ent);

   }
   if ( (trace_ent != targ) ) {

      if ( (((trace_ent.health > 25.00000) || !trace_ent.takedamage) || ((trace_ent.flags & FL_MONSTER) && (trace_ent.classname != "player_sheep"))) ) {

         return ( MA_BLOCKED );

      }

   }
   if ( (trace_inopen && trace_inwater) ) {

      return ( MA_CROSSED );

   }
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
   if ( (!self.th_missile || !(AttackType & (MA_MISSILE | MA_FAR_MELEE))) ) {

      return ( MA_NOWEAPON );

   }
   if ( (time < self.attack_finished) ) {

      return ( MA_TOOSOON );

   }
   if ( (enemy_range == RANGE_FAR) ) {

      return ( MA_TOOFAR );

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


float  (vector offset,vector to_where)monster_checkpos =  {
local vector start = '0.00000 0.00000 0.00000';
local float length = 0.00000;
   start = (self.origin + offset);
   traceline ( self.origin, start, FALSE, self);
   if ( (trace_fraction < 0.50000) ) {

      return ( FALSE );

   }
   length = (vlen ( (self.origin - start)) * trace_fraction);
   start = trace_endpos;
   traceline ( start, to_where, FALSE, self);
   if ( ((trace_ent == self.enemy) || (trace_fraction > 0.98000)) ) {

      length = (length + (vlen ( (start - self.enemy.origin)) * trace_fraction));
      return ( length );

   }
   return ( FALSE );
};


void  (float l,float r,float u,float d,float last_move,vector where)find_path =  {
local float length = 0.00000;
local float newyaw = 0.00000;
local float newz = 0.00000;
local float c = 0.00000;
local float retval = 0.00000;
   makevectors ( self.angles);
   length = 99999.00000;
   newyaw = self.ideal_yaw;
   newz = self.velocity_z;
   c = 0.00000;
   while ( (c <= 4.00000) ) {

      if ( ((c == 0.00000) && last_move) ) {

         retval = monster_checkpos ( (v_forward * 300.00000), where);
         if ( (retval && (retval < length)) ) {

            self.monster_duration = (18.00000 + 5.00000);
            length = retval;

         }

      }
      if ( (c == l) ) {

         retval = monster_checkpos ( (v_right * -200.00000), where);
         if ( (retval && (retval < length)) ) {

            newyaw = (self.angles_y + 90.00000);
            self.monster_duration = (18.00000 + 5.00000);
            length = retval;

         }
      } else {

         if ( (c == r) ) {

            retval = monster_checkpos ( (v_right * 200.00000), where);
            if ( (retval && (retval < length)) ) {

               newyaw = (self.angles_y - 90.00000);
               self.monster_duration = (18.00000 + 5.00000);
               length = retval;

            }
         } else {

            if ( (c == u) ) {

               retval = monster_checkpos ( (v_up * 200.00000), where);
               if ( (retval && (retval < length)) ) {

                  newz = 30.00000;
                  self.monster_duration = (18.00000 + 5.00000);
                  length = retval;

               }
            } else {

               if ( (c == d) ) {

                  retval = monster_checkpos ( (v_up * -200.00000), where);
                  if ( (retval && (retval < length)) ) {

                     newz = -30.00000;
                     self.monster_duration = (18.00000 + 5.00000);
                     length = retval;

                  }

               }

            }

         }

      }
      c = (c + 1.00000);

   }
   if ( ((length == 99999.00000) && (self.monster_last_seen != where)) ) {

      find_path ( l, r, u, d, 0.00000, self.monster_last_seen);
   } else {

      self.ideal_yaw = newyaw;
      self.velocity_z = newz;

   }
};


void  ()FindDir =  {
local vector a = '0.00000 0.00000 0.00000';
local vector b = '0.00000 0.00000 0.00000';
local vector c = '0.00000 0.00000 0.00000';
local float inc = 0.00000;
local float step = 0.00000;
   if ( (random() < 0.50000) ) {

      inc = 45.00000;
   } else {

      inc = -45.00000;

   }
   c = '0.00000 0.00000 0.00000';
   c_y = (c_y + inc);
   step = 0.00000;
   while ( (step < 6.00000) ) {

      makevectors ( (self.angles + c));
      a = (self.origin + self.view_ofs);
      b = (a + (v_forward * 100.00000));
      traceline ( a, b, FALSE, self);
      if ( (trace_fraction > 0.90000) ) {

         return ( (self.angles_y + c_y) );

      }
      c_y = (c_y + inc);
      step = (step + 1.00000);

   }
   return ( self.angles_y );
};


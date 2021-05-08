void  (float num_bubbles)DeathBubbles;

float  ()Skip =  {
local vector dir1 = '0.00000 0.00000 0.00000';
local vector dir2 = '0.00000 0.00000 0.00000';
local float dot = 0.00000;
   dir1 = normalize ( self.velocity);
   traceline ( (self.origin - (dir1 * 4.00000)), (self.origin + (dir1 * 16.00000)), TRUE, self);
   dir2 = trace_plane_normal;
   dir1_x *= -1.00000;
   dot = (dir1 * dir2);
   if ( ((dot <= 0.15000) && (trace_fraction < 1.00000)) ) {

      return ( TRUE );
   } else {

      return ( FALSE );

   }
};


void  (float amount)Veer =  {
local vector veerdir = '0.00000 0.00000 0.00000';
   veerdir_z = amount;
   veerdir_y = amount;
   veerdir_x = amount;
   self.velocity += RandomVector ( veerdir);
   self.angles = vectoangles ( self.velocity);
};


void  ()VeerThink =  {
   Veer ( self.veer);
   if ( (self.think == Veer) ) {

      AdvanceThinkTime(self,0.10000);

   }
};


float  (entity loser,entity from)ahead =  {
local vector proj_dir = '0.00000 0.00000 0.00000';
local vector spot1 = '0.00000 0.00000 0.00000';
local vector spot2 = '0.00000 0.00000 0.00000';
local vector vec = '0.00000 0.00000 0.00000';
local float accept = 0.00000;
local float dot = 0.00000;
   proj_dir = normalize ( from.velocity);
   spot1 = from.origin;
   spot2 = ((loser.absmin + loser.absmax) * 0.50000);
   if ( ((from.classname == "flaming arrow") || (from.classname == "bolt")) ) {

      accept = 0.87500;
   } else {

      accept = 0.20000;

   }
   vec = normalize ( (spot2 - spot1));
   dot = (vec * proj_dir);
   if ( (dot > accept) ) {

      return ( TRUE );

   }
   return ( FALSE );
};


float  (entity loser,entity from,float accept)heading =  {
local vector proj_dir = '0.00000 0.00000 0.00000';
local vector spot1 = '0.00000 0.00000 0.00000';
local vector spot2 = '0.00000 0.00000 0.00000';
local vector vec = '0.00000 0.00000 0.00000';
local float dot = 0.00000;
   proj_dir = normalize ( from.velocity);
   spot1 = from.origin;
   spot2 = ((loser.absmin + loser.absmax) * 0.50000);
   if ( !accept ) {

      accept = 0.80000;

   }
   vec = normalize ( (spot2 - spot1));
   dot = (vec * proj_dir);
   if ( (dot > accept) ) {

      return ( TRUE );

   }
   return ( FALSE );
};

void  ()HomeThink;

void  ()HomeFindTarget =  {
local entity loser;
local float dist = 0.00000;
local float bestdist = 0.00000;
   if ( (self.think != HomeThink) ) {

      bestdist = 5000.00000;
   } else {

      bestdist = 1000.00000;

   }
   loser = findradius ( self.origin, bestdist);
   bestdist += 1.00000;
   while ( loser ) {

      if ( (((((((loser.health && loser.takedamage) && (loser.flags2 & FL_ALIVE)) && visible ( loser)) && (loser != self)) && (loser != world)) && (loser != self.owner)) && !(other.effects & EF_NODRAW)) ) {

         if ( ((!self.aflag || self.ideal_yaw) && !ahead ( loser, self)) ) {

            dprint ( "");
         } else {

            if ( (teamplay && ((loser.team == self.owner.team) || (loser.team == self.controller.team))) ) {

               dprint ( "");
            } else {

               if ( (coop && (other.classname == "player")) ) {

                  dprint ( "");
               } else {

                  dist = vlen ( (self.origin - loser.origin));
                  if ( (dist < bestdist) ) {

                     bestdist = dist;
                     self.enemy = loser;

                  }
                  if ( (bestdist < 100.00000) ) {

                     self.aflag = TRUE;
                     return ( self.enemy );

                  }

               }

            }

         }

      }
      loser = loser.chain;

   }
   self.aflag = TRUE;
   if ( self.enemy ) {

      return ( self.enemy );
   } else {

      return ( world );

   }
};


void  ()HomeThink =  {
local vector huntdir = '0.00000 0.00000 0.00000';
local float waterornot = 0.00000;
local vector olddir = '0.00000 0.00000 0.00000';
local vector newdir = '0.00000 0.00000 0.00000';
local float oldvelmult = 0.00000;
local float newveldiv = 0.00000;
local float speed_mod = 0.00000;
   if ( (self.thingtype == THINGTYPE_FIRE) ) {

      waterornot = pointcontents ( self.origin);
      if ( ((waterornot == CONTENT_WATER) || (waterornot == CONTENT_SLIME)) ) {

         DeathBubbles ( 1.00000);

      }

   }
   if ( ((self.enemy != world) && !self.lockentity) ) {

      if ( ((!visible ( self.enemy) || !self.enemy.health) || !(self.enemy.flags2 & FL_ALIVE)) ) {

         self.oldenemy = self.enemy;
         self.enemy = world;

      }

   }
   if ( (self.enemy == world) ) {

      if ( ((random() < 0.30000) || (self.think != HomeThink)) ) {

         HomeFindTarget ( );

      }
      if ( (((((self.enemy == world) && (self.oldenemy != world)) && visible ( self.oldenemy)) && self.oldenemy.health) && (self.oldenemy.flags2 & FL_ALIVE)) ) {

         self.enemy = self.oldenemy;

      }

   }
   if ( ((self.enemy != world) && visible ( self.enemy)) ) {

      olddir = normalize ( self.velocity);
      if ( ((self.enemy.classname == "player") && (self.enemy.view_ofs != '0.00000 0.00000 0.00000')) ) {

         huntdir = (self.enemy.origin + self.enemy.view_ofs);
      } else {

         huntdir = ((self.enemy.absmin + self.enemy.absmax) * 0.50000);

      }
      huntdir = normalize ( (huntdir - self.origin));
      oldvelmult = self.turn_time;
      newveldiv = (1.00000 / (self.turn_time + 1.00000));
      newdir = (((olddir * oldvelmult) + huntdir) * newveldiv);
      if ( self.hoverz ) {

         speed_mod = (olddir * newdir);
      } else {

         speed_mod = 1.00000;

      }
      if ( (speed_mod < 0.05000) ) {

         speed_mod = 0.05000;

      }
      if ( (self.velocity != (huntdir * self.speed)) ) {

         self.velocity = (((((olddir * oldvelmult) + huntdir) * newveldiv) * self.speed) * speed_mod);

      }

   }
   if ( self.veer ) {

      Veer ( self.veer);

   }
   self.movedir = normalize ( self.velocity);
   if ( (self.think == HomeThink) ) {

      if ( (self.lifetime < time) ) {

         self.th_die ( );
      } else {

         AdvanceThinkTime(self,self.homerate);

      }

   }
};


void  ()SpiralThink =  {
local vector newangles = '0.00000 0.00000 0.00000';
   makevectors ( self.angles);
   self.velocity = (self.movedir * self.speed);
   newangles = vectoangles ( self.velocity);
   self.angles_y = newangles_y;
   self.angles_x = newangles_x;
   if ( (self.cnt != 0.00000) ) {

      self.anglespeed += self.cnt;

   }
   self.velocity += (v_right * self.anglespeed);
   if ( (self.think == SpiralThink) ) {

      AdvanceThinkTime(self,0.10000);

   }
};


void  ()Missile_Arc =  {
local vector newpitch = '0.00000 0.00000 0.00000';
   self.velocity_z -= 60.00000;
   newpitch = vectoangles ( self.velocity);
   self.angles_x = newpitch_x;
   self.think = Missile_Arc;
   AdvanceThinkTime(self,0.10000);
};


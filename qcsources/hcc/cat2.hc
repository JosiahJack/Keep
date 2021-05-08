
void  ()catapult_ready =  {
local entity found;
local vector dir = '0.00000 0.00000 0.00000';
local vector org = '0.00000 0.00000 0.00000';
   if ( (self.flags & FL_ONGROUND) ) {

      self.movetype = MOVETYPE_NONE;

   }
   if ( ((self.origin != self.oldorigin) || (self.angles != self.o_angle)) ) {

      makevectors ( self.angles);
      dir = normalize ( v_forward);
      org = (self.origin + ((dir * -4.00000) * self.level));
      org_z = self.absmax_z;
      found = nextent ( world);
      while ( found ) {

         if ( ((vhlen ( (found.origin - org)) < (2.00000 * self.level)) && (found.catapulter == self)) ) {

            setorigin ( found, (org + found.pos_ofs));
            found.angles = (self.angles + found.angle_ofs);
            found.velocity = '0.00000 0.00000 0.00000';
            found.flags |= FL_ONGROUND;

         }
         found = nextent ( found);

      }

   }
   self.o_angle = self.angles;
   self.oldorigin = self.origin;
   self.think = catapult_ready;
   AdvanceThinkTime(self,0.00000);
};


void  ()catapult_reset =  {
   if ( (self.frame == 22.00000) ) {

      sound ( self, CHAN_VOICE, "misc/catdrop.wav", 1.00000, ATTN_NORM);
      self.frame = 0.00000;

   }
   if ( (self.frame >= 20.00000) ) {

      sound ( self, CHAN_VOICE, "misc/catreset.wav", 1.00000, ATTN_NORM);
      self.frame = 20.00000;
      self.think = catapult_ready;
      AdvanceThinkTime(self,0.00000);
   } else {

      self.frame += 1.00000;
      self.think = catapult_reset;
      AdvanceThinkTime(self,0.05000);

   }
};


void  ()catapult_wait =  {
   self.think = catapult_reset;
   AdvanceThinkTime(self,self.wait);
};


void  ()catapult_fire =  {
local entity found;
local vector dir = '0.00000 0.00000 0.00000';
local vector org = '0.00000 0.00000 0.00000';
local vector addvel = '0.00000 0.00000 0.00000';
local float distance = 0.00000;
local float force = 0.00000;
local float centrifugal = 0.00000;
   if ( (self.frame == 20.00000) ) {

      sound ( self, CHAN_VOICE, "misc/catlnch.wav", 1.00000, ATTN_NORM);
      found = nextent ( world);
      makevectors ( self.angles);
      dir = normalize ( v_forward);
      org = (self.origin + ((dir * -4.00000) * self.level));
      org_z = self.absmax_z;
      while ( found ) {

         distance = vhlen ( (found.origin - org));
         if ( ((distance < (2.00000 * self.level)) && (found.origin_z > (self.origin_z + (self.maxs_z * 0.75000)))) ) {

            found.catapult_time = (time + 3.00000);
            found.catapulter = world;
            centrifugal = vhlen ( (found.origin - self.origin));
            force = ((self.speed + random(-100.00000,100.00000)) + (centrifugal * 4.00000));
            addvel = ((dir * force) + (v_right * random(-50.00000,50.00000)));
            force = ((self.speed + random(-100.00000,100.00000)) + (centrifugal * 4.00000));
            addvel_z = force;
            found.velocity += addvel;
            if ( !found.touch ) {

               found.touch = obj_push;

            }
            found.flags ^= FL_ONGROUND;
            if ( !(found.flags2 & FL_ALIVE) ) {

               found.avelocity = (found.velocity * random(-1.00000,1.00000));
               found.movetype = MOVETYPE_BOUNCE;

            }
            if ( (found.model == "models/sheep.mdl") ) {

               found.avelocity = (found.velocity * random(-1.00000,1.00000));
               found.movetype = MOVETYPE_BOUNCE;
               sound ( found, CHAN_VOICE, "misc/sheepfly.wav", 1.00000, ATTN_NORM);
               found.pain_finished = (time + 1.00000);

            }

         }
         found = nextent ( found);

      }

   }
   if ( (self.frame >= 22.00000) ) {

      self.frame = 22.00000;
      self.think = catapult_wait;
      AdvanceThinkTime(self,0.00000);
   } else {

      self.frame += 1.00000;
      self.think = catapult_fire;
      AdvanceThinkTime(self,0.05000);

   }
};


void  ()catapult_pain =  {
   if ( !(self.enemy.flags2 & FL_ALIVE) ) {

      return ;

   }
   if ( (self.frame == 20.00000) ) {

      catapult_fire ( );

   }
};


void  ()catapult2_touch =  {
local vector dir = '0.00000 0.00000 0.00000';
local vector org = '0.00000 0.00000 0.00000';
local float distance = 0.00000;
   if ( ((other.solid == SOLID_BSP) || (other == world)) ) {

      return ;

   }
   if ( ((other.origin_z - (other.mins_z * 0.75000)) >= (self.origin_z + (self.maxs_z * 0.75000))) ) {

      if ( ((((other.solid != SOLID_TRIGGER) && other.movetype) && (other.catapulter != self)) && (other.catapult_time < (time + 0.10000))) ) {

         makevectors ( self.angles);
         dir = normalize ( v_forward);
         org = (self.origin + ((dir * -4.00000) * self.level));
         org_z = self.absmax_z;
         distance = vhlen ( (other.origin - org));
         if ( (distance <= (2.00000 * self.level)) ) {

            other.catapult_time = (time + 0.10000);
            other.catapulter = self;
            other.velocity = self.velocity;
            other.pos_ofs = (other.origin - org);
            other.angle_ofs = (self.angles - other.angles);

         }
         other.flags |= FL_ONGROUND;

      }

   }
};


void  ()obj_catapult2 =  {
   precache_model ( "models/cattest.mdl");
   precache_sound ( "misc/catlnch.wav");
   precache_sound ( "misc/catreset.wav");
   precache_sound ( "misc/catdrop.wav");
   self.solid = SOLID_BBOX;
   self.movetype = MOVETYPE_PUSHPULL;
   self.touch = catapult2_touch;
   setmodel ( self, "models/cattest.mdl");
   setsize ( self, '-145.00000 -145.00000 0.00000', '145.00000 145.00000 26.00000');
   self.hull = HULL_SCORPION;
   setorigin ( self, self.origin);
   self.classname = "catapult";
   self.level = 30.00000;
   self.frame = 20.00000;
   self.th_pain = catapult_pain;
   self.th_weapon = catapult_fire;
   self.speed = 300.00000;
   if ( (self.wait == 0.00000) ) {

      self.wait = 3.00000;

   }
   self.th_die = chunk_death;
   self.takedamage = DAMAGE_YES;
   self.use = catapult_fire;
   if ( !self.thingtype ) {

      self.thingtype = THINGTYPE_WOOD;

   }
   if ( !self.mass ) {

      self.mass = 1000.00000;

   }
   if ( !self.health ) {

      self.health = 1000.00000;

   }
   self.max_health = self.health;
   self.think = catapult_ready;
   AdvanceThinkTime(self,0.00000);
};


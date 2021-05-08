
void  ()SpitTouch =  {
local float damg = 0.00000;
   if ( (other == self.owner) ) {

      return ;

   }
   if ( (pointcontents ( self.origin) == CONTENT_SKY) ) {

      remove ( self);
      return ;

   }
   damg = random(5.00000,8.00000);
   if ( other.health ) {

      T_Damage ( other, self, self.owner, damg);

   }
   T_RadiusDamage ( self, self.owner, damg, other);
   self.origin = (self.origin - (8.00000 * normalize ( self.velocity)));
   remove ( self);
};


void  ()spit_1 =  {
   self.veer += 10.00000;
   Veer ( self.veer);
   AdvanceThinkTime(self,0.10000);
};


void  (vector offset)do_spit =  {
local entity missile;
local vector vec = '0.00000 0.00000 0.00000';
   self.last_attack = time;
   missile = spawn ( );
   missile.owner = self;
   missile.movetype = MOVETYPE_FLYMISSILE;
   missile.solid = SOLID_BBOX;
   setmodel ( missile, "models/spit.mdl");
   setsize ( missile, '0.00000 0.00000 0.00000', '0.00000 0.00000 0.00000');
   makevectors ( self.angles);
   setorigin ( missile, (self.origin + v_factor ( offset)));
   if ( (self.enemy.velocity_z < 0.00000) ) {

      vec = (self.enemy.origin - missile.origin);
   } else {

      vec = ((self.enemy.origin - missile.origin) + self.enemy.view_ofs);

   }
   vec = normalize ( vec);
   missile.velocity = (vec * (650.00000 - random(30.00000)));
   missile.angles = vectoangles ( ('0.00000 0.00000 0.00000' - missile.velocity));
   missile.touch = SpitTouch;
   missile.veer = 5.00000;
   missile.think = spit_1;
   AdvanceThinkTime(missile,0.10000);
};


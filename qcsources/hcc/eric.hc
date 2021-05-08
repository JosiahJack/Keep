void  ()trap_fireball_use;

void  ()trap_fireball_wait =  {
   self.use = trap_fireball_use;
   self.think = SUB_Null;
   self.nextthink = -1.00000;
};


void  ()fireball_think =  {
   particle4 ( self.origin, 3.00000, random(160.00000,176.00000), PARTICLETYPE_FIREBALL, random(10.00000,20.00000));
   self.think = fireball_think;
   AdvanceThinkTime(self,0.10000);
};


void  ()trap_fireball_use =  {
local entity fireball;
local vector vec = '0.00000 0.00000 0.00000';
local float dot = 0.00000;
   if ( (self.spawnflags & 1.00000) ) {

      self.think = trap_fireball_wait;
      AdvanceThinkTime(self,0.00000);
   } else {

      self.use = trap_fireball_wait;
      self.think = trap_fireball_use;
      AdvanceThinkTime(self,self.wait);

   }
   if ( self.goalentity ) {

      self.enemy = self.goalentity;
   } else {

      self.enemy = find ( world, classname, "player");

   }
   if ( ((visible ( self.enemy) && (self.enemy != world)) || (self.goalentity == self.enemy)) ) {

      vec = normalize ( (((self.enemy.absmin + self.enemy.absmax) * 0.50000) - self.origin));
      makevectors ( self.angles);
      dot = (v_forward * vec);
      if ( ((dot > 0.60000) || (self.goalentity == self.enemy)) ) {

         sound ( self, CHAN_WEAPON, "imp/fireball.wav", 1.00000, ATTN_NORM);
         fireball = spawn ( );
         fireball.movetype = MOVETYPE_FLYMISSILE;
         fireball.solid = SOLID_BBOX;
         fireball.speed = 1000.00000;
         fireball.velocity = (vec * fireball.speed);
         fireball.touch = fireballTouch;
         fireball.dmg = self.dmg;
         fireball.owner = self;
         fireball.angles = vectoangles ( fireball.velocity);
         fireball.think = fireball_think;
         AdvanceThinkTime(fireball,0.05000);
         self.last_attack = time;
         setmodel ( fireball, "models/drgnball.mdl");
         setsize ( fireball, '0.00000 0.00000 0.00000', '0.00000 0.00000 0.00000');
         setorigin ( fireball, self.origin);

      }

   }
};


void  ()locate_first_target =  {
   self.goalentity = find ( world, targetname, self.target);
   if ( !self.goalentity ) {

      dprint ( "ERROR: Targeted Fireball can't find target\n");

   }
};


void  ()trap_fireball =  {
   precache_sound2 ( "imp/fireball.wav");
   precache_model2 ( "models/drgnball.mdl");
   if ( !self.wait ) {

      self.wait = 0.50000;

   }
   if ( !self.dmg ) {

      self.dmg = 10.00000;

   }
   if ( self.target ) {

      self.think = locate_first_target;
      AdvanceThinkTime(self,0.50000);

   }
   self.use = trap_fireball_use;
};


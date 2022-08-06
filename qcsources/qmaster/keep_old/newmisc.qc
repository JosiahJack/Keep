
void () light_lantern = {

   precache_model ("progs/lantern.mdl");
   setmodel (self,"progs/lantern.mdl");
   makestatic (self);

};

void () light_candle = {

   precache_model ("progs/candle.mdl");
   setmodel (self,"progs/candle.mdl");
   makestatic (self);

};

void () rubble_touch = {

   if ( ((other.classname == "player") || (other.flags & FL_MONSTER)) ) {

      if ( (vlen (self.velocity) > FALSE) ) {

         T_Damage (other,self,self,MOVETYPE_BOUNCE);

      }

   }

};

void () rubble_throw = {

   local vector throw;
   local entity rubble;

   rubble = find (world,targetname,self.target);
   throw = normalize ((rubble.origin - self.origin));
   throw_x = ((throw_x + (random () * 0.200)) - 0.100);
   throw_y = ((throw_y + (random () * 0.200)) - 0.100);
   throw_z = ((throw_z + (random () * 0.200)) - 0.100);
   rubble = spawn ();
   rubble.owner = self;
   rubble.classname = "rubble";
   rubble.movetype = MOVETYPE_BOUNCE;
   rubble.solid = SOLID_BBOX;
   rubble.velocity = (throw * 300.000);
   setmodel (rubble,"progs/rubble.mdl");
   setsize (rubble,'-16.000 -16.000 -16.000','16.000 16.000 16.000');
   setorigin (rubble,self.origin);
   rubble.touch = rubble_touch;
   rubble.think = SUB_Remove;
   rubble.nextthink = (time + SVC_INTERMISSION);
   if ( (self.spawnflags & TRUE) ) {

      rubble.skin = TRUE;

   } else {

      rubble.skin = FALSE;

   }
   self.think = rubble_throw;
   self.nextthink = (time + self.delay);

};

void () rubble_use = {

   if ( (self.wait == FALSE) ) {

      self.think = rubble_throw;
      self.nextthink = (time + self.delay);
      self.wait = TRUE;

   } else {

      self.nextthink = (time - TRUE);
      self.wait = FALSE;

   }

};

void () rubble_generator = {

   precache_model ("progs/rubble.mdl");
   if ( !self.target ) {

      objerror ("rubble_generator has no target!");

   }
   if ( !self.delay ) {

      self.delay = MOVETYPE_FLY;

   }
   self.solid = SOLID_NOT;
   self.use = rubble_use;
   if ( (self.spawnflags & FL_SWIM) ) {

      rubble_use ();

   }

};

void () trigEx_die = {

   SUB_UseTargets ();
   self.touch = SUB_Null;
   self.nextthink = (time + 0.100);
   self.think = SUB_Remove;

};

void () trigger_explosion = {

   InitTrigger ();
   if ( !self.health ) {

      self.health = 20.000;

   }
   self.max_health = self.health;
   self.th_die = trigEx_die;
   self.takedamage = DAMAGE_YES;
   self.solid = SOLID_BBOX;
   setorigin (self,self.origin);

};

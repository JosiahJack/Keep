void  (string modelname,string name)Ring_Init;

void  ()ring_touch =  {
local float amount = 0.00000;
local entity holdself;
   if ( ((other.classname != "player") || (other.health <= 0.00000)) ) {

      return ;

   }
   if ( ((self.owner == other) && (self.artifact_ignore_owner_time > time)) ) {

      return ;

   }
   if ( (self.artifact_ignore_time > time) ) {

      return ;

   }
   amount = random();
   if ( (amount < 0.50000) ) {

      sprint ( other, STR_YOUPOSSESS);
      sprint ( other, self.netname);
   } else {

      sprint ( other, STR_YOUHAVEACQUIRED);
      sprint ( other, self.netname);

   }
   sprint ( other, "\n");
   if ( (deathmatch || (self.classname == "Ring_Flight")) ) {

      self.mdl = self.model;
      self.nextthink = (time + 60.00000);
      self.think = SUB_regen;

   }
   sound ( other, CHAN_VOICE, "items/ringpkup.wav", 1.00000, ATTN_NORM);
   stuffcmd ( other, "bf\n");
   self.solid = SOLID_NOT;
   self.model = string_null;
   if ( ((self.classname == "Ring_Flight") && deathmatch) ) {

      other.cnt_flight += 1.00000;
   } else {

      if ( (self.classname == "Ring_Flight") ) {

         if ( (other.rings_active & RING_FLIGHT) ) {

            other.ring_flight = 100.00000;
            other.ring_flight_time = (time + 1.00000);
         } else {

            other.rings |= RING_FLIGHT;
            other.ring_flight = 100.00000;
            other.ring_flight_time = (time + 1.00000);
            holdself = self;
            self = other;
            player_fly ( );
            self = holdself;
            other.rings_active |= RING_FLIGHT;

         }
         other.rings_low ^= RING_FLIGHT;
      } else {

         if ( (self.classname == "Ring_WaterBreathing") ) {

            other.rings = (other.rings | RING_WATER);
            other.ring_water = 100.00000;
            other.ring_water_time = (time + 1.00000);
            if ( (other.rings_low & RING_WATER) ) {

               other.rings_low ^= RING_WATER;

            }
         } else {

            if ( (self.classname == "Ring_Turning") ) {

               other.rings = (other.rings | RING_TURNING);
               other.ring_turning = 100.00000;
               other.ring_turning_time = (time + 1.00000);
               other.rings_active |= RING_TURNING;
               if ( (other.rings_low & RING_TURNING) ) {

                  other.rings_low ^= RING_TURNING;

               }
            } else {

               if ( (self.classname == "Ring_Regeneration") ) {

                  other.rings = (other.rings | RING_REGENERATION);
                  other.ring_regeneration = 100.00000;
                  other.rings_active |= RING_REGENERATION;
                  if ( (other.rings_low & RING_REGENERATION) ) {

                     other.rings_low ^= RING_REGENERATION;

                  }

               }

            }

         }

      }

   }
   activator = other;
   SUB_UseTargets ( );
};


void  ()Ring_WaterBreathing =  {
   precache_model ( "models/ringwb.mdl");
   Ring_Init ( "models/ringwb.mdl", STR_RINGWATERBREATHING);
};


void  ()Ring_Flight =  {
   precache_model ( "models/ringft.mdl");
   Ring_Init ( "models/ringft.mdl", STR_RINGFLIGHT);
};


void  ()Ring_Regeneration =  {
   precache_model ( "models/ringre.mdl");
   Ring_Init ( "models/ringre.mdl", STR_RINGREGENERATION);
};


void  ()Ring_Turning =  {
   precache_model ( "models/ringtn.mdl");
   Ring_Init ( "models/ringtn.mdl", STR_RINGTURNING);
};


void  (string modelname,string name)Ring_Init =  {
   setmodel ( self, modelname);
   self.netname = name;
   setsize ( self, '0.00000 0.00000 0.00000', '0.00000 0.00000 0.00000');
   self.hull = HULL_POINT;
   self.touch = ring_touch;
   StartItem ( );
};


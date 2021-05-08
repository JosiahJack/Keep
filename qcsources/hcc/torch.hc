
void  ()Init_Torch =  {
   if ( self.targetname ) {

      self.use = torch_use;

   }
   self.solid = SOLID_BBOX;
   self.movetype = MOVETYPE_NONE;
   if ( self.health ) {

      if ( !self.targetname ) {

         dprint ( "No targetname for breakable torch\n");

      }
      if ( (self.style < 32.00000) ) {

         dprint ( ftos ( self.style));
         dprint ( ": Bad lightstyle for breakable torch\n");

      }
      self.takedamage = DAMAGE_YES;
      self.th_die = torch_death;
      self.classname = "breakable_torch";

   }
   if ( (self.style >= 32.00000) ) {

      if ( !self.lightvalue2 ) {

         self.lightvalue2 = 11.00000;

      }
      if ( !self.fadespeed ) {

         self.fadespeed = 1.00000;

      }
      initialize_lightstyle ( );
      self.think = torch_think;
      AdvanceThinkTime(self,1.00000);
   } else {

      self.drawflags |= MLS_ABSLIGHT;
      setmodel ( self, self.weaponmodel);
      if ( ((self.health != 0.00000) || (self.targetname != "")) ) {

         dprint ( ftos ( self.style));
         dprint ( ": Bad lightstyle for breakable torch\n");
      } else {

         makestatic ( self);

      }

   }
};


void  ()light_torch_eqypt =  {
   precache_model2 ( "models/egtorch.mdl");
   precache_model2 ( "models/eflmtrch.mdl");
   precache_sound ( "raven/flame1.wav");
   self.abslight = 0.75000;
   self.mdl = "models/egtorch.mdl";
   self.weaponmodel = "models/eflmtrch.mdl";
   self.thingtype = THINGTYPE_WOOD;
   setsize ( self, '-6.00000 -6.00000 -8.00000', '6.00000 6.00000 8.00000');
   Init_Torch ( );
};


void  ()light_torch_castle =  {
   precache_model2 ( "models/castrch.mdl");
   precache_model ( "models/cflmtrch.mdl");
   precache_sound ( "raven/flame1.wav");
   self.weaponmodel = "models/cflmtrch.mdl";
   self.mdl = "models/castrch.mdl";
   self.thingtype = THINGTYPE_METAL;
   setsize ( self, '-6.00000 -6.00000 -8.00000', '6.00000 6.00000 8.00000');
   self.abslight = 0.75000;
   Init_Torch ( );
};


void  ()light_torch_meso =  {
   precache_model2 ( "models/mesotrch.mdl");
   precache_model2 ( "models/mflmtrch.mdl");
   precache_sound ( "raven/flame1.wav");
   self.weaponmodel = "models/mflmtrch.mdl";
   self.mdl = "models/mesotrch.mdl";
   self.abslight = 0.75000;
   self.thingtype = THINGTYPE_BROWNSTONE;
   setsize ( self, '-12.00000 -12.00000 -16.00000', '12.00000 12.00000 16.00000');
   Init_Torch ( );
};


void  ()light_torch_rome =  {
   precache_model ( "models/rometrch.mdl");
   precache_model ( "models/rflmtrch.mdl");
   precache_sound ( "raven/flame1.wav");
   self.weaponmodel = "models/rflmtrch.mdl";
   self.mdl = "models/rometrch.mdl";
   self.thingtype = THINGTYPE_GREYSTONE;
   setsize ( self, '-6.00000 -6.00000 -8.00000', '6.00000 6.00000 8.00000');
   self.abslight = 0.75000;
   Init_Torch ( );
};


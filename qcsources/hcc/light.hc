float START_LOW   =  1.00000;

void  ()initialize_lightstyle =  {
   if ( (self.spawnflags & START_LOW) ) {

      if ( (self.lightvalue1 < self.lightvalue2) ) {

         lightstylestatic ( self.style, self.lightvalue1);
      } else {

         lightstylestatic ( self.style, self.lightvalue2);

      }
   } else {

      if ( (self.lightvalue1 < self.lightvalue2) ) {

         lightstylestatic ( self.style, self.lightvalue2);
      } else {

         lightstylestatic ( self.style, self.lightvalue1);

      }

   }
};


void  ()fadelight =  {
   self.frags += self.cnt;
   self.light_lev += self.frags;
   lightstylestatic ( self.style, self.light_lev);
   self.count += 1.00000;
   if ( ((self.count / 20.00000) >= self.fadespeed) ) {

      remove ( self);
   } else {

      if ( (((self.cnt < 0.00000) && (self.light_lev <= self.level)) || ((self.cnt > 0.00000) && (self.light_lev >= self.level))) ) {

         lightstylestatic ( self.style, self.level);
         remove ( self);
      } else {

         self.nextthink = (time + 0.05000);
         self.think = fadelight;

      }

   }
};


void  ()lightstyle_change_think =  {
   self.speed = (self.lightvalue2 - self.lightvalue1);
   self.light_lev = lightstylevalue ( self.style);
   if ( (self.light_lev == self.lightvalue1) ) {

      self.level = self.lightvalue2;
   } else {

      if ( (self.light_lev == self.lightvalue2) ) {

         self.level = self.lightvalue1;
      } else {

         if ( (self.speed > 0.00000) ) {

            if ( (self.light_lev < (self.lightvalue1 + (self.speed * 0.50000))) ) {

               self.level = self.lightvalue2;
            } else {

               self.level = self.lightvalue1;

            }
         } else {

            if ( (self.speed < 0.00000) ) {

               if ( (self.light_lev < (self.lightvalue2 - (self.speed * 0.50000))) ) {

                  self.level = self.lightvalue1;
               } else {

                  self.level = self.lightvalue2;

               }

            }

         }

      }

   }
   self.cnt = (((self.level - self.light_lev) / self.fadespeed) / 20.00000);
   self.think = fadelight;
   self.nextthink = time;
};


void  (entity light_targ)lightstyle_change =  {
   newmis = spawn ( );
   newmis.lightvalue1 = light_targ.lightvalue1;
   newmis.lightvalue2 = light_targ.lightvalue2;
   newmis.fadespeed = light_targ.fadespeed;
   newmis.style = self.style;
   newmis.think = lightstyle_change_think;
   newmis.nextthink = time;
};


void  ()torch_death =  {
   lightstylestatic ( self.style, 0.00000);
   chunk_death ( );
};


void  ()torch_think =  {
local float lightstate = 0.00000;
   lightstate = lightstylevalue ( self.style);
   if ( !lightstate ) {

      if ( self.mdl ) {

         setmodel ( self, self.mdl);

      }
      self.drawflags ^= MLS_ABSLIGHT;
   } else {

      if ( self.weaponmodel ) {

         setmodel ( self, self.weaponmodel);

      }
      self.drawflags |= MLS_ABSLIGHT;

   }
   if ( (time > self.fadespeed) ) {

      self.nextthink = -1.00000;
   } else {

      self.nextthink = (time + 0.05000);

   }
   self.think = torch_think;
};


void  ()torch_use =  {
   self.fadespeed = ((time + other.fadespeed) + 1.00000);
   torch_think ( );
};


void  ()light =  {
   if ( (self.targetname == "") ) {

      remove ( self);
   } else {

      if ( !self.lightvalue2 ) {

         self.lightvalue2 = 11.00000;

      }
      if ( !self.fadespeed ) {

         self.fadespeed = 1.00000;

      }
      initialize_lightstyle ( );

   }
};


void  ()FireAmbient =  {
   precache_sound ( "raven/flame1.wav");
   ambientsound ( self.origin, "raven/flame1.wav", 0.50000, ATTN_STATIC);
};


void  ()light_torch_small_walltorch =  {
   precache_model ( "models/flame.mdl");
   FireAmbient ( );
   if ( self.targetname ) {

      self.use = torch_use;

   }
   self.mdl = "models/null.spr";
   self.weaponmodel = "models/flame.mdl";
   self.abslight = 0.75000;
   if ( (self.style >= 32.00000) ) {

      if ( !self.lightvalue2 ) {

         self.lightvalue2 = 11.00000;

      }
      if ( !self.fadespeed ) {

         self.fadespeed = 1.00000;

      }
      initialize_lightstyle ( );
      self.think = torch_think;
      self.nextthink = (time + 1.00000);
   } else {

      self.drawflags |= MLS_ABSLIGHT;
      setmodel ( self, self.weaponmodel);
      makestatic ( self);

   }
};


void  ()light_flame_large_yellow =  {
   precache_model ( "models/flame1.mdl");
   FireAmbient ( );
   if ( self.targetname ) {

      self.use = torch_use;

   }
   self.abslight = 0.75000;
   self.mdl = "models/null.spr";
   self.weaponmodel = "models/flame1.mdl";
   if ( (self.style >= 32.00000) ) {

      if ( !self.lightvalue2 ) {

         self.lightvalue2 = 11.00000;

      }
      if ( !self.fadespeed ) {

         self.fadespeed = 1.00000;

      }
      initialize_lightstyle ( );
      self.think = torch_think;
      self.nextthink = (time + 1.00000);
   } else {

      self.drawflags |= MLS_ABSLIGHT;
      setmodel ( self, self.weaponmodel);
      makestatic ( self);

   }
};


void  ()light_flame_small_yellow =  {
   precache_model ( "models/flame2.mdl");
   FireAmbient ( );
   if ( self.targetname ) {

      self.use = torch_use;

   }
   self.abslight = 0.75000;
   self.mdl = "models/null.spr";
   self.weaponmodel = "models/flame2.mdl";
   if ( (self.style >= 32.00000) ) {

      if ( !self.lightvalue2 ) {

         self.lightvalue2 = 11.00000;

      }
      if ( !self.fadespeed ) {

         self.fadespeed = 1.00000;

      }
      initialize_lightstyle ( );
      self.think = torch_think;
      self.nextthink = (time + 1.00000);
   } else {

      self.drawflags |= MLS_ABSLIGHT;
      setmodel ( self, self.weaponmodel);
      makestatic ( self);

   }
};


void  ()light_gem =  {
   precache_model ( "models/gemlight.mdl");
   if ( self.targetname ) {

      self.use = torch_use;

   }
   self.mdl = "models/null.spr";
   self.weaponmodel = "models/gemlight.mdl";
   self.abslight = 0.75000;
   if ( (self.style >= 32.00000) ) {

      if ( !self.lightvalue2 ) {

         self.lightvalue2 = 11.00000;

      }
      if ( !self.fadespeed ) {

         self.fadespeed = 1.00000;

      }
      initialize_lightstyle ( );
      self.think = torch_think;
      self.nextthink = (time + 1.00000);
   } else {

      self.drawflags |= MLS_ABSLIGHT;
      setmodel ( self, self.weaponmodel);
      makestatic ( self);

   }
};



void  ()rain_use =  {
   dprint ( " rain ");
   rain_go ( self.mins, self.maxs, self.size, '125.00000 100.00000 0.00000', (self.color + random(8.00000)), self.counter);
   self.nextthink = (time + self.wait);
};

float RAIN_STRAIGHT   =  1.00000;

void  ()rain_splatter =  {
local vector spot1 = '0.00000 0.00000 0.00000';
local vector spot2 = '0.00000 0.00000 0.00000';
   spot1 = self.mins;
   spot1_x += random(self.size_x);
   spot1_y += random(self.size_y);
   spot1_z = self.maxs_z;
   spot2 = spot1;
   spot2_z = (self.mins_z - 10.00000);
   traceline ( spot1, spot2, FALSE, self);
   if ( (trace_fraction < 1.00000) ) {

      particle4 ( trace_endpos, 10.00000, random(408.00000,412.00000), PARTICLETYPE_GRAV, random(5.00000,10.00000));
      AdvanceThinkTime(self,random(0.01000,0.20000));
   } else {

      AdvanceThinkTime(self,0.00000);

   }
};


void  ()make_splatter =  {
   newmis = spawn ( );
   setorigin ( newmis, self.origin);
   setsize ( newmis, self.mins, self.maxs);
   newmis.think = rain_splatter;
   AdvanceThinkTime(newmis,0.00000);
};


void  ()weather_rain =  {
local vector dir = '0.00000 0.00000 0.00000';
local float splat_count = 0.00000;
   if ( !self.soundtype ) {

      precache_sound2 ( "ambience/rain.wav");
      self.noise1 = "ambience/rain.wav";
   } else {

      precache_sound2 ( "ambience/drip1.wav");
      self.noise1 = "ambience/drip1.wav";
      self.think = sound_again;
      self.nextthink = (time + random(5.00000,30.00000));

   }
   self.movetype = MOVETYPE_NOCLIP;
   self.owner = self;
   self.solid = SOLID_NOT;
   setsize ( self, self.mins, self.maxs);
   setorigin ( self, self.origin);
   setmodel ( self, self.model);
   self.modelindex = 0.00000;
   self.model = "";
   if ( !self.wait ) {

      self.wait = 0.10000;

   }
   if ( !self.color ) {

      self.color = 414.00000;

   }
   if ( !self.counter ) {

      self.counter = 300.00000;

   }
   if ( (self.spawnflags & RAIN_STRAIGHT) ) {

      dir = '0.00000 0.00000 0.00000';
   } else {

      dir = '125.00000 100.00000 0.00000';

   }
   self.color = 414.00000;
   starteffect ( CE_RAIN, self.mins, self.maxs, self.size, dir, self.color, self.counter, self.wait);
   if ( !self.soundtype ) {

      ambientsound ( self.origin, "ambience/rain.wav", 1.00000, ATTN_NONE);
   } else {

      sound ( self, CHAN_VOICE, self.noise1, 1.00000, ATTN_NORM);

   }
   if ( !(self.spawnflags & 2.00000) ) {

      splat_count = 10.00000;

   }
   while ( splat_count ) {

      make_splatter ( );
      splat_count -= 1.00000;

   }
   if ( !self.soundtype ) {

      remove ( self);

   }
};


void  ()weather_lightning_use =  {
local vector p1 = '0.00000 0.00000 0.00000';
local vector p2 = '0.00000 0.00000 0.00000';
local entity targ;
   if ( (self.classname == "weather_sunbeam_start") ) {

      sound ( self, CHAN_WEAPON, "crusader/sunhum.wav", 1.00000, ATTN_NORM);

   }
   if ( !self.target ) {

      dprint ( "No target for lightning\n");
      return ;

   }
   targ = find ( world, targetname, self.target);
   if ( !targ ) {

      dprint ( "No target for beam effect\n");
      return ;

   }
   p1 = self.origin;
   p2 = targ.origin;
   p1 += (normalize ( (p2 - p1)) * 15.00000);
   if ( (self.classname == "weather_lightning_start") ) {

      do_lightning ( self, 1.00000, 0.00000, 4.00000, p1, p2, 10.00000);
   } else {

      if ( (self.classname == "weather_sunbeam_start") ) {

         WriteByte ( MSG_BROADCAST, SVC_TEMPENTITY);
         WriteByte ( MSG_BROADCAST, TE_STREAM_SUNSTAFF1);
         WriteEntity ( MSG_BROADCAST, self);
         WriteByte ( MSG_BROADCAST, 0.00000);
         WriteByte ( MSG_BROADCAST, 4.00000);
         WriteCoord ( MSG_BROADCAST, p1_x);
         WriteCoord ( MSG_BROADCAST, p1_y);
         WriteCoord ( MSG_BROADCAST, p1_z);
         WriteCoord ( MSG_BROADCAST, p2_x);
         WriteCoord ( MSG_BROADCAST, p2_y);
         WriteCoord ( MSG_BROADCAST, p2_z);
         LightningDamage ( p1, p2, self, 10.00000, "sunbeam");
      } else {

         if ( (self.classname == "fx_colorbeam_start") ) {

            WriteByte ( MSG_BROADCAST, SVC_TEMPENTITY);
            WriteByte ( MSG_BROADCAST, TE_STREAM_COLORBEAM);
            WriteEntity ( MSG_BROADCAST, self);
            WriteByte ( MSG_BROADCAST, 0.00000);
            WriteByte ( MSG_BROADCAST, 4.00000);
            WriteByte ( MSG_BROADCAST, self.color);
            WriteCoord ( MSG_BROADCAST, p1_x);
            WriteCoord ( MSG_BROADCAST, p1_y);
            WriteCoord ( MSG_BROADCAST, p1_z);
            WriteCoord ( MSG_BROADCAST, p2_x);
            WriteCoord ( MSG_BROADCAST, p2_y);
            WriteCoord ( MSG_BROADCAST, p2_z);
         } else {

            return ;

         }

      }

   }
   if ( (self.lifetime > time) ) {

      AdvanceThinkTime(self,0.20000);
   } else {

      if ( (self.wait > -1.00000) ) {

         AdvanceThinkTime(self,self.wait);
         self.think = weather_lightning_use;
         self.lifetime = (self.lifespan + self.nextthink);
         self.aflag = FALSE;
      } else {

         self.nextthink = -1.00000;

      }

   }
};


void  ()lightning_init =  {
   if ( (self.lifetime > time) ) {

      return ;

   }
   self.think = weather_lightning_use;
   self.lifetime = (self.lifespan + time);
   if ( (self.spawnflags & 2.00000) ) {

      if ( (random() < 0.50000) ) {

         sound ( self, CHAN_AUTO, "crusader/lghtn1.wav", 1.00000, ATTN_NORM);
      } else {

         sound ( self, CHAN_AUTO, "crusader/lghtn1.wav", 1.00000, ATTN_NORM);

      }
      self.aflag = TRUE;

   }
   weather_lightning_use ( );
};


void  ()weather_lightning_start =  {
   self.movetype = MOVETYPE_NOCLIP;
   self.owner = self;
   self.solid = SOLID_NOT;
   setorigin ( self, self.origin);
   setmodel ( self, self.model);
   setsize ( self, self.mins, self.maxs);
   if ( (self.classname == "weather_lightning_start") ) {

      precache_model2 ( "models/stlghtng.mdl");
      if ( !self.noise ) {

         self.noise = "raven/lightng1.wav";
         precache_sound2 ( "raven/lightng1.wav");

      }
      if ( (self.spawnflags & 2.00000) ) {

         self.noise = "";
         precache_sound2 ( "crusader/lghtn1.wav");

      }
   } else {

      if ( ((self.classname == "weather_sunbeam_start") && (self.noise == "2")) ) {

         dprint ( "Shazzaam!\n");
         self.noise = "crusader/lghtn1.wav";
         precache_sound2 ( "crusader/lghtn1.wav");

      }

   }
   self.use = lightning_init;
   self.think = weather_lightning_use;
   if ( !self.wait ) {

      self.wait = 5.00000;

   }
   if ( ((self.wait > -1.00000) && !(self.spawnflags & 1.00000)) ) {

      AdvanceThinkTime(self,self.wait);
      self.lifetime = ((time + self.lifespan) + self.wait);

   }
};


void  ()weather_lightning_end =  {
   self.movetype = MOVETYPE_NOCLIP;
   self.owner = self;
   self.solid = SOLID_NOT;
   setsize ( self, self.mins, self.maxs);
   setorigin ( self, self.origin);
};


void  ()weather_sunbeam_start =  {
   precache_model2 ( "models/stsunsf1.mdl");
   precache_model2 ( "models/stsunsf2.mdl");
   precache_model2 ( "models/stsunsf3.mdl");
   precache_model2 ( "models/stsunsf4.mdl");
   self.noise = "crusader/lghtn1.wav";
   weather_lightning_start ( );
};


void  ()weather_sunbeam_end =  {
   weather_lightning_end ( );
};


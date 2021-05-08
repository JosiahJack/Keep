float PLAQUE_INVISIBLE   =  1.00000;
float PLAQUE_ACTIVATE   =  2.00000;

void  ()plaque_use =  {
   if ( (self.spawnflags & PLAQUE_ACTIVATE) ) {

      self.inactive = 0.00000;

   }
};


void  ()plaque_touch =  {
local vector spot1 = '0.00000 0.00000 0.00000';
local vector spot2 = '0.00000 0.00000 0.00000';
   if ( self.inactive ) {

      return ;

   }
   if ( ((other.classname == "player") && !other.plaqueflg) ) {

      makevectors ( other.v_angle);
      spot1 = (other.origin + other.view_ofs);
      spot2 = (spot1 + (v_forward * 25.00000));
      traceline ( spot1, spot2, FALSE, other);
      if ( ((trace_fraction == 1.00000) || (trace_ent.classname != "plaque")) ) {

         traceline ( spot1, (spot2 - (v_up * 30.00000)), FALSE, other);
         if ( ((trace_fraction == 1.00000) || (trace_ent.classname != "plaque")) ) {

            traceline ( spot1, (spot2 + (v_up * 30.00000)), FALSE, other);
            if ( ((trace_fraction == 1.00000) || (trace_ent.classname != "plaque")) ) {

               return ;

            }

         }

      }
      other.plaqueflg = 1.00000;
      other.plaqueangle = other.v_angle;
      msg_entity = other;
      plaque_draw ( MSG_ONE, self.message);
      if ( (other.noise1 != "") ) {

         sound ( other, CHAN_VOICE, self.noise1, 1.00000, ATTN_NORM);
      } else {

         sound ( other, CHAN_ITEM, self.noise, 1.00000, ATTN_NORM);

      }

   }
};


void  ()plaque =  {
   setsize ( self, self.mins, self.maxs);
   setorigin ( self, self.origin);
   setmodel ( self, self.model);
   self.solid = SOLID_SLIDEBOX;
   if ( deathmatch ) {

      return ;

   }
   self.use = plaque_use;
   precache_sound ( "raven/use_plaq.wav");
   self.noise = "raven/use_plaq.wav";
   self.touch = plaque_touch;
   if ( (self.spawnflags & PLAQUE_INVISIBLE) ) {

      self.effects |= EF_NODRAW;

   }
   if ( (self.spawnflags & PLAQUE_ACTIVATE) ) {

      self.inactive = 1.00000;
   } else {

      self.inactive = 0.00000;

   }
};


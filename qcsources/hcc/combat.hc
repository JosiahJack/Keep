
float  (float targettype)MetalHitSound =  {
   if ( (targettype == THINGTYPE_FLESH) ) {

      sound ( self, CHAN_WEAPON, "weapons/met2flsh.wav", 1.00000, ATTN_NORM);
      return ( TRUE );
   } else {

      if ( (targettype == THINGTYPE_WOOD) ) {

         sound ( self, CHAN_WEAPON, "weapons/met2wd.wav", 1.00000, ATTN_NORM);
         return ( TRUE );
      } else {

         if ( (targettype == THINGTYPE_METAL) ) {

            sound ( self, CHAN_WEAPON, "weapons/met2met.wav", 1.00000, ATTN_NORM);
            return ( TRUE );
         } else {

            if ( ((targettype == THINGTYPE_BROWNSTONE) || (targettype == THINGTYPE_GREYSTONE)) ) {

               sound ( self, CHAN_WEAPON, "weapons/met2stn.wav", 1.00000, ATTN_NORM);
               return ( TRUE );

            }

         }

      }

   }
   return ( FALSE );
};


void  (float damage_base,float damage_mod,float attack_radius)FireMelee =  {
local vector source = '0.00000 0.00000 0.00000';
local vector org = '0.00000 0.00000 0.00000';
local float damg = 0.00000;
local float backstab = 0.00000;
local float chance = 0.00000;
local float point_chance = 0.00000;
   makevectors ( self.v_angle);
   source = (self.origin + self.proj_ofs);
   traceline ( source, (source + (v_forward * 64.00000)), FALSE, self);
   if ( (trace_fraction == 1.00000) ) {

      traceline ( source, ((source + (v_forward * 64.00000)) - (v_up * 30.00000)), FALSE, self);
      if ( (trace_fraction == 1.00000) ) {

         traceline ( source, ((source + (v_forward * 64.00000)) + (v_up * 30.00000)), FALSE, self);
         if ( (trace_fraction == 1.00000) ) {

            return ;

         }

      }

   }
   org = (trace_endpos + (v_forward * 4.00000));
   if ( trace_ent.takedamage ) {

      if ( (((((trace_ent.flags2 & FL_ALIVE) && !infront_of_ent ( self, trace_ent)) && (self.playerclass == CLASS_ASSASSIN)) && (self.weapon == IT_WEAPON1)) && (random(1.00000,10.00000) < self.level)) ) {

         CreateRedFlash ( trace_endpos);
         damage_base *= random(2.50000,4.00000);
         backstab = TRUE;

      }
      damg = random((damage_mod + damage_base),damage_base);
      SpawnPuff ( org, '0.00000 0.00000 0.00000', damg, trace_ent);
      T_Damage ( trace_ent, self, self, damg);
      if ( (!(trace_ent.flags2 & FL_ALIVE) && backstab) ) {

         centerprint ( self, "Critical Hit Backstab!\n");
         AwardExperience ( self, trace_ent, 10.00000);

      }
      if ( (trace_ent.thingtype == THINGTYPE_FLESH) ) {

         sound ( self, CHAN_WEAPON, "weapons/slash.wav", 1.00000, ATTN_NORM);
      } else {

         sound ( self, CHAN_WEAPON, "weapons/hitwall.wav", 1.00000, ATTN_NORM);

      }
      if ( (self.playerclass == CLASS_NECROMANCER) ) {

         if ( ((trace_ent.flags & FL_MONSTER) || (trace_ent.flags & FL_CLIENT)) ) {

            chance = (self.level * 0.05000);
            if ( (chance > random()) ) {

               point_chance = self.level;
               point_chance *= random();
               if ( (point_chance < 1.00000) ) {

                  point_chance = 1.00000;

               }
               sound ( self, CHAN_BODY, "weapons/drain.wav", 1.00000, ATTN_NORM);
               self.health += point_chance;
               if ( (self.health > self.max_health) ) {

                  self.health = self.max_health;

               }

            }

         }

      }
   } else {

      sound ( self, CHAN_WEAPON, "weapons/hitwall.wav", 1.00000, ATTN_NORM);
      WriteByte ( MSG_BROADCAST, SVC_TEMPENTITY);
      WriteByte ( MSG_BROADCAST, TE_GUNSHOT);
      WriteCoord ( MSG_BROADCAST, org_x);
      WriteCoord ( MSG_BROADCAST, org_y);
      WriteCoord ( MSG_BROADCAST, org_z);

   }
};


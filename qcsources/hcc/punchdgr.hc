void  ()Ass_Pdgr_Fire;

void  ()fire_punchdagger =  {
local vector source = '0.00000 0.00000 0.00000';
local vector org = '0.00000 0.00000 0.00000';
local vector dir = '0.00000 0.00000 0.00000';
local float damg = 0.00000;
local float inertia = 0.00000;
local float damage_mod = 0.00000;
local float damage_base = 0.00000;
   damage_mod = 10.00000;
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

      if ( (((trace_ent.flags2 & FL_ALIVE) && !infront_of_ent ( self, trace_ent)) && (random(1.00000,10.00000) < self.level)) ) {

         damage_base = WEAPON1_PWR_BASE_DAMAGE;
         damage_mod = WEAPON1_PWR_ADD_DAMAGE;
         CreateRedFlash ( trace_endpos);
         centerprint ( self, "Critical Hit Backstab!\n");
         AwardExperience ( self, trace_ent, 10.00000);
         damage_base *= random(2.50000,4.00000);
      } else {

         if ( (self.artifact_active & ART_TOMEOFPOWER) ) {

            damage_base = WEAPON1_PWR_BASE_DAMAGE;
            damage_mod = WEAPON1_PWR_ADD_DAMAGE;
            CreateWhiteFlash ( org);
            if ( (trace_ent.mass <= 10.00000) ) {

               inertia = 1.00000;
            } else {

               inertia = (trace_ent.mass / 10.00000);

            }
            if ( (((trace_ent.hull != HULL_BIG) && (inertia < 1000.00000)) && (trace_ent.classname != "breakable_brush")) ) {

               if ( (trace_ent.mass < 1000.00000) ) {

                  dir = (trace_ent.origin - self.origin);
                  trace_ent.velocity = ((dir * WEAPON1_PUSH) * (1.00000 / inertia));
                  if ( (trace_ent.movetype == MOVETYPE_FLY) ) {

                     if ( (trace_ent.flags & FL_ONGROUND) ) {

                        trace_ent.velocity_z = (200.00000 / inertia);

                     }
                  } else {

                     trace_ent.velocity_z = (200.00000 / inertia);

                  }
                  trace_ent.flags ^= FL_ONGROUND;

               }

            }
         } else {

            damage_base = WEAPON1_BASE_DAMAGE;
            damage_mod = WEAPON1_ADD_DAMAGE;

         }

      }
      damg = random((damage_mod + damage_base),damage_base);
      SpawnPuff ( org, '0.00000 0.00000 0.00000', damg, trace_ent);
      T_Damage ( trace_ent, self, self, damg);
      if ( !MetalHitSound ( trace_ent.thingtype) ) {

         sound ( self, CHAN_WEAPON, "weapons/slash.wav", 1.00000, ATTN_NORM);

      }
   } else {

      sound ( self, CHAN_WEAPON, "weapons/hitwall.wav", 1.00000, ATTN_NORM);
      WriteByte ( MSG_BROADCAST, SVC_TEMPENTITY);
      WriteByte ( MSG_BROADCAST, TE_GUNSHOT);
      WriteCoord ( MSG_BROADCAST, org_x);
      WriteCoord ( MSG_BROADCAST, org_y);
      WriteCoord ( MSG_BROADCAST, org_z);
      if ( (self.artifact_active & ART_TOMEOFPOWER) ) {

         CreateWhiteFlash ( org);
      } else {

         org = ((trace_endpos + (v_forward * -1.00000)) + (v_right * 15.00000));
         org -= '0.00000 0.00000 26.00000';
         CreateSpark ( org);

      }

   }
};


void  ()punchdagger_idle =  {
   self.th_weapon = punchdagger_idle;
   self.weaponframe = 0.00000;
};


void  ()punchdagger_d =  {
   self.th_weapon = punchdagger_d;
   self.wfs = advanceweaponframe ( 33.00000, 45.00000);
   if ( (self.weaponframe == 35.00000) ) {

      sound ( self, CHAN_WEAPON, "weapons/gaunt1.wav", 1.00000, ATTN_NORM);

   }
   if ( (self.weaponframe == 37.00000) ) {

      fire_punchdagger ( );

   }
   if ( (self.wfs == WF_CYCLE_WRAPPED) ) {

      punchdagger_idle ( );

   }
};


void  ()punchdagger_c =  {
   self.th_weapon = punchdagger_c;
   self.wfs = advanceweaponframe ( 21.00000, 32.00000);
   if ( (self.weaponframe == 25.00000) ) {

      sound ( self, CHAN_WEAPON, "weapons/gaunt1.wav", 1.00000, ATTN_NORM);

   }
   if ( (self.weaponframe == 26.00000) ) {

      fire_punchdagger ( );

   }
   if ( (self.wfs == WF_CYCLE_WRAPPED) ) {

      punchdagger_idle ( );

   }
};


void  ()punchdagger_b =  {
   self.th_weapon = punchdagger_b;
   self.wfs = advanceweaponframe ( 9.00000, 20.00000);
   if ( (self.weaponframe == 10.00000) ) {

      sound ( self, CHAN_WEAPON, "weapons/gaunt1.wav", 1.00000, ATTN_NORM);

   }
   if ( (self.weaponframe == 14.00000) ) {

      fire_punchdagger ( );

   }
   if ( (self.wfs == WF_CYCLE_WRAPPED) ) {

      punchdagger_idle ( );

   }
};


void  ()punchdagger_a =  {
   self.th_weapon = punchdagger_a;
   self.wfs = advanceweaponframe ( 1.00000, 8.00000);
   if ( (self.weaponframe == 3.00000) ) {

      sound ( self, CHAN_WEAPON, "weapons/gaunt1.wav", 1.00000, ATTN_NORM);

   }
   if ( (self.weaponframe == 5.00000) ) {

      fire_punchdagger ( );

   }
   if ( (self.wfs == WF_CYCLE_WRAPPED) ) {

      punchdagger_idle ( );

   }
};

float r2   =  0.00000;

void  ()Ass_Pdgr_Fire =  {
   self.attack_finished = (time + 0.50000);
   if ( (r2 == 1.00000) ) {

      punchdagger_a ( );
   } else {

      if ( (r2 == 2.00000) ) {

         punchdagger_b ( );
      } else {

         if ( (r2 == 3.00000) ) {

            punchdagger_c ( );
         } else {

            punchdagger_d ( );

         }

      }

   }
   r2 += 1.00000;
   if ( (r2 > 4.00000) ) {

      r2 = 1.00000;

   }
};


void  ()punchdagger_select =  {
   self.th_weapon = punchdagger_select;
   self.wfs = advanceweaponframe ( 53.00000, 46.00000);
   self.weaponmodel = "models/punchdgr.mdl";
   if ( (self.wfs == WF_CYCLE_STARTED) ) {

      sound ( self, CHAN_WEAPON, "weapons/unsheath.wav", 1.00000, ATTN_NORM);

   }
   if ( (self.wfs == WF_CYCLE_WRAPPED) ) {

      self.attack_finished = (time - 1.00000);
      punchdagger_idle ( );

   }
};


void  ()punchdagger_deselect =  {
   self.th_weapon = punchdagger_deselect;
   self.wfs = advanceweaponframe ( 46.00000, 53.00000);
   if ( (self.wfs == WF_CYCLE_WRAPPED) ) {

      W_SetCurrentAmmo ( );

   }
};


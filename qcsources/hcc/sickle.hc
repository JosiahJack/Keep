void  ()sickle_decide_attack;

void  ()sickle_fire =  {
local vector source = '0.00000 0.00000 0.00000';
local vector org = '0.00000 0.00000 0.00000';
local vector dir = '0.00000 0.00000 0.00000';
local float damg = 0.00000;
local float inertia = 0.00000;
local float damage_mod = 0.00000;
local float damage_base = 0.00000;
local float chance = 0.00000;
local float point_chance = 0.00000;
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

      if ( (((trace_ent.flags & FL_MONSTER) || (trace_ent.flags & FL_CLIENT)) && (self.level >= 6.00000)) ) {

         chance = ((self.level - 5.00000) * 0.04000);
         if ( (chance > 0.20000) ) {

            chance = 0.20000;

         }
         if ( (random() < chance) ) {

            point_chance = ((self.level - 5.00000) * 2.00000);
            if ( (point_chance > 10.00000) ) {

               point_chance = 10.00000;

            }
            sound ( self, CHAN_BODY, "weapons/drain.wav", 1.00000, ATTN_NORM);
            self.health += point_chance;
            if ( (self.health > self.max_health) ) {

               self.health = self.max_health;

            }

         }

      }
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


void  ()sickle_ready =  {
   self.th_weapon = sickle_ready;
   self.weaponframe = 0.00000;
};


void  ()sickle_c =  {
   self.th_weapon = sickle_c;
   self.wfs = advanceweaponframe ( 20.00000, 29.00000);
   if ( (self.weaponframe == 20.00000) ) {

      sound ( self, CHAN_WEAPON, "weapons/gaunt1.wav", 1.00000, ATTN_NORM);
   } else {

      if ( (self.weaponframe == 22.00000) ) {

         sickle_fire ( );

      }

   }
   if ( (self.wfs == WF_LAST_FRAME) ) {

      sickle_ready ( );

   }
};


void  ()sickle_b =  {
   self.th_weapon = sickle_b;
   self.wfs = advanceweaponframe ( 10.00000, 19.00000);
   if ( (self.weaponframe == 10.00000) ) {

      sound ( self, CHAN_WEAPON, "weapons/gaunt1.wav", 1.00000, ATTN_NORM);
   } else {

      if ( (self.weaponframe == 12.00000) ) {

         sickle_fire ( );
      } else {

         if ( (self.wfs == WF_LAST_FRAME) ) {

            sickle_ready ( );

         }

      }

   }
};


void  ()sickle_a =  {
   self.th_weapon = sickle_a;
   self.wfs = advanceweaponframe ( 1.00000, 9.00000);
   if ( (self.weaponframe == 1.00000) ) {

      sound ( self, CHAN_WEAPON, "weapons/gaunt1.wav", 1.00000, ATTN_NORM);
   } else {

      if ( (self.weaponframe == 2.00000) ) {

         sickle_fire ( );
      } else {

         if ( (self.wfs == WF_LAST_FRAME) ) {

            sickle_ready ( );

         }

      }

   }
};


void  ()sickle_select =  {
   self.th_weapon = sickle_select;
   self.wfs = advanceweaponframe ( 39.00000, 30.00000);
   self.weaponmodel = "models/sickle.mdl";
   if ( (self.wfs == WF_CYCLE_STARTED) ) {

      sound ( self, CHAN_WEAPON, "weapons/unsheath.wav", 1.00000, ATTN_NORM);

   }
   if ( (self.wfs == WF_CYCLE_WRAPPED) ) {

      self.attack_finished = (time - 1.00000);
      sickle_ready ( );

   }
};


void  ()sickle_deselect =  {
   self.th_weapon = sickle_deselect;
   self.wfs = advanceweaponframe ( 30.00000, 39.00000);
   if ( (self.wfs == WF_CYCLE_WRAPPED) ) {

      W_SetCurrentAmmo ( );

   }
};


void  ()sickle_decide_attack =  {
   if ( (self.attack_cnt < 1.00000) ) {

      sickle_a ( );
   } else {

      sickle_b ( );
      self.attack_cnt = -1.00000;

   }
   self.attack_cnt += 1.00000;
   self.attack_finished = (time + 0.50000);
};


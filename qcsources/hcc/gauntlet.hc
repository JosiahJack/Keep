float GAUNT_BASE_DAMAGE   =  16.00000;
float GAUNT_ADD_DAMAGE   =  12.00000;
float GAUNT_PWR_BASE_DAMAGE   =  30.00000;
float GAUNT_PWR_ADD_DAMAGE   =  20.00000;
float GAUNT_PUSH   =  4.00000;

void  (float anim)gauntlet_fire =  {
local vector source = '0.00000 0.00000 0.00000';
local vector org = '0.00000 0.00000 0.00000';
local float damg = 0.00000;
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

      SpawnPuff ( org, '0.00000 0.00000 0.00000', 20.00000, trace_ent);
      if ( (self.artifact_active & ART_TOMEOFPOWER) ) {

         damg = (GAUNT_PWR_BASE_DAMAGE + random(GAUNT_PWR_ADD_DAMAGE));
         org = (trace_endpos + (v_forward * -1.00000));
         CreateWhiteFlash ( org);
         sound ( self, CHAN_WEAPON, "weapons/gauntht1.wav", 1.00000, ATTN_NORM);
      } else {

         damg = (GAUNT_BASE_DAMAGE + random(GAUNT_ADD_DAMAGE));
         sound ( self, CHAN_WEAPON, "weapons/gauntht1.wav", 1.00000, ATTN_NORM);

      }
      T_Damage ( trace_ent, self, self, damg);
   } else {

      sound ( self, CHAN_WEAPON, "weapons/gauntht2.wav", 1.00000, ATTN_NORM);
      WriteByte ( MSG_BROADCAST, SVC_TEMPENTITY);
      WriteByte ( MSG_BROADCAST, TE_GUNSHOT);
      WriteCoord ( MSG_BROADCAST, org_x);
      WriteCoord ( MSG_BROADCAST, org_y);
      WriteCoord ( MSG_BROADCAST, org_z);
      org = (trace_endpos + (v_forward * -1.00000));
      org += '0.00000 0.00000 10.00000';
      CreateWhiteSmoke ( org, '0.00000 0.00000 2.00000', HX_FRAME_TIME);

   }
};


void  ()gauntlet_ready =  {
   self.th_weapon = gauntlet_ready;
   self.weaponframe = 0.00000;
};


void  ()gauntlet_twitch =  {
   self.wfs = advanceweaponframe ( 42.00000, 55.00000);
   self.th_weapon = gauntlet_twitch;
   if ( (self.weaponframe == 44.00000) ) {

      sound ( self, CHAN_VOICE, "fx/wallbrk.wav", 1.00000, ATTN_NORM);

   }
   if ( (self.wfs == WF_LAST_FRAME) ) {

      gauntlet_ready ( );

   }
};


void  ()gauntlet_select =  {
   self.wfs = advanceweaponframe ( 19.00000, 14.00000);
   self.weaponmodel = "models/gauntlet.mdl";
   self.th_weapon = gauntlet_select;
   self.last_attack = time;
   self.attack_cnt = 0.00000;
   if ( (self.wfs == WF_LAST_FRAME) ) {

      self.attack_finished = (time - 1.00000);
      gauntlet_twitch ( );

   }
};


void  ()gauntlet_deselect =  {
   self.wfs = advanceweaponframe ( 14.00000, 19.00000);
   self.th_weapon = gauntlet_deselect;
   self.oldweapon = IT_WEAPON1;
   if ( (self.wfs == WF_LAST_FRAME) ) {

      W_SetCurrentAmmo ( );

   }
};


void  ()gauntlet_d =  {
   self.wfs = advanceweaponframe ( 58.00000, 68.00000);
   self.th_weapon = gauntlet_d;
   if ( (self.weaponframe == 59.00000) ) {

      sound ( self, CHAN_WEAPON, "weapons/gaunt1.wav", 1.00000, ATTN_NORM);
   } else {

      if ( (self.weaponframe == 62.00000) ) {

         gauntlet_fire ( 4.00000);

      }

   }
   if ( (self.wfs == WF_LAST_FRAME) ) {

      gauntlet_ready ( );

   }
};


void  ()gauntlet_c =  {
   self.wfs = advanceweaponframe ( 30.00000, 41.00000);
   self.th_weapon = gauntlet_c;
   if ( (self.weaponframe == 32.00000) ) {

      sound ( self, CHAN_WEAPON, "weapons/gaunt1.wav", 1.00000, ATTN_NORM);
   } else {

      if ( (self.weaponframe == 35.00000) ) {

         gauntlet_fire ( 3.00000);

      }

   }
   if ( (self.wfs == WF_LAST_FRAME) ) {

      gauntlet_ready ( );

   }
};


void  ()gauntlet_b =  {
   self.wfs = advanceweaponframe ( 14.00000, 29.00000);
   self.th_weapon = gauntlet_b;
   if ( ((self.weaponframe == 17.00000) || (self.weaponframe == 18.00000)) ) {

		self.weaponframe = 19.00000;

   }
   if ( (self.weaponframe == 19.00000) ) {

      sound ( self, CHAN_WEAPON, "weapons/gaunt1.wav", 1.00000, ATTN_NORM);
   } else {

      if ( (self.weaponframe == 22.00000) ) {

         gauntlet_fire ( 2.00000);

      }

   }
   if ( (self.wfs == WF_LAST_FRAME) ) {

      gauntlet_ready ( );

   }
};


void  ()gauntlet_a =  {
   self.wfs = advanceweaponframe ( 1.00000, 13.00000);
   self.th_weapon = gauntlet_a;
   if ( (self.weaponframe == 2.00000) ) {

      sound ( self, CHAN_WEAPON, "weapons/gaunt1.wav", 1.00000, ATTN_NORM);
   } else {

      if ( (self.weaponframe == 4.00000) ) {

         gauntlet_fire ( 1.00000);

      }

   }
   if ( (self.wfs == WF_LAST_FRAME) ) {

      gauntlet_ready ( );

   }
};


void  ()pal_gauntlet_fire =  {
   if ( (self.attack_cnt < 1.00000) ) {

      gauntlet_a ( );
   } else {

      if ( (self.attack_cnt < 2.00000) ) {

         gauntlet_b ( );
      } else {

         if ( (self.attack_cnt < 3.00000) ) {

            gauntlet_c ( );
         } else {

            if ( (self.attack_cnt < 4.00000) ) {

               gauntlet_d ( );
               self.attack_cnt = -1.00000;

            }

         }

      }

   }
   self.attack_cnt += 1.00000;
   self.attack_finished = (time + 0.50000);
};


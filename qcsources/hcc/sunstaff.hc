
void  (vector dir,float ofs)FireSunstaff =  {
local vector org1 = '0.00000 0.00000 0.00000';
local vector org2 = '0.00000 0.00000 0.00000';
local vector vec = '0.00000 0.00000 0.00000';
local vector endspot = '0.00000 0.00000 0.00000';
local vector endplane = '0.00000 0.00000 0.00000';
local float remainder = 0.00000;
local float reflect_count = 0.00000;
local float damg = 0.00000;
   if ( (self.attack_finished > time) ) {

      return ;

   }
   if ( (self.t_width < time) ) {

      sound ( self, CHAN_WEAPON, "crusader/sunhum.wav", 1.00000, ATTN_NORM);
      self.t_width = (time + 0.20000);

   }
   self.effects |= EF_BRIGHTLIGHT;
   if ( ((self.artifact_active & ART_TOMEOFPOWER) && !ofs) ) {

      damg = 17.00000;
   } else {

      damg = 7.00000;

   }
   if ( !ofs ) {

      remainder = 1000.00000;
   } else {

      remainder = 750.00000;

   }
   makevectors ( self.v_angle);
   org1 = ((self.origin + self.proj_ofs) + (v_forward * 7.00000));
   org2 = (org1 + (dir * 20.00000));
   vec = (org2 + (dir * remainder));
   traceline ( org2, vec, TRUE, self);
   endspot = trace_endpos;
   endplane = trace_plane_normal;
   remainder -= (remainder * trace_fraction);
   WriteByte ( MSG_BROADCAST, SVC_TEMPENTITY);
   WriteByte ( MSG_BROADCAST, TE_STREAM_SUNSTAFF1);
   WriteEntity ( MSG_BROADCAST, self);
   WriteByte ( MSG_BROADCAST, (ofs + STREAM_ATTACHED));
   WriteByte ( MSG_BROADCAST, 2.00000);
   WriteCoord ( MSG_BROADCAST, org2_x);
   WriteCoord ( MSG_BROADCAST, org2_y);
   WriteCoord ( MSG_BROADCAST, org2_z);
   WriteCoord ( MSG_BROADCAST, trace_endpos_x);
   WriteCoord ( MSG_BROADCAST, trace_endpos_y);
   WriteCoord ( MSG_BROADCAST, trace_endpos_z);
   LightningDamage ( (org1 - (v_forward * 7.00000)), (trace_endpos + (normalize ( dir) * 7.00000)), self, damg, "sunbeam");
   while ( ((remainder > 0.00000) && (reflect_count < 2.00000)) ) {

      org1 = endspot;
      dir += (2.00000 * endplane);
      vec = (org1 + (normalize ( dir) * remainder));
      traceline ( org1, vec, TRUE, self);
      endspot = trace_endpos;
      endplane = trace_plane_normal;
      remainder -= (remainder * trace_fraction);
      reflect_count += 1.00000;
      WriteByte ( MSG_BROADCAST, SVC_TEMPENTITY);
      WriteByte ( MSG_BROADCAST, TE_STREAM_SUNSTAFF1);
      WriteEntity ( MSG_BROADCAST, self);
      WriteByte ( MSG_BROADCAST, (ofs + reflect_count));
      WriteByte ( MSG_BROADCAST, 2.00000);
      WriteCoord ( MSG_BROADCAST, org1_x);
      WriteCoord ( MSG_BROADCAST, org1_y);
      WriteCoord ( MSG_BROADCAST, org1_z);
      WriteCoord ( MSG_BROADCAST, trace_endpos_x);
      WriteCoord ( MSG_BROADCAST, trace_endpos_y);
      WriteCoord ( MSG_BROADCAST, trace_endpos_z);
      LightningDamage ( org1, (trace_endpos + (normalize ( dir) * 7.00000)), self, (damg / 2.00000), "sunbeam");

   }
};


void  ()FireSunstaffPower =  {
local vector dir1 = '0.00000 0.00000 0.00000';
local vector dir2 = '0.00000 0.00000 0.00000';
   makevectors ( self.v_angle);
   dir1 = ((v_forward + v_right) * 0.50000);
   dir2 = ((v_forward + (v_right * -1.00000)) * 0.50000);
   FireSunstaff ( normalize ( v_forward), 0.00000);
   FireSunstaff ( dir1, 4.00000);
   FireSunstaff ( dir2, 8.00000);
};

void  ()sunstaff_ready_loop;
void  ()Cru_Sun_Fire;

void  ()sunstaff_fire_settle =  {
   self.wfs = advanceweaponframe ( 59.00000, 63.00000);
   self.th_weapon = sunstaff_fire_settle;
   if ( (self.wfs == WF_CYCLE_WRAPPED) ) {

      self.effects ^= EF_BRIGHTLIGHT;
      self.last_attack = time;
      sunstaff_ready_loop ( );

   }
};


void  ()sunstaff_fire_loop =  {
   self.wfs = advanceweaponframe ( 0.00000, 9.00000);
   self.th_weapon = sunstaff_fire_loop;
   if ( ((((self.attack_finished <= time) && self.button0) && (self.greenmana >= 2.00000)) && (self.bluemana >= 2.00000)) ) {

      if ( (self.artifact_active & ART_TOMEOFPOWER) ) {

         FireSunstaffPower ( );
         self.greenmana -= 2.00000;
         self.bluemana -= 2.00000;
      } else {

         makevectors ( self.v_angle);
         FireSunstaff ( v_forward, 0.00000);
         self.greenmana -= 0.35000;
         self.bluemana -= 0.35000;

      }
      self.attack_finished = (time + 0.05000);

   }
   if ( ((self.wfs == WF_CYCLE_WRAPPED) && ((!self.button0 || (self.greenmana < 2.00000)) || (self.bluemana < 2.00000))) ) {

      self.effects ^= EF_BRIGHTLIGHT;
      sunstaff_fire_settle ( );

   }
};


void  ()sunstaff_fire =  {
   self.wfs = advanceweaponframe ( 10.00000, 13.00000);
   self.th_weapon = sunstaff_fire;
   if ( (self.wfs == WF_CYCLE_WRAPPED) ) {

      sunstaff_fire_loop ( );

   }
};


void  ()Cru_Sun_Fire =  {
   if ( ((self.weaponframe < 14.00000) || (self.weaponframe > 44.00000)) ) {

      return ;

   }
   sound ( self, CHAN_AUTO, "crusader/sunstart.wav", 1.00000, ATTN_NORM);
   self.th_weapon = sunstaff_fire;
   AdvanceThinkTime(self,0.00000);
};


void  ()sunstaff_ready_loop =  {
   self.wfs = advanceweaponframe ( 14.00000, 44.00000);
   self.th_weapon = sunstaff_ready_loop;
};


void  ()sunstaff_select =  {
   self.wfs = advanceweaponframe ( 45.00000, 58.00000);
   self.weaponmodel = "models/sunstaff.mdl";
   self.th_weapon = sunstaff_select;
   self.last_attack = time;
   if ( (self.wfs == WF_CYCLE_WRAPPED) ) {

      self.attack_finished = (time - 1.00000);
      sunstaff_ready_loop ( );

   }
};


void  ()sunstaff_deselect =  {
   self.wfs = advanceweaponframe ( 58.00000, 45.00000);
   self.th_weapon = sunstaff_deselect;
   if ( (self.wfs == WF_CYCLE_WRAPPED) ) {

      W_SetCurrentAmmo ( );

   }
};


float AXE_DAMAGE   =  24.00000;
float AXE_ADD_DAMAGE   =  6.00000;
void  ()T_PhaseMissileTouch;

void  ()axeblade_gone =  {
   sound ( self, CHAN_VOICE, "misc/null.wav", 1.00000, ATTN_NORM);
   sound ( self, CHAN_WEAPON, "misc/null.wav", 1.00000, ATTN_NORM);
   if ( (self.skin == 0.00000) ) {

      CreateLittleWhiteFlash ( self.origin);
   } else {

      CreateLittleBlueFlash ( self.origin);

   }
   remove ( self.goalentity);
   remove ( self);
};


void  ()axeblade_run =  {
   AdvanceFrame( 0.00000, 5.00000);
   if ( (self.lifetime < time) ) {

      axeblade_gone ( );

   }
};


void  ()axetail_run =  {
   self.origin = self.owner.origin;
   self.velocity = self.owner.velocity;
   self.owner.angles = vectoangles ( self.velocity);
   self.angles = self.owner.angles;
   self.origin = self.owner.origin;
};


void  (entity axeblade)launch_axtail =  {
local entity tail;
   tail = spawn ( );
   tail.movetype = MOVETYPE_NOCLIP;
   tail.solid = SOLID_NOT;
   tail.classname = "ax_tail";
   setmodel ( tail, "models/axtail.mdl");
   setsize ( tail, '0.00000 0.00000 0.00000', '0.00000 0.00000 0.00000');
   tail.drawflags |= DRF_TRANSLUCENT;
   tail.owner = axeblade;
   tail.origin = tail.owner.origin;
   tail.velocity = tail.owner.velocity;
   tail.angles = tail.owner.angles;
   axeblade.goalentity = tail;
};


void  (vector dir_mod,vector angle_mod)launch_axe =  {
local entity missile;
   self.attack_finished = (time + 0.40000);
   missile = spawn ( );
   CreateEntityNew ( missile, ENT_AXE_BLADE, "models/axblade.mdl", SUB_Null);
   missile.owner = self;
   missile.classname = "ax_blade";
   makevectors ( (self.v_angle + dir_mod));
   missile.velocity = normalize ( v_forward);
   missile.velocity = (missile.velocity * 900.00000);
   missile.touch = T_PhaseMissileTouch;
   missile.angles = vectoangles ( missile.velocity);
   missile.angles += angle_mod;
   missile.counter = 4.00000;
   missile.cnt = 0.00000;
   missile.lifetime = (time + 2.00000);
   setorigin ( missile, (((self.origin + self.proj_ofs) + (v_forward * 10.00000)) + (v_right * 1.00000)));
   if ( (self.artifact_active & ART_TOMEOFPOWER) ) {

      missile.frags = TRUE;
      missile.classname = "powerupaxeblade";
      missile.skin = 1.00000;
      missile.drawflags = ((self.drawflags & MLS_MASKOUT) | MLS_POWERMODE);
   } else {

      missile.classname = "axeblade";

   }
   missile.lifetime = (time + 2.00000);
   AdvanceThinkTime(missile,HX_FRAME_TIME);
   missile.think = axeblade_run;
   launch_axtail ( missile);
};


void  ()axeblade_fire =  {
   if ( ((self.artifact_active & ART_TOMEOFPOWER) && (self.greenmana >= 8.00000)) ) {

      FireMelee ( 50.00000, 25.00000, 64.00000);
      sound ( self, CHAN_WEAPON, "paladin/axgenpr.wav", 1.00000, ATTN_NORM);
      launch_axe ( '0.00000 0.00000 0.00000', '0.00000 0.00000 0.00000');
      launch_axe ( '0.00000 5.00000 0.00000', '0.00000 0.00000 0.00000');
      launch_axe ( '0.00000 -5.00000 0.00000', '0.00000 0.00000 0.00000');
      self.greenmana -= 8.00000;
   } else {

      if ( (self.greenmana >= 2.00000) ) {

         FireMelee ( WEAPON1_BASE_DAMAGE, WEAPON1_ADD_DAMAGE, 64.00000);
         if ( (self.greenmana >= 2.00000) ) {

            sound ( self, CHAN_WEAPON, "paladin/axgen.wav", 1.00000, ATTN_NORM);
            launch_axe ( '0.00000 0.00000 0.00000', '0.00000 0.00000 300.00000');
            self.greenmana -= 2.00000;

         }

      }

   }
};


void  ()axe_ready =  {
   self.th_weapon = axe_ready;
   self.weaponframe = 0.00000;
};


void  ()axe_select =  {
   self.wfs = advanceweaponframe ( 14.00000, 3.00000);
   if ( (self.weaponframe == 11.00000) ) {

      sound ( self, CHAN_WEAPON, "weapons/vorpswng.wav", 1.00000, ATTN_NORM);

   }
   self.weaponmodel = "models/axe.mdl";
   self.th_weapon = axe_select;
   self.last_attack = time;
   if ( (self.wfs == WF_LAST_FRAME) ) {

      self.attack_finished = (time - 1.00000);
      axe_ready ( );

   }
};


void  ()axe_deselect =  {
   self.wfs = advanceweaponframe ( 14.00000, 3.00000);
   self.th_weapon = axe_deselect;
   self.oldweapon = IT_WEAPON3;
   if ( (self.wfs == WF_LAST_FRAME) ) {

      W_SetCurrentAmmo ( );

   }
};


void  ()axe_a =  {
   self.wfs = advanceweaponframe ( 1.00000, 18.00000);
   self.th_weapon = axe_a;
   if ( ((self.weaponframe >= 2.00000) && (self.weaponframe <= 4.00000)) ) {

      self.weaponframe += 1.00000;
   } else {

      if ( ((self.weaponframe >= 6.00000) && (self.weaponframe <= 7.00000)) ) {

         self.weaponframe += 1.00000;

      }

   }
   if ( (self.weaponframe == 12.00000) ) {

      sound ( self, CHAN_WEAPON, "weapons/vorpswng.wav", 1.00000, ATTN_NORM);
      axeblade_fire ( );

   }
   if ( (self.wfs == WF_LAST_FRAME) ) {

      axe_ready ( );

   }
};


void  ()pal_axe_fire =  {
   axe_a ( );
   if ( (self.artifact_active & ART_TOMEOFPOWER) ) {

      self.attack_finished = (time + 0.70000);
   } else {

      self.attack_finished = (time + 0.35000);

   }
};


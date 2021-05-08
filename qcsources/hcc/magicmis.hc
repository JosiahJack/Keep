
void  ()chain_remove =  {
   if ( (self.movechain.movechain != world) ) {

      remove ( self.movechain.movechain);

   }
   if ( (self.movechain != world) ) {

      remove ( self.movechain);

   }
   remove ( self);
};


void  ()MagicMissileTouch =  {
   if ( ((other.classname == self.classname) && (other.owner == self.owner)) ) {

      return ;

   }
   if ( (self.movechain.movechain != world) ) {

      remove ( self.movechain.movechain);

   }
   if ( (self.movechain != world) ) {

      remove ( self.movechain);

   }
   self.level = FALSE;
   if ( other.takedamage ) {

      T_Damage ( other, self, self.owner, self.dmg);

   }
   T_RadiusDamage ( self, self.owner, self.dmg, other);
   sound ( self, CHAN_AUTO, "weapons/explode.wav", 1.00000, ATTN_NORM);
   starteffect ( CE_MAGIC_MISSILE_EXPLOSION, (self.origin - (self.movedir * 8.00000)), 0.05000);
   remove ( self);
};


void  ()TorpedoTrail =  {
   particle4 ( self.origin, 7.00000, random(148.00000,159.00000), PARTICLETYPE_GRAV, random(10.00000,20.00000));
};


void  ()StarTwinkle =  {
   if ( !self.owner.level ) {

      remove ( self);

   }
   if ( (self.owner.owner.classname != "monster_eidolon") ) {

      if ( !self.aflag ) {

         self.scale += 0.05000;
         if ( (self.scale >= 1.00000) ) {

            self.aflag = TRUE;

         }
      } else {

         self.scale -= 0.05000;
         if ( (self.scale <= 0.01000) ) {

            self.aflag = FALSE;

         }

      }

   }
   if ( (random() < 0.30000) ) {

      TorpedoTrail ( );

   }
   self.think = StarTwinkle;
   AdvanceThinkTime(self,0.05000);
};


void  (float offset)FireMagicMissile =  {
local entity star1;
local entity star2;
local vector spread = '0.00000 0.00000 0.00000';
   if ( (self.classname == "monster_eidolon") ) {

      v_forward = self.v_angle;
   } else {

      makevectors ( self.v_angle);

   }
   self.effects |= EF_MUZZLEFLASH;
   newmis = spawn ( );
   newmis.classname = "magic missile";
   newmis.owner = self;
   newmis.drawflags |= SCALE_ORIGIN_CENTER;
   newmis.movetype = MOVETYPE_FLYMISSILE;
   newmis.solid = SOLID_BBOX;
   newmis.touch = MagicMissileTouch;
   newmis.dmg = random(20.00000,25.00000);
   newmis.speed = 1000.00000;
   spread = (normalize ( v_right) * (offset * 25.00000));
   newmis.velocity = ((normalize ( v_forward) * newmis.speed) + spread);
   newmis.movedir = normalize ( newmis.velocity);
   newmis.avelocity_z = random(300.00000,600.00000);
   newmis.level = TRUE;
   setmodel ( newmis, "models/ball.mdl");
   setsize ( newmis, '0.00000 0.00000 0.00000', '0.00000 0.00000 0.00000');
   if ( (self.classname == "monster_eidolon") ) {

      newmis.scale = 0.75000;
      setorigin ( newmis, (((self.origin + self.proj_ofs) + (v_forward * 48.00000)) + (v_right * 20.00000)));
      sound ( self, CHAN_AUTO, "eidolon/spell.wav", 1.00000, ATTN_NORM);
   } else {

      newmis.scale = 0.50000;
      setorigin ( newmis, ((((self.origin + self.proj_ofs) + (v_forward * 8.00000)) + (v_right * 7.00000)) + '0.00000 0.00000 5.00000'));
      sound ( newmis, CHAN_AUTO, "necro/mmfire.wav", 1.00000, ATTN_NORM);

   }
   if ( (self.artifact_active & ART_TOMEOFPOWER) ) {

      if ( (self.classname == "monster_eidolon") ) {

         newmis.enemy = self.enemy;
         newmis.classname = "eidolon spell";
         newmis.turn_time = 3.00000;
         newmis.dmg = random(30.00000,40.00000);
      } else {

         newmis.turn_time = 2.00000;
         newmis.dmg = random(45.00000,55.00000);

      }
      newmis.effects = EF_DIMLIGHT;
      newmis.frags = TRUE;
      newmis.dmg = random(30.00000,40.00000);
      newmis.veer = 100.00000;
      newmis.homerate = 0.10000;
      newmis.turn_time = 3.00000;
      newmis.lifetime = (time + 5.00000);
      newmis.th_die = chain_remove;
      newmis.think = HomeThink;
      newmis.hoverz = TRUE;
      AdvanceThinkTime(newmis,0.20000);
   } else {

      newmis.think = chain_remove;
      AdvanceThinkTime(newmis,3.00000);

   }
   star1 = spawn ( );
   newmis.movechain = star1;
   star1.drawflags |= MLS_ABSLIGHT;
   star1.abslight = 0.50000;
   star1.avelocity_z = 400.00000;
   star1.avelocity_y = 300.00000;
   star1.angles_y = 90.00000;
   if ( (self.classname == "monster_eidolon") ) {

      setmodel ( star1, "models/glowball.mdl");
   } else {

      setmodel ( star1, "models/star.mdl");
      star1.scale = 0.30000;

   }
   setorigin ( star1, newmis.origin);
   star2 = spawn ( );
   if ( (self.classname != "monster_eidolon") ) {

      star1.movechain = star2;
      star2.drawflags |= MLS_ABSLIGHT;
      star2.abslight = 0.50000;
      star2.avelocity_z = -400.00000;
      star2.avelocity_y = -300.00000;
      star2.scale = 0.30000;
      setmodel ( star2, "models/star.mdl");
      setorigin ( star2, newmis.origin);

   }
   star2.movetype = MOVETYPE_NOCLIP;
   star1.movetype = MOVETYPE_NOCLIP;
   star2.owner = newmis;
   star1.owner = newmis;
   star2.think = StarTwinkle;
   star1.think = StarTwinkle;
   AdvanceThinkTime(star1,0.00000);
   AdvanceThinkTime(star2,0.00000);
};


void  ()flash_think =  {
   makevectors ( self.owner.v_angle);
   self.angles_x = (self.owner.v_angle_x * -1.00000);
   self.angles_y = self.owner.v_angle_y;
   setorigin ( self, ((((self.owner.origin + self.owner.proj_ofs) + '0.00000 0.00000 5.00000') + (v_right * 2.00000)) + (v_forward * 6.00000)));
   AdvanceThinkTime(self,0.01000);
   self.abslight -= 0.05000;
   self.scale += 0.05000;
   if ( ((self.lifetime < time) || (self.abslight <= 0.05000)) ) {

      remove ( self);

   }
};


void  ()FireFlash =  {
   makevectors ( self.v_angle);
   newmis = spawn ( );
   newmis.movetype = MOVETYPE_NOCLIP;
   newmis.owner = self;
   newmis.abslight = 0.50000;
   newmis.scale = random(0.80000,1.20000);
   newmis.drawflags |= (MLS_ABSLIGHT | DRF_TRANSLUCENT);
   setmodel ( newmis, "models/handfx.mdl");
   setorigin ( newmis, ((((self.origin + self.proj_ofs) + '0.00000 0.00000 5.00000') + (v_right * 2.00000)) + (v_forward * 6.00000)));
   newmis.angles = self.v_angle;
   newmis.angles_x = (self.v_angle_x * -1.00000);
   newmis.angles_z = random(360.00000);
   newmis.avelocity_z = random(360.00000,720.00000);
   newmis.lifetime = (time + 0.07500);
   newmis.think = flash_think;
   AdvanceThinkTime(newmis,0.00000);
};


void  ()mmis_power =  {
   if ( (self.attack_finished > time) ) {

      return ;

   }
   FireFlash ( );
   FireMagicMissile ( -3.00000);
   FireMagicMissile ( 0.00000);
   FireMagicMissile ( 3.00000);
   self.bluemana -= 10.00000;
   self.attack_finished = (time + 0.70000);
};


void  ()mmis_normal =  {
   if ( (self.attack_finished > time) ) {

      return ;

   }
   FireFlash ( );
   FireMagicMissile ( 0.00000);
   self.bluemana -= 2.00000;
   self.attack_finished = (time + 0.20000);
};

void  ()magicmis_ready;
void  ()Nec_Mis_Attack;

void  ()magicmis_fire =  {
   if ( ((self.button0 && (self.weaponframe == 65.00000)) && !(self.artifact_active & ART_TOMEOFPOWER)) ) {

      self.weaponframe = 65.00000;
   } else {

      self.wfs = advanceweaponframe ( 61.00000, 68.00000);

   }
   self.th_weapon = magicmis_fire;
   self.last_attack = time;
   if ( (((self.wfs == WF_CYCLE_WRAPPED) || (self.bluemana < 2.00000)) || ((self.artifact_active & ART_TOMEOFPOWER) && (self.bluemana < 10.00000))) ) {

      magicmis_ready ( );
   } else {

      if ( (self.weaponframe == 65.00000) ) {

         if ( (self.artifact_active & ART_TOMEOFPOWER) ) {

            mmis_power ( );
         } else {

            mmis_normal ( );

         }

      }

   }
};


void  ()Nec_Mis_Attack =  {
   magicmis_fire ( );
   AdvanceThinkTime(self,0.00000);
};


void  ()magicmis_jellyfingers =  {
   self.wfs = advanceweaponframe ( 69.00000, 90.00000);
   self.th_weapon = magicmis_jellyfingers;
   if ( (self.wfs == WF_CYCLE_WRAPPED) ) {

      magicmis_ready ( );

   }
};


void  ()magicmis_ready =  {
   self.weaponframe = 69.00000;
   if ( (((random() < 0.10000) && (random() < 0.30000)) && (random() < 0.50000)) ) {

      self.th_weapon = magicmis_jellyfingers;
   } else {

      self.th_weapon = magicmis_ready;

   }
};


void  ()magicmis_select =  {
   self.wfs = advanceweaponframe ( 91.00000, 110.00000);
   self.weaponmodel = "models/spllbook.mdl";
   self.th_weapon = magicmis_select;
   if ( (self.wfs == WF_CYCLE_WRAPPED) ) {

      self.attack_finished = (time - 1.00000);
      magicmis_ready ( );

   }
};


void  ()magicmis_deselect =  {
   self.wfs = advanceweaponframe ( 110.00000, 91.00000);
   self.th_weapon = magicmis_deselect;
   if ( (self.wfs == WF_CYCLE_WRAPPED) ) {

      W_SetCurrentAmmo ( );

   }
};


void  ()magicmis_select_from_bone =  {
   self.wfs = advanceweaponframe ( 12.00000, 24.00000);
   self.weaponmodel = "models/spllbook.mdl";
   self.th_weapon = magicmis_select_from_bone;
   if ( (self.wfs == WF_CYCLE_WRAPPED) ) {

      self.attack_finished = (time - 1.00000);
      magicmis_ready ( );

   }
};


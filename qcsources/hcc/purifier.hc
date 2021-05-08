void  ()purifier_ready;

void  ()pmissile_gone =  {
   sound ( self, CHAN_VOICE, "misc/null.wav", 1.00000, ATTN_NORM);
   sound ( self, CHAN_WEAPON, "misc/null.wav", 1.00000, ATTN_NORM);
   remove ( self);
};


void  ()pmissile_touch =  {
local float damg = 0.00000;
   if ( (other == self.owner) ) {

      return ;

   }
   if ( (pointcontents ( self.origin) == CONTENT_SKY) ) {

      pmissile_gone ( );
      return ;

   }
   damg = random(15.00000,25.00000);
   if ( other.health ) {

      T_Damage ( other, self, self.owner, damg);

   }
   sound ( self, CHAN_BODY, "weapons/expsmall.wav", 1.00000, ATTN_NORM);
   self.origin = (self.origin - (8.00000 * normalize ( self.velocity)));
   CreateFireCircle ( (self.origin - (v_forward * 8.00000)));
   self.effects = EF_NODRAW;
   self.solid = SOLID_NOT;
   self.nextthink = (time + 0.50000);
   self.think = pmissile_gone;
};


void  ()smokering_run =  {
   self.scale += 0.12000;
   self.nextthink = ((time + HX_FRAME_TIME) + random(HX_FRAME_TIME));
   self.think = smokering_run;
   if ( ((self.lifetime - time) < 0.30000) ) {

      self.skin = 4.00000;
   } else {

      if ( ((self.lifetime - time) < 0.60000) ) {

         self.skin = 3.00000;
      } else {

         if ( ((self.lifetime - time) < 0.90000) ) {

            self.skin = 2.00000;
         } else {

            if ( ((self.lifetime - time) < 1.20000) ) {

               self.skin = 1.00000;
            } else {

               self.skin = 0.00000;

            }

         }

      }

   }
   if ( (self.lifetime < time) ) {

      remove ( self);

   }
};


void  ()pmissile2_touch =  {
local float damg = 0.00000;
   if ( (other == self.owner) ) {

      return ;

   }
   if ( (pointcontents ( self.origin) == CONTENT_SKY) ) {

      pmissile_gone ( );
      return ;

   }
   damg = random(150.00000,200.00000);
   if ( other.health ) {

      T_Damage ( other, self, self.owner, damg);

   }
   damg = random(120.00000,160.00000);
   T_RadiusDamage ( self, self.owner, damg, other);
   sound ( self, CHAN_BODY, "weapons/exphuge.wav", 1.00000, ATTN_NORM);
   self.origin = (self.origin - (8.00000 * normalize ( self.velocity)));
   self.effects = EF_NODRAW;
   self.solid = SOLID_NOT;
   CreateExplosion29 ( (self.origin - (v_forward * 8.00000)));
   self.nextthink = (time + 0.50000);
   self.think = pmissile_gone;
};


void  ()pmissile2_puff =  {
local entity smokering;
   smokering = spawn ( );
   smokering.owner = self;
   smokering.movetype = MOVETYPE_FLYMISSILE;
   smokering.solid = SOLID_BBOX;
   smokering.classname = "puffring";
   smokering.angles = (self.angles + '0.00000 0.00000 90.00000');
   setmodel ( smokering, "models/ring.mdl");
   setsize ( smokering, '0.00000 0.00000 0.00000', '0.00000 0.00000 0.00000');
   smokering.drawflags |= DRF_TRANSLUCENT;
   smokering.origin = self.origin;
   smokering.velocity_z = 15.00000;
   smokering.nextthink = (time + 0.01000);
   smokering.think = smokering_run;
   smokering.lifetime = (time + 1.20000);
   smokering.drawflags |= SCALE_ORIGIN_CENTER;
   smokering.scale = 1.00000;
   smokering.owner = self;
   self.nextthink = (time + 0.15000);
   self.think = pmissile2_puff;
   if ( (time > (self.lifetime - 1.70000)) ) {

      HomeThink ( );
      self.angles = vectoangles ( self.velocity);

   }
   if ( (self.lifetime < time) ) {

      pmissile_gone ( );

   }
};


void  ()launch_pmissile2 =  {
local entity missile;
   missile = spawn ( );
   missile.owner = self;
   missile.movetype = MOVETYPE_FLYMISSILE;
   missile.solid = SOLID_BBOX;
   missile.frags = TRUE;
   missile.classname = "purimissile";
   makevectors ( self.v_angle);
   missile.velocity = normalize ( v_forward);
   missile.velocity = (missile.velocity * 1000.00000);
   missile.touch = pmissile2_touch;
   missile.angles = vectoangles ( missile.velocity);
   sound ( self, CHAN_VOICE, "paladin/purfireb.wav", 1.00000, ATTN_NORM);
   setmodel ( missile, "models/drgnball.mdl");
   setsize ( missile, '0.00000 0.00000 0.00000', '0.00000 0.00000 0.00000');
   setorigin ( missile, (((self.origin + (v_forward * 10.00000)) + (v_right * 1.00000)) + (v_up * 40.00000)));
   missile.effects = EF_BRIGHTLIGHT;
   missile.nextthink = (time + 0.15000);
   missile.think = pmissile2_puff;
   missile.lifetime = (time + 2.00000);
   missile.veer = FALSE;
   missile.turn_time = 3.00000;
   missile.speed = 1000.00000;
   missile.ideal_yaw = TRUE;
   self.greenmana -= 8.00000;
   self.bluemana -= 8.00000;
};


void  ()purifier_tomefire =  {
   self.wfs = advanceweaponframe ( 16.00000, 24.00000);
   self.th_weapon = purifier_tomefire;
   if ( (self.weaponframe == 17.00000) ) {

      self.punchangle_x = -4.00000;
      launch_pmissile2 ( );
      self.attack_finished = (time + 0.50000);
   } else {

      if ( (self.wfs == WF_CYCLE_WRAPPED) ) {

         purifier_ready ( );

      }

   }
};


void  ()launch_pmissile1 =  {
local entity missile;
   missile = spawn ( );
   missile.owner = self;
   missile.movetype = MOVETYPE_FLYMISSILE;
   missile.solid = SOLID_BBOX;
   missile.classname = "purimissile";
   makevectors ( self.v_angle);
   missile.velocity = normalize ( v_forward);
   missile.velocity = (missile.velocity * 1000.00000);
   missile.touch = pmissile_touch;
   missile.angles = vectoangles ( missile.velocity);
   setmodel ( missile, "models/purfir1.mdl");
   setsize ( missile, '0.00000 0.00000 0.00000', '0.00000 0.00000 0.00000');
   if ( ((self.cnt == 1.00000) || (self.cnt == 3.00000)) ) {

      setorigin ( missile, (((self.origin + self.proj_ofs) + (v_forward * 6.00000)) + (v_right * 10.00000)));
   } else {

      if ( ((self.cnt == 0.00000) || (self.cnt == 2.00000)) ) {

         setorigin ( missile, (((self.origin + self.proj_ofs) + (v_forward * 6.00000)) - (v_right * 10.00000)));

      }

   }
   sound ( self, CHAN_WEAPON, "paladin/purfire.wav", 1.00000, ATTN_NORM);
   self.cnt += 1.00000;
   if ( (self.cnt > 3.00000) ) {

      self.cnt = 0.00000;

   }
   missile.drawflags = MLS_ABSLIGHT;
   missile.abslight = 1.00000;
   missile.nextthink = (time + 2.50000);
   missile.think = pmissile_gone;
   self.greenmana -= 1.00000;
   self.bluemana -= 1.00000;
};


void  ()purifier_rapidfire2R =  {
   self.wfs = advanceweaponframe ( 10.00000, 12.00000);
   self.th_weapon = purifier_rapidfire2R;
   if ( (self.weaponframe == 12.00000) ) {

      self.punchangle_x = random(-3.00000);

   }
   if ( ((self.attack_finished <= time) && self.button0) ) {

      launch_pmissile1 ( );

   }
   if ( (self.wfs == WF_CYCLE_WRAPPED) ) {

      purifier_ready ( );

   }
};


void  ()purifier_rapidfire2L =  {
   self.wfs = advanceweaponframe ( 7.00000, 9.00000);
   self.th_weapon = purifier_rapidfire2L;
   if ( (self.weaponframe == 3.00000) ) {

      self.punchangle_x = random(-3.00000);

   }
   if ( ((self.attack_finished <= time) && self.button0) ) {

      launch_pmissile1 ( );

   }
   if ( (self.wfs == WF_CYCLE_WRAPPED) ) {

      purifier_ready ( );

   }
};


void  ()purifier_rapidfire1R =  {
   self.wfs = advanceweaponframe ( 4.00000, 6.00000);
   self.th_weapon = purifier_rapidfire1R;
   if ( (self.weaponframe == 6.00000) ) {

      self.punchangle_x = random(-3.00000);

   }
   if ( ((self.attack_finished <= time) && self.button0) ) {

      launch_pmissile1 ( );

   }
   if ( (self.wfs == WF_CYCLE_WRAPPED) ) {

      purifier_ready ( );

   }
};


void  ()purifier_rapidfire1L =  {
   self.wfs = advanceweaponframe ( 1.00000, 3.00000);
   self.th_weapon = purifier_rapidfire1L;
   if ( (self.weaponframe == 3.00000) ) {

      self.punchangle_x = random(-3.00000);

   }
   if ( ((self.attack_finished <= time) && self.button0) ) {

      launch_pmissile1 ( );

   }
   if ( (self.wfs == WF_CYCLE_WRAPPED) ) {

      purifier_ready ( );

   }
};


void  ()purifier_rapidfire =  {
   if ( (self.counter == 0.00000) ) {

      purifier_rapidfire1L ( );
   } else {

      if ( (self.counter == 1.00000) ) {

         purifier_rapidfire1R ( );
      } else {

         if ( (self.counter == 2.00000) ) {

            purifier_rapidfire2L ( );
         } else {

            if ( (self.counter == 3.00000) ) {

               purifier_rapidfire2R ( );

            }

         }

      }

   }
   self.counter += 1.00000;
   self.attack_finished = (time + 0.14000);
   if ( (self.counter > 3.00000) ) {

      self.counter = 0.00000;

   }
};


void  ()pal_purifier_fire =  {
   if ( (((self.artifact_active & ART_TOMEOFPOWER) && (self.greenmana >= 8.00000)) && (self.bluemana >= 8.00000)) ) {

      purifier_tomefire ( );
   } else {

      if ( ((self.greenmana >= 2.00000) && (self.bluemana >= 2.00000)) ) {

         purifier_rapidfire ( );

      }

   }
   self.nextthink = time;
};


void  ()purifier_ready =  {
   self.weaponframe = 0.00000;
   self.wfs = 0.00000;
   self.th_weapon = purifier_ready;
};


void  ()purifier_deselect =  {
   self.wfs = advanceweaponframe ( 36.00000, 25.00000);
   self.th_weapon = purifier_deselect;
   self.oldweapon = IT_WEAPON4;
   if ( (self.wfs == WF_LAST_FRAME) ) {

      W_SetCurrentAmmo ( );

   }
};


void  ()purifier_select =  {
   self.wfs = advanceweaponframe ( 25.00000, 36.00000);
   self.weaponmodel = "models/purifier.mdl";
   self.th_weapon = purifier_select;
   self.counter = 0.00000;
   if ( (self.wfs == WF_CYCLE_WRAPPED) ) {

      self.attack_finished = (time - 1.00000);
      purifier_ready ( );

   }
};


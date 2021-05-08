
void  ()grenade_trail =  {
   if ( (self.lifetime < time) ) {

      self.think = self.th_die;
      AdvanceThinkTime(self,0.00000);
   } else {

      particle4 ( self.origin, 0.50000, 284.00000, PARTICLETYPE_SLOWGRAV, 3.00000);
      AdvanceThinkTime(self,0.05000);

   }
};


void  ()ThrowMiniGrenade =  {
local entity missile;
   self.greenmana -= 3.00000;
   makevectors ( self.v_angle);
   sound ( self, CHAN_WEAPON, "misc/whoosh.wav", 1.00000, ATTN_NORM);
   missile = spawn ( );
   missile.owner = self;
   missile.classname = "minigrenade";
   missile.movetype = MOVETYPE_BOUNCE;
   missile.solid = SOLID_BBOX;
   missile.takedamage = DAMAGE_YES;
   missile.health = 3.00000;
   missile.th_die = DarkExplosion;
   missile.touch = GrenadeTouch2;
   missile.dmg = 100.00000;
   missile.lifetime = (time + 2.00000);
   missile.o_angle = (((self.origin + self.proj_ofs) + (v_forward * 8.00000)) + (v_right * 8.00000));
   missile.speed = (500.00000 + (self.weaponframe_cnt * 10.00000));
   if ( self.v_angle_x ) {

      missile.velocity = ((((v_forward * missile.speed) + (v_up * 200.00000)) + ((crandom ( ) * v_right) * 10.00000)) + ((crandom ( ) * v_up) * 10.00000));
   } else {

      missile.velocity = aim ( self, missile.o_angle, 1000.00000);
      missile.velocity = (missile.velocity * missile.speed);
      missile.velocity_z = 200.00000;

   }
   missile.angles = vectoangles ( missile.velocity);
   missile.avelocity = random('-300.00000 -300.00000 -300.00000','300.00000 300.00000 300.00000');
   setmodel ( missile, "models/assgren.mdl");
   missile.scale = 0.77000;
   setsize ( missile, '0.00000 0.00000 0.00000', '0.00000 0.00000 0.00000');
   setorigin ( missile, missile.o_angle);
   missile.think = grenade_trail;
   AdvanceThinkTime(missile,0.00000);
};


void  ()SuperGrenadeExplode =  {
local entity missile;
local float attack_counter = 0.00000;
local float number_explosions = 0.00000;
   attack_counter = 0.00000;
   number_explosions = rint ( random(3.00000,6.00000));
   while ( (attack_counter < number_explosions) ) {

      attack_counter += 1.00000;
      missile = spawn_temp ( );
      missile.owner = self.owner;
      missile.classname = "minigrenade";
      if ( (self.classname == "multigrenade") ) {

         missile.controller = self;
         if ( self.cnt ) {

            self.cnt = FALSE;
         } else {

            self.cnt = TRUE;

         }

      }
      if ( (((self.classname == "multigrenade") && self.cnt) || ((self.classname != "multigrenade") && (self.movetype == MOVETYPE_BOUNCE))) ) {

         missile.movetype = MOVETYPE_BOUNCE;
         missile.velocity_x = random(-300.00000,300.00000);
         missile.velocity_y = random(-300.00000,300.00000);
         missile.velocity_z = random(50.00000,150.00000);
      } else {

         missile.movetype = MOVETYPE_FLYMISSILE;
         missile.velocity_x = random(-40.00000,40.00000);
         missile.velocity_y = random(-40.00000,40.00000);
         missile.velocity_z = random(150.00000,300.00000);

      }
      self.dmg = (self.dmg * (0.70000 + random(0.20000)));
      missile.dmg = (self.dmg * (0.70000 + random(0.20000)));
      if ( (missile.dmg < 70.00000) ) {

         missile.dmg = 70.00000;

      }
      missile.solid = SOLID_NOT;
      setmodel ( missile, "models/null.spr");
      setsize ( missile, '0.00000 0.00000 0.00000', '0.00000 0.00000 0.00000');
      setorigin ( missile, self.origin);
      if ( (missile.dmg > 70.00000) ) {

         missile.think = SuperGrenadeExplode;
      } else {

         missile.think = DarkExplosion;

      }
      AdvanceThinkTime(missile,random(0.10000,0.60000));

   }
   self.dmg *= 2.00000;
   if ( (self.classname == "multigrenade") ) {

      if ( (random() < 0.30000) ) {

         MonsterQuake ( 200.00000);

      }
      MultiExplode ( );
   } else {

      DarkExplosion ( );

   }
};


void  ()ThrowMultiGrenade =  {
local entity missile;
   makevectors ( self.v_angle);
   self.greenmana -= 12.00000;
   sound ( self, CHAN_WEAPON, "misc/whoosh.wav", 1.00000, ATTN_NORM);
   missile = spawn ( );
   missile.frags = TRUE;
   missile.owner = self;
   missile.classname = "multigrenade";
   missile.movetype = MOVETYPE_BOUNCE;
   missile.solid = SOLID_BBOX;
   missile.takedamage = DAMAGE_YES;
   missile.health = 3.00000;
   missile.th_die = SuperGrenadeExplode;
   missile.touch = GrenadeTouch2;
   missile.dmg = 250.00000;
   missile.o_angle = (((self.origin + self.proj_ofs) + (v_forward * 8.00000)) + (v_right * 8.00000));
   missile.speed = (500.00000 + (self.weaponframe_cnt * 10.00000));
   if ( self.v_angle_x ) {

      missile.velocity = ((((v_forward * missile.speed) + (v_up * 200.00000)) + ((crandom ( ) * v_right) * 10.00000)) + ((crandom ( ) * v_up) * 10.00000));
   } else {

      missile.velocity = aim ( self, missile.o_angle, 1000.00000);
      missile.velocity = (missile.velocity * missile.speed);
      missile.velocity_z = 200.00000;

   }
   missile.angles = vectoangles ( missile.velocity);
   missile.avelocity = random('-300.00000 -300.00000 -300.00000','300.00000 300.00000 300.00000');
   setmodel ( missile, "models/assgren.mdl");
   missile.scale = 2.00000;
   setsize ( missile, '0.00000 0.00000 0.00000', '0.00000 0.00000 0.00000');
   setorigin ( missile, missile.o_angle);
   missile.lifetime = (time + 2.00000);
   missile.think = grenade_trail;
   AdvanceThinkTime(missile,0.00000);
};

void  ()grenade_select;
void  ()grenade_throw;

void  ()grenade_idle =  {
   self.th_weapon = grenade_idle;
   self.weaponframe = 6.00000;
};


void  ()grenade_reload =  {
   self.th_weapon = grenade_reload;
   self.wfs = advanceweaponframe ( 0.00000, 5.00000);
   self.weaponmodel = "models/v_assgr.mdl";
   if ( (self.wfs == WF_CYCLE_WRAPPED) ) {

      grenade_idle ( );

   }
};


void  ()grenade_throw =  {
   self.th_weapon = grenade_throw;
   self.wfs = advanceweaponframe ( 7.00000, 18.00000);
   if ( (self.button0 && (self.weaponframe == 11.00000)) ) {

      self.weaponframe = 10.00000;
      if ( (self.weaponframe_cnt < 50.00000) ) {

         self.weaponframe_cnt += 1.00000;

      }
   } else {

      if ( (self.weaponframe == 16.00000) ) {

         if ( (self.artifact_active & ART_TOMEOFPOWER) ) {

            ThrowMultiGrenade ( );
            self.attack_finished = (time + 2.00000);
         } else {

            ThrowMiniGrenade ( );
            self.attack_finished = (time + 0.30000);

         }
         self.weaponframe_cnt = 0.00000;
      } else {

         if ( (self.wfs == WF_CYCLE_WRAPPED) ) {

            grenade_reload ( );

         }

      }

   }
};


void  ()grenade_select =  {
   self.th_weapon = grenade_select;
   self.wfs = advanceweaponframe ( 0.00000, 5.00000);
   self.weaponmodel = "models/v_assgr.mdl";
   if ( (self.wfs == WF_CYCLE_WRAPPED) ) {

      self.attack_finished = (time - 1.00000);
      grenade_idle ( );

   }
};


void  ()grenade_deselect =  {
   self.th_weapon = grenade_deselect;
   self.wfs = advanceweaponframe ( 5.00000, 0.00000);
   if ( (self.wfs == WF_CYCLE_WRAPPED) ) {

      W_SetCurrentAmmo ( );

   }
};


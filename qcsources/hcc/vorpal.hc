float VORP_BASE_DAMAGE   =  15.00000;
float VORP_ADD_DAMAGE   =  15.00000;
float VORP_PWR_BASE_DAMAGE   =  50.00000;
float VORP_PWR_ADD_DAMAGE   =  30.00000;
float VORP_RADIUS   =  150.00000;
float VORP_PUSH   =  5.00000;

void  ()missile_gone =  {
   sound ( self, CHAN_VOICE, "misc/null.wav", 1.00000, ATTN_NORM);
   sound ( self, CHAN_WEAPON, "misc/null.wav", 1.00000, ATTN_NORM);
   remove ( self);
};


void  ()vshock2_run =  {
   self.effects ^= EF_NODRAW;
   if ( (self.skin == 0.00000) ) {

      self.skin = 1.00000;
      self.scale = random(0.80000,1.40000);
   } else {

      self.skin = 0.00000;
      self.scale = random(0.80000,1.40000);

   }
   self.think = vshock2_run;
   AdvanceThinkTime(self,HX_FRAME_TIME);
   if ( (self.lifetime < time) ) {

      remove ( self);

   }
};


void  ()vshock2_start =  {
local vector holdangle = '0.00000 0.00000 0.00000';
   makevectors ( self.angles);
   holdangle = self.angles;
   holdangle_x += 90.00000;
   holdangle_y = random(0.00000,360.00000);
   makevectors ( holdangle);
   self.velocity = normalize ( v_forward);
   self.velocity = (self.velocity * 80.00000);
   self.angles = holdangle;
   self.lifetime = (time + 0.75000);
   self.think = vshock2_run;
   AdvanceThinkTime(self,(HX_FRAME_TIME + random(0.10000,0.25000)));
};


void  (float dir)vorp_shock2 =  {
local entity newent;
   newent = spawn ( );
   newent.owner = self.owner;
   newent.movetype = MOVETYPE_NOCLIP;
   newent.solid = SOLID_NOT;
   newent.drawflags = MLS_ABSLIGHT;
   newent.abslight = 0.50000;
   setorigin ( newent, self.origin);
   setmodel ( newent, "models/vorpshk2.mdl");
   setsize ( newent, '0.00000 0.00000 0.00000', '0.00000 0.00000 0.00000');
   newent.effects |= EF_NODRAW;
   newent.think = vshock2_start;
   newent.nextthink = (time + random(0.15000,0.50000));
   newent.scale = 1.00000;
   newent.count = dir;
   newent.angles = self.angles;
};


void  ()vshock_end =  {
   if ( (self.skin == 0.00000) ) {

      self.skin = 1.00000;
   } else {

      self.skin = 0.00000;

   }
   self.scale -= 0.25000;
   if ( (self.scale <= 0.00000) ) {

      remove ( self);

   }
   self.think = vshock_end;
   AdvanceThinkTime(self,HX_FRAME_TIME);
};


void  ()vshock_run =  {
local float damg = 0.00000;
local float shock_cnt = 0.00000;
   if ( (self.skin == 0.00000) ) {

      self.skin = 1.00000;
      self.scale = random(0.80000,1.40000);
   } else {

      self.skin = 0.00000;
      self.scale = random(0.80000,1.40000);

   }
   if ( self.enemy.health ) {

      if ( (self.classname == "vorpalhalfshock") ) {

         damg = 2.50000;
      } else {

         damg = 5.00000;

      }
      T_Damage ( self.enemy, self, self.owner, damg);

   }
   self.think = vshock_run;
   AdvanceThinkTime(self,HX_FRAME_TIME);
   if ( (self.lifetime < time) ) {

      shock_cnt = random(0.00000,4.00000);
      shock_cnt = 1.00000;
      if ( (shock_cnt > 0.00000) ) {

         vorp_shock2 ( 0.00000);

      }
      if ( (shock_cnt > 1.00000) ) {

         vorp_shock2 ( 1.00000);

      }
      if ( (shock_cnt > 2.00000) ) {

         vorp_shock2 ( 0.00000);

      }
      if ( (shock_cnt > 3.00000) ) {

         vorp_shock2 ( 1.00000);

      }
      vshock_end ( );

   }
};


void  (entity victim)vorp_shock =  {
local entity newent;
local vector org = '0.00000 0.00000 0.00000';
   org = (self.origin - (8.00000 * normalize ( self.velocity)));
   self.angles_y += 180.00000;
   makevectors ( self.angles);
   traceline ( org, (org + (v_forward * 16.00000)), FALSE, self);
   if ( (other.classname == "worldspawn") ) {

      self.angles = vectoangles ( trace_plane_normal);

   }
   newent = spawn ( );
   setorigin ( newent, org);
   setmodel ( newent, "models/vorpshok.mdl");
   setsize ( newent, '0.00000 0.00000 0.00000', '0.00000 0.00000 0.00000');
   newent.owner = self.owner;
   newent.movetype = MOVETYPE_NONE;
   newent.solid = SOLID_NOT;
   newent.angles = self.angles;
   newent.enemy = victim;
   if ( (self.classname == "halfvorpmissile") ) {

      newent.classname = "vorpalhalfshock";
   } else {

      newent.classname = "vorpalshock";

   }
   newent.drawflags = MLS_ABSLIGHT;
   newent.abslight = 0.50000;
   newent.think = vshock_run;
   AdvanceThinkTime(newent,HX_FRAME_TIME);
   newent.lifetime = (time + 0.50000);
   newent.scale = 1.00000;
};


void  ()vorpmissile_touch =  {
local float damg = 0.00000;
   if ( (other == self.owner) ) {

      return ;

   }
   if ( (pointcontents ( self.origin) == CONTENT_SKY) ) {

      missile_gone ( );
      return ;

   }
   damg = random(30.00000,60.00000);
   if ( (self.classname == "halfvorpmissile") ) {

      damg = (damg * 0.50000);

   }
   if ( other.health ) {

      T_Damage ( other, self, self.owner, damg);

   }
   sound ( self, CHAN_WEAPON, "weapons/explode.wav", 1.00000, ATTN_NORM);
   vorp_shock ( other);
   missile_gone ( );
};


void  ()vorpmissile_run =  {
   AdvanceFrame( 16.00000, 29.00000);
   if ( (self.skin == 0.00000) ) {

      self.skin = 1.00000;
   } else {

      if ( (self.skin == 1.00000) ) {

         self.skin = 0.00000;

      }

   }
   if ( (self.scale < 2.40000) ) {

      self.scale += 0.20000;

   }
   if ( (self.scale > 2.40000) ) {

      self.scale = 2.40000;

   }
};


void  ()vorpmissile_birth =  {
   AdvanceFrame( 0.00000, 15.00000);
   if ( (self.skin == 0.00000) ) {

      self.skin = 1.00000;
   } else {

      if ( (self.skin == 1.00000) ) {

         self.skin = 0.00000;

      }

   }
   self.frame += 2.00000;
   if ( (self.scale < 2.40000) ) {

      self.scale += 0.15000;

   }
   if ( (self.scale > 2.40000) ) {

      self.scale = 2.40000;

   }
   if ( (self.frame >= 14.00000) ) {

      vorpmissile_run ( );

   }
};


void  ()launch_vorpal_missile =  {
local entity missile;
   missile = spawn ( );
   CreateEntityNew ( missile, ENT_VORP_MISSILE, "models/vorpshot.mdl", SUB_Null);
   missile.owner = self;
   missile.classname = "vorpalmissile";
   makevectors ( self.v_angle);
   missile.velocity = normalize ( v_forward);
   missile.velocity = (missile.velocity * 1000.00000);
   missile.frags = TRUE;
   missile.touch = vorpmissile_touch;
   missile.angles = vectoangles ( missile.velocity);
   missile.angles_x += 180.00000;
   missile.drawflags = MLS_ABSLIGHT;
   missile.abslight = 0.50000;
   setorigin ( missile, (self.origin + (v_up * 40.00000)));
   missile.scale = 0.50000;
   if ( (self.bluemana < 4.00000) ) {

      missile.classname = "halfvorpmissile";

   }
   AdvanceThinkTime(missile,HX_FRAME_TIME);
   missile.think = vorpmissile_birth;
   missile.lifetime = (time + 2.00000);
};


void  ()vorpal_melee =  {
local vector source = '0.00000 0.00000 0.00000';
local vector org = '0.00000 0.00000 0.00000';
local vector dir = '0.00000 0.00000 0.00000';
local float damg = 0.00000;
local float no_flash = 0.00000;
local float inertia = 0.00000;
   makevectors ( self.v_angle);
   source = (self.origin + self.proj_ofs);
   traceline ( source, (source + (v_forward * 64.00000)), FALSE, self);
   self.enemy = world;
   if ( (trace_fraction == 1.00000) ) {

      traceline ( source, ((source + (v_forward * 88.00000)) - (v_up * 30.00000)), FALSE, self);
      if ( (trace_fraction == 1.00000) ) {

         traceline ( source, ((source + (v_forward * 88.00000)) + (v_up * 30.00000)), FALSE, self);
         if ( (trace_fraction == 1.00000) ) {

            return ;

         }

      }

   }
   org = (trace_endpos + (v_forward * 2.00000));
   if ( trace_ent.takedamage ) {

      SpawnPuff ( org, '0.00000 0.00000 0.00000', 20.00000, trace_ent);
      self.enemy = trace_ent;
      if ( !trace_ent.mass ) {

         inertia = 1.00000;
      } else {

         if ( (trace_ent.mass <= 5.00000) ) {

            inertia = trace_ent.mass;
         } else {

            inertia = (trace_ent.mass / 10.00000);

         }

      }
      no_flash = 0.00000;
      if ( ((self.bluemana >= 4.00000) && (self.artifact_active & ART_TOMEOFPOWER)) ) {

         damg = (40.00000 + random(30.00000));
         damg += (damg * 0.25000);
      } else {

         if ( (self.bluemana >= 2.00000) ) {

            damg = (30.00000 + random(20.00000));
            if ( (trace_ent.flags & FL_MONSTER) ) {

               self.bluemana -= 2.00000;

            }
         } else {

            no_flash = 1.00000;
            damg = (20.00000 + random(10.00000));

         }

      }
      org = (trace_endpos + (v_forward * -1.00000));
      if ( !no_flash ) {

         CreateLittleWhiteFlash ( org);

      }
      if ( !MetalHitSound ( trace_ent.thingtype) ) {

         sound ( self, CHAN_WEAPON, "weapons/vorpht1.wav", 1.00000, ATTN_NORM);

      }
      dir = (trace_ent.origin - self.origin);
      if ( ((trace_ent.solid != SOLID_BSP) && (trace_ent.movetype != MOVETYPE_PUSH)) ) {

         trace_ent.velocity = ((dir * VORP_PUSH) * (1.00000 / inertia));
         if ( (trace_ent.movetype == MOVETYPE_FLY) ) {

            if ( (trace_ent.flags & FL_ONGROUND) ) {

               trace_ent.velocity_z = (80.00000 / inertia);

            }
         } else {

            trace_ent.velocity_z = (80.00000 / inertia);

         }
         trace_ent.flags ^= FL_ONGROUND;

      }
      T_Damage ( trace_ent, self, self, damg);
   } else {

      sound ( self, CHAN_WEAPON, "weapons/vorpht2.wav", 1.00000, ATTN_NORM);
      org = (trace_endpos + (v_forward * -1.00000));
      org += '0.00000 0.00000 10.00000';
      CreateWhiteSmoke ( org, '0.00000 0.00000 2.00000', HX_FRAME_TIME);

   }
};


void  ()vorpal_normal_fire =  {
local entity victim;
local float damg = 0.00000;
local float damage_flg = 0.00000;
   vorpal_melee ( );
   if ( (self.bluemana < 2.00000) ) {

      return ;

   }
   damage_flg = 0.00000;
   victim = findradius ( self.origin, 100.00000);
   while ( victim ) {

      if ( ((victim.health && (victim != self)) && (victim != self.enemy)) ) {

         traceline ( (self.origin + self.owner.view_ofs), victim.origin, FALSE, self);
         if ( (trace_ent == victim) ) {

            damage_flg = 1.00000;
            sound ( self, CHAN_WEAPON, "weapons/vorpblst.wav", 1.00000, ATTN_NORM);
            CreateWhiteSmoke ( (victim.origin + '0.00000 0.00000 30.00000'), '0.00000 0.00000 8.00000', HX_FRAME_TIME);
            damg = (VORP_BASE_DAMAGE + random(VORP_ADD_DAMAGE));
            T_Damage ( victim, self, self, damg);

         }

      }
      victim = victim.chain;

   }
   if ( (trace_ent.flags & FL_MONSTER) ) {

      self.bluemana -= 2.00000;

   }
};


void  ()vorpal_tome_fire =  {
   vorpal_melee ( );
   if ( (self.bluemana >= 4.00000) ) {

      launch_vorpal_missile ( );
      self.bluemana -= 4.00000;

   }
};


void  ()vorpal_fire =  {
   if ( (self.artifact_active & ART_TOMEOFPOWER) ) {

      vorpal_tome_fire ( );
   } else {

      vorpal_normal_fire ( );

   }
};


void  ()vorpal_ready =  {
   self.weaponframe = 0.00000;
   self.th_weapon = vorpal_ready;
};


void  ()vorpal_twitch =  {
   self.wfs = advanceweaponframe ( 1.00000, 22.00000);
   self.th_weapon = vorpal_twitch;
   if ( (self.weaponframe == 8.00000) ) {

      sound ( self, CHAN_WEAPON, "weapons/vorpswng.wav", 1.00000, ATTN_NORM);
   } else {

      if ( (self.weaponframe == 13.00000) ) {

         sound ( self, CHAN_WEAPON, "weapons/vorpswng.wav", 1.00000, ATTN_NORM);

      }

   }
   if ( (self.wfs == WF_LAST_FRAME) ) {

      vorpal_ready ( );

   }
};


void  ()moveswipe =  {
local vector org = '0.00000 0.00000 0.00000';
   AdvanceFrame( 0.00000, 6.00000);
   makevectors ( self.owner.v_angle);
   org = ((self.owner.origin + self.owner.view_ofs) - '0.00000 0.00000 25.00000');
   setorigin ( self, org);
   self.angles = self.owner.v_angle;
   self.angles_y += 180.00000;
   self.think = moveswipe;
   AdvanceThinkTime(self,HX_FRAME_TIME);
   if ( (self.frame > 5.00000) ) {

      self.think = SUB_Remove;

   }
};


void  ()SpawnSwipe =  {
local entity swipe;
local vector org = '0.00000 0.00000 0.00000';
   swipe = spawn ( );
   CreateEntityNew ( swipe, ENT_SWIPE, "models/vorpswip.mdl", SUB_Null);
   makevectors ( self.v_angle);
   swipe.angles = self.v_angle;
   swipe.angles_y += 180.00000;
   org = ((self.origin + self.view_ofs) - '0.00000 0.00000 25.00000');
   setorigin ( swipe, org);
   swipe.counter = 0.00000;
   swipe.owner = self;
   swipe.velocity = '0.00000 0.00000 0.00000';
   swipe.touch = SUB_Null;
   swipe.drawflags |= DRF_TRANSLUCENT;
   swipe.think = moveswipe;
   AdvanceThinkTime(swipe,HX_FRAME_TIME);
};


void  ()vorpal_a =  {
   self.wfs = advanceweaponframe ( 23.00000, 35.00000);
   self.th_weapon = vorpal_a;
   if ( (self.weaponframe == 24.00000) ) {

      if ( (self.artifact_active & ART_TOMEOFPOWER) ) {

         sound ( self, CHAN_WEAPON, "weapons/vorppwr.wav", 1.00000, ATTN_NORM);
      } else {

         sound ( self, CHAN_WEAPON, "weapons/vorpswng.wav", 1.00000, ATTN_NORM);

      }
   } else {

      if ( (self.weaponframe == 25.00000) ) {

         vorpal_fire ( );

      }

   }
   if ( ((self.weaponframe == 25.00000) && (self.bluemana >= 2.00000)) ) {

      SpawnSwipe ( );

   }
   if ( (self.wfs == WF_LAST_FRAME) ) {

      self.th_weapon = vorpal_ready;

   }
};


void  ()vorpal_select =  {
   self.wfs = advanceweaponframe ( 5.00000, 1.00000);
   self.weaponmodel = "models/vorpal.mdl";
   self.th_weapon = vorpal_select;
   self.last_attack = time;
   if ( (self.wfs == WF_LAST_FRAME) ) {

      self.attack_finished = (time - 1.00000);
      vorpal_twitch ( );

   }
};


void  ()vorpal_deselect =  {
   self.wfs = advanceweaponframe ( 36.00000, 40.00000);
   self.th_weapon = vorpal_deselect;
   self.oldweapon = IT_WEAPON2;
   if ( (self.wfs == WF_LAST_FRAME) ) {

      W_SetCurrentAmmo ( );

   }
};


void  ()pal_vorpal_fire =  {
   vorpal_a ( );
   self.attack_finished = (time + 0.30000);
};


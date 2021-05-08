void  ()warhammer_idle;
void  ()Cru_Wham_Fire;
void  ()warhammer_select;

void  ()ThrowHammerReturn =  {
   sound ( self.controller, CHAN_ITEM, "weapons/weappkup.wav", 1.00000, ATTN_NORM);
   self.controller.weapon = IT_WEAPON1;
   self.controller.th_weapon = warhammer_select;
   sound ( self, CHAN_VOICE, "misc/null.wav", 0.30000, ATTN_NORM);
   remove ( self);
};


void  ()HammerZap =  {
local vector zapangle = '0.00000 0.00000 0.00000';
local vector tospot = '0.00000 0.00000 0.00000';
local vector fromspot = '0.00000 0.00000 0.00000';
local float numstrikes = 0.00000;
local float strikelength = 0.00000;
   if ( (pointcontents ( self.origin) == CONTENT_WATER) ) {

      strikelength = 42.00000;
   } else {

      strikelength = 14.00000;

   }
   numstrikes = random(1.00000,6.00000);
   while ( (numstrikes > 0.00000) ) {

      zapangle = RandomVector ( '360.00000 360.00000 360.00000');
      makevectors ( zapangle);
      fromspot = (self.origin + (v_forward * 16.00000));
      tospot = (self.origin + (v_forward * random((strikelength + 32.00000),32.00000)));
      do_lightning ( self, self.level, STREAM_ATTACHED, 1.00000, fromspot, tospot, 3.00000);
      self.level += 1.00000;
      numstrikes -= 1.00000;
      if ( (self.level > 32.00000) ) {

         self.level = 0.00000;

      }

   }
   self.effects = EF_MUZZLEFLASH;
};


void  ()hammer_bounce =  {
   if ( (other.thingtype != THINGTYPE_FLESH) ) {

      if ( (self.t_width < time) ) {

         self.t_width = (time + 0.30000);
         if ( (random() < 0.30000) ) {

            sound ( self, CHAN_BODY, "weapons/met2stn.wav", 0.50000, ATTN_NORM);
         } else {

            if ( (random() < 0.50000) ) {

               sound ( self, CHAN_BODY, "weapons/vorpht2.wav", 0.50000, ATTN_NORM);
            } else {

               sound ( self, CHAN_BODY, "paladin/axric1.wav", 0.75000, ATTN_NORM);

            }

         }

      }

   }
};


void  ()ThrowHammerThink =  {
local vector destiny = '0.00000 0.00000 0.00000';
local float distance = 0.00000;
local vector dir = '0.00000 0.00000 0.00000';
   makevectors ( self.controller.v_angle);
   destiny = (((self.controller.origin + self.controller.proj_ofs) + (v_right * 7.00000)) + '0.00000 0.00000 -7.00000');
   distance = vlen ( (self.origin - destiny));
   if ( ((self.lifetime < time) || ((distance < 28.00000) && (self.bloodloss < time))) ) {

      ThrowHammerReturn ( );

   }
   if ( (self.bloodloss <= time) ) {

      self.owner = self;

   }
   if ( (distance > 377.00000) ) {

      self.aflag = -1.00000;

   }
   if ( (self.aflag == -1.00000) ) {

      dir = normalize ( (destiny - self.origin));
      if ( (self.watertype < -2.00000) ) {

         self.velocity = ((dir * self.speed) * 0.50000);
      } else {

         self.velocity = (dir * self.speed);

      }
      self.angles = vectoangles ( self.velocity);
      if ( (self.flags & FL_ONGROUND) ) {

         self.avelocity = '500.00000 0.00000 0.00000';
         self.flags ^= FL_ONGROUND;

      }

   }
   if ( (self.pain_finished <= time) ) {

      sound ( self, CHAN_VOICE, "paladin/axblade.wav", 0.30000, ATTN_NORM);
      self.pain_finished = (time + 0.30000);

   }
   if ( ((self.controller.health <= 0.00000) || !(self.controller.flags2 & FL_ALIVE)) ) {

      sound ( self, CHAN_VOICE, "misc/null.wav", 0.30000, ATTN_NORM);
      if ( (pointcontents ( self.origin) == CONTENT_SOLID) ) {

         remove ( self);
      } else {

         self.touch = hammer_bounce;
         self.avelocity = random('-400.00000 -400.00000 -400.00000','400.00000 400.00000 400.00000');
         self.movetype = MOVETYPE_BOUNCE;
         self.think = corpseblink;
         AdvanceThinkTime(self,3.00000);

      }
      return ;

   }
   AdvanceThinkTime(self,0.10000);
   self.think = ThrowHammerThink;
};


void  ()HammerTouch =  {
local float inertia = 0.00000;
   if ( (other == self.controller) ) {

      if ( (self.aflag || (self.bloodloss < time)) ) {

         ThrowHammerReturn ( );
      } else {

         return ;

      }
   } else {

      if ( other.takedamage ) {

         if ( ((self.velocity != VEC_ORIGIN) && (other != self.controller)) ) {

            if ( (self.aflag < 1.00000) ) {

               other.punchangle_x = -20.00000;
               self.enemy = other;
               CastLightning ( 3.00000, 10.00000);
               if ( ((other.health && (other.solid != SOLID_BSP)) && (other.movetype != MOVETYPE_PUSH)) ) {

                  if ( (other.mass <= 10.00000) ) {

                     inertia = 1.00000;
                  } else {

                     inertia = (other.mass / 10.00000);

                  }
                  other.velocity_x = (other.velocity_x + (self.velocity_x / inertia));
                  other.velocity_y = (other.velocity_y + (self.velocity_y / inertia));
                  other.flags ^= FL_ONGROUND;

               }
               T_Damage ( other, self, self.controller, 10.00000);

            }

         }
      } else {

         if ( !MetalHitSound ( other.thingtype) ) {

            sound ( self, CHAN_BODY, "weapons/hitwall.wav", 1.00000, ATTN_NORM);

         }

      }

   }
   if ( (self.aflag < 1.00000) ) {

      self.aflag = -1.00000;
      self.movetype = MOVETYPE_NOCLIP;
      self.solid = SOLID_PHASE;

   }
};


void  ()ThrowHammer =  {
local entity missile;
   sound ( self, CHAN_WEAPON, "weapons/vorpswng.wav", 1.00000, ATTN_NORM);
   missile = spawn ( );
   missile.owner = self;
   missile.controller = self;
   missile.classname = "mjolnir";
   missile.movetype = MOVETYPE_FLYMISSILE;
   missile.solid = SOLID_BBOX;
   makevectors ( self.v_angle);
   missile.velocity = normalize ( v_forward);
   missile.angles = vectoangles ( missile.velocity);
   missile.speed = 800.00000;
   if ( (self.waterlevel > 2.00000) ) {

      missile.velocity = ((missile.velocity * missile.speed) * 0.50000);
   } else {

      missile.velocity = (missile.velocity * missile.speed);

   }
   missile.touch = HammerTouch;
   AdvanceThinkTime(missile,0.00000);
   missile.frags = TRUE;
   missile.bloodloss = (time + 0.30000);
   missile.lifetime = (time + 3.00000);
   sound ( missile, CHAN_VOICE, "paladin/axblade.wav", 1.00000, ATTN_NORM);
   missile.think = ThrowHammerThink;
   setmodel ( missile, "models/hamthrow.mdl");
   setsize ( missile, '-1.00000 -2.00000 -4.00000', '1.00000 2.00000 4.00000');
   setorigin ( missile, ((self.origin + self.proj_ofs) + (v_forward * FL_SWIM)));
   missile.avelocity = '-500.00000 0.00000 0.00000';
   missile.aflag = 0.00000;
   missile.level = 4.00000;
   missile.drawflags = MLS_ABSLIGHT;
   missile.abslight = 1.00000;
   missile.dmg = 200.00000;
   self.attack_finished = (time + 0.50000);
};


void  ()warhammer_gone =  {
   self.th_weapon = warhammer_gone;
   self.weaponmodel = "";
   self.weaponframe = 0.00000;
};


void  ()warhammer_throw =  {
   self.th_weapon = warhammer_throw;
   self.wfs = advanceweaponframe ( 59.00000, 68.00000);
   if ( (self.weaponframe == 65.00000) ) {

      sound ( self, CHAN_WEAPON, "weapons/vorpswng.wav", 1.00000, ATTN_NORM);
      ThrowHammer ( );
   } else {

      if ( (self.wfs == WF_LAST_FRAME) ) {

         warhammer_gone ( );

      }

   }
};


void  ()test_traceline =  {
local vector source = '0.00000 0.00000 0.00000';
local vector dir = '0.00000 0.00000 0.00000';
   makevectors ( self.v_angle);
   source = (self.origin + self.proj_ofs);
   dir = normalize ( v_forward);
   traceline ( source, (source + (dir * 64.00000)), TRUE, self);
};


void  (string hitdir,vector ofs)warhammer_fire =  {
local vector source = '0.00000 0.00000 0.00000';
local vector org = '0.00000 0.00000 0.00000';
local vector dir = '0.00000 0.00000 0.00000';
local float damg = 0.00000;
local float inertia = 0.00000;
local float force = 0.00000;
   makevectors ( self.v_angle);
   source = (self.origin + self.proj_ofs);
   traceline ( source, ((source + ((v_forward * 64.00000) * self.scale)) + ofs), FALSE, self.goalentity);
   if ( (!trace_ent || (trace_ent == self.goalentity)) ) {

      traceline ( source, (((source + ((v_forward * 64.00000) * self.scale)) + ofs) - (v_up * 32.00000)), FALSE, self.goalentity);

   }
   if ( (!trace_ent || (trace_ent == self.goalentity)) ) {

      traceline ( source, (((source + ((v_forward * 64.00000) * self.scale)) + ofs) + (v_up * 16.00000)), FALSE, self.goalentity);

   }
   if ( (trace_fraction < 1.00000) ) {

      org = (trace_endpos + (v_forward * 4.00000));
      if ( trace_ent.takedamage ) {

         if ( ((trace_ent.solid == SOLID_BSP) || (trace_ent.movetype == MOVETYPE_PUSH)) ) {

            inertia = 1000.00000;
         } else {

            if ( (trace_ent.mass <= 10.00000) ) {

               inertia = 1.00000;
            } else {

               inertia = (trace_ent.mass / 10.00000);

            }

         }
         force = ((self.strength / 40.00000) + 0.50000);
         self.goalentity = trace_ent;
         SpawnPuff ( org, '0.00000 0.00000 0.00000', 20.00000, trace_ent);
         damg = random(15.00000,25.00000);
         org = (trace_endpos + (v_forward * -1.00000));
         if ( !MetalHitSound ( trace_ent.thingtype) ) {

            sound ( self, CHAN_WEAPON, "weapons/gauntht1.wav", 1.00000, ATTN_NORM);

         }
         if ( (hitdir == "top") ) {

            damg = (damg * 2.00000);
            trace_ent.deathtype = "hammercrush";

         }
         if ( (inertia < 100.00000) ) {

            dir = ((normalize ( (trace_ent.origin - self.origin)) * damg) * 2.00000);
            if ( (hitdir == "right") ) {

               dir = (dir + (normalize ( v_right) * 40.00000));
               trace_ent.punchangle_y = 6.00000;
            } else {

               if ( (hitdir == "left") ) {

                  dir = (dir - (normalize ( v_right) * 40.00000));
                  trace_ent.punchangle_y = -6.00000;

               }

            }
            trace_ent.velocity = ((dir * (1.00000 / inertia)) * force);
            if ( (trace_ent.movetype == MOVETYPE_FLY) ) {

               if ( (trace_ent.flags & FL_ONGROUND) ) {

                  trace_ent.velocity_z = ((175.00000 / inertia) * force);

               }
            } else {

               trace_ent.velocity_z = ((175.00000 / inertia) * force);

            }
            trace_ent.flags ^= FL_ONGROUND;

         }
         T_Damage ( trace_ent, self, self, damg);
      } else {

         if ( (ofs == '0.00000 0.00000 0.00000') ) {

            sound ( self, CHAN_WEAPON, "weapons/hitwall.wav", 1.00000, ATTN_NORM);

         }

      }

   }
};


void  ()warhammer_idle =  {
   self.th_weapon = warhammer_idle;
   self.weaponframe = 69.00000;
};


void  ()warhammer_return =  {
   self.th_weapon = warhammer_return;
   self.wfs = advanceweaponframe ( 33.00000, 36.00000);
   if ( (self.wfs == WF_CYCLE_WRAPPED) ) {

      warhammer_idle ( );

   }
};


void  ()warhammer_deselect =  {
   self.wfs = advanceweaponframe ( 58.00000, 50.00000);
   self.th_weapon = warhammer_deselect;
   if ( (self.wfs == WF_LAST_FRAME) ) {

      W_SetCurrentAmmo ( );

   }
};


void  ()warhammer_select =  {
   self.th_weapon = warhammer_select;
   self.wfs = advanceweaponframe ( 50.00000, 58.00000);
   self.weaponmodel = "models/warhamer.mdl";
   if ( (self.wfs == WF_CYCLE_WRAPPED) ) {

      self.attack_finished = (time - 1.00000);
      warhammer_idle ( );

   }
};


void  ()warhammer_c =  {
local vector ofs = '0.00000 0.00000 0.00000';
   makevectors ( self.v_angle);
   self.th_weapon = warhammer_c;
   self.wfs = advanceweaponframe ( 22.00000, 32.00000);
   if ( (self.weaponframe == 25.00000) ) {

      self.weaponframe += 3.00000;

   }
   if ( (self.weaponframe == 28.00000) ) {

      sound ( self, CHAN_WEAPON, "weapons/vorpswng.wav", 1.00000, ATTN_NORM);
      self.goalentity = self;
      ofs = (normalize ( v_right) * 30.00000);
      warhammer_fire ( "right", ofs);
   } else {

      if ( (self.weaponframe == 29.00000) ) {

         warhammer_fire ( "right", '0.00000 0.00000 0.00000');
      } else {

         if ( (self.weaponframe == 30.00000) ) {

            ofs = (normalize ( v_right) * -30.00000);
            warhammer_fire ( "right", ofs);

         }

      }

   }
   if ( (self.wfs == WF_CYCLE_WRAPPED) ) {

      warhammer_return ( );

   }
};


void  ()warhammer_b =  {
local vector ofs = '0.00000 0.00000 0.00000';
   makevectors ( self.v_angle);
   self.th_weapon = warhammer_b;
   self.wfs = advanceweaponframe ( 37.00000, 47.00000);
   if ( (self.weaponframe == 41.00000) ) {

      sound ( self, CHAN_WEAPON, "weapons/vorpswng.wav", 1.00000, ATTN_NORM);
      self.goalentity = self;
      ofs = (normalize ( v_right) * -30.00000);
      warhammer_fire ( "left", ofs);
   } else {

      if ( (self.weaponframe == 42.00000) ) {

         warhammer_fire ( "left", '0.00000 0.00000 0.00000');
      } else {

         if ( (self.weaponframe == 43.00000) ) {

            ofs = (normalize ( v_right) * 30.00000);
            warhammer_fire ( "left", ofs);

         }

      }

   }
   if ( (self.wfs == WF_CYCLE_WRAPPED) ) {

      warhammer_select ( );

   }
};


void  ()warhammer_a =  {
local vector ofs = '0.00000 0.00000 0.00000';
   makevectors ( self.v_angle);
   self.th_weapon = warhammer_a;
   self.wfs = advanceweaponframe ( 0.00000, 11.00000);
   if ( (self.weaponframe == 6.00000) ) {

      sound ( self, CHAN_WEAPON, "weapons/vorpswng.wav", 1.00000, ATTN_NORM);
      self.goalentity = self;
      ofs = (normalize ( v_up) * 30.00000);
      ofs += (normalize ( v_right) * 15.00000);
      warhammer_fire ( "top", ofs);
   } else {

      if ( (self.weaponframe == 7.00000) ) {

         warhammer_fire ( "top", '0.00000 0.00000 0.00000');
      } else {

         if ( (self.weaponframe == 8.00000) ) {

            ofs = (normalize ( v_up) * -30.00000);
            warhammer_fire ( "top", ofs);

         }

      }

   }
   if ( (self.wfs == WF_CYCLE_WRAPPED) ) {

      warhammer_return ( );

   }
};


void  ()Cru_Wham_Fire =  {
local float r = 0.00000;
   if ( (self.artifact_active & ART_TOMEOFPOWER) ) {

      warhammer_throw ( );
   } else {

      self.attack_finished = (time + 0.70000);
      r = rint ( random(1.00000,3.00000));
      if ( (r == 1.00000) ) {

         warhammer_a ( );
      } else {

         if ( (r == 2.00000) ) {

            warhammer_b ( );
         } else {

            if ( (r == 3.00000) ) {

               warhammer_c ( );

            }

         }

      }

   }
};


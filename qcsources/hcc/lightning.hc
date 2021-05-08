
void  ()smolder_think =  {
local vector ofs = '0.00000 0.00000 0.00000';
   ofs_x = random(-10.00000,10.00000);
   ofs_y = random(-10.00000,10.00000);
   particle ( (self.origin + ofs), '0.00000 0.00000 100.00000', random(272.00000,288.00000), random(1.00000,10.00000));
   if ( ((random() < 0.10000) && (random() < 0.50000)) ) {

      CreateWhiteSmoke ( self.origin, '0.00000 0.00000 8.00000', (HX_FRAME_TIME * 2.00000));

   }
   AdvanceThinkTime(self,0.10000);
   if ( (time > self.lifetime) ) {

      remove ( self);

   }
};


void  (vector org)smolder =  {
   newmis = spawn ( );
   setorigin ( newmis, org);
   newmis.effects = EF_NODRAW;
   newmis.lifetime = (time + 7.00000);
   newmis.think = smolder_think;
   AdvanceThinkTime(newmis,0.00000);
};


void  ()shock_think =  {
   if ( (self.skin == 0.00000) ) {

      self.skin = 1.00000;
   } else {

      self.skin = 0.00000;

   }
   self.scale -= 0.10000;
   AdvanceThinkTime(self,0.05000);
   if ( ((time > self.lifetime) || (self.scale <= 0.10000)) ) {

      remove ( self);

   }
};


void  (vector org)spawnshockball =  {
   newmis = spawn ( );
   newmis.drawflags |= MLS_TORCH;
   setmodel ( newmis, "models/vorpshok.mdl");
   setorigin ( newmis, org);
   newmis.lifetime = (time + 1.00000);
   newmis.angles_z = 90.00000;
   newmis.think = shock_think;
   AdvanceThinkTime(newmis,0.00000);
   newmis.scale = 2.50000;
};


void  (vector endpos)ThroughWaterZap =  {
local entity waterloser;
local entity attacker;
local float damg = 0.00000;
   waterloser = spawn ( );
   setorigin ( waterloser, endpos);
   if ( (self.classname == "mjolnir") ) {

      damg = 128.00000;
   } else {

      damg = (666.00000 * 2.00000);

   }
   attacker = self;
   if ( (self.classname != "player") ) {

      if ( (self.owner.classname == "player") ) {

         attacker = self.owner;
      } else {

         if ( (self.controller.classname == "player") ) {

            attacker = self.controller;

         }

      }

   }
   T_RadiusDamageWater ( waterloser, self, damg, self);
   remove ( waterloser);
};


void  (vector startpos)ThroughWater =  {
local vector endpos = '0.00000 0.00000 0.00000';
local float mover = 0.00000;
   mover = 600.00000;
   while ( mover ) {

      mover = (mover - 10.00000);
      endpos = (startpos + (v_forward * mover));
      if ( ((pointcontents ( endpos) == CONTENT_WATER) || (pointcontents ( endpos) == CONTENT_SLIME)) ) {

         ThroughWaterZap ( endpos);
      } else {

         if ( (pointcontents ( endpos) == CONTENT_SOLID) ) {

            return ;

         }

      }

   }
};


void  (entity from,float damage,string type)do_lightning_dam =  {
local vector loser_org = '0.00000 0.00000 0.00000';
   if ( (((trace_ent.classname == "monster_eidolon") || (trace_ent.classname == "obj_chaos_orb")) && (type == "lightning")) ) {

      return ;

   }
   particle ( trace_endpos, '0.00000 0.00000 100.00000', 225.00000, (damage * 4.00000));
   if ( (type == "lightning") ) {

      spawnshockball ( ((trace_ent.absmax + trace_ent.absmin) * 0.50000));

   }
   loser_org = trace_ent.origin;
   T_Damage ( trace_ent, from, from, damage);
   if ( (trace_ent.health <= 0.00000) ) {

      smolder ( loser_org);

   }
   if ( (type == "lightning") ) {

      sound ( trace_ent, CHAN_AUTO, "misc/lighthit.wav", 1.00000, ATTN_NORM);
   } else {

      sound ( trace_ent, CHAN_AUTO, "crusader/sunhit.wav", 1.00000, ATTN_NORM);

   }
};


void  (vector p1,vector p2,entity from,float damage,string type)LightningDamage =  {
local entity e1;
local entity e2;
local vector f = '0.00000 0.00000 0.00000';
local float inertia = 0.00000;
   f = (p2 - p1);
   normalize ( f);
   f_x = (0.00000 - f_y);
   f_y = f_x;
   f_z = 0.00000;
   f = (f * 16.00000);
   e2 = world;
   e1 = world;
   traceline ( p1, p2, FALSE, self);
   if ( ((type == "lightning") && ((pointcontents ( trace_endpos) == CONTENT_WATER) || (pointcontents ( trace_endpos) == CONTENT_SLIME))) ) {

      ThroughWaterZap ( trace_endpos);
   } else {

      if ( ((type == "lightning") && ((trace_ent.watertype == CONTENT_WATER) || (trace_ent.watertype == CONTENT_SLIME))) ) {

         T_RadiusDamageWater ( self, self, (666.00000 * 2.00000), self);
      } else {

         if ( ((self.classname == "mjolnir") && (trace_ent == self.controller)) ) {

            bprint ( "");
         } else {

            if ( trace_ent.takedamage ) {

               if ( (trace_ent.mass <= 10.00000) ) {

                  inertia = 1.00000;
               } else {

                  inertia = (trace_ent.mass / 10.00000);

               }
               do_lightning_dam ( from, damage, type);
               if ( (((self.classname == "mjolnir") && (trace_ent.flags & FL_ONGROUND)) && (type == "lightning")) ) {

                  trace_ent.velocity_z = (trace_ent.velocity_z + (400.00000 / inertia));
                  trace_ent.flags ^= FL_ONGROUND;

               }
            } else {

               if ( (type == "lightning") ) {

                  ThroughWater ( p1);

               }

            }

         }

      }

   }
   e1 = trace_ent;
   traceline ( (p1 + f), (p2 + f), FALSE, self);
   if ( ((self.classname == "mjolnir") && (trace_ent == self.controller)) ) {

      bprint ( "");
   } else {

      if ( ((trace_ent != e1) && trace_ent.takedamage) ) {

         do_lightning_dam ( from, damage, type);

      }

   }
   e2 = trace_ent;
   traceline ( (p1 - f), (p2 - f), FALSE, self);
   if ( ((self.classname == "mjolnir") && (trace_ent == self.controller)) ) {

      bprint ( "");
   } else {

      if ( (((trace_ent != e1) && (trace_ent != e2)) && trace_ent.takedamage) ) {

         do_lightning_dam ( from, damage, type);

      }

   }
};


void  (entity lowner,float tag,float lflags,float duration,vector spot1,vector spot2,float ldamg)do_lightning =  {
local vector damage_dir = '0.00000 0.00000 0.00000';
   WriteByte ( MSG_BROADCAST, SVC_TEMPENTITY);
   WriteByte ( MSG_BROADCAST, TE_STREAM_LIGHTNING);
   WriteEntity ( MSG_BROADCAST, lowner);
   WriteByte ( MSG_BROADCAST, (tag + lflags));
   WriteByte ( MSG_BROADCAST, duration);
   WriteCoord ( MSG_BROADCAST, spot1_x);
   WriteCoord ( MSG_BROADCAST, spot1_y);
   WriteCoord ( MSG_BROADCAST, spot1_z);
   WriteCoord ( MSG_BROADCAST, spot2_x);
   WriteCoord ( MSG_BROADCAST, spot2_y);
   WriteCoord ( MSG_BROADCAST, spot2_z);
   if ( ldamg ) {

      if ( (self.owner.classname == "player") ) {

         lowner = self.owner;
      } else {

         if ( (self.controller.classname == "player") ) {

            lowner = self.controller;

         }

      }
      damage_dir = normalize ( (spot2 - spot1));
      LightningDamage ( (spot1 - (damage_dir * 15.00000)), (spot2 + (damage_dir * 15.00000)), lowner, ldamg, "lightning");

   }
};


void  (float max_strikes,float damg)CastLightning =  {
local vector org = '0.00000 0.00000 0.00000';
local vector dir = '0.00000 0.00000 0.00000';
local vector tospot = '0.00000 0.00000 0.00000';
local float number_strikes = 0.00000;
   self.effects |= EF_MUZZLEFLASH;
   if ( (max_strikes == 0.00000) ) {

      max_strikes = 1.00000;

   }
   while ( (max_strikes > number_strikes) ) {

      if ( (random() < 0.70000) ) {

         sound ( self.enemy, CHAN_AUTO, "crusader/lghtn1.wav", 1.00000, ATTN_NORM);
      } else {

         sound ( self.enemy, CHAN_AUTO, "crusader/lghtn2.wav", 1.00000, ATTN_NORM);

      }
      if ( ((self.enemy.solid == SOLID_BSP) && (self.enemy.origin == '0.00000 0.00000 0.00000')) ) {

         org = ((self.enemy.absmin + self.enemy.absmax) * 0.50000);
      } else {

         org = self.enemy.origin;
         org_z += (0.50000 * self.enemy.maxs_z);

      }
      dir = org;
      dir_x += random(-300.00000,300.00000);
      dir_y += random(-300.00000,300.00000);
      dir_z += 500.00000;
      traceline ( org, dir, TRUE, self);
      tospot = org;
      org = trace_endpos;
      do_lightning ( self, number_strikes, 0.00000, 4.00000, org, tospot, damg);
      number_strikes += 1.00000;

   }
};

void  ()rolling_thunder;

void  ()thunder_clear =  {
   self.owner.aflag -= 1.00000;
   remove ( self);
};


void  ()thunder_sound =  {
local float sound_vol = 0.00000;
   sound_vol = (self.lightvalue2 / 25.00000);
   if ( (sound_vol > 1.00000) ) {

      sound_vol = 1.00000;
   } else {

      if ( (sound_vol < 0.00000) ) {

         sound_vol = 0.10000;

      }

   }
   sound ( self, CHAN_VOICE, "ambience/thunder1.wav", sound_vol, ATTN_NORM);
   AdvanceThinkTime(self,5.00000);
   self.think = thunder_clear;
};


void  ()spawn_thunder =  {
   self.aflag += 1.00000;
   newmis = spawn ( );
   self.angles_y = random(360.00000);
   makevectors ( self.angles);
   setorigin ( newmis, (self.origin + ((v_forward * self.lightvalue2) * 10.00000)));
   newmis.owner = self;
   newmis.lightvalue2 = self.lightvalue2;
   newmis.think = thunder_sound;
   AdvanceThinkTime(newmis,(2.50000 - (self.lightvalue2 / 10.00000)));
};


void  ()flash_wait =  {
   lightstylestatic ( self.style, self.lightvalue1);
   self.think = rolling_thunder;
   AdvanceThinkTime(self,0.00000);
};


void  ()lightning_strike =  {
local vector org = '0.00000 0.00000 0.00000';
local vector tospot = '0.00000 0.00000 0.00000';
local vector lightn_dir = '0.00000 0.00000 0.00000';
local float dist = 0.00000;
local float num_branches = 0.00000;
   dist = random(self.frags);
   self.angles_y = random(360.00000);
   makevectors ( self.angles);
   traceline ( self.origin, (self.origin + (v_forward * dist)), TRUE, self);
   org = trace_endpos;
   tospot = (org - '0.00000 0.00000 1000.00000');
   traceline ( org, tospot, TRUE, self);
   tospot = trace_endpos;
   tospot_x += random(-100.00000,100.00000);
   tospot_y += random(-100.00000,100.00000);
   dist = vlen ( (tospot - org));
   newmis = spawn ( );
   setorigin ( newmis, org);
   if ( (random() < 0.50000) ) {

      sound ( newmis, CHAN_AUTO, "crusader/lghtn1.wav", 1.00000, ATTN_NORM);
   } else {

      sound ( newmis, CHAN_AUTO, "crusader/lghtn2.wav", 1.00000, ATTN_NORM);

   }
   newmis.think = SUB_Remove;
   AdvanceThinkTime(newmis,3.00000);
   num_branches = rint ( random(3.00000,7.00000));
   while ( num_branches ) {

      self.level += 1.00000;
      if ( (self.level >= 8.00000) ) {

         self.level = 0.00000;

      }
      do_lightning ( self, self.level, STREAM_ATTACHED, 4.00000, org, tospot, 10000.00000);
      lightn_dir = normalize ( (tospot - org));
      org = (org + (lightn_dir * random((num_branches + (dist / 10.00000)),(num_branches + (dist / 5.00000)))));
      tospot = (org - '0.00000 0.00000 1000.00000');
      traceline ( trace_endpos, tospot, TRUE, self);
      tospot = trace_endpos;
      if ( (random() < 0.50000) ) {

         tospot_x += random(125.00000,375.00000);
      } else {

         tospot_x -= random(125.00000,375.00000);

      }
      if ( (random() < 0.50000) ) {

         tospot_y += random(125.00000,375.00000);
      } else {

         tospot_y -= random(125.00000,375.00000);

      }
      num_branches -= 1.00000;

   }
};


void  ()rolling_thunder =  {
local float lightburst = 0.00000;
   if ( (random(100.00000) >= self.wait) ) {

      if ( ((self.spawnflags & 1.00000) && (random(100.00000) < self.dmg)) ) {

         self.lightvalue2 = 25.00000;
         lightning_strike ( );
      } else {

         lightburst = (random(0.10000,1.10000) * (25.00000 - self.lightvalue1));
         self.lightvalue2 = (self.lightvalue1 + lightburst);
         if ( (self.aflag <= 3.00000) ) {

            spawn_thunder ( );

         }

      }
      lightstylestatic ( self.style, self.lightvalue2);
      self.think = flash_wait;
      AdvanceThinkTime(self,random(0.30000));
   } else {

      self.think = rolling_thunder;
      AdvanceThinkTime(self,random(0.10000,1.10000));

   }
};


void  ()thunder_use =  {
local float lightburst = 0.00000;
   if ( (self.spawnflags & 1.00000) ) {

      self.lightvalue2 = 25.00000;
      lightning_strike ( );
   } else {

      lightburst = (random(0.10000,1.10000) * (25.00000 - self.lightvalue1));
      self.lightvalue2 = (self.lightvalue1 + lightburst);
      spawn_thunder ( );

   }
   lightstylestatic ( self.style, self.lightvalue2);
   self.think = flash_wait;
   AdvanceThinkTime(self,random(0.30000));
};


void  ()light_thunderstorm =  {
   if ( self.targetname ) {

      self.use = thunder_use;
   } else {

      remove ( self);
      return ;

   }
   precache_sound2 ( "ambience/thunder1.wav");
   precache_sound2 ( "crusader/lghtn1.wav");
   precache_sound2 ( "crusader/lghtn2.wav");
   if ( !self.frags ) {

      self.frags = 1000.00000;

   }
   if ( !self.wait ) {

      self.wait = 33.00000;

   }
   if ( !self.lightvalue1 ) {

      self.lightvalue1 = 11.00000;

   }
   if ( (!self.dmg && (self.spawnflags & 1.00000)) ) {

      self.dmg = 10.00000;

   }
   lightstylestatic ( self.style, self.lightvalue1);
   self.think = rolling_thunder;
   AdvanceThinkTime(self,0.00000);
};


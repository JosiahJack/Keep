void  ()ravenstaff_fire;
void  ()ravenstaff_idle;
void  ()split;
void  ()raven_track;
void  ()raven_flap;
void  ()raven_touch;
void  ()raven_track_init;
void  ()ravenmissile_explode;

void  ()raven_spark =  {
   if ( (pointcontents ( self.origin) == CONTENT_SKY) ) {

      remove ( self);
      return ;

   }
   CreateWhiteSmoke ( (self.origin + '0.00000 0.00000 -10.00000'), '0.00000 8.00000 -10.00000', (HX_FRAME_TIME * 3.00000));
   CreateRedSmoke ( (self.origin + '0.00000 0.00000 -10.00000'), '0.00000 0.00000 -10.00000', (HX_FRAME_TIME * 3.00000));
   CreateWhiteSmoke ( (self.origin + '0.00000 0.00000 -10.00000'), '0.00000 -8.00000 -10.00000', (HX_FRAME_TIME * 3.00000));
   sound ( self, CHAN_WEAPON, "raven/death.wav", 1.00000, ATTN_NORM);
   self.touch = SUB_Null;
   self.effects = EF_NODRAW;
   self.think = SUB_Remove;
   AdvanceThinkTime(self,HX_FRAME_TIME);
};


void  ()raven_death_init =  {
   self.owner.raven_cnt -= 1.00000;
   traceline ( self.origin, (self.origin + '0.00000 0.00000 600.00000'), FALSE, self);
   if ( (trace_fraction < 1.00000) ) {

      self.touch = raven_spark;
      self.nextthink = 0.00000;
   } else {

      self.touch = raven_spark;
      self.think = raven_spark;
      AdvanceThinkTime(self,1.00000);

   }
   self.velocity = normalize ( '0.00000 0.00000 600.00000');
   self.velocity = (self.velocity * 400.00000);
   self.angles = vectoangles ( self.velocity);
};


void  ()raven_bounce =  {
   self.flags ^= FL_ONGROUND;
   self.angles = vectoangles ( self.velocity);
   self.angles_y += random(-90.00000,90.00000);
   self.angles_x = random(-20.00000,20.00000);
   makevectors ( self.angles);
   self.velocity = normalize ( v_forward);
   self.velocity = (self.velocity * 600.00000);
   self.think = raven_flap;
   self.nextthink = (time + HX_FRAME_TIME);
   self.think1 = raven_track_init;
   self.next_action = (time + (HX_FRAME_TIME * random(2.00000,4.00000)));
   self.touch = raven_touch;
};


void  ()raven_touch =  {
   if ( ((other == self.enemy) && (other.takedamage != DAMAGE_NO)) ) {

      if ( (other.monsterclass >= CLASS_BOSS) ) {

         T_Damage ( other, self, self.owner, 10.00000);
      } else {

         T_Damage ( other, self, self.owner, 20.00000);

      }
      self.damage_max += 20.00000;
      SpawnPuff ( self.origin, '0.00000 0.00000 -5.00000', random(5.00000,10.00000), other);
      MeatChunks ( self.origin, ((self.velocity * 0.50000) + '0.00000 0.00000 20.00000'), 2.00000);
      sound ( self, CHAN_WEAPON, "weapons/gauntht1.wav", 1.00000, ATTN_NORM);

   }
   if ( (self.damage_max > 200.00000) ) {

      raven_death_init ( );
   } else {

      self.touch = SUB_Null;
      self.think = raven_bounce;
      self.nextthink = (time + 0.05000);

   }
   if ( ((self.lifetime < time) || (self.owner.raven_cnt > 6.00000)) ) {

      raven_death_init ( );
      return ;

   }
};


void  ()raven_search =  {
local entity victim;
   self.nextthink = (time + HX_FRAME_TIME);
   self.think = raven_flap;
   victim = findradius ( self.origin, 1000.00000);
   while ( victim ) {

      if ( ((((((victim.flags & FL_MONSTER) || (victim.flags & FL_CLIENT)) && (victim.owner != self)) && (victim.controller != self.owner)) && (victim.health > 0.00000)) && (victim != self.owner)) ) {

         if ( (coop && (self.enemy.team == self.team)) ) {

            victim = victim;
         } else {

            traceline ( self.origin, victim.origin, TRUE, self);
            if ( (trace_fraction == 1.00000) ) {

               self.enemy = victim;
               self.think1 = raven_track;
               self.think1 = raven_track_init;
               self.next_action = (time + 0.10000);
               self.searchtime = 0.00000;
               return ;

            }

         }

      }
      victim = victim.chain;

   }
   self.think1 = raven_search;
   self.next_action = (time + (HX_FRAME_TIME * 3.00000));
   if ( (self.searchtime == 0.00000) ) {

      self.searchtime = (time + 0.50000);
      self.angles_y = random(0.00000,360.00000);
      self.angles_x = 0.00000;
      makevectors ( self.angles);
      self.velocity = normalize ( v_forward);
      self.velocity = (self.velocity * 600.00000);

   }
   if ( (((self.searchtime < time) || (self.lifetime < time)) || (self.owner.raven_cnt > 6.00000)) ) {

      raven_death_init ( );

   }
};


void  ()raven_track =  {
local vector delta = '0.00000 0.00000 0.00000';
local vector hold_spot = '0.00000 0.00000 0.00000';
   if ( (((self.enemy.health <= 0.00000) || (self.enemy == world)) || !(self.enemy.flags & FL_MONSTER)) ) {

      raven_search ( );
   } else {

      traceline ( self.origin, self.enemy.origin, TRUE, self);
      if ( (trace_fraction == 1.00000) ) {

         hold_spot = self.enemy.origin;
         hold_spot_z += self.enemy.maxs_z;
         delta = (hold_spot - self.origin);
         self.velocity = normalize ( delta);
         self.velocity = (self.velocity * 600.00000);
         self.angles = vectoangles ( self.velocity);
         self.think1 = raven_track;
         self.next_action = (time + (HX_FRAME_TIME * 3.00000));
         self.think = raven_flap;
         self.nextthink = (time + HX_FRAME_TIME);
      } else {

         raven_search ( );

      }

   }
   if ( ((self.lifetime < time) || (self.owner.raven_cnt > 6.00000)) ) {

      raven_death_init ( );
      return ;

   }
};


void  ()raven_track_init =  {
local vector delta = '0.00000 0.00000 0.00000';
local vector hold_spot = '0.00000 0.00000 0.00000';
   if ( ((self.enemy.health <= 0.00000) || (self.enemy == world)) ) {

      raven_search ( );
   } else {

      hold_spot = self.enemy.origin;
      hold_spot_z += self.enemy.maxs_z;
      delta = (hold_spot - self.origin);
      self.velocity = normalize ( delta);
      self.angles = vectoangles ( self.velocity);
      self.idealpitch = self.angles_x;
      makevectors ( self.angles);
      self.velocity = normalize ( v_forward);
      self.velocity = (self.velocity * 600.00000);
      self.pitchdowntime = (time + (HX_FRAME_TIME * 3.00000));
      self.think = raven_track;
      self.nextthink = time;

   }
};


void  ()raven_flap =  {
   AdvanceFrame ( 0.00000, 7.00000);
   if ( ((self.frame == 1.00000) && (random() < 0.20000)) ) {

      sound ( self, CHAN_VOICE, "raven/squawk2.wav", 1.00000, ATTN_NORM);

   }
   if ( (self.next_action < time) ) {

      self.think = self.think1;
      self.nextthink = time;
   } else {

      self.think = raven_flap;
      self.nextthink = (time + HX_FRAME_TIME);

   }
   if ( ((self.lifetime < time) || (self.owner.raven_cnt > 6.00000)) ) {

      raven_death_init ( );
      return ;

   }
};


void  ()create_raven =  {
local entity missile;
local vector spot1 = '0.00000 0.00000 0.00000';
local vector spot2 = '0.00000 0.00000 0.00000';
   missile = spawn ( );
   missile.frags = TRUE;
   missile.owner = self.owner;
   self.owner.raven_cnt += 1.00000;
   missile.movetype = MOVETYPE_BOUNCEMISSILE;
   missile.solid = SOLID_BBOX;
   missile.takedamage = DAMAGE_YES;
   makevectors ( self.v_angle);
   missile.velocity = normalize ( v_forward);
   missile.velocity = (missile.velocity * 600.00000);
   missile.angles = vectoangles ( missile.velocity);
   missile.searchtime = 0.00000;
   missile.yaw_speed = 50.00000;
   setmodel ( missile, "models/ravproj.mdl");
   setsize ( missile, '-8.00000 -8.00000 8.00000', '8.00000 8.00000 8.00000');
   setorigin ( missile, (((self.origin + self.proj_ofs) - (v_forward * 14.00000)) + (v_right * random(-8.00000,8.00000))));
   missile.touch = raven_touch;
   missile.lifetime = (time + 5.00000);
   missile.classname = "bird_missile";
   sound ( missile, CHAN_VOICE, "raven/ravengo.wav", 1.00000, ATTN_NORM);
   makevectors ( self.v_angle);
   spot1 = (self.origin + self.proj_ofs);
   spot2 = (spot1 + (v_forward * 600.00000));
   traceline ( spot1, spot2, FALSE, self);
   if ( ((((trace_ent != world) && (trace_ent.flags & FL_MONSTER)) && (trace_ent.owner != self)) && (trace_ent.health > 0.00000)) ) {

      missile.enemy = trace_ent;
      missile.nextthink = (time + HX_FRAME_TIME);
      missile.think = raven_flap;
      missile.next_action = (time + 0.01000);
      missile.think1 = raven_track;
      missile.think1 = raven_track_init;
   } else {

      missile.nextthink = (time + 0.01000);
      missile.think = raven_search;

   }
};


void  ()ravenmissile_explode =  {
   create_raven ( );
   create_raven ( );
   create_raven ( );
   CreateWhiteSmoke ( (self.origin + '0.00000 0.00000 0.00000'), '0.00000 0.00000 8.00000', (HX_FRAME_TIME * 3.00000));
   CreateWhiteSmoke ( (self.origin + '0.00000 0.00000 5.00000'), '0.00000 0.00000 8.00000', (HX_FRAME_TIME * 3.00000));
   CreateWhiteSmoke ( (self.origin + '0.00000 0.00000 10.00000'), '0.00000 0.00000 8.00000', (HX_FRAME_TIME * 3.00000));
   remove ( self);
};


void  ()ravenmissile_touch =  {
   if ( (pointcontents ( self.origin) == CONTENT_SKY) ) {

      remove ( self);
      return ;

   }
   if ( other.health ) {

      sound ( self, CHAN_WEAPON, "weapons/explode.wav", 1.00000, ATTN_NORM);
      starteffect ( CE_SM_EXPLOSION, self.origin);
      self.enemy = other;
      T_Damage ( other, self, self, 10.00000);

   }
   ravenmissile_explode ( );
};


void  ()ravenmissile_puff =  {
   makevectors ( self.angles);
   if ( (self.lifetime < time) ) {

      ravenmissile_explode ( );
   } else {

      AdvanceThinkTime(newmis,(HX_FRAME_TIME * 3.00000));
      self.think = ravenmissile_puff;

   }
};


void  ()launch_superraven =  {
   self.attack_finished = (time + 0.50000);
   makevectors ( self.v_angle);
   newmis = spawn ( );
   setmodel ( newmis, "models/birdmsl2.mdl");
   newmis.movetype = MOVETYPE_FLYMISSILE;
   newmis.solid = SOLID_BBOX;
   newmis.takedamage = DAMAGE_NO;
   newmis.owner = self;
   setsize ( newmis, '0.00000 0.00000 0.00000', '0.00000 0.00000 0.00000');
   newmis.velocity = normalize ( v_forward);
   newmis.velocity = (newmis.velocity * 600.00000);
   newmis.angles = vectoangles ( newmis.velocity);
   setorigin ( newmis, ((self.origin + self.proj_ofs) + (v_forward * 10.00000)));
   newmis.touch = ravenmissile_touch;
   newmis.lifetime = (time + 0.50000);
   newmis.avelocity_z = 1000.00000;
   newmis.scale = 0.40000;
   AdvanceThinkTime(newmis,(HX_FRAME_TIME * 3.00000));
   newmis.think = ravenmissile_puff;
   self.punchangle_x = random(-3.00000);
};


void  ()ravenshot_touch =  {
   if ( (pointcontents ( self.origin) == CONTENT_SKY) ) {

      remove ( self);
      return ;

   }
   T_Damage ( other, self, self.owner, 30.00000);
   sound ( self, CHAN_WEAPON, "weapons/explode.wav", 1.00000, ATTN_NORM);
   starteffect ( CE_SM_EXPLOSION, self.origin);
   remove ( self);
};


void  (vector location,float add_yaw,float nexttime,float rotate,void() nextfunc)create_raven_shot2 =  {
local entity missile;
local vector holdangle = '0.00000 0.00000 0.00000';
   missile = spawn ( );
   missile.owner = self.owner;
   missile.movetype = MOVETYPE_FLYMISSILE;
   missile.solid = SOLID_BBOX;
   missile.solid = DAMAGE_YES;
   missile.angles = self.angles;
   holdangle = self.angles;
   holdangle_z = 0.00000;
   holdangle_x = (0.00000 - holdangle_x);
   holdangle_y += add_yaw;
   makevectors ( holdangle);
   missile.velocity = normalize ( v_forward);
   missile.velocity = (missile.velocity * 800.00000);
   if ( rotate ) {

      missile.avelocity_z = 1000.00000;
   } else {

      missile.avelocity_z = -1000.00000;

   }
   missile.touch = ravenshot_touch;
   setmodel ( missile, "models/vindsht1.mdl");
   setsize ( missile, '0.00000 0.00000 0.00000', '0.00000 0.00000 0.00000');
   setorigin ( missile, location);
   missile.classname = "set_missile";
   AdvanceThinkTime(missile,nexttime);
   missile.think = nextfunc;
};


void  (vector location,float nexttime,void() nextfunc,vector fire_angle)create_raven_shot1 =  {
local entity missile;
   missile = spawn ( );
   missile.owner = self;
   missile.movetype = MOVETYPE_FLYMISSILE;
   missile.solid = SOLID_BBOX;
   makevectors ( fire_angle);
   missile.velocity = normalize ( v_forward);
   missile.velocity = (missile.velocity * 800.00000);
   missile.avelocity_z = 1000.00000;
   missile.angles = vectoangles ( missile.velocity);
   missile.dmg = 40.00000;
   missile.touch = ravenshot_touch;
   setmodel ( missile, "models/vindsht1.mdl");
   setsize ( missile, '0.00000 0.00000 0.00000', '0.00000 0.00000 0.00000');
   setorigin ( missile, location);
   missile.classname = "set_missile";
   AdvanceThinkTime(missile,nexttime);
   missile.think = nextfunc;
};


void  ()missle_straight =  {
local vector holdangles = '0.00000 0.00000 0.00000';
   holdangles = self.angles;
   holdangles_z = 0.00000;
   holdangles_x = (0.00000 - holdangles_x);
   makevectors ( holdangles);
   self.velocity = normalize ( v_forward);
   self.velocity = (self.velocity * 800.00000);
};


void  ()missle_straight1 =  {
local vector holdangles = '0.00000 0.00000 0.00000';
   holdangles = self.angles;
   holdangles_z = 0.00000;
   holdangles_x = (0.00000 - holdangles_x);
   makevectors ( holdangles);
   self.velocity = normalize ( v_forward);
   self.velocity = (self.velocity * 800.00000);
   create_raven_shot2 ( self.origin, -10.00000, 0.25000, 1.00000, missle_straight);
   CreateLittleBlueFlash ( self.origin);
   sound ( self, CHAN_WEAPON, "raven/split.wav", 1.00000, ATTN_NORM);
};


void  ()missle_straight2 =  {
local vector holdangles = '0.00000 0.00000 0.00000';
   holdangles = self.angles;
   holdangles_z = 0.00000;
   holdangles_x = (0.00000 - holdangles_x);
   makevectors ( holdangles);
   self.velocity = normalize ( v_forward);
   self.velocity = (self.velocity * 800.00000);
   create_raven_shot2 ( self.origin, 10.00000, 0.25000, 1.00000, missle_straight);
   CreateLittleBlueFlash ( self.origin);
   sound ( self, CHAN_WEAPON, "raven/split.wav", 1.00000, ATTN_NORM);
};


void  ()split =  {
local vector holdangles = '0.00000 0.00000 0.00000';
   create_raven_shot2 ( self.origin, -6.00000, 0.50000, 0.00000, missle_straight1);
   create_raven_shot2 ( self.origin, 6.00000, 0.50000, 0.00000, missle_straight2);
   CreateLittleBlueFlash ( self.origin);
   sound ( self, CHAN_WEAPON, "raven/split.wav", 1.00000, ATTN_NORM);
   self.dmg = 20.00000;
   holdangles = self.angles;
   holdangles_z = 0.00000;
   holdangles_x = (0.00000 - holdangles_x);
   makevectors ( holdangles);
   self.velocity = normalize ( v_forward);
   self.velocity = (self.velocity * 800.00000);
};


void  (vector dir_mod)launch_set =  {
   self.attack_finished = (time + 0.50000);
   create_raven_shot1 ( ((self.origin + self.proj_ofs) + (v_forward * 14.00000)), 0.05000, split, self.v_angle);
};


void  ()ravenstaff_power =  {
   self.wfs = advanceweaponframe ( 1.00000, 4.00000);
   self.th_weapon = ravenstaff_power;
   if ( (self.weaponframe == 1.00000) ) {

      self.punchangle_x = -4.00000;
      launch_superraven ( );
      self.greenmana -= 16.00000;
      self.bluemana -= 16.00000;
   } else {

      if ( (self.weaponframe == 4.00000) ) {

         self.weaponframe = 4.00000;
         self.th_weapon = ravenstaff_idle;

      }

   }
   AdvanceThinkTime(self,HX_FRAME_TIME);
};


void  ()ravenstaff_normal =  {
   self.wfs = advanceweaponframe ( 1.00000, 4.00000);
   self.th_weapon = ravenstaff_normal;
   if ( (self.weaponframe == 3.00000) ) {

      self.punchangle_x = -2.00000;
      launch_set ( '0.00000 0.00000 0.00000');
      self.greenmana -= 8.00000;
      self.bluemana -= 8.00000;
   } else {

      if ( (self.wfs == WF_CYCLE_WRAPPED) ) {

         self.weaponframe = 0.00000;
         self.th_weapon = ravenstaff_idle;

      }

   }
   AdvanceThinkTime(self,HX_FRAME_TIME);
};


void  ()ravenstaff_fire =  {
local vector holdvelocity = '0.00000 0.00000 0.00000';
   if ( (((self.artifact_active & ART_TOMEOFPOWER) && (self.greenmana >= 16.00000)) && (self.bluemana >= 16.00000)) ) {

      sound ( self, CHAN_WEAPON, "raven/rfire2.wav", 1.00000, ATTN_NORM);
      stuffcmd ( self, "bf\n");
      ravenstaff_power ( );
   } else {

      if ( ((self.greenmana >= 8.00000) && (self.bluemana >= 8.00000)) ) {

         stuffcmd ( self, "bf\n");
         makevectors ( self.v_angle);
         holdvelocity = normalize ( v_right);
         holdvelocity = (holdvelocity * 10.00000);
         starteffect ( CE_TELESMK1, ((self.origin + self.proj_ofs) + (v_forward * 14.00000)), holdvelocity, (HX_FRAME_TIME * 3.00000));
         starteffect ( CE_TELESMK1, ((self.origin + self.proj_ofs) + (v_forward * 14.00000)), (holdvelocity * -1.00000), (HX_FRAME_TIME * 3.00000));
         sound ( self, CHAN_WEAPON, "raven/rfire1.wav", 1.00000, ATTN_NORM);
         ravenstaff_normal ( );

      }

   }
   self.attack_finished = (time + 0.50000);
};


void  ()ravenstaff_idle =  {
   self.weaponframe = 0.00000;
   self.th_weapon = ravenstaff_idle;
};


void  ()ravenstaff_select =  {
   self.wfs = advanceweaponframe ( 5.00000, 16.00000);
   self.weaponmodel = "models/ravenstf.mdl";
   self.th_weapon = ravenstaff_select;
   if ( (self.weaponframe == 16.00000) ) {

      self.attack_finished = (time - 1.00000);
      ravenstaff_idle ( );

   }
};


void  ()ravenstaff_deselect =  {
   self.wfs = advanceweaponframe ( 16.00000, 5.00000);
   self.th_weapon = ravenstaff_deselect;
   AdvanceThinkTime(self,HX_FRAME_TIME);
   self.oldweapon = IT_WEAPON4;
   if ( (self.wfs == WF_CYCLE_WRAPPED) ) {

      W_SetCurrentAmmo ( );

   }
};



void  (vector org,float damage)Ricochet =  {
   particle4 ( org, 3.00000, random(368.00000,384.00000), PARTICLETYPE_GRAV, (damage / 2.00000));
};

entity multi_ent;
float multi_damage   =  0.00000;

void  ()ClearMultDamg =  {
   multi_ent = world;
   multi_damage = 0.00000;
};


void  ()ApplyMultDamg =  {
local float kicker = 0.00000;
local float inertia = 0.00000;
local entity loser;
local entity winner;
   if ( !multi_ent ) {

      return ;

   }
   winner = self;
   loser = multi_ent;
   kicker = ((multi_damage * 7.00000) - vlen ( (winner.origin - loser.origin)));
   if ( (kicker > 0.00000) ) {

      if ( (loser.flags & FL_ONGROUND) ) {

         loser.flags ^= FL_ONGROUND;
         loser.velocity_z = (loser.velocity_z + 150.00000);

      }
      if ( (loser.mass <= 10.00000) ) {

         inertia = 1.00000;
      } else {

         inertia = (loser.mass / 10.00000);

      }
      if ( (loser == self) ) {

         loser.velocity = (loser.velocity - (normalize ( loser.v_angle) * (kicker / inertia)));
      } else {

         loser.velocity = (loser.velocity + (normalize ( winner.v_angle) * (kicker / inertia)));

      }
      T_Damage ( loser, winner, winner, multi_damage);

   }
};


void  (entity hit,float damage)AddMultDamg =  {
   if ( !hit ) {

      return ;

   }
   if ( (hit != multi_ent) ) {

      ApplyMultDamg ( );
      multi_damage = damage;
      multi_ent = hit;
   } else {

      multi_damage = (multi_damage + damage);

   }
};


void  (float damage,vector dir)TraceHit =  {
local vector vel = '0.00000 0.00000 0.00000';
local vector org = '0.00000 0.00000 0.00000';
   vel = ((normalize ( (dir + v_factorrange ( '-1.00000 -1.00000 0.00000', '1.00000 1.00000 0.00000'))) + (2.00000 * trace_plane_normal)) * 200.00000);
   org = (trace_endpos - (dir * 4.00000));
   if ( trace_ent.takedamage ) {

      SpawnPuff ( org, (vel * 0.10000), (damage * 0.25000), trace_ent);
      AddMultDamg ( trace_ent, damage);
   } else {

      Ricochet ( org, damage);

   }
};


void  (float shotcount,vector dir,vector spread)InstantDamage =  {
local vector direction = '0.00000 0.00000 0.00000';
local vector src = '0.00000 0.00000 0.00000';
   makevectors ( self.v_angle);
   src = (((self.origin + self.proj_ofs) + '0.00000 0.00000 6.00000') + (v_forward * 10.00000));
   ClearMultDamg ( );
   while ( (shotcount > 0.00000) ) {

      direction = (dir + ((random(-1.00000,1.00000) * spread_x) * v_right));
      direction += ((random(-1.00000,1.00000) * spread_y) * v_up);
      traceline ( src, (src + (direction * 2048.00000)), FALSE, self);
      if ( (trace_fraction != 1.00000) ) {

         TraceHit ( 4.00000, direction);

      }
      shotcount = (shotcount - 1.00000);

   }
   ApplyMultDamg ( );
};


void  ()bone_shard_touch =  {
local string hitsound;
   if ( (other == self.owner) ) {

      return ;

   }
   if ( other.takedamage ) {

      hitsound = "necro/bonenhit.wav";
      T_Damage ( other, self, self.owner, self.dmg);
   } else {

      hitsound = "necro/bonenwal.wav";
      T_RadiusDamage ( self, self.owner, (self.dmg * 2.00000), self.owner);

   }
   starteffect ( CE_WHITE_SMOKE, self.origin, '0.00000 0.00000 0.00000', HX_FRAME_TIME);
   sound ( self, CHAN_WEAPON, hitsound, 1.00000, ATTN_NORM);
   particle4 ( self.origin, 3.00000, random(368.00000,384.00000), PARTICLETYPE_GRAV, (self.dmg / 2.00000));
   remove ( self);
};


void  ()fire_bone_shrapnel =  {
local vector shard_vel = '0.00000 0.00000 0.00000';
   newmis = spawn ( );
   newmis.owner = self.owner;
   newmis.movetype = MOVETYPE_BOUNCE;
   newmis.solid = SOLID_BBOX;
   newmis.touch = bone_shard_touch;
   newmis.dmg = 15.00000;
   newmis.speed = 777.00000;
   trace_fraction = 0.00000;
   trace_ent = world;
   while ( ((trace_fraction != 1.00000) && !trace_ent.takedamage) ) {

      shard_vel = random('1.00000 1.00000 1.00000','-1.00000 -1.00000 -1.00000');
      traceline ( self.origin, (self.origin + (shard_vel * 36.00000)), TRUE, self);

   }
   newmis.velocity = (shard_vel * newmis.speed);
   newmis.avelocity = random('777.00000 777.00000 777.00000','-777.00000 -777.00000 -777.00000');
   setmodel ( newmis, "models/boneshrd.mdl");
   setsize ( newmis, '0.00000 0.00000 0.00000', '0.00000 0.00000 0.00000');
   setorigin ( newmis, (self.origin + (shard_vel * 8.00000)));
};


void  ()bone_shatter =  {
local float shard_count = 0.00000;
   shard_count = 20.00000;
   while ( shard_count ) {

      fire_bone_shrapnel ( );
      shard_count -= 1.00000;

   }
};


void  ()bone_power_touch =  {
local vector randomvec = '0.00000 0.00000 0.00000';
   sound ( self, CHAN_WEAPON, "necro/bonephit.wav", 1.00000, ATTN_NORM);
   if ( other.takedamage ) {

      T_Damage ( other, self, self.owner, (self.dmg * 2.00000));
      randomvec = random('-20.00000 -20.00000 -20.00000','20.00000 20.00000 20.00000');
      starteffect ( CE_GHOST, ((self.origin - (self.movedir * 8.00000)) + randomvec), ('0.00000 0.00000 30.00000' + randomvec), 0.10000);
      randomvec = random('-20.00000 -20.00000 -20.00000','20.00000 20.00000 20.00000');
      starteffect ( CE_GHOST, ((self.origin - (self.movedir * 8.00000)) + randomvec), ('0.00000 0.00000 30.00000' + randomvec), 0.10000);
      randomvec = random('-20.00000 -20.00000 -20.00000','20.00000 20.00000 20.00000');
      starteffect ( CE_GHOST, ((self.origin - (self.movedir * 8.00000)) + randomvec), ('0.00000 0.00000 30.00000' + randomvec), 0.10000);
      randomvec = random('-20.00000 -20.00000 -20.00000','20.00000 20.00000 20.00000');
      starteffect ( CE_GHOST, ((self.origin - (self.movedir * 8.00000)) + randomvec), ('0.00000 0.00000 30.00000' + randomvec), 0.10000);

   }
   self.flags2 |= FL2_ADJUST_MON_DAM;
   T_RadiusDamage ( self, self.owner, self.dmg, other);
   self.solid = SOLID_NOT;
   bone_shatter ( );
   starteffect ( CE_BONE_EXPLOSION, (self.origin - (self.movedir * 6.00000)), '0.00000 0.00000 0.00000', HX_FRAME_TIME);
   particle4 ( self.origin, 50.00000, random(368.00000,384.00000), PARTICLETYPE_GRAV, 10.00000);
   remove ( self);
};


void  ()power_trail =  {
   if ( (self.owner.classname != "player") ) {

      bprint ( "ERROR: Bone powered owner not player!\n");

   }
   if ( (self.touch == SUB_Null) ) {

      bprint ( "ERROR: Bone powered touch is null!\n");

   }
   particle4 ( self.origin, 10.00000, random(368.00000,384.00000), PARTICLETYPE_SLOWGRAV, 3.00000);
   AdvanceThinkTime(self,0.05000);
};


void  ()bone_smoke_fade =  {
   AdvanceThinkTime(self,0.05000);
   self.abslight -= 0.05000;
   self.scale += 0.05000;
   if ( (self.abslight == 0.35000) ) {

      self.skin = 1.00000;
   } else {

      if ( (self.abslight == 0.20000) ) {

         self.skin = 2.00000;
      } else {

         if ( (self.abslight <= 0.10000) ) {

            remove ( self);

         }

      }

   }
};


void  ()MakeBoneSmoke =  {
local entity smoke;
   smoke = spawn_temp ( );
   smoke.movetype = MOVETYPE_FLYMISSILE;
   smoke.velocity = (random('0.00000 0.00000 20.00000') + (v_forward * 20.00000));
   smoke.drawflags |= (MLS_ABSLIGHT | DRF_TRANSLUCENT);
   smoke.abslight = 0.50000;
   smoke.angles = vectoangles ( v_forward);
   smoke.avelocity_x = random(-600.00000,600.00000);
   smoke.scale = 0.10000;
   setmodel ( smoke, "models/bonefx.mdl");
   setsize ( smoke, '0.00000 0.00000 0.00000', '0.00000 0.00000 0.00000');
   setorigin ( smoke, self.origin);
   smoke.think = bone_smoke_fade;
   AdvanceThinkTime(smoke,0.05000);
};


void  ()bone_smoke =  {
   self.cnt += 1.00000;
   MakeBoneSmoke ( );
   if ( (self.cnt > 3.00000) ) {

      self.nextthink = -1.00000;
   } else {

      AdvanceThinkTime(self,0.01000);

   }
};


void  (float powered_up,vector ofs)bone_fire =  {
local vector org = '0.00000 0.00000 0.00000';
   makevectors ( self.v_angle);
   newmis = spawn ( );
   newmis.owner = self;
   newmis.movetype = MOVETYPE_FLYMISSILE;
   newmis.solid = SOLID_BBOX;
   newmis.speed = 1000.00000;
   newmis.velocity = (v_forward * newmis.speed);
   org = ((((self.origin + self.proj_ofs) + (v_forward * 8.00000)) + (v_right * (ofs_y + 12.00000))) + (v_up * ofs_z));
   setorigin ( newmis, org);
   if ( powered_up ) {

      self.punchangle_x = -2.00000;
      sound ( self, CHAN_WEAPON, "necro/bonefpow.wav", 1.00000, ATTN_NORM);
      self.attack_finished = (time + 1.30000);
      newmis.dmg = 200.00000;
      newmis.frags = TRUE;
      newmis.takedamage = DAMAGE_YES;
      newmis.health = 3.00000;
      newmis.th_die = bone_shatter;
      newmis.touch = bone_power_touch;
      newmis.avelocity = random('777.00000 777.00000 777.00000','-777.00000 -777.00000 -777.00000');
      setmodel ( newmis, "models/bonelump.mdl");
      setsize ( newmis, '0.00000 0.00000 0.00000', '0.00000 0.00000 0.00000');
      newmis.think = power_trail;
      AdvanceThinkTime(newmis,0.00000);
      self.greenmana -= 10.00000;
   } else {

      newmis.speed += random(500.00000);
      newmis.dmg = 7.00000;
      newmis.touch = bone_shard_touch;
      setmodel ( newmis, "models/boneshot.mdl");
      setsize ( newmis, '0.00000 0.00000 0.00000', '0.00000 0.00000 0.00000');
      newmis.velocity += (((v_right * ofs_y) * 10.00000) + ((v_up * ofs_z) * 10.00000));
      newmis.angles = vectoangles ( newmis.velocity);
      newmis.avelocity_z = random(777.00000,-777.00000);
      newmis.think = bone_smoke;
      AdvanceThinkTime(newmis,0.06000);

   }
};


void  ()bone_normal =  {
local vector dir = '0.00000 0.00000 0.00000';
   sound ( self, CHAN_WEAPON, "necro/bonefnrm.wav", 1.00000, ATTN_NORM);
   self.effects |= EF_MUZZLEFLASH;
   makevectors ( self.v_angle);
   dir = normalize ( v_forward);
   InstantDamage ( 4.00000, dir, '0.10000 0.10000 0.10000');
   self.greenmana -= 1.00000;
   self.attack_finished = (time + 0.30000);
};


void  ()bone_fire_once =  {
local vector ofs = '0.00000 0.00000 0.00000';
   ofs_z = random(-5.00000,5.00000);
   ofs_x = random(-5.00000,5.00000);
   ofs_y = random(-5.00000,5.00000);
   bone_fire ( FALSE, ofs);
};

void  ()boneshard_ready;
void  ()Nec_Bon_Attack;

void  ()boneshard_fire =  {
   self.wfs = advanceweaponframe ( 0.00000, 11.00000);
   if ( ((self.button0 && (self.weaponframe > 2.00000)) && !(self.artifact_active & ART_TOMEOFPOWER)) ) {

      self.weaponframe = 2.00000;

   }
   self.th_weapon = boneshard_fire;
   self.last_attack = time;
   if ( (((self.wfs == WF_CYCLE_WRAPPED) || (self.greenmana < 1.00000)) || ((self.greenmana < 10.00000) && (self.artifact_active & ART_TOMEOFPOWER))) ) {

      boneshard_ready ( );
   } else {

      if ( (self.weaponframe == 2.00000) ) {

         if ( (self.artifact_active & ART_TOMEOFPOWER) ) {

            bone_fire ( TRUE, '0.00000 0.00000 0.00000');
         } else {

            bone_normal ( );

         }

      }

   }
   if ( (((random() < 0.80000) && !(self.artifact_active & ART_TOMEOFPOWER)) && (self.weaponframe <= 5.00000)) ) {

      bone_fire_once ( );

   }
};


void  ()Nec_Bon_Attack =  {
   boneshard_fire ( );
   AdvanceThinkTime(self,0.00000);
};


void  ()boneshard_jellyfingers =  {
   self.wfs = advanceweaponframe ( 39.00000, 60.00000);
   self.th_weapon = boneshard_jellyfingers;
   if ( (self.wfs == WF_CYCLE_WRAPPED) ) {

      boneshard_ready ( );

   }
};


void  ()boneshard_ready =  {
   self.weaponframe = 39.00000;
   if ( (((random() < 0.10000) && (random() < 0.30000)) && (random() < 0.50000)) ) {

      self.th_weapon = boneshard_jellyfingers;
   } else {

      self.th_weapon = boneshard_ready;

   }
};


void  ()boneshard_select =  {
   self.wfs = advanceweaponframe ( 117.00000, 111.00000);
   self.weaponmodel = "models/spllbook.mdl";
   self.th_weapon = boneshard_select;
   if ( (self.wfs == WF_CYCLE_WRAPPED) ) {

      self.attack_finished = (time - 1.00000);
      boneshard_ready ( );

   }
};


void  ()boneshard_deselect =  {
   self.wfs = advanceweaponframe ( 111.00000, 117.00000);
   self.th_weapon = boneshard_deselect;
   if ( (self.wfs == WF_CYCLE_WRAPPED) ) {

      W_SetCurrentAmmo ( );

   }
};


void  ()boneshard_select_from_mmis =  {
   self.wfs = advanceweaponframe ( 25.00000, 38.00000);
   self.weaponmodel = "models/spllbook.mdl";
   self.th_weapon = boneshard_select_from_mmis;
   if ( (self.wfs == WF_CYCLE_WRAPPED) ) {

      self.attack_finished = (time - 1.00000);
      boneshard_ready ( );

   }
};


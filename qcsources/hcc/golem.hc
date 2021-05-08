void  ()GolemInit;
void  ()GolemCUse;
void  ()GolemStand;
void  ()GolemWalk;
void  ()GolemRun;
void  ()GolemSMeleeDecide;
void  ()GolemIMeleeDecide;
void  ()GolemBMeleeDecide;
void  ()GolemPunchRight;
void  ()GolemPoundRight;
void  ()GolemSRushBegin;
void  ()GolemSRushSlide;
void  ()GolemSRushEnd;
float  (float firstFrame,float lastFrame)GolemFlinch;
void  ()GolemSPain;
void  ()GolemIPain;
void  ()GolemBPain;
void  ()GolemDie;
void  ()GolemBBeamBegin;
void  ()GolemBStomp;
void  ()GolemIMissile;
float  ()GolemBCheckBeamAttack;
float  ()GolemICheckMissileAttack;

void  ()monster_golem_stone =  {
   if ( deathmatch ) {

      remove ( self);
      return ;

   }
   precache_model2 ( "models/golem_s.mdl");
   precache_model2 ( "models/goarm.mdl");
   precache_model2 ( "models/golegs.mdl");
   precache_model2 ( "models/g-head.mdl");
   precache_sound2 ( "golem/stnfall.wav");
   precache_sound2 ( "golem/stnpain.wav");
   precache_sound2 ( "golem/slide.wav");
   precache_sound2 ( "imp/swoophit.wav");
   precache_sound2 ( "golem/dthgroan.wav");
   self.thingtype = THINGTYPE_GREYSTONE;
   setmodel ( self, "models/golem_s.mdl");
   setsize ( self, '-20.00000 -20.00000 0.00000', '20.00000 20.00000 80.00000');
   GolemInit ( );
   self.hull = HULL_PLAYER;
   self.health = 200.00000;
   self.experience_value = 125.00000;
   self.mintel = 4.00000;
   self.th_melee = GolemSMeleeDecide;
   self.th_pain = GolemSPain;
   self.view_ofs = '0.00000 0.00000 64.00000';
   walkmonster_start ( );
};


void  ()monster_golem_iron =  {
   if ( deathmatch ) {

      remove ( self);
      return ;

   }
   precache_model2 ( "models/golem_i.mdl");
   precache_model2 ( "models/goarm.mdl");
   precache_model2 ( "models/golegs.mdl");
   precache_model2 ( "models/g-head.mdl");
   precache_model2 ( "models/golemmis.mdl");
   precache_sound2 ( "golem/mtlfall.wav");
   precache_sound2 ( "golem/mtlpain.wav");
   precache_sound2 ( "golem/gbfire.wav");
   precache_sound2 ( "golem/dthgroan.wav");
   self.thingtype = THINGTYPE_METAL;
   setmodel ( self, "models/golem_i.mdl");
   setsize ( self, '-20.00000 -20.00000 0.00000', '20.00000 20.00000 80.00000');
   GolemInit ( );
   self.health = 450.00000;
   self.mintel = 6.00000;
   self.experience_value = 200.00000;
   self.th_melee = GolemIMeleeDecide;
   self.th_pain = GolemIPain;
   self.view_ofs = '0.00000 0.00000 64.00000';
   walkmonster_start ( );
};


void  ()monster_golem_bronze =  {
   if ( deathmatch ) {

      remove ( self);
      return ;

   }
   self.cnt = 0.00000;
   precache_model2 ( "models/golem_b.mdl");
   precache_model2 ( "models/goarm.mdl");
   precache_model2 ( "models/golegs.mdl");
   precache_model2 ( "models/g-head.mdl");
   precache_sound2 ( "golem/mtlfall.wav");
   precache_sound2 ( "golem/mtlpain.wav");
   precache_sound2 ( "golem/stomp.wav");
   precache_sound2 ( "golem/gbcharge.wav");
   precache_sound2 ( "golem/gbfire.wav");
   precache_sound2 ( "golem/dthgroan.wav");
   self.thingtype = THINGTYPE_METAL;
   setmodel ( self, "models/golem_b.mdl");
   setsize ( self, '-60.00000 -60.00000 0.00000', '60.00000 60.00000 190.00000');
   GolemInit ( );
   self.health = 650.00000;
   self.mintel = 8.00000;
   self.experience_value = 275.00000;
   self.th_melee = GolemBMeleeDecide;
   self.th_pain = GolemBPain;
   self.view_ofs = '0.00000 0.00000 115.00000';
   walkmonster_start ( );
};


void  ()monster_golem_crystal =  {
   if ( deathmatch ) {

      remove ( self);
      return ;

   }
   precache_model2 ( "models/golem_s.mdl");
   precache_sound2 ( "golem/stnpain.wav");
   precache_sound2 ( "golem/slide.wav");
   precache_sound2 ( "golem/dthgroan.wav");
   self.thingtype = THINGTYPE_ICE;
   setmodel ( self, "models/golem_s.mdl");
   setsize ( self, '-20.00000 -20.00000 0.00000', '20.00000 20.00000 80.00000');
   GolemInit ( );
   self.hull = HULL_PLAYER;
   self.drawflags = (DRF_TRANSLUCENT | MLS_ABSLIGHT);
   self.abslight = 1.40000;
   self.skin = GLOBAL_SKIN_ICE;
   self.health = 400.00000;
   self.experience_value = 650.00000;
   self.th_melee = GolemSMeleeDecide;
   self.th_pain = GolemSPain;
   self.use = GolemCUse;
   self.view_ofs = '0.00000 0.00000 64.00000';
   walkmonster_start ( );
   self.takedamage = DAMAGE_NO;
};


void  ()GolemInit =  {
   self.netname = "golem";
   self.flags |= FL_MONSTER;
   self.flags2 |= FL_ALIVE;
   self.solid = SOLID_SLIDEBOX;
   self.movetype = MOVETYPE_STEP;
   self.yaw_speed = 14.00000;
   self.mass = 75.00000;
   self.mintel = 2.00000;
   self.hull = HULL_GOLEM;
   self.th_stand = GolemStand;
   self.th_walk = GolemWalk;
   self.th_run = GolemRun;
   self.th_die = GolemDie;
   precache_sound2 ( "golem/awaken.wav");
   precache_sound2 ( "golem/step.wav");
   precache_sound2 ( "golem/swing.wav");
};


void  ()GolemCUse =  {
   self.takedamage = DAMAGE_YES;
   self.drawflags = (DRF_TRANSLUCENT | MLS_CRYSTALGOLEM);
};


void  ()GolemStand =  {
   AdvanceFrame( 0.00000, 21.00000);
   ai_stand ( );
   AdvanceThinkTime(self,0.20000);
};


void  ()GolemWalk =  {
   AdvanceFrame( 64.00000, 97.00000);
   if ( ((self.frame == 79.00000) || (self.frame == 96.00000)) ) {

      sound ( self, CHAN_BODY, "golem/step.wav", 1.00000, ATTN_NORM);

   }
   ai_walk ( 2.00000);
};


void  ()GolemRun =  {
local float len = 0.00000;
local float hdiff = 0.00000;
local float dist = 0.00000;
local float r = 0.00000;
   AdvanceFrame( 98.00000, 121.00000);
   check_pos_enemy ( );
   checkenemy ( );
   if ( (coop && !visible ( self.enemy)) ) {

      LocateTarget ( );

   }
   if ( ((self.classname == "monster_golem_stone") || (self.classname == "monster_golem_crystal")) ) {

      len = vlen ( (self.origin - self.enemy.origin));
      hdiff = fabs ( (self.origin_z - self.enemy.origin_z));
      if ( (((len > 50.00000) && (len < 300.00000)) && (hdiff < 80.00000)) ) {

         if ( (random() < 0.05000) ) {

            GolemSRushBegin ( );
            return ;

         }

      }
      ai_run ( 8.00000);

   }
   if ( (self.classname == "monster_golem_bronze") ) {

      dist = vlen ( (self.enemy.origin - self.origin));
      r = random(0.00000,10.00000);
      if ( (dist < 100.00000) ) {

         GolemBMeleeDecide ( );
      } else {

         if ( (((dist > 200.00000) && visible ( self.enemy)) && (r < 0.60000)) ) {

            if ( (GolemBCheckBeamAttack ( ) == 1.00000) ) {

               GolemBBeamBegin ( );

            }
         } else {

            if ( (((dist > 100.00000) && (dist < 200.00000)) && (r < 0.30000)) ) {

               GolemBStomp ( );

            }

         }

      }
      ai_run ( 8.00000);

   }
   if ( (self.classname == "monster_golem_iron") ) {

      dist = vlen ( (self.enemy.origin - self.origin));
      r = random(0.00000,10.00000);
      if ( (dist < 100.00000) ) {

         GolemBMeleeDecide ( );
      } else {

         if ( (((dist > 150.00000) && visible ( self.enemy)) && (r < 0.40000)) ) {

            if ( GolemICheckMissileAttack ( ) ) {

               GolemIMissile ( );

            }

         }

      }
      ai_run ( 5.00000);

   }
   if ( ((self.frame == 109.00000) || (self.frame == 121.00000)) ) {

      sound ( self, CHAN_BODY, "golem/step.wav", 1.00000, ATTN_NORM);

   }
};


void  (float critical)GolemDoMelee =  {
local vector delta = '0.00000 0.00000 0.00000';
local float ldmg = 0.00000;
   if ( !self.enemy ) {

      return ;

   }
   delta = (self.enemy.origin - self.origin);
   if ( (self.classname == "monster_golem_bronze") ) {

      if ( (vlen ( delta) > 100.00000) ) {

         return ;

      }
      ldmg = random(15.00000);
   } else {

      if ( (self.classname == "monster_golem_iron") ) {

         if ( (vlen ( delta) > 80.00000) ) {

            return ;

         }
         ldmg = random(12.00000);
      } else {

         ldmg = random(8.00000);
         if ( (vlen ( delta) > 60.00000) ) {

            return ;

         }

      }

   }
   if ( critical ) {

      ldmg = (ldmg * 1.50000);

   }
   if ( (self.attack_finished < time) ) {

      sound ( self, CHAN_BODY, "imp/swoophit.wav", 1.00000, ATTN_NORM);
      self.attack_finished = (time + 1.00000);

   }
   if ( ((((self.enemy.health - ldmg) <= 0.00000) && critical) && (self.enemy.flags2 & FL_ALIVE)) ) {

      self.enemy.decap = 2.00000;

   }
   T_Damage ( self.enemy, self, self, ldmg);
};


void  ()GolemSMeleeDecide =  {
   if ( (random() < 0.50000) ) {

      GolemPunchRight ( );
   } else {

      GolemPoundRight ( );

   }
};


void  ()GolemIMissileTouch =  {
   if ( ((other.health > 0.00000) && (other.flags & FL_ALIVE)) ) {

      T_Damage ( other, self, self.owner, random(13.00000,17.00000));

   }
   remove ( self);
};


void  ()GolemIMissileThink =  {
   if ( (self.count > time) ) {

      HomeThink ( );

   }
   particle4 ( self.origin, 20.00000, random(128.00000,143.00000), PARTICLETYPE_GRAV, 4.00000);
   self.angles = vectoangles ( self.velocity);
   self.think = GolemIMissileThink;
   AdvanceThinkTime(self,0.10000);
};


void  (vector vect,vector offset,float vel)GolemISpawnMissile =  {
local entity missile;
local vector vec = '0.00000 0.00000 0.00000';
   self.last_attack = time;
   missile = spawn ( );
   missile.classname = "golem_iron_proj";
   missile.owner = self;
   missile.goalentity = self.enemy;
   missile.enemy = self.enemy;
   missile.movetype = MOVETYPE_FLYMISSILE;
   missile.solid = SOLID_BBOX;
   missile.yaw_speed = 3.00000;
   missile.drawflags |= (MLS_POWERMODE | SCALE_TYPE_UNIFORM);
   missile.scale = 2.50000;
   setmodel ( missile, "models/golemmis.mdl");
   setsize ( missile, '0.00000 0.00000 0.00000', '0.00000 0.00000 0.00000');
   makevectors ( self.angles);
   setorigin ( missile, (self.origin + offset));
   vec = ((self.enemy.origin - missile.origin) + self.enemy.view_ofs);
   vec = normalize ( vec);
   vec += vect;
   missile.speed = 300.00000;
   missile.velocity = (vec * (300.00000 - random(vel)));
   missile.angles = vectoangles ( missile.velocity);
   missile.touch = GolemIMissileTouch;
   missile.think = GolemIMissileThink;
   missile.veer = 0.00000;
   missile.turn_time = 0.50000;
   missile.hoverz = TRUE;
   missile.ideal_yaw = TRUE;
   missile.count = (time + 2.00000);
   AdvanceThinkTime(missile,0.20000);
};


void  ()GolemIMissile =  {
local vector vect = '0.00000 0.00000 0.00000';
   AdvanceFrame( 192.00000, 215.00000);
   ai_face ( );
   makevectors ( self.angles);
   if ( (self.frame == 192.00000) ) {

      self.colormap = (128.00000 + 16.00000);

   }
   if ( (self.frame == 192.00000) ) {

      vect = (self.origin + (v_forward * 16.00000));
      particle4 ( (vect + '0.00000 0.00000 90.00000'), 15.00000, (256.00000 + random(128.00000,143.00000)), PARTICLETYPE_GRAV, 10.00000);

   }
   self.colormap -= 0.50000;
   if ( ((self.frame == 208.00000) && FacingIdeal ( )) ) {

      sound ( self, CHAN_WEAPON, "golem/gbfire.wav", 1.00000, ATTN_NORM);
      GolemISpawnMissile ( '0.00000 0.00000 0.00000', '0.00000 0.00000 75.00000', 100.00000);
      self.think = self.th_run;
      self.colormap = 0.00000;
      AdvanceThinkTime(self,0.10000);

   }
};


void  ()GolemIMeleeDecide =  {
   if ( (random() < 0.50000) ) {

      GolemPunchRight ( );
   } else {

      GolemPoundRight ( );

   }
};


void  ()GolemBMeleeDecide =  {
   if ( (random() < 0.50000) ) {

      GolemPunchRight ( );
   } else {

      GolemPoundRight ( );

   }
};


void  ()GolemPunchRight =  {
local vector checkPos = '0.00000 0.00000 0.00000';
   AdvanceFrame( 122.00000, 145.00000);
   if ( cycle_wrapped ) {

      GolemRun ( );
      return ;

   }
   if ( (self.frame == 131.00000) ) {

      sound ( self, CHAN_BODY, "golem/step.wav", 1.00000, ATTN_NORM);
      sound ( self, CHAN_WEAPON, "golem/swing.wav", 1.00000, ATTN_NORM);
   } else {

      if ( (self.frame == 145.00000) ) {

         sound ( self, CHAN_BODY, "golem/step.wav", 1.00000, ATTN_NORM);

      }

   }
   ai_face ( );
   if ( !walkmove ( self.angles_y, 8.00000, TRUE) ) {

      if ( (trace_ent.health <= 0.00000) ) {

         return ;

      }

   }
   if ( ((self.frame > 131.00000) && (self.frame < 137.00000)) ) {

      makevectors ( self.enemy.angles);
      checkPos = (self.enemy.origin + (v_forward * -24.00000));
      checkPos_z = (self.enemy.origin_z + self.enemy.view_ofs_z);
      traceline ( self.enemy.origin, checkPos, FALSE, self.enemy);
      if ( ((trace_fraction < 1.00000) && !(trace_ent.flags2 & FL_ALIVE)) ) {

         GolemDoMelee ( 1.00000);
      } else {

         GolemDoMelee ( 0.00000);

      }

   }
};


void  ()GolemPoundRight =  {
local vector checkPos = '0.00000 0.00000 0.00000';
   AdvanceFrame( 146.00000, 169.00000);
   if ( cycle_wrapped ) {

      GolemRun ( );
      return ;

   }
   if ( (self.frame == 155.00000) ) {

      sound ( self, CHAN_BODY, "golem/step.wav", 1.00000, ATTN_NORM);
      sound ( self, CHAN_WEAPON, "golem/swing.wav", 1.00000, ATTN_NORM);
   } else {

      if ( (self.frame == 169.00000) ) {

         sound ( self, CHAN_BODY, "golem/step.wav", 1.00000, ATTN_NORM);

      }

   }
   ai_face ( );
   if ( !walkmove ( self.angles_y, 10.00000, TRUE) ) {

      if ( (trace_ent.health <= 0.00000) ) {

         return ;

      }

   }
   if ( ((self.frame > 155.00000) && (self.frame < 161.00000)) ) {

      makevectors ( self.enemy.angles);
      checkPos = (self.enemy.origin + (v_forward * -24.00000));
      checkPos_z = (self.enemy.origin_z + self.enemy.view_ofs_z);
      traceline ( self.enemy.origin, checkPos, FALSE, self.enemy);
      if ( (trace_fraction < 1.00000) ) {

         GolemDoMelee ( 1.00000);
      } else {

         GolemDoMelee ( 0.00000);

      }

   }
};


void  ()GolemSRushBegin =  {
   AdvanceFrame( 192.00000, 203.00000);
   if ( (self.frame == 203.00000) ) {

      self.golemSlideCounter = 8.00000;
      self.think = GolemSRushSlide;
      sound ( self, CHAN_WEAPON, "golem/slide.wav", 1.00000, ATTN_NORM);
   } else {

      if ( (self.frame == 201.00000) ) {

         sound ( self, CHAN_BODY, "golem/step.wav", 1.00000, ATTN_NORM);

      }

   }
   ai_face ( );
   if ( !walkmove ( self.angles_y, 5.00000, TRUE) ) {

      if ( (trace_ent.health <= 0.00000) ) {

         return ;

      }

   }
};


void  ()GolemSRushSlide =  [203.0, GolemSRushSlide] {
   if ( walkmove ( self.angles_y, 20.00000, FALSE) ) {

      if ( (random() < 0.20000) ) {

         CreateWhiteSmoke ( self.origin, '0.00000 0.00000 8.00000', (HX_FRAME_TIME * 2.00000));

      }
   } else {

      self.think = GolemSRushEnd;
      return ;

   }
   self.golemSlideCounter -= 1.00000;
   if ( (self.golemSlideCounter < 0.00000) ) {

      self.think = GolemSRushEnd;

   }
};


float  ()GolemBCheckBeamAttack =  {
local vector p1 = '0.00000 0.00000 0.00000';
local vector p2 = '0.00000 0.00000 0.00000';
local vector off = '0.00000 0.00000 0.00000';
local float dist = 0.00000;
   makevectors ( self.angles);
   dist = vlen ( (self.enemy.origin - self.origin));
   off = ((v_forward * 15.00000) + (v_right * 1.00000));
   p1 = ((self.origin + '0.00000 0.00000 92.00000') + off);
   p2 = (p1 + (v_forward * dist));
   p2_z = (self.enemy.origin_z + self.enemy.proj_ofs_z);
   traceline ( p1, p2, FALSE, self);
   if ( (trace_ent == self.enemy) ) {

      return ( 1.00000 );

   }
   return ( 0.00000 );
};


float  ()GolemICheckMissileAttack =  {
local vector p1 = '0.00000 0.00000 0.00000';
local vector p2 = '0.00000 0.00000 0.00000';
local vector off = '0.00000 0.00000 0.00000';
local float dist = 0.00000;
   makevectors ( self.angles);
   dist = vlen ( (self.enemy.origin - self.origin));
   off = ((v_forward * 15.00000) + (v_right * 1.00000));
   p1 = ((self.origin + '0.00000 0.00000 92.00000') + off);
   p2 = (p1 + (v_forward * dist));
   p2_z = (self.enemy.origin_z + self.enemy.proj_ofs_z);
   traceline ( p1, p2, FALSE, self);
   if ( (trace_ent == self.enemy) ) {

      return ( 1.00000 );

   }
   return ( 0.00000 );
};


void  ()GolemBBeamFinish =  {
   AdvanceFrame( 209.00000, 215.00000);
   if ( (self.frame == 215.00000) ) {

      self.colormap = 0.00000;
      self.think = self.th_run;
      AdvanceThinkTime(self,0.10000);
      return ;

   }
};


void  (float offset,float damage)GolemDoBeam =  {
local vector p1 = '0.00000 0.00000 0.00000';
local vector p2 = '0.00000 0.00000 0.00000';
local vector off = '0.00000 0.00000 0.00000';
local vector dir = '0.00000 0.00000 0.00000';
local float dist = 0.00000;
   makevectors ( self.angles);
   dist = vlen ( (self.enemy.origin - self.origin));
   off = ((v_forward * 15.00000) + (v_right * 1.00000));
   p1 = ((self.origin + '0.00000 0.00000 92.00000') + off);
   dist = vlen ( (((p1 - self.enemy.origin) + self.enemy.proj_ofs) - '0.00000 0.00000 6.00000'));
   dir = normalize ( ((v_forward * 100.00000) + (v_right * offset)));
   p2 = (p1 + (dir * dist));
   p2_z = ((self.enemy.origin_z + self.enemy.proj_ofs_z) - 6.00000);
   dir = normalize ( (p2 - p1));
   traceline ( p1, (p2 + (dir * (dist / 2.00000))), FALSE, self);
   if ( ((trace_ent != world) && (trace_ent.health > 0.00000)) ) {

      sound ( trace_ent, CHAN_AUTO, "crusader/sunhit.wav", 1.00000, ATTN_NORM);
      if ( ((trace_ent.health - damage) <= 0.00000) ) {

         trace_ent.decap = TRUE;

      }
      if ( (trace_ent.flags & FL_MONSTER) ) {

         T_Damage ( trace_ent, self, self, (damage / 2.00000));
      } else {

         T_Damage ( trace_ent, self, self, damage);

      }

   }
   SpawnPuff ( trace_endpos, '0.00000 0.00000 10.00000', 1.00000, trace_ent);
   WriteByte ( MSG_BROADCAST, SVC_TEMPENTITY);
   WriteByte ( MSG_BROADCAST, TE_STREAM_COLORBEAM);
   WriteEntity ( MSG_BROADCAST, self);
   WriteByte ( MSG_BROADCAST, 0.00000);
   WriteByte ( MSG_BROADCAST, 1.00000);
   WriteByte ( MSG_BROADCAST, 2.00000);
   WriteCoord ( MSG_BROADCAST, p1_x);
   WriteCoord ( MSG_BROADCAST, p1_y);
   WriteCoord ( MSG_BROADCAST, p1_z);
   WriteCoord ( MSG_BROADCAST, trace_endpos_x);
   WriteCoord ( MSG_BROADCAST, trace_endpos_y);
   WriteCoord ( MSG_BROADCAST, trace_endpos_z);
};


void  ()GolemBBeamFireArch1 =  [209.0, GolemBBeamFireArch1] {
   if ( (self.golemBeamDelay < time) ) {

      self.think = GolemBBeamFinish;
      AdvanceThinkTime(self,0.10000);
      return ;

   }
   self.golemBeamOff1 += 5.00000;
   GolemDoBeam ( self.golemBeamOff1, random(7.00000,12.00000));
};


void  ()GolemBBeamFireArch2 =  [209.0, GolemBBeamFireArch2] {
   if ( (self.golemBeamDelay < time) ) {

      self.think = GolemBBeamFinish;
      AdvanceThinkTime(self,0.10000);
      return ;

   }
   if ( !self.golemBeamOff2 ) {

      self.golemBeamOff1 += 10.00000;
   } else {

      self.golemBeamOff1 -= 10.00000;

   }
   if ( (self.golemBeamOff1 == 100.00000) ) {

      self.golemBeamOff2 = 1.00000;

   }
   GolemDoBeam ( self.golemBeamOff1, random(7.00000,12.00000));
};


void  ()GolemBBeamFire =  {
local float r = 0.00000;
   AdvanceFrame( 202.00000, 209.00000);
   ai_face ( );
   if ( (self.frame == 209.00000) ) {

      r = random();
      visible ( self.enemy);
      if ( (FacingIdeal ( ) && FacingIdeal ( )) ) {

         sound ( self, CHAN_WEAPON, "golem/gbfire.wav", 1.00000, ATTN_NORM);
         if ( (r < 0.50000) ) {

            self.golemBeamDelay = (time + 2.00000);
            self.golemBeamOff1 = -100.00000;
            self.think = GolemBBeamFireArch1;
            AdvanceThinkTime(self,0.10000);
         } else {

            self.golemBeamDelay = (time + 2.00000);
            self.golemBeamOff1 = -100.00000;
            self.golemBeamOff2 = 0.00000;
            self.think = GolemBBeamFireArch2;
            AdvanceThinkTime(self,0.10000);

         }
      } else {

         self.think = self.th_run;
         AdvanceThinkTime(self,0.10000);

      }

   }
};


void  ()GolemBBeamPause =  [202.0, GolemBBeamPause] {
   if ( ((self.golemBeamDelay < time) && !self.cnt) ) {

      self.golemBeamDelay = (time + 0.50000);
      self.cnt = 1.00000;
      self.colormap = (176.00000 + 16.00000);

   }
   self.colormap -= 1.00000;
   if ( (self.golemBeamDelay > time) ) {

      particle4 ( (self.origin + self.view_ofs), 5.00000, (185.00000 + random(6.00000)), PARTICLETYPE_SLOWGRAV, 1.00000);
      ai_face ( );
      return ;

   }
   self.cnt = 0.00000;
   GolemBBeamFire ( );
};


void  ()GolemBBeamBegin =  {
   AdvanceFrame( 192.00000, 202.00000);
   sound ( self, CHAN_WEAPON, "golem/gbcharge.wav", 1.00000, ATTN_NORM);
   if ( (self.frame == 202.00000) ) {

      AdvanceThinkTime(self,0.10000);
      self.think = GolemBBeamPause;

   }
};


void  ()GolemBStompEffect =  {
local float dist = 0.00000;
   dist = vlen ( (self.enemy.origin - self.origin));
   MonsterQuake ( 350.00000);
   if ( (dist < 350.00000) ) {

      T_Damage ( self.enemy, self, self, random((50.00000 / dist)));

   }
};


void  ()GolemBStomp =  {
local float numPuffs = 0.00000;
local vector vect = '0.00000 0.00000 0.00000';
   AdvanceFrame( 216.00000, 239.00000);
   if ( (self.frame == 228.00000) ) {

      sound ( self, CHAN_BODY, "golem/stomp.wav", 1.00000, ATTN_NORM);
      numPuffs = random(4.00000,10.00000);
      makevectors ( self.angles);
      while ( (numPuffs > 0.00000) ) {

         vect_x = self.origin_x;
         vect_y = self.origin_y;
         vect_z = self.absmin_z;
         vect_z += (v_up_z * 3.00000);
         vect_x += (v_forward_x * random(0.00000,self.size_x));
         vect_y += (v_forward_y * random(0.00000,self.size_y));
         particle4 ( vect, (20.00000 + random(1.00000,10.00000)), (256.00000 + random(90.00000,95.00000)), PARTICLETYPE_GRAV, 30.00000);
         numPuffs -= 1.00000;

      }
      GolemBStompEffect ( );

   }
   if ( (self.frame == 239.00000) ) {

      self.think = self.th_run;
      AdvanceThinkTime(self,0.10000);

   }
};


void  ()GolemICheckRushDamage =  {
local float r = 0.00000;
local float damage = 0.00000;
   if ( !self.enemy ) {

      return ;

   }
   r = vlen ( (self.enemy.origin - self.origin));
   damage = random(20.00000,30.00000);
   if ( (infront ( self.enemy) && (r < 60.00000)) ) {

      sound ( self, CHAN_BODY, "imp/swoophit.wav", 1.00000, ATTN_NORM);
      makevectors ( self.angles);
      self.enemy.flags ^= FL_ONGROUND;
      self.enemy.velocity = (v_forward * (damage * 20.00000));
      self.enemy.velocity_z = random(300.00000,350.00000);
      T_Damage ( self.enemy, self, self, damage);

   }
};


void  ()GolemSRushEnd =  {
   AdvanceFrame( 204.00000, 215.00000);
   if ( cycle_wrapped ) {

      GolemRun ( );
      return ;

   }
   if ( (self.frame == 206.00000) ) {

      GolemICheckRushDamage ( );

   }
   if ( (self.frame == 215.00000) ) {

      sound ( self, CHAN_BODY, "golem/step.wav", 1.00000, ATTN_NORM);

   }
   ai_face ( );
   if ( !walkmove ( self.angles_y, 4.00000, TRUE) ) {

      if ( (trace_ent.health <= 0.00000) ) {

         return ;

      }

   }
};


float  (float firstFrame,float lastFrame)GolemFlinch =  {
   if ( ((self.frame < firstFrame) || (self.frame > lastFrame)) ) {

      return ( 0.00000 );

   }
   self.nextthink += (0.10000 + (random() * 0.20000));
   self.frame = ((self.frame - 8.00000) - rint ( (random() * 12.00000)));
   self.pain_finished = (time + 1.00000);
   if ( (self.frame < firstFrame) ) {

      self.frame = ((lastFrame + 1.00000) - (firstFrame - self.frame));

   }
   return ( 1.00000 );
};


void  ()GolemSPain =  {
   if ( (self.pain_finished > time) ) {

      return ;

   }
};


void  ()GolemIPain =  {
   if ( (self.pain_finished > time) ) {

      return ;

   }
};


void  ()GolemBPain =  {
   if ( (self.pain_finished > time) ) {

      return ;

   }
};


float  ()GolemCheckSolidGround =  {
local vector p1 = '0.00000 0.00000 0.00000';
local vector p2 = '0.00000 0.00000 0.00000';
local vector p3 = '0.00000 0.00000 0.00000';
local vector p4 = '0.00000 0.00000 0.00000';
local vector destin = '0.00000 0.00000 0.00000';
local float numSolid = 4.00000;
   makevectors ( self.angles);
   p1 = (self.origin + (v_forward * (self.size_y * 0.80000)));
   p2 = (self.origin - (v_forward * (self.size_y * 0.80000)));
   p3 = (self.origin + (v_right * (self.size_x * 0.50000)));
   p4 = (self.origin - (v_right * (self.size_x * 0.50000)));
   destin = (p1 - (v_up * self.size_y));
   traceline ( p1, destin, FALSE, self);
   if ( (trace_fraction == 1.00000) ) {

      numSolid -= 1.00000;

   }
   destin = (p2 - (v_up * self.size_y));
   traceline ( p2, destin, FALSE, self);
   if ( (trace_fraction == 1.00000) ) {

      numSolid -= 1.00000;

   }
   destin = (p3 - (v_up * self.size_y));
   traceline ( p3, destin, FALSE, self);
   if ( (trace_fraction == 1.00000) ) {

      numSolid -= 1.00000;

   }
   destin = (p4 - (v_up * 2.00000));
   traceline ( p4, destin, FALSE, self);
   if ( (trace_fraction == 1.00000) ) {

      numSolid -= 1.00000;

   }
   if ( (numSolid < 3.00000) ) {

      return ( 0.00000 );

   }
   return ( 1.00000 );
};


void  (string gibname,vector pos,vector vel)GolemChunkPlace =  {
local entity new;
   makevectors ( self.angles);
   new = spawn ( );
   new.origin = pos;
   setmodel ( new, gibname);
   setsize ( new, '0.00000 0.00000 0.00000', '0.00000 0.00000 0.00000');
   new.velocity = vel;
   new.movetype = MOVETYPE_BOUNCE;
   new.solid = SOLID_NOT;
   new.angles = self.angles;
   if ( (gibname != "models/golegs.mdl") ) {

      new.avelocity_y = random(100.00000,500.00000);
      new.velocity_x += random((v_forward_x * 100.00000),(v_forward_x * 300.00000));
      new.velocity_y += random((v_forward_y * 100.00000),(v_forward_y * 300.00000));
      new.velocity_z += random((v_forward_z * 350.00000),(v_forward_z * 600.00000));
      new.flags ^= FL_ONGROUND;

   }
   if ( (self.classname == "monster_golem_crystal") ) {

      new.drawflags = (DRF_TRANSLUCENT | MLS_ABSLIGHT);
      new.abslight = 1.40000;
      new.skin = GLOBAL_SKIN_ICE;

   }
   if ( (self.classname == "monster_golem_stone") ) {

      new.skin = 0.00000;

   }
   if ( (self.classname == "monster_golem_iron") ) {

      new.scale = 1.50000;
      new.skin = 1.00000;

   }
   if ( (self.classname == "monster_golem_bronze") ) {

      new.scale = 2.00000;
      new.skin = 2.00000;

   }
   new.think = SUB_Remove;
   new.ltime = time;
   new.nextthink = ((time + 10.00000) + (random() * 10.00000));
   new.frame = 0.00000;
   new.flags = 0.00000;
};


void  ()GolemChunkDeath =  {
local float numPuffs = 0.00000;
local vector vect = '0.00000 0.00000 0.00000';
local vector dir = '0.00000 0.00000 0.00000';
   makevectors ( self.angles);
   dir = (v_right * random(150.00000,200.00000));
   dir_z = random(100.00000,300.00000);
   GolemChunkPlace ( "models/goarm.mdl", (self.origin + (v_right * 16.00000)), dir);
   dir = ((v_right * random(150.00000,200.00000)) * -1.00000);
   dir_z = random(100.00000,300.00000);
   GolemChunkPlace ( "models/goarm.mdl", (self.origin + (v_right * -16.00000)), dir);
   GolemChunkPlace ( "models/golegs.mdl", (self.origin + (v_forward * -12.00000)), '0.00000 0.00000 0.00000');
   GolemChunkPlace ( "models/g-head.mdl", (self.origin + (v_forward * random(10.00000,20.00000))), '0.00000 0.00000 250.00000');
   numPuffs = random(4.00000,10.00000);
   while ( (numPuffs > 0.00000) ) {

      vect = self.origin;
      vect_z += (v_up_z * 4.00000);
      vect_x += (v_forward_x * random(0.00000,self.size_x));
      vect_y += (v_forward_y * random(0.00000,self.size_y));
      particle4 ( vect, (20.00000 + random(1.00000,10.00000)), (256.00000 + random(90.00000,95.00000)), PARTICLETYPE_GRAV, 10.00000);
      numPuffs -= 1.00000;

   }
   if ( (self.classname == "monster_golem_crystal") ) {

      self.thingtype = THINGTYPE_ICE;

   }
   self.think = chunk_death;
   AdvanceThinkTime(self,0.10000);
};


void  ()GolemDeathFinish =  {
   AdvanceFrame( 181.00000, 191.00000);
   if ( (self.frame == 191.00000) ) {

      self.nextthink = -1.00000;
      if ( ((self.classname == "monster_golem_stone") || (self.classname == "monster_golem_crystal")) ) {

         sound ( self, CHAN_BODY, "golem/stnfall.wav", 1.00000, ATTN_NORM);
      } else {

         if ( (self.classname == "monster_golem_iron") ) {

            sound ( self, CHAN_BODY, "golem/mtlfall.wav", 1.00000, ATTN_NORM);
         } else {

            sound ( self, CHAN_BODY, "golem/mtlfall.wav", 1.00000, ATTN_NORM);

         }

      }
      if ( GolemCheckSolidGround ( ) ) {

         GolemChunkDeath ( );
      } else {

         self.think = chunk_death;
         AdvanceThinkTime(self,0.10000);

      }
      return ;

   }
   if ( (self.frame == 185.00000) ) {

      self.solid = SOLID_NOT;

   }
   if ( (self.frame > 185.00000) ) {

      makevectors ( self.angles);
      self.origin += (v_forward * 4.00000);

   }
   if ( (self.health < -50.00000) ) {

      self.think = chunk_death;

   }
   AdvanceThinkTime(self,0.07000);
};


void  ()GolemDeathPause =  [180.0, GolemDeathPause] {
local vector vect = '0.00000 0.00000 0.00000';
   if ( ((self.cnt - time) == 1.00000) ) {

      sound ( self, CHAN_BODY, "golem/dthgroan.wav", 1.00000, ATTN_NORM);
      if ( (self.classname == "monster_golem_bronze") ) {

         makevectors ( self.angles);
         vect = (self.origin + (v_forward * (self.size_x / 2.00000)));
         particle4 ( (vect + '0.00000 0.00000 80.00000'), 15.00000, (256.00000 + random(184.00000,191.00000)), PARTICLETYPE_GRAV, 10.00000);

      }
      if ( (self.classname == "monster_golem_iron") ) {

         makevectors ( self.angles);
         vect = (self.origin + (v_forward * (self.size_x / 2.00000)));
         particle4 ( (vect + '0.00000 0.00000 70.00000'), 15.00000, (256.00000 + random(128.00000,143.00000)), PARTICLETYPE_GRAV, 10.00000);

      }

   }
   if ( (self.cnt < time) ) {

      GolemDeathFinish ( );

   }
};


void  ()GolemDie =  {
   AdvanceFrame( 170.00000, 180.00000);
   self.colormap = 0.00000;
   if ( (self.frame == 180.00000) ) {

      if ( ((self.classname == "monster_golem_bronze") || (self.classname == "monster_golem_iron")) ) {

         sound ( self, CHAN_BODY, "golem/mtlpain.wav", 1.00000, ATTN_NORM);
      } else {

         sound ( self, CHAN_BODY, "golem/stnpain.wav", 1.00000, ATTN_NORM);

      }
      self.cnt = (time + 1.00000);
      GolemDeathPause ( );

   }
};


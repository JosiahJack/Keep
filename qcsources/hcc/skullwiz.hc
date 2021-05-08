void  ()skullwiz_walk;
void  ()skullwiz_run;
void  ()skullwiz_melee;
void  ()skullwiz_blink;
void  ()skullwiz_push;
void  ()skullwiz_missile_init;
float SKULLBOOK   =  0.00000;
float SKULLHEAD   =  1.00000;

float  ()SkullFacingIdeal =  {
local float delta = 0.00000;
   delta = anglemod ( (self.angles_y - self.ideal_yaw));
   if ( ((delta > 25.00000) && (delta < 335.00000)) ) {

      return ( FALSE );

   }
   return ( TRUE );
};


void  ()phase_init =  {
local vector spot1 = '0.00000 0.00000 0.00000';
local vector newangle = '0.00000 0.00000 0.00000';
local float loop_cnt = 0.00000;
local float forward = 0.00000;
   trace_fraction = 0.00000;
   loop_cnt = 0.00000;
   do {

      newangle = self.angles;
      newangle_y = random(0.00000,360.00000);
      makevectors ( newangle);
      forward = random(40.00000,100.00000);
      spot1 = (self.origin + (v_forward * forward));
      tracearea ( spot1, (spot1 + (v_up * 80.00000)), '-32.00000 -32.00000 -10.00000', '32.00000 32.00000 46.00000', FALSE, self);
      if ( ((trace_fraction == 1.00000) && !trace_allsolid) ) {

         traceline ( spot1, (spot1 + (v_up * -4.00000)), FALSE, self);
         if ( (trace_fraction == 1.00000) ) {

            trace_fraction = 0.00000;
         } else {

            trace_fraction = 1.00000;

         }
      } else {

         trace_fraction = 0.00000;

      }
      loop_cnt += 1.00000;
      if ( (loop_cnt > 500.00000) ) {

         self.nextthink = (time + 2.00000);
         return ;

      }
   } while ( (trace_fraction != 1.00000) );
   self.origin = spot1;
};


float  ()check_defense_blink =  {
local vector spot1 = '0.00000 0.00000 0.00000';
local vector spot2 = '0.00000 0.00000 0.00000';
local vector dangerous_dir = '0.00000 0.00000 0.00000';
local float dot = 0.00000;
   if ( !self.enemy ) {

      return ( FALSE );

   }
   if ( !visible ( self.enemy) ) {

      return ( FALSE );

   }
   if ( (self.enemy.last_attack < (time - 0.50000)) ) {

      return ( FALSE );

   }
   spot1 = (self.enemy.origin + self.enemy.proj_ofs);
   spot2 = ((self.absmin + self.absmax) * 0.50000);
   dangerous_dir = normalize ( (spot2 - spot1));
   if ( (self.enemy.classname == "player") ) {

      makevectors ( self.enemy.v_angle);
   } else {

      makevectors ( self.enemy.angles);

   }
   dot = (dangerous_dir * v_forward);
   if ( (dot > 0.80000) ) {

      return ( TRUE );
   } else {

      return ( FALSE );

   }
};


void  (float part)skullwiz_throw =  {
local entity new;
   new = spawn ( );
   if ( (part == SKULLBOOK) ) {

      setmodel ( new, "models/skulbook.mdl");
   } else {

      setmodel ( new, "models/skulhead.mdl");

   }
   new.origin_x = random(10.00000,10.00000);
   new.origin_y = random(10.00000,10.00000);
   new.origin_z = 40.00000;
   setorigin ( new, (self.origin + new.origin));
   setsize ( new, '0.00000 0.00000 0.00000', '0.00000 0.00000 0.00000');
   new.velocity_z = random(100.00000,150.00000);
   new.velocity_x = random(100.00000,150.00000);
   new.velocity_y = random(100.00000,150.00000);
   new.movetype = MOVETYPE_BOUNCE;
   new.solid = SOLID_NOT;
   new.avelocity_x = random(400.00000,600.00000);
   new.avelocity_y = random(400.00000,600.00000);
   new.avelocity_z = random(400.00000,600.00000);
   new.flags ^= FL_ONGROUND;
   new.think = MakeSolidCorpse;
   new.nextthink = (time + (HX_FRAME_TIME * 15.00000));
};

void  ()skullwiz_summon;

void  (float spawn_side)spider_spawn =  {
   newmis = spawn ( );
   newmis.cnt = spawn_side;
   newmis.flags2 = FL_SUMMONED;
   newmis.nextthink = (time + 0.01000);
   newmis.think = skullwiz_summon;
   newmis.origin = self.origin;
   newmis.controller = self;
   newmis.angles = self.angles;
};


void  ()skullwiz_die =  {
local entity newent;
local entity holdent;
   AdvanceFrame( 0.00000, 14.00000);
   AdvanceThinkTime(self,(HX_FRAME_TIME * 1.50000));
   self.scale = 1.00000;
   if ( (self.frame == 0.00000) ) {

      self.solid = SOLID_NOT;
      CreateWhiteSmoke ( (self.origin + '0.00000 0.00000 20.00000'), '0.00000 0.00000 12.00000', (HX_FRAME_TIME * 10.00000));
      CreateWhiteSmoke ( (self.origin + '0.00000 0.00000 20.00000'), '0.00000 8.00000 8.00000', (HX_FRAME_TIME * 10.00000));
      CreateWhiteSmoke ( (self.origin + '0.00000 0.00000 20.00000'), '0.00000 -8.00000 8.00000', (HX_FRAME_TIME * 10.00000));
      if ( (self.classname == "monster_skull_wizard") ) {

         sound ( self, CHAN_VOICE, "skullwiz/death.wav", 1.00000, ATTN_NORM);
      } else {

         sound ( self, CHAN_VOICE, "skullwiz/death2.wav", 1.00000, ATTN_NORM);

      }
      spider_spawn ( 0.00000);
      if ( (random() < 0.50000) ) {

         spider_spawn ( 1.00000);

      }

   }
   if ( (self.frame == 5.00000) ) {

      skullwiz_throw ( SKULLBOOK);

   }
   if ( (self.frame == 6.00000) ) {

      setorigin ( self, (self.origin + '0.00000 0.00000 10.00000'));
      self.flags ^= FL_ONGROUND;
      self.velocity_z = random(100.00000,150.00000);
      self.velocity_x = random(100.00000,150.00000);
      self.velocity_y = random(100.00000,150.00000);
      self.avelocity_x = random(400.00000,600.00000);
      self.avelocity_y = random(400.00000,600.00000);
      self.avelocity_z = random(400.00000,600.00000);
      self.mass = 99999.00000;

   }
   if ( (self.frame == 7.00000) ) {

      skullwiz_throw ( SKULLHEAD);

   }
   if ( (self.frame == 14.00000) ) {

      if ( (self.classname == "monster_skull_wizard_lord") ) {

         newent = spawn ( );
         setorigin ( newent, (self.origin + '0.00000 0.00000 16.00000'));
         newent.lifespan = random(10.00000,15.00000);
         newent.lifetime = (time + newent.lifespan);
         newent.thingtype = GREY_PUFF;
         newent.wait = 1.50000;
         holdent = self;
         self = newent;
         fx_smoke_generator ( );
         self = holdent;

      }
      MakeSolidCorpse ( );

   }
};


void  ()spider_grow =  {
   AdvanceThinkTime(self,HX_FRAME_TIME);
   self.think = spider_grow;
   self.scale += 0.03000;
   if ( (self.scale >= 0.50000) ) {

      walkmonster_start ( );

   }
};


void  ()skullwiz_summon =  {
local vector newangle = '0.00000 0.00000 0.00000';
local vector spot1 = '0.00000 0.00000 0.00000';
local vector spot2 = '0.00000 0.00000 0.00000';
local vector spot3 = '0.00000 0.00000 0.00000';
local float loop_cnt = 0.00000;
   setmodel ( self, "models/spider.mdl");
   self.solid = SOLID_SLIDEBOX;
   self.movetype = MOVETYPE_STEP;
   self.drawflags = SCALE_ORIGIN_BOTTOM;
   self.flags2 = FL_SUMMONED;
   self.yaw_speed = 10.00000;
   self.mass = 1.00000;
   self.speed = 5.00000;
   setsize ( self, '-7.00000 -7.00000 0.00000', '7.00000 7.00000 10.00000');
   self.lifetime = (time + 30.00000);
   self.skin = 1.00000;
   self.health = 5.00000;
   self.experience_value = (SpiderExp->1.00000);
   self.drawflags = SCALE_ORIGIN_BOTTOM;
   self.spawnflags |= JUMP;
   self.spiderType = 1.00000;
   self.spiderGoPause = 35.00000;
   self.mintel = 10.00000;
   self.netname = "spider";
   self.attack_state = AS_STRAIGHT;
   self.thingtype = THINGTYPE_FLESH;
   self.th_stand = SpiderStand;
   self.th_walk = SpiderWalk;
   self.th_run = SpiderRun;
   self.th_die = SpiderDie;
   self.th_melee = SpiderMeleeBegin;
   self.th_missile = SpiderJumpBegin;
   self.th_pain = SpiderPain;
   self.th_possum = spider_playdead;
   self.th_possum_up = spider_possum_up;
   self.classname = "monster_spider_yellow_small";
   self.flags = (self.flags | FL_MONSTER);
   if ( (self.controller.flags2 & FL_ALIVE) ) {

      trace_fraction = 0.00000;
      loop_cnt = 0.00000;
      while ( (trace_fraction < 1.00000) ) {

         newangle = self.angles;
         if ( self.cnt ) {

            newangle_y -= random(45.00000);
         } else {

            newangle_y += random(45.00000);

         }
         makevectors ( newangle);
         spot1 = self.origin;
         spot2 = (spot1 + (v_forward * random(60.00000,160.00000)));
         traceline ( spot1, spot2, FALSE, self);
         if ( ((trace_fraction == 1.00000) && (trace_ent == world)) ) {

            tracearea ( spot1, spot2, '-30.00000 -30.00000 0.00000', '30.00000 30.00000 64.00000', FALSE, self);
            if ( (trace_fraction == 1.00000) ) {

               spot3 = (spot2 + (v_up * -4.00000));
               traceline ( spot2, spot3, FALSE, self);
               if ( (trace_fraction == 1.00000) ) {

                  trace_fraction = 0.00000;
               } else {

                  trace_fraction = 1.00000;

               }

            }

         }
         loop_cnt += 1.00000;
         if ( (loop_cnt > 500.00000) ) {

            self.nextthink = (time + 2.00000);
            return ;

         }

      }
      spot2 = (spot2 + (v_forward * -16.00000));
   } else {

      phase_init ( );
      spot2 = self.origin;

   }
   self.scale = 0.10000;
   setorigin ( self, spot2);
   sound ( self, CHAN_VOICE, "skullwiz/gate.wav", 1.00000, ATTN_NORM);
   spider_grow ( );
};


void  ()skullwiz_summoninit =  {
   AdvanceFrame( 15.00000, 44.00000);
   if ( (self.frame == 16.00000) ) {

      sound ( self, CHAN_VOICE, "skullwiz/gatespk.wav", 1.00000, ATTN_NORM);

   }
   if ( (self.frame == 35.00000) ) {

      spider_spawn ( 0.00000);
      if ( (random() < 0.15000) ) {

         spider_spawn ( 1.00000);

      }

   }
   if ( cycle_wrapped ) {

      skullwiz_run ( );

   }
};


void  ()skullwiz_transition =  {
   AdvanceFrame( 99.00000, 105.00000);
   if ( (self.frame == 99.00000) ) {

      self.attack_finished = (time + random(0.50000,3.50000));

   }
   if ( cycle_wrapped ) {

      skullwiz_run ( );

   }
};


void  ()skullwiz_pain_anim =  {
   AdvanceFrame( 45.00000, 56.00000);
   if ( (self.frame == 46.00000) ) {

      if ( (self.classname == "monster_skull_wizard") ) {

         sound ( self, CHAN_BODY, "skullwiz/pain.wav", 1.00000, ATTN_NORM);
      } else {

         sound ( self, CHAN_BODY, "skullwiz/pain2.wav", 1.00000, ATTN_NORM);

      }

   }
   if ( (self.frame < 55.00000) ) {

      self.frame += 1.00000;

   }
   if ( (self.frame >= 56.00000) ) {

      self.pain_finished = (time + 3.00000);
      if ( (random() < 0.20000) ) {

         skullwiz_blink ( );
      } else {

         skullwiz_run ( );

      }

   }
};


void  (entity attacker,float damg)skullwiz_pain =  {
   if ( ((self.pain_finished > time) || (random(self.health) > damg)) ) {

      return ;

   }
   skullwiz_pain_anim ( );
};


void  ()SkullMissileTouch =  {
local float damg = 0.00000;
   if ( (other == self.owner) ) {

      return ;

   }
   if ( (pointcontents ( self.origin) == CONTENT_SKY) ) {

      remove ( self);
      return ;

   }
   if ( (self.owner.classname == "monster_skull_wizard") ) {

      damg = random(5.00000,13.00000);
   } else {

      damg = random(10.00000,18.00000);

   }
   if ( other.health ) {

      T_Damage ( other, self, self.owner, damg);

   }
   self.origin = (self.origin - (8.00000 * normalize ( self.velocity)));
   sound ( self, CHAN_WEAPON, "weapons/explode.wav", 1.00000, ATTN_NORM);
   BecomeExplosion ( FALSE);
};


void  ()SkullMissile_Twist2 =  {
local vector holdangle = '0.00000 0.00000 0.00000';
   self.think = SkullMissile_Twist2;
   AdvanceThinkTime(self,0.20000);
   holdangle = self.angles;
   if ( !self.cnt ) {

      holdangle_x = ((0.00000 - holdangle_x) + 10.00000);
      self.cnt = 1.00000;
   } else {

      holdangle_x = ((0.00000 - holdangle_x) - 10.00000);
      self.cnt = 0.00000;

   }
   makevectors ( holdangle);
   self.velocity = normalize ( v_forward);
   self.velocity = (self.velocity * 600.00000);
   if ( (self.lifetime < time) ) {

      remove ( self);

   }
   if ( (self.scream_time < time) ) {

      sound ( self, CHAN_BODY, "skullwiz/scream2.wav", 1.00000, ATTN_NORM);
      self.scream_time = (time + random(0.50000,1.00000));

   }
};


void  ()SkullMissile_Twist =  {
   self.think = SkullMissile_Twist;
   AdvanceThinkTime(self,0.20000);
   if ( (self.lifetime < time) ) {

      remove ( self);

   }
   if ( (self.scream_time < time) ) {

      sound ( self, CHAN_BODY, "skullwiz/scream.wav", 1.00000, ATTN_NORM);
      self.scream_time = (time + random(0.50000,1.00000));

   }
};


void  ()launch_skullshot =  {
local vector diff = '0.00000 0.00000 0.00000';
   self.last_attack = time;
   newmis = spawn ( );
   newmis.owner = self;
   newmis.movetype = MOVETYPE_FLYMISSILE;
   newmis.solid = SOLID_BBOX;
   setmodel ( newmis, "models/skulshot.mdl");
   newmis.hull = HULL_POINT;
   newmis.takedamage = DAMAGE_YES;
   newmis.health = 1.00000;
   newmis.dmg = 10.00000;
   newmis.th_die = MultiExplode;
   setsize ( newmis, '-7.00000 -7.00000 -10.00000', '7.00000 7.00000 10.00000');
   makevectors ( self.angles);
   setorigin ( newmis, (((self.origin + (v_forward * 20.00000)) - (v_right * 16.00000)) + (v_up * 45.00000)));
   diff = ((self.enemy.origin + self.enemy.view_ofs) - newmis.origin);
   newmis.velocity = normalize ( diff);
   newmis.velocity = (newmis.velocity * 600.00000);
   newmis.classname = "skullmissile";
   newmis.angles = vectoangles ( newmis.velocity);
   newmis.scale = 1.70000;
   newmis.touch = SkullMissileTouch;
   AdvanceThinkTime(newmis,0.10000);
   newmis.lifetime = (time + 2.50000);
   newmis.scream_time = (time + random(0.50000,1.00000));
   self.cnt = 0.00000;
   if ( (self.classname == "monster_skull_wizard_lord") ) {

      sound ( newmis, CHAN_BODY, "skullwiz/scream2.wav", 1.00000, ATTN_NORM);
      newmis.skin = 1.00000;
      newmis.think = SkullMissile_Twist2;
   } else {

      sound ( newmis, CHAN_BODY, "skullwiz/scream.wav", 1.00000, ATTN_NORM);
      newmis.think = SkullMissile_Twist;
      newmis.scale = 0.90000;

   }
};


void  ()skullwiz_missile =  {
local vector delta = '0.00000 0.00000 0.00000';
local vector spot1 = '0.00000 0.00000 0.00000';
local vector spot2 = '0.00000 0.00000 0.00000';
   AdvanceFrame( 69.00000, 83.00000);
   delta = (self.enemy.origin - self.origin);
   if ( (self.frame == 78.00000) ) {

      ai_face ( );
      makevectors ( self.angles);
      spot1 = ((self.origin + (v_right * 10.00000)) + (v_up * 36.00000));
      spot2 = (self.enemy.origin + self.enemy.view_ofs);
      traceline ( spot1, spot2, FALSE, self);
      if ( (trace_ent == self.enemy) ) {

         if ( SkullFacingIdeal ( ) ) {

            sound ( self, CHAN_WEAPON, "skullwiz/firemisl.wav", 1.00000, ATTN_NORM);
            launch_skullshot ( );
         } else {

            self.frame -= 1.00000;

         }

      }

   }
   if ( cycle_wrapped ) {

      if ( (random() < 0.50000) ) {

         skullwiz_missile ( );
      } else {

         if ( (self.skin && (random() < ((skill / 10.00000) + 0.20000))) ) {

            skullwiz_blink ( );
         } else {

            skullwiz_transition ( );

         }

      }

   }
};


void  ()skullwiz_missile_init =  {
   AdvanceFrame( 57.00000, 68.00000);
   self.frame += 2.00000;
   if ( cycle_wrapped ) {

      skullwiz_missile ( );

   }
};


void  ()skullwiz_blinkin =  {
local float max_scale = 0.00000;
   AdvanceThinkTime(self,HX_FRAME_TIME);
   self.think = skullwiz_blinkin;
   self.scale += 0.10000;
   ai_face ( );
   if ( (self.classname == "monster_skull_wizard") ) {

      max_scale = 1.00000;
   } else {

      max_scale = 1.20000;

   }
   if ( (self.scale >= max_scale) ) {

      self.scale = max_scale;
      self.th_pain = skullwiz_pain;
      self.takedamage = DAMAGE_YES;
      skullwiz_run ( );

   }
};


void  ()skullwiz_blinkin1 =  {
   AdvanceThinkTime(self,HX_FRAME_TIME);
   self.think = skullwiz_blinkin;
   setmodel ( self, "models/skullwiz.mdl");
   self.frame = 125.00000;
};


void  ()skullwiz_ininit =  {
local vector spot1 = '0.00000 0.00000 0.00000';
local vector spot2 = '0.00000 0.00000 0.00000';
local vector spot3 = '0.00000 0.00000 0.00000';
local vector newangle = '0.00000 0.00000 0.00000';
local vector enemy_dir = '0.00000 0.00000 0.00000';
local float loop_cnt = 0.00000;
local float forward = 0.00000;
local float dot = 0.00000;
   trace_fraction = 0.00000;
   loop_cnt = 0.00000;
   do {

      if ( self.enemy ) {

         makevectors ( self.enemy.angles);
         enemy_dir = self.enemy.velocity;
         enemy_dir_z = 0.00000;
         enemy_dir = normalize ( enemy_dir);
         dot = (enemy_dir * v_forward);
         enemy_dir_y = (self.enemy.angles_y + 360.00000);
         if ( (dot > 0.50000) ) {

            newangle_y = (enemy_dir_y + random(-45.00000,45.00000));
         } else {

            newangle_y = (enemy_dir_y + random(45.00000,315.00000));

         }
      } else {

         newangle = self.angles;
         newangle_y = random(360.00000);

      }
      makevectors ( newangle);
      if ( self.enemy ) {

         spot1 = self.enemy.origin;
      } else {

         spot1 = self.origin;

      }
      forward = random(120.00000,200.00000);
      spot2 = (spot1 + (v_forward * forward));
      traceline ( spot1, (spot2 + (v_forward * 30.00000)), FALSE, self.enemy);
      if ( (trace_fraction == 1.00000) ) {

         makevectors ( newangle);
         tracearea ( spot2, (spot2 + (v_up * 80.00000)), '-32.00000 -32.00000 -10.00000', '32.00000 32.00000 46.00000', FALSE, self);
         if ( ((trace_fraction == 1.00000) && !trace_allsolid) ) {

            spot3 = (spot2 + (v_up * -4.00000));
            traceline ( spot2, spot3, FALSE, self);
            if ( (trace_fraction == 1.00000) ) {

               trace_fraction = 0.00000;
            } else {

               makevectors ( newangle);
               traceline ( spot1, spot2, FALSE, self.enemy);
               if ( (trace_fraction == 1.00000) ) {

                  setsize ( self, '-24.00000 -24.00000 0.00000', '24.00000 24.00000 64.00000');
                  self.hull = 2.00000;
                  self.solid = SOLID_SLIDEBOX;
                  setorigin ( self, spot2);
                  if ( walkmove ( self.angles_y, 0.05000, TRUE) ) {

                     trace_fraction = 1.00000;
                  } else {

                     trace_fraction = 0.00000;

                  }
               } else {

                  trace_fraction = 0.00000;

               }

            }
         } else {

            trace_fraction = 0.00000;

         }
      } else {

         trace_fraction = 0.00000;

      }
      loop_cnt += 1.00000;
      if ( (loop_cnt > 500.00000) ) {

         self.nextthink = (time + 2.00000);
         return ;

      }
   } while ( (trace_fraction != 1.00000) );
   self.think = skullwiz_blinkin1;
   self.nextthink = time;
   sound ( self, CHAN_VOICE, "skullwiz/blinkin.wav", 1.00000, ATTN_NORM);
   CreateRedFlash ( (self.origin + '0.00000 0.00000 40.00000'));
};


void  ()skullwiz_blinkout =  {
   AdvanceThinkTime(self,HX_FRAME_TIME);
   self.think = skullwiz_blinkout;
   self.scale -= 0.10000;
   if ( ((self.scale > 0.19000) && (self.scale < 0.29000)) ) {

      sound ( self, CHAN_BODY, "skullwiz/blinkout.wav", 1.00000, ATTN_NORM);
      CreateRedFlash ( (self.origin + '0.00000 0.00000 40.00000'));

   }
   if ( (self.scale < 0.10000) ) {

      setmodel ( self, string_null);
      AdvanceThinkTime(self,random(0.50000,3.00000));
      self.think = skullwiz_ininit;

   }
};


void  ()skullwiz_blink =  {
   AdvanceFrame( 84.00000, 98.00000);
   if ( (self.frame == 84.00000) ) {

      if ( (self.classname == "monster_skull_wizard") ) {

         sound ( self, CHAN_VOICE, "skullwiz/blinkspk.wav", 1.00000, ATTN_NORM);
      } else {

         sound ( self, CHAN_VOICE, "skullwiz/blnkspk2.wav", 1.00000, ATTN_NORM);

      }

   }
   if ( self.aflag ) {

      if ( ((self.frame + 2.00000) <= 98.00000) ) {

         self.frame += 2.00000;

      }
      AdvanceThinkTime(self,0.00500);

   }
   if ( (self.frame == 98.00000) ) {

      self.aflag = FALSE;
      self.takedamage = DAMAGE_NO;
      self.scale = 1.00000;
      self.drawflags = ((self.drawflags & SCALE_TYPE_MASKOUT) | SCALE_TYPE_XYONLY);
      self.solid = SOLID_NOT;
      self.th_pain = SUB_Null;
      skullwiz_blinkout ( );

   }
};


void  ()skullwiz_push =  {
local vector delta = '0.00000 0.00000 0.00000';
local float ldmg = 0.00000;
   if ( (self.enemy.classname != "player") ) {

      return ;

   }
   delta = (self.enemy.origin - self.origin);
   self.last_attack = time;
   ldmg = random(10.00000);
   T_Damage ( self.enemy, self, self, ldmg);
   sound ( self, CHAN_VOICE, "skullwiz/push.wav", 1.00000, ATTN_NORM);
   if ( (self.enemy.flags & FL_ONGROUND) ) {

      self.enemy.flags ^= FL_ONGROUND;

   }
   if ( (self.classname == "monster_skull_wizard") ) {

      self.enemy.velocity = (delta * 10.00000);
      self.enemy.velocity_z = 100.00000;
   } else {

      self.enemy.velocity = (delta * 10.00000);
      self.enemy.velocity_z = 200.00000;

   }
};


void  ()skullwiz_melee =  {
local vector delta = '0.00000 0.00000 0.00000';
   AdvanceFrame( 69.00000, 83.00000);
   if ( (self.frame == 78.00000) ) {

      if ( (self.classname == "monster_skull_wizard") ) {

         skullwiz_push ( );
         if ( (random() < 0.50000) ) {

            skullwiz_missile_init ( );

         }
      } else {

         if ( (random() < 0.15000) ) {

            skullwiz_summoninit ( );
         } else {

            skullwiz_push ( );
            if ( (random() < 0.50000) ) {

               skullwiz_missile_init ( );

            }

         }

      }

   }
   if ( cycle_wrapped ) {

      delta = (self.enemy.origin - self.origin);
      if ( (vlen ( delta) > 80.00000) ) {

         skullwiz_run ( );

      }
   } else {

      ai_charge ( 1.30000);

   }
};


void  ()skullwiz_run =  {
local vector delta = '0.00000 0.00000 0.00000';
   AdvanceFrame( 125.00000, 148.00000);
   if ( (check_defense_blink ( ) && ((self.health < 50.00000) || (self.classname == "monster_skull_wizard_lord"))) ) {

      self.solid = SOLID_NOT;
      self.aflag = TRUE;
      self.think = skullwiz_blink;
      AdvanceThinkTime(self,0.00000);
      return ;

   }
   if ( ((random(1.00000) < 0.10000) && (self.frame == 125.00000)) ) {

      if ( (self.classname == "monster_skull_wizard") ) {

         sound ( self, CHAN_VOICE, "skullwiz/growl.wav", 1.00000, ATTN_NORM);
      } else {

         sound ( self, CHAN_VOICE, "skullwiz/growl2.wav", 1.00000, ATTN_NORM);

      }

   }
   delta = (self.enemy.origin - self.origin);
   if ( (vlen ( delta) < 80.00000) ) {

      self.attack_finished = (time - 1.00000);

   }
   if ( (self.frame == 125.00000) ) {

      if ( (self.classname == "monster_skull_wizard") ) {

         if ( (random() < 0.20000) ) {

            skullwiz_blink ( );

         }
      } else {

         if ( ((random() < 0.30000) || (self.search_time < (time + 1.00000))) ) {

            skullwiz_blink ( );

         }

      }
   } else {

      if ( (self.attack_finished > time) ) {

         movetogoal ( 1.30000);
      } else {

         ai_run ( 1.50000);

      }

   }
};


void  ()skullwiz_walk =  {
   AdvanceFrame( 125.00000, 148.00000);
   if ( ((random(1.00000) < 0.05000) && (self.frame == 125.00000)) ) {

      if ( (self.classname == "monster_skull_wizard") ) {

         sound ( self, CHAN_VOICE, "skullwiz/growl.wav", 1.00000, ATTN_NORM);
      } else {

         sound ( self, CHAN_VOICE, "skullwiz/growl2.wav", 1.00000, ATTN_NORM);

      }

   }
   ai_walk ( 1.30000);
};


void  ()skullwiz_stand =  {
   AdvanceFrame( 106.00000, 124.00000);
   if ( (random() < 0.50000) ) {

      ai_stand ( );

   }
};


void  ()skullwizard_init =  {
   if ( !(self.flags2 & FL_SUMMONED) ) {

      precache_model ( "models/skullwiz.mdl");
      precache_model ( "models/skulbook.mdl");
      precache_model ( "models/skulhead.mdl");
      precache_model ( "models/skulshot.mdl");
      if ( (self.classname == "monster_skull_wizard") ) {

         precache_sound ( "skullwiz/death.wav");
         precache_sound ( "skullwiz/blinkspk.wav");
         precache_sound ( "skullwiz/growl.wav");
         precache_sound ( "skullwiz/scream.wav");
         precache_sound ( "skullwiz/pain.wav");
      } else {

         precache_sound ( "skullwiz/death2.wav");
         precache_sound ( "skullwiz/blnkspk2.wav");
         precache_sound ( "skullwiz/growl2.wav");
         precache_sound ( "skullwiz/scream2.wav");
         precache_sound ( "skullwiz/gatespk.wav");
         precache_sound ( "skullwiz/pain2.wav");

      }
      precache_sound ( "skullwiz/gate.wav");
      precache_sound ( "skullwiz/blinkin.wav");
      precache_sound ( "skullwiz/blinkout.wav");
      precache_sound ( "skullwiz/push.wav");
      precache_sound ( "skullwiz/firemisl.wav");
      precache_spider ( );

   }
   setmodel ( self, "models/skullwiz.mdl");
   self.solid = SOLID_SLIDEBOX;
   self.movetype = MOVETYPE_STEP;
   self.mass = 4.00000;
   self.mintel = 5.00000;
   self.thingtype = THINGTYPE_FLESH;
   self.th_stand = skullwiz_stand;
   self.th_walk = skullwiz_walk;
   self.th_run = skullwiz_run;
   self.th_melee = skullwiz_melee;
   self.th_missile = skullwiz_missile_init;
   self.th_pain = skullwiz_pain;
   self.th_die = skullwiz_die;
   setsize ( self, '-24.00000 -24.00000 0.00000', '24.00000 24.00000 64.00000');
   self.hull = 2.00000;
   self.flags |= FL_MONSTER;
   self.yaw_speed = 10.00000;
};


void  ()monster_skull_wizard =  {
   if ( deathmatch ) {

      remove ( self);
      return ;

   }
   skullwizard_init ( );
   self.health = 150.00000;
   self.experience_value = 90.00000;
   self.monsterclass = CLASS_GRUNT;
   walkmonster_start ( );
};


void  ()monster_skull_wizard_lord =  {
   if ( deathmatch ) {

      remove ( self);
      return ;

   }
   skullwizard_init ( );
   self.health = 650.00000;
   self.experience_value = 325.00000;
   self.monsterclass = CLASS_LEADER;
   self.skin = 1.00000;
   self.scale = 1.20000;
   walkmonster_start ( );
};


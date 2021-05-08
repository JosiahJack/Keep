float SPIDER_RED_LARGE   =  0.00000;
float SPIDER_RED_SMALL   =  1.00000;
float SPIDER_YELLOW_LARGE   =  2.00000;
float SPIDER_YELLOW_SMALL   =  3.00000;
float ONWALL   =  32.00000;
float SPIDER_FRAME_TIME   =  0.02500;
void  (float type)SpiderInit;
void  ()SpiderStand;
void  ()SpiderWalk;
void  ()SpiderRun;
void  ()SpiderMelee;
void  ()SpiderMeleeEnd;
void  ()SpiderPause;
void  (entity attacker,float total_damage)SpiderPain;
void  ()SpiderPainLow;
void  ()SpiderPainHigh;
void  ()SpiderDie;
void  ()SpiderGone;
void  ()SpiderJumpOffWall;
float SpiderHealth [4]   = { 175.00000,
    50.00000,    75.00000,    30.00000};
float SpiderExp [4]   = { 225.00000,
    50.00000,    100.00000,    25.00000};

void  ()monster_spider =  {
};


void  ()monster_spider_red_large =  {
   SpiderInit ( SPIDER_RED_LARGE);
};


void  ()monster_spider_red_small =  {
   SpiderInit ( SPIDER_RED_SMALL);
};


void  ()monster_spider_yellow_large =  {
   SpiderInit ( SPIDER_YELLOW_LARGE);
};


void  ()monster_spider_yellow_small =  {
   SpiderInit ( SPIDER_YELLOW_SMALL);
};


void  ()spider_possum_up =  {
   AdvanceFrame( 117.00000, 98.00000);
   if ( cycle_wrapped ) {

      self.think = self.th_run;

   }
};


void  ()spider_playdead =  {
   self.frame = 117.00000;
   self.think = spider_playdead;
   self.nextthink = (time + 0.10000);
   ai_stand ( );
};


void  ()spider_noise =  {
local float r = 0.00000;
   r = random();
   if ( (r < 0.33000) ) {

      self.noise = "spider/step1.wav";
   } else {

      if ( (r < 0.66000) ) {

         self.noise = "spider/step2.wav";
      } else {

         self.noise = "spider/step3.wav";

      }

   }
   sound ( self, CHAN_BODY, self.noise, random(0.70000,1.00000), ATTN_NORM);
};


void  ()spider_onwall_awakened =  {
   self.use = monster_use;
   sound ( self, CHAN_VOICE, "spider/pain.wav", 1.00000, ATTN_NORM);
   self.goalentity = self.enemy;
   setorigin ( self, (self.origin + (self.movedir * 22.00000)));
   makevectors ( self.enemy.angles);
   self.view_ofs = '0.00000 0.00000 22.00000';
   self.velocity = (normalize ( ((self.enemy.origin + (v_forward * 24.00000)) - self.origin)) * 200.00000);
   self.flags ^= FL_FLY;
   self.movetype = MOVETYPE_TOSS;
   self.last_attack = time;
   self.think = SpiderJumpOffWall;
   AdvanceThinkTime(self,random(0.50000));
};


void  ()spider_onwall_use =  {
   self.enemy = activator;
   if ( (self.enemy.classname == "player") ) {

      sight_entity = self;
      sight_entity_time = time;

   }
   self.show_hostile = (time + 1.00000);
   spider_onwall_awakened ( );
};


void  ()spider_onwall_wait =  {
   AdvanceFrame( 16.00000, 40.00000);
   AdvanceThinkTime(self,0.10000);
   if ( (random() < 0.50000) ) {

      if ( LocateTarget ( ) ) {

         spider_onwall_awakened ( );

      }

   }
};


void  ()spider_onwall_wait_init =  {
   total_monsters += 1.00000;
   if ( (self.angles_y == -2.00000) ) {

      self.angles = '90.00000 0.00000 0.00000';

   }
   self.flags |= FL_FLY;
   walkmonster_start ( );
   makevectors ( self.angles);
   setorigin ( self, (self.origin - (v_forward * 22.00000)));
   self.view_ofs = (v_forward * 36.00000);
   self.movedir = v_forward;
   traceline ( self.origin, (self.origin - (v_forward * 100.00000)), TRUE, self);
   pitch_roll_for_slope ( trace_plane_normal);
   self.use = spider_onwall_use;
   if ( (self.targetname == "") ) {

      self.think = spider_onwall_wait;
      AdvanceThinkTime(self,0.00000);
   } else {

      self.nextthink = -1.00000;

   }
};


void  (float type)SpiderInit =  {
   if ( deathmatch ) {

      remove ( self);
      return ;

   }
   if ( !(self.flags2 & FL_SUMMONED) ) {

      precache_spider ( );

   }
   setmodel ( self, "models/spider.mdl");
   self.solid = SOLID_SLIDEBOX;
   self.movetype = MOVETYPE_STEP;
   self.yaw_speed = 10.00000;
   if ( (type > SPIDER_RED_SMALL) ) {

      self.skin = 1.00000;

   }
   if ( (type & 1.00000) ) {

      self.scale = random(0.70000,0.90000);
      self.mass = 1.00000;
      self.speed = 5.00000;
      setsize ( self, '-12.00000 -12.00000 0.00000', '12.00000 12.00000 16.00000');
   } else {

      self.scale = random(1.10000,1.40000);
      self.mass = 3.00000;
      self.speed = 10.00000;
      setsize ( self, '-16.00000 -16.00000 0.00000', '16.00000 16.00000 26.00000');

   }
   self.hull = HULL_CROUCH;
   self.drawflags = SCALE_ORIGIN_BOTTOM;
   self.spawnflags |= JUMP;
   self.spiderType = type;
   self.spiderGoPause = 35.00000;
   self.mintel = 10.00000;
   self.netname = "spider";
   self.health = (SpiderHealth->type);
   self.experience_value = (SpiderExp->type);
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
   self.flags = (self.flags | FL_MONSTER);
   if ( (self.spawnflags & ONWALL) ) {

      spider_onwall_wait_init ( );
   } else {

      walkmonster_start ( );

   }
};


void  ()SpiderDie =  {
   AdvanceFrame( 98.00000, 117.00000);
   if ( (self.frame == 98.00000) ) {

      sound ( self, CHAN_VOICE, "spider/death.wav", 1.00000, ATTN_NORM);
      self.flags ^= FL_FLY;
      if ( !(self.flags & FL_ONGROUND) ) {

         self.movetype = MOVETYPE_BOUNCE;

      }

   }
   if ( (self.frame == 117.00000) ) {

      self.think = SpiderGone;

   }
   if ( (self.health < -20.00000) ) {

      chunk_death ( );

   }
};


void  ()SpiderGone =  {
   MakeSolidCorpse ( );
};


void  (entity attacker,float total_damage)SpiderPain =  {
   if ( (random(self.health) > total_damage) ) {

      return ;

   }
   sound ( self, CHAN_VOICE, "spider/pain.wav", 1.00000, ATTN_NORM);
   if ( (self.flags & FL_FLY) ) {

      spider_onwall_awakened ( );
   } else {

      if ( ((self.frame < 49.00000) || (self.frame > 63.00000)) ) {

         SpiderPainLow ( );
      } else {

         SpiderPainHigh ( );

      }

   }
};


void  ()SpiderPainLow =  {
   AdvanceFrame( 80.00000, 89.00000);
   if ( cycle_wrapped ) {

      self.enemy = world;
      SpiderRun ( );

   }
   AdvanceThinkTime(self,SPIDER_FRAME_TIME);
};


void  ()SpiderPainHigh =  {
   AdvanceFrame( 90.00000, 97.00000);
   if ( cycle_wrapped ) {

      self.enemy = world;
      SpiderRun ( );

   }
   AdvanceThinkTime(self,SPIDER_FRAME_TIME);
};


void  ()SpiderMeleeBegin =  {
   AdvanceFrame( 42.00000, 53.00000);
   ai_charge ( (self.speed / 2.00000));
   if ( (self.frame == 42.00000) ) {

      self.last_attack = time;
   } else {

      if ( (self.frame == 53.00000) ) {

         self.think = SpiderMelee;

      }

   }
   AdvanceThinkTime(self,SPIDER_FRAME_TIME);
};


void  ()SpiderMeleeSettle =  {
   AdvanceFrame( 75.00000, 79.00000);
   ai_charge ( (self.speed / 2.00000));
   if ( (self.frame == 79.00000) ) {

      self.think = self.th_run;

   }
   AdvanceThinkTime(self,SPIDER_FRAME_TIME);
};


void  ()SpiderJumpTouch =  {
   if ( (other.takedamage && (other.model != "models/spider.mdl")) ) {

      T_Damage ( other, self, self, 10.00000);
      self.touch = obj_push;

   }
};


void  ()SpiderJumpBegin =  {
   AdvanceFrame( 64.00000, 74.00000);
   if ( (self.frame == 64.00000) ) {

      if ( (!CheckJump ( ) || (self.level < 20.00000)) ) {

         self.think = SpiderRun;
         self.nextthink = time;
         return ;
      } else {

         self.last_attack = time;

      }

   }
   if ( (self.frame < 68.00000) ) {

      self.ideal_yaw = vectoyaw ( (self.enemy.origin - self.origin));
      self.angles_y = vectoyaw ( (self.enemy.origin - self.origin));
      ai_charge ( (self.speed / 2.00000));
   } else {

      if ( (self.frame == 68.00000) ) {

         self.last_attack = time;
         self.touch = SpiderJumpTouch;
         self.last_attack = time;
         makevectors ( self.angles);
         self.jump_flag = (time + 7.00000);
         self.velocity = (((v_forward * self.level) * 12.00000) * self.scale);
         self.velocity_z = ((self.level * 10.00000) * self.scale);
         self.flags ^= FL_ONGROUND;
      } else {

         if ( (self.frame == 74.00000) ) {

            self.touch = obj_push;
            self.frame = 48.00000;
            self.think = SpiderMeleeBegin;

         }

      }

   }
};


void  ()SpiderJumpOffWall =  {
   AdvanceFrame( 64.00000, 74.00000);
   if ( (self.angles_x != 0.00000) ) {

      if ( ((self.angles_x <= 10.00000) && (self.angles_x >= -10.00000)) ) {

         self.angles_x = 0.00000;
      } else {

         self.angles_x /= 1.50000;

      }

   }
   if ( (self.angles_z != 0.00000) ) {

      if ( ((self.angles_z <= 10.00000) && (self.angles_z >= -10.00000)) ) {

         self.angles_z = 0.00000;
      } else {

         self.angles_z /= 1.50000;

      }

   }
   ai_face ( );
   if ( (self.flags & FL_ONGROUND) ) {

      if ( (self.movetype != MOVETYPE_STEP) ) {

         self.movetype = MOVETYPE_STEP;
         sound ( self, CHAN_BODY, "player/land.wav", 1.00000, ATTN_NORM);

      }

   }
   if ( (self.frame == 74.00000) ) {

      if ( (self.flags & FL_ONGROUND) ) {

         self.movetype = MOVETYPE_STEP;
         self.angles_x = 0.00000;
         self.angles_z = 0.00000;
         self.frame = 48.00000;
         self.think = SpiderMeleeBegin;
      } else {

         self.frame -= 1.00000;

      }

   }
};


void  ()SpiderMelee =  {
   AdvanceFrame( 54.00000, 63.00000);
   self.last_attack = time;
   if ( (self.frame == 60.00000) ) {

      ai_melee ( );

   }
   if ( (self.frame == 59.00000) ) {

      sound ( self, CHAN_VOICE, "spider/bite.wav", 1.00000, ATTN_NORM);

   }
   if ( ((self.frame > 58.00000) && (self.frame < 62.00000)) ) {

      ai_charge ( (self.speed / 1.50000));
   } else {

      ai_charge ( (self.speed / 2.50000));

   }
   if ( (self.frame == 63.00000) ) {

      if ( (range ( self.enemy) == RANGE_MELEE) ) {

         if ( (random() < (0.70000 - (skill / 10.00000))) ) {

            self.think = SpiderMeleeEnd;

         }
      } else {

         self.think = SpiderMeleeEnd;

      }

   }
   AdvanceThinkTime(self,SPIDER_FRAME_TIME);
};


void  ()SpiderMeleeEnd =  {
   AdvanceFrame( 53.00000, 42.00000);
   if ( (self.frame == 42.00000) ) {

      self.think = SpiderRun;

   }
   AdvanceThinkTime(self,SPIDER_FRAME_TIME);
};


void  ()SpiderPauseInit =  {
   self.th_save = self.think;
   self.spiderPauseLength = (7.00000 + (random() * 8.00000));
   self.spiderGoPause = (16.00000 + (random() * 16.00000));
   self.spiderActiveCount = 0.00000;
   self.spiderPauseCount = 0.00000;
   SpiderPause ( );
};


void  ()SpiderPause =  {
   AdvanceFrame( 16.00000, 41.00000);
   self.spiderPauseCount += 1.00000;
   if ( (self.spiderPauseCount > self.spiderPauseLength) ) {

      self.think = self.th_save;
      if ( !(self.think) ) {

         self.think = SpiderStand;

      }

   }
};


void  ()SpiderRun =  {
   AdvanceFrame( 0.00000, 15.00000);
   self.spiderActiveCount += 1.00000;
   if ( ((self.spiderActiveCount > self.spiderGoPause) && (random() > (skill / 5.00000))) ) {

      SpiderPauseInit ( );
      return ;

   }
   if ( (self.attack_state == AS_STRAIGHT) ) {

      if ( (random() < 0.10000) ) {

         self.attack_state = AS_SLIDING;

      }
   } else {

      if ( (self.attack_state == AS_SLIDING) ) {

         if ( (random() < 0.30000) ) {

            self.attack_state = AS_STRAIGHT;

         }

      }

   }
   if ( (self.spiderType & 1.00000) ) {

      ai_run ( (self.speed / self.attack_state));
   } else {

      ai_run ( (self.speed / self.attack_state));

   }
   if ( (random() < 0.20000) ) {

      spider_noise ( );
      pitch_roll_for_slope ( '0.00000 0.00000 0.00000');

   }
   if ( ((self.flags2 & FL_SUMMONED) && (self.lifetime < time)) ) {

      SpiderDie ( );

   }
   AdvanceThinkTime(self,SPIDER_FRAME_TIME);
};


void  ()SpiderStand =  {
   AdvanceFrame( 16.00000, 40.00000);
   if ( (random() < 0.50000) ) {

      ai_stand ( );

   }
};


void  ()SpiderWalk =  {
   AdvanceFrame( 0.00000, 15.00000);
   ai_walk ( (self.speed / 2.00000));
   if ( (random() < 0.10000) ) {

      spider_noise ( );
      pitch_roll_for_slope ( '0.00000 0.00000 0.00000');

   }
};


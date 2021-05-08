float HYDRA_STAGE_WAIT   =  0.00000;
float HYDRA_STAGE_SWIM   =  1.00000;
float HYDRA_STAGE_FLOAT   =  2.00000;
float HYDRA_STAGE_STRAIGHT   =  3.00000;
float HYDRA_STAGE_REVERSE   =  4.00000;
float HYDRA_STAGE_CHARGE   =  5.00000;
float HYDRA_STAGE_ATTACK   =  10.00000;
void  ()hydra_attack;
void  ()hydra_CloseFrames;
void  (float thrust)hydra_move;
void  ()hydra_bob;

void  ()hydra_init =  {
   self.ideal_yaw = vectoyaw ( (self.enemy.origin - self.origin));
   self.think = self.th_run;
   AdvanceThinkTime(self,random(0.10000,0.60000));
   self.count = 0.00000;
   self.monster_stage = HYDRA_STAGE_SWIM;
   self.hydra_FloatTo = 0.00000;
   self.goalentity = self.enemy;
   self.monster_awake = TRUE;
};


void  ()hydra_wait =  {
   if ( LocateTarget ( ) ) {

      hydra_init ( );

   }
};

void  ()hydra_OpenFrames;
void  ()hydra_TentFrames;
void  ()hydra_SpitFrames;
float  ()hydra_check_blind_melee;

void  ()hydra_charge_finish =  {
   self.yaw_speed = 5.00000;
   self.cnt = (time + random(5.00000,10.00000));
   if ( CheckMonsterAttack ( MA_MELEE, 3.00000) ) {

      self.monster_stage += HYDRA_STAGE_ATTACK;
      self.monster_check = 0.00000;
      self.think = hydra_attack;
      AdvanceThinkTime(self,0.05000);
      return ;

   }
   self.monster_stage = HYDRA_STAGE_SWIM;
   self.think = self.th_run;
   AdvanceThinkTime(self,0.10000);
};


void  ()hydra_charge =  {
local float dist = 0.00000;
   self.yaw_speed = 8.00000;
   check_pos_enemy ( );
   ai_face ( );
   dist = vlen ( (self.enemy.origin - self.origin));
   movetogoal ( (dist / 8.00000));
   if ( (range ( self.enemy) == RANGE_MELEE) ) {

      self.monster_check = 0.00000;
      hydra_charge_finish ( );
      return ;

   }
   if ( (self.hydra_chargeTime < time) ) {

      self.monster_check = 0.00000;
      hydra_charge_finish ( );
      return ;

   }
   self.think = hydra_charge;
   AdvanceThinkTime(self,0.05000);
};


float  ()hydra_check_blind_melee =  {
local float dist = 0.00000;
local float c1 = 0.00000;
   if ( (self.enemy.watertype != CONTENT_WATER) ) {

      return ( 0.00000 );

   }
   if ( (self.cnt > time) ) {

      return ( 0.00000 );

   }
   dist = vhlen ( (self.enemy.origin - self.origin));
   traceline ( self.origin, self.enemy.origin, FALSE, self);
   c1 = fov ( self, self.enemy, 80.00000);
   if ( (((dist < 256.00000) && c1) && (trace_ent == self.enemy)) ) {

      if ( (random() < 0.20000) ) {

         return ( 1.00000 );

      }

   }
   return ( 0.00000 );
};


void  ()hydra_blind =  {
   stuffcmd ( self.enemy, "df\n");
   self.hydra_chargeTime = (time + 1.00000);
   self.think = hydra_charge;
   AdvanceThinkTime(self,0.05000);
};


void  ()hydra_checkForBlind =  {
local float r = 0.00000;
   r = pointcontents ( self.enemy.origin);
   if ( (r != CONTENT_WATER) ) {

      self.think = self.th_run;
      AdvanceThinkTime(self,0.10000);
      return ;

   }
   r = vhlen ( (self.enemy.origin - self.origin));
   if ( (((r < 150.00000) && fov ( self, self.enemy, 80.00000)) && fov ( self.enemy, self, 80.00000)) ) {

      AdvanceThinkTime(self,0.10000);
      self.think = hydra_blind;
   } else {

      self.think = self.th_run;
      AdvanceThinkTime(self,0.10000);

   }
};


void  (float thrust)hydra_swim =  {
local float dist = 0.00000;
local float temp = 0.00000;
   if ( self.velocity ) {

      self.velocity = (self.velocity * 0.70000);

   }
   if ( !(self.enemy.flags2 & FL_ALIVE) ) {

      self.enemy = world;
      self.goalentity = world;
      self.monster_stage = HYDRA_STAGE_WAIT;
      return ;

   }
   dist = (4.00000 + (thrust * 6.00000));
   movetogoal ( dist);
   if ( (self.hydra_FloatTo == 0.00000) ) {

      dist = (self.enemy.origin_z - self.origin_z);
      if ( (dist < -50.00000) ) {

         self.hydra_FloatTo = (dist - random(60.00000));
      } else {

         if ( (dist > 50.00000) ) {

            self.hydra_FloatTo = (dist + random(60.00000));

         }

      }

   }
   if ( (self.hydra_FloatTo < -10.00000) ) {

      temp = random(-3.50000,-2.50000);
      self.hydra_FloatTo -= temp;
   } else {

      if ( (self.hydra_FloatTo > 10.00000) ) {

         temp = random(2.50000,3.50000);
         self.hydra_FloatTo -= temp;
      } else {

         self.hydra_FloatTo = 0.00000;

      }

   }
   self.th_save = self.think;
   enemy_range = range ( self.enemy);
   if ( hydra_check_blind_melee ( ) ) {

      self.monster_check = 2.00000;
      hydra_attack ( );

   }
   dist = vlen ( (self.enemy.origin - self.origin));
   if ( (dist > 350.00000) ) {

      if ( CheckMonsterAttack ( MA_MISSILE, 8.00000) ) {

         return ;

      }
   } else {

      CheckMonsterAttack ( MA_MELEE, 3.00000);

   }
};


void  ()hydra_float =  {
local float Length = 0.00000;
   if ( self.velocity ) {

      self.velocity = (self.velocity * 0.70000);

   }
   Length = vhlen ( (self.origin - self.enemy.origin));
   if ( (Length < 300.00000) ) {

      self.monster_stage = HYDRA_STAGE_SWIM;
      self.hydra_FloatTo = 0.00000;
      return ;

   }
   ai_face ( );
   self.th_save = self.think;
   enemy_range = range ( self.enemy);
   if ( hydra_check_blind_melee ( ) ) {

      self.monster_check = 2.00000;
      hydra_attack ( );

   }
   CheckMonsterAttack ( MA_MISSILE, 8.00000);
};


void  ()hydra_reverse =  {
local float retval = 0.00000;
local float dist = 0.00000;
   self.monster_duration -= 1.00000;
   dist = 4.00000;
   retval = walkmove ( (self.angles_y + 180.00000), dist, FALSE);
};


void  (float thrust)hydra_move =  {
   check_pos_enemy ( );
   if ( (self.monster_stage == HYDRA_STAGE_SWIM) ) {

      hydra_swim ( thrust);
      return ;
   } else {

      if ( (self.monster_stage == HYDRA_STAGE_FLOAT) ) {

         hydra_float ( );
         return ;
      } else {

         if ( (self.monster_stage == HYDRA_STAGE_WAIT) ) {

            hydra_wait ( );
            return ;
         } else {

            if ( (self.monster_stage == HYDRA_STAGE_REVERSE) ) {

               return ;

            }

         }

      }

   }
};


void  ()hydra_attack =  {
   if ( (self.monster_check > 0.00000) ) {

      hydra_SpitFrames ( );
   } else {

      hydra_TentFrames ( );

   }
};


void  ()hydra_fire =  {
   sound ( self, CHAN_WEAPON, "hydra/spit.wav", 1.00000, ATTN_NORM);
   do_spit ( '0.00000 0.00000 0.00000');
   do_spit ( '0.00000 0.00000 0.00000');
   do_spit ( '0.00000 0.00000 0.00000');
};


void  (float TryHit)hydra_tent =  {
   ai_face ( );
   check_pos_enemy ( );
   if ( TryHit ) {

      makevectors ( self.angles);
      traceline ( self.origin, (self.origin + (v_forward * 128.00000)), FALSE, self);
      if ( trace_ent.takedamage ) {

         sound ( self, CHAN_WEAPON, "hydra/tent.wav", 1.00000, ATTN_NORM);
         T_Damage ( trace_ent, self, self, random(1.00000,2.00000));
      } else {

         movetogoal ( 15.00000);

      }

   }
};


void  ()hydra_open =  {
   ai_face ( );
};


void  ()hydra_bob =  {
local float rnd1 = 0.00000;
local float rnd2 = 0.00000;
local float rnd3 = 0.00000;
   rnd1 = (self.velocity_x + random(-10.00000,10.00000));
   rnd2 = (self.velocity_y + random(-10.00000,10.00000));
   rnd3 = (self.velocity_z + random(10.00000));
   if ( (rnd1 > 10.00000) ) {

      rnd1 = 10.00000;

   }
   if ( (rnd1 < -10.00000) ) {

      rnd1 = -10.00000;

   }
   if ( (rnd2 > 10.00000) ) {

      rnd2 = 10.00000;

   }
   if ( (rnd2 < -10.00000) ) {

      rnd2 = -10.00000;

   }
   if ( (rnd3 > 55.00000) ) {

      rnd3 = 50.00000;

   }
   self.velocity_x = rnd1;
   self.velocity_y = rnd2;
   self.velocity_z = rnd3;
};

float hydra_Swim [20]   = { -0.20000,
    -0.10000,    0.00000,    0.10000,    0.20000,
    0.30000,    0.40000,    0.50000,    0.40000,
    0.30000,    0.20000,    0.10000,    0.00000,
    -0.10000,    -0.20000,    -0.30000,    -0.40000,
    -0.50000,    -0.40000,    -0.30000};
float hydra_TentAttacks [24]   = { 0.00000,
    0.00000,    0.00000,    0.00000,    1.00000,
    0.00000,    3.00000,    0.00000,    4.00000,
    0.00000,    0.00000,    5.00000,    0.00000,
    0.00000,    0.00000,    2.00000,    0.00000,
    0.00000,    0.00000,    4.00000,    3.00000,
    1.00000,    0.00000,    0.00000};

void  ()hydra_AttackDieFrames =  {
   self.think = hydra_AttackDieFrames;
   AdvanceThinkTime(self,HX_FRAME_TIME);
   if ( (self.frame != 35.00000) ) {

      AdvanceFrame ( 0.00000, 35.00000);

   }
   if ( (self.frame == 34.00000) ) {

      self.solid = SOLID_NOT;
      MakeSolidCorpse ( );

   }
   if ( (self.frame >= 12.00000) ) {

      hydra_bob ( );

   }
   if ( (self.health < -30.00000) ) {

      chunk_death ( );

   }
};


void  ()hydra_AttackPainFrames =  {
   self.think = hydra_AttackPainFrames;
   AdvanceThinkTime(self,HX_FRAME_TIME);
   AdvanceFrame ( 36.00000, 45.00000);
};


void  ()hydra_SwimDieFrames =  {
   self.think = hydra_SwimDieFrames;
   AdvanceThinkTime(self,HX_FRAME_TIME);
   if ( (self.frame != 149.00000) ) {

      AdvanceFrame ( 114.00000, 149.00000);

   }
   if ( (self.frame == 148.00000) ) {

      self.solid = SOLID_NOT;
      MakeSolidCorpse ( );

   }
   if ( (self.frame >= 121.00000) ) {

      hydra_bob ( );

   }
   if ( (self.health < -30.00000) ) {

      chunk_death ( );

   }
};


void  ()hydra_SwimPainFrames =  {
   self.think = hydra_SwimPainFrames;
   AdvanceThinkTime(self,HX_FRAME_TIME);
   AdvanceFrame ( 150.00000, 159.00000);
};


void  ()hydra_OpenFrames =  {
   self.think = hydra_OpenFrames;
   AdvanceThinkTime(self,HX_FRAME_TIME);
   if ( (self.enemy.watertype != CONTENT_WATER) ) {

      self.monster_stage = HYDRA_STAGE_FLOAT;
      self.think = self.th_run;
      AdvanceThinkTime(self,0.10000);
      return ;

   }
   hydra_open ( );
   if ( (AdvanceFrame ( 76.00000, 83.00000) == AF_END) ) {

      hydra_attack ( );

   }
};


void  ()hydra_CloseFrames =  {
   self.think = hydra_CloseFrames;
   AdvanceThinkTime(self,HX_FRAME_TIME);
   if ( (RewindFrame ( 83.00000, 76.00000) == AF_END) ) {

      self.monster_stage -= HYDRA_STAGE_ATTACK;
      self.think = self.th_save;

   }
};


void  ()hydra_SpitFrames =  {
local vector vecA = '0.00000 0.00000 0.00000';
local vector vecB = '0.00000 0.00000 0.00000';
   self.think = hydra_SpitFrames;
   AdvanceThinkTime(self,HX_FRAME_TIME);
   self.angles_y = vectoyaw ( (self.enemy.origin - self.origin));
   if ( (AdvanceFrame ( 160.00000, 171.00000) == AF_END) ) {

      self.think = hydra_CloseFrames;
      self.monster_check = -1.00000;
   } else {

      if ( ((self.frame == 166.00000) && (self.monster_check == 2.00000)) ) {

         sound ( self, CHAN_WEAPON, "hydra/spit.wav", 1.00000, ATTN_NORM);
         vecA = ((self.enemy.origin - self.origin) + self.enemy.proj_ofs);
         vecA = vectoangles ( vecA);
         makevectors ( vecA);
         v_forward_z = (0.00000 - v_forward_z);
         vecA = v_factor ( '-40.00000 400.00000 -40.00000');
         vecB = v_factor ( '40.00000 500.00000 40.00000');
         particle2 ( (self.origin + (v_forward * 40.00000)), vecA, vecB, 256.00000, 12.00000, 400.00000);
         self.think = hydra_checkForBlind;
         AdvanceThinkTime(self,0.10000);
      } else {

         if ( ((self.frame == 167.00000) && (self.monster_check == 1.00000)) ) {

            hydra_fire ( );

         }

      }

   }
};


void  ()hydra_TentFrames =  {
local float r = 0.00000;
   if ( !(self.enemy.flags2 & FL_ALIVE) ) {

      self.enemy = world;
      self.goalentity = world;
      self.monster_stage = HYDRA_STAGE_WAIT;
      self.think = self.th_stand;
      AdvanceThinkTime(self,0.10000);
      return ;

   }
   self.think = hydra_TentFrames;
   AdvanceThinkTime(self,0.02500);
   if ( (AdvanceFrame ( 192.00000, 215.00000) == AF_END) ) {

      r = range ( self.enemy);
      if ( ((r == RANGE_MELEE) && (random(0.00000,1.00000) < 0.30000)) ) {

         self.frame = 192.00000;
         hydra_tent ( (hydra_TentAttacks->(self.frame - 192.00000)));
      } else {

         self.think = hydra_CloseFrames;

      }
   } else {

      hydra_tent ( (hydra_TentAttacks->(self.frame - 192.00000)));

   }
};


void  ()hydra_SwimFrames =  {
   if ( (self.health < 125.00000) ) {

      dprintf ( "Contents : %s\n", pointcontents ( self.origin));

   }
   self.think = hydra_SwimFrames;
   AdvanceThinkTime(self,HX_FRAME_TIME);
   AdvanceFrame ( 172.00000, 191.00000);
   if ( (self.frame == 172.00000) ) {

      sound ( self, CHAN_WEAPON, "hydra/swim.wav", 1.00000, ATTN_NORM);

   }
   hydra_move ( ((hydra_Swim->(self.frame - 172.00000)) + 0.30000));
};


void  ()misc_fountain =  {
   starteffect ( CE_FOUNTAIN, self.origin, self.angles, self.movedir, self.color, self.cnt);
};


void  ()do_hydra_spit =  {
   self.monster_check = 1.00000;
   self.monster_stage += HYDRA_STAGE_ATTACK;
   sound ( self, CHAN_WEAPON, "hydra/open.wav", 1.00000, ATTN_NORM);
   hydra_OpenFrames ( );
};


void  ()do_hydra_tent =  {
   self.monster_check = 0.00000;
   self.monster_stage += HYDRA_STAGE_ATTACK;
   sound ( self, CHAN_WEAPON, "hydra/open.wav", 1.00000, ATTN_NORM);
   hydra_OpenFrames ( );
};


void  ()do_hydra_die =  {
   self.flags |= FL_SWIM;
   sound ( self, CHAN_WEAPON, "hydra/die.wav", 1.00000, ATTN_NORM);
   if ( (self.monster_stage >= HYDRA_STAGE_ATTACK) ) {

      hydra_AttackDieFrames ( );
   } else {

      hydra_SwimDieFrames ( );

   }
};


void  ()hydra_retreat =  {
   self.monster_stage = HYDRA_STAGE_REVERSE;
   self.think = self.th_run;
   AdvanceThinkTime(self,0.10000);
};


void  (entity attacker,float damage)hydra_pain =  {
   sound ( self, CHAN_WEAPON, "hydra/pain.wav", 1.00000, ATTN_NORM);
};


void  ()init_hydra =  {
   if ( deathmatch ) {

      remove ( self);
      return ;

   }
   self.monster_stage = HYDRA_STAGE_WAIT;
   precache_model ( "models/hydra.mdl");
   precache_model ( "models/spit.mdl");
   self.solid = SOLID_SLIDEBOX;
   self.movetype = MOVETYPE_SWIM;
   self.thingtype = THINGTYPE_FLESH;
   self.classname = "monster_hydra";
   self.mass = 7.00000;
   setmodel ( self, "models/hydra.mdl");
   self.skin = 0.00000;
   setsize ( self, '-40.00000 -40.00000 -42.00000', '40.00000 40.00000 42.00000');
   self.hull = HULL_SCORPION;
   self.health = 125.00000;
   self.experience_value = 50.00000;
   self.mintel = 4.00000;
   self.th_stand = hydra_SwimFrames;
   self.th_walk = hydra_SwimFrames;
   self.th_run = hydra_SwimFrames;
   self.th_pain = hydra_pain;
   self.th_die = do_hydra_die;
   self.th_missile = do_hydra_spit;
   self.th_melee = do_hydra_tent;
   self.takedamage = DAMAGE_YES;
   self.flags2 |= FL_ALIVE;
   self.ideal_yaw = (self.angles * '0.00000 1.00000 0.00000');
   if ( !self.yaw_speed ) {

      self.yaw_speed = 5.00000;

   }
   self.view_ofs = '0.00000 0.00000 0.00000';
   self.use = monster_use;
   self.flags |= (FL_SWIM | FL_MONSTER);
   self.pausetime = 100000000.00000;
   total_monsters += 1.00000;
   AdvanceThinkTime(self,random(0.50000));
   self.think = self.th_stand;
};


void  ()monster_hydra =  {
   init_hydra ( );
   precache_sound ( "hydra/pain.wav");
   precache_sound ( "hydra/die.wav");
   precache_sound ( "hydra/open.wav");
   precache_sound ( "hydra/turn-s.wav");
   precache_sound ( "hydra/turn-b.wav");
   precache_sound ( "hydra/swim.wav");
   precache_sound ( "hydra/tent.wav");
   precache_sound ( "hydra/spit.wav");
};


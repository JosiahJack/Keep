float FISH_STAGE_MOVE   =  1.00000;
float FISH_STAGE_FOLLOW   =  2.00000;
float FISH_STAGE_BORED   =  3.00000;
void  ()fish_hover;
void  ()fish_move;

float  ()fish_friends =  {
local entity item;
local entity test;
local float bad = 0.00000;
   item = findradius ( self.origin, 100.00000);
   while ( item ) {

      if ( ((item.classname == "monster_fish") && (item != self)) ) {

         test = item.goalentity;
         bad = FALSE;
         while ( ((test != world) && (bad != TRUE)) ) {

            if ( (test == self) ) {

               bad = TRUE;

            }
            test = test.goalentity;

         }
         if ( !bad ) {

            self.goalentity = item;
            self.goalentity.fish_leader_count += 1.00000;
            return ( TRUE );

         }

      }
      item = item.chain;

   }
   return ( FALSE );
};


void  ()fish_follow =  {
   AdvanceThinkTime(self,HX_FRAME_TIME);
   AdvanceFrame ( 0.00000, 39.00000);
   if ( (random() > 0.10000) ) {

      return ;

   }
   if ( (random() < 0.05000) ) {

      self.monster_duration = random(250.00000,450.00000);
      self.monster_stage = FISH_STAGE_BORED;
      self.think = fish_hover;
      self.goalentity.fish_leader_count -= 1.00000;
      self.goalentity = world;

   }
   self.movedir = ((self.monster_last_seen - self.origin) + random('-20.00000 -20.00000 -25.00000','20.00000 20.00000 25.00000'));
   if ( self.goalentity.goalentity ) {

      self.goalentity.fish_leader_count -= 1.00000;
      self.goalentity = self.goalentity.goalentity;
      self.goalentity.fish_leader_count += 1.00000;

   }
   self.monster_last_seen = self.goalentity.origin;
   self.count = (80.00000 + random(20.00000));
   self.movedir_x /= self.count;
   self.movedir_y /= self.count;
   self.movedir_z /= self.count;
   self.fish_speed = vhlen ( self.movedir);
   self.think = fish_move;
};


void  ()fish_move =  {
local float retval = 0.00000;
   AdvanceThinkTime(self,HX_FRAME_TIME);
   AdvanceFrame ( 0.00000, 39.00000);
   self.ideal_yaw = vectoyaw ( self.movedir);
   ChangeYaw ( );
   retval = walkmove ( self.angles_y, self.fish_speed, FALSE);
   retval = movestep ( 0.00000, 0.00000, self.movedir_z, FALSE);
   if ( (self.count >= 170.00000) ) {

      self.fish_speed *= 1.05000;
   } else {

      if ( (self.count < 30.00000) ) {

         self.fish_speed *= 0.90000;

      }

   }
   self.count -= 1.00000;
   if ( (self.count < 1.00000) ) {

      self.count = 0.00000;
      if ( (self.monster_stage == FISH_STAGE_MOVE) ) {

         if ( fish_friends ( ) ) {

            self.monster_stage = FISH_STAGE_FOLLOW;
            self.think = fish_follow;
            self.monster_last_seen = self.goalentity.origin;
         } else {

            self.think = fish_hover;

         }
      } else {

         if ( (self.monster_stage == FISH_STAGE_FOLLOW) ) {

            self.think = fish_follow;
         } else {

            if ( (self.monster_stage == FISH_STAGE_BORED) ) {

               self.think = fish_hover;

            }

         }

      }

   }
};


void  ()fish_hover =  {
local float try = 0.00000;
   AdvanceThinkTime(self,HX_FRAME_TIME);
   AdvanceFrame ( 0.00000, 39.00000);
   if ( (self.monster_stage == FISH_STAGE_BORED) ) {

      self.monster_duration -= 1.00000;
      if ( (self.monster_duration <= 0.00000) ) {

         self.monster_stage = FISH_STAGE_MOVE;

      }

   }
   if ( (random() < 0.02000) ) {

      try = 0.00000;
      while ( (try < 10.00000) ) {

         self.movedir = random('-100.00000 -100.00000 -30.00000','100.00000 100.00000 30.00000');
         tracearea ( self.origin, (self.origin + self.movedir), self.mins, self.maxs, FALSE, self);
         if ( (trace_fraction == 1.00000) ) {

            self.think = fish_move;
            self.count = (170.00000 + random(30.00000));
            self.movedir_x /= 400.00000;
            self.movedir_y /= 400.00000;
            self.movedir_z /= 400.00000;
            self.fish_speed = vhlen ( self.movedir);
            try = 999.00000;

         }
         try += 1.00000;

      }

   }
};


void  ()fish_die =  {
   remove ( self);
};


void  ()monster_fish =  {
   precache_model2 ( "models/fish.mdl");
   self.takedamage = DAMAGE_YES;
   self.solid = SOLID_SLIDEBOX;
   self.movetype = MOVETYPE_FLY;
   self.flags |= (FL_SWIM | FL_MONSTER);
   self.yaw_speed = 2.00000;
   self.hull = HULL_PLAYER;
   self.monster_stage = FISH_STAGE_MOVE;
   self.mass = 99999.00000;
   setmodel ( self, "models/fish.mdl");
   self.skin = 0.00000;
   setsize ( self, '-10.00000 -10.00000 -8.00000', '10.00000 10.00000 8.00000');
   self.health = 1.00000;
   self.th_die = fish_die;
   self.think = fish_hover;
   AdvanceThinkTime(self,HX_FRAME_TIME);
};


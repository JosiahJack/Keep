float cube_distance   =  500.00000;

float  ()cube_find_target =  {
local entity item;
   item = findradius ( self.origin, cube_distance);
   while ( item ) {

      if ( (((item.flags & FL_MONSTER) || ((item.classname == "player") && (deathmatch == 1.00000))) && (item.health > 0.00000)) ) {

         tracearea ( self.origin, item.origin, self.mins, self.maxs, FALSE, self);
         if ( (trace_ent == item) ) {

            if ( !(item.effects & EF_NODRAW) ) {

               self.enemy = item;
               return ( TRUE );

            }

         }

      }
      item = item.chain;

   }
   return ( FALSE );
};

void  (vector offset)do_fireball;
vector CubeDirection [6]   = { '90.00000 0.00000 0.00000',
    '-90.00000 0.00000 0.00000',    '0.00000 90.00000 0.00000',    '0.00000 -90.00000 0.00000',    '0.00000 0.00000 90.00000',
    '0.00000 0.00000 -90.00000'};

void  ()cube_fire =  {
local float Distance = 0.00000;
local entity temp;
   if ( (((time > self.monster_duration) || (self.owner.health <= 0.00000)) || (self.shot_cnt >= 10.00000)) ) {

      self.owner.artifact_flags ^= self.artifact_flags;
      remove ( self);
      return ;

   }
   if ( !self.enemy ) {

      self.cnt += 1.00000;
      if ( (self.cnt > 5.00000) ) {

         cube_find_target ( );
         self.cnt = 0.00000;

      }

   }
   if ( self.enemy ) {

      if ( (self.enemy.health <= 0.00000) ) {

         self.enemy = world;

      }

   }
   if ( self.enemy ) {

      if ( (random() < 0.25000) ) {

         Distance = vlen ( (self.origin - self.enemy.origin));
         if ( (Distance > cube_distance) ) {

            self.enemy = world;
         } else {

            temp = self.owner;
            self.owner = self;
            tracearea ( self.origin, self.enemy.origin, self.mins, self.maxs, FALSE, self);
            if ( (trace_ent == self.enemy) ) {

               self.adjust_velocity = (CubeDirection->random(0.00000,5.00000));
               self.abslight = 1.00000;
               self.shot_cnt += 1.00000;
               do_fireball ( '0.00000 0.00000 0.00000');
            } else {

               self.enemy = world;

            }
            self.owner = temp;

         }

      }

   }
};


void  ()cube_rotate =  {
local vector NewOffset = '0.00000 0.00000 0.00000';
   NewOffset = concatv ( self.adjust_velocity, '5.00000 5.00000 5.00000');
   self.adjust_velocity -= NewOffset;
   self.v_angle += NewOffset;
};

vector CubeFollowRate   =  '14.00000 14.00000 14.00000';
vector CubeAttackRate   =  '3.00000 3.00000 3.00000';

void  ()CubeThinkerB =  {
local vector NewSpot = '0.00000 0.00000 0.00000';
local float Distance = 0.00000;
   AdvanceThinkTime(self,0.05000);
   if ( !(self.owner.flags2 & FL_ALIVE) ) {

      remove ( self);
      return ;

   }
   if ( (self.adjust_velocity == '0.00000 0.00000 0.00000') ) {

      cube_fire ( );
      if ( (self.adjust_velocity == '0.00000 0.00000 0.00000') ) {

         if ( (random() < 0.02000) ) {

            self.adjust_velocity = (CubeDirection->random(0.00000,5.00000));

         }

      }

   }
   cube_rotate ( );
   if ( (self.abslight > 0.10000) ) {

      self.abslight -= 0.10000;

   }
   self.angles = (self.owner.angles + self.v_angle);
   self.count += random(4.00000,6.00000);
   if ( (self.count > 360.00000) ) {

      self.count -= 360.00000;

   }
   Distance = vlen ( (self.origin - self.owner.origin));
   if ( (Distance > cube_distance) ) {

      self.enemy = world;

   }
   if ( (self.enemy != world) ) {

      NewSpot = (self.enemy.origin + self.enemy.view_ofs);
      if ( (self.artifact_flags & AFL_CUBE_LEFT) ) {

         NewSpot += (((cos ( self.count) * 40.00000) * '1.00000 0.00000 0.00000') + ((sin ( self.count) * 40.00000) * '0.00000 1.00000 0.00000'));
      } else {

         NewSpot += (((sin ( self.count) * 40.00000) * '1.00000 0.00000 0.00000') + ((cos ( self.count) * 40.00000) * '0.00000 1.00000 0.00000'));

      }
      self.movedir_z += random(10.00000,12.00000);
      if ( (self.movedir_z > 360.00000) ) {

         self.movedir_z -= 360.00000;

      }
      NewSpot_z += (sin ( self.movedir_z) * 10.00000);
      NewSpot = (self.origin + concatv ( (NewSpot - self.origin), CubeAttackRate));
   } else {

      makevectors ( self.owner.v_angle);
      if ( (self.artifact_flags & AFL_CUBE_LEFT) ) {

         NewSpot = (((self.owner.origin + self.owner.view_ofs) + '0.00000 0.00000 10.00000') + v_factor ( '40.00000 60.00000 0.00000'));
      } else {

         NewSpot = (((self.owner.origin + self.owner.view_ofs) + '0.00000 0.00000 10.00000') + v_factor ( '-40.00000 60.00000 0.00000'));

      }
      self.movedir_z += random(10.00000,12.00000);
      if ( (self.movedir_z > 360.00000) ) {

         self.movedir_z -= 360.00000;

      }
      NewSpot += ((((v_right * cos ( self.count)) * 15.00000) + ((v_up * sin ( self.count)) * 15.00000)) + ((v_forward * sin ( self.movedir_z)) * 15.00000));
      NewSpot = (self.origin + concatv ( (NewSpot - self.origin), CubeFollowRate));

   }
   setorigin ( self, NewSpot);
};


void  ()CubeDie =  {
   remove ( self);
};


void  ()UseCubeOfForce =  {
local entity cube;
   if ( ((self.artifact_flags & AFL_CUBE_LEFT) && (self.artifact_flags & AFL_CUBE_RIGHT)) ) {

      return ;

   }
   cube = spawn ( );
   cube.owner = self;
   cube.solid = SOLID_SLIDEBOX;
   cube.movetype = MOVETYPE_NOCLIP;
   cube.flags |= (FL_FLY | FL_NOTARGET);
   setorigin ( cube, cube.owner.origin);
   setmodel ( cube, "models/cube.mdl");
   setsize ( cube, '-5.00000 -5.00000 -5.00000', '5.00000 5.00000 5.00000');
   cube.classname = "cube_of_force";
   cube.health = 10.00000;
   cube.dmg = -1.00000;
   if ( (self.artifact_flags & AFL_CUBE_LEFT) ) {

      self.artifact_flags |= AFL_CUBE_RIGHT;
      cube.artifact_flags |= AFL_CUBE_RIGHT;
   } else {

      self.artifact_flags |= AFL_CUBE_LEFT;
      cube.artifact_flags |= AFL_CUBE_LEFT;

   }
   cube.think = CubeThinkerB;
   cube.th_die = CubeDie;
   AdvanceThinkTime(cube,0.01000);
   cube.monster_duration = (time + 45.00000);
   cube.shot_cnt = 0.00000;
   cube.movedir = '100.00000 100.00000 0.00000';
   cube.count = random(360.00000);
   self.movedir_z = random(360.00000);
   cube.drawflags |= MLS_ABSLIGHT;
   cube.abslight = 0.10000;
   self.cnt_cubeofforce -= 1.00000;
};


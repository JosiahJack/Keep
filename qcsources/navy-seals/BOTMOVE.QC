/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*\
||          norse_movetogoal and related move functions          ||
||                   by Roscoe A. Sincero                        ||
||              e-mail: legion@keg.zymurgy.org                   ||
||                                                               ||
||                   Copyright(c) 1997                           ||
||                                                               ||
||                   Date: June 27, 1997 (v0.30)                 ||
||                   Date: July 03, 1997 (v0.31)                 ||
||                   Date: July 13, 1997 (v0.31.1)               ||
||                   Date: July 21, 1997 (v0.32.0)               ||
||                                                               ||
||                                                               ||
||     Permissions:  You are allowed to use these functions      ||
||                   provided that the original author,          ||
||                   Roscoe A. Sincero gets credit for coding    ||
||                   the functions and that your work is         ||
||                   is publically available to anyone and it    ||
||                   is *FREE*.                                  ||
\*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=*/

/*

   If you wish to add this code or portions of it in a commercial
   product, you will need to contact me _AND_ the individuals mentioned
   in my credits below.

   Norse_movetogoal package v0.32 by Roscoe A. Sincero

   Additional credits: Cameron Newham for Eliminatorbot v1.4.  If it wasn't
   for his bot, I would never had tried to create my own movetogoal
   function.  I had major problems in combining his bot with roambot
   and at the time I couldn't figure out why the bot would simply stop
   for no reason.  So I played around with the FL_ONGROUND flag.  From
   this, I formed the basis for the movetogoal function.  For the curious,
   it turns out that my problems were with those nested if-else block
   statements and had nothing to do with FL_ONGROUND.  The jumping code
   and swimming code used in the eliminatorbot formed the basis for the
   now complicated swim code and jump code.

   Jonathan E. Wright for Cujo v1.4.  I used the FINDLEDGE function and
   used ideas taken from various other functions related to finding gaps
   in the floor.


   NOTE: The swim code assumes that your bot executes a function very similar
         to WaterMove function found in client.qc.  To make your bot blow
         bubbles when it is feeling pain while under water, you must add
         the following line of code to the DeathBubblesSpawn function found
         in player.qc:

            self.owner.waterlevel = norse_waterlevel (self.owner);

         This line is placed *BEFORE* it checks for the owner's waterlevel.
         If the owner's waterlevel is not three, the function will return
         before it spawns any bubbles.

         It is assumed that the bot's initial think function is
         frame_start.  You may need to change this if you use a
         different think function.

   TO USE: To use the new movetogoal function simply replace all instances
           of ID's original movetogoal function with norse_movetogoal.
           You will also need to comment out or delete all lines associated
           with swimming and jumping over gaps.  If you want the bot to
           move at walking speed, replace movetogoal with
           norse_movetogoal (FALSE).  If you want the bot to move at
           running speed, use norse_movetogoal (TRUE).  The actual speed
           of the bot is determined by the skill level of the bot.


               norse_movetogoal (TRUE);

           The above code instructs the bot to run.  If you wish to set
           the actual speed of the bot, then you do this:

               norse_movetogoal (32);

           As long as you don't use values 0 (FALSE) and 1 (TRUE), the
           parameter is used to determine the actual speed of the bot.

           Also new to v0.31 is the ability to specify a direction via
           self.movedir.  As long as self.goalentity does not equal world,
           you can specify a direction the bot can move to.  If self.movedir
           is equal to '0 0 0', then it will head towards self.goalentity.
           If self.movedir does not equal '0 0 0', then it will move towards
           the direction specified by self.movedir.

           Sample use of code:

           self.movedir = '0 100 0';
           norse_movetogoal (32);
           self.movedir = '0 0 0';

           The last self.movedir resets the direction.  Otherwise, the next
           time norse_movetogoal is used, it will move in the direction
           specified by self.movedir.

           If you do not want to specify anything, do the following:
           self.movedir = '0 0 0';
           norse_movetogoal (TRUE);  *OR* norse_movetogoal (FALSE);

           DO NOT USE self.speed.  This variable is used and modified
           within the code.


*/

// variables to be declared
.float   movetogoal_watchdog;
.vector  old_origin;
.entity  maker;
float    botnofind;

// start modification, William
.float   watertype2;
// end modification, William

// function prototypes
void     ()                      PlayerJump;
float    ()                      norse_CheckWaterJump;
float    (entity me)             norse_checkgap;
void     ()                      norse_blind_leap;
float    ()                      norse_jump;
void     ()                      norse_swim;
float    (entity me)             norse_jumpgoal;
void     ()                      WaterMove;
float    (entity me)             norse_recognize_platform;
vector   (entity me)             real_origin;
float    (entity me)             norse_jump_barrier;
float    (entity targ)           visible;
//void     (entity me)             find_trap;
//float    (entity me)             avoid_trap;
float    (entity me, float dist) find_ledge;
float    (entity me, vector org,
          vector dir)            check_traj_pt;

float (entity me) norse_recognize_platform =
{

/*
   assumptions used for platform/door recognition
      a) platforms move up when activated
      b) doors move down when activated (eg. the platform-like entity
         on E1M1 near single-player start location that is activated by
         pressing button)

*/

   local vector   start, end;
   local float plat_speed;
   local vector   actual_origin;

   start = me.origin;
   end = start;
   end_z = end_z - 120;

   traceline (start, end, TRUE, self);
   plat_speed = vlen (trace_ent.velocity);

   if (trace_ent.classname == "plat")
   {
      if (plat_speed)
      {
         actual_origin = real_origin (me.goalentity);
         if (self.origin_z > (actual_origin_z + 64) )
         {
            // if bot's height is higher than goal, then bot is allowed
            // to move.
            return FALSE;
         }
         else
         {
            // goal is either not low enough or it is higher than bot,
            // so bot won't move while platform is moving upwards.
            return TRUE;
         }
      }
   }

   if (trace_ent.classname == "door")
   {
      if (plat_speed)
      {
         actual_origin = real_origin (me.goalentity);
         if (actual_origin_z > (self.origin_z + 64) )
         {
            // if goal's height is higher than bot, then bot is allowed
            // to move.
            return FALSE;
         }
         else
         {
            // bot is either not low enough or it is higher than goal,
            // so bot won't move while door is moving downwards.
            return TRUE;
         }
      }
   }

   return FALSE;
};

vector (entity me) real_origin =
{

   if ( (me.classname == "door") ||
        (me.classname == "plat") ||
        (me.classname == "func_button") ||
        (me.classname == "trigger_teleport") ||
        (me.classname == "trigger_multiple") ||
        (me.classname == "trigger_once") ||
        (me.classname == "func_wall") ||
        (me.classname == "trigger_push") ||
        (me.classname == "trigger_secret"))
   {
      // the origins of these entities need to be calculated using
      // the vectors .absmin and .absmax.
      // code taken from T_Damage function in combat.qc

      return me.absmin + (me.absmax - me.absmin) * 0.5;
   }
   else
      return me.origin;


};

float (entity me) norse_waterlevel =
{

   local float pc;
   if (me == world)
      return 0;

/*
   I originally took the waterlevel code from Jonathan E. Wright's
   CUJO_Waterlevel function of Cujo v1.4.  It has proven to be unreliable
   and more importantly, it is no longer compatible with the move code.
   So I made my own.

   The variable .watertype2 is used instead of .watertype.  The variable
   .watertype can be modified by the Quake engine itself.  Moreover, it
   is also used to produce the unwanted splashing sounds.  To remove the
   splashing sounds, .watertype is permanently set to zero.  .watertype2
   is used instead.

*/

   me.watertype = 0;

   // check at eye level
   pc = pointcontents (me.origin + me.view_ofs);

   if (pc == CONTENT_WATER || pc == CONTENT_SLIME || pc == CONTENT_LAVA)
   {
      me.watertype2 = pc;
      me.waterlevel = 3;
      return 3;   // liquid is at eye/head level, above mouth/nose
   }

   // check at waist level
   pc = pointcontents (me.origin + '0 0 6');

   if (pc == CONTENT_WATER || pc == CONTENT_SLIME || pc == CONTENT_LAVA)
   {
      me.watertype2 = pc;
      me.waterlevel = 2;
      return 2;
   }

   // check at feet level
   pc = pointcontents (me.origin - '0 0 20');

   if (pc == CONTENT_WATER || pc == CONTENT_SLIME || pc == CONTENT_LAVA)
   {
      me.watertype2 = pc;
      me.waterlevel = 1;
      return 1;   // liquid covers legs
   }

   pc = pointcontents (me.origin - '0 0 24');
   if (pc == CONTENT_LAVA || pc == CONTENT_SLIME || pc == CONTENT_WATER)
   {
      me.watertype2 = pc;
      me.waterlevel = 1;
      return 1;
   }


   me.watertype2 = 0;
   me.waterlevel = 0;
   return 0;   // water, if any, is not significant


};


void(float run_type) norse_movetogoal =
{
   // norse_movetogoal was initially designed for chasing moving targets
   // and it was originally called bot_movetogoal in the doombot project.
   // However, modifications have been made so that, hopefully, it will
   // work great with non-moving targets as well.  Additional changes
   // were made to allow the bot to move in one direction but face another.

   // need to check if bot is on top of a moving entity
   if (norse_recognize_platform (self))
   {
      // bot is on a platform, so don't move
      self.velocity = '0 0 0';
      return;
   }

   // check to see if bot needs to swim.  It is assumed that the
   // WaterMove function is executed PRIOR to executing the movetogoal
   // function.
   if (norse_waterlevel(self) > 1)
   {
      norse_swim ();
      return;
   }

   // bot can not move if it is not on the ground.
   if (!(self.flags & FL_ONGROUND))
      return;

   local vector  dir, actual_origin;
   local vector   dir_angles;
   local float dist;

/* variable discriptions:

   dir:           this is the VECTOR direction that the bot is moving to
   dir_angles:    this vector contains the BEARING (angle of direction
                  in dir) and PITCH (up/down angle of dir).
   actual_origin: the actual origin of goal.  This is needed for entities
                  such as doors and teleporters.
   dist:          distance from goal
*/


   // it is usually a good idea to check to see if there is a gap in front
   // of the bot.  Bot will only check for gaps in the direction of its
   // actual goal.  So, the owner of the bot can literally force the bot
   // to land in lava.  Enemies can not, however, since it will check for
   // gaps.
   local float gap;
   gap = norse_checkgap (self);

   local float jump_to_goal;
   jump_to_goal = norse_jumpgoal (self);

   self.speed = 0;
   if (gap)
   {
      if (norse_jump ())
      {  return;
      }
   }
   else if (norse_jump_barrier (self))
   {  return;
   }
   else if (jump_to_goal)
   {
      norse_blind_leap ();
      return;
   }

   if (self.speed)
      run_type = self.speed;

   if (self.movedir == '0 0 0')
   {
      actual_origin = real_origin(self.goalentity);
      actual_origin_z = self.origin_z;
      dir = (actual_origin - self.origin);
      dist = vlen(dir);
   }
   else
   {
      actual_origin = real_origin(self.goalentity);
      dir = self.movedir;
      dist = vlen(dir);
   }


   if ((self.goalentity.classname == "player" ||
      self.goalentity.classname == "bot") && (self.goalentity != self.owner)
      && (self.goalentity != self.maker))
   {
      if (dist < 72 && self.movedir == '0 0 0')
      {
         // too close to live target already
         self.velocity_x = 0;
         self.velocity_y = 0;
         return;
      }
   }

   // bot is on the ground, so now take it off the ground to allow the bot
   // to move freely.
   if (self.flags & FL_ONGROUND)
      self.flags = self.flags - FL_ONGROUND;

   // initialize velocity of bot to 0,0,0
   self.velocity_x = self.velocity_y = self.velocity_z = 0;

   // based on the vector direction of bot, vectoangles function is
   // used to calculate dir_angles described above
   dir_angles = vectoangles (dir);

   local vector   a, b;

   // if the enemy is the goal and the enemy is far above the bot,
   // then the bot will not chase the enemy.  It will stay at a
   // certain distance away.
   local float horiz_dist;
   a = actual_origin; a_z = 0;
   b = self.origin; b_z = 0;
   horiz_dist = fabs(vlen (a - b));
   local float r;

   if (self.goalentity == self.enemy)
   {

      if ( (actual_origin_z - self.origin_z) > 160)
      {
         if (horiz_dist < 224 && self.movedir == '0 0 0')
         {
            // too close back away now
            dir = dir * -1;
            dir_angles = vectoangles (dir);
         }

      }

   }

   // calculate the velocity of the bot using dir as the basis where
   // dir is the VECTOR direction the bot is moving to.  If run_type
   // is true meaning bot is running, use running speed.  If run_type
   // is false, use walking speed. The variable .bot_skill is used
   // to store the skill level of the bot.  This has been commented
   // out and maximum skill of 3 is used instead.

   local float horizontal_speed;
   local float max_speed;

   if (run_type == 1)
   {
      horizontal_speed = 336 + (32) * 3; // self.bot_skill;
   }
   else if (run_type == 0)
   {
      horizontal_speed = 240 + (32) * 3; // self.bot_skill;
   }
   else
   {
      horizontal_speed = run_type * 1.35 * 10;

   }
/*
   // now checking for type1 traps to avoid
   local float trap_dir;
   find_trap (self);
   trap_dir = avoid_trap(self);
   if (trap_dir == 1)
   {
      // turn left
      dir = dir - v_right * (0.66 * dist);
   }
   else if (trap_dir == 2)
   {
      // turn right
      dir = dir + v_right * (0.66 * dist);
   }
*/

   // Need to cap speed of bot just in case, you decided to
   // use a skill level greater than 3.
   max_speed = 1.4 * (cvar("sv_maxspeed"));
   if (horizontal_speed > max_speed)
      horizontal_speed = max_speed;

   // if self.goalentity is self.owner or self.maker and
   // self.goalentity is too close to bot, bot will back up
   local float nohop;

   if (self.goalentity == self.owner ||
       self.goalentity == self.maker)
   {
      if (dist < 42)
      {
         dir = dir * -1;
         dir_angles = vectoangles (dir);
         horizontal_speed = 224;
         nohop = TRUE;
      }
      else if (dist < 72)
      {
         // close enough but not too close
         self.velocity_x = 0;
         self.velocity_y = 0;
         return;
      }

   }

   if (self.goalentity == world ||
      (actual_origin_x < 1 &&
       actual_origin_y < 1 &&
       actual_origin_z < 1) )
   {
      // if for some reason, no goal is set.  Then the bot will
      // move in the forward direction it is currently facing.
      makevectors (self.angles);
      dir = v_forward;
      dir_angles = vectoangles (dir);

   }

   // v_forward, v_right, and v_up (forward direction, right, and up)
   // are calculated by using the makevectors function with dir_angles
   // as the basis for calculation.  Originally, self.angles, instead
   // of dir_angles, was used in the original bot_movetogoal function
   // where self.angles is the direction the bot is currently facing.
   // Since the purpose of this modified movetogoal function is to
   // allow the bot to move in one direction while facing another,
   // self.angles is no longer used.
   makevectors (dir_angles);


   // now need to check to see if there is a barrier at bot's orgin
   // in the way of bot.  if so, try to manuever around it.
   local vector left, right, left_end, right_end;
   local float left_block, right_block;
   local float block;
   block = dist * 2.5;  // this is equivalent to changing the direction by
                        // 68.2 degrees left or right depending on which
                        // way bot decides to go. remember, the length of
                        // dir is the distance between bot and goal so the
                        // amount you add to dir will have to take this into
                        // account.  Initially, I set the block factor to a
                        // value of 32.  If you don't take into account the
                        // distance, then if the bot is close to the goal,
                        // the bot will make a very sharp change in
                        // direction when avoiding obstacle.  That is, it
                        // will move 90 degrees.  If the goal is far away,
                        // bot will have a difficult time manuevering around
                        // obstacles.  By taking into account the distance,
                        // the bot's ability to move around obstacles will
                        // be the same no matter how far the goal is.

   left_block = right_block = FALSE;

   left = self.origin - v_right * 15;
   left_end = left + v_forward * 24;

   right = self.origin + v_right * 15;
   right_end = right + v_forward * 24;

   // old: traceline (left, left_end, TRUE, self); - try to walk thru monsters
   traceline (left, left_end, FALSE, self);
   if (trace_fraction != 1.0)
      left_block = TRUE;
   // old: traceline (right, right_end, TRUE, self); - try to walk thru monsters
   traceline (right, right_end, FALSE, self);
   if (trace_fraction != 1.0)
      right_block = TRUE;

   if (left_block && !right_block)
   {
      dir = dir + v_right * block;
      horizontal_speed = 160; // need to reduce speed
   }
   else if (right_block && !left_block)
   {
      dir = dir + v_right * (0 - block);
      // QuakeC is pretty crappy.  It does not recognize "-block" so I use
      // (0 - block) which is the same thing.
      horizontal_speed = 160; // need to reduce speed


   }
   else if (left_block && right_block)
   {
      left_block = right_block = FALSE;
      left = self.origin - v_right * 31;
      left_end = left + v_forward * 24;

      right = self.origin + v_right * 31;
      right_end = right + v_forward * 24;

      // old: traceline (left, left_end, TRUE, self); - try to walk thru monsters
      traceline (left, left_end, FALSE, self);
      if (trace_fraction != 1.0)
         left_block = TRUE;
      // old: traceline (right, right_end, TRUE, self); - try to walk thru monsters
      traceline (right, right_end, FALSE, self);
      if (trace_fraction != 1.0)
         right_block = TRUE;

      if (left_block && !right_block)
      {
         dir = dir + v_right * block;

      }
      else if (right_block && !left_block)
      {
         dir = dir + v_right * (0 - block);

      }
      else if (left_block && right_block)
      {

         left_block = right_block = FALSE;
         left = self.origin - v_right * 47;
         left_end = left + v_forward * 24;

         right = self.origin + v_right * 47;
         right_end = right + v_forward * 24;

         // old: traceline (left, left_end, TRUE, self); - try to walk thru monsters
         traceline (left, left_end, FALSE, self);
         if (trace_fraction != 1.0)
            left_block = TRUE;
         // old: traceline (right, right_end, TRUE, self); - try to walk thru monsters
         traceline (right, right_end, FALSE, self);
         if (trace_fraction != 1.0)
            right_block = TRUE;

         if (left_block && !right_block)
         {
            dir = dir + v_right * block;

         }
         else if (right_block && !left_block)
         {
            dir = dir + v_right * (0 - block);

         }
         else if (left_block && right_block)
         {
            left_block = right_block = FALSE;
            left = self.origin - v_right * 63;
            left_end = left + v_forward * 24;

            right = self.origin + v_right * 63;
            right_end = right + v_forward * 24;

            // old: traceline (left, left_end, TRUE, self); - try to walk thru monsters
            traceline (left, left_end, FALSE, self);
            if (trace_fraction != 1.0)
               left_block = TRUE;
            // old: traceline (right, right_end, TRUE, self); - try to walk thru monsters
            traceline (right, right_end, FALSE, self);
            if (trace_fraction != 1.0)
               right_block = TRUE;

            if (left_block && !right_block)
            {
               dir = dir + v_right * block;

            }
            else if (right_block && !left_block)
            {
               dir = dir + v_right * (0 - block);

            }
            else if (left_block && right_block)
            {

               dir = dir + v_forward * (0 - block);
            }
         }

      }

   }


   // now check to see if bot is not too close to the walls
   local vector start, end;
   start = self.origin;
   end = self.origin + v_right * 20;
   traceline (start, end, TRUE, self);
   if (trace_fraction != 1.0)
   {
      // wall too close on bot's right side so move a little to left
      dir = dir + v_right * (0 - block);
      horizontal_speed = 160;
   }

   start = self.origin;
   end = self.origin + v_right * (-20);
   traceline (start, end, TRUE, self);
   if (trace_fraction != 1.0)
   {
      // wall too close on bot's left side so move a little to right
      dir = dir + v_right * (block);
      horizontal_speed = 160;

   }


   // now check to see if it is heading towards a teleporter
   local entity   article;
   local entity   selected;
   article = world;
   article = findradius (self.origin, 128);

   while (article)
   {
      if (article.classname == "trigger_teleport")
      {
         selected = article;
      }
      article = article.chain;
   }

   if (selected.classname == "trigger_teleport")
   {
      //bprint ("slowing down\n");
      // slow down to allow whoever is ahead of them to pass through
      horizontal_speed = 192;

   }


   // now normalize the vector direction.
   dir = normalize (dir);

   self.velocity = horizontal_speed * dir;

   // Many times, the bot will get stuck.  The causes for this varies
   // greatly from goal is far below bot to a small object mearly two
   // or three units high blocking the foot of bot.

   local float hop_factor;
   local float checka1, checkb1;
   local float incline1;
   local float incline2;
   local float incline3;

   // hop factor is used if bot is on a map in which sv_gravity
   // has been altered.

   if (self.movetogoal_watchdog < time)
   { if (vlen(self.origin - self.old_origin) < 24)
      {  if (self.goalentity.origin_z + 24 < self.origin_z)
         {
            // raise bot three units and reduce speed
            self.origin_z = self.origin_z + 3;
         }
         else
         {  // hop a little
            if (self.waterlevel == 1)
            {
               local vector ahead;
               ahead = v_forward;
               ahead_z = 0;
               start = self.origin;
               start_z = start_z - 22;
               end = start;
               end = end + v_forward * 64;
               traceline (start, end, TRUE, self);

               if (trace_fraction < 1)
               {
                  hop_factor = cvar ("sv_gravity");
                  hop_factor = hop_factor / 800;
                  self.origin_z = self.origin_z + 8;
                  self.velocity_z = 160 * hop_factor;


               }
               else
               {
                  if (!nohop)
                  {
                     hop_factor = cvar ("sv_gravity");
                     hop_factor = hop_factor / 800;
                     self.velocity_z = 56 * hop_factor;
                  }
               }


            }
            else
            {
               if (!nohop)
               {  hop_factor = cvar ("sv_gravity");
                  hop_factor = hop_factor / 800;
                  // subtle direction change - william
                  dir   = vectoangles(dir);
                  dir_y = dir_y + 5 * random();
                  makevectors(dir);
                  dir = v_forward;
                  normalize(dir);

                  self.velocity = horizontal_speed * dir;
                  // end dir change
                  self.velocity_z = 36 * hop_factor;
               }
            }

         }
      }

      self.movetogoal_watchdog = time + 0.2 * (320/horizontal_speed);
   }


   local vector   start, end, ahead;
   local vector projected_dest;
   local float LAVA_LEAP;

   // now need to determine if target is leading
   // bot into lava

   start = self.enemy.origin;
   end = start;
   traceline (start, end, TRUE, self);
   if (pointcontents(trace_endpos) == CONTENT_LAVA)
      LAVA_LEAP = TRUE;
   end_z = end_z - 32;
   traceline (start, end, TRUE, self);
   if (pointcontents(trace_endpos) == CONTENT_LAVA)
      LAVA_LEAP = TRUE;

   start = self.enemy.origin + normalize (self.enemy.velocity) * 12;
   end = start;
   traceline (start, end, TRUE, self);
   if (pointcontents(trace_endpos) == CONTENT_LAVA)
      LAVA_LEAP = TRUE;
   end_z = end_z - 32;
   traceline (start, end, TRUE, self);
   if (pointcontents(trace_endpos) == CONTENT_LAVA)
      LAVA_LEAP = TRUE;
   end_z = end_z - 56;
   traceline (start, end, TRUE, self);
   if (pointcontents(trace_endpos) == CONTENT_LAVA)
      LAVA_LEAP = TRUE;

   start = self.enemy.origin + normalize (self.enemy.velocity) * 24;
   end = start;
   traceline (start, end, TRUE, self);
   if (pointcontents(trace_endpos) == CONTENT_LAVA)
      LAVA_LEAP = TRUE;
   end_z = end_z - 32;
   traceline (start, end, TRUE, self);
   if (pointcontents(trace_endpos) == CONTENT_LAVA)
      LAVA_LEAP = TRUE;
   end_z = end_z - 56;
   traceline (start, end, TRUE, self);
   if (pointcontents(trace_endpos) == CONTENT_LAVA)
      LAVA_LEAP = TRUE;

   start = self.enemy.origin + normalize (self.enemy.velocity) * 36;
   end = start;
   traceline (start, end, TRUE, self);
   if (pointcontents(trace_endpos) == CONTENT_LAVA)
      LAVA_LEAP = TRUE;
   end_z = end_z - 32;
   traceline (start, end, TRUE, self);
   if (pointcontents(trace_endpos) == CONTENT_LAVA)
      LAVA_LEAP = TRUE;
   end_z = end_z - 56;
   traceline (start, end, TRUE, self);
   if (pointcontents(trace_endpos) == CONTENT_LAVA)
      LAVA_LEAP = TRUE;

   projected_dest = self.enemy.origin + normalize (self.enemy.velocity) * 56;
   start = projected_dest;
   end = start;
   end_z = end_z - 32;
   traceline (start, end, TRUE, self);
   if (pointcontents(trace_endpos) == CONTENT_LAVA)
      LAVA_LEAP = TRUE;
   traceline (start + v_right * 32, end + v_right * 32, TRUE, self);
   if (pointcontents(trace_endpos) == CONTENT_LAVA)
      LAVA_LEAP = TRUE;
   traceline (start - v_right * 32, end - v_right * 32, TRUE, self);
   if (pointcontents(trace_endpos) == CONTENT_LAVA)
      LAVA_LEAP = TRUE;
   if (LAVA_LEAP)
   {
      self.velocity_x = self.velocity_x * -0.3;
      self.velocity_y = self.velocity_y * -0.3;
      self.velocity_z = 0;
      self.goalentity = world;
      self.enemy = world;
/* OOPS - William
      self.bot_think_status = BOT_STAND;
      self.think = frame_start;
      self.nextthink = time + frametime;
OOPS - William */
   }


   // now need to check for steps and inclines

   local float f, old_f, z_ht, z_dist, i;
   i = 0;
   old_f = FALSE;
   z_ht = FALSE;
   z_dist = FALSE;

   while (i < 17)
   {
      start = self.origin;
      start_z = start_z - 24;
      start_z = start_z + i;
      end = start;
      end = start + v_forward * 100;
      traceline (start, end, FALSE, self);
      f = trace_fraction * 100;
      if (f > old_f)
      {
         if (!z_ht)
         {
            z_ht = i;
            z_dist = old_f;
         }
      }

      old_f = f;

      i = i + 1;
   }

   if (z_dist <= 32)
   {
      start = self.origin;
      start_z = start_z + z_ht + 1;
      setorigin (self, start);
   }

   self.old_origin = self.origin;
};



float (entity me) norse_jumpgoal =
{
   local vector  dir, actual_origin, dir_angles;
   local vector start, end;
   local float pc;
   local float dist;
   actual_origin = real_origin(me.goalentity);
   actual_origin_z = me.origin_z;

   if (self.movedir == '0 0 0')
   {
      dir = (actual_origin - me.origin);
      dist = vlen (dir);
      dir_angles = vectoangles (dir);
   }
   else
   {
      dir = self.movedir;
      dist = vlen(dir);
      dir_angles = vectoangles (dir);
   }


   makevectors (dir_angles);

   if (self.goalentity == world ||
      (actual_origin_x < 1 &&
       actual_origin_y < 1 &&
       actual_origin_z < 1) )
   {
      // if for some reason, no goal is set.  Then the bot will
      // move in the forward direction it is currently facing.
      makevectors (self.angles);
      dir = v_forward;
      dir_angles = vectoangles (dir);

   }

   if ((me.enemy.origin_z - me.origin_z) > 128 && (me.enemy.velocity_z > 0))
   {
      if (visible(me.enemy))
      {
         if (me.enemy)
            return TRUE;
      }
   }

   if (norse_waterlevel (me) == 1)
   {
      if (me.watertype2 == CONTENT_LAVA)
      {

         //bprint ("ouch! ouch! hot! hot!\n");

         return TRUE;
      }
   }

   return FALSE;

};

float (entity me) norse_jump_barrier =
{

   local vector  dir, actual_origin, dir_angles;
   local vector start, end;
   local float check1, check2, check3, check4, check5;
   local float pc;
   local float dist;
   actual_origin = real_origin(me.goalentity);
   actual_origin_z = me.origin_z;
   if (me.movedir == '0 0 0')
   {
      dir = (actual_origin - me.origin);
      dist = vlen (dir);
      dir_angles = vectoangles (dir);
   }
   else
   {
      dir = me.movedir;
      dist = vlen (dir);
      dir_angles = vectoangles (dir);
   }

   makevectors (dir_angles);

   if (me.goalentity == world ||
      (actual_origin_x < 1 &&
       actual_origin_y < 1 &&
       actual_origin_z < 1) )
   {
      // if for some reason, no goal is set.  Then the bot will
      // move in the forward direction it is currently facing.
      makevectors (me.angles);
      dir = v_forward;
      dir_angles = vectoangles (dir);

   }



   v_forward_z = 0;

   local vector start, end;

   start = me.origin + me.view_ofs + v_up * 18;
   end = start + v_forward * 48;
   traceline (start, end, FALSE, me);
   if (trace_fraction < 1)
      return FALSE;


   local float f, z_dist, z_ht, f1;

   local float i;
   i = 0;

   f1 = 0;
   z_ht = FALSE;
   z_dist = FALSE;

   while (i < 38)
   {
      start = me.origin;
      start_z = start_z - 24;
      start_z = start_z + i;
      end = start;
      end = end + v_forward * 100;
      traceline (start, end, TRUE, self);
      f = trace_fraction * 100;
      if (f > f1)
      {
         if (!z_ht)
         {
            z_ht = i;
            z_dist = f1;
         }
      }

      f1 = f;

      i = i + 1;
   }

   local float tol1;
   tol1 = 32;
   if (z_ht > 18)
   {
      // it is not a steep stairs
      if ((z_dist > tol1) && (z_dist < 45))
      {
         // close enough to jump

         me.flags = me.flags - (me.flags & FL_ONGROUND);

         me.velocity_x = v_forward_x * 64;//(256);
         me.velocity_y = v_forward_y * 64;//(256);

         me.velocity_z = 270;
         //jump_sound ();
         sound (me, CHAN_BODY, "player/plyrjmp8.wav", 1, ATTN_NORM);


         return TRUE;
      }
      else if ((z_dist <=tol1))
      {
         // too close
         me.movedir = v_forward * -1000;
         me.speed = 10;
         return FALSE;
      }
      else if (z_dist < 100)
      {
         me.speed = 10;
      }


   }


   return FALSE;

};


float (entity me) norse_checkgap =
{


   if (me.waterlevel)
   {
      // bot is not on dry land.  So why would the bot need to check
      // for gaps.  It is too late for that now.
      return FALSE;
   }

   // checks if there is a gap.
   // returns TRUE if there is a non-walkable gap
   // returns FALSE if there is no gap or there is a
   // walkable gap

   local vector   start, end, ahead;
   local float dist;

   local vector  dir, actual_origin, dir_angles;
   actual_origin = real_origin(me.goalentity);
   actual_origin_z = me.origin_z;

   if (me.movedir == '0 0 0')
   {
      dir = (actual_origin - me.origin);
      dir_angles = vectoangles (dir);
   }
   else
   {
      dir = me.movedir;
      dir_angles = vectoangles (dir);
   }

   makevectors (dir_angles);

   if (me.goalentity == world ||
      (actual_origin_x < 1 &&
       actual_origin_y < 1 &&
       actual_origin_z < 1) )
   {
      // if for some reason, no goal is set.  Then the bot will
      // move in the forward direction it is currently facing.
      makevectors (me.angles);
      dir = v_forward;
      dir_angles = vectoangles (dir);

   }

   ahead = v_forward;
   ahead_z = 0;

   dist = 128;
   
   start = me.origin;
   end = start - '0 0 28' + ahead * dist;
   traceline (start, end, TRUE, me);
   if (trace_fraction != 1.0)
   {
      return FALSE;
   }

   // bot did not find any solid dist units in front.  There could be a
   // gap at this distance.  Nevertheless, bot needs to check to see if
   // there is a barrier in front to prevent bot from jumping before
   // any additional analysis of the alleged gap is performed.

   end = start + ahead * 48;
   traceline (start, end, FALSE, me);
   if (trace_fraction != 1.0)
   {
      return FALSE;
   }

   start = me.origin + '0 0 8';
   end = start + ahead * 48;
   traceline (start, end, FALSE, me);
   if (trace_fraction != 1.0)
   {
      return FALSE;
   }

   start = me.origin + '0 0 12';
   end = start + ahead * 48;
   traceline (start, end, FALSE, me);
   if (trace_fraction != 1.0)
   {
      //bprint ("barrier at chest\n");
      return FALSE;
   }

   start = me.origin + '0 0 18';
   end = start + ahead * 48;
   traceline (start, end, FALSE, me);
   if (trace_fraction != 1.0)
   {
      return FALSE;
   }

   start = me.origin + self.view_ofs;
   end = start + ahead * 48;
   traceline (start, end, FALSE, me);
   if (trace_fraction != 1.0)
   {
      return FALSE;
   }

   // need to determine how far away this alleged gap is
   local float dist_from_gap;
   local float i;

   i = 17; // start at 17 units from origin
   dist_from_gap = 0;

   while (i < dist)
   {
      start = me.origin + ahead * i;         
      end = start;
      end_z = end_z - 32;
      traceline (start, end, TRUE, me);
      if (trace_fraction == 1.0)
      {
         if (!dist_from_gap)
            dist_from_gap = i;
      }

      i = i + 4;
   }

   // begin analyzing this alleged gap
   // code modified from Cujo v1.4

   dist = dist_from_gap;
   dist = dist + 5 * (3 /*me.bot_skill*/);
                                      // don't want dist to be too large or
                                      // too small.  Large value means bigger
                                      // margin of error but too large then
                                      // bot can misjudge gap.

   local float trace_dist;
   local float fwd_inc;
   local float solid_count;
   trace_dist = 1000;
   fwd_inc = 8;
   solid_count = 0;
   i = 0;

   start = me.origin + ahead * (dist - fwd_inc);
   end = start;
   end_z = end_z - trace_dist;

   local float fwd;
   local float f;

   while (i < 4)
   {
      start = start + ahead * fwd_inc;
      end = end + ahead * fwd_inc;

      // check in front of bot
      traceline (start, end, TRUE, me);
      if (trace_fraction * trace_dist < 64)
         solid_count = solid_count + 1;

      // check at right of bot
      traceline (start + v_right * 15, end + v_right * 15, TRUE, me);
      if (trace_fraction * trace_dist < 64)
         solid_count = solid_count + 1;

      // check at left of bot
      traceline (start - v_right * 15, end + v_right * 15, TRUE, me);
      if (trace_fraction * trace_dist < 64)
         solid_count = solid_count + 1;
      
      i = i + 1;
   }

   if (solid_count)
   {
      return FALSE;
   }

   // now as we all know by now, traceline function SUCKS.  Finding a
   // non-walkable gap does not mean that there is a non-walkable gap.
   // So continue analyzing this alleged gap by trying to find a ledge.
   // This is the ledge the bot will jump to.

   // If no ledge is found, then this gap is either walkable or is
   // non-existent.

   // ledge code taken from Cujo v1.4
   
   local float ledge;
   ledge = find_ledge (me, dist_from_gap);

   if (!ledge)
   {
      //bprint ("Ledge not found\n");
      return FALSE;
   }
   
   if ( (dist_from_gap >= 48) && (dist_from_gap <= 70))
   {
      //bprint ("Close to gap need to slow down\n");
      self.speed = 8;
      return FALSE;
   }
   else if ((dist_from_gap > 70) && (dist_from_gap < 96))
   {
      self.speed = 18;
      return FALSE;
   }
   else if (dist_from_gap >=96)
   {
      return FALSE;
   }

   return TRUE;

};

float(entity me, float dist) find_ledge =
{

   // code taken from Cujo v1.4

   local vector   start, end;
   local vector   above_start;
   local float highest;
   local float found_ledge;
   local float ledge_height;
   local float i;

   local vector  dir, actual_origin, dir_angles;
   actual_origin = real_origin(me.goalentity);
   actual_origin_z = me.origin_z; 

   if (me.movedir == '0 0 0')
   {
      dir = (actual_origin - me.origin);
      dir_angles = vectoangles (dir);
   }
   else
   {
      dir = me.movedir;
      dir_angles = vectoangles (dir);
   }

   makevectors (dir_angles);

   if (me.goalentity == world ||
      (actual_origin_x < 1 &&
       actual_origin_y < 1 &&
       actual_origin_z < 1) )
   {
      // if for some reason, no goal is set.  Then the bot will
      // move in the forward direction it is currently facing.
      makevectors (me.angles);
      dir = v_forward;
      dir_angles = vectoangles (dir);

   }

   above_start = me.origin + v_up * 48;
   found_ledge = FALSE;

   ledge_height = 0.096;  
   i = dist + 30;


   // Modifications to the find ledge code to take into account
   // different gravities.  Mod made by Roscoe A. Sincero
   local float tol;
   local float grav_fac;
   grav_fac = cvar ("sv_gravity");
   grav_fac = 800 / grav_fac; 
   tol = 320 * grav_fac;
   
   
   while ((i <= tol) && (!found_ledge))
   {
      start = above_start + (v_forward * (i + 30)) + (v_right * 15);
      end = start - (v_up * 1000);
      traceline (start, end, FALSE, me);
      highest = trace_fraction;

      if (trace_fraction <= ledge_height)
      {
         start = above_start + (v_forward * (i + 30)) - (v_right * 15);
         end = start - (v_up * 1000);
         traceline (start, end, FALSE, me);
         if (trace_fraction < highest)
            highest = trace_fraction;

         if (trace_fraction <= ledge_height)
         {
            start = above_start + (v_forward * i) + (v_right * 15);
            end = start - (v_up * 1000);
            traceline (start, end, FALSE, me);
            if (trace_fraction < highest)
               highest = trace_fraction;
            
            if (trace_fraction <= ledge_height)
            {
               start = above_start + (v_forward * i) - (v_right * 15);
               end = start - (v_up * 1000);
               traceline (start, end, FALSE, me);
               if (trace_fraction < highest)
                  highest = trace_fraction;

               if (trace_fraction <= ledge_height)
               {
                  start = above_start + (v_forward * (i + 15));
                  end = start - (v_up * 1000);
                  traceline (start, end, FALSE, me);
                  if (trace_fraction < highest)
                     highest = trace_fraction;
               
                  if (trace_fraction <= ledge_height)
                  {
                     start = above_start + (v_forward * (i + 7.5)) - (v_right * 7.5);
                     end = start - (v_up * 1000);
                     traceline (start, end, FALSE, me);
                     if (trace_fraction < highest)
                        highest = trace_fraction;
      
                     if (trace_fraction <= ledge_height)
                     {
                        start = above_start + (v_forward * (i + 7.5)) + (v_right * 7.5);
                        end = start - (v_up * 1000);
                        traceline (start, end, FALSE, me);
                        if (trace_fraction < highest)
                           highest = trace_fraction;

                        if (trace_fraction <= ledge_height)
                           found_ledge = TRUE;
                     }
                  }
               }
            }
         }
      }

      i = i + 30;
   }

   return found_ledge;

};

float(entity me) norse_tryjump =
{

   local vector  dir, actual_origin, dir_angles;
   actual_origin = real_origin(me.goalentity);
   actual_origin_z = me.origin_z;

   if (me.movedir == '0 0 0')
   {
      dir = (actual_origin - me.origin);
      dir_angles = vectoangles (dir);
   }
   else
   {
      dir = me.movedir;
      dir_angles = vectoangles (dir);
   }

   makevectors (dir_angles);


   local vector test_vel;
   local float i;
   local vector   org;

   test_vel = me.velocity;

   local vector   start, end;
   org = me.origin;
   org_z = org_z - 22;

   i = 0;

// OOPS - William
//   if (me.human)
//    test_vel = me.velocity;
//   else
//   {
      test_vel = v_forward * 320;
      test_vel_z = 270;
//   }

   local vector   destination;
   destination = '0 0 0';

   local float f;
   f = 0;
   while (i < 32)
   {
      test_vel_z = test_vel_z - cvar("sv_gravity") * frametime;
      org = org + (test_vel * frametime);
      start = org;
      end = start + v_forward * 32;
      traceline (start, end, FALSE, me);
      if (trace_fraction < 1)
      {
         // hit a wall
         test_vel_x = 0;
         test_vel_y = 0;
         if (test_vel_z > 0)
            test_vel_z = 0;
         if (destination == '0 0 0')
            destination = org;

      }

      end = start + me.view_ofs;
      end = end + v_up * 16;
      traceline (start, end, FALSE, me);
      if (trace_fraction < 1)
      {
         // hit a ceiling
         if (test_vel_z > 0)
            test_vel_z = 0;

      }


      if (test_vel_z < 0)
      {

         if (check_traj_pt (me, org, v_forward))
         {
            if (destination == '0 0 0')
               destination = org;
         }
      }

      i = i + 1;

   }


   if (destination == '0 0 0')
   {
      return FALSE;
   }

   local float pc;
   local float lava_count;

   lava_count = 0;

   start = destination;
   end = start;
   end_z = end_z - 1000;
   traceline (start, end, FALSE, me);
   pc = pointcontents (trace_endpos);
   if (pc == CONTENT_LAVA)
      lava_count = lava_count + 1;

   start = destination + v_forward * 12;
   end = start;
   end_z = end_z - 1000;
   traceline (start, end, FALSE, me);
   pc = pointcontents (trace_endpos);
   if (pc == CONTENT_LAVA)
      lava_count = lava_count + 1;

   if (lava_count == 2)
   {
      return FALSE;
   }
   else
   {
      return TRUE;
   }


};

float (entity me, vector org, vector dir) check_traj_pt =
{

   // checks to see if trajectory point will cause bot to land on
   // a solid.  Returns TRUE if bot will land on solid at this
   // point.
   local vector start, end;

   start = org;
   end = start;
   end_z = end_z - (24 + 8);
   traceline (start, end, FALSE, me);
   if (trace_fraction < 1)
      return TRUE;

   start = org + dir * 12;
   end = start;
   end_z = end_z - (24 + 8);
   traceline (start, end, FALSE, me);
   if (trace_fraction < 1)
      return TRUE;


};


float () norse_jump =
{
   if (!(self.flags & FL_ONGROUND))
   {
      return;
   }

   local vector  dir, actual_origin, dir_angles;
   actual_origin = real_origin(self.goalentity);
   actual_origin_z = self.origin_z;

   if (self.movedir == '0 0 0')
   {
      dir = (actual_origin - self.origin);
      dir_angles = vectoangles (dir);
   }
   else
   {
      dir = self.movedir;
      dir_angles = vectoangles (dir);
   }

   makevectors (dir_angles);

   if (self.goalentity == world ||
      (actual_origin_x < 1 &&
       actual_origin_y < 1 &&
       actual_origin_z < 1) )
   {
      // if for some reason, no goal is set.  Then the bot will
      // move in the forward direction it is currently facing.
      makevectors (self.angles);
      dir = v_forward;
      dir_angles = vectoangles (dir);

   }

   if (norse_tryjump (self))
   {
      norse_blind_leap ();
      //bprint ("Jumping for my life\n");
      return TRUE;
   }

   dir = dir * -1;
   self.movedir = dir;
   return FALSE;

};

void() norse_blind_leap =
{
   local float horizontal_speed;
   local float max_speed;

   local vector  dir, actual_origin, dir_angles;
   actual_origin = real_origin(self.goalentity);
   if (self.movedir == '0 0 0')
   {
      dir = (actual_origin - self.origin);
      dir_angles = vectoangles (dir);
   }
   else
   {
      dir = self.movedir;
      dir_angles = vectoangles (dir);
   }

   makevectors (dir_angles);

   if (self.goalentity == world ||
      (actual_origin_x < 1 &&
       actual_origin_y < 1 &&
       actual_origin_z < 1) )
   {
      // if for some reason, no goal is set.  Then the bot will
      // move in the forward direction it is currently facing.
      makevectors (self.angles);
      dir = v_forward;
      dir_angles = vectoangles (dir);

   }


   horizontal_speed = 336 + (32) * (3);//self.bot_skill);

   // Need to cap speed of bot just in case, you decided to
   // use a skill level greater than 3.

   max_speed = 1.4 * (cvar("sv_maxspeed"));
   if (horizontal_speed > max_speed)
      horizontal_speed = max_speed;

   self.velocity_x = v_forward_x * horizontal_speed;
   self.velocity_y = v_forward_y * horizontal_speed;


	if ( !(self.flags & FL_JUMPRELEASED) )
      self.flags = self.flags + FL_JUMPRELEASED;

   PlayerJump ();

};

void() norse_swim =
{  //bprint("norse_swim - ");

   local vector   norm_vel;
   local float pc, dist;

   local vector  dir, actual_origin, dir_angles;
   actual_origin = real_origin(self.goalentity);
   if (self.movedir == '0 0 0')
   {  //bprint(" moving to target ");
      //bprint(self.goalentity.classname);
      //bprint("::");
      //bprint(self.goalentity.netname);
      dir = (actual_origin - self.origin);
      dist = vlen(dir);
      dir_angles = vectoangles (dir);
   }
   else
   {
      dir = self.movedir;
      dist = vlen(dir);
      dir_angles = vectoangles (dir);
   }

   makevectors (dir_angles);

   if (self.goalentity == world ||
      (actual_origin_x < 1 &&
       actual_origin_y < 1 &&
       actual_origin_z < 1) )
   {
      // if for some reason, no goal is set.  Then the bot will
      // move in the forward direction it is currently facing.
      makevectors (self.angles);
      dir = v_forward;
      dir_angles = vectoangles (dir);

   }


   self.waterlevel = norse_waterlevel (self);
   //bprint("lvl = ");
   //bprint(ftos(self.waterlevel));
   //bprint(", vel = ");
   //bprint(vtos(self.velocity));
   //bprint("\n");

   if (self.flags & FL_ONGROUND)
      self.flags = self.flags - FL_ONGROUND;

   if (self.goalentity == self.enemy)
      self.velocity_z = actual_origin_z + 16 - self.origin_z;
   else
      self.velocity_z = actual_origin_z + 56 - self.origin_z;

   local float test;
   local vector a;

   if (self.velocity_z > 0)
   {  if ((self.goalentity == self.enemy) ||
          (self.goalentity.classname == "waypoint")
         )
      {
         if (self.goalentity.waterlevel > 0)
            { self.velocity_z = self.velocity_z * 4.0;
            }
         else
         {
            if (self.waterlevel == 2)
            {
               if (norse_CheckWaterJump())
               {
                  test = TRUE;
                  return;
               }
               else
               {  //bprint(" - jump failed\n");

                  a = self.origin;
                  a_z = a_z + 12;

                  test = pointcontents (a);
                  if (test == CONTENT_EMPTY)
                  {
                     self.velocity_z = 0;
                  }
                  else
                  {
                     self.velocity_z = 128;
                     //self.velocity_z * 4.0;
                  }

               }
            }
            else
            {
               a = self.origin;
               a_z = a_z + 12;

               test = pointcontents (a);
               if (test == CONTENT_EMPTY)
               {
                  self.velocity_z = 0;
               }
               else
               {
                  self.velocity_z = 128;//self.velocity_z * 4.0;
               }

            }
         }

      }
      else
      {
         if (self.waterlevel == 2)
         {
                  a = self.origin;
                  a_z = a_z + 12;

                  test = pointcontents (a);
                  if (test == CONTENT_EMPTY)
                  {
                     self.velocity_z = 0;
                  }
                  else
                  {
                     self.velocity_z = 128;//self.velocity_z * 4.0;
                  }

         }
         else
         {
            self.velocity_z = self.velocity_z * 2.0;
         }
      }
   }

   self.waterlevel = norse_waterlevel (self);

   if (time > (self.air_finished - 2) && self.waterlevel > 2)
   {
      // checks to see if bot needs to start going up for air
      traceline (self.origin, self.origin + '0 0 64', TRUE, self);
      if (trace_inopen)
      {
         // bot only goes up if nothing is blocking it from above
        self.velocity_z = 270 + random() * 40;
      }
      else
      {
         traceline (self.origin, self.origin + '0 0 128', TRUE, self);
         if (trace_inopen)
         {
            // bot only goes up if nothing is blocking it from above
            self.velocity_z = 270 + random() * 40;
         }
         else
         {
            traceline (self.origin, self.origin + '0 0 192', TRUE, self);
            if (trace_inopen)
            {
               // bot only goes up if nothing is blocking it from above
               self.velocity_z = 270 + random() * 40;
            }
            else
            {
               traceline (self.origin, self.origin + '0 0 256', TRUE, self);
               if (trace_inopen)
               {
                  // bot only goes up if nothing is blocking it from above
                  self.velocity_z = 270 + random() * 40;
               }
               else
               {
                  traceline (self.origin, self.origin + '0 0 320', TRUE, self);
                  if (trace_inopen)
                  {
                     // bot only goes up if nothing is blocking it from above
                     self.velocity_z = 270 + random() * 40;
                  }
                  else
                  {
                     traceline (self.origin, self.origin + '0 0 384', TRUE, self);
                     if (trace_inopen)
                     {
                        // bot only goes up if nothing is blocking it from above
                        self.velocity_z = 270 + random() * 40;
                     }
                     else
                     {
                        traceline (self.origin, self.origin + '0 0 448', TRUE, self);
                        if (trace_inopen)
                        {
                           // bot only goes up if nothing is blocking it from above
                           self.velocity_z = 270 + random() * 40;
                        }
                        else
                        {
                           traceline (self.origin, self.origin + '0 0 512', TRUE, self);
                           if (trace_inopen)
                           {
                              // bot only goes up if nothing is blocking it from above
                              self.velocity_z = 270 + random() * 40;
                           }
                           else
                           {
                              traceline (self.origin, self.origin + '0 0 576', TRUE, self);
                              if (trace_inopen)
                              {
                                 // bot only goes up if nothing is blocking it from above
                                 self.velocity_z = 270 + random() * 40;
                              }
                              else
                              {
                                 traceline (self.origin, self.origin + '0 0 640', TRUE, self);
                                 if (trace_inopen)
                                 {
                                    // bot only goes up if nothing is blocking it from above
                                    self.velocity_z = 270 + random() * 40;
                                 }
                                 else
                                 {
                                    traceline (self.origin, self.origin + '0 0 704', TRUE, self);
                                    if (trace_inopen)
                                    {
                                       // bot only goes up if nothing is blocking it from above
                                       self.velocity_z = 270 + random() * 40;
                                    }
                                    else
                                    {
                                       traceline (self.origin, self.origin + '0 0 768', TRUE, self);
                                       if (trace_inopen)
                                       {
                                          // bot only goes up if nothing is blocking it from above
                                          self.velocity_z = 270 + random() * 40;
                                       }
                                       else
                                       {
                                          traceline (self.origin, self.origin + '0 0 832', TRUE, self);
                                          if (trace_inopen)
                                          {
                                             // bot only goes up if nothing is blocking it from above
                                             self.velocity_z = 270 + random() * 40;
                                          }
                                          else
                                          {
                                             traceline (self.origin, self.origin + '0 0 896', TRUE, self);
                                             if (trace_inopen)
                                             {
                                                // bot only goes up if nothing is blocking it from above
                                                self.velocity_z = 270 + random() * 40;
                                             }
                                             else
                                             {
                                                traceline (self.origin, self.origin + '0 0 960', TRUE, self);
                                                if (trace_inopen)
                                                {
                                                   // bot only goes up if nothing is blocking it from above
                                                   self.velocity_z = 270 + random() * 40;
                                                }
                                                else
                                                {
                                                   traceline (self.origin, self.origin + '0 0 1024', TRUE, self);
                                                   if (trace_inopen)
                                                   {
                                                      // bot only goes up if nothing is blocking it from above
                                                      self.velocity_z = 270 + random() * 40;
                                                   }
                                                   else
                                                   {
                                                      traceline (self.origin, self.origin + '0 0 1152', TRUE, self);
                                                      if (trace_inopen)
                                                      {
                                                         // bot only goes up if nothing is blocking it from above
                                                         self.velocity_z = 270 + random() * 40;
                                                      }
                                                      else
                                                      {
                                                         traceline (self.origin, self.origin + '0 0 1280', TRUE, self);
                                                         if (trace_inopen)
                                                         {
                                                            // bot only goes up if nothing is blocking it from above
                                                            self.velocity_z = 270 + random() * 40;
                                                         }
                                                         else
                                                         {
                                                            traceline (self.origin, self.origin + '0 0 1408', TRUE, self);
                                                            if (trace_inopen)
                                                            {
                                                               // bot only goes up if nothing is blocking it from above
                                                               self.velocity_z = 270 + random() * 40;
                                                            }
                                                            else
                                                            {
                                                               traceline (self.origin, self.origin + '0 0 1536', TRUE, self);
                                                               if (trace_inopen)
                                                               {
                                                                  // bot only goes up if nothing is blocking it from above
                                                                  self.velocity_z = 270 + random() * 40;
                                                               }
                                                               else
                                                               {
                                                                  traceline (self.origin, self.origin + '0 0 1664', TRUE, self);
                                                                  if (trace_inopen)
                                                                  {
                                                                     // bot only goes up if nothing is blocking it from above
                                                                     // at this depth and with only 2 seconds, the
                                                                     // the bot should be suffering damage
                                                                     self.velocity_z = 270 + random() * 40;
                                                                  }
                                                                  else
                                                                  {
                                                                     traceline (self.origin, self.origin + '0 0 1792', TRUE, self);
                                                                     if (trace_inopen)
                                                                     {
                                                                        // bot only goes up if nothing is blocking it from above
                                                                        // at this depth and with only 2 seconds, the
                                                                        // the bot should be suffering damage
                                                                        self.velocity_z = 270 + random() * 40;
                                                                     }
                                                                     else
                                                                     {
                                                                        traceline (self.origin, self.origin + '0 0 1920', TRUE, self);
                                                                        if (trace_inopen)
                                                                        {
                                                                           // bot only goes up if nothing is blocking it from above
                                                                           // at this depth and with only 2 seconds, the
                                                                           // the bot should be suffering damage
                                                                           self.velocity_z = 270 + random() * 40;
                                                                        }
                                                                        else
                                                                        {
                                                                           traceline (self.origin, self.origin + '0 0 2048', TRUE, self);
                                                                           if (trace_inopen)
                                                                           {
                                                                              // bot only goes up if nothing is blocking it from above
                                                                              // at this depth and with only 2 seconds, the
                                                                              // the bot should be suffering damage
                                                                              self.velocity_z = 270 + random() * 40;
                                                                           }
                                                                           else
                                                                           {
                                                                              traceline (self.origin, self.origin + '0 0 2304', TRUE, self);
                                                                              if (trace_inopen)
                                                                              {
                                                                                 // bot only goes up if nothing is blocking it from above
                                                                                 // at this depth and with only 2 seconds, the
                                                                                 // the bot should be suffering damage

                                                                                 // need to check for these extreme depths to make sure
                                                                                 // bot does not give up so easily
                                                                                 self.velocity_z = 270 + random() * 40;
                                                                              }
                                                                              else
                                                                              {
                                                                                 traceline (self.origin, self.origin + '0 0 2560', TRUE, self);
                                                                                 if (trace_inopen)
                                                                                 {
                                                                                    // bot only goes up if nothing is blocking it from above
                                                                                    // at this depth and with only 2 seconds, the
                                                                                    // the bot should be suffering damage

                                                                                    // need to check for these extreme depths to make sure
                                                                                    // bot does not give up so easily
                                                                                    self.velocity_z = 270 + random() * 40;
                                                                                 }
                                                                                 else
                                                                                 {
                                                                                    traceline (self.origin, self.origin + '0 0 2816', TRUE, self);
                                                                                    if (trace_inopen)
                                                                                    {
                                                                                       // bot only goes up if nothing is blocking it from above
                                                                                       // at this depth and with only 2 seconds, the
                                                                                       // the bot should be suffering damage

                                                                                       // need to check for these extreme depths to make sure
                                                                                       // bot does not give up so easily

                                                                                       // at this depth, bot may not make if it doesn't have
                                                                                       // enough health and armor.  But bot will try anyway.
                                                                                       self.velocity_z = 270 + random() * 40;
                                                                                    }

                                                                                 }

                                                                              }

                                                                           }

                                                                        }

                                                                     }

                                                                  }


                                                               }

                                                            }

                                                         }

                                                      }

                                                   }
                                                }
                                             }

                                          }

                                       }

                                    }
                                 }
                              }

                           }
                        }

                     }


                  }
               }


            }


         }


      }
   }


   // now need to check to see if there is a barrier at bot's orgin
   // in the way of bot.  if so, try to manuever around it.

   local vector left, right, left_end, right_end;
   local float left_block, right_block;

   left_block = right_block = FALSE;

   left = self.origin - v_right * 15;
   left_end = left + v_forward * 24;

   right = self.origin + v_right * 15;
   right_end = right + v_forward * 24;

   traceline (left, left_end, TRUE, self);
   if (trace_fraction != 1.0)
      left_block = TRUE;
   traceline (right, right_end, TRUE, self);
   if (trace_fraction != 1.0)
      right_block = TRUE;

   if (left_block && !right_block)
   {
      dir = dir + v_right * 32;
   }
   else if (right_block && !left_block)
   {
      dir = dir + v_right * (-32);
   }
   else if (left_block && right_block)
   {
      left_block = right_block = FALSE;
      left = self.origin - v_right * 31;
      left_end = left + v_forward * 24;

      right = self.origin + v_right * 31;
      right_end = right + v_forward * 24;

      traceline (left, left_end, TRUE, self);
      if (trace_fraction != 1.0)
         left_block = TRUE;
      traceline (right, right_end, TRUE, self);
      if (trace_fraction != 1.0)
         right_block = TRUE;

      if (left_block && !right_block)
      {
         dir = dir + v_right * 32;

      }
      else if (right_block && !left_block)
      {
         dir = dir + v_right * (-32);

      }
      else if (left_block && right_block)
      {

         left_block = right_block = FALSE;
         left = self.origin - v_right * 47;
         left_end = left + v_forward * 24;

         right = self.origin + v_right * 47;
         right_end = right + v_forward * 24;

         traceline (left, left_end, TRUE, self);
         if (trace_fraction != 1.0)
            left_block = TRUE;
         traceline (right, right_end, TRUE, self);
         if (trace_fraction != 1.0)
            right_block = TRUE;

         if (left_block && !right_block)
         {
            dir = dir + v_right * 32;

         }
         else if (right_block && !left_block)
         {
            dir = dir + v_right * (-32);

         }
         else if (left_block && right_block)
         {
            left_block = right_block = FALSE;
            left = self.origin - v_right * 63;
            left_end = left + v_forward * 24;

            right = self.origin + v_right * 63;
            right_end = right + v_forward * 24;

            traceline (left, left_end, TRUE, self);
            if (trace_fraction != 1.0)
               left_block = TRUE;
            traceline (right, right_end, TRUE, self);
            if (trace_fraction != 1.0)
               right_block = TRUE;

            if (left_block && !right_block)
            {
               dir = dir + v_right * 32;

            }
            else if (right_block && !left_block)
            {
               dir = dir + v_right * (-32);

            }
            else if (left_block && right_block)
            {

               dir = dir + v_forward * (-32);
            }
         }

      }

   }


   // now check to see if bot is not too close to the walls
   local vector start, end;
   start = self.origin;
   end = self.origin + v_right * 20;
   traceline (start, end, TRUE, self);
   if (trace_fraction != 1.0)
   {
      // wall too close on bot's right side so move a little to left
      dir = dir + v_right * (-32);
   }

   start = self.origin;
   end = self.origin + v_right * (-20);
   traceline (start, end, TRUE, self);
   if (trace_fraction != 1.0)
   {
      // wall too close on bot's left side so move a little to right
      dir = dir + v_right * (32);
   }


   self.velocity_x = dir_x;
   self.velocity_y = dir_y;

   local vector h1, h2;
   h1 = self.origin; h1_z = 0;
   h2 = actual_origin; h2_z = 0;

   if (self.goalentity == self.enemy && self.goalentity != self.owner &&
   self.goalentity != self.maker)
   if (fabs(vlen(h2 - h1)) < 64)
   {
      self.velocity_x = 0;
      self.velocity_y = 0;
   }

   // if self.goalentity is self.owner or self.maker and
   // self.goalentity is too close to bot, bot will back up
   if (self.goalentity == self.owner ||
       self.goalentity == self.maker)
   {
      if (dist < 42)
      {
         //bprint ("backing away while swimming\n");
         self.velocity_x = self.velocity_x * -1;
         self.velocity_y = self.velocity_y * -1;

      }
      else if (dist < 72)
      {
         // close enough but not too close
         //bprint ("close enough\n");
         self.velocity_x = 0;
         self.velocity_y = 0;
      }

   }

   // if the enemy is the goal and the enemy is far above the bot,
   // then the bot will not chase the enemy.  It will stay at a
   // certain distance away.
   local float horiz_dist;
   local vector b;
   a = actual_origin; a_z = 0;
   b = self.origin; b_z = 0;
   horiz_dist = fabs(vlen (a - b));

   if (self.goalentity == self.enemy)
   {
      if ( (actual_origin_z - self.origin_z) > 160)
      {
         if (horiz_dist < 224)
         {
            // too close back away now
            self.velocity_x = self.velocity_x * -1;
            self.velocity_y = self.velocity_y * -1;

         }

      }

   }

   norm_vel = normalize (self.velocity) * 72;
   norm_vel_z = 0;


   self.velocity = self.velocity + norm_vel;

};


float() norse_CheckWaterJump =
{

// This is a major hack to keep the bot from jumping out of water
// when a target is in sight BUT it is too far up to get to.


   if ( (self.enemy.origin_z > (self.origin_z + 96)) && self.enemy != world)
   {
      return FALSE;
   }

   //bprint("check jump");
   local vector start, end;
   local float waste;
   local float dist;
   local float checka1, checka2, checka3;
   local float checkb1, checkb2, checkb3;
   local float incline1, incline2, incline3;

// check for a jump-out-of-water
// self.angles is used.  This means that bot can only jump out of water
// if it is facing the right direction.  Thus, it can't jump out of water
// backwards.
	makevectors (self.angles);
	v_forward_z = 0;
	normalize(v_forward);

   // incline check
   start = self.origin;
   start_z = start_z - 22;
   traceline (start, end, TRUE, self);
   checka1 = trace_fraction * 80;
   if (trace_fraction < 1)
   {
      waste = TRUE;
      start = self.origin;
      start_z = start_z - 19;
      v_forward_z = 0;
      normalize(v_forward);
      end = start + v_forward*80;
      traceline (start, end, TRUE, self);
      checkb1 = trace_fraction * 80;
      if (checka1 < checkb1)
      {
         incline1 = TRUE;
      }

   }

   start = self.origin;
   start_z = start_z - 17;
	traceline (start, end, TRUE, self);
   checka1 = trace_fraction * 80;
   if (trace_fraction < 1)
   {
      waste = TRUE;
      start = self.origin;
      start_z = start_z - 14;
      v_forward_z = 0;
      normalize(v_forward);
      end = start + v_forward*80;
      traceline (start, end, TRUE, self);
      checkb1 = trace_fraction * 80;
      if (checka1 < checkb1)
      {
         incline2 = TRUE;
      }

   }

   start = self.origin;
   start_z = start_z - 12;
	traceline (start, end, TRUE, self);
   checka1 = trace_fraction * 80;
   if (trace_fraction < 1)
   {
      waste = TRUE;
      start = self.origin;
      start_z = start_z - 7;
      v_forward_z = 0;
      normalize(v_forward);
      end = start + v_forward*80;
      traceline (start, end, TRUE, self);
      checkb1 = trace_fraction * 80;
      if (checka1 < checkb1)
      {
         incline3 = TRUE;
      }

   }

// Navy SEALs sQuad bot modification
// was:    if (incline1 && incline2 && incline3)

// end - Navy SEALs sQuad bot modification
   if (incline1 && (incline2 || incline3))
   {  self.origin_z = self.origin_z + 8;

      self.velocity_x = v_forward_x * 72;
      self.velocity_y = v_forward_y * 72;
      return TRUE;

   }

   start = self.origin;
   start_z = start_z + 8;
   end = start + v_forward*80;
   traceline (start, end, TRUE, self);
   if (trace_fraction < 1)
   {
      waste = TRUE;
   }

   start = self.origin;
   start_z = start_z + 4;
   end = start + v_forward*80;
   traceline (start, end, TRUE, self);
   if (trace_fraction < 1)
   {
      waste = TRUE;
   }

   start = self.origin;
   start_z = start_z + 12;
   end = start + v_forward*80;
   traceline (start, end, TRUE, self);
   if (trace_fraction < 1)
   {
      waste = TRUE;
   }

   start = self.origin;
   start_z = start_z + 16;
   end = start + v_forward*80;
   traceline (start, end, TRUE, self);
   if (trace_fraction < 1)
   {
      waste = TRUE;
   }

   start = self.origin;
   start_z = start_z + 20;
   end = start + v_forward*80;
   traceline (start, end, TRUE, self);
   if (trace_fraction < 1)
   {
      waste = TRUE;
   }


   start = self.origin;
   start_z = start_z - 4;
   end = start + v_forward*80;
   traceline (start, end, TRUE, self);
   if (trace_fraction < 1)
   {
      waste = TRUE;
   }

   start = self.origin;
   start_z = start_z - 8;
   end = start + v_forward*80;
   traceline (start, end, TRUE, self);
   if (trace_fraction < 1)
   {
      waste = TRUE;
   }

   start = self.origin;
   end = start + v_forward*80;
   traceline (start, end, TRUE, self);
   if (trace_fraction < 1)
      waste = TRUE;

   if (waste)  // homonyms
	{	// solid at waist

		start_z = start_z + self.maxs_z - 8;
      end = start + v_forward*128;
		traceline (start, end, TRUE, self);

		if (trace_fraction == 1)
		{	// open at eye level

            start = self.origin;
            start_z = start_z + 8;
            end = start + v_forward * 80;
            traceline (start, end, TRUE, self);
            dist = trace_fraction;

            start = self.origin;
            start_z = start_z + 4;
            end = start + v_forward*80;
            traceline (start, end, TRUE, self);
            if (trace_fraction < 1)
            if (trace_fraction < dist)
               dist = trace_fraction;

            start = self.origin;
            start_z = start_z + 12;
            end = start + v_forward*80;
            traceline (start, end, TRUE, self);
            if (trace_fraction < 1)
            if (trace_fraction < dist)
               dist = trace_fraction;

            start = self.origin;
            start_z = start_z + 16;
            end = start + v_forward*80;
            traceline (start, end, TRUE, self);
            if (trace_fraction < 1)
            if (trace_fraction < dist)
               dist = trace_fraction;

            start = self.origin;
            start_z = start_z + 20;
            end = start + v_forward*80;
            traceline (start, end, TRUE, self);
            if (trace_fraction < 1)
            if (trace_fraction < dist)
               dist = trace_fraction;

            start = self.origin;
            start_z = start_z - 4;
            end = start + v_forward*80;
            traceline (start, end, TRUE, self);
            if (trace_fraction < 1)
            if (trace_fraction < dist)
               dist = trace_fraction;

            start = self.origin;
            start_z = start_z - 8;
            end = start + v_forward*80;
            traceline (start, end, TRUE, self);
            if (trace_fraction < 1)
            if (trace_fraction < dist)
               dist = trace_fraction;

            start = self.origin;
            end = start + v_forward*80;
            traceline (start, end, TRUE, self);
            if (trace_fraction < 1)
            if (trace_fraction < dist)
               dist = trace_fraction;

            if (dist <0.60)
            {  //bprint("bot too close to ledge\n");
               // bot is too close to ledge to jump out of water
               // so move backwards away from ledge.
               self.velocity_x = v_forward_x * -176;
               self.velocity_y = v_forward_y * -176;

               return TRUE;

            }
            if (dist < 0.78)
            {
               self.velocity_x = v_forward_x * 144;
               self.velocity_y = v_forward_y * 144;
               self.velocity_z = 336;
               self.flags = self.flags | FL_WATERJUMP;
               self.flags = self.flags - (self.flags & FL_JUMPRELEASED);
               self.teleport_time = time + 2;   // safety net
               return TRUE;
            }
            else return FALSE;

		}
	}
};


/*
   The following is unfinished code planned for v0.32 of norse_movetogoal.
   It is currently tested on REAL players by having these functions attached
   to impulse commands.  Thus, I know it works for real players.  It has
   not been implemented on bots, yet.  The question with bots concerns
   whether or not it has enough time to notice the traps and decide which
   direction to go before it is too late.  This is the *SAME* problem I
   had with checking for gaps.  That is why bots will sometimes walk right
   off the ledge and into lava.

   Yes, you read right.  It is code for avoiding TRAPS!

*/
/*
void() trap_touch =
{

   // bprint ("Touched trap\n");

   // this function does nothing.  By the time the bot touches the
   // trap, it is too late.
   return;


};

void(vector set_trap, entity me) spawn_trap =
{

   local vector set_trap_now;
   set_trap_now = set_trap;
   local entity   trap;
   local entity   article;
   local vector   trap_origin;
   local float dist, trap_dist;
   local vector quake_bug_workaround;

   article = findradius (me.origin, 128);
   trap_dist = 9999;

   while (article)
   {
      if (article.classname == "bubble_trap")
      {

            trap_origin = real_origin (article);

            dist = vlen(trap_origin - me.origin);

            if (dist < trap_dist)
            {
               trap = article;
               trap_dist = dist;
            }
      }

      article = article.chain;

   }

   if (trap_origin == set_trap_now)
   {
      return;
   }      

   local entity   bubble;
	bubble = spawn();
   bubble.classname = "bubble_trap";

   bubble.touch = trap_touch;
   //setmodel (bubble, "progs/s_bubble.spr");
   setorigin (bubble, set_trap_now);
   bubble.movetype = MOVETYPE_NONE;

   bubble.solid = SOLID_TRIGGER;

	setsize (bubble, '-8 -8 -8', '8 8 8');

};




void (entity me) find_trap =
{
   local entity   trap;
   local entity   article;
   local vector   trap_origin;
   local float dist, trap_dist;
   local vector quake_bug_workaround;

   trap_dist = 9999;
   article = findradius (me.origin, 128);

   while (article)
   {
      if (article.classname == "trap_spikeshooter" ||
         article.classname == "trap_shooter" ||
         article.classname == "func_wall" ||
         article.classname == "trigger_multiple")
      {

            trap_origin = real_origin (article);

            dist = vlen(trap_origin - me.origin);

            if (dist < trap_dist)
            {
               trap = article;
               trap_dist = dist;
            }
      }

      article = article.chain;

   }

   if (trap)
   {
      spawn_trap (trap_origin, me);
   }
};

float (entity me) avoid_trap =
{

   local entity   trap;
   local entity   article;
   local vector   trap_origin;
   local float dist, trap_dist;
   local vector quake_bug_workaround;


   // this uses a findradius function.  Traceline function will *NOT*
   // find any traps so findradius is the only thing you can do.
   // Unfortunately, it is only useful to finding traps that are within
   // a specified distance.  The bigger the distance, the more CPU
   // it will need.  An alternative is to execute a function ONCE that
   // will spawn all the necessary trap waypoints for the entire map.
   // You will notice that the bot will also use the findradius function
   // to look for trap waypoints.  In short, detecting traps eats up
   // CPU.

   article = findradius (me.origin, 128);
   trap_dist = 9999;

   while (article)
   {
      if (article.classname == "bubble_trap")
      {

            trap_origin = real_origin (article);

            dist = vlen(trap_origin - me.origin);

            if (dist < trap_dist)
            {
               trap = article;
               trap_dist = dist;
            }
      }

      article = article.chain;

   }

   if (!trap)
   {
      return 0;
   }

   local vector a, b, dir;
   local float dist;
   local vector   dir_angles;
   a = trap_origin;
   b = me.origin; b_z = a_z;


   dir = (a - b);    // from bot to bubble.  Recall final - initial dest
   dir_angles = vectoangles (dir);
   dist = vlen(dir);
   makevectors (dir_angles);
   v_forward_z = 0;
   local vector v1, v2;
   v1 = v_forward * 128;

   // am I heading toward the trap?
   makevectors (self.angles);
   v_forward_z = 0;
   v2 = v_forward * 128;

   local float dir_dist;
   dir_dist = vlen (v1 - v2);

   if (dir_dist > 128)
   {
      dir_dist = 256 - dir_dist;
   }
*/
/*
   v1 is the vector from bot to waypoint
   v2 is the vector the bot is facing (which is assumed to be the direction
      it is moving to).

   if these two vectors are very close together, then this means that the
   bot is heading towards that waypoint.  Meaning it is heading towards
   the trap.
*/
/*
   local float t_dist, t_vel;
   t_vel = vlen (me.velocity);
   if (t_vel < 100)
      t_vel = 100;

   t_dist = 48 * (320/t_vel);

   if (dist > t_dist || dir_dist > 80)
   {
      //bprint ("Not going to hit trap\n"); // dir_dist > 40
      //bprint (" or too far from trap\n"); // dist > 96, these are for
                                          // traps on ceilings (eg. E1M5)
      //bprint (ftos(dist));
      //bprint (ftos(dir_dist));
      //bprint ("\n");
      return 0;
   }


   // deciding which direction to go
   // the fraction that is the greatest is the direction bot should go to

   local vector start, end;
   local float fraction;
   local float r, l;
   start = me.origin;
   end = start + v_forward * 48 - v_right * 30;
   traceline (start, end, TRUE, self);
   l = trace_fraction * 100;


   start = me.origin;
   end = start + v_forward * 48 + v_right * 30;
   traceline (start, end, TRUE, self);
   r = trace_fraction * 100;

   if (l > r)
   {
      return 1;
   }
   else if (r > l)
   {
      return 2;
   }
   else
   {
      //if (random() < 0.5)
      //   return 2;
      //else
         return 2;
   }


};

*/

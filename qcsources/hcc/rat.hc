void  ()rat_wait;
void  ()rat_noise;

void  ()rat_die_wait =  {
   if ( (self.health < -80.00000) ) {

      chunk_death ( );
      return ;

   }
   if ( !self.velocity ) {

      if ( (random() < 0.50000) ) {

         self.angles_x = 0.00000;
      } else {

         self.angles_x = 180.00000;

      }
      self.avelocity = '0.00000 0.00000 0.00000';
      MakeSolidCorpse ( );
      return ;
   } else {

      self.think = rat_die_wait;
      AdvanceThinkTime(self,0.50000);

   }
};


void  ()rat_death =  {
local vector bounce_vel = '0.00000 0.00000 0.00000';
   if ( (self.health < -80.00000) ) {

      chunk_death ( );
      return ;

   }
   bounce_vel = normalize ( (self.origin - damage_attacker.origin));
   bounce_vel_x *= random((self.health * -30.00000));
   self.velocity = bounce_vel;
   self.velocity_z = random(150.00000,450.00000);
   self.flags ^= FL_ONGROUND;
   self.movetype = MOVETYPE_BOUNCE;
   self.avelocity_x = (random((self.health * 10.00000)) - self.health);
   self.avelocity_y = (random((self.health * 10.00000)) - self.health);
   self.avelocity_z = (random((self.health * 10.00000)) - self.health);
   self.think = rat_die_wait;
   AdvanceThinkTime(self,0.00000);
};


void  ()ratrun =  {
local entity player;
local float player_see_me = 0.00000;
local vector ahead_org = '0.00000 0.00000 0.00000';
local float drop_content = 0.00000;
   self.frame += 1.00000;
   AdvanceThinkTime(self,HX_FRAME_TIME);
   self.think = ratrun;
   AdvanceFrame ( 0.00000, 17.00000);
   self.ideal_yaw = vectoyaw ( (self.goalentity.origin - self.origin));
   ChangeYaw ( );
   if ( (pointcontents ( (self.origin + '0.00000 0.00000 7.00000')) != CONTENT_EMPTY) ) {

      if ( (pointcontents ( self.origin) == CONTENT_LAVA) ) {

         chunk_death ( );
      } else {

         self.velocity_z = 1.00000;
         self.flags |= FL_SWIM;

      }
   } else {

      self.velocity_z = -1.00000;

   }
   if ( ((((random() < 0.10000) || (self.origin == self.oldorigin)) && (self.pain_finished < time)) && !(self.flags & FL_SWIM)) ) {

      makevectors ( self.angles);
      ahead_org = ((self.origin + '0.00000 0.00000 7.00000') + (v_forward * 10.00000));
      traceline ( ahead_org, (ahead_org - '0.00000 0.00000 1000.00000'), FALSE, self);
      drop_content = pointcontents ( trace_endpos);
      if ( ((drop_content != CONTENT_EMPTY) && (drop_content != CONTENT_SOLID)) ) {

         self.pain_finished = (time + 3.00000);
         AdvanceThinkTime(self,0.50000);
         self.velocity = ((v_forward * 200.00000) + '0.00000 0.00000 150.00000');
         self.flags ^= FL_ONGROUND;

      }

   }
   if ( ((random() < 0.10000) && (random() < 0.10000)) ) {

      rat_noise ( );

   }
   if ( (self.goalentity.classname == "player") ) {

      if ( (vlen ( (self.goalentity.origin - self.origin)) < 36.00000) ) {

         self.think = rat_wait;

      }
   } else {

      player = find ( world, classname, "player");
      while ( player ) {

         if ( ((((((random() < 0.10000) && (random() < 0.10000)) && (random() < 0.10000)) && (random() < 0.10000)) && (random() < 0.10000)) && !self.target) ) {

            self.goalentity = player;
            player_see_me = TRUE;
         } else {

            if ( visible2ent ( self, player) ) {

               player_see_me = TRUE;

            }

         }
         player = find ( player, classname, "player");

      }
      if ( (!player_see_me && (time > self.lifetime)) ) {

         if ( (self.goalentity.classname == "tempgoal") ) {

            remove ( self.goalentity);

         }
         remove ( self);

      }
      if ( (self.frags >= 10.00000) ) {

         self.frags = 0.00000;
         makevectors ( self.angles);
         newmis = spawn ( );
         setorigin ( newmis, ((v_forward * -1000.00000) + (v_right * ((random() * 100.00000) - 50.00000))));
         remove ( self.goalentity);
         self.goalentity = newmis;

      }

   }
   if ( !walkmove ( self.angles_y, random(3.00000,7.00000), FALSE) ) {

      remove ( self);

   }
};


void  ()rat_wait =  {
   if ( (vlen ( (self.goalentity.origin - self.origin)) > 56.00000) ) {

      self.think = ratrun;
   } else {

      self.think = rat_wait;

   }
   AdvanceThinkTime(self,0.05000);
};


void  ()rat_noise =  {
   sound ( self, CHAN_VOICE, "misc/squeak.wav", 1.00000, ATTN_NORM);
};


void  ()rat_touch =  {
   return ;
};


void  ()rat_make_goal =  {
local vector goaldir = '0.00000 0.00000 0.00000';
   goaldir = self.angles;
   goaldir_y = self.ideal_yaw;
   makevectors ( goaldir);
   newmis = spawn ( );
   newmis.effects = EF_NODRAW;
   setmodel ( newmis, "models/null.spr");
   setorigin ( newmis, (self.origin + (v_forward * 1000.00000)));
   self.goalentity = newmis;
   newmis.classname = "tempgoal";
   AdvanceThinkTime(newmis,30.00000);
   newmis.think = SUB_Remove;
};


void  ()rat_stupor =  {
   self.angles_y += random(-2.00000,2.00000);
   self.frame = random(17.00000);
   self.think = rat_stupor;
   AdvanceThinkTime(self,random(0.30000,1.30000));
};


void  ()rat_go =  {
   self.th_stand = ratrun;
   self.th_walk = ratrun;
   self.think = ratrun;
   AdvanceThinkTime(self,0.00000);
};


void  ()monster_rat =  {
   if ( !(self.flags2 & FL_SUMMONED) ) {

      precache_model ( "models/rat.mdl");
      precache_sound ( "misc/squeak.wav");
      self.th_stand = rat_stupor;
      self.th_walk = rat_stupor;
      self.use = rat_go;
   } else {

      self.th_stand = ratrun;
      self.th_walk = ratrun;

   }
   setmodel ( self, "models/rat.mdl");
   self.movetype = MOVETYPE_STEP;
   self.solid = SOLID_SLIDEBOX;
   if ( (pointcontents ( self.origin) != CONTENT_EMPTY) ) {

      self.flags |= FL_SWIM;
      self.angles_x = 10.00000;

   }
   self.touch = rat_touch;
   self.classname = "monster_rat";
   setsize ( self, '-3.00000 -3.00000 0.00000', '3.00000 3.00000 7.00000');
   self.health = 3.00000;
   self.thingtype = THINGTYPE_FLESH;
   self.th_run = ratrun;
   self.th_melee = ratrun;
   self.th_missile = ratrun;
   self.th_pain = rat_noise;
   self.th_die = rat_death;
   self.flags |= FL_MONSTER;
   self.yaw_speed = 10.00000;
   self.lifetime = (time + 10.00000);
   if ( !self.target ) {

      self.ideal_yaw = random(360.00000);
      rat_make_goal ( );

   }
   walkmonster_start ( );
};


void  ()monster_ratnest =  {
   precache_model ( "models/rat.mdl");
   precache_sound ( "misc/squeak.wav");
   self.use = barrel_die;
};


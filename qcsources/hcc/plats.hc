void  ()newplat_center_touch;
void  ()newplat_go_up;
void  ()newplat_go_down;
void  ()plat_center_touch;
void  ()plat_outside_touch;
void  ()plat_trigger_use;
void  ()plat_go_up;
void  ()plat_go_down;
void  ()plat_crush;
float PLAT_LOW_TRIGGER   =  1.00000;
void  ()crusher_hit_bottom;
void  ()crusher_hit_top;
void  ()crusher_trigger_use;
void  ()crusher_go_up;
void  ()crusher_go_down;
float CRUSH_MULT   =  1.00000;
float CRUSH_SLIDE   =  2.00000;
float CRUSH_START_OPEN   =  4.00000;
float CRUSH_ENDPOS   =  8.00000;
float START_BOTTOM   =  1.00000;
float START_RTRN   =  2.00000;
float CONTINUE   =  4.00000;
void  ()train_wait;
float TRAIN_GLOW   =  1.00000;
float TRAIN_WAITTRIG   =  2.00000;
float TRAIN_RETURN   =  4.00000;

void  ()plat_spawn_inside_trigger =  {
local entity trigger;
local vector tmin = '0.00000 0.00000 0.00000';
local vector tmax = '0.00000 0.00000 0.00000';
   trigger = spawn ( );
   if ( (self.classname == "newplat") ) {

      trigger.touch = newplat_center_touch;
   } else {

      trigger.touch = plat_center_touch;

   }
   trigger.movetype = MOVETYPE_NONE;
   trigger.solid = SOLID_TRIGGER;
   trigger.enemy = self;
   tmin = (self.mins + '25.00000 25.00000 0.00000');
   tmax = (self.maxs - '25.00000 25.00000 -8.00000');
   tmin_z = (tmax_z - ((self.pos1_z - self.pos2_z) + 8.00000));
   if ( (self.spawnflags & PLAT_LOW_TRIGGER) ) {

      tmax_z = (tmin_z + 8.00000);

   }
   if ( (self.size_x <= 50.00000) ) {

      tmin_x = ((self.mins_x + self.maxs_x) / 2.00000);
      tmax_x = (tmin_x + 1.00000);

   }
   if ( (self.size_y <= 50.00000) ) {

      tmin_y = ((self.mins_y + self.maxs_y) / 2.00000);
      tmax_y = (tmin_y + 1.00000);

   }
   setsize ( trigger, tmin, tmax);
};


void  ()plat_hit_top =  {
   sound ( self, CHAN_VOICE, self.noise1, 1.00000, ATTN_NORM);
   self.state = STATE_TOP;
   self.think = plat_go_down;
   self.nextthink = (self.ltime + 3.00000);
};


void  ()plat_hit_bottom =  {
   sound ( self, CHAN_VOICE, self.noise1, 1.00000, ATTN_NORM);
   self.state = STATE_BOTTOM;
};


void  ()plat_go_down =  {
   sound ( self, CHAN_VOICE, self.noise, 1.00000, ATTN_NORM);
   self.state = STATE_DOWN;
   SUB_CalcMove ( self.pos2, self.speed, plat_hit_bottom);
};


void  ()plat_go_up =  {
   sound ( self, CHAN_VOICE, self.noise, 1.00000, ATTN_NORM);
   self.state = STATE_UP;
   SUB_CalcMove ( self.pos1, self.speed, plat_hit_top);
};


void  ()plat_center_touch =  {
   if ( ((other.classname != "player") && (other.movetype != MOVETYPE_PUSHPULL)) ) {

      return ;

   }
   if ( (other.health <= 0.00000) ) {

      return ;

   }
   self = self.enemy;
   if ( (self.state == STATE_BOTTOM) ) {

      plat_go_up ( );
   } else {

      if ( (self.state == STATE_TOP) ) {

         self.nextthink = (self.ltime + 1.00000);

      }

   }
};


void  ()plat_outside_touch =  {
   if ( ((other.classname != "player") && (other.movetype != MOVETYPE_PUSHPULL)) ) {

      return ;

   }
   if ( (other.health <= 0.00000) ) {

      return ;

   }
   self = self.enemy;
   if ( (self.state == STATE_TOP) ) {

      plat_go_down ( );

   }
};


void  ()plat_trigger_use =  {
   if ( self.think ) {

      return ;

   }
   plat_go_down ( );
};


void  ()plat_crush =  {
   T_Damage ( other, self, self, 1.00000);
   if ( (self.state == STATE_UP) ) {

      plat_go_down ( );
   } else {

      if ( (self.state == STATE_DOWN) ) {

         plat_go_up ( );
      } else {

         objerror ( "plat_crush: bad self.state\n");

      }

   }
};


void  ()plat_use =  {
   self.use = SUB_Null;
   if ( (self.state != STATE_UP) ) {

      objerror ( "plat_use: not in up state");

   }
   plat_go_down ( );
};


void  ()func_plat =  {
   if ( !self.t_length ) {

      self.t_length = 80.00000;

   }
   if ( !self.t_width ) {

      self.t_width = 10.00000;

   }
   if ( (self.soundtype == 0.00000) ) {

      self.soundtype = 2.00000;

   }
   if ( (self.soundtype == 1.00000) ) {

      precache_sound ( "plats/pulyplt1.wav");
      precache_sound ( "plats/pulyplt2.wav");
      self.noise = "plats/pulyplt1.wav";
      self.noise1 = "plats/pulyplt2.wav";

   }
   if ( (self.soundtype == 2.00000) ) {

      precache_sound ( "plats/chainplt1.wav");
      precache_sound ( "plats/chainplt2.wav");
      self.noise = "plats/chainplt1.wav";
      self.noise1 = "plats/chainplt2.wav";

   }
   self.mangle = self.angles;
   self.angles = '0.00000 0.00000 0.00000';
   self.classname = "plat";
   self.solid = SOLID_BSP;
   self.movetype = MOVETYPE_PUSH;
   setorigin ( self, self.origin);
   setmodel ( self, self.model);
   setsize ( self, self.mins, self.maxs);
   self.blocked = plat_crush;
   if ( !self.speed ) {

      self.speed = 150.00000;

   }
   self.pos1 = self.origin;
   self.pos2 = self.origin;
   if ( self.height ) {

      self.pos2_z = (self.origin_z - self.height);
   } else {

      self.pos2_z = ((self.origin_z - self.size_z) + 8.00000);

   }
   self.use = plat_trigger_use;
   plat_spawn_inside_trigger ( );
   if ( self.targetname ) {

      self.state = STATE_UP;
      self.use = plat_use;
   } else {

      setorigin ( self, self.pos2);
      self.state = STATE_BOTTOM;

   }
};

void  ()train_next;
void  ()func_train_find;

void  ()train_blocked =  {
   if ( (time < self.attack_finished) ) {

      return ;

   }
   self.attack_finished = (time + 0.50000);
   T_Damage ( other, self, self, self.dmg);
};


void  ()train_use =  {
   if ( (self.wait == -1.00000) ) {

      self.use = SUB_Null;

   }
   if ( (self.spawnflags & TRAIN_GLOW) ) {

      self.effects = EF_BRIGHTLIGHT;

   }
   if ( (self.decap != 1.00000) ) {

      self.decap = 1.00000;
      if ( (self.think != train_next) ) {

         self.think = func_train_find;
         train_next ( );

      }
   } else {

      if ( (self.spawnflags & TRAIN_RETURN) ) {

         self.decap = 0.00000;
      } else {

         self.decap = 2.00000;

      }

   }
};


void  ()train_wait =  {
   if ( (self.decap != 2.00000) ) {

      self.think = train_next;
      if ( (self.wait == -2.00000) ) {

         if ( self.th_die ) {

            if ( self.pausetime ) {

               self.think = self.th_die;
               self.nextthink = (self.ltime + self.pausetime);
            } else {

               self.th_die ( );
               return ;

            }
         } else {

            if ( self.pausetime ) {

               self.think = chunk_death;
               self.nextthink = (self.ltime + self.pausetime);
            } else {

               chunk_death ( );
               return ;

            }

         }
      } else {

         if ( (self.wait == -1.00000) ) {

            self.nextthink = -1.00000;
         } else {

            if ( self.wait ) {

               self.nextthink = (self.ltime + self.wait);
               sound ( self, CHAN_VOICE, self.noise, 1.00000, ATTN_NORM);
            } else {

               self.nextthink = (self.ltime + 0.10000);

            }

         }

      }

   }
   if ( ((self.decap == 0.00000) || (self.decap == 2.00000)) ) {

      self.effects = 0.00000;

   }
};


void  ()train_rotate =  {
local entity targ;
local vector dir = '0.00000 0.00000 0.00000';
   targ = self.enemy;
   if ( (((targ.mangle_x != 0.00000) || (targ.mangle_y != 0.00000)) || (targ.mangle_z != 0.00000)) ) {

      dir = self.angles;
      dir += targ.mangle;
      SUB_CalcAngleMove ( dir, self.speed, train_wait);
   } else {

      train_wait ( );

   }
};


void  ()train_next =  {
local entity targ;
local vector dir = '0.00000 0.00000 0.00000';
local float targ_speed = 0.00000;
local float targ_aspeed = 0.00000;
   targ = find ( world, targetname, self.target);
   self.target = targ.target;
   if ( (!self.decap && (self.spawnflags & TRAIN_RETURN)) ) {

      if ( (self.netname == targ.targetname) ) {

         self.decap = 2.00000;

      }

   }
   if ( !self.target ) {

      objerror ( "train_next: no next target");

   }
   if ( targ.wait ) {

      self.wait = targ.wait;
   } else {

      self.wait = 0.00000;

   }
   self.enemy = targ;
   sound ( self, CHAN_VOICE, self.noise1, 1.00000, ATTN_NORM);
   if ( (((targ.mangle_x != 0.00000) || (targ.mangle_y != 0.00000)) || (targ.mangle_z != 0.00000)) ) {

      dir = self.angles;
      dir += targ.mangle;
      if ( targ.speed ) {

         targ_speed = targ.speed;
      } else {

         targ_speed = self.speed;

      }
      if ( targ.anglespeed ) {

         targ_aspeed = targ.anglespeed;
      } else {

         targ_aspeed = self.anglespeed;

      }
      if ( (targ.spawnflags & SYNCH) ) {

         SUB_CalcMoveAndAngleInit ( (targ.origin - self.mins), targ_speed, dir, targ_aspeed, train_wait, TRUE);
      } else {

         SUB_CalcMoveAndAngleInit ( (targ.origin - self.mins), targ_speed, dir, targ_aspeed, train_wait, FALSE);

      }
   } else {

      SUB_CalcMove ( (targ.origin - self.mins), self.speed, train_rotate);

   }
   if ( (self.spawnflags & TRAIN_WAITTRIG) ) {

      self.decap = 2.00000;

   }
};


void  ()func_train_find =  {
local entity targ;
   targ = find ( world, targetname, self.target);
   self.target = targ.target;
   setorigin ( self, (targ.origin - self.mins));
   if ( !self.targetname ) {

      self.decap = 1.00000;
      self.nextthink = (self.ltime + 0.10000);
      self.think = train_next;

   }
};


void  ()func_train =  {
local entity targ;
   self.decap = 0.00000;
   if ( (self.spawnflags & TRAIN_GLOW) ) {

      self.solid = SOLID_NOT;
      setmodel ( self, "models/s_light.spr");
   } else {

      self.solid = SOLID_BSP;
      setmodel ( self, self.model);

   }
   if ( !self.speed ) {

      self.speed = 100.00000;

   }
   if ( !self.anglespeed ) {

      self.anglespeed = 100.00000;

   }
   if ( !self.target ) {

      objerror ( "func_train without a target");

   }
   if ( !self.dmg ) {

      self.dmg = 2.00000;

   }
   if ( (self.soundtype == 1.00000) ) {

      self.noise = "plats/train2.wav";
      precache_sound ( "plats/train2.wav");
      self.noise1 = "plats/train1.wav";
      precache_sound ( "plats/train1.wav");
   } else {

      self.noise1 = "misc/null.wav";
      self.noise = "misc/null.wav";
      precache_sound ( "misc/null.wav");

   }
   if ( (self.wait == -2.00000) ) {

      if ( !self.thingtype ) {

         self.thingtype = 1.00000;

      }
      if ( !self.th_die ) {

         self.th_die = chunk_death;

      }

   }
   self.cnt = 1.00000;
   self.movetype = MOVETYPE_PUSH;
   self.blocked = train_blocked;
   self.use = train_use;
   self.classname = "train";
   setsize ( self, self.mins, self.maxs);
   setorigin ( self, self.origin);
   targ = find ( world, target, self.target);
   self.netname = targ.target;
   if ( self.abslight ) {

      self.drawflags |= MLS_ABSLIGHT;

   }
   if ( (self.spawnflags & 8.00000) ) {

      self.drawflags |= DRF_TRANSLUCENT;
      self.solid = SOLID_NOT;

   }
   self.nextthink = (self.ltime + 0.10000);
   self.think = func_train_find;
};


void  ()newplat_hit_bottom =  {
   sound ( self, CHAN_VOICE, self.noise1, 1.00000, ATTN_NORM);
   self.state = STATE_BOTTOM;
   self.lifetime = (time + self.wait);
   if ( (((self.spawnflags & START_RTRN) && !(self.spawnflags & START_BOTTOM)) || (self.spawnflags & CONTINUE)) ) {

      self.nextthink = (self.ltime + self.wait);
      self.think = newplat_go_up;

   }
   setorigin ( self.enemy, self.origin);
};


void  ()newplat_hit_top =  {
   sound ( self, CHAN_VOICE, self.noise1, 1.00000, ATTN_NORM);
   self.state = STATE_TOP;
   self.lifetime = (time + self.wait);
   if ( (((self.spawnflags & START_RTRN) && (self.spawnflags & START_BOTTOM)) || (self.spawnflags & CONTINUE)) ) {

      self.nextthink = (self.ltime + self.wait);
      self.think = newplat_go_down;

   }
   setorigin ( self.enemy, self.origin);
};


void  ()newplat_trigger_use =  {
   if ( self.think ) {

      return ;

   }
   if ( ((self.state == STATE_MOVING) || (self.lifetime > time)) ) {

      return ;

   }
   if ( (self.state == STATE_BOTTOM) ) {

      newplat_go_up ( );
   } else {

      newplat_go_down ( );

   }
};


void  ()newplat_calc_down =  {
   self.state = STATE_MOVING;
   SUB_CalcMove ( self.pos2, self.speed, newplat_hit_bottom);
};


void  ()newplat_go_down =  {
   sound ( self, CHAN_VOICE, self.noise, 1.00000, ATTN_NORM);
   newplat_calc_down ( );
};


void  ()newplat_calc_up =  {
   self.state = STATE_MOVING;
   SUB_CalcMove ( self.pos1, self.speed, newplat_hit_top);
};


void  ()newplat_go_up =  {
   sound ( self, CHAN_VOICE, self.noise, 1.00000, ATTN_NORM);
   newplat_calc_up ( );
};


void  ()newplat_crush =  {
   T_Damage ( other, self, self, 1.00000);
   if ( (self.velocity_z < 0.00000) ) {

      newplat_calc_down ( );
   } else {

      if ( (self.velocity_z > 0.00000) ) {

         newplat_calc_up ( );
      } else {

         objerror ( "newplat_crush: bad self.state\n");

      }

   }
};


void  ()newplat_center_touch =  {
   if ( (((other.classname != "player") && (other.movetype != MOVETYPE_PUSHPULL)) || (other.health <= 0.00000)) ) {

      return ;

   }
   self = self.enemy;
   if ( ((self.state == STATE_MOVING) || (self.lifetime > time)) ) {

      return ;

   }
   if ( (self.state == STATE_BOTTOM) ) {

      newplat_go_up ( );
   } else {

      newplat_go_down ( );

   }
};


void  ()newplat_spawn_inside_trigger =  {
local entity trigger;
   trigger = spawn ( );
   trigger.touch = newplat_center_touch;
   trigger.movetype = MOVETYPE_PUSH;
   trigger.solid = SOLID_TRIGGER;
   trigger.enemy = self;
   self.enemy = trigger;
   setsize ( trigger, self.mins, self.maxs);
};


void  ()func_newplat =  {
   if ( !self.t_length ) {

      self.t_length = 80.00000;

   }
   if ( !self.t_width ) {

      self.t_width = 10.00000;

   }
   if ( (self.soundtype == 0.00000) ) {

      self.soundtype = 2.00000;

   }
   if ( (self.soundtype == 1.00000) ) {

      precache_sound ( "plats/pulyplt1.wav");
      precache_sound ( "plats/pulyplt2.wav");
      self.noise = "plats/pulyplt1.wav";
      self.noise1 = "plats/pulyplt2.wav";

   }
   if ( (self.soundtype == 2.00000) ) {

      precache_sound ( "plats/chainplt1.wav");
      precache_sound ( "plats/chainplt2.wav");
      self.noise = "plats/chainplt1.wav";
      self.noise1 = "plats/chainplt2.wav";

   }
   self.mangle = self.angles;
   self.angles = '0.00000 0.00000 0.00000';
   self.classname = "newplat";
   self.solid = SOLID_BSP;
   self.movetype = MOVETYPE_PUSH;
   setorigin ( self, self.origin);
   setmodel ( self, self.model);
   setsize ( self, self.mins, self.maxs);
   if ( !self.speed ) {

      self.speed = 150.00000;

   }
   if ( !self.wait ) {

      self.wait = 3.00000;

   }
   self.pos1 = self.origin;
   self.pos2 = self.origin;
   if ( (self.spawnflags & START_BOTTOM) ) {

      self.state = STATE_BOTTOM;
   } else {

      self.state = STATE_TOP;

   }
   if ( (self.state == STATE_BOTTOM) ) {

      self.pos1_z = (self.origin_z + self.height);
      self.pos2_z = self.origin_z;
   } else {

      self.pos1_z = self.origin_z;
      self.pos2_z = (self.origin_z - self.height);

   }
   self.use = newplat_trigger_use;
   self.blocked = newplat_crush;
   newplat_spawn_inside_trigger ( );
};


void  ()crusher_slide_next =  {
local vector vdestdelta = '0.00000 0.00000 0.00000';
local float len = 0.00000;
local float tspeed = 0.00000;
   tspeed = self.speed;
   if ( !tspeed ) {

      objerror ( "No speed defined!");

   }
   if ( (self.finaldest == self.origin) ) {

      self.velocity = '0.00000 0.00000 0.00000';
      if ( (self.state == STATE_DOWN) ) {

         self.think = crusher_hit_bottom;
      } else {

         if ( (self.state == STATE_UP) ) {

            self.think = crusher_hit_top;

         }

      }
      self.nextthink = (self.ltime + 0.10000);
      return ;

   }
   vdestdelta = (self.finaldest - self.origin);
   len = vlen ( vdestdelta);
   if ( (len < 1.00000) ) {

      if ( (self.state == STATE_DOWN) ) {

         crusher_hit_bottom ( );
      } else {

         if ( (self.state == STATE_UP) ) {

            crusher_hit_top ( );
         } else {

            dprint ( "NO STATE\n");

         }

      }
      return ;

   }
   self.nextthink = (self.ltime + 0.10000);
   self.think = crusher_slide_next;
   self.velocity = (vdestdelta * ((len / (len / 3.00000)) / (self.speed / 100.00000)));
};


void  (vector tdest)crusher_slide =  {
   self.finaldest = tdest;
   crusher_slide_next ( );
};


void  ()crusher_hit_top =  {
   sound ( self, CHAN_VOICE, self.noise1, 1.00000, ATTN_NORM);
   self.state = STATE_TOP;
   if ( (self.spawnflags & CRUSH_MULT) ) {

      return ;

   }
   if ( !self.level ) {

      self.think = crusher_go_down;
      self.nextthink = (self.ltime + 1.00000);
   } else {

      self.nextthink = -1.00000;

   }
};


void  ()crusher_hit_bottom =  {
   sound ( self, CHAN_VOICE, self.noise1, 1.00000, ATTN_NORM);
   self.state = STATE_BOTTOM;
   if ( (self.level && (self.spawnflags & CRUSH_ENDPOS)) ) {

      return ;

   }
   self.think = crusher_go_up;
   self.nextthink = (self.ltime + 1.00000);
};


void  ()crusher_go_down =  {
   sound ( self, CHAN_VOICE, self.noise, 1.00000, ATTN_NORM);
   self.state = STATE_DOWN;
   if ( (self.spawnflags & CRUSH_SLIDE) ) {

      crusher_slide ( self.pos2);
   } else {

      SUB_CalcMove ( self.pos2, self.speed, crusher_hit_bottom);

   }
};


void  ()crusher_go_up =  {
   sound ( self, CHAN_VOICE, self.noise, 1.00000, ATTN_NORM);
   self.state = STATE_UP;
   if ( (self.spawnflags & CRUSH_SLIDE) ) {

      crusher_slide ( self.pos1);
   } else {

      SUB_CalcMove ( self.pos1, self.speed, crusher_hit_top);

   }
};


void  ()crusher_trigger_use =  {
   if ( !self.level ) {

      self.level = TRUE;
   } else {

      self.level = FALSE;

   }
   if ( self.think ) {

      if ( (self.spawnflags & CRUSH_MULT) ) {

         return ;

      }

   }
   crusher_go_down ( );
};


void  ()crusher_crush =  {
   T_Damage ( other, self, self, self.dmg);
};


void  ()crusher_use =  {
   if ( !self.level ) {

      self.level = TRUE;
   } else {

      self.level = FALSE;

   }
   crusher_go_down ( );
};


void  ()func_crusher =  {
   SetMovedir ( );
   if ( (self.soundtype == 0.00000) ) {

      self.soundtype = 2.00000;

   }
   if ( (self.soundtype == 1.00000) ) {

      precache_sound ( "plats/plat1.wav");
      precache_sound ( "plats/plat2.wav");
      self.noise = "plats/plat1.wav";
      self.noise1 = "plats/plat2.wav";
   } else {

      if ( (self.soundtype == 2.00000) ) {

         precache_sound ( "plats/medplat1.wav");
         precache_sound ( "plats/medplat2.wav");
         self.noise = "plats/medplat1.wav";
         self.noise1 = "plats/medplat2.wav";
      } else {

         if ( (self.soundtype == 3.00000) ) {

            precache_sound2 ( "plats/guiltin1.wav");
            precache_sound2 ( "plats/guiltin2.wav");
            self.noise = "plats/guiltin1.wav";
            self.noise1 = "plats/guiltin2.wav";

         }

      }

   }
   self.mangle = self.angles;
   self.angles = '0.00000 0.00000 0.00000';
   self.classname = "crusher";
   self.solid = SOLID_BSP;
   self.movetype = MOVETYPE_PUSH;
   setorigin ( self, self.origin);
   setmodel ( self, self.model);
   setsize ( self, self.mins, self.maxs);
   self.level = TRUE;
   if ( !self.dmg ) {

      self.dmg = 10.00000;

   }
   self.blocked = crusher_crush;
   if ( !self.speed ) {

      self.speed = 150.00000;

   }
   self.pos1 = self.origin;
   self.pos2 = (self.pos1 + (self.movedir * (fabs ( (self.movedir * self.size)) - self.lip)));
   if ( (self.spawnflags & CRUSH_START_OPEN) ) {

      setorigin ( self, self.pos2);
      self.pos2 = self.pos1;
      self.pos1 = self.origin;

   }
   self.use = crusher_trigger_use;
   if ( self.targetname ) {

      self.state = STATE_UP;
      self.use = crusher_use;
   } else {

      setorigin ( self, self.pos2);
      self.state = STATE_BOTTOM;
      self.nextthink = (self.ltime + 0.10000);
      self.think = crusher_use;

   }
};


void  ()reset_solid =  {
};


void  ()rot_mov_dmg =  {
   if ( (other == world) ) {

      return ;

   }
   if ( (other.classname == "player") ) {

      self.solid = SOLID_TRIGGER;
      self.think = reset_solid;
      AdvanceThinkTime(self,0.10000);

   }
   if ( other.takedamage ) {

      if ( self.noise1 ) {

         sound ( self, CHAN_VOICE, self.noise1, 1.00000, ATTN_NORM);

      }
      self.pain_finished = (time + self.wait);
      T_Damage ( other, self, self.owner, self.dmg);

   }
};


void  ()rot_mov_snd =  {
   if ( (self.pain_finished <= time) ) {

      sound ( self, CHAN_VOICE, self.noise, 1.00000, ATTN_NORM);
      self.pain_finished = (time + self.wait);

   }
   self.think = rot_mov_snd;
   AdvanceThinkTime(self,self.wait);
};


void  ()rot_mov_activate =  {
   if ( self.dmg ) {

      self.touch = rot_mov_dmg;

   }
   if ( !self.avelocity ) {

      self.avelocity = self.o_angle;

   }
   if ( self.noise ) {

      if ( !self.wait ) {

         objerror ( "func_rotating_movechain: sound, but no delay time");
      } else {

         self.think = rot_mov_snd;
         AdvanceThinkTime(self,0.00000);

      }

   }
};

float NOANGLECHAIN   =  1.00000;

void  ()func_rotating_movechain =  {
   if ( !self.netname ) {

      objerror ( "func_rotating_movechain has no netname");

   }
   self.owner = find ( world, netname, self.netname);
   if ( (self.owner.classname == "world") ) {

      objerror ( "func_rotating_movechain has no owner!");

   }
   self.solid = SOLID_TRIGGER;
   self.movetype = MOVETYPE_NOCLIP;
   setmodel ( self, self.model);
   setsize ( self, self.mins, self.maxs);
   setorigin ( self, self.origin);
   self.owner.movechain = self;
   if ( !(self.spawnflags & NOANGLECHAIN) ) {

      self.flags += FL_MOVECHAIN_ANGLE;

   }
   if ( self.targetname ) {

      self.use = rot_mov_activate;
      self.o_angle = self.avelocity;
      self.avelocity = '0.00000 0.00000 0.00000';
   } else {

      self.think = rot_mov_activate;
      AdvanceThinkTime(self,3.00000);

   }
};


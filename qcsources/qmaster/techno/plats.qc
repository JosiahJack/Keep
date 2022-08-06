
void () plat_center_touch;

void () plat_outside_touch;

void () plat_trigger_use;

void () plat_go_up;

void () plat_go_down;

void () plat_crush;
float PLAT_LOW_TRIGGER    = 1.000;

void () plat_spawn_inside_trigger = {

   local entity trigger;
   local vector tmin;
   local vector tmax;

   trigger = spawn ();
   trigger.touch = plat_center_touch;
   trigger.movetype = MOVETYPE_NONE;
   trigger.solid = SOLID_TRIGGER;
   trigger.enemy = self;
   tmin = (self.mins + '25.000 25.000 0.000');
   tmax = (self.maxs - '25.000 25.000 -8.000');
   tmin_z = (tmax_z - ((self.pos1_z - self.pos2_z) + FL_CLIENT));
   if ( (self.spawnflags & PLAT_LOW_TRIGGER) ) {

      tmax_z = (tmin_z + FL_CLIENT);

   }
   if ( (self.size_x <= 50.000) ) {

      tmin_x = ((self.mins_x + self.maxs_x) / FL_SWIM);
      tmax_x = (tmin_x + TRUE);

   }
   if ( (self.size_y <= 50.000) ) {

      tmin_y = ((self.mins_y + self.maxs_y) / FL_SWIM);
      tmax_y = (tmin_y + TRUE);

   }
   setsize (trigger,tmin,tmax);

};

void () plat_hit_top = {

   sound (self,CHAN_VOICE,self.noise1,TRUE,ATTN_NORM);
   self.state = STATE_TOP;
   self.think = plat_go_down;
   self.nextthink = (self.ltime + MOVETYPE_WALK);

};

void () plat_hit_bottom = {

   sound (self,CHAN_VOICE,self.noise1,TRUE,ATTN_NORM);
   self.state = STATE_BOTTOM;

};

void () plat_go_down = {

   sound (self,CHAN_VOICE,self.noise,TRUE,ATTN_NORM);
   self.state = STATE_DOWN;
   SUB_CalcMove (self.pos2,self.speed,plat_hit_bottom);

};

void () plat_go_up = {

   sound (self,CHAN_VOICE,self.noise,TRUE,ATTN_NORM);
   self.state = STATE_UP;
   SUB_CalcMove (self.pos1,self.speed,plat_hit_top);

};

void () plat_center_touch = {

   if ( (other.classname != "player") ) {

      return ;

   }
   if ( (other.health <= FALSE) ) {

      return ;

   }
   self = self.enemy;
   if ( (self.state == STATE_BOTTOM) ) {

      plat_go_up ();

   } else {

      if ( (self.state == STATE_TOP) ) {

         self.nextthink = (self.ltime + TRUE);

      }

   }

};

void () plat_outside_touch = {

   if ( (other.classname != "player") ) {

      return ;

   }
   if ( (other.health <= FALSE) ) {

      return ;

   }
   self = self.enemy;
   if ( (self.state == STATE_TOP) ) {

      plat_go_down ();

   }

};

void () plat_trigger_use = {

   if ( self.think ) {

      return ;

   }
   plat_go_down ();

};

void () plat_crush = {

   T_Damage (other,self,self,TRUE);
   if ( (self.state == STATE_UP) ) {

      plat_go_down ();

   } else {

      if ( (self.state == STATE_DOWN) ) {

         plat_go_up ();

      } else {

         objerror ("plat_crush: bad self.state\n");

      }

   }

};

void () plat_use = {

   self.use = SUB_Null;
   if ( (self.state != STATE_UP) ) {

      objerror ("plat_use: not in up state");

   }
   plat_go_down ();

};

void () func_plat = {

   if ( !self.t_length ) {

      self.t_length = 80.000;

   }
   if ( !self.t_width ) {

      self.t_width = MOVETYPE_BOUNCE;

   }
   if ( (self.sounds == FALSE) ) {

      self.sounds = FL_SWIM;

   }
   if ( (self.sounds == TRUE) ) {

      precache_sound ("plats/plat1.wav");
      precache_sound ("plats/plat2.wav");
      self.noise = "plats/plat1.wav";
      self.noise1 = "plats/plat2.wav";

   }
   if ( (self.sounds == FL_SWIM) ) {

      precache_sound ("plats/medplat1.wav");
      precache_sound ("plats/medplat2.wav");
      self.noise = "plats/medplat1.wav";
      self.noise1 = "plats/medplat2.wav";

   }
   self.mangle = self.angles;
   self.angles = VEC_ORIGIN;
   self.classname = "plat";
   self.solid = SOLID_BSP;
   self.movetype = MOVETYPE_PUSH;
   setorigin (self,self.origin);
   setmodel (self,self.model);
   setsize (self,self.mins,self.maxs);
   self.blocked = plat_crush;
   if ( !self.speed ) {

      self.speed = 150.000;

   }
   self.pos1 = self.origin;
   self.pos2 = self.origin;
   if ( self.height ) {

      self.pos2_z = (self.origin_z - self.height);

   } else {

      self.pos2_z = ((self.origin_z - self.size_z) + FL_CLIENT);

   }
   self.use = plat_trigger_use;
   plat_spawn_inside_trigger ();
   if ( self.targetname ) {

      self.state = STATE_UP;
      self.use = plat_use;

   } else {

      setorigin (self,self.pos2);
      self.state = STATE_BOTTOM;

   }

};

void () train_next;

void () func_train_find;

void () train_blocked = {

   if ( (time < self.attack_finished) ) {

      return ;

   }
   self.attack_finished = (time + 0.500);
   T_Damage (other,self,self,self.dmg);

};

void () train_use = {

   if ( (self.think != func_train_find) ) {

      return ;

   }
   train_next ();

};

void () train_wait = {

   if ( self.wait ) {

      self.nextthink = (self.ltime + self.wait);
      sound (self,CHAN_VOICE,self.noise,TRUE,ATTN_NORM);

   } else {

      self.nextthink = (self.ltime + 0.100);

   }
   self.think = train_next;

};

void () train_next = {

   local entity targ;

   targ = find (world,targetname,self.target);
   self.target = targ.target;
   if ( !self.target ) {

      objerror ("train_next: no next target");

   }
   if ( targ.wait ) {

      self.wait = targ.wait;

   } else {

      self.wait = FALSE;

   }
   sound (self,CHAN_VOICE,self.noise1,TRUE,ATTN_NORM);
   SUB_CalcMove ((targ.origin - self.mins),self.speed,train_wait);

};

void () func_train_find = {

   local entity targ;

   targ = find (world,targetname,self.target);
   self.target = targ.target;
   setorigin (self,(targ.origin - self.mins));
   if ( !self.targetname ) {

      self.nextthink = (self.ltime + 0.100);
      self.think = train_next;

   }

};

void () func_train = {

   if ( !self.speed ) {

      self.speed = 100.000;

   }
   if ( !self.target ) {

      objerror ("func_train without a target");

   }
   if ( !self.dmg ) {

      self.dmg = FL_SWIM;

   }
   if ( (self.sounds == FALSE) ) {

      self.noise = "misc/null.wav";
      precache_sound ("misc/null.wav");
      self.noise1 = "misc/null.wav";
      precache_sound ("misc/null.wav");

   }
   if ( (self.sounds == TRUE) ) {

      self.noise = "plats/train2.wav";
      precache_sound ("plats/train2.wav");
      self.noise1 = "plats/train1.wav";
      precache_sound ("plats/train1.wav");

   }
   self.cnt = TRUE;
   self.solid = SOLID_BSP;
   self.movetype = MOVETYPE_PUSH;
   self.blocked = train_blocked;
   self.use = train_use;
   self.classname = "train";
   setmodel (self,self.model);
   setsize (self,self.mins,self.maxs);
   setorigin (self,self.origin);
   self.nextthink = (self.ltime + 0.100);
   self.think = func_train_find;

};

void () misc_teleporttrain = {

   if ( !self.speed ) {

      self.speed = 100.000;

   }
   if ( !self.target ) {

      objerror ("func_train without a target");

   }
   self.cnt = TRUE;
   self.solid = SOLID_NOT;
   self.movetype = MOVETYPE_PUSH;
   self.blocked = train_blocked;
   self.use = train_use;
   self.avelocity = '100.000 200.000 300.000';
   self.noise = "misc/null.wav";
   precache_sound ("misc/null.wav");
   self.noise1 = "misc/null.wav";
   precache_sound ("misc/null.wav");
   precache_model2 ("progs/teleport.mdl");
   setmodel (self,"progs/teleport.mdl");
   setsize (self,self.mins,self.maxs);
   setorigin (self,self.origin);
   self.nextthink = (self.ltime + 0.100);
   self.think = func_train_find;

};

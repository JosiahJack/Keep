
void () info_null = {

   remove (self);

};

void () info_notnull = {


};
float START_OFF    = 1.000;

void () light_use = {

   if ( (self.spawnflags & START_OFF) ) {

      lightstyle (self.style,"m");
      self.spawnflags = (self.spawnflags - START_OFF);

   } else {

      lightstyle (self.style,"a");
      self.spawnflags = (self.spawnflags + START_OFF);

   }

};

void () light = {

   if ( !self.targetname ) {

      remove (self);
      return ;

   }
   if ( (self.style >= FL_MONSTER) ) {

      self.use = light_use;
      if ( (self.spawnflags & START_OFF) ) {

         lightstyle (self.style,"a");

      } else {

         lightstyle (self.style,"m");

      }

   }

};

void () light_fluoro = {

   if ( (self.style >= FL_MONSTER) ) {

      self.use = light_use;
      if ( (self.spawnflags & START_OFF) ) {

         lightstyle (self.style,"a");

      } else {

         lightstyle (self.style,"m");

      }

   }
   precache_sound ("ambience/fl_hum1.wav");
   ambientsound (self.origin,"ambience/fl_hum1.wav",0.500,ATTN_STATIC);

};

void () light_fluorospark = {

   if ( !self.style ) {

      self.style = MOVETYPE_BOUNCE;

   }
   precache_sound ("ambience/buzz1.wav");
   ambientsound (self.origin,"ambience/buzz1.wav",0.500,ATTN_STATIC);

};

float FLAG_REDORANGE = 1;
float FLAG_YELLOW    = 2;
float FLAG_BLUE      = 4;
float FLAG_WHITE     = 8;
float FLAG_DARKRED   = 16;

void () light_globecolor = {

   if ( (self.spawnflags & FLAG_REDORANGE) ) {

      precache_model ("progs/s_light2.spr");
      setmodel (self,"progs/s_light2.spr");
      makestatic (self);

   }
   if ( (self.spawnflags & FLAG_YELLOW) ) {

      precache_model ("progs/s_light3.spr");
      setmodel (self,"progs/s_light3.spr");
      makestatic (self);

   }
   if ( (self.spawnflags & FLAG_BLUE) ) {

      precache_model ("progs/s_light4.spr");
      setmodel (self,"progs/s_light4.spr");
      makestatic (self);

   }
   if ( (self.spawnflags & FLAG_WHITE) ) {

      precache_model ("progs/s_light5.spr");
      setmodel (self,"progs/s_light5.spr");
      makestatic (self);

   }
   if ( (self.spawnflags & FLAG_DARKRED) ) {

      precache_model ("progs/s_light6.spr");
      setmodel (self,"progs/s_light6.spr");
      makestatic (self);

   }
   if ( (self.spawnflags & FALSE) ) {

      precache_model ("progs/s_light.spr");
      setmodel (self,"progs/s_light.spr");
      makestatic (self);

   }

};

void () light_globe = {

   precache_model ("progs/s_light.spr");
   setmodel (self,"progs/s_light.spr");
   makestatic (self);

};

void () FireAmbient = {

   precache_sound ("ambience/fire1.wav");
   ambientsound (self.origin,"ambience/fire1.wav",0.500,ATTN_STATIC);

};

void () light_torch_small_walltorch = {

   if ( (self.spawnflags & COOP_NOT) ) {

      if (coop) {

         remove (self);

      }
   }

   if ( (self.spawnflags & COOP_ONLY) ) {

      if ( !(coop) ) {

         remove (self);

      }
   }

   precache_model ("progs/flame.mdl");
   setmodel (self,"progs/flame.mdl");
   FireAmbient ();
   makestatic (self);

};

void () light_flame_large_yellow = {

   if ( (self.spawnflags & COOP_NOT) ) {

      if (coop) {

         remove (self);

      }
   }

   if ( (self.spawnflags & COOP_ONLY) ) {

      if ( !(coop) ) {

         remove (self);

      }
   }

   precache_model ("progs/flame2.mdl");
   setmodel (self,"progs/flame2.mdl");
   self.frame = TRUE;
   FireAmbient ();
   makestatic (self);

};

void () light_flame_small_yellow = {

   if ( (self.spawnflags & COOP_NOT) ) {

      if (coop) {

         remove (self);

      }
   }

   if ( (self.spawnflags & COOP_ONLY) ) {

      if ( !(coop) ) {

         remove (self);

      }
   }
   precache_model ("progs/flame2.mdl");
   setmodel (self,"progs/flame2.mdl");
   FireAmbient ();
   makestatic (self);

};

void () light_flame_small_white = {

   precache_model ("progs/flame2.mdl");
   setmodel (self,"progs/flame2.mdl");
   FireAmbient ();
   makestatic (self);

};

void () fire_fly;

void () fire_touch;

void () misc_fireball = {

   precache_model ("progs/lavaball.mdl");
   self.classname = "fireball";
   self.nextthink = (time + (random () * MOVETYPE_FLY));
   self.think = fire_fly;
   if ( !self.speed ) {

      self.speed = 40;

   }

};

void () fire_fly = {

   local entity fireball;

   fireball = spawn ();
   fireball.solid = SOLID_TRIGGER;
   fireball.movetype = MOVETYPE_TOSS;
   fireball.velocity = '0.000 0.000 1000.000';
   fireball.velocity_x = ((random () * 100.000) - 50.000);
   fireball.velocity_y = ((random () * 100.000) - 50.000);
   fireball.velocity_z = (self.speed + (random () * 200.000));
   fireball.classname = "fireball";
   setmodel (fireball,"progs/lavaball.mdl");
   setsize (fireball,VEC_ORIGIN,VEC_ORIGIN);
   setorigin (fireball,self.origin);
   fireball.nextthink = (time + MOVETYPE_FLY);
   fireball.think = SUB_Remove;
   fireball.touch = fire_touch;
   self.nextthink = ((time + (random () * MOVETYPE_FLY)) + MOVETYPE_WALK);
   self.think = fire_fly;

};

void () fire_touch = {

   T_Damage (other,self,self,20.000);
   remove (self);

};

void () barrel_explode = {

   self.takedamage = DAMAGE_NO;
   self.classname = "explo_box";
   T_RadiusDamage (self,self,160.000,world);
   sound (self,CHAN_VOICE,"weapons/r_exp3.wav",TRUE,ATTN_NORM);
   particle (self.origin,VEC_ORIGIN,75.000,255.000);
   self.origin_z = (self.origin_z + FL_MONSTER);
   BecomeExplosion ();

};

void () misc_explobox = {

   local float oldz;

   self.solid = SOLID_BBOX;
   self.movetype = MOVETYPE_NONE;
   precache_model ("maps/b_explob.bsp");
   setmodel (self,"maps/b_explob.bsp");
   precache_sound ("weapons/r_exp3.wav");
   self.health = 20.000;
   self.th_die = barrel_explode;
   self.takedamage = DAMAGE_AIM;
   self.origin_z = (self.origin_z + FL_SWIM);
   oldz = self.origin_z;
   droptofloor ();
   if ( ((oldz - self.origin_z) > 250.000) ) {

      dprint ("item fell out of level at ");
      dprint (vtos (self.origin));
      dprint ("\n");
      remove (self);

   }

};

void () misc_explobox2 = {

   local float oldz;

   self.solid = SOLID_BBOX;
   self.movetype = MOVETYPE_NONE;
   precache_model2 ("maps/b_exbox2.bsp");
   setmodel (self,"maps/b_exbox2.bsp");
   precache_sound ("weapons/r_exp3.wav");
   self.health = 20.000;
   self.th_die = barrel_explode;
   self.takedamage = DAMAGE_AIM;
   self.origin_z = (self.origin_z + FL_SWIM);
   oldz = self.origin_z;
   droptofloor ();
   if ( ((oldz - self.origin_z) > 250.000) ) {

      dprint ("item fell out of level at ");
      dprint (vtos (self.origin));
      dprint ("\n");
      remove (self);

   }

};
float SPAWNFLAG_SUPERSPIKE    = 1.000;
float SPAWNFLAG_LASER    = 2.000;
float SPAWNFLAG_FLAMETHROW	= 4.000;

void (vector org, vector vec) LaunchLaser;
void (vector org, vector dir) launch_flames = {

   newmis = spawn ();
   newmis.owner = self;
   newmis.movetype = MOVETYPE_FLYMISSILE;
   newmis.solid = SOLID_BBOX;
   newmis.angles = vectoangles (dir);
   newmis.touch = fire_touch;
   newmis.classname = "flame";
   newmis.think = SUB_Remove;
   newmis.nextthink = (time + MOVETYPE_STEP);
   setmodel (newmis,"progs/s_explod.spr");
   setsize (newmis,VEC_ORIGIN,VEC_ORIGIN);
   setorigin (newmis,org);
   newmis.velocity = (dir * 1000.000);
   s_explode1 ();

};

void () spikeshooter_use = {

   if ( (self.spawnflags & SPAWNFLAG_LASER) ) {

      sound (self,CHAN_VOICE,"enforcer/enfire.wav",TRUE,ATTN_NORM);
      LaunchLaser (self.origin,self.movedir);

   } else {

      if ( (self.spawnflags & SPAWNFLAG_FLAMETHROW) ) {

         sound (self,CHAN_VOICE,"weapons/flameburst1.wav",TRUE,ATTN_NORM);
         launch_flames (self.origin,self.movedir);
         newmis.velocity = (self.movedir * 300.000);
         newmis.touch = fire_touch;

      } else {

         sound (self,CHAN_VOICE,"weapons/spike2.wav",TRUE,ATTN_NORM);
         launch_spike (self.origin,self.movedir);
         newmis.velocity = (self.movedir * 500.000);
         if ( (self.spawnflags & SPAWNFLAG_SUPERSPIKE) ) {

            newmis.touch = superspike_touch;

         }

      }

   }

};

void () shooter_think = {

   spikeshooter_use ();
   self.nextthink = (time + self.wait);
   newmis.velocity = (self.movedir * 500.000);

};

void () trap_spikeshooter = {

   SetMovedir ();
   self.use = spikeshooter_use;
   if ( (self.spawnflags & SPAWNFLAG_LASER) ) {

      precache_model2 ("progs/laser.mdl");
      precache_sound2 ("enforcer/enfire.wav");
      precache_sound2 ("enforcer/enfstop.wav");

   } else {

      precache_sound ("weapons/spike2.wav");

   }

};

void () trap_shooter = {

   trap_spikeshooter ();
   if ( (self.wait == FALSE) ) {

      self.wait = TRUE;

   }
   self.nextthink = ((self.nextthink + self.wait) + self.ltime);
   self.think = shooter_think;

};

void () make_bubbles;

void () bubble_remove;

void () air_bubbles = {

   if ( deathmatch ) {

      remove (self);
      return ;

   }
   precache_model ("progs/s_bubble.spr");
   self.nextthink = (time + TRUE);
   self.think = make_bubbles;

};

void () make_bubbles = {

   local entity bubble;

   bubble = spawn ();
   setmodel (bubble,"progs/s_bubble.spr");
   setorigin (bubble,self.origin);
   bubble.movetype = MOVETYPE_NOCLIP;
   bubble.solid = SOLID_NOT;
   bubble.velocity = '0.000 0.000 15.000';
   bubble.nextthink = (time + 0.500);
   bubble.think = bubble_bob;
   bubble.touch = bubble_remove;
   bubble.classname = "bubble";
   bubble.frame = FALSE;
   bubble.cnt = FALSE;
   setsize (bubble,'-8.000 -8.000 -8.000','8.000 8.000 8.000');
   self.nextthink = ((time + random ()) + 0.500);
   self.think = make_bubbles;

};

void () bubble_split = {

   local entity bubble;

   bubble = spawn ();
   setmodel (bubble,"progs/s_bubble.spr");
   setorigin (bubble,self.origin);
   bubble.movetype = MOVETYPE_NOCLIP;
   bubble.solid = SOLID_NOT;
   bubble.velocity = self.velocity;
   bubble.nextthink = (time + 0.500);
   bubble.think = bubble_bob;
   bubble.touch = bubble_remove;
   bubble.classname = "bubble";
   bubble.frame = TRUE;
   bubble.cnt = MOVETYPE_BOUNCE;
   setsize (bubble,'-8.000 -8.000 -8.000','8.000 8.000 8.000');
   self.frame = TRUE;
   self.cnt = MOVETYPE_BOUNCE;
   if ( (self.waterlevel != MOVETYPE_WALK) ) {

      remove (self);

   }

};

void () bubble_remove = {

   if ( (other.classname == self.classname) ) {

      return ;

   }
   remove (self);

};

void () bubble_bob = {

   local float rnd1;
   local float rnd2;
   local float rnd3;
   local vector vtmp1;
   local vector modi;

   self.cnt = (self.cnt + TRUE);
   if ( (self.cnt == MOVETYPE_STEP) ) {

      bubble_split ();

   }
   if ( (self.cnt == 20.000) ) {

      remove (self);

   }
   rnd1 = (self.velocity_x + (-10.000 + (random () * 20.000)));
   rnd2 = (self.velocity_y + (-10.000 + (random () * 20.000)));
   rnd3 = ((self.velocity_z + MOVETYPE_BOUNCE) + (random () * MOVETYPE_BOUNCE));
   if ( (rnd1 > MOVETYPE_BOUNCE) ) {

      rnd1 = MOVETYPE_FLY;

   }
   if ( (rnd1 < -10.000) ) {

      rnd1 = CONTENT_LAVA;

   }
   if ( (rnd2 > MOVETYPE_BOUNCE) ) {

      rnd2 = MOVETYPE_FLY;

   }
   if ( (rnd2 < -10.000) ) {

      rnd2 = CONTENT_LAVA;

   }
   if ( (rnd3 < MOVETYPE_BOUNCE) ) {

      rnd3 = 15.000;

   }
   if ( (rnd3 > SVC_INTERMISSION) ) {

      rnd3 = 25.000;

   }
   self.velocity_x = rnd1;
   self.velocity_y = rnd2;
   self.velocity_z = rnd3;
   self.nextthink = (time + 0.500);
   self.think = bubble_bob;

};

void () viewthing = {

   self.movetype = MOVETYPE_NONE;
   self.solid = SOLID_NOT;
   precache_model ("progs/player.mdl");
   setmodel (self,"progs/player.mdl");

};

void () func_wall_use = {

   self.frame = (TRUE - self.frame);

};


void () func_wall = {

   if ( (self.spawnflags & COOP_NOT) ) {

      if (coop) {

         remove (self);

      }
   }

   if ( (self.spawnflags & COOP_ONLY) ) {

      if ( !(coop) ) {

         remove (self);

      }
   }

   self.angles = VEC_ORIGIN;
   self.movetype = MOVETYPE_PUSH;
   self.solid = SOLID_BSP;
   self.use = func_wall_use;
   setmodel (self,self.model);

};

void () func_illusionary = {

   self.angles = VEC_ORIGIN;
   self.movetype = MOVETYPE_NONE;
   self.solid = SOLID_NOT;
   setmodel (self,self.model);
   makestatic ();

};

void () func_episodegate = {

   if ( !(serverflags & self.spawnflags) ) {

      return ;

   }
   self.angles = VEC_ORIGIN;
   self.movetype = MOVETYPE_PUSH;
   self.solid = SOLID_BSP;
   self.use = func_wall_use;
   setmodel (self,self.model);

};

void () func_bossgate = {

   if ( ((serverflags & 15.000) == 15.000) ) {

      return ;

   }
   self.angles = VEC_ORIGIN;
   self.movetype = MOVETYPE_PUSH;
   self.solid = SOLID_BSP;
   self.use = func_wall_use;
   setmodel (self,self.model);

};

void () ambient_suck_wind = {

   precache_sound ("ambience/suck1.wav");
   ambientsound (self.origin,"ambience/suck1.wav",TRUE,ATTN_STATIC);

};

void () ambient_drone = {

   precache_sound ("ambience/drone6.wav");
   ambientsound (self.origin,"ambience/drone6.wav",0.500,ATTN_STATIC);

};

void () ambient_flouro_buzz = {

   precache_sound ("ambience/buzz1.wav");
   ambientsound (self.origin,"ambience/buzz1.wav",TRUE,ATTN_STATIC);

};

void () ambient_drip = {

   precache_sound ("ambience/drip1.wav");
   ambientsound (self.origin,"ambience/drip1.wav",0.500,ATTN_STATIC);

};

void () ambient_comp_hum = {

   precache_sound ("ambience/comp1.wav");
   ambientsound (self.origin,"ambience/comp1.wav",TRUE,ATTN_STATIC);

};

void () ambient_thunder = {

   precache_sound ("ambience/thunder1.wav");
   ambientsound (self.origin,"ambience/thunder1.wav",0.500,ATTN_STATIC);

};

void () ambient_light_buzz = {

   precache_sound ("ambience/fl_hum1.wav");
   ambientsound (self.origin,"ambience/fl_hum1.wav",0.500,ATTN_STATIC);

};

void () ambient_swamp1 = {

   precache_sound ("ambience/swamp1.wav");
   ambientsound (self.origin,"ambience/swamp1.wav",0.500,ATTN_STATIC);

};

void () ambient_swamp2 = {

   precache_sound ("ambience/swamp2.wav");
   ambientsound (self.origin,"ambience/swamp2.wav",0.500,ATTN_STATIC);

};
// Added for keep

void () ambient_running_water = {

   if ( (self.volume == FALSE) ) {

      self.volume = 0.500;

   }
   precache_sound ("ambient/runwater.wav");
   ambientsound (self.origin,"ambient/runwater.wav",self.volume,ATTN_STATIC);

};

// End added for keep

void () noise_think = {

   self.nextthink = (time + 0.500);
   sound (self,TRUE,"enforcer/enfire.wav",TRUE,ATTN_NORM);
   sound (self,FL_SWIM,"enforcer/enfstop.wav",TRUE,ATTN_NORM);
   sound (self,MOVETYPE_WALK,"enforcer/sight1.wav",TRUE,ATTN_NORM);
   sound (self,MOVETYPE_STEP,"enforcer/sight2.wav",TRUE,ATTN_NORM);
   sound (self,MOVETYPE_FLY,"enforcer/sight3.wav",TRUE,ATTN_NORM);
   sound (self,MOVETYPE_TOSS,"enforcer/sight4.wav",TRUE,ATTN_NORM);
   sound (self,MOVETYPE_PUSH,"enforcer/pain1.wav",TRUE,ATTN_NORM);

};

void () misc_noisemaker = {

   precache_sound2 ("enforcer/enfire.wav");
   precache_sound2 ("enforcer/enfstop.wav");
   precache_sound2 ("enforcer/sight1.wav");
   precache_sound2 ("enforcer/sight2.wav");
   precache_sound2 ("enforcer/sight3.wav");
   precache_sound2 ("enforcer/sight4.wav");
   precache_sound2 ("enforcer/pain1.wav");
   precache_sound2 ("enforcer/pain2.wav");
   precache_sound2 ("enforcer/death1.wav");
   precache_sound2 ("enforcer/idle1.wav");
   self.nextthink = ((time + 0.100) + random ());
   self.think = noise_think;

};

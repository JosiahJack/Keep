void  ()wake_effect;
void  ()snake_think;
float  ()snake_look;

void  ()snake_sleep =  {
   self.nextthink = (time - 1.00000);
   self.think = SUB_Null;
};


void  ()snake_settle =  {
   AdvanceFrame( 37.00000, 44.00000);
   if ( (self.frame == 38.00000) ) {

      sound ( self, CHAN_BODY, "snake/hiss.wav", 1.00000, ATTN_NORM);

   }
   if ( cycle_wrapped ) {

      wake_effect ( );

   }
};


void  ()snake_unsway =  {
   AdvanceFrame( 82.00000, 94.00000);
   if ( (self.frame == 86.00000) ) {

      sound ( self, CHAN_BODY, "snake/hiss.wav", 1.00000, ATTN_NORM);

   }
   if ( cycle_wrapped ) {

      snake_settle ( );

   }
};


void  ()spit_touch =  {
local float damg = 0.00000;
local vector delta = '0.00000 0.00000 0.00000';
   damg = random(10.00000,14.00000);
   T_Damage ( other, self, self.owner, damg);
   self.origin = ((self.origin - (8.00000 * normalize ( self.velocity))) - '0.00000 0.00000 40.00000');
   sound ( self, CHAN_WEAPON, "weapons/explode.wav", 1.00000, ATTN_NORM);
   if ( other ) {

      delta = (other.origin - self.origin);
      other.velocity = (delta * 40.00000);
      other.flags ^= FL_ONGROUND;
      other.velocity_z = 275.00000;

   }
   CreateRedSpark ( self.origin);
   remove ( self);
};


void  ()snake_missile_think =  {
   if ( (self.lifetime < time) ) {

      spit_touch ( );
   } else {

      HomeThink ( );
      self.angles = vectoangles ( self.velocity);
      self.think = snake_missile_think;
      AdvanceThinkTime(self,HX_FRAME_TIME);

   }
};


void  (vector spot1)snake_missile_shoot =  {
local vector diff = '0.00000 0.00000 0.00000';
   newmis = spawn ( );
   newmis.owner = self;
   newmis.movetype = MOVETYPE_FLYMISSILE;
   newmis.solid = SOLID_BBOX;
   setmodel ( newmis, "models/goop.mdl");
   setsize ( newmis, '0.00000 0.00000 0.00000', '0.00000 0.00000 0.00000');
   setorigin ( newmis, spot1);
   newmis.angles = self.angles;
   diff = ((self.enemy.origin + self.enemy.view_ofs) - spot1);
   newmis.velocity = normalize ( diff);
   newmis.angles = vectoangles ( newmis.velocity);
   makevectors ( newmis.angles);
   newmis.velocity = (newmis.velocity * 1000.00000);
   newmis.speed = 1000.00000;
   newmis.classname = "faminemissile";
   newmis.angles = vectoangles ( newmis.velocity);
   newmis.veer = TRUE;
   newmis.turn_time = 3.00000;
   newmis.ideal_yaw = TRUE;
   newmis.lockentity = self.enemy;
   newmis.lifetime = (time + 1.50000);
   newmis.think = snake_missile_think;
   AdvanceThinkTime(newmis,HX_FRAME_TIME);
   newmis.touch = spit_touch;
};


void  ()snake_missile =  {
   makevectors ( self.angles);
   snake_missile_shoot ( (((self.origin + (v_forward * 4.00000)) + (v_right * 38.00000)) + (v_up * 195.00000)));
   makevectors ( self.angles);
   snake_missile_shoot ( (((self.origin + (v_forward * 4.00000)) + (v_right * 57.00000)) + (v_up * 195.00000)));
};


void  ()snake_attackleft =  {
   AdvanceFrame( 45.00000, 57.00000);
   if ( (self.frame == 49.00000) ) {

      snake_missile ( );

   }
   if ( (self.frame == 45.00000) ) {

      sound ( self, CHAN_WEAPON, "snake/attack.wav", 1.00000, ATTN_NORM);

   }
   if ( cycle_wrapped ) {

      snake_think ( );

   }
};


void  ()snake_attackright =  {
   AdvanceFrame( 58.00000, 70.00000);
   if ( (self.frame == 62.00000) ) {

      snake_missile ( );

   }
   if ( (self.frame == 61.00000) ) {

      sound ( self, CHAN_WEAPON, "snake/attack.wav", 1.00000, ATTN_NORM);

   }
   if ( cycle_wrapped ) {

      snake_think ( );

   }
};


void  ()snake_attackfront =  {
   AdvanceFrame( 99.00000, 113.00000);
   if ( (self.frame == 104.00000) ) {

      snake_missile ( );

   }
   if ( (self.frame == 100.00000) ) {

      sound ( self, CHAN_WEAPON, "snake/attack.wav", 1.00000, ATTN_NORM);

   }
   if ( cycle_wrapped ) {

      snake_think ( );

   }
};


void  ()snake_attack =  {
   self.attack_cnt += 1.00000;
   self.ideal_yaw = vectoyaw ( (self.enemy.origin - self.origin));
   self.ideal_yaw = (vectoyaw ( (self.enemy.origin - self.origin)) - self.angles_y);
   if ( (((self.ideal_yaw >= 0.00000) && (self.ideal_yaw < 25.00000)) || ((self.ideal_yaw >= -25.00000) && (self.ideal_yaw < -1.00000))) ) {

      snake_attackfront ( );
   } else {

      if ( ((self.ideal_yaw >= 25.00000) && (self.ideal_yaw < 180.00000)) ) {

         snake_attackleft ( );
      } else {

         snake_attackright ( );

      }

   }
};


void  ()snake_dancetongue =  {
   AdvanceFrame( 14.00000, 26.00000);
   AdvanceThinkTime(self,(HX_FRAME_TIME * 1.50000));
   if ( (self.frame == 16.00000) ) {

      sound ( self, CHAN_BODY, "snake/hiss.wav", 1.00000, ATTN_NORM);

   }
   if ( cycle_wrapped ) {

      snake_think ( );

   }
};


void  ()snake_dancetail =  {
   AdvanceFrame( 1.00000, 13.00000);
   AdvanceThinkTime(self,(HX_FRAME_TIME * 1.50000));
   if ( cycle_wrapped ) {

      snake_think ( );

   }
};


void  ()snake_dance =  {
   self.attack_cnt = 0.00000;
   if ( (random() < 0.50000) ) {

      snake_dancetail ( );
   } else {

      snake_dancetongue ( );

   }
};


void  ()snake_startsway =  {
   AdvanceFrame( 71.00000, 81.00000);
   AdvanceThinkTime(self,HX_FRAME_TIME);
   if ( cycle_wrapped ) {

      snake_dance ( );

   }
};


void  ()snake_wake =  {
   AdvanceFrame( 95.00000, 113.00000);
   AdvanceThinkTime(self,HX_FRAME_TIME);
   if ( (self.frame < 109.00000) ) {

      self.abslight = (0.25000 + (0.05000 * (self.frame - 95.00000)));
   } else {

      self.abslight -= 0.05000;

   }
   if ( (self.frame == 113.00000) ) {

      self.drawflags ^= MLS_ABSLIGHT;

   }
   if ( (self.frame == 100.00000) ) {

      sound ( self, CHAN_ITEM, "snake/wake.wav", 1.00000, ATTN_NORM);

   }
   self.skin = 0.00000;
   if ( cycle_wrapped ) {

      snake_startsway ( );

   }
};

float float_null   =  0.00000;

float  ()snake_look =  {
local entity client;
   client = checkclient ( );
   if ( !client ) {

      return ( FALSE );

   }
   if ( ((client.items & IT_INVISIBILITY) || (client.flags & FL_NOTARGET)) ) {

      return ( FALSE );

   }
   if ( !visible ( client) ) {

      return ( FALSE );

   }
   if ( (client.classname == "player") ) {

      self.enemy = client;
      return ( TRUE );

   }
   return ( FALSE );
};


void  ()snake_think =  {
local float chance = 0.00000;
   if ( snake_look ( ) ) {

      enemy_range = vlen ( (self.origin - self.enemy.origin));
      enemy_range -= 80.00000;
      if ( (enemy_range < 200.00000) ) {

         chance = 0.90000;
      } else {

         if ( (enemy_range < 400.00000) ) {

            chance = 0.80000;
         } else {

            if ( (enemy_range < 800.00000) ) {

               chance = 0.70000;
            } else {

               if ( (enemy_range < 1200.00000) ) {

                  chance = 0.60000;
               } else {

                  if ( (enemy_range < 2000.00000) ) {

                     chance = 0.50000;
                  } else {

                     self.enemy = world;
                     chance = 0.00000;

                  }

               }

            }

         }

      }
      chance -= ((self.attack_cnt / 2.00000) * 0.10000);
      if ( (random() < chance) ) {

         self.last_attack = time;
         snake_attack ( );
      } else {

         snake_dance ( );

      }
   } else {

      self.enemy = world;
      snake_dance ( );

   }
   if ( (self.last_attack < (time - 30.00000)) ) {

      snake_unsway ( );

   }
};


void  ()wake_effect =  {
local entity newent;
   newent = spawn ( );
   setorigin ( newent, self.origin);
   sound ( self, CHAN_BODY, "snake/life.wav", 1.00000, ATTN_NORM);
   if ( (self.colormap != float_null) ) {

      CreateGreySmoke ( (self.origin + '0.00000 0.00000 60.00000'), '0.00000 0.00000 12.00000', (HX_FRAME_TIME * 20.00000));
      CreateGreySmoke ( (self.origin + '16.00000 16.00000 55.00000'), '0.00000 0.00000 12.00000', (HX_FRAME_TIME * 20.00000));
      CreateGreySmoke ( (self.origin + '32.00000 32.00000 80.00000'), '0.00000 0.00000 12.00000', (HX_FRAME_TIME * 20.00000));
      CreateGreySmoke ( (self.origin + '64.00000 64.00000 50.00000'), '0.00000 0.00000 12.00000', (HX_FRAME_TIME * 20.00000));
      CreateGreySmoke ( (self.origin + '-16.00000 -16.00000 65.00000'), '0.00000 0.00000 12.00000', (HX_FRAME_TIME * 20.00000));
      CreateGreySmoke ( (self.origin + '-32.00000 -32.00000 45.00000'), '0.00000 0.00000 12.00000', (HX_FRAME_TIME * 20.00000));
      CreateGreySmoke ( (self.origin + '-64.00000 -64.00000 70.00000'), '0.00000 0.00000 12.00000', (HX_FRAME_TIME * 20.00000));
      self.use = SUB_Null;
      self.colormap = float_null;
      self.takedamage = DAMAGE_YES;
      self.drawflags |= MLS_ABSLIGHT;
      snake_wake ( );
   } else {

      self.colormap = 3.00000;
      self.use = wake_effect;
      self.takedamage = DAMAGE_NO;
      snake_sleep ( );

   }
};


void  ()monster_snake =  {
   if ( deathmatch ) {

      remove ( self);
      return ;

   }
   self.solid = SOLID_BBOX;
   self.movetype = MOVETYPE_NONE;
   self.colormap = 3.00000;
   precache_model2 ( "models/goop.mdl");
   precache_model2 ( "models/snake.mdl");
   setmodel ( self, "models/snake.mdl");
   precache_sound2 ( "snake/attack.wav");
   precache_sound2 ( "snake/hiss.wav");
   precache_sound2 ( "snake/wake.wav");
   precache_sound2 ( "snake/life.wav");
   precache_sound2 ( "fangel/deflect.wav");
   setsize ( self, '-80.00000 -80.00000 0.00000', '80.00000 80.00000 200.00000');
   self.health = 1200.00000;
   total_monsters += 1.00000;
   self.view_ofs = '0.00000 0.00000 40.00000';
   self.flags |= FL_MONSTER;
   self.use = wake_effect;
   self.th_die = chunk_death;
   self.thingtype = THINGTYPE_BROWNSTONE;
   self.monsterclass = CLASS_BOSS;
   self.counter = 0.00000;
};


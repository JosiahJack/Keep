void  ()fangel_blockframes;
void  ()fangel_handframes;
void  ()fangel_wingframes;
void  ()fangel_flyframes;
float fangel_attack_speed   =  11.00000;
float fangel_move_speed   =  6.00000;

float  ()fangel_check_incoming =  {
local entity item;
local vector vec = '0.00000 0.00000 0.00000';
local vector realVec = '0.00000 0.00000 0.00000';
local float dot = 0.00000;
   if ( (range ( self.enemy) <= RANGE_MELEE) ) {

      return ( FALSE );

   }
   if ( (fov ( self, self.enemy, 30.00000) && ((self.enemy.last_attack + 0.75000) > time)) ) {

      self.th_save = self.think;
      self.fangel_Count = 0.00000;
      fangel_blockframes ( );
      return ( TRUE );

   }
   if ( (random() > ((0.40000 + (skill / 10.00000)) + (self.skin / 10.00000))) ) {

      return ( FALSE );

   }
   item = findradius ( self.origin, 256.00000);
   while ( item ) {

      if ( ((item.owner.classname == "player") && (((item.movetype == MOVETYPE_FLYMISSILE) || (item.movetype == MOVETYPE_BOUNCEMISSILE)) || (item.movetype == MOVETYPE_BOUNCE))) ) {

         vec = normalize ( ((self.origin - item.origin) + self.view_ofs));
         realVec = normalize ( item.velocity);
         dot = (vec * realVec);
         if ( (dot >= 0.40000) ) {

            self.th_save = self.think;
            self.fangel_Count = 0.00000;
            fangel_blockframes ( );
            return ( TRUE );

         }

      }
      item = item.chain;

   }
   return ( FALSE );
};

float FANGEL_STAGE_WAIT   =  0.00000;
float FANGEL_STAGE_FLY   =  1.00000;
float FANGEL_STAGE_FLOAT   =  2.00000;
float FANGEL_STAGE_SIDESTEP   =  3.00000;

void  ()fangel_check_wing =  {
local float retval = 0.00000;
   enemy_infront = visible ( self.enemy);
   if ( ((self.monster_stage == FANGEL_STAGE_FLY) && (random() < 0.50000)) ) {

      enemy_infront = 0.00000;

   }
   if ( enemy_infront ) {

      self.th_save = self.think;
      enemy_range = range ( self.enemy);
      if ( (random() < 0.50000) ) {

         retval = CheckMonsterAttack ( MA_FAR_MELEE, 1.00000);
      } else {

         retval = CheckMonsterAttack ( MA_MISSILE, 1.00000);

      }
   } else {

      retval = MA_NOATTACK;

   }
   if ( (retval != MA_SUCCESSFUL) ) {

      fangel_check_incoming ( );
   } else {

      self.yaw_speed = fangel_attack_speed;

   }
};


void  ()fangel_find_spot =  {
local float crj = 0.00000;
local float radius = 0.00000;
local float dist = 0.00000;
local vector vec = '0.00000 0.00000 0.00000';
   crj = 0.00000;
   while ( (crj < 50.00000) ) {

      radius = random(100.00000,200.00000);
      vec = random('0.00000 0.00000 0.00000','360.00000 360.00000 0.00000');
      vec = normalize ( vec);
      vec = (self.enemy.origin + (vec * radius));
      vec_z = ((vec_z + random(20.00000,40.00000)) + self.enemy.view_ofs_z);
      tracearea ( self.origin, vec, self.mins, self.maxs, FALSE, self);
      if ( (trace_fraction == 1.00000) ) {

         self.monster_last_seen = vec;
         dist = (self.origin_z - self.monster_last_seen_z);
         if ( (dist < -20.00000) ) {

            self.z_movement = random(0.00000,2.00000);
         } else {

            if ( (dist > 20.00000) ) {

               self.z_movement = random(-2.00000,0.00000);
            } else {

               self.z_movement = random(-2.00000,2.00000);

            }

         }
         self.z_duration = (time + (HX_FRAME_TIME * random(15.00000,25.00000)));
         return ;

      }
      crj += 1.00000;

   }
   self.monster_stage = FANGEL_STAGE_FLOAT;
   self.monster_duration = random(20.00000,30.00000);
};


void  ()fangel_init =  {
   self.ideal_yaw = vectoyaw ( (self.enemy.origin - self.origin));
   self.think = self.th_stand;
   AdvanceThinkTime(self,random(0.10000,0.60000));
   self.count = 0.00000;
   self.monster_stage = FANGEL_STAGE_FLY;
   self.monster_duration = 0.00000;
   self.goalentity = self.enemy;
   self.monster_awake = TRUE;
   if ( self.skin ) {

      self.drawflags |= MLS_POWERMODE;

   }
   fangel_find_spot ( );
};


void  ()fangel_wait =  {
   AdvanceThinkTime(self,0.15000);
   if ( LocateTarget ( ) ) {

      fangel_init ( );
   } else {

      if ( ((random(100.00000) < 5.00000) && (self.t_width < time)) ) {

         self.t_width = (time + 7.00000);
         if ( self.skin ) {

            sound ( self, CHAN_AUTO, "fangel/ambi2.wav", random(0.50000,1.00000), ATTN_NORM);
         } else {

            sound ( self, CHAN_AUTO, "fangel/ambi1.wav", random(0.50000,1.00000), ATTN_NORM);

         }

      }

   }
};


void  ()fangel_sidestep =  {
local float retval = 0.00000;
local float dist = 0.00000;
local float chance = 0.00000;
   self.monster_duration -= 1.00000;
   dist = random(1.00000,4.00000);
   retval = walkmove ( (self.angles_y + 90.00000), dist, FALSE);
   if ( !retval ) {

      self.monster_stage = FANGEL_STAGE_FLY;
      fangel_find_spot ( );
      self.think = fangel_flyframes;
      self.nextthink = time;
      return ;

   }
   dist = (self.origin_z - self.monster_last_seen_z);
   if ( (dist < -20.00000) ) {

      self.z_movement = random(0.00000,2.00000);
      self.z_duration = (time + (HX_FRAME_TIME * random(15.00000,25.00000)));
   } else {

      if ( (dist > 20.00000) ) {

         self.z_movement = random(-2.00000,0.00000);
         self.z_duration = (time + (HX_FRAME_TIME * random(15.00000,25.00000)));

      }

   }
   if ( (self.monster_duration <= 0.00000) ) {

      chance = random();
      if ( (chance < 0.33000) ) {

         self.monster_stage = FANGEL_STAGE_FLOAT;
         self.monster_duration = random(10.00000,30.00000);
      } else {

         if ( (chance < 0.66000) ) {

            self.think = fangel_handframes;
         } else {

            self.think = fangel_wingframes;

         }

      }

   }
};


void  (float thrust)fangel_fly =  {
local float retval = 0.00000;
local float dist = 0.00000;
local float Length = 0.00000;
   Length = vhlen ( (self.origin - self.monster_last_seen));
   self.ideal_yaw = vectoyaw ( (self.monster_last_seen - self.origin));
   ChangeYaw ( );
   dist = (2.00000 + (thrust * 4.00000));
   if ( (Length < 20.00000) ) {

      if ( (random() < 0.10000) ) {

         fangel_find_spot ( );
      } else {

         self.monster_stage = FANGEL_STAGE_FLOAT;
         self.monster_duration = random(10.00000,30.00000);

      }
      return ;

   }
   retval = walkmove ( self.angles_y, dist, FALSE);
   if ( !retval ) {

      fangel_find_spot ( );
      return ;

   }
   dist = (self.origin_z - self.monster_last_seen_z);
   if ( (dist < -20.00000) ) {

      self.z_movement = random(2.00000,4.00000);
      self.z_duration = (time + (HX_FRAME_TIME * random(15.00000,25.00000)));
   } else {

      if ( (dist > 20.00000) ) {

         self.z_movement = random(-2.00000,-4.00000);
         self.z_duration = (time + (HX_FRAME_TIME * random(15.00000,25.00000)));

      }

   }
   if ( (self.z_duration > time) ) {

      movestep ( 0.00000, 0.00000, self.z_movement, FALSE);

   }
};


void  ()fangel_float =  {
   self.monster_duration = (self.monster_duration - 1.00000);
   ai_face ( );
   enemy_range = range ( self.enemy);
   if ( ((enemy_range <= RANGE_NEAR) && (random() < 0.25000)) ) {

      self.monster_duration = 0.00000;
   } else {

      if ( ((enemy_range <= RANGE_MELEE) && (random() < 0.90000)) ) {

         self.monster_duration = 0.00000;

      }

   }
   if ( (self.monster_duration <= 0.00000) ) {

      self.monster_stage = FANGEL_STAGE_FLY;
      fangel_find_spot ( );

   }
};


void  (float thrust)fangel_move =  {
   check_z_move ( (thrust / 2.00000));
   if ( (self.monster_stage == FANGEL_STAGE_WAIT) ) {

      fangel_wait ( );
      return ;
   } else {

      if ( (self.monster_stage == FANGEL_STAGE_FLY) ) {

         fangel_fly ( thrust);
         return ;
      } else {

         if ( (self.monster_stage == FANGEL_STAGE_SIDESTEP) ) {

            fangel_sidestep ( );
            return ;
         } else {

            if ( (self.monster_stage == FANGEL_STAGE_FLOAT) ) {

               fangel_float ( );
               return ;

            }

         }

      }

   }
};


void  ()fangel_prepare_attack =  {
   ai_face ( );
};


void  ()fangel_hand_fire =  {
   fangel_prepare_attack ( );
   sound ( self, CHAN_WEAPON, "fangel/hand.wav", 1.00000, ATTN_NORM);
   do_faSpell ( '10.00000 -4.00000 8.00000', 400.00000);
   do_faSpell ( '10.00000 -4.00000 8.00000', 300.00000);
};


void  ()fangel_wing_fire =  {
   fangel_prepare_attack ( );
   sound ( self, CHAN_WEAPON, "fangel/wing.wav", 1.00000, ATTN_NORM);
   makevectors ( self.angles);
   do_faBlade ( '8.00000 6.00000 4.00000', 360.00000, (v_right * 2.00000));
   do_faBlade ( '-8.00000 6.00000 4.00000', 360.00000, (v_right * -2.00000));
};

float fangel_fly_offsets [20]   = { 0.00000,
    0.10000,    0.20000,    0.30000,    0.40000,
    0.50000,    0.60000,    0.70000,    0.80000,
    0.90000,    1.00000,    0.90000,    0.80000,
    0.70000,    0.60000,    0.50000,    0.40000,
    0.30000,    0.20000,    0.10000};

void  ()fangel_blockframes =  {
local float RetVal = 0.00000;
local float chance = 0.00000;
   self.think = fangel_blockframes;
   AdvanceThinkTime(self,HX_FRAME_TIME);
   if ( (self.velocity != '0.00000 0.00000 0.00000') ) {

      self.velocity = (self.velocity * 0.70000);

   }
   ai_face ( );
   check_z_move ( 3.00000);
   if ( self.fangel_Count ) {

      self.fangel_Count -= 1.00000;
      RetVal = 3.00000;
   } else {

      if ( (fov ( self, self.enemy, 30.00000) && ((self.enemy.last_attack + 0.75000) > time)) ) {

         self.fangel_Count += 1.00000;
      } else {

         RetVal = AdvanceFrame ( 0.00000, 20.00000);

      }

   }
   if ( (self.frame == 20.00000) ) {

      if ( self.movechain ) {

         remove ( self.movechain);

      }
      self.movechain = world;

   }
   if ( (RetVal == AF_END) ) {

      self.takedamage = DAMAGE_YES;
      chance = random();
      if ( (chance < 0.10000) ) {

         self.think = self.th_save;
      } else {

         if ( (chance < 0.60000) ) {

            self.think = fangel_handframes;
         } else {

            self.think = fangel_wingframes;

         }

      }
   } else {

      if ( (RetVal == AF_NORMAL) ) {

         if ( (self.frame == 12.00000) ) {

            self.fangel_Count = 40.00000;

         }

      }

   }
   if ( (self.frame == 8.00000) ) {

      self.takedamage = DAMAGE_NO;
      spawn_reflect ( );

   }
};


void  ()fangel_deathframes =  {
   if ( (self.health <= -40.00000) ) {

      chunk_death ( );
      return ;

   }
   self.think = fangel_deathframes;
   AdvanceThinkTime(self,HX_FRAME_TIME);
   traceline ( self.origin, (self.origin - '0.00000 0.00000 250.00000'), FALSE, self);
   particle2 ( trace_endpos, '-30.00000 -30.00000 50.00000', '30.00000 30.00000 100.00000', 384.00000, PARTICLETYPE_SPELL, 80.00000);
   if ( (self.frame == 26.00000) ) {

      self.drop_time = (time + 0.25000);

   }
   if ( ((self.frame == 27.00000) && !(self.flags & FL_ONGROUND)) ) {

      self.frame = 26.00000;
      self.velocity_z = -20.00000;
      if ( (self.drop_time < time) ) {

         self.frame = 27.00000;

      }

   }
   if ( (AdvanceFrame ( 21.00000, 60.00000) == AF_BEGINNING) ) {

      remove ( self);

   }
   if ( (self.frame == 21.00000) ) {

      self.movetype = MOVETYPE_STEP;

   }
   if ( (self.frame == 30.00000) ) {

      if ( (self.classname == "monster_fallen_angel") ) {

         sound ( self, CHAN_WEAPON, "fangel/death.wav", 1.00000, ATTN_NORM);
      } else {

         sound ( self, CHAN_WEAPON, "fangel/death2.wav", 1.00000, ATTN_NORM);

      }

   }
};


void  ()fangel_flyforward =  {
   AdvanceFrame ( 113.00000, 132.00000);
   self.frame += 1.00000;
   fangel_move ( (3.00000 * (fangel_fly_offsets->(self.frame - 113.00000))));
   if ( (self.frame == 114.00000) ) {

      sound ( self, CHAN_WEAPON, "fangel/fly.wav", 1.00000, ATTN_NORM);

   }
   if ( (((self.frame >= 118.00000) && (self.frame <= 120.00000)) || ((self.frame >= 128.00000) && (self.frame <= 130.00000))) ) {

      self.fangel_SaveFrame = self.frame;
      fangel_check_wing ( );

   }
};


void  ()fangel_flyother =  {
   AdvanceFrame ( 61.00000, 90.00000);
   fangel_move ( (3.00000 * (fangel_fly_offsets->rint ( ((self.frame - 61.00000) * 0.65000)))));
   if ( (self.frame == 61.00000) ) {

      sound ( self, CHAN_WEAPON, "fangel/fly.wav", 1.00000, ATTN_NORM);

   }
   if ( (((self.frame >= 71.00000) && (self.frame <= 73.00000)) || ((self.frame >= 86.00000) && (self.frame <= 88.00000))) ) {

      self.fangel_SaveFrame = self.frame;
      fangel_check_wing ( );

   }
};


void  ()fangel_flyframes =  {
   self.think = fangel_flyframes;
   AdvanceThinkTime(self,HX_FRAME_TIME);
   fangel_check_incoming ( );
   if ( (self.velocity != '0.00000 0.00000 0.00000') ) {

      self.velocity = (self.velocity * 0.70000);

   }
   if ( (self.monster_stage == FANGEL_STAGE_FLY) ) {

      fangel_flyforward ( );
   } else {

      fangel_flyother ( );

   }
};


void  ()fangel_handframes =  {
   self.think = fangel_handframes;
   AdvanceThinkTime(self,HX_FRAME_TIME);
   fangel_check_incoming ( );
   if ( (AdvanceFrame ( 91.00000, 112.00000) == AF_END) ) {

      fangel_prepare_attack ( );
      if ( (random() < 0.25000) ) {

         self.monster_stage = FANGEL_STAGE_SIDESTEP;
         self.monster_duration = random(20.00000,40.00000);
         fangel_find_spot ( );
         self.think = fangel_flyframes;
      } else {

         self.think = self.th_save;

      }
      self.frame = self.fangel_SaveFrame;
      self.yaw_speed = fangel_move_speed;
   } else {

      if ( (self.frame == 102.00000) ) {

         fangel_hand_fire ( );
      } else {

         fangel_prepare_attack ( );

      }

   }
};


void  ()fangel_painframes =  {
local float chance = 0.00000;
   self.think = fangel_painframes;
   AdvanceThinkTime(self,HX_FRAME_TIME);
   if ( (AdvanceFrame ( 133.00000, 144.00000) == AF_END) ) {

      fangel_check_incoming ( );
      chance = random();
      if ( (chance < 0.33000) ) {

         self.think = self.th_save;
      } else {

         if ( (chance < 0.66000) ) {

            self.think = fangel_handframes;
         } else {

            self.think = fangel_wingframes;

         }

      }
      self.frame = self.fangel_SaveFrame;

   }
};


void  ()fangel_wingframes =  {
local vector org = '0.00000 0.00000 0.00000';
   self.think = fangel_wingframes;
   AdvanceThinkTime(self,HX_FRAME_TIME);
   if ( (AdvanceFrame ( 185.00000, 214.00000) == AF_END) ) {

      fangel_prepare_attack ( );
      if ( (random() < 0.25000) ) {

         self.monster_stage = FANGEL_STAGE_SIDESTEP;
         self.monster_duration = random(20.00000,40.00000);
         fangel_find_spot ( );
         self.think = fangel_flyframes;
      } else {

         self.think = self.th_save;

      }
      self.frame = self.fangel_SaveFrame;
      self.yaw_speed = fangel_move_speed;
   } else {

      if ( (self.classname == "monster_fallen_angel") ) {

         if ( (self.frame == 205.00000) ) {

            if ( (self.shoot_cnt < 3.00000) ) {

               if ( (self.shoot_time < time) ) {

                  fangel_wing_fire ( );
                  self.shoot_cnt += 1.00000;
                  self.shoot_time = (time + (HX_FRAME_TIME * 3.00000));

               }
               self.frame = 204.00000;
            } else {

               self.shoot_cnt = 0.00000;

            }
         } else {

            fangel_prepare_attack ( );

         }
      } else {

         if ( (self.frame == 205.00000) ) {

            if ( (self.shoot_cnt < 10.00000) ) {

               org = (self.origin - '0.00000 0.00000 5.00000');
               traceline ( org, ((self.enemy.absmin + self.enemy.absmax) * 0.50000), TRUE, self);
               if ( (trace_fraction == 1.00000) ) {

                  self.effects |= EF_MUZZLEFLASH;
                  WriteByte ( MSG_BROADCAST, SVC_TEMPENTITY);
                  WriteByte ( MSG_BROADCAST, TE_STREAM_COLORBEAM);
                  WriteEntity ( MSG_BROADCAST, self);
                  WriteByte ( MSG_BROADCAST, 0.00000);
                  WriteByte ( MSG_BROADCAST, 1.00000);
                  WriteByte ( MSG_BROADCAST, rint ( random(0.00000,4.00000)));
                  WriteCoord ( MSG_BROADCAST, org_x);
                  WriteCoord ( MSG_BROADCAST, org_y);
                  WriteCoord ( MSG_BROADCAST, org_z);
                  WriteCoord ( MSG_BROADCAST, trace_endpos_x);
                  WriteCoord ( MSG_BROADCAST, trace_endpos_y);
                  WriteCoord ( MSG_BROADCAST, trace_endpos_z);
                  LightningDamage ( self.origin, trace_endpos, self, 3.00000, "sunbeam");
                  self.frame -= 1.00000;
                  self.shoot_cnt += 1.00000;

               }
               self.frame = 204.00000;
            } else {

               self.shoot_cnt = 0.00000;

            }
         } else {

            fangel_prepare_attack ( );

         }

      }

   }
};


void  (entity attacker,float damage)fangel_pain =  {
   if ( ((random(self.health) > damage) || (self.pain_finished > time)) ) {

      return ;

   }
   self.pain_finished = ((time + 1.00000) + self.skin);
   if ( (self.health < 50.00000) ) {

      self.drawflags ^= (DRF_TRANSLUCENT | MLS_POWERMODE);

   }
   if ( (((self.frame >= 71.00000) && (self.frame <= 73.00000)) || ((self.frame >= 86.00000) && (self.frame <= 88.00000))) ) {

      if ( (self.classname == "monster_fallen_angel") ) {

         sound ( self, CHAN_WEAPON, "fangel/pain.wav", 1.00000, ATTN_NORM);
      } else {

         sound ( self, CHAN_WEAPON, "fangel/pain2.wav", 1.00000, ATTN_NORM);

      }
      self.fangel_SaveFrame = self.frame;
      self.th_save = fangel_flyframes;
      fangel_painframes ( );

   }
};


void  ()init_fangel =  {
   if ( deathmatch ) {

      remove ( self);
      return ;

   }
   self.monster_stage = FANGEL_STAGE_WAIT;
   precache_model2 ( "models/fangel.mdl");
   precache_model2 ( "models/faspell.mdl");
   precache_model2 ( "models/fablade.mdl");
   precache_model2 ( "models/h_fangel.mdl");
   precache_sound2 ( "fangel/fly.wav");
   precache_sound2 ( "fangel/deflect.wav");
   precache_sound2 ( "fangel/hand.wav");
   precache_sound2 ( "fangel/wing.wav");
   CreateEntityNew ( self, ENT_FANGEL, "models/fangel.mdl", fangel_deathframes);
   self.skin = 0.00000;
   self.hull = HULL_BIG;
   if ( (self.classname == "monster_fallen_angel") ) {

      precache_sound2 ( "fangel/ambi1.wav");
      self.skin = 0.00000;
      self.health = 250.00000;
      self.experience_value = 150.00000;
   } else {

      precache_sound2 ( "fangel/ambi2.wav");
      self.skin = 1.00000;
      self.health = 500.00000;
      self.experience_value = 400.00000;

   }
   self.th_stand = fangel_flyframes;
   self.th_walk = fangel_flyframes;
   self.th_run = fangel_flyframes;
   self.th_pain = fangel_pain;
   self.th_die = fangel_deathframes;
   self.th_missile = fangel_handframes;
   self.th_melee = fangel_wingframes;
   self.headmodel = "models/h_fangel.mdl";
   total_monsters += 1.00000;
   self.ideal_yaw = (self.angles * '0.00000 1.00000 0.00000');
   self.yaw_speed = fangel_move_speed;
   self.view_ofs = '0.00000 0.00000 -5.00000';
   self.use = monster_use;
   self.mintel = 3.00000;
   self.flags |= (FL_FLY | FL_MONSTER);
   self.flags2 |= FL_ALIVE;
   if ( (self.classname == "monster_fallen_angel_lord") ) {

      self.drawflags |= DRF_TRANSLUCENT;

   }
   self.pausetime = 100000000.00000;
   self.frame = 91.00000;
   self.think = fangel_wait;
   AdvanceThinkTime(self,0.00000);
};


void  ()monster_fallen_angel =  {
   precache_sound2 ( "fangel/death.wav");
   precache_sound2 ( "fangel/pain.wav");
   init_fangel ( );
};


void  ()monster_fallen_angel_lord =  {
   precache_sound2 ( "fangel/death2.wav");
   precache_sound2 ( "fangel/pain2.wav");
   init_fangel ( );
};


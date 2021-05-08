float MEDUSA_LOOK   =  0.00000;
float MEDUSA_RATTLE   =  1.00000;
float MEDUSA_HEADBUTT   =  2.00000;
float MEDUSA_SNAKES   =  3.00000;
void  (entity attacker,float total_damage)medusa_pain;
void  ()medusa_attack_right;
void  ()medusa_attack_left;
void  ()medusa_attack;
void  (float action)MedusaSelectDir;

void  (string modelstring)medusa_check_use_model =  {
   if ( (self.model != modelstring) ) {

      setmodel ( self, modelstring);
      setsize ( self, '-16.00000 -16.00000 0.00000', '16.00000 16.00000 56.00000');

   }
};


void  ()snake_remove =  {
   particleexplosion ( self.origin, random(176.00000,192.00000), 30.00000, 20.00000);
   remove ( self);
};


void  ()SnakeHit =  {
   if ( ((other == self.owner) || ((other.owner == self.owner) && (other.classname == "snakearrow"))) ) {

      return ;

   }
   starteffect ( CE_MEDUSA_HIT, self.origin);
   sound ( other, CHAN_AUTO, "medusa/hitplayr.wav", 1.00000, ATTN_NORM);
   if ( other.takedamage ) {

      other.bloodloss = (other.bloodloss + 1.00000);
      SpawnPuff ( other.origin, '0.00000 0.00000 0.00000', self.dmg, other);
      T_Damage ( other, self, self.owner, self.dmg);

   }
   snake_remove ( );
};


void  ()snake_fly =  {
   particle4 ( self.origin, 10.00000, (256.00000 + random(176.00000,192.00000)), PARTICLETYPE_GRAV, 3.00000);
   if ( (random() < 0.10000) ) {

      CreateGreenSmoke ( self.origin, '0.00000 0.00000 0.00000', HX_FRAME_TIME);

   }
   HomeThink ( );
   self.think = snake_fly;
   AdvanceThinkTime(self,0.05000);
};


void  (vector offset)FireSnakeArrow =  {
   self.last_attack = time;
   makevectors ( self.angles);
   newmis = spawn ( );
   newmis.owner = self;
   newmis.classname = "snakearrow";
   newmis.movetype = MOVETYPE_FLYMISSILE;
   newmis.solid = SOLID_BBOX;
   newmis.abslight = 0.30000;
   newmis.drawflags |= MLS_ABSLIGHT;
   newmis.speed = 500.00000;
   newmis.o_angle = normalize ( ((self.goalentity.origin + self.goalentity.view_ofs) - ((self.origin + self.view_ofs) + offset)));
   newmis.velocity = (newmis.o_angle * newmis.speed);
   newmis.angles = vectoangles ( newmis.velocity);
   newmis.touch = SnakeHit;
   newmis.dmg = 3.00000;
   newmis.enemy = self.enemy;
   newmis.lockentity = self.enemy;
   newmis.veer = 50.00000;
   newmis.th_die = snake_remove;
   newmis.think = snake_fly;
   newmis.hoverz = TRUE;
   AdvanceThinkTime(newmis,0.00000);
   setmodel ( newmis, "models/snakearr.mdl");
   setsize ( newmis, '0.00000 0.00000 0.00000', '0.00000 0.00000 0.00000');
   setorigin ( newmis, (((self.origin + self.view_ofs) + (v_forward * 8.00000)) + offset));
};


void  ()MedusaAttacks =  {
local vector source = '0.00000 0.00000 0.00000';
local vector org = '0.00000 0.00000 0.00000';
local float damg = 0.00000;
   if ( (self.monster_stage == MEDUSA_SNAKES) ) {

      self.attack_finished = (time + 2.00000);
      sound ( self, CHAN_WEAPON, "medusa/attack2.wav", 1.00000, ATTN_NORM);
      FireSnakeArrow ( (v_up * 12.00000));
      FireSnakeArrow ( (v_right * 12.00000));
      FireSnakeArrow ( (v_right * -12.00000));
   } else {

      self.attack_finished = (time + 1.00000);
      makevectors ( (self.angles + self.angle_ofs));
      source = (self.origin + self.view_ofs);
      traceline ( source, (source + (v_forward * 48.00000)), FALSE, self);
      if ( (trace_fraction == 1.00000) ) {

         return ;

      }
      org = (trace_endpos + (v_forward * 4.00000));
      sound ( self, CHAN_WEAPON, "weapons/gauntht1.wav", 1.00000, ATTN_NORM);
      if ( trace_ent.takedamage ) {

         damg = random(10.00000,18.00000);
         SpawnPuff ( org, '0.00000 0.00000 0.00000', 20.00000, trace_ent);
         T_Damage ( trace_ent, self, self, damg);
      } else {

         SpawnPuff ( trace_endpos, '0.00000 0.00000 0.00000', 20.00000, self);
         medusa_pain ( self, 0.00000);

      }

   }
};


void  ()medusa_attack_left =  {
   AdvanceFrame( 144.00000, 164.00000);
   medusa_check_use_model ( "models/medusa2.mdl");
   if ( (self.frame == 164.00000) ) {

      self.think = self.th_run;
   } else {

      if ( (self.frame == 147.00000) ) {

         MedusaAttacks ( );

      }

   }
};


void  ()medusa_attack_right =  {
   AdvanceFrame( 165.00000, 185.00000);
   medusa_check_use_model ( "models/medusa2.mdl");
   if ( (self.frame == 185.00000) ) {

      self.think = self.th_run;
   } else {

      if ( (self.frame == 168.00000) ) {

         MedusaAttacks ( );

      }

   }
};


void  ()medusa_attack =  {
   AdvanceFrame( 186.00000, 214.00000);
   medusa_check_use_model ( "models/medusa2.mdl");
   if ( (self.frame == 214.00000) ) {

      self.think = self.th_run;
   } else {

      if ( (self.frame == 197.00000) ) {

         MedusaAttacks ( );

      }

   }
};

void  ()MedusaGazeLoop;

void  (vector org,vector destiny,entity loser)MedusaGaze =  {
   AdvanceFrame( 58.00000, 86.00000);
   self.last_attack = time;
   if ( !self.aflag ) {

      sound ( self, CHAN_WEAPON, "medusa/attack1.wav", 1.00000, ATTN_NORM);
      self.aflag = TRUE;

   }
   medusa_check_use_model ( "models/medusa.mdl");
   ai_face ( );
   WriteByte ( MSG_BROADCAST, SVC_TEMPENTITY);
   WriteByte ( MSG_BROADCAST, TE_STREAM_GAZE);
   WriteByte ( MSG_BROADCAST, (1.00000 + STREAM_ATTACHED));
   WriteByte ( MSG_BROADCAST, 4.00000);
   WriteEntity ( MSG_BROADCAST, self);
   WriteCoord ( MSG_BROADCAST, org_x);
   WriteCoord ( MSG_BROADCAST, org_y);
   WriteCoord ( MSG_BROADCAST, org_z);
   WriteCoord ( MSG_BROADCAST, destiny_x);
   WriteCoord ( MSG_BROADCAST, destiny_y);
   WriteCoord ( MSG_BROADCAST, destiny_z);
   if ( ((loser.health <= 10.00000) && !(loser.artifact_active & ART_INVINCIBILITY)) ) {

      sound ( loser, CHAN_BODY, "medusa/stoned.wav", 1.00000, ATTN_NORM);
      self.attack_finished = (time + 7.00000);
      loser.skin = GLOBAL_SKIN_STONE;
      loser.th_run = SUB_Null;
      loser.th_pain = SUB_Null;
      loser.think = SUB_Null;
      loser.pausetime = (time + 1410065408.00000);
      loser.teleport_time = (time + 1410065408.00000);
      loser.attack_finished = (time + 1410065408.00000);
      loser.nextthink = -1.00000;
      loser.th_die = chunk_death;
      loser.thingtype = THINGTYPE_GREYSTONE;
      loser.health = 10.00000;
      loser.touch = obj_push;
      loser.flags ^= FL_FLY;
      loser.flags ^= FL_SWIM;
      if ( (loser.classname != "player") ) {

         loser.movetype = MOVETYPE_STEP;
      } else {

         loser.o_angle = loser.v_angle;

      }
      loser.solid = SOLID_BBOX;
      loser.artifact_active |= ARTFLAG_STONED;
   } else {

      T_Damage ( loser, self, self, 3.00000);
      if ( ((loser.classname == "player") && (random() < ((0.20000 + (skill / 10.00000)) + (self.skin / 5.00000)))) ) {

         loser.o_angle = loser.v_angle;
         loser.pausetime = (time + random(0.05000,0.30000));
         if ( (random() < 0.50000) ) {

            loser.attack_finished = (time + random(0.05000,0.30000));
            if ( (random() < 0.50000) ) {

               AdvanceThinkTime(loser,0.20000);

            }

         }

      }

   }
   if ( (lineofsight ( self, loser) && !(loser.artifact_active & ARTFLAG_STONED)) ) {

      self.goalentity = loser;
      self.think = MedusaGazeLoop;
      AdvanceThinkTime(self,0.10000);
   } else {

      self.aflag = FALSE;
      sound ( self, CHAN_WEAPON, "misc/null.wav", 1.00000, ATTN_NORM);
      self.attack_finished = (time + 2.00000);
      self.think = self.th_run;
      AdvanceThinkTime(self,0.00000);

   }
};


void  ()MedusaGazeLoop =  {
   MedusaGaze ( (self.origin + self.view_ofs), (self.goalentity.origin + self.goalentity.view_ofs), self.goalentity);
};


void  ()MedusaSwipe =  {
   AdvanceFrame( 203.00000, 231.00000);
   self.last_attack = time;
   if ( cycle_wrapped ) {

      self.attack_finished = (time + 1.00000);
      self.think = self.th_run;
      AdvanceThinkTime(self,0.00000);
   } else {

      if ( (self.frame == 203.00000) ) {

         sound ( self, CHAN_VOICE, "medusa/sight.wav", 1.00000, ATTN_NORM);
         sound ( self, CHAN_BODY, "weapons/vorpswng.wav", 1.00000, ATTN_NORM);
      } else {

         if ( ((self.frame >= 208.00000) && (self.frame <= 212.00000)) ) {

            makevectors ( self.angles);
            traceline ( (self.origin + '0.00000 0.00000 23.00000'), (((self.origin + '0.00000 0.00000 23.00000') - (v_forward * 72.00000)) + ((v_right * (209.00000 - self.frame)) * 10.00000)), FALSE, self);
            if ( trace_ent.takedamage ) {

               T_Damage ( trace_ent, self, self, 7.00000);
               sound ( trace_ent, CHAN_BODY, "weapons/met2flsh.wav", 1.00000, ATTN_NORM);
               SpawnPuff ( trace_endpos, '0.00000 0.00000 0.00000', 7.00000, trace_ent);
               trace_ent.velocity += (v_right * -200.00000);
               trace_ent.velocity_z += 100.00000;
               trace_ent.flags ^= FL_ONGROUND;

            }
         } else {

            if ( (self.frame > 212.00000) ) {

               ai_face ( );

            }

         }

      }

   }
};


float  ()MedusaCheckAttack =  {
local vector org = '0.00000 0.00000 0.00000';
local vector dir = '0.00000 0.00000 0.00000';
local vector destiny = '0.00000 0.00000 0.00000';
local float r = 0.00000;
local float loscheck1 = 0.00000;
local float loscheck2 = 0.00000;
   if ( ((random() < ((0.50000 - (skill / 10.00000)) - (self.skin / 5.00000))) || (self.enemy == world)) ) {

      return ( FALSE );

   }
   org = (self.origin + self.view_ofs);
   if ( (time < self.attack_finished) ) {

      return ( FALSE );

   }
   if ( !enemy_vis ) {

      if ( (self.goalentity.classname == "waypoint") ) {

         if ( visible2ent ( self.enemy, self.goalentity) ) {

            MedusaSelectDir ( MEDUSA_SNAKES);
            return ( TRUE );

         }

      }
      return ( FALSE );

   }
   if ( !enemy_infront ) {

      if ( (enemy_range == RANGE_MELEE) ) {

         MedusaSwipe ( );
         return ( TRUE );

      }

   }
   if ( (enemy_range == RANGE_FAR) ) {

      if ( (self.attack_state != AS_STRAIGHT) ) {

         self.attack_state = AS_STRAIGHT;

      }
      return ( FALSE );

   }
   dir = (self.enemy.origin + self.enemy.view_ofs);
   traceline ( org, dir, FALSE, self);
   if ( (trace_ent != self.enemy) ) {

		if ( (self.attack_state != AS_SLIDING) ) {

			 self.attack_state = AS_SLIDING;

      }
      return ( FALSE );
   } else {

		self.attack_state = AS_STRAIGHT;

   }
   destiny = (self.enemy.origin + self.enemy.view_ofs);
   loscheck1 = lineofsight ( self.enemy, self);
   loscheck2 = lineofsight ( self, self.enemy);
   r = random();
   if ( ((!(self.enemy.artifact_active & ARTFLAG_STONED) && loscheck1) && (loscheck2 || ((r < 0.10000) && infront_of_ent ( self, self.enemy)))) ) {

      MedusaGaze ( org, destiny, self.enemy);
      return ( TRUE );

   }
   if ( (enemy_range == RANGE_MELEE) ) {

      MedusaSelectDir ( MEDUSA_HEADBUTT);
      return ( TRUE );
   } else {

      if ( (enemy_range == RANGE_NEAR) ) {

         r = 0.20000;
      } else {

         if ( (enemy_range == RANGE_MID) ) {

            r = 0.30000;

         }

      }

   }
   if ( (random() < r) ) {

      MedusaSelectDir ( MEDUSA_SNAKES);
      return ( TRUE );

   }
   return ( FALSE );
};

void  ()medusa_look_right;

void  ()MedusaHeadTouch =  {
   if ( ((self.velocity != '0.00000 0.00000 0.00000') && !(other.flags2 & FL_ALIVE)) ) {

      sound ( self, CHAN_AUTO, "weapons/hithurt2.wav", 1.00000, ATTN_NORM);

   }
};

void  ()MedusaHeadDying;

void  ()MedusaHeadDead =  {
   AdvanceFrame( 0.00000, 45.00000);
   AdvanceThinkTime(self,0.10000);
   ai_face ( );
   if ( (self.frame == 20.00000) ) {

      sound ( self, CHAN_VOICE, "medusa/sight.wav", 0.50000, ATTN_NORM);
   } else {

      if ( (self.frame == 45.00000) ) {

         self.aflag = TRUE;
         self.think = MedusaHeadDying;

      }

   }
};


void  ()MedusaHeadDying =  {
   AdvanceFrame( 46.00000, 105.00000);
   if ( (self.velocity == '0.00000 0.00000 0.00000') ) {

      if ( !self.aflag ) {

         if ( ((self.angles_x < -10.00000) || (self.angles_x > 10.00000)) ) {

            self.angles_x = 0.00000;

         }
         if ( ((self.angles_z < -10.00000) || (self.angles_z > 10.00000)) ) {

            self.angles_z = 0.00000;

         }
         self.solid = SOLID_BBOX;
         self.think = MedusaHeadDead;
         AdvanceThinkTime(self,0.00000);
      } else {

         if ( (self.frame == 105.00000) ) {

            self.skin = 1.00000;
            self.think = init_corpseblink;
            AdvanceThinkTime(self,5.00000);

         }

      }

   }
};


void  ()MedusaThrowHead =  {
   newmis = spawn ( );
   newmis.owner = self;
   newmis.goalentity = self.enemy;
   newmis.enemy = self.enemy;
   newmis.yaw_speed = 3.00000;
   setmodel ( newmis, self.headmodel);
   self.headmodel = "";
   setsize ( newmis, '-3.00000 -3.00000 -3.00000', '3.00000 3.00000 3.00000');
   setorigin ( newmis, (self.absmax - '0.00000 0.00000 15.00000'));
   newmis.velocity = random('-200.00000 -200.00000 200.00000','200.00000 200.00000 600.00000');
   newmis.movetype = MOVETYPE_BOUNCE;
   if ( (pointcontents ( newmis.origin) == CONTENT_SOLID) ) {

      newmis.solid = SOLID_NOT;
   } else {

      newmis.solid = SOLID_BBOX;

   }
   newmis.takedamage = DAMAGE_YES;
   newmis.thingtype = self.thingtype;
   newmis.th_die = chunk_death;
   newmis.touch = MedusaHeadTouch;
   newmis.health = 25.00000;
   newmis.scale = 2.00000;
   newmis.avelocity_x = random(600.00000);
   newmis.avelocity_y = random(600.00000);
   newmis.avelocity_z = random(600.00000);
   newmis.think = MedusaHeadDying;
   AdvanceThinkTime(newmis,0.00000);
};


void  ()medusa_decap_drop =  {
   AdvanceFrame( 88.00000, 112.00000);
   if ( (self.frame == 96.00000) ) {

      sound ( self, CHAN_BODY, "player/land.wav", 1.00000, ATTN_NORM);
   } else {

      if ( (self.frame == 112.00000) ) {

         MakeSolidCorpse ( );

      }

   }
};


void  ()medusa_decap_loop =  {
   AdvanceFrame( 0.00000, 87.00000);
   if ( (random() < 0.50000) ) {

      self.angles_y += random(-3.00000,3.00000);

   }
   walkmove ( self.angles_y, (self.speed * random()), FALSE);
   if ( (random() < 0.20000) ) {

      sound ( self, CHAN_VOICE, "misc/decomp.wav", 0.30000, ATTN_NORM);
      SpawnPuff ( (self.origin + '0.00000 0.00000 56.00000'), '0.00000 0.00000 35.00000', 5.00000, self);

   }
   if ( (self.frame == 47.00000) ) {

      sound ( self, CHAN_BODY, "medusa/rattle.wav", 1.00000, ATTN_NORM);

   }
   if ( cycle_wrapped ) {

      self.think = medusa_decap_drop;
      AdvanceThinkTime(self,0.00000);

   }
};


void  ()medusa_decap_init =  {
local float throwdist = 0.00000;
   throwdist = self.health;
   ThrowGib ( "models/medsnake.mdl", throwdist);
   ThrowGib ( "models/medsnake.mdl", throwdist);
   ThrowGib ( "models/medsnake.mdl", throwdist);
   sound ( self, CHAN_VOICE, "player/gib2.wav", 1.00000, ATTN_NORM);
   MedusaThrowHead ( );
   SpawnPuff ( (self.origin + '0.00000 0.00000 56.00000'), '0.00000 0.00000 35.00000', 5.00000, self);
   medusa_decap_loop ( );
};


void  ()medusa_die =  {
   AdvanceFrame( 113.00000, 132.00000);
   medusa_check_use_model ( "models/medusa2.mdl");
   if ( self.decap ) {

      medusa_decap_init ( );
   } else {

      if ( (self.health <= -80.00000) ) {

         MedusaThrowHead ( );
         chunk_death ( );
      } else {

         if ( (self.frame == 132.00000) ) {

            MakeSolidCorpse ( );
         } else {

            if ( (self.frame == 113.00000) ) {

               sound ( self, CHAN_VOICE, "medusa/death.wav", 1.00000, ATTN_NORM);

            }

         }

      }

   }
};


void  ()medusa_pain_anim =  {
   AdvanceFrame( 133.00000, 143.00000);
   medusa_check_use_model ( "models/medusa2.mdl");
   if ( cycle_wrapped ) {

      AdvanceThinkTime(self,0.00000);
      self.think = self.th_run;
   } else {

      if ( (self.frame == 133.00000) ) {

         sound ( self, CHAN_VOICE, "medusa/pain.wav", 1.00000, ATTN_NORM);

      }

   }
};


void  (entity attacker,float total_damage)medusa_pain =  {
   if ( (((random() < 0.60000) && (total_damage < 50.00000)) && (attacker != self)) ) {

      return ;

   }
   medusa_pain_anim ( );
};


void  ()medusa_look_left =  {
   AdvanceFrame( 0.00000, 28.00000);
   medusa_check_use_model ( "models/medusa.mdl");
   if ( (self.oldthink == self.th_run) ) {

      ai_run ( self.speed);
   } else {

      if ( (self.oldthink == self.th_stand) ) {

         ai_stand ( );
      } else {

         if ( (self.oldthink == self.th_walk) ) {

            ai_walk ( 5.00000);

         }

      }

   }
   if ( cycle_wrapped ) {

      self.think = self.oldthink;
      if ( (self.think != self.th_run) ) {

         if ( (random() < 0.20000) ) {

            self.think = medusa_look_right;

         }

      }
      AdvanceThinkTime(self,0.00000);

   }
};


void  ()medusa_look_right =  {
   AdvanceFrame( 29.00000, 57.00000);
   medusa_check_use_model ( "models/medusa.mdl");
   if ( (self.oldthink == self.th_run) ) {

      ai_run ( self.speed);
   } else {

      if ( (self.oldthink == self.th_stand) ) {

         ai_stand ( );
      } else {

         if ( (self.oldthink == self.th_walk) ) {

            ai_walk ( 5.00000);

         }

      }

   }
   if ( cycle_wrapped ) {

      self.think = self.oldthink;
      if ( (self.think != self.th_run) ) {

         if ( (random() < 0.20000) ) {

            self.think = medusa_look_left;

         }

      }
      AdvanceThinkTime(self,0.00000);

   }
};


void  ()medusa_rattle_left =  {
   AdvanceFrame( 116.00000, 144.00000);
   medusa_check_use_model ( "models/medusa.mdl");
   if ( cycle_wrapped ) {

      AdvanceThinkTime(self,0.00000);
      self.think = self.th_run;

   }
};


void  ()medusa_rattle_right =  {
   AdvanceFrame( 145.00000, 173.00000);
   medusa_check_use_model ( "models/medusa.mdl");
   if ( cycle_wrapped ) {

      AdvanceThinkTime(self,0.00000);
      self.think = self.th_run;

   }
};


void  ()medusa_rattle =  {
   AdvanceFrame( 87.00000, 115.00000);
   medusa_check_use_model ( "models/medusa.mdl");
   if ( cycle_wrapped ) {

      AdvanceThinkTime(self,0.00000);
      self.think = self.th_run;

   }
};


void  (float action)MedusaSelectDir =  {
local vector enemy_dir = '0.00000 0.00000 0.00000';
local float dot = 0.00000;
   medusa_check_use_model ( "models/medusa.mdl");
   self.monster_stage = action;
   if ( (action >= MEDUSA_HEADBUTT) ) {

      self.last_attack = time;
      sound ( self, CHAN_VOICE, "medusa/hiss.wav", 1.00000, ATTN_NORM);
      medusa_check_use_model ( "models/medusa2.mdl");
   } else {

      if ( (action == MEDUSA_RATTLE) ) {

         sound ( self, CHAN_BODY, "medusa/rattle.wav", 1.00000, ATTN_NORM);

      }

   }
   makevectors ( self.angles);
   enemy_dir = normalize ( (self.enemy.origin - self.origin));
   dot = (v_right * enemy_dir);
   if ( (dot > 0.30000) ) {

      self.angle_ofs_y = -90.00000;
      if ( (action >= MEDUSA_HEADBUTT) ) {

         self.think = medusa_attack_right;
      } else {

         if ( (action == MEDUSA_RATTLE) ) {

            self.think = medusa_rattle_right;
         } else {

            self.think = medusa_look_right;

         }

      }
   } else {

      if ( (dot < -0.30000) ) {

         self.angle_ofs_y = -90.00000;
         if ( (action >= MEDUSA_HEADBUTT) ) {

            self.think = medusa_attack_left;
         } else {

            if ( (action == MEDUSA_RATTLE) ) {

               self.think = medusa_rattle_left;
            } else {

               self.think = medusa_look_left;

            }

         }
      } else {

         self.angle_ofs_y = 0.00000;
         if ( (action >= MEDUSA_HEADBUTT) ) {

            self.think = medusa_attack;
         } else {

            if ( (action == MEDUSA_RATTLE) ) {

               self.think = medusa_rattle;
            } else {

               return ;

            }

         }

      }

   }
   AdvanceThinkTime(self,0.00000);
};


void  ()medusa_hunt =  {
   AdvanceFrame( 58.00000, 86.00000);
   medusa_check_use_model ( "models/medusa.mdl");
   if ( (random() < 0.10000) ) {

      ai_run ( 0.00000);
   } else {

      ai_run ( self.speed);

   }
   if ( !enemy_vis ) {

      if ( ((random() < 0.10000) && (random() < 0.50000)) ) {

         if ( (random() < 0.50000) ) {

            MedusaSelectDir ( MEDUSA_RATTLE);
         } else {

            self.oldthink = self.th_run;
            MedusaSelectDir ( MEDUSA_LOOK);

         }

      }

   }
};


void  ()medusa_walk =  {
   AdvanceFrame( 58.00000, 86.00000);
   medusa_check_use_model ( "models/medusa.mdl");
   self.monster_awake = FALSE;
   if ( (random() < 0.10000) ) {

      ai_walk ( 0.00000);
   } else {

      ai_walk ( 5.00000);

   }
   if ( cycle_wrapped ) {

      if ( (random() < 0.30000) ) {

         self.oldthink = self.th_walk;
         if ( (random() < 0.50000) ) {

            AdvanceThinkTime(self,0.00000);
            self.think = medusa_look_left;
         } else {

            AdvanceThinkTime(self,0.00000);
            self.think = medusa_look_right;

         }

      }

   }
   if ( ((random() < 0.10000) && (random() < 0.50000)) ) {

      sound ( self, CHAN_VOICE, "medusa/hiss.wav", 1.00000, ATTN_NORM);

   }
};


void  ()medusa_stand =  {
   AdvanceFrame( 174.00000, 202.00000);
   medusa_check_use_model ( "models/medusa.mdl");
   self.monster_awake = FALSE;
   ai_stand ( );
   if ( (random() < 0.10000) ) {

      self.oldthink = self.th_stand;
      if ( (random() < 0.50000) ) {

         AdvanceThinkTime(self,0.00000);
         self.think = medusa_look_left;
      } else {

         AdvanceThinkTime(self,0.00000);
         self.think = medusa_look_right;

      }

   }
   if ( ((random() < 0.10000) && (random() < 0.30000)) ) {

      sound ( self, CHAN_VOICE, "medusa/hiss.wav", 1.00000, ATTN_NORM);

   }
};


void  ()monster_medusa_green =  {
   if ( deathmatch ) {

      remove ( self);
      return ;

   }
   precache_model2 ( "models/medusa.mdl");
   precache_model2 ( "models/medusa2.mdl");
   precache_model2 ( "models/snakearr.mdl");
   precache_model2 ( "models/medhit.spr");
   precache_model2 ( "models/medhead.mdl");
   precache_model2 ( "models/medsnake.mdl");
   precache_sound2 ( "medusa/rattle.wav");
   precache_sound2 ( "medusa/hiss.wav");
   precache_sound2 ( "medusa/sight.wav");
   precache_sound2 ( "medusa/attack1.wav");
   precache_sound2 ( "medusa/attack2.wav");
   precache_sound2 ( "medusa/pain.wav");
   precache_sound2 ( "medusa/death.wav");
   precache_sound2 ( "medusa/stoned.wav");
   precache_sound2 ( "medusa/hitplayr.wav");
   self.headmodel = "models/medhead.mdl";
   self.solid = SOLID_SLIDEBOX;
   self.movetype = MOVETYPE_STEP;
   self.takedamage = DAMAGE_YES;
   self.thingtype = THINGTYPE_FLESH;
   self.monsterclass = CLASS_LEADER;
   self.mintel = 20.00000;
   self.mass = 15.00000;
   self.view_ofs = '0.00000 0.00000 53.00000';
   self.speed = 5.00000;
   self.yaw_speed = 5.00000;
   self.classname = "monster_medusa";
   self.health = 700.00000;
   self.experience_value = 500.00000;
   self.th_stand = medusa_stand;
   self.th_run = medusa_hunt;
   self.th_walk = medusa_walk;
   self.th_die = medusa_die;
   self.th_pain = medusa_pain;
   self.th_missile = medusa_rattle;
   self.th_melee = medusa_attack;
   setmodel ( self, "models/medusa.mdl");
   setsize ( self, '-28.00000 -28.00000 0.00000', '28.00000 28.00000 56.00000');
   self.hull = HULL_PLAYER;
   walkmonster_start ( );
};


void  ()monster_medusa =  {
   monster_medusa_green ( );
};


void  ()monster_medusa_red =  {
   monster_medusa_green ( );
   self.health = 250.00000;
   self.experience_value = 125.00000;
};


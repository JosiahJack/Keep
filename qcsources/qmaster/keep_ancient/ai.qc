float RUN_STRAIGHT    = 0.000;

void () movetarget_f;
void () t_movetarget;
void () t_runtarget;
void () knight_walk1;
void () knight_bow6;
void () knight_bow1;
float current_yaw /* = 0.000 */;
entity sight_entity;
float sight_entity_time /* = 0.000 */;
float (float v) anglemod = {

   while ( (v >= 360.000) ) {

      v = (v - 360.000);

   }
   while ( (v < FALSE) ) {

      v = (v + 360.000);

   }
   return ( v );

};

void () movetarget_f = {

   if ( !self.targetname ) {

      objerror ("monster_movetarget: no targetname");

   }
   self.solid = SOLID_TRIGGER;
   self.touch = t_movetarget;
   setsize (self,'-8.000 -8.000 -8.000','8.000 8.000 8.000');

};

void () path_corner = {

   movetarget_f ();

};

void () path_corner_run = {

   if ( !self.targetname ) {

      objerror ("monster_movetarget: no targetname");

   }
   self.solid = SOLID_TRIGGER;
   self.touch = t_runtarget;
   setsize (self,'-8.000 -8.000 -8.000','8.000 8.000 8.000');

};

void () t_movetarget = {

   local entity temp;

   if ( (other.movetarget != self) ) {

      return ;

   }
   if ( other.enemy ) {

      return ;

   }
   temp = self;
   self = other;
   other = temp;
   if ( (self.classname == "monster_ogre") ) {

      sound (self,CHAN_VOICE,"ogre/ogdrag.wav",TRUE,ATTN_IDLE);

   }
   self.movetarget = find (world,targetname,other.target);
   self.goalentity = find (world,targetname,other.target);
   self.ideal_yaw = vectoyaw ((self.goalentity.origin - self.origin));
   if ( !self.movetarget ) {

      self.pausetime = (time + 999999.000);
      self.th_stand ();
      return ;

   }

};
void () t_runtarget = {

   local entity temp;

   if ( (other.movetarget != self) ) {

      return ;

   }
   if ( other.enemy ) {

      return ;

   }
   temp = self;
   self = other;
   other = temp;
   self.movetarget = find (world,targetname,other.target);
   self.goalentity = find (world,targetname,other.target);
   self.ideal_yaw = vectoyaw ((self.goalentity.origin - self.origin));
   if ( !self.movetarget ) {

      self.pausetime = (time + 999999.000);
      self.th_stand ();
      return ;

   }

};
float (entity targ) range = {

   local vector spot1;
   local vector spot2;
   local float r;

   spot1 = (self.origin + self.view_ofs);
   spot2 = (targ.origin + targ.view_ofs);
   r = vlen ((spot1 - spot2));
   if ( (r < 120.000) ) {

      return ( RANGE_MELEE );

   }
   if ( (r < 500.000) ) {

      return ( RANGE_NEAR );

   }
   if ( (r < 1000.000) ) {

      return ( RANGE_MID );

   }
   return ( RANGE_FAR );

};
float (entity targ) visible = {

   local vector spot1;
   local vector spot2;

   spot1 = (self.origin + self.view_ofs);
   spot2 = (targ.origin + targ.view_ofs);
   traceline (spot1,spot2,TRUE,self);
   if ( (trace_inopen && trace_inwater) ) {

      return ( FALSE );

   }
   if ( (trace_fraction == TRUE) ) {

      return ( TRUE );

   }
   return ( FALSE );

};
float (entity targ) infront = {

   local vector vec;
   local float dot;

   makevectors (self.angles);
   vec = normalize ((targ.origin - self.origin));
   dot = (vec * v_forward);
   if ( (dot > 0.300) ) {

      return ( TRUE );

   }
   return ( FALSE );

};

void () HuntTarget = {

   self.goalentity = self.enemy;
   self.think = self.th_run;
   self.ideal_yaw = vectoyaw ((self.enemy.origin - self.origin));
   self.nextthink = (time + 0.100);
   SUB_AttackFinished (TRUE);

};

void () SightSound = {

   local float rsnd;

   if ( (self.classname == "monster_ogre") ) {

      sound (self,CHAN_VOICE,"ogre/ogwake.wav",TRUE,ATTN_NORM);

   } else {

      if ( (self.classname == "monster_knight") ) {

         sound (self,CHAN_VOICE,"knight/ksight.wav",TRUE,ATTN_NORM);

      } else {

         if ( (self.classname == "monster_shambler") ) {

            sound (self,CHAN_VOICE,"shambler/ssight.wav",TRUE,ATTN_NORM);

         } else {

            if ( (self.classname == "monster_demon1") ) {

               sound (self,CHAN_VOICE,"demon/sight2.wav",TRUE,ATTN_NORM);

            } else {

               if ( (self.classname == "monster_wizard") ) {

                  sound (self,CHAN_VOICE,"wizard/wsight.wav",TRUE,ATTN_NORM);

               } else {

                  if ( (self.classname == "monster_zombie") ) {

                     sound (self,CHAN_VOICE,"zombie/z_idle.wav",TRUE,ATTN_NORM);

                  } else {

                     if ( (self.classname == "monster_dog") ) {

                        sound (self,CHAN_VOICE,"dog/dsight.wav",TRUE,ATTN_NORM);

                     } else {

                        if ( (self.classname == "monster_hell_knight") ) {

                           sound (self,CHAN_VOICE,"hknight/sight1.wav",TRUE,ATTN_NORM);

                        } else {

                           if ( (self.classname == "monster_tarbaby") ) {

                              sound (self,CHAN_VOICE,"blob/sight1.wav",TRUE,ATTN_NORM);

                           } else {

                              if ( (self.classname == "monster_vomit") ) {

                                 sound (self,CHAN_VOICE,"vomitus/v_sight1.wav",TRUE,ATTN_NORM);

                              } else {

                                 if ( (self.classname == "monster_enforcer") ) {

                                    rsnd = rint ((random () * MOVETYPE_WALK));
                                    if ( (rsnd == TRUE) ) {

                                       sound (self,CHAN_VOICE,"enforcer/sight1.wav",TRUE,ATTN_NORM);

                                    } else {

                                       if ( (rsnd == FL_SWIM) ) {

                                          sound (self,CHAN_VOICE,"enforcer/sight2.wav",TRUE,ATTN_NORM);

                                       } else {

                                          if ( (rsnd == FALSE) ) {

                                             sound (self,CHAN_VOICE,"enforcer/sight3.wav",TRUE,ATTN_NORM);

                                          } else {

                                             sound (self,CHAN_VOICE,"enforcer/sight4.wav",TRUE,ATTN_NORM);

                                          }

                                       }

                                    }

                                 } else {

                                    if ( (self.classname == "monster_army") ) {

                                       sound (self,CHAN_VOICE,"soldier/sight1.wav",TRUE,ATTN_NORM);

                                    } else {

                                       if ( (self.classname == "monster_shalrath") ) {

                                          sound (self,CHAN_VOICE,"shalrath/sight.wav",TRUE,ATTN_NORM);

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

};

void () FoundTarget = {

   if ( (self.enemy.classname == "player") ) {

      sight_entity = self;
      sight_entity_time = time;

   }
   self.show_hostile = (time + TRUE);
   SightSound ();
   HuntTarget ();

};
float () FindTarget = {

   local entity client;
   local float r;

   if ( ((sight_entity_time >= (time - 0.100)) && !(self.spawnflags & MOVETYPE_WALK)) ) {

      client = sight_entity;
      if ( (client.enemy == self.enemy) ) {

         return ;

      }

   } else {

      client = checkclient ();
      if ( !client ) {

         return ( FALSE );

      }

   }
   if ( (client == self.enemy) ) {

      return ( FALSE );

   }
   if ( (client.flags & FL_NOTARGET) ) {

      return ( FALSE );

   }
   if ( (client.items & IT_INVISIBILITY) ) {

      return ( FALSE );

   }
   r = range (client);
   if ( (r == RANGE_FAR) ) {

      return ( FALSE );

   }
   if ( !visible (client) ) {

      return ( FALSE );

   }
   if ( (r == RANGE_NEAR) ) {

      if ( ((client.show_hostile < time) && !infront (client)) ) {

         return ( FALSE );

      }

   } else {

      if ( (r == RANGE_MID) ) {

         if ( !infront (client) ) {

            return ( FALSE );

         }

      }

   }
   self.enemy = client;
   if ( (self.enemy.classname != "player") ) {

      self.enemy = self.enemy.enemy;
      if ( (self.enemy.classname != "player") ) {

         self.enemy = world;
         return ( FALSE );

      }

   }
   FoundTarget ();
   return ( TRUE );

};

void (float dist) ai_forward = {

   walkmove (self.angles_y,dist);

};

void (float dist) ai_back = {

   walkmove ((self.angles_y + 180.000),dist);

};

void (float dist) ai_pain = {

   ai_back (dist);

};

void (float dist) ai_painforward = {

   walkmove (self.ideal_yaw,dist);

};

void (float dist) ai_walk = {

   local vector mtemp;

   movedist = dist;
   if ( (self.classname == "monster_dragon") ) {

      movetogoal (dist);
      return ;

   }
   if ( FindTarget () ) {

      return ;

   }
   movetogoal (dist);

};

void () ai_stand = {

   if ( FindTarget () ) {

      return ;

   }
   if ( (time > self.pausetime) ) {

      self.th_walk ();
      return ;

   }

};

void () ai_turn = {

   if ( FindTarget () ) {

      return ;

   }
   ChangeYaw ();

};

void (vector dest3) ChooseTurn = {

   local vector dir;
   local vector newdir;

   dir = (self.origin - dest3);
   newdir_x = trace_plane_normal_y;
   newdir_y = (FALSE - trace_plane_normal_x);
   newdir_z = FALSE;
   if ( ((dir * newdir) > FALSE) ) {

      dir_x = (FALSE - trace_plane_normal_y);
      dir_y = trace_plane_normal_x;

   } else {

      dir_x = trace_plane_normal_y;
      dir_y = (FALSE - trace_plane_normal_x);

   }
   dir_z = FALSE;
   self.ideal_yaw = vectoyaw (dir);

};
float () FacingIdeal = {

   local float delta;

   delta = anglemod ((self.angles_y - self.ideal_yaw));
   if ( ((delta > 45.000) && (delta < 315.000)) ) {

      return ( FALSE );

   }
   return ( TRUE );

};
float () WizardCheckAttack;
float () DogCheckAttack;
float () CheckAnyAttack = {

   if ( !enemy_vis ) {

      return ;

   }
   if ( (self.classname == "monster_army") ) {

      return ( SoldierCheckAttack () );

   }
   if ( (self.classname == "monster_ogre") ) {

      return ( OgreCheckAttack () );

   }
   if ( (self.classname == "monster_shambler") ) {

      return ( ShamCheckAttack () );

   }
   if ( (self.classname == "monster_demon1") ) {

      return ( DemonCheckAttack () );

   }
   if ( (self.classname == "monster_dog") ) {

      return ( DogCheckAttack () );

   }
   if ( (self.classname == "monster_wizard") ) {

      return ( WizardCheckAttack () );

   }
   return ( CheckAttack () );

};

void () ai_run_melee = {

   self.ideal_yaw = enemy_yaw;
   ChangeYaw ();
   if ( FacingIdeal () ) {

      self.th_melee ();
      self.attack_state = AS_STRAIGHT;

   }

};

void () ai_run_missile = {

   self.ideal_yaw = enemy_yaw;
   ChangeYaw ();
   if ( FacingIdeal () ) {

      self.th_missile ();
      self.attack_state = AS_STRAIGHT;

   }

};

void () ai_run_slide = {

   local float ofs;

   self.ideal_yaw = enemy_yaw;
   ChangeYaw ();
   if ( self.lefty ) {

      ofs = 90.000;

   } else {

      ofs = -90.000;

   }
   if ( walkmove ((self.ideal_yaw + ofs),movedist) ) {

      return ;

   }
   self.lefty = (TRUE - self.lefty);
   walkmove ((self.ideal_yaw - ofs),movedist);

};

void (float dist) ai_run = {

   local vector delta;
   local float axis;
   local float direct;
   local float ang_rint;
   local float ang_floor;
   local float ang_ceil;

   movedist = dist;
   if ( (self.enemy.health <= FALSE) ) {

      self.enemy = world;
      if ( (self.oldenemy.health > FALSE) ) {

         self.enemy = self.oldenemy;
         HuntTarget ();

      } else {

         if ( self.movetarget ) {

            self.th_walk ();

         } else {

            self.th_stand ();

         }
         return ;

      }

   }
   self.show_hostile = (time + TRUE);
   enemy_vis = visible (self.enemy);
   if ( enemy_vis ) {

      self.search_time = (time + MOVETYPE_FLY);

   }
   if ( (coop && (self.search_time < time)) ) {

      if ( FindTarget () ) {

         return ;

      }

   }
   enemy_infront = infront (self.enemy);
   enemy_range = range (self.enemy);
   enemy_yaw = vectoyaw ((self.enemy.origin - self.origin));
   if ( (self.attack_state == AS_MISSILE) ) {

      ai_run_missile ();
      return ;

   }
   if ( (self.attack_state == AS_MELEE) ) {

      ai_run_melee ();
      return ;

   }
   if ( CheckAnyAttack () ) {

      return ;

   }
   if ( (self.attack_state == AS_SLIDING) ) {

      ai_run_slide ();
      return ;

   }
   movetogoal (dist);

};

void () ai_turn_in_place = {

   local float delta;

   self.nextthink = (time + 0.100);
   enemy_yaw = vectoyaw ((self.enemy.origin - self.origin));
   delta = fabs ((self.angles_y - enemy_yaw));
   if ( (delta > MIN_ANGLE_DELTA) ) {

      self.ideal_yaw = enemy_yaw;
      ChangeYaw ();

   } else {

      self.think = self.th_run;

   }

};
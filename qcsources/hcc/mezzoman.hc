void  ()mezzo_skid;
void  ()mezzo_block;
void  ()mezzo_block_wait;
void  ()mezzo_jump;
void  ()mezzo_roar;
void  ()mezzo_in_air;
void  ()mezzo_run_loop;
void  ()mezzo_charge;

void  ()mezzo_idle_sound =  {
local string soundstr;
   if ( (random() < 0.50000) ) {

      soundstr = "mezzo/snort.wav";
   } else {

      soundstr = "mezzo/growl.wav";

   }
   sound ( self, CHAN_VOICE, soundstr, 1.00000, ATTN_NORM);
};


void  ()mezzo_roll_right =  {
local vector rollangle = '0.00000 0.00000 0.00000';
   AdvanceFrame( 157.00000, 140.00000);
   makevectors ( self.angles);
   rollangle = vectoangles ( v_right);
   walkmove ( rollangle_y, 7.00000, FALSE);
   if ( cycle_wrapped ) {

      AdvanceThinkTime(self,0.00000);
      if ( !(self.flags & FL_ONGROUND) ) {

         self.think = mezzo_in_air;
      } else {

         self.think = self.th_run;

      }

   }
};


void  ()mezzo_roll_left =  {
local vector rollangle = '0.00000 0.00000 0.00000';
   AdvanceFrame( 140.00000, 157.00000);
   makevectors ( self.angles);
   rollangle = vectoangles ( v_right);
   walkmove ( rollangle_y, -7.00000, FALSE);
   if ( cycle_wrapped ) {

      AdvanceThinkTime(self,0.00000);
      if ( !(self.flags & FL_ONGROUND) ) {

         self.think = mezzo_in_air;
      } else {

         self.think = self.th_run;

      }

   }
};


void  ()mezzo_roll_forward =  {
   AdvanceFrame( 63.00000, 80.00000);
   if ( !(self.flags & FL_ONGROUND) ) {

      if ( !infront ( self.enemy) ) {

         ai_face ( );

      }
   } else {

      if ( self.dflags ) {

         sound ( self, CHAN_BODY, "player/land.wav", 1.00000, ATTN_NORM);
         self.dflags = FALSE;

      }
      walkmove ( self.angles_y, 7.00000, FALSE);

   }
   if ( cycle_wrapped ) {

      AdvanceThinkTime(self,0.00000);
      if ( !(self.flags & FL_ONGROUND) ) {

         self.think = mezzo_in_air;
      } else {

         self.think = self.th_run;

      }

   }
};


void  ()mezzo_duck =  {
local vector newmaxs = '0.00000 0.00000 0.00000';
   AdvanceFrame( 93.00000, 102.00000);
   if ( (self.frame == 94.00000) ) {

      newmaxs = self.maxs;
      newmaxs_z = (self.maxs_z * 0.50000);
      setsize ( self, self.mins, newmaxs);
   } else {

      if ( (self.frame == 98.00000) ) {

         newmaxs = self.maxs;
         newmaxs_z = (self.maxs_z * 2.00000);
         setsize ( self, self.mins, newmaxs);
      } else {

         if ( (self.frame == 96.00000) ) {

            AdvanceThinkTime(self,0.50000);
         } else {

            if ( cycle_wrapped ) {

               AdvanceThinkTime(self,0.00000);
               self.think = self.th_run;

            }

         }

      }

   }
};


float  (entity proj)mezzo_check_duck =  {
local vector proj_mins = '0.00000 0.00000 0.00000';
local vector duck_hite = '0.00000 0.00000 0.00000';
local vector proj_dir = '0.00000 0.00000 0.00000';
   proj_mins = proj.origin;
   proj_mins_z = (proj.origin_z - proj.mins_z);
   duck_hite = self.origin;
   duck_hite_z = (self.origin_z + (self.maxs_z / 2.00000));
   proj_dir = normalize ( (duck_hite - proj_mins));
   traceline ( proj_mins, (duck_hite + (proj_dir * 8.00000)), FALSE, self);
   if ( ((trace_ent != self) || (trace_endpos_z > duck_hite_z)) ) {

      return ( TRUE );
   } else {

      return ( FALSE );

   }
};


float  (entity proj)mezzo_check_jump =  {
local float impact_hite = 0.00000;
local float jump_hite = 0.00000;
local vector proj_dir = '0.00000 0.00000 0.00000';
local vector proj_top = '0.00000 0.00000 0.00000';
   if ( !(self.flags & FL_ONGROUND) ) {

      return ( FALSE );

   }
   proj_dir = normalize ( proj.velocity);
   proj_top = proj.origin;
   proj_top_z = proj.absmax_z;
   traceline ( proj_top, (proj_top + (proj_dir * 1000.00000)), FALSE, proj);
   if ( (trace_ent != self) ) {

      return ( FALSE );

   }
   impact_hite = trace_endpos_z;
   tracearea ( self.origin, (self.origin + '0.00000 0.00000 256.00000'), self.mins, self.maxs, FALSE, self);
   jump_hite = (trace_fraction * 256.00000);
   if ( (jump_hite < 24.00000) ) {

      return ( FALSE );
   } else {

      if ( (jump_hite > 133.00000) ) {

         jump_hite = 133.00000;
      } else {

         if ( (jump_hite < 77.00000) ) {

            jump_hite = 77.00000;

         }

      }

   }
   if ( (((self.origin_z + (jump_hite / 2.00000)) > (impact_hite + proj.maxs_z)) && (random() < 0.70000)) ) {

      self.velocity_z = (jump_hite * 3.00000);
      self.flags ^= FL_ONGROUND;
      return ( TRUE );

   }
   return ( FALSE );
};


void  (entity proj)mezzo_choose_roll =  {
local float proj_dir = 0.00000;
   proj_dir = check_heading_left_or_right ( proj);
   if ( (proj_dir == 0.00000) ) {

      if ( mezzo_check_duck ( proj) ) {

         AdvanceThinkTime(self,0.00000);
         self.think = mezzo_duck;
      } else {

         AdvanceThinkTime(self,0.00000);
         self.think = mezzo_block;

      }
      return ;
   } else {

      makevectors ( self.angles);
      if ( solid_under ( self.origin, (self.origin + ((v_right * 105.00000) * proj_dir))) ) {

         tracearea ( self.origin, (self.origin + ((v_right * 105.00000) * proj_dir)), self.mins, self.maxs, FALSE, self);
      } else {

         trace_fraction = FALSE;

      }
      if ( (trace_fraction == 1.00000) ) {

         traceline ( trace_endpos, (trace_endpos - '0.00000 0.00000 300.00000'), TRUE, self);
         if ( (pointcontents ( trace_endpos) != CONTENT_EMPTY) ) {

            trace_fraction = FALSE;
         } else {

            trace_fraction = TRUE;

         }

      }
      if ( (trace_fraction == 1.00000) ) {

         if ( (proj_dir > 0.00000) ) {

            AdvanceThinkTime(self,0.00000);
            self.think = mezzo_roll_right;
         } else {

            AdvanceThinkTime(self,0.00000);
            self.think = mezzo_roll_left;

         }
         return ;
      } else {

         if ( mezzo_check_duck ( proj) ) {

            AdvanceThinkTime(self,0.00000);
            self.think = mezzo_duck;
         } else {

            AdvanceThinkTime(self,0.00000);
            self.think = mezzo_block;

         }

      }

   }
};


void  ()mezzo_check_defense =  {
local entity enemy_proj;
local float r = 0.00000;
local vector enemy_dir = '0.00000 0.00000 0.00000';
   if ( ((skill + (self.skin / 5.00000)) < random(6.00000)) ) {

      return ;

   }
   if ( ((((self.enemy.last_attack + 0.50000) < time) && ((self.oldenemy.last_attack + 0.50000) < time)) || self.aflag) ) {

      return ;

   }
   enemy_proj = look_projectiles ( );
   if ( !enemy_proj ) {

      if ( lineofsight ( self, self.enemy) ) {

         enemy_proj = self.enemy;
         self.level = (vlen ( (self.enemy.origin - self.origin)) / 1000.00000);
      } else {

         return ;

      }

   }
   if ( (self.flags & FL_ONGROUND) ) {

      self.velocity = '0.00000 0.00000 0.00000';

   }
   r = range ( enemy_proj);
   if ( ((self.enemy.weapon == IT_WEAPON1) && (r <= RANGE_NEAR)) ) {

      AdvanceThinkTime(self,0.00000);
      if ( (r == RANGE_MELEE) ) {

         if ( ((random() < 0.70000) || (self.enemy.v_angle_x >= 0.00000)) ) {

            self.think = mezzo_duck;
         } else {

            if ( (self.think == mezzo_block_wait) ) {

               self.t_width = (time + 1.00000);
               return ;
            } else {

               if ( ((self.think == mezzo_run_loop) || (random() < 0.30000)) ) {

                  self.think = mezzo_charge;
               } else {

                  self.think = mezzo_block;

               }

            }

         }
         return ;
      } else {

         if ( (random() < 0.50000) ) {

            mezzo_choose_roll ( enemy_proj);
         } else {

            if ( ((random() < 0.70000) || (self.enemy.v_angle_x >= 0.00000)) ) {

               self.think = mezzo_duck;
            } else {

               if ( (self.think == mezzo_block_wait) ) {

                  self.t_width = (time + 1.00000);
                  return ;
               } else {

                  if ( (self.think == mezzo_block_wait) ) {

                     self.t_width = (time + 1.00000);
                     return ;
                  } else {

                     if ( ((self.think == mezzo_run_loop) || (random() < 0.30000)) ) {

                        self.think = mezzo_charge;
                     } else {

                        self.think = mezzo_block;

                     }

                  }

               }

            }

         }

      }
      return ;

   }
   if ( (self.level > 0.30000) ) {

      mezzo_choose_roll ( enemy_proj);
      return ;
   } else {

      if ( mezzo_check_duck ( enemy_proj) ) {

         AdvanceThinkTime(self,0.00000);
         tracearea ( self.origin, (self.origin + (v_forward * 64.00000)), self.mins, '16.00000 16.00000 20.00000', FALSE, self);
         if ( (((trace_fraction < 1.00000) || (random() < 0.20000)) || !infront ( enemy_proj)) ) {

            self.think = mezzo_duck;
         } else {

            self.think = mezzo_roll_forward;

         }
         return ;
      } else {

         if ( mezzo_check_jump ( enemy_proj) ) {

            self.think = mezzo_jump;
            enemy_infront = infront ( self.enemy);
            enemy_vis = visible ( self.enemy);
            trace_fraction = 0.00000;
            if ( (((((random() < 0.30000) || (self.think == mezzo_run_loop)) && enemy_infront) && enemy_vis) && (self.enemy != world)) ) {

               enemy_dir = normalize ( (self.enemy.origin - self.origin));
               traceline ( self.origin, ((self.origin + (enemy_dir * 64.00000)) + '0.00000 0.00000 56.00000'), FALSE, self);
               if ( (trace_fraction == 1.00000) ) {

                  traceline ( trace_endpos, (trace_endpos - '0.00000 0.00000 300.00000'), TRUE, self);
                  if ( (pointcontents ( trace_endpos) == CONTENT_EMPTY) ) {

                     self.velocity_y = 0.00000;
                     self.velocity_x = 0.00000;
                     self.velocity += (enemy_dir * vlen ( (self.enemy.origin - self.origin)));
                     trace_fraction = 1.00000;
                     if ( (random() < 0.70000) ) {

                        self.think = mezzo_roll_forward;
                     } else {

                        self.think = self.th_jump;

                     }
                  } else {

                     trace_fraction = 0.00000;

                  }
               } else {

                  trace_fraction = 0.00000;

               }

            }
            if ( ((random() < 0.50000) && (trace_fraction < 1.00000)) ) {

               if ( (random() < 0.50000) ) {

                  r = 1.00000;
               } else {

                  r = -1.00000;

               }
               makevectors ( self.angles);
               traceline ( self.origin, ((self.origin + ((v_right * 36.00000) * r)) + '0.00000 0.00000 56.00000'), FALSE, self);
               if ( (trace_fraction < 1.00000) ) {

                  traceline ( self.origin, ((self.origin - ((v_right * 36.00000) * r)) + '0.00000 0.00000 56.00000'), FALSE, self);
                  if ( (trace_fraction < 1.00000) ) {

                     self.think = mezzo_jump;
                  } else {

                     traceline ( trace_endpos, (trace_endpos - '0.00000 0.00000 300.00000'), TRUE, self);
                     if ( (pointcontents ( trace_endpos) != CONTENT_EMPTY) ) {

                        self.think = mezzo_jump;
                     } else {

                        self.velocity -= ((v_right * r) * 200.00000);
                        if ( ((r * -1.00000) > 0.00000) ) {

                           self.think = mezzo_roll_right;
                        } else {

                           self.think = mezzo_roll_left;

                        }

                     }

                  }
               } else {

                  traceline ( trace_endpos, (trace_endpos - '0.00000 0.00000 300.00000'), TRUE, self);
                  if ( (pointcontents ( trace_endpos) != CONTENT_EMPTY) ) {

                     self.think = mezzo_jump;
                  } else {

                     self.velocity += ((v_right * r) * 200.00000);
                     if ( (r > 0.00000) ) {

                        self.think = mezzo_roll_right;
                     } else {

                        self.think = mezzo_roll_left;

                     }

                  }

               }

            }
            AdvanceThinkTime(self,0.00000);
            if ( ((((self.think != mezzo_jump) && (self.think != mezzo_roll_right)) && (self.think != mezzo_roll_left)) && (self.think != mezzo_roll_forward)) ) {

               self.think = mezzo_jump;

            }
         } else {

            infront ( enemy_proj);
            if ( (random() && (random() < 0.50000)) ) {

               AdvanceThinkTime(self,0.00000);
               if ( (self.think == mezzo_block_wait) ) {

                  self.t_width = (time + 1.00000);
                  return ;
               } else {

                  if ( ((self.think == mezzo_run_loop) || (random() < 0.30000)) ) {

                     self.think = mezzo_charge;
                  } else {

                     self.think = mezzo_block;

                  }

               }
               return ;

            }

         }

      }

   }
};

void  ()mezzo_charge_stop;

void  ()mezzo_slam =  {
local float inertia = 0.00000;
local vector punchdir = '0.00000 0.00000 0.00000';
   if ( ((!other.movetype || (other.mass > 100.00000)) || (other.solid == SOLID_BSP)) ) {

      return ;

   }
   if ( (!infront ( other) || (other.safe_time > time)) ) {

      return ;

   }
   if ( ((other.origin_z > (self.absmax_z - 6.00000)) || (other.absmax_z < (self.origin_z + 6.00000))) ) {

      return ;

   }
   sound ( self, CHAN_VOICE, "mezzo/slam.wav", 1.00000, ATTN_NORM);
   if ( (other.mass < 10.00000) ) {

      inertia = 1.00000;
   } else {

      inertia = (other.mass / 10.00000);

   }
   makevectors ( self.angles);
   punchdir = ((v_forward * 300.00000) + '0.00000 0.00000 100.00000');
   T_Damage ( other, self, self, (((5.00000 * (self.skin + 1.00000)) * (self.aflag + 1.00000)) * (coop + 1.00000)));
   other.velocity += (punchdir * (1.00000 / inertia));
   other.flags ^= FL_ONGROUND;
   self.ltime += 1.00000;
   other.safe_time = (time + 1.25000);
   if ( (self.think != mezzo_charge_stop) ) {

      AdvanceThinkTime(self,0.00000);
      self.think = mezzo_charge_stop;

   }
};


void  ()mezzo_reflect_trig_touch =  {
local vector org = '0.00000 0.00000 0.00000';
local vector vec = '0.00000 0.00000 0.00000';
local vector dir = '0.00000 0.00000 0.00000';
local float magnitude = 0.00000;
   if ( ((((other.flags & FL_MONSTER) || (other.flags & FL_CLIENT)) || !other) || (other == self)) ) {

      return ;

   }
   if ( (other.safe_time > time) ) {

      return ;

   }
   if ( (!(self.owner.flags2 & FL_ALIVE) || (self.owner.frozen > 0.00000)) ) {

      if ( (self.owner.movechain == self) ) {

         self.owner.movechain = world;

      }
      remove ( self);

   }
   dir = normalize ( other.velocity);
   magnitude = vlen ( other.velocity);
   org = other.origin;
   vec = (org + (dir * 100.00000));
   traceline ( org, vec, FALSE, other);
   if ( (trace_ent != self.owner) ) {

      return ;

   }
   if ( (self.owner.classname == "monster_mezzoman") ) {

      sound ( self, CHAN_AUTO, "mezzo/slam.wav", 1.00000, ATTN_NORM);

   }
   if ( (!self.owner.skin && (self.owner.classname == "monster_mezzoman")) ) {

      if ( !(other.flags2 & FL_ALIVE) ) {

         other.flags2 |= FL_NODAMAGE;

      }
   } else {

      if ( (self.owner.classname != "monster_mezzoman") ) {

         sound ( self, CHAN_WEAPON, "fangel/deflect.wav", 1.00000, ATTN_NORM);
         CreateWhiteFlash ( trace_endpos);
         if ( (self.owner.classname == "monster_fallen_angel") ) {

            dir = (dir * -1.00000);
            makevectors ( dir);
            dir = ((v_forward + (v_up * random(-0.75000,0.75000))) + (v_right * random(-0.75000,0.75000)));
            dir = normalize ( dir);
         } else {

            v_forward = normalize ( ((other.owner.origin + other.owner.view_ofs) - other.origin));
            dir += (2.00000 * v_forward);
            dir = normalize ( dir);

         }
      } else {

         sound ( self, CHAN_AUTO, "mezzo/reflect.wav", 1.00000, ATTN_NORM);
         starteffect ( CE_MEZZO_REFLECT, self.origin);
         makevectors ( trace_ent.angles);
         dir += (2.00000 * v_forward);
         dir = normalize ( dir);

      }
      if ( other.movedir ) {

         other.movedir = dir;

      }
      if ( other.o_angle ) {

         other.o_angle = dir;

      }
      if ( (magnitude < other.speed) ) {

         magnitude = other.speed;

      }
      other.velocity = (dir * magnitude);
      other.angles = vectoangles ( other.velocity);
      self.owner.last_attack = time;
      other.safe_time = (time + (100.00000 / magnitude));
      if ( !other.controller ) {

         other.controller = other.owner;

      }
      if ( (other.enemy == self.owner) ) {

         other.enemy = other.owner;

      }
      if ( (other.goalentity == self.owner) ) {

         other.goalentity = other.owner;

      }
      other.owner = self.owner;

   }
};


void  ()reflect_think =  {
   makevectors ( self.owner.angles);
   setorigin ( self, ((self.owner.origin + (v_forward * 48.00000)) + '0.00000 0.00000 40.00000'));
   self.think = reflect_think;
   AdvanceThinkTime(self,0.05000);
};


void  ()spawn_reflect =  {
   makevectors ( self.angles);
   newmis = spawn ( );
   self.shield = newmis;
   newmis.movetype = MOVETYPE_NOCLIP;
   newmis.solid = SOLID_TRIGGER;
   newmis.owner = self;
   newmis.touch = mezzo_reflect_trig_touch;
   newmis.classname = "mezzo_reflect";
   newmis.effects = EF_NODRAW;
   setmodel ( newmis, "models/null.spr");
   if ( (self.classname == "monster_mezzoman") ) {

      setsize ( newmis, '-32.00000 -32.00000 -10.00000', '32.00000 32.00000 30.00000');
      setorigin ( newmis, ((self.origin + (v_forward * 48.00000)) + '0.00000 0.00000 40.00000'));
      newmis.think = reflect_think;
      AdvanceThinkTime(newmis,0.00000);
   } else {

      self.movechain = newmis;
      setsize ( newmis, '-48.00000 -48.00000 -64.00000', '48.00000 48.00000 50.00000');
      setorigin ( newmis, self.origin);

   }
};


void  ()mezzo_clobber =  {
   AdvanceFrame( 31.00000, 46.00000);
   ai_charge ( 1.00000);
   if ( (self.frame == 37.00000) ) {

      makevectors ( self.angles);
      traceline ( (self.origin + '0.00000 0.00000 30.00000'), ((self.origin + '0.00000 0.00000 30.00000') + (v_forward * 36.00000)), FALSE, self);
      if ( (trace_fraction == 1.00000) ) {

         return ;

      }
      sound ( self, CHAN_VOICE, "mezzo/slam.wav", 1.00000, ATTN_NORM);
      if ( (trace_ent.movetype && (trace_ent.movetype != MOVETYPE_PUSH)) ) {

         trace_ent.velocity += (((v_forward * 200.00000) - (v_right * 100.00000)) + '0.00000 0.00000 100.00000');

      }
      if ( trace_ent.takedamage ) {

         T_Damage ( trace_ent, self, self, (((5.00000 * (self.skin + 1.00000)) * (self.aflag + 1.00000)) * (coop + 1.00000)));

      }
      if ( (trace_ent.classname == "player") ) {

         if ( infront_of_ent ( self, trace_ent) ) {

            trace_ent.punchangle_y = 4.00000;

         }

      }
   } else {

      if ( cycle_wrapped ) {

         self.attack_finished = (time + 0.50000);
         AdvanceThinkTime(self,0.00000);
         self.think = self.th_run;
      } else {

         if ( (self.frame == 31.00000) ) {

            self.last_attack = time;
            if ( (random() < 0.50000) ) {

               sound ( self, CHAN_VOICE, "mezzo/attack.wav", 1.00000, ATTN_NORM);

            }

         }

      }

   }
};


void  ()mezzo_sword =  {
local float ofs = 0.00000;
local vector dir = '0.00000 0.00000 0.00000';
   AdvanceFrame( 190.00000, 202.00000);
   ai_face ( );
   ai_charge ( 3.00000);
   if ( cycle_wrapped ) {

      self.attack_finished = (time + 0.30000);
      AdvanceThinkTime(self,0.00000);
      self.think = self.th_run;
   } else {

      if ( (self.frame == 190.00000) ) {

         self.last_attack = time;
         sound ( self, CHAN_WEAPON, "weapons/vorpswng.wav", 1.00000, ATTN_NORM);
         if ( (random() < 0.50000) ) {

            sound ( self, CHAN_VOICE, "mezzo/attack.wav", 1.00000, ATTN_NORM);

         }
      } else {

         if ( ((self.frame >= 195.00000) && (self.frame <= 199.00000)) ) {

            makevectors ( self.angles);
            ofs = ((199.00000 - self.frame) * 4.00000);
            dir_z = (ofs - 8.00000);
            dir += ((v_right * (ofs - 8.00000)) + (v_forward * (48.00000 - fabs ( (16.00000 - ofs)))));
            dir = normalize ( dir);
            traceline ( (self.origin + '0.00000 0.00000 37.00000'), ((self.origin + '0.00000 0.00000 37.00000') + (dir * 48.00000)), FALSE, self);
            if ( (trace_fraction == 1.00000) ) {

               return ;

            }
            if ( (self.t_width < time) ) {

               MetalHitSound ( trace_ent.thingtype);
               self.t_width = (time + 1.00000);

            }
            if ( trace_ent.takedamage ) {

               T_Damage ( trace_ent, self, self, (((2.00000 * (self.skin + 1.00000)) * (self.aflag + 1.00000)) * (coop + 1.00000)));

            }
            if ( ((trace_ent.thingtype == THINGTYPE_FLESH) && (self.frame == 198.00000)) ) {

               MeatChunks ( trace_endpos, ((v_right * random(-100.00000,-300.00000)) + '0.00000 0.00000 200.00000'), 3.00000);
               sound ( self, CHAN_AUTO, "weapons/slash.wav", 1.00000, ATTN_NORM);

            }
            SpawnPuff ( trace_endpos, '0.00000 0.00000 0.00000', 3.00000, trace_ent);

         }

      }

   }
};


void  ()mezzo_melee =  {
   if ( (random() < 0.30000) ) {

      self.think = mezzo_clobber;
   } else {

      self.think = mezzo_sword;

   }
   AdvanceThinkTime(self,0.00000);
};


void  ()mezzo_missile =  {
   if ( ((vlen ( (self.enemy.origin - self.origin)) < 84.00000) && lineofsight ( self.enemy, self)) ) {

      self.think = mezzo_charge;
   } else {

      self.think = self.th_run;

   }
   AdvanceThinkTime(self,0.00000);
};


void  ()mezzo_die =  {
   AdvanceFrame( 47.00000, 62.00000);
   if ( self.shield ) {

      remove ( self.shield);

   }
   if ( (self.health < -40.00000) ) {

      chunk_death ( );
      return ;

   }
   if ( (self.frame == 47.00000) ) {

      sound ( self, CHAN_VOICE, "mezzo/die.wav", 1.00000, ATTN_NORM);
   } else {

      if ( (self.frame == 58.00000) ) {

         sound ( self, CHAN_BODY, "player/land.wav", 1.00000, ATTN_NORM);
      } else {

         if ( (self.frame == 62.00000) ) {

            MakeSolidCorpse ( );

         }

      }

   }
   AdvanceThinkTime(self,0.10000);
};


void  ()mezzo_pain_seq =  {
   AdvanceFrame( 103.00000, 109.00000);
   ai_back ( 1.00000);
   if ( cycle_wrapped ) {

      AdvanceThinkTime(self,0.00000);
      if ( !(self.flags & FL_ONGROUND) ) {

         self.think = mezzo_in_air;
      } else {

         self.think = self.th_run;

      }

   }
};


void  (entity attacker,float damage)mezzo_pain =  {
   if ( self.monster_awake ) {

      if ( ((random(self.health) > (damage * 3.00000)) || (self.pain_finished > time)) ) {

         return ;

      }

   }
   self.monster_awake = TRUE;
   if ( self.shield ) {

      remove ( self.shield);

   }
   if ( (self.health <= 100.00000) ) {

      self.th_pain = SUB_Null;
      if ( (self.health <= 100.00000) ) {

         if ( (random() < 0.50000) ) {

            self.oldthink = self.th_run;
            self.think = mezzo_roar;
            self.speed = 15.00000;
            self.yaw_speed = 20.00000;
            self.aflag = TRUE;
         } else {

            if ( !(self.flags & FL_ONGROUND) ) {

               self.think = mezzo_in_air;
            } else {

               self.think = self.th_run;

            }

         }

      }
   } else {

      sound ( self, CHAN_VOICE, "mezzo/pain.wav", 1.00000, ATTN_NORM);
      if ( (!self.enemy || !visible ( self.enemy)) ) {

         if ( ((self.enemy != world) && (self.enemy != attacker)) ) {

            self.oldenemy = self.enemy;

         }
         self.enemy = attacker;

      }
      self.pain_finished = ((time + 1.00000) + self.skin);
      self.think = mezzo_pain_seq;

   }
   AdvanceThinkTime(self,0.00000);
};


void  ()mezzo_land =  {
   AdvanceFrame( 93.00000, 102.00000);
   if ( cycle_wrapped ) {

      AdvanceThinkTime(self,0.00000);
      self.think = self.th_run;
   } else {

      if ( (self.frame == 93.00000) ) {

         sound ( self, CHAN_BODY, "player/land.wav", 1.00000, ATTN_NORM);

      }

   }
};


void  ()mezzo_in_air =  {
   self.frame = 92.00000;
   if ( (self.flags & FL_ONGROUND) ) {

      AdvanceThinkTime(self,0.00000);
      self.think = mezzo_land;
   } else {

      if ( (self.velocity == '0.00000 0.00000 0.00000') ) {

         self.velocity = '0.00000 0.00000 -60.00000';

      }
      self.think = mezzo_in_air;
      if ( (vlen ( self.velocity) > 300.00000) ) {

         if ( (random() < 0.50000) ) {

            self.dflags = TRUE;
            self.think = mezzo_roll_forward;

         }

      }
      AdvanceThinkTime(self,0.05000);

   }
};


void  ()mezzo_jump =  {
   AdvanceFrame( 81.00000, 91.00000);
   ai_face ( );
   if ( (self.flags & FL_ONGROUND) ) {

      AdvanceThinkTime(self,0.00000);
      self.think = mezzo_land;
   } else {

      if ( (self.frame == 91.00000) ) {

         AdvanceThinkTime(self,0.05000);
         self.think = mezzo_in_air;

      }

   }
};


void  ()mezzo_charge_stop =  {
   AdvanceFrame( 20.00000, 30.00000);
   if ( cycle_wrapped ) {

      self.touch = obj_push;
      AdvanceThinkTime(self,0.00000);
      self.think = self.th_run;

   }
   if ( !walkmove ( self.angles_y, (30.00000 - self.frame), FALSE) ) {

      if ( !self.ltime ) {

         self.think = mezzo_pain_seq;
      } else {

         self.think = self.th_run;

      }
      AdvanceThinkTime(self,0.00000);

   }
};


void  ()mezzo_charge_leap =  {
   AdvanceFrame( 14.00000, 19.00000);
   if ( cycle_wrapped ) {

      AdvanceThinkTime(self,0.00000);
      self.think = mezzo_charge_stop;
   } else {

      if ( (self.frame == 14.00000) ) {

         makevectors ( self.angles);
         traceline ( (self.origin + '0.00000 0.00000 25.00000'), ((self.origin + '0.00000 0.00000 25.00000') + (v_forward * 256.00000)), FALSE, self);
         if ( !trace_ent.takedamage ) {

            self.think = mezzo_skid;
            AdvanceThinkTime(self,0.00000);
         } else {

            traceline ( trace_endpos, (trace_endpos - '0.00000 0.00000 300.00000'), TRUE, self);
            if ( ((pointcontents ( trace_endpos) != CONTENT_EMPTY) || (trace_fraction == 1.00000)) ) {

               self.think = mezzo_skid;
               AdvanceThinkTime(self,0.00000);
            } else {

               if ( (self.flags & FL_ONGROUND) ) {

                  if ( (random() < 0.50000) ) {

                     sound ( self, CHAN_VOICE, "mezzo/attack.wav", 1.00000, ATTN_NORM);

                  }
                  self.velocity = ((v_forward * 700.00000) + '0.00000 0.00000 133.00000');
                  self.flags ^= FL_ONGROUND;
               } else {

                  self.think = mezzo_in_air;
                  AdvanceThinkTime(self,0.00000);

               }

            }

         }

      }

   }
};


void  ()mezzo_charge =  {
   AdvanceFrame( 6.00000, 13.00000);
   if ( cycle_wrapped ) {

      AdvanceThinkTime(self,0.00000);
      self.think = mezzo_charge_leap;
   } else {

      if ( (self.frame == 6.00000) ) {

         self.last_attack = time;
         self.ltime = 0.00000;
         self.touch = mezzo_slam;
         self.attack_finished = (time + 1.25000);

      }

   }
   walkmove ( self.angles_y, 15.00000, FALSE);
};


void  ()mezzo_block_return =  {
local float r = 0.00000;
   AdvanceFrame( 5.00000, 0.00000);
   if ( cycle_wrapped ) {

      if ( self.shield ) {

         remove ( self.shield);

      }
      r = vlen ( (self.enemy.origin - self.origin));
      if ( (infront ( self.enemy) && (r < 100.00000)) ) {

         AdvanceThinkTime(self,0.00000);
         self.think = self.th_melee;
      } else {

         AdvanceThinkTime(self,0.00000);
         self.think = self.th_run;

      }

   }
};


void  ()mezzo_block_wait =  {
   self.think = mezzo_block_wait;
   if ( (self.t_width < time) ) {

      AdvanceThinkTime(self,0.00000);
      self.think = mezzo_block_return;
   } else {

      self.frame = 5.00000;
      ai_face ( );
      self.think = mezzo_block_wait;
      AdvanceThinkTime(self,0.05000);

   }
   if ( (range ( self.enemy) == RANGE_MELEE) ) {

      if ( CheckAnyAttack ( ) ) {

         return ;

      }

   }
   if ( !(self.flags & FL_ONGROUND) ) {

      if ( (!self.velocity_x && !self.velocity_y) ) {

         self.think = mezzo_in_air;
      } else {

         self.think = mezzo_roll_forward;

      }
      AdvanceThinkTime(self,0.00000);

   }
   self.shield.oldthink = self.shield.think;
   self.shield.think = SUB_Remove;
   AdvanceThinkTime(self.shield,0.20000);
   mezzo_check_defense ( );
   if ( (self.think == mezzo_block_wait) ) {

      self.shield.think = self.shield.oldthink;
      AdvanceThinkTime(self.shield,0.00000);

   }
};


void  ()mezzo_block =  {
   AdvanceFrame( 0.00000, 5.00000);
   walkmove ( self.angles_y, -1.00000, FALSE);
   if ( cycle_wrapped ) {

      if ( ((self.th_pain == SUB_Null) && (self.health > 77.00000)) ) {

         self.th_pain = mezzo_pain;

      }
      self.t_width = (time + 1.00000);
      AdvanceThinkTime(self,0.00000);
      self.think = mezzo_block_wait;
   } else {

      if ( (self.frame == 0.00000) ) {

         spawn_reflect ( );

      }

   }
};


void  ()mezzo_skid =  {
local float skidspeed = 0.00000;
local float anim_stretch = 0.00000;
   AdvanceFrame( 0.00000, 5.00000);
   anim_stretch = 3.00000;
   skidspeed = (((5.00000 - self.frame) + anim_stretch) - self.level);
   if ( walkmove ( self.angles_y, (skidspeed * 2.00000), FALSE) ) {

      particle ( self.origin, ('0.00000 0.00000 20.00000' * skidspeed), 344.00000, skidspeed);
      if ( (random() < 0.20000) ) {

         CreateWhiteSmoke ( self.origin, '0.00000 0.00000 8.00000', (HX_FRAME_TIME * 2.00000));

      }
   } else {

      AdvanceThinkTime(self,0.00000);
      self.think = mezzo_block_return;
      return ;

   }
   if ( cycle_wrapped ) {

      self.attack_finished = (time + 3.00000);
      AdvanceThinkTime(self,0.00000);
      self.think = mezzo_block_return;
   } else {

      if ( (self.frame == 0.00000) ) {

         spawn_reflect ( );
         sound ( self, CHAN_AUTO, "mezzo/skid.wav", 1.00000, ATTN_NORM);
      } else {

         if ( (self.level < anim_stretch) ) {

            self.frame -= 1.00000;
            self.level += 1.00000;
         } else {

            self.level = 0.00000;

         }

      }

   }
};


void  ()mezzo_roar =  {
   AdvanceFrame( 110.00000, 139.00000);
   self.health += 1.10000;
   if ( (self.frame == 139.00000) ) {

      if ( !self.aflag ) {

         self.th_pain = mezzo_pain;

      }
      if ( !self.takedamage ) {

         self.takedamage = DAMAGE_YES;

      }
      self.last_attack = (time + 3.00000);
      AdvanceThinkTime(self,0.00000);
      self.think = self.oldthink;
   } else {

      if ( (self.frame == 110.00000) ) {

         self.monster_awake = TRUE;
         if ( (self.health < 100.00000) ) {

            self.th_pain = SUB_Null;
            self.takedamage = DAMAGE_NO;

         }
         sound ( self, CHAN_VOICE, "mezzo/roar.wav", 1.00000, ATTN_NORM);
      } else {

         if ( (self.frame == 128.00000) ) {

            AdvanceThinkTime(self,2.00000);

         }

      }

   }
   if ( self.takedamage ) {

      mezzo_check_defense ( );

   }
};


void  ()mezzo_run_think =  {
local float dist = 0.00000;
   mezzo_check_defense ( );
   if ( !self.takedamage ) {

      self.takedamage = DAMAGE_YES;

   }
   if ( (!(self.enemy.flags2 & FL_ALIVE) && (self.enemy != world)) ) {

      self.monster_awake = FALSE;
      visible ( self.enemy);
      if ( (infront ( self.enemy) && infront ( self.enemy)) ) {

         self.oldthink = self.th_stand;
         self.think = mezzo_roar;
      } else {

         self.think = self.th_stand;

      }
      if ( (self.oldenemy.flags2 & FL_ALIVE) ) {

         self.enemy = self.oldenemy;
         self.oldenemy = world;
         self.think = self.th_run;
      } else {

         self.enemy = world;

      }
      AdvanceThinkTime(self,0.00000);
   } else {

      if ( (self.enemy != world) ) {

         if ( visible ( self.enemy) ) {

            dist = vlen ( (self.enemy.origin - self.origin));
            if ( ((dist < 177.00000) && (dist > 33.00000)) ) {

               if ( ((random() < 0.50000) && lineofsight ( self.enemy, self)) ) {

                  AdvanceThinkTime(self,0.00000);
                  self.think = mezzo_charge;
               } else {

                  if ( (((dist > 84.00000) && (self.last_attack < time)) && infront ( self.enemy)) ) {

                     AdvanceThinkTime(self,0.00000);
                     self.think = mezzo_skid;

                  }

               }
            } else {

               if ( !infront ( self.enemy) ) {

                  if ( ((self.last_attack < time) && (random() < 0.50000)) ) {

                     if ( !self.aflag ) {

                        self.yaw_speed = 10.00000;

                     }
                     self.last_attack = (time + 7.00000);
                     AdvanceThinkTime(self,0.00000);
                     self.think = mezzo_skid;
                  } else {

                     self.yaw_speed = 20.00000;

                  }
               } else {

                  if ( !self.aflag ) {

                     self.yaw_speed = 10.00000;

                  }

               }

            }
         } else {

            self.yaw_speed = 10.00000;

         }
         ai_run ( self.speed);
      } else {

         self.think = self.th_stand;
         AdvanceThinkTime(self,0.00000);

      }

   }
};


void  ()mezzo_run_loop =  {
   AdvanceFrame( 158.00000, 179.00000);
   mezzo_run_think ( );
};


void  ()mezzo_run =  {
   AdvanceFrame( 163.00000, 179.00000);
   mezzo_check_defense ( );
   self.last_attack = (time + 0.10000);
   if ( !self.monster_awake ) {

      if ( ((range ( self.enemy) > RANGE_NEAR) && (random() > 0.30000)) ) {

         self.oldthink = self.th_run;
         self.think = mezzo_roar;
         AdvanceThinkTime(self,0.00000);
         return ;
      } else {

         sound ( self, CHAN_VOICE, "mezzo/attack.wav", 1.00000, ATTN_NORM);
         self.monster_awake = TRUE;

      }

   }
   if ( cycle_wrapped ) {

      self.think = mezzo_run_loop;
      AdvanceThinkTime(self,0.00000);
   } else {

      mezzo_run_think ( );

   }
};


void  ()mezzo_walk =  {
   AdvanceFrame( 213.00000, 242.00000);
   if ( ((self.frame == 182.00000) && (random() < 0.10000)) ) {

      mezzo_idle_sound ( );

   }
   mezzo_check_defense ( );
   ai_walk ( 3.00000);
   if ( self.enemy ) {

      if ( CheckAnyAttack ( ) ) {

         return ;

      }

   }
};

void  ()mezzo_stand;

void  ()mezzo_twirl =  {
   AdvanceFrame( 203.00000, 212.00000);
   mezzo_check_defense ( );
   if ( cycle_wrapped ) {

      self.think = mezzo_stand;
      AdvanceThinkTime(self,0.00000);
   } else {

      if ( (self.frame == 203.00000) ) {

         sound ( self, CHAN_WEAPON, "weapons/vorpswng.wav", 0.70000, ATTN_NORM);
         if ( (random() < 0.50000) ) {

            mezzo_idle_sound ( );

         }

      }

   }
   ai_stand ( );
};


void  ()mezzo_stand2 =  {
   AdvanceFrame( 189.00000, 180.00000);
   mezzo_check_defense ( );
   if ( ((self.level < 3.00000) && (self.frame < 189.00000)) ) {

      self.level += 1.00000;
      self.frame += 1.00000;
   } else {

      self.level = 0.00000;

   }
   if ( (self.frame == 180.00000) ) {

      if ( ((random() < 0.10000) || (self.monster_awake && (random() < 0.50000))) ) {

         self.think = mezzo_twirl;
      } else {

         self.think = mezzo_stand;

      }
      AdvanceThinkTime(self,0.00000);
      return ;
   } else {

      if ( ((self.frame == 189.00000) && (random() < 0.10000)) ) {

         mezzo_idle_sound ( );

      }

   }
   ai_stand ( );
};


void  ()mezzo_stand =  {
   AdvanceFrame( 180.00000, 189.00000);
   if ( (random() < 0.50000) ) {

      mezzo_check_defense ( );
      if ( ((!(self.enemy.flags2 & FL_ALIVE) && (self.enemy != world)) || (self.enemy == world)) ) {

         self.monster_awake = FALSE;
         if ( (self.oldenemy.flags2 & FL_ALIVE) ) {

            self.enemy = self.oldenemy;
            self.oldenemy = world;
         } else {

            self.enemy = world;

         }

      }

   }
   if ( ((self.level < 3.00000) && (self.frame > 180.00000)) ) {

      self.level += 1.00000;
      self.frame -= 1.00000;
   } else {

      self.level = 0.00000;

   }
   if ( (self.frame == 189.00000) ) {

      self.think = mezzo_stand2;
      AdvanceThinkTime(self,0.00000);
      return ;
   } else {

      if ( ((self.frame == 180.00000) && (random() < 0.10000)) ) {

         mezzo_idle_sound ( );

      }

   }
   if ( (random() < 0.50000) ) {

      ai_stand ( );

   }
};


void  ()monster_werejaguar =  {
   if ( deathmatch ) {

      remove ( self);
      return ;

   }
   if ( !(self.flags2 & FL_SUMMONED) ) {

      precache_model2 ( "models/mezzoman.mdl");
      precache_model2 ( "models/mezzoref.spr");
      precache_model2 ( "models/h_mez.mdl");
      precache_sound2 ( "mezzo/skid.wav");
      precache_sound2 ( "mezzo/roar.wav");
      precache_sound2 ( "mezzo/reflect.wav");
      precache_sound2 ( "mezzo/slam.wav");
      precache_sound2 ( "mezzo/pain.wav");
      precache_sound2 ( "mezzo/die.wav");
      precache_sound2 ( "mezzo/growl.wav");
      precache_sound2 ( "mezzo/snort.wav");
      precache_sound2 ( "mezzo/attack.wav");

   }
   self.solid = SOLID_SLIDEBOX;
   self.takedamage = DAMAGE_YES;
   self.thingtype = THINGTYPE_FLESH;
   self.movetype = MOVETYPE_STEP;
   self.view_ofs = '0.00000 0.00000 53.00000';
   self.speed = 10.00000;
   self.yaw_speed = 10.00000;
   self.health = 250.00000;
   self.experience_value = 150.00000;
   self.monsterclass = CLASS_HENCHMAN;
   self.mass = 10.00000;
   self.mintel = 15.00000;
   if ( (self.classname == "monster_werepanther") ) {

      self.monsterclass = CLASS_LEADER;
      self.experience_value = 300.00000;
      self.health = 400.00000;
      self.skin = 1.00000;

   }
   self.classname = "monster_mezzoman";
   self.th_stand = mezzo_stand;
   self.th_walk = mezzo_walk;
   self.th_run = mezzo_run;
   self.th_pain = mezzo_pain;
   self.th_melee = mezzo_melee;
   self.th_missile = mezzo_missile;
   self.th_jump = mezzo_jump;
   self.th_die = mezzo_die;
   self.spawnflags |= JUMP;
   setmodel ( self, "models/mezzoman.mdl");
   self.headmodel = "models/h_mez.mdl";
   setsize ( self, '-16.00000 -16.00000 0.00000', '16.00000 16.00000 56.00000');
   self.frame = 180.00000;
   walkmonster_start ( );
};


void  ()monster_mezzoman =  {
   monster_werejaguar ( );
};


void  ()monster_werepanther =  {
   monster_werejaguar ( );
};


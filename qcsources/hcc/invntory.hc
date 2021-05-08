entity  ()SelectSpawnPoint;
void  ()teleport_touch;
void  ()PlayerSpeed_Calc;
void  ()player_fly;
void  ()player_stopfly;

void  ()Use_RingFlight =  {
   if ( (self.rings & RING_FLIGHT) ) {

      self.ring_flight_time = 0.00000;
      self.ring_flight = 0.00000;
      self.rings ^= RING_FLIGHT;
      self.rings_low ^= RING_FLIGHT;
      player_stopfly ( );
      self.cnt_flight -= 1.00000;
   } else {

      self.rings |= RING_FLIGHT;
      self.ring_flight = 100.00000;
      self.ring_flight_time = (time + 1.00000);
      player_fly ( );
      self.rings_low ^= RING_FLIGHT;

   }
};

void  ()monster_imp_lord;

void  ()BecomeImp =  {
local entity oself;
   if ( (other.solid != SOLID_BSP) ) {

      return ;

   }
   setorigin ( self, (self.origin + '0.00000 0.00000 42.00000'));
   setsize ( self, '-40.00000 -40.00000 -42.00000', '40.00000 40.00000 42.00000');
   self.hull = HULL_HYDRA;
   newmis = spawn ( );
   setorigin ( newmis, self.origin);
   tracearea ( self.origin, (self.origin + '0.00000 0.00000 1.00000'), self.mins, self.maxs, FALSE, self);
   if ( ((trace_fraction == 1.00000) && !trace_allsolid) ) {

      self.touch = SUB_Null;
      self.solid = SOLID_NOT;
      newmis.flags2 |= FL_SUMMONED;
      newmis.controller = self.owner;
      newmis.team = self.owner.team;
      newmis.classname = "monster_imp_lord";
      newmis.lifetime = (time + 30.00000);
      if ( (((self.owner.enemy != world) && (self.owner.enemy.flags2 & FL_ALIVE)) && visible2ent ( self.owner.enemy, self)) ) {

         newmis.goalentity = self.owner.enemy;
         newmis.enemy = self.owner.enemy;
         newmis.monster_awake = TRUE;
      } else {

         newmis.goalentity = self.owner;
         newmis.enemy = self.owner;
         newmis.monster_awake = TRUE;

      }
      self.owner.imp_count += 1.00000;
      newmis.imp_count = self.owner.imp_count;
      newmis.think = monster_imp_lord;
      AdvanceThinkTime(newmis,0.00000);
      sound ( newmis, CHAN_AUTO, "weapons/expsmall.wav", 1.00000, ATTN_NORM);
      sound ( newmis, CHAN_VOICE, "imp/upbig.wav", 1.00000, ATTN_NORM);
      setorigin ( self, (self.origin - '0.00000 0.00000 42.00000'));
      BecomeExplosion ( CE_FLOOR_EXPLOSION);
   } else {

      setorigin ( self, ((self.origin - '0.00000 0.00000 42.00000') - (self.movedir * 8.00000)));
      traceline ( (self.origin + '0.00000 0.00000 10.00000'), (self.origin - '0.00000 0.00000 100.00000'), TRUE, self);
      sound ( newmis, CHAN_BODY, "items/itmspawn.wav", 1.00000, ATTN_NORM);
      newmis.classname = "art_summon";
      setorigin ( newmis, (trace_endpos + '0.00000 0.00000 40.00000'));
      CreateWhiteFlash ( newmis.origin);
      oself = self;
      oself.think = SUB_Remove;
      AdvanceThinkTime(oself,0.00000);
      self = newmis;
      spawn_artifact ( ARTIFACT_SUMMON, FALSE);

   }
};


void  ()Use_Summoner =  {
local entity missile;
   self.attack_finished = (time + 0.10000);
   makevectors ( self.v_angle);
   missile = spawn ( );
   missile.owner = self;
   missile.classname = "summon";
   missile.movetype = MOVETYPE_BOUNCE;
   missile.solid = SOLID_BBOX;
   missile.touch = BecomeImp;
   missile.effects = EF_DIMLIGHT;
   missile.drawflags = MLS_POWERMODE;
   missile.movedir = normalize ( v_forward);
   missile.velocity = ((normalize ( v_forward) * 300.00000) + (v_up * 100.00000));
   missile.avelocity = RandomVector ( '300.00000 300.00000 300.00000');
   setmodel ( missile, "models/a_summon.mdl");
   setsize ( missile, '0.00000 0.00000 0.00000', '0.00000 0.00000 0.00000');
   setorigin ( missile, ((self.origin + self.proj_ofs) + (v_forward * 16.00000)));
   missile.think = BecomeImp;
   AdvanceThinkTime(missile,1.00000);
   self.cnt_summon -= 1.00000;
};


void  ()teleport_coin_run =  {
   other = self.enemy;
   teleport_touch ( );
};


void  ()Use_TeleportCoin =  {
local entity teleport_ent;
   self.flags2 |= FL_TORNATO_SAFE;
   teleport_ent = spawn ( );
   teleport_ent.goalentity = SelectSpawnPoint ( );
   teleport_ent.classname = "teleportcoin";
   teleport_ent.inactive = FALSE;
   teleport_ent.think = teleport_coin_run;
   teleport_ent.nextthink = (time + 0.01000);
   teleport_ent.spawnflags = 0.00000;
   self.cnt_teleport -= 1.00000;
   teleport_ent.enemy = self;
};


void  ()wedge_run =  {
   if ( (((self.owner.velocity_x == 0.00000) && (self.owner.velocity_y == 0.00000)) && (self.owner.velocity_z == 0.00000)) ) {

      self.effects |= EF_NODRAW;
   } else {

      if ( (self.effects & EF_NODRAW) ) {

         self.effects ^= EF_NODRAW;

      }

   }
   self.angles = vectoangles ( self.owner.velocity);
   self.origin = self.owner.origin;
   self.think = wedge_run;
   self.nextthink = (time + 0.04000);
   if ( ((self.owner.health <= 0.00000) || !(self.owner.artifact_active & ART_HASTE)) ) {

      remove ( self);

   }
};


void  ()Use_TomeofPower =  {
   if ( (self.model == "models/sheep.mdl") ) {

      self.sheep_time = 0.00000;
   } else {

      self.artifact_active = (self.artifact_active | ART_TOMEOFPOWER);
      self.tome_time = (time + TOME_TIME);

   }
   self.cnt_tome -= 1.00000;
};


void  ()Use_Haste =  {
   self.artifact_active = (self.artifact_active | ART_HASTE);
   self.haste_time = (time + TOME_TIME);
   self.effects |= EF_DARKFIELD;
   PlayerSpeed_Calc ( );
   self.cnt_haste -= 1.00000;
};


void  ()proximity_think =  {
local float okay = 0.00000;
local float dist = 0.00000;
local vector org = '0.00000 0.00000 0.00000';
local float bestdist = 0.00000;
local float lastdist = 0.00000;
local entity found;
   AdvanceThinkTime(self,0.10000);
   if ( (self.lifetime < time) ) {

      self.think = MultiExplode;
      AdvanceThinkTime(self,0.00000);
      return ;

   }
   if ( (!visible ( self.enemy) && !(self.enemy.effects & EF_NODRAW)) ) {

      self.enemy = world;

   }
   if ( self.enemy ) {

      org = ((self.enemy.absmin + self.enemy.absmax) * 0.50000);
      dist = vlen ( (org - self.origin));
      if ( (dist < 100.00000) ) {

         sound ( self, CHAN_AUTO, "misc/warning.wav", 1.00000, ATTN_NORM);
         self.think = MultiExplode;
         AdvanceThinkTime(self,0.30000);
      } else {

         self.velocity = (normalize ( (org - self.origin)) * 150.00000);

      }
   } else {

      if ( (random() < 0.50000) ) {

         bestdist = 1001.00000;
         found = findradius ( self.origin, 1000.00000);
         while ( found ) {

            if ( (((((found.health && (found.flags2 & FL_ALIVE)) && !(found.effects & EF_NODRAW)) && (found != self.owner)) && (found != self)) && (found.controller != self.owner)) ) {

               if ( (coop && (found.classname == "player")) ) {

                  okay = FALSE;

               }
               if ( (teamplay && (found.team == self.owner.team)) ) {

                  okay = FALSE;
               } else {

                  okay = TRUE;

               }
               if ( okay ) {

                  lastdist = vlen ( (found.origin - self.origin));
                  if ( (lastdist < bestdist) ) {

                     self.enemy = found;
                     bestdist = lastdist;

                  }

               }

            }
            found = found.chain;

         }

      }

   }
};


void  ()Use_Proximity_Mine =  {
   newmis = spawn ( );
   newmis.owner = self;
   newmis.classname = "proximity";
   newmis.movetype = MOVETYPE_FLYMISSILE;
   newmis.solid = SOLID_BBOX;
   newmis.dmg = (67.50000 + (self.level * 7.50000));
   newmis.health = 10.00000;
   newmis.takedamage = DAMAGE_YES;
   newmis.th_die = MultiExplode;
   newmis.touch = MultiExplode;
   newmis.angles_x = 90.00000;
   newmis.avelocity_y = 100.00000;
   newmis.skin = 1.00000;
   newmis.drawflags |= MLS_POWERMODE;
   setmodel ( newmis, "models/glyphwir.mdl");
   setsize ( newmis, '-3.00000 -3.00000 -3.00000', '3.00000 3.00000 3.00000');
   newmis.hull = HULL_POINT;
   setorigin ( newmis, (self.origin + self.proj_ofs));
   newmis.lifetime = (time + 30.00000);
   newmis.think = proximity_think;
   AdvanceThinkTime(newmis,0.00000);
};


void  ()TimeBombBoom =  {
   sound ( self, CHAN_AUTO, "misc/warning.wav", 1.00000, ATTN_NORM);
   DarkExplosion ( );
};


void  ()TimeBombTouch =  {
   if ( !other.takedamage ) {

      return ;

   }
   other = self.enemy;
   T_Damage ( other, self, self.owner, 50.00000);
   TimeBombBoom ( );
};


void  ()Use_TimeBomb =  {
   newmis = spawn ( );
   newmis.owner = self;
   newmis.enemy = world;
   newmis.classname = "timebomb";
   newmis.solid = SOLID_BBOX;
   newmis.dmg = 50.00000;
   newmis.touch = TimeBombTouch;
   newmis.angles_x = 90.00000;
   newmis.avelocity_y = 100.00000;
   newmis.skin = 1.00000;
   newmis.drawflags |= (DRF_TRANSLUCENT | MLS_ABSLIGHT);
   newmis.abslight = 0.50000;
   setmodel ( newmis, "models/glyphwir.mdl");
   setsize ( newmis, '0.00000 0.00000 0.00000', '0.00000 0.00000 0.00000');
   setorigin ( newmis, (self.origin + self.proj_ofs));
   newmis.think = TimeBombBoom;
   AdvanceThinkTime(newmis,0.75000);
};


void  ()UseBlast =  {
local vector dir = '0.00000 0.00000 0.00000';
local vector holdpos = '0.00000 0.00000 0.00000';
local entity victim;
local float v_length = 0.00000;
local float push = 0.00000;
local float percent = 0.00000;
local float points = 0.00000;
local float inertia = 0.00000;
   victim = findradius ( self.origin, (BLAST_RADIUS * 2.00000));
   self.safe_time = (time + 7.00000);
   while ( victim ) {

      if ( ((((victim.classname != "hook") && (victim.owner.classname != "circfire")) && (victim.classname != "cube_of_force")) && (victim.monsterclass < CLASS_BOSS)) ) {

         if ( ((((victim.health && (victim != self)) || (victim.movetype == MOVETYPE_FLYMISSILE)) || (victim.movetype == MOVETYPE_BOUNCEMISSILE)) && (victim.owner != self)) ) {

            traceline ( self.origin, victim.origin, TRUE, self);
            if ( (trace_fraction == 1.00000) ) {

               sound ( self, CHAN_WEAPON, "raven/blast.wav", 1.00000, ATTN_NORM);
               if ( (((victim.movetype != MOVETYPE_FLYMISSILE) && (victim.movetype != MOVETYPE_BOUNCEMISSILE)) || (victim.classname == "chain_head")) ) {

                  dir = (victim.origin - self.origin);
                  v_length = vlen ( dir);
                  if ( (v_length < BLAST_RADIUS) ) {

                     percent = (BLAST_RADIUS / v_length);
                     if ( (percent > 3.00000) ) {

                        percent = 3.00000;

                     }
                     if ( (victim.mass > 20.00000) ) {

                        inertia = (victim.mass / 20.00000);
                     } else {

                        inertia = 1.00000;

                     }
                     push = ((percent + 1.00000) / inertia);
                     victim.velocity = (dir * push);
                     victim.flags ^= FL_ONGROUND;
                     push = (((percent * 100.00000) + 100.00000) / inertia);
                     victim.velocity_z = push;

                  }
               } else {

                  victim.enemy = victim.owner;
                  victim.owner = self;
                  victim.velocity = (victim.velocity * -1.00000);
                  victim.angles = vectoangles ( victim.velocity);

               }
               holdpos = victim.origin;
               holdpos_z += ((victim.maxs_z - victim.mins_z) / 2.00000);
               traceline ( self.origin, holdpos, FALSE, self);
               CreateBlueFlash ( trace_endpos);
               points = (percent * BLASTDAMAGE);
               if ( (points > 10.00000) ) {

                  points = 10.00000;

               }
               T_Damage ( victim, self, self, points);

            }

         }

      }
      if ( ((victim.classname == "tornato") && (victim.enemy.flags2 & FL_ALIVE)) ) {

         victim.enemy.flags2 |= FL_TORNATO_SAFE;

      }
      if ( (victim.classname == "swarm") ) {

         victim.think = hive_die;
         AdvanceThinkTime(victim,0.00000);

      }
      victim = victim.chain;

   }
   self.cnt_blast -= 1.00000;
};


void  ()UseInvincibility =  {
   self.artifact_active = (self.artifact_active | ART_INVINCIBILITY);
   if ( deathmatch ) {

      self.invincible_time = (time + TOME_TIME);
   } else {

      self.invincible_time = (time + 10.00000);

   }
   if ( (self.artifact_low & ART_INVINCIBILITY) ) {

      self.artifact_low = (self.artifact_low - (self.artifact_low & ART_INVINCIBILITY));

   }
   if ( (self.playerclass == CLASS_CRUSADER) ) {

      self.skin = GLOBAL_SKIN_STONE;
   } else {

      if ( (self.playerclass == CLASS_PALADIN) ) {

         self.effects |= EF_BRIGHTLIGHT;
      } else {

         if ( (self.playerclass == CLASS_ASSASSIN) ) {

            self.colormap = 140.00000;
         } else {

            if ( (self.playerclass == CLASS_NECROMANCER) ) {

               self.effects |= EF_DARKLIGHT;

            }

         }

      }

   }
   self.cnt_invincibility -= 1.00000;
};


void  ()UseInvisibility =  {
   centerprint ( self, "You are Invisible!\n");
   self.artifact_active = (self.artifact_active | ART_INVISIBILITY);
   self.invisible_time = (time + TOME_TIME);
   if ( (self.artifact_low & ART_INVISIBILITY) ) {

      self.artifact_low = (self.artifact_low - (self.artifact_low & ART_INVISIBILITY));

   }
   msg_entity = self;
   WriteByte ( MSG_ONE, SVC_SET_VIEW_FLAGS);
   WriteByte ( MSG_ONE, DRF_TRANSLUCENT);
   self.effects |= (EF_NODRAW | EF_LIGHT);
   self.cnt_invisibility -= 1.00000;
};

void  ()Use_Polymorph;
void  ()Use_Tripwire;
void  ()Use_Fireball;

void  ()BreakChains =  {
   if ( !(self.flags2 & FL_CHAINED) ) {

      return ;

   }
   self.flags2 ^= FL_CHAINED;
   if ( !(self.rings & RING_FLIGHT) ) {

      self.movetype = MOVETYPE_WALK;

   }
};


void  ()UseInventoryItem =  {
   if ( (self.health <= 0.00000) ) {

      return ;

   }
   if ( (((self.flags2 & FL_CHAINED) && (self.inventory != INV_TELEPORT)) && (self.inventory != INV_BLAST)) ) {

      return ;

   }
   if ( ((self.inventory == INV_TORCH) && self.cnt_torch) ) {

      if ( (self.torchtime < (time + 5.00000)) ) {

         UseTorch ( );
         self.flags |= FL_ARTIFACTUSED;

      }
   } else {

      if ( ((self.inventory == INV_TELEPORT) && self.cnt_teleport) ) {

         Use_TeleportCoin ( );
         BreakChains ( );
         self.flags |= FL_ARTIFACTUSED;
      } else {

         if ( ((self.inventory == INV_HP_BOOST) && self.cnt_h_boost) ) {

            use_healthboost ( );
            self.flags |= FL_ARTIFACTUSED;
         } else {

            if ( ((self.inventory == INV_SUPER_HP_BOOST) && self.cnt_sh_boost) ) {

               use_super_healthboost ( );
               self.flags |= FL_ARTIFACTUSED;
            } else {

               if ( ((self.inventory == INV_MANA_BOOST) && self.cnt_mana_boost) ) {

                  UseManaBoost ( );
                  self.flags |= FL_ARTIFACTUSED;
               } else {

                  if ( ((self.inventory == INV_GLYPH) && self.cnt_glyph) ) {

                     self.cnt_glyph -= 1.00000;
                     if ( (self.playerclass == CLASS_ASSASSIN) ) {

                        Use_Tripwire ( );
                     } else {

                        if ( (self.playerclass == CLASS_CRUSADER) ) {

                           Use_TimeBomb ( );
                        } else {

                           if ( (self.playerclass == CLASS_PALADIN) ) {

                              Use_Fireball ( );
                           } else {

                              if ( (self.playerclass == CLASS_NECROMANCER) ) {

                                 Use_Proximity_Mine ( );

                              }

                           }

                        }

                     }
                     self.flags |= FL_ARTIFACTUSED;
                  } else {

                     if ( ((self.inventory == INV_HASTE) && self.cnt_haste) ) {

                        if ( (self.haste_time < (time + 5.00000)) ) {

                           Use_Haste ( );
                           self.flags |= FL_ARTIFACTUSED;

                        }
                     } else {

                        if ( ((self.inventory == INV_BLAST) && self.cnt_blast) ) {

                           UseBlast ( );
                           BreakChains ( );
                           self.flags |= FL_ARTIFACTUSED;
                        } else {

                           if ( ((self.inventory == INV_CUBEOFFORCE) && self.cnt_cubeofforce) ) {

                              if ( (!(self.artifact_flags & AFL_CUBE_LEFT) || !(self.artifact_flags & AFL_CUBE_RIGHT)) ) {

                                 UseCubeOfForce ( );
                                 self.flags |= FL_ARTIFACTUSED;

                              }
                           } else {

                              if ( ((self.inventory == INV_INVINCIBILITY) && self.cnt_invincibility) ) {

                                 if ( (self.invincible_time < (time + 5.00000)) ) {

                                    UseInvincibility ( );
                                    self.flags |= FL_ARTIFACTUSED;

                                 }
                              } else {

                                 if ( ((self.inventory == INV_INVISIBILITY) && self.cnt_invisibility) ) {

                                    if ( (self.invisible_time < (time + 5.00000)) ) {

                                       UseInvisibility ( );
                                       self.flags |= FL_ARTIFACTUSED;

                                    }
                                 } else {

                                    if ( ((self.inventory == INV_TOME) && self.cnt_tome) ) {

                                       if ( (self.tome_time < (time + 5.00000)) ) {

                                          Use_TomeofPower ( );
                                          self.flags |= FL_ARTIFACTUSED;

                                       }
                                    } else {

                                       if ( ((self.inventory == INV_POLYMORPH) && self.cnt_polymorph) ) {

                                          Use_Polymorph ( );
                                          self.flags |= FL_ARTIFACTUSED;
                                       } else {

                                          if ( ((self.inventory == INV_SUMMON) && self.cnt_summon) ) {

                                             Use_Summoner ( );
                                             self.flags |= FL_ARTIFACTUSED;
                                          } else {

                                             if ( ((self.inventory == INV_FLIGHT) && self.cnt_flight) ) {

                                                Use_RingFlight ( );
                                                self.flags |= FL_ARTIFACTUSED;
                                             } else {

                                                if ( (!deathmatch && (self.inventory == INV_FLIGHT)) ) {

                                                   time = time;
                                                } else {

                                                   sprint ( self, STR_DONOTPOSSESS);
                                                   sprint ( self, "\n");

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
};


void  ()PanicButton =  {
   if ( (self.health <= 0.00000) ) {

      return ;

   }
   if ( (self.flags2 & FL_CHAINED) ) {

      return ;

   }
   if ( self.cnt_torch ) {

      if ( (self.torchtime < (time + 5.00000)) ) {

         UseTorch ( );
         self.flags |= FL_ARTIFACTUSED;

      }

   }
   if ( self.cnt_teleport ) {

      Use_TeleportCoin ( );
      BreakChains ( );
      self.flags |= FL_ARTIFACTUSED;

   }
   if ( self.cnt_h_boost ) {

      use_healthboost ( );
      self.flags |= FL_ARTIFACTUSED;

   }
   if ( self.cnt_sh_boost ) {

      use_super_healthboost ( );
      self.flags |= FL_ARTIFACTUSED;

   }
   if ( self.cnt_mana_boost ) {

      UseManaBoost ( );
      self.flags |= FL_ARTIFACTUSED;

   }
   if ( self.cnt_glyph ) {

      self.cnt_glyph = (self.cnt_glyph - 1.00000);
      if ( (self.playerclass == CLASS_ASSASSIN) ) {

         Use_Tripwire ( );
      } else {

         if ( (self.playerclass == CLASS_CRUSADER) ) {

            Use_TimeBomb ( );
         } else {

            if ( (self.playerclass == CLASS_PALADIN) ) {

               Use_Fireball ( );
            } else {

               if ( (self.playerclass == CLASS_NECROMANCER) ) {

                  Use_Proximity_Mine ( );

               }

            }

         }

      }
      self.flags |= FL_ARTIFACTUSED;

   }
   if ( self.cnt_haste ) {

      if ( (self.haste_time < (time + 5.00000)) ) {

         Use_Haste ( );
         self.flags |= FL_ARTIFACTUSED;

      }

   }
   if ( self.cnt_blast ) {

      UseBlast ( );
      BreakChains ( );
      self.flags |= FL_ARTIFACTUSED;

   }
   if ( self.cnt_cubeofforce ) {

      if ( (!(self.artifact_flags & AFL_CUBE_LEFT) || !(self.artifact_flags & AFL_CUBE_RIGHT)) ) {

         UseCubeOfForce ( );
         self.flags |= FL_ARTIFACTUSED;

      }

   }
   if ( self.cnt_invincibility ) {

      if ( (self.invincible_time < (time + 5.00000)) ) {

         UseInvincibility ( );
         self.flags |= FL_ARTIFACTUSED;

      }

   }
   if ( self.cnt_invisibility ) {

      if ( (self.invisible_time < (time + 5.00000)) ) {

         UseInvisibility ( );
         self.flags |= FL_ARTIFACTUSED;

      }

   }
   if ( self.cnt_tome ) {

      if ( (self.tome_time < (time + 5.00000)) ) {

         Use_TomeofPower ( );
         self.flags |= FL_ARTIFACTUSED;

      }

   }
   if ( self.cnt_polymorph ) {

      Use_Polymorph ( );
      self.flags |= FL_ARTIFACTUSED;

   }
   if ( self.cnt_summon ) {

      Use_Summoner ( );
      self.flags |= FL_ARTIFACTUSED;

   }
   if ( self.cnt_flight ) {

      Use_RingFlight ( );
      self.flags |= FL_ARTIFACTUSED;

   }
};


void  ()DropInventoryItem =  {
local entity item;
local entity holdent;
local float throwflag = 0.00000;
   makevectors ( self.v_angle);
   traceline ( (self.origin + self.proj_ofs), ((self.origin + self.proj_ofs) + (v_forward * 60.00000)), FALSE, self);
   if ( (trace_fraction < 1.00000) ) {

      remove ( item);
      centerprint ( self, "Not enough room to throw");
      return ;

   }
   item = spawn ( );
   item.flags |= FL_ITEM;
   item.solid = SOLID_TRIGGER;
   item.movetype = MOVETYPE_TOSS;
   item.owner = self;
   item.artifact_ignore_owner_time = (time + 2.00000);
   item.artifact_ignore_time = (time + 0.10000);
   setsize ( item, '-8.00000 -8.00000 -38.00000', '8.00000 8.00000 24.00000');
   holdent = self;
   self = item;
   throwflag = 0.00000;
   if ( ((holdent.inventory == INV_TORCH) && holdent.cnt_torch) ) {

      spawn_artifact ( ARTIFACT_TORCH, NO_RESPAWN);
      holdent.cnt_torch -= 1.00000;
      throwflag = 1.00000;
   } else {

      if ( ((holdent.inventory == INV_HP_BOOST) && holdent.cnt_h_boost) ) {

         spawn_artifact ( ARTIFACT_HP_BOOST, NO_RESPAWN);
         holdent.cnt_h_boost -= 1.00000;
         throwflag = 1.00000;
      } else {

         if ( ((holdent.inventory == INV_SUPER_HP_BOOST) && holdent.cnt_sh_boost) ) {

            spawn_artifact ( ARTIFACT_SUPER_HP_BOOST, NO_RESPAWN);
            holdent.cnt_sh_boost -= 1.00000;
            throwflag = 1.00000;
         } else {

            if ( ((holdent.inventory == INV_MANA_BOOST) && holdent.cnt_mana_boost) ) {

               spawn_artifact ( ARTIFACT_MANA_BOOST, NO_RESPAWN);
               holdent.cnt_mana_boost -= 1.00000;
               throwflag = 1.00000;
            } else {

               if ( ((holdent.inventory == INV_TELEPORT) && holdent.cnt_teleport) ) {

                  spawn_artifact ( ARTIFACT_TELEPORT, NO_RESPAWN);
                  holdent.cnt_teleport -= 1.00000;
                  throwflag = 1.00000;
               } else {

                  if ( ((holdent.inventory == INV_TOME) && holdent.cnt_tome) ) {

                     spawn_artifact ( ARTIFACT_TOME, NO_RESPAWN);
                     holdent.cnt_tome -= 1.00000;
                     throwflag = 1.00000;
                  } else {

                     if ( ((holdent.inventory == INV_SUMMON) && holdent.cnt_summon) ) {

                        spawn_artifact ( ARTIFACT_SUMMON, NO_RESPAWN);
                        holdent.cnt_summon -= 1.00000;
                        throwflag = 1.00000;
                     } else {

                        if ( ((holdent.inventory == INV_INVISIBILITY) && holdent.cnt_invisibility) ) {

                           spawn_artifact ( ARTIFACT_INVISIBILITY, NO_RESPAWN);
                           holdent.cnt_invisibility -= 1.00000;
                           throwflag = 1.00000;
                        } else {

                           if ( ((holdent.inventory == INV_GLYPH) && ((holdent.cnt_glyph && (holdent.playerclass != CLASS_CRUSADER)) || (holdent.cnt_glyph >= 5.00000))) ) {

                              spawn_artifact ( ARTIFACT_GLYPH, NO_RESPAWN);
                              if ( (holdent.playerclass == CLASS_CRUSADER) ) {

                                 holdent.cnt_glyph -= 5.00000;
                              } else {

                                 holdent.cnt_glyph -= 1.00000;

                              }
                              throwflag = 1.00000;
                           } else {

                              if ( ((holdent.inventory == INV_HASTE) && holdent.cnt_haste) ) {

                                 spawn_artifact ( ARTIFACT_HASTE, NO_RESPAWN);
                                 holdent.cnt_haste -= 1.00000;
                                 throwflag = 1.00000;
                              } else {

                                 if ( ((holdent.inventory == INV_BLAST) && holdent.cnt_blast) ) {

                                    spawn_artifact ( ARTIFACT_BLAST, NO_RESPAWN);
                                    holdent.cnt_blast -= 1.00000;
                                    throwflag = 1.00000;
                                 } else {

                                    if ( ((holdent.inventory == INV_POLYMORPH) && holdent.cnt_polymorph) ) {

                                       spawn_artifact ( ARTIFACT_POLYMORPH, NO_RESPAWN);
                                       holdent.cnt_polymorph -= 1.00000;
                                       throwflag = 1.00000;
                                    } else {

                                       if ( ((holdent.inventory == INV_FLIGHT) && holdent.cnt_flight) ) {

                                          spawn_artifact ( ARTIFACT_FLIGHT, NO_RESPAWN);
                                          holdent.cnt_flight -= 1.00000;
                                          throwflag = 1.00000;
                                       } else {

                                          if ( ((holdent.inventory == INV_CUBEOFFORCE) && holdent.cnt_cubeofforce) ) {

                                             spawn_artifact ( ARTIFACT_CUBEOFFORCE, NO_RESPAWN);
                                             holdent.cnt_cubeofforce -= 1.00000;
                                             throwflag = 1.00000;
                                          } else {

                                             if ( ((holdent.inventory == INV_INVINCIBILITY) && holdent.cnt_invincibility) ) {

                                                spawn_artifact ( ARTIFACT_INVINCIBILITY, NO_RESPAWN);
                                                holdent.cnt_invincibility -= 1.00000;
                                                throwflag = 1.00000;

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
   self = holdent;
   if ( throwflag ) {

      item.velocity = normalize ( v_forward);
      item.velocity = (item.velocity * 200.00000);
      item.velocity_x += random(-20.00000,20.00000);
      item.velocity_y += random(-20.00000,20.00000);
      item.velocity_z = 200.00000;
      makevectors ( self.v_angle);
      setorigin ( item, ((((self.origin + self.proj_ofs) + (v_up * 10.00000)) + (v_forward * 40.00000)) + (v_right * 8.00000)));
      sound ( self, CHAN_BODY, "misc/whoosh.wav", 1.00000, ATTN_NORM);
   } else {

      remove ( item);

   }
};


void  (float which)Inventory_Quick =  {
local float old_inv = 0.00000;
   old_inv = self.inventory;
   self.inventory = which;
   UseInventoryItem ( );
   self.inventory = old_inv;
};


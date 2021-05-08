void  ()CheckRings;

void  ()FreezeAllEntities =  {
local entity search;
   search = nextent ( world);
   while ( (search != world) ) {

      if ( (search.classname != "player") ) {

         AdvanceThinkTime(search,99999.00000);

      }
      search = nextent ( search);

   }
};

float intermission_running   =  0.00000;
float intermission_exittime   =  0.00000;

void  ()info_intermission =  {
};


entity  ()FindIntermission =  {
local entity spot;
local float cyc = 0.00000;
   spot = find ( world, classname, "info_intermission");
   if ( spot ) {

      cyc = random(4.00000);
      while ( (cyc > 1.00000) ) {

         spot = find ( spot, classname, "info_intermission");
         if ( !spot ) {

            spot = find ( spot, classname, "info_intermission");

         }
         cyc = (cyc - 1.00000);

      }
      return ( spot );

   }
   spot = find ( world, classname, "info_player_start");
   if ( spot ) {

      return ( spot );

   }
   spot = find ( world, classname, "testplayerstart");
   if ( spot ) {

      return ( spot );

   }
   objerror ( "FindIntermission: no spot");
};

string nextmap   =  "";
string nextstartspot   =  "";

void  ()GotoNextMap =  {
   if ( cvar ( "samelevel") ) {

      changelevel ( mapname, startspot);
   } else {

      changelevel ( nextmap, nextstartspot);

   }
};


void  ()ExitIntermission =  {
   if ( deathmatch ) {

      intermission_running = 0.00000;
      intermission_exittime = 0.00000;

   }
   other = find ( world, classname, "player");
   while ( (other != world) ) {

      stuffcmd ( other, "-showdm\n");
      other.frags = 0.00000;
      other.takedamage = DAMAGE_YES;
      other.solid = SOLID_BBOX;
      other.movetype = MOVETYPE_WALK;
      other.flags ^= FL_NOTARGET;
      other.effects = FALSE;
      other.weaponmodel = other.lastweapon;
      other = find ( other, classname, "player");

   }
   if ( deathmatch ) {

      gameover = FALSE;
      GotoNextMap ( );
      return ;

   }
   intermission_exittime = (time + 1.00000);
   intermission_running = (intermission_running + 1.00000);
   if ( (intermission_running == 2.00000) ) {

      GotoNextMap ( );

   }
};


void  ()IntermissionThink =  {
   if ( (time < intermission_exittime) ) {

      return ;

   }
   if ( ((!self.button0 && !self.button1) && !self.button2) ) {

      return ;

   }
   ExitIntermission ( );
};


void  ()execute_changelevel =  {
   intermission_running = 1.00000;
   if ( deathmatch ) {

      intermission_exittime = (time + 5.00000);
   } else {

      intermission_exittime = (time + 2.00000);

   }
   other = find ( world, classname, "player");
   while ( (other != world) ) {

      other.sv_flags = serverflags;
      AdvanceThinkTime(other,0.50000);
      other.takedamage = DAMAGE_NO;
      other.solid = SOLID_NOT;
      other.movetype = MOVETYPE_NONE;
      other.flags |= FL_NOTARGET;
      other.effects = EF_NODRAW;
      other.lastweapon = other.weaponmodel;
      stuffcmd ( other, "+showdm\n");
      other = find ( other, classname, "player");

   }
};


void  ()FindDMLevel =  {
   serverflags |= SFL_NEW_UNIT;
   nextmap = string_null;
   if ( cvar ( "registered") ) {

      if ( (mapname == "demo1") ) {

         nextmap = "demo2";
      } else {

         if ( (mapname == "demo2") ) {

            nextmap = "demo3";
         } else {

            if ( (mapname == "demo3") ) {

               nextmap = "village1";
            } else {

               if ( (mapname == "village1") ) {

                  nextmap = "village2";
               } else {

                  if ( (mapname == "village2") ) {

                     nextmap = "village3";
                  } else {

                     if ( (mapname == "village3") ) {

                        nextmap = "village4";
                     } else {

                        if ( (mapname == "village4") ) {

                           nextmap = "village5";
                        } else {

                           if ( (mapname == "village5") ) {

                              nextmap = "rider1a";
                           } else {

                              if ( (mapname == "rider1a") ) {

                                 nextmap = "demo1";
                              } else {

                                 if ( (mapname == "meso1") ) {

                                    nextmap = "meso2";
                                 } else {

                                    if ( (mapname == "meso2") ) {

                                       nextmap = "meso3";
                                    } else {

                                       if ( (mapname == "meso3") ) {

                                          nextmap = "meso4";
                                       } else {

                                          if ( (mapname == "meso4") ) {

                                             nextmap = "meso5";
                                          } else {

                                             if ( (mapname == "meso5") ) {

                                                nextmap = "meso6";
                                             } else {

                                                if ( (mapname == "meso6") ) {

                                                   nextmap = "meso8";
                                                } else {

                                                   if ( (mapname == "meso8") ) {

                                                      nextmap = "meso9";
                                                   } else {

                                                      if ( (mapname == "meso9") ) {

                                                         nextmap = "meso1";
                                                      } else {

                                                         if ( (mapname == "egypt1") ) {

                                                            nextmap = "egypt2";
                                                         } else {

                                                            if ( (mapname == "egypt2") ) {

                                                               nextmap = "egypt3";
                                                            } else {

                                                               if ( (mapname == "egypt3") ) {

                                                                  nextmap = "egypt4";
                                                               } else {

                                                                  if ( (mapname == "egypt4") ) {

                                                                     nextmap = "egypt5";
                                                                  } else {

                                                                     if ( (mapname == "egypt5") ) {

                                                                        nextmap = "egypt6";
                                                                     } else {

                                                                        if ( (mapname == "egypt6") ) {

                                                                           nextmap = "egypt7";
                                                                        } else {

                                                                           if ( (mapname == "egypt7") ) {

                                                                              nextmap = "rider2c";
                                                                           } else {

                                                                              if ( (mapname == "rider2c") ) {

                                                                                 nextmap = "egypt1";
                                                                              } else {

                                                                                 if ( (mapname == "romeric1") ) {

                                                                                    nextmap = "romeric2";
                                                                                 } else {

                                                                                    if ( (mapname == "romeric2") ) {

                                                                                       nextmap = "romeric3";
                                                                                    } else {

                                                                                       if ( (mapname == "romeric3") ) {

                                                                                          nextmap = "romeric4";
                                                                                       } else {

                                                                                          if ( (mapname == "romeric4") ) {

                                                                                             nextmap = "romeric5";
                                                                                          } else {

                                                                                             if ( (mapname == "romeric5") ) {

                                                                                                nextmap = "romeric6";
                                                                                             } else {

                                                                                                if ( (mapname == "romeric6") ) {

                                                                                                   nextmap = "romeric7";
                                                                                                } else {

                                                                                                   if ( (mapname == "romeric7") ) {

                                                                                                      nextmap = "romeric1";
                                                                                                   } else {

                                                                                                      if ( (mapname == "cath") ) {

                                                                                                         nextmap = "tower";
                                                                                                      } else {

                                                                                                         if ( (mapname == "tower") ) {

                                                                                                            nextmap = "castle4";
                                                                                                         } else {

                                                                                                            if ( (mapname == "castle4") ) {

                                                                                                               nextmap = "castle5";
                                                                                                            } else {

                                                                                                               if ( (mapname == "castle5") ) {

                                                                                                                  nextmap = "eidolon";
                                                                                                               } else {

                                                                                                                  if ( (mapname == "eidolon") ) {

                                                                                                                     nextmap = "cath";
                                                                                                                  } else {

                                                                                                                     if ( (mapname == "ravdm1") ) {

                                                                                                                        nextmap = "ravdm2";
                                                                                                                     } else {

                                                                                                                        if ( (mapname == "ravdm2") ) {

                                                                                                                           nextmap = "ravdm3";
                                                                                                                        } else {

                                                                                                                           if ( (mapname == "ravdm3") ) {

                                                                                                                              nextmap = "ravdm4";
                                                                                                                           } else {

                                                                                                                              if ( (mapname == "ravdm4") ) {

                                                                                                                                 nextmap = "ravdm5";
                                                                                                                              } else {

                                                                                                                                 if ( (mapname == "ravdm5") ) {

                                                                                                                                    nextmap = "ravdm1";

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
   } else {

      if ( (mapname == "demo1") ) {

         nextmap = "demo2";
      } else {

         if ( (mapname == "demo2") ) {

            nextmap = "ravdm1";
         } else {

            if ( (mapname == "ravdm1") ) {

               nextmap = "demo1";

            }

         }

      }

   }
};


void  ()changelevel_touch =  {
   if ( (other.classname != "player") ) {

      return ;

   }
   if ( ((cvar ( "noexit") == 1.00000) || ((cvar ( "noexit") == 2.00000) && (mapname != "start"))) ) {

      T_Damage ( other, self, self, 50000.00000);
      return ;

   }
   if ( (self.movedir != '0.00000 0.00000 0.00000') ) {

      makevectors ( other.angles);
      if ( ((v_forward * self.movedir) < 0.00000) ) {

         return ;

      }

   }
   other.sv_flags = serverflags;
   if ( (coop || deathmatch) ) {

      bprint ( other.netname);
      bprint ( " exited the level\n");

   }
   if ( deathmatch ) {

      FindDMLevel ( );
   } else {

      nextmap = self.map;
      nextstartspot = self.target;

   }
   SUB_UseTargets ( );
   if ( (!cvar ( "registered") && (nextmap == "village1")) ) {

      remove ( self);
      intermission_running = 2.00000;
      intermission_exittime = (time + 20.00000);
      WriteByte ( MSG_ALL, SVC_INTERMISSION);
      WriteByte ( MSG_ALL, 5.00000);
      FreezeAllEntities ( );
      return ;

   }
   if ( (deathmatch == 0.00000) ) {

      GotoNextMap ( );
      return ;

   }
   self.touch = SUB_Null;
   self.think = execute_changelevel;
   AdvanceThinkTime(self,0.10000);
};


void  ()changelevel_use =  {
local entity saveOther;
   saveOther = other;
   other = activator;
   changelevel_touch ( );
   other = saveOther;
};


void  ()trigger_changelevel =  {
   if ( !self.map ) {

      objerror ( "changelevel trigger doesn't have map");

   }
   InitTrigger ( );
   self.touch = changelevel_touch;
   self.use = changelevel_use;
};


void  ()respawn =  {
   if ( coop ) {

      SolidPlayer ( );
      setspawnparms ( self);
      PutClientInServer ( );
   } else {

      if ( deathmatch ) {

         SolidPlayer ( );
         PutClientInServer ( );
      } else {

         localcmd ( "restart restore\n");

      }

   }
};


void  ()ClientKill =  {
   bprint ( self.netname);
   bprint ( " suicides\n");
   self.model = self.init_model;
   GibPlayer ( );
   self.frags = (self.frags - 2.00000);
   drop_level ( self, 2.00000);
   respawn ( );
};


float  (vector v)CheckSpawnPoint =  {
   return ( FALSE );
};


entity  ()SelectSpawnPoint =  {
local entity spot;
local entity thing;
local float pcount = 0.00000;
local float ok = 0.00000;
   spot = find ( world, classname, "testplayerstart");
   if ( spot ) {

      return ( spot );

   }
   if ( coop ) {

      spot = lastspawn;
      pcount = 1.00000;
      while ( ((pcount > 0.00000) && (pcount < 3.00000)) ) {

         spot = find ( spot, classname, "info_player_coop");
         if ( (((spot != world) && (spot.targetname == startspot)) || ((startspot == string_null) && (spot.spawnflags & 1.00000))) ) {

            thing = findradius ( spot.origin, 64.00000);
            ok = TRUE;
            while ( thing ) {

               if ( (thing.classname == "player") ) {

                  thing = world;
                  ok = FALSE;
               } else {

                  thing = thing.chain;

               }

            }
            if ( ok ) {

               lastspawn = spot;
               return ( lastspawn );

            }

         }
         if ( (spot == world) ) {

            pcount += 1.00000;

         }

      }
      lastspawn = find ( lastspawn, classname, "info_player_start");
      if ( (lastspawn != world) ) {

         return ( lastspawn );

      }
   } else {

      if ( deathmatch ) {

         spot = lastspawn;
         while ( 1.00000 ) {

            spot = find ( spot, classname, "info_player_deathmatch");
            if ( (spot != world) ) {

               if ( (spot == lastspawn) ) {

                  return ( lastspawn );

               }
               pcount = 0.00000;
               thing = findradius ( spot.origin, 64.00000);
               while ( thing ) {

                  if ( (thing.classname == "player") ) {

                     pcount = (pcount + 1.00000);

                  }
                  thing = thing.chain;

               }
               if ( (pcount == 0.00000) ) {

                  lastspawn = spot;
                  return ( spot );

               }

            }

         }

      }

   }
   if ( startspot ) {

      spot = world;
      pcount = 1.00000;
      while ( pcount ) {

         spot = find ( spot, classname, "info_player_start");
         if ( !spot ) {

            pcount = 0.00000;
         } else {

            if ( (spot.targetname == startspot) ) {

               pcount = 0.00000;

            }

         }

      }

   }
   if ( !spot ) {

      spot = find ( world, classname, "info_player_start");
      if ( !spot ) {

         error ( "PutClientInServer: no info_player_start on level");

      }

   }
   return ( spot );
};


void  ()PutClientInServer =  {
local entity spot;
   spot = SelectSpawnPoint ( );
   if ( deathmatch ) {

      self.items ^= ((((IT_WEAPON4 | IT_WEAPON3) | IT_WEAPON4_1) | IT_WEAPON4_2) | IT_WEAPON2);
      self.skin = 0.00000;
   } else {

      if ( self.sv_flags ) {

         serverflags = self.sv_flags;

      }

   }
   self.classname = "player";
   self.takedamage = DAMAGE_YES;
   self.solid = SOLID_SLIDEBOX;
   self.movetype = MOVETYPE_WALK;
   self.deathtype = "";
   self.viewentity = self;
   self.wallspot = '0.00000 0.00000 0.00000';
   self.scale = 1.00000;
   self.skin = 0.00000;
   self.effects = 0.00000;
   self.abslight = 0.00000;
   self.drawflags = 0.00000;
   self.flags |= FL_CLIENT;
   self.flags2 |= FL_ALIVE;
   self.air_finished = (time + 12.00000);
   self.dmg = 2.00000;
   self.thingtype = THINGTYPE_FLESH;
   self.adjust_velocity = '-999.00000 -999.00000 -999.00000';
   self.plaqueflg = 0.00000;
   self.frozen = 0.00000;
   self.decap = 0.00000;
   self.hasted = 0.00000;
   self.super_damage_low = 0.00000;
   self.super_damage = 0.00000;
   self.ring_turning_time = 0.00000;
   self.ring_water_time = 0.00000;
   self.ring_flight_time = 0.00000;
   self.ring_regen_time = 0.00000;
   self.camera_time = 0.00000;
   self.tome_time = 0.00000;
   self.haste_time = 0.00000;
   self.super_damage_time = 0.00000;
   self.attack_finished = 0.00000;
   self.sheep_time = 0.00000;
   self.teleport_time = 0.00000;
   self.pausetime = 0.00000;
   self.rings_low = 0.00000;
   self.ring_regen_time = 0.00000;
   self.splash_time = 0.00000;
   self.invincible_time = 0.00000;
   self.invisible_finished = 0.00000;
   self.last_onground = 0.00000;
   self.still_time = 0.00000;
   self.sheep_sound_time = 0.00000;
   self.last_impact = 0.00000;
   self.absorb_time = 0.00000;
   self.safe_time = 0.00000;
   self.catapult_time = 0.00000;
   self.healthtime = 0.00000;
   self.torchtime = 0.00000;
   self.last_attack = 0.00000;
   self.camptime = 0.00000;
   self.invisible_time = 0.00000;
   self.onfire = 0.00000;
   self.show_hostile = 0.00000;
   self.act_state = 0.00000;
   self.artifact_active ^= (ARTFLAG_FROZEN | ARTFLAG_STONED);
   if ( (self.playerclass == CLASS_NONE) ) {

      if ( cvar ( "registered") ) {

         setclass ( self, rint ( random(1.00000,4.00000)));
      } else {

         if ( (random() < 0.50000) ) {

            setclass ( self, CLASS_PALADIN);
         } else {

            setclass ( self, CLASS_ASSASSIN);

         }

      }

   }
   if ( (self.max_health <= 0.00000) ) {

      stats_NewPlayer ( self);
   } else {

      self.health = self.max_health;

   }
   if ( ((self.max_health <= 0.00000) || (self.health <= 0.00000)) ) {

      dprint ( "ERROR: Respawned Dead!\n");
      dprintf ( "Class: %s\n", self.playerclass);
      dprint ( "Map: ");
      dprint ( mapname);
      dprint ( "\n");
      dprintf ( "Max: %s\n", self.max_health);
      dprintf ( "Health: %s\n", self.health);
      dprint ( "Autofix: health default to 100\n");
		self.max_health = 100.00000;
      self.health = 100.00000;

   }
   self.deadflag = DEAD_NO;
   setorigin ( self, (spot.origin + '0.00000 0.00000 1.00000'));
   self.angles = spot.angles;
   self.fixangle = TRUE;
   if ( !self.weapon ) {

      self.items = IT_WEAPON1;
      self.weapon = IT_WEAPON1;
      self.oldweapon = IT_WEAPON1;

   }
   if ( deathmatch ) {

      self.weapon = IT_WEAPON1;

   }
   W_SetCurrentAmmo ( );
   SetModelAndThinks ( );
   PlayerSpeed_Calc ( );
   if ( deathmatch ) {

      self.effects = 0.00000;
      self.artifact_active = ART_INVINCIBILITY;
      self.invincible_time = (time + 3.00000);
      self.artifact_low |= ART_INVINCIBILITY;
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

   }
   self.ring_regen_time = 0.00000;
   self.ring_flight_time = 0.00000;
   self.ring_water_time = 0.00000;
   self.ring_turning_time = 0.00000;
   self.ring_flight = 0.00000;
   self.ring_water = 0.00000;
   self.ring_turning = 0.00000;
   self.ring_regeneration = 0.00000;
   self.rings = 0.00000;
   self.view_ofs = '0.00000 0.00000 50.00000';
   self.proj_ofs = '0.00000 0.00000 44.00000';
   self.hull = HULL_PLAYER;
   self.idealpitch = cvar ( "sv_walkpitch");
   self.button2 = 0.00000;
   self.button1 = 0.00000;
   self.button0 = 0.00000;
   self.attack_finished = (time + 0.50000);
   player_frames ( );
   if ( (deathmatch || coop) ) {

      makevectors ( self.angles);
      GenerateTeleportEffect ( self.origin, 0.00000);

   }
   spawn_tdeath ( self.origin, self);
		dprintf ( "Class: %s\n", self.playerclass);
      dprint ( "Map: ");
      dprint ( mapname);
      dprint ( "\n");
      dprintf ( "Max: %s\n", self.max_health);
      dprintf ( "Health: %s\n", self.health);
};


void  (float TimeDiff)ClientReEnter =  {
local entity spot;
   if ( (!(self.flags2 & FL_ALIVE) || (self.health < 1.00000)) ) {

      self.weapon = IT_WEAPON1;
      PutClientInServer ( );
      return ;

   }
   self.owner = world;
   self.dmg_inflictor = world;
   self.goalentity = world;
   self.chain = world;
   self.groundentity = world;
   self.enemy = world;
   if ( deathmatch ) {

      self.items ^= ((((IT_WEAPON4 | IT_WEAPON2) | IT_WEAPON3) | IT_WEAPON4_1) | IT_WEAPON4_2);
      self.skin = 0.00000;
   } else {

      if ( self.sv_flags ) {

         serverflags = self.sv_flags;

      }

   }
   self.movetype = MOVETYPE_WALK;
   self.viewentity = self;
   self.wallspot = '0.00000 0.00000 0.00000';
   self.deathtype = "";
   self.plaqueflg = 0.00000;
   self.frozen = 0.00000;
   self.decap = 0.00000;
   self.splash_time = 0.00000;
   self.healthtime = 0.00000;
   self.onfire = 0.00000;
   self.act_state = 0.00000;
   self.artifact_active ^= (ARTFLAG_FROZEN | ARTFLAG_STONED);
   self.ring_flight_time = 0.00000;
   self.ring_flight = 0.00000;
   self.rings ^= RING_FLIGHT;
   self.rings_active ^= RING_FLIGHT;
   self.air_finished = (time + 12.00000);
   self.ring_regen_time += TimeDiff;
   self.ring_water_time += TimeDiff;
   self.ring_turning_time += TimeDiff;
   self.super_damage_time += TimeDiff;
   self.haste_time += TimeDiff;
   self.tome_time += TimeDiff;
   self.camera_time += TimeDiff;
   self.torchtime += TimeDiff;
   self.pausetime += TimeDiff;
   self.teleport_time += TimeDiff;
   self.sheep_time += TimeDiff;
   self.attack_finished += TimeDiff;
   self.catapult_time += TimeDiff;
   self.safe_time += TimeDiff;
   self.absorb_time += TimeDiff;
   self.last_impact += TimeDiff;
   self.sheep_sound_time += TimeDiff;
   self.still_time += TimeDiff;
   self.last_onground += TimeDiff;
   self.invincible_time += TimeDiff;
   self.show_hostile += TimeDiff;
   self.invisible_time += TimeDiff;
   self.camptime += TimeDiff;
   self.last_attack += TimeDiff;
   self.dmg = 2.00000;
   setsize ( self, '-16.00000 -16.00000 0.00000', '16.00000 16.00000 56.00000');
   self.hull = HULL_PLAYER;
   self.view_ofs = '0.00000 0.00000 50.00000';
   self.proj_ofs = '0.00000 0.00000 44.00000';
   spot = SelectSpawnPoint ( );
   setorigin ( self, (spot.origin + '0.00000 0.00000 1.00000'));
   self.angles = spot.angles;
   self.fixangle = TRUE;
   self.velocity = '0.00000 0.00000 0.00000';
   self.avelocity = '0.00000 0.00000 0.00000';
   self.adjust_velocity = '-999.00000 -999.00000 -999.00000';
   if ( (deathmatch || coop) ) {

      makevectors ( self.angles);
      GenerateTeleportEffect ( self.origin, 0.00000);

   }
   spawn_tdeath ( self.origin, self);
   SetModelAndThinks ( );
   PlayerSpeed_Calc ( );
   W_SetCurrentAmmo ( );
   force_retouch = 2.00000;
   self.think = player_frames;
   AdvanceThinkTime(self,0.00000);
};


void  ()info_player_start =  {
};


void  ()info_player_start2 =  {
};


void  ()testplayerstart =  {
};


void  ()info_player_deathmatch =  {
   if ( !deathmatch ) {

      remove ( self);

   }
};


void  ()info_player_coop =  {
};


void  ()NextLevel =  {
local entity o;
   FindDMLevel ( );
   o = spawn ( );
   o.map = nextmap;
   if ( (nextmap == "") ) {

      o = find ( world, classname, "trigger_changelevel");
      if ( !o ) {

         mapname = "demo1";
         o.map = mapname;

      }

   }
   gameover = TRUE;
   if ( (o.nextthink < time) ) {

      o.think = execute_changelevel;
      AdvanceThinkTime(o,0.10000);

   }
};


void  ()CheckRules =  {
local float timelimit = 0.00000;
local float fraglimit = 0.00000;
   if ( gameover ) {

      return ;

   }
   timelimit = (cvar ( "timelimit") * 60.00000);
   fraglimit = cvar ( "fraglimit");
   if ( (timelimit && (time >= timelimit)) ) {

      NextLevel ( );
      return ;

   }
   if ( (fraglimit && (self.frags >= fraglimit)) ) {

      NextLevel ( );
      return ;

   }
};


void  ()PlayerDeathThink =  {
local float forward = 0.00000;
   if ( (self.flags & FL_ONGROUND) ) {

      forward = vlen ( self.velocity);
      forward = (forward - 20.00000);
      if ( (forward <= 0.00000) ) {

         self.velocity = '0.00000 0.00000 0.00000';
      } else {

         self.velocity = (forward * normalize ( self.velocity));

      }

   }
   if ( (self.deadflag == DEAD_DEAD) ) {

      if ( (self.button2 || self.button0) ) {

         return ;

      }
      self.deadflag = DEAD_RESPAWNABLE;
      return ;

   }
   if ( ((!self.button2 && !self.button1) && !self.button0) ) {

      return ;

   }
   self.button0 = 0.00000;
   self.button1 = 0.00000;
   self.button2 = 0.00000;
   respawn ( );
};


void  ()CheckWaterJump =  {
local vector start = '0.00000 0.00000 0.00000';
local vector end = '0.00000 0.00000 0.00000';
   makevectors ( self.angles);
   start = ((self.origin + self.proj_ofs) - '0.00000 0.00000 8.00000');
   v_forward_z = 0.00000;
   normalize ( v_forward);
   end = (start + (v_forward * 24.00000));
   traceline ( start, end, TRUE, self);
   if ( (trace_fraction < 1.00000) ) {

      if ( (self.model == "models/sheep.mdl") ) {

         start_z = ((self.origin_z + self.proj_ofs_z) + 26.00000);
      } else {

         start_z = ((self.origin_z + self.proj_ofs_z) + 6.00000);

      }
      end = (start + (v_forward * 24.00000));
      self.movedir = (trace_plane_normal * -50.00000);
      traceline ( start, end, TRUE, self);
      if ( (trace_fraction == 1.00000) ) {

         self.flags |= FL_WATERJUMP;
         self.velocity_z = 225.00000;
         self.flags ^= FL_JUMPRELEASED;
         self.teleport_time = (time + 2.00000);
         return ;

      }

   }
};

void  ()catapult_fire;

void  ()PlayerJump =  {
   if ( (self.flags & FL_ONGROUND) ) {

      traceline ( self.origin, (self.origin - '0.00000 0.00000 3.00000'), FALSE, self);
      if ( ((trace_ent.classname == "catapult") && (trace_ent.frame == 20.00000)) ) {

         trace_ent.think = catapult_fire;
         AdvanceThinkTime(trace_ent,0.00000);

      }

   }
   if ( (self.flags & FL_WATERJUMP) ) {

      return ;

   }
   if ( (self.movetype == MOVETYPE_FLY) ) {

      return ;

   }
   if ( (self.waterlevel >= 2.00000) ) {

      if ( (self.watertype == CONTENT_WATER) ) {

         self.velocity_z = (100.00000 * self.scale);
      } else {

         if ( (self.watertype == CONTENT_SLIME) ) {

            self.velocity_z = (80.00000 * self.scale);
         } else {

            self.velocity_z = (50.00000 * self.scale);

         }

      }
      if ( (self.swim_flag < time) ) {

         self.swim_flag = (time + 1.00000);
         if ( (random() < 0.50000) ) {

            sound ( self, CHAN_BODY, "player/swim1.wav", 1.00000, ATTN_NORM);
         } else {

            sound ( self, CHAN_BODY, "player/swim2.wav", 1.00000, ATTN_NORM);

         }

      }
      return ;

   }
   if ( !(self.flags & FL_ONGROUND) ) {

      return ;

   }
   if ( !(self.flags & FL_JUMPRELEASED) ) {

      return ;

   }
   self.act_state = ACT_JUMP;
   self.flags ^= FL_JUMPRELEASED;
   self.flags ^= FL_ONGROUND;
   self.button2 = 0.00000;
   if ( (self.model == "models/sheep.mdl") ) {

      sheep_sound ( 1.00000);
   } else {

      if ( (self.playerclass == CLASS_ASSASSIN) ) {

         sound ( self, CHAN_BODY, "player/assjmp.wav", 1.00000, ATTN_NORM);
      } else {

         sound ( self, CHAN_BODY, "player/paljmp.wav", 1.00000, ATTN_NORM);

      }

   }
   self.velocity_z = (self.velocity_z + (270.00000 * self.scale));
};


void  ()WaterMove =  {
   if ( (self.movetype == MOVETYPE_NOCLIP) ) {

      return ;

   }
   if ( (self.health <= 0.00000) ) {

      return ;

   }
   if ( ((((self.flags & FL_INWATER) && (self.watertype == CONTENT_WATER)) && (self.waterlevel == 3.00000)) && !self.lefty) ) {

      DeathBubbles ( 10.00000);
      self.lefty = 1.00000;

   }
   if ( (self.waterlevel != 3.00000) ) {

      if ( (self.air_finished < time) ) {

         if ( (self.model == "models/sheep.mdl") ) {

            sheep_sound ( 1.00000);
         } else {

            if ( (self.playerclass == CLASS_ASSASSIN) ) {

               sound ( self, CHAN_VOICE, "player/assgasp1.wav", 1.00000, ATTN_NORM);
            } else {

               sound ( self, CHAN_VOICE, "player/palgasp1.wav", 1.00000, ATTN_NORM);

            }

         }
      } else {

         if ( (self.air_finished < (time + 9.00000)) ) {

            if ( (self.model == "models/sheep.mdl") ) {

               sheep_sound ( 1.00000);
            } else {

               if ( (self.playerclass == CLASS_ASSASSIN) ) {

                  sound ( self, CHAN_VOICE, "player/assgasp2.wav", 1.00000, ATTN_NORM);
               } else {

                  sound ( self, CHAN_VOICE, "player/palgasp2.wav", 1.00000, ATTN_NORM);

               }

            }

         }

      }
      self.air_finished = (time + 12.00000);
      self.dmg = 2.00000;
   } else {

      if ( ((self.air_finished < time) && !(self.rings & RING_WATER)) ) {

         if ( (self.pain_finished < time) ) {

            self.dmg = (self.dmg + 2.00000);
            if ( (self.dmg > 15.00000) ) {

               self.dmg = 10.00000;

            }
            T_Damage ( self, world, world, self.dmg);
            self.pain_finished = (time + 1.00000);

         }

      }

   }
   if ( !self.waterlevel ) {

      if ( (self.flags & FL_INWATER) ) {

         sound ( self, CHAN_BODY, "raven/outwater.wav", 1.00000, ATTN_NORM);
         self.flags ^= FL_INWATER;
         self.lefty = 0.00000;

      }
      return ;

   }
   if ( (self.watertype == CONTENT_LAVA) ) {

      if ( (self.dmgtime < time) ) {

         self.dmgtime = (time + 0.50000);
         if ( (other.flags & FL_FIREHEAL) ) {

            other.health = (other.health + (5.00000 * self.waterlevel));
         } else {

            if ( !(other.flags & FL_FIRERESIST) ) {

               T_Damage ( self, world, world, (5.00000 * self.waterlevel));

            }

         }

      }
   } else {

      if ( (self.watertype == CONTENT_SLIME) ) {

         if ( (self.dmgtime < time) ) {

            self.dmgtime = (time + 1.00000);
            T_Damage ( self, world, world, (4.00000 * self.waterlevel));

         }

      }

   }
   if ( !(self.flags & FL_INWATER) ) {

      self.splash_time = (time + 0.05000);
      if ( (self.watertype == CONTENT_LAVA) ) {

         sound ( self, CHAN_BODY, "raven/inlava.wav", 1.00000, ATTN_NORM);
      } else {

         if ( (self.watertype == CONTENT_WATER) ) {

            sound ( self, CHAN_BODY, "raven/inh2o.wav", 1.00000, ATTN_NORM);
         } else {

            if ( (self.watertype == CONTENT_SLIME) ) {

               sound ( self, CHAN_BODY, "player/slimbrn1.wav", 1.00000, ATTN_NORM);

            }

         }

      }
      self.flags |= FL_INWATER;
      self.dmgtime = 0.00000;

   }
   if ( !(self.flags & FL_WATERJUMP) ) {

      self.velocity = (self.velocity - (((0.80000 * self.waterlevel) * frametime) * self.velocity));

   }
};


void  ()CheckCrouch =  {
   if ( (self.crouch_time && (self.crouch_time < time)) ) {

      if ( (self.hull == HULL_CROUCH) ) {

         self.crouch_stuck = 0.00000;
         self.view_ofs_z -= 10.00000;
         self.proj_ofs_z -= 10.00000;
         if ( (self.view_ofs_z < 24.00000) ) {

            self.view_ofs_z = 24.00000;
            self.proj_ofs_z = 18.00000;
            self.crouch_time = 0.00000;
         } else {

            self.crouch_time = (time + (HX_FRAME_TIME / 4.00000));

         }
      } else {

         self.view_ofs_z += 10.00000;
         self.proj_ofs_z += 10.00000;
         if ( (self.view_ofs_z > 50.00000) ) {

            self.view_ofs_z = 50.00000;
            self.proj_ofs_z = 44.00000;
            self.crouch_time = 0.00000;
         } else {

            self.crouch_time = (time + (HX_FRAME_TIME / 4.00000));

         }

      }

   }
   if ( ((((self.flags2 & FL2_CROUCHED) || (self.model == "models/sheep.mdl")) || (self.flags2 & FL2_CROUCH_TOGGLE)) && (self.hull != HULL_CROUCH)) ) {

      PlayerCrouching ( );
   } else {

      if ( ((((!(self.flags2 & FL2_CROUCHED) && (self.model != "models/sheep.mdl")) && !(self.flags2 & FL2_CROUCH_TOGGLE)) && (self.hull == HULL_CROUCH)) || self.crouch_stuck) ) {

         PlayerUnCrouching ( );

      }

   }
};


void  ()CheckIncapacities =  {
local vector dir = '0.00000 0.00000 0.00000';
   if ( (self.frozen > 0.00000) ) {

      if ( ((self.flags2 & FL_ALIVE) && self.health) ) {

         if ( (self.colormap > 144.00000) ) {

            self.colormap -= 0.50000;
            self.abslight -= 0.02500;
         } else {

            self.colormap = 0.00000;
            self.abslight = 0.50000;
            self.skin = GLOBAL_SKIN_ICE;

         }
         if ( (self.pausetime <= time) ) {

            if ( (self.skin == GLOBAL_SKIN_ICE) ) {

               self.skin = self.oldskin;

            }
            self.colormap = 0.00000;
            self.abslight = 0.00000;
            self.thingtype = THINGTYPE_FLESH;
            self.drawflags ^= (DRF_TRANSLUCENT | MLS_ABSLIGHT);
            self.frozen = FALSE;
            self.artifact_active ^= ARTFLAG_FROZEN;

         }
      } else {

         self.teleport_time = 0.00000;
         self.pausetime = 0.00000;
         self.frozen = 0.00000;

      }

   }
   if ( ((self.pausetime > time) && (self.model != self.headmodel)) ) {

      if ( (self.model == "models/flesh1.mdl") ) {

         dir = normalize ( ((self.wallspot - self.origin) + self.view_ofs));
         dir = vectoangles ( dir);
         self.o_angle_x = (dir_x * -1.00000);
         self.o_angle_y = dir_y;
         self.o_angle_z = self.v_angle_z;
      } else {

         if ( (!(self.flags2 & FL_ALIVE) && (self.enemy.flags2 & FL_ALIVE)) ) {

            self.o_angle = normalize ( (((self.enemy.origin + self.enemy.proj_ofs) - self.origin) + self.view_ofs));
            self.o_angle = vectoangles ( self.o_angle);
            self.o_angle_x *= -1.00000;
            if ( (self.o_angle_y > 180.00000) ) {

               self.o_angle_y -= 360.00000;
            } else {

               if ( (self.o_angle_y < -180.00000) ) {

                  self.o_angle_y += 360.00000;

               }

            }
            self.o_angle_z = self.v_angle_z;
            self.o_angle -= self.v_angle;
            if ( (self.o_angle_x > 7.00000) ) {

               self.o_angle_x = 7.00000;
            } else {

               if ( (self.o_angle_x < -7.00000) ) {

                  self.o_angle_x = -7.00000;

               }

            }
            if ( (self.o_angle_y > 10.00000) ) {

               self.o_angle_y = 10.00000;
            } else {

               if ( (self.o_angle_y < -10.00000) ) {

                  self.o_angle_y = -10.00000;

               }

            }
            self.o_angle += self.v_angle;

         }

      }
      msg_entity = self;
      WriteByte ( MSG_ONE, 10.00000);
      WriteAngle ( MSG_ONE, self.o_angle_x);
      WriteAngle ( MSG_ONE, self.o_angle_y);
      WriteAngle ( MSG_ONE, self.o_angle_z);
      if ( (self.flags & FL_ONGROUND) ) {

         self.velocity = '0.00000 0.00000 0.00000';

      }
      self.button0 = 0.00000;
      self.button2 = 0.00000;
      self.impulse = 0.00000;

   }
   if ( (self.flags2 & FL_CHAINED) ) {

      self.button2 = 0.00000;
      self.button1 = 0.00000;
      self.button0 = 0.00000;

   }
};


void  ()PlayerPreThink =  {
local vector spot1 = '0.00000 0.00000 0.00000';
local vector spot2 = '0.00000 0.00000 0.00000';
   if ( !(self.flags & FL_INWATER) ) {

      self.aflag = 0.00000;

   }
   if ( intermission_running ) {

      IntermissionThink ( );
      return ;

   }
   if ( ((((self.view_ofs == '0.00000 0.00000 0.00000') && (self.viewentity.classname != "chasecam")) && !self.button0) && !self.button2) ) {

      return ;

   }
   if ( (self.adjust_velocity_x != -999.00000) ) {

      self.velocity_x = self.adjust_velocity_x;

   }
   if ( (self.adjust_velocity_y != -999.00000) ) {

      self.velocity_y = self.adjust_velocity_y;

   }
   if ( (self.adjust_velocity_z != -999.00000) ) {

      self.velocity_z = self.adjust_velocity_z;

   }
   self.adjust_velocity = '-999.00000 -999.00000 -999.00000';
   CheckIncapacities ( );
   if ( (self.viewentity != self) ) {

      CameraViewPort ( self, self.viewentity);
      if ( (self.viewentity.classname != "chasecam") ) {

         self.weaponframe = self.viewentity.weaponframe;
         self.weaponmodel = self.viewentity.weaponmodel;
         CameraViewAngles ( self, self.viewentity);
      } else {

         self.weaponmodel = "";

      }

   }
   makevectors ( self.v_angle);
   self.friction = 0.00000;
   CheckRules ( );
   CheckRings ( );
   CheckAbilities ( );
   CheckCrouch ( );
   WaterMove ( );
   if ( (self.waterlevel == 2.00000) ) {

      CheckWaterJump ( );

   }
   if ( (self.deadflag >= DEAD_DEAD) ) {

      PlayerDeathThink ( );
      return ;

   }
   if ( self.plaqueflg ) {

      if ( (((self.velocity_x || self.velocity_y) || self.velocity_z) || (self.plaqueangle != self.v_angle)) ) {

         makevectors ( self.v_angle);
         spot1 = (self.origin + self.view_ofs);
         spot2 = (spot1 + (v_forward * 25.00000));
         traceline ( spot1, spot2, FALSE, self);
         if ( ((trace_fraction == 1.00000) || (trace_ent.classname != "plaque")) ) {

            traceline ( spot1, (spot2 - (v_up * 30.00000)), FALSE, self);
            if ( ((trace_fraction == 1.00000) || (trace_ent.classname != "plaque")) ) {

               traceline ( spot1, (spot2 + (v_up * 30.00000)), FALSE, self);
               if ( ((trace_fraction == 1.00000) || (trace_ent.classname != "plaque")) ) {

                  self.plaqueflg = 0.00000;
                  plaque_draw ( MSG_ONE, 0.00000);

               }

            }

         }
         if ( self.plaqueflg ) {

            self.plaqueangle = self.v_angle;

         }

      }

   }
   if ( ((!self.velocity_x && !self.velocity_y) && !self.velocity_z) ) {

      if ( ((self.camptime + 600.00000) < time) ) {

         if ( (self.playerclass == CLASS_PALADIN) ) {

            if ( (self.weapon == IT_WEAPON1) ) {

               gauntlet_twitch ( );
            } else {

               if ( (self.weapon == IT_WEAPON2) ) {

                  vorpal_twitch ( );

               }

            }
            self.camptime = (time + random(840.00000,420.00000));

         }

      }
   } else {

      self.camptime = (time + random(420.00000,840.00000));

   }
   if ( (self.deadflag == DEAD_DYING) ) {

      return ;

   }
   if ( self.button2 ) {

      PlayerJump ( );
   } else {

      self.flags |= FL_JUMPRELEASED;

   }
   if ( (time < self.pausetime) ) {

      self.velocity = '0.00000 0.00000 0.00000';

   }
   if ( ((time > self.attack_finished) && (self.weapon != IT_WEAPON1)) ) {

      if ( (((self.weapon == IT_WEAPON3) && (self.greenmana < 1.00000)) || (((self.weapon == IT_WEAPON4) && (self.bluemana < 1.00000)) && (self.greenmana < 1.00000))) ) {

         W_BestWeapon ( );
         W_SetCurrentWeapon ( );

      }

   }
};


void  ()CheckRings =  {
local entity victim;
local vector dir = '0.00000 0.00000 0.00000';
local float chance = 0.00000;
   if ( (self.health <= 0.00000) ) {

      return ;

   }
   if ( (self.rings & RING_REGENERATION) ) {

      if ( (self.ring_regen_time < time) ) {

         if ( (self.health < self.max_health) ) {

            self.ring_regeneration -= (100.00000 / RING_REGENERATION_MAX);
            self.health += 1.00000;
            self.ring_regen_time = (time + 1.00000);

         }
         if ( ((self.ring_regeneration < 10.00000) && !(self.rings_low & RING_REGENERATION)) ) {

            self.rings_low |= RING_REGENERATION;
            centerprint ( self, "Ring of Regeneration is running low");
            sound ( self, CHAN_BODY, "misc/comm.wav", 1.00000, ATTN_NORM);

         }
         if ( (self.ring_regeneration <= 0.00000) ) {

            self.ring_regeneration = 0.00000;
            self.rings ^= RING_REGENERATION;
            self.rings_active ^= RING_REGENERATION;

         }

      }

   }
   if ( (self.rings & RING_FLIGHT) ) {

      if ( (self.ring_flight_time < time) ) {

         self.ring_flight -= (100.00000 / RING_FLIGHT_MAX);
         if ( ((self.ring_flight < 25.00000) && !(self.rings_low & RING_FLIGHT)) ) {

            self.rings_low |= RING_FLIGHT;
            centerprint ( self, "Ring of Flight is running low");
            sound ( self, CHAN_BODY, "misc/comm.wav", 1.00000, ATTN_NORM);

         }
         if ( (self.ring_flight <= 0.00000) ) {

            self.ring_flight = 0.00000;
            self.rings ^= RING_FLIGHT;
            self.rings_active ^= RING_FLIGHT;
            player_stopfly ( );
            if ( deathmatch ) {

               self.cnt_flight -= 1.00000;

            }

         }
         self.ring_flight_time = (time + 1.00000);

      }

   }
   if ( (((self.rings & RING_WATER) && (self.waterlevel == 3.00000)) && (self.air_finished < time)) ) {

      self.rings_active |= RING_WATER;
      if ( (self.ring_water_time < time) ) {

         self.ring_water -= (100.00000 / RING_WATER_MAX);
         if ( ((self.ring_water < 25.00000) && !(self.rings_low & RING_WATER)) ) {

            self.rings_low |= RING_WATER;
            centerprint ( self, "Ring of Water Breathing is running low");
            sound ( self, CHAN_BODY, "misc/comm.wav", 1.00000, ATTN_NORM);

         }
         if ( (self.ring_water <= 0.00000) ) {

            self.ring_water = 0.00000;
            self.rings ^= RING_WATER;
            self.rings_active ^= RING_WATER;

         }
         self.ring_water_time = (time + 1.00000);

      }
   } else {

      self.rings_active ^= RING_WATER;

   }
   if ( (self.rings & RING_TURNING) ) {

      victim = findradius ( self.origin, 100.00000);
      while ( victim ) {

         if ( ((victim.movetype == MOVETYPE_FLYMISSILE) && (victim.owner != self)) ) {

            victim.owner = self;
            chance = random();
            dir = (victim.origin + (v_forward * -1.00000));
            CreateLittleWhiteFlash ( dir);
            sound ( self, CHAN_WEAPON, "weapons/vorpturn.wav", 1.00000, ATTN_NORM);
            if ( (chance < 0.90000) ) {

               victim.v_angle = (self.v_angle + random('0.00000 0.00000 0.00000','360.00000 360.00000 360.00000'));
               makevectors ( victim.v_angle);
               victim.velocity = (v_forward * 1000.00000);
            } else {

               victim.velocity = ('0.00000 0.00000 0.00000' - victim.velocity);

            }

         }
         victim = victim.chain;

      }
      if ( (self.ring_turning_time < time) ) {

         self.ring_turning -= (100.00000 / RING_TURNING_MAX);
         if ( ((self.ring_turning < 10.00000) && !(self.rings_low & RING_TURNING)) ) {

            self.rings_low |= RING_TURNING;
            centerprint ( self, "Ring of Reflection is running low");
            sound ( self, CHAN_BODY, "misc/comm.wav", 1.00000, ATTN_NORM);

         }
         if ( (self.ring_turning <= 0.00000) ) {

            self.ring_turning = 0.00000;
            self.rings ^= RING_TURNING;
            self.rings_active ^= RING_TURNING;

         }
         self.ring_turning_time = (time + 1.00000);

      }

   }
};


void  (entity loser)remove_invincibility =  {
   loser.artifact_low ^= ART_INVINCIBILITY;
   loser.artifact_active ^= ART_INVINCIBILITY;
   loser.invincible_time = 0.00000;
   loser.air_finished = (time + 12.00000);
   if ( (loser.playerclass == CLASS_CRUSADER) ) {

      loser.skin = 0.00000;
   } else {

      if ( (loser.playerclass == CLASS_PALADIN) ) {

         loser.effects ^= EF_BRIGHTLIGHT;
      } else {

         if ( (loser.playerclass == CLASS_ASSASSIN) ) {

            loser.colormap = 0.00000;
         } else {

            if ( (loser.playerclass == CLASS_NECROMANCER) ) {

               loser.effects ^= EF_DARKLIGHT;

            }

         }

      }

   }
};


void  ()CheckPowerups =  {
   if ( (self.health <= 0.00000) ) {

      return ;

   }
   if ( (self.divine_time < time) ) {

      self.artifact_active ^= ARTFLAG_DIVINE_INTERVENTION;

   }
   if ( self.super_damage ) {

      if ( (self.super_damage_time < time) ) {

         self.super_damage = 0.00000;
      } else {

         if ( (((self.super_damage_time - 10.00000) < time) && !self.super_damage_low) ) {

            self.super_damage_low = 1.00000;
            sprint ( self, "Holy Strength begins to wane\n");
            stuffcmd ( self, "bf\n");

         }

      }

   }
   if ( (self.artifact_active & ART_HASTE) ) {

      if ( (self.haste_time < time) ) {

         self.artifact_low = (self.artifact_low - (self.artifact_low & ART_HASTE));
         self.artifact_active = (self.artifact_active - (self.artifact_active & ART_HASTE));
         self.effects ^= EF_DARKFIELD;
         PlayerSpeed_Calc ( );
         self.haste_time = 0.00000;
         self.air_finished = (time + 12.00000);
      } else {

         if ( ((self.haste_time - 10.00000) < time) ) {

            self.artifact_low = (self.artifact_low | ART_HASTE);

         }

      }

   }
   if ( (self.artifact_active & ART_INVINCIBILITY) ) {

      if ( (self.invincible_time < time) ) {

         remove_invincibility ( self);
      } else {

         if ( ((self.invincible_time - 10.00000) < time) ) {

            self.artifact_low = (self.artifact_low | ART_INVINCIBILITY);

         }

      }

   }
   if ( ((self.drawflags & MLS_MASKIN) != MLS_POWERMODE) ) {

      self.drawflags = ((self.drawflags & MLS_MASKOUT) | MLS_POWERMODE);

   }
   if ( (self.tome_time < time) ) {

      self.artifact_low = (self.artifact_low - (self.artifact_low & ART_TOMEOFPOWER));
      self.artifact_active = (self.artifact_active - (self.artifact_active & ART_TOMEOFPOWER));
      self.tome_time = 0.00000;
      self.drawflags = ((self.drawflags & MLS_MASKOUT) | 0.00000);
   } else {

      if ( ((self.tome_time - 10.00000) < time) ) {

         self.artifact_low = (self.artifact_low | ART_TOMEOFPOWER);

      }

   }
   if ( (self.artifact_active & ART_INVISIBILITY) ) {

      if ( (self.invisible_time < time) ) {

         self.artifact_low = (self.artifact_low - (self.artifact_low & ART_INVISIBILITY));
         self.artifact_active = (self.artifact_active - (self.artifact_active & ART_INVISIBILITY));
         self.invisible_time = 0.00000;
         msg_entity = self;
         WriteByte ( MSG_ONE, SVC_CLEAR_VIEW_FLAGS);
         WriteByte ( MSG_ONE, DRF_TRANSLUCENT);
         self.effects ^= (EF_NODRAW | EF_LIGHT);
      } else {

         if ( ((self.invisible_time - 10.00000) < time) ) {

            self.artifact_low = (self.artifact_low | ART_INVISIBILITY);

         }

      }

   }
   if ( ((self.sheep_time < (time + 3.00000)) && (self.model == "models/sheep.mdl")) ) {

      if ( !self.sheep_sound_time ) {

         sprint ( self, "Polymorph Spell is wearing off...");
         stuffcmd ( self, "bf\n");
         self.sheep_sound_time = TRUE;

      }
      if ( (self.sheep_time < time) ) {

         sound ( self, CHAN_VOICE, "misc/sheepfly.wav", 1.00000, ATTN_NORM);
         particleexplosion ( ((self.absmin + self.absmax) * 0.50000), random(144.00000,159.00000), (self.absmax_z - self.absmin_z), 50.00000);
         GenerateTeleportEffect ( self.origin, 1.00000);
         setsize ( self, '-16.00000 -16.00000 0.00000', '16.00000 16.00000 56.00000');
         self.hull = HULL_PLAYER;
         self.view_ofs = '0.00000 0.00000 50.00000';
         self.proj_ofs = '0.00000 0.00000 44.00000';
         SetModelAndThinks ( );
         PlayerSpeed_Calc ( );
         self.think = player_frames;
         AdvanceThinkTime(self,0.00000);

      }

   }
   if ( (self.cameramode != world) ) {

      if ( deathmatch ) {

         if ( ((((self.velocity != '0.00000 0.00000 0.00000') || (self.pain_finished > time)) || self.button0) || self.button2) ) {

            CameraReturn ( );

         }
      } else {

         if ( (self.camera_time < time) ) {

            CameraReturn ( );

         }

      }

   }
};


void  ()PlayerTouch =  {
   if ( (other.classname == "monster_eidolon") ) {

      return ;

   }
   if ( ((other.dmg == 666.00000) && ((other.velocity != '0.00000 0.00000 0.00000') || (other.avelocity != '0.00000 0.00000 0.00000'))) ) {

      self.decap = TRUE;
      T_Damage ( self, other, other, (self.health + 300.00000));
      return ;

   }
   if ( (((((vlen ( self.velocity) * (self.mass / 10.00000)) >= 100.00000) && ((self.last_onground + 0.30000) < time)) || (other.thingtype >= THINGTYPE_WEBS)) && ((self.last_impact + 0.10000) <= time)) ) {

      obj_fly_hurt ( other);

   }
   if ( (other == world) ) {

      return ;

   }
   if ( (self.flags & FL_ONGROUND) ) {

      return ;
   } else {

      if ( (((((other.classname == "player") || (other.flags & FL_ONGROUND)) || other.health) && (self.origin_z >= ((other.absmin_z + other.absmax_z) * 0.50000))) && (self.velocity_z < 10.00000)) ) {

         self.flags |= FL_ONGROUND;

      }

   }
};


void  ()PlayerPostThink =  {
   if ( intermission_running ) {

      return ;

   }
   if ( self.deadflag ) {

      return ;

   }
   W_WeaponFrame ( );
   if ( (self.viewentity.classname == "chasecam") ) {

      self.weaponmodel = "";

   }
   if ( ((((self.jump_flag * (self.mass / 10.00000)) < -300.00000) && (self.flags & FL_ONGROUND)) && (self.health > 0.00000)) ) {

      if ( (self.absorb_time >= time) ) {

         self.jump_flag /= 2.00000;

      }
      if ( (self.watertype == CONTENT_WATER) ) {

         sound ( self, CHAN_BODY, "player/h2ojmp.wav", 1.00000, ATTN_NORM);
      } else {

         if ( ((self.jump_flag * (self.mass / 10.00000)) < -500.00000) ) {

            if ( (self.playerclass == CLASS_ASSASSIN) ) {

               sound ( self, CHAN_VOICE, "player/asslnd.wav", 1.00000, ATTN_NORM);
            } else {

               sound ( self, CHAN_VOICE, "player/pallnd.wav", 1.00000, ATTN_NORM);

            }
            self.deathtype = "falling";
         } else {

            sound ( self, CHAN_VOICE, "player/land.wav", 1.00000, ATTN_NORM);

         }

      }
      if ( ((self.scale > 1.00000) && ((self.jump_flag * (self.mass / 10.00000)) < -500.00000)) ) {

         MonsterQuake ( ((self.mass / 10.00000) * self.jump_flag));

      }
      self.jump_flag = 0.00000;

   }
   if ( !(self.flags & FL_ONGROUND) ) {

      self.jump_flag = self.velocity_z;
   } else {

      self.last_onground = time;

   }
   CheckPowerups ( );
   if ( ((self.artifact_flags & AFL_TORCH) && (self.torchtime < time)) ) {

      self.torchthink ( );

   }
   if ( ((self.artifact_flags & AFL_SUPERHEALTH) && (self.healthtime < time)) ) {

      DecrementSuperHealth ( );

   }
};


void  ()ClientConnect =  {
   bprint ( self.netname);
   bprint ( STR_JOINEDTHEGAME);
   if ( intermission_running ) {

      ExitIntermission ( );

   }
};


void  ()ClientDisconnect =  {
   if ( gameover ) {

      return ;

   }
   bprint ( self.netname);
   bprint ( STR_LEFTTHEGAMEWITH);
   bprint ( ftos ( self.frags));
   bprint ( STR_FRAGS);
   sound ( self, CHAN_BODY, "player/leave.wav", 1.00000, ATTN_NONE);
   GibPlayer ( );
   set_suicide_frame ( );
};


void  (entity targ,entity attacker,entity inflictor)ClientObituary =  {
local float rnum = 0.00000;
local float tclass = 0.00000;
local float aclass = 0.00000;
local float reversed = 0.00000;
local float powered_up = 0.00000;
local string deathstring;
local string deathstring2;
local string iclass;
   if ( (targ.classname != "player") ) {

      return ;

   }
   tclass = targ.playerclass;
   aclass = attacker.playerclass;
   iclass = inflictor.classname;
   powered_up = inflictor.frags;
   exp_mult = 1.00000;
   rnum = random();
   if ( (targ.deathtype == "teledeath") ) {

      bprint ( targ.netname);
      bprint ( STR_WASTELEFRAGGEDBY);
      bprint ( attacker.netname);
      bprint ( "\n");
      attacker.frags += 1.00000;
      return ;

   }
   if ( (targ.deathtype == "teledeath2") ) {

      bprint ( "The power of invincibility reflects ");
      bprint ( targ.netname);
      bprint ( "'s telefrag\n");
      targ.frags = (targ.frags - 1.00000);
      return ;

   }
   if ( (targ.deathtype == "teledeath3") ) {

      bprint ( attacker.netname);
      bprint ( " telefragged ");
      bprint ( targ.netname);
      bprint ( ", his own teammate!\n");
      attacker.frags = (attacker.frags - 1.00000);
      return ;

   }
   if ( (targ.deathtype == "teledeath4") ) {

      bprint ( attacker.netname);
      bprint ( "'s invincibility met ");
      bprint ( targ.netname);
      bprint ( "'s invincibility and mutual annihilation resulted!\n");
      targ.frags = (targ.frags - 1.00000);
      return ;

   }
   if ( (attacker.classname == "player") ) {

      if ( (targ == attacker) ) {

         attacker.frags = (attacker.frags - 1.00000);
         bprint ( targ.netname);
         if ( (random() < 0.50000) ) {

            bprint ( " must be a masochist!\n");
         } else {

            bprint ( " becomes bored with life...\n");

         }
         return ;
      } else {

         if ( (((teamplay == 2.00000) && (targ.team > 0.00000)) && (targ.team == attacker.team)) ) {

            if ( (rnum < 0.25000) ) {

               deathstring = " mows down a teammate\n";
            } else {

               if ( (rnum < 0.50000) ) {

                  deathstring = " checks his glasses\n";
               } else {

                  if ( (rnum < 0.75000) ) {

                     deathstring = " gets a frag for the other team\n";
                  } else {

                     deathstring = " loses another friend\n";

                  }

               }

            }
            bprint ( attacker.netname);
            bprint ( deathstring);
            attacker.frags = (attacker.frags - 1.00000);
            return ;
         } else {

            attacker.frags = (attacker.frags + 1.00000);
            rnum = attacker.weapon;
            if ( (attacker.model == "models/sheep.mdl") ) {

               if ( (random() < 0.30000) ) {

                  deathstring = " was nibbled to death by ";
               } else {

                  if ( (random() < 0.50000) ) {

                     deathstring = " says 'HELLO DOLLY!' to ";
                  } else {

                     if ( (tclass == CLASS_ASSASSIN) ) {

                        deathstring = " got the wool pulled over her eyes by ";
                     } else {

                        deathstring = " got the wool pulled over his eyes by ";

                     }

                  }

               }
               deathstring2 = " the sheep!!\n";
            } else {

               if ( (targ.decap == 1.00000) ) {

                  if ( (tclass == CLASS_ASSASSIN) ) {

                     deathstring = " lost her head over ";
                  } else {

                     deathstring = "lost his head over ";

                  }
               } else {

                  if ( (targ.decap == 2.00000) ) {

                     if ( (tclass == CLASS_ASSASSIN) ) {

                        deathstring = " got her head blown off by ";
                        deathstring2 = "!\n";
                     } else {

                        deathstring = " got his head blown off by ";
                        deathstring2 = "!\n";

                     }
                  } else {

                     if ( (iclass == "tripwire") ) {

                        deathstring = " tripped on ";
                        deathstring2 = "'s tripwire glyph!\n";
                     } else {

                        if ( (iclass == "fireballblast") ) {

                           deathstring = " was blown away by ";
                           deathstring2 = "'s delayed fireball glyph!\n";
                        } else {

                           if ( (iclass == "proximity") ) {

                              deathstring = " got too close for comfort to ";
                              deathstring2 = "'s proximity glyph!\n";
                           } else {

                              if ( (iclass == "timebomb") ) {

                                 deathstring = " was in the wrong place at the wrong time thanks to ";
                                 deathstring2 = "'s timebomb glyph!\n";
                              } else {

                                 if ( (iclass == "tornato") ) {

                                    deathstring = " isn't in kansas anymore thanks to ";
                                    deathstring2 = "'s tornado!\n";
                                 } else {

                                    if ( (iclass == "blizzard") ) {

                                       deathstring = " was snowed in by ";
                                       deathstring2 = "'s blizzard!\n";
                                    } else {

                                       if ( (targ.deathtype == "hammercrush") ) {

                                          deathstring = " was crushed by the righteous might of ";
                                          deathstring2 = "'s Hammer!\n";
                                       } else {

                                          if ( (iclass == "monster_imp_lord") ) {

                                             deathstring = " was jacked up by ";
                                             deathstring2 = "'s Summoned Imp Lord!\n";
                                          } else {

                                             if ( (rnum == IT_WEAPON1) ) {

                                                if ( (attacker.artifact_active & ART_TOMEOFPOWER) ) {

                                                   exp_mult = 1.50000;
                                                } else {

                                                   exp_mult = 2.00000;

                                                }
                                                if ( (aclass == CLASS_ASSASSIN) ) {

                                                   deathstring = " got penetrated by ";
                                                   deathstring2 = "'s Katar\n";
                                                } else {

                                                   if ( (aclass == CLASS_CRUSADER) ) {

                                                      if ( powered_up ) {

                                                         exp_mult = 1.50000;
                                                         deathstring = " was fried by the holy lightning of ";
                                                         deathstring2 = "'s Mjolnir!\n";
                                                      } else {

                                                         deathstring = " was whalloped by ";
                                                         deathstring2 = "'s hammer!\n";

                                                      }
                                                   } else {

                                                      if ( (aclass == CLASS_PALADIN) ) {

                                                         deathstring = " got KO'd by ";
                                                         deathstring2 = "'s fists of fury!\n";
                                                      } else {

                                                         deathstring = " was sliced and diced by ";
                                                         deathstring2 = "'s sickle!\n";

                                                      }

                                                   }

                                                }
                                             } else {

                                                if ( (rnum == IT_WEAPON2) ) {

                                                   if ( powered_up ) {

                                                      exp_mult = 1.00000;
                                                   } else {

                                                      exp_mult = 1.20000;

                                                   }
                                                   if ( (aclass == CLASS_ASSASSIN) ) {

                                                      if ( powered_up ) {

                                                         deathstring = " was stuck like a pig by ";
                                                         deathstring2 = "'s arrows!\n";
                                                      } else {

                                                         deathstring = " took one of ";
                                                         deathstring2 = "'s arrows to the heart!\n";

                                                      }
                                                   } else {

                                                      if ( (aclass == CLASS_CRUSADER) ) {

                                                         if ( powered_up ) {

                                                            deathstring = " befell the subzero temperatures of ";
                                                            deathstring2 = "'s blizzard!\n";
                                                         } else {

                                                            deathstring = " gets the cold shoulder from ";
                                                            deathstring2 = "!\n";

                                                         }
                                                      } else {

                                                         if ( (aclass == CLASS_PALADIN) ) {

                                                            if ( powered_up ) {

                                                               deathstring = " took a shock to the system from ";
                                                               deathstring2 = "'s Vorpal Shockwave!\n";
                                                            } else {

                                                               deathstring = " was cut to pieces by ";
                                                               deathstring2 = "'s vorpal sword!\n";

                                                            }
                                                         } else {

                                                            if ( powered_up ) {

                                                               deathstring = " was tracked down by ";
                                                               deathstring2 = "'s Magic Missiles!\n";
                                                            } else {

                                                               deathstring = " was mowed down by ";
                                                               deathstring2 = "'s Magic Missiles!\n";

                                                            }

                                                         }

                                                      }

                                                   }
                                                } else {

                                                   if ( (rnum == IT_WEAPON3) ) {

                                                      if ( powered_up ) {

                                                         exp_mult = 0.80000;
                                                      } else {

                                                         exp_mult = 1.00000;

                                                      }
                                                      if ( (aclass == CLASS_ASSASSIN) ) {

                                                         if ( powered_up ) {

                                                            reversed = TRUE;
                                                            deathstring = " opened up a nice big can o' whoop-ass on ";
                                                            deathstring2 = "!\n";
                                                         } else {

                                                            deathstring = " sucked down ";
                                                            deathstring2 = "'s grenade!\n";

                                                         }
                                                      } else {

                                                         if ( (aclass == CLASS_CRUSADER) ) {

                                                            if ( powered_up ) {

                                                               deathstring = " was whisked away by ";
                                                               deathstring2 = "'s tornado!\n";
                                                            } else {

                                                               deathstring = " took a nice hot meteor shower courtesy of ";
                                                               deathstring2 = "!\n";

                                                            }
                                                         } else {

                                                            if ( (aclass == CLASS_PALADIN) ) {

                                                               if ( powered_up ) {

                                                                  deathstring = " was cut down by ";
                                                                  deathstring2 = "'s magic axeblades!\n";
                                                               } else {

                                                                  deathstring = " got a nasty papercut from ";
                                                                  deathstring2 = "'s axeblade!\n";

                                                               }
                                                            } else {

                                                               if ( powered_up ) {

                                                                  deathstring = " was fragged by ";
                                                                  deathstring2 = "'s Frag Bones!\n";
                                                               } else {

                                                                  reversed = TRUE;
                                                                  deathstring = " broke  ";
                                                                  deathstring2 = "'s bones with the bone shard spell!\n";

                                                               }

                                                            }

                                                         }

                                                      }
                                                   } else {

                                                      if ( (rnum == IT_WEAPON4) ) {

                                                         if ( powered_up ) {

                                                            exp_mult = 0.50000;
                                                         } else {

                                                            exp_mult = 0.80000;

                                                         }
                                                         if ( (aclass == CLASS_ASSASSIN) ) {

                                                            if ( powered_up ) {

                                                               deathstring = " got into a little S&M with ";
                                                               deathstring2 = "'s chains!\n";
                                                            } else {

                                                               deathstring = " got cored by ";
                                                               deathstring2 = "'s Scarab Staff!\n";

                                                            }
                                                         } else {

                                                            if ( (aclass == CLASS_CRUSADER) ) {

                                                               if ( (attacker.artifact_active & ART_TOMEOFPOWER) ) {

                                                                  exp_mult = 0.50000;
                                                                  deathstring = " needs some SPF 5,000,000 to stop ";
                                                                  deathstring2 = "'s Sunstaff!\n";
                                                               } else {

                                                                  deathstring = " smells like fried chicken thanks to ";
                                                                  deathstring2 = "'s Sunstaff!\n";

                                                               }
                                                            } else {

                                                               if ( (aclass == CLASS_PALADIN) ) {

                                                                  if ( powered_up ) {

                                                                     deathstring = " was blown into next week by ";
                                                                     deathstring2 = "'s Purifier Seeker!\n";
                                                                  } else {

                                                                     deathstring = "'s evil ways were purified by ";
                                                                     deathstring2 = "!\n";

                                                                  }
                                                               } else {

                                                                  if ( powered_up ) {

                                                                     deathstring = " succumbed to the black death of ";
                                                                     deathstring2 = "'s Ravens!\n";
                                                                  } else {

                                                                     deathstring = " befell the black magic of ";
                                                                     deathstring2 = "'s Ravenstaff!\n";

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

                  }

               }

            }
            if ( reversed ) {

               bprint ( attacker.netname);
               bprint ( deathstring);
               bprint ( targ.netname);
               bprint ( deathstring2);
            } else {

               bprint ( targ.netname);
               bprint ( deathstring);
               bprint ( attacker.netname);
               bprint ( deathstring2);

            }

         }

      }
      return ;
   } else {

      targ.frags = (targ.frags - 1.00000);
      bprint ( targ.netname);
      if ( (attacker.flags & FL_MONSTER) ) {

         if ( (attacker.model == "models/sheep.mdl") ) {

            if ( (random() < 0.50000) ) {

               bprint ( " was savagely mauled by a sheep!\n");
            } else {

               bprint ( " says 'HELLO DOLLY!'\n");

            }

         }
         if ( (attacker.classname == "monster_archer") ) {

            bprint ( " was skewered by an Archer!\n");

         }
         if ( (attacker.classname == "monster_archer_lord") ) {

            bprint ( " got Horshacked!\n");

         }
         if ( (attacker.classname == "monster_fallen_angel") ) {

            bprint ( " was felled by the Fallen Angel\n");

         }
         if ( (attacker.classname == "monster_fallen_angel_lord") ) {

            bprint ( " was decimated by a Fallen Angel Lord!\n");

         }
         if ( (attacker.classname == "monster_golem_bronze") ) {

            if ( (targ.decap == 1.00000) ) {

               bprint ( "'s head was taken as a trophy for the Bronze Golem!\n");
            } else {

               if ( (targ.decap == 2.00000) ) {

                  bprint ( " became a permanent stain on the wall!\n");
               } else {

                  bprint ( " was squished like an insect by a Bronze Golem!\n");

               }

            }

         }
         if ( (attacker.classname == "monster_golem_iron") ) {

            if ( (inflictor.classname == "golem_iron_proj") ) {

               bprint ( " felt the sting of the Iron Golem's jewel!\n");
            } else {

               if ( (targ.decap == 2.00000) ) {

                  bprint ( "'s brains make nice wall decorations!\n");
               } else {

                  bprint ( " was crushed by the Iron Golem's fist!\n");

               }

            }

         }
         if ( (attacker.classname == "monster_golem_stone") ) {

            if ( (targ.decap == 2.00000) ) {

               bprint ( " is feeling a little light-headed!\n");
            } else {

               bprint ( " was pummeled by a Stone Golem!\n");

            }

         }
         if ( (attacker.classname == "monster_golem_crystal") ) {

            bprint ( " was mangled by the Enchanted Crystal Golem!\n");

         }
         if ( (attacker.classname == "monster_hydra") ) {

            bprint ( " becomes food for the Hydra!\n");

         }
         if ( (attacker.classname == "monster_imp_fire") ) {

            bprint ( " was roasted by a Fire Imp!\n");

         }
         if ( (attacker.classname == "monster_imp_ice") ) {

            bprint ( " chills out with the Ice Imps!\n");

         }
         if ( (attacker.classname == "monster_medusa") ) {

            if ( (attacker.skin == 1.00000) ) {

               bprint ( " was stricken by the beauty of the Crimson Medusa!\n");
            } else {

               bprint ( " is helpless in the face of the Medusa's beauty!\n");

            }

         }
         if ( (attacker.classname == "monster_mezzoman") ) {

            if ( (attacker.skin == 1.00000) ) {

               bprint ( " is not yet worthy of facing the WerePanther!\n");
            } else {

               bprint ( " is no match for the WereJaguar!\n");

            }

         }
         if ( (attacker.classname == "monster_mummy") ) {

            bprint ( " got mummified!\n");

         }
         if ( (attacker.classname == "monster_mummy_lord") ) {

            bprint ( " was escorted to the Underworld by a Mummy Lord!\n");

         }
         if ( (attacker.classname == "monster_scorpion_black") ) {

            bprint ( " submits to the sting of the Black Scorpion!\n");

         }
         if ( (attacker.classname == "monster_scorpion_yellow") ) {

            bprint ( " was poisoned by the fatal Golden Scorpion!\n");

         }
         if ( (attacker.classname == "monster_skull_wizard") ) {

            bprint ( " succumbed to the Skull Wizard's magic!\n");

         }
         if ( (attacker.classname == "monster_skull_wizard_lord") ) {

            bprint ( " was Skull-duggeried!\n");

         }
         if ( (attacker.classname == "monster_snake") ) {

            bprint ( " was bitten by the lethal Cobra!\n");

         }
         if ( (attacker.classname == "monster_spider_red_large") ) {

            bprint ( " was overcome by the Crimson Spiders!\n");

         }
         if ( (attacker.classname == "monster_spider_red_small") ) {

            bprint ( " was eaten alive by the spiders!\n");

         }
         if ( (attacker.classname == "monster_spider_yellow_large") ) {

            bprint ( " was overwhelmed by the Golden Spiders!\n");

         }
         if ( (attacker.classname == "monster_spider_yellow_small") ) {

            bprint ( " is a meal for the spiders!\n");

         }
         if ( (attacker.classname == "rider_famine") ) {

            bprint ( " was drained of life-force by Famine!\n");

         }
         if ( (attacker.classname == "rider_death") ) {

            if ( (inflictor == attacker) ) {

               bprint ( " was snuffed out of existance by Death!\n");
            } else {

               if ( (inflictor.netname == "deathbone") ) {

                  bprint ( " had his bones crushed to a fine powder by Death!\n");
               } else {

                  if ( (iclass == "deathmissile") ) {

                     bprint ( " was shot down by Death's crimson bolts!\n");
                  } else {

                     bprint ( " was smitten by Death's unholy fire\n");

                  }

               }

            }

         }
         if ( (attacker.classname == "rider_pestilence") ) {

            if ( (targ.deathtype == "poison") ) {

               bprint ( " was poisoned to death by Pestilence's Crossbow!\n");
            } else {

               bprint ( "'s rotted corpse is the possession of Pestilence!\n");

            }

         }
         if ( (attacker.classname == "rider_war") ) {

            bprint ( " was taught the true meaning of War!\n");

         }
         if ( (attacker.classname == "monster_eidolon") ) {

            if ( (inflictor == attacker) ) {

               bprint ( " was squashed like an insect by Eidolon!\n");
            } else {

               if ( (inflictor.classname == "eidolon fireball") ) {

                  bprint ( " was obliterated by Eidolon's fireballs!\n");
               } else {

                  if ( (inflictor.classname == "eidolon spell") ) {

                     bprint ( " was introduced to a new level of pain by Eidolon's Magic!\n...");
                  } else {

                     if ( (inflictor.classname == "eidolon flames") ) {

                        bprint ( " was roasted to a crisp by Eidolon's Hellfire!\n");

                     }

                  }

               }

            }

         }
         return ;

      }
      if ( (targ.decap == 1.00000) ) {

         if ( (targ.playerclass == CLASS_ASSASSIN) ) {

            bprint ( " should have quit while she was a head... oh, she IS a head!...");
         } else {

            bprint ( " should have quit while he was a head... oh, he IS a head!\n...");

         }
         return ;

      }
      if ( (targ.decap == 2.00000) ) {

         if ( (targ.playerclass == CLASS_ASSASSIN) ) {

            bprint ( " got her head blown off!\n");
         } else {

            bprint ( " got his head blown off!\n");

         }
         return ;

      }
      if ( (attacker.classname == "light_thunderstorm") ) {

         if ( (mapname == "eidolon") ) {

            bprint ( " was smited by Eidolon's unholy lightning!\n");
         } else {

            bprint ( " shouldn't mess with Mother Nature!\n");

         }
         return ;

      }
      if ( (targ.deathtype == "zap") ) {

         bprint ( " was electrocuted!\n");
         return ;

      }
      if ( (targ.deathtype == "chopped") ) {

         bprint ( " was sliced AND diced!\n");
         return ;

      }
      if ( ((attacker.solid == SOLID_BSP) && (attacker != world)) ) {

         bprint ( " was squished\n");
         return ;

      }
      if ( ((attacker.classname == "trap_shooter") || (attacker.classname == "trap_spikeshooter")) ) {

         bprint ( " was spiked");
         if ( ((attacker.enemy.classname == "player") && (attacker.enemy != targ)) ) {

            bprint ( " by ");
            bprint ( attacker.enemy.netname);
            attacker.enemy.frags += 1.00000;

         }
         bprint ( "\n");
         return ;

      }
      if ( (attacker.classname == "fireball") ) {

         bprint ( " ate a lavaball\n");
         return ;

      }
      if ( (attacker.classname == "trigger_changelevel") ) {

         bprint ( " tried to leave\n");
         return ;

      }
      rnum = targ.watertype;
      if ( (rnum == -3.00000) ) {

         if ( (random() < 0.50000) ) {

            bprint ( " takes a nice, deep breath of H2O!\n");
         } else {

            bprint ( " needed gills\n");

         }
         return ;
      } else {

         if ( (rnum == -4.00000) ) {

            if ( (random() < 0.50000) ) {

               bprint ( " gulped a load of slime\n");
            } else {

               bprint ( " can't exist on slime alone\n");

            }
            return ;
         } else {

            if ( (rnum == -5.00000) ) {

               if ( (random() < 0.30000) ) {

                  bprint ( " needs a cold shower\n");
               } else {

                  if ( (random() < 0.50000) ) {

                     bprint ( " likes it HOT!\n");
                  } else {

                     bprint ( " smells like burnt hair\n");

                  }

               }
               return ;

            }

         }

      }
      if ( (targ.deathtype == "falling") ) {

         targ.deathtype = "";
         bprint ( STR_CHUNKYSALSA);
         return ;

      }
      bprint ( STR_CEASEDTOFUNCTION);

   }
};


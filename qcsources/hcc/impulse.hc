void  (float NewLevel)PlayerAdvanceLevel;
void  ()player_level_cheat;
void  ()player_experience_cheat;
void  (entity loser)Polymorph;

void  ()restore_weapon =  {
   self.weaponframe = 0.00000;
   if ( (self.playerclass == CLASS_PALADIN) ) {

      if ( (self.weapon == IT_WEAPON1) ) {

         self.weaponmodel = "models/gauntlet.mdl";
      } else {

         if ( (self.weapon == IT_WEAPON2) ) {

            self.weaponmodel = "models/vorpal.mdl";
         } else {

            if ( (self.weapon == IT_WEAPON3) ) {

               self.weaponmodel = "models/axe.mdl";
            } else {

               if ( (self.weapon == IT_WEAPON4) ) {

                  self.weaponmodel = "models/purifier.mdl";

               }

            }

         }

      }
   } else {

      if ( (self.playerclass == CLASS_CRUSADER) ) {

         if ( (self.weapon == IT_WEAPON1) ) {

            self.weaponmodel = "models/warhamer.mdl";
         } else {

            if ( (self.weapon == IT_WEAPON2) ) {

               self.weaponmodel = "models/icestaff.mdl";
            } else {

               if ( (self.weapon == IT_WEAPON3) ) {

                  self.weaponmodel = "models/meteor.mdl";
               } else {

                  if ( (self.weapon == IT_WEAPON4) ) {

                     self.weaponmodel = "models/sunstaff.mdl";

                  }

               }

            }

         }
      } else {

         if ( (self.playerclass == CLASS_NECROMANCER) ) {

            if ( (self.weapon == IT_WEAPON1) ) {

               self.weaponmodel = "models/sickle.mdl";
            } else {

               if ( (self.weapon == IT_WEAPON2) ) {

                  self.weaponmodel = "models/sickle.mdl";
               } else {

                  if ( (self.weapon == IT_WEAPON3) ) {

                     self.weaponmodel = "models/sickle.mdl";
                  } else {

                     if ( (self.weapon == IT_WEAPON4) ) {

                        self.weaponmodel = "models/ravenstf.mdl";

                     }

                  }

               }

            }
         } else {

            if ( (self.playerclass == CLASS_ASSASSIN) ) {

               if ( (self.weapon == IT_WEAPON1) ) {

                  self.weaponmodel = "models/punchdgr.mdl";
               } else {

                  if ( (self.weapon == IT_WEAPON2) ) {

                     self.weaponmodel = "models/crossbow.mdl";
                  } else {

                     if ( (self.weapon == IT_WEAPON3) ) {

                        self.weaponmodel = "models/v_assgr.mdl";
                     } else {

                        if ( (self.weapon == IT_WEAPON4) ) {

                           self.weaponmodel = "models/scarabst.mdl";

                        }

                     }

                  }

               }

            }

         }

      }

   }
};


void  ()see_coop_view =  {
local entity startent;
local entity found;
local float gotone = 0.00000;
   if ( (!coop && !teamplay) ) {

      centerprint ( self, "Ally vision not available\n");
      return ;

   }
   startent = self.viewentity;
   found = startent;
   while ( !gotone ) {

      found = find ( found, classname, "player");
      if ( (found.flags2 & FL_ALIVE) ) {

         if ( ((deathmatch && (found.team == self.team)) || coop) ) {

            gotone = TRUE;

         }

      }
      if ( (found == startent) ) {

         centerprint ( self, "No allies available\n");
         return ;

      }

   }
   sprint ( self, found.netname);
   sprint ( self, " found!\n");
   self.viewentity = found;
   CameraViewPort ( self, found);
   CameraViewAngles ( self, found);
   if ( (self.viewentity == self) ) {

      self.oldweapon = self.weapon;
      restore_weapon ( );
   } else {

      self.weaponmodel = self.viewentity.weaponmodel;
      self.weaponframe = self.viewentity.weaponframe;

   }
};


void  ()player_everything_cheat =  {
   if ( (deathmatch || coop) ) {

      return ;

   }
   CheatCommand ( );
   Artifact_Cheat ( );
   self.puzzles_cheat = 1.00000;
};


void  ()player_stopfly =  {
   self.movetype = MOVETYPE_WALK;
   self.idealpitch = cvar ( "sv_walkpitch");
   self.idealroll = 0.00000;
};


void  ()player_fly =  {
   self.movetype = MOVETYPE_FLY;
   self.velocity_z = 100.00000;
   self.hoverz = 0.40000;
};


void  ()HeaveHo =  {
local vector dir = '0.00000 0.00000 0.00000';
local float inertia = 0.00000;
local float lift = 0.00000;
   makevectors ( self.v_angle);
   dir = normalize ( v_forward);
   traceline ( (self.origin + self.proj_ofs), ((self.origin + self.proj_ofs) + (dir * 48.00000)), FALSE, self);
   if ( ((((trace_ent.movetype && trace_ent.solid) && (trace_ent != world)) && (trace_ent.flags & FL_ONGROUND)) && (trace_ent.solid != SOLID_BSP)) ) {

      if ( !trace_ent.mass ) {

         inertia = 1.00000;
      } else {

         if ( (trace_ent.mass <= 50.00000) ) {

            inertia = (trace_ent.mass / 10.00000);
         } else {

            inertia = (trace_ent.mass / 100.00000);

         }

      }
      lift = ((((self.strength / 40.00000) + 0.50000) * 300.00000) / inertia);
      if ( (lift > 300.00000) ) {

         lift = 300.00000;

      }
      trace_ent.velocity_z += lift;
      if ( (trace_ent.flags & FL_ONGROUND) ) {

         trace_ent.flags -= FL_ONGROUND;

      }
      if ( (self.playerclass == CLASS_ASSASSIN) ) {

         sound ( self, CHAN_BODY, "player/assjmp.wav", 1.00000, ATTN_NORM);
      } else {

         sound ( self, CHAN_BODY, "player/paljmp.wav", 1.00000, ATTN_NORM);

      }
      self.attack_finished = (time + 1.00000);

   }
};


void  ()ImpulseCommands =  {
local entity search;
local float total = 0.00000;
   if ( ((self.flags2 & FL_CHAINED) && (self.impulse != 23.00000)) ) {

      return ;

   }
   if ( (self.impulse == 9.00000) ) {

      CheatCommand ( );
   } else {

      if ( (self.impulse == 14.00000) ) {

         Polymorph ( self);
      } else {

         if ( (self.impulse == 99.00000) ) {

            ClientKill ( );
         } else {

            if ( (self.impulse == 21.00000) ) {

               UseTorch ( );
            } else {

               if ( (self.impulse == 23.00000) ) {

                  UseInventoryItem ( );
               } else {

                  if ( (self.impulse == 33.00000) ) {

                     see_coop_view ( );
                  } else {

                     if ( (self.impulse == 32.00000) ) {

                        PanicButton ( );
                     } else {

                        if ( (self.impulse == 35.00000) ) {

                           search = nextent ( world);
                           total = 0.00000;
                           while ( (search != world) ) {

                              if ( (search.flags & FL_MONSTER) ) {

                                 total += 1.00000;
                                 remove ( search);

                              }
                              search = nextent ( search);

                           }
                           dprintf ( "Removed %s monsters\n", total);
                        } else {

                           if ( (self.impulse == 36.00000) ) {

                              search = nextent ( world);
                              total = 0.00000;
                              while ( (search != world) ) {

                                 if ( (search.flags & FL_MONSTER) ) {

                                    total += 1.00000;
                                    AdvanceThinkTime(search,99999.00000);

                                 }
                                 search = nextent ( search);

                              }
                              dprintf ( "Froze %s monsters\n", total);
                           } else {

                              if ( (self.impulse == 37.00000) ) {

                                 search = nextent ( world);
                                 total = 0.00000;
                                 while ( (search != world) ) {

                                    if ( (search.flags & FL_MONSTER) ) {

                                       total += 1.00000;
                                       AdvanceThinkTime(search,HX_FRAME_TIME);

                                    }
                                    search = nextent ( search);

                                 }
                                 dprintf ( "UnFroze %s monsters\n", total);
                              } else {

                                 if ( (self.impulse == 42.00000) ) {

                                    dprintv ( "Coordinates: %s\n", self.origin);
                                    dprintv ( "Angles: %s\n", self.angles);
                                    dprint ( "Map is ");
                                    dprint ( mapname);
                                    dprint ( "\n");
                                 } else {

                                    if ( (self.impulse == 43.00000) ) {

                                       player_everything_cheat ( );
                                    } else {

                                       if ( (self.impulse == 44.00000) ) {

                                          DropInventoryItem ( );
                                       } else {

                                          if ( ((self.impulse >= 100.00000) && (self.impulse <= 115.00000)) ) {

                                             Inventory_Quick ( (self.impulse - 99.00000));
                                          } else {

                                             if ( (self.impulse == 254.00000) ) {

                                                sprint ( self, "King of the Hill is ");
                                                search = FindExpLeader ( );
                                                sprint ( self, search.netname);
                                                sprint ( self, " (EXP = ");
                                                sprint ( self, ftos ( search.experience));
                                                sprint ( self, ") \n");

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
   if ( (self.model == "models/sheep.mdl") ) {

      self.impulse = 0.00000;
      return ;
   } else {

      if ( ((self.impulse >= 1.00000) && (self.impulse <= 4.00000)) ) {

         W_ChangeWeapon ( );
      } else {

         if ( ((self.impulse == 10.00000) && (wp_deselect == 0.00000)) ) {

            CycleWeaponCommand ( );
         } else {

            if ( (self.impulse == 11.00000) ) {

               ServerflagsCommand ( );
            } else {

               if ( (self.impulse == 12.00000) ) {

                  CycleWeaponReverseCommand ( );
               } else {

                  if ( (self.impulse == 13.00000) ) {

                     HeaveHo ( );
                  } else {

                     if ( ((self.impulse == 22.00000) && !(self.flags2 & FL2_CROUCHED)) ) {

                        if ( (self.flags2 & FL2_CROUCH_TOGGLE) ) {

                           self.flags2 ^= FL2_CROUCH_TOGGLE;
                        } else {

                           self.flags2 |= FL2_CROUCH_TOGGLE;

                        }

                     }

                  }

               }

            }

         }

      }

   }
   self.impulse = 0.00000;
};


void (entity attacker, float damage) player_pain;
void () player_stand1;
void (vector org) spawn_tfog;
void (vector org, entity death_owner) spawn_tdeath;
void (entity targ, entity attacker) dmatch_score;
float modelindex_eyes /* = 0.000 */;
float modelindex_player /* = 0.000 */;
float modelindex_hammer /* = 0.000 */;
float intermission_running /* = 0.000 */;
float intermission_exittime /* = 0.000 */;

void () info_intermission = {};

void () SetChangeParms = {

   if ( (self.health <= FALSE) ) {

      SetNewParms ();
      parm14 = self.steam;
      return ;

   }
   self.items = (self.items - (self.items & (((((IT_KEY1 | IT_KEY2) | IT_INVULNERABILITY) | IT_SUIT) | IT_QUAD) | IT_INVISIBILITY)));
   self.items2 = (self.items2 - (self.items2 & ((((((IT2_ANTIGRAV | IT2_SHIELD) | IT2_SUPERHEALTH) | IT2_KEY_SKELETON) | IT2_KEY3) | HIP_IT2_WETSUIT) | HIP_IT2_EMPATHY_SHIELDS)));
   self.gravity = TRUE;
   if ( (self.health > 100.000) ) {

      self.health = 100.000;

   }
   if ( (self.health < 50.000) ) {

      self.health = 50.000;

   }
   teamplay = cvar ("teamplay");
   if ( (teamplay >= TEAM_CTF) ) {

      SetNewParms ();

   } else {

      parm1 = self.items;
      parm2 = self.health;
      parm3 = self.armorvalue;
      if ( (self.ammo_shells1 < 25.000) ) {

         parm4 = 25.000;

      } else {

         parm4 = self.ammo_shells1;

      }
      parm5 = self.ammo_nails1;
      parm6 = self.ammo_rockets1;
      parm7 = self.ammo_cells1;
      parm8 = self.weapon;
      parm9 = (self.armortype * 100.000);
      parm10 = self.items2;
      parm11 = self.ammo_lava_nails;
      parm12 = self.ammo_multi_rockets;
      parm13 = self.ammo_plasma;

   }
   parm14 = self.steam;

};

void () SetNewParms = {

   if ( (deathmatch && (teamplay >= TEAM_CTF)) ) {

      parm1 = ((IT_SHOTGUN | IT_AXE) | IT_GRAPPLE);
      parm10 = IT2_ARMOR1;
      parm3 = 50.000;
      parm9 = SVC_INTERMISSION;

   } else {

      parm1 = (IT_SHOTGUN | IT_AXE);
      parm3 = FALSE;
      parm9 = FALSE;
      parm10 = FALSE;

   }
   parm2 = 100.000;
   parm4 = 25.000;
   parm5 = FALSE;
   parm6 = FALSE;
   parm7 = FALSE;
   parm8 = TRUE;
   parm11 = FALSE;
   parm12 = FALSE;
   parm13 = FALSE;
   parm14 = CONTENT_EMPTY;

};

void () DecodeLevelParms = {

   if ( serverflags ) {

      if ( (world.model == "maps/start.bsp") ) {

         SetNewParms ();

      }

   }
   if ( (world.model == "maps/hip1m1.bsp") ) {

      SetNewParms ();

   }
   if ( (world.model == "maps/hip2m1.bsp") ) {

      SetNewParms ();

   }
   if ( (world.model == "maps/hip3m1.bsp") ) {

      SetNewParms ();

   }
   if ( ((world.model == "maps/r2m1.bsp") && !deathmatch) ) {

      SetNewParms ();

   }
   if ( ((world.model == "maps/e1m1.bsp") && !deathmatch) ) {

      SetNewParms ();

   }
   if ( ((world.model == "maps/e2m1.bsp") && !deathmatch) ) {

      SetNewParms ();

   }
   if ( ((world.model == "maps/e3m1.bsp") && !deathmatch) ) {

      SetNewParms ();

   }
   if ( ((world.model == "maps/e4m1.bsp") && !deathmatch) ) {

      SetNewParms ();

   }
   self.items = parm1;
   self.health = parm2;
   self.armorvalue = parm3;
   self.ammo_shells1 = parm4;
   self.ammo_nails1 = parm5;
   self.ammo_rockets1 = parm6;
   self.ammo_cells1 = parm7;
   if ( ((parm8 == IT_GRAPPLE) && (teamplay < TEAM_CTF)) ) {

      self.weapon = IT_AXE;

   } else {

      self.weapon = parm8;

   }
   self.armortype = (parm9 * 0.010);
   self.items2 = parm10;
   self.ammo_lava_nails = parm11;
   self.ammo_multi_rockets = parm12;
   self.ammo_plasma = parm13;
   if ( TeamColorIsLegal (parm14) ) {

      self.steam = parm14;
      TeamSetSkin ();

   }

};
entity () FindIntermission = {

   local entity spot;
   local float cyc;

   spot = find (world,classname,"info_intermission");
   if ( spot ) {

      cyc = (random () * MOVETYPE_STEP);
      while ( (cyc > TRUE) ) {

         spot = find (spot,classname,"info_intermission");
         if ( !spot ) {

            spot = find (spot,classname,"info_intermission");

         }
         cyc = (cyc - TRUE);

      }
      return ( spot );

   }
   spot = find (world,classname,"info_player_start");
   if ( spot ) {

      return ( spot );

   }
   spot = find (world,classname,"testplayerstart");
   if ( spot ) {

      return ( spot );

   }
   objerror ("FindIntermission: no spot");
   return ( spot );

};
string nextmap;

void () GotoNextMap = {

   if ( cvar ("samelevel") ) {

      changelevel (mapname);

   } else {

      changelevel (nextmap);

   }

};

void () ExitIntermission = {

   if ( deathmatch ) {

      GotoNextMap ();
      return ;

   }
   intermission_exittime = (time + TRUE);
   intermission_running = (intermission_running + TRUE);
   if ( (intermission_running == FL_SWIM) ) {

      if ( (world.model == "maps/e1m7.bsp") ) {

         WriteByte (MSG_ALL,SVC_CDTRACK);
         WriteByte (MSG_ALL,FL_SWIM);
         WriteByte (MSG_ALL,MOVETYPE_WALK);
         if ( !cvar ("registered") ) {

            WriteByte (MSG_ALL,SVC_FINALE);
            WriteString (MSG_ALL,"As the corpse of the monstrous entity\nChthon sinks back into the lava whence\nit rose, you grip the Rune of Earth\nMagic tightly. Now that you have\nconquered the Dimension of the Doomed,\nrealm of Earth Magic, you are ready to\ncomplete your task in the other thre\nhaunted lands of Quake. Or are you? If\n you don't register Quake, you'll never\nknow what awaits you in the Realm of\nBlack Magic, the Netherworld and the\nElder World!");

         } else {

            WriteByte (MSG_ALL,SVC_FINALE);
            WriteString (MSG_ALL,"As the corpse of the monstrous entity\nChthon sinks back into the lava whence\nit rose, you grip the Rune of Earth\nMagic tightly. Now that you have\nconquered the Dimension of the Doomed,\nrealm of Earth Magic, you are ready to\ncomplete your task. A Rune of magic\npower lies at the end of each haunted\nland of Quake. Go forth, seek the\ntotality of the four Runes!");

         }
         return ;

      } else {

         if ( (world.model == "maps/e2m6.bsp") ) {

            WriteByte (MSG_ALL,SVC_CDTRACK);
            WriteByte (MSG_ALL,FL_SWIM);
            WriteByte (MSG_ALL,MOVETYPE_WALK);
            WriteByte (MSG_ALL,SVC_FINALE);
            WriteString (MSG_ALL,"The Rune of Black Magic throbs evilly in\nyour hand and whispers dark thoughts\ninto your brain. You learn the inmost\nlore of the Hell-Mother; Shub-Niggurath!\nYou now know that she is behind all the\nterrible plotting which has led to so\nmuch death and horror. But she is not\ninviolate! Armed with this Rune, you\nrealize that once all four Runes are\ncombined, the gate to Shub-Niggurath's\nPit will open, and you can face the\nWitch-Goddess herself in her frightful\notherworld cathedral.");
            return ;

         } else {

            if ( (world.model == "maps/e3m6.bsp") ) {

               WriteByte (MSG_ALL,SVC_CDTRACK);
               WriteByte (MSG_ALL,FL_SWIM);
               WriteByte (MSG_ALL,MOVETYPE_WALK);
               WriteByte (MSG_ALL,SVC_FINALE);
               WriteString (MSG_ALL,"The charred viscera of diabolic horrors\nbubble viscously as you seize the Rune\nof Hell Magic. Its heat scorches your\nhand, and its terrible secrets blight\nyour mind. Gathering the shreds of your\ncourage, you shake the devil's shackles\nfrom your soul, and become ever more\nhard and determined to destroy the\nhideous creatures whose mere existence\nthreatens the souls and psyches of all\nthe population of Earth.");
               return ;

            } else {

               if ( (world.model == "maps/e4m7.bsp") ) {

                  WriteByte (MSG_ALL,SVC_CDTRACK);
                  WriteByte (MSG_ALL,FL_SWIM);
                  WriteByte (MSG_ALL,MOVETYPE_WALK);
                  WriteByte (MSG_ALL,SVC_FINALE);
                  WriteString (MSG_ALL,"Despite the awful might of the Elder\nWorld, you have achieved the Rune of\nElder Magic, capstone of all types of\narcane wisdom. Beyond good and evil,\nbeyond life and death, the Rune\npulsates, heavy with import. Patient and\npotent, the Elder Being Shub-Niggurath\nweaves her dire plans to clear off all\nlife from the Earth, and bring her own\nfoul offspring to our world! For all the\ndwellers in these nightmare dimensions\nare her descendants! Once all Runes of\nmagic power are united, the energy\nbehind them will blast open the Gateway\nto Shub-Niggurath, and you can travel\nthere to foil the Hell-Mother's plots\ninperson.");
                  return ;

               } else {

                  if ( (world.model == "maps/r1m7.bsp") ) {

                     WriteByte (MSG_ALL,SVC_FINALE);
                     WriteString (MSG_ALL,"Victory! The Overlord's mangled\nremains are the evidence.  His evil\nWrath army?  Cast out to wander\naimlessly throughout time.\n\nAs the Slipgate fog surrounds you,\nthoughts rage into your consciousness:\nHas Quake's oppressive reign ended?\nIs it S..");
                     return ;

                  }

               }

            }

         }

      }
      if ( (world.model == "maps/hip1m4.bsp") ) {

         WriteByte (MSG_ALL,SVC_CDTRACK);
         WriteByte (MSG_ALL,MOVETYPE_TOSS);
         WriteByte (MSG_ALL,MOVETYPE_WALK);
         WriteByte (MSG_ALL,SVC_FINALE);
         WriteString (MSG_ALL,"Deep within the bowels of the\nResearch Facility, you discover the\npassage that the followers of Quake\nhave used to enter our world.\nThe bastards used some type of\ngigantic teleporter to overload\none of our own slipgates!  As long as\nthis portal ...");
         return ;

      } else {

         if ( (world.model == "maps/hip2m5.bsp") ) {

            WriteByte (MSG_ALL,SVC_CDTRACK);
            WriteByte (MSG_ALL,MOVETYPE_TOSS);
            WriteByte (MSG_ALL,MOVETYPE_WALK);
            WriteByte (MSG_ALL,SVC_FINALE);
            WriteString (MSG_ALL,"After destroying the power generator,\nyou pass beyond the gate of Mortum's\nKeep.  A wave of nausea suddenly flows\nover you and you find yourself cast\nout into a liquid void.  You float\nlifelessly, yet aware, in a lavender\nsea of energy.");
            return ;

         } else {

            if ( (world.model == "maps/hipend.bsp") ) {

               WriteByte (MSG_ALL,SVC_CDTRACK);
               WriteByte (MSG_ALL,FL_SWIM);
               WriteByte (MSG_ALL,MOVETYPE_WALK);
               WriteByte (MSG_ALL,SVC_FINALE);
               WriteString (MSG_ALL,"After the last echoes of Armagon's\ndeath yell fade away, you breathe a\nheavy sigh of relief.  With the loss\nof his magic, Armagon's fortress\nbegins to collapse.  The rift he\ncreated to send his grisly troops\nthrough time slowly closes and seals\n...");
               return ;

            }

         }

      }
      GotoNextMap ();

   }
   if ( (intermission_running == MOVETYPE_WALK) ) {

      if ( !cvar ("registered") ) {

         WriteByte (MSG_ALL,SVC_SELLSCREEN);
         return ;

      }
      if ( ((serverflags & CTF_CAPTURE_BONUS) == CTF_CAPTURE_BONUS) ) {

         WriteByte (MSG_ALL,SVC_FINALE);
         WriteString (MSG_ALL,"Now, you have all four Runes. You sense\ntremendous invisible forces moving to\nunseal ancient barriers. Shub-Niggurath\nhad hoped to use the Runes Herself to\nclear off the Earth, but now instead,\nyou will use them to enter her home and\nconfront her as an avatar of avenging\nEarth-life. If you defeat her, you will\nbe remembered forever as the savior of\nthe planet. If she conquers, it will be\nas if you had never been born.");
         return ;

      }
      if ( (world.model == "maps/hip1m4.bsp") ) {

         WriteByte (MSG_ALL,SVC_FINALE);
         WriteString (MSG_ALL,"If you can find the source of the\nportal's power, you can shut it\ndown--possibly forever!  With only a\nmoment's consideration for your own\nsafety, you re-enter the dark domain,\nknowing Hell would be a better fate\nthan experiencing the reign of Q...");
         return ;

      } else {

         if ( (world.model == "maps/hip2m5.bsp") ) {

            WriteByte (MSG_ALL,SVC_FINALE);
            WriteString (MSG_ALL,"After what seems like an eternity,\nyou feel the presence of a diabolical\nintelligence.  You are held helpless\nfor a moment as your mind is open to\nthat of Armagon--Quake's General and\nmaster of this realm.  Recognizing\nyou as the one who foiled ...");
            return ;

         } else {

            if ( (world.model == "maps/hipend.bsp") ) {

               WriteByte (MSG_ALL,SVC_FINALE);
               WriteString (MSG_ALL,"Congratulations!  You are victorious!\nThe minions of Quake have once again\nfallen before your mighty hand.\nIs this the last you will see of\nQuake's hellions?\n\nOnly time will tell...");
               intermission_exittime = (time + 10000000.000);
               return ;

            }

         }

      }

   }
   GotoNextMap ();

};

void () IntermissionThink = {

   if ( (time < intermission_exittime) ) {

      return ;

   }
   if ( ((!self.button0 && !self.button1) && !self.button2) ) {

      return ;

   }
   ExitIntermission ();

};

void () execute_changelevel = {

   local entity pos;

   intermission_running = TRUE;
   if ( deathmatch ) {

      intermission_exittime = (time + MOVETYPE_FLY);

   } else {

      intermission_exittime = (time + FL_SWIM);

   }
   WriteByte (MSG_ALL,SVC_CDTRACK);
   WriteByte (MSG_ALL,MOVETYPE_WALK);
   WriteByte (MSG_ALL,MOVETYPE_WALK);
   pos = FindIntermission ();
   other = find (world,classname,"player");
   while ( (other != world) ) {

      other.view_ofs = VEC_ORIGIN;
      other.v_angle = pos.mangle;
      other.angles = pos.mangle;
      other.fixangle = TRUE;
      other.nextthink = (time + 0.500);
      other.takedamage = DAMAGE_NO;
      other.solid = SOLID_NOT;
      other.movetype = MOVETYPE_NONE;
      other.modelindex = FALSE;
      setorigin (other,pos.origin);
      other = find (other,classname,"player");

   }
   WriteByte (MSG_ALL,SVC_INTERMISSION);

};

void () changelevel_touch = {

   if ( (other.classname != "player") ) {

      return ;

   }
   if ( ((cvar ("noexit") == TRUE) || ((cvar ("noexit") == FL_SWIM) && (mapname != "start"))) ) {

      T_Damage (other,self,self,50000.000);
      return ;

   }
   if ( (coop || deathmatch) ) {

      bprint (other.netname);
      bprint (" exited the level\n");

   }
   nextmap = self.map;
   SUB_UseTargets ();
   if ( ((self.spawnflags & TRUE) && (deathmatch == FALSE)) ) {

      GotoNextMap ();
      return ;

   }
   self.touch = SUB_Null;
   self.think = execute_changelevel;
   self.nextthink = (time + 0.100);

};

void () trigger_changelevel = {

   if ( !self.map ) {

      objerror ("chagnelevel trigger doesn't have map");

   }
   InitTrigger ();
   self.touch = changelevel_touch;

};

void () set_suicide_frame;

void () respawn = {

   if ( coop ) {

      CopyToBodyQue (self);
      setspawnparms (self);
      PutClientInServer ();

   } else {

      if ( deathmatch ) {

         CopyToBodyQue (self);
         SetNewParms ();
         PutClientInServer ();

      } else {

         localcmd ("restart\n");

      }

   }

};

void () ClientKill = {

   local entity vSphere;

   if ( (self.suicide_count > MOVETYPE_WALK) ) {

      sprint (self,"You have suicided too much already.\n");
      return ;

   }
   TeamDropFlagOfPlayer (self);
   self.suicide_count = (self.suicide_count + TRUE);
   if ( (tag_token_owner == self) ) {

      self.health = FALSE;
      self.solid = SOLID_NOT;
      tag_token_drop ();

   }
   if ( (self.items2 & IT2_V_SPHERE) ) {

      vSphere = find (world,classname,"Vengeance");
      while ( vSphere ) {

         if ( (vSphere.owner == self) ) {

            remove (vSphere);

         }
         vSphere = find (vSphere,classname,"Vengeance");

      }

   }
   bprint (self.netname);
   bprint (" suicides\n");
   set_suicide_frame ();
   self.modelindex = modelindex_player;
   self.frags = (self.frags - FL_SWIM);
   respawn ();

};
float (vector v) CheckSpawnPoint = {

   return ( FALSE );

};
entity () SelectSpawnPoint = {

   local entity spot;
   local entity thing;
   local float pcount;
   local entity startspot;
   local float t;

   spot = find (world,classname,"testplayerstart");
   if ( spot ) {

      return ( spot );

   }
   if ( coop ) {

      lastspawn = find (lastspawn,classname,"info_player_coop");
      if ( (lastspawn == world) ) {

         lastspawn = find (lastspawn,classname,"info_player_start");

      }
      if ( (lastspawn != world) ) {

         return ( lastspawn );

      }

   } else {

      if ( deathmatch ) {

         spot = lastspawn;
         startspot = lastspawn;
         t = FALSE;
         if ( (!self.ctf_killed && (teamplay >= TEAM_CTF)) ) {

            if ( (self.steam == TEAM1) ) {

               spot = team1_lastspawn;
               startspot = team1_lastspawn;
               t = TEAM1;

            } else {

               if ( (self.steam == TEAM2) ) {

                  spot = team2_lastspawn;
                  startspot = team2_lastspawn;
                  t = TEAM2;

               }

            }

         }
         while ( TRUE ) {

            if ( (t == TEAM1) ) {

               spot = find (spot,classname,"info_player_team1");

            } else {

               if ( (t == TEAM2) ) {

                  spot = find (spot,classname,"info_player_team2");

               } else {

                  spot = find (spot,classname,"info_player_deathmatch");

               }

            }
            if ( (spot != world) ) {

               if ( (spot == startspot) ) {

                  return ( startspot );

               }
               pcount = FALSE;
               thing = findradius (spot.origin,FL_MONSTER);
               while ( thing ) {

                  if ( (thing.classname == "player") ) {

                     pcount = (pcount + TRUE);

                  }
                  thing = thing.chain;

               }
               if ( (pcount == FALSE) ) {

                  if ( (t == TEAM1) ) {

                     team1_lastspawn = spot;

                  } else {

                     if ( (t == TEAM2) ) {

                        team2_lastspawn = spot;

                     } else {

                        lastspawn = spot;

                     }

                  }
                  return ( spot );

               }

            } else {

               t = FALSE;

            }

         }

      }

   }
   if ( serverflags ) {

      spot = find (world,classname,"info_player_start2");
      if ( spot ) {

         return ( spot );

      }

   }
   spot = find (world,classname,"info_player_start");
   if ( !spot ) {

      error ("PutClientInServer: no info_player_start on level");

   }
   return ( spot );

};

void () PlayerDie;
void () player_touch;

void () PutClientInServer = {

   local entity spot;

   self.classname = "player";
   self.health = 100.000;
   self.takedamage = DAMAGE_AIM;
   self.solid = SOLID_SLIDEBOX;
   self.movetype = MOVETYPE_WALK;
   self.show_hostile = FALSE;
   self.max_health = 100.000;
   self.flags = FL_CLIENT;
   self.air_finished = (time + STAT_TOTALMONSTERS);
   self.dmg = FL_SWIM;
   self.super_damage_finished = FALSE;
   self.radsuit_finished = FALSE;
   self.invisible_finished = FALSE;
   self.invincible_finished = FALSE;
   self.effects = FALSE;
   self.invincible_time = FALSE;
   self.wetsuit_finished = FALSE;
   self.empathy_finished = FALSE;
   self.shield_finished = FALSE;
   self.antigrav_finished = FALSE;
   self.gravity = TRUE;
   self.ctf_lastreturnedflag = -10.000;
   self.ctf_lastfraggedcarrier = -10.000;
   self.ctf_flagsince = -10.000;
   self.ctf_lasthurtcarrier = -10.000;
   DecodeLevelParms ();
   spot = SelectSpawnPoint ();
   W_SetCurrentAmmo ();
   self.attack_finished = time;
   self.th_pain = player_pain;
   self.th_die = PlayerDie;
   self.deadflag = DEAD_NO;
   self.pausetime = FALSE;
   self.origin = (spot.origin + '0.000 0.000 1.000');
   self.angles = spot.angles;
   self.fixangle = TRUE;
   self.touch = player_touch;
   setmodel (self,"progs/playham.mdl");
   modelindex_hammer = self.modelindex;
   setmodel (self,"progs/eyes.mdl");
   modelindex_eyes = self.modelindex;
   setmodel (self,"progs/player.mdl");
   modelindex_player = self.modelindex;
   setsize (self,VEC_HULL_MIN,VEC_HULL_MAX);
   self.view_ofs = '0.000 0.000 22.000';
   player_stand1 ();
   if ( (deathmatch || coop) ) {

      makevectors (self.angles);
      spawn_tfog ((self.origin + (v_forward * 20.000)));

   }
   self.on_hook = FALSE;
   self.hook_out = FALSE;
   spawn_tdeath (self.origin,self);

};

void () info_player_start = {};

void () info_player_start2 = {};

void () testplayerstart = {};

void () info_player_deathmatch = {

	SpawnRunes ();

};

void () info_player_coop = {};

void () NextLevel = {

   local entity o;

   if ( (mapname == "start") ) {

      if ( !cvar ("registered") ) {

         mapname = "e1m1";

      } else {

         if ( !(serverflags & TRUE) ) {

            mapname = "e1m1";
            serverflags = (serverflags | TRUE);

         } else {

            if ( !(serverflags & FL_SWIM) ) {

               mapname = "e2m1";
               serverflags = (serverflags | FL_SWIM);

            } else {

               if ( !(serverflags & MOVETYPE_STEP) ) {

                  mapname = "e3m1";
                  serverflags = (serverflags | MOVETYPE_STEP);

               } else {

                  if ( !(serverflags & FL_CLIENT) ) {

                     mapname = "e4m1";
                     serverflags = (serverflags - MOVETYPE_PUSH);

                  } else {

                     if ( (mapname == "rogstart") ) {

                        mapname = "r1m1";

                     } else {

                        if ( (mapname == "hipstart") ) {

                           mapname = "hip1m1";

                        }

                     }

                  }

               }

            }

         }

      }
      o = spawn ();
      o.map = mapname;

   } else {

      o = find (world,classname,"trigger_changelevel");
      if ( !o ) {

         mapname = "start";
         o = spawn ();
         o.map = mapname;

      }

   }
   nextmap = o.map;
   gameover = TRUE;
   if ( (o.nextthink < time) ) {

      o.think = execute_changelevel;
      o.nextthink = (time + 0.100);

   }

};

void () CheckRules = {

   local float timelimit;
   local float fraglimit;

   if ( gameover ) {

      return ;

   }
   timelimit = (cvar ("timelimit") * 60.000);
   fraglimit = cvar ("fraglimit");
   if ( (timelimit && (time >= timelimit)) ) {

      NextLevel ();
      return ;

   }
   if ( (fraglimit && (self.frags >= fraglimit)) ) {

      NextLevel ();
      return ;

   }
   TeamCheckUpdate ();

};

void () PlayerDeathThink = {

   local float forward;

   if ( (self.flags & FL_ONGROUND) ) {

      forward = vlen (self.velocity);
      forward = (forward - 20.000);
      if ( (forward <= FALSE) ) {

         self.velocity = VEC_ORIGIN;

      } else {

         self.velocity = (forward * normalize (self.velocity));

      }

   }
   if ( (self.deadflag == DEAD_DEAD) ) {

      if ( ((self.button2 || self.button1) || self.button0) ) {

         return ;

      }
      self.deadflag = DEAD_RESPAWNABLE;
      return ;

   }
   if ( ((!self.button2 && !self.button1) && !self.button0) ) {

      return ;

   }
   self.button0 = FALSE;
   self.button1 = FALSE;
   self.button2 = FALSE;
   respawn ();

};

void () PlayerJump = {

   if ( (self.flags & FL_WATERJUMP) ) {

      return ;

   }
   if ( (self.waterlevel >= FL_SWIM) ) {

      if ( (self.watertype == CONTENT_WATER) ) {

         self.velocity_z = 100.000;

      } else {

         if ( (self.watertype == CONTENT_SLIME) ) {

            self.velocity_z = 80.000;

         } else {

            self.velocity_z = 50.000;

         }

      }
      if ( (self.swim_flag < time) ) {

         self.swim_flag = (time + TRUE);
         if ( (random () < 0.500) ) {

            sound (self,CHAN_BODY,"misc/water1.wav",TRUE,ATTN_NORM);

         } else {

            sound (self,CHAN_BODY,"misc/water2.wav",TRUE,ATTN_NORM);

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
   self.flags = (self.flags - (self.flags & FL_JUMPRELEASED));
   self.flags = (self.flags - FL_ONGROUND);
   self.button2 = FALSE;
   sound (self,CHAN_BODY,"player/plyrjmp8.wav",TRUE,ATTN_NORM);
   self.velocity_z = (self.velocity_z + 270.000);

};
.float dmgtime;

void () WaterMove = {

   if ( (self.movetype == MOVETYPE_NOCLIP) ) {

      return ;

   }
   if ( (self.health < FALSE) ) {

      return ;

   }
   if ( (self.waterlevel != MOVETYPE_WALK) ) {

      if ( (self.air_finished < time) ) {

         sound (self,CHAN_VOICE,"player/gasp2.wav",TRUE,ATTN_NORM);

      } else {

         if ( (self.air_finished < (time + MOVETYPE_FLYMISSILE)) ) {

            sound (self,CHAN_VOICE,"player/gasp1.wav",TRUE,ATTN_NORM);

         }

      }
      self.air_finished = (time + STAT_TOTALMONSTERS);
      self.dmg = FL_SWIM;

   } else {

      if ( (self.air_finished < time) ) {

         if ( (self.pain_finished < time) ) {

            self.dmg = (self.dmg + FL_SWIM);
            if ( (self.dmg > CTF_CAPTURE_BONUS) ) {

               self.dmg = MOVETYPE_BOUNCE;

            }
            T_Damage (self,world,world,self.dmg);
            self.pain_finished = (time + TRUE);

         }

      }

   }
   if ( !self.waterlevel ) {

      if ( (self.flags & FL_INWATER) ) {

         sound (self,CHAN_BODY,"misc/outwater.wav",TRUE,ATTN_NORM);
         self.flags = (self.flags - FL_INWATER);

      }
      return ;

   }
   if ( (self.watertype == CONTENT_LAVA) ) {

      if ( (self.dmgtime < time) ) {

         if ( (self.radsuit_finished > time) ) {

            self.dmgtime = (time + TRUE);

         } else {

            self.dmgtime = (time + 0.200);

         }
         T_Damage (self,world,world,(MOVETYPE_TOSS * self.waterlevel));

      }

   } else {

      if ( (self.watertype == CONTENT_SLIME) ) {

         if ( ((self.dmgtime < time) && (self.radsuit_finished < time)) ) {

            self.dmgtime = (time + TRUE);
            T_Damage (self,world,world,(MOVETYPE_STEP * self.waterlevel));

         }

      }

   }
   if ( !(self.flags & FL_INWATER) ) {

      if ( (self.watertype == CONTENT_LAVA) ) {

         sound (self,CHAN_BODY,"player/inlava.wav",TRUE,ATTN_NORM);

      }
      if ( (self.watertype == CONTENT_WATER) ) {

         sound (self,CHAN_BODY,"player/inh2o.wav",TRUE,ATTN_NORM);

      }
      if ( (self.watertype == CONTENT_SLIME) ) {

         sound (self,CHAN_BODY,"player/slimbrn2.wav",TRUE,ATTN_NORM);

      }
      self.flags = (self.flags + FL_INWATER);
      self.dmgtime = FALSE;

   }
   if ( !(self.flags & FL_WATERJUMP) ) {

      self.velocity = (self.velocity - (((0.800 * self.waterlevel) * frametime) * self.velocity));

   }

};

void () CheckWaterJump = {

   local vector start;
   local vector end;

   makevectors (self.angles);
   start = self.origin;
   start_z = (start_z + FL_CLIENT);
   v_forward_z = FALSE;
   normalize (v_forward);
   end = (start + (v_forward * 24.000));
   traceline (start,end,TRUE,self);
   if ( (trace_fraction < TRUE) ) {

      start_z = ((start_z + self.maxs_z) - FL_CLIENT);
      end = (start + (v_forward * 24.000));
      self.movedir = (trace_plane_normal * -50.000);
      traceline (start,end,TRUE,self);
      if ( (trace_fraction == TRUE) ) {

         self.flags = (self.flags | FL_WATERJUMP);
         self.velocity_z = 225.000;
         self.flags = (self.flags - (self.flags & FL_JUMPRELEASED));
         self.teleport_time = (time + FL_SWIM);
         return ;

      }

   }

};

void (float num_bubbles) DeathBubbles;

void () PlayerPreThink = {

   if ( intermission_running ) {

      IntermissionThink ();
      return ;

   }
   if ( (self.view_ofs == VEC_ORIGIN) ) {

      return ;

   }
   if ( earthquake_active ) {

      if ( (self.flags & FL_ONGROUND) ) {

         self.velocity_x = ((self.velocity_x + ((random () * earthquake_intensity) * FL_SWIM)) - earthquake_intensity);
         self.velocity_y = ((self.velocity_y + ((random () * earthquake_intensity) * FL_SWIM)) - earthquake_intensity);
         self.velocity_z = ((self.velocity_z + ((random () * earthquake_intensity) * FL_SWIM)) - earthquake_intensity);

      }

   }
   earthquake_prethink ();
   makevectors (self.v_angle);
   TeamCheckLock ();
   CheckMOTD ();
   CheckRules ();
   WaterMove ();
   if ( (self.wetsuit_finished > time) ) {

      if ( (self.waterlevel == FL_SWIM) ) {

         self.velocity = (self.velocity * 1.250);

      }
      if ( (self.waterlevel == MOVETYPE_WALK) ) {

         self.velocity = (self.velocity * 1.500);

      }
      if ( (self.waterlevel >= FL_SWIM) ) {

         if ( (self.swim_flag < time) ) {

            self.swim_flag = (time + MOVETYPE_PUSH);
            sound (self,CHAN_BODY,"misc/wetsuit.wav",TRUE,ATTN_NORM);

         } else {

            if ( (fabs (((self.swim_flag - time) - MOVETYPE_TOSS)) < 0.040) ) {

               DeathBubbles (TRUE);

            } else {

               if ( (fabs (((self.swim_flag - time) - 5.500)) < 0.040) ) {

                  DeathBubbles (TRUE);

               } else {

                  if ( (fabs (((self.swim_flag - time) - MOVETYPE_FLY)) < 0.040) ) {

                     DeathBubbles (TRUE);

                  }

               }

            }

         }

      }

   }
   if ( (self.waterlevel == FL_SWIM) ) {

      CheckWaterJump ();

   }
   if ( (self.deadflag >= DEAD_DEAD) ) {

      PlayerDeathThink ();
      return ;

   }
   if ( (self.deadflag == DEAD_DYING) ) {

      return ;

   }
   if ( self.button2 ) {

      PlayerJump ();

   } else {

      self.flags = (self.flags | FL_JUMPRELEASED);

   }
   if ( (time < self.pausetime) ) {

      self.velocity = VEC_ORIGIN;

   }
   if ( ((((time > self.attack_finished) && (self.currentammo == FALSE)) && (self.weapon != IT_AXE)) && (self.weapon != IT2_MJOLNIR)) ) {

      self.weapon = W_BestWeapon ();
      W_SetCurrentAmmo ();

   }
   if ( (self.items2 & IT2_ANTIGRAV) ) {

      if ( (time > self.AGping) ) {

         sound (self,CHAN_AUTO,"belt/use.wav",0.400,ATTN_NORM);
         self.AGping = (time + MOVETYPE_WALK);
         if ( (self.AGping >= (self.antigrav_finished - MOVETYPE_WALK)) ) {

            self.AGping = (self.antigrav_finished + MOVETYPE_WALK);

         }

      }

   }
   RuneApplyElder (self);
   if ( self.hook_out ) {

      GrappleService ();

   }

};

void () CheckPowerups = {

   if ( (self.health <= FALSE) ) {

      return ;

   }
   if ( self.invisible_finished ) {

      if ( (self.invisible_sound < time) ) {

         sound (self,CHAN_AUTO,"items/inv3.wav",0.500,ATTN_IDLE);
         self.invisible_sound = (time + ((random () * MOVETYPE_WALK) + TRUE));

      }
      if ( (self.invisible_finished < (time + MOVETYPE_WALK)) ) {

         if ( (self.invisible_time == TRUE) ) {

            sprint (self,"Ring of Shadows magic is fading\n");
            stuffcmd (self,"bf\n");
            sound (self,CHAN_AUTO,"items/inv2.wav",TRUE,ATTN_NORM);
            self.invisible_time = (time + TRUE);

         }
         if ( (self.invisible_time < time) ) {

            self.invisible_time = (time + TRUE);
            stuffcmd (self,"bf\n");

         }

      }
      if ( (self.invisible_finished < time) ) {

         self.items = (self.items - IT_INVISIBILITY);
         self.invisible_finished = FALSE;
         self.invisible_time = FALSE;

      }
      self.frame = FALSE;
      self.modelindex = modelindex_eyes;

   } else {

      if ( (self.weapon == IT2_MJOLNIR) ) {

         self.modelindex = modelindex_hammer;

      } else {

         self.modelindex = modelindex_player;

      }

   }
   if ( self.invincible_finished ) {

      if ( (self.invincible_finished < (time + MOVETYPE_WALK)) ) {

         if ( (self.invincible_time == TRUE) ) {

            sprint (self,"Protection is almost burned out\n");
            stuffcmd (self,"bf\n");
            sound (self,CHAN_AUTO,"items/protect2.wav",TRUE,ATTN_NORM);
            self.invincible_time = (time + TRUE);

         }
         if ( (self.invincible_time < time) ) {

            self.invincible_time = (time + TRUE);
            stuffcmd (self,"bf\n");

         }

      }
      if ( (self.invincible_finished < time) ) {

         self.items = (self.items - IT_INVULNERABILITY);
         self.invincible_time = FALSE;
         self.invincible_finished = FALSE;

      }
      if ( (self.invincible_finished > time) ) {

         self.effects = (self.effects | EF_DIMLIGHT);

      } else {

         self.effects = (self.effects - (self.effects & EF_DIMLIGHT));

      }

   }
   if ( self.super_damage_finished ) {

      if ( (self.super_damage_finished < (time + MOVETYPE_WALK)) ) {

         if ( (self.super_time == TRUE) ) {

            sprint (self,"Quad Damage is wearing off\n");
            stuffcmd (self,"bf\n");
            sound (self,CHAN_AUTO,"items/damage2.wav",TRUE,ATTN_NORM);
            self.super_time = (time + TRUE);

         }
         if ( (self.super_time < time) ) {

            self.super_time = (time + TRUE);
            stuffcmd (self,"bf\n");

         }

      }
      if ( (self.super_damage_finished < time) ) {

         self.items = (self.items - IT_QUAD);
         self.super_damage_finished = FALSE;
         self.super_time = FALSE;

      }
      if ( (self.super_damage_finished > time) ) {

         self.effects = (self.effects | EF_DIMLIGHT);

      } else {

         self.effects = (self.effects - (self.effects & EF_DIMLIGHT));

      }

   }
   if ( self.radsuit_finished ) {

      self.air_finished = (time + STAT_TOTALMONSTERS);
      if ( (self.radsuit_finished < (time + MOVETYPE_WALK)) ) {

         if ( (self.rad_time == TRUE) ) {

            sprint (self,"Air supply in Biosuit expiring\n");
            stuffcmd (self,"bf\n");
            sound (self,CHAN_AUTO,"items/suit2.wav",TRUE,ATTN_NORM);
            self.rad_time = (time + TRUE);

         }
         if ( (self.rad_time < time) ) {

            self.rad_time = (time + TRUE);
            stuffcmd (self,"bf\n");

         }

      }
      if ( (self.radsuit_finished < time) ) {

         self.items = (self.items - IT_SUIT);
         self.rad_time = FALSE;
         self.radsuit_finished = FALSE;

      }

   }
   if ( self.wetsuit_finished ) {

      self.air_finished = (time + STAT_TOTALMONSTERS);
      if ( (self.wetsuit_finished < (time + MOVETYPE_WALK)) ) {

         if ( (self.wetsuit_time == TRUE) ) {

            sprint (self,"Air supply in Wetsuit is running out\n");
            stuffcmd (self,"bf\n");
            sound (self,CHAN_AUTO,"items/suit2.wav",TRUE,ATTN_NORM);
            self.wetsuit_time = (time + TRUE);

         }
         if ( (self.wetsuit_time < time) ) {

            self.wetsuit_time = (time + TRUE);
            stuffcmd (self,"bf\n");

         }

      }
      if ( (self.wetsuit_finished < time) ) {

         self.items2 = (self.items2 - HIP_IT2_WETSUIT);
         self.wetsuit_time = FALSE;
         self.wetsuit_finished = FALSE;

      }

   }
   if ( self.empathy_finished ) {

      if ( (self.empathy_finished < (time + MOVETYPE_WALK)) ) {

         if ( (self.empathy_time == TRUE) ) {

            sprint (self,"Empathy Shields are running out\n");
            stuffcmd (self,"bf\n");
            sound (self,CHAN_AUTO,"items/suit2.wav",TRUE,ATTN_NORM);
            self.empathy_time = (time + TRUE);

         }
         if ( (self.empathy_time < time) ) {

            self.empathy_time = (time + TRUE);
            stuffcmd (self,"bf\n");

         }

      }
      if ( (self.empathy_finished < time) ) {

         self.items2 = (self.items2 - HIP_IT2_EMPATHY_SHIELDS);
         self.empathy_time = FALSE;
         self.empathy_finished = FALSE;

      }
      if ( (self.empathy_finished > time) ) {

         self.effects = (self.effects | EF_DIMLIGHT);

      } else {

         self.effects = (self.effects - (self.effects & EF_DIMLIGHT));

      }

   }
   if ( self.shield_finished ) {

      if ( (self.shield_finished < (time + MOVETYPE_WALK)) ) {

         if ( (self.shield_time == TRUE) ) {

            sprint (self,"Shield failing...\n");
            sound (self,CHAN_AUTO,"shield/fadeout.wav",TRUE,ATTN_NORM);
            self.shield_time = FALSE;

         }
         if ( (self.shield_time < time) ) {

            self.shield_time = (time + TRUE);
            stuffcmd (self,"bf\n");

         }

      }
      if ( (self.shield_finished < time) ) {

         sprint (self,"Shield Lost.\n");
         self.shield_finished = FALSE;
         self.items2 = (self.items2 - IT2_SHIELD);

      }

   }
   if ( self.antigrav_finished ) {

      if ( (self.antigrav_finished < (time + MOVETYPE_WALK)) ) {

         if ( (self.antigrav_time == TRUE) ) {

            sprint (self,"Antigrav failing...\n");
            self.antigrav_time = FALSE;
            sound (self,CHAN_AUTO,"belt/fadeout.wav",TRUE,ATTN_NORM);

         }
         if ( (self.antigrav_time < time) ) {

            self.antigrav_time = (time + TRUE);
            stuffcmd (self,"bf\n");

         }

      }
      if ( (self.antigrav_finished < time) ) {

         sprint (self,"Antigrav Lost.\n");
         self.antigrav_finished = FALSE;
         self.items2 = (self.items2 - IT2_ANTIGRAV);
         self.gravity = TRUE;

      }

   }

};

void () xpackEnding;

void () PlayerPostThink = {

   if ( (self.view_ofs == VEC_ORIGIN) ) {

      earthquake_postthink ();
      return ;

   }
   if ( (self.wetsuit_finished > time) ) {

      if ( (self.waterlevel == FL_SWIM) ) {

         self.velocity = (self.velocity * 0.800);

      }
      if ( (self.waterlevel == MOVETYPE_WALK) ) {

         self.velocity = (self.velocity * 0.660);

      }

   }
   earthquake_postthink ();
   if ( self.deadflag ) {

      return ;

   }
   if ( cutscene_running ) {

      xpackEnding ();

   }
   W_WeaponFrame ();
   if ( (((self.jump_flag < -300.000) && (self.flags & FL_ONGROUND)) && (self.health > FALSE)) ) {

      if ( (self.watertype == CONTENT_WATER) ) {

         sound (self,CHAN_BODY,"player/h2ojump.wav",TRUE,ATTN_NORM);

      } else {

         if ( (self.jump_flag < -650.000) ) {

            T_Damage (self,world,world,MOVETYPE_FLY);
            sound (self,CHAN_VOICE,"player/land2.wav",TRUE,ATTN_NORM);
            self.deathtype = "falling";

         } else {

            sound (self,CHAN_VOICE,"player/land.wav",TRUE,ATTN_NORM);

         }

      }
      self.jump_flag = FALSE;

   }
   if ( !(self.flags & FL_ONGROUND) ) {

      self.jump_flag = self.velocity_z;

   }
   CheckPowerups ();

};

void () ClientConnect = {

   bprint (self.netname);
   bprint (" entered the game\n");
   self.suicide_count = FALSE;
   self.ctf_killed = FALSE;
   SetMOTD ();
   if ( ((parm14 < FALSE) && (teamplay > FALSE)) ) {

      if ( (cvar ("gamecfg") & GAMECFG_USE_COLOR) ) {

         self.steam = self.team;

      } else {

         self.steam = -50.000;

      }
      TeamCheckLock ();

   }
   if ( intermission_running ) {

      ExitIntermission ();

   }

};

void () ClientDisconnect = {

   if ( gameover ) {

      return ;

   }
   bprint (self.netname);
   bprint (" left the game with ");
   bprint (ftos (self.frags));
   bprint (" frags\n");
   sound (self,CHAN_BODY,"player/tornoff2.wav",TRUE,ATTN_NONE);
   sphere_remove (self);
   if ( (tag_token_owner == self) ) {

      tag_token_drop ();

   }
   TeamDropFlagOfPlayer (self);
   self.steam = -50.000;
   self.team = FALSE;
   set_suicide_frame ();

};

void (entity targ, entity attacker) ClientObituary = {

   local float rnum;
   local string deathstring;
   local string deathstring2;

   rnum = random ();
   if ( (targ.classname == "player") ) {

      TeamResetCarrier (targ);
      if ( (attacker.classname == "teledeath") ) {

         bprint (targ.netname);
         bprint (" was telefragged by ");
         bprint (attacker.owner.netname);
         bprint ("\n");
         attacker.owner.frags = (attacker.owner.frags + TRUE);
         return ;

      }
      if ( (attacker.classname == "teledeath2") ) {

         bprint ("Satan's power deflects ");
         bprint (targ.netname);
         bprint ("'s telefrag\n");
         targ.frags = (targ.frags - TRUE);
         return ;

      }
      if ( (attacker.classname == "player") ) {

         if ( (targ == attacker) ) {

            attacker.frags = (attacker.frags - TRUE);
            bprint (targ.netname);
            if ( ((targ.weapon == FL_GODMODE) && (targ.waterlevel > TRUE)) ) {

               bprint (" discharges into the water.\n");
               return ;

            }
            if ( (targ.weapon == IT_GRENADE_LAUNCHER) || (targ.weapon == IT_MULTI_GRENADE) || (targ.weapon == IT2_PROXIMITY_GUN)) {

               bprint (" tries to put the pin back in\n");

            } else {

               if ( (teamplay && (targ.team != targ.steam)) ) {

                  if ( (cvar ("gamecfg") & GAMECFG_ALLOW_CHG) ) {

                     bprint (" changed teams\n");

                  } else {

                     bprint (" tried to change teams\n");

                  }

               } else {

                  if ( (rnum > 0.400) ) {

                     bprint (" becomes bored with life\n");

                  } else {

                     bprint (" checks if his weapon is loaded\n");

                  }

               }

            }
            return ;

         } else {

            if ( (((teamplay == FL_SWIM) && (targ.team > FALSE)) && (targ.team == attacker.team)) ) {

               if ( (rnum < 0.250) ) {

                  deathstring = " mows down a teammate\n";

               } else {

                  if ( (rnum < 0.500) ) {

                     deathstring = " checks his glasses\n";

                  } else {

                     if ( (rnum < 0.750) ) {

                        deathstring = " gets a frag for the other team\n";

                     } else {

                        deathstring = " loses another friend\n";

                     }

                  }

               }
               bprint (attacker.netname);
               bprint (deathstring);
               attacker.frags = (attacker.frags - TRUE);
               return ;

            } else {

               if ( (teamplay == TEAM_DMATCH_TAG) ) {

                  dmatch_score (targ,attacker);

               } else {

                  attacker.frags = (attacker.frags + TRUE);
                  TeamAssists (targ,attacker);

               }
               if ( (empathyused == TRUE) ) {

                  bprint (targ.netname);
                  if ( (random () < 0.500) ) {

                     bprint (" shares ");

                  } else {

                     bprint (" feels ");

                  }
                  bprint (attacker.netname);
                  bprint ("'s pain\n");
                  return ;

               }
               if ( (targ.dmg_inflictor.classname == "proximity_grenade") ) {

                  bprint (targ.netname);
                  if ( (random () < 0.500) ) {

                     bprint (" got too friendly with ");

                  } else {

                     bprint (" did the rhumba with ");

                  }
                  bprint (attacker.netname);
                  bprint ("'s bomb\n");
                  return ;

               }
               rnum = attacker.weapon;
               if ( (rnum == IT_AXE) ) {

                  deathstring = " was ax-murdered by ";
                  deathstring2 = "\n";

               }
               if ( (rnum == IT_GRAPPLE) ) {

                  deathstring = " was grappled by ";
                  deathstring2 = "\n";

               }
               if ( (rnum == IT_SHOTGUN) ) {

                  deathstring = " chewed on ";
                  deathstring2 = "'s boomstick\n";

               }
               if ( (rnum == IT_SUPER_SHOTGUN) ) {

                  deathstring = " ate 2 loads of ";
                  deathstring2 = "'s buckshot\n";

               }
               if ( (rnum == IT_NAILGUN) ) {

                  deathstring = " was nailed by ";
                  deathstring2 = "\n";

               }
               if ( (rnum == IT_SUPER_NAILGUN) ) {

                  deathstring = " was punctured by ";
                  deathstring2 = "\n";

               }
               if ( (rnum == IT_GRENADE_LAUNCHER) ) {

                  deathstring = " eats ";
                  deathstring2 = "'s pineapple\n";
                  if ( (targ.health < -40.000) ) {

                     deathstring = " was gibbed by ";
                     deathstring2 = "'s grenade\n";

                  }

               }
               if ( (rnum == IT_ROCKET_LAUNCHER) ) {

                  deathstring = " rides ";
                  deathstring2 = "'s rocket\n";
                  if ( (targ.health < -40.000) ) {

                     deathstring = " was gibbed by ";
                     deathstring2 = "'s rocket\n";

                  }

               }
               if ( (rnum == IT_LIGHTNING) ) {

                  deathstring = " accepts ";
                  if ( (attacker.waterlevel > TRUE) ) {

                     deathstring2 = "'s discharge\n";

                  } else {

                     deathstring2 = "'s shaft\n";

                  }

               }
               if ( ((rnum == IT_LAVA_NAILGUN) || (rnum == IT_LAVA_SUPER_NAILGUN)) ) {

                  deathstring = " was burned by ";
                  deathstring2 = "\n";

               } else {

                  if ( (rnum == IT_PLASMA_GUN) ) {

                     deathstring = " was fused by ";
                     deathstring2 = "\n";

                  } else {

                     if ( ((rnum == IT_MULTI_GRENADE) || (rnum == IT_MULTI_ROCKET)) ) {

                        deathstring = " was blasted to bits by ";
                        deathstring2 = "\n";

                     }

                  }

               }
               if ( (rnum == IT2_LASER_CANNON) ) {

                  if ( (random () < 0.500) ) {

                     deathstring = " was toasted by ";

                  } else {

                     deathstring = " was radiated by ";

                  }
                  deathstring2 = "'s laser\n";

               }
               if ( (rnum == IT2_MJOLNIR) ) {

                  if ( (random () < 0.500) ) {

                     deathstring = " was slammed by ";
                     deathstring2 = "'s hammer\n";

                  } else {

                     deathstring = " felt the power of ";
                     deathstring2 = "'s mighty hammer\n";

                  }

               }
               bprint (targ.netname);
               bprint (deathstring);
               bprint (attacker.netname);
               bprint (deathstring2);

            }

         }
         return ;

      } else {

         targ.frags = (targ.frags - TRUE);
         bprint (targ.netname);
         if ( (attacker.flags & FL_MONSTER) ) {

            if ( (attacker.classname == "monster_army") ) {

               bprint (" was shot by a Grunt\n");

            }
            if ( (attacker.classname == "monster_demon1") ) {

               bprint (" was eviscerated by a Fiend\n");

            }
            if ( (attacker.classname == "monster_dog") ) {

               bprint (" was mauled by a Rottweiler\n");

            }
            if ( (attacker.classname == "monster_dragon") ) {

               if ( (random () < 0.500) ) {

                  bprint (" was annihilated by a Dragon\n");

               } else {

                  bprint (" was fried by a Dragon\n");

               }

            }
            if ( (attacker.classname == "monster_dragon_dead") ) {

               bprint (" was squashed by a Dragon\n");

            }
            if ( (attacker.classname == "monster_enforcer") ) {

               bprint (" was blasted by an Enforcer\n");

            }
            if ( (attacker.classname == "monster_fish") ) {

               bprint (" was fed to the Rotfish\n");

            }
            if ( (attacker.classname == "monster_hell_knight") ) {

               bprint (" was slain by a Death Knight\n");

            }
            if ( (attacker.classname == "monster_knight") ) {

               bprint (" was slashed by a Knight\n");

            }
            if ( (attacker.classname == "monster_ogre") ) {

               bprint (" was destroyed by an Ogre\n");

            }
            if ( (attacker.classname == "monster_oldone") ) {

               bprint (" became one with Shub-Niggurath\n");

            }
            if ( (attacker.classname == "monster_shalrath") ) {

               bprint (" was exploded by a Vore\n");

            }
            if ( (attacker.classname == "monster_shambler") ) {

               bprint (" was smashed by a Shambler\n");

            }
            if ( (attacker.classname == "monster_tarbaby") ) {

               bprint (" was slimed by a Spawn\n");

            }
            if ( (attacker.classname == "monster_slimespawn") ) {

               bprint (" was slimed by a Slime Spawn\n");

            }
            if ( (attacker.classname == "monster_wizard") ) {

               bprint (" was scragged by a Scrag\n");

            }
            if ( (attacker.classname == "monster_zombie") ) {

               bprint (" joins the Zombies\n");

            }
            if ( (attacker.classname == "monster_eel") ) {

               bprint (" was electrified by an Eel\n");

            }
            if ( (attacker.classname == "monster_wrath") ) {

               bprint (" was disintegrated by a Wrath\n");

            }
            if ( (attacker.classname == "monster_super_wrath") ) {

               bprint (" was obliterated by an Overlord\n");

            }
            if ( (attacker.classname == "monster_sword") ) {

               bprint (" was slit open by a Phantom Swordsman\n");

            }
            if ( (attacker.classname == "monster_lava_man") ) {

               bprint (" fries in Hephaestus' fury\n");

            }
            if ( (attacker.classname == "monster_morph") ) {

               bprint (" was crushed by a Guardian\n");

            }
            if ( (attacker.classname == "monster_mummy") ) {

               bprint (" was Mummified\n");

            }
            if ( (attacker.classname == "monster_gremlin") ) {

               bprint (" was outsmarted by a Gremlin\n");

            }
            if ( (attacker.classname == "monster_scourge") ) {

               bprint (" was stung by a Centroid\n");

            }
            if ( (attacker.classname == "monster_armagon") ) {

               bprint (" was outgunned by Armagon\n");

            }
            return ;

         }
         if ( (attacker.classname == "explo_box") ) {

            bprint (" blew up\n");
            return ;

         }
         if ( ((attacker.solid == SOLID_BSP) && (attacker != world)) ) {

            bprint (" was squished\n");
            return ;

         }
         if ( ((attacker.classname == "trap_shooter") || (attacker.classname == "trap_spikeshooter")) ) {

            bprint (" was spiked\n");
            return ;

         }
         if ( (attacker.classname == "fireball") ) {

            bprint (" ate a lavaball\n");
            return ;

         }
         if ( (attacker.classname == "trigger_changelevel") ) {

            bprint (" tried to leave\n");
            return ;

         }
         if ( ((attacker.classname == "ltrail_start") || (attacker.classname == "ltrail_relay")) ) {

            bprint (" rode the lightning\n");
            return ;

         }
         if ( (attacker.classname == "pendulum") ) {

            bprint (" was cleaved in two\n");
            return ;

         }
         if ( (attacker.classname == "buzzsaw") ) {

            bprint (" was sliced to pieces\n");
            return ;

         }
         if ( (attacker.classname == "plasma") ) {

            bprint (" was turned to plasma\n");
            return ;

         }
         if ( (attacker.classname == "Vengeance") ) {

            targ.frags = (targ.frags + TRUE);
            bprint (" was purged by the Vengeance Sphere\n");
            return ;

         }
         if ( (attacker.classname == "power_shield") ) {

            targ.frags = (targ.frags + TRUE);
            attacker.owner.frags = (attacker.owner.frags + TRUE);
            TeamAssists (targ,attacker.owner);
            deathstring = " was smashed by ";
            deathstring2 = "\n";
            bprint (deathstring);
            bprint (attacker.owner.netname);
            bprint (deathstring2);
            return ;

         }
         rnum = targ.watertype;
         if ( (rnum == CONTENT_WATER) ) {

            if ( (random () < 0.500) ) {

               bprint (" sleeps with the fishes\n");

            } else {

               bprint (" sucks it down\n");

            }
            return ;

         } else {

            if ( (rnum == CONTENT_SLIME) ) {

               if ( (random () < 0.500) ) {

                  bprint (" gulped a load of slime\n");

               } else {

                  bprint (" can't exist on slime alone\n");

               }
               return ;

            } else {

               if ( (rnum == CONTENT_LAVA) ) {

                  if ( (targ.health < -15.000) ) {

                     bprint (" burst into flames\n");
                     return ;

                  }
                  if ( (random () < 0.500) ) {

                     bprint (" turned into hot slag\n");

                  } else {

                     bprint (" visits the Volcano God\n");

                  }
                  return ;

               }

            }

         }
         if ( (targ.deathtype == "falling") ) {

            targ.deathtype = "";
            bprint (" fell to his death\n");
            return ;

         }
         bprint (" died\n");

      }

   }

};

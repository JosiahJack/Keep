
void (entity targ, entity attacker) ClientObituary;

void (entity targ, entity attacker) Killed = {

   local entity oself;

   oself = self;
   self = targ;
   if ( (self.health < -99.000) ) {

      self.health = -99.000;

   }
   if ( ((self.movetype == MOVETYPE_PUSH) || (self.movetype == MOVETYPE_NONE)) ) {

      self.th_die ();
      self = oself;
      return ;

   }
   self.enemy = attacker;
   ClientObituary (self,attacker);
   self.takedamage = DAMAGE_NO;
   self.touch = SUB_Null;
   self.th_die ();
   self = oself;

};
void (entity targ, entity inflictor, entity attacker, float damage) T_Damage = {

   local vector dir;
   local entity oldself;
   local float save;
   local float take;

   if ( !targ.takedamage ) {

      return ;

   }
   damage_attacker = attacker;
   save = ceil ((targ.armortype * damage));
   if ( (save >= targ.armorvalue) ) {

      save = targ.armorvalue;
      targ.armortype = FALSE;
      targ.items = (targ.items - (targ.items & ((IT2_ARMOR1 | IT2_ARMOR2) | IT2_ARMOR3)));

   }
   targ.armorvalue = (targ.armorvalue - save);
   take = ceil ((damage - save));
   if ( (targ.flags & FL_CLIENT) ) {

      targ.dmg_take = (targ.dmg_take + take);
      targ.dmg_save = (targ.dmg_save + save);
      targ.dmg_inflictor = inflictor;

   }
   if ( ((inflictor != world) && (targ.movetype == MOVETYPE_WALK)) ) {

      dir = (targ.origin - ((inflictor.absmin + inflictor.absmax) * 0.500));
      dir = normalize (dir);
      targ.velocity = (targ.velocity + ((dir * damage) * FL_CLIENT));

   }
   if ( (targ.flags & FL_GODMODE) ) {

      return ;

   }
   if ( (targ.invincible_finished >= time) ) {

      if ( (self.invincible_sound < time) ) {

         sound (targ,CHAN_ITEM,"items/protect3.wav",TRUE,ATTN_NORM);
         self.invincible_sound = (time + FL_SWIM);

      }
      return ;

   }
   if ( (((teamplay == TRUE) && (targ.team > FALSE)) && (targ.team == attacker.team)) ) {

      return ;

   }
   targ.health = (targ.health - take);
   if ( (targ.health <= FALSE) ) {

      Killed (targ,attacker);
      return ;

   }
   oldself = self;
   self = targ;
   if ( self.th_pain ) {

      self.th_pain (attacker,take);
      if ( (skill == MOVETYPE_WALK) ) {

         self.pain_finished = (time + MOVETYPE_FLY);

      }

   }
   self = oldself;

};

void () player_pain;
void () player_stand1;
void (vector org) spawn_tfog;
void (vector org, entity death_owner) spawn_tdeath;

float modelindex_eyes /* = 0.000 */;
float modelindex_player /* = 0.000 */;
float intermission_running /* = 0.000 */;
float intermission_exittime /* = 0.000 */;

void () info_intermission = {};

void () SetChangeParms = {

   if ( (self.health <= FALSE) ) {

      SetNewParms ();
      return ;

   }
   self.items = IT_SHOTGUN;
   self.items2 = FALSE;
   self.gravity = TRUE;
   if ( (self.health > 100.000) ) {

      self.health = 100.000;

   }
   if ( (self.health < 50.000) ) {

      self.health = 50.000;

   }
   parm1 = self.items;
   parm2 = self.health;
   parm3 = self.armorvalue;
   parm9 = (self.armortype * 100.000);

};

void () SetNewParms = {

   parm1 = (IT_SHOTGUN);
   parm2 = 100.000;
   parm3 = FALSE;
   parm9 = FALSE;

};

void () DecodeLevelParms = {

   if ( serverflags ) {

      if ( (world.model == "maps/start.bsp") ) {

         SetNewParms ();

      }

   }
   self.items = parm1;
   self.health = parm2;
   self.armorvalue = parm3;
   self.armortype = (parm9 * 0.010);

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
   objerror ("FindIntermission: no spot");

};

string nextmap /* = "" */;

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

   local entity pos;

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
      SetNewParms ();
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

   bprint (self.netname);
   bprint (" suicides\n");
   set_suicide_frame ();
   self.modelindex = modelindex_player;
   respawn ();

};
entity () SelectSpawnPoint = {

   local entity spot;
   local entity thing;
   local float pcount;

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
         while ( TRUE ) {

            spot = find (spot,classname,"info_player_deathmatch");
            if ( (spot != world) ) {

               if ( (spot == lastspawn) ) {

                  return ( lastspawn );

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

                  lastspawn = spot;
                  return ( spot );

               }

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

void () PutClientInServer = {

   local entity spot;

   spot = SelectSpawnPoint ();
   self.classname = "player";
   self.health = 100.000;
   self.ammo_cells = self.flashlight_ammo;
   self.ammo_rockets = found_secrets;
   self.ammo_nails = total_monsters;
   self.ammo_shells = FALSE;
   self.takedamage = DAMAGE_AIM;
   self.solid = SOLID_SLIDEBOX;
   self.movetype = MOVETYPE_WALK;
   self.show_hostile = FALSE;
   self.max_health = 100.000;
   self.flags = FL_CLIENT;
   self.air_finished = (time + 12.000);
   self.dmg = FL_SWIM;
   self.super_damage_finished = FALSE;
   self.radsuit_finished = FALSE;
   self.therm_finished = FALSE;
   self.invincible_finished = FALSE;
   self.effects = FALSE;
   self.invincible_time = FALSE;
   self.wetsuit_finished = FALSE;
   self.empathy_finished = FALSE;
   self.shield_finished = FALSE;
   self.antigrav_finished = FALSE;
   self.items2 = FALSE;
   self.gravity = TRUE;
   DecodeLevelParms ();
   self.attack_finished = time;
   self.th_pain = player_pain;
   self.th_die = PlayerDie;
   self.deadflag = DEAD_NO;
   self.pausetime = FALSE;
   self.origin = (spot.origin + '0.000 0.000 1.000');
   self.angles = spot.angles;
   self.fixangle = TRUE;
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
   spawn_tdeath (self.origin,self);

};

void () info_player_start = {};
void () info_player_start2 = {};
void () info_player_deathmatch = {};
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

};

void () PlayerDeathThink = {

   local entity old_self;
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

   local vector start;
   local vector end;

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

            if ( (self.watertype == CONTENT_LADDER) ) {

               self.velocity_z = 24;

            } else {

               self.velocity_z = 50.000;

            }

         }

      }
      if ( (self.swim_flag < time) ) {

         self.swim_flag = (time + TRUE);
         if ( (random () < 0.500) ) {

            if ( (self.watertype != CONTENT_LADDER) ) {

               sound (self,CHAN_BODY,"misc/water1.wav",TRUE,ATTN_NORM);

            }

         } else {

            if ( (self.watertype != CONTENT_LADDER) ) {

               sound (self,CHAN_BODY,"misc/water2.wav",TRUE,ATTN_NORM);

            }

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

      if ( (self.watertype == CONTENT_LADDER) ) {

         self.air_finished = (time + 12.000);

      }
      if ( (self.air_finished < time) ) {

         sound (self,CHAN_VOICE,"player/gasp2.wav",TRUE,ATTN_NORM);

      } else {

         if ( (self.air_finished < (time + MOVETYPE_FLYMISSILE)) ) {

            sound (self,CHAN_VOICE,"player/gasp1.wav",TRUE,ATTN_NORM);

         }

      }
      self.air_finished = (time + 12.000);
      self.dmg = FL_SWIM;

   } else {

      if ( (self.watertype == CONTENT_LADDER) ) {

         self.air_finished = (time + 12.000);

      }
      if ( (self.air_finished < time) ) {

         if ( (self.pain_finished < time) ) {

            self.dmg = (self.dmg + FL_SWIM);
            if ( (self.dmg > 15.000) ) {

               self.dmg = MOVETYPE_BOUNCE;

            }
            T_Damage (self,world,world,self.dmg);
            self.pain_finished = (time + TRUE);

         }

      }

   }
   if ( !self.waterlevel ) {
      
      if ( (self.previous_content == CONTENT_LADDER) ) {

         self.flags = (self.flags - FL_INWATER);
         self.previous_content = FALSE;

      }
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
         if ( (self.therm_finished < time) ) {

            T_Damage (self,world,world,(FL_SWIM * self.waterlevel));

         }

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

   local float mspeed;
   local float aspeed;
   local float r;

   if ( intermission_running ) {

      IntermissionThink ();
      return ;

   }
   if ( (self.view_ofs == VEC_ORIGIN) ) {

      return ;

   }
   makevectors (self.v_angle);
   CheckRules ();
   WaterMove ();
   if ( (self.wetsuit_finished > time) ) {

      if ( (self.watertype != CONTENT_LADDER) ) {

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
   if ( (self.items & IT2_ANTIGRAV) ) {

      if ( (time > self.AGping) ) {

         sound (self,CHAN_AUTO,"belt/use.wav",0.400,ATTN_NORM);
         self.AGping = (time + MOVETYPE_WALK);
         if ( (self.AGping >= (self.antigrav_finished - MOVETYPE_WALK)) ) {

            self.AGping = (self.antigrav_finished + MOVETYPE_WALK);

         }

      }

   }

};
void () CheckPowerups = {

   if ( (self.health <= FALSE) ) {

      return ;

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

            sprint (self,"Quad Speed is wearing off\n");
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
         localcmd ("-speed\n");
         self.speedflag = FALSE;
         self.speedstate = FALSE;

      }
      if ( (self.super_damage_finished > time) ) {

         self.effects = (self.effects | EF_DIMLIGHT);

      } else {

         self.effects = (self.effects - (self.effects & EF_DIMLIGHT));

      }

   }
   if ( self.radsuit_finished ) {

      self.air_finished = (self.air_finished + 12.000);
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
   if ( self.therm_finished ) {

      self.air_finished = (self.air_finished + 12.000);
      if ( (self.therm_finished < (time + MOVETYPE_WALK)) ) {

         if ( (self.therm_time == TRUE) ) {

            sprint (self,"Power in Thermal Protection Suit expiring\n");
            stuffcmd (self,"bf\n");
            sound (self,CHAN_AUTO,"items/suit2.wav",TRUE,ATTN_NORM);
            self.therm_time = (time + TRUE);

         }
         if ( (self.therm_time < time) ) {

            self.therm_time = (time + TRUE);
            stuffcmd (self,"bf\n");

         }

      }
      if ( (self.therm_finished < time) ) {

         self.items = (self.items - IT_INVISIBILITY);
         self.therm_time = FALSE;
         self.therm_finished = FALSE;

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

         self.items = (self.items - HIP_IT_WETSUIT);
         self.wetsuit_time = FALSE;
         self.wetsuit_finished = FALSE;

      }

   }
   if ( self.empathy_finished ) {

      if ( (self.empathy_finished < (time + MOVETYPE_WALK)) ) {

         if ( (self.empathy_time == TRUE) ) {

            sprint (self,"Friendship Token is running out\n");
            stuffcmd (self,"bf\n");
            sound (self,CHAN_AUTO,"hipitems/empathy2.wav",TRUE,ATTN_NORM);
            self.empathy_time = (time + TRUE);

         }
         if ( (self.empathy_time < time) ) {

            self.empathy_time = (time + TRUE);
            stuffcmd (self,"bf\n");

         }

      }
      if ( (self.empathy_finished < time) ) {

         self.items = (self.items - HIP_IT_EMPATHY_SHIELDS);
         self.empathy_time = FALSE;
         self.empathy_finished = FALSE;

      }
      if ( (self.empathy_finished > time) ) {

         self.effects = (self.effects | EF_DIMLIGHT);

      } else {

         self.effects = (self.effects - (self.effects & EF_DIMLIGHT));

      }

   }
   if ( (self.shield_finished > FALSE) ) {

      if ( (self.shield_finished < (time + MOVETYPE_WALK)) ) {

         if ( (self.shield_time == TRUE) ) {

            sprint (self,"Impact Shield failing...\n");
            sound (self,CHAN_AUTO,"shield/fadeout.wav",TRUE,ATTN_NORM);
            self.shield_time = FALSE;

         }
         if ( (self.shield_time < time) ) {

            self.shield_time = (time + TRUE);
            stuffcmd (self,"bf\n");

         }

      }
      if ( (self.shield_finished < time) ) {

         sprint (self,"Impact Shield Lost.\n");
         self.shield_finished = FALSE;
         self.items = (self.items - IT2_SHIELD);

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
         self.items = (self.items - IT2_ANTIGRAV);
         self.gravity = TRUE;

      }

   }

};
void () PlayerPostThink = {

   local float mspeed;
   local float aspeed;
   local float r;

   if ( (self.view_ofs == VEC_ORIGIN) ) {

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
   if ( self.deadflag ) {

      return ;

   }
   SetFlashlight_Frame ();
   if ( (((self.jump_flag < -300.000) && (self.flags & FL_ONGROUND)) && (self.health > FALSE)) ) {

      if ( (self.watertype == CONTENT_WATER) ) {

         sound (self,CHAN_BODY,"player/h2ojump.wav",TRUE,ATTN_NORM);

      } else {

         if ( (self.jump_flag < -650.000) ) {

            if (!(self.items & IT2_SHIELD) ) {

               T_Damage (self,world,world,FL_INWATER);
               sound (self,CHAN_VOICE,"player/land2.wav",TRUE,ATTN_NORM);
               self.deathtype = "falling";

            } else {

               sprint (self,"Impact Shields deflect fall damage\n");
               sound (self,CHAN_VOICE,"shield/hit.wav",TRUE,ATTN_NORM);

            }

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
   bprint (" rings\n");
   set_suicide_frame ();

};
void (entity targ, entity attacker) ClientObituary = {

   local float rnum;
   local string deathstring;
   local string deathstring2;

   rnum = random ();
   if ( (targ.classname == "player") ) {

      if ( (attacker.classname == "teledeath") ) {

         bprint (targ.netname);
         bprint (" was telefragged by ");
         bprint (attacker.owner.netname);
         bprint ("\n");
         return ;

      }
      if ( (attacker.classname == "teledeath2") ) {

         bprint (attacker.owner.netname);
         bprint (" deflects ");
         bprint (targ.netname);
         bprint ("'s telefrag\n");
         return ;

      }
      if ( (attacker.classname == "player") ) {

         if ( (targ == attacker) ) {

            bprint (targ.netname);

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
               return ;

            } else {

               bprint (targ.netname);
               bprint (deathstring);
               bprint (attacker.netname);
               bprint (deathstring2);

            }

         }
         return ;

      } else {

         bprint (targ.netname);
         if ( ((attacker.solid == SOLID_BSP) && (attacker != world)) ) {

            bprint (" was squashed like a bug\n");
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
         rnum = targ.watertype;
         if ( (rnum == CONTENT_WATER) ) {

            if ( (random () < 0.500) ) {

               bprint (" sleeps with the fishes\n");

            } else {

               bprint (" drank too much\n");

            }
            return ;

         } else {

            if ( (rnum == CONTENT_SLIME) ) {

               if ( (random () < 0.500) ) {

                  bprint (" gulped a load of slime\n");

               } else {

                  bprint (" ate too much slime\n");

               }
               return ;

            } else {

               if ( (rnum == CONTENT_LAVA) ) {

                  if ( (targ.health < -15.000) ) {

                     bprint (" burst into flames\n");
                     return ;

                  }
                  if ( (random () < 0.500) ) {

                     bprint (" disintegrated\n");

                  } else {

                     bprint (" was torched by lava\n");

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

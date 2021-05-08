void  ()multi_touch;
float SPAWNFLAG_DODAMAGE   =  1.00000;
float SPAWNFLAG_QMULT   =  2.00000;
float COUNTER_ORDERED   =  2.00000;
entity stemp;
entity otemp;
entity s;
entity old;

void  ()trigger_reactivate =  {
   self.solid = SOLID_TRIGGER;
};

float SPAWNFLAG_NOMESSAGE   =  1.00000;
float SPAWNFLAG_NOTOUCH   =  1.00000;
float SPAWNFLAG_MTOUCH   =  2.00000;
float SPAWNFLAG_PUSHTOUCH   =  4.00000;
float ALWAYS_RETURN   =  4.00000;
float SPAWNFLAG_REMOVE_PP   =  16.00000;
float SPAWNFLAG_NO_PP   =  32.00000;

void  ()multi_wait =  {
   self.check_ok = FALSE;
   if ( self.max_health ) {

      self.health = self.max_health;
      self.takedamage = DAMAGE_YES;
      self.solid = SOLID_BBOX;

   }
};


void  ()multi_trigger =  {
   if ( (self.nextthink > time) ) {

      return ;

   }
   if ( (self.classname == "trigger_secret") ) {

      if ( (self.enemy.classname != "player") ) {

         return ;

      }
      found_secrets = (found_secrets + 1.00000);
      WriteByte ( MSG_ALL, SVC_FOUNDSECRET);

   }
   if ( self.noise ) {

      sound ( self, CHAN_VOICE, self.noise, 1.00000, ATTN_NORM);

   }
   self.takedamage = DAMAGE_NO;
   activator = self.enemy;
   if ( self.experience_value ) {

      AwardExperience ( activator, self, 0.00000);

   }
   self.check_ok = TRUE;
   SUB_UseTargets ( );
   if ( (self.wait > 0.00000) ) {

      self.think = multi_wait;
      AdvanceThinkTime(self,self.wait);
   } else {

      self.use = SUB_Null;
      self.think = SUB_Null;
      self.touch = SUB_Null;
      self.nextthink = -1.00000;

   }
};


void  ()multi_killed =  {
   self.enemy = damage_attacker;
   multi_trigger ( );
};


float  (entity client,string piece)client_has_piece =  {
   if ( ((((((((client.puzzle_inv1 == piece) || (client.puzzle_inv2 == piece)) || (client.puzzle_inv3 == piece)) || (client.puzzle_inv4 == piece)) || (client.puzzle_inv5 == piece)) || (client.puzzle_inv6 == piece)) || (client.puzzle_inv7 == piece)) || (client.puzzle_inv8 == piece)) ) {

      return ( 1.00000 );

   }
   if ( client.puzzles_cheat ) {

      return ( 1.00000 );

   }
   return ( 0.00000 );
};


void  (entity client,string piece)client_remove_piece =  {
   if ( !piece ) {

      return ;

   }
   if ( (client.puzzle_inv1 == piece) ) {

      client.puzzle_inv1 = string_null;
   } else {

      if ( (client.puzzle_inv2 == piece) ) {

         client.puzzle_inv2 = string_null;
      } else {

         if ( (client.puzzle_inv3 == piece) ) {

            client.puzzle_inv3 = string_null;
         } else {

            if ( (client.puzzle_inv4 == piece) ) {

               client.puzzle_inv4 = string_null;
            } else {

               if ( (client.puzzle_inv5 == piece) ) {

                  client.puzzle_inv5 = string_null;
               } else {

                  if ( (client.puzzle_inv6 == piece) ) {

                     client.puzzle_inv6 = string_null;
                  } else {

                     if ( (client.puzzle_inv7 == piece) ) {

                        client.puzzle_inv7 = string_null;
                     } else {

                        if ( (client.puzzle_inv8 == piece) ) {

                           client.puzzle_inv8 = string_null;

                        }

                     }

                  }

               }

            }

         }

      }

   }
};


float  (entity client,float remove_pieces,float inverse)check_puzzle_pieces =  {
local float required = 0.00000;
local float has = 0.00000;
local entity found;
   has = 0.00000;
   required = 0.00000;
   if ( self.puzzle_piece_1 ) {

      required |= 1.00000;
      if ( client_has_piece ( client, self.puzzle_piece_1) ) {

         has |= 1.00000;

      }

   }
   if ( self.puzzle_piece_2 ) {

      required |= 2.00000;
      if ( client_has_piece ( client, self.puzzle_piece_2) ) {

         has |= 2.00000;

      }

   }
   if ( self.puzzle_piece_3 ) {

      required |= 4.00000;
      if ( client_has_piece ( client, self.puzzle_piece_3) ) {

         has |= 4.00000;

      }

   }
   if ( self.puzzle_piece_4 ) {

      required |= 8.00000;
      if ( client_has_piece ( client, self.puzzle_piece_4) ) {

         has |= 8.00000;

      }

   }
   if ( (!inverse && (required != has)) ) {

      return ( 0.00000 );
   } else {

      if ( (inverse && (required == has)) ) {

         return ( 0.00000 );

      }

   }
   if ( remove_pieces ) {

      found = find ( world, classname, "player");
      while ( found ) {

         client_remove_piece ( found, self.puzzle_piece_1);
         client_remove_piece ( found, self.puzzle_piece_2);
         client_remove_piece ( found, self.puzzle_piece_3);
         client_remove_piece ( found, self.puzzle_piece_4);
         found = find ( found, classname, "player");

      }

   }
   return ( 1.00000 );
};


void  ()multi_use =  {
local string temp;
local float removepp = 0.00000;
local float inversepp = 0.00000;
   if ( (time < self.attack_finished) ) {

      return ;

   }
   if ( (self.spawnflags & SPAWNFLAG_ACTIVATED) ) {

      self.touch = multi_touch;
      return ;

   }
   removepp = (self.spawnflags & SPAWNFLAG_REMOVE_PP);
   inversepp = (self.spawnflags & SPAWNFLAG_NO_PP);
   if ( !check_puzzle_pieces ( other, removepp, inversepp) ) {

      if ( (self.no_puzzle_msg && !deathmatch) ) {

         temp = getstring ( self.no_puzzle_msg);
         if ( !deathmatch ) {

            centerprint ( other, temp);

         }
         self.attack_finished = (time + 2.00000);

      }
      return ;

   }
   self.enemy = activator;
   multi_trigger ( );
};


void  ()multi_touch =  {
local float removepp = 0.00000;
local float inversepp = 0.00000;
local string temp;
   if ( (time < self.attack_finished) ) {

      return ;

   }
   if ( self.inactive ) {

      return ;

   }
   if ( (self.spawnflags & SPAWNFLAG_MTOUCH) ) {

      if ( !(other.flags & FL_MONSTER) ) {

         return ;

      }
   } else {

      if ( (self.spawnflags & SPAWNFLAG_PUSHTOUCH) ) {

         if ( !(other.flags & FL_PUSH) ) {

            return ;

         }
      } else {

         if ( (other.classname != "player") ) {

            return ;

         }

      }

   }
   if ( (self.movedir != '0.00000 0.00000 0.00000') ) {

      makevectors ( other.angles);
      if ( ((v_forward * self.movedir) < 0.00000) ) {

         return ;

      }

   }
   removepp = (self.spawnflags & SPAWNFLAG_REMOVE_PP);
   inversepp = (self.spawnflags & SPAWNFLAG_NO_PP);
   if ( !check_puzzle_pieces ( other, removepp, inversepp) ) {

      if ( (self.no_puzzle_msg && !deathmatch) ) {

         temp = getstring ( self.no_puzzle_msg);
         if ( !deathmatch ) {

            centerprint ( other, temp);

         }
         self.attack_finished = (time + 2.00000);

      }
      return ;

   }
   self.enemy = other;
   multi_trigger ( );
};


void  ()trigger_multiple =  {
   if ( (self.soundtype == 1.00000) ) {

      precache_sound ( "misc/secret.wav");
      self.noise = "misc/secret.wav";
   } else {

      if ( (self.soundtype == 2.00000) ) {

         precache_sound ( "misc/comm.wav");
         self.noise = "misc/comm.wav";
      } else {

         if ( (self.soundtype == 3.00000) ) {

            precache_sound ( "misc/trigger1.wav");
            self.noise = "misc/trigger1.wav";

         }

      }

   }
   if ( !self.wait ) {

      self.wait = 0.20000;

   }
   self.use = multi_use;
   InitTrigger ( );
   if ( self.health ) {

      if ( (self.spawnflags & SPAWNFLAG_NOTOUCH) ) {

         objerror ( "health and notouch don't make sense\n");

      }
      self.max_health = self.health;
      self.th_die = multi_killed;
      self.takedamage = DAMAGE_YES;
      self.solid = SOLID_BBOX;
      setorigin ( self, self.origin);
   } else {

      if ( !(self.spawnflags & SPAWNFLAG_NOTOUCH) ) {

         self.touch = multi_touch;

      }

   }
};


void  ()trigger_once =  {
   self.wait = -1.00000;
   trigger_multiple ( );
};


void  ()trigger_activate =  {
local float temp_flags = 0.00000;
   temp_flags = self.spawnflags;
   self.spawnflags ^= (1.00000 | 2.00000);
   if ( (temp_flags & 1.00000) ) {

      trigger_once ( );
   } else {

      if ( (temp_flags & 2.00000) ) {

         self.use = SUB_UseTargets;
      } else {

         trigger_multiple ( );

      }

   }
};


void  ()trigger_deactivate =  {
   trigger_activate ( );
};


void  ()interval_use =  {
   SUB_UseTargets ( );
   self.think = interval_use;
   AdvanceThinkTime(self,self.wait);
};


void  ()trigger_interval =  {
   if ( !self.wait ) {

      self.wait = 5.00000;

   }
   InitTrigger ( );
   self.use = interval_use;
   self.think = interval_use;
   if ( !self.targetname ) {

      AdvanceThinkTime(self,0.10000);

   }
};


void  ()trigger_relay_use =  {
   SUB_UseTargets ( );
};


void  ()trigger_relay =  {
   self.use = trigger_relay_use;
};


void  ()counter_find_linked =  {
local entity starte;
local entity t;
   starte = self;
   t = nextent ( world);
   if ( (self.netname == "") ) {

      objerror ( "Ordered counter without a netname\n");

   }
   self.think = SUB_Null;
   while ( (t != world) ) {

      self.owner = starte;
      t = find ( t, netname, starte.netname);
      if ( ((t != world) && (t != starte)) ) {

         self.lockentity = t;
         self = t;

      }

   }
   self = starte;
};


void  ()counter_return_buttons =  {
local entity t;
   t = self.lockentity;
   while ( t ) {

      if ( (t.classname == "button") ) {

         t.think = button_return;
         t.nextthink = (t.ltime + 1.00000);

      }
      t = t.lockentity;

   }
};


void  ()counter_use_ordered =  {
local string oldtarg;
local float oldmsg = 0.00000;
local string temp;
   if ( self.mangle ) {

      if ( ((((self.cnt == 1.00000) && (other.aflag != self.mangle_x)) || ((self.cnt == 2.00000) && (other.aflag != self.mangle_y))) || ((self.cnt == 3.00000) && (other.aflag != self.mangle_z))) ) {

         self.items = 1.00000;

      }
   } else {

      if ( (other.aflag != self.cnt) ) {

         self.items = 1.00000;

      }

   }
   self.cnt += 1.00000;
   self.count -= 1.00000;
   if ( !self.items ) {

      if ( (self.count < 0.00000) ) {

         self.check_ok = TRUE;
         if ( (self.spawnflags & ALWAYS_RETURN) ) {

            counter_return_buttons ( );

         }
         if ( (((activator.classname == "player") && ((self.spawnflags & SPAWNFLAG_NOMESSAGE) == 0.00000)) && !deathmatch) ) {

            if ( self.message ) {

               temp = getstring ( self.message);
            } else {

               temp = "Sequence completed!";

            }
            centerprint ( activator, temp);

         }
         self.enemy = activator;
         multi_trigger ( );
         self.cnt = 1.00000;
         self.count = self.frags;
         self.items = 0.00000;

      }
   } else {

      if ( (self.count < 0.00000) ) {

         self.check_ok = FALSE;
         if ( ((activator.classname == "player") && !deathmatch) ) {

            if ( self.msg2 ) {

               temp = getstring ( self.msg2);
            } else {

               temp = "Nothing seemed to happen";

            }
            centerprint ( activator, temp);

         }
         oldtarg = self.target;
         self.target = self.puzzle_id;
         oldmsg = self.message;
         self.message = FALSE;
         SUB_UseTargets ( );
         self.message = oldmsg;
         self.target = oldtarg;
         self.cnt = 1.00000;
         self.count = self.frags;
         self.items = 0.00000;
         counter_return_buttons ( );

      }

   }
};


void  ()counter_use =  {
   self.count -= 1.00000;
   if ( (self.count < 0.00000) ) {

      return ;

   }
   if ( (self.count != 0.00000) ) {

      if ( (((activator.classname == "player") && ((self.spawnflags & SPAWNFLAG_NOMESSAGE) == 0.00000)) && !deathmatch) ) {

         if ( (self.count >= 4.00000) ) {

            centerprint ( activator, "There are more to go...");
         } else {

            if ( (self.count == 3.00000) ) {

               centerprint ( activator, "Only 3 more to go...");
            } else {

               if ( (self.count == 2.00000) ) {

                  centerprint ( activator, "Only 2 more to go...");
               } else {

                  centerprint ( activator, "Only 1 more to go...");

               }

            }

         }

      }
      self.check_ok = FALSE;
      return ;

   }
   if ( (((activator.classname == "player") && ((self.spawnflags & SPAWNFLAG_NOMESSAGE) == 0.00000)) && !deathmatch) ) {

      centerprint ( activator, "Sequence completed!");
      sound ( activator, CHAN_ITEM, "misc/comm.wav", 1.00000, ATTN_NORM);

   }
   self.check_ok = TRUE;
   self.enemy = activator;
   multi_trigger ( );
   self.cnt = 1.00000;
   self.count = self.frags;
   self.items = 0.00000;
};


void  ()trigger_counter =  {
   if ( !self.wait ) {

      self.wait = -1.00000;

   }
   if ( !self.count ) {

      self.count = 2.00000;

   }
   if ( (self.spawnflags & 8.00000) ) {

      self.inactive = TRUE;

   }
   self.items = 0.00000;
   self.cnt = 1.00000;
   self.frags = self.count;
   if ( (self.spawnflags & COUNTER_ORDERED) ) {

      self.use = counter_use_ordered;
      AdvanceThinkTime(self,0.10000);
      self.think = counter_find_linked;
   } else {

      self.use = counter_use;

   }
};


void  ()trigger_combination_assign =  {
   trigger_multiple ( );
};


void  ()trigger_counter_reset =  {
   trigger_multiple ( );
};


void  ()check_find_linked =  {
local entity starte;
local entity t;
   starte = self;
   t = nextent ( world);
   if ( (self.netname == "") ) {

      objerror ( "Check trigger without a netname\n");

   }
   self.think = SUB_Null;
   while ( (t != world) ) {

      t = find ( t, netname, starte.netname);
      if ( ((t != world) && (t != starte)) ) {

         self.check_chain = t;
         self = t;
         self.owner = starte;

      }

   }
   self = starte;
};


void  ()check_use =  {
local entity t;
local float failed = 0.00000;
   t = self.check_chain;
   while ( t ) {

      if ( !t.check_ok ) {

         failed = TRUE;

      }
      t = t.check_chain;

   }
   if ( (!failed && !self.check_ok) ) {

      self.check_ok = TRUE;
      SUB_UseTargets ( );
   } else {

      if ( (failed && self.check_ok) ) {

         self.check_ok = FALSE;
         SUB_UseTargets ( );

      }

   }
};


void  ()trigger_check =  {
   self.use = check_use;
   AdvanceThinkTime(self,0.10000);
   self.think = check_find_linked;
};


void  ()quake_shake_next =  {
local entity player;
   if ( (self.spawnflags & SPAWNFLAG_DODAMAGE) ) {

      T_Damage ( self.enemy, self, self, self.dmg);

   }
   player = world;
   player = find ( world, classname, "player");
   if ( !player ) {

      return ;

   }
   player.punchangle = RandomVector ( '5.00000 4.00000 4.00000');
   if ( (player.flags & FL_ONGROUND) ) {

      player.velocity += RandomVector ( '25.00000 25.00000 0.00000');
      player.velocity_z += random(100.00000,200.00000);
      player.flags ^= FL_ONGROUND;

   }
   self.think = quake_shake_next;
   AdvanceThinkTime(self,0.10000);
   if ( (self.lifespan < time) ) {

      self.nextthink = -1.00000;
      self.wait = -1.00000;
   } else {

      AdvanceThinkTime(self,0.10000);

   }
};


void  ()quake_shake =  {
   sound ( self, CHAN_AUTO, "weapons/explode.wav", 1.00000, ATTN_NONE);
   sound ( self, CHAN_AUTO, "fx/quake.wav", 1.00000, ATTN_NONE);
   self.think = quake_shake_next;
   AdvanceThinkTime(self,0.10000);
   SUB_UseTargets ( );
   if ( !(self.spawnflags & SPAWNFLAG_QMULT) ) {

      self.wait = -1.00000;

   }
};


void  ()quake_use =  {
   if ( ((self.nextthink >= time) || (self.nextthink < 0.00000)) ) {

      return ;

   }
   self.think = quake_shake;
   self.lifespan += time;
   if ( !(self.spawnflags & 2.00000) ) {

      self.use = SUB_Null;

   }
   AdvanceThinkTime(self,self.wait);
};


void  ()trigger_quake =  {
   self.use = quake_use;
   if ( !self.wait ) {

      self.wait = 1.00000;

   }
   if ( !self.dmg ) {

      self.dmg = 5.00000;

   }
   if ( !self.lifespan ) {

      self.lifespan = 2.00000;

   }
   InitTrigger ( );
   self.touch = SUB_Null;
};

float PLAYER_ONLY   =  1.00000;
float SILENT   =  2.00000;

void  ()play_teleport =  {
local float v = 0.00000;
local string tmpstr;
   v = random(5.00000);
   if ( (v < 1.00000) ) {

      tmpstr = "misc/teleprt1.wav";
   } else {

      if ( (v < 2.00000) ) {

         tmpstr = "misc/teleprt2.wav";
      } else {

         if ( (v < 3.00000) ) {

            tmpstr = "misc/teleprt3.wav";
         } else {

            if ( (v < 4.00000) ) {

               tmpstr = "misc/teleprt4.wav";
            } else {

               tmpstr = "misc/teleprt5.wav";

            }

         }

      }

   }
   sound ( self, CHAN_VOICE, tmpstr, 1.00000, ATTN_NORM);
   remove ( self);
};


void  (vector org)spawn_tfog =  {
   s = spawn ( );
   s.origin = org;
   AdvanceThinkTime(s,0.05000);
   s.think = play_teleport;
   WriteByte ( MSG_BROADCAST, SVC_TEMPENTITY);
   WriteByte ( MSG_BROADCAST, TE_TELEPORT);
   WriteCoord ( MSG_BROADCAST, org_x);
   WriteCoord ( MSG_BROADCAST, org_y);
   WriteCoord ( MSG_BROADCAST, org_z);
};


void  ()tdeath_touch =  {
   if ( (other == self.owner) ) {

      return ;

   }
   if ( (other.classname == "player") ) {

      if ( (self.owner.classname != "player") ) {

         T_Damage ( self.owner, self, self.owner, 50000.00000);
         return ;

      }
      if ( (other.artifact_active & ART_INVINCIBILITY) ) {

         if ( (self.owner.artifact_active & ART_INVINCIBILITY) ) {

            self.classname = "teledeath4";
            self.owner.deathtype = self.classname;
            other.deathtype = self.classname;
            remove_invincibility ( other);
            remove_invincibility ( self.owner);
            T_Damage ( other, self, self.owner, 50000.00000);
         } else {

            self.classname = "teledeath2";

         }
         other = self.owner;

      }
      if ( (((coop && teamplay) && (self.owner.classname == "player")) || ((deathmatch && teamplay) && (other.team == self.owner.team))) ) {

         self.classname = "teledeath3";

      }

   }
   if ( other.health ) {

      other.deathtype = self.classname;
      T_Damage ( other, self, self.owner, 50000.00000);

   }
};


void  (vector org,entity death_owner)spawn_tdeath =  {
local entity death;
   death = spawn ( );
   death.classname = "teledeath";
   death.movetype = MOVETYPE_NONE;
   death.solid = SOLID_TRIGGER;
   death.angles = '0.00000 0.00000 0.00000';
   setsize ( death, (death_owner.mins - '1.00000 1.00000 1.00000'), (death_owner.maxs + '1.00000 1.00000 1.00000'));
   setorigin ( death, org);
   death.touch = tdeath_touch;
   AdvanceThinkTime(death,0.20000);
   death.think = SUB_Remove;
   death.owner = death_owner;
   force_retouch = 2.00000;
};


void  ()teleport_effect_delay =  {
   GenerateTeleportEffect ( self.enemy.origin, 0.00000);
   self.attack_finished = (time + 0.50000);
   if ( (self.classname == "teleportcoin") ) {

      self.think = SUB_Remove;
      self.nextthink = (time + HX_FRAME_TIME);

   }
};


void  ()teleport_touch =  {
local entity t;
local vector org = '0.00000 0.00000 0.00000';
local float poof_speed = 0.00000;
   if ( self.inactive ) {

      return ;

   }
   if ( (self.spawnflags & PLAYER_ONLY) ) {

      if ( (other.classname != "player") ) {

         return ;

      }

   }
   if ( (((other.solid == SOLID_BSP) || (other.solid == SOLID_TRIGGER)) || (other.teleport_time > time)) ) {

      return ;

   }
   SUB_UseTargets ( );
   if ( !(self.spawnflags & SILENT) ) {

      GenerateTeleportEffect ( other.origin, 0.00000);

   }
   if ( (self.classname != "teleportcoin") ) {

      t = find ( world, targetname, self.target);
      if ( !t ) {

         objerror ( "couldn't find target");

      }
   } else {

      t = self.goalentity;

   }
   if ( (t.avelocity != '0.00000 0.00000 0.00000') ) {

      t.mangle = t.angles;

   }
   if ( (!(t.spawnflags & 1.00000) && (self.classname != "teleportcoin")) ) {

      makevectors ( t.mangle);
      org = (t.origin + (32.00000 * v_forward));
   } else {

      org = t.origin;

   }
   spawn_tdeath ( t.origin, other);
   if ( (!other.health && (other.size != '0.00000 0.00000 0.00000')) ) {

      other.origin = t.origin;
      if ( (!(t.spawnflags & 1.00000) && (self.classname != "teleportcoin")) ) {

         other.velocity = ((v_forward * other.velocity_x) + (v_forward * other.velocity_y));

      }
      return ;

   }
   setorigin ( other, t.origin);
   if ( !(self.spawnflags & SILENT) ) {

      self.enemy = other;
      self.think = teleport_effect_delay;
      AdvanceThinkTime(self,0.05000);

   }
   other.teleport_time = (time + 0.70000);
   if ( (!(t.spawnflags & 1.00000) && (self.classname != "teleportcoin")) ) {

      other.angles = t.mangle;
      other.fixangle = 1.00000;
      if ( ((other.classname != "player") && (other.velocity != '0.00000 0.00000 0.00000')) ) {

         poof_speed = vlen ( other.velocity);
      } else {

         poof_speed = 300.00000;

      }
      other.velocity = (v_forward * poof_speed);

   }
   other.flags ^= FL_ONGROUND;
};


void  ()info_teleport_destination =  {
   if ( (self.avelocity != '0.00000 0.00000 0.00000') ) {

      self.movetype = MOVETYPE_NOCLIP;

   }
   self.mangle = self.angles;
   self.angles = '0.00000 0.00000 0.00000';
   self.model = "";
   self.origin = (self.origin + '0.00000 0.00000 27.00000');
   if ( !self.targetname ) {

      objerror ( "no targetname");

   }
};


void  ()teleport_use =  {
   AdvanceThinkTime(self,0.20000);
   force_retouch = 2.00000;
   self.think = SUB_Null;
};


void  ()trigger_teleport =  {
local vector o = '0.00000 0.00000 0.00000';
   InitTrigger ( );
   self.touch = teleport_touch;
   if ( !self.target ) {

      objerror ( "no target");

   }
   self.use = teleport_use;
   if ( !(self.spawnflags & SILENT) ) {

      precache_sound ( "ambience/newhum1.wav");
      o = ((self.mins + self.maxs) * 0.50000);
      ambientsound ( o, "ambience/newhum1.wav", 0.50000, ATTN_STATIC);

   }
   if ( (self.spawnflags & 4.00000) ) {

      self.inactive = TRUE;

   }
};


void  ()hurt_on =  {
   self.solid = SOLID_TRIGGER;
   self.nextthink = -1.00000;
};


void  ()hurt_touch =  {
   if ( other.takedamage ) {

      self.solid = SOLID_NOT;
      T_Damage ( other, self, self, self.dmg);
      self.think = hurt_on;
      AdvanceThinkTime(self,1.00000);

   }
   return ;
};


void  ()trigger_hurt =  {
   InitTrigger ( );
   self.touch = hurt_touch;
   if ( !self.dmg ) {

      self.dmg = 1000.00000;

   }
};

float PUSH_ONCE   =  1.00000;

void  ()trigger_push_gone =  {
   remove ( self);
};


void  ()trigger_push_touch =  {
   if ( (other.health > 0.00000) ) {

      if ( (other.flags & FL_ONGROUND) ) {

         other.velocity = (self.movedir * self.speed);
         other.velocity_z = 500.00000;

      }
      if ( ((other.classname == "player") && (other.flags & FL_ONGROUND)) ) {

         sound ( other, CHAN_AUTO, "ambience/windpush.wav", 1.00000, ATTN_NORM);
         other.flags ^= FL_ONGROUND;

      }

   }
   if ( (self.spawnflags & PUSH_ONCE) ) {

      remove ( self);

   }
};


void  ()trigger_push =  {
   InitTrigger ( );
   precache_sound ( "ambience/windpush.wav");
   self.touch = trigger_push_touch;
   self.use = trigger_push_gone;
   if ( !self.speed ) {

      self.speed = 500.00000;

   }
};


void  ()trigger_monsterjump_touch =  {
   if ( ((other.flags & ((FL_MONSTER | FL_FLY) | FL_SWIM)) != FL_MONSTER) ) {

      return ;

   }
   other.velocity_x = (self.movedir_x * self.speed);
   other.velocity_y = (self.movedir_y * self.speed);
   if ( !(other.flags & FL_ONGROUND) ) {

      return ;

   }
   other.flags ^= FL_ONGROUND;
   other.velocity_z = self.height;
   self.wait = -1.00000;
   if ( -1.00000 ) {

      self.touch = SUB_Null;

   }
   if ( other.th_jump ) {

      other.think = other.th_jump;
      AdvanceThinkTime(other,0.00000);

   }
};


void  ()trigger_monsterjump =  {
   if ( !self.speed ) {

      self.speed = 200.00000;

   }
   if ( !self.height ) {

      self.height = 200.00000;

   }
   if ( (self.angles == '0.00000 0.00000 0.00000') ) {

      self.angles = '0.00000 360.00000 0.00000';

   }
   InitTrigger ( );
   self.touch = trigger_monsterjump_touch;
};


void  ()trigger_crosslevel_use =  {
   if ( (other.classname == "trigger_check") ) {

      if ( !other.check_ok ) {

         self.check_ok = FALSE;
         if ( (self.spawnflags & 1.00000) ) {

            serverflags ^= SFL_CROSS_TRIGGER_1;

         }
         if ( (self.spawnflags & 2.00000) ) {

            serverflags ^= SFL_CROSS_TRIGGER_2;

         }
         if ( (self.spawnflags & 4.00000) ) {

            serverflags ^= SFL_CROSS_TRIGGER_3;

         }
         if ( (self.spawnflags & 8.00000) ) {

            serverflags ^= SFL_CROSS_TRIGGER_4;

         }
         if ( (self.spawnflags & 16.00000) ) {

            serverflags ^= SFL_CROSS_TRIGGER_5;

         }
         if ( (self.spawnflags & 32.00000) ) {

            serverflags ^= SFL_CROSS_TRIGGER_6;

         }
         if ( (self.spawnflags & 64.00000) ) {

            serverflags ^= SFL_CROSS_TRIGGER_7;

         }
         if ( (self.spawnflags & 128.00000) ) {

            serverflags ^= SFL_CROSS_TRIGGER_8;

         }
         return ;

      }

   }
   if ( (self.spawnflags & 1.00000) ) {

      serverflags |= SFL_CROSS_TRIGGER_1;

   }
   if ( (self.spawnflags & 2.00000) ) {

      serverflags |= SFL_CROSS_TRIGGER_2;

   }
   if ( (self.spawnflags & 4.00000) ) {

      serverflags |= SFL_CROSS_TRIGGER_3;

   }
   if ( (self.spawnflags & 8.00000) ) {

      serverflags |= SFL_CROSS_TRIGGER_4;

   }
   if ( (self.spawnflags & 16.00000) ) {

      serverflags |= SFL_CROSS_TRIGGER_5;

   }
   if ( (self.spawnflags & 32.00000) ) {

      serverflags |= SFL_CROSS_TRIGGER_6;

   }
   if ( (self.spawnflags & 64.00000) ) {

      serverflags |= SFL_CROSS_TRIGGER_7;

   }
   if ( (self.spawnflags & 128.00000) ) {

      serverflags |= SFL_CROSS_TRIGGER_8;

   }
   self.check_ok = TRUE;
   SUB_UseTargets ( );
   self.solid = SOLID_NOT;
};


void  ()trigger_crosslevel_touch =  {
   if ( (other.classname != "player") ) {

      return ;

   }
   activator = other;
   trigger_crosslevel_use ( );
};


void  ()trigger_crosslevel =  {
   if ( (((((((((self.spawnflags & 1.00000) && (serverflags & SFL_CROSS_TRIGGER_1)) || ((self.spawnflags & 2.00000) && (serverflags & SFL_CROSS_TRIGGER_2))) || ((self.spawnflags & 4.00000) && (serverflags & SFL_CROSS_TRIGGER_3))) || ((self.spawnflags & 8.00000) && (serverflags & SFL_CROSS_TRIGGER_4))) || ((self.spawnflags & 16.00000) && (serverflags & SFL_CROSS_TRIGGER_5))) || ((self.spawnflags & 32.00000) && (serverflags & SFL_CROSS_TRIGGER_6))) || ((self.spawnflags & 64.00000) && (serverflags & SFL_CROSS_TRIGGER_7))) || ((self.spawnflags & 128.00000) && (serverflags & SFL_CROSS_TRIGGER_8))) ) {

      self.solid = SOLID_NOT;
      self.flags |= FL_ARCHIVE_OVERRIDE;
      return ;

   }
   InitTrigger ( );
   self.touch = trigger_crosslevel_touch;
   self.use = trigger_crosslevel_use;
};


void  ()trigger_crosslevel_target_think =  {
   if ( (((((((((self.spawnflags & 1.00000) && (serverflags & SFL_CROSS_TRIGGER_1)) || ((self.spawnflags & 2.00000) && (serverflags & SFL_CROSS_TRIGGER_2))) || ((self.spawnflags & 4.00000) && (serverflags & SFL_CROSS_TRIGGER_3))) || ((self.spawnflags & 8.00000) && (serverflags & SFL_CROSS_TRIGGER_4))) || ((self.spawnflags & 16.00000) && (serverflags & SFL_CROSS_TRIGGER_5))) || ((self.spawnflags & 32.00000) && (serverflags & SFL_CROSS_TRIGGER_6))) || ((self.spawnflags & 64.00000) && (serverflags & SFL_CROSS_TRIGGER_7))) || ((self.spawnflags & 128.00000) && (serverflags & SFL_CROSS_TRIGGER_8))) ) {

      activator = world;
      self.check_ok = TRUE;
      SUB_UseTargets ( );
   } else {

      self.check_ok = FALSE;

   }
};


void  ()trigger_crosslevel_target =  {
   self.think = trigger_crosslevel_target_think;
   AdvanceThinkTime(self,0.50000);
   self.solid = SOLID_NOT;
   self.flags |= FL_ARCHIVE_OVERRIDE;
};


void  (entity item,entity person)GetPuzzle =  {
   if ( !person.puzzle_inv1 ) {

      person.puzzle_inv1 = item.puzzle_id;
   } else {

      if ( !person.puzzle_inv2 ) {

         person.puzzle_inv2 = item.puzzle_id;
      } else {

         if ( !person.puzzle_inv3 ) {

            person.puzzle_inv3 = item.puzzle_id;
         } else {

            if ( !person.puzzle_inv4 ) {

               person.puzzle_inv4 = item.puzzle_id;
            } else {

               if ( !person.puzzle_inv5 ) {

                  person.puzzle_inv5 = item.puzzle_id;
               } else {

                  if ( !person.puzzle_inv6 ) {

                     person.puzzle_inv6 = item.puzzle_id;
                  } else {

                     if ( !person.puzzle_inv7 ) {

                        person.puzzle_inv7 = item.puzzle_id;
                     } else {

                        if ( person.puzzle_inv8 ) {

                           person.puzzle_inv8 = item.puzzle_id;
                        } else {

                           dprint ( "No room for puzzle piece!\n");

                        }

                     }

                  }

               }

            }

         }

      }

   }
};


void  (entity item,entity person,string which)GetPuzzle2 =  {
   item.puzzle_id = which;
};


void  ()puzzle_touch =  {
local float amount = 0.00000;
   if ( (other.classname != "player") ) {

      return ;

   }
   if ( (other.health <= 0.00000) ) {

      return ;

   }
   if ( ((((((((other.puzzle_inv1 == self.puzzle_id) || (other.puzzle_inv2 == self.puzzle_id)) || (other.puzzle_inv3 == self.puzzle_id)) || (other.puzzle_inv4 == self.puzzle_id)) || (other.puzzle_inv5 == self.puzzle_id)) || (other.puzzle_inv6 == self.puzzle_id)) || (other.puzzle_inv7 == self.puzzle_id)) || (other.puzzle_inv8 == self.puzzle_id)) ) {

      return ;

   }
   amount = random();
   if ( (amount < 0.50000) ) {

      sprint ( other, STR_YOUPOSSESS);
      sprint ( other, self.netname);
   } else {

      sprint ( other, STR_YOUHAVEACQUIRED);
      sprint ( other, self.netname);

   }
   sprint ( other, "\n");
   GetPuzzle ( self, other);
   sound ( other, CHAN_VOICE, self.noise, 1.00000, ATTN_NORM);
   stuffcmd ( other, "bf\n");
   if ( coop ) {

      return ;

   }
   self.solid = SOLID_NOT;
   self.model = string_null;
   activator = other;
   SUB_UseTargets ( );
};


void  ()puzzle_use =  {
   self.effects ^= EF_NODRAW;
   self.solid = SOLID_TRIGGER;
   self.use = SUB_Null;
   self.touch = puzzle_touch;
   setorigin ( self, self.origin);
   StartItem ( );
};


void  ()puzzle_piece =  {
   precache_sound ( "items/artpkup.wav");
   precache_puzzle_model ( self.puzzle_id);
   setpuzzlemodel ( self, self.puzzle_id);
   self.noise = "items/artpkup.wav";
   if ( (self.spawnflags & 1.00000) ) {

      setsize ( self, '-8.00000 -8.00000 -8.00000', '8.00000 8.00000 16.00000');
      self.spawnflags ^= 1.00000;
      self.solid = SOLID_NOT;
      self.effects |= EF_NODRAW;
      self.use = puzzle_use;
   } else {

      setsize ( self, '0.00000 0.00000 0.00000', '0.00000 0.00000 0.00000');
      self.hull = HULL_POINT;
      self.solid = SOLID_BBOX;
      self.touch = puzzle_touch;
      self.think = StartItem;
      AdvanceThinkTime(self,0.00000);

   }
   if ( (self.spawnflags & 2.00000) ) {

      self.spawnflags = 1.00000;

   }
   if ( ((self.puzzle_id == "glass") || (self.puzzle_id == "lens")) ) {

      self.drawflags |= DRF_TRANSLUCENT;

   }
};


void  ()puzzle_static_use =  {
   setpuzzlemodel ( self, self.puzzle_id);
   SUB_UseTargets ( );
   if ( self.lifespan ) {

      AdvanceThinkTime(self,self.lifespan);
      self.think = SUB_Remove;

   }
};


void  ()puzzle_static_piece =  {
   precache_puzzle_model ( self.puzzle_id);
   setmodel ( self, self.model);
   self.solid = SOLID_NOT;
   self.movetype = MOVETYPE_NONE;
   setsize ( self, '0.00000 0.00000 0.00000', '0.00000 0.00000 0.00000');
   self.use = puzzle_static_use;
};


void  ()reset_mangle =  {
   SUB_CalcAngleMove ( self.mangle, 10.00000, SUB_Null);
};


void  ()control_return =  {
   if ( (self.goalentity.classname != "catapult") ) {

      self.goalentity.oldthink = SUB_Null;
      self.goalentity.think = reset_mangle;
      AdvanceThinkTime(self.goalentity,0.00000);

   }
   if ( self.check_ok ) {

      self.enemy.oldweapon = 0.00000;
      self.enemy.th_weapon = W_SetCurrentAmmo;
      self.check_ok = FALSE;
      self.enemy = world;

   }
};

void  ()catapult_ready;

void  ()control_touch =  {
local vector org = '0.00000 0.00000 0.00000';
local vector dir = '0.00000 0.00000 0.00000';
local float fire_range = 0.00000;
   if ( (other.classname != "player") ) {

      return ;

   }
   if ( ((self.enemy != world) && (other != self.enemy)) ) {

      return ;

   }
   if ( ((self.goalentity.health <= 0.00000) && self.goalentity.takedamage) ) {

      self.think = SUB_Remove;
      AdvanceThinkTime(self,0.00000);
      return ;

   }
   other.attack_finished = (time + 0.10000);
   if ( (other.weaponmodel != "models/xhair.mdl") ) {
	   other.weaponmodel = "models/xhair.mdl";
	}
   other.weaponframe = 0.00000;
   other.th_weapon = SUB_Null;
   self.check_ok = TRUE;
   if ( (self.enemy != other) ) {

      centerprint ( other, "You're not in control!!!!!!\n");

   }
   self.enemy = other;
   self.goalentity.enemy = self;
   makevectors ( self.enemy.v_angle);
   if ( (self.goalentity.classname == "catapult") ) {

      if ( ((self.enemy.angles_y < (self.goalentity.angles_y + 5.00000)) && (self.enemy.angles_y > (self.goalentity.angles_y - 5.00000))) ) {

         self.goalentity.angles_y = self.enemy.angles_y;

      }
      if ( (self.goalentity.think == catapult_ready) ) {

         if ( self.enemy.button0 ) {

            self.goalentity.think = self.goalentity.th_weapon;
            AdvanceThinkTime(self.goalentity,0.00000);

         }

      }
   } else {

      org = (self.enemy.origin + self.enemy.proj_ofs);
      dir = normalize ( v_forward);
      traceline ( org, (org + (dir * 10000.00000)), FALSE, self.enemy);
      org = (self.goalentity.origin + self.goalentity.proj_ofs);
      fire_range = vlen ( (org - trace_endpos));
      if ( (fire_range > 128.00000) ) {

         dir = normalize ( (trace_endpos - org));
         if ( (trace_ent.health && (trace_ent.origin != '0.00000 0.00000 0.00000')) ) {

            self.goalentity.goalentity = trace_ent;
         } else {

            self.goalentity.goalentity = world;

         }
         self.goalentity.view_ofs = trace_endpos;
         dir = vectoangles ( dir);
         self.goalentity.angles = dir;
         self.goalentity.angles_z = (dir_z / 10.00000);
         if ( (self.goalentity.think != self.goalentity.th_weapon) ) {

            if ( (self.enemy.button0 && (self.goalentity.th_weapon != SUB_Null)) ) {

               self.goalentity.think = self.goalentity.th_weapon;
               AdvanceThinkTime(self.goalentity,0.00000);

            }

         }

      }

   }
   self.think = control_return;
   AdvanceThinkTime(self,0.10000);
};


void  ()trigger_control_find_target =  {
   if ( !self.target ) {

      objerror ( "Nothing to control!\n");

   }
   self.goalentity = find ( world, targetname, self.target);
   if ( !self.goalentity ) {

      objerror ( "Could not find target\n");
   } else {

      if ( ((self.goalentity.classname == "catapult") || (self.goalentity.classname == "obj_catapult2")) ) {

         self.goalentity.movechain = self;
         self.flags |= FL_MOVECHAIN_ANGLE;
         self.movetype = MOVETYPE_NOCLIP;
      } else {

         self.goalentity.mangle = self.goalentity.angles;

      }

   }
};


void  ()trigger_control =  {
   self.enemy = world;
   self.touch = control_touch;
   self.ltime = time;
   InitTrigger ( );
   self.think = trigger_control_find_target;
   AdvanceThinkTime(self,1.00000);
};


void  ()trigger_attack_touch =  {
   if ( (other.classname != "player") ) {

      return ;

   }
   if ( ((other.last_attack + 0.30000) >= time) ) {

      SUB_UseTargets ( );
      remove ( self);

   }
};


void  ()trigger_attack =  {
   InitTrigger ( );
   self.touch = trigger_attack_touch;
};


void  ()trigger_message_transfer_use =  {
local string temp;
   temp = getstring ( self.message);
   if ( !deathmatch ) {

      centerprint ( activator, temp);

   }
   other.nexttarget = self.target;
};


void  ()trigger_message_transfer =  {
   InitTrigger ( );
   self.use = trigger_message_transfer_use;
};



void (vector tdest, float tspeed, void() func) SUB_CalcMove;
void (entity ent, vector tdest, float tspeed, void() func) SUB_CalcMoveEnt;
void (vector destangle, float tspeed, void() func) SUB_CalcAngleMove;
void () SUB_CalcMoveDone;
void () SUB_CalcAngleMoveDone;
void () SUB_Null;
void () SUB_UseTargets;
void () SUB_Remove;
void (entity targ, entity inflictor, entity attacker, float damage) T_Damage;
float (entity e, float healamount, float ignore) T_Heal;
float (entity targ, entity inflictor) CanDamage;
void (entity theEntity) UpdateAmmoCounts;
void () tag_token_respawn;
void () tag_token_touch;
void () tag_token_drop;
void (entity ownerEntity) sphere_remove;
.float steam;
.float suicide_count;
.float ctf_flags;
.float ctf_killed;
.float ctf_flagsince;
.float ctf_lasthurtcarrier;
.float ctf_lastreturnedflag;
.float ctf_lastfraggedcarrier;
float TEAM1    = 5.000;
float TEAM2    = 14.000;
float TEAM3    = 1.000;
entity team1_lastspawn;
entity team2_lastspawn;
float nextteamupdtime /* = 0.000 */;
float TEAM_NORMAL_NODAMAGE    = 1.000;
float TEAM_NORMAL_DAMAGE    = 2.000;
float TEAM_DMATCH_TAG    = 3.000;
float TEAM_CTF    = 4.000;
float TEAM_CTF_ONEFLAG    = 5.000;
float TEAM_CTF_ALT    = 6.000;
float GAMECFG_ENABLE_RUNES    = 1.000;
float GAMECFG_TEAM_ARMOR_DMG    = 2.000;
float GAMECFG_TEAM_HEALTH_DMG    = 4.000;
float GAMECFG_USE_COLOR    = 8.000;
float GAMECFG_ALLOW_CHG    = 16.000;
float CTF_CAPTURE_BONUS    = 15.000;
float CTF_TEAM_BONUS    = 10.000;
float CTF_ALT_CAPTURE_BONUS    = 8.000;
float CTF_ALT_TEAM_BONUS    = 4.000;
float CTF_RECOVERY_BONUS    = 1.000;
float CTF_FRAG_CARRIER_BONUS    = 2.000;
float CTF_FLAG_RETURN_TIME    = 40.000;
float CTF_CARRIER_DANGER_PROTECT_BONUS    = 2.000;
float CTF_CARRIER_PROTECT_BONUS    = 1.000;
float CTF_FLAG_DEFENSE_BONUS    = 1.000;
float CTF_RETURN_FLAG_ASSIST_BONUS    = 1.000;
float CTF_FRAG_CARRIER_ASSIST_BONUS    = 2.000;
float CTF_TARGET_PROTECT_RADIUS    = 400.000;
float CTF_ATTACKER_PROTECT_RADIUS    = 400.000;
float CTF_CARRIER_DANGER_PROTECT_TIMEOUT    = 4.000;
float CTF_CARRIER_FLAG_SINCE_TIMEOUT    = 2.000;
float CTF_FRAG_CARRIER_ASSIST_TIMEOUT    = 6.000;
float CTF_RETURN_FLAG_ASSIST_TIMEOUT    = 4.000;
float CTF_UPDATE_TIME    = 120.000;
float CTF_FLAG_FLAG    = 1.000;
float CTF_FLAG_TEAM1    = 1.000;
float CTF_FLAG_TEAM2    = 2.000;
float CTF_FLAG_STUFF_COLOR    = 4.000;
float FLAG_AT_BASE    = 0.000;
float FLAG_CARRIED    = 1.000;
float FLAG_DROPPED    = 2.000;
float () W_BestWeapon;
void () W_SetCurrentAmmo;
void () bound_other_ammo;
void (float old, float new) Deathmatch_Weapon;
void () BackpackTouch;
void (entity comboOwner) EnableComboWeapons;

string (float Team) GetTeamColor = {

   if ( (Team == TRUE) ) {

      return ( "White" );

   } else {

      if ( (Team == FL_SWIM) ) {

         return ( "Brown" );

      } else {

         if ( (Team == MOVETYPE_WALK) ) {

            return ( "Light blue" );

         } else {

            if ( (Team == MOVETYPE_STEP) ) {

               return ( "Green" );

            } else {

               if ( (Team == MOVETYPE_FLY) ) {

                  return ( "Red" );

               } else {

                  if ( (Team == MOVETYPE_TOSS) ) {

                     return ( "Olive" );

                  } else {

                     if ( (Team == MOVETYPE_PUSH) ) {

                        return ( "Orange" );

                     } else {

                        if ( (Team == FL_CLIENT) ) {

                           return ( "Peech" );

                        } else {

                           if ( (Team == MOVETYPE_FLYMISSILE) ) {

                              return ( "Purple" );

                           } else {

                              if ( (Team == MOVETYPE_BOUNCE) ) {

                                 return ( "Majenta" );

                              } else {

                                 if ( (Team == MOVETYPE_BOUNCEMISSILE) ) {

                                    return ( "Grey" );

                                 } else {

                                    if ( (Team == STAT_TOTALMONSTERS) ) {

                                       return ( "Aqua" );

                                    } else {

                                       if ( (Team == TE_BEAM) ) {

                                          return ( "Yellow" );

                                       } else {

                                          if ( (Team == TEAM2) ) {

                                             return ( "Blue" );

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
   return ( "Unknown" );

};
string (float Team) GetCTFTeam = {

   if ( (Team == TEAM1) ) {

      return ( "“≈ƒ" );

   } else {

      if ( (Team == TEAM2) ) {

         return ( "¬Ã’≈" );

      } else {

         if ( (Team == TEAM3) ) {

            return ( "«“≈Ÿ" );

         }

      }

   }
   return ( "UNKNOWN" );

};
float (entity targ, entity inflictor, entity attacker, float damage) TeamArmorDam = {

   if ( (teamplay <= FALSE) ) {

      return ( TRUE );

   }
   if ( ((((((teamplay == TEAM_CTF) || (teamplay == TEAM_CTF_ONEFLAG)) || (teamplay == TEAM_CTF_ALT)) && (attacker.steam == targ.steam)) && (attacker != targ)) && !(cvar ("gamecfg") & GAMECFG_TEAM_ARMOR_DMG)) ) {

      return ( FALSE );

   }
   return ( TRUE );

};
float (entity targ, entity inflictor, entity attacker, float damage) TeamHealthDam = {

   if ( (teamplay <= FALSE) ) {

      return ( TRUE );

   }
   if ( ((teamplay == TEAM_NORMAL_NODAMAGE) && (attacker.steam == targ.steam)) ) {

      return ( FALSE );

   }
   if ( ((((((teamplay == TEAM_CTF) || (teamplay == TEAM_CTF_ONEFLAG)) || (teamplay == TEAM_CTF_ALT)) && (attacker.steam == targ.steam)) && (attacker != targ)) && !(cvar ("gamecfg") & GAMECFG_TEAM_HEALTH_DMG)) ) {

      return ( FALSE );

   }
   return ( TRUE );

};

void (entity who) TeamResetCarrier = {

   local entity head;

   if ( ((teamplay >= TEAM_CTF) && (who.ctf_flags & (CTF_FLAG_TEAM1 | CTF_FLAG_TEAM2))) ) {

      head = find (world,classname,"player");
      while ( (head != world) ) {

         if ( (((teamplay == TEAM_CTF_ONEFLAG) || ((who.ctf_flags & CTF_FLAG_TEAM1) && (head.steam == TEAM1))) || ((who.ctf_flags & CTF_FLAG_TEAM2) && (head.steam == TEAM2))) ) {

            head.ctf_lasthurtcarrier = -10.000;

         }
         head = find (head,classname,"player");

      }

   }

};

void (entity targ, entity attacker) TeamAssists = {

   local float flag_radius;
   local float flag_carrier_radius;
   local string s;
   local entity head;

   if ( ((targ.ctf_flags & (CTF_FLAG_TEAM1 | CTF_FLAG_TEAM2)) && (targ.steam != attacker.steam)) ) {

      attacker.ctf_lastfraggedcarrier = time;
      if ( ((targ.ctf_flagsince + CTF_CARRIER_FLAG_SINCE_TIMEOUT) > time) ) {

         sprint (attacker,"Enemy flag carrier killed, no bonus\n");

      } else {

         attacker.frags = (attacker.frags + CTF_FRAG_CARRIER_BONUS);
         sprint (attacker,"Enemy flag carrier killed: ");
         s = ftos (CTF_FRAG_CARRIER_BONUS);
         sprint (attacker,s);
         sprint (attacker," bonus frags\n");

      }

   }
   flag_radius = FALSE;
   flag_carrier_radius = FALSE;
   s = GetCTFTeam (attacker.steam);
   if ( (((targ.ctf_lasthurtcarrier + CTF_CARRIER_DANGER_PROTECT_TIMEOUT) > time) && !(attacker.ctf_flags & (CTF_FLAG_TEAM1 | CTF_FLAG_TEAM2))) ) {

      attacker.frags = (attacker.frags + CTF_CARRIER_DANGER_PROTECT_BONUS);
      flag_carrier_radius = TRUE;
      bprint (attacker.netname);
      bprint (" defends ");
      bprint (s);
      bprint ("'s flag carrier against an agressive enemy\n");

   }
   head = findradius (attacker.origin,CTF_ATTACKER_PROTECT_RADIUS);
   while ( head ) {

      if ( (head.classname == "player") ) {

         if ( ((((head.steam == attacker.steam) && (head.ctf_flags & (CTF_FLAG_TEAM1 | CTF_FLAG_TEAM2))) && (head != attacker)) && !flag_carrier_radius) ) {

            attacker.frags = (attacker.frags + CTF_CARRIER_PROTECT_BONUS);
            flag_carrier_radius = TRUE;
            bprint (attacker.netname);
            bprint (" defends ");
            bprint (s);
            bprint ("'s flag carrier\n");

         }

      }
      if ( ((((attacker.steam == TEAM1) && (head.classname == "item_flag_team1")) || ((attacker.steam == TEAM2) && (head.classname == "item_flag_team2"))) || (head.classname == "item_flag")) ) {

         attacker.frags = (attacker.frags + CTF_FLAG_DEFENSE_BONUS);
         flag_radius = TRUE;
         bprint (attacker.netname);
         bprint (" defends the");
         if ( (teamplay != TEAM_CTF_ONEFLAG) ) {

            bprint (" ");
            bprint (s);

         }
         bprint (" flag\n");

      }
      head = head.chain;

   }
   head = findradius (targ.origin,CTF_TARGET_PROTECT_RADIUS);
   while ( head ) {

      if ( (head.classname == "player") ) {

         if ( ((((head.steam == attacker.steam) && (head.ctf_flags & (CTF_FLAG_TEAM1 | CTF_FLAG_TEAM2))) && (head != attacker)) && !flag_carrier_radius) ) {

            attacker.frags = (attacker.frags + CTF_CARRIER_PROTECT_BONUS);
            flag_carrier_radius = TRUE;
            bprint (attacker.netname);
            bprint (" defends ");
            bprint (s);
            bprint ("'s flag carrier\n");

         }

      }
      if ( (((((attacker.steam == TEAM1) && (head.classname == "item_flag_team1")) || ((attacker.steam == TEAM2) && (head.classname == "item_flag_team2"))) || (head.classname == "item_flag")) && !flag_radius) ) {

         attacker.frags = (attacker.frags + CTF_FLAG_DEFENSE_BONUS);
         flag_radius = TRUE;
         bprint (attacker.netname);
         bprint (" defends the");
         if ( (teamplay != TEAM_CTF_ONEFLAG) ) {

            bprint (" ");
            bprint (s);

         }
         bprint (" flag\n");

      }
      head = head.chain;

   }

};
float (float color) TeamColorIsLegal = {

   if ( (teamplay < TEAM_CTF) ) {

      if ( (color > FALSE) ) {

         return ( TRUE );

      }
      return ( FALSE );

   }
   if ( ((teamplay == TEAM_CTF) || (teamplay == TEAM_CTF_ONEFLAG)) ) {

      if ( ((color == TEAM1) || (color == TEAM2)) ) {

         return ( TRUE );

      } else {

         return ( FALSE );

      }

   }
   if ( (teamplay == TEAM_CTF_ALT) ) {

      if ( (((color == TEAM1) || (color == TEAM2)) || (color == TEAM3)) ) {

         return ( TRUE );

      } else {

         return ( FALSE );

      }

   }
   return ( TRUE );

};

void () TeamSetSkin = {

   self.skin = FALSE;
   if ( deathmatch ) {

      if ( (teamplay >= TEAM_CTF) ) {

         self.skin = TRUE;

      }

   }

};

void () TeamCheckTeam = {

   local float team1count;
   local float team2count;
   local float team3count;
   local float newcolor;
   local float t;
   local entity p;
   local string n;

   if ( ((self.steam >= FALSE) || (teamplay < TEAM_CTF)) ) {

      if ( TeamColorIsLegal (self.team) ) {

         self.steam = self.team;
         TeamSetSkin ();
         return ;

      }

   }
   team1count = FALSE;
   team2count = FALSE;
   team3count = FALSE;
   p = find (world,classname,"player");
   while ( p ) {

      if ( (p != self) ) {

         if ( (p.steam == TEAM1) ) {

            team1count = (team1count + TRUE);

         } else {

            if ( (p.steam == TEAM2) ) {

               team2count = (team2count + TRUE);

            } else {

               if ( (p.steam == TEAM3) ) {

                  team3count = (team3count + TRUE);

               }

            }

         }

      }
      p = find (p,classname,"player");

   }
   newcolor = TEAM1;
   t = team1count;
   if ( ((team2count < t) || ((team2count == t) && (random () < 0.500))) ) {

      newcolor = TEAM2;
      t = team2count;

   }
   team3count = (team3count * FL_SWIM);
   if ( ((teamplay == TEAM_CTF_ALT) && (team3count < t)) ) {

      newcolor = TEAM3;
      t = team3count;

   }
   self.ctf_flags = (self.ctf_flags | CTF_FLAG_STUFF_COLOR);
   n = GetCTFTeam (newcolor);
   sprint (self,"You have been assigned to ");
   sprint (self,n);
   sprint (self," team.\n");
   self.steam = newcolor;
   self.team = newcolor;
   TeamSetSkin ();

};

void () TeamCheckLock = {

   local float n;
   local string s;

   if ( (!deathmatch || (teamplay < TEAM_CTF)) ) {

      self.steam = self.team;
      return ;

   }
   if ( (self.ctf_flags & CTF_FLAG_STUFF_COLOR) ) {

      self.ctf_flags = (self.ctf_flags - CTF_FLAG_STUFF_COLOR);
      stuffcmd (self,"color ");
      n = (self.steam - TRUE);
      s = ftos (n);
      stuffcmd (self,s);
      stuffcmd (self,"\n");
      TeamSetSkin ();
      return ;

   }
   if ( (!TeamColorIsLegal (self.team) && (self.team == self.steam)) ) {

      self.steam = CONTENT_EMPTY;

   }
   if ( (self.team != self.steam) ) {

      if ( (self.steam >= FALSE) ) {

         if ( TeamColorIsLegal (self.steam) ) {

            if ( !(cvar ("gamecfg") & GAMECFG_ALLOW_CHG) ) {

               if ( (self.suicide_count > MOVETYPE_WALK) ) {

                  sprint (self,"You were told you can't change teams.\nGo play color games somewhere else.\n");
                  stuffcmd (self,"disconnect\n");
                  bprint (self.netname);
                  bprint (" has bad color sense\n");

               }
               if ( (self.ctf_killed != TRUE) ) {

                  self.ctf_killed = FL_SWIM;

               }
               T_Damage (self,self,self,1000.000);
               self.suicide_count = (self.suicide_count + TRUE);
               sprint (self,"You cannot change teams.\n");
               stuffcmd (self,"color ");
               n = (self.steam - TRUE);
               s = ftos (n);
               stuffcmd (self,s);
               stuffcmd (self,"\n");
               self.team = self.steam;
               return ;

            }

         } else {

            self.steam = -50.000;

         }

      }
      if ( (self.steam > FALSE) ) {

         if ( (self.ctf_killed != TRUE) ) {

            self.ctf_killed = FL_SWIM;

         }
         T_Damage (self,self,self,1000.000);

      }
      self.frags = FALSE;
      TeamCheckTeam ();

   }

};

void () TossBackpack = {

   local entity item;

   if ( (self.currentammo <= FALSE) ) {

      return ;

   }
   if ( (teamplay < TRUE) ) {

      return ;

   }
   item = spawn ();
   if ( ((self.weapon == IT_SHOTGUN) || (self.weapon == IT_SUPER_SHOTGUN)) ) {

      if ( (self.ammo_shells1 >= 20.000) ) {

         item.ammo_shells1 = 20.000;
         self.ammo_shells1 = (self.ammo_shells1 - 20.000);

      } else {

         item.ammo_shells1 = self.ammo_shells1;
         self.ammo_shells1 = FALSE;

      }

   }
   if ( (!(self.items & IT_SHOTGUN) && !(self.items & IT_SUPER_SHOTGUN)) ) {

      if ( (self.ammo_shells1 >= 20.000) ) {

         item.ammo_shells1 = 20.000;
         self.ammo_shells1 = (self.ammo_shells1 - 20.000);

      } else {

         item.ammo_shells1 = self.ammo_shells1;
         self.ammo_shells1 = FALSE;

      }

   }
   if ( ((self.weapon == IT_NAILGUN) || (self.weapon == IT_SUPER_NAILGUN)) ) {

      if ( (self.ammo_nails1 >= 20.000) ) {

         item.ammo_nails1 = 20.000;
         self.ammo_nails1 = (self.ammo_nails1 - 20.000);

      } else {

         item.ammo_nails1 = self.ammo_nails1;
         self.ammo_nails1 = FALSE;

      }

   }
   if ( ((self.weapon == IT_LAVA_NAILGUN) || (self.weapon == IT_LAVA_SUPER_NAILGUN)) ) {

      if ( (self.ammo_lava_nails >= 20.000) ) {

         item.ammo_lava_nails = 20.000;
         self.ammo_lava_nails = (self.ammo_lava_nails - 20.000);

      } else {

         item.ammo_lava_nails = self.ammo_lava_nails;
         self.ammo_lava_nails = FALSE;

      }

   }
   if ( (!(self.items & IT_NAILGUN) && !(self.items & IT_SUPER_NAILGUN)) ) {

      if ( (self.ammo_nails1 >= 20.000) ) {

         item.ammo_nails1 = 20.000;
         self.ammo_nails1 = (self.ammo_nails1 - 20.000);

      } else {

         item.ammo_nails1 = self.ammo_nails1;
         self.ammo_nails1 = FALSE;

      }
      if ( (self.ammo_lava_nails >= 20.000) ) {

         item.ammo_lava_nails = 20.000;
         self.ammo_lava_nails = (self.ammo_lava_nails - 20.000);

      } else {

         item.ammo_lava_nails = self.ammo_lava_nails;
         self.ammo_lava_nails = FALSE;

      }

   }
   if ( ((self.weapon == IT_GRENADE_LAUNCHER) || (self.weapon == IT_ROCKET_LAUNCHER)) ) {

      if ( (self.ammo_rockets1 >= MOVETYPE_BOUNCE) ) {

         item.ammo_rockets1 = MOVETYPE_BOUNCE;
         self.ammo_rockets1 = (self.ammo_rockets1 - MOVETYPE_BOUNCE);

      } else {

         item.ammo_rockets1 = self.ammo_rockets1;
         self.ammo_rockets1 = FALSE;

      }

   }
   if ( ((self.weapon == IT_MULTI_GRENADE) || (self.weapon == IT_MULTI_ROCKET)) ) {

      if ( (self.ammo_multi_rockets >= MOVETYPE_BOUNCE) ) {

         item.ammo_multi_rockets = MOVETYPE_BOUNCE;
         self.ammo_multi_rockets = (self.ammo_multi_rockets - MOVETYPE_BOUNCE);

      } else {

         item.ammo_multi_rockets = self.ammo_multi_rockets;
         self.ammo_multi_rockets = FALSE;

      }

   }
   if ( (!(self.items & IT_GRENADE_LAUNCHER) && !(self.items & IT_ROCKET_LAUNCHER)) ) {

      if ( (self.ammo_rockets1 >= MOVETYPE_BOUNCE) ) {

         item.ammo_rockets1 = MOVETYPE_BOUNCE;
         self.ammo_rockets1 = (self.ammo_rockets1 - MOVETYPE_BOUNCE);

      } else {

         item.ammo_rockets1 = self.ammo_rockets1;
         self.ammo_rockets1 = FALSE;

      }
      if ( (self.ammo_multi_rockets >= MOVETYPE_BOUNCE) ) {

         item.ammo_multi_rockets = MOVETYPE_BOUNCE;
         self.ammo_multi_rockets = (self.ammo_multi_rockets - MOVETYPE_BOUNCE);

      } else {

         item.ammo_multi_rockets = self.ammo_multi_rockets;
         self.ammo_multi_rockets = FALSE;

      }

   }
   if ( (self.weapon == IT_LIGHTNING) ) {

      if ( (self.ammo_cells1 >= 20.000) ) {

         item.ammo_cells1 = 20.000;
         self.ammo_cells1 = (self.ammo_cells1 - 20.000);

      } else {

         item.ammo_cells1 = self.ammo_cells1;
         self.ammo_cells1 = FALSE;

      }

   }
   if ( (self.weapon == IT_PLASMA_GUN) ) {

      if ( (self.ammo_plasma >= MOVETYPE_BOUNCE) ) {

         item.ammo_plasma = MOVETYPE_BOUNCE;
         self.ammo_plasma = (self.ammo_plasma - MOVETYPE_BOUNCE);

      } else {

         item.ammo_plasma = self.ammo_plasma;
         self.ammo_plasma = FALSE;

      }

   }
   if ( !(self.items & IT_LIGHTNING) ) {

      if ( (self.ammo_cells1 >= 20.000) ) {

         item.ammo_cells1 = 20.000;
         self.ammo_cells1 = (self.ammo_cells1 - 20.000);

      } else {

         item.ammo_cells1 = self.ammo_cells1;
         self.ammo_cells1 = FALSE;

      }
      if ( (self.ammo_plasma >= MOVETYPE_BOUNCE) ) {

         item.ammo_plasma = MOVETYPE_BOUNCE;
         self.ammo_plasma = (self.ammo_plasma - MOVETYPE_BOUNCE);

      } else {

         item.ammo_plasma = self.ammo_plasma;
         self.ammo_plasma = FALSE;

      }

   }
   if ( (((((((item.ammo_shells1 + item.ammo_nails1) + item.ammo_lava_nails) + item.ammo_rockets1) + item.ammo_multi_rockets) + item.ammo_cells1) + item.ammo_plasma) == FALSE) ) {

      sprint (self,"No ammo available!\n");
      remove (item);
      return ;

   }
   item.owner = self;
   makevectors (self.v_angle);
   setorigin (item,(self.origin + '0.000 0.000 16.000'));
   item.velocity = aim (self,1000.000);
   item.velocity = (item.velocity * 500.000);
   item.flags = FL_ITEM;
   item.solid = SOLID_TRIGGER;
   item.movetype = MOVETYPE_BOUNCE;
   setmodel (item,"progs/backpack.mdl");
   setsize (item,'-16.000 -16.000 0.000','16.000 16.000 56.000');
   item.touch = BackpackTouch;
   item.nextthink = (time + CTF_UPDATE_TIME);
   item.think = SUB_Remove;
   W_SetCurrentAmmo ();

};

void () Team_weapon_touch = {

   local float best;
   local float new;
   local float old;
   local entity stemp;

   if ( !(other.flags & FL_CLIENT) ) {

      return ;

   }
   if ( ((other == self.owner) && ((self.nextthink - time) > 119.000)) ) {

      return ;

   }
   stemp = self;
   self = other;
   best = W_BestWeapon ();
   self = stemp;
   if ( (self.classname == "weapon_nailgun") ) {

      new = IT_NAILGUN;

   } else {

      if ( (self.classname == "weapon_supernailgun") ) {

         new = IT_SUPER_NAILGUN;

      } else {

         if ( (self.classname == "weapon_supershotgun") ) {

            new = IT_SUPER_SHOTGUN;

         } else {

            if ( (self.classname == "weapon_rocketlauncher") ) {

               new = IT_ROCKET_LAUNCHER;

            } else {

               if ( (self.classname == "weapon_grenadelauncher") ) {

                  new = IT_GRENADE_LAUNCHER;

               } else {

                  if ( (self.classname == "weapon_lightning") ) {

                     new = IT_LIGHTNING;

                  } else {

                     objerror ("Team_weapon_touch: unknown classname");

                  }

               }

            }

         }

      }

   }
   sprint (other,"You got the ");
   sprint (other,self.netname);
   sprint (other,"\n");
   sound (other,CHAN_ITEM,"weapons/pkup.wav",TRUE,ATTN_NORM);
   stuffcmd (other,"bf\n");
   bound_other_ammo ();
   old = other.items;
   other.items = (other.items | new);
   remove (self);
   self = other;
   if ( !deathmatch ) {

      self.weapon = new;

   } else {

      Deathmatch_Weapon (old,new);

   }
   EnableComboWeapons (self);
   UpdateAmmoCounts (self);
   W_SetCurrentAmmo ();

};

void () TossWeapon = {

   local entity item;

   if ( (deathmatch != TRUE) ) {

      return ;

   }
   if ( (teamplay < TRUE) ) {

      return ;

   }
   if ( (((self.weapon == IT_AXE) || (self.weapon == IT_SHOTGUN)) || (self.weapon == IT_GRAPPLE)) ) {

      return ;

   }
   item = spawn ();
   item.owner = self;
   makevectors (self.v_angle);
   item.weapon = FALSE;
   setorigin (item,(self.origin + '0.000 0.000 16.000'));
   item.velocity = aim (self,1000.000);
   item.velocity = (item.velocity * 500.000);
   item.flags = FL_ITEM;
   item.solid = SOLID_TRIGGER;
   item.movetype = MOVETYPE_BOUNCE;
   if ( (self.weapon == IT_SUPER_SHOTGUN) ) {

      setmodel (item,"progs/g_shot.mdl");
      item.weapon = IT_SUPER_SHOTGUN;
      item.netname = "Double-barrelled Shotgun";
      item.classname = "weapon_supershotgun";
      self.items = (self.items - IT_SUPER_SHOTGUN);

   }
   if ( ((self.weapon == IT_NAILGUN) || (self.weapon == IT_LAVA_NAILGUN)) ) {

      setmodel (item,"progs/g_nail.mdl");
      item.weapon = IT_NAILGUN;
      item.netname = "nailgun";
      item.classname = "weapon_nailgun";
      self.items = (self.items - (self.items & (IT_NAILGUN | IT_LAVA_NAILGUN)));

   }
   if ( ((self.weapon == IT_SUPER_NAILGUN) || (self.weapon == IT_LAVA_SUPER_NAILGUN)) ) {

      setmodel (item,"progs/g_nail2.mdl");
      item.weapon = IT_SUPER_NAILGUN;
      item.netname = "Super Nailgun";
      item.classname = "weapon_supernailgun";
      self.items = (self.items - (self.items & (IT_SUPER_NAILGUN | IT_LAVA_SUPER_NAILGUN)));

   }
   if ( ((self.weapon == IT_GRENADE_LAUNCHER) || (self.weapon == IT_MULTI_GRENADE)) ) {

      setmodel (item,"progs/g_rock.mdl");
      item.weapon = IT_GRENADE_LAUNCHER;
      item.netname = "Grenade Launcher";
      item.classname = "weapon_grenadelauncher";
      self.items = (self.items - (self.items & (IT_GRENADE_LAUNCHER | IT_MULTI_GRENADE)));

   }
   if ( ((self.weapon == IT_ROCKET_LAUNCHER) || (self.weapon == IT_MULTI_ROCKET)) ) {

      setmodel (item,"progs/g_rock2.mdl");
      item.weapon = IT_ROCKET_LAUNCHER;
      item.netname = "Rocket Launcher";
      item.classname = "weapon_rocketlauncher";
      self.items = (self.items - (self.items & (IT_ROCKET_LAUNCHER | IT_MULTI_ROCKET)));

   }
   if ( ((self.weapon == IT_LIGHTNING) || (self.weapon == IT_PLASMA_GUN)) ) {

      setmodel (item,"progs/g_light.mdl");
      item.weapon = IT_LIGHTNING;
      item.netname = "Thunderbolt";
      item.classname = "weapon_lightning";
      self.items = (self.items - (self.items & (IT_LIGHTNING | IT_PLASMA_GUN)));

   }
   setsize (item,'-16.000 -16.000 0.000','16.000 16.000 56.000');
   item.touch = Team_weapon_touch;
   item.think = SUB_Remove;
   item.nextthink = (time + CTF_UPDATE_TIME);
   self.weapon = W_BestWeapon ();
   W_SetCurrentAmmo ();

};

void (entity flg) RegenFlag = {

   flg.movetype = MOVETYPE_TOSS;
   flg.solid = SOLID_TRIGGER;
   sound (flg,CHAN_VOICE,"items/itembk2.wav",TRUE,ATTN_NORM);
   setorigin (flg,flg.oldorigin);
   flg.angles = flg.mangle;
   flg.cnt = FLAG_AT_BASE;
   flg.owner = world;

};

void (entity flg) TeamReturnFlag = {

   local entity p;

   RegenFlag (flg);
   p = find (world,classname,"player");
   while ( (p != world) ) {

      if ( (teamplay == TEAM_CTF_ONEFLAG) ) {

         centerprint (p,"The flag has been returned!\n");

      } else {

         if ( (teamplay == TEAM_CTF_ALT) ) {

            if ( (flg.team == TEAM1) ) {

               centerprint (p,"“≈ƒ flag has been returned to base!\n");

            } else {

               if ( (flg.team == TEAM2) ) {

                  centerprint (p,"¬Ã’≈ flag has been returned to base!\n");

               } else {

                  centerprint (p,"Some flag has been returned to base!\n");

               }

            }

         } else {

            if ( (p.steam != flg.team) ) {

               centerprint (p,"Enemy flag has been returned to base!\n");

            } else {

               if ( (p.steam == flg.team) ) {

                  centerprint (p,"Your flag has been returned to base!\n");

               }

            }

         }

      }
      p = find (p,classname,"player");

   }

};

void () TeamRegenFlags = {

   local entity f;

   if ( (teamplay == TEAM_CTF_ONEFLAG) ) {

      f = find (world,classname,"item_flag");
      if ( (f != world) ) {

         RegenFlag (f);

      }
      return ;

   }
   f = find (world,classname,"item_flag_team1");
   if ( (f != world) ) {

      RegenFlag (f);

   }
   f = find (world,classname,"item_flag_team2");
   if ( (f != world) ) {

      RegenFlag (f);

   }

};

void (entity flg) TeamDropFlag = {

   local entity p;

   p = flg.owner;
   bprint (p.netname);
   if ( (teamplay == TEAM_CTF_ONEFLAG) ) {

      bprint (" ÏÔÛÙ the flag!\n");

   } else {

      if ( (flg.team == TEAM1) ) {

         bprint (" ÏÔÛÙ the “≈ƒ flag!\n");

      } else {

         bprint (" ÏÔÛÙ the ¬Ã’≈ flag!\n");

      }

   }
   setorigin (flg,(p.origin - '0.000 0.000 24.000'));
   flg.cnt = FLAG_DROPPED;
   flg.velocity_z = 300.000;
   flg.velocity_x = FALSE;
   flg.velocity_y = FALSE;
   flg.flags = FL_ITEM;
   flg.solid = SOLID_TRIGGER;
   flg.movetype = MOVETYPE_TOSS;
   setsize (flg,'-16.000 -16.000 0.000','16.000 16.000 74.000');
   flg.super_time = (time + CTF_FLAG_RETURN_TIME);

};

void (entity player) TeamDropFlagOfPlayer = {

   local string kn;
   local entity e;

   if ( ((teamplay == TEAM_CTF_ONEFLAG) && (player.ctf_flags & CTF_FLAG_FLAG)) ) {

      kn = "item_flag";

   } else {

      if ( (player.ctf_flags & CTF_FLAG_TEAM1) ) {

         kn = "item_flag_team1";

      } else {

         if ( (player.ctf_flags & CTF_FLAG_TEAM2) ) {

            kn = "item_flag_team2";

         } else {

            return ;

         }

      }

   }
   player.ctf_flags = (player.ctf_flags - (player.ctf_flags & ((CTF_FLAG_FLAG | CTF_FLAG_TEAM1) | CTF_FLAG_TEAM2)));
   e = find (world,classname,kn);
   if ( (e != world) ) {

      TeamDropFlag (e);

   }

};

void () TeamFlagTouch = {

   local entity p;

   if ( (other.classname != "player") ) {

      return ;

   }
   if ( (other.health <= FALSE) ) {

      return ;

   }
   if ( (other.team != other.steam) ) {

      return ;

   }
   if ( (self.cnt == FLAG_CARRIED) ) {

      return ;

   }
   if ( (teamplay == TEAM_CTF_ONEFLAG) ) {

      bprint (other.netname);
      bprint (" ÁÔÙ the flag!\n");
      centerprint (other,"Ÿœ’ «œ‘ ‘»≈ ∆Ã¡«\n\n‘¡À≈ …‘ ‘œ ≈Œ≈ÕŸ ¬¡”≈\n");
      sound (other,CHAN_ITEM,self.noise,TRUE,ATTN_NORM);
      other.ctf_flags = (other.ctf_flags | CTF_FLAG_FLAG);
      other.items = (other.items | self.items);
      other.ctf_flagsince = time;
      self.cnt = FLAG_CARRIED;
      self.movetype = MOVETYPE_NOCLIP;
      self.solid = SOLID_NOT;
      self.owner = other;
      p = find (world,classname,"player");
      while ( (p != world) ) {

         if ( (p != other) ) {

            centerprint (p,"The flag has been taken!\n");

         }
         p = find (p,classname,"player");

      }
      return ;

   }
   if ( ((teamplay != TEAM_CTF) && (teamplay != TEAM_CTF_ALT)) ) {

      return ;

   }
   if ( (self.team == other.steam) ) {

      if ( (self.cnt == FLAG_AT_BASE) ) {

         if ( (((self.team == TEAM1) && (other.ctf_flags & CTF_FLAG_TEAM2)) || ((self.team == TEAM2) && (other.ctf_flags & CTF_FLAG_TEAM1))) ) {

            bprint (other.netname);
            if ( (other.team == TEAM1) ) {

               bprint (" „·ÙıÚÂ‰ the ¬Ã’≈ flag!\n");

            } else {

               bprint (" „·ÙıÚÂ‰ the “≈ƒ flag!\n");

            }
            other.items = (other.items - (other.items & (IT_KEY1 | IT_KEY2)));
            sound (other,CHAN_VOICE,"misc/flagcap.wav",TRUE,ATTN_NONE);
            other.frags = (other.frags + CTF_CAPTURE_BONUS);
            p = find (world,classname,"player");
            while ( (p != world) ) {

               self = p;
               if ( ((self.team == other.team) && (self != other)) ) {

                  self.frags = (self.frags + CTF_TEAM_BONUS);

               }
               if ( (self.team != other.team) ) {

                  if ( (self.team == TEAM3) ) {

                     if ( (other.team == TEAM1) ) {

                        centerprint (self,"¬Ã’≈ flag was captured!\n");

                     } else {

                        centerprint (self,"“≈ƒ flag was captured!\n");

                     }

                  } else {

                     centerprint (self,"Your flag was captured!\n");

                  }
                  self.ctf_lasthurtcarrier = CONTENT_LAVA;

               } else {

                  if ( (self.team == other.team) ) {

                     centerprint (self,"Your team captured the flag!\n");
                     if ( ((self.ctf_lastreturnedflag + CTF_RETURN_FLAG_ASSIST_TIMEOUT) > time) ) {

                        bprint (self.netname);
                        if ( (self.team == TEAM1) ) {

                           bprint (" gets an assist for returning the “≈ƒ flag!\n");

                        } else {

                           bprint (" gets an assist for returning the ¬Ã’≈ flag!\n");

                        }
                        self.frags = (self.frags + CTF_RETURN_FLAG_ASSIST_BONUS);

                     }
                     if ( ((self.ctf_lastfraggedcarrier + CTF_FRAG_CARRIER_ASSIST_TIMEOUT) > time) ) {

                        bprint (self.netname);
                        bprint (" gets an assist for fragging the flag carrier!\n");
                        self.frags = (self.frags + CTF_FRAG_CARRIER_ASSIST_BONUS);

                     }

                  }

               }
               self.ctf_flags = (self.ctf_flags - (self.ctf_flags & (CTF_FLAG_TEAM1 | CTF_FLAG_TEAM2)));
               p = find (p,classname,"player");

            }
            TeamRegenFlags ();
            return ;

         }
         return ;

      }
      bprint (other.netname);
      if ( (other.team == TEAM1) ) {

         bprint (" ÚÂÙıÚÓÂ‰ the “≈ƒ flag!\n");

      } else {

         bprint (" ÚÂÙıÚÓÂ‰ the ¬Ã’≈ flag!\n");

      }
      other.frags = (other.frags + CTF_RECOVERY_BONUS);
      other.ctf_lastreturnedflag = time;
      sound (other,CHAN_ITEM,self.noise1,TRUE,ATTN_NORM);
      TeamReturnFlag (self);
      return ;

   }
   if ( (other.ctf_flags & (CTF_FLAG_TEAM1 | CTF_FLAG_TEAM2)) ) {

      return ;

   }
   bprint (other.netname);
   if ( (self.team == TEAM1) ) {

      bprint (" ÁÔÙ the “≈ƒ flag!\n");

   } else {

      bprint (" ÁÔÙ the ¬Ã’≈ flag!\n");

   }
   if ( (other.team == TEAM3) ) {

      centerprint (other,"Ÿœ’ «œ‘ ‘»≈ ≈Œ≈ÕŸ ∆Ã¡«\n\n“≈‘’“Œ …‘ ‘œ ‘»≈ œ‘»≈“ ¬¡”≈\n");

   } else {

      centerprint (other,"Ÿœ’ «œ‘ ‘»≈ ≈Œ≈ÕŸ ∆Ã¡«\n\n“≈‘’“Œ ‘œ ¬¡”≈\n");

   }
   sound (other,CHAN_ITEM,self.noise,TRUE,ATTN_NORM);
   if ( (self.team == TEAM1) ) {

      other.ctf_flags = (other.ctf_flags | CTF_FLAG_TEAM1);

   } else {

      other.ctf_flags = (other.ctf_flags | CTF_FLAG_TEAM2);

   }
   other.items = (other.items | self.items);
   other.ctf_flagsince = time;
   self.cnt = FLAG_CARRIED;
   self.movetype = MOVETYPE_NOCLIP;
   self.solid = SOLID_NOT;
   self.owner = other;
   p = find (world,classname,"player");
   while ( (p != world) ) {

      if ( (p != other) ) {

         if ( (p.steam == self.team) ) {

            centerprint (p,"Your flag has been taken!\n");

         } else {

            if ( (p.steam == other.team) ) {

               if ( (self.team == TEAM1) ) {

                  centerprint (p,"Your team has the “≈ƒ flag!\n");

               } else {

                  centerprint (p,"Your team has the ¬Ã’≈ flag!\n");

               }

            } else {

               if ( (self.team == TEAM1) ) {

                  if ( (other.steam == TEAM2) ) {

                     centerprint (p,"¬Ã’≈ team has the “≈ƒ flag!\n");

                  } else {

                     centerprint (p,"«“≈Ÿ team has the “≈ƒ flag!\n");

                  }

               } else {

                  if ( (other.steam == TEAM1) ) {

                     centerprint (p,"“≈ƒ team has the ¬Ã’≈ flag!\n");

                  } else {

                     centerprint (p,"«“≈Ÿ team has the ¬Ã’≈ flag!\n");

                  }

               }

            }

         }

      }
      p = find (p,classname,"player");

   }

};

void () TeamFlagBaseTouch = {

   local entity p;
   local entity f;

   if ( (other.classname != "player") ) {

      return ;

   }
   if ( (other.health <= FALSE) ) {

      return ;

   }
   if ( (other.team != other.steam) ) {

      return ;

   }
   if ( (teamplay == TEAM_CTF_ONEFLAG) ) {

      if ( ((((self.team == TEAM1) && (other.steam == TEAM2)) || ((self.team == TEAM2) && (other.steam == TEAM1))) && (other.ctf_flags & CTF_FLAG_FLAG)) ) {

         bprint (other.netname);
         bprint (" „·ÙıÚÂ‰ the flag!\n");
         other.items = (other.items - (other.items & (IT_KEY1 | IT_KEY2)));
         sound (other,CHAN_VOICE,"misc/flagcap.wav",TRUE,ATTN_NONE);
         other.frags = (other.frags + CTF_CAPTURE_BONUS);
         p = find (world,classname,"player");
         while ( (p != world) ) {

            self = p;
            if ( ((self.team == other.team) && (self != other)) ) {

               self.frags = (self.frags + CTF_TEAM_BONUS);

            }
            if ( (self.team != other.team) ) {

               self.ctf_lasthurtcarrier = CONTENT_LAVA;

            } else {

               if ( (self.team == other.team) ) {

                  if ( ((self.ctf_lastfraggedcarrier + CTF_FRAG_CARRIER_ASSIST_TIMEOUT) > time) ) {

                     bprint (self.netname);
                     bprint (" gets an assist for fragging the flag carrier!\n");
                     self.frags = (self.frags + CTF_FRAG_CARRIER_ASSIST_BONUS);

                  }

               }

            }
            self.ctf_flags = (self.ctf_flags - (self.ctf_flags & CTF_FLAG_FLAG));
            p = find (p,classname,"player");

         }
         TeamRegenFlags ();
         return ;

      }

   }
   if ( ((teamplay != TEAM_CTF_ALT) || (other.steam != TEAM3)) ) {

      return ;

   }
   if ( (((other.ctf_flags & CTF_FLAG_TEAM1) && (self.team == TEAM2)) || ((other.ctf_flags & CTF_FLAG_TEAM2) && (self.team == TEAM1))) ) {

      bprint (other.netname);
      if ( (self.team == TEAM1) ) {

         bprint (" „·ÙıÚÂ‰ the ¬Ã’≈ flag!\n");

      } else {

         bprint (" „·ÙıÚÂ‰ the “≈ƒ flag!\n");

      }
      other.items = (other.items - (other.items & (IT_KEY1 | IT_KEY2)));
      sound (other,CHAN_VOICE,"misc/flagcap.wav",TRUE,ATTN_NONE);
      other.frags = (other.frags + CTF_ALT_CAPTURE_BONUS);
      p = find (world,classname,"player");
      while ( (p != world) ) {

         self = p;
         if ( ((self.team == other.team) && (self != other)) ) {

            self.frags = (self.frags + CTF_ALT_TEAM_BONUS);

         }
         if ( (self.team != other.team) ) {

            if ( ((other.ctf_flags & CTF_FLAG_TEAM1) && (self.team == TEAM1)) ) {

               centerprint (self,"Your flag was captured!\n");

            } else {

               if ( ((other.ctf_flags & CTF_FLAG_TEAM2) && (self.team == TEAM2)) ) {

                  centerprint (self,"The enemy flag was captured!\n");

               }

            }
            self.ctf_lasthurtcarrier = CONTENT_LAVA;

         } else {

            if ( (self.team == other.team) ) {

               centerprint (self,"Your team captured the flag!\n");

            }

         }
         p = find (p,classname,"player");

      }
      if ( (other.ctf_flags & CTF_FLAG_TEAM1) ) {

         f = find (world,classname,"item_flag_team1");
         if ( (f != world) ) {

            RegenFlag (f);

         }

      } else {

         f = find (world,classname,"item_flag_team2");
         if ( (f != world) ) {

            RegenFlag (f);

         }

      }
      other.ctf_flags = (other.ctf_flags - (other.ctf_flags & (CTF_FLAG_TEAM1 | CTF_FLAG_TEAM2)));
      return ;

   }

};

void () TeamFlagThink = {

   local entity e;
   local vector v;
   local float f;

   self.nextthink = (time + 0.100);
   if ( (self.cnt == FLAG_AT_BASE) ) {

      return ;

   }
   if ( (self.cnt == FLAG_DROPPED) ) {

      if ( ((time - self.super_time) > CTF_FLAG_RETURN_TIME) ) {

         TeamReturnFlag (self);

      }
      return ;

   }
   if ( (self.cnt != FLAG_CARRIED) ) {

      objerror ("Flag in invalid state\n");

   }
   e = self.owner;
   if ( ((e.classname != "player") || e.deadflag) ) {

      TeamDropFlag (self);
      return ;

   }
   if ( ((teamplay == TEAM_CTF_ONEFLAG) && !(e.ctf_flags & CTF_FLAG_FLAG)) ) {

      TeamDropFlag (self);
      return ;

   }
   if ( ((!(e.ctf_flags & CTF_FLAG_TEAM1) && (self.team == TEAM1)) || (!(e.ctf_flags & CTF_FLAG_TEAM2) && (self.team == TEAM2))) ) {

      TeamDropFlag (self);
      return ;

   }
   makevectors (e.angles);
   v = v_forward;
   v_z = (CONTENT_EMPTY * v_z);
   f = TEAM2;
   if ( ((self.owner.frame >= 29.000) && (self.owner.frame <= CTF_FLAG_RETURN_TIME)) ) {

      if ( ((self.owner.frame >= 29.000) && (self.owner.frame <= SVC_CUTSCENE)) ) {

         if ( (self.owner.frame == 29.000) ) {

            f = (f + FL_SWIM);

         } else {

            if ( (self.owner.frame == SVC_INTERMISSION) ) {

               f = (f + FL_CLIENT);

            } else {

               if ( (self.owner.frame == SVC_FINALE) ) {

                  f = (f + STAT_TOTALMONSTERS);

               } else {

                  if ( (self.owner.frame == FL_MONSTER) ) {

                     f = (f + MOVETYPE_BOUNCEMISSILE);

                  } else {

                     if ( (self.owner.frame == SVC_SELLSCREEN) ) {

                        f = (f + MOVETYPE_BOUNCE);

                     } else {

                        if ( (self.owner.frame == SVC_CUTSCENE) ) {

                           f = (f + MOVETYPE_STEP);

                        }

                     }

                  }

               }

            }

         }

      } else {

         if ( ((self.owner.frame >= 35.000) && (self.owner.frame <= CTF_FLAG_RETURN_TIME)) ) {

            if ( (self.owner.frame == 35.000) ) {

               f = (f + FL_SWIM);

            } else {

               if ( (self.owner.frame == 36.000) ) {

                  f = (f + MOVETYPE_BOUNCE);

               } else {

                  if ( (self.owner.frame == 37.000) ) {

                     f = (f + MOVETYPE_BOUNCE);

                  } else {

                     if ( (self.owner.frame == 38.000) ) {

                        f = (f + FL_CLIENT);

                     } else {

                        if ( (self.owner.frame == 39.000) ) {

                           f = (f + MOVETYPE_STEP);

                        } else {

                           if ( (self.owner.frame == CTF_FLAG_RETURN_TIME) ) {

                              f = (f + FL_SWIM);

                           }

                        }

                     }

                  }

               }

            }

         }

      }

   } else {

      if ( ((self.owner.frame >= 103.000) && (self.owner.frame <= 118.000)) ) {

         if ( ((self.owner.frame >= 103.000) && (self.owner.frame <= 104.000)) ) {

            f = (f + MOVETYPE_TOSS);

         } else {

            if ( ((self.owner.frame >= 105.000) && (self.owner.frame <= 106.000)) ) {

               f = (f + MOVETYPE_TOSS);

            } else {

               if ( ((self.owner.frame >= 107.000) && (self.owner.frame <= 112.000)) ) {

                  f = (f + MOVETYPE_PUSH);

               } else {

                  if ( ((self.owner.frame >= 112.000) && (self.owner.frame <= 118.000)) ) {

                     f = (f + MOVETYPE_PUSH);

                  }

               }

            }

         }

      }

   }
   self.origin = (((e.origin + '0.000 0.000 -16.000') - (f * v)) + (v_right * 22.000));
   self.angles = (e.angles + '0.000 0.000 -45.000');
   setorigin (self,self.origin);
   self.nextthink = (time + 0.010);

};

void () TeamFlagStatusReport = {

   local entity flag1;
   local entity flag2;
   local entity p;
   local string n;

   if ( !deathmatch ) {

      return ;

   }
   if ( (((teamplay != TEAM_CTF) && (teamplay != TEAM_CTF_ONEFLAG)) && (teamplay != TEAM_CTF_ALT)) ) {

      sprint (self,"Capture the Flag is not enabled.\n");
      return ;

   }
   if ( (teamplay == TEAM_CTF_ONEFLAG) ) {

      flag1 = find (world,classname,"item_flag");
      if ( (flag1 == world) ) {

         sprint (self,"The flag is missing!\n");

      } else {

         if ( (flag1.cnt == FLAG_AT_BASE) ) {

            sprint (self,"The flag is at base!\n");

         } else {

            if ( (flag1.cnt == FLAG_DROPPED) ) {

               sprint (self,"The flag is lying about!\n");

            } else {

               if ( (flag1.cnt == FLAG_CARRIED) ) {

                  if ( (flag1.owner == self) ) {

                     sprint (self,"You have the flag!\n");

                  } else {

                     sprint (self,flag1.owner.netname);
                     n = GetCTFTeam (flag1.owner.steam);
                     sprint (self," of the ");
                     sprint (self,n);
                     sprint (self," team has the flag!\n");

                  }

               } else {

                  sprint (self,"The flag is screwed up!\n");

               }

            }

         }

      }
      return ;

   }
   if ( (teamplay == TEAM_CTF) ) {

      flag1 = find (world,classname,"item_flag_team1");
      flag2 = find (world,classname,"item_flag_team2");
      if ( (self.team != TEAM1) ) {

         p = flag1;
         flag1 = flag2;
         flag2 = p;

      }
      if ( ((flag1 != world) && (flag1.cnt == FLAG_CARRIED)) ) {

         sprint (self,flag1.owner.netname);
         sprint (self," has your flag. ");

      } else {

         sprint (self,"Your flag is ");
         if ( (flag1 == world) ) {

            sprint (self,"missing!\n");

         }
         if ( (flag1.cnt == FLAG_AT_BASE) ) {

            sprint (self,"in your base.\n");

         } else {

            if ( (flag1.cnt == FLAG_DROPPED) ) {

               sprint (self,"lying about.\n");

            } else {

               sprint (self," corrupt.\n");

            }

         }

      }
      if ( ((flag2 != world) && (flag2.cnt == FLAG_CARRIED)) ) {

         if ( (self == flag2.owner) ) {

            sprint (self,"You have the enemy flag.\n");

         } else {

            sprint (self,flag2.owner.netname);
            sprint (self," has the enemy flag.\n");

         }

      } else {

         sprint (self,"The enemy flag is ");
         if ( (flag2 == world) ) {

            sprint (self,"missing!\n");

         }
         if ( (flag2.cnt == FLAG_AT_BASE) ) {

            sprint (self,"in their base.\n");

         } else {

            if ( (flag2.cnt == FLAG_DROPPED) ) {

               sprint (self,"lying about.\n");

            } else {

               sprint (self," corrupt.\n");

            }

         }

      }

   }
   if ( (teamplay == TEAM_CTF_ALT) ) {

      flag1 = find (world,classname,"item_flag_team1");
      flag2 = find (world,classname,"item_flag_team2");
      if ( ((flag1 != world) && (flag1.cnt == FLAG_CARRIED)) ) {

         if ( (flag1.owner == self) ) {

            sprint (self,"You have the “≈ƒ flag!\n");

         } else {

            sprint (self,flag1.owner.netname);
            n = GetCTFTeam (flag1.owner.steam);
            sprint (self," of the ");
            sprint (self,n);
            sprint (self," team has the “≈ƒ flag.\n");

         }

      } else {

         if ( (self.steam == flag1.team) ) {

            sprint (self,"Your flag is ");

         } else {

            sprint (self,"“≈ƒ flag is ");

         }
         if ( (flag1 == world) ) {

            sprint (self,"missing!\n");

         }
         if ( (flag1.cnt == FLAG_AT_BASE) ) {

            sprint (self,"at base.\n");

         } else {

            if ( (flag1.cnt == FLAG_DROPPED) ) {

               sprint (self,"lying about.\n");

            } else {

               sprint (self," corrupt.\n");

            }

         }

      }
      if ( ((flag2 != world) && (flag2.cnt == FLAG_CARRIED)) ) {

         if ( (flag2.owner == self) ) {

            sprint (self,"You have the ¬Ã’≈ flag.\n");

         } else {

            sprint (self,flag2.owner.netname);
            n = GetCTFTeam (flag2.owner.steam);
            sprint (self," of the ");
            sprint (self,n);
            sprint (self," team has the ¬Ã’≈ flag.\n");

         }

      } else {

         if ( (self.steam == flag1.team) ) {

            sprint (self,"Your flag is ");

         } else {

            sprint (self,"¬Ã’≈ flag is ");

         }
         if ( (flag2 == world) ) {

            sprint (self,"missing!\n");

         }
         if ( (flag2.cnt == FLAG_AT_BASE) ) {

            sprint (self,"at base.\n");

         } else {

            if ( (flag2.cnt == FLAG_DROPPED) ) {

               sprint (self,"lying about.\n");

            } else {

               sprint (self," corrupt.\n");

            }

         }

      }

   }

};

void () place_flag = {

   self.mdl = self.model;
   self.flags = FL_ITEM;
   self.solid = SOLID_TRIGGER;
   self.movetype = MOVETYPE_TOSS;
   self.velocity = VEC_ORIGIN;
   self.origin_z = (self.origin_z + MOVETYPE_TOSS);
   self.think = TeamFlagThink;
   self.touch = TeamFlagTouch;
   self.nextthink = (time + 0.100);
   self.cnt = FLAG_AT_BASE;
   self.mangle = self.angles;
   self.effects = (self.effects | EF_DIMLIGHT);
   if ( !droptofloor () ) {

      dprint ("Flag fell out of level at ");
      dprint (vtos (self.origin));
      dprint ("\n");
      remove (self);
      return ;

   }
   self.oldorigin = self.origin;

};

void (entity flg, string cname) place_flagbase = {

   local entity oself;

   teamplay = cvar ("teamplay");
   oself = self;
   self = spawn ();
   self.classname = cname;
   setorigin (self,flg.origin);
   self.angles = flg.angles;
   precache_model ("progs/ctfbase.mdl");
   setmodel (self,"progs/ctfbase.mdl");
   self.skin = flg.skin;
   self.team = flg.team;
   setsize (self,'-8.000 -8.000 0.000','8.000 8.000 8.000');
   self.flags = FL_ITEM;
   self.movetype = MOVETYPE_TOSS;
   self.velocity = VEC_ORIGIN;
   self.origin_z = (self.origin_z + MOVETYPE_TOSS);
   if ( ((teamplay == TEAM_CTF_ONEFLAG) || (teamplay == TEAM_CTF_ALT)) ) {

      self.solid = SOLID_TRIGGER;
      self.touch = TeamFlagBaseTouch;

   } else {

      self.solid = SOLID_NOT;

   }
   if ( !droptofloor () ) {

      dprint ("Flagbase fell out of level at ");
      dprint (vtos (self.origin));
      dprint ("\n");
      remove (self);
      self = oself;
      return ;

   }
   self = oself;

};

void () item_flag_team1 = {

   if ( !deathmatch ) {

      remove (self);
      return ;

   }
   teamplay = cvar ("teamplay");
   if ( (teamplay == TEAM_CTF_ONEFLAG) ) {

      precache_sound ("misc/flagtk.wav");
      precache_sound ("misc/flagcap.wav");
      self.skin = FALSE;
      self.team = TEAM1;
      place_flagbase (self,"item_flagbase_team1");
      remove (self);
      return ;

   }
   if ( ((teamplay == TEAM_CTF) || (teamplay == TEAM_CTF_ALT)) ) {

      self.team = TEAM1;
      self.items = IT_KEY2;
      precache_model ("progs/ctfmodel.mdl");
      setmodel (self,"progs/ctfmodel.mdl");
      self.skin = FALSE;
      precache_sound ("misc/flagtk.wav");
      precache_sound ("misc/flagcap.wav");
      precache_sound ("misc/flagret.wav");
      self.noise = "misc/flagtk.wav";
      self.noise1 = "misc/flagret.wav";
      setsize (self,'-16.000 -16.000 0.000','16.000 16.000 74.000');
      self.nextthink = (time + 0.200);
      self.think = place_flag;
      place_flagbase (self,"item_flagbase_team1");

   } else {

      remove (self);

   }

};

void () item_flag_team2 = {

   if ( !deathmatch ) {

      remove (self);
      return ;

   }
   teamplay = cvar ("teamplay");
   if ( (teamplay == TEAM_CTF_ONEFLAG) ) {

      precache_sound ("misc/flagtk.wav");
      precache_sound ("misc/flagcap.wav");
      self.team = TEAM2;
      self.skin = TRUE;
      place_flagbase (self,"item_flagbase_team2");
      remove (self);
      return ;

   }
   if ( ((teamplay == TEAM_CTF) || (teamplay == TEAM_CTF_ALT)) ) {

      self.team = TEAM2;
      self.items = IT_KEY1;
      precache_model ("progs/ctfmodel.mdl");
      setmodel (self,"progs/ctfmodel.mdl");
      self.skin = TRUE;
      precache_sound ("misc/flagtk.wav");
      precache_sound ("misc/flagcap.wav");
      precache_sound ("misc/flagret.wav");
      self.noise = "misc/flagtk.wav";
      self.noise1 = "misc/flagret.wav";
      setsize (self,'-16.000 -16.000 0.000','16.000 16.000 74.000');
      self.nextthink = (time + 0.200);
      self.think = place_flag;
      place_flagbase (self,"item_flagbase_team2");

   } else {

      remove (self);

   }

};

void () item_flag = {

   if ( (cvar ("teamplay") != TEAM_CTF_ONEFLAG) ) {

      remove (self);
      return ;

   }
   self.team = FALSE;
   self.items = (IT_KEY1 | IT_KEY2);
   precache_model ("progs/ctfmodel.mdl");
   setmodel (self,"progs/ctfmodel.mdl");
   self.skin = FL_SWIM;
   precache_sound ("misc/flagtk.wav");
   precache_sound ("misc/flagcap.wav");
   precache_sound ("misc/flagret.wav");
   self.noise = "misc/flagtk.wav";
   self.noise1 = "misc/flagret.wav";
   setsize (self,'-16.000 -16.000 0.000','16.000 16.000 74.000');
   self.nextthink = (time + 0.200);
   self.think = place_flag;
   place_flagbase (self,"item_flagbase");

};

void () info_player_team1 = {


};

void () info_player_team2 = {


};

void () TeamSetUpdate = {

   nextteamupdtime = (time + CTF_UPDATE_TIME);

};

void () TeamCheckUpdate = {

   local float total1;
   local float total2;
   local float total3;
   local entity p;
   local string s;
   local string ts1;
   local string ts2;
   local string ts3;

   if ( (((nextteamupdtime > time) || (teamplay < TRUE)) || !deathmatch) ) {

      return ;

   }
   TeamSetUpdate ();
   total3 = FALSE;
   total2 = FALSE;
   total1 = FALSE;
   ts1 = GetCTFTeam (TEAM1);
   ts2 = GetCTFTeam (TEAM2);
   ts3 = GetCTFTeam (TEAM3);
   if ( (((teamplay == TEAM_CTF) || (teamplay == TEAM_CTF_ALT)) || (teamplay == TEAM_CTF_ONEFLAG)) ) {

      p = find (world,classname,"player");
      while ( (p != world) ) {

         if ( (p.steam == TEAM1) ) {

            total1 = (total1 + p.frags);

         } else {

            if ( (p.steam == TEAM2) ) {

               total2 = (total2 + p.frags);

            } else {

               if ( (p.steam == TEAM3) ) {

                  total3 = (total3 + p.frags);

               }

            }

         }
         p = find (p,classname,"player");

      }
      if ( ((teamplay == TEAM_CTF) || (teamplay == TEAM_CTF_ONEFLAG)) ) {

         if ( (total1 > total2) ) {

            bprint (ts1);
            bprint (" team is leading by ");
            s = ftos ((total1 - total2));
            bprint (s);
            bprint (" points!\n");

         } else {

            if ( (total1 < total2) ) {

               bprint (ts2);
               bprint (" team is leading by ");
               s = ftos ((total2 - total1));
               bprint (s);
               bprint (" points!\n");

            } else {

               bprint (ts1);
               bprint (" and ");
               bprint (ts2);
               bprint (" teams are tied with ");
               s = ftos (total1);
               bprint (s);
               bprint (" points!\n");

            }

         }

      } else {

         if ( (teamplay == TEAM_CTF_ALT) ) {

            if ( ((total1 > total2) && (total1 > total3)) ) {

               bprint (ts1);
               bprint (" team is leading by ");
               if ( (total2 > total3) ) {

                  s = ftos ((total1 - total2));

               } else {

                  s = ftos ((total1 - total3));

               }
               bprint (s);
               bprint (" points!\n");

            } else {

               if ( ((total2 > total1) && (total2 > total3)) ) {

                  bprint (ts2);
                  bprint (" team is leading by ");
                  if ( (total1 > total3) ) {

                     s = ftos ((total2 - total1));

                  } else {

                     s = ftos ((total2 - total3));

                  }
                  bprint (s);
                  bprint (" points!\n");

               } else {

                  if ( ((total3 > total1) && (total3 > total2)) ) {

                     bprint (ts3);
                     bprint (" team is leading by ");
                     if ( (total1 > total2) ) {

                        s = ftos ((total3 - total1));

                     } else {

                        s = ftos ((total3 - total2));

                     }
                     bprint (s);
                     bprint (" points!\n");

                  } else {

                     if ( (total1 == total2) ) {

                        bprint (ts1);
                        bprint (" and ");
                        bprint (ts2);
                        bprint (" teams are tied with ");
                        s = ftos (total1);
                        bprint (s);
                        bprint (" points!\n");

                     } else {

                        if ( (total3 == total2) ) {

                           bprint (ts2);
                           bprint (" and ");
                           bprint (ts3);
                           bprint (" teams are tied with ");
                           s = ftos (total3);
                           bprint (s);
                           bprint (" points!\n");

                        } else {

                           if ( (total3 == total1) ) {

                              bprint (ts1);
                              bprint (" and ");
                              bprint (ts3);
                              bprint (" teams are tied with ");
                              s = ftos (total1);
                              bprint (s);
                              bprint (" points!\n");

                           } else {

                              bprint (ts1);
                              bprint (", ");
                              bprint (ts2);
                              bprint (" and ");
                              bprint (ts3);
                              bprint (" teams are tied with ");
                              s = ftos (total1);
                              bprint (s);
                              bprint (" points!\n");

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

void () func_ctf_wall = {

   teamplay = cvar ("teamplay");
   if ( (((teamplay == TEAM_CTF) || (teamplay == TEAM_CTF_ONEFLAG)) || (teamplay == TEAM_CTF_ALT)) ) {

      self.angles = VEC_ORIGIN;
      self.movetype = MOVETYPE_PUSH;
      self.solid = SOLID_BSP;
      setmodel (self,self.model);

   } else {

      remove (self);

   }

};

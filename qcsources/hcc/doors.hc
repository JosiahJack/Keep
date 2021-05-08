float DOOR_START_OPEN   =  1.00000;
float REVERSE   =  2.00000;
float DOOR_DONT_LINK   =  4.00000;
float DOOR_TOGGLE   =  8.00000;
float DOOR_SLIDE   =  16.00000;
float DOOR_NORMAL   =  32.00000;
float DOOR_REMOVE_PP   =  64.00000;
float DOOR_NO_PP   =  128.00000;
void  ()door_hit_bottom;
void  ()door_hit_top;

void  ()door_slide_next =  {
local vector vdestdelta = '0.00000 0.00000 0.00000';
local vector odelta = '0.00000 0.00000 0.00000';
local float len = 0.00000;
local float tspeed = 0.00000;
   tspeed = self.speed;
   if ( !tspeed ) {

      objerror ( "No speed is defined!");

   }
   if ( (self.finaldest == self.origin) ) {

      self.velocity = '0.00000 0.00000 0.00000';
      if ( (self.state == STATE_DOWN) ) {

         self.think = door_hit_bottom;
      } else {

         if ( (self.state == STATE_UP) ) {

            self.think = door_hit_top;

         }

      }
      self.nextthink = (self.ltime + 0.10000);
      return ;

   }
   vdestdelta = (self.finaldest - self.origin);
   odelta = (self.origin - self.pos1);
   len = vlen ( odelta);
   if ( (vlen ( vdestdelta) < 0.10000) ) {

      if ( (self.state == STATE_DOWN) ) {

         door_hit_bottom ( );
      } else {

         if ( (self.state == STATE_UP) ) {

            door_hit_top ( );
         } else {

            dprint ( "Bad door state!\n");

         }

      }
      return ;

   }
   self.nextthink = (self.ltime + 0.10000);
   self.think = door_slide_next;
   tspeed = ((self.speed - (len / 10.00000)) / 20.00000);
   if ( (tspeed < 2.00000) ) {

      if ( (self.state == STATE_DOWN) ) {

         SUB_CalcMove ( self.finaldest, self.speed, door_hit_bottom);
      } else {

         if ( (self.state == STATE_UP) ) {

            SUB_CalcMove ( self.finaldest, self.speed, door_hit_top);
         } else {

            dprint ( "Bad door state!\n");

         }

      }
      return ;

   }
   self.velocity = (vdestdelta * tspeed);
};


void  (vector tdest)door_slide =  {
   self.finaldest = tdest;
   door_slide_next ( );
};


void  ()door_crash_next =  {
local vector vdestdelta = '0.00000 0.00000 0.00000';
local vector nextvect = '0.00000 0.00000 0.00000';
local vector testvect = '0.00000 0.00000 0.00000';
local vector tdest = '0.00000 0.00000 0.00000';
local float len = 0.00000;
local float nextlen = 0.00000;
local float testlen = 0.00000;
local float tspeed = 0.00000;
   tdest = self.finaldest;
   tspeed = self.speed;
   if ( !tspeed ) {

      objerror ( "No speed is defined!");

   }
   if ( (tdest == self.origin) ) {

      self.velocity = '0.00000 0.00000 0.00000';
      if ( (self.state == STATE_DOWN) ) {

         self.think = door_hit_bottom;
      } else {

         if ( (self.state == STATE_UP) ) {

            self.think = door_hit_top;
         } else {

            dprint ( "Bad door state!\n");

         }

      }
      self.nextthink = (self.ltime + 0.10000);
      return ;

   }
   vdestdelta = (self.finaldest - self.origin);
   nextvect = (self.pos2 - self.origin);
   testvect = (self.pos2 - self.finaldest);
   len = vlen ( vdestdelta);
   nextlen = (vlen ( nextvect) + 1.00000);
   testlen = vlen ( testvect);
   if ( ((len < 0.10000) || (nextlen > testlen)) ) {

      return ;
   } else {

      self.velocity = ((vdestdelta * (nextlen / len)) * 4.00000);
      nextvect = (self.origin + self.velocity);
      nextlen = vlen ( nextvect);
      if ( (nextlen >= (testlen * 2.00000)) ) {

         SUB_CalcMove ( self.finaldest, (self.speed * (len / (len / 3.00000))), door_hit_bottom);
         return ;

      }

   }
   self.nextthink = (self.ltime + 0.10000);
   self.think = door_crash_next;
};


void  (vector tdest)door_crash =  {
   self.finaldest = tdest;
   door_crash_next ( );
};

void  ()door_go_down;
void  ()door_go_up;

void  ()door_damage =  {
   T_Damage ( other, self, self, self.dmg);
};


void  ()door_blocked =  {
   if ( ((self.wait > -2.00000) && (self.strength <= 0.00000)) ) {

      if ( (self.dmg == 666.00000) ) {

         if ( ((other.classname == "player") && (other.flags2 & FL_ALIVE)) ) {

            other.decap = TRUE;
            T_Damage ( other, self, self, (other.health + 300.00000));
         } else {

            T_Damage ( other, self, self, (other.health + 50.00000));

         }
      } else {

         T_Damage ( other, self, self, self.dmg);

      }

   }
   if ( (((other.flags & FL_ONGROUND) && (self.movedir_x || self.movedir_z)) && (self.strength == 1.00000)) ) {

      other.flags ^= FL_ONGROUND;
      other.velocity_z += (self.speed * 2.00000);
      other.velocity_x -= (self.speed * self.movedir_x);
      other.velocity_y -= (self.speed * self.movedir_z);
   } else {

      other.flags ^= FL_ONGROUND;
      other.velocity_z += 10.00000;

   }
   if ( (self.wait >= 0.00000) ) {

      if ( (self.state == STATE_DOWN) ) {

         door_go_up ( );
      } else {

         door_go_down ( );

      }

   }
};


void  ()door_hit_top =  {
   self.velocity = '0.00000 0.00000 0.00000';
   sound ( self, CHAN_VOICE, self.noise1, 1.00000, ATTN_NORM);
   self.state = STATE_TOP;
   if ( (self.spawnflags & DOOR_TOGGLE) ) {

      return ;

   }
   if ( (self.wait == -2.00000) ) {

      self.th_die ( );
   } else {

      if ( (self.wait == -1.00000) ) {

         self.nextthink = -1.00000;
      } else {

         self.think = door_go_down;
         self.nextthink = (self.ltime + self.wait);

      }

   }
};


void  ()door_hit_bottom =  {
   self.velocity = '0.00000 0.00000 0.00000';
   sound ( self, CHAN_VOICE, self.noise1, 1.00000, ATTN_NORM);
   self.state = STATE_BOTTOM;
};


void  ()door_go_down =  {
   sound ( self, CHAN_VOICE, self.noise2, 1.00000, ATTN_NORM);
   if ( (!self.thingtype && self.max_health) ) {

      self.takedamage = DAMAGE_YES;
      self.health = self.max_health;

   }
   self.state = STATE_DOWN;
   if ( (self.classname == "door") ) {

      if ( (self.spawnflags & DOOR_SLIDE) ) {

         door_slide ( self.pos1);
      } else {

         if ( (self.spawnflags & DOOR_NORMAL) ) {

            if ( (self.v_angle != '0.00000 0.00000 0.00000') ) {

               if ( self.speed ) {

                  if ( self.anglespeed ) {

                     SUB_CalcMoveAndAngleInit ( self.pos1, self.speed, self.o_angle, self.anglespeed, door_hit_bottom, FALSE);
                  } else {

                     SUB_CalcMoveAndAngleInit ( self.pos1, self.speed, self.o_angle, self.anglespeed, door_hit_bottom, TRUE);

                  }
               } else {

                  SUB_CalcAngleMove ( self.o_angle, self.anglespeed, door_hit_bottom);

               }
            } else {

               SUB_CalcMove ( self.pos1, self.speed, door_hit_bottom);

            }
         } else {

            door_crash ( self.pos1);

         }

      }
   } else {

      if ( (self.classname == "door_rotating") ) {

         SUB_CalcAngleMove ( self.pos1, self.speed, door_hit_bottom);

      }

   }
};


void  (vector movin,float dir)new_movedir =  {
   self.movedir = movin;
   if ( (dir < 0.00000) ) {

      self.movedir = (self.movedir * -1.00000);

   }
   self.pos1 = self.angles;
   self.pos2 = (self.angles + (self.movedir * self.dflags));
};


void  ()door_go_up =  {
   if ( (self.state == STATE_UP) ) {

      return ;

   }
   if ( (self.state == STATE_TOP) ) {

      self.nextthink = (self.ltime + self.wait);
      return ;

   }
   sound ( self, CHAN_VOICE, self.noise2, 1.00000, ATTN_NORM);
   self.state = STATE_UP;
   if ( (self.classname == "door") ) {

      if ( (self.spawnflags & DOOR_NORMAL) ) {

         if ( (self.v_angle != '0.00000 0.00000 0.00000') ) {

            if ( self.speed ) {

               if ( self.anglespeed ) {

                  SUB_CalcMoveAndAngleInit ( self.pos2, self.speed, self.v_angle, self.anglespeed, door_hit_top, FALSE);
               } else {

                  SUB_CalcMoveAndAngleInit ( self.pos2, self.speed, self.v_angle, self.anglespeed, door_hit_top, TRUE);

               }
            } else {

               SUB_CalcAngleMove ( self.v_angle, self.anglespeed, door_hit_top);

            }
         } else {

            SUB_CalcMove ( self.pos2, self.speed, door_hit_top);

         }
      } else {

         door_slide ( self.pos2);

      }
   } else {

      if ( (self.classname == "door_rotating") ) {

         SUB_CalcAngleMove ( self.pos2, self.speed, door_hit_top);

      }

   }
   SUB_UseTargets ( );
};


void  ()door_fire =  {
local entity oself;
local entity starte;
   if ( (self.owner != self) ) {

      objerror ( "door_fire: self.owner != self");

   }
   self.no_puzzle_msg = 0.00000;
   self.message = 0.00000;
   oself = self;
   if ( (self.spawnflags & DOOR_TOGGLE) ) {

      if ( ((self.state == STATE_UP) || (self.state == STATE_TOP)) ) {

         starte = self;
         do {

            door_go_down ( );
            self = self.enemy;
         } while ( ((self != starte) && (self != world)) );
         self = oself;
         return ;

      }

   }
   starte = self;
   do {

      door_go_up ( );
      self = self.enemy;
   } while ( ((self != starte) && (self != world)) );
   self = oself;
};


void  ()door_use =  {
local entity oself;
   self.message = 0.00000;
   self.owner.message = 0.00000;
   self.enemy.message = 0.00000;
   oself = self;
   self = self.owner;
   door_fire ( );
   self = oself;
};

float  (entity client,float remove_pieces,float inverse)check_puzzle_pieces;

void  ()door_trigger_touch =  {
local entity door;
local string temp;
local float removepp = 0.00000;
local float inversepp = 0.00000;
   if ( (!(other.flags & FL_CLIENT) && !(other.flags & FL_MONSTER)) ) {

      return ;

   }
   if ( (time < self.attack_finished) ) {

      return ;

   }
   door = self;
   self = self.owner;
   if ( !deathmatch ) {

      removepp = (self.spawnflags & DOOR_REMOVE_PP);
      inversepp = (self.spawnflags & DOOR_NO_PP);
      if ( !check_puzzle_pieces ( other, removepp, inversepp) ) {

         if ( (self.no_puzzle_msg && !deathmatch) ) {

            temp = getstring ( self.no_puzzle_msg);
            centerprint ( other, temp);
            door.attack_finished = (time + 2.00000);

         }
         return ;

      }

   }
   self.attack_finished = (time + 1.00000);
   activator = other;
   door_use ( );
};


void  ()door_killed =  {
local entity oself;
   oself = self;
   self = self.owner;
   self.health = self.max_health;
   self.takedamage = DAMAGE_NO;
   door_use ( );
   self = oself;
};


void  ()door_touch =  {
local string temp;
local float removepp = 0.00000;
local float inversepp = 0.00000;
   if ( (!(other.flags & FL_CLIENT) && !(other.flags & FL_MONSTER)) ) {

      return ;

   }
   if ( ((self.dmg == 666.00000) && ((self.velocity != '0.00000 0.00000 0.00000') || (self.avelocity != '0.00000 0.00000 0.00000'))) ) {

      if ( ((other.classname == "player") && (other.flags2 & FL_ALIVE)) ) {

         other.decap = TRUE;
         T_Damage ( other, self, self, (other.health + 300.00000));
      } else {

         T_Damage ( other, self, self, (other.health + 50.00000));

      }

   }
   if ( (self.owner.attack_finished > time) ) {

      return ;

   }
   self.owner.attack_finished = (time + 2.00000);
   if ( ((self.owner.message != 0.00000) && !deathmatch) ) {

      temp = getstring ( self.owner.message);
      centerprint ( other, temp);
      sound ( other, CHAN_VOICE, "misc/comm.wav", 1.00000, ATTN_NORM);

   }
   if ( (((!self.puzzle_piece_1 && !self.puzzle_piece_2) && !self.puzzle_piece_3) && !self.puzzle_piece_4) ) {

      return ;

   }
   removepp = (self.spawnflags & DOOR_REMOVE_PP);
   inversepp = (self.spawnflags & DOOR_NO_PP);
   if ( !check_puzzle_pieces ( other, removepp, inversepp) ) {

      if ( (self.no_puzzle_msg && !deathmatch) ) {

         temp = getstring ( self.no_puzzle_msg);
         centerprint ( other, temp);

      }
      return ;

   }
   self.touch = SUB_Null;
   if ( self.enemy ) {

      self.enemy.touch = SUB_Null;

   }
   door_use ( );
};


entity  (vector fmins,vector fmaxs,entity door)spawn_field =  {
local entity trigger;
local vector t1 = '0.00000 0.00000 0.00000';
local vector t2 = '0.00000 0.00000 0.00000';
   trigger = spawn ( );
   trigger.movetype = MOVETYPE_NONE;
   trigger.solid = SOLID_TRIGGER;
   trigger.owner = door;
   trigger.touch = door_trigger_touch;
   t1 = fmins;
   t2 = fmaxs;
   t1 += door.origin;
   t2 += door.origin;
   setsize ( trigger, (t1 - '60.00000 60.00000 8.00000'), (t2 + '60.00000 60.00000 8.00000'));
   return ( trigger );
};


float  (entity e1,entity e2)EntitiesTouching =  {
local vector e1max = '0.00000 0.00000 0.00000';
local vector e1min = '0.00000 0.00000 0.00000';
local vector e2max = '0.00000 0.00000 0.00000';
local vector e2min = '0.00000 0.00000 0.00000';
   if ( ((e1.classname == "door_rotating") || ((e1.classname == "door") && (e1.v_angle != '0.00000 0.00000 0.00000'))) ) {

      e1max = (e1.maxs + e1.origin);
      e1min = (e1.mins + e1.origin);
      e2max = (e2.maxs + e2.origin);
      e2min = (e2.mins + e2.origin);
   } else {

      e1max = e1.maxs;
      e1min = e1.mins;
      e2max = e2.maxs;
      e2min = e2.mins;

   }
   if ( (e1min_x > e2max_x) ) {

      return ( FALSE );

   }
   if ( (e1min_y > e2max_y) ) {

      return ( FALSE );

   }
   if ( (e1min_z > e2max_z) ) {

      return ( FALSE );

   }
   if ( (e1max_x < e2min_x) ) {

      return ( FALSE );

   }
   if ( (e1max_y < e2min_y) ) {

      return ( FALSE );

   }
   if ( (e1max_z < e2min_z) ) {

      return ( FALSE );

   }
   return ( TRUE );
};


void  ()LinkDoors =  {
local entity t;
local entity starte;
local vector cmins = '0.00000 0.00000 0.00000';
local vector cmaxs = '0.00000 0.00000 0.00000';
   if ( self.enemy ) {

      return ;

   }
   if ( (self.spawnflags & 4.00000) ) {

      self.enemy = self;
      self.owner = self;
      return ;

   }
   cmins = self.mins;
   cmaxs = self.maxs;
   starte = self;
   t = self;
   do {

      self.owner = starte;
      if ( (!self.thingtype && self.health) ) {

         starte.health = self.health;

      }
      if ( self.targetname ) {

         starte.targetname = self.targetname;

      }
      if ( (self.message != 0.00000) ) {

         starte.message = self.message;

      }
      t = find ( t, classname, self.classname);
      if ( !t ) {

         self.enemy = starte;
         self = self.owner;
         if ( (!self.thingtype && self.health) ) {

            return ;

         }
         if ( self.targetname ) {

            return ;

         }
         if ( ((((self.puzzle_piece_1 != string_null) || (self.puzzle_piece_2 != string_null)) || (self.puzzle_piece_3 != string_null)) || (self.puzzle_piece_4 != string_null)) ) {

            return ;

         }
         self.owner.trigger_field = spawn_field ( cmins, cmaxs, self.owner);
         return ;

      }
      if ( EntitiesTouching ( self, t) ) {

         if ( t.enemy ) {

            objerror ( "cross connected doors");

         }
         self.enemy = t;
         self = t;
         if ( (t.mins_x < cmins_x) ) {

            cmins_x = t.mins_x;

         }
         if ( (t.mins_y < cmins_y) ) {

            cmins_y = t.mins_y;

         }
         if ( (t.mins_z < cmins_z) ) {

            cmins_z = t.mins_z;

         }
         if ( (t.maxs_x > cmaxs_x) ) {

            cmaxs_x = t.maxs_x;

         }
         if ( (t.maxs_y > cmaxs_y) ) {

            cmaxs_y = t.maxs_y;

         }
         if ( (t.maxs_z > cmaxs_z) ) {

            cmaxs_z = t.maxs_z;

         }

      }
   } while ( 1.00000 );
};


void  ()door_sounds =  {
   self.noise3 = "doors/baddoor.wav";
   if ( (self.soundtype == 0.00000) ) {

      precache_sound ( "misc/null.wav");
      precache_sound ( "misc/null.wav");
      self.noise1 = "misc/null.wav";
      self.noise2 = "misc/null.wav";
      self.noise4 = "misc/null.wav";
   } else {

      if ( (self.soundtype == 1.00000) ) {

         precache_sound ( "doors/gatestop.wav");
         precache_sound ( "doors/gateswng.wav");
         precache_sound ( "doors/gatestrt.wav");
         self.noise1 = "doors/gatestop.wav";
         self.noise2 = "doors/gateswng.wav";
         self.noise4 = "doors/gatestrt.wav";
      } else {

         if ( (self.soundtype == 2.00000) ) {

            precache_sound ( "doors/doorstop.wav");
            precache_sound ( "doors/stonslid.wav");
            precache_sound ( "doors/dorstart.wav");
            self.noise1 = "doors/doorstop.wav";
            self.noise2 = "doors/stonslid.wav";
            self.noise4 = "doors/dorstart.wav";
         } else {

            if ( (self.soundtype == 3.00000) ) {

               precache_sound ( "doors/swngstop.wav");
               precache_sound ( "doors/wdswngbg.wav");
               precache_sound ( "doors/dorstart.wav");
               self.noise1 = "doors/swngstop.wav";
               self.noise2 = "doors/wdswngbg.wav";
               self.noise4 = "doors/dorstart.wav";
            } else {

               if ( (self.soundtype == 4.00000) ) {

                  precache_sound ( "doors/swngstop.wav");
                  precache_sound ( "doors/wdswngsm.wav");
                  precache_sound ( "doors/dorstart.wav");
                  self.noise1 = "doors/swngstop.wav";
                  self.noise2 = "doors/wdswngsm.wav";
                  self.noise4 = "doors/dorstart.wav";
               } else {

                  if ( (self.soundtype == 5.00000) ) {

                     precache_sound ( "doors/swngstop.wav");
                     precache_sound ( "doors/woodslid.wav");
                     precache_sound ( "doors/dorstart.wav");
                     self.noise1 = "doors/swngstop.wav";
                     self.noise2 = "doors/woodslid.wav";
                     self.noise4 = "doors/dorstart.wav";
                  } else {

                     if ( (self.soundtype == 6.00000) ) {

                        precache_sound ( "doors/doorstop.wav");
                        precache_sound ( "doors/drawmove.wav");
                        precache_sound ( "doors/drawstrt.wav");
                        self.noise1 = "doors/doorstop.wav";
                        self.noise2 = "doors/drawmove.wav";
                        self.noise4 = "doors/dorstart.wav";
                     } else {

                        if ( (self.soundtype == 7.00000) ) {

                           precache_sound ( "doors/doorstop.wav");
                           precache_sound ( "doors/stonslid.wav");
                           precache_sound ( "doors/dorstart.wav");
                           self.noise1 = "doors/doorstop.wav";
                           self.noise2 = "doors/stonslid.wav";
                           self.noise4 = "doors/dorstart.wav";
                        } else {

                           if ( (self.soundtype == 8.00000) ) {

                              precache_sound ( "doors/mtlstop.wav");
                              precache_sound ( "doors/mtlslide.wav");
                              precache_sound ( "doors/mtlstart.wav");
                              self.noise1 = "doors/mtlstop.wav";
                              self.noise2 = "doors/mtlslide.wav";
                              self.noise4 = "doors/mtlstart.wav";
                           } else {

                              if ( (self.soundtype == 9.00000) ) {

                                 precache_sound2 ( "doors/penstop.wav");
                                 precache_sound2 ( "doors/penswing.wav");
                                 precache_sound2 ( "doors/penstart.wav");
                                 self.noise1 = "doors/penstop.wav";
                                 self.noise2 = "doors/penswing.wav";
                                 self.noise4 = "doors/penstart.wav";

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


void  ()door_rotate_incr_done =  {
};


void  ()door_rotate_incr =  {
local vector newvect = '0.00000 0.00000 0.00000';
   if ( (self.strength == 2.00000) ) {

      cvar_set ( "sv_gravity", "100");

   }
   self.dflags = self.flags;
   self.flags = 0.00000;
   if ( (self.v_angle != '0.00000 0.00000 0.00000') ) {

      if ( ((random() > 0.50000) && (self.v_angle_x != 0.00000)) ) {

         self.dflags = self.v_angle_x;
         self.cnt = self.v_angle_x;
         new_movedir ( '1.00000 0.00000 0.00000', self.cnt);
      } else {

         if ( ((random() > 0.50000) && (self.v_angle_y != 0.00000)) ) {

            self.dflags = self.v_angle_y;
            self.cnt = self.v_angle_y;
            new_movedir ( '0.00000 1.00000 0.00000', self.cnt);
         } else {

            if ( (self.v_angle_z != 0.00000) ) {

               self.dflags = self.v_angle_z;
               self.cnt = self.v_angle_z;
               new_movedir ( '0.00000 0.00000 1.00000', self.cnt);

            }

         }

      }

   }
   newvect = (self.movedir * self.cnt);
   SUB_CalcAngleMove ( (self.angles + newvect), self.speed, door_rotate_incr_done);
};


void  ()func_door =  {
   door_sounds ( );
   SetMovedir ( );
   if ( (self.spawnflags & REVERSE) ) {

      self.movedir = (self.movedir * -1.00000);
      self.v_angle = (self.v_angle * -1.00000);

   }
   self.max_health = self.health;
   self.solid = SOLID_BSP;
   self.movetype = MOVETYPE_PUSH;
   setorigin ( self, self.origin);
   setmodel ( self, self.model);
   self.classname = "door";
   self.blocked = door_blocked;
   self.use = door_use;
   if ( self.abslight ) {

      self.drawflags = (self.drawflags | MLS_ABSLIGHT);

   }
   if ( (self.speed == -1.00000) ) {

      self.speed = 0.00000;
   } else {

      if ( !self.speed ) {

         self.speed = 100.00000;

      }

   }
   if ( !self.wait ) {

      self.wait = 3.00000;

   }
   if ( !self.lip ) {

      self.lip = 8.00000;

   }
   if ( !self.dmg ) {

      self.dmg = 2.00000;

   }
   self.pos1 = self.origin;
   if ( self.level ) {

      self.pos2 = (self.pos1 + (self.movedir * (self.level - self.lip)));
   } else {

      self.pos2 = (self.pos1 + (self.movedir * (fabs ( (self.movedir * self.size)) - self.lip)));

   }
   if ( (self.v_angle != '0.00000 0.00000 0.00000') ) {

      self.o_angle = self.angles;
      self.v_angle += self.angles;

   }
   if ( (self.wait == -2.00000) ) {

      self.th_die = chunk_death;
      if ( !self.health ) {

         if ( ((self.thingtype == THINGTYPE_GLASS) || (self.thingtype == THINGTYPE_CLEARGLASS)) ) {

            self.health = 25.00000;
            self.max_health = 25.00000;
         } else {

            if ( ((self.thingtype == THINGTYPE_GREYSTONE) || (self.thingtype == THINGTYPE_BROWNSTONE)) ) {

               self.health = 75.00000;
               self.max_health = 75.00000;
            } else {

               if ( (self.thingtype == THINGTYPE_WOOD) ) {

                  self.health = 50.00000;
                  self.max_health = 50.00000;
               } else {

                  if ( (self.thingtype == THINGTYPE_METAL) ) {

                     self.health = 100.00000;
                     self.max_health = 100.00000;
                  } else {

                     if ( (self.thingtype == THINGTYPE_FLESH) ) {

                        self.health = 30.00000;
                        self.max_health = 30.00000;
                     } else {

                        self.health = 25.00000;
                        self.max_health = 25.00000;

                     }

                  }

               }

            }

         }

      }

   }
   if ( (self.spawnflags & DOOR_START_OPEN) ) {

      if ( (self.v_angle != '0.00000 0.00000 0.00000') ) {

         self.angles = self.v_angle;
         self.v_angle = self.o_angle;
         self.o_angle = self.angles;

      }
      setorigin ( self, self.pos2);
      self.pos2 = self.pos1;
      self.pos1 = self.origin;

   }
   self.state = STATE_BOTTOM;
   if ( self.health ) {

      self.takedamage = DAMAGE_YES;
      self.th_pain = door_killed;
      self.th_die = door_killed;

   }
   if ( ((((self.puzzle_piece_1 != string_null) || (self.puzzle_piece_2 != string_null)) || (self.puzzle_piece_3 != string_null)) || (self.puzzle_piece_4 != string_null)) ) {

      self.wait = -1.00000;

   }
   self.touch = door_touch;
   self.think = LinkDoors;
   self.nextthink = (self.ltime + 0.10000);
   if ( self.cnt ) {

      self.touch = SUB_Null;
      self.use = door_rotate_incr;

   }
};

void  ()fd_secret_move1;
void  ()fd_secret_move2;
void  ()fd_secret_move3;
void  ()fd_secret_move4;
void  ()fd_secret_move5;
void  ()fd_secret_move6;
void  ()fd_secret_done;
float SECRET_OPEN_ONCE   =  1.00000;
float SECRET_1ST_LEFT   =  2.00000;
float SECRET_1ST_DOWN   =  4.00000;
float SECRET_NO_SHOOT   =  8.00000;
float SECRET_YES_SHOOT   =  16.00000;

void  ()fd_secret_use =  {
local float temp = 0.00000;
   self.health = 10000.00000;
   if ( (self.origin != self.oldorigin) ) {

      return ;

   }
   self.message = 0.00000;
   SUB_UseTargets ( );
   if ( !(self.spawnflags & SECRET_NO_SHOOT) ) {

      self.th_pain = SUB_Null;
      self.takedamage = DAMAGE_NO;

   }
   self.velocity = '0.00000 0.00000 0.00000';
   sound ( self, CHAN_VOICE, self.noise1, 1.00000, ATTN_NORM);
   self.nextthink = (self.ltime + 0.10000);
   temp = (1.00000 - (self.spawnflags & SECRET_1ST_LEFT));
   makevectors ( self.mangle);
   if ( !self.t_width ) {

      if ( (self.spawnflags & SECRET_1ST_DOWN) ) {

         self.t_width = fabs ( (v_up * self.size));
      } else {

         self.t_width = fabs ( (v_right * self.size));

      }

   }
   if ( !self.t_length ) {

      self.t_length = fabs ( (v_forward * self.size));

   }
   if ( (self.spawnflags & SECRET_1ST_DOWN) ) {

      self.dest1 = (self.origin - (v_up * self.t_width));
   } else {

      self.dest1 = (self.origin + (v_right * (self.t_width * temp)));

   }
   self.dest2 = (self.dest1 + (v_forward * self.t_length));
   SUB_CalcMove ( self.dest1, self.speed, fd_secret_move1);
   sound ( self, CHAN_VOICE, self.noise2, 1.00000, ATTN_NORM);
};


void  ()fd_secret_move1 =  {
   self.nextthink = (self.ltime + 1.00000);
   self.think = fd_secret_move2;
   sound ( self, CHAN_VOICE, self.noise3, 1.00000, ATTN_NORM);
};


void  ()fd_secret_move2 =  {
   sound ( self, CHAN_VOICE, self.noise2, 1.00000, ATTN_NORM);
   SUB_CalcMove ( self.dest2, self.speed, fd_secret_move3);
};


void  ()fd_secret_move3 =  {
   sound ( self, CHAN_VOICE, self.noise3, 1.00000, ATTN_NORM);
   if ( !(self.spawnflags & SECRET_OPEN_ONCE) ) {

      self.nextthink = (self.ltime + self.wait);
      self.think = fd_secret_move4;

   }
};


void  ()fd_secret_move4 =  {
   sound ( self, CHAN_VOICE, self.noise2, 1.00000, ATTN_NORM);
   SUB_CalcMove ( self.dest1, self.speed, fd_secret_move5);
};


void  ()fd_secret_move5 =  {
   self.nextthink = (self.ltime + 1.00000);
   self.think = fd_secret_move6;
   sound ( self, CHAN_VOICE, self.noise3, 1.00000, ATTN_NORM);
};


void  ()fd_secret_move6 =  {
   sound ( self, CHAN_VOICE, self.noise2, 1.00000, ATTN_NORM);
   SUB_CalcMove ( self.oldorigin, self.speed, fd_secret_done);
};


void  ()fd_secret_done =  {
   if ( (!self.targetname || (self.spawnflags & SECRET_YES_SHOOT)) ) {

      self.health = 10000.00000;
      self.takedamage = DAMAGE_YES;
      self.th_pain = fd_secret_use;

   }
   sound ( self, CHAN_VOICE, self.noise3, 1.00000, ATTN_NORM);
};


void  ()secret_blocked =  {
   if ( (time < self.attack_finished) ) {

      return ;

   }
   self.attack_finished = (time + 0.50000);
   T_Damage ( other, self, self, self.dmg);
};


void  ()secret_touch =  {
local string s;
   if ( (other.classname != "player") ) {

      return ;

   }
   if ( (self.attack_finished > time) ) {

      return ;

   }
   self.attack_finished = (time + 2.00000);
   if ( self.message ) {

      s = getstring ( self.message);
      centerprint ( other, s);
      sound ( other, CHAN_BODY, "misc/comm.wav", 1.00000, ATTN_NORM);

   }
};


void  ()func_door_secret =  {
   door_sounds ( );
   if ( !self.dmg ) {

      self.dmg = 2.00000;

   }
   self.mangle = self.angles;
   self.angles = '0.00000 0.00000 0.00000';
   self.solid = SOLID_BSP;
   self.movetype = MOVETYPE_PUSH;
   self.classname = "door";
   setmodel ( self, self.model);
   setorigin ( self, self.origin);
   self.touch = secret_touch;
   self.blocked = secret_blocked;
   self.speed = 50.00000;
   self.use = fd_secret_use;
   if ( (!self.targetname || (self.spawnflags & SECRET_YES_SHOOT)) ) {

      self.health = 10000.00000;
      self.takedamage = DAMAGE_YES;
      self.th_pain = fd_secret_use;
      self.th_die = fd_secret_use;

   }
   self.oldorigin = self.origin;
   if ( !self.wait ) {

      self.wait = 5.00000;

   }
};


void  ()func_door_rotating =  {
local vector vec = '0.00000 0.00000 0.00000';
   self.dflags = self.flags;
   self.flags = 0.00000;
   if ( (self.spawnflags & 64.00000) ) {

      self.movedir = '0.00000 0.00000 1.00000';
   } else {

      if ( (self.spawnflags & 128.00000) ) {

         self.movedir = '1.00000 0.00000 0.00000';
      } else {

         self.movedir = '0.00000 1.00000 0.00000';

      }

   }
   if ( (self.spawnflags & 2.00000) ) {

      self.movedir = (self.movedir * -1.00000);

   }
   self.spawnflags ^= 192.00000;
   if ( (self.spawnflags & 8.00000) ) {

      self.spawnflags |= DOOR_REMOVE_PP;

   }
   if ( (self.spawnflags & 16.00000) ) {

      self.spawnflags |= DOOR_NO_PP;

   }
   if ( (self.spawnflags & 32.00000) ) {

      self.spawnflags |= DOOR_TOGGLE;

   }
   self.pos1 = self.angles;
   self.pos2 = (self.angles + (self.movedir * self.dflags));
   self.max_health = self.health;
   self.solid = SOLID_BSP;
   self.movetype = MOVETYPE_PUSH;
   setorigin ( self, self.origin);
   setmodel ( self, self.model);
   self.classname = "door_rotating";
   if ( self.abslight ) {

      self.drawflags |= MLS_ABSLIGHT;

   }
   if ( !self.speed ) {

      self.speed = 100.00000;

   }
   if ( (self.wait == 0.00000) ) {

      self.wait = 3.00000;

   }
   if ( !self.dmg ) {

      self.dmg = 2.00000;

   }
   if ( (self.wait == -2.00000) ) {

      self.th_die = chunk_death;
      if ( !self.health ) {

         if ( ((self.thingtype == THINGTYPE_GLASS) || (self.thingtype == THINGTYPE_CLEARGLASS)) ) {

            self.health = 25.00000;
            self.max_health = 25.00000;
         } else {

            if ( ((self.thingtype == THINGTYPE_GREYSTONE) || (self.thingtype == THINGTYPE_BROWNSTONE)) ) {

               self.health = 75.00000;
               self.max_health = 75.00000;
            } else {

               if ( (self.thingtype == THINGTYPE_WOOD) ) {

                  self.health = 50.00000;
                  self.max_health = 50.00000;
               } else {

                  if ( (self.thingtype == THINGTYPE_METAL) ) {

                     self.health = 100.00000;
                     self.max_health = 100.00000;
                  } else {

                     if ( (self.thingtype == THINGTYPE_FLESH) ) {

                        self.health = 30.00000;
                        self.max_health = 30.00000;
                     } else {

                        self.health = 25.00000;
                        self.max_health = 25.00000;

                     }

                  }

               }

            }

         }

      }

   }
   door_sounds ( );
   if ( (self.spawnflags & DOOR_START_OPEN) ) {

      self.angles = self.pos2;
      vec = self.pos2;
      self.pos2 = self.pos1;
      self.pos1 = vec;
      self.movedir = (self.movedir * -1.00000);

   }
   self.state = STATE_BOTTOM;
   self.touch = door_touch;
   self.blocked = door_blocked;
   self.use = door_use;
   if ( ((((self.puzzle_piece_1 != string_null) || (self.puzzle_piece_2 != string_null)) || (self.puzzle_piece_3 != string_null)) || (self.puzzle_piece_4 != string_null)) ) {

      self.wait = -1.00000;

   }
   self.think = LinkDoors;
   self.nextthink = (self.ltime + 0.10000);
   if ( self.cnt ) {

      self.touch = SUB_Null;
      self.use = door_rotate_incr;

   }
   if ( self.flags2 ) {

      self.touch = door_damage;
      self.flags2 = FALSE;

   }
};



void  ()Pal_Change_Weapon =  {
   if ( (self.weapon == IT_WEAPON1) ) {

      self.th_missile = pal_gauntlet_fire;
   } else {

      if ( (self.weapon == IT_WEAPON4) ) {

         self.th_missile = pal_purifier_fire;
      } else {

         if ( (self.weapon == IT_WEAPON2) ) {

            self.th_missile = pal_vorpal_fire;
         } else {

            self.th_missile = pal_axe_fire;

         }

      }

   }
};


void  ()Cru_Change_Weapon =  {
   if ( (self.weapon == IT_WEAPON1) ) {

      self.th_missile = Cru_Wham_Fire;
   } else {

      if ( (self.weapon == IT_WEAPON2) ) {

         self.th_missile = Cru_Ice_Fire;
      } else {

         if ( (self.weapon == IT_WEAPON3) ) {

            self.th_missile = Cru_Met_Attack;
         } else {

            self.th_missile = Cru_Sun_Fire;

         }

      }

   }
};


void  ()Nec_Change_Weapon =  {
   if ( (self.weapon == IT_WEAPON1) ) {

      self.th_missile = sickle_decide_attack;
   } else {

      if ( (self.weapon == IT_WEAPON4) ) {

         self.th_missile = setstaff_decide_attack;
      } else {

         if ( (self.weapon == IT_WEAPON2) ) {

            self.th_missile = Nec_Mis_Attack;
         } else {

            self.th_missile = Nec_Bon_Attack;

         }

      }

   }
};


void  ()Ass_Change_Weapon =  {
   if ( (self.weapon == IT_WEAPON4) ) {

      self.th_missile = ass_setstaff_fire;
   } else {

      if ( (self.weapon == IT_WEAPON2) ) {

         self.th_missile = crossbow_fire;

      }

   }
   if ( (self.weapon == IT_WEAPON3) ) {

      self.th_missile = grenade_throw;
   } else {

      self.th_missile = Ass_Pdgr_Fire;

   }
};

float player_start_frames [160]   = { 209.00000,
    235.00000,    235.00000,    222.00000,    101.00000,
    165.00000,    231.00000,    231.00000,    162.00000,
    103.00000,    103.00000,    217.00000,    201.00000,
    227.00000,    201.00000,    214.00000,    173.00000,
    197.00000,    197.00000,    185.00000,    114.00000,
    149.00000,    214.00000,    214.00000,    150.00000,
    91.00000,    91.00000,    205.00000,    165.00000,
    189.00000,    165.00000,    177.00000,    95.00000,
    125.00000,    125.00000,    110.00000,    68.00000,
    126.00000,    191.00000,    191.00000,    127.00000,
    68.00000,    68.00000,    182.00000,    87.00000,
    117.00000,    87.00000,    102.00000,    0.00000,
    15.00000,    15.00000,    11.00000,    83.00000,
    161.00000,    226.00000,    226.00000,    115.00000,
    60.00000,    60.00000,    174.00000,    0.00000,
    15.00000,    0.00000,    11.00000,    152.00000,
    166.00000,    166.00000,    159.00000,    93.00000,
    141.00000,    206.00000,    206.00000,    142.00000,
    83.00000,    83.00000,    197.00000,    144.00000,
    158.00000,    144.00000,    151.00000,    140.00000,
    0.00000,    0.00000,    0.00000,    178.00000,
    0.00000,    0.00000,    0.00000,    150.00000,
    91.00000,    91.00000,    205.00000,    132.00000,
    0.00000,    0.00000,    0.00000,    27.00000,
    0.00000,    0.00000,    0.00000,    0.00000,
    0.00000,    0.00000,    0.00000,    0.00000,
    0.00000,    0.00000,    0.00000,    19.00000,
    0.00000,    0.00000,    0.00000,    27.00000,
    0.00000,    0.00000,    0.00000,    0.00000,
    0.00000,    0.00000,    0.00000,    0.00000,
    0.00000,    0.00000,    0.00000,    19.00000,
    0.00000,    0.00000,    0.00000,    47.00000,
    0.00000,    0.00000,    0.00000,    48.00000,
    0.00000,    0.00000,    0.00000,    20.00000,
    0.00000,    0.00000,    0.00000,    39.00000,
    0.00000,    0.00000,    0.00000,    67.00000,
    0.00000,    0.00000,    0.00000,    20.00000,
    0.00000,    0.00000,    0.00000,    40.00000,
    0.00000,    0.00000,    0.00000,    59.00000,
    0.00000,    0.00000,    0.00000};
float player_end_frames [160]   = { 221.00000,
    247.00000,    247.00000,    234.00000,    113.00000,
    177.00000,    243.00000,    243.00000,    173.00000,
    114.00000,    114.00000,    228.00000,    213.00000,
    239.00000,    213.00000,    226.00000,    184.00000,
    208.00000,    208.00000,    196.00000,    125.00000,
    160.00000,    225.00000,    225.00000,    161.00000,
    102.00000,    102.00000,    216.00000,    176.00000,
    200.00000,    176.00000,    188.00000,    109.00000,
    139.00000,    139.00000,    124.00000,    82.00000,
    140.00000,    204.00000,    204.00000,    140.00000,
    81.00000,    81.00000,    195.00000,    101.00000,
    131.00000,    101.00000,    116.00000,    10.00000,
    26.00000,    26.00000,    14.00000,    92.00000,
    164.00000,    230.00000,    230.00000,    126.00000,
    67.00000,    67.00000,    181.00000,    10.00000,
    18.00000,    10.00000,    14.00000,    158.00000,
    172.00000,    172.00000,    165.00000,    100.00000,
    148.00000,    213.00000,    213.00000,    149.00000,
    90.00000,    90.00000,    204.00000,    150.00000,
    164.00000,    150.00000,    157.00000,    151.00000,
    0.00000,    0.00000,    0.00000,    190.00000,
    0.00000,    0.00000,    0.00000,    161.00000,
    102.00000,    102.00000,    216.00000,    143.00000,
    0.00000,    0.00000,    0.00000,    46.00000,
    0.00000,    0.00000,    0.00000,    19.00000,
    0.00000,    0.00000,    0.00000,    19.00000,
    0.00000,    0.00000,    0.00000,    38.00000,
    0.00000,    0.00000,    0.00000,    46.00000,
    0.00000,    0.00000,    0.00000,    19.00000,
    0.00000,    0.00000,    0.00000,    19.00000,
    0.00000,    0.00000,    0.00000,    38.00000,
    0.00000,    0.00000,    0.00000,    66.00000,
    0.00000,    0.00000,    0.00000,    67.00000,
    0.00000,    0.00000,    0.00000,    39.00000,
    0.00000,    0.00000,    0.00000,    58.00000,
    0.00000,    0.00000,    0.00000,    94.00000,
    0.00000,    0.00000,    0.00000,    47.00000,
    0.00000,    0.00000,    0.00000,    59.00000,
    0.00000,    0.00000,    0.00000,    86.00000,
    0.00000,    0.00000,    0.00000};

void  ()player_frames =  {
local float weapmod = 0.00000;
local float startframe = 0.00000;
local float endframe = 0.00000;
local float framestate = 0.00000;
   if ( self.deadflag ) {

      self.act_state = ACT_DEAD;

   }
   if ( ((self.act_state < ACT_JUMP) || ((self.playerclass == CLASS_NECROMANCER) && (self.act_state <= ACT_JUMP))) ) {

      if ( (self.weapon == IT_WEAPON4) ) {

         weapmod = 3.00000;

      }
      if ( (self.weapon == IT_WEAPON3) ) {

         weapmod = 2.00000;

      }
      if ( (self.weapon == IT_WEAPON2) ) {

         weapmod = 1.00000;

      }
      if ( (self.weapon == IT_WEAPON1) ) {

         weapmod = 0.00000;

      }
   } else {

      weapmod = 0.00000;

   }
   startframe = (player_start_frames->((((self.playerclass - 1.00000) * 4.00000) + (self.act_state * 16.00000)) + weapmod));
   if ( ((self.waterlevel < 3.00000) && (self.movetype == MOVETYPE_FLY)) ) {

      endframe = startframe;
   } else {

      endframe = (player_end_frames->((((self.playerclass - 1.00000) * 4.00000) + (self.act_state * 16.00000)) + weapmod));

   }
   if ( (self.act_state != ACT_CROUCH_STAND) ) {

      framestate = AdvanceFrame ( startframe, endframe);

   }
   self.think = player_frames;
   AdvanceThinkTime(self,HX_FRAME_TIME);
   if ( (self.act_state != ACT_DEAD) ) {

      if ( ((self.viewentity == self) || (self.viewentity.classname == "chasecam")) ) {

         self.th_weapon ( );

      }

   }
   if ( (self.act_state == ACT_SWIM_FLY) ) {

      if ( (self.movetype != MOVETYPE_FLY) ) {

         if ( (self.velocity_x || self.velocity_y) ) {

            self.act_state = ACT_RUN;
         } else {

            self.act_state = ACT_STAND;

         }

      }
   } else {

      if ( (self.act_state == ACT_STAND) ) {

         if ( (self.hull == HULL_CROUCH) ) {

            self.act_state = ACT_CROUCH_STAND;
         } else {

            if ( (self.velocity_x || self.velocity_y) ) {

               self.act_state = ACT_RUN;

            }

         }
      } else {

         if ( (self.act_state == ACT_RUN) ) {

            if ( (self.hull == HULL_CROUCH) ) {

               self.act_state = ACT_CROUCH_MOVE;
            } else {

               if ( (!self.velocity_x && !self.velocity_y) ) {

                  self.act_state = ACT_STAND;

               }

            }
         } else {

            if ( (self.act_state == ACT_CROUCH_STAND) ) {

               if ( (self.hull == HULL_PLAYER) ) {

                  self.act_state = ACT_STAND;
               } else {

                  if ( ((self.frame > endframe) || (self.frame < startframe)) ) {

                     self.frame = startframe;
                  } else {

                     if ( (self.velocity_x || self.velocity_y) ) {

                        self.act_state = ACT_CROUCH_MOVE;

                     }

                  }

               }
            } else {

               if ( (self.act_state == ACT_CROUCH_MOVE) ) {

                  if ( (self.hull == HULL_PLAYER) ) {

                     self.act_state = ACT_RUN;
                  } else {

                     if ( (!self.velocity_x && !self.velocity_y) ) {

                        self.act_state = ACT_CROUCH_STAND;

                     }

                  }
               } else {

                  if ( (((self.act_state == ACT_ATTACK) || (self.act_state == ACT_JUMP)) || (self.act_state == ACT_PAIN)) ) {

                     if ( ((framestate == AF_END) && !self.button0) ) {

                        if ( (!self.velocity_x && !self.velocity_y) ) {

                           self.act_state = ACT_STAND;
                        } else {

                           self.act_state = ACT_RUN;

                        }

                     }

                  }

               }

            }

         }

      }

   }
   if ( (self.act_state == ACT_DEAD) ) {

      if ( ((self.frame == startframe) && !deathmatch) ) {

         if ( ((self.enemy.flags2 & FL_ALIVE) && visible ( self.enemy)) ) {

            self.pausetime = (time + 3.00000);

         }

      }
      if ( ((self.view_ofs_z - 2.50000) >= 8.00000) ) {

         self.view_ofs_z -= 2.50000;

      }
      if ( (framestate == AF_END) ) {

         self.view_ofs = '0.00000 0.00000 8.00000';
         self.think = PlayerDead;
         AdvanceThinkTime(self,0.00000);

      }
   } else {

      if ( ((self.waterlevel > 2.00000) || (self.movetype == MOVETYPE_FLY)) ) {

         self.act_state = ACT_SWIM_FLY;

      }

   }
};


void  ()player_frames_behead =  {
   self.level = (player_start_frames->((ACT_DECAP * 16.00000) + ((self.playerclass - 1.00000) * 4.00000)));
   self.dmg = (player_end_frames->((ACT_DECAP * 16.00000) + ((self.playerclass - 1.00000) * 4.00000)));
   self.cnt = 0.00000;
   player_behead ( );
};


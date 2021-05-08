/****************************************************************************/
/*                                                                          */
/*    project    : S.E.A.L. sQuad       (c) 1997 William van der Sterren    */
/*                                                                          */
/*      file     : squad_an.qc  "animation related functions for member"    */
/*      author(s): William van der Sterren                                  */
/*      version  : 0.5                                                      */
/*                                                                          */
/*      date (last revision):  Sep 08, 97                                   */
/*      date (creation)     :  Oct 05, 97                                   */
/*                                                                          */
/*                                                                          */
/*      revision history                                                    */
/*      -- date ---- | -- revision ---------------------- | -- revisor --   */
/*      Oct 05, 1997 | used "pdude" animations            | william         */
/*                                                                          */
/****************************************************************************/
//
// Squad initialization, creation and information
//

// prototypes - local functions



// implementation


// forward declarations
void () Squad_Anim_Pd_WaitStanding1;
void () Squad_Anim_Pd_WaitStanding2;
void () Squad_Anim_Pd_WaitSitting1;
void () Squad_Anim_Pd_Draw1;
void () Squad_Anim_Pd_Draw2;
void () Squad_Anim_Pd_Check1;
void () Squad_Anim_Pd_Check2;
void () Squad_Anim_Pd_ReloadStanding1;
void () Squad_Anim_Pd_ReloadSitting1;
void () Squad_Anim_Pd_Walk4;
void () Squad_Anim_Pd_Walk15;
void () Squad_Anim_Pd_Run4;
void () Squad_Anim_Pd_Run8;
void () Squad_Anim_Pd_Run9;
void () Squad_Anim_Pd_Stuff1;
void () Squad_Anim_Pd_StrafeRight1;
void () Squad_Anim_Pd_StrafeLeft1;
void () Squad_Anim_Pd_DieA1;
void () Squad_Anim_Pd_DieC1;
void () Squad_Anim_Pd_DieD1;
void () Squad_Anim_Pd_DieE1;
void () Squad_Anim_Pd_DieF1;
void () Squad_Anim_Pd_Roll1;
void () Squad_Anim_Pd_Roll5;
void () Squad_Anim_Pd_PainA1;
void () Squad_Anim_Pd_PainB1;
void () Squad_Anim_Pd_PainC1;
void () Squad_Anim_Pd_PainD1;
void () Squad_Anim_Pd_PainE1;
void () Squad_Anim_Pd_AttackMeleeUseKnife1;
void () Squad_Anim_Pd_AttackMeleeApproach1;
void () Squad_Anim_Pd_AttackHandgun;
void () Squad_Anim_Pd_AttackHandgunStandingA1;
void () Squad_Anim_Pd_AttackHandgunStandingB1;
void () Squad_Anim_Pd_AttackHandgunSittingD1;
void () Squad_Anim_Pd_AttackHandGrenade1;

void () Squad_Anim_Gd_WaitStanding1;
void () Squad_Anim_Gd_WaitStanding2;
void () Squad_Anim_Gd_WaitSitting1;
void () Squad_Anim_Gd_Draw1;
void () Squad_Anim_Gd_Draw2;
void () Squad_Anim_Gd_Draw3;
void () Squad_Anim_Gd_Check1;
void () Squad_Anim_Gd_Check2;
void () Squad_Anim_Gd_ReloadStanding1;
void () Squad_Anim_Gd_Walk1;
void () Squad_Anim_Gd_Walk15;
void () Squad_Anim_Gd_Walk24;
void () Squad_Anim_Gd_Run4;
void () Squad_Anim_Gd_Run8;
void () Squad_Anim_Gd_Stuff1;
void () Squad_Anim_Gd_StrafeRight1;
void () Squad_Anim_Gd_StrafeLeft1;
void () Squad_Anim_Gd_DieA1;
void () Squad_Anim_Gd_DieB1;
void () Squad_Anim_Gd_DieC1;
void () Squad_Anim_Gd_DieD1;
void () Squad_Anim_Gd_PainA1;
void () Squad_Anim_Gd_PainB1;
void () Squad_Anim_Gd_PainC1;
void () Squad_Anim_Gd_PainD1;
void () Squad_Anim_Gd_AttackMeleeUseGun1;
void () Squad_Anim_Gd_AttackMeleeApproach1;
void () Squad_Anim_Gd_AttackMachinegun;
void () Squad_Anim_Gd_AttackMachineGunStandingA1;
void () Squad_Anim_Gd_AttackMachineGunStandingB1;
void () Squad_Anim_Gd_AttackMachineGunSittingC1;
void () Squad_Anim_Gd_AttackHandGrenade1;




// frame declarations (copied from pdude.qc)
$cd id1/models/pdude
$origin 0 -6 -24
$base base
$skin skin
$frame reload1 reload2 reload3 reload4 reload5 reload6 reload7 reload8
$frame reload9 reload10
$frame reload11 reload12 reload13 reload14 reload15 reload16 reload17
$frame reload18 reload19
$frame reload20 reload21
$frame drawa1 drawa2 drawa3 drawa4 drawa5 drawa6 drawa7
$frame drawb1 drawb2 drawb3 drawb4 drawb5 drawb6
$frame roll1 roll2 roll3 roll4 roll5 roll6 roll7 roll8 roll9 roll10 roll11
$frame roll12 roll13
$frame roll14 roll15 roll16 roll17 roll18 roll19 roll20 roll21 roll22 roll23
$frame roll24 roll25 roll26 roll27
$frame leap1 leap2 leap3 leap4 leap5 leap6 leap7 leap8 leap9 leap10 leap11
$frame leap12 leap13 leap14
$frame firea1 firea2 firea3
$frame fireb1 fireb2 fireb3
$frame firec1 firec2 firec3 firec4 firec5 firec6 firec7 firec8 firec9 firec10
$frame firec11 firec12 firec13 firec14 firec15 firec16 firec17
$frame fired1 fired2 fired3
$frame paina1 paina2 paina3 paina4 paina5 paina6
$frame painb1 painb2 painb3 painb4 painb5 painb6 painb7 painb8
$frame painc1 painc2 painc3 painc4 painc5 painc6
$frame paind1 paind2 paind3 paind4 paind5 paind6
$frame paine1 paine2 paine3 paine4 paine5 paine6
$frame deatha1 deatha2 deatha3 deatha4 deatha5 deatha6 deatha7 deatha8 deatha9
$frame deatha10 deatha11 deatha12 deatha13 deatha14
$frame deathc1 deathc2 deathc3 deathc4 deathc5 deathc6 deathc7 deathc8 deathc9
$frame deathc10 deathc11 deathc12
$frame deathd1 deathd2 deathd3 deathd4 deathd5 deathd6 deathd7 deathd8 deathd9
$frame deathe1 deathe2 deathe3 deathe4 deathe5 deathe6 deathe7 deathe8 deathe9
$frame deathe10 deathe11 deathe12
$frame deathf1 deathf2 deathf3 deathf4 deathf5 deathf6 deathf7 deathf8 deathf9
$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8
$frame grenade1 grenade2 grenade3 grenade4 grenade5 grenade6 grenade7 grenade8
$frame grenade9 grenade10 grenade11 grenade12 grenade13 grenade14 grenade15
$frame grenade16
$frame run1 run2 run3 run4 run5 run6 run7 run8 run9
$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9 walk10 walk11 walk12
$frame walk13 walk14 walk15 walk16
$frame melee1 melee2 melee3 melee4 melee5 melee6 melee7 melee8 melee9 melee10
$frame melee11 melee12 melee13 melee14 melee15 melee16 melee17 melee18



// Squad_Anim_Wait    - animations to wait, either standing or sitting
//
//
//
void () Squad_Anim_Wait =
{ self.nextthink  = time + 0.1;
  // test for member role
  if (Squad_GetRole(self) == SQUAD_ROLE_HANDGUNSOLDIER)
    { // process posture
      if (Squad_GetPosture(self) == SQUAD_POSTURE_SIT)
        { self.think      = Squad_Anim_Pd_WaitSitting1;
          self.frame      = $reload17;
        }
      else
      // standing
      // if gun drawn, stay this way
      if ((self.frame == $drawa7 ) ||
          (self.frame == $drawb6 )
         )
        { self.think      = Squad_Anim_Pd_WaitStanding2;
        }
      else
        { self.think      = Squad_Anim_Pd_WaitStanding1;
          self.frame      = $stand1;
        }
    }
  else
  // SQUAD_ROLE_MACHINEGUNSOLDIER
    { // process posture
      if (Squad_GetPosture(self) == SQUAD_POSTURE_SIT)
        { self.think      = Squad_Anim_Gd_WaitSitting1;
          self.frame      = 138; // $drawc9;
        }
      else
      // if gun drawn, stay this way
      if ((self.frame == 127 /* $drawb9 */) ||
          (self.frame == 110 /* $drawa7 */)
         )
        { self.think        = Squad_Anim_Gd_WaitStanding2;
        }
      else
        { // sometimes, draw gun
          if (random() < 0.1)
            { self.think      = Squad_Anim_Gd_Draw2;
              self.frame      = 119; // $drawb1;
            }
          else
            { self.think      = Squad_Anim_Gd_WaitStanding1;
              self.frame      = 207; // $stand1;
            }
        }
    }
};


void () Squad_Anim_Pd_WaitStanding1 =
{ self.nextthink  = time + 0.1;

  local float f_frame;
  f_frame = self.frame + 1;
  if (f_frame > $stand8 )
    { // allow for change of posture
      Squad_Anim_Wait();
    }
  else
    self.frame = f_frame;

  // do some thinking
  Squad_EveryFrame();
  Squad_AI_Wait();
};


void () Squad_Anim_Pd_WaitStanding2 =
{ self.nextthink  = time + 0.1;

  // allow for posture change
  Squad_Anim_Wait();

  // do some thinking
  Squad_EveryFrame();
  Squad_AI_Wait();
};


void () Squad_Anim_Pd_WaitSitting1 =
{ self.nextthink  = time + 0.1;

  local float f_frame;
  f_frame = self.frame + 1;
  if (f_frame > $reload17 )
    { // allow for change of posture
      Squad_Anim_Wait();
    }
  else
    self.frame = f_frame;

  // do some thinking
  Squad_EveryFrame();
  Squad_AI_Wait();
};




// Squad_Anim_Draw - animations to draw gun
//
//
//
void () Squad_Anim_Draw =
{ // process posture
  Squad_SetPosture(self, SQUAD_POSTURE_STAND);
  self.nextthink  = time + 0.02;
  if (Squad_GetRole(self) == SQUAD_ROLE_HANDGUNSOLDIER)
    { if (random() > 0.5)
        { self.think      = Squad_Anim_Pd_Draw1;
          self.frame      = $drawa1;
        }
      else
        { self.think      = Squad_Anim_Pd_Draw2;
          self.frame      = $drawb1;
        }
    }
  else
    { local float r;
      r = random();
      if (r > 0.8)
        { self.think      = Squad_Anim_Gd_Draw1;
          self.frame      = 104; // $drawa1;
        }
      else
      if (r > 0.5)
        { self.think      = Squad_Anim_Gd_Draw2;
          self.frame      = 119; // $drawb1;
        }
      else
        { self.think      = Squad_Anim_Gd_Draw3;
          self.frame      = 130; // $drawc1;
        }
    }
};



void () Squad_Anim_Pd_Draw1 =
{ self.nextthink  = time + 0.05;

  local float f_frame;
  f_frame = self.frame + 1;
  if (f_frame > $drawa7 )
    { Squad_AI_DrawFinish();
      return;
    }
  else
    self.frame = f_frame;

  // perform turn to self.ideal_yaw
  ai_face();
  // do some thinking
  Squad_EveryFrame();
};


void () Squad_Anim_Pd_Draw2 =
{ self.nextthink  = time + 0.05;

  local float f_frame;
  f_frame = self.frame + 1;
  if (f_frame > $drawb6 )
    { Squad_AI_DrawFinish();
      return;
    }
  else
    self.frame = f_frame;

  // perform turn to self.ideal_yaw
  ai_face();
  // do some thinking
  Squad_EveryFrame();
};



// Squad_Anim_Check   - animations to draw gun and look around
//
//
//
void () Squad_Anim_Check =
{ self.nextthink  = time + 0.06;
  if (Squad_GetRole(self) == SQUAD_ROLE_HANDGUNSOLDIER)
    { self.think      = Squad_Anim_Pd_Check1;
      self.frame      = $drawa1;
    }
  else
    { self.think      = Squad_Anim_Gd_Check1;
      self.frame      = 119; // $drawb1;
    }
};



void () Squad_Anim_Pd_Check1 =
{ self.nextthink  = time + 0.1;

  local float f_frame;
  f_frame = self.frame + 1;
  if (f_frame > $drawa7 )
    { // check for enemy and immediately attack
      if (Squad_AI_DetectTarget())
        { // skip pre-attack delay
          Squad_SetState(self, SQUAD_MEMBERATTACK);
          return;
        }

      // ... else, time to reverse anim and turn
      Squad_Anim_Pd_Check2();
    }
  else
    self.frame = f_frame;

  // perform turn to self.ideal_yaw
  ChangeYaw();
  // do some thinking
  Squad_EveryFrame();
  // just wait
  Squad_AI_Wait();
};


void () Squad_Anim_Pd_Check2 =
{ self.nextthink  = time + 0.1;

  local float f_frame;
  f_frame     = self.frame - 1;
  if (f_frame >= $drawa1 )
    { // is it time to finish
      Squad_AI_CheckFinish();
      return;
    }
  else
    self.frame = f_frame;

  // perform turn to self.ideal_yaw
  ChangeYaw();
  // do some thinking
  Squad_EveryFrame();
  // just wait
  Squad_AI_Wait();
};



// Squad_Anim_Reload  - animations to reload, either standing or sitting
//
//
//
void () Squad_Anim_Reload =
{ self.nextthink  = time + 0.1;
  if (Squad_GetRole(self) == SQUAD_ROLE_HANDGUNSOLDIER)
    { // process posture
      if (Squad_GetPosture(self) == SQUAD_POSTURE_STAND)
        { self.think      = Squad_Anim_Pd_ReloadStanding1;
          self.frame      = $reload1;
        }
      else
        { self.think      = Squad_Anim_Pd_ReloadSitting1;
          self.frame      = $reload4;
        }
    }
  else
    { // set posture
      Squad_SetPosture(self, SQUAD_POSTURE_STAND);
      self.think      = Squad_Anim_Gd_ReloadStanding1;
      self.frame      = 74; //$reload1;
    }
};



void() Squad_Anim_Pd_ReloadStanding1 =
{ self.nextthink  = time + 0.1;

  local float f_frame;
  f_frame = self.frame + 1;
  if (f_frame > $reload21 )
    { // finished reloading
      Squad_AI_FinishedReload();
    }
  else
    self.frame = f_frame;

  if (f_frame == $reload5 )
   sound(self,CHAN_WEAPON,"weapons/mp5out.wav",1,ATTN_NORM);

  if (f_frame == $reload16 )
    { sound(self,CHAN_WEAPON,"weapons/mp5in.wav",1,ATTN_NORM);
      Squad_AI_PerformReload(self);
    }

  // do some thinking
  Squad_EveryFrame();
  Squad_AI_Wait();
};


void() Squad_Anim_Pd_ReloadSitting1 =
{ self.nextthink  = time + 0.1;

  local float f_frame;
  f_frame = self.frame + 1;
  if (f_frame > $reload17 )
    { // finished reloading
      Squad_AI_FinishedReload();
    }
  else
    self.frame = f_frame;

  if (f_frame == $reload5 )
   sound(self,CHAN_WEAPON, "weapons/mp5out.wav", 1, ATTN_NORM);

  if (f_frame == $reload16 )
    { sound(self, CHAN_WEAPON, "weapons/mp5in.wav", 1, ATTN_NORM);
      Squad_AI_PerformReload(self);
    }

  // do some thinking
  Squad_EveryFrame();
  Squad_AI_Wait();
};


// Squad_Anim_Walk    - animations to walk
//
//
//
void() Squad_Anim_Walk =
{ Squad_SetPosture(self, SQUAD_POSTURE_STAND);

  local float r;
  r = 2 * random();
  if (Squad_GetRole(self) == SQUAD_ROLE_HANDGUNSOLDIER)
    { if (r < 1)
        Squad_Anim_Pd_Walk4();
      else
        Squad_Anim_Pd_Walk15();
    }
  else
    { if (r < 0.6)
        Squad_Anim_Gd_Walk1();
      else
      if (r < 1.3)
        Squad_Anim_Gd_Walk15();
      else
        Squad_Anim_Gd_Walk24();
    }
};

void()  Squad_Anim_Pd_Walk1  =[$walk1 , Squad_Anim_Pd_Walk2  ] {Squad_AI_Walk( 1.1); Squad_EveryFrame();};
void()  Squad_Anim_Pd_Walk2  =[$walk2 , Squad_Anim_Pd_Walk3  ] {Squad_AI_Walk( 2.3); Squad_EveryFrame();};
void()  Squad_Anim_Pd_Walk3  =[$walk3 , Squad_Anim_Pd_Walk4  ] {Squad_AI_Walk( 2.3); Squad_EveryFrame();};
void()  Squad_Anim_Pd_Walk4  =[$walk4 , Squad_Anim_Pd_Walk5  ] {Squad_AI_Walk( 2.3); Squad_EveryFrame();};
void()  Squad_Anim_Pd_Walk5  =[$walk5 , Squad_Anim_Pd_Walk6  ] {Squad_AI_Walk( 3.6); Squad_EveryFrame();};
void()  Squad_Anim_Pd_Walk6  =[$walk6 , Squad_Anim_Pd_Walk7  ] {Squad_AI_Walk( 7.5); Squad_EveryFrame();};
void()  Squad_Anim_Pd_Walk7  =[$walk7 , Squad_Anim_Pd_Walk8  ] {Squad_AI_Walk( 9.5); Squad_EveryFrame();};
void()  Squad_Anim_Pd_Walk8  =[$walk8 , Squad_Anim_Pd_Walk9  ] {Squad_AI_Walk( 8.2); Squad_EveryFrame();};
void()  Squad_Anim_Pd_Walk9  =[$walk9 , Squad_Anim_Pd_Walk10 ] {Squad_AI_Walk( 1.1); Squad_EveryFrame();};
void()  Squad_Anim_Pd_Walk10 =[$walk10, Squad_Anim_Pd_Walk11 ] {Squad_AI_Walk( 1.1); Squad_EveryFrame();};
void()  Squad_Anim_Pd_Walk11 =[$walk11, Squad_Anim_Pd_Walk12 ] {Squad_AI_Walk( 1.1); Squad_EveryFrame();};
void()  Squad_Anim_Pd_Walk12 =[$walk12, Squad_Anim_Pd_Walk13 ] {Squad_AI_Walk( 1.1); Squad_EveryFrame();};
void()  Squad_Anim_Pd_Walk13 =[$walk13, Squad_Anim_Pd_Walk14 ] {Squad_AI_Walk( 2.3); Squad_EveryFrame();};
void()  Squad_Anim_Pd_Walk14 =[$walk14, Squad_Anim_Pd_Walk15 ] {Squad_AI_Walk(12.4); Squad_EveryFrame();};
void()  Squad_Anim_Pd_Walk15 =[$walk15, Squad_Anim_Pd_Walk16 ] {Squad_AI_Walk(11.1); Squad_EveryFrame();};
void()  Squad_Anim_Pd_Walk16 =[$walk16, Squad_Anim_Pd_Walk1  ] {Squad_AI_Walk(10.8); Squad_EveryFrame();};



// Squad_Anim_Run     - animations to run
//
//
//
void() Squad_Anim_Run =
{ Squad_SetPosture(self, SQUAD_POSTURE_STAND);

  local float r;
  r = random();
  if (Squad_GetRole(self) == SQUAD_ROLE_HANDGUNSOLDIER)
    { if (r > 0.7)
        Squad_Anim_Pd_Run4();
      else
      if (r > 0.2)
        Squad_Anim_Pd_Run8();
      else
        Squad_Anim_Pd_Run9();
    }
  else
    { if (r > 0.5)
        Squad_Anim_Gd_Run4();
      else
        Squad_Anim_Gd_Run8();
    }
};

void()  Squad_Anim_Pd_Run1 =[$run1, Squad_Anim_Pd_Run2 ] {Squad_AI_Run( 9.0); Squad_EveryFrame();};
void()  Squad_Anim_Pd_Run2 =[$run2, Squad_Anim_Pd_Run3 ] {Squad_AI_Run(12.0); Squad_EveryFrame();};
void()  Squad_Anim_Pd_Run3 =[$run3, Squad_Anim_Pd_Run4 ] {Squad_AI_Run( 9.0); Squad_EveryFrame();};
void()  Squad_Anim_Pd_Run4 =[$run4, Squad_Anim_Pd_Run5 ] {Squad_AI_Run( 9.0); Squad_EveryFrame();};
void()  Squad_Anim_Pd_Run5 =[$run5, Squad_Anim_Pd_Run6 ] {Squad_AI_Run(12.0); Squad_EveryFrame();};
void()  Squad_Anim_Pd_Run6 =[$run6, Squad_Anim_Pd_Run7 ] {Squad_AI_Run(12.0); Squad_EveryFrame();};
void()  Squad_Anim_Pd_Run7 =[$run7, Squad_Anim_Pd_Run8 ] {Squad_AI_Run( 6.0); Squad_EveryFrame();};
void()  Squad_Anim_Pd_Run8 =[$run8, Squad_Anim_Pd_Run9 ] {Squad_AI_Run( 9.0); Squad_EveryFrame();};
void()  Squad_Anim_Pd_Run9 =[$run9, Squad_Anim_Pd_Run1 ] {Squad_AI_Run( 9.0); Squad_EveryFrame();};



// Squad_Anim_Stuff - animations to run to stuff
//
//
//
void() Squad_Anim_Stuff =
{ Squad_SetPosture(self, SQUAD_POSTURE_STAND);
  if (Squad_GetRole(self) == SQUAD_ROLE_HANDGUNSOLDIER)
    Squad_Anim_Pd_Stuff1();
  else
    Squad_Anim_Gd_Stuff1();
};

void()  Squad_Anim_Pd_Stuff1 =[$run1, Squad_Anim_Pd_Stuff2 ] {Squad_AI_HuntStuff( 9.0); Squad_EveryFrame();};
void()  Squad_Anim_Pd_Stuff2 =[$run2, Squad_Anim_Pd_Stuff3 ] {Squad_AI_HuntStuff(12.0); Squad_EveryFrame();};
void()  Squad_Anim_Pd_Stuff3 =[$run3, Squad_Anim_Pd_Stuff4 ] {Squad_AI_HuntStuff( 9.0); Squad_EveryFrame();};
void()  Squad_Anim_Pd_Stuff4 =[$run4, Squad_Anim_Pd_Stuff5 ] {Squad_AI_HuntStuff( 9.0); Squad_EveryFrame();};
void()  Squad_Anim_Pd_Stuff5 =[$run5, Squad_Anim_Pd_Stuff6 ] {Squad_AI_HuntStuff(12.0); Squad_EveryFrame();};
void()  Squad_Anim_Pd_Stuff6 =[$run6, Squad_Anim_Pd_Stuff7 ] {Squad_AI_HuntStuff(12.0); Squad_EveryFrame();};
void()  Squad_Anim_Pd_Stuff7 =[$run7, Squad_Anim_Pd_Stuff8 ] {Squad_AI_HuntStuff( 6.0); Squad_EveryFrame();};
void()  Squad_Anim_Pd_Stuff8 =[$run8, Squad_Anim_Pd_Stuff9 ] {Squad_AI_HuntStuff( 9.0); Squad_EveryFrame();};
void()  Squad_Anim_Pd_Stuff9 =[$run9, Squad_Anim_Pd_Stuff1 ] {Squad_AI_HuntStuff( 9.0); Squad_EveryFrame();};



// Squad_Anim_Strafe - animations to strafe rightwards
//
//
//
void () Squad_Anim_Strafe =
{ Squad_SetPosture(self, SQUAD_POSTURE_STAND);
  if (Squad_GetRole(self) == SQUAD_ROLE_HANDGUNSOLDIER)
    { if (self.squadStrafeDirection == SQUAD_STRAFE_DIRECTION_RIGHT)
        Squad_Anim_Pd_StrafeRight1();
      else
        Squad_Anim_Pd_StrafeLeft1();
    }
  else
    { if (self.squadStrafeDirection == SQUAD_STRAFE_DIRECTION_RIGHT)
        Squad_Anim_Gd_StrafeRight1();
      else
        Squad_Anim_Gd_StrafeLeft1();
    }
};



void()  Squad_Anim_Pd_StrafeRight1 =
  [$firec1, Squad_Anim_Pd_StrafeRight2 ]
  { Squad_Behavior_Strafe(00); Squad_EveryFrame(); };
void()  Squad_Anim_Pd_StrafeRight2 =
  [$firec2, Squad_Anim_Pd_StrafeRight3 ]
  { Squad_Behavior_Strafe(00); Squad_EveryFrame(); };
void()  Squad_Anim_Pd_StrafeRight3 =
  [$firec3, Squad_Anim_Pd_StrafeRight4 ]
  { Squad_Behavior_Strafe(00); Squad_EveryFrame(); };
void()  Squad_Anim_Pd_StrafeRight4 =
  [$firec5, Squad_Anim_Pd_StrafeRight5 ]
  { Squad_Behavior_Strafe(00); Squad_EveryFrame(); };
void()  Squad_Anim_Pd_StrafeRight5 =
  [$firec7, Squad_Anim_Pd_StrafeRight6 ]
  { Squad_Behavior_Strafe(10); Squad_EveryFrame(); };
void()  Squad_Anim_Pd_StrafeRight6 =
  [$firec9, Squad_Anim_Pd_StrafeRight7 ]
  { Squad_Behavior_Strafe(05); Squad_EveryFrame(); };
void()  Squad_Anim_Pd_StrafeRight7 =
  [$firec11, Squad_Anim_Pd_StrafeRight8 ]
  { Squad_Behavior_Strafe(03); Squad_EveryFrame(); };
void()  Squad_Anim_Pd_StrafeRight8 =
  [$firec13, Squad_Anim_Pd_StrafeRight9 ]
  { Squad_Behavior_Strafe(05); Squad_EveryFrame(); };
void()  Squad_Anim_Pd_StrafeRight9 =
  [$firec15, Squad_Anim_Pd_StrafeRight1 ]
  { Squad_Behavior_Strafe(04); Squad_AI_StrafeFinish();
    Squad_EveryFrame();
  };


void()  Squad_Anim_Pd_StrafeLeft1 =
  [$firec15, Squad_Anim_Pd_StrafeLeft2 ]
  { Squad_Behavior_Strafe(00); Squad_EveryFrame(); };
void()  Squad_Anim_Pd_StrafeLeft2 =
  [$firec13, Squad_Anim_Pd_StrafeLeft3 ]
  { Squad_Behavior_Strafe(00); Squad_EveryFrame(); };
void()  Squad_Anim_Pd_StrafeLeft3 =
  [$firec11, Squad_Anim_Pd_StrafeLeft4 ]
  { Squad_Behavior_Strafe(00); Squad_EveryFrame(); };
void()  Squad_Anim_Pd_StrafeLeft4 =
  [$firec9, Squad_Anim_Pd_StrafeLeft5 ]
  { Squad_Behavior_Strafe(00); Squad_EveryFrame(); };
void()  Squad_Anim_Pd_StrafeLeft5 =
  [$firec7, Squad_Anim_Pd_StrafeLeft6 ]
  { Squad_Behavior_Strafe(10); Squad_EveryFrame(); };
void()  Squad_Anim_Pd_StrafeLeft6 =
  [$firec5, Squad_Anim_Pd_StrafeLeft7 ]
  { Squad_Behavior_Strafe(05); Squad_EveryFrame(); };
void()  Squad_Anim_Pd_StrafeLeft7 =
  [$firec3, Squad_Anim_Pd_StrafeLeft8 ]
  { Squad_Behavior_Strafe(03); Squad_EveryFrame(); };
void()  Squad_Anim_Pd_StrafeLeft8 =
  [$firec2, Squad_Anim_Pd_StrafeLeft9 ]
  { Squad_Behavior_Strafe(05); Squad_EveryFrame(); };
void()  Squad_Anim_Pd_StrafeLeft9 =
  [$firec1, Squad_Anim_Pd_StrafeLeft1 ]
  { Squad_Behavior_Strafe(04); Squad_AI_StrafeFinish();
    Squad_EveryFrame();
  };




// Squad_Anim_Die   - chooses animation given weapon and chance
//
//
//
void()  Squad_Anim_Die =
{ Squad_SetState(self, SQUAD_MEMBERDIE);
  self.nextthink = time + 0.03;
  local float r;
  if (self.health < -40)
  {
      if (deathmatch)
      {
        Squad_MemberDeactivate();
      }
      return;
  }

  r = random();
  if (r > 0.66)
    sound (self, CHAN_VOICE, "weapons/die3.wav", 1, ATTN_NORM);
  else
  if (r > 0.33)
    sound (self, CHAN_VOICE, "weapons/die2.wav", 1, ATTN_NORM);
  else
    sound (self, CHAN_VOICE, "weapons/die1.wav", 1, ATTN_NORM);

  if (Squad_GetRole(self) == SQUAD_ROLE_HANDGUNSOLDIER)
    { r = rint((random() * 4) + 1);
      if (Squad_GetPosture(self) == SQUAD_POSTURE_SIT)
        { self.frame = $deatha1; self.think = Squad_Anim_Pd_DieA1; return;}
      if (r == 1)
        { self.frame = $deathc1; self.think = Squad_Anim_Pd_DieC1; }
      else if (r == 2)
        { self.frame = $deathd1; self.think = Squad_Anim_Pd_DieD1; }
      else if (r == 3)
        { self.frame = $deathe1; self.think = Squad_Anim_Pd_DieE1; }
      else
        { self.frame = $deathf1; self.think = Squad_Anim_Pd_DieF1; }
    }
  else
    { r = rint((random() * 3) + 1);
      if (Squad_GetPosture(self) == SQUAD_POSTURE_SIT)
        { self.frame = 9; // $deatha1;
          self.think = Squad_Anim_Gd_DieA1;
        }
      else if (r == 1)
        { self.frame = 19; // $deathb1;
          self.think = Squad_Anim_Gd_DieB1;
        }
      else if (r == 2)
        { self.frame = 30; // $deathc1;
          self.think = Squad_Anim_Gd_DieC1;
        }
      else
        { self.frame = 0; // $deathd1;
          self.think = Squad_Anim_Gd_DieD1;
        }
    }

  // death frame sequence includes bot deactivation
};



// Squad_Anim_Pd_Die - animations to die with gun active, sitting
//
//
//
void() Squad_Anim_Pd_DieA1 =
{ self.nextthink  = time + 0.05;

  // update frame
  local float f_frame;
  f_frame = self.frame + 1;
  self.frame      = self.frame + 1;
  if (f_frame > $deatha14 )
    self.frame = $deatha14;
  else
    self.frame = f_frame;

  // do some thinking
  if (f_frame == $deatha4 )
    { Squad_Behavior_Move(-4);
      //self.ammo_shells = 2;self.ammo_nails = 2;
      //self.ammo_cells = 2;
      DropBackpack();
    }
  else
  if (((f_frame > $deatha5 ) && (f_frame < $deatha12 )) ||
      (f_frame == $deatha3 )
     )
    Squad_Behavior_Move(-4);
  else
  if (f_frame == $deatha14 )
    { Squad_SetPosture(self, SQUAD_POSTURE_LAY);
      Squad_MemberDeactivate();
    }
};



void() Squad_Anim_Pd_DieC1 =
{ self.nextthink  = time + 0.05;

  // update frame
  local float f_frame;
  f_frame = self.frame + 1;
  self.frame      = self.frame + 1;
  if (f_frame > $deathc12 )
    self.frame = $deathc12;
  else
    self.frame = f_frame;

  // do some thinking
  if (f_frame == $deathc4 )
    { //self.ammo_shells = 2;self.ammo_nails = 2;
      //self.ammo_cells = 2;
      DropBackpack();
      ai_back(4);
    }
  else
  if (f_frame == $deathc12 )
    { Squad_SetPosture(self, SQUAD_POSTURE_LAY);
      Squad_MemberDeactivate();
    }
};



void() Squad_Anim_Pd_DieD1 =
{ self.nextthink  = time + 0.05;

  // update frame
  local float f_frame;
  f_frame = self.frame + 1;
  self.frame      = self.frame + 1;
  if (f_frame > $deathd9  )
    self.frame = $deathd9;
  else
    self.frame = f_frame;

  // do some thinking
  if (f_frame == $deathd4 )
    { //self.ammo_shells = 2;self.ammo_nails = 2;
      //self.ammo_cells = 2;
      DropBackpack();
      ai_back(4);
    }
  else
  if (f_frame == $deathd9 )
    { Squad_SetPosture(self, SQUAD_POSTURE_LAY);
      Squad_MemberDeactivate();
    }
};
  


void() Squad_Anim_Pd_DieE1 =
{ self.nextthink  = time + 0.05;

  // update frame
  local float f_frame;
  f_frame = self.frame + 1;
  self.frame      = self.frame + 1;
  if (f_frame > $deathe12 )
    self.frame = $deathe12;
  else
    self.frame = f_frame;

  // do some thinking
  if (f_frame == $deathe4 )
    { //self.ammo_shells = 2;self.ammo_nails = 2;
      //self.ammo_cells = 2;
      DropBackpack();
      ai_back(4);
    }
  else
  if (f_frame == $deathe12 )
    { Squad_SetPosture(self, SQUAD_POSTURE_LAY);
      Squad_MemberDeactivate();
    }
};



void() Squad_Anim_Pd_DieF1 =
{ self.nextthink  = time + 0.05;

  // update frame
  local float f_frame;
  f_frame = self.frame + 1;
  self.frame      = self.frame + 1;
  if (f_frame > $deathf9  )
    self.frame = $deathf9;
  else
    self.frame = f_frame;

  // do some thinking
  if (f_frame == $deathf4 )
    { //self.ammo_shells = 2;self.ammo_nails = 2;
      //self.ammo_cells = 2;
      DropBackpack();
      ai_back(4);
    }
  else
  if (f_frame == $deathf9 )
    { Squad_SetPosture(self, SQUAD_POSTURE_LAY);
      Squad_MemberDeactivate();
    }
};




// Squad_Anim_Defend  - animations to roll or sit down
//
//
//
void() Squad_Anim_Defend =
{ // process role
  if (Squad_GetRole(self) == SQUAD_ROLE_HANDGUNSOLDIER)
    { // process posture
      if (Squad_GetPosture(self) == SQUAD_POSTURE_STAND)
        Squad_Anim_Pd_Roll1();
      else
        Squad_Anim_Pd_Roll5();
    }
  else
    Squad_Anim_Gd_Draw3();
};




// Squad_Anim_Roll    - animations to roll, either from standing or
//                      sitting posture
//
//
void() Squad_Anim_Roll =
{ // process posture
  if (Squad_GetPosture(self) == SQUAD_POSTURE_STAND)
    Squad_Anim_Pd_Roll1();
  else
    Squad_Anim_Pd_Roll5();
};

void() Squad_Anim_Pd_Roll1 =  [ $roll1  , Squad_Anim_Pd_Roll2 ]
  { self.nextthink = time + 0.05;
    Squad_EveryFrame();
  };
void() Squad_Anim_Pd_Roll2 =  [ $roll2  , Squad_Anim_Pd_Roll3 ]  {Squad_Behavior_Move( 4.5);self.nextthink = time + 0.05; Squad_EveryFrame(); };
void() Squad_Anim_Pd_Roll3 =  [ $roll3  , Squad_Anim_Pd_Roll4 ]  {Squad_Behavior_Move( 3.1);self.nextthink = time + 0.05;  };
void() Squad_Anim_Pd_Roll4 =  [ $roll4  , Squad_Anim_Pd_Roll5 ]  {Squad_Behavior_Move( 3.1);self.nextthink = time + 0.05; Squad_EveryFrame(); };
void() Squad_Anim_Pd_Roll5 =  [ $roll5  , Squad_Anim_Pd_Roll6 ]  {Squad_Behavior_Move( 1.6);self.nextthink = time + 0.05;  };
void() Squad_Anim_Pd_Roll6 =  [ $roll6  , Squad_Anim_Pd_Roll7 ]  {Squad_Behavior_Move( 4.5);self.nextthink = time + 0.05; Squad_EveryFrame(); };
void() Squad_Anim_Pd_Roll7 =  [ $roll7  , Squad_Anim_Pd_Roll8 ]  {Squad_Behavior_Move(10.5);self.nextthink = time + 0.05;  };
void() Squad_Anim_Pd_Roll8 =  [ $roll8  , Squad_Anim_Pd_Roll9 ]  {Squad_Behavior_Move(12.0);self.nextthink = time + 0.05; Squad_EveryFrame(); };
void() Squad_Anim_Pd_Roll9 =  [ $roll9  , Squad_Anim_Pd_Roll10 ]
  { Squad_Behavior_Move(6);
    Squad_SetPosture(self, SQUAD_POSTURE_ROLL);
    self.nextthink = time + 0.05;
  };
void() Squad_Anim_Pd_Roll10 = [ $roll10 , Squad_Anim_Pd_Roll11 ] {Squad_Behavior_Move( 9.0);self.nextthink = time + 0.05; Squad_EveryFrame(); };
void() Squad_Anim_Pd_Roll11 = [ $roll11 , Squad_Anim_Pd_Roll12 ] {Squad_Behavior_Move( 7.5);self.nextthink = time + 0.05;  };
void() Squad_Anim_Pd_Roll12 = [ $roll12 , Squad_Anim_Pd_Roll13 ] {Squad_Behavior_Move( 7.5);self.nextthink = time + 0.05; Squad_EveryFrame(); };
void() Squad_Anim_Pd_Roll13 = [ $roll13 , Squad_Anim_Pd_Roll14 ] {Squad_Behavior_Move( 7.5);self.nextthink = time + 0.05;  };
void() Squad_Anim_Pd_Roll14 = [ $roll14 , Squad_Anim_Pd_Roll15 ] {Squad_Behavior_Move( 9.0);self.nextthink = time + 0.05; Squad_EveryFrame(); };
void() Squad_Anim_Pd_Roll15 = [ $roll15 , Squad_Anim_Pd_Roll16 ] {Squad_Behavior_Move( 7.5);self.nextthink = time + 0.05;  };
void() Squad_Anim_Pd_Roll16 = [ $roll16 , Squad_Anim_Pd_Roll17 ] {Squad_Behavior_Move( 7.5);self.nextthink = time + 0.05; Squad_EveryFrame(); };
void() Squad_Anim_Pd_Roll17 = [ $roll17 , Squad_Anim_Pd_Roll18 ] {Squad_Behavior_Move( 7.5);self.nextthink = time + 0.05;  };
void() Squad_Anim_Pd_Roll18 = [ $roll18 , Squad_Anim_Pd_Roll19 ] {Squad_Behavior_Move( 7.5);self.nextthink = time + 0.05; Squad_EveryFrame(); };
void() Squad_Anim_Pd_Roll19 = [ $roll19 , Squad_Anim_Pd_Roll20 ] {Squad_Behavior_Move( 7.5);self.nextthink = time + 0.05;  };
void() Squad_Anim_Pd_Roll20 = [ $roll20 , Squad_Anim_Pd_Roll21 ] {Squad_Behavior_Move( 7.5);self.nextthink = time + 0.05; Squad_EveryFrame(); };
void() Squad_Anim_Pd_Roll21 = [ $roll21 , Squad_Anim_Pd_Roll22 ] {Squad_Behavior_Move( 7.5);self.nextthink = time + 0.05;  };
void() Squad_Anim_Pd_Roll22 = [ $roll22 , Squad_Anim_Pd_Roll23 ] {Squad_Behavior_Move( 7.5);self.nextthink = time + 0.05; Squad_EveryFrame(); };
void() Squad_Anim_Pd_Roll23 = [ $roll23 , Squad_Anim_Pd_Roll24 ] {Squad_Behavior_Move( 4.5);self.nextthink = time + 0.05;  };
void() Squad_Anim_Pd_Roll24 = [ $roll24 , Squad_Anim_Pd_Roll25 ] {Squad_Behavior_Move( 3.75);self.nextthink = time + 0.05; Squad_EveryFrame(); };
void() Squad_Anim_Pd_Roll25 = [ $roll25 , Squad_Anim_Pd_Roll26 ] {Squad_Behavior_Move( 0.5);self.nextthink = time + 0.05; Squad_EveryFrame(); };
void() Squad_Anim_Pd_Roll26 = [ $roll26 , Squad_Anim_Pd_Roll27 ] {Squad_Behavior_Move( 0.1);self.nextthink = time + 0.05; Squad_EveryFrame(); };
void() Squad_Anim_Pd_Roll27 = [ $roll27 , Squad_Anim_Pd_Roll1  ]
  { Squad_SetPosture(self, SQUAD_POSTURE_STAND);
    Squad_EveryFrame();
    Squad_AI_RollFinish();
  };



// Squad_Anim_Pain - animations to show pain
//
//
//
void()  Squad_Anim_Pain =
{ self.nextthink  = time + 0.03;

  // try to turn towards attacker
  if (self.enemy != world)
    { local vector v;
      v              = self.enemy.origin - self.origin;
      self.ideal_yaw = vectoyaw(v);
    }

  local float r;
  // sound, 25% chance, one of three sounds
  r = random();
  if (r > 0.91)
    sound(self,CHAN_BODY,"weapons/pain1.wav",1,ATTN_NORM);
  else
  if (r > 0.83)
    sound(self,CHAN_BODY,"weapons/pain2.wav",1,ATTN_NORM);
  else
  if (r > 0.75)
    sound(self,CHAN_BODY,"weapons/pain3.wav",1,ATTN_NORM);

  if (Squad_GetRole(self) == SQUAD_ROLE_HANDGUNSOLDIER)
    { // process posture
      if (Squad_GetPosture(self) == SQUAD_POSTURE_STAND)
        { r = 3 * random();
          if (r < 1)
            { self.frame = $painc1; self.think = Squad_Anim_Pd_PainC1; }
          else if (r < 2)
            { self.frame = $paind1; self.think = Squad_Anim_Pd_PainD1; }
          else
            { self.frame = $paine1; self.think = Squad_Anim_Pd_PainE1; }
        }
      else
        { r = 2 * random();
          if (r < 1)
            { self.frame = $paina1; self.think = Squad_Anim_Pd_PainA1; }
          else
            { self.frame = $painb1; self.think = Squad_Anim_Pd_PainB1; }
        }
    }
  else
    { // process posture
      if (Squad_GetPosture(self) == SQUAD_POSTURE_STAND)
        { r = 3 * random();
          if (r < 1)
            { self.frame = 47; // $painb1;
              self.think = Squad_Anim_Gd_PainB1;
            }
          else if (r < 2)
            { self.frame = 52; // $painc1;
              self.think = Squad_Anim_Gd_PainC1;
            }
          else
            { self.frame = 59; // $paind1;
              self.think = Squad_Anim_Gd_PainD1;
            }
        }
      else
        { self.frame = 42; // $paina1;
          self.think = Squad_Anim_Gd_PainA1;
        }
    }
};


void() Squad_Anim_Pd_PainA1 =
{ self.nextthink  = time + 0.1;

  // update frame
  local float f_frame;
  f_frame = self.frame + 1;
  self.frame      = self.frame + 1;
  if (f_frame > $paina6 )
    Squad_AI_FinishedPain();
  else
    self.frame = f_frame;

  // do some thinking
  Squad_EveryFrame();
  // adjust yaw
  ChangeYaw();

  if (f_frame == $paina4 )
    { ai_pain(1);
      // ignore pain if target is visible
      Squad_AI_NeedIgnorePain();
    }
};



void() Squad_Anim_Pd_PainB1 =
{ self.nextthink  = time + 0.1;

  // update frame
  local float f_frame;
  f_frame = self.frame + 1;
  self.frame      = self.frame + 1;
  if (f_frame > $painb8 )
    Squad_AI_FinishedPain();
  else
    self.frame = f_frame;

  // do some thinking
  Squad_EveryFrame();
  if (f_frame == $painb4 )
    { ai_pain(1);
      // ignore pain if target is visible
      Squad_AI_NeedIgnorePain();
    }
};



void() Squad_Anim_Pd_PainC1 =
{ self.nextthink  = time + 0.1;

  // update frame
  local float f_frame;
  f_frame = self.frame + 1;
  self.frame      = self.frame + 1;
  if (f_frame > $painc6 )
    Squad_AI_FinishedPain();
  else
    self.frame = f_frame;

  // do some thinking
  Squad_EveryFrame();
  // adjust yaw
  ChangeYaw();

  if (f_frame == $painc4 )
    { ai_pain(1);
      // ignore pain if target is visible
      Squad_AI_NeedIgnorePain();
    }
};



void() Squad_Anim_Pd_PainD1 =
{ self.nextthink  = time + 0.1;

  // update frame
  local float f_frame;
  f_frame = self.frame + 1;
  self.frame      = self.frame + 1;
  if (f_frame > $paind6 )
    Squad_AI_FinishedPain();
  else
    self.frame = f_frame;

  // do some thinking
  Squad_EveryFrame();
  // adjust yaw
  ChangeYaw();

  if (f_frame == $paind4 )
    { ai_pain(1);
      // ignore pain if target is visible
      Squad_AI_NeedIgnorePain();
    }
};



void() Squad_Anim_Pd_PainE1 =
{ self.nextthink  = time + 0.1;

  // update frame
  local float f_frame;
  f_frame = self.frame + 1;
  self.frame      = self.frame + 1;
  if (f_frame > $paine6 )
    Squad_AI_FinishedPain();
  else
    self.frame = f_frame;

  // do some thinking
  Squad_EveryFrame();
  // adjust yaw
  ChangeYaw();
  
  if (f_frame == $paine4 )
    { ai_pain(1);
      // ignore pain if target is visible
      Squad_AI_NeedIgnorePain();
    }
};


/*
// Squad_RollLeftDistance() - has self move left (wrt to angles)
//                            only to be called by self
//
void (entity member, float dist) Squad_RollLeftDistance =
{ walkmove(self.angles_y + 90, dist);
};



// Squad_RollRightDistance() - has self move right (wrt to angles)
//                            only to be called by self
//
void (entity member, float dist) Squad_RollRightDistance =
{ walkmove(self.angles_y - 90, dist);
};



// Squad_AdjustRoll   - sets roll (in degrees) of model
//
//
//
void (float newRoll) Squad_AdjustRoll =
{ self.angles_z = newRoll;
};
*/


// Squad_Anim_AttackMelee - animations to attack using knife
//
//
//
void()  Squad_Anim_AttackMelee =
{ self.nextthink = time + 0.03;
  // no need to process posture
  Squad_SetPosture(self, SQUAD_POSTURE_STAND);
  // check if near enemy
  local float fDistance;
  fDistance = vlen(self.origin - self.enemy.origin);

  if (Squad_GetRole(self) == SQUAD_ROLE_HANDGUNSOLDIER)
    { if (fDistance < 80)
        { self.frame = $melee1;
          self.think = Squad_Anim_Pd_AttackMeleeUseKnife1;
        }
      else
        { self.frame = $run1;
          self.think = Squad_Anim_Pd_AttackMeleeApproach1;
        }
    }
  else
    { if (fDistance < 80)
        { self.frame = 64; // $melee1;
          self.think = Squad_Anim_Gd_AttackMeleeUseGun1;
        }
      else
        { self.frame = 166; // $run1;
          self.think = Squad_Anim_Gd_AttackMeleeApproach1;
        }
    }
};



// Squad_Anim_Pd_AttackMeleeUseKnife1 - animations to attack using knife
//
//
//
void()  Squad_Anim_Pd_AttackMeleeUseKnife1 =
{ self.nextthink  = time + 0.06;

  // update frame
  local float f_frame;
  f_frame = self.frame + 1;
  self.frame      = self.frame + 1;
  if (f_frame > $melee17 )
    Squad_Anim_AttackMelee();
  else
    self.frame = f_frame;

  // do some thinking
  ai_face();
  Squad_EveryFrame(); Squad_AI_EveryAttack(0);

  // special frames
  if ((f_frame == $melee8  ) ||
      (f_frame == $melee9  ) ||
      (f_frame == $melee15 ) ||
      (f_frame == $melee16 )
     )
    { // step forward and ...
      Squad_Behavior_Move(12.0);
      // ... attack enemy
      local float fDistance;
      fDistance = vlen(self.origin - self.enemy.origin);
      if (fDistance < 50)
        { local float fDamage;
	  fDamage = 10 + 5*random();
	  T_Damage (self.enemy, self, self, fDamage);
        }
      sound (self, CHAN_WEAPON, "weapons/slash.wav", 1, ATTN_NORM);
    }
};



void () Squad_Anim_Pd_AttackMeleeApproach1 =
  [$run1, Squad_Anim_Pd_AttackMeleeApproach2 ]
  { Squad_AI_Assault( 9.0); Squad_EveryFrame(); Squad_AI_EveryAttack(0); };
void () Squad_Anim_Pd_AttackMeleeApproach2 =
  [$run2, Squad_Anim_Pd_AttackMeleeApproach3 ]
  { Squad_AI_Assault(12.0); Squad_EveryFrame(); Squad_AI_EveryAttack(0); };
void () Squad_Anim_Pd_AttackMeleeApproach3 =
  [$run3, Squad_Anim_Pd_AttackMeleeApproach4 ]
  { Squad_AI_Assault( 9.0); Squad_EveryFrame(); Squad_AI_EveryAttack(0); };
void () Squad_Anim_Pd_AttackMeleeApproach4 =
  [$run4, Squad_Anim_Pd_AttackMeleeApproach5 ]
  { Squad_AI_Assault( 9.0); Squad_EveryFrame(); Squad_AI_EveryAttack(0); };
void () Squad_Anim_Pd_AttackMeleeApproach5 =
  [$run5, Squad_Anim_Pd_AttackMeleeApproach6 ]
  { Squad_AI_Assault(12.0); Squad_EveryFrame(); Squad_AI_EveryAttack(0); };
void () Squad_Anim_Pd_AttackMeleeApproach6 =
  [$run6, Squad_Anim_Pd_AttackMeleeApproach7 ]
  { Squad_AI_Assault(12.0); Squad_EveryFrame(); Squad_AI_EveryAttack(0); };
void () Squad_Anim_Pd_AttackMeleeApproach7 =
  [$run7, Squad_Anim_Pd_AttackMeleeApproach8 ]
  { Squad_AI_Assault( 6.0); Squad_EveryFrame(); Squad_AI_EveryAttack(0); };
void () Squad_Anim_Pd_AttackMeleeApproach8 =
  [$run8, Squad_Anim_Pd_AttackMeleeApproach9 ]
  { Squad_AI_Assault( 9.0); Squad_EveryFrame(); Squad_AI_EveryAttack(0); };
void () Squad_Anim_Pd_AttackMeleeApproach9 =
  [$run9, Squad_Anim_Attack ]
  { Squad_AI_Assault( 9.0); Squad_EveryFrame(); Squad_AI_EveryAttack(0); };



// Squad_Anim_Pd_AttackHandgun - animations for attacking using hand gun;
//                               take into account postures; most of the
//                               time, continues previous animations
//
void()  Squad_Anim_Pd_AttackHandgun =
{ self.nextthink = time + 0.03;
  local float r;
  r = random();
  if (r < 0.8)
  { // try to continue previous animation, else, fall thru
    if ((self.frame == $drawa7 ) || (self.frame == $firea3 ))
      { self.think = Squad_Anim_Pd_AttackHandgunStandingA1;
        return;
      }
    else
    if ((self.frame == $drawb6 ) || (self.frame == $fireb3 ))
      { self.think = Squad_Anim_Pd_AttackHandgunStandingB1;
        return;
      }
  }
  // process posture
  if (Squad_GetPosture(self) == SQUAD_POSTURE_STAND)
    { r = 2 * random();
      if (r < 1)
        self.think = Squad_Anim_Pd_AttackHandgunStandingA1;
      else
        self.think = Squad_Anim_Pd_AttackHandgunStandingB1;
    }
  else // sitting
    { r = random();
      if (r < 0.7)
        // continue sitting
        self.think = Squad_Anim_Pd_AttackHandgunSittingD1;
      else
        // raise a little
        self.think = Squad_Anim_Pd_AttackHandgunStandingA1;
    }
};



// Squad_Anim_Pd_AttackHandgunStandingXY - animations for attacking using hand
//                                      gun while standing
//
//
void()  Squad_Anim_Pd_AttackHandgunStandingA1 =
  [ $firea1, Squad_Anim_Pd_AttackHandgunStandingA2 ]
  { Squad_SetPosture(self, SQUAD_POSTURE_STAND);
    Squad_AI_AttackSomeHandgun();
    ai_face(); Squad_EveryFrame(); Squad_AI_EveryAttack(0);
  };
void()  Squad_Anim_Pd_AttackHandgunStandingA2 =
  [ $firea2, Squad_Anim_Pd_AttackHandgunStandingA3 ]
  { ai_face(); Squad_EveryFrame();
  };
void()  Squad_Anim_Pd_AttackHandgunStandingA3 =
  [ $firea3, Squad_Anim_Attack ]
  { ai_face(); Squad_EveryFrame();
  };


void()  Squad_Anim_Pd_AttackHandgunStandingB1 =
  [ $fireb1, Squad_Anim_Pd_AttackHandgunStandingB2 ]
  { Squad_SetPosture(self, SQUAD_POSTURE_STAND);
    Squad_AI_AttackSomeHandgun();
    ai_face(); Squad_EveryFrame(); Squad_AI_EveryAttack(0);
  };
void()  Squad_Anim_Pd_AttackHandgunStandingB2 =
  [ $fireb2, Squad_Anim_Pd_AttackHandgunStandingB3 ]
  { ai_face(); Squad_EveryFrame();
  };
void()  Squad_Anim_Pd_AttackHandgunStandingB3 =
  [ $fireb3, Squad_Anim_Attack ]
  { ai_face(); Squad_EveryFrame();
  };


void()  Squad_Anim_Pd_AttackHandgunSittingD1 =
  [ $fired1, Squad_Anim_Pd_AttackHandgunSittingD2 ]
  { Squad_SetPosture(self, SQUAD_POSTURE_SIT);
    Squad_AI_AttackSomeHandgun();
    ai_face(); Squad_EveryFrame(); Squad_AI_EveryAttack(0);
  };
void()  Squad_Anim_Pd_AttackHandgunSittingD2 =
  [ $fired2, Squad_Anim_Pd_AttackHandgunSittingD3 ]
  { ai_face(); Squad_EveryFrame();
  };
void()  Squad_Anim_Pd_AttackHandgunSittingD3 =
  [ $fired3, Squad_Anim_Attack ]
  { ai_face(); Squad_EveryFrame();
  };



// Squad_Anim_AttackHandGrenade - animations to throw hand
//                                grenade; assumption:
//                                required grenade velocity
//                                already calculated
//
void (float fGrenadeType)  Squad_Anim_AttackHandGrenade =
{ self.grenadetype = fGrenadeType;
  self.nextthink   = time + 0.1;
  // no need to process posture
  Squad_SetPosture(self, SQUAD_POSTURE_STAND);
  if (Squad_GetRole(self) == SQUAD_ROLE_HANDGUNSOLDIER)
    { self.frame = $grenade1;
      self.think = Squad_Anim_Pd_AttackHandGrenade1;
    }
  else
    { self.frame = 88; // $grenade1;
      self.think = Squad_Anim_Gd_AttackHandGrenade1;
    }
};



void () Squad_Anim_Pd_AttackHandGrenade1 =
{ self.nextthink  = time + 0.1;

  local float f_frame;
  f_frame = self.frame + 1;
  if (f_frame > $grenade16 )
    { // allow for change of posture
      Squad_AI_GrenadeFinish();
    }
  else
    self.frame = f_frame;

  // do some thinking
  Squad_EveryFrame();
  ai_face();

  // special frames
  if (f_frame == $grenade2 )
    { // record required grenade speed and direction
      local entity receiver;
      receiver = Squad_FI_CanThrowGrenade(self, self.enemy);
      if (receiver != self.enemy)
        Squad_AI_GrenadeFinish();
    }
  else
  if (f_frame == $grenade5 )
    { sound(self,CHAN_WEAPON,"weapons/gpull.wav",1,ATTN_NORM);
    }
  else
  if (f_frame == $grenade13 )
    { Squad_AI_AttackHandGrenade();
    }
};



// Squad_Anim_Attack - selects behavior/animation
//                     corresponding to weapon
//
//
//
void() Squad_Anim_Attack =
{ if ((!visible(self.enemy))
      || (self.enemy.health < 0)
     )
    { Squad_SetState(self, SQUAD_MEMBERPATROL);
      return;
    }
  // use knife if empty clip and nearby enemy or no ammo at all
  local float fDistance;
  fDistance = vlen(self.origin - self.enemy.origin);

  if (Squad_GetRole(self) == SQUAD_ROLE_HANDGUNSOLDIER)
    { if ((self.mk23clip == 0) &&
          ((fDistance < 300) || (self.ammo_shells == 0))
         )
        Squad_Anim_AttackMelee();
      else
      // use hand grenade if allowed by team, enemy is not near
      // and team mates cannot be hurt by grenade
        { local float fGrenadeType;
          fGrenadeType = Squad_AI_ShouldUseHandGrenade(self, self.enemy);
          if (fGrenadeType != SQUAD_NO_GRENADE)
            Squad_Anim_AttackHandGrenade(fGrenadeType);
          else
          // either reload or attack again
          if ((self.ammo_shells > 0) && (self.mk23clip == 0))
            Squad_SetState(self, SQUAD_MEMBERRELOAD);
          else
            Squad_Anim_Pd_AttackHandgun();
        }
    }
  else
    { if ((self.mp5clip == 0) &&
          ((fDistance < 300) || (self.ammo_shells == 0))
         )
        Squad_Anim_AttackMelee();
      else
      // use hand grenade if allowed by team, enemy is not near
      // and team mates cannot be hurt by grenade
        { local float fGrenadeType;
          fGrenadeType = Squad_AI_ShouldUseHandGrenade(self, self.enemy);
          if (fGrenadeType != SQUAD_NO_GRENADE)
            Squad_Anim_AttackHandGrenade(fGrenadeType);
          else
          // either reload or attack again
          if ((self.ammo_shells > 0) && (self.mp5clip == 0))
            Squad_SetState(self, SQUAD_MEMBERRELOAD);
          else
            Squad_Anim_Gd_AttackMachinegun();
        }
    }
};








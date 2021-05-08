/****************************************************************************/
/*                                                                          */
/*    project    : S.E.A.L. sQuad       (c) 1997 William van der Sterren    */
/*                                                                          */
/*      file     : squad_gd.qc  "animation functions; guard animations"     */
/*      author(s): William van der Sterren                                  */
/*      version  : 0.5                                                      */
/*                                                                          */
/*      date (last revision):  Sep 08, 97                                   */
/*      date (creation)     :  Oct 05, 97                                   */
/*                                                                          */
/*                                                                          */
/*      revision history                                                    */
/*      -- date ---- | -- revision ---------------------- | -- revisor --   */
/*      Nov 25, 1997 | used "guard" animations            | william         */
/*                                                                          */
/****************************************************************************/
//
// Squad initialization, creation and information
//

// prototypes - local functions



// implementation


// forward declarations



// frame declarations (copied from guard.qc)
$cd id1/models/guard
$origin 0 -6 -24
$base base
$skin skin
//0
$frame deathd1 deathd2 deathd3 deathd4 deathd5 deathd6 deathd7 deathd8
$frame deathd9
// 9
$frame deatha1 deatha2 deatha3 deatha4 deatha5 deatha6 deatha7 deatha8
$frame deatha9 deatha10
// 19
$frame deathb1 deathb2 deathb3 deathb4 deathb5 deathb6 deathb7 deathb8
$frame deathb9 deathb10 deathb11
// 30
$frame deathc1 deathc2 deathc3 deathc4 deathc5 deathc6 deathc7 deathc8
$frame deathc9 deathc10 deathc11 deathc12
// 42
$frame paina1 paina2 paina3 paina4 paina5
// 47
$frame painb1 painb2 painb3 painb4 painb5
// 52
$frame painc1 painc2 painc3 painc4 painc5 painc6 painc7
// 59
$frame paind1 paind2 paind3 paind4 paind5
// 64
$frame melee1 melee2 melee3 melee4 melee5 melee6 melee7 melee8 melee9 melee10
// 74
$frame load1 load2 load3 load4 load5 load6 load7 load8 load9 load10
$frame load11 load12 load13 load14
// 88
$frame grenade1 grenade2 grenade3 grenade4 grenade5 grenade6 grenade7 grenade8
$frame grenade9 grenade10 grenade11 grenade12 grenade13 grenade14 grenade15
$frame grenade16
// 104
$frame drawa1 drawa2 drawa3 drawa4 drawa5 drawa6 drawa7
// 111
$frame firea1 firea2 firea3 firea4 firea5 firea6 firea7 firea8
// 119
$frame drawb1 drawb2 drawb3 drawb4 drawb5 drawb6 drawb7 drawb8 drawb9
// 128
$frame fireb1 fireb2
// 130
$frame drawc1 drawc2 drawc3 drawc4 drawc5 drawc6 drawc7 drawc8 drawc9
// 139
$frame firec1 firec2 firec3 firec4 firec5 firec6 firec7 firec8 firec9 firec10
$frame firec11 firec12 firec13
// 152
$frame rstrafe1 rstrafe2 rstrafe3 rstrafe4 rstrafe5 rstrafe6 rstrafe7
// 159
$frame lstrafe1 lstrafe2 lstrafe3 lstrafe4 lstrafe5 lstrafe6 lstrafe7
// 166
$frame run1 run2 run3 run4 run5 run6 run7 run8 run9
// 175
$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9 walk10
$frame walk11 walk12 walk13 walk14 walk15 walk16 walk17 walk18 walk19
$frame walk20 walk21 walk22 walk23 walk24 walk25 walk26 walk27 walk28
$frame walk29 walk30 walk31 walk32
// 207
$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8 stand9
$frame stand10 stand11 stand12 stand13 stand14 stand15 stand16 stand17
$frame stand18 stand19 stand20 stand21 stand22
// 229


void () Squad_Anim_Gd_WaitStanding1 =
{ self.nextthink  = time + 0.1;

  local float f_frame;
  f_frame = self.frame + 1;
  if (f_frame > $stand22 )
    { // allow for change of posture
      Squad_Anim_Wait();
    }
  else
    self.frame = f_frame;

  // do some thinking
  Squad_EveryFrame();
  Squad_AI_Wait();
};



void () Squad_Anim_Gd_WaitStanding2 =
{ self.nextthink  = time + 0.1;
  Squad_Anim_Wait();

  // do some thinking
  Squad_EveryFrame();
  Squad_AI_Wait();
};



void () Squad_Anim_Gd_WaitSitting1 =
{ self.nextthink  = time + 0.1;

  local float f_frame;
  f_frame = self.frame + 1;
  if (f_frame > $drawc9 )
    { // allow for change of posture
      Squad_Anim_Wait();
    }
  else
    self.frame = f_frame;

  // do some thinking
  Squad_EveryFrame();
  Squad_AI_Wait();
};



void () Squad_Anim_Gd_Draw1 =
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


void () Squad_Anim_Gd_Draw2 =
{ self.nextthink  = time + 0.05;

  local float f_frame;
  f_frame = self.frame + 1;
  if (f_frame > $drawb9 )
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


void () Squad_Anim_Gd_Draw3 =
{ self.nextthink  = time + 0.05;

  local float f_frame;
  f_frame = self.frame + 1;
  if (f_frame > $drawc9 )
    { Squad_AI_DrawFinish();
      return;
    }
  else
    self.frame = f_frame;

  // perform turn to self.ideal_yaw
  ai_face();
  // do some thinking
  Squad_EveryFrame();
  // special frames
  if (f_frame == $drawc7 )
    Squad_SetPosture(self, SQUAD_POSTURE_SIT);
};


void () Squad_Anim_Gd_Check1 =
{ self.nextthink  = time + 0.1;

  local float f_frame;
  f_frame = self.frame + 1;
  if (f_frame > $drawb9 )
    { // check for enemy and immediately attack
      if (Squad_AI_DetectTarget())
        { // skip pre-attack delay
          Squad_SetState(self, SQUAD_MEMBERATTACK);
          return;
        }

      // ... else, time to reverse anim and turn
      Squad_Anim_Gd_Check2();
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


void () Squad_Anim_Gd_Check2 =
{ self.nextthink  = time + 0.1;

  local float f_frame;
  f_frame     = self.frame - 1;
  if (f_frame >= $drawb1 )
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




void() Squad_Anim_Gd_ReloadStanding1 =
{ self.nextthink  = time + 0.1;

  local float f_frame;
  f_frame = self.frame + 1;
  if (f_frame > $load14 )
    { // finished reloading
      Squad_AI_FinishedReload();
    }
  else
    self.frame = f_frame;

  if (f_frame == $load2 )
   sound(self,CHAN_WEAPON,"weapons/mp5out.wav",1,ATTN_NORM);

  if (f_frame == $load13 )
    { sound(self,CHAN_WEAPON,"weapons/mp5in.wav",1,ATTN_NORM);
      Squad_AI_PerformReload(self);
    }

  // do some thinking
  Squad_EveryFrame();
  Squad_AI_Wait();
};


void()  Squad_Anim_Gd_Walk1  =[$walk1 , Squad_Anim_Gd_Walk2  ]
  { Squad_AI_Walk( 4.0); Squad_EveryFrame(); self.nextthink = time + 0.08; };
void()  Squad_Anim_Gd_Walk2  =[$walk2 , Squad_Anim_Gd_Walk3  ]
  { Squad_AI_Walk( 6.0); Squad_EveryFrame(); self.nextthink = time + 0.08; };
void()  Squad_Anim_Gd_Walk3  =[$walk3 , Squad_Anim_Gd_Walk4  ]
  { Squad_AI_Walk( 6.0); Squad_EveryFrame(); self.nextthink = time + 0.08; };
void()  Squad_Anim_Gd_Walk4  =[$walk4 , Squad_Anim_Gd_Walk5  ]
  { Squad_AI_Walk( 4.5); Squad_EveryFrame(); self.nextthink = time + 0.08; };
void()  Squad_Anim_Gd_Walk5  =[$walk5 , Squad_Anim_Gd_Walk6  ]
  { Squad_AI_Walk( 1.6); Squad_EveryFrame(); self.nextthink = time + 0.08; };
void()  Squad_Anim_Gd_Walk6  =[$walk6 , Squad_Anim_Gd_Walk7  ]
  { Squad_AI_Walk( 3.0); Squad_EveryFrame(); self.nextthink = time + 0.08; };
void()  Squad_Anim_Gd_Walk7  =[$walk7 , Squad_Anim_Gd_Walk8  ]
  { Squad_AI_Walk( 4.0); Squad_EveryFrame(); self.nextthink = time + 0.08; };
void()  Squad_Anim_Gd_Walk8  =[$walk8 , Squad_Anim_Gd_Walk9  ]
  { Squad_AI_Walk( 2.6); Squad_EveryFrame(); self.nextthink = time + 0.08; };
void()  Squad_Anim_Gd_Walk9  =[$walk9 , Squad_Anim_Gd_Walk10 ] 
  { Squad_AI_Walk( 4.0); Squad_EveryFrame(); self.nextthink = time + 0.08; };
void()  Squad_Anim_Gd_Walk10 =[$walk10, Squad_Anim_Gd_Walk11 ]
  { Squad_AI_Walk( 7.0); Squad_EveryFrame(); self.nextthink = time + 0.08; };
void()  Squad_Anim_Gd_Walk11 =[$walk11, Squad_Anim_Gd_Walk12 ]
  { Squad_AI_Walk( 6.0); Squad_EveryFrame(); self.nextthink = time + 0.08; };
void()  Squad_Anim_Gd_Walk12 =[$walk12, Squad_Anim_Gd_Walk13 ]
  { Squad_AI_Walk( 1.6); Squad_EveryFrame(); self.nextthink = time + 0.08; };
void()  Squad_Anim_Gd_Walk13 =[$walk13, Squad_Anim_Gd_Walk14 ] 
  { Squad_AI_Walk( 3.0); Squad_EveryFrame(); self.nextthink = time + 0.08; };
void()  Squad_Anim_Gd_Walk14 =[$walk14, Squad_Anim_Gd_Walk15 ] 
  { Squad_AI_Walk( 5.5); Squad_EveryFrame(); self.nextthink = time + 0.08; };
void()  Squad_Anim_Gd_Walk15 =[$walk15, Squad_Anim_Gd_Walk16 ] 
  { Squad_AI_Walk( 6.0); Squad_EveryFrame(); self.nextthink = time + 0.08; };
void()  Squad_Anim_Gd_Walk16 =[$walk16, Squad_Anim_Gd_Walk17 ]
  { Squad_AI_Walk( 5.0); Squad_EveryFrame(); self.nextthink = time + 0.08; };
void()  Squad_Anim_Gd_Walk17 =[$walk17, Squad_Anim_Gd_Walk18 ]
  { Squad_AI_Walk( 3.0); Squad_EveryFrame(); self.nextthink = time + 0.08; };
void()  Squad_Anim_Gd_Walk18 =[$walk18, Squad_Anim_Gd_Walk19 ] 
  { Squad_AI_Walk( 6.0); Squad_EveryFrame(); self.nextthink = time + 0.08; };
void()  Squad_Anim_Gd_Walk19 =[$walk19, Squad_Anim_Gd_Walk20 ]
  { Squad_AI_Walk( 6.1); Squad_EveryFrame(); self.nextthink = time + 0.08; };
void()  Squad_Anim_Gd_Walk20 =[$walk20, Squad_Anim_Gd_Walk21 ] 
  { Squad_AI_Walk( 4.5); Squad_EveryFrame(); self.nextthink = time + 0.08; };
void()  Squad_Anim_Gd_Walk21 =[$walk21, Squad_Anim_Gd_Walk22 ] 
  { Squad_AI_Walk( 1.6); Squad_EveryFrame(); self.nextthink = time + 0.08; };
void()  Squad_Anim_Gd_Walk22 =[$walk22, Squad_Anim_Gd_Walk23 ] 
  { Squad_AI_Walk( 4.1); Squad_EveryFrame(); self.nextthink = time + 0.08; };
void()  Squad_Anim_Gd_Walk23 =[$walk23, Squad_Anim_Gd_Walk24 ] 
  { Squad_AI_Walk( 4.0); Squad_EveryFrame(); self.nextthink = time + 0.08; };
void()  Squad_Anim_Gd_Walk24 =[$walk24, Squad_Anim_Gd_Walk25 ] 
  { Squad_AI_Walk( 2.6); Squad_EveryFrame(); self.nextthink = time + 0.08; };
void()  Squad_Anim_Gd_Walk25 =[$walk25, Squad_Anim_Gd_Walk26 ] 
  { Squad_AI_Walk( 4.1); Squad_EveryFrame(); self.nextthink = time + 0.08; };
void()  Squad_Anim_Gd_Walk26 =[$walk26, Squad_Anim_Gd_Walk27 ]
  { Squad_AI_Walk( 6.1); Squad_EveryFrame(); self.nextthink = time + 0.08; };
void()  Squad_Anim_Gd_Walk27 =[$walk27, Squad_Anim_Gd_Walk28 ] 
  { Squad_AI_Walk( 6.1); Squad_EveryFrame(); self.nextthink = time + 0.08; };
void()  Squad_Anim_Gd_Walk28 =[$walk28, Squad_Anim_Gd_Walk29 ] 
  { Squad_AI_Walk( 1.6); Squad_EveryFrame(); self.nextthink = time + 0.08; };
void()  Squad_Anim_Gd_Walk29 =[$walk29, Squad_Anim_Gd_Walk30 ] 
  { Squad_AI_Walk( 3.1); Squad_EveryFrame(); self.nextthink = time + 0.08; };
void()  Squad_Anim_Gd_Walk30 =[$walk30, Squad_Anim_Gd_Walk31 ] 
  { Squad_AI_Walk( 4.5); Squad_EveryFrame(); self.nextthink = time + 0.08; };
void()  Squad_Anim_Gd_Walk31 =[$walk31, Squad_Anim_Gd_Walk32 ] 
  { Squad_AI_Walk( 6.1); Squad_EveryFrame(); self.nextthink = time + 0.08; };
void()  Squad_Anim_Gd_Walk32 =[$walk32, Squad_Anim_Gd_Walk1  ]
  { Squad_AI_Walk( 4.1); Squad_EveryFrame(); self.nextthink = time + 0.08; };



void()  Squad_Anim_Gd_Run1 =[$run1, Squad_Anim_Gd_Run2 ] {Squad_AI_Run(27.0); Squad_EveryFrame();};
void()  Squad_Anim_Gd_Run2 =[$run2, Squad_Anim_Gd_Run3 ] {Squad_AI_Run(21.0); Squad_EveryFrame();};
void()  Squad_Anim_Gd_Run3 =[$run3, Squad_Anim_Gd_Run4 ] {Squad_AI_Run(10.5); Squad_EveryFrame();};
void()  Squad_Anim_Gd_Run4 =[$run4, Squad_Anim_Gd_Run5 ] {Squad_AI_Run(18.0); Squad_EveryFrame();};
void()  Squad_Anim_Gd_Run5 =[$run5, Squad_Anim_Gd_Run6 ] {Squad_AI_Run(21.0); Squad_EveryFrame();};
void()  Squad_Anim_Gd_Run6 =[$run6, Squad_Anim_Gd_Run7 ] {Squad_AI_Run(21.0); Squad_EveryFrame();};
void()  Squad_Anim_Gd_Run7 =[$run7, Squad_Anim_Gd_Run8 ] {Squad_AI_Run(10.5); Squad_EveryFrame();};
void()  Squad_Anim_Gd_Run8 =[$run8, Squad_Anim_Gd_Run9 ] {Squad_AI_Run(10.5); Squad_EveryFrame();};
void()  Squad_Anim_Gd_Run9 =[$run9, Squad_Anim_Gd_Run1 ] {Squad_AI_Run(17.0); Squad_EveryFrame();};



void()  Squad_Anim_Gd_Stuff1 =[$run1, Squad_Anim_Gd_Stuff2 ] {Squad_AI_HuntStuff(27.0); Squad_EveryFrame();};
void()  Squad_Anim_Gd_Stuff2 =[$run2, Squad_Anim_Gd_Stuff3 ] {Squad_AI_HuntStuff(21.0); Squad_EveryFrame();};
void()  Squad_Anim_Gd_Stuff3 =[$run3, Squad_Anim_Gd_Stuff4 ] {Squad_AI_HuntStuff(10.5); Squad_EveryFrame();};
void()  Squad_Anim_Gd_Stuff4 =[$run4, Squad_Anim_Gd_Stuff5 ] {Squad_AI_HuntStuff(18.0); Squad_EveryFrame();};
void()  Squad_Anim_Gd_Stuff5 =[$run5, Squad_Anim_Gd_Stuff6 ] {Squad_AI_HuntStuff(21.0); Squad_EveryFrame();};
void()  Squad_Anim_Gd_Stuff6 =[$run6, Squad_Anim_Gd_Stuff7 ] {Squad_AI_HuntStuff(21.0); Squad_EveryFrame();};
void()  Squad_Anim_Gd_Stuff7 =[$run7, Squad_Anim_Gd_Stuff8 ] {Squad_AI_HuntStuff(10.5); Squad_EveryFrame();};
void()  Squad_Anim_Gd_Stuff8 =[$run8, Squad_Anim_Gd_Stuff9 ] {Squad_AI_HuntStuff(10.5); Squad_EveryFrame();};
void()  Squad_Anim_Gd_Stuff9 =[$run9, Squad_Anim_Gd_Stuff1 ] {Squad_AI_HuntStuff(17.0); Squad_EveryFrame();};



void()  Squad_Anim_Gd_StrafeLeft1 =
  [$lstrafe2, Squad_Anim_Gd_StrafeLeft2 ]
  { Squad_Behavior_Strafe(04); Squad_EveryFrame(); };
void()  Squad_Anim_Gd_StrafeLeft2 =
  [$rstrafe6, Squad_Anim_Gd_StrafeLeft3 ]
  { Squad_Behavior_Strafe(10); Squad_EveryFrame(); };
void()  Squad_Anim_Gd_StrafeLeft3 =
  [$lstrafe2, Squad_Anim_Gd_StrafeLeft4 ]
  { Squad_Behavior_Strafe(10); Squad_EveryFrame(); };
void()  Squad_Anim_Gd_StrafeLeft4 =
  [$rstrafe2, Squad_Anim_Gd_StrafeLeft1 ]
  { Squad_Behavior_Strafe(04); Squad_AI_StrafeFinish();
    Squad_EveryFrame();
  };

void()  Squad_Anim_Gd_StrafeRight1 =
  [$rstrafe2, Squad_Anim_Gd_StrafeRight2 ]
  { Squad_Behavior_Strafe(04); Squad_EveryFrame(); };
void()  Squad_Anim_Gd_StrafeRight2 =
  [$lstrafe2, Squad_Anim_Gd_StrafeRight3 ]
  { Squad_Behavior_Strafe(10); Squad_EveryFrame(); };
void()  Squad_Anim_Gd_StrafeRight3 =
  [$rstrafe6, Squad_Anim_Gd_StrafeRight4 ]
  { Squad_Behavior_Strafe(10); Squad_EveryFrame(); };
void()  Squad_Anim_Gd_StrafeRight4 =
  [$lstrafe2, Squad_Anim_Gd_StrafeRight1 ]
  { Squad_Behavior_Strafe(04); Squad_AI_StrafeFinish();
    Squad_EveryFrame();
  };


// Squad_Anim_Gd_Die - animations to die with gun active, sitting
//
//
//
void() Squad_Anim_Gd_DieA1 =
{ self.nextthink  = time + 0.06;

  // update frame
  local float f_frame;
  f_frame = self.frame + 1;
  self.frame      = self.frame + 1;
  if (f_frame > $deatha10 )
    self.frame = $deatha10;
  else
    self.frame = f_frame;

  // do some thinking
  if (f_frame == $deatha3 )
    { //self.ammo_shells = 2;self.ammo_nails = 2;
      //self.ammo_cells = 2;
      DropBackpack();
    }
  else
  if (f_frame == $deatha10 )
    { Squad_SetPosture(self, SQUAD_POSTURE_LAY);
      Squad_MemberDeactivate();
    }
};



void() Squad_Anim_Gd_DieB1 =
{ self.nextthink  = time + 0.06;

  // update frame
  local float f_frame;
  f_frame = self.frame + 1;
  self.frame      = self.frame + 1;
  if (f_frame > $deathb11 )
    self.frame = $deathb11;
  else
    self.frame = f_frame;

  // do some thinking
  if (f_frame == $deathb3 )
    { ai_back(4);
      //self.ammo_shells = 2;self.ammo_nails = 2;
      //self.ammo_cells = 2;
      DropBackpack();
    }
  else
  if (f_frame == $deathb11 )
    { Squad_SetPosture(self, SQUAD_POSTURE_LAY);
      Squad_MemberDeactivate();
    }
};


void() Squad_Anim_Gd_DieC1 =
{ self.nextthink  = time + 0.06;

  // update frame
  local float f_frame;
  f_frame = self.frame + 1;
  self.frame      = self.frame + 1;
  if (f_frame > $deathc12 )
    self.frame = $deathc12;
  else
    self.frame = f_frame;

  // do some thinking
  if (f_frame == $deathc3 )
    { ai_back(4);
      //self.ammo_shells = 2;self.ammo_nails = 2;
      //self.ammo_cells = 2;
      DropBackpack();
    }
  else
  if (f_frame == $deathc12 )
    { Squad_SetPosture(self, SQUAD_POSTURE_LAY);
      Squad_MemberDeactivate();
    }
};



void() Squad_Anim_Gd_DieD1 =
{ self.nextthink  = time + 0.06;

  // update frame
  local float f_frame;
  f_frame = self.frame + 1;
  self.frame      = self.frame + 1;
  if (f_frame > $deathd9 )
    self.frame = $deathd9;
  else
    self.frame = f_frame;

  // do some thinking
  if (f_frame == $deathd3 )
    { ai_back(4);
      //self.ammo_shells = 2;self.ammo_nails = 2;
      //self.ammo_cells = 2;
      DropBackpack();
    }
  else
  if (f_frame == $deathd9 )
    { Squad_SetPosture(self, SQUAD_POSTURE_LAY);
      Squad_MemberDeactivate();
    }
};



void() Squad_Anim_Gd_PainA1 =
{ self.nextthink  = time + 0.1;

  // update frame
  local float f_frame;
  f_frame = self.frame + 1;
  self.frame      = self.frame + 1;
  if (f_frame > $paina5 )
    Squad_AI_FinishedPain();
  else
    self.frame = f_frame;

  // do some thinking
  Squad_EveryFrame();
  // adjust yaw
  ChangeYaw();

  if (f_frame == $paina3 )
    { ai_pain(1);
      // ignore pain if target is visible
      Squad_AI_NeedIgnorePain();
    }
};


void() Squad_Anim_Gd_PainB1 =
{ self.nextthink  = time + 0.1;

  // update frame
  local float f_frame;
  f_frame = self.frame + 1;
  self.frame      = self.frame + 1;
  if (f_frame > $painb5 )
    Squad_AI_FinishedPain();
  else
    self.frame = f_frame;

  // do some thinking
  Squad_EveryFrame();
  // adjust yaw
  ChangeYaw();

  if (f_frame == $painb3 )
    { ai_pain(1);
      // ignore pain if target is visible
      Squad_AI_NeedIgnorePain();
    }
};


void() Squad_Anim_Gd_PainC1 =
{ self.nextthink  = time + 0.1;

  // update frame
  local float f_frame;
  f_frame = self.frame + 1;
  self.frame      = self.frame + 1;
  if (f_frame > $painc7 )
    Squad_AI_FinishedPain();
  else
    self.frame = f_frame;

  // do some thinking
  Squad_EveryFrame();
  // adjust yaw
  ChangeYaw();

  if (f_frame == $painc3 )
    { ai_pain(1);
      // ignore pain if target is visible
      Squad_AI_NeedIgnorePain();
    }
};


void() Squad_Anim_Gd_PainD1 =
{ self.nextthink  = time + 0.1;

  // update frame
  local float f_frame;
  f_frame = self.frame + 1;
  self.frame      = self.frame + 1;
  if (f_frame > $paind5 )
    Squad_AI_FinishedPain();
  else
    self.frame = f_frame;

  // do some thinking
  Squad_EveryFrame();
  // adjust yaw
  ChangeYaw();

  if (f_frame == $paind3 )
    { ai_pain(1);
      // ignore pain if target is visible
      Squad_AI_NeedIgnorePain();
    }
};



// Squad_Anim_Gd_AttackMeleeUseGun1 - animations to attack using gun
//
//
//
void()  Squad_Anim_Gd_AttackMeleeUseGun1 =
{ self.nextthink  = time + 0.06;

  // update frame
  local float f_frame;
  f_frame = self.frame + 1;
  self.frame      = self.frame + 1;
  if (f_frame > $melee10 )
    Squad_Anim_AttackMelee();
  else
    self.frame = f_frame;

  // do some thinking
  ai_face();
  Squad_EveryFrame(); Squad_AI_EveryAttack(0);

  // special frames
  if ((f_frame == $melee3  ) ||
      (f_frame == $melee10 )
     )
    { // step forward and ...
      Squad_Behavior_Move(12.0);
      // ... attack enemy
      local float fDistance;
      fDistance = vlen(self.origin - self.enemy.origin);
      if (fDistance < 90)
        { local float fDamage;
	  fDamage = 10 + 5*random();
	  T_Damage (self.enemy, self, self, fDamage);
        }
      sound (self, CHAN_WEAPON, "weapons/slash.wav", 1, ATTN_NORM);
    }
};


void()  Squad_Anim_Gd_AttackMeleeApproach1 =
  [$run1, Squad_Anim_Gd_AttackMeleeApproach2 ]
  {Squad_AI_Assault(27.0); Squad_EveryFrame(); Squad_AI_EveryAttack(0); };
void()  Squad_Anim_Gd_AttackMeleeApproach2 =
  [$run2, Squad_Anim_Gd_AttackMeleeApproach3 ]
  {Squad_AI_Assault(21.0); Squad_EveryFrame(); Squad_AI_EveryAttack(0); };
void()  Squad_Anim_Gd_AttackMeleeApproach3 =
  [$run3, Squad_Anim_Gd_AttackMeleeApproach4 ]
  {Squad_AI_Assault(10.5); Squad_EveryFrame(); Squad_AI_EveryAttack(0); };
void()  Squad_Anim_Gd_AttackMeleeApproach4 =
  [$run4, Squad_Anim_Gd_AttackMeleeApproach5 ]
  {Squad_AI_Assault(18.0); Squad_EveryFrame(); Squad_AI_EveryAttack(0); };
void()  Squad_Anim_Gd_AttackMeleeApproach5 =
  [$run5, Squad_Anim_Gd_AttackMeleeApproach6 ]
  {Squad_AI_Assault(21.0); Squad_EveryFrame(); Squad_AI_EveryAttack(0); };
void()  Squad_Anim_Gd_AttackMeleeApproach6 =
  [$run6, Squad_Anim_Gd_AttackMeleeApproach7 ]
  {Squad_AI_Assault(21.0); Squad_EveryFrame(); Squad_AI_EveryAttack(0); };
void()  Squad_Anim_Gd_AttackMeleeApproach7 =
  [$run7, Squad_Anim_Gd_AttackMeleeApproach8 ]
  {Squad_AI_Assault(10.5); Squad_EveryFrame(); Squad_AI_EveryAttack(0); };
void()  Squad_Anim_Gd_AttackMeleeApproach8 =
  [$run8, Squad_Anim_Gd_AttackMeleeApproach9 ]
  {Squad_AI_Assault(10.5); Squad_EveryFrame(); Squad_AI_EveryAttack(0); };
void()  Squad_Anim_Gd_AttackMeleeApproach9 =
  [$run9, Squad_Anim_Attack ]
  {Squad_AI_Assault(17.0); Squad_EveryFrame(); Squad_AI_EveryAttack(0); };



// Squad_Anim_Gd_AttackMachinegun - animations for attacking using hand gun;
//                                  take into account postures; most of the
//                                  time, continues previous animations
//
void()  Squad_Anim_Gd_AttackMachinegun =
{ self.nextthink = time + 0.03;
  local float r;
  local float r;
  r = random();
  if (r < 0.8)
  { // try to continue previous animation, else, fall thru
    if ((self.frame == $drawa7 ) || (self.frame == $firea8 ))
      { self.think = Squad_Anim_Gd_AttackMachineGunStandingA1;
        return;
      }
    else
    if ((self.frame == $drawb9 ) || (self.frame == $fireb2 ))
      { self.think = Squad_Anim_Gd_AttackMachineGunStandingB1;
        return;
      }
    else
    if ((self.frame == $drawc9 ) || (self.frame == $firec13 ))
      { self.think = Squad_Anim_Gd_AttackMachineGunSittingC1;
        return;
      }
  }
  // process posture
  if (Squad_GetPosture(self) == SQUAD_POSTURE_STAND)
    { r = 2 * random();
      if (r < 0.5)
        { self.think = Squad_Anim_Gd_AttackMachineGunStandingA1;
          self.frame = $firea1;
        }
      else
        { self.think = Squad_Anim_Gd_AttackMachineGunStandingB1;
        }
    }
  else // sitting
    { // continue sitting
      self.think = Squad_Anim_Gd_AttackMachineGunSittingC1;
      self.frame = $firec1;
    }
};



// Squad_Anim_Gd_AttackMachineGunStandingXY - animations for attacking using
//                                      machine gun while standing
//
//
void () Squad_Anim_Gd_AttackMachineGunStandingA1 =
{ self.nextthink  = time + 0.08;

  // update frame
  local float f_frame;
  f_frame = self.frame + 1;
  self.frame      = self.frame + 1;
  if (f_frame > $firea8 )
    Squad_Anim_Attack();
  else
    self.frame = f_frame;

  // do some thinking
  ai_face();
  Squad_EveryFrame();
  Squad_AI_EveryAttack(0);

  if ((f_frame == $firea1 ) ||
      (f_frame == $firea3 ) ||
      (f_frame == $firea5 ) ||
      (f_frame == $firea7 )
     )
    { Squad_AI_AttackSomeMachinegun();
    }

  if (Squad_AI_GetReloadUrgency(self) == SQUAD_RELOAD_IMMEDIATE)
    Squad_Anim_Attack();
};


void () Squad_Anim_Gd_AttackMachineGunStandingB1 =
  [ $fireb1, Squad_Anim_Gd_AttackHandgunStandingB2 ]
  { Squad_SetPosture(self, SQUAD_POSTURE_STAND);
    Squad_AI_AttackSomeMachinegun();
    ai_face(); Squad_EveryFrame(); Squad_AI_EveryAttack(0);
    self.nextthink  = time + 0.08;
  };
void () Squad_Anim_Gd_AttackHandgunStandingB2 =
  [ $fireb2, Squad_Anim_Gd_AttackMachineGunStandingB3 ]
  { ai_face(); Squad_EveryFrame();
    if (Squad_AI_GetReloadUrgency(self) == SQUAD_RELOAD_IMMEDIATE)
      Squad_Anim_Attack();
  };
void () Squad_Anim_Gd_AttackMachineGunStandingB3 =
  [ $fireb1, Squad_Anim_Gd_AttackHandgunStandingB4 ]
  { Squad_AI_AttackSomeMachinegun();
    ai_face(); Squad_EveryFrame(); Squad_AI_EveryAttack(0);
    self.nextthink  = time + 0.08;
  };
void () Squad_Anim_Gd_AttackHandgunStandingB4 =
  [ $fireb2, Squad_Anim_Gd_AttackMachineGunStandingB5 ]
  { ai_face(); Squad_EveryFrame();
    self.nextthink  = time + 0.08;
    if (Squad_AI_GetReloadUrgency(self) == SQUAD_RELOAD_IMMEDIATE)
      Squad_Anim_Attack();
  };
void () Squad_Anim_Gd_AttackMachineGunStandingB5 =
  [ $fireb1, Squad_Anim_Gd_AttackHandgunStandingB6 ]
  { Squad_AI_AttackSomeMachinegun();
    ai_face(); Squad_EveryFrame(); Squad_AI_EveryAttack(0);
    self.nextthink  = time + 0.08;
  };
void () Squad_Anim_Gd_AttackHandgunStandingB6 =
  [ $fireb2, Squad_Anim_Attack ]
  { ai_face(); Squad_EveryFrame();
    self.nextthink  = time + 0.08;
  };


void () Squad_Anim_Gd_AttackMachineGunSittingC1 =
{ self.nextthink  = time + 0.08;

  // update frame
  local float f_frame;
  f_frame = self.frame + 1;
  self.frame      = self.frame + 1;
  if (f_frame > $firec13 )
    Squad_Anim_Attack();
  else
    self.frame = f_frame;

  // do some thinking
  ai_face();
  Squad_EveryFrame();
  Squad_AI_EveryAttack(0);

  if ((f_frame == $firec1  ) ||
      (f_frame == $firec3  ) ||
      (f_frame == $firec5  ) ||
      (f_frame == $firec7  ) ||
      (f_frame == $firec9  ) ||
      (f_frame == $firec11 ) ||
      (f_frame == $firec13 )
     )
    { Squad_AI_AttackSomeMachinegun();
    }

  if (Squad_AI_GetReloadUrgency(self) == SQUAD_RELOAD_IMMEDIATE)
    Squad_Anim_Attack();
};


void () Squad_Anim_Gd_AttackHandGrenade1 =
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
  if (f_frame == $grenade11 )
    { Squad_AI_AttackHandGrenade();
    }
};






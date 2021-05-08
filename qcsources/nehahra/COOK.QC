Void function monster_cook();
{
  if (deathmatch) {
    remove(self);
    exit;
    }
  total_monsters = total_monsters + 1;
  precache_model("progs/cook.mdl");
  precache_model("progs/h_ogre.mdl");
  precache_sound("ogre/ogdrag.wav");
  precache_sound("ogre/ogdth.wav");
  precache_sound("ogre/ogidle.wav");
  precache_sound("ogre/ogidle2.wav");
  precache_sound("ogre/ogpain1.wav");
  precache_sound("ogre/ogwake.wav");
  precache_sound("cook/comm1.wav");
  precache_sound("cook/comm2.wav");
  precache_sound("cook/comm3.wav");
  precache_sound("cook/comm4.wav");
  precache_sound("cook/comm5.wav");
  precache_sound("cook/daddy.wav");
  precache_sound("cook/mademe.wav");
  precache_sound("cook/listen.wav");
  precache_sound("cook/goway.wav");
  precache_sound("cook/you.wav");
  precache_sound("cook/whatu.wav");
  precache_sound("cook/idiot.wav");
  precache_sound("cook/moron.wav");
  precache_sound("cook/cannot.wav");
  precache_sound("cook/skull.wav");
  precache_sound("cook/skull2.wav");
  precache_sound("cook/makemad.wav");
  precache_sound("cook/pansiz1.wav");
  precache_sound("cook/pansiz2.wav");
  precache_sound("cook/ping1.wav");
  precache_sound("cook/ping2.wav");
  precache_sound("cook/pong1.wav");
  precache_sound("cook/dpong.wav");
  precache_sound("cook/panup.wav");
  precache_sound("cook/pity01.wav");
  precache_sound("knight/sword1.wav");
  if (!(self.brain & NAVLOGIC)) {
    self.brain = self.brain | NAVLOGIC;
    }
  self.solid = SOLID_SLIDEBOX;
  self.movetype = MOVETYPE_STEP;
  setmodel(self, "progs/cook.mdl");
  setsize(self, VEC_HULL2_MIN, VEC_HULL2_MAX);
  if (!(self.health)) {
    self.health = 280;
    }
  self.cnt = 0;
  self.aflag = 0;
  self.button0 = 90;
  self.th_stand = cook_control1;
  self.th_walk = cook_nowalk;
  self.th_run = cook_run1;
  self.th_die = cook_die;
  self.th_melee = cook_melee;
  self.th_pain = cook_pain;
  self.th_special = cook_notice;
  self.th_wins = cook_wins;
  walkmonster_start();
}

Void function cook_nowalk();
{
  self.goalentity = world;
  self.th_stand();
}

Void function cook_think();
var
 client : Object;
{
  if (self.enemy == world) {
    client = find(world, classname, "player");
    if (client != world) {
      self.enemy = client;
      }
    else {
      exit;
      }
    }
  if (ai_checksmalldist()) {
    self.th_special();
    }
}

Void function cook_control1();
var
 num : Real;
{
  sound(self, CHAN_VOICE, "cook/pansiz1.wav", 1, ATTN_IDLE);
  num = random();
  if (num < 0.5) {
    cook_cook();
    exit;
    }
  if (num < 0.8) {
    cook_oshake();
    exit;
    }
  cook_flip1();
}

Void function cook_cook();
{
  if (self.walkframe >= 8) {
    self.walkframe = 0;
    cook_control1();
    exit;
    }
  #0 cook_cook;
  self.frame = 0 + self.walkframe;
  self.walkframe = self.walkframe + 1;
  cook_think();
}

Void function cook_flip1();
{
  if (self.walkframe >= 11) {
    self.walkframe = 0;
    cook_control1();
    exit;
    }
  #64 cook_flip1;
  self.frame = 18 + self.walkframe;
  self.walkframe = self.walkframe + 1;
}

Void function cook_control2();
var
 num : Real;
{
  ai_face();
  cook_checkcooks();
  if (self.walkframe >= 21) {
    self.walkframe = 0;
    if (visible(self.enemy)) {
      if (self.aflag == 0) {
        if (random() > 0.4) {
          self.cnt = self.cnt + 1;
          if(cook_WAVS()) {
            #34 cook_run1;
            exit;
            }
          self.aflag = 444;
          }
        else {
          if (!ai_checksmalldist()) {
            self.goalentity = self.enemy;
            cook_scoot1();
            exit;
            }
          }
        }
      else {
        if (self.aflag == 444) {
          self.aflag = 0;
          }
        }
      }
    }
  #34 cook_control2;
  num = self.walkframe;
  if (num >= 7) {
    num = num - 7;
    }
  if (num >= 7) {
    num = num - 7;
    }
  self.frame = 34 + num;
  self.walkframe = self.walkframe + 1;
  if (self.impulse != 0) {
    exit;
    }
  if (self.aflag == 444) {
    if (self.skin == 0) {
      self.skin = 1;
      exit;
      }
    }
  self.skin = 0;
}

Void function cook_checkcooks();
var
 cook : Object;
{
  cook = find(world, classname, "monster_cook");
  while (cook) {
    if (cook.health > 0 && cook.cnt > 8 && cook.enemy != world) {
      if (visible(cook)) {
        self.cnt = 10;
        }
      }
    cook = find(cook, classname, "monster_cook");
    }
}

Void function cook_wins();
{
  if (self.impulse == 0) {
    if (self.sounds == 1) {
      sound(self, CHAN_WEAPON, "cook/daddy.wav", 1, ATTN_IDLE);
      }
    else {
      if (self.sounds == 2) {
        sound(self, CHAN_WEAPON, "cook/cannot.wav", 1, ATTN_IDLE);
        }
      else {
        if (self.sounds == 3) {
          sound(self, CHAN_WEAPON, "cook/mademe.wav", 1, ATTN_IDLE);
          }
        else {
          sound(self, CHAN_WEAPON, "cook/pity01.wav", 1, ATTN_IDLE);
          }
        }
      }
    }
  cook_stand();
}

Void function cook_stand();
{
  if (self.walkframe >= 7) {
    self.walkframe = 0;
    }
  #34 cook_stand;
  self.frame = 34 + self.walkframe;
  self.walkframe = self.walkframe + 1;
  ai_stand();
}

Void function cook_shake();
{
  if (self.walkframe >= 6) {
    self.walkframe = 0;
    cook_control1();
    exit;
    }
  #8 cook_shake;
  self.frame = 8 + self.walkframe;
  self.walkframe = self.walkframe + 1;
}

Void function cook_oshake();
{
  #14 cook_oshake2;
}

Void function cook_oshake2();
{
  if (random() < 0.5) {
    #15 cook_oshake;
    sound(self, CHAN_WEAPON, "cook/pansiz2.wav", 1, ATTN_IDLE);
    exit;
    }
  #15 cook_oshake3;
}

Void function cook_oshake3();
{
  #16 cook_oshake4;
}

Void function cook_oshake4();
var
 num : Real;
{
  num = random();
  if (num < 0.4) {
    #17 cook_oshake3;
    exit;
    }
  if (num < 0.7) {
    #17 cook_oshake;
    exit;
    }
  #17 cook_control1;
}

Void function cook_run1();
{
  if (borkfactor1()) {
    exit;
    }
  #41 cook_run2;
  ai_run(MOVETYPE_FLYMISSILE);
  if (random() < 0.2) {
    sound(self, CHAN_VOICE, "ogre/ogidle2.wav", 1, ATTN_IDLE);
    }
}

Void function cook_run2();
{
  #42 cook_run3;
  ai_run(12);
}

Void function cook_run3();
{
  #43 cook_run4;
  ai_run(FL_CLIENT);
}

Void function cook_run4();
{
  #44 cook_run5;
  ai_run(22);
}

Void function cook_run5();
{
  #45 cook_run6;
  ai_run(FL_INWATER);
  if (!(visible(self.enemy))) {
    if (random() < 0.1) {
      sound(self, CHAN_VOICE, "ogre/ogidle2.wav", 1, ATTN_IDLE);
      }
    }
}

Void function cook_run6();
{
  #46 cook_run7;
  ai_run(MOVETYPE_STEP);
}

Void function cook_run7();
{
  #47 cook_run8;
  ai_run(13);
}

Void function cook_run8();
{
  #48 cook_run1;
  ai_run(24);
}

Void function cook_scoot1();
{
  #41 cook_scoot2;
  movetogoal(MOVETYPE_FLYMISSILE);
  if (random() < 0.2) {
    sound(self, CHAN_VOICE, "ogre/ogidle2.wav", 1, ATTN_IDLE);
    }
}

Void function cook_scoot2();
{
  #42 cook_scoot3;
  movetogoal(12);
}

Void function cook_scoot3();
{
  #43 cook_scoot4;
  movetogoal(FL_CLIENT);
}

Void function cook_scoot4();
{
  #44 cook_scoot5;
  movetogoal(22);
}

Void function cook_scoot5();
{
  #45 cook_scoot6;
  movetogoal(FL_INWATER);
}

Void function cook_scoot6();
{
  #46 cook_scoot7;
  movetogoal(MOVETYPE_STEP);
}

Void function cook_scoot7();
{
  #47 cook_scoot8;
  movetogoal(13);
}

Void function cook_scoot8();
{
  #48 cook_control2;
  movetogoal(24);
}

Void function cook_notice();
{
  #29 cook_notice2;
  ai_face();
  self.th_stand = cook_stand;
}

Void function cook_notice2();
{
  #30 cook_notice3;
  ai_face();
  sound(self, CHAN_VOICE, "cook/panup.wav", 1, ATTN_IDLE);
}

Void function cook_notice3();
{
  #31 cook_notice4;
  ai_face();
}

Void function cook_notice4();
{
  #32 cook_notice5;
  ai_face();
}

Void function cook_notice5();
{
  self.cnt = 0;
  self.aflag = 0;
  #33 cook_control2;
}

Void function cook_pain();
{
  if (self.pain_finished > time) {
    exit;
    }
  sound(self, CHAN_VOICE, "ogre/ogpain1.wav", 1, ATTN_IDLE);
  self.pain_finished = time + 0.9;
  if (self.th_stand != cook_stand) {
    self.th_stand = cook_stand;
    }
  if (random() < 0.5) {
    #62 cook_paina1;
    }
  else {
    #65 cook_painb1;
    }
}

Void function cook_paina1();
{
  #63 cook_paina2;
}

Void function cook_paina2();
{
  #64 cook_run1;
}

Void function cook_painb1();
{
  #66 cook_painb2;
}

Void function cook_painb2();
{
  #67 cook_painb3;
}

Void function cook_painb3();
{
  #68 cook_painb4;
}

Void function cook_painb4();
{
  #69 cook_painb5;
}

Void function cook_painb5();
{
  #70 cook_run1;
}

Void function cook_die();
{
  if (self.health < -80) {
    sound(self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
    ThrowHead("progs/h_ogre.mdl", self.health);
    ThrowGib("progs/gib3.mdl", self.health);
    ThrowGib("progs/gib3.mdl", self.health);
    ThrowGib("progs/gib3.mdl", self.health);
    exit;
    }
  sound(self, CHAN_VOICE, "ogre/ogdth.wav", 1, ATTN_NORM);
  #71 cook_die2;
}

Void function cook_die2();
{
  #72 cook_die3;
}

Void function cook_die3();
{
  #73 cook_die4;
  self.solid = SOLID_NOT;
}

Void function cook_die4();
{
  #74 cook_die5;
}

Void function cook_die5();
{
  #75 cook_die6;
}

Void function cook_die6();
{
  #76 cook_die7;
}

Void function cook_die7();
{
  #77 corpse_think;
}

Void function cook_melee();
{
  self.walkframe = 0;
  if (random() < 0.4 && self.nojump == 0) {
    ai2_jump(self.angles, 225, [0 0 250]);
    }
  if (random() < 0.5) {
    #49 cook_ping;
    }
  else {
    #54 cook_pong;
    }
}

Void function cook_ping();
{
  #50 cook_ping2;
  ai_charge(8);
  sound(self, CHAN_WEAPON, "knight/sword1.wav", 1, ATTN_IDLE);
}

Void function cook_ping2();
{
  #51 cook_ping3;
  ai_charge(8);
}

Void function cook_ping3();
{
  #52 cook_ping4;
  ai_charge(8);
}

Void function cook_ping4();
{
  #53 cook_ping5;
  ai_charge(8);
  ai_melee();
}

Void function cook_ping5();
{
  #52 cook_run1;
}

Void function cook_pong();
{
  if (self.walkframe >= 7) {
    self.walkframe = 0;
    cook_run1();
    exit;
    }
  #55 cook_pong;
  self.frame = 55 + self.walkframe;
  self.walkframe = self.walkframe + 1;
  ai_charge(10);
  if (self.walkframe == 1 || self.walkframe == 4) {
    sound(self, CHAN_WEAPON, "knight/sword1.wav", 1, ATTN_IDLE);
    }
  if (self.walkframe == 3 || self.walkframe == 6) {
    ai_melee();
    }
}

Void function cook_WAVS();
{
  if (self.impulse != 0) {
    return 0;
    exit;
    }
  if (self.sounds == 1) {
    if (cook_WAVS2()) {
      return 1;
      }
    else {
      return 0;
      }
    exit;
    }
  if (self.sounds == 2) {
    if (cook_WAVS3()) {
      return 1;
      }
    else {
      return 0;
      }
    exit;
    }
  if (self.sounds == 3) {
    if (cook_WAVS4()) {
      return 1;
      }
    else {
      return 0;
      }
    exit;
    }
  if (self.cnt == 1) {
    sound(self, CHAN_WEAPON, "cook/comm3.wav", 1, ATTN_IDLE);
    }
  if (self.cnt == 2) {
    sound(self, CHAN_WEAPON, "cook/comm1.wav", 1, ATTN_IDLE);
    }
  if (self.cnt == 3) {
    sound(self, CHAN_WEAPON, "cook/comm2.wav", 1, ATTN_IDLE);
    }
  if (self.cnt == 4) {
    sound(self, CHAN_WEAPON, "ogre/ogidle2.wav", 1, ATTN_IDLE);
    }
  if (self.cnt == 5) {
    sound(self, CHAN_WEAPON, "cook/comm4.wav", 1, ATTN_IDLE);
    }
  if (self.cnt == 6) {
    sound(self, CHAN_WEAPON, "cook/makemad.wav", 1, ATTN_IDLE);
    ai2_jump(self.angles, 200, [0 0 225]);
    }
  if (self.cnt == 7) {
    sound(self, CHAN_WEAPON, "ogre/ogwake.wav", 1, ATTN_IDLE);
    }
  if (self.cnt == 8) {
    sound(self, CHAN_WEAPON, "cook/comm5.wav", 1, ATTN_IDLE);
    }
  if (self.cnt > 8) {
    return 1;
    exit;
    }
  return 0;
}

Void function cook_WAVS2();
{
  if (self.impulse != 0) {
    return 0;
    exit;
    }
  if (self.cnt == 1) {
    sound(self, CHAN_WEAPON, "cook/whatu.wav", 1, ATTN_IDLE);
    }
  if (self.cnt == 2) {
    sound(self, CHAN_WEAPON, "cook/you.wav", 1, ATTN_IDLE);
    }
  if (self.cnt == 3) {
    sound(self, CHAN_WEAPON, "cook/moron.wav", 1, ATTN_IDLE);
    }
  if (self.cnt == 4) {
    sound(self, CHAN_WEAPON, "ogre/ogidle.wav", 1, ATTN_IDLE);
    }
  if (self.cnt == 5) {
    sound(self, CHAN_WEAPON, "cook/skull.wav", 1, ATTN_IDLE);
    }
  if (self.cnt == 6) {
    sound(self, CHAN_WEAPON, "cook/makemad.wav", 1, ATTN_IDLE);
    ai2_jump(self.angles, 200, [0 0 240]);
    }
  if (self.cnt == 7) {
    sound(self, CHAN_WEAPON, "ogre/ogwake.wav", 1, ATTN_IDLE);
    }
  if (self.cnt == 8) {
    sound(self, CHAN_WEAPON, "cook/skull2.wav", 1, ATTN_IDLE);
    }
  if (self.cnt > 8) {
    return 1;
    exit;
    }
  return 0;
}

Void function cook_WAVS3();
{
  if (self.impulse != 0) {
    return 0;
    exit;
    }
  if (self.cnt == 1) {
    sound(self, CHAN_WEAPON, "cook/goway.wav", 1, ATTN_IDLE);
    }
  if (self.cnt == 2) {
    sound(self, CHAN_WEAPON, "cook/comm2.wav", 1, ATTN_IDLE);
    }
  if (self.cnt == 3) {
    sound(self, CHAN_WEAPON, "cook/you.wav", 1, ATTN_IDLE);
    }
  if (self.cnt == 4) {
    sound(self, CHAN_WEAPON, "cook/idiot.wav", 1, ATTN_IDLE);
    }
  if (self.cnt == 5) {
    sound(self, CHAN_WEAPON, "cook/listen.wav", 1, ATTN_IDLE);
    }
  if (self.cnt == 6) {
    sound(self, CHAN_WEAPON, "cook/comm5.wav", 1, ATTN_IDLE);
    ai2_jump(self.angles, 200, [0 0 230]);
    }
  if (self.cnt == 7) {
    sound(self, CHAN_WEAPON, "ogre/ogwake.wav", 1, ATTN_IDLE);
    }
  if (self.cnt == 8) {
    sound(self, CHAN_WEAPON, "cook/moron.wav", 1, ATTN_IDLE);
    }
  if (self.cnt > 8) {
    return 1;
    exit;
    }
  return 0;
}

Void function cook_WAVS4();
{
  if (self.impulse != 0) {
    return 0;
    exit;
    }
  if (self.cnt == 1) {
    sound(self, CHAN_WEAPON, "cook/comm3.wav", 1, ATTN_IDLE);
    }
  if (self.cnt == 2) {
    sound(self, CHAN_WEAPON, "cook/idiot.wav", 1, ATTN_IDLE);
    }
  if (self.cnt == 3) {
    sound(self, CHAN_WEAPON, "cook/you.wav", 1, ATTN_IDLE);
    }
  if (self.cnt == 4) {
    sound(self, CHAN_WEAPON, "cook/idiot.wav", 1, ATTN_IDLE);
    }
  if (self.cnt == 5) {
    sound(self, CHAN_WEAPON, "cook/skull2.wav", 1, ATTN_IDLE);
    }
  if (self.cnt == 6) {
    sound(self, CHAN_WEAPON, "cook/makemad.wav", 1, ATTN_IDLE);
    ai2_jump(self.angles, 200, [0 0 230]);
    }
  if (self.cnt == 7) {
    sound(self, CHAN_WEAPON, "ogre/ogwake.wav", 1, ATTN_IDLE);
    }
  if (self.cnt == 8) {
    sound(self, CHAN_WEAPON, "cook/comm1.wav", 1, ATTN_IDLE);
    }
  if (self.cnt > 8) {
    return 1;
    exit;
    }
  return 0;
}


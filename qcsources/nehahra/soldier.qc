Void function army_stand1();
{
  #0 army_stand2;
  ai_stand();
}

Void function army_stand2();
{
  #1 army_stand3;
  ai_stand();
  ai_emnity("monster_qguy", 2000, 0);
}

Void function army_stand3();
{
  #2 army_stand4;
  ai_stand();
}

Void function army_stand4();
{
  #3 army_stand5;
  ai_stand();
}

Void function army_stand5();
{
  #4 army_stand6;
  ai_stand();
}

Void function army_stand6();
{
  #5 army_stand7;
  ai_stand();
}

Void function army_stand7();
{
  #6 army_stand8;
  ai_stand();
}

Void function army_stand8();
{
  if (self.impulse == 10) {
    self.cnt = 0;
    #7 army_lleft1;
    ai_stand();
    exit;
    }
  self.cnt = self.cnt + 1;
  if (self.cnt > 5) {
    if (random() < 0.2) {
      self.cnt = 0;
      if (random() < 0.5) {
        #7 army_lleft1;
        ai_stand();
        exit;
        }
      #7 army_lright1;
      ai_stand();
      exit;
      }
    }
  #7 army_stand1;
  ai_stand();
}

Void function army_lleft1();
{
  #128 army_lleft2;
  ai_stand();
}

Void function army_lleft2();
{
  #129 army_lleft3;
  ai_stand();
}

Void function army_lleft3();
{
  #130 army_lleft4;
  ai_stand();
}

Void function army_lleft4();
{
  #129 army_lleft5;
  ai_stand();
}

Void function army_lleft5();
{
  if (self.impulse == 10) {
    #128 army_lright1;
    ai_stand();
    exit;
    }
  #128 army_stand1;
  ai_stand();
}

Void function army_lright1();
{
  #131 army_lright2;
  ai_stand();
}

Void function army_lright2();
{
  #132 army_lright3;
  ai_stand();
}

Void function army_lright3();
{
  #133 army_lright4;
  ai_stand();
}

Void function army_lright4();
{
  #132 army_lright5;
  ai_stand();
}

Void function army_lright5();
{
  if (self.impulse == 10) {
    self.cnt = self.cnt + 1;
    if (self.cnt < 3) {
      #131 army_lleft1;
      ai_stand();
      exit;
      }
    }
  self.cnt = 0;
  self.impulse = 0;
  #131 army_stand1;
  ai_stand();
  exit;
}

Void function army_walk1();
{
  if (random() < 0.2) {
    sound(self, CHAN_VOICE, "soldier/idle.wav", 1, ATTN_IDLE);
    }
  if (self.objekt && self.objekt.classname == "player") {
    if (ai_checkobjdist(300)) {
      self.walkframe = 0;
      army_boogie();
      exit;
      }
    }
  #90 army_walk2;
  ai_walk(1);
}

Void function army_walk2();
{
  #91 army_walk3;
  ai_walk(1);
}

Void function army_walk3();
{
  #92 army_walk4;
  ai_walk(1);
}

Void function army_walk4();
{
  #93 army_walk5;
  ai_walk(1);
}

Void function army_walk5();
{
  #94 army_walk6;
  ai_walk(FL_SWIM);
}

Void function army_walk6();
{
  #95 army_walk7;
  ai_walk(MOVETYPE_WALK);
}

Void function army_walk7();
{
  #96 army_walk8;
  ai_walk(MOVETYPE_STEP);
  ai_emnity("monster_qguy", 2000, 0);
}

Void function army_walk8();
{
  #97 army_walk9;
  ai_walk(MOVETYPE_STEP);
}

Void function army_walk9();
{
  #98 army_walk10;
  ai_walk(FL_SWIM);
}

Void function army_walk10();
{
  #99 army_walk11;
  ai_walk(FL_SWIM);
}

Void function army_walk11();
{
  #100 army_walk12;
  ai_walk(FL_SWIM);
}

Void function army_walk12();
{
  #101 army_walk13;
  ai_walk(1);
}

Void function army_walk13();
{
  #102 army_walk14;
  ai_walk(0);
}

Void function army_walk14();
{
  #103 army_walk15;
  ai_walk(1);
}

Void function army_walk15();
{
  #104 army_walk16;
  ai_walk(1);
}

Void function army_walk16();
{
  #105 army_walk17;
  ai_walk(1);
}

Void function army_walk17();
{
  #106 army_walk18;
  ai_walk(MOVETYPE_WALK);
}

Void function army_walk18();
{
  #107 army_walk19;
  ai_walk(MOVETYPE_WALK);
}

Void function army_walk19();
{
  #108 army_walk20;
  ai_walk(MOVETYPE_WALK);
}

Void function army_walk20();
{
  #109 army_walk21;
  ai_walk(MOVETYPE_WALK);
}

Void function army_walk21();
{
  #110 army_walk22;
  ai_walk(FL_SWIM);
}

Void function army_walk22();
{
  #111 army_walk23;
  ai_walk(1);
}

Void function army_walk23();
{
  #112 army_walk24;
  ai_walk(1);
}

Void function army_walk24();
{
  #113 army_walk1;
  ai_walk(1);
}

Void function army_onground1();
{
  #114 army_onground2;
  self.cnt = self.cnt + 1;
}

Void function army_onground2();
{
  if (self.cnt > 10) {
    self.cnt = 0;
    self.th_pain = army_pain;
    self.th_die = army_die;
    self.th_run = army_run1;
    #114 army_painb7;
    exit;
    }
  if (random() > 0.9) {
    #115 army_ongdie;
    exit;
    }
  #115 army_onground1;
}

Void function army_ongdie();
{
  if (self.health < -35) {
    army_die();
    exit;
    }
  self.health = 0;
  if (self.flags & FL_ONGROUND) {
    self.flags = self.flags - FL_ONGROUND;
    }
  self.solid = SOLID_NOT;
  if (random() < 0.5 || self.health > 0) {
    #115 army_flop1;
    }
  else {
    #115 army_deth;
    }
}

Void function army_flop1();
{
  #116 army_flop2;
  army_dropbackpack();
}

Void function army_flop2();
{
  #117 army_flop3;
}

Void function army_flop3();
{
  #118 army_flop4;
}

Void function army_flop4();
{
  #119 army_flop5;
}

Void function army_flop5();
{
  #120 army_flop6;
}

Void function army_flop6();
{
  #121 army_flop7;
}

Void function army_flop7();
{
  #122 army_flop8;
}

Void function army_flop8();
{
  #123 army_flop9;
}

Void function army_flop9();
{
  #124 army_flop10;
}

Void function army_flop10();
{
  #124 army_flop11;
}

Void function army_flop11();
{
  #124 corpse_think;
}

Void function army_deth();
{
  #125 army_deth2;
  army_dropbackpack();
}

Void function army_deth2();
{
  #126 army_deth3;
}

Void function army_deth3();
{
  #127 corpse_think;
}

Void function army_run1();
{
  if (borkfactor1()) {
    exit;
    }
  if (random() < 0.2) {
    sound(self, CHAN_VOICE, "soldier/idle.wav", 1, ATTN_IDLE);
    }
  if (self.classname != "monster_army3") {
    if (visible(self.enemy)) {
      if (random() < 0.7) {
        self.attack_finished = time + 0.8;
        army_runshot1();
        exit;
        }
      }
    }
  #73 army_run2;
  ai3_run(MOVETYPE_BOUNCEMISSILE);
}

Void function army_run2();
{
  #74 army_run3;
  ai3_run(15);
}

Void function army_run3();
{
  #75 army_run4;
  ai3_run(MOVETYPE_BOUNCE);
}

Void function army_run4();
{
  #76 army_run5;
  ai3_run(MOVETYPE_BOUNCE);
}

Void function army_run5();
{
  #77 army_run6;
  ai3_run(FL_CLIENT);
}

Void function army_run6();
{
  #78 army_run7;
  ai3_run(15);
}

Void function army_run7();
{
  #79 army_run8;
  ai3_run(MOVETYPE_BOUNCE);
}

Void function army_run8();
{
  #80 army_run1;
  ai3_run(FL_CLIENT);
}

Void function army_boogie();
{
  if (self.walkframe >= 8) {
    self.walkframe = 0;
    if (self.objekt) {
      if (!(ai_checkobjdist(200))) {
        #73 army_walk1;
        exit;
        }
      }
    }
  #73 army_boogie;
  self.frame = 73 + self.walkframe;
  self.walkframe = self.walkframe + 1;
  if (self.walkframe == 5) {
    ai_objledge();
    }
  if (random() < 0.5) {
    ai_walk(12);
    }
  else {
    ai_walk(17);
    }
}

Void function army_atk1();
var
 megadeth : Vector;
 diff : Real;
{
  if (borkfactor1()) {
    exit;
    }
  #81 army_atk2;
  ai_face();
  ai_threats();
  megadeth = self.enemy.origin - self.origin;
  if (vlen(megadeth) > 120) {
    self.impulse = 11;
    }
}

Void function army_atk2();
var
 diff : Real;
{
  #82 army_atk3;
  ai_face();
  if (self.impulse == 11) {
    if (self.classname != "monster_army2") {
      exit;
      }
    diff = self.enemy.origin_z - self.origin_z;
    if (self.origin_z < self.enemy.origin_z) {
      if (self.flags & FL_ONGROUND) {
        self.origin_z = self.origin_z + 1;
        self.velocity_z = 300;
        self.velocity = v_forward * -350;
        self.flags = self.flags - FL_ONGROUND;
        exit;
        }
      }
    else {
      if (self.flags & FL_ONGROUND && diff < 120) {
        self.flags = self.flags - FL_ONGROUND;
        self.origin_z = self.origin_z + 1;
        self.velocity_z = 300;
        }
      }
    }
}

Void function army_atk3();
{
  if (self.impulse == 11) {
    if (self.classname == "monster_army2" || self.classname == "monster_army4") {
      if (Mons_consider() || Mons_proxim()) {
        if (random() < 0.2) {
          #80 army_run1;
          ai_face();
          exit;
          }
        }
      }
    }
  #83 army_atk4;
  ai_face();
}

Void function army_atk4();
{
  ai_threats();
  #84 army_atk5;
  ai_face();
  self.cnt = 0;
}

Void function army_atk5();
var
 hmm : Real;
{
  if (self.enemy.health < 1) {
    self.enemy = world;
    self.goalentity = world;
    self.th_stand();
    exit;
    }
  ai_threats();
  if (self.enemy.origin_z > self.origin_z) {
    hmm = self.enemy.origin_z - self.origin_z;
    if (hmm > 250) {
      #134 army_shootup1;
      ai_face();
      exit;
      }
    }
  #85 army_atk6;
  ai_face();
  army_fire();
  self.effects = self.effects | EF_MUZZLEFLASH;
}

Void function army_atk6();
{
  if (self.classname == "monster_army3") {
    self.cnt = self.cnt + 1;
    if (self.cnt < 10) {
      if (random() > 0.1) {
        #84 army_atk5;
        ai_threats();
        exit;
        }
      }
    }
  #86 army_atk7;
  ai_face();
}

Void function army_atk7();
{
  #87 army_atk8;
  ai_face();
  SUB_CheckRefire(army_atk1);
}

Void function army_atk8();
{
  ai_threats();
  #88 army_atk9;
  ai_face();
}

Void function army_atk9();
{
  #89 army_run1;
  ai_face();
  ai_emnity("monster_qguy", 2000, 0);
}

Void function army_shootup1();
{
  #135 army_shootup2;
  ai_face();
  army_fire();
  ai_threats();
  self.effects = self.effects | EF_MUZZLEFLASH;
}

Void function army_shootup2();
{
  if (self.classname == "monster_army3") {
    self.cnt = self.cnt + 1;
    if (self.cnt < 10) {
      if (random() > 0.1) {
        #134 army_shootup1;
        ai_threats();
        exit;
        }
      }
    }
  #136 army_shootup3;
  ai_face();
}

Void function army_shootup3();
{
  #80 army_run1;
  ai3_run(15);
}

Void function army_pain1();
{
  #40 army_pain2;
}

Void function army_pain2();
{
  #41 army_pain3;
}

Void function army_pain3();
{
  #42 army_pain4;
}

Void function army_pain4();
{
  #43 army_pain5;
}

Void function army_pain5();
{
  #44 army_pain6;
}

Void function army_pain6();
{
  #45 army_run1;
  ai_pain(1);
}

Void function army_painb1();
{
  #46 army_painb2;
}

Void function army_painb2();
{
  #47 army_painb3;
  ai_painforward(13);
}

Void function army_painb3();
{
  #48 army_painb4;
  ai_painforward(MOVETYPE_FLYMISSILE);
}

Void function army_painb4();
{
  #49 army_painb5;
}

Void function army_painb5();
{
  #50 army_painb6;
}

Void function army_painb6();
{
  #51 army_painb7;
}

Void function army_painb7();
{
  if (self.health < 10) {
    self.th_pain = army_painb8;
    self.th_die = army_ongdie;
    self.th_run = army_onground1;
    self.cnt = 0;
    #52 army_onground1;
    exit;
    }
  #52 army_painb8;
}

Void function army_painb8();
{
  #53 army_painb9;
}

Void function army_painb9();
{
  #54 army_painb10;
}

Void function army_painb10();
{
  #55 army_painb11;
}

Void function army_painb11();
{
  #56 army_painb12;
}

Void function army_painb12();
{
  #57 army_painb13;
  ai_pain(FL_SWIM);
}

Void function army_painb13();
{
  #58 army_painb14;
}

Void function army_painb14();
{
  if (self.th_pain == army_painb8) {
    self.th_run = army_run1;
    self.th_pain = army_pain;
    self.th_die = army_die;
    }
  #59 army_run1;
}

Void function army_painc1();
{
  #60 army_painc2;
}

Void function army_painc2();
{
  #61 army_painc3;
  ai_pain(1);
}

Void function army_painc3();
{
  #62 army_painc4;
}

Void function army_painc4();
{
  #63 army_painc5;
}

Void function army_painc5();
{
  #64 army_painc6;
  ai_painforward(1);
}

Void function army_painc6();
{
  #65 army_painc7;
  ai_painforward(1);
}

Void function army_painc7();
{
  #66 army_painc8;
}

Void function army_painc8();
{
  #67 army_painc9;
  ai_pain(1);
}

Void function army_painc9();
{
  #68 army_painc10;
  ai_painforward(MOVETYPE_STEP);
}

Void function army_painc10();
{
  #69 army_painc11;
  ai_painforward(MOVETYPE_WALK);
}

Void function army_painc11();
{
  #70 army_painc12;
  ai_painforward(MOVETYPE_TOSS);
}

Void function army_painc12();
{
  #71 army_painc13;
  ai_painforward(FL_CLIENT);
}

Void function army_painc13();
{
  #72 army_run1;
}

Void function army_pain(attacker : Object; damage : Real);
var
 r : Real;
{
  if (self.pain_finished > time) {
    exit;
    }
  r = random();
  if (r < 0.2) {
    self.pain_finished = time + 0.6;
    army_pain1();
    sound(self, CHAN_VOICE, "soldier/pain1.wav", 1, ATTN_NORM);
    }
  else {
    if (r < 0.6) {
      self.pain_finished = time + 1.1;
      army_painb1();
      sound(self, CHAN_VOICE, "soldier/pain2.wav", 1, ATTN_NORM);
      }
    else {
      self.pain_finished = time + 1.1;
      army_painc1();
      sound(self, CHAN_VOICE, "soldier/pain2.wav", 1, ATTN_NORM);
      }
    }
}

Void function army_fire();
var
 dir : Vector;
 en : Object;
 megadeth : Vector;
{
  megadeth = self.enemy.origin - self.origin;
  if (self.impulse == 11) {
    if (self.classname == "monster_army4") {
      if (self.origin_z > self.enemy.origin_z) {
        Mons_fire_grenade();
        ai2_jumpsplash(-200, [0 0 200]);
        }
      else {
        Mons_Fire_rocket();
        ai2_jumpsplash(-200, [0 0 200]);
        }
      exit;
      }
    if (self.classname == "monster_army2") {
      Mons_fire_rocket();
      ai2_jumpsplash(-200, [0 0 200]);
      exit;
      }
    if (self.classname == "monster_army5") {
      Mons_fire_sprocket();
      ai2_jumpsplash(-200, [0 0 200]);
      exit;
      }
    }
  if (self.classname == "monster_army3") {
    Mons_fire_nails();
    ai2_jumpsplash(-200, [0 0 200]);
    }
  else {
    if (skill == 3) {
      Mons_Fire_Shotgun();
      exit;
      }
    ai_face();
    sound(self, CHAN_WEAPON, "soldier/sattck1.wav", 1, ATTN_NORM);
    en = self.enemy;
    dir = en.origin - en.velocity * 0.2;
    dir = normalize(dir - self.origin);
    FireBullets(3, dir, [0.1 0.1 0]);
    }

}

Void function army_die1();
{
  #8 army_die2;
}

Void function army_die2();
{
  #9 army_die3;
}

Void function army_die3();
{
  #10 army_die4;
  army_dropbackpack();
  self.solid = SOLID_NOT;
}

Void function army_die4();
{
  #11 army_die5;
}

Void function army_die5();
{
  #12 army_die6;
}

Void function army_die6();
{
  #13 army_die7;
}

Void function army_die7();
{
  #14 army_die8;
}

Void function army_die8();
{
  #15 army_die9;
}

Void function army_die9();
{
  #16 army_die10;
}

Void function army_die10();
{
  #17 corpse_think;
}

Void function army_cdie1();
{
  #18 army_cdie2;
}

Void function army_cdie2();
{
  #19 army_cdie3;
  ai_back(MOVETYPE_FLY);
}

Void function army_cdie3();
{
  #20 army_cdie4;
  self.solid = SOLID_NOT;
  ai_back(MOVETYPE_STEP);
  army_dropbackpack();
}

Void function army_cdie4();
{
  #21 army_cdie5;
  ai_back(13);
}

Void function army_cdie5();
{
  #22 army_cdie6;
  ai_back(MOVETYPE_WALK);
}

Void function army_cdie6();
{
  #23 army_cdie7;
  ai_back(MOVETYPE_STEP);
}

Void function army_cdie7();
{
  #24 army_cdie8;
}

Void function army_cdie8();
{
  #25 army_cdie9;
}

Void function army_cdie9();
{
  #26 army_cdie10;
}

Void function army_cdie10();
{
  #27 army_cdie11;
}

Void function army_cdie11();
{
  #28 corpse_think;
}

Void function army_die();
{
  if (self.flags & FL_ONGROUND) {
    self.flags = self.flags - FL_ONGROUND;
    }
  if (self.health < -35) {
    if (skill == 0) {
      army_dropbackpack();
      }
    sound(self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
    ThrowHead("progs/h_guard.mdl", self.health);
    ThrowGib("progs/gib1.mdl", self.health);
    ThrowGib("progs/gib2.mdl", self.health);
    ThrowGib("progs/gib3.mdl", self.health);
    exit;
    }
  sound(self, CHAN_VOICE, "soldier/death1.wav", 1, ATTN_NORM);
  dead_stay_dead();
  if (random() < 0.5) {
    army_die1();
    }
  else {
    army_cdie1();
    }
}

Void function army_begin();
{
  self.th_stand = army_stand1;
  self.th_walk = army_walk1;
  if (self.goalentity != world) {
    #0 army_walk1;
    }
  else {
    #0 army_stand1;
    }
}

Void function army_wait();
{
  self.use = army_begin;
  if (self.walkframe >= 8) {
    self.walkframe = 0;
    }
  #64 army_wait;
  self.frame = 0 + self.walkframe;
  self.walkframe = self.walkframe + 1;
}

Void function monster_army2();
{
  monster_army();
}

Void function monster_army3();
{
  monster_army();
  self.skin = 0;
}

Void function monster_army4();
{
  monster_army();
}

Void function monster_army5();
{
  monster_army();
}

Void function army_blahblah();
{
  setsize(self, VEC_HULL_MIN, [16 16 40]);
}

Void function monster_army();
{
  if (deathmatch) {
    remove(self);
    exit;
    }
  total_monsters = total_monsters + 1;
  precache_model("progs/soldier.mdl");
  precache_model("progs/h_guard.mdl");
  precache_model("progs/gib1.mdl");
  precache_model("progs/gib2.mdl");
  precache_model("progs/gib3.mdl");
  precache_sound("soldier/death1.wav");
  precache_sound("soldier/idle.wav");
  precache_sound("soldier/pain1.wav");
  precache_sound("soldier/pain2.wav");
  precache_sound("soldier/sattck1.wav");
  precache_sound("soldier/sight1.wav");
  precache_sound("player/udeath.wav");
  self.impulse = 0;
  self.cnt = 0;
  if (self.spawnflags & FL_GODMODE) {
    self.th_stand = army_cidle1;
    self.th_walk = army_walk1;
    self.th_run = army_crun;
    self.th_pain = army_ouch;
    self.th_missile = army_atk1;
    self.th_die = army_die;
    carnify_soldier();
    exit;
    }
  if (self.targetname == "actor4" || self.targetname == "actor5" || self.targetname == "actor6" || self.targetname == "actor7") {
    self.th_stand = army_wait;
    self.th_walk = army_wait;
    }
  else {
    self.th_stand = army_stand1;
    self.th_walk = army_walk1;
    }
  self.th_run = army_run1;
  self.th_missile = army_atk1;
  self.th_pain = army_pain;
  self.th_die = army_die;
  self.th_runfire = army_runshot1;
  if (self.brain & TRIGGER_SPAWN) {
    self.use = soldier_startt;
    exit;
    }
  carnify_soldier();
}

Void function soldier_startt();
{
  trigger_spawnmonster();
  carnify_soldier();
}

Void function carnify_soldier();
{
  self.solid = SOLID_SLIDEBOX;
  self.movetype = MOVETYPE_STEP;
  setmodel(self, "progs/soldier.mdl");
  setsize(self, VEC_HULL_MIN, [16 16 40]);
  if (!(self.health)) {
    self.health = 42;
    }
  walkmonster_start();
}

Void function army_2normal();
{
  self.th_stand = army_stand1;
  self.th_walk = army_walk1;
  self.th_run = army_run1;
  self.th_missile = army_atk1;
  self.th_pain = army_pain;
  self.th_die = army_die;
}

Void function army_ouch();
{
  army_2normal();
  army_pain();
}

Void function army_crun();
{
  army_2normal();
  army_run1();
}

Void function army_cidle1();
{
  #137 army_cidle2;
  ai_stand();
}

Void function army_cidle2();
{
  #138 army_cidle3;
  ai_stand();
}

Void function army_cidle3();
{
  #139 army_cidle4;
  ai_stand();
}

Void function army_cidle4();
{
  #140 army_cidle5;
  ai_stand();
}

Void function army_cidle5();
{
  #141 army_cidle6;
  ai_stand();
}

Void function army_cidle6();
{
  if (random() < 0.4) {
    if (random() < 0.5) {
      #142 army_look;
      }
    else {
      #142 army_con1;
      }
    exit;
    }
  #142 army_cidle1;
  ai_stand();
}

Void function army_con1();
{
  if (self.walkframe >= 7) {
    self.walkframe = 0;
    army_con2();
    exit;
    }
  #143 army_con1;
  self.frame = 143 + self.walkframe;
  self.walkframe = self.walkframe + 1;
  ai_stand();
}

Void function army_con2();
{
  if (self.walkframe >= 7) {
    self.walkframe = 0;
    army_cidle1();
    exit;
    }
  #143 army_con2;
  self.frame = 149 - self.walkframe;
  self.walkframe = self.walkframe + 1;
  ai_stand();
}

Void function army_look();
{
  if (self.walkframe >= 6) {
    self.walkframe = 0;
    army_look2();
    exit;
    }
  #150 army_look;
  self.frame = 150 + self.walkframe;
  self.walkframe = self.walkframe + 1;
  ai_stand();
}

Void function army_look2();
{
  if (self.walkframe >= 6) {
    self.walkframe = 0;
    army_look3();
    exit;
    }
  #150 army_look2;
  self.frame = 155 - self.walkframe;
  self.walkframe = self.walkframe + 1;
  ai_stand();
}

Void function army_look3();
{
  if (self.walkframe >= 6) {
    self.walkframe = 0;
    army_look4();
    exit;
    }
  #150 army_look3;
  self.frame = 156 + self.walkframe;
  self.walkframe = self.walkframe + 1;
  ai_stand();
}

Void function army_look4();
{
  if (self.walkframe >= 6) {
    self.walkframe = 0;
    army_cidle1();
    exit;
    }
  #150 army_look4;
  self.frame = 161 - self.walkframe;
  self.walkframe = self.walkframe + 1;
  ai_stand();
}

Void function army_dropbackpack();
{
  if (self.classname != "monster_army3") {
    self.ammo_shells = MOVETYPE_FLY;
    }
  else {
    self.ammo_nails = MOVETYPE_NOCLIP;
    }
  if (self.classname == "monster_army2" || self.classname == "monster_army4") {
    self.ammo_rockets = MOVETYPE_WALK;
    }
  DropBackpack();
}

Void function army_runshot1();
{
  if (borkfactor1()) {
    exit;
    }
  #164 army_runshot2;
  if (random() < 0.2) {
    sound(self, CHAN_VOICE, "soldier/idle.wav", 1, ATTN_IDLE);
    }
  if (!ai_threats()) {
    ai_run_slide(10);
    }
  ai_face();
}

Void function army_runshot2();
{
  #165 army_runshot3;
  if (!ai_threats()) {
    ai_run_slide(9);
    }
  ai_face();
}

Void function army_runshot3();
{
  #166 army_runshot4;
  if (!ai_threats()) {
    ai_run_slide(8);
    }
  ai_face();
}

Void function army_runshot4();
{
  #167 army_runshot5;
  if (!ai_threats()) {
    ai_run_slide(8);
    }
  ai_face();
}

Void function army_runshot5();
{
  #168 army_runshot6;
  if (!ai_threats()) {
    ai_run_slide(9);
    }
  army_fire();
  self.effects = self.effects | EF_MUZZLEFLASH;
}

Void function army_runshot6();
{
  #169 army_runshot7;
  if (!ai_threats()) {
    ai_run_slide(10);
    }
  ai_face();
}

Void function army_runshot7();
{
  #170 army_runshot8;
  if (!ai_threats()) {
    ai_run_slide(9);
    }
  ai_face();
}

Void function army_runshot8();
{
  if (self.enemy.health < 1) {
    self.th_stand();
    exit;
    }
  if (ai_threats()) {
    #171 army_runshot1;
    ai_face();
    exit;
    }
  #171 army_run1;
  self.tactic = 0;
  ai_run_slide(9);
  ai_face();
}


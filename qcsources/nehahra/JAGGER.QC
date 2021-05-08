Void function ai_frolic();
var
 num : Real;
 dave : Vector;
 vec : Vector;
 mark : Object;
{
  mark = self.goalentity;
  ai4_face(mark.xtrace);
  if (jagger_checktop()) {
    self.frolic = 0;
    self.boost = 0;
    self.wripple = rint(20 * random());
    self.velocity = [0 0 0];
    self.goalentity = world;
    self.th_stand();
    return 1;
    exit;
    }
  self.frolic = self.frolic + 1;
  if (self.frolic == 2) {
    Jagger_ontop();
    }
  if (self.frolic > 4) {
    self.boost = self.boost + 1;
    self.frolic = 0;
    makevectors(self.angles);
    num = 50;
    dave = [0 0 350];
    vec = self.origin + (v_forward * 80);
    vec = vec + [0 0 150];
    traceline(self.origin, vec, 1, self);
    if (trace_fraction < 1) {
      num = 10;
      dave = [0 0 450];
      vec_x = self.origin_x;
      vec_y = self.origin_y;
      traceline(self.origin, vec, 1, self);
      if (trace_fraction < 1) {
        num = -50;
        vec = self.origin - (v_forward * 80);
        traceline(self.origin, vec, 1, self);
        if (trace_fraction < 1) {
          self.boost = 18;
          }
        }
      }
    if (self.boost > 16) {
      self.frolic = 0;
      self.boost = 0;
      self.wripple = rint(20 * random());
      self.velocity = [0 0 0];
      self.goalentity = world;
      self.th_stand();
      return 1;
      exit;
      }
    if (self.flags & FL_ONGROUND) {
      self.flags = self.flags - FL_ONGROUND;
      }
    self.origin_z = self.origin_z + 1;
    self.velocity = v_forward * num + dave;
    }
  return 0;
}


Void function jagger_checktop();
var
 spot : Vector;
 p : Real;
{
  spot = self.origin + [0 0 45];
  p = pointcontents(spot);
  if (p == CONTENT_WATER) {
    return 0;
    }
  if (p == CONTENT_EMPTY) {
    return 0;
    }
  return 1;
}

Void function jagger_frolic();
var
 spot : Vector;
{
  if (ai_frolic()) {
    exit;
    }
  #19 jagger_frolic2;
}

Void function jagger_frolic2();
{
  if (ai_frolic()) {
    exit;
    }
  #20 jagger_frolic3;
}

Void function jagger_frolic3();
{
  if (ai_frolic()) {
    exit;
    }
  #21 jagger_frolic4;
}

Void function jagger_frolic4();
var
 spot : Vector;
{
  if (pointcontents(self.origin) == CONTENT_WATER) {
    #20 jagger_frolic;
    exit;
    }
  if (!jagger_checktop()) {
    makevectors(self.angles);
    self.origin_z = self.origin_z + 1;
    self.velocity = v_forward * 250 + [0 0 200];
    self.goalentity = find(world, classname, "info_jagnest");
    if (self.flags & FL_ONGROUND) {
      self.flags = self.flags - FL_ONGROUND;
      }
    }
  else {
    ai_run_slide(2);
    }
  #20 jagger_walk;
  ai2_walk();
}

Void function jagger_ffrolic();
{
  #19 jagger_ffrolic2;
  ai2_walk(3);
  if (self.flags & FL_ONGROUND) {
    makevectors(self.angles);
    self.origin_z = self.origin_z + 1;
    self.velocity = v_forward * 500 + [0 0 300];
    self.flags = self.flags - FL_ONGROUND;
    }
}

Void function jagger_ffrolic2();
{
  #20 jagger_ffrolic3;
  ai2_walk();
}

Void function jagger_ffrolic3();
{
  #21 jagger_ffrolic4;
  ai2_walk();
}

Void function jagger_ffrolic4();
{
  #20 jagger_stand;
  self.goalentity = world;
  ai2_stand();
}

Void function jagger_mourn();
var
 head : Object;
 megadeth : Vector;
{
  head = find(world, classname, "monster_jagger");
  while (head) {
    megadeth = self.origin - head.origin;
    if (head.enemy == world && head.health > 0) {
      if (vlen(megadeth) < 1000) {
        head.think = jagger_call1;
        }
      }
    head = find(head, classname, "monster_jagger");
    }
  jagger_call1();
}

Void function jagger_call();
var
 head : Object;
{
  head = find(world, classname, "monster_jagger");
  if (head == world || head.enemy == self.enemy) {
    jagger_watch();
    exit;
    }
  head.enemy = self.enemy;
  T_Damage(head, self.enemy, self.enemy, 1);
  jagger_call1();
}

Void function jagger_call1();
{
  #106 jagger_call2;
  ai_face();
}

Void function jagger_call2();
{
  #107 jagger_call3;
  ai_face();
}

Void function jagger_call3();
{
  #108 jagger_call4;
  ai_face();
  sound(self, CHAN_VOICE, "jagger/bidle2.wav", 1, ATTN_IDLE);
}

Void function jagger_call4();
{
  #109 jagger_call5;
  ai_face();
}

Void function jagger_call5();
{
  #110 jagger_call6;
  ai_face();
}

Void function jagger_call6();
{
  #111 jagger_call7;
  ai_face();
}

Void function jagger_call7();
{
  #112 jagger_call8;
  ai_face();
}

Void function jagger_call8();
{
  #113 jagger_call9;
  ai_face();
}

Void function jagger_call9();
{
  #114 jagger_call10;
  ai_face();
}

Void function jagger_call10();
{
  #115 jagger_call11;
  ai_face();
}

Void function jagger_call11();
{
  #116 jagger_call12;
  ai_face();
}

Void function jagger_call12();
{
  #117 jagger_call13;
  ai_face();
}

Void function jagger_call13();
{
  #110 jagger_call14;
  ai_face();
}

Void function jagger_call14();
{
  #109 jagger_call15;
  ai_face();
}

Void function jagger_call15();
{
  if (self.enemy == world) {
    jagger_nedec();
    exit;
    }
  #108 jagger_watch;
  ai_face();
}

Void function jagger_lower();
{
  #63 jagger_lower2;
  ai_face();
}

Void function jagger_lower2();
{
  #64 jagger_lower3;
  ai_face();
}

Void function jagger_lower3();
{
  #65 jagger_lower4;
  ai_face();
}

Void function jagger_lower4();
{
  #66 jagger_lower5;
  ai_face();
}

Void function jagger_lower5();
{
  ai_run(0);
  jagger2ir();
  self.th_run();
}

Void function jagger_backup();
{
  #66 jagger_backup2;
  ai_face();
}

Void function jagger_backup2();
{
  #65 jagger_backup3;
  ai_face();
}

Void function jagger_backup3();
{
  #64 jagger_backup4;
  ai_face();
}

Void function jagger_backup4();
{
  #63 jagger_backup5;
  ai_face();
}

Void function jagger_backup5();
{
  ai_run(0);
  jagger2ni();
  #63 jagger_watch;
}

Void function jagger_curious();
{
  #118 jagger_curious2;
  ai_face();
}

Void function jagger_curious2();
{
  #119 jagger_curious3;
  ai_face();
}

Void function jagger_curious3();
{
  #120 jagger_curious4;
  ai_face();
}

Void function jagger_curious4();
{
  #121 jagger_curious5;
  ai_face();
}

Void function jagger_curious5();
{
  #120 jagger_curious6;
  ai_face();
}

Void function jagger_curious6();
{
  #119 jagger_watch;
  ai_face();
}

Void function jagger_sprint1();
{
  #123 jagger_sprint3;
  ai_run(35);
}

Void function jagger_sprint3();
{
  #124 jagger_sprint4;
  ai_run(40);
}

Void function jagger_sprint4();
{
  #123 jagger_run12;
  ai_run(30);
  if (self.flags & FL_ONGROUND) {
    ai2_jump(self.angles, 250, [0 0 250]);
    }
}

Void function jagger_nod();
{
  #46 jagger_nod2;
  ai_face();
}

Void function jagger_nod2();
{
  #47 jagger_nod3;
  ai_face();
}

Void function jagger_nod3();
{
  #48 jagger_nod4;
  ai_face();
}

Void function jagger_nod4();
{
  #49 jagger_nod5;
  ai_face();
}

Void function jagger_nod5();
{
  #50 jagger_nod6;
  ai_face();
}

Void function jagger_nod6();
{
  #51 jagger_nod7;
  ai_face();
}

Void function jagger_nod7();
{
  #52 jagger_nod8;
  ai_face();
}

Void function jagger_nod8();
{
  #53 jagger_nod9;
  ai_face();
}

Void function jagger_nod9();
{
  #54 jagger_nod10;
  ai_face();
}

Void function jagger_nod10();
{
  #55 jagger_nod11;
  ai_face();
}

Void function jagger_nod11();
{
  jagger2norm();
  self.goalentity = world;
  self.enemy = world;
  self.oldenemy = world;
  self.th_stand();
}

Void function jagger_old_idlesound();
{
  if (random() < 0.050000) {
    sound(self, CHAN_VOICE, "jagger/bidle.wav", 1, ATTN_IDLE);
    sound(self, CHAN_VOICE, "jagger/bidle2.wav", 1, ATTN_IDLE);
    }
  ai_walk(8);
}

Void function jagger_walk();
{
  #0 jagger_walk2;
  ai2_walk(10);
  ai_jagmourn();
}

Void function jagger_walk2();
{
  #1 jagger_walk3;
  ai2_walk(18);
  if (pointcontents(self.origin) == CONTENT_WATER) {
    Jagger_fishhunt();
    exit;
    }
  if (self.goalentity.classname == "monster_fish") {
    if (pointcontents(self.origin) == CONTENT_SLIME) {
      self.goalentity = find(world, classname, "info_jagout");
      }
    else {
      self.goalentity = find(world, classname, "info_jagwater");
      }
    }
}

Void function jagger_walk3();
{
  #2 jagger_walk4;
  ai2_walk(18);
  Jagger_lookdec();
}

Void function jagger_walk4();
{
  #3 jagger_walk5;
  ai2_walk(10);
  if (self.goalentity.flags & FL_MONSTER) {
    if (self.goalentity.health < 1) {
      self.goalentity = world;
      }
    }
}

Void function jagger_walk5();
{
  #4 jagger_walk6;
  ai2_walk(18);
  if (pointcontents(self.origin) == CONTENT_WATER) {
    if (self.goalentity.classname == "info_jagnest") {
      self.goalentity = world;
      jagger_decide();
      }
    }
}

Void function jagger_walk6();
{
  #5 jagger_nedec;
  ai2_walk(18);
}

Void function jagger_growl();
{
  #56 jagger_growl2;
  ai_run(0);
}

Void function jagger_growl2();
{
  #57 jagger_growl3;
  ai_face();
}

Void function jagger_growl3();
{
  #58 jagger_growl4;
  ai_face();
}

Void function jagger_growl4();
{
  #59 jagger_growl5;
  ai_face();
  sound(self, CHAN_VOICE, "jagger/bidle.wav", 1, ATTN_IDLE);
}

Void function jagger_growl5();
{
  #60 jagger_growl6;
  ai_face();
}

Void function jagger_growl6();
{
  #61 jagger_growl7;
  ai_face();
}

Void function jagger_growl7();
{
  #62 jagger_irdec;
  ai_face();
}

Void function jagger2_growl();
{
  #77 jagger2_growl2;
  ai_face();
}

Void function jagger2_growl2();
{
  #78 jagger2_growl3;
  ai_face();
  sound(self, CHAN_VOICE, "jagger/bidle.wav", 1, ATTN_IDLE);
}

Void function jagger2_growl3();
{
  #79 jagger2_growl4;
  ai_face();
}

Void function jagger2_growl4();
{
  #80 jagger2_growl5;
  ai_face();
}

Void function jagger2_growl5();
{
  #81 jagger2_growl6;
  ai_face();
}

Void function jagger2_growl6();
{
  #82 jagger2_growl7;
  ai_face();
}

Void function jagger2_growl7();
{
  #83 jagger_irdec2;
  ai_face();
}

Void function jagger_scareem();
var
 mustaine : Object;
{
  mustaine = self.enemy;
  if (mustaine.enemy == self) {
    mustaine.enemy == world;
    }
  if (mustaine.classname == "monster_ogre") {
    mustaine.flags = mustaine.flags + FL_FLEE;
    }
}

Void function jagger_intimidate();
{
  #97 jagger_intimid2;
  ai_face();
}

Void function jagger_intimid2();
{
  #98 jagger_intimid3;
  ai_face();
}

Void function jagger_intimid3();
{
  #99 jagger_intimid4;
  ai_face();
  sound(self, CHAN_VOICE, "jagger/bidle.wav", 1, ATTN_IDLE);
}

Void function jagger_intimid4();
{
  #100 jagger_intimid5;
  ai_face();
}

Void function jagger_intimid5();
{
  #101 jagger_intimid6;
  ai_face();
}

Void function jagger_intimid6();
{
  #102 jagger_intimid7;
  ai_face();
}

Void function jagger_intimid7();
{
  #103 jagger_intimid8;
  ai_face();
}

Void function jagger_intimid8();
{
  #104 jagger_intimid9;
  ai_face();
}

Void function jagger_intimid9();
{
  #105 jagger_irdec;
  ai_face();
}

Void function jagger_stand();
{
  #41 jagger_stand2;
  ai2_stand();
  if (self.watertype == CONTENT_WATER) {
    Jagger_fishhunt();
    }
}

Void function jagger_stand2();
{
  #42 jagger_stand3;
  ai2_stand();
}

Void function jagger_stand3();
{
  #43 jagger_stand4;
  ai2_stand();
  if (self.goalentity == world) {
    jagger_decide();
    }
}

Void function jagger_stand4();
{
  #44 jagger_stand5;
  ai2_stand();
  Jagger_lookdec();
}

Void function jagger_stand5();
{
  #45 jagger_nedec;
  ai2_stand();
}

Void function jagger_watch();
{
  #41 jagger_watch2;
  ai_face();
}

Void function jagger_watch2();
{
  #42 jagger_watch3;
  ai_face();
}

Void function jagger_watch3();
{
  #43 jagger_watch4;
  ai_face();
}

Void function jagger_watch4();
{
  #44 jagger_watch5;
  ai_face();
}

Void function jagger_watch5();
var
 gg : Real;
{
  if (self.enemy.health < 1) {
    jagger2norm();
    self.enemy = world;
    self.oldenemy = world;
    self.th_stand();
    exit;
    }
  gg = random();
  if (gg < 0.4) {
    #45 jagger_watch;
    exit;
    }
  if (gg < 0.6) {
    #45 jagger_growl;
    exit;
    }
  if (gg < 0.8) {
    #45 jagger_intimidate;
    exit;
    }
  #45 jagger_call;
}

Void function jagger2_watch();
{
  #68 jagger2_watch2;
  ai_run(0);
}

Void function jagger2_watch2();
{
  #69 jagger2_watch3;
  ai_face();
}

Void function jagger2_watch3();
{
  #70 jagger2_watch4;
  ai_face();
}

Void function jagger2_watch4();
{
  #71 jagger2_watch5;
  ai_face();
}

Void function jagger2_watch5();
{
  #72 jagger2_watch6;
  ai_face();
}

Void function jagger2_watch6();
{
  #73 jagger2_watch7;
  ai_face();
}

Void function jagger2_watch7();
{
  #74 jagger2_watch8;
  ai_face();
}

Void function jagger2_watch8();
{
  #75 jagger2_watch9;
  ai_face();
}

Void function jagger2_watch9();
{
  ai_face();
  if (random() < 0.4) {
    #76 jagger2_growl;
    exit;
    }
  #76 jagger2_watch;
}

Void function jagger_stop1();
{
  #29 jagger_stop2;
  sound(self, CHAN_VOICE, "jagger/ddeath.wav", 1, ATTN_NORM);
}

Void function jagger_stop2();
{
  #30 jagger_stop3;
}

Void function jagger_stop3();
{
  #31 jagger_stop4;
}

Void function jagger_stop4();
{
  #32 jagger_stop5;
}

Void function jagger_stop5();
{
  #33 jagger_stop6;
  self.solid = SOLID_NOT;
}

Void function jagger_stop6();
{
  #34 jagger_stop7;
}

Void function jagger_stop7();
{
  #35 corpse_think;
}

Void function jagger_bstop1();
{
  #36 jagger_bstop2;
  sound(self, CHAN_VOICE, "jagger/ddeath.wav", 1, ATTN_NORM);
  ai_forward(16);
}

Void function jagger_bstop2();
{
  #37 jagger_bstop3;
  ai_forward(14);
}

Void function jagger_bstop3();
{
  #38 jagger_bstop4;
  ai_forward(10);
}

Void function jagger_bstop4();
{
  #39 jagger_bstop5;
  ai_forward(5);
}

Void function jagger_bstop5();
{
  #40 jagger_bstop6;
  self.solid = SOLID_NOT;
}

Void function jagger_bstop6();
{
  self.think = corpse_think;
  self.nextthink = time + 3;
}

Void function jagger_run();
{
  if (borkfactor1()) {
    exit;
    }
  if (random() < 0.5) {
    if (self.watertype == CONTENT_WATER && self.enemy.watertype != CONTENT_WATER) {
      #20 jagger_frolic;
      exit;
      }
    }
  #6 jagger_run2;
  ai_run(5);
  ai_face();
}

Void function jagger_run2();
{
  #7 jagger_run3;
  ai_run(5);
  ai_face();
}

Void function jagger_run3();
{
  #8 jagger_run4;
  ai_run(10);
  ai_face();
}

Void function jagger_run4();
{
  #9 jagger_run5;
  ai_face();
  self.touch = jagger_JumpTouch;
  makevectors(self.angles);
  self.origin_z = self.origin_z + 1;
  if (jagger_checktop()) {
    self.velocity = v_forward * 400 + [0 0 5];
    }
  else {
    self.velocity = v_forward * 400 + [0 0 250];
    }
  if (self.flags & FL_ONGROUND) {
    self.flags = self.flags - FL_ONGROUND;
    }
  sound(self, CHAN_VOICE, "jagger/bjump.wav", 1, ATTN_NORM);
}

Void function jagger_run5();
{
  #10 jagger_run6;
}

Void function jagger_run6();
{
  #11 jagger_run7;
}

Void function jagger_run7();
{
  #12 jagger_run8;
  if (self.watertype != CONTENT_WATER) {
    exit;
    }
  if (jagger_checktop()) {
    ai_run(25);
    exit;
    }
  if (visible(self.enemy)) {
    makevectors(self.angles);
    self.origin_z = self.origin_z + 1;
    self.velocity = v_forward * 450 + [0 0 250];
    if (self.flags & FL_ONGROUND) {
      self.flags = self.flags - FL_ONGROUND;
      }
    }
}

Void function jagger_run8();
{
  #13 jagger_run9;
}

Void function jagger_run9();
{
  #14 jagger_run10;
}

Void function jagger_run10();
{
  #15 jagger_run11;
  if (jagger_checktop()) {
    ai_run(25);
    }
}

Void function jagger_run11();
{
  #16 jagger_run12;
}

Void function jagger_run12();
var
 megadeth : Vector;
 num : Real;
 t : Real;
{
  megadeth = self.enemy.origin - self.origin;
  if (vlen(megadeth) > 650) {
    self.enemy = world;
    self.goalentity = world;
    jagger2norm();
    #13 jagger_stand;
    exit;
    }
  if (ai_check_z()) {
    #122 jagger_sprint1;
    ai_run(15);
    exit;
    }
  #17 jagger_run;
}

Void function jagger_atta1();
{
  #23 jagger_atta2;
  ai_charge(10);
  ai_face();
}

Void function jagger_atta2();
{
  #24 jagger_atta3;
  ai_charge(10);
  ai_face();
}

Void function jagger_atta3();
{
  #25 jagger_atta4;
  ai_charge(10);
  jagger_bite();
}

Void function jagger_atta4();
{
  #26 jagger_atta5;
  sound(self, CHAN_VOICE, "jagger/bjump2.wav", 1, ATTN_NORM);
  jagger_bite();
}

Void function jagger_atta5();
{
  #27 jagger_atta6;
  ai_charge(10);
  jagger_bite();
}

Void function jagger_atta6();
{
  #28 jagger_run;
  ai_charge(10);
}

Void function jagger_leap1();
{
  #25 jagger_leap2;
  ai_face();
}

Void function jagger_leap2();
{
  #26 jagger_leap3;
  ai_face();
}

Void function jagger_leap3();
{
  #27 jagger_leap4;
  ai_face();
  if (self.flags & FL_ONGROUND) {
    self.touch = jagger_JumpTouch;
    makevectors(self.angles);
    self.origin_z = self.origin_z + 1;
    self.velocity = v_forward * 600 + [0 0 250];
    self.flags = self.flags - FL_ONGROUND;
    if (random() < 0.050000) {
      sound(self, CHAN_VOICE, "jagger/bjump.wav", 1, ATTN_NORM);
      }
    }
}

Void function jagger_leap4();
{
  #28 jagger_leap5;
  ai_face();
}

Void function jagger_leap5();
{
  #29 jagger_leap6;
  ai_face();
}

Void function jagger_leap6();
{
  #13 jagger_run;
  ai_face();
}

Real function CheckJaggerMelee();
{
  if (enemy_range == RANGE_MELEE) {
    self.attack_state = AS_MELEE;
    return 1;
    }
  return 0;
}

Void function jagger_JumpTouch();
var
 ldmg : Real;
{
  if (self.health <= 0) {
    exit;
    }
  if (other.classname == self.classname) {
    exit;
    }
  if (other.takedamage) {
    if (vlen(self.velocity) > 300) {
      ldmg = 5 + 10 * random();
      T_Damage(other, self, self, ldmg);
      }
    }
  if (!checkbottom(self)) {
    if (self.flags & FL_ONGROUND || self.watertype == CONTENT_WATER) {
      self.touch = SUB_Null;
      self.think = jagger_leap1;
      self.nextthink = time;
      }
    exit;
    }
  self.touch = SUB_Null;
  self.think = jagger_run8;
  self.nextthink = time;
}

Void function jagger_pain(attacker : Object; damage : Real);
{
  if (self.touch == jagger_JumpTouch) {
    exit;
    }
  if (self.pain_finished > time) {
    exit;
    }
  self.pain_finished = time + 3;
  sound(self, CHAN_VOICE, "jagger/dpain1.wav", 1, ATTN_NORM);
  if (pointcontents(self.origin) == CONTENT_WATER) {
    sound(self, CHAN_DAMAUL, "player/razh20.wav", 1, ATTN_NORM);
    }
  exit;
}

Void function jagger_die();
{
  if (self.health < -50) {
    if (self.watertype == CONTENT_WATER) {
      sound(self, CHAN_BODY, "player/razh20.wav", 1, ATTN_NORM);
      }
    sound(self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
    ThrowHead("progs/gib2.mdl", self.health);
    ThrowGib("progs/gib1.mdl", self.health);
    ThrowGib("progs/gib2.mdl", self.health);
    ThrowGib("progs/gib3.mdl", self.health);
    exit;
    }
  if (random() > 0.4) {
    jagger_stop1();
    exit;
    }
  else {
    self.movetype = MOVETYPE_BOUNCE;
    }
  self.velocity_x = -50 + 100 * random();
  self.velocity_y = -50 + 100 * random();
  self.flags = self.flags - (self.flags & FL_ONGROUND);
  jagger_bstop1();
}

Real function CheckJaggerJump();
var
 dist : Vector;
 d : Real;
{
  if (self.origin_z + self.mins_z > self.enemy.origin_z + self.enemy.mins_z + 0.75 * self.enemy.size_z) {
    return 0;
    }
  if (self.origin_z + self.maxs_z < self.enemy.origin_z + self.enemy.mins_z + 0.25 * self.enemy.size_z) {
    return 0;
    }
  dist = self.enemy.origin - self.origin;
  dist_z = 0;
  d = vlen(dist);
  if (d < 80) {
    return 0;
    }
  if (d > 150) {
    return 0;
    }
  return 1;
}

Real function JaggerCheckAttack();
var
 vec : Vector;
{
  if (CheckJaggerMelee()) {
    self.attack_state = AS_MELEE;
    return 1;
    }
  if (CheckJaggerJump()) {
    if (self.th_run == jagger_run) {
      self.attack_state = AS_MISSILE;
      return 1;
      }
    }
  return 0;
}

Void function jagger_bite();
var
 delta : Vector;
 ldmg : Real;
{
  if (!(self.enemy)) {
    exit;
    }
  ai_charge(10);
  if (!CanDamage(self.enemy, self)) {
    exit;
    }
  delta = self.enemy.origin - self.origin;
  if (vlen(delta) > 120) {
    exit;
    }
  ldmg = random() * 6 + random() * 6;
  T_Damage(self.enemy, self, self, ldmg);
}

Void function monster_jagger();
{
  if (deathmatch) {
    remove(self);
    exit;
    }
  total_monsters = total_monsters + 1;
  precache_model("progs/jagger.mdl");
  precache_sound("jagger/dpain1.wav");
  precache_sound("jagger/bidle.wav");
  precache_sound("jagger/bidle2.wav");
  precache_sound("jagger/bjump.wav");
  precache_sound("jagger/bjump2.wav");
  precache_sound("jagger/ddeath.wav");
  self.cnt = 0;
  self.skin = 3;
  self.th_stand = jagger_stand;
  self.th_walk = jagger_walk;
  self.th_run = jag_from_norm;
  self.th_melee = jag_from_norm;
  self.th_pain = jag_from_norm;
  self.th_missile = SUB_Null;
  self.th_die = jagger_die;
  self.th_mourn = jagger_mourn;
  self.pain_finished = time + 3;
  if (self.brain & TRIGGER_SPAWN) {
    self.use = jagger_startt;
    exit;
    }
  carnify_jagger();
}

Void function jagger_startt();
{
  trigger_spawnmonster();
  carnify_jagger();
}

Void function carnify_jagger();
{
  self.solid = SOLID_SLIDEBOX;
  self.movetype = MOVETYPE_STEP;
  setmodel(self, "progs/jagger.mdl");
  setsize(self, VEC_HULL_MIN, [16 16 30]);
  if (!(self.health)) {
    self.health = 480;
    }
  walkmonster_start();
}

Void function jagger2norm();
{
  self.th_stand = jagger_stand;
  self.th_walk = jagger_walk;
  self.th_run = jag_from_norm;
  self.th_melee = SUB_Null;
  self.th_pain = jag_from_norm;
  self.th_missile = SUB_Null;
}

Void function jagger_reset();
{
  jagger2norm();
  self.goalentity = world;
  self.th_stand();
}

Void function jag_from_norm();
{
  if (self.health < 150) {
    jagger2mad();
    self.th_run();
    exit;
    }
  jagger2ni();
  self.th_run();
}

Void function jagger2ni();
{
  self.th_stand = jagger_stand;
  self.th_walk = jagger_walk;
  self.th_run = jagger_watch;
  self.th_melee = SUB_Null;
  self.th_pain = jaggerpissed;
  self.th_missile = SUB_Null;
}

Void function jagger2ir();
{
  self.th_stand = jagger_stand;
  self.th_walk = jagger_walk;
  self.th_run = jagger2_watch;
  self.th_melee = SUB_Null;
  self.th_missile = SUB_Null;
  self.th_pain = jaggerpissed;
}

Void function jaggerpissed();
{
  jagger2mad();
  self.th_run();
}

Void function jagger2mad();
{
  self.th_stand = jagger_reset;
  self.th_walk = jagger_reset;
  self.th_melee = jagger_atta1;
  self.th_missile = jagger_leap1;
  self.th_run = jagger_run;
  self.th_pain = jagger_pain;
}

Void function jagger_decide();
var
 megadeth : Vector;
 mustaine : Object;
{
  if (self.goalentity != world) {
    exit;
    }
  if (pointcontents(self.origin) == CONTENT_WATER && random() < 0.5) {
    mustaine = find(world, classname, "monster_fish");
    if (mustaine.health > 1) {
      self.goalentity = mustaine;
      exit;
      }
    }
  if (self.watertype != CONTENT_WATER) {
    mustaine = find(world, classname, "info_jagwater");
    if (mustaine != world) {
      self.goalentity = mustaine;
      exit;
      }
    }
  else {
    mustaine = find(world, classname, "jagpoint");
    if (mustaine != world) {
      self.goalentity = mustaine;
      exit;
      }
    else {
      mustaine = find(world, classname, "info_jagout");
      if (mustaine != world) {
        self.goalentity = mustaine;
        exit;
        }
      }
    }
  mustaine = find(world, classname, "ambient_swamp1");
  if (mustaine != world) {
    self.goalentity = mustaine;
    exit;
    }
  mustaine = find(world, classname, "ambient_swamp2");
  if (mustaine != world) {
    self.goalentity = mustaine;
    exit;
    }
  mustaine = find(world, classname, "ambient_swamp3");
  if (mustaine != world) {
    self.goalentity = mustaine;
    exit;
    }
}

Void function jagger_nedec();
var
 megadeth : Vector;
 mustaine : Object;
{
  if (self.wripple > 0) {
    self.wripple = self.wripple - 1;
    }
  Jagger_ontop();
  mustaine = self.goalentity;
  megadeth = mustaine.origin - self.origin;
  if (mustaine.classname == "info_jagnest" && vlen(megadeth) < 250) {
    mustaine = world;
    if (self.cnt > 0) {
      Spew_fish();
      self.cnt = self.cnt - 1;
      }
    }
  if (mustaine == world) {
    if (random() < 0.1) {
      self.goalentity = world;
      }
    jagger_stand();
    exit;
    }
  megadeth = mustaine.origin - self.origin;
  if (mustaine.classname == "ambient_swamp1" || mustaine.classname == "ambient_swamp2") {
    if (vlen(megadeth) < 200) {
      if (self.watertype == CONTENT_WATER && self.wripple < 1) {
        mustaine = find(world, classname, "info_jagout");
        }
      else {
        mustaine = find(world, classname, "info_jagwater");
        }
      }
    }
  if (mustaine.classname == "info_jagwater" || mustaine.classname == "info_jagout" || mustaine.classname == "jagpoint") {
    if (self.wripple <= 0) {
      if (pointcontents(self.origin) == CONTENT_WATER) {
        jagger_frolic();
        exit;
        }
      else {
        if (vlen(megadeth) < 600) {
          jagger_ffrolic();
          exit;
          }
        }
      }
    }
  if (mustaine.classname == "monster_fish") {
    if (mustaine.health < 1) {
      self.goalentity = world;
      jagger_stand();
      exit;
      }
    if (vlen(megadeth) < 200 || visible(mustaine)) {
      jagger2mad();
      #6 jagger_run;
      exit;
      }
    }
  jagger_walk();
}

Void function jagger_irdec();
var
 mustaine : Object;
 megadeth : Vector;
 no9 : Real;
{
  mustaine = find(world, classname, "info_jagnest");
  if (mustaine != world) {
    megadeth = mustaine.origin - self.origin;
    if (vlen(megadeth) < 400) {
      jagger2mad();
      self.th_run();
      exit;
      }
    }
  mustaine = self.enemy;
  megadeth = mustaine.origin - self.origin;
  no9 = vlen(megadeth);
  if (mustaine.health < 1 || no9 > 300) {
    jagger_nod();
    exit;
    }
  if (no9 < 110) {
    jagger2mad();
    self.th_run();
    exit;
    }
  if (no9 > 109 && no9 < 160) {
    jagger_lower();
    exit;
    }
  if (no9 > 159 && no9 < 250) {
    jagger_watch();
    exit;
    }
  if (no9 > 249 && no9 < 301) {
    if (random() < 0.5) {
      jagger_watch();
      exit;
      }
    jagger_curious();
    exit;
    }
  jagger_watch();
}

Void function jagger_irdec2();
var
 mustaine : Object;
 megadeth : Vector;
 no9 : Real;
{
  if (self.relations == -1) {
    jaggerpissed();
    exit;
    }
  mustaine = find(world, classname, "info_jagnest");
  if (mustaine != world) {
    megadeth = mustaine.origin - self.origin;
    if (vlen(megadeth) < 600) {
      jagger2mad();
      self.th_run();
      exit;
      }
    }
  mustaine = self.enemy;
  megadeth = mustaine.origin - self.origin;
  no9 = vlen(megadeth);
  if (mustaine.health < 1 || no9 > 300) {
    jagger_backup();
    exit;
    }
  if (no9 < 110) {
    jagger2mad();
    self.th_run();
    exit;
    }
  if (no9 > 109 && no9 < 160) {
    jagger2_watch();
    exit;
    }
  if (no9 > 159 && no9 < 300) {
    jagger_backup();
    exit;
    }
  jagger2_watch();
}

Void function Jagger_lookdec();
var
 head : Object;
 selected : Object;
 dist : Real;
{
  dist = 300;
  selected = world;
  head = findradius(self.origin, 300);
  while (head) {
    if (head.flags & FL_CLIENT || (head.flags & FL_MONSTER)) {
      if (!(head.flags & FL_NOTARGET)) {
        if (visible(head) && trace_plane_dist < 300) {
          if (head.health > 0 && head != self) {
            if (head.classname != "monster_fish" && head.classname != self.classname) {
              selected = head;
              dist = trace_plane_dist;
              }
            }
          }
        }
      }
    head = head.chain;
    }
  if (selected == world) {
    return 0;
    }
  else {
    self.enemy = selected;
    FoundTarget();
    HuntTarget();
    return 1;
    }
}

Void function Jagger_fishhunt();
var
 head : Object;
 selected : Object;
 dist : Real;
{
  if (self.watertype != CONTENT_WATER) {
    exit;
    }
  dist = 120;
  selected = world;
  head = findradius(self.origin, 300);
  while (head) {
    if (visible(head) && trace_plane_dist < 300) {
      if (head.health > 0 && head != self) {
        if (head.classname == "monster_fish") {
          selected = head;
          dist = trace_plane_dist;
          }
        }
      }
    head = head.chain;
    }
  if (selected == world) {
    return 0;
    }
  else {
    self.enemy = selected;
    if (self.classname == "monster_jagger") {
      jagger2mad();
      }
    FoundTarget();
    HuntTarget();
    return 1;
    }
}

Void function Jagger_ontop();
var
 head : Object;
 selected : Object;
 dist : Real;
{
  dist = 90;
  selected = world;
  head = findradius(self.origin, 90);
  while (head) {
    if (trace_plane_dist < 90) {
      if (head.health > 0 && head != self && head.watertype == CONTENT_WATER) {
        if (head.classname == self.classname && self.origin_z > head.origin_z) {
          selected = head;
          dist = trace_plane_dist;
          }
        }
      }
    head = head.chain;
    }
  if (selected == world) {
    return 0;
    }
  else {
    makevectors(self.angles);
    self.origin_z = self.origin_z + 1;
    self.velocity = v_forward * -250 + [0 0 350];
    if (self.flags & FL_ONGROUND) {
      self.flags = self.flags - FL_ONGROUND;
      }
    return 1;
    }
}

Void function Spew_fish();
var
 item : Object;
{
  item = spawn();
  item.origin = self.origin + [0 0 24];
  item.velocity_z = 300;
  item.velocity_x = -100 + random() * 200;
  item.velocity_y = -100 + random() * 200;
  item.flags = FL_ITEM;
  item.enemy = self;
  item.health = 10;
  item.solid = SOLID_NOT;
  item.movetype = MOVETYPE_STEP;
  item.classname = "spew_fish";
  setmodel(item, "progs/fish.mdl");
  setsize(item, VEC_HULL_MIN, [16 16 3]);
  item.frame = 35;
  item.nextthink = time + 0.2;
  item.think = SUB_Null;
  item.th_stand = SUB_Null;
  item.th_walk = SUB_Null;
  item.th_run = SUB_Null;
  item.th_pain = fishy_blood;
  item.th_melee = SUB_Null;
  item.th_missile = SUB_Null;
  item.th_die = fish_splat;
}

Void function fishy_blood();
{
  SpawnMeatSpray(self.origin, crandom() * 86 * v_right);
}

Void function fish_splat();
{
  SpawnMeatSpray(self.origin, crandom() * 86 * v_right);
  ThrowGib("progs/gib1.mdl", self.health);
  ThrowGib("progs/gib3.mdl", self.health);
  ThrowGib("progs/gib3.mdl", self.health);
  remove(self);
}

Void function info_jagnest();
{
  self.cnt = 0;
  self.think = fish_tally;
  self.nextthink = time + 1.2;
}

Void function fish_tally();
var
 e : Object;
 n : Real;
 j : Real;
 head : Object;
 selected : Object;
 dist : Real;
{
  j = 0;
  e = find(world, classname, "monster_jagger");
  while (e) {
    if (e.health > 5) {
      j = j + 1;
      }
    e = find(e, classname, "monster_jagger");
    }
  n = 0;
  e = find(world, classname, "spew_fish");
  while (e) {
    n = n + 1;
    e = find(e, classname, "spew_fish");
    }
  if (n < j) {
    self.cnt = n;
    }
  else {
    dist = 250;
    selected = world;
    head = findradius(self.origin, 250);
    while (head) {
      if (trace_plane_dist < 250) {
        if (head.health > 0) {
          if (head.classname == "monster_jagger") {
            selected = head;
            dist = trace_plane_dist;
            }
          }
        }
      head = head.chain;
      }
    if (selected != world) {
      e = find(world, classname, "spew_fish");
      if (pointcontents(e.origin) == CONTENT_EMPTY) {
        e.flags = FL_MONSTER;
        e.takedamage = DAMAGE_AIM;
        e.solid = SOLID_SLIDEBOX;
        }
      }
    }
  self.nextthink = time + 1.2;
}

Void function info_jagwater();
var
 new : Object;
{
  if (self.spawnflags > 0) {
    new = spawn();
    new.origin = self.origin;
    new.classname = "info_jagout";
    setorigin(new, self.origin);
    new.think = jagout_assess;
    new.nextthink = time + 1;
    remove(self);
    }
}

Void function info_jagout();
{
  self.think = jagout_assess;
  self.nextthink = time + 1;
}

Void function jagout_assess();
var
 vec : Vector;
 megadeth : Vector;
 num : Real;
{
  vec = self.origin - [0 0 200];
  traceline(self.origin, vec, 1, self);
  if (trace_fraction == 1) {
    dprint("INFO_JAGOUT: Too high,");
    if (pointcontents(trace_endpos) == CONTENT_WATER) {
      dprint("no land found beneath");
      dprint("|");
      }
    dprint("JAGGER BEHAVIOR MAY BE UNUSUAL|");
    }
  self.think = jagout_cardinal;
  self.nextthink = time + 0.5;
}

Void function jagout_cardinal();
var
  head : Object;
  vec : Vector;
  megadeth : Vector;
  num : Real;
{
  self.cnt = self.cnt + 1;
  vec = VEC_ORIGIN;
  if (self.cnt == 1) {
    vec = self.origin + [100 0 0];
    }
  if (self.cnt == 2) {
    vec = self.origin - [100 0 0];
    }
  if (self.cnt == 3) {
    vec = self.origin + [0 100 0];
    }
  if (self.cnt == 4) {
    vec = self.origin - [0 100 0];
    }
  if (self.cnt == 5) {
    vec = self.origin + [100 100 0];
    }
  if (self.cnt == 6) {
    vec = self.origin - [100 100 0];
    }
  if (self.cnt == 7) {
    vec = self.origin + [100 -100 0];
    }
  if (self.cnt == 8) {
    vec = self.origin + [-100 100 0];
    }
  if (self.cnt > 8) {
    self.think = setup_jagpoint;
    self.nextthink = time + 0.5;
    exit;
    }
  traceline(self.origin, vec, 1, self);
  if (trace_fraction == 1) {
    megadeth = vec - [0 0 500];
    traceline(vec, megadeth, 1, self);
    num = vlen(vec - trace_endpos);
    if (pointcontents(trace_endpos) == CONTENT_WATER) {
      if (num > self.frolic) {
        self.frolic = num;
        self.xgoal = vec;
        }
      }
    }
  self.think = jagout_cardinal;
  self.nextthink = time + 0.1;
}

Void function setup_jagpoint();
var
 new : Object;
{
  if (self.xgoal == [0 0 0]) {
    dprint("INFO_JAGOUT: Location lacks logical route|");
    self.xtrace = self.origin;
    self.think = Sub_Null;
    self.nextthink = time + 99999;
    exit;
    }
  new = spawn();
  new.xtrace = self.origin;
  new.origin = self.xgoal;
  new.classname = "jagpoint";
  new.fullbright = 1;
}

Void function kguard_firing(side : Real; damg : Real);
var
 r : Real;
 delta : Vector;
{
  ai_face();
  if (visible(self.enemy)) {
    if (self.origin_z < self.enemy.origin_z) {
      Mons_fire_nails();
      exit;
      }
    delta = self.enemy.origin - self.origin;
    if (vlen(delta) > 200 && self.rotate_type != 1) {
      if (random() < 0.5 && self.enemy.origin_z <= self.origin_z) {
        Mons_fire_grenade();
        exit;
        }
      Mons_fire_rocket();
      if (self.flags & FL_ONGROUND) {
        self.origin_z = self.origin_z + 1;
        self.velocity_z = 200;
        self.flags = self.flags - FL_ONGROUND;
        exit;
        }
      }
    }
  Mons_fire_nails();
}

Void function kguard_stand1();
{
  #12 kguard_stand2;
  ai_stand();
}

Void function kguard_stand2();
{
  #13 kguard_stand3;
  ai_stand();
  TargetBadGuys();
}

Void function kguard_stand3();
{
  #14 kguard_stand4;
  ai_stand();
}

Void function kguard_stand4();
{
  #15 kguard_stand5;
  ai_stand();
}

Void function kguard_stand5();
{
  #16 kguard_stand6;
  ai_stand();
}

Void function kguard_stand6();
{
  #15 kguard_stand7;
  ai_stand();
}

Void function kguard_stand7();
{
  #14 kguard_stand8;
  ai_stand();
}

Void function kguard_stand8();
{
  #16 kguard_stand9;
  ai_stand();
}

Void function kguard_stand9();
{
  ai_stand();
  kguard_stand1();
}

Void function kguard_walk1();
{
  #6 kguard_walk2;
  ai_walk(28);
  TargetBadGuys();
}

Void function kguard_walk2();
{
  #7 kguard_walk3;
  ai_walk(28);
  if (self.objekt != world && self.objekt.classname == "player") {
    ai_objledge();
    }
}

Void function kguard_walk3();
{
  #8 kguard_walk4;
  ai_walk(28);
}

Void function kguard_walk4();
{
  #9 kguard_walk5;
  ai_walk(28);
}

Void function kguard_walk5();
{
  #10 kguard_walk6;
  ai_walk(28);
}

Void function kguard_walk6();
{
  #11 kguard_walk1;
  ai_walk(28);
}

Void function kguard_back();
{
  if (self.walkframe >= 6) {
    self.walkframe = 0;
    self.touch = objekt_touch;
    #11 kguard_stand1;
    exit;
    }
  #6 kguard_back;
  self.frame = 11 - self.walkframe;
  self.walkframe = self.walkframe + 1;
  ai_back(12);
}

Void function kguard_run1();
{
  #6 kguard_run2;
  ai3_run(29);
}

Void function kguard_run2();
{
  #7 kguard_run3;
  ai3_run(29);
  TargetBadGuys();
}

Void function kguard_run3();
{
  #8 kguard_run4;
  ai3_run(29);
}

Void function kguard_run4();
{
  #9 kguard_run5;
  ai3_run(29);
}

Void function kguard_run5();
{
  #10 kguard_run6;
  ai3_run(29);
  ai_threats();
}

Void function kguard_run6();
{
  #11 kguard_run7;
  ai3_run(29);
}

Void function kguard_run7();
{
  ai3_run(29);
  kguard_shoot();
}

Void function kguard_atta1();
{
  if (qguy_tolerance()) {
    self.th_stand();
    exit;
    }
  #113 kguard_atta4;
  ai_face();
}

Void function kguard_atta4();
{
  #114 kguard_atta5;
  ai_face();
  kguard_firing();
  self.effects = self.effects | EF_MUZZLEFLASH;
}

Void function kguard_atta5();
{
  if (random() < 0.4 && visible(self.enemy)) {
    #115 kguard_atta4;
    ai_face();
    }
  #115 kguard_atta6;
  ai_face();
}

Void function kguard_atta6();
{
  #116 kguard_atta7;
  ai_face();
}

Void function kguard_atta7();
{
  #117 kguard_atta8;
  ai_face();
}

Void function kguard_atta8();
{
  ai_face();
  kguard_shoot();
}

Void function kguard_pain1();
{
  if (self.pain_finished > time) {
    exit;
    }
  self.pain_finished = time + 2.1;
  #35 kguard_pain2;
  PainSound();
}

Void function kguard_pain2();
{
  #36 kguard_pain3;
}

Void function kguard_pain3();
{
  #37 kguard_pain4;
}

Void function kguard_pain4();
{
  #38 kguard_pain5;
}

Void function kguard_pain5();
{
  #39 kguard_pain6;
}

Void function kguard_pain6();
{
  #40 kguard_shoot;
}

Void function kguard_pain();
{
  kguard_pain1();
}

Void function kguard_die1();
{
  #50 kguard_die2;
}

Void function kguard_die2();
{
  #51 kguard_die3;
}

Void function kguard_die3();
{
  #52 kguard_die4;
}

Void function kguard_die4();
{
  #53 kguard_die5;
}

Void function kguard_die5();
{
  #54 kguard_die6;
}

Void function kguard_die6();
{
  #55 kguard_die7;
}

Void function kguard_die7();
{
  #56 kguard_die8;
}

Void function kguard_die8();
{
  #57 kguard_die9;
}

Void function kguard_die9();
{
  #58 kguard_die10;
}

Void function kguard_die10();
{
  #59 kguard_die11;
}

Void function kguard_die11();
{
  #60 corpse_think;
}

Void function kguard_dieb1();
{
  #85 kguard_dieb2;
}

Void function kguard_dieb2();
{
  #86 kguard_dieb3;
}

Void function kguard_dieb3();
{
  #87 kguard_dieb4;
}

Void function kguard_dieb4();
{
  #88 kguard_dieb5;
}

Void function kguard_dieb5();
{
  #89 kguard_dieb6;
}

Void function kguard_dieb6();
{
  #90 kguard_dieb7;
}

Void function kguard_dieb7();
{
  #91 kguard_dieb8;
}

Void function kguard_dieb8();
{
  #92 kguard_dieb9;
}

Void function kguard_dieb9();
{
  #93 corpse_think;
}

Void function kguard_die();
{
  if (self.health < -35) {
    sound(self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
    ThrowGib("progs/gib3.mdl", self.health);
    ThrowGib("progs/gib1.mdl", self.health);
    ThrowGib("progs/gib2.mdl", self.health);
    ThrowHead("progs/gib3.mdl", self.health);
    exit;
    }
  if (random() < 0.5) {
    sound(self, CHAN_VOICE, "player/death3.wav", 1, ATTN_NORM);
    }
  else {
    sound(self, CHAN_VOICE, "player/death1.wav", 1, ATTN_NORM);
    }
  self.solid = SOLID_NOT;
  if (random() > 0.5) {
    kguard_die1();
    }
  else {
    kguard_dieb1();
    }
}

Void function monster_qguy();
{
  if (deathmatch) {
    exit;
    }
  precache_sound("weapons/rocket1i.wav");
  if (!(self.brain & NAVLOGIC)) {
    self.brain = self.brain | NAVLOGIC;
    }
  self.rotate_type = self.cnt;
  if (self.targetname == "actor10" || self.targetname == "actor6" || self.targetname == "actor9") {
    self.th_stand = kguard_actor_wait;
    self.th_walk = kguard_actor_wait;
    }
  else {
    self.th_stand = kguard_stand1;
    self.th_walk = kguard_walk1;
    }
  self.th_run = kguard_run1;
  self.th_pain = kguard_pain;
  self.th_die = kguard_die;
  self.th_melee = kguard_atta1;
  self.th_missile = SUB_Null;
  if (self.relations == -1) {
    self.relations = 0;
    }
  else {
    if (self.relations < 2) {
      self.relations = 2;
      }
    }
  if (self.relations > 2) {
    self.th_back = kguard_back;
    }
  if (self.brain & TRIGGER_SPAWN) {
    self.use = qguy_start;
    exit;
    }
  carnify_qguy();
}

Void function qguy_start();
{
  trigger_spawnmonster();
  carnify_qguy();
}

Void function carnify_qguy();
{
  self.solid = SOLID_SLIDEBOX;
  self.movetype = MOVETYPE_STEP;
  setmodel(self, "progs/player.mdl");
  setsize(self, VEC_HULL_MIN, [16 16 40]);
  if (!(self.health)) {
    self.health = 250;
    }
  walkmonster_start();
}

Void function kguard_actor_wait();
{
  self.use = kguard_actor_use;
  if (self.walkframe >= 5) {
    self.walkframe = 0;
    }
  #12 kguard_actor_wait;
  self.frame = 12 + self.walkframe;
  self.walkframe = self.walkframe + 1;
}

Void function kguard_actor_use();
{
  if (self.goalentity == world) {
    #69 kguard_stand1;
    }
  else {
    #69 kguard_walk1;
    ai_walk(5);
    }
  self.th_stand = kguard_stand1;
  self.th_walk = kguard_walk1;
  self.use = monster_use;
}

Void function kguard_shoot(side : Real; damg : Real);
var
 ldmg : Real;
 delta : Vector;
{
  if (self.enemy.health < 1) {
    kguard_stand1();
    self.enemy = world;
    exit;
    }
  ai_face();
  if (visible(self.enemy) * random() > 0.5) {
    kguard_atta1();
    exit;
    }
  kguard_run1();
}

Void function TargetBadGuys();
var
 head : Object;
 selected : Object;
 dist : Real;
{
  if (self.relations == -1) {
    exit;
    }
  dist = 1000;
  selected = world;
  head = findradius(self.origin, 1000);
  while (head) {
    if (visible(head)) {
      if (trace_plane_dist < dist) {
        if (head.health > 0 && head != self) {
          if (head.classname != "player" && head.classname != self.classname && head.classname != "camera") {
            if (head.flags & FL_MONSTER) {
              selected = head;
              dist = trace_plane_dist;
              }
            }
          }
        }
      }
    head = head.chain;
    }
  if (selected == world || selected == self.enemy) {
    return 0;
    }
  else {
    self.enemy = selected;
    FoundTarget();
    HuntTarget();
    return 1;
    }
}

Void function qguy_tolerance();
{
  if (self.enemy.classname == "monster_qguy") {
    if (self.pest == world) {
      self.pest = self.enemy;
      }
    if (self.pest != self.enemy) {
      self.tolerate = 0;
      self.pest = self.enemy;
      }
    self.tolerate = self.tolerate + 1;
    if (self.tolerate > 2) {
      return 0;
      }
    self.enemy = world;
    self.goalentity = world;
    self.oldenemy = world;
    return 1;
    exit;
    }
  return 0;
}

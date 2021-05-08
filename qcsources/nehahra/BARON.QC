Void function baron_fling();
var
 mark : Object;
 delta : Vector;
{
  delta = self.enemy.origin - self.origin;
  if (vlen(delta) > 100) {
    exit;
    }
  if (!CanDamage(self.enemy, self)) {
    exit;
    }
  mark = self.enemy;
  if (mark.flags & FL_ONGROUND) {
    mark.flags = mark.flags - FL_ONGROUND;
    makevectors(self.angles);
    mark.origin_z = mark.origin_z + 1;
    mark.velocity = v_forward * 400 + [0 0 350];
    }
}

Void function baron_idle();
var
 num : real;
 num2 : real;
{
  if (self.walkframe >= 20) {
    self.walkframe = 0;
    self.cnt = self.cnt + 1;
    if (self.cnt > 1) {
      self.cnt = 0;
      }
    }
  #79 baron_idle;
  if (self.cnt == 0) {
    self.frame = 79 + self.walkframe;
    }
  else {
    self.frame = 98 - self.walkframe;
    }
  self.walkframe = self.walkframe + 1;
  ai_stand();
  if (self.walkframe == 10) {
    sound(self, CHAN_VOICE, "hknight/idle.wav", 1, ATTN_NORM);
    }
}

Void function baron_walk();
{
  if (self.walkframe >= 20) {
    self.walkframe = 0;
    }
  #79 baron_walk;
  self.frame = 79 + self.walkframe;
  self.walkframe = self.walkframe + 1;
  ai_walk(0);
}

Void function baron_wins();
var
 num : Real;
{
  num = random();
  self.walkframe = 0;
  if (num < 0.3) {
    baron_draw();
    }
  else {
    if (num < 0.6) {
      baron_hyped();
      }
    else {
      baron_point();
      }
    }
}

Void function baron_point();
{
  if (self.walkframe >= 11) {
    self.walkframe = 0;
    baron_draw();
    exit;
    }
  #11 baron_point;
  self.frame = 11 + self.walkframe;
  self.walkframe = self.walkframe + 1;
  ai_stand();
}

Void function baron_hyped();
{
  if (self.walkframe >= 19) {
    self.walkframe = 0;
    baron_draw();
    exit;
    }
  #22 baron_hyped;
  self.frame = 22 + self.walkframe;
  self.walkframe = self.walkframe + 1;
  ai_stand();
}

Void function baron_draw();
{
  self.walkframe = 0;
  self.th_run = baron_run1;
  self.pain_finished = time + 0.6;
  baron_draw1();
}

Void function baron_draw1();
{
  if (self.walkframe >= 5) {
    self.walkframe = 0;
    if (self.enemy == world) {
      baron_idle();
      exit;
      }
    baron_run1();
    exit;
    }
  #62 baron_draw1;
  if (self.enemy == world) {
    self.frame = 66 - self.walkframe;
    }
  else {
    self.frame = 62 + self.walkframe;
    ai_face();
    }
  self.walkframe = self.walkframe + 1;
}

Void function baron_run1();
{
  if (self.walkframe == 0) {
    if (borkfactor1()) {
      exit;
      }
    }
  if (self.walkframe >= 6) {
    self.walkframe = 0;
    }
  #56 baron_run1;
  self.frame = 56 + self.walkframe;
  self.walkframe = self.walkframe + 1;
  ai_run(FL_MONSTER);
}

Void function baron_melee();
{
  self.walkframe = 0;
  self.cnt = 0;
  hknight_type = hknight_type + 1;
  sound(self, CHAN_WEAPON, "baron/woosh.wav", 1, ATTN_NORM);
  if (hknight_type == 1) {
    baron_sword1_1();
    }
  else {
    if (hknight_type == FL_SWIM) {
      baron_smash();
      hknight_type = 0;
      }
    else {
      if (hknight_type == MOVETYPE_WALK) {
        baron_sword2_1();
        hknight_type = 0;
        }
      }
    }
}

Void function baron_lrange();
{
  self.walkframe = 0;
  self.cnt = 0;
  if (self.nojump == 0 && random() < 0.3) {
    if (ai2_tracetoss(self.angles, 400, [0 0 300])) {
      baron_jump();
      exit;
      }
    }
  baron_magic1();
}

Void function baron_magic1();
{
  #109 baron_magic2;
  ai_face();
}

Void function baron_magic2();
{
  #110 baron_magic3;
  ai_face();
}

Void function baron_magic3();
{
  #111 baron_magic4;
  ai_face();
  hknight_shot(0);
}

Void function baron_magic4();
{
  #112 baron_magic5;
  ai_face();
  hknight_shot(CONTENT_EMPTY);
  hknight_shot(CONTENT_SOLID);
}

Void function baron_magic5();
{
  #113 baron_magic6;
  ai_face();
  hknight_shot(1);
  hknight_shot(0);
}

Void function baron_magic6();
{
  #114 baron_magic7;
  ai_face();
}

Void function baron_magic7();
{
  #115 baron_run1;
  ai_face();
}

Void function baron_sword1_1();
{
  if (self.walkframe >= 6) {
    self.walkframe = 1;
    self.cnt = self.cnt + 1;
    if (self.cnt > 1) {
      baron_run1();
      exit;
      }
    }
  #103 baron_sword1_1;
  if (self.cnt == 0) {
    self.frame = 103 + self.walkframe;
    }
  else {
    self.frame = 108 - self.walkframe;
    }
  self.walkframe = self.walkframe + 1;
  ai_charge(3);
  self.angles_y = self.angles_y + 11;
  anglechecking();
  if (self.walkframe > 4) {
    ai_melee();
    chainsaw(0);
    }
}

Void function baron_sword2_1();
{
  if (self.walkframe >= 13) {
    self.walkframe = 0;
    baron_run1();
    exit;
    }
  #103 baron_sword2_1;
  self.frame = 115 - self.walkframe;
  self.walkframe = self.walkframe + 1;
  ai_face();
  ai_charge(FL_SWIM);
  if (self.walkframe > 5 && self.walkframe < 9) {
    ai_melee();
    }
}

Void function baron_smash();
{
  if (self.walkframe >= 12) {
    self.walkframe = 0;
    baron_run1();
    exit;
    }
  if (self.walkframe == 8) {
    demon_melee(150);
    if (random() > 0.9) {
      self.walkframe = 0;
      baron_fling();
      #77 baron_throw;
      exit;
      }
    }
  #67 baron_smash;
  self.frame = 67 + self.walkframe;
  self.walkframe = self.walkframe + 1;
  ai_charge(2);
}

Void function baron_throw();
{
  if (self.walkframe >= 11) {
    self.walkframe = 0;
    baron_run1();
    exit;
    }
  #68 baron_throw;
  self.frame = 78 - self.walkframe;
  self.walkframe = self.walkframe + 1;
  ai_face();
}

Void function baron_jump();
{
  self.walkframe = 0;
  self.cnt = 0;
  baron_jumpup();
}

Void function baron_jumpup();
{
  if (self.walkframe >= 6) {
    self.walkframe = 1;
    self.cnt = self.cnt + 1;
    if (self.cnt > 1) {
      baron_run1();
      exit;
      }
    }
  #125 baron_jumpup;
  if (self.cnt == 0) {
    self.frame = 130 - self.walkframe;
    if (self.walkframe == 3) {
      makevectors(self.angles);
      self.origin_z = self.origin_z + 1;
      self.velocity = v_forward * 400 + [0 0 300];
      if (self.flags & FL_ONGROUND) {
        self.flags = self.flags - FL_ONGROUND;
        }
      }
    }
  else {
    self.frame = 125 + self.walkframe;
    }
  self.walkframe = self.walkframe + 1;
  ai_face();
}

Void function baron_pain(attacker : Object; damage : Real);
{
  if (self.pain_finished > time) {
    exit;
    }
  if (random() * SVC_INTERMISSION > damage) {
    exit;
    }
  self.pain_finished = time + 1;
  if (random() < 0.4) {
    baron_pain1();
    }
  else {
    baron_bigpain1();
    }
}

Void function baron_pain1();
{
  #43 baron_pain2;
}

Void function baron_pain2();
{
  #42 baron_pain3;
}

Void function baron_pain3();
{
  #41 baron_run1;
}

Void function baron_bigpain1();
{
  #99 baron_bigpain2;
  sound(self, CHAN_WEAPON, "baron/bpain1.wav", 1, ATTN_NORM);
}

Void function baron_bigpain2();
{
  #100 baron_bigpain3;
}

Void function baron_bigpain3();
{
  #101 baron_bigpain4;
}

Void function baron_bigpain4();
{
  #102 baron_run1;
}

Void function baron_death();
{
  if (self.health < -50) {
    sound(self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
    ThrowGib("progs/gib1.mdl", self.health);
    ThrowGib("progs/gib2.mdl", self.health);
    ThrowGib("progs/gib3.mdl", self.health);
    remove(self);
    exit;
    }
  sound(self, CHAN_WEAPON, "baron/death.wav", 1, ATTN_NORM);
  if (random() < 0.3) {
    baron_diea1();
    exit;
    }
  baron_dieb1();
}

Void function baron_diea1();
{
  #44 baron_diea2;
}

Void function baron_diea2();
{
  #45 baron_diea3;
}

Void function baron_diea3();
{
  #46 baron_diea4;
  self.solid = SOLID_NOT;
}

Void function baron_diea4();
{
  #47 baron_diea5;
}

Void function baron_diea5();
{
  #48 baron_diea6;
}

Void function baron_diea6();
{
  #49 corpse_think;
}

Void function baron_dieb1();
{
  #50 baron_dieb2;
}

Void function baron_dieb2();
{
  #51 baron_dieb3;
}

Void function baron_dieb3();
{
  #52 baron_dieb4;
}

Void function baron_dieb4();
{
  #53 baron_dieb5;
  self.solid = SOLID_NOT;
}

Void function baron_dieb5();
{
  #54 baron_dieb6;
}

Void function baron_dieb6();
{
  #55 corpse_think;
}

Void function monster_baron();
{
  if (deathmatch) {
    remove(self);
    exit;
    }
  total_monsters = total_monsters + 1;
  precache_model2("progs/baron.mdl");
  precache_model2("progs/k_spike.mdl");
  precache_sound2("baron/sight.wav");
  precache_sound2("hknight/attack1.wav");
  precache_sound2("hknight/idle.wav");
  precache_sound2("baron/throb.wav");
  precache_sound2("baron/smash.wav");
  precache_sound2("baron/death.wav");
  precache_sound2("baron/woosh.wav");
  precache_sound2("baron/bpain1.wav");
  if (!(self.brain & NAVLOGIC)) {
    self.brain = self.brain | NAVLOGIC;
    }
  if (!(self.brain & NO_SWIM)) {
    self.brain = self.brain | NO_SWIM;
    }
  self.th_stand = baron_idle;
  self.th_walk = baron_walk;
  self.th_run = baron_draw;
  self.th_wins = baron_wins;
  self.th_melee = baron_melee;
  self.th_missile = baron_lrange;
  self.th_pain = baron_pain;
  self.th_die = baron_death;
  if (self.brain & TRIGGER_SPAWN) {
    self.use = baron_gostart;
    exit;
    }
  carnify_baron();
}

Void function baron_gostart();
{
  carnify_baron();
}

Void function carnify_baron();
{
  self.solid = SOLID_SLIDEBOX;
  self.movetype = MOVETYPE_STEP;
  setmodel(self, "progs/baron.mdl");
  setsize(self, VEC_HULL_MIN, [16 16 40]);
  if (!(self.health)) {
    self.health = 500;
    }
  walkmonster_start();
}

Void function monster_qforge();
{
  if (deathmatch) {
    remove(self);
    exit;
    }
  precache_model("progs/forqguy.mdl");
  precache_sound("forge/fline1.wav");
  precache_sound("forge/fline2.wav");
  precache_sound("forge/fline3.wav");
  precache_sound("forge/fline4.wav");
  precache_sound("forge/fline5.wav");
  precache_sound("forge/fline6.wav");
  self.impulse = 0;
  self.cnt = 0;
  self.state = 0;
  self.solid = SOLID_NOT;
  self.movetype = MOVETYPE_NONE;
  setmodel(self, "progs/forqguy.mdl");
  setsize(self, VEC_HULL_MIN, [16 16 40]);
  self.health = 90;
  self.use = qforge_spiel_go;
  self.th_stand = qforge_begin;
  self.th_walk = qforge_wait;
  self.th_die = qforge_die;
  walkmonster_start();
}

Void function qforge_spiel_go();
{
  self.use = Sub_Null;
  spawn_qforgespeak();
  self.state = 1;
}

Void function qforge_begin();
{
  self.takedamage = DAMAGE_NO;
  self.use = qforge_spiel_go;
  qforge_wait();
}

Void function qforge_wait();
{
  if (self.state > 0) {
    self.walkframe = 0;
    qforge_lookup();
    exit;
    }
  if (self.walkframe >= 5) {
    self.walkframe = 0;
    if (random() < 0.2) {
      qforge_stir();
      exit;
      }
    }
  #0 qforge_wait;
  self.frame = self.walkframe;
  self.walkframe = self.walkframe + 1;
}

Void function qforge_stir();
{
  if (self.state > 0) {
    self.walkframe = 0;
    qforge_lookup();
    exit;
    }
  if (self.walkframe >= 9) {
    self.walkframe = 0;
    qforge_wait();
    exit;
    }
  #5 qforge_stir;
  self.frame = 5 + self.walkframe;
  self.walkframe = self.walkframe + 1;
}

Void function qforge_lookup();
{
  if (self.walkframe >= 7) {
    self.walkframe = 0;
    if (self.state == 1) {
      qforge_uptalk();
      self.state = 2;
      exit;
      }
    else {
      self.health = 0;
      self.th_die();
      exit;
      }
    }
  #14 qforge_lookup;
  if (self.state == 1) {
    self.frame = 14 + self.walkframe;
    }
  else {
    self.frame = 20 - self.walkframe;
    }
  self.walkframe = self.walkframe + 1;
}

Void function qforge_uptalk();
{
  if (self.state > 2) {
    self.walkframe = 0;
    qforge_lookup();
    exit;
    }
  if (self.walkframe >= 4) {
    self.walkframe = 0;
    }
  #21 qforge_uptalk;
  self.frame = 21 + self.walkframe;
  self.walkframe = self.walkframe + 1;
}

Void function qforge_die();
{
  #25 qforge_die2;
  self.solid = SOLID_NOT;
}

Void function qforge_die2();
{
  #26 qforge_die3;
}

Void function qforge_die3();
{
  #27 qforge_die4;
}

Void function qforge_die4();
{
  #28 qforge_die5;
}

Void function qforge_die5();
{
  #29 qforge_die6;
}

Void function qforge_die6();
{
  #30 qforge_die6;
}

Void function spawn_qforgespeak();
var
 mark : Object;
{
  mark = spawn();
  setorigin(mark, self.origin);
  mark.cnt = 0;
  mark.owner = self;
  mark.blink = 0;
  mark.think = qforge_talk;
  mark.nextthink = time + 0.3;
}

Void function qforge_talk();
{
  self.cnt = self.cnt + 1;
  if (self.cnt == 1) {
    sound(self, CHAN_AUTO, "forge/fline1.wav", 1, ATTN_IDLE);
    self.blink = 4;
    }
  if (self.cnt == 2) {
    sound(self, CHAN_AUTO, "forge/fline2.wav", 1, ATTN_IDLE);
    self.blink = 8;
    }
  if (self.cnt == 3) {
    sound(self, CHAN_AUTO, "forge/fline3.wav", 1, ATTN_IDLE);
    self.blink = 7;
    }
  if (self.cnt == 4) {
    sound(self, CHAN_AUTO, "forge/fline4.wav", 1, ATTN_IDLE);
    self.blink = 4;
    }
  if (self.cnt == 5) {
    sound(self, CHAN_AUTO, "forge/fline5.wav", 1, ATTN_IDLE);
    self.blink = 3;
    }
  if (self.cnt == 6) {
    sound(self, CHAN_AUTO, "forge/fline6.wav", 1, ATTN_IDLE);
    self.blink = 0.1;
    }
  if (self.cnt > 6) {
    self.owner.state = self.owner.state + 1;
    remove(self);
    exit;
    }
  self.think = qforge_talk;
  self.nextthink = time + self.blink;
}

Void function monster_labguy();
{
  if (deathmatch) {
    remove(self);
    exit;
    }
  precache_model("progs/lab1.mdl");
  precache_sound("player/udeath.wav");
  self.classname = "monster_qguy";
  self.skin = 3;
  self.blink = 0;
  self.th_stand = lab_idle;
  self.th_walk = lab_walk;
  self.th_run = lab_run;
  self.th_die = lab_die;
  self.solid = SOLID_SLIDEBOX;
  self.movetype = MOVETYPE_STEP;
  setmodel(self, "progs/lab1.mdl");
  setsize(self, VEC_HULL_MIN, [16 16 40]);
  self.health = 50;
  walkmonster_start();
}

Void function lab_idle();
{
  self.state = 0;
  if (self.walkframe >= 6) {
    self.walkframe = 0;
    self.blink = self.blink + 1;
    if (self.blink > 4) {
      self.blink = 0;
      if (random() < 0.4) {
        lab_idleaction();
        exit;
        }
      }
    }
  #0 lab_idle;
  self.frame = 0 + self.walkframe;
  self.walkframe = self.walkframe + 1;
  npc_stand();
}

Void function lab_idleaction();
var
 num : Real;
{
  self.state = 0;
  num = random() + random();
  if (num < 0.5) {
    lab_looking();
    exit;
    }
  if (num < 1.0) {
    lab_lookdown();
    exit;
    }
  if (num < 1.5) {
    lab1_control();
    exit;
    }
  lab2_control();
}

Void function lab_looking();
{
  if (self.walkframe >= 5) {
    self.walkframe = 0;
    if (self.state == 0) {
      self.state = 1;
      }
    else {
      self.state = 0;
      lab_looking2();
      exit;
      }
    }
  #6 lab_looking;
  if (self.state == 0) {
    self.frame = 6 + self.walkframe;
    }
  else {
    self.frame = 10 - self.walkframe;
    }
  self.walkframe = self.walkframe + 1;
  npc_stand();
}

Void function lab_looking2();
{
  if (self.walkframe >= 5) {
    self.walkframe = 0;
    if (self.state == 0) {
      self.state = 1;
      }
    else {
      self.state = 0;
      lab_idle();
      exit;
      }
    }
  #11 lab_looking2;
  if (self.state == 0) {
    self.frame = 11 + self.walkframe;
    }
  else {
    self.frame = 15 - self.walkframe;
    }
  self.walkframe = self.walkframe + 1;
  npc_stand();
}

Void function lab_lookdown();
{
  if (self.walkframe >= 6) {
    self.walkframe = 0;
    if (self.state == 0) {
      self.state = 1;
      }
    else {
      self.state = 0;
      lab_idle();
      exit;
      }
    }
  #16 lab_lookdown;
  if (self.state == 0) {
    self.frame = 16 + self.walkframe;
    }
  else {
    self.frame = 21 - self.walkframe;
    }
  self.walkframe = self.walkframe + 1;
  npc_stand();
}

Void function lab1_control();
{
  if (self.walkframe >= 9) {
    self.walkframe = 0;
    if (self.state == 0) {
      self.state = 1;
      lab1_control2();
      exit;
      }
    else {
      self.state = 0;
      lab_idle();
      exit;
      }
    }
  #22 lab1_control;
  if (self.state == 0) {
    self.frame = 22 + self.walkframe;
    }
  else {
    self.frame = 30 - self.walkframe;
    }
  self.walkframe = self.walkframe + 1;
  npc_stand();
}

Void function lab1_control2();
{
  if (self.walkframe >= 9) {
    self.walkframe = 0;
    if (random() < 0.2) {
      lab1_control();
      exit;
      }
    }
  #31 lab1_control2;
  self.frame = 31 + self.walkframe;
  self.walkframe = self.walkframe + 1;
  npc_stand();
}

Void function lab2_control();
{
  if (self.walkframe >= 9) {
    self.walkframe = 0;
    if (self.state == 0) {
      self.state = 1;
      lab2_control2();
      exit;
      }
    else {
      self.state = 0;
      lab_idle();
      exit;
      }
    }
  #40 lab2_control;
  if (self.state == 0) {
    self.frame = 40 + self.walkframe;
    }
  else {
    self.frame = 48 - self.walkframe;
    }
  self.walkframe = self.walkframe + 1;
  npc_stand();
}

Void function lab2_control2();
{
  if (self.walkframe >= 5) {
    self.walkframe = 0;
    if (random() < 0.2) {
      lab2_control();
      exit;
      }
    }
  #49 lab2_control2;
  self.frame = 49 + self.walkframe;
  self.walkframe = self.walkframe + 1;
  npc_stand();
}

Void function lab_walk();
{
  if (self.walkframe >= 11) {
    self.walkframe = 0;
    }
  #67 lab_walk;
  self.frame = 67 + self.walkframe;
  self.walkframe = self.walkframe + 1;
  npc_walk(15);
}

Void function lab_die();
{
  self.solid = SOLID_NOT;
  lab_die2();
}

Void function lab_die2();
{
  if (self.walkframe >= 10) {
    self.think = corpse_think;
    self.nextthink = time + 12;
    exit;
    }
  #78 lab_die2;
  self.frame = 78 + self.walkframe;
  self.walkframe = self.walkframe + 1;
}

Void function lab_run();
{
  if (self.walkframe >= 6) {
    self.walkframe = 0;
    }
  #88 lab_run;
  self.frame = 88 + self.walkframe;
  self.walkframe = self.walkframe + 1;
  ai2_fleerun(30);
}

Void function npc_walk(dist : Real);
var
 mtemp : Vector;
{
  movedist = dist;
  if (self.objekt) {
    if (ai_objekt()) {
      self.th_stand();
      exit;
      }
    }
  if (self.goalentity == world) {
    self.th_stand();
    exit;
    }
  if (npc_threats()) {
    exit;
    }
  movetogoal(dist);
}

Void function npc_stand();
{
  if (self.objekt) {
    if (ai_objekt()) {
      exit;
      }
    }
  if (npc_threats()) {
    exit;
    }
  if (time < self.pausetime) {
    exit;
    }
  self.th_walk();
}

Void function npc_threats();
var
 head : Object;
 selected : Object;
{
  selected = world;
  head = find(world, soul, "yes");
  while (head) {
    if (head.enemy.classname == self.classname || head.enemy.classname == "player") {
      if (visible(head)) {
        selected = head;
        }
      }
    head = find(head, soul, "yes");
    }
  if (selected == world) {
    return 0;
    exit;
    }
  self.enemy = selected;
  self.th_run();
  return 1;
}


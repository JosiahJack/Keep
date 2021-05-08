Void function wraith_checkenemy();
var
 head : Object;
{
  head = self.enemy;
  if (head == world) {
    return 0;
    exit;
    }
  if (head.health < self.health || head.weapon < 8) {
    if (head.ammo_rockets < 1) {
      return 1;
      exit;
      }
    }
  return 0;
}

Void function wraith_2normal();
{
  self.th_stand = wraith_idle1;
  self.th_walk = wraith_motion;
  self.th_run = wraith_motion;
  self.th_pain = wraith_pain;
  self.th_die = wraith_unform;
  self.solid = SOLID_TRIGGER;
  self.effects = self.effects - (self.effects & EF_DIMLIGHT);
  sound(self, CHAN_VOICE, "wraith/return.wav", 1, ATTN_NONE);
}

Void function wraith_2inv();
{
  self.th_stand = wraith_inv_idle;
  self.th_walk = wraith_inv_motion;
  self.th_run = wraith_inv_motion;
  self.solid = SOLID_NOT;
  self.effects = self.effects | EF_DIMLIGHT;
  sound(self, CHAN_VOICE, "wraith/return.wav", 1, ATTN_NONE);
}

Void function wraith_inv_idle();
{
  if (!Wraith_Find_Orphans()) {
    Seek_out_Soul();
    }
  if (self.enemy != world) {
    wraith_inv_motion();
    exit;
    }
  #0 wraith_inv_idle;
  if (random() < 0.3) {
    self.effects = self.effects | EF_MUZZLEFLASH;
    }
  if (random() > 0.95) {
    sound(self, CHAN_VOICE, "wraith/idle.wav", 1, ATTN_IDLE);
    }
}

Void function wraith_inv_motion();
var
 mspike : Real;
 wspike : Real;
{
  if (self.health < 60) {
    if (random() < 0.1) {
      T_Heal(self, 1, 1);
      }
    }
  else {
    if (wraith_checkenemy()) {
      wraith_comeback();
      exit;
      }
    if (self.rotate_type == 1) {
      sound(self.enemy, CHAN_VOICE, "wraith/speak.wav", 1, ATTN_IDLE);
      self.rotate_type = 0;
      }
    }
  if (self.enemy == world) {
    if (!Wraith_Find_Orphans()) {
      Seek_out_Soul();
      }
    }
  else {
    if (self.enemy.health < 1) {
      self.enemy = world;
      self.cnt = 0;
      }
    }
  if (self.enemy != world) {
    wraith_soul_proxim();
    if (self.cnt > 1 && self.enemy.classname == "soul_to_take") {
      sound(self, CHAN_VOICE, "wraith/talk1.wav", 1, ATTN_IDLE);
      self.cnt = 3;
      wraith_inv_souls();
      exit;
      }
    Wraith_Move();
    }
  else {
    if (self.goalentity != world) {
      self.goalentity = world;
      }
    }
  if (self.walkframe >= 14) {
    self.walkframe = 0;
    }
  #0 wraith_inv_motion;
  if (random() < 0.2) {
    self.effects = self.effects | EF_MUZZLEFLASH;
    }
}

Void function wraith_comeback();
{
  self.alpha = 0.8;
  wraith_comeback2();
}

Void function wraith_comeback2();
{
  if (self.walkframe >= 17) {
    self.walkframe = 0;
    wraith_2normal();
    wraith_motion();
    exit;
    }
  #103 wraith_comeback2;
  self.frame = 119 - self.walkframe;
  self.walkframe = self.walkframe + 1;
}

Void function wraith_attack1();
var
 num : Real;
{
  if (self.walkframe >= 6) {
    self.walkframe = 0;
    wraith_attack2();
    exit;
    }
  #79 wraith_attack1;
  self.frame = 79 + self.walkframe;
  self.walkframe = self.walkframe + 1;
  Wraith_move();
  if (self.walkframe > 3 && visible(self.enemy)) {
    num = self.walkframe - 6;
    wraith_spike(num);
    }
}

Void function wraith_attack2();
var
 num : Real;
{
  if (self.walkframe >= 6) {
    self.walkframe = 0;
    wraith_motion();
    exit;
    }
  #79 wraith_attack2;
  self.frame = 84 - self.walkframe;
  self.walkframe = self.walkframe + 1;
  Wraith_move();
  if (self.walkframe < 4 && visible(self.enemy)) {
    num = self.walkframe - 3;
    wraith_spike(num);
    }
}

Void function wraith_goinv();
{
  wraith_2inv();
  wraith_goinv2();
}

Void function wraith_goinv2();
{
  if (self.walkframe >= 17) {
    self.walkframe = 0;
    self.alpha = -1;
    wraith_inv_motion();
    exit;
    }
  #103 wraith_goinv2;
  self.frame = 103 + self.walkframe;
  self.walkframe = self.walkframe + 1;
}

Void function wraith_inv_souls();
{
  self.alpha = 0.8;
  wraith_inv_souls2();
}

Void function wraith_inv_souls2();
{
  if (self.walkframe >= 17) {
    self.walkframe = 0;
    wraith_2normal();
    wraith_souls();
    exit;
    }
  #103 wraith_inv_souls2;
  self.frame = 119 - self.walkframe;
  self.walkframe = self.walkframe + 1;
}

Void function Wraith_Move();
var
 s : Object;
 spot : Real;
 num : Real;
{
  ai_face();
  if (self.rotate_type == 0) {
    num = 5;
    }
  else {
    num = -3;
    }
  s = self.enemy;
  if (s.origin_x < self.origin_x) {
    self.origin_x = self.origin_x - num;
    }
  if (s.origin_x > self.origin_x) {
    self.origin_x = self.origin_x + num;
    }
  if (s.origin_y < self.origin_y) {
    self.origin_y = self.origin_y - num;
    }
  if (s.origin_y > self.origin_y) {
    self.origin_y = self.origin_y + num;
    }
  spot = s.origin_z + 40;
  if (self.origin_z < spot) {
    self.origin_z = self.origin_z + num;
    }
  if (self.origin_z > spot) {
    self.origin_z = self.origin_z - num;
    }
}

Void function wraith_spike(offset : Real);
var
 offang : Vector;
 org : Vector;
 vec : Vector;
{
  offang = vectoangles(self.enemy.origin - self.origin);
  offang_y = offang_y + offset * MOVETYPE_TOSS;
  makevectors(offang);
  org = self.origin + self.mins + self.size * 0.5 + v_forward * 20;
  org = org - [0 0 20];
  vec = normalize(v_forward);
  vec_z = 0 - vec_z + (random() - 0.5) * 0.1;
  launch_spike(org, vec);
  newmis.classname = "wraithspike";
  setmodel(newmis, "progs/wr_spike.mdl");
  setsize(newmis, VEC_ORIGIN, VEC_ORIGIN);
  newmis.velocity = vec * 300;
  sound(self, CHAN_WEAPON, "baron/throb.wav", 1, ATTN_IDLE);
}

Void function wraith_invisible();
{
  #0 wraith_invisible;
  if (self.enemy != world) {
    ai_run(6);
    }
  else {
    if (self.goalentity != world) {
      ai_walk(4);
      }
    else {
      ai_stand();
      }
    }
}

Void function wraith_idle1();
var
 mspike : Real;
 wspike : Real;
{
  if (!Wraith_Find_Orphans()) {
    Seek_out_Soul();
    }
  if (self.enemy != world) {
    wraith_motion();
    exit;
    }
  if (self.walkframe >= 23) {
    self.walkframe = 0;
    self.nojump = self.nojump + 1;
    if (self.nojump > 1) {
      self.nojump = 0;
      wraith_idle2();
      exit;
      }
    }
  #18 wraith_idle1;
  if (self.nojump == 0) {
    self.frame = 18 + self.walkframe;
    }
  else {
    self.frame = 40 - self.walkframe;
    }
  self.walkframe = self.walkframe + 1;
  if (self.walkframe == 12) {
    if (random() < 0.3) {
      sound(self, CHAN_DAMAUL, "wraith/idle.wav", 1, ATTN_IDLE);
      }
    else {
      sound(self, CHAN_DAMAUL, "wraith/weird.wav", 1, ATTN_IDLE);
      }
    }
}

Void function wraith_idle2();
var
 mspike : Real;
 wspike : Real;
{
  if (!Wraith_Find_Orphans()) {
    Seek_out_Soul();
    }
  if (self.enemy != world) {
    wraith_motion();
    exit;
    }
  if (self.walkframe >= 23) {
    self.walkframe = 0;
    self.nojump = self.nojump + 1;
    if (self.nojump > 1) {
      self.nojump = 0;
      wraith_idle1();
      exit;
      }
    }
  #42 wraith_idle2;
  if (self.nojump == 0) {
    self.frame = 42 + self.walkframe;
    }
  else {
    self.frame = 63 - self.walkframe;
    }
  self.walkframe = self.walkframe + 1;
  if (self.walkframe == 8 || self.walkframe == 18) {
    if (random() < 0.2) {
      sound(self, CHAN_VOICE, "wraith/idle.wav", 1, ATTN_IDLE);
      }
    }
}

Void function wraith_motion();
var
 mspike : Real;
 wspike : Real;
{
  if (self.health < 50) {
    wraith_goinv();
    exit;
    }
  if (self.health < 60) {
    if (random() < 0.1) {
      T_Heal(self, 1, 1);
      }
    }
  else {
    if (self.rotate_type == 1) {
      sound(self.enemy, CHAN_VOICE, "wraith/speak.wav", 1, ATTN_IDLE);
      self.rotate_type = 0;
      }
    }
  if (self.enemy == world) {
    if (!Wraith_Find_Orphans()) {
      Seek_out_Soul();
      }
    }
  else {
    if (self.enemy.health < 1) {
      self.enemy = world;
      self.cnt = 0;
      }
    }
  if (self.enemy != world) {
    wraith_soul_proxim();
    if (self.cnt > 1 && self.enemy.classname == "soul_to_take") {
      sound(self, CHAN_VOICE, "wraith/talk1.wav", 1, ATTN_IDLE);
      self.cnt = 3;
      wraith_souls();
      exit;
      }
    Wraith_Move();
    if (self.enemy.classname != "soul_to_take" && random() < 0.1) {
      if (random() < 0.5) {
        wraith_attack1();
        exit;
        }
      mspike = rint(self.walkframe / 6);
      wspike = 3 - mspike;
      wraith_spike(wspike);
      }
    }
  else {
    if (self.goalentity != world) {
      self.goalentity = world;
      }
    else {
      if (random() < 0.4) {
        if (random() < 0.5) {
          self.angles_y = self.angles_y + 15;
          }
        else {
          self.angles_y = self.angles_y - 15;
          }
        }
      }
    }
  if (self.walkframe >= 14) {
    self.walkframe = 0;
    }
  #66 wraith_motion;
  self.frame = 66 + self.walkframe;
  self.walkframe = self.walkframe + 1;
  if (self.walkframe == 25 || self.walkframe == 15) {
    if (random() < 0.3) {
      sound(self, CHAN_VOICE, "wraith/idle.wav", 1, ATTN_IDLE);
      }
    }
}

Void function Spawn_Wraithgunk(org : Vector; vel : Vector; damage : Real);
{
  if (self.classname == "gunk") {
    particle(self.origin, [0 0 1], 152, 25);
    particle(self.origin, [-20 -20 -5], 158, 25);
    }
  else {
    particle(self.origin, [0 0 1], 80, 25);
    particle(self.origin, [-20 -20 -5], 48, 25);
    }
  self.cnt = self.cnt + 1;
  if (self.cnt > 30) {
    self.think = SUB_Remove;
    self.nextthink = time + 0.010000;
    exit;
    }
  self.nextthink = time + 0.050000;
}

Void function wraith_throws_gunk();
var
 gunk : Object;
 n : Real;
{
  n = 0;
  gunk = find(world, classname, "gunk");
  while (gunk) {
    n = n + 1;
    gunk = find(gunk, classname, "gunk");
    }
  if (n > 3) {
    exit;
    }
  gunk = spawn();
  gunk.origin = self.origin + [0 0 24];
  if (self.classname == "monster_wraith") {
    gunk.classname = "gunk";
    }
  gunk.velocity_z = 300;
  gunk.velocity_x = -100 + random() * 200;
  gunk.velocity_y = -100 + random() * 200;
  gunk.solid = SOLID_NOT;
  gunk.cnt = 0;
  gunk.movetype = MOVETYPE_TOSS;
  gunk.nextthink = time + 0.010000;
  gunk.think = Spawn_Wraithgunk;
}

Void function wraith_unform();
{
  self.walkframe = 0;
  #51 wraith_dissipate;
}

Void function wraith_dissipate();
{
  if (self.walkframe >= 17) {
    remove(self);
    exit;
    }
  if (self.walkframe == 9) {
    if (random() < 0.2) {
      sound(self, CHAN_VOICE, "wraith/talk3.wav", 1, ATTN_IDLE);
      }
    else {
      sound(self, CHAN_VOICE, "wraith/call.wav", 1, ATTN_IDLE);
      }
    }
  #0 wraith_dissipate;
  wraith_throws_gunk();
  self.frame = 18 - self.walkframe;
  self.walkframe = self.walkframe + 1;
}

Void function monster_wraith();
{
  if (deathmatch) {
    remove(self);
    exit;
    }
  total_monsters = total_monsters + 1;
  self.alpha = 0.7;
  self.fullbright = 1;
  precache_model("progs/wraith.mdl");
  precache_model("progs/s_null.spr");
  precache_model("progs/wr_spike.mdl");
  precache_model("progs/soul.mdl");
  precache_sound("wraith/soul.wav");
  precache_sound("wraith/idle.wav");
  precache_sound("wraith/idle2.wav");
  precache_sound("baron/throb.wav");
  precache_sound("wraith/rych1.wav");
  precache_sound("wraith/call.wav");
  precache_sound("wraith/talk1.wav");
  precache_sound("wraith/weird.wav");
  precache_sound("wraith/speak.wav");
  precache_sound("wraith/growl2.wav");
  precache_sound("wraith/talk3.wav");
  precache_sound("wraith/return.wav");
  precache_sound("wraith/select.wav");
  self.solid = SOLID_TRIGGER;
  self.movetype = MOVETYPE_NOCLIP;
  setmodel(self, "progs/wraith.mdl");
  setsize(self, VEC_HULL_MIN, [16 16 90]);
  if (!(self.health)) {
    self.health = 600;
    }
  self.brain = 0;
  if (self.targetname == "actor11" || self.targetname == "actor12") {
    self.th_stand = wraith_wait;
    self.th_walk = wraith_wait;
    }
  else {
    self.th_stand = wraith_idle1;
    self.th_walk = wraith_motion;
    }
  self.th_run = wraith_motion;
  self.th_pain = wraith_pain;
  self.th_die = wraith_unform;
  self.rotate_type = 0;
  self.nojump = 0;
  self.touch = death_aura;
  flymonster_start();
}

Void function death_aura();
var
 head : Object;
 selected : Object;
 dist : Real;
{
  if (other.health < 1) {
    exit;
    }
  if (other.flags & FL_CLIENT || other.flags & FL_MONSTER) {
    T_Damage(other, self, self, other.health);
    }
}

Void function wraith_wait();
{
  self.use = wraith_begin;
  if (self.walkframe >= 34) {
    self.walkframe = 0;
    }
  #0 wraith_wait;
  self.frame = 0 + self.walkframe;
  self.walkframe = self.walkframe + 1;
}

Void function wraith_begin();
{
  self.use = monster_use;
  self.th_stand = wraith_motion;
  self.th_walk = wraith_motion;
  #0 wraith_motion;
}

Void function wraith_pain();
var
 num : Real;
{
  num = random();
  if (num < 0.3) {
    sound(self, CHAN_VOICE, "wraith/growl2.wav", 1, ATTN_IDLE);
    }
  else {
    if (num < 0.6) {
      sound(self, CHAN_VOICE, "wraith/idle2.wav", 1, ATTN_IDLE);
      }
    }
  if (self.health < 60) {
    self.rotate_type = 1;
    }
  wraith_throws_gunk();
  if (random() < 0.4) {
    #79 wraith_motion;
    exit;
    }
  if (self.pain_finished > time) {
    exit;
    }
  self.pain_finished = time + 5;
  #86 wraith_pain2;
}

Void function wraith_pain2();
{
  #87 wraith_pain3;
}

Void function wraith_pain3();
{
  #88 wraith_pain4;
}

Void function wraith_pain4();
{
  #89 wraith_pain5;
}

Void function wraith_pain5();
{
  #90 wraith_pain6;
}

Void function wraith_pain6();
{
  #91 wraith_pain7;
}

Void function wraith_pain7();
{
  #92 wraith_motion;
}

Void function wraith_special();
{
  if (self.super_damage_finished > time) {
    self.effects = self.effects | EF_DIMLIGHT;
    }
  else {
    self.effects = self.effects - (self.effects & EF_DIMLIGHT);
    }
}

Void function wraith_zeda();
{
  #93 wraith_zeda1;
  ai_face();
}

Void function wraith_zeda1();
{
  #94 wraith_zeda2;
  ai_face();
}

Void function wraith_zeda2();
{
  #95 wraith_zeda3;
  ai_face();
}

Void function wraith_zeda3();
{
  #96 wraith_zeda4;
  ai_face();
}

Void function wraith_zeda4();
{
  #97 wraith_zeda5;
  ai_face();
}

Void function wraith_zeda5();
{
  #98 wraith_zeda6;
  ai_face();
}

Void function wraith_zeda6();
{
  #99 wraith_zeda7;
  ai_face();
}

Void function wraith_zeda7();
{
  #100 wraith_zeda8;
  ai_face();
}

Void function wraith_zeda8();
{
  #101 wraith_soulcheck;
  ai_face();
}

Void function wraith_soulcheck();
{
  if (self.enemy.classname != "soul_to_take") {
    self.cnt = 0;
    self.nojump = 0;
    self.enemy = world;
    #18 wraith_idle1;
    exit;
    }
  #100 wraith_xeda2;
  ai_face();
}

Void function wraith_xeda2();
{
  #99 wraith_xeda3;
  ai_face();
}

Void function wraith_xeda3();
{
  #98 wraith_zeda6;
}

Void function wraith_souls();
{
  if (self.enemy.classname != "soul_to_take") {
    self.cnt = 0;
    self.nojump = 0;
    self.enemy = world;
    wraith_idle1();
    exit;
    }
  wraith_zeda();
}

Void function Soul_to_take(mark : Object);
var
 soul : Object;
{
  if (mark.origin == [0 0 0]) {
    dprint("soul tried to spawn at [0 0 0]|");
    exit;
    }
  soul = spawn();
  soul.origin = mark.origin - [0 0 20];
  soul.objekt = mark;
  soul.owner = self;
  soul.enemy = self;
  self.enemy = soul;
  soul.solid = SOLID_TRIGGER;
  soul.health = 9000;
  soul.movetype = MOVETYPE_NOCLIP;
  soul.classname = "soul_to_take";
  soul.model = string_null;
  soul.effects = soul.effects | EF_DIMLIGHT;
  setsize(soul, VEC_HULL_MIN, [16 16 16]);
  soul.nextthink = time + 0.2;
  soul.think = Soul_Think;
}

Void function Soul_Think();
var
 dave : Vector;
 s : Object;
{
  s = self.enemy;
  s.enemy = self;
  if (s.cnt < 3) {
    self.think = Soul_Think;
    self.nextthink = time + 0.050000;
    exit;
    }
  if (self.model == string_null) {
    self.alpha = 0.3;
    self.fullbright = 1;
    setmodel(self, "progs/soul.mdl");
    }
  if (s.origin_x < self.origin_x) {
    self.origin_x = self.origin_x - 3;
    }
  if (s.origin_x > self.origin_x) {
    self.origin_x = self.origin_x + 3;
    }
  if (s.origin_y < self.origin_y) {
    self.origin_y = self.origin_y - 3;
    }
  if (s.origin_y > self.origin_y) {
    self.origin_y = self.origin_y + 3;
    }
  if (s.origin_z < self.origin_z + 10) {
    self.origin_z = self.origin_z - 2;
    }
  if (s.origin_z > self.origin_z + 10) {
    self.origin_z = self.origin_z + 2;
    }
  dave = self.enemy.origin - self.origin;
  if (vlen(dave) < 20) {
    s.enemy = world;
    s.cnt = 0;
    s.blink = -1;
    if (s.health < 1200) {
      s.health = s.health + 50;
      }
    self.classname == "eaten";
    sound(self.enemy, CHAN_VOICE, "wraith/rych1.wav", 1, ATTN_IDLE);
    remove(self);
    exit;
    }
  self.think = Soul_Think;
  self.nextthink = time + 0.050000;
}

Void function Seek_out_soul();
var
 head : Object;
 selected : Object;
 dist : Real;
{
  head = find(world, soul, "yes");
  while (head) {
    if (head.health < 1) {
      selected = head;
      }
    head = find(head, soul, "yes");
    }
  if (selected == world) {
    return 0;
    }
  else {
    selected.soul = "no";
    self.cnt = 1;
    self.enemy = selected;
    sound(self, CHAN_ITEM, "wraith/select.wav", 1, ATTN_IDLE);
    sound(selected, CHAN_BAL, "wraith/select.wav", 1, ATTN_IDLE);
    soul_to_take(selected);
    spawn_soulsound(selected);
    return 1;
    }
}

Real function Wraith_Find_Orphans();
var
 head : Object;
 selected : Object;
 dist : Real;
{
  dist = 1000;
  selected = world;
  head = findradius(self.origin, 1000);
  while (head) {
    if (head.classname == "soul_to_take" && head.owner == self) {
      if (visible(head) && trace_plane_dist < dist) {
        selected = head;
        dist = trace_plane_dist;
        }
      }
    head = head.chain;
    }
  if (selected == world) {
    return 0;
    }
  else {
    self.enemy = selected;
    self.cnt = 1;
    return 1;
    }
}

Void function wraith_soul_proxim();
var
 megadeth : Vector;
 corpse : Object;
{
  if (self.enemy.classname != "soul_to_take") {
    exit;
    }
  megadeth = self.enemy.origin - self.origin;
  if (vlen(megadeth) < 300) {
    self.cnt = 2;
    exit;
    }
  self.cnt = 1;
}

Void function spawn_soulsound(mark : Object);
var
 head : Object;
 num : Real;
{
  head = spawn();
  head.origin = mark.origin;
  num = 60 * random();
  head.think = make_soulsound;
  head.nextthink = time + num;
}

Void function make_soulsound();
{
  sound(self, CHAN_ENDER, "wraith/soul.wav", 1, ATTN_IDLE);
  self.think = Sub_remove;
  self.nextthink = time + 1.5;
}


Void function plat_spawn_inside_trigger();
var
 trigger : Object;
 tmin : Vector;
 tmax : Vector;
{
  trigger = spawn();
  trigger.touch = plat_center_touch;
  trigger.movetype = MOVETYPE_NONE;
  trigger.solid = SOLID_TRIGGER;
  trigger.enemy = self;
  tmin = self.mins + [25 25 0];
  tmax = self.maxs - [25 25 -8];
  tmin_z = tmax_z - (self.pos1_z - self.pos2_z + FL_CLIENT);
  if (self.spawnflags & PLAT_LOW_TRIGGER) {
    tmax_z = tmin_z + FL_CLIENT;
    }
  if (self.size_x <= 50) {
    tmin_x = (self.mins_x + self.maxs_x) / FL_SWIM;
    tmax_x = tmin_x + 1;
    }
  if (self.size_y <= 50) {
    tmin_y = (self.mins_y + self.maxs_y) / FL_SWIM;
    tmax_y = tmin_y + 1;
    }
  setsize(trigger, tmin, tmax);
}

Void function plat_hit_top();
{
  sound(self, CHAN_VOICE, self.noise1, 1, ATTN_NORM);
  self.state = STATE_TOP;
  self.think = plat_go_down;
  self.nextthink = self.ltime + MOVETYPE_WALK;
}

Void function plat_hit_bottom();
{
  sound(self, CHAN_VOICE, self.noise1, 1, ATTN_NORM);
  self.state = STATE_BOTTOM;
}

Void function plat_go_down();
{
  sound(self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
  self.state = STATE_DOWN;
  SUB_CalcMove(self.pos2, self.speed, plat_hit_bottom);
}

Void function plat_go_up();
{
  sound(self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
  self.state = STATE_UP;
  SUB_CalcMove(self.pos1, self.speed, plat_hit_top);
}

Void function plat_center_touch();
{
  if (other.classname != "player") {
    if (other.soul != "yes" && other.soul != "undead") {
      exit;
      }
    }
  if (other.health <= 0) {
    exit;
    }
  self = self.enemy;
  if (self.state == STATE_BOTTOM) {
    plat_go_up();
    }
  else {
    if (self.state == STATE_TOP) {
      self.nextthink = self.ltime + 1;
      }
    }
}

Void function plat_outside_touch();
{
  if (other.classname != "player") {
    if (other.soul != "yes" && other.soul != "undead") {
      exit;
      }
    exit;
    }
  if (other.health <= 0) {
    exit;
    }
  self = self.enemy;
  if (self.state == STATE_TOP) {
    plat_go_down();
    }
}

Void function plat_trigger_use();
{
  if (self.think) {
    exit;
    }
  plat_go_down();
}

Void function plat_crush();
{
  T_Damage(other, self, self, 1);
  if (self.state == STATE_UP) {
    plat_go_down();
    }
  else {
    if (self.state == STATE_DOWN) {
      plat_go_up();
      }
    else {
      objerror("plat_crush: bad self.state|");
      }
    }
}

Void function plat_use();
{
  self.use = SUB_Null;
  if (self.state != STATE_UP) {
    objerror("plat_use: not in up state");
    }
  plat_go_down();
}

Void function func_plat();
var
 t : Object;
{
  if (!(self.t_length)) {
    self.t_length = 80;
    }
  if (!(self.t_width)) {
    self.t_width = MOVETYPE_BOUNCE;
    }
  if (self.sounds == 0) {
    self.sounds = FL_SWIM;
    }
  if (self.sounds == 1) {
    precache_sound("plats/plat1.wav");
    precache_sound("plats/plat2.wav");
    self.noise = "plats/plat1.wav";
    self.noise1 = "plats/plat2.wav";
    }
  if (self.sounds == FL_SWIM) {
    precache_sound("plats/medplat1.wav");
    precache_sound("plats/medplat2.wav");
    self.noise = "plats/medplat1.wav";
    self.noise1 = "plats/medplat2.wav";
    }
  self.mangle = self.angles;
  self.angles = VEC_ORIGIN;
  self.classname = "plat";
  self.solid = SOLID_BSP;
  self.movetype = MOVETYPE_PUSH;
  setorigin(self, self.origin);
  setmodel(self, self.model);
  setsize(self, self.mins, self.maxs);
  self.blocked = plat_crush;
  if (!(self.speed)) {
    self.speed = 150;
    }
  self.pos1 = self.origin;
  self.pos2 = self.origin;
  if (self.height) {
    self.pos2_z = self.origin_z - self.height;
    }
  else {
    self.pos2_z = self.origin_z - self.size_z + FL_CLIENT;
    }
  self.use = plat_trigger_use;
  plat_spawn_inside_trigger();
  if (self.targetname) {
    self.state = STATE_UP;
    self.use = plat_use;
    }
  else {
    setorigin(self, self.pos2);
    self.state = STATE_BOTTOM;
    }
}

Void function train_blocked();
{
  if (time < self.attack_finished) {
    exit;
    }
  self.attack_finished = time + 0.5;
  T_Damage(other, self, self, self.dmg);
}

Void function train_use();
{
  if (self.think != func_train_find) {
    exit;
    }
  train_next();
}

Void function train_wait();
{
  if (self.wait) {
    if (self.wait < 0) {
      self.think = func_train_find;
      }
    else {
      self.think = train_next;
      }
    self.nextthink = self.ltime + self.wait;
    sound(self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
    exit;
    }
  else {
    self.nextthink = self.ltime + 0.1;
    }
  self.think = train_next;
}

Void function train_next();
var
 targ : Object;
 head : Object;
{
  targ = find(world, targetname, self.target);
  self.target = targ.target;
  if (!(self.target)) {
    objerror("train_next: no next target");
    }
  if (targ.wait) {
    self.wait = targ.wait;
    }
  else {
    self.wait = 0;
    }
  sound(self, CHAN_VOICE, self.noise1, 1, ATTN_NORM);
  if (self.targetname == "end_vader" && world.model == "maps/nehahra.bsp") {
    head = find(world, classname, "player");
    if (head != world) {
      if (head.groundentity == self) {
        self.speed = 8;
        }
      }
    }
  SUB_CalcMove(targ.origin - self.mins, self.speed, train_wait);
}

Void function func_train_find();
var
 targ : Object;
{
  targ = find(world, targetname, self.target);
  self.target = targ.target;
  setorigin(self, targ.origin - self.mins);
  if (!(self.targetname)) {
    self.nextthink = self.ltime + 0.1;
    self.think = train_next;
    }
}

Void function func_train();
{
  if (!(self.speed)) {
    self.speed = 100;
    }
  if (!(self.target)) {
    objerror("func_train without a target");
    }
  if (!(self.dmg)) {
    self.dmg = FL_SWIM;
    }
  if (self.sounds == 0) {
    self.noise = "misc/null.wav";
    precache_sound("misc/null.wav");
    self.noise1 = "misc/null.wav";
    precache_sound("misc/null.wav");
    }
  if (self.sounds == 1) {
    self.noise = "plats/train2.wav";
    precache_sound("plats/train2.wav");
    self.noise1 = "plats/train1.wav";
    precache_sound("plats/train1.wav");
    }
  if (self.sounds == 2) {
    self.noise = "doors/ddoor2.wav";
    precache_sound("doors/ddoor2.wav");
    self.noise1 = "doors/ddoor1.wav";
    precache_sound("doors/ddoor1.wav");
    }
  if (self.sounds == 3) {
    self.noise = "doors/airdoor2.wav";
    precache_sound("doors/airdoor2.wav");
    self.noise1 = "doors/airdoor1.wav";
    precache_sound("door/airdoor1.wav");
    }
  if (self.sounds == 4) {
    self.noise = "doors/basesec2.wav";
    precache_sound("doors/basesec2.wav");
    self.noise1 = "doors/basesec1.wav";
    precache_sound("doors/basesec1.wav");
    }
  if (self.sounds == 5) {
    self.noise = "doors/hydro2.wav";
    precache_sound("doors/hydro2.wav");
    self.noise1 = "doors/hydro1.wav";
    precache_sound("doors/hydro1.wav");
    }
  if (self.sounds == 6) {
    self.noise = "doors/stndr2.wav";
    precache_sound("doors/stndr2.wav");
    self.noise1 = "doors/stndr1.wav";
    precache_sound("doors/stndr1.wav");
    }
  if (self.cnt > 0) {
    pain_deathtype();
    }
  self.cnt = 1;
  self.solid = SOLID_BSP;
  self.movetype = MOVETYPE_PUSH;
  self.blocked = train_blocked;
  self.use = train_use;
  self.classname = "train";
  setmodel(self, self.model);
  setsize(self, self.mins, self.maxs);
  setorigin(self, self.origin);
  self.nextthink = self.ltime + 0.1;
  self.think = func_train_find;
}

Void function misc_teleporttrain();
{
  if (!(self.speed)) {
    self.speed = 100;
    }
  if (!(self.target)) {
    objerror("func_train without a target");
    }
  self.cnt = 1;
  self.solid = SOLID_NOT;
  self.movetype = MOVETYPE_PUSH;
  self.blocked = train_blocked;
  self.use = train_use;
  self.avelocity = [100 200 300];
  self.noise = "misc/null.wav";
  precache_sound("misc/null.wav");
  self.noise1 = "misc/null.wav";
  precache_sound("misc/null.wav");
  precache_model2("progs/teleport.mdl");
  setmodel(self, "progs/teleport.mdl");
  setsize(self, self.mins, self.maxs);
  setorigin(self, self.origin);
  self.nextthink = self.ltime + 0.1;
  self.think = func_train_find;
}


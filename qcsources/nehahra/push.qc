Void function experiment_push();
{
  if (other.classname != "player"){
    exit;
    }
  if (self.classname != "func_drift") {
    if (IsOnTopOf(other, self)) {
      exit;
      }
    if (self.pain_finished < time) {
      self.pain_finished = time + 0.6;
      sound(self, 7, "wall/push.wav", 1, ATTN_NORM);
      }
    if (self.flags & FL_ONGROUND) {
      self.flags = self.flags - FL_ONGROUND;
      }
    }
  makevectors(other.angles);
  self.velocity_x = other.velocity_x * 0.6;
  self.velocity_y = other.velocity_y * 0.6;
}

Void function func_pushable();
var
 new : Object;
 newsize : Vector;
{
  precache_sound("wall/push.wav");
  self.mangle = self.angles;
  self.angles = [0 0 0];
  self.classname = "pushwall";
  self.solid = SOLID_SLIDEBOX;
  self.movetype = MOVETYPE_STEP;
  setmodel(self, self.model);
  setorigin(self, self.origin);
  setsize(self, self.mins, self.maxs);
  self.touch = experiment_push;
}

Void function info_weight_switch();
{
  precache_sound("misc/trigger1.wav");
  self.cnt = 0;
  self.solid = SOLID_TRIGGER;
  setsize(self, [-16 -16 0], [16 16 56]);
  InitTrigger();
  self.touch = weight_sensor;
  self.think = weight_switch_think;
  self.nextthink = time + 0.5;
}

Void function weight_switch_think();
{
  if (self.cnt == 10) {
    self.nextthink = time + 99999;
    self.think = weight_switch_think;
    exit;
    }
  if (self.cnt != 0) {
    SUB_UseTargets();
    Wsensor_checkothers();
    }
  self.nextthink = time + 0.3;
  self.think = weight_switch_think;
}

Void function main_weight_switch();
{
  self.cnt = 0;
  self.think = mweight_think;
  self.nextthink = time + 0.1;
}

Void function mweight_think();
var
 head : Object;
{
  if (self.cnt == 99) {
    head = find(world, classname, "info_weight_switch");
    while (head) {
      remove(head);
      head = find(head, classname, "info_weight_switch");
      }
    SUB_UseTargets();
    remove(self);
    exit;
    }
  self.nextthink = time + 0.3;
  self.think = mweight_think;
}

Void function Wsensor_checkothers();
var
 kount : Real;
 t : Real;
 head : Object;
{
  t = 0;
  kount = 0;
  head = find(world, classname, "info_weight_switch");
  while (head) {
    if (head != self) {
      t = t + 1;
      }
    head = find(head, classname, "info_weight_switch");
    }
  if (t == 0) {
    head = find(world, classname, "main_weight_switch");
    if (head != world) {
      head.cnt = 99;
      self.cnt = 10;
      }
    return 1;
    exit;
    }
  remove(self);
}

Real function weight_sensor();
var
 head : Object;
 selected : Object;
 dist : Real;
 megadeth : Vector;
 dave : Vector;
{
  if (other.classname != "pushwall") {
    self.cnt = 0;
    exit;
    }
  other.touch = SUB_Null;
  sound(self, CHAN_ITEM, "misc/trigger1.wav", 1, ATTN_IDLE);
  self.cnt = 1;
}


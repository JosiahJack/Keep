Void function hurt_setdamage(ent : Object; amount : Real);
{
  ent.dmg = amount;
  if (amount) {
    ent.solid = SOLID_TRIGGER;
    }
  else {
    ent.solid = SOLID_NOT;
    }
  ent.nextthink = CONTENT_EMPTY;
}

Vector function SUB_NormalizeAngles(ang : Vector);
{
  while (ang_x > 360) {
    ang_x = ang_x - 360;
    }
  while (ang_x < 0) {
    ang_x = ang_x + 360;
    }
  while (ang_y > 360) {
    ang_y = ang_y - 360;
    }
  while (ang_y < 0) {
    ang_y = ang_y + 360;
    }
  while (ang_z > 360) {
    ang_z = ang_z - 360;
    }
  while (ang_z < 0) {
    ang_z = ang_z + 360;
    }
  return ang_x;
}

Void function info_rotate();
{
  self.nextthink = time + AS_SLIDING;
  self.think = SUB_Remove;
}

Void function RotateTargets();
var
 ent : Object;
 vx : Vector;
 vy : Vector;
 vz : Vector;
 org : Vector;
{
  makevectors(self.angles);
  ent = find(world, targetname, self.target);
  while (ent) {
    if (ent.rotate_type == OBJECT_SETORIGIN) {
      org = ent.oldorigin;
      vx = v_forward * org_x;
      vy = v_right * org_y;
      vy = vy * CONTENT_EMPTY;
      vz = v_up * org_z;
      ent.neworigin = vx + vy + vz;
      setorigin(ent, ent.neworigin + self.origin);
      }
    else {
      if (ent.rotate_type == OBJECT_ROTATE) {
        ent.angles = self.angles;
        org = ent.oldorigin;
        vx = v_forward * org_x;
        vy = v_right * org_y;
        vy = vy * CONTENT_EMPTY;
        vz = v_up * org_z;
        ent.neworigin = vx + vy + vz;
        setorigin(ent, ent.neworigin + self.origin);
        }
      else {
        org = ent.oldorigin;
        vx = v_forward * org_x;
        vy = v_right * org_y;
        vy = vy * CONTENT_EMPTY;
        vz = v_up * org_z;
        ent.neworigin = vx + vy + vz;
        ent.neworigin = self.origin - self.oldorigin + (ent.neworigin - ent.oldorigin);
        ent.velocity = (ent.neworigin - ent.origin) * 25;
        }
      }
    ent = find(ent, targetname, self.target);
    }
}

Void function RotateTargetsFinal();
var
 ent : Object;
{
  ent = find(world, targetname, self.target);
  while (ent) {
    ent.velocity = VEC_ORIGIN;
    if (ent.rotate_type == OBJECT_ROTATE) {
      ent.angles = self.angles;
      }
    ent = find(ent, targetname, self.target);
    }
}

Void function SetTargetOrigin();
var
 ent : Object;
{
  ent = find(world, targetname, self.target);
  while (ent) {
    if (ent.rotate_type == OBJECT_MOVEWALL) {
      setorigin(ent, self.origin - self.oldorigin + (ent.neworigin - ent.oldorigin));
      }
    else {
      setorigin(ent, ent.neworigin + self.origin);
      }
    ent = find(ent, targetname, self.target);
    }
}

Void function LinkRotateTargets();
var
 ent : Object;
 tempvec : Vector;
{
  self.oldorigin = self.origin;
  ent = find(world, targetname, self.target);
  while (ent) {
    if (ent.classname == "rotate_object") {
      ent.rotate_type = OBJECT_ROTATE;
      ent.oldorigin = ent.origin - self.oldorigin;
      ent.neworigin = ent.origin - self.oldorigin;
      ent.owner = self;
      }
    else {
      if (ent.classname == "func_movewall") {
        ent.rotate_type = OBJECT_MOVEWALL;
        tempvec = (ent.absmin + ent.absmax) * 0.5;
        ent.oldorigin = tempvec - self.oldorigin;
        ent.neworigin = ent.oldorigin;
        ent.owner = self;
        }
      else {
        ent.rotate_type = OBJECT_SETORIGIN;
        ent.oldorigin = ent.origin - self.oldorigin;
        ent.neworigin = ent.origin - self.oldorigin;
        }
      }
    ent = find(ent, targetname, self.target);
    }
}

Void function SetDamageOnTargets(amount : Real);
var
 ent : Object;
{
  ent = find(world, targetname, self.target);
  while (ent) {
    if (ent.classname == "trigger_hurt") {
      hurt_setdamage(ent, amount);
      }
    else {
      if (ent.classname == "func_movewall") {
        ent.dmg = amount;
        }
      }
    ent = find(ent, targetname, self.target);
    }
}

Void function rotate_entity_think();
var
 t : Real;
{
  t = time - self.ltime;
  self.ltime = time;
  if (self.state == STATE_SPEEDINGUP) {
    self.count = self.count + self.cnt * t;
    if (self.count > AS_STRAIGHT) {
      self.count = AS_STRAIGHT;
      }
    t = t * self.count;
    }
  else {
    if (self.state == STATE_SLOWINGDOWN) {
      self.count = self.count - self.cnt * t;
      if (self.count < 0) {
        RotateTargetsFinal();
        self.state = STATE_INACTIVE;
        self.think = SUB_Null;
        exit;
        }
      t = t * self.count;
      }
    }
  self.angles = self.angles + self.rotate * t;
  self.angles = SUB_NormalizeAngles(self.angles);
  RotateTargets();
  self.nextthink = time + 0.020000;
}

Void function rotate_entity_use();
{
  self.frame = AS_STRAIGHT - self.frame;
  if (self.state == STATE_ACTIVE) {
    if (self.spawnflags & TOGGLE) {
      if (self.speed) {
        self.count = AS_STRAIGHT;
        self.state = STATE_SLOWINGDOWN;
        }
      else {
        self.state = STATE_INACTIVE;
        self.think = SUB_Null;
        }
      }
    }
  else {
    if (self.state == STATE_INACTIVE) {
      self.think = rotate_entity_think;
      self.nextthink = time + 0.020000;
      self.ltime = time;
      if (self.speed) {
        self.count = 0;
        self.state = STATE_SPEEDINGUP;
        }
      else {
        self.state = STATE_ACTIVE;
        }
      }
    else {
      if (self.state == STATE_SPEEDINGUP) {
        if (self.spawnflags & TOGGLE) {
          self.state = STATE_SLOWINGDOWN;
          }
        }
      else {
        self.state = STATE_SPEEDINGUP;
        }
      }
    }
}

Void function rotate_entity_firstthink();
{
  LinkRotateTargets();
  if (self.spawnflags & START_ON2) {
    self.state = STATE_ACTIVE;
    self.think = rotate_entity_think;
    self.nextthink = time + 0.020000;
    self.ltime = time;
    }
  else {
    self.state = STATE_INACTIVE;
    self.think = SUB_Null;
    }
  self.use = rotate_entity_use;
}

Void function func_rotate_entity();
{
  self.solid = SOLID_NOT;
  self.movetype = MOVETYPE_NONE;
  setmodel(self, self.model);
  setsize(self, self.mins, self.maxs);
  if (self.speed) {
    self.cnt = AS_STRAIGHT / self.speed;
    }
  self.think = rotate_entity_firstthink;
  self.nextthink = time + 0.1;
  self.ltime = time;
  self.netname = "Rotating entity";
}

Void function path_rotate();
{
  if (self.noise) {
    precache_sound(self.noise);
    }
  if (self.noise1) {
    precache_sound(self.noise1);
    }
}

Void function rotate_train_think();
var
 t : Real;
 timeelapsed : Real;
{
  t = time - self.ltime;
  self.ltime = time;
  if (self.endtime && time >= self.endtime) {
    self.endtime = 0;
    if (self.state == STATE_MOVE) {
      setorigin(self, self.finaldest);
      self.velocity = VEC_ORIGIN;
      }
    if (self.think1) {
      self.think1();
      }
    }
  else {
    timeelapsed = (time - self.cnt) * self.duration;
    if (timeelapsed > AS_STRAIGHT) {
      timeelapsed = AS_STRAIGHT;
      }
    setorigin(self, self.dest1 + self.dest2 * timeelapsed);
    }
  self.angles = self.angles + self.rotate * t;
  self.angles = SUB_NormalizeAngles(self.angles);
  RotateTargets();
  self.nextthink = time + 0.020000;
}

Void function rotate_train_use();
{
  if (self.think1 != rotate_train_find) {
    if (self.velocity != VEC_ORIGIN) {
      exit;
      }
    if (self.think1) {
      self.think1();
      }
    }
}

Void function rotate_train_wait();
{
  self.state = STATE_WAIT;
  if (self.goalentity.noise) {
    sound(self, CHAN_VOICE, self.goalentity.noise, AS_STRAIGHT, ATTN_NORM);
    }
  else {
    sound(self, CHAN_VOICE, self.noise, AS_STRAIGHT, ATTN_NORM);
    }
  if (self.goalentity.spawnflags & ANGLES) {
    self.rotate = VEC_ORIGIN;
    self.angles = self.finalangle;
    }
  if (self.goalentity.spawnflags & NO_ROTATE) {
    self.rotate = VEC_ORIGIN;
    }
  self.endtime = self.ltime + self.goalentity.wait;
  self.think1 = rotate_train_next;
}

Void function rotate_train_stop();
{
  self.state = STATE_STOP;
  if (self.goalentity.noise) {
    sound(self, CHAN_VOICE, self.goalentity.noise, AS_STRAIGHT, ATTN_NORM);
    }
  else {
    sound(self, CHAN_VOICE, self.noise, AS_STRAIGHT, ATTN_NORM);
    }
  if (self.goalentity.spawnflags & ANGLES) {
    self.rotate = VEC_ORIGIN;
    self.angles = self.finalangle;
    }
  if (self.goalentity.spawnflags & NO_ROTATE) {
    self.rotate = VEC_ORIGIN;
    }
  self.dmg = 0;
  self.think1 = rotate_train_next;
}

Void function rotate_train_next();
var
 targ : Object;
 current : Object;
 vdestdelta : Vector;
 len : Real;
 traveltime : Real;
 div : Real;
 temp : String;
{
  self.state = STATE_NEXT;
  current = self.goalentity;
  targ = find(world, targetname, self.path);
  if (targ.classname != "path_rotate") {
    objerror("Next target is not path_rotate");
    }
  if (self.goalentity.noise1) {
    self.noise1 = self.goalentity.noise1;
    }
  sound(self, CHAN_VOICE, self.noise1, AS_STRAIGHT, ATTN_NORM);
  self.goalentity = targ;
  self.path = targ.target;
  if (!(self.path)) {
    objerror("rotate_train_next: no next target");
    }
  if (targ.spawnflags & STOP) {
    self.think1 = rotate_train_stop;
    }
  else {
    if (targ.wait) {
      self.think1 = rotate_train_wait;
      }
    else {
      self.think1 = rotate_train_next;
      }
    }
  if (current.event) {
    temp = self.target;
    self.target = current.event;
    self.message = current.message;
    SUB_UseTargets();
    self.target = temp;
    self.message = string_null;
    }
  if (current.spawnflags & ANGLES) {
    self.rotate = VEC_ORIGIN;
    self.angles = self.finalangle;
    }
  if (current.spawnflags & ROTATION) {
    self.rotate = current.rotate;
    }
  if (current.spawnflags & DAMAGE) {
    self.dmg = current.dmg;
    }
  if (current.spawnflags & SET_DAMAGE) {
    SetDamageOnTargets(current.dmg);
    }
  if (current.speed == CONTENT_EMPTY) {
    setorigin(self, targ.origin);
    self.endtime = self.ltime + 0.010000;
    SetTargetOrigin();
    if (targ.spawnflags & ANGLES) {
      self.angles = targ.angles;
      }
    self.duration = AS_STRAIGHT;
    self.cnt = time;
    self.dest2 = VEC_ORIGIN;
    self.dest1 = self.origin;
    self.finaldest = self.origin;
    }
  else {
    self.state = STATE_MOVE;
    self.finaldest = targ.origin;
    if (self.finaldest == self.origin) {
      self.velocity = VEC_ORIGIN;
      self.endtime = self.ltime + 0.1;
      self.duration = AS_STRAIGHT;
      self.cnt = time;
      self.dest2 = VEC_ORIGIN;
      self.dest1 = self.origin;
      self.finaldest = self.origin;
      exit;
      }
    vdestdelta = self.finaldest - self.origin;
    len = vlen(vdestdelta);
    if (current.spawnflags & MOVETIME) {
      traveltime = current.speed;
      }
    else {
      if (current.speed > 0) {
        self.speed = current.speed;
        }
      if (!(self.speed)) {
        objerror("No speed is defined!");
        }
      traveltime = len / self.speed;
      }
    if (traveltime < 0.1) {
      self.velocity = VEC_ORIGIN;
      self.endtime = self.ltime + 0.1;
      if (targ.spawnflags & ANGLES) {
        self.angles = targ.angles;
        }
      exit;
      }
    div = AS_STRAIGHT / traveltime;
    if (targ.spawnflags & ANGLES) {
      self.finalangle = SUB_NormalizeAngles(targ.angles);
      self.rotate = (targ.angles - self.angles) * div;
      }
    self.endtime = self.ltime + traveltime;
    self.velocity = vdestdelta * div;
    self.duration = div;
    self.cnt = time;
    self.dest2 = vdestdelta;
    self.dest1 = self.origin;
    }
}

Void function rotate_train_find();
var
 targ : Object;
{
  self.state = STATE_FIND;
  LinkRotateTargets();
  targ = find(world, targetname, self.path);
  if (targ.classname != "path_rotate") {
    objerror("Next target is not path_rotate");
    }
  self.goalentity = targ;
  if (targ.spawnflags & ANGLES) {
    self.angles = targ.angles;
    self.finalangle = SUB_NormalizeAngles(targ.angles);
    }
  self.path = targ.target;
  setorigin(self, targ.origin);
  SetTargetOrigin();
  RotateTargetsFinal();
  self.think1 = rotate_train_next;
  if (!(self.targetname)) {
    self.endtime = self.ltime + 0.1;
    }
  else {
    self.endtime = 0;
    }
  self.duration = AS_STRAIGHT;
  self.cnt = time;
  self.dest2 = VEC_ORIGIN;
  self.dest1 = self.origin;
}

Void function rotate_train();
{
  objerror("rotate_train entities should be changed to rotate_object with|func_rotate_train controllers|");
}

Void function func_rotate_train();
{
  if (!(self.speed)) {
    self.speed = 100;
    }
  if (!(self.target)) {
    objerror("rotate_train without a target");
    }
  if (!(self.noise)) {
    if (!(self.sounds)) {
      self.noise = "misc/null.wav";
      }
    if (self.sounds == AS_STRAIGHT) {
      self.noise = "plats/train2.wav";
      }
    }
  if (!(self.noise1)) {
    if (!(self.sounds)) {
      self.noise1 = "misc/null.wav";
      }
    if (self.sounds == AS_STRAIGHT) {
      self.noise1 = "plats/train1.wav";
      }
    }
  precache_sound(self.noise);
  precache_sound(self.noise1);
  self.cnt = AS_STRAIGHT;
  self.solid = SOLID_NOT;
  self.movetype = MOVETYPE_STEP;
  self.use = rotate_train_use;
  setmodel(self, self.model);
  setsize(self, self.mins, self.maxs);
  setorigin(self, self.origin);
  self.ltime = time;
  self.nextthink = self.ltime + 0.1;
  self.endtime = self.ltime + 0.1;
  self.think = rotate_train_think;
  self.think1 = rotate_train_find;
  self.state = STATE_FIND;
  self.duration = AS_STRAIGHT;
  self.cnt = 0.1;
  self.dest2 = VEC_ORIGIN;
  self.dest1 = self.origin;
  self.flags = self.flags | FL_ONGROUND;
  self.netname = "Rotating train";
}

Void function movewall_touch();
{
  if (time < self.owner.attack_finished) {
    exit;
    }
  if (self.dmg) {
    T_Damage(other, self, self.owner, self.dmg);
    self.owner.attack_finished = time + 0.5;
    }
  else {
    if (self.owner.dmg) {
      T_Damage(other, self, self.owner, self.owner.dmg);
      self.owner.attack_finished = time + 0.5;
      }
    }
}

Void function movewall_blocked();
var
 temp : Object;
{
  if (time < self.owner.attack_finished) {
    exit;
    }
  self.owner.attack_finished = time + 0.5;
  if (self.owner.classname == "func_rotate_door") {
    temp = self;
    self = self.owner;
    rotate_door_group_reversedirection();
    self = temp;
    }
  if (self.dmg) {
    T_Damage(other, self, self.owner, self.dmg);
    self.owner.attack_finished = time + 0.5;
    }
  else {
    if (self.owner.dmg) {
      T_Damage(other, self, self.owner, self.owner.dmg);
      self.owner.attack_finished = time + 0.5;
      }
    }
}

Void function movewall_think();
{
  self.ltime = time;
  self.nextthink = time + 0.020000;
}

Void function func_movewall();
{
  self.angles = VEC_ORIGIN;
  self.movetype = MOVETYPE_PUSH;
  if (self.spawnflags & NONBLOCKING) {
    self.solid = SOLID_NOT;
    self.blocked = movewall_blocked;
    }
  else {
    self.solid = SOLID_BSP;
    self.blocked = movewall_blocked;
    }
  if (self.spawnflags & TOUCH) {
    self.touch = movewall_touch;
    }
  setmodel(self, self.model);
  setmodel(self, self.model);
  if (!(self.spawnflags & VISIBLE2)) {
    self.model = string_null;
    }
  self.think = movewall_think;
  self.nextthink = time + 0.020000;
  self.ltime = time;
}

Void function rotate_object();
{
  self.classname = "rotate_object";
  self.solid = SOLID_NOT;
  self.movetype = MOVETYPE_NONE;
  setmodel(self, self.model);
  setsize(self, self.mins, self.maxs);
  self.think = SUB_Null;
  self.netname = "Rotating object";
}

Void function rotate_door_think2();
var
 t : Real;
{
  t = time - self.ltime;
  self.ltime = time;
  self.frame = AS_STRAIGHT - self.frame;
  self.angles = self.dest;
  if (self.state == STATE_OPENING) {
    self.state = STATE_OPEN;
    }
  else {
    if (self.spawnflags & STAYOPEN) {
      rotate_door_group_reversedirection();
      exit;
      }
    self.state = STATE_CLOSED;
    }
  sound(self, CHAN_VOICE, self.noise3, AS_STRAIGHT, ATTN_NORM);
  self.think = SUB_Null;
  RotateTargetsFinal();
}

Void function rotate_door_think();
var
 t : Real;
{
  t = time - self.ltime;
  self.ltime = time;
  if (time < self.endtime) {
    self.angles = self.angles + self.rotate * t;
    RotateTargets();
    }
  else {
    self.angles = self.dest;
    RotateTargets();
    self.think = rotate_door_think2;
    }
  self.nextthink = time + 0.010000;
}

Void function rotate_door_reversedirection();
var
 start : Vector;
{
  self.frame = AS_STRAIGHT - self.frame;
  if (self.state == STATE_CLOSING) {
    start = self.dest1;
    self.dest = self.dest2;
    self.state = STATE_OPENING;
    }
  else {
    start = self.dest2;
    self.dest = self.dest1;
    self.state = STATE_CLOSING;
    }
  sound(self, CHAN_VOICE, self.noise2, AS_STRAIGHT, ATTN_NORM);
  self.rotate = (self.dest - start) * (AS_STRAIGHT / self.speed);
  self.think = rotate_door_think;
  self.nextthink = time + 0.020000;
  self.endtime = time + self.speed - (self.endtime - time);
  self.ltime = time;
}

Void function rotate_door_group_reversedirection();
var
 name : String;
{
  if (self.group) {
    name = self.group;
    self = find(world, group, name);
    while (self) {
      rotate_door_reversedirection();
      self = find(self, group, name);
      }
    }
  else {
    rotate_door_reversedirection();
    }
}

Void function rotate_door_use();
var
 t : Object;
 start : Vector;
{
  if (self.state != STATE_OPEN && self.state != STATE_CLOSED) {
    exit;
    }
  if (!(self.cnt)) {
    self.cnt = AS_STRAIGHT;
    LinkRotateTargets();
    }
  self.frame = AS_STRAIGHT - self.frame;
  if (self.state == STATE_CLOSED) {
    start = self.dest1;
    self.dest = self.dest2;
    self.state = STATE_OPENING;
    }
  else {
    start = self.dest2;
    self.dest = self.dest1;
    self.state = STATE_CLOSING;
    }
  sound(self, CHAN_VOICE, self.noise2, AS_STRAIGHT, ATTN_NORM);
  self.rotate = (self.dest - start) * (AS_STRAIGHT / self.speed);
  self.think = rotate_door_think;
  self.nextthink = time + 0.010000;
  self.endtime = time + self.speed;
  self.ltime = time;
}

Void function func_rotate_door();
{
  if (!(self.target)) {
    objerror("rotate_door without target.");
    }
  self.dest1 = VEC_ORIGIN;
  self.dest2 = self.angles;
  self.angles = self.dest1;
  if (!(self.speed)) {
    self.speed = AS_SLIDING;
    }
  self.cnt = 0;
  if (!(self.dmg)) {
    self.dmg = AS_SLIDING;
    }
  else {
    if (self.dmg < 0) {
      self.dmg = 0;
      }
    }
  if (!(self.sounds)) {
    self.sounds = AS_STRAIGHT;
    }
  if (self.sounds == AS_STRAIGHT) {
    precache_sound("doors/latch2.wav");
    precache_sound("doors/winch2.wav");
    precache_sound("doors/drclos4.wav");
    self.noise1 = "doors/latch2.wav";
    self.noise2 = "doors/winch2.wav";
    self.noise3 = "doors/drclos4.wav";
    }
  else {
    if (self.sounds == AS_SLIDING) {
      precache_sound("doors/airdoor1.wav");
      precache_sound("doors/airdoor2.wav");
      self.noise2 = "doors/airdoor1.wav";
      self.noise1 = "doors/airdoor2.wav";
      self.noise3 = "doors/airdoor2.wav";
      }
    else {
      if (self.sounds == AS_MELEE) {
        precache_sound("doors/basesec1.wav");
        precache_sound("doors/basesec2.wav");
        self.noise2 = "doors/basesec1.wav";
        self.noise1 = "doors/basesec2.wav";
        self.noise3 = "doors/basesec2.wav";
        }
      }
    }
  self.solid = SOLID_NOT;
  self.movetype = MOVETYPE_NONE;
  setmodel(self, self.model);
  setorigin(self, self.origin);
  setsize(self, self.mins, self.maxs);
  self.state = STATE_CLOSED;
  self.use = rotate_door_use;
  self.think = SUB_Null;
  self.netname = "Rotating door";
}


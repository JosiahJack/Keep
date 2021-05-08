Void function SUB_Null();
{
}

Void function SUB_Remove();
{
  remove(self);
}

Void function SetMovedir();
{
  if (self.angles == [0 -1 0]) {
    self.movedir = [0 0 1];
    }
  else {
    if (self.angles == [0 -2 0]) {
      self.movedir = [0 0 -1];
      }
    else {
      makevectors(self.angles);
      self.movedir = v_forward;
      }
    }
  self.angles = VEC_ORIGIN;
}

Void function InitTrigger();
{
  if (self.angles != VEC_ORIGIN) {
    SetMovedir();
    }
  self.solid = SOLID_TRIGGER;
  setmodel(self, self.model);
  self.movetype = MOVETYPE_NONE;
  self.modelindex = 0;
  self.model = "";
}

Void function SUB_CalcMoveEnt(ent : Object; tdest : Vector; tspeed : Real; func : PFunc);
var
 stemp : Object;
{
  stemp = self;
  self = ent;
  SUB_CalcMove(tdest, tspeed, func);
  self = stemp;
}

Void function SUB_CalcMove(tdest : Vector; tspeed : Real; func : PFunc);
var
 vdestdelta : Vector;
 len : Real;
 traveltime : Real;
{
  if (!tspeed) {
    objerror("No speed is defined!");
    }
  self.think1 = func;
  self.finaldest = tdest;
  self.think = SUB_CalcMoveDone;
  if (tdest == self.origin) {
    self.velocity = VEC_ORIGIN;
    self.nextthink = self.ltime + 0.1;
    exit;
    }
  vdestdelta = tdest - self.origin;
  len = vlen(vdestdelta);
  traveltime = len / tspeed;
  if (traveltime < 0.1) {
    self.velocity = VEC_ORIGIN;
    self.nextthink = self.ltime + 0.1;
    exit;
    }
  self.nextthink = self.ltime + traveltime;
  self.velocity = vdestdelta * (1 / traveltime);
}

Void function SUB_CalcMoveDone();
{
  setorigin(self, self.finaldest);
  self.velocity = VEC_ORIGIN;
  self.nextthink = CONTENT_EMPTY;
  if (self.think1) {
    self.think1();
    }
}

Void function SUB_CalcAngleMoveEnt(ent : Object; destangle : Vector; tspeed : Real; func : PFunc);
var
 stemp : Object;
{
  stemp = self;
  self = ent;
  SUB_CalcAngleMove(destangle, tspeed, func);
  self = stemp;
}

Void function SUB_CalcAngleMove(destangle : Vector; tspeed : Real; func : PFunc);
var
 destdelta : Vector;
 len : Real;
 traveltime : Real;
{
  if (!tspeed) {
    objerror("No speed is defined!");
    }
  destdelta = destangle - self.angles;
  len = vlen(destdelta);
  traveltime = len / tspeed;
  self.nextthink = self.ltime + traveltime;
  self.avelocity = destdelta * (1 / traveltime);
  self.think1 = func;
  self.finalangle = destangle;
  self.think = SUB_CalcAngleMoveDone;
}

Void function SUB_CalcAngleMoveDone();
{
  self.angles = self.finalangle;
  self.avelocity = VEC_ORIGIN;
  self.nextthink = CONTENT_EMPTY;
  if (self.think1) {
    self.think1();
    }
}

Void function DelayThink();
{
  activator = self.enemy;
  SUB_UseTargets();
  remove(self);
}

Void function SUB_UseTargets();
var
 t : Object;
 stemp : Object;
 otemp : Object;
 act : Object;
{
  if (self.delay) {
    t = spawn();
    t.classname = "DelayedUse";
    t.nextthink = time + self.delay;
    t.think = DelayThink;
    t.enemy = activator;
    t.message = self.message;
    t.killtarget = self.killtarget;
    t.target = self.target;
    exit;
    }
  if (activator.classname == "player" && self.message != "") {
    centerprint(activator, self.message);
    if (!(self.noise)) {
      sound(activator, CHAN_VOICE, "misc/talk.wav", 1, ATTN_NORM);
      }
    }
  if (self.killtarget) {
    t = world;
    do {
      t = find(t, targetname, self.killtarget);
      if (!t) {
        exit;
        }
      remove(t);
      } while (1);
    }
  if (self.target != "") {
    act = activator;
    t = world;
    do {
      t = find(t, targetname, self.target);
      if (!t) {
        exit;
        }
      stemp = self;
      otemp = other;
      self = t;
      other = stemp;
      if (self.use != SUB_Null) {
        if (self.use) {
          self.use();
          }
        }
      self = stemp;
      other = otemp;
      activator = act;
      } while (1);
    }
}

Void function SUB_AttackFinished(normal : Real);
{
  self.cnt = 0;
  if (skill != MOVETYPE_WALK) {
    self.attack_finished = time + normal;
    }
}

Void function SUB_CheckRefire(thinkst : PFunc);
{
  if (skill != MOVETYPE_WALK) {
    exit;
    }
  if (self.cnt == 1) {
    exit;
    }
  if (!visible(self.enemy)) {
    exit;
    }
  self.cnt = 1;
  self.think = thinkst;
}

Void function Sub_NormalizeAngles(ang : Vector);
{
  if (ang.angles_x > 360) {
    ang.angles_x = ang.angles_x - 360;
    }
  if (ang.angles_x < 0) {
    ang.angles_x = ang.angles_x + 360;
    }
  if (ang.angles_y > 360) {
    ang.angles_y = ang.angles_y - 360;
    }
  if (ang.angles_y < 0) {
    ang.angles_y = ang.angles_y + 360;
    }
  if (ang.angles_z > 360) {
    ang.angles_z = ang.angles_z - 360;
    }
  if (ang.angles_z < 0) {
    ang.angles_z = ang.angles_z + 360;
    }
}

Void function Sub_CalcOrigin(mark : Object);
var
 spot : Vector;
{
  spot = mark.absmin + ((mark.absmax - mark.absmin) * 0.5);
  return spot;
}

Void function Sub_CardinalizeAngle(num : Real);
var
 not : Real;
{
  if (num < 135 && num > 44) {
    not = 90;
    }
  else {
    if (num < 225 && num > 134) {
      not = 180;
      }
    else {
      if (num < 335 && num > 224) {
        not = 270;
        }
      else {
        not = 0;
        }
      }
    }
  return not;
}


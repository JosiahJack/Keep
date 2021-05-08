Void function ai_retreat(dist : Real);
var
 num : Real;
{
  if (self.enemy.health < 1) {
    self.enemy = world;
    self.oldenemy = world;
    self.th_stand();
    exit;
    }
  flee_options();
  if (self.fangle == -1) {
    self.flags = self.flags - (self.flags & FL_FLEE);
    ai_run(dist);
    exit;
    }
  self.ideal_yaw = self.fangle;
  ChangeYaw();
  if (walkmove(self.fangle, dist) == FALSE) {
    num = at_ledge(self.fangle, self.origin);
    if (num > CONTENT_SLIME) {
      if (ai2_tracetoss(self.fangle, 200, [0 0 250])) {
        SightSound();
        ai2_jump(self.fangle, 200, [0 0 250]);
        ai_run(dist);
        exit;
        }
      }
    flee_options();
    if (self.fangle == -1) {
      self.flags = self.flags - (self.flags & FL_FLEE);
      ai_run(dist);
      exit;
      }
    }
}

Void function flee_options();
var
 num : Real;
 not : Real;
 judge : Vector;
 judy : Vector;
{
  judy = [-1 -1 -1];
  judge = judy;
  num = vectoyaw(self.enemy.origin - self.origin);
  if (visible(self.enemy)) {
    not = Sub_CardinalizeAngle(num);
    }
  else {
    not = -1;
    }
  if (not != 0) {
    judge = checkfleepath(0, judy);
    judy = judge;
    }
  if (not != 90) {
    judge = checkfleepath(90, judy);
    judy = judge;
    }
  if (not != 180) {
    judge = checkfleepath(180, judy);
    judy = judge;
    }
  if (not != 270) {
    judge = checkfleepath(270, judy);
    judy = judge;
    }
  if (judy_z > -1) {
    self.fangle = judy_z;
    }
}

Void function checkfleepath(num : Real; t : Vector);
var
 megadeth : Vector;
 points : Real;
{
  self.boost = 0;
  megadeth = self.origin;
  if (walkmove(num, 32)) {
    vispts();
    if (walkmove(num, 32)) {
      vispts();
      if (walkmove(num, 32)) {
        vispts();
        if (walkmove(num, 32)) {
          vispts();
          if (walkmove(num, 32)) {
            vispts();
            if (walkmove(num, 32)) {
              self.boost = self.boost + 1;
              if (walkmove(num, 32)) {
                self.boost = self.boost + 1;
                if (walkmove(num, 32)) {
                  self.boost = self.boost + 1;
                  }
                }
              }
            }
          }
        }
      }
    }
  if (vlen(self.origin - megadeth) < 300) {
    self.boost = 0;
    num = -1;
    }
  points = self.boost;
  self.boost = 0;
  self.origin = megadeth;
  if (points > t_y) {
    t_y = points;
    t_z = num;
    }
  return t;
}


Void function vispts();
{
  if (visible(self.enemy)) {
    self.boost = self.boost + 0.5;
    }
  else {
    self.boost = self.boost + 1;
    }
}



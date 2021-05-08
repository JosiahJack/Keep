Void function ai_threats();
var
 megadeth : Vector;
 threat : Object;
 pnt : Vector;
 spot1 : Vector;
 spot2 : Vector;
 traj : Vector;
 num : Real;
 dodge : Real;
 blah : Real;
 astri : String;
{
  if (panzy_mode == 1) {
    return 0;
    exit;
    }
  if (!(self.flags & FL_ONGROUND)) {
    if (self.classname != "monster_wizard") {
      return 0;
      exit;
      }
    }
  dodge = 0;
  astri = "thrett";
  if (self.enemy.classname != "player") {
    astri = "mthret";
    }
  threat = find(world, event, astri);
  if (threat != world) {
    if (threat.classname == "player" && threat.health > 0) {
      dodge_incoming(threat);
      if (self.th_runfire && visible(self.enemy) && self.tactic != 1) {
        self.tactic = 1;
        self.th_runfire();
        exit;
        }
      return 1;
      exit;
      }
    if (threat.owner.classname == "player") {
      if (threat.owner.health < 1) {
        return 0;
        exit;
        }
      }
    megadeth = threat.origin - self.origin;
    if (vlen(megadeth) < 1000) {
      num = fabs(threat.velocity_x) + fabs(threat.velocity_y);
      if (num > 20) {
        makevectors(threat.angles);
        spot1 = threat.origin;
        traj = normalize(threat.velocity);
        spot2 = threat.origin + (traj * 1000);
        traceline(spot1, spot2, 0, threat);
        megadeth = trace_endpos - self.origin;
        if (vlen(megadeth) < 400 || trace_ent == self) {
          dodge = 1;
          }
        }
      else {
        megadeth = threat.origin - self.origin;
        blah = vlen(megadeth);
        if (blah < 300) {
          if (blah < 150) {
            dodge = 2;
            }
          else {
            dodge = 3;
            }
          }
        }
      }
    }
  if (dodge == 0) {
    return 0;
    exit;
    }
  if (dodge == 1) {
    dodge_incoming(threat);
    }
  else {
    dodge_fixed(threat, dodge);
    }
  return 1;
}

Void function dodge_fixed(threat : Object; dodge: Real);
var
 megadeth : Vector;
 dave : Vector;
 t : Real;
 mr : Real;
 num : Real;
 g : Real;
{
  if (self.model == "progs/soldier.mdl") {
    g = 15;
    }
  else {
    g = 20;
    }
  mr = 0;
  ai_face();
  if (infront(threat)) {
    if (dodge == 2) {
      if (walkmove(self.angles_y, g) == FALSE) {
        mr = 1;
        }
      num = at_ledge(self.angles, self.origin);
      if (num == 0 && self.nojump == 0) {
        ai2_jump(self.angles, 200, [0 0 225]);
        exit;
        }
      }
    else { 
      megadeth = self.angles - [0 180 0];
      Sub_NormalizeAngles(megadeth);
      if (walkmove(megadeth_y, g) == FALSE) {
        if (panicjump(megadeth)) {
          exit;
          }
        mr = 1;
        num = at_ledge(megadeth, self.origin);
        if (num == 0 && self.nojump == 0) {
          ai2_jump(megadeth, -250, [0 0 225]);
          exit;
          }
        }
      }
    }
  else {
    if (walkmove(self.angles_y, g) == FALSE) {
      mr = 1;
      }
    num = at_ledge(self.angles, self.origin);
    if (num == 0 && self.nojump == 0) {
      ai2_jump(self.angles, 200, [0 0 225]);
      exit;
      }
    }
  t = vectoyaw(self.origin - threat.origin);
  if (walkmove(t, g) == FALSE) {
    dodge_cardinalize(t);
    }
}

Void function dodge_incoming(missile : Object);
var
 megadeth : Vector;
 mr : Real;
 num : Real;
 g : Real;
{
  if (self.model == "progs/soldier.mdl") {
    g = 15;
    }
  else {
    g = 20;
    }
  megadeth = VEC_ORIGIN;
  ai_face();
  if (infront(missile)) {
    if (walkmove(self.angles_y - 180, g) == FALSE) {
      mr = 1;
      }
    }
  else {
    if (walkmove(self.angles_y, g) == FALSE) {
      mr = 1;
      }
    }
  if (missile.classname == "player") {
    megadeth_y = Calc_Strafemove(missile, self);
    }
  else {
    megadeth_y = Calc_Dodgemove(missile, self);
    }
  if (walkmove(megadeth_y, g) == FALSE) {
    if (self.nojump == 0) {
      if (panicjump(megadeth)) { 
        ai2_jump(megadeth, 250, [0 0 250]);
        exit;
        }
      num = at_ledge(megadeth, self.origin);
      if (num > CONTENT_SLIME) {
        ai2_jump(megadeth, 250, [0 0 250]);
        exit;
        }
      }
    num = vectoyaw(self.origin - missile.origin);
    if (walkmove(num, g) == FALSE) {
      dprint("|");
      }
    }  
}

Void function dodge_cardinalize(num : Real);
var
 mr : Real;
 t : Real;
 dodge : Real;
 r : Real;
 vec : Vector;
{
  if (num > 360) {
    num = num - 360;
    }
  num = num + 90;
  dodge = rint(num / 90);
  r = (num / 90) - dodge;
  mr = dodge * 90;
  mr = mr - 90;
  t = mr - 90;
  if (r > 0) {
    dodge = mr;
    mr = t;
    t = dodge;
    }
  if (walkmove(mr, 15) == FALSE) {
    if (walkmove(t, 15) == FALSE) {
      vec = VEC_ORIGIN;
      vec_y = t;
      ai_ledgejump(vec, 0);
      }
    }
}

Void function Calc_Dodgemove(missile : Object; head : Object);
var
 dave : Vector;
 megadeth : Vector;
 num : Real;
{
  dave = normalize(head.origin - missile.origin);
  megadeth = normalize(missile.velocity);
  if (dave_y < megadeth_y) {
    num = megadeth_y - 90;
    }
  else {
    num = megadeth_y + 90;
    }
  if (num > 360) {
    num = num - 360;
    }
  else {
    if (num < 0) {
      num = num + 360;
      }
    }
  return num;
}

Void function Calc_Strafemove(missile : Object; head : Object);
var
 dave : Vector;
 megadeth : Vector;
 num : Real;
{
  dave = normalize(head.origin - missile.origin);
  makevectors(missile.angles);
  megadeth = normalize(v_forward * 6000);
  if (dave_y < megadeth_y) {
    num = megadeth_y - 90;
    }
  else {
    num = megadeth_y + 90;
    }
  if (num > 360) {
    num = num - 360;
    }
  else {
    if (num < 0) {
      num = num + 360;
      }
    }
  return num;
}

Void function panicjump(vec : Vector);
var
 start : Vector;
 end : Vector;
 num : Real;
{
  if (self.health > 10) {
    return 0;
    }
  if (self.nojump > 0) {
    return 0;
    }
  vec_x = 0;
  vec_z = 0;
  if (random() < 0.4) {
    vec_y = vec_y + 180;
    if (vec_y > 360) {
      vec_y = vec_y - 360;
      }
    }
  makevectors(vec);
  end = self.origin + v_forward * 75;
  traceline(self.origin, end, 1, self);
  if (trace_fraction == 1) {
    start = trace_endpos;
    end = start - [0 0 1500];
    traceline(start, end, 1, self); 
    if (trace_fraction > 0.1) {
      return 0;
      exit;
      }
    num = pointcontents(trace_endpos);
    if (num < CONTENT_WATER) {
      return 0;
      exit;
      }
    if (!(self.brain & NO_SWIM)) {
      if (num == CONTENT_WATER) {
        return 0;
        exit;
        }
      }
    }
  return 1;
}


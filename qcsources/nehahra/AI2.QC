Void function ai3_tracetoss(org : Vector ; min : Vector; max : Vector; vel : Vector; ignore : Object);
{
  if (!tracetossent) {
    tracetossent = spawn();
    }
  setorigin(tracetossent, org);
  setsize(tracetossent, min, max);
  tracetossent.velocity = vel;
  tracetoss(tracetossent, ignore);
}

Void function ai2_tracetoss(vec2 : Vector; t : Real; mustaine : Vector);
var
 megadeth : Vector;
 dave : Vector;
 vec : Vector;
 num : Real;
 case : Real;
{
  megadeth = self.velocity;
  makevectors(vec2);
  self.velocity = v_forward * t + mustaine;
  tracetoss(self, self);
  if (self.enemy) {
    if (trace_ent != world && trace_ent != self.enemy && trace_ent.classname != self.classname) {
      self.velocity = megadeth;
      return 0;
      }
    if (trace_endpos_z < self.enemy.origin_z) {
      num = self.enemy.origin_z - trace_endpos_z;
      if (num > 150) {
        self.velocity = megadeth;
        return 0;
        }
      }
    }
  dave = trace_endpos;
  vec = dave - [0 0 400];
  traceline(dave, vec, 0, self);
  num = pointcontents(trace_endpos);
  if (trace_fraction == 1 || num < CONTENT_SLIME) {
    self.velocity = megadeth;
    return 0;
    }
  if (self.brain & NO_SWIM && num < CONTENT_SOLID) {
    self.velocity = megadeth;
    return 0;
    }
  else {
    self.velocity = megadeth;
    return 1;
    }
}

Void function ai_ledgejump(megadeth : Vector; t : Real);
var
 num : Real;
{
  if (visible(self.enemy)) {
    if (ai2_check_z()) {
      num = at_ledge(megadeth, self.origin);
      if (num < CONTENT_WATER) {
        exit;
        }
      if (num == CONTENT_WATER) {
        if (self.brain & NO_SWIM) {
          exit;
          }
        }
      if (t == 0) {
        ai2_jump(megadeth, 200, [0 0 225]);
        }
      else {
        ai2_jump(megadeth, -200, [0 0 230]);
        }
      }
    }
}

Void function ai_teleport(head : Object; vec : Vector);
{
  spawn_tfog(head.origin);
  spawn_tdeath(vec, head);
  head.origin = vec;
  spawn_tfog(vec);
  setorigin(head, vec);
  head.flags = head.flags - (head.flags & FL_ONGROUND);
}

Void function ai_checkflee();
{
  if (self.health > 39 && self.flags & FL_FLEE) {
    self.flags = self.flags - FL_FLEE;
    }
  if (self.health < 40 && random() < 0.2) {
    if (!(self.flags & FL_FLEE)) {
      self.flags = self.flags | FL_FLEE;
      }
    }
}

Void function ai2_jumpsplash(num : Real; dave : Vector);
var
 megadeth : Vector;
{
  megadeth = self.enemy.origin - self.origin;
  if (vlen(megadeth) < 150) {
    if (self.flags & FL_ONGROUND) {
      makevectors(self.angles);
      self.origin_z = self.origin_z + 1;
      self.velocity = v_forward * num + dave;
      self.flags = self.flags - FL_ONGROUND;
      }
    }
}

Void function ai2_jump(vec : Vector; num : Real; dave : Vector);
{
  if (self.flags & FL_SWIM) {
    exit;
    }
  if (self.flags & FL_ONGROUND) {
    vec_x = 0;
    vec_z = 0;
    makevectors(vec);
    self.origin_z = self.origin_z + 1;
    self.velocity = v_forward * num + dave;
    self.flags = self.flags - FL_ONGROUND;
    }
}

Void function ai_emnity(foe : String; dist : Real; kind : Real);
var
 head : Object;
 megadeth : Vector;
 selected : Object;
{
  selected = world;
  head = find(world, classname, foe);
  while (head) {
    if (visible(head) && head.health > 0) {
      megadeth = head.origin - self.origin;
      if (vlen(megadeth) < dist) {
        selected = head;
        }
      }
    head = find(head, classname, foe);
    }
  if (selected == world) {
    return 0;
    exit;
    }
  if (kind == 0) {
    self.pain_finished = time + 0.6;
    T_Damage(self, selected, selected, 0.1);
    }
  else {
    self.objekt = head;
    }
  return 1;
}

Void function at_ledge(vec : Vector; vec2 : Vector);
var
 num : Real;
 spot1 : Vector;
 spot2 : Vector;
 start : Vector;
 end : Vector;
 megadeth : Vector;
 cont : Real;
{
  if (self.flags & FL_SWIM) {
    return -7;
    exit;
    }
  if (!(self.flags & FL_ONGROUND)) {
    return -7;
    exit;
    }
  megadeth = vec;
  megadeth_x = 0;
  megadeth_z = 0;
  makevectors(megadeth);
  spot1 = vec2 - [0 0 24];
  spot2 = vec2 + v_forward * 80;
  traceline(spot1, spot2, 1, self);
  if (trace_fraction < 1.0) {
    return -8;
    exit;
    }
  megadeth = spot1;
  spot1 = spot2 - [0 0 1000];
  traceline(spot2, spot1, 1, self);
  cont = pointcontents(trace_endpos);
  num = trace_endpos_z;
  if (trace_fraction >= 0.1) {
    start = megadeth;
    end = vec2 + v_forward * 175;
    traceline(start, end, 1, self);
    if (trace_fraction < 1) {
      return -9;
      exit;
      }
    start = trace_endpos;
    end = start - [0 0 1000];
    traceline(start, end, 1, self);
    if (trace_endpos_z == num) {
      if (pointcontents(trace_endpos) != cont) {
        return -10;
        exit;
        }
      return cont;
      exit;
      }
    }
  return -11;
}

Void function ai_mourndead();
var
 head : Object;
 selected : Object;
 megadeth : Vector;
 dist : Real;
{
  if (self.classname == "monster_gaunt") {
    if (self.event == "done") {
      return 0;
      exit;
      }
    }
  dist = 200;
  selected = world;
  head = find(world, classname, self.classname);
  while (head) {
    if (head.health < 1 && head != self) {
      if (head.relations != 66) {
        megadeth = self.origin - head.origin;
        if (vlen(megadeth) < 150) {
          selected = head;
          }
        }
      }
    head = find(head, classname, self.classname);
    }
  if (selected == world) {
    return 0;
    }
  else {
    if (self.classname != "monster_gaunt") {
      selected.relations = 66;
      }
    if(self.th_mourn) {
      self.th_mourn();
      }
    return 1;
    }
}

Void function ai_jagmourn();
var
 head : Object;
 selected : Object;
 megadeth : Vector;
 dist : Real;
{
  dist = 200;
  selected = world;
  head = find(world, classname, self.classname);
  while (head) {
    if (head.health < 1 && head != self) {
      if (head.relations < 12) {
        megadeth = self.origin - head.origin;
        if (vlen(megadeth) < 150) {
          selected = head;
          }
        }
      }
    head = find(head, classname, self.classname);
    }
  if (selected == world) {
    return 0;
    }
  else {
    selected.relations = selected.relations + 1;
    self.enemy = selected.enemy;
    self.th_mourn();
    return 1;
    }
}

Void function ai_check_z();
var
 num : Real;
 t : Real;
{
  if (self.origin_z < self.enemy.origin_z) {
    num = self.enemy.origin_z - self.origin_z;
    if (num > 80) {
      return 1;
      exit;
      }
    }
  return 0;
}

Void function ai2_check_z();
var
 num : Real;
 t : Real;
{
  if (self.classname == "monster_hknight") {
    if (self.watertype != self.enemy.watertype) {
      return 0;
      exit;
      }
    }
  if (self.origin_z > self.enemy.origin_z) {
    if (self.enemy.watertype > CONTENT_SLIME) {
      num = self.origin_z - self.enemy.origin_z;
      if (num > 80) {
        return 1;
        exit;
        }
      }
    else {
      self.nojump = 10;
      }
    }
  return 0;
}

Void function objekt_touch();
{
  if (self.enemy == world) {
    if (other.classname == "player" && self.enemy.classname != "player") {
      if (self.th_back) {
        self.objekt = other;
        self.touch = Sub_Null;
        self.th_back();
        }
      }
    }
}

Void function ai_objledge();
var
 num : Real;
 t : Real;
{
  if (self.nojump == 1) {
    exit;
    }
  if (self.origin_z > self.objekt.origin_z) {
    if (self.objekt.watertype > CONTENT_SLIME) {
      num = self.origin_z - self.objekt.origin_z;
      if (num > 80) {
        if (visible(self.objekt)) {
          ai_face_objekt();
          ai2_jump(self.ideal_yaw, 200, [0 0 225]);
          }
        }
      }
    }
}

Void function ai_checkobjdist(dist: Real);
var
 megadeth : Vector;
{
  megadeth = self.objekt.origin - self.origin;
  if (vlen(megadeth) < dist) {
    return 0;
    }
  else {
    return 1;
    }
}

Void function ai_checksmalldist();
var
 megadeth : Vector;
{
  if (!visible(self.enemy)) {
    return 0;
    exit;
    }
  megadeth = self.enemy.origin - self.origin;
  if (vlen(megadeth) < 100) {
    return 1;
    }
  else {
    return 0;
    }
}

Void function ai_checkdist();
var
 megadeth : Vector;
{
  if (self.th_melee && self.classname != "monster_cook") {
    return 0;
    exit;
    }
  if (!visible(self.enemy)) {
    return 0;
    exit;
    }
  megadeth = self.enemy.origin - self.origin;
  if (vlen(megadeth) < 200 && self.classname != "monster_zombie") {
    return 1;
    }
  else {
    return 0;
    }
}

Void function ai2_checkdist(mark : Object; dist : Real);
var
 megadeth : Vector;
{
  megadeth = mark.origin - self.origin;
  if (vlen(megadeth) < dist) {
    return 1;
    }
  else {
    return 0;
    }
}

Void function ai2_face(mark : Object);
{
  self.ideal_yaw = vectoyaw(mark.origin - self.origin);
  ChangeYaw();
}

Void function ai_face_goal();
{
  if (self.goalentity == world) {
    exit;
    }
  self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
  ChangeYaw();
}

Void function ai_face_objekt();
{
  self.ideal_yaw = vectoyaw(self.objekt.origin - self.origin);
  ChangeYaw();
}

Void function ai2_walk(dist : Real);
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
  movetogoal(dist);
}

Void function ai2_stand();
{
  if (self.objekt) {
    if (ai_objekt()) {
      exit;
      }
    }
  if (time < self.pausetime) {
    exit;
    }
  self.th_walk();
}

Void function ai2_run(dist : Real);
var
 delta : Vector;
 axis : Real;
 direct : Real;
 ang_rint : Real;
 ang_floor : Real;
 ang_ceil : Real;
 megadeth : Vector;
 pot : Real;
 vartns : Real;
 spot : Vector;
 putz : Object;
{
  if (self.relations == 4 && self.enemy.classname == "player") {
    self.enemy = world;
    self.oldenemy = world;
    self.goalentity = world;
    self.th_stand();
    exit;
    }
  movedist = dist;
  self.goalentity = self.enemy;
  if (self.objekt && self.enemy.enemy == self.objekt && !visible(self.enemy)) {
    self.enemy = world;
    self.oldenemy = world;
    self.goalentity = world;
    self.th_stand();
    exit;
    }
  megadeth = self.enemy.origin - self.origin;
  if (self.enemy.health <= 0) {
    putz = self.enemy;
    self.enemy = world;
    self.goalentity = world;
    self.objekt = world;
    if (self.th_wins && putz.classname == "player") {
      self.walkframe = 0;
      self.th_wins();
      exit;
      }
    if (self.oldenemy.health > 0) {
      self.enemy = self.oldenemy;
      HuntTarget();
      }
    else {
      if (self.movetarget) {
        self.th_walk();
        }
      else {
        self.th_stand();
        }
      exit;
      }
    }
  if (!(self.brain & NO_SWIM)) {
    if (self.watertype < CONTENT_SOLID) {
      monster_swim();
      }
    }
  self.show_hostile = time + 1;
  enemy_vis = visible(self.enemy);
  if (enemy_vis) {
    self.search_time = time + MOVETYPE_FLY;
    }
  if (coop && self.search_time < time) {
    if (FindTarget()) {
      exit;
      }
    }
  enemy_infront = infront(self.enemy);
  enemy_range = range(self.enemy);
  enemy_yaw = vectoyaw(self.enemy.origin - self.origin);
  if (!(self.brain & INTREPID)) {
    if (self.flags & FL_ONGROUND) {
      if (ai_threats()) {
        exit;
        }
      }
    if (vlen(megadeth) > 1000) {
      if (self.health < 40 && !visible(self.enemy)) {
        if (random() > 0.9) {
          self.enemy = world;
          self.oldenemy = world;
          self.th_stand();
          exit;
          }
        if (random() < 0.5) {
          T_Heal(self, 1, 1);
          }
        ai_back(8);
        }
      }
    if (self.health < 50 && self.health < self.enemy.health) {
      if (self.th_missile && walkmove(self.angles_y - 180, movedist) == 0) {
        if (random() > 0.6 && visible(self.enemy)) {
          self.th_missile();
          }
        ai_run_slide(10);
        }
      else {
        ai_back(8);
        }
      if (random() < 0.1) {
        T_Heal(self, 1, 1);
        }
      if (random() < 0.3 && visible(self.enemy)) {
        Checkanyattack();
        }
      }
    }
  if (self.nojump == 0) {
    ai_ledgejump(self.angles, 0);
    }
  if (self.attack_state == AS_MISSILE) {
    ai_run_missile(dist);
    exit;
    }
  if (self.attack_state == AS_MELEE) {
    ai_run_melee(dist);
    exit;
    }
  if (CheckAnyAttack()) {
    exit;
    }
  if (self.attack_state == AS_SLIDING) {
    ai_run_slide(0.1);
    exit;
    }
  if (self.classname != "monster_wizard") {
    movetogoal(dist);
    exit;
    }
  if (ai_checkdist()) {
    if (random() < 0.8) {
      if (walkmove(self.angles_y - 180, 15) == TRUE) {
        exit;
        }
      }
    }
  if (!(self.th_melee)) {
    if (ai2_checkdist(self.enemy, 250)) {
      if (visible(self.enemy)) {
        self.th_missile();
        exit;
        }
      }
    }
  if (self.brain & BLINK) {
    ai4_checkblink();
    }
  if (self.brain & NAVLOGIC) {
    if (ai4_strategy(dist)) {
      exit;
      }
    }
  movetogoal(dist);
}

Void function ai2_run_slide();
var
 ofs : Real;
{
  if (self.lefty) {
    ofs = 90;
    }
  else {
    ofs = -90;
    }
  if (walkmove(self.ideal_yaw + ofs, movedist)) {
    if (ofs == -90) {
      makevectors(self.angles);
      self.flags = self.flags - (self.flags & FL_ONGROUND);
      self.velocity = v_right * 160;
      }
    else {
      makevectors(self.angles);
      self.flags = self.flags - (self.flags & FL_ONGROUND);
      self.velocity = v_right * -160;
      }
    exit;
    }
  self.lefty = 1 - self.lefty;
  walkmove(self.ideal_yaw - ofs, movedist);
  if (ofs == -90) {
    makevectors(self.angles);
    self.flags = self.flags - (self.flags & FL_ONGROUND);
    self.velocity = v_right * 160;
    }
  else {
    makevectors(self.angles);
    self.flags = self.flags - (self.flags & FL_ONGROUND);
    self.velocity = v_right * -160;
    }
}

Void function ai3_pain(dist : Real);
{
  if (time < self.enemy.attack_finished) {
    ai_run_slide();
    exit;
    }
  ai_back(dist);
}

Void function ai3_run(dist : Real);
var
 delta : Vector;
 axis : Real;
 direct : Real;
 ang_rint : Real;
 ang_floor : Real;
 ang_ceil : Real;
 megadeth : Vector;
 pot : Real;
 vartns : Real;
 spot : Vector;
 putz : Object;
{
  if (self.relations == 4 && self.enemy.classname == "player") {
    self.enemy = world;
    self.oldenemy = world;
    self.goalentity = world;
    self.th_stand();
    exit;
    }
  movedist = dist;
  self.goalentity = self.enemy;
  if (self.objekt && self.enemy.enemy == self.objekt && !visible(self.enemy)) {
    self.enemy = world;
    self.oldenemy = world;
    self.goalentity = world;
    self.th_stand();
    exit;
    }
  megadeth = self.enemy.origin - self.origin;
  if (self.enemy.health <= 0) {
    putz = self.enemy;
    self.enemy = world;
    self.goalentity = world;
    self.objekt = world;
    if (self.th_wins && putz.classname == "player") {
      self.walkframe = 0;
      self.th_wins();
      exit;
      }
    if (self.oldenemy.health > 0) {
      self.enemy = self.oldenemy;
      HuntTarget();
      }
    else {
      if (self.movetarget) {
        self.th_walk();
        }
      else {
        self.th_stand();
        }
      exit;
      }
    }
  if (!(self.brain & NO_SWIM)) {
    if (self.watertype < CONTENT_SOLID) {
      monster_swim();
      }
    }
  self.show_hostile = time + 1;
  enemy_vis = visible(self.enemy);
  if (self.flags & FL_ONGROUND) {
    if (!(self.brain & INTREPID)) {
      if (ai_threats()) {
        exit;
        }
      }
    }
  if (enemy_vis) {
    self.search_time = time + MOVETYPE_FLY;
    }
  if (coop && self.search_time < time) {
    if (FindTarget()) {
      exit;
      }
    }
  enemy_infront = infront(self.enemy);
  enemy_range = range(self.enemy);
  enemy_yaw = vectoyaw(self.enemy.origin - self.origin);
  if (time < self.enemy.attack_finished) {
    if (self.enemy.weapon == IT_SWORD && visible(self.enemy)) {
      if (random() < 0.5) {
        self.th_missile();
        }
      ai_run_slide(2);
      }
    }
  if (!(self.brain & INTREPID)) {
    if (self.health < 15) {
      if (walkmove(self.angles_y - 180, 20) == 0) {
        ai_run_slide(9);
        }
      if (random() < 0.3 && visible(self.enemy)) {
        self.th_missile();
        }
      exit;
      }
    }
  if (self.nojump == 0) {
    ai_ledgejump(self.angles, 0);
    }
  if (self.attack_state == AS_MISSILE) {
    ai_run_missile(dist);
    exit;
    }
  if (self.attack_state == AS_MELEE) {
    ai_run_melee(dist);
    exit;
    }
  if (CheckAnyAttack()) {
    exit;
    }
  if (self.attack_state == AS_SLIDING) {
    ai_run_slide(0.1);
    exit;
    }
  if (ai_checkdist()) {
    ai_back(dist);
    exit;
    }
  if (!(self.th_melee)) {
    if (ai2_checkdist(self.enemy, 250)) {
      if (visible(self.enemy)) {
        self.th_missile();
        exit;
        }
      }
    }
  if (self.brain & BLINK) {
    ai4_checkblink();
    }
  if (self.brain & NAVLOGIC) {
    if (ai4_strategy(dist)) {
      exit;
      }
    }
  movetogoal(dist);
}

Void function ai4_run(dist : Real);
var
 delta : Vector;
 axis : Real;
 direct : Real;
 ang_rint : Real;
 ang_floor : Real;
 ang_ceil : Real;
 megadeth : Vector;
 pot : Real;
 vartns : Real;
 spot : Vector;
 putz : Object;
{
  if (self.relations == 4 && self.enemy.classname == "player") {
    self.enemy = world;
    self.oldenemy = world;
    self.goalentity = world;
    self.th_stand();
    exit;
    }
  movedist = dist;
  self.goalentity = self.enemy;
  if (self.objekt && self.enemy.enemy == self.objekt && !visible(self.enemy)) {
    self.enemy = world;
    self.oldenemy = world;
    self.goalentity = world;
    self.th_stand();
    exit;
    }
  megadeth = self.enemy.origin - self.origin;
  if (self.enemy.health <= 0) {
    putz = self.enemy;
    self.enemy = world;
    self.goalentity = world;
    self.objekt = world;
    if (self.oldenemy.health > 0) {
      self.enemy = self.oldenemy;
      HuntTarget();
      }
    else {
      if (self.movetarget) {
        self.th_walk();
        }
      else {
        self.th_stand();
        }
      exit;
      }
    }
  if (!(self.brain & NO_SWIM)) {
    if (self.watertype < CONTENT_SOLID) {
      monster_swim();
      }
    }
  self.show_hostile = time + 1;
  enemy_vis = visible(self.enemy);
  if (self.flags & FL_ONGROUND) {
    if (!(self.brain & INTREPID)) {
      if (ai_threats()) {
        exit;
        }
      }
    }
  if (enemy_vis) {
    self.search_time = time + MOVETYPE_FLY;
    }
  if (coop && self.search_time < time) {
    if (FindTarget()) {
      exit;
      }
    }
  enemy_infront = infront(self.enemy);
  enemy_range = range(self.enemy);
  enemy_yaw = vectoyaw(self.enemy.origin - self.origin);
  if (time < self.enemy.attack_finished) {
    if (self.enemy.weapon == IT_SWORD && visible(self.enemy)) {
      ai_run_slide(6);
      }
    }
  if (!(self.brain & INTREPID)) {
    if (self.health < 15) {
      if (walkmove(self.angles_y - 180, 20) == 0) {
        ai_run_slide(9);
        }
      exit;
      }
    }
  if (self.nojump == 0) {
    ai_ledgejump(self.angles, 0);
    }
  if (self.attack_state == AS_MISSILE) {
    ai_run_missile(dist);
    exit;
    }
  if (self.attack_state == AS_MELEE) {
    ai_run_melee(dist);
    exit;
    }
  if (self.attack_state == AS_SLIDING) {
    ai_run_slide(0.1);
    exit;
    }
  if (ai_checkdist()) {
    ai_back(dist);
    exit;
    }
  if (self.brain & BLINK) {
    ai4_checkblink();
    }
  if (self.brain & NAVLOGIC) {
    if (ai4_strategy(dist)) {
      exit;
      }
    }
  movetogoal(dist);
}

Void function Mons_consider();
var
 head : Object;
 selected : Object;
 dist : Real;
{
  dist = 180;
  selected = world;
  head = findradius(self.enemy.origin, 180);
  while (head) {
    if (trace_plane_dist < 180) {
      if (visible(head) && head.health > 0 && head != self) {
        if (head != self.enemy && head.classname != self.classname && head.classname != "player") {
          selected = head;
          dist = trace_plane_dist;
          }
        }
      }
    head = head.chain;
    }
  if (selected == world) {
    return 0;
    }
  else {
    return 1;
    }
}

Real function Mons_proxim();
var
 head : Object;
 selected : Object;
 dist : Real;
{
  dist = 180;
  selected = world;
  head = findradius(self.origin, 180);
  while (head) {
    if (trace_plane_dist < 180) {
      if (visible(head) && head.health > 0 && head != self && head != self.enemy) {
        if (head.classname != self.classname && head.classname != "player") {
          selected = head;
          dist = trace_plane_dist;
          }
        }
      }
    head = head.chain;
    }
  if (selected == world) {
    return 0;
    }
  else {
    return 1;
    }
}

Void function ai_threatproxim();
var
 megadeth : Vector;
 threat : Object;
 dave : Vector;
 mustaine : Vector;
{
  if (self.classname == "monster_qguy" && self.relations > 1) {
    return 0;
    exit;
    }
  threat = find(world, classname, "player");
  if (threat == world) {
    return 0;
    exit;
    }
  if (threat.health < 1) {
    return 0;
    exit;
    }
  threat = find(world, event, "thrett");
  if (threat != world) {
    if (threat.owner != self) {
      dave = threat.origin - self.origin;
      if (vlen(dave) > 300) {
        return 0;
        exit;
        }
      }
    }
  if (threat.owner.classname != "player") {
    return 0;
    exit;
    }
  else {
    if (self.relations > 2) {
      return 0;
      exit;
      }
    }
  if (threat.owner == self.objekt || threat.owner.health < 1) {
    return 0;
    exit;
    }
  self.enemy = threat.owner;
  FoundTarget();
  HuntTarget();
  return 1;
}

Void function ai2_fleerun(dist : Real);
{
  self.enemy = world;
  self.oldenemy = world;
  if (self.goalentity.classname != "path_danger" && self.goalentity.classname != "path_corner") {
    self.goalentity = SelectPathTarget("path_danger");
    if (self.goalentity == world) {
      self.goalentity = self.movetarget = SelectPathTarget("path_corner");
      }
    }
  movetogoal(dist);
}

Void function SelectPathTarget(pathst : String);
var
 head : Object;
 selected : Object;
 dist : Real;
{
  dist = 700;
  selected = world;
  head = findradius(self.origin, 700);
  while (head) {
    if (head.classname == pathst) {
      if (visible(head)) {
        selected = head;
        dist = trace_plane_dist;
        }
      }
    head = head.chain;
    }
  return selected;
}

Void function coward_is_safe();
var
 head : Object;
 selected : Object;
{
  selected = world;
  head = find(world, soul, "yes");
  while (head) {
    if (visible(head) && head.classname != self.classname) {
      selected = head;
      }
    head = find(head, soul, "yes");
    }
  if (selected == world) {
    return 0;
    }
  return 1;
}

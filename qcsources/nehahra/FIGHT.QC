Void function knight_attack();
var
 len : Real;
{
  len = vlen(self.enemy.origin + self.enemy.view_ofs - (self.origin + self.view_ofs));
  if (len < 80) {
    knight_atk1();
    }
  else {
    knight_runatk1();
    }
}

Real function CheckAttack();
var
 spot1 : Vector;
 spot2 : Vector;
 targ : Object;
 chance : Real;
{
  targ = self.enemy;
  spot1 = self.origin + self.view_ofs;
  spot2 = targ.origin + targ.view_ofs;
  traceline(spot1, spot2, 0, self);
  if (trace_ent != targ) {
    return 0;
    }
  if (trace_inopen && trace_inwater) {
    return 0;
    }
  if (enemy_range == RANGE_MELEE) {
    if (self.th_melee) {
      if (self.classname == "monster_knight") {
        knight_attack();
        }
      else {
        self.th_melee();
        }
      return 1;
      }
    }
  if (!(self.th_missile)) {
    return 0;
    }
  if (time < self.attack_finished) {
    return 0;
    }
  if (enemy_range == RANGE_FAR) {
    return 0;
    }
  if (enemy_range == RANGE_MELEE) {
    chance = 0.9;
    self.attack_finished = 0;
    }
  else {
    if (enemy_range == RANGE_NEAR) {
      if (self.th_melee) {
        chance = 0.2;
        }
      else {
        chance = 0.4;
        }
      }
    else {
      if (enemy_range == RANGE_MID) {
        if (self.th_melee) {
          chance = 0.050000;
          }
        else {
          chance = 0.1;
          }
        }
      else {
        chance = 0;
        }
      }
    }
  if (random() < chance) {
    self.th_missile();
    SUB_AttackFinished(FL_SWIM * random());
    return 1;
    }
  return 0;
}

Void function ai_face();
var
 spot : Vector;
{
  if (self.enemy.classname != "player" && self.classname == "monster_gaunt") {
    FindTarget();
    }
  self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
  ChangeYaw();
}

Void function ai_charge(d : Real);
{
  ai_face();
  movetogoal(d);
}

Void function ai_charge_side();
var
 dtemp : Vector;
 heading : Real;
{
  self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
  ChangeYaw();
  makevectors(self.angles);
  dtemp = self.enemy.origin - SVC_INTERMISSION * v_right;
  heading = vectoyaw(dtemp - self.origin);
  walkmove(heading, 20);
}

Void function ai_melee();
var
 delta : Vector;
 ldmg : Real;
 num : Real;
{
  if (!(self.enemy)) {
    exit;
    }
  delta = self.enemy.origin - self.origin;
  if (self.classname == "monster_cook") {
    if (vlen(delta) > 120) {
      exit;
      }
    }
  else {
    if (vlen(delta) > 60) {
      exit;
      }
    }
  random();
  ldmg = (random() + random() + random()) * MOVETYPE_WALK;
  if (self.classname == "monster_cook") {
    num = random();
    ldmg = ldmg + 3;
    if (ldmg > self.enemy.health) {
      sound(self, CHAN_VOICE, "cook/dpong.wav", 1, ATTN_IDLE);
      }
    else {
      if (num < 0.3) {
        sound(self, CHAN_BODY, "cook/ping1.wav", 1, ATTN_IDLE);
        }
      else {
        if (num < 0.7) {
          sound(self, CHAN_VOICE, "cook/ping2.wav", 1, ATTN_IDLE);
          }
        else {
          sound(self, CHAN_AUTO, "cook/pong1.wav", 1, ATTN_IDLE);
          }
        }
      }
    }
  T_Damage(self.enemy, self, self, ldmg);
}

Void function ai_melee_side();
var
 delta : Vector;
 ldmg : Real;
{
  if (!(self.enemy)) {
    exit;
    }
  ai_charge_side();
  delta = self.enemy.origin - self.origin;
  if (vlen(delta) > 60) {
    exit;
    }
  if (!CanDamage(self.enemy, self)) {
    exit;
    }
  random();
  ldmg = (random() + random() + random()) * MOVETYPE_WALK;
  T_Damage(self.enemy, self, self, ldmg);
}

Real function SoldierCheckAttack();
var
 spot1 : Vector;
 spot2 : Vector;
 targ : Object;
 chance : Real;
{
  targ = self.enemy;
  spot1 = self.origin + self.view_ofs;
  spot2 = targ.origin + targ.view_ofs;
  traceline(spot1, spot2, 0, self);
  if (trace_inopen && trace_inwater) {
    return 0;
    }
  if (trace_ent != targ) {
    return 0;
    }
  if (time < self.attack_finished) {
    return 0;
    }
  if (enemy_range == RANGE_FAR) {
    return 0;
    }
  if (enemy_range == RANGE_MELEE) {
    chance = 0.9;
    }
  else {
    if (enemy_range == RANGE_NEAR) {
      chance = 0.4;
      }
    else {
      if (enemy_range == RANGE_MID) {
        chance = 0.050000;
        }
      else {
        chance = 0;
        }
      }
    }
  if (random() < chance) {
    self.th_missile();
    SUB_AttackFinished(1 + random());
    if (random() < 0.3) {
      self.lefty = !(self.lefty);
      }
    return 1;
    }
  return 0;
}

Real function ShamCheckAttack();
var
 spot1 : Vector;
 spot2 : Vector;
 targ : Object;
 chance : Real;
{
  if (enemy_range == RANGE_MELEE) {
    if (CanDamage(self.enemy, self)) {
      self.attack_state = AS_MELEE;
      return 1;
      }
    }
  if (time < self.attack_finished) {
    return 0;
    }
  if (!enemy_vis) {
    return 0;
    }
  targ = self.enemy;
  spot1 = self.origin + self.view_ofs;
  spot2 = targ.origin + targ.view_ofs;
  if (vlen(spot1 - spot2) > 600) {
    return 0;
    }
  traceline(spot1, spot2, 0, self);
  if (trace_inopen && trace_inwater) {
    return 0;
    }
  if (trace_ent != targ) {
    return 0;
    }
  if (enemy_range == RANGE_FAR) {
    return 0;
    }
  self.attack_state = AS_MISSILE;
  SUB_AttackFinished(FL_SWIM + FL_SWIM * random());
  return 1;
}

Real function OgreCheckAttack();
var
 spot1 : Vector;
 spot2 : Vector;
 targ : Object;
 chance : Real;
{
  if (enemy_range == RANGE_MELEE) {
    if (CanDamage(self.enemy, self)) {
      self.attack_state = AS_MELEE;
      return 1;
      }
    }
  if (time < self.attack_finished) {
    return 0;
    }
  if (!enemy_vis) {
    return 0;
    }
  targ = self.enemy;
  spot1 = self.origin + self.view_ofs;
  spot2 = targ.origin + targ.view_ofs;
  traceline(spot1, spot2, 0, self);
  if (trace_inopen && trace_inwater) {
    return 0;
    }
  if (trace_ent != targ) {
    return 0;
    }
  if (time < self.attack_finished) {
    return 0;
    }
  if (enemy_range == RANGE_FAR) {
    return 0;
    }
  else {
    if (enemy_range == RANGE_NEAR) {
      chance = 0.1;
      }
    else {
      if (enemy_range == RANGE_MID) {
        chance = 0.050000;
        }
      else {
        chance = 0;
        }
      }
    }
  self.attack_state = AS_MISSILE;
  SUB_AttackFinished(1 + FL_SWIM * random());
  return 1;
}

Real function CookCheckAttack();
var
 spot1 : Vector;
 spot2 : Vector;
 targ : Object;
 chance : Real;
{
  if (enemy_range == RANGE_MELEE) {
    if (CanDamage(self.enemy, self)) {
      self.attack_state = AS_MELEE;
      return 1;
      exit;
      }
    }
  return 0;
}



Real function CanDamage(targ : Object; inflictor : Object);
{
  if (targ.health < 1) {
    return 0;
    }
  if (targ.classname == "monster_beard") {
    if (inflictor == self) {
      exit;
      }
    }
  if (targ.movetype == MOVETYPE_PUSH) {
    traceline(inflictor.origin, 0.5 * (targ.absmin + targ.absmax), 1, self);
    if (trace_fraction == 1) {
      return 1;
      }
    if (trace_ent == targ) {
      return 1;
      }
    return 0;
    }
  traceline(inflictor.origin, targ.origin, 1, self);
  if (trace_fraction == 1) {
    return 1;
    }
  traceline(inflictor.origin, targ.origin + [15 15 0], 1, self);
  if (trace_fraction == 1) {
    return 1;
    }
  traceline(inflictor.origin, targ.origin + [-15 -15 0], 1, self);
  if (trace_fraction == 1) {
    return 1;
    }
  traceline(inflictor.origin, targ.origin + [-15 15 0], 1, self);
  if (trace_fraction == 1) {
    return 1;
    }
  traceline(inflictor.origin, targ.origin + [15 -15 0], 1, self);
  if (trace_fraction == 1) {
    return 1;
    }
  return 0;
}

Void function Killed(targ : Object; attacker : Object);
var
 oself : Object;
{
  oself = self;
  self = targ;
  if (self.health < -99) {
    self.health = -99;
    }
  if (self.classname == "monster_beard") {
    if (self.health > -41) {
      self.takedamage = DAMAGE_NO;
      self.touch = SUB_Null;
      self.th_die();
      self = oself;
      exit;
      }
    }
  if (self.movetype == MOVETYPE_PUSH || self.movetype == MOVETYPE_NONE) {
    self.th_die();
    self = oself;
    exit;
    }
  self.enemy = attacker;
  if (self.flags & FL_MONSTER && self.classname != "the_mister" && self.classname != "monster_qguy") {
    killed_monsters = killed_monsters + 1;
    WriteByte(MSG_ALL, SVC_KILLEDMONSTER);
    }
  ClientObituary(self, attacker);
  self.takedamage = DAMAGE_NO;
  self.touch = SUB_Null;
  monster_death_use();
  self.th_die();
  self = oself;
}

Void function T_Damage(targ : Object; inflictor : Object; attacker : Object; damage : Real);
var
 dir : Vector;
 oldself : Object;
 save : Real;
 take : Real;
{
  if (!(targ.takedamage)) {
    exit;
    }
  if (targ.health < 1) {
    exit;
    }
  if (attacker.classname == "monster_wizard" && targ.classname == "monster_wizard") {
    exit;
    }
  if (targ.classname == "nehahra_head") {
    damage = damage * 3;
    }
  if (targ.classname == "monster_nehahra") {
    damage = damage * 0.5;
    }
  damage_attacker = attacker;
  if (attacker.super_damage_finished > time) {
    damage = damage * MOVETYPE_STEP;
    }
  save = ceil(targ.armortype * damage);
  if (save >= targ.armorvalue) {
    save = targ.armorvalue;
    targ.armortype = 0;
    targ.items = targ.items - (targ.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3));
    }
  targ.armorvalue = targ.armorvalue - save;
  take = ceil(damage - save);
  if (targ.flags & FL_CLIENT) {
    targ.dmg_take = targ.dmg_take + take;
    targ.dmg_save = targ.dmg_save + save;
    targ.dmg_inflictor = inflictor;
    }
  if (inflictor != world && targ.movetype == MOVETYPE_WALK) {
    dir = targ.origin - (inflictor.absmin + inflictor.absmax) * 0.5;
    dir = normalize(dir);
    targ.velocity = targ.velocity + dir * damage * FL_CLIENT;
    }
  if (targ.flags & FL_GODMODE) {
    exit;
    }
  if (targ.invincible_finished >= time) {
    if (self.invincible_sound < time) {
      sound(targ, CHAN_ITEM, "items/protect3.wav", 1, ATTN_NORM);
      self.invincible_sound = time + FL_SWIM;
      }
    exit;
    }
  if (teamplay == 1 && targ.team > 0 && targ.team == attacker.team) {
    exit;
    }
  if (deathmatch == 3) {
    if (targ != attacker && targ.pmodel == attacker.pmodel) {
      if (targ.classname == "player" && attacker.classname == targ.classname) {
        exit;
        }
      }
    }
  targ.health = targ.health - take;
  if (targ.health <= 0) {
    Killed(targ, attacker);
    exit;
    }
  oldself = self;
  self = targ;
  if (self.flags & FL_MONSTER && attacker != world) {
    if (self != attacker && attacker != self.enemy) {
      if (self.classname != attacker.classname) {
        if (self.enemy.classname == "player") {
          self.oldenemy = self.enemy;
          }
        self.enemy = attacker;
        FoundTarget();
        }
      }
    }
  if (self.th_pain) {
    self.tactic = 0;
    self.th_pain(attacker, take);
    if (skill == MOVETYPE_WALK) {
      self.pain_finished = time + MOVETYPE_FLY;
      }
    }
  self = oldself;
}

Void function T_RadiusDamage(inflictor : Object; attacker : Object; damage : Real; ignore : Object);
var
 points : Real;
 head : Object;
 org : Vector;
{
  head = findradius(inflictor.origin, damage + 40);
  while (head) {
    if (head != ignore) {
      if (head.takedamage) {
        org = head.origin + (head.mins + head.maxs) * 0.5;
        points = 0.5 * vlen(inflictor.origin - org);
        if (points < 0) {
          points = 0;
          }
        points = damage - points;
        if (head == attacker) {
          points = points * 0.5;
          }
        if (points > 0) {
          if (CanDamage(head, inflictor)) {
            if (head.classname == "monster_shambler") {
              T_Damage(head, inflictor, attacker, points * 0.5);
              }
            else {
              if (self.aflag == 6066 && head.classname == "player") {
                T_Damage(head, inflictor, head, points);
                }
              else {
                T_Damage(head, inflictor, attacker, points);
                }
              }
            }
          }
        }
      }
    head = head.chain;
    }
}

Void function T_BeamDamage(attacker : Object; damage : Real);
var
 points : Real;
 head : Object;
{
  head = findradius(attacker.origin, damage + 40);
  while (head) {
    if (head.takedamage) {
      points = 0.5 * vlen(attacker.origin - head.origin);
      if (points < 0) {
        points = 0;
        }
      points = damage - points;
      if (head == attacker) {
        points = points * 0.5;
        }
      if (points > 0) {
        if (CanDamage(head, attacker)) {
          if (head.classname == "monster_shambler") {
            T_Damage(head, attacker, attacker, points * 0.5);
            }
          else {
            T_Damage(head, attacker, attacker, points);
            }
          }
        }
      }
    head = head.chain;
    }
}


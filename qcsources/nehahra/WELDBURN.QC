Void function nehahra_lead();
var
 en : Object;
 num : Real;
 dir : Vector;
 megadeth : Vector;
 vec : Vector;
 mark : Object;
 t : Real;
{
  mark = find(world, classname, "nehahra_head");
  num = 1;
  t = 1000;
  t = t * 0.000001;
  megadeth = self.enemy.origin - mark.origin;
  num = vlen(megadeth);
  num = num * t;
  vec = self.enemy.velocity;
  vec_z = vec_z * 0.25;
  dir = self.enemy.origin + (vec * num);
  dir = normalize(dir - mark.origin);
  return dir;
}

Void function nehahra_spitfire(offset : Real);
var
 org : Vector;
 vec : Vector;
 ox : Real;
 spot : Vector;
{
  makevectors(self.angles);
  spot = self.origin + [0 0 235];
  org = spot + v_forward * 10;
  if (random() < 0.6) {
    vec = nehahra_lead();
    }
  else {
    vec = self.enemy.origin - spot;
    }
  vec = normalize(vec);
  WeldFire(org, vec);
}

Void function max_shootfire(offset : Real);
var
 org : Vector;
 vec : Vector;
 ox : Real;
 spot : Vector;
{
  makevectors(self.angles);
  spot = self.origin + [0 0 20];
  org = spot + v_forward * 10;
  if (random() < 0.8) {
    vec = mindcrime_lead(1000);
    }
  else {
    vec = self.enemy.origin - spot;
    }
  vec = normalize(vec);
  WeldFire(org, vec);
}

Void function WeldFire(org : Vector; dir : Vector);
var
 weld : Object;
 head : Object;
{
  weld = spawn();
  if (self.classname == "monster_nehahra") {
    head = find(world, classname, "nehahra_head");
    if (head == world) {
      weld.owner = self;
      }
    else {
      weld.owner = head;
      }
    }
  else {
    weld.owner = self;
    }
  weld.movetype = MOVETYPE_FLYMISSILE;
  weld.solid = SOLID_BBOX;
  weld.event = "mthret";
  if (self.classname == "monster_nehahra" && self.enemy.flags & FL_BLOODLESS) {
    weld.touch = nehahra_wreckbsp;
    }
  else {
    weld.touch = WeldTouch;
    }
  weld.classname = "weld_blob";
  weld.think = SUB_Remove;
  weld.nextthink = time + MOVETYPE_TOSS;
  weld.velocity = dir * 1000;
  weld.angles = vectoangles(weld.velocity);
  weld.angles_x = weld.angles_x + 90;
  burn_pain_sound_1 = "player/lburn1.wav";
  burn_pain_sound_2 = "player/lburn2.wav";
  burn_extinguish_sound = "player/slimbrn2.wav";
  burn_light_sound = "ambience/fire1.wav";
  weld_explode_sound = "boss3/hit.wav";
  weld_fire_sound_1 = "weapons/spike2.wav";
  weld_fire_sound_2 = "hknight/idle.wav";
  if (time >= weld.owner.weld_light_time) {
    weld.effects = weld.effects | EF_DIMLIGHT;
    weld.owner.weld_light_time = time + 0.2;
    }
  setmodel(weld, "progs/flame2.mdl");
  setsize(weld, VEC_ORIGIN, VEC_ORIGIN);
  setorigin(weld, org - [0 0 6] + dir * FL_CLIENT);
  sound(weld.owner, CHAN_WEAPON, weld_fire_sound_1, 0.6, ATTN_NORM);
  sound(weld, CHAN_BODY, weld_fire_sound_2, 1, ATTN_NORM);
}

Void function WeldExplode1();
{
  #0 WeldExplode2;
}

Void function WeldExplode2();
{
  #3 WeldExplode3;
}

Void function WeldExplode3();
{
  #4 SUB_Remove;
}

Void function WeldTouch();
var
 r : Real;
 d : Real;
 db : Real;
 e : Object;
{
  if (pointcontents(self.origin) == CONTENT_SKY) {
    remove(self);
    exit;
    }
  if (self.waterlevel > 1) {
    remove(self);
    exit;
    }
  if (self.enemy.classname == "the_mister") {
    remove(self);
    exit;
    }
  if (self.enemy.items & IT_SUIT) {
    remove(self);
    exit;
    }
  if (self.enemy.event == "nehahra_frame" || self.enemy.classname == "monster_nehahra") {
    remove(self);
    exit;
    }
  if (other.takedamage) {
    spawn_touchblood(MOVETYPE_FLYMISSILE);
    }
  e = findradius(self.origin, WELD_DAMAGE_RADIUS);
  while (e) {
    if (e.takedamage) {
      if (e.takedamage != DAMAGE_AIM) {
        T_Damage(e, self, self.owner, MOVETYPE_BOUNCE);
        }
      else {
        r = random();
        db = MOVETYPE_BOUNCE + (0.5 - r) * MOVETYPE_TOSS;
        d = vlen(e.origin + [0 0 16] - self.origin);
        if (d < WELD_DAMAGE_RADIUS - MOVETYPE_STEP * db) {
          d = db;
          }
        else {
          if (d < WELD_DAMAGE_RADIUS) {
            d = (WELD_DAMAGE_RADIUS - d) * 0.25;
            }
          else {
            d = 0;
            }
          }
        if (d) {
          T_Damage(e, self, self.owner, d);
          if (r > 0.85) {
            if (d > MOVETYPE_FLY) {
              BurnSetOnFire(e, self.owner);
              }
            }
          }
        }
      }
    e = e.chain;
    }
  self.origin = self.origin - MOVETYPE_STEP * normalize(self.velocity);
  self.movetype = MOVETYPE_NONE;
  self.velocity = VEC_ORIGIN;
  self.touch = SUB_Null;
  self.solid = SOLID_NOT;
  self.think = SUB_Remove;
  self.nextthink = time + MOVETYPE_STEP;
  setmodel(self, "progs/s_explod.spr");
  setorigin(self, self.origin);
  sound(self, CHAN_BODY, weld_explode_sound, 1, ATTN_NORM);
  WeldExplode1();
}

Void function BurnMakeBubble();
var
 bubble : Object;
{
  bubble = spawn();
  bubble.movetype = MOVETYPE_NOCLIP;
  bubble.solid = SOLID_NOT;
  bubble.velocity = [0 0 15];
  bubble.nextthink = time + 0.5;
  bubble.think = bubble_bob;
  bubble.classname = "bubble";
  bubble.owner = self.owner;
  bubble.frame = 0;
  bubble.cnt = 0;
  setmodel(bubble, "progs/s_bubble.spr");
  setorigin(bubble, self.owner.origin + [0 0 24]);
  setsize(bubble, [-8 -8 -8], [8 8 8]);
  self.nextthink = time + 0.1 + random() * 0.2;
  self.think = BurnMakeBubble;
  self.air_finished = self.air_finished + 1;
  if (self.air_finished >= self.bubble_count) {
    remove(self);
    }
  if (self.waterlevel > 1) {
    remove(self);
    }
}

Void function BurnSteam(num_bubbles : Real);
var
 steam : Object;
{
  steam = spawn();
  steam.movetype = MOVETYPE_NONE;
  steam.solid = SOLID_NOT;
  steam.nextthink = time + 0.1;
  steam.think = BurnMakeBubble;
  steam.air_finished = 0;
  steam.owner = self.enemy;
  steam.bubble_count = num_bubbles;
  setorigin(steam, self.enemy.origin);
  sound(steam.owner, CHAN_BODY, burn_extinguish_sound, 1, ATTN_NORM);
}

Void function BurnThink();
var
 damage : Real;
 r : Real;
 e : Object;
 IMMEDIATE : Vector;
 vf : Vector;
 vr : Vector;
{
  if (self.enemy.deadflag != DEAD_NO) {
    if (self.enemy.burn_burning) {
      self.enemy.burn_burning = 0;
      }
    else {
      if (self.enemy.deadflag == DEAD_DEAD) {
        remove(self.burn_flame);
        setorigin(self, self.origin - [0 0 12]);
        BecomeExplosion();
        exit;
        }
      }
    }
  if (time > self.burn_damage_time) {
    if (self.enemy.waterlevel > 1) {
      BurnSteam(FL_CLIENT);
      self.enemy.burn_burning = 0;
      }
    if (self.enemy.burn_burning) {
      damage = 0;
      if (self.enemy.burn_burning & 1) {
        damage = damage + MOVETYPE_WALK;
        if (time > self.burn_lifetime1) {
          self.enemy.burn_burning = self.enemy.burn_burning - 1;
          }
        }
      if (self.enemy.burn_burning & FL_SWIM) {
        damage = damage + MOVETYPE_WALK;
        if (time > self.burn_lifetime2) {
          self.enemy.burn_burning = self.enemy.burn_burning - FL_SWIM;
          }
        }
      if (self.enemy.burn_burning & MOVETYPE_STEP) {
        damage = damage + MOVETYPE_WALK;
        if (time > self.burn_lifetime4) {
          self.enemy.burn_burning = self.enemy.burn_burning - MOVETYPE_STEP;
          }
        }
      r = random();
      if (damage > 0 && self.enemy.health > 0) {
        T_Damage(self.enemy, self, self.owner, damage);
        }
      e = findradius(self.enemy.origin + [0 0 18], 50);
      while (e) {
        if (e != self.enemy) {
          if (e.takedamage == DAMAGE_AIM) {
            T_Damage(e, self, self.enemy, MOVETYPE_TOSS + r * MOVETYPE_STEP);
            if (r > 0.5) {
              BurnSetOnFire(e, self.enemy);
              }
            }
          }
        e = e.chain;
        }
      }
    self.burn_damage_time = time + 1;
    }
  if (self.enemy.burn_burning) {
    makevectors(self.enemy.v_angle);
    vf = crandom() * FL_SWIM * v_forward;
    vr = crandom() * MOVETYPE_STEP * v_right;
    self.origin = self.enemy.origin + [0 0 18] - MOVETYPE_PUSH * v_forward + vf + vr;
    self.burn_flame.origin = self.enemy.origin + [0 0 18] - MOVETYPE_PUSH * v_forward - vf - vr;
    if (self.enemy.deadflag != DEAD_NO) {
      self.origin = self.origin - [0 0 12];
      self.burn_flame.origin = self.burn_flame.origin - [0 0 12];
      }
    setorigin(self, self.origin);
    setorigin(self.burn_flame, self.burn_flame.origin);
    self.nextthink = time + 0.020000;
    exit;
    }
  remove(self.burn_flame);
  remove(self);
}

Void function BurnSetOnFire(victim : Object; attacker : Object);
var
 flame : Object;
 r : Real;
 flame2 : Object;
{
  if (victim.waterlevel > 1) {
    exit;
    }
  if (victim.invincible_finished >= time) {
    exit;
    }
  if (victim.classname == "the_mister") {
    exit;
    }
  if (victim.event == "nehahra_frame" || victim.classname == "monster_nehahra") {
    remove(self);
    exit;
    }
  if (victim.th_die == barrel_explode) {
    exit;
    }
  if (victim.items & IT_SUIT) {
    remove(self);
    exit;
    }
  if (victim.health <= 0) {
    exit;
    }
  if (!(victim.burn_burning)) {
    flame = spawn();
    flame.owner = attacker;
    flame.enemy = victim;
    flame.movetype = MOVETYPE_NONE;
    flame.velocity = VEC_ORIGIN;
    flame.solid = SOLID_NOT;
    flame.ltime = time + MOVETYPE_BOUNCE;
    flame.classname = "burn_flame";
    flame.origin = victim.origin + [-4 0 18];
    flame.think = BurnThink;
    flame.nextthink = time + 0.1;
    flame.effects = flame.effects | EF_DIMLIGHT;
    setmodel(flame, "progs/flame2.mdl");
    flame.frame = 1;
    setsize(flame, VEC_ORIGIN, VEC_ORIGIN);
    setorigin(flame, victim.origin + [-4 0 18]);
    victim.burn_flame = flame;
    flame2 = spawn();
    flame2.owner = attacker;
    flame2.enemy = victim;
    flame2.movetype = MOVETYPE_NONE;
    flame2.velocity = VEC_ORIGIN;
    flame2.solid = SOLID_NOT;
    flame2.ltime = time + 15;
    flame2.origin = victim.origin + [4 0 18];
    flame2.think = SUB_Null;
    setmodel(flame2, "progs/flame2.mdl");
    flame2.frame = 1;
    setsize(flame2, VEC_ORIGIN, VEC_ORIGIN);
    setorigin(flame2, victim.origin + [4 0 18]);
    victim.burn_flame2 = flame2;
    flame.burn_flame = flame2;
    }
  else {
    flame = victim.burn_flame;
    }
  if (victim.burn_burning == MOVETYPE_PUSH) {
    if (flame.burn_lifetime1 <= flame.burn_lifetime2) {
      if (flame.burn_lifetime1 <= flame.burn_lifetime4) {
        flame.burn_lifetime1 = time + 15;
        }
      }
    else {
      if (flame.burn_lifetime2 <= flame.burn_lifetime4) {
        if (flame.burn_lifetime2 <= flame.burn_lifetime1) {
          flame.burn_lifetime2 = time + 15;
          }
        }
      else {
        flame.burn_lifetime4 = time + 15;
        }
      }
    }
  else {
    if (!(victim.burn_burning & 1)) {
      flame.burn_lifetime1 = time + 15;
      victim.burn_burning = victim.burn_burning | 1;
      }
    else {
      if (!(victim.burn_burning & FL_SWIM)) {
        flame.burn_lifetime2 = time + 15;
        victim.burn_burning = victim.burn_burning | FL_SWIM;
        }
      else {
        flame.burn_lifetime4 = time + 15;
        victim.burn_burning = victim.burn_burning | MOVETYPE_STEP;
        }
      }
    }
  sound(flame, CHAN_WEAPON, "ambience/fire1.wav", ATTN_NORM);
}

Void function BurnPainSound();
{
  if (time < self.burn_painsound_time) {
    exit;
    }
  if (random() > 0.5) {
    sound(self, CHAN_VOICE, burn_pain_sound_1, 1, ATTN_NORM);
    }
  else {
    sound(self, CHAN_VOICE, burn_pain_sound_2, 1, ATTN_NORM);
    }
  self.burn_painsound_time = time + 0.8;
}


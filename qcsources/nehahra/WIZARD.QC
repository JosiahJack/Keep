Void function LaunchMissile(missile : Object; mspeed : Real; accuracy : Real);
var
 vec : Vector;
 move : Vector;
 fly : Real;
{
  makevectors(self.angles);
  vec = self.enemy.origin + self.enemy.mins + self.enemy.size * 0.7 - missile.origin;
  fly = vlen(vec) / mspeed;
  move = self.enemy.velocity;
  move_z = 0;
  vec = vec + move * fly;
  vec = normalize(vec);
  vec = vec + accuracy * v_up * (random() - 0.5) + accuracy * v_right * (random() - 0.5);
  missile.velocity = vec * mspeed;
  missile.angles = VEC_ORIGIN;
  missile.event = "mthret";
  missile.angles_y = vectoyaw(missile.velocity);
  missile.nextthink = time + MOVETYPE_FLY;
  missile.think = SUB_Remove;
}

Real function WizardCheckAttack();
var
 spot1 : Vector;
 spot2 : Vector;
 targ : Object;
 chance : Real;
{
  if (time < self.attack_finished) {
    return 0;
    }
  if (!enemy_vis) {
    return 0;
    }
  if (enemy_range == RANGE_FAR) {
    if (self.attack_state != AS_STRAIGHT) {
      self.attack_state = AS_STRAIGHT;
      wiz_run1();
      }
    return 0;
    }
  targ = self.enemy;
  spot1 = self.origin + self.view_ofs;
  spot2 = targ.origin + targ.view_ofs;
  traceline(spot1, spot2, 0, self);
  if (trace_ent != targ) {
    if (self.attack_state != AS_STRAIGHT) {
      self.attack_state = AS_STRAIGHT;
      wiz_run1();
      }
    return 0;
    }
  if (enemy_range == RANGE_MELEE) {
    chance = 0.9;
    }
  else {
    if (enemy_range == RANGE_NEAR) {
      chance = 0.6;
      }
    else {
      if (enemy_range == RANGE_MID) {
        chance = 0.2;
        }
      else {
        chance = 0;
        }
      }
    }
  if (random() < chance) {
    self.attack_state = AS_MISSILE;
    return 1;
    }
  if (enemy_range == RANGE_MID) {
    if (self.attack_state != AS_STRAIGHT) {
      self.attack_state = AS_STRAIGHT;
      wiz_run1();
      }
    }
  else {
    if (self.attack_state != AS_SLIDING) {
      self.attack_state = AS_SLIDING;
      wiz_side1();
      }
    }
  return 0;
}

Void function WizardAttackFinished();
{
  if (enemy_range >= RANGE_MID || !enemy_vis) {
    self.attack_state = AS_STRAIGHT;
    self.think = wiz_run1;
    }
  else {
    self.attack_state = AS_SLIDING;
    self.think = wiz_side1;
    }
}

Void function Wiz_FastFire();
var
 vec : Vector;
 dst : Vector;
{
  if (self.owner.health > 0) {
    self.owner.effects = self.owner.effects | EF_MUZZLEFLASH;
    makevectors(self.enemy.angles);
    dst = self.enemy.origin - 13 * self.movedir;
    vec = normalize(dst - self.origin);
    sound(self, CHAN_WEAPON, "wizard/wattack.wav", 1, ATTN_NORM);
    launch_spike(self.origin, vec);
    newmis.velocity = vec * 600;
    newmis.owner = self.owner;
    newmis.classname = "wizspike";
    setmodel(newmis, "progs/w_spike.mdl");
    setsize(newmis, VEC_ORIGIN, VEC_ORIGIN);
    }
  remove(self);
}

Void function Wiz_StartFast();
var
 missile : Object;
{
  sound(self, CHAN_WEAPON, "wizard/wattack.wav", 1, ATTN_NORM);
  self.v_angle = self.angles;
  makevectors(self.angles);
  missile = spawn();
  missile.owner = self;
  missile.nextthink = time + 0.6;
  setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
  setorigin(missile, self.origin + [0 0 30] + v_forward * 2 + v_right * 14);
  missile.enemy = self.enemy;
  missile.nextthink = time + 0.8;
  missile.think = Wiz_FastFire;
  missile.movedir = v_right;
  missile = spawn();
  missile.owner = self;
  missile.nextthink = time + 1;
  setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
  setorigin(missile, self.origin + [0 0 30] + v_forward * 2 + v_right * -14);
  missile.enemy = self.enemy;
  missile.nextthink = time + 0.3;
  missile.think = Wiz_FastFire;
  missile.movedir = VEC_ORIGIN - v_right;
}

Void function Wiz_idlesound();
var
 wr : Real;
{
  wr = random() * MOVETYPE_FLY;
  if (self.waitmin < time) {
    self.waitmin = time + FL_SWIM;
    if (wr > 4.5) {
      sound(self, CHAN_VOICE, "wizard/widle1.wav", 1, ATTN_IDLE);
      }
    if (wr < 1.5) {
      sound(self, CHAN_VOICE, "wizard/widle2.wav", 1, ATTN_IDLE);
      }
    }
  exit;
}

Void function wiz_stand1();
{
  #0 wiz_stand2;
  ai_stand();
  ai_emnity("monster_qguy", 2000, 0);
}

Void function wiz_stand2();
{
  #1 wiz_stand3;
  ai_stand();
}

Void function wiz_stand3();
{
  #2 wiz_stand4;
  ai_stand();
}

Void function wiz_stand4();
{
  #3 wiz_stand5;
  ai_stand();
}

Void function wiz_stand5();
{
  #4 wiz_stand6;
  ai_stand();
  ai_emnity("monster_qguy", 2000, 0);
}

Void function wiz_stand6();
{
  #5 wiz_stand7;
  ai_stand();
}

Void function wiz_stand7();
{
  #6 wiz_stand8;
  ai_stand();
}

Void function wiz_stand8();
{
  #7 wiz_stand1;
  ai_stand();
  ai_emnity("monster_qguy", 2000, 0);
}

Void function wiz_walk1();
{
  #0 wiz_walk2;
  ai_walk(FL_CLIENT);
  Wiz_idlesound();
}

Void function wiz_walk2();
{
  #1 wiz_walk3;
  ai_walk(FL_CLIENT);
  ai_emnity("monster_qguy", 2000, 0);
}

Void function wiz_walk3();
{
  #2 wiz_walk4;
  ai_walk(FL_CLIENT);
}

Void function wiz_walk4();
{
  #3 wiz_walk5;
  ai_walk(FL_CLIENT);
}

Void function wiz_walk5();
{
  #4 wiz_walk6;
  ai_walk(FL_CLIENT);
  ai_emnity("monster_qguy", 2000, 0);
}

Void function wiz_walk6();
{
  #5 wiz_walk7;
  ai_walk(FL_CLIENT);
  ai_emnity("monster_qguy", 2000, 0);
}

Void function wiz_walk7();
{
  #6 wiz_walk8;
  ai_walk(FL_CLIENT);
}

Void function wiz_walk8();
{
  #7 wiz_walk1;
  ai_walk(FL_CLIENT);
  ai_emnity("monster_qguy", 2000, 0);
}

Void function wiz_side1();
{
  #0 wiz_side2;
  ai2_run(FL_CLIENT);
  Wiz_idlesound();
}

Void function wiz_side2();
{
  #1 wiz_side3;
  ai2_run(FL_CLIENT);
}

Void function wiz_side3();
{
  #2 wiz_side4;
  ai2_run(FL_CLIENT);
}

Void function wiz_side4();
{
  #3 wiz_side5;
  ai2_run(FL_CLIENT);
}

Void function wiz_side5();
{
  #4 wiz_side6;
  ai2_run(FL_CLIENT);
}

Void function wiz_side6();
{
  #5 wiz_side7;
  ai2_run(FL_CLIENT);
}

Void function wiz_side7();
{
  #6 wiz_side8;
  ai2_run(FL_CLIENT);
}

Void function wiz_side8();
{
  #7 wiz_side1;
  ai2_run(FL_CLIENT);
}

Void function wiz_run1();
{
  #15 wiz_run2;
  ai2_run(FL_INWATER);
  Wiz_idlesound();
}

Void function wiz_run2();
{
  #16 wiz_run3;
  ai2_run(FL_INWATER);
  ai_threats();
}

Void function wiz_run3();
{
  #17 wiz_run4;
  ai2_run(FL_INWATER);
  ai_threats();
}

Void function wiz_run4();
{
  #18 wiz_run5;
  ai2_run(FL_INWATER);
  ai_threats();
}

Void function wiz_run5();
{
  #19 wiz_run6;
  ai2_run(FL_INWATER);
  ai_threats();
}

Void function wiz_run6();
{
  #20 wiz_run7;
  ai2_run(FL_INWATER);
  ai_threats();
}

Void function wiz_run7();
{
  #21 wiz_run8;
  ai2_run(FL_INWATER);
  ai_threats();
}

Void function wiz_run8();
{
  #22 wiz_run9;
  ai2_run(FL_INWATER);
  ai_threats();
}

Void function wiz_run9();
{
  #23 wiz_run10;
  ai2_run(FL_INWATER);
  ai_threats();
}

Void function wiz_run10();
{
  #24 wiz_run11;
  ai2_run(FL_INWATER);
  ai_threats();
}

Void function wiz_run11();
{
  #25 wiz_run12;
  ai2_run(FL_INWATER);
  ai_threats();
}

Void function wiz_run12();
{
  #26 wiz_run13;
  ai2_run(FL_INWATER);
  ai_threats();
}

Void function wiz_run13();
{
  #27 wiz_run14;
  ai2_run(FL_INWATER);
  ai_threats();
}

Void function wiz_run14();
{
  #28 wiz_run1;
  ai2_run(FL_INWATER);
  ai_threats();
}

Void function wiz_fast1();
{
  #29 wiz_fast2;
  ai_face();
  Wiz_StartFast();
}

Void function wiz_fast2();
{
  #30 wiz_fast3;
  ai_face();
  ai_threats();
}

Void function wiz_fast3();
{
  #31 wiz_fast4;
  ai_face();
  ai_threats();
}

Void function wiz_fast4();
{
  #32 wiz_fast5;
  ai_face();
  ai_threats();
}

Void function wiz_fast5();
{
  #33 wiz_fast6;
  ai_face();
  ai_threats();
}

Void function wiz_fast6();
{
  #34 wiz_fast7;
  ai_face();
  ai_threats();
}

Void function wiz_fast7();
{
  #33 wiz_fast8;
  ai_face();
  ai_threats();
}

Void function wiz_fast8();
{
  #32 wiz_fast9;
  ai_face();
  ai_threats();
}

Void function wiz_fast9();
{
  #31 wiz_fast10;
  ai_face();
  ai_threats();
}

Void function wiz_fast10();
{
  #30 wiz_run1;
  ai_face();
  SUB_AttackFinished(FL_SWIM);
  WizardAttackFinished();
}

Void function wiz_pain1();
{
  #42 wiz_pain2;
  ai_threats();
}

Void function wiz_pain2();
{
  #43 wiz_pain3;
  ai_threats();
}

Void function wiz_pain3();
{
  #44 wiz_pain4;
  ai_threats();
}

Void function wiz_pain4();
{
  #45 wiz_run1;
  ai_threats();
}

Void function wiz_death1();
{
  #46 wiz_death2;
  self.velocity_x = -200 + 400 * random();
  self.velocity_y = -200 + 400 * random();
  self.velocity_z = 100 + 100 * random();
  self.flags = self.flags - (self.flags & FL_ONGROUND);
  sound(self, CHAN_VOICE, "wizard/wdeath.wav", 1, ATTN_NORM);
}

Void function wiz_death2();
{
  #47 wiz_death3;
}

Void function wiz_death3();
{
  #48 wiz_death4;
  self.solid = SOLID_NOT;
}

Void function wiz_death4();
{
  #49 wiz_death5;
}

Void function wiz_death5();
{
  #50 wiz_death6;
}

Void function wiz_death6();
{
  #51 wiz_death7;
}

Void function wiz_death7();
{
  #52 wiz_death8;
}

Void function wiz_death8();
{
  #53 corpse_think;
}

Void function wiz_die();
{
  if (self.health < -40) {
    sound(self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
    ThrowHead("progs/h_wizard.mdl", self.health);
    ThrowGib("progs/gib2.mdl", self.health);
    ThrowGib("progs/gib2.mdl", self.health);
    ThrowGib("progs/gib2.mdl", self.health);
    exit;
    }
  wiz_death1();
}

Void function Wiz_Pain(attacker : Object; damage : Real);
{
  sound(self, CHAN_VOICE, "wizard/wpain.wav", 1, ATTN_NORM);
  if (random() * 70 > damage) {
    exit;
    }
  wiz_pain1();
}

Void function Wiz_Missile();
{
  wiz_fast1();
}

Void function monster_wizard();
{
  if (deathmatch) {
    remove(self);
    exit;
    }
  total_monsters = total_monsters + 1;
  precache_model("progs/wizard.mdl");
  precache_model("progs/h_wizard.mdl");
  precache_model("progs/w_spike.mdl");
  precache_sound("wizard/hit.wav");
  precache_sound("wizard/wattack.wav");
  precache_sound("wizard/wdeath.wav");
  precache_sound("wizard/widle1.wav");
  precache_sound("wizard/widle2.wav");
  precache_sound("wizard/wpain.wav");
  precache_sound("wizard/wsight.wav");
  if (!(self.health)) {
    self.health = 80;
    }
  self.nojump = 1;
  if (!(self.brain & NO_SWIM)) {
    self.brain = self.brain | NO_SWIM;
    }
  self.th_stand = wiz_stand1;
  self.th_walk = wiz_walk1;
  self.th_run = wiz_run1;
  self.th_missile = Wiz_Missile;
  self.th_pain = Wiz_Pain;
  self.th_die = wiz_die;
  if (self.brain & TRIGGER_SPAWN) {
    self.use = wizard_startt;
    exit;
    }
  carnify_wizard();
}

Void function wizard_startt();
{
  trigger_spawnmonster();
  carnify_wizard();
}

Void function carnify_wizard();
{
  self.solid = SOLID_SLIDEBOX;
  self.movetype = MOVETYPE_STEP;
  setmodel(self, "progs/wizard.mdl");
  setsize(self, VEC_HULL_MIN, [16 16 40]);
  flymonster_start();
}


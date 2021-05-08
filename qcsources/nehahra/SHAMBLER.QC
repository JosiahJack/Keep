Void function sham_stand1();
{
  if (self.walkframe >= 17) {
    self.walkframe = 0;
    }
  #0 sham_stand1;
  self.frame = 0 + self.walkframe;
  self.walkframe = self.walkframe + 1;
  ai_stand();
}

Void function sham_walk1();
{
  #17 sham_walk2;
  ai_walk(MOVETYPE_BOUNCE);
}

Void function sham_walk2();
{
  #18 sham_walk3;
  ai_walk(MOVETYPE_FLYMISSILE);
  ai_emnity("monster_qguy", 700, 0);
}

Void function sham_walk3();
{
  #19 sham_walk4;
  ai_walk(MOVETYPE_FLYMISSILE);
}

Void function sham_walk4();
{
  #20 sham_walk5;
  ai_walk(MOVETYPE_FLY);
}

Void function sham_walk5();
{
  #21 sham_walk6;
  ai_walk(MOVETYPE_TOSS);
}

Void function sham_walk6();
{
  #22 sham_walk7;
  ai_walk(12);
  ai_emnity("monster_qguy", 700, 0);
}

Void function sham_walk7();
{
  #23 sham_walk8;
  ai_walk(FL_CLIENT);
}

Void function sham_walk8();
{
  #24 sham_walk9;
  ai_walk(MOVETYPE_WALK);
  ai_emnity("monster_qguy", 700, 0);
}

Void function sham_walk9();
{
  #25 sham_walk10;
  ai_walk(13);
}

Void function sham_walk10();
{
  #26 sham_walk11;
  ai_walk(MOVETYPE_FLYMISSILE);
}

Void function sham_walk11();
{
  #27 sham_walk12;
  ai_walk(MOVETYPE_PUSH);
  ai_emnity("monster_qguy", 700, 0);
}

Void function sham_walk12();
{
  #28 sham_walk1;
  ai_walk(MOVETYPE_PUSH);
  if (random() > 0.8) {
    sound(self, CHAN_VOICE, "shambler/sidle.wav", 1, ATTN_IDLE);
    }
}

Void function sham_run1();
{
  #29 sham_run2;
  ai_run(20);
}

Void function sham_run2();
{
  #30 sham_run3;
  ai_run(24);
}

Void function sham_run3();
{
  #31 sham_run4;
  ai_run(20);
}

Void function sham_run4();
{
  #32 sham_run5;
  ai_run(20);
}

Void function sham_run5();
{
  #33 sham_run6;
  ai_run(24);
}

Void function sham_run6();
{
  #34 sham_run1;
  ai_run(20);
  if (random() > 0.8) {
    sound(self, CHAN_VOICE, "shambler/sidle.wav", 1, ATTN_IDLE);
    }
}

Void function sham_smash1();
{
  #35 sham_smash2;
  sound(self, CHAN_VOICE, "shambler/melee1.wav", 1, ATTN_NORM);
  ai_charge(FL_SWIM);
}

Void function sham_smash2();
{
  #36 sham_smash3;
  ai_charge(MOVETYPE_TOSS);
}

Void function sham_smash3();
{
  #37 sham_smash4;
  ai_charge(MOVETYPE_TOSS);
}

Void function sham_smash4();
{
  #38 sham_smash5;
  ai_charge(MOVETYPE_FLY);
}

Void function sham_smash5();
{
  #39 sham_smash6;
  ai_charge(MOVETYPE_STEP);
}

Void function sham_smash6();
{
  #40 sham_smash7;
  ai_charge(1);
}

Void function sham_smash7();
{
  #41 sham_smash8;
  ai_charge(0);
}

Void function sham_smash8();
{
  #42 sham_smash9;
  ai_charge(0);
}

Void function sham_smash9();
{
  #43 sham_smash10;
  ai_charge(0);
}

Void function sham_smash10();
var
 delta : Vector;
 ldmg : Real;
{
  #44 sham_smash11;
  if (!(self.enemy)) {
    exit;
    }
  ai_charge(0);
  delta = self.enemy.origin - self.origin;
  if (vlen(delta) > 100) {
    exit;
    }
  if (!CanDamage(self.enemy, self)) {
    exit;
    }
  random();
  ldmg = (random() + random() + random()) * 40;
  T_Damage(self.enemy, self, self, ldmg);
  sound(self, CHAN_VOICE, "shambler/smack.wav", 1, ATTN_NORM);
  SpawnMeatSpray(self.origin + v_forward * FL_INWATER, crandom() * 100 * v_right);
  SpawnMeatSpray(self.origin + v_forward * FL_INWATER, crandom() * 100 * v_right);
}

Void function sham_smash11();
{
  #45 sham_smash12;
  ai_charge(MOVETYPE_FLY);
}

Void function sham_smash12();
{
  #46 sham_run1;
  ai_charge(MOVETYPE_STEP);
}

Void function ShamClaw(side : Real);
var
 delta : Vector;
 ldmg : Real;
{
  if (!(self.enemy)) {
    exit;
    }
  ai_charge(MOVETYPE_BOUNCE);
  delta = self.enemy.origin - self.origin;
  if (vlen(delta) > 100) {
    exit;
    }
  random();
  ldmg = (random() + random() + random()) * 20;
  T_Damage(self.enemy, self, self, ldmg);
  sound(self, CHAN_VOICE, "shambler/smack.wav", 1, ATTN_NORM);
  if (side) {
    makevectors(self.angles);
    SpawnMeatSpray(self.origin + v_forward * FL_INWATER, side * v_right);
    }
}

Void function sham_swingl1();
{
  #56 sham_swingl2;
  sound(self, CHAN_VOICE, "shambler/melee2.wav", 1, ATTN_NORM);
  ai_charge(MOVETYPE_FLY);
}

Void function sham_swingl2();
{
  #57 sham_swingl3;
  ai_charge(MOVETYPE_WALK);
}

Void function sham_swingl3();
{
  #58 sham_swingl4;
  ai_charge(MOVETYPE_PUSH);
}

Void function sham_swingl4();
{
  #59 sham_swingl5;
  ai_charge(MOVETYPE_WALK);
}

Void function sham_swingl5();
{
  #60 sham_swingl6;
  ai_charge(MOVETYPE_PUSH);
}

Void function sham_swingl6();
{
  #61 sham_swingl7;
  ai_charge(MOVETYPE_FLYMISSILE);
}

Void function sham_swingl7();
{
  #62 sham_swingl8;
  ai_charge(MOVETYPE_FLY);
  ShamClaw(250);
}

Void function sham_swingl8();
{
  #63 sham_swingl9;
  ai_charge(MOVETYPE_STEP);
}

Void function sham_swingl9();
{
  #64 sham_run1;
  ai_charge(FL_CLIENT);
  if (random() < 0.5) {
    self.think = sham_swingr1;
    }
}

Void function sham_swingr1();
{
  #47 sham_swingr2;
  sound(self, CHAN_VOICE, "shambler/melee1.wav", 1, ATTN_NORM);
  ai_charge(1);
}

Void function sham_swingr2();
{
  #48 sham_swingr3;
  ai_charge(FL_CLIENT);
}

Void function sham_swingr3();
{
  #49 sham_swingr4;
  ai_charge(14);
}

Void function sham_swingr4();
{
  #50 sham_swingr5;
  ai_charge(MOVETYPE_PUSH);
}

Void function sham_swingr5();
{
  #51 sham_swingr6;
  ai_charge(MOVETYPE_WALK);
}

Void function sham_swingr6();
{
  #52 sham_swingr7;
  ai_charge(MOVETYPE_TOSS);
}

Void function sham_swingr7();
{
  #53 sham_swingr8;
  ai_charge(MOVETYPE_TOSS);
  ShamClaw(-250);
}

Void function sham_swingr8();
{
  #54 sham_swingr9;
  ai_charge(MOVETYPE_WALK);
}

Void function sham_swingr9();
{
  #55 sham_run1;
  ai_charge(1);
  ai_charge(MOVETYPE_BOUNCE);
  if (random() < 0.5) {
    self.think = sham_swingl1;
    }
}

Void function sham_melee();
var
 chance : Real;
{
  chance = random();
  if (chance > 0.6 || self.health == 600) {
    sham_smash1();
    }
  else {
    if (chance > 0.3) {
      sham_swingr1();
      }
    else {
      sham_swingl1();
      }
    }
}

Void function CastLightning();
var
 org : Vector;
 dir : Vector;
{
  self.effects = self.effects | EF_MUZZLEFLASH;
  ai_face();
  if (self.classname == "the_mister") {
    org = self.origin + [0 0 20];
    }
  else {
    org = self.origin + [0 0 40];
    }
  dir = self.enemy.origin + [0 0 16] - org;
  dir = normalize(dir);
  traceline(org, self.origin + dir * 600, 1, self);
  WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
  WriteByte(MSG_BROADCAST, TE_LIGHTNING1);
  WriteEntity(MSG_BROADCAST, self);
  WriteCoord(MSG_BROADCAST, org_x);
  WriteCoord(MSG_BROADCAST, org_y);
  WriteCoord(MSG_BROADCAST, org_z);
  WriteCoord(MSG_BROADCAST, trace_endpos_x);
  WriteCoord(MSG_BROADCAST, trace_endpos_y);
  WriteCoord(MSG_BROADCAST, trace_endpos_z);
  LightningDamage(org, trace_endpos, self, MOVETYPE_BOUNCE);
}

Void function sham_magic1();
{
  #65 sham_magic2;
  ai_face();
  sound(self, CHAN_WEAPON, "shambler/sattck1.wav", 1, ATTN_NORM);
}

Void function sham_magic2();
{
  #66 sham_magic3;
  ai_face();
}

Void function sham_magic3();
var
 o : Object;
{
  #67 sham_magic4;
  ai_face();
  self.nextthink = self.nextthink + 0.2;
  self.effects = self.effects | EF_MUZZLEFLASH;
  ai_face();
  self.owner = spawn();
  o = self.owner;
  setmodel(o, "progs/s_light.mdl");
  setorigin(o, self.origin);
  o.angles = self.angles;
  o.nextthink = time + 0.7;
  o.think = SUB_Remove;
}

Void function sham_magic4();
{
  #68 sham_magic5;
  self.effects = self.effects | EF_MUZZLEFLASH;
  self.owner.frame = 1;
}

Void function sham_magic5();
{
  #69 sham_magic6;
  self.effects = self.effects | EF_MUZZLEFLASH;
  self.owner.frame = FL_SWIM;
}

Void function sham_magic6();
{
  #70 sham_magic9;
  remove(self.owner);
  CastLightning();
  sound(self, CHAN_WEAPON, "shambler/sboom.wav", 1, ATTN_NORM);
}

Void function sham_magic9();
{
  #73 sham_magic10;
  CastLightning();
}

Void function sham_magic10();
{
  #74 sham_magic11;
  CastLightning();
}

Void function sham_magic11();
{
  #75 sham_magic12;
  if (skill == MOVETYPE_WALK) {
    CastLightning();
    }
}

Void function sham_magic12();
{
  #76 sham_run1;
}

Void function sham_pain1();
{
  #77 sham_pain2;
}

Void function sham_pain2();
{
  #78 sham_pain3;
}

Void function sham_pain3();
{
  #79 sham_pain4;
}

Void function sham_pain4();
{
  #80 sham_pain5;
}

Void function sham_pain5();
{
  #81 sham_pain6;
}

Void function sham_pain6();
{
  #82 sham_run1;
}

Void function sham_pain(attacker : Object; damage : Real);
{
  sound(self, CHAN_VOICE, "shambler/shurt2.wav", 1, ATTN_NORM);
  if (self.health <= 0) {
    exit;
    }
  if (random() * 400 > damage) {
    exit;
    }
  if (self.pain_finished > time) {
    exit;
    }
  self.pain_finished = time + FL_SWIM;
  sham_pain1();
}

Void function sham_death1();
{
  #83 sham_death2;
}

Void function sham_death2();
{
  #84 sham_death3;
}

Void function sham_death3();
{
  #85 sham_death4;
  self.solid = SOLID_NOT;
}

Void function sham_death4();
{
  #86 sham_death5;
}

Void function sham_death5();
{
  #87 sham_death6;
}

Void function sham_death6();
{
  #88 sham_death7;
}

Void function sham_death7();
{
  #89 sham_death8;
}

Void function sham_death8();
{
  #90 sham_death9;
}

Void function sham_death9();
{
  #91 sham_death10;
}

Void function sham_death10();
{
  #92 sham_death11;
}

Void function sham_death11();
{
  #93 corpse_think;
}

Void function sham_die();
{
  if (self.health < -60) {
    sound(self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
    ThrowHead("progs/h_shams.mdl", self.health);
    ThrowGib("progs/gib1.mdl", self.health);
    ThrowGib("progs/gib2.mdl", self.health);
    ThrowGib("progs/gib3.mdl", self.health);
    exit;
    }
  sound(self, CHAN_VOICE, "shambler/sdeath.wav", 1, ATTN_NORM);
  sham_death1();
}

Void function monster_shambler();
{
  if (deathmatch) {
    remove(self);
    exit;
    }
  if (world.model == "maps/neh2m2.bsp") {
    if (self.target == "last_fight") {
      self.target = "final_monsters";
      }
    }
  total_monsters = total_monsters + 1;
  precache_model("progs/shambler.mdl");
  precache_model("progs/s_light.mdl");
  precache_model("progs/h_shams.mdl");
  precache_model("progs/bolt.mdl");
  precache_sound("shambler/sattck1.wav");
  precache_sound("shambler/sboom.wav");
  precache_sound("shambler/sdeath.wav");
  precache_sound("shambler/shurt2.wav");
  precache_sound("shambler/sidle.wav");
  precache_sound("shambler/ssight.wav");
  precache_sound("shambler/melee1.wav");
  precache_sound("shambler/melee2.wav");
  precache_sound("shambler/smack.wav");
  if (self.spawnflags & FL_GODMODE) {
    precache_sound("shambler/sham1.wav");
    precache_sound("shambler/sham2.wav");
    precache_sound("shambler/sham3.wav");
    self.th_stand = sham_sleepstart;
    }
  else {
    self.th_stand = sham_stand1;
    }
  self.th_walk = sham_walk1;
  self.th_run = sham_run1;
  self.th_die = sham_die;
  self.th_melee = sham_melee;
  self.th_missile = sham_magic1;
  self.th_pain = sham_pain;
  if (self.brain & TRIGGER_SPAWN) {
    self.use = shambler_start;
    exit;
    }
  carnify_shambler();
}

Void function shambler_start();
var
 org : Vector;
{
  trigger_spawnmonster();
  carnify_shambler();
}

Void function carnify_shambler();
{
  self.solid = SOLID_SLIDEBOX;
  self.movetype = MOVETYPE_STEP;
  setmodel(self, "progs/shambler.mdl");
  setsize(self, VEC_HULL2_MIN, VEC_HULL2_MAX);
  if (!(self.health)) {
    self.health = 600;
    }
  walkmonster_start();
}

Void function sham_sleepstart();
{
  self.th_stand = sham_stand1;
  self.touch = sham_wakes;
  sham_sleep();
}

Void function sham_sleep();
{
  if (self.walkframe >= 10) {
    self.walkframe = 0;
    }
  #64 sham_sleep;
  self.frame = 94 + self.walkframe;
  self.walkframe = self.walkframe + 1;
  ai_shamsleep();
  if (self.walkframe == 9) {
    if (random() < 0.1) {
      shambler_snore();
      }
    }
}

Void function sham_wakes();
{
  if (other.classname != "player" || other.health < 1) {
    exit;
    }
  if (FindTarget()) {
    self.touch = Sub_Null;
    }
}

Void function ai_shamsleep();
var
 dist : Real;
 selected : Object;
 megadeth : Vector;
 head : Object;
{
  selected = world;
  head = find(world, classname, "monster_shambler");
  while (head) {
    megadeth = self.origin - head.origin;
    if (vlen(megadeth) < 400) {
      if (head.spawnflags == self.spawnflags) {
        if (head.health > 0 && head.enemy.classname == "player") {
          selected = head.enemy;
          }
        }
      }
    head = find(head, classname, "monster_shambler");
    }
  if (selected != world) {
    self.enemy = selected;
    FoundTarget();
    HuntTarget();
    }
}

Void function shambler_snore();
var
 num : Real;
{
  num = random();
  if (num < 0.33) {
    sound(self, CHAN_WEAPON, "shambler/sham1.wav", 1, ATTN_NORM);
    }
  else {
    if (num < 0.66) {
      sound(self, CHAN_WEAPON, "shambler/sham2.wav", 1, ATTN_NORM);
      }
    else {
      sound(self, CHAN_WEAPON, "shambler/sham3.wav", 1, ATTN_NORM);
      }
    }
}

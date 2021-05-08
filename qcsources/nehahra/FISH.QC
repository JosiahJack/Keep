Void function f_check();
{
  if (self.watertype == CONTENT_WATER) {
    if (!(self.flags & FL_SWIM)) {
      self.flags = self.flags | FL_SWIM;
      }
    }
}

Void function f_stand1();
{
  #39 f_stand2;
  ai_stand();
}

Void function f_stand2();
{
  #40 f_stand3;
  ai_stand();
}

Void function f_stand3();
{
  #41 f_stand4;
  ai_stand();
  f_check();
}

Void function f_stand4();
{
  #42 f_stand5;
  ai_stand();
}

Void function f_stand5();
{
  #43 f_stand6;
  ai_stand();
}

Void function f_stand6();
{
  #44 f_stand7;
  ai_stand();
}

Void function f_stand7();
{
  #45 f_stand8;
  ai_stand();
}

Void function f_stand8();
{
  #46 f_stand9;
  ai_stand();
}

Void function f_stand9();
{
  #47 f_stand10;
  ai_stand();
}

Void function f_stand10();
{
  #48 f_stand11;
  ai_stand();
}

Void function f_stand11();
{
  #49 f_stand12;
  ai_stand();
}

Void function f_stand12();
{
  #50 f_stand13;
  ai_stand();
}

Void function f_stand13();
{
  #51 f_stand14;
  ai_stand();
}

Void function f_stand14();
{
  #52 f_stand15;
  ai_stand();
}

Void function f_stand15();
{
  #53 f_stand16;
  ai_stand();
}

Void function f_stand16();
{
  #54 f_stand17;
  ai_stand();
}

Void function f_stand17();
{
  if (random() < 0.2) {
    #56 f_walk1;
    ai_walk(FL_CLIENT);
    }
  #55 f_stand18;
  ai_stand();
}

Void function f_stand18();
{
  #56 f_walk1;
  ai_stand();
}

Void function f_walk1();
{
  #39 f_walk2;
  ai_walk(10);
}

Void function f_walk2();
{
  #40 f_walk3;
  ai_walk(10);
  f_check();
}

Void function f_walk3();
{
  #41 f_walk4;
  ai_walk(10);
}

Void function f_walk4();
{
  #42 f_walk5;
  ai_walk(10);
}

Void function f_walk5();
{
  #43 f_walk6;
  ai_walk(10);
}

Void function f_walk6();
{
  #44 f_walk7;
  ai_walk(10);
}

Void function f_walk7();
{
  #45 f_walk8;
  ai_walk(10);
}

Void function f_walk8();
{
  #46 f_walk9;
  ai_walk(10);
}

Void function f_walk9();
{
  #47 f_walk10;
  ai_walk(10);
}

Void function f_walk10();
{
  #48 f_walk11;
  ai_walk(10);
}

Void function f_walk11();
{
  #49 f_walk12;
  ai_walk(10);
}

Void function f_walk12();
{
  #50 f_walk13;
  ai_walk(10);
}

Void function f_walk13();
{
  #51 f_walk14;
  ai_walk(10);
}

Void function f_walk14();
{
  #52 f_walk15;
  ai_walk(10);
}

Void function f_walk15();
{
  #53 f_walk16;
  ai_walk(10);
}

Void function f_walk16();
{
  #54 f_walk17;
  ai_walk(10);
}

Void function f_walk17();
{
  #55 f_walk18;
  ai_walk(10);
}

Void function f_walk18();
{
  #56 f_walk1;
  ai_walk(10);
}

Void function f_run1();
{
  #39 f_run2;
  ai_run(12);
  if (random() < 0.5) {
    sound(self, CHAN_VOICE, "fish/idle.wav", 1, ATTN_NORM);
    }
}

Void function f_run2();
{
  #41 f_run3;
  ai_run(12);
}

Void function f_run3();
{
  #43 f_run4;
  ai_run(12);
}

Void function f_run4();
{
  #45 f_run5;
  ai_run(12);
}

Void function f_run5();
{
  #47 f_run6;
  ai_run(12);
}

Void function f_run6();
{
  #49 f_run7;
  ai_run(12);
}

Void function f_run7();
{
  #51 f_run8;
  ai_run(12);
}

Void function f_run8();
{
  #53 f_run9;
  ai_run(12);
}

Void function f_run9();
{
  #55 f_run1;
  ai_run(12);
}

Void function fish_melee();
var
 delta : Vector;
 ldmg : Real;
{
  if (!(self.enemy)) {
    exit;
    }
  delta = self.enemy.origin - self.origin;
  if (vlen(delta) > 60) {
    exit;
    }
  sound(self, CHAN_VOICE, "fish/bite.wav", 1, ATTN_NORM);
  random();
  ldmg = (random() + random()) * MOVETYPE_WALK;
  T_Damage(self.enemy, self, self, ldmg);
}

Void function f_attack1();
{
  #0 f_attack2;
  ai_charge(MOVETYPE_BOUNCE);
}

Void function f_attack2();
{
  #1 f_attack3;
  ai_charge(MOVETYPE_BOUNCE);
}

Void function f_attack3();
{
  #2 f_attack4;
  fish_melee();
}

Void function f_attack4();
{
  #3 f_attack5;
  ai_charge(MOVETYPE_BOUNCE);
}

Void function f_attack5();
{
  #4 f_attack6;
  ai_charge(MOVETYPE_BOUNCE);
}

Void function f_attack6();
{
  #5 f_attack7;
  ai_charge(MOVETYPE_BOUNCE);
}

Void function f_attack7();
{
  #6 f_attack8;
  ai_charge(MOVETYPE_BOUNCE);
}

Void function f_attack8();
{
  #7 f_attack9;
  ai_charge(MOVETYPE_BOUNCE);
}

Void function f_attack9();
{
  #8 f_attack10;
  fish_melee();
}

Void function f_attack10();
{
  #9 f_attack11;
  ai_charge(MOVETYPE_BOUNCE);
}

Void function f_attack11();
{
  #10 f_attack12;
  ai_charge(MOVETYPE_BOUNCE);
}

Void function f_attack12();
{
  #11 f_attack13;
  ai_charge(MOVETYPE_BOUNCE);
}

Void function f_attack13();
{
  #12 f_attack14;
  ai_charge(MOVETYPE_BOUNCE);
}

Void function f_attack14();
{
  #13 f_attack15;
  ai_charge(MOVETYPE_BOUNCE);
}

Void function f_attack15();
{
  #14 f_attack16;
  fish_melee();
}

Void function f_attack16();
{
  #15 f_attack17;
  ai_charge(MOVETYPE_BOUNCE);
}

Void function f_attack17();
{
  #16 f_attack18;
  ai_charge(MOVETYPE_BOUNCE);
}

Void function f_attack18();
{
  #17 f_run1;
  ai_charge(MOVETYPE_BOUNCE);
}

Void function f_death1();
{
  if (self.enemy.classname == "monster_jagger") {
    self.enemy.cnt = self.enemy.cnt + 1;
    self.solid = SOLID_NOT;
    SpawnMeatSpray(self.origin, crandom() * 86 * v_right);
    ThrowGib("progs/gib1.mdl", self.health);
    ThrowGib("progs/gib1.mdl", self.health);
    remove(self);
    exit;
    }
  if (self.health < -35) {
    sound(self, CHAN_BODY, "player/razh20.wav", 1, ATTN_NORM);
    ThrowHead("progs/gib3.mdl", self.health);
    ThrowGib("progs/gib1.mdl", self.health);
    ThrowGib("progs/gib2.mdl", self.health);
    ThrowGib("progs/gib3.mdl", self.health);
    exit;
    }
  #18 f_death2;
  sound(self, CHAN_VOICE, "fish/death.wav", 1, ATTN_NORM);
}

Void function f_death2();
{
  #19 f_death3;
}

Void function f_death3();
{
  #20 f_death4;
  self.solid = SOLID_NOT;
}

Void function f_death4();
{
  #21 f_death5;
}

Void function f_death5();
{
  #22 f_death6;
}

Void function f_death6();
{
  #23 f_death7;
}

Void function f_death7();
{
  #24 f_death8;
}

Void function f_death8();
{
  #25 f_death9;
}

Void function f_death9();
{
  #26 f_death10;
}

Void function f_death10();
{
  #27 f_death11;
}

Void function f_death11();
{
  #28 f_death12;
}

Void function f_death12();
{
  #29 f_death13;
}

Void function f_death13();
{
  #30 f_death14;
}

Void function f_death14();
{
  #31 f_death15;
}

Void function f_death15();
{
  #32 f_death16;
}

Void function f_death16();
{
  #33 f_death17;
}

Void function f_death17();
{
  #34 f_death18;
}

Void function f_death18();
{
  #35 f_death19;
}

Void function f_death19();
{
  #36 f_death20;
}

Void function f_death20();
{
  #37 f_death21;
}

Void function f_death21();
{
  #38 corpse_think;
}

Void function f_pain1();
{
  #57 f_pain2;
}

Void function f_pain2();
{
  #58 f_pain3;
  ai_pain(MOVETYPE_TOSS);
}

Void function f_pain3();
{
  #59 f_pain4;
  ai_pain(MOVETYPE_TOSS);
}

Void function f_pain4();
{
  #60 f_pain5;
  ai_pain(MOVETYPE_TOSS);
}

Void function f_pain5();
{
  #61 f_pain6;
  ai_pain(MOVETYPE_TOSS);
}

Void function f_pain6();
{
  #62 f_pain7;
  ai_pain(MOVETYPE_TOSS);
}

Void function f_pain7();
{
  #63 f_pain8;
  ai_pain(MOVETYPE_TOSS);
}

Void function f_pain8();
{
  #64 f_pain9;
  ai_pain(MOVETYPE_TOSS);
}

Void function f_pain9();
{
  #65 f_run1;
  ai_pain(MOVETYPE_TOSS);
}

Void function fish_pain(attacker : Object; damage : Real);
{
  f_pain1();
}

Void function monster_fish();
{
  if (deathmatch) {
    remove(self);
    exit;
    }
  total_monsters = total_monsters + 1;
  precache_model2("progs/fish.mdl");
  precache_sound2("fish/death.wav");
  precache_sound2("fish/bite.wav");
  precache_sound2("fish/idle.wav");
  self.solid = SOLID_SLIDEBOX;
  self.movetype = MOVETYPE_STEP;
  setmodel(self, "progs/fish.mdl");
  setsize(self, VEC_HULL_MIN, [16 16 24]);
  if (!(self.health)) {
    self.health = 25;
    }
  self.brain = 0;
  self.netname = "fishy";
  self.th_stand = f_stand1;
  self.th_walk = f_walk1;
  self.th_run = f_run1;
  self.th_die = f_death1;
  self.th_pain = fish_pain;
  self.th_melee = f_attack1;
  swimmonster_start();
}


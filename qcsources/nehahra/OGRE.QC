Void function OgreGrenadeExplode();
{
  T_RadiusDamage(self, self.owner, 40, world);
  sound(self, CHAN_VOICE, "weapons/r_exp3.wav", 1, ATTN_NORM);
  WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
  WriteByte(MSG_BROADCAST, TE_EXPLOSION);
  WriteCoord(MSG_BROADCAST, self.origin_x);
  WriteCoord(MSG_BROADCAST, self.origin_y);
  WriteCoord(MSG_BROADCAST, self.origin_z);
  self.velocity = VEC_ORIGIN;
  self.touch = SUB_Null;
  setmodel(self, "progs/s_explod.spr");
  self.solid = SOLID_NOT;
  BecomeExplosion();
}

Void function OgreGrenadeTouch();
{
  if (other == self.owner) {
    exit;
    }
  if (other.takedamage == DAMAGE_AIM) {
    OgreGrenadeExplode();
    exit;
    }
  sound(self, CHAN_VOICE, "weapons/bounce.wav", 1, ATTN_NORM);
  if (self.velocity == VEC_ORIGIN) {
    self.avelocity = VEC_ORIGIN;
    }
}

Void function OgreFireGrenade();
var
 missile : Object;
 mpuff : Object;
{
  self.effects = self.effects | EF_MUZZLEFLASH;
  sound(self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM);
  missile = spawn();
  missile.owner = self;
  missile.movetype = MOVETYPE_BOUNCE;
  missile.solid = SOLID_BBOX;
  makevectors(self.angles);
  missile.velocity = normalize(self.enemy.origin - self.origin);
  missile.velocity = missile.velocity * 600;
  missile.velocity_z = 200;
  missile.avelocity = [300 300 300];
  missile.angles = vectoangles(missile.velocity);
  missile.touch = OgreGrenadeTouch;
  missile.nextthink = time + 2.5;
  missile.think = OgreGrenadeExplode;
  setmodel(missile, "progs/grenade.mdl");
  setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
  setorigin(missile, self.origin);
}

Void function chainsaw(side : Real);
var
 delta : Vector;
 ldmg : Real;
{
  if (!(self.enemy)) {
    exit;
    }
  if (!CanDamage(self.enemy, self)) {
    exit;
    }
  ai_charge(MOVETYPE_BOUNCE);
  delta = self.enemy.origin - self.origin;
  if (vlen(delta) > 100) {
    exit;
    }
  random();
  ldmg = (random() + random() + random()) * MOVETYPE_STEP;
  if (self.enemy.classname == "monster_zombie") {
    ldmg = 300;
    }
  T_Damage(self.enemy, self, self, ldmg);
  if (side) {
    makevectors(self.angles);
    if (side == 1) {
      SpawnMeatSpray(self.origin + v_forward * FL_INWATER, crandom() * 100 * v_right);
      }
    else {
      SpawnMeatSpray(self.origin + v_forward * FL_INWATER, side * v_right);
      if (self.th_melee == enf3_melee && random() < 0.2) {
        sound(self, CHAN_BODY, "enf3/blhit.wav", 1, ATTN_IDLE);
        }
      }
    }
}

Void function ogre_stand1();
{
  #0 ogre_stand2;
  ai_stand();
}

Void function ogre_stand2();
{
  #1 ogre_stand3;
  ai_stand();
  ai_emnity("monster_qguy", 600, 0);
}

Void function ogre_stand3();
{
  #2 ogre_stand4;
  ai_stand();
}

Void function ogre_stand4();
{
  #3 ogre_stand5;
  ai_stand();
}

Void function ogre_stand5();
{
  #4 ogre_stand6;
  if (random() < 0.2) {
    sound(self, CHAN_VOICE, "ogre/ogidle.wav", 1, ATTN_IDLE);
    }
  ai_stand();
}

Void function ogre_stand6();
{
  #5 ogre_stand7;
  ai_stand();
}

Void function ogre_stand7();
{
  #6 ogre_stand8;
  ai_stand();
  ai_emnity("monster_qguy", 600, 0);
}

Void function ogre_stand8();
{
  #7 ogre_stand9;
  ai_stand();
}

Void function ogre_stand9();
{
  #8 ogre_stand1;
  ai_stand();
}

Void function ogre_boogie();
{
  if (self.walkframe >= 8) {
    self.walkframe = 0;
    if (self.objekt) {
      if (!(ai_checkobjdist(200))) {
        #24 ogre_walk1;
        exit;
        }
      }
    }
  #25 ogre_boogie;
  self.frame = 25 + self.walkframe;
  self.walkframe = self.walkframe + 1;
  if (self.walkframe == 5) {
    ai_objledge();
    }
  if (random() < 0.5) {
    ai_walk(15);
    }
  else {
    ai_walk(24);
    }
}

Void function ogre_back();
{
  if (self.walkframe >= 8) {
    self.walkframe = 0;
    self.touch = objekt_touch;
    #8 ogre_stand1;
    exit;
    }
  #25 ogre_back;
  self.frame = 32 - self.walkframe;
  self.walkframe = self.walkframe + 1;
  ai_back(8);
}

Void function ogre_walk1();
{
  if (self.objekt && self.objekt.classname == "player") {
    if (ai_checkobjdist(300)) {
      self.walkframe = 0;
      #9 ogre_boogie;
      ai_walk(MOVETYPE_WALK);
      exit;
      }
    }
  #9 ogre_walk2;
  ai_walk(MOVETYPE_WALK);
}

Void function ogre_walk2();
{
  #10 ogre_walk3;
  ai_walk(FL_SWIM);
  ai_emnity("monster_qguy", 600, 0);
}

Void function ogre_walk3();
{
  #11 ogre_walk4;
  ai_walk(FL_SWIM);
  if (random() < 0.2) {
    sound(self, CHAN_VOICE, "ogre/ogidle.wav", 1, ATTN_IDLE);
    }
}

Void function ogre_walk4();
{
  #12 ogre_walk5;
  ai_walk(FL_SWIM);
  ai_emnity("monster_qguy", 600, 0);
}

Void function ogre_walk5();
{
  #13 ogre_walk6;
  ai_walk(FL_SWIM);
}

Void function ogre_walk6();
{
  #14 ogre_walk7;
  ai_walk(MOVETYPE_FLY);
  if (random() < 0.1) {
    sound(self, CHAN_VOICE, "ogre/ogdrag.wav", 1, ATTN_IDLE);
    }
}

Void function ogre_walk7();
{
  #15 ogre_walk8;
  ai_walk(MOVETYPE_WALK);
}

Void function ogre_walk8();
{
  #16 ogre_walk9;
  ai_walk(FL_SWIM);
}

Void function ogre_walk9();
{
  #17 ogre_walk10;
  ai_walk(MOVETYPE_WALK);
}

Void function ogre_walk10();
{
  #18 ogre_walk11;
  ai_walk(1);
}

Void function ogre_walk11();
{
  #19 ogre_walk12;
  ai_walk(FL_SWIM);
  ai_emnity("monster_qguy", 600, 0);
}

Void function ogre_walk12();
{
  #20 ogre_walk13;
  ai_walk(MOVETYPE_WALK);
}

Void function ogre_walk13();
{
  #21 ogre_walk14;
  ai_walk(MOVETYPE_WALK);
  ai_emnity("monster_qguy", 1200, 0);
}

Void function ogre_walk14();
{
  #22 ogre_walk15;
  ai_walk(MOVETYPE_WALK);
}

Void function ogre_walk15();
{
  #23 ogre_walk16;
  ai_walk(MOVETYPE_WALK);
}

Void function ogre_walk16();
{
  #24 ogre_walk1;
  ai_walk(MOVETYPE_STEP);
  ai_emnity("monster_qguy", 600, 0);
}

Void function ogre_run1();
{
  #25 ogre_run2;
  ai2_run(MOVETYPE_FLYMISSILE);
  if (random() < 0.2) {
    sound(self, CHAN_VOICE, "ogre/ogidle2.wav", 1, ATTN_IDLE);
    }
}

Void function ogre_run2();
{
  #26 ogre_run3;
  ai2_run(12);
}

Void function ogre_run3();
{
  #27 ogre_run4;
  ai2_run(FL_CLIENT);
}

Void function ogre_run4();
{
  #28 ogre_run5;
  ai2_run(22);
}

Void function ogre_run5();
{
  #29 ogre_run6;
  ai2_run(FL_INWATER);
}

Void function ogre_run6();
{
  #30 ogre_run7;
  ai2_run(MOVETYPE_STEP);
}

Void function ogre_run7();
{
  #31 ogre_run8;
  ai2_run(13);
}

Void function ogre_run8();
{
  #32 ogre_run1;
  ai2_run(24);
}

Void function ogre_swing1();
{
  #33 ogre_swing2;
  ai_charge(MOVETYPE_BOUNCEMISSILE);
  sound(self, CHAN_WEAPON, "ogre/ogsawatk.wav", 1, ATTN_NORM);
}

Void function ogre_swing2();
{
  #34 ogre_swing3;
  ai_charge(1);
}

Void function ogre_swing3();
{
  #35 ogre_swing4;
  ai_charge(MOVETYPE_STEP);
}

Void function ogre_swing4();
{
  #36 ogre_swing5;
  ai_charge(13);
}

Void function ogre_swing5();
{
  #37 ogre_swing6;
  ai_charge(MOVETYPE_FLYMISSILE);
  chainsaw(0);
  self.angles_y = self.angles_y + random() * 25;
}

Void function ogre_swing6();
{
  #38 ogre_swing7;
  chainsaw(200);
  self.angles_y = self.angles_y + random() * 25;
}

Void function ogre_swing7();
{
  #39 ogre_swing8;
  chainsaw(0);
  self.angles_y = self.angles_y + random() * 25;
}

Void function ogre_swing8();
{
  #40 ogre_swing9;
  chainsaw(0);
  self.angles_y = self.angles_y + random() * 25;
}

Void function ogre_swing9();
{
  #41 ogre_swing10;
  chainsaw(0);
  self.angles_y = self.angles_y + random() * 25;
}

Void function ogre_swing10();
{
  #42 ogre_swing11;
  chainsaw(-200);
  self.angles_y = self.angles_y + random() * 25;
}

Void function ogre_swing11();
{
  #43 ogre_swing12;
  chainsaw(0);
  self.angles_y = self.angles_y + random() * 25;
}

Void function ogre_swing12();
{
  #44 ogre_swing13;
  ai_charge(MOVETYPE_WALK);
}

Void function ogre_swing13();
{
  #45 ogre_swing14;
  ai_charge(FL_CLIENT);
}

Void function ogre_swing14();
{
  #46 ogre_run1;
  ai_charge(MOVETYPE_FLYMISSILE);
}

Void function ogre_smash1();
{
  #47 ogre_smash2;
  ai_charge(MOVETYPE_TOSS);
  sound(self, CHAN_WEAPON, "ogre/ogsawatk.wav", 1, ATTN_NORM);
}

Void function ogre_smash2();
{
  #48 ogre_smash3;
  ai_charge(1);
}

Void function ogre_smash3();
{
  #49 ogre_smash4;
  ai_charge(1);
}

Void function ogre_smash4();
{
  #50 ogre_smash5;
  ai_charge(1);
}

Void function ogre_smash5();
{
  #51 ogre_smash6;
  ai_charge(MOVETYPE_STEP);
}

Void function ogre_smash6();
{
  #52 ogre_smash7;
  ai_charge(MOVETYPE_STEP);
  chainsaw(0);
}

Void function ogre_smash7();
{
  #53 ogre_smash8;
  ai_charge(MOVETYPE_STEP);
  chainsaw(0);
}

Void function ogre_smash8();
{
  #54 ogre_smash9;
  ai_charge(MOVETYPE_BOUNCE);
  chainsaw(0);
}

Void function ogre_smash9();
{
  #55 ogre_smash10;
  ai_charge(13);
  chainsaw(0);
}

Void function ogre_smash10();
{
  #56 ogre_smash11;
  chainsaw(1);
}

Void function ogre_smash11();
{
  #57 ogre_smash12;
  ai_charge(FL_SWIM);
  chainsaw(0);
  self.nextthink = self.nextthink + random() * 0.2;
}

Void function ogre_smash12();
{
  #58 ogre_smash13;
  ai_charge(1);
}

Void function ogre_smash13();
{
  #59 ogre_smash14;
  ai_charge(MOVETYPE_STEP);
}

Void function ogre_smash14();
{
  #60 ogre_run1;
  ai_charge(12);
}

Void function ogre_nail1();
{
  #61 ogre_nail2;
  ai_face();
}

Void function ogre_nail2();
{
  #62 ogre_nail3;
  ai_face();
  if (self.classname != "monster_ogre") {
    ai2_jumpsplash(-200, [0 0 200]);
    }
}

Void function ogre_nail3();
{
  #62 ogre_nail4;
  ai_face();
}

Void function ogre_nail4();
{
  #63 ogre_nail5;
  ai_face();
  if (self.classname == "monster_ogre") {
    Mons_fire_nails();
    }
  else {
    OgreFireGrenade();
    }
}

Void function ogre_nail5();
var
 num : Real;
{
  num = 2 + skill;
  num = num * 0.1;
  if (visible(self.enemy) && random() < num) {
    #64 ogre_nail3;
    ai_face();
    exit;
    }
  #64 ogre_nail6;
  ai_face();
}

Void function ogre_nail6();
{
  #65 ogre_nail7;
  ai_face();
}

Void function ogre_nail7();
{
  #66 ogre_run1;
}

Void function ogre_pain1();
{
  #67 ogre_pain2;
}

Void function ogre_pain2();
{
  #68 ogre_pain3;
}

Void function ogre_pain3();
{
  #69 ogre_pain4;
}

Void function ogre_pain4();
{
  #70 ogre_pain5;
}

Void function ogre_pain5();
{
  #71 ogre_run1;
}

Void function ogre_painb1();
{
  #72 ogre_painb2;
}

Void function ogre_painb2();
{
  #73 ogre_painb3;
}

Void function ogre_painb3();
{
  #74 ogre_run1;
}

Void function ogre_painc1();
{
  #75 ogre_painc2;
}

Void function ogre_painc2();
{
  #76 ogre_painc3;
}

Void function ogre_painc3();
{
  #77 ogre_painc4;
}

Void function ogre_painc4();
{
  #78 ogre_painc5;
}

Void function ogre_painc5();
{
  #79 ogre_painc6;
}

Void function ogre_painc6();
{
  #80 ogre_run1;
}

Void function ogre_paind1();
{
  #81 ogre_paind2;
}

Void function ogre_paind2();
{
  #82 ogre_paind3;
  ai_pain(MOVETYPE_BOUNCE);
}

Void function ogre_paind3();
{
  #83 ogre_paind4;
  ai_pain(MOVETYPE_FLYMISSILE);
}

Void function ogre_paind4();
{
  #84 ogre_paind5;
  ai_pain(MOVETYPE_STEP);
}

Void function ogre_paind5();
{
  #85 ogre_paind6;
}

Void function ogre_paind6();
{
  #86 ogre_paind7;
}

Void function ogre_paind7();
{
  #87 ogre_paind8;
}

Void function ogre_paind8();
{
  #88 ogre_paind9;
}

Void function ogre_paind9();
{
  #89 ogre_paind10;
}

Void function ogre_paind10();
{
  #90 ogre_paind11;
}

Void function ogre_paind11();
{
  #91 ogre_paind12;
}

Void function ogre_paind12();
{
  #92 ogre_paind13;
}

Void function ogre_paind13();
{
  #93 ogre_paind14;
}

Void function ogre_paind14();
{
  #94 ogre_paind15;
}

Void function ogre_paind15();
{
  #95 ogre_paind16;
}

Void function ogre_paind16();
{
  #96 ogre_run1;
}

Void function ogre_paine1();
{
  #97 ogre_paine2;
}

Void function ogre_paine2();
{
  #98 ogre_paine3;
  ai_pain(MOVETYPE_BOUNCE);
}

Void function ogre_paine3();
{
  #99 ogre_paine4;
  ai_pain(MOVETYPE_FLYMISSILE);
}

Void function ogre_paine4();
{
  #100 ogre_paine5;
  ai_pain(MOVETYPE_STEP);
}

Void function ogre_paine5();
{
  #101 ogre_paine6;
}

Void function ogre_paine6();
{
  #102 ogre_paine7;
}

Void function ogre_paine7();
{
  #103 ogre_paine8;
}

Void function ogre_paine8();
{
  #104 ogre_paine9;
}

Void function ogre_paine9();
{
  #105 ogre_paine10;
}

Void function ogre_paine10();
{
  #106 ogre_paine11;
}

Void function ogre_paine11();
{
  #107 ogre_paine12;
}

Void function ogre_paine12();
{
  #108 ogre_paine13;
}

Void function ogre_paine13();
{
  #109 ogre_paine14;
}

Void function ogre_paine14();
{
  #110 ogre_paine15;
}

Void function ogre_paine15();
{
  #111 ogre_run1;
}

Void function ogre_pain(attacker : Object; damage : Real);
var
 r : Real;
{
  if (self.pain_finished > time) {
    exit;
    }
  sound(self, CHAN_VOICE, "ogre/ogpain1.wav", 1, ATTN_NORM);
  r = random();
  if (r < 0.25) {
    ogre_pain1();
    self.pain_finished = time + 1;
    }
  else {
    if (r < 0.5) {
      ogre_painb1();
      self.pain_finished = time + 1;
      }
    else {
      if (r < 0.75) {
        ogre_painc1();
        self.pain_finished = time + 1;
        }
      else {
        if (r < 0.88) {
          ogre_paind1();
          self.pain_finished = time + FL_SWIM;
          }
        else {
          ogre_paine1();
          self.pain_finished = time + FL_SWIM;
          }
        }
      }
    }
}

Void function ogre_die1();
{
  dead_stay_dead();
  #112 ogre_die2;
}

Void function ogre_die2();
{
  #113 ogre_die3;
}

Void function ogre_die3();
{
  #114 ogre_die4;
  self.solid = SOLID_NOT;
  if (self.classname == "monster_ogre_marksman") {
    self.ammo_rockets = FL_SWIM;
    }
  else {
    self.ammo_nails = MOVETYPE_PUSH;
    }
  DropBackpack();
}

Void function ogre_die4();
{
  #115 ogre_die5;
}

Void function ogre_die5();
{
  #116 ogre_die6;
}

Void function ogre_die6();
{
  #117 ogre_die7;
}

Void function ogre_die7();
{
  #118 ogre_die8;
}

Void function ogre_die8();
{
  #119 ogre_die9;
}

Void function ogre_die9();
{
  #120 ogre_die10;
}

Void function ogre_die10();
{
  #121 ogre_die11;
}

Void function ogre_die11();
{
  #122 ogre_die12;
}

Void function ogre_die12();
{
  #123 ogre_die13;
}

Void function ogre_die13();
{
  #124 ogre_die14;
}

Void function ogre_die14();
{
  #125 corpse_think;
}

Void function ogre_bdie1();
{
  dead_stay_dead();
  #126 ogre_bdie2;
}

Void function ogre_bdie2();
{
  #127 ogre_bdie3;
  ai_forward(MOVETYPE_FLY);
}

Void function ogre_bdie3();
{
  #128 ogre_bdie4;
  self.solid = SOLID_NOT;
  if (self.classname == "monster_ogre_marksman") {
    self.ammo_rockets = MOVETYPE_WALK;
    }
  else {
    self.ammo_nails = MOVETYPE_BOUNCE;
    }
  DropBackpack();
}

Void function ogre_bdie4();
{
  #129 ogre_bdie5;
  ai_forward(1);
}

Void function ogre_bdie5();
{
  #130 ogre_bdie6;
  ai_forward(MOVETYPE_WALK);
}

Void function ogre_bdie6();
{
  #131 ogre_bdie7;
  ai_forward(MOVETYPE_PUSH);
}

Void function ogre_bdie7();
{
  #132 ogre_bdie8;
  ai_forward(25);
}

Void function ogre_bdie8();
{
  #133 ogre_bdie9;
}

Void function ogre_bdie9();
{
  #134 ogre_bdie10;
}

Void function ogre_bdie10();
{
  #135 corpse_think;
}

Void function ogre_die();
{
  if (self.health < -80) {
    sound(self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
    ThrowHead("progs/h_ogre.mdl", self.health);
    ThrowGib("progs/gib3.mdl", self.health);
    ThrowGib("progs/gib3.mdl", self.health);
    ThrowGib("progs/gib3.mdl", self.health);
    exit;
    }
  if (self.flags & FL_ONGROUND) {
    self.flags = self.flags - FL_ONGROUND;
    }
  sound(self, CHAN_VOICE, "ogre/ogdth.wav", 1, ATTN_NORM);
  if (random() < 0.5) {
    ogre_die1();
    }
  else {
    ogre_bdie1();
    }
}

Void function ogre_melee();
{
  if (random() > 0.5) {
    ogre_smash1();
    }
  else {
    ogre_swing1();
    }
}

Void function monster_ogre();
{
  if (deathmatch) {
    remove(self);
    exit;
    }
  total_monsters = total_monsters + 1;
  precache_model("progs/ogre.mdl");
  precache_model("progs/h_ogre.mdl");
  precache_model("progs/grenade.mdl");
  precache_sound("ogre/ogdrag.wav");
  precache_sound("ogre/ogdth.wav");
  precache_sound("ogre/ogidle.wav");
  precache_sound("ogre/ogidle2.wav");
  precache_sound("ogre/ogpain1.wav");
  precache_sound("ogre/ogsawatk.wav");
  precache_sound("ogre/ogwake.wav");
  if (self.targetname == "actor21" || self.targetname == "actor22") {
    self.th_stand = ogre_wait;
    self.th_walk = ogre_wait;
    }
  else {
    self.th_stand = ogre_stand1;
    self.th_walk = ogre_walk1;
    }
  self.th_run = ogre_run1;
  self.th_die = ogre_die;
  self.th_melee = ogre_melee;
  self.th_missile = ogre_nail1;
  self.th_runfire = ogre_runfire1;
  self.th_pain = ogre_pain;
  if (self.relations > 2) {
    self.th_back = ogre_back;
    }
  if (self.brain & TRIGGER_SPAWN) {
    self.use = ogre_tstart;
    exit;
    }
  carnify_ogre();
}

Void function ogre_tstart();
{
  trigger_spawnmonster();
  carnify_ogre();
}

Void function carnify_ogre();
{
  self.solid = SOLID_SLIDEBOX;
  self.movetype = MOVETYPE_STEP;
  setmodel(self, "progs/ogre.mdl");
  setsize(self, VEC_HULL2_MIN, VEC_HULL2_MAX);
  if (!(self.health)) {
    self.health = 205;
    }
  self.button0 = 90;
  walkmonster_start();
}

Void function ogre_wait();
{
  self.use = ogre_begin;
  if (self.walkframe >= 9) {
    self.walkframe = 0;
    }
  #0 ogre_wait;
  self.frame = 0 + self.walkframe;
  self.walkframe = self.walkframe + 1;
}

Void function ogre_begin();
{
  self.th_stand = ogre_stand1;
  self.th_walk = ogre_walk1;
  self.use = monster_use;
  if (self.goalentity == world) {
    #0 ogre_stand1;
    }
  else {
    #0 ogre_walk1;
    }
}

Void function monster_ogre_marksman();
{
  monster_ogre();
}

Void function ogre_runfire1();
{
  self.walkframe = 0;
  self.tactic = 1;
  ogre_runfire2();
}

Void function ogre_runfire2();
{
  if (self.walkframe >= 8) {
    self.walkframe = 0;
    if (ai_threats() && visible(self.enemy)) {
      ogre_runfire2();
      exit;
      }
    self.tactic = 0;
    #32 ogre_run1;
    ai2_run(25);
    exit;
    }
  #147 ogre_runfire2;
  self.frame = 147 + self.walkframe;
  self.walkframe = self.walkframe + 1;
  ai_face();
  if (self.walkframe == 4) {
    if (self.classname == "monster_ogre") {
      Mons_fire_nails();
      }
    else {
      OgreFireGrenade();
      ai2_jumpsplash(-200, [0 0 200]);
      }
    }
  if (ai_threats()) {
    exit;
    }
  ai_run_slide(9);
}

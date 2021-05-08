Void function gaunt_ring(num : Real);
var
 missile : Object;
 mpuff : Object;
 org : Vector;
 vec : Vector;
 vec2 : Vector;
{
  makevectors(self.angles);
  if (num == 0) {
    vec2 = self.origin + v_forward * FL_CLIENT + [0 0 16];
    }
  else {
    if (num == 1) {
      vec2 = self.origin + v_right * 35;
      }
    else {
      vec2 = self.origin + v_right * -35;
      }
    }
  ai2_jumpsplash(-200, [0 0 200]);
  self.effects = self.effects | EF_MUZZLEFLASH;
  sound(self, CHAN_BODY, "archg/fire2.wav", 1, ATTN_NORM);
  org = self.origin + v_forward * SVC_INTERMISSION + v_right * 8.5 + [0 0 16];
  vec = normalize(vec);
  missile = spawn();
  missile.enemy = self.enemy;
  missile.owner = self;
  missile.movetype = MOVETYPE_FLYMISSILE;
  missile.solid = SOLID_BBOX;
  missile.event = "mthret";
  missile.effects = EF_RED;
  makevectors(self.angles);
  missile.velocity = normalize(self.enemy.origin - vec2);
  if (self.classname == "gaunt") {
    missile.velocity = missile.velocity * 700;
    missile.avelocity = [100 100 100];
    }
  else {
    missile.velocity = missile.velocity * 1000;
    missile.avelocity = [700 700 200];
    }
  missile.angles = vectoangles(missile.velocity);
  missile.touch = gring_touch;
  missile.nextthink = time + MOVETYPE_FLY;
  missile.think = SUB_Remove;
  setmodel(missile, "progs/gring.mdl");
  setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
  setorigin(missile, vec2);
}

Void function gring_touch();
var
 damg : Real;
 vec : Vector;
 mark : Object;
 num : Real;
{
  if (other == self.owner) {
    exit;
    }
  if (other.classname == self.owner.classname) {
    mark = self.owner;
    self.owner = other;
    if (mark.flags & FL_ONGROUND) {
      makevectors(mark.angles);
      mark.origin_z = mark.origin_z + 1;
      if (random() < 0.4) {
        num = 175;
        }
      else {
        num = -175;
        }
      mark.velocity = v_right * num + [0 0 225];
      mark.flags = mark.flags - FL_ONGROUND;
      self.velocity = [0 0 1000];
      exit;
      }
    }
  if (pointcontents(self.origin) == CONTENT_SKY) {
    remove(self);
    exit;
    }
  self.origin = self.origin - FL_CLIENT * normalize(self.velocity);
  sound(self, CHAN_ENDER, "boss3/nehdie4.wav", 1, ATTN_NORM);
  WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
  WriteByte(MSG_BROADCAST, TE_LAVASPLASH);
  WriteCoord(MSG_BROADCAST, self.origin_x);
  WriteCoord(MSG_BROADCAST, self.origin_y);
  WriteCoord(MSG_BROADCAST, self.origin_z - 50);
  damg = 5 + (random() * 20);
  if (other.health) {
    T_Damage(other, self, self.owner, damg);
    BecomeExplosion3();
    exit;
    }
  remove(self);
}

Void function gaunt_kneel();
{
  self.event = "gauntmourn";
  self.goalentity = world;
  gaunt2_kneel();
}

Void function gaunt2_kneel();
{
  if (self.walkframe >= 8) {
    self.walkframe = 0;
    if (self.event == "gauntmourn") {
      self.event = "done";
      gaunt_pray();
      }
    else {
      gaunt_stand();
      }
    exit;
    }
  #138 gaunt2_kneel;
  if (self.event == "gauntmourn") {
    self.frame = 138 + self.walkframe;
    }
  else {
    self.frame = 145 - self.walkframe;
    }
  self.walkframe = self.walkframe + 1;
  ai_stand();
}

Void function gaunt_pray();
{
  if (self.walkframe >= 7) {
    self.walkframe = 0;
    if (random() < 0.2) {
      gaunt2_kneel();
      exit;
      }
    }
  #146 gaunt_pray;
  self.frame = 146 + self.walkframe;
  self.walkframe = self.walkframe + 1;
  ai_stand();
  if (self.skin == 0) {
    self.skin = 1;
    }
  else {
    self.skin = 0;
    }
  if (self.walkframe == 1) {
    sound(self, CHAN_VOICE, "gaunt/g10.wav", 1, ATTN_NORM);
    }
  if (self.walkframe == 4) {
    sound(self, CHAN_VOICE, "gaunt/g11.wav", 1, ATTN_NORM);
    }
  if (self.walkframe == 6) {
    sound(self, CHAN_VOICE, "gaunt/g1.wav", 1, ATTN_NORM);
    }
}

Void function gaunt_crucified();
{
  if (self.walkframe >= 20) {
    self.walkframe = 0;
    }
  #153 gaunt_crucified;
  self.frame = 153 + self.walkframe;
  self.walkframe = self.walkframe + 1;
  self.nextthink = time + 0.1 + random() * 0.1;
}

Void function gaunt_dieagain();
{
  if (self.health < -35) {
    gaunt_gibs();
    exit;
    }
  self.health = 50;
  self.takedamage = DAMAGE_AIM;
  gaunt_crucdead();
}

Void function gaunt_crucdead();
{
  if (self.health < -35) {
    gaunt_gibs();
    exit;
    }
  self.th_die = gaunt_gibs;
  if (random() < 0.5) {
    gaunt_crucdead1();
    }
  else {
    gaunt_crucdead2();
    }
}

Void function gaunt_crucdead1();
{
  #173 gaunt_crucdead1;
}

Void function gaunt_crucdead2();
{
  #174 gaunt_crucdead2;
}

Void function gaunt_boxed();
{
  #175 gaunt_boxed;
}

Void function gaunt_retreat();
{
  if (visible(self.enemy)) {
    self.walkframe = 0;
    sound(self, CHAN_BODY, "gaunt/boom.wav", 1, ATTN_NORM);
    gaunt_runfire();
    exit;
    }
  if (!ai_threats()) {
    gaunt_arg_control();
    }
  if (self.walkframe >= 6) {
    self.walkframe = 0;
    }
  #176 gaunt_retreat;
  self.frame = 176 + self.walkframe;
  self.walkframe = self.walkframe + 1;
}

Void function gaunt_runfire();
var
 dist : Real;
{
  if (self.enemy.health < 1) {
    gaunt_arg_control();
    exit;
    }
  if (!visible(self.enemy)) {
    gaunt_retreat();
    exit;
    }
  ai_face();
  ai_threats();
  if (self.walkframe >= 6) {
    self.walkframe = 0;
    gaunt_retreat();
    exit;
    }
  #182 gaunt_runfire;
  self.frame = 182 + self.walkframe;
  self.walkframe = self.walkframe + 1;
  dist = vlen(self.origin - self.enemy.origin);
  if (dist < 400) {
    if (self.walkframe == 3) {
      sound(self, CHAN_VOICE, "gaunt/elekt.wav", 1, ATTN_NORM);
      }
    if (self.walkframe > 2 && self.walkframe < 5) {
      MaxRedLightning();
      }
    }
  else {
    if (self.walkframe == 3) {
      gaunt_ring(0);
      }
    }
}

Void function gaunt_gibs();
{
  sound(self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
  ThrowHead("progs/h_gaunt.mdl", self.health);
  ThrowGib("progs/gib1.mdl", self.health);
  ThrowGib("progs/gib2.mdl", self.health);
  ThrowGib("progs/gib3.mdl", self.health);
  exit;
}

Void function gaunt_stand();
{
  ai_stand();
  if (random() < 0.2) {
    ai_emnity("monster_qguy", 1500, 0);
    }
  if (self.walkframe >= 12) {
    self.walkframe = 0;
    if (self.enemy != world) {
      #0 gaunt_arg_control;
      exit;
      }
    }
  #0 gaunt_stand;
  self.frame = 0 + self.walkframe;
  self.walkframe = self.walkframe + 1;
  if (self.walkframe == 5) {
    if (self.enemy == world) {
      if (ai_mourndead()) {
        exit;
        }
      }
    }
  if (self.enemy != world && self.enemy.health > 0) {
    gaunt_talk();
    }
  else {
    if (self.walkframe == 8 && self.enemy == world) {
      gaunt_select_kin();
      }
    }
}

Void function gaunt_shakefists();
{
  ai_face();
  if (self.walkframe >= 15) {
    self.walkframe = 0;
    #32 gaunt_arg_control;
    exit;
    }
  #32 gaunt_shakefists;
  self.frame = 32 + self.walkframe;
  self.walkframe = self.walkframe + 1;
  if (self.enemy != world) {
    gaunt_talk();
    }
  if (self.flags & FL_FLEE) {
    Gaunt_Teleport();
    }
}

Void function gaunt_shimmy();
{
  if (self.walkframe >= 10) {
    self.walkframe = 0;
    #22 gaunt_arg_control;
    exit;
    }
  #22 gaunt_shimmy;
  self.frame = 22 + self.walkframe;
  self.walkframe = self.walkframe + 1;
  ai_face();
}

Void function gaunt_wardoff();
{
  if (self.walkframe >= 8) {
    self.walkframe = 0;
    if (self.enemy == world) {
      #66 gaunt_lowfinger;
      exit;
      }
    if (self.enemy.enemy == self) {
      self.enemy.enemy = self.enemy.oldenemy;
      gaunt_quirk();
      }
    #73 gaunt_shakefinger;
    exit;
    }
  #66 gaunt_wardoff;
  self.frame = 66 + self.walkframe;
  self.walkframe = self.walkframe + 1;
  ai_face();
}

Void function gaunt_shakefinger();
{
  if (self.walkframe >= 12) {
    self.walkframe = 0;
    if (random() < 0.4) {
      #77 gaunt_lowfinger;
      exit;
      }
    }
  #77 gaunt_shakefinger;
  self.frame = 77 + self.walkframe;
  self.walkframe = self.walkframe + 1;
  ai_face();
}

Void function gaunt_lowfinger();
{
  if (self.walkframe >= 8) {
    self.walkframe = 0;
    #66 gaunt_arg_control;
    if (self.enemy.classname != "player") {
      self.enemy = world;
      }
    exit;
    }
  #66 gaunt_lowfinger;
  self.frame = 73 - self.walkframe;
  self.walkframe = self.walkframe + 1;
  ai_face();
}

Void function gaunt_die();
{
  if (self.health < -35) {
    gaunt_gibs();
    exit;
    }
  sound(self, CHAN_VOICE, "gaunt/death.wav", 1, ATTN_NORM);
  self.walkframe = 0;
  if (random() < 0.5) {
    #53 gaunt_dback;
    }
  else {
    #90 gaunt_death;
    }
}

Void function gaunt_dback();
{
  #54 gaunt_dback3;
  self.solid = SOLID_NOT;
}

Void function gaunt_dback3();
{
  #55 gaunt_dback4;
}

Void function gaunt_dback4();
{
  #56 gaunt_dback5;
}

Void function gaunt_dback5();
{
  #57 corpse_think;
}

Void function gaunt_death();
{
  if (self.walkframe >= 16) {
    self.solid = SOLID_NOT;
    #104 gaunt_nothing;
    exit;
    }
  #89 gaunt_death;
  self.frame = 89 + self.walkframe;
  self.walkframe = self.walkframe + 1;
}

Void function gaunt_shoot();
{
  if (self.walkframe >= 12) {
    self.walkframe = 0;
    if (self.enemy.health < 1) {
      #116 gaunt_endshoot;
      exit;
      }
    #119 gaunt_beam;
    exit;
    }
  #105 gaunt_shoot;
  self.frame = 105 + self.walkframe;
  self.walkframe = self.walkframe + 1;
  if (self.walkframe > 6 && self.walkframe < 10) {
    self.effects = self.effects | EF_MUZZLEFLASH;
    }
  if (self.walkframe > 11) {
    GauntLightning();
    sound(self, CHAN_BODY, "gaunt/boom.wav", 1, ATTN_NORM);
    }
}

Void function gaunt_beam();
{
  #117 gaunt_beam1;
  GauntLightning();
  ai_face();
}

Void function gaunt_beam1();
{
  #118 gaunt_beam2;
  ai_face();
  if (self.enemy.classname != self.classname) {
    sound(self, CHAN_VOICE, "gaunt/elekt.wav", 1, ATTN_NORM);
    }
}

Void function gaunt_beam2();
var
 megadeth : Vector;
{
  megadeth = self.enemy.origin - self.origin;
  if (visible(self.enemy) && self.enemy.health > 10) {
    if (vlen(megadeth) < 250 && random() < 0.3) {
      #119 gaunt_beam;
      GauntLightning();
      ai_face();
      exit;
      }
    }
  self.walkframe = 0;
  #119 gaunt_endshoot;
}

Void function gaunt_endshoot();
{
  if (self.walkframe >= 12) {
    self.walkframe = 0;
    #0 gaunt_motion;
    exit;
    }
  #105 gaunt_endshoot;
  self.frame = 116 - self.walkframe;
  self.walkframe = self.walkframe + 1;
}

Void function gaunt_nothing();
{
  #104 corpse_think;
}

Void function gaunt_motion();
{
  if (self.walkframe >= 10) {
    self.walkframe = 0;
    }
  if (self.walkframe == 5) {
    if (self.enemy != world) {
      if (self.enemy.classname == self.classname) {
        if (ai_mourndead()) {
          exit;
          }
        }
      }
    }
  #12 gaunt_motion;
  self.frame = 12 + self.walkframe;
  self.walkframe = self.walkframe + 1;
  if (self.enemy != world) {
    ai_run(4);
    }
  else {
    if (self.goalentity != world) {
      ai_walk(4);
      if (self.goalentity.classname == self.classname) {
        self.goalentity = world;
        }
      }
    else {
      self.walkframe = 0;
      #0 gaunt_stand;
      exit;
      }
    }
}

Void function gaunt_pain();
{
  if (self.pain_finished > time) {
    if (self.enemy.weapon == IT_SWORD && random() > 0.8) {
      gaunt_runfire();
      }
    exit;
    }
  self.pain_finished = time + 1.1;
  if (visible(self.enemy)) {
    if (random() < 0.3) {
      #127 gaunt_rock2;
      exit;
      }
    }
  #47 gaunt_pain1;
}

Void function gaunt_pain1();
{
  #48 gaunt_pain2;
}

Void function gaunt_pain2();
{
  #49 gaunt_pain3;
}

Void function gaunt_pain3();
{
  #50 gaunt_pain4;
}

Void function gaunt_pain4();
{
  #51 gaunt_pain5;
}

Void function gaunt_pain5();
{
  self.walkframe = 0;
  if (random() < 0.3 && visible(self.enemy)) {
    gaunt_runfire();
    exit;
    }
  #52 gaunt_motion;
}

Void function gaunt_swing2();
{
  #125 gaunt_swing3;
  ai_face();
}

Void function gaunt_swing3();
{
  #124 gaunt_swing4;
  ai_face();
}

Void function gaunt_swing4();
{
  #123 gaunt_swing5;
  GauntMissile();
  ai_face();
}

Void function gaunt_swing5();
{
  #122 gaunt_swing6;
  ai_face();
}

Void function gaunt_swing6();
{
  #121 gaunt_swing7;
}

Void function gaunt_swing7();
{
  self.walkframe = 0;
  #120 gaunt_motion;
}

Void function gaunt_rock2();
{
  #128 gaunt_rock3;
  if (self.flags & FL_ONGROUND) {
    makevectors(self.angles);
    self.origin_z = self.origin_z + 1;
    self.velocity = v_forward * -200 + [10 10 150];
    self.flags = self.flags - FL_ONGROUND;
    }
}

Void function gaunt_rock3();
{
  #129 gaunt_rock4;
}

Void function gaunt_rock4();
{
  #130 gaunt_rock5;
}

Void function gaunt_rock5();
{
  #131 gaunt_rock6;
}

Void function gaunt_rock6();
{
  #130 gaunt_rock7;
}

Void function gaunt_rock7();
{
  #129 gaunt_rock8;
}

Void function gaunt_rock8();
{
  #128 gaunt_rock9;
}

Void function gaunt_rock9();
{
  self.walkframe = 0;
  #127 gaunt_motion;
}

Void function gaunt_clap1();
{
  #132 gaunt_clap2;
}

Void function gaunt_clap2();
{
  #133 gaunt_clap3;
}

Void function gaunt_clap3();
{
  #134 gaunt_clap4;
}

Void function gaunt_clap4();
{
  #135 gaunt_clap5;
}

Void function gaunt_clap5();
{
  #136 gaunt_clap6;
}

Void function gaunt_clap6();
{
  if (random() < 0.9) {
    #137 gaunt_clap5;
    sound(self, CHAN_VOICE, "gaunt/clap.wav", 1, ATTN_NORM);
    }
  else {
    #137 gaunt_clap7;
    }
}

Void function gaunt_clap7();
{
  #134 gaunt_clap8;
}

Void function gaunt_clap8();
{
  #133 gaunt_clap9;
  self.th_wins = Sub_Null;
}

Void function gaunt_clap9();
{
  #132 gaunt_arg_control;
}

Void function monster_gaunt();
{
  if (deathmatch) {
    remove(self);
    exit;
    }
  precache_model2("progs/gaunt.mdl");
  precache_model2("progs/gntspke.mdl");
  precache_model2("progs/h_gaunt.mdl");
  precache_model2("progs/gring.mdl");
  precache_sound2("gaunt/death.wav");
  precache_sound2("gaunt/elekt.wav");
  precache_sound2("gaunt/boom.wav");
  precache_sound2("gaunt/g14.wav");
  precache_sound2("gaunt/g13.wav");
  precache_sound2("gaunt/g12.wav");
  precache_sound2("gaunt/g11.wav");
  precache_sound2("gaunt/g10.wav");
  precache_sound2("gaunt/g9.wav");
  precache_sound2("gaunt/g8.wav");
  precache_sound2("gaunt/g7.wav");
  precache_sound2("gaunt/g6.wav");
  precache_sound2("gaunt/g4.wav");
  precache_sound2("gaunt/g3.wav");
  precache_sound2("gaunt/g2.wav");
  precache_sound2("gaunt/g1.wav");
  precache_sound2("gaunt/ga5.wav");
  precache_sound2("gaunt/ga8.wav");
  precache_sound2("gaunt/ga7.wav");
  precache_sound2("gaunt/ga6.wav");
  precache_sound2("gaunt/ga4.wav");
  precache_sound2("gaunt/ga3.wav");
  precache_sound2("gaunt/ga2.wav");
  precache_sound2("gaunt/ga1.wav");
  precache_sound2("gaunt/gspike.wav");
  precache_sound2("gaunt/spkhit.wav");
  precache_sound2("archg/fire2.wav");
  precache_sound2("gaunt/clap.wav");
  precache_sound2("boss3/nehdie4.wav");
  setmodel(self, "progs/gaunt.mdl");
  if (!(self.brain & NAVLOGIC)) {
    self.brain = self.brain | NAVLOGIC;
    }
  if (self.spawnflags & FL_NOTARGET) {
    self.movetype = MOVETYPE_NONE;
    self.th_die = gaunt_dieagain;
    gaunt_crucified();
    exit;
    }
  if (self.spawnflags & FL_GODMODE) {
    self.movetype = MOVETYPE_NONE;
    if (self.cnt == 1) {
      carnify_gaunt();
      self.th_die = gaunt_gibs;
      gaunt_crucdead1();
      exit;
      }
    if (self.cnt == 2) {
      carnify_gaunt();
      self.th_die = gaunt_gibs;
      gaunt_crucdead2();
      exit;
      }
    if (self.cnt == 3) {
      carnify_gaunt();
      self.th_die = gaunt_gibs;
      gaunt_boxed();
      exit;
      }
    carnify_gaunt();
    gaunt_crucdead();
    exit;
    }
  total_monsters = total_monsters + 1;
  if (self.targetname == "actor23" || self.targetname == "actor24" || self.targetname == "actor25") {
    self.th_stand = gaunt_wait;
    self.th_walk = gaunt_wait;
    }
  else {
    self.th_stand = gaunt_stand;
    self.th_walk = gaunt_motion;
    }
  self.th_run = gaunt_motion;
  self.th_missile = gaunt_arg_control;
  self.th_pain = gaunt_pain;
  self.th_mourn = gaunt_kneel;
  self.th_die = gaunt_die;
  self.th_wins = gaunt_clap1;
  if (self.cnt == 1) {
    self.flags = self.flags & FL_COMMAND;
    }
  if (self.brain & TRIGGER_SPAWN) {
    self.use = gaunt_start;
    exit;
    }
  carnify_gaunt();
  walkmonster_start();
}

Void function gaunt_start();
{
  trigger_spawnmonster();
  carnify_gaunt();
  walkmonster_start();
}

Void function carnify_gaunt();
{
  self.solid = SOLID_SLIDEBOX;
  self.movetype = MOVETYPE_STEP;
  setsize(self, VEC_HULL_MIN, [12 12 40]);
  self.takedamage = DAMAGE_AIM;
  if (!(self.health)) {
    self.health = 200;
    }
}

Void function gaunt_wait();
{
  self.use = gaunt_begin;
  if (self.walkframe >= 12) {
    self.walkframe = 0;
    }
  #0 gaunt_wait;
  self.frame = 0 + self.walkframe;
  self.walkframe = self.walkframe + 1;
}

Void function gaunt_begin();
{
  self.th_stand = gaunt_stand;
  self.th_walk = gaunt_motion;
  self.use = monster_use;
  if (self.goalentity == world) {
    #0 gaunt_stand;
    }
  else {
    #0 gaunt_motion;
    }
}

Void function gaunt_talk();
{
  if (self.skin == 0) {
    self.skin = 1;
    if (self.enemy.classname == self.classname) {
      gaunt_voice();
      exit;
      }
    if (random() < 0.8) {
      gaunt_yell();
      }
    }
  else {
    self.skin = 0;
    }
}

Void function gaunt_voice();
var
 num : Real;
 mun : Real;
{
  num = random();
  mun = num + random();
  if (mun > 1.8) {
    sound(self, CHAN_VOICE, "gaunt/g14.wav", 1, ATTN_NORM);
    exit;
    }
  if (mun > 1.7) {
    sound(self, CHAN_VOICE, "gaunt/g13.wav", 1, ATTN_NORM);
    exit;
    }
  if (mun > 1.6) {
    sound(self, CHAN_VOICE, "gaunt/g12.wav", 1, ATTN_NORM);
    exit;
    }
  if (mun > 1.5) {
    sound(self, CHAN_VOICE, "gaunt/g11.wav", 1, ATTN_NORM);
    exit;
    }
  if (mun > 1.4) {
    sound(self, CHAN_VOICE, "gaunt/g10.wav", 1, ATTN_NORM);
    exit;
    }
  if (mun > 1.3) {
    sound(self, CHAN_VOICE, "gaunt/g9.wav", 1, ATTN_NORM);
    exit;
    }
  if (mun > 1.2) {
    sound(self, CHAN_VOICE, "gaunt/g8.wav", 1, ATTN_NORM);
    exit;
    }
  if (mun > 1.1) {
    sound(self, CHAN_VOICE, "gaunt/g7.wav", 1, ATTN_NORM);
    exit;
    }
  if (mun > 1) {
    sound(self, CHAN_VOICE, "gaunt/g6.wav", 1, ATTN_NORM);
    exit;
    }
  if (mun > 0.7) {
    sound(self, CHAN_VOICE, "gaunt/g4.wav", 1, ATTN_NORM);
    exit;
    }
  if (mun > 0.6) {
    sound(self, CHAN_VOICE, "gaunt/g3.wav", 1, ATTN_NORM);
    exit;
    }
  if (mun > 0.4) {
    sound(self, CHAN_VOICE, "gaunt/g2.wav", 1, ATTN_NORM);
    exit;
    }
  sound(self, CHAN_VOICE, "gaunt/g1.wav", 1, ATTN_NORM);
}

Void function gaunt_yell();
var
 num : Real;
 mun : Real;
{
  num = random();
  mun = num + random();
  if (mun > 1.8) {
    sound(self, CHAN_VOICE, "gaunt/ga5.wav", 1, ATTN_NORM);
    exit;
    }
  if (mun > 1.5) {
    sound(self, CHAN_VOICE, "gaunt/ga8.wav", 1, ATTN_NORM);
    exit;
    }
  if (mun > 1.3) {
    sound(self, CHAN_VOICE, "gaunt/ga7.wav", 1, ATTN_NORM);
    exit;
    }
  if (mun > 1.0) {
    sound(self, CHAN_VOICE, "gaunt/ga6.wav", 1, ATTN_NORM);
    exit;
    }
  if (mun > 0.8) {
    sound(self, CHAN_VOICE, "gaunt/ga4.wav", 1, ATTN_NORM);
    exit;
    }
  if (mun > 0.5) {
    sound(self, CHAN_VOICE, "gaunt/ga3.wav", 1, ATTN_NORM);
    exit;
    }
  if (mun > 0.2) {
    sound(self, CHAN_VOICE, "gaunt/ga2.wav", 1, ATTN_NORM);
    exit;
    }
  sound(self, CHAN_VOICE, "gaunt/ga1.wav", 1, ATTN_NORM);
}

Real function gaunt_checkenemy();
var
 head : Object;
{
  if (self.enemy.classname == "monster_gaunt") {
    return 1;
    }
  else {
    head = find(world, classname, "monster_gaunt");
    while (head) {
      if (head.enemy == world || head.enemy.classname == self.classname) {
        head.enemy = self.enemy;
        }
      head = find(head, classname, "monster_gaunt");
      }
    return 0;
    }
}

Void function gaunt_arg_control();
var
 num : Real;
{
  if (borkfactor1()) {
    exit;
    }
  ai_checkflee();
  if (self.enemy.health < 1) {
    self.walkframe = 0;
    self.enemy = world;
    self.goalentity = world;
    self.objekt = world;
    #0 gaunt_stand;
    exit;
    }
  if (random() < 0.3) {
    if (self.enemy.classname != self.classname) {
      if (ai_threats()) {
        self.walkframe = 0;
        gaunt_retreat();
        exit;
        }
      }
    }
  if (gaunt_checkenemy()) {
    if (gaunt_measure()) {
      #12 gaunt_motion;
      exit;
      }
    num = random();
    if (num < 0.1) {
      #22 gaunt_shimmy;
      exit;
      }
    if (num < 0.4) {
      #32 gaunt_shakefists;
      exit;
      }
    if (num < 0.9) {
      #11 gaunt_stand;
      exit;
      }
    #66 gaunt_wardoff;
    exit;
    }
  if (random() < 0.2) {
    #105 gaunt_shoot;
    exit;
    }
  if (random() > 0.5) {
    #32 gaunt_shakefists;
    }
  else {
    #126 gaunt_swing2;
    }
}

Real function gaunt_measure();
var
 g : Object;
 dave : Vector;
{
  g = self.goalentity;
  dave = g.origin - self.origin;
  if (vlen(dave) < 200) {
    return 0;
    }
  else {
    return 1;
    }
}

Void function gaunt_select_kin();
var
 head : Object;
 selected : Object;
 dist : Real;
{
  dist = 300;
  selected = world;
  head = findradius(self.origin, 300);
  while (head) {
    if (trace_plane_dist < dist) {
      if (visible(head) && head.health > 0 && head != self) {
        if (head.classname == self.classname) {
          if (!(head.flags & FL_COMMAND)) {
            selected = head;
            dist = trace_plane_dist;
            }
          }
        }
      }
    head = head.chain;
    }
  if (selected == world) {
    return 0;
    }
  else {
    self.enemy = selected;
    self.enemy.enemy = self;
    FoundTarget();
    return 1;
    }
}

Void function gaunt_quirk();
var
 head : Object;
 selected : Object;
 dist : Real;
{
  dist = 800;
  selected = world;
  head = findradius(self.origin, 800);
  while (head) {
    if (trace_plane_dist < dist) {
      if (head != self && head.classname != self.classname) {
        if (random() < 0.2) {
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
    self.enemy = selected;
    return 1;
    }
}

Void function GauntMissile();
var
 missile : Object;
 dir : Vector;
 dist : Real;
 flytime : Real;
{
  dir = normalize(self.enemy.origin + [0 0 10] - self.origin);
  dist = vlen(self.enemy.origin - self.origin);
  flytime = dist * 0.002000;
  if (flytime < 0.1) {
    flytime = 0.1;
    }
  self.effects = self.effects | EF_MUZZLEFLASH;
  sound(self, CHAN_WEAPON, "gaunt/gspike.wav", 1, ATTN_NORM);
  missile = spawn();
  missile.owner = self;
  missile.solid = SOLID_BBOX;
  missile.movetype = MOVETYPE_FLYMISSILE;
  setmodel(missile, "progs/gntspke.mdl");
  setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
  missile.effects = EF_RED;
  missile.origin = self.origin + [0 0 6];
  missile.velocity = dir * 500;
  missile.avelocity = [666 666 666];
  missile.nextthink = flytime + time;
  missile.think = Gntspke_Home;
  missile.enemy = self.enemy;
  missile.touch = GntSpke_Touch;
}

Void function Gntspke_Home();
var
 dir : Vector;
 vtemp : Vector;
{
  vtemp = self.enemy.origin + [0 0 10];
  if (self.enemy.health < 1) {
    remove(self);
    exit;
    }
  dir = normalize(vtemp - self.origin);
  if (self.classname == "archmissile") {
    self.velocity = dir * 90;
    }
  else {
    self.velocity = dir * 150;
    }
  self.nextthink = time + 0.2;
  self.think = Gntspke_Home;
}

Void function GntSpke_Touch();
{
  if (other.classname == "monster_gaunt") {
    exit;
    }
  sound(self, CHAN_WEAPON, "gaunt/spkhit.wav", 1, ATTN_NORM);
  self.dmg = rint(30 * random());
  T_Damage(other, self, self.owner, self.dmg);
  remove(self);
}

Void function Gaunt_Teleport();
var
 head : Object;
 selected : Object;
{
  head = find(world, event, "spawn_point");
  while (head) {
    if (pointcontents(head.origin) == CONTENT_EMPTY) {
      selected = head;
      }
    head = find(head, event, "spawn_point");
    }
  if (selected == world) {
    return 0;
    }
  spawn_tfog(self.origin);
  spawn_gmonitor(selected);
  spawn_tdeath(selected.origin, self);
  self.flags = self.flags - (self.flags & FL_ONGROUND);
  self.origin = selected.origin + [0 0 25];
  T_Heal(self, 20, 1);
  spawn_tfog(selected.origin);
  if (self.flags & FL_FLEE) {
    self.flags = self.flags - FL_FLEE;
    }
  return 1;
}

Void function spawn_gmonitor(mark : Object);
var
 head : Object;
{
  head = spawn();
  head.origin = self.origin;
  head.owner = self;
  head.objekt = mark;
  mark.event = "monitored";
  head.think = gmonitor;
  head.nextthink = time + 3;
}

Void function gmonitor();
var
  megadeth : Vector;
{
  megadeth = self.owner.origin - self.objekt.origin;  
  if (vlen(megadeth) > 600 || self.owner.health < 1) {
    self.objekt.event = "spawn_point";
    remove(self);
    }
  self.think = gmonitor;
  self.nextthink = time + 0.4;
}

Void function player_stand1();
{
  #17 player_stand1;
  self.weaponframe = 0;
  if (self.velocity_x || self.velocity_y) {
    self.walkframe = 0;
    player_run();
    exit;
    }
  if (self.weapon == IT_SWORD) {
    if (self.walkframe >= 12) {
      self.walkframe = 0;
      }
    self.frame = 17 + self.walkframe;
    }
  else {
    if (self.walkframe >= MOVETYPE_FLY) {
      self.walkframe = 0;
      }
    self.frame = 12 + self.walkframe;
    }
  self.walkframe = self.walkframe + 1;
}

Void function player_run();
{
  #6 player_run;
  self.weaponframe = 0;
  if (!(self.velocity_x) && !(self.velocity_y)) {
    self.walkframe = 0;
    player_stand1();
    exit;
    }
  if (self.weapon == IT_SWORD) {
    if (self.walkframe == MOVETYPE_TOSS) {
      self.walkframe = 0;
      }
    self.frame = 0 + self.walkframe;
    }
  else {
    if (self.walkframe == MOVETYPE_TOSS) {
      self.walkframe = 0;
      }
    self.frame = self.frame + self.walkframe;
    }
  self.walkframe = self.walkframe + 1;
}

Void function player_shot1();
{
  if (self.angles_x > 12) {
    player3_shotup1();
    exit;
    }
  if (self.angles_x < -12) {
    player2_shotdown1();
    exit;
    }
  #113 player_shot2;
  self.weaponframe = 1;
  self.effects = self.effects | EF_MUZZLEFLASH;
}

Void function player_shot2();
{
  #114 player_shot3;
  self.weaponframe = FL_SWIM;
}

Void function player_shot3();
{
  #115 player_shot4;
  self.weaponframe = MOVETYPE_WALK;
}

Void function player_shot4();
{
  #116 player_shot5;
  self.weaponframe = MOVETYPE_STEP;
}

Void function player_shot5();
{
  #117 player_shot6;
  self.weaponframe = MOVETYPE_FLY;
}

Void function player_shot6();
{
  #118 player_run;
  self.weaponframe = MOVETYPE_TOSS;
}

Void function player_axe1();
{
  #119 player_axe2;
  self.weaponframe = 1;
}

Void function player_axe2();
{
  #120 player_axe3;
  self.weaponframe = 2;
}

Void function player_axe3();
{
  #121 player_axe4;
  self.weaponframe = 3;
  W_FireAxe();
}

Void function player_axe4();
{
  #122 player_run;
  self.weaponframe = 4;
}

Void function player_axeb1();
{
  #123 player_axeb2;
  self.weaponframe = 5;
}

Void function player_axeb2();
{
  #124 player_axeb3;
  self.weaponframe = 6;
}

Void function player_axeb3();
{
  #125 player_axeb4;
  self.weaponframe = 7;
  W_FireAxe();
}

Void function player_axeb4();
{
  #126 player_run;
  self.weaponframe = 8;
}

Void function player_axec1();
{
  #127 player_axec2;
  self.weaponframe = 9;
}

Void function player_axec2();
{
  #128 player_axec3;
  self.weaponframe = 10;
}

Void function player_axec3();
{
  #129 player_axec4;
  self.weaponframe = 11;
  W_FireAxe();
}

Void function player_axec4();
{
  #130 player_run;
  self.weaponframe = 12;
}

Void function player_axed1();
{
  #131 player_axed2;
  self.weaponframe = 13;
}

Void function player_axed2();
{
  #132 player_axed3;
  self.weaponframe = 14;
}

Void function player_axed3();
{
  #133 player_axed4;
  self.weaponframe = 15;
  W_FireAxe();
}

Void function player_axed4();
{
  #134 player_run;
  self.weaponframe = 16;
}

Void function player_nail1();
{
  if (self.angles_x > 12) {
    player3_nail1();
    exit;
    }
  if (self.angles_x < -12) {
    player2_nail1();
    exit;
    }
  #103 player_nail2;
  self.effects = self.effects | EF_MUZZLEFLASH;
  if (!(self.button0)) {
    player_run();
    exit;
    }
  self.weaponframe = self.weaponframe + 1;
  if (self.weaponframe == MOVETYPE_FLYMISSILE) {
    self.weaponframe = 1;
    }
  SuperDamageSound();
  W_FireSpikes(MOVETYPE_STEP);
  self.attack_finished = time + 0.2;
}

Void function player_nail2();
{
  #104 player_nail1;
  self.effects = self.effects | EF_MUZZLEFLASH;
  if (!(self.button0)) {
    player_run();
    exit;
    }
  self.weaponframe = self.weaponframe + 1;
  if (self.weaponframe == MOVETYPE_FLYMISSILE) {
    self.weaponframe = 1;
    }
  SuperDamageSound();
  W_FireSpikes(CONTENT_SLIME);
  self.attack_finished = time + 0.2;
}

Void function player_autos1();
{
  if (self.angles_x > 12) {
    player3_autos1();
    exit;
    }
  if (self.angles_x < -12) {
    player2_autos1();
    exit;
    }
  #103 player_autos2;
  self.effects = self.effects | EF_MUZZLEFLASH;
  if ((!(self.button0)) || self.ammo_shells < 1) {
    player_run();
    exit;
    }
  self.weaponframe = self.weaponframe + 1;
  if (self.weaponframe == 18) {
    self.weaponframe = 0;
    }
  SuperDamageSound();
  W_FireAutoShotgun();
  self.attack_finished = time + 0.2;
}

Void function player_autos2();
{
  #104 player_autos1;
  self.effects = self.effects | EF_MUZZLEFLASH;
  if ((!(self.button0)) || self.ammo_shells < 1) {
    player_run();
    exit;
    }
  self.weaponframe = self.weaponframe + 1;
  if (self.weaponframe == 18) {
    self.weaponframe = 0;
    }
  SuperDamageSound();
  W_FireAutoShotgun();
  self.attack_finished = time + 0.2;
}

Void function player_light1();
{
  if (self.angles_x > 12) {
    player3_light1();
    exit;
    }
  if (self.angles_x < -12) {
    player2_light1();
    exit;
    }
  #105 player_light2;
  self.effects = self.effects | EF_MUZZLEFLASH;
  if ((!(self.button0)) || self.ammo_cells < 1) {
    player_run();
    exit;
    }
  self.weaponframe = self.weaponframe + 1;
  if (self.weaponframe == MOVETYPE_FLY) {
    self.weaponframe = 1;
    }
  SuperDamageSound();
  W_FireLightning();
  self.attack_finished = time + 0.2;
}

Void function player_light2();
{
  #106 player_light1;
  self.effects = self.effects | EF_MUZZLEFLASH;
  if ((!(self.button0)) || self.ammo_cells < 1) {
    player_run();
    exit;
    }
  self.weaponframe = self.weaponframe + 1;
  if (self.weaponframe == MOVETYPE_FLY) {
    self.weaponframe = 1;
    }
  SuperDamageSound();
  W_FireLightning();
  self.attack_finished = time + 0.2;
}

Void function player_rocket1();
{
  if (self.angles_x > 12) {
    player3_rocket1();
    exit;
    }
  if (self.angles_x < -12) {
    player2_rocket1();
    exit;
    }
  #107 player_rocket2;
  self.weaponframe = 1;
  self.effects = self.effects | EF_MUZZLEFLASH;
}

Void function player_rocket2();
{
  #108 player_rocket3;
  self.weaponframe = FL_SWIM;
}

Void function player_rocket3();
{
  #109 player_rocket4;
  self.weaponframe = MOVETYPE_WALK;
}

Void function player_rocket4();
{
  #110 player_rocket5;
  self.weaponframe = MOVETYPE_STEP;
}

Void function player_rocket5();
{
  #111 player_rocket6;
  self.weaponframe = MOVETYPE_FLY;
}

Void function player_rocket6();
{
  #112 player_run;
  self.weaponframe = MOVETYPE_TOSS;
}

Void function PainSound();
var
 rs : Real;
{
  if (self.health < 0) {
    exit;
    }
  if (damage_attacker.classname == "teledeath") {
    sound(self, CHAN_VOICE, "player/teledth1.wav", 1, ATTN_NONE);
    exit;
    }
  if (self.watertype == CONTENT_WATER && self.waterlevel == MOVETYPE_WALK) {
    DeathBubbles(1);
    if (random() > 0.5) {
      sound(self, CHAN_VOICE, "player/drown1.wav", 1, ATTN_NORM);
      }
    else {
      sound(self, CHAN_VOICE, "player/drown2.wav", 1, ATTN_NORM);
      }
    exit;
    }
  if (self.watertype == CONTENT_SLIME) {
    if (random() > 0.5) {
      sound(self, CHAN_VOICE, "player/lburn1.wav", 1, ATTN_NORM);
      }
    else {
      sound(self, CHAN_VOICE, "player/lburn2.wav", 1, ATTN_NORM);
      }
    exit;
    }
  if (self.watertype == CONTENT_LAVA) {
    if (random() > 0.5) {
      sound(self, CHAN_VOICE, "player/lburn1.wav", 1, ATTN_NORM);
      }
    else {
      sound(self, CHAN_VOICE, "player/lburn2.wav", 1, ATTN_NORM);
      }
    exit;
    }
  if (self.burn_burning) {
    BurnPainSound();
    exit;
    }
  if (self.pain_finished > time) {
    self.axhitme = 0;
    exit;
    }
  self.pain_finished = time + 0.5;
  if (self.axhitme == 1) {
    self.axhitme = 0;
    sound(self, CHAN_VOICE, "player/axhit1.wav", 1, ATTN_NORM);
    exit;
    }
  rs = rint(random() * MOVETYPE_FLY + 1);
  self.noise = "";
  if (rs == 1) {
    self.noise = "player/pain1.wav";
    }
  else {
    if (rs == FL_SWIM) {
      self.noise = "player/pain2.wav";
      }
    else {
      if (rs == MOVETYPE_WALK) {
        self.noise = "player/pain3.wav";
        }
      else {
        if (rs == MOVETYPE_STEP) {
          self.noise = "player/pain4.wav";
          }
        else {
          if (rs == MOVETYPE_FLY) {
            self.noise = "player/pain5.wav";
            }
          else {
            self.noise = "player/pain6.wav";
            }
          }
        }
      }
    }
  sound(self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
  exit;
}

Void function player_pain1();
{
  #35 player_pain2;
  PainSound();
  self.weaponframe = 0;
}

Void function player_pain2();
{
  #36 player_pain3;
}

Void function player_pain3();
{
  #37 player_pain4;
}

Void function player_pain4();
{
  #38 player_pain5;
}

Void function player_pain5();
{
  #39 player_pain6;
}

Void function player_pain6();
{
  #40 player_run;
}

Void function player_axpain1();
{
  #29 player_axpain2;
  PainSound();
  self.weaponframe = 0;
}

Void function player_axpain2();
{
  #30 player_axpain3;
}

Void function player_axpain3();
{
  #31 player_axpain4;
}

Void function player_axpain4();
{
  #32 player_axpain5;
}

Void function player_axpain5();
{
  #33 player_axpain6;
}

Void function player_axpain6();
{
  #34 player_run;
}

Void function player_pain();
{
  if (self.weaponframe) {
    exit;
    }
  if (self.invisible_finished > time) {
    exit;
    }
  if (self.weapon == IT_SWORD) {
    player_axpain1();
    }
  else {
    player_pain1();
    }
}

Void function DeathBubblesSpawn();
var
 bubble : Object;
{
  if (self.owner.waterlevel != MOVETYPE_WALK) {
    exit;
    }
  bubble = spawn();
  setmodel(bubble, "progs/s_bubble.spr");
  setorigin(bubble, self.owner.origin + [0 0 24]);
  bubble.movetype = MOVETYPE_NOCLIP;
  bubble.solid = SOLID_NOT;
  bubble.velocity = [0 0 15];
  bubble.nextthink = time + 0.5;
  bubble.think = bubble_bob;
  bubble.classname = "bubble";
  bubble.frame = 0;
  bubble.cnt = 0;
  setsize(bubble, [-8 -8 -8], [8 8 8]);
  self.nextthink = time + 0.1;
  self.think = DeathBubblesSpawn;
  self.air_finished = self.air_finished + 1;
  if (self.air_finished >= self.bubble_count) {
    remove(self);
    }
}

Void function DeathBubbles(num_bubbles : Real);
var
 bubble_spawner : Object;
{
  bubble_spawner = spawn();
  setorigin(bubble_spawner, self.origin);
  bubble_spawner.movetype = MOVETYPE_NONE;
  bubble_spawner.solid = SOLID_NOT;
  bubble_spawner.nextthink = time + 0.1;
  bubble_spawner.think = DeathBubblesSpawn;
  bubble_spawner.air_finished = 0;
  bubble_spawner.owner = self;
  bubble_spawner.bubble_count = num_bubbles;
  exit;
}

Void function DeathSound();
var
 rs : Real;
{
  if (self.waterlevel == MOVETYPE_WALK) {
    DeathBubbles(20);
    sound(self, CHAN_VOICE, "player/h2odeath.wav", 1, ATTN_NONE);
    exit;
    }
  rs = rint(random() * MOVETYPE_STEP + 1);
  if (rs == 1) {
    self.noise = "player/death1.wav";
    }
  if (rs == FL_SWIM) {
    self.noise = "player/death2.wav";
    }
  if (rs == MOVETYPE_WALK) {
    self.noise = "player/death3.wav";
    }
  if (rs == MOVETYPE_STEP) {
    self.noise = "player/death4.wav";
    }
  if (rs == MOVETYPE_FLY) {
    self.noise = "player/death5.wav";
    }
  sound(self, CHAN_VOICE, self.noise, 1, ATTN_NONE);
  exit;
}

Void function PlayerDead();
{
  self.nextthink = CONTENT_EMPTY;
  self.deadflag = DEAD_DEAD;
}

Vector function VelocityForDamage(dm : Real);
var
 v : Vector;
{
  v_x = 100 * crandom();
  v_y = 100 * crandom();
  v_z = 200 + 100 * random();
  if (dm > -50) {
    v = v * 0.7;
    }
  else {
    if (dm > -200) {
      v = v * FL_SWIM;
      }
    else {
      v = v * MOVETYPE_BOUNCE;
      }
    }
  return v_x;
}

Void function ThrowGib(gibname : String; dm : Real);
var
 new : Object;
{
  new = spawn();
  new.origin = self.origin;
  setmodel(new, gibname);
  setsize(new, VEC_ORIGIN, VEC_ORIGIN);
  new.velocity = VelocityForDamage(dm);
  new.movetype = MOVETYPE_BOUNCE;
  new.solid = SOLID_NOT;
  new.avelocity_x = random() * 600;
  new.avelocity_y = random() * 600;
  new.avelocity_z = random() * 600;
  new.think = SUB_Remove;
  new.ltime = time;
  new.nextthink = time + MOVETYPE_BOUNCE + random() * MOVETYPE_BOUNCE;
  new.frame = 0;
  new.flags = 0;
}

Void function ThrowHead(gibname : String; dm : Real);
{
  self.skin = 0;
  self.th_stand = Sub_Null;
  self.th_walk = Sub_Null;
  self.th_run = Sub_Null;
  self.th_pain = Sub_Null;
  self.th_die = Sub_Null;
  self.th_missile = Sub_Null;
  self.th_melee = Sub_Null;
  self.th_runfire = Sub_Null;
  self.use = Sub_Null;
  setmodel(self, gibname);
  self.frame = 0;
  self.nextthink = time + 30;
  self.think = corpse_think;
  self.movetype = MOVETYPE_BOUNCE;
  self.takedamage = DAMAGE_NO;
  self.solid = SOLID_NOT;
  self.view_ofs = [0 0 8];
  setsize(self, [-16 -16 0], [16 16 56]);
  self.velocity = VelocityForDamage(dm);
  self.origin_z = self.origin_z - 24;
  self.flags = self.flags - (self.flags & FL_ONGROUND);
  self.avelocity = crandom() * [0 600 0];
}

Void function GibPlayer();
{
  erase_deadstate();
  kill_deathspirits();
  self.lives = 0;
  msg_entity = self;
  WriteByte(MSG_ONE, SVC_SHOWLMP);
  WriteString(MSG_ONE, "deadstate");
  WriteString(MSG_ONE, "gfx/it/res2.lmp");
  WriteByte(MSG_ONE, 10);
  WriteByte(MSG_ONE, 10);
  ThrowHead("progs/h_player.mdl", self.health);
  ThrowGib("progs/gib1.mdl", self.health);
  ThrowGib("progs/gib2.mdl", self.health);
  ThrowGib("progs/gib3.mdl", self.health);
  self.deadflag = DEAD_DEAD;
  if (damage_attacker.classname == "teledeath") {
    sound(self, CHAN_VOICE, "player/teledth1.wav", 1, ATTN_NONE);
    exit;
    }
  if (damage_attacker.classname == "teledeath2") {
    sound(self, CHAN_VOICE, "player/teledth1.wav", 1, ATTN_NONE);
    exit;
    }
  if (random() < 0.5) {
    sound(self, CHAN_VOICE, "player/gib.wav", 1, ATTN_NONE);
    }
  else {
    sound(self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NONE);
    }
}

Void function PlayerDie();
var
 i : Real;
{
  if (self.lives == 1) {
    self.lives = 0;
    msg_entity = self;
    WriteByte(MSG_ONE, SVC_SHOWLMP);
    WriteString(MSG_ONE, "deadstate");
    WriteString(MSG_ONE, "gfx/it/res3.lmp");
    WriteByte(MSG_ONE, 10);
    WriteByte(MSG_ONE, 10);
    }
  else {
    msg_entity = self;
    WriteByte(MSG_ONE, SVC_SHOWLMP);
    WriteString(MSG_ONE, "deadstate");
    WriteString(MSG_ONE, "gfx/it/res1.lmp");
    WriteByte(MSG_ONE, 10);
    WriteByte(MSG_ONE, 10);
    }
  kill_deathspirits();
  self.dlmp = 1;
  spawn_deathspirits();
  self.items = self.items - (self.items & IT_INVISIBILITY);
  self.invisible_finished = 0;
  self.invincible_finished = 0;
  self.super_damage_finished = 0;
  self.radsuit_finished = 0;
  self.attack_finished = time + 1;
  self.modelindex = self.modelindex_player;
  if (deathmatch || coop) {
    if (self.health > -41 && self.lives == 0) {
      DropBackpack();
      }
    }
  self.weaponmodel = "";
  self.view_ofs = [0 0 -8];
  self.deadflag = DEAD_DYING;
  if (self.lives < 1) {
    self.solid = SOLID_NOT;
    }
  self.flags = self.flags - (self.flags & FL_ONGROUND);
  self.movetype = MOVETYPE_TOSS;
  if (self.velocity_z < MOVETYPE_BOUNCE) {
    self.velocity_z = self.velocity_z + random() * 300;
    }
  if (self.health < -40) {
    GibPlayer();
    DropBackpack();
    exit;
    }
  DeathSound();
  self.angles_x = 0;
  self.angles_z = 0;
  if (self.burn_burning) {
    player_dieb1();
    exit;
    }
  if (self.weapon == IT_SWORD) {
    player_die_ax1();
    exit;
    }
  i = cvar("temp1");
  if (!i) {
    i = 1 + floor(random() * MOVETYPE_TOSS);
    }
  if (i == 1) {
    player_diea1();
    }
  else {
    if (i == FL_SWIM) {
      player_dieb1();
      }
    else {
      if (i == MOVETYPE_WALK) {
        player_diec1();
        }
      else {
        if (i == MOVETYPE_STEP) {
          player_died1();
          }
        else {
          player_diee1();
          }
        }
      }
    }
}

Void function set_suicide_frame();
{
  if (self.model == "progs/vplayer2.mdl") {
    exit;
    }
  self.frame = 60;
  self.solid = SOLID_NOT;
  self.movetype = MOVETYPE_TOSS;
  self.deadflag = DEAD_DEAD;
  self.nextthink = CONTENT_EMPTY;
}

Void function player_diea1();
{
  #50 player_diea2;
}

Void function player_diea2();
{
  #51 player_diea3;
}

Void function player_diea3();
{
  #52 player_diea4;
}

Void function player_diea4();
{
  #53 player_diea5;
}

Void function player_diea5();
{
  #54 player_diea6;
}

Void function player_diea6();
{
  #55 player_diea7;
}

Void function player_diea7();
{
  #56 player_diea8;
}

Void function player_diea8();
{
  #57 player_diea9;
}

Void function player_diea9();
{
  #58 player_diea10;
}

Void function player_diea10();
{
  #59 player_diea11;
}

Void function player_diea11();
{
  self.angles_x = 0;
  self.angles_z = 0;
  #60 player_diea11;
  if (self.classname == "player") {
    PlayerDead();
    }
}

Void function player_dieb1();
{
  #61 player_dieb2;
}

Void function player_dieb2();
{
  #62 player_dieb3;
}

Void function player_dieb3();
{
  #63 player_dieb4;
}

Void function player_dieb4();
{
  #64 player_dieb5;
}

Void function player_dieb5();
{
  #65 player_dieb6;
}

Void function player_dieb6();
{
  #66 player_dieb7;
}

Void function player_dieb7();
{
  #67 player_dieb8;
}

Void function player_dieb8();
{
  #68 player_dieb9;
}

Void function player_dieb9();
{
  self.angles_x = 0;
  self.angles_z = 0;
  #69 player_dieb9;
  if (self.classname == "player") {
    PlayerDead();
    }
}

Void function player_diec1();
{
  #70 player_diec2;
}

Void function player_diec2();
{
  #71 player_diec3;
}

Void function player_diec3();
{
  #72 player_diec4;
}

Void function player_diec4();
{
  #73 player_diec5;
}

Void function player_diec5();
{
  #74 player_diec6;
}

Void function player_diec6();
{
  #75 player_diec7;
}

Void function player_diec7();
{
  #76 player_diec8;
}

Void function player_diec8();
{
  #77 player_diec9;
}

Void function player_diec9();
{
  #78 player_diec10;
}

Void function player_diec10();
{
  #79 player_diec11;
}

Void function player_diec11();
{
  #80 player_diec12;
}

Void function player_diec12();
{
  #81 player_diec13;
}

Void function player_diec13();
{
  #82 player_diec14;
}

Void function player_diec14();
{
  #83 player_diec15;
}

Void function player_diec15();
{
  self.angles_x = 0;
  self.angles_z = 0;
  #84 player_diec15;
  if (self.classname == "player") {
    PlayerDead();
    }
}

Void function player_died1();
{
  #85 player_died2;
}

Void function player_died2();
{
  #86 player_died3;
}

Void function player_died3();
{
  #87 player_died4;
}

Void function player_died4();
{
  #88 player_died5;
}

Void function player_died5();
{
  #89 player_died6;
}

Void function player_died6();
{
  #90 player_died7;
}

Void function player_died7();
{
  #91 player_died8;
}

Void function player_died8();
{
  #92 player_died9;
}

Void function player_died9();
{
  self.angles_x = 0;
  self.angles_z = 0;
  #93 player_died9;
  if (self.classname == "player") {
    PlayerDead();
    }
}

Void function player_diee1();
{
  #94 player_diee2;
}

Void function player_diee2();
{
  #95 player_diee3;
}

Void function player_diee3();
{
  #96 player_diee4;
}

Void function player_diee4();
{
  #97 player_diee5;
}

Void function player_diee5();
{
  #98 player_diee6;
}

Void function player_diee6();
{
  #99 player_diee7;
}

Void function player_diee7();
{
  #100 player_diee8;
}

Void function player_diee8();
{
  #101 player_diee9;
}

Void function player_diee9();
{
  self.angles_x = 0;
  self.angles_z = 0;
  #102 player_diee9;
  if (self.classname == "player") {
    PlayerDead();
    }
}

Void function player_die_ax1();
{
  #41 player_die_ax2;
}

Void function player_die_ax2();
{
  #42 player_die_ax3;
}

Void function player_die_ax3();
{
  #43 player_die_ax4;
}

Void function player_die_ax4();
{
  #44 player_die_ax5;
}

Void function player_die_ax5();
{
  #45 player_die_ax6;
}

Void function player_die_ax6();
{
  #46 player_die_ax7;
}

Void function player_die_ax7();
{
  #47 player_die_ax8;
}

Void function player_die_ax8();
{
  #48 player_die_ax9;
}

Void function player_die_ax9();
{
  #49 player_die_ax9;
  PlayerDead();
}

Void function player2_shotdown1();
{
  #146 player2_shotdown2;
  self.weaponframe = 1;
  self.effects = self.effects | EF_MUZZLEFLASH;
}

Void function player2_shotdown2();
{
  #147 player2_shotdown3;
  self.weaponframe = FL_SWIM;
}

Void function player2_shotdown3();
{
  #148 player2_shotdown4;
  self.weaponframe = MOVETYPE_WALK;
}

Void function player2_shotdown4();
{
  #149 player2_shotdown5;
  self.weaponframe = MOVETYPE_STEP;
}

Void function player2_shotdown5();
{
  #150 player2_shotdown6;
  self.weaponframe = MOVETYPE_FLY;
}

Void function player2_shotdown6();
{
  #151 player_run;
  self.weaponframe = MOVETYPE_TOSS;
}

Void function player2_nail1();
{
  if (self.angles_x > -5) {
    player_nail1();
    exit;
    }
  #135 player2_nail2;
  self.effects = self.effects | EF_MUZZLEFLASH;
  if (!(self.button0)) {
    player_run();
    exit;
    }
  self.weaponframe = self.weaponframe + 1;
  if (self.weaponframe == MOVETYPE_FLYMISSILE) {
    self.weaponframe = 1;
    }
  SuperDamageSound();
  W_FireSpikes(MOVETYPE_STEP);
  self.attack_finished = time + 0.2;
}

Void function player2_nail2();
{
  #136 player2_nail1;
  self.effects = self.effects | EF_MUZZLEFLASH;
  if (!(self.button0)) {
    player_run();
    exit;
    }
  self.weaponframe = self.weaponframe + 1;
  if (self.weaponframe == MOVETYPE_FLYMISSILE) {
    self.weaponframe = 1;
    }
  SuperDamageSound();
  W_FireSpikes(CONTENT_SLIME);
  self.attack_finished = time + 0.2;
}

Void function player2_autos1();
{
  if (self.angles_x > -5) {
    player_autos1();
    exit;
    }
  #135 player2_autos2;
  self.effects = self.effects | EF_MUZZLEFLASH;
  if ((!(self.button0)) || self.ammo_shells < 1) {
    player_run();
    exit;
    }
  self.weaponframe = self.weaponframe + 1;
  if (self.weaponframe == 17) {
    self.weaponframe = 1;
    }
  SuperDamageSound();
  W_FireAutoShotgun();
  self.attack_finished = time + 0.2;
}

Void function player2_autos2();
{
  #136 player2_autos1;
  self.effects = self.effects | EF_MUZZLEFLASH;
  if ((!(self.button0)) || self.ammo_shells < 1) {
    player_run();
    exit;
    }
  self.weaponframe = self.weaponframe + 1;
  if (self.weaponframe == 17) {
    self.weaponframe = 1;
    }
  SuperDamageSound();
  W_FireAutoShotgun();
  self.attack_finished = time + 0.2;
}

Void function player2_light1();
{
  if (self.angles_x > -5) {
    player_light1();
    exit;
    }
  #137 player2_light2;
  self.effects = self.effects | EF_MUZZLEFLASH;
  if ((!(self.button0)) || self.ammo_cells < 1) {
    player_run();
    exit;
    }
  self.weaponframe = self.weaponframe + 1;
  if (self.weaponframe == MOVETYPE_FLY) {
    self.weaponframe = 1;
    }
  SuperDamageSound();
  W_FireLightning();
  self.attack_finished = time + 0.2;
}

Void function player2_light2();
{
  #138 player2_light1;
  self.effects = self.effects | EF_MUZZLEFLASH;
  if ((!(self.button0)) || self.ammo_cells < 1) {
    player_run();
    exit;
    }
  self.weaponframe = self.weaponframe + 1;
  if (self.weaponframe == MOVETYPE_FLY) {
    self.weaponframe = 1;
    }
  SuperDamageSound();
  W_FireLightning();
  self.attack_finished = time + 0.2;
}

Void function player2_rocket1();
{
  #139 player2_rocket2;
  self.weaponframe = 1;
  self.effects = self.effects | EF_MUZZLEFLASH;
}

Void function player2_rocket2();
{
  #140 player2_rocket3;
  self.weaponframe = FL_SWIM;
}

Void function player2_rocket3();
{
  #141 player2_rocket4;
  self.weaponframe = MOVETYPE_WALK;
}

Void function player2_rocket4();
{
  #142 player2_rocket5;
  self.weaponframe = MOVETYPE_STEP;
}

Void function player2_rocket5();
{
  #143 player2_rocket6;
  self.weaponframe = MOVETYPE_FLY;
}

Void function player2_rocket6();
{
  #144 player_run;
  self.weaponframe = MOVETYPE_TOSS;
}

Void function player3_shotup1();
{
  #162 player3_shotup2;
  self.weaponframe = 1;
  self.effects = self.effects | EF_MUZZLEFLASH;
}

Void function player3_shotup2();
{
  #163 player3_shotup3;
  self.weaponframe = FL_SWIM;
}

Void function player3_shotup3();
{
  #164 player3_shotup4;
  self.weaponframe = MOVETYPE_WALK;
}

Void function player3_shotup4();
{
  #165 player3_shotup5;
  self.weaponframe = MOVETYPE_STEP;
}

Void function player3_shotup5();
{
  #166 player3_shotup6;
  self.weaponframe = MOVETYPE_FLY;
}

Void function player3_shotup6();
{
  #167 player_run;
  self.weaponframe = MOVETYPE_TOSS;
}

Void function player3_nail1();
{
  if (self.angles_x < 7) {
    player_nail1();
    exit;
    }
  #152 player3_nail2;
  self.effects = self.effects | EF_MUZZLEFLASH;
  if (!(self.button0)) {
    player_run();
    exit;
    }
  self.weaponframe = self.weaponframe + 1;
  if (self.weaponframe == MOVETYPE_FLYMISSILE) {
    self.weaponframe = 1;
    }
  SuperDamageSound();
  W_FireSpikes(MOVETYPE_STEP);
  self.attack_finished = time + 0.2;
}

Void function player3_nail2();
{
  #153 player3_nail1;
  self.effects = self.effects | EF_MUZZLEFLASH;
  if (!(self.button0)) {
    player_run();
    exit;
    }
  self.weaponframe = self.weaponframe + 1;
  if (self.weaponframe == MOVETYPE_FLYMISSILE) {
    self.weaponframe = 1;
    }
  SuperDamageSound();
  W_FireSpikes(CONTENT_SLIME);
  self.attack_finished = time + 0.2;
}

Void function player3_autos1();
{
  if (self.angles_x < 7) {
    player_autos1();
    exit;
    }
  #152 player3_autos2;
  self.effects = self.effects | EF_MUZZLEFLASH;
  if ((!(self.button0)) || self.ammo_shells < 1) {
    player_run();
    exit;
    }
  self.weaponframe = self.weaponframe + 1;
  if (self.weaponframe == 17) {
    self.weaponframe = 1;
    }
  SuperDamageSound();
  W_FireAutoShotgun();
  self.attack_finished = time + 0.2;
}

Void function player3_autos2();
{
  #153 player3_autos1;
  self.effects = self.effects | EF_MUZZLEFLASH;
  if ((!(self.button0)) || self.ammo_shells < 1) {
    player_run();
    exit;
    }
  self.weaponframe = self.weaponframe + 1;
  if (self.weaponframe == 17) {
    self.weaponframe = 1;
    }
  SuperDamageSound();
  W_FireAutoShotgun();
  self.attack_finished = time + 0.2;
}

Void function player3_light1();
{
  if (self.angles_x < 7) {
    player_light1();
    exit;
    }
  #154 player3_light2;
  self.effects = self.effects | EF_MUZZLEFLASH;
  if ((!(self.button0)) || self.ammo_cells < 1) {
    player_run();
    exit;
    }
  self.weaponframe = self.weaponframe + 1;
  if (self.weaponframe == MOVETYPE_FLY) {
    self.weaponframe = 1;
    }
  SuperDamageSound();
  W_FireLightning();
  self.attack_finished = time + 0.2;
}

Void function player3_light2();
{
  #155 player3_light1;
  self.effects = self.effects | EF_MUZZLEFLASH;
  if ((!(self.button0)) || self.ammo_cells < 1) {
    player_run();
    exit;
    }
  self.weaponframe = self.weaponframe + 1;
  if (self.weaponframe == MOVETYPE_FLY) {
    self.weaponframe = 1;
    }
  SuperDamageSound();
  W_FireLightning();
  self.attack_finished = time + 0.2;
}

Void function player3_rocket1();
{
  #156 player3_rocket2;
  self.weaponframe = 1;
  self.effects = self.effects | EF_MUZZLEFLASH;
}

Void function player3_rocket2();
{
  #157 player3_rocket3;
  self.weaponframe = FL_SWIM;
}

Void function player3_rocket3();
{
  #158 player3_rocket4;
  self.weaponframe = MOVETYPE_WALK;
}

Void function player3_rocket4();
{
  #159 player3_rocket5;
  self.weaponframe = MOVETYPE_STEP;
}

Void function player3_rocket5();
{
  #160 player3_rocket6;
  self.weaponframe = MOVETYPE_FLY;
}

Void function player3_rocket6();
{
  #161 player_run;
  self.weaponframe = MOVETYPE_TOSS;
}


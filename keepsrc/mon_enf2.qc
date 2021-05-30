Void function mark3_stand1();
{
  #23 mark3_stand2;
  ai_stand();
  ai_emnity("monster_qguy", 1500, 0);
}

Void function mark3_stand2();
{
  #24 mark3_stand3;
  ai_stand();
}

Void function mark3_stand3();
{
  #25 mark3_stand4;
  ai_stand();
}

Void function mark3_stand4();
{
  #26 mark3_stand5;
  ai_stand();
  ai_emnity("monster_qguy", 1500, 0);
}

Void function mark3_stand5();
{
  #27 mark3_stand6;
  ai_stand();
}

Void function mark3_stand6();
{
  #28 mark3_stand7;
  ai_stand();
  if (random() > 0.8) {
    enf2_idlesound();
    }
}

Void function mark3_stand7();
{
  #29 mark3_stand1;
  ai_stand();
  ai_emnity("monster_qguy", 1500, 0);
}

Void function mark3_walk1();
{
  #62 mark3_walk2;
  if (random() < 0.2) {
    enf2_idlesound();
    }
  ai_walk(FL_SWIM);
}

Void function mark3_walk2();
{
  #63 mark3_walk3;
  ai_walk(MOVETYPE_STEP);
  ai_emnity("monster_qguy", 1500, 0);
}

Void function mark3_walk3();
{
  #64 mark3_walk4;
  ai_walk(MOVETYPE_STEP);
}

Void function mark3_walk4();
{
  #65 mark3_walk5;
  ai_walk(MOVETYPE_WALK);
}

Void function mark3_walk5();
{
  #66 mark3_walk6;
  ai_walk(1);
  ai_emnity("monster_qguy", 1500, 0);
}

Void function mark3_walk6();
{
  #67 mark3_walk7;
  ai_walk(FL_SWIM);
}

Void function mark3_walk7();
{
  #68 mark3_walk8;
  ai_emnity("monster_qguy", 1500, 0);
  ai_walk(FL_SWIM);
}

Void function mark3_walk8();
{
  #69 mark3_walk9;
  ai_walk(1);
}

Void function mark3_walk9();
{
  #70 mark3_walk10;
  ai_walk(FL_SWIM);
}

Void function mark3_walk10();
{
  #71 mark3_walk11;
  ai_walk(MOVETYPE_STEP);
  ai_emnity("monster_qguy", 1500, 0);
}

Void function mark3_walk11();
{
  #72 mark3_walk12;
  ai_walk(MOVETYPE_STEP);
}

Void function mark3_walk12();
{
  #73 mark3_walk13;
  ai_walk(1);
  ai_emnity("monster_qguy", 1500, 0);
}

Void function mark3_walk13();
{
  #74 mark3_walk14;
  ai_walk(FL_SWIM);
}

Void function mark3_walk14();
{
  #75 mark3_walk15;
  ai_walk(MOVETYPE_WALK);
  ai_emnity("monster_qguy", 1500, 0);
}

Void function mark3_walk15();
{
  #76 mark3_walk16;
  ai_walk(MOVETYPE_STEP);
}

Void function mark3_walk16();
{
  #77 mark3_walk1;
  ai_walk(FL_SWIM);
}

Void function mark3_run1();
{
  if (borkfactor1()) {
    exit;
    }
  #30 mark3_run2;
  if (random() < 0.2) {
    enf2_idlesound();
    }
  ai3_run(22);
}

Void function mark3_run2();
{
  #31 mark3_run3;
  ai3_run(22);
}

Void function mark3_run3();
{
  #32 mark3_run4;
  ai3_run(22);
}

Void function mark3_run4();
{
  #33 mark3_run5;
  ai3_run(22);
}

Void function mark3_run5();
{
  #34 mark3_run6;
  ai3_run(22);
}

Void function mark3_run6();
{
  #35 mark3_run1;
  ai3_run(22);
}

Void function mark3_dstand();
{
  #36 mark3_dstand2;
  ai_stand();
}

Void function mark3_dstand2();
{
  #37 mark3_dstand3;
  ai_stand();
}

Void function mark3_dstand3();
{
  #38 mark3_dstand4;
  ai_stand();
}

Void function mark3_dstand4();
{
  #39 mark3_dstand5;
  ai_stand();
}

Void function mark3_dstand5();
{
  #40 mark3_dstand6;
  ai_stand();
}

Void function mark3_dstand6();
{
  #41 mark3_dstand7;
  ai_stand();
}

Void function mark3_dstand7();
var
 yawn : Real;
{
  yawn = random();
  if (yawn < 0.5) {
    #42 mark3_dstand;
    ai_stand();
    exit;
    }
  #42 mark3_gunup;
  ai_stand();
}

Void function mark3_gunup();
{
  #43 mark3_gunup2;
  ai_stand();
}

Void function mark3_gunup2();
{
  #44 mark3_gunup3;
  ai_stand();
}

Void function mark3_gunup3();
{
  #45 mark3_gunup4;
  ai_stand();
}

Void function mark3_gunup4();
{
  #46 mark3_gunup5;
  ai_stand();
}

Void function mark3_gunup5();
{
  #47 mark3_stand1;
  self.th_stand = mark3_stand1;
  ai_stand();
}

Void function mark3_shoot();
{
  if (self.origin_z >= self.enemy.origin_z && random() < 0.3) {
    mark3_lowshot();
    }
  else {
    mark3_atk1();
    }
}

Void function mark3_atk1();
{
  if (borkfactor1()) {
    exit;
    }
  if (visible(self.enemy)) {
    #48 mark3_atk2;
    ai_face();
    exit;
    }
  #48 mark3_walk1;
}

Void function mark3_atk2();
{
  #49 mark3_atk3;
  ai_face();
  self.th_stand = mark3_stand1;
}

Void function mark3_atk3();
{
  #50 mark3_atk4;
  ai_face();
}

Void function mark3_atk4();
{
  if (self.health < 25) {
    if (random() < 0.5) {
      sound(self, CHAN_WEAPON, "nehahra/weapons/shotdud.wav", 1, ATTN_NORM);
      #53 mark3_atk7;
      exit;
      }
    }
  #51 mark3_atk5;
  ai_face();
}

Void function mark3_atk5();
{
  #52 mark3_atk6;
  Mons_fire_shotgun2();
  ai3_run(0);
}

Void function mark3_atk6();
{
  if (visible(self.enemy)) {
    if (random() < 0.7) {
      #53 mark3_atk5;
      ai_face();
      exit;
      }
    }
  #53 mark3_atk7;
  ai_face();
}

Void function mark3_atk7();
{
  #54 mark3_atk8;
  ai_face();
}

Void function mark3_atk8();
{
  #55 mark3_run1;
  ai_face();
}

Void function mark3_paina1();
{
  #56 mark3_paina2;
}

Void function mark3_paina2();
{
  #57 mark3_paina3;
}

Void function mark3_paina3();
{
  #58 mark3_paina4;
}

Void function mark3_paina4();
{
  #59 mark3_paina5;
}

Void function mark3_paina5();
{
  #60 mark3_paina6;
}

Void function mark3_paina6();
{
  #61 mark3_run1;
}


Void function mark3_pain(attacker : Object; damage : Real);
var
 r : Real;
{
  r = random();
  if (self.pain_finished > time) {
    exit;
    }
  self.pain_finished = time + 0.6;
  if (r < 0.5) {
    sound(self, CHAN_VOICE, "nehahra/enf2/pain1.wav", 1, ATTN_NORM);
    } else {
    sound(self, CHAN_VOICE, "nehahra/enf2/pain2.wav", 1, ATTN_NORM);
    }
  mark3_paina1();
}

Void function mark3_die1();
{
  dead_stay_dead();
  #0 mark3_die2;
}

Void function mark3_die2();
{
  #1 mark3_die3;
}

Void function mark3_die3();
{
  #2 mark3_die4;
  self.solid = SOLID_NOT;
  if (random() < 0.4) {
    self.ammo_shells = 20;
    }
  else {
    self.ammo_shells = 15;
    }
  DropBackpack();
}

Void function mark3_die4();
{
  #3 mark3_die5;
  ai_forward(14);
}

Void function mark3_die5();
{
  #4 mark3_die6;
  ai_forward(FL_SWIM);
}

Void function mark3_die6();
{
  #5 mark3_die7;
}

Void function mark3_die7();
{
  #6 mark3_die8;
}

Void function mark3_die8();
{
  #7 mark3_die9;
}

Void function mark3_die9();
{
  #8 mark3_die10;
  ai_forward(MOVETYPE_WALK);
}

Void function mark3_die10();
{
  #9 mark3_die11;
  ai_forward(MOVETYPE_FLY);
}

Void function mark3_die11();
{
  #10 mark3_die12;
  ai_forward(MOVETYPE_FLY);
}

Void function mark3_die12();
{
  #11 mark3_die13;
  ai_forward(MOVETYPE_FLY);
}

Void function mark3_die13();
{
  #12 mark3_die14;
}

Void function mark3_die14();
{
  #13 mark3_die15;
}

Void function mark3_die15();
{
  #14 mark3_die16;
}

Void function mark3_die16();
{
  #15 mark3_die17;
}

Void function mark3_die17();
{
  #16 mark3_die18;
}

Void function mark3_die18();
{
  #17 mark3_die19;
}

Void function mark3_die19();
{
  #18 mark3_die20;
}

Void function mark3_die20();
{
  #19 mark3_die21;
}

Void function mark3_die21();
{
  #21 mark3_die21;
}

Void function mark3_die22();
{
  #22 corpse_think;
}

Void function mark3_fdie1();
{
  dead_stay_dead();
  #78 mark3_fdie2;
}

Void function mark3_fdie2();
{
  #79 mark3_fdie3;
}

Void function mark3_fdie3();
{
  #80 mark3_fdie4;
  self.solid = SOLID_NOT;
  if (random() < 0.4) {
    self.ammo_shells = 15;
    }
  else {
    self.ammo_shells = 10;
    }
  DropBackpack();
}

Void function mark3_fdie4();
{
  #81 mark3_fdie5;
}

Void function mark3_fdie5();
{
  #82 mark3_fdie6;
}

Void function mark3_fdie6();
{
  #83 mark3_fdie7;
}

Void function mark3_fdie7();
{
  #84 mark3_fdie8;
}

Void function mark3_fdie8();
{
  #85 corpse_think;
}

Void function mark3_lowshot();
{
  #96 mark3_lowshot2;
  ai_face();
}

Void function mark3_lowshot2();
{
  self.th_pain = mark3_lowpain;
  self.th_die = mark3_lowdie;
  #97 mark3_lowshot3;
  ai_face();
}

Void function mark3_lowshot3();
{
  #98 mark3_lowshot4;
  ai_face();
}

Void function mark3_lowshot4();
{
  #99 mark3_lowshot5;
  ai_face();
}

Void function mark3_lowshot5();
{
  #100 mark3_lowshot6;
  Mons_fire_shotgun2();
}

Void function mark3_lowshot6();
{
  if (visible(self.enemy) && random() < 0.6) {
    #101 mark3_lowshot5;
    ai_face();
    exit;
    }
  #101 mark3_lowshot7;
}

Void function mark3_lowshot7();
{
  #99 mark3_lowshot8;
}

Void function mark3_lowshot8();
{
  #97 mark3_lowshot9;
}

Void function mark3_lowshot9();
{
  self.th_pain = mark3_pain;
  self.th_die = mark3_die;
  #98 mark3_run1;
}

Void function mark3_lowdie();
{
  #102 mark3_lowdie2;
}

Void function mark3_lowdie2();
{
  #103 mark3_die;
}

Void function mark3_lowpain();
{
  if (self.pain_finished > time) {
    exit;
    }
  self.pain_finished = time + 0.6;
  #102 mark3_lowpain2;
}

Void function mark3_lowpain2();
{
  #103 mark3_lowpain3;
}

Void function mark3_lowpain3();
{
  self.th_pain = mark3_pain;
  self.th_die = mark3_die;
  #104 mark3_run1;
}

Void function mark3_die();
{
  if (self.health < -35) {
    if (skill == 0) {
      self.ammo_nails = 20;
      DropBackpack();
      }
    sound(self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
    ThrowGib("progs/gib1.mdl", self.health);
    ThrowGib("progs/gib2.mdl", self.health);
    ThrowGib("progs/gib3.mdl", self.health);
    ThrowGib(25,1); // headmdl "progs/h_enf2.mdl"
    exit;
    }
  enf2_deathsound();
  if (random() > 0.5) {
    mark3_die1();
    }
  else {
    mark3_fdie1();
    }
}

Void function monster_enf2() = {
  if (deathmatch) {
    remove(self);
    exit;
    }

  precache_model("progs/mark3.mdl");
  precache_model("progs/h_enf2.mdl");
  precache_sound("enforcer/death1.wav");
  precache_sound("nehahra/enf2/sight1.wav");
  precache_sound("nehahra/enf2/comeon.wav");
  precache_sound("nehahra/enf2/pain1.wav");
  precache_sound("nehahra/enf2/pain2.wav");
	precache_sound("nehahra/weapons/shotdud.wav");
  precache_sound("nehahra/enf2/sight2.wav");
  precache_sound("nehahra/enf2/sight3.wav");
  precache_sound("nehahra/enf2/sight4.wav");
  precache_sound("nehahra/enf2/sight5.wav");
  precache_sound("nehahra/enf2/death1.wav");
  precache_sound("nehahra/enf2/death2.wav");
  precache_sound("nehahra/enf2/death3.wav");
  precache_sound("nehahra/enf2/idle1.wav");
  precache_sound("nehahra/enf2/idle2.wav");
  precache_sound("nehahra/enf2/idle3.wav");
  if (!(self.brain & NAVLOGIC)) {
    self.brain = self.brain | NAVLOGIC;
    }
  if (self.targetname == "actor1" || self.targetname == "actor2" || self.targetname == "actor3") {
    self.th_stand = mark3_actor_wait;
    self.th_walk = mark3_actor_wait;
    }
  else {
    self.th_stand = mark3_dstand;
    self.th_walk = mark3_walk1;
    }
  self.th_run = mark3_run1;
  self.th_pain = mark3_pain;
  self.th_die = mark3_die;
  self.th_missile = mark3_shoot;
  if (self.brain & TRIGGER_SPAWN) {
    self.use = enf2_start;
    exit;
    }
  carnify_enforcer2();
}

Void function enf2_start();
{
  trigger_spawnmonster();
  carnify_enforcer2();
}

Void function carnify_enforcer2();
{
  self.solid = SOLID_SLIDEBOX;
  self.movetype = MOVETYPE_STEP;
  setmodel(self, "progs/mark3.mdl");
  setsize(self, VEC_HULL_MIN, [16 16 40]);
  self.yaw_speed = 70;
  if (!(self.health)) {
    self.health = 160;
    }
  walkmonster_start();
}

Void function mark3_actor_wait();
{
  #36 mark3_actor_wait;
  self.use = mark3_actor_use;
}

Void function mark3_actor_use();
{
  if (self.goalentity != world) {
    #36 mark3_walk1;
    ai_walk(5);
    }
  else {
    #36 mark3_dstand;
    ai_stand();
    }
  self.th_stand = mark3_dstand;
  self.th_walk = mark3_walk1;
  self.use = monster_use;
}

Void function enf2_runfire1();
{
  if (borkfactor1()) {
    exit;
    }
  #105 enf2_runfire2;
  ai_face();
  if (ai_threats()) {
    exit;
    }
  ai_run_slide(12);
}

Void function enf2_runfire2();
{
  #106 enf2_runfire3;
  ai_face();
  self.effects = self.effects | EF_MUZZLEFLASH;
  Mons_Fire_Shotgun2();
  if (ai_threats()) {
    exit;
    }
  ai_run_slide(12);
}

Void function enf2_runfire3();
{
  #107 enf2_runfire4;
  ai_face();
  if (ai_threats()) {
    exit;
    }
  ai_run_slide(12);
}

Void function enf2_runfire4();
{
  #108 enf2_runfire5;
  ai_face();
  self.effects = self.effects | EF_MUZZLEFLASH;
  Mons_Fire_Shotgun2();
  if (ai_threats()) {
    exit;
    }
  ai_run_slide(12);
}

Void function enf2_runfire5();
{
  #109 enf2_runfire6;
  ai_face();
  if (ai_threats()) {
    exit;
    }
  ai_run_slide(12);
}

Void function enf2_runfire6();
{
  ai_face();
  self.effects = self.effects | EF_MUZZLEFLASH;
  Mons_Fire_Shotgun2();
  self.walkframe = 0;
  if (ai_threats()) {
    if (visible(self.enemy)) {
      #110 enf2_runfire1;
      ai_run_slide(12);
      exit;
      }
    }
  #110 mark3_run1;
  self.tactic = 0;
  ai_run_slide(12);
}

Void function enf2_sightsound();
var
 rsnd : Real;
{
  if (self.enemy == world) {
    exit;
    }
  if (self.enemy.classname == "player") {
    rsnd = rint(random() * MOVETYPE_WALK);
    if (rsnd == 1) {
      sound(self, CHAN_VOICE, "nehahra/enf2/comeon.wav", 1, ATTN_NORM);
      }
    else {
      if (rsnd == FL_SWIM) {
        sound(self, CHAN_VOICE, "nehahra/enf2/sight1.wav", 1, ATTN_NORM);
        }
      else {
        if (rsnd == 0) {
          sound(self, CHAN_VOICE, "nehahra/enf2/sight4.wav", 1, ATTN_NORM);
          }
        else {
          sound(self, CHAN_VOICE, "nehahra/enf2/sight3.wav", 1, ATTN_NORM);
          }
        }
      }
    exit;
    }
  rsnd = rint(random() * MOVETYPE_WALK);
  if (rsnd == 1) {
    sound(self, CHAN_VOICE, "nehahra/enf2/comeon.wav", 1, ATTN_NORM);
    }
  else {
    if (rsnd == FL_SWIM) {
      sound(self, CHAN_VOICE, "nehahra/enf2/sight4.wav", 1, ATTN_NORM);
      }
    else {
      if (rsnd == 0) {
        sound(self, CHAN_VOICE, "nehahra/enf2/sight5.wav", 1, ATTN_NORM);
        }
      else {
        sound(self, CHAN_VOICE, "nehahra/enf2/sight2.wav", 1, ATTN_NORM);
        }
      }
    }
}

Void function enf2_idlesound();
var
 num : Real;
{
  num = random() + random();
  if (num < 0.6) {
    sound(self, CHAN_VOICE, "nehahra/enf2/idle1.wav", 1, ATTN_NORM);
    exit;
    }
  if (num < 1.2) {
    sound(self, CHAN_VOICE, "nehahra/enf2/idle2.wav", 1, ATTN_NORM);
    exit;
    }
  sound(self, CHAN_VOICE, "nehahra/enf2/idle3.wav", 1, ATTN_NORM);
}

Void function enf2_deathsound();
var
 num : Real;
{
  num = random() + random();
  if (num < 0.6) {
    sound(self, CHAN_VOICE, "nehahra/enf2/death1.wav", 1, ATTN_NORM);
    exit;
    }
  if (num < 1.2) {
    sound(self, CHAN_VOICE, "nehahra/enf2/death2.wav", 1, ATTN_NORM);
    exit;
    }
  sound(self, CHAN_VOICE, "nehahra/enf2/death3.wav", 1, ATTN_NORM);
}

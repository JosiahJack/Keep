Void function boss_face();
{
  if (self.enemy.health <= 0 || random() < 0.020000) {
    self.enemy = find(self.enemy, classname, "player");
    if (!(self.enemy)) {
      self.enemy = find(self.enemy, classname, "player");
      }
    }
  ai_face();
}

Void function boss_rise1();
{
  #0 boss_rise2;
  sound(self, CHAN_WEAPON, "boss1/out1.wav", 1, ATTN_NORM);
}

Void function boss_rise2();
{
  #1 boss_rise3;
  sound(self, CHAN_VOICE, "boss1/sight1.wav", 1, ATTN_NORM);
}

Void function boss_rise3();
{
  #2 boss_rise4;
}

Void function boss_rise4();
{
  #3 boss_rise5;
}

Void function boss_rise5();
{
  #4 boss_rise6;
}

Void function boss_rise6();
{
  #5 boss_rise7;
}

Void function boss_rise7();
{
  #6 boss_rise8;
}

Void function boss_rise8();
{
  #7 boss_rise9;
}

Void function boss_rise9();
{
  #8 boss_rise10;
}

Void function boss_rise10();
{
  #9 boss_rise11;
}

Void function boss_rise11();
{
  #10 boss_rise12;
}

Void function boss_rise12();
{
  #11 boss_rise13;
}

Void function boss_rise13();
{
  #12 boss_rise14;
}

Void function boss_rise14();
{
  #13 boss_rise15;
}

Void function boss_rise15();
{
  #14 boss_rise16;
}

Void function boss_rise16();
{
  #15 boss_rise17;
}

Void function boss_rise17();
{
  #16 boss_missile1;
}

Void function boss_idle1();
{
  #17 boss_idle2;
}

Void function boss_idle2();
{
  #18 boss_idle3;
  boss_face();
}

Void function boss_idle3();
{
  #19 boss_idle4;
  boss_face();
}

Void function boss_idle4();
{
  #20 boss_idle5;
  boss_face();
}

Void function boss_idle5();
{
  #21 boss_idle6;
  boss_face();
}

Void function boss_idle6();
{
  #22 boss_idle7;
  boss_face();
}

Void function boss_idle7();
{
  #23 boss_idle8;
  boss_face();
}

Void function boss_idle8();
{
  #24 boss_idle9;
  boss_face();
}

Void function boss_idle9();
{
  #25 boss_idle10;
  boss_face();
}

Void function boss_idle10();
{
  #26 boss_idle11;
  boss_face();
}

Void function boss_idle11();
{
  #27 boss_idle12;
  boss_face();
}

Void function boss_idle12();
{
  #28 boss_idle13;
  boss_face();
}

Void function boss_idle13();
{
  #29 boss_idle14;
  boss_face();
}

Void function boss_idle14();
{
  #30 boss_idle15;
  boss_face();
}

Void function boss_idle15();
{
  #31 boss_idle16;
  boss_face();
}

Void function boss_idle16();
{
  #32 boss_idle17;
  boss_face();
}

Void function boss_idle17();
{
  #33 boss_idle18;
  boss_face();
}

Void function boss_idle18();
{
  #34 boss_idle19;
  boss_face();
}

Void function boss_idle19();
{
  #35 boss_idle20;
  boss_face();
}

Void function boss_idle20();
{
  #36 boss_idle21;
  boss_face();
}

Void function boss_idle21();
{
  #37 boss_idle22;
  boss_face();
}

Void function boss_idle22();
{
  #38 boss_idle23;
  boss_face();
}

Void function boss_idle23();
{
  #39 boss_idle24;
  boss_face();
}

Void function boss_idle24();
{
  #40 boss_idle25;
  boss_face();
}

Void function boss_idle25();
{
  #41 boss_idle26;
  boss_face();
}

Void function boss_idle26();
{
  #42 boss_idle27;
  boss_face();
}

Void function boss_idle27();
{
  #43 boss_idle28;
  boss_face();
}

Void function boss_idle28();
{
  #44 boss_idle29;
  boss_face();
}

Void function boss_idle29();
{
  #45 boss_idle30;
  boss_face();
}

Void function boss_idle30();
{
  #46 boss_idle31;
  boss_face();
}

Void function boss_idle31();
{
  #47 boss_idle1;
  boss_face();
}

Void function boss_missile1();
{
  #57 boss_missile2;
  boss_face();
}

Void function boss_missile2();
{
  #58 boss_missile3;
  boss_face();
}

Void function boss_missile3();
{
  #59 boss_missile4;
  boss_face();
}

Void function boss_missile4();
{
  #60 boss_missile5;
  boss_face();
}

Void function boss_missile5();
{
  #61 boss_missile6;
  boss_face();
}

Void function boss_missile6();
{
  #62 boss_missile7;
  boss_face();
}

Void function boss_missile7();
{
  #63 boss_missile8;
  boss_face();
}

Void function boss_missile8();
{
  #64 boss_missile9;
  boss_face();
}

Void function boss_missile9();
{
  #65 boss_missile10;
  boss_missile([100 100 200]);
}

Void function boss_missile10();
{
  #66 boss_missile11;
  boss_face();
}

Void function boss_missile11();
{
  #67 boss_missile12;
  boss_face();
}

Void function boss_missile12();
{
  #68 boss_missile13;
  boss_face();
}

Void function boss_missile13();
{
  #69 boss_missile14;
  boss_face();
}

Void function boss_missile14();
{
  #70 boss_missile15;
  boss_face();
}

Void function boss_missile15();
{
  #71 boss_missile16;
  boss_face();
}

Void function boss_missile16();
{
  #72 boss_missile17;
  boss_face();
}

Void function boss_missile17();
{
  #73 boss_missile18;
  boss_face();
}

Void function boss_missile18();
{
  #74 boss_missile19;
  boss_face();
}

Void function boss_missile19();
{
  #75 boss_missile20;
  boss_face();
}

Void function boss_missile20();
{
  #76 boss_missile21;
  boss_missile([100 -100 200]);
}

Void function boss_missile21();
{
  #77 boss_missile22;
  boss_face();
}

Void function boss_missile22();
{
  #78 boss_missile23;
  boss_face();
}

Void function boss_missile23();
{
  #79 boss_missile1;
  boss_face();
}

Void function boss_shocka1();
{
  #80 boss_shocka2;
}

Void function boss_shocka2();
{
  #81 boss_shocka3;
}

Void function boss_shocka3();
{
  #82 boss_shocka4;
}

Void function boss_shocka4();
{
  #83 boss_shocka5;
}

Void function boss_shocka5();
{
  #84 boss_shocka6;
}

Void function boss_shocka6();
{
  #85 boss_shocka7;
}

Void function boss_shocka7();
{
  #86 boss_shocka8;
}

Void function boss_shocka8();
{
  #87 boss_shocka9;
}

Void function boss_shocka9();
{
  #88 boss_shocka10;
}

Void function boss_shocka10();
{
  #89 boss_missile1;
}

Void function boss_shockb1();
{
  #90 boss_shockb2;
}

Void function boss_shockb2();
{
  #91 boss_shockb3;
}

Void function boss_shockb3();
{
  #92 boss_shockb4;
}

Void function boss_shockb4();
{
  #93 boss_shockb5;
}

Void function boss_shockb5();
{
  #94 boss_shockb6;
}

Void function boss_shockb6();
{
  #95 boss_shockb7;
}

Void function boss_shockb7();
{
  #90 boss_shockb8;
}

Void function boss_shockb8();
{
  #91 boss_shockb9;
}

Void function boss_shockb9();
{
  #92 boss_shockb10;
}

Void function boss_shockb10();
{
  #93 boss_missile1;
}

Void function boss_shockc1();
{
  #96 boss_shockc2;
}

Void function boss_shockc2();
{
  #97 boss_shockc3;
}

Void function boss_shockc3();
{
  #98 boss_shockc4;
}

Void function boss_shockc4();
{
  #99 boss_shockc5;
}

Void function boss_shockc5();
{
  #100 boss_shockc6;
}

Void function boss_shockc6();
{
  #101 boss_shockc7;
}

Void function boss_shockc7();
{
  #102 boss_shockc8;
}

Void function boss_shockc8();
{
  #103 boss_shockc9;
}

Void function boss_shockc9();
{
  #104 boss_shockc10;
}

Void function boss_shockc10();
{
  #105 boss_death1;
}

Void function boss_death1();
{
  #48 boss_death2;
  sound(self, CHAN_VOICE, "boss1/death.wav", 1, ATTN_NORM);
}

Void function boss_death2();
{
  #49 boss_death3;
}

Void function boss_death3();
{
  #50 boss_death4;
}

Void function boss_death4();
{
  #51 boss_death5;
}

Void function boss_death5();
{
  #52 boss_death6;
}

Void function boss_death6();
{
  #53 boss_death7;
}

Void function boss_death7();
{
  #54 boss_death8;
}

Void function boss_death8();
{
  #55 boss_death9;
}

Void function boss_death9();
{
  #56 boss_death10;
  sound(self, CHAN_BODY, "boss1/out1.wav", 1, ATTN_NORM);
  WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
  WriteByte(MSG_BROADCAST, TE_LAVASPLASH);
  WriteCoord(MSG_BROADCAST, self.origin_x);
  WriteCoord(MSG_BROADCAST, self.origin_y);
  WriteCoord(MSG_BROADCAST, self.origin_z);
}

Void function boss_death10();
{
  #56 boss_death10;
  killed_monsters = killed_monsters + 1;
  WriteByte(MSG_ALL, SVC_KILLEDMONSTER);
  SUB_UseTargets();
  remove(self);
}

Void function boss_missile(p : Vector);
var
 offang : Vector;
 org : Vector;
 vec : Vector;
 d : Vector;
 t : Real;
{
  offang = vectoangles(self.enemy.origin - self.origin);
  makevectors(offang);
  org = self.origin + p_x * v_forward + p_y * v_right + p_z * [0 0 1];
  if (skill > 1) {
    t = vlen(self.enemy.origin - org) / 300;
    vec = self.enemy.velocity;
    vec_z = 0;
    d = self.enemy.origin + t * vec;
    }
  else {
    d = self.enemy.origin;
    }
  vec = normalize(d - org);
  launch_spike(org, vec);
  setmodel(newmis, "progs/lavaball.mdl");
  newmis.avelocity = [200 100 300];
  setsize(newmis, VEC_ORIGIN, VEC_ORIGIN);
  newmis.velocity = vec * 300;
  newmis.touch = T_MissileTouch;
  sound(self, CHAN_WEAPON, "boss1/throw.wav", 1, ATTN_NORM);
  if (self.enemy.health <= 0) {
    boss_idle1();
    }
}

Void function boss_awake();
{
  self.solid = SOLID_SLIDEBOX;
  self.movetype = MOVETYPE_STEP;
  self.takedamage = DAMAGE_NO;
  setmodel(self, "progs/boss.mdl");
  setsize(self, [-128 -128 -24], [128 128 256]);
  if (skill == 0) {
    self.health = 1;
    }
  else {
    self.health = MOVETYPE_WALK;
    }
  self.enemy = activator;
  WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
  WriteByte(MSG_BROADCAST, TE_LAVASPLASH);
  WriteCoord(MSG_BROADCAST, self.origin_x);
  WriteCoord(MSG_BROADCAST, self.origin_y);
  WriteCoord(MSG_BROADCAST, self.origin_z);
  self.yaw_speed = 20;
  boss_rise1();
}

Void function monster_boss();
{
  if (deathmatch) {
    remove(self);
    exit;
    }
  total_monsters = total_monsters + 1;
  precache_model("progs/boss.mdl");
  precache_model("progs/lavaball.mdl");
  precache_sound("weapons/rocket1i.wav");
  precache_sound("boss1/out1.wav");
  precache_sound("boss1/sight1.wav");
  precache_sound("misc/power.wav");
  precache_sound("boss1/throw.wav");
  precache_sound("boss1/pain.wav");
  precache_sound("boss1/death.wav");
  self.use = boss_awake;
}

Void function lightning_fire();
var
 p1 : Vector;
 p2 : Vector;
{
  if (time >= lightning_end) {
    self = le1;
    door_go_down();
    self = le2;
    door_go_down();
    exit;
    }
  p1 = (le1.mins + le1.maxs) * 0.5;
  p1_z = le1.absmin_z - FL_INWATER;
  p2 = (le2.mins + le2.maxs) * 0.5;
  p2_z = le2.absmin_z - FL_INWATER;
  p2 = p2 - normalize(p2 - p1) * 100;
  self.nextthink = time + 0.1;
  self.think = lightning_fire;
  WriteByte(MSG_ALL, SVC_TEMPENTITY);
  WriteByte(MSG_ALL, TE_LIGHTNING3);
  WriteEntity(MSG_ALL, world);
  WriteCoord(MSG_ALL, p1_x);
  WriteCoord(MSG_ALL, p1_y);
  WriteCoord(MSG_ALL, p1_z);
  WriteCoord(MSG_ALL, p2_x);
  WriteCoord(MSG_ALL, p2_y);
  WriteCoord(MSG_ALL, p2_z);
}

Void function lightning_use();
{
  if (lightning_end >= time + 1) {
    exit;
    }
  le1 = find(world, target, "lightning");
  le2 = find(le1, target, "lightning");
  if (!le1 || !le2) {
    dprint("missing lightning targets|");
    exit;
    }
  if (le1.state != STATE_TOP && le1.state != STATE_BOTTOM || (le2.state != STATE_TOP && le2.state != STATE_BOTTOM) || le1.state != le2.state) {
    exit;
    }
  le1.nextthink = CONTENT_EMPTY;
  le2.nextthink = CONTENT_EMPTY;
  lightning_end = time + 1;
  sound(self, CHAN_VOICE, "misc/power.wav", 1, ATTN_NORM);
  lightning_fire();
  self = find(world, classname, "monster_boss");
  if (!self) {
    exit;
    }
  self.enemy = activator;
  if (le1.state == STATE_TOP && self.health > 0) {
    sound(self, CHAN_VOICE, "boss1/pain.wav", 1, ATTN_NORM);
    self.health = self.health - 1;
    if (self.health >= FL_SWIM) {
      boss_shocka1();
      }
    else {
      if (self.health == 1) {
        boss_shockb1();
        }
      else {
        if (self.health == 0) {
          boss_shockc1();
          }
        }
      }
    }
}

Void function event_lightning();
{
  self.use = lightning_use;
}


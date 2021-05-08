Void function old_idle1();
{
  #0 old_idle2;
}

Void function old_idle2();
{
  #1 old_idle3;
}

Void function old_idle3();
{
  #2 old_idle4;
}

Void function old_idle4();
{
  #3 old_idle5;
}

Void function old_idle5();
{
  #4 old_idle6;
}

Void function old_idle6();
{
  #5 old_idle7;
}

Void function old_idle7();
{
  #6 old_idle8;
}

Void function old_idle8();
{
  #7 old_idle9;
}

Void function old_idle9();
{
  #8 old_idle10;
}

Void function old_idle10();
{
  #9 old_idle11;
}

Void function old_idle11();
{
  #10 old_idle12;
}

Void function old_idle12();
{
  #11 old_idle13;
}

Void function old_idle13();
{
  #12 old_idle14;
}

Void function old_idle14();
{
  #13 old_idle15;
}

Void function old_idle15();
{
  #14 old_idle16;
}

Void function old_idle16();
{
  #15 old_idle17;
}

Void function old_idle17();
{
  #16 old_idle18;
}

Void function old_idle18();
{
  #17 old_idle19;
}

Void function old_idle19();
{
  #18 old_idle20;
}

Void function old_idle20();
{
  #19 old_idle21;
}

Void function old_idle21();
{
  #20 old_idle22;
}

Void function old_idle22();
{
  #21 old_idle23;
}

Void function old_idle23();
{
  #22 old_idle24;
}

Void function old_idle24();
{
  #23 old_idle25;
}

Void function old_idle25();
{
  #24 old_idle26;
}

Void function old_idle26();
{
  #25 old_idle27;
}

Void function old_idle27();
{
  #26 old_idle28;
}

Void function old_idle28();
{
  #27 old_idle29;
}

Void function old_idle29();
{
  #28 old_idle30;
}

Void function old_idle30();
{
  #29 old_idle31;
}

Void function old_idle31();
{
  #30 old_idle32;
}

Void function old_idle32();
{
  #31 old_idle33;
}

Void function old_idle33();
{
  #32 old_idle34;
}

Void function old_idle34();
{
  #33 old_idle35;
}

Void function old_idle35();
{
  #34 old_idle36;
}

Void function old_idle36();
{
  #35 old_idle37;
}

Void function old_idle37();
{
  #36 old_idle38;
}

Void function old_idle38();
{
  #37 old_idle39;
}

Void function old_idle39();
{
  #38 old_idle40;
}

Void function old_idle40();
{
  #39 old_idle41;
}

Void function old_idle41();
{
  #40 old_idle42;
}

Void function old_idle42();
{
  #41 old_idle43;
}

Void function old_idle43();
{
  #42 old_idle44;
}

Void function old_idle44();
{
  #43 old_idle45;
}

Void function old_idle45();
{
  #44 old_idle46;
}

Void function old_idle46();
{
  #45 old_idle1;
}

Void function old_thrash1();
{
  #46 old_thrash2;
  lightstyle(0, "m");
}

Void function old_thrash2();
{
  #47 old_thrash3;
  lightstyle(0, "k");
}

Void function old_thrash3();
{
  #48 old_thrash4;
  lightstyle(0, "k");
}

Void function old_thrash4();
{
  #49 old_thrash5;
  lightstyle(0, "i");
}

Void function old_thrash5();
{
  #50 old_thrash6;
  lightstyle(0, "g");
}

Void function old_thrash6();
{
  #51 old_thrash7;
  lightstyle(0, "e");
}

Void function old_thrash7();
{
  #52 old_thrash8;
  lightstyle(0, "c");
}

Void function old_thrash8();
{
  #53 old_thrash9;
  lightstyle(0, "a");
}

Void function old_thrash9();
{
  #54 old_thrash10;
  lightstyle(0, "c");
}

Void function old_thrash10();
{
  #55 old_thrash11;
  lightstyle(0, "e");
}

Void function old_thrash11();
{
  #56 old_thrash12;
  lightstyle(0, "g");
}

Void function old_thrash12();
{
  #57 old_thrash13;
  lightstyle(0, "i");
}

Void function old_thrash13();
{
  #59 old_thrash14;
  lightstyle(0, "k");
}

Void function old_thrash14();
{
  #60 old_thrash15;
  lightstyle(0, "m");
}

Void function old_thrash15();
{
  #61 old_thrash16;
  lightstyle(0, "m");
  self.cnt = self.cnt + 1;
  if (self.cnt != MOVETYPE_WALK) {
    self.think = old_thrash1;
    }
}

Void function old_thrash16();
{
  #62 old_thrash17;
  lightstyle(0, "g");
}

Void function old_thrash17();
{
  #63 old_thrash18;
  lightstyle(0, "c");
}

Void function old_thrash18();
{
  #64 old_thrash19;
  lightstyle(0, "b");
}

Void function old_thrash19();
{
  #65 old_thrash20;
  lightstyle(0, "a");
}

Void function old_thrash20();
{
  #66 old_thrash20;
  finale_4();
}

Void function finale_1();
var
 pos : Object;
 pl : Object;
 timer : Object;
{
  intermission_exittime = time + 10000000;
  intermission_running = 1;
  pos = find(world, classname, "info_intermission");
  if (!pos) {
    error("no info_intermission");
    }
  pl = find(world, classname, "misc_teleporttrain");
  if (!pl) {
    error("no teleporttrain");
    }
  remove(pl);
  WriteByte(MSG_ALL, SVC_FINALE);
  WriteString(MSG_ALL, "");
  pl = find(world, classname, "player");
  while (pl != world) {
    pl.view_ofs = VEC_ORIGIN;
    pl.angles = other.v_angle = pos.mangle;
    pl.fixangle = 1;
    pl.map = self.map;
    pl.nextthink = time + 0.5;
    pl.takedamage = DAMAGE_NO;
    pl.solid = SOLID_NOT;
    pl.movetype = MOVETYPE_NONE;
    pl.modelindex = 0;
    setorigin(pl, pos.origin);
    pl = find(pl, classname, "player");
    }
  timer = spawn();
  timer.nextthink = time + 1;
  timer.think = finale_2;
}

Void function finale_2();
var
 o : Vector;
{
  o = shub.origin - [0 100 0];
  WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
  WriteByte(MSG_BROADCAST, TE_TELEPORT);
  WriteCoord(MSG_BROADCAST, o_x);
  WriteCoord(MSG_BROADCAST, o_y);
  WriteCoord(MSG_BROADCAST, o_z);
  sound(shub, CHAN_VOICE, "misc/r_tele1.wav", 1, ATTN_NORM);
  self.nextthink = time + FL_SWIM;
  self.think = finale_3;
}

Void function finale_3();
{
  shub.think = old_thrash1;
  sound(shub, CHAN_VOICE, "boss2/death.wav", 1, ATTN_NORM);
  lightstyle(0, "abcdefghijklmlkjihgfedcb");
}

Void function finale_4();
var
 oldo : Vector;
 x : Real;
 y : Real;
 z : Real;
 r : Real;
 n : Object;
{
  sound(self, CHAN_VOICE, "boss2/pop2.wav", 1, ATTN_NORM);
  oldo = self.origin;
  z = FL_INWATER;
  while (z <= 144) {
    x = -64;
    while (x <= FL_GODMODE) {
      y = -64;
      while (y <= FL_GODMODE) {
        self.origin_x = oldo_x + x;
        self.origin_y = oldo_y + y;
        self.origin_z = oldo_z + z;
        r = random();
        if (r < 0.3) {
          ThrowGib("progs/gib1.mdl", -999);
          }
        else {
          if (r < 0.6) {
            ThrowGib("progs/gib2.mdl", -999);
            }
          else {
            ThrowGib("progs/gib3.mdl", -999);
            }
          }
        y = y + FL_MONSTER;
        }
      x = x + FL_MONSTER;
      }
    z = z + 96;
    }
  WriteByte(MSG_ALL, SVC_FINALE);
  WriteString(MSG_ALL, "Congratulations and well done! You have|beaten the hideous Shub-Niggurath, and|her hundreds of ugly changelings and|monsters. You have proven that your|skill and your cunning are greater than|all the powers of Quake. You are the|master now. Id Software salutes you.");
  n = spawn();
  setmodel(n, "progs/player.mdl");
  oldo = oldo - [32 264 0];
  setorigin(n, oldo);
  n.angles = [0 290 0];
  n.frame = 1;
  remove(self);
  WriteByte(MSG_ALL, SVC_CDTRACK);
  WriteByte(MSG_ALL, MOVETYPE_WALK);
  WriteByte(MSG_ALL, MOVETYPE_WALK);
  lightstyle(0, "m");
}

Void function monster_oldone();
{
  if (deathmatch) {
    remove(self);
    exit;
    }
  precache_model2("progs/oldone.mdl");
  precache_sound2("boss2/death.wav");
  precache_sound2("boss2/idle.wav");
  precache_sound2("boss2/sight.wav");
  precache_sound2("boss2/pop2.wav");
  self.solid = SOLID_SLIDEBOX;
  self.movetype = MOVETYPE_STEP;
  setmodel(self, "progs/oldone.mdl");
  setsize(self, [-160 -128 -24], [160 128 256]);
  self.health = 40000;
  self.think = old_idle1;
  self.nextthink = time + 0.1;
  self.takedamage = DAMAGE_YES;
  self.th_die = finale_1;
  shub = self;
  total_monsters = total_monsters + 1;
}


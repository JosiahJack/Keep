Void function misc_hummer();
{
  misc_car();
}

Void function info_null();
{
  remove(self);
}

Void function info_notnull();
{
}

Void function light_use();
{
  if (self.spawnflags & START_OFF) {
    lightstyle(self.style, "m");
    self.spawnflags = self.spawnflags - START_OFF;
    }
  else {
    lightstyle(self.style, "a");
    self.spawnflags = self.spawnflags + START_OFF;
    }
}

Void function light();
{
  if (!(self.targetname)) {
    remove(self);
    exit;
    }
  if (self.style >= FL_MONSTER) {
    self.use = light_use;
    if (self.spawnflags & START_OFF) {
      lightstyle(self.style, "a");
      }
    else {
      lightstyle(self.style, "m");
      }
    }
}

Void function light_fluoro();
{
  if (self.style >= FL_MONSTER) {
    self.use = light_use;
    if (self.spawnflags & START_OFF) {
      lightstyle(self.style, "a");
      }
    else {
      lightstyle(self.style, "m");
      }
    }
  precache_sound("ambience/fl_hum1.wav");
  ambientsound(self.origin, "ambience/fl_hum1.wav", 0.5, ATTN_STATIC);
}

Void function light_fluorospark();
{
  if (!(self.style)) {
    self.style = MOVETYPE_BOUNCE;
    }
  precache_sound("ambience/buzz1.wav");
  ambientsound(self.origin, "ambience/buzz1.wav", 0.5, ATTN_STATIC);
}

Void function light_globe();
{
  precache_model("progs/s_light.spr");
  setmodel(self, "progs/s_light.spr");
  makestatic(self);
}

Void function FireAmbient();
{
  precache_sound("ambience/fire1.wav");
  ambientsound(self.origin, "ambience/fire1.wav", 0.5, ATTN_STATIC);
}

Void function light_torch_small_walltorch();
{
  precache_model("progs/flame.mdl");
  setmodel(self, "progs/flame.mdl");
  FireAmbient();
  makestatic(self);
}

Void function light_flame_large_yellow();
{
  precache_model("progs/flame2.mdl");
  setmodel(self, "progs/flame2.mdl");
  self.frame = 1;
  FireAmbient();
  makestatic(self);
}

Void function light_flame_small_yellow();
{
  precache_model("progs/flame2.mdl");
  setmodel(self, "progs/flame2.mdl");
  FireAmbient();
  makestatic(self);
}

Void function light_flame_small_white();
{
  precache_model("progs/flame2.mdl");
  setmodel(self, "progs/flame2.mdl");
  FireAmbient();
  makestatic(self);
}

Void function light_lantern();
{
  precache_model("progs/lantern0.mdl");
  setmodel(self, "progs/lantern0.mdl");
  FireAmbient();
  makestatic(self);
}

Void function light_swinging_lantern();
{
  precache_model("progs/lantern.mdl");
  setmodel(self, "progs/lantern.mdl");
  FireAmbient();
  makestatic(self);
}

Void function light_candle_t();
{
  precache_model("progs/candle_t.mdl");
  setmodel(self, "progs/candle_t.mdl");
  FireAmbient();
  makestatic(self);
}

Void function light_candle_w();
{
  precache_model("progs/candle_w.mdl");
  setmodel(self, "progs/candle_w.mdl");
  FireAmbient();
  makestatic(self);
}

Void function light_candleth();
{
  precache_model("progs/candleth.mdl");
  setmodel(self, "progs/candleth.mdl");
  FireAmbient();
  makestatic(self);
}

Void function light_candlews();
{
  precache_model("progs/candlews.mdl");
  setmodel(self, "progs/candlews.mdl");
  FireAmbient();
  makestatic(self);
}

Void function misc_fireball();
{
  precache_model("progs/lavaball.mdl");
  self.classname = "fireball";
  self.nextthink = time + random() * MOVETYPE_FLY;
  self.think = fire_fly;
  if (!(self.speed)) {
    self.speed == 1000;
    }
}

Void function fire_fly();
var
 fireball : Object;
{
  fireball = spawn();
  fireball.solid = SOLID_TRIGGER;
  fireball.movetype = MOVETYPE_TOSS;
  fireball.velocity = [0 0 1000];
  fireball.velocity_x = random() * 100 - 50;
  fireball.velocity_y = random() * 100 - 50;
  fireball.velocity_z = self.speed + random() * 200;
  fireball.classname = "fireball";
  setmodel(fireball, "progs/lavaball.mdl");
  setsize(fireball, VEC_ORIGIN, VEC_ORIGIN);
  setorigin(fireball, self.origin);
  fireball.nextthink = time + MOVETYPE_FLY;
  fireball.think = SUB_Remove;
  fireball.touch = fire_touch;
  self.nextthink = time + random() * MOVETYPE_FLY + MOVETYPE_WALK;
  self.think = fire_fly;
}

Void function fire_touch();
{
  T_Damage(other, self, self, 20);
  remove(self);
}

Void function misc_slime_ball();
{
  precache_model("progs/slime.mdl");
  self.classname = "slimeball";
  self.nextthink = time + random() * MOVETYPE_FLY;
  self.think = slime_fly;
  if (!(self.speed)) {
    self.speed == 1000;
    }
}

Void function slime_fly();
var
 fireball : Object;
{
  fireball = spawn();
  fireball.solid = SOLID_TRIGGER;
  fireball.movetype = MOVETYPE_TOSS;
  fireball.velocity = [0 0 1000];
  fireball.velocity_x = random() * 100 - 50;
  fireball.velocity_y = random() * 100 - 50;
  fireball.velocity_z = 100 + random() * 200;
  fireball.classname = "slime";
  setmodel(fireball, "progs/slime.mdl");
  setsize(fireball, VEC_ORIGIN, VEC_ORIGIN);
  setorigin(fireball, self.origin);
  fireball.nextthink = time + MOVETYPE_FLY;
  fireball.think = SUB_Remove;
  fireball.touch = slime_touch;
  self.nextthink = time + random() * MOVETYPE_FLY + MOVETYPE_WALK;
  self.think = slime_fly;
}

Void function slime_touch();
{
  T_Damage(other, self, self, 10);
  remove(self);
}

Void function barrel_explode();
{
  self.takedamage = DAMAGE_NO;
  self.classname = "explo_box";
  T_RadiusDamage(self, self, 160, world);
  sound(self, CHAN_VOICE, "weapons/r_exp3.wav", 1, ATTN_NORM);
  particle(self.origin, VEC_ORIGIN, 75, 255);
  self.origin_z = self.origin_z + FL_MONSTER;
  WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
  WriteByte(MSG_BROADCAST, TE_EXPLOSION);
  WriteCoord(MSG_BROADCAST, self.origin_x);
  WriteCoord(MSG_BROADCAST, self.origin_y);
  WriteCoord(MSG_BROADCAST, self.origin_z);
  BecomeExplosion();
}

Void function sbarrel_explode();
{
  self.takedamage = DAMAGE_NO;
  self.classname = "slime_barrel";
  T_RadiusDamage(self, self, 60, world);
  sound(self, CHAN_VOICE, "weapons/r_exp3.wav", 1, ATTN_NORM);
  particle(self.origin, VEC_ORIGIN, 80, 255);
  self.origin_z = self.origin_z + FL_MONSTER;
  slime_fly();
  Wraith_Throws_Gunk();
  slime_fly();
  if (random() < 0.2) {
    ThrowGib("progs/bartop.mdl", self.health);
    ThrowGib("progs/slime.mdl", self.health);
    }
  ThrowGib("progs/slime.mdl", self.health);
  ThrowGib("progs/slime.mdl", self.health);
  WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
  WriteByte(MSG_BROADCAST, TE_EXPLOSION3);
  WriteCoord(MSG_BROADCAST, self.origin_x);
  WriteCoord(MSG_BROADCAST, self.origin_y);
  WriteCoord(MSG_BROADCAST, self.origin_z);
  WriteCoord(MSG_BROADCAST, 0.1);
  WriteCoord(MSG_BROADCAST, 0.8);
  WriteCoord(MSG_BROADCAST, 0.2);
  BecomeExplosion();
}

Void function misc_barrel();
var
 oldz : Real;
{
  self.solid = SOLID_SLIDEBOX;
  self.movetype = MOVETYPE_STEP;
  precache_model("progs/barrel.mdl");
  precache_model("progs/bartop.mdl");
  precache_model("progs/slime.mdl");
  setmodel(self, "progs/barrel.mdl");
  if (!(self.frame)) { 
    setsize(self, VEC_HULL_MIN, [10 10 10]);
    self.health = 30;
    }
  else {
    if (self.frame == 1) {
      setsize(self, VEC_HULL_MIN, [10 10 10]);
      self.health = 40;
      }
    else {
      if (self.frame == 2) {
        setsize(self, VEC_HULL_MIN, [12 12 12]);
        self.health = 50;
        }
      else {
        dprint("removed barrel with invalid frame|");
        remove(self);
        exit;
        }
      }
    }
  precache_sound("weapons/r_exp3.wav");
  self.health = 20;
  self.th_die = sbarrel_explode;
  self.takedamage = DAMAGE_AIM;
  self.event = "metal";
  self.touch = player_push;
  self.origin_z = self.origin_z + FL_SWIM;
  oldz = self.origin_z;
  droptofloor();
  if (oldz - self.origin_z > 250) {
    dprint("item fell out of level at ");
    dprint(vtos(self.origin));
    dprint("|");
    remove(self);
    }
  self.think = box_think;
  self.nextthink = time + 0.3;
}

Void function misc_explobox();
var
 oldz : Real;
{
  self.solid = SOLID_SLIDEBOX;
  self.movetype = MOVETYPE_STEP;
  precache_model("maps/b_explob.bsp");
  setmodel(self, "maps/b_explob.bsp");
  precache_sound("weapons/r_exp3.wav");
  self.health = 20;
  self.th_die = barrel_explode;
  self.takedamage = DAMAGE_AIM;
  self.touch = player_push;
  self.origin_z = self.origin_z + FL_SWIM;
  oldz = self.origin_z;
  droptofloor();
  if (oldz - self.origin_z > 250) {
    dprint("item fell out of level at ");
    dprint(vtos(self.origin));
    dprint("|");
    remove(self);
    }
  self.think = box_think;
  self.nextthink = time + 0.3;
}

Void function misc_explobox2();
var
 oldz : Real;
{
  self.solid = SOLID_SLIDEBOX;
  self.movetype = MOVETYPE_STEP;
  precache_model2("maps/b_exbox2.bsp");
  setmodel(self, "maps/b_exbox2.bsp");
  precache_sound("weapons/r_exp3.wav");
  self.health = 20;
  self.th_die = barrel_explode;
  self.takedamage = DAMAGE_AIM;
  self.touch = player_push;
  self.origin_z = self.origin_z + FL_SWIM;
  oldz = self.origin_z;
  droptofloor();
  if (oldz - self.origin_z > 250) {
    dprint("item fell out of level at ");
    dprint(vtos(self.origin));
    dprint("|");
    remove(self);
    }
  self.think = box_think;
  self.nextthink = time + 0.3;
}

Void function box_think();
{
  if (self.watertype == CONTENT_LAVA) {
    barrel_explode();
    exit;
    }
  if (pointcontents(self.origin) < CONTENT_SOLID) {
    self.think = box_float;
    self.nextthink = time + 0.1;
    exit;
    }
  self.think = box_think;
  self.nextthink = time + 0.2;
}

Void function box_float();
var
 spot : Vector;
 spot2 : Vector;
{
  self.touch = experiment_push;
  spot = self.origin + [0 0 5];
  spot2 = self.origin + [0 0 2];
  if (pointcontents(spot) == CONTENT_WATER || pointcontents(spot) == CONTENT_SLIME || pointcontents(spot2) == CONTENT_SOLID) {
    self.velocity_z = 80;
    dprint("up|");
    }
  else {
    if (pointcontents(spot) == CONTENT_EMPTY) {
      if (pointcontents(spot2) == CONTENT_WATER || pointcontents(spot2) == CONTENT_SLIME) {
        self.velocity_x = rint(3 * random());
        self.velocity_y = rint(3 * random());
        if (random() < 0.5) {
          self.velocity_x = self.velocity_x * -1;
          }
        else {
          self.velocity_y = self.velocity_y * -1;
          }
        if (self.velocity_z < -1) {
          self.velocity_z = -1;
          }
        }
      else {
        if (pointcontents(spot2) == CONTENT_EMPTY) {
          if (self.velocity_z < -1) {
            self.velocity_z = -1;
            }
          }
        }
      }
    }
  self.think = box_float;
  self.nextthink = time + 0.1;
}

Void function player_push();
var
 spot : Vector;
 meas : real;
 chck : real;
{
  if (other.classname != "player") {
    exit;
    }
  if (IsOnTopOf(other, self)) {
    exit;
    }
  if (self.pain_finished < time) {
    self.pain_finished = time + 0.4;
    if (self.event == "stone") {
      sound(self, 7, "wall/statslid.wav", 1, ATTN_NORM);
      }
    else {
      sound(self, 7, "wall/barslide.wav", 1, ATTN_NORM);
      }
    }
  if (walkmove(other.angles_y, 2) == FALSE) {
    meas = other.origin_z + 3;
    chck = meas - self.origin_z;
    if (self.origin_z < meas) {
      if (chck < 10) {
        self.origin_z = self.origin_z + 1;
        }
      self.velocity_x = other.velocity_x + 4 * random();
      self.velocity_y = other.velocity_y + 4 * random();
      if (self.flags & FL_ONGROUND) {
        self.flags = self.flags - FL_ONGROUND;
        }
      }
    }
}

Void function misc_corpse();
{
  if (deathmatch) {
    remove(self);
    exit;
    }
  self.soul = "yes";
  if (self.cnt < 0) {
    self.cnt = 0;
    }
  if (self.cnt < 5) {
    precache_model("progs/player.mdl");
    setmodel(self, "progs/player.mdl");
    }
  else {
    if (self.cnt < 7) {
      precache_model("progs/soldier.mdl");
      setmodel(self, "progs/soldier.mdl");
      }
    else {
      if (self.cnt < 9) {
        precache_model("progs/mark3.mdl");
        setmodel(self, "progs/mark3.mdl");
        }
      else {
        objerror("*cnt* of misc_corpse set to unsupported number|");
        }
      }
    }
  self.solid = SOLID_NOT;
  self.movetype = MOVETYPE_NONE;
  if (self.cnt == 0) {
    self.frame = 60;
    }
  if (self.cnt == 1) {
    self.frame = 69;
    }
  if (self.cnt == 2) {
    self.frame = 84;
    }
  if (self.cnt == 3) {
    self.frame = 93;
    }
  if (self.cnt == 4) {
    self.frame = 102;
    }
  if (self.cnt == 5) {
    self.frame = 17;
    }
  if (self.cnt == 6) {
    self.frame = 28;
    }
  if (self.cnt == 7) {
    self.frame = 22;
    }
  if (self.cnt == 8) {
    self.frame = 85;
    }
  self.use = corpsesplat;
}

Void function corpsesplat();
{
  if (random() < 0.5) {
    sound(self, CHAN_VOICE, "player/gib.wav", 1, ATTN_NONE);
    }
  else {
    sound(self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NONE);
    }
  ThrowGib("progs/gib1.mdl", self.health);
  ThrowGib("progs/gib2.mdl", self.health);
  ThrowGib("progs/gib3.mdl", self.health);
  ThrowHead("progs/h_player.mdl", self.health);
  self.use = Sub_Null;
}

Void function spikeshooter_use();
{
  if (self.spawnflags & SPAWNFLAG_LASER) {
    sound(self, CHAN_VOICE, "enforcer/enfire.wav", 1, ATTN_NORM);
    LaunchLaser(self.origin, self.movedir);
    }
  else {
    if (self.spawnflags & SPAWNFLAG_ROCKET) {
      sound(self, CHAN_VOICE, "weapons/sgun1.wav", 1, ATTN_NORM);
      launch_rocket(self.origin, self.movedir);
      }
    else {
      sound(self, CHAN_VOICE, "weapons/spike2.wav", 1, ATTN_NORM);
      launch_spike(self.origin, self.movedir);
      newmis.velocity = self.movedir * 500;
      if (self.spawnflags & SPAWNFLAG_SUPERSPIKE) {
        newmis.touch = superspike_touch;
        }
      }
    }
}

Void function shooter_think();
{
  spikeshooter_use();
  self.nextthink = time + self.wait;
  newmis.velocity = self.movedir * 500;
}

Void function trap_spikeshooter();
{
  self.event = "realfire";
  SetMovedir();
  self.use = spikeshooter_use;
  if (self.spawnflags & SPAWNFLAG_LASER) {
    precache_model2("progs/laser.mdl");
    precache_sound2("enforcer/enfire.wav");
    precache_sound2("enforcer/enfstop.wav");
    }
  else {
    precache_sound("weapons/spike2.wav");
    }
}

Void function trap_shooter();
{
  self.event = "realfire";
  trap_spikeshooter();
  if (self.wait == 0) {
    self.wait = 1;
    }
  self.nextthink = self.nextthink + self.wait + self.ltime;
  self.think = shooter_think;
}

Void function air_bubbles();
{
  if (deathmatch) {
    remove(self);
    exit;
    }
  precache_model("progs/s_bubble.spr");
  self.nextthink = time + 1;
  self.think = make_bubbles;
}

Void function make_bubbles();
var
 bubble : Object;
{
  bubble = spawn();
  setmodel(bubble, "progs/s_bubble.spr");
  setorigin(bubble, self.origin);
  bubble.movetype = MOVETYPE_NOCLIP;
  bubble.solid = SOLID_NOT;
  bubble.velocity = [0 0 15];
  bubble.nextthink = time + 0.5;
  bubble.think = bubble_bob;
  bubble.touch = bubble_remove;
  bubble.classname = "bubble";
  bubble.frame = 0;
  bubble.cnt = 0;
  setsize(bubble, [-8 -8 -8], [8 8 8]);
  self.nextthink = time + random() + 0.5;
  self.think = make_bubbles;
}

Void function bubble_split();
var
 bubble : Object;
{
  bubble = spawn();
  setmodel(bubble, "progs/s_bubble.spr");
  setorigin(bubble, self.origin);
  bubble.movetype = MOVETYPE_NOCLIP;
  bubble.solid = SOLID_NOT;
  bubble.velocity = self.velocity;
  bubble.nextthink = time + 0.5;
  bubble.think = bubble_bob;
  bubble.touch = bubble_remove;
  bubble.classname = "bubble";
  bubble.frame = 1;
  bubble.cnt = MOVETYPE_BOUNCE;
  setsize(bubble, [-8 -8 -8], [8 8 8]);
  self.frame = 1;
  self.cnt = MOVETYPE_BOUNCE;
  if (self.waterlevel != MOVETYPE_WALK) {
    remove(self);
    }
}

Void function bubble_remove();
{
  if (other.classname == self.classname) {
    exit;
    }
  remove(self);
}

Void function bubble_bob();
var
 rnd1 : Real;
 rnd2 : Real;
 rnd3 : Real;
 vtmp1 : Vector;
 modi : Vector;
{
  self.cnt = self.cnt + 1;
  if (self.cnt == MOVETYPE_STEP) {
    bubble_split();
    }
  if (self.cnt == 20) {
    remove(self);
    }
  rnd1 = self.velocity_x + (-10 + random() * 20);
  rnd2 = self.velocity_y + (-10 + random() * 20);
  rnd3 = self.velocity_z + MOVETYPE_BOUNCE + random() * MOVETYPE_BOUNCE;
  if (rnd1 > MOVETYPE_BOUNCE) {
    rnd1 = MOVETYPE_FLY;
    }
  if (rnd1 < -10) {
    rnd1 = CONTENT_LAVA;
    }
  if (rnd2 > MOVETYPE_BOUNCE) {
    rnd2 = MOVETYPE_FLY;
    }
  if (rnd2 < -10) {
    rnd2 = CONTENT_LAVA;
    }
  if (rnd3 < MOVETYPE_BOUNCE) {
    rnd3 = 15;
    }
  if (rnd3 > SVC_INTERMISSION) {
    rnd3 = 25;
    }
  self.velocity_x = rnd1;
  self.velocity_y = rnd2;
  self.velocity_z = rnd3;
  self.nextthink = time + 0.5;
  self.think = bubble_bob;
}

Void function viewthing();
{
  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_NOT;
  precache_model("progs/player.mdl");
  setmodel(self, "progs/player.mdl");
}

Void function func_wall_use();
{
  self.frame = 1 - self.frame;
}

Void function func_wall();
{
  self.angles = VEC_ORIGIN;
  self.movetype = MOVETYPE_PUSH;
  self.solid = SOLID_BSP;
  self.use = func_wall_use;
  setmodel(self, self.model);
}

Void function func_illusionary();
{
  self.angles = VEC_ORIGIN;
  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_NOT;
  setmodel(self, self.model);
  if (self.alpha == 0) {
    makestatic();
    }
}

Void function func_episodegate();
{
  if (!(serverflags & self.spawnflags)) {
    exit;
    }
  self.angles = VEC_ORIGIN;
  self.movetype = MOVETYPE_PUSH;
  self.solid = SOLID_BSP;
  self.use = func_wall_use;
  setmodel(self, self.model);
}

Void function func_bossgate();
{
  if ((serverflags & 15) == 15) {
    exit;
    }
  self.angles = VEC_ORIGIN;
  self.movetype = MOVETYPE_PUSH;
  self.solid = SOLID_BSP;
  self.use = func_wall_use;
  setmodel(self, self.model);
}

Void function ambient_suck_wind();
{
  precache_sound("ambience/suck1.wav");
  ambientsound(self.origin, "ambience/suck1.wav", 1, ATTN_STATIC);
  remove(self);
}

Void function ambient_fan_blowing();
{
  precache_sound("ambience/fanblow.wav");
  ambientsound(self.origin, "ambience/fanblow.wav", 1, ATTN_STATIC);
  remove(self);
}

Void function ambient_drone();
{
  precache_sound("ambience/drone6.wav");
  ambientsound(self.origin, "ambience/drone6.wav", 0.5, ATTN_STATIC);
  remove(self);
}

Void function ambient_flouro_buzz();
{
  precache_sound("ambience/buzz1.wav");
  ambientsound(self.origin, "ambience/buzz1.wav", 1, ATTN_STATIC);
  remove(self);
}

Void function ambient_drip();
{
  precache_sound("ambience/drip1.wav");
  ambientsound(self.origin, "ambience/drip1.wav", 0.5, ATTN_STATIC);
  remove(self);
}

Void function ambient_comp_hum();
{
  precache_sound("ambience/comp1.wav");
  ambientsound(self.origin, "ambience/comp1.wav", 1, ATTN_STATIC);
  remove(self);
}

Void function ambient_light_buzz();
{
  precache_sound("ambience/fl_hum1.wav");
  ambientsound(self.origin, "ambience/fl_hum1.wav", 0.5, ATTN_STATIC);
  remove(self);
}

Void function ambient_swamp1();
{
  precache_sound("ambience/swamp1.wav");
  ambientsound(self.origin, "ambience/swamp1.wav", 0.5, ATTN_STATIC);
}

Void function ambient_swamp2();
{
  precache_sound("ambience/swamp2.wav");
  ambientsound(self.origin, "ambience/swamp2.wav", 0.5, ATTN_STATIC);
}

Void function ambient_swamp3();
{
  precache_sound("ambience/swamp3.wav");
  ambientsound(self.origin, "ambience/swamp3.wav", 1, ATTN_STATIC);
}

Void function noise_think();
{
  self.nextthink = time + 0.5;
  sound(self, 1, "enforcer/enfire.wav", 1, ATTN_NORM);
  sound(self, FL_SWIM, "enforcer/enfstop.wav", 1, ATTN_NORM);
  sound(self, MOVETYPE_WALK, "enforcer/sight1.wav", 1, ATTN_NORM);
  sound(self, MOVETYPE_STEP, "enforcer/sight2.wav", 1, ATTN_NORM);
  sound(self, MOVETYPE_FLY, "enforcer/sight3.wav", 1, ATTN_NORM);
  sound(self, MOVETYPE_TOSS, "enforcer/sight4.wav", 1, ATTN_NORM);
  sound(self, MOVETYPE_PUSH, "enforcer/pain1.wav", 1, ATTN_NORM);
}

Void function misc_noisemaker();
{
  precache_sound2("enforcer/enfire.wav");
  precache_sound2("enforcer/enfstop.wav");
  precache_sound2("enforcer/sight1.wav");
  precache_sound2("enforcer/sight2.wav");
  precache_sound2("enforcer/sight3.wav");
  precache_sound2("enforcer/sight4.wav");
  precache_sound2("enforcer/pain1.wav");
  precache_sound2("enforcer/pain2.wav");
  precache_sound2("enforcer/death1.wav");
  precache_sound2("enforcer/idle1.wav");
  self.nextthink = time + 0.1 + random();
  self.think = noise_think;
}

Void function ambient_secj();
{
  precache_sound("ambience/secj.wav");
  self.think = play_secj;
  self.nextthink = time + 0.5;
}

Void function play_secj();
{
  sound(self, CHAN_AUTO, "ambience/secj.wav", 1, ATTN_NONE);
  self.think = play_secj;
  self.nextthink = time + 25;
}

Void function ambient_toggle();
{
  if (self.delay < 1) {
    self.delay = 5;
    }
  if (self.wait < 1) {
    self.wait = 1;
    }
  precache_sound(self.noise);
  precache_sound(self.noise1);
  precache_sound(self.noise2);
  precache_sound(self.noise3);
  precache_sound(self.noise4);
  self.event = "";
  self.think = toggle_ambiences;
  self.nextthink = time + 1;
}

Void function toggle_ambiences();
var
 num : Real;
{
  num = self.wait * random();
  pick_ambience();
  if (self.impulse == 1) {
    sound(self, CHAN_AUTO, self.event, 1, ATTN_NONE);
    }
  else {
    sound(self, CHAN_AUTO, self.event, 1, ATTN_IDLE);
    }
  self.think = toggle_ambiences;
  self.nextthink = time + self.delay + num;
}

Void function pick_ambience();
var
 t : Real;
{
  t = random();
  if (t < 0.2) {
    self.event = self.noise;
    }
  else {
    if (t < 0.4) {
      self.event = self.noise1;
      }
    else {
      if (t < 0.6) {
        self.event = self.noise2;
        }
      else {
        if (t < 0.8) {
          self.event = self.noise3;
          }
        else {
          self.event = self.noise4;
          }
        }
      }
    }
}

Void function ambient_sound();
{
  if (!(self.noise)) {
    remove(self);
    exit;
    }
  if (!(self.volume)) {
    self.volume = 0.5;
    }
  precache_sound(self.noise);
  ambientsound(self.origin, self.noise, self.volume, ATTN_STATIC);
}

Void function ambient_global();
{
  if (!(self.noise)) {
    remove(self);
    exit;
    }
  precache_sound(self.noise);
  ambientsound(self.origin, self.noise, 1, ATTN_NONE);
  remove(self);
}

Void function ambient_zzxzz();
{
  precache_sound("ambience/flash.wav");
  ambientsound(self.origin, "ambience/flash.wav", 1, ATTN_STATIC);
  remove(self);
}

Void function ambient_sizzle();
{
  ambientsound(self.origin, "ambience/amsizl.wav", 0.5, ATTN_STATIC);
  remove(self);
}

Void function ambient_drain();
{
  precache_sound("ambience/drain.wav");
  ambientsound(self.origin, "ambience/drain.wav", 0.5, ATTN_STATIC);
  remove(self);
}

Void function ambient_humming();
{
  precache_sound("ambience/maydn.wav");
  ambientsound(self.origin, "ambience/maydn.wav", 1, ATTN_STATIC);
  remove(self);
}

Void function ambient_sphum();
{
  precache_sound("ambience/sphum.wav");
  ambientsound(self.origin, "ambience/sphum.wav", 1, ATTN_STATIC);
  remove(self);
}

Void function ambient_machines();
{
  precache_sound("ambience/begths.wav");
  ambientsound(self.origin, "ambience/begths.wav", 1, ATTN_STATIC);
  remove(self);
}

Void function ambient_factory();
{
  precache_sound("ambience/factory.wav");
  ambientsound(self.origin, "ambience/factory.wav", 1, ATTN_STATIC);
  remove(self);
}

Void function ambient_whnoise();
{
  precache_sound("ambience/whn.wav");
  ambientsound(self.origin, "ambience/whn.wav", 1, ATTN_STATIC);
  remove(self);
}

Void function ambient_nehum();
{
  precache_sound("ambience/filt.wav");
  ambientsound(self.origin, "ambience/filt.wav", 1, ATTN_STATIC);
  remove(self);
}

Void function ambient_moor();
{
  precache_sound("ambience/bush.wav");
  ambientsound(self.origin, "ambience/bush.wav", 1, ATTN_STATIC);
  remove(self);
}

Void function ambient_eerie();
{
  precache_sound("ambience/rych1.wav");
  ambientsound(self.origin, "ambience/rych1.wav", 1, ATTN_STATIC);
  remove(self);
}

Void function ambient_rain();
{
  precache_sound("ambience/rain.wav");
  ambientsound(self.origin, "ambience/rain.wav", 1, ATTN_STATIC);
  remove(self);
}

Void function ambient_flies();
{
  precache_sound("ambience/bugs.wav");
  ambientsound(self.origin, "ambience/bugs.wav", 1, ATTN_STATIC);
  remove(self);
}

Void function play_sound_looped();
{
  precache_sound(self.noise);
  if (self.volume == 0 || self.volume > 1) {
    self.volume = 1;
    }
  if (self.wait == 0) {
    bprint("PLAY_SOUND_LOOPED, no 'wait' field set|");
    remove(self);
    exit;
    }
  if (self.targetname) {
    if (self.cnt == 1) {
      self.use = start_loopsnd;
      exit;
      }
    else {
      self.use = stop_loopsnd;
      }
    }
  self.think = playloopsnd;
  self.nextthink = time + self.wait;
}

Void function playloopsnd();
{
  sound(self, CHAN_AUTO, self.noise, self.volume, ATTN_IDLE);
  self.think = playloopsnd;
  self.nextthink = time + self.cnt;
}

Void function start_loopsnd();
{
  self.use = stop_loopsnd;
  playloopsnd();
}

Void function stop_loopsnd();
{
  self.use = start_loopsnd;
  self.think = Sub_null;
  self.nextthink = time + 9999;
}

Void function play_sound_use();
{
  if (self.target) {
    Sub_UseTargets();
    }
  if (self.spawnflags & 1) {
    if (self.state == 0) {
      self.state = 1;
      sound(self, self.impulse, self.noise, self.volume, self.speed);
      }
    else {
      self.state = 0;
      sound(self, self.impulse, "misc/null.wav", self.volume, self.speed);
      }
    }
  else {
    sound(self, self.impulse, self.noise, self.volume, self.speed);
    }
}

Void function PlaySoundThink();
var
 T : Real;
{
  T = self.wait * random();
  if (T < self.delay) {
    T = self.delay;
    }
  self.nextthink = time + T;
  play_sound_use();
}

Void function play_sound_triggered();
{
  precache_sound(self.noise);
  precache_sound("misc/null.wav");
  if (self.volume == 0) {
    self.volume = 1;
    }
  if (self.speed == 0) {
    self.speed = 1;
    }
  if (self.speed == -1) {
    self.speed = 0;
    }
  if (self.spawnflags & 1) {
    if (self.impulse == 0) {
      self.impulse = 7;
      }
    }
  self.use = play_sound_use;
}

Void function play_sound();
var
 T : Real;
{
  play_sound_triggered();
  if (self.wait == 0) {
    self.wait = 20;
    }
  if (self.delay == 0) {
    self.delay = 2;
    }
  self.think = PlaySoundThink;
  T = self.wait * random();
  if (T < self.delay) {
    T = self.delay;
    }
  self.nextthink = time + T;
}

Void function Seekoutwall();
var
 blah : Object;
{
  blah = find(world, classname, "func_quakedmg");
  if (blah == world) {
    exit;
    }
  T_Damage(blah, self, self.owner, 7000);
}

Void function thunder_go_boom();
{
  if (random() < 0.5) {
    sound(self, CHAN_AUTO, "ambience/thunder1.wav", 0.5, ATTN_NONE);
    }
  else {
    sound(self, CHAN_AUTO, "ambience/thunder2.wav", 0.5, ATTN_NONE);
    self.think = thunder_go_boom;
    self.nextthink = time + 20 * random();
    }
}

Void function ambient_thunder();
{
  precache_sound("ambience/thunder1.wav");
  precache_sound("ambience/thunder2.wav");
  self.think = thunder_go_boom;
  self.nextthink = time + random();
}

Void function floating_gibs();
{
  self.cnt = 0;
  if (self.delay < 1) {
    self.delay = 10;
    }
  if (self.count < 1) {
    self.count = 3;
    }
  if (self.targetname) {
    self.use = trigger_gibs;
    exit;
    }
  self.think = fgib_spawn;
  self.nextthink = time + self.delay;
}

Void function fgib_touch();
var
 v : Vector;
{
  if (other.classname != "player") {
    exit;
    }
  self.velocity_x = other.velocity_x + 10 * random();
  self.velocity_y = other.velocity_y + 10 * random();
  if (other.velocity_z < 0) {
    self.velocity_z = other.velocity_z * 0.5;
    }
}

Void function spawn_fgib(gibname : String; dm : Real);
var
 fgib : Object;
{
  fgib = spawn();
  fgib.origin = self.origin;
  setmodel(fgib, gibname);
  setsize(self, [-16 -16 0], [16 16 56]);
  fgib.velocity = VelocityForDamage(dm);
  fgib.classname = "fgib";
  fgib.takedamage = DAMAGE_AIM;
  fgib.health = 20;
  fgib.avelocity_x = random() * 3;
  fgib.avelocity_y = random() * 3;
  fgib.avelocity_z = random() * 3;
  fgib.movetype = MOVETYPE_FLYMISSILE;
  fgib.solid = SOLID_BBOX;
  fgib.touch = fgib_touch;
  fgib.think = fgib_think;
  fgib.nextthink = time + 0.1;
  fgib.th_die = fgib_die;
  setorigin(fgib, self.origin);
}

Void function fgib_think();
var
 spot : Vector;
 spot2 : Vector;
{
  self.touch = fgib_touch;
  spot = self.origin + [0 0 4];
  spot2 = self.origin + [0 0 2];
  if (pointcontents(spot) == CONTENT_EMPTY) {
    self.velocity_z = -10;
    }
  else {
    if (pointcontents(spot) == CONTENT_WATER || pointcontents(spot) == CONTENT_SLIME || pointcontents(spot2) == CONTENT_SOLID) {
      self.velocity_z = 10;
      }
    else {
      if (pointcontents(spot) == CONTENT_EMPTY) {
        if (pointcontents(spot2) == CONTENT_WATER || pointcontents(spot2) == CONTENT_SLIME) {
          self.velocity_x = rint(2 * random());
          self.velocity_y = rint(2 * random());
          if (random() < 0.5) {
            self.velocity_x = self.velocity_x * -1;
            }
          else {
            self.velocity_y = self.velocity_y * -1;
            }
          if (self.velocity_z != 0) {
            self.velocity_z = 0;
            }
          }
        }
      }
    }
  if (random() < 0.3){
    self.angles_y = self.angles_y - 1;
    }
  else {
    self.angles_y = self.angles_y + 1;
    }
  Sub_Normalizeangles(self.angles);
  self.think = fgib_think;
  self.nextthink = time + 0.1;
}

Void function trigger_gibs();
{
  self.use = SUB_Null;
  self.think = fgib_spawn;
  self.nextthink = time + self.delay;
}

Void function fgib_spawn();
var
 t : Real;
{
  t = random();
  if (t < 0.2) {
    spawn_fgib("progs/fgib1.mdl", random() * -100);
    }
  else {
    if (t < 0.6) {
      spawn_fgib("progs/fgib2.mdl", random() * -100);
      }
    else {
      spawn_fgib("progs/fgib3.mdl", random() * -100);
      }
    }
  self.cnt = self.cnt + 1;
  if (self.cnt > self.count) {
    remove(self);
    exit;
    }
  self.think = fgib_spawn;
  self.nextthink = time + self.delay;
}

Void function fgib_die();
{
  ThrowGib("progs/zom_gib.mdl", self.health);
  ThrowGib("progs/zom_gib.mdl", self.health);
  ThrowGib("progs/zom_gib.mdl", self.health);
  remove(self);
}

Void function misc_motel();
{
  precache_model("progs/motel.mdl");
  setmodel(self, "progs/motel.mdl");
  setsize(self, VEC_HULL2_MIN, VEC_HULL2_MAX);
  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_SLIDEBOX;
}

Void function misc_sign();
{
  precache_model("progs/route.mdl");
  setmodel(self, "progs/route.mdl");
  setsize(self, VEC_HULL_MIN, [10 10 45]);
  self.movetype = MOVETYPE_NONE;
  if (self.frame == 0) {
    if (self.cnt == 1) {
      self.solid = SOLID_TRIGGER;
      }
    else {
      self.solid = SOLID_SLIDEBOX;
      }
    exit;
    }
  self.solid = SOLID_NOT;
}

Void function misc_tree();
{
  if (!(self.model)) {
    self.model = "progs/tree1.mdl";
    }
  if (self.model == "progs/tree1.mdl") {
    self.frame = 0;
    }
  precache_model(self.model);
  setmodel(self, self.model);
  setsize(self, VEC_HULL_MIN, [10 10 45]);
  self.movetype = MOVETYPE_NONE;
  if (self.cnt == 1) {
    self.solid = SOLID_NOT;
    }
  else {
    self.solid = SOLID_SLIDEBOX;
    }
}

Void function misc_vend();
var
 oldz : Real;
{
  self.solid = SOLID_BBOX;
  self.movetype = MOVETYPE_NONE;
  precache_model("progs/frubble1.mdl");
  precache_model("progs/frubble2.mdl");
  precache_model("progs/frubble3.mdl");
  precache_model("progs/vending.mdl");
  setmodel(self, "progs/vending.mdl");
  setsize(self, [-20 -27 -26], [20 29 60]);
  precache_sound("weapons/r_exp3.wav");
  self.health = 40;
  self.th_die = vend_blows;
  self.takedamage = DAMAGE_AIM;
  self.origin_z = self.origin_z + FL_SWIM;
  oldz = self.origin_z;
  droptofloor();
  if (oldz - self.origin_z > 250) {
    dprint("vending machine fell out of level at ");
    dprint(vtos(self.origin));
    dprint("|");
    remove(self);
    }
}

Void function vend_blows();
{
  WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
  WriteByte(MSG_BROADCAST, TE_EXPLOSION3);
  WriteCoord(MSG_BROADCAST, self.origin_x);
  WriteCoord(MSG_BROADCAST, self.origin_y);
  WriteCoord(MSG_BROADCAST, self.origin_z);
  WriteCoord(MSG_BROADCAST, 1.0);
  WriteCoord(MSG_BROADCAST, 0.4);
  WriteCoord(MSG_BROADCAST, 0.2);
  ThrowRubble("progs/frubble1.mdl", self.health);
  ThrowRubble("progs/frubble2.mdl", self.health);
  ThrowRubble("progs/frubble1.mdl", self.health);
  ThrowRubble("progs/frubble2.mdl", self.health);
  ThrowRubble("progs/frubble3.mdl", self.health);
  BecomeExplosion();
}

Void function misc_fscreen();
{
  precache_sound("forge/alarm.wav");
  precache_sound("sets/set2_4.wav");
  precache_model("progs/fscreen.mdl");
  setmodel(self, "progs/fscreen.mdl");
  setsize(self, VEC_HULL_MIN, [10 10 45]);
  self.movetype = MOVETYPE_NONE;
  self.solid = SOLID_NOT;
  self.use = fscreen_trigger1;
  self.think = fscreen_think;
  self.nextthink = time + 1;
}

Void function fscreen_think();
{
  if (self.skin == 0) {
    self.skin = 1;
    }
  else {
    self.skin = 0;
    }
  self.think = fscreen_think;
  self.nextthink = time + 1;
}

Void function fscreen_trigger1();
{
  Sub_UseTargets();
  sound(self, CHAN_AUTO, "sets/set2_4.wav", 1, ATTN_NONE);
  self.use = fscreen_trigger2;
  self.think = fscreen_think2;
  self.nextthink = time + 0.5;
}

Void function fscreen_think2();
{
  if (self.skin == 3) {
    self.skin = 1;
    }
  else {
    self.skin = 3;
    }
  if (self.pain_finished > time) {
    self.think = fscreen_think2;
    self.nextthink = time + 0.5;
    exit;
    }
  sound(self, CHAN_AUTO, "forge/alarm.wav", 1, ATTN_NORM);
  self.pain_finished = time + 1;
  self.think = fscreen_think2;
  self.nextthink = time + 0.5;
}

Void function fscreen_trigger2();
{
  self.use = Sub_null;
  self.think = fscreen_error;
  self.nextthink = time + 0.7;
}

Void function fscreen_error();
{
  if (self.skin == 1) {
    self.skin = 2;
    }
  else {
    self.skin = 1;
    }
  if (self.pain_finished > time) {
    self.think = fscreen_error;
    self.nextthink = time + 0.7;
    exit;
    }
  sound(self, CHAN_AUTO, "forge/alarm.wav", 1, ATTN_NORM);
  self.pain_finished = time + 1;
  self.think = fscreen_error;
  self.nextthink = time + 0.7;
}

Void function misc_valve();
{
  precache_sound("forge/turnme.wav");
  if (!(self.target)) {
    bprint("MISC_VALVE NEEDS A TARGET|");
    }
  precache_model("progs/valve.mdl");
  setmodel(self, "progs/valve.mdl");
  self.movetype = MOVETYPE_NOCLIP;
  self.solid = SOLID_TRIGGER;
  self.frame = 0;
  self.cnt = 0;
  self.origin = self.origin - [0 0 10];
  self.touch = valve_turn;
  setsize(self, [-16 -16 0], [16 16 56]);
}

Void function valve_turn();
{
  if (other.classname != "player") {
    exit;
    }
  self.cnt = self.cnt + 1;
  if (self.cnt > 50) {
    Sub_UseTargets();
    self.touch = Sub_null;
    exit;
    }
  self.origin_z = self.origin_z + 0.2;
  self.frame = self.frame + 1;
  if (self.frame > 10) {
    self.frame = 0;
    }
  if (self.pain_finished > time) {
    exit;
    }
  self.pain_finished = time + 0.3;
  sound(self, CHAN_AUTO, "forge/turnme.wav", 1, ATTN_NORM);
}

Void function misc_car();
var
 oldz : Real;
{
  self.solid = SOLID_BBOX;
  self.movetype = MOVETYPE_STEP;
  precache_model("progs/hummer.mdl");
  setmodel(self, "progs/hummer.mdl");
  setsize(self, [-29 -66 -15], [31 67 41]);
  self.origin_z = self.origin_z + FL_SWIM;
  oldz = self.origin_z;
  droptofloor();
  if (oldz - self.origin_z > 250) {
    dprint("misc_car fell out of level at ");
    dprint(vtos(self.origin));
    dprint("|");
    remove(self);
    }
}


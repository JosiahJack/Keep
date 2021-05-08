Void function trigger_console();
{
  InitTrigger();
  if (!(self.event)) {
    bprint("Trigger Console with no command set in event field|");
    remove(self);
    }
  self.touch = console_send;
}

Void function console_send();
{
  if (other.classname != "player") {
    exit;
    }
  stuffcmd(other, self.event);
  stuffcmd(other, "|");
}

Void function info_idscale();
{
  self.use = trigger_V_IDLES_use;
  if (!(self.message)) {
    dprint("No V_IDLESCALE set in info_idscale|");
    }
}

Void function trigger_V_IDLES_use();
{
  cvar_set("v_idlescale", self.message);
}


Void function info_script();
{
  if (coop || deathmatch) {
    self.message = "";
    self.targetname = "cammies";
    self.use = script_usetargets;
    }
}

Void function script_usetargets();
{
  Sub_UseTargets();
  remove(self);
}

Void function info_camera();
{
  if (coop || deathmatch) {
    remove(self);
    exit;
    }
  self.use = camera_cyclez;
}

Void function info_intermission();
{
  self.use = camera_cyclez;
}

Void function remove_movers();
var
 m : Object;
{
  m = find(world, classname, "info_movecam");
  while (m) {
    if (m.think == come_to_me) {
      remove(m.target);
      remove(m);
      }
    m = find(m, classname, "info_movecam");
    }
}

Void function info_movecam();
{
  if (deathmatch || coop) {
    remove(self);
    exit;
    }
  if (self.speed < 1) {
    self.speed = 1;
    }
  self.use = move_the_camera;
}

Void function move_the_camera();
var
 head : Object;
 s : Object;
{
  head = find(world, classname, "camera");
  if (head == world) {
    exit;
    }
  remove_movers();
  s = spawn();
  s.origin = head.origin;
  setorigin(s, head.origin);
  s.classname == "mover";
  self.enemy = head;
  self.target = s;
  self.think = come_to_me;
  self.nextthink = time + 0.010000;
}

Void function come_to_me();
var
 dave : Vector;
 s : Object;
 cam : Object;
{
  dave = self.enemy.origin - self.origin;
  if (vlen(dave) < 10) {
    remove(self.target);
    remove(self);
    exit;
    }
  s = self.target;
  cam = self.enemy;
  if (s.origin_x < self.origin_x) {
    s.origin_x = s.origin_x + self.speed;
    }
  if (s.origin_x > self.origin_x) {
    s.origin_x = s.origin_x - self.speed;
    }
  if (s.origin_y < self.origin_y) {
    s.origin_y = s.origin_y + self.speed;
    }
  if (s.origin_y > self.origin_y) {
    s.origin_y = s.origin_y - self.speed;
    }
  if (s.origin_z < self.origin_z) {
    s.origin_z = s.origin_z + self.speed;
    }
  if (s.origin_z > self.origin_z) {
    s.origin_z = s.origin_z - self.speed;
    }
  cam.origin = s.origin;
  setorigin(cam, s.origin);
  self.think = come_to_me;
  self.nextthink = time + 0.010000;
}

Void function camera_cyclez();
var
 head : Object;
{
  head = find(world, classname, "camera");
  if (head == world) {
    exit;
    }
  head.enemy = self;
  head.velocity = VEC_ORIGIN;
  head.view_ofs = VEC_ORIGIN;
  head.angles = self.mangle;
  head.origin = self.origin;
  setorigin(head, self.origin);
}

Void function spawn_dummy(o : Object);
var
 s : Object;
{
  if (deathmatch || coop) {
    exit;
    }
  s = spawn();
  s.origin = o.origin;
  s.velocity = o.velocity;
  s.angles = o.angles;
  s.health = o.health;
  s.weapon = o.weapon;
  s.classname = "dummy";
  s.movetype = MOVETYPE_NONE;
  s.solid = SOLID_NOT;
  s.weaponmodel = o.weaponmodel;
  s.flags = o.flags;
  s.skin = o.skin;
  setorigin(s, o.origin);
  setmodel(s, o.model);
  s.frame = 12;
  s.think = dummy_stand;
  s.nextthink = time + 0.1;
}

Void function dummy_stand();
{
  #12 dummy_stand2;
}

Void function dummy_stand2();
{
  #13 dummy_stand3;
}

Void function dummy_stand3();
{
  #14 dummy_stand4;
}

Void function dummy_stand4();
{
  #15 dummy_stand5;
}

Void function dummy_stand5();
{
  #16 dummy_stand;
}

Void function name_player();
var
 play : Object;
{
  play = find(world, classname, "camera");
  play.classname = "player";
  stuffcmd(play, "-forward|");
}

Void function go_back();
var
 t : Object;
 c : Object;
 d : Object;
 org : Vector;
 val : String;
{
  if (deathmatch || coop) {
    remove(self);
    }
  t = find(world, classname, "dummy");
  if (!t) {
    dprint("couldn't find dummy");
    exit;
    }
  c = find(world, classname, "camera");
  if (!c) {
    dprint("couldn't find camera");
    exit;
    }
  remove_movers();
  setorigin(c, t.origin);
  c.velocity = t.velocity;
  c.view_ofs = [0 0 22];
  c.angles_x = t.angles_x;
  c.angles_y = t.angles_y;
  c.angles_z = 0;
  c.health = t.health;
  c.weapon = t.weapon;
  c.weaponmodel = t.weaponmodel;
  c.weaponframe = 0;
  c.flags = t.flags;
  c.fixangle = 1;
  c.takedamage = DAMAGE_AIM;
  c.solid = SOLID_SLIDEBOX;
  c.movetype = MOVETYPE_WALK;
  c.think = player_stand1;
  c.air_finished = time + 12;
  stuffcmd(c, "v_cshift 0 0 0 0|");
  d = spawn();
  d.nextthink = time + 0.1;
  d.think = name_player;
  val = ftos(c.cnt);
  cvar_set("viewsize", val);
  val = ftos(c.blink);
  cvar_set("chase_active", val);
  cvar_set("v_idlescale", "0");
  t.nextthink = time + 0.1;
  t.think = SUB_Remove;
  remove(self);
}

Void function look_ahead();
{
  self.angles = self.enemy.mangle;
  self.fixangle = 1;
  self.nextthink = time + 0.010000;
}

Void function go_camera();
{
  self.classname = "camera";
  self.velocity = VEC_ORIGIN;
  self.view_ofs = VEC_ORIGIN;
  self.angles = self.enemy.mangle;
  self.fixangle = 1;
  self.movetype = MOVETYPE_NONE;
  self.takedamage = DAMAGE_NO;
  self.solid = SOLID_NOT;
  self.weaponmodel = "";
  self.nextthink = time + 0.050000;
  self.think = look_ahead;
  if (!(self.script)) {
    dprint("trigger_camera needs a script number");
    }
  self.script_count = 0;
  self.cnt = cvar("viewsize");
  self.blink = cvar("chase_active");
  cvar_set("chase_active", "0");
  cvar_set("viewsize", "120");
  cvar_set("v_idlescale", "0");
  setorigin(self, self.enemy.origin);
}

Void function camera_use();
var
 head : Object;
{
  head = find(world, classname, "player");
  if (head == world) {
    bprint("No player found!|");
    exit;
    }
  if (head.health <= 0) {
    dprint("Player dead|");
    exit;
    }
  self.enemy = head;
  self.nextthink = time + self.delay;
  self.think = activate_cutscene;
}

Void function trigger_camera();
{
  InitTrigger();
  if (coop || deathmatch) {
    self.target = "cammies";
    self.use = script_usetargets;
    self.touch = camerap_touch;
    exit;
    }
  self.touch = camera_touch;
  if (!(self.target)) {
    objerror("no target");
    }
  self.use = camera_use;
}

Void function camerap_touch();
var
 t : Object;
{
  if (other.health <= 0 || other.classname != "player") {
    exit;
    }
  script_usetargets();
}

Void function Script_play();
var
 scrpt : Object;
 temp : Object;
{
  scrpt = find(world, script_num, self.script);
  if (!scrpt) {
    dprint("Error: script not found!");
    }
  if (scrpt.target) {
    temp = self;
    self = scrpt;
    SUB_UseTargets();
    self.target = string_null;
    self = temp;
    }
  self.script_delay = scrpt.script_delay;
  self.script_time = time + 1;
  self.script_count = self.script_count + 1;
  centerprint(self, scrpt.message);
  if (self.script_count == self.script_delay) {
    self.script = scrpt.next_script;
    if (self.script != "0") {
      self.script_count = 0;
      }
    else {
      scrpt.nextthink = time + MOVETYPE_STEP;
      scrpt.think = go_back;
      }
    }
  exit;
}

Void function big_bang();
var
 newo : Vector;
 x : Real;
 y : Real;
 z : Real;
{
  if (self.wait == 1) {
    sound(self, CHAN_VOICE, "boss2/pop2.wav", 1, ATTN_NONE);
    }
  x = random() * FL_NOTARGET - FL_GODMODE;
  y = random() * FL_NOTARGET - FL_GODMODE;
  z = random() * FL_NOTARGET - FL_GODMODE;
  newo_x = self.origin_x + x;
  newo_y = self.origin_y + y;
  newo_z = self.origin_z + z;
  WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
  WriteByte(MSG_BROADCAST, TE_EXPLOSION);
  WriteCoord(MSG_BROADCAST, newo_x);
  WriteCoord(MSG_BROADCAST, newo_y);
  WriteCoord(MSG_BROADCAST, newo_z);
  self.wait = self.wait - 1;
  if (self.wait < 0) {
    remove(self);
    }
  self.nextthink = time + 0.2 * random() + 0.1;
  self.think = big_bang;
}

Void function misc_boom();
{
  precache_sound2("boss2/pop2.wav");
  self.use = big_bang;
}

Void function info_angle();
{
  dprint("There is no info_angle!!!!  Only Zuuuuul!!!!!!!!|");
}

Void function camera_touch();
var
 t : Object;
{
  if (self.targetname) {
    if (self.nextthink < time) {
      exit;
      }
    }
  if (other.health <= 0 || other.classname != "player" || self.cnt == CONTENT_EMPTY) {
    exit;
    }
  self.enemy = other;
  self.nextthink = time + self.delay;
  self.think = activate_cutscene;
}

Void function activate_cutscene();
var
 t : Object;
{
  ResetEnemies(self.enemy);
  SUB_UseTargets();
  if (self.enemy.flags & FL_ONGROUND) {
    self.enemy.flags = self.enemy.flags - FL_ONGROUND;
    }
  if (self.targetname == "xnehahra_finale") {
    spawn_dummy_finale(self.enemy);
    }
  else {
    spawn_dummy(self.enemy);
    }
  t = find(world, targetname, self.target);
  if (!t) {
    error("couldn't find target");
    }
  self.enemy.enemy = t;
  self.enemy.script = self.script;
  self.enemy.script_delay = self.script_delay;
  if (!(deathmatch)) {
    if (!(coop)) {
      self.enemy.nextthink = time + 0.050000;
      self.enemy.think = go_camera;
      }
    }
  self.cnt = CONTENT_EMPTY;
  self.nextthink = time + 0.1;
  self.think = SUB_Remove;
}

Void function info_fadeout();
{
  if (self.speed == 0) {
    self.speed = 0.01;
    }
  self.cnt = 0;
  self.use = fade_out_go;
}

Void function info_fadein();
{
  if (self.speed == 0) {
    self.speed = 0.01;
    }
  self.cnt = 255;
  self.use = fade_in_go;
}

Void function fade_in_go();
{
  if (findcamera()) {
    fade_in();
    }
}

Void function fade_out_go();
{
  if (findcamera()) {
    fade_away();
    }
}

Void function findcamera();
var
 head : Object;
{
  head = find(world, classname, "camera");
  if (head == world) {
    return 0;
    }
  else {
    self.enemy = head;
    return 1;
    }
}

Void function fade_in();
{
  fade_v_cshift();
  self.cnt = self.cnt - 5;
  if (self.cnt < 1) {
    stuffcmd(self.enemy, "v_cshift 0 0 0 0");
    self.enemy = world;
    self.nextthink = time + 9999;
    self.think = Sub_null;
    exit;
    }
  self.think = fade_in;
  self.nextthink = time + self.speed;
}

Void function fade_away();
{
  fade_v_cshift();
  self.cnt = self.cnt + 5;
  if (self.cnt > 254) {
    stuffcmd(self.enemy, "v_cshift 0 0 0 255");
    self.enemy = world;
    self.nextthink = time + 9999;
    self.think = Sub_null;
    exit;
    }
  self.think = fade_away;
  self.nextthink = time + self.speed;
}

Void function fade_v_cshift();
{
  stuffcmd(self.enemy, "v_cshift ");
  if (self.spawnflags == 0) {
    stuffcmd(self.enemy, "0 ");
    }
  else {
    stuffcmd(self.enemy, "100 ");
    }
  stuffcmd(self.enemy, "0 0 ");
  stuffcmd(self.enemy, ftos(self.cnt));
  stuffcmd(self.enemy, "|");
}


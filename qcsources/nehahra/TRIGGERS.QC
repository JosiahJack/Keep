Void function trigger_spawnmonster();
{
  if (self.style == 1) {
    spawn_tfog(self.origin);
    }
  spawn_tdeath(self.origin, self);
}

Void function trigger_reactivate();
{
  self.solid = SOLID_TRIGGER;
}

Void function multi_wait();
{
  if (self.max_health) {
    self.health = self.max_health;
    self.takedamage = DAMAGE_YES;
    self.solid = SOLID_BBOX;
    }
}

Void function multi_trigger();
{
  if (self.nextthink > time) {
    exit;
    }
  if (self.classname == "trigger_secret") {
    if (self.enemy.classname != "player") {
      exit;
      }
    found_secrets = found_secrets + 1;
    WriteByte(MSG_ALL, SVC_FOUNDSECRET);
    }
  if (self.noise) {
    sound(self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
    }
  self.takedamage = DAMAGE_NO;
  activator = self.enemy;
  SUB_UseTargets();
  if (self.wait > 0) {
    self.think = multi_wait;
    self.nextthink = time + self.wait;
    }
  else {
    self.touch = SUB_Null;
    self.nextthink = time + 0.1;
    self.think = SUB_Remove;
    }
}

Void function multi_killed();
{
  self.enemy = damage_attacker;
  multi_trigger();
}

Void function multi_use();
{
  self.enemy = activator;
  multi_trigger();
}

Void function multi_touch();
{
  if (other.classname != "player") {
    exit;
    }
  if (self.movedir != VEC_ORIGIN) {
    makevectors(other.angles);
    if (v_forward * self.movedir < 0) {
      exit;
      }
    }
  self.enemy = other;
  multi_trigger();
}

Void function trigger_multiple();
{
  if (world.model == "maps/neh1m1.bsp" && deathmatch) {
    self.message = "";
    }
  if (self.sounds == 1) {
    precache_sound("misc/secret.wav");
    self.noise = "misc/secret.wav";
    }
  else {
    if (self.sounds == FL_SWIM) {
      precache_sound("misc/talk.wav");
      self.noise = "misc/talk.wav";
      }
    else {
      if (self.sounds == MOVETYPE_WALK) {
        precache_sound("misc/trigger1.wav");
        self.noise = "misc/trigger1.wav";
        }
      }
    }
  if (!(self.wait)) {
    self.wait = 0.2;
    }
  self.use = multi_use;
  InitTrigger();
  if (self.health) {
    if (self.spawnflags & SPAWNFLAG_NOTOUCH) {
      objerror("health and notouch don't make sense|");
      }
    self.max_health = self.health;
    self.th_die = multi_killed;
    self.takedamage = DAMAGE_YES;
    self.solid = SOLID_BBOX;
    setorigin(self, self.origin);
    }
  else {
    if (!(self.spawnflags & SPAWNFLAG_NOTOUCH)) {
      self.touch = multi_touch;
      }
    }
}

Void function trigger_once();
{
  if (world.model == "maps/neh1m1.bsp" && deathmatch) {
    self.message = "";
    }
  self.wait = CONTENT_EMPTY;
  trigger_multiple();
}

Void function trigger_relay();
{
  if (world.model == "maps/neh1m1.bsp" && deathmatch) {
    self.message = "";
    }
  self.use = SUB_UseTargets;
}

Void function trigger_secret();
{
  total_secrets = total_secrets + 1;
  self.wait = CONTENT_EMPTY;
  if (!(self.message)) {
    self.message = "You found a secret area!";
    }
  if (!(self.sounds)) {
    self.sounds = 1;
    }
  if (self.sounds == 1) {
    precache_sound("misc/secret.wav");
    self.noise = "misc/secret.wav";
    }
  else {
    if (self.sounds == FL_SWIM) {
      precache_sound("misc/talk.wav");
      self.noise = "misc/talk.wav";
      }
    }
  trigger_multiple();
}

Void function counter_use();
var
 junk : String;
{
  self.count = self.count - 1;
  if (self.count < 0) {
    exit;
    }
  if (self.count != 0) {
    if (activator.classname == "player" && (self.spawnflags & SPAWNFLAG_NOMESSAGE) == 0) {
      if (self.count >= MOVETYPE_STEP) {
        centerprint(activator, "There are more to go...");
        }
      else {
        if (self.count == MOVETYPE_WALK) {
          centerprint(activator, "Only 3 more to go...");
          }
        else {
          if (self.count == FL_SWIM) {
            centerprint(activator, "Only 2 more to go...");
            }
          else {
            centerprint(activator, "Only 1 more to go...");
            }
          }
        }
      }
    exit;
    }
  if (activator.classname == "player" && (self.spawnflags & SPAWNFLAG_NOMESSAGE) == 0) {
    centerprint(activator, "Sequence completed!");
    }
  self.enemy = activator;
  multi_trigger();
}

Void function trigger_counter();
{
  if (world.model == "maps/neh1m1.bsp" && deathmatch) {
    self.message = "";
    }
  self.wait = CONTENT_EMPTY;
  if (!(self.count)) {
    self.count = FL_SWIM;
    }
  self.use = counter_use;
}

Void function play_teleport();
var
 v : Real;
 tmpstr : String;
{
  v = random() * MOVETYPE_FLY;
  if (v < 1) {
    tmpstr = "misc/r_tele1.wav";
    }
  else {
    if (v < FL_SWIM) {
      tmpstr = "misc/r_tele2.wav";
      }
    else {
      if (v < MOVETYPE_WALK) {
        tmpstr = "misc/r_tele3.wav";
        }
      else {
        if (v < MOVETYPE_STEP) {
          tmpstr = "misc/r_tele4.wav";
          }
        else {
          tmpstr = "misc/r_tele5.wav";
          }
        }
      }
    }
  sound(self, CHAN_VOICE, tmpstr, 1, ATTN_NORM);
  remove(self);
}

Void function spawn_tfog(org : Vector);
{
  s = spawn();
  s.origin = org;
  s.nextthink = time + 0.2;
  s.think = play_teleport;
  WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
  WriteByte(MSG_BROADCAST, TE_TELEPORT);
  WriteCoord(MSG_BROADCAST, org_x);
  WriteCoord(MSG_BROADCAST, org_y);
  WriteCoord(MSG_BROADCAST, org_z);
}

Void function tdeath_touch();
{
  if (other == self.owner) {
    exit;
    }
  if (other.classname == "player") {
    if (other.invincible_finished > time) {
      self.classname = "teledeath2";
      }
    if (self.owner.classname != "player" && self.owner.classname != "the_mister") {
      T_Damage(self.owner, self, self, 50000);
      exit;
      }
    }
  if (other.health) {
    T_Damage(other, self, self, 50000);
    }
}

Void function spawn_tdeath(org : Vector; death_owner : Object);
var
 death : Object;
{
  death = spawn();
  death.classname = "teledeath";
  death.movetype = MOVETYPE_NONE;
  death.solid = SOLID_TRIGGER;
  death.angles = VEC_ORIGIN;
  setsize(death, death_owner.mins - [1 1 1], death_owner.maxs + [1 1 1]);
  setorigin(death, org);
  death.touch = tdeath_touch;
  death.nextthink = time + 0.2;
  death.think = SUB_Remove;
  death.owner = death_owner;
  force_retouch = FL_SWIM;
}

Void function teleport_touch();
var
 t : Object;
 org : Vector;
{
  if (other.classname == "the_mister") {
    exit;
    }
  if (self.targetname) {
    if (self.nextthink < time) {
      exit;
      }
    }
  if (self.spawnflags & PLAYER_ONLY) {
    if (other.classname != "player") {
      exit;
      }
    }
  if (other.health <= 0 || other.solid != SOLID_SLIDEBOX) {
    exit;
    }
  SUB_UseTargets();
  spawn_tfog(other.origin);
  t = find(world, targetname, self.target);
  if (!t) {
    objerror("couldn't find target");
    }
  makevectors(t.mangle);
  org = t.origin + FL_MONSTER * v_forward;
  spawn_tfog(org);
  spawn_tdeath(t.origin, other);
  if (!(other.health)) {
    other.origin = t.origin;
    other.velocity = v_forward * other.velocity_x + v_forward * other.velocity_y;
    exit;
    }
  setorigin(other, t.origin);
  other.angles = t.mangle;
  if (other.classname == "player") {
    other.fixangle = 1;
    other.teleport_time = time + 0.7;
    if (other.flags & FL_ONGROUND) {
      other.flags = other.flags - FL_ONGROUND;
      }
    other.velocity = v_forward * 300;
    }
  other.flags = other.flags - (other.flags & FL_ONGROUND);
}

Void function info_teleport_destination();
{
  self.mangle = self.angles;
  self.angles = VEC_ORIGIN;
  self.model = "";
  self.event = "spawn_point";
  self.origin = self.origin + [0 0 27];
  if (!(self.targetname)) {
    objerror("no targetname");
    }
}

Void function teleport_use();
{
  self.nextthink = time + 0.2;
  force_retouch = FL_SWIM;
  self.think = SUB_Null;
}

Void function trigger_teleport();
var
 o : Vector;
{
  InitTrigger();
  self.touch = teleport_touch;
  if (!(self.target)) {
    objerror("no target");
    }
  self.use = teleport_use;
  if (!(self.spawnflags & SILENT)) {
    precache_sound("ambience/hum1.wav");
    o = (self.mins + self.maxs) * 0.5;
    ambientsound(o, "ambience/hum1.wav", 0.5, ATTN_STATIC);
    }
}

Void function trigger_skill_touch();
{
  if (other.classname != "player") {
    exit;
    }
  cvar_set("skill", self.message);
}

Void function trigger_setskill();
{
  InitTrigger();
  self.touch = trigger_skill_touch;
}

Void function trigger_onlyregistered_touch();
{
  if (other.classname != "player") {
    exit;
    }
  if (self.attack_finished > time) {
    exit;
    }
  self.attack_finished = time + FL_SWIM;
  if (cvar("registered")) {
    self.message = "";
    SUB_UseTargets();
    remove(self);
    }
  else {
    if (self.message != "") {
      centerprint(other, self.message);
      sound(other, CHAN_BODY, "misc/talk.wav", 1, ATTN_NORM);
      }
    }
}

Void function trigger_onlyregistered();
{
  precache_sound("misc/talk.wav");
  InitTrigger();
  self.touch = trigger_onlyregistered_touch;
}

Void function hurt_on();
{
  self.solid = SOLID_TRIGGER;
  self.nextthink = CONTENT_EMPTY;
}

Void function hurt_touch();
{
  if (other.takedamage) {
    self.solid = SOLID_NOT;
    T_Damage(other, self, self, self.dmg);
    self.think = hurt_on;
    self.nextthink = time + 1;
    }
  exit;
}

Void function trigger_hurt();
{
  InitTrigger();
  self.touch = hurt_touch;
  if (self.cnt > 0) {
    pain_deathtype();
    }
  if (!(self.dmg)) {
    self.dmg = MOVETYPE_FLY;
    }
}

Void function trigger_push_touch();
{
  if (other.classname == "grenade" || other.classname == "gib" || other.classname == "gren2") {
    other.velocity = self.speed * self.movedir * MOVETYPE_BOUNCE;
    }
  else {
    if (other.health > 0) {
      other.velocity = self.speed * self.movedir * MOVETYPE_BOUNCE;
      if (other.classname == "player" && self.sounds == 0) {
        if (other.fly_sound < time) {
          other.fly_sound = time + 1.5;
          sound(other, CHAN_AUTO, "ambience/windfly.wav", 1, ATTN_NORM);
          }
        }
      }
    }
  if (self.spawnflags & PUSH_ONCE) {
    remove(self);
    }
}

Void function trigger_push();
{
  InitTrigger();
  precache_sound("ambience/windfly.wav");
  if (self.targetname) {
    self.use = toggle_trigger_push;
    if (self.spawnflags & SPAWNFLAG_LASER) {
      self.touch = trigger_push_touch;
      }
    else {
      self.touch = Sub_Null;
      }
    }
  else {
    self.touch = trigger_push_touch;
    }
  if (!(self.speed)) {
    self.speed = 1000;
    }
}

Void function toggle_trigger_push();
{
  if (other.classname != "player") {
    exit;
    }
  if (self.touch == trigger_push_touch) {
    self.touch = Sub_Null;
    }
  else {
    self.touch = trigger_push_touch;
    }
}

Void function trigger_monsterjump_touch();
{
  if ((other.flags & (FL_MONSTER | FL_FLY | FL_SWIM)) != FL_MONSTER) {
    exit;
    }
  other.velocity_x = self.movedir_x * self.speed;
  other.velocity_y = self.movedir_y * self.speed;
  if (!(other.flags & FL_ONGROUND)) {
    exit;
    }
  other.flags = other.flags - FL_ONGROUND;
  other.velocity_z = self.height;
}

Void function trigger_monsterjump();
{
  if (!(self.speed)) {
    self.speed = 200;
    }
  if (!(self.height)) {
    self.height = 200;
    }
  if (self.angles == VEC_ORIGIN) {
    self.angles = [0 360 0];
    }
  InitTrigger();
  self.touch = trigger_monsterjump_touch;
}

Void function qteleport_touch();
var
 t : Object;
 org : Vector;
{
  if (self.targetname) {
    if (self.nextthink < time) {
      exit;
      }
    }
  if (other.health <= 0 || other.solid != SOLID_SLIDEBOX) {
    exit;
    }
  SUB_UseTargets();
  t = find(world, targetname, self.target);
  if (!t) {
    objerror("couldn't find target");
    }
  makevectors(t.mangle);
  org = t.origin + FL_MONSTER * v_forward;
  spawn_tdeath(t.origin, other);
  if (!(other.health)) {
    other.origin = t.origin;
    other.velocity = v_forward * other.velocity_x + v_forward * other.velocity_y;
    exit;
    }
  setorigin(other, t.origin);
  other.angles = t.mangle;
  if (other.classname == "player") {
    other.fixangle = 1;
    other.teleport_time = time + 0.7;
    if (other.flags & FL_ONGROUND) {
      other.flags = other.flags - FL_ONGROUND;
      }
    other.velocity = v_forward * 300;
    }
  other.flags = other.flags - (other.flags & FL_ONGROUND);
}

Void function trigger_qtele();
var
 o : Vector;
{
  InitTrigger();
  self.touch = qteleport_touch;
  if (!(self.target)) {
    objerror("no target");
    }
  self.use = teleport_use;
}

Void function skubremove_touch();
var
 t : Object;
 org : Vector;
{
  if (other.classname == "player") {
    exit;
    }
  if (other.solid == SOLID_BBOX) {
    if (other.classname != "func_mindcrime") {
      exit;
      }
    }
  else {
    if (other.solid != SOLID_SLIDEBOX) {
      exit;
      }
    }
  SUB_UseTargets();
  if (self.spawnflags & FL_GODMODE) {
    spawn_tfog(other.origin);
    }
  dprint("something removed via func_remove|");
  remove(other);
}

Void function func_remove();
var
 o : Vector;
{
  InitTrigger();
  if (self.spawnflags & FL_NOTARGET || world.model == "maps/nehend.bsp") {
    self.touch = abyss_touch;
    }
  else {
    self.touch = skubremove_touch;
    }
}

Void function abyss_touch();
{
  if (other.classname == "camera") {
    exit;
    }
  if (other.classname == "player") {
    exit;
    }
  if (other.solid == SOLID_SLIDEBOX || other.solid == SOLID_BBOX) {
    remove(other);
    }
}

Void function info_levelend();
{
  self.use = trigger_levelchange;
}

Void function trigger_levelchange();
var
 head : Object;
{
  self.objekt = find(world, classname, "camera");
  if (self.objekt == world) {
    head = find(world, classname, "player");
    while (head) {
      if (head.health > 0) {
        self.objekt = head;
        }
      head = find(head, classname, "player");
      }
    }
  if (self.objekt != world) {
    nextmap = self.map;
    self.objekt.think = execute_changelevel;
    self.objekt.nextthink = time + 0.5;
    exit;
    }
}


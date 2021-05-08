Void function button_wait();
{
  self.state = STATE_TOP;
  self.nextthink = self.ltime + self.wait;
  self.think = button_return;
  activator = self.enemy;
  SUB_UseTargets();
  self.frame = 1;
}

Void function button_done();
{
  self.state = STATE_BOTTOM;
}

Void function button_return();
{
  self.state = STATE_DOWN;
  SUB_CalcMove(self.pos1, self.speed, button_done);
  self.frame = 0;
  if (self.health) {
    self.takedamage = DAMAGE_YES;
    }
}

Void function button_blocked();
{
}

Void function button_fire();
{
  if (self.state == STATE_UP || self.state == STATE_TOP) {
    exit;
    }
  sound(self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
  self.state = STATE_UP;
  SUB_CalcMove(self.pos2, self.speed, button_wait);
}

Void function button_use();
{
  self.enemy = activator;
  button_fire();
}

Void function button_touch();
{
  if (self.spawnflags & FL_GODMODE) {
    if (other.soul != "yes") {
      exit;
      }
    }
  else {
    if (other.classname != "player") {
      exit;
      }
    if (self.spawnflags & FL_INWATER) {
      if (!(other.items & IT_KEY1)) {
        if (world.worldtype == FL_SWIM) {
          centerprint(other, "Silver keycard required to operate");
          }
        else {
          if (world.worldtype == 1) {
            centerprint(other, "You need the silver runekey");
            }
          else {
            if (world.worldtype == 0) {
              centerprint(other, "You need the silver key");
              }
            }
          }
        exit;
        }
      }
    if (self.spawnflags & FL_CLIENT) {
      if (!(other.items & IT_KEY2)) {
        if (world.worldtype == FL_SWIM) {
          centerprint(other, "You need the gold keycard");
          }
        else {
          if (world.worldtype == 1) {
            centerprint(other, "You need the gold runekey");
            }
          else {
            if (world.worldtype == 0) {
              centerprint(other, "You need the gold key");
              }
            }
          }
        exit;
        }
      }
    }
  self.enemy = other;
  button_fire();
}

Void function button_killed();
{
  self.enemy = damage_attacker;
  self.health = self.max_health;
  self.takedamage = DAMAGE_NO;
  button_fire();
}

Void function func_button();
var
 gtemp : Real;
 ftemp : Real;
{
  if (self.sounds == 0) {
    precache_sound("buttons/airbut1.wav");
    self.noise = "buttons/airbut1.wav";
    }
  if (self.sounds == 1) {
    precache_sound("buttons/switch21.wav");
    self.noise = "buttons/switch21.wav";
    }
  if (self.sounds == FL_SWIM) {
    precache_sound("buttons/switch02.wav");
    self.noise = "buttons/switch02.wav";
    }
  if (self.sounds == MOVETYPE_WALK) {
    precache_sound("buttons/switch04.wav");
    self.noise = "buttons/switch04.wav";
    }
  if (self.sounds == 4) {
    precache_sound("buttons/rch_sw1.wav");
    self.noise = "buttons/rch_sw1.wav";
    }
  if (self.sounds == 5) {
    precache_sound("buttons/rch_sw2.wav");
    self.noise = "buttons/rch_sw2.wav";
    }
  SetMovedir();
  self.movetype = MOVETYPE_PUSH;
  self.solid = SOLID_BSP;
  setmodel(self, self.model);
  self.blocked = button_blocked;
  self.use = button_use;
  if (self.health) {
    self.max_health = self.health;
    self.th_die = button_killed;
    self.takedamage = DAMAGE_YES;
    }
  else {
    self.touch = button_touch;
    }
  if (!(self.speed)) {
    self.speed = 40;
    }
  if (!(self.wait)) {
    self.wait = 1;
    }
  if (!(self.lip)) {
    self.lip = MOVETYPE_STEP;
    }
  self.state = STATE_BOTTOM;
  self.pos1 = self.origin;
  self.pos2 = self.pos1 + self.movedir * (fabs(self.movedir * self.size) - self.lip);
}


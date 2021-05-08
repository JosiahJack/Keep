Void function trigger_custom();
{
  if (!(self.target)) {
    objerror("trigger_custom with no targets.  Doh!|");
    }
  InitTrigger();
  if (self.noise) {
    precache_sound(self.noise);
    }
  if (self.noise1) {
    precache_sound(self.noise1);
    }
  if (!(self.event)) {
    self.event = "prefatory@yahoo.com";
    }
  self.touch = check_custom;
  self.think = custom_timing;
  self.nextthink = time + 1;
}

Void function custom_timing();
{
  if (self.touch != check_custom) {
    self.touch = check_custom;
    }
  self.nextthink = time + 2;
  self.think = custom_timing;
}

Void function check_custom();
var
 item : Object;
{
  if (other.classname != "player" || other.health < 1) {
    exit;
    }
  item = find(world, netname, self.event);
  if (item != world) {
    centerprint(other, "You need the ", self.event);
    if (self.noise1) {
      sound(other, CHAN_ITEM, self.noise1, 1, ATTN_NORM);
      }
    self.touch = Sub_Null;
    exit;
    }
  if (self.noise) {
    sound(other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
    }
  Sub_UseTargets();
  remove(self);
}

Void function custom_item();
{
  if (!(self.model)) {
    bprint("MINDCRIME: removed Custom_Item because no model was set|");
    remove(self);
    exit;
    }
  if (!(self.netname)) {
    bprint("MINDCRIME: removed Custom_Item because no netname was set|");
    remove(self);
    exit;
    }
  if (self.noise) {
    precache_sound(self.noise);
    }
  precache_model(self.model);
  setmodel(self, self.model);
  self.touch = cust_item_touch;
  setsize(self, [-16 -16 0], [16 16 56]);
  StartItem();
}

Void function cust_item_touch();
{
  if (other.classname != "player" || other.health < 1) {
    exit;
    }
  if (self.noise) {
    sound(other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
    }
  centerprint(other, "You got the |");
  centerprint(other, self.netname);
  Sub_UseTargets();
  remove(self);
}

Void function snd_beat_toggle();
{
  if (!(self.noise)) {
    objerror("No self.noise for snd_beat_toggle.  Doh!");
    }
  if (!(self.noise1)) {
    objerror("No self.noise1 for snd_beat_toggle.  Doh|");
    }
  precache_sound(self.noise);
  precache_sound(self.noise1);
  setorigin(self, self.origin);
  if (self.volume < 1) {
    self.volume = 1;
    }
  self.noise2 = self.noise;
  self.cnt = 0;
  if (self.targetname) {
    self.use = snd_beat_use;
    }
  else {
    if (self.wait > 0) {
      self.think = snd_beat_go;
      self.nextthink = time + self.wait;
      exit;
      }
    self.think = snd_beat_go;
    self.nextthink = time + self.delay;
    }
}

Void function snd_beat_use();
{
  self.think = snd_beat_go;
  self.nextthink = snd_beat_use;
  self.use = Sub_Remove;
}

Void function snd_beat_go();
{
  sound(other, CHAN_ITEM, self.noise2, 1, ATTN_NORM);
  self.cnt = self.cnt + 1;
  if (self.cnt >= self.volume) {
    self.cnt = 0;
    if (random() < 0.4) {
      self.noise2 = self.noise;
      }
    else {
      self.noise2 = self.noise1;
      }
    }
  self.nextthink = time + self.delay;
  self.think = snd_beat_go;
}

Void function misc_misc();
{
  if (!(self.model)) {
    bprint("MINDCRIME: removed misc_misc because no model was set|");
    remove(self);
    exit;
    }
  precache_model(self.model);
  setmodel(self, self.model);
  setorigin(self, self.origin);
  setsize(self, [-16 -16 0], [16 16 56]);
}


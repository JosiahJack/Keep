Void function SUB_regen();
{
  self.model = self.mdl;
  self.solid = SOLID_TRIGGER;
  sound(self, CHAN_VOICE, "items/itembk2.wav", 1, ATTN_NORM);
  setorigin(self, self.origin);
}

Void function noclass();
{
  dprint("noclass spawned at");
  dprint(vtos(self.origin));
  dprint("|");
  remove(self);
}

Void function PlaceItem();
var
 oldz : Real;
{
  self.mdl = self.model;
  self.flags = FL_ITEM;
  self.solid = SOLID_TRIGGER;
  self.movetype = MOVETYPE_TOSS;
  self.velocity = VEC_ORIGIN;
  self.origin_z = self.origin_z + MOVETYPE_TOSS;
  oldz = self.origin_z;
  if (!droptofloor()) {
    dprint("Bonus item fell out of level at ");
    dprint(vtos(self.origin));
    dprint("|");
    remove(self);
    exit;
    }
}

Void function StartItem();
{
  self.nextthink = time + 0.2;
  self.think = PlaceItem;
}

Real function T_Heal(e : Object; healamount : Real; ignore : Real);
{
  if (e.health <= 0) {
    return 0;
    }
  if (!ignore && e.health >= other.max_health) {
    return 0;
    }
  healamount = ceil(healamount);
  e.health = e.health + healamount;
  if (!ignore && e.health >= other.max_health) {
    e.health = other.max_health;
    }
  if (e.classname == "player" && e.health > 250) {
    e.health = 250;
    }
  return 1;
}

Void function item_health();
{
  self.touch = health_touch;
  if (self.spawnflags & H_ROTTEN) {
    precache_model("maps/b_bh10.bsp");
    precache_sound("items/r_item1.wav");
    setmodel(self, "maps/b_bh10.bsp");
    self.noise = "items/r_item1.wav";
    self.healamount = 15;
    self.healtype = 0;
    }
  else {
    if (self.spawnflags & H_MEGA) {
      precache_model("maps/b_bh100.bsp");
      precache_sound("items/r_item2.wav");
      setmodel(self, "maps/b_bh100.bsp");
      self.noise = "items/r_item2.wav";
      self.healamount = 100;
      self.healtype = FL_SWIM;
      }
    else {
      precache_model("maps/b_bh25.bsp");
      precache_sound("items/health1.wav");
      setmodel(self, "maps/b_bh25.bsp");
      self.noise = "items/health1.wav";
      self.healamount = 25;
      self.healtype = 1;
      }
    }
  setsize(self, VEC_ORIGIN, [32 32 56]);
  StartItem();
}


Void function item2_health();
{
  self.touch = health_touch;
  if (self.spawnflags & H_MEGA) {
    precache_model("progs/mshelth.mdl");
    precache_sound("items/r_item2.wav");
    setmodel(self, "progs/mshelth.mdl");
    self.noise = "items/r_item2.wav";
    self.healamount = 100;
    self.healtype = FL_SWIM;
    }
  else {
    precache_model("progs/mhelth.mdl");
    precache_sound("items/r_item2.wav");
    setmodel(self, "progs/mhelth.mdl");
    self.noise = "items/r_item2.wav";
    self.healamount = 25;
    self.healtype = 1;
    }
  setsize(self, VEC_ORIGIN, [32 32 56]);
  StartItem();
}

Void function health_touch();
var
 amount : Real;
 s : String;
{
  if (other.classname != "player") {
    exit;
    }
  if (self.healtype == FL_SWIM) {
    if (other.health >= 250) {
      exit;
      }
    if (!T_Heal(other, self.healamount, 1)) {
      exit;
      }
    }
  else {
    if (!T_Heal(other, self.healamount, 0)) {
      exit;
      }
    }
  sprint(other, "You receive ");
  s = ftos(self.healamount);
  sprint(other, s);
  sprint(other, " health|");
  sound(other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
  stuffcmd(other, "bf|");
  self.model = string_null;
  self.solid = SOLID_NOT;
  if (self.healtype == FL_SWIM) {
    other.items = other.items | IT_SUPERHEALTH;
    self.nextthink = time + MOVETYPE_FLY;
    self.think = item_megahealth_rot;
    self.owner = other;
    }
  else {
    if (irespawn || deathmatch || world.model == "maps/nehend.bsp" || world.model == "maps/nehahra.bsp") {
      self.nextthink = time + 20;
      }
    self.think = SUB_regen;
    }
  activator = other;
  SUB_UseTargets();
}

Void function item_megahealth_rot();
{
  other = self.owner;
  if (other.health > other.max_health) {
    other.health = other.health - 1;
    self.nextthink = time + 1;
    exit;
    }
  other.items = other.items - (other.items & IT_SUPERHEALTH);
  if (deathmatch == 1 || irespawn) {
    self.nextthink = time + 20;
    self.think = SUB_regen;
    }
}

Void function armor_touch();
var
 type : Real;
 value : Real;
 bit : Real;
{
  if (other.health <= 0) {
    exit;
    }
  if (other.classname != "player") {
    exit;
    }
  if (self.classname == "item_armor1") {
    type = 0.3;
    value = 100;
    bit = IT_ARMOR1;
    }
  if (self.classname == "item_armor2") {
    type = 0.6;
    value = 150;
    bit = IT_ARMOR2;
    }
  if (self.classname == "item_armorInv") {
    type = 0.8;
    value = 200;
    bit = IT_ARMOR3;
    }
  if (other.armortype * other.armorvalue >= type * value) {
    exit;
    }
  other.armortype = type;
  other.armorvalue = value;
  other.items = other.items - (other.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3)) + bit;
  self.solid = SOLID_NOT;
  self.model = string_null;
  if (irespawn || deathmatch > 0 || world.model == "maps/nehend.bsp" || world.model == "maps/nehahra.bsp") {
    self.nextthink = time + 20;
    }
  self.think = SUB_regen;
  sprint(other, "You got armor|");
  sound(other, CHAN_ITEM, "items/armor1.wav", 1, ATTN_NORM);
  stuffcmd(other, "bf|");
  activator = other;
  SUB_UseTargets();
}

Void function item_armor1();
{
  self.touch = armor_touch;
  precache_model("progs/armor.mdl");
  setmodel(self, "progs/armor.mdl");
  self.skin = 0;
  setsize(self, [-16 -16 0], [16 16 56]);
  StartItem();
}

Void function item_armor2();
{
  self.touch = armor_touch;
  precache_model("progs/armor.mdl");
  setmodel(self, "progs/armor.mdl");
  self.skin = 1;
  setsize(self, [-16 -16 0], [16 16 56]);
  StartItem();
}

Void function item_armorInv();
{
  self.touch = armor_touch;
  precache_model("progs/armor.mdl");
  setmodel(self, "progs/armor.mdl");
  self.skin = FL_SWIM;
  setsize(self, [-16 -16 0], [16 16 56]);
  StartItem();
}

Void function bound_other_ammo();
{
  if (other.ammo_shells > 200) {
    other.ammo_shells = 200;
    }
  if (other.ammo_nails > 200) {
    other.ammo_nails = 200;
    }
  if (other.ammo_rockets > 100) {
    other.ammo_rockets = 100;
    }
  if (other.ammo_cells > 100) {
    other.ammo_cells = 100;
    }
}

Real function RankForWeapon(w : Real);
{
  if (w == IT_LIGHTNING) {
    return 1;
    }
  if (w == IT_ROCKET_LAUNCHER) {
    return FL_SWIM;
    }
  if (w == IT_SUPER_NAILGUN) {
    return MOVETYPE_WALK;
    }
  if (w == IT_GRENADE_LAUNCHER) {
    return MOVETYPE_STEP;
    }
  if (w == IT_SUPER_SHOTGUN) {
    return MOVETYPE_FLY;
    }
  if (w == IT_AUTO_SHOTGUN) {
    return MOVETYPE_TOSS;
    }
  return MOVETYPE_PUSH;
}

Void function Deathmatch_Weapon(old : Real; new : Real);
var
 or : Real;
 nr : Real;
{
  or = RankForWeapon(self.weapon);
  nr = RankForWeapon(new);
  if (nr < or) {
    self.weapon = new;
    }
}

Void function weapon_touch();
var
 hadammo : Real;
 best : Real;
 new : Real;
 old : Real;
 stemp : Object;
 leave : Real;
{
  if (!(other.flags & FL_CLIENT)) {
    exit;
    }
  stemp = self;
  self = other;
  best = W_BestWeapon();
  self = stemp;
  leave = (deathmatch > 1 || coop);
  new = self.weapon;
  if (leave && (other.items & new)) {
    exit;
    }
  other.ammo_shells = other.ammo_shells + self.ammo_shells;
  other.ammo_nails = other.ammo_nails + self.ammo_nails;
  other.ammo_rockets = other.ammo_rockets + self.ammo_rockets;
  other.ammo_cells = other.ammo_cells + self.ammo_cells;
  sprint(other, "You got the ");
  sprint(other, self.netname);
  sprint(other, "|");
  sound(other, CHAN_ITEM, "weapons/pkup.wav", 1, ATTN_NORM);
  stuffcmd(other, "bf|");
  bound_other_ammo();
  old = other.items;
  other.items = other.items | new;
  stemp = self;
  self = other;
  self.weapon = new;
  W_SetCurrentAmmo();
  self = stemp;
  if (leave) {
    exit;
    }
  self.model = string_null;
  self.solid = SOLID_NOT;
  if (deathmatch == 1 || deathmatch > 2) {
    self.nextthink = time + 30;
    }
  self.think = SUB_regen;
  activator = other;
  SUB_UseTargets();
}

Void function weapon_supershotgun();
{
  precache_model("progs/g_shot.mdl");
  setmodel(self, "progs/g_shot.mdl");
  self.weapon = IT_SUPER_SHOTGUN;
  self.netname = "Double Barrel Shotgun";
  self.touch = weapon_touch;
  setsize(self, [-16 -16 0], [16 16 56]);
  StartItem();
  self.ammo_shells = 5;
}

Void function weapon_nailgun();
{
  precache_model("progs/g_nail.mdl");
  setmodel(self, "progs/g_nail.mdl");
  self.weapon = IT_NAILGUN;
  self.netname = "nailgun";
  self.touch = weapon_touch;
  setsize(self, [-16 -16 0], [16 16 56]);
  StartItem();
  self.ammo_nails = 30;
}

Void function weapon_supernailgun();
{
  precache_model("progs/g_nail2.mdl");
  setmodel(self, "progs/g_nail2.mdl");
  self.weapon = IT_SUPER_NAILGUN;
  self.netname = "Super Nailgun";
  self.touch = weapon_touch;
  setsize(self, [-16 -16 0], [16 16 56]);
  StartItem();
  self.ammo_nails = 30;
}

Void function weapon_grenadelauncher();
{
  precache_model("progs/g_rock.mdl");
  setmodel(self, "progs/g_rock.mdl");
  self.weapon = IT_GRENADE_LAUNCHER;
  self.netname = "Grenade Launcher";
  self.touch = weapon_touch;
  setsize(self, [-16 -16 0], [16 16 56]);
  StartItem();
  self.ammo_rockets = 5;
}

Void function weapon_rocketlauncher();
{
  precache_model("progs/g_rock2.mdl");
  setmodel(self, "progs/g_rock2.mdl");
  self.weapon = IT_ROCKET_LAUNCHER;
  self.netname = "Rocket Launcher";
  self.touch = weapon_touch;
  setsize(self, [-16 -16 0], [16 16 56]);
  StartItem();
  self.ammo_rockets = 5;
}

Void function weapon_gshotgun();
{
  precache_model("progs/mg_sh2.mdl");
  setmodel(self, "progs/mg_sh2.mdl");
  self.weapon = IT_AUTO_SHOTGUN;
  self.netname = "Auto Shotgun";
  self.touch = weapon_touch;
  setsize(self, [-16 -16 0], [16 16 56]);
  StartItem();
  self.ammo_shells = 50;
}

Void function weapon_sprocket();
{
  precache_model("progs/mg_rock2.mdl");
  setmodel(self, "progs/mg_rock2.mdl");
  self.weapon = IT_SPROCKET;
  self.netname = "Sprocket Launcher";
  self.touch = weapon_touch;
  setsize(self, [-16 -16 0], [16 16 56]);
  StartItem();
  self.ammo_rockets = 5;
}

Void function weapon_lightning();
{
  precache_model("progs/g_light.mdl");
  setmodel(self, "progs/g_light.mdl");
  self.weapon = IT_LIGHTNING;
  self.netname = "Thunderbolt";
  self.touch = weapon_touch;
  setsize(self, [-16 -16 0], [16 16 56]);
  StartItem();
  self.ammo_cells = 15;
}

Void function ammo_touch();
var
 stemp : Object;
 best : Real;
{
  if (other.classname != "player") {
    exit;
    }
  if (other.health <= 0) {
    exit;
    }
  stemp = self;
  self = other;
  best = W_BestWeapon();
  self = stemp;
  if (self.weapon == 1) {
    if (other.ammo_shells >= 200) {
      exit;
      }
    other.ammo_shells = other.ammo_shells + self.aflag;
    }
  if (self.weapon == FL_SWIM) {
    if (other.ammo_nails >= 200) {
      exit;
      }
    other.ammo_nails = other.ammo_nails + self.aflag;
    }
  if (self.weapon == MOVETYPE_WALK) {
    if (other.ammo_rockets >= 100) {
      exit;
      }
    other.ammo_rockets = other.ammo_rockets + self.aflag;
    }
  if (self.weapon == MOVETYPE_STEP) {
    if (other.ammo_cells >= 100) {
      exit;
      }
    other.ammo_cells = other.ammo_cells + self.aflag;
    }
  bound_other_ammo();
  sprint(other, "You got the ");
  sprint(other, self.netname);
  sprint(other, "|");
  sound(other, CHAN_ITEM, "weapons/lock4.wav", 1, ATTN_NORM);
  stuffcmd(other, "bf|");
  if (other.weapon == best) {
    stemp = self;
    self = other;
    self.weapon = W_BestWeapon();
    W_SetCurrentAmmo();
    self = stemp;
    }
  stemp = self;
  self = other;
  W_SetCurrentAmmo();
  self = stemp;
  self.model = string_null;
  self.solid = SOLID_NOT;
  if (irespawn || deathmatch > 0 || world.model == "maps/nehend.bsp" || world.model == "maps/nehahra.bsp") {
    self.nextthink = time + SVC_INTERMISSION;
    }
  self.think = SUB_regen;
  activator = other;
  SUB_UseTargets();
}

Void function item_shells();
{
  self.touch = ammo_touch;
  if (self.spawnflags & WEAPON_BIG2) {
    precache_model("maps/b_shell1.bsp");
    setmodel(self, "maps/b_shell1.bsp");
    self.aflag = 40;
    }
  else {
    precache_model("maps/b_shell0.bsp");
    setmodel(self, "maps/b_shell0.bsp");
    self.aflag = 20;
    }
  self.weapon = 1;
  self.netname = "shells";
  setsize(self, VEC_ORIGIN, [32 32 56]);
  StartItem();
}

Void function item_spikes();
{
  self.touch = ammo_touch;
  if (self.spawnflags & WEAPON_BIG2) {
    precache_model("maps/b_nail1.bsp");
    setmodel(self, "maps/b_nail1.bsp");
    self.aflag = 50;
    }
  else {
    precache_model("maps/b_nail0.bsp");
    setmodel(self, "maps/b_nail0.bsp");
    self.aflag = 25;
    }
  self.weapon = FL_SWIM;
  self.netname = "nails";
  setsize(self, VEC_ORIGIN, [32 32 56]);
  StartItem();
}

Void function item_rockets();
{
  self.touch = ammo_touch;
  if (self.spawnflags & WEAPON_BIG2) {
    precache_model("maps/b_rock1.bsp");
    setmodel(self, "maps/b_rock1.bsp");
    self.aflag = MOVETYPE_BOUNCE;
    }
  else {
    precache_model("maps/b_rock0.bsp");
    setmodel(self, "maps/b_rock0.bsp");
    self.aflag = MOVETYPE_FLY;
    }
  self.weapon = MOVETYPE_WALK;
  self.netname = "rockets";
  setsize(self, VEC_ORIGIN, [32 32 56]);
  StartItem();
}

Void function item_cells();
{
  self.touch = ammo_touch;
  if (self.spawnflags & WEAPON_BIG2) {
    precache_model("maps/b_batt1.bsp");
    setmodel(self, "maps/b_batt1.bsp");
    self.aflag = 12;
    }
  else {
    precache_model("maps/b_batt0.bsp");
    setmodel(self, "maps/b_batt0.bsp");
    self.aflag = MOVETYPE_TOSS;
    }
  self.weapon = MOVETYPE_STEP;
  self.netname = "cells";
  setsize(self, VEC_ORIGIN, [32 32 56]);
  StartItem();
}

Void function item_weapon();
{
  self.touch = ammo_touch;
  if (self.spawnflags & WEAPON_SHOTGUN) {
    if (self.spawnflags & WEAPON_BIG) {
      precache_model("maps/b_shell1.bsp");
      setmodel(self, "maps/b_shell1.bsp");
      self.aflag = 40;
      }
    else {
      precache_model("maps/b_shell0.bsp");
      setmodel(self, "maps/b_shell0.bsp");
      self.aflag = 20;
      }
    self.weapon = 1;
    self.netname = "shells";
    }
  if (self.spawnflags & WEAPON_SPIKES) {
    if (self.spawnflags & WEAPON_BIG) {
      precache_model("maps/b_nail1.bsp");
      setmodel(self, "maps/b_nail1.bsp");
      self.aflag = 40;
      }
    else {
      precache_model("maps/b_nail0.bsp");
      setmodel(self, "maps/b_nail0.bsp");
      self.aflag = 20;
      }
    self.weapon = FL_SWIM;
    self.netname = "spikes";
    }
  if (self.spawnflags & WEAPON_ROCKET) {
    if (self.spawnflags & WEAPON_BIG) {
      precache_model("maps/b_rock1.bsp");
      setmodel(self, "maps/b_rock1.bsp");
      self.aflag = MOVETYPE_BOUNCE;
      }
    else {
      precache_model("maps/b_rock0.bsp");
      setmodel(self, "maps/b_rock0.bsp");
      self.aflag = MOVETYPE_FLY;
      }
    self.weapon = MOVETYPE_WALK;
    self.netname = "rockets";
    }
  setsize(self, VEC_ORIGIN, [32 32 56]);
  StartItem();
}

Void function key_touch();
var
 stemp : Object;
 best : Real;
{
  if (other.classname != "player") {
    exit;
    }
  if (other.health <= 0) {
    exit;
    }
  if (other.items & self.items) {
    exit;
    }
  sprint(other, "You got the ");
  sprint(other, self.netname);
  sprint(other, "|");
  sound(other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
  stuffcmd(other, "bf|");
  other.items = other.items | self.items;
  if (!coop) {
    self.solid = SOLID_NOT;
    self.model = string_null;
    }
  activator = other;
  SUB_UseTargets();
}

Void function key_setsounds();
{
  if (world.worldtype == 0) {
    precache_sound("misc/medkey.wav");
    self.noise = "misc/medkey.wav";
    }
  if (world.worldtype == 1) {
    precache_sound("misc/runekey.wav");
    self.noise = "misc/runekey.wav";
    }
  if (world.worldtype == FL_SWIM) {
    precache_sound2("misc/basekey.wav");
    self.noise = "misc/basekey.wav";
    }
}

Void function item_key1();
{
  if (deathmatch > 0) {
    remove(self);
    exit;
    }
  if (world.worldtype == 0) {
    precache_model("progs/w_s_key.mdl");
    setmodel(self, "progs/w_s_key.mdl");
    self.netname = "silver key";
    }
  else {
    if (world.worldtype == 1) {
      precache_model("progs/m_s_key.mdl");
      setmodel(self, "progs/m_s_key.mdl");
      self.netname = "silver runekey";
      }
    else {
      if (world.worldtype == FL_SWIM) {
        precache_model2("progs/b_s_key.mdl");
        setmodel(self, "progs/b_s_key.mdl");
        self.netname = "silver keycard";
        }
      }
    }
  key_setsounds();
  self.touch = key_touch;
  self.items = IT_KEY1;
  setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
  StartItem();
}

Void function item_key2();
{
  if (deathmatch > 0) {
    remove(self);
    exit;
    }
  if (world.worldtype == 0) {
    precache_model("progs/w_g_key.mdl");
    setmodel(self, "progs/w_g_key.mdl");
    self.netname = "gold key";
    }
  if (world.worldtype == 1) {
    precache_model("progs/m_g_key.mdl");
    setmodel(self, "progs/m_g_key.mdl");
    self.netname = "gold runekey";
    }
  if (world.worldtype == FL_SWIM) {
    precache_model2("progs/b_g_key.mdl");
    setmodel(self, "progs/b_g_key.mdl");
    self.netname = "gold keycard";
    }
  key_setsounds();
  self.touch = key_touch;
  self.items = IT_KEY2;
  setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
  StartItem();
}

Void function sigil_touch();
var
 stemp : Object;
 best : Real;
{
  if (other.classname != "player") {
    exit;
    }
  if (other.health <= 0) {
    exit;
    }
  centerprint(other, "You got the rune!");
  sound(other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
  stuffcmd(other, "bf|");
  self.solid = SOLID_NOT;
  self.model = string_null;
  serverflags = serverflags | (self.spawnflags & 15);
  self.classname = "";
  activator = other;
  SUB_UseTargets();
}

Void function item_sigil();
{
  if (!(self.spawnflags)) {
    objerror("no spawnflags");
    }
  precache_sound("misc/runekey.wav");
  self.noise = "misc/runekey.wav";
  if (self.spawnflags & 1) {
    precache_model("progs/end1.mdl");
    setmodel(self, "progs/end1.mdl");
    }
  if (self.spawnflags & FL_SWIM) {
    precache_model2("progs/end2.mdl");
    setmodel(self, "progs/end2.mdl");
    }
  if (self.spawnflags & MOVETYPE_STEP) {
    precache_model2("progs/end3.mdl");
    setmodel(self, "progs/end3.mdl");
    }
  if (self.spawnflags & FL_CLIENT) {
    precache_model2("progs/end4.mdl");
    setmodel(self, "progs/end4.mdl");
    }
  self.touch = sigil_touch;
  setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
  StartItem();
}

Void function powerup_touch();
var
 stemp : Object;
 best : Real;
{
  if (other.classname != "player") {
    exit;
    }
  if (other.health <= 0) {
    exit;
    }
  sprint(other, "You got the ");
  sprint(other, self.netname);
  sprint(other, "|");
  stuffcmd(other, "bf|");
  if (irespawn || deathmatch || world.model == "maps/nehend.bsp") {
    self.mdl = self.model;
    if (self.classname == "item_artifact_invulnerability" || self.classname == "item_artifact_invisibility") {
      self.nextthink = time + 80 * MOVETYPE_FLY;
      }
    else {
      self.nextthink = time + 60;
      }
    if (world.model == "maps/nehend.bsp" && self.classname == "item_artifact_resurrection") {
      self.think = Sub_remove;
      }
    else {
      self.think = SUB_regen;
      }
    }
  sound(other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
  self.solid = SOLID_NOT;
  if (self.classname == "item_artifact_resurrection") {
    other.lives = other.lives + 1;
    }
  if (self.classname == "item_artifact_regeneration") {
    other.regen = other.regen + 20;
    if (other.regen > 100) {
      other.regen = 100;
      bprint("Your regeneration is at full|");
      }
    }
  else {
    other.items = other.items | self.items;
    }
  self.model = string_null;
  if (self.event == "thrownsuit" || self.classname == "item_artifact_envirosuit") {
    other.rad_time = 1;
    other.radsuit_finished = time + SVC_INTERMISSION;
    }
  if (self.classname == "item_artifact_invulnerability") {
    other.invincible_time = 1;
    other.invincible_finished = time + SVC_INTERMISSION;
    }
  if (self.classname == "item_artifact_invisibility") {
    other.invisible_time = 1;
    other.invisible_finished = time + SVC_INTERMISSION;
    }
  if (self.classname == "item_artifact_super_damage") {
    other.super_time = 1;
    other.super_damage_finished = time + SVC_INTERMISSION;
    }
  if (self.classname == "item_artifact_flight") {
    other.fly_time = 1;
    other.fly_finished = time + FL_GODMODE;
    }
  activator = other;
  SUB_UseTargets();
}

Void function item_artifact_regeneration();
{
  self.event = "relic";
  self.touch = powerup_touch;
  precache_model("progs/regen.mdl");
  precache_sound("items/inv1.wav");
  precache_sound("items/inv2.wav");
  precache_sound("items/inv3.wav");
  self.noise = "items/inv1.wav";
  setmodel(self, "progs/regen.mdl");
  self.netname = "Regeneration Artifact";
  setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
  StartItem();
}

Void function item_artifact_resurrection();
{
  self.event = "relic";
  self.touch = powerup_touch;
  precache_model("progs/res.mdl");
  precache_sound("items/inv1.wav");
  precache_sound("items/inv2.wav");
  precache_sound("items/inv3.wav");
  self.noise = "items/inv1.wav";
  setmodel(self, "progs/res.mdl");
  self.netname = "the resurrection artifact";
  setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
  StartItem();
  if (world.model == "maps/nehend.bsp") {
    self.mdl = self.model;
    self.nextthink = time + 150;
    self.think = SUB_regen;
    self.solid = SOLID_NOT;
    self.model = string_null;
    }
}

Void function item_artifact_flight();
{
  if (deathmatch == 4) {
    self.classname = "info_player_deathmatch";
    exit;
    }
  self.event = "relic";
  self.touch = powerup_touch;
  precache_model("progs/flying.mdl");
  precache_sound("items/inv1.wav");
  precache_sound("items/inv2.wav");
  precache_sound("items/inv3.wav");
  self.noise = "items/inv1.wav";
  setmodel(self, "progs/flying.mdl");
  self.netname = "the flying artifact";
  self.items = 0;
  setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
  StartItem();
  if (world.model == "maps/nehend.bsp") {
    self.mdl = self.model;
    self.nextthink = time + 110;
    self.think = SUB_regen;
    self.solid = SOLID_NOT;
    self.model = string_null;
    }
}

Void function item_artifact_invulnerability();
{
  self.event = "relic";
  self.touch = powerup_touch;
  precache_model("progs/invulner.mdl");
  precache_sound("items/protect.wav");
  self.noise = "items/protect.wav";
  setmodel(self, "progs/invulner.mdl");
  self.netname = "Pentagram of Protection";
  self.items = IT_INVULNERABILITY;
  setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
  StartItem();
}

Void function item_artifact_envirosuit();
{
  self.event = "relic";
  self.touch = powerup_touch;
  precache_model("progs/suit.mdl");
  precache_sound("items/suit.wav");
  precache_sound("items/suit2.wav");
  self.noise = "items/suit.wav";
  setmodel(self, "progs/suit.mdl");
  self.netname = "Biosuit";
  self.items = IT_SUIT;
  setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
  StartItem();
}

Void function item_artifact_invisibility();
{
  self.event = "relic";
  self.touch = powerup_touch;
  precache_model("progs/invisibl.mdl");
  precache_sound("items/inv1.wav");
  precache_sound("items/inv2.wav");
  precache_sound("items/inv3.wav");
  self.noise = "items/inv1.wav";
  setmodel(self, "progs/invisibl.mdl");
  self.netname = "Ring of Shadows";
  self.items = IT_INVISIBILITY;
  setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
  StartItem();
}

Void function item_artifact_super_damage();
{
  self.event = "relic";
  self.touch = powerup_touch;
  precache_model("progs/quaddama.mdl");
  precache_sound("items/damage.wav");
  precache_sound("items/damage2.wav");
  precache_sound("items/damage3.wav");
  self.noise = "items/damage.wav";
  setmodel(self, "progs/quaddama.mdl");
  self.netname = "Quad Damage";
  self.items = IT_QUAD;
  setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
  StartItem();
  if (world.model == "maps/nehend.bsp") {
    self.mdl = self.model;
    self.nextthink = time + 125;
    self.think = SUB_regen;
    self.solid = SOLID_NOT;
    self.model = string_null;
    }
}

Void function BackpackTouch();
var
 s : String;
 best : Real;
 old : Real;
 new : Real;
 stemp : Object;
 acount : Real;
{
  if (other.classname != "player") {
    exit;
    }
  if (other.health <= 0) {
    exit;
    }
  acount = 0;
  sprint(other, "You get ");
  if (self.items) {
    if ((other.items & self.items) == 0) {
      acount = 1;
      sprint(other, "the ");
      sprint(other, self.netname);
      }
    }
  stemp = self;
  self = other;
  best = W_BestWeapon();
  self = stemp;
  other.ammo_shells = other.ammo_shells + self.ammo_shells;
  other.ammo_nails = other.ammo_nails + self.ammo_nails;
  other.ammo_rockets = other.ammo_rockets + self.ammo_rockets;
  other.ammo_cells = other.ammo_cells + self.ammo_cells;
  new = self.items;
  if (!new) {
    new = other.weapon;
    }
  old = other.items;
  other.items = other.items | new;
  bound_other_ammo();
  if (self.ammo_shells) {
    if (acount) {
      sprint(other, ", ");
      }
    acount = 1;
    s = ftos(self.ammo_shells);
    sprint(other, s);
    sprint(other, " shells");
    }
  if (self.ammo_nails) {
    if (acount) {
      sprint(other, ", ");
      }
    acount = 1;
    s = ftos(self.ammo_nails);
    sprint(other, s);
    sprint(other, " nails");
    }
  if (self.ammo_rockets) {
    if (acount) {
      sprint(other, ", ");
      }
    acount = 1;
    s = ftos(self.ammo_rockets);
    sprint(other, s);
    sprint(other, " rockets");
    }
  if (self.ammo_cells) {
    if (acount) {
      sprint(other, ", ");
      }
    acount = 1;
    s = ftos(self.ammo_cells);
    sprint(other, s);
    sprint(other, " cells");
    }
  sprint(other, "|");
  sound(other, CHAN_ITEM, "weapons/lock4.wav", 1, ATTN_NORM);
  stuffcmd(other, "bf|");
  remove(self);
  self = other;
  if (!deathmatch) {
    self.weapon = new;
    }
  else {
    Deathmatch_Weapon(old, new);
    }
  W_SetCurrentAmmo();
}

Void function DropBackpack();
var
 item : Object;
{
  if (!(self.ammo_shells + self.ammo_nails + self.ammo_rockets + self.ammo_cells)) {
    exit;
    }
  item = spawn();
  item.origin = self.origin - [0 0 24];
  item.items = self.weapon;
  if (item.items == IT_SWORD) {
    item.netname = "Axe";
    }
  else {
    if (item.items == IT_SHOTGUN) {
      item.netname = "Shotgun";
      }
    else {
      if (item.items == IT_SUPER_SHOTGUN) {
        item.netname = "Double-barrelled Shotgun";
        }
      else {
        if (item.items == IT_AUTO_SHOTGUN) {
          item.netname = "Automatic Shotgun";
          }
        else {
          if (item.items == IT_SUPER_NAILGUN) {
            item.netname = "Nailgun";
            }
          else {
            if (item.items == IT_GRENADE_LAUNCHER) {
              item.netname = "Grenade Launcher";
              }
            else {
              if (item.items == IT_ROCKET_LAUNCHER) {
                item.netname = "Rocket Launcher";
                }
              else {
                if (item.items == IT_LIGHTNING) {
                  item.netname = "Thunderbolt";
                  }
                else {
                  item.netname = "";
                  }
                }
              }
            }
          }
        }
      }
    }
  item.ammo_shells = self.ammo_shells;
  item.ammo_nails = self.ammo_nails;
  item.ammo_rockets = self.ammo_rockets;
  item.ammo_cells = self.ammo_cells;
  item.velocity_z = 300;
  item.velocity_x = -100 + random() * 200;
  item.velocity_y = -100 + random() * 200;
  item.flags = FL_ITEM;
  item.solid = SOLID_TRIGGER;
  item.movetype = MOVETYPE_TOSS;
  setmodel(item, "progs/backpack.mdl");
  setsize(item, [-16 -16 0], [16 16 56]);
  item.touch = BackpackTouch;
  item.nextthink = time + 120;
  item.think = SUB_Remove;
}


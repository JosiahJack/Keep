Void function yield_items();
{
  if (self.ammo_shells > 0) {
    throw_ammo(IT_SHELLS);
    }
  if (self.ammo_cells > 0) {
    throw_ammo(IT_CELLS);
    }
  if (self.ammo_nails > 0) {
    throw_ammo(IT_NAILS);
    }
  if (self.ammo_rockets > 0) {
    throw_ammo(IT_ROCKETS);
    }
  if (self.items & IT_QUAD) {
    throw_item(IT_QUAD);
    }
  if (self.items & IT_SUPER_SHOTGUN) {
    throw_item(IT_SUPER_SHOTGUN);
    }
  if (self.items & IT_AUTO_SHOTGUN) {
    throw_item(IT_AUTO_SHOTGUN);
    }
  if (self.items & IT_SPROCKET) {
    throw_item(IT_SPROCKET);
    }
  if (self.items & IT_SUPER_NAILGUN) {
    throw_item(IT_SUPER_NAILGUN);
    }
  if (self.items & IT_GRENADE_LAUNCHER) {
    throw_item(IT_GRENADE_LAUNCHER);
    }
  if (self.items & IT_ROCKET_LAUNCHER) {
    throw_item(IT_ROCKET_LAUNCHER);
    }
  if (self.items & IT_LIGHTNING) {
    throw_item(IT_LIGHTNING);
    }
  if (self.items & IT_SUPERHEALTH) {
    throw_item(IT_SUPERHEALTH);
    }
  if (self.items & IT_FLIGHT) {
    throw_item(IT_FLIGHT);
    }
  if (self.items & IT_SUIT) {
    throw_item(IT_SUIT);
    }
}

Void function yield_armor();
{
  if (self.armorvalue == 3) {
    throw_item(IT_ARMOR3);
    exit;
    }
  if (self.armorvalue == 2) {
    throw_item(IT_ARMOR2);
    exit;
    }
  if (self.armorvalue == 1) {
    throw_item(IT_ARMOR1);
    exit;
    }
}

Void function precache_thrown(num : Real);
var
 item : Object;
{
  if (num & IT_QUAD) {
    precache_model("progs/quaddama.mdl");
    precache_sound("items/damage.wav");
    precache_sound("items/damage2.wav");
    precache_sound("items/damage3.wav");
    }
  if (num & IT_FLIGHT) {
    precache_model("progs/flying.mdl");
    precache_sound("items/inv1.wav");
    precache_sound("items/inv2.wav");
    precache_sound("items/inv3.wav");
    }
  if (num & IT_SUIT) {
    precache_model("progs/suit.mdl");
    precache_sound("items/suit.wav");
    precache_sound("items/suit2.wav");
    }
  if (num & IT_SUPERHEALTH) {
    precache_model("maps/b_bh25.bsp");
    precache_sound("items/health1.wav");
    }
  precache_model("progs/armor.mdl");
  if (num & IT_SUPER_SHOTGUN) {
    precache_model("progs/g_shot.mdl");
    }
  if (num & IT_AUTO_SHOTGUN) {
    precache_model("progs/mg_sh2.mdl");
    }
  if (num & IT_NAILGUN) {
    precache_model("progs/g_nail.mdl");
    }
  if (num & IT_SUPER_NAILGUN) {
    precache_model("progs/g_nail2.mdl");
    }
  if (num & IT_GRENADE_LAUNCHER) {
    precache_model("progs/g_rock.mdl");
    }
  if (num & IT_ROCKET_LAUNCHER) {
    precache_model("progs/g_rock2.mdl");
    }
  if (num & IT_LIGHTNING) {
    precache_model("progs/g_light.mdl");
    }
  if (num & IT_SPROCKET) {
    precache_model("progs/mg_rock2.mdl");
    }
}

Void function precache_ammo();
var
 item : Object;
{
  if (self.ammo_shells > 0) {
    precache_model("maps/b_shell0.bsp");
    }
  if (self.ammo_nails > 0) {
    precache_model("maps/b_nail0.bsp");
    }
  if (self.ammo_rockets > 0) {
    precache_model("maps/b_rock0.bsp");
    }
  if (self.ammo_cells > 0) {
    precache_model("maps/b_batt0.bsp");
    }
}

Void function throw_item(num : Real);
var
 item : Object;
{
  item = spawn();
  item.origin_x = self.absmin_x + random() * self.size_x;
  item.origin_y = self.absmin_y + random() * self.size_y;
  item.origin_z = self.absmin_z + random() * self.size_z;
  item.velocity_z = 300;
  item.velocity_x = -100 + random() * 200;
  item.velocity_y = -100 + random() * 200;
  item.flags = FL_ITEM;
  item.solid = SOLID_TRIGGER;
  item.movetype = MOVETYPE_TOSS;
  if (num == IT_QUAD) {
    item.classname == "item_artifact_super_damage";
    item.touch = powerup_touch;
    item.noise = "items/damage.wav";
    setmodel(item, "progs/quaddama.mdl");
    item.netname = "Quad Damage";
    item.items = IT_QUAD;
    setsize(item, VEC_HULL_MIN, VEC_HULL_MAX);
    exit;
    }
  if (num == IT_FLIGHT) {
    item.classname = "item_artifact_flight";
    item.touch = powerup_touch;
    item.noise = "items/inv1.wav";
    setmodel(item, "progs/flying.mdl");
    item.netname = "the flying artifact";
    item.items = IT_FLIGHT;
    setsize(item, VEC_HULL_MIN, VEC_HULL_MAX);
    exit;
    }
  if (num == IT_SUIT) {
    item.classname = "item_artifact_envirosuit";
    item.event = "thrownsuit";
    item.noise = "items/suit.wav";
    item.touch = powerup_touch;
    setmodel(item, "progs/suit.mdl");
    item.netname = "Biosuit";
    item.items = IT_SUIT;
    setsize(item, VEC_HULL_MIN, VEC_HULL_MAX);
    exit;
    }
  if (num == IT_ARMOR1) {
    item.classname = "item_armor1";
    item.touch = armor_touch;
    setmodel(item, "progs/armor.mdl");
    item.skin = 0;
    setsize(item, [-16 -16 0], [16 16 56]);
    exit;
    }
  if (num == IT_ARMOR2) {
    item.classname = "item_armor2";
    item.touch = armor_touch;
    setmodel(item, "progs/armor.mdl");
    item.skin = 1;
    setsize(item, [-16 -16 0], [16 16 56]);
    exit;
    }
  if (num == IT_ARMOR3) {
    item.classname = "item_armorInv";
    item.touch = armor_touch;
    setmodel(item, "progs/armor.mdl");
    item.skin = FL_SWIM;
    setsize(item, [-16 -16 0], [16 16 56]);
    exit;
    }
  if (num == IT_SUPER_SHOTGUN) {
    item.classname = "weapon_supershotgun";
    setmodel(item, "progs/g_shot.mdl");
    item.weapon = IT_SUPER_SHOTGUN;
    item.netname = "Double Barrel Shotgun";
    item.touch = weapon_touch;
    setsize(item, [-16 -16 0], [16 16 56]);
    exit;
    }
  if (num == IT_AUTO_SHOTGUN) {
    item.classname = "weapon_gshotgun";
    setmodel(item, "progs/mg_sh2.mdl");
    item.weapon = IT_AUTO_SHOTGUN;
    item.netname = "Auto Shotgun";
    item.touch = weapon_touch;
    setsize(item, [-16 -16 0], [16 16 56]);
    exit;
    }
  if (num == IT_NAILGUN) {
    item.classname = "weapon_nailgun";
    setmodel(item, "progs/g_nail.mdl");
    item.weapon = IT_NAILGUN;
    item.netname = "Nailgun";
    item.touch = weapon_touch;
    setsize(item, [-16 -16 0], [16 16 56]);
    exit;
    }
  if (num == IT_SUPER_NAILGUN) {
    item.classname = "weapon_supernailgun";
    setmodel(item, "progs/g_nail2.mdl");
    item.weapon = IT_SUPER_NAILGUN;
    item.netname = "Super Nailgun";
    item.touch = weapon_touch;
    setsize(item, [-16 -16 0], [16 16 56]);
    exit;
    }
  if (num == IT_GRENADE_LAUNCHER) {
    item.classname = "weapon_grenadelauncher";
    setmodel(item, "progs/g_rock.mdl");
    item.weapon = MOVETYPE_WALK;
    item.netname = "Grenade Launcher";
    item.touch = weapon_touch;
    setsize(item, [-16 -16 0], [16 16 56]);
    exit;
    }
  if (num == IT_ROCKET_LAUNCHER) {
    item.classname = "weapon_rocketlauncher";
    setmodel(item, "progs/g_rock2.mdl");
    item.weapon = MOVETYPE_WALK;
    item.netname = "Rocket Launcher";
    item.touch = weapon_touch;
    setsize(item, [-16 -16 0], [16 16 56]);
    exit;
    }
  if (num == IT_LIGHTNING) {
    item.classname = "weapon_lightning";
    setmodel(item, "progs/g_light.mdl");
    item.weapon = MOVETYPE_WALK;
    item.netname = "Thunderbolt";
    item.touch = weapon_touch;
    setsize(item, [-16 -16 0], [16 16 56]);
    exit;
    }
  if (num == IT_SPROCKET) {
    item.classname = "weapon_sprocket";
    setmodel(item, "progs/mg_rock2.mdl");
    item.weapon = IT_SPROCKET;
    item.netname = "Sprocket Launcher";
    item.touch = weapon_touch;
    setsize(item, [-16 -16 0], [16 16 56]);
    exit;
    }
}

Void function throw_ammo(num : Real);
var
 item : Object;
{
  item = spawn();
  item.origin_x = self.absmin_x + random() * self.size_x;
  item.origin_y = self.absmin_y + random() * self.size_y;
  item.origin_z = self.absmin_z + random() * self.size_z;
  item.velocity_z = 300;
  item.velocity_x = -100 + random() * 200;
  item.velocity_y = -100 + random() * 200;
  item.flags = FL_ITEM;
  item.solid = SOLID_TRIGGER;
  item.movetype = MOVETYPE_TOSS;
  if (num == IT_SHELLS) {
    item.classname = "item_shells";
    item.touch = ammo_touch;
    setmodel(item, "maps/b_shell0.bsp");
    item.aflag = 20;
    item.weapon = 1;
    item.netname = "shells";
    setsize(item, VEC_ORIGIN, [32 32 56]);
    exit;
    }
  if (num == IT_NAILS) {
    item.classname = "item_spikes";
    item.touch = ammo_touch;
    setmodel(item, "maps/b_nail0.bsp");
    item.aflag = 25;
    item.weapon = FL_SWIM;
    item.netname = "nails";
    setsize(item, VEC_ORIGIN, [32 32 56]);
    exit;
    }
  if (num == IT_ROCKETS) {
    item.classname = "item_rockets";
    item.touch = ammo_touch;
    setmodel(item, "maps/b_rock0.bsp");
    item.aflag = MOVETYPE_FLY;
    item.weapon = MOVETYPE_WALK;
    item.netname = "rockets";
    setsize(item, VEC_ORIGIN, [32 32 56]);
    exit;
    }
  item.classname = "item_cells";
  item.touch = ammo_touch;
  setmodel(item, "maps/b_batt0.bsp");
  item.aflag = MOVETYPE_TOSS;
  item.weapon = MOVETYPE_STEP;
  item.netname = "cells";
  setsize(item, VEC_ORIGIN, [32 32 56]);
}



Void function monster_use();
{
  if (self.enemy) {
    exit;
    }
  if (self.health <= 0) {
    exit;
    }
  if (activator.items & IT_INVISIBILITY) {
    exit;
    }
  if (activator.flags & FL_NOTARGET) {
    exit;
    }
  if (activator.classname != "player") {
    exit;
    }
  if (self.classname == "monster_jagger") {
    self.relations = -1;
    }
  if (self.classname == "monster_qforge") {
    qforge_spiel_go();
    exit;
    }
  self.enemy = activator;
  self.nextthink = time + 0.1;
  self.think = FoundTarget;
}

Void function monster_death_use();
var
 ent : Object;
 otemp : Object;
 stemp : Object;
{
  if (self.flags & FL_FLY) {
    self.flags = self.flags - FL_FLY;
    }
  if (self.flags & FL_SWIM) {
    self.flags = self.flags - FL_SWIM;
    }
  self.angles_x = 0;
  if (!(self.target)) {
    exit;
    }
  activator = self.enemy;
  SUB_UseTargets();
}

Void function walkmonster_start_go();
var
 stemp : String;
 etemp : Object;
{
  self.origin_z = self.origin_z + 1;
  droptofloor();
  if (!walkmove(0, 0)) {
    dprint("walkmonster in wall at: ");
    dprint(vtos(self.origin));
    dprint("|");
    }
  self.takedamage = DAMAGE_AIM;
  if (self.th_back) {
    self.touch = objekt_touch;
    }
  self.ideal_yaw = self.angles * [0 1 0];
  if (!(self.yaw_speed)) {
    self.yaw_speed = 20;
    }
  if (self.event) {
    self.objekt = find(world, targetname, self.event);
    self.event = "";
    }
  self.view_ofs = [0 0 25];
  self.use = monster_use;
  self.flags = self.flags | FL_MONSTER;
  if (self.brain & NO_JUMP) {
    self.nojump = 1;
    }
  self.soul = "yes";
  if (self.target) {
    self.goalentity = self.movetarget = find(world, targetname, self.target);
    self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
    if (!(self.movetarget)) {
      dprint("Monster can't find target at ");
      dprint(vtos(self.origin));
      dprint("|");
      }
    if (self.movetarget.classname == "path_corner") {
      self.th_walk();
      }
    else {
      self.pausetime = 100000000;
      self.goalentity = world;
      self.movetarget = world;
      }
    self.th_stand();
    }
  else {
    self.pausetime = 100000000;
    self.th_stand();
    }
  self.nextthink = self.nextthink + random() * 0.5;
}

Void function walkmonster_start();
{
  if (skill == 0) {
    self.health = rint(self.health * 0.75);
    }
  if (skill == 1) {
    self.health = rint(self.health * 0.85);
    }
  self.nextthink = self.nextthink + random() * 0.5;
  self.think = walkmonster_start_go;
}

Void function flymonster_start_go();
{
  self.takedamage = DAMAGE_AIM;
  self.ideal_yaw = self.angles * [0 1 0];
  if (!(self.yaw_speed)) {
    self.yaw_speed = MOVETYPE_BOUNCE;
    }
  if (self.event) {
    self.objekt = find(world, targetname, self.event);
    self.event = "";
    }
  if (self.spawnflags & FL_INWATER) {
    self.flags = self.flags | FL_FLEE;
    }
  self.view_ofs = [0 0 25];
  self.use = monster_use;
  self.flags = self.flags | FL_FLY;
  self.flags = self.flags | FL_MONSTER;
  if (!walkmove(0, 0)) {
    dprint("flymonster in wall at: ");
    dprint(vtos(self.origin));
    dprint("|");
    }
  if (self.target) {
    self.goalentity = self.movetarget = find(world, targetname, self.target);
    if (!(self.movetarget)) {
      dprint("Monster can't find target at ");
      dprint(vtos(self.origin));
      dprint("|");
      }
    if (self.movetarget.classname == "path_corner") {
      self.th_walk();
      }
    else {
      self.pausetime = 100000000;
      }
    self.th_stand();
    }
  else {
    self.pausetime = 100000000;
    self.th_stand();
    }
}

Void function flymonster_start();
{
  if (skill == 0) {
    self.health = rint(self.health * 0.75);
    }
  if (skill == 1) {
    self.health = rint(self.health * 0.85);
    }
  self.nextthink = self.nextthink + random() * 0.5;
  self.think = flymonster_start_go;
}

Void function swimmonster_start_go();
{
  if (deathmatch) {
    remove(self);
    exit;
    }
  self.takedamage = DAMAGE_AIM;
  self.ideal_yaw = self.angles * [0 1 0];
  if (!(self.yaw_speed)) {
    self.yaw_speed = MOVETYPE_BOUNCE;
    }
  self.view_ofs = [0 0 10];
  self.use = monster_use;
  self.flags = self.flags | FL_SWIM;
  self.flags = self.flags | FL_MONSTER;
  if (self.target) {
    self.goalentity = self.movetarget = find(world, targetname, self.target);
    if (!(self.movetarget)) {
      dprint("Monster can't find target at ");
      dprint(vtos(self.origin));
      dprint("|");
      }
    self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
    self.th_walk();
    }
  else {
    self.pausetime = 100000000;
    self.th_stand();
    }
  self.nextthink = self.nextthink + random() * 0.5;
}

Void function swimmonster_start();
{
  self.nextthink = self.nextthink + random() * 0.5;
  self.think = swimmonster_start_go;
}

Void function dead_stay_dead();
{
  self.th_stand = Sub_Null;
  self.th_walk = Sub_Null;
  self.th_run = Sub_Null;
  self.th_melee = Sub_Null;
  self.th_missile = Sub_Null;
  self.th_runfire = Sub_Null;
  self.th_die = Sub_Null;
  self.th_pain = Sub_Null;
  self.use = Sub_Null;
}

Void function corpse_think();
{
  dead_stay_dead();
  self.nextthink = time + (120 * random());
  self.think = corpse_removal;
}

Void function corpse_removal();
var
 head : Object;
 selected : Object;
{
  if (self.soul == "no") {
    head = find(world, classname, "soul_to_take");
    while (head) {
      if (head.objekt == self) {
        selected = head;
        }
      head = find(head, classname, "soul_to_take");
      }
    if (selected != world) {
      corpse_think();
      exit;
      }
    }
  self.alpha = 0.98;
  self.think = corpse_fades;
  self.nextthink = time + 0.1;
}

Void function corpse_fades();
{
  self.alpha = self.alpha - 0.02;
  if (self.alpha < 0.05) {
    remove(self);
    exit;
    }
  self.think = corpse_fades;
  self.nextthink = time + 0.05;
}

Void function spawn_monster();
{
  if (deathmatch > 0) {
    self.classname = "info_player_deathmatch";
    exit;
    }
  if (self.cnt < 1) {
    self.cnt = 10;
    }
  self.frags = self.cnt;
  if (self.delay < 0) {
    self.delay = 5;
    }
  self.delay = self.delay * 20;
  if (self.targetname == "monster_fish") {
    precache_model2("progs/fish.mdl");
    precache_sound2("fish/death.wav");
    precache_sound2("fish/bite.wav");
    precache_sound2("fish/idle.wav");
    }
  else {
    if (self.targetname == "monster_army") {
      precache_model("progs/soldier.mdl");
      precache_model("progs/h_guard.mdl");
      precache_sound("soldier/death1.wav");
      precache_sound("soldier/idle.wav");
      precache_sound("soldier/pain1.wav");
      precache_sound("soldier/pain2.wav");
      precache_sound("soldier/sattck1.wav");
      precache_sound("soldier/sight1.wav");
      precache_sound("player/udeath.wav");
      }
    else {
      if (self.targetname == "monster_qguy") {
        precache_sound("weapons/rocket1i.wav");
        }
      else {
        if (self.targetname == "monster_enforcer") {
          precache_model2("progs/enforcer.mdl");
          precache_model2("progs/h_mega.mdl");
          precache_model2("progs/laser.mdl");
          precache_sound2("enforcer/death1.wav");
          precache_sound2("enforcer/enfire.wav");
          precache_sound2("enforcer/enfstop.wav");
          precache_sound2("enforcer/idle1.wav");
          precache_sound2("enforcer/pain1.wav");
          precache_sound2("enforcer/pain2.wav");
          precache_sound2("enforcer/sight1.wav");
          precache_sound2("enforcer/sight2.wav");
          precache_sound2("enforcer/sight3.wav");
          precache_sound2("enforcer/sight4.wav");
          }
        else {
          if (self.targetname == "monster_dog") {
            precache_model("progs/h_dog.mdl");
            precache_model("progs/dog.mdl");
            precache_sound("dog/dattack1.wav");
            precache_sound("dog/ddeath.wav");
            precache_sound("dog/dpain1.wav");
            precache_sound("dog/dsight.wav");
            precache_sound("dog/idle.wav");
            }
          else {
            if (self.targetname == "monster_knight") {
              precache_model("progs/knight.mdl");
              precache_model("progs/h_knight.mdl");
              precache_sound("knight/kdeath.wav");
              precache_sound("knight/khurt.wav");
              precache_sound("knight/ksight.wav");
              precache_sound("knight/sword1.wav");
              precache_sound("knight/sword2.wav");
              precache_sound("sets/set2_4.wav");
              precache_sound("sets/dml1_4.wav");
              precache_sound("knight/idle.wav");
              }
            else {
              if (self.targetname == "monster_zombie") {
                precache_model("progs/zombie.mdl");
                precache_model("progs/h_zombie.mdl");
                precache_model("progs/zom_gib.mdl");
                precache_sound("zombie/z_idle.wav");
                precache_sound("zombie/z_idle1.wav");
                precache_sound("zombie/z_shot1.wav");
                precache_sound("zombie/z_gib.wav");
                precache_sound("zombie/z_pain.wav");
                precache_sound("zombie/z_pain1.wav");
                precache_sound("zombie/z_fall.wav");
                precache_sound("zombie/z_miss.wav");
                precache_sound("zombie/z_hit.wav");
                precache_sound("zombie/idle_w2.wav");
                }
              else {
                if (self.targetname == "monster_enf2") {
                  precache_model2("progs/mark3.mdl");
                  precache_model2("progs/h_mega.mdl");
                  precache_sound2("enforcer/death1.wav");
                  precache_sound2("enf2/sight1.wav");
                  precache_sound2("enf2/comeon.wav");
                  precache_sound2("enf2/pain1.wav");
                  precache_sound2("enf2/pain2.wav");
                  precache_sound("enf2/sight2.wav");
                  precache_sound("enf2/sight3.wav");
                  precache_sound("enf2/sight4.wav");
                  precache_sound("enf2/sight5.wav");
                  precache_sound("enf2/death1.wav");
                  precache_sound("enf2/death2.wav");
                  precache_sound("enf2/death3.wav");
                  precache_sound("enf2/idle1.wav");
                  precache_sound("enf2/idle2.wav");
                  precache_sound("enf2/idle3.wav");
                  }
                else {
                  error("Not a valid *targetname* on Spawn_Monster|");
                  }
                }
              }
            }
          }
        }
      }
    }
  self.think = spawner_think;
  self.nextthink = time + self.delay;
}

Void function spawner_think();
var
 kount : Real;
 head : Object;
{
  if (self.frags != self.cnt) {
    self.cnt = self.frags;
    }
  kount = 0;
  head = find(world, classname, self.targetname);
  while (head) {
    if (head.health > 0) {
      kount = kount + 1;
      }
    head = find(head, classname, self.targetname);
    }
  if (self.cnt >= kount) {
    spawn_one();
    }
  self.nextthink = time + self.delay;
  self.think = spawner_think;
}

Void function spawn_one();
var
 monster : Object;
{
  monster = spawn();
  monster.angles = self.angles;
  monster.origin_z = monster.origin_z + 1;
  monster.takedamage = DAMAGE_AIM;
  monster.ideal_yaw = monster.angles * [0 1 0];
  monster.classname = self.targetname;
  monster.target = self.target;
  monster.yaw_speed = 20;
  monster.view_ofs = [0 0 25];
  monster.solid = SOLID_SLIDEBOX;
  monster.movetype = MOVETYPE_STEP;
  monster.relations = self.relations;
  monster.impulse = self.impulse;
  if (monster.classname != "monster_zombie") {
    monster.soul = "yes";
    }
  else {
    monster.soul = "undead";
    }
  if (monster.classname == "monster_fish") {
    setmodel(monster, "progs/fish.mdl");
    setsize(monster, VEC_HULL_MIN, [16 16 24]);
    monster.health = 22;
    monster.netname = "fishy";
    monster.th_stand = f_stand1;
    monster.th_walk = f_walk1;
    monster.th_run = f_run1;
    monster.th_die = f_death1;
    monster.th_pain = fish_pain;
    monster.th_melee = f_attack1;
    }
  else {
    if (monster.classname == "monster_qguy") {
      setmodel(monster, "progs/player.mdl");
      setsize(monster, VEC_HULL_MIN, [16 16 40]);
      monster.health = 100;
      monster.th_stand = kguard_stand1;
      monster.th_walk = kguard_walk1;
      monster.th_run = kguard_run1;
      monster.th_pain = kguard_pain;
      monster.th_die = kguard_die;
      monster.th_melee = kguard_atta1;
      monster.th_missile = SUB_Null;
      }
    else {
      if (monster.classname == "monster_army") {
        setmodel(monster, "progs/soldier.mdl");
        setsize(monster, VEC_HULL_MIN, [16 16 40]);
        monster.health = 40;
        monster.th_stand = army_stand1;
        monster.th_walk = army_walk1;
        monster.th_run = army_run1;
        monster.th_missile = army_atk1;
        monster.th_pain = army_pain;
        monster.th_die = army_die;
        monster.th_runfire = army_runshot1;
        }
      else {
        if (monster.classname == "monster_enforcer") {
          setmodel(monster, "progs/enforcer.mdl");
          setsize(monster, VEC_HULL_MIN, [16 16 40]);
          monster.health = 90;
          monster.th_stand = enf_stand1;
          monster.th_walk = enf_walk1;
          monster.th_run = enf_run1;
          monster.th_pain = enf_pain;
          monster.th_die = enf_die;
          monster.th_missile = enf_atk1;
          monster.th_runfire = enf_runfire1;
          }
        else {
          if (monster.classname == "monster_enf2") {
            setmodel(monster, "progs/mark3.mdl");
            setsize(monster, VEC_HULL_MIN, [16 16 40]);
            monster.health = 150;
            monster.th_stand = mark3_dstand;
            monster.th_walk = mark3_walk1;
            monster.th_run = mark3_run1;
            monster.th_pain = mark3_pain;
            monster.th_die = mark3_die;
            monster.th_missile = mark3_atk1;
            monster.th_runfire = enf2_runfire1;
            }
          else {
            if (monster.classname == "monster_dog") {
              setmodel(monster, "progs/dog.mdl");
              setsize(monster, VEC_HULL2_MIN, [32 32 40]);
              monster.health = 27;
              monster.th_stand = dog_stand1;
              monster.th_walk = dog_walk1;
              monster.th_run = dog_run1;
              monster.th_pain = dog_pain;
              monster.th_die = dog_die;
              monster.th_melee = dog_atta1;
              monster.th_missile = dog_leap1;
              }
            else {
              if (monster.classname == "monster_knight") {
                setmodel(monster, "progs/knight.mdl");
                setsize(monster, VEC_HULL_MIN, [16 16 40]);
                monster.health = 77;
                monster.th_stand = knight_stand1;
                monster.th_walk = knight_walk1;
                monster.th_run = knight_run1;
                monster.th_melee = knight_atk1;
                monster.th_pain = knight_pain;
                monster.th_die = knight_die;
                }
              else {
                if (monster.classname == "monster_zombie") {
                  setmodel(monster, "progs/zombie.mdl");
                  setsize(monster, VEC_HULL_MIN, [16 16 40]);
                  monster.health = 60;
                  monster.th_stand = zombie_stand1;
                  monster.th_walk = zombie_walk1;
                  monster.th_run = zombie_run1;
                  monster.th_pain = zombie_pain;
                  monster.th_die = zombie_die;
                  monster.th_missile = zombie_missile;
                  }
                else {
                  bprint("error in spawn.qc|");
                  bprint(monster.classname);
                  bprint(" is not supported|");
                  remove(self);
                  exit;
                  }
                }
              }
            }
          }
        }
      }
    }
  setorigin(monster, self.origin);
  monster.use = monster_use;
  spawn_tdeath(monster.origin, monster);
  setorigin(monster, self.origin);
  if (self.method == 1) {
    spawn_irritant(monster);
    }
  if (monster.classname != "monster_fish") {
    spawn_tfog(monster.origin);
    }
  monster.think = walkmonster_start;
  monster.nextthink = time + 0.2;
}

Void function spawn_irritant(monster : Object);
var
 head : Object;
{
  head = spawn();
  head.objekt = monster;
  head.think = irritate_monster;
  head.nextthink = time + 0.2;
}

Void function irritate_monster();
{
  self.objekt.enemy = find(world, classname, "player");
  if (self.objekt.enemy != world) {
    T_Damage(self.objekt, self.objekt.enemy, self.objekt.enemy, 1);
    remove(self);
    }
  self.think = irritate_monster;
  self.nextthink = time + 0.5;
}

Void function borkfactor1();
{
  if (self.health < 1) {
    dprint("borkfactor1: rare bug|");
    self.th_die();
    return 1;
    exit;
    }
  return 0;
}

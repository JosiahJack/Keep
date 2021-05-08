Void function Deathmatch5();
{
  self.ammo_rockets = 10;
  self.ammo_nails = 50;
  self.ammo_shells = 52;
  self.items = self.items | IT_SWORD | IT_NAILGUN | IT_SHOTGUN | IT_SUPER_SHOTGUN | IT_AUTO_SHOTGUN | IT_SUPER_NAILGUN | IT_GRENADE_LAUNCHER | IT_ROCKET_LAUNCHER | IT_KEY1 | IT_KEY2;
  self.ammo_cells = 50;
  self.items = self.items | IT_LIGHTNING | IT_SPROCKET;
  self.regen = 30;
  self.weapon = IT_SUPER_SHOTGUN;
  self.impulse = 0;
  W_SetCurrentAmmo();
}

Void function dm3_adjustscores(belf : object; num : Real);
{
  if (deathmatch != 3) {
    exit;
    }
  if (belf.pmodel == 0) {
    tscore0 = tscore0 + num;
    }
  if (belf.pmodel == 1) {
    tscore1 = tscore1 + num;
    }
  if (belf.pmodel == 2) {
    tscore2 = tscore2 + num;
    }
  if (belf.pmodel == 3) {
    tscore3 = tscore3 + num;
    }
  if (belf.pmodel == 4) {
    tscore4 = tscore4 + num;
    }
  if (belf.pmodel == 5) {
    tscore5 = tscore5 + num;
    }
}

Void function dm3_showscores();
{
  if (deathmatch != 3) {
    exit;
    }
  sprint(self, "DEATHMATCH 3 SCORES|");
  sprint(self, "###################|");
  sprint(self, "Marines       ");
  sprint(self, ftos(tscore0));
  sprint(self, "|");
  sprint(self, "Grunts        ");
  sprint(self, ftos(tscore1));
  sprint(self, "|");
  sprint(self, "Lab Guys      ");
  sprint(self, ftos(tscore2));
  sprint(self, "|");
  sprint(self, "Ogre Mutants  ");
  sprint(self, ftos(tscore3));
  sprint(self, "|");
  sprint(self, "Bents         ");
  sprint(self, ftos(tscore4));
  sprint(self, "|");
  sprint(self, "Jacks         ");
  sprint(self, ftos(tscore5));
  sprint(self, "|###################|");
}

Void function PmodelChanged();
{
  if (self.oldpmodel == self.pmodel) {
    return 0;
    }
  if (self.pmodel_time > time) {
    return 0;
    }
  self.pmodel_time = time + 3;
  self.oldpmodel = self.pmodel;
  ClientPmodelChange();
  return 1;
}

Void function ClientPmodelChange();
{
  if (self.health < 1) {
    erase_deadstate();
    }
  bprint(self.netname);
  bprint(" respawns as ");
  if (self.pmodel == 0) {
    bprint("quake marine|");
    }
  else {
    if (self.pmodel == 1) {
      bprint("grunt|");
      }
    else {
      if (self.pmodel == 2) {
        bprint("labguy|");
        }
      else {
        if (self.pmodel == 3) {
          bprint("ogre mutant|");
          }
        else {
          if (self.pmodel == 4) {
            bprint("Bent|");
            }
          else {
            bprint("Jack|");
            }
          }
        }
      }
    }
  set_suicide_frame();
  self.angles_x = 0;
  self.angles_z = 0;
  self.modelindex = self.modelindex_player;
  respawn();
}

Void function select_pmodel();
var
 num : Real;
{
  if (deathmatch < 1 && coop < 1) {
    self.skin = 0;
    if (self.objekt != world) {
      set_playmodel_special();
      exit;
      }
    setmodel(self, "progs/player1.mdl");
    exit;
    }
  self.oldpmodel = self.pmodel;
  num = self.pmodel;
  if (num == 5) {
    self.skin = 0;
    setmodel(self, "progs/player1.mdl");
    exit;
    }
  if (num < 0 || num > 5) {
    num = 0;
    }
  self.skin = num;
  setmodel(self, "progs/player2.mdl");
}

Void function display_dm3outcome();
{
  if (deathmatch != 3) {
    exit;
    }
  bprint("DEATHMATCH 3 SCORES|");
  bprint("###################|");
  bprint("Marines       ");
  bprint(ftos(tscore0));
  bprint("|");
  bprint("Grunts        ");
  bprint(ftos(tscore1));
  bprint("|");
  bprint("Lab Guys      ");
  bprint(ftos(tscore2));
  bprint("|");
  bprint("Ogre Mutants  ");
  bprint(ftos(tscore3));
  bprint("|");
  bprint("Bents         ");
  bprint(ftos(tscore4));
  bprint("|");
  bprint("Jacks         ");
  bprint(ftos(tscore5));
  bprint("|###################|");
}

Void function set_playmodel_special();
var
 num : Real;
{
  num = self.objekt.pmodel;
  if (num == 5) {
    self.skin = 0;
    setmodel(self, "progs/player1.mdl");
    exit;
    }
  if (num < 0 || num > 5) {
    num = 0;
    }
  self.skin = num;
  setmodel(self, "progs/player2.mdl");
}

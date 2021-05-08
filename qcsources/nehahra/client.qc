Void function ResetEnemies(mark : Object);
var
  head : Object;
{
  head = find(world, enemy, mark);
  while (head) {
    if (head.flags & FL_MONSTER) {
      head.enemy = world;
      head.oldenemy = world;
      }
    head = find(head, enemy, mark);
    }
}

Void function IsOnTopOf(Top : object; bottom : object);
var
  Msg : String;
{
  if (Top.absmin_z < Bottom.absmax_z - 3) {
    return 0;
    }
  if (Top.absmin_z > Bottom.absmax_z + 2) {
    return 0;
    }
  if (Top.absmin_y > Bottom.absmax_y) {
    return 0;
    }
  if (Top.absmax_y < Bottom.absmin_y) {
    return 0;
    }
  if (Top.absmin_x > Bottom.absmax_x) {
    return 0;
    }
  if (Top.absmax_x < Bottom.absmin_x) {
    return 0;
    }
  return 1;
}

Void function Client_Ground();
var
 msg : String;
{
  if (other.solid == SOLID_BBOX || other.solid == SOLID_SLIDEBOX) {
    if (IsOnTopOf(self, other)) {
      self.flags = self.flags | FL_ONGROUND;
      }
    }
}

Void function demofunc_getparms();
{
  parm1 = cvar("nehx01");
  nehx01 = parm1;
  parm2 = cvar("nehx02");
  nehx02 = parm2;
  parm3 = cvar("nehx03");
  nehx03 = parm3;
  parm4 = cvar("nehx04");
  nehx04 = parm4;
  parm5 = cvar("nehx05");
  nehx05 = parm5;
  parm6 = cvar("nehx06");
  nehx06 = parm6;
  parm7 = cvar("nehx07");
  nehx07 = parm7;
  parm8 = cvar("nehx08");
  nehx08 = parm8;
  parm9 = cvar("nehx09");
  nehx09 = parm9;
  parm10 = cvar("nehx10");
  nehx10 = parm10;
  parm11 = cvar("nehx11");
  nehx11 = parm11;
  parm12 = cvar("nehx12");
  nehx12 = parm12;
  parm13 = cvar("nehx13");
  nehx13 = parm13;
  parm14 = cvar("nehx14");
  nehx14 = parm14;
  cvar_set("viewsize", ftos(parm13));
  cvar_set("nehx15", "0");
  nehx15 = 1;
}

Void function feedstoredparms();
{
  cvar_set("nehx01", ftos(nehx01));
  cvar_set("nehx02", ftos(nehx02));
  cvar_set("nehx03", ftos(nehx03));
  cvar_set("nehx04", ftos(nehx04));
  cvar_set("nehx05", ftos(nehx05));
  cvar_set("nehx06", ftos(nehx06));
  cvar_set("nehx07", ftos(nehx07));
  cvar_set("nehx08", ftos(nehx08));
  cvar_set("nehx09", ftos(nehx09));
  cvar_set("nehx10", ftos(nehx10));
  cvar_set("nehx11", ftos(nehx11));
  cvar_set("nehx12", ftos(nehx12));
  cvar_set("nehx13", ftos(nehx13));
  cvar_set("nehx14", "777");
  cvar_set("nehx15", "1");
}

Void function demofunc_storeparms();
var
 num : Real;
{
  self.items = self.items - (self.items & (IT_KEY1 | IT_KEY2 | IT_INVISIBILITY | IT_INVULNERABILITY | IT_SUIT | IT_QUAD));
  if (self.health > 100) {
    self.health = 100;
    }
  if (self.health < 50) {
    self.health = 50;
    }
  cvar_set("nehx01", ftos(self.items));
  cvar_set("nehx02", ftos(self.health));
  cvar_set("nehx03", ftos(self.armorvalue));
  if (self.ammo_shells < 25) {
    cvar_set("nehx04", "25");
    }
  else {
    cvar_set("nehx04", ftos(self.ammo_shells));
    }
  cvar_set("nehx05", ftos(self.ammo_nails));
  cvar_set("nehx06", ftos(self.ammo_rockets));
  cvar_set("nehx07", ftos(self.ammo_cells));
  cvar_set("nehx08", ftos(self.weapon));
  cvar_set("nehx09", ftos(self.armortype * 100));
  cvar_set("nehx10", ftos(self.items2));
  cvar_set("nehx11", ftos(self.lives));
  cvar_set("nehx12", ftos(self.regen));
  num = cvar("viewsize");
  cvar_set("nehx13", ftos(num));
  cvar_set("nehx14", "777");
  cvar_set("nehx15", "0");
}

Void function SetChangeParms();
{
  if (self.health <= 0) {
    SetNewParms();
    exit;
    }
  self.items = self.items - (self.items & (IT_KEY1 | IT_KEY2 | IT_INVISIBILITY | IT_INVULNERABILITY | IT_SUIT | IT_QUAD));
  if (self.health > 100) {
    self.health = 100;
    }
  if (self.health < 50) {
    self.health = 50;
    }
  parm1 = self.items;
  parm2 = self.health;
  parm3 = self.armorvalue;
  if (self.ammo_shells < 25) {
    parm4 = 25;
    }
  else {
    parm4 = self.ammo_shells;
    }
  parm5 = self.ammo_nails;
  parm6 = self.ammo_rockets;
  parm7 = self.ammo_cells;
  parm8 = self.weapon;
  parm9 = self.armortype * 100;
  parm10 = self.items2;
  parm11 = self.lives;
  parm12 = self.regen;
}

Void function SetNewParms();
{
  parm1 = IT_SHOTGUN | IT_SWORD;
  parm2 = 100;
  parm3 = 0;
  parm4 = 25;
  parm5 = 0;
  parm6 = 0;
  parm7 = 0;
  parm8 = 1;
  parm9 = 0;
  parm10 = 0;
  parm11 = 1;
  parm12 = 0;
}

Void function DecodeLevelParms();
var
 num : Real;
 t : Real;
{
  if (serverflags) {
    if (world.model == "maps/start.bsp") {
      SetNewParms();
      }
    }
  if (!(deathmatch)) {
    if (!(coop)) {
      num = cvar("cutscene");
      if (num == 1) {
        num = cvar("nehx15");
        if (num == 1) {
          t = cvar("nehx14");
          if (t == 777) {
            demofunc_getparms();
            if (parm2 < 50) {
              parm2 = 50;
              }
            }
          }
        }
      }
    }
  self.items = parm1;
  self.health = parm2;
  self.armorvalue = parm3;
  self.ammo_shells = parm4;
  self.ammo_nails = parm5;
  self.ammo_rockets = parm6;
  self.ammo_cells = parm7;
  self.weapon = parm8;
  self.armortype = parm9 * 0.010000;
  self.items2 = parm10;
  self.lives = parm11;
  self.regen = parm12;
}

Object function FindIntermission();
var
 spot : Object;
 cyc : Real;
{
  spot = find(world, classname, "info_intermission");
  if (spot) {
    cyc = random() * MOVETYPE_STEP;
    while (cyc > 1) {
      spot = find(spot, classname, "info_intermission");
      if (!spot) {
        spot = find(spot, classname, "info_intermission");
        }
      cyc = cyc - 1;
      }
    return spot;
    }
  spot = find(world, classname, "info_player_start");
  if (spot) {
    return spot;
    }
  spot = find(world, classname, "testplayerstart");
  if (spot) {
    return spot;
    }
  objerror("FindIntermission: no spot");
}

Void function GotoNextMap();
var
 num : Real;
{
  num = cvar("cutscene");
  if (num == 1) {
    if (self.demo) {
      if (world.model == "maps/nehstart.bsp") {
        stuffcmd(self, "nehx15 1|");
        }
      stuffcmd(self, "r_oldsky 0|");
      stuffcmd(self, "playdemo ");
      stuffcmd(self, self.demo);
      stuffcmd(self, "|");
      exit;
      }
    }
  if (cvar("samelevel")) {
    changelevel(mapname);
    }
  else {
    changelevel(nextmap);
    }
}

Void function ExitIntermission();
{
  if (deathmatch) {
    GotoNextMap();
    exit;
    }
  intermission_exittime = time + 1;
  intermission_running = intermission_running + 1;
  if (intermission_running == FL_SWIM) {
    if (world.model == "maps/e1m7.bsp") {
      WriteByte(MSG_ALL, SVC_CDTRACK);
      WriteByte(MSG_ALL, FL_SWIM);
      WriteByte(MSG_ALL, MOVETYPE_WALK);
      if (!cvar("registered")) {
        WriteByte(MSG_ALL, SVC_FINALE);
        WriteString(MSG_ALL, "As the corpse of the monstrous entity|Chthon sinks back into the lava whence|it rose, you grip the Rune of Earth|Magic tightly. Now that you have|conquered the Dimension of the Doomed,|realm of Earth Magic, you are ready to|complete your task in the other three|haunted lands of Quake. Or are you? If|you don't register Quake, you'll never|know what awaits you in the Realm of|Black Magic, the Netherworld, and the|Elder World!");
        }
      else {
        WriteByte(MSG_ALL, SVC_FINALE);
        WriteString(MSG_ALL, "As the corpse of the monstrous entity|Chthon sinks back into the lava whence|it rose, you grip the Rune of Earth|Magic tightly. Now that you have|conquered the Dimension of the Doomed,|realm of Earth Magic, you are ready to|complete your task. A Rune of magic|power lies at the end of each haunted|land of Quake. Go forth, seek the|totality of the four Runes!");
        }
      exit;
      }
    else {
      if (world.model == "maps/e2m6.bsp") {
        WriteByte(MSG_ALL, SVC_CDTRACK);
        WriteByte(MSG_ALL, FL_SWIM);
        WriteByte(MSG_ALL, MOVETYPE_WALK);
        WriteByte(MSG_ALL, SVC_FINALE);
        WriteString(MSG_ALL, "The Rune of Black Magic throbs evilly in|your hand and whispers dark thoughts|into your brain. You learn the inmost|lore of the Hell-Mother; Shub-Niggurath!|You now know that she is behind all the|terrible plotting which has led to so|much death and horror. But she is not|inviolate! Armed with this Rune, you|realize that once all four Runes are|combined, the gate to Shub-Niggurath's|Pit will open, and you can face the|Witch-Goddess herself in her frightful|otherworld cathedral.");
        exit;
        }
      else {
        if (world.model == "maps/e3m6.bsp") {
          WriteByte(MSG_ALL, SVC_CDTRACK);
          WriteByte(MSG_ALL, FL_SWIM);
          WriteByte(MSG_ALL, MOVETYPE_WALK);
          WriteByte(MSG_ALL, SVC_FINALE);
          WriteString(MSG_ALL, "The charred viscera of diabolic horrors|bubble viscously as you seize the Rune|of Hell Magic. Its heat scorches your|hand, and its terrible secrets blight|your mind. Gathering the shreds of your|courage, you shake the devil's shackles|from your soul, and become ever more|hard and determined to destroy the|hideous creatures whose mere existence|threatens the souls and psyches of all|the population of Earth.");
          exit;
          }
        else {
          if (world.model == "maps/e4m7.bsp") {
            WriteByte(MSG_ALL, SVC_CDTRACK);
            WriteByte(MSG_ALL, FL_SWIM);
            WriteByte(MSG_ALL, MOVETYPE_WALK);
            WriteByte(MSG_ALL, SVC_FINALE);
            WriteString(MSG_ALL, "Despite the awful might of the Elder|World, you have achieved the Rune of|Elder Magic, capstone of all types of|arcane wisdom. Beyond good and evil,|beyond life and death, the Rune|pulsates, heavy with import. Patient and|potent, the Elder Being Shub-Niggurath|weaves her dire plans to clear off all|life from the Earth, and bring her own|foul offspring to our world! For all the|dwellers in these nightmare dimensions|are her descendants! Once all Runes of|magic power are united, the energy|behind them will blast open the Gateway|to Shub-Niggurath, and you can travel|there to foil the Hell-Mother's plots|in person.");
            exit;
            }
          else {
            if (world.model == "maps/nehend.bsp") {
              WriteByte(MSG_ALL, SVC_CDTRACK);
              WriteByte(MSG_ALL, FL_SWIM);
              WriteByte(MSG_ALL, MOVETYPE_WALK);
              WriteByte(MSG_ALL, SVC_FINALE);
              WriteString(MSG_ALL, "Wrung from the blood of a thousand|damned, the blood of Max seeps into the|cold metal floor of his otherworld|arena and the spirits of the innumerable|slip away from his lifeless hands.|Their liberated voices echo off the once|dispassionate industrial walls and chase|the chill of fear from your soul.|Even knowing your life on Earth awaits|you in the blink of an eye, you derive|little comfort from your survival.|Although the twisted immortal lies dead,|a gaunt proverb parades through your|mind as if to taunt you with|the possibilities.||'Death is just the beginning.'");
              exit;
              }
            else {
              if (world.model == "maps/nehahra.bsp") {
                WriteByte(MSG_ALL, SVC_CDTRACK);
                WriteByte(MSG_ALL, FL_SWIM);
                WriteByte(MSG_ALL, MOVETYPE_WALK);
                WriteByte(MSG_ALL, SVC_FINALE);
                WriteString(MSG_ALL, "Paralyzed, courage lost to quicksand|and senses deafened by the roar of |the daemonic tornado, your heart  |screams with rage, your lungs labor |for air, as your hands wildly dance,|groping for the nothing.  Leaping,|falling, flying madly through strings of|inner spaces, soaring mindlessly|through Cimmerian abysses on cacophonous|wings of emotion and infinite sound;|madly plunging past unnumbered shapes of|shadow beyond all memory; all these|fantastic things can not overwhelm|the maniacal laughter of the dark|immortal and his commanding hands|that pull you through the|black aether to some unknown end.||The beast Nehahra is laid to rest,|but your troubles are far from over.");
                exit;
                }
              else {
                if (world.model == "maps/neh1m3.bsp") {
                  WriteByte(MSG_ALL, SVC_CDTRACK);
                  WriteByte(MSG_ALL, FL_SWIM);
                  WriteByte(MSG_ALL, MOVETYPE_WALK);
                  WriteByte(MSG_ALL, SVC_FINALE);
                  WriteString(MSG_ALL, "Odds weigh against you but luck is|on your side. Free from the death|enveloping Forge City, you have only a|question mark lingering in the air|to look forward to.  Not knowing what to|expect, not knowing where you're going|or how to get there, you continue on|from the ruins of a human dream and hope| your courage holds strong.||You may very well be alone in your|struggle.");
                  exit;
                  }
                else {
                  if (world.model == "maps/neh1m9.bsp") {
                    WriteByte(MSG_ALL, SVC_CDTRACK);
                    WriteByte(MSG_ALL, FL_SWIM);
                    WriteByte(MSG_ALL, MOVETYPE_WALK);
                    WriteByte(MSG_ALL, SVC_FINALE);
                    WriteString(MSG_ALL, "The battle cries of the vile Vores|and the strange utterances of the|bizarre race of Tsemoch echo through|your thoughts.  Amazed you survived this|long, you leave the last threads of|human civilization behind and boldly|venture into the alien outlands, hoping|to find some means home, knowing you'll|find more death.  So hopeless it|seems.  All the regrets and dreams|from your earthly life flow through your|mind's eye in an endless slideshow.|You cannot die here.|There must be second chances.|You must survive.");
                    exit;
                    }
                  else {
                    if (world.model == "maps/neh3m4.bsp") {
                      WriteByte(MSG_ALL, SVC_CDTRACK);
                      WriteByte(MSG_ALL, FL_SWIM);
                      WriteByte(MSG_ALL, MOVETYPE_WALK);
                      WriteByte(MSG_ALL, SVC_FINALE);
                      WriteString(MSG_ALL, "The bitter taste of adrenaline lingers|on your lips like Stygian wine and the|blood staining your hands feels no|less cold than your own that rushes|through your veins and hammers your|ears long after the warped Archgaunt|fell.  You shudder from the haunts of|memory and the chill of fear cascading|from the black void the tainted grounds|have left on your soul.  It grows and|aches with the death of all conscience.|To survive the evil is to embrace its|rules. To defeat the beast is to become|the beast.  Even knowing home is an eye|blink away, all comfort scatters |with the receding shadows...|");
                      exit;
                      }
                    else {
                      if (world.model == "maps/alk10d.bsp") {
                        WriteByte(MSG_ALL, SVC_CDTRACK);
                        WriteByte(MSG_ALL, FL_SWIM);
                        WriteByte(MSG_ALL, MOVETYPE_WALK);
                        WriteByte(MSG_ALL, SVC_FINALE);
                        WriteString(MSG_ALL, "You've stumbled through underground|caverns of mud and pools of thick blood|from hundreds of slaughtered beasts.|Eventually you found your way to the |decaying stronghold of Shub-Niggurath's|mini-army.  With your bloody rocket|launcher stolen from the remains of a|grunt, you had murdered most of Shub's|frightful army, and finally found her|gory nest. But before you had time to|recover from the ugly view and blast|the hideous hunk into pieces, she used|her powers to teleport you back to your|home.||With her still alive you are|very vulnerable.  But you can only|live on in the hope that Shub|will never bring you back to her world,|in fear of the rest of her army|suffering the same fate you gave|those unfortunate, now dead.");
                        exit;
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    GotoNextMap();
    }
  if (intermission_running == MOVETYPE_WALK) {
    if (!cvar("registered")) {
      WriteByte(MSG_ALL, SVC_SELLSCREEN);
      exit;
      }
    if ((serverflags & 15) == 15) {
      WriteByte(MSG_ALL, SVC_FINALE);
      WriteString(MSG_ALL, "Now, you have all four Runes. You sense|tremendous invisible forces moving to|unseal ancient barriers. Shub-Niggurath|had hoped to use the Runes Herself to|clear off the Earth, but now instead,|you will use them to enter her home and|confront her as an avatar of avenging|Earth-life. If you defeat her, you will|be remembered forever as the savior of|the planet. If she conquers, it will be|as if you had never been born.");
      exit;
      }
    }
  GotoNextMap();
}

Void function IntermissionThink();
var
 num : Real;
{
  if (time < intermission_exittime) {
    exit;
    }
  if (!(self.button0) && !(self.button1) && !(self.button2)) {
    exit;
    }
  if (!(deathmatch)) {
    if (!(coop)) {
      num = cvar("cutscene");
      if (num == 1) {
        if (self.demo) {
          demofunc_storeparms();
          }
        }
      }
    }
  ExitIntermission();
}

Void function execute_changelevel();
var
 pos : Object;
{
  display_dm3outcome();
  intermission_running = 1;
  if (deathmatch) {
    intermission_exittime = time + MOVETYPE_FLY;
    }
  else {
    intermission_exittime = time + FL_SWIM;
    }
  WriteByte(MSG_ALL, SVC_CDTRACK);
  WriteByte(MSG_ALL, MOVETYPE_WALK);
  WriteByte(MSG_ALL, MOVETYPE_WALK);
  pos = FindIntermission();
  other = find(world, classname, "player");
  while (other != world) {
    stuffcmd(other, "stopmod|");
    other.view_ofs = VEC_ORIGIN;
    other.angles = other.v_angle = pos.mangle;
    other.fixangle = 1;
    other.nextthink = time + 0.5;
    other.takedamage = DAMAGE_NO;
    other.solid = SOLID_NOT;
    other.movetype = MOVETYPE_NONE;
    other.modelindex = 0;
    setorigin(other, pos.origin);
    other = find(other, classname, "player");
    }
  WriteByte(MSG_ALL, SVC_INTERMISSION);
}

Void function changelevel_touch();
var
 pos : Object;
{
  if (other.classname != "player") {
    exit;
    }
  if (self.noise) {
    stuffcmd(other, "play2 ");
    stuffcmd(other, self.noise);
    stuffcmd(other, "|");
    }
  if (cvar("noexit")) {
    T_Damage(other, self, self, 50000);
    exit;
    }
  bprint(other.netname);
  bprint(" exited the level|");
  ResetEnemies(other);
  if (!coop) {
    if (!deathmatch) {
      if (self.demo) {
        other.demo = self.demo;
        }
      }
    }
  nextmap = self.map;
  SUB_UseTargets();
  if (self.spawnflags & 1 && deathmatch == 0) {
    GotoNextMap();
    exit;
    }
  self.touch = SUB_Null;
  self.think = execute_changelevel;
  self.nextthink = time + 0.1;
}

Void function trigger_changelevel();
{
  if (world.model == "maps/neh1m3.bsp") {
    self.noise = "cuts1/opening.wav";
    }
  if (world.model == "maps/neh2m6.bsp") {
    self.noise = "cuts1/opening.wav";
    }
  if (world.model == "maps/nehstart.bsp") {
    self.demo = "gamedem1";
    }
  if (world.model == "maps/neh1m6.bsp") {
    self.demo = "gamedem4";
    }
  if (world.model == "maps/neh1m9.bsp") {
    self.demo = "gamedem5";
    self.noise = "cuts1/opening.wav";
    }
  if (world.model == "maps/neh2m4.bsp") {
    self.demo = "gamedem6";
    }
  if (world.model == "maps/neh2m6.bsp") {
    self.demo = "gamedem7";
    }
  if (world.model == "maps/nehend.bsp") {
    self.demo = "gameend";
    }
  if (!(self.map)) {
    objerror("changelevel trigger doesn't have map");
    }
  InitTrigger();
  self.touch = changelevel_touch;
}

Void function respawn();
{
  if (coop) {
    CopyToBodyQue(self);
    setspawnparms(self);
    PutClientInServer();
    }
  else {
    if (deathmatch) {
      CopyToBodyQue(self);
      SetNewParms();
      PutClientInServer();
      }
    else {
      localcmd("stopmod|");
      if (nehx15 == 1) {
        nehx13 = cvar("viewsize");
        feedstoredparms();
        }
      localcmd("restart|");
      }
    }
}

Void function ClientKill();
{
  bprint(self.netname);
  bprint(" suicides|");
  set_suicide_frame();
  self.angles_x = 0;
  self.angles_z = 0;
  self.modelindex = self.modelindex_player;
  self.frags = self.frags - FL_SWIM;
  dm3_adjustscores(self, -2);
  respawn();
}

Void function CheckSpawnPoint(v : Vector);
{
  return 0;
}

Object function SelectSpawnPoint();
var
 spot : Object;
{
  spot = find(world, classname, "testplayerstart");
  if (spot) {
    return spot;
    }
  if (coop || self.classname != "player" || deathmatch == 5) {
    lastspawn = find(lastspawn, classname, "info_player_coop");
    if (lastspawn == world) {
      lastspawn = find(lastspawn, classname, "info_player_start");
      }
    if (lastspawn != world) {
      return lastspawn;
      }
    }
  else {
    if (deathmatch) {
      lastspawn = find(lastspawn, classname, "info_player_deathmatch");
      if (lastspawn == world) {
        lastspawn = find(lastspawn, classname, "info_player_deathmatch");
        }
      if (lastspawn != world) {
        return lastspawn;
        }
      }
    }
  if (serverflags) {
    spot = find(world, classname, "info_player_start2");
    if (spot) {
      return spot;
      }
    }
  spot = find(world, classname, "info_player_start");
  if (!spot) {
    error("PutClientInServer: no info_player_start on level");
    }
  return spot;
}

Void function PutClientInServer();
var
 spot : Object;
{
  self.skin = 0;
  self.oldpmodel = self.pmodel;
  self.classname = "player";
  self.targetname = "player";
  self.health = 100;
  self.takedamage = DAMAGE_AIM;
  self.solid = SOLID_SLIDEBOX;
  self.movetype = MOVETYPE_WALK;
  self.show_hostile = 0;
  self.max_health = 100;
  self.flags = FL_CLIENT;
  self.air_finished = time + 12;
  self.dmg = FL_SWIM;
  self.burn_burning = 0;
  self.super_damage_finished = 0;
  self.radsuit_finished = 0;
  self.invisible_finished = 0;
  self.invincible_finished = 0;
  self.fly_finished = 0;
  self.effects = 0;
  self.invincible_time = 0;
  self.fly_time = 0;
  DecodeLevelParms();
  W_SetCurrentAmmo();
  self.attack_finished = time;
  self.th_pain = player_pain;
  self.th_die = PlayerDie;
  self.deadflag = DEAD_NO;
  self.pausetime = 0;
  spot = SelectSpawnPoint();
  if (spot.forcemodel > 0) {
    self.objekt = spot;
    }
  self.soul = "yes";
  self.origin = spot.origin + [0 0 1];
  self.angles = spot.angles;
  self.fixangle = 1;
  setmodel(self, "progs/s_null.spr");
  self.model = "";
  modelindex_eyes = self.modelindex;
  select_pmodel();
  self.modelindex_player = self.modelindex;
  setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
  self.view_ofs = [0 0 22];
  self.touch = Client_Ground;
  cvar_set("sv_aim", "1.0");
  nospr32 = cvar("nospr32");
  panzy_mode = cvar("nomonsters");
  player_stand1();
  if (deathmatch || coop) {
    makevectors(self.angles);
    spawn_tfog(self.origin + v_forward * 20);
    if (coop && world.model == "maps/nehend.bsp") {
      self.impulse = 0;
      self.attack_finished = time + 0.5;
      Deathmatch5();
      }
    if (deathmatch == 5) {
      self.impulse = 0;
      self.attack_finished = time + 0.5;
      Deathmatch5();
      }
    }
  spawn_tdeath(self.origin, self);
  client_cvarpimp();
}

Void function info_player_start();
{
  self.event = "spawn_point";
  if (world.model == "maps/nehend.bsp") {
    if (deathmatch) {
      deathmatch_nehend();
      exit;
      }
    precache_mr();
    spawn_mister();
    }
}

Void function deathmatch_nehend();
var
 head : Object;
{
  head = find(world, targetname, "deadmax");
  if (head != world) {
    remove(head);
    }
}

Void function info_player_start2();
{
  self.event = "spawn_point";
}

Void function testplayerstart();
{
}

Void function info_player_deathmatch();
{
  if (deathmatch == 5) {
    self.classname = "info_player_coop";
    }
  self.event = "spawn_point";
}

Void function old_deathmatch();
{
  self.mangle = self.angles;
  self.angles = VEC_ORIGIN;
  self.model = "";
  self.origin = self.origin + [0 0 27];
}

Void function info_player_coop();
{
  self.event = "spawn_point";
}

Void function PrintClientScore(c : Object);
{
  if (c.frags > -10 && c.frags < 0) {
    bprint(" ");
    }
  else {
    if (c.frags >= 0) {
      if (c.frags < 100) {
        bprint(" ");
        }
      if (c.frags < MOVETYPE_BOUNCE) {
        bprint(" ");
        }
      }
    }
  bprint(ftos(c.frags));
  bprint(" ");
  bprint(c.netname);
  bprint("|");
}

Void function DumpScore();
var
 e : Object;
 sort : Object;
 walk : Object;
{
  if (world.chain) {
    error("DumpScore: world.chain is set");
    }
  e = find(world, classname, "player");
  sort = world;
  while (e) {
    if (!sort) {
      sort = e;
      e.chain = world;
      }
    else {
      if (e.frags > sort.frags) {
        e.chain = sort;
        sort = e;
        }
      else {
        walk = sort;
        do {
          if (!(walk.chain)) {
            e.chain = world;
            walk.chain = e;
            }
          else {
            if (walk.chain.frags < e.frags) {
              e.chain = walk.chain;
              walk.chain = e;
              }
            else {
              walk = walk.chain;
              }
            }
          } while (walk.chain != e);
        }
      }
    e = find(e, classname, "player");
    }
  bprint("|");
  while (sort) {
    PrintClientScore(sort);
    sort = sort.chain;
    }
  bprint("|");
}

Void function NextLevel();
var
 o : Object;
{
  o = find(world, classname, "trigger_changelevel");
  if (!o || mapname == "start") {
    o = spawn();
    o.map = mapname;
    }
  nextmap = o.map;
  if (o.nextthink < time) {
    o.think = execute_changelevel;
    o.nextthink = time + 0.1;
    }
}

Void function CheckRules();
var
 timelimit : Real;
 fraglimit : Real;
{
  if (gameover) {
    exit;
    }
  timelimit = cvar("timelimit") * 60;
  fraglimit = cvar("fraglimit");
  if (timelimit && time >= timelimit) {
    NextLevel();
    exit;
    }
  if (fraglimit && self.frags >= fraglimit) {
    NextLevel();
    exit;
    }
}

Void function PlayerRiseFromDead();
{
  self.alpha = 0;
  self.effects = self.effects - (self.effects & EF_DIMLIGHT);
  self.items = self.items - (self.items & (IT_INVISIBILITY | IT_INVULNERABILITY | IT_SUIT | IT_QUAD));
  self.super_damage_finished = 0;
  self.super_time = 0;
  self.fly_finished = 0;
  self.invincible_time = 1;
  self.invincible_finished = time + 3.5;
  self.items = self.items | IT_INVULNERABILITY;
  self.effects = self.effects - (self.effects & EF_RED);
  self.health = 100;
  self.takedamage = DAMAGE_AIM;
  self.solid = SOLID_SLIDEBOX;
  self.movetype = MOVETYPE_WALK;
  self.show_hostile = 0;
  self.max_health = 100;
  self.flags = FL_CLIENT;
  self.deadflag = DEAD_NO;
  self.air_finished = time + 12;
  self.dmg = FL_SWIM;
  self.boost = 0;
  self.origin = self.origin + [0 0 1];
  self.fixangle = 1;
  self.view_ofs = [0 0 22];
  self.super_damage_finished = 0;
  self.radsuit_finished = 0;
  self.invisible_finished = 0;
  self.fly_finished = 0;
  self.fly_time = 0;
  self.touch = Client_Ground;
  self.effects = 0;
  self.attack_finished = time;
  self.th_pain = player_pain;
  self.th_die = PlayerDie;
  self.deadflag = DEAD_NO;
  self.pausetime = 0;
  setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
  W_SetCurrentAmmo();
  W_Bestweapon();
  PlayerPreThink();
}

Void function SpawnLifeGiver();
var
 life : Object;
{
  self.effects = self.effects | EF_RED;
  self.alpha = 0.5;
  sound(self, CHAN_WEAPON, "player/dedrise.wav", 1, ATTN_NORM);
  life = spawn();
  life.origin = self.origin;
  life.classname = "lifegiver";
  life.owner = self;
  self.health = 0;
  life.effects = EF_DIMLIGHT;
  life.cnt = -8;
  life.method = 91;
  life.brain = 0;
  life.think = raise_the_client;
  life.nextthink = time + 0.3;
  PlayerDeaththink();
}

Void function raise_the_client();
var
 dead : Object;
 damg : Real;
 num : Real;
 t : Real;
{
  dead = self.owner;
  if (dead.lives == -1) {
    dead.health = 0;
    remove(self);
    exit;
    }
  dead.view_ofs_z = self.cnt;
  num = 23 - dead.view_ofs_z;
  dead.health = 1;
  if (dead.view_ofs_z < 23) {
    self.method = self.method - 1;
    self.brain = self.brain + 1;
    if (self.brain > 3) {
      self.brain = 0;
      dead.view_ofs_z = dead.view_ofs_z + 1;
      }
    self.cnt = dead.view_ofs_z;
    }
  if (self.cnt == 20 && pointcontents(self.origin) == CONTENT_WATER) {
    sound(self, CHAN_BODY, "player/razh20.wav", 1, ATTN_NORM);
    }
  if (self.cnt == 12) {
    sound(self, CHAN_VOICE, "player/razd1.wav", 1, ATTN_NORM);
    }
  if (self.cnt == 9 || self.cnt == 13) {
    sound(self, CHAN_WEAPON, "player/dedrise.wav", 1, ATTN_NORM);
    }
  if (self.cnt == 18) {
    sound(self, CHAN_AUTO, "player/razd2.wav", 1, ATTN_NORM);
    }
  if (random() < 0.5) {
    stuffcmd(dead, "bf|");
    }
  msg_entity = dead;
  Writebyte(1, 10);
  Writeangle(1, dead.v_angle_x);
  Writeangle(1, dead.v_angle_y);
  Writeangle(1, self.method);
  self.nextthink = time + 0.05;
  self.think = raise_the_client;
}

Void function PlayerDeathThink();
var
 old_self : Object;
 forward : Real;
 head : Object;
{
  if (self.flags & FL_ONGROUND) {
    forward = vlen(self.velocity);
    forward = forward - 20;
    if (forward <= 0) {
      self.velocity = VEC_ORIGIN;
      }
    else {
      self.velocity = forward * normalize(self.velocity);
      }
    }
  if (self.deadflag == DEAD_DEAD) {
    if (self.button2 || self.button1 || self.button0) {
      exit;
      }
    self.deadflag = DEAD_RESPAWNABLE;
    exit;
    }
  if (self.view_ofs_z > 22) {
    PlayerRiseFromDead();
    head = find(world, classname, "lifegiver");
    while(head) {
      if (head.owner == self) {
        remove(head);
        }
      head = find(head, classname, "lifegiver");
      }
    exit;
    }
  head = find(world, classname, "lifegiver");
  if (head != world) {
    exit;
    }
  if (!(self.button2) && !(self.button1) && !(self.button0)) {
    exit;
    }
  erase_deadstate();
  if (self.lives > 1) {
    SpawnLifeGiver();
    kill_deathspirits();
    self.lives = self.lives - 1;
    exit;
    }
  self.button0 = 0;
  self.button1 = 0;
  self.button2 = 0;
  respawn();
}

Void function erase_deadstate();
{
  msg_entity = self;
  self.dlmp = 0;
  WriteByte(MSG_ONE, SVC_HIDELMP);
  WriteString(MSG_ONE, "deadstate");
}

Void function PlayerJump();
var
 start : Vector;
 end : Vector;
{
  if (self.flags & FL_WATERJUMP) {
    exit;
    }
  if (self.waterlevel >= FL_SWIM) {
    if (self.watertype == CONTENT_WATER) {
      self.velocity_z = 100;
      }
    else {
      if (self.watertype == CONTENT_SLIME) {
        self.velocity_z = 80;
        }
      else {
        self.velocity_z = 50;
        }
      }
    if (self.swim_flag < time) {
      self.swim_flag = time + 1;
      if (random() < 0.5) {
        sound(self, CHAN_BODY, "misc/water1.wav", 1, ATTN_NORM);
        }
      else {
        sound(self, CHAN_BODY, "misc/water2.wav", 1, ATTN_NORM);
        }
      }
    exit;
    }
  if (!(self.flags & FL_ONGROUND)) {
    exit;
    }
  if (!(self.flags & FL_JUMPRELEASED)) {
    exit;
    }
  self.flags = self.flags - (self.flags & FL_JUMPRELEASED);
  self.flags = self.flags - FL_ONGROUND;
  if (!(self.fly_finished)) {
    self.button2 = 0;
    sound(self, CHAN_BODY, "player/plyrjmp8.wav", 1, ATTN_NORM);
    }
  self.velocity_z = self.velocity_z + 270;
}

Void function WaterMove();
{
  if (self.movetype == MOVETYPE_NOCLIP) {
    exit;
    }
  if (self.health < 0) {
    exit;
    }
  if (self.waterlevel != MOVETYPE_WALK) {
    if (self.air_finished < time) {
      sound(self, CHAN_VOICE, "player/gasp2.wav", 1, ATTN_NORM);
      }
    else {
      if (self.air_finished < time + MOVETYPE_FLYMISSILE) {
        sound(self, CHAN_VOICE, "player/gasp1.wav", 1, ATTN_NORM);
        }
      }
    self.air_finished = time + 12;
    self.dmg = FL_SWIM;
    }
  else {
    if (self.air_finished < time) {
      if (self.pain_finished < time) {
        self.dmg = self.dmg + FL_SWIM;
        if (self.dmg > 15) {
          self.dmg = MOVETYPE_BOUNCE;
          }
        T_Damage(self, world, world, self.dmg);
        self.pain_finished = time + 1;
        }
      }
    }
  if (!(self.waterlevel)) {
    if (self.flags & FL_INWATER) {
      sound(self, CHAN_BODY, "misc/outwater.wav", 1, ATTN_NORM);
      self.flags = self.flags - FL_INWATER;
      }
    exit;
    }
  if (self.watertype == CONTENT_LAVA) {
    if (self.dmgtime < time) {
      if (self.radsuit_finished > time) {
        self.dmgtime = time + 1;
        }
      else {
        self.dmgtime = time + 0.2;
        }
      T_Damage(self, world, world, MOVETYPE_BOUNCE * self.waterlevel);
      }
    }
  else {
    if (self.watertype == CONTENT_SLIME) {
      if (self.dmgtime < time && self.radsuit_finished < time) {
        self.dmgtime = time + 1;
        T_Damage(self, world, world, MOVETYPE_STEP * self.waterlevel);
        }
      }
    }
  if (!(self.flags & FL_INWATER)) {
    if (self.watertype == CONTENT_LAVA) {
      sound(self, CHAN_BODY, "player/inlava.wav", 1, ATTN_NORM);
      }
    if (self.watertype == CONTENT_WATER) {
      sound(self, CHAN_BODY, "player/inh2o.wav", 1, ATTN_NORM);
      }
    if (self.watertype == CONTENT_SLIME) {
      sound(self, CHAN_BODY, "player/slimbrn2.wav", 1, ATTN_NORM);
      }
    self.flags = self.flags + FL_INWATER;
    self.dmgtime = 0;
    }
  if (!(self.flags & FL_WATERJUMP)) {
    self.velocity = self.velocity - 0.8 * self.waterlevel * frametime * self.velocity;
    }
}

Void function CheckWaterJump();
var
 start : Vector;
 end : Vector;
{
  makevectors(self.angles);
  start = self.origin;
  start_z = start_z + FL_CLIENT;
  v_forward_z = 0;
  normalize(v_forward);
  end = start + v_forward * 24;
  traceline(start, end, 1, self);
  if (trace_fraction < 1) {
    start_z = start_z + self.maxs_z - FL_CLIENT;
    end = start + v_forward * 24;
    self.movedir = trace_plane_normal * -50;
    traceline(start, end, 1, self);
    if (trace_fraction == 1) {
      self.flags = self.flags | FL_WATERJUMP;
      self.velocity_z = 225;
      self.flags = self.flags - (self.flags & FL_JUMPRELEASED);
      self.teleport_time = time + FL_SWIM;
      exit;
      }
    }
}

Void function PlayerPreThink();
var
 mspeed : Real;
 aspeed : Real;
 r : Real;
 goback : Object;
{
  if (intermission_running) {
    IntermissionThink();
    exit;
    }
  if (self.view_ofs == VEC_ORIGIN) {
    if (self.script_count < self.script_delay && self.script_time < time) {
      Script_play();
      }
    exit;
    }
  makevectors(self.v_angle);
  CheckRules();
  if (self.deadflag >= DEAD_DEAD) {
    PlayerDeathThink();
    exit;
    }
  WaterMove();
  if (self.waterlevel == FL_SWIM) {
    CheckWaterJump();
    }
  if (self.deadflag == DEAD_DYING) {
    exit;
    }
  if (self.button2) {
    PlayerJump();
    }
  else {
    self.flags = self.flags | FL_JUMPRELEASED;
    }
  if (time < self.pausetime) {
    self.velocity = VEC_ORIGIN;
    }
  if (time > self.attack_finished && self.currentammo == 0 && self.weapon != IT_SWORD) {
    self.weapon = W_BestWeapon();
    W_SetCurrentAmmo();
    }
  if (self.regen > 0) {
    if (self.health > 0 && self.health < 1) {
      self.health = 1;
      }
    if (self.health < self.regen && self.health >= 1) {
      self.health = self.health + (self.regen * 0.05 * frametime);
      exit;
      }
    }
}

Void function ShakePlayer();
var
 num : Real;
{
  if (self.flags & FL_FLEE) {
    if (!(self.flags & FL_ONGROUND)) {
      if (self.jump_flag > -505) {
        self.velocity = self.velocity - random() * [0 0 70];
        }
      }
    else {
      self.velocity = self.velocity + random() * [0 0 75];
      }
    num = 2;
    if (world.model == "maps/hehend.bsp" && hknight_type == 666) {
      num = 5;
      }
    else {
      if (random() < 0.5) {
        self.view_ofs_x = num;
        }
      else {
        self.view_ofs_x = num * -1;
        }
      if (random() < 0.5) {
        self.view_ofs_y = num;
        }
      else {
        self.view_ofs_y = num * -1;
        }
      if (random() < 0.5) {
        self.view_ofs_z = 22 + num;
        }
      else {
        self.view_ofs_z = 22 - num;
        }
      }
    }
  else {
    if (self.view_ofs != [0 0 22]) {
      self.view_ofs = [0 0 22];
      }
    if (self.v_angle_z != 0) {
      msg_entity = self;
      Writebyte(1, 10);
      Writeangle(1, self.v_angle_x);
      Writeangle(1, self.v_angle_y);
      Writeangle(1, 0);
      self.v_angle_z = 0;
      }
    }
}

Void function FlyJump();
var
 start : Vector;
 end : Vector;
{
  self.flags = self.flags - (self.flags & FL_JUMPRELEASED);
  self.velocity_x = self.velocity_x * 1.01;
  self.velocity_y = self.velocity_y * 1.01;
  if (self.velocity_z < 300) {
    self.velocity_z = self.velocity_z + 80;
    }
  if (self.flags & FL_ONGROUND) {
    self.flags = self.flags - FL_ONGROUND;
    }
  if (self.fly_sound < time) {
    self.fly_sound = time + 0.8;
    sound(self, CHAN_AUTO, "player/flight.wav", 1, ATTN_NORM);
    }
}

Void function CheckPowerups();
{
  if (self.health <= 0) {
    exit;
    }
  if (self.invisible_finished) {
    if (self.invisible_sound < time) {
      sound(self, CHAN_AUTO, "items/inv3.wav", 0.5, ATTN_IDLE);
      self.invisible_sound = time + (random() * MOVETYPE_WALK + 1);
      }
    if (self.invisible_finished < time + MOVETYPE_WALK) {
      if (self.invisible_time == 1) {
        sprint(self, "Ring of Shadows magic is fading|");
        stuffcmd(self, "bf|");
        sound(self, CHAN_AUTO, "items/inv2.wav", 1, ATTN_NORM);
        self.invisible_time = time + 1;
        }
      if (self.invisible_time < time) {
        self.invisible_time = time + 1;
        stuffcmd(self, "bf|");
        }
      }
    if (self.invisible_finished < time) {
      self.items = self.items - IT_INVISIBILITY;
      self.invisible_finished = 0;
      self.invisible_time = 0;
      }
    self.frame = 0;
    self.modelindex = modelindex_eyes;
    }
  else {
    self.modelindex = self.modelindex_player;
    }
  if (self.invincible_finished) {
    if (self.invincible_finished < time + MOVETYPE_WALK) {
      if (self.invincible_time == 1) {
        sprint(self, "Protection is almost burned out|");
        stuffcmd(self, "bf|");
        sound(self, CHAN_AUTO, "items/protect2.wav", 1, ATTN_NORM);
        self.invincible_time = time + 1;
        }
      if (self.invincible_time < time) {
        self.invincible_time = time + 1;
        stuffcmd(self, "bf|");
        }
      }
    if (self.invincible_finished < time) {
      self.items = self.items - IT_INVULNERABILITY;
      self.invincible_time = 0;
      self.invincible_finished = 0;
      }
    if (self.invincible_finished > time) {
      self.effects = self.effects | EF_DIMLIGHT;
      }
    else {
      self.effects = self.effects - (self.effects & EF_DIMLIGHT);
      }
    }
  if (self.super_damage_finished) {
    if (self.super_damage_finished < time + MOVETYPE_WALK) {
      if (self.super_time == 1) {
        sprint(self, "Quad Damage is wearing off|");
        stuffcmd(self, "bf|");
        sound(self, CHAN_AUTO, "items/damage2.wav", 1, ATTN_NORM);
        self.super_time = time + 1;
        }
      if (self.super_time < time) {
        self.super_time = time + 1;
        stuffcmd(self, "bf|");
        }
      }
    if (self.super_damage_finished < time) {
      self.items = self.items - IT_QUAD;
      self.super_damage_finished = 0;
      self.super_time = 0;
      }
    if (self.super_damage_finished > time) {
      self.effects = self.effects | EF_DIMLIGHT;
      }
    else {
      self.effects = self.effects - (self.effects & EF_DIMLIGHT);
      }
    }
  if (self.radsuit_finished) {
    self.air_finished = time + 12;
    if (self.radsuit_finished < time + MOVETYPE_WALK) {
      if (self.rad_time == 1) {
        sprint(self, "Air supply in Biosuit expiring|");
        stuffcmd(self, "bf|");
        sound(self, CHAN_AUTO, "items/suit2.wav", 1, ATTN_NORM);
        self.rad_time = time + 1;
        }
      if (self.rad_time < time) {
        self.rad_time = time + 1;
        stuffcmd(self, "bf|");
        }
      }
    if (self.radsuit_finished < time) {
      self.items = self.items - IT_SUIT;
      self.rad_time = 0;
      self.radsuit_finished = 0;
      }
    }
  if (self.fly_finished) {
    if (self.fly_finished < time + MOVETYPE_WALK) {
      if (self.fly_time == 1) {
        sprint(self, "Fly time almost gone|");
        stuffcmd(self, "bf|");
        self.fly_time = time + 1;
        }
      if (self.fly_time < time) {
        self.fly_time = time + 1;
        stuffcmd(self, "bf|");
        }
      }
    if (self.fly_finished < time) {
      self.fly_finished = 0;
      self.fly_time = 0;
      }
    }
}

Void function PlayerPostThink();
var
 mspeed : Real;
 aspeed : Real;
 r : Real;
 num : Real;
{
  if (self.view_ofs == VEC_ORIGIN) {
    exit;
    }
  if (deathmatch || coop) {
    if (PmodelChanged()) {
      exit;
      }
    }
  if (self.deadflag) {
    exit;
    }
  if (time > self.attack_finished) {
    self.event = "";
    }
  W_WeaponFrame();
  if (self.jump_flag < -300 && (self.flags & FL_ONGROUND) && self.health > 0) {
    if (self.watertype == CONTENT_WATER) {
      sound(self, CHAN_BODY, "player/h2ojump.wav", 1, ATTN_NORM);
      }
    else {
      if (self.jump_flag < -630) {
        num = rint((self.jump_flag + 600) * -0.1);
        T_Damage(self, world, world, num);
        sound(self, CHAN_VOICE, "player/land2.wav", 1, ATTN_NORM);
        self.deathtype = "falling";
        }
      else {
        sound(self, CHAN_VOICE, "player/land.wav", 1, ATTN_NORM);
        }
      }
    self.jump_flag = 0;
    }
  if (!(self.flags & FL_ONGROUND)) {
    self.jump_flag = self.velocity_z;
    }
  if (self.fly_finished || deathmatch == 4) {
    if (self.button2) {
      FlyJump();
      }
    }
  CheckPowerups();
  ShakePlayer();
  self.movedir = self.velocity;
}

Void function ClientConnect();
{
  bprint(self.netname);
  bprint(" entered the game|");
  if (intermission_running) {
    ExitIntermission();
    }
}

Void function ClientDisconnect();
{
  if (gameover) {
    exit;
    }
  bprint(self.netname);
  bprint(" left the game with ");
  bprint(ftos(self.frags));
  bprint(" frags|");
  sound(self, CHAN_BODY, "player/tornoff2.wav", 1, ATTN_NONE);
  set_suicide_frame();
}

Void function kill_deathspirits();
var
 head : Object;
{
  head = find(world, classname, "deathspirit");
  while (head) {
    head.think = Sub_remove;
    head.nextthink = time + 0.2;
    head = find(head, classname, "deathspirit");
    }
}

Void function spawn_deathspirits();
var
 mark : Object;
{
  mark = spawn();
  mark.classname = "deathspirit";
  mark.objekt = self;
  mark.cnt = 0;
  mark.think = deathspirits;
  mark.nextthink = time + 0.3;
}

Void function deathspirits();
{
  if (self.objekt.dlmp > 0) {
    if (self.objekt.health > 0) {
      msg_entity = self.objekt;
      self.objekt.dlmp = 0;
      WriteByte(MSG_ONE, SVC_HIDELMP);
      WriteString(MSG_ONE, "deadstate");
      remove(self);
      exit;
      }
    }
  self.cnt = self.cnt + 1;
  if (self.cnt > 300) {
    remove(self);
    exit;
    }
  self.think = deathspirits;
  self.nextthink = time + 0.3;
}

Void function ClientObituary(targ : Object; attacker : Object);
var
 rnum : Real;
 deathstring : String;
 deathstring2 : String;
{
  rnum = random();
  if (targ.classname == "player") {
    if (attacker.classname == "teledeath") {
      bprint(targ.netname);
      bprint(" was telefragged by the evil ");
      bprint(attacker.owner.netname);
      bprint("|");
      attacker.owner.frags = attacker.owner.frags + 1;
      dm3_adjustscores(attacker.owner, 1);
      exit;
      }
    if (attacker.classname == "teledeath2") {
      bprint("Satan's power deflects ");
      bprint(targ.netname);
      bprint("'s telefrag|");
      targ.frags = targ.frags - 1;
      dm3_adjustscores(targ, -1);
      exit;
      }
    if (attacker.classname == "player") {
      if (targ == attacker) {
        attacker.frags = attacker.frags - 1;
        dm3_adjustscores(attacker, -1);
        bprint(targ.netname);
        if (targ.weapon == FL_GODMODE && targ.waterlevel > 1) {
          bprint(" discharges into the water.|");
          exit;
          }
        if (targ.weapon == FL_INWATER) {
          bprint(" tries to put the pin back in|");
          attacker.boost = 1;
          }
        else {
          attacker.boost = 2;
          if (rnum) {
            bprint(" becomes bored with life|");
            }
          else {
            bprint(" checks if his weapon is loaded|");
            }
          }
        exit;
        }
      else {
        attacker.frags = attacker.frags + 1;
        dm3_adjustscores(attacker, 1);
        rnum = attacker.weapon;
        if (rnum == IT_SWORD) {
          deathstring = " was slashed by ";
          deathstring2 = "|";
          }
        if (rnum == IT_SHOTGUN) {
          deathstring = " chewed on ";
          deathstring2 = "'s boomstick|";
          }
        if (rnum == IT_SUPER_SHOTGUN) {
          deathstring = " ate 2 loads of ";
          deathstring2 = "'s buckshot|";
          }
        if (rnum == IT_AUTO_SHOTGUN) {
          deathstring = " got hosed down by ";
          deathstring2 = "|";
          }
        if (rnum == IT_NAILGUN) {
          deathstring = " was nailed by ";
          deathstring2 = "|";
          }
        if (rnum == IT_SUPER_NAILGUN) {
          deathstring = " was punctured by ";
          deathstring2 = "|";
          }
        if (rnum == IT_GRENADE_LAUNCHER) {
          deathstring = " eats ";
          deathstring2 = "'s pineapple|";
          if (targ.health < -40) {
            deathstring = " was gibbed by ";
            deathstring2 = "'s grenade|";
            }
          }
        if (rnum == IT_ROCKET_LAUNCHER) {
          deathstring = " rides ";
          deathstring2 = "'s rocket|";
          if (targ.health < -40) {
            deathstring = " was gibbed by ";
            deathstring2 = "'s rocket|";
            }
          }
        if (rnum == IT_LIGHTNING) {
          deathstring = " accepts ";
          if (attacker.waterlevel > 1) {
            deathstring2 = "'s discharge|";
            }
          else {
            deathstring2 = "'s shaft|";
            }
          }
        if (rnum == IT_SPROCKET) {
          deathstring = " rides ";
          deathstring2 = "'s sprocket|";
          if (targ.health < -40) {
            deathstring = " was sent to hell on ";
            deathstring2 = "'s sprocket|";
            }
          }
        bprint(targ.netname);
        bprint(deathstring);
        bprint(attacker.netname);
        bprint(deathstring2);
        }
      exit;
      }
    else {
      targ.frags = targ.frags - 1;
      dm3_adjustscores(targ, -1);
      rnum = targ.watertype;
      bprint(targ.netname);
      if (rnum == CONTENT_WATER) {
        if (random() < 0.5) {
          bprint(" sleeps with the fishes|");
          }
        else {
          bprint(" sucks it down|");
          sound(self, CHAN_ITEM, "player/razh20.wav", 1, ATTN_IDLE);
          }
        exit;
        }
      else {
        if (rnum == CONTENT_SLIME) {
          if (random() < 0.5) {
            bprint(" gulped a load of slime|");
            }
          else {
            bprint(" can't exist on slime alone|");
            }
          exit;
          }
        else {
          if (rnum == CONTENT_LAVA) {
            if (!coop && !deathmatch) {
              sound(self, CHAN_AUTO, "ambience/amsizl.wav", 0.2, ATTN_IDLE);
              }
            if (targ.health < -15) {
              bprint(" burst into flames|");
              exit;
              }
            if (random() < 0.5) {
              bprint(" turned into hot slag|");
              }
            else {
              bprint(" visits the Volcano God|");
              }
            exit;
            }
          }
        }
      if (attacker.flags & FL_MONSTER) {
        if (attacker.classname == "monster_army") {
          bprint(" was shot by a Grunt|");
          }
        if (attacker.classname == "monster_army3") {
          bprint(" was nailed by a Grunt|");
          }
        if (attacker.classname == "monster_army2") {
          bprint(" was killed by a Grunt|");
          }
        if (attacker.classname == "monster_army4") {
          bprint(" was killed by a Grunt|");
          }
        if (attacker.classname == "monster_demon1") {
          bprint(" was eviscerated by a Fiend|");
          }
        if (attacker.classname == "monster_dog") {
          bprint(" was mauled by a Rottweiler|");
          }
        if (attacker.classname == "monster_baron") {
          bprint(" became a Baron's thrill kill|");
          }
        if (attacker.classname == "monster_enforcer") {
          bprint(" was blasted by an Enforcer|");
          }
        if (attacker.classname == "monster_shalrath") {
          bprint(" was exploded by a Vore|");
          }
        if (attacker.classname == "monster_fish") {
          bprint(" was fed to the Rotfish|");
          }
        if (attacker.classname == "monster_hell_knight") {
          bprint(" was slain by a Death Knight|");
          }
        if (attacker.classname == "monster_beard") {
          bprint(" was slain by Ghoro|");
          }
        if (attacker.classname == "monster_knight") {
          bprint(" was slashed by a Knight|");
          }
        if (attacker.classname == "monster_ogre" || attacker.classname == "monster_ogre_marksman") {
          bprint(" was destroyed by an Ogre|");
          }
        if (attacker.classname == "monster_jagger") {
          bprint(" was jagged by a Jagger|");
          }
        if (attacker.classname == "monster_cook") {
          if (random() < 0.5) {
            bprint(" becomes the cook's next dish|");
            }
          else {
            bprint(" was panned to death|");
            }
          }
        if (attacker.classname == "the_mister") {
          if (random() < 0.5) {
            bprint(" got owned by Max|");
            }
          else {
            bprint(" was put to shame by Max|");
            }
          }
        if (attacker.classname == "monster_qguy") {
          bprint(" becomes a statistic|");
          }
        if (attacker.classname == "monster_shambler") {
          bprint(" was smashed by a Shambler|");
          }
        if (attacker.classname == "monster_tarbaby") {
          bprint(" was slimed by a Spawn|");
          }
        if (attacker.classname == "monster_vomit") {
          bprint(" was vomited on by a Vomitus|");
          }
        if (attacker.classname == "monster_wizard") {
          bprint(" was scragged by a Scrag|");
          }
        if (attacker.classname == "monster_zombie") {
          bprint(" joins the Zombies|");
          }
        if (attacker.classname == "monster_wraith") {
          bprint(" was killed by a wraith|");
          }
        if (attacker.classname == "monster_gaunt") {
          bprint(" was killed by a gaunt|");
          }
        if (attacker.classname == "monster_enf2") {
          bprint(" was shot by a field enforcer|");
          }
        if (attacker.classname == "monster_enf3") {
          bprint(" was killed by an ogre mutant|");
          }
        if (attacker.classname == "monster_library") {
          bprint(" was killed by an Archgaunt librarian|");
          }
        if (attacker.classname == "monster_archgaunt") {
          bprint(" was exterminated by an ArchGaunt|");
          }
        if (attacker.classname == "monster_oglib|") {
          bprint(" was killed by a rabid librarian|");
          }
        if (attacker.classname == "monster_hunter") {
          bprint(" was taken down by a tsemoch|");
          }
        if (attacker.classname == "monster_nehahra") {
          bprint(" was destroyed by Nehahra|");
          }
        exit;
        }
      if (attacker.classname == "explo_box") {
        bprint(" blew up|");
        exit;
        }
      if (attacker.deathtype == "hotp") {
        if (random() < 0.5) {
          bprint(" fried on a hot plate|");
          exit;
          }
        bprint(" was fried medium rare|");
        exit;
        }
      if (attacker.deathtype == "impaled") {
        if (random() < 0.5) {
          bprint(" was impaled|");
          exit;
          }
        bprint(" lies in pieces|");
        exit;
        }
      if (attacker.deathtype == "diced") {
        if (random() < 0.5) {
          bprint(" goes home in several boxes|");
          exit;
          }
        bprint(" was diced|");
        exit;
        }
      if (attacker.deathtype == "hod") {
        if (random() < 0.5) {
          bprint(" died at the hands of death|");
          exit;
          }
        bprint(" croaked|");
        exit;
        }
      if (attacker.deathtype == "hell") {
        if (random() < 0.5) {
          bprint(" takes a permanent vacation in Hell|");
          exit;
          }
        bprint(" went to Hell the fast way down|");
        exit;
        }
      if (attacker.deathtype == "void") {
        bprint(" fell into the void|");
        exit;
        }
      if (attacker.deathtype == "swal") {
        if (random() < 0.5) {
          bprint(" was swallowed|");
          exit;
          }
        bprint(" made for a tasty meal|");
        exit;
        }
      if (attacker.deathtype == "hotm") {
        bprint(" shouldn't have touched the machinery|");
        exit;
        }
      if (attacker.deathtype == "simple") {
        bprint(" is dead|");
        exit;
        }
      if (attacker.deathtype == "furn") {
        if (random() < 0.5) {
          bprint(" took a walk in the furnace|");
          exit;
          }
        bprint(" fried in the furnace|");
        exit;
        }
      if (attacker.solid == SOLID_BSP && attacker != world) {
        if (random() < 0.4) {
          bprint(" bought the farm|");
          exit;
          }
        bprint(" was squished|");
        exit;
        }
      if (targ.deathtype == "falling") {
        targ.boost = 3;
        targ.deathtype = "";
        bprint(" fell to his death|");
        exit;
        }
      if (attacker.classname == "trap_shooter" || attacker.classname == "trap_spikeshooter") {
        bprint(" was spiked|");
        exit;
        }
      if (attacker.classname == "fireball") {
        bprint(" ate a lavaball|");
        exit;
        }
      if (attacker.classname == "trigger_changelevel") {
        bprint(" tried to leave|");
        exit;
        }
      bprint(" died|");
      }
    }
}


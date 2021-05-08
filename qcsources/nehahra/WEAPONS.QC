Void function W_Precache();
{
  precache_sound("weapons/r_exp3.wav");
  precache_sound("weapons/rocket1i.wav");
  precache_sound("weapons/sgun1.wav");
  precache_sound("weapons/guncock.wav");
  precache_sound("weapons/ric1.wav");
  precache_sound("weapons/shotgn3.wav");
  precache_sound("enforcer/enfstop.wav");
  precache_sound("weapons/shotdud.wav");
  precache_sound("weapons/ric2.wav");
  precache_sound("weapons/ric3.wav");
  precache_sound("weapons/spike2.wav");
  precache_sound("weapons/tink1.wav");
  precache_sound("weapons/grenade.wav");
  precache_sound("weapons/thump.wav");
  precache_sound("weapons/shotgn2.wav");
  precache_sound("weapons/sprocket.wav");
  precache_sound("boss2/pop2.wav");
  precache_sound("weapons/bounce.wav");
  precache_sound("weapons/shotgn2.wav");
}

Real function crandom();
{
  return FL_SWIM * (random() - 0.5);
}

Void function W_FireAxe();
var
 source : Vector;
 org : Vector;
{
  makevectors(self.v_angle);
  source = self.origin + [0 0 16];
  traceline(source, source + v_forward * FL_GODMODE, 0, self);
  if (trace_fraction == 1) {
    exit;
    }
  org = trace_endpos - v_forward * MOVETYPE_STEP;
  if (trace_ent.takedamage) {
    if (random() < 0.4) { 
      if (trace_ent.flags & FL_MONSTER) {
        trace_ent.pain_finished = time + 1.5;
        }
      }
    trace_ent.axhitme = 1;
    SpawnBlood(org, VEC_ORIGIN, 35);
    T_Damage(trace_ent, self, self, 35);
    if (trace_ent.flags & FL_BLOODLESS) {
      sound(self, CHAN_WEAPON, "player/axhit2.wav", 1, ATTN_NORM);
      }
    }
  else {
    sound(self, CHAN_WEAPON, "player/axhit2.wav", 1, ATTN_NORM);
    WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
    WriteByte(MSG_BROADCAST, TE_GUNSHOT);
    WriteCoord(MSG_BROADCAST, org_x);
    WriteCoord(MSG_BROADCAST, org_y);
    WriteCoord(MSG_BROADCAST, org_z);
    }
}

Vector function wall_velocity();
var
 vel : Vector;
{
  vel = normalize(self.velocity);
  vel = normalize(vel + v_up * (random() - 0.5) + v_right * (random() - 0.5));
  vel = vel + FL_SWIM * trace_plane_normal;
  vel = vel * 200;
  return vel_x;
}

Void function SpawnMeatSpray(org : Vector; vel : Vector);
var
 missile : Object;
 mpuff : Object;
{
  missile = spawn();
  missile.owner = self;
  missile.movetype = MOVETYPE_BOUNCE;
  missile.solid = SOLID_NOT;
  makevectors(self.angles);
  missile.velocity = vel;
  missile.velocity_z = missile.velocity_z + 250 + 50 * random();
  missile.avelocity = [3000 1000 2000];
  missile.nextthink = time + 1;
  missile.think = SUB_Remove;
  setmodel(missile, "progs/zom_gib.mdl");
  setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
  setorigin(missile, org);
}

Void function SpawnBlood(org : Vector; vel : Vector; damage : Real);
{
  if (!(trace_ent.flags & FL_BLOODLESS)) {
    particle(org, vel * 0.1, 73, damage * FL_SWIM);
    exit;
    }
  WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
  WriteByte(MSG_BROADCAST, TE_GUNSHOT);
  WriteCoord(MSG_BROADCAST, org_x);
  WriteCoord(MSG_BROADCAST, org_y);
  WriteCoord(MSG_BROADCAST, org_z);
}

Void function spawn_touchblood(damage : Real);
var
 vel : Vector;
{
  if (!(trace_ent.flags & FL_BLOODLESS)) {
    vel = wall_velocity() * 0.2;
    SpawnBlood(self.origin + vel * 0.010000, vel, damage);
    exit;
    }
  WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
  WriteByte(MSG_BROADCAST, TE_SUPERSPIKE);
  WriteCoord(MSG_BROADCAST, self.origin_x);
  WriteCoord(MSG_BROADCAST, self.origin_y);
  WriteCoord(MSG_BROADCAST, self.origin_z);
  remove(self);
}

Void function SpawnChunk(org : Vector; vel : Vector);
{
  particle(org, vel * 0.020000, 0, MOVETYPE_BOUNCE);
}

Void function ClearMultiDamage();
{
  multi_ent = world;
  multi_damage = 0;
}

Void function ApplyMultiDamage();
{
  if (!multi_ent) {
    exit;
    }
  T_Damage(multi_ent, self, self, multi_damage);
}

Void function AddMultiDamage(hit : Object; damage : Real);
{
  if (!hit) {
    exit;
    }
  if (hit != multi_ent) {
    ApplyMultiDamage();
    multi_damage = damage;
    multi_ent = hit;
    }
  else {
    multi_damage = multi_damage + damage;
    }
}

Void function TraceAttack(damage : Real; dir : Vector);
var
 vel : Vector;
 org : Vector;
{
  vel = normalize(dir + v_up * crandom() + v_right * crandom());
  vel = vel + FL_SWIM * trace_plane_normal;
  vel = vel * 200;
  org = trace_endpos - dir * MOVETYPE_STEP;
  if (self.flags & FL_MONSTER) {
    if (trace_ent.flags & FL_MONSTER && trace_ent != self.enemy) {
      exit;
      }
    }
  if (trace_ent.takedamage) {
    SpawnBlood(org, vel * 0.2, damage);
    AddMultiDamage(trace_ent, damage);
    }
  else {
    WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
    WriteByte(MSG_BROADCAST, TE_GUNSHOT);
    WriteCoord(MSG_BROADCAST, org_x);
    WriteCoord(MSG_BROADCAST, org_y);
    WriteCoord(MSG_BROADCAST, org_z);
    }
}

Void function FireBullets(shotcount : Real; dir : Vector; spread : Vector);
var
 direction : Vector;
 src : Vector;
{
  makevectors(self.v_angle);
  src = self.origin + v_forward * MOVETYPE_BOUNCE;
  src_z = self.absmin_z + self.size_z * 0.7;
  ClearMultiDamage();
  while (shotcount > 0) {
    direction = dir + crandom() * spread_x * v_right + crandom() * spread_y * v_up;
    traceline(src, src + direction * FL_WATERJUMP, 0, self);
    if (trace_fraction != 1 && pointcontents(trace_endpos) != CONTENT_SKY) {
      TraceAttack(MOVETYPE_STEP, direction);
      }
    shotcount = shotcount - 1;
    }
  ApplyMultiDamage();
}

Void function W_FireAutoShotgun();
var
 dir : Vector;
 en : Object;
{
  sound(self, CHAN_WEAPON, "weapons/autos.wav", 1, ATTN_NORM);
  self.punchangle_x = CONTENT_LAVA;
  self.currentammo = self.ammo_shells = self.ammo_shells - 1;
  dir = aim(self, 1000000);
  FireBullets(7, dir, [0.10 0.080000 0]);
  walkmove(self.angles_y - 180, 20); 
  if (!(self.flags & FL_ONGROUND)) {
    makevectors(self.angles);
    self.velocity = self.velocity + (v_forward * -100);
    }
  if (self.angles_x < -10) {
    autosh_physics();
    }
}

Void function autosh_physics();
var
 spot1 : Vector;
{
  if (self.velocity_z < -275) {
    self.velocity_z = -275;
    }
  spot1 = self.origin - [0 0 60];
  traceline(self.origin, spot1, 1, self);
  if (trace_fraction == 1) {
    exit;
    }
  makevectors(self.angles);
  self.origin_z = self.origin_z + 1;
  self.velocity = v_forward * -150 + [0 0 150];
  if (self.angles_x < -20) {
    self.velocity_z = 300;
    }
  if (self.flags & FL_ONGROUND) {
    self.flags = self.flags - FL_ONGROUND;
    }
}

Void function W_FireShotgun();
var
 dir : Vector;
{
  sound(self, CHAN_WEAPON, "weapons/guncock.wav", 1, ATTN_NORM);
  self.punchangle_x = CONTENT_SOLID;
  self.currentammo = self.ammo_shells = self.ammo_shells - 1;
  dir = aim(self, 100000);
  FireBullets(MOVETYPE_TOSS, dir, [0.040000 0.040000 0]);
}

Void function W_FireSuperShotgun();
var
 dir : Vector;
 num : Real;
{
  sound(self, CHAN_WEAPON, "weapons/shotgn2.wav", 1, ATTN_NORM);
  self.punchangle_x = CONTENT_SLIME;
  if (self.ammo_shells == 1) {
    num = 1;
    }
  else {
    num = 2;
    }
  self.currentammo = self.ammo_shells = self.ammo_shells - num;
  dir = aim(self, 100000);
  FireBullets(14, dir, [0.14 0.080000 0]);
}

Void function T_MissileTouch();
var
 damg : Real;
{
  if (other == self.owner) {
    exit;
    }
  if (pointcontents(self.origin) == CONTENT_SKY) {
    remove(self);
    exit;
    }
  if (self.flags & FL_MONSTER) {
    damg = 25 + random() * 5;
    T_RadiusDamage(self, self.owner, 60, other);
    }
  else {
    damg = 100 + random() * 20;
    T_RadiusDamage(self, self.owner, 120, other);
    }
  if (other.health) {
    if (other.classname == "monster_shambler") {
      damg = damg * 0.5;
      }
    T_Damage(other, self, self.owner, damg);
    }
  self.origin = self.origin - FL_CLIENT * normalize(self.velocity);
  WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
  WriteByte(MSG_BROADCAST, TE_EXPLOSION);
  WriteCoord(MSG_BROADCAST, self.origin_x);
  WriteCoord(MSG_BROADCAST, self.origin_y);
  WriteCoord(MSG_BROADCAST, self.origin_z);
  if (random() < 0.4) {
    becomeexplosion();
    }
  else {
    becomeexplosion3();
    }
}

Void function W_FireRocket();
var
 missile : Object;
 mpuff : Object;
{
  self.currentammo = self.ammo_rockets = self.ammo_rockets - 1;
  sound(self, CHAN_WEAPON, "weapons/sgun1.wav", 1, ATTN_NORM);
  self.punchangle_x = CONTENT_SOLID;
  missile = spawn();
  missile.owner = self;
  missile.movetype = MOVETYPE_FLYMISSILE;
  missile.solid = SOLID_BBOX;
  missile.classname = "missile";
  missile.event = "thrett";
  makevectors(self.v_angle);
  missile.velocity = aim(self, 950);
  missile.velocity = missile.velocity * 950;
  missile.angles = vectoangles(missile.velocity);
  missile.touch = T_MissileTouch;
  missile.nextthink = time + MOVETYPE_FLY;
  missile.think = SUB_Remove;
  setmodel(missile, "progs/missile.mdl");
  setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
  setorigin(missile, self.origin + v_forward * FL_CLIENT + [0 0 16]);
}

Void function W_FireLightning();
var
 org : Vector;
 cells : Real;
{
  if (self.ammo_cells < 1) {
    self.weapon = W_BestWeapon();
    W_SetCurrentAmmo();
    exit;
    }
  if (self.waterlevel > 1) {
    cells = self.ammo_cells;
    self.ammo_cells = 0;
    W_SetCurrentAmmo();
    T_RadiusDamage(self, self, 35 * cells, world);
    exit;
    }
  if (self.t_width < time) {
    sound(self, CHAN_WEAPON, "weapons/lhit.wav", 1, ATTN_NORM);
    self.t_width = time + 0.6;
    }
  self.punchangle_x = CONTENT_SOLID;
  self.currentammo = self.ammo_cells = self.ammo_cells - 1;
  org = self.origin + [0 0 16];
  traceline(org, org + v_forward * 600, 1, self);
  WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
  WriteByte(MSG_BROADCAST, TE_LIGHTNING2);
  WriteEntity(MSG_BROADCAST, self);
  WriteCoord(MSG_BROADCAST, org_x);
  WriteCoord(MSG_BROADCAST, org_y);
  WriteCoord(MSG_BROADCAST, org_z);
  WriteCoord(MSG_BROADCAST, trace_endpos_x);
  WriteCoord(MSG_BROADCAST, trace_endpos_y);
  WriteCoord(MSG_BROADCAST, trace_endpos_z);
  ClientLightningDamage(self.origin, trace_endpos + v_forward * MOVETYPE_STEP, self, SVC_INTERMISSION);
}

Void function W_GauntLightning();
var
 org : Vector;
 cells : Real;
{
  if (self.ammo_cells < 1) {
    self.weapon = W_BestWeapon();
    W_SetCurrentAmmo();
    exit;
    }
  if (self.waterlevel > 1) {
    cells = self.ammo_cells;
    self.ammo_cells = 0;
    W_SetCurrentAmmo();
    T_RadiusDamage(self, self, 35 * cells, world);
    exit;
    }
  if (self.t_width < time) {
    sound(self, CHAN_WEAPON, "weapons/lhit.wav", 1, ATTN_NORM);
    self.t_width = time + 0.6;
    }
  self.punchangle_x = CONTENT_SOLID;
  self.currentammo = self.ammo_cells = self.ammo_cells - 1;
  org = self.origin + [0 0 16];
  traceline(org, org + v_forward * 600, 1, self);
  WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
  WriteByte(MSG_BROADCAST, TE_LIGHTNING3);
  WriteEntity(MSG_BROADCAST, self);
  WriteCoord(MSG_BROADCAST, org_x);
  WriteCoord(MSG_BROADCAST, org_y);
  WriteCoord(MSG_BROADCAST, org_z);
  WriteCoord(MSG_BROADCAST, trace_endpos_x);
  WriteCoord(MSG_BROADCAST, trace_endpos_y);
  WriteCoord(MSG_BROADCAST, trace_endpos_z);
  ClientLightningDamage(self.origin, trace_endpos + v_forward * MOVETYPE_STEP, self, SVC_INTERMISSION);
}

Void function GrenadeExplode();
{
  self.classname = "nadda";
  self.event = "";
  if (self.flags & FL_MONSTER) {
    T_RadiusDamage(self, self.owner, 30, world);
    }
  else {
    T_RadiusDamage(self, self.owner, 120, world);
    }
  WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
  WriteByte(MSG_BROADCAST, TE_EXPLOSION);
  WriteCoord(MSG_BROADCAST, self.origin_x);
  WriteCoord(MSG_BROADCAST, self.origin_y);
  WriteCoord(MSG_BROADCAST, self.origin_z);
  BecomeExplosion3();
}

Void function GrenadeTouch();
{
  if (other == self.owner) {
    exit;
    }
  if (pointcontents(self.origin) == CONTENT_SKY) {
    remove(self);
    exit;
    }
  if (other.takedamage == DAMAGE_AIM) {
    GrenadeExplode();
    exit;
    }
  sound(self, CHAN_WEAPON, "weapons/bounce.wav", 1, ATTN_NORM);
  if (self.velocity == VEC_ORIGIN) {
    self.avelocity = VEC_ORIGIN;
    }
}

Void function W_FireGrenade();
var
 missile : Object;
 mpuff : Object;
{
  self.currentammo = self.ammo_rockets = self.ammo_rockets - 1;
  sound(self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM);
  self.punchangle_x = CONTENT_SOLID;
  missile = spawn();
  missile.owner = self;
  missile.movetype = MOVETYPE_BOUNCE;
  missile.solid = SOLID_BBOX;
  missile.classname = "grenade";
  missile.event = "thrett";
  makevectors(self.v_angle);
  if (self.v_angle_x) {
    missile.velocity = v_forward * 600 + v_up * 200 + crandom() * v_right * MOVETYPE_BOUNCE + crandom() * v_up * MOVETYPE_BOUNCE;
    }
  else {
    missile.velocity = aim(self, 10000);
    missile.velocity = missile.velocity * 600;
    missile.velocity_z = 200;
    }
  missile.avelocity = [300 300 300];
  missile.angles = vectoangles(missile.velocity);
  missile.touch = GrenadeTouch;
  missile.nextthink = time + 2.5;
  missile.think = GrenadeExplode;
  setmodel(missile, "progs/grenade.mdl");
  setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
  setorigin(missile, self.origin);
}

Void function launch_spike(org : Vector; dir : Vector);
{
  newmis = spawn();
  newmis.owner = self;
  newmis.movetype = MOVETYPE_FLYMISSILE;
  newmis.solid = SOLID_BBOX;
  newmis.angles = vectoangles(dir);
  newmis.touch = spike_touch;
  newmis.classname = "spike";
  if (newmis.owner.classname == "player") {
    newmis.event = "thrett";
    }
  else {
    newmis.event = "mthret";
    }
  newmis.think = SUB_Remove;
  newmis.nextthink = time + MOVETYPE_TOSS;
  setmodel(newmis, "progs/spike.mdl");
  setsize(newmis, VEC_ORIGIN, VEC_ORIGIN);
  setorigin(newmis, org);
  newmis.velocity = dir * 1000;
}

Void function W_FireSuperSpikes();
var
 dir : Vector;
 old : Object;
{
  sound(self, CHAN_WEAPON, "weapons/spike2.wav", 1, ATTN_NORM);
  self.attack_finished = time + 0.2;
  self.currentammo = self.ammo_nails = self.ammo_nails - FL_SWIM;
  dir = aim(self, 1000);
  launch_spike(self.origin + [0 0 16], dir);
  newmis.touch = superspike_touch;
  setmodel(newmis, "progs/s_spike.mdl");
  setsize(newmis, VEC_ORIGIN, VEC_ORIGIN);
  self.punchangle_x = CONTENT_SOLID;
}

Void function W_FireSpikes(ox : Real);
var
 dir : Vector;
 old : Object;
{
  makevectors(self.v_angle);
  if (self.ammo_nails >= FL_SWIM && self.weapon == IT_SUPER_NAILGUN) {
    W_FireSuperSpikes();
    exit;
    }
  if (self.ammo_nails < 1) {
    self.weapon = W_BestWeapon();
    W_SetCurrentAmmo();
    exit;
    }
  sound(self, CHAN_WEAPON, "weapons/nailgun.wav", 1, ATTN_NORM);
  self.attack_finished = time + 0.2;
  self.currentammo = self.ammo_nails = self.ammo_nails - 1;
  dir = aim(self, 1000);
  launch_spike(self.origin + [0 0 16] + v_right * ox, dir);
  self.punchangle_x = CONTENT_SOLID;
}

Void function spike_touch();
var
 rand : Real;
{
  if (other == self.owner) {
    exit;
    }
  if (other.solid == SOLID_TRIGGER) {
    exit;
    }
  if (self.owner.classname == "monster_wizard") {
    if (other.classname == "monster_wizard") {
      remove(self);
      exit;
      }
    }
  if (self.owner.classname == "monster_hell_knight" || self.owner.classname == "monster_baron") {
    if (other.classname == "monster_knight" || other.classname == "monster_hell_knight" || other.classname == "monster_baron") {
      remove(self);
      exit;
      }
    }
  if (pointcontents(self.origin) == CONTENT_SKY) {
    remove(self);
    exit;
    }
  if (other.takedamage) {
    T_Damage(other, self, self.owner, MOVETYPE_FLYMISSILE);
    if (!(other.flags & FL_BLOODLESS)) {
      spawn_touchblood(MOVETYPE_FLYMISSILE);
      }
    else {
      remove(self);
      }
    }
  else {
    WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
    if (self.classname == "wizspike") {
      WriteByte(MSG_BROADCAST, TE_WIZSPIKE);
      }
    else {
      if (self.classname == "wraithspike") {
        WriteByte(MSG_BROADCAST, TE_WIZSPIKE);
        }
      else {
        if (self.classname == "knightspike") {
          WriteByte(MSG_BROADCAST, TE_KNIGHTSPIKE);
          }
        else {
          WriteByte(MSG_BROADCAST, TE_SPIKE);
          }
        }
      }
    WriteCoord(MSG_BROADCAST, self.origin_x);
    WriteCoord(MSG_BROADCAST, self.origin_y);
    WriteCoord(MSG_BROADCAST, self.origin_z);
    }
  remove(self);
}

Void function superspike_touch();
var
 rand : Real;
{
  if (other == self.owner) {
    exit;
    }
  if (other.solid == SOLID_TRIGGER) {
    exit;
    }
  if (pointcontents(self.origin) == CONTENT_SKY) {
    remove(self);
    exit;
    }
  if (other.takedamage) {
    T_Damage(other, self, self.owner, 18);
    if (!(other.flags & FL_BLOODLESS)) {
      spawn_touchblood(18);
      }
    else {
      WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
      WriteByte(MSG_BROADCAST, TE_SUPERSPIKE);
      WriteCoord(MSG_BROADCAST, self.origin_x);
      WriteCoord(MSG_BROADCAST, self.origin_y);
      WriteCoord(MSG_BROADCAST, self.origin_z);
      remove(self);
      exit;
      }
    }
  else {
    WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
    WriteByte(MSG_BROADCAST, TE_SUPERSPIKE);
    WriteCoord(MSG_BROADCAST, self.origin_x);
    WriteCoord(MSG_BROADCAST, self.origin_y);
    WriteCoord(MSG_BROADCAST, self.origin_z);
    }
  remove(self);
}

Void function W_SetCurrentAmmo();
{
  player_run();
  self.items = self.items - (self.items & (IT_SHELLS | IT_NAILS | IT_ROCKETS | IT_CELLS));
  if (self.weapon == IT_SWORD) {
    self.currentammo = 0;
    self.weaponmodel = "progs/mv_nad.mdl";
    self.weaponframe = 0;
    }
  else {
    if (self.weapon == IT_SHOTGUN) {
      self.currentammo = self.ammo_shells;
      self.weaponmodel = "progs/v_shot.mdl";
      self.weaponframe = 0;
      self.items = self.items | IT_SHELLS;
      }
    else {
      if (self.weapon == IT_SUPER_SHOTGUN) {
        self.currentammo = self.ammo_shells;
        self.weaponmodel = "progs/v_shot2.mdl";
        self.weaponframe = 0;        
        self.items = self.items | IT_SHELLS;
        }
      else {
        if (self.weapon == IT_NAILGUN) {
          self.currentammo = self.ammo_nails;
          self.weaponmodel = "progs/v_nail.mdl";
          self.weaponframe = 0;
          self.items = self.items | IT_NAILS;
          }
        else {
          if (self.weapon == IT_SUPER_NAILGUN) {
            self.currentammo = self.ammo_nails;
            self.weaponmodel = "progs/v_nail2.mdl";
            self.weaponframe = 0;
            self.items = self.items | IT_NAILS;
            }
          else {
            if (self.weapon == IT_GRENADE_LAUNCHER) {
              self.currentammo = self.ammo_rockets;
              self.weaponmodel = "progs/v_rock.mdl";
              self.weaponframe = 0;
              self.items = self.items | IT_ROCKETS;
              }
            else {
              if (self.weapon == IT_ROCKET_LAUNCHER) {
                self.currentammo = self.ammo_rockets;
                self.weaponmodel = "progs/v_rock2.mdl";
                self.weaponframe = 0;
                self.items = self.items | IT_ROCKETS;
                }
              else {
                if (self.weapon == IT_LIGHTNING) {
                  self.currentammo = self.ammo_cells;
                  self.weaponmodel = "progs/v_light.mdl";
                  self.weaponframe = 0;
                  self.items = self.items | IT_CELLS;
                  }
                else {
                  if (self.weapon == IT_SPROCKET) {
                    self.currentammo = self.ammo_rockets;
                    self.weaponmodel = "progs/mv_rock2.mdl";
                    self.weaponframe = 0;
                    self.items = self.items | IT_ROCKETS;
                    }
                  else {
                    if (self.weapon == IT_AUTO_SHOTGUN) {
                      self.currentammo = self.ammo_shells;
                      self.weaponmodel = "progs/mv_sh2.mdl";
                      self.weaponframe = 0;
                      self.items = self.items | IT_SHELLS;
                      }
                    else {
                      self.currentammo = 0;
                      self.weaponmodel = "";
                      self.weaponframe = 0;
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
}

Real function W_BestWeapon();
var
 it : Real;
{
  it = self.items;
  if (self.waterlevel <= 1 && self.ammo_cells >= 1 && (it & IT_LIGHTNING)) {
    return IT_LIGHTNING;
    }
  if (self.ammo_nails >= FL_SWIM && (it & IT_SUPER_NAILGUN)) {
    return IT_SUPER_NAILGUN;
    }
  if (self.ammo_nails >= FL_SWIM && (it & IT_NAILGUN)) {
    return IT_NAILGUN;
    }
  if (self.ammo_shells >= FL_SWIM && (it & IT_AUTO_SHOTGUN)) {
    return IT_AUTO_SHOTGUN;
    }
  if (self.ammo_shells >= FL_SWIM && (it & IT_SUPER_SHOTGUN)) {
    return IT_SUPER_SHOTGUN;
    }
  if (self.ammo_shells >= 1 && (it & IT_SHOTGUN)) {
    return IT_SHOTGUN;
    }
  return IT_SWORD;
}

Real function W_CheckNoAmmo();
{
  if (self.currentammo > 0) {
    return 1;
    }
  if (self.weapon == IT_SWORD) {
    return 1;
    }
  self.weapon = W_BestWeapon();
  W_SetCurrentAmmo();
  return 0;
}

Void function W_Attack();
var
 r : Real;
{
  if (!W_CheckNoAmmo()) {
    exit;
    }
  makevectors(self.v_angle);
  self.show_hostile = time + 1;
  if (self.weapon == IT_SWORD) {
    sound(self, CHAN_WEAPON, "weapons/ax1.wav", 1, ATTN_NORM);
    r = random();
    if (r < 0.25) {
      player_axe1();
      }
    else {
      if (r < 0.5) {
        player_axeb1();
        }
      else {
        if (r < 0.75) {
          player_axec1();
          }
        else {
          player_axed1();
          }
        }
      }
    self.attack_finished = time + 0.5;
    }
  else {
    if (self.weapon == IT_SHOTGUN) {
      player_shot1();
      W_FireShotgun();
      self.event = "thrett";
      self.attack_finished = time + 0.5;
      }
    else {
      if (self.weapon == IT_SUPER_SHOTGUN) {
        player_shot1();
        W_FireSuperShotgun();
        self.event = "thrett";
        self.attack_finished = time + 0.7;
        }
      else {
        if (self.weapon == IT_AUTO_SHOTGUN) {
          self.event = "thrett";
          player_autos1();
          }
        else {
          if (self.weapon == IT_SUPER_NAILGUN) {
            self.event = "thrett";
            player_nail1();
            }
          else {
            if (self.weapon == IT_GRENADE_LAUNCHER) {
              player_rocket1();
              W_FireGrenade();
              self.attack_finished = time + 0.6;
              }
            else {
              if (self.weapon == IT_ROCKET_LAUNCHER) {
                player_rocket1();
                W_FireRocket();
                self.attack_finished = time + 0.8;
                }
              else {
                if (self.weapon == IT_LIGHTNING) {
                  player_light1();
                  self.attack_finished = time + 0.1;
                  self.event = "thrett";
                  sound(self, CHAN_AUTO, "weapons/lstart.wav", 1, ATTN_NORM);
                  }
                else {
                  if (self.weapon == IT_SPROCKET) {
                    player_rocket1();
                    W_FireSprocket();
                    self.attack_finished = time + 0.6;
                    }
                  else {
                    if (self.weapon == IT_NAILGUN) {
                      self.event = "thrett";
                      player_nail1();
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
}

Void function W_ChangeWeapon();
var
 it : Real;
 am : Real;
 fl : Real;
{
  it = self.items;
  am = 0;
  if (self.impulse == 1) {
    fl = IT_SWORD;
    }
  else {
    if (self.impulse == FL_SWIM) {
      fl = IT_SHOTGUN;
      if (self.ammo_shells < 1) {
        am = 1;
        }
      }
    else {
      if (self.impulse == MOVETYPE_WALK) {
        fl = IT_SUPER_SHOTGUN;
        if (self.ammo_shells < FL_SWIM) {
          am = 1;
          }
        }
      else {
        if (self.impulse == MOVETYPE_STEP) {
          fl = IT_NAILGUN;
          if (self.ammo_nails < 1) {
            am = 1;
            }
          }
        else {
          if (self.impulse == MOVETYPE_FLY) {
            fl = IT_SUPER_NAILGUN;
            if (self.ammo_nails < FL_SWIM) {
              am = 1;
              }
            }
          else {
            if (self.impulse == MOVETYPE_TOSS) {
              fl = IT_GRENADE_LAUNCHER;
              if (self.ammo_rockets < 1) {
                am = 1;
                }
              }
            else {
              if (self.impulse == MOVETYPE_PUSH) {
                fl = IT_ROCKET_LAUNCHER;
                if (self.ammo_rockets < 1) {
                  am = 1;
                  }
                }
              else {
                if (self.impulse == FL_CLIENT) {
                  fl = IT_LIGHTNING;
                  if (self.ammo_cells < 1) {
                    am = 1;
                    }
                  }
                else {
                  if (self.impulse == MOVETYPE_FLYMISSILE) {
                    fl = IT_SPROCKET;
                    if (self.ammo_rockets < FL_SWIM) {
                      am = 1;
                      }
                    }
                  else {
                    if (self.impulse == 100) {
                      fl = IT_AUTO_SHOTGUN;
                      if (self.ammo_shells < 1) {
                        am = 1;
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
    }
  self.impulse = 0;
  if (!(self.items & fl)) {
    sprint(self, "you don't have that item.|");
    exit;
    }
  if (am) {
    sprint(self, "no can do.|");
    exit;
    }
  self.weapon = fl;
  W_SetCurrentAmmo();
}

Void function CheatCommand();
{
  self.ammo_rockets = 100;
  self.ammo_nails = 200;
  self.ammo_shells = 200;
  self.items = self.items | IT_SWORD | IT_NAILGUN | IT_SHOTGUN | IT_SUPER_SHOTGUN | IT_AUTO_SHOTGUN | IT_SUPER_NAILGUN | IT_GRENADE_LAUNCHER | IT_ROCKET_LAUNCHER;
  self.ammo_cells = 100;
  self.items = self.items | IT_LIGHTNING | IT_SPROCKET;
  self.regen = self.regen + 30;
  if (self.regen > 100) {
    self.regen = 100;
    }
  self.lives = self.lives + 1;
  self.weapon = IT_ROCKET_LAUNCHER;
  self.impulse = 0;
  W_SetCurrentAmmo();
}

Void function CycleWeaponCommand();
var
 it : Real;
 am : Real;
{
  it = self.items;
  self.impulse = 0;
  while (1) {
    am = 0;
    if (self.weapon == IT_AUTO_SHOTGUN) {
      self.weapon = IT_SWORD;
      }
    else {
      if (self.weapon == IT_SWORD) {
        self.weapon = IT_SHOTGUN;
        if (self.ammo_shells < 1) {
          am = 1;
          }
        }
      else {
        if (self.weapon == IT_SHOTGUN) {
          self.weapon = IT_SUPER_SHOTGUN;
          if (self.ammo_shells < FL_SWIM) {
            am = 1;
            }
          }
        else {
          if (self.weapon == IT_SUPER_SHOTGUN) {
            self.weapon = IT_NAILGUN;
            if (self.ammo_nails < 1) {
              am = 1;
              }
            }
          else {
            if (self.weapon == IT_NAILGUN) {
              self.weapon = IT_SUPER_NAILGUN;
              if (self.ammo_nails < FL_SWIM) {
                am = 1;
                }
              }
            else {
              if (self.weapon == IT_SUPER_NAILGUN) {
                self.weapon = IT_GRENADE_LAUNCHER;
                if (self.ammo_rockets < 1) {
                  am = 1;
                  }
                }
              else {
                if (self.weapon == IT_GRENADE_LAUNCHER) {
                  self.weapon = IT_ROCKET_LAUNCHER;
                  if (self.ammo_rockets < 1) {
                    am = 1;
                    }
                  }
                else {
                  if (self.weapon == IT_ROCKET_LAUNCHER) {
                    self.weapon = IT_LIGHTNING;
                    if (self.ammo_cells < 1) {
                      am = 1;
                      }
                    }
                  else {
                    if (self.weapon == IT_LIGHTNING) {
                      self.weapon = IT_SPROCKET;
                      if (self.ammo_rockets < 1) {
                        am = 1;
                        }
                      }
                    else {
                      if (self.weapon == IT_SPROCKET) {
                        self.weapon = IT_AUTO_SHOTGUN;
                        if (self.ammo_shells < 1) {
                          am = 1;
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
      }
    if (it & self.weapon && am == 0) {
      W_SetCurrentAmmo();
      exit;
      }
    }
}

Void function CycleWeaponReverseCommand();
var
 it : Real;
 am : Real;
{
  it = self.items;
  self.impulse = 0;
  while (1) {
    am = 0;
    if (self.weapon == IT_LIGHTNING) {
      self.weapon = IT_ROCKET_LAUNCHER;
      if (self.ammo_rockets < 1) {
        am = 1;
        }
      }
    else {
      if (self.weapon == IT_ROCKET_LAUNCHER) {
        self.weapon = IT_GRENADE_LAUNCHER;
        if (self.ammo_rockets < 1) {
          am = 1;
          }
        }
      else {
        if (self.weapon == IT_GRENADE_LAUNCHER) {
          self.weapon = IT_SUPER_NAILGUN;
          if (self.ammo_nails < FL_SWIM) {
            am = 1;
            }
          }
        else {
          if (self.weapon == IT_SUPER_NAILGUN) {
            self.weapon = IT_NAILGUN;
            if (self.ammo_nails < 1) {
              am = 1;
              }
            }
          else {
            if (self.weapon == IT_NAILGUN) {
              self.weapon = IT_SUPER_SHOTGUN;
              if (self.ammo_shells < FL_SWIM) {
                am = 1;
                }
              }
            else {
              if (self.weapon == IT_SUPER_SHOTGUN) {
                self.weapon = IT_SHOTGUN;
                if (self.ammo_shells < 1) {
                  am = 1;
                  }
                }
              else {
                if (self.weapon == IT_SHOTGUN) {
                  self.weapon = IT_SWORD;
                  }
                else {
                  if (self.weapon == IT_SWORD) {
                    self.weapon = IT_AUTO_SHOTGUN;
                    if (self.ammo_shells < 1) {
                      am = 1;
                      }
                    }
                  else {
                    if (self.weapon == IT_AUTO_SHOTGUN) {
                      self.weapon = IT_SPROCKET;
                      if (self.ammo_rockets < 1) {
                        am = 1;
                        }
                      }
                    else {
                      if (self.weapon == IT_SPROCKET) {
                        self.weapon = IT_LIGHTNING;
                        if (self.ammo_cells < 1) {
                          am = 1;
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
      }
    if (it & self.weapon && am == 0) {
      W_SetCurrentAmmo();
      exit;
      }
    }
}                                   

Void function ServerflagsCommand();
{
  serverflags = serverflags * FL_SWIM + 1;
}

Void function QuadCheat();
{
  if (deathmatch || coop) {
    exit;
    }
  self.super_time = 1;
  self.super_damage_finished = time + SVC_INTERMISSION;
  self.items = self.items | IT_QUAD;
  dprint("quad cheat|");
}

Void function ImpulseCommands();
var
 mark : Object;
{
  if (self.impulse == 100) {
    W_ChangeWeapon();
    }
  if (self.impulse >= 1 && self.impulse <= 9) {
    W_ChangeWeapon();
    }
  if (self.impulse == 221) {
    dm3_showscores();
    }
  if (self.impulse == 222) {
    if (coop || deathmatch) {
      exit;
      }
    CheatCommand();
    }
  if (self.impulse == 223) {
    bprint("ORIGIN: ");
    bprint(vtos(self.origin));
    bprint(" ---- ANGLES: ");
    bprint(vtos(self.angles));
    bprint("|");
    }
  if (self.impulse == 224) {
    bprint(self.netname);
    bprint(" is a llama|");
    }
  if (self.impulse == MOVETYPE_BOUNCE) {
    CycleWeaponCommand();
    }
  if (self.impulse == MOVETYPE_BOUNCEMISSILE) {
    ServerflagsCommand();
    }
  if (self.impulse == 12) {
    CycleWeaponReverseCommand();
    }
  if (self.impulse == 255) {
    QuadCheat();
    }
  self.impulse = 0;
}

Void function W_WeaponFrame();
{
  if (time < self.attack_finished) {
    exit;
    }
  ImpulseCommands();
  if (self.button0) {
    SuperDamageSound();
    W_Attack();
    }
}

Void function SuperDamageSound();
{
  if (self.super_damage_finished > time) {
    if (self.super_sound < time) {
       self.super_sound = time + 1;
      sound(self, CHAN_BODY, "items/damage3.wav", 1, ATTN_NORM);
      }
    }
  exit;
}

Void function W_FireSprocket();
var
 missile : Object;
 mpuff : Object;
{
  self.currentammo = self.ammo_rockets = self.ammo_rockets - AS_STRAIGHT;
  sound(self, CHAN_WEAPON, "weapons/thump.wav", AS_STRAIGHT, ATTN_NORM);
  self.punchangle_x = CONTENT_SOLID;
  missile = spawn();
  missile.owner = self;
  missile.movetype = MOVETYPE_FLYMISSILE;
  missile.solid = SOLID_BBOX;
  missile.classname = "sprocket";
  missile.event = "thrett";
  makevectors(self.v_angle);
  missile.velocity = aim(self, 700);
  missile.velocity = missile.velocity * 700;
  missile.angles = vectoangles(missile.velocity);
  missile.touch = Sprocket_Touch;
  missile.nextthink = time + 2.5;
  missile.think = SUB_Remove;
  setmodel(missile, "progs/sprocket.mdl");
  setsize(missile, [0 0 0], [0 0 0]);
  setorigin(missile, self.origin + v_forward * WEAPON_BIG + [0 0 16]);
}

Void function Sprocket_Touch();
var
 pnt : Vector;
 num : Real;
{
  if (other == self.owner) {
    exit;
    }
  if (pointcontents(self.origin) == CONTENT_SKY) {
    remove(self);
    exit;
    }
  if (other.classname == "monster_nehahra") {
    self.think = SprocketExplode;
    self.nextthink = time + 0.1;
    exit;
    }
  self.enemy = other;
  if (other.takedamage == DAMAGE_AIM) {
    self.solid = SOLID_NOT;
    self.enemy = other;
    pnt = self.origin;
    if (self.origin_x > self.enemy.origin_x) {
      num = self.origin_x - self.enemy.origin_x;
      num = num * 0.6;
      pnt_x = pnt_x - num;
      }
    else {
      if (self.origin_x < self.enemy.origin_x) {
        num = self.enemy.origin_x - self.origin_x;
        num = num * 0.6;
        pnt_x = pnt_x + num;
        }
      }
    if (self.origin_y > self.enemy.origin_y) {
      num = self.origin_y - self.enemy.origin_y;
      num = num * 0.6;
      pnt_y = pnt_y - num;
      }
    else {
      if (self.origin_y < self.enemy.origin_y) {
        num = self.enemy.origin_y - self.origin_y;
        num = num * 0.6;
        pnt_y = pnt_y + num;
        }
      }
    if (self.origin_z > self.enemy.origin_z) {
      num = self.origin_z - self.enemy.origin_z;
      num = num * 0.4;
      pnt_z = pnt_z - num;
      }
    else {
      if (self.origin_z < self.enemy.origin_z) {
        num = self.enemy.origin_z - self.origin_z;
        num = num * 0.4;
        pnt_z = pnt_z + num;
        }
      }
    self.aether = self.enemy.origin - pnt;
    self.touch = SUB_Null;
    self.think = Sprocket_Imbed;
    self.nextthink = time + 0.1;
    exit;
    }
  self.dest = self.origin - other.origin; 
  self.cnt = 0;
  sound(self, CHAN_ITEM, "weapons/sprwall.wav", 1, ATTN_NORM);
  self.velocity = 0;
  self.avelocity = 0;
  self.touch = SUB_Null;
  self.think = Sprocket_Imbed;
  self.nextthink = time;
}

Void function Sprocket_Imbed();
var
 num : Real;
{
  if (self.enemy != world) {
    self.frame = 1;
    if (self.enemy.flags & FL_MONSTER) {
      self.velocity = self.enemy.velocity;
      self.enemy.velocity = [0 0 0];
      self.origin = self.enemy.origin - self.aether;
      if (self.enemy.health < 1) {
        self.think = SprocketExplode;
        self.nextthink = time + 0.050000;
        exit;
        }
      }
    else {
      self.origin = self.enemy.origin + self.dest;
      }
    num = FL_SWIM;
    if (self.items & IT_QUAD) {
      num = num * 4;
      }
    if (self.enemy.health > num) {
      T_Damage(self.enemy, self, self.owner, FL_SWIM);
      }
    }
  self.cnt = self.cnt + 1;
  if (self.cnt == 15 || self.cnt == 23 || self.cnt == 30) {
    sound(self, CHAN_WEAPON, "weapons/sprocket.wav", AS_STRAIGHT, ATTN_NORM);
    self.effects = self.effects | EF_MUZZLEFLASH;
    if (self.enemy != world) {
      if (self.enemy.flags & FL_MONSTER || self.enemy.flags & FL_CLIENT) {
        if (random() < 0.4) {
          SpawnMeatSpray(self.origin, crandom() * 86 * v_right);
          }
        else {
          SpawnMeatSpray(self.origin, crandom() * -86 * v_right);
          }
        }
      }
    }
  if (self.cnt > 33) {
    if (self.enemy.flags & FL_BLOODLESS) {
      T_Damage(self.enemy, self, self.owner, 30);
      }
    self.cnt = 0;
    self.think = SprocketExplode;
    self.nextthink = time + 0.1;
    exit;
    }
  self.think = Sprocket_Imbed;
  self.nextthink = time;
}

Void function SprocketExplode();
{
  T_RadiusDamage(self, self.owner, 85, world);
  WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
  WriteByte(MSG_BROADCAST, TE_EXPLOSION);
  WriteCoord(MSG_BROADCAST, self.origin_x);
  WriteCoord(MSG_BROADCAST, self.origin_y);
  WriteCoord(MSG_BROADCAST, self.origin_z);
  becomeexplosion2();
}


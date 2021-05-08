/****************************************************************************/
/*                                                                          */
/*    project    : S.E.A.L. sQuad       (c) 1997 William van der Sterren    */
/*                                                                          */
/*      file     : squad.hqc    "definitions for squad member and team"     */
/*      author(s): William van der Sterren                                  */
/*      version  : 0.5                                                      */
/*                                                                          */
/*      date (last revision):  Sep 08, 97                                   */
/*      date (creation)     :  Sep 08, 97                                   */
/*                                                                          */
/*                                                                          */
/*      revision history                                                    */
/*      -- date ---- | -- revision ---------------------- | -- revisor --   */
/*                   |                                    |                 */
/*                                                                          */
/****************************************************************************/


//
// Squad fighting
//

// prototypes - local functions



// implementation



// Squad_FI_CanThrowGrenade - returns if member can reach receiver
//                            using grenade; calculation results
//                            will be stored in missile_Speed;
//                            result == receiver, if ok
//                            result == world, if surroundings hit
//                            result == other entity, if blocked
//
//
entity (entity member, entity receiver) Squad_FI_CanThrowGrenade =
{ local entity receivingEntity;
  // calculate missile vertical speed, using a 800 horizontal
  // speed and the level's gravity
  local vector O, OE, dOOE, missile_Speed;
  local float  dl, dh, tE, vl, vh, g;
  local float  path_OK;
  path_OK = FALSE;
  vl      = 400;
  O       = member.origin;
  OE      = receiver.origin;
  OE_z    = receiver.absmin_z;
  g       = cvar("sv_gravity");
  // calculate horizontal and vertical distances
  dh    = O_z - OE_z;
  O_z   = 0;
  OE_z  = 0;
  dOOE  = OE - O;
  dl    = vlen(dOOE);

  // init iteration
  receivingEntity = world;

  while ((receivingEntity != receiver) && (vl < 1100))
    { // determine flight time for grenade, based on horizontal
      // distance/speed
      tE    = dl / vl;
      // calculate required vh
      vh    = 0.5 * g * tE - (dh / tE);

      // set missile speed
      missile_Speed   = normalize(dOOE) * vl;
      missile_Speed_z = vh;

      // now check missile path
      local vector p1, p2, o1;
      local float  t,  dt, result, tflight;
      dt     = 0.1;
      t      = 0.0;
      o1     = member.origin;
      p1     = o1;
      result = TRUE;
      // don't check all the way
      tflight = 0.9 * tE;
      while ((t < tflight) && (result))
        { // increment time
          t  = t + dt;

          p2      = o1 + t * missile_Speed;
          p2_z    = p2_z - 0.5 * g * t * t;
          // check p2
          if (pointcontents(p2) == CONTENT_SOLID)
            { result = FALSE;
              receivingEntity = world;
            }

          // check traject p1 - p2
          traceline(p1, p2, FALSE, member);
          if ((result)                                &&
              (trace_fraction < 1.0)                  &&
              (trace_ent != receiver)                 &&
              (trace_ent.classname != "marker")       &&
              ((trace_ent.classname != "player")    ||
               (trace_ent.team      != member.team)
              )
             )
            { result          = FALSE;
              receivingEntity = trace_ent;
            }

          // set p1 to be p2
          p1 = p2;
        }
      if (result)
        receivingEntity = receiver;
      else
        vl = vl + 50;

    }

  if (receivingEntity == receiver)
    { //bprint(member.netname);
      //bprint(" throws grenade with v : ");
      //bprint(vtos(missile_Speed));
      //bprint("\n");
      // record required speed
      member.dest = missile_Speed;
    }
/*
  else
    { bprint(member.netname);
      bprint(" cannot throw grenade because of ");
      bprint(receiver.classname);
      bprint("::");
      bprint(receiver.netname);
      bprint("\n");
    }
*/

  return receivingEntity;
};



// Squad_FI_FireDirection - returns non-normalized dir, including error
//
//
//
vector () Squad_FI_FireDirection =
{ local float  targetDistance;
  local vector targetVector, normTargetVector;
  local vector errorVector;

  local vector spot1,   spot2;
  makevectors(self.v_angle);
  spot1   = self.origin + v_forward*10;
  spot1_z = self.absmin_z + self.size_z * 0.7;
  spot2   = self.enemy.origin;
  spot2_z = self.enemy.absmin_z + self.enemy.size_z * 0.7;

  targetVector     = spot2 - spot1;
  targetDistance   = vlen(targetVector);
  normTargetVector = normalize(targetVector);

  errorVector_x = 0; // random() * 0.10;
  errorVector_y = 0; // random() * 0.10;
  errorVector_z = 0; // random() * 0.05;

  targetVector  = normTargetVector + errorVector;
  targetVector  = targetDistance * targetVector;

  return targetVector;
};



// Squad_FI_FireHandgun -  fire handgun
//
//
//
void () Squad_FI_FireHandgun =
{ // empty sound if gun empty, and return
  if (self.mk23clip <= 0)
    { sound(self,CHAN_WEAPON,"weapons/mp5click.wav",1,ATTN_NORM);
      return;
    }

  local vector dir;

  self.mk23clip = self.mk23clip - 1;

  sound (self, CHAN_WEAPON, "weapons/pdudegun.wav", 1, ATTN_NORM);

  self.effects = self.effects | EF_MUZZLEFLASH;
  dir = Squad_FI_FireDirection();
  dir = normalize(dir);

  // compute spread, depending on skill
  local vector spread;
  spread = '0.04 0.04 0';
  spread = (5 - skill) * spread;
  // now fire
  FireBullets (2, dir, spread);
  eject_shell ((((self.origin + (v_forward * 14.000))
                 - (v_right * 9.00)) + (v_up * 14.000)),
               dir);

};




// Squad_FI_FireMachinegun -  fire machine gun
//
//
//
void () Squad_FI_FireMachinegun =
{ // empty sound if gun empty, and return
  if (self.mp5clip <= 0)
    { sound(self,CHAN_WEAPON,"weapons/mp5click.wav",1,ATTN_NORM);
      return;
    }

  local vector dir;

  self.mp5clip = self.mp5clip - 1;

  if (self.weapon == WP_MP5 /* MP5 */ )
    sound (self, CHAN_WEAPON, "weapons/mp5fire.wav", 1, ATTN_NORM);
  else
    sound (self, CHAN_WEAPON, "weapons/mp5sd.wav", 1, ATTN_NORM);

  self.effects = self.effects | EF_MUZZLEFLASH;
  dir = Squad_FI_FireDirection();
  dir = normalize(dir);

  // compute spread, depending on skill
  local vector spread;
  spread = '0.04 0.04 0';
  spread = (5 - skill) * spread;
  // now fire
  FireBullets (4, dir, spread);
  eject_shell ((((self.origin + (v_forward * 14.000))
                 - (v_right * 9.00)) + (v_up * 14.000)),
               dir);

};




// Squad_FI_ThrowHandGrenade -  throw handgrenade (either fragmentation
//                              or flashbang grenade)
//
//
void (vector grenade_speed, float fGrenadeType) Squad_FI_ThrowHandGrenade =
{ // empty sound if gun empty, and return
  if (self.ammo_rockets <= 0)
    return;
  self.ammo_rockets = self.ammo_rockets - 1;

  local entity missile;
  missile = spawn ();
  missile.owner      = self;
  missile.movetype   = MOVETYPE_BOUNCE;
  missile.solid      = SOLID_BBOX;

  missile.velocity    = grenade_speed;
  missile.grenadetype = fGrenadeType;

  missile.avelocity  = '300 300 300';
  missile.angles     = vectoangles(missile.velocity);
  missile.touch      = HandGrenadeTouch;

  // set missile duration
  missile.search_time = time + 2.5;
  missile.nextthink   = time + 0.1;
  missile.think       = W_PredictMissileDestination;

  setmodel (missile, "progs/m16gren.mdl");
  setsize (missile, '0 0 0', '0 0 0');
  setorigin (missile, self.origin);
};



/*
// Squad_FI_FireAxe -  fire weapon axe
//
//
//
void() Squad_FI_FireAxe =
{ local vector	    delta;

  ai_face ();

  delta = self.enemy.origin - self.origin;

  if (vlen(delta) > 100)
    return;
  if (!CanDamage (self.enemy, self))
    return;

  sound (self, CHAN_WEAPON, "player/axhit2.wav", 1, ATTN_NORM);
  T_Damage (self.enemy, self, self, 20);

  // makevectors (self.angles);
  // SpawnMeatSpray (self.origin + v_forward*16, v_right);
};




// Squad_FI_FireShotgun -  fire shotgun
//
//
//
void() Squad_FI_FireShotgun =
{ local vector dir;

  self.currentammo = self.ammo_shells = self.ammo_shells - 1;
  sound (self, CHAN_WEAPON, "weapons/guncock.wav", 1, ATTN_NORM);
  self.effects = self.effects | EF_MUZZLEFLASH;
  dir = Squad_FI_FireDirection();
  dir = normalize(dir);
  FireBullets (6, dir, '0.04 0.04 0');
};




// Squad_FI_FireDoubleBarrelShotgun -  fire double barrel shotgun
//
//
//
void() Squad_FI_FireDoubleBarrelShotgun =
{ local vector dir;

  if (self.currentammo == 1)
    { Squad_FI_FireShotgun ();
      return;
    }

  self.currentammo = self.ammo_shells = self.ammo_shells - 2;
  self.effects = self.effects | EF_MUZZLEFLASH;
  sound (self ,CHAN_WEAPON, "weapons/shotgn2.wav", 1, ATTN_NORM);
  dir = Squad_FI_FireDirection();
  dir = normalize(dir);
  FireBullets (14, dir, '0.14 0.08 0');
};


// NOTE! INCONSISTENT IMPLEMENTATIONS OF BOTH THE NAILGUNS

// Squad_FI_FireNailgun -  fire nailgun
//
//
//
void() Squad_FI_FireNailgun =
{
  local vector org;
  local vector dir;
  local float  ox;

  ox = 4;

  self.effects = self.effects | EF_MUZZLEFLASH;
  makevectors (self.angles);
  sound (self, CHAN_WEAPON, "weapons/rocket1i.wav", 1, ATTN_NORM);
  self.currentammo = self.ammo_nails = self.ammo_nails - 1;
  org = self.origin + v_forward * 30 + v_right*ox + '0 0 16';
  dir = Squad_FI_FireDirection();
  dir = normalize(dir);

  launch_spike(org, dir);
};




// Squad_FI_FireQuadBarrelNailgun -  fire quad barrel nailgun
//
//
//
void() Squad_FI_FireQuadBarrelNailgun =
{ local vector     dir;
  local vector     org;

  self.effects = self.effects | EF_MUZZLEFLASH;
  makevectors (self.angles);
  sound (self, CHAN_WEAPON, "weapons/spike2.wav", 1, ATTN_NORM);
  self.currentammo = self.ammo_nails = self.ammo_nails - 2;
  org = self.origin + '0 0 16';

  dir = Squad_FI_FireDirection();
  dir = normalize(dir);

  launch_spike (org, dir);
  newmis.touch = superspike_touch;
  setmodel (newmis, "progs/s_spike.mdl");
  setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);
};




// Squad_FI_FireGrenadeLauncher -  fire grenade launcher
//
//
//
void() Squad_FI_FireGrenadeLauncher =
{ local   entity missile, mpuff;

  self.effects = self.effects | EF_MUZZLEFLASH;

  self.currentammo = self.ammo_rockets = self.ammo_rockets - 1;

  sound (self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM);

  missile = spawn ();
  missile.owner = self;
  missile.movetype = MOVETYPE_BOUNCE;
  missile.solid = SOLID_BBOX;

  makevectors (self.angles);

  missile.velocity = normalize(self.enemy.origin - self.origin);
  missile.velocity = missile.velocity * 600;
  missile.velocity_z = 200;
  missile.classname = "grenade";

  missile.avelocity = '300 300 300';
  missile.angles = vectoangles(missile.velocity);
  missile.touch = GrenadeTouch;

  missile.nextthink = time + 2.5;
  missile.think = GrenadeExplode;

  setmodel (missile, "progs/grenade.mdl");
  setsize (missile, '0 0 0', '0 0 0');
  setorigin (missile, self.origin);
};




// Squad_FI_FireGrenadeLauncher -  fire rocket launcher
//
//
//
void() Squad_FI_FireRocketLauncher =
{ local   entity missile, mpuff;

  self.currentammo = self.ammo_rockets = self.ammo_rockets - 1;

  sound (self, CHAN_WEAPON, "weapons/sgun1.wav", 1, ATTN_NORM);
  missile = spawn ();
  missile.owner = self;
  missile.movetype = MOVETYPE_FLYMISSILE;
  missile.solid = SOLID_BBOX;
  makevectors (self.angles);
  missile.velocity = self.enemy.origin - self.origin;
  missile.velocity = normalize(missile.velocity);
  missile.velocity = missile.velocity * 1000;
  missile.angles = vectoangles(missile.velocity);
  missile.touch = T_MissileTouch;
  missile.nextthink = time + 5;
  missile.think = SUB_Remove;
  setmodel (missile, "progs/missile.mdl");
  setsize (missile, '0 0 0', '0 0 0');
  setorigin (missile, self.origin + '0 0 16');
};



// Squad_FI_FireLightning -  fire lightning
//
//
//
void() Squad_FI_FireLightning =
{ local   vector  org, dir;

  self.effects = self.effects | EF_MUZZLEFLASH;
  self.currentammo = self.ammo_cells = self.ammo_cells - 1;

  ai_face ();

  org = self.origin + '0 0 16';

  dir = self.enemy.origin + '0 0 16' - org;
  dir = normalize (dir);

  traceline (org, self.origin + dir*600, TRUE, self);

  WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
  WriteByte (MSG_BROADCAST, TE_LIGHTNING1);
  WriteEntity (MSG_BROADCAST, self);
  WriteCoord (MSG_BROADCAST, org_x);
  WriteCoord (MSG_BROADCAST, org_y);
  WriteCoord (MSG_BROADCAST, org_z);
  WriteCoord (MSG_BROADCAST, trace_endpos_x);
  WriteCoord (MSG_BROADCAST, trace_endpos_y);
  WriteCoord (MSG_BROADCAST, trace_endpos_z);

  LightningDamage (org, trace_endpos, self, 10);
};

*/



// W_PredictMissileDestination - every frame, check if explosion
//                               required. Else, updated
//                               projected destination (in self.dest)
//
void () W_PredictMissileDestination =
{ // need explosion
  if (time > self.search_time)
    { if (self.grenadetype == 0)
        M16GrenadeExplode();
      else
      if (self.grenadetype == 1) 
        FlashExplode();
      return;
    }

  // next think
  self.nextthink = time + 0.1;

  // predict path
  local float  t, tE, dt, g, ok;
  local vector p1, p2, o1, vl, vh;
  g    = cvar("sv_gravity");
  dt   = 0.1;
  vl   = self.velocity;
  tE   = self.search_time - time;
  o1   = self.origin;
  p1   = o1;
  t    = 0.0;
  ok   = TRUE;
  while ((t < tE) && (ok))
    { // increment time
      t       = t + dt;

      p2      = o1 + t * vl;
      p2_z    = p2_z - 0.5 * g * t * t;

      // check traject p1 - p2
      traceline(p1, p2, FALSE, self);
      if ((ok) &&
          (trace_fraction < 1.0)
         )
        { // set p2 to point of collision
          p2 = trace_endpos;
        }

      // set p1 to be p2
      p1 = p2;
    }
  // end position is p2
  self.dest = p2;
  /*
  bprint("time = ");
  bprint(ftos(tE));
  bprint(", grenade predicts = ");
  bprint(vtos(self.dest));
  bprint("\n");
  */
};


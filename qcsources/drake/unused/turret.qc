//=========================================================================
//
//  AUTOMATED DEFENSE TURRET
//
//=========================================================================

float   TURRET_SPIKE    = 0;    // Used only in oum.  Undesired in Drake.
float   TURRET_LASER    = 1;
float   TURRET_CHAINGUN = 2;
float   TURRET_ROCKET   = 3;

// Fires a missile at a target.
void() tur_fire =
{
    local   vector  v1, vy;

    if (self.ammo_cells < 1)
        return;
    self.ammo_cells = self.ammo_cells - 1;
    v1 = self.trigger_field.angles;
    v1_x = 0 - v1_x;
    makevectors (v1);
    v1 = v_forward;
//- - - - - - - - -
// Use self.cnt instead of self.attack_finished.
    if (self.height == TURRET_ROCKET)
    {   // Guided/Homing Rockets
        vy = v_right * -8;
        vy = vy * ((self.ammo_cells & 3) - 1.5);
        sound (self, CHAN_WEAPON, "weapons/sgun1.wav", 1, ATTN_NORM);
        SuperRocket_Launch (self.origin + '0 0 8' + vy, v1);
        newmis.dmg = 40;
        newmis.height = 0;
        newmis.cnt = 0;
        newmis.speed = 600;
        newmis.state = TRUE;    // Guide missile ahead target to intercept.
        self.cnt = 5;       //self.attack_finished = time + 0.5;
    }
    else if (self.height == TURRET_CHAINGUN)
    {   // Machine shotgun -- spiderdemon style.
        if (self.trigger_field)     // Animate top.
            self.trigger_field.frame = (self.ammo_cells & 1) + 1;
        M_ChaingunNextthink ();
        self.effects = self.effects | EF_MUZZLEFLASH;
        sound (self, CHAN_WEAPON, "weapons/dsshotgn.wav", 1, ATTN_NORM);
        FireBullets (3, v1, '0.1 0.1 0');   // Was 4 shots, too much.
    }
    else
    {   // Lasers or spikes.
        vy = v_right * -12;
        if (self.ammo_cells & 1)
            vy = vy * -1;
        if (self.height == TURRET_LASER)
        {
            sound (self, CHAN_WEAPON, "drone/enfire.wav", 1, ATTN_NORM);
            LaunchLaser (self.origin + vy, v1);
            if (self.tracer_time > time)    // Don't light up each laser.
                newmis.effects = newmis.effects - (newmis.effects & EF_DIMLIGHT);
            else
                self.tracer_time = time + 0.5;
        }
        else
        {
            sound (self, CHAN_WEAPON, "weapons/spike2.wav", 1, ATTN_NORM);
            launch_superspike (self.origin + vy, v1);
        }
        self.cnt = 2;       //self.attack_finished = time + 0.2;
    }
//- - - - - - - - -
};

// Changes turret angles then fires at a target if any.
void() tur_aim =
{
    local   vector  dir, vtemp, org;
    local   float   lo, hi;

    if (!self.trigger_field)
        return;     // PM:  Where's the top?!  Shouldn't happen.

    hi = self.yaw_speed;    // Was 10.
    lo = 0 - hi;            // Was -10.

//dprint (self.enemy.classname); dprint ("\n"); return;
    if (self.enemy)
    {
        org = Midpoint (self.enemy);
        if (self.height == TURRET_ROCKET)
            org = Aim_Lead (self.origin, org, 600, self.enemy);
        else if (self.height == TURRET_CHAINGUN)
        {
            if (!self.enemy.hook)
                org = org + self.enemy.velocity * 0.1142857;    // 4/35
        }
        else
            org = Aim_Lead (self.origin, org, 1000, self.enemy);
    }
    else
        org = self.origin + self.movedir;
    dir = vectoangles (org - self.origin);
    vtemp_x = dir_x - self.trigger_field.angles_x;
    vtemp_y = dir_y - self.angles_y;
    vtemp_z = 0;
    dir = '0 0 0';
    if (vtemp_x < 0)
        vtemp_x = vtemp_x + 360;
    if (vtemp_x > 180)
        vtemp_x = vtemp_x - 360;
    if (vtemp_y < 0)
        vtemp_y = vtemp_y + 360;
    if (vtemp_y > 180)
        vtemp_y = vtemp_y - 360;
    dir = vtemp;
    if (dir_x < lo)
        dir_x = lo;
    if (dir_x > hi)
        dir_x = hi;
    if (dir_y < lo)
        dir_y = lo;
    if (dir_y > hi)
        dir_y = hi;

    self.trigger_field.angles_x = anglemod (self.trigger_field.angles_x + dir_x);
    self.angles_y = anglemod (self.angles_y + dir_y);
    self.trigger_field.angles_y = self.angles_y;
    if (self.enemy)
    {   // Can the turret shoot its target?
        dir = self.trigger_field.angles;
        dir_x = 0 - dir_x;
        makevectors (dir);
        dir = normalize (org - self.origin);
        if (dir * v_forward > 0.97)
        {
            if (self.cnt <= 0)   //self.attack_finished < time)
            {
                if (vlen(self.origin - org) < 2000)     // OUM used 1200.
                {
//                    traceline (self.origin, org, TRUE, world);
//                    if (trace_fraction == 1)
                    if (CanDamage_Point (self.origin, org))
                        tur_fire ();
                }
            }
        }
    }
};

// Checks if 'targ' can be seen by the turret.
float(entity targ) tur_vis =
{
    if (targ.invisible_finished)
        return FALSE;
    if (targ.flags & FL_NOTARGET)
        return FALSE;
    if (!targ.modelindex)
        return FALSE;
    return visible (targ);
};

float() turfindtarget =
{
    local   entity  targ, old;
    local   float   r, best;

    old = self.enemy;
    if (self.enemy)
        best = vlen (self.enemy.origin - self.origin);
    else
        best = 2000;

//- - - - - - - - -
// Search for a better target.
// PM:  Added alignment support so turrets can shoot at npcs.
    if (self.alignment == GOOD)
    {   // Look for monsters to fry.
        if (!self.enemy)
        if (self.waitmax <= time)
        {   // No target, so search everything.
            targ = findradius (self.origin + self.view_ofs, best);
            while (targ)
            {
                if (targ.alignment == EVIL)
                if (targ.health > 0)
                if (tur_vis (targ))
                {
                    r = vlen (targ.origin - self.origin);
                    if (r < best)
                        {best = r;  self.enemy = targ;}
                }
                targ = targ.chain;
            }
            self.waitmax = time + 0.5;  // Don't scan this much every frame.
        }
        targ = blacky;
    }
    else
    {   // Scan for players.
        targ = find (world, classname, "player");
        while (targ)
        {
            if (targ.health > 0)
            if (tur_vis (targ))
            {
                r = vlen (targ.origin - self.origin);
                if (r < best)
                    {best = r;  self.enemy = targ;}
            }
            targ = find (targ, classname, "player");
        }
        targ = whitey;      // ...and one npc.
    }
// Check one last time for the given npc.
    if (targ.health > 0)
    if (tur_vis (targ))
    {
        r = vlen (targ.origin - self.origin);
        if (r < best)
            {best = r;  self.enemy = targ;}
    }
//- - - - - - - - -

    if (self.enemy)
        if (self.enemy != old)
            return TRUE;
    return FALSE;
};

// Stuff that needs to be done each frame.
void() tur_frame =
{
    if (self.trigger_field)
    {
        self.trigger_field.frame = 0;   // Reset top frame to idle.
        ai_synch ();
    }
    if (self.cnt > 0)
        self.cnt = self.cnt - 1;        // Attack delay countdown.
};

// Checks if turret is on or off the ground.  If off, destroy it.
float() tur_failure =
{
    if (self.groundentity.solid != SOLID_BSP)
        self.flags = self.flags - (self.flags & FL_ONGROUND);
    if (!(self.flags & FL_ONGROUND))
    {   // Destroyed if knocked off the ground.
        T_Kill (self, world, world, -99, "");
        return TRUE;
    }
    return FALSE;
};


//=========================================================================

// STAND - - - - - - - - - - - - - - - -
void() tur_scan = [ 0, tur_scan ]
{
//dprint("stand\n");
    tur_frame ();
    if (tur_failure ())
        return;

    if (self.state)
    {
        if (turfindtarget ())
            {self.think = self.th_run;  return;}
        self.enemy = world;
        tur_aim ();
    }
};

// RUN - - - - - - - - - - - - - - - - -
void() tur_run = [ 0, tur_run ]
{
//dprint("run\n");
    tur_frame ();
    if (tur_failure ())
        return;

    if (self.enemy.health <= 0)
        self.enemy = world;
    else if (!tur_vis (self.enemy))
        self.enemy = world;

    turfindtarget ();
    if (!self.enemy)
        {self.think = self.th_stand;  return;}
    else
        M_ShowHostile ();   // Attacking -- alert other monsters.
    tur_aim ();
};

// DEATH - - - - - - - - - - - - - - - -
void() tur_explode =
{
    local   float   up;

    Rocket_Explosion1 (self.origin);
    if (self.trigger_field)
    {   // Remove the top.
        remove (self.trigger_field);
        self.trigger_field = world;
    }

    monster_dead (FALSE);
    up = 0;
    if (deathmatch && !self.spawned)
        up = 2;
    else if (M_RespawnCheck ())
        up = 1;
    if (up)
    {   // Respawn after death.
        SUB_Disappear ();
        if (up == 2)
            M_RespawnNextthink (self.wait);
        else
            M_RespawnNextthink (0);
        MakeExplosion2 (self.origin);
    }
    else
        BecomeExplosion2 ();
};

void() tur_die =
{
// Cannot explode immediately in case turret was destroyed on its turn
// by getting knocked off the ground.
    self.solid = SOLID_NOT;
    self.nextthink = 0.01;
    self.think = tur_explode;
};


//=========================================================================

void() tur_use =
{
    if (self.health <= 0)
        return;

    self.state = !self.state;       // Turns them on or off.
    self.think = tur_scan;
    self.nextthink = time + 0.1;
};

void() start_monster_tur =
{
    local   entity  top;

// Spawn the base.
//    self.solid      = SOLID_SLIDEBOX;
//    self.movetype   = MOVETYPE_TOSS;
//    self.health     = self.max_health;
    self.th_stand   =
    self.th_walk    = tur_scan;
    self.th_run     = tur_run;
    self.th_missile = tur_fire;
    self.th_die     = tur_die;
    self.touch      = monster_touch;    // Player can walk on them.
    self.use        = tur_use;
//    setall (self, self.page1, '-16 -16 -20', '16 16 16', self.oldorigin);
//    self.mindex2    = self.modelindex;
//    droptofloor ();

//    self.deadflag   = DEAD_NO;
//    self.takedamage = DAMAGE_AIM;
    self.ideal_yaw  = self.angles_y;
    self.view_ofs   = '0 0 1';
//    self.flags      = self.flags | FL_MONSTER;
//    self.ammo_cells = self.aflag;
    self.cnt        = 0;

    self.bloodtype  = BLOOD_SPARKS;
    self.family     = FAM_DROID;
    self.hittype    = HIT_METAL;

// Spawn the top.
    top = spawn();
    top.owner       = self;
    top.takedamage  = DAMAGE_NO;
    top.angles      = self.angles;
    setall (top, self.page2, '0 0 0', '0 0 0', self.origin);
    top.mindex2     = top.modelindex;
//- - - - - - - - -
// PM:  Added so turret tops use interpolation.
    top.movetype    = MOVETYPE_STEP;
    top.flags       = MOVETYPE_FLY;
    top.velocity    = '0 0 0';
//- - - - - - - - -

// Connect the two then go.
    self.trigger_field = top;
    self.th_stand ();
};

void() turret_cache =
{
    precache_model ("progs/aagba.mdl");
    precache_model ("progs/aagtb.mdl");
    precache_model ("progs/laser.mdl");

//    precache_sound ("tur_arm.wav");
    precache_sound ("drone/enfire.wav");
    precache_sound ("enforcer/enfstop.wav");
};

void() turret_gun_cache =
{
    precache_model ("progs/amgba.mdl");
    precache_model ("progs/amgtb.mdl");

    precache_sound ("weapons/dsshotgn.wav");
};

void() turret_rocket_cache =
{
    precache_model ("progs/samba.mdl");
    precache_model ("progs/samtb.mdl");
};

//============
// --> QUAKED monster_turret (1 0 0) (-32 -32 -24) (32 32 64) Ambush Chaingun Rockets
//============
void(float t) monster_turret_spawn;

void() monster_turret_laser = {monster_turret_spawn(TURRET_LASER);};
void() monster_turret_gun = {monster_turret_spawn(TURRET_CHAINGUN);};
void() monster_turret_rocket = {monster_turret_spawn(TURRET_ROCKET);};
void() monster_turret_spike = {monster_turret_spawn(TURRET_SPIKE);};

void(float t) monster_turret_spawn =
{
    local   vector  v1;

    if (!self.spawned)
    {
        if (noenemies)
            {remove (self);  return;}
        // Precache later.
    }

    self.classname = "monster_turret";
    if (t == TURRET_ROCKET)
    {   self.page1 = "progs/samba.mdl";
        self.page2 = "progs/samtb.mdl";
        self.th_spawn = monster_turret_rocket;
        if (!self.spawned)
            turret_rocket_cache ();
    }
    else if (t == TURRET_CHAINGUN)
    {   self.page1 = "progs/amgba.mdl";
        self.page2 = "progs/amgtb.mdl";
        self.th_spawn = monster_turret_gun;
        if (!self.spawned)
            turret_gun_cache ();
    }
    else
    {   self.page1 = "progs/aagba.mdl";
        self.page2 = "progs/aagtb.mdl";
        if (t != TURRET_LASER)
        {   self.th_spawn = monster_turret_spike;
            t = TURRET_SPIKE;
        }
        else
            self.th_spawn = monster_turret_laser;
        if (!self.spawned)
            turret_cache ();
    }

    self.height = t;
    monster_form (self.page1, '-16 -16 -20', '16 16 16', 100, 0);

    self.th_stand   =
    self.th_walk    =
    self.th_run     = start_monster_tur;
    self.th_die     = tur_die;
    //- - - - - - - -

//    self.oldorigin = self.origin;

    v1_x = -20;
    v1_y = self.angles_y;
    v1_z = 0;
    makevectors (v1);
    self.movedir = v_forward;
    if (!self.ammo_cells)
        self.ammo_cells = 1000000;      // Was 5000, may not be enough.
    self.aflag = self.ammo_cells;
    if (!self.wait)
        self.wait = 30;
    self.state = TRUE;      // Active by default.

    self.tracer_time = 0;
//    self.xfl = XFL_IGNORE;

    self.trigger_field = world;

    monster_start ();
};

// Turret entity used in Drake.  OUM spike turrets are redundant.
// If you really want them, see 'monster_tur' below.
void() monster_turret =
{
    local   float   r;

    r = TURRET_LASER;
    if (self.spawnflags & 2)
        r = TURRET_CHAINGUN;
    else if (self.spawnflags & 4)
        r = TURRET_ROCKET;
    monster_turret_spawn (r);
};

// OUM spike turret entity.  Use sf2 for lasers.
void() monster_tur =
{
    self.yaw_speed = 10;    // Used in OUM.
    if (self.spawnflags & 2)
        monster_turret_spawn(TURRET_LASER);
    else
        monster_turret_spawn(TURRET_SPIKE);
};


//===========================/  END OF FILE  /===========================//

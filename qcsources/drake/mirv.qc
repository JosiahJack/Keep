//==========================================================================
//
//  MIRV (Multiple Independently Targeted Reentry Vechiles)
//
//==========================================================================

// New constants for Stinger.
// Used in this file only, so no need to move them to const.qc.
float   LOCK_DOT_PITCH  = 0.9848;   // cos(10).
float   LOCK_DOT_YAW    = 0.9397;   // cos(20).
float   LOCK_RANGE      = 8192;     // 1000 is about 30 metres.
                                    // 4096 isn't long enough for Masque.

// New fields used by the '*_Target' functions.
// Update:  Moved mirv1/chain2 to defs because it is used in multiple files.
// Update 1/6/10:  Remaining edict fields moved to entity.qc.


//==========================================================================
//  Direction Vector Change

//  Moved to 'math.qc'.


//==========================================================================
//  Target Selection

//- - - - - - - - -
//  This checks if the target is inside the targeting box.
//
//  Attacker must be a client to work properly.
//  Non-clients that try to use this will likely get a result of FALSE.
//- - - - - - - - -
float(entity targ, entity client) BfgLock_InSight =
{
    local   vector  vec, v1, v2;
    local   float   dot;

    v1 = client.origin + client.view_ofs;
    v2 = Midpoint (targ);

// Check if the target is within the v_weapon's targeting box.
    vec = normalize (v2 - v1);
    makevectors (client.v_angle);

    dot = vec * v_forward;
    if (dot < LOCK_DOT_YAW)
        return FALSE;   // NOT in the box.
    if (dot >= LOCK_DOT_PITCH)
        return TRUE;    // Certainly IN the box.

    // We know the target is within the left and right bounds.  However,
    // we don't know if the target is truly within the top and bottom
    // bounds.  Therefore, we need to create a vector whose pitch is the
    // same as the aim vector AND whose yaw is the same as the ideal vector.
    // Then we need to find the dot product of the new and ideal vectors.
    // If dot is greater than or equal to vertical dot, target is in the box.

    v1 = vectoangles (v_forward);
    v2 = vectoangles (vec);
    v1_x = 0 - v1_x;    // Fix pitch reversal.
    v1_y = v2_y;
    makevectors (v1);

// TRUE = Target is in the box, FALSE = Target is outside.
    return  (vec * v_forward) >= LOCK_DOT_PITCH;
};

// This checks if the target should be targeted by the weapon system.
float(entity targ, entity sensor, entity attacker) BfgLock_Confirm =
{
    if (targ == attacker)
        return FALSE;   // Don't turn on the attacker.

// Target must be mortal and solid.
    if (!targ.takedamage)
        return FALSE;   // This will stop here in case targ is the world.
    if (targ.solid <= SOLID_TRIGGER)    // solid_not is less than trigger.
        return FALSE;   // Ethereal, not solid.

// Target must not have stealth tech.
    if (targ.invisible_finished)
        return FALSE;
    if (targ.flags & FL_NOTARGET)
        return FALSE;

// Sensor entity must see the target.
// If sensor equals attacker, he must see target as the weapon would.
    local   vector  p1, p2;

    p1 = sensor.origin + sensor.view_ofs;
    p2 = Midpoint (targ);
    traceline (p1, p2, TRUE, sensor);
    if (trace_fraction < 1)
        return FALSE;   // Blocked!
    if (trace_inopen)
        if (trace_inwater)
            return FALSE;   // Lock cannot cross contents.

// Check relations to avoid friendly fire.
    if (Ally_Check (targ, attacker))
        return FALSE;

// Target is confirmed.
    return TRUE;
};


//==========================================================================
//  Warheads

// AreaBlaster = Fireballs that tear through and grind targets for a while
// before exploding.  Similar to the AreaBlaster special from the NES game
// The Guardian Legend.  For a more recent example, the ghosts from
// Hexen's priest weapon Wraithverge.

float   AREABLASTER_DAMAGE  = 15;   // Was 18, but that was too much.

void() AreaBlaster_Touch =
{
    if (pointcontents(self.origin) == CONTENT_SKY)
        {remove (self); return;}
    if (Reflected ())
        return;

// hit something that bleeds
    if (other.takedamage)
        T_NewDamage (other, self, self.master, self.cnt, DF_FIRE|DF_ROCKET|DF_SCAR, self.classname);    //"areablaster");
    else
        Tent_Point (TE_KNIGHTSPIKE, self.origin);
    if (other.solid != SOLID_BSP)
        self.owner = other;
};

// Alternate explosion function for warheads.
void() SmallExplosion =
{
    Rocket_Explosion2 (self.origin, 96, 16);
    BecomeExplosion ();
};

// Checks if the warhead can track either of its targets.
float() Warhead_See =
{
    local   entity  t1, t2;
    local   float   dead;

    t1 = self.enemy;
    t2 = self.oldenemy;
    dead = TRUE;
    if (t1)
        if (t1.takedamage || !IsDead (t1))
            dead = FALSE;
    if (dead)
    {   // Current target eliminated.
        if (self.oldenemy)
        {   // Attack secondary target.
            t1 = self.enemy = t2;
            t2 = self.oldenemy = world;
        }
//- - - - - - - - -
// Note:  Comment this section out if you want warheads to chase gibs.
        else
        {   // No targets left.
            self.enemy = self.oldenemy = world;
            return FALSE;
        }
//- - - - - - - - -
    }
    if (t1)
    {   // Target is available.
        if (!t1.invisible_finished)
            if (!(t1.flags & FL_NOTARGET))
                return TRUE;

        // Primary target has stealth tech.  Check secondary target.
        if (t2)
            if (t2.takedamage || !IsDead (t2))
                if (!t2.invisible_finished)
                    if (!(t2.flags & FL_NOTARGET))
                    {   // Secondary target is live and uncloaked.
                        local   vector  spot;

                        spot = Midpoint (t2);
                        traceline (self.origin, spot, TRUE, self);
                        if (trace_fraction == 1)
                        {   // Secondary target found, swap targets.
                            self.enemy = t2;
                            self.oldenemy = t1;
                            return TRUE;
                        }
                    }
    }
    return FALSE;
};

// Missile think.  Warhead seeks its acquired target.
void() Warhead_Think =
{
    if (self.delay <= time)
    {   // Pop when out of fuel.
        self.enemy = world;
        T_MissileExplode ();
        return;
    }

    if (self.tome_finished)
    {   // AreaBlaster.
        if (self.wait <= time)
        {
            self.wait = time + 0.2;
            self.owner = world;
        }
        if (IsDead (self.enemy))
            self.enemy = world;
    }

    // Calculate new velocity.
    local   vector  dir;

    dir = self.movedir;
    if (Warhead_See ())
    {   // Aim for midpoint between top and center of enemy, if way is clear.
        local   vector  spot;

        spot = Midpoint (self.enemy);
        spot_z = (self.enemy.absmax_z - spot_z) * 0.5 + spot_z;
        traceline (self.origin, spot, TRUE, self);
        if (trace_fraction == 1)
            dir = Dir_GotoIdeal (dir, self.origin, spot, self.yaw_speed);
    }
    else if (self.tome_finished)
    {   // AreaBlaster -- Find new guy.
        local   float   best, dist;
        local   entity  head;
        local   vector  spot2;

        best = 600;
        head = findradius (self.origin, best);
        while (head)
        {
            if (head != self.owner)
            if (head.takedamage || !IsDead (head))
            if (!Ally_Check (head, self.master))
            if (!head.invisible_finished)
            if (!(head.flags & FL_NOTARGET))
            {   // Secondary target is live and uncloaked.
                spot2 = Midpoint (head);
                traceline (self.origin, spot2, TRUE, self);
                if (trace_fraction == 1)
                {
                    dist = vlen (self.origin - spot2);
                    if (dist <= best)
                    {
                        best = dist;
                        self.enemy = head;
                    }
                }
            }
            head = head.chain;
        }
    }
    dir = Dir_Change (dir, self.t_width, self.t_length);  // Give spiraling.

    // Update speeds and spiraling angles.
    // Note:  43 and 47 are primes closest to 45.
    self.speed      = self.speed + self.distance;
    self.t_width    = self.t_width + 0.5;
    self.t_length   = anglemod(self.t_length + 47);

    // Apply new velocity.
    if (self.flags & FL_ONGROUND)
    {
        self.flags      = self.flags - FL_ONGROUND;
        if (self.owner.solid == SOLID_BSP)
        {   // Glide along the ground.
            local   vector  p1, p2;

            dir = 16*dir;
            p1 = self.origin - (dir);
            p2 = self.origin + (dir);
            traceline (p1, p2, TRUE, self);     // see through other monsters
            dir = Vec_Reflect (dir, trace_plane_normal, 1, 0);
            dir = normalize(dir);
        }
    }
    self.movedir    = dir;
    self.angles     = vectoangles(dir);
    self.velocity   = self.movedir * self.speed;
    self.nextthink  = time + 0.1;
};

// Spawns and launches a payload warhead.  'self' is its parent MIRV.
void(vector start, vector dir, float ang, entity targ1, entity targ2)
    Warhead_Launch =
{
    local   entity  bomb;

    bomb = spawn();
    if (self.tome_finished)
        setmodel (bomb, "progs/k_ball.mdl");
    else
        setmodel (bomb, "progs/memissil.mdl");
    setsize (bomb, '0 0 0', '0 0 0');
    setorigin (bomb, start);
    bomb.movetype   = MOVETYPE_FLYMISSILE;
    bomb.solid      = SOLID_BBOX;
    bomb.angles     = vectoangles(dir);

    bomb.t_length   = ang;  // Affects warhead's spiraling flight path.
    bomb.t_width    = 0;    // Ditto.

    bomb.distance   = rint(self.speed * 0.05);  // Acceleration per frame.
    bomb.speed      = self.speed;
    bomb.yaw_speed  = 30;   // Turning speed in degrees.  10 thinks/sec.
    bomb.delay      = time + 2 + random() * 0.5;    // Grenades are 2.5.
    bomb.dmg        = self.cnt;
    bomb.style      = self.style;
    bomb.cnt        = AREABLASTER_DAMAGE;
    bomb.wait       = time + 0.2;   // AreaBlaster retouch time.

    bomb.velocity   = dir * bomb.speed;
    bomb.nextthink  = time + 0.3;   // Give time for payload to spread.
    bomb.think      = Warhead_Think;
    bomb.touch      = T_MissileTouch;       // Was 'Warhead_Touch'.
    if (self.tome_finished)
    {
        bomb.distance   = 0;    // Constant speed during flight.
        bomb.yaw_speed  = 40;   // Faster turn speed.
        bomb.touch      = AreaBlaster_Touch;
    }

    // Use 'master' instead of 'owner' so warheads can strike attacker.
    bomb.master     = self.master;
    bomb.owner      = world;
    bomb.enemy      = targ1;
    bomb.oldenemy   = targ2;

    bomb.classname  = "mirv";   // Use the same obits as its parent.
    bomb.movedir    = dir;
    bomb.think1     = SmallExplosion;
    bomb.tome_finished  = self.tome_finished;

    newmis = bomb;
};


//==========================================================================
//  Guided Missile

// This selects targets for the payload warheads to lock on to.
// Returns the best target as the head of a list of viable targets.
entity() Payload_Target =
{
    local   entity  best, head, ent;
    local   vector  org, vec, vx;
    local   float   dist, dot, pc, in;

    ent = self.master;
    pc = ent.flags & FL_CLIENT;
    best = world;
    org = self.master.origin + self.master.view_ofs;
    head = findradius(org, LOCK_RANGE);
    if (pc)
    {   makevectors (self.master.v_angle);
        vx = v_forward;     // Your facing.
    }
    else
        vx = normalize (ent.enemy.origin - ent.origin);

    // Find a target to home in on.
    while (head)
    {
        if (BfgLock_Confirm (head, self.master, self.master))
        {
            vec = Midpoint (head) - org;    // Path toward target.
            dot = normalize(vec) * vx;
            if (dot >= LOCK_DOT_YAW)    // Assumes constant > 0.
            {   // Check if the target is within the gun sights.
                if (pc)
                    in = BfgLock_InSight (head, self.master);
                else
                    in = TRUE;  // Always so for npcs.
                if (in)
                {   // Take this target!
                    // Treat targets that are not perfectly lined up further
                    // away than they really are.  Like squaring the circle.
                    dist = vlen(vec) / dot;
                    head.rate2 = dist;
                    if (!best || (dist < best.rate2))
                    {   // Place at the head of the list.
                        head.chain2 = best;
                        best = head;
                    }
                    else
                    {   // Placed somewhere under head.
                        ent = best;
                        while (ent)
                        {
                            if (!ent.chain2 || (dist < ent.chain2.rate2))
                            {   // Insert into list then get out of loop.
                                head.chain2 = ent.chain2;
                                ent.chain2 = head;
                                ent = world;
                            }
                            if (ent == ent.chain2)
                                ent = world;    // Avoid infinite loop.
                            else
                                ent = ent.chain2;
                        }
                    }
                }
            }
        }
        head = head.chain;
    }

    return best;    // Return the head of the hitlist.
};

// This launches all the warheads in a MIRV's payload.
void() Mirv_Payload =
{
    local   entity  first, head, t1, t2;
    local   float   loop, hi, theta, qcsin, qccos;
    local   vector  dir, trig, vx, vy, vz;

// Get unit vectors along the three axes.
    dir = Vangles(self.movedir);
    makevectors (dir);
    vx = v_forward; vy = v_right; vz = v_up;

// Set loop counter equal to the number of warheads to spawn.
    hi = self.count;
    if (hi < 2)
        hi = 2;     // By definition, MIRVs carry at least two warheads.
    loop = hi;
    hi = 360 / hi;

// Acquire a list of viable targets.
    if (self.state)
        head = Payload_Target ();
    else
        head = world;
    first = head;

    trig = CoSine(10);
    qccos = trig_x;
    qcsin = trig_y;

// Spawn each payload missile.
    while (loop)
    {
        if (head)
        {   t1 = head;
            head = head.chain2;
            if (!head)
                head = first;
            t2 = head;
        }
        else
            t1 = t2 = world;

        theta = anglemod (loop * hi + 90);
        trig = CoSine (theta);
        dir = (vx*qccos) + ( ((vy*trig_x) + (vz*trig_y))*qcsin );
        Warhead_Launch (self.origin, dir, theta, t1, t2);

        loop = loop - 1;
    }
};

// Checks if the weapon's targeting system is offline.
float() Mirv_Off =
{
    if (self.master.mirv1 != self)
        return TRUE;    // Previously went offline.
//    if (self.master.flags & FLx_CREATURE)
        if (self.war != self.master.war)
            return TRUE;    // Not holding the launching weapon.
    if (intermission_running)
        return TRUE;
    if (cutscene)
        return TRUE;

    return FALSE;
};

// This severs the link between an attacker and his MIRV.
void() Mirv_Reset =
{
    local   entity  ent;

    ent = self.master;
    if (ent)
        if (ent.mirv1 == self)  // Make sure the missiles match.
    {
        if (Mirv_Off ())
            self.state = 0;     // Disable payload targeting.

        if (ent.flags & FL_CLIENT)
            if (ent.button0)
            {   // Give client a chance to release button after impact
                // so that he doesn't accidently fire another MIRV.
                if (ent.attack_finished < time + 0.5)
                    ent.attack_finished = time + 0.5;
            }

        ent.mirv1 = world;
    }
};

// Called when a MIRV slams into something before releasing its payload.
void() Mirv_Touch = //{Mirv_Reset (); T_MissileTouch ();};
{
// Turn off control.
    Mirv_Reset ();

// Touch code.
    if (pointcontents(self.origin) == CONTENT_SKY)
        {remove (self); return;}
    if (Reflected_Damage (COURAGE_DAMAGE))
        return;

    if (self.tome_finished)
        Mirv_Payload ();    // Unleash AreaBlaster payload.

    self.touch = SUB_Null;      // Stack overflow prevention.
    self.enemy = other;
    T_MissileExplode ();
};

// This causes to split by releasing its payload.
void() Mirv_Split =
{
    Mirv_Reset ();

    sound (self, CHAN_WEAPON, "weapons/mirv2.wav", 1, ATTN_NORM);
    self.effects = self.effects | EF_MUZZLEFLASH;
    Mirv_Payload ();
    BecomeExplosion ();
};

// Lets 'self' use a linked MIRV by releasing its payload.
void() Mirv_Use =
{
    if (self.mirv1)
    {   // Enforce a brief delay so the attacker cannot hit himself
        // with the payload because the MIRV split too close after launch.
        if (!self.mirv1.th_win)
            self.mirv1.th_win = Mirv_Split;
        if (time - self.mirv1.search_time > 0.3)
            SUB_Think (self.mirv1, self.mirv1.th_win);
        else    // Can't use it now.
            self.mirv1.delay = time + (time - self.mirv1.search_time);
        // Since attack was released, MIRV will split.
        // Reducing fuel to ensure the split is an ugly but simple hack.
    }
};

// Missile think.  Attacker guides the MIRV by sight.
void() Mirv_Think =
{
    if (!self.th_win)
        self.th_win = Mirv_Split;

    if (self.delay <= time)
    {   // Out of fuel, release payload.
        self.th_win ();
        return;
    }

    if (Mirv_Off ())
    {   // MIRV launcher inactive.
        Mirv_Reset ();
        self.nextthink = self.delay;
        self.think = self.th_win;
        return;
    }

// Calculate then apply new velocity.
    local   entity  ent;
    local   vector  dir;

    ent = self.master;
    dir = self.movedir;
    if (visible (ent))      // Missile must 'see' its owner.
    {   // Fly toward the spot its owner is aiming at.
        local   vector  org, vec;

        if (ent.flags & FL_CLIENT)
            {makevectors (ent.v_angle);  vec = v_forward;}      //vec = Mirv_TargetDir (v_forward);
        else //if (ent.flags & FL_MONSTER)
            vec = normalize (ent.enemy.origin - ent.origin);
        org = ent.origin + '0 0 16';
        traceline (org, org + vec*LOCK_RANGE, FALSE, ent);
        if (trace_fraction < 1)
            dir = Dir_GotoIdeal (dir, self.origin, trace_endpos, self.yaw_speed);
    }
    self.movedir    = dir;
    self.flags      = self.flags - (self.flags & FL_ONGROUND);
    self.angles     = vectoangles(dir);
    self.velocity   = self.movedir * self.speed;
    self.nextthink  = time + 0.2;
};

// This spawns and launches a MIRV.
void(vector start, vector dir) Mirv_Launch =
{
    local   entity  bomb;

    bomb = spawn();
    setmodel (bomb, "progs/rocket1.mdl");
    setsize (bomb, '0 0 0', '0 0 0');
    setorigin (bomb, start);
    bomb.movetype   = MOVETYPE_FLYMISSILE;
    bomb.solid      = SOLID_BBOX;
    bomb.angles     = vectoangles(dir);

    bomb.speed      = 500;
    bomb.yaw_speed  = 40;       // Turning speed in degrees.  5 thinks/sec.
    bomb.delay      = time + 16;    // 500 * 16 = 8K range.  Was T+10.
    bomb.dmg        = 190;          // MIRV damage.  See below for details.
    bomb.count      = COST_MIRV;    // Number of warheads in payload.
    bomb.cnt        = 95;   // Warhead damage, same power as Hip proxy bomb.
    bomb.style      = DF_ROCKET;
//- - - - - - - - - - - - - - - - - - -
// damage | radius |  volume (4*pi*r*r*r/3)
//--------+--------+------------
//    95  |   135  | 10305994.7
//   190  |   230  | 50965010.4
//
// MIRVs release five warheads.  If a MIRV explodes before releasing
// its payload, make a single large blast with the combined blast volume
// (not damage) from each warhead.
//
// Note that the sphere with 230 radius has roughly five times more volume
// than the sphere with 135 radius.
//
// If you want to change warhead damage, make sure MIRV radius is
// 1.71 (or cube root of 5) times warhead radius.
//- - - - - - - - - - - - - - - - - - -

    bomb.velocity   = dir * bomb.speed;
    bomb.touch      = Mirv_Touch;
    bomb.nextthink  = time + 0.2;
    bomb.think      = Mirv_Think;

    bomb.master     = bomb.owner    = self;
    bomb.enemy      = world;

    bomb.classname  = "mirv";
    bomb.movedir    = dir;

    bomb.tome_finished  = self.tome_finished;
    bomb.search_time= time;
    bomb.state      = 1;    // Warhead auto-targeting: 0 = off, 1 = on.
    bomb.war        = self.war;
    bomb.think1     = BecomeBigBang;    // Use alternate explosion code.
    bomb.th_win     = Mirv_Split;

    newmis = bomb;
    if (self)
        self.mirv1 = bomb;
};

//============
// W_FireStinger
//
// Called when player launches a MIRV.
//============
void() W_FireStinger =
{
    if (self.ammo_rockets < COST_MIRV)
        return;

    self.currentammo = self.ammo_rockets = self.ammo_rockets - COST_MIRV;

// Cost of admission paid.  Launch the big missile.
    local   vector  start;

    sound (self, CHAN_WEAPON, "weapons/mirv1.wav", 1, ATTN_NORM);
    self.punchangle = '6 0 -12';

    makevectors (self.v_angle);
    self.velocity = self.velocity - (v_forward * 100);  // Recoil!
    start = self.origin + self.view_ofs + (v_forward*8) + (v_right*8);
    Mirv_Launch (start, v_forward);
};


//==========================================================================
//  Hydra/Drunk Missiles

// Note:  Not part of the MIRVs, but this borrows some code from there.

void() DrunkRocket_Think =
{
    if (self.delay <= time)
    {   // Pop when out of fuel.
        self.enemy = world;
        T_MissileExplode ();
        return;
    }

    // Check if the enemy still exists.
    if (self.enemy)
    {
        if (!self.enemy.takedamage && (self.enemy.health <= 0))
        {
            // Primary target gone; go to secondary target.
            self.enemy = self.oldenemy;
            self.oldenemy = world;
            if (!self.enemy.takedamage && (self.enemy.health <= 0))
                self.enemy = world;     // No more targets.
        }
    }

    // Calculate new velocity.
    local   vector  dir, vec;

    dir = self.movedir;
    if (self.enemy)
    {
        // Turn toward the enemy if not blocked.
        vec = Midpoint (self.enemy);
        traceline (self.origin, vec, TRUE, self);
        if (trace_fraction == 1)
            dir = Dir_GotoIdeal (dir, self.origin, vec, self.yaw_speed);
    }
    dir = Dir_Randomize (dir, self.cnt);     // For drunken flight.

    // Apply new velocity.
    self.movedir    = dir;
    self.flags      = self.flags - (self.flags & FL_ONGROUND);
    self.angles     = vectoangles(self.movedir);
    self.velocity   = self.movedir * (self.speed + random() * self.height);
    self.nextthink  = time + 0.2;
    if (self.delay < self.nextthink)
        self.nextthink = self.delay;
};

void(entity attacker, vector start, vector dir, float damage,
    entity targ1, entity targ2) DrunkRocket_Launch =
{
    newmis = spawn ();
    newmis.master       = newmis.owner      = attacker;
    newmis.movetype     = MOVETYPE_FLYMISSILE;
    newmis.solid        = SOLID_BBOX;
    newmis.classname    = "rocket";
// set missile speed
    newmis.yaw_speed    = 40;   // Note:  Missiles think 5/sec, not 10/sec.
    newmis.speed        = 450;
    newmis.height       = 50;
    newmis.movedir      = dir;
    newmis.velocity     = dir * 600;
    newmis.angles       = vectoangles(newmis.velocity);
// set missile damage
    newmis.dmg          = damage;
    newmis.style        = DF_ROCKET;
// set missile special stuff
    newmis.enemy        = targ1;
    newmis.oldenemy     = targ2;
    newmis.ideal_yaw    = newmis.angles_y;
//- - - - - - - - -
    newmis.cnt          = 20;   // Random angle used for drunken flight.
//- - - - - - - - -
// set missile duration
    newmis.touch        = T_MissileTouch;
    newmis.delay        = time + 2 + random() * 0.5;    // Grenades are 2.5.
    newmis.nextthink    = time + 0.2;
    newmis.think        = DrunkRocket_Think;
    newmis.think1       = SmallExplosion;

    setall (newmis, "progs/memissil.mdl", '0 0 0', '0 0 0', start);
};

// Splits the missile and launches all payload missiles.
void() Hydra_Split =
{
    local   vector  start, dir, vx, vy, trig;
    local   entity  t0, t1, t2;
    local   float   loop, cost;

    loop = self.count;
    cost = loop - 1;

    start = self.origin;
    dir = self.angles;  dir_x = 0 - dir_x;
    makevectors (dir);

    vx = v_forward;
    vy = v_right;
    // Search for targets infront of the parent missile.
    t0 = t1 = SuperRocket_Target (self.master, start, v_forward, 2000, 0.3);

    while (loop > 0)
    {
        t2 = t1.chain2;
        if (!t2)
            t2 = t0;

        loop = loop - 1;
        trig = CoSine ((cost - loop * 2) * 10);     // 20 degrees of separation.
        dir = (vx*trig_x) + (vy*trig_y);
        DrunkRocket_Launch (self.master, start, dir, 90, t1, t2);

        t1 = t2;
    }

    // FIXME:  Maybe spawn a tiny explosion instead like in mirv.qc?
    remove (self);
};

// Launches a small MIRV that splits into mini-rockets a few frames
// after launch.  One big rocket causes less backlash than several
// smaller rockets.
//
// I wanted a multi-rocket launcher, much like a shotgun that fires rockets
// instead of pellets, but backlash from multiple rockets at point-blank
// causes too much damage and knockback.  Instead, a MIRV is launched.
// See above for details.
void() W_FireHydra =
{
    local   vector  start, dir;
    local   float   cost;

    if (self.ammo_rockets < 1)
        return;

    cost = 3;
    if (self.ammo_rockets < cost)
        cost = self.ammo_rockets;
    self.currentammo = self.ammo_rockets = self.ammo_rockets - cost;
    sound (self, CHAN_WEAPON, "weapons/stunfire.wav", 1, ATTN_NORM);
    self.punchangle_x = -2;

    makevectors (self.v_angle);
    start = self.origin + v_forward*8 + '0 0 16';
    dir = v_forward;

    Rocket_Launch (start, dir);
    newmis.velocity = dir * 600;
    newmis.count    = cost;         // # of warheads after splitting.
    newmis.nextthink= time + 0.2;
    newmis.think    = Hydra_Split;
    if (cost >= 2)
    {   // Make bigger explosion if payload includes multiple rockets.
        newmis.dmg      = cost * 30 + 60;
        newmis.think1   = BecomeBigBang;
    }
};


//===========================/  END OF FILE  /===========================//

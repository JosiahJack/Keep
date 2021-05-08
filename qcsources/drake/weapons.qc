//==========================================================================
//
//  ROCKETS
//
//==========================================================================

// Checks if the missile can see its target.
float() Missile_Vis =
{
    if (self.enemy)
    if (self.enemy.health > 0)
    if (!self.enemy.invisible_finished)
    if (!(self.enemy.items & IT_INVISO))
    if (!(self.enemy.flags & FL_NOTARGET))
    if (visible (self.enemy))
        return TRUE;

    return FALSE;
};

//- - - - - - - - -
// Point missile toward a point in space.
//
// Note:  Missile will seek the same elevation as its target point.
// This means if missile is at the same altitude as its target, missile
// will not climb or dive to loop toward the target even if such three
// dimensional manuvering would let it loop back faster.  Instead,
// it will loop to the side.  This does not mean the missile cannot
// climb or dive toward the target; in fact, it will do so if there
// is a elevation difference between the missile and its target.
//
// This two dimensional movement is good for sidewinding missiles
// and the Mjolnir.  For other missiles, not so much.
//- - - - - - - - -
void(vector spot) Missile_Face =
{
    local   vector  ang;
    local   float   diff;

    ang = normalize (spot - self.origin);
    ang = vectoangles (ang);
    self.angles_y = anglemod(self.angles_y);
// Change pitch - - - - - - -
    // Copy pitch into yaw to fool Quake into changing the pitch for us.
    self.ideal_yaw = anglemod(ang_x);
    diff = self.angles_y;   // Remember this so we can restore yaw later.
    self.angles_y = self.angles_x;
    ChangeYaw ();
    self.angles_x = self.angles_y;
    self.angles_y = diff;   // Restore yaw now that pitch has changed.
// Change yaw - - - - - - - -
    self.ideal_yaw = anglemod(ang_y);
    ChangeYaw ();
};

// Points missile toward its target.  Used by Mjolnir.
// Note:  Missile_Face favors two dimension movement.  See above.
void(entity targ) Missile_Seek =
{
    if (targ)
    {
        if (targ.invisible_finished || (targ.items & IT_INVISO))
            if ( !((self.classname == "Mjolnir") && (self.master == targ)) )
                return;

        local   vector  vec;

        vec = Aimpoint (targ);
    // Check for intercept course.
        if (self.state)
            vec = Aim_Lead (self.origin, vec, self.speed, targ);
    //- - - - - - - - -
        Missile_Face (vec);
        vec = self.angles;
        vec_x = 0 - vec_x;
        makevectors (vec);
        self.velocity = v_forward * self.speed;
        self.movedir = v_forward;
    }
};

// Points missile toward its target.
// Function runs more code, but missiles can climb or dive more.
// Used by homing missiles in this file.
void(entity targ) Missile_Seek_3D =
{
    if (targ)
    {
        if (targ.invisible_finished || (targ.items & IT_INVISO))
            return;

        local   vector  vec, dir;

        vec = Aimpoint (targ);
    // Check for intercept course.
        if (self.state)
            vec = Aim_Lead (self.origin, vec, self.speed, targ);
    //- - - - - - - - -
        dir = normalize (self.velocity);
        dir = self.movedir = Dir_GotoIdeal (dir, self.origin, vec, self.yaw_speed);
        self.angles = vectoangles (dir);
        self.velocity = dir * self.speed;
    }
};


//======================================
//  Standard Rockets
//======================================
// PM:  Replaced owner with master for all missiles because of reflection.
void() T_MissileExplode =
{
    if (!self.dmg)
        self.dmg = 120;

    if (self.enemy)     // Don't check health, just if there is a target.
    {
        // History lesson:  Doom's rockets did 1d8*20 (20-160) damage on
        // a direct hit, and did full radius damage to everyone.
        // Cyberdemon took full damage from direct hits, but none from
        // any splash.
        local   float   damage;

        if (self.worldtype == MDAM_TWENTY)
        {
            if (self.dmg < 20)
                damage = random() * self.dmg;
            else
                damage = (self.dmg - 20) + (random() * 20);
        }
        else if (self.worldtype == MDAM_FULL)
            damage = self.dmg;
        else if (self.worldtype == MDAM_GRENADE)
            damage = SUB_ExploDamage (other, self, self.dmg);
        else
            damage = SUB_RandomDamage (self.dmg);
    // PM:  For rewritten shal-rath missiles.
        if (self.style & DF_ZKILL)
            if (self.enemy.classname == "monster_zombie")
                damage = self.enemy.health + 50;
    //- - - - - - - - -
        T_NewDamage (self.enemy, self, self.master, damage, self.style, self.classname);
    }
    // Don't do radius damage to the enemy, because all the damage
    // was done in the impact.
    T_NewRadiusDamage (self, self.master, self.dmg, self.enemy, self.style, self.classname);
// DISABLED -- Not sure I want to do fragmentation this way.
//    if (self.th_win)
//        self.th_win ();   // For fragmenting attacks such as gugs' bilebombs.

// PM:  Don't set origin directly during a touch function because of
// possible link scrambling.  May cause FitzQuake to crash otherwise.
    self.origin = self.origin - 8*normalize(self.velocity);
    if (self.think1)
    {   // Alternate explosion code defined, so use that instead.
        self.think1();
    }
    else
    {   // Standard explosion procedure.
        Rocket_Explosion1 (self.origin);
        BecomeExplosion2 ();
    }
// PM:  In classic Doom, target took damage from both impact AND explosion.
//  The only exception was if the target was either the cyberdemon or
//  spider mastermind, both of whom had immunity to splash damage.
};

//============
void() T_MissileTouch =
{
// Removed 'other == self.owner' since entities always ignore the owner.

    if (pointcontents(self.origin) == CONTENT_SKY)
        {remove (self); return;}
    if (Reflected_Damage (COURAGE_DAMAGE))
        return;

// Set the touch function to SUB_Null, so that monsters hurt by the missile
// and walkmove via pain/death functions cannot retouch the missile in a
// loop and cause stack overflow.  Make sure other touch stuff gets this
// safeguard.
    self.touch = SUB_Null;
    self.enemy = other;
    T_MissileExplode ();
};

void(vector start, vector dir) Rocket_Launch =
{
    local   entity  missile;

    missile = spawn ();
    missile.master      = missile.owner     = self;
    missile.movetype    = MOVETYPE_FLYMISSILE;
    missile.solid       = SOLID_BBOX;
    missile.classname   = "rocket";     // Originally "missile".
// set missile speed
    missile.speed       = 1000;
    missile.velocity    = dir * 1000;
    missile.angles      = vectoangles(missile.velocity);
// set missile damage
    missile.dmg         = 120;      // Alien Quake is 210.
    missile.enemy       = world;
    missile.style       = DF_ROCKET;    // Shamblers take half damage.
// set missile duration
    missile.touch       = T_MissileTouch;
    missile.nextthink   = time + 5;
    missile.think       = SUB_Remove;

    setall (missile, "progs/missile.mdl", '0 0 0', '0 0 0', start);

    newmis = missile;
};

// Homing Rockets - - - - - - - - - - -
// Returns a linked list of targets, with the best at the head of list.
// Uses .chain2 to link targtes.
entity(entity attacker, vector org, vector dir, float radius, float scope)
    SuperRocket_Target =
{
    local   entity  head, targ, link, old;
    local   vector  vec, end;
    local   float   dp;     // Dot Product

    targ = world;
    head = findradius(org, radius);
    while (head)
    {   // Target must be a living creature without any stealth tech.
        if (head.health > 0)
        if (!head.invisible_finished)
        if (!(head.flags & FL_NOTARGET))
        if (head.flags & FLx_CREATURE)
        if (!Ally_Check (head, attacker))
        {   // Get the target whose direction matches aim vector the closest.
            end = Midpoint (head);
            vec = normalize (end - org);
            dp = vec * dir;
//- - - - - - - - -
            if (dp > scope)
            {
                traceline (org, end, TRUE, head);
                if (trace_fraction == 1)
                {   // Accept as a possible target.
                    // Make a chain of targets.
                    head.chain2 = world;
                    head.rate2 = dp;
                    if (targ)
                    {   // Sort the chain by dot product in descending order.
                        old = world;
                        link = targ;
                    //- - - - - - - - -
                        while (link)
                        {
                            if (dp > link.rate2)
                            {   // This target is more desirable.
                                head.chain2 = link;
                                if (old)
                                    old.chain2 = head;
                                else
                                    targ = head;
                                link = world;   // End this sub-loop.
                            }
                            else
                            {   // Next!
                                old = link;
                                link = link.chain2;
                                if (!link)
                                    old.chain2 = head;
                            }
                        }
                    //- - - - - - - - -
                    }
                    else
                        targ = head;
                }
            }
//- - - - - - - - -
        }
        head = head.chain;
    }
    return targ;
};

void() SuperRocket_Think =
{
    if (self.delay <= time)
    {
        self.enemy = world;     // Thanks to my bonehead way of doing T_MissileExplode.
        T_MissileExplode ();
        return;
    }

    local   float   seen;

    seen = Missile_Vis ();
    self.yaw_speed = self.yaw_speed + self.cnt;     // See launch func below.
    self.velocity = normalize(self.velocity);
    if (!seen)
    {
        if (self.wait <= time)
        {
            self.wait = time + 0.5;
// Use owner instead of master because missile passes owner.
// FIXME:  Use master if owner is the world?
            self.enemy = SuperRocket_Target (self.master, self.origin, self.velocity, 1000, self.volume);
            if (self.enemy)
                seen = TRUE;
        }
    }
    if (seen)
        Missile_Seek_3D (self.enemy);

    self.speed = self.speed + self.height;
    if (self.speed > 1500)
        self.speed = 1500;
    self.velocity = normalize(self.velocity)*self.speed;

    self.nextthink = time + 0.1;
};

void(vector start, vector dir) SuperRocket_Launch =
{
    Rocket_Launch (start, dir);
    newmis.speed     = 500;
//    newmis.movedir   = dir;
    newmis.velocity  = dir * newmis.speed;
    newmis.height    = 50;
    newmis.volume    = 0.7071;
    newmis.enemy     = SuperRocket_Target (self, start, dir, 2000, newmis.volume);
    newmis.yaw_speed = 10;
//- - - - - - - - -
    newmis.cnt       = 2;   // Increase yaw_speed by this after each think.
    newmis.state     = 0;   // Aim directly at enemy.  Use 1 to intercept.
//- - - - - - - - -
    newmis.delay     = newmis.nextthink;
    newmis.nextthink = time + 0.2;
    newmis.think     = SuperRocket_Think;
};
//- - - - - - - - - - - - - - - - - - -

//================
// W_FireRocket
//================
void() W_FireRocket =
{
    if (self.ammo_rockets < 1)
        return;

    self.currentammo = self.ammo_rockets = self.ammo_rockets - 1;
    sound (self, CHAN_WEAPON, "weapons/sgun1.wav", 1, ATTN_NORM);
    self.punchangle_x = -2;

    local   vector  start, dir;

    makevectors (self.v_angle);
    start = self.origin + v_forward*8 + '0 0 16';   // DPwep = '8 12 12'.
    dir = v_forward;    //aim(self, 1000);

    if (self.tome_finished)
        SuperRocket_Launch (start, dir);
    else
        Rocket_Launch (start, dir);
};


// Accelerating Homing Missile - - - - -
// Used by rocketters.  Not used by players.

void() AccelRocket_Think =
{
    if (self.delay <= time)
    {
        self.enemy = world;     // Thanks to my bonehead way of doing T_MissileExplode.
        T_MissileExplode ();
        return;
    }

    self.speed = self.speed + self.height;      // Accelerate!
    if (self.speed > 2000)
        self.speed = 2000;
    if (Missile_Vis ())
    {
    // Combine its direction and the direction toward the target.
    // It is quick and easy.  It also gives it variable turning speed.
        local   vector  v1, v2;

        v1 = Aimpoint (self.enemy);
// DISABLED -- Unused.
    // Check for intercept course.
//        if (self.state)
//            v1 = Aim_Lead (self.origin, v1, self.speed, self.enemy);
    //- - - - - - - - -
        v1 = normalize (v1 - self.origin);
        v2 = normalize (self.velocity);
        self.velocity = v1 + v2;
    }
    self.velocity = normalize(self.velocity)*self.speed;
    self.angles = vectoangles(self.velocity);

    self.nextthink = time + 0.1;
};

// Launches a rocket similar to those fired by the rocketter from Quoth.
void(vector start, vector dir, entity targ, float damage) AccelRocket_Launch =
{
    Rocket_Launch (start, dir);
    newmis.height    = 100;
    newmis.speed     = 100;
    newmis.velocity  = dir * newmis.speed;
    newmis.enemy     = targ;
    newmis.dmg       = damage;
    newmis.delay     = time + 2;
    newmis.nextthink = time + 0.1;
    newmis.think     = AccelRocket_Think;
    newmis.think1    = Old_Explosion1;
};


// Sidewinder Rockets - - - - - - - - -
// Used by players and mega enforcers.
// Some of the sidewinder code is also used by other monsters (SoE acolyte).

// Missile angles oscillate around ideal_yaw.
// Use when missile needs to sidewind along a straight line.
void() Sidewind_Ideal =
{
    local   float   diff, yaw;

    yaw = self.ideal_yaw;
    diff = anglemod(yaw - self.angles_y);
    if ((diff > 0) && (diff <= 180))
        self.ideal_yaw = self.angles_y + self.yaw_speed;   // Go left.
    else
        self.ideal_yaw = self.angles_y - self.yaw_speed;   // Go right;
    ChangeYaw ();
    self.ideal_yaw = yaw;
};

// Missile changes pitch and yaw to face its target point.
// The missile must always turn toward ideal_yaw at full yaw_speed.
void(vector spot) Sidewind_Face =
{
    local   vector  ang;
    local   float   diff;
    local   float   up;

//- - - - - - - - -
    if (self.lefty)
    {   // Oscillate up and down slightly.
        up = (self.cnt & 7) * 45;
        up = SUB_cos(up) * 5;
        self.cnt = self.cnt + 1;
    }
    else
        up = 0;
//- - - - - - - - -

    ang = normalize (spot - self.origin);
    ang = vectoangles (ang);
    self.angles_y = anglemod(self.angles_y);
// Change pitch - - - - - - -
    // Copy pitch into yaw to fool Quake into changing the pitch for us.
    self.ideal_yaw = anglemod(ang_x + up);
    diff = self.angles_y;   // Remember this so we can restore yaw later.
    self.angles_y = self.angles_x;
    ChangeYaw ();
    self.angles_x = self.angles_y;
    self.angles_y = diff;   // Restore yaw now that pitch has changed.
// Change yaw - - - - - - - -
    diff = anglemod(ang_y - self.angles_y);
    if ((diff > 0) && (diff <= 180))
        self.ideal_yaw = self.angles_y + self.yaw_speed;   // Go left.
    else
        self.ideal_yaw = self.angles_y - self.yaw_speed;   // Go right;
    self.ideal_yaw = anglemod(self.ideal_yaw);
    ChangeYaw ();
};

// The missile must always turn toward ideal_yaw at full yaw_speed.
void(vector vec, float sped) Sidewind_Go =
{
    Sidewind_Face (vec);

    vec = self.angles;
    vec_x = 0 - vec_x;
    makevectors (vec);
    self.velocity = v_forward * sped;
};

//- - - - - - - - -
// The above three functions may be used for other similar missiles.
//
// However, the next three functions are designed specifically for the
// mega enforcers' sidewinder missiles (which the player may use too).
//- - - - - - - - -

void() Sidewinder_Think =
{
    if (self.delay < time)
    {   // Out of gas.
        if (self.style & DF_ROCKET)
        {   // Update 4/2/10:  Explode instead of disappearing.
            self.enemy = world;     // Thanks to my bonehead way of doing T_MissileExplode.
            T_MissileExplode ();
        }
        else    // For acolytes' venom shots.
            remove (self);
        return;
    }

    local   vector  vec;
    local   float   sped;

    if (self.enemy)
        sped = ( !(self.enemy.items & IT_INVISO) && !(self.enemy.flags & FL_NOTARGET) );
    else
        sped = FALSE;
    if (sped)
    {
        vec = Aimpoint (self.enemy);    // Was self.enemy.origin;
        Sidewind_Face (vec);
        if (!self.volume)
        {   // Lose track if missile flies past its target.
            local   float   d1, d2;
            local   vector  dir;

            dir = normalize(self.velocity);
            d1 = normalize(self.enemy.origin - self.origin) * dir;
//            dprint(ftos(d1));  dprint("\n");    // Debug message.

            if (d1 < 0)
            {   // Target is behind the missile.
                // Check if missile is further away than the target.
                // If missile is further away from the current owner than
                // the target is from missile's owner, assume the missile
                // flew behind the target and drop the target.
                if (self.master.flags & FL_MONSTER)
                {
                    d1 = vlen (vec - self.owner.origin);
                    d2 = vlen (self.origin - self.owner.origin);
                    if (d2 > (d1 + 50))
                        self.enemy = world;   // Assumed to be behind target.
                }
            }
        }
    }
    else if ((self.master == self.owner) && (!self.oldenemy))
        Sidewind_Face (self.pos2);      // No target to begin with.
    else
        Sidewind_Ideal ();

    sped = random() * 50 + 450;     //random() * self.height + self.speed;

    vec = self.angles;
    vec_x = 0 - vec_x;
    makevectors (vec);
    self.velocity = v_forward * sped;

    if (self.lefty & 1)
        {self.lefty = 2;  self.nextthink = time + 0.1;}
    else
        self.nextthink = time + 0.2;
};

// Update 4/2/10:  Adapted for player use.  Mega enforcer still uses this.
void(vector start, vector dir, entity targ) Sidewinder_Launch =
{
    newmis = spawn ();
    newmis.master       = newmis.owner      = self;
    newmis.movetype     = MOVETYPE_FLYMISSILE;
    newmis.solid        = SOLID_BBOX;
    newmis.classname    = "rocket";
// set missile speed
    newmis.yaw_speed    = 30;   // For sidewinding code.
    newmis.speed        = 450;
    newmis.height       = 50;
    newmis.velocity     = dir * (450 + (random() * 50));
    newmis.angles       = vectoangles(newmis.velocity);
// set missile damage
    newmis.dmg          = 90;
    newmis.style        = DF_ROCKET;
// set missile special stuff
    newmis.oldenemy     =
    newmis.enemy        = targ;
    newmis.ideal_yaw    = newmis.angles_y;
//- - - - - - - - -
    newmis.cnt          = 0;
    newmis.lefty        = 1;
    // Get the spot we want to hit if fired straight without a target.
    newmis.pos2         = start + (dir * ((newmis.speed + newmis.height) * 5));
//- - - - - - - - -
// set missile duration
    newmis.touch        = T_MissileTouch;
    newmis.delay        = time + 2.5;       // Total duration
    newmis.nextthink    = time + 0.2;       // Was T+0.25
    newmis.think        = Sidewinder_Think;
    newmis.think1       = Old_Explosion1;

    setall (newmis, "progs/memissil.mdl", '0 0 0', '0 0 0', start);
};

//====================
// W_FireSidewinder
//====================
void() W_FireSidewinder =
{
    if (self.ammo_rockets < 1)
        return;

    self.currentammo = self.ammo_rockets = self.ammo_rockets - 1;
    sound (self, CHAN_WEAPON, "weapons/stunfire.wav", 1, ATTN_NORM);
    self.punchangle_x = -2;

    local   vector  start, dir;
    local   entity  targ;

    makevectors (self.v_angle);
    start = self.origin + v_forward*8 + '0 0 16';
    dir = v_forward;
    // Select a target in front of the player's sights.
    targ = SuperRocket_Target (self, start, dir, 2000, COS30);

    Sidewinder_Launch (start, dir, targ);
};


// Hydra/Drunk Rockets moved to 'mirv.qc'.


//======================================
//  Grenades
//======================================
void() Grenade_Touch =
{
// PM:  The cont checks are new.
    local   float   pc;

    pc = pointcontents (self.origin);
    if (pc == CONTENT_SKY)
        {remove (self);  return;}

    // PM:  Also explode if in lava.
    if ( (other.takedamage == DAMAGE_AIM) || (pc == CONTENT_LAVA) )
    {
        if (pc != CONTENT_LAVA)
            if (Reflected_Damage (COURAGE_DAMAGE))
                return;

        self.touch = SUB_Null;      // Stack overflow prevention.
        self.enemy = other;
        T_MissileExplode ();
        return;
    }
    sound (self, CHAN_WEAPON, "weapons/bounce.wav", 1, ATTN_NORM);
    if (self.velocity == '0 0 0')
        self.avelocity = '0 0 0';
};

//============
void(vector start, vector dir, vector add) Grenade_Launch =
{
    local   entity  missile;

    missile = spawn ();
    missile.master      = missile.owner     = self;
    missile.movetype    = MOVETYPE_BOUNCE;
    missile.solid       = SOLID_BBOX;
    missile.classname   = "grenade";
// set missile speed
    missile.speed       = 600;
    missile.velocity    = (dir * 600) + add;
    missile.avelocity   = '300 300 300';
    missile.angles      = vectoangles(missile.velocity);
// set missile damage
    missile.dmg         = 120;      // Alien Quake is 210.
    missile.enemy       = world;
    missile.style       = DF_ROCKET;    // Shamblers take half damage.
    missile.xfl         = XFL_WIND;     // Ride wind tunnels.
    missile.worldtype   = MDAM_GRENADE;
// set missile duration
    missile.touch       = Grenade_Touch;
    missile.nextthink   = time + 2.5;
    missile.think       = T_MissileExplode;

    setall (missile, "progs/grenade.mdl", '0 0 0', '0 0 0', start);

    newmis = missile;
};

// Super Grenades - - - - - - - - - - -
void() SuperGrenade_Think =
{
    if (self.delay <= time)
        {T_MissileExplode ();  return;}

    self.angles = vectoangles (self.velocity);
    self.nextthink = time + 0.05;
};

void(vector start, vector dir, vector add) SuperGrenade_Launch =
{
    local   entity  missile;

    missile = spawn ();
    missile.master      = missile.owner     = self;
    missile.movetype    = MOVETYPE_TOSS;
    missile.solid       = SOLID_BBOX;
    missile.classname   = "grenade";
// set missile speed
    missile.speed       = 800;      // Was 600, too slow.
    missile.velocity    = (dir * missile.speed) + add;
    missile.angles      = vectoangles(missile.velocity);
// set missile damage
    missile.dmg         = 160;
    missile.enemy       = world;
    missile.style       = DF_ROCKET;
    missile.xfl         = XFL_WIND;     // Ride wind tunnels.
// set missile duration
    missile.touch       = T_MissileTouch;
    missile.delay       = time + 2.5;
    missile.nextthink   = time + 0.1;
    missile.think       = SuperGrenade_Think;
    missile.think1      = BecomeBigBang;

    setall (missile, "progs/grenade.mdl", '0 0 0', '0 0 0', start);

    newmis = missile;
};
//- - - - - - - - - - - - - - - - - - -

//================
// W_FireGrenade
//================
void() W_FireGrenade =
{
    if (self.ammo_rockets < 1)
        return;

    self.currentammo = self.ammo_rockets = self.ammo_rockets - 1;
    sound (self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM);
    self.punchangle_x = -2;

    local   vector  start, vec;

    makevectors (self.v_angle);
    start = self.origin;
    vec = '0 0 200';
    if (self.v_angle_x)
        {vec = vec + crandom()*v_right*10; vec = vec + crandom()*v_up*10;}

    if (self.tome_finished)     // FIXME:  use 2 rockets?
        SuperGrenade_Launch (start, v_forward, vec);
    else
        Grenade_Launch (start, v_forward, vec);
};


//==========================================================================
// ECHO SHOTS
//
// Used to create more shots between frames to give firing rates faster
// than 10 frames per second.  Only clients should use this because of
// intermission and fire button checks, which do not apply to monsters.
//==========================================================================

void() Echo_Think =
{
    if (!intermission_running)
        if (!cutscene)
            if (self.owner.button0 || self.owner.form_active
            || self.tome_finished || (self.owner.perms & POW_DOUBLE))
                if (self.owner.health > 0)
                    SUB_Think (self.owner, self.think1);

    remove (self);
};

// Spawns a dummy entity that will fire a shot for its owner.
void(float pause, void() thinkst) Echo_Shot =
{
    local   entity  echo;

    echo = spawn();
    echo.owner      = self;
    echo.nextthink  = time + pause;
    echo.think      = Echo_Think;
    echo.think1     = thinkst;

    echo.tome_finished  = self.tome_finished;
};


//=============================================================================
//
//  REBOUNDING SHOTS
//  (Note:  For DarkPlaces engine, use MOVETYPE_BOUNCEMISSILE instead.)
//
//=============================================================================

// Update 1/5/10:  Vec_Reflect moved to 'math.qc'.

// This traces for the vector normal to a surface.  It also resets the
// missile's origin.
void() BounceShot_TraceNormal =
{
    local   vector  spot1, spot2;

    self.movedir = normalize (self.dest);
    spot1 = self.origin - (16*self.movedir);
    spot2 = self.origin + (16*self.movedir);
    traceline (spot1, spot2, FALSE, self);  // see through other monsters
    setorigin (self, trace_endpos);     //self.origin = trace_endpos;
};

// The moves a missile after an impact.
void() BounceShot_Move =
{
    self.velocity   = Vec_Reflect (self.movedir, trace_plane_normal, 2, 0);
    self.velocity   = normalize(self.velocity);
    self.velocity   = self.dest         = self.speed * self.velocity;
    self.flags      = self.flags - (self.flags & FL_ONGROUND);
    self.angles     = vectoangles(self.velocity);
};

// This updates the velocity and angles of a missile.  Needed for
// rebounding shots.  Used by pulse rifle and Hip's laser cannon.
void() BounceShot_Think =
{
    if (time > self.delay)
        {remove (self); return;}

    self.flags      = self.flags - (self.flags & FL_ONGROUND);
    self.velocity   = self.dest;    //old_velocity;
    self.angles     = vectoangles(self.velocity);
    self.nextthink  = time + sys_ticrate;

    if (self.xfl & XFL_GHOST_BANE)
        Ghost_Touch ();
};

// This redirects a missile to an enemy.
// Must call BounceShot_Move first.
void() BounceShot_Seek =
{
    local   entity  head, best;
    local   vector  dir, spot;
    local   float   bdot, dot;

    best = world;
    dir = trace_plane_normal;   //self.dest
    bdot = 0;
    head = findradius (self.origin, 2000);
    while (head)
    {
        if (head.takedamage == DAMAGE_AIM)
        if (!head.invisible_finished)
        if (!(head.flags & FL_NOTARGET))
        if (head != self)
        if (head != self.master)
        if (!Ally_Check (head, self.master))
        if (CanDamage (head, self))
        {
            spot = Midpoint (head);
            dot = normalize(spot - self.origin) * dir;
            if (dot > bdot)
            {
                best = head;
                bdot = dot;
            }
        }
        head = head.chain;
    }

    if (best)
    {
        self.velocity   = Midpoint (best);
        self.velocity   = normalize (self.velocity - self.origin);
        self.velocity   = self.dest         = self.speed * self.velocity;
        self.angles     = vectoangles(self.velocity);
    }
};


//=============================================================================
//
//  SPIKES
//
//=============================================================================

// Hitscan - - - - -
// Note:  Hitscan spikes should probably go into the bullets section,
// but since the weapons that use these are modified nailguns, put them
// here close to the nailgun code.

float   SPIKEY_RANGE    = 8192;     // Quake2 railgun range.
float   SPIKEY_DAMAGE   = 9;

// FIXME:  Not needed anymore, but I am too lazy to rip the code out now.
.float  dmg_stack;

// Loop through all entities and damage everyone who has damage stacked
// against them (from the piercing shotgun effect).  Not has fast as
// MultiDamage*, but necessary when piercing shots are involved.
void(entity inflictor, entity attacker, string dtype) StackDamage_Clear =
{
    local   entity  head;
    head = nextent (world);
    while (head)
    {
        if (head.dmg_stack)
        {
            T_NewDamage (head, inflictor, attacker, head.dmg_stack, DF_NONE, dtype);
            head.dmg_stack = 0;
        }
        head = nextent (head);
    }
};

// Shoots a piercing hitscan bullet.
void(vector p1, vector p2, entity attacker, float damage, entity inflictor,
    float fx) Piercer_Trace =
{
    local   entity  ruler;
    local   entity  ignore;
    local   entity  targ;
    local   vector  start;
    local   vector  dir;
    local   float   dist;
    local   float   delta;
    local   float   hits;

    hits = 3;
    ruler = inflictor;

    dir = p2 - p1;
    delta = vlen(dir);  // Get total length in case of reflection.
    dir = normalize(dir);

    while (ruler)
    {
        ignore = inflictor = ruler;
        ruler = world;      // End loop unless set otherwise by reflection.
        start = p1;

        do
        {
            traceline (p1, p2, FALSE, ignore);
    
            p1 = trace_endpos;
            targ = trace_ent;
            if ((targ.solid != SOLID_BSP) && targ.takedamage)
                ignore = targ;
            else
                ignore = world;
            if (targ != inflictor)      // Dirty hack to prevent suicide.
            {
                if (HasReflection (targ, p1, damage))
                {
                    if (hits > 0)
                    {
                        hits = hits - 1;
                        ruler = targ;
                        delta = delta - vlen(p1 - start);   // Get remaining dist.
                        dir = normalize(p1 - targ.origin);
                        p2 = p1 + dir*delta;
                    }
                    else
                        trace_fraction = 1;     // We give up.
                    ignore = world;     // Stop the trace.
                    ReflectSound (targ);
                }
                else if (targ.takedamage)
                {   // Note:  Because we may call the function we are in
                    // multiple times for a shotgun-like attack, don't apply
                    // damage now.  Just put the damage number in a stack,
                    // then apply it when we are ready.
                    blood_impact (inflictor, dir, p1, damage, targ.bloodtype);
                    targ.dmg_stack = targ.dmg_stack + damage;
                }
            }
    
        // If current trace hits inflictor/attacker, next trace will miss all.
        // Move the new start point ahead slightly to prevent attacker from
        // hitting himself and preventing the bolt from piercing anymore.
        // (Note:  If attacker is inside the monster because of noclip,
        // he can still hit himself.)
            if (ignore)     // Always world if 'p2 == trace_endpos'.
            {
                dist = vlen(p2 - p1);
                if (dist > 1)
                    p1 = p1 + dir;
                else
                    ignore = world;   // Not enough distance left, so just stop.
            }
        }
        while (ignore);
    }

    if (trace_fraction < 1)
        if (pointcontents (p1) != CONTENT_SKY)
            Tent_Point (fx, p1);    // fx should be TE_SPIKE or TE_SUPERSPIKE.
};


// Standard - - - -
void() spike_touch =
{
    if (pointcontents(self.origin) == CONTENT_SKY)
        {remove (self); return;}
    if (Reflected ())
        return;

    self.touch = SUB_Null;      // Stack overflow prevention.

// hit something that bleeds
    if (other.takedamage)
    {
        // Check for immunity.
        local   float   hit;

        hit = TRUE;
        if (self.worldtype == TE_KNIGHTSPIKE)
        {
            if (other.xfl & XFL_ARMORED)
                hit = FALSE;    // Immune to magic missiles.
        }
        else if (self.worldtype == TE_WIZSPIKE)
        {   // Do acid test here instead of in the damage functions.
            self.dmg = ceil(self.dmg * (1 - other.resist_acid));
            if (self.dmg < 1)
                hit = FALSE;
        }

        if (hit)
        {
            if ((other.hittype == HIT_METAL) || (other.hittype == HIT_STONE))
            if ((self.worldtype == TE_SPIKE) || (self.worldtype == TE_SUPERSPIKE))
            {   // Play ricochet sounds.
                if (random() < 0.2)
                    Sfx_Ric ();
            }
            spawn_touchblood (self.dmg, other.bloodtype);
            T_NewDamage (other, self, self.master, self.dmg, self.style, self.classname);
            remove (self);
            return;
        }
    }

    Tent_Point (self.worldtype, self.origin);
    remove (self);
};

//===============
// launch_spike
//
// Used by a lot of things, not just the player and Qtest/Nehahra ogre.
//===============
void(vector org, vector dir) launch_spike =
{
    newmis = spawn ();
    newmis.master       = newmis.owner      = self;
    newmis.movetype     = MOVETYPE_FLYMISSILE;
    newmis.solid        = SOLID_BBOX;

    newmis.angles       = vectoangles (dir);

    newmis.dmg          = 9;
    newmis.style        = DF_NONE;
    newmis.worldtype    = TE_SPIKE;

    newmis.touch        = spike_touch;
    newmis.classname    = "spike";
    newmis.think        = SUB_Remove;
    newmis.nextthink    = time + 6;

    newmis.speed        = 1000;
    newmis.velocity     = dir * 1000;
    newmis.dest         = dir;      // for 'spawn_touchblood'.

    setall (newmis, "progs/spike.mdl", VEC_ORIGIN, VEC_ORIGIN, org);
};

// Used to spawn super spikes.  Yes, keep this.
void(vector org, vector dir) launch_superspike =
{
    launch_spike (org, dir);
    newmis.skin     = 1;    // s_spike skin
    newmis.dmg      = 18;
    newmis.worldtype= TE_SUPERSPIKE;
};

void(float ox) W_EchoSpike =
{
    local   float   cost;

    cost = 1;
    if (self.perms & POW_DOUBLE)
    {
        if (self.war == WAR_NAILGUN)
            cost = 0;
        else
        {   // Assume super nailgun.
            if (!self.tome_finished || (ox < 0))
                cost = 0;
        }
    }

    if (self.ammo_nails < cost)
        return;

    local   vector  dir;

    makevectors (self.v_angle);
    if (self.war == WAR_NAILGUN)
        sound (self, CHAN_WEAPON, "weapons/rocket1i.wav", 1, ATTN_NORM);
    else    // Assume super nailgun.
        sound (self, CHAN_WEAPON, "weapons/spike2.wav", 1, ATTN_NORM);
    self.attack_finished = time + 0.2;
    self.currentammo = self.ammo_nails = self.ammo_nails - cost;
    if (self.tome_finished)
    {
        local   string  dtype;
        local   vector  org;

        if (self.war == WAR_NAILGUN)
        {
            dtype = "spike";
            org = self.origin + '0 0 16' + v_right*(ox*3);
        }
        else
        {
            dtype = "spike2";
            org = self.origin + '0 0 16' + v_right*(ox*2);
        }
        dir = aim (self, 100000);
        Piercer_Trace (org, org + dir*SPIKEY_RANGE, self, SPIKEY_DAMAGE, self, TE_SPIKE);
        StackDamage_Clear (self, self, dtype);
    }
    else
    {
        dir = aim (self, 1000);
        if (self.war == WAR_NAILGUN)
        {   ox = ox * 1.5;
            launch_spike (self.origin + '0 0 16' + v_right*ox, dir);
        }
        else
            launch_spike (self.origin + '0 0 16' + v_up*ox, dir);   // '8 10 12+ox'
        if (self.war == WAR_SUPER_NAILGUN)
            newmis.classname = "spike2";    // For obituary.
    }
};
void() W_EchoSpike_Up = {W_EchoSpike(2);};
void() W_EchoSpike_Down = {W_EchoSpike(-2);};

void(float ox) W_FireSpikes =
{
    local   vector  dir, org;
    local   float   super;
    local   string  sfx;
    local   float   pay;
    local   float   tome;   // If TRUE, use hitscan instead of missiles.
    local   float   half;   // Half cost with equalizer.
    local   float   hits;   // How many shots, for ToP'ed sng.

    tome = self.tome_finished;
    if (self.perms & POW_DOUBLE)
        half = TRUE;
    else
        half = FALSE;

    makevectors (self.v_angle);
    super = FALSE;
    sfx = "weapons/spike2.wav";
    pay = hits = 1;
    if (self.war == WAR_NAILGUN)
    {
        ox = ox * 1.5;      // ox == 3.  Use * 2 for the old 4.
        sfx = "weapons/rocket1i.wav";
        if (!tome && half)
        {
            if (ox < 0)
                pay = 0;    // Second nail is free.
        }
    }
    else
    {   // Super Nailgun
        if (tome)
        {   // Update 2/14/10:  Minigun mode.
            // Since this is hitscan, do this even in multiplayer.
            if (half)
                if (ox < 0)
                    pay = 0;
        }
        else if (coop || deathmatch)
        {   // Fire superspikes instead to reduce network traffic.
            if (half)
                super = TRUE;
            else if (self.ammo_nails >= 2)
                {super = TRUE;  pay = 2;}
        }
        else
        {   // Single player.
            // PM:  Keep 1200 rounds/minute in single-player even in Drake.
            // More dakka is always fun.
            if (ox < 0)
                Echo_Shot (0.05, W_EchoSpike_Down);
            else
                Echo_Shot (0.05, W_EchoSpike_Up);
        }
    }
    if (pay)
        if (self.ammo_nails < 1)
            {War_FindBestWeapon (); return;}

    self.effects = self.effects | EF_MUZZLEFLASH;

    sound (self, CHAN_WEAPON, sfx, 1, ATTN_NORM);
    self.attack_finished = time + 0.2;
    if (pay)
        self.currentammo = self.ammo_nails = self.ammo_nails - pay;

    if (tome)
    {   // ToP makes nailguns fire armor-piercing, hitscan bullets.
        ox = ox * 2;    // Hitscan with no bonus, so extend offset.
        dir = aim (self, 100000) * SPIKEY_RANGE;
        if (self.war == WAR_NAILGUN)
        {   // ToP also doubles nailgun's rate of fire.
            org = self.origin + '0 0 16' + v_right*ox;
            Piercer_Trace (org, org + dir, self, SPIKEY_DAMAGE, self, TE_SPIKE);
            // Fire a second nail from the same barrel a moment later.
            if (ox < 0)
                Echo_Shot (0.05, W_EchoSpike_Down);
            else
                Echo_Shot (0.05, W_EchoSpike_Up);
            StackDamage_Clear (self, self, "spike");
        }
        else
        {   // Super Nailgun
            // Update 2/14/10:  Minigun mode -- fire three shots per 0.1 sec.
            org = self.origin + '0 0 16' + v_up*fabs(ox);
            Piercer_Trace (org, org + dir, self, SPIKEY_DAMAGE, self, TE_SPIKE);
            Echo_Shot (1/30, W_EchoSpike_Down);
            Echo_Shot (2/30, W_EchoSpike_Up);
            StackDamage_Clear (self, self, "spike2");
        }
    }
    else
    {   // Normal weapons.
        dir = aim (self, 1000);
        org = self.origin + '0 0 16';
        if (super)
        {
            // Viewmodel has 9 frames, 0 = idle, 1-8 = firing.
            // Use current frame to determine which origin will be.
            // Fires at all frames from 1 to 8.
            pay = self.weaponframe & 3;
            if (pay == 0)
                org = org - v_up*ox;
            else if (pay == 1)
                org = org + v_right*ox;
            else if (pay == 2)
                org = org + v_up*ox;
            else
                org = org - v_right*ox;
            launch_superspike (org, dir);
        }
        else
        {
            launch_spike (org + v_right*ox, dir);
        }
        if (self.war == WAR_SUPER_NAILGUN)
            newmis.classname = "spike2";    // For obituary.
    }

    self.punchangle_x = -2;
};

// Magic Missiles -- Used by the wand and monsters such as hell knights.
void(vector start, vector dir, float sped) Knightspike_Launch =
{
    launch_spike (start, dir);
    setform (newmis, "progs/k_spike.mdl", VEC_ORIGIN, VEC_ORIGIN);        
    newmis.worldtype = TE_KNIGHTSPIKE;
    newmis.classname = "knightspike";
    newmis.speed     = sped;
    newmis.velocity  = dir * sped;
};


//=============================================================================
//
//  BLASTER BOLTS (a.k.a. LASERS)
//
//=============================================================================

void() player_run;
void() SuperDamageSound;

void() HipLaser_Touch =
{
    if (pointcontents(self.origin) == CONTENT_SKY)
        {remove (self); return;}
    if (Reflected ())
        return;

    self.owner = world;
    self.cnt = self.cnt + 1;
    BounceShot_TraceNormal ();
    // Don't check '.health'!
    if ( other.takedamage && ((self.master != other) || !self.worldtype) )
    {
        self.touch = SUB_Null;      // Stack overflow prevention.
        if (self.master == other)
            self.dmg = self.dmg / 2;
        spawn_touchblood (self.dmg, other.bloodtype);
        T_NewDamage (other, self, self.master, self.dmg, DF_NONE, self.classname);
    }
    else if ((self.cnt >= 3) || (random() < self.volume))
    {   // Stop the laser.
        Tent_Point (TE_GUNSHOT, self.origin);
    }
    else
    {   // Rebound off the wall.
        self.dmg = 0.9 * self.dmg;    // Lose 10% power after each hit.
        BounceShot_Move ();
        if (self.tome_time)
            BounceShot_Seek ();     // Redirect to an enemy.
        sound (self, CHAN_WEAPON, "hipweap/laserric.wav", 1, ATTN_STATIC);
        return;
    }
    sound (self, CHAN_WEAPON, "enforcer/enfstop.wav", 1, ATTN_STATIC);
    remove (self);
};

void() Laser_Touch =
{
    if (pointcontents(self.origin) == CONTENT_SKY)
        {remove (self); return;}
    if (Reflected ())
        return;

    local   vector  org;

    self.touch = SUB_Null;      // Stack overflow prevention.
    org = self.origin - 8*normalize(self.velocity);
    if (other.takedamage)   // Don't check '.health'!
    {
        SpawnBlood (org, self.velocity*0.2, self.dmg, other.bloodtype);
        T_NewDamage (other, self, self.master, self.dmg, DF_NONE, self.classname);
    }
    else
        Tent_Point (TE_GUNSHOT, org);
    sound (self, CHAN_WEAPON, "enforcer/enfstop.wav", 1, ATTN_STATIC);
    remove (self);
};

void() Laser_Think =
{
// Draw ion particle trails if necessary.  Used by mega enforcer.
// Also by ToP powered-up lasers.
    if (self.waitmin)
        particle (self.origin, self.velocity * 0.005, self.waitmin, 2);
    if (self.waitmax)
        particle (self.origin, self.velocity * 0.01, self.waitmax, 4);

// Hipnotic Laser Cannon:  Check motion.
    BounceShot_Think ();
};

// 'waitmin' = slow color, 'waitmax' = fast color.
void(entity shot, float rgb) Laser_Color =
{
    shot.skin = rgb;
    if (rgb == 3)   // Blue
        {shot.waitmin = 9;  shot.waitmax = 41;}
    else if (rgb == 2)  // Yellow
        {shot.waitmin = 105;  shot.waitmax = 193;}
    else if (rgb == 1)  // Red
        {shot.waitmin = 73;  shot.waitmax = 225;}
    else    // Orange
        {shot.skin = 0;  shot.waitmin = 97;  shot.waitmax = 233;}
    // Note:  For orange, I replaced 225 with 97 to stop blood in some ports.
};

void(vector org, vector vec, float lflags) Laser_Launch =
{
    newmis = spawn();
    newmis.master       = newmis.owner      = self;
    newmis.movetype     = MOVETYPE_FLYMISSILE;
    newmis.solid        = SOLID_BBOX;
    if (lflags & LF_GLOW)
        newmis.effects  = EF_DIMLIGHT;

    newmis.tome_time    = FALSE;
    newmis.classname    = "laser";
    newmis.speed        = 1000;
    newmis.velocity     = newmis.dest       = vec * newmis.speed;
    newmis.angles       = vectoangles(newmis.velocity);
    newmis.delay        = time + 5;     // Formerly '.attack_finished'.
    newmis.nextthink    = 0.01;
    newmis.think        = Laser_Think;
    newmis.touch        = Laser_Touch;
    if (lflags & LF_YELLOW)
    {   // Update 6/7/09:  Don't use blue lasers.  Use needles instead.
        newmis.skin     = 2;
        newmis.dmg      = 30;
        newmis.xfl      = newmis.xfl | XFL_GHOST_BANE;  // Can hit ghosts.
    }
    else if (lflags & LF_RED)
    {   newmis.skin     = 1;
        newmis.dmg      = 18;
    }
    else
    {   newmis.skin     = 0;
        newmis.dmg      = 15;
    }

    if (lflags & LF_SPARKS)
        Laser_Color (newmis, newmis.skin);
    else
        newmis.waitmin  = newmis.waitmax = 0;

    if (lflags & LF_BOUNCE)
    {
        newmis.frame    = 1;
        newmis.cnt      = 0;
        newmis.avelocity= '0 0 400';
        newmis.volume   = 0.15;
        newmis.touch    = HipLaser_Touch;
    }

// Qrack replaces laser model with builtin hot color particle effects.
    setall (newmis, "progs/laser.mdl", '0 0 0', '0 0 0', org);
};

//============
void(vector org, vector vec) LaunchLaser =
    {Laser_Launch (org, vec, LF_GLOW);};

void(vector org, vector vec, float glow) HIP_LaunchLaser =
{
    sound (self, CHAN_WEAPON, "hipweap/laserg.wav", 1, ATTN_NORM);
    if (glow)
        glow = LF_GLOW;
    if (self.tome_finished)
    {
        if (glow)
            glow = glow | LF_SPARKS;
        Laser_Launch (org, vec, glow | LF_YELLOW | LF_BOUNCE);
        newmis.tome_time= TRUE;     // Homing laser.
        newmis.cnt      = -1;   // Bounce one more time for three bounces max.
    }
    else
        Laser_Launch (org, vec, glow | LF_RED | LF_BOUNCE);
};

//=================
// HIP_FireLaser
//=================
void(float stat) HIP_FireLaser =
{
    local   vector  org;
    local   vector  dir;
    local   vector  out;
    local   float   ofs;
    local   float   aofs;
    local   float   glow;

    if (!self.button0 || intermission_running)  // PM:  Stop at intermission.
        {player_run (); return;}
    if (self.ammo_cells < 1)
        {War_FindBestWeapon (); return;}

    SuperDamageSound();
    self.effects = self.effects | EF_MUZZLEFLASH;
    makevectors (self.v_angle);

    ofs = 6;
    out = v_forward;
// PM:  Commented out next two lines because they look bad if fired up/down.
//    out_z = 0;
//    out = normalize(out);
    org = self.origin + ((12-ofs) * v_up) + (12*out);
    dir = aim (self, 1000);
    aofs = ofs * 0.707;
    glow = FALSE;
    Update_Cells (self, self.ammo_cells - 1);
    if (stat == 0)
    {
        org = org + (aofs*(v_right - v_up));
        HIP_LaunchLaser (org, dir, 0);
        if (self.ammo_cells >= 1)
        {   // PM:  Cells raised to 200, so eat another cell for 2nd laser.
            Update_Cells (self, self.ammo_cells - 1);
            org = org - (2*aofs*v_right);
            HIP_LaunchLaser (org, dir, 0);
        }
    }
    else if (stat == 1)
    {
        org = org + (ofs*v_up);
        if (self.tracer_time <= time)  //(random() < 0.1)
            {glow = TRUE; self.tracer_time = time + 0.5;}
        HIP_LaunchLaser (org, dir, glow);
        // PM:  Center laser no longer costs double, so no damage increase.
    // Update 4/19/09:  Remove impact removal chance so LC replaces blaster.
        newmis.volume = 0;      // No random chance of removal on impact.
    }
    else
    {   // Using the modified shotgun-turned-blaster model...
        org = self.origin + '0 0 12';
        if (stat == 2)
            if (self.tracer_time <= time)
                {glow = TRUE; self.tracer_time = time + 0.5;}

        HIP_LaunchLaser (org, dir, glow);
        newmis.volume = 0;      // No random chance of removal on impact.
        // Note to self:  Spread gun looks bad unless v_model is wide.
    }
    self.punchangle_x = -1;
};


//=======================================================================//
//  Energy Needles -- A laser alternative.

void() Needle_Gone =
{
    sound (self, CHAN_WEAPON, "enforcer/enfstop.wav", 1, ATTN_STATIC);
    BecomeFancy ( (self.skin & 3) * 4 + X32_SPARK_ORANGE, 4);
};

void() Needle_Touch =
{
    if (pointcontents(self.origin) == CONTENT_SKY)
        {remove (self);  return;}
    if (Reflected ())
        return;

    self.touch = SUB_Null;      // Stack overflow prevention.
    if (other.takedamage)   // Don't check '.health'!
    {
        SpawnBlood (self.origin, self.velocity*0.2, self.dmg, other.bloodtype);
        T_NewDamage (other, self, self.master, self.dmg, DF_NONE, self.classname);
    }
    self.origin = self.origin - 8*normalize(self.velocity);
//    self.effects = self.effects | EF_MUZZLEFLASH;
    Needle_Gone ();
};

void(vector start, vector dir, float mx) Needle_Launch =
{
    newmis = spawn ();
    newmis.master       = newmis.owner        = self;
    newmis.movetype     = MOVETYPE_FLYMISSILE;
    newmis.solid        = SOLID_BBOX;
    newmis.classname    = "needle";
// set missile speed
    newmis.movedir      = dir;
    newmis.speed        = 1000;
    newmis.velocity     = dir * newmis.speed;
    newmis.avelocity    = '0 0 0';
    newmis.angles       = vectoangles(newmis.velocity);
//    newmis.dest         = dir;
    newmis.dmg          = 18;
    newmis.dest         = newmis.velocity;
    newmis.oldorigin    = start;
    Laser_Color (newmis, mx);
// set missile duration
    newmis.touch        = Needle_Touch;
    newmis.delay        = time + 5;
    newmis.nextthink    = time + 0.1;
    newmis.think        = Laser_Think;

    setall (newmis, "progs/needle.mdl", '0 0 0', '0 0 0', start);
};


//==========================================================================
// MULTI-DAMAGE
//
// Collects multiple small damages into a single damage
//
// PM:  Damage that is affected by damage flags should be handled
// in the function that calls any of MultiDamage_xxx, not here.
// That is because in case I may want weapons that shoot multiple
// attacks that have different properties, yet hit simultaneously.
//==========================================================================
// PM:  Globals moved to global.qc.

void() MultiDamage_Clear = {multi_ent = world;  multi_damage = 0;  multi_headinjury = 0;};

void(string dtype) MultiDamage_Apply =
{
    if (multi_ent)
    {
        T_NewDamage (multi_ent, self, self, multi_damage, DF_NONE, dtype);
    }
};

void(entity hit, float damage, float trauma, string dtype) MultiDamage_Add =
{
    if (!hit)
        return;

    if (hit != multi_ent)
    {
        MultiDamage_Apply (dtype);
        multi_headinjury = trauma;
        multi_damage = damage;
        multi_ent = hit;
    }
    else
    {
        multi_headinjury = multi_headinjury + trauma;
        multi_damage = multi_damage + damage;
    //- - - - - - - - -
    // If the target takes enough damage to gib, damage it now.
    // Gibbing makes the target smaller and non-solid, allowing the remaining
    // shotgun pellets to hit more targets behind the one to be gibbed.
    // Note:  Also works for IK's antimatter gun.
    //- - - - - - - - -
        if (hit.th_gib)
            if (hit.health >= hit.gib_health)
        {
            local   vector  dv;     // x=damage taken, y=armor damage, z=x+y

            dv = CalcDamage (hit, self, multi_damage, DF_NONE);
            if (dv_x > (dv_y + hit.health - hit.gib_health))
            {   // Enough damage to gib the target, so do it now!
                if (hit.health < 0) // HACK:  Make it easier to gib dead guys.
                    multi_damage = multi_damage - hit.health;
                MultiDamage_Apply (dtype);
                MultiDamage_Clear ();
            }
            else
            {
            //- - - - - - - - -
            // Hack:  If zombie, treat head damage as double.  This means if
            // zombie has 60 health, it takes only 30 to the head to kill.
            // Headshot damage must be 25 or more to decapitate.
            //
            // Update 6/11/2011:  Only if not in classic mode.
            //- - - - - - - - -
                if (hit.classname == "monster_zombie")
                if (!q1shot)
                if (multi_headinjury >= 25)
                if (multi_headinjury * 2 >= hit.health)
                if (dv_x * 2 >= hit.health)
                {
                    multi_damage = multi_damage * 2;    // Boom! Headshot!
                    MultiDamage_Apply (dtype);
                    MultiDamage_Clear ();
                }
            }
        }
    }
};


//==========================================================================
//
//  BULLETS
//
//==========================================================================

//- - - - - - - - -
// Average rocket damage is 110 (100-120).  Scaling maximum damage down
// to 35, the new range is from 29.17 to 35, with the average at 32.08.
// 32*3 = 96, which is double of an equalized shotgun's 6*8 (or 12*4) = 48.
// Super shotgun's damage rate is doubled similarly by the Tome.
// Note:  Damage based on unmodified shotguns (or those in nsoe).
// Recent decision was made to buff shotguns for Drake.
float   EXSHELL_DAMAGE  = 35;

// For Tome of Power shotguns.
void(float shotcount, float damage, vector src, vector dir, vector spread,
    string dtype, void() xfx)  FireExploShots;

// Sample exploding function to use when calling 'xfx' in 'FireExpShots'
void() TraceExploShell_Think =
{
    T_NewRadiusDamage (self, self.owner, self.dmg, self.enemy, self.cnt, self.deathtype);
    Rocket_Explosion2 (self.origin, 224, 16);
    BecomeFancy (X32_PUFF_ORANGE, 5);
};
//- - - - - - - - -

// Used by shotguns and other hitscan scatterguns such IK's Asha gun.
// Update:  Also used by flare gun/ruby wand.
// Note:  'damage' is used only to check reflection against courage armor.
// 'sparks' -- x=color1, y=color2, z=density (0=none).
void(vector org, vector dir, float dist, float damage, entity attacker,
    vector sparks)  Lead_Hitscan =
{
    local   entity  ignore;
    local   vector  end;
    local   float   loop;

    ignore = attacker;
    loop = 3;
    while (loop > 0)
    {
        end = org + dir*dist;
        traceline (org, end, FALSE, ignore);
        if (sparks_z >= 1)
            Particle_Beam (org, trace_endpos, sparks_x, sparks_y, sparks_z, TRUE);
        if (trace_fraction != 1.0)
        {
            if (HasReflection (trace_ent, trace_endpos, damage))
            {
                ignore = trace_ent;
                org = trace_endpos;
                dir = normalize (org - ignore.origin);
                dist = dist * (1 - trace_fraction);
                ReflectSound (trace_ent);
            }
            else
                return;
        }
        else
            return;

        loop = loop - 1;
    }
// Reflected too many times, so fake a miss.
    trace_fraction = 1.0;
    trace_ent = world;
};


//================
// TraceAttack
//================
void(float damage, vector dir, string dtype) TraceAttack =
{
    local   vector  org;
    
    if (pointcontents(trace_endpos) == CONTENT_SKY)
        return;     // This is new -- do nothing if impact is in the sky.

    org = trace_endpos - dir*4;
    if (trace_ent.takedamage)
    {
// Update 3/6/11:  Decapitation check.
        local   float   trauma;

        // Hullbox can be bigger than model, so use more than a sixth.
        trauma = trace_ent.absmin_z + trace_ent.size_z * 0.8;
        if (trace_endpos_z > trauma)
            trauma = damage;
        else
            trauma = 0;
//- - - - - - - - -

        dir = dir + v_up*crandom();
        dir = dir + v_right*crandom();
        dir = normalize(dir);
        dir = (dir + 2*trace_plane_normal) * 40;    // 200 * 0.2 = 40.

        SpawnBlood (org, dir, damage, trace_ent.bloodtype);
        MultiDamage_Add (trace_ent, damage, trauma, dtype);
    }
    else
        Tent_Point (TE_GUNSHOT, org);
};

//================
// FireShots (formerly FireBullets)
//
// Used by shotgun, super shotgun, and enemy soldier firing
// Go to the trouble of combining multiple pellets into a single damage call.
//================
void(float shotcount, float damage, vector src, vector dir, vector spread,
    string dtype)  FireLead =
{
    local   vector  direction;
    local   vector  vec;
    local   vector  side, up;

// Calculate side and up vectors from the aim vector.
    vec = Vangles (dir);
    makevectors (vec);
    side = v_right;
    up = v_up;

// Do the shotgun attack loop.
    MultiDamage_Clear ();
    while (shotcount > 0)
    {
        direction = dir + crandom()*spread_x*side;
        direction = direction + crandom()*spread_y*up;

        Lead_Hitscan (src, direction, 2048, damage, self, '0 0 0');  // PM:  Checks for reflection.
        if (trace_fraction != 1.0)
            TraceAttack (damage, direction, dtype);

        shotcount = shotcount - 1;
    }
    MultiDamage_Apply (dtype);
};

// Returns the source point given by the old shotgun code.
vector() BulletSource =
{
    local   vector  src;

    if (self.flags & FL_CLIENT)
        makevectors (self.v_angle);
    else
        makevectors (self.angles);

    src   = self.origin + v_forward*10;
    src_z = self.absmin_z + self.size_z * 0.7;

    return src;
};

// This is now a support function for the real deal.  Left here so
// I do not need to change code in the monster files that use this.
void(float shotcount, vector dir, vector spread) FireBullets =
{
    local   vector  org;

    org = BulletSource ();
    FireLead (shotcount, 4, org, dir, spread, "");
};

//================
// W_FireShotgun
//================
void() W_FireShotgun =
{
    local   vector  dir, org;

    if (q1shot)
        sound (self, CHAN_WEAPON, "weapons/guncock.wav", 1, ATTN_NORM);
    else
        sound (self, CHAN_WEAPON, "weapons/shotgn2.wav", 1, ATTN_NORM);
    self.punchangle_x = -2;
    self.currentammo = self.ammo_shells = self.ammo_shells - 1;
    org = BulletSource ();      // This calls makevectors.
    dir = aim (self, 100000);
// Attack!
    if (self.tome_finished)
    {   // Explosive shotgun not unlike asha.
        self.velocity = self.velocity - dir*100;    // Recoil.
        FireExploShots (3, EXSHELL_DAMAGE, org, dir, '0.061 0.061 0', "shotgun", TraceExploShell_Think);
        return;
    }
// Pellet attack.
    if (q1shot)
    {   // The old wimpy pistol-posing-as-shotgun attack.
        FireLead (6, 4, org, dir, '0.04 0.04 0', "shotgun");
    }
    else
    {   // PM:  Going for 60 dps.  42 dmg / 0.7 sec.
        // Update:  44/0.7 = 62.857.  A bit high, but acceptable.
        // Thus, shoot 11 pellets of 4 dmg, not 7 pellets/6 dmg.
        // Update 6/8/11:  12 pellets for 48 damage.  DPS = 68+.
        // Update 6/9/11:  9 pellets @ 5 dmg each for 45 damage.  DPS = 64+.
        FireLead (9, 5, org, dir, '0.061 0.061 0', "shotgun");
    }
};

void() W_FireSSG =
{
    if (self.ammo_shells < 2)
        {W_FireShotgun ();  return;}

    local   vector  dir, org;

    if (q1shot)
        sound (self, CHAN_WEAPON, "weapons/shotgn2.wav", 1, ATTN_NORM);
    else
        sound (self, CHAN_WEAPON, "weapons/ssg.wav", 1, ATTN_NORM);
    self.punchangle_x = -2;
    self.currentammo = self.ammo_shells = self.ammo_shells - 2;
    org = BulletSource ();      // This calls makevectors.
    dir = aim (self, 100000);
// Attack!
    if (self.tome_finished)
    {   // Explosive shotgun not unlike asha.
        // Careful with recoil -- too much makes rocket jumping too easy.
        self.velocity = self.velocity - dir*150;
        FireExploShots (7, EXSHELL_DAMAGE, org, dir, '0.14 0.08 0', "ssg", TraceExploShell_Think);
        return;
    }
// Pellet attack.
    if (q1shot)
    {   // Classic attack.  Fine for a shotgun, but a double shotty? Ewww!
        FireLead (14, 4, org, dir, '0.14 0.08 0', "ssg");
    }
    else
    {   // With total damage at 108, use two calls at 54 damage each.
        // That way, the shotgun cannot gib zombies without help from
        // damage modifiers.
        // Update 6/8/11:  13 pellets x4 x2 for 112 damage.
        // Update 6/9/11:  11 pellets x5 x2 for 110 damage.  Same DPS as Q3.
        //  More than 110 means shambler goes from full hp to gibbed in six
        //  shots, and gug dies in nine instead of ten.
        FireLead (11, 5, org, dir, '0.14 0.08 0', "ssg");
        FireLead (11, 5, org, dir, '0.14 0.08 0', "ssg");
        // Also, if the first call gibbed a target, the second call
        // will hit whatever was behind the gibbed, similar to old
        // Doom shotguns piercing the dead.
    }
};


//==========================================================================
//
//  EXPLODING BULLETS
//  (Useful for explosive shotgun shells or asha's antimatter blasts)
//
//==========================================================================

//// Sample exploding function to use when calling 'xfx' in 'FireExpShots'
//void() TraceExplo_Think =
//{
//    T_NewRadiusDamage (self, self.owner, self.dmg, self.enemy, self.cnt, self.deathtype);
//    Tent_Point (TE_EXPLOSION, self.origin);     // For DP's explosion fx.
//    BecomeExplosion ();
//};

void(float damage, vector dir, string dtype, void() xfx) TraceExploAttack =
{
    local   vector  org;
    
    if (pointcontents(trace_endpos) == CONTENT_SKY)
        return;

    org = trace_endpos - dir*8;     // Yes, use 8 for sprite placement.
    if (trace_ent.takedamage)
    {   // Adding explosive fuel to the fire...
        local   float   ldmg;

        ldmg = SUB_RandomDamage (damage);
        MultiDamage_Add (trace_ent, ldmg, 0, dtype);
    }

    // Spawn an explosion entity to put on a linked list.
    newmis = spawn();
    newmis.owner     = self;
    newmis.enemy     = trace_ent;
    newmis.oldenemy  = shot_head;
    newmis.dmg       = damage;
    newmis.deathtype = dtype;
    newmis.cnt       = DF_ROCKET;
    newmis.think1    = xfx;
    setmodel (newmis, "");
    setorigin (newmis, org);
    // Don't use chain because findradius will overwrite that.
    // Some engines, like DarkPlaces, pick up even SOLID_NOT.
    shot_head = newmis;
};

void() TraceExploBoom =
{
    local   entity  swap;   // Placeholder for the entity self.

    swap = self;
    self = shot_head;
    while (self)
    {
        self.think1 ();     // Explosion effects.
        if (self == self.oldenemy)
            self = world;   // Infinite loop -- break!
        else
            self = self.oldenemy;   // Proceed to next link.
    }
    self = swap;
};

// Like FireBullets for shotguns and the like, except with explosions.
void(float shotcount, float damage, vector src, vector dir, vector spread,
    string dtype, void() xfx)  FireExploShots =
{
    local   vector  direction;
    local   vector  vec;
    local   vector  side, up;

// Calculate side and up vectors from the aim vector.
    vec = Vangles (dir);
    makevectors (vec);
    side = v_right;
    up = v_up;

// Do the shotgun attack loop.  As Iikka Keranen would write:
// "This uses multidamage to gib whenever possible. ;)"
    shot_head = world;
    MultiDamage_Clear ();
    while (shotcount > 0)
    {
        direction = dir + crandom()*spread_x*side;
        direction = direction + crandom()*spread_y*up;

        // Assuming rocket-like explosions, don't use full damage vs. courage.
        Lead_Hitscan (src, direction, 2048, COURAGE_DAMAGE, self, '0 0 0');  // PM:  Checks for reflection.
        if (trace_fraction != 1.0)
            TraceExploAttack (damage, direction, dtype, xfx);

        shotcount = shotcount - 1;
    }
    MultiDamage_Apply (dtype);

// IK's antimatter gun delays the explosions for one frame.  However,
// I want the explosions NOW!  Therefore, use the linked list of explosion
// entities to do all the explody stuff right here and now!
    TraceExploBoom ();
};


//==========================================================================
//
//  MELEE WEAPONS
//
//==========================================================================

//================
// W_FireSaw
//================
void(entity targ, vector dir) Attack_Saw =
{
    local   vector  spot;

    spot = self.origin + '0 0 16';      // 'source'
    traceline (spot, spot + dir*64, FALSE, self);
    if (trace_fraction == 1.0)
        return;

    // This next check is for AI-controlled monsters aiming at 'targ',
    // which should equal 'self.enemy'.
    if (targ)
        if (trace_ent != targ)
            return;     // Missed target.

    spot = trace_endpos - dir*4;        // 'org'
    targ = trace_ent;
    if (targ.takedamage)
    {
        local   vector  vec;
        local   float   damage, dflags, pain;
        local   string  dtype;

        dtype = "chainsaw";     // Normal kill.
        dflags = DF_SCAR | DF_MELEE;
        damage = 24;
        if (trace_fraction <= 0.5)
        {   // Deep hit.
            dtype = "saw_decap";    // Chop off the head.
            if (targ.xsf & XSF_BODY_DOUBLE)     // Chop up flimsy bodies.
                if (targ.max_health < 50)
                    if (targ.health > damage)
                        damage = targ.health;
        }
        if (self.tome_finished) // Suck life like Heretic's necro gauntlets.
        {
            if (damage < 40)
                damage = 40;
            dflags = dflags | DF_LEECH;
        }

    // Blood!
        vec = ((random()*300) - 150) * v_right + (100 * v_forward);
        SpawnBlood (trace_endpos, '0 0 5', damage, targ.bloodtype);
        if (self.weaponframe & 1)
            SpawnMeatSpray (self.origin + dir*16, vec, targ.bloodtype);
    // Damage!
        pain = FeelsPain (targ);
        T_NewDamage (targ, self, self, damage, dflags, dtype);
        if (targ.solid != SOLID_BSP)
            targ.velocity = targ.velocity * 0.5;
    // Sounds.
        sound (self, CHAN_WEAPON, "weapons/sawguts.wav", 1, ATTN_NORM);
        if (targ.hittype == HIT_METAL)
            if (pain && (targ.pain_finished > time))
                sound (self, CHAN_AUTO, "weapons/clang.wav", 1, ATTN_NORM);

        self.punchangle_x = -8;
    }
    else
    {   // Hit wall.
        sound (self, CHAN_WEAPON, "player/axhit2.wav", 1, ATTN_NORM);
        Tent_Point (TE_GUNSHOT, spot);
    }
};

void() W_FireSaw =
{
    if (cutscene || intermission_running)
        return;     // Abort if in intermission.
    makevectors (self.v_angle);
    Attack_Saw (world, v_forward);
};

//================
// W_FireAxe
//================
// Returns TRUE if we hit something, FALSE on a whiff.
float(entity targ, vector dir) Attack_Axe =
{
    local   vector  spot;
    local   float   damage, dflags;

    if (!self.button0)  // If attack is not held, assume power swing.
        self.attack_finished = self.attack_finished + 0.2;

    spot = self.origin + '0 0 16';      // 'source'
    traceline (spot, spot + dir*64, FALSE, self);
    if (trace_fraction == 1.0)
        return FALSE;

    // This next check is for AI-controlled monsters aiming at 'targ',
    // which should equal 'self.enemy'.
    if (targ)
        if (trace_ent != targ)
            return FALSE;   // Missed target.

    targ = trace_ent;
    spot = trace_endpos - dir*4;        // 'org'
    if (targ.takedamage)
    {
        local   string  dtype;
        local   float   dead, pain;
        local   float   decap;

        dead = targ.deadflag;
        pain = FeelsPain (targ);
        decap = FALSE;

        dtype = "axe";
        dflags = DF_MELEE;
        if (self.button0 || self.encore)
            damage = 24;
        else
            damage = 30;
        if (self.tome_finished)
        {
            dflags = dflags | DF_LEECH;
            damage = damage + 20;
        }
        if ((targ.flags & FLx_CREATURE) || (targ.solid == SOLID_SLIDEBOX))
        {
            dflags = dflags | DF_SCAR;
            if (self.flags & FL_CLIENT) // Only players can behead others.
            if (trace_fraction <= 0.5)
            {   // A clean hit.
                if (self.weaponframe > 4)
                    dtype = "axe_decap1";   // Cross slash, knock off head.
                else
                    dtype = "axe_decap2";   // Overhead, smash head to pieces.
                decap = TRUE;
            }
        }

        if ((targ.solid == SOLID_BSP) || (targ.hittype == HIT_STONE))
            sound (self, CHAN_WEAPON, "weapons/axhitwal.wav", 1, ATTN_NORM);    // zombie/z.hit.wav
        else if (!(targ.hittype == HIT_METAL))  // We'll play metalheads' hit sounds below.
            sound (self, CHAN_WEAPON, "weapons/axhit.wav", 1, ATTN_NORM);
        // PM:  Removed 'targ.axhitme = 1;'.  Obsolete in Drake.
        SpawnBlood (spot, '0 0 0', damage, targ.bloodtype);
        T_NewDamage (targ, self, self, damage, dflags, dtype);
    // Play alt. hit sound when armored targets won't clang.
        if (targ.hittype == HIT_METAL)
        {   // Play all of the clanging sounds here instead of monster pain.
            damage = random();
            if (damage < 0.2)
                dtype = "weapons/sword3.wav";
            else if (pain && (targ.pain_finished > time))
                dtype = "weapons/clang.wav";
            else
                dtype = "weapons/sword2.wav";
            if (targ.deadflag)
            {
                if (targ.model == targ.mdl_head)
                    decap = TRUE;
                if (decap)
                    dtype = "weapons/axhit.wav";    // Gibbed or decapitated.
                else if (!dead)
                    dtype = "weapons/clang.wav";
            }
            sound (self, CHAN_WEAPON, dtype, 1, ATTN_NORM);
        }
    }
    else
    {   // Hit wall.
        sound (self, CHAN_WEAPON, "player/axhit2.wav", 1, ATTN_NORM);
        Tent_Point (TE_GUNSHOT, spot);
    }
    self.axhitme = time + 0.2;      // Don't play ax swoosh on next swing.
    return TRUE;
};

void() W_FireAxe =
{
    if (cutscene || intermission_running)
        return;     // Abort if in intermission.

    makevectors (self.v_angle);
    Attack_Axe (world, v_forward);
};


//==========================================================================
//  Throwing Axe

// This removes the axe if its surface moves or if its been out too long.
// Update:  Also called by goblin arrow code for the same purpose.
void() Axe_Watch =
{
    if (self.delay <= time)
        remove (self);
    else if (vlen (self.enemy.velocity) > 0)
        remove (self);      // Surface moved, so remove the axe now.
    else
        self.nextthink = time + sys_ticrate;
};

// Called when a thrown axe hits something.
void() Axe_Touch =
{
    if (pointcontents(self.origin) == CONTENT_SKY)
        {remove (self); return;}
    if (Reflected ())
        return;

    if (other.takedamage)
    {
        self.touch = SUB_Null;      // Stack overflow prevention.
        spawn_touchblood (20, other.bloodtype);
        T_Damage (other, self, self.master, 20);
        sound (self, CHAN_WEAPON, "zombie/z_hit.wav", 1, ATTN_NORM);
        remove (self);
        return;
    }

    sound (self, CHAN_WEAPON, "player/axhit2.wav", 1, ATTN_NORM);
    if (other.solid != SOLID_BSP)   // e.g., shielded mega enforcer.
    {   // Bounce off object.
        if (self.velocity == '0 0 0')
            self.avelocity = '0 0 0';

        if (self.count > 2)     // Don't let it bounce too much.
        {
            local   vector  org;

            org = self.origin - 8*normalize(self.velocity);
            Tent_Point (TE_GUNSHOT, org);
            remove (self);
        }
        else
            self.count = self.count + 1;
        return;
    }
// Imbed into the surface.
    self.movetype = MOVETYPE_NONE;
    self.velocity = self.avelocity = '0 0 0';
    self.touch = SUB_Remove;
    if (other)
    {   // Hit something that may move later.  Watch the axe.
        self.enemy = other;
        self.delay = self.nextthink;
        self.nextthink = time + sys_ticrate;
        self.think = Axe_Watch;
    }
};

// This launches a throwing axe.
void(vector start, vector dir, vector add, string axe) Axe_Launch =
{
    newmis = spawn ();
    newmis.master       = newmis.owner      = self;
    newmis.movetype     = MOVETYPE_BOUNCE;
    newmis.solid        = SOLID_BBOX;
    newmis.classname    = "axe";
// set missile speed
    newmis.speed        = 600;
    newmis.velocity     = (dir * 600) + add;
    newmis.angles       = vectoangles(newmis.velocity);
    newmis.avelocity    = '-600 0 0';   // Make sure pitch = 0 - speed.
// set missile misc
    newmis.skin         = 0;    // Normal bloody axe.
    newmis.count        = 0;
    newmis.xfl          = XFL_WIND;     // Ride wind tunnels.
// set missile duration
    newmis.touch        = Axe_Touch;
    newmis.nextthink    = time + 2.5;
    newmis.think        = SUB_Remove;

    setall (newmis, axe, '0 0 0', '0 0 0', start);
};

/* DISABLED -- Unused.
void() W_FireThrowAxe =
{
// There is a delay before firing, so don't throw if not an appropriate time.
    if (cutscene || intermission_running)
        return;

// We can throw axe.
    local   vector  vec;

    sound (self, CHAN_WEAPON, "knight/sword1.wav", 1, ATTN_NORM);

    makevectors (self.v_angle);
    vec = '0 0 200';
    if (self.v_angle_x)
        {vec = vec + crandom()*v_right*10; vec = vec + crandom()*v_up*10;}

    Axe_Launch (self.origin, v_forward, vec, "progs/throwaxe.mdl");
};
*/


//===========================/  END OF FILE  /===========================//

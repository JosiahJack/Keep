//=========================================================================
// This file is like weapons.qc, except the attacks are used by monsters.

//==========================================================================
//  Archer Knight Arrows

// Update 11/24/09:  Constants moved to defs.

// Magic arrow explosion code.
void() AkArrow_Explode =
{
    self.count = self.count & 3;
    sound (self, CHAN_AUTO, "archer/explode.wav", 1, ATTN_NORM);
    Colored_Explosion (self.origin, self.count);
    BecomeFancy (X80_SPARK_ORANGE + (self.count * 6), 6);
};

void() AkArrow_Magic_Touch =
{
// Other, more powerful and explosive arrow types.
    if (self.worldtype)
    {
        if (other.flags & FLx_CREATURE)
        if (!Ally_Check (other, self.master))
        if (!HasReflection (other, self.origin, 0))
        if (other.mass && (other.mass <= MASS_SUPER))
        {   // Knockback effect.
            local   float   sped;

            sped = self.speed;
            if (other.mass == MASS_SUPER)
                sped = sped / 2;
            other.velocity = other.velocity + (self.movedir * sped);
            if (other.flags & FL_ONGROUND)
            {
                other.flags = other.flags - FL_ONGROUND;
                if (other.velocity_z < 150)
                    other.velocity_z = 150;
            }
        }
    }
    T_MissileTouch ();
};

// Called when an arrow hits something.
void() AkArrow_Wood_Touch =
{
    if (pointcontents(self.origin) == CONTENT_SKY)
        {remove (self); return;}
    if (Reflected ())
        return;

    self.touch = SUB_Null;      // Stack overflow prevention.
    if (other.takedamage)
    {
        spawn_touchblood (self.dmg, other.bloodtype);
        T_Damage (other, self, self.master, self.dmg);
        sound (self, CHAN_WEAPON, "archer/arrow1.wav", 1, ATTN_IDLE);
        remove (self);
        return;
    }
    if (other.solid != SOLID_BSP)   // e.g., shielded mega enforcer.
    {   // Break on impact.
        local   vector  org;

        org = self.origin - 8*normalize(self.velocity);
        sound (self, CHAN_WEAPON, "archer/arrowbrk.wav", 1, ATTN_IDLE);
        Tent_Point (TE_GUNSHOT, org);
        remove (self);
        return;
    }
// Imbed into the surface.
    if (random() < 0.5)
        sound (self, CHAN_WEAPON, "archer/arrow2.wav", 1, ATTN_IDLE);
    else
        sound (self, CHAN_WEAPON, "archer/arrow3.wav", 1, ATTN_IDLE);
    self.movetype = MOVETYPE_NONE;
    self.velocity = self.avelocity = '0 0 0';
    // Reset think so arrow sticks in wall for a moment then vanishes.
    self.nextthink= time + 1.5;
    self.think    = SUB_Remove;
    self.touch    = SUB_Remove;
    if (other)
    {   // Hit something that may move later.  Watch the axe... er, arrow.
        self.enemy      = other;
        self.delay      = self.nextthink;
        self.nextthink  = time + sys_ticrate;
        self.think      = Axe_Watch;
    }
};

void() AkArrow_Think =
{
    if (self.delay <= time)
        {remove (self); return;}

    self.speed   = vlen (self.velocity);
    self.movedir = self.dest = normalize (self.velocity);
    self.angles  = vectoangles(self.movedir);
    if (self.cnt)
        Meteor_Trail (self.cnt, 1, FALSE);

    self.nextthink = time + 0.05;

// PM:  Energy arrows can blast ghosts.
    if (self.worldtype)
        Ghost_Touch ();
};

void(vector start, vector dir, float type) AkArrow_Launch =
{
    newmis = spawn ();
    newmis.master       = newmis.owner        = self;
    newmis.movetype     = MOVETYPE_FLYMISSILE;
    newmis.solid        = SOLID_BBOX;
    newmis.classname    = "arrow";
// set missile speed
    newmis.movedir      = dir;
//    if (ARROW_FLY)
    {
        newmis.speed        = AKARROW_SPEED_FLY;
        newmis.velocity     = dir * newmis.speed;
    }
//    else
//    {
//        newmis.speed        = AKARROW_SPEED_TOSS;
//        newmis.velocity     = dir * newmis.speed;
//        newmis.velocity_z   = newmis.velocity_z + 200;
//        newmis.movetype     = MOVETYPE_TOSS;
//    }
    newmis.avelocity    = '0 0 0';
    newmis.avelocity_z  = newmis.speed;     // Makes arrow model spiral.
    newmis.angles       = vectoangles(newmis.velocity);
    newmis.dest         = dir;      // for 'spawn_touchblood'.
// set missile damage
// Damage: green = 5-7, red = 8-12, gold = 13-17
// For Quake, do x*3 so that orange = 15-20, gold = 25-35, blue = 40-50
// Update/Drake:  Green = 9, Red = 18, Yellow/Orange = 30.
    if (type & 2)
    {   // Energy arrow.
        type = newmis.count = 0;    // Was LF_YELLOW.
        Laser_Color (newmis, type);
        newmis.worldtype    = TRUE;     // FIXME:  Conflict with rocket code.
        newmis.dmg          = 30;
        newmis.think1       = AkArrow_Explode;
    // For more explosive arrow types, use safe flag so attacker doesn't
    // blow himself up.  Arrows don't explode in Hexen2, but I am making
    // them so in Drake.
    // Update 4/13/2009:  Removed lightning flag.
        newmis.style        = DF_SAFE;
        newmis.cnt          = newmis.waitmax;
        newmis.effects      = newmis.effects | EF_DIMLIGHT;
        newmis.oldorigin    = start;
        newmis.skin         = ARROW_MAGIC + type;  // Yes, use + not |.
    }
    else
    {
        newmis.worldtype    = FALSE;
        newmis.xfl          = newmis.xfl | XFL_WIND;
        // Normal wooden arrow.
        newmis.cnt          = 0;
        if (type & 4)
            newmis.dmg          = 9;    // Goblin arrow.
        else if (type & 1)
            newmis.dmg          = 18;   // Lord arrow.
        else
            newmis.dmg          = 15;   // Orc arrow.
        newmis.skin         = type & 1;
    }
    newmis.enemy        = world;
// set missile duration
    newmis.touch        = AkArrow_Magic_Touch;
    newmis.delay        = time + 5;         // Total duration
    newmis.nextthink    = time + 0.1;
    newmis.think        = AkArrow_Think;
    if (!newmis.cnt)
    {
        newmis.touch        = AkArrow_Wood_Touch;
//        if (ARROW_FLY)
        {
            newmis.nextthink    = newmis.delay;
            newmis.think        = SUB_Remove;
        }
    }

    if (self.classname == "monster_rebel")  // FIXME:  Crossbow bandit hack.
        newmis.frame        = 1;
    setall (newmis, "progs/arrow.mdl", '0 0 0', '0 0 0', start);
};


//==========================================================================
//  ShalMissile

void() ShalExplosion =
{
    Rocket_Explosion2 (self.origin, 128, 29);   // Purple explosion
    BecomeFancy (X56_PUFF_PURPLE, 6);
};

void() ShalHome =
{
// PM:  Also remove missile if player goes to intermission or cutscene.
    if ((self.enemy.health < 1) || !self.enemy.modelindex)
        {remove(self); return;}

// PM:  Missile speed set at spawn function.

// Merge overlapping missiles from the same attacker into one.
    local   entity  e, ex;

    e = findradius (self.origin, 10);
    while (e)
    {
        ex = e.chain;   // Must get before removing 'e'.
        if (e.master == self.master)
            if (e.enemy == self.enemy)
                if (e.think == ShalHome)
                    if (e != self)
                        {self.dmg = self.dmg + e.dmg;  remove (e);}
        e = ex;
    }

// Treat the missile as a living organism, meaning that it can chase an
// invisible target like a monster, albeit in a drunken way.
    local   vector  dir;

    dir = self.enemy.origin + '0 0 10';
    dir = Maim_Line (self.origin, dir, self.speed, world, '0 0 0');
    self.velocity = dir * self.speed;
    self.nextthink = time + 0.2;
    self.think = ShalHome;    

// NEW:  Hit ghosts too!
    Ghost_Touch ();
};

// Assumes a launch by monster.
void(vector start, vector dir, float flytime) Shal_Launch =
{
    local   entity  missile;

    missile = spawn ();
    missile.master      = missile.owner     = self;
    missile.movetype    = MOVETYPE_FLYMISSILE;
    missile.solid       = SOLID_BBOX;
//    missile.classname   = "shalmissle".
// set missile speed
    if ((skill >= 3) || cranked)
        missile.speed       = 350;
    else
        missile.speed       = 250;
    missile.velocity    = dir * 400;
    missile.avelocity   = '300 300 300';
//    missile.angles      = vectoangles(missile.velocity);
// set missile damage
    if (cranked)
        missile.dmg         = 60;
    else
        missile.dmg         = 40;
    missile.enemy       = self.enemy;
    missile.style       = DF_ROCKET | DF_SAFE | DF_ZKILL;
    missile.worldtype   = MDAM_GRENADE;
    missile.yaw_speed   = 360;  // PM: Let dragons know this cannot be dodged.
// set missile duration
    missile.touch       = T_MissileTouch;
    missile.nextthink   = flytime + time;
    missile.think       = ShalHome;
    missile.think1      = ShalExplosion;

    setall (missile, "progs/v_spike.mdl", '0 0 0', '0 0 0', start);

    newmis = missile;
};

// Shalmissile attack.  Used by shal-rath and others.
void(vector st, float damage, string sfx) M_Shal_Ex =
{
    local   vector  dir, org;
    local   float   flytime;

//    org = self.origin + '0 0 10';
    makevectors (self.angles);
    org = self.origin + (v_forward * st_x) + (v_right * st_y) + (v_up * st_z);
    dir = self.enemy.origin + '0 0 10';
    dir = Maim_Line (org, dir, 400, world, '0 0 0');
    flytime = vlen (self.enemy.origin - self.origin) * 0.002;
    if (flytime < 0.1)
        flytime = 0.1;

    self.effects = self.effects | EF_MUZZLEFLASH;
    sound (self, CHAN_WEAPON, sfx, 1, ATTN_NORM);
    Shal_Launch (org, dir, flytime);
    if (damage)
        newmis.dmg  = damage;
};

// Shalmissile attack.  Used by shal-rath.
void(vector st) M_Shal = {M_Shal_Ex (st, 0, "shalrath/attack2.wav");};

// hkboss damage was 26.
void(vector st) M_Shal30 = {M_Shal_Ex (st, 30, "hkboss/iceball.wav");};


//==========================================================================
//  Throwing Axe -- Used by axeman and overlord.

void(vector st, string axe) M_FireAxe =
{
    local   vector  org, dir;
    local   entity  targ;

    if (cranked)
        targ = self.enemy;
    else if ((self.classname == "monster_wraith_lord") || (self.classname == "monster_super_wrath"))
        targ = self.enemy;
    else
        targ = world;
    makevectors (self.angles);
    org = self.origin + v_forward*st_x + v_right*st_y + v_up*st_z;
    dir = Maim_Toss (org, self.enemy.origin, 600, 200, targ, '0 0 0');

    sound (self, CHAN_WEAPON, "knight/sword1.wav", 1, ATTN_NORM);

    Axe_Launch (org, dir, '0 0 200', axe);
};


//==========================================================================
//  Meat -- Used by zombie and nightshade (wraith dragon)

// Formerly 'ZombieGrenadeTouch'
void() Meat_Touch =
{
    if (pointcontents(self.origin) == CONTENT_SKY)
        {remove (self); return;}
    if (Reflected ())
        return;

    if (other.takedamage)
    {
        if (!self.dmg)
            self.dmg = 10;
        self.touch = SUB_Null;      // Stack overflow prevention.
//        if (cranked)
//            Poison_Add (other, 1);      // Give fatal illness like in movies.
        T_Damage (other, self, self.master, self.dmg);
        sound (self, CHAN_WEAPON, "zombie/z_hit.wav", 1, ATTN_NORM);
        remove (self);
        return;
    }
    sound (self, CHAN_WEAPON, "zombie/z_miss.wav", 1, ATTN_NORM);    // bounce sound
    self.velocity = self.avelocity = '0 0 0';
    self.touch = SUB_Remove;
};

// This was formerly 'ZombieFireGrenade'.
void(vector start, vector dir) Meat_Launch =
{
    newmis = spawn ();
    newmis.master       = newmis.owner      = self;
    newmis.movetype     = MOVETYPE_BOUNCE;
    newmis.solid        = SOLID_BBOX;
//    newmis.classname    = "meat";
// set missile speed
    newmis.speed        = 600;
    newmis.velocity     = dir * 600;
    newmis.velocity_z   = newmis.velocity_z + 200;  // Used to be 200 only.
    newmis.avelocity    = '3000 1000 2000';
// set missile damage
    newmis.dmg          = 10;
    if (self.classname == "monster_mummy")
        newmis.dmg          = random() * 15 + 15;
// set missile duration
    newmis.touch        = Meat_Touch;
    newmis.nextthink    = time + 2.5;
    newmis.think        = SUB_Remove;

    setall (newmis, "progs/zom_gib.mdl", '0 0 0', '0 0 0', start);
};

void(vector st) M_FireMeat =
{
    local   vector  org, dir;

    makevectors (self.angles);
    org = self.origin + v_forward*st_x + v_right*st_y + v_up*st_z;
    // Improved aim code.
    dir = Maim_Toss (org, self.enemy.origin, 600, 200, world, '0 0 0');

    sound (self, CHAN_WEAPON, "zombie/z_shot1.wav", 1, ATTN_NORM);

    Meat_Launch (org, dir);
};


//==========================================================================
//  Smart Fireballs -- Used by nemesant (and SoE sorcerer).

void() SmartBall_Think =
{
    if (self.delay <= time)
        {remove(self); return;}

    self.angles = vectoangles(self.velocity);

// Changed particle count from 25 at 10/sec to 10 at 20/sec.
// Note:  2000 speed rocket trails spawn 11 at about 50/sec.
    particle (self.origin, '0 0 1', 233, 10);   //particle (self.origin, '0 0 1', 233, 25);
    self.nextthink = time + 0.05;               //self.nextthink = time + 0.1;
};

void() SmartBall_Bounce =
{
    local   vector  p1, p2;
    local   float   up;

    p1 = self.origin;
    p2 = self.enemy.origin + self.enemy.view_ofs;   // Go for the eyes.
    up = Aim_TossUp (p1, p2, 400);

// Fireballs can be fooled by invisibility.
    self.flags = self.flags - (self.flags & FL_ONGROUND);
    self.velocity = Maim_SmartBall (p1, p2, 400, up, world, '0 0 0');
    self.velocity = self.velocity * 400;
    self.velocity_z = self.velocity_z + up;
    self.angles = vectoangles(self.velocity);

    self.nextthink = time + 0.01;
    self.think = SmartBall_Think;
};

void() SmartBall_Touch =
{
    if (pointcontents(self.origin) == CONTENT_SKY)
        {remove(self); return;}     // Disappeared into space.
    if (Reflected_Damage (COURAGE_DAMAGE))
        return;     // Bounced off reflective shield.

// Explode if...
// 1) Entity struck can take damage.
// 2) Fireball bounced more than three times.  One more than HipLaser.
// 3) Target is already dead.
    if (other.takedamage || (self.count >= 3) || (self.enemy.health <= 0))
    {   // Go BOOM!
        T_MissileTouch ();
        return;
    }

    // PM:  Removed 'hknight/hit.wav'.
    sound (self, CHAN_WEAPON, "nemesant/frblfly.wav", 0.6, ATTN_NORM);
    self.count = self.count + 1;
    self.think = SmartBall_Bounce;
    self.nextthink = time + 0.01;
};

void(vector start, vector dir, vector add) SmartBall_Launch =
{
    newmis = spawn ();
    newmis.master       = newmis.owner      = self;
    newmis.movetype     = MOVETYPE_TOSS;
    newmis.solid        = SOLID_BBOX;
    newmis.classname    = "fireball";
// set missile speed
    newmis.speed        = 600;
    newmis.velocity     = (dir * 600) + add;
    newmis.angles       = vectoangles(newmis.velocity);
// set missile damage
    if (cranked)
        newmis.dmg          = 60;
    else
        newmis.dmg          = 40;
    newmis.enemy        = self.enemy;
    newmis.style        = DF_ROCKET | DF_SAFE;
    newmis.worldtype    = MDAM_GRENADE;
// set missile special stuff
    newmis.count        = 0;
// set missile duration
    newmis.touch        = SmartBall_Touch;
    newmis.delay        = time + 20;    // Total duration
    newmis.nextthink    = time + 0.1;
    newmis.think        = SmartBall_Think;

    setall (newmis, "progs/smartbal.mdl", '0 0 0', '0 0 0', start);
};

void(vector st) M_FireSmart =
{
    local   vector  p1, p2, dir, up;
    local   entity  targ;

    targ = world;
    makevectors (self.angles);
    p1 = self.origin + (v_forward*st_x) + (v_right*st_y) + (v_up*st_z);
    p2 = Aimpoint (self.enemy);

    up = '0 0 0';
    up_z = Aim_TossUp (p1, p2, 600);
    dir = Maim_SmartBall (p1, p2, 600, up_z, targ, '0 0 0');
    if (!targ)
    {   // In case we can't hit enemy, just lob it straight ahead.
        TraceToss (p1, up + dir*600, FALSE, self, 5);
        if (trace_ent != self.enemy)
            up_z = 200;
    }

    self.effects = self.effects | EF_MUZZLEFLASH;
    sound (self, CHAN_AUTO, "nemesant/frblfly.wav", 0.6, ATTN_NORM);

    SmartBall_Launch (p1, dir, up);
};


//==========================================================================
//  Knight Fireball -- Used by hell knight and baron.

void(vector start, vector dir) KnightBall_Launch =
{
    local   entity  missile;

    missile = spawn ();
    missile.master      = missile.owner     = self;
    missile.movetype    = MOVETYPE_FLYMISSILE;
    missile.solid       = SOLID_BBOX;
    missile.classname   = "fireball";
// set missile speed
    missile.speed       = 1000;
    missile.velocity    = dir * 1000;
    missile.angles      = vectoangles(missile.velocity);
    missile.avelocity   = '0 0 0';
    missile.avelocity_z = random()*2000 - 1000;
// set missile damage
    missile.dmg         = 60;
    missile.enemy       = world;
    missile.style       = DF_ROCKET;    // Shamblers take half damage.
// set missile duration
    missile.touch       = T_MissileTouch;
    missile.nextthink   = time + 5;
    missile.think       = T_MissileExplode;
    missile.think1      = Orange_Explosion;

    missile.frame       = 2;
    setall (missile, "progs/k_ball.mdl", '0 0 0', '0 0 0', start);

    newmis = missile;
};

void(vector st, float lo) M_FireKnight =
{
    local   vector  p1, p2, dir;
    local   entity  targ;

//    if (cranked)
//        targ = self.enemy;
//    else
        targ = world;
    makevectors (self.angles);
    p1 = self.origin + (v_forward * st_x) + (v_right * st_y) + (v_up * st_z);
    p2 = Aimpoint (self.enemy);
    if (lo)
        p2_z = self.enemy.absmin_z + 1;
    dir = Maim_Line (p1, p2, 1000, targ, '0 0 0');

    self.effects = self.effects | EF_MUZZLEFLASH;
    sound (self, CHAN_WEAPON, "baron/fireball.wav", 1, ATTN_NORM);

    KnightBall_Launch (p1, dir);
};


//==========================================================================
//  Imp Fireball -- Used by imps (duh!)

// Use this only for small imp fireballs.
void() ImpBall_Think =
{
    if (self.delay <= time)
        {remove (self);  return;}

    self.nextthink = time + 0.2;
    Fireball_InWater (self);    // fire.qc: Removes self if in the water.
};

void(vector start, vector dir) ImpBall_Launch =
{
    local   entity  missile;

    missile = spawn ();
    missile.master      = missile.owner     = self;
    missile.movetype    = MOVETYPE_FLYMISSILE;
    missile.solid       = SOLID_BBOX;
    missile.classname   = "fireball";
// set missile speed
    missile.speed       = 600;
    missile.velocity    = dir * 600;
    missile.angles      = vectoangles(missile.velocity);
// set missile damage
    missile.dmg         = 20;
    missile.enemy       = world;
    missile.style       = DF_FIRE | DF_ROCKET | DF_SAFE;
// set missile duration
    missile.touch       = T_MissileTouch;
    missile.delay       = time + 5;
    missile.nextthink   = time + 0.2;
    missile.think       = ImpBall_Think;
    missile.think1      = Orange_Explosion;

    missile.frame       = 0;
    setall (missile, "progs/k_ball.mdl", '0 0 0', '0 0 0', start);

    newmis = missile;
};


//==========================================================================
//  Energy Shards -- Used by hell knight derivates, namely the golem.

void() GoShard_Explosion =
{
    sound (self, CHAN_AUTO, "enforcer/enfstop.wav", 1, ATTN_NORM);
    Colored_Explosion (self.origin, self.skin);
    BecomeFancy ((self.skin & 3) * 5 + X32_STAR_ORANGE, 5);
};

void() GoShard_Think =
{
    local   float   rgb;

    if (self.delay <= time)
        {remove (self); return;}

    self.speed   = vlen (self.velocity);
    self.movedir = self.dest = normalize (self.velocity);
    self.angles  = vectoangles(self.movedir);

    self.lefty  = !self.lefty;
    if (self.lefty)
        rgb = self.waitmin;
    else
        rgb = self.waitmax;
    if (rgb)
        Meteor_Trail (rgb, 1, FALSE);

    self.nextthink = time + 0.05;

    Ghost_Touch ();     // PM:  Energy arrows can blast ghosts.
};

void(vector start, vector dir) GoShard_Launch =
{
    newmis = spawn ();
    newmis.master       = newmis.owner        = self;
    newmis.movetype     = MOVETYPE_FLYMISSILE;
    newmis.solid        = SOLID_BBOX;
    newmis.classname    = "arrow";
// set missile speed
    newmis.movedir      = dir;
    newmis.speed        = 1000;
    newmis.velocity     = dir * newmis.speed;
    newmis.avelocity    = '0 0 0';
    newmis.angles       = vectoangles(newmis.velocity);
    newmis.dest         = dir;      // for 'spawn_touchblood'.
    if (cranked)
        newmis.dmg          = 60;
    else
        newmis.dmg          = 40;       // Was 60 -- too much.
    newmis.style        = DF_SAFE | DF_ROCKET;
    newmis.effects      = newmis.effects | EF_DIMLIGHT;
    newmis.skin         = 0;
    newmis.oldorigin    = start;
    Laser_Color (newmis, 0);    //newmis.skin & 3);
// set missile duration
    newmis.touch        = T_MissileTouch;
    newmis.delay        = time + 5;         // Total duration
    newmis.nextthink    = time + 0.1;
    newmis.think        = GoShard_Think;
    newmis.think1       = GoShard_Explosion;

    setall (newmis, "progs/akarrow.mdl", '0 0 0', '0 0 0', start);
};

void(vector st, float ofs) M_GoShard =
{
    local   vector  org, dir;
//    local   float   type;

    makevectors (self.angles);
    // Spawns at sword point regardless of velocity.
    org = self.origin + v_forward*st_x + v_right*st_y + v_up*st_z;
    dir = Aimpoint (self.enemy);
    dir = Vangles (dir - org);      //(self.enemy.origin - self.origin);
    makevectors (dir);
    // Do it this way so spread is preserved when shot up or down.
    // Doing it like hknight_shot chokes the spread if shot up or down,
    // and I don't want that.
    if (ofs)
    {
        dir = CoSine (0 - ofs);
        dir = v_forward*dir_x + v_right*dir_y;
    }
    else
        dir = v_forward;
    dir = Maim_Scatter (dir, '0 0 0');      // Use in case of inviso foe.

//    makevectors (self.angles);
//    org = self.origin + v_forward*st_x + v_right*st_y + v_up*st_z;
//    dir = Aimpoint (self.enemy);
//    dir = Maim_Line (org, dir, 1000, world, '0 0 0');

    GoShard_Launch (org, dir);
// HACK:  No lights for off-center shots.
    if (fabs(ofs) & 1)
        newmis.effects = newmis.effects - (newmis.effects & EF_DIMLIGHT);
};


//==========================================================================
//  Blood Star -- Used by Shub-Niggurath

void() BloodStar_Think =
{
// Shub spawns a lot of entities while dying, so remove all the spam.
    if ((self.delay <= time) || self.master.deadflag)
        {remove (self); return;}
    self.nextthink = time + 0.1;

    if (self.attack_finished > time)
        return;
    self.attack_finished = time + 0.5;

// FIXME:  Look for a favorite target, and shoot him if in los, else shoot
// the closest one.

// Spawn shots.
    local   entity  head;   //, head2;
    local   entity  inflictor, attacker;
    local   float   hits, hi;
    local   vector  end, spot;

    inflictor = self;
    attacker = self.master;
    spot = inflictor.origin;

    hits = 0;
    hi = 2;
    head = findradius (spot, 1000);
    while (head)
    {
    // Notarget/stealth won't save you from discharge.
        if (head.takedamage == DAMAGE_AIM)      // Was flags & FLx_CREATURE.
        if (head != attacker)
        if (!Ally_Check (head, attacker))
        {
            end = Midpoint (head);
            traceline (end, spot, TRUE, head);
            if (trace_fraction == 1)
            {
                end = normalize (end - spot);
                Needle_Launch (spot, end, 1);
                newmis.master = newmis.owner = attacker;
                sound (inflictor, CHAN_VOICE, "hknight/attack1.wav", 1, ATTN_NORM);

                hits = hits + 1;
                if (hits >= hi)
                    return;
            }
        }
        head = head.chain;
    }
};

void(vector start, vector dir) BloodStar_Launch =
{
    newmis = spawn ();
    newmis.master       = newmis.owner        = self;
    newmis.movetype     = MOVETYPE_NOCLIP;
    newmis.solid        = SOLID_BBOX;
    newmis.classname    = "rift";
    newmis.alpha        = ALPHA_GHOST;
// set missile speed
    newmis.movedir      = dir;
    newmis.speed        = 300;
    newmis.velocity     = dir * newmis.speed;
    newmis.avelocity    = '300 300 300';
    newmis.angles       = vectoangles(newmis.velocity);
    newmis.dest         = dir;      // for 'spawn_touchblood'.
    newmis.dmg          = 30;
    newmis.enemy        = world;
// set missile duration
    newmis.touch        = SUB_Null;
    newmis.delay        = time + 10;
    newmis.attack_finished = time + 0.5;
    newmis.nextthink    = time + 0.1;
    newmis.think        = BloodStar_Think;

    setall (newmis, "progs/shubstar.mdl", '0 0 0', '0 0 0', start);
};


//==========================================================================
//  Star Missile -- Used by Kinn's gauroch.

void() YakStar_Touch =
{
    if (Reflected ())
        return;

    self.touch = SUB_Null;      // Stack overflow prevention.
    T_Damage (other, self, self.owner, 9);
    self.origin = self.origin - 8*normalize(self.velocity);
    sound (self, CHAN_AUTO, "yakman/expsmall.wav", 1, ATTN_NORM);
    BecomeFpsExplosion (self.cnt + 6, 5, 20, "progs/s_kinn.spr");
};

void() YakStar_Think =
{
    if (self.frame < 11)
        Meteor_Trail (41, 2, TRUE);
    else if (self.frame < 22)
        Meteor_Trail (105, 2, TRUE);
    else
        Meteor_Trail (233, 2, TRUE);

    if (self.delay <= time)
        {remove (self); return;}
    self.walkframe = self.walkframe + 1;
    if (self.walkframe > 5)
        self.walkframe = 0;
    self.frame = self.cnt + self.walkframe;
    self.nextthink = time + 0.05;

    Ghost_Touch ();     // Magic missile can hit ghosts.
};

void(vector start, vector dir, float sped) YakStar_Launch =
{
    newmis = spawn ();
    newmis.master       = newmis.owner      = self;
    newmis.movetype     = MOVETYPE_FLYMISSILE;
    newmis.solid        = SOLID_BBOX;
    newmis.classname    = "firebolt";
// set missile speed
    newmis.speed        = sped;
    newmis.velocity     = dir * sped;
    newmis.angles       = vectoangles(newmis.velocity);
// set missile damage
    newmis.dmg          = 9;
//    newmis.style        = DF_NONE;
// set missile special stuff
//    newmis.lefty        = 0;
    newmis.dest         = dir;
    newmis.oldorigin    = start;    // For proper particle trail drawing.
// set missile duration
    newmis.touch        = YakStar_Touch;
    newmis.delay        = time + 5;     // Total duration.  As spikes.
    newmis.nextthink    = 0.01;
    newmis.think        = YakStar_Think;

    newmis.cnt = newmis.frame = self.skin * 11;
    newmis.walkframe = 0;
    setall (newmis, "progs/s_kinn.spr", '0 0 0', '0 0 0', start);
};


//==========================================================================
//  Bile Bomb -- Used by green dragon.  (Gug uses similar attack in Quoth.)

void() Bile_Explosion =
{
    Rocket_Explosion2 (self.origin, 48, 16);
    BecomeFancy (X56_SPLASH_GREEN, 3);
};

void(float ofs) BileFrag_Launch =
{
    local   vector  dir, vel;
    local   float   r;
    local   float   qsin, qcos;

// Find cosine and sine of offset angle.
    r = random() * 60 + 30;
    dir = '0 0 0';
    dir_y = r;
    makevectors (dir);
    qcos = v_forward_x;
    qsin = v_forward_y;

    dir = '0 0 0';
    dir_y = ofs;
    makevectors (dir);
    vel = ((v_forward * qcos) + (v_up * qsin)) * 400;

    newmis = spawn ();
    newmis.master       = self.master;
    newmis.owner        = self.owner;
    newmis.movetype     = MOVETYPE_BOUNCE;
    newmis.solid        = SOLID_BBOX;
    newmis.classname    = "acid";
// set missile speed
    newmis.speed        = 400;
    newmis.velocity     = vel;
    newmis.avelocity    = '300 300 300';
    newmis.angles       = vectoangles(newmis.velocity);
// set missile damage
    newmis.dmg          = self.dmg;
    newmis.style        = self.style;
// set missile duration
    newmis.touch        = T_MissileTouch;
    newmis.nextthink    = time + 0.5 + random();
    newmis.think        = T_MissileExplode;
    newmis.think1       = Bile_Explosion;

    setall (newmis, "progs/acidbal2.mdl", '0 0 0', '0 0 0', self.origin);
};

void() Bile_Split =
{
    local   float   add, ofs;

    if (self.cnt < 2)
        self.cnt = 2;   // Need at least two shots for useful splitting.
    else if (self.cnt > 8)
        self.cnt = 8;   // Protect against excess edict spawning.

    add = 360 / self.cnt;
    ofs = random() * add;
    while (ofs < 360)
        {BileFrag_Launch (ofs);  ofs = ofs + add;}
};

// Call this instead of T_Missilexxx because of splitting.
void() Bile_Touch =
{
    if (pointcontents(self.origin) == CONTENT_SKY)
        {remove(self);  return;}
    if (Reflected_Damage (COURAGE_DAMAGE))
        return;

    if (!self.dmg)
        self.dmg = 60;

    self.touch = SUB_Null;      // Stack overflow prevention.
    if (other.takedamage == DAMAGE_AIM)
    {   // On direct hit, bypass split and explode for double damage.
        local   float   damage;

        damage = SUB_RandomDamage (self.dmg * 2);
        T_NewDamage (other, self, self.master, damage, self.style, self.classname);
    }
    else
        Bile_Split ();    // Split into mini-bombs.
    T_NewRadiusDamage (self, self.master, self.dmg, other, self.style, self.classname);

    self.origin = self.origin - 8*normalize(self.velocity);
    Bile_Explosion ();
};

void(vector start, vector dir, float sped, float damage) Bile_Launch =
{
    newmis = spawn ();
    newmis.master       = newmis.owner      = self;
    newmis.movetype     = MOVETYPE_TOSS;
    newmis.solid        = SOLID_BBOX;
    newmis.classname    = "acid";
// set missile speed
    newmis.speed        = sped;
    newmis.velocity     = dir * sped;
    newmis.avelocity    = '200 100 300';
    newmis.angles       = vectoangles(newmis.velocity);
// set missile damage
    newmis.dmg          = damage;
    newmis.cnt          = 3;    // Was 4.
// set missile special stuff
    newmis.dest         = dir;
    newmis.style        = DF_ACID | DF_ROCKET;
// set missile duration
    newmis.touch        = Bile_Touch;
    newmis.nextthink    = time + 5;
    newmis.think        = SUB_Remove;
    newmis.think1       = Bile_Explosion;

    setall (newmis, "progs/acidbal1.mdl", '0 0 0', '0 0 0', start);
};

void() Acidball_Explosion =
{
    Rocket_Explosion2 (self.origin, 48, 16);
    BecomeFancy (X56_CLOUD_GREEN, 5);
};

void(vector start, vector dir, float sped, float damage) Acidball_Launch =
{
    newmis = spawn ();
    newmis.master       = newmis.owner      = self;
    newmis.movetype     = MOVETYPE_TOSS;
    newmis.solid        = SOLID_BBOX;
    newmis.classname    = "acid";
// set missile speed
    newmis.speed        = sped;
    newmis.velocity     = dir * sped;
    newmis.avelocity    = '200 100 300';
    newmis.angles       = vectoangles(newmis.velocity);
// set missile damage
    newmis.dmg          = damage;
// set missile special stuff
    newmis.dest         = dir;
    newmis.style        = DF_ACID | DF_ROCKET;
// set missile duration
    newmis.touch        = T_MissileTouch;
    newmis.nextthink    = time + 5;
    newmis.think        = SUB_Remove;
    newmis.think1       = Acidball_Explosion;

    setall (newmis, "progs/acidbal1.mdl", '0 0 0', '0 0 0', start);
};


//==========================================================================
//  Acid -- Used by scrag and green dragon.

void() Acid_Think =
{
    if (self.delay <= time)
        {remove (self); return;}

    self.angles = vectoangles (self.velocity);
    self.nextthink = time + 0.1;
};

void(vector start, vector dir, float sped) Acid_Launch =
{
    launch_spike (start, dir);
    setform (newmis, "progs/w_spike.mdl", VEC_ORIGIN, VEC_ORIGIN);        
    newmis.worldtype = TE_WIZSPIKE;
    newmis.classname = "wizspike";
    newmis.speed     = sped;
    newmis.velocity  = dir * sped;
};

void(vector start, vector dir, float sped) Acid_Toss =
{
    Acid_Launch (start, dir, sped);

    newmis.movetype  = MOVETYPE_TOSS;
    newmis.speed     = sped;
    newmis.velocity  = (dir * sped) + '0 0 200';
    newmis.angles    = vectoangles (newmis.velocity);
    newmis.delay     = newmis.nextthink;
    newmis.nextthink = time + 0.1;
    newmis.think     = Acid_Think;
};


//==========================================================================
//  Magic Missiles -- Used by hell knight, baron, and nemesant.

// Moved to 'weapons.qc'.


//==========================================================================
//  Rain Storm -- Used by the elemental boss barons.

//- - - - - - - - -
// Various missile functions for the rainstorm.
void() RainStorm_Ice =
{
// Use flymissile instead of toss for the missile clip bonus.
// Then set speed to a reasonably fast value to use for terminal velocity.
    Ice_Launch (trace_endpos, '0 0 -1', 1000);
    newmis.master   = newmis.owner  = self.owner;
    newmis.delay    = time + 2.5;
    newmis.dmg      = self.dmg;
};

// DISABLED -- Unused.
//void() RainStorm_Fire =
//{
//    Fireball_Launch (self.owner, trace_endpos, '0 0 -1', 1000, self.dmg);
//    newmis.delay    = time + 2.5;
//    newmis.noise    = "hknight/hit.wav";
//    newmis.style    = newmis.style | DF_SAFE;
//};

// DISABLED -- Unused.
//void() RainStorm_Steel =
//{
//    launch_superspike (trace_endpos, '0 0 -1');
//    newmis.master   = newmis.owner  = self.owner;
//    newmis.nextthink= time + 2.5;
//    newmis.dmg      = self.dmg;
//};
//- - - - - - - - -

void() RainStorm_Think =
{
    if (self.delay <= time)
    {
        super_active = 0;
        remove (self);
        return;
    }

// Find a point to spawn a rain drop.
    local   vector  p1, p2, dir;

    p1 = self.enemy.origin;
    p2_x = crandom() * self.distance + p1_x;
    p2_y = crandom() * self.distance + p1_y;
    p2_z = p1_z;

    traceline (p1, p2, TRUE, self);
    p2 = trace_endpos;
    if (trace_fraction < 1)
    {   // Move away from the wall a tiny bit.
        dir = normalize (p2 - p1);
        p2 = p2 - dir*2;
    }
    traceline (p2, p2 + '0 0 2048', TRUE, self);
    // Move endpoint away from the ceiling.
    // We can't pass vectors to a void() function, so use trace_endpos.
    if (trace_fraction < 1)
        trace_endpos = trace_endpos - '0 0 2';

    if (self.think1)
        self.think1 ();
    else
        {remove (self);  return;}

    self.nextthink = time + self.wait;
};

// Spawns a missile spawner that drops shots on a target from the ceiling.
void(entity targ, entity attacker, float damage, float fps, float dist,
    float limit, void() thinkst) RainStorm =
{
    if (limit)
    if (super_active)   // FIXME:  Check this only if attacker is a monster.
        return;

    super_active = 1;       // This chews through a lot of edicts.

    if (!fps)
        fps = 10;
    if (!dist)
        dist = 64;

    newmis = spawn();
    setorigin (newmis, '0 0 0');

    newmis.owner    = attacker;
    newmis.enemy    = targ;
    newmis.delay    = time + 5;
    newmis.think    = RainStorm_Think;
    newmis.think1   = thinkst;
    newmis.dmg      = damage;
    newmis.wait     = 1 / fps;
    newmis.distance = dist;
    newmis.nextthink= 0.01;
};


//==========================================================================
//  Light Wall

// Yes, this is a cut-and-paste job from the firewall code.
float   SPEED_LIGHTWALL  = 400;

void() Lightwall_Think =
{
    local   float   pc;
    local   vector  spot;

    if (self.delay <= time)
        {remove (self);  return;}   // Time's up.
    pc = pointcontents (self.origin);
    if (pc == CONTENT_SOLID)
        {remove (self);  return;}   // In the void.

// Trace lightning bolt.
    traceline (self.origin, self.origin + '0 0 4096', TRUE, self);
    spot = trace_endpos;
    LightningBolt (spot, spot - '0 0 8192', self.master, self.dmg, self, TE_LIGHTNING2, "lightning");
    particle (trace_endpos, trace_plane_normal, 41, 10);

// The rest of the spawner missile think.
    if (self.enemy)
    {   // Steer toward the enemy.
        spot = self.enemy.origin + self.enemy.view_ofs;
        {   // Change yaw only.  Aim_Line plots intercept course.
            // Use 'normalize(spot - self.origin)' instead to follow directly.
            spot = Aim_Line (self.origin, spot, SPEED_LIGHTWALL, self.enemy);
            self.ideal_yaw = vectoyaw(spot);
            self.ideal_yaw = anglemod(self.ideal_yaw);
            ChangeYaw ();
        }
        // Update direction.
        spot = self.angles;
        spot_x = 0 - spot_x;
        makevectors (spot);
        self.movedir  = v_forward;
    }
    self.velocity   = self.movedir * self.speed;
    self.angles     = vectoangles(self.velocity);
    self.nextthink  = time + 0.05;
};

void(vector start, vector dir, entity targ) Lightwall_Spawn =
{
    newmis = spawn ();
    newmis.master       = newmis.owner      = self;
    newmis.movetype     = MOVETYPE_NOCLIP;  // Pass through all.
    newmis.solid        = SOLID_NOT;
    newmis.classname    = "lightning";
// set missile speed
    newmis.speed        = SPEED_LIGHTWALL;
    newmis.movedir      = dir;
    newmis.velocity     = dir * SPEED_LIGHTWALL;
    newmis.angles       = vectoangles(newmis.velocity);
// set missile damage
    newmis.dmg          = 15;   // Half of 30.
    newmis.enemy        = targ;
    newmis.yaw_speed    = 5;    // Thinks 20/sec, effective yaw_speed of 10.
// set missile duration
    newmis.delay        = time + 6;
    newmis.nextthink    = time + 0.05;
    newmis.think        = Lightwall_Think;

    newmis.modelindex = 0;      // Missile is invisible.
    setsize (newmis, '0 0 0', '0 0 0');        
    setorigin (newmis, start);

    sound (newmis, CHAN_WEAPON, "weapons/lstart.wav", 1, ATTN_NORM);
};

// Launch a lightning wall.  Designed for use by storm knights.
void() M_Lightwall =
{
    local   entity  targ;
    local   vector  org, dir;

    self.effects = self.effects | EF_MUZZLEFLASH;

// DISABLED -- No initial intercepting aim.
//    if (skill >= 2)     // As with Chthon, lead on Hard and up.
//        targ = self.enemy;
//    else
        targ = world;
    org = self.origin + self.view_ofs;
    dir = self.enemy.origin + self.enemy.view_ofs;
    dir = Maim_Line (org, dir, SPEED_LIGHTWALL, targ, '0 0 0');
    Lightwall_Spawn (org, dir, world);

// Hack (hknight):  On Normal or higher, the bolt seeks the enemy.
    if (skill >= 1)
        newmis.enemy = self.enemy;
};


//=========================================================================
//  Multishot Firebomb -- used by Chthon.

void() Firebomb_Explosion =
{
    local   float   r;

    r = random() * 3 & 3;
    if (r == 0)
        sound (self, CHAN_AUTO, "boss1/explode.wav", 1, ATTN_NORM);
    else if (r == 1)
        sound (self, CHAN_AUTO, "boss1/explode2.wav", 1, ATTN_NORM);
    else
        sound (self, CHAN_AUTO, "boss1/explode3.wav", 1, ATTN_NORM);
    Tent_Explosion2 (self.origin, 224, 16);
    BecomeTheBigFire ();
};

void(float ofs) FirebombFrag_Launch =
{
    local   vector  dir, vel;

    dir = '0 0 0';
    dir_y = ofs;
    makevectors (dir);
    vel = v_forward * self.speed + '0 0 200';

    newmis = spawn ();
    newmis.master       = self.master;
    newmis.owner        = self.owner;
    newmis.movetype     = MOVETYPE_TOSS;
    newmis.solid        = SOLID_BBOX;
    newmis.classname    = "fire";
// set missile speed
    newmis.speed        = self.speed;
    newmis.velocity     = vel;
    newmis.avelocity    = '200 100 300';    // was '300 300 300'
    newmis.angles       = vectoangles(newmis.velocity);
// set missile damage
    newmis.dmg          = self.dmg;
    newmis.style        = self.style;
    newmis.worldtype    = self.worldtype;
// set missile duration
    newmis.touch        = T_MissileTouch;
    newmis.nextthink    = time + 5;
    newmis.think        = T_MissileExplode;
    newmis.think1       = Firebomb_Explosion;

    setall (newmis, "progs/lavaball.mdl", '0 0 0', '0 0 0', self.origin);
};

void() Firebomb_Split =
{
    local   float   add, ofs;

    if (self.cnt < 2)
        self.cnt = 2;   // Need at least two shots for useful splitting.
    else if (self.cnt > 8)
        self.cnt = 8;  // Protect against excess edict spawning.

    add = 360 / self.cnt;
    ofs = random() * add;
    while (ofs < 360)
        {FirebombFrag_Launch (ofs);  ofs = ofs + add;}
};

void() Firebomb_Touch =
{
    if (pointcontents(self.origin) == CONTENT_SKY)
        {remove(self);  return;}
    if (Reflected_Damage (COURAGE_DAMAGE))
        return;

    if (!self.dmg)
        self.dmg = 90;

    self.touch = SUB_Null;      // Stack overflow prevention.
    if (other.takedamage)
    {
        local   float   damage;

        if (self.worldtype == MDAM_FULL)
            damage = self.dmg;
        else
            damage = SUB_RandomDamage (self.dmg);
        T_NewDamage (other, self, self.master, damage, self.style, self.classname);
    }
    T_NewRadiusDamage (self, self.master, self.dmg, other, self.style, self.classname);
    Firebomb_Split ();

    self.origin = self.origin - 8*normalize(self.velocity);
    Firebomb_Explosion ();
};

// For Necros' style Chthon.
void() Firebomb_ExplosionMulti =
{
    Firebomb_Split ();
    Firebomb_Explosion ();
};

void(vector start, vector dir, float sped, float damage) Firebomb_Launch =
{
    newmis = spawn ();
    newmis.master       = newmis.owner      = self;
    newmis.movetype     = MOVETYPE_FLYMISSILE;
    newmis.solid        = SOLID_BBOX;
    newmis.classname    = "fire";
// set missile speed
    newmis.speed        = sped;     //500;
    newmis.velocity     = dir * newmis.speed;
    newmis.avelocity    = '200 100 300';
    newmis.angles       = vectoangles(newmis.velocity);
// set missile damage
    newmis.dmg          = damage;
    newmis.cnt          = 5;        // Number of fragments spawned.
// set missile special stuff
    newmis.dest         = dir;
    newmis.style        = DFx_FIREBALL | DF_ROCKET;
    newmis.worldtype    = MDAM_FULL;
// set missile duration
    newmis.touch        = Firebomb_Touch;   //T_MissileTouch;
    newmis.nextthink    = time + 5;
    newmis.think        = T_MissileExplode;
    newmis.think1       = Firebomb_ExplosionMulti;
//    newmis.th_win       = Firebomb_Split;

    setall (newmis, "progs/lavaball.mdl", '0 0 0', '0 0 0', start);
};


//==========================================================================
//
//  Coven of Ebony Attacks
//
//==========================================================================

//==========================================================================
//  Necrosnake

void() NecroSnake_Touch =
{
    if (pointcontents(self.origin) == CONTENT_SKY)
        {remove(self);  return;}
    if (Reflected ())
        return;

    self.touch = SUB_Null;      // Stack overflow prevention.
    if (other.takedamage && (other.classname != self.master.classname))
    {
        spawn_touchblood (self.dmg, other.bloodtype);
        T_NewDamage (other, self, self.master, self.dmg, DF_NONE, self.classname);
        // Update 6/11/2011:  Removed poison critical hits.
    }
    else
        Tent_Point (TE_WIZSPIKE, self.origin);
    remove (self);
};

// Launches a sidewinding poison shot.  Used by acolytes.
void(vector start, vector dir, float sped) NecroSnake_Launch =
{
    newmis = spawn ();
    newmis.master       = newmis.owner        = self;
    newmis.movetype     = MOVETYPE_FLYMISSILE;
    newmis.solid        = SOLID_BBOX;
    newmis.classname    = "wizspike";
// set missile speed
    newmis.speed        = sped;
    newmis.velocity     = dir * sped;
    newmis.angles       = vectoangles(newmis.velocity);
// set missile damage
    newmis.dmg          = 9;
    newmis.enemy        = self.enemy;
// set missile special stuff
    newmis.worldtype    = TE_WIZSPIKE;
    newmis.speed        = sped;
    newmis.yaw_speed    = 10;
    newmis.ideal_yaw    = self.angles_y;
    // Get the spot we want to hit if fired straight without a target.
    newmis.pos2         = start + (dir * ((newmis.speed + newmis.height) * 5));
// set missile duration
    newmis.touch        = NecroSnake_Touch;     //spike_touch;
    newmis.delay        = time + 5;     // Total duration
    newmis.nextthink    = time + 0.1;
    newmis.think        = Sidewinder_Think;

    setall (newmis, "progs/w_spike.mdl", '0 0 0', '0 0 0', start);
};


//==========================================================================
//  Explosive Runes -- Used by Ebon Sorcerer.

void() NecroBomb_Explode =
{
    self.enemy = world;
    T_MissileExplode ();
};

void() NecroBomb_Touch =
{
    if (other != self.owner)
    if (self.wait < time)
    {
        // We cannot use solid_trigger self to explode because that will
        // break links as soon as a set* builtin is called in an explosion
        // function.  To circumvent this problem, spawn a dummy entity
        // to do all the damage and explosion stuff.  In the meantime,
        // self will be removed like an item.
        local   entity  ent;

        // Make the rune disappear as a taken item.
        self.touch = SUB_Null;      // Stack overflow prevention.
        self.solid = SOLID_NOT;
        self.model = world.null_string;    //string_null;

        // Spawn dummy, copy necessary fields, then explode.
        ent = spawn();
        ent.master    = ent.owner     = self.master;
        ent.touch     = SUB_Null; 
        ent.solid     = SOLID_NOT;
        ent.style     = self.style;
        ent.dmg       = self.dmg;
        ent.classname = self.classname;
        setorigin (ent, self.origin);
        SUB_Think (ent, NecroBomb_Explode);

        remove (self);      // Remove the rune.
    }
};

// Deposits an explosive rune where the necro is standing.
void(vector org) NecroBomb =
{
    newmis = spawn ();
    newmis.master       = newmis.owner        = self;
    newmis.movetype     = MOVETYPE_FLY;
    newmis.solid        = SOLID_TRIGGER;
    newmis.classname    = "necrobomb";
// set missile speed
    newmis.velocity     = '0 0 0';
    newmis.angles       = '0 0 0';
    newmis.angles_y     = random() * 360;   //self.angles_y;
// set missile damage
    newmis.style        = DF_ROCKET;
    newmis.dmg          = 70;
// set missile duration
    newmis.touch        = NecroBomb_Touch;
    newmis.wait         = time + 0.2;
    newmis.nextthink    = time + 1;     //(1 + random()) * 0.5
    newmis.think        = NecroBomb_Explode;

    setall (newmis, "progs/nec_rune.mdl", '-16 -16 -24', '16 16 32', org);
};


//==========================================================================
//  Necrobolt -- Used by Ebon Warlock and Dark Lord

// Update:  Instead of splitting into multiple mini-spikes, the bolt now
// redirects like shal-rath homing bombs, except update frequency is longer.
// It resembles more like the Amazon's Guided Arrows from Diablo 2.
void() NecroBolt_Think =
{
    if (self.delay <= time)
    {
        local   vector  vec;

//        if ((self.count > 3) || (self.enemy.health <= 0))
        if ((self.dmg <= 40) || (self.enemy.health <= 0))
        {
            BecomeFancy (X32_STAR_RED + 3, 2);
            return;
        }

        vec = Aimpoint (self.enemy);
        vec = normalize (vec - self.origin);

    // Each update weakens the bolt, so long distance attacks are
    // less effective.
//        self.count      = self.count + 1;
        self.dmg        = self.dmg - 10;
        self.delay      = time + 1;     // Much like Diablo2 Guided Arrow.
        self.velocity   = vec * self.speed;
        self.angles     = vectoangles(self.velocity);
        self.owner      = world;    // Let bolt hit the source now.
    }

// Draw particle trail.
    particle (self.origin, self.velocity * 0.005, 73, 2);
    particle (self.origin, self.velocity * 0.01, 225, 4);
    self.nextthink = time + sys_ticrate;

    Ghost_Touch ();
};

//void() NecroBolt_Explosion =
//{
//    Sfx_Discharge ();
//    Rocket_Explosion2 (self.origin, 247, 5);     // Red
//    BecomeFancy (X56_PLASMA_RED, 6);
//};

void() NecroBolt_Touch =
{
    if (pointcontents(self.origin) == CONTENT_SKY)
        {remove(self);  return;}
    if (Reflected_Damage (COURAGE_DAMAGE))
        return;

    self.touch = SUB_Null;      // Stack overflow prevention.

// PM:  Half strength would be 50+d10, but since older progs used 50+d20
// and gives the shot more oomph, I'll leave damage alone.
    if (other.classname != self.master.classname)
    {
    // Note:  Warlocks are immune, and shamblers take full damage.
        local   float   damage;

        damage = (self.dmg - 20) + (random() * 20);
        if (damage > 0)
            T_Damage (other, self, self.master, damage);
    }
// PM:  Don't use 120 radius damage because that is too much.
// Also, even though effects look like lightning, it isn't -- it's magic!
    T_NewRadiusDamage (self, self.master, self.dmg, other, self.style, self.classname);

// Create wicked red electric explosion.
    self.origin = self.origin - 8*normalize(self.velocity);
    Sfx_Discharge ();
    Rocket_Explosion2 (self.origin, 247, 5);     // Red
    BecomeFancy (X56_PLASMA_RED, 6);
};

// Launches a crimson energy seeker bolt.  Used by warlocks.
void(vector start, vector dir) NecroBolt_Launch =
{
    newmis = spawn ();
    newmis.master       = newmis.owner        = self;
    newmis.movetype     = MOVETYPE_FLYMISSILE;
    newmis.solid        = SOLID_BBOX;
    newmis.classname    = "necrobolt";
// set missile speed
    newmis.speed        = 600;
    newmis.velocity     = dir * 600;
    newmis.avelocity    = '0 0 1200';
    newmis.angles       = vectoangles(newmis.velocity);
// set missile damage
    newmis.yaw_speed    = 360;  // PM: Let dragons know this cannot be dodged.
    newmis.style        = DF_ROCKET | DF_SAFE;
    newmis.dmg          = 70;   // max(50+d20) = 70.
    newmis.enemy        = self.enemy;
// FIXME:  warlock immunity.
//    newmis.worldtype    = MDAM_TWENTY;
// set missile duration
    newmis.touch        = NecroBolt_Touch;
    newmis.delay        = time + 0.8;   // Total duration
    newmis.nextthink    = time + 0.1;
    newmis.think        = NecroBolt_Think;
//    newmis.think1       = NecroBolt_Explosion;

    setall (newmis, "progs/r_bolt.mdl", '0 0 0', '0 0 0', start);
};


//===========================/  END OF FILE  /===========================//

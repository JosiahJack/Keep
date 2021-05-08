// ------------------------------------------------------------- //
// |                    ** The BloodCube **                    | //
// |                 Heavily modified for Drake                | //
// |                                                           | //
// |  A new powerup.  The Cube is alive, and when you touch it | //
// |  you become its master.  The cube will start circling     | //
// |  above your head, and will atack any monsters on sight.   | //
// |  If you don't feed the Cube plenty of gibs, it will get   | //
// |  hungry and start to feed off of your blood.              | //
// |                                                           | //
// |  PM:  For us Star Control 2 junkies, bloodcube works      | //
// |  like the Chmmr "zap sats".                               | //
// ------------------------------------------------------------- //

// * prototypes *
void() StartCube;
void() Cube_die;
void() Cube_control;
void() SeekCube;    // PM:  Placed here; used by 'LookForBlood' now.

// Particle_Beam moved to 'fx.qc'.

// ----------------------------------------------------- //
//   CubeAttack - A new attack style for the BloodCube.  //
// ----------------------------------------------------- //
void(vector start, vector end, entity cube, entity targ) CubeAttack =
{
// Zerstorer multiplied damage by 5 if target health is less than damage.
// In Drake, just use the damage flag that gibs target if killed.
    local   float   damage;     // The amount of damage of one zap

    if (targ.bloodtype == BLOOD_RED)
        damage = 225;
    else if (targ.bloodtype == BLOOD_PURPLE)
        damage = 134;
    else
        damage = targ.bloodtype;
    Particle_Beam (start, end, targ.bloodtype, damage, 40, TRUE);

    if (deathmatch)
        damage = 15;
    else
        damage = 20;

// Since the cube is the creature dealing the damage, use proxy damage flag
// so that its owner takes all the credit (and blame).
    T_NewDamage (targ, cube, cube.owner, damage, DF_PROXY|DF_GIB, "BloodCube");

    if (self.t_width < time)
    {
        sound (self, CHAN_AUTO, "cube/bc_attck.wav", 1, ATTN_NORM);
        self.t_width = time + 0.4;
    }
};


// ----------------------------------------------------- //
//   Cube_Pulse - Replaces LookforBlood and FeedMe.      //
//                                                       //
//  PM:  I did not want to use xxx.aiment.  Therefore,   //
//  use 'findradius' to scan for targets then make the   //
//  cube attack every target found.                      //
// ----------------------------------------------------- //
void() Cube_Pulse =
{
    local   entity  head;
    local   float   hit;

    if (deathmatch)
        hit = 300;
    else
        hit = 400;
    head = findradius (self.origin, hit);
    hit = FALSE;
    
    while (head)
    {
        // PM:  Pick up gibs it encounters, and attack fresh targets.
        if (head.touch == Gib_Touch)
        {   // It's a gib.
            if (head.movetype != MOVETYPE_FLY)
            if (visible (head))
            {
                if (head.avelocity == VEC_ORIGIN)
                {   // Probably laying on the ground.
                    if (head.style)
                    {   // Assume head.
                        head.avelocity = crandom() * '0 600 0';
                    }
                    else
                    {   // Assume normal gib.
                        head.avelocity_x = random()*600;
                        head.avelocity_y = random()*600;
                        head.avelocity_z = random()*600;
                    }
                }
                head.movetype = MOVETYPE_FLY;
                head.solid = SOLID_TRIGGER;     //SOLID_BBOX;
                head.enemy = self;
                head.think = SeekCube;
                head.nextthink = time + random();
            }
        }
        else
        {
            if (head.flags & FLx_CREATURE)
            if (head.health > 0)
            if (head != self.owner)
            if (head.takedamage)
            if (head.solid)
            if (visible (head))
            {
                hit = TRUE;
                CubeAttack (self.origin, head.origin + '0 0 16', self, head);
            }
        }

        head = head.chain;
    }

    if (hit)
    {   // Got one!
        self.avelocity = '0 500 0';
        if (deathmatch)
            self.attack_finished = time + 0.25;     // 40% efficiency
        else
            self.attack_finished = time + 0.1;
    }
    else
        self.avelocity = '0 100 0';
};

void(vector cdest) FeedonPlayer =
{
    local   vector  spray;

    spray = cdest - self.owner.origin;
    particle (self.owner.origin + '0 0 24', spray, 225, 70);
    sound (self, CHAN_AUTO, "cube/bc_attck.wav", 1, ATTN_NORM);
    T_NewDamage (self.owner, self, self.owner, 1, DF_PROXY, "BloodCube");
    // Hereafter replaced .invisible_time with .delay.
    self.delay = time + 2;    // suck blood again in 2 secs
};

// --------------------------------------------------------- //
// | blood_CalcMove - Used to calculate the cubes velocity | //
// |  to get it to the next position.                      | //
// --------------------------------------------------------- //
void(vector tdest, float tspeed, void() func) blood_CalcMove =
{
local   vector  vdestdelta;
local   float   traveltime;

    self.finaldest = tdest;
    self.think = func;

    if (tdest == self.origin)
    {
        self.velocity = '0 0 0';
        self.nextthink = time + 0.05;
        return;
    }
    vdestdelta = tdest - self.origin;
    traveltime = vlen (vdestdelta) / tspeed;
    if (traveltime < 0.01)
    {
        self.velocity = '0 0 0';
        self.nextthink = time + 0.01;
        return;
    }
// PM:  Make sure the onground flag is off -- we don't want the
//      bloodcube frozen in mid-air.
    self.flags = self.flags - (self.flags & FL_ONGROUND);
    self.nextthink = time + traveltime;
    self.velocity = vdestdelta * (1/traveltime);
};


// ---------------------------------------------------- //
// | Cube_control - This is called by the Cube every  | //
// | 0.5 seconds.  It assigns the cube a destination  | //
// | and also scans the area for enemies.  Also keeps | //
// | track of all the timers.  It's a bit too big.    | //
// ---------------------------------------------------- //
void() Cube_control =
{
    if (self.owner.health <= 0)     // This should catch 'world' too.
    {
        Cube_die ();
        return;
    }

    if (self.owner.view_ofs == '0 0 0')     // PM:  Is this cutscene stuff?
    {
        self.velocity   = '0 0 0';
        self.think      = Cube_control;
        self.nextthink  = time + 0.5;
        return;
    }

    local   vector  cdest;
    local   float   clen, cuspeed;

    if (self.cnt == 0)
        cdest = self.owner.origin + '0 36 52';
    else if (self.cnt == 1)
        cdest = self.owner.origin + '25 25 52';
    else if (self.cnt == 2)
        cdest = self.owner.origin + '36 0 52';
    else if (self.cnt == 3)
        cdest = self.owner.origin + '25 -25 52';
    else if (self.cnt == 4)
        cdest = self.owner.origin + '0 -36 52';
    else if (self.cnt == 5)
        cdest = self.owner.origin + '-25 -25 52';
    else if (self.cnt == 6)
        cdest = self.owner.origin + '-36 0 52';
    else
        cdest = self.owner.origin + '-25 25 52';

    traceline (self.origin + '0 0 16', cdest, TRUE, self);
    //dprint(ftos(trace_fraction));dprint(" = trace_fraction\n");
    if (trace_fraction < 1)
        cdest = self.owner.origin + '0 0 48';
    traceline (self.origin, cdest + '0 0 32', TRUE, self);
    if (trace_fraction < 1)
        cdest = cdest - '0 0 16';
    clen = vlen(cdest - self.origin);
    if (clen > 500)
    {
        //sprint(self.owner, "The BloodCube teleports\n");
        setorigin (self, (self.owner.origin + '0 0 24'));
        self.velocity = '0 0 0';
        self.think = Cube_control;
        self.nextthink = time + 0.1;
        return;
    }
    if (clen < 50)
        cuspeed = clen * 2;
    else
        cuspeed = clen * 4;

    self.cnt = self.cnt + 1;
    if (self.cnt >= 8)
        self.cnt = 0;

    if (self.attack_finished < time)
        Cube_Pulse ();      // Sets attack_finished.

// Update 10/25/09:  Hereafter replaced .invincible_finished with
// .pain_finished.  Made change to prevent cube telefragging things in Drake.
    if (self.pain_finished < time)
    {   // "Give me blood!"
        sound (self, CHAN_ITEM, "cube/bc_hngry.wav", 1, ATTN_NORM);
        self.pain_finished = time + 30;
    }
    
    if (self.delay < time)
        FeedonPlayer (cdest);

    if (self.radsuit_finished < (time + 5))
    {
        if (!self.rad_time)
        {   // PM:  Cube is 'self' here, NOT 'other'.
            sound (self, CHAN_AUTO, "cube/bc_activ.wav", 1, ATTN_NORM);
            stuffcmd (self.owner, "bf\n");
            sprint (self.owner, "The Sanguinoch grows weary of you\n");
            self.rad_time = time + 5.5;
        }
        if (self.radsuit_finished < time)
        {
            sprint (self.owner, "The Sanguinoch has left you\n");
            Cube_die ();
            return;
        }
    }

    blood_CalcMove (cdest, cuspeed, Cube_control);
};

// ------------------------------------- //
// | bloodcb_touch - called when the   | //
// | cube touches something.  If it    | //
// | sees that it will hit a wall, it  | //
// | centers itself above player until | //
// | next call to Control_cube.        | //
// ------------------------------------- //
void() bloodcb_touch =
{
    if (self.solid == SOLID_NOT)    // Was 'delay == BLOOD_ASLEEP'.
        return;
    if (other.flags & FL_MONSTER)
        return;
    if (other.health <= 0 || other.classname != "player")
    {
        if (self.owner)
            self.velocity = ((self.owner.origin + '0 0 48') - self.origin)*2;
        return;
    }
    if (other == self.enemy)
    {   // PM:  Replaced .protect_time with .wait.
        if (self.wait < time)
        {   // PM:  Use centerprint so even dummies can read.
            centerprint (other, "The Sanguinoch doesn't want you anymore\n");
            self.wait = time + 2;   // Use +3 if sprint.
        }
        return;
    }

    if (self.owner)
        return;     // Already has an owner!

// PM:  Reset the size so the cube doesn't get stuck following owner.
    setsize (self, '-1 -1 -1', '1 1 1');
    self.owner = other;         // Cube is in the AWAKE state now
    self.cnt = 0;
    if (deathmatch)
        self.radsuit_finished = time + 30;
    else
        self.radsuit_finished = time + 40;
    self.rad_time = 0;
    self.pain_finished = time + 12;   //time until hungry sound
    self.delay = time + 2;

    sprint (other, "The Sanguinoch befriends you\n");
    sound (other, CHAN_AUTO, "cube/bc_activ.wav", 1, ATTN_NORM);
    stuffcmd (other, "bf\n");
    
    if (!deathmatch)
        SUB_UseTargets ();

    self.nextthink = time + 0.2;
    self.think = Cube_control;
};

// ----------------------------------------------------- //
// | Cube_die - called when cube leaves the player for | //
// |  any reason.  The cube will just lower itself a   | //
// |  few feet and wait for someone else to pick it up.| //
// |  The same player cannot pick it up twice in a row.| //
// |                                                   | //
// | PM:  If kept, cube is moved to its original       | //
// |  spawnpoint.                                      | //
// ----------------------------------------------------- //
void() Cube_die =
{
    self.enemy      = self.owner;
    self.owner      = world;
    self.solid      = SOLID_NOT;
    self.velocity   = self.avelocity    = '0 0 0';
    self.mdl        = self.model;
    self.model      = world.null_string;
    setorigin (self, self.oldorigin);

    if (deathmatch || coop)
    {
        self.nextthink  = time + 300;   // Five minutes.
        self.think      = StartCube;
        return;
    }

// dhm: in single play, gone.
// PM:  Removing cube doesn't make gibs' .enemy == world,
    self.think      = SUB_Remove;
    self.nextthink  = time + 0.1;
};

void() StartCube =
{
    self.owner      = world;
    self.netname    = "BloodCube";
    setorigin (self, self.origin);

    self.solid      = SOLID_TRIGGER;

    self.flags      = self.flags | FL_ITEM;
    self.movetype   = MOVETYPE_FLY;    
    self.velocity   = '0 0 0';
    self.avelocity  = '0 100 0';
    self.model      = self.mdl;
    setmodel (self, "progs/bloodcb.mdl");
    setsize (self, '-16 -16 -1', '16 16 32');
// PM:  Size was a 2x2x2 box.  Increased size allows easier pickup.
};


/* --------------------------------------------------------- */
/*QUAKED item_bloodcube (0 .5 .8) (-16 -16 -24) (16 16 32)
New powerup!
*/
/* --------------------------------------------------------- */
void() item_bloodcube =
{
// PM:  Removed constant changing mess.
    if (deathmatch)
        SUB_UseTargets ();

    self.classname  = "BloodCube";
    self.touch      = bloodcb_touch;
    self.oldorigin  = self.origin;

    precache_model ("progs/bloodcb.mdl");
    precache_sound ("cube/bc_activ.wav");
    precache_sound ("cube/bc_hngry.wav");
    precache_sound ("cube/bc_gulp.wav");
    precache_sound ("cube/bc_attck.wav");

    self.nextthink  = time + 0.2;
    self.think      = StartCube;
};


// ---------------------------------- //
// |  Used by flying gibs to guide  | //
// |  them into the Bloodcube.      | //
// ---------------------------------- //
float() NoCube =
{
// 'self.enemy' is the bloodcube that is attracting the gib like a magnet.
    if (self.enemy)
        if (self.enemy.owner)
            if (visible (self.enemy))
                return FALSE;

    return TRUE;
};

void() SeekCube =
{
local   vector  vdestdelta;
local   float   traveltime;

    if (NoCube ())
    {
        self.movetype = MOVETYPE_BOUNCE;
        self.solid = SOLID_TRIGGER;     // PM:  Restore original solidity.
        self.think = SUB_Remove;
        self.nextthink = time + 10 * random();
        return;
    }

    vdestdelta = self.enemy.origin - self.origin;
    traveltime = vlen (vdestdelta) / 300;
    if (traveltime < 0.2)   // In other words, vlen < 60.
    {
        local   float   add;

        if (deathmatch)
            add = 7;
        else
            add = 3;
        if (self.enemy.super_time < time)
        {
            sound (self.enemy, CHAN_ITEM, "cube/bc_gulp.wav", 1, ATTN_NORM);
            self.enemy.super_time = time + 0.8;
        }
        T_Heal (self.enemy.owner, add, TRUE);
        stuffcmd (self.enemy.owner, "bf\n");
        remove (self);
        return;
    }
// PM: Make sure the onground flag is off -- we don't want gibs
//      frozen in mid-air.
    self.flags = self.flags - (self.flags & FL_ONGROUND);
    self.velocity = vdestdelta * (1/traveltime);    // IOW, dir * 300.
    self.nextthink = time + 0.2;
    self.think = SeekCube;
};


//========================================================================//
float(entity ent) Cube_TimeLeft =
{
    local   entity  cube;
    local   float   secs, standby;

    standby = 0;
    cube = find(world, classname, "BloodCube");
    while (cube)
    {
        if (cube.owner == ent)
        {
            secs = cube.radsuit_finished - time;
            if (secs > standby)
                standby = secs;
        }
        cube = find(cube, classname, "BloodCube");
    }
    return standby;
};

// Ripped from Zer's ThrowGib, this sends a gib to an active bloodcube.
void(entity gib) Gib_FeedCube =
{
    local   entity  cube;

    cube = find(world, classname, "BloodCube");
    while (cube != world)
    {
        if (cube.owner)
            if (visible (cube))
            {
                gib.movetype    = MOVETYPE_FLY;
                gib.solid       = SOLID_TRIGGER;
                gib.enemy       = cube;
                gib.think       = SeekCube;
                gib.nextthink   = time + 0.2 + random()*0.8;
                return;
            }
        cube = find(cube, classname, "BloodCube");
    }
};


//===========================/  END OF FILE  /===========================//

/*
==============================================================================

GREMLIN

==============================================================================
*/

$cd hipwork\models\grem
$origin 0 0 23
$scale 2
$base grembase.asc
$skin grem

$frame stand1.asc stand2.asc stand3.asc stand4.asc stand5.asc stand6.asc
$frame stand7.asc stand8.asc stand9.asc stand10.asc stand11.asc stand12.asc
$frame stand13.asc stand14.asc stand15.asc stand16.asc stand17.asc

$frame walk1.asc walk2.asc walk3.asc walk4.asc walk5.asc walk6.asc
$frame walk7.asc walk8.asc walk9.asc walk10.asc walk11.asc walk12.asc

$frame run1.asc run2.asc run3.asc run4.asc run5.asc run6.asc run7.asc run8.asc
$frame run9.asc run10.asc run11.asc run12.asc run13.asc run14.asc run15.asc

$frame jump1.asc jump2.asc jump3.asc jump4.asc jump5.asc jump6.asc jump7.asc
$frame jump8.asc jump9.asc jump10.asc jump11.asc jump12.asc jump13.asc jump14.asc
$frame jump15.asc jump16.asc

$frame attk1.asc attk2.asc attk3.asc attk4.asc attk5.asc attk6.asc
$frame attk7.asc attk8.asc attk9.asc attk10.asc attk11.asc

$frame maul1.asc maul2.asc maul3.asc maul4.asc maul5.asc maul6.asc
$frame maul7.asc maul8.asc maul9.asc maul10.asc maul11.asc maul12.asc maul13.asc

$frame spawn1.asc spawn2.asc spawn3.asc spawn4.asc spawn5.asc spawn6.asc

$frame look1.asc look2.asc look3.asc look4.asc look5.asc look6.asc look7.asc
$frame look8.asc look9.asc look10.asc

$frame pain1.asc pain2.asc pain3.asc pain4.asc

$frame death1.asc death2.asc death3.asc death4.asc death5.asc death6.asc death7.asc
$frame death8.asc death9.asc death10.asc death11.asc death12.asc

$frame flip1.asc flip2.asc flip3.asc flip4.asc flip5.asc flip6.asc flip7.asc
$frame flip8.asc

$frame lunge1.asc lunge2.asc lunge3.asc lunge4.asc lunge5.asc lunge6.asc lunge7.asc
$frame lunge8.asc lunge9.asc lunge10.asc lunge11.asc

$frame gfire1.asc gfire2.asc gfire3.asc gfire4.asc gfire5.asc gfire6.asc

$frame glook1.asc glook2.asc glook3.asc glook4.asc glook5.asc glook6.asc glook7.asc
$frame glook8.asc glook9.asc glook10.asc glook11.asc glook12.asc glook13.asc 
$frame glook14.asc glook15.asc glook16.asc glook17.asc glook18.asc glook19.asc glook20.asc

$frame gpain1.asc gpain2.asc gpain3.asc

$frame grun1.asc grun2.asc grun3.asc grun4.asc grun5.asc grun6.asc grun7.asc
$frame grun8.asc grun9.asc grun10.asc grun11.asc grun12.asc grun13.asc grun14.asc grun15.asc

//============================================================================

// Defs
.entity  lastlink;      // FIXME:  Move elsewhere.

float   NumGremlins;
float   NumSpawnGremlins;

// Prototypes
void() gremlin_glook1;

//============
// GremlinFindVictim
//
// find a victim to shoot at
//============
entity() GremlinFindVictim =
{
    local entity head;
    local entity selected;
    local float dist;
    local float head_dist;

    self.search_time = time + 1.0;
// look in our immediate vicinity

    selected = world;
    dist = 1000;
    head = findradius(self.origin, 1000);
    while (head)
    {
        if (!(head.flags & FL_NOTARGET))
        if (head.flags & FLx_CREATURE)
        {
// FIXME:  Check alignment stuff.
            if (head != self.master)    // PM:  Don't fight the master.
            if (head.health > 0)
            if (head != self)
            if (visible(head))
            {
                head_dist = vlen(head.origin-self.origin);
                if (head == self.lastlink)
                    head_dist = head_dist * 2;
                if (head.flags & FL_CLIENT)
                    head_dist = head_dist / 1.5;
                if (head.classname == self.classname)
                    head_dist = head_dist * 1.5;
                if (head_dist < dist)
                {
                    selected = head;
                    dist = head_dist;
                }
            }
        }
        head = head.chain;
    }
    self.lastlink = selected;

    return selected;
};

//===========
// GremlinFindTarget
//
// gremlin is currently not attacking anything, so try to find a target
//============
float() GremlinFindTarget =
{
    local   entity  head;
    local   entity  gorge;
    local   float   dist;
    local   float   result;

    if (self.war)
    {   // Armed with a weapon, so find an enemy to shoot at.
        head = GremlinFindVictim();
        if (head)   // != world)
        {
            self.enemy = head;
            FoundTarget();
            self.attack_finished = time;
            self.search_time = time + 2.0;
            return TRUE;
        }
    }
    else if (time > self.wait)
    {   // Unarmed, look for food.
        self.wait = time + 1.0;
        dist = 2000;
        gorge = world;
        head = nextent(world);
        while (head)    // != world)
        {
            if (head.health <= 0)           //if (head.health < 1)
            if (head.flags & FLx_CREATURE)  //if (head.flags & (FL_MONSTER|FL_CLIENT))
            if (!(head.xfl & XFL_INEDIBLE))
            if (head.gorging == FALSE)
            // PM (Update):  It is safe to eat dynamically spawned stuff.
            {
                result = fabs(head.origin_z - self.origin_z);
                if (visible(head))
                    if (result < 80)
                        //if (head.gorging == FALSE)
                        if (visible_distance < dist)
                            {dist = visible_distance; gorge = head;}
            }
            head = nextent(head);
        }
        if (gorge)  // != world)
            if ( dist < (700 * random()) )
        {
//            dprint("starting to gorge on ");
//            dprint(gorge.classname); dprint("\n");
            self.oldenemy = self.enemy;
            self.gorging = TRUE;
            self.enemy = gorge;
            self.search_time = time + 4.0;
            FoundTarget();
            return TRUE;
        }
    }
    result = FindTarget();
    self.search_time = time + 2.0;
    return result;
};

//===========
// GremlinAttemptWeaponSteal
//
// see if we can steal enemy's weapon
//============
float() GremlinAttemptWeaponSteal =
{
    local   vector  delta;
//    local   entity  tempself;
    local   float   best;
    local   entity  victim;
//    local   float   amount;

    if (self.war)
        return FALSE;   //dprint("gremlin trying to steal a weapon again\n");
    if (self.enemy.classname == self.classname)
        return FALSE;   // Don't steal from other gremlins.

    delta = (self.enemy.origin - self.origin);

    if (vlen(delta) > 100)
        return FALSE;
    if (random() < 0.5)
        return FALSE;
//
// we are within range so lets go for it
//
    victim = self.enemy;
    best = victim.war;

// Update:  Code moved to war.qc since other monsters can take weapons.
    if (!War_Steal (self, victim, "Gremlin stole your "))
        return FALSE;

// Don't fire the first shot at the person we stole the weapon from
// all the time.
    self.attack_finished = time;
    if (random() > 0.65)
        self.lastlink = victim;
    else
        self.lastlink = self;
// Find a recipient
    victim = GremlinFindVictim();
    if (victim) // != world)
    {
        self.enemy = victim;
        FoundTarget();
        self.attack_finished = time;
        self.search_time = time + 1.0;
    }

    return TRUE;
};

//===========
// GremlinCheckAttack
//
// see if gremlin should attack now
//============
float() GremlinCheckAttack =
{
    if (time < self.attack_finished)
        return FALSE;

// Check for melee attack
    if (!self.war)
        if (InMeleeRange (90))      //(vlen(spot2 - spot1) <= 90)
            {self.attack_state = AS_MELEE; return TRUE;}

// missile attack
    if (self.war || (random() < 0.03))
        {self.attack_state = AS_MISSILE; return TRUE;}

    return FALSE;
};

//============
// GremlinCheckNoAmmo
//
// check ammo reserves
//============
float() GremlinCheckNoAmmo =
{
    if (self.currentammo > 0)
        return TRUE;

    if (self.mirv1)
        Mirv_Use ();
    self.arsenal = self.war = 0;    // Discard weapon.
    return FALSE;
};

//=============
// gremlin_stand
//
// The monster is staying in one place for a while, with slight angle turns
// Added by PM.
//=============
void() gremlin_stand = {self.nextthink = time + 0.2; ai_stand();};
// NOTE:  Modified nextthink was placed after ai_stand originally.

//=============
// gremlin_walk
//
// The monster is walking it's beat
//=============
void(float dist) gremlin_walk =
{
// PM:  Duel Monsters code. ---------
    if (self.master)    // Warning: 'self.master == self' causes weirdness.
    {
        if (self.ryuflags & RYU_PATROL)
        {
            if (!GremlinFindTarget ())  // check for noticing a player
                ai_pet_patrol (dist);
        }
        else    // Override walking and run after master instead with gusto.
            self.th_run ();
        return;
    }
//-----------------------------------

    // check for noticing a player
    if (GremlinFindTarget ())
        return;

    movetogoal (dist);
};

//=============
// gremlin_run
//
// The monster has an enemy it is trying to kill
//=============
void(float dist) gremlin_run =
{
    local   float   r;
    local   vector  d;

// PM:  Lava check done elsewhere.  Not insta-kill anymore.

    if (self.war)
        self.frame = self.frame + $grun1.asc - $run1.asc;

    if (self.gorging)
    {   // Gremlin chases a corpse to feed on.
        // PM:  Removed traceline check since 'visible' does that already.
        if (!visible(self.enemy))
            {self.gorging = FALSE; return;}
        r = vlen(self.enemy.origin - self.origin);
        if (r < 130)
        {
            ai_face();
            if (r < 45)     // On top of corpse if true.
                {self.th_melee (); self.attack_state = AS_STRAIGHT;}  // Eat!
            else if (walkmove (self.angles_y, dist) == FALSE)
                self.gorging = FALSE;   // Blocked, abort.
            return;
        }
        movetogoal (dist);      // done in C code...
        return;
    }

// We know the gremlin isn't thinking about eating now.

// There is a small chance the gremlin will change targets (or find one).
    if (random() > 0.97)
        if (GremlinFindTarget ())
            return;     // Found some different meat!

    // get away from player if we stole a weapon
    if (self.war)
    {
        // Drop weapon if enemy is dead and only if enemy is a client.
        if (self.enemy.health < 0)
            if (self.enemy.classname == "player")
                {gremlin_glook1(); return;}

        if (!GremlinCheckNoAmmo())
        {
            if (self.trigger_field)
            {
                remove (self.trigger_field);
                self.trigger_field = world;
                self.goalentity = self.enemy;
            }
            return;
        }
        r = vlen(self.enemy.origin - self.origin);
        d = normalize(self.origin - self.enemy.origin);
        if (!self.trigger_field)    // If temp goal == world.
        {
            if (r < 150)
            {
                self.trigger_field = spawn();
                setsize (self.trigger_field, '-1 -1 -1', '1 1 1');
            }
        }
        // PM:  Can't use temp_goal because its origin can change.
        if (self.trigger_field)
        {
            if (r > 250)
            {
                remove (self.trigger_field);
                self.trigger_field = world;
                self.goalentity = self.enemy;
            }
            else
            {
                if (r < 160)
                {
                    local   vector  ang;
                    local   float   done;
                    local   vector  end;
                    local   float   c;

                    ang = vectoangles(d);
                    done = 0;
                    c = 0;
                    while (done == 0)
                    {
                        makevectors(ang);
                        end = self.enemy.origin + v_forward * 350;
                        traceline(self.enemy.origin, end, FALSE, self);
                        if (trace_fraction == 1.0)
                        {
                            traceline(self.origin, end, FALSE, self);
                            if (trace_fraction == 1.0)
                                done = 1;
                        }
                        ang_y = anglemod(ang_y + 36);
                        c = c + 1;
                        if (c == 10)
                        {
                            done = 1;
                        }
                    }
                    setorigin (self.trigger_field, end);
                }
                self.goalentity = self.trigger_field;
                d = normalize(self.goalentity.origin - self.origin);
                self.ideal_yaw = vectoyaw(d);
                ChangeYaw ();
                movetogoal (dist);      // done in C code...
                self.nextthink = time + 0.1;
                return;
            }
        }
    }

    ai_run (dist);
    self.nextthink = time + 0.1;
};

//===============
// GremlinDropBackpack
//===============
void() GremlinDropBackpack =
{
// Update:  Allow player to recover stolen weapon if he slays the thief.
// Normally (in SoA), gremlins do not drop weapons.
    if (self.health > 0)    // PM:  Live gremlins destroy weapons as in MP1.
        self.arsenal = self.war = self.war & WAR_SHOTGUN;   // PM:  Don't destroy shotgun.

    DropBackpack ();
    self.arsenal = self.war = 0;
};


//============================================================================

// STAND - - - - - - - - - - - - - - - -
void() gremlin_stand1  =[ $stand1.asc,  gremlin_stand2  ] {gremlin_stand();};
void() gremlin_stand2  =[ $stand2.asc,  gremlin_stand3  ] {gremlin_stand();};
void() gremlin_stand3  =[ $stand3.asc,  gremlin_stand4  ] {gremlin_stand();};
void() gremlin_stand4  =[ $stand4.asc,  gremlin_stand5  ] {gremlin_stand();};
void() gremlin_stand5  =[ $stand5.asc,  gremlin_stand6  ] {gremlin_stand();};
void() gremlin_stand6  =[ $stand6.asc,  gremlin_stand7  ] {gremlin_stand();};
void() gremlin_stand7  =[ $stand7.asc,  gremlin_stand8  ] {gremlin_stand();};
void() gremlin_stand8  =[ $stand8.asc,  gremlin_stand9  ] {gremlin_stand();};
void() gremlin_stand9  =[ $stand9.asc,  gremlin_stand10 ] {gremlin_stand();};
void() gremlin_stand10 =[ $stand10.asc, gremlin_stand11 ] {gremlin_stand();};
void() gremlin_stand11 =[ $stand11.asc, gremlin_stand12 ] {gremlin_stand();};
void() gremlin_stand12 =[ $stand12.asc, gremlin_stand13 ] {gremlin_stand();};
void() gremlin_stand13 =[ $stand13.asc, gremlin_stand14 ] {gremlin_stand();};
void() gremlin_stand14 =[ $stand14.asc, gremlin_stand15 ] {gremlin_stand();};
void() gremlin_stand15 =[ $stand15.asc, gremlin_stand16 ] {gremlin_stand();};
void() gremlin_stand16 =[ $stand16.asc, gremlin_stand17 ] {gremlin_stand();};
void() gremlin_stand17 =[ $stand17.asc, gremlin_stand1  ] {gremlin_stand();};
// PM:  Dump loot before standing or walking.
void() gremlin_stand_start =
{
    if (self.war)
        GremlinDropBackpack();
    gremlin_stand1 ();
};

// WALK - - - - - - - - - - - - - - - -
void() gremlin_walk1  =[ $walk1.asc,  gremlin_walk2 ]
{
    if (random() < 0.1)
        sound (self, CHAN_VOICE, "grem/idle.wav", 1, ATTN_IDLE);
    gremlin_walk(8);
};
void() gremlin_walk2  =[ $walk2.asc,  gremlin_walk3  ] {gremlin_walk(8);};
void() gremlin_walk3  =[ $walk3.asc,  gremlin_walk4  ] {gremlin_walk(8);};
void() gremlin_walk4  =[ $walk4.asc,  gremlin_walk5  ] {gremlin_walk(8);};
void() gremlin_walk5  =[ $walk5.asc,  gremlin_walk6  ] {gremlin_walk(8);};
void() gremlin_walk6  =[ $walk6.asc,  gremlin_walk7  ] {gremlin_walk(8);};
void() gremlin_walk7  =[ $walk7.asc,  gremlin_walk8  ] {gremlin_walk(8);};
void() gremlin_walk8  =[ $walk8.asc,  gremlin_walk9  ] {gremlin_walk(8);};
void() gremlin_walk9  =[ $walk9.asc,  gremlin_walk10 ] {gremlin_walk(8);};
void() gremlin_walk10 =[ $walk10.asc, gremlin_walk11 ] {gremlin_walk(8);};
void() gremlin_walk11 =[ $walk11.asc, gremlin_walk12 ] {gremlin_walk(8);};
void() gremlin_walk12 =[ $walk12.asc, gremlin_walk1  ] {gremlin_walk(8);};
// PM:  Dump loot before standing or walking.
void() gremlin_walk_start =
{
    if (self.war)
        GremlinDropBackpack();
    gremlin_walk1 ();
};

// RUN - - - - - - - - - - - - - - - - -
void() gremlin_run1  =[ $run1.asc,  gremlin_run2 ]
{
    if (random() < 0.1)
        sound (self, CHAN_VOICE, "grem/idle.wav", 1, ATTN_IDLE);
    gremlin_run(0);
};
void() gremlin_run2  =[ $run2.asc,  gremlin_run3  ] {gremlin_run(8);};
void() gremlin_run3  =[ $run3.asc,  gremlin_run4  ] {gremlin_run(12);};
void() gremlin_run4  =[ $run4.asc,  gremlin_run5  ] {gremlin_run(16);};
void() gremlin_run5  =[ $run5.asc,  gremlin_run6  ] {gremlin_run(16);};
void() gremlin_run6  =[ $run6.asc,  gremlin_run7  ] {gremlin_run(12);};
void() gremlin_run7  =[ $run7.asc,  gremlin_run8  ] {gremlin_run(8);};
void() gremlin_run8  =[ $run8.asc,  gremlin_run9  ] {gremlin_run(0);};
void() gremlin_run9  =[ $run9.asc,  gremlin_run10 ] {gremlin_run(8);};
void() gremlin_run10 =[ $run10.asc, gremlin_run11 ] {gremlin_run(12);};
void() gremlin_run11 =[ $run11.asc, gremlin_run12 ] {gremlin_run(16);};
void() gremlin_run12 =[ $run12.asc, gremlin_run1  ] {gremlin_run(16);};
void() gremlin_run13 =[ $run13.asc, gremlin_run14 ] {gremlin_run(12);};
void() gremlin_run14 =[ $run14.asc, gremlin_run15 ] {gremlin_run(8);};
void() gremlin_run15 =[ $run15.asc, gremlin_run1  ] {gremlin_run(0);};

void() gremlin_look1 =[ $look1.asc, gremlin_look2 ] {self.nextthink = time + 0.2;};
void() gremlin_look2 =[ $look2.asc, gremlin_look3 ] {self.nextthink = time + 0.2;};
void() gremlin_look3 =[ $look3.asc, gremlin_look4 ] {self.nextthink = time + 0.2;};
void() gremlin_look4 =[ $look4.asc, gremlin_look5 ] {self.nextthink = time + 0.2;};
void() gremlin_look5 =[ $look5.asc, gremlin_look6 ] {self.nextthink = time + 0.2;};
void() gremlin_look6 =[ $look6.asc, gremlin_look7 ] {self.nextthink = time + 0.2;};
void() gremlin_look7 =[ $look7.asc, gremlin_look8 ] {self.nextthink = time + 0.2;};
void() gremlin_look8 =[ $look8.asc, gremlin_look9 ] {self.nextthink = time + 0.2;};
void() gremlin_look9 =[ $look9.asc, gremlin_run1  ] {ai_run_kill ();};

void() gremlin_glook1  =[ $glook1.asc,  gremlin_glook2  ] {};
void() gremlin_glook2  =[ $glook2.asc,  gremlin_glook3  ] {};
void() gremlin_glook3  =[ $glook3.asc,  gremlin_glook4  ] {};
void() gremlin_glook4  =[ $glook4.asc,  gremlin_glook5  ] {};
void() gremlin_glook5  =[ $glook5.asc,  gremlin_glook6  ] {};
void() gremlin_glook6  =[ $glook6.asc,  gremlin_glook7  ] {};
void() gremlin_glook7  =[ $glook7.asc,  gremlin_glook8  ] {};
void() gremlin_glook8  =[ $glook8.asc,  gremlin_glook9  ] {};
void() gremlin_glook9  =[ $glook9.asc,  gremlin_glook10 ] {};
void() gremlin_glook10 =[ $glook10.asc, gremlin_glook11 ] {};
void() gremlin_glook11 =[ $glook11.asc, gremlin_glook12 ] {};
void() gremlin_glook12 =[ $glook12.asc, gremlin_glook13 ] {};
void() gremlin_glook13 =[ $glook13.asc, gremlin_glook14 ] {};
void() gremlin_glook14 =[ $glook14.asc, gremlin_glook15 ] {};
void() gremlin_glook15 =[ $glook15.asc, gremlin_glook16 ] {};
void() gremlin_glook16 =[ $glook16.asc, gremlin_glook17 ] {};
void() gremlin_glook17 =[ $glook17.asc, gremlin_glook18 ] {};
void() gremlin_glook18 =[ $glook18.asc, gremlin_glook19 ] {};
void() gremlin_glook19 =[ $glook19.asc, gremlin_glook20 ] {};
void() gremlin_glook20 =[ $glook20.asc, gremlin_run1    ] {GremlinDropBackpack(); ai_run_kill ();};

// ATTACK (Jump) - - - - - - - - - - - -
void() Gremlin_JumpTouch;

void() gremlin_jump1  =[ $jump1.asc,  gremlin_jump2  ] {ai_face();};
void() gremlin_jump2  =[ $jump2.asc,  gremlin_jump3  ] {ai_face();};
void() gremlin_jump3  =[ $jump3.asc,  gremlin_jump4  ] {ai_face();};
void() gremlin_jump4  =[ $jump4.asc,  gremlin_jump5  ] {ai_face();};
void() gremlin_jump5  =[ $jump5.asc,  gremlin_jump6  ]
{
    ai_face();

    if (self.flags & FL_ONGROUND)
    {
        self.touch = Gremlin_JumpTouch;
        makevectors (self.angles);
        self.origin_z = self.origin_z + 1;
        self.velocity = v_forward * 300 + '0 0 300';
        self.flags = self.flags - FL_ONGROUND;
    }
    else
    {
        gremlin_run1();
    }
};
void() gremlin_jump6  =[ $jump6.asc,  gremlin_jump7  ] {};
void() gremlin_jump7  =[ $jump7.asc,  gremlin_jump8  ] {};
void() gremlin_jump8  =[ $jump8.asc,  gremlin_jump9  ] {};
void() gremlin_jump9  =[ $jump9.asc,  gremlin_jump10 ] {};
void() gremlin_jump10 =[ $jump10.asc, gremlin_jump11 ] {};
void() gremlin_jump11 =[ $jump11.asc, gremlin_jump1  ]
{
    self.nextthink = time + 3;
    // if three seconds pass, assume gremlin is stuck and jump again
};
void() gremlin_jump12 =[ $jump12.asc, gremlin_jump13 ] {};
void() gremlin_jump13 =[ $jump13.asc, gremlin_jump14 ] {};
void() gremlin_jump14 =[ $jump14.asc, gremlin_jump15 ] {};
void() gremlin_jump15 =[ $jump15.asc, gremlin_jump16 ] {};
void() gremlin_jump16 =[ $jump16.asc, gremlin_run1   ] {};

void() Gremlin_JumpTouch =
{
    if (self.health <= 0)
        return;

    if (!checkbottom(self))
    {
        if (self.flags & FL_ONGROUND)
        {
            self.touch = SUB_Null;
            self.think = gremlin_jump1;
            self.nextthink = time + 0.1;
        }
        return;    // not on ground yet
    }

    self.touch = SUB_Null;
    self.think = gremlin_jump12;
    self.nextthink = time + 0.1;
};

// ATTACK (Guns) - - - - - - - - - - - -
// Gremlin aim vectors converted to their inverse tangent values.
vector  GAIM1   = '5.7106 5.7106 0';    // 0.1
vector  GAIM3   = '16.6992 16.6992 0';  // 0.3

//============
// Gremlin_Start
//============
vector() Gremlin_Start =
{
    local   vector  org;

    makevectors (self.angles);
    org = self.origin + v_forward*22 + v_right*10 + v_up*9;
    return org;
};

//============
// Gremlin_FireAutoShotGun
//
// fire the auto shotgun
//============
void() gremlin_autoshot =
{
    local   vector  org;

// DISABLED -- Don't change nextthinks.
//    self.nextthink = time + 4/30;
    self.effects = self.effects | EF_MUZZLEFLASH;
    org = Gremlin_Start ();
    M_FireShotgun (org, self.enemy.origin, world, GAIM3, FALSE, 2);
};
void() gremlin_autos3 =[$gfire1.asc, gremlin_autos4 ] {gremlin_autoshot();};
void() gremlin_autos4 =[$gfire6.asc, gremlin_autos5 ] {};   //{gremlin_autoshot();};
void() gremlin_autos5 =[$gfire1.asc, gremlin_autos6 ] {gremlin_autoshot();};
void() gremlin_autos6 =[$gfire6.asc, gremlin_autos7 ] {};   //{gremlin_autoshot();};
void() gremlin_autos7 =[$gfire1.asc, gremlin_run1   ] {};

//============
// Gremlin_FireNailGun
//
// fire a nailgun
//============
void() Gremlin_FireNailGun =
{
    local   vector  org;

    org = Gremlin_Start ();
    M_FireNailgun (org, self.enemy.origin, world, GAIM1, self.war & WAR_SUPER_NAILGUN);
};

//void() gremlin_nail1 =[$gfire1.asc, gremlin_nail2  ]
//    {self.effects = self.effects | EF_MUZZLEFLASH; Gremlin_FireNailGun();};
//void() gremlin_nail2 =[$gfire6.asc, gremlin_nail3  ]
//    {self.effects = self.effects | EF_MUZZLEFLASH; Gremlin_FireNailGun();};
void() gremlin_nail3 =[$gfire1.asc, gremlin_nail4  ]
    {self.effects = self.effects | EF_MUZZLEFLASH; Gremlin_FireNailGun();};
void() gremlin_nail4 =[$gfire6.asc, gremlin_nail5  ]
    {self.effects = self.effects | EF_MUZZLEFLASH; Gremlin_FireNailGun();};
void() gremlin_nail5 =[$gfire1.asc, gremlin_nail6  ]
    {self.effects = self.effects | EF_MUZZLEFLASH; Gremlin_FireNailGun();};
void() gremlin_nail6 =[$gfire6.asc, gremlin_nail7  ]
    {self.effects = self.effects | EF_MUZZLEFLASH; Gremlin_FireNailGun();};
void() gremlin_nail7 =[$gfire1.asc, gremlin_run1   ] {};

//============
// Gremlin_FireLaserGun
//
// fire a laser cannon
//============
void(float lite) Gremlin_FireLaserGun =
{
    local   vector  org;
    local   float   glow;

    if (lite)
        glow = LF_GLOW;
    else
        glow = 0;

    org = Gremlin_Start ();
    M_FireLaser (org, self.enemy.origin, world, GAIM1, LF_RED|LF_BOUNCE|glow);
};

//============
// Gremlin_FirePlasmaGun
//
// fire a plasma gun
//============
void() Gremlin_FirePlasmaGun =
{
    local   vector  org;

    org = Gremlin_Start ();
    M_FirePlasma (org, self.enemy.origin, world, GAIM3, FALSE);
};

// Laser Cannon
//void() gremlin_laser1 =[$gfire1.asc, gremlin_laser2  ]
//    {self.effects = self.effects | EF_MUZZLEFLASH; Gremlin_FireLaserGun(1);};
//void() gremlin_laser2 =[$gfire6.asc, gremlin_laser3  ]
//    {self.effects = self.effects | EF_MUZZLEFLASH; Gremlin_FireLaserGun(0);};
void() gremlin_laser3 =[$gfire1.asc, gremlin_laser4  ]
    {self.effects = self.effects | EF_MUZZLEFLASH; Gremlin_FireLaserGun(0);};
void() gremlin_laser4 =[$gfire6.asc, gremlin_laser5  ]
    {self.effects = self.effects | EF_MUZZLEFLASH; Gremlin_FireLaserGun(0);};
void() gremlin_laser5 =[$gfire1.asc, gremlin_laser6  ]
    {self.effects = self.effects | EF_MUZZLEFLASH; Gremlin_FireLaserGun(0);};
void() gremlin_laser6 =[$gfire6.asc, gremlin_laser7  ]
    {self.effects = self.effects | EF_MUZZLEFLASH; Gremlin_FireLaserGun(0);};
void() gremlin_laser7 = [$gfire1.asc, gremlin_run1   ] {};

// Drake Blaster
//void() gremlin_blast1 =[$gfire1.asc, gremlin_blast2  ]
//    {self.effects = self.effects | EF_MUZZLEFLASH; Gremlin_FireLaserGun(1);};
//void() gremlin_blast2 =[$gfire6.asc, gremlin_blast3  ] {};
void() gremlin_blast3 =[$gfire1.asc, gremlin_blast4  ]
    {self.effects = self.effects | EF_MUZZLEFLASH; Gremlin_FireLaserGun(0);};
void() gremlin_blast4 =[$gfire6.asc, gremlin_blast5  ] {};
void() gremlin_blast5 =[$gfire1.asc, gremlin_blast6  ]
    {self.effects = self.effects | EF_MUZZLEFLASH; Gremlin_FireLaserGun(0);};
void() gremlin_blast6 =[$gfire6.asc, gremlin_blast7  ] {};
void() gremlin_blast7 =[$gfire1.asc, gremlin_run1    ] {};

// Plasma Gun
void() gremlin_plasma3 =[$gfire1.asc, gremlin_plasma4  ]
    {self.effects = self.effects | EF_MUZZLEFLASH; Gremlin_FirePlasmaGun();};
void() gremlin_plasma4 =[$gfire6.asc, gremlin_plasma5  ] {};
void() gremlin_plasma5 =[$gfire1.asc, gremlin_plasma6  ]
    {self.effects = self.effects | EF_MUZZLEFLASH; Gremlin_FirePlasmaGun();};
void() gremlin_plasma6 =[$gfire6.asc, gremlin_plasma7  ] {};
void() gremlin_plasma7 =[$gfire1.asc, gremlin_run1     ] {};

//============
// Gremlin_FireLightningGun
//
// fire lightning gun
//============
void() Gremlin_FireLightningGun =
{
    local   vector  org;

    org = Gremlin_Start ();
    M_FireThunderbolt (org, self.enemy.origin, world, GAIM1, FALSE, self.war & WAR_CHAIN_LIGHTNING);
};

// Chain/Thunderbolt
void() gremlin_light1 =[$gfire1.asc, gremlin_light2 ] {Gremlin_FireLightningGun();};
void() gremlin_light2 =[$gfire6.asc, gremlin_light3 ] {Gremlin_FireLightningGun();};
void() gremlin_light3 =[$gfire1.asc, gremlin_light4 ] {Gremlin_FireLightningGun();};
void() gremlin_light4 =[$gfire6.asc, gremlin_light5 ] {Gremlin_FireLightningGun();};
void() gremlin_light5 =[$gfire1.asc, gremlin_run1   ] {};

//============
// Gremlin_Fire
//
// fire a gun -- any gun (that is 'none of the above').
//============
void() Gremlin_Fire =
{
    local   vector  org, err;

    org = Gremlin_Start ();
    if ((self.war & WARx_USES_SHELLS) || (self.war == WAR_CRUISE_MISSILE))
        err = GAIM3;
    else
        err = GAIM1;
    M_Attack (self.war, org, self.enemy.origin, world, err, FALSE);
};

void() gremlin_shot1 =[ $gfire1.asc, gremlin_shot2 ] {self.effects = self.effects | EF_MUZZLEFLASH;};
void() gremlin_shot2 =[ $gfire2.asc, gremlin_shot3 ] {};
void() gremlin_shot3 =[ $gfire3.asc, gremlin_shot4 ] {};
void() gremlin_shot4 =[ $gfire4.asc, gremlin_shot5 ] {};
void() gremlin_shot5 =[ $gfire5.asc, gremlin_shot6 ] {};
void() gremlin_shot6 =[ $gfire6.asc, gremlin_run1  ] {};

//============
// GremlinWeaponAttack
//
// attack with a weapon
//============
float() GremlinWeaponAttack =
{
    if (!self.war)
        return FALSE;   // No weapon to use!
    if (!GremlinCheckNoAmmo ())
        return FALSE;

    self.show_hostile = time + 1; // wake monsters up

// Select appropriate attack routine.
    if (self.war == WAR_NAILGUN)
        gremlin_nail3 ();
    else if (self.war == WAR_SUPER_NAILGUN)
        gremlin_nail3 ();
    else if (self.war & (WAR_THUNDERBOLT | WAR_CHAIN_LIGHTNING))
        {gremlin_light1(); M_Lstart ();}
    else if (self.war == WAR_PLASMA_GUN)
        gremlin_plasma3();
    else if (self.war == WAR_BLASTER)
        gremlin_blast3();
    else if (self.war == WAR_LASER_CANNON)
        gremlin_laser3();
    else
        {gremlin_shot1 (); Gremlin_Fire();}

// Fire!
    SUB_AttackFinished(1);
    return TRUE;
};

void() Gremlin_MissileAttack =
{
    if (GremlinWeaponAttack ())
        return;

    if (self.flags & FL_ONGROUND)
        gremlin_jump1();
};

// ATTACK (Melee) - - - - - - - - - - -
void(float side)  Gremlin_Melee =
{
    local   float   ldmg;
    // PM:  Removed vector delta.

    ai_face ();

//   walkmove (self.ideal_yaw, 12);   // allow a little closing


    if (!InMeleeRange (100))    // PM:  Replaced vlen(delta) with this
        return;                 //  due to fat monster code for dragons.
    if (!CanDamage (self.enemy, self))
        return;

    sound (self, CHAN_WEAPON, "grem/attack.wav", 1, ATTN_NORM);
    ldmg = 10 + 5*random();
    T_NewDamage (self.enemy, self, self, ldmg, DF_NONE, "melee");

    makevectors (self.angles);
    SpawnMeatSpray (self.origin + v_forward*16, side * v_right, self.enemy.bloodtype);
};

void() gremlin_lunge1  =[ $lunge1.asc,  gremlin_lunge2  ] {ai_charge(0);};
void() gremlin_lunge2  =[ $lunge2.asc,  gremlin_lunge3  ] {ai_charge(0);};
void() gremlin_lunge3  =[ $lunge3.asc,  gremlin_lunge4  ] {ai_charge(0);};
void() gremlin_lunge4  =[ $lunge4.asc,  gremlin_lunge5  ] {ai_charge(0);};
void() gremlin_lunge5  =[ $lunge5.asc,  gremlin_lunge6  ] {ai_charge(0);};
void() gremlin_lunge6  =[ $lunge6.asc,  gremlin_lunge7  ] {ai_charge(0);};
void() gremlin_lunge7  =[ $lunge7.asc,  gremlin_lunge8  ] {ai_charge(15);};
void() gremlin_lunge8  =[ $lunge8.asc,  gremlin_lunge9  ] {ai_charge(0);Gremlin_Melee(0);};
void() gremlin_lunge9  =[ $lunge9.asc,  gremlin_lunge10 ] {ai_charge(0);};
void() gremlin_lunge10 =[ $lunge10.asc, gremlin_lunge11 ] {ai_charge(0);};
void() gremlin_lunge11 =[ $lunge11.asc, gremlin_run1    ] {ai_charge(0);};

void() gremlin_claw1   =[ $attk1.asc,   gremlin_claw2   ] {ai_charge(0);};
void() gremlin_claw2   =[ $attk2.asc,   gremlin_claw3   ] {ai_charge(0);};
void() gremlin_claw3   =[ $attk3.asc,   gremlin_claw4   ] {ai_charge(0);};
void() gremlin_claw4   =[ $attk4.asc,   gremlin_claw5   ] {ai_charge(0);};
void() gremlin_claw5   =[ $attk5.asc,   gremlin_claw6   ] {ai_charge(0);};
void() gremlin_claw6   =[ $attk6.asc,   gremlin_claw7   ] {ai_charge(0);Gremlin_Melee(200);};
void() gremlin_claw7   =[ $attk7.asc,   gremlin_claw8   ] {ai_charge(15);};
void() gremlin_claw8   =[ $attk8.asc,   gremlin_claw9   ] {ai_charge(0);};
void() gremlin_claw9   =[ $attk9.asc,   gremlin_claw10  ] {ai_charge(0);};
void() gremlin_claw10  =[ $attk10.asc,  gremlin_claw11  ] {ai_charge(0);};
void() gremlin_claw11  =[ $attk11.asc,  gremlin_run1    ] {ai_charge(0);};

void(float side)  Gremlin_Gorge;    // Prototype

void() gremlin_gorge1  =[ $maul1.asc,   gremlin_gorge2  ] {ai_charge(1);};
void() gremlin_gorge2  =[ $maul2.asc,   gremlin_gorge3  ] {ai_charge(1);};
void() gremlin_gorge3  =[ $maul3.asc,   gremlin_gorge4  ] {ai_charge(2);};
void() gremlin_gorge4  =[ $maul4.asc,   gremlin_gorge5  ] {ai_charge(0);};
void() gremlin_gorge5  =[ $maul5.asc,   gremlin_gorge6  ] {ai_charge(0);};
void() gremlin_gorge6  =[ $maul6.asc,   gremlin_gorge7  ] {ai_charge(0);Gremlin_Gorge(200);};
void() gremlin_gorge7  =[ $maul7.asc,   gremlin_gorge8  ] {ai_charge(0);};
void() gremlin_gorge8  =[ $maul8.asc,   gremlin_gorge9  ] {ai_charge(0);Gremlin_Gorge(-200);};
void() gremlin_gorge9  =[ $maul9.asc,   gremlin_gorge10 ] {ai_charge(0);};
void() gremlin_gorge10 =[ $maul10.asc,  gremlin_gorge11 ] {ai_charge(0);};
void() gremlin_gorge11 =[ $maul11.asc,  gremlin_gorge12 ] {ai_charge(0);};
void() gremlin_gorge12 =[ $maul12.asc,  gremlin_gorge13 ] {ai_charge(0);};
void() gremlin_gorge13 =[ $maul13.asc,  gremlin_gorge1  ] {ai_charge(0);};

void() Gremlin_MeleeAttack =
{
    if (self.gorging)
        {gremlin_gorge1(); return;}

    if (self.war)
        objerror("gremlin meleeing with stolen weapon");
    else if (random() < 0.4)    // NPCs can carry and use weapons like PCs.
    {
        if (GremlinAttemptWeaponSteal ())
            return;     // Successful rip off.
    }

// Originally, lunge1 was 0.3 <= x < 0.6, and claw1 all else.
    if (random() < 0.3)
        gremlin_lunge1 ();
    else
        gremlin_claw1 ();
};

// PAIN - - - - - - - - - - - - - - - -
void() gremlin_pain1 =[ $pain1.asc, gremlin_pain2 ] {ai_back(4);};
void() gremlin_pain2 =[ $pain2.asc, gremlin_pain3 ] {ai_back(4);};
void() gremlin_pain3 =[ $pain3.asc, gremlin_pain4 ] {ai_back(2);};
void() gremlin_pain4 =[ $pain4.asc, gremlin_run1  ] {};

void() gremlin_gunpain1 =[ $gpain1.asc, gremlin_gunpain2 ] {ai_back(4);};
void() gremlin_gunpain2 =[ $gpain2.asc, gremlin_gunpain3 ] {ai_back(2);};
void() gremlin_gunpain3 =[ $gpain3.asc, gremlin_run1     ] {};

void(entity attacker, float damage) gremlin_pain =
{
    local   float   r;

    if (random() < 0.8)
    if (self != attacker)           // Don't get mad at itself.
    if (self.enemy != attacker)     // Don't get paralyzed by enemy.
    if (self.master != attacker)    // Don't turn on master.
    {
        self.gorging = FALSE;       // Stop eating if feeding.
        self.enemy = attacker;
        FoundTarget();
    }

    if (self.touch == Gremlin_JumpTouch)
        return;

    if (self.pain_finished > time)
        return;

    self.pain_finished = time + 1;
    r = random();
    if (r < 0.33)
        sound (self, CHAN_VOICE, "grem/pain1.wav", 1, ATTN_NORM);
    else if (r < 0.66)
        sound (self, CHAN_VOICE, "grem/pain2.wav", 1, ATTN_NORM);
    else
        sound (self, CHAN_VOICE, "grem/pain3.wav", 1, ATTN_NORM);

    if (SUB_IgnorePain ())
        return;     // PM:  No pain frames in Nightmare.

    if (self.war)
        gremlin_gunpain1 ();
    else
        gremlin_pain1 ();
    damage = damage;    // FrikQcc warning squelch!
};

// DEATH - - - - - - - - - - - - - - - -
void() Gremlin_FlipTouch;

void() gremlin_die1  =[ $death1.asc,  gremlin_die2  ] {sound (self, CHAN_VOICE, "grem/death.wav", 1, ATTN_NORM);};
void() gremlin_die2  =[ $death2.asc,  gremlin_die3  ] {ai_forward(2);};
void() gremlin_die3  =[ $death3.asc,  gremlin_die4  ] {ai_forward(1);};
void() gremlin_die4  =[ $death4.asc,  gremlin_die5  ] {ai_forward(2);};
void() gremlin_die5  =[ $death5.asc,  gremlin_die6  ] {ai_forward(1);};
void() gremlin_die6  =[ $death6.asc,  gremlin_die7  ] {self.solid = SOLID_NOT;};
void() gremlin_die7  =[ $death7.asc,  gremlin_die8  ] {ai_forward(2);};
void() gremlin_die8  =[ $death8.asc,  gremlin_die9  ] {ai_forward(1);};
void() gremlin_die9  =[ $death9.asc,  gremlin_die10 ] {ai_forward(2);};
void() gremlin_die10 =[ $death10.asc, gremlin_die11 ] {ai_forward(1);};
void() gremlin_die11 =[ $death11.asc, gremlin_die12 ] {ai_forward(2);};
void() gremlin_die12 =[ $death12.asc, monster_end   ] {};

float(float dm) gremlin_gib1 =
{
    if (self.health < self.gib_health)
    {
        sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
        ThrowGib ("progs/gib1.mdl", dm);
        ThrowGib ("progs/gib1.mdl", dm);
        ThrowGib ("progs/gib1.mdl", dm);
        ThrowHead ("progs/h_grem.mdl", dm);
        return TRUE;
    }
    return FALSE;
};
void() gremlin_gib = {self.health = self.gib_health - 1; gremlin_gib1 (-35);};

void() gremlin_flip1 =[ $flip1.asc, gremlin_flip2 ]
{
    ai_face();
    makevectors (self.angles);
    self.origin_z = self.origin_z + 1;
    self.velocity = '0 0 350' - (v_forward * 200);
    if (self.flags & FL_ONGROUND)
        self.flags = self.flags - FL_ONGROUND;
    sound (self, CHAN_VOICE, "grem/death.wav", 1, ATTN_NORM);
};
void() gremlin_flip2 =[ $flip2.asc, gremlin_flip3 ] {ai_face();};
void() gremlin_flip3 =[ $flip3.asc, gremlin_flip4 ] {};
void() gremlin_flip4 =[ $flip4.asc, gremlin_flip5 ] {};
void() gremlin_flip5 =[ $flip5.asc, gremlin_flip6 ] {};
void() gremlin_flip6 =[ $flip6.asc, gremlin_flip7 ] {self.touch = Gremlin_FlipTouch;};
void() gremlin_flip7 =[ $flip7.asc, gremlin_gib   ] {self.nextthink = time + 3;};   // Gib if stuck!
void() gremlin_flip8 =[ $flip8.asc, monster_end   ] {self.solid = SOLID_NOT;};

void() Gremlin_FlipTouch =
{
    if (!checkbottom(self))
    {
        if (self.flags & FL_ONGROUND)
        {
            self.touch = SUB_Null;
            self.think = gremlin_flip1;
            self.nextthink = time + 0.1;
        }
        return;    // not on ground yet
    }

    self.touch = SUB_Null;
    self.think = gremlin_flip8;
    self.nextthink = time + 0.1;
};

void() gremlin_die =
{
    self.gorging = FALSE;   // Reset so other gremlins get eat.

    if (self.war)
        GremlinDropBackpack();

    if (self.trigger_field)
    {
        remove (self.trigger_field);    // Remove any spawned waypoint.
        self.trigger_field = world;
    }

    if (Shattered ())
        return;
    if (Decapitated ())
    {   // Model isn't suited for decapitation, so gib instead.
        if (self.health >= self.gib_health)
            {gremlin_gib();  return;}
    }
// Note:  Model did not have enough vertecies for me to construct viable
// headless death scenes.  Thus, the gremlin cannot be decapitated.
// check for gib
    if (gremlin_gib1 (self.health))
        return;

    if (self.enemy)
    {
        local   vector  vec;

// Changed 'damage_attacker' to 'self.enemy' for the following reasons:
// 1) 'damage_attacker' may not be real attacker because of summon hierarchy.
// 2) 'self.enemy' is always set to whoever killed self.
// FIXME:  What if gremlin is sandwiched between attacker and inflictor.
        makevectors (self.angles);
        vec = normalize (self.enemy.origin - self.origin);
        if ((vec * v_forward) > 0.7)    // Dot product.
            if (random() < 0.5)
                if (self.flags & FL_ONGROUND)
                    {gremlin_flip1 ();  return;}
    }

// regular death
    gremlin_die1 ();
};

// REVIVE - - - - - - - - - - - - - - -
void() gremlin_revive1   =[ $death11.asc, gremlin_revive2   ] {};
void() gremlin_revive2   =[ $death10.asc, gremlin_revive3   ] {};
void() gremlin_revive3   =[ $death9.asc,  gremlin_revive4   ] {};
void() gremlin_revive4   =[ $death8.asc,  gremlin_revive5   ] {};
void() gremlin_revive5   =[ $death7.asc,  gremlin_revive6   ] {};
void() gremlin_revive6   =[ $death6.asc,  gremlin_revive7   ] {};
void() gremlin_revive7   =[ $death5.asc,  gremlin_revive8   ] {};
void() gremlin_revive8   =[ $death4.asc,  gremlin_revive9   ] {};
void() gremlin_revive9   =[ $death3.asc,  gremlin_revive10  ] {};
void() gremlin_revive10  =[ $death2.asc,  gremlin_revive11  ] {};
void() gremlin_revive11  =[ $death1.asc,  gremlin_pain4     ] {};

void() gremlin_reviveb1  =[ $flip7.asc,   gremlin_reviveb2  ] {};
void() gremlin_reviveb2  =[ $flip6.asc,   gremlin_reviveb3  ] {};
void() gremlin_reviveb3  =[ $flip5.asc,   gremlin_reviveb4  ] {};
void() gremlin_reviveb4  =[ $flip4.asc,   gremlin_reviveb5  ] {};
void() gremlin_reviveb5  =[ $flip3.asc,   gremlin_reviveb6  ] {};
void() gremlin_reviveb6  =[ $flip2.asc,   gremlin_reviveb7  ] {};
void() gremlin_reviveb7  =[ $flip1.asc,   gremlin_run1      ] {};

void() gremlin_revive =
{
// Remove all guns and ammo.
    self.arsenal = self.war = 0;
    self.ammo_shells=self.ammo_nails=self.ammo_rockets=self.ammo_cells = 0;
    self.ammo_super = 0;
// Revive.
    if ( self.frame == $flip8.asc )
        gremlin_reviveb1 ();
    else
        gremlin_revive1 ();
};

// SPAWN - - - - - - - - - - - - - - - -
void() gremlin_spawn1 =[ $spawn1.asc, gremlin_spawn2 ] {self.nextthink = time + 0.3;
    self.th_pain = SUB_Null;
//    sound (self, CHAN_VOICE, "grem/idle.wav", 1, ATTN_IDLE);
};
void() gremlin_spawn2 =[ $spawn2.asc, gremlin_spawn3 ] {self.nextthink = time + 0.3;};
void() gremlin_spawn3 =[ $spawn3.asc, gremlin_spawn4 ] {self.nextthink = time + 0.3;};
void() gremlin_spawn4 =[ $spawn4.asc, gremlin_spawn5 ] {self.nextthink = time + 0.3;};
void() gremlin_spawn5 =[ $spawn5.asc, gremlin_spawn6 ] {self.nextthink = time + 0.3;};
void() gremlin_spawn6 =[ $spawn6.asc, gremlin_run1   ] {self.th_pain = gremlin_pain;};

void(float dm) Gremlin_ThrowHead =
{
    if (self.classname == "player")
    {
        if (self.modelindex == mindex_dragon)
            ThrowHead ("progs/dr_head.mdl", dm);
        else
            ThrowHead ("progs/h_player.mdl", dm);
        return;
    }

    if (self.mdl_head)
        if (self.mdl_head != "")
        {
            ThrowHead (self.mdl_head, dm);
            return;
        }

// Update 10/27/09:  Make sure skin is right.
    self.skin = 0;
    ThrowHead ("progs/gib3.mdl", dm);
};

void() Gremlin_Split =
{
    if (self.spawned)   // PM:  Don't let spawned monsters have children.
        return;
    if (NumSpawnGremlins >= (NumGremlins*2))
        return;

    local   entity  grem;
    local   entity  temp;
    local   entity  head;
    local   float   done;
    local   vector  ang;
    local   float   c;
    local   vector  pos;
    local   float   proceed;

    done = 0;
    c = 0;
    ang = self.angles;
    while (done == 0)
    {
        makevectors(ang);
        pos = self.origin + (80 * v_forward);
        head = findradius(pos, 35);
        proceed = 1;
        while (head)
        {
            if (head.health > 0)
                if (head.flags & (FL_MONSTER | FL_CLIENT))
                    proceed = 0;
            head = head.chain;
        }
        traceline(self.origin,pos,FALSE,self);
        if (trace_fraction == 1 && (proceed == 1))
        {
            traceline(self.origin,(pos-'40 40 0'),FALSE,self);
            if (trace_fraction == 1)
            {
                traceline(self.origin,(pos+'40 40 0'),FALSE,self);
                if (trace_fraction == 1)
                {
                    traceline(self.origin,(pos + '0 0 64'),FALSE,self);
                    if (trace_fraction == 1)
                    {
                        traceline(self.origin,(pos - '0 0 64'),FALSE,self);
                        if (trace_fraction != 1)
                        {
                            done = 1;
                        }
                    }
                }
            }
        }
        if (done == 0)
        {
            ang_y = ang_y + 36;
            c = c + 1;
            if (c==10)
            {
                return;
            }
        }
    }

    NumSpawnGremlins = NumSpawnGremlins + 1;

    grem = spawn();
    SUB_CopyEntity (self,grem);
    grem.solid = SOLID_SLIDEBOX;
    grem.movetype = MOVETYPE_STEP;
    setmodel (grem, "progs/grem.mdl");
    setsize (grem, VEC_HULL_MIN, VEC_HULL_MAX);
    if (self.health < self.max_health)
        self.health = self.max_health;
    self.health = self.health / 2;
    grem.health = floor (self.health);
    self.health = ceil (self.health);
    grem.war = grem.arsenal = 0;

    // PM:  Delay monster count update until grem becomes self.
    setorigin (grem, pos);

    temp = self;
    self = grem;
    if (self.alignment != GOOD)
        monster_1up ();     // Another bad guy.
    gremlin_spawn1 ();
    self.enemy = world;
    self.gorging = FALSE;
    self = temp;
};

void(float side)  Gremlin_Gorge =
{
    local   entity  targ;

    targ = self.enemy;
    if (!targ.modelindex || !targ.deadflag || targ.gorging)
    {   // Enemy no longer exists for feeding.
        self.enemy = world;
        self.gorging = FALSE;
        gremlin_look1 ();
        return;
    }

    local   float   ldmg;

    sound (self, CHAN_WEAPON, "demon/dhit2.wav", 1, ATTN_NORM);
    ldmg = 7 + 5*random();
    if ((targ.health < 1) || targ.deadflag)
        targ.health = targ.health - ldmg;

    makevectors (self.angles);
    SpawnMeatSpray (self.origin + v_forward*16, side * v_right, targ.bloodtype);
    if (targ.health < -200.0)
    {
        if (targ.gorging==FALSE)
        {
            local   entity  temp;

            targ.gorging = TRUE;    // Flag victim as eaten.
            sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
            temp = self;
            self = targ;
            Gremlin_ThrowHead (-15);    // Gremlins eat all but the head.

            self = temp;
            ldmg = 150 + 100*random();
            T_Heal (self, ldmg, FALSE);
            Gremlin_Split();
        }
        self.enemy = world;
        self.gorging = FALSE;
        gremlin_look1 ();
    }
};

// OTHER - - - - - - - - - - - - - - - -
void(float hello) gremlin_sight =
{
    if (hello)
        sound (self, CHAN_VOICE, "grem/idle.wav", 1, ATTN_NORM);
    else
        sound (self, CHAN_VOICE, "grem/sight1.wav", 1, ATTN_NORM);
};

void() gremlin_cache =
{
   precache_model ("progs/grem.mdl");
   precache_model ("progs/h_grem.mdl");

   precache_sound ("grem/death.wav");
   precache_sound ("grem/attack.wav");
   precache_sound ("demon/djump.wav");
   precache_sound ("demon/dhit2.wav");
   precache_sound ("grem/pain1.wav");
   precache_sound ("grem/pain2.wav");
   precache_sound ("grem/pain3.wav");
   precache_sound ("grem/idle.wav");
   precache_sound ("grem/sight1.wav");
};

//============
// --> QUAKED monster_gremlin (1 0 0) (-16 -16 -24) (16 16 32) Ambush
//============
void() monster_gremlin =
{
    if (!self.spawned)
    {
        if (noenemies)
            {remove(self); return;}

        NumGremlins = NumGremlins + 1;
        gremlin_cache ();
    }
//    else if (!NumGremlins)
//        NumGremlins = 1;    // PM:  For testing only

    if (world.tronyn & DJG_SNOW)
        self.skin = 1;
    monster_form ("progs/grem.mdl", VEC_HULL_MIN, VEC_HULL_MAX, 100, -35);
    self.mdl_head   = "progs/h_grem.mdl";
    self.mass       = MASS_LIGHT;
    self.yaw_speed  = 40;    // PM:  These buggers turn fast, Hip.

    self.th_stand   = gremlin_stand_start;
    self.th_walk    = gremlin_walk_start;
    self.th_run     = gremlin_run1;
    self.th_melee   = Gremlin_MeleeAttack;      // one of two attacks
    self.th_missile = Gremlin_MissileAttack;    // check for random jump or firing of weapon
    self.th_pain    = gremlin_pain;
    self.th_die     = gremlin_die;
    //- - - - - - - -
    self.th_sight   = gremlin_sight;
    self.th_check   = GremlinCheckAttack;
    self.th_gib     = gremlin_gib1;     // Not 'gremlin_gib'!
    self.th_revive  = gremlin_revive;
    self.th_spawn   = monster_gremlin;

    self.family     = FAM_IMP;      // Imps and gremlins are related.
    self.resist_fire = -1;    // Takes double fire damage for fast lava kills.
    self.xfl        = XFL_USE_AMMO;     // Using stolen weapons consumes ammo.
    if (soul_evil)
        monster_purse (1, 0.5, 0.5);    // 50% item, 50% gem.

    self.trigger_field  = world;    // PM:  Clear waypoint.

    monster_start();
};


//===========================/  END OF FILE  /===========================//

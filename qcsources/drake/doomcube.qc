// Monster spawner similar to that on MAP30 in Doom2.
// This is the invisible "mook maker" entity, not Romero's head on a stick.
//
// Update 8/12/10:  Uses func_spawn monster spawners instead of a fixed list.

//- - - - - - - - -
void(entity who) KillOldPet =
{
    local   entity  head, targ;
    local   float   when;

    when = time;
    targ = world;
    head = nextent (world);
    while (head)
    {
        if (head.xfl & XFL_PET)
        if (head.master == who)
        if (!head.deadflag)
        if (head.spawned)
        if (head.spawned < when)
            {targ = head;  when = head.spawned;}
        head = nextent (head);
    }
    T_Kill (targ, world, who, -1, "impulse");
};

void() Kill_ExtraMonster =
{
    local   entity  head, targ;
    local   float   when;

    when = time;
    targ = world;
    head = nextent (world);
    while (head)
    {
        if (!head.master)
        if (!head.deadflag)
        if (head.spawned)
        if (head.spawned < when)
            {targ = head;  when = head.spawned;}
        head = nextent (head);
    }
    T_Kill (targ, world, world, -1, "impulse");
};

float() Count_ExtraMonsters =
{
    local   entity  e;
    local   float   hits;

    hits = 0;
    e = nextent (world);
    while (e)
    {
        if (e.spawned)
            if (e.flags & FL_MONSTER)
                if (!e.master)
                    if (!e.deadflag)
                        hits = hits + 1;
        e = nextent (e);
    }
    return hits;
};

// Doomcube: Kills one monster if spawned monsters exceeds a limit.
float() CountKill_ExtraMonsters =
{
    local   entity  head, targ;
    local   float   hits, when;

    hits = 0;
    when = time;
    targ = world;
    head = nextent (world);
    while (head)
    {
        if (head.spawned)
        if (head.flags & FL_MONSTER)
        if (!head.master)
        if (!head.deadflag)
        {
            if (head.spawned < when)
                {targ = head;  when = head.spawned;}
            hits = hits + 1;
        }
        head = nextent (head);
    }
    if (hits > 20)      // Kill oldest spawn if too many monsters!
        T_Kill (targ, world, world, -1, "impulse");
    return hits;
};
//- - - - - - - - -

// Doomcube spawns a monster.
void() doomcube_spawn =
{
    summon_func (world, self.master, self.pos1, 0, EntryPoint_BossCube);
    CountKill_ExtraMonsters ();
    remove (self);
};

void() doomcube_fly =
{
    local   vector  vec, dir, spot;
    local   float   dist, fuse, sped;

    spot = self.enemy.origin;
    spot_z = spot_z + 1;    //+ 32;
    vec = spot - self.origin;
    dir = normalize (vec);
    dist = vlen (vec);
    sped = 400;
    fuse = dist / sped;

    newmis = spawn ();
    newmis.master       = self.chain2;      // Link to func_spawn.
    newmis.owner        = self;
    newmis.movetype     = MOVETYPE_NOCLIP;
    newmis.solid        = SOLID_NOT;
    newmis.classname    = "doomcube";
    newmis.pos1         = spot;
// set missile speed
    newmis.speed        = sped;
    newmis.velocity     = dir * sped;
    newmis.avelocity    = '0 0 0';
    newmis.avelocity_y  = sped;
    newmis.angles       = '0 0 0';
    newmis.ideal_yaw    = self.enemy.angles_y;
// set missile duration
    newmis.nextthink    = time + fuse;
    newmis.think        = doomcube_spawn;
//newmis.summontarget = "test";   // What's this?

    setall (newmis, "progs/doomcube.mdl", '0 0 0', '0 0 0', self.origin);
};

void() doomcube_think =
{
    self.enemy = find (self.enemy, targetname, self.target);
    if (!self.enemy)
    {
        self.enemy = find (world, targetname, self.target);
        if (!self.enemy)
            return;     // No targets.
    }
    self.nextthink = time + 5;
    self.think = doomcube_think;

// Select a monster spawner.
    self.chain2 = summon_data (self.summontarget);
    if (!self.chain2)
    {   dprint ("no func_spawn to copy from!\n");
        return;     // Nothing to spawn with.
    }
//- - - - - - - - -
    doomcube_fly ();
    sound (self, CHAN_WEAPON, "doomcube/dsbospit.wav", 1, ATTN_NONE);
};

void() doomcube_use =
{
    self.use = SUB_Null;
    self.enemy = world;
    sound (self, CHAN_VOICE, "doomcube/dsbossit.wav", 1, ATTN_NONE);

    self.nextthink = time + 5;
    self.think = doomcube_think;
};

void() misc_doomcube =
{
// PM:  Don't bother with spawned or other summon related stuff.
    if (noenemies)
        {remove (self);  return;}

    if (!self.targetname)
        objerror ("misc_doomcube: no targetname");

// Sounds needed by the spawner itself.
    precache_model ("progs/doomcube.mdl");
    precache_sound ("doomcube/dsbospit.wav");
    precache_sound ("doomcube/dsbossit.wav");   // J.Romero's reversed hint.

// Update 8/12/10:
// Use 'func_spawn' or 'func_summon' to precache monster files.
self.summontarget = "cubed";    // for roman3 test in h.qc.

    self.use = doomcube_use;
    setform (self, "", '0 0 0', '0 0 0');
};


//===========================/  END OF FILE  /===========================//

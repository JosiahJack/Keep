//
// FIXME:  Rod is gone, use something else!
//
// Update 1/31/10:  For rod weapon.
// Like *_Circle above, except only to first three points are used.
// Used by the spirit weapon/magic rod.


// FIXME:  Move, maybe to ammo stuff once resolved.
void(entity ent) Mace_HUD =
{
    if (ent.flags & FL_CLIENT)
    if (ent.war == WAR_TAMER)
    {
        ent.items = ent.items - (ent.items & ITx_ALL_AMMO);
        if (ent.mist.tamed)
            ent.currentammo = 0;    // Captured something.
        else if (ent.tamed)
            ent.currentammo = 1;
        else
            ent.currentammo = ent.ammo_tamer;
    }
};

//==========================================================================
//
//  CAPTURE
//
//==========================================================================

// Update 1/30/10:  Finally decided capturing mechanics.
//
// Monster capturing is like casting a spell.  The player waves his
// rod at monsters, and the closest one will be targeted.  If the
// monster can be captured, a mist of particles will glitter around
// target until captured or disrupted.

void(entity targ) Disc_Capture =
{
// Attacker must be self.master so messages and triggers work properly.
    T_Kill (targ, self, self.master, 0, "capture");

// The above gives the player control of the monster immediately.
// Change it so that player must collect its soul first before he
// can command his new pet.
    self.tamed = self.master.tamed;
    if (self.master)
        self.master.tamed = world;      // Player must retrieve soul first.
};

void() Disc_Remove =
{
    local   entity  src;

    src = self.master;
    if (src)
    if (src.mist == self)
    {
        src.mist = world;
        Mace_HUD (src);
    }
    remove (self);
};

void() Capture_Eject =
{
    self.effects = EF_DIMLIGHT;
    self.speed = 400;
    self.frame = 80;
    self.walkframe = 0;
    setall (self, "progs/s_spark.spr", '0 0 0', '0 0 0', self.enemy.origin);

    self.enemy = self.master;   // So it returns.
    Mace_HUD (self.master);
};

// Transfers captured pet to its master.
void() Disc_Loot =
{
    local   entity  ent;

    ent = self.master;
    if (ent)
    {
        ent.tamed = self.tamed;
        sound (ent, CHAN_ITEM, "items/r_item1.wav", 1, ATTN_NORM);
        Safe_stuffcmd (ent, "bf\n");
    }
    Disc_Remove ();
    Mace_HUD (ent);
};

// Drains one cell per call, or removes 'self' if attacker has none.
// Returns TRUE if 'self' was removed due to lack of juice.
// 'self' is the capturing missile.
float() Capture_Drained =
{
    if (self.master)
    {
        if (self.master.ammo_tamer < 1)
            {Disc_Remove ();  return TRUE;}

        self.master.ammo_tamer = self.master.ammo_tamer - 1;
        if (self.master.war == WAR_TAMER)
            self.master.currentammo = self.master.ammo_tamer;
    }
    return FALSE;
};

void() Capture_Think =
{
    self.nextthink = time + 0.1;
    self.think = Capture_Think;

    if (!self.enemy)
        {Disc_Remove ();  return;}
    if (IsDead (self.master))
        {Disc_Remove ();  return;}

    if (self.enemy == self.master)
    {   // Returning back to attacker.
        local   vector  spot;

        if (Overlap (self, self.master))
            {Disc_Loot ();  return;}
        spot = self.enemy.origin + '0 0 16';
        if (vlen(spot - self.origin) < 40)
            {Disc_Loot ();  return;}

        self.movedir = normalize (spot - self.origin);
        self.velocity = self.movedir * self.speed;
        self.frame = 80 + self.walkframe;
        self.walkframe = self.walkframe + 1;
        if (self.walkframe > 4)
            self.walkframe = 0;
        particle (self.origin, self.movedir, 1, 20);
        particle (self.origin, self.movedir, 41, 10);
        return;
    }

// Make the field stick inside the target.
    if (IsDead (self.enemy))
        {Disc_Remove ();  return;}
    if (IsOut (self.enemy))
        {Disc_Remove ();  return;}
//- - - - - - - - -
    if (self.enemy.master == self.master)
    {   // Already our pet.  Patch it up and recall when at max hp.
        if (self.enemy.health < self.enemy.max_health)
        {
            if (Capture_Drained ())
                return;
            T_Heal (self.enemy, 25, FALSE);
        }
        // ELSE... monster is already at full hp, so just nab it.
        self.dmg = self.enemy.health;
    }
    else
    {
        if (Capture_Drained ())
            return;
        // Cell hog.  That's why player gets many cells when he takes a rod.
        self.dmg = self.dmg + 6000;
    }
//- - - - - - - - -
    if (self.dmg >= self.enemy.max_health)
    {
        Disc_Capture (self.enemy);
        Capture_Eject ();
        return;
    }

    // If line-of-sight is broken for more than second, abort!
    if (visible2 (self.enemy, self.master))
        self.search_time = time + 1;
    else if (self.search_time < time)
        {Disc_Remove ();  return;}

// Glitter effects.
    if (self.enemy.master == self.master)
    {   // White mist for healing only.
        Particle_Cube (self.enemy, 1, 9);
        return;
    }
    Particle_Cube (self.enemy, 1, 41);      // Gray and blue for slow mist.
// Call damage function to make 'em squirm in pain and get mad.
    T_NewDamage (self.enemy, self, self.master, 0, DF_TIMED, "");
    // Slow the enemy.
    if (!IsDead (self.enemy))
        if (self.wait <= time)
            self.wait = self.enemy.nextthink = self.enemy.nextthink + random()*0.2;
};

// Launches the poke, er... mace head.
void(entity targ) Capture_Field =
{
    newmis = spawn ();
    newmis.master       = self;
    newmis.owner        =
    newmis.enemy        = targ;
    newmis.movetype     = MOVETYPE_NOCLIP;
    newmis.solid        = SOLID_NOT;
    newmis.classname    = "capture";
// set missile speed
    newmis.speed        = 0;
    newmis.velocity     = '0 0 0';
// set missile damage
    newmis.dmg          = 0;
// set missile duration
    newmis.search_time  = time + 1;
    newmis.nextthink    = 0.01;
    newmis.think        = Capture_Think;

    setall (newmis, "", '0 0 0', '0 0 0', targ.origin);

// Update attacker stats.
    if (self)
        self.mist = newmis;
};

entity(vector start, vector dir) Capture_Scan =
{
    local   entity  inflictor, attacker, head, best;
    local   float   dist, radius;
    local   vector  vec, end;
    local   float   /*cost,*/ vang, dot;

    best = world;

    radius = 400;   // Mjolnir=350, medium range=500-999
//    vang = 0.866;   // 30 deg. cone.
    vang = 0.93;
//- - - - - - - - -
    // Create dummy entity at spawn point so that 'CanDamage' works right.
    inflictor = spawn();
    setorigin (inflictor, start);
//- - - - - - - - -
    attacker = self;
    head = findradius(start, radius);
    while (head)
    {
        if (head.takedamage)
        if (head != attacker)
        if (head.health > 0)
        if (head.solid > SOLID_NOT)     // So DarkPlaces won't gib the fallen.
        if (head.flags & FL_MONSTER)
// FIXME:  invulnerability and cross should protect.
        {
            if (CanDamage (head, inflictor))
            {
                end = Midpoint (head);
                vec = end - start;
                dot = dir * normalize(vec);
                if (dot > vang)
                if (!HasReflection (head, end, 0))
                {
                    dist = vlen (vec);
                    if (vlen(vec) <= radius)
                        {best = head;  radius = dist;}
                }
            }
        }
        head = head.chain;
    }
//- - - - - - - - -
    remove (inflictor);
//- - - - - - - - -
    return best;
};

void(vector start, vector dir) Capture_Beam =
{
    local   entity  targ;
    local   float   cost, recall;

    targ = Capture_Scan (start, dir);
    recall = FALSE;

    if (!(targ.flags & FL_MONSTER))
        return;     // Target must be a monster.
//    if (targ.xfl & XFL_BOSS)
//        return;     // Immune and cannot be captured.
    if (IsDead (targ))
        return;     // Must be alive.

// Target is valid.
    if ((targ.xfl & XFL_ZOMBIE) || (targ.family & FAM_UNDEAD))
    if (targ.master != self)    // Don't blast our pets!
    {   // Target is undead, attempt to dispel it.  One-hit kill on success.
        cost = ceil (targ.health / 20);     // 10*2=20.  *2 against undead.
        if (self.ammo_tamer >= cost)
        {
            self.currentammo = self.ammo_tamer = self.ammo_tamer - cost;
            T_Kill (targ, self, self, -50, "mace");
        }
        return;
    }
    Capture_Field (targ);
};

// Assumes 'self' is always good.
void() Disc_Summon =
{
    local   entity  targ;
    local   float   osf;
    local   vector  oang, oorg;

    targ = self.tamed;

    if (!targ)
        return;
    if (!EntryPoint_Spawn (targ, self, self.origin, EntryPoint_Circle))
        return;

// Save these fields so we can change them for use in monster_respawn.
    osf = targ.spawnflags;
    oang = targ.mangle;
    oorg = targ.oldorigin;

    self.tamed = world;     // Released into the world.
// FIXME:  Disabled now for debugging, uncomment when done.
//    if (!targ.th_spawn)
//        return;     // Can't respawn our monster, so leave it in netherspace.

// Respawn the creature.
    targ.master = self;     // All your base are belong to us.
    targ.spawnflags = targ.spawnflags | SPAWN_WHITE;    // Force loyalty.
    targ.mangle_x = 0;
    targ.mangle_y = vectoyaw (self.origin - targ.origin);
    targ.mangle_z = 0;
    targ.oldorigin = targ.origin;   // Use the summon spawnpoint.
    SUB_Think (targ, monster_respawn);

// Restore original spawn data.
    targ.mangle = oang;
    targ.oldorigin = oorg;
    targ.spawnflags = osf;
};

void() W_UseMace =
{
    local   vector  vec, dir;

// There is a delay before firing, so don't fire if not an appropriate time.
    if (cutscene || intermission_running)
        return;

    if (self.mist)
    {   // Capture attempt in progress.
        if (!self.mist.tamed)   // TRUE = Wasn't captured yet.
            SUB_Think (self.mist, Disc_Remove);     // Cancel
        return;
    }

// Player is invoking a special power.
    if (self.tamed)
    {
        Disc_Summon ();     // "Pikachu, I choose you!"
        Mace_HUD (self);
    }
    else
    {   // "Go pokeball!"
        makevectors (self.v_angle);
        dir = v_forward;
        vec = self.origin + (v_forward*8) + '0 0 16';

        stuffcmd (self, "bf\n");
//        sound (self, CHAN_WEAPON, "hknight/attack1.wav", 1, ATTN_NORM);
        Capture_Beam (vec, dir);
    }
};


//===========================/  END OF FILE  /===========================//

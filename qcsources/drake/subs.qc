//==========================================================================
//  The Basics

void() SUB_Null = {};

// PM:  This severs as many links to this entity as possible before removal.
void(entity e) Remove_Ent =
{
    if (e)
    {
        Burn_Null (e);
        e.targetname = world.null_string;
        if (e.use)
            e.use = SUB_Null;   // Don't use e anymore.
        remove (e);
    }
};

void() SUB_Remove = {Remove_Ent (self);  /*self = world;*/};


//==========================================================================
//  Velocity Motion

//============
// After moving, set origin to exact final destination
//============
void() SUB_CalcMoveDone =
{
    setorigin (self, self.finaldest);
    self.velocity   = '0 0 0';
    self.nextthink  = -1;
    if (self.think1)
        self.think1 ();
};

//===============
// SUB_CalcMove
//
// calculate self.velocity and self.nextthink to reach dest from
// self.origin traveling at speed
//===============
void(vector tdest, float tspeed, void() func) SUB_CalcMove =
{
    local   vector  vdestdelta;
    local   float   traveltime;

    if (!tspeed)
        objerror ("No speed is defined!");

    self.think1     = func;
    self.finaldest  = tdest;
    self.think      = SUB_CalcMoveDone;

    if (tdest == self.origin)
    {
        self.velocity   = '0 0 0';
        self.nextthink  = self.ltime + 0.1;
        return;
    }

// set destdelta to the vector needed to move
    vdestdelta = tdest - self.origin;
    
// calculate length of vector, then divide by speed to get time to reach dest
    traveltime = vlen (vdestdelta) / tspeed;

    if (traveltime < 0.1)
    {
        self.velocity = '0 0 0';
        self.nextthink = self.ltime + 0.1;
        return;
    }
    
// set nextthink to trigger a think when dest is reached
    self.nextthink = self.ltime + traveltime;

// scale the destdelta vector by the time spent traveling to get velocity
    self.velocity = vdestdelta * (1/traveltime);    // qcc won't take vec/float
};

void(entity ent, vector tdest, float tspeed, void() func) SUB_CalcMoveEnt =
{
    local   entity  stemp;

    stemp = self;
    self = ent;
    SUB_CalcMove (tdest, tspeed, func);
    self = stemp;
};


//==========================================================================
//  Angular Velocity

//============
// After rotating, set angle to exact final angle
//============
void() SUB_CalcAngleMoveDone =
{
    self.angles     = self.finalangle;
    self.avelocity  = '0 0 0';
    self.nextthink  = -1;
    if (self.think1)
        self.think1 ();
};

//=============
// SUB_CalcAngleMove
//
// calculate self.avelocity and self.nextthink to reach destangle from
// self.angles rotating 
//
// The calling function should make sure self.think is valid
//===============
void(vector destangle, float tspeed, void() func) SUB_CalcAngleMove =
{
    local   vector  destdelta;
    local   float   traveltime;

    if (!tspeed)
        objerror ("No speed is defined!");

// set destdelta to the vector needed to move
    destdelta = destangle - self.angles;

// calculate length of vector, then divide by speed to get time to reach dest
    traveltime = vlen (destdelta) / tspeed;

// set nextthink to trigger a think when dest is reached
    self.nextthink = self.ltime + traveltime;

// scale the destdelta vector by the time spent traveling to get velocity
    self.avelocity = destdelta * (1 / traveltime);
    
    self.think1 = func;
    self.finalangle = destangle;
    self.think = SUB_CalcAngleMoveDone;
};

void(entity ent, vector destangle, float tspeed, void() func)
    SUB_CalcAngleMoveEnt =
{
    local   entity  stemp;

    stemp = self;
    self = ent;
    SUB_CalcAngleMove (destangle, tspeed, func);
    self = stemp;
};



//=============================================================================
// PM:  'void() SUB_UseTargets;' moved to 'proto.qc'

//============
void() DelayThink =
{
    activator = self.enemy;
    SUB_UseTargets ();
    remove(self);
};

//============
// Called by SUB_UseTargets.
void(string text) FireTargets =
{
    local   entity  t, stemp, otemp, act;

    act = activator;
    t = world;
    do
    {
        t = find (t, targetname, text);
        if (!t)
            return;

        // PM:  Swap self and other only if t gets used.
        if (t.use)
            if (t.use != SUB_Null)
            {
                stemp = self;
                otemp = other;
                self = t;
                other = stemp;

                self.use ();

                self = stemp;
                other = otemp;
                activator = act;
            }
    } while ( 1 );
};

//==============================
// SUB_UseTargets
//
// the global "activator" should be set to the entity that initiated the
// firing.
//
// If self.delay is set, a DelayedUse entity will be created that will
// actually do the SUB_UseTargets after that many seconds have passed.
//
// Centerprints any self.message to the activator.
//
// Removes all entities with a targetname that match self.killtarget,
// and removes them, so some events can remove other triggers.
//
// Search for (string)targetname in all entities that
// match (string)self.target and call their .use function
//==============================
void() SUB_UseTargets =
{
    local   entity  t;

//
// check for a delay
//
    if (self.delay)
    {
    // create a temp object to fire at a later time
        t = spawn();
        t.classname     = "DelayedUse";
        t.nextthink     = time + self.delay;
        t.think         = DelayThink;
        t.enemy         = activator;
        t.message       = self.message;
        t.killtarget    = self.killtarget;
        t.target        = self.target;
        t.target2       = self.target2;     // PM:  New two target system.
// FIXME:  Noise inheirtance may break expected sounds for delayed secrets.
//        t.noise         = self.noise;       // PM:  Inherit noise too.
        return;
    }

//
// print the message
//
    if (activator.classname == "player")
        if (self.message != "")
        {
            centerprint (activator, self.message);
            if (!self.noise)
                sound (activator, CHAN_VOICE, "misc/talk.wav", 1, ATTN_NORM);
        }

//
// kill the killtagets
//
    // PM:  Rewrote killtarget loop so target use isn't skipped afterwards.
    if (self.killtarget)
    {
        local   entity  t2;

        t = find (world, targetname, self.killtarget);
        while (t)
        {
            t2 = find (t, targetname, self.killtarget);
            if (t != self)      // PM:  Don't remove self.  WATCH THIS!
                {Remove_Ent (t);}
            t = t2;
        }
    }
    
//
// fire targets
//
    if (self.target)
        if (self.target != self.killtarget) // No sense using removed ents.
            FireTargets (self.target);
// PM:  Added support for two target types.
    if (self.target2)
        if (self.target2 != self.target)    // Avoid double duty.
            if (self.target2 != self.killtarget)
                FireTargets (self.target2);

};


//============
// In nightmare mode, all attack_finished times become 0,
// and some monsters refire twice automatically
//
// PM:  In nightmare, attempts to change attack_finished via SUBs are
//  ignored, not set to zero -- big difference!  You can (still) set
//  attack_finished in Nightmare whenever appropriate, just not here.
//============
void (void() thinkst) SUB_CheckRefire =
{
    if (skill < 3)
        return;     // Not Nightmare.
    if (self.cnt)
        return;     // Already refired.
    if (!visible (self.enemy))
        return;
    if (IsDead (self))
        return;     // PM:  Unwanted thinking may resurrect 'self' if dead.
    self.cnt = 1;
    self.think = thinkst;
};

void(float normal) SUB_AttackFinished =
{
    self.cnt = 0;        // refire count for nightmare
    if (skill < 3)
    {   // Never speed up attack finished.  This allows a monster's missile
        // function to set reload times without the need to add bulky code
        // to undo any speedups the old code may cause. -- PM
        normal = time + normal;
        if (self.attack_finished < normal)
            self.attack_finished = normal;
    }
};


//==========================================================================
//
//  EXTRA STUFF BELOW (Added by PM)
//
//==========================================================================

//==========================================================================
//  Macro-Style Functions

//------------------------------------------------------------------------//
//  This makes an entity do a think function right now.
//------------------------------------------------------------------------//
void(entity ent, void() thinkst) SUB_Think =
{
    local   entity  swap;

    swap = self;
    self = ent;
    thinkst ();
    self = swap;
};

//------------------------------------------------------------------------//
//  This forces a touch call bewteen two entities.
//
//  WARNING:  Never use if self's touch function removes either entity.
//
//  PM's note:  I wrote this function for Dragons, where a player can
//  take items collected by Draco just by touching him.
//
//  Update:  Also used by wraiths to check contact with path_corners.
//------------------------------------------------------------------------//
void(entity eo, entity es) SUB_Touch =
{
    if (!es.touch)
        return;     // No touch function available.

    local   entity  oo, os;

    oo = other;
    os = self;
    other = eo;
    self = es;
    self.touch ();
    other = oo;
    self = os;
};


//==========================================================================
//  Safe Message Functions

// These are for functions that display messages and are used by clients
// (players) and non-clients (monsters).  Such functions include item pickups
// and powerup countdowns.

void(entity ent, string text) Safe_sprint =
{
    if ((ent.flags & FLx_CREATURE) == FL_CLIENT)
        sprint (ent, text);
};

void(entity ent, string text) Safe_centerprint =
{
    if ((ent.flags & FLx_CREATURE) == FL_CLIENT)
        centerprint (ent, text);
};

void(entity ent, string text) Safe_stuffcmd =
{
// The server crashes if it attempts a stuffcmd on a non-client.
    if ((ent.flags & FLx_CREATURE) == FL_CLIENT)
        stuffcmd (ent, text);
};

// Use this to centerprint a message to everyone.
void(string text) Mass_Centerprint =
{
    local   entity  pc;

    pc = find (world, classname, "player");
    while (pc)
    {
        if ((pc.flags & FLx_CREATURE) == FL_CLIENT)   // Confirm pc status.
            centerprint (pc, text);
        pc = find (pc, classname, "player");
    }
};

// Prints developer messages about self.
void(string s1, string s2) print_self =
    {dprint(s1);  dprint(s2);  dprint(vtos(self.origin));  dprint("\n");};


//==========================================================================
//  Reset Buttons

// Removes all temporary powerups and their effects.
// Does NOT remove permanent powers like extra health or equalizer.
// The real purpose of this function is to turn off lights and colored
// screens for entities when necessary.
void() SUB_RemovePowerups =
{
// Standard Quake powerups.
    self.items      = self.items - (self.items & ITx_ALL_POWERUPS);
    self.items2     = self.items2 & IT2x_ALL_RUNES;     // Runes stay.
    self.effects    = 0;    // PM:  Erase shield, lights, and the rest.

    self.invincible_finished    = self.invisible_finished   = 0;
    self.super_damage_finished  = self.radsuit_finished     = 0;

    self.invincible_time    = self.invincible_sound = 0;
    self.invisible_time     = self.invisible_sound  = 0;
    self.super_time         = self.super_sound      = 0;
    self.rad_time           = 0;

// Extra powerups (Hipnotic, Quoth, Zerstorer, and my own additions)
    self.thorns_finished  = self.thorns_time  = self.thorns_sound  = 0;
    self.cross_finished   = self.cross_time   = self.cross_sound   = 0;
    self.wing_finished    = self.wing_time    = self.wing_sound    = 0;
    self.mirror_finished  = self.mirror_time  = self.mirror_sound  = 0;
    self.mirror_ping      = 0;
    // Arcanum:  Tome of Power and Necromancer curses.
    self.tome_finished    = self.tome_time    = 0;
    self.curse_finished   = self.curse_type   = 0;
    self.gravity          = fabs(self.gravity);   // Boots of Leviation.
// Jump pads
    self.jump_time          = 0;

// Reset Mjolnir (and other weapons).
    self.hammer_finished    = 0;
    self.zapper_time        = 0;

// DISABLED -- v_cshift causes unwanted problems for me.
    // Screen color, done much like in Quoth.
//    if (self.flags & FLx_CREATURE == FL_CLIENT)
//        stuffcmd (self, "v_cshift 0 0 0 0");
};

void(float hp) SUB_FullHealth =
{
    // Health can range from -32768 to 65535.
    if (self.health)
        hp = self.health;
    hp = floor (hp);

    if (hp > 50000)
        hp = 50000;
    else if (hp < 1)
        hp = 1;

    self.health = self.max_health = hp;
};

// Convenience function -- precache a model then set self to that model.
void(string gfx) cache_set  = {precache_model(gfx);  setmodel(self, gfx);};

// Convenience function -- one that sets model and size.
// Called by monster spawn functions.
void(entity e, string s, vector v1, vector v2) setform =
    {setmodel (e, s);  setsize (e, v1, v2);};

// Convenience function -- set model, size, and origin.
// Called by various missile functions.
void(entity e, string s, vector v1, vector v2, vector org) setall =
{
    setmodel (e, s);        // May resize hullbox after this is called.
    setsize (e, v1, v2);    // Must do *after* setmodel.
    setorigin (e, org);     // Updates links immediately, so do last.
};


//==========================================================================
//  Miscellaneous Junk

//- - - - - - - - -
// How games handled pain in Nightmare.
// Doom:  Monsters take pain normally.  However, most monsters didn't
//  flinch reliably, and when they did, had short delays.
// Quake1:  Immune to pain for five seconds after taking damage.
// Quake2:  Immune to pain.
//
// Complete immunity to pain is not fun, and makes some monsters much
// more dangerous than normal.  For instance, the lowly grunt with his
// hitscan shotgun.
//- - - - - - - - -
// Checks if monster won't flinch from pain.
float() SUB_IgnorePain =
{
    if (skill >= 3)
    {   // Nightmare or Hell.
        if (random() < 0.5)     // Update 1/5/10:  Go 50/50 instead of 100%.
            return TRUE;
    }
    return FALSE;
};

// Checks if monster should use a faster attack.
// Used to make rhythm tactics such as shambler dancing harder.
float() SUB_QuickAttack =
{
    if (skill >= 2)
        if (self.health <= (self.max_health * 0.25))
            if (random() < 0.5)     //0.25
                return TRUE;

// Always fast in Cranked mode.  Otherwise, normal speed.
    return cranked;
};

// Spawns a muzzleflash.  Used by phased out monsters with a modelindex
// of zero, who cannot display effects while modelindex is zero.
// Update 9/5/09:  Also by players for some weapons to get around
// Qrack's custom client muzzleflashes.
void() SUB_Flash =
{
    local   entity  e;

    e = spawn();
    e.movetype  = MOVETYPE_NONE;    //MOVETYPE_NOCLIP;
    e.velocity  = '0 0 0';          //self.velocity;
    e.touch     = SUB_Null;
    e.solid     = SOLID_NOT;
    e.effects   = EF_MUZZLEFLASH;       // The point of this function.
    e.nextthink = time + 0.1;
    e.think     = SUB_Remove;
    // Non-zero invisible model.
    setall (e, "progs/null_256.spr", '0 0 0', '0 0 0', self.origin);
};

// Unstick an entity from the ground.
void(entity e) SUB_OffGround =
{
    if (e)
    {   e.flags = e.flags - (e.flags & FL_ONGROUND);
        e.groundentity = world;
    }
};

// Like findradius, except the chain includes entities with solid_not.
// Useful when you want explosions and the like to gib non-solid corpses.
entity(vector org, float radius) QC_FindRadius =
{
    local   entity  e, head;
    local   vector  spot;

    head = world;
    e = nextent (world);
    while (e)
    {
        spot = e.origin + (e.mins + e.maxs)*0.5;
        if (vlen(org - spot) <= radius)
        {
            e.chain = head;
            head = e;
        }
        e = nextent (e);
    }
    return head;
};

// Find the next player among the entities.
entity(entity e) NextPlayer =
{
    e = find (e, classname, "player");
    if (!e)
        e = find (world, classname, "player");
    return e;
};

// Finds a random player in the game.
entity() RandomPlayer =
{
    local   entity  e;

    e = find (world, classname, "player");
    if (deathmatch || coop)
    {
        local   float   loop;

        loop = 0;
        while (e)
        {   loop = loop + 1;
            e = find (e, classname, "player");
        }
        loop = loop * random();
        loop = ceil (loop);
        e = world;
        do
        {
            e = find (e, classname, "player");
            loop = loop - 1;
        } while (loop > 0);
    }
    return e;
};

// Returns number of pet monsters of a given class.
// Used by boss necro to count imps.
float(entity ent, string mclass) count_petclass =
{
    local   entity  head;
    local   float   hits;

    hits = 0;
    head = find (world, classname, mclass);
    while (head)
    {
        if (head.master == ent)
            if (head.xfl & XFL_PET)
                if (!IsDead (head))
                    hits = hits + 1;
        head = find (head, classname, mclass);
    }
    return hits;
};

// Add one to the global float.  Used to help calculate attack patterns for
// some monsters.  Update:  Rollover after 8-bit limit.
float() AddOne = {gloat = (gloat + 1) & 255;  return gloat;};

//- - - - - - - - -

// Show runes for a client.
void(entity e) HUD_Runes =
{
    if (e)
    {   // Don't overwrite powerup icons.
        if (!(e.items2 & IT2_WETSUIT))
            e.items2 = (e.items2 - (e.items2 & IT2x_RUNES12)) | ((serverflags & 3) * IT2_RUNE1);
        if (!(e.items2 & IT2_SHIELDS))
            e.items2 = (e.items2 - (e.items2 & IT2x_RUNES34)) | ((serverflags & 12) * IT2_RUNE1);
    }
};

// Call this when rune serverflags change during play.
// That is, when a player takes a rune or inputs impulse 11.
void() HUD_ServerRunes =
{
    local   entity  e;

    e = find (world, classname, "player");
    while (e)
    {
        HUD_Runes (e);
        e = find (e, classname, "player");
    }
};

/* FIXME:  Move here (at subs.qc)?  Used by monsters too?
void() SUB_TriggerFieldRemove =
{
    if (self.trigger_field)
    {
//        if (self.goalentity == self.trigger_field)
//            self.goalentity = self.enemy;
        remove (self.trigger_field);
        self.trigger_field = world;
    }
};
*/


//===========================/  END OF FILE  /===========================//

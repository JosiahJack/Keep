//=========================================================================
// soul.qc
//
// Here in its own file for any wraith-like monster to use.
//=========================================================================

// Spawnflags used by ghosts (wraith, dreadlord, and nightshade).
// 1 = Ambush, as standard plus phased out when idle.
// 2 = Special, wraiths behave as in Nehahra, dreadlords get boss mode.
// 4 = Souls, seek out and collect souls.  Enables fleeing and aether scenes.
float   SPAWN_SOUL  = 4;    // Spawnflag that tells wraith to seek out souls.

float   SOUL_TIME   = 15;

// Call this to remove souls.
void() Soul_Remove =
{
    if (self.oldenemy)
        if (self.oldenemy.solid)
            if (!self.oldenemy.deadflag)
                if (self.oldenemy.soul == "in")
                    self.oldenemy.soul = "yes";     // Safe in body again.
    if (self.owner)
    {
        if (self.owner.enemy == self)
            self.owner.enemy = world;   // Target is gone, find another.
        if (self.owner.oldenemy == self)
            self.owner.oldenemy = world;    // Ditto
        if (!self.owner.deadflag)
            self.owner.gorging = FALSE; // Get out of reaper mode.
    }
    remove (self);
};

// 'self' is the soul getting sucked in.
void() Soul_Think = [ 0, Soul_Think ]
{
    local   entity  reaper;
    local   vector  org;

    self.nextthink = time + 0.05;
    if (self.wait < time)
    {
        sound (self, CHAN_BODY, "wraith/soul.wav", 1, ATTN_IDLE);
        self.wait = random() * 60 + time;
    }

    reaper = self.owner;
    if (self.delay <= time)
    {   // Lost for too long.
        Soul_Remove ();
        return;
    }
    if (!reaper.gorging || (reaper.health <= 0) || (reaper.enemy != self))
    {   // Not sucking souls now.
        self.velocity = '0 0 0';
        if (reaper)
            if (reaper.health <= 0)
            {   // Reaper is dead.
                self.owner = world;
            }
        if (self.cnt)
        {   // Still inside corpse.
            local   entity  src;

            self.delay = time + SOUL_TIME;
            src = self.oldenemy;
            if (!src.modelindex || !src.deadflag)
            {   // Corpse is gone!
                Soul_Remove ();
            }
            else
            {   // Stick to corpse.
                if (self.owner)
                {
                    self.origin     = src.origin;
                    self.origin_z   = src.absmin_z + 4;
                    setorigin (self, self.origin);
                }
                else
                {   // No one stealing its soul now, so put it back.
                    Soul_Remove ();
                    src.soul = "yes";
                }
            }
        }
        return;
    }
    self.delay = time + SOUL_TIME;
    if (self.cnt)
    {   // Rip the soul out of the body.
        self.soul = world.null_string;
        self.alpha = 0.3;
        self.cnt = FALSE;
        self.effects = EF_DIMLIGHT;
        setmodel (self, "progs/soul.mdl");
        setsize (self, '0 0 0', '0 0 0');
    }
    if (self.mangle_x || self.mangle_y)
    {   makevectors (reaper.angles);
        org = reaper.origin + (v_forward*self.mangle_x)
            + (v_forward*self.mangle_y) + (v_forward*self.mangle_z);
    }
    else
        org = reaper.origin + self.mangle;
    org = org - self.origin;
    self.velocity = normalize(org) * 40;
    if (vlen(org) < 20)
    {   // Close enough for soul to be devoured by wraith.
        StopSound (self, CHAN_BODY);
        // FIXME:  Blink.
        T_Heal (reaper, 50, TRUE);
// FIXME:  Find another, more general way if more monsters use this.
        if (reaper.classname == "monster_nightshade")
            sound (reaper, CHAN_VOICE, "shade/taunt.wav", 1, ATTN_NORM);
        else
            sound (reaper, CHAN_VOICE, "wraith/rych1.wav", 1, ATTN_IDLE);
        Soul_Remove ();
    }
};

// Spawns a fresh soul by ripping it out of 'ent'.
// 'self' is the monster looking for souls to steal.
void(entity ent) Soul_Spawn =
{
    local   entity  s0ul;

    if (ent)
        ent.soul = "in";
    else
        return;

// Nehahra aborted this if soul would spawn at the origin.
    s0ul = spawn();
    s0ul.origin     = ent.origin;
    s0ul.origin_z   = ent.absmin_z + 4;
    // Cannot use 'master' because summon code thinks soul is a pet.
    s0ul.oldenemy   = ent;
    s0ul.owner      = self;
    s0ul.classname  = "soul";
// Don't make bodies glow.
    s0ul.solid      = SOLID_TRIGGER;
    s0ul.movetype   = MOVETYPE_NOCLIP;
// Don't need health.
// More fields in case enemy is a nightshade and not a wraith.
    s0ul.cnt        = TRUE;     // Begins hidden in corpse.
    s0ul.mangle     = '0 0 20';
    if (self.classname == "monster_nightshade")
        s0ul.mangle_x   = 30;   // Was 50.

    s0ul.delay      = time + SOUL_TIME;
    s0ul.wait       = 0;

    s0ul.nextthink  = time + 0.2;
    s0ul.think      = Soul_Think;

    setorigin (s0ul, s0ul.origin);
    setmodel (s0ul, "progs/null_256.spr");  // So it can glow while invisible.
    setsize (s0ul, '0 0 0', '0 0 0');

    if (self.flags & FL_MONSTER)
    {
        if (self.enemy)
            self.oldenemy = self.enemy;
        self.enemy = s0ul;
    }
};


float() Wraith_FindSoul =
{
    local   float   dist, d;
    local   entity  head, targ;

// Find the nearest lost soul.
    dist = 1001;
    targ = world;
    head = findradius(self.origin, 1000);
    while (head)
    {
        if (head.classname == "soul")
        if (!head.owner || (head.owner == self))
// DISABLED -- If wraith can sense souls in corpses, it can sense free souls.
//        if (visible (head))     // Legacy from Neh.
        {
            d = vlen(head.origin - self.origin);    //trace_plane_dist
            if (d < dist)
                {targ = head;  dist = d;}
        }
        head = head.chain;
    }
    if (targ)
    {   // Found one.
        targ.owner = self;

        if (self.enemy)
            self.oldenemy = self.enemy;
        self.enemy = targ;
        return TRUE;
    }
// Didn't find any lost souls, so look for fresh souls in corpses.
    head = find(world, soul, "yes");
    while (head)
    {
        if (head.health <= 0)
        if (head.h2otype != CONTENT_SOLID)
        {   // Got one!
// FIXME:  Find another, more general way if more monsters use this.
            if (self.classname == "monster_nightshade")
            {   // Use voice channel to override others.
                sound (self, CHAN_VOICE, "shade/screech.wav", 1, ATTN_NORM);
                sound (head, 6, "shade/screech.wav", 1, ATTN_IDLE);
            }
            else
            {   // Nehahra used item channel for selection.
                sound (self, CHAN_ITEM, "wraith/select.wav", 1, ATTN_IDLE);
                sound (head, 6, "wraith/select.wav", 1, ATTN_IDLE);
            }
            Soul_Spawn (head);
            return TRUE;
        }
        head = find(head, soul, "yes");
    }
    return FALSE;
};


//=========================================================================

void(string sfx) ai_wraith =
{
    if ((self.health < WRAITH_HP_CRITICAL) && (self.health < self.max_health))
    {   // Regenerate a bit if health is low.  Works independently of Regen*.
        if (random() < 0.1)
            T_Heal (self, 1, FALSE);
    }
    else
    {
        if (self.attack_state == AS_FLEEING)
        {   // self.enemy only in Nehahra.
            sound (self, CHAN_VOICE, sfx, 1, ATTN_IDLE);
            sound (self.enemy, CHAN_VOICE, sfx, 1, ATTN_IDLE);
            self.attack_state = AS_STRAIGHT;
            if (self.spawnflags & 2)
                if (self.classname == "monster_wraith")
                    self.attack_state = AS_CHASING;
        }
    }
};

void() aether_out1 =
{   // Phase out start.
    self.velocity   = '0 0 0';
    self.solid      = SOLID_NOT;
    self.takedamage = DAMAGE_NO;
    self.effects    = self.effects | EF_DIMLIGHT;
    sound (self, CHAN_VOICE, "wraith/return.wav", 1, 0.5);  // Was ATTN_NONE.
    self.th_melee   =
    self.th_missile = world.null_func;
};
void() aether_out2 =
{   // Phase out end.
    self.effects    = self.effects - (self.effects & EF_DIMLIGHT);
    self.flags      = self.flags | FL_NOTARGET;
    self.modelindex = 0;
};

void() aether_in1 =
{   // Phase in start.
    self.velocity   = '0 0 0';
    self.effects    = self.effects | EF_DIMLIGHT;
    self.flags      = self.flags - (self.flags & FL_NOTARGET);
    self.modelindex = self.mindex2;
    sound (self, CHAN_VOICE, "wraith/return.wav", 1, 0.5);  // Was ATTN_NONE.
};
void(void() hth, void() miss) aether_in2 =
{   // Phase in end.
    self.effects    = self.effects - (self.effects & EF_DIMLIGHT);
    self.solid      = SOLID_TRIGGER;
    self.takedamage = DAMAGE_AIM;
    self.th_melee   = hth;
    self.th_missile = miss;
};

float(void() out, void() in) ai_aether =
{
    local   float   aether;

// FIXME:  Use something other than fleeing to flag aether use.
    aether = (!self.modelindex && (self.attack_state == AS_FLEEING));
    if ((self.health < WRAITH_HP_CRITICAL) && (self.health < self.max_health))
    {
        if (!aether)
        {   if (self.health < WRAITH_HP_AETHER)
            {   // Phase out of the level.
                out ();
                return TRUE;
            }
        }
    }
    else
    {
        // Nehahra had more checks such that the wraith would reappear
        // only if it had more health than its target and if the target
        // didn't have any rockets.  Drake does not use such checks because
        // it makes 100% kills too hard to get.
        if (aether)
        {   // Rematerialize.
            in ();
            return TRUE;
        }
    }
    return FALSE;
};

float(float d, void() souls) ai_souls =
{
// Look for souls to reap.
    if (self.enemy)
    {
        if (self.enemy.classname != "soul")
        {   // Look for souls if ethereal or if enemy isn't present.
            if (!self.modelindex)
                Wraith_FindSoul ();
            else
            {
                if (self.search_time < time + 4)
                if (!visible (self.enemy))
                    Wraith_FindSoul ();
            }
        }
    }
    else
    {   // Look for souls to reap.
        Wraith_FindSoul ();
    }
// Now we move the wraith.
    if (self.enemy.classname == "soul")
    {
        if (souls)
        {
            if (vlen (self.enemy.origin - self.origin) < 300)
            {   // Close to soul, so stop to collect it.
                souls ();
            }
            else
            {   // Move directly to the soul.
                ai_face ();
                safe_move (self.angles_y, d);
            }
        }
        else
        {
            ai_face();
            if (vlen (self.enemy.origin - self.origin) >= 300)
                safe_move (self.angles_y, d);
        }
        return TRUE;
    }
    return FALSE;
};

// Used by phase-capable wraiths.
void(void() func1, void() func2) wraith_start =
{
    if (self.spawnflags & SPAWN_SOUL)
    {   // Resolve any conflict between phase by ambush or aether.
        if (self.health < self.max_health)
            if (self.health < WRAITH_HP_CRITICAL)
                {func1 ();  return;}
    }

    if (self.takedamage)
        func1 ();       // Wraith is visible and vulnerable.
    else
        func2 ();       // Wraith was phased out.
};


//===========================/  END OF FILE  /===========================//

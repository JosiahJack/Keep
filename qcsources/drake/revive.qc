//=========================================================================

// Don't move this time.
void() ai_ritual =
{
    if (self.fallen)
    {
        local   entity  temp;

        temp = self.enemy;
        self.enemy = self.fallen;
        ai_face ();
        self.enemy = temp;
    }
};

//=========================================================================

// Checks if 'self' can be raised from the dead.
// Must use self because one of the conditions requires a walkmove.
// Called by 'monster_revive'.
//
// Note:  findradius may be safe to use, since it is useless for detecting
// entities with SOLID_NOT, barring DarkPlaces engine.
//
float() CanSelfRevive =
{
    if (self.th_revive)
      if (self.flags & FL_MONSTER)
        if (self.deadflag == DEAD_DEAD)
          if (self.movetype == MOVETYPE_STEP)
            if (!self.gorging)    // Is someone else defiling the corpse?
              if (self.modelindex)
                if (self.modelindex == self.mindex2)
                {
                  if (self.maxs_x != self.dest2_x)
                  {
                    local   vector  v1, v2;

                    v1 = self.mins; v2 = self.maxs;
                    setsize (self, self.dest1, self.dest2);
                    if (safe_move (0, 0))
                      return TRUE;
                    setsize (self, v1, v2);
                  }
                  else
                  {
                    if (safe_move (0, 0))
                      return TRUE;
                  }
                }
    return FALSE;
};

// 'ent' = entity to be resurrected, 'god' = the one resurrecting ent.
// Note:  'CanSelfRevive' always returns FALSE, if ent == world.
float(entity ent, entity god) monster_revive =
{
    local   entity  os;
    local   float   res, good, pc;

    if (god == ent)
        god = world;    // If able to self-resurrect, use the world as god.

// Check if target is worthy of resurrection.
    pc = (god.classname == "player");
    if (pc)
        good = TRUE;
    else
    {
        // All good NPCs have a common spawnflag.
        // Exception:  Evil monsters revived and converted by players.
        good = ent.spawnflags & SPAWN_WHITE;
        if (ent.master)
        {
            if (!ent.master.alignment)
                return FALSE;   // Unknown unalignment -- master is likely dead.
            if (god)
                if (!Ally_Check (ent.master, god))
                    return FALSE;   // Don't revive the enemy's pets.
        }
    
        if (god)
        {
            if (good)
            {   if (god.alignment != GOOD)
                    return FALSE;   // Don't revive good guys if redeemer isn't one.
            }
            else
            {   if (god.alignment == GOOD)
                    return FALSE;   // Don't revive enemies.
            }
        }
        // ELSE god == world (or itself), and the world doesn't choose sides.
    }

// Now check for real.
    os = self;
    self = ent;

    res = CanSelfRevive ();
    if (res)
    {   // Play classic arch-vile resurrection sound.
        sound (self, CHAN_AUTO, "misc/dsslop.wav", 1, ATTN_NORM);
        self.pain_finished  = time + 1;  // Don't interrupt reanimation.

        Align_Add (self, good);
        if (self.alignment != GOOD)
            monster_1up ();     // Bad guy!  Increment kill total -- again.
        if (god)
        {   // Reset enemy since it was set to slayer when self died earlier.
            self.enemy = self.oldenemy = world;
            // 'God' forgets the revived if he is the enemy.
            // Otherwise, 'god' may attack him yet again.
            if (pc)
            {   // Player is reviving the target.
                self.master = god;
                self.enemy  = self.oldenemy = world;
            }
            else
            {
                if (god.oldenemy == self)
                    god.oldenemy = world;
                if (god.enemy == self)
                {   if (god.goalentity == self)
                        god.goalentity = god.oldenemy;
                    god.enemy = god.oldenemy;
                }
                // The revived targets the true enemy of 'god'.
                if (!Align_Match (god.enemy, god))
                    self.enemy      = god.enemy;
                else if (!Align_Match (god.oldenemy, god))
                    self.enemy      = god.oldenemy;
                // ELSE -- Don't waste time infighting (with slayer).
            }
        }
        else
        {   // Update 9/4/09:  Self-rezzed evil may remember the enemy.
            if (good || (self.enemy.alignment != GOOD)
            || (self.enemy.health <= 0))
                self.enemy = world;
            self.oldenemy = world;
        }
        // Reset other enemy dependant fields.
        self.goalentity = self.enemy;
        if (self.enemy)
        {   self.fighting   = TRUE;
            self.search_time= time + 5;
        }
        else
        {   self.fighting   = FALSE;
            self.search_time= time + 3;
        }

        // Sever all targeting links.
        self.targetname =
        self.killtarget = self.target = self.target2 = world.null_string;

        // SoE: Undo super drop bonus, and refill purse.
        monster_purse_reset ();

        // Restore physical properties then re-animate.
        self.solid      = SOLID_SLIDEBOX;
        self.takedamage = DAMAGE_AIM;
        self.deadflag   = DEAD_NO;
        self.health     = self.max_health;
        // Reset size in case it was changed by crushing brushes and the like.
        // Calling setsize or setorigin also updates the solid change now,
        // which without it, a solid change could get delayed until the
        // next frame.  A delayed solid change may allow another monster
        // to fuse with self and both will get stuck -- not good.
        setsize (self, self.dest1, self.dest2);
        self.th_revive ();
    }
    self = os;

    return res;
};

// Checks if monster should stop to revive a fallen monster.
// Success initiates resurrection.
float(float d) ai_medic =
{
    local   entity  head, goal;
    local   float   hit;
//- - - - - - - - -
    local   float   hp;

// HACK:  Bane -- Don't revive things with too much hp.
// Update:  At least until after Bane clones himself.
    hp = 0;
    if (self.classname == "monster_bane")
        if (self.waitmin)    // This is zero after Bane spawns clones.
            hp = 300;
//- - - - - - - - -

    hit = FALSE;
    goal = self.goalentity;
    head = nextent (world);
    while (head)
    {
        if (head.flags & FL_MONSTER)
        if (head.deadflag == DEAD_DEAD)
        if (!hp || (hp <= head.max_health))
        {
            self.goalentity = head;     // QC_CloseEnough checks against goal.
            hit = QC_CloseEnough (d);
            if (hit)
            {
                if (monster_revive (head, self))
                {
                    self.fallen = head;
                    self.goalentity = goal;
                    return TRUE;
                }
            }
        }
        head = nextent(head);
    }
    self.fallen = world;
    self.goalentity = goal;
    return FALSE;
};

// TRUE = Stop and revive monster.  FALSE = move as per ai_run(d).
float(float d, void() thinkst) ai_medic_run =
{
    if (ai_medic (d))
        {thinkst ();  return 1;}
    else
        {ai_run (d);  return 0;}
};

// Revives all monsters visible to 'self', within a set health limit.
// Used by skull wizard boss.
float(float hp) mass_revive =
{
    local   entity  head;
    local   float   hits;

    if (!hp)
        hp = INFINITY;
    hits = 0;
    head = nextent (world);
    while (head)
    {
        if (head.flags & FL_MONSTER)
        if (head.deadflag == DEAD_DEAD)
        if (head.max_health <= hp)
        {
            if (visible (head))
            if (infront (head))     // NOTE:  Assumes self is monster, not PC.
            {
                if (monster_revive (head, self))
                {
                    hits = hits + 1;
                    hp = hp - head.max_health;
                    if (hp < 1)
                        return hits;    // Cannot revive anymore.
                }
            }
        }
        head = nextent(head);
    }
    return hits;
};


//===========================/  END OF FILE  /===========================//

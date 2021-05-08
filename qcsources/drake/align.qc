//==========================================================================
//  align.qc -- by Patrick Martin
//--------------------------------------------------------------------------
//  This file contains code to maintain a whitelist of monsters friendly
//  to players and a blacklist of monsters hostile to players and NPCs.
//
//  The purpose of a whitelist is to serve as a hitlist of NPCs for
//  enemy monsters to attack.  Without the whitelist, enemy monsters
//  would look for players only.
//
//  The purpose of a blacklist is to serve as a hitlist of enemy monsters
//  for whitelisted monsters to attack without executing numerous calls
//  to findradius to find a suitable target.
//
//  The hitlists use find/classname instead of linked lists for stability.
//
//  FIXME:  If DarkPlaces, use findfloat instead of find.
//==========================================================================

//==========================================================================
//  Hitlist Count

//------------------------------------------------------------------------//
//  These count the number of entries in the blacklist/whitelist.
//
//  text : Use either GOOD or EVIL.
//------------------------------------------------------------------------//
float(string text) Align_Count =
{
    local   entity  e;
    local   float   i;

    i = 0;
    e = find (world, alignment, text);
    while (e)
        {i = i + 1;  e = find (e, alignment, text);}
    return i;
};


//==========================================================================
//  Family Hierarchy

//------------------------------------------------------------------------//
//  This returns the grand patron of an entity.  An entity with no master
//  is its own patriarch.
//------------------------------------------------------------------------//
entity(entity e) Patriarch =
{
    if (e)
    {
// Update:  It is possible to get a loop like this a->b->c->a...
// so abort if it loops too much.
        local   float   loop;

        loop = 20;      // Should be more than enough.
        while (e.master)
        {
            if (e == e.master)  // Infinite loop if TRUE.
                return e;
            e = e.master;

            loop = loop - 1;
            if (loop < 1)
                return e;
        }
    }

    return e;
};

//------------------------------------------------------------------------//
//  Checks if the patriarch of an entity is a player.  If so, return the
//  player.  If not, return the world.
//------------------------------------------------------------------------//
entity(entity e) PlayerIsKing =
{
    // Assumes players have no master (they'd better NOT).
    e = Patriarch (e);
    if (e.classname == "player")
        return e;
    return world;
};

//------------------------------------------------------------------------//
//  Checks if the first entity passed is an ancestor of the second entity.
//------------------------------------------------------------------------//
float(entity one, entity two) FirstIsBoss =
{
    if (two)
        while (two.master)
        {
            if (two.master == one)
                return TRUE;    // Found it!
            if (two.master == two)  // Infinite loop if TRUE.
                return FALSE;   // Didn't find one, so it is FALSE.
            two = two.master;
        }
    return FALSE;
};


//==========================================================================
//  Universal

//------------------------------------------------------------------------//
//  This checks if both entities are teammates.
//------------------------------------------------------------------------//
float(entity targ, entity attacker) Team_Match =
{
    // NOTE:  It is possible to kill teammate by telefrag even in damage
    //  avoidance mode.  Therefore, always check if teamplay in on.
    //  0 = no teams, 1 = friendly fire OFF, 2 = friendly fire ON
    if (teamplay)
        if (targ.team > 0)
            if (targ.team == attacker.team)
                return TRUE;

    // When in doubt, assume the other player is an enemy.
    return FALSE;
};


//------------------------------------------------------------------------//
//  This advances to the next entries on all the alignment hitlists.
//------------------------------------------------------------------------//
void() Align_Next =
{
    local   entity  old;

// Blacklist
    old = blacky;
    blacky = find (blacky, alignment, EVIL);
    // If no new hit was found and we had an old hit, try again.
    if (!blacky)
        if (old)
            blacky = find (blacky, alignment, EVIL);
// Whitelist
    old = whitey;
    whitey = find (whitey, alignment, GOOD);
    if (!whitey)
        if (old)
            whitey = find (whitey, alignment, GOOD);
    // Skip clients because they are found via checkclient.
    // Clients are placed in good hitlist so good NPCs don't attack them.
    while (whitey.flags & FL_CLIENT)
        whitey = find (whitey, alignment, GOOD);
};

//------------------------------------------------------------------------//
//  This removes a marked entity from an alignment hitlist.
//------------------------------------------------------------------------//
void(entity ent) Align_Remove =
{
    if (ent)
    {   // Wipe out current alignment.
// FIXME:  Update hitlists like this?!
        if (ent.alignment == GOOD)
            whitey = find (ent, alignment, GOOD);
        else if (ent.alignment == EVIL)
            blacky = find (ent, alignment, EVIL);
        ent.alignment = world.null_string;
    }
};

//------------------------------------------------------------------------//
//  This adds an unmarked entity to an alignment hitlist.
//------------------------------------------------------------------------//
void(entity ent, float good) Align_Add =
{
    if (ent)
    {   // Overwrite current alignment with new alignment.
        if (good)
            ent.alignment   = GOOD;
        else    // It's evil!
            ent.alignment   = EVIL;
    }
};

//------------------------------------------------------------------------//
//  This checks if the alignment of two entities match.
//  This is NOT the same as a team check!
//------------------------------------------------------------------------//
float(entity e1, entity e2) Align_Match =
{
    if (e1 == e2)
        return TRUE;

    if (deathmatch)
    {   // Alignment means little between players in deathmatch.
        local   entity  p1, p2;

        p1 = PlayerIsKing (e1);
        p2 = PlayerIsKing (e2);

        if (p1)
            if (p2)
            {
                if (p1 == p2)
                    return TRUE;
                return Team_Match (p1, p2);
            }
    }

//---- Single or Coop ----
    if (e1.alignment)
        return (e1.alignment == e2.alignment);
    return FALSE;
};


//==========================================================================
//  Allies

//------------------------------------------------------------------------//
//  This checks if both players are on the same side.  This is not the
//  same as a team check since this always passes in sp/coop whereas
//  the team-only check would likely fail.
//
//  Again, assumes both entities are players.
//------------------------------------------------------------------------//
float(entity targ, entity attacker) Ally_PvP =
{
    if (!deathmatch)
        return TRUE;    // Players are allies in non-deathmatch play.
    if (targ == attacker)
        return TRUE;    // Attacker is an ally to himself.
    if (Team_Match (targ, attacker))
        return TRUE;    // Teammates are allies.

    // When in doubt, assume the other player is an enemy.
    return FALSE;
};

//------------------------------------------------------------------------//
//  Checks if entity is hostile to players.
//------------------------------------------------------------------------//
float(entity ent) MadAtPlayer =
{
    if (ent)    // World has no enemies.
    {
        if (ent.enemy.classname == "player")
            return TRUE;
        if (ent.oldenemy.classname == "player")
            return TRUE;
    }
    return FALSE;
};

//------------------------------------------------------------------------//
//  Checks if two entities are allies, or at least non-hostile to each
//  other.  This is useful for smart weapons, such as Chain Lightning
//  or MIRVs, that can select and pick off enemies only with precision,
//  even if there are allies nearby.
//------------------------------------------------------------------------//
float(entity targ, entity attacker) Ally_Check =
{
    local   entity  pat;

    if (targ == attacker)
        return TRUE;    // Always ally to self.

//
//  If either side is a player, the other side is an ally only if it is
//  another player or a peaceful, non-evil monster.  When in doubt, assume
//  the non-player target to be an enemy.
//

    // Check players first since that is where much of the messy code is.
    // For player vs. player (PvP) or player vs. monster (PvM).
    if (targ.classname == "player")
    {
        if (deathmatch)
        {
            if (attacker.classname == "player")
                return Ally_PvP (targ, attacker);
            if (attacker.flags & FL_MONSTER)
            {
                if (targ == attacker.enemy)
                    return FALSE;
                if (targ == attacker.oldenemy)
                    return FALSE;
                pat = Patriarch (attacker);
                if (pat.classname == "player")
                    return Ally_PvP (targ, pat);
                return Align_Match (targ, attacker);
            }
        }
        else
        {
            if (attacker.classname == "player")
                return TRUE;
            if (attacker.flags & FL_MONSTER)
            {
                if (attacker.alignment == EVIL)     // != GOOD
                    return FALSE;   // Fight all that is evil!
                if (MadAtPlayer (attacker))
                    return FALSE;   // Defend against those hostile to players.
                return TRUE;
            }
        }
        return FALSE;   // Third party?  Treat as enemy.
    }
    if (attacker.classname == "player")
    {
        // No need to check if target here is a player since that is
        // done above.
        if (targ.flags & FL_MONSTER)
        {
            if (deathmatch)
            {
                if (attacker == targ.enemy)
                    return FALSE;
                if (attacker == targ.oldenemy)
                    return FALSE;
                pat = Patriarch (targ);
                if (pat.classname == "player")
                    return Ally_PvP (pat, attacker);
                return Align_Match (targ, attacker);
            }
            else
            {
                if (targ.alignment == EVIL)     // != GOOD
                    return FALSE;   // Fight all that is evil!
                if (MadAtPlayer (targ))
                    return FALSE;   // Defend against those hostile to players.
                return TRUE;
            }
        }
        return FALSE;
    }

//
//  If both sides are monsters, they are not allies if any of the following
//  apply:
//
//  1) One side is a direct enemy of the other.
//  2) One side is player-controlled and loyal to players, and the other
//      side is hostile to other players.
//  3) Both sides' alignments are opposed (i.e., Good vs. Evil).
//

    if (targ.flags & FL_MONSTER)
        if (attacker.flags & FL_MONSTER)
    {
        // Not allies if one side is an enemy of the other.
        if (attacker == targ.enemy)
            return FALSE;
        if (attacker == targ.oldenemy)
            return FALSE;
        if (targ == attacker.enemy)
            return FALSE;
        if (targ == attacker.oldenemy)
            return FALSE;

        if (deathmatch)
        {
            targ = PlayerIsKing (targ);
            if (targ)
            {   attacker = PlayerIsKing (attacker);
                if (attacker)
                    return Ally_PvP (targ, attacker);   // Check PvP loyalties.
            }
            return Align_Match (targ, attacker);
        }

        // If one side is controlled by a player, check if the other side
        // is hostile to other players (AND players only)!  If so, monsters
        // are enemies.
        //
        // Do NOT negate alliances if monster is not hostile at a player,
        // even if one side is hostile to a player controlled monster.
        // If we checked solely on player loyalties, every player-controlled
        // monster will fight each other until one is left standing.
        //
        if (PlayerIsKing (targ))
            if (!MadAtPlayer (targ))
                if (MadAtPlayer (attacker))
                    return FALSE;   // Hostile to players, so no allies.
        if (PlayerIsKing (attacker))
            if (!MadAtPlayer (attacker))
                if (MadAtPlayer (targ))
                    return FALSE;   // Hostile to players, so no allies.

        // Compare alignments of both monsters.
        if (attacker.alignment)
            return (attacker.alignment == targ.alignment);
        return FALSE;
    }

    // Not allies if either side is the world or other non-creature hazard.
    return FALSE;
};


//===========================================================================
//
//  ENEMIES
//  (Formerly in enemy.qc)
//
//===========================================================================

//------------------------------------------------------------------------//
//  Checks if attacker qualifies as 'stupid' when attacking friendly NPCs.
//------------------------------------------------------------------------//
float(entity attacker) Enemy_Player =
{
    if (attacker.classname == "player")
        return TRUE;

    return FALSE;
};


//------------------------------------------------------------------------//
//  Support function that checks if target should turn on attacker.
//------------------------------------------------------------------------//
float(entity targ, entity attacker) Enemy_Monster =
{
    // Summoned minions are never allowed to fight their master.
    if (targ.spawned)   // If created, assume on behalf of master.
        if (FirstIsBoss (attacker, targ))
            return FALSE;   // Don't turn on master (or any ancestor).
// DISABLED -- Let parents smash children if they get in the way.
//    if (FirstIsBoss (targ, attacker))
//        return FALSE;   // Don't attack its pawns.

    // Check if target should fight back.
    if (attacker.flags & FL_MONSTER)
    {
        // Always defend against deliberate attack.
        if (targ == attacker.enemy)
            return TRUE;
        if (targ == attacker.oldenemy)
            return TRUE;
    }

    // Check if the monster is a good guy.
    if (targ.alignment == GOOD)
    {
        if (attacker.alignment == EVIL)     // != GOOD
            return TRUE;    // Fight evil!

        if (deathmatch)
        {
            local   entity  boss_a, boss_t;

            boss_t = PlayerIsKing (targ);
            if (boss_t)
            {
                boss_a = PlayerIsKing (attacker);
                if (boss_a)
                    return !Ally_PvP (boss_t, boss_a);
            }
        }

    // Check for possible infighting.  Do this only with unstable monsters,
    // such as grunts or Armagon, because it is too easy for the player to
    // hit friends with burn, poison, proxy bombs, or other delayed attacks.
        if (targ.ryuflags & RYU_INSANE)
        {
            // Special case if player is the attacker.
            if (Enemy_Player (attacker))
            {   // Allow three seconds after combat before condemning player
                // in case of late friendly fire.  If hurt after the grace
                // period, assume evil player guilty of attempted murder.
                // This is a faulty assumption with fire and Hip weapons.
// FIXME:  show_hostile not always updated per frame like in standard Quake.
                if (!targ.enemy)
                    return ((targ.show_hostile + 3) < time);

                // Don't ignore extra bad players.
                if (PlayerIsKing (targ.enemy))
                    return TRUE;
                return FALSE;
            }
        }
        else
        {   // If attacker is mad at the target's master, always fight back
            // in an effort to protect the master.  Note:  unstable monsters
            // do not use this because their loyalties are... well, unstable.
            // NOTE:  Don't do this with all parents -- takes too much time.
            if (targ.master)
                if (targ.enemy != targ.master)
                {
                    // Assumes 'targ != attacker' is true.  If not, well...
                    // 'Enemy_Check' should have returned FALSE long ago.
                    if (attacker.enemy == targ.master)
                        return TRUE;
                    if (attacker.oldenemy == targ.master)
                        return TRUE;
                }
        }

        // Good guys normally do not attack other non-evil guys.
        return FALSE;
    }

// The rest of the checks are for defending non-good guys.

    // All players and good NPCs are the enemy.
    if (Align_Match (targ, attacker))
    {   // Parties are both evil -- will they get along?
        if (IsGhost (attacker))
            if (!(targ.xfl & XFL_GHOST_BANE))
                return FALSE;   // Can't hurt ghosts -- leave them alone.

        // Those 'insane in the brain' attack anything.
        // Note:  Grunts and Armagon should have the insane flag.
        if (!(targ.ryuflags & RYU_INSANE))
        {   // Not a homicidal maniac, so check if targ should retaliate.
            if (targ.ryuflags & (RYU_ALERT|RYU_ANGRY) == RYU_ALERT)
                return FALSE;   // Not distracted by infighting.
            if (targ.family & attacker.family)
                return FALSE;   // Ignore relatives regardless of classname.
            if (targ.classname == attacker.classname)
                return FALSE;   // Standard -- Same species don't infight.
            // Update:  Summoned monsters from same parent don't infight.
            if (targ.master)
                if (targ.master == attacker.master)
                    if (attacker.master.enemy != attacker)
                        return FALSE;
            // Update 4/11/09:  Boss usually don't infight other bosses.
            if (targ.xfl & XFL_BOSS)
                if (attacker.xfl & XFL_BOSS)
                    return FALSE;
        }
    }
    return TRUE;    // Fight, fight, FIGHT!!!
};

//------------------------------------------------------------------------//
//  Support function to check if target should fight back at the attacker.
//
//  Note:  Similar to Quake2's 'M_ReactToDamage'.
//------------------------------------------------------------------------//
float(entity targ, entity attacker) Enemy_Check =
{
// Check if fighting back is even possible.
    if (targ == attacker)
        return FALSE;   // Don't attack itself.
    if (attacker.health <= 0)
        return FALSE;   // Attacker is already dead.
    // NOTE:  Don't disqualify if enemy is the attacker because of new rules.

    if (!(attacker.flags & FLx_CREATURE))
    {   // Update 7/9/09:  Chthon has the boss flag.
        if (!(attacker.xfl & XFL_BOSS))
            return FALSE;   // Attacker is either a superboss or not a creature.
    }
    if (attacker.xfl & XFL_IGNORE)
        return FALSE;   // Don't get mad at this thing.  Traps that are
                        //  monsters, such as auto turrets, should have this.
    if (attacker.xfl & XFL_BOSS)
        if (!(targ.xfl & XFL_BOSS))
            if (Align_Match (targ, attacker))
                return FALSE;   // Mooks aren't allowed to strike the boss.
    if (!Enemy_Monster (targ, attacker))
        return FALSE;   // Allies, or at least unable to hurt attacker.

// Fight back!
    if (targ.master == attacker)
        targ.master = world;    // Break bond if mad at its master.
    return TRUE;
};


//==========================================================================
//  Enemy Selection

// This resets an entity's threshold.
void() Threshold_Reset =
{
// In Doom, all monsters except the arch-vile have three second threshold.
// Arch-vile (and the shambler version, Sha'Vile) has no threshold.
    if (self.classname == "monster_cyberdemon")
        self.threshold = time + 3;
    else if ((self.classname == "monster_archvile") || (self.classname == "monster_shamvile"))
        self.threshold = 0;
    else
        self.threshold = time + 1;

// Note:  Normal Quake had NO threshold whatsoever... not a good idea
//  because multiple attackers will destroy lone defending monsters
//  too easily.

// Note#2:  Diving into the Chapters source reveals that most monsters
//  have a five second threshold.  The gug has seven seconds and the
//  vermis has ten seconds.  I am still using the times I first used
//  in Indian Summer because too long a threshold can be exploited too.
};

//------------------------------------------------------------------------//
//  This changes the monster's enemy to the entity attacking the monster.
//  If the original enemy was opposed by the target, it will be remembered
//  as a secondary target.
//------------------------------------------------------------------------//
void(entity attacker) NewEnemy =
{
    if (self.enemy != attacker)
    {   // New target to defend against.
        local   float   smart;  // TRUE = use stay/doom to select targets.
        local   float   stay;   // TRUE = keep enemy, FALSE = switch targets.
        local   float   doom;

        smart = TRUE;   // Was 'self.ryuflags & RYU_ALERT;'
        stay = FALSE;
        if (self.enemy)
        {   // Already fighting someone.  Decide whether or not to switch.
            doom = TRUE;
            // Update 1/31/10:  Obey threshold only if current target is alive.
            if ( ((self.threshold > time) && (self.enemy.health > 0))
            || (self.curse_type == CURSE_CONFUSE) )
                stay = TRUE;    // Too soon to switch targets.
            // FIXME:  Could check for something like .attack_finished
            //  or .show_hostile.
            if (self.th_melee)
            {
                if (range(self.enemy) == RANGE_MELEE)
                {   // Assume target was locked in melee.
//                    bprint ("melee: ");
                    if (range(attacker) != RANGE_MELEE)
                        doom = FALSE;   // Interrupt melee attack.
                }
            }
        }
        else
        {   // Wasn't mad at anyone before now.
            doom = FALSE;
        }

    // Decision time.
        if (stay && smart)
        {   // Don't change targets.  Remember attacker if applicable.
//            bprint ("old\n");
            if (!Align_Match (self.enemy, self))
                self.oldenemy = attacker;
        }
        else
        {   // Attack the new target, and remember old enemy if applicable.
//            bprint ("new: ");
            Threshold_Reset ();
            if (!Align_Match (self.enemy, self))
                self.oldenemy = self.enemy;
            self.enemy = attacker;
            if (doom && smart)
            {   // Doom-style target switch.
//                bprint ("Doom\n");
                SwapTarget ();      // Discreetly change enemy, like in Doom.
            }
            else
            {   // Standard Quake-style.
//                bprint ("Quake\n");
                FoundTarget ();     // Wake up to new enemy, Quake standard.
            }
        }
    }
    else
    {   // The attacker is already the monster's enemy.
        // Reset threshold so it will keep attacking the enemy
        // even if struck by another attacker soon after.
//        bprint ("reset\n");
        Threshold_Reset ();
    }
};


//===========================/  END OF FILE  /===========================//

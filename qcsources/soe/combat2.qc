//==========================================================================
//  combat2.qc -- by Patrick Martin             Last updated:  5-1-2001
//--------------------------------------------------------------------------
//  This file contains code that is used by the modified 'combat.qc'.
//==========================================================================

//-----------------//
//  NEW CONSTANTS  //
//-----------------//
// None now.

//--------------------//
//  NEW EDICT FIELDS  //
//--------------------//
.float  threshold;      // Time when monster can fight back new targets.
.float  thresh_time;    // Time monster will not change targets when hit.


//==========================================================================
//  AI.QC extras

//----------------------------------------------------/ New Code /--------//
//  This is similar to the function 'FoundTarget' except the monster
//  does not head straight for the opponent because it is heading for
//  a more urgent goal (i.e., water while burning).
//------------------------------------------------------------------------//
void() PM_FoundSecondary =
{
    if (self.oldenemy.classname == "player")
    {
        // Let other monsters see this monster for a while.
        sight_entity = self;
        sight_entity_time = time;
    }
	
    self.show_hostile = time + 1;           // Wake up other monsters.
    SightSound ();

    // Watered down Hunt_Target.
    self.think = self.th_run;
    self.nextthink = time + 0.1;
    SUB_AttackFinished (1); // wait a while before first attack
};


//==========================================================================
//  COMBAT.QC extras

//----------------------------------------------------/ New Code /--------//
//  This checks if an entity is a player.
//
//  NOTE:  This check is used only in the 'combat*.qc' files.
//------------------------------------------------------------------------//
float(entity ent) PM_EntIsPlayer =
{
    if (ent.classname == "player")
        return TRUE;
    if (ent.classname == "camera")  // Player becomes camera in cutscene.
        return TRUE;

    return FALSE;
};

//----------------------------------------------------/ New Code /--------//
//  This checks if an entity is a good guy.  Players and monsters that
//  fight for players are considered good.  Anything else is considered
//  evil.
//
//  FIXME:  Instead of classname/flags comparison, the entities should
//          use a single variable, much like 'team'.
//
//  NOTE:  This does not check if a good guy attacks other good guys.
//         If the entity check is a good guy, it stays good even if it
//         attacks others.
//------------------------------------------------------------------------//
float(entity ent) PM_EntIsGood =
{
    // Players are the good guys.
    if (PM_EntIsPlayer (ent))
        return TRUE;

    if (ent.flags & FL_MONSTER)
    {
        // Monsters controlled by players are good guys also.
        if (PM_EntIsPlayer (ent.master))
            return TRUE;

        // Zerstorer/cutscene support -- treat actors as players.
        if (ent.classname == "actor")
            return TRUE;
    }

    // All other creatures are evil!
    return FALSE;
};

//----------------------------------------------------/ New Code /--------//
//  Checks if monster should count as a kill if killed.
//------------------------------------------------------------------------//
float(entity ent) PM_CountMonster =
{
    // Good guys should not count.
    if (PM_EntIsGood (ent))
        return FALSE;

	//SoE: If the dragon is a boss monster, then it bloody well does!
	if (ent.targetname == "DMSP_boss")
		return TRUE;
	if (ent.master.targetname == "DMSP_boss")
		return TRUE;

    // Monster should count only if it was not created by an item or
    // another monster.
    return (ent.master == world);
};

//----------------------------------------------------/ New Code /--------//
//  This checks if a player entity is an enemy of an attacking player.
//  This is used for player vs. player ONLY.
//------------------------------------------------------------------------//
float(entity victim, entity attacker) PM_PlayerOnSameTeam =
{
    // Players are allies in non-deathmatch play -- don't attack them.
    if (!deathmatch)
        return TRUE;

    // Attacker is an ally to himself.
    if (victim == attacker)
        return TRUE;

    // Without teamplay, any other player is an enemy.
    if (!teamplay)
        return FALSE;

    // Teammates are allies.
    if (victim.team > 0)
        return (victim.team == attacker.team);

    // When in doubt, assume the other player is an enemy.
    return FALSE;
};

//----------------------------------------------------/ New Code /--------//
//  This determines whether the monster and attacker are allies.
//  If so, TRUE is returned.  Otherwise, FALSE is returned.
//------------------------------------------------------------------------//
float(entity victim, entity attacker) PM_MonsterAlly =
{
    // Any monster will retaliate against deliberate attacks from anyone.
    if (victim == attacker.enemy)
        if (attacker.flags & FL_MONSTER)
            return FALSE;

    // Check if the monster is a good guy.
    if (PM_EntIsGood (victim))
    {
        // No cutscenes in DM, so no need to use 'EntIsPlayer' check.
        if (deathmatch)
            if (victim.master.classname == "player")
            {
                // Monster is controlled by player.  Check teams.

                // Attacking player?
                if (attacker.classname == "player")
                    return PM_PlayerOnSameTeam (victim.master, attacker);

                // Player controlled monster?
                if (attacker.master.classname == "player")
                    return PM_PlayerOnSameTeam (victim.master, attacker.master);
            }

        // Good guys normally do not attack other good guys.
        return PM_EntIsGood (attacker);
    }

    // The rest of the checks are for defending bad guys.

    // Good guys (players or monsters) are the ultimate enemy.
    if (PM_EntIsGood (attacker))
        return FALSE;

    // Standard.  Grunts attack anything.
    if (victim.classname == "monster_army")
        return FALSE;

    // Dragons require special coding.
    if (victim.classname == "monster_dragon")
    {
        if (victim.state < IQ_GENIUS)
        {
            if (victim.classname != attacker.classname)
                return FALSE;   // Different monster species.
            if (victim.skin != attacker.skin)
                return FALSE;   // Both dragons, but of different types.
            if (victim.state == IQ_LOW)
                return FALSE;   // Always get angry if really stupid.
        }
        return TRUE;    // Dragon will not fight.
    }

    // Evil monsters of different species do not like each other.
    if (victim.classname != attacker.classname)
        return FALSE;

    // The attack was an accident so don't turn on 'attacker'.
    return TRUE;
};

//----------------------------------------------------/ New Code /--------//
//  This determines whether the monster should get mad at its attacker.
//  FALSE is returned if:
//  1)  Attacker is itself.
//  2)  Attacker is already dead.
//  3)  Victim is not a slidebox -- (e.g., nightshade, turrets).
//  4)  Attacker is not a slidebox -- see above.
//  5)  Attacker is Chthon.
//  6)  Attacker is an ally.
//------------------------------------------------------------------------//
float(entity victim, entity attacker) PM_GetMad =
{
    // Monster cannot attack itself.  (And why would it?)
    if (victim == attacker)
        return FALSE;

    // The attacker is already dead so do nothing.
    if (attacker.health <= 0)
        return FALSE;

    // If either side is not a living thing (e.g., no ghosts or bsp-like
    // things such as barrels or turrets), do not attack.
    if (victim.solid != SOLID_SLIDEBOX)
        return FALSE;
    if (attacker.solid != SOLID_SLIDEBOX)
        return FALSE;

    // Chthon is impervious to normal attacks, so don't attack him.
    if (attacker.classname == "monster_boss")
        return FALSE;

    // A monster may or may not ignore 'friendly-fire'.
    if (PM_MonsterAlly (victim, attacker))
        return FALSE;

    // Can turn on attacker now.
    return TRUE;
};

//----------------------------------------------------/ New Code /--------//
//  This resets an entity's threshold.
//------------------------------------------------------------------------//
void(entity ent) PM_ResetThreshold =
{
    if (ent.thresh_time > 0)
        ent.threshold = time + ent.thresh_time;
    else
        ent.threshold = 0;
};

//----------------------------------------------------/ New Code /--------//
//  This initializes the entity's times of threshold.
//------------------------------------------------------------------------//
void(entity ent, float secs) PM_InitThreshold =
{
    self.threshold   = 0;
    self.thresh_time = secs;
};

//----------------------------------------------------/ New Code /--------//
//  This checks if the monster should ignore the attacker in favor of
//  the current target.  If so, TRUE is returned.
//------------------------------------------------------------------------//
float(entity attacker) PM_IgnoreAttacker =
{
    // No current enemy, so fight the attacker.
    if (!self.enemy)
        return FALSE;

    // Threshold has been reached, so fight back!
    if (self.threshold < time)
        return FALSE;

//
// NOTE:
//    There are other things that can be done to check if the monster
//    should fight back.  Examples would be if the attacker is visible
//    or not; or if the defender is a bad guy, enemy is a bad guy, but
//    attacker is a good guy, and the defender has enough smarts to
//    attack the good guy back.  However, each of these can be exploited
//    by a clever player in some situations, so it may not be a good
//    idea to implement them.  So far, the threshold method from Doom
//    seems to work best.
//

    // Ignore attacker, continue assault on current enemy.
    return TRUE;
};

//----------------------------------------------------/ New Code /--------//
//  This changes the monster's enemy to another entity.
//  If the attacker is a player or the monster is a good guy,
//  the enemy or attacker will be remembered as a secondary target.
//------------------------------------------------------------------------//
void(entity attacker) PM_NewEnemy =
{
    if (self.enemy.classname == "watergoal")
    {
        // Monster is burning and looking for water.
        // Always reset threshold and attack in this case.
        PM_ResetThreshold (self);
        if (self.oldenemy != attacker)
        {
            // Will fight the attacker once the fire is out.
            self.oldenemy = attacker;
            PM_FoundSecondary ();
        }
    }
    else if (self.enemy == attacker)
    {
        // The attacker is already the monster's enemy.
        // Reset threshold so it will keep attacking the enemy
        // even if struck by another attacker soon after.
        PM_ResetThreshold (self);
    }
    else if (PM_IgnoreAttacker (attacker))
    {
        // Don't change targets.  Remember attacker if applicable.
        if (PM_EntIsPlayer (self.enemy))
            self.oldenemy = attacker;
        else if (PM_EntIsGood (self))
            self.oldenemy = attacker;
    }
    else
    {
        // Defend!  Remember enemy if applicable.
        PM_ResetThreshold (self);
        if (PM_EntIsPlayer (self.enemy))
            self.oldenemy = self.enemy;
        else if (PM_EntIsGood (self))
            self.oldenemy = self.enemy;
        self.enemy = attacker;
        FoundTarget ();
    }
};

//----------------------------------------------------/ New Code /--------//
//  This checks if an entity is resistant to radius damage.
//------------------------------------------------------------------------//
float(entity ent) PM_BlastResistant =
{
    // The following monster types are resistant to explosions:
    if (ent.classname == "monster_shambler")    return TRUE;
    if (ent.classname == "monster_cyberdemon")  return TRUE;
    if (ent.classname == "monster_dragon")
    {
        if (ent.skin == SKIN_GOLD)  return TRUE;
    }

    return FALSE;
};


//===========================/  END OF FILE  /===========================//

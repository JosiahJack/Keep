//==========================================================================
//  petai.qc -- by Patrick Martin               Last updated:  5-5-2001
//--------------------------------------------------------------------------
//  This file contains code that dictates the AI of pet dragons.
//  The code is an extension of 'ryuai.qc' that is used exclusively
//  for dragon familiars.
//==========================================================================


//==========================================================================
//  Pet Ally Checks

//----------------------------------------------------/ New Code /--------//
//  This checks if the dragon turned evil.
//------------------------------------------------------------------------//
float(entity pet) PM_PetGoneBad =
{
    // If master lost control, treat dragon as a bad guy now.
    if (pet.enemy == pet.master)
        return TRUE;
    if (pet.oldenemy == pet.master)
        return TRUE;

    // Dragon remains loyal.
    return FALSE;
};

//----------------------------------------------------/ New Code /--------//
//  This determines whether the target and attacker are allies.
//  If so, TRUE is returned.  Otherwise, FALSE is returned.
//------------------------------------------------------------------------//
float(entity victim, entity attacker) PM_IsPetAlly =
{
    // Pet should never oppose itself.
    if (victim == attacker)
        return TRUE;

    // Not allies if victim is the target.
    if (victim == attacker.enemy)
        return FALSE;

    // Players are usually allies.
    if (victim.classname == "player")
    {
        // Check if player is on the same team.  Should always be TRUE
        // in sp/coop or if victim is the pet's master.
        return PM_PlayerOnSameTeam (victim, attacker.master);
    }

    // Check monsters.
    if (victim.flags & FL_MONSTER)
    {
        // Not allies if attacked by victim.
        if (victim.enemy == attacker)
            return FALSE;

        // Let familiars attack anyone that opposes their master.
        if (attacker.master)
            if (victim.enemy == attacker.master)
                return FALSE;

        // Do not attack its master.  This probably will not happen
        // since pets are used only by players.
        if (victim == attacker.master)
            return TRUE;

        // Always attack bad guys.
        if (!PM_EntIsGood (victim))
            return FALSE;

        // Monster is normally a good guy.

        // Treat monsters owned by a player much like another player.
        if (victim.master.classname == "player")
        {
            return (PM_PlayerOnSameTeam (victim.master, attacker.master));
        }

        return TRUE;
    }

    // NOTE:  If player's classname is not "player", the function could
    //   get this far and the dragon will turn on the player, even if
    //   he owns the dragon... if not for the check below.

    // Final safeguard for owner.
    if (victim == self.master)
        return TRUE;

    // Not an ally.
    return FALSE;
};

//----------------------------------------------------/ New Code /--------//
//  This checks if a good guy is in the line of fire, which is the
//  vector from the attacker to the victim.  If so, TRUE is returned.
//------------------------------------------------------------------------//
float(entity victim, entity attacker) PM_PetAllyInLine =
{
    local   entity  ignore;
    local   vector  dir;
    local   vector  org;
    local   vector  end;

    dir = normalize (victim.origin - attacker.origin);
    org = attacker.origin;
    end = org + dir*2048;   // This should work; 8000+ is a bit extreme.
    ignore = attacker;

    while (ignore)
    {
        traceline (org, end, FALSE, ignore);
        if (trace_fraction < 1)
        {
            org = trace_endpos;
            ignore = trace_ent;
            if (ignore)
            {
                if (ignore.solid == SOLID_BSP)
                    ignore = world;
                else if (PM_IsPetAlly (ignore, attacker))
                    return TRUE;    // Ally in line of fire -- don't shoot!
            }
        }
        else
            ignore = world;
    }

    // All clear.
    return FALSE;
};

//----------------------------------------------------/ New Code /--------//
//  This checks if a good guy is too close to the dragon's intended
//  target.
//------------------------------------------------------------------------//
float(entity victim, entity attacker) PM_PetAllyTooClose =
{
    local   entity  head;
    local   vector  spot;
    local   float   radius;

    // Anticipate where the shot will hit.
    traceline (attacker.origin, victim.origin, FALSE, attacker);
    if ((trace_fraction < 1) && (trace_ent == victim))
        spot = trace_endpos;
    else
        spot = victim.origin;

    // Find the distance between that spot and the victim origin.
    radius = vlen (spot - victim.origin);

    // Add that distance to the default radius.  Default radius should
    // be 80.  Dragons with explosive shots (i.e., red and gold) should
    // have a radius of at least 40 units greater than the blast radius.
    if (attacker.skin == SKIN_RED)
        radius = radius + 120;
    else if (attacker.skin == SKIN_GOLD)
        radius = radius + 160;
    else
        radius = radius + 80;

    // Get list of entities close to target.
    // Don't shoot at target if a good guy is too close to it.
    head = findradius (victim.origin, radius);
    while (head)
    {
        if ((head != attacker) && (head != victim))
        {
            traceline(spot, head.origin, TRUE, attacker);
            if (trace_fraction == 1)
                if (PM_IsPetAlly (head, attacker))
                    return TRUE;    // Ally too close.
        }
        head = head.chain;
    }

    // All clear -- we hope...
    return FALSE;
};

//----------------------------------------------------/ New Code /--------//
//  This checks if a good guy is in front of the dragon within a
//  specified angle.  If so, TRUE is returned.
//
//  NOTE:  This function may cause slowdown in older computers,
//         such as those available when Quake was first released.
//         Therefore, use it only if you really need it.
//------------------------------------------------------------------------//
float(entity victim, entity attacker, float cone) PM_PetAllyInCone =
{
    local   entity  head;
    local   vector  dir;
    local   vector  vec;
    local   float   dot;

    dir = normalize (victim.origin - attacker.origin);
    head = findradius (attacker.origin, 2048);
    while (head)
    {
        if (head != attacker)
        {
            traceline (attacker.origin, head.origin, TRUE, attacker);
            if (trace_fraction == 1)
            {
                vec = normalize (head.origin - attacker.origin);
                dot = vec * dir;
                if (dot > cone)
                    if (PM_IsPetAlly (head, attacker))
                        return TRUE;    // Ally within the cone.
            }
        }
        head = head.chain;
    }

    // All clear.
    return FALSE;
};

//----------------------------------------------------/ New Code /--------//
//  This checks if a good guy is in the way of the dragon's shot.
//------------------------------------------------------------------------//
float() PM_PetAllyInWay =
{
    if (PM_PetGoneBad (self))
        return FALSE;   // No allies if evil.

    if (PM_PetAllyInLine (self.enemy, self))
        return TRUE;
    if (PM_PetAllyTooClose (self.enemy, self))
        return TRUE;

    // If gold dragon, don't shoot if good guy is in front of the dragon.
    // Their shots cause lethal results if it hits the wrong target.
    if (self.skin == SKIN_GOLD)
        if (PM_PetAllyInCone (self.enemy, self, 0.3))
            return TRUE;

    // All clear -- we hope...
    return FALSE;
};


//==========================================================================
//  Pet Combat

//----------------------------------------------------/ New Code /--------//
//  This returns the power level of a pet dragon.  It also checks for
//  Shiva and returns that level if activated.
//------------------------------------------------------------------------//
float() pet_level =
{
    local   float   level;

    level = PM_TruePetLevel (self);
    if (PM_ImmortalDragon (self))
        level = 4;

    return level;
};

//----------------------------------------------------/ New Code /--------//
//  Check if an attack can be made.
//------------------------------------------------------------------------//
float() PM_PetCheckAttack =
{
    local   vector  spot1, spot2;
    local   entity  targ;
    local   float   chance;
    local   float   pause;

    targ = self.enemy;
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;

    // FIXME:  Add wall check here if necessary.  Already done in pet_run.

    // If dragon is not stupid, check if attack is blocked by creature.
    // If so, flag it so dragon may try to move around it vertically.
    traceline (spot1, spot2, FALSE, self);
    if (trace_ent != targ)
    {
        targ = trace_ent;
        if (targ)
            if (targ.solid == SOLID_SLIDEBOX)
                if (targ.health)
                    self.attack_state = AS_SLIDING;

        return FALSE;
    }

    // If target is reachable within melee range, the dragon will attack
    // the target if the dragon has a melee attack.
    if (enemy_range == RANGE_MELEE)
        if (self.th_melee)
            if (CanDamage (targ, self))
            {
                self.attack_state = AS_MELEE;
                return TRUE;
            }

    // missile attack

    // Check if the dragon has a breath weapon.
    if (!self.th_missile)
    {
        self.attack_state = AS_STRAIGHT;
        return FALSE;
    }
		
    // Check if allowed to attack.
    if (time < self.attack_finished)
        return FALSE;
    if (PM_DragonNoShot (self))
        return FALSE;

    // Determine the chance that the dragon will use its breath weapon.
    chance = pet_level ();
    chance = PM_DragonChance (chance);

    // Don't fly too far away.
    if (!chance)
        self.attack_state = AS_STRAIGHT;

    // The dragon decides whether to attack or move on.
    if (random () < chance)
    {
        // Don't shoot if a good guy is too close to target.
        if (PM_PetAllyInWay ())
        {
            // Same as !chance.
            self.attack_state = AS_STRAIGHT;
            return FALSE;
        }

        // Fire away!
        self.th_missile ();
        pause = random() * 2 + 1;
        SUB_AttackFinished (pause);
        return TRUE;
    }

    // If the function made it this far, the dragon moves on.
    return FALSE;
};


//==========================================================================
//  Target Detection

//----------------------------------------------------/ New Code /--------//
//  This checks if the player is suspended from play because of a
//  cutscene in progress.  Cutscenes are used in several level packs
//  (e.g., mexx9) or mods (e.g., Zerstorer).
//------------------------------------------------------------------------//
float(entity client) PM_InCutscene =
{
    return (client.classname == "camera");
};

//----------------------------------------------------/ New Code /--------//
//  This checks if an enemy is very dangerous.
//------------------------------------------------------------------------//
float(entity ent) PM_PetEnemyNasty =
{
    // Players are a special case.
    if (ent.classname == "player")
    {
        // Players with the quad are truly dangerous.
        if (ent.items & IT_QUAD)
            return TRUE;

        // This isn't saying much since humans are more competent than AI...
        return FALSE;
    }

    // The following monsters are too dangerous to ignore.
    if (ent.classname == "monster_dragon")
        return TRUE;
    if (ent.classname == "monster_shambler")
        return TRUE;
    if (ent.classname == "monster_shalrath")
        return TRUE;

    if (ent.classname == "monster_cyberdemon")
        return TRUE;
    if (ent.classname == "monster_troglodyte")  // Zerstorer's Nemesant.
        return TRUE;

    // Target is not a great threat.
    return FALSE;
};

//----------------------------------------------------/ New Code /--------//
//  This checks if the target can be ignored, so dragon can attack
//  other more important targets.
//------------------------------------------------------------------------//
float(entity ent) PM_IgnorableTarget =
{
    // Non-solid targets cannot be harmed.  (e.g., downed zombies.)
    if (ent.solid == SOLID_NOT)
        return TRUE;

    // Might as well ignore unstoppable targets if there is something else.
    // NOTE:  This includes Zer's mega enforcer when his shields are on.
    if (PM_IsImmortal (ent))
        return TRUE;

    // Some enemies are too dangerous to ignore, so kill them immediately.
    if (PM_PetEnemyNasty (ent))
        return FALSE;

    if (ent.enemy)
    {
        // Do not anger a target that is attacking a bad guy.
        if (!PM_IsPetAlly (ent.enemy, self))
            return TRUE;

        // Don't ignore an attacker in melee, in case dragon gets pinned.
        if (ent.enemy == self)
            if (range (ent) == RANGE_MELEE)
                return FALSE;
    }

    // Let targets on fire burn to death.
    if (PM_IsBurning (ent))
        return TRUE;

    // No good reason to ignore, so keep fighting.
    return FALSE;
};

//----------------------------------------------------/ New Code /--------//
//  This checks if the entity is threatening its enemy.
//------------------------------------------------------------------------//
float(entity ent) PM_NoThreat =
{
    if (self.state < IQ_GENIUS)
        return FALSE;

    if (!ent.enemy)
        return TRUE;    // Idle.

    if (ent.enemy == self)
        return FALSE;   // Let dragon defend itself.

    if (PM_IsPetAlly (ent.enemy, self))
    {
        // If target is a good guy, help him if he is in trouble.
        if (PM_EntIsVisible (ent.enemy, ent, FALSE))
            return FALSE;   // Seen by enemy.
        if (PM_EntIsVisible (ent.enemy, self, FALSE))
            return FALSE;   // Seen by dragon; dragon seen by enemy.
    }

    return TRUE;
};

//----------------------------------------------------/ New Code /--------//
//  This checks if the dragon should attack the target.  If so, return
//  TRUE.  Otherwise, return FALSE.
//
//  NOTE:  This assumes the dragon is loyal to its master.
//------------------------------------------------------------------------//
float(entity ent, entity pet) PM_ValidTarget =
{
    // Pet dragon can attack only living creatures.
    if (ent.solid != SOLID_SLIDEBOX)
        return FALSE;
    if (ent.health <= 0)
        return FALSE;

    // Target is undetectable so do nothing.
    if (ent.flags & FL_NOTARGET)
        return FALSE;

    // Minor dragon familiars are fooled by invisibility.  Draco isn't.
    if (ent.items & IT_INVISIBILITY)
        if (pet.state < IQ_GENIUS)
            return FALSE;

    // Don't attack allies.  This should include itself too.
    if (PM_IsPetAlly (ent, pet))
        return FALSE;

    // Ignore unstoppable targets.
    // NOTE:  This includes Zer's mega enforcer when his shields are on.
    if (PM_IsImmortal (ent))
        return FALSE;

    // Entity is a target if it is a player or monster.
    if (ent.classname == "player")
        return TRUE;
    if (ent.flags & FL_MONSTER)
    {
        // Check if the dragon should really attack the monster.
        if (!deathmatch)
        {
            if (PM_NoThreat (ent))
            {
                // Target is not threatening any good guys (probably idle).
                // Player must see this target or the dragon won't attack
                // it.  This is done so the dragon doesn't fly off and
                // wake up things that can kill it.
                if (!PM_EntIsVisible (ent, pet.master, FALSE))
                    return FALSE;
            }
        }

        return TRUE;
    }

    return FALSE;
};

//----------------------------------------------------/ New Code /--------//
//  This checks if the target is visible to the dragon familiar.
//------------------------------------------------------------------------//
float(entity ent) PM_PetSeeTarget =
{
    local   float   r;

    r = range (ent);

    // Can't see targets that are too far away.
    if (r == RANGE_FAR)
        return FALSE;

    // Target must be visible.
    if (!visible (ent))
        return FALSE;

	if (r == RANGE_NEAR)
    {
        if (ent.show_hostile < time)
            if (!infront (ent))
                return FALSE;
    }
	else if (r == RANGE_MID)
    {
        if (!infront (ent))
            return FALSE;
    }

    // Target found!
    return TRUE;
};

//----------------------------------------------------/ New Code /--------//
//  This searches for targets surrounding the dragon.
//
//  To minimize slowdown, a relatively small radius is used.
//  As a result, the dragon is somewhat near-sighted.
//
//  NOTE:  Do not let familiars that turn evil use this.
//------------------------------------------------------------------------//
entity(entity ignore, float all) PM_PetDetectTarget =
{
    local   entity  head;

    head = findradius(self.origin, SIGHT_RADIUS);
    if (all)
    {
        // Look for all possible targets.
        while (head)
        {
            if (head != ignore)
            {
                traceline (self.origin, head.origin, TRUE, self);
                if (trace_fraction == 1)
                    if (PM_ValidTarget (head, self))
                        if (PM_PetSeeTarget (head))
                            return head;    // Got one!
            }
            head = head.chain;
        }
    }
    else
    {
        // Look for important targets only.
        while (head)
        {
            if (head != ignore)
                if (!PM_IgnorableTarget (head))
                {
                    traceline (self.origin, head.origin, TRUE, self);
                    if (trace_fraction == 1)
                        if (PM_ValidTarget (head, self))
                            if (PM_PetSeeTarget (head))
                                return head;    // Got one!
                }
            head = head.chain;
        }
    }

    // No one found.
    return head;
};

//----------------------------------------------------/ New Code /--------//
//  This checks if the dragon is allowed to fight bad guys.
//------------------------------------------------------------------------//
float(entity pet) PM_PetCanFight =
{
    // Don't initiate combat during a cutscene.
    if (PM_InCutscene (pet.master))
        return FALSE;

    // Dragon won't attack if pacifist or busy shooting.
    if (pet == pet.master.draco)
        if (pet.master.petflags & (PET_PACIFIST | PET_FORCED))
            return FALSE;

    // Dragon won't attack bad guys if unruly.
    if (PM_PetGoneBad (pet))
        return FALSE;

    // Look for bad guys.
    return TRUE;
};

//----------------------------------------------------/ New Code /--------//
//  This checks if the pet dragon will wake up when it finds a target.
//------------------------------------------------------------------------//
float(float all) PM_PetFindTarget =
{
    local   entity  head;

    // Dragon won't attack if pacifist or busy shooting.
    if (!PM_PetCanFight (self))
        return FALSE;

    // Look for targets to fight.  However, if dragon is looking for
    // water, ignore any target it finds for now.
    if (self.enemy.classname == "watergoal")
    {
        head = PM_PetDetectTarget (self.oldenemy, all);
        if (!head)
            return FALSE;   // No target found.
        self.oldenemy = head;
        PM_FoundSecondary ();
    }
    else
    {
        head = PM_PetDetectTarget (self.enemy, all);
        if (!head)
            return FALSE;   // No target found.
        self.enemy = head;
        FoundTarget ();
    }

    return TRUE;
};

//----------------------------------------------------/ New Code /--------//
//  This makes the dragon attack the target found.
//------------------------------------------------------------------------//
void(entity targ) PM_PetFoundTarget =
{
    // Enemy is found.
    // However, if dragon is looking for water, ignore opponent for now.
    if (self.enemy.classname == "watergoal")
    {
        self.oldenemy = targ;
        PM_FoundSecondary ();
    }
    else
    {
        self.enemy = targ;
        FoundTarget ();
    }
};


//==========================================================================
//  Pain Reaction

//----------------------------------------------------/ New Code /--------//
//  This checks if Draco's anger message should be displayed.
//------------------------------------------------------------------------//
float(entity pet) PM_ShowAngryMessage =
{
    // Show the angry message.
    return TRUE;
};

//----------------------------------------------------/ New Code /--------//
//  This makes the dragon disappear if attacked by the bloodcube.
//
//  NOTE:  Assumes dragon has a master.
//------------------------------------------------------------------------//
void(entity pet, entity cube) PM_PetCubeReact =
{
    if (pet == pet.master.draco)
    {
        if (cube.owner == pet.master)
            PM_DracoTalk (pet, "Sanguinoch and I don't mix -- I'm leaving!");
        else
            PM_DracoTalk (pet, "The Sanguinoch is killing me -- I must leave!");
    }

    // Leave and don't come back until the bloodcube goes away.
    local   float   standby;

    standby = (cube.radsuit_finished - time) + 3;
    PM_PetDisappear (pet, standby);
};

//----------------------------------------------------/ New Code /--------//
//  This does the normal pain reactions when hit by an attacker.
//
//  NOTE:  Assumes dragon has a master.
//------------------------------------------------------------------------//
void(entity pet, entity attacker) PM_PetPainReact =
{
    // Do normal reactions for familiars.
    if (pet == pet.master.draco)
    {
        if (!(pet.master.petflags & PET_PACIFIST))
        {
            if (PM_GetMad (pet, attacker))
            {
                // Don't let player force Draco if it gets mad.
                PM_StopRapidFire (pet.master, TRUE);

                if (!pet.enemy)
                {
                    if (PM_ShowAngryMessage (pet))
                    {
                        // Draco: Grrrr!
                        PM_DracoTalk (pet, "Grrrr!");
                    }
                    pet.master.petflags = pet.master.petflags -
                        (pet.master.petflags & PET_FORCED);
                }
                PM_NewEnemy (attacker);
            }
        }
    }
    else
    {
        if (PM_GetMad (pet, attacker))
            PM_NewEnemy (attacker);
    }
};


//==========================================================================
//  Pet Behavior

//----------------------------------------------------/ New Code /--------//
//  This regenerates the dragon and checks if its powerups expire.
//------------------------------------------------------------------------//
void() PM_CheckPetPower =
{
    // Pet dragons slowly regain health.
    PM_Regenerate();

    // Check if quad damage wore off.
    if (self.super_damage_finished)
    {
        if (self.super_damage_finished < time + 3)
        {
            if (self.super_damage_finished < time)
            {
                if (self == self.master.draco)
                    PM_DracoTalk (self, "Quad damage wore off.");

                self.items   = self.items - (self.items & IT_QUAD);
                if (!self.invincible_finished)
                    self.effects = self.effects - (self.effects & EF_DIMLIGHT);
                self.super_damage_finished = 0;
                self.super_time = 0;
            }
            else if (self.super_time == 1)
            {
                sound (self, CHAN_AUTO, "items/damage2.wav", 1, ATTN_NORM);
                self.super_time = time + 1;
            }
        }
    }

    // Check if invulnerability wore off.
    if (self.invincible_finished)
    {
        if (self.invincible_finished < time + 3)
        {
            if (self.invincible_finished < time)
            {
                if (self == self.master.draco)
                    PM_DracoTalk (self, "Invulnerability wore off.");

                self.items   = self.items - (self.items & IT_INVULNERABILITY);
                if (!self.super_damage_finished)
                    self.effects = self.effects - (self.effects & EF_DIMLIGHT);
                self.invincible_finished = 0;
                self.invincible_time = 0;
            }
            else if (self.invincible_time == 1)
            {
                sound (self, CHAN_AUTO, "items/protect2.wav", 1, ATTN_NORM);
                self.invincible_time = time + 1;
            }
        }
    }
};

//----------------------------------------------------/ New Code /--------//
//  This checks the dragon's regeneration, powerups, and trail
//  while it is in pain.
//------------------------------------------------------------------------//
void() pet_status =
{
    // Check power and keep track of master.
    PM_CheckPetPower ();
    PM_TrackMaster ();
};

//----------------------------------------------------/ New Code /--------//
//  This rotates the pet in place before it uses its missile attack.
//------------------------------------------------------------------------//
void() pet_rotate =
{
    if (PM_InCutscene ())
        return;

    // Get spot to aim at.
    local   vector  spot;

    spot = PM_AimForward();

    // Rotate to face spot.
    self.ideal_yaw = vectoyaw(spot - self.origin);
    ChangeYaw ();

    // Check if dragon is facing opponent.  If so, attack!
    if (FacingIdeal ())
    {
        self.attack_state = AS_STRAIGHT;
        self.th_missile ();     // "You may fire when ready."
        return;
    }

    // Keep track of where the master went.
    PM_TrackMaster ();
};

//----------------------------------------------------/ New Code /--------//
//  The pet dragon melees like any other small dragon.
//------------------------------------------------------------------------//
void() pet_melee =
{
    // Check dragon strength and remember where the master went.
    PM_CheckPetPower ();
    PM_TrackMaster ();

    // Check for water if dragon has no memory of a location underwater.
    if (PM_WaterUnknown ())
        PM_WaterMemory ();

    // Turn to face enemy.
	ai_face ();
	
    // Check if dragon should back off from the target.
    if (!self.invincible_finished)
    {
        if (PM_BackOff ())
        {
            if (self.state < IQ_GENIUS)
            {
                if (self.attack_state != AS_SLIDING)
                    if (PM_DetectDanger (DRAGON_MINSPEED))
                        return;
            }
            else
            {
                if (PM_DetectDanger (self.speed))
                    return;
            }
        }
        else if (!PM_PetGoneBad (self))
        {
            // Dragon should fly away if player launches a grenade/rocket
            // at the target.  Useful for dragon vs. zombie battles.
            if (self.state < IQ_GENIUS)
            {
                if (self.attack_state != AS_SLIDING)
                    if (PM_PetDetectBombs (DRAGON_MINSPEED))
                        return;
            }
            else
            {
                if (PM_PetDetectBombs (self.speed))
                    return;
            }
        }
    }

    // If dragon does not like water, don't go under to chase the enemy.
    if (PM_Hydrophobic ())
        if (PM_NearLiquid (DRAGON_MINSPEED))
            return;

    // Check if the dragon is in strafe mode.
    if (self.attack_state == AS_SLIDING)
    {
        ryu_circlestrafe (self.speed);
        if (PM_CheckDragonLevel ())
            PM_VerticalSlide (self.speed, self.enemy);
        return;
    }

    // Close in on the opponent.
    movetogoal (DRAGON_MINSPEED);
    PM_AntiTrap (self.speed);
};

//----------------------------------------------------/ New Code /--------//
//  The pet dragon can shoot at enemies normally, or when told to do
//  so by its master.
//------------------------------------------------------------------------//
void() pet_missile =
{
    // Check dragon strength and remember where the master went.
    PM_CheckPetPower ();
    PM_TrackMaster ();

    // Check for water if dragon has no memory of a location underwater.
    if (PM_WaterUnknown ())
        PM_WaterMemory ();

    // If dragon has no targets, aim where its master is aiming at.
    // FIXME:  Should check if the forced bit is on.
    if (!self.enemy)
    {
        local   vector  spot;

        spot = PM_AimForward ();
        self.ideal_yaw = vectoyaw(spot - self.origin);
        ChangeYaw ();
        return;
    }

    // Turn to face enemy.
    ai_face();

    // Dodge dangerous entities (if applicable) while attacking.
    if (!self.invincible_finished)
    {
        if (self.state < IQ_GENIUS)
        {
            if (self.attack_state != AS_SLIDING)
                if (PM_DetectDanger (DRAGON_MINSPEED))
                    return;
        }
        else
        {
            if (PM_DetectDanger (self.speed))
                return;
        }
    }

    // If dragon does not like water, don't go under to chase the enemy.
    if (PM_Hydrophobic ())
        if (PM_NearLiquid (DRAGON_MINSPEED))
            return;

    // Check if the dragon is in strafe mode.
    if (self.attack_state == AS_SLIDING)
    {
        ryu_circlestrafe (self.speed);
        if (PM_CheckDragonLevel ())
            PM_VerticalSlide (self.speed, self.enemy);
        return;
    }

    // Close in on the opponent.
    walkmove (self.angles_y, DRAGON_MINSPEED);   // same as ai_forward()
    PM_AntiTrap (self.speed);
};

//----------------------------------------------------/ New Code /--------//
//  The dragon is burning and is on its way to water.  The
//  dragon flies extremely fast and it will avoid combat.  
//------------------------------------------------------------------------//
void() pet_panic =
{
    movedist = self.speed;

    // Keep track of where the master went.
    PM_TrackMaster ();

    // Avoid any dangerous entities nearby the dragon.  Double speed.
    if (PM_DetectDanger (self.speed*2))
        return;

    // Make sure the goal is the watergoal.
    self.goalentity = self.enemy;

    // Maintain the panic if still burning.
    PM_DragonWaterStatus (self.speed);

    // Skim over/under obstacles.
    PM_CheckWaterPath(self.speed);

    // Head straight in for water.
    movetogoal (self.speed);                // done in C code...

    // Add extra movement forward to guarantee that dragon keeps moving.
    walkmove (self.angles_y, self.speed);   // same as ai_forward()
};

//----------------------------------------------------/ New Code /--------//
//  The pet dragon hovers in place.
//------------------------------------------------------------------------//
void() pet_stand =
{
    // Check dragon strength.
    PM_CheckPetPower();

    // All pet dragons will not let water separate it from its master.
    PM_NegateWaterFear ();

    // Check for noticing a target.
    if (PM_PetFindTarget (TRUE))
        return;
	
    // Move faster to water if burning.
    if (self.enemy.classname == "watergoal")
    {
        pet_panic ();
        return;
    }

    // If burning, find some water and go there!
    PM_DragonWaterStatus (self.speed);

    // Check for force attack.
    if (self == self.master.draco)
        if (self.master.petflags & PET_FORCED)
        {
            pet_rotate ();
            return;
        }

    // Keep track of where the master went.
    PM_TrackMaster ();
};

//----------------------------------------------------/ New Code /--------//
//  This tells the pet dragon to fly slowly back and forth.
//------------------------------------------------------------------------//
void() pet_patrol =
{
    local   float   delta;
	
    // Keep track of where the master went.
    PM_TrackMaster ();

    // Rotate in place if necessary before flying straight ahead.
    delta = rint(self.angles_y - self.ideal_yaw);
    delta = anglemod(delta);
    if (delta != 0)
    {
        ChangeYaw ();
        return;
    }

    // If movement was blocked, turn around and fly.
    if (!walkmove (self.angles_y, DRAGON_MINSPEED))
    {
        local   float   reverse;

        reverse = self.angles_y + 180;
        reverse = anglemod(reverse);
        self.ideal_yaw = reverse;
    }
};

//----------------------------------------------------/ New Code /--------//
//  This tells the pet dragon to follow its master.  The dragon may
//  do other tasks instead, such as flying toward food and eating it.
//------------------------------------------------------------------------//
void(entity food, entity shot, entity clip) pet_follow =
{
    // Avoid projectiles or other threats.
    if (!self.invincible_finished)
        if (shot)
        {
            PM_FindBestPath (self.speed, shot);
            PM_TrackMaster ();
            return;
        }

    // FIXME:  If dragon wants to go after an item, do it here.

    // Go after food if hungry.
    if (food)
        if (PM_PetHungry ())
        {
            PM_GotoPetFood (food);
            PM_TrackMaster ();
            return;
        }

    // If path from pet to master is blocked, follow the trail.
    if (PM_PetOutOfSight (self))
    {
        if (self.node)
            self.goalentity = self.node;
        PM_LookForMaster ();
        return;
    }

    // Check if pet is in its master's way.
    if (PM_CheckPetBlock ())
        return;

    // Fly towards master.
    self.goalentity = self.master;
    if (PM_GotoMaster ())
    {
        // Face the master.
        self.ideal_yaw = vectoyaw(self.master.origin - self.origin);
    }
    else
    {
        // Dragon has stalled, turn away from master to fly around.
        self.ideal_yaw = vectoyaw(self.origin - self.master.origin);
    }
    ChangeYaw ();

    // Adjust elevation if necessary.
    PM_SeekLevel (self.petofs, self.master.origin_z);
    PM_PetAntiTrap (clip);
};

//----------------------------------------------------/ New Code /--------//
//  This makes the pet dragon move during walk mode.  Normally, that
//  means the dragon either follows its master, or glides back and forth.
//
//  NOTE:  Patrol is disabled, so the dragon only follows now.
//
//  Walk part 3.
//------------------------------------------------------------------------//
void(entity food, entity shot, entity clip) pet_walkgo =
{
    // Move faster to water if burning.
    if (self.enemy.classname == "watergoal")
    {
        pet_panic ();
        return;
    }
    // If burning, find some water and go there!
    PM_DragonWaterStatus(self.speed);

    // Now move!
    if (self == self.master.draco)
    {
        // Draco only:  Check for force attack.  If not, check for patrol.
        if (self.master.petflags & PET_FORCED)
        {
            pet_rotate ();
            return;
        }
        if (self.master.petflags & PET_PATROL)
        {
            pet_patrol ();
            return;
        }
    }

    // Don't follow if in cutscene.  It will follow camera if it does.
    if (PM_InCutscene (self.master))
        pet_patrol ();
    else
        pet_follow (food, shot, clip);
};

//////////////////////////////////////////////////////////////////////////
//----------------------------------------------------/ New Code /--------//
//  The following functions scan for various things around the dragon.
//  They are very similar and have much code in common.
//
//  Together, it all looks ugly, but I did it this way for efficiency
//  reasons.  Findradius can be slow, and I don't want to call it three
//  or more times in a row.
//
//  pet_walkfind1 = Finds enemies, food, and obstacles.
//  pet_walkfind2 = Finds for food and obstacles only.
//
//  Walk part 2.
//------------------------------------------------------------------------//

// Find enemies, food, and obstacles.
void() pet_walkfind1 =
{
    local   entity  head;
    local   entity  clip;
    local   entity  food;
    local   entity  shot;
    local   float   dist;

    clip = world;
    food = world;
    shot = world;
    head = findradius(self.origin, SIGHT_RADIUS);
    while (head)
    {
        // The dragon looks for things to fight or to avoid.
        if (head != self)
        {
            traceline(self.origin, head.origin, TRUE, self);
            if (trace_fraction == 1)
            {
                // Check for targets to fight.
                if (PM_ValidTarget (head, self))
                    if (PM_PetSeeTarget (head))
                    {
                        PM_PetFoundTarget (head);
                        return;
                    }

                // No targets, check for other things.
                dist = vlen (head.origin - self.origin);

                // Check for food.
                if (PM_IsGoodFood (head, dist))
                {
                    // Find the nearest source of food.
                    if (!food)
                        food = head;
                    else if (vlen (food.origin - self.origin) > dist)
                        food = head;
                }

                // Check for nasty things.
                if (dist <= DETECT_RADIUS)
                {
                    if (PM_IsHostile (head))
                        shot = head;
                }
                if (dist <= 32)
                    clip = head;
            }
        }
        head = head.chain;
    }

    pet_walkgo (food, shot, clip);
};

// Find food and obstacles.
void() pet_walkfind2 =
{
    local   entity  head;
    local   entity  clip;
    local   entity  food;
    local   entity  shot;
    local   float   dist;

    clip = world;
    food = world;
    shot = world;
    head = findradius(self.origin, SIGHT_RADIUS);
    while (head)
    {
        // The dragon looks for things to fight or to avoid.
        if (head != self)
        {
            traceline(self.origin, head.origin, TRUE, self);
            if (trace_fraction == 1)
            {
                // No targets, check for other things.
                dist = vlen (head.origin - self.origin);

                // Check for food.
                if (PM_IsGoodFood (head, dist))
                {
                    // Find the nearest source of food.
                    if (!food)
                        food = head;
                    else if (vlen (food.origin - self.origin) > dist)
                        food = head;
                }

                // Check for nasty things.
                if (dist <= DETECT_RADIUS)
                {
                    if (PM_IsHostile (head))
                        shot = head;
                }
                if (dist <= 32)
                    clip = head;
            }
        }
        head = head.chain;
    }

    pet_walkgo (food, shot, clip);
};
//////////////////////////////////////////////////////////////////////////

//----------------------------------------------------/ New Code /--------//
//  This begins and sets up walk mode for the pet dragon.
//  Walk part 1.
//------------------------------------------------------------------------//
void() pet_walk =
{
    // If a dragon gets stuck inside a wall and cannot escape, it dies.
    if (PM_PetGoneInWall())  return;

    // Check dragon strength.
    PM_CheckPetPower();

    // All pet dragons will not let water separate it from its master.
    PM_NegateWaterFear ();

    movedist = DRAGON_MINSPEED;

    if (PM_PetCanFight (self))
        pet_walkfind1 ();
    else
        pet_walkfind2 ();
};

//----------------------------------------------------/ New Code /--------//
//  The pet dragon checks if it can ignore its current target and
//  attack another target it found.
//------------------------------------------------------------------------//
float() PM_FindTargetOfOp =
{
    local   entity  oldmeat;

    oldmeat = self.enemy;
    if (PM_IgnorableTarget (self.enemy))
    {
        // Current target can be ignored for now.
        // First, check if we had a previous opponent.  If so,
        // attack it if we can see it and if it is good idea.
        if (self.oldenemy)
        {
            if (visible (self.oldenemy))
            {
                if (!PM_IgnorableTarget (self.oldenemy))
                {
                    self.enemy = self.oldenemy;
                    self.oldenemy = oldmeat;
                    HuntTarget ();
                    return TRUE;
                }
            }
        }

        // We didn't have an oldenemy worthy of attacking now,
        // so check for any other easy prey nearby.
        if (PM_PetFindTarget (FALSE))
        {
            self.oldenemy = oldmeat;
            return TRUE;
        }
    }

    // No other targets found, so continue the fight with current enemy.
    return FALSE;
};

//----------------------------------------------------/ New Code /--------//
//  The pet dragon stops attacking its current enemy, then either
//  attacks a previous opponent or goes idle.
//------------------------------------------------------------------------//
float() PM_PetDisengage =
{
    // Now change the enemy.
    self.enemy = world;
    if (self.oldenemy.health > 0)
    {
        // There is another target.
        self.enemy = self.oldenemy;
        self.oldenemy = world;      // Don't hunt oldenemy indefinitely.
        HuntTarget ();
        return FALSE;
    }

    // Cease fire.
    self.oldenemy = world;
    self.goalentity = self.master;
    self.search_time = time;
    if (self == self.master.draco)
    {
        // Remove 'forced' so pet is not stuck in shoot mode.
        self.master.petflags = self.master.petflags -
            (self.master.petflags & PET_FORCED);

        if (self.master.petflags & PET_STAY)
            self.th_stand ();
        else
            self.th_walk ();
    }
    else
        self.th_walk ();

    return TRUE;
};

//----------------------------------------------------/ New Code /--------//
//  Check if dragon was commanded to attack an enemy.  If so,
//  the dragon is focused on the enemy and FALSE will be returned.
//------------------------------------------------------------------------//
float() PM_PetNotFocused =
{
    // If turned evil, stay focused and return false.
    if (PM_PetGoneBad (self))
        return FALSE;

    // FIXME:  Optional -- should the dragon really do this?
    // If pacifist, never give up until recalled by its master.
    if (self == self.master.draco)
        if (self.master.petflags & PET_PACIFIST)
            return FALSE;

    // Dragon was not commanded to attack.  (i.e., attacked on its own.)
    return TRUE;
};

//----------------------------------------------------/ New Code /--------//
//  The pet dragon is flying around while fighting.  It may attack,
//  dodge missiles, or just simply move toward the opponent at normal
//  running speed.
//------------------------------------------------------------------------//
void() pet_run =
{
    // If a dragon gets stuck inside a wall and cannot escape, it dies.
    if (PM_PetGoneInWall())
        return;

    // Check dragon strength.
    PM_CheckPetPower();

    // Move faster to water if burning.
    if (self.enemy.classname == "watergoal")
    {
        pet_panic ();
        return;
    }

    // Make sure the right dragons are afraid of water during combat.
    PM_SetWaterFear (self.skin);

    movedist = self.speed;

    // See if the enemy is dead...
	if (self.enemy.health <= 0)
        if (PM_PetDisengage ())
            return;

    // Check for master's location.
    PM_TrackMaster ();

    // Check if dragon was commanded to attack an enemy.
    local   float   no_focus;

    no_focus = PM_PetNotFocused ();

    // Check knowledge of enemy.
    enemy_vis = ryu_visible(self.enemy);   // !!!
    if (PM_CanAttackTarget ())
        self.search_time = time + 5;

    if (self.search_time < time)
    {
        // Dragon hasn't seen its opponent for a while,
        // so find another target or go idle.
        if (self.attack_state == AS_SLIDING)
            self.attack_state = AS_STRAIGHT;

        if (no_focus)
        {
            if (PM_PetFindTarget (TRUE))
                return;
            if (PM_PetDisengage ())
            {
                // The dragon grumbles then returns to its master.
                sound (self, CHAN_VOICE, "dragon/idle2.wav", 1, ATTN_NORM);
                return;
            }
        }
    }
    // Look for targets of opportunity.
    if (no_focus)
        if (PM_FindTargetOfOp ())
            return;

    // FIXME:  Should be a check to stop fighting in case target is a
    //         good guy and it stops fighting.

    // If burning, find some water and go there!
    PM_DragonWaterStatus (self.speed);

	enemy_infront = infront(self.enemy);
	enemy_range = range(self.enemy);
	enemy_yaw = vectoyaw(self.enemy.origin - self.origin);
	
	if (self.attack_state == AS_MISSILE)
    {
        ryu_run_attack ();
		return;
	}
	if (self.attack_state == AS_MELEE)
    {
        ryu_run_attack ();
        return;
	}

    if (enemy_vis)
        if (PM_PetCheckAttack ())
            return;         // Beginning an attack.

    // Avoid projectiles or other threats.
    if (!self.invincible_finished)
        if (PM_DetectDanger (self.speed))
        {
            self.slide_rand = time + DODGE_TIME;
            return;
        }

    // If the dragon does not like water, stay away from it.
    if (PM_Hydrophobic ())
    {
        if (PM_EntInWater (self))
            if (PM_LeaveWater (self.speed))
                return;
        if (PM_NearLiquid (self.speed))
            return;
    }

    // Don't pin zombies.
    if (PM_AntiZombiePin ())
        return;

    // Head straight in.
    movetogoal (self.speed);            // done in C code...
    PM_AntiTrap (self.speed);

    // Move vertical if in strafe mode.
    if (self.attack_state == AS_SLIDING)
        PM_VerticalSlide (self.speed, self.enemy);
};


//===========================/  END OF FILE  /===========================//

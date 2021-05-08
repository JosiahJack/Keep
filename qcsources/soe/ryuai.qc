//==========================================================================
//  ryuai.qc -- by Patrick Martin               Last updated:  5-5-2001
//--------------------------------------------------------------------------
//  This file contains code that dictates the AI of the dragons.
//==========================================================================


//==========================================================================
//  Dragon Combat

//----------------------------------------------------/ New Code /--------//
//  This returns the power level of a dragon.
//
//  NOTE:  Familiars do not use this -- they use their own function.
//------------------------------------------------------------------------//
float() dragon_level =
{
    if (self.height == SIZE_SMALL)
    {
        if (self.spawnflags & SPAWN_CRANKED)
            return 2;
        return 1;
    }

    // Large dragons.
    if (self.spawnflags & SPAWN_CRANKED)
        return 4;
    return 2;
};

//----------------------------------------------------/ New Code /--------//
//  Return the chance that the dragon will breathe (or shoot something)
//  at it opponent.
//------------------------------------------------------------------------//
float(float level) PM_DragonChance =
{
    // Any dragon will almost certainly attack within melee range.
    if (enemy_range == RANGE_MELEE)
    {
        self.attack_finished = 0;
        return 0.9;
    }

    // Short range (120-500)
    if (enemy_range == RANGE_NEAR)
    {
        return 0.2;
    }

    // Medium range (500-1000)
    if (enemy_range == RANGE_MID)
    {
        if (level < 2)
        {
            // Weak blue dragons' lightning is short range only.
            if (self.skin == SKIN_BLUE)
                return 0;

            // Small, weak dragons rarely attack from medium range.
            return 0.05;
        }

        return 0.1;
    }

    // Long range (1000+)
    self.attack_state = AS_STRAIGHT;    // No need to fly up or down.

    // Small, weak dragons can't attack from long range.
    if (level < 2)
        return 0;

    if (self.skin == SKIN_BLUE)
        return 0;   // Max range is 1000-1500 -- just assume 1000.

    // Most dragons can attack from long range.
    return 0.02;
};

//----------------------------------------------------/ New Code /--------//
//  This checks if the dragon cannot use its missile attacks because
//  of some detrimental side effect that could result from it.
//------------------------------------------------------------------------//
float(entity ent) PM_DragonNoShot =
{
    // Stupid dragons always shoot even if it hurts them.
    if (ent.state == IQ_LOW)
        return FALSE;

    // Check if the dragon can shoot.
    if (ent.skin == SKIN_RED)
    {
        // Fire is useless underwater.
        return (PM_EntInWater (ent));
    }
    if (ent.skin == SKIN_WHITE)
    {
        // Ice shards melt in the lava.
        return (pointcontents(ent.origin) == CONTENT_LAVA);
    }
    if (ent.skin == SKIN_BLUE)
    {
        // Lightning is explosive underwater.
        // FIXME:  Could be allowed to discharge in specific situations.
        return (PM_EntInWater (ent));
    }

    // Dragon is allowed to fire.
    return FALSE;
};

//----------------------------------------------------/ New Code /--------//
//  Check if an attack can be made.
//------------------------------------------------------------------------//
float() PM_DragonCheckAttack =
{
    local   vector  spot1, spot2;
    local   entity  targ;
    local   float   chance;
    local   float   pause;

    targ = self.enemy;
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;

    // FIXME:  Add wall check here if necessary.  Currently,
    //         enemy_vis in ryu_run does this already...

    // If dragon is not stupid, check if attack is blocked by creature.
    // If so, flag it so dragon may try to move around it vertically.
    if (self.state != IQ_LOW)
    {
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
    chance = dragon_level();
    chance = PM_DragonChance(chance);

    // Don't fly too far away.
    if (!chance)
        self.attack_state = AS_STRAIGHT;

    // The dragon decides whether to attack or move on.
    if (random () < chance)
    {
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
//  This checks if the dragon found a target.
//------------------------------------------------------------------------//
float(entity targ) PM_DragonEnemyFound =
{
    // If client found is already the monster's enemy, do nothing.
    if (self.enemy.classname == "watergoal")
    {
        if (targ == self.oldenemy)
            return FALSE;
    }
    else
    {
        if (targ == self.enemy)
            return FALSE;
    }

    // Client is undetectable so do nothing.
    if (targ.flags & FL_NOTARGET)
        return FALSE;

    // Smart dragons can spot even "invisible" players.
    if (targ.items & IT_INVISIBILITY)
        if (self.state < IQ_GENIUS)
            return FALSE;

    // Look for clients.
    local   float   r;

    r = range (targ);
    if (!visible (targ))
        return FALSE;
	if (r == RANGE_NEAR)
    {
        if (targ.show_hostile < time)
            if (!infront (targ))
                return FALSE;
	}
	else if (r == RANGE_MID)
    {
        if (!infront (targ))
            return FALSE;
    }
    else if (r == RANGE_FAR)
    {
        // Not smart enough to see threats from long range.
        if (self.state < IQ_HIGH)
            return FALSE;

        // If target becomes a threat, wake up.
        if (targ.show_hostile < time)
            return FALSE;
        if (!infront (targ))
            return FALSE;
    }

    // Found one.
    return TRUE;
};

//----------------------------------------------------/ New Code /--------//
//  This checks if the dragon will wake up when it sees a player.
//  This is similar to 'FindTarget' except it contains the necessary
//  modifications needed to work with the dragon AI features without
//  embedding code in 'FindTarget'.
//------------------------------------------------------------------------//
float() PM_DragonFindTarget =
{
    local   entity  client;

    // A dragon with the pacifist flag set will not wake up even when
    // it sees a player.
    if (self.spawnflags & SPAWN_PACIFIST)
        return FALSE;

    // If the ambush spawnflag bit is set, the monster will only wake up
    // on really seeing the player, not another monster getting angry.
    // No zombie crucified mess here :)
    if (sight_entity_time >= time - 0.1  &&  !(self.spawnflags & SPAWN_AMBUSH) )
    {
        client = sight_entity;
        if (self.enemy.classname == "watergoal")
        {
            if (client.enemy == self.oldenemy)
                return FALSE;
        }
        else
        {
            if (client.enemy == self.enemy)
                return FALSE;
        }
    }
	else
    {
        client = checkclient ();
        if (!client)
            return FALSE;   // current check entity isn't in PVS
	}

    // If no enemy is found, abort.
    if (!PM_DragonEnemyFound (client))
        return FALSE;

    // Enemy is found.  However, if dragon is looking for water, ignore
    // opponent for now.
    if (self.enemy.classname == "watergoal")
    {
        self.oldenemy = client;
        if (self.oldenemy.classname != "player")
        {
            self.oldenemy = self.oldenemy.enemy;
            if (self.oldenemy.classname != "player")
            {
                self.oldenemy = world;
                return FALSE;
            }
        }
        PM_FoundSecondary ();
    }
    else
    {
        self.enemy = client;
        if (self.enemy.classname != "player")
        {
            self.enemy = self.enemy.enemy;
            if (self.enemy.classname != "player")
            {
                self.enemy = world;
                return FALSE;
            }
        }
        FoundTarget ();
    }

    return TRUE;
};


//==========================================================================
//  Dragon Behavior

//----------------------------------------------------/ New Code /--------//
//  This checks if the dragon should strafe.
//------------------------------------------------------------------------//
float() PM_DoStrafe =
{
    // Gold dragons should not strafe if not in melee.
    if (self.skin == SKIN_GOLD)
        if (range(self.enemy) > RANGE_MELEE)
            return FALSE;

    // No need to circle-strafe if dragon is invulnerable.
    if (self.invincible_finished)
        return FALSE;

    // Stupid dragons cannot circle-strafe.
    if (self.state == IQ_LOW)
        return FALSE;

    // Always strafe if it wants to, especially after flinching from pain.
    if (self.slide_away >= time)
        return TRUE;

    // The dragon should close in on zombies so don't strafe by chance.
    if (self.enemy.classname == "monster_zombie")
        return FALSE;

    // Gold dragons should not strafe unless they really need to.
    // In older Dragons, blue did not strafe.  Now they do.
    if (self.skin == SKIN_GOLD)
        return FALSE;

    // If inclined to strafe, do it half the time.
    if (self.slide_rand >= time)
        if (random() < 0.5)
            return TRUE;

    // Dragon decided not to strafe after all.
    return FALSE;
};

//----------------------------------------------------/ New Code /--------//
//  The dragon decides whether to strafe or hold still while attacking.
//  Used in missile attacks.
//------------------------------------------------------------------------//
void() PM_StrafeOption =
{
    if (PM_DoStrafe ())
    {
        self.attack_state = AS_SLIDING;
        if (random() < 0.5)
            self.lefty = 1;
        else
            self.lefty = 0;
        return;
    }

    // Don't strafe.
    self.attack_state = AS_STRAIGHT;
};

//----------------------------------------------------/ New Code /--------//
//  The dragon strafes to the side then rotates to face opponent.
//------------------------------------------------------------------------//
void(float dist) ryu_circlestrafe =
{
    local   float   offset;

    self.ideal_yaw = enemy_yaw;
    ChangeYaw ();
    if (self.lefty)
        offset = 90;
    else
        offset = -90;

    if (walkmove (self.angles_y + offset, dist))
        if (!PM_AntiClip ())
        {
            ai_face ();
            return;
        }

    self.lefty = !self.lefty;
    walkmove (self.angles_y - offset, dist);
    PM_AntiClip ();
    ai_face ();
};

//----------------------------------------------------/ New Code /--------//
//  This checks if the dragon should back off from melee.
//------------------------------------------------------------------------//
float() PM_BackOff =
{
    // Target moved out of melee range, so watch out.
    if (vlen(self.enemy.origin - self.origin) > 120)
        return TRUE;

    // Don't use "KeepAway" here.  Just stay away from burning entities
    // or spawn.  If we did want to use KeepAway, remove the rest of the
    // checks and return the results of KeepAway.

    // If target is on fire, stay away.
    if (PM_IsBurning (self.enemy))
        return TRUE;

    // Run away from spawn -- they explode if killed.
    if (self.state >= IQ_GENIUS)
        if (self.th_missile)
            if (self.enemy.classname == "monster_tarbaby")
                return TRUE;

    // Close in on target if possible.
    return FALSE;
};

//----------------------------------------------------/ New Code /--------//
//  The dragon is engaged in melee with its opponent.
//------------------------------------------------------------------------//
void() ryu_melee =
{
    // A dragon that can regenerate can regain health.
    PM_Regenerate ();

    // Check for water if dragon has no memory of a location underwater.
    if (PM_WaterUnknown ())
        PM_WaterMemory ();

    // Attacking, not trying to go somewhere.
    self.stalled = time + 1;

    // Turn to face enemy.
    ai_face ();
	
    // Check if opponent is close enough.  If opponent is too far away,
    // he (or whatever) was baiting the dragon for an easy shot.  In
    // this case, avoid any projectiles attackers may launch at it.
    if (!self.invincible_finished)
    {
        if (PM_BackOff ())
        {
            if (self.state < IQ_GENIUS)
            {
                // Dragons with only high intelligence dodge slowly if
                // not strafing.
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
    }

    // If dragon does not like water, don't go under to chase the enemy.
    if (PM_Hydrophobic ())
        if (PM_NearLiquid (DRAGON_MINSPEED))
            return;

    // Check if the dragon is in strafe mode.
    if (self.attack_state == AS_SLIDING)
    {
        ryu_circlestrafe(self.speed);
        if (PM_CheckDragonLevel ())
            PM_VerticalSlide (self.speed, self.enemy);
        return;
    }

    // Close in on the opponent.
    movetogoal (DRAGON_MINSPEED);
    PM_AntiClip ();
    PM_AntiTrap (self.speed);
};

//----------------------------------------------------/ New Code /--------//
//  Face and close in on the opponent while attacking.
//------------------------------------------------------------------------//
void() ryu_missile =
{
    // A dragon that can regenerate can regain health.
    PM_Regenerate ();

    // Check for water if dragon has no memory of a location underwater.
    if (PM_WaterUnknown ())
        PM_WaterMemory ();

    // Attacking, not trying to go somewhere.
    self.stalled = time + 1;

    // Turn to face enemy.
    ai_face();

    // Dodge dangerous entities (if applicable) while attacking.
    // Less intelligent dragons cannot dodge things while circle-strafing.
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
        ryu_circlestrafe(self.speed);
        if (PM_CheckDragonLevel ())
            PM_VerticalSlide (self.speed, self.enemy);
        return;
    }

    // Close in on the opponent.
    walkmove (self.angles_y, DRAGON_MINSPEED);   // same as ai_forward()
    PM_AntiClip ();
    PM_AntiTrap (self.speed);
};

//----------------------------------------------------/ New Code /--------//
//  The dragon is burning and is on its way to water.  The
//  dragon flies extremely fast and it will avoid combat.  
//------------------------------------------------------------------------//
void() ryu_panic =
{
    movedist = self.speed;

    self.show_hostile = time + 1;           // wake up other monsters

    // Avoid any dangerous entities nearby the dragon.  Double speed.
    if (PM_DetectDanger (self.speed*2))
        return;

    // Maintain the panic if still burning.
    PM_DragonWaterStatus (self.speed);

    // Skim over/under obstacles.
    PM_CheckWaterPath (self.speed);

    // Head straight in for water.
    movetogoal (self.speed);                // done in C code...
    PM_AntiClip ();

    // Add extra movement forward to guarantee the dragon keeps moving.
    walkmove (self.angles_y, self.speed);   // same as ai_forward()
    PM_AntiClip ();
};

//----------------------------------------------------/ New Code /--------//
//  The dragon hovers in place.  If a water-fearing dragon is
//  underwater, it will escape the pool if possible. 
//------------------------------------------------------------------------//
void() ryu_stand =
{
    // A dragon that can regenerate can regain health.
    PM_Regenerate();

    // Check for noticing a player.
    if (PM_DragonFindTarget ())
        return;
	
	if (time > self.pausetime)
    {
        self.th_walk ();
		return;
    }

    // Move faster to water if burning.
    if (self.enemy.classname == "watergoal")
    {
        ryu_panic ();
        return;
    }
    // If burning, find some water and go there!
    PM_DragonWaterStatus (self.speed);

    // If dragon does not like water and is in it, then get out if possible.
    if (PM_Hydrophobic ())
    {
        if (PM_EntInWater (self))
        {
            PM_LeaveWater (self.speed);
            return;
        }
        PM_NearLiquid (self.speed);
    }
};

//----------------------------------------------------/ New Code /--------//
//  The dragon glides along its path.  Like ryu_stand(), a
//  water-fearing dragon will try to escape from any body of
//  water if it is placed in one.
//------------------------------------------------------------------------//
void() ryu_walk =
{
    // A dragon that can regenerate can regain health.
    PM_Regenerate();

    movedist = DRAGON_MINSPEED;

    // Check for noticing a player if the dragon is not pacifist.
    if (PM_DragonFindTarget ())
        return;

    // Move faster to water if burning.
    if (self.enemy.classname == "watergoal")
    {
        ryu_panic ();
        return;
    }
    // If burning, find some water and go there!
    PM_DragonWaterStatus(self.speed);

    // If the dragon does not like water and is in it, then get out if possible.
    if (PM_Hydrophobic ())
    {
        if (PM_EntInWater (self))
        {
            if (!PM_LeaveWater (self.speed))
            {
                movetogoal (self.speed);
                PM_AntiClip ();
            }        
            return;
        }
        if (PM_NearLiquid (self.speed))
            return;
    }

    // Dragon proceeds on its intended path.
    movetogoal (DRAGON_MINSPEED);
    PM_AntiClip();
};

//----------------------------------------------------/ New Code /--------//
//  This checks whether the dragon is allowed to attack its target
//  when one is in air while the other is in liquid.
//------------------------------------------------------------------------//
float() PM_BlockDragonSight =
{
    // Less intelligent dragons will not attack an unseen target.
    if (self.state < IQ_HIGH)
        return TRUE;

    if (self.th_missile)
    {
        // Blue dragons will shoot lightning into water to fry targets.
        if (self.skin == SKIN_BLUE)
            return FALSE;
    }

    // Other dragons can attack the target if it is within melee range.
    // Otherwise, it is not allowed to attack the target blindly.
    return (vlen(self.enemy.origin - self.origin) > 120);
};

//----------------------------------------------------/ New Code /--------//
//  This checks if the dragon's target can be seen.  This is different
//  from the original visible() function in that some dragons can see
//  a swimming target through the water.
//------------------------------------------------------------------------//
float(entity targ) ryu_visible =
{
    local   vector  spot1, spot2;
	
    spot1 = self.origin + self.view_ofs;
    spot2 = targ.origin + targ.view_ofs;
    traceline (spot1, spot2, TRUE, self);   // see through other monsters
	
    // Some dragons can see targets through liquid while others cannot.
    if (trace_inopen)
        if (trace_inwater)
            if (PM_BlockDragonSight())
                return FALSE;

    return (trace_fraction == 1);
};

//----------------------------------------------------/ New Code /--------//
//  The dragon rotates in place (via multiple calls to this function)
//  until it faces its opponent.  Upon facing an opponent, the dragon
//  will launch an attack.
//------------------------------------------------------------------------//
void() ryu_run_attack =
{
    // Rotate to face opponent.
    self.ideal_yaw = enemy_yaw;
    ChangeYaw ();

    // Check if dragon is facing opponent.  If so, attack!
    if (FacingIdeal ())
    {
        self.attack_state = AS_STRAIGHT;

        if (enemy_range == RANGE_MELEE)
            if (self.th_melee)
            {
                self.th_melee ();
                return;
            }

        if (self.th_missile)
            if (!PM_DragonNoShot (self))
            {
                self.th_missile ();     // switch attacks
                return;
            }
    }

    // Break off the attack if a projectile or some other danger is nearby.
    if (PM_DetectDanger (self.speed))
        self.attack_state = AS_STRAIGHT;
};

//----------------------------------------------------/ New Code /--------//
//  The dragon stops attacking its current enemy, then either
//  attacks a previous opponent or goes idle.
//------------------------------------------------------------------------//
float() PM_Disengage =
{
    self.enemy = world;

    // Check if there was a previous opponent.
    if (self.oldenemy.health > 0)
    {
        // Attack previous opponent.
        self.enemy = self.oldenemy;
        self.oldenemy = world;
        HuntTarget ();
        return FALSE;
    }

    // All clear -- cease fire.
    self.oldenemy = world;
    if (self.movetarget)
        self.th_walk ();
    else
        self.th_stand ();
    return TRUE;
};

//----------------------------------------------------/ New Code /--------//
//  This checks if the dragon can forget the enemy.
//------------------------------------------------------------------------//
float() PM_ForgetEnemy =
{
    // Must be of similar alignment.
    if (PM_EntIsGood (self.enemy))
        return FALSE;

    // Enemy must not be fighting the dragon.
    if (self.enemy.enemy == self)
        return FALSE;
    if (self.enemy.oldenemy == self)
        return FALSE;

    // Can forget enemy.
    return TRUE;
};

//----------------------------------------------------/ New Code /--------//
//  This checks if the dragon is able to attack the target.
//------------------------------------------------------------------------//
float() PM_CanAttackTarget =
{
    // Standard.  Must see the target.
    if (!enemy_vis)
        return FALSE;

    // In case mega-enforcer keeps his shields up for too long.
    if (!self.enemy.takedamage)
        return FALSE;

    // In case zombie stays down forever.
    if (!self.enemy.solid)
    {
        // If zombie, extend the search time by a frame on every other
        // frame, since zombies stay down for five seconds.  This will
        // let the dragon wait a few more seconds for the zombie to get up.
        // If it can't, then leave it.
        if (self.enemy.classname == "monster_zombie")
            if (floor(time) & 1)
                self.search_time = self.search_time + 0.1;

        return FALSE;
    }

    // Don't let blue dragons get stuck trying to zap zombies that are
    // underwater to death -- it is useless.
    if (self.skin == SKIN_BLUE)
        if (self.enemy.classname == "monster_zombie")
            if (!PM_EntInWater (self))
                if (PM_WaterLevel(self.enemy) > 2)
                    return FALSE;

    return TRUE;
};

//----------------------------------------------------/ New Code /--------//
//  The dragon is flying around while fighting.  It may attack,
//  dodge missiles, or just simply move toward the opponent at
//  normal running speed.
//------------------------------------------------------------------------//
void() ryu_run =
{
    // A dragon that can regenerate regains health.
    PM_Regenerate();

    // Moving toward water?  Go into panic mode.
    if (self.enemy.classname == "watergoal")
    {
        ryu_panic ();
        return;
    }

    movedist = self.speed;

    // See if the enemy is dead.
    if (self.enemy.health <= 0)
        if (PM_Disengage ())
            return;

    self.show_hostile = time + 1;       // wake up other monsters

    // check knowledge of enemy
    enemy_vis = ryu_visible(self.enemy);   // !!!
    if (PM_CanAttackTarget ())
        self.search_time = time + 5;

    if (self.search_time < time)
    {
        // Hasn't seen enemy in a while.  Get out of strafe mode.
        if (self.attack_state == AS_SLIDING)
            self.attack_state = AS_STRAIGHT;

        // If dragon is not too stupid, look for other players.
        // Do this in single player as well in coop/dm because
        // good monsters act like extra players.
        if (self.state > IQ_LOW)
            if (PM_DragonFindTarget ())
                return;
    }

    // If genius, check if it can forget the enemy and go idle.
    if (self.state >= IQ_GENIUS)
        if (PM_ForgetEnemy ())
            if (PM_Disengage ())
                return;

    // If burning, find some water and go there!
    PM_DragonWaterStatus (self.speed);

    // Check for attack.
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
        if (PM_DragonCheckAttack())
            return;         // beginning an attack

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

    // Head straight in...
    if (self.height == SIZE_SMALL)
    {
        // No need to use anti-stall code.
        movetogoal (self.speed);        // done in C code...
    }
    else
    {
        local   vector  oldspot;

        oldspot = self.origin;
        movetogoal (self.speed);              // done in C code...

        // Fast, larger dragons sometimes have trouble closing in for melee.
        // If stalled, fly in at minimum speed to move in.
        if (oldspot == self.origin)
        {
            if (self.stalled < time)
            {
                self.attack_finished = 0;
                movetogoal (DRAGON_MINSPEED);
            }
        }
        else
        {
            self.stalled = time + 1;
        }
    }
    PM_AntiClip ();
    PM_AntiTrap (self.speed);

    // Check if dragon is in strafe mode.
    if (self.attack_state == AS_SLIDING)
        PM_VerticalSlide (self.speed, self.enemy);
};


//===========================/  END OF FILE  /===========================//

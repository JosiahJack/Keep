//==========================================================================
//  petimp.qc -- by Patrick Martin              Last updated:  5-5-2001
//--------------------------------------------------------------------------
//  This controls the interface between pet and master via impulse.
//
//  NOTE:  Dragon names in high ascii...
//  Draco:  = ƒÚ·„Ô∫
//  Hiryu:  = »ÈÚ˘ı∫
//  Ryu:    = “˘ı∫
//  dragon: = ‰Ú·ÁÔÓ∫
//==========================================================================


//==========================================================================
//  Impulse 101:  Select Draco

//----------------------------------------------------/ New Code /--------//
//  This shows the name of the dragon the player is controlling.
//------------------------------------------------------------------------//
void(entity client) PM_ShowPetName =
{
    sprint (self, "Draco\n");
};

//----------------------------------------------------/ New Code /--------//
//  This returns the health to be displayed on the hud.
//  If multiple dragons are controlled, the health average will be shown.
//
//  Note about dragon health:  If entity == world, health will read 0.
//------------------------------------------------------------------------//
float(entity client) PM_GetPetHealth =
{
    if (client.draco)
        return PM_ArmoredHealth (client.draco);

    return 0;
};

//----------------------------------------------------/ New Code /--------//
//  This lets the player select Draco as weapon.
//------------------------------------------------------------------------//
float(float select) PM_SelectPet =
{
    if (PM_HasPermanentDragon (self))
    {
        // Player already has Draco.
        if (select)
        {
            // If dragon is the current weapon, ignore the impulse.
            if (self.petflags & PET_CONTROL)
                return TRUE;

            // Don't let dragon shoot immediately.
            if (self.button0)
                PM_StopRapidFire (self, TRUE);

            // Switch to axe and enable dragon control.
            self.petflags = self.petflags | PET_CONTROL;
            //PM_ShowPetName (self);
            self.weapon = IT_AXE;
            W_SetCurrentAmmo ();
            return TRUE;
        }

        // 'select' is FALSE.  Player wants to disable control.
        if (self.petflags & PET_CONTROL)
        {
            self.petflags = self.petflags - PET_CONTROL;
            W_SetCurrentAmmo ();
            return TRUE;
        }
    }
    else
    {
        // NOTE:  Not the best way to do this, but it's simple and it works.
        if ((self.impulse == 1) || (self.impulse == 101))
            sprint (self, "Draco is not here.\n");
    }

    return FALSE;
};

void() PM_Impulse_101 =
{
    PM_SelectPet (TRUE);
};


//==========================================================================
//  Impulse 102:  Dragon Status

//----------------------------------------------------/ New Code /--------//
//  This checks if a pet is allowed to talk to its master.
//------------------------------------------------------------------------//
float(entity pet) PM_NoPetTalk =
{
    if (pet.master.health <= 0)
        return TRUE;    // Master is dead.

    // Don't check classname because of possible cutscene.
    if (!(pet.master.flags & FL_CLIENT))
        return TRUE;    // Only players have a screen.

    // Do NOT let Draco talk to master if master is the enemy,
    // unless Draco is dying.
    if (pet.health > 0)
        if (PM_PetGoneBad (pet))
            return TRUE;

    // Allowed to talk.
    return FALSE;
};

//----------------------------------------------------/ New Code /--------//
//  This displays a message from Draco to its master.
//------------------------------------------------------------------------//
void(entity pet, string text) PM_DracoTalk =
{
    if (PM_NoPetTalk (pet))
        return;     // Not allowed to talk.

    // Display message.
    sprint (pet.master, "ƒÚ·„Ô∫ ");
    sprint (pet.master, text);
    sprint (pet.master, "\n");
};

//----------------------------------------------------/ New Code /--------//
//  This is a safety check in which players without a pet dragon
//  available are told why the command failed.
//------------------------------------------------------------------------//
float(float order) PM_PetReady =
{
    if (!(self.petflags & PET_ALIVE))
    {
        sprint (self, "Draco is not here.\n");
        return FALSE;
    }
    if (!(self.petflags & PET_READY))
    {
        sprint (self, "Draco is not available yet.\n");
        return FALSE;
    }
    if (!self.draco)
    {
        sprint (self, "Draco is not available yet.\n");
        return FALSE;
    }

    if (order)
        if (self.draco.enemy == self)
        {
            sprint (self, "Draco refuses to obey you.\n");
            return FALSE;
        }

    // The player has a dragon available to receive commands.
    return TRUE;
};

//----------------------------------------------------/ New Code /--------//
//  This shows the dragon's level and health to its master.
//------------------------------------------------------------------------//
void(entity pet) PM_PetStatus =
{
    // If pet is the world, flash this bug alert and abort.
    if (!pet)
    {
        sprint (self, "WARNING:  pet == world");
        return;
    }

    // NOTE:  Always display status message even if Draco should not talk.

    // Show familiar name and its level.  If no name, abort.
    if (pet == self.draco)
    {
        sprint (self, "ƒÚ·„Ô∫ ");

        local   entity  oself;
        local   float   level;

        oself = self;
        self  = pet;
        level = pet_level ();
        self  = oself;

        // Show level (red triangles)
        if (level == 1)
            sprint (self, "ç ");
        else if (level == 2)
            sprint (self, "çç ");
        else if (level == 3)
            sprint (self, "ççç ");
        else //if (level == 4)
            sprint (self, "çççç ");
    }
    else
    {
        return;
    }

    // Show dragon health/items.  Can be used by any familiar if allowed.
    local   float   points;
    local   string  stat;

    points = PM_ArmoredHealth (pet);
    stat = ftos (points);
    sprint (self, stat);

    // show dragon items (shield for pent, Q for quad)
    if (pet.invincible_finished)
    {
        if (pet.super_damage_finished)
            sprint (self, " É—");
        else
            sprint (self, " É");
    }
    else if (pet.super_damage_finished)
    {
        sprint (self, " —");
    }

    sprint (self, "\n");
};

void() PM_Impulse_102 =
{
    if (PM_PetReady (TRUE))
        PM_PetStatus (self.draco);
};


//==========================================================================
//  Impulse 103:  Stay/Follow

//----------------------------------------------------/ New Code /--------//
//  This checks if the pet dragon is looking for water and if so,
//  lets its master know and TRUE is returned.
//------------------------------------------------------------------------//
float(entity pet) PM_PetNeedWater =
{
    if (pet.enemy)
        if (pet.enemy.classname == "watergoal")
        {
            if (pet == self.draco)
                PM_DracoTalk (pet, "I need water!");
            return TRUE;
        }

    return FALSE;
};

//----------------------------------------------------/ New Code /--------//
//  This commands the dragon to stay or move.
//------------------------------------------------------------------------//
void(entity pet) PM_PetCmdStay =
{
    // Ignore if looking for water.
    if (PM_PetNeedWater (pet))
        return;

    // Do it.
    if (pet == self.draco)
    {
        if (self.petflags & PET_STAY)
        {
            // Since patrol is disabled, make sure it stays disabled.
            self.petflags = self.petflags - (self.petflags & PET_PATROL);

            // Follow!
            self.petflags = self.petflags - PET_STAY;
            if (pet.enemy)
            {
                PM_DracoTalk (pet, "I will follow after the fight.");
            }
            else
            {
                PM_DracoTalk (pet, "I will follow you.");
                if (!(self.petflags & PET_FORCED))
                {
                    pet.nextthink = 0.1;    // ASAP
                    pet.think     = pet.th_walk;
                }
            }
        }
        else
        {
            self.petflags = self.petflags | PET_STAY;
            if (pet.enemy)
            {
                PM_DracoTalk (pet, "I will stay after the fight.");
            }
            else
            {
                PM_DracoTalk (pet, "I will stay.");
                if (!(self.petflags & PET_FORCED))
                {
                    pet.nextthink = 0.1;    // ASAP
                    pet.think     = pet.th_stand;
                }
            }
        }
    }
};

//----------------------------------------------------/ New Code /--------//
//  This commands the dragon to follow or patrol.
//
//  NOTE:  This is OBSOLETE!  It is currently unused.
//------------------------------------------------------------------------//
void(entity pet) PM_PetCmdMove =
{
    // Ignore if looking for water.
    if (PM_PetNeedWater (pet))
        return;

    if (pet == self.draco)
    {
        if (self.petflags & PET_PATROL)
        {
            self.petflags = self.petflags - PET_PATROL;
            PM_DracoTalk (pet, "I will follow you.");
        }
        else
        {
            self.petflags = self.petflags | PET_PATROL;
            PM_DracoTalk (pet, "I will go forward.");
        }

        // The dragon will move again so remove the stop flag.
        if (self.petflags & PET_STAY)
        {
            self.petflags = self.petflags - PET_STAY;
            if ( (!pet.enemy) && (!(self.petflags & PET_FORCED)) )
            {
                pet.nextthink = 0.1;    // ASAP
                pet.think     = pet.th_walk;
            }
        }
    }
};

//----------------------------------------------------/ New Code /--------//
//  This invokes 'stay/move'.
//------------------------------------------------------------------------//
float() PM_AttackMove =
{
    if (PM_PetReady (TRUE))
        PM_PetCmdStay (self.draco);

    return FALSE;
};

void() PM_Impulse_103 =
{
    PM_AttackMove ();
};


//==========================================================================
//  Impulse 104:  Fight/Ignore

//----------------------------------------------------/ New Code /--------//
//  This tells the dragon to stop fighting immediately.
//------------------------------------------------------------------------//
float(entity pet) PM_PetCeaseFire =
{
    if (pet == self.draco)
    {
        if (pet.enemy)
            if (pet.enemy.classname != "watergoal")
            {
                self.petflags = self.petflags | PET_PACIFIST;
                PM_DracoTalk (pet, "I stopped fighting.");
                pet.enemy = world;
                pet.oldenemy = world;

                return TRUE;
            }
    }

    return FALSE;
};

//----------------------------------------------------/ New Code /--------//
//  This commands the dragon to fight or not to fight.
//------------------------------------------------------------------------//
void(entity pet) PM_PetCmdFight =
{
    // Ignore if looking for water.
    if (PM_PetNeedWater (pet))
        return;

    // A dragon with the pacifist flag set will not attack targets.
    if (pet == self.draco)
    {
        if (self.petflags & PET_PACIFIST)
        {
            self.petflags = self.petflags - PET_PACIFIST;
            PM_DracoTalk (pet, "I will fight.");
        }
        else if (!PM_PetCeaseFire (pet))
        {
            self.petflags = self.petflags | PET_PACIFIST;
            PM_DracoTalk (pet, "I will not attack.");
        }
    }
};

//----------------------------------------------------/ New Code /--------//
//  This invokes 'fight/ignore'.
//------------------------------------------------------------------------//
float() PM_AttackCalm =
{
    if (PM_PetReady (TRUE))
        PM_PetCmdFight (self.draco);

    return FALSE;
};

void() PM_Impulse_104 =
{
    PM_AttackCalm ();
};


//==========================================================================
//  Impulse 105:  Target Select

//----------------------------------------------------/ New Code /--------//
//  This prints a monster's name.  If it is a player, print his netname.
//------------------------------------------------------------------------//
void(entity targ) PM_TargetName =
{
    // Other players.
    if (targ.classname == "player")
    {
        sprint (self, targ.netname);
        return;
    }

    // Normal Quake monsters
    if (targ.classname == "monster_army")
        sprint (self, "a grunt");
    else if (targ.classname == "monster_demon1")
        sprint (self, "a fiend");
    else if (targ.classname == "monster_dog")
        sprint (self, "a rottweiler");
    else if (targ.classname == "monster_dragon")
    {
        // Assumes Dragons patch.
        if (targ.skin == SKIN_RED)
            sprint (self, "a red dragon"); 
        else if (targ.skin == SKIN_WHITE)
            sprint (self, "a white dragon"); 
        else if (targ.skin == SKIN_BLUE)
            sprint (self, "a blue dragon"); 
        else if (targ.skin == SKIN_GOLD)
            sprint (self, "a gold dragon"); 
        else
            sprint (self, "a dragon"); 
    }
    else if (targ.classname == "monster_enforcer")
        sprint (self, "an enforcer");
    else if (targ.classname == "monster_fish")
        sprint (self, "a rotfish");
    else if (targ.classname == "monster_hell_knight")
        sprint (self, "a death knight");
    else if (targ.classname == "monster_knight")
        sprint (self, "a knight");
    else if (targ.classname == "monster_ogre")
        sprint (self, "an ogre");
    else if (targ.classname == "monster_shalrath")
        sprint (self, "a vore"); 
    else if (targ.classname == "monster_shambler")
        sprint (self, "a shambler");
    else if (targ.classname == "monster_tarbaby")
        sprint (self, "a spawn");
    else if (targ.classname == "monster_vomit")
        sprint (self, "a vomitus");
    else if (targ.classname == "monster_wizard")
        sprint (self, "a scrag");
    else if (targ.classname == "monster_zombie")
        sprint (self, "a zombie");

    // Zerstorer monsters
    else if (targ.classname == "monster_me")
        sprint (self, "a mega enforcer");
    else if (targ.classname == "monster_troglodyte")
        sprint (self, "a nemesant");
    // NOTE:  Draco won't attack laser turrets.

    // Other miscellaneous monsters
    else if (targ.classname == "monster_cyberdemon")
        sprint (self, "the cyberdemon");
    else if (targ.classname == "monster_snakeman")
        sprint (self, "a snakeman");
    else if (targ.classname == "monster_spider")
        sprint (self, "a spider");

    // Unknown monster
    else 
        sprint (self, "an unknown monster");
};

//----------------------------------------------------/ New Code /--------//
//  This checks if the target is an immortal boss.
//------------------------------------------------------------------------//
float(entity targ) PM_IsBoss =
{
    if (targ.classname == "monster_boss")
        return TRUE;
    if (targ.classname == "monster_oldone")
        return TRUE;

    return FALSE;
};

//----------------------------------------------------/ New Code /--------//
//  This checks if the target found is fightable.  TRUE is returned
//  if the target can be fought, FALSE otherwise.  Note, TRUE does
//  not mean the target is an enemy.
//------------------------------------------------------------------------//
float(entity targ) PM_CanBeFought =
{
    // If target is not a living creature, don't bother checking.
    if (targ.solid != SOLID_SLIDEBOX)
        return FALSE;

    // If target is dead, don't bother checking.
    if (targ.health <= 0)
        return FALSE;

    // If target is undetectable, don't bother checking.
    if (targ.flags & FL_NOTARGET)
        return FALSE;

    // Treat bosses a possible targets, even if immune to damage.
    if (PM_IsBoss (targ))
        return TRUE;

    // Don't fight targets immune to damage.
    if (!targ.takedamage)
    {
        // Exception:  Zerstorer's mega enforcer uses shields,
        // and is not always immune to damage.
        if (targ.classname == "monster_me")
            return TRUE;

        return FALSE;
    }

    // Monsters are fightable.
    if (targ.flags & FL_MONSTER)
        return TRUE;

    // Players are fightable.
    if (targ.classname == "player")
        return TRUE;

    // No target found.
    return FALSE;
};

//----------------------------------------------------/ New Code /--------//
//  This checks if the target given is an enemy.
//------------------------------------------------------------------------//
float(entity targ, entity pet) PM_TargetIsEnemy =
{
    // Treat bosses as enemies.
    if (PM_IsBoss (targ))
        return TRUE;

    // Pet dragon will attack any monster that is a bad guy.
    if (targ.flags & FL_MONSTER)
    {
        // Cannot attack itself.
        if (targ == pet)
            return FALSE;

        // Check if target is a good guy.
        if (PM_IsPetAlly (targ, pet))
            return FALSE;

        // Bad guy!
        return TRUE;
    }

    // Attack another player if he is an enemy.
    if (targ.classname == "player")
    {
        if (PM_PlayerOnSameTeam (targ, pet.master))
            return FALSE;

        // Player is an enemy.
        return TRUE;
    }

    // Not a target.
    return FALSE;
};

//----------------------------------------------------/ New Code /--------//
//  This checks if the dragon will attack the target given.
//------------------------------------------------------------------------//
float(entity targ, entity pet) PM_AttackPetTarget =
{
    local   float   msg_draco;

    msg_draco = (pet == self.draco);

    // If target is already the dragon's enemy, do nothing.
    if (targ == pet.enemy)
    {
        if (msg_draco)
            PM_DracoTalk (pet, "That is my current target.");
        return FALSE;
    }

    // Bosses cannot be killed by normal means.
    if (targ.classname == "monster_boss")
    {
        if (msg_draco)
            PM_DracoTalk (pet, "I cannot kill Chthon.");
        return FALSE;
    }
    if (targ.classname == "monster_oldone")
    {
        if (msg_draco)
            PM_DracoTalk (pet, "I cannot kill Shub-Niggurath.");
        return FALSE;
    }

    // Pet dragon will attack any monster that is a bad guy.
    if (targ.flags & FL_MONSTER)
    {
        if (targ == pet)
        {
            // Cannot attack itself.
            if (msg_draco)
                PM_DracoTalk (pet, "That is me.");
            return FALSE;
        }
        if (targ.master.classname == "player")
        {
            // Target is familiar owned by another player.
            if (PM_PlayerOnSameTeam (targ.master, pet.master))
            {
                if (msg_draco)
                {
                    if (targ.master == self)
                        PM_DracoTalk (pet, "That is one of your familiars.");
                    else
                        PM_DracoTalk (pet, "That is a friend's familiars.");
                }
                return FALSE;
            }
        }
        if (PM_IsPetAlly (targ, pet))
        {
            // Target is an unknown good guy.
            if (msg_draco)
                PM_DracoTalk (pet, "Target is not evil.");
            return FALSE;
        }

        // Special case:  Zer's mega enforcer.
        if (!targ.takedamage)
            if (targ.classname == "monster_me")
            {
                if (msg_draco)
                    PM_DracoTalk (pet, "Can't -- shields are on.");
                return FALSE;
            }

        // Bad guy, bad guy!
        return TRUE;
    }

    // Attack another player if he is an enemy.
    if (targ.classname == "player")
    {
        if (PM_PlayerOnSameTeam (targ, pet.master))
        {
            // Cannot attack friendly players.
            if (msg_draco)
            {
                if (targ == pet.master)
                    PM_DracoTalk (pet, "I will not fight you.");
                else
                    PM_DracoTalk (pet, "I will not attack an ally.");
            }
            return FALSE;
        }

        // Player is an enemy.
        return TRUE;
    }

    // Unknown target.  Shouldn't make it this far.
    if (msg_draco)
        PM_DracoTalk (pet, "What?!");
    return FALSE;
};

//----------------------------------------------------/ New Code /--------//
//  This checkes all entities within the player's field of vision.
//  If a target exists, the one closest to the center is taken.
//------------------------------------------------------------------------//
entity(entity pet) PM_PetSearchAll =
{
    local   entity  head;
    local   entity  best;
    local   float   dot, best_dot;
    local   vector  start, end;

    best = world;
    best_dot = 0.7071;  // This is cos 45@.  Player's FOV = 90@.
    start = pet.master.origin + pet.master.view_ofs;

    head = nextent(world);
    while (head)
    {
        if (head != pet.master)
        {
            dot = PM_DotTarget (head, pet.master);
            if (dot >= best_dot)
            {
                end = head.origin + head.view_ofs;
                if (PM_PathClear (start, end, pet.master))
                    if (PM_CanBeFought (head))
                        if (PM_TargetIsEnemy (head, pet))
                        {
                            // Update prime target.
                            best = head;
                            best_dot = dot;
                        }
            }
        }
        head = nextent(head);
    }

    return best;
};

//----------------------------------------------------/ New Code /--------//
//  This return the target, if any, the player is aiming at.
//  Not all entities are considered targets.
//------------------------------------------------------------------------//
entity(entity pet) PM_AimSearch =
{
    local   vector  p1, p2;
    local   vector  org;
    local   vector  dir;
    local   entity  targ;

    // Find where the player is pointing at.
    p1 = self.origin + self.view_ofs;
    org = pet.origin + pet.view_ofs;
    dir = aim (self, 100000);
    p2 = p1 + dir*8192;
    traceline (p1, p2, FALSE, self);

    targ = trace_ent;

    if (!targ)
        return world;   // No target.

    if (targ == pet.enemy)
        return targ;

    // If player aims at an enemy, take it.
    if (PM_CanBeFought (targ))
        if (PM_TargetIsEnemy (targ, pet))
            return targ;

    // Not a target.
    return world;
};

//----------------------------------------------------/ New Code /--------//
//  This tells the dragon to attack a target in its master's FOV.
//  The target closest to the center of the player's FOV, if any,
//  is selected.  The dragon may or may not attack it, and give a
//  reason why.
//------------------------------------------------------------------------//
void(entity pet) PM_AttackThing =
{
    // Ignore if looking for water.
    if (PM_PetNeedWater (pet))
        return;

    // Stop fighting if attacking while in pacifist mode.
    if (pet.enemy)
    {
        if (pet == self.draco)
            if (self.petflags & PET_PACIFIST)
            {
                PM_PetCeaseFire (pet);
                return;
            }
    }

    // Player must see Draco for this to work.
    if (PM_PetOutOfSight (pet))
    {
        if (pet == self.draco)
            sprint (self, "You must be able to see Draco to order an attack.\n");
        return;
    }

    local   entity  targ;

    // Try to get the target closest to the center of the player's FOV.
    targ = PM_AimSearch (pet);
    if (!targ)
        targ = PM_PetSearchAll (pet);

    if (!targ)
    {
        if (pet == self.draco)
            PM_DracoTalk (pet, "No one to fight.");
        return;
    }

    if (!PM_EntIsVisible (targ, pet, FALSE))
    {
        if (pet == self.draco)
            PM_DracoTalk (pet, "I cannot see your target.");
        return;
    }

    if (!PM_AttackPetTarget (targ, pet))
        return;     // Target is refused.

    // We found a target, so attack it!
    if (!PM_NoPetTalk (pet))
    {
        // Display attack message.
        if (pet == self.draco)
        {
            if (pet.enemy.classname == "watergoal")
                sprint (self, "ƒÚ·„Ô∫ I will attack ");
            else
                sprint (self, "ƒÚ·„Ô∫ I am attacking ");
            PM_TargetName (targ);
            sprint (self, ".\n");
        }
    }

    pet.nextthink = 0.1;    // ASAP
    if (pet.enemy.classname == "watergoal")
    {
        pet.oldenemy = targ;
        pet.think = PM_FoundSecondary;
    }
    else
    {
        pet.enemy = targ;
        pet.think = FoundTarget;
    }
};

//----------------------------------------------------/ New Code /--------//
//  This tells the dragon to attack a hostile target, if any, in its
//  master's field of vision.
//
//  If rapid-fire should be disrupted, FALSE is returned.
//  Rapid-fire should end if the dragon could talk at each frame.
//
//  Currently, the dragon (should) talk after each use of this
//  function, and FALSE is always returned.
//------------------------------------------------------------------------//
float() PM_AttackTarget =
{
    if (PM_PetReady (TRUE))
        PM_AttackThing (self.draco);

    return FALSE;
};

void() PM_Impulse_105 =
{
    PM_AttackTarget ();
};


//==========================================================================
//  Impulse 106:  Forced Shooting

//----------------------------------------------------/ New Code /--------//
//  This checks if the dragon's projectile attack is impractical
//  to use underwater (i.e. fire or lightning).
//------------------------------------------------------------------------//
float(entity pet) PM_PetNoShot =
{
    // Blue dragons will discharge if invulnerable.
    if (pet.skin == SKIN_BLUE)
    {
        // Protected by pentagram.
        if (self.invincible_finished >= (time + 3))
            return FALSE;

        // Shiva equals nopain.
        if (pet == pet.master.draco)
            if (pet.master.petflags & PET_SHIVA)
                if (pet.health >= pet.max_health)
                    return FALSE;
    }

    // Check if it can shoot.
    return PM_DragonNoShot (pet);
};

//----------------------------------------------------/ New Code /--------//
//  This checks if the dragon is in the middle of an attack.
//------------------------------------------------------------------------//
float(entity pet) PM_PetAttacking =
{
    // Check if in attack frames.  See 'pet.qc' for frame info.
    if (pet.frame >= 8)
        if (pet.frame <= 16)
            return TRUE;

    // If no enemy, ignore attack states.
    if (!pet.enemy)
        return FALSE;

    // Check if getting ready to start an attack.
    if (pet.attack_state == AS_MELEE)
        return TRUE;
    if (pet.attack_state == AS_MISSILE)
        return TRUE;

    // Not attacking.
    return FALSE;
};

//----------------------------------------------------/ New Code /--------//
//  This checks if the dragon has a clear shot.
//------------------------------------------------------------------------//
float(entity pet) PM_PetClearShot =
{
    local   vector  p1, p2;
    local   vector  org;

    p1 = self.origin + self.view_ofs;
    org = pet.origin + pet.view_ofs;

    makevectors(self.v_angle);
    p2 = p1 + v_forward*8192;
    traceline (p1, p2, FALSE, self);
    traceline (org, trace_endpos, TRUE, pet);
    if (trace_fraction < 1)
    {
        if (pet == self.draco)
            PM_DracoTalk (pet, "I do not have a clear shot.");
        return FALSE;
    }

    // Check if master is in the way.
    traceline (org, p2, FALSE, pet);
    if (trace_ent == self)
    {
        // Dragon will not shoot at it's master back.
        if (pet == self.draco)
            PM_DracoTalk (pet, "You are blocking my shot!");
        return FALSE;
    }

    // Forget whatever opponents the dragon was fighting.
    if (pet.enemy)
        PM_PetInstantCalm (pet);

    // All clear -- will begin to shoot.
    if (pet == self.draco)
        self.petflags = self.petflags | PET_FORCED;

    return TRUE;
};

//----------------------------------------------------/ New Code /--------//
//  This tells the dragon to fire its breath weapon if possible.
//  If the dragon cannot shoot, it gives a reason why.
//------------------------------------------------------------------------//
float(entity pet) PM_ForceShoot =
{
    // Ignore if looking for water.
    if (PM_PetNeedWater (pet))
        return FALSE;

    // Not in combat, so check if it can shoot.
    if (self.petflags & PET_FORCED)
        return TRUE;    // Already shooting; ignore and do not talk.

    // Must see player to shoot.
    if (PM_PetOutOfSight (pet))
    {
        if (pet == self.draco)
            sprint (self, "You must be able to see Draco to order an attack.\n");
        return;
    }

    if (PM_PetNoShot (pet))
    {
        // Dragon refuses to shoot.
        if (pet == self.draco)
            PM_DracoTalk (pet, "NO!");
        return FALSE;
    }

    if (PM_PetAttacking (pet))
    {
        // Dragon is locked in combat.
        if (pet == self.draco)
            PM_DracoTalk (pet, "Can't -- already attacking.");
        return FALSE;
    }

    return PM_PetClearShot (pet);
};

//----------------------------------------------------/ New Code /--------//
//  This tells the dragon to fire its breath weapon if possible.
//
//  If rapid-fire should be disrupted, FALSE is returned.
//  Rapid-fire should end if the dragon could talk at each frame.
//------------------------------------------------------------------------//
float() PM_AttackShoot =
{
    if (PM_PetReady (TRUE))
        if (PM_ForceShoot (self.draco))
            return TRUE;

    return FALSE;
};

void() PM_Impulse_106 =
{
    PM_AttackShoot ();
};


//==========================================================================
//  Impulse 107:  Teleport Familiar

//----------------------------------------------------/ New Code /--------//
//  This commands the dragon to teleport near its master.
//------------------------------------------------------------------------//
float(entity pet) PM_PetCmdWarp =
{
    if (pet.health <= COST_PET_TELEPORT)
    {
        if (pet == self.draco)
            PM_DracoTalk (pet, "I am too weak to teleport.");
        return FALSE;
    }

    if (PM_PetComeHere (pet, TRUE))
    {
        // Teleport is a success.
        if (pet.health > COST_PET_TELEPORT)
            pet.health = pet.health - COST_PET_TELEPORT;
        else
            pet.health = 1;     // This should not happen.
        return TRUE;
    }

    // Failed...
    if (pet == self.draco)
        PM_DracoTalk (pet, "Teleport attempt failed.");
    return FALSE;
};

void() PM_Impulse_107 =
{
    if (PM_PetReady (TRUE))
        PM_PetCmdWarp (self.draco);
};


//==========================================================================
//  Impulse 108:  Cheat -- Patrol

//----------------------------------------------------/ New Code /--------//
//  This changes the command given by the attack button.
//------------------------------------------------------------------------//
void(float add) PM_ChangeOption =
{
    local   float   type;

    type = (self.petflags & PET_CMDALL) / PET_CMD1;

    if (add)
    {
        type = type + 1;
        if (type > 3)
            type = 0;
    }
    else
    {
        type = type - 1;
        if (type < 0)
            type = 3;
    }

    self.petflags = self.petflags - (self.petflags & PET_CMDALL);
    self.petflags = self.petflags | (type * PET_CMD1);

    // Display message.
    if (type == ATK_MISSILE)
        sprint (self, "Command set to:  Shoot\n");
    else if (type == ATK_TARGET)
        sprint (self, "Command set to:  Target\n");
    else if (type == ATK_FIGHT)
        sprint (self, "Command set to:  Fight/Ignore\n");
    else if (type == ATK_STAY)
        sprint (self, "Command set to:  Stay/Follow\n");
    else
        sprint (self, "Unknown command setting.\n");
};

void() PM_Impulse_108 =
{
    if (PM_PetReady (FALSE))
        PM_ChangeOption (FALSE);
};


//==========================================================================
//  Impulse 109:  Cheat -- Dragon Powerup

//----------------------------------------------------/ New Code /--------//
//  This cheat spawns a dragon.
//------------------------------------------------------------------------//
void() PM_PetCmdSpawn =
{
    local   float   type;

    type = self.petflags & PET_SKIN;
    if ((self.petflags & PET_ALIVE) >= PET_LEVELMAX)
    {
        PM_RechargeDraco (self, type);
        PM_SpawnPet (self, FALSE, type);
        return;
    }

    PM_PowerupDraco (self, type, 1);
};

void() PM_Impulse_109 =
{
    sprint (self, "Cheat:  Dragon powerup\n");
    PM_PetCmdSpawn ();
};


//==========================================================================
//  Impulse 110:  Cheat -- Skin Change

//----------------------------------------------------/ New Code /--------//
//  This cheat changes the dragon's skin.
//------------------------------------------------------------------------//
void(entity pet) PM_PetCmdSkinChange =
{
    local   float   type;

    type = pet.skin + 1;
    if (type > 3)
        type = 0;

    PM_RechargeDraco (self, type);
};

void() PM_Impulse_110 =
{
    sprint (self, "Cheat:  Skin change\n");
    if (PM_PetReady (FALSE))
        PM_PetCmdSkinChange (self.draco);
};


//==========================================================================
//  Impulse 111:  Cheat -- Shiva

//----------------------------------------------------/ New Code /--------//
//  This cheat gives a dragon great power.
//------------------------------------------------------------------------//
void(entity pet) PM_PetCmdShiva =
{
    // A dragon with the Shiva flag gains great power and immortality.
    if (pet == self.draco)
    {
        if (self.petflags & PET_SHIVA)
        {
            self.petflags = self.petflags - PET_SHIVA;
            sprint (self, "Draco is mortal.\n");
        }
        else
        {
            pet.health = pet.max_health;
            PM_DragonAddArmor (pet, 0);
            self.petflags = self.petflags | PET_SHIVA;
            sprint (self, "Draco is Death incarnate!\n");
        }
    }
};

//  SHIVA! -- Great strength and immortality.
void() PM_Impulse_111 =
{
    sprint (self, "Cheat:  Shiva\n");
    if (PM_PetReady (FALSE))
        PM_PetCmdShiva (self.draco);
};


//==========================================================================
//  Impulse 112:  Cheat -- Kill familiars

void() PM_Impulse_112 =
{
    sprint (self, "Cheat:  Kill familiars\n");
    PM_KillAllPets (self, FALSE);
};


//==========================================================================
//  Impulse 113:  Cheat -- Evil familiars

//----------------------------------------------------/ New Code /--------//
//  This causes a familiar to go mad and attack its master.
//------------------------------------------------------------------------//
float(entity pet) PM_PetTurn =
{
    if (PM_PetGoneBad (pet))
        return FALSE;   // Already evil.
    if (PM_PetHiding (pet))
        return FALSE;   // Not available.
    if (pet.enemy.classname == "watergoal")
        return FALSE;   // Can't change enemy now.

    // Turn the familiar against its master.
    pet.enemy = pet.master;
    pet.nextthink = 0.1;    // ASAP
    pet.think = FoundTarget;

    return TRUE;
};

//----------------------------------------------------/ New Code /--------//
//  This causes all familiars to turn on their master.
//------------------------------------------------------------------------//
void() PM_TurnAllFamiliars =
{
    local   entity  head;
    local   float   turned;

    turned = 0;

    head = find (world, classname, "monster_dragon");
    while (head)
    {
        if (head.master == self)
            if (PM_PetTurn (head))
                turned = turned + 1;
        head = find (head, classname, "monster_dragon");
    }

    if (turned)
        sprint (self, "Your dragons turned on you!\n");
};

void() PM_Impulse_113 =
{
    sprint (self, "Cheat:  Evil familiars\n");
    PM_TurnAllFamiliars ();
};


//==========================================================================
//  Impulse 114:  Cheat -- Burn familiars

void() PM_Impulse_114 =
{
    // BURN -- Debugging only
    sprint (self, "Cheat:  Burn familiars\n");

    local   entity  head;

    head = find (world, classname, "monster_dragon");
    while (head)
    {
        if (head.master == self)
            PM_Ignite (head, head, DMG_ONFIRE);
        head = find (head, classname, "monster_dragon");
    }
};


//==========================================================================
//  Impulse 115:  Cheat -- Count Dragons

//----------------------------------------------------/ New Code /--------//
//  This counts the number of dragons a player owns.
//------------------------------------------------------------------------//
float() PM_PetCountSelf =
{
    local   float   petcount;
    local   entity  head;

    petcount = 0;
    head = find (world, classname, "monster_dragon");
    while (head)
    {
        if (head.master == self)
            petcount = petcount + 1;
        head = find (head, classname, "monster_dragon");
    }

    if (petcount == 0)
    {
        sprint (self, "You have no dragons.\n");
    }
    else if (petcount == 1)
    {
        sprint (self, "You have 1 dragon.\n");
    }
    else
    {
        local   string  petstring;

        petstring = ftos (petcount);
        sprint (self, "You have ");
        sprint (self, petstring);
        sprint (self, " dragons.\n");
    }

    return petcount;
};

//----------------------------------------------------/ New Code /--------//
//  This counts the number of familiars on the level.
//------------------------------------------------------------------------//
float() PM_PetCountAll =
{
    local   float   petcount;
    local   entity  head;

    // Count all the minors.
    petcount = ryucount;

    // Count all the Dracos.
    head = find (world, classname, "player");
    while (head != world)
    {
        if (head.petflags & PET_ALIVE)
            petcount = petcount + 1;
        head = find (head, classname, "player");
    }

    // Data is in the format:  (minors)/(all).
    local   string  petstring;

    sprint (self, "Familiar count:  ");
    petstring = ftos (ryucount);
    sprint (self, petstring);
    sprint (self, "/");
    petstring = ftos (petcount);
    sprint (self, petstring);
    sprint (self, "\n");

    return petcount;
};

void() PM_Impulse_115 =
{
    PM_PetCountAll ();
    PM_PetCountSelf ();
};


//==========================================================================
//  Impulse Commands

//----------------------------------------------------/ New Code /--------//
//  This commands the player's dragon via impulse.
//  Impulses that are currently used are:
//
//  NORMAL --
//  101 = This selects Draco as a weapon.
//  102 = This shows Draco's level, health, and items.
//  103 = Tells Draco to stay or move.  Does not work if fighting.
//  104 = Tells Draco to attack monsters on sight or ignore them.
//  105 = Tells Draco to attack a monster within its master's FOV.
//  106 = Tells Draco to shoot.  Will forget the enemy if necessary.
//  107 = This teleports Draco to its master.  Costs Draco 20 health.
//  108 = This changes the command given via attack button.
//  CHEATS (Powerups) --
//  109 = This spawns Draco or powers it up.
//  110 = This changes the skin of Draco.
//  111 = This puts Draco in or out of Shiva mode.
//  CHEATS (Developer) --
//  112 = This kills all dragons immediately.
//  113 = This causes all dragons to turn on their master.
//  114 = This sets all dragons on fire.
//  115 = This counts how many dragons a player has.
//------------------------------------------------------------------------//
void() PM_DragonImpulse =
{
    if (self.impulse == 101)
    {
        PM_Impulse_101 ();
        return;
    }
    if (self.impulse == 102)
    {
        PM_Impulse_102 ();
        return;
    }
    if (self.impulse == 103)
    {
        PM_Impulse_103 ();
        return;
    }
    if (self.impulse == 104)
    {
        PM_Impulse_104 ();
        return;
    }
    if (self.impulse == 105)
    {
        PM_Impulse_105 ();
        return;
    }
    if (self.impulse == 106)
    {
        PM_Impulse_106 ();
        return;
    }
    if (self.impulse == 107)
    {
        PM_Impulse_107 ();
        return;
    }
    if (self.impulse == 108)
    {
        PM_Impulse_108 ();
        return;
    }

    // The rest are cheats.
    if (coop)
        return;
    if (deathmatch)
        return;

    if (self.impulse == 109)
    {
        PM_Impulse_109 ();
        return;
    }
    if (self.impulse == 110)
    {
        PM_Impulse_110 ();
        return;
    }
    if (self.impulse == 111)
    {
        PM_Impulse_111 ();
        return;
    }
    if (self.impulse == 112)
    {
        PM_Impulse_112 ();
        return;
    }
    if (self.impulse == 113)
    {
        PM_Impulse_113 ();
        return;
    }
    if (self.impulse == 114)
    {
        PM_Impulse_114 ();
        return;
    }
    if (self.impulse == 115)
    {
        PM_Impulse_115 ();
        return;
    }
};


//==========================================================================
//  Rapid Fire

//----------------------------------------------------/ New Code /--------//
//  This dictates if the player is allowed to use rapid fire.
//  The field '.aflag' is used.  If the value of it is...
//
//  FALSE = Player can maintain rapid-fire.
//  TRUE  = Player must let go of fire button before he can attack again.
//------------------------------------------------------------------------//
void(entity client, float nofire) PM_StopRapidFire =
{
    client.aflag = nofire;
};

//----------------------------------------------------/ New Code /--------//
//  This checks if the player is allowed to use rapid fire.
//------------------------------------------------------------------------//
float(entity client) PM_UseRapidFire =
{
    return !client.aflag;
};


//==========================================================================
//  Dragon Weapon Attack/Control

//----------------------------------------------------/ New Code /--------//
//  This commands the dragon via the attack button.  Currently,
//  the command given depends on the situation.
//
//  If rapid-fire should be disrupted, FALSE is returned.
//  Rapid-fire should end if the dragon could talk at each frame.
//
//  All commands except shoot should always return FALSE.
//------------------------------------------------------------------------//
float() PM_AttackOption =
{
    if (!PM_PetReady (TRUE))
        return FALSE;

    // May command only Draco.
    local   entity  pet;
    local   float   cmd;

    pet = self.draco;

    if (self.petflags & PET_FORCED)
        return TRUE;    // Already shooting; ignore and do not talk.

    cmd = (self.petflags & PET_CMDALL) / PET_CMD1;

    if (cmd == ATK_STAY)
        return PM_AttackMove();
    if (cmd == ATK_FIGHT)
        return PM_AttackCalm();

    // The remaining commands require a direct line from Draco to his
    // master.
    if (PM_PetOutOfSight (pet))
    {
        // Teleport Draco to player if separated.
        PM_PetCmdWarp (pet);
        return FALSE;
    }

    if (cmd == ATK_TARGET)
        return PM_AttackTarget();
    return PM_AttackShoot();
};

//----------------------------------------------------/ New Code /--------//
//  This checks if the player is using the attack button to command
//  the dragon to attack.  TRUE is returned if player tried to command
//  at least one dragon to attack.
//------------------------------------------------------------------------//
float() PM_CheckPetAttack =
{
    // Abort if dragons are not selected as weapon.
    if (!(self.petflags & PET_CONTROL))
        return FALSE;

    // If dragon is dead, switch to another weapon.
    if (!(self.petflags & PET_ALIVE))
    {
        // Disable control.
        self.petflags = self.petflags - PET_CONTROL;

        // Change weapons.
        self.weapon = W_BestWeapon ();
        W_SetCurrentAmmo ();
        return FALSE;
    }

    local   float   abort;
    local   float   attacked;

    abort = FALSE;
    attacked = 0;

    if (self.petflags & PET_ALIVE)
    {
        if (PM_UseRapidFire (self))
        {
            if (!PM_AttackOption ())
                abort = TRUE;
        }
        attacked = attacked + 1;
    }

    if (abort)
        PM_StopRapidFire (self, TRUE);

    return attacked;
};


//===========================/  END OF FILE  /===========================//

//==========================================================================
//  death.qc
//--------------------------------------------------------------------------
//  Place this file before 'combat.qc', or whatever its name is.
//==========================================================================

// Speaks for itself.  Called after ClientObituary.
// Sometimes, we want to change deathtype so we don't need to
// check for a bunch of deathtypes when its time to decide how
// the target dies (i.e., decapitation, shattering, etc).
void(entity targ) ChangeDeathtype =
{
    if (targ.deathtype == "Buriza")
    {
        targ.deathtype = "frozen";
        return;
    }

    if (targ.th_gib)
    {
        if (targ.deathtype == "axe_decap1")
            targ.deathtype = "decap_cut";
        else if (targ.deathtype == "vorpal")    // Bane kill someone?
            targ.deathtype = "decap_cut";
        else if (multi_headinjury >= 25)        // Head blown off by shotgun?
        {
            targ.deathtype = "decap_pop";
            // FIXME:  Resetting the trauma global here is a stopgap until I
            // locate where this fails to clear at times.
            multi_headinjury = 0;
        }
        else
        {
            if (targ.health >= targ.gib_health)
            {   // Not gibbed!
                if (targ.deathtype == "axe_decap2")
                    targ.deathtype = "decap_pop";   // Yo' head aesplode!
                else if (targ.deathtype == "hammer_decap")
                    targ.deathtype = "decap_pop";
                else if (targ.deathtype == "saw_decap")
                    targ.deathtype = "decap_cut";
            }
            else
            {
                if (targ.deathtype == "ice")
                    targ.deathtype = "frozen";
            }
        }
    }
};

// This adds frags to an entity *IF* there is an entity to give frags to.
// This is insurance that Quake will not add frags to the world.  Attempts
// to do so will crash the game and dump all clients to the console.
//
// Also, any subtraction never lowers frags below zero.  This is because
// negative frags encourages powergamers to disconnect then reconnect to
// raise a negative score to zero.  Besides, a negative score on a scoreboard
// is an eyesore.
void(entity e, float add) Frags_Add =
{
    if (e)
    {
        e.frags = e.frags + add;
        if (e.frags < 0)
            e.frags = 0;
    }
};

//===========
// ClientObituary
//
// called when a player dies
// PM:  This is one HUGE function.  So huge it needs its own file.
//============
void(entity targ, entity attacker) ClientObituary =
{
    if (targ.classname != "player")
        return;
// DISABLED -- Test for monsters.
//    if (targ.flags & FL_MONSTER)  if (!targ.netname)  targ.netname = "enemy";

    local   float   rnum;
    local   string  deathstring, deathstring2, dtype;

    dtype = targ.deathtype;
    rnum = random();

// Death by telefrag.
    if (attacker.classname == "teledeath")
    {
        if (dtype == "td_double")
        {
            bprint (targ.netname);
            bprint (" was crushed by Satan's power\n");
            Frags_Add (targ, -1);
            return;
        }
        if (dtype == "td_reflect")
        {
            bprint ("Satan's power deflects ");
            bprint (targ.netname);
            bprint ("'s telefrag\n");
            Frags_Add (targ, -1);
            return;
        }
        if (dtype == "td_reflect_me")
        {   // Tried to telefrag a shielded mega enforcer.
            bprint (targ.netname);
            bprint ("'s telefrag was deflected\n");
            Frags_Add (targ, -1);
            return;
        }
        if ((attacker.owner.classname != "player") || (targ == attacker.owner))
        {   // Telefragged by monster or other NPC?
            bprint (targ.netname);
            bprint (" was telefragged\n");
            Frags_Add (targ, -1);
            return;
        }
        bprint (targ.netname);
        bprint (" was telefragged by ");
        bprint (attacker.owner.netname);
        bprint ("\n");
        if (Team_Match (targ, attacker.owner))
            Frags_Add (attacker.owner, -1);
        else
            Frags_Add (attacker.owner, 1);
        return;
    }
// Death by another player.
    if (attacker.classname == "player")
    {
        if (targ == attacker)
        {
            // killed self
            Frags_Add (attacker, -1);
            bprint (targ.netname);
                
            if (dtype == "discharge")
            {
                if (targ.h2otype == CONTENT_WATER)
                    bprint (" discharges into the water\n");
                else if (targ.h2otype == CONTENT_SLIME)
                    bprint (" discharges into the slime\n");
                else if (targ.h2otype == CONTENT_LAVA)
                    bprint (" discharges into the lava\n");
//                else if (rnum < 0.5)
//                    bprint (" blew his mind... and everything else\n");
                else
                    bprint (" discharged\n");
            }
            else if (dtype == "fire")
            {   // Removed " became toast\n" and " went down in a blaze\n".
                bprint (" played with fire\n");
            }
            else if (dtype == "grenade")
            {
                if (rnum < 0.5)
                    bprint (" tries to put the pin back in\n");
                else
                    bprint (" tripped on his own grenade\n");
            }
            else if (dtype == "mirv")
            {
//                if (targ.v_angle_x >= 60)   // reversed pitch
//                    bprint (" tried to rocket jump\n");
//                else
//                    bprint (" stood too close to the fireworks\n");
                bprint (" should have used a smaller gun\n");
            }
            else if (dtype == "explo_box")
                bprint (" blew up\n");
//            else if (dtype == "firebomb")
//                bprint (" fell apart\n");
            else if (dtype == "Mjolnir")
                bprint (" couldn't control Thor's power\n");
            else if (dtype == "laser")
                bprint (" saw the light\n");
//            else if (dtype == "plasma")
//                bprint (" melted\n");
            else if (dtype == "BloodCube")
                bprint (" was betrayed by the Sanguinoch\n");
            else if ((rnum < 0.25) && (dtype == "rocket"))
                bprint (" blew himself up\n");
            else if (rnum < 0.5)
                bprint (" becomes bored with life\n");
//            else if (rnum < 0.75)
//                bprint (" checks if his weapon is loaded\n");
            else
                bprint (" was his own worst enemy\n");
            return;
        }
        else if (Team_Match (targ, attacker))
        {
            if (rnum < 0.25)
                deathstring = " mows down a teammate\n";
            else if (rnum < 0.50)
                deathstring = " checks his glasses\n";
            else if (rnum < 0.75)
                deathstring = " gets a frag for the other team\n";
            else
                deathstring = " loses another friend\n";
            bprint (attacker.netname);
            bprint (deathstring);
            Frags_Add (attacker, -1);
            return;
        }
        else
        {
            Frags_Add (attacker, 1);

            if ((dtype == "axe") || (dtype == "axe_decap1") || (dtype == "axe_decap2"))
            {   // Removed 'axe-murdered' because weapon may be a sword.
                deathstring = " was hacked-and-slashed by ";
                deathstring2 = "\n";
            }
            else if ((dtype == "chainsaw") || (dtype == "saw_decap"))
            {
                deathstring = " was chainsaw-massacred by ";
                deathstring2 = "\n";
            }
//            else if (dtype == "mace")
//            {
//                deathstring = " got ";
//                deathstring2 = "'s mace in the face\n";
//            }
            else if (dtype == "shotgun")
            {
                if (rnum < 0.5)
                {
                    deathstring = " chewed on ";
                    deathstring2 = "'s boomstick\n";
                }
                else
                {
                    deathstring = " was gunned down by ";
                    deathstring2 = "\n";
                }
            }
            else if (dtype == "ssg")
            {
                if (rnum < 0.5)
                {
                    deathstring = " ate 2 loads of ";
                    deathstring2 = "'s buckshot\n";
                }
                else
                {
                    deathstring = " took both barrels from ";
                    deathstring2 = "\n";
                }
            }
//            else if (dtype == "autosg")
//            {
//                deathstring = " got hosed down by ";
//                deathstring2 = "\n";
//            }
            else if (dtype == "spike")
            {
                deathstring = " was nailed by ";
                deathstring2 = "\n";
            }
            else if (dtype == "spike2")
            {
                if (rnum < 0.5)
                    deathstring = " was perforated by ";
                else
                    deathstring = " was punctured by ";
                deathstring2 = "\n";
            }
            else if (dtype == "grenade")
            {
                if (targ.health < targ.gib_health)
                {
                    if (rnum < 0.5)
                        deathstring = " was gibbed by ";
                    else
                        deathstring = " was popped by ";
                    deathstring2 = "'s grenade\n";
                }
                else if (rnum < 0.5)
                {
                    deathstring = " eats ";
                    deathstring2 = "'s pineapple\n";
                }
                else
                {
                    deathstring = " caught ";
                    deathstring2 = "'s grenade\n";
                }
            }
            else if (dtype == "rocket")
            {
                if (targ.health < targ.gib_health)
                {
                    if (attacker.super_damage_finished)
                    {
                        deathstring2 = "'s quad rocket\n";
                        if (rnum < 0.3)
                            deathstring = " was brutalized by ";
                        else if (rnum < 0.6)
                            deathstring = " was smeared by ";
                        else
                        {
                            bprint (attacker.netname);
                            bprint (" rips ");
                            bprint (targ.netname);
                            bprint (" a new one\n");
                            return;
                        }
                    }
                    else
                    {
                        if (rnum < 0.5)
                            deathstring = " was exploded by ";
                        else
                            deathstring = " was gibbed by ";
                        deathstring2 = "'s rocket\n" ;
                    }
                }
                else
                {
                    if (rnum < 0.5)
                        deathstring = " eats ";     // Quake2 uses 'ate'.
                    else
                        deathstring = " rides ";
                    deathstring2 = "'s rocket\n";
                }
            }
            else if (dtype == "thunderbolt")    // FIXME:  Rename to shaft.
            {
                if (rnum < 0.5)
                {
                    deathstring = " accepts ";
                    deathstring2 = "'s shaft\n";
                }
//                else
//                {   // Quake3 obit.
//                    deathstring = " was electrocuted by ";
//                    deathstring2 = "\n";
//                }
                else
                {
                    deathstring = " was shafted by ";
                    deathstring2 = "\n";
                }
            }
            else if (dtype == "discharge")
            {
                if (rnum < 0.333)
                    deathstring = " accepts ";
                else if (rnum < 0.666)
                    deathstring = " was electrocuted by ";
                else
                    deathstring = " was shocked by ";
                deathstring2 = "'s discharge\n";
            }
            else if (dtype == "deathray")
            {
                deathstring = " was fried by ";     // Was "disintegrated".
                deathstring2 = "\n";    //'s death ray\n";
            }
            else if (dtype == "laser")
            {
                if (rnum < 0.25)
                    deathstring = " saw the light from ";
                else if (rnum < 0.5)
                    deathstring = " was blasted by ";
                else if (rnum < 0.75)
                    deathstring = " was radiated by ";
                else
                    deathstring = " was toasted by ";
                deathstring2 = "'s laser\n";
            }
// DISABLED -- Proximity gun replaced by drill bomber.
/*
            else if (dtype == "proximity_grenade")
            {
                if (rnum < 0.5)
                    deathstring = " got too friendly with ";
                else
                    deathstring = " did the rhumba with ";
                deathstring2 = "'s bomb\n";
            }
            else if (dtype == "spike_trap")
            {   // ToP proxy bombs -- direct hit.
                deathstring = " was lowballed by ";
                deathstring2 = "'s spike trap\n";
            }
            else if (dtype == "trapspike")
            {   // ToP proxy bombs -- spikes.
                deathstring = " dances for ";
                deathstring2 = "'s spike trap\n";
            }
*/
//- - - - - - - - -
            else if (dtype == "crash_bomb")
            {   // Explosion damage.
                if (targ.health < targ.gib_health)
                {
                    if (rnum < 0.5)
                        deathstring = " was exploded by ";
                    else
                        deathstring = " was sent to Hell on ";
                }
                else
                    deathstring = " was crashed by ";
                deathstring2 = "'s crash bomb\n";
            }
            else if (dtype == "crash_drill")
            {   // Time between hit and explosion.
                deathstring = " was drilled by ";
                deathstring2 = "'s crash bomb\n";
            }
            else if (dtype == "crash_hit")
            {   // Direct hit.
                deathstring = " was lowballed by ";
                deathstring2 = "'s crash bomb\n";
            }
            else if ((dtype == "hammer") || (dtype == "hammer_decap"))
            {   // Hit by hammer
                if (rnum < 0.5)
                    deathstring = " was hammered by ";
                else
                    deathstring = " was slammed by ";
                deathstring2 = "'s Mjolnir\n";      // was >'s hammer<
            }
            else if (dtype == "divine")
            {   // Lightning storm proc from Mjolnir.
                deathstring = " suffered ";
                deathstring2 = "'s divine wrath\n";

//                bprint (attacker.netname);
//                bprint (" brought the house down on ");
//                bprint (targ.netname);
//                bprint ("\n");
            }
            else if (dtype == "Mjolnir")
            {   // Zapped by the lightning.
                if (rnum < 0.5)
                    deathstring = " felt the power of ";
                else
                    deathstring = " was shocked-and-awed by ";
                deathstring2 = "'s Mjolnir\n";
            }
//            else if (dtype == "static")
//            {   // Hit by static field.  Shouldn't happen but just in case.
//                deathstring = " was zapped in ";
//                deathstring2 = "'s static field\n";
//            }
            else if (dtype == "quake")
            {   // Earthquake.
                deathstring = " was quaked by ";
                deathstring2 = "\n";
            }
            else if (dtype == "plasma")
            {   // DoE-style plasma orbs.
//                if (rnum < 0.5)
//                {
//                    deathstring = " was fused by ";
//                    deathstring2 = "\n";
//                }
//                else
                {   // Quake3 obit
                    deathstring = " was melted by ";
                    deathstring2 = "'s plasma gun\n";
                }
            }
//            else if ((dtype == "multi_grenade") || (dtype == "mini_grenade"))
//            {   // DoE-style multibombs.
//                deathstring = " was blasted to bits by ";
//                deathstring2 = "\n";
//            }
            else if (dtype == "mirv")
            {
                if (attacker.super_damage_finished)
                {
                    bprint (attacker.netname);
                    if (rnum < 0.5)
                    {
                        bprint (" rocked ");
                        bprint (targ.netname);
                        bprint ("'s world\n");
                    }
                    else
                    {
                        bprint (" turns ");
                        bprint (targ.netname);
                        bprint (" into fine red mist\n");
                    }
                    return;
                }
                if (rnum < 0.5)
                    deathstring = " couldn't hide from ";
                else
                    deathstring = " failed to dodge ";
                deathstring2 = "'s MIRV\n";     // cruise missile
            }
//            else if (dtype == "firebomb")
//            {
//                deathstring = " was firebombed by ";
//                deathstring2 = "\n";
//            }
            else if (dtype == "sparks")     // Ruby Wand
            {
                deathstring = " was zapped by ";
                deathstring2 = "\n";
            }
            else if (dtype == "hook")
            {
                if (rnum < 0.5)
                    deathstring = " was grappled by ";
                else
                    deathstring = " was hooked by ";
                deathstring2 = "\n";
            }
            else if (dtype == "Buriza")
            {
                deathstring = " was shattered by ";
                deathstring2 = "\n";
            }
            else if (dtype == "fire")
            {
                if (rnum < 0.5)
                    deathstring = " was burned by ";
                else
                    deathstring = " was flamed by ";
                deathstring2 = "\n";
            }
            else if (dtype == "thorns")    // Empathy shields
            {
                deathstring = " feels ";
                deathstring2 = "'s pain\n";
            }
            else if (dtype == "BloodCube")
            {
                if (rnum < 0.25)
                    deathstring = " donates blood to ";
                else if (rnum < 0.5)
                    deathstring = " feeds ";
                else if (rnum < 0.75)
                    deathstring = " was slain by ";     // Original message
                else
                    deathstring = " was sucked dry by ";
                deathstring2 = "'s Sanguinoch\n";
            }
            else if (dtype == "explo_box")
            {
// FIXME:  What if triggered by a info_notnull hack?
//                deathstring = " was barreled over by ";
                deathstring = " was blown up by ";
                deathstring2 = "\n";
            }
//            else if (dtype == "scorpion")   // Centroid morph
//            {
//                deathstring = " was stung by ";
//                deathstring2 = "\n";
//            }
//            else if (dtype == "impulse")
//            {
//                deathstring = " used a cheat to kill "
//                deathstring2 = "\n";
//
//                // Punisher cheater by removing all frags.
//                if (attacker.flags & FL_CLIENT)
//                    centerprint ("C H E A T E R !");
//                Frags_Add (attacker, 0 - attacker.frags);
//            }
            else // Don't know how he died; he's just dead.
            {
                deathstring = " was fragged by ";
                deathstring2 = "\n";
            }
            bprint (targ.netname);
            bprint (deathstring);
            bprint (attacker.netname);
            bprint (deathstring2);
        }
        return;
    }

// Killed by thorns?
    if (dtype == "thorns")
    {   // Killed by reflected damage (from empathy shields).
        // Doesn't matter which NPC reflected the damage back.
        Frags_Add (targ, -1);

        bprint (targ.netname);
        if (rnum < 0.5)
            bprint (" dealt the pain but couldn't take it\n");
        else
            bprint (" exceeded his tolerance for pain\n");
        return;
    }
// Killed by uncontrolled bloodcube?
    if (dtype == "BloodCube")
    {   // Killed by bloodcube, not the NPC who controls it.
        Frags_Add (targ, -1);

        bprint (targ.netname);
        bprint (" was slain by the Sanguinoch\n");
        return;
    }

// Killed by a monster?
    if (attacker.flags & FL_MONSTER)
    {
    // Remove frags from target even if the attacker was a pawn of an
    // enemy player.  Enemy losing frags is as good as a player gaining them.
    // Well, not as good in big free-for-all games.
        Frags_Add (targ, -1);

        bprint (targ.netname);
        if (!IsEmptyString (attacker.netname))      // Named NPC?
        {   // Named NPCs use the same obit.  Worked for Diablo II.
            bprint (" was slain by ");
            bprint (attacker.netname);
            bprint ("\n");
        }
//        else if (attacker.classname == "monster_archvile")
//            bprint (" was immolated by an Arch-Vile\n");
        else if (attacker.classname == "monster_archer")
        {
            if (soul_evil)
                bprint (" was shafted by an Orc\n");
            else
                bprint (" was skewered by an Archer\n");
        }
        else if (attacker.classname == "monster_archer_lord")
            bprint (" got Horshacked\n");   //bprint (" was assassinated by an Assassin\n");
        else if (attacker.classname == "monster_bandit")
        {
            if ((attacker.ryuflags & RYU_REBEL) && (attacker.spawnflags & SPAWN_WHITE))
                bprint (" was shot by friendly fire\n");
            else if (soul_evil)
                bprint (" was shot by a Bandit\n");
            else
                bprint (" was shot by a Grunt\n");
        }
        else if (attacker.classname == "monster_goblin")
            bprint (" was shot by a Goblin\n");
// Army - - - - - -
        else if (attacker.classname == "monster_army")
            bprint (" was shot by a Grunt\n");
        else if (attacker.classname == "monster_army_axe")
            bprint (" was axed by a Grunt\n");
        // FIXME:  Sort eliminator/commando mess.
        else if (attacker.classname == "monster_army_cyborg")
            bprint (" was blitzed by a Commando\n");
        else if (attacker.classname == "monster_army_rocket")
            bprint (" was rocked by a Rocketter\n");
        else if (attacker.classname == "monster_soldier")
            bprint (" was shot by a Soldier\n");
        else if (attacker.classname == "monster_commando")  // Plasma dude.
            bprint (" was eliminated by an Eliminator\n");  // Quoth says "phased out"
        else if (attacker.classname == "monster_defender")
            bprint (" was defeated by a Defender\n");
//        else if (attacker.classname == "monster_eliminator")
//            bprint (" was phased by an Eliminator\n");
        else if (attacker.classname == "monster_enforcer")
        {
            if (rnum < 0.5)
                bprint (" was blasted by an Enforcer\n");
            else
                bprint (" was terminated by an Enforcer\n");
        }
        else if (attacker.classname == "monster_gunner")
        {
            if (dtype == "chaingun")
                bprint (" was perforated by a Chaingunner\n");
            else
                bprint (" was outgunned by a Gunner\n");
        }
        else if (attacker.classname == "monster_me")
            bprint (" was vaporized by a Mega Enforcer\n");
        else if (attacker.classname == "monster_ultra")
            bprint (" was demolished by a Stormtrooper\n");
//- - - - - - - - -
        else if (attacker.classname == "monster_axeman")
        {
            if (attacker.skin)
            {
                if (attacker.ryuflags & RYU_REBEL)
                    bprint (" was felled by an Axeman\n");
                else
                    bprint (" was bushwhacked by a Forest Thug\n");
            }
            else
                bprint (" was scalped by an Axe Knight\n");
        }
        else if (attacker.classname == "monster_baron")
        {
        // Elemental bosses
            if (attacker.level == 1)
                bprint (" was scorched by the Fire Baron\n");
            else if (attacker.level == 2)
                bprint (" was buried by the Earth Baron\n");
            else if (attacker.level == 3)
                bprint (" was blown away by the Wind Baron\n");    //Storm
            else if (attacker.level == 4)
                bprint (" was liquidated by the Water Baron\n");   //Rain
        //- - - - - - - - -
            else if (rnum < 0.5)
                bprint (" became a Baron's thrill kill\n");
            else
                bprint (" was ruled by a Baron\n");
        }
        else if (attacker.classname == "monster_cyberdemon")
        {
            if (rnum < 0.5)
                bprint (" dances the Cyberboogie\n");
            else
                bprint (" was splattered by a Cyberdemon\n");
        }
        else if (attacker.classname == "monster_demon1")
            bprint (" was eviscerated by a Fiend\n");
        else if (attacker.classname == "monster_dog")
        {
            if (attacker.skin == 1)
                bprint (" fed the Wolves\n");
            else if (attacker.skin == 2)
                bprint (" was scorched by a Hell Hound\n");
            else
            {   // Classic dog.
                if (rnum < 0.5)
                    bprint (" was mauled by a Rottweiler\n");
                else
                    bprint (" became the Rottweiler's chew toy\n");
            }
        }
        else if (attacker.classname == "monster_dragon")
        {   // Qtest/Drake based.
            if (dtype == "melee")
                bprint (" was crushed by a Dragon\n");
            else if ((dtype == "acid") || (dtype == "wizspike"))
                bprint (" was melted by a Dragon\n");
            else if (dtype == "ice")
                bprint (" was iced by a Dragon\n");
//            else if (dtype == "fire")
//                bprint (" was scorched by a Dragon\n");
            else if (dtype == "death")
                bprint (" was annihilated by an exploding Dragon\n");
            else
                bprint (" was fried by a Dragon\n");    // Original obit.
        }
        else if (attacker.classname == "monster_drone")
        {
            if (dtype == "laser")
                bprint (" was drilled by a Drone\n");   // OUM.
            else
                bprint (" was blown up by a Drone\n");
        }
        else if (attacker.classname == "monster_fish")
        {
            if (rnum < 0.5)
                bprint (" was fed to the Rotfish\n");
            else
                bprint (" was munched by the Rotfish\n");
        }
// Hell Knights - - -
        else if (attacker.classname == "monster_bane")  // BBEG
            bprint (" provided sport for The Bane\n");
        else if (attacker.classname == "monster_hell_knight")
        {
            if (dtype == "melee")
                bprint (" was slashed by a Hell Knight\n");
            else
                bprint (" was slain by a Hell Knight\n");
        }
        else if (attacker.classname == "monster_hell_lord")
            bprint (" fell before a Hell Lord\n");
        else if (attacker.classname == "monster_hkboss")
            bprint (" was slaughtered by a Warlord\n");
        else if (attacker.classname == "monster_dark_lord")
        {   if (attacker.xfl & XFL_BOSS)
                bprint (" fell before the Dark Lord\n");
            else
                bprint (" fell before a Dark Lord\n");
        }
//- - - - - - - - - -
// Knights - - - - -
        else if (attacker.classname == "monster_knight")
            bprint (" was slashed by a Knight\n");
        else if (attacker.classname == "monster_warrior")
        {   if (soul_evil)
                bprint (" was slashed by a Warrior of Bane\n");
            else
                bprint (" was slashed by a Warrior\n");
        }
//- - - - - - - - -
        else if (attacker.classname == "monster_golem")
        {
            if (dtype == "melee")
                bprint (" was cleaved by a Golem\n");
            else
                bprint (" was terminated by a Golem\n");
        }
        else if ((attacker.classname == "monster_imp") ||
        (attacker.classname == "monster_imp_lord"))
        {
            if (targ.deathtype == "melee")
                bprint (" was raked by an Imp\n");
            else if (targ.deathtype == "swoop")
                bprint (" was crashed by an Imp\n");
            else if (targ.deathtype == "ice")
                bprint (" was chilled out by an Imp\n");
            else //if (targ.deathtype == "fire")
                bprint (" was roasted by an Imp\n");
        }
// Necromancer - - -
        else if (attacker.classname == "monster_acolyte")
            bprint (" was humiliated by an Acolyte\n");
        else if (attacker.classname == "monster_sorcerer")
            bprint (" was bested by a Sorcerer\n");
        else if (attacker.classname == "monster_warlock")
            bprint (" was no match for a Warlock\n");
        else if (attacker.classname == "monster_necromancer")
            bprint (" was snuffed by the Necromancer\n");
//- - - - - - - - -
// Nemesant - - - -
        else if (attacker.classname == "monster_nemesant")      // Zerstorer
        {
            if (attacker.skin)
                bprint (" succumbed to a Demon Magus\n");
            else
                bprint (" was buried by a Nemesant\n");
        }
        else if ((attacker.classname == "monster_trogboss") ||
        (attacker.classname == "monster_cultlord"))
        {
            if (attacker.deadflag)
                bprint (" goes down with the Master\n");
            else
                bprint (" failed to impress the Master\n");
        }
//- - - - - - - - -
        else if ((attacker.classname == "monster_ogre") ||
        (attacker.classname == "monster_ogre_marksman"))
            bprint (" was destroyed by an Ogre\n");
        else if (attacker.classname == "monster_oldone")
            bprint (" became one with Shub-Niggurath\n");
        else if (attacker.classname == "monster_ranger")        // ***
        {
            if (Ally_Check (targ, attacker))
            {   // Killed by friendly fire?
                if (rnum < 0.5)
                    bprint (" takes one for the team\n");
                else
                    bprint (" was fragged by friendly fire\n");
            }
            else
                bprint (" met his match\n");    //was fragged by a Ranger
        }
        else if (attacker.classname == "monster_rebel")
        {
            if ((attacker.ryuflags & RYU_REBEL) && (attacker.spawnflags & SPAWN_WHITE))
                bprint (" was shot by friendly fire\n");
            else
                bprint (" was quarreled at by an Enforcer\n");
        }
        else if (attacker.classname == "monster_shalrath")
            bprint (" was exploded by a Shal-Rath\n");      //Vore
        else if (attacker.classname == "monster_shambler")
        {
            if (dtype == "lightning")
                bprint (" was fried by a Shambler\n");
            else
                bprint (" was smashed by a Shambler\n");
        }
        else if (attacker.classname == "monster_shamvile")
            bprint (" was mutilated by a Sha'Vile\n");
// Skull Wizard - -
        else if (attacker.classname == "monster_skull_wizard")
            bprint (" succumbed to the Skull Wizard's magic\n");
        else if (attacker.classname == "monster_skull_wizard_lord")
            bprint (" was Skull-duggeried\n");
        else if (attacker.classname == "monster_skull_wizard_boss")
            bprint (" was razed by the Summoner\n");
//- - - - - - - - -
        else if (attacker.classname == "monster_snakeman")
            bprint (" was hosed by a Snakeman\n");
        else if (attacker.classname == "monster_spider")
            bprint (" fed the Spiders\n");
        else if (attacker.classname == "monster_tarbaby")
            bprint (" was slimed by an Spawn\n");
        else if (attacker.classname == "monster_turret")
            bprint (" got trashed by a defense turret\n");
// Undead - - - - -
//        else if (attacker.classname == "monster_eyes")
//            bprint (" was zapped by a Stalker\n");
        else if (attacker.classname == "monster_nightshade")    // Dragons
            bprint (" was etherealized by a Nightshade\n");
        else if (attacker.classname == "monster_wraith")
            bprint (" was disembodied by a Wraith\n");
        else if (attacker.classname == "monster_wraith_lord")
            bprint (" was voided by a Dread Lord\n");
//            bprint (" was eradicated by a Dread Lord\n");   //Wraith\n");
//- - - - - - - - -
        else if (attacker.classname == "monster_vomit")
        {
            if (dtype == "melee")
                bprint (" was eaten by a Vomitus\n");
            else
                bprint (" was vomited on by a Vomitus\n");
        }
        else if (attacker.classname == "monster_wizard")
        {
            if (attacker.skin == 1)
                bprint (" didn't duck a Drake\n");
            else
                bprint (" was scragged by a Scrag\n");
        }
        else if (attacker.classname == "monster_yakman")
            bprint (" was gored by a Gauroch\n");
//        else if (attacker.classname == "monster_zer")
//            bprint (" was destroyed by the Zerstorer!\n");
        else if (attacker.classname == "monster_zombie")
        {
            if (rnum < 0.5)
                bprint (" joins the Zombies\n");
            else
                bprint (" was Zombified\n");
        }
// MP1 (Scourge of Armagon) monsters
        else if (attacker.classname == "monster_armagon")
        {
            if (dtype == "repel")
                bprint (" tried to headbang Armagon\n");
            else
                bprint (" was outgunned by Armagon\n"); // Original message.
        }
        else if (attacker.classname == "monster_gremlin")
        {
            if (dtype == "melee")
                bprint (" was lacerated by a Gremlin\n");
            else
                bprint (" was outsmarted by a Gremlin\n");
        }
        else if (attacker.classname == "monster_scourge")
            bprint (" was stung by a Centroid\n");
//        else if (attacker.classname == "trap_spike_mine")
//            bprint (" was blasted by a spike mine\n");
//- - - - - - - - -
// MP2 (Dissolution of Eternity) monsters
        else if (attacker.classname == "monster_eel")
            bprint (" was electrified by an Eel\n");
        else if (attacker.classname == "monster_morph")
        {
//            if (attacker.model == "progs/morph_eg.mdl")
//            {
//                if (rnum < 0.5)
//                    bprint (" walked like an Egyptian\n");
//                else
//                    bprint (" sleeps with the pharaohs\n");
//            }
//            else
                bprint (" was crushed by a Guardian\n");
        }
        else if (attacker.classname == "monster_mummy")
            bprint (" was Mummified\n");
        else if (attacker.classname == "monster_wrath")
        {
            if (rnum < 0.5)
                bprint (" suffered the wrath of a Wrath\n");  // fc1 obit.
            else
                bprint (" was disintegrated by a Wrath\n");
        }
        else if (attacker.classname == "monster_super_wrath")
            bprint (" was obliterated by an Overlord\n");
//- - - - - - - - -
// Quoth monsters
        else if (attacker.classname == "monster_drole")
            bprint (" was decimated by a Drole\n");
        else if (attacker.classname == "monster_gaunt")
        {
            if (dtype == "swoop")
                bprint (" died in the clutches of a Nightgaunt\n");
            else
                bprint (" was charred by a Nightgaunt\n");
        }
        else if (attacker.classname == "monster_gug")
        {
            if (dtype == "quake")
                bprint (" was quaked by a Gug\n");
            else
                bprint (" was obliterated by a Gug\n");
        }
//        else if (attacker.classname == "monster_vermis")
//            bprint (" was eradicated by a Vermis\n");
//- - - - - - - - -
    // Unknown monster?
        else
            bprint (" died of unnatural causes\n");
        return;
    }

// Killed by a hazard.
    Frags_Add (targ, -1);
    bprint (targ.netname);

    // Episode 1 boss -- Chthon.
    if (attacker.classname == "monster_boss")
    {
        if (targ.health < targ.gib_health)
            bprint (" was obliterated by Chthon\n");
        else if (rnum < 0.5)
            bprint (" had a blast with Chthon\n");
        else
            bprint (" was firebombed by Chthon\n");
        return;
    }
    // tricks and traps
    if (attacker.classname == "explo_box")
    {
        bprint (" blew up\n");
        return;
    }

    if (attacker.classname == "fireball")
    {
        bprint (" ate a lavaball\n");
        return;
    }
    if (attacker.solid == SOLID_BSP)
        if (attacker)   // != world)
    {    
        bprint (" was squished\n");
        return;
    }

// hell if I know; he's just dead!!!
    if (IsEmptyString (dtype))
    {
        bprint (" died\n");
        return;
    }

// Wildcard obituaries.
    // fell to their death?
    if (dtype == "falling")
    {
        if (targ.health < targ.gib_health)
            bprint (" splattered\n");
        else if (rnum < 0.5)
            bprint (" cratered\n");             // Quake2 obit
        else
            bprint (" fell to his death\n");    // Quake1 obit
        return;
    }
    // tricks and traps
    if (dtype == "laser")
    {
        if (rnum < 0.333)
            bprint (" got blasted\n");      // Q2 blaster trap death
        else if (rnum < 0.666)
            bprint (" saw the light\n");    // Q2 laser trap death
        else
            bprint (" was zapped\n");       // QuakeWorld
        return;
    }
    if ((dtype == "spike") || (dtype == "superspike") ||
    (dtype == "spike2") || (dtype == "trapspike"))
    {
        bprint (" was spiked\n");
        return;
    }
    if (dtype == "rocket")
    {
        bprint (" was slammed by a rocket\n");
        return;
    }
    if (dtype == "lavaball")
    {
        bprint (" swallowed a red hot lavaball\n");
        return;
    }
    // in-water deaths
    if (dtype == "water")
    {
        if (rnum < 0.2)
            bprint (" drowned\n");
        else if (rnum < 0.4)
            bprint (" sank like a rock\n");
        else if (rnum < 0.6)
            bprint (" sleeps with the fishes\n");
        else if (rnum < 0.8)
            bprint (" sucks it down\n");
        else
            bprint (" went to Davy Jones's locker\n");
        return;
    }
    if (dtype == "slime")
    {
        if (rnum < 0.2)
            bprint (" can't exist on slime alone\n");
        else if (rnum < 0.4)
            bprint (" dissolved\n");
        else if (rnum < 0.6)
            bprint (" failed the acid test\n");
        else if (rnum < 0.8)
            bprint (" gulped a load of slime\n");
        else
            bprint (" was slimed\n");
        return;
    }
    if (dtype == "lava")
    {
        if (targ.health < -15)
        {
            if (rnum < 0.5)
                bprint (" burst into flames\n");
            else
                bprint (" went up in smoke\n");
            return;
        }
        if (rnum < 0.333)
            bprint (" had a meltdown\n");
        else if (rnum < 0.666)
            bprint (" turned into hot slag\n");
        else
            bprint (" visits the Volcano God\n");
        return;
    }
    if (dtype == "void")
    {
        if (rnum < 0.5)
            bprint (" disappears\n");
        else
            bprint (" was in the wrong place\n");   // Quake3 obit.
        return;
    }
    if (dtype == "quake")
    {   // Earthquake.
        bprint (" was Quaked\n");
        return;
    }
    if (dtype == "divine")
    {   // Arcanum:  From trigger_divine.
        bprint (" was struck by lightning\n");
        return;
    }
    if ((dtype == "fire") || (dtype == "fireball"))
    {
        bprint (" played with fire\n");
        return;
    }
    if (dtype == "ice")
    {
        bprint (" chilled out\n");
        return;
    }
    if (dtype == "lightning")
    {
        bprint (" rode the lightning\n");
        return;
    }
    // cheater deaths
//    if (dtype == "noclip")
//    {
//        if (rnum < 0.25)
//            bprint (" enters the Twilight Zone\n");
//        else if (rnum < 0.5)
//            bprint (" phased out of existance\n");
//        else if (rnum < 0.75)
//            bprint (" thought he was a ghost\n");
//        else
//            bprint (" won a free one-way trip to the afterlife\n");
//        return;
//    }
    if (dtype == "impulse")
    {
        bprint (" was sent to Hell\n");
        return;
    }
//- - - - - - - - -
    // Orphaned missiles after its former owner left the game.
    if (dtype == "Buriza")
    {
        bprint (" shattered\n");
        return;
    }
    if (dtype == "Mjolnir")
    {
        bprint (" was crushed by Thor's power\n");
        return;
    }
    if (dtype == "acid")
    {
        bprint (" took some bad acid\n");
        return;
    }
    if (dtype == "arrow")
    {
        if (rnum < 0.5)
            bprint (" got shafted\n");
        else
            bprint (" was skewered\n");
        return;
    }
    if (dtype == "grenade")
    {
        bprint (" munched on a grenade\n");
        return;
    }
    if (dtype == "hook")
    {
        bprint (" was grappled to death\n");
        return;
    }
    if (dtype == "mirv")    
    {
        bprint (" was splattered by a MIRV\n");
        return;
    }
    if (dtype == "necrobomb")
    {
        bprint (" was blasted by an explosive rune\n");
        return;
    }
    if ((dtype == "necrobolt") || (dtype == "knightspike") || (dtype == "sparks"))
    {
        bprint (" was felled by black magic\n");
        return;
    }
    if (dtype == "needle")
    {
        bprint (" got blasted\n");
        return;
    }
    if (dtype == "plasma")
    {
        bprint (" melted\n");   //(" was fried\n");
        return;
    }
//    if (dtype == "proximity_grenade")
//    {
//        bprint (" blundered into a proximity bomb\n");
//        return;
//    }
//    if (dtype == "spike_trap")
//    {
//        bprint (" got in the way of a spike trap\n");
//        return;
//    }
    if (dtype == "wizspike")
    {
        bprint (" choked on green goo\n");
        return;
    }
//- - - - - - - - -

// Generic obituary.
    bprint (" ");
    bprint (dtype);
    bprint ("\n");
};


//===========================/  END OF FILE  /===========================//

//==========================================================================
//  Sounds

//============
// ProtectSound
//============
void(entity e) ProtectSound =
{
    if (e)
    if (e.invincible_sound < time)
    {
        sound (e, CHAN_ITEM, "items/protect3.wav", 1, ATTN_NORM);
        e.invincible_sound = time + 2;
    }
};

//============
// CrossSound
//============
void(entity e) CrossSound =
{
    if (powcache & PCH_CROSS_USE)
    if (e)
    if (e.cross_sound < time)
    {
        sound (e, CHAN_ITEM, "items/crosuse.wav", 1, ATTN_NORM);
        e.cross_sound = time + 0.5;
    }
};


//==========================================================================
//  Curses

// Placed here because it is like T_Damage, except it attacks an enemy
// with a debuff instead of direct damage.  Chaos armor may curse an
// enemy when it takes damage.

// Generic slow timer.  Inflicted by Buriza.
void(entity targ, entity attacker, float dur) T_Slow =
{
    if (!targ)
        return;
    if (targ.invincible_finished)
        return;
    if (targ.cross_finished)
        return;
    // FIXME:  Empathy shields should share the pain.

    // FIXME:  Should slow time stack for slowed targets?
    dur = time + dur;
    if (targ.slow_finished < dur)
        targ.slow_finished = dur;
    attacker = attacker;    // Appease compiler.
};

// Called by T_Curse below.
void(entity ent, float take, float save) Flash =
{
    if (ent.flags & FL_CLIENT)
    {
        ent.dmg_take       = ent.dmg_take + take;
        ent.dmg_save       = ent.dmg_save + save;
        ent.dmg_inflictor  = ent;
    }
};

//============
// T_Curse
//
// Inflicts a curse upon the target.  Each curse has a duration set by 'dur'.
// Made for the necromancer boss, but this may be used as freely as T_Damage.
// Each target may be inflicted by one curse at a time only.  New curses
// will override any active curse.
//
// Target will get mad at the attacker.
//
// FIXME:  Use reverse runes.
// --- Curse types --
// CURSE_DAMAGE  : Amplify Damage, target takes double damage from attacks.
// CURSE_WEAKEN  : Weaken, target inflicts half damage to others.
// CURSE_SLOW    : Decrepify, target moves slower.
// CURSE_ARMOR   : Lower Defense, target's armortype is halved.
//
// Yes, the curses work much like in Diablo 2.
// ...Except decrepify, which just slows you down here, instead of
// inflicting an overpowered combo of slow, weaken, and amplify damage.
//
// There was a CURSE_IRONMAIDEN that reflected damage back at the attacker,
// but that was removed for being too cruel to players.
// (Note 2/10/11:  Even Blizzard removed Iron Maiden from monsters
// in the Diablo II 1.13 patch because it is an OHKO against melee PCs.)
//
// Update 5/29/10:  Removed CURSE_LIFETAP because health gains are
// far too much if a player can exploit it on cursed monsters.
//============
void(entity targ, entity attacker, float curse, float dur) T_Curse =
{
    local   string  sfx;
    local   float   take, save;

    if (!(targ.flags & FLx_CREATURE))
        return;
    if (targ.invincible_finished)
    {   // Invulnerability provides immunity.
        ProtectSound (targ);
        return;
    }
    if (targ.cross_finished)
    {   // Update 5/12/10:  Cross provides immunity to curses too.
        CrossSound (targ);
        return;
    }

// Select the appropriate curse to use.
    take = save = 0;
    if (!curse)
        curse = ((random() * 4) & 3) + 1;

    if (curse == CURSE_DAMAGE)
        {sfx = "curse/x_damage.wav";  take = 50;}
    else if (curse == CURSE_WEAKEN)
        {sfx = "curse/x_weaken.wav";  save = 50;}
    else if (curse == CURSE_SLOW)
        {sfx = "curse/x_slow.wav";   save = 50;}
//        {sfx = "curse/x_armor.wav";   take = save = 50;}
    else if (curse == CURSE_ARMOR)
        {sfx = "curse/x_armor.wav";   save = 50;}
//    else if (curse == CURSE_LIFETAP)
//        {sfx = "curse/x_leech.wav";   take = save = 25;}
    else
        return;     // Unsupported.

// Apply curse to target.
    if (targ.curse_type != curse)
    {
        Flash (targ, take, save);
        sound (targ, CHAN_AUTO, sfx, 1, ATTN_NORM);
        targ.curse_type     = curse;
    }
    targ.curse_finished = time + dur;

// Aggravate target.
    if (targ.flags & FL_MONSTER)
    {
        if (attacker)   // != world)
        if (targ.health > 0)
        if (!(targ.ryuflags & RYU_PATH))    // For DoE dragon.
        if (Enemy_Check (targ, attacker))
        {
            local   entity  swap;
    
            swap = self;
            self = targ;
            NewEnemy (attacker);
            self = swap;
        }
    }
};

// Returns a target for a confused enemy to attack.
// WARNING:  Uses findradius, so *don't* call this within a findradius call!
entity(entity targ, entity attacker) Confuse_Target =
{
    local   entity  victim;

    victim = world;
    if (targ.flags & FL_MONSTER)    // Must be a monster.
    if (!IsDead (targ))             // Must be alive.
    if (targ.modelindex)            // Must be active in the level.
    if (targ != attacker)           // Attacker cannot target himself.
    if ((targ.xfl & XFL_BOSS) == 0)     // Must be weak-minded.
    {
        local   entity  head;
        local   vector  p1, p2;
        local   float   hits;

        hits = 0;
        p1 = targ.origin + targ.view_ofs;
        head = findradius(p1, 1000);
        victim = world;
        while (head)
        {
            if (head.takedamage)            // New target must be breakable.
            if (head.health > 0)            // New target must be standing.
            if (head != targ)               // Don't attack itself.
            if (head != attacker)           // Don't attack the curse giver
            if (head != attacker.master)    // ...or his master.
            if (!head.invisible_finished)       // Must see the new target.
            if (!(head.flags & FL_NOTARGET))
            {
                p2 = Midpoint (head);
                traceline (p1, p2, TRUE, targ);
                if (trace_fraction == 1)
                {
                    head.chain2 = victim;
                    victim = head;
                    hits = hits + 1;
                }
            }
            head = head.chain;
        }
        if (hits)
        {
            hits = random() * hits;
            hits = floor (hits);
            while (hits > 0)
            {
                victim = victim.chain2;
                hits = hits - 1;
            }
        }
    }
    return victim;
};

float(entity targ, entity attacker) T_Confuse =
{
    local   entity  victim;

    victim = Confuse_Target (targ, attacker);
    if (!victim)
        return FALSE;

// "These are not the droids you are looking for."
// Play curse effects then switch the target's enemy to the victim.
    if (targ.curse_type != CURSE_CONFUSE)
    {
        sound (targ, CHAN_AUTO, "curse/x_muddle.wav", 1, ATTN_NORM);
        targ.curse_type     = CURSE_CONFUSE;
    }
    targ.curse_finished = time + 5;

    if (victim == targ.enemy)
        return TRUE;    // Already fighting this target, just reset duration.

    if (!Align_Match (targ.enemy, targ))
        targ.oldenemy   = targ.enemy;
    targ.enemy      = victim;
    SUB_Think (targ, FoundTarget);

// Reset attacker's enemy if it was the target.
    if (attacker.flags & FL_MONSTER)
        if (attacker.health > 0)
            if (attacker.enemy == targ)
                if (Ally_Check (targ, attacker))
                    attacker.enemy = world;     // So ai_run finds a new one.

    return TRUE;
};

// Think func for delayed confusion.
void() Confusion_Think =
{
    T_Confuse (self.enemy, self.owner);
    remove (self);
};

// Spawns a dummy entity to trigger confusion a frame later.
// Used to avoid recursive calls to findradius.
void(entity targ, entity attacker) Confusion_Delayed =
{
    local   entity  ent;
    
    ent = spawn();
    ent.owner = attacker;
    ent.enemy = targ;
    ent.nextthink = 0.01;
    ent.think = Confusion_Think;
};


//==========================================================================
//  COMBAT!

//============
// UseCourage
//
// Checks if 'ent' can reflect an attack from the point 'spot'.
//============
float(entity ent, vector spot) UseCourage =
{
    if (Armor_Exotic (ent) == SUIT_COURAGE)
    {
        local   vector  vx, vy, vz, v1, v2;

        vx = v_forward;  vy = v_right;  vz = v_up;
        makevectors (ent.angles);   // Yes, use model angles, not viewangles.
        v1 = normalize (spot - ent.origin);
        v2 = v_forward;
        v_forward = vx;  v_right = vy;  v_up = vz;
        if (v1 * v2 > 0.3)      // Must be infront of 'ent'.
            return TRUE;
    }
    return FALSE;
};


//============
// T_Heal
//
// Add health to an entity, limiting health to max_health
// "ignore" will ignore max_health limit
//
// PM:  Now returns amount healed instead of FALSE/TRUE.
//============
float(entity e, float heal, float ignore) T_Heal =
{
    if ((ignore != 2) || !(e.flags & FL_MONSTER))
    {
        if (e.health <= 0)
            return 0;   // Dead.
    }
    // ELSE... absorb mode is on, which can heal and revive dead things.

    local   float   full;

    if (ignore)
        full = e.max_health + 150;
    else
        full = e.max_health;

    if (e.health >= full)
        return 0;   // Already has full health.

    if (e.health + heal >= full)
        heal = full - e.health;
    if (heal < 1)
        return 0;   // Don't hurt the receiver.

    e.hit_points = e.health = e.health + heal;
    return heal;        // Return amount healed instead of TRUE.
};

//============
// T_Repair
//
// Add armor to an entity, within limits.  Similar to T_Heal, but for armor.
//============
float(entity e, float heal, float ignore) T_Repair =
{
    local   float   full;

    if (e.health <= 0)
        return 0;   // Dead.
    if (Armor_NoPatch (e))
        return 0;

    if (ignore)
        full = 250;     // armorvalue on hud is restricted to max of 255.
    else if (e.items & IT_ARMOR3)
        full = ARMOR_STATS_RED_y;
    else if (e.items & IT_ARMOR2)
        full = ARMOR_STATS_YELLOW_y;
    else
        full = ARMOR_STATS_GREEN_y;

    if (e.armorvalue >= full)
        return 0;   // Armor already fully restored.

    if (e.armorvalue + heal >= full)
        heal = full - e.armorvalue;
    if (heal < 1)
        return 0;   // Don't damage the armor.

    e.armorvalue = e.armorvalue + heal;
    if (!e.armortype)
    if (!Armor_Exotic (e))      // Some of the custom armors are cursed!
    {
        // Add green armor.
        e.armortype = ARMOR_STATS_GREEN_x;
        if (e.flags & FL_CLIENT)
            if (!(e.items & ITx_ALL_ARMOR))
                e.items = e.items | IT_ARMOR1;
    }
    return heal;        // Return amount healed instead of TRUE.
};


// - - - - - - - - - - - - - - - - - - -
//============
// ResistDamage
//
// Modifies damage based on type.
//
// In case of multiple damage types, choose the single most effective
// resist and/or single worst weakness that apply.  Stacking multiple
// resistances weakens damage too much.  Similarly, stacking multiple
// weaknesses causes too much damage.
//
// Q:  Should we just take the weakest resistance and be done with it?
// A:  No -- Breaks shambler half damage for fire+rocket, elec+rocket.
//============
float(entity targ, float damage, float dflags) ResistDamage =
{
    local   float   lo, hi;

    lo = hi = 0;
    if (dflags & DFx_RESISTS)
    {
        if (dflags & DF_ACID)
            if (targ.resist_acid)
            {
                if (hi < targ.resist_acid)
                    hi = targ.resist_acid;
                else if (lo > targ.resist_acid)
                    lo = targ.resist_acid;
            }
        if (dflags & DF_COLD)
            if (targ.resist_cold)
            {
                if (hi < targ.resist_cold)
                    hi = targ.resist_cold;
                else if (lo > targ.resist_cold)
                    lo = targ.resist_cold;
            }
        if (dflags & DF_FIRE)
        {
            // Update 5/14/10:  Dragonscale gives resistance to fire.
            if (Armor_Exotic (targ) == SUIT_DRAGON)
                if (!targ.form_active)  // Dragon form has it already.
                    damage = damage * 0.5;
            if (targ.resist_fire)
            {
                if (hi < targ.resist_fire)
                    hi = targ.resist_fire;
                else if (lo > targ.resist_fire)
                    lo = targ.resist_fire;
            }
        }
        if (dflags & DF_LIGHTNING)
        {
            if (targ.radsuit_finished)
                return 0;   // Inheirted from wetsuit.
            // SoE:  Holding Mjolnir halves lightning damage.
            if (targ.flags & FL_CLIENT)
                if (targ.war == WAR_MJOLNIR)
                    if (!targ.form_active)
                        if (!targ.hammer_finished)
                            damage = damage * 0.5;
            if (targ.resist_light)
            {
                if (hi < targ.resist_light)
                    hi = targ.resist_light;
                else if (lo > targ.resist_light)
                    lo = targ.resist_light;
            }
        }
        if (dflags & DF_ROCKET)
            if (targ.resist_rocket)
            {
                if (hi < targ.resist_rocket)
                    hi = targ.resist_rocket;
                else if (lo > targ.resist_rocket)
                    lo = targ.resist_rocket;
            }
        damage = damage * (1 - lo) * (1 - hi);
    }
    return damage;
};
// - - - - - - - - - - - - - - - - - - -

//============
// CanDamage
//
// Returns true if the inflictor can directly damage the target.  Used for
// explosions and melee attacks.
//============
float(entity targ, entity inflictor) CanDamage =
{
// Bmodels need special checking because their origin is '0,0,0'.
    if (targ.movetype == MOVETYPE_PUSH)
    {
        traceline(inflictor.origin, 0.5 * (targ.absmin + targ.absmax), TRUE, self);
        if (trace_fraction == 1)
            return TRUE;
        if (trace_ent == targ)
            return TRUE;
        return FALSE;
    }
    
    traceline (inflictor.origin, targ.origin, TRUE, self);
    if (trace_fraction == 1)
        return TRUE;
    traceline (inflictor.origin, targ.origin + '15 15 0', TRUE, self);
    if (trace_fraction == 1)
        return TRUE;
    traceline (inflictor.origin, targ.origin + '-15 -15 0', TRUE, self);
    if (trace_fraction == 1)
        return TRUE;
    traceline (inflictor.origin, targ.origin + '-15 15 0', TRUE, self);
    if (trace_fraction == 1)
        return TRUE;
    traceline (inflictor.origin, targ.origin + '15 -15 0', TRUE, self);
    if (trace_fraction == 1)
        return TRUE;

    return FALSE;
};

// Point version of CanDamage.  Useful when entities are unavailable.
// Used by modified AirQuake/OUM turrets.
float(vector v1, vector v2) CanDamage_Point =
{
    traceline (v1, v2, TRUE, self);
    if (trace_fraction == 1)
        return TRUE;
    traceline (v1, v2 + '15 15 0', TRUE, self);
    if (trace_fraction == 1)
        return TRUE;
    traceline (v1, v2 + '-15 -15 0', TRUE, self);
    if (trace_fraction == 1)
        return TRUE;
    traceline (v1, v2 + '-15 15 0', TRUE, self);
    if (trace_fraction == 1)
        return TRUE;
    traceline (v1, v2 + '15 -15 0', TRUE, self);
    if (trace_fraction == 1)
        return TRUE;

    return FALSE;
};


// - - - - - - - - - - - - - - - - - - -
//============
// AddToKills
//============
void() AddToKills =
{
    local   entity  attacker;

    attacker = self.enemy;  // Set by 'Killed'.
    if (self.xfl & XFL_ADD_TO_KILL)
    {
        self.xfl = self.xfl - XFL_ADD_TO_KILL;  // Count only once.
        killed_monsters = killed_monsters + 1;
        WriteByte (MSG_ALL, SVC_KILLEDMONSTER);

    // Update 5/14/10:  Kills recharge berserker armor.
        if (Armor_Exotic (attacker) == SUIT_BERSERKER)
            if (attacker.armorvalue < ARMOR_STATS_DEMON_y)
                attacker.armorvalue = attacker.armorvalue + 1;

    // SoE:  Killing monsters adds to frags.
        if (deathmatch)
            if (attacker.flags & FL_CLIENT)
                Frags_Add (attacker, 1);

// Dmsp - - - - - -
        if (dmsp)
        if (!(dmsp & DMSP_NOCOUNT))
        {
            if (totalmonsterspawn < 1)  // Show count only after invasion.
            {
                if (killed_monsters >= total_monsters)  //&& (totalmonsterspawn < 1))
                    NextLevel ();
                else
                {
                    local   float   n;

//                    if (PRECOUNT)
//                        n = total_monsters - killed_monsters;
//                    else
                        n = totalmonsterspawn + total_monsters - killed_monsters;
                    if (n >= 10)
                    {
                        if (n == 50)
                            Mass_Centerprint ("There are 50 more to go...");
                        if (n == 40)
                            Mass_Centerprint ("There are 40 more to go...");
                        if (n == 30)
                            Mass_Centerprint ("There are 30 more to go...");
                        if (n == 20)
                            Mass_Centerprint ("There are 20 more to go...");
                        if (n == 10)
                            Mass_Centerprint ("There are 10 more to go...");
                    }
                    else
                    {
                        if (n == 5)
                            Mass_Centerprint ("There are 5 more to go...");
                        if (n == 4)
                            Mass_Centerprint ("There are 4 more to go...");
                        if (n == 3)
                            Mass_Centerprint ("Only 3 more to go...");
                        if (n == 2)
                            Mass_Centerprint ("Only 2 more to go...");
                        if (n == 1)
                            Mass_Centerprint ("Only one left...");
                    }
                }
            }
        }
//- - - - - - - - -

    // PM:  Activate 'all clear' triggers at 100% kills.
        if (killed_monsters == total_monsters)
        {   // Just reached 100% kills.
            local   entity  swap;
    
            swap = self;
            self = find (world, classname, "trigger_victory");
            if (self)
            {   // Found one!
                activator = Patriarch (swap.enemy);
                while (self)
                {
                    SUB_UseTargets ();
                    self.classname  = "noclass";    // Use once only.
                    self.nextthink  = time + 0.1;   // Can't remove now...
                    self.think      = SUB_Remove;   // ...while in a loop.
                    self = find (self, classname, "trigger_victory");
                }
            }
            self = swap;
        }
    }
};
// - - - - - - - - - - - - - - - - - - -

/* DISABLED -- Totally unused now that the pokeweapon has been scrapped.
//============
// Captured
//
// Captured monsters disappear.  This should be called during 'Killed'
// so other monsters will stop pursuit, and things that trigger after
// a monster kill will get fired.
//============
void(entity attacker) Captured =
{
    if (attacker)
        attacker.tamed = self;    // So its new master may summon it later.

// NOTE:  Captured monsters cannot respawn while in respawn mode.
// Well, the game thinks they're dead, but they really aren't.
    self.modelindex = 0;
    self.solid = SOLID_NOT;
    self.takedamage = DAMAGE_NO;
    self.movetype = MOVETYPE_NONE;
    self.gorging = TRUE;        // So wraiths and gremlins ignore monster.
    // Remove th_die function so if Killed is called again, it aborts.
    // We must do this because the monster now has movetype_none.
    // Killed can be called again via Pets_Free if captured monster
    // was spawned dynamicly.
    self.th_die =
    self.th_gib =
    self.th_revive = world.null_func;
    self.nextthink = -1;
    monster_item_drop ();       // Drop any special item it had.
    // Don't drop backpacks or money.  Player can kill the captured
    // monster later for that kind of loot.

// FIXME:  Make sure nothing breaks for monsters that use trigger_field.
    if (self.trigger_field)     // Remove extra parts.
        {remove (self.trigger_field);  self.trigger_field = world;}

    spawn_tfog (self.origin);
};
*/

//============
// Killed
//============
void(entity targ, entity attacker, string dtype) Killed =
{
    if (!targ.th_die)
        return;     // No death function.

// Health is 16 bit floating point for players, 32 bit fp for everyone else.
// Health can rollover back to positive beyond -32768, so cap it.
// Original cap was (and still is) -99.  If you want health that can go
// lower than -200 for extreme velocity gibs, lower the cap to -999
// so gibs from an extreme death can really fly.
//
// The 'don't let sbar look bad if a player' is meaningless since
// it is always overwritten by tab info.
    if (targ.health < -99)
        targ.health = -99;
    targ.deathtype = dtype;

    local   entity  swap;

    swap = self;
    self = targ;
    if (self.movetype == MOVETYPE_PUSH || self.movetype == MOVETYPE_NONE)
    {   // doors, triggers, etc.
        // PM:  Also includes misc_explobox and crucified zombies.
        if (self.th_die == barrel_die)
            self.enemy = attacker;      // So attacker gets credit.
        self.th_die ();
    }
    else if (!self.deadflag)
    {   // Enemy was just killed.
        self.deadflag = DEAD_DYING;
        self.enemy = attacker;

        AddToKills ();  // bump the monster counter
        ClientObituary (self, attacker);
        ChangeDeathtype (self);

        // Removing 'self.takedamage = DAMAGE_NO;' lets corpses get mutilated.
        self.touch = SUB_Null;

//        SetDeathEffects ();
// FIXME:  capture/void resolution of multi-part/trigger monsters.
    //- - - - - - - - -
    // PM:  Capture check.
        if (attacker)
            if (self.flags & FL_MONSTER)
                if (self.th_spawn)      // Uses respawn code to release.
/* DISABLED -- No more pokeball weapon.
                    if (dtype == "capture")
                    {   // Captured instead of slain.
                        local   float   df;

                        df = self.flags & (FL_FLY | FL_SWIM);
                        monster_death_use ();
                        Captured (attacker);
                        self.flags = df;    // So summoning works right.
                        self = swap;
                        return;
                    }
*/
    //- - - - - - - - -
        monster_death_use ();
    //- - - - - - - - -
    // PM:  Special death if killed by a void trigger.
        if (attacker.classname == "trigger_void")
            if (self.th_void)
                {self.th_void ();  self = swap;  return;}
    //- - - - - - - - -
        self.th_die ();
    }
    self = swap;
};

//============
// T_Kill
//
// Use this to kill 'targ' instantly regardless of protections.
//============
void(entity targ, entity inflictor, entity attacker, float hp, string dtype)
    T_Kill =
{
    if (!targ)
        return;     // Can't kill the world.
    if (targ.deadflag)
        return;     // Already dead!
// FIXME:  Should we ignore takedamage?

// Automatically use chaos device to save the player from death.
    if (Use_ChaosArmor (targ))
        return;

// Used by buttons and triggers to set activator for target firing.
// If minion did it, give credit to master, so messages can be displayed.
    damage_attacker = Patriarch (attacker);

// Don't bother with knockback.
    damage_velocity = '0 0 0';

    if (targ.flags & FL_CLIENT)
    {   // Go through the trouble of red flashing the hud.
        targ.dmg_take       = 255;      // Assume max/infinite damage.
        targ.dmg_inflictor  = inflictor;
    }
    targ.hit_points =
    targ.health     = hp;
    Killed (targ, attacker, dtype);
};

//============
// Kill_Cheater
//============
float(entity targ, entity inflictor, string dtype) Kill_Cheater =
{
    if (!targ.deadflag)
    if (targ.flags & FLx_CREATURE == FL_CLIENT)
    {
        // Remove lifesaving artifacts, then kill!
        Armor_Remove (targ);

        Safe_centerprint (targ, "C H E A T E R !");
        T_Kill (targ, inflictor, world, -99, dtype);
// DISABLED -- No need for beep sound.
//        sound (targ, CHAN_AUTO, "misc/talk.wav", 1, ATTN_NORM);
        return TRUE;
    }
    return FALSE;
};

// Calculates quad percentile damage.
float(float damage) FourZaps =
{
    local   float   minus;

// First, save +/- sign.
    if (damage < 0)
        minus = TRUE;
    else
        minus = FALSE;
    damage = fabs(damage);
// Second, calculate damage is if hit four consecutive times.
// Don't multiply damage by 4 or else it becomes a one-hit kill if base
// damage% was 25+.
    if (damage > 100)
    {
        damage = (damage - 100) / 100;
        damage = damage * damage * damage * damage;
        damage = damage * 100;
    }
    else
    {
        damage = (100 - damage) / 100;
        damage = damage * damage * damage * damage;
        damage = (damage * -100) + 100;
    }
// Restore sign.
    if (minus)
        damage = 0 - damage;

    return damage;
};

// Knockback!
void(entity targ, entity inflictor, float damage, float dflags) T_KnockBack =
{
    local   vector  dir;

    if (!targ)
        return;     // Can't move the world!

    dir = '0 0 0';
    if (inflictor)
        if (!(dflags & DF_NO_KNOCK))
    {
        dir = targ.origin - (inflictor.absmin + inflictor.absmax) * 0.5;
        dir = normalize(dir);
        dir = dir*damage*8;
        // If target is a player, move him now.  Do not check for
        // movetype_walk because the player may use flight.
        if (targ.classname == "player")   // Was 'movetype == MOVETYPE_WALK'.
            targ.velocity = targ.velocity + dir;
        else if (dflags & DF_PUSH_NPC)
        {
            if (targ.mass && (targ.mass <= MASS_SUPER))
            if (targ.solid != SOLID_BSP)
            {
                if (targ.mass == MASS_SUPER)
                    dir = dir * 0.5;    // Harder to shove.
                targ.velocity = targ.velocity + dir;
                if (targ.flags & FL_ONGROUND)
                {   // Engine does not update velocity unless falling.
                    targ.flags = targ.flags - FL_ONGROUND;
                    targ.velocity = dir;    // Set to new velocity.
                    if (targ.velocity_z < 150)
                        targ.velocity_z = 150;
                }
                else
                    targ.velocity = targ.velocity + dir;
            }
        }
    }
    damage_velocity = dir;
};

//============
// T_Damage
//
// The damage is coming from inflictor, but get mad at attacker
// This should be the only function that ever reduces health.
//
// FIXME:  Pass impact point and velocity.
//============
void(entity targ, entity inflictor, entity attacker, float damage,
    float dflags, string dtype) T_NewDamage =
{
    if (!targ.takedamage)
    {
        if (!(dflags & DF_NO_SHIELDS) || !(targ.xfl & XFL_SHIELDS))
            return;
        // ELSE... penetrate the mega-enforcers' shields.
    }
    if (dflags & DF_BLESSED)
        if (Ally_Check (targ, attacker))
            return;     // A 'blessed' attack ignores allies.

//    local   vector  dir;
    local   entity  oldself;
    local   float   save;
    local   float   take;
    local   float   burn;       // PM:  Burn damage.
    local   float   misc;       // PM:  Miscellaneous float.
    local   float   exotic, adamant;    // Update 5/13/10:  Exotic armors.

// Used by buttons and triggers to set activator for target firing.
// If minion did it, give credit to master, so messages can be displayed.
// FIXME:  This may cause weird things for other code that use damage_attacker.
//         Example:  Gremlin uses it to determine choice of death animation.
    damage_attacker = Patriarch (attacker);

// check for quad damage powerup on the attacker
// PM:  Yes, I know Quake2 does it differently and better, but this is simple
// and works well enough.
    if (!(dflags & DF_PROXY))
    {
        if (attacker.curse_type == CURSE_WEAKEN)
            damage = damage / 2;    // FIXME:  What if percentile damage?
        if (attacker.perms & POW_VAMPIRE)
            if (dflags & DF_MELEE)
                damage = damage * 1.25;
        if (attacker.super_damage_finished)     // IT_QUAD
        {
            if (dflags & DF_PERCENT)
                damage = FourZaps (damage);
            else
                damage = damage * 4;
            dflags = dflags | DF_SCAR;  // Let quad anything blast zombies.
        }
    }

// Check for health percentage mod.  Works like Static Field from Diablo2.
    if (dflags & DF_PERCENT)
        damage = targ.health * damage / 100;

// - - - - - - - - - - - - - - - - - - -
// check for other damage modifiers
//
// PM:  Unlike Diablo II, apply resistance to armor too.
// We (generally) don't know how the target gets his resistance.
// That is, barrier (always full damage) vs. innate/buffs (use resists).
// - - - - - - - - - - - - - - - - - - -
    burn = 0;
    misc = 0;
    damage = ResistDamage (targ, damage, dflags);

// Empathy shields - - - - - - - - - - -
// PM:  This is DANGEROUS!!!  Prone to bugs if not careful.
//  Check the comments in some of the monster files, namely those with
//  jump attacks, to see the changes I made to prevent thorns-related bugs.
// - - - - - - - - - - - - - - - - - - -
    if (targ.thorns_finished)
        if (!(dflags & DF_NO_ARMOR))
    {
        take = dflags & DF_PROXY;
        if (take || !attacker.thorns_finished)
        {
            damage = damage * 0.5;
            if (!take)
                T_NewDamage (attacker, targ, targ, damage, dflags, "thorns");
            // ELSE... damage by proxy.
            // Damage did not really come from the attacker, even though
            // all the credit goes to him.

            // Was placed between invulnerability and teamplay checks.
            if (targ.thorns_sound < time)
            {
                if (powcache & PCH_THORNS_USE)
                    sound (targ, CHAN_ITEM, "hipitems/empathy2.wav", 1, ATTN_NORM);
                targ.thorns_sound = time + 0.5;
            }
        }
        // ELSE both sides have thorns, and they cancel each other out.
    }
// - - - - - - - - - - - - - - - - - - -
// Final damage
    damage = ceil(damage);

// figure momentum add
    T_KnockBack (targ, inflictor, damage, dflags);

// Check for invulnerability.  In classic Doom, invulnerability did not
// red flash or otherwise change the player's view.  Some other Quake mods
// harken back to that style.
    if (targ.flags & FL_GODMODE)
    {
        if (skill < 4)
            return;
        if (!(targ.flags & FL_CLIENT))
            return;
    // Players can't cheat in Hell.
        targ.flags = targ.flags - FL_GODMODE;
        if (Kill_Cheater (targ, inflictor, "fell from grace"))
            return;
    }
    if (targ.invincible_finished)
    {
        ProtectSound (targ);
        return;
    }
// Cross of Deflection - - - - - - - - -
    if (targ.cross_finished)
    {   // Note:  Cross reduces damage only, not knockback.
        CrossSound (targ);
        if (dflags & DF_CROSS_BLOCK)
            return;     // Negate all damage from this attack.
        damage = ceil(damage * 0.5);    // Even armor-piercers get affected.
    }
// - - - - - - - - - - - - - - - - - - -
// Friendly fire.  Placed after shielding items.
    if (teamplay == 1)
        if (Team_Match (targ, attacker))
            return;     // team play damage avoidance
// FIXME:  Too messy, rewrite.
    if (targ.xfl & XFL_BOSS)
    {
        // SoE:  Bane clones.
        if (targ.classname == attacker.classname)
            if ((targ.classname == "monster_bane") || (targ.classname == "monster_morph"))
                if (Ally_Check (targ, attacker))
                    return;     // Bane can't hurt himself and his clones.
        // Minion immunity.
        if (targ == attacker.master)
            if (Ally_Check (targ, attacker))
                return;     // Immune to minions' attacks.
    }
// - - - - - - - - - - - - - - - - - - -

// Damage vs. protection
    take = damage;
    save = 0;
    exotic = Armor_Exotic (targ);
    adamant = Armor_Infinite (targ);

    // Save damage based on target's armor level.
    // Note:  Treat armorvalue of morphed players more like health by
    //  absorbing all damage, even armor-piercing damage.
    if (!(dflags & DF_NO_ARMOR) || targ.form_active)
    {
        damage = damage - PowerArmor_Absorb (targ, damage, TRUE);

//        take = 1;
        if (targ.form_active)
        {   // Absorb all damage while in monster form.
//            if (targ.form_active == FORM_SCORPIO)
//                take = 2;   // Centroid has 300 hp.  150 * 2 = 300 hp.
//            save = damage / take;
            save = damage;
        }
        else if (targ.armortype)
        {   // Target has armor.
            if ((exotic != SUIT_COURAGE)  ||  UseCourage (targ, inflictor.origin))
                save = ceil (targ.armortype * damage);
        }
        else if (exotic == SUIT_CHAOS)
        {
            if (targ.health > 0)
            {
                save = Armor_ChaosRating (targ);
                save = ceil (save * damage);
                // Chance to confuse attacker.  Must delay confusion
                // in case T_Damage was called within T_RadiusDamage.
// DISABLED -- I need to precache a sound to use this, and there's never
// enough slots!  Variable absorption and teleportation should be chaotic enough.
//                if (!(dflags & DF_PROXY))
//                    if (random() < (save + 1) * 0.01)
//                        Confusion_Delayed (attacker, targ);
            }
        }

        if (save)   // Non-zero only with armor, and most are unarmored.
        {
            if (targ.curse_type == CURSE_ARMOR)
                save = ceil(save / 2);      // Armor is not as effective.
            if (!adamant)
                if (save > targ.armorvalue)
                    save = targ.armorvalue;
            take = ceil (damage - save);
    //        take = ceil (damage - save * take);
        }
    }

// Light up the screen if target is a living client.
    if (targ.flags & FL_CLIENT)
    {
        if (!targ.deadflag)
        {
            //- - - - - - - - -
            // Timed, continuous, or persistant damage hurts the target each
            // frame (or every other frame) it is active, and flashing the
            // hud each time will eventually blind the client with red flash.
            //
            // Leave the hud alone if damage is timed and the client is
            // already reeling in pain.
            //- - - - - - - - -
            if ( !(dflags & DF_TIMED) || (targ.pain_finished <= time) )
            {
                if (damage < 0)
                    stuffcmd (targ, "bf\n");    // Use yellow flash.
                else
                {
                    targ.dmg_take = targ.dmg_take + take;
                    targ.dmg_save = targ.dmg_save + save;
                }
            }
            targ.dmg_inflictor = inflictor;
        }
    }

    // Now check for armor damage.
    if (save)
    if (!adamant)
    {
        misc = targ.armorvalue;     // Remember armor before hit.
        targ.armorvalue = targ.armorvalue - save;
        if ((targ.armorvalue <= 0) && !Armor_Indestructible (targ))
        {   // Normal procedure.
            Armor_Remove (targ);    // Lost all armor.
            exotic = 0;
        }
        else if (damage < 0)
        {   // Negative damage can increase armor value.  For clients,
            // do not let it rollover the max of 255 (8-bit).
            if (targ.flags & FL_CLIENT)
                if (targ.armorvalue > 250)
                {   // Move unused armor into health.
                    take = take - (targ.armorvalue - 250);
                    targ.armorvalue = 250;
                    if (misc >= 250)
                        misc = 0;
                }
            if (misc)
                ProtectSound (targ);
        }
        else if (!take)
        {
            if ((exotic == SUIT_SPIRIT) || (exotic == SUIT_ULTRA))
            {   // Spirit armor absorbed all damage this time.
                ProtectSound (targ);
                return;     // Yes, even if a monster wouldn't notice.
            }
        }
    }

// Check for post-armor resistance, like CTF's Earth rune.
// Protection that is applied after armor damage and momentum.
// Note:  Multipliers first, then additions.
//    if (targ.tech == TECH_ARMOR)
//        take = take / 2;
    if (targ.curse_type == CURSE_DAMAGE)
        take = take * 2;
    if (exotic == SUIT_BERSERKER)   // Demonhide increases damage taken.
        take = take * 1.3;          // Green armor reduces 30%, reverse it!
    take = floor(take);
// DISABLED -- Phaser/Wand doesn't reduce damage anymore.
// Keep the code handy in case I want to add a protection artifact.
//    // Holding the wand reduces damage by one -- think ring of protection +1.
//    if (!targ.form_active)
//        if (targ.war == WAR_ZAPPER)
//            if (targ.arsenal & WAR_ZAPPER)
//                if (take > 0)
//                    take = take - 1;

// Negative damage check.
    if (take < 0)
    {   // Negative damage?  Heal the target.  One of czg's maps has a
        // fountain that heals the player by causing negative damage.
        // Since negative damage could add health over the normal limit
        // in the standard progs.dat, do so here too.
        if (T_Heal (targ, 0 - take, 2))     // 2 = Heal even dead things.
        {
            if (targ.health >= 1)
            {
                if (targ.deadflag == DEAD_DEAD)
                    monster_revive (targ, targ);
// DISABLED -- No sound please.
//                else if (!targ.deadflag)
//                    ProtectSound (targ);
            }
        }
        return;
    }

// Check for burn damage.  Works only if player did not heal from damage.
// Warning:  Ugly hack alert -- the big burn hack!
    if (dflags & DF_BURN)
    {   // Okay, here's the deal.  The ignition stuff is tailored specially
        // for dragons' fire attacks.  Anything that lights stuff on fire
        // is set rigidly to the same standard.  I could change the code to
        // allow more variable burning stats, but I would need to add yet
        // another variable to be passed to T_Damage, and I don't want to
        // just for the dragons.  Hence, the big burn hack.
        if (dtype == "rabies")  // Named after Diablo2 druid skill.
        {   // 50% chance to infect a new target with fire.
            // Assumes inflictor is a big fire burning on targ.
            if (random() < 0.5)
                Burn_Add (targ, attacker, inflictor.dmg - BURN_PER_SECOND);
            dtype = "fire";     // Change it back.
        }
        else
        {   // Chance to burn equals (damage + 1)%.  E.g., 9 damage = 10%.
            // Yes, use 'damage' and not 'take'.
            if (random() < (damage+1)*0.01)
                Burn_Add (targ, attacker, MAX_BURN_DAMAGE);
        }
    }

// Check if the damage is allowed to hurt the target.  In case of
// zombies/corpses, remove health only on one-hit kill or scar damage.
// Note:  Boss monsters always cause scar damage to other monsters
// because we don't want a lowly zombie to overpower the boss.
//
// Now that 'burn' served its original purpose (or would have), use it as
// a boolean such that TRUE = hurt the target or FALSE = ignore the damage.
    burn = FALSE;
    if (dflags & DF_SCAR)   // This type of damage hurts even the dead.
        burn = TRUE;
    else if ((targ.curse_type == CURSE_ARMOR) || (attacker.xfl & XFL_BOSS))
    {   // Negate zombies' damage immunity.
        if (targ.flags & FLx_CREATURE)
            burn = TRUE;
    }
    else if (targ.deadflag)
    {   // Dead targets are like zombies, damage only if it gibs on one hit.
        if (take > (0 - targ.gib_health))
            if (!(dflags & DF_NO_GIB))
                burn = TRUE;
    }
    else
    {   // Live target -- zombies are hurt only by one-hit kill.
        // Anything else is hurt normally.
        if (!(targ.xfl & XFL_ZOMBIE) || (take >= targ.max_health))
            burn = TRUE;
    }

// Do the damage.
    if (burn)
    {
        // Check for life leech before applying the damage.
        // Only living attackers can leech from living targets.
        // Update:  Healing is done after damage.
        // Note:  It is possible for attacker to leech himself.  Silly,
        //  but I do not see why it would not work as long as leech is
        //  kept below 100%.
        // FIXME:  Make leech ineffective against non-living such as undead.
        local   float   ignore, hi;

        ignore = FALSE;
        save = misc = 0;
        if (attacker.health > 0)
        if (attacker.flags & FLx_CREATURE)
        if (targ.flags & FLx_CREATURE)
        {
            if (dflags & DF_LEECH)
            {   if (attacker.family & FAM_WRATH)
                {
                    save = save + 0.5;      // Assume life drain attack.
                    ignore = TRUE;          // Exceed normal health limit.
                }
                else
                    save = save + 0.1;
            }
// DISABLED -- Removed lifetap curse.
//            if (targ.curse_type == CURSE_LIFETAP)
//                save = save + 0.5;
            if (save > 1)
                save = 1;   // Cannot heal more than damage dealt.

            if (take > targ.health)
                hi = targ.health;
            else
                hi = take;
            if (save)
            {
                misc = ceil (hi * save);
            }

            if (dflags & DF_MELEE)
            if (attacker.perms & POW_VAMPIRE)
            if (!(targ.family & FAMx_NONLIVING))
            {
                misc = misc + 1;
                if (misc > hi)
                    misc = hi;
            }
        }
        // Now inflict the damage for real.
        targ.hit_points = targ.health = targ.health - take;
        if (misc > 0)
            T_Heal (attacker, misc, ignore);
    // Update 5/14/2010:  Demonhide lifesaver check.
        if (exotic == SUIT_BERSERKER)
        {   // Demonhide will try to save player from a fatal wound.
            if (targ.health < 1)
            {   // Armor will heal the player then break.
                targ.health = targ.armorvalue + targ.health;
                if (targ.health > targ.max_health)
                    targ.health = targ.max_health;
                targ.hit_points = targ.health;
                if (targ.flags & FL_CLIENT)
                {
                    if (targ.health > 0)
                    {
//                        sound (targ, CHAN_VOICE, "misc/talk.wav", 1, ATTN_NORM);
                        ProtectSound (targ);
                        centerprint (targ, "You absorb your armor!");
                    }
                    // ELSE... Damage was too much to overcome -- tough luck!
                }
                // Saved the player's ass, so go away now.
                Armor_Remove (targ);
            }
        }
    //- - - - - - - - -
// DISABLED -- Regen code.
//        targ.healtime = time + 1;   // Suppress regeneration.
    }
    if (targ.health <= 0)
    {
        // Target was slain!
        if (!targ.deadflag)
        {
            // Shotgun hack:  Knockback on kill!
            if (!q1shot)
            if (dtype == "ssg")
            if (targ.flags & FL_MONSTER)
            if (take >= 25)
            {
                if (targ.classname == "monster_zombie")
                    take = take * 0.5;      // Offset 2x damage from headshot.
                else if (targ.family & FAM_WRATH)
                    take = take * 0.2;      // Give a slight push
                T_KnockBack (targ, inflictor, take, DF_PUSH_NPC | dflags);
            }

            if (dflags & DF_GIB)
                targ.hit_points = targ.health = -99;
            else if (dflags & DF_NO_GIB)
                targ.hit_points = targ.health = 0;
            Killed (targ, attacker, dtype);
        }
        else if (targ.th_gib)
        {
            if (burn)
            {
                oldself = self;
                self = targ;
                if (self.th_gib (0 - take))       // Gibbed if TRUE.
                    self.th_gib = world.null_func;
                self = oldself;
            }
        }
        return;
    }

// React to the damage.
    oldself = self;
    self = targ;

    if (self.flags & FL_MONSTER)
    {
    //- - - - - - - - -
    // Notes:
    // 1) Never react to 'timed' damage because it becomes too easy for
    //  multiple attackers to paralyze the target.
    // 2) AFAIK, doors are both inflictor and attacker.  Also, since doors
    //  are not creatures, monsters can't get mad at it.  So no need for
    //  'if (inflictor.classname != "door")'
    // 3) Normally, DoE dragon does not react.  In this mod, it reacts if
    //  not bound to a path.
    //- - - - - - - - -
        if (attacker)   // != world)
            if (!(dflags & DF_NO_REACT))
                if (!(dflags & DF_TIMED) || !self.enemy)
                    if (!(self.ryuflags & RYU_PATH))    // For DoE dragon.
                        if (Enemy_Check (self, attacker))
                            NewEnemy (attacker);
    }

    if (self.th_pain)
    {
        if (dflags & DF_TIMED)
            take = 0;   // Minimize pain.
        self.th_pain (attacker, take);

        // Do Nightmare stuff on a case-by-case basis like in Quake2.
        // Quake2 has Quake's pain_finished = T+5, but was made moot by
        // the no pain anims in nightmare override most monsters have.
    }

    self = oldself;
};
//============
void(entity targ, entity inflictor, entity attacker, float damage) T_Damage =
{
    T_NewDamage (targ, inflictor, attacker, damage, DF_NONE, "");
};

//============
// T_RadiusDamage
//============
void(entity inflictor, entity attacker, float damage, entity ignore,
    float dflags, string dtype, float radius, float attn) T_RadiusDamage_II =
{
// Do some sanity checking.
    if (damage < 1)
        return;     // No damage, don't waste time.

// Now do the radius damage routine.
    local   float   points;
    local   entity  head;
    local   vector  org;
    local   float   no_water;
    local   float   ldmg;

    dflags = (dflags | DF_CROSS_BLOCK) - (dflags & DF_NO_SHIELDS);
    ldmg = 0;
    no_water = !(dflags & DF_WATER_ONLY);
//    head = QC_FindRadius(inflictor.origin, radius);     // Hits SOLID_NOT.
    head = findradius(inflictor.origin, radius);
    while (head)
    {
        if (head != ignore)
        if (head.takedamage)
        if (!(head.xfl & XFL_FIREANGEL))
        if (no_water || head.h2olevel)
        if (head.solid > SOLID_NOT)     // So DarkPlaces won't gib the fallen.
        {
            // T_RadiusDamage may be called during WorldScan, and the less
            // code ran and functions called, the less likely FitzQuake will
            // crash when a huge mob gets nuked by Mjolnir.  Here, do the
            // math from Midpoint instead of calling the function.
            org = head.origin + (head.mins + head.maxs)*0.5;    //Midpoint (head);
            points = attn * vlen(inflictor.origin - org);
            points = damage - points;
            if (points > 0)
                if (CanDamage (head, inflictor))
                {
                    if (head == attacker)
                    {   // Ignore attacker until after everyone else is hit.
                        if (dflags & DF_PROXY)
                            ldmg = points;
                        else if (!(dflags & DF_SAFE))
                            ldmg = points * 0.5;
                    }
                    else
                        T_NewDamage (head, inflictor, attacker, points, dflags, dtype);
                }
        }
        head = head.chain;
    }

// Damage attacker last.  Why?  Since frags do not go less than zero,
// build up the frags from kills first before applying the suicide penalty.
// FIXME:  Does not account for teammate kills, which reduces frags too.
    if (ldmg)
        T_NewDamage (attacker, inflictor, attacker, ldmg, dflags, dtype);
};
//============
void(entity inflictor, entity attacker, float damage, entity ignore,
    float dflags, string dtype) T_NewRadiusDamage =
{
    T_RadiusDamage_II (inflictor, attacker, damage, ignore, dflags, dtype, damage+40, ATTN_DAMAGE);
};
void(entity inflictor, entity attacker, float damage, entity ignore)
    T_RadiusDamage =
{
    T_RadiusDamage_II (inflictor, attacker, damage, ignore, DF_NONE, "", damage+40, ATTN_DAMAGE);
};

// Use this when we need radius damage originating from a point without
// an inflictor.  Called by a few hitscan attacks.
void(vector spot, entity attacker, float damage, entity ignore,
    float dflags, string dtype) Point_RadiusDamage =
{
    local   entity  e;

    e = spawn();
    setall (e, "", '0 0 0', '0 0 0', spot);
    T_RadiusDamage_II (e, attacker, damage, ignore, dflags, dtype, damage+40, ATTN_DAMAGE);
    remove (e);
};

//- - - - - - - - -
//============
// CalcDamage
//
// Calculates the damage a target would take from an attack.
// Target takes no damage however.  Since multiple values are needed,
// a vector is returned.  x=damage taken, y=armor damage, z = x+y.
//
// Used by shotgun code during the multi-damage loop to check if the damage
// can gib a target and if so, apply the damage immediately to gib target,
// which lets any remaining pellets pass through where the target once stood.
//
// NOTE:  Make sure the damage modifications match those in 'T_Damage'!
//============
vector(entity targ, entity attacker, float damage, float dflags) CalcDamage =
{
    local   float   take, save;
    local   vector  stats;

// Check for items that multiply damage unaffected by armor,
// starting with the quad.
    if (attacker.curse_type == CURSE_WEAKEN)
        damage = damage / 2;
    if (attacker.super_damage_finished)
        if (!(dflags & DF_PROXY))
            damage = damage * 4;
// Resistances
    damage = ResistDamage (targ, damage, dflags);
// Thorns
    if (targ.thorns_finished)
        if (!(dflags & DF_NO_ARMOR))
            if ((dflags & DF_PROXY) || !attacker.thorns_finished)
                damage = damage * 0.5;
// Cross
    if (targ.cross_finished)
        damage = damage * 0.5;

// Final damage before armor.
    take = ceil(damage);

// Check for armor.
    save = 0;
    if (targ.armorvalue)
        if (!(dflags & DF_NO_ARMOR) || targ.form_active)
        {
            if (targ.form_active)
                save = damage;
            else    // FIXME:  Add attack point for courage armor check.
                save = ceil (targ.armortype * damage);
            if (save > targ.armorvalue)
                save = targ.armorvalue;
            take = ceil (take - save);
        }

//    if (targ.tech == TECH_ARMOR)
//        take = take / 2;
    if (targ.curse_type == CURSE_DAMAGE)
        take = take * 2;
    take = floor(take);
// DISABLED -- As per T_Damage.
//    if (!targ.form_active)
//        if (targ.war == WAR_ZAPPER)
//            if (targ.arsenal & WAR_ZAPPER)
//                if (take > 0)
//                    take = take - 1;

// Report the numbers.
    stats_x = take;
    stats_y = save;
    stats_z = take + save;

    return stats;
};
//- - - - - - - - -


//===========================/  END OF FILE  /===========================//

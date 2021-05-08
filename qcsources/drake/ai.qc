//==========================================================================
//  ai.qc
//
//  This file is the a combination of 1.06 QC progs 'fight.qc' and 'ai.qc'
//  plus new noclip movement functions used by wraiths and other such
//  ghostly monsters.  The new noclip AI functions are derived from those
//  in 'sv_move.c' (in q1source).
//==========================================================================


//==========================================================================
// fight.qc
//==========================================================================

//
// A monster is in fight mode if it thinks it can effectively attack its
// enemy.
//
// When it decides it can't attack, it goes into hunt mode.
//

// GLOBALS
// Update 1/7/10:  Moved to global.qc.

//=============================================================================

//- - - - - - - - -
// Checks if enemy is within melee range.  def_range is defined melee range.
// Assumes self has an enemy and can damage said enemy.
float(float def_range) InMeleeRange =
{
    local   float   dist;

    if (!self.enemy.modelindex)
        if (self.enemy.solid == SOLID_NOT)
            return FALSE;       // Phased out of the level.

    dist = vlen(self.enemy.origin - self.origin);
    if (dist > def_range)
        if ( dist > ((self.maxs_x + self.enemy.maxs_x) * SQRT2 + 10) )
            return FALSE;

    return TRUE;    // Within range.
};
//- - - - - - - - -

// Same as W_ShowHostile, minus the quad sound.  Some monsters can abort
// attacks in their attack functions so don't blindly play the quad sound.
void() M_ShowHostile = //{self.show_hostile = time + 1;};
{
    self.show_hostile = time + 1;
    self.attack_time = time;
};

//===========
// DontHurtMe
//
// PM:  Checks if 'self' should attack even though 'ent' is in the way.
// Called by 'CheckAttack' and their monster-specific equivalents.
//===========
float(entity ent) DontHurtMe =
{
    if (ent.flags & FLx_CREATURE)   // Blocked by a possible target.
        if (self.enemy.solid > SOLID_TRIGGER)   // Don't waste time if FALSE.
    {
        if (!Align_Match (self, ent))
            return FALSE;   // Enemies.
        if (ent.enemy == self)
            return FALSE;   // Mad at attacker.
        if (self.oldenemy == ent)
            return FALSE;   // Attacker has a grudge against ent.
    }
    return TRUE;
};

//===========
// CheckAttack
//
// The player is in view, so decide to move or launch an attack
// Returns FALSE if movement should continue
//============
float() CheckAttack =
{
    if (enemy_range == RANGE_FAR)
        return FALSE;   // Don't call traceline again when we don't need to.

    local   vector  spot1, spot2;
    local   entity  targ;
    local   float   chance;

    targ = self.enemy;
    
// see if any entities are in the way of the shot
    spot1 = self.origin + self.view_ofs;
    spot2 = targ.origin + targ.view_ofs;

    traceline (spot1, spot2, FALSE, self);

    chance = 1;     // PM:  Use as melee toggle before missile check.
    if (trace_ent != targ)
    {
        // Didn't hit the intended target.  Either something else blocked
        // the scan, or the scan was complete and could not hit the target.
        // Standard 1.06 progs would just return FALSE.
        if (trace_fraction < 1)
        {   // don't have a clear shot
            if (DontHurtMe (trace_ent))
                return FALSE;   // Don't shoot whoever is in line of fire.

            // Otherwise, whoever is in the way is a potential enemy and
            // hitting him instead of the intended target with missile
            // attacks is still useful.  Melee is still impossible though.
            chance = 0;
        }
        else
        {   // Target is non-solid.  It could be a wraith, downed zombie,
            // or something in spectator mode.

            // Unlike dragons, attack only if the target really is a ghost.
            if (targ.takedamage != DAMAGE_AIM)
                return FALSE;
            if (!IsGhost (targ))
                return FALSE;
// Commented out because those with no mindex should have DAMAGE_NO too.
//            if (!targ.modelindex)
//                return FALSE;
        }
    }

    // PM:  Added alert support so that some monsters can see and attack
    //      through water like players can.
    // FIXME:  Is the 'fish check' necessary here?
    if (trace_inopen)
        if (trace_inwater)
            if (!(self.ryuflags & RYU_ALERT))   // PM:  Alert support.
                return FALSE;            // sight line crossed contents

    if (enemy_range == RANGE_MELEE)
    {   // melee attack
        if (chance)     // PM:  See above in the sight code.
            if (self.th_melee)
            {
                self.th_melee ();
                return TRUE;
            }
    }
    
// missile attack
    if (!self.th_missile)
        return FALSE;
    if (time < self.attack_finished)
        return FALSE;

    if (enemy_range == RANGE_MELEE)
    {
        chance = 0.9;
        self.attack_finished = 0;
    }
    else if (enemy_range == RANGE_NEAR)
    {
        if (self.th_melee)
            chance = 0.2;
        else
            chance = 0.4;
    }
    else if (enemy_range == RANGE_MID)
    {
        if (self.th_melee)
            chance = 0.05;
        else
            chance = 0.1;
    }
    else if (enemy_range == RANGE_LONG)     // PM:  New range!
    {
        if (self.th_melee)
            chance = 0.02;
        else
            chance = 0.04;
    }
    else
        chance = 0;

    if (random () >= chance)
        return FALSE;

/* DISABLED -- Unnecessary for now.
// Update 6/3/10:  If monster spawns an attack from other than its eyes,
// make sure it doesn't impact the wall.
    if (self.attack_ofs != VEC_ORIGIN)
    {   // Make sure missile can hit the target from where it spawns.
        makevectors (self.angles);
        spot1 = self.origin + (v_forward*self.attack_ofs_x)
            + (v_right*self.attack_ofs_y) + (v_up*self.attack_ofs_z);
        traceline (spot1, spot2, TRUE, self);
        if (trace_fraction < 1)
            return FALSE;   // Blocked by a wall.
    }
*/

// Attack!
    chance = 2*random();
    self.th_missile ();
    SUB_AttackFinished (chance);
    return TRUE;
};


//=============
// ai_face
//
// Stay facing the enemy
//=============
void() ai_face =
{
// Wraith AI - - - -
    if (self.movetype == MOVETYPE_NOCLIP)
        self.velocity = '0 0 0';
// - - - - - - - - -

// PM:  May be called while not fighting.  Face goalentity if no enemy.
    if (self.enemy)
        self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
    else
        self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
    ChangeYaw ();
};

//=============
// ai_charge
//
// The monster is in a melee attack, so get as close as possible to .enemy
//=============
// Update 1/7/10:  visible, infront, and range prototypes moved to proto.qc.

void(float d) ai_charge = {ai_face ();  safe_goal (d);};

void(float d) ai_charge_left =
{
    local   vector  dtemp;
    local   float   heading;

// aim to the left of the enemy for a flyby
    self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
    ChangeYaw ();

    makevectors (self.angles);
    dtemp = self.enemy.origin - 30*v_right;
    heading = vectoyaw(dtemp - self.origin);
    
    safe_move (heading, d);
};

void() ai_charge_side = {ai_charge_left (20);};


//=============
// ai_dizzy
//
// PM:  Randomize current facing if enemy is invisible.
// Used by monsters with jumping attacks (e.g., dogs, fiends).
//=============
void() ai_dizzy =
{
// FIXME:  Dive through Doom source and figure out exactly how the
// partial invisibility works.
    if (self.enemy.invisible_finished || (self.enemy.items & IT_INVISO))
    {   // Select an angle up to 20 degrees (in steps of 5) away from ideal.
        // Monster only has a 20% chance of aiming at the right angle.
        local   float   r, oy;

        r = random() * 4;
        r = floor(r) * 5;
        if (r)
        {
            if (random() < 0.5)
                r = 0 - r;

            oy = self.ideal_yaw;
            self.ideal_yaw = anglemod(self.angles_y + r);
            ChangeYaw ();
            self.ideal_yaw = oy;
        }
    }
};


//==========================================================================
// ai.qc
//==========================================================================

// NOTE:  'anglemod()' moved to 'subs.qc', with all the other math stuff.

//
// globals
//
// Update 1/7/10:  Moved to global.qc.


//============================================================================

//=============
// range
//
// returns the range categorization of an entity reletive to self
// 0    melee range, will become hostile even if back is turned
// 1    visibility and infront, or visibility and show hostile
// 2    visibility and infront
// 3    visibility, infront, and show hostile
// 4    only triggered by damage
//=============
float(entity targ) range =
{
    local   vector  spot1, spot2;
    local   float   r;

    spot1 = self.origin + self.view_ofs;
    spot2 = targ.origin + targ.view_ofs;
    
    r = vlen (spot1 - spot2);
    if (r < 120)
        return RANGE_MELEE;
    if (r < 500)
    {   // PM:  Extend melee range for huge monsters like the dragon.
        if (r < (self.maxs_x + targ.maxs_x) * SQRT2 + 30)   // FIXME: +20?
            return RANGE_MELEE;
        else
            return RANGE_NEAR;
    }
    if (r < 1000)
        return RANGE_MID;
    if (r < 3000)   // PM:  3K worked for AirQuake.  SoE levels are big.
        return RANGE_LONG;
    return RANGE_FAR;
};

//=============
// visible
//
// returns 1 if the entity is visible to self, even if not infront ()
//=============
float(entity targ) visible =
{
    local   vector  spot1, spot2;
    
    spot1 = self.origin + self.view_ofs;
    spot2 = targ.origin + targ.view_ofs;
    traceline (spot1, spot2, TRUE, self);   // see through other monsters
    
    if (trace_inopen)
        if (trace_inwater)
            if (!(self.ryuflags & RYU_ALERT))   // PM:  Alert support.
                if (!self.h2olevel || !targ.h2olevel)   // PM:  Fish check
                    return FALSE;       // sight line crossed contents
// About 'fish check' above:  In normal Quake, if a fish's eyes are above
// the water (happens when origin is less than 10 pixels away from surface)
// while the target is underwater, the fish cannot see, let alone attack,
// the target.  A clever player can exploit this and make fish fights a
// non-challenge.  To fix this, the trace is allowed to pierce contents
// when both entities are in the water.

    if (trace_fraction == 1)
        return TRUE;
    return FALSE;
};

// visible2 -- same as visible except a 'src' entity takes place of self.
float(entity targ, entity src) visible2 =
{
    local   entity  os;
    local   float   found;

    os = self;
    self = src;
    found = visible (targ);
    self = os;

    return found;
};

//=============
// infront
//
// returns 1 if the entity is in front (in sight) of self
//=============
float(entity targ) infront =
{
    local   vector  vec;
    local   float   dot;
    
    makevectors (self.angles);
    vec = normalize (targ.origin - self.origin);
    dot = vec * v_forward;

    return (dot > 0.3);
};


//============================================================================
// NOTE:  'ChangeYaw' is a builtin function.
//============================================================================

//- - - - - - - - -
// Like checkclient, but for monsters.
// Checks if a given target is available for attacking.
// The entity targ is supposed to be the current entity on a given hitlist.
entity(entity targ) CheckTarget =
{
    if (targ.health > 0)
        if (visible (targ))
            return targ;
    return world;
};
//- - - - - - - - -

//- - - - - - - - - - - - - - - - - - -
void() SwapTarget =
{
// Taken from 'HuntTarget'.
    self.fighting       = TRUE;
    self.search_time    = time + 5;
    self.goalentity     = self.enemy;
    self.ideal_yaw      = vectoyaw(self.enemy.origin - self.origin);
};
//- - - - - - - - - - - - - - - - - - -
void() HuntTarget =
{
    SwapTarget ();
    self.think          = self.th_run;
    self.nextthink      = time + 0.1;
    if (self.ryuflags & RYU_ALERT)
        SUB_AttackFinished (0.5);   // alert monsters don't wait as long...
    else
        SUB_AttackFinished (1);    // wait a while before first attack
};

// Function 'SightSound' removed.  Each monster has its own sight function.

// PM:  Moved from FoundTarget because wyrm AI uses this too sans HuntTarget.
void() SoundTarget =
{
    if (!Align_Match (self.enemy, self))    // Used to check players only.
    {   // Let other monsters see this monster for a while
        sight_entity = self;
        sight_entity_time = time;
    }
    
    self.show_hostile = time + 1;        // wake up other monsters

// FIXME:  If oldenemy, do something else.
    if (self.th_sight)
        self.th_sight (FALSE);      // Hostile sound
};

void() FoundTarget =
{
    SoundTarget ();
    HuntTarget ();
};

//- - - - - - - - - - - - - - - - - - -
// PM:  Checks for infighting between 'targ' and 'self'.
//      Assumes both are of good alignment.
float(entity targ) UnitedWeStand =
{
//- - - - - - - - -
// When any target (even a player) is killed, its enemy is set to its slayer.
// Therefore, abort if the master is dead.
//
// Note:  Check only the immediate master -- don't waste time checking on
// grandfathers via the patriarch loop.
//- - - - - - - - -
    if (self.master.health > 0)     // Also:  World has health of zero.
        if ((targ.enemy == self.master) || (targ.oldenemy == self.master))
            return FALSE;

    return TRUE;
};

float(entity targ) SeeTarget =
{
    if (!targ.modelindex)
        return FALSE;   // sf64 and/or eth wraith.  Treat as non-existant.
//- - - - - - - - -
// SoE
    if (angry_monsters)
    {   // PM:  Don't let followers get distracted.
        if (!self.master)
        {
            if (self.enemy)
                if (!visible (targ))
                    return FALSE;
            return TRUE;
        }
    }
//- - - - - - - - -
    if (targ.flags & FL_NOTARGET)   // FIXME:  Remove if you want to stop
        return FALSE;               // ......   the Notarget cheat.
// Check IT_INVISO also only because the old code did so.
    if (targ.invisible_finished || (targ.items & IT_INVISO))
    {
        // Invisible, only those alert will wake up on sound.
        if (!(self.ryuflags & RYU_ALERT))
            return FALSE;
        if (targ.show_hostile < time)
            return FALSE;

        // Made it here?  Enemy was alerted by a noise.
    }

    local   float   r;

    r = range (targ);
    if (r == RANGE_FAR)
    {
        if (self.ryuflags & RYU_ALERT)
            r = RANGE_LONG;
        else
            return FALSE;   // Standard
    }

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
    else if (r == RANGE_LONG)
    {
        if (targ.show_hostile < time)
            return FALSE;
        if (!infront (targ))
            return FALSE;
    }

    return TRUE;
};
//- - - - - - - - - - - - - - - - - - -

//===========
// FindTarget
//
// Self is currently not attacking anything, so try to find a target
//
// Returns TRUE if an enemy was sighted
//
// When a player fires a missile, the point of impact becomes a fakeplayer
// so that monsters that see the impact will respond as if they had seen the
// player.
//
// To avoid spending too much time, only a single client (or fakeclient) is
// checked each frame.  This means multi player games will have slightly
// slower noticing monsters.
//============
float(entity targ, float united) FindTarget_II =
{
    if (!targ)
        return FALSE;   // No enemy to fight.
    if (targ == self)
        return FALSE;   // Don't target itself.
    if (targ == self.enemy)
        return FALSE;   // Already fighting this target.

    if (!SeeTarget (targ))
        return FALSE;

//
// got one
//
    if (united)
        if (Align_Match (targ, self))
    {
        // Indirect check for what is likely 'sight_entity'.
        targ = targ.enemy;
        if (targ.health <= 0)   // This also catches !targ.
            return FALSE;   // Don't pass the dead in a neverending loop.
        if (Align_Match (targ, self))   // Was (targ.classname != "player")
            return FALSE;
    }
    self.enemy = targ;
    return TRUE;
};

float() FindMasterEnemy =
{
// Abort if dead or the world.  World always has 0 health.
    if (self.master.health > 0)
      if (self.master.enemy.flags & FLx_CREATURE)     // Hack:  No souls!
        return  FindTarget_II (self.master.enemy, FALSE);
    return FALSE;
};

float() FindBadGuy =
{
    local   entity  head;

// This check can slow down the game if every monster did this, so do it
// only if the monster is seen by its master if the master is a client.
// Note:  Don't bother with this if player not the master, even if he is
// the patriarch in the chain of command.
    if (self.master.flags & FL_CLIENT)
        if (visible (self.master))
    {
    // 1000 is the standard max distance to find targets.  1500 is Hip's
    // charmed radius.  3000 is Drake's new max distance.  The lower the
    // distance, the faster the game runs.  Since the gremlin is limited to
    // 1000, use that.
        head = findradius (self.origin + self.view_ofs, 1000);
        while (head)
        {
            // Since only good guys call this function, check only for bad
            // guys (less code to run).  Bad guys don't need to use this
            // because they are busy scanning for clients, not NPCs, to kill.
            // Note:  visibility is checked in FindTarget_II, so no need to
            // do a vis check here.
            if (head.alignment == EVIL)
                if (head.health > 0)    // && visible (head))
                    if (FindTarget_II (head, TRUE))
                        return TRUE;
            head = head.chain;
        }
        return FALSE;       // Nothing found.
    }

// Just check the selected monster on the blacklist.
    head = CheckTarget (blacky);
    return FindTarget_II (head, TRUE);
};

float() FindTarget =
{
    if (cutscene)
        return FALSE;   // Don't search for targets during a cutscene.
    if (self.ryuflags & RYU_CALM)
        return FALSE;   // Do not bother looking for targets if pacifist.
// Wraith AI - - - -
    if (self.movetype == MOVETYPE_NOCLIP)   // Most monsters aren't wraiths.
        if (pointcontents (self.origin + self.view_ofs) == CONTENT_SOLID)
            return FALSE;   // Don't let wraiths see targets while in the wall.
// - - - - - - - - -

// if the first spawnflag bit is set, the monster will only wake up on
// really seeing the player, not another monster getting angry

// Update:  spawnflags & 3 hack is obsolete in Drake.
// Zombie spawnflags get changed as necessary during spawn time.
    if (sight_entity_time >= time - 0.1 && !(self.spawnflags & 1) )
    {
        if (sight_entity.health <= 0)
            return FALSE;
        if (sight_entity.enemy == self.enemy)
            return FALSE;
        if (!FindTarget_II (sight_entity, TRUE))
            return FALSE;
    }
    else if (!FindMasterEnemy ())   // New:  Check a master's enemy 1st.
    {
        // Builtin 'checkclient' ignore entities with zero or negative health.
        local   entity  targ;

        if (self.alignment == GOOD)
        {
    //- - - - - - - - -
            if (deathmatch)
            {   // Look for enemy clients to kill first.
                if (PlayerIsKing (self))
                {
                    targ = checkclient ();   // Select a player.
                    if (!Align_Match (targ, self))
                        if (FindTarget_II (targ, FALSE))    // No NOT op !.
                        {
                            FoundTarget ();
                            return TRUE;
                        }
                }
            }
    //- - - - - - - - -
            if (!FindBadGuy ())
            {
                // No bad guys.  Check for good monsters gone bad.
                // If no enemy is found, look for a client to team up with.
                targ = CheckTarget (whitey);
                if (UnitedWeStand (targ))    // Good guy if true.
                    return FindNewMaster (targ);    // Was FALSE.
                if (!FindTarget_II (targ, FALSE))
                    return FindNewMaster (targ);    // Was FALSE.
            }
        }
        else
        {
            // Check one player, and if that fails, check one NPC.
            targ = checkclient ();   // Select a player.
            if (!FindTarget_II (targ, TRUE))
            {
                targ = CheckTarget (whitey);    // Select one NPC at a time.
                if (UnitedWeStand (targ))
                {   // Normal
                    if (!FindTarget_II (targ, TRUE))
                        return FALSE;
                }
                else
                {   // Target is a rogue, attacking "self"'s master.
                    if (!FindTarget_II (targ, FALSE))
                        return FALSE;
                }
            }
        }
    }

    FoundTarget ();
    return TRUE;
};


//===========
// FindNewMaster
//
// Returns TRUE if a new ally was sighted.
// Called by FindTarget to find a friend when it can't find an enemy.
//============
float(entity targ) FindNewMaster =
{
    if (self.enemy)
        return FALSE;   // Too busy fighting to look for allies.

    if (!self.master)   // Warning: 'self.master == self' causes weirdness.
    {
        local   entity  swap;

        swap = self.enemy;
        targ = checkclient ();
        if (FindTarget_II (targ, FALSE))
        {
            // '.enemy' will be set at 'targ'.  That is our new master!
            if (self.th_sight)
                self.th_sight (TRUE);   // Welcome sound
// FIXME:  Could be expanded to allow dialogue with NPCs.
            // "You have a new friend...\n"
            if (!IsEmptyString (self.message))
            {
                centerprint (self.enemy, self.message);
                self.message = "";      // SoE:  Print only once.
            }
            self.master = self.enemy;
            self.enemy = swap;
            return TRUE;
        }
    }

    return FALSE;
};

// Called from 'monsters.qc' when a monster finds a player to serve.
void() FoundMaster =
{
    if (self.th_sight)
        self.th_sight (TRUE);   // Welcome sound
    HuntTarget ();
};


//=============================================================================

//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//=============
void(float dist) ai_pet_patrol =
{
// Note:  If a cutscene activates when the monster is walking its beat,
//  allow it to continue walking because it is not following its master,
//  whom the latter gets transported elsewhere as a camera entity.

    if (!MatchingIdeal ())
        {ChangeYaw(); return;}

// Wraith AI - - - -
    if (self.movetype == MOVETYPE_NOCLIP)
    {
        // 'noclip_move' sets velocity.
        if (self.velocity == '0 0 0')
            noclip_move (self.angles_y, dist);
        else
        {
            noclip_move (self.angles_y, dist);
            if (pointcontents (self.origin) == CONTENT_SOLID)
            {
                self.ideal_yaw = anglemod (self.angles_y + 180);
                self.velocity = '0 0 0';
            }
        }
    }
// - - - - - - - - -
    else
    {
        if (!safe_move (self.angles_y, dist))
            self.ideal_yaw = anglemod (self.angles_y + 180);
    }
};

//=============
// ai_pet_stay
//
// Monster stays put until ready to follow master.
//=============
void() ai_pet_stay =
{
    if (self.master)    // Warning: 'self.master == self' causes weirdness.
    {
        if (cutscene)
            return;     // Stay put in cutscenes.
        if (self.ryuflags & RYU_STAY)
            return;     // Staying put as told.
        if (self.ryuflags & RYU_PATROL)
        {
            self.think = self.th_walk;
            return;
        }

    // Prepping monster to run again soon.
        self.search_time = time + 3;

        local   vector  vec;
        local   float   delta;

        self.goalentity = self.master;
        vec = self.master.origin - self.origin;
        delta = vlen(vec);
        if (delta > self.zones_z)
            self.think = self.th_run;
        else if (delta <= self.zones_x)
        {
            // Should run now, but delay it for one frame to avoid double
            // call to FindTarget.  In the meantime, make the monster
            // turn away.
            self.think = self.th_run;
            vec = vec * -1;
        }
        self.ideal_yaw = vectoyaw(vec);
        ChangeYaw ();
    }
};

//=============
// ai_pet_follow
//
// Monster follows its master to the best of its ability.
//=============
void(float dist) ai_pet_follow =
{
    if (self.master)    // Warning: 'self.master == self' causes weirdness.
    {
        if (cutscene)   // Stop immediately if a cutscene activates.
            {self.think = self.th_stand; self.nextthink = 0.01; return;}

        local    vector  vec;
        local    float   delta2;
        local    float   seen;
        local    entity  swap;

        self.goalentity = self.master;
        if (self.movetype == MOVETYPE_NOCLIP)
            seen = TRUE;
        else
            seen = visible (self.goalentity);
        vec = self.master.origin - self.origin;
        delta2 = vlen(vec);

        if (self.ryuflags & RYU_STAY)
            self.think = self.th_stand;
        else if (self.ryuflags & RYU_PATROL)
            self.think = self.th_walk;
        else if (seen)
        {
            if (delta2 <= self.zones_x)
                vec = vec * -1;
            else if (delta2 <= self.zones_z)
                self.think = self.th_stand;
        }

        // If true, should stop now, but delay it for one frame to avoid
        // double call to FindTarget.  In the meantime, make monster slower.
        if (self.think == self.th_stand)
            dist = dist * 0.5;
        // NOTE:  No need to slow monster down if think == th_walk.

        dist = ceil(dist * 1.5);    // Speed up to keep up with player.
        if (dist > 32)      // Don't go faster than player.
            dist = 32;      // Assumes 'sv_maxspeed' is default of 320.

        // 'walkmove' and 'movetogoal' makes flying monsters go up or down
        // automatically toward enemy.  Make the goalentity into the enemy
        // for a moment so scrags and fish can rise or sink with master.
        // FIXME:  If injured during move, such as from a touch function
        //  like trigger_hurt, self.enemy will still point to the goalentity
        //  during the call to T_Damage.
        swap = self.enemy;
        self.enemy = self.goalentity;

        if (seen)
        {
            if (delta2 <= self.zones_x)
            {
                // Too close to master, go away now.
                self.ideal_yaw = vectoyaw(vec);
                ChangeYaw ();
                if (safe_move (self.angles_y, dist))
                    self.search_time = time + 3;
                else
                {
                    // Can't go forward so try a sidestep.
                    local   float   ofs;

                    if (self.lefty)
                        ofs = 90;
                    else
                        ofs = -90;
                    if (!safe_move (self.ideal_yaw + ofs, dist))
                    {
                        self.lefty = !self.lefty;
                        safe_move (self.ideal_yaw - ofs, dist);
                    }
                }
            }
            else
            {
                if (self.search_time >= time)
                {
                    self.ideal_yaw = vectoyaw(vec);
                    ChangeYaw ();
                }

                // The search is set so that if master disappears from
                // view (such as from teleporting), let monster go straight
                // ahead in hopes of finding master.
                if (safe_move (self.angles_y, dist))
                    self.search_time = time + 3;
                else
                {
                    safe_goal (dist);
                    self.search_time = 0;
                }
            }
        }
        else
        {
            // Separated from master -- find him!
            if (self.search_time < time)
                safe_goal (dist);
            else
            {
                self.enemy = world;     // Don't try to change altitude.
                if (!safe_move (self.angles_y, dist))
                    self.search_time = 0;
            }
        }

        self.enemy = swap;
        return;
    }

    safe_goal (dist);
};


//=============================================================================

void(float dist) ai_forward = {safe_move (self.angles_y, dist);};
void(float dist) ai_back = {safe_move ((self.angles_y+180), dist);};

// 'ai_pain' and 'ai_painforward' are obsolete!
// Well, ai_painforward moved toward ideal_yaw, which looked goofy.

//=============
// ai_walk
//
// The monster is walking it's beat
//=============
void(float dist) ai_walk =
{
    if (self.master)    // Warning: 'self.master == self' causes weirdness.
    {
        if (self.ryuflags & RYU_PATROL)
        {
            if (!FindTarget ())     // check for noticing a player
                ai_pet_patrol (dist);
        }
        else    // Override walking and run after master instead with gusto.
            self.th_run ();
        return;
    }

// check for noticing a player
    if (FindTarget ())
        return;

    safe_goal (dist);
// Wraith AI - - - -
    if (self.movetype == MOVETYPE_NOCLIP)
    {
    // Since wraiths can't touch 'path_corner' entities, call their touch
    // function for them if close enough.
        if (self.goalentity.touch == t_movetarget)
            if (vlen (self.goalentity.origin - self.origin) <= (self.maxs_x + 8))
                {SUB_Touch (self, self.goalentity); return;}

    // It is possible for a wandering wraith to never 'touch' its goalentity.
    // In such a case, the wraith must be prevented from moving endlessly in
    // one direction.  To do that, anytime a wraith is in a solid wall, and
    // its ideal_yaw is pointing away from its goalentity, point the wraith's
    // ideal_yaw backward.
        if (pointcontents (self.origin) == CONTENT_SOLID)
        {
            local   vector  dir;
            local   float   delta;

            dir = normalize (self.goalentity.origin - self.origin);
            delta = vectoyaw (dir);
            delta = anglemod (self.ideal_yaw - delta);
            if (delta > 90)
                if (delta < 270)
                {   // Goal is behind wraith.
                    self.ideal_yaw = anglemod (self.ideal_yaw - 180);
                    self.velocity = '0 0 0';    // Stop right now!
                }
        }
//        return;
    }
// - - - - - - - - -
};

//=============
// ai_stand
//
// The monster is staying in one place for a while, with slight angle turns
//=============
void() ai_stand =
{
// Wraith AI - - - -
    if (self.movetype == MOVETYPE_NOCLIP)
        self.velocity = '0 0 0';
// - - - - - - - - -
    if (FindTarget ())
        return;

    ai_pet_stay ();
};

//=============
// ai_turn
//
// don't move, but turn towards ideal_yaw
//=============
void() ai_turn =
{
// Wraith AI - - - -
    if (self.movetype == MOVETYPE_NOCLIP)
        self.velocity = '0 0 0';
// - - - - - - - - -
    if (FindTarget ())
        return;

    ChangeYaw ();
};

//=============================================================================

//============
// FacingIdeal
//============
float() FacingIdeal =
{
    local   float   delta;
    
    delta = anglemod(self.angles_y - self.ideal_yaw);
    if (delta > 45)
        if (delta < 315)
            return FALSE;
    return TRUE;
};

// Variant of 'FacingIdeal' in which TRUE is returned only if difference
// between self's yaw and ideal yaw is one-half of a degree or less.
// Used by patrol related code.
float() MatchingIdeal =
{
    local   float   delta;
    
    delta = rint(self.angles_y - self.ideal_yaw);
    delta = anglemod(delta);
    return !delta;
};


//=============================================================================

//- - - - - - - - -
// Tells the monster to go straight up, if distance is positive.
// A negative distance will make the monster go down instead.
// Returns TRUE if fully or partially successful at moving.
//
// Originally from Dragons.
//- - - - - - - - -
float(float dist) ai_up =
{
    local   entity  box, os;
    local   entity  swap;
    local   vector  spot;

    if (dist < 0)
    {
        dist = 0 - dist;    // 'fabs' it.
        temp_goal.origin_z = self.origin_z - 40 - dist;     // Going down.
    }
    else
        temp_goal.origin_z = self.origin_z - 30 + dist;     // Going up.
    setorigin (temp_goal, temp_goal.origin);

    spot = self.origin;

    swap = self.enemy;
    self.enemy = temp_goal;
    while (dist > 0)
    {
        if (dist < 8)   // walkmove moves self up or down 8 units at a time.
        {   // Last run through loop.
            // Go through the trouble of moving less than 8 units.
            // Create a dummy to move for the monster.  If the dummy
            // can move, it is safe to set origin directly for monster.
            box = spawn();
            box.oldorigin   = self.origin;
            box.angles      = self.angles;
            box.solid       = self.solid;
            box.movetype    = self.movetype;
            box.flags       = self.flags & FLx_NOT_FALLING;
            box.enemy       = self.enemy;
            box.owner       = self;     // Pass through monster.
            setsize (box, self.mins, self.maxs);
            setorigin (box, self.origin);
            os = self;
            self = box;
            if (safe_move (self.angles_y, 0))
            {   // Dummy moved, now move the monster precisely.
                if (self.origin_z > self.oldorigin_z)
                {   // Going up.
                    os.origin_z = os.origin_z + dist;
                    setorigin (os, os.origin);
                }
                else if (self.origin_z < self.oldorigin_z)
                {   // Going down.
                    os.origin_z = os.origin_z - dist;
                    setorigin (os, os.origin);
                }
            }
            remove (box);
            self = os;
        }
        else
            safe_move (self.angles_y, 0);    // Fails only in solid.

        dist = dist - 8;
    }
    self.enemy = swap;

    return (self.origin != spot);
};

float(float dist) ai_down = {return ai_up (0 - dist);};


//=============================================================================

// This keeps the entities of a two-part composite monster together.
// Examples of such monsters include Armagon and IK's turrets from Airquake.
void() ai_synch =
{
    if (self.trigger_field)
    {
        if ((self.modelindex == 0) || (self.modelindex == mindex_inviso))
            self.trigger_field.modelindex = self.modelindex;
        else
            self.trigger_field.modelindex = self.trigger_field.mindex2;
        setorigin (self.trigger_field, self.origin);
    }
};


//=============================================================================

// Specialized behavior for soldier rebel NPCs.
// Modifies move distances and possibly attack state.
float(float d) ai_run_rebel =
{
    if (self.fighting)
    {
        if (self.th_missile)
        {   // If the enemy is too close for comfort, back off.
            // Note:  Don't check for visibility.
            self.attack_state = AS_STRAIGHT;
            if (infront (self.enemy))   // Only if TRUE.
            {
                local   float   dist;
    
                dist = vlen(self.enemy.origin - self.origin);
                if (dist < 300)
                {   // Enemy is close.
                    if (dist < 250)
                        d = 0 - d;      // Backpedal
                    else
                        self.attack_state = AS_SLIDING;     // Sidestep.
                }
            }
        }
        return d;
    }
    return  d * 2;  // Speed up rebels so they can keep up with player.
};


//=============================================================================

float() CheckAnyAttack =
{
    if (cutscene)
        if (self.enemy.classname == "camera")
            return FALSE;   // Don't attack the camera (player)!
    if (!enemy_vis)
    {
        if (self.th_harass)
            return self.th_harass();
        return FALSE;
    }

    if (self.th_check)      // PM:  Simpler than checking by classname.
        return self.th_check ();
    return CheckAttack ();
};


//=============
// ai_run_attack
//
// Fusion of 'ai_run_melee' and 'ai_run_missile'.
// Turn in place until within an angle to launch an attack
// 'thinkst' should be either self.th_melee or self.th_missile.
//=============
void(void() thinkst) ai_run_attack =
{
    self.ideal_yaw = enemy_yaw;
    ChangeYaw ();
    if (FacingIdeal ())
        {thinkst ();  self.attack_state = AS_STRAIGHT;}
};


//=============
// ai_run_side
//
// Move to the side of ideal_yaw.  Assumes ideal_yaw was set prior to a
// call to this function.  Called by 'ai_run_strafe'.
//=============
void(float dist) ai_run_side =
{
    local   float   ofs;
    
    if (self.lefty)
        ofs = 90;
    else
        ofs = -90;

    if (safe_move (self.ideal_yaw + ofs, dist))
        return;

    self.lefty = !self.lefty;
    safe_move (self.ideal_yaw - ofs, dist);
};

//=============
// ai_run_strafe (formerly ai_run_slide)
//
// Strafe sideways, but stay at aproximately the same range
// PM:  Renamed to 'ai_run_strafe', and added float argument 'dist'.
//
// The above description, which describes circle-strafing, is only true if
// enemy_yaw updates each frame, which is true only if this is called from
// ai_run.  If called directly, enemy_yaw probably will not be set, and the
// monster will simply move to the side.
//
// For guaranteed circle-strafing, do the following:
//  {ai_face(); ai_run_side(dist); ai_face();}
//=============
void(float dist) ai_run_strafe =
{
    self.ideal_yaw = enemy_yaw;
    ChangeYaw ();

    ai_run_side (dist);
};

//=============
// ai_run_zigzag
//
// Approach goal while strafing in a zigzag pattern.
// Used by Hipnotic's scorpion.
//=============
void(float dist) ai_run_zigzag =
{
    local   float   ofs, newyaw;

    self.nextthink = time + 0.1;
    if (self.lefty)
        ofs = 40;
    else
        ofs = -40;

    if (time > self.ltime)
        {self.lefty = !self.lefty; self.ltime = time + 0.8;}

    newyaw = enemy_yaw + ofs;
    self.ideal_yaw = enemy_yaw;
    if (safe_move (newyaw, dist))
        {ChangeYaw (); return;}

    self.lefty = !self.lefty;
    self.ltime = time + 0.8;
    newyaw = enemy_yaw + ofs;
    self.ideal_yaw = enemy_yaw;
    safe_move (newyaw, dist);
    ChangeYaw ();
};


//- - - - - - - - -
// SOW = Stand or walk.  Called at the end of a victory dance.
void() monster_sow =
{
    if (self.movetarget)
        self.th_walk ();
    else
        self.th_stand ();
};

// Changes mode from fight to idle.  Does not actually change thinking.
void() ai_calm_down =
{
// Reset fight status.
    self.fighting     = FALSE;
    self.search_time  = time + 3;

// Forget all enemies and go idle.
    self.enemy = self.oldenemy = world;
};

// Monster is done running and going back to stand/walk.
void() ai_run_done =
{
    ai_calm_down ();
    monster_sow ();
};
//- - - - - - - - -

// Check if self should stop running after enemy.
float() ai_run_kill =
{
    local   float   winner;

// Check for victory sound.  Must do first because enemy will be changed.
// Sound is played only if enemy slain is a client.
    winner = FALSE;
    if (self.enemy)
    if (self.enemy.classname == "player")
    if (visible (self.enemy))
    {
        winner = TRUE;
        // Set yaw in case we need to face the fallen during the dance.
        self.ideal_yaw = vectoyaw (self.enemy.origin - self.origin);
    }

    self.enemy = world;
// FIXME: look all around for other targets
    if (self.oldenemy.health > 0)
    {
        self.enemy = self.oldenemy;
        self.oldenemy = world;
        // FIXME:  Replace with simpler version without the thinking.
        HuntTarget ();
    }
    else
    {
        ai_calm_down ();
        if (winner)
            if (self.th_win)
                {self.th_win ();  return TRUE;}   // We have a winner!
        monster_sow ();
        return TRUE;
    }
    return FALSE;
};

//=============
// ai_run
//
// The monster has an enemy it is trying to kill
//=============
void(float dist) ai_run =
{
    if (self.ryuflags & RYU_REBEL)
        dist = ai_run_rebel (dist);

// First, check if monster is fighting an enemy or following its master.
// Note:  Always uses normal fight ai if monster has no master.
    if (!self.fighting)
    {
        if (self.master)
        {   // Running while not in combat, so treat this like walking.
            self.enemy = world;   // Undo the change caused by the fire command.
            if (!FindTarget ())
                ai_pet_follow (dist);
            return;
        }
    }

// see if the enemy is dead
    if (self.enemy.health <= 0)
    {
        if (ai_run_kill ())
            return;
    }

// DISABLED:  Monsters reveal themselves only when waking up or attacking.
// This change was done due to the new alignment rules.
//    self.show_hostile = time + 1;        // wake up other monsters

// check knowledge of enemy  (PM:  Do this even if self is a wraith.)
    enemy_vis = visible(self.enemy);
    if (enemy_vis)
        self.search_time = time + 5;

// look for other targets if current target is unavailable.
// Do this in single-player and DM because of minions and their alignment.
    if (self.search_time < time)
    {
        if (FindTarget ())
            return;

        if (self.master)
            if (self.enemy != self.master)
                if ((self.alignment == GOOD) || (self.classname != "monster_bane"))
                    {ai_run_done(); return;}  // Stop chase and return to master.
    }

//    enemy_infront = infront(self.enemy);
    enemy_range = range(self.enemy);
    enemy_yaw = vectoyaw(self.enemy.origin - self.origin);
    
    if (self.attack_state == AS_MISSILE)
    {   ai_run_attack (self.th_missile);    //ai_run_missile ();
        return;
    }
    if (self.attack_state == AS_MELEE)
    {   ai_run_attack (self.th_melee);      //ai_run_melee ();
        return;
    }

    if (CheckAnyAttack ())
    {   M_ShowHostile ();   // wake up other monsters
        return;                    // beginning an attack
    }

// make a move
    if (self.attack_state > AS_STRAIGHT)
    {
        if (self.attack_state == AS_SLIDING)
            {ai_run_strafe (dist);  return;}
        if (self.attack_state == AS_DODGING)   // Hipnotic's scorpion
            {ai_run_zigzag (dist);  return;}
        if (self.attack_state == AS_VERTICAL)
            {if (self.lefty) dist = 0 - dist;  ai_up (dist);  return;}
        if (self.attack_state == AS_CHASING)
        {   // Move in a straight line to goal if possible.
            if (safe_move (self.angles_y, dist))
            {   // Turn after move, not before.
                self.ideal_yaw = enemy_yaw;
                ChangeYaw ();
                return;
            }
        }
        else if (self.attack_state == AS_FLEEING)
        {   // Move in a straight line away from goal if possible.
            dist = floor (dist / -2);
            if (safe_move (self.angles_y, dist))
            {   // Turn after move, not before.
                self.ideal_yaw = enemy_yaw;
                ChangeYaw ();
                return;
            }
        }
        else if (self.attack_state == AS_FLANKING)
        {
            if (enemy_vis)
            if (enemy_range <= RANGE_NEAR)
            if (InMeleeRange (160))
            {   // Attempt Quoth enforcers' flanking maneuvers.
                if (self.lefty)
                    enemy_yaw = enemy_yaw + 90;
                else
                    enemy_yaw = enemy_yaw - 90;
                self.ideal_yaw = anglemod (enemy_yaw);
                ChangeYaw ();
                if (safe_move (self.ideal_yaw, dist))
                    return;
                if (FacingIdeal ())
                    self.lefty = !self.lefty;
            }
        }
        else if (self.attack_state == AS_COWARDLY)
        {
            if (enemy_vis)
            if (enemy_range <= RANGE_NEAR)
            if (InMeleeRange (120))
            {
                self.ideal_yaw = anglemod (enemy_yaw);
                ChangeYaw ();
                ai_back (dist);
                return;
            }
        }
    }
    safe_goal (dist);
};


//==========================================================================
// HIPNOTIC

//void() ai_turn_in_place =
//{
//    local   float   delta;
//
//    self.nextthink = time + 0.1;
//    enemy_yaw = vectoyaw(self.enemy.origin - self.origin);
//    delta = fabs(self.angles_y - enemy_yaw);
//    if (delta > 10)     // MIN_ANGLE_DELTA = 10
//        {self.ideal_yaw = enemy_yaw; ChangeYaw ();}
//    else
//        self.think = self.th_run;
//};

//==========================================================================
// ROGUE

// Used by missiles to chase/track an enemy.  Flies directly at enemy's
// viewpoint.  e = target, sped = velocity multiplier.
void(entity e, float sped) ai_track =
    {self.velocity = normalize(e.origin + e.view_ofs - self.origin) * sped;};

// Gib stuff moved to dragon.qc.

// FC: isSpawnPointEmpty checks against telefragging.
// From Rogue mission pack.
// PM:  Used by overlord and the Egyptian.  Modified for Drake.
float(entity thePoint) isSpawnPointEmpty =
{
    local   entity  neighbors, start;

// PM:  World is not a legal spawn point entity.  Assume in solid rock.
    if (thePoint == world)
        return 0;

    neighbors = findradius (thePoint.origin, 64);   // Was 64 for soe dmsp.
	if (neighbors == world)
		return 1;

	start = neighbors;
	while (neighbors)
	{
		if (neighbors != thePoint)
        {
            // Update 6/14/09:  Creature must be alive.  After all,
            // there could be a severed head resting on the spawn point,
            // and that does not need to block the spawn point.
            if (neighbors.flags & FLx_CREATURE)
                if (!IsDead (neighbors))
                    return 0;   // player or monster here.  Detects ghosts.
            if (neighbors.solid >= SOLID_BBOX)
                return 0;   // PM:  Something here.  Won't detect ghosts.
            // There was a check for anything with a think here, but
            // Fat Controller removed it, and I would have done the same.
            // As his old comment read:  "After all, items have thinks."
		}
        neighbors = neighbors.chain;
		if (neighbors == start)
			return 1;
	}
	return 1;
};

entity(string text) M_FindDest =
{
    local   entity  furthestDest;
    local   entity  bestDest;
    local   entity  curDest;
    local   entity  thePlayer;
    local   float   theDist;
    local   float   curDist;
    local   float   dot;
    local   vector  curVector;

    furthestDest = bestDest = curDest = world;
    theDist = 0;
    thePlayer = find(world, classname, "player");

    makevectors (thePlayer.angles);

    while (1)
    {
        curDest = find (curDest, classname, text);
        if (curDest == world)
        {
            if (bestDest != world)
                return bestDest;

            return furthestDest;
        }

        if (isSpawnPointEmpty(curDest))
        {
            curVector = curDest.origin - thePlayer.origin;
            curDist = vlen ( curVector );
            curVector = normalize (curVector);
            dot = curVector * v_forward;
            if (dot > 0.6)
                if (curDist > 150)
                    bestDest = curDest;
            
            if (curDist > theDist)
            {
                furthestDest = curDest;
                theDist = curDist;
            } 
        }
    }

    // just in case, return the world.
    return world;
};


//==========================================================================
// CHAPTERS/QUOTH

// Updates aimpoint.
void() ai_shotcheck =
{
    if (visible (self.enemy))
        self.aim_here = self.enemy.origin;
};


//===========================/  END OF FILE  /===========================//

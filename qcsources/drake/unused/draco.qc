//==========================================================================
//  draco.qc -- by Patrick Martin
//--------------------------------------------------------------------------
//  This file contains nearly all the code for Draco, a dragon
//  monster bot with AI more powerful than the generic monster.
//
//  List of things Draco can do other monsters can't:
//  * Has a primitive dynamic waypoint system to track/follow its master.
//  * Seek out and pick up items, then give them to the player.
//
//  NOTE:  Draco was designed as a follower for player characters only.
//  Strange things may happen (such as crashing the game) if Draco is
//  used differently from its intended purpose.
//==========================================================================

// NEW CONSTANTS - - - - - - -
// Standard Quake world vector (x,y,z) limits are from -4192 to +4192.
vector  VEC_VOID    = '8000 8000 8000';

float   COST_PET_TELEPORT   = 10;   // Health cost for teleporting.
float   DRACO_SEARCH        = 3;    // Sec. to add when search_time resets.
float   DRACO_REGEN         = 0.3;  // Heals 200 hp per minute (60/200).

// NEW EDICT FIELDS - - - - -
.entity     draco;        // Pointer from client to Draco or world if none.
.entity     node;         // Temporary goal entity used to follow player.
.float      petofs;       // Ideal height difference between player and Draco.
.float      unload_time;  // Used so player cannot unload Draco every frame.

// PROTOTYPES - - - - - - - -
void(vector spot) Draco_Go;
void(entity pet, string text) Draco_Talk;


////////////////////////////////////////////////////////////////////////////
//  1.  Movement, Collision Detection, and Teleportation
////////////////////////////////////////////////////////////////////////////

//==========================================================================
//  Vertical Adjustment

//------------------------------------------------------------------------//
//  This causes Draco to fly up or down to a set elevation relative
//  to its goal.
//------------------------------------------------------------------------//
float(float offset, float zgoal) Draco_SeekZ =
{
// Quake engine move functions moves up or down by 8 pixels at a time.
// I no longer use setorigin for precise movement (less than 8 pixels)
// because it is too easy for the dragon to clip into other objects,
// and I do not want to rely on bulky anti-clip checks to stop that.
//
// Update:  Precise movement is back.
//
    offset = offset + zgoal - self.origin_z;
    if (offset > 8)     //4
        return  ai_up (8);
    if (offset < -8)    //-4
        return  ai_up (-8);
    if (offset)
        return  ai_up (offset);
    return 0;
};

//------------------------------------------------------------------------//
//  This changes the ideal height difference between Draco and its goal
//  so that the dragon can fly over or under some obstacles.
//  If there is change, TRUE is returned.
//------------------------------------------------------------------------//
float() Draco_ChangeOfs =
{
    local   vector  p1, p2;
    local   float   up, down, dist;

    up = down = FALSE;
    dist = 120 + self.maxs_x;   // Was a flat 150.

    makevectors(self.angles);
    p1   = self.origin;
    p1_z = p1_z + self.mins_z;
    p2   = p1 + v_forward * dist;
    traceline(p1, p2, FALSE, self);
    if (trace_fraction < 1)
        if (trace_ent != self.master)
            up = TRUE;

    p1   = self.origin;
    p1_z = p1_z + self.maxs_z;
    p2   = p1 + v_forward * dist;
    traceline(p1, p2, FALSE, self);
    if ((trace_fraction < 1) && (trace_ent != self.master))
        down = TRUE;
    else
    {   // HACK:  Engine checks move as if maxs_z = 64, if maxs_x > 16.
        p1   = self.origin + '0 0 64';
        p2   = p1 + v_forward * dist;
        traceline(p1, p2, FALSE, self);
        if (trace_fraction < 1)
            if (trace_ent != self.master)
                down = TRUE;
    }

    if (up)
    {
        if (down)
            return FALSE;   // Must be up or down, but not both!

        // Dragon wants to go up.
        self.petofs = self.petofs + 24;
        return TRUE;
    }
    if (down)
    {
        // Dragon wants to go down.
        self.petofs = self.petofs - 24;
        return TRUE;
    }
    return FALSE;
};

//------------------------------------------------------------------------//
//  This checks if an obstacle fully blocks the path from Draco to master.
//
//  Similar to the 'visible' function except this checks three points,
//  giving it wider coverage.  The coverage is needed to help it navigate
//  over or under some obstacles.
//------------------------------------------------------------------------//
float() Draco_InSight =
{
    local   vector  p1, p2;

    // Check path between origins.
    p1 = self.origin;
    p2 = self.master.origin;
    traceline (p1, p2, TRUE, self);
    if (trace_fraction == 1)
        return TRUE;

    // Check path between tops.
    p1_z = p1_z + self.maxs_z;
    p2_z = p2_z + self.master.maxs_z;
    traceline (p1, p2, TRUE, self);
    if (trace_fraction == 1)
        return TRUE;

    // Check path between bottoms.
    p1_z = self.origin_z + self.mins_z;
    p2_z = self.master.origin_z + self.master.mins_z;
    traceline (p1, p2, TRUE, self);
    if (trace_fraction == 1)
        return TRUE;

    // Path is (likely) blocked.
    return FALSE;
};


//==========================================================================
//  Positioning and Teleportation

//------------------------------------------------------------------------//
//  As payment for teleporting, this removes health from Draco.
//------------------------------------------------------------------------//
void(entity pet) Draco_PayTeleportCost =
{
    if (pet.health > COST_PET_TELEPORT)
        pet.health = pet.health - COST_PET_TELEPORT;
    else
        pet.health = 1;     // This should not happen.
};

//------------------------------------------------------------------------//
//  This checks if the dragon has disappeared and is hiding.
//------------------------------------------------------------------------//
float(entity pet) Draco_Gone = {return (!pet.modelindex && !pet.solid);};

//------------------------------------------------------------------------//
//  This idles the dragon at the next frame.
//
//  NOTE:  Do NOT use if Draco is 'hiding'.
//------------------------------------------------------------------------//
void(entity pet) DracoAI_GoIdle =
{
    // Reset idle goal tracking.
    pet.goalentity  = pet.master;
    pet.search_time = time;

    // Go idle.
    pet.enemy = pet.oldenemy = world;
    pet.think = pet.th_walk;
    pet.nextthink = 0.01;
};

//------------------------------------------------------------------------//
//  This checks if the dragon is allowed to reappear.
//------------------------------------------------------------------------//
float() Draco_ReturnNow =
{
    if (cutscene)
        return FALSE;   // Do not appear during a cutscene.
    if (self.master.health <= 0)
        return FALSE;   // Master is dead -- wait until respawn.
    if (self.master.button0)
        if (self.master.war)
            return FALSE;   // Not while master is firing a weapon.
    // NEW!
    if (self.master.h2olevel == 3)
        if (self.master.h2otype < CONTENT_WATER)
            return FALSE;   // Do not appear in slime/lava.

    // May reappear normally.
    return TRUE;
};

//------------------------------------------------------------------------//
//  This checks if the summoned dragon is ready at this time.  If so,
//  zero is returned.  If not, the amount of time needed until the next
//  summoning attempt is returned.
//------------------------------------------------------------------------//
float() Draco_CallTime =
{
    // Check if it should reappear at this time.
    if (Draco_ReturnNow ())
    {
        local   float   standby;

        // Do not appear until ALL bloodcubes owned by master are gone!
        standby = Cube_TimeLeft (self.master);
        if (standby)
            return (standby + 3);

        // Try to reappear normally.
        if (EntryPoint_Spawn (self, self.master, self.master.origin, EntryPoint_Circle))
        {   // The dragon may appear -- activate it.
            Draco_Go (self.origin);
            return 0;
        }
    }
    return 1;
};

//------------------------------------------------------------------------//
//  This tries to activate the pet dragon.
//------------------------------------------------------------------------//
void() Draco_Start =
{
    local   float   standby;

    standby = Draco_CallTime ();    // Draco appears if this is non-zero.
    if (standby)
    {   // Draco failed to appear -- try again later!
        Burn_Null (self);   // If fire wasn't put out by now, do so.
        self.nextthink  = time + standby;
        self.think      = Draco_Start;
        return;
    }
};

//------------------------------------------------------------------------//
//  This makes the pet dragon disappear.  While it is gone, the dragon
//  is invisible and invulnerable.
//------------------------------------------------------------------------//
void(entity pet, float standby) Draco_Disappear =
{
    if (!Draco_Gone (pet))    // If False, just reset the timer.
    {   // Make Draco disappear.
        pet.movetype   = MOVETYPE_NONE;
        pet.velocity   = '0 0 0';
        pet.touch      = SUB_Null;
        pet.takedamage = DAMAGE_NO;
        pet.solid      = SOLID_NOT;

        spawn_tfog (pet.origin);
        pet.modelindex = 0;     // No model.
        setorigin (pet, VEC_ORIGIN);
    }

    if (standby)
    {   // Draco has gone for a while... assume fire was put out in meantime.
        Burn_Null (pet);
        if (standby < 0)
            pet.nextthink = -1;    // Do not reappear.  Back in the pokeball.
        else
            pet.nextthink = time + standby;
    }
    else
        pet.nextthink = 0.01;  // Reappear ASAP.  Basically, a teleport.
    pet.think   = Draco_Start;
};


//==========================================================================
//  Item Pack Transfer.

//  NOTE:  'self' = pet, 'other' = pet.master.

//------------------------------------------------------------------------//
//  This transfers keys from 'self' to 'other'.
//------------------------------------------------------------------------//
void() Draco_GiveKeys =
{
    local   float   k1, k2, i;

    k1 = k2 = i = 0;
    if (self.items & IT_KEY1)
        if (!(other.items & IT_KEY1))
            k1 = 1;
    if (self.items & IT_KEY2)
        if (!(other.items & IT_KEY2))
            k2 = 1;

    if (k1 + k2 == 0)
        return;     // No new keys to give.

// NOTE:  Assumes 'self.keyop*' is a non-world entity.
    sprint (other, "You get the ");
    if (k1)
    {
        other.items = other.items | IT_KEY1;
        self.items = self.items - IT_KEY1;

        if (self.keyop1.classname == "item_key1")
        {
            sound (other, CHAN_ITEM, self.keyop1.noise, 1, ATTN_NORM);
            sprint (other, self.keyop1.netname);
        }
        else
            sprint (other, "silver key");
        self.keyop1 = world;
        i = 1;
    }
    if (k2)
    {
        other.items = other.items | IT_KEY2;
        self.items = self.items - IT_KEY2;

        if (i)
            sprint (other, " and the ");
        if (self.keyop2.classname == "item_key2")
        {
            sound (other, CHAN_ITEM, self.keyop2.noise, 1, ATTN_NORM);
            sprint (other, self.keyop2.netname);
        }
        else
            sprint (other, "gold key");
        self.keyop2 = world;
    }
    sprint (other, "\n");
    stuffcmd (other, "bf\n");
};

//------------------------------------------------------------------------//
//  This transfers the item pack from 'self' to 'other'.
//------------------------------------------------------------------------//
void() Draco_GiveAllItems =
{
    Draco_GiveKeys ();

    local   float   oldw, neww;

    oldw = other.war;
    // True = Give all in one touch; False = Give only what the master needs.
    neww = Pack_TakeItems (!(self.ryuflags & RYU_GREEDY));

    if (neww)
    {   // Got a new weapon.
        local   entity  stemp;

        stemp = self;
        self = other;
        weapon_change (oldw, neww);
        self = stemp;
    }

    Draco_CheckLoad (self);

    // Master unloaded the dragon, so remove the runaway flag.
    self.ryuflags = self.ryuflags - (self.ryuflags & RYU_RUNAWAY);

    // Minimum delay before allowing the next unload.
    // Note:  Draco will avoid its master during the delay so extend the
    // delay if Draco is still holding items after unloading due to greed.
    if ((self.ryuflags & (RYU_LOADED|RYU_STAY|RYU_PATROL)) == RYU_LOADED)
        self.unload_time = time + 2;
    else
        self.unload_time = time + 0.5;
};

//------------------------------------------------------------------------//
//  This lets 'other' try to unload items from 'self'.
//  Draco's touch function.
//------------------------------------------------------------------------//
void() Draco_Touch =
{
    if (other != self.master)
        return;     // Draco gives only to its master.
    if (self.enemy)
        return;     // Too busy to give loot while fighting.
    if (!(self.ryuflags & RYU_LOADED))
        return;     // Nothing to give.
    if (self.unload_time > time)
        return;     // Recently unloaded.  Don't unload every frame.

    // Give loot if dragon is infront of the player.
    makevectors (other.v_angle);    // Assumes other is a player.
    if ((normalize (self.origin - other.origin) * v_forward) > 0.3)
        Draco_GiveAllItems ();
};


//==========================================================================
//  Pet Anti-Clipping

//------------------------------------------------------------------------//
//  Draco loses health if caught inside a wall.  If it has health left,
//  it disappears then teleports to near its master.  TRUE is returned
//  if the dragon got caught in a wall.
//
//  This should only be called during a world or client think phase.
//  In Drake, this function is called by the custom WorldScan.
//------------------------------------------------------------------------//
void(entity e) Draco_InWall =
{
    // Dragon is inside the wall.
    e.health = e.health - COST_PET_TELEPORT;
    if (e.health <= 0)
    {   // Splat on the wall!
//- - - - - - - - -
// DISABLED -- Emulate trigger_void effects.
//        self.modelindex = 0;
//        self.solid = SOLID_NOT;
//        sound (self, CHAN_VOICE, "player/teledth1.wav", 1, ATTN_NORM);
//- - - - - - - - -
        T_Kill (e, world, world, -999, "noclip");
        return;
    }
    // Draco lives!
    Draco_Talk (e, "OUCH!");
    Draco_Disappear (e, 3);     // Used to be 5 seconds.
};


////////////////////////////////////////////////////////////////////////////
//  2.  Navigation and Waypoint Spawning
////////////////////////////////////////////////////////////////////////////

//  NOTE:  This is used only to follow a master when it is not fighting.

//  NOTE(2):  Dragon should not try to follow while a cutscene is active.

//==========================================================================
//  Move-to-Goal

//------------------------------------------------------------------------//
//  Lets Draco teleport to master automatically.
//
//  Draco will auto-teleport to master if:
//  * Draco spent at least 10 seconds wandering.
//  * Draco has full or at least 100 health.
//  * Draco's master is not holding down the fire button.
//
//  Compared to older versions of Dragons, the requirements are relaxed
//  now because Draco is bigger and has more health than before.
//  Also, the code has been cleaned up (a bit) since, and Draco is now
//  guaranteed to teleport eventually if it cannot see its master.
//------------------------------------------------------------------------//
float() Draco_AutoTeleport =
{
    if (!self.master.button0)
      if (self.search_time + 10 < time)
        if ((self.health >= self.max_health) || (self.health >= 100))
        {
            Draco_Disappear (self, 0);
            Draco_PayTeleportCost (self);   // Teleporting drains health.
            return TRUE;
        }

    return FALSE;
};

//------------------------------------------------------------------------//
//  This resets the ideal height difference.
//------------------------------------------------------------------------//
void() DracoAI_ResetPetOfs =
{
    if (self.goalentity == self.master)
        self.petofs = 32;   // Was 35 (31 - 39)
    else
        self.petofs = 16;   // Was 19 (15 - 23)
};

//------------------------------------------------------------------------//
//  This calculates how fast the dragon should approach the goal.
//  Speed can range anywhere from walking speed to full running speed.
//  Unless it is close, the dragon should approach the goal at full speed.
//  When it is close to the goal, the dragon slows down to prevent the
//  chance that the dragon may perpetually orbit the goal.
//
//  NOTE:  The formula this function uses assumes a yaw speed of 20.
//------------------------------------------------------------------------//
float(float dist) DracoAI_GoalSpeed =
{
    local   float   shift;

    shift = floor(dist * 0.25);
    if (shift > self.speed)
        shift = self.speed;
    else if (shift < SPEED_RYU_MIN)
        shift = SPEED_RYU_MIN;

    return shift;
};


//==========================================================================
//  Triangle Waypoint Generation

//------------------------------------------------------------------------//
//  This tries to create a waypoint by tracing a vector from the
//  dragon to where it is facing, and from that point to where
//  its master is.
//------------------------------------------------------------------------//
void() Draco_ReverseTriangulate =
{
    if (self.pos2 != VEC_VOID)
        return;     // Already have a waypoint.

    local   vector  p1, p2;

    // Trace from dragon to where it is heading...
    p1 = self.origin + self.view_ofs;
    makevectors(self.angles);
    p2 = p1 + v_forward*4096;
    traceline (p1, p2, TRUE, self);

    // ...then trace from its master to that point.
    p2 = trace_endpos - v_forward*16;
    p1 = self.master.origin + self.master.view_ofs;
    traceline (p1, p2, TRUE, self.master);

    if (trace_fraction < 1)
        return;

    // We have a connection, and a new waypoint.
    self.search_time = time + 1;
    self.pos2 = p2;
};

//------------------------------------------------------------------------//
//  This tries to create a waypoint by tracing a vector from the
//  player to where he is aiming, and from that point to where
//  the dragon is.
//------------------------------------------------------------------------//
void() Draco_Triangulate =
{
    if (self.pos2 != VEC_VOID)
        return;     // Already have a waypoint.

    local   vector  p1, p2;

    // Trace from master to where he is looking at...
    p1 = self.master.origin + self.master.view_ofs;
    makevectors(self.master.v_angle);
    p2 = p1 + v_forward*4096;
    traceline (p1, p2, TRUE, self.master);

    // ...then trace from dragon to that point.
    p2 = trace_endpos - v_forward*16;
    p1 = self.origin + self.view_ofs;
    traceline (p1, p2, TRUE, self);

    if (trace_fraction < 1)
        {Draco_ReverseTriangulate (); return;}

    // We have a connection, and a new waypoint.
    self.search_time = time + 1;
    self.pos2 = p2;
};


//==========================================================================
//  Node Spawning

//  NOTE:  Something to do in the future... maybe.
//  Define new global 'temp_node' as goal, and store points in Draco.
//  Do this so that code does not create and remove entities all the time.

//------------------------------------------------------------------------//
//  This removes the dragon's node (waypoint) entity if it exists.
//------------------------------------------------------------------------//
void(entity ent) DracoNode_Remove =
{
    if (ent.node)
    {
        remove (ent.node);
        ent.node = world;
        ent.pos1 = ent.pos2 = VEC_VOID;
    }
};

//------------------------------------------------------------------------//
//  This creates the goal where the dragon will fly to.
//------------------------------------------------------------------------//
void(vector spot) DracoNode_Spawn =
{
    self.node = spawn();
    setmodel (self.node, "");
    setsize (self.node, '0 0 0', '0 0 0');
    setorigin (self.node, spot);
    self.node.solid      = SOLID_NOT;
    self.node.movetype   = MOVETYPE_NONE;
    self.node.takedamage = DAMAGE_NO;
    self.node.touch      = SUB_Null;
    self.node.classname  = "node";
    self.node.owner      = self;
    self.node.health     = 50000;

    // Initialize waypoints.
    self.node.dest       = VEC_VOID;
    self.node.dest1      = VEC_VOID;
    self.node.dest2      = VEC_VOID;
    self.node.pos1       = VEC_VOID;
    self.node.pos2       = VEC_VOID;
};


//==========================================================================
//  Node Finding

//------------------------------------------------------------------------//
//  This returns the location of the last waypoint on the path.
//------------------------------------------------------------------------//
vector(entity plist) DracoNode_LastWaypoint =
{
    if (plist.pos2 != VEC_VOID)
        return plist.pos2;
    if (plist.pos1 != VEC_VOID)
        return plist.pos1;
    if (plist.dest2 != VEC_VOID)
        return plist.dest2;
    if (plist.dest1 != VEC_VOID)
        return plist.dest1;
    if (plist.dest != VEC_VOID)
        return plist.dest;

    return plist.origin;
};

//------------------------------------------------------------------------//
//  Normally, this places the node to a new waypoint if one exists.
//  If no new point exists, remove the node.
//
//  If backtracking, this places the node to one of the dragon's earlier
//  points on the path.  Used when dragon strays from the path due to
//  fighting, feeding, or looking for water.
//------------------------------------------------------------------------//
void(entity ent, float backtrack) DracoNode_Update =
{
    if (backtrack)
    {   // Create a point to help dragon get back on the path.
        ent.node.pos2  = ent.node.pos1;
        ent.node.pos1  = ent.node.dest2;
        ent.node.dest2 = ent.node.dest1;
        ent.node.dest1 = ent.node.dest;
        ent.node.dest  = ent.node.origin;

        setorigin (ent.node, ent.pos1);
        ent.pos1 = VEC_VOID;

        return;
    }

    if (ent.node.dest != VEC_VOID)
    {   // Go to next point in trail.  Update list of waypoints.
        setorigin (ent.node, ent.node.dest);
        ent.node.dest  = ent.node.dest1;
        ent.node.dest1 = ent.node.dest2;
        ent.node.dest2 = ent.node.pos1;
        ent.node.pos1  = ent.node.pos2;
        ent.node.pos2  = VEC_VOID;
        return;
    }

    if (ent.pos2 != VEC_VOID)
    {
        // Go to the last known point where the master was.
        setorigin (ent.node, ent.pos2);
        ent.pos2 = VEC_VOID;
        return;
    }

    // Trail has ended.  Remove the node.
    DracoNode_Remove (ent);
};

//------------------------------------------------------------------------//
//  Called when dragon uses a teleporter.
//------------------------------------------------------------------------//
void(entity ent) Draco_UseTeleport =
{
    // If going to the node, assume dragon is flying on the path.
    // Advance the list of waypoints so the dragon can find it master.
    if (ent.node)
        if (ent.goalentity == ent.node)
            DracoNode_Update (ent, FALSE);
};

//------------------------------------------------------------------------//
//  This checks if the dragon's master used a teleporter.  If so,
//  the dragon will look for the same teleporter.
//------------------------------------------------------------------------//
void() Draco_HitTeleport =
{
    if (self.master.teleport_time > time)
    {
        if (self.master.lastwarp)
        {
            local   vector  org;
            local   entity  warp;

            // Get the teleporter the player used last.
            warp = self.master.lastwarp;

            // Aim for the center of the teleporter.
            org = warp.origin + (warp.mins + warp.maxs)*0.5;

            // Make sure the teleporter is accessible.
            traceline (self.pos2, org, TRUE, self);
            if (trace_fraction < 1)
                return;

            if (self.node)
            {
                local   vector  spot;

                spot = DracoNode_LastWaypoint (self.node);
                traceline (spot, self.pos2, TRUE, self);
                if (trace_fraction < 1)
                    return;
            }

            // Reachable -- move waypoint inside the teleporter.
            self.pos2 = org;
        }
    }
};

//------------------------------------------------------------------------//
//  This tries to connect a path from the dragon to its master.
//------------------------------------------------------------------------//
float() DracoNode_BuildPath =
{
// First point.
    traceline (self.node.origin, self.master.origin, TRUE, self);
    if (trace_fraction == 1)
    {   // Path connected.  Remove extra waypoints.
        self.node.dest = self.node.dest1 = self.node.dest2 = VEC_VOID;
        self.node.pos1 = self.node.pos2 = VEC_VOID;
        return TRUE;
    }
    if (self.node.dest == VEC_VOID)
    {   // Add waypoint to the list.
        Draco_HitTeleport ();
        self.node.dest = self.pos2;
        return TRUE;
    }

// Second point.
    traceline (self.node.dest, self.master.origin, TRUE, self);
    if (trace_fraction == 1)
    {
        self.node.dest1 = self.node.dest2 = VEC_VOID;
        self.node.pos1 = self.node.pos2 = VEC_VOID;
        return TRUE;
    }
    if (self.node.dest1 == VEC_VOID)
    {
        Draco_HitTeleport ();
        self.node.dest1 = self.pos2;
        return TRUE;
    }

// Third point.
    traceline (self.node.dest1, self.master.origin, TRUE, self);
    if (trace_fraction == 1)
    {
        self.node.dest2 = self.node.pos1 = self.node.pos2 = VEC_VOID;
        return TRUE;
    }
    if (self.node.dest2 == VEC_VOID)
    {
        Draco_HitTeleport ();
        self.node.dest2 = self.pos2;
        return TRUE;
    }

// Fourth point.
    traceline (self.node.dest2, self.master.origin, TRUE, self);
    if (trace_fraction == 1)
    {
        self.node.pos1 = self.node.pos2 = VEC_VOID;
        return TRUE;
    }
    if (self.node.pos1 == VEC_VOID)
    {
        Draco_HitTeleport ();
        self.node.pos1 = self.pos2;
        return TRUE;
    }

// Fifth point.
    traceline (self.node.pos1, self.master.origin, TRUE, self);
    if (trace_fraction == 1)
    {
        self.node.pos2 = VEC_VOID;
        return TRUE;
    }
    if (self.node.pos2 == VEC_VOID)
    {
        Draco_HitTeleport ();
        self.node.pos2 = self.pos2;
        return TRUE;
    }

// Final point.
    traceline (self.node.pos2, self.master.origin, TRUE, self);
    if (trace_fraction == 1)
        return TRUE;

// List of waypoints full.  Cannot keep track of master any longer.
    return FALSE;
};

//------------------------------------------------------------------------//
//  This tries to link the node and its list of points to the dragon's
//  master.
//------------------------------------------------------------------------//
void() DracoNode_TrailLink =
{
    // If path is intact, update next waypoint.
    if (self.node)
        if (DracoNode_BuildPath ())
            self.pos2 = self.master.origin;
};

//------------------------------------------------------------------------//
//  This checks if the way to the dragon's node is blocked.
//  That is, out of sight.
//
//  Like 'Draco_InSight', except it checks from the point 'org' to the
//  node entity.
//------------------------------------------------------------------------//
float(vector org) DracoNode_InSight =
{
    local   vector  p1, p2;

// Check origins.
    p1 = org;
    p2 = self.node.origin;
    traceline (p1, p2, TRUE, self);
    if (trace_fraction == 1)
        return TRUE;

// Check tops.
    p1_z = p1_z + self.maxs_z;
    p2_z = p2_z + self.node.maxs_z;
    traceline (p1, p2, TRUE, self);
    if (trace_fraction == 1)
        return TRUE;

// Check bottoms.
    p1 = org;
    p2 = self.node.origin;
    p1_z = p1_z + self.mins_z;
    p2_z = p2_z + self.node.mins_z;
    traceline (p1, p2, TRUE, self);
    if (trace_fraction == 1)
        return TRUE;

// Path is blocked!
    return FALSE;
};

//------------------------------------------------------------------------//
//  Part II -- Common movement function used in multiple places by part I.
//------------------------------------------------------------------------//
void(vector dir, float shift)  Draco_GotoNode_II =
{
// Turn toward the node.
    if (self.search_time >= time)
    {
        self.ideal_yaw = vectoyaw(dir);
        ChangeYaw ();
    }
// Fly toward it.
    if (safe_move (self.angles_y, shift))
        DracoAI_ResetPetOfs ();
    else
    {   // Direct move didn't work so bump around.
        safe_goal (shift);
        Draco_ChangeOfs ();
        if (self.search_time > time)
            self.search_time = time;    // Not zero because of auto-teleport.
    }
    Draco_SeekZ (self.petofs, self.node.origin_z);
};

//------------------------------------------------------------------------//
//  This tells Draco to go to a node.  Part I
//------------------------------------------------------------------------//
void() Draco_GotoNode =
{
// Check how fast dragon should fly to waypoint.
    local   float   delta;
    local   float   shift;
    local   vector  vec;

    self.goalentity = self.node;
    vec = self.node.origin - self.origin;
    delta = vlen(vec);
    shift = DracoAI_GoalSpeed (delta);
    if (QC_CloseEnough (shift))
    {   // Dragon made it to a waypoint.  Update trail.
        Draco_GotoNode_II (vec, shift);
        DracoNode_Update (self, FALSE);
        self.search_time = time + DRACO_SEARCH;
    }
//- - Check if the waypoint is accessible. - -
    else if (DracoNode_InSight (self.origin))
    {   // Dragon can see the node.
        local   vector  spot;

        spot = self.origin;
        Draco_GotoNode_II (vec, shift);
        if (spot == self.origin)
        {   // Didn't move.
            if ((self.search_time + 3) < time)
            {   // Stuck -- abandon waypoint.
                self.pos1 = self.pos2 = VEC_VOID;
                DracoNode_Remove (self);
                DracoAI_ResetPetOfs ();
            }
        }
        else
            self.pos1 = self.origin;    // Remember its current position.
    }
    else
    {   // Can't see node?
        if (self.pos1 != VEC_VOID)
        {   // Check if it can backtrack.
            if (DracoNode_InSight (self.pos1))
                DracoNode_Update (self, TRUE);     // Backtrack is a success.
            else
                self.pos1 = VEC_VOID;         // Can't backtrack.
        }
        // Wander toward the node's general direction.
        if (self.node)
        {
            safe_goal (shift);
            Draco_SeekZ (self.petofs, self.node.origin_z);
        }
    }
//- - - - - - - - - - - - - - - - - - - - - -
// Update nodes.
    if (self.node)
        DracoNode_TrailLink ();
};


//==========================================================================
//  Trailing

//------------------------------------------------------------------------//
//  This lets a pet dragon that is NOT following its master to
//  construct a trail that will hopefully lead to its master.
//------------------------------------------------------------------------//
void() Draco_TrackMaster =
{
    // Check if dragon can see its master.
    if (Draco_InSight ())
    {   // Master is visible.  Remove trail and remember current location of
        // itself and its master.
        DracoNode_Remove (self);
        self.pos1 = self.origin;
        self.pos2 = self.master.origin;
    }
    else
    {   // Can't see master, construct a trail.
        if (self.node)
        {   // Check for backtrack.
            if (DracoNode_InSight (self.origin))
                self.pos1 = self.origin;
            else if (self.pos1 != VEC_VOID)
            {
                if (DracoNode_InSight (self.pos1))
                    DracoNode_Update (self, TRUE);
                self.pos1 = VEC_VOID;
            }
            // Check node trail.
            DracoNode_TrailLink ();
        }
        else
        {   // No trail.  Find a waypoint.
            Draco_Triangulate ();
            if (self.pos2 != VEC_VOID)
            {   // Found a point.
                Draco_HitTeleport ();
                DracoNode_Spawn (self.pos2);
                self.pos2 = VEC_VOID;
            }
        }
    }
};

//------------------------------------------------------------------------//
//  Draco follows its master to the best of its ability.
//
//  Draco will either follow the master directly or along a
//  pre-constructed path.
//------------------------------------------------------------------------//
void() Draco_Follow =
{
    local   float   dist;
    local   vector  vec;
    local   float   delta2;
    local   float   seen;

    dist = self.speed;
    self.goalentity = self.master;
    seen = Draco_InSight ();
    vec = self.master.origin - self.origin;
    delta2 = vlen(vec);
// Since Draco uses SeekZ for vertical movement, don't temp set .enemy.
    if (seen)
    {
        local   float   shift;
        local   float   run;

        self.goalentity = self.master;
        shift = self.maxs_x * 1.25 + 80;
        run = 0;
        if ((self.ryuflags & RYU_LOADED) && (self.unload_time <= time))
            shift = shift - 20;
        else
    // If running away, remove the flag only if dragon carries no items.
    // Otherwise, give master the chance to unload the dragon first.
        {   self.ryuflags = self.ryuflags - (self.ryuflags & RYU_RUNAWAY);
            if (delta2 < shift)
                run = 1;
            else
                shift = shift + 20;
        }

        if (run)
        {   // Too close to master, go away now.
            if (self.ryuflags & RYU_SLOW)
            {   // Start slow this frame.
                self.ryuflags = self.ryuflags - RYU_SLOW;
                dist = SPEED_RYU_MIN;
            }
            vec = vec * -1;
            self.ideal_yaw = vectoyaw(vec);
            ChangeYaw ();
            if (safe_move (self.angles_y, dist))
                self.search_time = time + DRACO_SEARCH;
            else
            {   // Can't go forward so try a sidestep.
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
        {   // Approach master.
            if (self.search_time >= time)
            {
                self.ideal_yaw = vectoyaw(vec);
                ChangeYaw ();
            }
            if (delta2 > shift)
            {
                if (delta2 <= shift + self.speed)
                    dist = SPEED_RYU_MIN;   // Close, so slow down.

                // The search is set so that if master disappears from
                // view (such as from teleporting), let monster go straight
                // ahead in hopes of finding master.
                if (safe_move (self.angles_y, dist))
                {
                    self.search_time = time + DRACO_SEARCH;
                    DracoAI_ResetPetOfs ();     // FIXME:  Is this right???
                }
                else
                {   // Blocked, move around.
                    safe_goal (dist);
                    self.search_time = time;    // Not zero because of tele.
                    Draco_ChangeOfs ();
                }
            }
            else
            {   // Close enough to master, so stay right there.
                self.ryuflags = self.ryuflags | RYU_SLOW;
                self.search_time = time + DRACO_SEARCH;
                DracoAI_ResetPetOfs ();
            }
        }
        // Move toward Z.
        Draco_SeekZ (self.petofs, self.master.origin_z);

    // Direct line from dragon to master is intact.  Remove nodes, and
    // remember where the master is now in case he disappears later.
        DracoNode_Remove (self);
        self.pos1 = self.origin;
        self.pos2 = self.master.origin;
    }
//- - Separated from master. - -
    else if (Draco_AutoTeleport ())
        return;
    else if (self.node)     // If node exists, that means Draco is
        Draco_GotoNode ();  // following a trail.
    else
    {   // Draco has no trail.  Try to find a path.
        // Do not use triangulation here to generate a point to go to
        // because Draco may get stuck there in a loop.
        if (self.pos2 != VEC_VOID)
        {   // Go to the point where master was last seen.
            Draco_HitTeleport ();
            DracoNode_Spawn (self.pos2);
            self.pos2 = VEC_VOID;
            Draco_GotoNode ();
        }
        else
        {   // Path from pet to master is lost.  If dragon has extra search
            // time, fly straight ahead in hopes the goal may be found soon.
            // Otherwise, use movetogoal-style AI to follow walls and wander.
            if (self.search_time < time)
            {
                safe_goal (self.speed);
                Draco_SeekZ (self.petofs, self.master.origin_z);
            }
            else if (!safe_move (self.angles_y, self.speed))
                self.search_time = time;    // Blocked -- remove excess time.
        }
    }
//- - - - - - - - - - - - - - -
};


//==========================================================================
//  Item Finding

//------------------------------------------------------------------------//
//  This checks if Draco is hungry.
//------------------------------------------------------------------------//
float() Draco_Hungry =
{
    if (self.health < self.max_health)
        return TRUE;    // Always eat if wounded.
    if (self.armorvalue < DRACO_ARMORVALUE)
        return TRUE;    // Eating is the only way to repair armor.

    return FALSE;   // Has full life and armor, so no need to eat.
};

//------------------------------------------------------------------------//
//  This tells the dragon to seek out the item.
//------------------------------------------------------------------------//
void(entity item) Draco_GotoItem =
{
    local   float   dist, shift, up;
    local   vector  spot, vec;

    if ((item.loottype == LOOT_FOOD) || (item.loottype == LOOT_MONEY))
        spot = item.origin;     // Aim low for food and coins.
    else
        spot = item.origin + ((item.mins + item.maxs) * 0.5);
    vec = spot - self.origin;
    dist = vlen(vec);
    // Determine how fast the dragon should approach the item.
    shift = DracoAI_GoalSpeed (dist);
    up = fabs(spot_z - self.origin_z);

// Go for it.
    self.goalentity = item;
    if (self.search_time >= time)
    {
        self.ideal_yaw = vectoyaw(vec);
        ChangeYaw ();
    }
    if (safe_move (self.angles_y, shift))
    {
        self.search_time = time + 1;  // Use 1 sec. due of item check below.
        DracoAI_ResetPetOfs ();
    }
    else
    {   // Blocked, move around.
        safe_goal (shift);
        self.search_time = time;    // Not zero because of auto-teleport.
        Draco_ChangeOfs ();
    }
    Draco_SeekZ (self.petofs, spot_z);
//----------//
// Ewwww... is there a better way to do this?
//
// Compare both altitude and overall distance of pre-move and post-move.
// If Draco fails to decrease the distance in both checks, increase the
// greed frame counter by one.  If the frame counter reaches a predefined
// number, Draco abandons the item.
//
// Yes, I know this method is flawed for multiplayer, but I consider that
// a minor problem in the grand scheme of things.
//
    if (up <= fabs(spot_z - self.origin_z))     // Altitude only.
        if (dist <= vlen(spot - self.origin))       // Overall distance.
            if (item)
                if (item.greedtime < time)
                {
                    item.greed = item.greed + 1;
                    item.greedtime = time + 0.1;
//                    dprint("greed: ");dprint(ftos(item.greed));dprint("\n");
                }
//----------//
};

//------------------------------------------------------------------------//
//  This checks if the entity found is an item that a dragon can reach
//  and grab without trouble.
//------------------------------------------------------------------------//
float(entity item, float dist, float eat, float reach) Draco_AcceptItem =
{
    if (!item.loottype)     // || !(item.flags & FL_ITEM))
        return FALSE;

//-----/ C-style switch... /-----//
    if (item.loottype == LOOT_FOOD)
    {
        if (!eat)
            return FALSE;   // Not hungry.
    }
    else if (item.loottype == LOOT_PACK)
    {
        // Backpacks may hold weapons, so don't waste them if Draco already
        // holds a weapon.  Does not apply in deathmatch.
        if (!deathmatch)
            if (self.arsenal || self.war)
                return FALSE;   // Already holding weapon.

        // NOTE:  If you want Draco to always chase backpacks, remove the
        // above check and replace with SUB_Null ().  Why?  QC must do
        // something in an if-bracket, even a call to a function that
        // does nothing, so compiler won't complain.
    }
    else if (item.loottype == LOOT_MONEY)
    {   // Dragons have an insatisable lust for treasure.  Always take money.
        SUB_Null ();
    }
    else if (item.loottype == LOOT_POWER)
    {
        if (!(self.ryuflags & RYU_GREEDY))
            if (!deathmatch)
                return FALSE;
    }
    else if (item.loottype == LOOT_WEAPON)
    {
        if (!(self.ryuflags & RYU_GREEDY))
            return FALSE;

        // Note:  Draco can only carry one weapon at a time.
        if (self.arsenal || self.war)
            return FALSE;   // Already holding weapon.
        if (item.lefty)   // NOTE:  Does it match with leave code in ammo.qc?
            if (self.master)
                if (self.master.arsenal & item.war)
                    return FALSE;   // Player would 'leave' this weapon.
    }
    else if (item.loottype == LOOT_ARMOR)
    {
        if (!(self.ryuflags & RYU_GREEDY))
            return FALSE;
        if (self.armor_stats_y)
            return FALSE;   // Already carrying armor.
    }
    else if (item.loottype == LOOT_HEALTH)
    {
        if (!(self.ryuflags & RYU_GREEDY))
        {
            // Pickup only necessary health.  (Disabled at the moment.)
//            if (self.master)
//                if (self.master.health + self.healamount + item.healamount > self.master.max_health)
                    return FALSE;
        }
        if (self.healamount >= MAX_EXTRA_LIFE)
            return FALSE;   // Already carrying max health.
    }
    else if (item.loottype == LOOT_AMMO)
    {
        if (!(self.ryuflags & RYU_GREEDY))
            return FALSE;

        local   float   am1, am2, am3, am4;

        am1 = am2 = am3 = am4 = 0;
        if (item.ammo_shells)
            if (self.ammo_shells < AMAX_SHELLS)
                am1 = 1;
        if (item.ammo_nails)
            if (self.ammo_nails < AMAX_NAILS)
                am2 = 1;
        if (item.ammo_rockets)
            if (self.ammo_rockets < AMAX_ROCKETS)
                am3 = 1;
        if (item.ammo_cells)
            if (self.ammo_cells < AMAX_CELLS)
                am4 = 1;
        if (am1 + am2 + am3 + am4 == 0)
            return FALSE;   // No ammo to pick up.
    }
    else if (item.loottype == LOOT_KEY)
    {
        if (!(self.ryuflags & RYU_GREEDY))
            return FALSE;
        if (item.items & self.items)
            return FALSE;   // Already carrying the same type of key.
        if (self.master)
            if (item.items & self.master.items)
                return FALSE;   // Master already has this key.
    }
    else //if (item.loottype == LOOT_MISC)
    {
        if (!(self.ryuflags & RYU_GREEDY))
            return FALSE;
    }
//-------------------------------//

    if (dist <= reach)
        return TRUE;    // Close enough to take the item.

    if (self.ryuflags & RYU_RUNAWAY)
    {   // In runaway mode.  Ignore all items except food.
        if (item.loottype != LOOT_FOOD)
            return FALSE;
    }

    if (item.greed >= 25)   // 2.5 seconds * 10 fps = 25 frames.
        return FALSE;   // Don't spend too much time trying to get one item.

    // Go for it.
    return TRUE;
};

//------------------------------------------------------------------------//
//  This checks if the item is in a safe environment.  That is, fetch
//  items that are not submerged in slime or lava.
//
//  Water is considered safe as long as the dragon is not afraid of water,
//  and has at least five seconds of air left.
//------------------------------------------------------------------------//
float(vector spot) Draco_SafeItem =
{
    local   float   pc;

    pc = pointcontents(spot);
    if (pc == CONTENT_EMPTY)
        return TRUE;
    // Half air time is the point of no return, and half of 12 is 6.
    if (pc == CONTENT_WATER)
        if (!(self.ryuflags & RYU_NO_WATER))    // Must be able to enter H2O.
        {
            if (self.xfl & XFL_NO_AIR)
                return TRUE;    // SoE:  Can't drown.
            return (self.air_finished > (time + 6));
        }
    return FALSE;   // Everything else is deadly or solid.
};

//------------------------------------------------------------------------//
//  This compares two items and tells which item the dragon should target.
//  Old item uses 'item1/dist1' and new item uses 'item2/dist2'.  Return
//  TRUE if item2 should be targeted.  Return FALSE if item1 is kept.
//------------------------------------------------------------------------//
float(entity item1, float dist1, entity item2, float dist2, float reach)
    Draco_TargetNewItem =
{
    if (!item1)
        return TRUE;    // First item found.
    if (item2.loottype < item1.loottype)
    {
        // New item has higher priority, but take only if one of the
        // following conditions is met.
        // Note:  Old item should use old reach instead of new, but in
        //  the interest of convenience...
        if (dist1 > reach)
            return TRUE;    // Old item is beyond pickup range.
        if (dist2 <= reach)
            return TRUE;    // New item is within pickup range.
    }
    if (dist1 > dist2)
        return TRUE;    // New item is nearer.

    return FALSE;   // Old item is more important, so ignore new item.
};


////////////////////////////////////////////////////////////////////////////
//  3.  Behavior and Combat AI
////////////////////////////////////////////////////////////////////////////

//-----------------//
//  NEW CONSTANTS  //
//-----------------//

//
//  Draco sight radius.  Anything within this distance is seen.
//
//  In versions of Dragons prior to 5.0, a sight radius of 600 was
//  used primarily for performance (read:  slowdown avoidance).
//  That made the dragon somewhat near-sighted.
//
//  Now the sight radius is 1000, which is comparable to the standard.
//  NOTE:  Drake standard is 2000, which is too much for findradius.
//
//  Update (2007):  With the speed of modern computers, findradius
//  could be set to 8000 and the player may not even notice.  I am
//  still leaving this to a more standard value.
//
float   SIGHT_RADIUS    = 1000;

//==========================================================================
//  Friendly Fire Checks

//------------------------------------------------------------------------//
//  This checks if a good guy is in the way of the dragon's shot.
//------------------------------------------------------------------------//
float() Draco_FriendlyFire =
{
    if (self.xfl & XFL_DRACO)
    {   // Only Draco bothers checking for friendly fire.
        local   float   dist, dot;
        local   entity  head;
        local   vector  v1, v2;
        local   entity  attacker, victim;

        attacker = self;
        victim = self.enemy;

        v1 = normalize (victim.origin - attacker.origin);
        head = findradius (victim.origin, 2048);
        while (head)
        {   // Do not fire if allies are within dragon's FOV.
            if (head != attacker)
                if (head != victim)
                    if (Ally_Check (head, attacker))
            {
                v2 = normalize (head.origin - attacker.origin);
                dot = v1 * v2;
                dist = vlen(head.origin - victim.origin);
                if ((dot > 0.9848) || (dist < 120))
                {   // Abort if within aim field of 10 degrees or too close,
                    // provided that the attacker could hit the ally.
                    traceline (attacker.origin, head.origin, TRUE, attacker);
                    if (trace_fraction == 1)
                        return TRUE;    // Ally in spray area -- abort!
                }
            }
            head = head.chain;
        }
    }
    return FALSE;   // All clear -- we hope...
};


//==========================================================================
//  Target Detection

//------------------------------------------------------------------------//
//  This checks if the target can be ignored, so dragon can attack
//  other more important targets.
//------------------------------------------------------------------------//
float(entity ent) PM_IgnorableTarget =
{
// Ignore targets that are impossible to damage, if there is something else.
    if (ent.solid <= SOLID_TRIGGER)
    {
        if (range (ent) != RANGE_MELEE)
        {
            if (self.ryuflags & RYU_ELEMENTS != RYU_USE_LITE)
                return TRUE;    // Can't hit non-solid targets past melee range.
            if (!IsGhost (ent))
                return TRUE;    // Even lightning won't work on these.
            // Damage check done below, so no need to check here.
        }
    }
    if (ImmuneToDamage (ent))
        return TRUE;    // Invulernable.  Includes mega enforcer shields.

// Some enemies are too dangerous to ignore, so kill them immediately.
    if (ent.items & IT_QUAD)
        return FALSE;   // Enemies with the quad are truly dangerous.
    if (ent.threats & THREATx_DRACO)
        return FALSE;   // Marked as highly dangerous.

// Ignore targets who fight the enemy.  "The enemy of my enemy is my friend."
    if (ent.enemy)
    {   if (!Ally_Check (ent.enemy, self))
            return TRUE;    // Let the target fight another enemy for you.
    }

// No good reason to ignore, so keep fighting.
    return FALSE;
};

//------------------------------------------------------------------------//
//  This checks if the dragon should attack a target it found.
//  This is done so the dragon doesn't fly off and wake up something
//  that can kill it.  (i.e., biting off more than it can chew.)
//
//  Update:  Evil monsters attack Draco on sight, so discretion is best.
//------------------------------------------------------------------------//
float(entity ent) Draco_AcceptTarget =
{
    if (deathmatch)
        return TRUE;    // Attack any enemy on sight in deathmatch.

// Attack if immortal.  (Disabled because godmode is cheat-only.)
// 666 is not true immortality because it might end before the fight is over.
//    if (self.flags & FL_GODMODE)
//        return TRUE;    // Indefinite immortality.

    // Attack only if target is threating a good guy.
    if (ent.enemy)
    {
        if (ent.enemy == self)
        {   // The dragon itself is the target.
            if (self.ryuflags & (RYU_STAY | RYU_PATROL))
                return TRUE;    // Cannot run away so fight back.
            if (visible2 (ent, self.master))
                return TRUE;    // Fight if dragon and master see the target.

            // Unless the above conditions are met, don't fight back unless
            // hurt by an enemy.  If hurt by the enemy, the dragon will turn
            // to fight it.  The functions in 'combat.qc' will see to that.

            // Add runaway flag to suppress greedy itemfinding behavior.
            // A psuedo-boolean function is not the best place to put this,
            // but it works and is convenient.
            if (!(self.ryuflags & RYU_RUNAWAY))
                self.ryuflags = self.ryuflags | RYU_RUNAWAY;
        }
        else if (Ally_Check (ent.enemy, self))
        {   // If target is a good guy, help him if he is in trouble.
            if (visible (ent.enemy))
                return TRUE;    // Seen by dragon; dragon seen by enemy.
            if (visible2 (ent.enemy, ent))
                return TRUE;    // Seen by enemy.
        }
        // At this point, the target will not be attacked.
    }
    // Leave the target alone.
    return FALSE;
};

//------------------------------------------------------------------------//
//  This checks if the dragon should attack the target.  If so, return
//  TRUE.  Otherwise, return FALSE.
//
//  NOTE:  This assumes the dragon is loyal to its master.
//  Update:  Draco should *always* be loyal -- see ryu.qc.
//------------------------------------------------------------------------//
float(entity ent) Draco_ValidTarget =
{
    // Pet dragon can attack only living creatures.
    if (ent.flags & FLx_CREATURE)   //(FL_CLIENT | FL_MONSTER)
    {
        if (ent.health <= 0)
            return FALSE;
        if (Ally_Check (ent, self)) // No 'Align_Match' in case of infighting.
            return FALSE;   // Don't attack allies.  Should include self too.
        if (ImmuneToDamage (ent))   // For Zer's me when shields are on.
            return FALSE;   // Ignore unstoppable targets.

        if (SeeTarget (ent))    // Do this first!
        {
            if (ent.classname == "player")
                return TRUE;    // May always attack enemy players.
            if (Draco_AcceptTarget (ent))
                return TRUE;    // Monster can be attacked.
        }
    }

    return FALSE;   // Not a target.
};

//------------------------------------------------------------------------//
//  This checks if the dragon is allowed to fight bad guys.
//------------------------------------------------------------------------//
float(entity pet) Draco_IsAllowedToFight =
{
    if (cutscene)
        return FALSE;   // Don't initiate combat during a cutscene.
    if (pet.ryuflags & (RYU_CALM | RYU_FORCED))
        return FALSE;   // Don't attack if pacifist or shooting.

    // Look for bad guys.
    return TRUE;
};

//------------------------------------------------------------------------//
//  This searches for targets surrounding the dragon.
//------------------------------------------------------------------------//
entity(entity ignore, float all) Draco_FindNewTarget_II =
{
    local   entity  head;

    head = findradius(self.origin, SIGHT_RADIUS);
    if (all)
    {   // Look for all possible targets.
        while (head)
        {
            if (head != ignore)
            {
                traceline (self.origin, head.origin, TRUE, self);
                if (trace_fraction == 1)
                    if (Draco_ValidTarget (head))
                        return head;    // Got one!
            }
            head = head.chain;
        }
    }
    else
    {   // Look for important targets only.
        while (head)
        {
            if (head != ignore)
                if (!PM_IgnorableTarget (head))
                {
                    traceline (self.origin, head.origin, TRUE, self);
                    if (trace_fraction == 1)
                        if (Draco_ValidTarget (head))
                            return head;    // Got one!
                }
            head = head.chain;
        }
    }
    // No one found.
    return head;
};

//------------------------------------------------------------------------//
//  This checks if the pet dragon will wake up when it finds a target.
//------------------------------------------------------------------------//
float(float all) Draco_FindNewTarget =
{
    if (Draco_IsAllowedToFight (self))
    {   // Look for targets to fight.
        local   entity  head;

        head = Draco_FindNewTarget_II (self.enemy, all);
        if (head)
        {
            self.enemy = head;
            FoundTarget ();
            return TRUE;
        }
    }
    return FALSE;
};

//------------------------------------------------------------------------//
//  The pet dragon checks if it can ignore its current target and
//  attack another target it found.
//------------------------------------------------------------------------//
float() Draco_FindSecondaryTarget =
{
    local   entity  oldmeat;

    oldmeat = self.enemy;
    if (PM_IgnorableTarget (self.enemy))
    {   // Current target can be ignored for now.
        // First, check if we had a previous opponent.  If so,
        // attack it if we can see it and if it is good idea.
        if (self.oldenemy)
            if (visible (self.oldenemy))
                if (!PM_IgnorableTarget (self.oldenemy))
                {
                    self.enemy = self.oldenemy;
                    self.oldenemy = oldmeat;
                    HuntTarget ();
                    return TRUE;
                }

        // We didn't have an oldenemy worthy of attacking now,
        // so check for any other easy prey nearby.
        if (Draco_FindNewTarget (FALSE))
        {
            self.oldenemy = oldmeat;
            return TRUE;
        }
    }
    // No other targets found, so continue the fight with current enemy.
    return FALSE;
};


//==========================================================================
//  Pain Reaction

//------------------------------------------------------------------------//
//  This makes the dragon disappear if attacked by the bloodcube.
//
//  NOTE:  Assumes dragon has a master.
//------------------------------------------------------------------------//
float(entity pet, entity cube) Draco_Vs_Cube =
{
    if (cube.classname != "BloodCube")
        return FALSE;   // Not attacked by bloodcube.
    if (pet.health <= COST_PET_TELEPORT)
        return FALSE;   // Too weak to avoid the cube.
    if (!(self.xfl & XFL_DRACO))
        return FALSE;   // Only Draco can escape the Sanguinoch.

    // Leave and don't come back until the bloodcube goes away.
    local   float   standby;

    standby = (cube.radsuit_finished - time) + 3;   // Check bloodcube code.
    Draco_Disappear (pet, standby);
    Draco_PayTeleportCost (pet);

    return TRUE;
};


//==========================================================================
//  Pet Behavior

//------------------------------------------------------------------------//
//  This rotates the pet in place before it uses its missile attack.
//------------------------------------------------------------------------//
void() pet_rotate =
{
    if (cutscene)
        return;

    // Get spot to aim at.
    local   vector  spot;

    spot = Ryu_AimForward();

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
    Draco_TrackMaster ();
};

//------------------------------------------------------------------------//
//  This is basic non-follow idle ai.  The pet dragon can hover in place
//  or fly slowly back and forth.
//------------------------------------------------------------------------//
void(float move) pet_idle =
{
    self.ryuflags = self.ryuflags | RYU_SLOW;
    self.search_time = time + DRACO_SEARCH;
    ryu_untilt ();          // Undo any angle changes due to evasion.
    Draco_TrackMaster ();   // Keep track of where the master went.

    if (move)
    {   // Patrol movement code below.
        // Rotate in place if necessary before flying straight ahead.
        // Then, if movement was blocked, turn around and fly.
        if (!MatchingIdeal ())
            ChangeYaw ();
        else if (!safe_move (self.angles_y, SPEED_RYU_MIN))
            self.ideal_yaw = anglemod (self.angles_y + 180);
    }
};

//------------------------------------------------------------------------//
//  This tells Draco to follow its master.  Draco may do other tasks
//  instead, such as flying toward an item and taking it.
//------------------------------------------------------------------------//
void(entity item, entity shot) pet_follow =
{
// Avoid projectiles or other threats.
    if (!ImmuneToDamage (self))
        if (shot)
        {
            Ryu_FindBestPath (self.speed, shot);
            Draco_TrackMaster ();
            return;
        }

// Stay out of the master's personal space!
    if (Overlap (self, self.master))
        Ryu_VerticalSlide (self.speed, self.master);

// Nothing to dodge, so level out and go after the goal.
    ryu_untilt ();
    if (item)
    {   // Go after the found item.
        Draco_GotoItem (item);
        Draco_TrackMaster ();
    }
    else    // Seek out the master.
        Draco_Follow ();
};

//------------------------------------------------------------------------//
//  The following scans for various things around the dragon.
//  They are very similar and have much code in common.
//
//  Together, it all looks ugly, but I did it this way for efficiency
//  (read: game speed) reasons.  Findradius can be slow (at least with
//  hardware during Quake's time, circa late 1990s), and I don't want
//  to call it three or more times in a row.
//
//  Update (2007):  With the speed of modern computers, some code can be
//  combined into a single function to reduce duplicate code.  Whatever
//  speed benefit the extra code had years ago won't be noticed now.
//
//  This begins and sets up walk mode for the pet dragon.
//------------------------------------------------------------------------//
// Find enemies, items, and deadly obstacles.
void() pet_walk =
{
    if (self.ryuflags & RYU_FORCED)
    {   // Busy shooting on demand, so no need to check the world for stuff.
        pet_rotate ();
        return;
    }

    local   entity  head, item, shot;
    local   float   dar, dist, eat, id, reach;
    local   vector  spot;

    dar = self.maxs_x * 1.5625 + 275;   // dar = Draco_Avoid_Radius.
    id = SIGHT_RADIUS + 1;      // 'item' distance from self.
    eat = Draco_Hungry ();
    item = shot = world;
    head = findradius(self.origin, SIGHT_RADIUS);
    while (head)
    {
        // The dragon looks for things to fight or to avoid.
        if (head != self)
        {
            if (head.loottype == LOOT_FOOD)
                spot = head.origin;
            else
                spot = head.origin + ((head.mins + head.maxs) * 0.5);
            traceline(self.origin, spot, TRUE, self);
            if (trace_fraction == 1)
            {
//- - The fight-a-target part. - -
                // Check for targets to fight.
                if (Draco_IsAllowedToFight (self))
                    if (Draco_ValidTarget (head))
                    {   // Enemy found.
                        self.enemy = head;
                        FoundTarget ();
                        return;
                    }
//- - - - - - - - - - - - - - - - -

                // No targets, check for other things.
                dist = vlen (spot - self.origin);

                // Check for items.
                if (Draco_SafeItem (spot))
                {
                    reach = (self.size_x + head.size_x)*0.5;
                    if (Draco_AcceptItem (head, dist, eat, reach))
                        if (Draco_TargetNewItem (item, id, head, dist, reach))
                            {item = head;  id = dist;}
                }

                // Check for nasty things.
                if (dist <= dar)
                    if (Ryu_IsHostile (head))
                        shot = head;
            }
        }
        head = head.chain;
    }

// If close enough to take an item, take it and set item value to world.
    if (item)
    {
        head = self.goalentity;
        self.goalentity = item;
        if (QC_CloseEnough (self.speed))
        {   // Take the item.
            SUB_Touch (self, item);
            item = world;
        }
        self.goalentity = head;
    }

// Now move!  Draco either follows its master, or glides back and forth.
    if (self.ryuflags & RYU_STAY)
        pet_idle (FALSE);
    else if (cutscene)
        pet_idle (FALSE);   // Don't follow -- player is camera.
    else if (self.ryuflags & RYU_PATROL)
        pet_idle (TRUE);
    else
        pet_follow (item, shot);
};


////////////////////////////////////////////////////////////////////////////
//  4.  Spawning Rules
////////////////////////////////////////////////////////////////////////////

//==========================================================================
//  Pet Disposal

//------------------------------------------------------------------------//
//  This makes a pet dragon disappear permanently.
//  Should only be called if the pet is hiding.
//------------------------------------------------------------------------//
void() draco_erase =
{
    self.deadflag   = DEAD_DEAD;
    self.nextthink  = 0.01;
    self.think      = SUB_Remove;
};

//------------------------------------------------------------------------//
//  Called when Draco dies.
//------------------------------------------------------------------------//
void() draco_end =
{
    // If the dragon had extra entities attached, remove them!
    DracoNode_Remove (self);

    // Sever link from master then die.
    local   entity  client;

    client = self.master;
    if (client)
    {
        Draco_Talk (self, "...");
        if (self == client.draco)
        {
            client.draco    = world;
            client.ryuflags = client.ryuflags - (client.ryuflags & RYU_DRACO);
        }
    }

    // Reset death functions.
    if (Draco_Gone (self))
        self.th_die = draco_erase;    // Non-solid, so just disappear.
    else
        self.th_die = dragon_die;
    self.th_void = monster_void;
    // Death functions called elsewhere.
};
void() draco_die = {draco_end ();  self.th_die ();};
void() draco_void = {draco_end ();  monster_void ();};


//==========================================================================
//  Pet Creation

// Sets Draco's size.
void(entity pet) Draco_SetSize =
{
    if (pet.height == 1)
        setsize (pet, '-64 -64 -24', '64 64 64');
    else if (pet.height == 2)
        setsize (pet, '-96 -96 -24', '96 96 96');
    else
        setsize (pet, '-32 -32 -24', '32 32 32');
};

//------------------------------------------------------------------------//
// Returns the max health of a dragon.  Used more than once by Draco code.
// 0 = 200, 1 = 800, 2 = 1800, 3 = 3200.
//
// Note:  Other dragons could use this, but do not need to.  It is easier
// to simply plug in the proper number than call a function to find it.
// Therefore, it it used only by Draco bot code.
//------------------------------------------------------------------------//
float(float mx) Draco_MaxHealth =
{
    mx = mx + 2;        // Was 'mx * 2 + 2' for normal dragons.
    mx = mx * mx;
    return (50 * mx);
};

//------------------------------------------------------------------------//
//  This sets Draco's model.
//
//  Warning:  Draco's navigation AI assumes maxs_z of 64 or less.
//  If using maxs_z > 64, Draco may clip ceilings.
//  Use large size at your own risk.
//------------------------------------------------------------------------//
void(entity pet) Draco_SetModel =
{
    pet.view_ofs = '0 0 25';
    setmodel (pet, "progs/dragon1.mdl");
    Draco_SetSize (pet);
    if (pet.height == 1)
    {
        pet.gib_health  = -90;
        pet.burn_ofs    = '4 0 22';
        pet.th_move     = Wyrm_WalkMove;
        pet.th_goal     = QC_MoveToGoal;
    }
    else if (pet.height == 2)
    {
        pet.gib_health  = 0;    // Can't gib.
        pet.burn_ofs    = '4 0 32';
        pet.th_move     = Wyrm_WalkMove;
        pet.th_goal     = QC_MoveToGoal;
    }
    else    // Default to small size.
    {
        pet.gib_health  = -60;
        pet.burn_ofs    = '0 0 0';
        pet.th_move     = Ryu_WalkMove;
        pet.th_goal     = Ryu_MoveToGoal;
    }
    if (pet.gib_health)
        pet.th_gib      = dragon_gib;
    else
        pet.th_gib      = world.th_gib;     // Points to null.
    pet.mindex2 = pet.modelindex;
};

//------------------------------------------------------------------------//
//  This sets Draco's skin and size based on the values held by its
//  master.
//------------------------------------------------------------------------//
void(entity client, entity pet) Draco_SetType =
{
    local   float   element, rflags;

// Reset the elements.
    pet.ryuflags = pet.ryuflags - (pet.ryuflags & RYU_ELEMENTS);

    rflags = client.ryuflags & RYU_ELEMENTS;
    if (rflags == RYU_USE_LITE)
        {element = RYU_USE_LITE; pet.skin = SKIN_BLUE;}
    else if (rflags == RYU_USE_ACID)
        {element = RYU_USE_ACID; pet.skin = SKIN_GREEN;}
    else if (rflags == RYU_USE_ICE)
        {element = RYU_USE_ICE; pet.skin = SKIN_WHITE;}
    else
        {element = RYU_USE_FIRE; pet.skin = SKIN_RED;}
// DISABLED:  Player dragon model removed.
//    pet.skin = pet.skin + 1;    // Using PC model, so add to get right color.

    if (client.ryuflags & RYU_RED)  // Check for attack override.  If TRUE,
        element = RYU_USE_FIRE;     // fire-breathing is locked to all types.

    pet.ryuflags = pet.ryuflags | element;
    Ryu_ElementalStats (pet);       // Sets special attacks too.

// Reset size.
    rflags = (client.ryuflags & RYU_SIZE_BITS) / RYU_SIZE_BASE;
    if (pet.height != rflags)
    {   // Size change.
        local   float   hi;     // New max health.
        local   float   hp;     // Health after transformation.

        hi = Draco_MaxHealth (rflags);
        if (pet.max_health)
            hp = floor (pet.health * hi / pet.max_health);
        // The alternatives shouldn't happen, but are here just in case.
        else if (pet.health > hi)
            hp = hi;
        else
            hp = pet.health;

        if (hp < 1)
            hp = 1;
        pet.max_health = hi;
        pet.health = hp;

        pet.height = rflags;
        Regen_Set (pet, DRACO_REGEN);
        if (Draco_Gone (pet))
        {   // Reset size so the summon code uses the correct distance.
            // Everything else "will be done later when Draco returns."
            // Important:  Make sure sizes match those in 'Draco_SetModel'.
            pet.view_ofs = '0 0 25';
            Draco_SetSize (pet);
        }
        else
        {   // Show tranformation effects.
            Draco_SetModel (pet);
            if (Overlap (pet, pet.master))
                Draco_Disappear (pet, 0);   // Do not trap master.
            else
                spawn_tfog (pet.origin);
        }
    }
};

//------------------------------------------------------------------------//
//  This sets Draco's health and armor to the max.
//------------------------------------------------------------------------//
void(entity pet) Draco_FullHeal =
{
    pet.max_health = Draco_MaxHealth (pet.height);
    pet.health = pet.max_health;
    T_Repair (pet, pet.max_health, 0);
    Regen_Set (pet, DRACO_REGEN);
};

//------------------------------------------------------------------------//
//  This makes the dragon appear, facing the player; then sends it off.
//------------------------------------------------------------------------//
void(vector spot) Draco_Go =
{
    // Go to spawn point.
    setorigin (self, spot);

    // Make the dragon solid.
    self.movetype   = MOVETYPE_STEP;
    self.solid      = SOLID_SLIDEBOX;
    self.takedamage = DAMAGE_AIM;
    self.touch      = Draco_Touch;

    // Make the dragon face its master.
    self.angles_x   = 0;
    self.angles_y   = vectoyaw(self.master.origin - self.origin);
    self.angles_z   = 0;
    self.fixangle   = TRUE;
    self.ideal_yaw  = self.angles * '0 1 0';

    // Don't let the dragon stay or fire as soon as it appears.
    // Exception:  If flagged by teleport command, remove it instead of stay.
    if (self.ryuflags & RYU_TELEPORT)
        self.ryuflags = self.ryuflags - (self.ryuflags & (RYU_TELEPORT | RYU_FORCED));
    else
        self.ryuflags = self.ryuflags - (self.ryuflags & (RYU_STAY | RYU_FORCED));

    // The dragon shall appear now.
    spawn_tfog (self.origin);
    Draco_SetModel (self);
    DracoAI_GoIdle (self);      // Engage!
};

//------------------------------------------------------------------------//
//  This initializes a newly created pet dragon's stats.  In addition,
//  this increases the current count of pet dragons on the level.
//------------------------------------------------------------------------//
void(entity client, float xfer) Draco_Spawn =
{
    local   entity  pet;

    pet = spawn();
    client.draco = pet;
    client.ryuflags = client.ryuflags | RYU_DRACO;  // It's alive!

    // Begin creation process.

    setmodel (pet, string_null);
    setsize (pet, '-32 -32 -24', '32 32 32');
    setorigin (pet, VEC_ORIGIN);

    pet.takedamage  = DAMAGE_NO;
    pet.movetype    = MOVETYPE_NONE;
    pet.touch       = SUB_Null;
    pet.solid       = SOLID_NOT;
    pet.deadflag    = DEAD_NO;
    pet.classname   = "monster_dragon";

    pet.master      = client;   // "All your base are belong to us!"

    // FLAGS -- Set these *before* calling functions that can change them!
    pet.flags       = FL_FLY | FL_MONSTER;
    pet.ryuflags    = RYU_ALERT;    // Draco is smarter than average.
    pet.xfl         = XFL_DRACO;    // Use Draco-bot code.  Do before Align*.
    pet.lip         = 1;            // Draco is strong for his size.

    // IDENTITY
    pet.netname     = "Draco";      // Named NPC.
    Align_Add (pet, TRUE);          // One of the good guys!  Changes .xfl.

    // ACTIONS
    pet.th_stand    = draco_fly;
    pet.th_walk     = draco_fly;
    pet.th_run      = dragon_run;
    pet.th_missile  = dragon_missile1;
    pet.th_melee    = dragon_strike;
    pet.th_pain     = dragon_pain;
    pet.th_die      = draco_die;
    // Expanded actions //
    pet.th_sight    = dragon_sight;
    pet.th_check    = DragonCheckAttack;
    pet.th_gib      = dragon_gib;
    pet.th_void     = draco_void;
    pet.th_move     = Ryu_WalkMove;     // Set this before call to *SetType.
    pet.th_goal     = Ryu_MoveToGoal;   // Ditto.

    // DRAGON TYPE and SIZE
    pet.height      = 0;          // Default to small size.
    pet.view_ofs    = '0 0 25';   // Draco's eyes.
    Draco_FullHeal (pet);
    Draco_SetType (client, pet);    // Changes .ryuflags.

    // ITEMS
    pet.items = 0;
    // ----- (ammo) -----
    pet.ammo_shells = pet.ammo_nails = pet.ammo_rockets = pet.ammo_cells = 0;
    // ----- (armor) -----
    pet.armor_stats = '0 0 0';
    // ----- (health) -----
    pet.healamount = pet.healtype = 0;
    // ----- (keys) -----
    pet.keyop1 = pet.keyop2 = world;
    // ----- (powerups) -----
    SUB_Think (pet, SUB_RemovePowerups);

    // AIR SUPPLY
    more_air (pet);     // So it doesn't drown if it spawns underwater.

    // SPAWNFLAGS
    pet.spawnflags = 0;    // Draco does not use spawnflags.

    // SPEED
    pet.speed      = 32;   // This is as fast as the player.
    pet.yaw_speed  = 20;   // Standard for 'walkmonsters' and dragons.

    // Actions used to be here.

    // MOVEMENT AI
    pet.dodge_back = 0;
    pet.panic_time = 0;

    // WAYPOINT STUFF
    pet.pos1       = pet.pos2     = VEC_VOID;
    pet.node       = world;

    // MISCELLANEOUS STUFF
    pet.bloodtype  = BLOOD_RED;
    pet.spawned    = TRUE;
    pet.mdl_head   = "progs/dr_head.mdl";
    pet.purse      = '0 0 1';   // Does not carry money... yet.

    // ACTIVATION -- "Go!"
    if (xfer)
        pet.nextthink   = time + 0.5 + random();    // Level transfer.
    else
        pet.nextthink   = 0.01;
    pet.think       = Draco_Start;
};


//==========================================================================
//  Dragon Powerup

//------------------------------------------------------------------------//
//  Checks if Draco is alive based on its client/master's data flags.
//------------------------------------------------------------------------//
float(entity client) IsDracoAlive = {return (client.ryuflags & RYU_DRACO);};

//------------------------------------------------------------------------//
//  This creates a entity that will spawn Draco soon.  This is used to
//  transport Draco from level to level.
//
//  'self' here = client/player.
//------------------------------------------------------------------------//
void() Draco_Crossover =
{
    // Spawn Draco only if he is alive but not on the level.
    // 0 = client, 1 = xfer pack
    if (IsDracoAlive (self))
        if (!self.draco)
            Draco_Spawn (self, 1);
};

//------------------------------------------------------------------------//
//  This powers up Draco, the player's persistent minion.
//------------------------------------------------------------------------//
void(entity client) Draco_Powerup =
{
    if (IsDracoAlive (client))
        sprint (client, "Draco feels refreshed\n");
    else
        sprint (client, "Draco befriends you\n");   // First appearance.

// Heal Draco back up to full strength.
    if (client.draco)
    {   // Heal and change types.
        Draco_FullHeal (client.draco);
        Draco_SetType (client, client.draco);
        Burn_Null (client.draco);       // Put out the fire!
    }
    else
    {   // Draco does not exist yet so create him.
        Draco_Spawn (client, 0);    // parms: 0 = client, 1 = xfer pack
    }

// Note:  Use generic monster summon here for spawn more dragons if desired.
};


//==========================================================================
//  Dragon Item Definition

//------------------------------------------------------------------------//
//  This sets the client's attack type flags.
//  These are used to set Draco's attack types when Draco is spawned
//  as a result from touching the Draco powerup.
//
//  Update:  Sets Draco's size as well.
//------------------------------------------------------------------------//
void(entity client) Draco_ClientFlags =
{
    local   float   element, beef, hi;

// Note:  'self' is the item touched.
// Color - - - - - -
    if (self.skin == SKIN_GREEN)
        element = RYU_USE_ACID;
    else if (self.skin == SKIN_BLUE)
        element = RYU_USE_LITE;
    else if (self.skin == SKIN_WHITE)
        element = RYU_USE_ICE;
    else
        element = RYU_USE_FIRE;

// Size - - - - - -
    // Enlarge Draco if the item size value is larger.
    // Note:  There are other ways to change size depending on game balance.

    // Item uses the same values defined by map editor as the dragon.
    beef = floor(self.height - 1) & 3;      // Four sizes max.
    if (beef == 3)
        beef = 0;   // Update:  Only three sizes possible.
    beef = (beef * RYU_SIZE_BASE) & RYU_SIZE_BITS;
    // Don't let item reduce the size of Draco.
    // "Chicks dig giant robots." -- MegasXLR  (In this case, dragons.)
    hi = client.ryuflags & RYU_SIZE_BITS;
    if (hi > beef)
        beef = hi;

// Update the client's flags.
    client.ryuflags =
        (client.ryuflags - (client.ryuflags & (RYU_ELEMENTS|RYU_SIZE_BITS)))
        | element | beef;
};

//------------------------------------------------------------------------//
//  This is called when a player touches the dragon powerup.
//  The player who touches the powerup summons Draco at full power.
//
//  WARNING:  Do NOT let any non-client (i.e., monsters) take this item!
//  Draco bot code assumes master is a player.  If not, game will crash.
//------------------------------------------------------------------------//
void() draco_touch =
{
    if (other.classname != "player")
        return;
    if (other.health <= 0)
        return;

    // Note:  Item removal used to be done here.

    // do the apropriate action
    sound (other, CHAN_VOICE, self.noise, 1, ATTN_NORM);
    stuffcmd (other, "bf\n");

    // Teleport Draco to its master.  Do this before powerup.
    if (other.draco)
        Draco_Disappear (other.draco, 0);
    Draco_ClientFlags (other);
    Draco_Powerup (other);    // This will display a "You got..." message.

    activator = other;
    SUB_UseTargets();       // fire all targets / killtargets

    ClearItem (60);
};

//------------------------------------------------------------------------//
//  This changes the item's skin.  Repeat every two seconds.
//------------------------------------------------------------------------//
void() draco_shift =
{
    if (self.skin == SKIN_RED)
        self.skin = SKIN_GREEN;
    else if (self.skin == SKIN_GREEN)
        self.skin = SKIN_BLUE;
    else if (self.skin == SKIN_BLUE)
        self.skin = SKIN_WHITE;
    else
        self.skin = SKIN_RED;
    self.nextthink = time + 2;
};

//------------------------------------------------------------------------//
//  Sets up item thinking for 'draco_shift'.  Do NOT change skins here.
//------------------------------------------------------------------------//
void() draco_check = {self.nextthink = time + 2; self.think = draco_shift;};

//============
// --> QUAKED item_dragon (0 .5 .8) (-16 -16 -24) (16 16 32) big
// Player gets the dragon familiar Draco.  Draco fights for player.
//============
void() item_draco =
{
    local   float   cycle;

    cycle = !self.skin;     // Activate item thinking if .skin = 0.
// SoE:  Gold dragon unavailable to Draco, so change to red.
    if (self.skin == SKIN_GOLD)
        self.skin = SKIN_RED;
//- - - - - - - - -
    if (!self.spawned)
    {
        dragon_cache ();
        precache_model ("progs/draco.mdl");
        precache_sound ("weapons/pkup2.wav");
    }
    setmodel (self, "progs/draco.mdl");
    Ryu_SetSkin ();   // Item uses the same color scheme as 'monster_dragon'.
    self.touch    = draco_touch;
    self.noise    = "weapons/pkup2.wav";
    self.netname  = "Draco";
    if (cycle)
        self.th_win   = draco_check;
    setsize (self, '-16 -16 -24', '16 16 32');
    StartItem ();
};

// Original name for 'item_draco'.
void() item_dragon = {self.classname = "item_draco"; item_draco();};


//==========================================================================
//  Epilogue

//------------------------------------------------------------------------//
//  When called, Draco gives everything to its master immediately.
//  Called at the end of a level.
//------------------------------------------------------------------------//
void(entity client) Draco_Xfer =
{
    if (client.deadflag)
        return;     // Dead!

    local   entity  head;

    head = client.draco;
// Give everything to the master -- discreetly.
    if (head)
    {
        if (head.war)
            if (!(client.arsenal & head.war))
        {
            // Draco has a new weapon.  Since this is the end of a level,
            // there is no need to call the function that updates v_weapon
            // or currentammo, because that is done at the next level.
            client.arsenal = client.arsenal | head.war;
            client.war = head.war;
        }
        T_Heal (client, head.healamount, FALSE);
        Armor_Add (client, head.armor_stats);
        client.ammo_shells  = client.ammo_shells + head.ammo_shells;
        client.ammo_nails   = client.ammo_nails + head.ammo_nails;
        client.ammo_rockets = client.ammo_rockets + head.ammo_rockets;
        client.ammo_cells   = client.ammo_cells + head.ammo_cells;
        bind_ammo (client);
    }
};

//------------------------------------------------------------------------//
//  This causes Draco to (appear to) exit the level.
//------------------------------------------------------------------------//
void(entity client) Draco_Exit =
{
    local   entity  head;

    head = client.draco;
    if (head)
    {
        Draco_Xfer (client);    // Hand over the loot now.
        if (!Draco_Gone (head))
            spawn_tfog (head.origin);
        Burn_Null (head);
        head.movetype   = MOVETYPE_NONE;
        head.takedamage = DAMAGE_NO;
        head.solid      = SOLID_NOT;
        head.touch      = head.think    = SUB_Null;
        head.nextthink  = -1;
        head.modelindex = 0;
        setorigin (head, client.origin);  // Go to master's intermission spot.
    }
};

// Called by 'powerup_touch'.
void(entity ent) Draco_Share =
{
    ent = ent.draco;
    if (ent)
        if (!IsDead (ent))
            Powerup_Start (ent);
};


////////////////////////////////////////////////////////////////////////////
//  5.  Interface
////////////////////////////////////////////////////////////////////////////

//==========================================================================
//  Pet Communication

//------------------------------------------------------------------------//
//  This checks if a pet is allowed to talk to its master.
//------------------------------------------------------------------------//
float(entity pet) Draco_Silent =
{
    if (cutscene)
        return TRUE;    // Shouldn't talk during a cutscene.
    if (pet.master.health <= 0)
        return TRUE;    // Master is dead.
    if (!(pet.master.flags & FL_CLIENT))    // Classname may not be "player".
        return TRUE;    // Only players have a screen.

    if (pet.health > 0)
    {
        if (Draco_Gone (pet))
            return TRUE;    // Gone for now.
    }
    // Else (FALSE) always lets Draco broadcast "..." when slain.

// Allowed to talk.
    return FALSE;
};

//------------------------------------------------------------------------//
//  This displays a message from Draco to its master.
//------------------------------------------------------------------------//
void(entity pet, string text) Draco_Talk =
{
    if (Draco_Silent (pet))
        return;     // Not allowed to talk.

// Display name if applicable.
    if (pet == pet.master.draco)
        sprint (pet.master, "ƒÚ·„Ô∫ ");
    else
        return;     // Don't talk if nameless.

// Display message.
    sprint (pet.master, text);
    sprint (pet.master, "\n");
};


//==========================================================================
//  Hide/Teleport Familiar

//------------------------------------------------------------------------//
//  This commands the dragon to teleport near its master.
//------------------------------------------------------------------------//
float(entity pet, float hide) DracoImp_Warp =
{
    if (Draco_Gone (pet))
    {   // Already teleported out of the level, so bring the dragon back.
        Draco_Disappear (pet, 0);
        return TRUE;
    }

    if (pet.health <= COST_PET_TELEPORT)
    {   // "I am too weak to teleport."
        Draco_Talk (pet, "I can't.");
        return FALSE;
    }

// Teleport is a success.
    if (hide)
    {
        if (deathmatch)
        {   // Hiding is disabled in deathmatch.
            Draco_Talk (pet, "No -- I want to fight!");
            return FALSE;
        }
        Draco_Talk (pet, "I will await your call.");
        Draco_Disappear (pet, -1);
    }
    else
    {   // Add the teleport flag so the stay flag is left alone.
        pet.ryuflags = pet.ryuflags | RYU_TELEPORT;
        Draco_Disappear (pet, 0);
    }
    Draco_PayTeleportCost (pet);
    self.attack_finished = time + 0.5;  // Add cast delay ala Diablo2.
    // Note:  Definitely add a delay to prevent tfog entity spamming.

    return TRUE;
};


//==========================================================================
//  Forced Shooting

//------------------------------------------------------------------------//
//  This tells the dragon to fire its breath weapon if possible.
//  If the dragon cannot shoot, it gives a reason why.
//  TRUE = Silence.  FALSE = Draco speaks.
//------------------------------------------------------------------------//
float(entity pet) DracoImp_Shoot =
{
    if (pet.ryuflags & RYU_FORCED)
        return TRUE;    // Already shooting; ignore and do not talk.

    if (!visible (pet))
    {   // Must see player to shoot.
        if (pet == self.draco)
            sprint (self, "You must be able to see Draco to order an attack.\n");
        return FALSE;
    }
    if (Ryu_NoShot (pet))
    {   // Dragon refuses to shoot.
        Draco_Talk (pet, "NO!");
        return FALSE;
    }
//- - - - - - - - -
// Here used to be the 'master blocking the shot' check.  The old check
// was imprecise and unreliable.
//
// With attacks having parabolic shots, various ranges, and/or scattering,
// it would be a mess to check if the master really was in the way.
// Therefore, pass to keep it simple, and let the player fry if he is
// dumb enough to stand in front of Draco while ordering an attack.
//- - - - - - - - -

// All clear -- will begin to shoot.
    pet.ryuflags = pet.ryuflags | RYU_FORCED;
    // Can only force shoot if idle, so make it idle if in fight mode.
    // Note:  Compiler does not understand (pet.enemy || pet.oldenemy)
    if (pet.enemy)
        DracoAI_GoIdle (pet);
    else if (pet.oldenemy)
        DracoAI_GoIdle (pet);
    return TRUE;
};


//==========================================================================
//  Stay/Follow

//------------------------------------------------------------------------//
//  This commands the dragon to stay or move.
//------------------------------------------------------------------------//
void(entity pet) DracoImp_Stay =
{
    // Patrol overrides follow, so remove it.
    // If removed, add stay so that follow is chosen.
    if (pet.ryuflags & RYU_PATROL)
        pet.ryuflags = (pet.ryuflags - RYU_PATROL) | RYU_STAY;

    if (pet.ryuflags & RYU_STAY)
    {   pet.ryuflags = pet.ryuflags - RYU_STAY;
        Draco_Talk (pet, "I will follow.");
    }
    else
    {   pet.ryuflags = pet.ryuflags | RYU_STAY;
        Draco_Talk (pet, "I will stay.");
    }
};

//------------------------------------------------------------------------//
//  This commands the dragon to move idlely toward.
//------------------------------------------------------------------------//
void(entity pet) DracoImp_Patrol =
{
    // Note:  Don't use 'visible (pet)' because it cannot penetrate water.
    traceline (self.origin+self.view_ofs, pet.origin+pet.view_ofs, TRUE, self);
    if (trace_fraction == 1)
    {   // Must see Draco to steer his path.
        local   vector  vec;

        // Stay overrides patrol, so remove it.
        pet.ryuflags = pet.ryuflags - (pet.ryuflags & RYU_STAY);

        if (!(pet.ryuflags & RYU_PATROL))
        {   pet.ryuflags = pet.ryuflags | RYU_PATROL;
            Draco_Talk (pet, "I will go.");
        }
//        else    // Just update where Draco should go.
//            Draco_Talk (pet, "Aye.");

        // Converge to where the master aims.
        makevectors (self.v_angle);
        vec = self.origin + '0 0 16';
        traceline (vec, vec + v_forward*2048, TRUE, self);
        pet.ideal_yaw = vectoyaw (trace_endpos - pet.origin);
    }
};


//==========================================================================
//  Fight/Ignore

//------------------------------------------------------------------------//
//  This commands the dragon to fight or not to fight.
//------------------------------------------------------------------------//
void(entity pet) DracoImp_Fight =
{
    // A dragon with the pacifist flag set will not attack targets.
    if (pet == self.draco)
    {
        if (pet.ryuflags & RYU_CALM)
        {   pet.ryuflags = pet.ryuflags - RYU_CALM;
            Draco_Talk (pet, "I will fight.");
        }
        else
        {   pet.ryuflags = pet.ryuflags | RYU_CALM;
            if (pet.enemy)
            {   Draco_Talk (pet, "I stopped fighting.");
                pet.enemy = pet.oldenemy = world;
            }
            else
                Draco_Talk (pet, "I will not attack.");
        }
    }
};


//==========================================================================
//  Itemfinding

//------------------------------------------------------------------------//
//  This shows Draco's inventory.
//------------------------------------------------------------------------//
void(entity pet) DracoImp_ShowPack =
{
    if (!pet)
        return;
    if (pet.master.classname != "player")   // For all of the sprint below.
        return;

    if (Draco_Silent (pet))
        return;
    if (Draco_Empty (pet))
        {Draco_Talk (pet, "My pack is empty.");  return;}

    local   string  text;
    local   float   i;

    Draco_Talk (pet, "I hold the following:  ");
    i = 0;
    if (pet.items & IT_KEY1)
    {   if (pet.keyop1)
            sprint (pet.master, pet.keyop1.netname);
        else
            sprint (pet.master, "Silver");
        i = 1;
    }
    if (pet.items & IT_KEY2)
    {   if (i)
            sprint (pet.master, ", ");
        if (pet.keyop2)
            sprint (pet.master, pet.keyop2.netname);
        else
            sprint (pet.master, "Gold");
        i = 1;
    }
    if (pet.war)
    {   if (i)
            sprint (pet.master, ", ");
        text = weapon_name (pet.war);
        sprint (pet.master, text);
        i = 1;
    }
    if (pet.armor_stats_y)
    {   if (i)
            sprint (pet.master, ", ");
        text = ftos (pet.armor_stats_y);
        sprint (pet.master, text);
        sprint (pet.master, " armor");
        i = 1;
    }
//- - - - -
    if (pet.healamount)
    {   if (i)
            sprint (pet.master, ", ");
        text = ftos (pet.healamount);
        sprint (pet.master, "HP: ");
        sprint (pet.master, text);
        i = 1;
    }
    else if (pet.healtype)  // Show antidote only if no health.
    {   if (i)
            sprint (pet.master, ", ");
        sprint (pet.master, "Antidote");
        i = 1;
    }
//- - - - -
    if (pet.ammo_shells)
    {   if (i)
            sprint (pet.master, ", ");
        text = ftos (pet.ammo_shells);
        sprint (pet.master, "S: ");
        sprint (pet.master, text);
        i = 1;
    }
    if (pet.ammo_nails)
    {   if (i)
            sprint (pet.master, ", ");
        text = ftos (pet.ammo_nails);
        sprint (pet.master, "N: ");
        sprint (pet.master, text);
        i = 1;
    }
    if (pet.ammo_rockets)
    {   if (i)
            sprint (pet.master, ", ");
        text = ftos (pet.ammo_rockets);
        sprint (pet.master, "R: ");
        sprint (pet.master, text);
        i = 1;
    }
    if (pet.ammo_cells)
    {   if (i)
            sprint (pet.master, ", ");
        text = ftos (pet.ammo_cells);
        sprint (pet.master, "C: ");
        sprint (pet.master, text);
        i = 1;
    }
    sprint (pet.master, "\n");
};

//------------------------------------------------------------------------//
//  This toggles "Greed Mode" for Draco.
//  ON = Seek and take nearly all types of items.
//  OFF = Seek and take only food and backpacks.
//
//  Note:  Greed mode is overpowered.  Only a cheat should turn it on.
//------------------------------------------------------------------------//
void(entity pet) DracoImp_Greedy =
{
    // With the greedy flag set, Draco will seek out items and take them.
    if (pet == self.draco)
    {
        if (pet.ryuflags & RYU_GREEDY)
        {   pet.ryuflags = pet.ryuflags - RYU_GREEDY;
            Draco_Talk (pet, "Hmmm...");
            pet.unload_time = time;     // Let player unload Draco now.
        }
        else
        {   pet.ryuflags = pet.ryuflags | RYU_GREEDY;
            Draco_Talk (pet, "I feel greedy.");
        }
    }
};


//==========================================================================
//  Cheats

// Toggles "godmode" for Draco.
void(entity pet) DracoCheat_God =
{
    if (pet == self.draco)
    {
        if (pet.flags & FL_GODMODE)
        {   pet.flags = pet.flags - FL_GODMODE;
            Draco_Talk (pet, "godmode OFF");
        }
        else
        {   pet.flags = pet.flags | FL_GODMODE;
            Draco_Talk (pet, "godmode ON");
        }
    }
};

// Toggles "notarget" for Draco.
void(entity pet) DracoCheat_Notarget =
{
    if (pet == self.draco)
    {
        if (pet.flags & FL_NOTARGET)
        {   pet.flags = pet.flags - FL_NOTARGET;
            Draco_Talk (pet, "notarget OFF");
        }
        else
        {   pet.flags = pet.flags | FL_NOTARGET;
            Draco_Talk (pet, "notarget ON");
        }
    }
};

// Toggles "dragonfire" for Draco.  If turned on, all colors use fire.
void() DracoCheat_Fire =
{
    if (self.ryuflags & RYU_RED)
    {   self.ryuflags = self.ryuflags - RYU_RED;
        sprint (self, "dragonfire OFF\n");
    }
    else
    {   self.ryuflags = self.ryuflags | RYU_RED;
        sprint (self, "dragonfire ON\n");
    }
    if (self.draco)
        Draco_SetType (self, self.draco);
};

// Changes the color (skin and attack type) of Draco.
void() DracoCheat_Color =
{
    local   float   e1, e2;

    e1 = self.ryuflags & RYU_ELEMENTS;
    if (e1 == RYU_USE_FIRE)
        {e2 = RYU_USE_ACID;  sprint (self, "Green\n");}
    else if (e1 == RYU_USE_ACID)
        {e2 = RYU_USE_LITE;  sprint (self, "Blue\n");}
    else if (e1 == RYU_USE_LITE)
        {e2 = RYU_USE_ICE;   sprint (self, "White\n");}
    else
        {e2 = RYU_USE_FIRE;  sprint (self, "Red\n");}
    self.ryuflags = (self.ryuflags - e1) | e2;

    if (self.draco)
        Draco_SetType (self, self.draco);
};

// Changes the size of Draco.
void() DracoCheat_Size =
{
    local   float   s1, s2;

    s1 = self.ryuflags & RYU_SIZE_BITS;
    s2 = (((s1 + RYU_SIZE_BASE) & RYU_SIZE_BITS) / RYU_SIZE_BASE) & 3;
    if (s2 == 1)
        sprint (self, "Medium\n");
    else if (s2 == 2)
        sprint (self, "Large\n");
    else
        {s2 = 0;  sprint (self, "Small\n");}
    self.ryuflags = (self.ryuflags - s1) | (s2 * RYU_SIZE_BASE);

    if (self.draco)
        Draco_SetType (self, self.draco);
};


////////////////////////////////////////////////////////////////////////////
//  6.  Interface                                                         //
////////////////////////////////////////////////////////////////////////////

//==========================================================================
//  Impulse Commands

//------------------------------------------------------------------------//
//  This is a safety check in which players without a pet dragon
//  available are told why the command failed.
//------------------------------------------------------------------------//
float(float nohide) IsDracoReady =
{
    if (!IsDracoAlive (self))
        {sprint (self, "Draco is not available.\n");  return FALSE;}
    if (!self.draco)
        {sprint (self, "Draco is not here yet.\n");  return FALSE;}
    if (Draco_Gone (self.draco))
        if (nohide)
            {sprint (self, "Draco is hiding.\n");  return FALSE;}

    return TRUE;    // Draco is available to receive commands.
};

//------------------------------------------------------------------------//
//  This commands the player's dragon via impulse.
//  Impulses that are currently used are:
//
//  NORMAL --
//   51 = Select Draco as a weapon.
//   52 = Teleport Draco to its master.  Costs Draco health.
//   53 = Tells Draco to stay or follow.
//   54 = Tells Draco to glide toward a point.  (a.k.a. Patrol mode.)
//   55 = Tells Draco to attack monsters on sight or ignore them.
//   56 = Show Draco's inventory.
//  CHEATS --
//   57 = Toggles Draco's greed for items.
//   58 = Toggles Godmode for Draco.
//   59 = Toggles Notarget for Draco.
//   60 = Toggles fire mode for Draco.
//   61 = Cycle Draco's colors.
//   62 = Cycle Draco's sizes.
//   63 = Spawn or powerup Draco.
//------------------------------------------------------------------------//
void() Draco_Impulse =
{
    if (self.impulse == 51)
        {SelectDraco (TRUE);  return;}
    if (self.impulse == 52)
    {   if (IsDracoReady (FALSE))
            DracoImp_Warp (self.draco, FALSE);
        return;
    }
    if (self.impulse == 53)
    {   if (IsDracoReady (TRUE))
            DracoImp_Stay (self.draco);
        return;
    }
    if (self.impulse == 54)
    {   if (IsDracoReady (TRUE))
            DracoImp_Patrol (self.draco);
        return;
    }
    if (self.impulse == 55)
    {   if (IsDracoReady (TRUE))
            DracoImp_Fight (self.draco);
        return;
    }
    if (self.impulse == 56)
    {   if (IsDracoReady (TRUE))
            DracoImp_ShowPack (self.draco);
        return;
    }
// Restricted commands -- The rest are cheats.
    if (deathmatch || coop)
        return;
    if (self.impulse == 57)
    {   if (IsDracoReady (TRUE))
            DracoImp_Greedy (self.draco);
        return;
    }
    if (self.impulse == 58)
    {   if (IsDracoReady (TRUE))
            DracoCheat_God (self.draco);
        return;
    }
    if (self.impulse == 59)
    {   if (IsDracoReady (TRUE))
            DracoCheat_Notarget (self.draco);
        return;
    }
    if (self.impulse == 60)
        {DracoCheat_Fire ();  return;}
    if (self.impulse == 61)
        {DracoCheat_Color ();  return;}
    if (self.impulse == 62)
        {DracoCheat_Size ();  return;}
    if (self.impulse == 63)
        {Draco_Powerup (self);  return;}
};


////////////////////////////////////////////////////////////////////////////
//  7.  Draco As Weapon                                                   //
////////////////////////////////////////////////////////////////////////////

//==========================================================================
//  Rapid Fire

//------------------------------------------------------------------------//
//  This dictates if the player is allowed to use rapid fire.
//  The field '.zerc' is used.  If the value of it is...
//
//  FALSE = Player can maintain rapid-fire.
//  TRUE  = Player must let go of fire button before he can attack again.
//
//  Note:  use 'zerc' because the only other entities that use it are
//   triggers, and they use it instead of 'cnt' for Zerstorer features.
//------------------------------------------------------------------------//
void(entity client, float nofire) DracoFire_Stop = {client.zerc = nofire;};

//------------------------------------------------------------------------//
//  This checks if the player is allowed to use rapid fire.
//
//  Call this function instead of checking the referenced variable
//  directly because if I wanted to change the variable referenced,
//  I need not scan through other files to update the code.
//------------------------------------------------------------------------//
float(entity client) DracoFire_Use = {return !client.zerc;};


//==========================================================================
//  Dragon Weapon Attack/Control

//------------------------------------------------------------------------//
//  This commands the dragon via the attack button.  Currently,
//  the command given depends on the situation.
//
//  If rapid-fire should be disrupted, FALSE is returned.
//  Rapid-fire should end if the dragon could talk at each frame.
//
//  All commands except shoot should always return FALSE.
//------------------------------------------------------------------------//
float() DracoWar_Attack =
{
    if (IsDracoReady (FALSE))
    {   // May command only Draco.
        local   entity  pet;

        pet = self.draco;
        if (!Draco_Gone (pet))
        {   if (pet.ryuflags & RYU_FORCED)
                return TRUE;    // Already shooting; ignore and do not talk.
            if (visible (pet))                  // Must see Draco...
                return DracoImp_Shoot(pet);     // ...for it to shoot.
        }
    // Couldn't shoot because Draco was gone/separated.
        DracoImp_Warp (pet, FALSE);   // Teleport Draco to master.
    }
    return FALSE;
};

//------------------------------------------------------------------------//
//  This checks if the player is using the attack button to command
//  the dragon to attack.  TRUE is returned if player tried to command
//  at least one dragon to attack.
//------------------------------------------------------------------------//
float() DracoWar_Check =
{
    if (!self.war)  // Only an unarmed player may command Draco.
    {
        if (IsDracoAlive (self))
        {
            if (DracoFire_Use (self))
                if (!DracoWar_Attack ())
                    DracoFire_Stop (self, TRUE);
            return TRUE;
        }
        // (else) Draco is dead, so switch to another weapon.
        War_FindBestWeapon ();
    }
    return FALSE;
};


//==========================================================================
//  Select Draco

//------------------------------------------------------------------------//
//  This returns Draco's health percentange to be displayed on the hud.
//  NOTE:  If entity == world, health will read 0.
//
//  Update:  Armor is not factored into the equation anymore.
//------------------------------------------------------------------------//
float(entity client) Draco_HealthOnHUD =
{
    if (client.draco)
    {
        local   float   hp, total;

        hp = client.draco.health;   //hp = ArmoredHealth (client.draco);
        if (hp > 0)
        {   total = client.draco.max_health;    //+ DRACO_ARMORVALUE;
            if (total > 0)
                return 100 * hp / total;
        }
    }

    return 0;   // Assume dead.
};

//------------------------------------------------------------------------//
//  This lets the player select Draco as weapon.
//------------------------------------------------------------------------//
float(float msg) SelectDraco =
{
    local   float   change;

    change = FALSE;
    if (IsDracoAlive (self))
    {   // Player already has Draco.
        if (self.war == 0)
        {   // If unarmed, Draco is the current weapon.  Change the command.
            if (IsDracoReady (TRUE))
                DracoImp_Stay (self.draco);     // Toggle stay/follow.
            return TRUE;
        }
        change = TRUE;
    }
    if (change)
    {   // Holster weapon and enable control of Draco.
        if (self.button0)
            DracoFire_Stop (self, TRUE);    // Don't let Draco shoot now.
        War_Select (0);
        return TRUE;
    }

    if (msg)
        sprint (self, "Draco is not available.\n");
    return FALSE;
};


//===========================/  END OF FILE  /===========================//

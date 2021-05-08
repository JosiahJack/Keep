//==========================================================================
//  petnode.qc -- by Patrick Martin             Last updated:  5-5-2001
//--------------------------------------------------------------------------
//  This file contains code that spawns and places waypoints that
//  allows pet dragons to follow their master(s).
//
//  NOTE:  This is used only to follow a master when it is not fighting.
//
//  FIXME:  Dragon should not try to follow while a cutscene is active.
//==========================================================================


//==========================================================================
//  Wandering

//----------------------------------------------------/ New Code /--------//
//  This checks if a wandering dragon decides to teleport to its master.
//
//  Dragon will auto-teleport if:
//  * Dragon spent at least 20 seconds wandering.
//  * Dragon has full health.
//  * Dragon's master is not holding down the fire button.
//
//  FIXME:  It is possible for dragon to get stuck going after an
//          unreachable node seen through broken terrain and not
//          auto-teleport because wandering state was never reached.
//------------------------------------------------------------------------//
float() PM_PetAutoTeleport =
{
    if (self.search_time + 20 < time)
        if (self.health >= self.max_health)
            if (!self.master.button0)
                if (PM_PetComeHere (self, FALSE))
                {
                    if (self == self.master.draco)
                        PM_DracoTalk (self, "I am back.");

                    // Teleporting drains health.
                    if (self.health > COST_PET_TELEPORT)
                        self.health = self.health - COST_PET_TELEPORT;
                    else
                        self.health = 1;
                    return TRUE;
                }

    return FALSE;
};

//----------------------------------------------------/ New Code /--------//
//  This causes the dragon to wander towards its goal.  iD's movetogoal
//  is used to follow walls.  If the dragon spends too much time
//  wandering, it will teleport to its master.
//------------------------------------------------------------------------//
void(float shift, float offset, float zgoal) PM_PetWander =
{
    if (PM_PetAutoTeleport ())
        return;

    movetogoal (shift);
    PM_SeekLevel (offset, zgoal);
};


//==========================================================================
//  Move-to-Goal

//----------------------------------------------------/ New Code /--------//
//  This causes the dragon to move towards its goal.  It will try to
//  move towards the goal in a straight line.  If it can't, it may
//  adjust where it wants to go.
//------------------------------------------------------------------------//
float(float shift) PM_PetMoveToGoal =
{
    if (walkmove (self.angles_y, shift))
    {
        self.stalled = time + 1;
        self.petofs  = OFFSET_LEVEL;
    }
    else
    {
        // Dragon was blocked (i.e., couldn't move).
        if (self.stalled < time)
        {
            // Dragon is stuck -- don't move here.
            self.petofs = OFFSET_LEVEL;
            if ((self.stalled + 1) < time)
            {
                // Still stuck...
                self.stalled = time + 1;
            }
            return FALSE;
        }

        // Try to move around the obstacle.
        local   vector  oldspot;

        oldspot = self.origin;
        movetogoal (shift);
        PM_ChangeOfs ();
        if (oldspot != self.origin)
            self.stalled = time + 1;
    }

    return TRUE;
};

//----------------------------------------------------/ New Code /--------//
//  This calculates how fast the dragon should approach the goal.
//  Speed can range anywhere from walking speed to full running speed.
//  Unless it is close, the dragon should approach the goal at full speed.
//  When it is close to the goal, the dragon slows down to prevent the
//  chance that the dragon may perpetually orbit the goal.
//
//  NOTE:  The formula this function uses assumes a yaw speed of 20.
//------------------------------------------------------------------------//
float(float dist) PM_PetGoalSpeed =
{
    local   float   shift;

    shift = floor(dist * 0.25);
    if (shift > self.speed)
        shift = self.speed;
    else if (shift < DRAGON_MINSPEED)
        shift = DRAGON_MINSPEED;

    return shift;
};


//==========================================================================
//  Node Spawning

//----------------------------------------------------/ New Code /--------//
//  This removes the dragon's node (waypoint) entity if it exists.
//------------------------------------------------------------------------//
void(entity ent) PM_RemoveNode =
{
    if (ent.node)
    {
        remove (ent.node);
        ent.node = world;
        ent.pos1 = ent.pos2 = VEC_ORIGIN;
    }
};

//----------------------------------------------------/ New Code /--------//
//  This creates the goal where the dragon will fly to.
//------------------------------------------------------------------------//
void(vector spot) PM_NewNode =
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
    self.node.dest       = VEC_ORIGIN;
    self.node.dest1      = VEC_ORIGIN;
    self.node.dest2      = VEC_ORIGIN;
    self.node.pos1       = VEC_ORIGIN;
    self.node.pos2       = VEC_ORIGIN;
};


//==========================================================================
//  Node Finding

//----------------------------------------------------/ New Code /--------//
//  This returns the location of the last waypoint on the path.
//------------------------------------------------------------------------//
vector(entity plist) PM_LastWaypoint =
{
    if (plist.pos2 != VEC_ORIGIN)
        return plist.pos2;
    if (plist.pos1 != VEC_ORIGIN)
        return plist.pos1;
    if (plist.dest2 != VEC_ORIGIN)
        return plist.dest2;
    if (plist.dest1 != VEC_ORIGIN)
        return plist.dest1;
    if (plist.dest != VEC_ORIGIN)
        return plist.dest;

    return plist.origin;
};

//----------------------------------------------------/ New Code /--------//
//  Normally, this places the node to a new waypoint if one exists.
//  If no new point exists, remove the node.
//
//  If backtracking, this places the node to one of the dragon's earlier
//  points on the path.  Used when dragon strays from the path due to
//  fighting, feeding, or looking for water.
//------------------------------------------------------------------------//
void(entity ent, float backtrack) PM_UpdateNode =
{
    if (backtrack)
    {
        // Create a point to help dragon get back on the path.
        ent.node.pos2  = ent.node.pos1;
        ent.node.pos1  = ent.node.dest2;
        ent.node.dest2 = ent.node.dest1;
        ent.node.dest1 = ent.node.dest;
        ent.node.dest  = ent.node.origin;

        setorigin (ent.node, ent.pos1);
        ent.pos1 = VEC_ORIGIN;

        return;
    }

    if (ent.node.dest != VEC_ORIGIN)
    {
        // Go to next point in trail.  Update list of waypoints.
        setorigin (ent.node, ent.node.dest);
        ent.node.dest  = ent.node.dest1;
        ent.node.dest1 = ent.node.dest2;
        ent.node.dest2 = ent.node.pos1;
        ent.node.pos1  = ent.node.pos2;
        ent.node.pos2  = VEC_ORIGIN;
        return;
    }

    if (ent.pos2 != VEC_ORIGIN)
    {
        // Go to the last known point where the master was.
        setorigin (ent.node, ent.pos2);
        ent.pos2 = VEC_ORIGIN;
        return;
    }

    // Trail has ended.  Remove the node.
    PM_RemoveNode (ent);
};

//----------------------------------------------------/ New Code /--------//
//  Called when dragon uses a teleporter.
//------------------------------------------------------------------------//
void(entity ent) PM_PetUseTeleport =
{
    // If going to the node, assume dragon is flying on the path.
    // Advance the list of waypoints so the dragon can find it master.
    if (ent.node)
        if (ent.goalentity == ent.node)
            PM_UpdateNode (ent, FALSE);
};

//----------------------------------------------------/ New Code /--------//
//  This checks if the dragon's master used a teleporter.  If so,
//  the dragon will look for the same teleporter.
//------------------------------------------------------------------------//
void() PM_HitTeleport =
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

                spot = PM_LastWaypoint (self.node);
                traceline (spot, self.pos2, TRUE, self);
                if (trace_fraction < 1)
                    return;
            }

            // Reachable -- move waypoint inside the teleporter.
            self.pos2 = org;
        }
    }
};

//----------------------------------------------------/ New Code /--------//
//  This tries to connect a path from the dragon to its master.
//------------------------------------------------------------------------//
float() PM_BuildPath =
{
    // First point.
    traceline (self.node.origin, self.master.origin, TRUE, self);
    if (trace_fraction == 1)
    {
        // Path connected.  Remove extra waypoints.
        self.node.dest = self.node.dest1 = self.node.dest2 = VEC_ORIGIN;
        self.node.pos1 = self.node.pos2 = VEC_ORIGIN;
        return TRUE;
    }
    if (self.node.dest == VEC_ORIGIN)
    {
        // Add waypoint to the list.
        PM_HitTeleport ();
        self.node.dest = self.pos2;
        return TRUE;
    }

    // Second point.
    traceline (self.node.dest, self.master.origin, TRUE, self);
    if (trace_fraction == 1)
    {
        self.node.dest1 = self.node.dest2 = VEC_ORIGIN;
        self.node.pos1 = self.node.pos2 = VEC_ORIGIN;
        return TRUE;
    }
    if (self.node.dest1 == VEC_ORIGIN)
    {
        PM_HitTeleport ();
        self.node.dest1 = self.pos2;
        return TRUE;
    }

    // Third point.
    traceline (self.node.dest1, self.master.origin, TRUE, self);
    if (trace_fraction == 1)
    {
        self.node.dest2 = self.node.pos1 = self.node.pos2 = VEC_ORIGIN;
        return TRUE;
    }
    if (self.node.dest2 == VEC_ORIGIN)
    {
        PM_HitTeleport ();
        self.node.dest2 = self.pos2;
        return TRUE;
    }

    // Fourth point.
    traceline (self.node.dest2, self.master.origin, TRUE, self);
    if (trace_fraction == 1)
    {
        self.node.pos1 = self.node.pos2 = VEC_ORIGIN;
        return TRUE;
    }
    if (self.node.pos1 == VEC_ORIGIN)
    {
        PM_HitTeleport ();
        self.node.pos1 = self.pos2;
        return TRUE;
    }

    // Fifth point.
    traceline (self.node.pos1, self.master.origin, TRUE, self);
    if (trace_fraction == 1)
    {
        self.node.pos2 = VEC_ORIGIN;
        return TRUE;
    }
    if (self.node.pos2 == VEC_ORIGIN)
    {
        PM_HitTeleport ();
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

//----------------------------------------------------/ New Code /--------//
//  This tries to link the node and its list of points to the dragon's
//  master.
//------------------------------------------------------------------------//
void() PM_TrailNode =
{
    if (!self.node)
        return;

    // If path is intact, update next waypoint.
    if (PM_BuildPath ())
        self.pos2 = self.master.origin;
};

//----------------------------------------------------/ New Code /--------//
//  This checks if the dragon's arrived at its destination.
//------------------------------------------------------------------------//
float() PM_PetInNode =
{
    local   vector  spot;
    local   vector  org;

    spot = self.node.origin;
    org  = self.origin;

    if (spot_x > org_x + self.maxs_x)  return FALSE;
    if (spot_x < org_x + self.mins_x)  return FALSE;
    if (spot_y > org_y + self.maxs_y)  return FALSE;
    if (spot_y < org_y + self.mins_y)  return FALSE;
    if (spot_z > org_z + self.maxs_z)  return FALSE;
    if (spot_z < org_z + self.mins_z)  return FALSE;

    return TRUE;
};

//----------------------------------------------------/ New Code /--------//
//  This checks if the way to the dragon's node is blocked.
//  That is, out of sight.
//------------------------------------------------------------------------//
float(vector org) PM_NodeInvisible =
{
    local   vector  p1, p2;

    // Check origins.
    p1 = org;
    p2 = self.node.origin;
    traceline (p1, p2, TRUE, self);
    if (trace_fraction == 1)
        return FALSE;

    // Check tops.
    p1_z = p1_z + self.maxs_z;
    p2_z = p2_z + self.node.maxs_z;
    traceline (p1, p2, TRUE, self);
    if (trace_fraction == 1)
        return FALSE;

    // Check bottoms.
    p1 = org;
    p2 = self.node.origin;
    p1_z = p1_z + self.mins_z;
    p2_z = p2_z + self.node.mins_z;
    traceline (p1, p2, TRUE, self);
    if (trace_fraction == 1)
        return FALSE;

    // Path is blocked!
    return TRUE;
};

//----------------------------------------------------/ New Code /--------//
//  This tells the pet dragon to go to a node.
//------------------------------------------------------------------------//
void() PM_GotoNode =
{
    // Check how fast dragon should fly to waypoint.
    local   float   delta;
    local   float   shift;

    delta = vlen(self.node.origin - self.origin);
    if (delta <= 64)
    {
        if (PM_PetInNode ())
        {
            // Dragon made it to a waypoint.  Update trail.
            PM_UpdateNode (self, FALSE);
            return;
        }
        shift = DRAGON_MINSPEED;
    }
    else
    {
        shift = PM_PetGoalSpeed (delta);
    }

    // Check if the waypoint is accessible.
    if (PM_NodeInvisible (self.origin))
    {
        // Can't see node?  Check if it can backtrack.
        if (self.pos1 != VEC_ORIGIN)
        {
            if (!PM_NodeInvisible (self.pos1))
            {
                // Backtrack is a success.
                PM_UpdateNode (self, TRUE);
                return;     // Stay cool -- don't move in this frame.
            }
            self.pos1 = VEC_ORIGIN;
        }

        // Can't see or backtrack.  Wander toward its general direction.
        PM_PetWander (shift, self.petofs, self.node.origin_z);
        return;
    }

    // Dragon can see the node.
    // Keep search time current as long as the dragon stays on the path.
    if (self.search_time < time)
        self.search_time = time;

    // Fly toward it.
    if (!PM_PetMoveToGoal (shift))
    {
        // Failed -- remove node.
        self.pos1 = self.pos2 = VEC_ORIGIN;
        PM_RemoveNode (self);
        return;
    }

    // Remember its current position.
    self.pos1 = self.origin;

    // Turn toward the node.  Adjust elevation if necessary.
    self.ideal_yaw = vectoyaw(self.node.origin - self.origin);
    ChangeYaw ();
    PM_SeekLevel (self.petofs, self.node.origin_z);
};


//==========================================================================
//  Triangle Waypoint Generation

//----------------------------------------------------/ New Code /--------//
//  This tries to create a waypoint by tracing a vector from the
//  dragon to where it is facing, and from that point to where
//  its master is.
//------------------------------------------------------------------------//
void() PM_CheckSecondTriangle =
{
    if (self.pos2 != VEC_ORIGIN)
        return;     // Already have a waypoint.

    local   vector  p1, p2;

    // Trace from dragon to where it is heading...
    p1 = self.origin + self.view_ofs;
    makevectors(self.angles);
    p2 = p1 + v_forward*8192;
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

//----------------------------------------------------/ New Code /--------//
//  This tries to create a waypoint by tracing a vector from the
//  player to where he is aiming, and from that point to where
//  the dragon is.
//------------------------------------------------------------------------//
void() PM_CheckTriangle =
{
    if (self.pos2 != VEC_ORIGIN)
        return;     // Already have a waypoint.

    local   vector  p1, p2;

    // Trace from master to where he is looking at...
    p1 = self.master.origin + self.master.view_ofs;
    makevectors(self.master.v_angle);
    p2 = p1 + v_forward*8192;
    traceline (p1, p2, TRUE, self.master);

    // ...then trace from dragon to that point.
    p2 = trace_endpos - v_forward*16;
    p1 = self.origin + self.view_ofs;
    traceline (p1, p2, TRUE, self);

    if (trace_fraction < 1)
    {
        PM_CheckSecondTriangle ();
        return;
    }

    // We have a connection, and a new waypoint.
    self.search_time = time + 1;
    self.pos2 = p2;
};


//==========================================================================
//  Trailing

//----------------------------------------------------/ New Code /--------//
//  This lets a pet dragon that is NOT following its master to
//  construct a trail that will hopefully lead to its master.
//------------------------------------------------------------------------//
void() PM_TrackMaster =
{
    // NOTE:  Used to reset 'stalled' time here.  Not anymore.

    // FIXME:  Should reset 'search_time' when not fighting.

    // Check if dragon can see its master.
    if (PM_PetOutOfSight (self))
    {
        // Can't see master, construct a trail.
        if (self.node)
        {
            // Check for backtrack.
            if (PM_NodeInvisible (self.origin))
            {
                if (self.pos1 != VEC_ORIGIN)
                {
                    if (!PM_NodeInvisible (self.pos1))
                        PM_UpdateNode (self, TRUE);
                    self.pos1 = VEC_ORIGIN;
                }
            }
            else
            {
                self.pos1 = self.origin;
            }

            // Check node trail.
            PM_TrailNode ();
        }
        else
        {
            // No trail.  Find a waypoint.
            PM_CheckTriangle ();
            if (self.pos2 != VEC_ORIGIN)
            {
                // Found a point.
                PM_HitTeleport ();
                PM_NewNode (self.pos2);
                self.pos2 = VEC_ORIGIN;
            }
        }
        return;
    }

    // Master is visible.  Remove trail and remember current location of
    // itself and its master.
    PM_RemoveNode (self);
    self.pos1 = self.origin;
    self.pos2 = self.master.origin;
};

//----------------------------------------------------/ New Code /--------//
//  If a pet dragon can't see its master, it will look for him by
//  following the trail of nodes.
//------------------------------------------------------------------------//
void() PM_LookForMaster =
{
    // Check if we are following a trail.
    if (self.node)
    {
        // If node exists, that means pet is following a trail.
        PM_GotoNode ();
        if (self.node)
        {
            PM_TrailNode ();
        }
        else
        {
            // Node was removed, check if we can make another.
            PM_CheckTriangle ();
            if (self.pos2 != VEC_ORIGIN)
            {
                PM_NewNode (self.pos2);
                self.pos2 = VEC_ORIGIN;
            }
        }
        return;
    }

    // Pet has no trail.  Try to find master's location, and make a path.
    PM_CheckTriangle ();
    if (self.pos2 != VEC_ORIGIN)
    {
        // New path found!
        PM_HitTeleport ();
        PM_NewNode (self.pos2);
        self.pos2 = VEC_ORIGIN;
        return;
    }

    // Path from pet to master is blocked.  If dragon has extra search time,
    // fly straight ahead in hopes the goal may be found soon.  Otherwise,
    // use Id's movetogoal to follow walls and wander.
    if (self.search_time < time)
        PM_PetWander (self.speed, self.petofs, self.master.origin_z);
    else if (!walkmove (self.angles_y, self.speed))
        self.search_time = time;
};

//----------------------------------------------------/ New Code /--------//
//  This causes the pet dragon to fly straight ahead toward its master.
//  The dragon will also move around minor obstacles that partially
//  block the path.
//------------------------------------------------------------------------//
float() PM_GotoMaster =
{
    // Direct line from dragon to master is intact.  Remove nodes, and
    // remember where the master is now in case he disappears later.
    PM_RemoveNode (self);
    self.pos1 = self.origin;
    self.pos2 = self.master.origin;
    self.search_time = time + 3;

    // Dragon tries to follow its master.  If its path is blocked,
    // it will fly up or down to overcome walls and/or follow walls.
    local   float   delta;
    local   float   shift;

    delta = vlen(self.master.origin - self.origin);

    if (delta > 60)
    {
        // Set the dragon's speed.
        if (delta > 120)
        {
            shift = self.speed;
        }
        else if (PM_IsBurning (self))
        {
            // Don't get too close to master and set him on fire!
            self.stalled = time + 1;
            return TRUE;
        }
        else
        {
            shift = DRAGON_MINSPEED;
        }

        // Try to approach the master.
        return PM_PetMoveToGoal (shift);
    }

    // Dragon is near it's master.
    self.stalled = time + 1;
    self.petofs  = OFFSET_LEVEL;
    return TRUE;
};


//==========================================================================
//  Food Foraging

//----------------------------------------------------/ New Code /--------//
//  This heals the dragon and removes the devoured food.
//------------------------------------------------------------------------//
void(entity food) PM_PetEatFood =
{
    local   float   points;

    // Boost life.
    points = self.health + food.count;
    if (points > self.max_health)
    {
        // Will have extra health leftover.
        self.health = self.max_health;
        points = points - self.max_health;

        // If Draco, pump the extra health to fix its natural armor.
        if (self == self.master.draco)
            PM_DragonAddArmor (self, points);
    }
    else
    {
        self.health = points;
    }

    // Do the eating effects.
    if (food.style)
    {
        // The big crunch!
        // NOTE:  Sound was originally 'demon/dhit2.wav'.
        sound (self, CHAN_ITEM, "dragon/eathead.wav", 1, ATTN_NORM);

        // Throw some meat chunks.
        local   float   gibs;
        local   vector  vec;

        gibs = 3;
        while (gibs > 0)
        {
            vec_x = 200 * (random() - 0.5);
            vec_y = 200 * (random() - 0.5);
            vec_z = 0;
            SpawnMeatSpray (food.origin, vec);
            gibs = gibs - 1;
        }
    }
    else
    {
        // NOTE:  Sound was originally 'items/r_item1.wav'.
        sound (self, CHAN_ITEM, "dragon/eat.wav", 1, ATTN_NORM);
    }

    // Consume food.
    food.solid      = SOLID_NOT;
    food.deathtype  = "eaten";
    food.nextthink  = 0.1;
    food.think      = SUB_Remove;
};

//----------------------------------------------------/ New Code /--------//
//  This tells the dragon to seek out and eat food.
//------------------------------------------------------------------------//
void(entity food) PM_GotoPetFood =
{
    local   float   dist;

    dist = vlen(food.origin - self.origin);
    if (dist <= REACH_EAT)
    {
        // Dragon is close enough to touch and eat the food.
        PM_PetEatFood (food);
        return;
    }

    local   float   shift;

    // Determine how fast the dragon should approach the food.
    shift = PM_PetGoalSpeed (dist);

    // As long as the dragon seeks food, keep search time current.
    if (self.search_time < time)
        self.search_time = time;

    // Go for it.
    self.goalentity = food;
    if (PM_PetMoveToGoal (shift))
        self.ideal_yaw = vectoyaw(food.origin - self.origin);
    else
        self.ideal_yaw = vectoyaw(self.origin - food.origin);
    ChangeYaw ();
    PM_SeekLevel (self.petofs, food.origin_z);
};

//----------------------------------------------------/ New Code /--------//
//  This checks if the dragon is hungry.
//------------------------------------------------------------------------//
float() PM_PetHungry =
{
    // Always eat if wounded.
    if (self.health < self.max_health)
        return TRUE;

    // Eating is the only way Draco can repair his armor.
    if (self == self.master.draco)
        if (self.armorvalue < PM_DragonMaxArmor (self))
            return TRUE;

    // Has full life and armor, so no need to eat.
    return FALSE;
};

//----------------------------------------------------/ New Code /--------//
//  This checks if the entity found is food that a dragon can reach and
//  eat without trouble.
//------------------------------------------------------------------------//
float(entity food, float dist) PM_IsGoodFood =
{
    if (food.deathtype != "food")
        return FALSE;

    if (dist <= REACH_EAT)
        return TRUE;    // Close enough to eat it.

    if (food.nextthink == -1)
        return FALSE;   // Don't risk getting stuck trying to reach heads.

    // Food's mins_z is 0; dragon's mins_z is -24.  Offset that plus
    // an extra 8 in case food is resting on sloping ground.
    if (PM_EntInWall (self, food.origin + '0 0 32'))
        return FALSE;   // Probably cannot reach on its own.

    // Go for it.
    return TRUE;
};


//===========================/  END OF FILE  /===========================//

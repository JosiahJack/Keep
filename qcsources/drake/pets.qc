//==========================================================================
//  MONSTER PETS
//==========================================================================

//==========================================================================
//  Monster Removal

//------------------------------------------------------------------------//
//  This kills all summoned minions a player has.
//------------------------------------------------------------------------//
void() Pets_Kill =
{
    local   entity  head;

    head = nextent(world);
    while (head)
    {
        if (head.master == self)
            if (head.spawned)
                KillIt (head, self);
        head = nextent(head);
    }
};

//------------------------------------------------------------------------//
//  This turns all summoned minions a player has into the enemy.
//------------------------------------------------------------------------//
void() Pets_Mad =
{
    local   entity  head;
    local   float   turned;

    turned = 0;
    head = nextent (world);
    while (head)
    {
        if (head.spawned)   // Doesn't work on free-willed allies.
        if (head.master == self)
        if ((head.health > 0) && !head.deadflag)
        {
            head.enemy      = head.master;
            head.master     = world;    // Sever bond to master.
            head.nextthink  = 0.01;
            head.think      = FoundTarget;

            // Alignment stuff changes allegiance permanently.
            // Not really needed, just done for fun.
            head.spawnflags = head.spawnflags - (head.spawnflags & SPAWN_WHITE);
            Align_Remove (head);        // Remove from good guys.
            Align_Add (head, FALSE);    // Add to bad guys.

            turned = turned + 1;
        }
        head = nextent (head);
    }
    if (turned)
        sprint (self, "Your minions turned against you!\n");
};

//------------------------------------------------------------------------//
//  This removes the bond between a master and all of its slaves.
//
//  Usually called by clients when logging in/out.
//  Occasionally used by monsters who can spawn other monsters.
//------------------------------------------------------------------------//
void(entity parent) Pets_Free =
{
    local   entity  head;

    head = nextent(world);
    while (head)
    {
        if (head.master == parent)
        {
            if (head.spawned && !(head.xfl & XFL_ADD_TO_KILL))
                KillIt (head, parent);
            else
                head.master = world;
        }
        head = nextent(head);
    }
};


//==========================================================================
//  Monster Commands

//------------------------------------------------------------------------//
//  Checks if a targ can be seen within a client's field-of-vision (FOV).
//  Assumes FOV is 90.
//
//  Similar concept to infront, but for clients.
//------------------------------------------------------------------------//
float(entity targ) inview =
{
    local   vector  vec;

    // Can if view to target is blocked or not by walls and the like.
    // Note:  Because this is called in a loop to check all entities,
    //  do this instead of 'CanDamage' for performance reasons.
    traceline (self.origin+self.view_ofs, targ.origin+targ.view_ofs, TRUE, self);
    if (trace_fraction < 1)
        return FALSE;

    makevectors (self.v_angle);
    vec = normalize (targ.origin - self.origin);
    return ((v_forward * vec) > 0.7071);    // Is dot product 45 deg or less?
};

//------------------------------------------------------------------------//
//  Checks if a given monster is able to obey a command.
//------------------------------------------------------------------------//
float(entity head) MonCom_Accepted =
{
    if (head.master == self)
        if (head.enemy != self)
            if (head.flags & FL_MONSTER)
                if (inview (head))
                    return TRUE;
    return FALSE;
};

//------------------------------------------------------------------------//
//  This gives all friendly monsters in sight a command to obey.
//
//  Stay   : Tells monster to stay.
//  Follow : Tells monster to follow.
//  Patrol : Tells monster to walk idlely toward a spot chosen by master.
//  Calm   : Tells monster not to attack enemy on sight.
//  Fight  : Monster may attack enemy on sight.
//------------------------------------------------------------------------//
void(float plus) MonsterCommand =
{
    local   float   minus;
    local   entity  head;
    local   vector  vec;

    if (plus == RYU_ALERT)
    {   sprint (self, "Fight\n");
        plus = 0;
        minus = RYU_CALM;
    }
    else if (plus == RYU_CALM)
    {   sprint (self, "Hold\n");
        minus = 0;
    }
    else if (plus == RYU_PATROL)
    {   sprint (self, "Go\n");
//        if (!self.form_active)
//            sound (self, CHAN_VOICE, "enforcer/sight3.wav", 1, ATTN_NORM);
        minus = RYU_STAY;
    }
    else if (plus == RYU_STAY)
    {   sprint (self, "Stay\n");
//        if (!self.form_active)
//            sound (self, CHAN_VOICE, "enforcer/sight1.wav", 1, ATTN_NORM);
        minus = RYU_PATROL;
    }
    else
    {   sprint (self, "Follow\n");
//        if (!self.form_active)
//            sound (self, CHAN_VOICE, "enforcer/sight3.wav", 1, ATTN_NORM);
        plus = 0;
        minus = RYU_STAY | RYU_PATROL;
    }

    makevectors (self.v_angle);
    vec = self.origin + '0 0 16';
    traceline (vec, vec + v_forward*2048, TRUE, self);
    vec = trace_endpos;

    head = nextent (world);
    while (head)
    {
        if (MonCom_Accepted (head))
        {
            if (plus == RYU_PATROL)
                head.ideal_yaw = vectoyaw (vec - head.origin);
            else if (plus == RYU_CALM)
                head.enemy = head.oldenemy = world;
            head.ryuflags = (head.ryuflags | plus) - (head.ryuflags & minus);
        }
        head = nextent (head);
    }
};


//==========================================================================
//  Impulses

//------------------------------------------------------------------------//
//  This gives all friendly monsters in sight a command to obey.
//
//  Stay   : Tells monster to stay.
//  Follow : Tells monster to follow.
//  Patrol : Tells monster to walk idlely toward a spot chosen by master.
//  Calm   : Tells monster not to attack enemy on sight.
//  Fight  : Monster may attack enemy on sight.
//------------------------------------------------------------------------//
void() Impulse_Monster =
{
// Allow these commands.
    if (self.impulse == 51)
        MonsterCommand (RYU_STAY);
    else if (self.impulse == 52)
        MonsterCommand (0);     // Follow!
    else if (self.impulse == 53)
        MonsterCommand (RYU_PATROL);
    else if (self.impulse == 54)
        MonsterCommand (RYU_CALM);
    else if (self.impulse == 55)
        MonsterCommand (RYU_ALERT);   // Remove pacifist.
//    else if (!(deathmatch || coop))
    {
        if (self.impulse == 56)
            Pets_Mad ();
        else if (self.impulse == 57)
            Pets_Kill ();
    }
};


//===========================/  END OF FILE  /===========================//

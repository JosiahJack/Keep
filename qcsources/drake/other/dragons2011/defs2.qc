// defs2.qc

// Engine stuff.
.float      alpha;      // Used by ice shards.
.float      gravity;    // Used by aim code.
//- - - - - - - - -

// Combo flag values.
float   FLx_NOT_MISSILE     =  296;     // Client + Monster + Item
float   FLx_NOT_FALLING     =  515;     // Fly + Swim + Onground

.float(float yaw, float dist)   th_move;    // 'walkmove' or equivalent.
.void(float dist)   th_goal;    // 'movetogoal' or equivalent.

.float  h2olevel;           // 'waterlevel' without the C code baggage.
.float  h2otype;            // Ditto, except for 'watertype'.

.float      ryuflags;   // AI flags for monsters.

.float  shots_max, shots_left;      // Affects attacks.

// Dragon flags (NOTE:  could be used for other monsters...)
float   RYU_ELEMENTS    = 3;        // Bits: 1+2+4
    float   RYU_USE_FIRE    = 0;
    float   RYU_USE_ACID    = 1;
    float   RYU_USE_LITE    = 2;
    float   RYU_USE_ICE     = 3;
float   RYU_BOMB        = 4;
// Bits 8, 16, and 32 are unused.
float   RYU_ALERT       = 64;       // Has better awareness and reflexes.
float   RYU_CRANKED     = 128;      // Stronger, and may use special attacks.
float   RYU_NO_WATER    = 256;      // Hates and avoids water.
float   RYU_PATH        = 1048576;  // Stay on path, for DoE dragon.


// Functions.

// DRAGONS /- - - -
float   SQRT2  = 1.4142;    // The square root of 2.

// Checks if enemy is within melee range.  def_range is defined melee range.
// Assumes self has an enemy and can damage said enemy.
float(float def_range) InMeleeRange =
{
    local   float   dist;

    dist = vlen(self.enemy.origin - self.origin);
    if (dist > def_range)
        if ( dist > ((self.maxs_x + self.enemy.maxs_x) * SQRT2 + 10) )
            return FALSE;

    return TRUE;    // Within range.
};

// Checks if entity 'e' is a missile.
float(entity e) IsMissile =
{
    if (!(e.flags & FLx_NOT_MISSILE))
    {
        if (e.solid == SOLID_BBOX)
        {
            if (e.touch)
                if (e.touch != SUB_Null)
                    if (e.touch != SUB_Remove)
                        return TRUE;
        }
        else if (e.solid == SOLID_TRIGGER)
        {
            if (e.classname == "fireball")  // Lavaball check.
                return TRUE;
        }
    }
    return FALSE;
};

//  This makes an entity do a think function right now.
void(entity ent, void() thinkst) SUB_Think =
{
    local   entity  swap;

    swap = self;
    self = ent;
    thinkst ();
    self = swap;
};

// Speaks for itself.
vector(entity e) Midpoint = {return e.origin + (e.mins + e.maxs)*0.5;};


//===========================/  END OF FILE  /===========================//

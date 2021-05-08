//==========================================================================
//  Light Zero

// Custom addition by PM.  Used by storm code, most of it in 'cool.qc'.
//
// Since much of the level is lit up using lightstyle 0, changing it
// will make much of the level brighter or darker.  Useful for lightning
// storm effects.

float   lightzero_finished;
float   lightzero_level;
float   lightzero_rate;

float   LIGHT_ZERO          = 0;    // Lightstyle 0.
float   LIGHTZERO_NORMAL    = 12;   // Use for light "m".
float   LIGHTZERO_MIN       = 4;    // Minimum light when storming.
float   LIGHTZERO_MAX       = 25;   // Maximum light allowed.

// Calls 'lightstyle(0, <foo>)'.
void() LightZero_Update =
{
//    dprint(ftos(lightzero_level)); dprint("\n");
    lightzero_level = floor (lightzero_level);
    if (lightzero_level < 5)
    {
        if (lightzero_level < 1)
            lightstyle(LIGHT_ZERO, "a");
        else if (lightzero_level == 1)
            lightstyle(LIGHT_ZERO, "b");
        else if (lightzero_level == 2)
            lightstyle(LIGHT_ZERO, "c");
        else if (lightzero_level == 3)
            lightstyle(LIGHT_ZERO, "d");
        else //if (lightzero_level == 4)
            lightstyle(LIGHT_ZERO, "e");
    }
    else if (lightzero_level < 10)
    {
        if (lightzero_level == 5)
            lightstyle(LIGHT_ZERO, "f");
        else if (lightzero_level == 6)
            lightstyle(LIGHT_ZERO, "g");
        else if (lightzero_level == 7)
            lightstyle(LIGHT_ZERO, "h");
        else if (lightzero_level == 8)
            lightstyle(LIGHT_ZERO, "i");
        else //if (lightzero_level == 9)
            lightstyle(LIGHT_ZERO, "j");
    }
    else if (lightzero_level < 15)
    {
        if (lightzero_level == 10)
            lightstyle(LIGHT_ZERO, "k");
        else if (lightzero_level == 11)
            lightstyle(LIGHT_ZERO, "l");
        else if (lightzero_level == 12)
            lightstyle(LIGHT_ZERO, "m");
        else if (lightzero_level == 13)
            lightstyle(LIGHT_ZERO, "n");
        else //if (lightzero_level == 14)
            lightstyle(LIGHT_ZERO, "o");
    }
    else if (lightzero_level < 20)
    {
        if (lightzero_level == 15)
            lightstyle(LIGHT_ZERO, "p");
        else if (lightzero_level == 16)
            lightstyle(LIGHT_ZERO, "q");
        else if (lightzero_level == 17)
            lightstyle(LIGHT_ZERO, "r");
        else if (lightzero_level == 18)
            lightstyle(LIGHT_ZERO, "s");
        else //if (lightzero_level == 19)
            lightstyle(LIGHT_ZERO, "t");
    }
    else
    {
        if (lightzero_level == 20)
            lightstyle(LIGHT_ZERO, "u");
        else if (lightzero_level == 21)
            lightstyle(LIGHT_ZERO, "v");
        else if (lightzero_level == 22)
            lightstyle(LIGHT_ZERO, "w");
        else if (lightzero_level == 23)
            lightstyle(LIGHT_ZERO, "x");
        else if (lightzero_level == 24)
            lightstyle(LIGHT_ZERO, "y");
        else //if (lightzero_level == 25)
            lightstyle(LIGHT_ZERO, "z");
    }
};

void() LightZero_Go =
{
    if (!lightzero_finished)
        return;

    if (lightzero_finished > time)
    {
        lightzero_level = lightzero_level + lightzero_rate;
        if (lightzero_level < LIGHTZERO_MIN)
            lightzero_level = LIGHTZERO_MIN;
        else if (lightzero_level > LIGHTZERO_MAX)
            lightzero_level = LIGHTZERO_MAX;
    }
    else
    {   // Restore normal lighting.
        if (lightzero_level > LIGHTZERO_NORMAL)
        {   // Was brighter.
            lightzero_level = lightzero_level - 4;
            if (lightzero_level < LIGHTZERO_NORMAL)
                lightzero_level = LIGHTZERO_NORMAL;
        }
        else if (lightzero_level < LIGHTZERO_NORMAL)
        {   // Was darker.
            lightzero_level = lightzero_level + 2;
            if (lightzero_level > LIGHTZERO_NORMAL)
                lightzero_level = LIGHTZERO_NORMAL;
        }
        if (lightzero_level == LIGHTZERO_NORMAL)
            lightzero_finished = 0;     // End it!
    }

    LightZero_Update ();
};

void(float lite, float add, float rate) LightZero_Set =
{
    lightzero_rate = rate;
    if (lite == -1)
    {
        if (lightzero_finished)
            lite = lightzero_level;
        else
            lite = LIGHTZERO_NORMAL;
    }
    add = time + add;
    if (lightzero_finished < add)
        lightzero_finished = add;
    if (lightzero_level != lite)
    {
        lightzero_level = lite;
        LightZero_Update ();
    }
};


//===========================/  END OF FILE  /===========================//

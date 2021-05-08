//==========================================================================
//  dice.qc -- by Patrick Martin                Last updated:  9-26-1999
//--------------------------------------------------------------------------
//  This file contains code that simulates the rolling of dice.
//==========================================================================


//==========================================================================
//  Saving Throws

//----------------------------------------------------/ New Code /--------//
//  This simulates the rolling of a 20-sided die.  The die is then
//  compared to a given value.  If the die is greater than or equal to
//  the given value, the saving throw is made.
//------------------------------------------------------------------------//
float(float save) PM_SavingThrow =
{
    save = floor (save);

    // A natural '1' always fails.  A natural '20' always succeeds.
    if (save < 2)
        save = 2;
    else if (save > 20)
        save = 20;

    local   float   points;

    points = random() * 20;
    points = ceil(points);
    if (points < 1)
        points = 1;

    if (points < save)
        return FALSE;   // Failed saving throw.

    // Success!
    return TRUE;
};


//==========================================================================
//  Generic Dice

//----------------------------------------------------/ New Code /--------//
//  This simulates the rolling of a die.  A possible bonus is
//  added to the die total and the grand total is returned.
//
//  Total points = 1d('die') + 'base'.  (This is D&D notation.)
//------------------------------------------------------------------------//
float(float die, float base) PM_RollDie =
{
    if (die <= 0)
        return base;

    local   float   points;

    // Roll the die.
    points = random() * die;
    points = ceil(points);
    if (points < 1)
        points = 1;

    // Add base damage.
    points = points + base;

    return points;
};

//----------------------------------------------------/ New Code /--------//
//  This simulates the rolling of some dice.  A possible bonus is
//  added to the die total and the grand total is returned.
//
//  Total points = 'no_of_dice'd('die') + 'base'.  (This is D&D notation.)
//------------------------------------------------------------------------//
float(float no_of_dice, float die, float base) PM_RollDice =
{
    local   float   points;
    local   float   total;

    total = 0;
    if ((no_of_dice > 0) && (die > 0))
    {
        while (no_of_dice > 0)
        {
            // Roll the die.
            points = random() * die;
            points = ceil(points);
            if (points < 1)
                points = 1;

            total = total + points;
            no_of_dice = no_of_dice - 1;
        }
    }

    // Add base damage.
    total = total + base;

    return total;
};

//----------------------------------------------------/ New Code /--------//
//  This rolls dice and multiplies the result before adding a
//  final bonus.
//------------------------------------------------------------------------//
float(float multiplier, float no_of_dice, float die, float base,
    float bonus) PM_MultiDiceBonus =
{
    local   float   points;

    points = PM_RollDice (no_of_dice, die, base);
    points = multiplier * points + bonus;

    return points;
};


//===========================/  END OF FILE  /===========================//

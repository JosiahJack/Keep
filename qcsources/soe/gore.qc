//==========================================================================
//  gore.qc -- by Patrick Martin                Last updated:  4-10-2001
//--------------------------------------------------------------------------
//  This file contains code enhanced versions of the original
//  ThrowHead and ThrowGib functions.
//
//  All the gibs have their .deathtype labeled as "food".
//  This is so the dragons (and the modified bloodcube) can find and
//  eat the gibs.  .classname is not used because severed heads need it.
//  In addition, .deathtype is used only by players who die from falling,
//  and player heads are ignored.  Therefore, .deathtype is safe to use.
//==========================================================================

// Prototypes in other files.
vector(float dm) VelocityForDamage;
float() crandom;

// void(entity gib) PM_FeedCube;   // For modified Zerstorer's bloodcube.


//==========================================================================
//  Enhanced Gore Functions

//----------------------------------------------------/ New Code /--------//
//  Similar to the original ThrowHead and ThrowGib functions except for
//  the extra parameters.
//------------------------------------------------------------------------//
void(entity head, string gibname, float dm, float gibskin, float gibframe)
    PM_ThrowAnyHead =
{
    setmodel (head, gibname);
    head.frame      = gibframe;
    head.nextthink  = -1;
    head.movetype   = MOVETYPE_BOUNCE;
    head.takedamage = DAMAGE_NO;
    head.solid      = SOLID_NOT;
    if (head.classname != "player")
    {
        // FIXME:  Is changing the head's solid to trigger safe?
        // Make the head a trigger solid so the dragon can find and eat it.
        // Don't change classname because it breaks the obituaries.
        head.solid      = SOLID_TRIGGER;
        head.deathtype  = "food";
        head.count      = 25;    // Gives 25 health if consumed.
        head.style      = 1;     // Alternate eating effects.
    }
    head.view_ofs   = '0 0 8';
    setsize (head, '-16 -16 0', '16 16 56');
    head.velocity   = VelocityForDamage (dm);
    head.origin_z   = head.origin_z - 24;
    head.flags      = head.flags - (head.flags & FL_ONGROUND);
    head.avelocity  = crandom() * '0 600 0';
    head.skin       = gibskin;

    // Don't send head to cube immediately -- the fields are needed
    // for other things, such as properly triggering events.
};

//----------------------------------------------------/ New Code /--------//
//  Similar to the original ThrowHead and ThrowGib functions except for
//  the extra parameters.
//------------------------------------------------------------------------//
void(entity head, string gibname, float dm, float gibskin, float gibframe)
    PM_ThrowAnyGib =
{
    local   entity  new;

    new = spawn();
    setmodel (new, gibname);
    setsize (new, '0 0 0', '0 0 0');
    setorigin (new, head.origin);
    new.velocity    = VelocityForDamage (dm);
    new.movetype    = MOVETYPE_BOUNCE;
    new.solid       = SOLID_TRIGGER;    // So 'findradius' will detect this.
    new.deathtype   = "food";           // So dragon will seek out and eat.
    new.count       = 15;               // Gives 15 health if consumed.
    new.style       = 0;                // Normal eating effects.
    new.avelocity_x = random()*600;
    new.avelocity_y = random()*600;
    new.avelocity_z = random()*600;
    new.think       = SUB_Remove;
    new.ltime       = time;
    new.nextthink   = time + 10 + random()*10;
    new.frame       = gibframe;
    new.flags       = 0;
    new.skin        = gibskin;

    // If gibs came from a zombie that was created by a nightshade,
    // make them disappear sooner.
    if (head.master)
        if (head.classname == "monster_zombie")
            new.nextthink   = time + 2 + random()*2;

    // FIXME:  Send it to the bloodcube if there is one.
//    PM_FeedCube (new);
};


//===========================/  END OF FILE  /===========================//

//==========================================================================
//  GIBS
//
//  Yes, put gibs here because they are potential health items.
//==========================================================================

// Checks if 'self' is near the ceiling.
float() Gib_NearCeiling =
{
    local   vector  add, vec;

    add = '0 0 56';     // 32 + 24
    vec = self.origin;
    traceline (vec, vec + add, TRUE, self);
    if (trace_fraction < 1)
        return TRUE;
    if (pointcontents (vec + add) == CONTENT_SKY)
        return TRUE;    // Since sky tends to be flat, make one check for it.
    vec = self.origin + '16 16 0';
    traceline (vec, vec + add, TRUE, self);
    if (trace_fraction < 1)
        return TRUE;
    vec = self.origin + '-16 16 0';
    traceline (vec, vec + add, TRUE, self);
    if (trace_fraction < 1)
        return TRUE;
    vec = self.origin + '-16 -16 0';
    traceline (vec, vec + add, TRUE, self);
    if (trace_fraction < 1)
        return TRUE;
    vec = self.origin + '16 -16 0';
    traceline (vec, vec + add, TRUE, self);
    if (trace_fraction < 1)
        return TRUE;
    return FALSE;
};

// Checks if gib should be eaten.  TRUE = yes.
float() Gib_Eaten =
{
    if (other.health <= 0)
        return 0;   // Dead.
    if (!(other.xfl & XFL_GHOUL))
        return 0;   // Can't eat gibs.
    if (self.healamount < 1)
        return 0;   // Gib has no food value.

    local   float   leave;

    leave = 1;
    if (other.form_active)
    {   // Note:  Morphed clients use armorvalue as health.
        if (T_Repair (other, self.healamount, FALSE))   // armor
            leave = 0;
    }
    else
    {
        if (T_Heal (other, self.healamount, FALSE))     // health
            leave = 0;
    }

    if (other.xfl & XFL_HUNGRY == 0)
    {
        if (leave)
            return 0;
    }
    // ELSE... It's hungry, eat it anyway!
//- - - - - - - - -
// FIXME:  Experimental code for vomitus.
//    if (other.enemy == self)
//        {other.enemy = world;  other.gorging = FALSE;}
//- - - - - - - - -

// Do the eating effects.
    if (self.tronyn)
    {   // The big crunch when eating a head!
        if (powcache & PCH_EAT_GIB)
            sound (other, CHAN_ITEM, "cube/bc_gulp.wav", 1, ATTN_NORM);

        // Throw some meat chunks.
        local   float   gibs;
        local   vector  vec;

        gibs = 3;
        while (gibs > 0)
        {
            vec_x = 200 * (random() - 0.5);
            vec_y = 200 * (random() - 0.5);
            vec_z = 0;
            SpawnMeatSpray (self.origin, vec, self.bloodtype);
            gibs = gibs - 1;
        }

        // Removing head now can wreck links.  Do it next frame.
        Burn_Null (self);
        self.solid      = SOLID_NOT;
        self.touch      = SUB_Null;
        self.use        = SUB_Null;
        self.targetname = world.null_string;
        if (self.th_spawn)
        {   // Hide it!
            self.modelindex = 0;
        }
        else
        {   // Remove!
            self.nextthink  = 0.01;
            self.think      = SUB_Remove;
        }
    }
    else
    {
        if (powcache & PCH_EAT_GIB)
            sound (other, CHAN_ITEM, "cube/bc_attck.wav", 1, ATTN_NORM);
        remove (self);
    }

    Safe_stuffcmd (other, "bf\n");
    return 1;
};

// Called when the gib is touched by something.
void() Gib_Touch =
{
    if (Gib_Eaten ())   // This may remove self if TRUE.
        return;
    if (!self.volume)
        return;

// Rest of the code here should be used only by gibs spawned by a fountain.
	if (self.velocity == '0 0 0')
	{
		self.avelocity = '0 0 0';
        self.attack_finished = 0;   // Prevent any more plopping.
        self.nextthink = time + 2 + random()*6;
		return;
	}

    if (self.volume < time)
        if (pointcontents(self.origin) == CONTENT_EMPTY)
    {   // Bounce sound
        sound (self, CHAN_AUTO, "gibfnt/gf_plop.wav", 1, ATTN_NORM);
        self.volume = time + 0.3;
    }
};

void() Gib_Burn =
{
    self.lefty = !self.lefty;
    if (self.lefty)
        {if (!VecInWater (self.origin))  MakeFlame (self);}
    else
        MakeSmoke (self.origin, 5);

    self.alpha = self.alpha - 0.05;
    if (self.alpha <= 0.001)
        remove (self);
    else
        self.nextthink = time + 0.1;
};

void() Gib_Melt =
{
    if (self.frame >= 3)
        {remove (self);  return;}
    self.frame = self.frame + 1;
    self.alpha = self.alpha - 0.1;
    self.nextthink = time + self.lefty + random()*self.lefty;
};

//- - - - - - - - -
// This is the all-purpose function for spawning a gib.
// All references to the entity self were eliminated here.
//
// -- Arguments --
// org      = Point where the gib spawns.
// gibname  = Filename used by gib entity.
// vel      = Velocity of the gib.
// spin     = Angle velocity or spin speed of the gib.
// gibskin  = Speaks for itself, used by Qtest Dragons.
// gibframe = Ditto.
// heal     = Gib can be eaten if TRUE.
// fast     = Make gib disappear faster if TRUE.
//- - - - - - - - -
void(vector org, string gibname, vector vel, vector spin, float gibskin,
    float gibframe, float heal, float fast)  Gib_Spawn =
{
    local   entity  new;

    new = spawn();
    setorigin (new, org);
    setmodel (new, gibname);
    setsize (new, '0 0 0', '0 0 0');

    new.velocity    = vel;
    new.movetype    = MOVETYPE_BOUNCE;
    new.solid       = SOLID_NOT;
    if (heal)
    {
        new.solid       = SOLID_TRIGGER;    // So 'findradius' detects this.
        new.healamount  = 5;                // Gives health if consumed.
        new.tronyn      = 0;                // Normal eating effects.
        new.flags       = FL_ITEM;          // Make it easier to pick up.
        new.touch       = Gib_Touch;
    }
    new.xf2         = XF2_QUAKE;
    new.volume      = 0;
    new.avelocity   = spin;
    new.think       = SUB_Remove;
    new.ltime       = time;
    if (fast)
    {
        if (fast == -1)
        {   // Blood fountain gib.
            new.volume      = time;
            new.nextthink   = time + 6;
        }
        else if (fast == -2)
        {   // Burning gib.
            heal = 0;   // Bloodcube can't eat meat on fire.
            new.nextthink   = time + 0.1;
            new.think       = Gib_Burn;
            new.alpha       = 1;
        }
        else
            new.nextthink   = time + 2 + random()*2;
    }
    else if (gibname == "progs/ice_cube.mdl")
    {   // FIXME:  Messy -- rewrite ice hack to something cleaner.
        if (fast)
            new.lefty       = 0.5;
        else
            new.lefty       = 2.5;
        new.nextthink   = time + new.lefty + random()*new.lefty;
        new.think       = Gib_Melt;
        new.alpha       = 1;
        new.frame       = 0;
    }
    else
        new.nextthink   = time + 10 + random()*10;
    new.frame       = gibframe;
    new.skin        = gibskin;
    new.flags       = 0;

    if (heal)
        Gib_FeedCube (new);
};

//- - - - - - - - -
// Temporary touch function for heads.
void() Head_Touch =
{
    if (self.tronyn)     // Confirm it's a head.
        if (Gib_Eaten ())   // Head will be removed at next tic if TRUE.
            Pets_Free (self);
};

// Removes heads after a delay if necessary.
void() Head_SetThink =
{
    // Set cleanup time if necessary.
    if (self.spawned)
    {   // Remove summoned critters quickly to make room for more.
        self.nextthink  = time + 4 + random()*4;
        self.think      = SUB_Remove;
    }
    else if (M_RespawnCheck ())
    {
        M_RespawnNextthink (0);
    }
    else
    {
        if (corpse_removal)
        {   self.nextthink  = time + 20 + random()*10;
            self.think      = SUB_Remove;
        }
        else
        {   self.nextthink  = -1;
            self.think      = SUB_Null;
        }
    }
};

// Delayed function for heads.
void() Head_Think =
{
    Head_SetThink ();
    if (self.flags & FL_MONSTER)
        Pets_Free (self);   // Make sure this isn't done during T_Damage.
    if (self.touch == Head_Touch)
    {   // Pets_Free was done here, but moved up in case of inedible head.
        self.touch = Gib_Touch;
    }
};
//- - - - - - - - -

//- - - - - - - - -
// This is the all-purpose function for turning self into a head gib.
//
// Arguments here are used in the same manner as in Gib_Spawn.
//- - - - - - - - -
void(string gibname, vector vel, vector spin, float gibskin, float gibframe,
    float heal)  Gib_Head =
{
    local   float   lo;

    lo = self.mins_z;   // Usually -24.  Higher for spiders.

    setmodel (self, gibname);
    self.frame      = gibframe;
    self.skin       = gibskin;
    if (self.classname == "player")
    {   // Never remove a client's head!
        heal = 0;   // Don't let cannibals eat the head either!
        self.nextthink  = -1;
        self.think      = SUB_Null;
    }
    else
    {
        if (self.deadflag < DEAD_DEAD)
            self.deadflag = DEAD_DEAD;
        if (self.flags & FL_MONSTER)
        {   // We can't release pets now because that may cause T_Damage loop.
            // We must delay pet release for another frame so we don't crash.
            self.nextthink = 0.01;
            self.think     = Head_Think;
            monster_item_drop ();   // Update 9/4/09:  Check for special drop.
        }
        else
            Head_SetThink ();
    }
    self.movetype   = MOVETYPE_BOUNCE;
    self.takedamage = DAMAGE_NO;
    self.solid      = SOLID_NOT;
    if (heal)
    {
        // FIXME:  Is changing the head's solid to trigger safe?
        // Make the head a trigger solid so others can find and eat it.
        self.volume     = 0;
        self.solid      = SOLID_TRIGGER;
        self.healamount = 5;    // Gives health if consumed.
        // Can't use .style, which is used as secondary spawnflags.
        // FIXME:  Use something other than .tronyn.
        self.tronyn     = 1;    // Alternate eating effects.  Was .style.
        // Monsters cannot use Gib_Touch until after pets are released.
        if (self.flags & FL_MONSTER)
            self.touch      = Head_Touch;
        else
            self.touch      = Gib_Touch;
        // NOTE:  No need to set FL_ITEM to heads.
    }
    self.view_ofs   = '0 0 8';
// I am not fond of the head moved at self's feet, but I see it done
// that way because of Quake's infernal way of moving and clip entities
// against bsps.  Namely Quake uses only three bbox sizes to clip entities.
// Note:  Assumes self has a size at least as big as VEC_HULL_xxx.
    setsize (self, '-16 -16 0', '16 16 56');
    self.velocity   = vel;
    if (Gib_NearCeiling ())     // Don't move head unless necessary.
        self.origin_z   = self.origin_z + lo;
    self.flags      = self.flags - (self.flags & FL_ONGROUND);
    self.avelocity  = spin;
    self.volume     = 0;    // So head won't plop on contact.

// Now gibbed, so change to a null function to stop the possibility
// of multiple gibbings.  Update:  And stop resurrection.
// (Note:  Should've been done in combat.qc but just in case it hasn't...)
    self.th_gib     =
    self.th_revive  = world.null_func;
    self.gorging    = TRUE;     // Don't let gremlin eat the head.

    // Don't send head to cube immediately -- the fields are needed for
    // other things, such as properly triggering events.
};


//==========================================================================
//  Standard Gib Stuff

// Standard Quake progs spawned all of a creature's gibs from a
// single point.  Thus, ThrowHead must be called before ThrowGib.
//
// In this mod, gibs can be spawned anywhere within the lower half
// of a creature, similar to what Quake2 does (although that game
// used the entire creature size).  With the modified gib code,
// ThrowHead should be called last.

vector(float dm) VelocityForDamage =
{
    local   vector  v;

    v_x = 100 * crandom();
    v_y = 100 * crandom();
    v_z = 200 + 100 * random();

    if (dm > -50)
        v = v * 0.7;
    else if (dm > -100)                     // Quake uses 2, Q2 uses 1.2.
        v = v * (fabs(dm) * 0.016 + 0.4);   // 1.2 at -50, 2 at -100.
    else if (dm > -200)
        v = v * 2;
    else
        v = v * 10;

    return v;
};

// All-purpose support function for throwing gibs, rubble, etc.
void(string gibname, float dm, float gibflags) ThrowIt =
{
    local   float   gibskin, gibframe, heal, fast;
    local   vector  org, vel, spin;

    heal = gibflags & GIB_EAT;
    gibskin = gibframe = 0;
    if (gibflags & GIB_SKIN_MATCH)
        gibskin = self.skin;

// Calculate gib velocity.
    if (gibflags & GIB_DMV)
    {   // Add some of the damage velocity to the gib.
        // Full speed is too fast, so use 25-50%.
        vel = damage_velocity * 0.25;   // FIXME:  Make sure dmv is defined.
        if (vel_z < 0)
            vel_z = 0;   // Gibs always go up.
        vel = vel + VelocityForDamage (dm);
    }
    else
        vel = VelocityForDamage (dm);

// Check if it is a head or normal gib.
    if (gibflags & GIB_HEAD)
    {
        if (self.maxs_x > 96)
            heal = FALSE;       // Too big to eat.
        gibskin = self.skin;
        spin = crandom() * '0 600 0';
        Gib_Head (gibname, vel, spin, gibskin, gibframe, heal);
        return;     // We are done here.
    }

// Find the spawn point for the gib.
    if (gibflags & (GIB_BODY_HALF | GIB_BODY_FULL))
    {
        spin = self.size * 0.5;
        org = Midpoint (self);
        org_x = org_x + crandom() * spin_x;
        org_y = org_y + crandom() * spin_y;
        if (gibflags & GIB_BODY_FULL)
            org_z = org_z + crandom() * spin_z;
        else
            org_z = org_z - random() * spin_z;  // Use only the lower half.
    }
    else
        org = self.origin;

// Calculate gib spin (angle velocity).
    spin_x = random()*600;
    spin_y = random()*600;
    spin_z = random()*600;

// Got all the info, so call the gib spawning function.
    if (gibflags & GIB_BURN)
        fast = -2;
    else
        fast = self.spawned;
    Gib_Spawn (org, gibname, vel, spin, gibskin, gibframe, heal, fast);
};

void(string gibname, float dm) ThrowJunk =  // This throws an inedible gib.
    { ThrowIt (gibname, dm, 0); };
void(string gibname, float dm) ThrowGib =
    { ThrowIt (gibname, dm, GIBx_GIB); };
void(string gibname, float dm) ThrowHead =
    { ThrowIt (gibname, dm, GIBx_GIB|GIB_HEAD); };
void(string gibname, float dm) ThrowArmaGib =   // For Armagon.
    { ThrowIt (gibname, dm, GIB_EAT); };

// SoE:  For shootable trees.
void(string gibname) ThrowTreeChunks =
    { ThrowIt (gibname, self.health, GIB_BODY_FULL); };

// This spawns a gib from the blood fountain.
// Taken from Zerstorer and adapted to Drake.
void(string gibname, vector av) FtGib =
{
    local   vector  vel;

    vel_x  = (random() * 100) - 50;
    vel_y  = (random() * 100) - 50;
    vel_z  = self.speed + (random() * 200);
    Gib_Spawn (self.origin, gibname, vel, av, 0, 0, TRUE, -1);
};


//==========================================================================
//  Ice

// If TRUE, self explodes into ice chunks, one of which is a head gib.
float() Shattered =
{
    local   float   loop;

    if (self.deathtype != "frozen")
        return FALSE;

// Since this is called during T_Damage, don't invoke more damage calls here.
// In other words, don't call T_RadiusDamage for colateral damage.
    sound (self, CHAN_VOICE, "weapons/shatter.wav", 1, ATTN_NORM);
    Rocket_Explosion2 (self.origin, 32, 16);
    // Icy shockwave here would be over-the-top, so don't make one.
    MakeIcyExp (self.origin);

    loop = 2;
    while (loop > 0)
        {ThrowJunk ("progs/ice_cube.mdl", self.health);  loop = loop - 1;}
    self.skin = 0;
    ThrowIt ("progs/ice_cube.mdl", self.health, GIB_HEAD);
    return TRUE;
};

// Okay, this has nothing to do with ice.
// This should return TRUE if the monster died from holy damage.
// Nothing causes holy damage at the moment (though Mjolnir should).
//float() Dispelled =
//{
//    return FALSE;
//};


//==========================================================================
//  SoE Specialities

void(float loop) ThrowRocks =
{
    local   float   gibskin, gibframe;
    local   vector  org, vel, spin, mid_pt, half_size;

    mid_pt = Midpoint (self);
    half_size = self.size * 0.5;

    while (loop > 0)
    {
        loop = loop - 1;

        gibskin = 0;
        gibframe = loop & 3;
        vel = VelocityForDamage (-100);

        org = mid_pt;
        org_x = org_x + crandom() * half_size_x;
        org_y = org_y + crandom() * half_size_y;
        org_z = org_z + crandom() * half_size_z;

        // Calculate gib spin (angle velocity).
        spin_x = random()*600;
        spin_y = random()*600;
        spin_z = random()*600;

        Gib_Spawn (org, "progs/imp_rock.mdl", vel, spin, gibskin, gibframe, FALSE, TRUE);
    }
    sound (self, CHAN_AUTO, "misc/wallbrk.wav", 1, ATTN_NORM);
};

void(vector org, vector av, string text) meat_spawn =
{
    local   entity  meat;

    meat = spawn();
    meat.movetype   = MOVETYPE_BOUNCE;
    meat.solid      = SOLID_TRIGGER;    //SOLID_BBOX;
    meat.takedamage = DAMAGE_NO;        //DAMAGE_AIM;
    meat.touch      = SUB_Null;
    meat.velocity_x = meat.velocity_y = 0;
    meat.velocity_z = random() * 50;
    meat.avelocity  = av;
    meat.classname  = "gib";
    meat.think      = SUB_Null;
//    meat.health     = 10;
//    meat.th_die     = meat_die;

    setmodel (meat, text);
    if (av_x || av_z)
        setsize (meat, '0 0 0', '0 0 0');
    else
        setsize (meat, '-16 -16 0', '16 16 56');    // Assume head.
    setorigin (meat, org);

// Make gibs more like Drake's.
    meat.healamount = 5;
    if (meat.maxs)
        meat.tronyn = 1;
    else
    {
        meat.tronyn = 0;
        meat.flags  = FL_ITEM;
    }
    meat.touch      = Gib_Touch;
};

void() misc_meat =
{
    local   vector  av;

    precache_model ("progs/h_zombie.mdl");

    av = crandom() * '0 600 0';     // Was '150 350 225'.
    meat_spawn (self.origin + '-10 -20 5', '500 10 200', "progs/gib1.mdl");
    meat_spawn (self.origin + '10 20 5', '200 100 300', "progs/gib2.mdl");
    meat_spawn (self.origin + '20 5 5', '100 300 200', "progs/gib3.mdl");
    meat_spawn (self.origin + '2 2 5', av, "progs/h_zombie.mdl");
    remove (self);
};


//===========================/  END OF FILE  /===========================//

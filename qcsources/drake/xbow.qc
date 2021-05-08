//==========================================================================
//
//  BURIZA-DO KYANON
//
//==========================================================================

//- - - - - - - - -
// Buriza-Do Kyanon is an artifact crossbow based on the unique "ballista"
// from Diablo 2 Lord of Destruction.  The Buriza in Diablo 2 featured
// unusually high damage that was typed cold and physical, and shots that
// always pierced and froze most enemies on a hit.  Most enemies that died
// shattered into ice cubes.
//
// Here, the shots will always pierce, and they will one-hit kill most
// targets struck.  This is also similar to the super shot powerup in
// the games Gauntlet 2 and Gauntlet Legends.
//- - - - - - - - -

// Called when an arrow hits something.
void() Buriza_Touch =
{
    if (pointcontents(self.origin) == CONTENT_SKY)
        {remove (self); return;}
    if (Reflected ())
        return;

    if (other)
    {
        self.owner = other;     // So arrow may pass through target.

        if (other == self.fallen)
            return;     // Do not hit this target.
        if (other == self.oldenemy)
            return;     // Do not retouch the same target twice in a row.

        if (other.xfl & XFL_BOSS)
        {   // Originally did 25%+18 hp, but that was not interesting.
            // T_NewDamage (other, self, self.master, 25, self.style|DF_PERCENT|DF_NO_ARMOR, self.classname);
            // T_NewDamage (other, self, self.master, 18, self.style, self.classname);

            // Knock off some hp, and slow for 5 seconds.
            // Hit for 100 damage like in Heretic (ToP firemace vs. bosses).
            T_NewDamage (other, self, self.master, 100, self.style, self.classname);
            T_Slow (other, self.master, 5);

            // FIXME:  Should there be a hit effect?
            // 10/28/10:  My efforts look worse than none at all.
            // Defer for later, if ever.
        }
        else
        {   // One-hit instakill!  Ignores invulnerability.
            T_Kill (other, self, self.master, -50, self.classname);
        }

        if (other.solid != SOLID_BSP)
            {self.oldenemy = other;  return;}   // Pierce the target.
    // Arrow will shatter, so set owner to the world so that targets
    // hiding behind 'other' aren't hit by T_RadiusDamage.
        self.owner = world;
    }

// Explode on impact on a solid surface.
    self.touch = SUB_Null;      // Stack overflow prevention.
    T_NewRadiusDamage (self, self.master, 60, world, self.style, self.classname);
    self.origin = self.origin - 8*normalize(self.velocity);
    // Don't spawn shockwaves like the dragons' iceballs.
    sound (self, CHAN_AUTO, "weapons/icewall.wav", 1, ATTN_NORM);
    // Formerly 'Tent_Explosion2 (self.origin, 32, 16);'.
    Particle_Explosion (self.origin, '9 33 4', '15 41 3');
    BecomeIcyExp ();
};

void() Buriza_Think =
{
    if (self.delay <= time)
        {remove (self); return;}

    self.nextthink = time + 0.05;

//    self.speed   = vlen (self.velocity);
//    self.movedir = self.dest = normalize (self.velocity);
    self.flags = self.flags - (self.flags & FL_ONGROUND);
    self.velocity = self.dest;
    self.movedir = normalize (self.dest);
    self.angles  = vectoangles(self.movedir);
    Meteor_Trail (41, 1, FALSE);

// DISABLED -- No free lunch against ghosts.
//    Ghost_Touch ();
};

void(vector start, vector dir) Buriza_Launch =
{
    newmis = spawn ();
    newmis.master       = newmis.owner        = self;
    newmis.movetype     = MOVETYPE_FLYMISSILE;
    newmis.solid        = SOLID_BBOX;
    newmis.classname    = "Buriza";
// set missile speed
    newmis.movedir      = dir;
    newmis.speed        = SPEED_BURIZA;
    newmis.dest         = newmis.velocity     = dir * newmis.speed;
    newmis.avelocity    = '0 0 0';
    newmis.avelocity_z  = newmis.speed;     // Makes arrow model spiral.
    newmis.angles       = vectoangles(newmis.velocity);
// set missile damage
    // Don't need 'newmis.dmg'.
    newmis.style        = DF_SAFE | DF_COLD;
    newmis.cnt          = 41;
//    newmis.effects      = newmis.effects | EF_DIMLIGHT;
    newmis.oldorigin    = start;
    newmis.frame        = 1;
    newmis.skin         = ARROW_ICE;
    newmis.oldenemy     =
    newmis.enemy        = world;
    newmis.fallen       = self;     // Second owner, used by reflection.
// set missile duration
    newmis.touch        = Buriza_Touch;
    newmis.delay        = time + 10;    // Give it long range.
    newmis.nextthink    = 0.01;
    newmis.think        = Buriza_Think;

    setall (newmis, "progs/arrow.mdl", '0 0 0', '0 0 0', start);
};

void() W_FireCrossbow =
{
    if (self.ammo_super < 1)
        return;

    self.currentammo = self.ammo_super = self.ammo_super - 1;
    // Sound played in animation code, not here.
    self.punchangle_x = -2;

    local   vector  start, dir, vx, vy;

    makevectors (self.v_angle);
    start = self.origin + v_forward*8 + '0 0 16';
    dir = v_forward;    // No auto-aim please.
    vx = v_forward * 0.9848;    // cos(10)
    vy = v_right * 0.1736;      // sin(10)

    Buriza_Launch (start, dir);
    if (self.tome_finished)
    {   // ToP: Shoot two more to the sides for free.
        Buriza_Launch (start, vx + vy);
        Buriza_Launch (start, vx - vy);
    }
};


//===========================/  END OF FILE  /===========================//

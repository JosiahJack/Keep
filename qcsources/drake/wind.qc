//==========================================================================
//  Tornado -- Used by the wind baron.

// Sucks in targets near the cone, and damages those already in it.
void() Tornado_Attack =
{
    local   entity  head;
    local   vector  delta, spot, vel;
    local   float   hit;

// Note:  Walls offer no protection against the baron's tornado.
    head = findradius (self.origin, 256);
    while (head)
    {
        if (head != self)
        if (head != self.master)
        if (head.origin_z + head.maxs_z >= self.origin_z)   // Head must be above spawnpoint.
        {
            // Get horizontal distance between target and center.
            spot = head.origin;  spot_z = self.origin_z;
            delta = self.origin - spot;     // delta_z should be 0.

            // First, inflict some damage.
            hit = (vlen(delta) < 100);
            if (hit)
                T_NewDamage (head, self, self.master, self.dmg, DF_NO_KNOCK, self.classname);

            // Next, suck the target into the vortex if possible.
            if ( ((head.flags & FLx_CREATURE) && (head.mass && (head.mass <= MASS_HEAVY)))
            || (head.xfl & XFL_WIND) )
            {
                if (hit || (head.flags & FL_MONSTER))
                {   // Sweep the target off its feet.
                    if (!hit)
                        if (head.flags & FL_ONGROUND)
                            if (head.velocity_z < 80)
                                head.velocity_z = 80;
                    // Walkers lose control of movement.
                    head.flags = head.flags - (head.flags & FL_ONGROUND);
                }

                vel = head.velocity;
                vel_x = vel_x * 0.5;
                vel_y = vel_y * 0.5;
                if (hit)
                {
                    vel_z = vel_z * 0.5;
                    if (vel_z < 150)
                        vel_z = 150;    // Float up and away.
                }
                head.velocity = vel + normalize(delta) * 100;
            }
        }

        head = head.chain;
    }
};

// Thinking for the smoke particles in the tornado.
void() tornado2 =[ 0, tornado2 ]
{
    if (self.delay <= time)
    {
        remove (self);
        return;
    }

    local   vector  spot, trig, dir;

    self.speed = self.speed + 8;
    self.height = self.height + 24;
    self.cnt = anglemod (self.cnt + 47);
    spot = self.oldorigin;
    spot_z = spot_z + self.height;
    trig = CoSine (self.cnt);
    dir = (('1 0 0' * self.speed) * trig_x) + (('0 1 0' * self.speed) * trig_y);
    spot = spot + dir;

    setorigin (self, spot);
};

// Think function for the tornado.  Spawns all of its effects.
void() tornado1 =[ 0, tornado1 ]
{
    if (self.delay <= time)
    {
        super_active = FALSE;
//        StopSound (self, 6);
        remove (self);
        return;
    }

// FIXME:  Use different sound that loops?
    if (self.t_width < time)
    {
        self.t_width = time + 1;
        sound (self, CHAN_AUTO, "baron/tornado.wav", 1, ATTN_NORM);
    }

    Tornado_Attack ();

    self.height = (self.height + 3) & 7;
    self.cnt = anglemod(self.cnt + 107);

    newmis = spawn();
    newmis.owner      = self;
    newmis.movetype   = MOVETYPE_NOCLIP;
    newmis.solid      = SOLID_NOT;
    newmis.velocity   = '0 0 0';
    newmis.nextthink  = 0.01;
    newmis.delay      = time + 1.2;     // FIXME:  Use T+1?
    if (newmis.delay > self.delay)
        newmis.delay      = self.delay;     // Last no longer than parent.
    newmis.think      = tornado2;
    newmis.cnt        = self.cnt + self.height;
    newmis.oldorigin  = self.origin;
    setall (newmis, "progs/smoke.mdl", '0 0 0', '0 0 0', self.origin);
};

// Spawns an immobile tornado that sucks in and damages targets.
void(vector start) Tornado_Spawn =
{
    if (super_active)
        return;     // Uses many edicts and particles, only one at a time.

    traceline (start, start - '0 0 256', TRUE, self);
    if (trace_fraction == 1)
        return;     // No ground.

    start = trace_endpos + '0 0 2';
    super_active = TRUE;    // Only one big effect at a time please.

    local   entity  wind;

// Spawn the tornado.
    wind = spawn ();
    wind.owner        = world;
    wind.master       = self;
    wind.movetype     = MOVETYPE_NONE;    // Immobile.  No MOVETYPE_FLY.
    wind.solid        = SOLID_NOT;
    wind.classname    = "tornado";
// set missile speed
    wind.velocity     = '0 0 0';
// set missile damage
    wind.dmg          = 2;      // 20/sec * 5 sec = 100.
// set miscellaneous
    wind.takedamage   = DAMAGE_NO;
// set missile duration
    wind.touch        = SUB_Null;
    wind.frame        = 0;
    wind.think        = tornado1;
    wind.nextthink    = time + 0.1;
    wind.delay        = time + 5;
    wind.t_width      = 0;

    setall (wind, "", '0 0 0', '0 0 0', start);

// Spawning effects.
    ShockWave (wind.origin + '0 0 4', RING_QUAKE, 4, "progs/s_wave.spr");
};


//===========================/  END OF FILE  /===========================//

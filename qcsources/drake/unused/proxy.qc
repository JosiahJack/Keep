// PM:  Separated from weapons.qc in case I want to remove the
//  proximity gun from Drake.

//======================================
//  Proxy Bombs
//======================================

//MED 10/31/96
// PM:  Assume that this globar var is set to zero at worldspawn.
//  (Yes, it is bad assumption.)
// Update 1/6/10:  Moved globals to global.qc.

// Spike Traps do not explode when removed.
void() SpikeTrap_Poof =
{
    if (pointcontents (self.origin) > CONTENT_SLIME)
        Tent_Point (TE_SUPERSPIKE, self.origin);
    remove (self);
};

//================
// ProximityGrenadeExplode
//================
void() ProxyBomb_Explode =
{
    NumProximityGrenades = NumProximityGrenades - 1;
    if (self.tome_finished)
        NumSpikeTraps = NumSpikeTraps - 1;

    self.takedamage = DAMAGE_NO;
// Cannot explode now because this may be called when killed by damage
// or when proxy bomb warns to explode, so delay the call.
    self.nextthink  = 0.01;
    if (self.tome_finished)
        self.think      = SpikeTrap_Poof;
    else
        self.think      = T_MissileExplode;
};

void() ProxyBomb_ExplodeNow = {ProxyBomb_Explode ();  self.think ();};

//================
// ProximityGrenadeTouch
//================
void() ProxyBomb_Touch =
{
    local   float   pc;
    local   string  sfx;

    pc = pointcontents (self.origin);
    if (pc == CONTENT_SKY)
    {   // PM:  Don't attach to the sky!
        NumProximityGrenades = NumProximityGrenades - 1;
        if (self.tome_finished)
            NumSpikeTraps = NumSpikeTraps - 1;
        remove (self);
        return;
    }
    if (pc == CONTENT_LAVA)     // Lava will destroy this.
        {self.enemy = other; ProxyBomb_ExplodeNow(); return;}

    if (Reflected_Damage (COURAGE_DAMAGE))
        return;     // PM:  Repelled.

    if (other.classname == self.classname)
        return;     // Ignore other proxy bombs.

    sfx = "weapons/bounce.wav";
    if (self.tome_finished)
    {   // Spike trap.
        if ((other.takedamage == DAMAGE_AIM) && (other.solid != SOLID_BSP))
        {
            if (other != self.fallen)
            {
                self.fallen = other;
                T_NewDamage (other, self, self.master, COURAGE_DAMAGE, DF_NONE, self.classname);
                sfx = "zombie/z_hit.wav";
            }
        }
        else if (vlen(other.velocity) > 0)
            {self.enemy = other; ProxyBomb_ExplodeNow(); return;}
    }
    else
    {   // Proxy bomb.
        if ((other.takedamage == DAMAGE_AIM) || (vlen(other.velocity) > 0))
            {self.enemy = other; ProxyBomb_ExplodeNow(); return;}
    }
    sound (self, CHAN_WEAPON, sfx, 1, ATTN_NORM); // bounce sound
    if (other.solid != SOLID_BSP)
        return;     // PM:  Don't stick to non-bsp surfaces.

// Freeze the bomb in place.
    self.movetype   = MOVETYPE_NONE;
    setsize (self, '-8 -8 -8', '8 8 8');
    self.state      = 1;
    self.movetarget = other;    // Was 'self.spawnmaster'.
    self.touch      = SUB_Null;
};

//================
// ProximityBomb
//================
void() ProxyBomb_Think =
{
    local   entity  head;
    local   float   blowup;

// Changed 'self.spawnmaster' to 'self.movetarget'.
    if ((time > self.delay) || (vlen(self.movetarget.velocity) > 0) )
        {ProxyBomb_ExplodeNow(); return;}

    // If too many bombs are in the level, remove this one if it is the oldest.
    if ((NumProximityGrenades > 15)
    || (self.tome_finished && (NumSpikeTraps > 5)))
    {   // Cycle through all traps, and if this is the oldest, remove it.
        blowup = self.delay;
        head = find (world, classname, self.classname);
        while (head)
        {
            if (head != self)
                if (head.delay < blowup)
                    blowup = head.delay;
            head = find (head, classname, self.classname);
        }
        if (blowup == self.delay)
            {ProxyBomb_ExplodeNow(); return;}
    }

    if (self.wait <= time)
    {
        self.owner      = world;
        self.takedamage = DAMAGE_YES;
        self.wait       = time + 0.25;
        // Blinking skins.
        if (self.skin & 1)
        {   // Was on so blink off.
            self.skin = self.skin - 1;
            self.cnt = 0;
        }
        else
        {
            self.cnt = self.cnt + 1;
            if (self.cnt & 3 == 0)
                self.skin = self.skin | 1;
        }

        if (pointcontents(self.origin) <= CONTENT_LAVA)
            {ProxyBomb_ExplodeNow(); return;}

        blowup = 0;
        head = findradius (self.origin, self.distance);
        if (self.tome_finished)
        {   // Spike trap.
            local   vector  dir;
        
            while (head)
            {
            // Check for living targets.
                if (head != self)
                if (head.health > 0)
                if (head.flags & FLx_CREATURE)
                if (!Ally_Check (head, self.master))
                {
                    dir = Midpoint (head);
                    dir = Aim_Lead (self.origin, dir, 1000, head);
                    traceline (self.origin, dir, TRUE, self);
                    if (trace_fraction == 1)
                    {
                        dir = normalize (dir - self.origin);
                        launch_superspike (self.origin, dir);
                        newmis.master = self.master;
                        newmis.deathtype = "trapspike";
        
                        self.currentammo = self.currentammo - 1;
                        blowup = blowup + 1;
                    // Limit was 3, but reduced to stop spam from stacked traps.
                        if ((self.currentammo < 1) || (blowup >= 2))
                            head = world;   // Stop!
                    }
                }
                head = head.chain;
            }
            if (blowup)
            {   // Spikes were launched.
                sound (self, CHAN_WEAPON, "weapons/spike2.wav", 1, ATTN_NORM);
                self.wait = time + 0.5;
                self.skin = self.skin | 1;
                if (self.currentammo < 1)
                    {ProxyBomb_ExplodeNow();  return;}
            }
        }
        else
        {   // Proximity bomb.
            while (head)
            {
            // Check for living targets.
                if (head != self)
                if (head.health > 0)
                if (head.flags & FLx_CREATURE)
                if (head.classname != self.classname)
                    blowup = 1;
            // Check for other proxy bombs.
                if (head.classname == self.classname)
                if (head.state==0)
                    blowup = 1;
            // Check the target is visible to the proxy bomb.
                traceline (self.origin, head.origin, TRUE, self);
                if (trace_fraction != 1.0)
                    blowup = 0;
            // Found something -- explode soon to hurt it.
                if (blowup) //==1)
                {
                    sound (self, CHAN_WEAPON, "hipweap/proxwarn.wav", 1, ATTN_NORM);
                    ProxyBomb_Explode();
                    self.nextthink = time + 0.5;
                    self.skin = self.skin | 1;
                    return;
                }
                head = head.chain;
            }
        }
    }

    self.nextthink = time + sys_ticrate;
};

//============
void(vector start, vector dir, vector add) ProxyBomb_Launch =
{
    NumProximityGrenades = NumProximityGrenades + 1;

    local   entity  missile;

    missile = spawn ();
    missile.master      = missile.owner     = self;
    missile.movetype    = MOVETYPE_TOSS;
    missile.solid       = SOLID_BBOX;
    missile.classname   = "proximity_grenade";
    missile.takedamage  = DAMAGE_NO;
    missile.health      = 5;
    missile.state       = 0;
    // PM:  More stuff for blinking skins.
    missile.skin        = 0;
    missile.cnt         = 3;

// set missile speed
    missile.speed       = 600;
    missile.velocity    = (dir * 600) + add;
    missile.avelocity   = '100 600 100';
    missile.angles      = vectoangles(missile.velocity);
    missile.touch       = ProxyBomb_Touch;

// set missile damage
    missile.dmg         = 95;
    missile.enemy       = world;
    missile.style       = DF_ROCKET;
    missile.xfl         = XFL_WIND;         // Same as grenades.
    missile.worldtype   = MDAM_GRENADE;     // Same as grenades.

// set missile duration
// Note:  Made duration '.delay' constant since the oldest bombs are removed
// when too many are spawned.
    missile.nextthink   = time + 2;
    missile.delay       = time + 30;    // Was 15 + (10*random());
    missile.wait        = 0;
    missile.think       = ProxyBomb_Think;
    missile.th_die      = ProxyBomb_Explode;

//- - - - - - - - -
    // Update:  Tome of Power.
    missile.tome_finished = self.tome_finished;
    if (missile.tome_finished)
    {
        NumSpikeTraps = NumSpikeTraps + 1;

        missile.skin        = 2;
        missile.distance    = 500;
        missile.currentammo = 20;   // 18*20 = 360 damage total.
        missile.classname   = "spike_trap";
    }
    else
        missile.distance = 140;
//- - - - - - - - -

// PM:  Changed size from '2 2 2' to '0 0 0', to fix weird bug of explosions
// hurting things behind a wall.
    setform (missile, "progs/proxbomb.mdl", '0 0 0', '0 0 0');
    setorigin (missile, start);

    newmis = missile;   // PM:  So properties can be altered later.
};

//================
// W_FireProximityGrenade
//================
void() W_FireProximityGrenade =
{
    if (self.ammo_rockets < 1)
        return;

    self.currentammo = self.ammo_rockets = self.ammo_rockets - 1;
// Update 12/4/09:  Replaced sound to reduce precache slots needed.
//    sound (self, CHAN_WEAPON, "hipweap/proxbomb.wav", 1, ATTN_NORM);
    sound (self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM);
    self.punchangle_x = -2;

    local   vector  start, vec;

    makevectors (self.v_angle);
    start = self.origin;    //+ v_forward*8 + v_right*12 + '0 0 12';
    vec = '0 0 200';
    if (self.v_angle_x)
        {vec = vec + crandom()*v_right*10; vec = vec + crandom()*v_up*10;}

    ProxyBomb_Launch (start, v_forward, vec);
};


//===========================/  END OF FILE  /===========================//

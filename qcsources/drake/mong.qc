// mong.qc -- Monster Guns.

//==========================================================================
//
//  Normal Weapons for Monsters
//
//==========================================================================

//==========================================================================
//  Misc.

float() M_Punked =
{
    if (self.punked)
    {   // Lost weapon self was using (because gremlin stole it).
        self.punked = FALSE;
        if (self.th_run)
            self.think = self.th_run;
        return TRUE;
    }
    return FALSE;
};

void() M_Lstart =
    {sound (self, CHAN_AUTO, "weapons/lstart.wav", 1, ATTN_NORM);};

void(void() thinkst) M_Break =
{
    if (self.enemy.health > 0)
        if (self.enemy.solid > SOLID_TRIGGER)
            if (visible (self.enemy))
                if (range (self.enemy) < RANGE_FAR)
                    return;

// Break attack sequence.
    if (!IsDead (self))
        self.think = thinkst;
};

void(float reload) M_Reload =
{
    reload = reload + time;
    if (self.attack_finished < reload)
        self.attack_finished = reload;
};


//==========================================================================
//  Shells

// FIXME:  Add Tome of Power effects.
// FIXME:  Add power armor support.

void(vector org, vector dir, entity targ, vector err, float npc, float super)
    M_FireShotgun =
{
    local   string  sfx;

    if (super)
    {
        sfx = "weapons/ssg.wav";    // Was "weapons/shotgn2.wav".
        if (self.ammo_shells < 2)
            super = FALSE;
    }
    else
    {   // Use old shotgun sound instead of old ssg sound because
        // flak ogres use ssg sound for their nail attack, and having
        // everyone use the same ssg sound for various attacks gets
        // monotonous.
        //
        // Remember, player gets upgraded shotguns in Drake.
        // Stock Quake1 shotguns suck hard!  Doom/Q2/Q3 have the right idea.
        if (npc)
            sfx = "weapons/guncock.wav";    // Wimpy grunt version.
        else
            sfx = "weapons/shotgn2.wav";    // Powerful PC version.
    }

    if (self.xfl & XFL_USE_AMMO)
    {
        if (super)
            self.currentammo = self.ammo_shells = self.ammo_shells - 2;
        else
        {
            if (self.ammo_shells < 1)
                return;     // No ammo.
            self.currentammo = self.ammo_shells = self.ammo_shells - 1;
        }
    }
    self.effects = self.effects | EF_MUZZLEFLASH;
    dir = Maim_Line (org, dir, 0, targ, err);
    self.v_angle = vectoangles(dir);
    sound (self, CHAN_WEAPON, sfx, 1, ATTN_NORM);
    if (super)
    {
        if (npc)
            FireBullets (10, dir, '0.175 0.1 0');   // Quoth Defender shoots 12.
        else
            FireBullets (14, dir, '0.14 0.08 0');
        M_Reload (0.7);
    }
    else
    {
        if (npc)
            FireBullets (4, dir, '0.1 0.1 0');      // Grunt strength
        else
            FireBullets (6, dir, '0.04 0.04 0');    // Player strength
        M_Reload (0.5);
    }
};

// Update 4/6/10:  Removed riotgun code.  Redundant with buffed shotguns.
// Update 6/2/11:  Removed autoshotgun code.


//==========================================================================
//  Nails

void(vector org, vector dir, entity targ, vector err, float super)
    M_FireNailgun =
{
    local   float   ammo;

    ammo = self.xfl & XFL_USE_AMMO;
    if (ammo)
    {
        if (self.ammo_nails < 1)
            return;     // No ammo.
    }

    self.effects = self.effects | EF_MUZZLEFLASH;
    if (super)
    {
        sound (self, CHAN_WEAPON, "weapons/spike2.wav", 1, ATTN_NORM);
        if (ammo)
        {
            if (self.ammo_nails < 2)
                {super = FALSE; self.currentammo = self.ammo_nails = 0;}
            else
                self.currentammo = self.ammo_nails = self.ammo_nails - 2;
        }
    }
    else
    {
        sound (self, CHAN_WEAPON, "weapons/rocket1i.wav", 1, ATTN_NORM);
        if (ammo)
            self.currentammo = self.ammo_nails = self.ammo_nails - 1;
    }
    dir = Maim_Line (org, dir, 1000, targ, err);
    if (super)
        launch_superspike (org, dir);
    else
        launch_spike (org, dir);

    M_Reload (0.2);
};

void() M_ChaingunNextthink =
{
//    self.nextthink = time + RATE_CHAINGUN1;
// Note:  In 35 fps Doom, delays in the loop were 4/4/1.  The third
// frame was the same as first, but not fullbright, and did a vis check.
    self.b0_click = !self.b0_click;     // Use client-only field for this.
    if (self.b0_click)
        Doom_NextThink (4);
    else
        Doom_NextThink (5);
};

void(vector org, vector dir, entity targ, vector err)
    M_FireChaingun =
{
    if (self.xfl & XFL_USE_AMMO)
    {
        if (self.ammo_nails < 1)
            return;     // No ammo.
        self.currentammo = self.ammo_nails = self.ammo_nails - 1;
    }
    self.effects = self.effects | EF_MUZZLEFLASH;
    sound (self, CHAN_WEAPON, "weapons/dsshotgn.wav", 1, ATTN_NORM);
    dir = Maim_Line (org, dir, 0, targ, err);
    // Chaingunners were lousy shots in Doom2, so use a wide spread.
    // Normal SSG spread should do nicely.  Also, Doom's damage is 1d3*5.
    // Note:  Yaw scatter should be crandom * 3.125.
    FireLead (1, 9, org, dir, '0.14 0.08 0', "chaingun");

    // Slow down thinking to give a rate-of-fire of Doom's chaingun zombie.
    M_ChaingunNextthink ();

    M_Reload (0.2);
};


//==========================================================================
//  Rockets

void(vector org, vector dir, entity targ, vector err, float npc, float drill)
    M_FireGrenade =
{
    local   vector  up;

    if (self.xfl & XFL_USE_AMMO)
    {
        if (self.ammo_rockets < 1)
            return;     // No ammo.
        self.currentammo = self.ammo_rockets = self.ammo_rockets - 1;
    }
    up = '0 0 200';
    self.effects = self.effects | EF_MUZZLEFLASH;
/* FIXME
    if (drill)
    {   dir = Maim_Grenade (org, dir, 800, up_z, targ, err);
        sound (self, CHAN_WEAPON, "hipweap/proxbomb.wav", 1, ATTN_NORM);
        DrillBomb_Launch (org, dir, up);
        if (npc)
            newmis.distance = 1;
    }
    else
*/
drill = 0;
    {   dir = Maim_Grenade (org, dir, 600, up_z, targ, err);
        sound (self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM);
        Grenade_Launch (org, dir, up);
    }
    if (npc)
    {
        if (cranked)
            newmis.dmg = 60;
        else
            newmis.dmg = 40;
    }

    M_Reload (0.6);
};

void(vector org, vector dir, entity targ, vector err, float npc)
    M_FireRocket =
{
    if (self.xfl & XFL_USE_AMMO)
    {
        if (self.ammo_rockets < 1)
            return;     // No ammo.
        self.currentammo = self.ammo_rockets = self.ammo_rockets - 1;
    }
    self.effects = self.effects | EF_MUZZLEFLASH;
    sound (self, CHAN_WEAPON, "weapons/sgun1.wav", 1, ATTN_NORM);
    dir = Maim_Line (org, dir, 1000, targ, err);
    Rocket_Launch (org, dir);
    if (npc)
    {
        if (cranked)
            newmis.dmg = 60;
        else
            newmis.dmg = 40;
    }

    M_Reload (0.8);
};

void(vector org, vector dir, entity targ, vector err, float npc)
    M_FireSidewinder =
{
    if (self.xfl & XFL_USE_AMMO)
    {
        if (self.ammo_rockets < 1)
            return;     // No ammo.
        self.currentammo = self.ammo_rockets = self.ammo_rockets - 1;
    }
    self.effects = self.effects | EF_MUZZLEFLASH;
    sound (self, CHAN_WEAPON, "weapons/stunfire.wav", 1, ATTN_NORM);
    dir = Maim_Line (org, dir, 500, targ, err);
    Sidewinder_Launch (org, dir, self.enemy);
    if (npc)
    {
        if (cranked)
            newmis.dmg  = 45;
        else
            newmis.dmg  = 30;
    }

    M_Reload (1);
};

// Designed for use by mega enforcer.
void(vector st) M_MeSidewinder =
{
    local   vector  org, dir;

    makevectors (self.angles);
    org = self.origin + v_forward*st_x + v_right*st_y + v_up*st_z;
    dir = Maim_Line (self.origin, self.enemy.origin, 0, world, '1.2060 2.4110 0');
    // Last vec emulates the following:
    // (v_up * ((random()*20) - 10)) + (v_right * ((random()*40) - 20))

    self.effects = self.effects | EF_MUZZLEFLASH;
    sound (self, CHAN_WEAPON, "me/me_fire2.wav", 1, ATTN_NORM);

    Sidewinder_Launch (org, dir, self.enemy);
    newmis.delay = time + 5;    // Original duration in Zerstorer.
    if (cranked)
        newmis.dmg  = 45;
    else
        newmis.dmg  = 30;
};

// Rocketter rocket attack.
void(vector org, vector dir) M_AccelRocket =
{
    local   float   damage;

    if (cranked)
        damage = 45;
    else
        damage = 30;
    self.effects = self.effects | EF_MUZZLEFLASH;
    sound (self, CHAN_WEAPON, "weapons/sgun1.wav", 1, ATTN_NORM);
    // This is a variable speed homing missile -- don't bother with leading.
    dir = Maim_Line (org, dir, 0, world, '0 0 0');
    AccelRocket_Launch (org, dir, self.enemy, damage);
};

void(vector org, vector dir, entity targ, vector err, float npc)
    M_FireMirv =
{
    local   float   cost;

    cost = COST_MIRV;
    if (npc)
        if (cost > 3)
            cost = 3;
    if (self.xfl & XFL_USE_AMMO)
    {
        if (self.ammo_rockets < cost)
            return;     // No ammo.
        self.currentammo = self.ammo_rockets = self.ammo_rockets - cost;
    }
    self.effects = self.effects | EF_MUZZLEFLASH;
    sound (self, CHAN_WEAPON, "weapons/mirv1.wav", 1, ATTN_NORM);
    dir = Maim_Line (org, dir, 500, targ, err);
    Mirv_Launch (org, dir);
    if (npc)
    {   // Use fewer and weaker warheads.
        newmis.count = 3;   // # of warheads.
        if (cranked)
        {   newmis.dmg = 105;   // MIRV damage.
            newmis.cnt = 60;    // warhead damage.
        }
        else
        {   newmis.dmg = 75;
            newmis.cnt = 40;
        }
    }

    M_Reload (1.5);
};


//==========================================================================
//  Cells

void(vector org, vector dir, entity targ, vector err, float npc, float cl)
    M_FireThunderbolt =
{
    local   float   damage;
    local   float   impossible;

    impossible = FALSE;
    if (self.ammo_cells < 1)
    {
        if (self.xfl & XFL_USE_AMMO)
            return;     // Out of juice.

        impossible = TRUE;
        self.ammo_cells = 1;    // Give some to work.
    }

// Check for discharge.
    if (self.h2olevel > 1)      // Uh-oh!  Electricity + water = BOOM!
    {
        damage = self.ammo_cells;
        if (npc)    // Reduce damage if a grunt did it.
            self.ammo_cells = ceil(self.ammo_cells / 2);
        Discharge (self);
        if (!IsDead (self))
        {   // Restore ammo if possible.  Should be done before damage though.
            if (!(self.xfl & XFL_USE_AMMO))
                self.ammo_cells = damage;   // Restore pre-discharge ammo.
            if (impossible)
                self.ammo_cells = 0;
        }
        return;
    }

// Define ammo cost.
    damage = 2;
    if (npc)
        damage = ceil(damage / 2);
// Pay ammo cost.
    if (self.xfl & XFL_USE_AMMO)
    {
        if (damage > self.ammo_cells)
            damage = self.ammo_cells;
        self.currentammo = self.ammo_cells = self.ammo_cells - damage;
    }
    else if (impossible)
        self.currentammo = self.ammo_cells = 0;
// Calculate damage.
    if (npc)
        damage = damage * 10;
    else
        damage = damage * 15;

// Fire!
    self.effects = self.effects | EF_MUZZLEFLASH;
    if (self.t_width < time)
    {
        sound (self, CHAN_WEAPON, "weapons/lhit.wav", 1, ATTN_NORM);
        self.t_width = time + 0.6;
    }
    dir = Maim_Line (org, dir, 0, targ, err);
    dir = org + dir*600;

    if (cl)
        BurstLit_Bolt (org, dir, self, damage, 500);
    else
        LightningBolt (org, dir, self, damage, self, TE_LIGHTNING2, "thunderbolt");

    M_Reload (0.2);
};

void(vector org, vector dir, entity targ, vector err, float lf)
    M_FireLaser =
{
    if (self.xfl & XFL_USE_AMMO)
    {
        if (self.ammo_cells < 1)
            return;     // No ammo.
        self.currentammo = self.ammo_cells = self.ammo_cells - 1;
    }
    self.effects = self.effects | EF_MUZZLEFLASH;
    dir = Maim_Line (org, dir, 1000, targ, err);
    if (lf & LFx_BLUE == LFx_BLUE)
    {   // Use custom needle model instead due to ports like qrack.
        sound (self, CHAN_WEAPON, "me/me_fire1.wav", 1, ATTN_NORM);
        Needle_Launch (org, dir, 3);
// DISABLED -- Mega enforcer's blaster shoots 3-way in Drake.
//        newmis.dmg = 20;
    }
    else
    {
//        if (lf & (LF_RED | LF_YELLOW))
//            sound (self, CHAN_WEAPON, "hipweap/laserg.wav", 1, ATTN_NORM);
//        else
//            sound (self, CHAN_WEAPON, "enforcer/enfire.wav", 1, ATTN_NORM);
        Sfx_LaserFire ();
        Laser_Launch (org, dir, lf);
    }

    M_Reload (0.1);
};

// Specialized version of M_FireLaser designed to emulate the Laser Cannon.
// Used by the ranger.
void(vector org, vector dir, entity targ, vector err, float mid)
    M_FireHipLC =
{
    local   float   ammo;

    ammo = self.xfl & XFL_USE_AMMO;
    if (ammo)
    {
        if (self.ammo_cells < 1)
            return;     // No ammo.
        self.currentammo = self.ammo_cells = self.ammo_cells - 1;
    }
    self.effects = self.effects | EF_MUZZLEFLASH;
    dir = Maim_Line (org, dir, 1000, targ, err);
    makevectors (self.angles);
    if (mid)
    {   // Center laser.
        org = org + v_up*4;
        HIP_LaunchLaser(org, dir, mid);
    }
    else
    {   // Shoot right and left lasers.
        org = org + v_right*2;
        HIP_LaunchLaser(org, dir, 0);
        if (!ammo || (self.ammo_cells > 1))
        {   // Fire second laser.
            org = org - v_right*4;
            HIP_LaunchLaser(org, dir, 0);
            if (ammo)
                self.currentammo = self.ammo_cells = self.ammo_cells - 1;
        }
    }
    M_Reload (0.1);
};

void(vector org, vector dir, entity targ, vector err, float npc)
    M_FirePlasma =
{
    local   float   damage;
    local   float   impossible;

    impossible = FALSE;
    if (self.ammo_cells < 1)
    {
        if (self.xfl & XFL_USE_AMMO)
            return;     // Out of juice.

        impossible = TRUE;
        self.ammo_cells = 1;    // Give some to work.
    }

// Check for discharge.
    if (self.h2olevel > 1)      // Uh-oh!  Electricity + water = BOOM!
    {
        damage = self.ammo_cells;
        if (npc)    // Reduce damage if a grunt did it.
            self.ammo_cells = ceil(self.ammo_cells / 2);
        Discharge (self);
        if (!IsDead (self))
        {   // Restore ammo if possible.  Should be done before damage though.
            if (!(self.xfl & XFL_USE_AMMO))
                self.ammo_cells = damage;   // Restore pre-discharge ammo.
            if (impossible)
                self.ammo_cells = 0;
        }
        return;
    }

// Define ammo cost.
    damage = 3;
// Pay ammo cost.
    if (self.xfl & XFL_USE_AMMO)
    {
        if (damage > self.ammo_cells)
            damage = self.ammo_cells;
        self.currentammo = self.ammo_cells = self.ammo_cells - damage;
    }
    else if (impossible)
        self.currentammo = self.ammo_cells = 0;
// Calculate damage.
    if (npc)
        damage = damage * 10;
    else
        damage = damage * 50 / 3;

// Fire!
    self.effects = self.effects | EF_MUZZLEFLASH;
    sound (self, CHAN_WEAPON, "weapons/plasma1.wav", 1, ATTN_NORM);
    dir = Maim_Line (org, dir, 1000, targ, err);
    Plasma_Launch (org, dir, 1000, damage, FALSE);
    if (self.classname == "monster_commando")
        newmis.style    = newmis.style | DF_SAFE;

    M_Reload (0.2);
};


//==========================================================================
//  Zapper Weapon

void(vector org, vector dir, entity targ, vector err)  M_FireZapper =
{
    local   float   charge;

    charge = self.baha_ammo;
    if (charge < 1)
        charge = 1;
    self.zapper_time =
    self.baha_ammo = 0;

    dir = Maim_Line (org, dir, 0, targ, err);
    sound (self, CHAN_WEAPON, "hknight/attack1.wav", 1, ATTN_NORM);
    if (charge < WAND_FULL)
        FireSparks (org, dir, charge);
    else
        FireBigSpark (org, dir);

    M_Reload (WAND_DELAY);
};


//==========================================================================
//  Super Shot

void(vector org, vector dir, entity targ, vector err)
    M_FireBuriza =
{
    if (self.xfl & XFL_USE_AMMO)
    {
        if (self.ammo_super < 1)
            return;     // No ammo.
        self.currentammo = self.ammo_super = self.ammo_super - 1;
    }
    sound (self, CHAN_WEAPON, "necro/att_a.wav", 1, ATTN_NORM);
    dir = Maim_Line (org, dir, SPEED_BURIZA, targ, err);
    Buriza_Launch (org, dir);

    M_Reload (2);
};


//=========================================================================
//  Monster Weapons

void(float gun, vector org, vector dir, entity targ, vector err, float npc)
    M_Attack =
{
    if (self.mirv1)
        Mirv_Use ();    // Activate missile before weapon launch.

    if (M_Punked ())
        return;

    if (gun & WARx_USES_CELLS)
    {
        if (gun == WAR_CHAIN_LIGHTNING)
            M_FireThunderbolt (org, dir, targ, err, npc, TRUE);
        else if (gun == WAR_THUNDERBOLT)
            M_FireThunderbolt (org, dir, targ, err, npc, FALSE);
        else if (gun == WAR_PLASMA_GUN)
            M_FirePlasma (org, dir, targ, err, npc);
        else if (gun & (WAR_LASER_CANNON | WAR_BLASTER))
        {
            // Change npc to laser flags.
            if (npc == 2)   // Assume mega-enforcer.
                npc = LFx_BLUE | LF_GLOW | LF_SPARKS;
            else if (npc)
                npc = LF_GLOW;
            else
                npc = LF_RED | LF_BOUNCE;
            M_FireLaser (org, dir, targ, err, npc);
        }
    }
    else if (gun & WARx_USES_ROCKETS)
    {
        if (gun == WAR_CRUISE_MISSILE)
            M_FireMirv (org, dir, targ, err, npc);
        else if (gun == WAR_ROCKET_LAUNCHER)
            M_FireRocket (org, dir, targ, err, npc);
        else if (gun == WAR_SIDEWINDER)
            M_FireSidewinder (org, dir, targ, err, npc);
        else if (gun == WAR_GRENADE_LAUNCHER)
            M_FireGrenade (org, dir, targ, err, npc, FALSE);
    }
    else if (gun & WARx_USES_NAILS)
    {
        M_FireNailgun (org, dir, targ, err, gun == WAR_SUPER_NAILGUN);
    }
    else if (gun & WARx_USES_SHELLS)
    {
        M_FireShotgun (org, dir, targ, err, npc, gun == WAR_SUPER_SHOTGUN);
    }
    else if (gun == WAR_ZAPPER)
    {
        M_FireZapper (org, dir, targ, err);
    }
    else if (gun == WAR_BURIZA)
    {
        M_FireBuriza (org, dir, targ, err);
    }
    else
    {   // FIXME:  Add axe.

        // No weapon found.  Abort attack.
        if (self.th_run)
            self.th_run ();
    }
};

void() M_Select =
{
    local   float   guns, dist, yes;
    local   float   free, ts, tn, tr, tc, t5;

    self.punked = FALSE;    // Updating held weapon...

    ts = self.ammo_shells;
    tn = self.ammo_nails;
    tr = self.ammo_rockets;
    tc = self.ammo_cells;
    t5 = self.ammo_super;

//- - - - - - - - -
// FTEqcc Note:  With the assignments op checked in fteqcc, this next
// statement causes 'free' to be true now, but not later in the function.
// I don't know what's going on that causes such aberrant behavior,
// but since I may have other similar statements elsewhere, I just turn
// assignments off.
//
// Update 6/2/10:  Disabled old way.  Maybe it breaks in 'fteqcc /O3'
// is because the old way sets free to a variable instead of a constant?
//- - - - - - - - -
//    free = !(self.xfl & XFL_USE_AMMO);
//- - - - - - - - -
// If you must have assignments, use this instead of the above.
// (Yes, I use this now because the progs is too big for older compilers.)
    if (!(self.xfl & XFL_USE_AMMO))
        free = TRUE;
    else
        free = FALSE;
//- - - - - - - - -
    if (free)
        self.ammo_shells=self.ammo_nails=self.ammo_rockets=self.ammo_cells=self.ammo_super=255;

    if (self.mirv1)
        Mirv_Use ();    // Activate missile before weapon change.

    dist = vlen(self.enemy.origin - self.origin);
    yes = TRUE;
    if (self.arsenal & WARx_SHAFT)
    {
        if (dist > 600)
        {   // Too far away to hit.
            guns = self.arsenal - (self.arsenal & WARx_SHAFT);
            if (guns)
            {
                local   float   temp;

                temp = self.arsenal;
                self.arsenal = guns;
                self.war = War_BestWeapon ();
                self.arsenal = temp;
                yes = FALSE;    // So we don't need to search the best again.
            }
        }
    }
    if (yes)
        self.war = War_BestWeapon ();

// FTEqcc Note:  'free' should not change between its definition above
// and here, yet it does if the assignments optimization is used.
// I cannot see how it would.  'free' isn't a reserved word in QuakeC.
    if (free)
    {   // Restore original ammo.
        self.ammo_shells = ts;
        self.ammo_nails = tn;
        self.ammo_rockets = tr;
        self.ammo_cells = tc;
        self.ammo_super = t5;
    }

    if (!self.war)
        return;     // No weapon available.
    if (!(self.war & WARx_USES_ROCKETS))   // Check for weapon override.
    {
        if (self.arsenal & WARx_USES_ROCKETS)
        {   // Has, but not selected, rockets.  Check for override.
            // 10% per rocket, 50% max.
            yes = 0.1 * self.ammo_rockets;
            if (yes > 0.5)
                yes = 0.5;
            if (random() < yes)
            {   // Override weapon with grenades.
                if ((dist > 300) && (self.arsenal & WAR_CRUISE_MISSILE))
                    self.war = WAR_CRUISE_MISSILE;
                else if (dist > 200)
                {
                    if (self.arsenal & WAR_ROCKET_LAUNCHER)
                        self.war = WAR_ROCKET_LAUNCHER;
                    else if (self.arsenal & WAR_GRENADE_LAUNCHER)
                        self.war = WAR_GRENADE_LAUNCHER;
                }
            }
        }
    }
// Reset currentammo.
    War_UpdateCurrentAmmo ();
};

// Select a gun for a weapon.  Used by soldier class monsters such as grunts.
// Prevents soldier from selecting axe or the like should he have such junk.
void() M_SelectGun =
{
    local   float   guns;

    guns = self.arsenal;
    self.arsenal = self.arsenal & WARx_AI_GUNS;
    M_Select ();    // Sets self.war to some weapon bit.
    self.arsenal = guns;
};


//===========================/  END OF FILE  /===========================//

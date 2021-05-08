//==========================================================================
//  PLAYER WEAPON USE
//==========================================================================

// Called by 'W_Attack' and various monster AI functions.
void() W_ShowHostile =
{
    SuperDamageSound ();    // Moved from 'W_WeaponFrame' to here.
    self.show_hostile = time + 1;   // wake monsters up
    self.attack_time = time;    // So imps know when to dodge.
};

// Called by 'W_Attack' only.
float() W_CheckNoAmmo =
{
    if (self.form_active)
    {   // Use fire breath instead of weapons while in dragon form.
        if (self.baha_click & 2)    // Check bit for now.
            return (self.baha_ammo >= COST_BAHA_BOMB);
        return self.baha_ammo;
    }
    if (self.war == WAR_MJOLNIR)
        if (self.hammer_finished)
            return FALSE;       // Hammer not in hand.
    if (self.war & WARx_WEAPON_FREE)
        return TRUE;    // Weapon does not need ammo.
    if (self.currentammo > 0)
        return TRUE;    // Has ammo.

// Not enough ammo for current weapon -- switch.
    War_FindBestWeapon ();
    return FALSE;
};

void(float reload) W_Reload =
{
// DISABLED -- No CTF runes in Drake.
//    if (self.tech == TECH_HASTE)
//        reload = reload / 2;
    self.attack_finished = time + reload;
};


//============
// W_Attack
//
// An attack impulse can be triggered now
//============
void() W_Attack =
{
    if (!W_CheckNoAmmo ())
        return;

// PM:  'makevectors' will be called in each individual weapon function,
// so no need to call it here when it will be called later.
//    makevectors (self.v_angle);     // calculate forward angle for velocity
    W_ShowHostile ();
    self.b0_click = 0;

// Check for morph override.
    if (self.form_active)
    {   // When morphed into a monster, use its attacks instead.
        baha_fire1 ();
        return;
    }
// Normal weapon procedures below...
// Use tree structure to lower checks needed for worst-case scenario.
    if (self.war & WARx_USES_CELLS)
    {
        if (self.war == WAR_CHAIN_LIGHTNING)
        {   // Quake cannot draw very many bolts, so rapid-fire like
            // normal Thunderbolt is a bad idea.
            // Update 11/20/09:  Use DoE plasma code with fewer bolts.
            //  We may be able to stay under limits (24 bolts).
            if (self.tome_finished)
            {
                player_snake1 ();
                W_FireDeathRay ();
                W_Reload (0.4);
            }
            else
            {
                player_light1();
                self.attack_finished = time + 0.1;
                sound (self, CHAN_AUTO, "weapons/lstart.wav", 1, ATTN_NORM);
            }
        }
        else if (self.war == WAR_THUNDERBOLT)
        {
            player_light1();
            self.attack_finished = time + 0.1;
            sound (self, CHAN_AUTO, "weapons/lstart.wav", 1, ATTN_NORM);
        }
        else if (self.war == WAR_PLASMA_GUN)
            player_plasma1();
        else if (self.war == WAR_LASER_CANNON)
            player_laser1();
        else if (self.war == WAR_BLASTER)
            player_blast1();
        else if (self.war == WAR_MJOLNIR)
        {
            if (self.ammo_cells < COST_MJOLNIR)
                player_hammer1();
            else
                player_mjolnir1();
            // Update 12/1/09:  Sped up to match axe damage rate.
            W_Reload (0.6);     // Was T+0.7.
        }
    }
    else if (self.war & WARx_USES_ROCKETS)
    {
        if (self.war == WAR_CRUISE_MISSILE)
        {
            player_bfg1 ();
            W_FireStinger ();
            W_Reload (1.5);
        }
        else if (self.war == WAR_ROCKET_LAUNCHER)
        {
            player_rocket1();
            W_FireRocket();
            if (self.tome_finished)
                W_Reload (0.6);
            else
                W_Reload (0.8);
        }
        else if (self.war == WAR_SIDEWINDER)
        {
            player_rocket1();
            if (self.tome_finished)
            {   W_FireHydra();
                W_Reload (1.5);
            }
            else
            {   W_FireSidewinder();
                W_Reload (1);
            }
        }
        else if (self.war == WAR_GRENADE_LAUNCHER)
        {
            player_rocket1();
            W_FireGrenade();
            if (self.tome_finished)
                W_Reload (1);
            else
                W_Reload (0.6);
        }
    }
    else if (self.war & WARx_USES_NAILS)
    {
        if (self.war & (WAR_NAILGUN | WAR_SUPER_NAILGUN))
            player_nail1 ();
    }
    else if (self.war & WARx_USES_SHELLS)
    {
        if (self.war == WAR_SUPER_SHOTGUN)
        {
            player_shot1 ();
            W_FireSSG ();
            if (self.perms & POW_SHOTTYMAN)
            {   // Shotty powerup quickens rate of fire.
                if (q1shot)
                {   // Original
                    if (self.tome_finished)
                        W_Reload (1.0);     // 224 DPS
                    else
                        W_Reload (0.5);     // 112 DPS
                }
                else
                {   // Drake buff
                    if (self.tome_finished)
                        W_Reload (0.8);     // 280 DPS
                    else
                        W_Reload (0.7);     // 154 DPS
                }
            }
            else
            {   // Normal speed.
                if (q1shot)
                {   // Original
                    if (self.tome_finished)
                        W_Reload (1.4);     // 160 dmg/sec.
                    else
                        W_Reload (0.7);     // 80 dmg/sec.
                }
                else
                {   // Drake buff
                    if (self.tome_finished)
                        W_Reload (1.2);     // 186.6 dmg/sec.
                    else
                        W_Reload (1);       // 108 dmg/sec.
                }
            }
        }
        else if (self.war == WAR_SHOTGUN)
        {
            player_shot1 ();
            W_FireShotgun ();
            if (self.perms & POW_SHOTTYMAN)
            {   // Shotty powerup quickens rate of fire.
                if (q1shot)
                {   // Original
                    if (self.tome_finished)
                        W_Reload (0.6);     // 160 DPS
                    else
                        W_Reload (0.3);     // 80 DPS
                }
                else
                {   // Drake
                    if (self.tome_finished)
                        W_Reload (0.6);     // 160 DPS
                    else
                        W_Reload (0.5);     // 88 DPS
                }
            }
            else
            {   // Normal speed.
                if (q1shot)
                {   // Original
                    if (self.tome_finished)
                        W_Reload (1);       // 96 dmg/sec.
                    else
                        W_Reload (0.5);     // 48 dmg/sec.
                }
                else
                {   // Drake
                    if (self.tome_finished)
                        W_Reload (0.8);     // 120 dmg/sec.
                    else
                        W_Reload (0.7);     // 60-62.8 dmg/sec.
                }
            }
        }
    }
    else    // The weapons below don't use standard ammo.
    {
        if (self.war == WAR_AXE)
        {
            player_axe ();      // Sets 'self.attack_finished'.
        }
        else if (self.war == WAR_CHAINSAW)
        {
            player_saw1 ();
            self.attack_finished = time + 0.55;
            sound (self, CHAN_AUTO, "weapons/sawatck.wav", 1, ATTN_NORM);
        }
        else if (self.war == WAR_ZAPPER)
        {
            player_wand1 ();    // Was player_shot1 ();
            W_FireSparks ();
            if (self.tome_finished)
                W_Reload (0.3);     // Heretic wand RoF
            else
                W_Reload (WAND_DELAY);
        }
        else if (self.war == WAR_BURIZA)
        {
            player_xbow1 ();
            self.attack_finished = time + 0.8;  // Minimum delay.
        }
        else if (self.war == WAR_GRAPPLE)
        {
            if (self.hook)
            {
                if (!self.hook.modelindex)
                {   // Assume hook was improperly removed, so reset links.
                    self.hook = world;  // So W_FireGrapple fires a hook.
                    player_grapple1 ();
                    return;
                }
                if (self.hook.count)
                    return;
                player_grapple3 ();
            }
            else
                player_grapple1 ();
            // Modified animation takes three frames to complete.
            self.attack_finished = time + 0.3;
        }
    }
};


//============
// W_ChangeWeapon
//============
void() W_ChangeWeapon =
{
    local   float   it, am, fl;

    it = self.arsenal & legalized;
    am = fl = 0;
    if (self.impulse <= 8)
    {
        if (self.impulse == 1)      // The melee weapon impulse.
        {
            // Order is:  Axe/chainsaw then Mjolnir.  Chainsaw replaces axe.
            fl = it & (WAR_GRAPPLE | WAR_AXE | WAR_CHAINSAW | WAR_MJOLNIR);
            if (fl)
            {
                if ((self.war == WAR_AXE) || (self.war == WAR_CHAINSAW))
                {
                    if (fl & WAR_MJOLNIR)
                        fl = WAR_MJOLNIR;
                    else if (fl & WAR_GRAPPLE)
                        fl = WAR_GRAPPLE;
                    else if (fl & WAR_CHAINSAW)
                        fl = WAR_CHAINSAW;
                    else
                        fl = WAR_AXE;
                }
                else if (self.war == WAR_MJOLNIR)
                {
                    if (fl & WAR_GRAPPLE)
                        fl = WAR_GRAPPLE;
                    else if (fl & WAR_CHAINSAW)
                        fl = WAR_CHAINSAW;
                    else if (fl & WAR_AXE)
                        fl = WAR_AXE;
                    else
                        fl = WAR_MJOLNIR;
                }
                else
                {
                    if (fl & WAR_CHAINSAW)
                        fl = WAR_CHAINSAW;
                    else if (fl & WAR_AXE)
                        fl = WAR_AXE;
                    else if (fl & WAR_MJOLNIR)
                        fl = WAR_MJOLNIR;
                    else if (fl & WAR_GRAPPLE)
                        fl = WAR_GRAPPLE;
                }
            }
/*
            fl = it & (WAR_AXE | WAR_CHAINSAW | WAR_MJOLNIR);
            if (fl)
            {
                if ((self.war == WAR_AXE) || (self.war == WAR_CHAINSAW))
                {
                    if (fl & WAR_MJOLNIR)
                        fl = WAR_MJOLNIR;
                    else if (fl & WAR_CHAINSAW)
                        fl = WAR_CHAINSAW;
                    else
                        fl = WAR_AXE;
                }
                else
                {
                    if (fl & WAR_CHAINSAW)
                        fl = WAR_CHAINSAW;
                    else if (fl & WAR_AXE)
                        fl = WAR_AXE;
                    else if (fl & WAR_MJOLNIR)
                        fl = WAR_MJOLNIR;
                }
            }
*/
        }
        else if (self.impulse == 2)
        {
            fl = it & (WAR_ZAPPER | WAR_SHOTGUN);
            if (fl)
            {
                if ( ((self.war == WAR_SHOTGUN)
                || (self.ammo_shells < 1)) && (fl & WAR_ZAPPER) )
                    fl = WAR_ZAPPER;
                else
                {
                    if (fl & WAR_SHOTGUN)
                        fl = WAR_SHOTGUN;
                    else if (fl & WAR_ZAPPER)
                        fl = WAR_ZAPPER;
                }
                if (fl & WARx_USES_SHELLS)
                    if (self.ammo_shells < 1)
                        am = 1;
            }
        }
        else if (self.impulse == 3)
        {
/*
            fl = it & (WAR_GRAPPLE | WAR_SUPER_SHOTGUN);
            if (fl)
            {
                if ( ((self.war == WAR_SUPER_SHOTGUN) || (self.ammo_shells < 1))
                && (fl & WAR_GRAPPLE) )
                    fl = WAR_GRAPPLE;
                else
                {
                    if (fl & WAR_SUPER_SHOTGUN)
                        fl = WAR_SUPER_SHOTGUN;
                    else if (fl & WAR_GRAPPLE)
                        fl = WAR_GRAPPLE;
                }
                if (fl & WARx_USES_SHELLS)
                    if (self.ammo_shells < 1)
                        am = 1;
            }
*/
            fl = it & WAR_SUPER_SHOTGUN;
            if (self.ammo_shells < 1)
                am = 1;
        }
        else if (self.impulse == 4)
        {
            fl = it & WAR_NAILGUN;
            if (self.ammo_nails < 1)
                am = 1;
        }
        else if (self.impulse == 5)
        {
            fl = it & (WAR_SUPER_NAILGUN | WAR_BLASTER | WAR_LASER_CANNON);
            if ( ((self.war == WAR_SUPER_NAILGUN) || (self.ammo_nails < 1))
            && (fl & (WAR_BLASTER | WAR_LASER_CANNON)) )
            {
                if (fl & WAR_LASER_CANNON)
                    fl = WAR_LASER_CANNON;
                else
                    fl = WAR_BLASTER;
            }
            else
            {
                if (fl & WAR_SUPER_NAILGUN)
                    fl = WAR_SUPER_NAILGUN;
                else if (fl & WAR_LASER_CANNON)
                    fl = WAR_LASER_CANNON;
                else if (fl & WAR_BLASTER)
                    fl = WAR_BLASTER;
            }
            if (fl & WARx_USES_CELLS)
            {   if (self.ammo_cells < 1)
                    am = 1;
            }
            else
            {   // Assume Nailgun.
                if (self.ammo_nails < 1)
                    am = 1;
            }
        }
        else if (self.impulse == 6)
        {
            fl = it & (WAR_GRENADE_LAUNCHER | WAR_SIDEWINDER);
            if (fl)
            {
                if ( ((self.war != WAR_GRENADE_LAUNCHER) && (fl & WAR_GRENADE_LAUNCHER))
                || (fl == WAR_GRENADE_LAUNCHER) )
                    fl = WAR_GRENADE_LAUNCHER;
                else if (fl & WAR_SIDEWINDER)
                    fl = WAR_SIDEWINDER;
                if (self.ammo_rockets < 1)
                    am = 1;
            }
        }
        else if (self.impulse == 7)
        {
            fl = it & (WAR_ROCKET_LAUNCHER | WAR_CRUISE_MISSILE);
            if (fl)
            {
                if ( ((self.war != WAR_ROCKET_LAUNCHER) && (fl & WAR_ROCKET_LAUNCHER))
                || (fl == WAR_ROCKET_LAUNCHER) )
                {
                    fl = WAR_ROCKET_LAUNCHER;
                    if (self.ammo_rockets < 1)
                        am = 1;
                }
                else if (fl & WAR_CRUISE_MISSILE)
                {
                    fl = WAR_CRUISE_MISSILE;
                    if (self.ammo_rockets < COST_MIRV)
                        am = 1;
                }
            }
        }
        else if (self.impulse == 8)
        {
            fl = it & (WAR_BURIZA | WAR_PLASMA_GUN | WAR_THUNDERBOLT | WAR_CHAIN_LIGHTNING);
            if (fl)
            {   // Order is:  chain/thunderbolt, plasma gun, crossbow.
                // Note:  Railgun would be here because of Qrack lights
                // Weapons in slot 8 glow blue in Qrack.
                if ( (fl & WAR_BURIZA)
                && ((fl == WAR_BURIZA) || (self.ammo_cells < 1)) )
                    fl = WAR_BURIZA;       // Only weapon available.
                else if ((self.war == WAR_THUNDERBOLT) || (self.war == WAR_CHAIN_LIGHTNING))
                {
                    if (fl & WAR_PLASMA_GUN)
                        fl = WAR_PLASMA_GUN;
                    else if ((fl & WAR_BURIZA) && (self.ammo_super >= 1))
                        fl = WAR_BURIZA;
                    else if (self.war == WAR_CHAIN_LIGHTNING)
                        fl = WAR_CHAIN_LIGHTNING;
                    else
                        fl = WAR_THUNDERBOLT;
                }
                else if (self.war == WAR_PLASMA_GUN)
                {
                    if ((fl & WAR_BURIZA) && (self.ammo_super >= 1))
                        fl = WAR_BURIZA;
                    else if (fl & WAR_CHAIN_LIGHTNING)
                        fl = WAR_CHAIN_LIGHTNING;
                    else if (fl & WAR_THUNDERBOLT)
                        fl = WAR_THUNDERBOLT;
                    else
                        fl = WAR_PLASMA_GUN;
                }
                else
                {
                    if (fl & WAR_CHAIN_LIGHTNING)
                        fl = WAR_CHAIN_LIGHTNING;
                    else if (fl & WAR_THUNDERBOLT)
                        fl = WAR_THUNDERBOLT;
                    else if (fl & WAR_PLASMA_GUN)
                        fl = WAR_PLASMA_GUN;
                    else if (fl & WAR_BURIZA)
                        fl = WAR_BURIZA;
                }

                if (fl == WAR_BURIZA)
                {   if (self.ammo_super < 1)
                        am = 1;
                }
                else if (self.ammo_cells < 1)
                    am = 1;
            }
        }
    }
//- - - - - - - - -
// Hip and Drake weapons.
//    else if (self.impulse == 225)
//    {
//        fl = it & WAR_BURIZA;
//        if (self.ammo_nails < 1)
//            am = 1;
//    }
    // Impulses are needed for each weapon due to FrikBot.
    else if ((self.impulse >= 21) && (self.impulse <= 30))
    {
        if (self.impulse == 21)
        {
            fl = it & (WAR_AXE | WAR_CHAINSAW);
            if (fl & WAR_CHAINSAW)
                fl = WAR_CHAINSAW;
            else if (fl & WAR_AXE)
                fl = WAR_AXE;
        }
        else if (self.impulse == 22)
        {
            fl = it & WAR_SHOTGUN;
            if (self.ammo_shells < 1)
                am = 1;
        }
        else if (self.impulse == 23)
        {
            fl = it & WAR_SUPER_SHOTGUN;
            if (self.ammo_shells < 1)
                am = 1;
        }
        else if (self.impulse == 24)
        {
            fl = it & WAR_NAILGUN;
            if (self.ammo_nails < 1)
                am = 1;
        }
        else if (self.impulse == 25)
        {
            fl = it & WAR_SUPER_NAILGUN;
            if (self.ammo_nails < 1)
                am = 1;
        }
        else if (self.impulse == 26)
        {
            fl = it & WAR_GRENADE_LAUNCHER;
            if (self.ammo_rockets < 1)
                am = 1;
        }
        else if (self.impulse == 27)
        {
            fl = it & WAR_ROCKET_LAUNCHER;
            if (self.ammo_rockets < 1)
                am = 1;
        }
        else if (self.impulse == 28)
        {
            fl = it & (WAR_THUNDERBOLT | WAR_CHAIN_LIGHTNING);
            if (fl & WAR_CHAIN_LIGHTNING)
                fl = WAR_CHAIN_LIGHTNING;
            else if (fl & WAR_THUNDERBOLT)
                fl = WAR_THUNDERBOLT;
            if (self.ammo_cells < 1)
                am = 1;
        }
    }
    else if ((self.impulse >= 31) && (self.impulse <= 40))
    {
        if (self.impulse == 31)
            fl = it & WAR_MJOLNIR;
        else if (self.impulse == 32)
            fl = it & WAR_ZAPPER;
        else if (self.impulse == 35)
        {
            fl = it & (WAR_BLASTER | WAR_LASER_CANNON);
            if (fl & WAR_LASER_CANNON)
                fl = WAR_LASER_CANNON;
            else if (fl & WAR_BLASTER)
                fl = WAR_BLASTER;
            if (self.ammo_cells < 1)
                am = 1;
        }
        else if (self.impulse == 36)
        {
            fl = it & WAR_SIDEWINDER;
            if (self.ammo_rockets < 1)
                am = 1;
        }
        else if (self.impulse == 37)
        {
            fl = it & WAR_CRUISE_MISSILE;
            if (self.ammo_rockets < COST_MIRV)
                am = 1;
        }
        else if (self.impulse == 38)
        {
            fl = it & WAR_PLASMA_GUN;
            if (self.ammo_cells < 1)
                am = 1;
        }
    }
    else if ((self.impulse >= 41) && (self.impulse <= 50))
    {
        if (self.impulse == 41)
            fl = it & WAR_GRAPPLE;
        else if (self.impulse == 48)
        {
            fl = it & WAR_BURIZA;
            if (self.ammo_rockets < 1)
                am = 1;
        }
    }
//- - - - - - - - -

    self.impulse = 0;
    
    if (self.war == fl)
        return;     // Already the same weapon.

    if (!fl)    //(!(it & fl))
        {sprint (self, "no weapon.\n");  return;}
    if (am)
        {sprint (self, "not enough ammo.\n");  return;}

// Set weapon and ammo.
    War_Select (fl);    // Updates weapon icon too.
};

//============
// CycleWeaponCommand
//
// Go to the next weapon with ammo
//============
void() CycleWeaponCommand =
{
    local   float   it, am;
    local   float   ow;

    ow = self.war;
    it = self.arsenal & legalized;
    self.impulse = 0;

    do
    {
        am = 0;

        if (self.war == WAR_AXE)
            self.war = WAR_CHAINSAW;
        else if (self.war == WAR_CHAINSAW)
            self.war = WAR_MJOLNIR;
        else if (self.war == WAR_MJOLNIR)
            self.war = WAR_ZAPPER;
        else if (self.war == WAR_ZAPPER)
        {   self.war = WAR_SHOTGUN;
            if (self.ammo_shells < 1)  am = 1;
        }
        else if (self.war == WAR_SHOTGUN)
        {   self.war = WAR_SUPER_SHOTGUN;
            if (self.ammo_shells < 1)  am = 1;
        }
        else if (self.war == WAR_SUPER_SHOTGUN)
        {   if (it & WAR_SUPER_NAILGUN)
                self.war = WAR_SUPER_NAILGUN;
            else
                self.war = WAR_NAILGUN;
            if (self.ammo_nails < 1)  am = 1;
        }
        else if (self.war == WAR_NAILGUN)
        {   self.war = WAR_SUPER_NAILGUN;
            if (self.ammo_nails < 1)  am = 1;
        }
        else if (self.war == WAR_SUPER_NAILGUN)
        {   if (it & WAR_LASER_CANNON)
                self.war = WAR_LASER_CANNON;
            else
                self.war = WAR_BLASTER;
            if (self.ammo_cells < 1)  am = 1;
        }
        else if (self.war == WAR_BLASTER)
        {   self.war = WAR_LASER_CANNON;
            if (self.ammo_cells < 1)  am = 1;
        }
        else if (self.war == WAR_LASER_CANNON)
        {   self.war = WAR_GRENADE_LAUNCHER;
            if (self.ammo_rockets < 1)  am = 1;
        }
        else if (self.war == WAR_GRENADE_LAUNCHER)
        {   self.war = WAR_SIDEWINDER;
            if (self.ammo_rockets < 1)  am = 1;
        }
        else if (self.war == WAR_SIDEWINDER)
        {   self.war = WAR_ROCKET_LAUNCHER;
            if (self.ammo_rockets < 1)  am = 1;
        }
        else if (self.war == WAR_ROCKET_LAUNCHER)
        {   self.war = WAR_CRUISE_MISSILE;
            if (self.ammo_rockets < COST_MIRV)  am = 1;
        }
        else if (self.war == WAR_CRUISE_MISSILE)
        {   if (it & WAR_CHAIN_LIGHTNING)
                self.war = WAR_CHAIN_LIGHTNING;
            else
                self.war = WAR_THUNDERBOLT;
            if (self.ammo_cells < 1)  am = 1;
        }
        else if (self.war == WAR_THUNDERBOLT)
        {   self.war = WAR_CHAIN_LIGHTNING;
            if (self.ammo_cells < 1)  am = 1;
        }
        else if (self.war == WAR_CHAIN_LIGHTNING)
        {   self.war = WAR_PLASMA_GUN;
            if (self.ammo_cells < 1)  am = 1;
        }
        else if (self.war == WAR_PLASMA_GUN)
        {   self.war = WAR_BURIZA;
            if (self.ammo_super < 1)  am = 1;
        }
        else if (self.war == WAR_BURIZA)
            self.war = WAR_GRAPPLE;
        else if (self.war == WAR_GRAPPLE)
        {   if (it & WAR_CHAINSAW)
                self.war = WAR_CHAINSAW;
            else
                self.war = WAR_AXE;
        }

        if ( (it & self.war) && am == 0)
        {
            War_Select (self.war);  // Originally 'W_SetCurrentAmmo()'.
            return;
        }
    } while (ow != self.war);

};

//============
// CycleWeaponReverseCommand
//
// Go to the prev weapon with ammo
//============
void() CycleWeaponReverseCommand =
{
    local   float   it, am;
    local   float   ow;

    ow = self.war;
    it = self.arsenal;
    self.impulse = 0;

    do
    {
        am = 0;

        if ((self.war == WAR_CHAIN_LIGHTNING) || (self.war == WAR_THUNDERBOLT))
        {   self.war = WAR_CRUISE_MISSILE;
            if (self.ammo_rockets < COST_MIRV)  am = 1;
        }
        else if (self.war == WAR_CRUISE_MISSILE)
        {   self.war = WAR_ROCKET_LAUNCHER;
            if (self.ammo_rockets < 1)  am = 1;
        }
        else if (self.war == WAR_ROCKET_LAUNCHER)
        {   self.war = WAR_SIDEWINDER;
            if (self.ammo_rockets < 1)  am = 1;
        }
        else if (self.war == WAR_SIDEWINDER)
        {   self.war = WAR_GRENADE_LAUNCHER;
            if (self.ammo_rockets < 1)  am = 1;
        }
        else if (self.war == WAR_GRENADE_LAUNCHER)
        {   if (it & WAR_LASER_CANNON)
                self.war = WAR_LASER_CANNON;
            else
                self.war = WAR_BLASTER;
            if (self.ammo_cells < 1)  am = 1;
        }
        else if ((self.war == WAR_LASER_CANNON) || (self.war == WAR_BLASTER))
        {   if (it & WAR_SUPER_NAILGUN)
                self.war = WAR_SUPER_NAILGUN;
            else
                self.war = WAR_NAILGUN;
            if (self.ammo_nails < 1)  am = 1;
        }
        else if ((self.war == WAR_SUPER_NAILGUN) || (self.war == WAR_NAILGUN))
        {   self.war = WAR_SUPER_SHOTGUN;
            if (self.ammo_shells < 1)  am = 1;
        }
        else if (self.war == WAR_SUPER_SHOTGUN)
        {   self.war = WAR_SHOTGUN;
            if (self.ammo_shells < 1)  am = 1;
        }
        else if (self.war == WAR_SHOTGUN)
            self.war = WAR_ZAPPER;
        else if (self.war == WAR_ZAPPER)
            self.war = WAR_MJOLNIR;
        else if (self.war == WAR_MJOLNIR)
            self.war = WAR_CHAINSAW;
        else if (self.war == WAR_CHAINSAW)
        {   if (it & WAR_CHAINSAW)
                self.war = WAR_GRAPPLE;     // Skip the axe.
            else
                self.war = WAR_AXE;
        }
        else if (self.war == WAR_AXE)
            self.war = WAR_GRAPPLE;
        else if (self.war == WAR_GRAPPLE)
        {   self.war = WAR_BURIZA;
            if (self.ammo_super < 1)  am = 1;
        }
        else if (self.war == WAR_BURIZA)
        {   self.war = WAR_PLASMA_GUN;
            if (self.ammo_cells < 1)  am = 1;
        }
        else if (self.war == WAR_PLASMA_GUN)
        {   self.war = WAR_CHAIN_LIGHTNING;
            if (self.ammo_cells < 1)  am = 1;
        }
    
        if ( (it & self.war) && am == 0)
        {
            War_Select (self.war);  // Originally 'W_SetCurrentAmmo()'.
            return;
        }
    } while (ow != self.war);

};

//==========================================================================
//  PLAYER ARMOR USE
//==========================================================================

// Update 6/2/10:  'W_UseArmor' moved to armor.qc.

//==========================================================================
//  CHEATS
//==========================================================================

//============
// ServerflagsCommand
//
// Just for development (PM's Note:  This is the rune cheat.)
//============
void() ServerflagsCommand =
{
// Originally 'serverflags = serverflags * 2 + 1'.
    if ((serverflags & 15) == 15)
        serverflags = serverflags - 15;
    else
        serverflags = serverflags + 1;
    HUD_ServerRunes ();
};


//============
// CheatCommand
//============
// Give client all weapons and maximum ammo.
void() Cheat_Weapons =
{
    if (self.arsenal == legalized)
        self.perms = self.perms | POW_PACK;

    self.ammo_cells     = AMAX2_CELLS;
    self.ammo_rockets   = AMAX2_ROCKETS;
    self.ammo_nails     = AMAX2_NAILS;
    self.ammo_shells    = AMAX2_SHELLS;
    self.ammo_super     = AMAX_SUPER;
    bind_ammo (self);
    self.impulse        = 0;

    self.arsenal        = legalized;    // Give all allowed weapons.
// Set weapon.
    if (legalized & WAR_CRUISE_MISSILE)
        self.war = WAR_CRUISE_MISSILE;  // BFG.
//    else if (legalized & WAR_CHAIN_LIGHTNING)
//       self.war = WAR_CHAIN_LIGHTNING;
    else if (legalized & WAR_ROCKET_LAUNCHER)
        self.war = WAR_ROCKET_LAUNCHER; // The old gold standard.
    else
        War_FindBestWeapon ();

    War_UpdateAll (self);
    War_SetCurrentAmmo ();

    sprint (self, self.netname);
    sprint (self, " activates Guns and Ammo!\n");
};

// Removes current weapon.
void() Cheat_Remove =
{
    if (self.war)
    {
        local   string  s;

        s = weapon_name (self.war);
        sprint (self, "Your ");
        sprint (self, s);
        sprint (self, " disappears\n");
        War_Remove (self, self.war);
    }
};

// Removes all weapons, ammo, and items from client.
void() Cheat_Void =
{
    // Remove all items and their effects!
    SUB_RemovePowerups ();
    self.items=self.currentammo=self.arsenal=self.war = 0;
    self.ammo_shells=self.ammo_nails=self.ammo_rockets=self.ammo_cells=0;
    self.weaponmodel = "";
    War_UpdateWeapon (self);    // Set weapon to unused non-zero value.
    if (self.form_active)
        War_Transform (self);   // Force back to human form if needed.
    sprint (self, "Nil!\n");
};

// Gives client a special armor.
void(float exotic) Cheat_Armor =
{
    local   float   morphed;
    local   vector  stats;
    local   string  text;

    morphed = self.form_active;
    if (exotic == SUIT_COURAGE)
        {stats = ARMOR_STATS_COURAGE;  text = " activates Courage!\n";}
    else if (exotic == SUIT_ONYX)
        {stats = ARMOR_STATS_ONYX;  text = " activates Onyx!\n";}
    else if (exotic == SUIT_ONYX_POWER)
        {stats = ARMOR_STATS_ONYX;  text = " activates Onyx Power!\n";}
    else if (exotic == SUIT_BERSERKER)
        {stats = ARMOR_STATS_DEMON;  text = " activates Demonhide!\n";}
    else if (exotic == SUIT_SPIRIT)
        {stats = ARMOR_STATS_SPIRIT;  text = " activates Spirits!\n";}
    else if (exotic == SUIT_CHAOS)
        {stats = ARMOR_STATS_CHAOS;  text = " activates Chaos!\n";}
    else if (exotic == SUIT_ULTRA)
        {stats = ARMOR_STATS_ULTRA;  text = " tests ultra armor...\n";}
    else if (exotic == SUIT_NINJA)
        {stats = ARMOR_STATS_GREEN;  text = " activates Jumpsuit!\n";}
    else if (exotic == SUIT_DRAGON)
        {stats = ARMOR_STATS_RED;  text = " activates Dragonscale!\n";}
    else    // Default to basic red armor.
        {exotic = 0;  stats = ARMOR_STATS_RED;  text = " suits up!\n";}
    stats_z = stats_z | exotic;

// Change armor.
    Armor_Set (self, stats);

    sprint (self, self.netname);
    sprint (self, text);
};

// Gives client quad damage on demand for 30 seconds.
void() Cheat_Quad =
{
    self.super_time = 0;
    self.super_damage_finished = time + 30;
    self.items = self.items | IT_QUAD;
//    dprint ("quad cheat\n");
    sprint (self, self.netname);
    sprint (self, " activated the quad cheat\n");
};

// Toggles reflector shield.
void() Cheat_Shield =
{
    if (self.effects & EF_BRIGHTFIELD)
    {   sprint (self, "reflector OFF\n");
        self.effects = self.effects - EF_BRIGHTFIELD;
    }
    else
    {   sprint (self, "reflector ON\n");
        self.effects = self.effects | EF_BRIGHTFIELD;
    }
};

// Gives client tome of power on demand for 30 seconds.
void() Cheat_Tome =
{
//    if (self.tome_finished)
//    {   sprint(self, "tome OFF\n");
//        self.tome_finished = 0;
//    }
//    else
//    {   sprint(self, "tome ON\n");
//        self.tome_finished = 10000000;
//    }
    self.tome_time = 0;
    self.tome_finished = time + 30;
    self.items2 = (self.items2 - (self.items2 & IT2x_RUNES12)) | IT2_WETSUIT;
    sprint (self, self.netname);
    sprint (self, " activated the tome cheat\n");
};

// Toggles the given permanent powerups.
void(float pf, string text) Cheat_Perms =
{
    if (text)
        sprint (self, text);
    if (self.perms & pf)
    {   sprint (self, " OFF\n");
        self.perms = self.perms - (self.perms & pf);
    }
    else
    {   sprint (self, " ON\n");
        self.perms = self.perms | pf;
    }
};

// Toggles equalizer powerup.
void() Cheat_Shottyman = {Cheat_Perms (POW_SHOTTYMAN, "desperado");};

void() Cheat_Upgrade = {Cheat_Perms (POW_DOUBLE, "equalizer");};

void() Cheat_Vampire = {Cheat_Perms (POW_VAMPIRE, "berserker");};

// Dumps origin and yaw.
void() Cheat_Origin =
{
    local   float   yaw;

    yaw = rint(self.angles_y);
    yaw = anglemod(yaw);
    dprint(vtos(self.origin)); dprint(" -- ");
    dprint(ftos(yaw)); dprint("\n");
};

// Teleports client to an unrevealed secret.
void() Cheat_Secret =
{
    local   entity  e;

    e = find (world, classname, "trigger_secret");
    if (e)
    {
        sprint (self, "Reveal Secret\n");
        if (self.movetype != MOVETYPE_NOCLIP)
            {self.movetype = MOVETYPE_NOCLIP; sprint (self, "noclip ON\n");}
        setorigin (self, e.origin + ((e.mins + e.maxs)*0.5));
    }
};

// Use all targets with a targetname that match self.netname.
void() Cheat_Target =
{
    local   string  text;

    text = self.target;
    self.target = self.netname;
    activator = self;
    SUB_UseTargets ();
    self.target = text;

    dprint ("Using \"");
    dprint (self.netname);
    dprint ("\"\n");
};

// Use/aggravate every monster on the level.
void() Cheat_Aggro =
{
    local   entity  e, oa, os;
    local   float   notarg;

// Temporarily remove notarget flag if on.
    notarg = self.flags & FL_NOTARGET;
    self.flags = self.flags - notarg;

    oa = activator;
    os = self;
    activator = self;

    e = nextent (world);
    while (e)
    {
        if (e.flags & FL_MONSTER)
            {self = e;  self.use ();}
        else if (e.classname == "func_spawn")
        {
            if (e.targetname)
                {self = e;  self.use ();}
        }
        e = nextent (e);
    }
    activator = oa;
    self = os;

    self.flags = self.flags | notarg;   // Restore notarg flag.

    sprint (self, self.netname);
    sprint (self, " aggravated monsters\n");
};

// Instantly slays a monster.
void(entity targ, entity attacker) KillIt =
{
// FIXME:  Statue monsters are immune.  Fix that!
    if (targ.flags & FL_MONSTER)
        if (!IsDead (targ))
        {
            if (!targ.modelindex)
                targ.modelindex = targ.mindex2;
        // Restore movetype so Quake won't mistake targ for door or trigger.
            if (targ.spawnflags & SPAWNx_DELAY)
                if (targ.movetype == MOVETYPE_NONE)
                    targ.movetype = targ.xsf & XSF_MOVETYPE;
        //- - - - - - - - -
            T_Kill (targ, world, attacker, -1, "impulse");
        }
};

// Kills every monster on the level.
void() Cheat_Massacre =
{
    local   entity  e;

    e = nextent (world);
    while (e)
    {
        KillIt (e, self);
        e = nextent (e);
    }

    sprint (self, self.netname);
    sprint (self, " activated the massacre cheat\n");
};

// Resurrects monsters to fight for the player.
void() Cheat_Revive =
{
    if (!mass_revive (0))
        return;
    Quake_Spawn (self, 500, 0, self.origin, DF_BLESSED, 1, '0 5 0');
    sprint (self, self.netname);
    sprint (self, " wakes the dead\n");     //" raises hell\n"
};

//==========================================================================


float(float fl) Gamemode_Set =
{
    local   float   gm, off;
    local   string  text;

    gm = cvar("temp1");
    off = gm & fl;
    if (off)
        gm = gm - fl;
    else
        gm = gm | fl;
    text = ftos(gm);
    cvar_set ("temp1", text);

    return !off;
};

// Sets various... things.  Single-player only.
void() Gamemode =
{
    if (deathmatch || coop)
        return;

    if (self.impulse == 70)
    {
        if (Gamemode_Set (GM_DMSP))
            sprint (self, "dmsp ON\n");
        else
            sprint (self, "dmsp OFF\n");
    }
    else if (self.impulse == 71)
    {
        if (Gamemode_Set (GM_CRANKED))
            sprint (self, "cranked ON\n");
        else
            sprint (self, "cranked OFF\n");
    }
    else if (self.impulse == 72)
    {
        if (Gamemode_Set (GM_DECAY))
            sprint (self, "corpse removal ON\n");
        else
            sprint (self, "corpse removal OFF\n");
    }
    else if (self.impulse == 73)
    {
        if (Gamemode_Set (GM_FOOTSTEPS))
            sprint (self, "Footsteps ON\n");
        else
            sprint (self, "Footsteps OFF\n");
    }
    else if (self.impulse == 74)
    {
        if (Gamemode_Set (GM_SUMMON_ALL))
            sprint (self, "summon test ON\n");
        else
            sprint (self, "summon test OFF\n");
    }
    else if (self.impulse == 75)
    {
        if (Gamemode_Set (GM_AGGRO))
            sprint (self, "angry monsters ON\n");
        else
            sprint (self, "angry monsters OFF\n");
    }
    else if (self.impulse == 76)
    {
        if (Gamemode_Set (GM_RESPAWN))
            sprint (self, "respawning monsters ON\n");
        else
            sprint (self, "respawning monsters OFF\n");
    }
    else if (self.impulse == 77)
    {
        if (Gamemode_Set (GM_HELL))
            sprint (self, "Hell difficulty ON\n");
        else
        {   serverflags = serverflags - (serverflags & SVFL_HELL);
            sprint (self, "Hell difficulty OFF\n");
        }
    }
    else if (self.impulse == 78)
    {
        if (Gamemode_Set (GM_PURIST))
            sprint (self, "classic shotguns ON\n");
        else
            sprint (self, "classic shotguns OFF\n");
    }
    else if (self.impulse == 79)
    {
        if (Gamemode_Set (GM_PLAYER))
            sprint (self, "more player models ON\n");
        else
            sprint (self, "more player models OFF\n");
    }
    else if (self.impulse == 80)
    {
        if (Gamemode_Set (GM_DRAGONSCALE))
            sprint (self, "dragonscale test ON\n");
        else
            sprint (self, "dragonscale test OFF\n");
    }
    else if (self.impulse == 81)
    {
        if (Gamemode_Set (GM_THUNDERSTORM))
            sprint (self, "Mjolnir thunderstorm ON\n");
        else
            sprint (self, "Mjolnir thunderstorm OFF\n");
    }
    else
        return;
    sprint (self, "This will take effect next level.\n");
};

//==========================================================================


//- - - - - - - - - - - - - - - -//
// Finds the nearest enemy (within a set distance), then warns the client.
void() DetectEvil =
{
// Dmsp feature only.
    if (deathmatch || coop || !dmsp)// || (dmsp & DMSP_NOCOUNT))
    {   // Unfeasible in multiplayer due to conflicting pinging sounds,
        // not to mention overhead from multiple large findradius calls.
        radar_time = 10000000;
        return;
    }

//    if (time >= radar_time)
    {
        local   entity  head, targ;
        local   float   lo, dist;

        lo = 2000;    // Effective up to 60 metres.
        head = findradius(self.origin, lo);
        targ = world;
        while (head)
        {
            if (head.flags & FLx_CREATURE)
            if (head.health > 0)
            if (head != self)
            if (head.solid)     // Here so Darkplaces won't include.
            {
                dist = vlen(self.origin - head.origin);
                if (dist <= lo)
                if (!Ally_Check (head, self))   // Ignore allies.
                {
                    lo = dist;
                    targ = head;
                }
            }
            head = head.chain;
        }
        dist = lo / 800;   // Chosen to emulate Aliens' ping rate.
        if (dist < 0.2)
            dist = 0.2;     // That's 300 beats a minute!
        radar_time = dist + time;

// Note:  Make sure weapon does not use currentammo.
        if (targ)
        {   // Yes, use the target as the source because it affects the
            // volume and which speaker gets played.  This is also the
            // main reason why this is disabled in multiplayer.
            sound (targ, CHAN_AUTO, "ambience/heart.wav", 1, 0.2);
            self.currentammo = lo * 0.03;   // Approximate value in metres.
        }
        else
            self.currentammo = 0;
    }
};
//- - - - - - - - - - - - - - - -//

//============
// ImpulseCommands
//============
void() ImpulseCommands =
{
// Impulses - - - - - - - - - - - - - -
//    1 -   8 = Weapon select (normal)
//          9 = Give weapons
//         10 = Cycle weapons, forward
//         11 = Runes
//         12 = Cycle weapons, reverse
//         13 = Give keys
//         14 = Dragonscale
//         15 = Courage Armor
//         19 = Remove weapons
//         20 = Use armor
//   21 -  50 = Weapon select (specific)
//   51 -  55 = Monster command
//   56 -  57 = Kill/Anger pets
//         69 = Summon monster (type varies by value of saved1)
//   70 -  79 = Gamemode change
//  100 - 104 = Frikbot stuff
//  225 - 226 = Weapon select (Hipnotic)
//        246 = Gauntlets of Power
//        247 = Revive monsters
//        248 = Tome of Power
//        249 = Reveal secret
//        250 = Origin and Yaw dump
//        251 = Equalizer
//        252 = Shields
//        253 = Aggro
//        254 = Genocide
//        255 = Quad Damage
//- - - - - - - - - - - - - - - - - - -
    if (self.impulse >= 1 && self.impulse <= 8)
        W_ChangeWeapon ();
    else if (self.impulse == 10)
        CycleWeaponCommand ();
    else if (self.impulse == 11)
        ServerflagsCommand ();      // FIXME:  Is this a cheat?
    else if (self.impulse == 12)
        CycleWeaponReverseCommand ();
    else if (self.impulse == 20)
        W_UseArmor ();
    else if (self.impulse >= 21 && self.impulse <= 50)
        W_ChangeWeapon ();
    else if ((self.impulse >= 51) && (self.impulse <= 57))
        Impulse_Monster ();
    else if (self.impulse >= 70 && self.impulse <= 89)
        Gamemode ();
    // Impulses 100-104 reserved for FrikBot.
//    else if (self.impulse == 225)     // Hip weapon 9.
//        W_ChangeWeapon ();
//    else if (self.impulse == 226)     // Hip weapon 0.
//        W_UseArmor ();
    else if ( !(deathmatch || coop || (skill >= 4)) )
    {   // The big, bad CHEATS!
        // Turned off in multiplayer and/or Hell skill.
        if (self.impulse == 9)
            Cheat_Weapons ();
        else if (self.impulse == 13)
            self.items = self.items | ITx_ALL_KEYS;     // Give keys.
        else if (self.impulse == 17)
            Toggle_Music ();
        else if (self.impulse == 18)
            Cheat_Remove ();
        else if (self.impulse == 19)
            Cheat_Void ();
// Update 8/7/10:  Summon monster update.  One impulse to rule them all!
        else if (self.impulse == 69)
            Cheat_Monster ();
// The high end numbers...
        else if (self.impulse == 91)
            Cheat_Armor (SUIT_DRAGON);
        else if (self.impulse == 92)
            Cheat_Armor (SUIT_COURAGE);
        else if (self.impulse == 93)
            Cheat_Armor (SUIT_ONYX_POWER);
        else if (self.impulse == 94)
            Cheat_Armor (SUIT_BERSERKER);
        else if (self.impulse == 95)
            Cheat_Armor (SUIT_SPIRIT);
        else if (self.impulse == 96)
            Cheat_Armor (SUIT_CHAOS);
        else if (self.impulse == 97)
            Cheat_Armor (SUIT_NINJA);
        else if (self.impulse == 98)
            Cheat_Armor (SUIT_ULTRA);
// DISABLED -- No CTF runes in Drake.
//        else if (self.impulse == 99)
//        {
//            self.tech = (self.tech + 1) & 3;
//            sprint (self, "Tech: ");
//            if (self.tech == 1) sprint (self, "Resistance\n");
////            else if (self.tech == 2) sprint (self, "Strength\n");
//            else if (self.tech == 2) sprint (self, "Haste\n");
//            else if (self.tech == 3) sprint (self, "Regeneration\n");
//            else sprint(self, "none\n");
//            Regen_ClientReset (self);
//        }
        else if (self.impulse == 243)
            Cheat_Vampire ();
        else if (self.impulse == 244)
            Cheat_Shottyman ();
        else if (self.impulse == 245)
            Cheat_Upgrade ();
        else if (self.impulse == 246)
            T_Curse (self, world, CURSE_SLOW, 10);
        else if (self.impulse == 247)
            Cheat_Revive ();
        else if (self.impulse == 248)
            Cheat_Tome ();
        else if (self.impulse == 249)
            Cheat_Secret ();
        else if (self.impulse == 250)
            Cheat_Origin ();
        // 251 changed to something else.
        else if (self.impulse == 252)
            Cheat_Shield ();
        else if (self.impulse == 253)
            Cheat_Aggro ();
        else if (self.impulse == 254)
            Cheat_Massacre ();
        else if (self.impulse == 255)
            Cheat_Quad ();
    }
    self.impulse = 0;
};

//============
// W_WeaponFrame
//
// Called every frame so impulse events can be handled as well as possible
//============
void() W_WeaponFrame =
{
//- - - - - - - - - - - - - - - -//
    if (self.war == 0)
    {
        if (!self.form_active)
            self.currentammo = 0;
    }
    else if ((self.war == WAR_AXE) || (self.war == WAR_CHAINSAW))
    {
        if (!self.form_active)      // Usable only in human form.
            if (time >= radar_time)
                DetectEvil ();      // Radar.
    }
//- - - - - - - - - - - - - - - -//
    if (time < self.attack_finished)
    {
//- - - - - - - - - - - - - - - -//
        if (!self.button0)
        {
            if (!self.b0_click)
                self.b0_click = 1;      // Released button.
        // Check for loose MIRVs.
            if (self.war == WAR_CRUISE_MISSILE)
                Mirv_Use ();
        }
        else if (self.b0_click)
            self.b0_click = 2;      // Just double-clicked.
//- - - - - - - - - - - - - - - -//
        return;
    }

    if (self.impulse)
        ImpulseCommands ();
    
// check for attack
//- - - - - - - - - - - - - - - -//
// MIRVs
    if (self.war == WAR_CRUISE_MISSILE)
    {
        if (self.mirv1)
        {   // Active MIRV -- cannot allow another launch now!
            if (!self.button0)
                Mirv_Use ();
            // ELSE let the mirv fly some more.
        }
        else if (self.button0)
            W_Attack ();
        return;
    }
//- - - - - - - - - - - - - - - -//
    if (self.button0)
        W_Attack ();
};


//===========================/  END OF FILE  /===========================//

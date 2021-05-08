//==========================================================================
//
//  CROSS-LEVEL CLIENT DATA
//
//==========================================================================

void() SetNewParms =
{
    parm1 = map_armor;
    parm2 = 100;
    parm3 = map_ammo1;
    parm4 = map_ammo2;
    parm5 = 0;
    parm6 = map_guns;
    parm7 = map_woc;
    if (deathmatch)
        parm8 = POW_DOUBLE;     // Free Equalizer!
    else
        parm8 = 0;
    parm9 = 0;
};

void() SetChangeParms =
{
// Carry on!
    if (self.health <= 0)
        {SetNewParms (); return;}

// check for prior regeneration before resetting items.
    local   float   mx, exotic, had_regen;

    exotic = Armor_Exotic (self);
    if ( (exotic == SUIT_BERSERKER) || (self.items2 & (IT2_REGEN|IT2_REGEN2)) )
        had_regen = TRUE;
    else
        had_regen = FALSE;

// remove items
    self.items = self.items - (self.items & (ITx_ALL_KEYS | ITx_ALL_POWERUPS));
    self.items2 = 0;

// Reset spirit armor.
    if (exotic == SUIT_SPIRIT)
        self.armorvalue = ARMOR_STATS_SPIRIT_y;
// cap super health
    mx = 100 + (self.perms & POWx_HEALTH);
    if ((self.health > mx) || had_regen)
        self.health = mx;
    else if (self.health < 50)
        self.health = 50;
// Give some ammo for the shotgun if the player is short, if he has a shotgun.
    if (self.arsenal & WARx_USES_SHELLS)
    {
        mx = ShellGame (SHELLS_START);
        if (self.ammo_shells < mx)
            self.ammo_shells = mx;
    }
// Set parms.
    parm1 = self.items;
    parm2 = self.health;
    parm3 = parms_pack (self.armorvalue, self.armortype * 100, self.ammo_shells);
    parm4 = parms_pack (self.ammo_nails, self.ammo_rockets, self.ammo_cells);
    parm5 = 0;      // self.weapon;
    parm6 = self.arsenal & legalized;
    parm7 = self.war;
    parm8 = self.perms;
    parm9 = self.ammo_super;
};

void() parms_decode =
{
    if (albatross)      // Set at worldspawn.
        SetNewParms ();

    self.items          = parm1;
    self.hit_points     =
    self.health         = parm2;
    self.armorvalue     = parms_unpack (parm3, 1);
    self.armortype      = parms_unpack (parm3, 2) / 100;
    self.ammo_shells    = parms_unpack (parm3, 3);
    self.ammo_nails     = parms_unpack (parm4, 1);
    self.ammo_rockets   = parms_unpack (parm4, 2);
    self.ammo_cells     = parms_unpack (parm4, 3);
//    self.weapon         = parm5;
    self.arsenal        = parm6;
    self.war            = parm7;
    self.perms          = parm8;
    self.max_health     = self.max_health + (parm8 & POWx_HEALTH);
    self.ammo_super     = parm9;

    self.items2         = (serverflags & 15) * IT2_RUNE1;   // Runes stay.

    War_UpdateAll (self);
};


//==========================================================================
//
//  RULES
//
//==========================================================================
void() ClientKill =
{
    if (self.deadflag)      // C code checks health.  This checks deadflag.
        {sprint (self, "Can't suicide -- already dead!\n");  return;}
    if (!self.takedamage)
        return;     // Can't suicide -- immune to damage!

    if (self.invincible_finished)   // Suicide fails if invulnerable.
        return;
    else if (self.super_damage_finished)  // Die in a more entertaining way.
        T_Kill (self, self, world, -99, "self-destructs");
    else
        T_Kill (self, self, world, 0, "suicides");
};

// called by DeadThink
// ClientKill in standard progs called this too, but not in Drake.
void() respawn =
{
    if (coop)
    {
        CopyToBodyQue (self);   // Make copy of dead body for appearances sake.
        setspawnparms (self);   // Get spawn parms as they were at level start.
        PutClientInServer ();   // Respawn
    }
    else if (deathmatch)
    {
        CopyToBodyQue (self);   // Make copy of dead body for appearances sake.
        SetNewParms ();         // Set default spawn parms
        PutClientInServer ();   // Respawn
    }
    else
    {
        // NOTE:  Check for Nehahra-style resurrection powerup here.

        //- - - - - - - - -
        // No resurrection?  Restart the level.
        //
        // Loading a level while in chasecam mode will force the player
        // back into first-person mode while weaponmodel, bobbing, and
        // other view-related variables remain disabled.  Therefore,
        // turn off chasecam to force variables back to normal.
        // Update:  Removed QC chasecam.
        //- - - - - - - - -
        localcmd ("restart\n");     // Restart the entire server.
    }
};

void() PlayerDeathThink =
{
    if ((self.flags & FL_ONGROUND))
    {
        local   float   forward;

        forward = vlen (self.velocity);
        forward = forward - 20;
        if (forward <= 0)
            self.velocity = '0 0 0';
        else    
            self.velocity = forward * normalize(self.velocity);
    }

    if (deathmatch)
    {   // Force respawn to stop those who are ahead from staying down.
        self.deadflag = DEAD_RESPAWNABLE;
        self.button0 = self.button1 = self.button2 = 0;
    }
    else
    {
        if (self.deadflag == DEAD_DEAD)
        {
            // Wait for any button down.
            if (self.button0 || self.button1 || self.button2)
                self.deadflag = DEAD_RESPAWNABLE;
            return;
        }
        if (self.button0 || self.button1 || self.button2)
            return;     // Wait for all buttons released.
    }

    respawn ();
};

//==========================================================================


//==========================================================================

// Prototypes moved to proto.qc.

void() PlayerPreThink =
{
    if (BotPreFrame())  // FrikBot
        return;

    if (intermission_running)
    {
        IntermissionThink ();   // Otherwise a button could be missed between
        return;                 // the think tics.
    }
    if (self.view_ofs == '0 0 0')
    {
        Cutscene_Think ();      // Check for cutscene stuff.
        return;        // intermission or finale
    }
// QC chasecams were checked here and in PlayerPostThink.  We only need
// to check the chasecam once, not twice, per frame.  Since thinking and
// movement is done between 'PlayerPreThink' and 'PlayerPostThink', do
// the chasecam stuff after movement only.
//
// Update:  QC cams removed.  Comments remain for reference purposes.

// NOTE:  Other rules are checked by the world in 'StartFrame'.
    if (WinFraglimit ())      // Used to be 'void() CheckRules'.
        return;

    Burn_Check (self);
//    Poison_Check (self);        // CoE style poison.
    Divine_Check (self);        // Lightning strike.
    WaterSwim (self);
    Wetsuit_PreThink ();        // Hipnotic's wetsuit.
    if (self.curse_type == CURSE_SLOW)
        self.velocity = self.velocity * 0.5;
//    if (self.tech == TECH_HASTE)
//        self.velocity = self.velocity * 2;

    if (self.deadflag)
    {
        // NOTE:  Dead is dead regardless of health.
        //
        // Alien Quake had the facehugger kill players while leaving them
        // with positive health.  Player had weaponmodel of a facehugger.

        if (self.deadflag >= DEAD_DEAD)
            PlayerDeathThink ();
        return;     // Dead, do nothing else.
    }
    if (self.health < 1)
        self.health = 1;    // Not dead yet!

// Check for cheaters.
    if (skill >= 4)     // Players can't cheat in Hell.
    if (!cutscene)
    {
        self.health = self.hit_points;      // 10/30/09:  Prevent 'give h'.
/* FIXME:  Doesn't work if weapons are bound to standard slots.
        if (self.items & ITx_ALL_AMMO)
        {   // Stop 'give' ammo cheats.
            if (self.items & IT_SHELLS)
            {   if (self.currentammo != self.ammo_shells)
                    self.ammo_shells = self.currentammo;
            }
            if (self.items & IT_NAILS)
            {   if (self.currentammo != self.ammo_nails)
                    self.ammo_nails = self.currentammo;
            }
            if (self.items & IT_ROCKETS)
            {   if (self.currentammo != self.ammo_rockets)
                    self.ammo_rockets = self.currentammo;
            }
            if (self.items & IT_CELLS)
            {   if (self.currentammo != self.ammo_cells)
                    self.ammo_cells = self.currentammo;
            }
        }
*/
    // Give ammo is a pain to stop, but with other cheats gone, ammo alone
    // won't save a would-be cheater.
        if (self.movetype == MOVETYPE_NOCLIP)
        {
            if (Kill_Cheater (self, self, "enters the Twilight Zone"))
                return;
        }
        else if (self.movetype == MOVETYPE_FLY)
        {
            if (self.form_active != FORM_DRAGON)
            {   // Not morphed into a flying creature, he's cheating!
                if (!(self.flags & FL_ONGROUND))
                    if (Kill_Cheater (self, self, "flew in pieces"))
                        return;
            }
        }
        if (self.flags & FL_NOTARGET)
            if (Kill_Cheater (self, self, "hid from life"))
                return;
        // Godmode is checked only when the client takes damage.
    }

//- - - - - - - - -
    // Check for jump double press.  Used to activate dragonscale.
    if (self.button2)
    {   // Pressed the jump button.
        if ((self.b2_time > time) && (self.b2_click == 2) &&
        (self.b2_done <= time))
        {   // Double-clicked in time.
            self.b2_click = 3;
            W_UseArmor ();
        }
        else if (!(self.b2_click & 1))
        {   // First press.
            self.b2_click = 1;
            self.b2_time = time + 0.3;  // 3 frame window to double-click.
        }
    }
    else
    {   // Jump not pressed.
        if ((self.b2_time > time) && (self.b2_click == 1))
            self.b2_click = 2;
        else if (self.b2_click != 2)
            self.b2_click = 0;
    }
//- - - - - - - - -

    // Make sure flying is on if player uses an item that grants flight.
    if (self.form_active == FORM_DRAGON)
    {
        if (self.movetype == MOVETYPE_WALK)
            self.movetype = MOVETYPE_FLY;
    }

    if (self.movetype == MOVETYPE_WALK)
    {
        if (self.h2olevel == 2)
            CheckWaterJump ();
//- - - - - - - - -
// DISABLED -- Unused right now!
//        else if (self.form_active)
//        {   // Some forms cannot have a waterlevel of 2.
//            if (self.h2olevel == 1)
//                if (!(self.flags & FL_ONGROUND))
//                    if (self.view_ofs_z <= ((self.mins_z + self.maxs_z)*0.5))
//                        CheckWaterJump ();
//        }
//- - - - - - - - -

        if (self.button2)
            PlayerJump ();
        else
        {
            if (self.wing_finished)
                self.gravity = fabs(self.gravity);
            self.flags = self.flags | FL_JUMPRELEASED;
        }
    }
    else if (self.movetype == MOVETYPE_FLY)
    {   // FIXME:  If cheating, bring him down to earth.
        PlayerFly ();       // In 'swap.qc'.
    }

// Teleporters can force a non-moving pause time... but they don't!
//    if (time < self.pausetime)
//        self.velocity = '0 0 0';

// If out of ammo for a weapon that needs ammo to use, find another weapon.
// Update 6/11/09:  Some weapons need more than one shot to use.
//    if (self.currentammo < 1)
    if (time > self.attack_finished)
    if (self.war)
    {
        if (!self.form_active)      // Morph is its weapon.
        {
            if (!(self.war & WARx_WEAPON_FREE))
            if ( !(self.war == WAR_CRUISE_MISSILE) || !self.mirv1 )  // Check missile control.
            {
                if (self.war == WAR_CRUISE_MISSILE)
                {   if (self.currentammo < COST_MIRV)
                        War_FindBestWeapon ();
                }
                else if (self.currentammo < 1)
                    War_FindBestWeapon ();
            }
        }
//        else if (self.form_active == FORM_SCORPIO)
//        {   // Scorpion form attacks vary by ammo type only.
//            if (self.items & ITx_ALL_AMMO)
//            if (self.currentammo < 1)
//                War_FindBestWeapon ();
//        }
    }
};

void() PlayerPostThink =
{
    if (BotPostFrame())     // FrikBot
        return;
//-----
// PM:  Hip Quake code isn't used in Drake.  For all of your earthquaking
// needs, make something spawn an earthquake entity that shakes the entire
// level.  See 'cool.qc' for earthquake code.
//    earthquake_postthink ();
//-----

    if (self.view_ofs == '0 0 0')
        return;        // intermission or finale
    if (self.deadflag)
        return;

//-----
    Wetsuit_PostThink ();       // Hipnotic's wetsuit.
    if (self.curse_type == CURSE_SLOW)
        self.velocity = self.velocity * 2;
//    if (self.tech == TECH_HASTE)
//        self.velocity = self.velocity * 0.5;
    if (self.movetype == MOVETYPE_FLY)
        PlayerFly_PostThink ();
//-----
// do weapon stuff
    W_WeaponFrame ();

// check to see if player landed and play landing sound
    FallingStuff ();

    CheckArtifacts (self);      // Replaces CheckPowerups.
    CheckBahamut ();
    CheckMjolnir ();            // SoE:  Modified throwing hammer.
    Regen_Check (self);

// Update 7/24/09:  Added grappler weapon from DoE.
    if (self.hook)
        GrappleService ();
};


//==========================================================================
//
//  PLAYER GAME EDGE FUNCTIONS
//
//==========================================================================

//============
// SelectSpawnPoint
//
// Returns the entity to spawn at
//============
entity() SelectSpawnPoint =
{
    local   entity  spot;
    local   float   use_dm_spots;
    
// testinfo_player_start is only found in regioned levels
    spot = find (world, classname, "testplayerstart");
    if (spot)
        return spot;

// 8/14/10:  Check dmsp.
    if (dmsp && !(dmsp & DMSP_START))
        use_dm_spots = TRUE;
    else
        use_dm_spots = FALSE;

// choose a info_player_deathmatch point
    if (coop && !use_dm_spots)
    {
        lastspawn = find (lastspawn, classname, "info_player_coop");
        if (lastspawn == world)
            lastspawn = find (lastspawn, classname, "info_player_start");
        if (lastspawn != world)
            return lastspawn;
    }
    else if (deathmatch || use_dm_spots)
    {
        local   entity  thing;
        local   float   pcount;

        spot = lastspawn;
        while (1)
        {
            spot = find(spot, classname, "info_player_deathmatch");
            if (spot != world)
            {
                if (spot == lastspawn)
                    return lastspawn;
                pcount = 0;
                thing = findradius(spot.origin, 32);
                while (thing)
                {
                    if (thing.classname == "player")
                        pcount = pcount + 1;
                    thing = thing.chain;
                }
                if (pcount == 0)
                {
                    lastspawn = spot;
                    return spot;
                }
            }
        }
    }

// FIXME:  Merger will probably have more than four episodes.
    if (serverflags & 15)   // PM:  Only the first four bits are runes.
    {   // return with a rune to start
        spot = find (world, classname, "info_player_start2");
        if (spot)
            return spot;
    }
    
    spot = find (world, classname, "info_player_start");
    if (!spot)
        error ("PutClientInServer: no info_player_start on level");
    
    return spot;
};

//============
void() PutClientInServer =
{
    local   entity  spot;

    spot = SelectSpawnPoint ();
//- - - - - - - - -
// Hack:  Nsoe map messages.
    if (temp_goal.message)
    {
        centerprint (self, temp_goal.message);
        temp_goal.message = world.null_string;
    }
//- - - - - - - - -

// The bare necessities.
    self.classname  = "player";
    self.hit_points = 
    self.health     = self.max_health   = 100;
    self.gib_health = -40;
    self.takedamage = DAMAGE_AIM;
    self.solid      = SOLID_SLIDEBOX;
    self.movetype   = MOVETYPE_WALK;
    self.flags      = FL_CLIENT;
    self.deadflag   = DEAD_NO;
    self.deathtype  = "";       // Okay, not necessary, but useful.
    self.enemy      = world;    // Undo 'Killed' stuff in case of respawn.

// More necessities, custom stuff.
    self.alpha      = 0;        // In case it was changed.
    self.gravity    = 1.0;
    self.mass       = MASS_MEDIUM;
    self.bloodtype  = BLOOD_RED;
    self.xfl        = XFL_ITEMS;
    self.alignment  = GOOD;     // So good NPCs don't attack player on sight.
    self.gorging    = FALSE;    // Gremlins may eat the player again.
    self.form_active= 0;        // Start in human form.
    self.mdl_head   = "progs/h_player.mdl";
    self.soul       = "yes";    // For Nehahra's soul-stealing wraiths.
// Reset missile pointers.  Shouldn't need them but just in case.
    self.mist       =
    self.hook       =
    self.mirv1      = world;

// Reset jump button stats.
    self.b2_click   = self.b2_done  = self.b2_time  = 0;

// Setup cutscene stuff.  Legacy code from Zerstorer.
    self.script_count = 2;
    self.script_delay = 1;
    self.script_time  = 0;

// Reset timers and counters for powerups and other stuff.
    more_air (self);
    SUB_RemovePowerups ();
    Burn_Null (self);
//    Poison_Null (self);

// Give items.
    parms_decode ();
    War_SetCurrentAmmo ();
    self.attack_finished = 0;
    self.show_hostile    = 0;
    // parms control persistant powerups, so set regeneration after decoding.
    Regen_ClientReset (self);

    self.th_pain    = player_pain;
    self.th_die     = player_die;
    self.th_gib     = player_gib;
    self.th_void    = player_void;
    
// set player origin and angles.
//
// Don't use setorigin because it puts the client in the void.
// Set oldorigin because if spawnpoint is occupied and tdeath does not
// destroy the occupier instantly, player will spawn/teleport back to his
// current location instead.
    self.origin     = self.oldorigin    = spot.origin + '0 0 1';
    self.angles     = spot.angles;
    self.fixangle   = TRUE;

// set modelindex
// NOTE:  modelindex hack already done at 'worldspawn'.
    setmodel (self, "progs/player.mdl");
    setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);

    self.view_ofs   = '0 0 22';
    self.velocity   = '0 0 0';

    player_run ();

    if (deathmatch || coop)
    {
        makevectors (self.angles);
        spawn_tfog (self.origin + v_forward*20);
        if (deathmatch)
        {   // Give three second invulnerability in DM.
            // Note:  Does not protect against Buriza.  No biggie though.
            self.items = self.items | IT_PROTECT;
            self.invincible_finished = time + 3;
            self.invincible_time = time + 1;    // Suppress 3 sec. warning.
        }
    }
    spawn_tdeath (self.origin, self);
};

// Update 5/18/10:  Chaos Device.
float(entity who) Use_ChaosDevice =
{
    if (who)
    {
        local   entity  spot;
        local   vector  vel;
        local   float   sped;

        // FIXME:  Assumes client.  What if it's a monster?
        spot = SelectSpawnPoint();
        if (spot)
        {
            vel = who.velocity;  vel_z = 0;
            sped = vlen(vel);
            if (sped > 300)
                sped = 300;

            spawn_tfog (who.origin);
            makevectors (spot.angles);
            who.velocity    = v_forward * sped;
            who.angles      = spot.angles;
            who.fixangle    = TRUE;
            who.flags       = who.flags - (who.flags & FLx_JUMP_READY);
            who.oldorigin   = spot.origin + '0 0 1';    // Don't bounce back!
            // FIXME:  setorigin may cause problems if called during
            // a touch func or T_RadiusDamage call.
            setorigin (who, who.oldorigin);
            spawn_tfog (who.origin + v_forward*20);
            spawn_tdeath (who.origin, who);
            return TRUE;
        }
    }
    return FALSE;
};

//==========================================================================

//===========
// ClientConnect
//
// called when a player connects to a server
//============
void() ClientConnect =
{
    ClientInRankings();     // FrikBot

    bprint (self.netname);
    bprint (" entered the game\n");

// A client connecting during an intermission can cause problems.
    if (intermission_running)
        ExitIntermission ();
};

//===========
// ClientDisconnect
//
// called when a player disconnects from a server
//============
void() ClientDisconnect =
{
//    if (self.ishuman)
//        clientSetFree( self.fClientNo ); // FrikBot
    ClientDisconnected(); // FrikBot

    if (gameover)
        return;
    // if the level end trigger has been activated, just return
    // since they aren't *really* leaving

//- - - - - - - - -
// Remove targeting sights and minions.
    Pets_Free (self);
    key_recover ();
//- - - - - - - - -
    // let everyone else know
    bprint (self.netname);
    bprint (" left the game with ");
    bprint (ftos(self.frags));
    bprint (" frags\n");
    sound (self, CHAN_BODY, "player/tornoff2.wav", 1, ATTN_NONE);
    set_suicide_frame ();
};


//===========================/  END OF FILE  /===========================//

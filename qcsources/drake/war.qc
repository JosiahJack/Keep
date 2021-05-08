//==========================================================================
//  Status Bar

//============
void(entity who) War_UpdateItems =
{
// There are only seven weapon slots in the sbar.
    if (who.arsenal & WARx_WEAPON1)
        who.items = who.items | 1;
    else
        who.items = who.items - (who.items & 1);
    if (who.arsenal & WARx_WEAPON2)
        who.items = who.items | 2;
    else
        who.items = who.items - (who.items & 2);
    if (who.arsenal & WARx_WEAPON3)
        who.items = who.items | 4;
    else
        who.items = who.items - (who.items & 4);
    if (who.arsenal & WARx_WEAPON4)
        who.items = who.items | 8;
    else
        who.items = who.items - (who.items & 8);
    if (who.arsenal & WARx_WEAPON5)
        who.items = who.items | 16;
    else
        who.items = who.items - (who.items & 16);
    if (who.arsenal & WARx_WEAPON6)
        who.items = who.items | 32;
    else
        who.items = who.items - (who.items & 32);
    if (who.arsenal & WARx_WEAPON7)
        who.items = who.items | 64;
    else
        who.items = who.items - (who.items & 64);
// Hip weapons. - -
    if (who.arsenal & WARx_WEAPON8)
        who.items = who.items | 8388608;
    else
        who.items = who.items - (who.items & 8388608);
    if (who.arsenal & WARx_WEAPON9)
        who.items = who.items | 128;
    else
        who.items = who.items - (who.items & 128);
//- - - - - - - - -
};

//============
// * In Qrack, the weapon field also determines the kind of lights
//  the player spawns when he fires a weapon.  For example, blue sparks
//  when firing a bit 64 weapon, because Qrack assumes Thunderbolt.
// * If Quake is run in mission pack mode, weapon MUST have a
//  non-zero value or else the server will crash!
void(entity who) War_UpdateWeapon =
{
// There are only seven weapon slots in the sbar.
    if (who.war & WARx_WEAPON1)  who.weapon = 1;
    else if (who.war & WARx_WEAPON2)  who.weapon = 2;
    else if (who.war & WARx_WEAPON3)  who.weapon = 4;
    else if (who.war & WARx_WEAPON4)  who.weapon = 8;
    else if (who.war & WARx_WEAPON5)  who.weapon = 16;
    else if (who.war & WARx_WEAPON6)  who.weapon = 32;
    else if (who.war & WARx_WEAPON7)  who.weapon = 64;
// The next two use Hipnotic icons if run in -hipnotic mode
    else if (who.war & WARx_WEAPON8)  who.weapon = 8388608;
    else if (who.war & WARx_WEAPON9)  who.weapon = 128;
// The last one is for weapons that do not have a slot icon.
    else  who.weapon = 4096;    // No icon for axe slot, so use that!
};

//============
void(entity e) War_UpdateAll = {War_UpdateItems(e); War_UpdateWeapon(e);};


//==========================================================================
//  Ammo Updates

// This just updates the currentammo on the sbar.  Models are left unchanged.
void() War_UpdateCurrentAmmo =
{
    if (self.form_active)
        return;     // Don't interfere with HUD.

    if (self.items & IT_SHELLS)
        self.currentammo = self.ammo_shells;
    else if (self.items & IT_NAILS)
        self.currentammo = self.ammo_nails;
    else if (self.items & IT_ROCKETS)
        self.currentammo = self.ammo_rockets;
    else if (self.items & IT_CELLS)
        self.currentammo = self.ammo_cells;
    else if (self.war == WAR_BURIZA)
        self.currentammo = self.ammo_super;
// Do nothing if no (or non-standard) ammo.
};

// This is the replacement for W_SetCurrentAmmo.
void() War_SetCurrentAmmo =
{
// Proceed for real.
    if (self.form_active)
        return;     // Don't interfere with HUD.

// Show nothing if no weapon or the weapon is forbidden.
    if ((self.war & legalized) == 0)
    {
        // Play null sound in case the last weapon used was the chainsaw.
        StopSound (self, CHAN_IDLE);
        self.items = self.items - (self.items & ITx_ALL_AMMO);

        self.war = 0;   // Just in case an illegal weapon was selected.
        self.currentammo = 0;
        self.weaponmodel = "";
        self.weaponframe = 0;
        return;
    }

// Done with morphing, now for the other weapons...
//- - - - - - - - -
    // Chainsaw is a special case; check that first.
    if (self.war == WAR_CHAINSAW)
    {
        self.saw_time = time;   // Use T+0.5 if adding startup sound.
        player_run ();        // get out of any weapon firing states
        self.items = self.items - (self.items & ITx_ALL_AMMO);

        self.currentammo = 0;
        self.weaponmodel = "progs/v_saw.mdl";
        self.weaponframe = 0;
// DISABLED -- Chainsaw start sound.  People complain it's loud.
// I like it, but since not using it saves a sound slot, out it goes.
// If adding Zerstorer compatibility later, add sound back for zer* maps.
//        if (!intermission_running)
//        {   // In case of depoly at end-of-level, don't play saw between maps.
//            sound (self, CHAN_IDLE, "weapons/sawidle.wav", 1, ATTN_NORM);
//            self.show_hostile = time + 1;   // It's loud enough to wake the dead.
//        }
        radar_time = 0;     // Reset radar.
        return;
    }
    // Wielding a weapon that isn't the chainsaw...
//- - - - - - - - -
    if (self.saw_time)
    {
        StopSound (self, CHAN_IDLE);    // Silence chainsaw.
        self.saw_time = 0;
    }

    player_run ();        // get out of any weapon firing states

    self.items = self.items - (self.items & ITx_ALL_AMMO);

    self.weaponframe = 0;
    if (self.war == WAR_AXE)
    {
// DISABLED -- With more stuff, unnecessary sounds must be cut!
//        if (soul_evil)      // Audiable sharpness in Soul of Evil only.
//        {
//            if (!deathmatch && !coop)
//                sound (self, CHAN_IDLE, "weapons/unsheath.wav", 1, ATTN_IDLE);
//        }
        self.weaponmodel = "progs/v_axe.mdl";
        radar_time = 0;     // Reset radar.
    }
    else if (self.war == WAR_SHOTGUN)
        self.weaponmodel = "progs/v_shot.mdl";
    else if (self.war == WAR_SUPER_SHOTGUN)
        self.weaponmodel = "progs/v_shot2.mdl";
    else if (self.war == WAR_NAILGUN)
        self.weaponmodel = "progs/v_nail.mdl";
    else if (self.war == WAR_SUPER_NAILGUN)
        self.weaponmodel = "progs/v_nail2.mdl";
    else if (self.war == WAR_GRENADE_LAUNCHER)
        self.weaponmodel = "progs/v_rock.mdl";
    else if (self.war == WAR_ROCKET_LAUNCHER)
        self.weaponmodel = "progs/v_rock2.mdl";
    else if (self.war == WAR_THUNDERBOLT)
        self.weaponmodel = "progs/v_light.mdl";
// Hipnotic
    else if (self.war == WAR_LASER_CANNON)
        self.weaponmodel = "progs/v_laserg.mdl";
    else if (self.war == WAR_MJOLNIR)
    {
        if (self.hammer_finished)
            self.weaponmodel = "";
        else
            self.weaponmodel = "progs/v_hammer.mdl";
    }
// Rogue
    else if (self.war == WAR_GRAPPLE)
    {
        self.weaponmodel = "progs/v_grpple.mdl";
        if (self.hook)
            if (self.hook.count)
                self.weaponframe = 1;   // Hook is still out.
    }
// Other custom weapons.
    else if (self.war == WAR_ZAPPER)
        self.weaponmodel = "progs/v_wand.mdl";
    else if (self.war == WAR_BLASTER)
        self.weaponmodel = "progs/v_laserb.mdl";
    else if (self.war == WAR_SIDEWINDER)
        self.weaponmodel = "progs/v_rocks.mdl";
    else if (self.war == WAR_CHAIN_LIGHTNING)
        self.weaponmodel = "progs/v_light2.mdl";
    else if (self.war == WAR_PLASMA_GUN)
        self.weaponmodel = "progs/v_plasma.mdl";
    else if (self.war == WAR_CRUISE_MISSILE)
        self.weaponmodel = "progs/v_mirv.mdl";
    else if (self.war == WAR_BURIZA)
        self.weaponmodel = "progs/v_xbow.mdl";
    else
    {
        self.war         = 0;       // Invalid weapon.
        self.weaponmodel = "";
    }
//    self.weaponframe = 0;

// Reset currentammo.
    if (self.war & WARx_USES_SHELLS)
    {
        self.currentammo = self.ammo_shells;
        self.items       = self.items | IT_SHELLS;
    }
    else if (self.war & WARx_USES_NAILS)
    {
        self.currentammo = self.ammo_nails;
        self.items       = self.items | IT_NAILS;
    }
    else if (self.war & WARx_USES_ROCKETS)
    {
        self.currentammo = self.ammo_rockets;
        self.items       = self.items | IT_ROCKETS;
    }
    else if (self.war & WARx_USES_CELLS)
    {
        self.currentammo = self.ammo_cells;
        self.items       = self.items | IT_CELLS;
    }
    else if (self.war & WAR_ZAPPER)
    {   self.zapper_time = time;    // Reset charge.
        self.currentammo = 0;
    }
    else if (self.war & WAR_BURIZA)
        self.currentammo = self.ammo_super;
    else
        self.currentammo = 0;
};

/* FIXME:  ???
// Updates grapple viewmodel.
void(entity who) War_GrappleCheck =
{
    if (who.flags & FL_CLIENT)
        if (who.war == WAR_GRAPPLE)
            if (!(who.perms & POW_RUSTY_HOOK))
                who.weaponmodel = "progs/v_grpple.mdl";
};
*/


//==========================================================================
//  Best Weapons

// Update:  Some monsters use this function too.
float(entity who) War_SelectWeapon =
{
    local   float   it, nowater;

    it = who.arsenal & WARx_ALL_WEAPONS;
    if (who.flags & FL_CLIENT)
        it = who.arsenal & legalized;  // Legal weapons only for players.
    nowater = (who.h2olevel <= 1);

    if (who.ammo_cells >= 1)
    {
        if (nowater)
        {
            if (it & WAR_CHAIN_LIGHTNING)
                return WAR_CHAIN_LIGHTNING;
            if (it & WAR_THUNDERBOLT)
                return WAR_THUNDERBOLT;
            if (it & WAR_PLASMA_GUN)
                return WAR_PLASMA_GUN;
        }
        if (it & WAR_LASER_CANNON)
            return WAR_LASER_CANNON;
    }
    if (who.ammo_nails >= 1 && (it & WAR_SUPER_NAILGUN) )
        return WAR_SUPER_NAILGUN;
    if (who.ammo_cells >= 1 && (it & WAR_BLASTER) )
        return WAR_BLASTER;
    if (who.ammo_shells >= 1 && (it & WAR_SUPER_SHOTGUN) )
        return WAR_SUPER_SHOTGUN;
    if (who.ammo_nails >= 1 && (it & WAR_NAILGUN) )
        return WAR_NAILGUN;
    if (who.ammo_shells >= 1 && (it & WAR_SHOTGUN) )
        return WAR_SHOTGUN;

    if (it & WAR_ZAPPER)
        return WAR_ZAPPER;

// PM:  Buriza placed here because the player may accidently shoot and
// waste precious ammo if the weapon changes during a fight.  It also has
// the slowest reload out of all weapons, so a miss can mean death.
    if (who.ammo_super >= 1)
        if (it & WAR_BURIZA)
            return WAR_BURIZA;

//    if (nowater || who.ammo_cells < COST_MJOLNIR)
        if (it & WAR_MJOLNIR)
            return WAR_MJOLNIR;

    if (it & WAR_CHAINSAW)
        return WAR_CHAINSAW;    // In Doom, chainsaw was here.

    if (who.ammo_rockets >= 1)
    {   // Rockets are placed low because of self-destruction.
        if (it & WAR_SIDEWINDER)
            return WAR_SIDEWINDER;      // Less explosive power but safer.
        if (it & WAR_ROCKET_LAUNCHER)
            return WAR_ROCKET_LAUNCHER;
        if (it & WAR_GRENADE_LAUNCHER)
            return WAR_GRENADE_LAUNCHER;
    }
    if (it & WAR_AXE)
        return WAR_AXE;
    if (it & WAR_GRAPPLE)
        return WAR_GRAPPLE;

// The following are really big guns.
    if (who.ammo_rockets >= COST_MIRV && (it & WAR_CRUISE_MISSILE) )
        return WAR_CRUISE_MISSILE;

// The weapons below are suicide when used underwater!
//    if (it & WAR_MJOLNIR)
//        return WAR_MJOLNIR;
    if (who.ammo_cells >= 1)
    {
        if (it & WAR_CHAIN_LIGHTNING)
            return WAR_CHAIN_LIGHTNING;
        if (it & WAR_THUNDERBOLT)
            return WAR_THUNDERBOLT;
        if (it & WAR_PLASMA_GUN)
            return WAR_PLASMA_GUN;
    }

    return 0;   // No weapon left.
};

float() War_BestWeapon = {return War_SelectWeapon (self);};


//============
void() War_FindBestWeapon =
{
    self.war = War_BestWeapon ();
    War_UpdateAll (self);
    War_SetCurrentAmmo ();
};

void(float it) War_Select =
{
    self.war = it;
    War_UpdateAll (self);
    War_SetCurrentAmmo ();    // PM:  Old 'War_Swap' did not have this.
};


//==========================================================================
//  Weapon Inventory Change

// Adds a weapon to the arsenal.  Often called when someone takes a weapon.
void(entity who, float it) War_Add =
{
    who.arsenal = who.arsenal | it;
    who.war = it;
    if (who.flags & FL_CLIENT)
        War_UpdateAll (who);
};

// Removes a weapon from the arsenal.  Called when a gremlin steals a weapon.
void(entity who, float it) War_Remove =
{
    who.arsenal = who.arsenal - (who.arsenal & it);
    if (who.war == it)
    {
        who.war = War_SelectWeapon (who);   // Lost current weapon, find another!
        if (who.flags & FL_MONSTER)
            who.punked = TRUE;      // Stops soldiers from attacking.
    }
    if (who.flags & FL_CLIENT)
    {
        War_UpdateAll (who);
        SUB_Think (who, War_SetCurrentAmmo);
    }
};

// Attempts to steal a weapon from 'targ' and give it to 'who'.
// Returns TRUE if successful.
float(entity who, entity targ, string text) War_Steal =
{
    local   float   best, amount;
    local   string  s;

    best = targ.war;
    if (!targ)
        return FALSE;   // Don't try to change world stats.
    if (targ.xfl & XFL_HUNGRY)
        return FALSE;   // Assume weapons it has were eaten.
    if (!(best & legalized))
        return FALSE;   // Holding no weapon (or one forbidden to PCs).
    if (best & WARx_NO_STEALING)
        return FALSE;   // Not allowed to steal this weapon.
    if (best == targ.arsenal)
        return FALSE;   // Don't steal the last weapon held.

// Theft successful.
    War_Add (who, best);
//- - - - - - - - -
// Take some ammo while we are at it
    if (best & WARx_USES_SHELLS)
    {
        amount = 20;        // FIXME:  Convert shells?
        if (amount > targ.ammo_shells)
            amount = targ.ammo_shells;    // Can steal only what's there.
        targ.ammo_shells = targ.ammo_shells - amount;
        who.currentammo = who.ammo_shells = who.ammo_shells + amount;
    }
    else if (best & WARx_USES_NAILS)
    {
        amount = 40;
        if (amount > targ.ammo_nails)
            amount = targ.ammo_nails;
        targ.ammo_nails = targ.ammo_nails - amount;
        who.currentammo = who.ammo_nails = who.ammo_nails + amount;
    }
    else if (best & WARx_USES_ROCKETS)
    {
        amount = 5;
        if (amount > targ.ammo_rockets)
            amount = targ.ammo_rockets;
        targ.ammo_rockets = targ.ammo_rockets - amount;
        who.currentammo = who.ammo_rockets = who.ammo_rockets + amount;
    }
    else if (best & WARx_USES_CELLS)
    {
        amount = 80;    // Yes, that much no matter the weapon.  40*2=80.
        if (amount > targ.ammo_cells)
            amount = targ.ammo_cells;
        Update_Cells (targ, targ.ammo_cells - amount);
        Update_Cells (who, who.ammo_cells + amount);
        who.currentammo = who.ammo_cells;   // For NPCs.
    }
    else if (best == WAR_BURIZA)
    {
        amount = targ.ammo_super;   // Take all ammo.
        targ.ammo_super = targ.ammo_super - amount;
        who.currentammo = who.ammo_super = who.ammo_super + amount;
    }
// FIXME:  Resolve zapper charge time.
//    else if (best == WAR_ZAPPER)
//    {
//    }
    bind_ammo (who);    // PM:  Make sure ammo stays within limits.
//- - - - - - - - -
    s = weapon_name (best);
    if (who.flags & FLx_CREATURE == FL_CLIENT)
    {
        sprint (who, "You got the ");
        sprint (who, s);
        sprint (who, "\n");
// FIXME:  Add pickup effects.  (Update 10/28/10:  Really?)
    }
    if (targ.flags & FLx_CREATURE == FL_CLIENT)
    {
        if (!text)
            text = "You lost your ";
        sprint (targ, text);
        sprint (targ, s);
        sprint (targ, "\n");
    }
    War_Remove (targ, best);    // Take that weapon from the entity.

    return TRUE;
};


//==========================================================================
//  Dragon Transformation

// This checks if a player-sized entity has enough room to morph into
// a shambler-sized monster.  This check works by creating a dummy entity
// that moves toward the edges of the bigger hull size on behalf of the
// entity.  If any of the move tests fail, the entity does not have the
// room to grow in.  The process is similar to my dragon movement code.
//
// Because this is used only by the transformation code, this function is
// placed here instead of in 'box.qc' with the other Box* functions.
//
// Update 8/14/2010:  Also by dmsp code.
float(entity ent) Box16To32 =
{
    local   entity  box, os;
    local   vector  spot;

    box = spawn();
    setsize (box, VEC_HULL_MIN, VEC_HULL_MAX);
    box.solid       = SOLID_NOT;
    box.movetype    = MOVETYPE_STEP;
    box.flags       = FL_FLY;
    box.owner       = ent;
    box.enemy       = world;    // So walkmove won't move box up or down.

    os = self;
    self = box;

    spot = ent.origin;
    setorigin (self, spot);
    if (!walkmove (0, 16))
        {self = os;  remove(box);  return FALSE;}
    setorigin (self, spot);
    if (!walkmove (90, 16))
        {self = os;  remove(box);  return FALSE;}
    setorigin (self, spot);
    if (!walkmove (180, 16))
        {self = os;  remove(box);  return FALSE;}
    setorigin (self, spot);
    if (!walkmove (270, 16))
        {self = os;  remove(box);  return FALSE;}
    setorigin (self, spot);
    if (!walkmove (45, 22))     // 16*1.4142=22.6...
        {self = os;  remove(box);  return FALSE;}
    setorigin (self, spot);
    if (!walkmove (135, 22))
        {self = os;  remove(box);  return FALSE;}
    setorigin (self, spot);
    if (!walkmove (225, 22))
        {self = os;  remove(box);  return FALSE;}
    setorigin (self, spot);
    if (!walkmove (315, 22))
        {self = os;  remove(box);  return FALSE;}

    spot = spot + '0 0 32';
    setorigin (self, spot);
    if (!walkmove (0, 16))
        {self = os;  remove(box);  return FALSE;}
    setorigin (self, spot);
    if (!walkmove (90, 16))
        {self = os;  remove(box);  return FALSE;}
    setorigin (self, spot);
    if (!walkmove (180, 16))
        {self = os;  remove(box);  return FALSE;}
    setorigin (self, spot);
    if (!walkmove (270, 16))
        {self = os;  remove(box);  return FALSE;}
    setorigin (self, spot);
    if (!walkmove (45, 22))
        {self = os;  remove(box);  return FALSE;}
    setorigin (self, spot);
    if (!walkmove (135, 22))
        {self = os;  remove(box);  return FALSE;}
    setorigin (self, spot);
    if (!walkmove (225, 22))
        {self = os;  remove(box);  return FALSE;}
    setorigin (self, spot);
    if (!walkmove (315, 22))
        {self = os;  remove(box);  return FALSE;}

    self = os;
    remove (box);

    return TRUE;
};

// Check if the player has enough room to transform.  If not, the player
// has no room and TRUE is returned.
float(entity ent) Transform_Ok =
{
    if (cutscene)
        return FALSE;       // Not while player is posing as a camera.

    if (ent.movetype != MOVETYPE_NOCLIP)
    {
    // We can't use a trigger similar to tdeath because that only works
    // at the next frame, and we need something now!
        if (ent.maxs_x <= 16)
        {
            if (!Box16To32 (ent))
                return FALSE;   // Test move blocked.
            // The next two are insurance in case the first check fails.
            if (BoxInWall (VEC_HULL2_MIN, VEC_HULL2_MAX, ent.origin))
                return FALSE;   // Blocked by walls.
            if (BoxInThing (VEC_HULL2_MIN, VEC_HULL2_MAX, ent.origin, ent))
                return FALSE;   // Blocked by monsters or other solid.
        }
        // ELSE we are already big and fat, so no need to check.
    }
    return TRUE;    // All clear!
};

// Transforms player into some creature.
void(entity ent) War_Transform =
{
    if ((ent.flags & FLx_CREATURE) != FL_CLIENT)
        return;     // Only players may transform.

    local   float   flies, ofa;

    flies = FALSE;
    ofa = ent.form_active;

    if (!intermission_running)
    {
        StopSound (ent, CHAN_IDLE);     // Stop chainsaw sfx.
        spawn_tfog (ent.origin);
    }

    ent.walkframe = 0;
    ent.resist_fire = ent.resist_cold = 0;
    ent.form_active = !ent.form_active;     // Toggle -- assume morph armor.
    if (ent.form_active)
    {   // Monster form.
        {   // Fire dragon.
            flies = TRUE;
            ent.form_active = FORM_DRAGON;
            ent.velocity    = '0 0 0';
            ent.view_ofs_x  = 0;
            ent.view_ofs_y  = 0;
            ent.view_ofs_z  = BAHA_VIEW;
            ent.resist_fire = 0.5;      // Check 'ryu.qc' for red dragon resists.
            ent.resist_cold = -0.5;     // Ditto.
            ent.xfl         = ent.xfl | XFL_GHOUL;
            ent.gib_health  = -60;
            ent.mass        = MASS_LIGHT;   // Big as a condor.
            setsize (ent, '-32 -32 -24', '32 32 32');
            // Note:  Engine moves things this big with VEC_HULL2_xxx bbox.
    
            // PM:  Don't want baha_* fields here, but where else is better?
            ent.baha_time   = time;
            ent.baha_click  = 0;    // Reset attack mode.
            // Reset weapon stats.
            ent.items = ent.items - (ent.items & ITx_ALL_AMMO);
            ent.currentammo = ent.baha_ammo = MAX_BAHA_AMMO;    // Max ammo now.
            ent.weaponmodel = "";

            ent.weaponframe = 0;
            SUB_Think (ent, player_run);    // get out of any weapon firing states
        }
    }
    else
    {   // Human form.
        ent.baha_time   = 0;    // Disable automatic morph.
        ent.form_active = 0;    // Normal human form.
        ent.view_ofs    = '0 0 22';
        ent.xfl         = ent.xfl - (ent.xfl & (XFL_GHOUL|XFL_IMMUNITY));
        ent.gib_health  = -40;
        ent.mass        = MASS_MEDIUM;
        setsize (ent, VEC_HULL_MIN, VEC_HULL_MAX);

        // Restore weapon stats.
        SUB_Think (ent, War_SetCurrentAmmo);
    }
    // Set appropriate movetype if necessary.
    if (flies)
    {   if (ent.movetype == MOVETYPE_WALK)
            ent.movetype    = MOVETYPE_FLY;
    }
    else
    {   if (ent.movetype == MOVETYPE_FLY)
            ent.movetype    = MOVETYPE_WALK;
    }
    // Turn icons on/off as needed to stop unnecessary lights in ports.
    War_UpdateWeapon (ent);

// Formerly enforced a brief delay after transformation.
// Do that only if triggered by impulse, and in the impulse code.
};


//===========================/  END OF FILE  /===========================//

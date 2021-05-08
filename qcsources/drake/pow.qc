//==========================================================================
//  Water Works

//------------------------------------------------------------------------//
//  This sets an entity's waterlevel and watertype in a way similar to
//  the C code.
//------------------------------------------------------------------------//
void(entity ent) Water_Set =
{
    local   vector  spot;

    spot = ent.origin;
    spot_z = spot_z + ent.mins_z + 1;
    ent.h2otype = pointcontents (spot);
    if (ent.h2otype <= CONTENT_WATER)
    {
        ent.h2olevel = 1;
        spot_z = ent.origin_z + (ent.mins_z + ent.maxs_z) * 0.5;
        if (pointcontents (spot) <= CONTENT_WATER)
        {
            ent.h2olevel = 2;
            spot_z = ent.origin_z + ent.view_ofs_z;
            if (pointcontents (spot) <= CONTENT_WATER)
                ent.h2olevel = 3;
        }
    }
    else
        ent.h2olevel = 0;
};


//==========================================================================
//  Movement

void(entity ent) WaterRise =
{
    if (ent.h2otype == CONTENT_WATER)
        ent.velocity_z = 100;
    else if (ent.h2otype == CONTENT_SLIME)
        ent.velocity_z = 80;
    else
        ent.velocity_z = 50;

// Play swimming sound
    if (ent.swim_flag < time)
    {
        ent.swim_flag = time + 1;
        if (random() < 0.5)
            sound (ent, CHAN_BODY, "misc/water1.wav", 1, ATTN_NORM);
        else
            sound (ent, CHAN_BODY, "misc/water2.wav", 1, ATTN_NORM);
    }
};

void() PlayerJump =
{
    if (self.flags & FL_WATERJUMP)
        return;

    if (self.h2olevel >= 2)
        {WaterRise (self); return;}

// Levitation - - - - - - - - - - - - -
    if (self.wing_finished)
    {
        if (self.wing_sound <= time)
        {
            if (powcache & PCH_WING_USE)
                sound (self, CHAN_AUTO, "items/levitate.wav", 1, ATTN_NORM);
            self.wing_sound = time + 1;
        }
    // Gravity reversal was the simplest method to implement.
    // Using fancy math to get reverse standard gravity can cause problems
    // if the player gets hit with other effects that change gravity field.
        self.gravity = 0 - fabs(self.gravity);
        return;
    }
//- - - - - - - - - - - - - - - - - - -

    // 'JumpReady' is both onground and jumpreleased.  Check 'defs.qc'.
    if ((self.flags & FLx_JUMP_READY) != FLx_JUMP_READY)
        return;     // don't stairwalk (onground) or pogo stick (jumpreleased)
    self.flags = self.flags - FLx_JUMP_READY;

    self.button2 = 0;
    if (self.curse_type == CURSE_SLOW)  // FIXME:  Any other slow source too?
    {   // Too decrepid to jump.
        if (self.pain_finished <= time)
        {
            T_NewDamage (self, world, world, 1, 0, "falling");
            sound (self, CHAN_VOICE, "player/land2.wav", 1, ATTN_NORM);
        }
        return;
    }
//    if (self.form_active)
//    {
//        if (self.form_active == FORM_SCORPIO)
//        {   // Uses chan_body for walk sound, so use chan_voice for jumping.
//            sound (self, CHAN_VOICE, "scourge/idle.wav", 1, ATTN_NORM);
//        }
//    }
//    else
        sound (self, CHAN_BODY, "player/plyrjmp8.wav", 1, ATTN_NORM);
    if (Armor_Exotic (self) == SUIT_NINJA)
        self.velocity_z = self.velocity_z + 540;    // Wearing high jump suit.
    else
        self.velocity_z = self.velocity_z + 270;
    self.jump_time = time;      // Update 8/20/09:  Jump pad.
};

void() CheckWaterJump =
{
    local   vector  start, end;

// check for a jump-out-of-water
    makevectors (self.angles);
    start = self.origin;
    start_z = start_z + 8; 
    v_forward_z = 0;
    normalize(v_forward);
    // PM:  Use 'maxs_x + 8' instead of 24 in case of big monster morphs.
    end = start + v_forward*(self.maxs_x+8);    //24;
    traceline (start, end, TRUE, self);
    if (trace_fraction < 1)
    {    // solid at waist
        start_z = start_z + self.maxs_z - 8;
        end = start + v_forward*(self.maxs_x+8);    //24;
        self.movedir = trace_plane_normal * -50;
        traceline (start, end, TRUE, self);
        if (trace_fraction == 1)
        {    // open at eye level
            self.flags = self.flags | FL_WATERJUMP;
            self.velocity_z = 225;
            self.flags = self.flags - (self.flags & FL_JUMPRELEASED);
            self.teleport_time = time + 2;    // safety net
            return;
        }
    }
};


//============
//- - - - - - - - - - - - - - - - - - -
// This resets air capacity and drowning damage.
void(entity ent) more_air =
{
//- - - - - - - - -
// In Quake2, swimming monsters only had nine seconds of air out of water.
//
// I could use variable air capacities for different entities.  For example,
// 9 seconds for fish, 12 for players, or 30 for dragons.  However, with the
// KISS principle in mind, everything that needs air has 12 seconds of air,
// and those who don't need air will have that dealt elsewhere.
//- - - - - - - - -
    ent.air_finished = time + 12;
    ent.dmg = 2;        // initial water damage
};

void(entity ent) Drown =
{
    if (ent.pain_finished < time)
    if (!ent.cross_finished)      // Cross of Deflection prevents drowning.
    {
        local   string  text;

        if (ent.h2otype == CONTENT_LAVA)
            text = "lava";
        else if (ent.h2otype == CONTENT_SLIME)
            text = "slime";
        else if (ent.h2otype == CONTENT_WATER)
            text = "water";
        else
            text = "";

        ent.dmg = ent.dmg + 2;
        if (ent.dmg > 15)
            ent.dmg = 10;
        T_NewDamage (ent, world, world, ent.dmg, DF_NO_ARMOR, text);
        ent.pain_finished = time + 1;
    }
};
//- - - - - - - - - - - - - - - - - - -
// Moved 'dmgtime' to entity.qc.

void(entity ent) WaterSwim =
{
    if (ent.movetype == MOVETYPE_NOCLIP)
        return;
    if (ent.takedamage)
    {   if (ent.health < ent.gib_health)  // Let slime/lava burn to the bone.
            return;
    }
    else
    {   if (ent.health <= 0)
            return;
    }

// C code doesn't set water stuff to proper values if entity is not a walk
// type -- make it so!  It is okay to set them early because waterlevel/type
// is set before thinking and movement.
    Water_Set (ent);

    if (ent.health > 0)
    if (!(ent.xfl & XFL_NO_AIR))  // Not all creatures need air to live.
    {
// PM:  Commented out suffocation for fish out of water because said
// fish are suspended in mid-air, which looks really bad.  Until that
// is fixed, it is assumed fish are always in the water, and suffocation
// check for fish isn't necessary.
//        if (ent.xfl & XFL_WATER)
//        {   // Water-breather.
//            if (ent.h2olevel)
//                more_air (ent);
//            else if (ent.air_finished < time)
//                Drown (ent);
//        }
//        else
        {   // Air-breather.
            if (ent.h2olevel != 3)
            {
                if (ent.classname == "player")
                    if (!ent.deadflag)      // Don't croak if dead!
                {
                    if (ent.form_active == FORM_DRAGON)
                    {   // In dragon form.
                        if (ent.air_finished < time)
                            sound (ent, CHAN_VOICE, "dragon/idle2.wav", 1, ATTN_NORM);
                    }
//                    else if (ent.form_active == FORM_SCORPIO)
//                    {
//                        if (ent.air_finished < time)
//                            sound (ent, CHAN_VOICE, "scourge/idle.wav", 1, ATTN_NORM);
//                    }
                    else
                    {   // In human form.
                        if (ent.air_finished < time)
                            sound (ent, CHAN_VOICE, "player/gasp2.wav", 1, ATTN_NORM);
                        else if (ent.air_finished < time + 9)
                            sound (ent, CHAN_VOICE, "player/gasp1.wav", 1, ATTN_NORM);
                    }
                }
                more_air (ent);
            }
            else if (ent.air_finished < time)
            {    // drown!
                Drown (ent);
            }
        }
    }
    
    if (!ent.h2olevel)
    {
        if (ent.flags & FL_INWATER)
        {    
            // play leave water sound
            sound (ent, CHAN_BODY, "misc/outwater.wav", 1, ATTN_NORM);
            ent.flags = ent.flags - FL_INWATER;
        }
        return;
    }

    if (ent.h2otype == CONTENT_LAVA)
    {    // do damage
//        if (!(ent.flags & FL_IMMUNE_LAVA))
        if (!ent.cross_finished)    // Cross of Deflection repels lava.
        if (ent.resist_fire != 1)
        if (ent.dmgtime < time)
        {
            if (ent.takedamage)
                if (ent.resist_fire < 1)
                    MakeFlame (ent);
            T_NewDamage (ent, world, world, 10*ent.h2olevel, DF_FIRE | DF_SCAR, "lava");
            if (ent.radsuit_finished)
                ent.dmgtime = time + 1;
            else
                ent.dmgtime = time + 0.2;
        }
    }
    else if (ent.h2otype == CONTENT_SLIME)
    {    // do damage
//        if (!(ent.flags & FL_IMMUNE_SLIME))
        if (!(ent.xfl & (XFL_ZOMBIE | XFL_SLIMER)))
        if (!ent.radsuit_finished)  // Biosuit repels slime.
        if (!ent.cross_finished)    // Cross of Deflection repels slime.
        if (ent.resist_acid != 1)
        if (ent.dmgtime < time)
        {
            T_NewDamage (ent, world, world, 4*ent.h2olevel, DF_ACID, "slime");
            ent.dmgtime = time + 1;
        }
    }
    // else if in water, melt things like fire elementals and green witches.
    
    if ( !(ent.flags & FL_INWATER) )
    {    
// player enter water sound
        if (ent.h2otype == CONTENT_LAVA)
            sound (ent, CHAN_BODY, "player/inlava.wav", 1, ATTN_NORM);
        if (ent.h2otype == CONTENT_WATER)
            sound (ent, CHAN_BODY, "player/inh2o.wav", 1, ATTN_NORM);
        if (ent.h2otype == CONTENT_SLIME)
            sound (ent, CHAN_BODY, "player/slimbrn2.wav", 1, ATTN_NORM);

        ent.flags = ent.flags + FL_INWATER;
        ent.dmgtime = 0;
    }
    
    if (! (ent.flags & FL_WATERJUMP) )
        ent.velocity = ent.velocity - 0.8*ent.h2olevel*frametime*ent.velocity;
};

//void() WaterMove = {WaterSwim (self);};
//- - - - - - - - - - - - - - - - - - -

void() FallingStuff =
{
    if (self.jump_flag < -300)
    if (self.flags & FL_ONGROUND)
    if (self.health > 0)
    if (self.movetype != MOVETYPE_FLY)
    {
        if (self.h2otype == CONTENT_WATER)
        {
            sound (self, CHAN_BODY, "player/h2ojump.wav", 1, ATTN_NORM);
        }
    // Use Quake2's method of calculating falling damage.
        if (self.h2olevel == 3)
            self.jump_flag = 0;     // Take no damage.
        else if (self.h2olevel == 2)
            self.jump_flag = self.jump_flag * 0.25;
        else if (self.h2olevel == 1)
            self.jump_flag = self.jump_flag * 0.5;

// FIXME:  Use global set by worldspawn.
    // Chthon map hack:  Don't take falling damage from the big plunge.
    // Otherwise, the new falling rules will cause 70+ damage -- too much!
//        if (world.model == "maps/e1m7.bsp")
//            if (self.origin_z < -776)
//                if (self.jump_flag < -500)
//                    self.jump_flag = -500;

        if (self.form_active)
        {   // Monster forms are immune to falling damage.
            if (self.jump_flag < -300)
                sound (self, CHAN_VOICE, "demon/dland2.wav", 1, ATTN_NORM);
        }
        else if (self.jump_flag < -650)
        {
            local   float   damage;

            if (cranked)
            {
                damage = (-600 - self.jump_flag) * 0.1;
                damage = floor(damage);
                if (damage < 1)
                    damage = 1;
            }
            else
                damage = 5;
            T_NewDamage (self, world, world, damage, 0, "falling");
            if (self.health > 0)
                sound (self, CHAN_VOICE, "player/land2.wav", 1, ATTN_NORM);
        }
        else if (self.jump_flag < -300)
        {
            sound (self, CHAN_VOICE, "player/land.wav", 1, ATTN_NORM);
        }

        self.jump_flag = 0;
    }

    if (!(self.flags & FL_ONGROUND))
    {
//- - - - - - - - -
        if (self.velocity_z < -500)
        {
            if (world.model == "maps/e1m7.bsp")
            {
                if (world.message == "The House of Chthon")
                    if (self.origin_z < -776)
                        self.velocity_z = -500;
            }
            else if (soul_evil)
            {
                if (world.model == "maps/nsoe4.bsp")
                {   // This map has much falling and teleporting, so add this
                    // wind hack to cut the player a break.
                    if (self.origin_z < -448)
                    {
                        self.velocity_z = -500;
                        if (self.flags & FL_CLIENT)
                        {
                            if (!(self.perms & POW_HINT_FALL))
                            {   // First time activating the hack.
                                self.perms = self.perms | POW_HINT_FALL;
                                sound (self, CHAN_VOICE, "misc/talk.wav", 1, ATTN_NORM);
                                centerprint (self, "A strong wind slows your descent.");
                            }
                        }
                        if (self.fly_sound < time)
                        {
                            self.fly_sound = time + 1.5;
                            sound (self, CHAN_AUTO, "ambience/windfly.wav", 1, ATTN_NORM);
                        }
                    }
                }
            }
        }
//- - - - - - - - -
        self.jump_flag = self.velocity_z;   // Falling.
    }
};


//==========================================================================
//  Wetsuit

// DISABLED:  SoE doesn't use wetsuit effects.
//void() Wetsuit_Fx =
//{
//    // Originally did breathing sounds at level 2.  Not so anymore.
//    if (self.swim_flag < time)
//    {
//        self.swim_flag = time + 7;
//        if (powcache & PCH_SCUBA_USE)
//            sound (self, CHAN_BODY, "misc/wetsuit.wav", 1, ATTN_NORM);
//    }
//    // PM:  Lowered some times from 0.04 to reduce bubble spam.
//    else if (fabs(self.swim_flag - time - 6) < 0.04)
//        MakeBubble (self);
//    else if (fabs(self.swim_flag - time - 5.5) < 0.02)
//        MakeBubble (self);
//    else if (fabs(self.swim_flag - time - 5) < 0.02)
//        MakeBubble (self);
//};

void() Wetsuit_PreThink =
{
    if (self.radsuit_finished)
    {
        if (self.h2olevel == 2)
            self.velocity = self.velocity * 1.25;
        else if (self.h2olevel == 3)
        {
            self.velocity = self.velocity * 1.5;
//            Wetsuit_Fx ();
        }
    }
};

void() Wetsuit_PostThink =
{
    if (self.radsuit_finished)
    {
        if (self.h2olevel == 2)
            self.velocity = self.velocity * 0.8;
        if (self.h2olevel == 3)
            self.velocity = self.velocity * 0.66;
    }
};


//==========================================================================
//  Powerups

//================
// CheckArtifacts (formerly CheckPowerups)
//
// Check for turning off powerups
//================
void(entity ent) CheckArtifacts =
{
    if (ent.health <= 0)
        return;

// NOTE:  Check times instead of item flags for the following reasons:
// 1)  Standard progs did it that way.
// 2)  Custom maps might use them to powerup various monsters.
// 3)  Toggle item flags on and off so that color flash and item icon blink.

// Invisibility ------------------------
    if (ent.invisible_finished)
    {
        // Make the player mumble gibberish while cloaked.
        if (ent.invisible_sound < time)
        {
            if (powcache & PCH_INVISO_USE)      // Precache check.
                if (Armor_Exotic (ent) != SUIT_SPIRIT)   // Spirit armor suppresses sound.
                    sound (ent, CHAN_AUTO, "items/inv3.wav", 0.5, ATTN_IDLE);
            ent.invisible_sound = time + ((random() * 3) + 1);
        }

        if (ent.invisible_finished < time + 3)
        {
            // sound and screen flash when items starts to run out
            if (ent.invisible_time < time)
            {
                if (!ent.invisible_time)
                {
                    Safe_sprint (ent, "Ring of Shadows magic is fading\n");
    // Disabled sound "items/inv2.wav".  What good is invisibility if the
    // enemy can find you via hearing because the ring sounded a loud alarm?
                }
                // Blink item icon.
                if (ent.items & IT_INVISO)
                    ent.items = ent.items - IT_INVISO;
                else
                    ent.items = ent.items | IT_INVISO;
                ent.invisible_time = time + 0.5;
            }

            if (ent.invisible_finished < time)
            {    // just stopped
                ent.items = ent.items - (ent.items & IT_INVISO);
                ent.invisible_finished = 0;
                ent.invisible_time = 0;
            }
        }

    // use invisible model, which has 256 frames.  (No need to set frame.)
        ent.modelindex = mindex_inviso;
    }
    else
    {   // don't use invisible model
        if (ent.flags & FL_MONSTER)
            ent.modelindex = ent.mindex2;
        //- - - The rest below is for players. - - -
        else if (ent.form_active)
//        {   if (ent.form_active == FORM_SCORPIO)
//                ent.modelindex = mindex_scorpio;
//            else
                ent.modelindex = mindex_dragon;
//        }
        else if (mindex_hammer && ent.war == WAR_MJOLNIR)
        {
            if (ent.hammer_finished)
                ent.modelindex = mindex_hamout;
            else
                ent.modelindex = mindex_hammer;
        }
        else if (mindex_saw && ent.war == WAR_CHAINSAW)
            ent.modelindex = mindex_saw;
        else
            ent.modelindex = mindex_player;
    }

// Invincibility -----------------------
    if (ent.invincible_finished)
    {
        if (ent.invincible_finished < time + 3)
        {
            // sound and screen flash when items starts to run out
            if (ent.invincible_time < time)
            {
                if (!ent.invincible_time)
                {
                    Safe_sprint (ent, "Protection is almost burned out\n");
                    if (powcache & PCH_PROTECT_END)
                        sound (ent, CHAN_AUTO, "items/protect2.wav", 1, ATTN_NORM);
                }
                if (ent.items & IT_PROTECT)
                    ent.items = ent.items - IT_PROTECT;
                else
                    ent.items = ent.items | IT_PROTECT;
                ent.invincible_time = time + 0.5;
            }

            if (ent.invincible_finished < time)
            {    // just stopped
                ent.items = ent.items - (ent.items & IT_PROTECT);
                ent.invincible_finished = 0;
                ent.invincible_time = 0;
            }
        }
        
        if (ent.invincible_finished > time)
            ent.effects = ent.effects | EF_DIMLIGHT;
        else
            ent.effects = ent.effects - (ent.effects & EF_DIMLIGHT);
    }

// Super Damage ------------------------
    if (ent.super_damage_finished)
    {
        if (ent.super_damage_finished < time + 3)
        {
            // sound and screen flash when items starts to run out
            if (ent.super_time < time)
            {
                if (!ent.super_time)
                {
                    Safe_sprint (ent, "Quad Damage is wearing off\n");
                    if (powcache & PCH_QUAD_END)
                        sound (ent, CHAN_AUTO, "items/damage2.wav", 1, ATTN_NORM);
                }
                if (ent.items & IT_QUAD)
                    ent.items = ent.items - IT_QUAD;
                else
                    ent.items = ent.items | IT_QUAD;
                ent.super_time = time + 0.5;
            }

            if (ent.super_damage_finished < time)
            {   // just stopped
                ent.items = ent.items - (ent.items & IT_QUAD);
                ent.super_damage_finished = 0;
                ent.super_time = 0;
            }
        }

        if (ent.super_damage_finished > time)
            ent.effects = ent.effects | EF_DIMLIGHT;
        else
            ent.effects = ent.effects - (ent.effects & EF_DIMLIGHT);
    }    

// Suit --------------------------------
    if (ent.radsuit_finished)
    {
        more_air (ent);    // don't drown

        if (ent.radsuit_finished < time + 3)
        {
            // sound and screen flash when items starts to run out
            if (ent.rad_time < time)
            {
                if (!ent.rad_time)
                {
                    Safe_sprint (ent, "Air supply in Biosuit expiring\n");
                    if (powcache & PCH_SUIT_END)
                        sound (ent, CHAN_AUTO, "items/suit2.wav", 1, ATTN_NORM);
                }
                if (ent.items & IT_SUIT)
                    ent.items = ent.items - IT_SUIT;
                else
                    ent.items = ent.items | IT_SUIT;
                ent.rad_time = time + 0.5;
            }

            if (ent.radsuit_finished < time)
            {   // just stopped
                ent.items = ent.items - (ent.items & IT_SUIT);
                ent.radsuit_finished = 0;
                ent.rad_time = 0;
            }
        }
    }    

// Empathy Shields ---------------------
    if (ent.thorns_finished)
    {
        if (ent.thorns_finished < time + 3)
        {
            // sound and screen flash when items starts to run out
            if (ent.thorns_time < time)
            {
                if (!ent.thorns_time)
                {
                    Safe_sprint (ent, "Empathy Shields are collapsing\n");
                    if (powcache & PCH_SUIT_END)
                        sound (ent, CHAN_AUTO, "items/suit2.wav", 1, ATTN_NORM);
                }
                ent.thorns_time = time + 1;
                Safe_stuffcmd (ent, "bf\n");
            }

            if (ent.thorns_finished < time)
            {   // just stopped
                ent.thorns_finished = 0;
                ent.thorns_time     = 0;
            }
        }

        if (ent.thorns_finished > time)
            ent.effects = ent.effects | EF_DIMLIGHT;
        else
            ent.effects = ent.effects - (ent.effects & EF_DIMLIGHT);
    }    

// Cross of Deflection -----------------
    if (ent.cross_finished)
    {
        if (ent.cross_finished < time + 3)
        {
            // sound and screen flash when items starts to run out
            if (ent.cross_time < time)
            {
                if (!ent.cross_time)
                {
                    Safe_sprint (ent, "Cross of Deflection is fading\n");
                    if (powcache & PCH_CROSS_END)
                        sound (ent, CHAN_AUTO, "items/crosend.wav", 1, ATTN_NORM);
                }
//                ent.cross_time = time + 1;
//                Safe_stuffcmd (ent, "bf\n");
                if (ent.items2 & IT2_SHIELDS)
                {   Safe_stuffcmd (ent, "bf\n");
                    ent.items2 = (ent.items2 - IT2_SHIELDS) | ((serverflags & 12) * IT2_RUNE1);
                }
                else
                    ent.items2 = (ent.items2 - (ent.items2 & IT2x_RUNES34)) | IT2_SHIELDS;
                ent.cross_time = time + 0.5;
            }

            if (ent.cross_finished < time)
            {   // just stopped
                ent.items2 = (ent.items2 - (ent.items2 & IT2_SHIELDS)) | ((serverflags & 12) * IT2_RUNE1);
                ent.cross_finished = 0;
                ent.cross_time     = 0;
            }
        }

        if (ent.cross_finished > time)
            ent.effects = ent.effects | EF_DIMLIGHT;
        else
            ent.effects = ent.effects - (ent.effects & EF_DIMLIGHT);
    }    

// Levitation --------------------------
    if (ent.wing_finished)
    {
    //- - - - - - - - -
        // Levitation item also bestows feather fall.
        if (ent.velocity_z < -300)
            if (IsFalling (ent))
            {   // Feather fall.
                //particle (ent.origin + '0 0 -23', '0 0 -30', 9, 5);
                ent.velocity_z = -300;
            }
    //- - - - - - - - -
        if (ent.wing_finished < time + 3)
        {
            // sound and screen flash when items starts to run out
            if (ent.wing_time < time)
            {
                if (!ent.wing_time)
                {   // "Your wings grow weary\n"
                    Safe_sprint (ent, "Boots of Levitation are fading\n");
                    if (powcache & PCH_WING_END)
                        sound (ent, CHAN_AUTO, "ambience/wingend.wav", 1, ATTN_NORM);
                }
                ent.wing_time = time + 1;
                Safe_stuffcmd (ent, "bf\n");
            }

            if (ent.wing_finished < time)
            {   // just stopped
                ent.wing_finished = 0;
                ent.wing_time     = 0;
                ent.gravity       = fabs(ent.gravity);
            }
        }
    }

// Reflection --------------------------
    if (ent.mirror_finished)
    {
        if (ent.mirror_finished < time + 3)
        {
            // sound and screen flash when items starts to run out
            if (ent.mirror_time < time)
            {
                if (!ent.mirror_time)
                {
                    Safe_sprint (ent, "Amulet of Reflection is failing\n");
                    if (powcache & PCH_MIRROR_END)
                        sound (ent, CHAN_AUTO, "items/reflect2.wav", 1, ATTN_NORM);
                }
                // Toggle particle field on and off when fading.
                if (ent.effects & EF_BRIGHTFIELD)
                    ent.effects = ent.effects - EF_BRIGHTFIELD;
                else
                    ent.effects = ent.effects | EF_BRIGHTFIELD;
                ent.mirror_time = time + 0.5;
            }

            if (ent.mirror_finished < time)
            {    // just stopped
                ent.mirror_finished = 0;
                ent.mirror_time = 0;
                ent.mirror_ping = 0;
            }
        }
        
        if (ent.mirror_finished > time)
        {
            if (!ent.mirror_time)
                ent.effects = ent.effects | EF_BRIGHTFIELD;
        }
        else
            ent.effects = ent.effects - (ent.effects & EF_BRIGHTFIELD);
    }
    // This check is here for necroshield or mirror powerup.
    if (ent.effects & EF_BRIGHTFIELD)
    {
        if (ent.mirror_ping < time)
        {
            ent.mirror_ping = time + 0.1;
            ReflectorShield (ent);
        }
    }

// Tome of Power -----------------------
    if (ent.tome_finished)
    {
        if (ent.tome_finished < time + 3)
        {
            // sound and screen flash when items starts to run out
            if (ent.tome_time < time)
            {
                if (!ent.tome_time)
                {
                    Safe_sprint (ent, "Tome of Power is fading\n");
                    if (powcache & PCH_QUAD_END)
                        sound (ent, CHAN_AUTO, "items/damage2.wav", 1, ATTN_NORM);
                }
//                ent.tome_time = time + 1;
//                Safe_stuffcmd (ent, "bf\n");
                if (ent.items2 & IT2_WETSUIT)
                {   Safe_stuffcmd (ent, "bf\n");
                    ent.items2 = (ent.items2 - IT2_WETSUIT) | ((serverflags & 3) * IT2_RUNE1);
                }
                else
                    ent.items2 = (ent.items2 - (ent.items2 & IT2x_RUNES12)) | IT2_WETSUIT;
                ent.tome_time = time + 0.5;
            }

            if (ent.tome_finished < time)
            {   // just stopped
                ent.items2 = (ent.items2 - (ent.items2 & IT2_WETSUIT)) | ((serverflags & 3) * IT2_RUNE1);
                ent.tome_finished = 0;
                ent.tome_time = 0;
            }
        }

//        if (ent.tome_finished > time)
//            ent.effects = ent.effects | EF_DIMLIGHT;
//        else
//            ent.effects = ent.effects - (ent.effects & EF_DIMLIGHT);
    }

// Curses ------------------------------
    local   float   slowed;

    slowed = 0;
    if (ent.curse_type)     // Yes, check type and not time.
    {
        if (ent.curse_finished < time)
        {   // just stopped
            if (ent.curse_type == CURSE_CONFUSE)
            {   // Negate confusion.
                if (ent.flags & FL_MONSTER)
                if (ent.health > 0)
                {
                    local   entity  swap;

                // Keep enemy if it is legit.
                    swap = ent.enemy;
                    ent.enemy = world;
                    if (swap.flags & FLx_CREATURE)
                        if (!Ally_Check (swap, ent))
                            ent.enemy = swap;
                // Keep oldenemy if it is legit.
                    swap = ent.oldenemy;
                    ent.oldenemy = world;
                // FIXME:  vis check?
                    if (swap.flags & FLx_CREATURE)
                        if (!Ally_Check (swap, ent))
                        {
                            if (ent.enemy)
                                ent.oldenemy = swap;    // Restore backup.
                            else
                                ent.enemy = swap;       // Promote to new.
                        }
                }
            }
            ent.curse_finished = 0;
            ent.curse_type = 0;
        }

    // Spawn haze effects around upper body/head.
        if (ent.curse_type)
        {
            Curse_Haze (ent);       // In swap.qc
            if (ent.curse_type == CURSE_SLOW)
                slowed = 1;
        }
    }

// Holy Freeze -------------------------
    if (ent.slow_finished)
    {
        slowed = 1;
        if (ent.slow_ping < time)
            if (!IsOut (ent))
                Particle_Cube (ent, 1, 41); // Gray and blue for slow mist.
        if (ent.slow_finished < time)
        {   // just stopped
            ent.slow_finished = ent.slow_time = ent.slow_ping = 0;
        }
    }

    if (slowed)
    if (ent.curse_slow <= time)
    {
        slowed = random() * 0.2;    // Multiple sources of slow don't stack.
        ent.curse_slow = ent.nextthink = ent.nextthink + slowed;
        if (ent.flags & FL_CLIENT)  // Extend players' reload times.
            if (ent.attack_finished > 0)
                ent.attack_finished = ent.attack_finished + slowed;
    }

// Zapper ------------------------------
    if (ent.arsenal & WAR_ZAPPER)
        if (ent.war == WAR_ZAPPER)
            ent.currentammo = Zapper_Level (ent);

// Other -------------------------------
    // Dimlight will override brightlight, so remove it if necessary.
    if (ent.effects & EF_BRIGHTLIGHT)
        ent.effects = ent.effects - (ent.effects & EF_DIMLIGHT);

/*
// DISABLED -- v_cshift causes unwanted problems for me.
// Keys (input from keyboard) get stuck, and player may want to use it
// (v_cshift) for some reason.
    // Quoth-like screen colors.
    if (ent.hud_flags != ent.items2)
    {   // Update hud color.
        ent.hud_flags = ent.items2;
        if (ent.flags & FLx_CREATURE == FL_CLIENT)
        {
            if (ent.items2 & IT2_SHIELDS)
                stuffcmd (ent, "v_cshift 127 127 0 30");    // Cross
            else if (ent.items2 & IT2_WETSUIT)
                stuffcmd (ent, "v_cshift 15 0 127 30");    // Tome of Power
            else
                stuffcmd (ent, "v_cshift 0 0 0 0");
        }
    }
*/
};

//- - - - - - - - -
// view.c (q1source).
// empty = '130 80 50 0'
// water = '130 80 50 128'
// slime = '0 25 5 150'
// lava = '255 80 0 150'
// V_ParseDamage
// '200 100 100 30'
// '220 50 50 30'
// '255 0 0 30'
// V_BonusFlash_f.
// '215 186 69 50'
// V_CalePowerupCshift.
// Quad = '0 0 255 30'
// Inviso = '100 100 100 100'
// Pent = '255 255 0 30'
// Suit = '0 255 0 20'
//- - - - - - - - -
// Trinity = '0 120 255 40'
// Cross = '255 255 0 40'
//- - - - - - - - -

//void() CheckPowerups = {CheckArtifacts (self);};

//================
// CheckBahamut
//
// Check for ammo recharge for dragon morph.
// PM:  Only players should use this.
//================
void() CheckBahamut =
{
    if (self.form_active == FORM_DRAGON)
    {
        if (self.attack_finished > time)
        {   // Speed up ammo recovery so player can attack right after a
            // previous attack or transformation.
            self.baha_time = time;
        }
        else if (self.baha_time <= time)
        {   // Add more ammo to the battery.
            local   float   pak;

            pak = COST_BAHA_BOMB;   // Was 8.
            self.baha_ammo = self.baha_ammo + pak;
            if (self.baha_ammo > MAX_BAHA_AMMO)
                self.baha_ammo = MAX_BAHA_AMMO;

            // Set the time to the next recharge.
            // Recharge rate is 20 shots per second.
            self.baha_time = MAX_BAHA_AMMO - self.baha_ammo;
            if (self.baha_time > pak)
                self.baha_time = pak;
            else if (self.baha_time < 1)
                self.baha_time = 1;
            self.baha_time = self.baha_time * 0.05 + time;

            self.currentammo = self.baha_ammo;    // Update hud if necessary.
        }
    }
};

//================
// CheckMjolnir
//
// Check for Mjolnir.
//
// If a thrown hammer was removed without resetting the hammer time,
// the player cannot use the hammer again, until time is set back to zero.
// This function is a fail-safe that will return the hammer back to the
// player in case a hammer gets lost.
//
// PM:  Only players should use this.
//================
void() CheckMjolnir =
{
// Mjolnir -----------------------------
    if (self.hammer_finished)
    {
        if (self.hammer_finished < time)
        {
            self.hammer_finished = 0;
            War_SetCurrentAmmo ();
        }
    }
};


//===========================/  END OF FILE  /===========================//

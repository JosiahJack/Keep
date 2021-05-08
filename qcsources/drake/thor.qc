//==========================================================================
//
//  MJOLNIR (Thor's hammer)
//
//==========================================================================

//==========================================================================
//  Throwing Hammer

//
//  This part of the Mjolnir code is custom, added for SoE's modified
//  Mjolnir.  This lets the attacker throw the hammer.  The hammer will
//  select an enemy, fly toward it, then return back to the attacker.
//  In that respect, it is similar to the soulcube from Doom3.
//  If the hammer hits a target, the hammer will discharge like
//  the plasma balls from DoE.
//  
//  NOTE:  Plasma code is in 'light.qc'.
//

float   THOR_SPEED  = 600;

// Think function for the delayed discharge.
void() Thor_Pulse =
{
    if (self.count < 1)
        {remove (self);  return;}

    self.nextthink = time + 0.2;
    self.count = self.count - 1;
    Plasma_Discharge ();
};

// Spawns a special discharge entity for Mjolnir impacts.
// Cannot use BecomeExplosion derivates because hammer remains after impact,
// so we need to create the explosion effects.
void() Thor_Discharge =
{
// Spawn discharge entity.
    newmis = spawn();
    if (self.master.tome_finished)
        newmis.count = 3;
    else
        newmis.count = 2;
    newmis.master   = self.master;  // The attacker.
    newmis.enemy    = self.enemy;   // Who to ignore.
    newmis.dmg      = self.dmg;
    newmis.distance = self.dmg + 220;   //320;
    newmis.style    = 1;    // Don't let discharge zap allies.
    newmis.classname= "Mjolnir";    // For obituary.
    newmis.movetype = MOVETYPE_NONE;
    newmis.velocity = '0 0 0';
    newmis.touch    = SUB_Null;
    newmis.solid    = SOLID_NOT;
    newmis.think    = Thor_Pulse;
    setall (newmis, "", '0 0 0', '0 0 0', self.origin);
    SUB_Think (newmis, Thor_Pulse);

// Spawn a second entity for the explosion sprite.
    MakeFancy (self.origin, X56_PLASMA_BLUE, 6);
};

// Remove a thrown hammer.
// *** Always call this to remove a hammer! ***
void() Thor_Remove =
{
    local   entity  thor;

    thor = self.master;
    if (thor)
    {
        thor.hammer_finished = 0;
        if (thor.arsenal & WAR_MJOLNIR)     // Confirm ownership of hammer.
        {
            sound (thor, CHAN_ITEM, "weapons/lock4.wav", 1, ATTN_NORM);
            if (thor.flags & FL_CLIENT)     // So far, only clients use ammo.
            {
                if (self.ammo_cells)    // Recover all unused cells.
                    Update_Cells (thor, thor.ammo_cells + self.ammo_cells);

                if (!thor.form_active)
                {
                    if (thor.war & WARx_USES_CELLS)
                        SUB_Think (thor, War_UpdateCurrentAmmo);
                    if (thor.war == WAR_MJOLNIR)
                    {   // Hammer selected, so restore weapon model and ammo.
                        // Delay next attack a bit so player doesn't throw immediately.
                        if (thor.attack_finished < time + 0.2)
                            thor.attack_finished = time + 0.2;
                        if (cutscene)   // If TRUE, update dummy, not camera.
                            thor = find (world, classname, "dummy");
                        thor.weaponmodel = "progs/v_hammer.mdl";
                    }
                }
            }
        }
    }
    remove (self);
};

// Removes hammer by teleporting back to master.
// Any cells the hammer had are lost.
void() Thor_Poof =
{
    self.ammo_cells = 0;
    spawn_tfog (self.origin);
    Thor_Remove ();
};

// Called when a thrown hammer hits something.
void() Thor_Touch =
{
    local   vector  org;

    if (other == self.master)
    {   // Returned to attacker, so simply catch the hammer.
        Thor_Remove ();
        return;
    }

    if (Reflected ())
        return;

    if (self.owner == self.master)
    {   // Bounce straight back.
        self.movedir = self.movedir * -1;
        self.velocity = self.movedir * THOR_SPEED;
    }
    self.enemy = self.owner = other;
    if (other.takedamage)
    {   // Hammers do not draw blood like edged weapons, so no spawn_touchblood.
        // After all, this is why clerics in AD&D can use only blunt weapons.
        // Hammer in melee may draw blood, but not when thrown.
        local   float   damage;

        damage = 50;
        if (other.classname == "monster_zombie")
            damage = other.health + 10;
        sound (self, CHAN_WEAPON, "zombie/z_hit.wav", 1, ATTN_NORM);
        T_NewDamage (other, self, self.master, damage, DF_SCAR, "hammer");

        if (self.ammo_cells > 0)
        {
            damage = self.dmg * 0.7;
            if (self.master.tome_finished)
                damage = damage * 1.5;
            org = Midpoint (self.master);
            if (vlen(self.origin - org) > damage + 40)
            {   // Discharge.
                local   float   dmg1, dmg2;

                self.ammo_cells = 0;

                // Combine two different sources of damage into one.
                // dmg1 = Splash damage, dmg2 = Discharge.
                dmg1 = (0.8 + random()*0.2) * self.dmg;
                dmg1 = ResistDamage (other, dmg1, DF_LIGHTNING | DF_ROCKET);
                // Unlike plasma, this explosion discharges not once, but twice.
                if (Ally_Check (other, self.master))
                    dmg2 = 0;   // Discharge would not hit target.
                else
                {
                    dmg2 = self.dmg;
                    if (self.master.tome_finished)
                        dmg2 = dmg2 * 1.5;
                    dmg2 = ResistDamage (other, dmg2, DF_LIGHTNING);
                }
                // Send monsters flying.
                T_NewDamage (other, self, self.master, dmg1 + dmg2, DF_PUSH_NPC, self.classname);
                if (self.master.tome_finished)      // Instakill if ToP.
                {
                    if (!(other.xfl & XFL_BOSS))
                        T_Kill (other, self, self.master, -99, self.classname);
                }
                T_NewRadiusDamage (self, self.master, damage, other, DF_LIGHTNING | DF_ROCKET, self.classname);

            // Don't move sprite back because hammer is still there.
                sound (self, CHAN_AUTO, "hipweap/mjolhit.wav", 1, ATTN_NORM);
                Rocket_Explosion2 (self.origin, 244, 3);
                Thor_Discharge ();    // Spawn new, separate explosion entity.
                if (self.master.tome_finished)
                {
                    ShockWave (self.origin + '0 0 4', RING_BLUE, 6, "progs/s_wave.spr");
                    local   entity  swap;
                    swap = self;
                    self = self.master;
                    Quake_Self (800, 10, swap.origin, DF_BLESSED, 2);
                    // Use BFG9000-like trace attack instead of static field.
                    // StaticField (swap, self, other, "Mjolnir", 1000);
                    DeathRay (swap.origin, '0 0 0', 100, 1000, -2, "Mjolnir");
                    Divine_Wrath (4, 2);
                    self = swap;
                }
                else
                    ShockWave (self.origin + '0 0 4', RING_BLUE, 4, "progs/s_wave.spr");
            }
        }
    }
    else
    {   // Hammer slammed a wall or something.
        if (pointcontents(self.origin) != CONTENT_SKY)
        {
            org = self.origin - 8*normalize(self.velocity);
            Tent_Point (TE_GUNSHOT, org);
            sound (self, CHAN_WEAPON, "hipweap/mjoltink.wav", 1, ATTN_NORM);
        }

        if (self.count < 10)
            self.count = self.count + 1;
        else
        {   // Stuck, so teleport back to the attacker's hand.
            Thor_Poof ();
            return;
        }
    }
};

// Controls hammer velocity.  Called by Thor_Think.
// Cause thrown hammer to fly towards a given target.
void(entity targ) Thor_Fly =
{
    local   vector  ang;
    local   float   diff;

    self.flags = self.flags - (self.flags & FL_ONGROUND);
    self.avelocity_x = 0 - THOR_SPEED;

// Temporarily set angles to the direction the missile is traveling.
    ang = self.angles;
    self.angles = vectoangles (self.movedir);
    diff = ang_x - self.angles_x;
// Update velocity and angles based on missile angles.
    Missile_Seek (targ);
// Restore pitch to what it should be now.
    self.angles_x = anglemod (self.angles_x + diff);
    if (self.angles_x >= 180)
        self.angles_x = self.angles_x - 360;
};

// Track the nearest target.
void() Thor_Think =[ 0, Thor_Think ]
{
    local   entity  targ;

    if (self.master.hammer_finished < time)
    {   // Time's up, return to attacker now!
        Thor_Poof ();
        return;
    }

    if (self.owner == self.master)
    {   // Outgoing for an attack.
        if (self.enemy)
        {   // Return to attacker if target is gone.
            if (self.enemy.solid < SOLID_BBOX)
                if ((self.enemy.takedamage != DAMAGE_AIM) || (self.enemy.health <= 0))
                    self.owner = world;
            if (!self.enemy.modelindex)
                self.owner = world;
        // ToP:  If no juice, return after a short delay.
            if (!self.ammo_cells)
                if (self.delay <= time)
                    self.owner = world;
        }
        else
        {   // Return to attacker if hammer flew long enough.
            if (self.delay <= time)
                self.owner = world;
        }
        targ = self.enemy;
    }
    else
        targ = self.master;     // Returning back to attacker.

    Thor_Fly (targ);
};

// This throws the mighty hammer.
void(vector start, vector dir, entity targ) Thor_Launch =
{
    newmis = spawn ();
    newmis.master       = newmis.owner      = self;
    newmis.movetype     = MOVETYPE_FLYMISSILE;
    newmis.solid        = SOLID_BBOX;
    newmis.classname    = "Mjolnir";    //"hammer";
// set missile speed
    newmis.yaw_speed    = 40;
    newmis.speed        = THOR_SPEED;
    newmis.velocity     = dir * THOR_SPEED;
    newmis.angles       = vectoangles(newmis.velocity);
    newmis.avelocity    = '0 0 0';
    newmis.avelocity_x  = 0 - THOR_SPEED;
    newmis.movedir      = dir;
// set missile misc
    newmis.dmg          = 100;
    newmis.ammo_cells   = COST_MJOLNIR;
    newmis.enemy        = targ;
    newmis.count        = 0;
// set missile duration
    newmis.touch        = Thor_Touch;
    newmis.delay        = time + 1.5;   // 1,5 sec. gives about 900 range.
    newmis.nextthink    = time + 0.1;
    newmis.think        = Thor_Think;

    setmodel (newmis, "progs/throwham.mdl");
    setsize (newmis, '0 0 0', '0 0 0');        
    setorigin (newmis, start);

// Update attacker.
    if (self.flags & FL_CLIENT)
    {
        if (self.ammo_cells >= COST_MJOLNIR)
        {   // Throw hammer at full power.
            Update_Cells (self, self.ammo_cells - COST_MJOLNIR);
        }
        else
        {   // No juice!
            newmis.ammo_cells   = 0;
            if (self.tome_finished)
                newmis.delay        = time + 1;
            else
                newmis.delay        = time + 0.5;
        }
        self.weaponmodel    = "";
    }
    self.hammer_finished= time + 10;    // Automatically returns later.
};

float   THOR_NEAREST    = 1;    // 0 = Best dot product, 1 = Best distance.

entity() W_ThorTarget =
{
    local   entity  head, targ;
    local   float   best, dist, dot;
    local   vector  org, spot, vec, vx;

    if (self.flags & FL_CLIENT)
        makevectors (self.v_angle);
    else
        makevectors (self.angles);
    vx = v_forward;

    org = self.origin + self.view_ofs;
    targ = world;
//    if (THOR_NEAREST)
        best = 10000000;
//    else
//        best = 0.7071;
    head = findradius (org, 2000);      // Don't give hammer more range.
    while (head)
    {
        if (head.modelindex)    // PM:  Treat as notarg if FALSE.
        if (!(head.flags & FL_NOTARGET))
        if (head.flags & FLx_CREATURE)
        if (head.health > 0)        // Must be alive.
        if (head.solid >= SOLID_BBOX)
        if (!Ally_Check (head, self))
        {
            spot = Midpoint (head);
            traceline (org, spot, TRUE, self);
            if (trace_fraction == 1)
            {
                vec = head.origin - org;
                dot = normalize (vec) * vx;
//                if (THOR_NEAREST)
                {
                    if (dot > 0.7071)   // Must be within 90 fov.
                    {
                        dist = vlen(vec) / dot;     //vlen(vec) * (1 - dot);
                        if (dist < best)
                            {best = dist;  targ = head;}
                    }
                }
//                else
//                {
//                    if (dot > best)
//                        {best = dot;  targ = head;}
//                    else if (dot == best)
//                    {
//                        dist = vlen (vec);
//                        if (dist < vlen (targ.origin - org))
//                            targ = head;
//                    }
//                }
            }
        }
        head = head.chain;
    }
    return targ;
};

// Checks if self has enough power to throw the hammer.
float() HasPowerToThrow =
{
    if (self.tome_finished)
        return TRUE;
    if (self.ammo_cells >= COST_MJOLNIR)
        return TRUE;
    return FALSE;
};

void() W_FireThor =
{
    local   entity  targ;

// There is a delay before firing, so don't throw if not an appropriate time.
    if (cutscene || intermission_running)
        return;

    if (self.hammer_finished)
        return;     // No hammer!
    if (!HasPowerToThrow ())
        return;     // No ammo or power!

// We can throw.
    targ = W_ThorTarget ();      // This calls 'makevectors (self.v_angle)'.
    sound (self, CHAN_WEAPON, "knight/sword1.wav", 1, ATTN_NORM);
    Thor_Launch (self.origin + '0 0 12', v_forward, targ);
};


//==========================================================================
//  Hipnotic Slam

// NOTE:  Must use 'struck_by...' because tesla code uses that too.
.float  struck_by_mjolnir;

// Added 12/23/2009:
// Used by hammer slam to repel missiles and crush fallen zombies.
void(entity inflictor, float damage) Hammer_Block =
{
    local   entity  head;
    local   vector  spot, org;
    local   float   points;

    spot = inflictor.origin;
    head = QC_FindRadius (spot, damage + 40);
    while (head)
    {
        if (head.owner != self)
        if (head.solid == SOLID_NOT)
        {   // Hit zombies!
            if (head.takedamage)
            if (head.modelindex)
            if (!head.deadflag)
            if (head.classname == "monster_zombie")
            if (head.frame == 172)  // paine11.
            {
                org = Midpoint (head);
                points = 0.5 * vlen(spot - org);
                points = damage - points;
                if (points > 0)
                if (CanDamage (head, inflictor))
                {
                    if (points < self.health)
                        points = self.health;   // Insta-kill.
                    T_NewDamage (head, inflictor, self, points, DF_ROCKET | DF_SCAR | DF_BLESSED, "hammer");
                }
            }
        }
        else
        {
            if (IsMissile (head))
            {
                traceline (spot, head.origin, TRUE, self);
                if (trace_fraction == 1)
                    Block_Missile (head, spot);
            }
        }
        head = head.chain;
    }
};

// Rewritten so that the lightning base entity is not referenced here.
void() HIP_LightningThink =
{
    local   vector  org;
    local   vector  dst;
    local   vector  vec;
    local   float   dot;
    local   float   oldstate;
    local   float   dam;

    if (time > self.delay)
    {
        if (self.enemy)     //!= world)
            self.enemy.struck_by_mjolnir = 0;
        remove (self);
        return;
    }
    oldstate = self.state;
    if (self.state==0)
    {
        // look in our immediate vicinity
        local   entity  head;
        local   entity  selected;
        local   float   cur_dist;
        local   float   head_dist;

        self.enemy = selected = world;
        cur_dist = self.distance;
        head = findradius(self.dest, self.distance);
        while (head)
        {
            if (head.modelindex)    // PM:  Treat as notarg if FALSE.
            if (!(head.flags & FL_NOTARGET))
            if (head.flags & FLx_CREATURE)    // Must be creature.
            if (head != self.owner)     // Don't hit attacker.
            if (head.health > 0)        // Must be alive.
            if (head.struck_by_mjolnir==0)
            if (visible(head))
            if (!Ally_Check (head, self.owner))   // New, hit enemies only.
            {   // Potential target, take the closest one.
                head_dist = vlen(head.origin - self.dest);
                if (head_dist < cur_dist)
                {   // Best one yet.
                    selected = head;
                    cur_dist = head_dist;
                }
            }
            head = head.chain;
        }
        if (selected)   //!= world)
        {
            self.state = 1;
            self.enemy = selected;
            self.enemy.struck_by_mjolnir = 1;
        }
        else
        {   // Bolt hit no one...
            local   vector  end;

            makevectors (self.v_angle);
            org = self.dest;
            end = org + v_forward*200;
            end = end + (((400*random()) - 200) * v_right);

            traceline (org, end, TRUE, self);

            Tent_Beam (TE_LIGHTNING2, self, org, trace_endpos);

            self.nextthink = time + 0.1;
            return;
        }
    }
// Found an enemy, see if it can be hit.
    org = self.dest;
    dst = self.enemy.absmin + 0.25*(self.enemy.absmax-self.enemy.absmin);
    dst = dst + (random()*0.5*(self.enemy.absmax-self.enemy.absmin));
    traceline (org, dst, TRUE, self.owner);

    if (trace_fraction != 1.0 || self.enemy.health<=0)
    {
        self.enemy.struck_by_mjolnir = 0;
        self.state = 0;
        self.nextthink = time + 0.1;
        return;
    }

// Fry the enemy!
    dst = trace_endpos;     // PM:  Save this point.
    vec = normalize(self.enemy.origin - self.dest);
    dot = vec * self.movedir;
    if (oldstate==0)
        dam = self.waitmax;     //80;
    else
        dam = self.waitmin;     //30;
    if (dot <= 0.3)
        dam = dam*0.5;
    LightningBolt (org, dst, self.owner, dam, self, TE_LIGHTNING2, "Mjolnir");

    self.nextthink = time + 0.2;
};

void(float lo, float hi) Thor_Slam =
{
    local   entity  base, lite;
    local   float   loop;
    local   vector  ang;    // PM:  New.
    local   vector  spot;   // Ditto.

    spot = trace_endpos;

// PM:  Make idle lightning parallel to ground, rather than flat 0 degrees.
//    if (1)
//        ang = '0 0 0';
//    else
    {   ang = vectoangles (trace_plane_normal);
        ang_x = anglemod (ang_x - 90);
    }
    ang_y = self.angles_y;

// spawn lightning base
    base = spawn();
//   base.origin = self.origin - '0 0 24' + (32*v_forward);
    base.origin    = trace_endpos;
    base.flags     = 0;
    base.owner     = self;
    base.struck_by_mjolnir = 1;
    base.think     = SUB_Remove;
    base.nextthink = time + 1;
    sound (base, CHAN_AUTO, "hipweap/mjolslap.wav", 1, ATTN_NORM);
    sound (base, CHAN_WEAPON, "hipweap/mjolhit.wav", 1, ATTN_NORM);
    if (self.flags & FL_CLIENT)
        makevectors (self.v_angle);
    else
        makevectors (self.angles);
    base.movedir = v_forward;

// spawn actual lightning
    loop = 4;
    while (loop > 0)
    {
        lite = spawn();
        lite.delay     = time + 0.8;
        lite.state     = 0;
        lite.owner     = self;      // Was base.
        lite.distance  = 350;
        lite.v_angle   = ang;       // Was '0 0 0';
//        lite.v_angle_y = self.angles_y;
        lite.origin    = base.origin;
        lite.think     = HIP_LightningThink;
        lite.nextthink = time;
        lite.ryuflags  = RYU_ALERT;     // PM:  Allow sight across contents.
        // PM:  Damage set here.
        lite.waitmin   = lo;    //30;
        lite.waitmax   = hi;    //80;

    // Yes, I know it may be faster to define these once at the
    // lightning base than multiple times, once on each bolt.
    // However, I wanted to eliminate any reference to the
    // lightning base when the bolts think.  Now, the base is
    // just there as a sound source.
        lite.dest      = base.origin;
        lite.movedir   = base.movedir;

        loop = loop - 1;
    }

// PM:  Spawn shockwave.
//    Tent_Explosion2 (base.origin, 244, 3);
    ShockWave (base.origin + '0 0 4', RING_BLUE, 6, "progs/s_wave.spr");

    Hammer_Block (lite, 100);   // Added on 12/23/09.
};

// For earthquakes caused by Mjolnir slamming the ground.
void() Quake_Thor =
    {Quake_Self (800, 10, trace_endpos, DF_BLESSED, 2);};

// Mjolnir use for monsters!
void(vector spot) M_Slam =
{
    traceline (spot, spot - '0 0 64', TRUE, self);
    if (trace_fraction < 1.0)
    {   // Slammed the ground, so fire off some lightning.
        Thor_Slam (10, 30);
        Quake_Thor ();
// DISABLED -- Secondary lightning strikes are really unfair against players.
//        Divine_Wrath (3, 2);    // Do after Hip lightning.
    }
};

void() HIP_SpawnMjolnirBase = {Thor_Slam (30, 80);};

void() HIP_FireMjolnirLightning =
{
// PM:  Don't discharge if 'trace_endpos' is underwater (even though the
// change is tempting) because it would make discharging too easy.
    if (self.h2olevel > 1)
        {Discharge (self);  return;}

    Update_Cells (self, self.ammo_cells - COST_MJOLNIR);
    HIP_SpawnMjolnirBase();
};

// PM:  Custom shockwave attack for enhanced Mjolnir.
void() HIP_FireMjolnirShockwave =
{
    local   entity  wave;
    local   vector  spot;
    local   float   damage, fr, wc;

    spot = trace_endpos;
    wave = spawn();
    setorigin (wave, spot);
    sound (wave, CHAN_AUTO, "hipweap/mjolslap.wav", 1, ATTN_NORM);
//- - - - - - - - -
/* DISABLED -- Test for other weapon that's scrapped.
    // Update 5/14/10:  Dragonscale adds firewall
    if (Armor_Exotic (self) == SUIT_DRAGON)
    {   // Spawn a firewall.
        local   vector  dir, p1;
        local   entity  targ;

        makevectors (self.v_angle);
        dir = v_forward;
        p1 = self.origin + self.view_ofs;
        targ = SuperRocket_Target (self, p1, v_forward, 1000, COS30);
        if (targ)
            dir = normalize (targ.origin + targ.view_ofs - p1);
        Firewall_Spawn (self.origin, dir, 1, targ);
        wc = RING_FIRE;
    }
    else
*/
    {
        sound (wave, CHAN_WEAPON, "weapons/nova.wav", 1, ATTN_NORM);
        wc = RING_BLUE;
    }
//- - - - - - - - -
    if (self.tome_finished)
    {   // More damage plus a tremor to shake things up.
        damage = 100;  fr = 5;
        // Update 9/10/10:  Reduced dist(200), damage(4) and time(1).
        // Quake is for the player to feel powerful.
        Quake_Self (150, 3, spot, DF_BLESSED, 0.5);
    }
    else
        {damage = 70;  fr = 4;}
    ShockWave (spot + '0 0 4', wc, fr, "progs/s_wave.spr");
    T_NewRadiusDamage (wave, self, damage, self, DF_ROCKET | DF_PUSH_NPC | DF_BLESSED, "hammer");
    if (self.tome_finished)
    {   // Spawn mini-slam effects with Tome of Power.
        // Do after radius damage so dead things won't be targeted.
        if (pointcontents (spot) > CONTENT_WATER)   // No discharge for you!
            BurstLit_Chain (wave, self, 30, self, spot, "Mjolnir", '1 350 4', 2);
        Divine_Wrath (1, 1);
    }
    Hammer_Block (wave, damage);   // Added on 12/23/09.
    remove (wave);
};

// Checks if the super slam is safe to use.
float() Thor_Safe =
{
    if (deathmatch)
        return TRUE;    // Allow for possible net frag gain.
    if (self.h2olevel <= 1)
        return TRUE;    // Not in the water.
    if (self.cross_finished)
        return TRUE;    // Immune to radius damage.
    if (self.radsuit_finished)  // Inherited wetsuit powers...
        return TRUE;    // Protected from lightning damage.
    return ImmuneToDamage (self);
};

void() HIP_SlamMjolnir =
{
// Slammed the ground, so fire off some lightning.
    if (self.button0)
    if (self.ammo_cells >= COST_MJOLNIR)
    if (Thor_Safe ())   // Update 11/30/09:  Don't discharge if deadly.
    {   // Super slam.
        local   float   hits;

        if (self.tome_finished)
            hits = 6;
        else
            hits = 4;
        {
            Quake_Thor ();
            HIP_FireMjolnirLightning ();
            Divine_Wrath (hits, 2);     // Do after Hip lightning.
            if (!lightzero_finished)
                sound (world, CHAN_AUTO, "bane/thunder.wav", 1, ATTN_NONE);
        }
        if (self.tome_finished)     // Soften 'em up before delayed smashing.
            StaticField (self, self, self, "Mjolnir", 400);     // Was 500.
        self.attack_finished = time + 1.5;
        return;
    }
// Mini-slam.
    HIP_FireMjolnirShockwave ();
};

float() Hip_ThrewMjolnir =
{
    // Throw on a double-click, and if player has the juice.
    if (self.b0_click == 2)
        if (HasPowerToThrow ())
            {W_FireThor ();  return TRUE;}

    return FALSE;
};

// PM:  Called when Mjolnir hits a target directly.
void(vector org, vector dir, string dtype) HIP_MjolnirDamage =
{
    local   entity  targ;
    local   float   damage, static;

    static = 0;
    targ = trace_ent;

    damage = 50;
    if (targ.classname == "monster_zombie")
        damage = targ.health + 10;
// PM:  Use the thump sound instead of axhitme.
//    if (targ.hittype == HIT_STONE)
//        sound (self, CHAN_WEAPON, "hipweap/mjoltink.wav", 1, ATTN_NORM);
//    else if (targ.hittype == HIT_METAL)
//        sound (self, CHAN_WEAPON, "weapons/clang.wav", 1, ATTN_NORM);
//    else
        sound (self, CHAN_WEAPON, "zombie/z_hit.wav", 1, ATTN_NORM);
    SpawnBlood (org, dir, damage, targ.bloodtype);
    // As a blessed artifact of the gods, use scar damage.
    T_NewDamage (targ, self, self, damage, DF_SCAR|DF_MELEE, dtype);

    if (!self.tome_finished)
        return;

// Multiple procs are checked independently of each other, and may
// activate simultaneously.  Proc functions are in 'cool.qc'.
    if (random() < 0.2)
        static = 1;
    if (random() < 0.1)
    {   // Thunderstorm proc.
        if (!Divine_Wrath (3, 1))   // 3 shots, 1 sec of darkness.
            static = static + 1;
    }
    else if (self.tome_finished)
        Divine_Wrath (1, 1);
    if (static)
    {
        if (self.tome_finished)
            static = static + 1;
        static = static * 100 + 100;
        StaticField (targ, self, self, "Mjolnir", static);
    }
};

// PM:  This calls for the slam only now.  If slam fails, we totally missed.
void() HIP_FireMjolnir =
{
    local   vector  source, vec;

    if (cutscene || intermission_running)
        return;     // Not while viewing through a cam.

//- - - - - - - - -
// Since throwing the hammer on frame three can be almost impossible with
// lag, allow throwing on frame four, even if animation would make the
// throw appear a bit late.  Better to have forgiving controls and happy
// players than "fake difficulty" for animation's sake.
    if (Hip_ThrewMjolnir ())
        return;
//- - - - - - - - -

//    if (self.ammo_cells >= COST_MJOLNIR)
    {
        source = self.origin + '0 0 16';
        makevectors (self.v_angle);
        vec = v_forward * 32;
        // We want the slam.
        traceline (source, source + vec, FALSE, self);
//        if (trace_fraction == 1.0)
        {   // Hammer missed, so check if it slammed the ground.
            source = source + vec*trace_fraction;
            traceline (source , source - v_up*50, FALSE, self);
//            dprint("fraction = "); dprint(ftos(trace_fraction)); dprint("\n");
            if (trace_fraction < 1.0)
            {
                if (trace_fraction > 0.3)
                {   // Slammed the ground, so fire off some lightning.
                    HIP_SlamMjolnir ();
                    return;
                }
//- - - - - - - - -
            // We hit something on the way down.
                vec = trace_endpos + '0 0 4';
                if (trace_ent.takedamage)
                {   // Thumped an ankle-biter.
                    HIP_MjolnirDamage (vec, '0 0 1', "hammer");
                    return;
                }
                if (trace_ent.flags & FLx_CREATURE)
                {
                    sound (self, CHAN_WEAPON, "hipweap/mjoltink.wav", 1, ATTN_NORM);
                    Tent_Point (TE_GUNSHOT, vec);
                    return;
                }
//- - - - - - - - -
            }
        }
    }
    // whiff
    sound (self, CHAN_WEAPON, "knight/sword1.wav", 1, ATTN_NORM);
};

// PM:  Called on third frame of attack, before the slam on the fourth.
float() HIP_ThrowMjolnir =
{
    local   vector  org;
    local   float   damage, frac;
    local   vector  source;

    if (cutscene || intermission_running)
        return 0;   // Not while viewing through a cam.

    source = self.origin + '0 0 16';
    makevectors (self.v_angle);
    // PM:  Distance of 32 is obnoxiously short.
    // Use normal axe range if slam is not desired.
    if (self.button0 || (self.ammo_cells < COST_MJOLNIR))
        {damage = 64;  frac = 0.5;}
    else
        {damage = 32;  frac = 1;}
    traceline (source, source + v_forward*damage, FALSE, self);
    org = trace_endpos - v_forward*4;

    if (trace_ent.takedamage)
    {
        local   string  dtype;

        dtype = "hammer";
        if (trace_fraction <= frac)
            dtype = "hammer_decap";
        HIP_MjolnirDamage (org, v_forward, dtype);
        return 1;
    }
    else if (trace_fraction != 1.0)
    {   // hit wall
        if (other.solid == SOLID_BSP)
        {   // Check for premature hit on the ground.
            if (trace_plane_normal * '0 0 1' > COS45)
            {   // Player struck the ground.
                HIP_SlamMjolnir ();
                return 1;
            }
        }
        sound (self, CHAN_WEAPON, "hipweap/mjoltink.wav", 1, ATTN_NORM);
        Tent_Point (TE_GUNSHOT, org);
        return 1;
    }
    else
    {   // whiff
        // Frikbot code! - -
            if (!self.ishuman)
            {   // Emulate a double-click.  Since required timing varies
                // with lag, enforce a chance of failure.
                if ( random() < (skill * 0.1 + 0.7) )
                {   //dprint ("Frikbot tries to throw hammer\n");
                    self.b0_click = 2;
                }
            }
        //- - - - - - - - -
        // Update 12/11/09:  T+0.6+0.1=T+0.7.  Changed rate in impulse.qc.
        self.attack_finished = self.attack_finished + 0.1;
        return Hip_ThrewMjolnir ();
    }
//    return 0;
};


//===========================/  END OF FILE  /===========================//

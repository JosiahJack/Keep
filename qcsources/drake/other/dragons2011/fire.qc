// PM:  Heavily modified from Drake into a place for dragons' attack code.

//==========================================================================
//  Frame Data

//  Frame Macros for modified 'flame2.mdl'.
$cd id1/models/flame2
$origin 0 0 12
$base base        
$skin skin

// These are grouped scenes.
$frame  flame
$frame  flameb
// Next one is the firewall.  Added for SoE's hell lord.
$frame  flamec

// These scenes are not grouped.
$frame  ember1 ember2 ember3 ember4 ember5 ember6


//==========================================================================
//  Animation

//============
// Flame animation on modified 'flame2.mdl'.
//============
void() m_ember1 =[ $ember1, m_ember2   ] {};
void() m_ember2 =[ $ember2, m_ember3   ] {};
void() m_ember3 =[ $ember3, m_ember4   ] {};
void() m_ember4 =[ $ember4, m_ember5   ] {};
void() m_ember5 =[ $ember5, SUB_Remove ] {};
//void() m_ember6 =[ $ember6, SUB_Remove ] {};
//============

// This makes flaming embers rise from the burning victim 'ent'.
void(entity ent) MakeFlame =
{
    local   entity  fire;       // The new fire that will be created.
    local   vector  spot;       // The spot where the new fire will appear.
    local   float   r;

    // Used to be in a loop.
    spot   = ent.size * 0.5;
    spot_x = spot_x * (random() - 0.5);
    spot_y = spot_y * (random() - 0.5);
    spot_z = spot_z * (random() - 0.5);
    spot   = spot + Midpoint (ent);

    // Create the fire.
    fire = spawn();
    setmodel (fire, "progs/flame2.mdl");
    setsize (fire, '0 0 0', '0 0 0');
    setorigin (fire, spot);

    fire.frame      = $ember1;
    fire.solid      = SOLID_NOT;
    fire.takedamage = DAMAGE_NO;
    fire.movetype   = MOVETYPE_FLY;
    fire.velocity   = '0 0 100';
    fire.owner      = ent;

    // Animate the flame.
    r = random() * 3;
    if (r > 2)
        SUB_Think (fire, m_ember3);
    else if (r > 1)
        SUB_Think (fire, m_ember2);
    else
        SUB_Think (fire, m_ember1);
};

// This creates a small puff of smoke.
void(vector spot, float density) MakeSmoke =
{
    particle (spot, '0 0 100', 1, density);
};


void() s_fiery1 =[  1, s_fiery2 ] {};
void() s_fiery2 =[  3, s_fiery3 ] {};
void() s_fiery3 =[  5, s_fiery4 ] {};
void() s_fiery4 =[  7, s_fiery5 ] {};
void() s_fiery5 =[  9, s_fiery6 ] {};
void() s_fiery6 =[ 11, s_fiery7 ] {};
void() s_fiery7 =[ 13, s_fiery8 ] {};
void() s_fiery8 =[ 15, SUB_Remove ] {};

void() BecomeTheBigFire =
{
    self.movetype   = MOVETYPE_NONE;
    self.velocity   = '0 0 0';
    self.touch      = SUB_Null;
    setmodel (self, "progs/s_expbig.spr");
    self.solid      = SOLID_NOT;
    s_fiery1 ();
};


//  //  //  //  //
//==========================================================================
//  Shockwave Effects (for Iceball)

// Frames for 's_wave.spr'.
float   RING_FIRE       = 0;    // Custent's flaming shockwave, modified.
float   RING_BLUE       = 8;    // Drake's airstrike impact.
float   RING_QUAKE      = 14;   // Drake's quake slam.
float   RING_ICE        = 19;   // Iceball shockwave.
// Ends at frame 21.

void() s_explode_think =
{
    if (self.frame >= self.cnt)
        {SUB_Remove ();  return;}

    self.frame = self.frame + 1;
    self.nextthink = time + self.wait;
    if (self.frame == self.cnt)
        self.think = SUB_Remove;
};

void(float base, float add, string text) BecomeAnyExplosion =
{
    if (!add)
        add = 6;    // Assume standard duration of six frames.

// Become explosion code.
    self.movetype   = MOVETYPE_NONE;
    self.velocity   = '0 0 0';
    self.touch      = SUB_Null;
    setmodel (self, text);
    self.solid      = SOLID_NOT;
//- - - -
    self.frame      = base;
    self.cnt        = base + add - 1;
    self.wait       = 0.1;
    self.nextthink  = time + 0.1;
    self.think      = s_explode_think;
};

void(vector spot, float base, float add, string text) ShockWave =
{
    local   entity  wav1, wav2, ts;
    local   vector  ang;

// NOTE:  Don't use world in the 4th (ignore) parm or else the traceline
// will pass through any non-world bsp entites, such as shootable
// trap doors.  Use self instead, which should be an inflictor entity.
    traceline (spot, spot - '0 0 64', TRUE, self);
    if (trace_fraction >= 1.0)
        return;     // Too far from ground.
    if ((trace_plane_normal * '0 0 1') < 0.5)   //<= 0.7071
        return;     // Ground slopes too much.

    spot = trace_endpos + trace_plane_normal * 2;
    ang = vectoangles(trace_plane_normal);
    ang_y = anglemod(ang_y + 180);

// Top side.
    wav1 = spawn();
    wav1.angles     = ang;
    setorigin (wav1, spot);

// Bottom side.
    ang_x = anglemod(ang_x + 180);
    wav2 = spawn();
    wav2.angles     = ang;
    setorigin (wav2, spot);

// Thinking
    ts = self;
    self = wav1;
    BecomeAnyExplosion (base, add, text);
    self = wav2;
    BecomeAnyExplosion (base, add, text);
    self = ts;
};


//==========================================================================
//  Ice Explosions

// iceball.mdl:  frames 0-2 = iceballs, frames 3-7 = explosion of shards.
void() BecomeIcyExp =
{
    self.skin = 0;
    BecomeAnyExplosion (3, 5, "progs/iceball.mdl");
    self.alpha = 0.7;
};

void(vector spot) MakeIcyExp =
{
    local   entity  iced;

    iced = spawn();
    iced.movetype   = MOVETYPE_NONE;
    iced.velocity   = '0 0 0';
    iced.touch      = SUB_Null;
    iced.solid      = SOLID_NOT;
//- - - -
    iced.alpha      = 0.7;
    iced.frame      = 3;
    iced.cnt        = iced.frame + 4;    // 5 - 1
    iced.wait       = 0.1;
    iced.nextthink  = time + 0.1;
    iced.think      = s_explode_think;
//- - - -
    setmodel (iced, "progs/iceball.mdl");
    setsize (iced, '0 0 0', '0 0 0');
    setorigin (iced, spot);
};
//  //  //  //  //


//==========================================================================
//  Temporary Entities

// PM:  These are common within the qc progs.

void(float fx, vector spot) Tent_Point =
{
    WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
    WriteByte (MSG_BROADCAST, fx);
    WriteCoord (MSG_BROADCAST, spot_x);
    WriteCoord (MSG_BROADCAST, spot_y);
    WriteCoord (MSG_BROADCAST, spot_z);
};

void(float fx, entity src, vector p1, vector p2) Tent_Beam =
{
    WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
    WriteByte (MSG_BROADCAST, fx);
    WriteEntity (MSG_BROADCAST, src);   // If client, p1 is always origin.
    WriteCoord (MSG_BROADCAST, p1_x);
    WriteCoord (MSG_BROADCAST, p1_y);
    WriteCoord (MSG_BROADCAST, p1_z);
    WriteCoord (MSG_BROADCAST, p2_x);
    WriteCoord (MSG_BROADCAST, p2_y);
    WriteCoord (MSG_BROADCAST, p2_z);
};

void(vector spot, float rgb, float add) Tent_Explosion2 =
{
    WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
    WriteByte (MSG_BROADCAST, 12);
    WriteCoord (MSG_BROADCAST, spot_x);
    WriteCoord (MSG_BROADCAST, spot_y);
    WriteCoord (MSG_BROADCAST, spot_z);
    WriteByte (MSG_BROADCAST, rgb);     // First index to use on the palette.
    WriteByte (MSG_BROADCAST, add);     // Range is from rgb to rgb+add-1.
};


//==========================================================================
//  Explosion Effects

//------------------------------------------------------------------------//
//  Checks if a given point in space is in water.
//------------------------------------------------------------------------//
float(vector spot) VecInWater = {return (pointcontents(spot) <= CONTENT_WATER);};

//------------------------------------------------------------------------//
//  These create a mini-explosion within the flame cube.
//  Does no damage -- used only for show.
//------------------------------------------------------------------------//
void() FlameCube_Flare =
{
    setmodel (self, "progs/flame2.mdl");
    if (VecInWater (self.origin))
        {m_ember4 (); return;}     // Use smaller flame in water.
    m_ember1 ();
};

void() FlameCube_Burst =
    {setmodel (self, "progs/s_explod.spr");  s_explode1 ();};

//------------------------------------------------------------------------//
//  This creates a series of flames within a cube of space.  Referred to
//  as 'Cube-Shaped Flame Clouds'.
//
//  ents = Number of flames in explosion.
//------------------------------------------------------------------------//
void(vector org, vector vel, float ents, float side, void() thinkst)
    FlameCube =
{
    local   float   loop;       // Max attempts to create flames.
    local   float   pc;
    local   vector  spot;       // Location of each flame.
    local   entity  fire;       // Flame entity.

    loop = ents * 4;
    while (loop > 0)
    {
        // Place flame anywhere in the box.
        spot_x = org_x + ((random() - 0.5) * side);
        spot_y = org_y + ((random() - 0.5) * side);
        spot_z = org_z + ((random() - 0.5) * side);

        if (loop <= ents)
        {
            // Running low on attempts, so use a near-guaranteed method to
            // find a suitable point (in open space) if normal checks fail.
            pc = pointcontents(spot);
            if ((pc == CONTENT_SOLID) || (pc == CONTENT_SKY))
            {
                traceline (org, spot, TRUE, world);
                spot = trace_endpos - org;
                spot = trace_endpos - 8*normalize(spot);
            }
        }

        // Create flame if in open space.
        pc = pointcontents(spot);
        if (pc != CONTENT_SOLID)
            if (pc != CONTENT_SKY)
        {
            fire = spawn ();
            setmodel (fire, "");
            setsize (fire, VEC_ORIGIN, VEC_ORIGIN);        
            setorigin (fire, spot);

            fire.movetype   = MOVETYPE_FLY;
            fire.solid      = SOLID_NOT;
            fire.velocity   = vel;
            fire.touch      = SUB_Null;

            fire.nextthink  = time + random() * 0.2;
            fire.think      = thinkst;

            ents = ents - 1;
            if (ents <= 0)
                return;
        }

        loop = loop - 1;
    }
};

//------------------------------------------------------------------------//
//  This enforces air resistance on embers and updates their angles.
//
//  NOTE:  Modified flame has ember scene; frames start at 2, ends at 7.
//------------------------------------------------------------------------//
void() Ember_Think =[ $ember1, Ember_Think ]
{
    if (self.delay <= time)
    {
        if (self.walkframe >= 5)
            {remove (self); return;}
        self.walkframe = self.walkframe + 1;
    }
    self.frame = $ember1 + self.walkframe;

    local   vector  dir;

    // Update angles to its current direction.
    dir = normalize (self.velocity);
    self.angles = vectoangles(dir) + '90 0 0';

    // Cheap hack -- apply air resistance by reducing velocity.
    self.velocity = self.velocity * 0.75;
};

//------------------------------------------------------------------------//
//  Throws a shower of embers from 'self'.
//------------------------------------------------------------------------//
void(float ents, float smoke) Ember_Shower =
{
    local   entity  fire;
    local   vector  dir;
    local   float   loop;

    loop = ents * 6;
    while (loop > 0)
    {
        // Get initial direction.
        dir_x = (random() - 0.5) * 180;
        dir_y = random() * 360;
        dir_z = 0;
        makevectors (dir);
        dir = v_forward;

        traceline (self.origin, self.origin + dir*64, FALSE, other);
        if (trace_fraction == 1.0)
        {
            // Ember will not impact the wall immediately.
            fire = spawn();
            {
                setmodel (fire, "progs/flame2.mdl");
                setsize (fire, '0 0 0', '0 0 0');
                setorigin (fire, self.origin);

                fire.walkframe  = random() * 2 + 2.5;   //4.5;
                fire.walkframe  = floor(fire.walkframe);

                fire.frame      = $ember1 + fire.walkframe;
                fire.think      = Ember_Think;
            }

            fire.solid      = SOLID_BBOX;
            fire.movetype   = MOVETYPE_TOSS;
            fire.owner      = other;

            fire.velocity   = dir * (200 + random() * 800);
            fire.angles     = vectoangles(dir) + '90 0 0';

            fire.delay      = time + 0.5 + random();    // Time when it fades.

            fire.touch      = SUB_Remove;
            fire.nextthink  = time + 0.1;
//            fire.think      = Ember_Think;

            ents = ents - 1;
            if (ents <= 0)
                return;
        }

        loop = loop - 1;
    }
    smoke = FALSE;      // Commented out above, so appease FrikQcc.
};

//------------------------------------------------------------------------//
//  Spawns an ember and smoke in most of its think frames.
//------------------------------------------------------------------------//
void() Smokey_Think =
{
    if (self.wait > time)
        if (self.enemy.modelindex)
    {
        // Make a thin trail of smoke above the flame, plus a few embers.
        local   float   ftime;

        ftime = floor(time * 10);
        if (ftime & 1)
        {
            local   vector  spot;

            spot = Midpoint (self.enemy);
            MakeSmoke (spot, 5);
            if (ftime & 2)
                {if (!VecInWater (spot))  MakeFlame (self.enemy);}
        }
        self.nextthink = time + 0.1;
        return;
    }
    remove (self);
};

//------------------------------------------------------------------------//
//  This creates an entity that produces smoke and a few embers around
//  a given target 'ent'.  Used on targets that die from burning.
//------------------------------------------------------------------------//
void(entity ent) Smokey =
{
    // Create the fire.
    newmis = spawn();

    setmodel (newmis, "");
    setsize (newmis, '0 0 0', '0 0 0');
    setorigin (newmis, VEC_ORIGIN);

    newmis.solid      = SOLID_NOT;
    newmis.takedamage = DAMAGE_NO;
    newmis.enemy      = ent;
    newmis.wait       = time + 1 + random() * 2;
    newmis.nextthink  = 0.01;
    newmis.think      = Smokey_Think;
};


//==========================================================================
//  Fireballs

//  NOTE:  Fireballs are flames turned on its side.  In the official
//         GLQuake, this results in a shadow cast somewhere in the air.
//
//  One solution would be to add a fireball scene.  However, that causes
//  animation problems for embers in source ports that support frame
//  interpolation.  In addition, some of the source ports don't let
//  flames cast shadows (which is good).  Hence, no fireball scene.
//
//  Update:  Some ports automatically substitute 'flame2.mdl' with
//  other non-model graphics (decals?), and the projectiles appear more
//  like long flame trails, which look really bad.  Therefore, allow
//  the option for alternate fireball models.  Such models do not look
//  good in vanilla GLQuake or some other ports, but it's better than
//  nothing.

float   FIREBALL_RADIUS = 70;

//------------------------------------------------------------------------//
//  This creates steam that has the same velocity of the fireball that
//  spawned it.
//------------------------------------------------------------------------//
void(entity fire) Fireball_Steam =
{
    local   float   sped;
    local   vector  vel;

    sped = vlen (fire.velocity) * 0.01;
    vel = normalize (fire.velocity) * sped;

    sound (fire, CHAN_AUTO, "player/slimbrn2.wav", 1, ATTN_NORM);
    particle (fire.origin, vel, 1, 50);
};

//------------------------------------------------------------------------//
//  Check if fireball is in the water and if so remove it.
//  Returns TRUE if fireball was removed.
//------------------------------------------------------------------------//
float(entity fire) Fireball_InWater =
{
    local   float   pc;

    pc = pointcontents (fire.origin);
    if (pc <= CONTENT_WATER)
    {
        if ((pc == CONTENT_WATER) || (pc == CONTENT_SLIME))
            Fireball_Steam (fire);
        remove (fire);
        return TRUE;
    }
    return FALSE;
};

//------------------------------------------------------------------------//
//  This is the end of a fireball's think phase.
//------------------------------------------------------------------------//
void() Fireball_EndFrame =
{
    if (Fireball_InWater (self))
        return;

    // Fire is still burning, check again on the next frame.
    self.nextthink  = time + 0.1;
};

void(entity inflictor, entity attacker, float damage, entity ignore)
    T_FireballRadius =
{
    local   float   points, attn;
    local   entity  head;
    local   vector  org;

    head = findradius(inflictor.origin, FIREBALL_RADIUS);
    attn = damage / FIREBALL_RADIUS;

    while (head)
    {
        if (head != ignore)
        {
            if (head.takedamage)
            {
                org = head.origin + (head.mins + head.maxs)*0.5;
                points = attn * vlen(inflictor.origin - org);
                if (points < 0)
                    points = 0;
                points = damage - points;
                if (head == attacker)
                    points = points * 0.5;
                if (head.classname == "monster_shambler")
                    points = points * 0.5;  // shambler takes half damage from all explosions
                else if (head.classname == "monster_dragon")
                    if (self.skin == 0)     //SKIN_RED
                        points = 0;     // dragons are immune to fire.
                if (points > 0)
                {
                    T_Damage (head, inflictor, attacker, points);
                }
            }
        }
        head = head.chain;
    }
};

//------------------------------------------------------------------------//
//  Called when fireball impacts.  On impact, it explodes and inflicts
//  damage.
//------------------------------------------------------------------------//
void() Fireball_Touch =
{
    // If it is in the sky, disappear.
    if (pointcontents(self.origin) == CONTENT_SKY)
        {remove (self); return;}

    // If the flame is in water, dissolve into steam.
    self.velocity = normalize(self.velocity);
    if (Fireball_InWater (self))
        return;

    // hit something that bleeds
    T_FireballRadius (self, self.owner, self.dmg, other);
    self.origin = self.origin - 8*normalize(self.velocity);
    if (other.takedamage)
    {
        MakeFlame (other);
        T_Damage (other, self, self.owner, self.dmg);
    }

    self.effects = self.effects | EF_MUZZLEFLASH;
    if (self.noise)
        sound (self, CHAN_AUTO, self.noise, 1, ATTN_NORM);
    BecomeExplosion ();
};

//------------------------------------------------------------------------//
//  This updates the fireball's angles as it flies through the air.
//------------------------------------------------------------------------//
void() Fireball_Update =
{
    local   vector  dir;

    dir = normalize (self.velocity);
    self.angles = vectoangles(dir) + self.pos1;
// Update:  Use variable 'self.pos1' instead of always '90 0 0'.
};

//------------------------------------------------------------------------//
//  This gradually shrinks the fireball into nothing as it flies.
//------------------------------------------------------------------------//
void() Fireball_Fade =
{
    if (self.frame >= self.delay)
        {remove (self);  return;}
    self.frame = self.frame + 1;
    Fireball_Update ();
    Fireball_EndFrame ();
};

//------------------------------------------------------------------------//
//  This checks the fireball as it flies through the air.
//------------------------------------------------------------------------//
void() Fireball_Think =
{
    if (self.delay <= time)
    {
        // Make the fireball fade into nothing.  Takes 3 frames to fade.
        self.frame  = $ember2;
        self.delay  = $ember4;
        self.think  = Fireball_Fade;
    }
    Fireball_Update ();
    Fireball_EndFrame ();
};

//------------------------------------------------------------------------//
//  Create and launch a small fireball.
//------------------------------------------------------------------------//
void(entity attacker, vector start, vector dir, float sped, float damage)
    Fireball_Launch =
{
    local   entity  fire;
    local   vector  ofs;

    fire = spawn();
//    if (qrack)
//        {ofs = '0 0 0'; setmodel (fire, "progs/flame2a.mdl");}
//    else
        {ofs = '90 0 0'; setmodel (fire, "progs/flame2.mdl");}
    setsize (fire, '0 0 0', '0 0 0');
    setorigin (fire, start);
    fire.movetype   = MOVETYPE_FLYMISSILE;
    fire.solid      = SOLID_BBOX;
    fire.frame      = $flame;
    fire.angles     = vectoangles(dir) + ofs;
    fire.speed      = sped;
    fire.velocity   = dir * sped;
    fire.touch      = Fireball_Touch;
    fire.nextthink  = 0.01;
    fire.think      = Fireball_Think;
    fire.owner      = attacker;
    fire.delay      = time + 5;     // Was (8000 / sped), like in Quake2.
    fire.wait       = 0;
    fire.dmg        = damage;
    fire.classname  = "fire";
    fire.pos1       = ofs;

    // So fireball can be changed later.
    newmis = fire;
};


//==========================================================================
//  Super-sized Fireballs (a.k.a. Meteor)

//------------------------------------------------------------------------//
//  This fizzles then removes the meteor.
//------------------------------------------------------------------------//
void(entity fire) Meteor_Fizzle =
{
    local   float   pc;

    pc = pointcontents (fire.origin);
    if ((pc == CONTENT_WATER) || (pc == CONTENT_SLIME))
        Fireball_Steam (fire);
    remove (fire);
};

//------------------------------------------------------------------------//
//  This creates a small particle trail behind the shot.
//------------------------------------------------------------------------//
void(float rgb, float density, float full) Meteor_Trail =
{
    local   vector  delta;
    local   float   points;
    local   float   dist;
    local   vector  next;
    local   vector  end;

    delta = self.origin - self.oldorigin;
    dist = vlen(delta);

    if (full)
    {   // Unbroken, continuous trail.  Used by meteor.
        points = dist / 24;
        points = ceil(points);
        dist = -24;
    }
    else
    {   // Sparse, broken trail.  Useful for frost trails.
        if (deathmatch || coop)
            points = 2;
        else
            points = 3;
        dist = dist / points;
        dist = 0 - dist;
    }

    delta = normalize(delta);
    next = delta * dist;
    end = self.origin;

    while (points > 0)
    {
        particle (end, delta, rgb, density);
        end = end + next;
        points = points - 1;
    }

    // Update previous point.
    self.oldorigin = self.origin;
};

//------------------------------------------------------------------------//
//  The fireball explodes then creates a small cloud of fire.
//------------------------------------------------------------------------//
void() Meteor_Explode =
{
    // Do splash damage first then explode.
    T_RadiusDamage (self, self.owner, self.dmg, self.enemy);
    self.origin = self.origin - 8*normalize(self.velocity);

    if (self.enemy.takedamage)
    {   // Someone took a direct hit.
        local   float   damage;

        damage = self.dmg / 6 * (5 + random());
        T_Damage (self.enemy, self, self.owner, damage);
    }

    // Make a fiery explosion.
    FlameCube (self.origin, '0 0 50', self.dmg * 0.05, self.dmg, FlameCube_Flare);
    if (self.dmg >= 80)
        Tent_Point (TE_EXPLOSION, self.origin);
    else
        Tent_Explosion2 (self.origin, 96, 16);
    BecomeExplosion ();
};

//------------------------------------------------------------------------//
//  The large fireball explodes on contact and inflicts severe damage
//  within a radius.
//------------------------------------------------------------------------//
void() Meteor_Touch =
{
// Destroy fireball if it has no power or if it touches the sky.
    if (pointcontents(self.origin) == CONTENT_SKY)
        {remove (self); return;}
    if (self.dmg <= 0)
        {Meteor_Fizzle (self); return;}

// Do the damage.
    self.enemy = other;
    Meteor_Explode ();
};

//------------------------------------------------------------------------//
//  This checks the big fireball.  It loses strength if it travels
//  through water.  While active, the fireball leaves behind a trail
//  of steam or embers.
//------------------------------------------------------------------------//
void() Meteor_Think =
{
//- - - - - - - - -
// Particle trail.
    local   float   rgb;
    local   float   density;

    // Default trail is steam.
    rgb = 6;
    density = 16;

    if (VecInWater (self.origin))
    {   // Fireball loses strength in water.  Loses 10 damage per frame.
        // Used to be 10% damage in Dragons.
        self.dmg = self.dmg - 10;
        if (self.dmg < 0)
            self.dmg = 0;
    }
    else if (!VecInWater (self.oldorigin))
    {   // Fireball has not been in water lately, so make an ember trail.
        rgb = 233;
        density = 8;
    }
    Meteor_Trail (rgb, density, TRUE);
//- - - - - - - - -
    Fireball_Update ();

    // Fizzle if it lost all power.
    if (self.dmg <= 0)
        {Meteor_Fizzle (self); return;}

    // The fireball will explode after a period of time.
    if (self.delay < time)
        {Meteor_Explode (); return;}

    // Fire is still burning, check again.
    self.nextthink  = time + 0.1;
};

//------------------------------------------------------------------------//
//  This creates a large, highly explosive fireball.
//------------------------------------------------------------------------//
void(entity attacker, vector start, vector dir, float sped, float damage)
    Meteor_Launch =
{
    local   entity  fire;
    local   vector  ofs;

    fire = spawn();
//    if (qrack)
//        {ofs = '0 0 0'; setmodel (fire, "progs/flame2a.mdl");}
//    else
        {ofs = '90 0 0'; setmodel (fire, "progs/flame2.mdl");}
    setsize (fire, '0 0 0', '0 0 0');
    setorigin (fire, start);
    fire.movetype   = MOVETYPE_FLYMISSILE;
    fire.solid      = SOLID_BBOX;
    fire.frame      = $flameb;      // Use a *big* flame.
    fire.angles     = vectoangles(dir) + ofs;
    fire.speed      = sped;
    fire.velocity   = dir * sped;
    fire.touch      = Meteor_Touch;
    fire.nextthink  = 0.01;
    fire.think      = Meteor_Think;
    fire.owner      = attacker;
    fire.enemy      = world;
    fire.delay      = time + 5;     // Was (8000 / sped), like in Quake2.
    fire.wait       = 0;
    fire.dmg        = damage;
    fire.classname  = "fire";
    fire.pos1       = ofs;
    // Added rocket type flag so shamblers take less damage.

    fire.effects    = fire.effects | EF_DIMLIGHT;
    fire.oldorigin  = start;

    // So fireball can be changed later.
    newmis = fire;
};


//==========================================================================
//  Lightning

//------------------------------------------------------------------------//
//  This inflicts damage to an entity hit by the lightning bolt.
//------------------------------------------------------------------------//
void(entity targ, entity inflictor, entity attacker, vector org,
    float damage) BoltDamage =
{
    local   float   den;

    if (targ.classname == "monster_dragon")
        if (targ.skin == 2)     //SKIN_BLUE)
            damage = damage * 0.5;
    den = damage * 4;       //(damage * (1 - targ.resist_light)) * 4;
    den = floor (den);
    if (den > 0)
    {
        local   float   blud;

        blud = 225;     // Lightning blood.
        if (blud > 0)
            particle (org, '0 0 100', blud, den);     // Hit/bleed
        else
            particle (org, '0 0 20', 0 - blud, 10);   // chunks
    }
    T_Damage (targ, inflictor, attacker, damage);
};

//------------------------------------------------------------------------//
//  This strikes all entities hit by the lightning bolt.
//------------------------------------------------------------------------//
void(vector p1, vector p2, entity attacker, float damage, entity inflictor,
    float fx) LightningBolt =
{
// The old lightning code spawned two more invisible beams at weird places
// that could damage and kill more enemies (or teammates).  The new code
// below creates a single piercing bolt that hits everything in its path,
// like the railgun.  Lightning in many games (e.g., D&D, Diablo) pierce.

    local   entity  reflector;
    local   entity  ignore;
    local   entity  targ;
    local   vector  start;
    local   vector  dir;
    local   float   dist;
    local   float   delta;

    dir = p2 - p1;
    delta = vlen(dir);  // Get total length of bolt in case of reflection.
    dir = normalize(dir);

    reflector = world;
    ignore = attacker;
    start = p1;

    // Trace at least once.
    do
    {
        traceline (p1, p2, FALSE, ignore);

        p1 = trace_endpos;
        targ = trace_ent;

        if (targ.solid != SOLID_BSP)
            ignore = targ;
        else
            ignore = world;

        if (targ.takedamage)
            if (targ != inflictor)      // Dirty hack to prevent suicide.
            {
                BoltDamage (targ, inflictor, attacker, p1, damage);
            }

    // If current trace hits inflictor/attacker, next trace will miss all.
    // Move the new start point ahead slightly to prevent attacker from
    // hitting himself and preventing the bolt from piercing anymore.
    // (Note:  If attacker is inside the monster because of noclip,
    // he can still hit himself.)
        if (ignore)     // Always world if 'p2 == trace_endpos'.
        {
            dist = vlen(p2 - p1);
            if (dist > 1)
                p1 = p1 + dir;
            else
                ignore = world;   // Not enough distance left, so just stop.
        }
    }
    while (ignore);

    // Draw the lightning bolt between the two points.
    Tent_Beam (fx, inflictor, start, p1);
};
void(vector p1, vector p2, entity attacker, float damage) LightningBolt1 =
    { LightningBolt (p1, p2, attacker, damage, attacker, TE_LIGHTNING1); };
void(vector p1, vector p2, entity attacker, float damage) LightningBolt2 =
    { LightningBolt (p1, p2, attacker, damage, attacker, TE_LIGHTNING2); };


//==========================================================================
//  PLASMA (DoE style plasma, used by blue dragon and modified Mjolnir.)

// Called within 'BurstLit_Chain' below.
float(entity targ, entity inflictor, entity attacker, float damage,
    vector spot, float bang)  BurstLit_Trace =
{
    local   vector  end;

    if (targ.flags & FL_CLIENT)
        end = targ.origin;      // Use origin because of TE beam code for clients.
    else
        end = targ.origin + (targ.mins + targ.maxs)*0.5;
    //- - - - -
    // Update:  Traceline must hit intended target!
    // Targets can take damage from one bolt once because they
    // can neither stack nor pierce.
    //- - - - -
    traceline (spot, end, FALSE, inflictor);    // 3rd was TRUE.
    if (trace_ent == targ)
    {
        // Draw from source point to target point, except for players.
        // For players, draw from target point to source point
        // because engine always draws from origin in case of player.
        if (targ.flags & FL_CLIENT)
            Tent_Beam (TE_LIGHTNING2, targ, end, spot);
        else
            Tent_Beam (TE_LIGHTNING2, targ, spot, end);
        if (bang == 2)
            sound (inflictor, CHAN_VOICE, "weapons/lstart.wav", 1, ATTN_NORM);
        else if (bang)
            sound (inflictor, CHAN_VOICE, "weapons/lhit.wav", 1, ATTN_NORM);
        end = trace_endpos;     // Use where bolt hit for blood spot.
        BoltDamage (targ, inflictor, attacker, end, damage);
        return TRUE;
    }
    return FALSE;
};

// Shoots multiple lightning bolts at nearby targets from a common point.
// Used by burst lightning gun.  Also used by plasma discharge.
void(entity inflictor, entity attacker, float damage, entity ignore,
    vector spot, vector pak, float bang)  BurstLit_Chain =
{
    local   entity  head, saved;
    local   float   hits;
//    local   vector  end;

    local   float   nff, radius, hi;

    nff = pak_x;
    radius = pak_y;
    hi = pak_z;

    hits = 0;
    saved = world;
    head = findradius (spot, radius);
    while (head)
    {
    // Notarget/stealth won't save you from discharge.
        if (head.takedamage == DAMAGE_AIM)      // Was flags & FLx_CREATURE.
        if (head != attacker)
        if (head != ignore)
        if (head.health > 0)
        {
            if (BurstLit_Trace (head, inflictor, attacker, damage, spot, bang))
            {
                hits = hits + 1;
                if (hits >= hi)
                    return;
            }
        }
        head = head.chain;
    }
};


// Called by exploding plasma balls.  Also by Mjolnir.
void() Plasma_Discharge =
{
// Reference for DoE plasma discharge stats.
// BurstLit_Chain (self, self.owner, 50, world, self.origin, self.classname, '0 320 5', TRUE);
    local   vector  pak;

    pak_x = self.style;
    pak_y = self.distance;
    pak_z = self.count;     //5;

    BurstLit_Chain (self, self.owner, self.dmg*0.5, self.enemy, self.origin, pak, TRUE);
};

void() Plasma_Explode =
{
    if (!self.dmg)
        self.dmg = 100;
    if (!self.distance)
        self.distance = 320;
    if (!self.count)
        self.count = 5;

    if (self.enemy)
    {
        local   float   dmg1, dmg2;

        dmg1 = (0.8 + random()*0.2) * self.dmg;   // Was '80 + random()*20'.
    // PM:  Add discharge damage to impact damage, then ignore other in
    // the discharge call.  Saves a hit in the discharge for someone else.
        dmg2 = self.dmg * 0.5;

        if (self.enemy.classname == "monster_shambler")
            dmg1 = dmg1 * 0.5;      // Resists explosion damage.
        else if (self.classname == "monster_dragon")
        {
            if (self.enemy.skin == 2)     //SKIN_BLUE
            {   // Resists electrical damage.
                dmg1 = dmg1 * 0.5;
                dmg2 = dmg2 * 0.5;
            }
        }

        T_Damage (self.enemy, self, self.owner, dmg1 + dmg2);
    }
    // don't do radius damage to the other, because all the damage
    // was done in the impact
    // Note:  Radius damage was 70.
    T_RadiusDamage (self, self.owner, self.dmg*0.7, self.enemy);

    sound (self, CHAN_AUTO, "plasma/explode.wav", 1, ATTN_NORM);
    self.origin = self.origin - 8*normalize(self.velocity);
    setorigin (self, self.origin);      // PM:  Do it right.
    Tent_Explosion2 (self.origin, 244, 3);
    Plasma_Discharge ();

    BecomeAnyExplosion (138, 6, "progs/s_fancy.spr");
};

void() Plasma_Touch =
{
    if (pointcontents(self.origin) == CONTENT_SKY)
        {remove (self);  return;}

    self.enemy = other;
    Plasma_Explode ();
};

void() Plasma_Think =
{
    local   float   pc;

    if (self.delay <= time)
        {remove (self);  return;}
    pc = pointcontents(self.origin);
    if ((pc <= CONTENT_WATER) && (pc >= CONTENT_LAVA))
        {Plasma_Explode();  return;}

    particle (self.origin, self.velocity * 0.005, 9, self.waitmin);   //2
    particle (self.origin, self.velocity * 0.01, 41, self.waitmax);   //4
    self.nextthink = time + 0.05;
};

void(vector start, vector dir, float sped, float damage) Plasma_Launch =
{
    newmis = spawn ();
    newmis.owner        = self;
    newmis.movetype     = MOVETYPE_FLYMISSILE;
    newmis.solid        = SOLID_BBOX;
    newmis.classname    = "plasma";
// set missile speed
    newmis.movedir      = dir;
    newmis.speed        = sped;
    newmis.velocity     = dir * sped;
    newmis.avelocity    = '300 300 300';
    newmis.angles       = vectoangles(newmis.velocity);
// set missile damage
    newmis.dmg          = damage;
    //effects set below.
    newmis.distance     = damage + 220;     // 320 when dmg == 100.
    newmis.enemy        = world;
    newmis.style        = FALSE;    // TRUE is 'no friendly fire' discharge.
    // Note:  Mjolnir has a range of 350.
// set missile duration
    newmis.touch        = Plasma_Touch;
    newmis.delay        = time + 5;     // Total duration.  As spikes.
    newmis.nextthink    = 0.01;
    newmis.think        = Plasma_Think;

    // Big plasma balls from DoE.
    newmis.waitmin      = 2;
    newmis.waitmax      = 4;
    newmis.effects      = EF_DIMLIGHT;  // DoE used EF_BRIGHTLIGHT.
    setmodel (newmis, "progs/plasma.mdl");
    setsize (newmis, '0 0 0', '0 0 0');
    setorigin (newmis, start);
};


//==========================================================================
//  Acid Bomb -- Used by green dragon.

void() Acidball_Touch =
{
    if (pointcontents(self.origin) == CONTENT_SKY)
        {remove (self); return;}

    self.touch = SUB_Null;
    self.enemy = other;

    if (!self.dmg)
        self.dmg = 120;

    // Don't bother with green dragon acid resistance.
    if (self.enemy)     // Don't check health, just if there is a target.
    {   // Someone took a direct hit.
        local   float   damage;

        damage = self.dmg / 6 * (5 + random());
        T_Damage (self.enemy, self, self.owner, damage);
    }
    // Don't do radius damage to the enemy, because all the damage
    // was done in the impact.
    T_RadiusDamage (self, self.owner, self.dmg, self.enemy);

// PM:  Don't set origin directly during a touch function because of
// possible link scrambling.  May cause FitzQuake to crash otherwise.
    self.origin = self.origin - 8*normalize(self.velocity);
    Tent_Explosion2 (self.origin, 48, 16);
    BecomeAnyExplosion (115, 5, "progs/s_fancy.spr");
};

void(vector start, vector dir, float sped, float damage) Acidball_Launch =
{
    newmis = spawn ();
    newmis.owner        = self;
    newmis.movetype     = MOVETYPE_TOSS;
    newmis.solid        = SOLID_BBOX;
    newmis.classname    = "acid";
// set missile speed
    newmis.speed        = sped;
    newmis.velocity     = dir * sped;
    newmis.avelocity    = '200 100 300';
    newmis.angles       = vectoangles(newmis.velocity);
// set missile damage
    newmis.dmg          = damage;
// set missile special stuff
    newmis.dest         = dir;
// set missile duration
    newmis.touch        = Acidball_Touch;
    newmis.nextthink    = time + 5;
    newmis.think        = SUB_Remove;

    setmodel (newmis, "progs/acidbal1.mdl");
    setsize (newmis, '0 0 0', '0 0 0');
    setorigin (newmis, start);
};


//==========================================================================
//  Acid -- Used by scrag and green dragon.

void() Acid_Think =
{
    if (self.delay <= time)
        {remove (self); return;}

//    self.angles = normalize (self.velocity);
//    self.angles = vectoangles (self.angles);
    self.angles = vectoangles (self.velocity);
    self.nextthink = time + 0.1;
};

void(vector start, vector dir, float sped) Acid_Launch =
{
    launch_spike (start, dir);
    setmodel (newmis, "progs/w_spike.mdl");
    setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);        
    newmis.worldtype = TE_WIZSPIKE;
    newmis.classname = "wizspike";
    newmis.speed     = sped;
    newmis.velocity  = dir * sped;
};

void(vector start, vector dir, float sped) Acid_Toss =
{
    Acid_Launch (start, dir, sped);

    newmis.movetype  = MOVETYPE_TOSS;
    newmis.speed     = sped;
    newmis.velocity  = (dir * sped) + '0 0 200';
    newmis.angles    = vectoangles (newmis.velocity);
    newmis.delay     = newmis.nextthink;
    newmis.nextthink = time + 0.1;
    newmis.think     = Acid_Think;
};


//==========================================================================
//  Ice Shards -- Used by white dragon, ice imp, and Rapture's water baron.

void() Ice_Touch =
{
    if (pointcontents(self.origin) <= CONTENT_LAVA)     // Lava or sky.
        {remove(self);  return;}

    if (other.takedamage)
    {   // Check cold resistance here instead of in the damage functions
        // because it affects how much blood is spawned.
        if (other.classname == "monster_dragon")
            if (other.skin == 3)    //SKIN_WHITE)
                self.dmg = self.dmg * 0.5;
        if (self.dmg > 0)
        {
            spawn_touchblood (self.dmg);
            T_Damage (other, self, self.owner, self.dmg);
            remove (self);
            return;
        }
    }

    {   // Ice chunks.
        local   vector  vel;

        vel = wall_velocity () * 0.2;
        particle ((self.origin + vel*0.01), vel*0.1, 41, 20);
    }

    sound (self, CHAN_WEAPON, "dragon/icehit.wav", 1, ATTN_NORM);
    remove (self);
};

void() Ice_Think =
{
    Meteor_Trail (39, 2, FALSE);    // Function in 'fire.qc'.
    if (self.delay <= time)
        {remove (self); return;}
    if (pointcontents(self.origin) == CONTENT_LAVA)
        {remove (self); return;}

    self.nextthink = time + 0.1;
};

void(vector start, vector dir, float sped) Ice_Launch =
{
    newmis = spawn ();
    newmis.owner        = self;
    newmis.movetype     = MOVETYPE_FLYMISSILE;
    newmis.solid        = SOLID_BBOX;
    newmis.classname    = "ice";
// set missile speed
    newmis.speed        = sped;
    newmis.velocity     = dir * sped;
    newmis.angles       = vectoangles(newmis.velocity);
// set missile damage
    newmis.dmg          = 9;
//    newmis.enemy        = targ;
// set missile special stuff
//    newmis.lefty        = 0;
    newmis.dest         = dir;
    newmis.oldorigin    = start;    // For proper particle trail drawing.
    newmis.alpha        = 0.7;
// set missile duration
    newmis.touch        = Ice_Touch;
    newmis.delay        = time + 5;     // Total duration.  As spikes.
    newmis.nextthink    = 0.01;
    newmis.think        = Ice_Think;

    setmodel (newmis, "progs/ice.mdl");
    setsize (newmis, '0 0 0', '0 0 0');        
    setorigin (newmis, start);

//    launch_spike (start, dir);
//    setform (newmis, "progs/ice.mdl", VEC_ORIGIN, VEC_ORIGIN);        
//    newmis.style     = TE_KNIGHTSPIKE;
//    newmis.classname = "ice";
//    newmis.velocity  = dir*sped;
};


//==========================================================================
//  Iceballs -- Used by white wyrm.

void() Iceball_Touch =
{
    if (pointcontents(self.origin) == CONTENT_SKY)
        {remove (self); return;}

    self.touch = SUB_Null;
    self.enemy = other;

    if (!self.dmg)
        self.dmg = 120;

    // Don't bother with green dragon acid resistance.
    if (self.enemy)     // Don't check health, just if there is a target.
    {   // Someone took a direct hit.
        local   float   damage;

        damage = self.dmg / 6 * (5 + random());
        T_Damage (self.enemy, self, self.owner, damage);
    }
    // Don't do radius damage to the enemy, because all the damage
    // was done in the impact.
    T_RadiusDamage (self, self.owner, self.dmg, self.enemy);

// PM:  Don't set origin directly during a touch function because of
// possible link scrambling.  May cause FitzQuake to crash otherwise.
    self.origin = self.origin - 8*normalize(self.velocity);

    sound (self, CHAN_AUTO, "weapons/shatter.wav", 1, ATTN_NORM);
    Tent_Explosion2 (self.origin, 32, 16);
    ShockWave (self.origin, RING_ICE, 3, "progs/s_wave.spr");
    BecomeIcyExp ();
};

// Thinking for iceballs.  Unlike shards, balls explode instead of melting.
void() Iceball_Think =
{
// Bigger ice chunks, so spawn a beam of frost.
    Meteor_Trail (39, 2, TRUE);     // Function in 'fire.qc'.
    if (self.delay > time)
        if (pointcontents(self.origin) != CONTENT_LAVA)
            {self.nextthink = time + 0.1;  return;}

// Time to blow up.
    Iceball_Touch ();
};

// Launch an explosive icy spikeball.
void(vector start, vector dir, float sped, float damage) Iceball_Toss =
{
    Ice_Launch (start, dir, sped);

    setmodel (newmis, "progs/iceball.mdl");
    setsize (newmis, '0 0 0', '0 0 0');

    newmis.movetype = MOVETYPE_TOSS;
    newmis.avelocity = '300 300 300';
    newmis.dmg      = damage;
    newmis.alpha    = 0.9;  //ALPHA_ICEBALL;
    newmis.touch    = Iceball_Touch;
    newmis.think    = Iceball_Think;
};


//===========================/  END OF FILE  /===========================//

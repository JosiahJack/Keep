//========================================================================

//============
// --> QUAKED item_zerlogo (0 .5 .8) (-16 -16 0) (16 16 56)
// Zerstorer logo model.
//============
void() item_zerlogo = {remove(self);};
//{
//    cache_set ("progs/zerlogo.mdl");
//    setsize (self, '-16 -16 0', '16 16 56');
//    StartItem ();
//};

//========================================================================

/* Strips player of ammo.  Used in GYG only.  */

void() strip_touch =
{
    if (other.classname != "player")
        return;

// PM:  Kill all pets!
    Pets_Free (other);
// PM:  End Dragons.

    other.ammo_shells   = 0;    //25;
    other.ammo_nails    = 0;
    other.ammo_rockets  = 0;
    other.ammo_cells    = 0;
    other.ammo_super    = 0;    // 11/5/09:  Yes, even the crossbow.
    other.arsenal       = other.arsenal & (WAR_AXE | WAR_SHOTGUN) & legalized;
    other.war           = other.arsenal & WAR_AXE;

    War_UpdateAll (other);
    SUB_Think (other, War_SetCurrentAmmo);
    SUB_Think (other, SUB_RemovePowerups);

    remove (self);
};

//============
// --> QUAKED trigger_strip (.5 .5 .5) ?
// Variable sized trigger. Triggers once, then removes itself...
// after it strips a player of all ammo, weapons, powerups, and pets.
// Touch only.
//============
void() trigger_strip = {InitTrigger (); self.touch = strip_touch;};


//=======================================
//  Remove anything that touches this trigger.  for 'zerend'.

//void() tr_touch =
//{
//    if (other.classname != "player")
//        if (vlen(other.velocity) > 0)
//            remove (other);     //dprint("removed\n");
//};

//void() trigger_remove = {InitTrigger (); self.touch = tr_touch;};

//==========================================

// PM:  'func_rain' is a part of 'swap.qc' thanks to DarkPlaces alternative.


//==========================================================================
/* ------------------------------ */
/* |       trigger_gravity      | */
/* ------------------------------ */
/*QUAKED trigger_gravity (.5 .5 .5) (-8 -8 -8) (8 8 32)
This will change the gravity for objects that are inside it.
Put the value to change gravity to in the "gravity" field.
Ziggurat Vertigo used '100' for its low gravity.
*/
void() gravity_use =
{
    if (self.cnt == -1)
        self.cnt = 0;   //dprint("Anti-gravity machine turned ON\n");
    else
        self.cnt = -1;  //dprint("Anti-gravity machine turned OFF\n");
};

void() gravity_touch =
{
    if (self.cnt == -1)
        return;
    if (other.deadflag < DEAD_DEAD)
      if (other.velocity_z != 0)
        if (other.movetype != MOVETYPE_FLYMISSILE)
          if (other.classname != "BloodCube")
            other.velocity_z = other.velocity_z + (self.delay * frametime);
};

void() trigger_gravity = 
{
    InitTrigger ();
    self.delay = cvar("sv_gravity") - self.gravity;
    self.touch = gravity_touch;

    if (self.targetname)
        {self.cnt = -1; self.use = gravity_use;}
};


// PM:  trigger_quake modified and moved to 'cool.qc' to merge with my
// quake code.

//==========================================================================

float SPAWN_GLASS = 2;

void() brik_touch =
{
    if (self.velocity == '0 0 0')
    {
        self.avelocity  = '0 0 0';
        self.solid      = SOLID_NOT;
        self.touch      = SUB_Null;
        self.think      = SUB_Remove;
        self.nextthink  = time + (6 * random()) + 2;
        return;
    }
    if (!self.cnt)
        return;

    if (self.attack_finished < time)
        if (pointcontents(self.origin) > CONTENT_WATER) // empty or solid only
    {
    //bounce sound
        if (self.cnt == 1)
            sound (self, CHAN_AUTO, "ambience/brik_hit.wav", 1, ATTN_NORM);   
        else
            sound (self, CHAN_AUTO, "ambience/brikhit2.wav", 1, ATTN_NORM);   

        self.attack_finished = time + 0.3;
    }
};


void(string gibname, float dm) ThrowRubble =
{
    local   entity  new;

    new = spawn();
    // new.origin = self.origin doesnt work because the origin
    // is at world (0,0,0).
    new.origin_x = self.absmin_x + (random() * self.size_x);
    new.origin_y = self.absmin_y + (random() * self.size_y);
    new.origin_z = self.absmin_z + (random() * self.size_z);
    setmodel (new, gibname);
    setsize (new, '0 0 0', '0 0 0');

    if (gibname == "progs/tgib1.mdl" || gibname == "progs/tgib2.mdl")
        new.cnt = 1;
    else if (gibname == "progs/tgib3.mdl" || gibname == "progs/tgib4.mdl")
        new.cnt = 2;
    else
    {
        local   float   sndrnd;

        sndrnd = random();
        if (sndrnd < 0.25)
            new.cnt = 1;
        else if (sndrnd < 0.5)
            new.cnt = 2;
    }

    new.velocity    = VelocityForDamage (dm);
    new.movetype    = MOVETYPE_BOUNCE;
    new.classname   = "rubble";
    new.solid       = SOLID_TRIGGER;
    new.touch       = brik_touch;
    new.avelocity_x = random()*600;
    new.avelocity_y = random()*600;
    new.avelocity_z = random()*600;
    new.think       = SUB_Remove;
    new.ltime       = time;
    new.nextthink   = time + 10 + random()*10;
    new.frame       = 0;
    new.flags       = 0;
};

void () wall_killed =
// Called when the wall is destroyed.  Throws gibs (rubble).
{
    local   entity  sndspot;
    local   float   rubble_count;
    local   vector  vel;

    rubble_count = 0;
    sndspot = spawn();
    sndspot.origin = self.absmin;
    setorigin (sndspot, sndspot.origin);
    if (self.spawnflags & 16)
        sound (sndspot, CHAN_AUTO, "ambience/wall01.wav", 1, ATTN_NONE);
    else
        sound (sndspot, CHAN_AUTO, "ambience/wall01.wav", 1, ATTN_NORM);
    remove (sndspot);

    // determine volume of destroyed wall and throw rubble accordingly
    rubble_count = (self.size_x * self.size_y * self.size_z) / 64000;
    if (rubble_count > 5)
        rubble_count = 6;

    if (self.spawnflags & SPAWN_GLASS)
    {
        while (rubble_count > -1)
        {
            vel_x = random() * 100 - 50;
            vel_y = random() * 100 - 50;
            vel_z = random() * 100;
            damage_velocity = vel;

            ThrowRubble ("progs/rubble4.mdl", -100);
            ThrowRubble ("progs/rubble4.mdl", -100);
            ThrowRubble ("progs/rubble4.mdl", -100);
            ThrowRubble ("progs/rubble4.mdl", -100);
            ThrowRubble ("progs/rubble4.mdl", -100);
            ThrowRubble ("progs/rubble4.mdl", -100);
            ThrowRubble ("progs/rubble4.mdl", -100);
            ThrowRubble ("progs/rubble4.mdl", -100);
            ThrowRubble ("progs/rubble4.mdl", -100);
            ThrowRubble ("progs/rubble4.mdl", -100);
            ThrowRubble ("progs/rubble4.mdl", -100);
            ThrowRubble ("progs/rubble4.mdl", -100);
            ThrowRubble ("progs/rubble4.mdl", -100);
            ThrowRubble ("progs/rubble4.mdl", -100);
            ThrowRubble ("progs/rubble4.mdl", -100);
            ThrowRubble ("progs/rubble4.mdl", -100);
            ThrowRubble ("progs/rubble4.mdl", -100);
            ThrowRubble ("progs/rubble4.mdl", -100);
            rubble_count = rubble_count - 1;
        }
    }
    else
    {
        while (rubble_count > -1)
        {
            vel_x = random() * 100 - 50;
            vel_y = random() * 100 - 50;
            vel_z = random() * 100;
            damage_velocity = vel;
            ThrowRubble ("progs/rubble1.mdl", self.health);
            ThrowRubble ("progs/rubble2.mdl", self.health);
            ThrowRubble ("progs/rubble3.mdl", self.health);
            rubble_count = rubble_count - 1;
        }
    }
    activator = self;
    SUB_UseTargets();
    if (self.classname != "monster_demon1")
        remove (self);
};

void() wall_pain = {self.health = self.max_health;};

void() wall_use =
{
    self.health = -100;
    self.dest_x = (random() * 10) - 5;
    self.dest_y = (random() * 10) - 5;
    self.dest_z = (random() * 10);
    wall_killed ();
};

//============
// --> QUAKED exploding_wall
// When the exploding wall is shot, it "gibs" into rubble.
// "target"   all entities with a matching targetname will be used when killed
// "health"   the amount of damage needed to destroy the wall instead of touched
//============
void() exploding_wall =
{
    setmodel (self, self.model);
    // precache rubble models
    if (self.spawnflags & SPAWN_GLASS)
        precache_model ("progs/rubble4.mdl");
    else
    {
        precache_model ("progs/rubble1.mdl");
        precache_model ("progs/rubble2.mdl");
        precache_model ("progs/rubble3.mdl");
        // precache sounds
        precache_sound ("ambience/wall01.wav");
        precache_sound ("ambience/brik_hit.wav");
        precache_sound ("ambience/brikhit2.wav");
    }
    self.solid      = SOLID_BBOX;
    self.movetype   = MOVETYPE_NONE;

    if (self.health)
        self.max_health = self.health;
    else
        self.max_health = 100;
    self.th_die     = wall_killed;
    self.takedamage = DAMAGE_YES;
    self.th_pain    = wall_pain;
    if (self.targetname)
    {
        self.use        = wall_use;
        self.max_health = 10000;
    }
};

//==========================================================================

/*
    func_frame
    Written by Matt Houser   & modified by Darin McNeil (1/26/97)
    fisty@canweb.net
    Ripped off...err... inspired by Dimensionalitiy's func_frame
    18:48GMT-5:12/31/96
    Usage:
        Required:
    "classname" "func_frame"
    "targetname" "..."    - Name of group of frames, also targetname for toggling on and off
    "cnt" "#"            - Frame # (1 based)
    
        Optional: (only frame #1 is checked)
    "dmg" "#"        - Damage on touch (only when moving)
    "target" "..."    - Target to call on touch
    "spawnflags" "#"    - bit 1: Use on touch (frame will advance on touch, and
                        "target" will be triggered)
                    - bit 2: Stopped at start
                    - bit 3: Back and forth rather than looping
    "wait" "#"    - Time delay between this frame and the next (default is 0.1,
                    -1 should stop the animation)

    - Frames are played in order starting at 1 (duplicates may be missed)
    - On use, animation will start or stop
    - When stopped, no damage will be done

    TODO:
        - Incorporate sound somehow
        - Tidy up the back and forth code, Manero insisted on having it so I did it...
            blame him for it's untidyness
            
    BUGS:
        - Slight disfiguration on some walls while moving
        - Slightly larger delay when looping back to frame #1 (gone now, not sure why)
*/

float FF_USEONTOUCH = 1;
float FF_STOPPED = 2;
float FF_BACKANDFORTH = 4;

entity(float thisCount) func_frame_find_frame =
{
    local entity e;
    // find all the entities that have our targetname
    e = find(world, targetname, self.targetname);
    while (e != world)
    {
        // cycle thru until we found the right frame
        if (e.cnt == thisCount && e.classname == "func_frame")
            //we found it
            return e;
        e = find(e, classname, "func_frame");
    }
    return world;
};

void() func_frame_change_frame =
{
    local entity e;
    local float thisCount;
    
    if (self.cnt != 1)
        return;
    
    // which way? forward of reverse?    
    if (self.spawnflags & FF_BACKANDFORTH)
    {
        if (self.state) // reverse
        {
            if (self.enemy.cnt == 1) // we've hit the start of our loop, reverse gear
            {
                thisCount = 2;
                self.state = 0; // forward now
            }
            else
                thisCount = self.enemy.cnt - 1;
        }
        else
            thisCount = self.enemy.cnt + 1;
    }
    else
        thisCount = self.enemy.cnt + 1;
    // find the next frame
    if (thisCount == 1)
        e = self.goalentity;
    else
        e = func_frame_find_frame(thisCount);
    if (e == world)
    {
        // end of loop
        if (self.spawnflags & FF_BACKANDFORTH)
        {
            self.state = 1;    // backwards now
            e = func_frame_find_frame(self.enemy.cnt - 1);
            if (e == world)
            {
                // double wammy
                self.state = 0;
                e = self.goalentity;
            }
        }
        else
            e = self.goalentity;
    }

    // set the frame for future use
    self.enemy = e;

    // set the model
    setmodel(self, e.model);
    if ( !(self.spawnflags & FF_USEONTOUCH) )
    {
        if (e.wait < 0)    // if we've hit a -1 wait, signal a stopped state
        {
// dhm - Make the frames stop, and make it not solid so that you
//      can used this for doors, etc.

            sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
            self.spawnflags = self.spawnflags | FF_STOPPED;
            //self.think = SUB_Null;
            self.solid = SOLID_NOT;
            return;
        }
        else if (self.spawnflags & 2)
            // otherwise just make sure our state is the moving state
            self.spawnflags = self.spawnflags - FF_STOPPED;
        self.nextthink = time + e.wait;
    }
};

void() func_frame_use =
{
    // only #1 should do any using
    if (self.cnt != 1)
        return;

    // we don't use if we use on touch
    if (self.spawnflags & FF_USEONTOUCH)
        return;
        
    // we use spawnflags & FF_STOPPED to tell if we're moving or not
    if (self.spawnflags & FF_STOPPED)
    {
        // get moving
        sound (self, CHAN_VOICE, self.noise1, 1, ATTN_NORM);
        self.spawnflags = self.spawnflags - FF_STOPPED;
        func_frame_change_frame();
    }
    else
    {
        // stop
        self.nextthink = -1;
        self.spawnflags = self.spawnflags | FF_STOPPED;
    }
};

void() func_frame_touch =
{
    // only #1 should be touchable
    if (self.cnt != 1)
        return;
        
    // damage
    if (self.dmg && !(self.spawnflags & FF_STOPPED) )
        T_Damage(other, self, self, self.dmg);

    // change frame on touch only
    if (self.spawnflags & FF_USEONTOUCH)
    {
        func_frame_change_frame();
        // use any targets this may be dealing with
        activator = other;
        SUB_UseTargets();
    }
};

void() func_frame =
{
    // initial error checking
    if (!self.targetname)
    {
        // no targetname, no way to group
        objerror("func_frame without a targetname\n");
        remove(self);
    }
    if (!self.cnt)
    {
        // no cnt, no way to know which frame this is
        objerror("func_frame without a cnt\n");
        remove(self);
    }
    if (!self.wait)
        self.wait = 0.1;    // how long the current frame stays put

    if (self.cnt == 1)
    {
        self.solid = SOLID_BBOX;
        self.movetype = MOVETYPE_NONE;

        // 1 does all the work, 2 and so on are just additional frames
        setmodel(self, self.model);

        // duplicate ourself to save our model
        self.goalentity = spawn();
        self.goalentity.classname = "func_frame";
        self.goalentity.model = self.model;
        self.state = 0;
        self.goalentity.cnt = self.cnt;
        self.goalentity.wait = self.wait;
        self.use = func_frame_use;
        self.touch = func_frame_touch;
        
        self.enemy = self;    // enemy says which frame we're on
        if ( !(self.spawnflags & FF_USEONTOUCH) )
        {
            self.think = func_frame_change_frame;
            if ( !(self.spawnflags & FF_STOPPED) )
                self.nextthink = time + self.wait;
        }
    }
    
    //DHM: sounds from ACS func_train
    if (self.sounds == 0)
    {
        self.noise = ("misc/null.wav");
        precache_sound ("misc/null.wav");
        self.noise1 = ("misc/null.wav");
        precache_sound ("misc/null.wav");
    }
    else if (self.sounds == 1)
    {
        self.noise = ("plats/train2.wav");
        precache_sound ("plats/train2.wav");
        self.noise1 = ("plats/train1.wav");
        precache_sound ("plats/train1.wav");
    }
//dhm - new sounds from 'func_door'
    else if (self.sounds == 2)
    {
        precache_sound ("doors/drclos4.wav");
        precache_sound ("doors/doormv1.wav");
        self.noise = "doors/drclos4.wav";
        self.noise1 = "doors/doormv1.wav";
    }
    else if (self.sounds == 3)
    {
        precache_sound ("doors/hydro1.wav");
        precache_sound ("doors/hydro2.wav");
        self.noise1 = "doors/hydro1.wav";
        self.noise = "doors/hydro2.wav";
    }
    else if (self.sounds == 4)
    {
        precache_sound ("doors/stndr1.wav");
        precache_sound ("doors/stndr2.wav");
        self.noise1 = "doors/stndr1.wav";
        self.noise = "doors/stndr2.wav";
    }
    else if (self.sounds == 5)
    {
        precache_sound ("doors/ddoor1.wav");
        precache_sound ("doors/ddoor2.wav");
        self.noise = "doors/ddoor2.wav";
        self.noise1 = "doors/ddoor1.wav";
    }
};

//==========================================================================

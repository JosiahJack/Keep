// tronyn.qc -- For speciality content present in Tronyn's paks.

//==========================================================================
//
//  A ROMAN WILDERNESS OF PAIN
//
//==========================================================================

//==========================================================================
//  Spike Bed

void() misc_spikes_touch =
{
    if (!other.takedamage)
        return;     // Can't kill me.
    if (other.deadflag)
        return;     // Already dead.
    if (other.origin_z + other.mins_z < self.origin_z + self.maxs_z)
        return;     // Below spikes.

// Squish!
    sound (self, CHAN_WEAPON, "bane/hit.wav", 1, ATTN_NORM);
    T_Kill (other, self, self, other.gib_health - 1, "was impaled on spikes");
};

//============
// --> QUAKED misc_spikes (0 .5 .8) (-32 -32 0) (32 32 48)
// Spikes for roman start map.  (Which I built!)
// Custom made to avoid placing lots of thin
// brushes which can greatly increase vis times
// (and maybe r_speeds for that matter).
//============
void() misc_spikes =
{
    self.solid      = SOLID_BBOX;
    self.movetype   = MOVETYPE_NONE;
    cache_set ("progs/spikes32.mdl");
    precache_sound ("bane/hit.wav");
    self.takedamage = DAMAGE_NO;
    self.classname  = "spikes";
    self.touch      = misc_spikes_touch;
    setall (self, "progs/spikes32.mdl", '-32 -32 0', '32 32 48', self.origin);

    self.origin_z   = self.origin_z + 2;
    if (!droptofloor ())
    {
        print_self (self.classname, " fell out of level at ");
        remove (self);
    }
};


//==========================================================================
//
//  ARCANUM
//
//==========================================================================

//==========================================================================
//  Lightning Trigger

// Easy lightning triggers for Tronyn's maps.

void() trilight_think = [ 0, trilight_think ]
{
    local   entity  e1, e2;
    local   vector  p1, p2;
//    local   vector  dir;
//    local   float   dist;
    local   float   play;

    play = FALSE;
    if (self.t_width <= time)
        {play = TRUE;  self.t_width = time + 0.6;}

    e1 = find (world, targetname, self.target);
    if (!e1)
        return;
    p1 = Midpoint (e1);
    e2 = find (e1, targetname, self.target);
    while (e2)
    {
        p2 = Midpoint (e2);
//- - - - - - - - -
//        dir = p2 - p1;
//        dist = vlen(dir) / 30;
//        dir = normalize(dir);
//        dist = dist - floor(dist);
//        if (dist)
//        {   // split half the remainder with the front and back
//            dist = (dist - 1) * 15;
//            dir = dist * dir;
//            p1 = p1 + (dir);
//            p2 = p2 - (dir);
//        }
//- - - - - - - - -
        p2 = ChainLit_Point (e1, e2, p1, p2);   // In 'light.qc'.
        if (play)
            sound (e1, 7, self.noise, 1, ATTN_NORM);
        if (self.dmg < 1)
            Tent_Beam (self.worldtype, e1, p1, p2);
        else
            LightningBolt (p1, p2, self, self.dmg, e1, self.worldtype, self.deathtype);
        p1 = p2;
        e1 = e2;
        e2 = find (e1, targetname, self.target);
    }

    if (self.attack_finished <= time)
    {
        self.attack_finished = 0;
        self.think = SUB_Null;
    }
};

void() trilight_use =
{
    if (self.attack_finished)
        return;

    self.attack_finished = time + self.wait;
    trilight_think ();

// Hipnotic's cnt stuff - - - - - - - -
    HipCntDown ();
//- - - - - - - - - - - - - - - - - - -
};
void() trilight_touch =
{
    if (other.classname != "player")
        return;
    trilight_use ();
};

void(float pt) trigger_lightning_spawn =
{
    local   float   beamtype;

//self.wait = 10; self.dmg = 20; self.sounds = 2; self.worldtype = 1;
//self.wait = 5; self.dmg = 10; self.sounds = 2; self.worldtype = 3;
    // The other bolts are already precached.
    precache_model ("progs/bolt3.mdl");

    if (self.sounds == 2)
        self.noise = "misc/power.wav";
    else if (self.sounds == 1)
        self.noise = "weapons/lstart.wav";
    else
        self.noise = "weapons/lhit.wav";
    precache_sound (self.noise);

    if (!self.target)
        objerror ("no target");

    beamtype = self.worldtype;
    if (beamtype == 3)
        self.worldtype = TE_LIGHTNING3;
    else if (beamtype == 1)
        self.worldtype = TE_LIGHTNING1;
    else
        self.worldtype = TE_LIGHTNING2;

    if (pt)
        InitPointTrigger ();
    else
        InitTrigger ();
    if (self.targetname)
        self.use = trilight_use;
    else
        self.touch = trilight_touch;

    if (!self.deathtype)
        self.deathtype = "was electrocuted";
    if (!self.wait)
        self.wait = 0.1;
    self.attack_finished = 0;
    self.t_width = 0;
// Hipnotic's cnt stuff - - - - - - - -
    if (!self.cnt)
        self.cnt = -1;
//- - - - - - - - - - - - - - - - - - -
};

void() trigger_lightning = {trigger_lightning_spawn (FALSE);};
void() trigger_lightning_point = {trigger_lightning_spawn (TRUE);};


//==========================================================================
//  Circle of Sparks (arcanum2.bsp only)

void() magic_think = [ 0, magic_think ]
{
    DrawCircleXY (self.origin, self.lip, self.weapon);
    self.cnt = self.cnt - 1;
    if (self.cnt < 1)
        self.nextthink = -1;
};

void() magic_use = {self.cnt = self.count;  magic_think ();};

//weapon = 255, count = 40, lip = 96
void() misc_magic = {self.use    = magic_use;};


//==========================================================================
//
//  SOUL OF EVIL
//
//==========================================================================

/* DISABLED -- Unused legacy code from FC's SOE source.
float() rand_time = {return (time + 1 + random() * 30);};

void() func_thumpsound_play =
{
    local   float   r;
    local   string  text;

    r = random() * 8;
    if (r < 1)
        text = "random/thump/thump_1.wav";
    else if (r < 2)
        text = "random/thump/thump_2.wav";
    else if (r < 3)
        text = "random/thump/thump_3.wav";
    else if (r < 4)
        text = "random/thump/thump_4.wav";
    else if (r < 5)
        text = "random/thump/thump_5.wav";
    else if (r < 6)
        text = "random/thump/thump_6.wav";
    else if (r < 7)
        text = "random/thump/thump_7.wav";
    else
        text = "random/thump/thump_8.wav";

    sound (self, CHAN_AUTO, text, 1, ATTN_NORM);
    self.nextthink = rand_time ();
};

void() func_sound_thump =
{
    precache_sound ("random/thump/thump_1.wav");
    precache_sound ("random/thump/thump_2.wav");
    precache_sound ("random/thump/thump_3.wav");
    precache_sound ("random/thump/thump_4.wav");
    precache_sound ("random/thump/thump_5.wav");
    precache_sound ("random/thump/thump_6.wav");
    precache_sound ("random/thump/thump_7.wav");
    precache_sound ("random/thump/thump_8.wav");

    self.think = func_thumpsound_play;
    self.nextthink = rand_time();
};


void() func_wind_play =
{
    local   float   r;
    local   string  text;

    r = random() * 5;
    if (r < 1)
        text = "random/wind_1.wav";
    else if (r < 2)
        text = "random/wind_2.wav";
    else if (r < 3)
        text = "random/wind_3.wav";
    else if (r < 4)
        text = "random/wind_4.wav";
    else
        text = "random/wind_5.wav";

    sound (self, CHAN_AUTO, text, 1, ATTN_NORM);
    self.nextthink = rand_time ();
};

void() func_sound_wind =
{
    precache_sound ("random/wind_1.wav");
    precache_sound ("random/wind_2.wav");
    precache_sound ("random/wind_3.wav");
    precache_sound ("random/wind_4.wav");
    precache_sound ("random/wind_5.wav");

    self.think = func_wind_play;
    self.nextthink = rand_time();
};
*/


//- - - - - - - - -
//  Corpses

/* Todo:  Let corpses get splattered.
void() corpse_die =
{
	ThrowGib ("progs/gib1.mdl", self.health);
	ThrowGib ("progs/gib2.mdl", self.health);
	ThrowGib ("progs/gib3.mdl", self.health);
    sound (self, CHAN_VOICE, "misc/decomp.wav", 1, ATTN_NORM);
    SUB_UseTargets ();
// Can't remove now because we may be in the middle of a loop.
    self.modelindex = 0;
    self.nextthink = time + 0.1;
    self.think = SUB_Remove;
};
*/

// FIXME:  Use axeman instead, so that...
// 1) Don't need to mess with player model.
// 2) Bane can resurrect.
void() misc_corpse =
{
//    precache_sound ("misc/decomp.wav");
    if (self.spawnflags & 1)
    {   // zombie
        cache_set ("progs/zombie.mdl");
        self.frame      = 172;
    }
    else
    {
        cache_set ("progs/axeman.mdl");    //deadpl
        self.skin = 1;      //0;
        self.frame = 32;    //49;
    }
    setsize (self, '-16 -16 -24', '16 16 32');  //-8
    self.solid = SOLID_NOT;     //SOLID_BBOX;
//    self.health = 75;
//    self.th_die = corpse_die;
    self.takedamage = DAMAGE_NO;    //DAMAGE_YES;
    // Should wait two frames like everything else, but since this is
    // only for soe1m6, and I need to wrap things up fast, just do it now.
    self.origin = self.origin + '0 0 24';
	droptofloor();

    makestatic (self);
};


//- - - - - - - - - - - - - - - - - - -
//  Wanted Poster -- nsoe1+2.

// Death anim for the poster, which is a simple fade away.
void() wanted_fade =
{
    if (self.alpha <= self.cnt)
        {SUB_Remove();  return;}

    self.nextthink  = time + 0.1;
    self.think      = wanted_fade;
    self.alpha      = self.alpha - self.cnt;
};

// Called when poster is destroyed.
void() wanted_die =
{
    if (self.deathtype == "fire")
    {   // Go up in smoke.
        BecomeExplosion ();
    }
    else if (self.alpha <= self.cnt)
    {   // Cannot remove now in case we are in a .chain loop.
        self.nextthink  = time + 0.1;
        self.think      = SUB_Remove;
    }
    else
    {   // Kill it.
        self.takedamage = DAMAGE_NO;
        wanted_fade ();
    }
};

//============
// --> QUAKED misc_wanted (0 1 0) (-8 -8 -8) (8 8 8)
// Places a wanted poster on a wall.  Otherwise, same as Hip's wallsprite.
// Angles should be opposite of face.
//
// Update:  Wanted poster can be destroyed.
//============
void() misc_wanted =
{
    if (!self.model)
        self.model = "progs/wanted.mdl";

    cache_set (self.model);

    // QuakeEd doesn't save up and down angles properly.
    if (self.angles == '0 -1 0')
        self.angles = '-90 0 0';
    else if (self.angles == '0 -2 0')
        self.angles = '90 0 0';

    // Pull the sprite away from the wall slightly to
    // get rid of z sort errors.
    makevectors (self.angles);
    setorigin (self, self.origin - ( v_forward * 0.2 ) );
//    if (self.takedamage)
    {
        self.alpha      = 1;
        self.cnt        = 0.25;
        self.solid      = SOLID_TRIGGER;
        self.movetype   = MOVETYPE_NONE;
        self.takedamage = DAMAGE_YES;
        self.health     = 10;
        self.th_die     = wanted_die;
    }
//    else
//        makestatic (self);
};


//===========================================================================
//  Push Item

// Note:  Item built specifically to fix a nsoe4 design flaw.
void() item_pushup_touch =
{
    if (other.health <= 0)
        return;
    if (other.classname != "player")    // Must be a player!
        return;
    if (!(other.xfl & XFL_ITEMS))
        return;

    sound (other, CHAN_AUTO, "ambience/windfly.wav", 1, ATTN_NORM);
    stuffcmd (other, "bf\n");
    other.velocity = self.movedir;
    other.flags = other.flags - (other.flags & FL_ONGROUND);

    if (self.message)
    {
        centerprint (other, self.message);      // "Going up!"
        sound (other, CHAN_VOICE, "misc/talk.wav", 1, ATTN_NORM);
    }
    else
    {
        activator = other;
        SUB_UseTargets ();          // fire all targets / killtargets
    }
    Remove_Ent (self);          // Use instead of 'remove(self)'.
};

//============
// --> QUAKED item_pushup (0 .5 .8) (-16 -16 -24) (16 16 32)
// Trigger push in item form.  Usable only by players.
// Disappears when touched.
//============
void() item_pushup =
{
    self.touch = item_pushup_touch;
    if (!self.spawned)
    {
        precache_model ("progs/wings2.mdl");
        precache_sound ("ambience/windfly.wav");
    }
    setmodel (self, "progs/wings2.mdl");
    if (self.movedir == '0 0 0')
        self.movedir = '0 0 1000';
//- - - - - - - - -
// SoE:  Indian Summer
    if (world.model == "maps/nsoe4.bsp")
    {
        self.movedir = '0 -160 1200';
        self.message = "Going up!";
    }
//- - - - - - - - -

    setsize (self, '-16 -16 -24', '16 16 32');
    StartItem ();
};


//===========================/  END OF FILE  /===========================//

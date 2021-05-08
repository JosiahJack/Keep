/*
===============================================================================

HIPNOTIC HAZARDS

===============================================================================
*/

void() spikemine_Home =
{
    local   vector  dir, vtemp;

    self.frame = self.frame + 1;
    if (self.frame >= 9)
        self.frame = 0;

    self.nextthink  = time + 0.2;
    self.think      = spikemine_Home;

// look in our immediate vicinity... home in on the nearest client.
    if (self.search_time < time)
    {
        local   entity  head, selected;
        local   float   cur_dist, head_dist;

        selected = world;
        cur_dist = 2000;
        head = findradius(self.origin, 2000);
        while (head)
        {
            if (!(head.flags & FL_NOTARGET) && (head.flags & FL_CLIENT))
            {
                if (visible(head) && (head.health > 0))
                {
                    head_dist = vlen(head.origin-self.origin);
                    if (head_dist < cur_dist)
                    {
                        selected = head;
                        cur_dist = head_dist;
                    }
                }
            }
            head = head.chain;
        }
        if (selected != world)
            sound (self, CHAN_VOICE, "hipitems/spikmine.wav", 1, ATTN_NORM);
        self.enemy = selected;
        self.search_time = time + 1.3;
    }
    if (self.enemy == world)
    {
        sound (self, CHAN_VOICE, "misc/null.wav", 1, ATTN_NORM);
        self.velocity = '0 0 0';
        return;
    }
    vtemp = self.enemy.origin + '0 0 10';
    dir = normalize(vtemp - self.origin);
    if (infront(self.enemy))
        self.velocity = dir * ((skill*50) + 50);
    else
        self.velocity = dir * ((skill*50) + 150);
};

void() spikemine_Touch =
{
    if (self.health > 0)
    {
// NOTE:  Nails can pop the mine in one hit.
        if (other.classname == "trap_spike_mine")
            return;
        if (other.classname == "missile")
            return;
        if (other.classname == "grenade")
            return;
        if (other.classname == "hiplaser")
            return;
        if (other.classname == "proximity_grenade")
            return;

        // This kills the mine.
        T_Kill (self, self, self, -10, "");
    }

// If the mine was alive when it exploded, this part will be called twice.
    T_RadiusDamage (self, self, 110, world);

    sound (self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);
    Tent_Point (TE_EXPLOSION, self.origin);

    sound (self, CHAN_VOICE, "misc/null.wav", 1, ATTN_NORM);
    BecomeExplosion ();
};

/*
spike_mine_first_think
*/
void() spike_mine_first_think =
{
    self.think       = spikemine_Home;
    self.nextthink   = time + 0.1;
    self.search_time = 0;
    self.takedamage  = DAMAGE_AIM;
    self.use         = monster_use;
};

/*QUAKED trap_spike_mine (0 .5 .8) (-16 -16 0) (16 16 32)
*/
void() trap_spike_mine =
{
    if (deathmatch)
        {remove(self); return;}

    precache_model ("progs/spikmine.mdl");
//    precache_sound ("weapons/r_exp3.wav");
    precache_sound ("hipitems/spikmine.wav");
//    precache_sound ("misc/null.wav");

    setmodel (self, "progs/spikmine.mdl");
    setsize (self, '-16 -16 -16', '16 16 16');  // was 'mins' and 'maxs'.

    self.classname  = "trap_spike_mine";
    self.solid      = SOLID_BBOX;
    self.movetype   = MOVETYPE_FLYMISSILE;
    self.avelocity  = '-50 100 150';
    if (cvar("skill") <= 1)
        self.health = 200;
    else
        self.health = 400;
    self.frame = 0;

// stand, walk, melee, and missile removed.  All set to 'spikemine_Home'.
    self.think = spike_mine_first_think;
    self.touch = spikemine_Touch;
    self.th_run = spikemine_Home;
    self.th_die = spikemine_Touch;

    self.nextthink = time + 0.2;
    total_monsters = total_monsters + 1;
    self.flags = self.flags | FL_MONSTER;

    self.bloodtype = BLOOD_RED;     // Spike mines look organic.
//    self.deathtype = "was blasted by a spike mine";
};


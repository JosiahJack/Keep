//==========================================================================
//  minion.qc -- by Patrick Martin              Last updated:  6-30-1999
//--------------------------------------------------------------------------
//  This file contains code that produces the nightshade's breath attack.
//
//  Unlike other dragon breath attacks, the projectiles can spawn zombies.
//  However, these zombies are not quite the same as regular zombies.
//  Since the code for all of this is rather complicated, it is isolated
//  in this file.
//==========================================================================


//==========================================================================
//  Minion Release

//----------------------------------------------------/ New Code /--------//
//  This causes all zombies owned by a free-willed nightshade to
//  become free-willed, or all zombies owned by a controlled nightshade
//  to explode.  (This is called when a nightshade is killed.)
//------------------------------------------------------------------------//
void() PM_FreeSlaves =
{
    local   entity  head;

    // Nightshade loses all pawns.
    self.currentammo = 0;

    head = nextent(world);
    if ((self.master == world) || (self.master == self))
    {
        // Zombies become free-willed.
        while (head)
        {
            if (head.master == self)
            {
                head.master = head;
                head.owner  = world;
            }
            head = nextent(head);
        }
    }
    else
    {
        // Zombies are destroyed.
        while (head)
        {
            if (head.master == self)
                T_Damage (head, self, self, 50000);
            head = nextent(head);
        }
    }
};

//----------------------------------------------------/ New Code /--------//
//  Similar to ThrowHead and ThrowGib except the head disappears quickly.
//------------------------------------------------------------------------//
void(string gibname, float dm) PM_TempHead =
{
    setmodel (self, gibname);
    self.frame      = 0;
    self.nextthink  = time + 4 + random()*4;
    self.think      = SUB_Remove;
    self.movetype   = MOVETYPE_BOUNCE;
    self.takedamage = DAMAGE_NO;
    self.solid      = SOLID_NOT;
    self.view_ofs   = '0 0 8';
    setsize (self, '-16 -16 0', '16 16 56');
    self.velocity   = VelocityForDamage (dm);
    self.origin_z   = self.origin_z - 24;
    self.flags      = self.flags - (self.flags & FL_ONGROUND);
    self.avelocity  = crandom() * '0 600 0';
};

//----------------------------------------------------/ New Code /--------//
//  Similar to ThrowGib except the gib disappears more quickly.
//  The quick disappearence of gibs is necessary to minimize the
//  chance of 'packet overflow'.
//------------------------------------------------------------------------//
void(string gibname, float dm) PM_TempGib =
{
    local   entity  new;

    new = spawn();
    setmodel (new, gibname);
    setsize (new, '0 0 0', '0 0 0');
    setorigin (new, self.origin);

    new.velocity    = VelocityForDamage (dm);
    new.movetype    = MOVETYPE_BOUNCE;
    new.solid       = SOLID_NOT;
    new.avelocity_x = random()*600;
    new.avelocity_y = random()*600;
    new.avelocity_z = random()*600;
    new.think       = SUB_Remove;
    new.ltime       = time;
    new.nextthink   = time + 2 + random()*2;
    new.frame       = 0;
    new.flags       = 0;
};

//----------------------------------------------------/ New Code /--------//
//  This is called when a spawned zombie dies.
//------------------------------------------------------------------------//
void() minion_die =
{
    // Remove zombie from the nightshade's pawn limit.
    if (self.master)
        if (self.master != self)
            self.master.currentammo = self.master.currentammo - 1;

    // Gib the zombie.
    sound (self, CHAN_VOICE, "zombie/z_gib.wav", 1, ATTN_NORM);
    PM_TempHead ("progs/h_zombie.mdl", self.health);
    PM_TempGib ("progs/gib1.mdl", self.health);
    PM_TempGib ("progs/gib2.mdl", self.health);
    PM_TempGib ("progs/gib3.mdl", self.health);

    // 'PM_TempHead' will 'remove' the destroyed zombie.
};


//==========================================================================
//  Zombie Creation

//----------------------------------------------------/ New Code /--------//
//  This sends the newly created zombie off.
//------------------------------------------------------------------------//
void() PM_MinionGo =
{
	self.takedamage = DAMAGE_AIM;

	self.ideal_yaw = self.angles * '0 1 0';
	if (!self.yaw_speed)
		self.yaw_speed = 20;
	self.view_ofs = '0 0 25';
	self.use = monster_use;
	
    self.flags = self.flags | FL_MONSTER;

    self.pausetime = time + 999999;
    if (self.enemy)
        if (self.enemy.health > 0)
        {
            FoundTarget();
            return;
        }
    self.enemy = world;
    self.th_stand ();
};

//----------------------------------------------------/ New Code /--------//
//  This tries to create a zombie.
//------------------------------------------------------------------------//
void() PM_CreateMinion =
{
    // The nightshade can have only a small number of zombies at a time.
    if (self.master.currentammo >= self.master.lip)
    {
        remove (self);
        return;
    }

    // If the nightshade is dead, then don't spawn a zombie.
    if (self.master == self)
    {
        remove (self);
        return;
    }

    // Don't spawn a zombie if there is no one to attack.
    if (!self.master.enemy)
    {
        remove (self);
        return;
    }

    // Set the size of the gib to match the size of a zombie.
    self.movetype   = MOVETYPE_STEP;
    self.solid      = SOLID_NOT;
    setsize (self, '-16 -16 -24', '16 16 40');

    // Raise the gib a bit then and set it down.
    setorigin (self, self.origin + '0 0 41');
    droptofloor ();

    // Check if there is enough room.
    if (!walkmove (0,0))
    {
        remove (self);
        return;
    }

    // Create and animate a zombie!
    self.owner = world;    // Don't see through zombie.

    // If the nightshade has a target, make the zombie face the target.
    if (self.master.enemy)
    {
        self.enemy = self.master.enemy;
        self.angles = vectoangles(self.enemy.origin - self.origin);
    }
    // Fix the angles so that the zombie stands upright.
    self.angles_x = 0;
    self.angles_z = 0;
    self.fixangle = TRUE;

    // The zombie shall appear now.
    spawn_tfog (self.origin);

    self.movetype   = MOVETYPE_STEP;
    self.solid      = SOLID_SLIDEBOX;

    setmodel (self, "progs/zombie.mdl");

    setsize (self, '-16 -16 -24', '16 16 40');
    self.health     = 60;

    self.th_stand   = zombie_stand1;
    self.th_walk    = zombie_walk1;
    self.th_run     = zombie_run1;
    self.th_pain    = zombie_pain;
    self.th_die     = minion_die;
    self.th_missile = zombie_missile;

    self.classname  = "monster_zombie";
    self.nextthink  = time;
    self.think      = PM_MinionGo;

    // Add the zombie to the pawn limit.
    self.master.currentammo = self.master.currentammo + 1;
};


//==========================================================================
//  Nightshade Projectile Attack

//----------------------------------------------------/ New Code /--------//
//  A gib inflicts damage on contact.  If the gib misses, it may
//  form into a zombie two seconds later.
//------------------------------------------------------------------------//
void() PM_SpawnTouch =
{
    if (other == self.owner)
        return;

    if (other.solid == SOLID_TRIGGER)
        return;     // trigger field, do nothing

    if (pointcontents(self.origin) == CONTENT_SKY)
    {
        remove (self);
        return;
    }
	
    // hit something that bleeds
    if (other.takedamage)
    {
        spawn_touchblood (10);
        T_Damage (other, self, self.owner, 10);
        remove (self);
	}
	else
    {
        sound (self, CHAN_WEAPON, "wizard/hit.wav", 1, ATTN_NORM);
        spawn_touchblood (10);

        // Shot lies dormant for a moment before growing into a zombie.
        self.solid      = SOLID_NOT;
        self.touch      = SUB_Null;
        self.nextthink  = time + 2;
        if (!self.aflag || (random() < 0.5))
            self.think      = SUB_Remove;
        else
            self.think      = PM_CreateMinion;
        return;
	}
};

//----------------------------------------------------/ New Code /--------//
//  The nightshade shoots a bloody gib at its target.
//------------------------------------------------------------------------//
void(vector offset, float spread, float alive, float sped) PM_Spawn =
{
    local   vector  dir;    // Vector from 'org' to gib target.
    local   vector  org;    // Location of dragon's mouth.
    local   entity  curse;  // Nightshade projectile.

    makevectors(self.angles);
    org = self.origin + (v_forward * offset_x) + (v_right * offset_y) +
        (v_up * offset_z);

    dir = normalize(self.enemy.origin - org);
    dir = dir + (v_right * spread);
    dir = normalize(dir);

    curse = spawn();
    setmodel (curse, "progs/zom_gib.mdl");
    setsize (curse, '0 0 0', '0 0 0');        
    setorigin (curse, org);

    curse.takedamage = DAMAGE_NO;
    curse.movetype   = MOVETYPE_FLYMISSILE;
    curse.solid      = SOLID_BBOX;
    curse.owner      = self;
    curse.master     = self;
    curse.aflag      = alive;
    curse.angles     = vectoangles(dir);

    curse.touch      = PM_SpawnTouch;
    curse.nextthink  = time + 8000/sped;
    curse.think      = SUB_Remove;
    curse.velocity   = dir * sped;
};


//==========================================================================
//  Zombie Precache

//----------------------------------------------------/ New Code /--------//
//  This precaches all the zombie related models and sounds.
//------------------------------------------------------------------------//
void() PM_PrecacheMinion =
{
	precache_model ("progs/zombie.mdl");
	precache_model ("progs/h_zombie.mdl");
	precache_model ("progs/zom_gib.mdl");

	precache_sound ("zombie/z_idle.wav");
	precache_sound ("zombie/z_idle1.wav");
	precache_sound ("zombie/z_shot1.wav");
	precache_sound ("zombie/z_gib.wav");
	precache_sound ("zombie/z_pain.wav");
	precache_sound ("zombie/z_pain1.wav");
	precache_sound ("zombie/z_fall.wav");
	precache_sound ("zombie/z_miss.wav");
	precache_sound ("zombie/z_hit.wav");
	precache_sound ("zombie/idle_w2.wav");
};


//===========================/  END OF FILE  /===========================//

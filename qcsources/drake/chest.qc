//==========================================================================
//  Treasure Chests

// Called when 'other' touches the chest.
// If 'other' is a creature, the chest may slide.
void() chest_push =
{
    if (other.flags & FLx_CREATURE)
    {   // Only let other creatures push chests.
        local   float   yaw;

        if (other.movetype == MOVETYPE_WALK)
            CheckOnTop ();
        if (self.absmax_z <= other.absmin_z + 2)
            return;     // Don't let players slide objects from above.

    // Push object.
        yaw = vectoyaw(other.velocity);
        if (walkmove (yaw, 64 * frametime))
        {   // Moved object, now check for push sound.
            if (self.attack_finished <= time)
            {
                sound (self, CHAN_BODY, "misc/pushwood.wav", 1, ATTN_IDLE);
                self.attack_finished = time + 1;    // Lasts slightly over 1.2.
            }
        }
    }
};

void() chest_break =
{
    sound (self, CHAN_VOICE, "misc/woodbrk.wav", 1, ATTN_NORM);
    // PM:  Use Drake gib functions so that carnivores can't eat splinters.
    ThrowTreeChunks ("progs/rubble1.mdl");
    ThrowTreeChunks ("progs/rubble1.mdl");
    ThrowTreeChunks ("progs/rubble1.mdl");
};

// Called when destroyed by an attack.
void() chest_die =
{
// Disappear!
    self.model = world.null_string;
    self.touch = SUB_Null;
    self.solid = SOLID_NOT;
    self.takedamage = DAMAGE_NO;
    self.movetype = MOVETYPE_NONE;

// Activate targets.
    activator = damage_attacker;
    SUB_UseTargets ();

// Break it!
    if (!self.cnt)
    {   // If bomb trap, stop here.
        if (self.health > -100)
            self.health = -100;
        chest_break ();
        barrel_die ();
        return;
    }
    chest_break ();

// Treasure fountain -- scatter coins and jewels.
    DropMoney ();
// Drop the big item.
    Item_Drop (self.spawnflags, self.spawnclassname, self.spawnfunction);

// PM:  Don't remove self now because we may be in the middle of
// a damage chain, such as one made by T_RadiusDamage.
    self.nextthink = time + 0.1;
    self.think = SUB_Remove;
};

void() chest_start =
{
    self.mdl        = self.model;       // so it can be restored on respawn
    self.solid      = SOLID_SLIDEBOX;
    self.movetype   = MOVETYPE_PUSH;
    self.touch      = chest_push;
    self.th_die     = chest_die;
    self.takedamage = DAMAGE_YES;

    self.velocity   = '0 0 0';
    self.origin_z   = self.origin_z + 2;
    if (!droptofloor ())
    {
        print_self (self.classname, " fell out of level at ");
        remove (self);
        return;
    }

//    self.oldorigin = self.origin;
};

//============
// --> QUAKED misc_chest (0 .5 .8) (-16 -16 0) (16 16 24)
// Treasure chest.  May be pushed around.
//============
void() misc_chest =
{
    local   float   loop;

// Precache chest model and sounds.
    precache_model ("progs/chest1.mdl");
    precache_model ("progs/rubble1.mdl");

    precache_sound ("misc/pushwood.wav");
    precache_sound ("misc/woodbrk.wav");

    precache_money ();      // In case this hasn't be done at worldspawn.

// Set contents now to foil save scumming.
    loop = 0;
    self.purse = '0 0 0';
    self.cnt = random() * 16 & 15;

// Set the big item inside.
    if (self.spawnfunction)
    {   // Mapper has a specific item in mind.
        // FIXME:  Impossible to use in conjuction with func_spawn.
        // Note:  Not really a problem since spawning solids without
        //  telefrag contests to clean the trash is a bad idea...
        //  Besides, func_spawn'ing chests is mostly pointless.
        Item_Cache (self.spawnfunction);

        // If set item is treasure, make the whole drop the same.
        loop = (self.cnt & 1 + 2) * 5;      // 10 or 15 items.
        if (self.spawnfunction == item_treasure_coin)
            self.purse_x = loop;
        else if (self.spawnfunction == item_treasure_gem)
            self.purse_y = loop;
        else
            loop = (self.cnt & 3 - 1) * 5;  // (1d4-2)*5 items.
        self.cnt = 1;   // So chest won't blow up.
    }
    else
    {   // Default.  Precache treasure files.
        precache_model ("progs/t_coin.mdl");
        precache_model ("progs/t_gem.mdl");
        precache_sound ("items/treasure.wav");

        if (self.cnt & 7)
        {
        // The big item inside.
            if (self.cnt & 8)
                self.spawnfunction = item_treasure_gem;
            else
                self.spawnfunction = item_treasure_coin;
            if (self.cnt & 4)
            {   // Update 12/6/09:  Three sizes.
                if (random() < 0.5)
                    self.spawnflags = self.spawnflags | 1;
                else
                    self.spawnflags = self.spawnflags | 2;
            }

            loop = (self.cnt & 3 + 2) * 5;  // (1d4+1)*5 items.
        }
    }

// The rest is pocket change.
    while (loop > 0)
    {   // Give more coins than gems because gold tends to be more
        // common, and health items are more common than armor.
        if (random() < 0.25)
            self.purse_y = self.purse_y + 1;  // gem
        else
            self.purse_x = self.purse_x + 1;  // coin
        loop = loop - 1;
    }

// Start.
    setform (self, "progs/chest1.mdl", '-16 -16 0', '16 16 24');
    SUB_FullHealth (20);

    self.nextthink  = time + 0.2;   // start after other solids
    self.think      = chest_start;
};


//===========================/  END OF FILE  /===========================//

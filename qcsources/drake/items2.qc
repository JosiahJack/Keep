// Some of the custom items are here in a separate file to make it
// easier to find stuff.

//==========================================================================
//  Effects

// Permanently increase maximum health of ent.
// Note:  Negative hp values can reduce extra health.
void(entity ent, float hp) Life_Up =
{
    local   float   mx;

    hp = floor(hp);     // Integers only, please.

// Save the powerup.
    mx = ent.perms & POWx_HEALTH;
    ent.perms = ent.perms - mx;
    mx = mx + hp;
    if (mx > POWx_HEALTH)   // If TRUE, ent reached the maximum bonus allowed
        mx = POWx_HEALTH;   // and adding any more will rollover counter.
    else if (mx < 0)
        mx = 0;
    ent.perms = ent.perms | (mx & POWx_HEALTH);

// Increase max/health.
    ent.max_health = ent.max_health + hp;
    T_Heal (ent, hp, FALSE);
};


//==========================================================================
//
//  POTIONS
//
//==========================================================================

void() potion_type = {self.cnt = random() * 8;};

void() potion_effects =
{
    local   float   hp;

    if (self.healamount < 0)
    {   // Stuff was harmful.
        T_NewDamage (other, other, self, 0 - self.healamount, DF_NO_ARMOR|DF_NO_KNOCK, "drank the Kool-Aid");
        if (other.health > 0)
        {   // Display message only if 'other' survived.
            if (self.healamount > -50)
                Safe_sprint (other, "Ack! Tastes foul.\n");
            else
                Safe_sprint (other, "Eeww... Gross!\n");
        }
    }
    else
    {   // Good stuff.
        local   float   heal;   //, cure;

//        cure = IsPoisoned (other);
//        Poison_Null (other);
        heal = hp = T_Heal (other, self.healamount, FALSE);
//        if (!cure)    // Bypass extra health if poison was neutralized.
        {   // 20% of remaining unused health is added over the normal max.
            hp = floor ((self.healamount - hp) / 5);
            hp = T_Heal (other, hp, TRUE);
            heal = heal + hp;
        }

/* DISABLED -- Don't need it, so save a little space.
        if (self.worldtype)
        {   // Health box style messages.
            if (heal)
            {
                local   string  s;
    
                s = ftos(heal);
                Safe_sprint (other, "You receive ");
                Safe_sprint (other, s);
                Safe_sprint (other, " health\n");
                if (cure)
                    Safe_sprint (other, "and a cure for your illness\n");
            }
            else if (cure)
                Safe_sprint (other, "You receive a cure for your illness\n");
            else
                Safe_sprint (other, "Ah, refreshing...\n");
        }
        else
*/
        {   // Soul of Evil potion messages.
//            if (cure)
//                Safe_sprint (other, "What a relief!\n");
//            else
                Safe_sprint (other, "Ah, refreshing...\n");
        }
    }

    potion_type ();     // Reroll random effect for the next respawn.
};

// PM:  Player cannot tell what the potion is until after it is drunk.
void() potion_touch =
{
    if (other.health <= 0)
        return;
    if (!(other.xfl & (XFL_ITEMS | XFL_HUNGRY)))
        return;

// Item will be taken.  Make it non-solid now so that 'other' cannot retouch
// 'self' if a movement function like walkmove is called during T_Damage.
    self.solid = SOLID_NOT;

// Pickup effects.
    sound (other, CHAN_ITEM, "items/quaff.wav", 1, ATTN_NORM);
    Safe_stuffcmd (other, "bf\n");

// Now for the effects.
    potion_effects ();

// Take care of attachments.
    activator = other;
    SUB_UseTargets();                // fire all targets / killtargets

    ClearItem (20);
};

//============
// --> QUAKED item_potion (.3 .3 1) (-4 -4 0) (4 4 16)
// Bottle of juice.  Occasionally tainted or enchanted.
//
// Flags:
// "skin"
//  Color used. Matches player skin.
//  Use -1 for random skin.
//  Default is 0 (white).
// "style"  (FIXME:  Unused)
//  Healing, Augmentation, Sickness, Quad Damage, Invisibility
// "healamount"
//  Heal or hurt player by this amount.
//  Also, buff durations in seconds.
//  Default varies by effect.
//============
void() item_potion =
{
// Set potion color.
    if (self.skin < 0)
        self.skin = random() * 14 & 15;
    if (self.skin > 13)
        self.skin = 0;      // Prevent dprint complaints.

    if (!self.mdl)
        self.mdl = "progs/potion.mdl";

// Spawning is a go.
    potion_type ();     // Lock in random effect to foil save scumming.

    self.touch = potion_touch;
    if (!self.spawned)
    {
        precache_model (self.mdl);
        precache_sound ("items/quaff.wav");
    }
    setmodel (self, self.mdl);
    setsize (self, '0 0 0', '0 0 16');
    StartItem ();
};

void() item_health_potion =
{
    if (self.spawnflags & 1)    // H_ROTTEN
        {self.healamount = 15; self.skin = 13; self.mdl = "progs/potion2.mdl";}
    else if (self.spawnflags & 2)
        {self.healamount = 100; self.skin = 6;}
    else
        {self.healamount = 25; self.skin = 9;}

//    self.worldtype = 1;
    self.classname = "item_potion";
    item_potion ();
};


//==========================================================================
//
//  TREASURE
//
//==========================================================================

//- - - - - - - - -
// Updates gem color.
void(float gt) gem_colors =
{
    local   float   bit3, bit4;
    local   float   newskin;

    bit4 = self.cnt = (self.cnt + 1) & 7;

    bit3 = bit4 & 3;
    if (gt == 1)
    {   // 00001111
        newskin = (bit4 / 4);   //+ (self.worldtype * 2);
    }
    else if (gt == 2)
    {   // 00110011
        newskin = ((bit3 & 2) / 2);   //+ (self.worldtype * 2);
    }
    else if (gt == 3)
    {   // 21002100
        newskin = 2 - bit3;
        if (newskin < 0)
            newskin = 0;
    }
    else if (gt == 4)
    {   // 01210121
        if (bit3 == 3)
            newskin = 1;
        else
            newskin = bit3;
    }
    else if (gt == 5)
    {   // 01230123
        newskin = bit3;
    }
    else if (gt == 6)
    {   // 01233210
        if (bit4 & 4)
            newskin = 3 - bit3;
        else
            newskin = bit3;
    }
// PM:  Okay, so the gem model has a test fifth skin.
//    else if (gt == 7)
//    {   // ????????
//        newskin = (random() * 4) & 3;
//    }
    else
    {   // 40414243
        if (bit4 & 1)
            newskin = ((bit4 & 6) / 2) & 3;   
        else
            newskin = 4;
    }

    self.skin = newskin;
};

// Magic gem thinking -- change color every frame.
void() gem_pulse =
{
    self.nextthink = time + 0.1;
    self.think = gem_pulse;     // Must define here in case of dynamic spawn.
    gem_colors (self.worldtype);    // FIXME:  Confirm in item_treasure.
};

//- - - - - - - - -
// Moved 'Life_Up' to Potions section.

// Called when something bumps into item_treasure.
void() treasure_touch =
{
    if (other.health <= 0)
        return;

    if (!(other.xfl & XFL_ITEMS))
        return;

// Pickup effects.
    Safe_sprint (other, "You found ");
    Safe_sprint (other, self.netname);
    Safe_sprint (other, "\n");
    sound (other, CHAN_ITEM, "items/treasure.wav", 1, ATTN_NORM);
    Safe_stuffcmd (other, "bf\n");

// Reward with max hp increase -- not in SoE!
// SoE:  Increase armor, ignoring max, like in classic Doom.
// Note:  If adding shops, add to gp in addition to armor/hp boost.
    if (!self.healamount)
        self.healamount = 5;
    if (self.healtype)
        T_Heal (other, self.healamount, TRUE);
    else
        T_Repair (other, self.healamount, TRUE);

// Take care of attachments.
    activator = other;
    SUB_UseTargets();                // fire all targets / killtargets

    ClearItem (20);
};

//============
// --> QUAKED item_treasure (.83 .69 .22) (-16 -16 -24) (16 16 32) Gem Big
// Large gems or gold coins.
// Gems raise health by 3, ignoring max health.
// Coins raise armor by a like amount, up to an absolute limit of 250.
//
// Note:  In Drake, maximum health gets raised by 1 permanently.
//============
void() item_treasure =
{
    if (soul_evil)
    if (!self.healtype)
    if (!(self.xsf & XSF_CHEST_HACK))
    {   // Treasure type.
        if (self.spawnflags & 1)
            {self.healtype = 1;  self.spawnflags = self.spawnflags - 1;}
        else
            self.healtype = 0;

        // Size.
        if (self.spawnflags & 2)
            self.spawnflags = self.spawnflags - 2;
        else
            self.spawnflags = self.spawnflags | 1;
    }

    self.classname = "item_treasure";
//    if (!self.netname)
//        self.netname = "treasure";
//    if (!self.mdl)
//        self.mdl = "progs/t_gem.mdl";
    if (self.spawnflags & 1)
        {self.frame = 0;  self.healamount = 5;}
    else if (self.spawnflags & 2)
        {self.frame = 2;  self.healamount = 20;}
    else
        {self.frame = 1;  self.healamount = 10;}
    if (self.healtype)
    {
//- - - - - - - - -
// FIXME:  Experimental -- finalize!
        if (self.worldtype)
            self.th_win = gem_pulse;
//- - - - - - - - -
        self.netname = "a gem";
        self.mdl = "progs/t_gem.mdl";   //"progs/soe_gem.mdl";
        if (self.skin < 0)
        {
            self.skin = random() * 4.999;
            self.skin = floor (self.skin);
        }
//        else
//            self.skin = (AddOne() - 1) & 3;
    }
    else
    {
        self.netname = "gold";
        self.mdl = "progs/t_coin.mdl";  //"progs/soe_coin.mdl";
        self.skin = self.frame;
    }

    self.touch = treasure_touch;
    if (!self.spawned)
    {
        precache_model (self.mdl);
        precache_sound ("items/treasure.wav");
    }
    setmodel (self, self.mdl);
    setsize (self, '-16 -16 -24', '16 16 32');
    StartItem ();
};

//============
// --> QUAKED item_treasure_gem (.83 .69 .22) (-16 -16 -24) (16 16 32)
// Large gems
//============
void() item_treasure_gem =
{
    if (self.xsf & XSF_CHEST_HACK)
        self.skin       = -1;   // Random color.
    self.healtype = 1;
    item_treasure ();
};
//============
// --> QUAKED item_treasure_coin (.83 .69 .22) (-16 -16 -24) (16 16 32)
// Large gold coins
//============
void() item_treasure_coin =
    {self.healtype = 0;  item_treasure();};


//==========================================================================
//
//  MONEY
//
//==========================================================================

void() money_touch =
{
    if (other.health <= 0)
        return;

// FIXME:  Monsters like ogres and dragons should be able to pick up money.
    if (!(other.xfl & (XFL_ITEMS | XFL_HUNGRY)))
        return;

// Pickup effects.
//- - - - -
// Note:  Money entities tends to be spawned in groups, so to prevent
// unnecessary spamming, do not display a pickup message.  Just flash screen.
// Note#2:  Message is needed if keeping track of money for CRPG PC/TC.
//    Safe_sprint (other, "You got ");
//    Safe_sprint (other, self.netname);
//    Safe_sprint (other, "\n");
//- - - - -
    sound (other, CHAN_ITEM, "items/money.wav", 1, ATTN_NORM);
    Safe_stuffcmd (other, "bf\n");

// Add to score.
    if (!self.healamount)
        self.healamount = 1;
    if (self.style)
    {
        if (other.xfl & XFL_HUNGRY)
            other.purse_y = other.purse_y + self.healamount;
        else
            T_Heal (other, self.healamount, TRUE);
    }
    else
    {
        if (other.xfl & XFL_HUNGRY)
            other.purse_x = other.purse_x + self.healamount;
        else
            T_Repair (other, self.healamount, TRUE);
    }

// Take care of attachments.
    activator = other;
    SUB_UseTargets();                // fire all targets / killtargets

// Don't bother respawning these puny items even if placed on the map.
    remove (self);
};

void() money_bounce =
{
    if (pointcontents (self.origin) <= CONTENT_LAVA)    // Sky or lava.
        {remove (self);  return;}
    money_touch ();
};

// Called when money gets hit by damage.  All damage does is push it around.
// Use this only for money dropped by monsters.
void() money_hit =
{
//- - - - - - - - -
    // Undo interference from Killed.
    self.touch      = money_bounce;
    self.health     = 0;
    self.deadflag   = DEAD_NO;
    self.takedamage = DAMAGE_YES;
//- - - - - - - - -
    // Extend time before removal in case player wants to play hockey.
    if (self.delay)
        self.delay      = self.delay + 2;
//- - - - - - - - -
    // Toss the money around.
    self.velocity   = self.velocity + damage_velocity;
    if (self.flags & FL_ONGROUND)
    {
        self.flags = self.flags - (self.flags & FL_ONGROUND);
        if (self.velocity_z < 150)
            self.velocity_z = 150;
    }
};

// Use this only for money dropped by monsters.
void() money_think =
{
    if (self.delay)
        if (self.delay <= time)
            {remove (self);  return;}

// Don't use touch function to check velocity because it isn't always
// called when the item stops bouncing.
    if (self.velocity == '0 0 0')
    {
        if (self.lefty)
        {   // Just stopped.
            if (self.style)
                self.frame = 1 + ((random() * 2) & 1);  // Set to 1 or 2.
            self.avelocity = '0 0 0';
            traceline (self.origin + '0 0 1', self.origin + '0 0 -7', TRUE, self);
            if (trace_fraction < 1)
                self.angles = vectoangles (trace_plane_normal) + '-90 0 0';
            else
                self.angles_x = self.angles_z = 0;
            self.lefty = FALSE;
        }
    }
    else
    {
        if (!self.lefty)
        {   // Suddenly moving from rest.
            if (self.style)
                self.frame = 0;
            self.avelocity = self.mangle;
            self.lefty = TRUE;
        }
    }
//- - - - - - - - -
// Rainbow facets.
    if (self.style)
        if (self.healamount > 1)
            gem_colors (self.worldtype);
//- - - - - - - - -
    self.nextthink = time + 0.1;
};

// Called by money_throw (dropped) and money_start (placed).
void(entity item) money_go =
{
    item.xf2        = XF2_QUAKE;
//    item.flags      = FL_ITEM;
//    item.solid      = SOLID_TRIGGER;
    item.movetype   = MOVETYPE_BOUNCE;
    item.lefty      = TRUE;
//    setsize (item, '0 0 0', '0 0 16');
    item.touch      = money_bounce;
    item.nextthink  = time + 0.1;
    item.think      = money_think;

    item.deadflag   = DEAD_NO;
    item.health     = 0;
    item.takedamage = DAMAGE_YES;
    item.th_die     = money_hit;
    item.mass       = MASS_LIGHT;
};

// Called by the drop loop in DropMoney.
// Set properties here that is used only by dropped coins.
void(entity item) money_throw =
{
    item.velocity_x = -100 + (random() * 200);
    item.velocity_y = -100 + (random() * 200);
    item.velocity_z = 300 + (random() * 100);
    item.avelocity_x = random() * 600;
    item.avelocity_y = random() * 600;
    item.avelocity_z = random() * 600;
    item.mangle = item.avelocity;
    item.angles_x = random() * 360;
    item.angles_y = random() * 360;
    item.angles_z = random() * 360;

    item.flags      = FL_ITEM;
    item.solid      = SOLID_TRIGGER;
    item.delay      = time + 20 + random()*10;
// Add +16 to maxs_z so player can pick up item resting in a ground clip
// brush.  Due to Quake's funky physics code, this shouldn't cause problems.
// Note:  Don't set size_x or size_y to non-zero values because that causes
// splashing sounds as the item bounces.
    setsize (item, '0 0 0', '0 0 16');

    money_go (item);
};

void(entity item, float type, float hp, float flip) money_stats =
{
    item.healamount = floor (hp);
    if (hp > 5)
        hp = 5;
    if (flip)
        flip = 1;
    if (type)
    {
        if (type == 1)
            setmodel (item, "progs/gem1.mdl");
        else if (type == 2)
            setmodel (item, "progs/gem2.mdl");
        else
            setmodel (item, "progs/gem3.mdl");
        item.classname  = "gem";
        item.netname    = "a small gem";
        item.style      = TRUE;
        item.skin       = random() * 4 & 3;   // Assumes 4 skins in model.
        if (hp > 1)
        {
            item.skin       = 0;
            item.worldtype  = ((hp - 1) * 2) - 1 + flip;
        }
    }
    else
    {
        setmodel (item, "progs/coin.mdl");
        item.classname  = "coin";
        item.netname    = "a qubit";    // Battlestar Galactica cubits.
        item.style      = FALSE;
        item.skin       = hp - 1;
        item.frame      = flip + (item.skin * 2);
    }
};

// Selects the denomination to drop.
// Yes, I am aware that money taken by monsters can merge into bigger
// items.  Just think of it like the Shikon Jewel from InuYasha.
float(float mx) money_change =
{
    if (deathmatch || coop)
    {
        if (mx >= 2)
            return mx - 1;
        return 1;
    }
    if (mx >= 15)
        return mx - 10;
    if (mx >= 10)
        return 4;
    if (mx >= 6)
        return 3;
    if (mx >= 3)
        return 2;
    return 1;
};

// Causes 'self' to drop coins and/or gems.  Similar to DropBackpack.
void() DropMoney =
{
    local   entity  item;
    local   vector  org;
    local   float   coins, gems;
    local   float   mx, luck, flip;

    if (!cash_drop)
        return;     // Money was disabled -- files were not precached.

    // Was 'org = self.origin - '0 0 24';'
    org = self.origin;
    org_z = org_z + self.mins_z;
    coins = floor (self.purse_x);
    gems = floor (self.purse_y);
// Coins
    while (coins > 0)
    {
        flip = random() * 2 & 1;
        luck = money_change (coins);

        item = spawn();
        setorigin (item, org);
        money_stats (item, FALSE, luck, flip);
        money_throw (item);

        coins = coins - luck;
    }
// Gems
    while (gems > 0)
    {
        flip = random() * 2 & 1;
        mx = random();
        if (mx < 0.4)
            mx = 1;
        else if (mx < 0.7)
            mx = 2;
        else
            mx = 3;
        luck = money_change (gems);

        item = spawn();
        setorigin (item, org);
        money_stats (item, mx, luck, flip);
        money_throw (item);

        gems = gems - luck;
    }
};

// Update 10/28/10:  Removed 'item_money'.


//===========================================================================
//  Books

//
// As items, books merely display messages and maybe activate targets.
// They do not disappear when touched.
//

// Read the book.
// FIXME:  Broke in DarkPlaces.  Impulse doesn't clear immediately.
void() book_touch =
{
    local   float   bimp;

    if (other.health <= 0)
        return;
    if (other.classname != "player")
        return;     // Only players can read.
// DISABLED -- Not needed here.
//    if (other.attack_finished > time)
//        return;     // Don't cycle uncontrollably.

// Check for page change.
    bimp = other.impulse;
    if (bimp)
    {
        if (!self.impulse)
        {
            if (bimp == 10)
            {   // Cycle forward.
                if (other.attack_finished > time)
                    return;     // Don't cycle uncontrollably.
                bimp = other.book_page + 1;
                if (bimp > self.waitmax)
                    bimp = self.waitmin;
                self.height = bimp;
            }
            else if (bimp == 12)
            {   // Cycle reverse.
                if (other.attack_finished > time)
                    return;     // Don't cycle uncontrollably.
                bimp = other.book_page - 1;
                if (bimp < self.waitmin)
                    bimp = self.waitmax;
                self.height = bimp;
            }
        }
        if ((bimp < self.waitmin) || (bimp > self.waitmax))
            bimp = 0;   // Illegal page.
        else if ((bimp == other.book_page) && (other.book_ent == self))
            bimp = 0;   // Already reading the same page from the same book.
        // Changing page number...
        else if (bimp == 1)
            other.page1 = self.page1;
        else if (bimp == 2)
            other.page1 = self.page2;
        else if (bimp == 3)
            other.page1 = self.page3;
        else if (bimp == 4)
            other.page1 = self.page4;
        else if (bimp == 5)
            other.page1 = self.page5;
        else if (bimp == 6)
            other.page1 = self.page6;
        else if (bimp == 7)
            other.page1 = self.page7;
        else if (bimp == 8)
            other.page1 = self.page8;
        else
            bimp = 0;

        if (bimp)
            other.book_page = bimp;
    }
    else
        self.height = 0;   // Clear for the next press.
    // Do this check even if the books are different, so that the client
    // won't get flooded out if he touches multiple books simultaneously.
    if (other.book_time > time)
    {   // Already displaying a message.
        if (!bimp)
            return;     // Doing nothing.
        // ELSE... player turned a page.
    }
// Update book stats for the client.
    if (other.book_ent != self)
    {   // Reading a different book
        other.book_ent = self;
        if (!bimp)
        {   other.book_page = 1;
            other.page1 = self.page1;
        }
    }
    other.book_time = time + 1.5;

// Display effects.
    Safe_centerprint (other, other.page1);
    // Sound off only on first touch.  Don't resound lest two can permaring.
    if (!self.lefty)
    {
        self.lefty = 1;
        sound (other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
    }
    // No background flash if message only.

// If targeted, trigger on the first time the matching page is read.
    if (self.targetname)
    if (self.impulse == other.book_page)
    {
        activator = other;
        SUB_UseTargets ();          // fire all targets / killtargets
        // PM:  Prevents others from using this.
        self.targetname = world.null_string;
    }
};

//============
// --> QUAKED item_book (0 .5 .8) (-16 -16 0) (16 16 32)
// Touch to read.
//============
void() item_book =
{
    local   vector  bmin, bmax;

    if (soul_evil)
        self.noise = "misc/secret2.wav";
    else
        self.noise = "misc/secret.wav";
    self.mdl = "progs/bookopen.mdl";
    bmin = '-16 -16 0';
    bmax = '16 16 32';
    if (!self.spawned)
    {
        precache_model (self.mdl);
        precache_sound (self.noise);
    }
    setmodel (self, self.mdl);

    self.height     = 0;        // For cycle control.
    self.waitmin    = self.waitmax  = 1;
    if (!self.impulse)
        self.impulse = 1;       // Trigger upon reading page one.
//- - - - - - - - -
// Fix legacy from nsoe code.
    if (self.noise1)
        self.page1 = self.noise1;
    else if (self.noise2)
        self.page2 = self.noise2;
    else if (self.noise3)
        self.page3 = self.noise3;
    else if (self.noise4)
        self.page4 = self.noise4;
//- - - - - - - - -
    if (IsEmptyString (self.page1))
        objerror ("item_book: no page1");
    else
    {
        self.touch      = book_touch;
        if (self.page2)
        {   self.waitmax = 2;
            if (self.page3)
            {   self.waitmax = 3;
                if (self.page4)
                {   self.waitmax = 4;
                    if (self.page5)
                    {   self.waitmax = 5;
                        if (self.page6)
                        {   self.waitmax = 6;
                            if (self.page7)
                            {   self.waitmax = 7;
                                if (self.page8)
                                    self.waitmax = 8;
                            }
                        }
                    }
                }
            }
        }
    }
    setsize (self, bmin, bmax);
    StartItem ();
};


//===========================================================================
//  Fake Item

void() fake_touch =
{
    if (other.health <= 0)
        return;
    if (!(other.xfl & XFL_ITEMS))
        return;

// Poof!
    local   vector  spot;

    spot    = Midpoint (self);
    spawn_tfog (spot);

    activator = other;
    SUB_UseTargets ();          // fire all targets / killtargets

    Remove_Ent (self);          // Use instead of 'remove(self)'.
};

//============
// --> QUAKED item_fake (0 .5 .8) (-16 -16 -24) (16 16 32)
// Fake item.  Disappears when touched.
//============
void() item_fake =
{
    local   vector  bmin, bmax;

    if (!self.mdl)
        self.mdl = "progs/end1.mdl";
    bmin = '-16 -16 -24';
    bmax = '16 16 32';
    if (!self.spawned)
        precache_model (self.mdl);
    setmodel (self, self.mdl);

    self.touch      = fake_touch;
    setsize (self, bmin, bmax);
    StartItem ();
};


//===========================/  END OF FILE  /===========================//

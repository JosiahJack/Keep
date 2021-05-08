
// FIXME:  Trash, so remove!
/*
// Called at end of PlaceItem for item_money.
void() money_start = {money_go (self);};

//============
// --> QUAKED item_money (.83 .69 .22) (-4 -4 0) (4 4 16)
// Small coin or gem.
// Coins increase armor by 1.
// Gems increase health by 1.
// Boosts can exceed normal maximums.
// Not available in deathmatch games.
//============
void() item_money =
{
// Money is unnecessary junk in deathmatch.
    if (deathmatch)
        {remove (self);  return;}

// Spawning is a go.
    if (!self.healamount)
        self.healamount = 1;
    self.delay = 0;     // Won't vanish from the level.
    self.touch = money_touch;
    if (self.style)
    {
        local   string  text;

        self.frame = self.frame + 1;

        if (self.skin < 0)
            self.skin = random() * 4;
        self.skin = self.skin & 3;      // Assumes 4 skins in model.

        if (self.style < 0)
        {
            self.style = random() * 3;
            self.style = ceil (self.style);
        }
        if (self.style == 3)
            text = "progs/gem3.mdl";
        else if (self.style == 2)
            text = "progs/gem2.mdl";
        else
            {text = "progs/gem1.mdl";  self.style = 1;}
        self.style = 1;
        precache_model (text);
    }
    else
    {
        text = "progs/coin.mdl";
        self.style = 0;
    }
    if (!self.spawned)
    {
        precache_model (text);
        precache_sound ("items/money.wav");
    }
    money_stats (self, self.style, self.healamount, self.spawnflags & 1);
// Set up avelocity if coin gets knocked around.
    self.mangle_x = random() * 600;
    self.mangle_y = random() * 600;
    self.mangle_z = random() * 600;
//- - - - - - - - -
    self.th_win = money_start;  // Make it bounce from damage.
    setsize (self, '0 0 0', '0 0 16');
    StartItem ();
};

//void() item_money_gem = {item_money();};
//void() item_money_coin = {item_money();};
*/

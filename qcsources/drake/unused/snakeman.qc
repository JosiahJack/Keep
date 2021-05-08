// Replaced snakeman with something.
// The whole pack is getting too big, and if I need to drop something,
// snakeman is one of the first to go.

void() snake_cache = {ogre_cache();};

//============
// --> QUAKED monster_snakeman (1 0 0) (-32 -32 -24) (32 32 64) Ambush
//
// FIXME:  Replace with ogre or centroid.
//============
void() monster_snakeman =
{
    self.skin = 1;
    self.classname = "monster_ogre"
    monster_ogre ();
};


//===========================/  END OF FILE  /===========================//

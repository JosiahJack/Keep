//==========================================================================
//  Decorations

//============
// PlaceDecor
//
// plants the object on the floor
//============
void() PlaceDecor =
{
    self.solid      = SOLID_BBOX;
    self.movetype   = MOVETYPE_TOSS;    
    self.velocity   = '0 0 0';
    self.origin_z   = self.origin_z + 1;    // Other items used +6.
    if (!droptofloor ())
    {
        dprint (self.classname);
        dprint (" fell out of level at ");
        dprint (vtos(self.origin));
        dprint ("\n");
        remove (self);
        return;
    }
};

//============
// --> QUAKED misc_decor (0 .5 .8) ?
// Miscellaneous solid object that just sits there.
//============
void() misc_decor =
{
    if (!self.mdl)
    {   // Default to Zerstorer tree.
        self.mdl = "progs/tree.mdl";
        self.pos1 = '-16 -16 0';
        self.pos2 = '16 16 86';
    }
    precache_model (self.mdl);
    setmodel (self, self.mdl);
    setsize (self, self.pos1, self.pos2);

    self.nextthink  = time + 0.2;   // items start after other solids
    self.think      = PlaceDecor;
};


//==========================================================================
//  Trees

//============
// --> QUAKED misc_tree (0 .5 .8) (-16 -16 0) (16 16 86)
// A tree!
//============
void() misc_tree =
{
    self.mdl = "progs/tree.mdl";
    self.pos1 = '-16 -16 0';
    self.pos2 = '16 16 86';
    self.takedamage = DAMAGE_NO;

    misc_decor ();
};

// Zerstorer's tree entity.  Converted for Drake.
void() item_tree = {self.classname = "misc_tree";  misc_tree ();};


//===========================/  END OF FILE  /===========================//

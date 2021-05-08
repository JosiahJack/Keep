//==========================================================================
//
//  REANIMATOR (Artifact Horn)
//
//==========================================================================

float(vector dir, float hp) HornEffects =
{
    local   entity  head;
    local   vector  delta;
    local   float   damage, hits;

    hits = 0;

// Spawn a small earthquake to shake the screen.
    Quake_Spawn_Tilt (500, 0, self.origin, DF_BLESSED, 1, '0 5 0');

// Hurt living enemies and revive dead things.
    head = nextent (world);
    while (head)
    {
        if (!head.deadflag)
        {   // Cause some damage if close to the source.  Free of charge.
            if (head.takedamage)
            if (visible (head))
            {
                delta = Midpoint(head) - self.origin;
                damage = 60 - (0.5 * vlen(delta));
                if (damage > 0)
                    T_NewDamage (head, self, self, damage, DF_PUSH_NPC|DF_BLESSED, "sonic");
            }
        }
        else if (head.deadflag == DEAD_DEAD)
        {   // Revive dead monsters.  Costs ammo.
            if (head.flags & FL_MONSTER)
            if (head.max_health <= hp)
            {
                delta = head.origin - self.origin;
                if (vlen(delta) < 1000)     // Max range of ATTN_NORM sounds.
                if (dir * normalize (delta) > COS45)    // Must be in FOV.
                if (visible (head))
                {
                    if (monster_revive (head, self))
                    {
                        hp = hp - head.max_health;      // It lives!
                        hits = hits + head.max_health;
                    }
                }
            }
        }
        head = nextent(head);
    }

// Deathmatch usually has no monsters.  If such is truly the case,
// create a shambler or other high-level beatstick to attack other players.
    if (!hits)
    {
        if (deathmatch)
        {
// FIXME:  If wearing dragonscale, summon dragon instead.
            if (hp >= 600)
            if (SpawnMonster_Circle (self, ID_SHAMBLER_WHITE))
            {
                hp = hp - 600;      // Conjured up a monster.
                hits = hits + 600;
            }
        }
    }

    return hits;
};

void() W_FireHorn =
{
    local   float   cost;

    makevectors (self.v_angle);
    sound (self, CHAN_WEAPON, "weapons/horn1.wav", 1, ATTN_NORM);

    cost = self.health - 25;
    cost = HornEffects (v_forward, cost * 10);
    cost = ceil (cost / 10);
    if (cost > 0)
    {   // It hurts!
        self.health = self.health - cost;
        self.dmg_take = self.dmg_take + cost;
        self.dmg_inflictor = self;
    }
};



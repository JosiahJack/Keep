void() Axe_Watch;

//  Archer Knight Arrows
// Update 11/24/09:  Constants moved to defs.
// Magic arrow explosion code.
void() AkArrow_Explode = {
    self.count = self.count & 3;
    sound (self, CHAN_AUTO, "hexen2/weapons/explode.wav", 1, ATTN_NORM);
    Colored_Explosion (self.origin, self.count);
    BecomeFancy (X80_SPARK_ORANGE + (self.count * 6), 6);
};

void() AkArrow_Magic_Touch = {
	local float sped;

	// Other, more powerful and explosive arrow types.
    if (self.worldtype) {
        if (other.flags & FLx_CREATURE) {
			if (!Ally_Check (other, self.master))
			if (!HasReflection (other, self.origin, 0)) {
				if (other.mass && (other.mass <= MASS_SUPER)) { // Knockback effect.
					sped = self.speed;
					if (other.mass == MASS_SUPER) sped = sped / 2;
					other.velocity = other.velocity + (self.movedir * sped);
					if (other.flags & FL_ONGROUND) {
						other.flags = other.flags - FL_ONGROUND;
						if (other.velocity_z < 150) other.velocity_z = 150;
					}
				}
			}
		}
    }
    Touch_Missile();
};

// Called when an arrow hits something.
void() AkArrow_Wood_Touch = {
    local vector org;

    if (pointcontents(self.origin) == CONTENT_SKY) {remove (self); return;}
    if (Reflected ()) return;

    self.touch = SUB_Null;      // Stack overflow prevention.
    if (other.takedamage) {
        spawn_touchblood (self, other, self.dmg);
        T_Damage (other, self, self.master, self.dmg,DAMARMOR);
        sound (self, CHAN_WEAPON, "drake/archer/arrow1.wav", 1, ATTN_IDLE);
        remove (self);
        return;
    }
    if (other.solid != SOLID_BSP) { // Break on impact. e.g., shielded mega enforcer.
        org = self.origin - 8*normalize(self.velocity);
        sound (self, CHAN_WEAPON, "drake/archer/arrowbrk.wav", 1, ATTN_IDLE);
        Tent_Point (TE_GUNSHOT, org);
        remove (self);
        return;
    }
	// Imbed into the surface.
    if (random() < 0.5)
        sound (self, CHAN_WEAPON, "drake/archer/arrow2.wav", 1, ATTN_IDLE);
    else
        sound (self, CHAN_WEAPON, "drake/archer/arrow3.wav", 1, ATTN_IDLE);
    self.movetype = MOVETYPE_NONE;
    self.velocity = self.avelocity = '0 0 0';
    // Reset think so arrow sticks in wall for a moment then vanishes.
    self.nextthink= time + 1.5;
    self.think    = SUB_Remove;
    self.touch    = SUB_Remove;
    if (other) {   // Hit something that may move later.  Watch the axe... er, arrow.
        self.enemy      = other;
        self.delay      = self.nextthink;
        self.nextthink  = time + 0.100;
        self.think      = Axe_Watch;
    }
};

void() AkArrow_Think = {
    if (self.delay <= time) {remove (self); return;}

    self.speed   = vlen (self.velocity);
    self.movedir = self.dest = normalize (self.velocity);
    self.angles  = vectoangles(self.movedir);
    if (self.cnt)
        Meteor_Trail (self.cnt, 1, FALSE);
	else
		particle (self.origin, '0 0 0', 6, 1);	//ijed: subtle basic arrow trail
    self.nextthink = time + 0.05;

// PM:  Energy arrows can blast ghosts.
    //if (self.worldtype)
        //Ghost_Touch ();
};

void(vector start, vector dir, float type) AkArrow_Launch = {
    newmis = spawn ();
	newmis.classgroup = CG_PROJALL;
    newmis.master       = newmis.owner        = self;
    newmis.movetype     = MOVETYPE_FLYMISSILE;
    newmis.solid        = SOLID_BBOX;
    newmis.classname    = "arrow";
    newmis.movedir      = dir;
	newmis.speed        = AKARROW_SPEED_FLY;
	newmis.velocity     = dir * newmis.speed;
    newmis.avelocity    = '0 0 0';
    newmis.avelocity_z  = newmis.speed;     // Makes arrow model spiral.
    newmis.angles       = vectoangles(newmis.velocity);
    newmis.dest         = dir;      // for 'spawn_touchblood'.
	// set missile damage
	// Damage: green = 5-7, red = 8-12, gold = 13-17
	// For Quake, do x*3 so that orange = 15-20, gold = 25-35, blue = 40-50
	// Update/Drake:  Green = 9, Red = 18, Yellow/Orange = 30.
    if (type & 2) {   // Energy arrow.
        type = newmis.count = 0;    // Was LF_YELLOW.
        Laser_Color (newmis, type);
        newmis.worldtype    = TRUE;     // FIXME:  Conflict with rocket code.
        newmis.dmg          = 30;
        newmis.think1       = AkArrow_Explode;
		// For more explosive arrow types, use safe flag so attacker doesn't
		// blow himself up.  Arrows don't explode in Hexen2, but I am making
		// them so in Drake.
		// Update 4/13/2009:  Removed lightning flag.
        newmis.style        = DF_SAFE;
        newmis.cnt          = newmis.waitmax;
        newmis.effects      = newmis.effects | EF_DIMLIGHT;
        newmis.oldorigin    = start;
        newmis.skin         = ARROW_MAGIC + type;  // Yes, use + not |.
    } else {
        newmis.worldtype    = FALSE;
        newmis.xfl          = newmis.xfl | XFL_WIND;
        // Normal wooden arrow.
        newmis.cnt          = 0;
        if (type & 4)
            newmis.dmg          = 9;    // Goblin arrow.
        else if (type & 1)
            newmis.dmg          = 18;   // Lord arrow.
        else
            newmis.dmg          = 15;   // Orc arrow.
        newmis.skin         = type & 1;
    }
    newmis.enemy        = world;
	// set missile duration
    newmis.touch        = AkArrow_Magic_Touch;
    newmis.delay        = time + 5;         // Total duration
    newmis.nextthink    = time + 0.1;
    newmis.think        = AkArrow_Think;
    if (!newmis.cnt) {
        newmis.touch = AkArrow_Wood_Touch;
        //ijed regular arrows now have a continual think to produce a subtle particle trail, not one of the more magical built in mdl variants
		//newmis.nextthink = newmis.delay;
		//newmis.think = SUB_Remove;
    }

    if (self.classtype == CT_MONREBEL) newmis.frame = 1; // Crossbow bandit hack.
    setall (newmis, "progs/drake/arrow.mdl", '0 0 0', '0 0 0', start);
};

//  Throwing Axe

// This removes the axe if its surface moves or if its been out too long.
// Update:  Also called by goblin arrow code for the same purpose.
void() Axe_Watch = {
    if (self.delay <= time)
        remove (self);
    else if (vlen (self.enemy.velocity) > 0)
        remove (self);      // Surface moved, so remove the axe now.
    else
        self.nextthink = time + 0.100;
};

//  Burst Lightning
//  The "Burst" is a form of chain lightning cast at a target.  If the
//  target is struck, and there are more targets near the one first struck,
//  secondary bolts will erupt from the primary target and strike as many
//  extra targets as possible.
//
//  This form of chain lightning is based from the description of the Chain Lightning spell in the 3rd edition of Dungeons and Dragons.
//  This returns the endpoint where a bolt of chain lightning should strike.  The spot returned is usually the center of the target struck.
vector(entity attacker, entity targ, vector start, vector end) ChainLit_Point = {
    local   vector  spot;

    spot = Midpoint (targ);
    traceline (start, spot, FALSE, attacker);
    if (trace_ent == targ) {
        // We can hit the center.  Find the best endpoint of the bolt
        // so that it looks good when drawn.  This point is located
        // between the targer's center and where the bolt hit.

        local   vector  dir;
        local   float   d_impact, d_ideal, dist;

        dir = spot - start;
        d_impact = vlen (spot - trace_endpos);
        d_ideal = vlen (dir);
        dir = normalize (dir);
		// Bolts in beam TEs are drawn in intervals of 30.
        dist = floor (d_ideal / 30) * 30;
        if (dist >= d_impact)
            end = start + dir*dist;
        else {
            spot = start + dir*(dist+30);
            if (spot_x >= targ.absmin_x)
              if (spot_x <= targ.absmax_x)
                if (spot_y >= targ.absmin_y)
                  if (spot_y <= targ.absmax_y)
                    if (spot_z >= targ.absmin_z)
                      if (spot_z <= targ.absmax_z) end = spot;
        }
    }
    return end;
};

// Called within 'BurstLit_Chain' below.
float(entity targ, entity inflictor, entity attacker, float damage, vector spot, string dtype, float bang)  BurstLit_Trace = {
    local   vector  end;

    if (targ.flags & FL_CLIENT)
        end = targ.origin;      // Use origin because of TE beam code for clients.
    else
        end = Midpoint (targ);

    // Update:  Traceline must hit intended target!
    // Targets can take damage from one bolt once because they can neither stack nor pierce.
    // Note:  Ghost touch code must be called before calling this function if ghosts are to be hit.
    traceline (spot, end, FALSE, inflictor);    // 3rd was TRUE.
    if (trace_ent == targ) {
        // Draw from source point to target point, except for players.
        // For players, draw from target point to source point
        // because engine always draws from origin in case of player.
        if (targ.flags & FL_CLIENT)
            Tent_Beam (TE_LIGHTNING2, targ, end, spot);
        else
            Tent_Beam (TE_LIGHTNING2, targ, spot, end);
        if (bang == 2)
            sound (inflictor, CHAN_VOICE, "weapons/lstart.wav", 1, ATTN_NORM);
        else if (bang)
            sound (inflictor, CHAN_VOICE, "weapons/lhit.wav", 1, ATTN_NORM);
        end = trace_endpos;     // Use where bolt hit for blood spot.
        BoltDamage (targ, inflictor, attacker, end, damage, dtype);
        return TRUE;
    }
    return FALSE;
};

// Shoots multiple lightning bolts at nearby targets from a common point.  Used by burst lightning gun.  Also used by plasma discharge.
void(entity inflictor, entity attacker, float damage, entity ignore, vector spot, string dtype, vector pak, float bang)  BurstLit_Chain = {
    local   entity  head, saved;
    local   float   hits, nff, radius, hi;

    nff = pak_x;
    radius = pak_y;
    hi = pak_z;

    hits = 0;
    saved = world;
    head = findradius (spot, radius);
    while (head) {
		// Notarget/stealth won't save you from discharge.
        if (head.takedamage == DAMAGE_AIM)      // Was flags & FLx_CREATURE.
        if (head != attacker)
        if (head != ignore)
        if (head.resist_cells < 1)     // Don't waste hits on immune targets.
        if (!HasReflection (head, spot, damage)) {    // Too much work to bounce here, so pass!
			if (!(nff && Ally_Check (head, attacker))) {  // nff = No Friendly Fire.
				// Go to the trouble of zapping live, highly vulnerable targets
				// first instead of dead or resistant targets.
				if (head.deadflag || (head.health <= 0) || (head.resist_cells > 0)) { // Dead or resistant -- save it for later.
					head.chain2 = saved;
					saved = head;
				} else if (BurstLit_Trace (head, inflictor, attacker, damage, spot, dtype, bang)) {
					hits = hits + 1;
					if (hits >= hi) return;
				}
			}
        }
        head = head.chain;
    }
	// Now we zap the saved targets because we ran out of other targets.
    while (saved) {
        if (BurstLit_Trace (saved, inflictor, attacker, damage, spot, dtype, bang)) {
            hits = hits + 1;
            if (hits >= hi) return; // I hate to burst your chain, but...
        }
        saved = saved.chain2;
    }
};

// Fires a fat bolt of lightning, then splits into three thinner bolts after hitting a target.
// 'inflictor' = Don't hit this entity during the traceline.
// 'src'       = From whom the lightning gets drawn from.
// 'targ'      = Target by traceline.
void(vector p1, vector p2, entity attacker, float damage, float reach) BurstLit_Bolt = {
    local   entity  inflictor, src, targ;
    local   vector  pak;
    local   float   boing;

    pak_x = TRUE;       // Friendly fire off.
    pak_y = reach;
    pak_z = 3;          // Max number of targets.

    inflictor = src = attacker;
    while (src) {
		// Scan for a hit.
        reach = vlen(p2 - p1);
        traceline (p1, p2, FALSE, inflictor);
        p2 = trace_endpos;
        targ = trace_ent;

		// Check for reflection.
        boing = FALSE;
        if (targ)
            if (HasReflection (targ, p2, damage) || targ.resist_cells >= 1) boing = TRUE;

		// Draw beam.
        if (targ.takedamage)    // Hit something?  Aim bolt at its center.
            if (!boing) p2 = ChainLit_Point (attacker, targ, p1, p2);
        Tent_Beam (TE_LIGHTNING1, src, p1, p2);   // Use the fat beam.
        src = world;    // Unless reflected later, end loop when done.

		// Do hit effects and damage.
        if (boing) {
            ReflectSound (targ);
            if (src != lightning) {
                reach = reach - vlen(p2 - p1);  // Get remaining dist.
                p1 = p2;
                p2 = p2 + (normalize(p2 - targ.origin) * reach);
                inflictor = targ;
                src = lightning;
            }
        } else {
            if (targ.takedamage) {
                // Direct hit does full damage and splits the beam.
                BoltDamage (targ, inflictor, attacker, p2, damage, "thunderbolt");
                BurstLit_Chain (targ, attacker, damage * 2 / 3, targ, p2, "thunderbolt", pak, FALSE);
            }
        }
    }
};

// Called by exploding plasma balls.  Also by Mjolnir.
void() RyuPlasma_Discharge = {
    local   vector  pak;
    local string damagetype = "";

    pak_x = self.style;
    pak_y = self.distance;
    pak_z = self.count;     //5;

    BurstLit_Chain (self, self.owner, (self.dmg*0.5), self.enemy, self.origin, damagetype, pak, TRUE);
};

void() RyuPlasma_Explode = {
    if (!self.dmg)
        self.dmg = 100;
    if (!self.distance)
        self.distance = 320;
    if (!self.count)
        self.count = 5;

    if (self.enemy)
    {
        local   float   dmg1, dmg2;

        dmg1 = (0.8 + random()*0.2) * self.dmg;   // Was '80 + random()*20'.
    // PM:  Add discharge damage to impact damage, then ignore other in
    // the discharge call.  Saves a hit in the discharge for someone else.
        dmg2 = self.dmg * 0.5;

        if (self.enemy.classname == "monster_shambler")
            dmg1 = dmg1 * 0.5;      // Resists explosion damage.
        else if (self.classname == "monster_dragon")
        {
            if (self.enemy.skin == 2)     //SKIN_BLUE
            {   // Resists electrical damage.
                dmg1 = dmg1 * 0.5;
                dmg2 = dmg2 * 0.5;
            }
        }

        T_Damage (self.enemy, self, self.owner, (dmg1 + dmg2), DAMARMOR);
    }
    // don't do radius damage to the other, because all the damage
    // was done in the impact
    // Note:  Radius damage was 70.
    T_RadiusDamage (self, self.owner, self.dmg*0.7, self.enemy, DAMAGEALL);

    sound (self, CHAN_AUTO, "rogue/plasma/explode.wav", 1, ATTN_NORM);
    self.origin = self.origin - 8*normalize(self.velocity);
    setorigin (self, self.origin);      // PM:  Do it right.
    Tent_Explosion2 (self.origin, 244, 3);
    RyuPlasma_Discharge ();

    BecomeAnyExplosion (138, 6, "progs/drake/s_fancy.spr");
};

void() RyuPlasma_Touch =
{
    if (pointcontents(self.origin) == CONTENT_SKY)
        {remove (self);  return;}

    self.enemy = other;
    RyuPlasma_Explode ();
};

void() RyuPlasma_Think =
{
    local   float   pc;

    if (self.delay <= time)
        {remove (self);  return;}
    pc = pointcontents(self.origin);
    if ((pc <= CONTENT_WATER) && (pc >= CONTENT_LAVA))
        {RyuPlasma_Explode();  return;}

    particle (self.origin, self.velocity * 0.005, 9, self.waitmin);   //2
    particle (self.origin, self.velocity * 0.01, 41, self.waitmax);   //4
    self.nextthink = time + 0.05;
};

void(vector start, vector dir, float sped, float damage) RyuPlasma_Launch =
{
    newmis = spawn ();
	newmis.classgroup = CG_PROJALL;
    newmis.owner        = self;
    newmis.movetype     = MOVETYPE_FLYMISSILE;
    newmis.solid        = SOLID_BBOX;
    newmis.classname    = "plasma";
// set missile speed
    newmis.movedir      = dir;
    newmis.speed        = sped;
    newmis.velocity     = dir * sped;
    newmis.avelocity    = '300 300 300';
    newmis.angles       = vectoangles(newmis.velocity);
// set missile damage
    newmis.dmg          = damage;
    //effects set below.
    newmis.distance     = damage + 220;     // 320 when dmg == 100.
    newmis.enemy        = world;
    newmis.style        = FALSE;    // TRUE is 'no friendly fire' discharge.
    // Note:  Mjolnir has a range of 350.
// set missile duration
    newmis.touch        = RyuPlasma_Touch;
    newmis.delay        = time + 5;     // Total duration.  As spikes.
    newmis.nextthink    = 0.01;
    newmis.think        = RyuPlasma_Think;

    // Big plasma balls from DoE.
    newmis.waitmin      = 2;
    newmis.waitmax      = 4;
    newmis.effects      = EF_DIMLIGHT;  // DoE used EF_BRIGHTLIGHT.
    setmodel (newmis, "progs/plasma.mdl");
    setsize (newmis, '0 0 0', '0 0 0');
    setorigin (newmis, start);
};


//==========================================================================
//  Acid Bomb -- Used by green dragon.

void() Acidball_Touch =
{
    if (pointcontents(self.origin) == CONTENT_SKY)
        {remove (self); return;}

    self.touch = SUB_Null;
    self.enemy = other;

    if (!self.dmg)
        self.dmg = 120;

    // Don't bother with green dragon acid resistance.
    if (self.enemy)     // Don't check health, just if there is a target.
    {   // Someone took a direct hit.
        local   float   damage;

        damage = self.dmg / 6 * (5 + random());
        T_Damage (self.enemy, self, self.owner, damage, DAMARMOR);
    }
    // Don't do radius damage to the enemy, because all the damage
    // was done in the impact.
    T_RadiusDamage (self, self.owner, self.dmg, self.enemy,DAMAGEALL);

// PM:  Don't set origin directly during a touch function because of
// possible link scrambling.  May cause FitzQuake to crash otherwise.
    self.origin = self.origin - 8*normalize(self.velocity);
    Tent_Explosion2 (self.origin, 48, 16);
    BecomeAnyExplosion (115, 5, "progs/drake/s_fancy.spr");
};

void(vector start, vector dir, float sped, float damage) Acidball_Launch =
{
    newmis = spawn ();
	newmis.classgroup = CG_PROJALL;
    newmis.owner        = self;
    newmis.movetype     = MOVETYPE_TOSS;
    newmis.solid        = SOLID_BBOX;
    newmis.classname    = "acid";
// set missile speed
    newmis.speed        = sped;
    newmis.velocity     = dir * sped;
    newmis.avelocity    = '200 100 300';
    newmis.angles       = vectoangles(newmis.velocity);
// set missile damage
    newmis.dmg          = damage;
// set missile special stuff
    newmis.dest         = dir;
// set missile duration
    newmis.touch        = Acidball_Touch;
    newmis.nextthink    = time + 5;
    newmis.think        = SUB_Remove;

    setmodel (newmis, "progs/drake/acidbal1.mdl");
    setsize (newmis, '0 0 0', '0 0 0');
    setorigin (newmis, start);
};


//==========================================================================
//  Acid -- Used by scrag and green dragon.

void() Acid_Think =
{
    if (self.delay <= time)
        {remove (self); return;}

//    self.angles = normalize (self.velocity);
//    self.angles = vectoangles (self.angles);
    self.angles = vectoangles (self.velocity);
    self.nextthink = time + 0.1;
};

void(vector start, vector dir, float sped) Acid_Launch = { launch_projectile(start, dir, CT_PROJ_WIZ, sped);  };

void(vector start, vector dir, float sped) Acid_Toss =
{
    Acid_Launch (start, dir, sped);

    newmis.movetype  = MOVETYPE_TOSS;
    newmis.speed     = sped;
    newmis.velocity  = (dir * sped) + '0 0 200';
    newmis.angles    = vectoangles (newmis.velocity);
    newmis.delay     = newmis.nextthink;
    newmis.nextthink = time + 0.1;
    newmis.think     = Acid_Think;
};

//==========================================================================
//  Meat -- Used by zombie and nightshade (wraith dragon)

// Formerly 'ZombieGrenadeTouch'
void() Meat_Touch = {
    if (pointcontents(self.origin) == CONTENT_SKY)
        {remove (self); return;}
    if (Reflected ()) return;

    if (other.takedamage) {
        if (!self.dmg)
            self.dmg = 10;
        self.touch = SUB_Null;      // Stack overflow prevention.
//        if (cranked)
//            Poison_Add (other, 1);      // Give fatal illness like in movies.
        T_Damage (other, self, self.master, self.dmg, DAMARMOR);
        sound (self, CHAN_WEAPON, "zombie/z_hit.wav", 1, ATTN_NORM);
        remove (self);
        return;
    }
    sound (self, CHAN_WEAPON, "zombie/z_miss.wav", 1, ATTN_NORM);    // bounce sound
    self.velocity = self.avelocity = '0 0 0';
    self.touch = SUB_Remove;
};

// This was formerly 'ZombieFireGrenade'.
void(vector start, vector dir) Meat_Launch = {
    newmis = spawn ();
	newmis.classgroup = CG_PROJALL;
    newmis.master       = newmis.owner      = self;
    newmis.movetype     = MOVETYPE_BOUNCE;
    newmis.solid        = SOLID_BBOX;
//    newmis.classname    = "meat";
// set missile speed
    newmis.speed        = 600;
    newmis.velocity     = dir * 600;
    newmis.velocity_z   = newmis.velocity_z + 200;  // Used to be 200 only.
    newmis.avelocity    = '3000 1000 2000';
// set missile damage
    newmis.dmg          = 10;
    if (self.classname == "monster_mummy")
        newmis.dmg          = random() * 15 + 15;
// set missile duration
    newmis.touch        = Meat_Touch;
    newmis.nextthink    = time + 2.5;
    newmis.think        = SUB_Remove;

    setall (newmis, "progs/zom_gib.mdl", '0 0 0', '0 0 0', start);
};

//==========================================================================
//  Magic Missiles -- Used by hell knight, baron, and nemesant.

// Moved to 'weapons.qc'.


//==========================================================================
//  Rain Storm -- Used by the elemental boss barons.

//- - - - - - - - -
// Various missile functions for the rainstorm.
void() RainStorm_Ice =
{
// Use flymissile instead of toss for the missile clip bonus.
// Then set speed to a reasonably fast value to use for terminal velocity.
    Ice_Launch (trace_endpos, '0 0 -1', 1000);
    newmis.master   = newmis.owner  = self.owner;
    newmis.delay    = time + 2.5;
    newmis.dmg      = self.dmg;
};

// DISABLED -- Unused.
//void() RainStorm_Fire =
//{
//    Fireball_Launch (self.owner, trace_endpos, '0 0 -1', 1000, self.dmg);
//    newmis.delay    = time + 2.5;
//    newmis.noise    = "hknight/hit.wav";
//    newmis.style    = newmis.style | DF_SAFE;
//};

// DISABLED -- Unused.
//void() RainStorm_Steel =
//{
//    launch_superspike (trace_endpos, '0 0 -1');
//    newmis.master   = newmis.owner  = self.owner;
//    newmis.nextthink= time + 2.5;
//    newmis.dmg      = self.dmg;
//};
//- - - - - - - - -

void() RainStorm_Think =
{
    if (self.delay <= time)
    {
        super_active = 0;
        remove (self);
        return;
    }

// Find a point to spawn a rain drop.
    local   vector  p1, p2, dir;

    p1 = self.enemy.origin;
    p2_x = crandom() * self.distance + p1_x;
    p2_y = crandom() * self.distance + p1_y;
    p2_z = p1_z;

    traceline (p1, p2, TRUE, self);
    p2 = trace_endpos;
    if (trace_fraction < 1)
    {   // Move away from the wall a tiny bit.
        dir = normalize (p2 - p1);
        p2 = p2 - dir*2;
    }
    traceline (p2, p2 + '0 0 2048', TRUE, self);
    // Move endpoint away from the ceiling.
    // We can't pass vectors to a void() function, so use trace_endpos.
    if (trace_fraction < 1)
        trace_endpos = trace_endpos - '0 0 2';

    if (self.think1)
        self.think1 ();
    else
        {remove (self);  return;}

    self.nextthink = time + self.wait;
};

// Spawns a missile spawner that drops shots on a target from the ceiling.
void(entity targ, entity attacker, float damage, float fps, float dist,
    float limit, void() thinkst) RainStorm =
{
    if (limit)
    if (super_active)   // FIXME:  Check this only if attacker is a monster.
        return;

    super_active = 1;       // This chews through a lot of edicts.

    if (!fps)
        fps = 10;
    if (!dist)
        dist = 64;

    newmis = spawn();
    setorigin (newmis, '0 0 0');

    newmis.owner    = attacker;
    newmis.enemy    = targ;
    newmis.delay    = time + 5;
    newmis.think    = RainStorm_Think;
    newmis.think1   = thinkst;
    newmis.dmg      = damage;
    newmis.wait     = 1 / fps;
    newmis.distance = dist;
    newmis.nextthink= 0.01;
};

//==========================================================================
//  Light Wall

// Yes, this is a cut-and-paste job from the firewall code.
float   SPEED_LIGHTWALL  = 400;

void() Lightwall_Think =
{
    local   float   pc;
    local   vector  spot;

    if (self.delay <= time)
        {remove (self);  return;}   // Time's up.
    pc = pointcontents (self.origin);
    if (pc == CONTENT_SOLID)
        {remove (self);  return;}   // In the void.

// Trace lightning bolt.
    traceline (self.origin, self.origin + '0 0 4096', TRUE, self);
    spot = trace_endpos;
    LightningBolt (spot, spot - '0 0 8192', self.master, self.dmg, self, TE_LIGHTNING2, "lightning");
    particle (trace_endpos, trace_plane_normal, 41, 10);

// The rest of the spawner missile think.
    if (self.enemy)
    {   // Steer toward the enemy.
        spot = self.enemy.origin + self.enemy.view_ofs;
        {   // Change yaw only.  Aim_Line plots intercept course.
            // Use 'normalize(spot - self.origin)' instead to follow directly.
            spot = Aim_Line (self.origin, spot, SPEED_LIGHTWALL, self.enemy);
            self.ideal_yaw = vectoyaw(spot);
            self.ideal_yaw = anglemod(self.ideal_yaw);
            ChangeYaw ();
        }
        // Update direction.
        spot = self.angles;
        spot_x = 0 - spot_x;
        makevectors (spot);
        self.movedir  = v_forward;
    }
    self.velocity   = self.movedir * self.speed;
    self.angles     = vectoangles(self.velocity);
    self.nextthink  = time + 0.05;
};

void(vector start, vector dir, entity targ) Lightwall_Spawn =
{
    newmis = spawn ();
    newmis.master       = newmis.owner      = self;
    newmis.movetype     = MOVETYPE_NOCLIP;  // Pass through all.
    newmis.solid        = SOLID_NOT;
    newmis.classname    = "lightning";
// set missile speed
    newmis.speed        = SPEED_LIGHTWALL;
    newmis.movedir      = dir;
    newmis.velocity     = dir * SPEED_LIGHTWALL;
    newmis.angles       = vectoangles(newmis.velocity);
// set missile damage
    newmis.dmg          = 15;   // Half of 30.
    newmis.enemy        = targ;
    newmis.yaw_speed    = 5;    // Thinks 20/sec, effective yaw_speed of 10.
// set missile duration
    newmis.delay        = time + 6;
    newmis.nextthink    = time + 0.05;
    newmis.think        = Lightwall_Think;

    newmis.modelindex = 0;      // Missile is invisible.
    setsize (newmis, '0 0 0', '0 0 0');        
    setorigin (newmis, start);

    sound (newmis, CHAN_WEAPON, "weapons/lstart.wav", 1, ATTN_NORM);
};

// Launch a lightning wall.  Designed for use by storm knights.
void() M_Lightwall =
{
    local   entity  targ;
    local   vector  org, dir;

    self.effects = self.effects | EF_MUZZLEFLASH;

// DISABLED -- No initial intercepting aim.
//    if (skill >= 2)     // As with Chthon, lead on Hard and up.
//        targ = self.enemy;
//    else
        targ = world;
    org = self.origin + self.view_ofs;
    dir = self.enemy.origin + self.enemy.view_ofs;
    dir = Maim_Line (org, dir, SPEED_LIGHTWALL, targ, '0 0 0');
    Lightwall_Spawn (org, dir, world);

// Hack (hknight):  On Normal or higher, the bolt seeks the enemy.
    if (skill >= 1)
        newmis.enemy = self.enemy;
};

//==========================================================================
//  Knight Fireball -- Used by hell knight and baron.

void(vector start, vector dir) KnightBall_Launch = {
    local   entity  missile;

    missile = spawn ();
	missile.classgroup = CG_PROJALL;
    missile.master      = missile.owner     = self;
    missile.movetype    = MOVETYPE_FLYMISSILE;
    missile.solid       = SOLID_BBOX;
    missile.classname   = "fireball";
// set missile speed
    missile.speed       = 1000;
    missile.velocity    = dir * 1000;
    missile.angles      = vectoangles(missile.velocity);
    missile.avelocity   = '0 0 0';
    missile.avelocity_z = random()*2000 - 1000;
// set missile damage
    missile.dmg         = 60;
	missile.pos1		= '60 0 40'; // Base + Random, Splash
    missile.enemy       = world;
    missile.style       = DF_ROCKET;    // Shamblers take half damage.
// set missile duration
    missile.touch       = Touch_Missile;
    missile.nextthink   = time + 5;
    missile.think       = Orange_Explosion;
    missile.frame       = 2;
    setall (missile, "progs/drake/k_ball.mdl", '0 0 0', '0 0 0', start);

    newmis = missile;
};

void(vector st, float lo) M_FireKnight = {
    local   vector  p1, p2, dir;
    local   entity  targ;

//    if (cranked)
//        targ = self.enemy;
//    else
        targ = world;
    makevectors (self.angles);
    p1 = self.origin + (v_forward * st_x) + (v_right * st_y) + (v_up * st_z);
    p2 = Aimpoint (self.enemy);
    if (lo)
        p2_z = self.enemy.absmin_z + 1;

	dir = normalize(p2 - p1);
    // dir = Maim_Line (p1, p2, 1000, targ, '0 0 0');

    self.effects = self.effects | EF_MUZZLEFLASH;
    sound (self, CHAN_WEAPON, "drake/baron/fireball.wav", 1, ATTN_NORM);

    KnightBall_Launch (p1, dir);
};

//================
// W_FireSaw
//================
void(entity targ, vector dir) Attack_Saw =
{
    local   vector  spot;
	local vector source, org, vec2;
	local float src_dist, dotprod, axedmg;
	local entity onflr, tself, tother;

	source = self.origin + '0 0 16';		// Move source point up body

	// See if there are any bodies lying around
	onflr = find(world, bodyonflr, MON_ONFLR);
	while (onflr) {
		src_dist = vlen(source - onflr.origin);
		if (src_dist < RANGE_CHOPAXE) {			// Is the body close to the player?
			org = onflr.origin - '0 0 16';		// move origin close to floor
			makevectors (self.v_angle);			// Calculate viewing angle
			vec2 = normalize (org - self.origin);
			dotprod = vec2 * v_forward;
			if (dotprod > 0.6) {				// Is the body infront of the player
				onflr.origin = org;				// Move gib closer to floor
				onflr.bodyonflr = string_null;	// no more body gibbing
				tself = self; tother = other;	// save self/other
				self = onflr; other = tself;	// switch around
				if (onflr.classgroup == CG_ZOMBIE && !(targ.classname == "monster_mummy")) {
					self.health = 0;
					Killed(onflr, tself);
				} else {
					self.max_health = MON_NOGIBVELOCITY; // use minimal velocity
					monster_ThrowGib();			// throw parts
				}
				
				self = tself; other = tother;	// switch back
				SpawnBlood (onflr, onflr.origin, '0 0 50', axedmg*4);
				return;																// Finished
			}
		}
		// See if there are anymore bodies close by
		onflr = find(onflr,bodyonflr, MON_ONFLR);
	}

    spot = self.origin + '0 0 16';      // 'source'
    traceline (spot, spot + dir*64, FALSE, self);
    if (trace_fraction == 1.0) return;

    // This next check is for AI-controlled monsters aiming at 'targ',
    // which should equal 'self.enemy'.
    if (targ)
        if (trace_ent != targ) return;     // Missed target.

    spot = trace_endpos - dir*4;        // 'org'
    targ = trace_ent;
    if (targ.takedamage) {
        local   vector  vec;
        local   float   damage, pain;
        local   string  dtype;

        dtype = "chainsaw";     // Normal kill.
        // dflags = DF_SCAR | DF_MELEE;
        damage = 40;

		// Suck life like Heretic's necro gauntlets.
        //if (self.tome_finished) {
        //    if (damage < 40)
        //        damage = 40;
        //    dflags = dflags | DF_LEECH;
        //}
		// Blood!
        vec = ((random()*300) - 150) * v_right + (100 * v_forward);
        SpawnBlood (targ, trace_endpos, '0 0 5', damage);
        if (self.weaponframe & 1) SpawnMeatSpray(self,targ,(crandom() * 300));
		
        pain = FeelsPain (targ); // Damage!
        T_Damage (targ, self, self, damage, DAMARMOR);

        if (trace_ent.flags & FL_MONSTER){
            targ.velocity = targ.velocity * 0.5;
		// Sounds.
			sound (self, CHAN_WEAPON, "zerstorer/weapons/sawguts.wav", 1, ATTN_NORM);
			if (targ.hittype == HIT_METAL || targ.spawnflags & MON_OGRE_GREEN || targ.spawnflags & MON_HOGRE_METAL)
				if (pain && (targ.pain_finished > time))
					sound (self, CHAN_AUTO, "drake/weapons/clang.wav", 1, ATTN_NORM);

			if (targ.hittype == HIT_STONE)
				if (pain && (targ.pain_finished > time))
					sound (self, CHAN_AUTO, "drake/weapons/axhitwal.wav", 1, ATTN_NORM);

			self.punchangle_x = -8;
		}
		// Breakable impact sounds (def=stone/brick)
		else if (trace_ent.classtype == CT_FUNCBREAK) {
			if (trace_ent.style == BTYPE_WOOD) 
				sound (self, CHAN_WEAPON, SOUND_AXE_WOOD, 1, ATTN_NORM);
			else if (trace_ent.style == BTYPE_GLASS) 
				sound (self, CHAN_WEAPON, SOUND_AXE_GLASS, 1, ATTN_NORM);
			else if (trace_ent.style == BTYPE_METAL) 
				sound (self, CHAN_WEAPON, SOUND_AXE_METAL, 1, ATTN_NORM);
			else if (trace_ent.style == BTYPE_FLESH) 
				sound (self, CHAN_WEAPON, SOUND_AXE_FLESH, 1, ATTN_NORM);
			else
				sound (self, CHAN_WEAPON, SOUND_AXE_STONE, 1, ATTN_NORM);
		}
    }
    else
    {   // Hit wall.
		sound (self, CHAN_WEAPON, SOUND_AXE_STONE, 1, ATTN_NORM);
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_GUNSHOT);
		WriteCoord (MSG_BROADCAST, org_x);
		WriteCoord (MSG_BROADCAST, org_y);
		WriteCoord (MSG_BROADCAST, org_z);
    }
};

void() W_FireSaw = {
    if (cutscene || intermission_running || cinematic_running) return;     // Abort if in intermission.
    makevectors (self.v_angle);
    Attack_Saw (world, v_forward);
};

// Homing Rockets - - - - - - - - - - -
// Returns a linked list of targets, with the best at the head of list.
// Uses .chain2 to link targtes.
entity(entity attacker, vector org, vector dir, float radius, float scope) SuperRocket_Target = {
    local   entity  head, targ, link, old;
    local   vector  vec, end;
    local   float   dp;     // Dot Product

    targ = world;
    head = findradius(org, radius);
    while (head) {
		// Target must be a living creature without any stealth tech.
        if (head.health > 0)
        if (!head.invisible_finished)
        if (!(head.flags & FL_NOTARGET))
        if (head.flags & FLx_CREATURE)
        if (!(head.charmer == attacker)) {
			// Get the target whose direction matches aim vector the closest.
            end = Midpoint (head);
            vec = normalize (end - org);
            dp = vec * dir;
            if (dp > scope) {
                traceline (org, end, TRUE, head);
                if (trace_fraction == 1) {
					// Accept as a possible target.
                    // Make a chain of targets.
                    head.chain2 = world;
                    head.frate2 = dp;
                    if (targ) {
						// Sort the chain by dot product in descending order.
                        old = world;
                        link = targ;
                        while (link) {
                            if (dp > link.frate2) {
								// This target is more desirable.
                                head.chain2 = link;
                                if (old)
                                    old.chain2 = head;
                                else
                                    targ = head;
                                link = world;   // End this sub-loop.
                            } else {
								// Next!
                                old = link;
                                link = link.chain2;
                                if (!link)
                                    old.chain2 = head;
                            }
                        }
                    }
                    else
                        targ = head;
                }
            }
        }
        head = head.chain;
    }
    return targ;
};

// Sidewinder Rockets - - - - - - - - -
// Used by players and mega enforcers.
// Some of the sidewinder code is also used by other monsters (SoE acolyte).

// Missile angles oscillate around ideal_yaw.
// Use when missile needs to sidewind along a straight line.
void() Sidewind_Ideal = {
    local   float   diff, yaw;

    yaw = self.ideal_yaw;
    diff = anglemod(yaw - self.angles_y);
    if ((diff > 0) && (diff <= 180))
        self.ideal_yaw = self.angles_y + self.yaw_speed;   // Go left.
    else
        self.ideal_yaw = self.angles_y - self.yaw_speed;   // Go right;
    ChangeYaw ();
    self.ideal_yaw = yaw;
};

// Missile changes pitch and yaw to face its target point.
// The missile must always turn toward ideal_yaw at full yaw_speed.
void(vector spot) Sidewind_Face = {
    local   vector  ang;
    local   float   diff;
    local   float   up;

//- - - - - - - - -
    if (self.lefty)
    {   // Oscillate up and down slightly.
        up = (self.cnt & 7) * 45;
        up = mathlib_cos(up) * 5;
        self.cnt = self.cnt + 1;
    }
    else
        up = 0;
//- - - - - - - - -

    ang = normalize (spot - self.origin);
    ang = vectoangles (ang);
    self.angles_y = anglemod(self.angles_y);
// Change pitch - - - - - - -
    // Copy pitch into yaw to fool Quake into changing the pitch for us.
    self.ideal_yaw = anglemod(ang_x + up);
    diff = self.angles_y;   // Remember this so we can restore yaw later.
    self.angles_y = self.angles_x;
    ChangeYaw ();
    self.angles_x = self.angles_y;
    self.angles_y = diff;   // Restore yaw now that pitch has changed.
// Change yaw - - - - - - - -
    diff = anglemod(ang_y - self.angles_y);
    if ((diff > 0) && (diff <= 180))
        self.ideal_yaw = self.angles_y + self.yaw_speed;   // Go left.
    else
        self.ideal_yaw = self.angles_y - self.yaw_speed;   // Go right;
    self.ideal_yaw = anglemod(self.ideal_yaw);
    ChangeYaw ();
};

// The missile must always turn toward ideal_yaw at full yaw_speed.
void(vector vec, float sped) Sidewind_Go = {
    Sidewind_Face (vec);

    vec = self.angles;
    vec_x = 0 - vec_x;
    makevectors (vec);
    self.velocity = v_forward * sped;
};

// The next three functions are designed specifically for the mega enforcers' sidewinder missiles (which the player may use too). but are also used for the Necromancer boss's Necrosnake attack
void() Sidewinder_Think = {
    local vector vec;
    local float sped;

    if (self.delay < time) {
		// Out of gas.
        if (self.style & DF_ROCKET) {
            Touch_Missile();
        } else remove (self); // For acolytes' venom shots.
        return;
    }

    if (self.enemy)
        sped = ( !(self.enemy.items & IT_INVISIBILITY) && !(self.enemy.flags & FL_NOTARGET) );
    else
        sped = FALSE;
    if (sped) {
        vec = Aimpoint (self.enemy);    // Was self.enemy.origin;
        Sidewind_Face (vec);
        if (!self.volume) {
			// Lose track if missile flies past its target.
            local   float   d1, d2;
            local   vector  dir;

            dir = normalize(self.velocity);
            d1 = normalize(self.enemy.origin - self.origin) * dir;
//            dprint(ftos(d1));  dprint("\n");    // Debug message.

            if (d1 < 0)
            {   // Target is behind the missile.
                // Check if missile is further away than the target.
                // If missile is further away from the current owner than
                // the target is from missile's owner, assume the missile
                // flew behind the target and drop the target.
                if (self.master.flags & FL_MONSTER)
                {
                    d1 = vlen (vec - self.owner.origin);
                    d2 = vlen (self.origin - self.owner.origin);
                    if (d2 > (d1 + 50))
                        self.enemy = world;   // Assumed to be behind target.
                }
            }
        }
    }
    else if ((self.master == self.owner) && (!self.oldenemy))
        Sidewind_Face (self.pos2);      // No target to begin with.
    else
        Sidewind_Ideal ();

    sped = random() * 50 + 450;     //random() * self.height + self.speed;

    vec = self.angles;
    vec_x = 0 - vec_x;
    makevectors (vec);
    self.velocity = v_forward * sped;

    if (self.lefty & 1)
        {self.lefty = 2;  self.nextthink = time + 0.1;}
    else
        self.nextthink = time + 0.2;
};

// Update 4/2/10:  Adapted for player use.  Mega enforcer still uses this.
void(vector start, vector dir, entity targ) Sidewinder_Launch = {
    newmis = spawn ();
	newmis.classgroup = CG_PROJALL;
    newmis.master       = newmis.owner      = self;
    newmis.movetype     = MOVETYPE_FLYMISSILE;
    newmis.solid        = SOLID_BBOX;
    newmis.classname    = "rocket";
    newmis.yaw_speed    = 30;   // For sidewinding code.
    newmis.speed        = 450;
    newmis.height       = 50;
    newmis.velocity     = dir * (450 + (random() * 50));
    newmis.angles       = vectoangles(newmis.velocity);
    newmis.dmg          = 90;
    newmis.style        = DF_ROCKET;
    newmis.oldenemy     =
    newmis.enemy        = targ;
    newmis.ideal_yaw    = newmis.angles_y;
    newmis.cnt          = 0;
    newmis.lefty        = 1;
    newmis.pos2         = start + (dir * ((newmis.speed + newmis.height) * 5)); // Get the spot we want to hit if fired straight without a target.
    newmis.touch        = T_MissileTouch;
    newmis.delay        = time + 2.5;       // Total duration
    newmis.nextthink    = time + 0.2;       // Was T+0.25
    newmis.think        = Sidewinder_Think;
    newmis.think1       = Old_Explosion1;
    setall (newmis, "progs/drake/memissil.mdl", '0 0 0', '0 0 0', start);
};

void() W_FireSidewinder = {
    if (self.ammo_rockets < 1) return;

    self.currentammo = self.ammo_rockets = self.ammo_rockets - 1;
    sound (self, CHAN_WEAPON, "zerstorer/weapons/stunfire.wav", 1, ATTN_NORM);
    self.punchangle_x = -2;

    local   vector  start, dir;
    local   entity  targ;

    makevectors (self.v_angle);
    start = self.origin + v_forward*8 + '0 0 16';
    dir = v_forward;
    // Select a target in front of the player's sights.
    targ = SuperRocket_Target (self, start, dir, 2000, COS30);

    Sidewinder_Launch (start, dir, targ);
};

//==========================================================================
//  Coven of Ebony Attacks
//==========================================================================
void() NecroSnake_Touch = {
    if (pointcontents(self.origin) == CONTENT_SKY) {remove(self);  return;}
    if (Reflected ()) return;

    self.touch = SUB_Null;      // Stack overflow prevention.
    if (other.takedamage && (other.classname != self.master.classname)) {
        spawn_touchblood (self,other,self.dmg);
        T_Damage (other, self, self.master, self.dmg, DAMARMOR);
        // Update 6/11/2011:  Removed poison critical hits.
    } else Tent_Point (TE_WIZSPIKE, self.origin);
    remove (self);
};

// Launches a sidewinding poison shot.  Used by acolytes.
void(vector start, vector dir, float sped) NecroSnake_Launch = {
    newmis = spawn ();
	newmis.classgroup = CG_PROJALL;
    newmis.master       = newmis.owner        = self;
    newmis.movetype     = MOVETYPE_FLYMISSILE;
    newmis.solid        = SOLID_BBOX;
    newmis.classname    = "wizspike";
    newmis.speed        = sped;
    newmis.velocity     = dir * sped;
    newmis.angles       = vectoangles(newmis.velocity);
    newmis.dmg          = 9;
    newmis.enemy        = self.enemy;
    newmis.worldtype    = TE_WIZSPIKE;
    newmis.speed        = sped;
    newmis.yaw_speed    = 10;
    newmis.ideal_yaw    = self.angles_y;
    // Get the spot we want to hit if fired straight without a target.
    newmis.pos2         = start + (dir * ((newmis.speed + newmis.height) * 5));
    newmis.touch        = NecroSnake_Touch;     //spike_touch;
    newmis.delay        = time + 5;     // Total duration
    newmis.nextthink    = time + 0.1;
    newmis.think        = Sidewinder_Think;
    setall(newmis, "progs/w_spike.mdl", '0 0 0', '0 0 0', start);
};

//  Explosive Runes -- Used by Ebon Sorcerer.  Deposits an explosive rune where the necro is standing.
void(vector org) NecroBomb = {
    newmis = spawn();
	newmis.classgroup = CG_PROJALL;
    newmis.master       = newmis.owner        = self;
    newmis.movetype     = MOVETYPE_FLY;
    newmis.solid        = SOLID_TRIGGER;
    newmis.classname    = "necrobomb";
    newmis.velocity     = '0 0 0';
    newmis.angles       = '0 0 0';
    newmis.angles_y     = random() * 360;   //self.angles_y;
    newmis.style        = DF_ROCKET;
    newmis.dmg          = 70;
    newmis.touch        = Touch_Missile;
    newmis.wait         = time + 0.2;
    newmis.nextthink    = time + 1;     //(1 + random()) * 0.5
    newmis.think        = Touch_Missile;
    setall (newmis, "progs/drake/nec_rune.mdl", '-16 -16 -24', '16 16 32', org);
};

//==========================================================================
//  Necrobolt -- Used by Ebon Warlock and Dark Lord

// Update:  Instead of splitting into multiple mini-spikes, the bolt now
// redirects like shal-rath homing bombs, except update frequency is longer.
// It resembles more like the Amazon's Guided Arrows from Diablo 2.
void() NecroBolt_Think = {
    if (self.delay <= time) {
        local   vector  vec;

		//if ((self.count > 3) || (self.enemy.health <= 0))
        if ((self.dmg <= 40) || (self.enemy.health <= 0)) {
            BecomeFancy (X32_STAR_RED + 3, 2);
            return;
        }

        vec = Aimpoint (self.enemy);
        vec = normalize (vec - self.origin);

    // Each update weakens the bolt, so long distance attacks are
    // less effective.
	//    self.count      = self.count + 1;
        self.dmg        = self.dmg - 10;
        self.delay      = time + 1;     // Much like Diablo2 Guided Arrow.
        self.velocity   = vec * self.speed;
        self.angles     = vectoangles(self.velocity);
        self.owner      = world;    // Let bolt hit the source now.
    }

	// Draw particle trail.
    particle (self.origin, self.velocity * 0.005, 73, 2);
    particle (self.origin, self.velocity * 0.01, 225, 4);
    self.nextthink = time + 0.100;

    // Ghost_Touch ();
};

void() NecroBolt_Touch = {
    if (pointcontents(self.origin) == CONTENT_SKY) {remove(self);  return;}
    if (Reflected_Damage (COURAGE_DAMAGE)) return;

    self.touch = SUB_Null;      // Stack overflow prevention.

	// PM:  Half strength would be 50+d10, but since older progs used 50+d20
	// and gives the shot more oomph, I'll leave damage alone.
    if (other.classname != self.master.classname) {
		// Note:  Warlocks are immune, and shamblers take full damage.
        local   float   damage;

        damage = (self.dmg - 20) + (random() * 20);
        if (damage > 0) T_Damage (other, self, self.master, damage, DAMARMOR);
    }
	// PM:  Don't use 120 radius damage because that is too much.
	// Also, even though effects look like lightning, it isn't -- it's magic!
    T_RadiusDamage (self, self.master, self.dmg, other, DAMAGEALL);

	// Create wicked red electric explosion.
    self.origin = self.origin - 8*normalize(self.velocity);
    Sfx_Discharge ();
    Rocket_Explosion2 (self.origin, 247, 5);     // Red
    BecomeFancy (X56_PLASMA_RED, 6);
};

// Launches a crimson energy seeker bolt.  Used by warlocks.
void(vector start, vector dir) NecroBolt_Launch = {
    newmis = spawn ();
	newmis.classgroup = CG_PROJALL;
    newmis.master       = newmis.owner        = self;
    newmis.movetype     = MOVETYPE_FLYMISSILE;
    newmis.solid        = SOLID_BBOX;
    newmis.classname    = "necrobolt";
	// set missile speed
    newmis.speed        = 600;
    newmis.velocity     = dir * 600;
    newmis.avelocity    = '0 0 1200';
    newmis.angles       = vectoangles(newmis.velocity);
	// set missile damage
    newmis.yaw_speed    = 360;  // PM: Let dragons know this cannot be dodged.
    newmis.style        = DF_ROCKET | DF_SAFE;
    newmis.dmg          = 70;   // max(50+d20) = 70.
    newmis.enemy        = self.enemy;
	// FIXME:  warlock immunity.
	//    newmis.worldtype    = MDAM_TWENTY;
	// set missile duration
    newmis.touch        = NecroBolt_Touch;
    newmis.delay        = time + 0.8;   // Total duration
    newmis.nextthink    = time + 0.1;
    newmis.think        = NecroBolt_Think;
	//newmis.think1       = NecroBolt_Explosion;

    setall (newmis, "progs/drake/r_bolt.mdl", '0 0 0', '0 0 0', start);
};

// ATTACK - - - - - - - - - - - - - - -
// SoE:  Check added so hell lords don't summon meteors at inappropriate times.
float(vector p) M_MeteorCheck = {
    local   vector  org, spot, vec;

    spot = self.enemy.origin;
    vec = spot - self.origin;
    if (vlen(vec) < 200)
        return FALSE;   // Enemy too close to attacker.

    org = vectoangles (vec);
    makevectors (org);
    org = self.origin + p_x*v_forward + p_y*v_right + p_z*'0 0 1';

    if (vlen(spot - org) < 200)
        return FALSE;   // Not enough time for target to react.

    traceline (self.origin, org, TRUE, self);
    if (trace_fraction < 1)
        return FALSE;   // Spawn point blocked.

    return TRUE;
};

// SoE:  Split off from boss_missile so Hell Lord can use as well.
void(vector p, float sped, float multishot, float toss) boss_meteor = {
    local   vector  org, vec, d, avel;
	//    local   float   sped;

    vec = vectoangles (self.enemy.origin - self.origin);
    makevectors (vec);

    org = self.origin + p_x*v_forward + p_y*v_right + p_z*'0 0 1';
	// SoE:  Monsters must have unbroken line to spawn point.
	// Do that to minimize chances of meteors appearing in the wall.
    if (self.flags & FL_MONSTER)    // Chthon doesn't have this flag.
    {   // If TRUE, self is probably a Hell Lord.
        traceline (self.origin, org, TRUE, self);
        if (trace_fraction < 1)
        {
            org = org - self.origin;
            sped = vlen(org) - 32;
            org = normalize(org);
            org = self.origin + org*sped;
        }
    }
	//- - - - - - - - -
	//    sped = 300;
		
	// lead the player on hard mode
    d = self.enemy.origin;
    // if (self.spawnflags & SPAWN_LOBBER)
        // d = d + self.enemy.view_ofs;
    if (skill >= 2)
        d = Aim_Lead (org, d, sped, self.enemy);
    vec = normalize (d - org);
	avel = vecrand(100,200,FALSE);

    if (multishot) {
		Launch_Missile (org, vec, avel, CT_PROJ_FIRETOP, self.attack_speed);
    } else {
		// Classic lavaball.
		avel = vecrand(100,200,FALSE);
        Launch_Missile (org, vec, avel, CT_PROJ_LAVA, self.attack_speed);
    }
// Update 8/28/10:  Toss missile for Chthon in unforgiven4.
    if (toss)
    {   // Override velocity for a parabolic flight path.
        // Chthon is the boss -- he can throw stuff as fast as he wants!
        toss = vlen(d - org);
        if (toss > sped * 5)  // Target too far away, speed up the shot!
            sped = toss / 5;
        toss = Aim_TossUp (org, d, sped);
        newmis.velocity = Aim_Toss (org, d, sped, toss, world);
        newmis.velocity = newmis.velocity * sped;
        newmis.velocity_z = newmis.velocity_z + toss;
        newmis.movetype = MOVETYPE_TOSS;
    }
//- - - - - - - - -

    sound (self, CHAN_WEAPON, "boss1/throw.wav", 1, ATTN_NORM);
};


void(float lo, float hi) Thor_Slam =
{
    local   entity  base, lite;
    local   float   loop;
    local   vector  ang;    // PM:  New.
    local   vector  spot;   // Ditto.

    spot = trace_endpos;

// PM:  Make idle lightning parallel to ground, rather than flat 0 degrees.
//    if (1)
//        ang = '0 0 0';
//    else
    {   ang = vectoangles (trace_plane_normal);
        ang_x = anglemod (ang_x - 90);
    }
    ang_y = self.angles_y;

// spawn lightning base
    base = spawn();
//   base.origin = self.origin - '0 0 24' + (32*v_forward);
    base.origin    = trace_endpos;
    base.flags     = 0;
    base.owner     = self;
    base.struck_by_mjolnir = 1;
    base.think     = SUB_Remove;
    base.nextthink = time + 1;
    sound (base, CHAN_AUTO, "hipnotic/weapons/mjolslap.wav", 1, ATTN_NORM);
    sound (base, CHAN_WEAPON, "hipnotic/weapons/mjolhit.wav", 1, ATTN_NORM);
    if (self.flags & FL_CLIENT)
        makevectors (self.v_angle);
    else
        makevectors (self.angles);
    base.movedir = v_forward;

// spawn actual lightning
    loop = 4;
    while (loop > 0)
    {
        lite = spawn();
        lite.delay     = time + 0.8;
        lite.state     = 0;
        lite.owner     = self;      // Was base.
        lite.distance  = 350;
        lite.v_angle   = ang;       // Was '0 0 0';
//        lite.v_angle_y = self.angles_y;
        lite.origin    = base.origin;
        lite.think     = HIP_LightningThink;
        lite.nextthink = time;
        lite.ryuflags  = RYU_ALERT;     // PM:  Allow sight across contents.
        // PM:  Damage set here.
        lite.waitmin   = lo;    //30;
        lite.waitmax   = hi;    //80;

    // Yes, I know it may be faster to define these once at the
    // lightning base than multiple times, once on each bolt.
    // However, I wanted to eliminate any reference to the
    // lightning base when the bolts think.  Now, the base is
    // just there as a sound source.
        lite.dest      = base.origin;
        lite.movedir   = base.movedir;

        loop = loop - 1;
    }

// PM:  Spawn shockwave.
//    Tent_Explosion2 (base.origin, 244, 3);
    ShockWave (base.origin + '0 0 4', RING_BLUE, 6, "progs/s_wave.spr");

    //Hammer_Block (lite, 100);   // Added on 12/23/09.
};

// For earthquakes caused by Mjolnir slamming the ground.
void() Quake_Thor = {Quake_Self (800, 10, trace_endpos, DF_BLESSED, 2);};

// Mjolnir use for monsters!
void(vector spot) M_Slam = {
    traceline (spot, spot - '0 0 64', TRUE, self);
    if (trace_fraction < 1.0) {   // Slammed the ground, so fire off some lightning.
        Thor_Slam (10, 30);
        Quake_Thor ();
    }
};

void(vector start, vector dir) Rocket_Launch = {
    local   entity  missile;

    missile = spawn ();
    missile.master      = missile.owner     = self;
    missile.movetype    = MOVETYPE_FLYMISSILE;
    missile.solid       = SOLID_BBOX;
    missile.classname   = "rocket";     // Originally "missile".
	// set missile speed
    missile.speed       = 1000;
    missile.velocity    = dir * 1000;
    missile.angles      = vectoangles(missile.velocity);
	// set missile damage
    missile.dmg         = 120;      // Alien Quake is 210.
    missile.enemy       = world;
    missile.style       = DF_ROCKET;    // Shamblers take half damage.
	// set missile duration
    missile.touch       = T_MissileTouch;
    missile.nextthink   = time + 5;
    missile.think       = SUB_Remove;

    setall (missile, "progs/missile.mdl", '0 0 0', '0 0 0', start);

    newmis = missile;
};
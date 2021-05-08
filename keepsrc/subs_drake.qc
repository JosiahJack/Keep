float(float yaw, float dist) noclip_move;
void(float dist) noclip_goal;
void SuperDamageSound ();
float(entity ent, vector spot, float damage) HasReflection;

// Checks if a given point in space is in water.
float(vector spot) VecInWater;;

// Called by 'W_Attack' and various monster AI functions.
void() W_ShowHostile = {
    SuperDamageSound ();    // Moved from 'W_WeaponFrame' to here.
    self.show_hostile = time + 1;   // wake monsters up
    //self.attack_time = time;    // So imps know when to dodge.
};

// Based on 'SV_StepDirection'.  Use this only for big multi-hulled monsters such as dragons.
float(float yaw, float dist) QC_StepDir = {
	local vector spot;

    self.ideal_yaw = yaw;
    ChangeYaw ();

	// First, move self.  If successful, see if self is facing ideal.
	// If not, snap self back.
	spot = self.origin;
	if (walkmove (yaw, dist)) {
		if (!FacingIdeal ()) setorigin (self, spot);   // Didn't turn enough so don't move.
		return TRUE;
	}
    return FALSE;
};

// Based on 'SV_NewChaseDir'.
void(float dist) QC_NewChaseDir = {
    local   vector  delta;
    local   float   d1, d2, old, back, turn, ax, ay;

    old = floor (self.ideal_yaw / 45);  // IIRC, int chops off decimals.
    old = anglemod (old * 45);
    back = anglemod (old - 180);

    delta = self.goalentity.origin - self.origin;
    if (delta_x > 10)
        d1 = 0;
    else if (delta_x < -10)
        d1 = 180;
    else
        d1 = -1;
    if (delta_y < -10)
        d2 = 270;
    else if (delta_y > 10)
        d2 = 90;
    else
        d2 = -1;

	// Try direct route.
    if (d1 != -1) {
        if (d2 != -1) {
			if (d1 == 0) {
				if (d2 == 90) turn = 45;
				else turn = 315;
			} else {
				if (d2 == 90) turn = 135;
				else turn = 215;
			}

			if (turn != back) {
				if (QC_StepDir (turn, dist)) return;
			}
		}
    }

	// Try other directions.
    ax = fabs(delta_x);
    ay = fabs(delta_y);
    if ((random() < 0.333) || (ay > ax))
        {turn = d1; d1 = d2; d2 = turn;}

    if (d1 != -1)
        if (d1 != back)
            if (QC_StepDir (d1, dist)) return;
    if (d2 != -1)
        if (d2 != back)
            if (QC_StepDir (d2, dist)) return;

	// No direct path to goal, so pick another way.
    if (old != -1)
        if (QC_StepDir (old, dist)) return;

    local   float   end, next;
    if (random() < 0.5) {
		turn = 0; end = 315; next = 45;
	} else {
		turn = 315; end = 0; next = -45;
	}

    while (turn <= end) {
        if (turn != back) {
            if (QC_StepDir (turn, dist)) return;
		}
        turn = turn + next;
    }

    if (back != -1) {
        if (QC_StepDir (back, dist)) return;
	}

    self.ideal_yaw = old; // Can't move.
};

// Based on 'SV_CloseEnough'.
float(float dist) QC_CloseEnough = {
    if (self.goalentity.absmin_x > self.absmax_x + dist)  return FALSE;
    if (self.goalentity.absmax_x < self.absmin_x - dist)  return FALSE;
    if (self.goalentity.absmin_y > self.absmax_y + dist)  return FALSE;
    if (self.goalentity.absmax_y < self.absmin_y - dist)  return FALSE;
    if (self.goalentity.absmin_z > self.absmax_z + dist)  return FALSE;
    if (self.goalentity.absmax_z < self.absmin_z - dist)  return FALSE;
    return TRUE;
};

// This tries to emulate movetogoal for multiple bboxes acting as a unit.
// This is probably a very slow function compared to other functions.
// (However, it is not noticable at all with a modern computer.)
void(float dist) QC_MoveToGoal = {
// Commented out because only dragons use this, and they fly.
//    if (!(self.flags & FLx_NOT_FALLING))    //(FL_ONGROUND|FL_FLY|FL_SWIM)
//        return;

// If next step hits enemy, stop.
    if (self.enemy)
        if (QC_CloseEnough (dist))
            return;

// Bump around...
    if (random() < 0.333)
        QC_NewChaseDir (dist);
    else if (!QC_StepDir (self.ideal_yaw, dist))
        QC_NewChaseDir (dist);
};

//=========================================================================
//  Animation

// Sets nextthink.  'fr' is frame time delay based on 35 fps.
// Used by code that emulates stuff from the Doom or Heretic games.
void(float fr) Doom_NextThink = {self.nextthink = time + (fr / 35);};

// Checks if the given two entities' bboxes overlap.
// Similar to 'EntitiesTouching', but uses absmin/absmax.
float(entity e1, entity e2) Overlap =
{
    if (e1.absmin_x > e2.absmax_x)  return FALSE;
    if (e1.absmax_x < e2.absmin_x)  return FALSE;
    if (e1.absmin_y > e2.absmax_y)  return FALSE;
    if (e1.absmax_y < e2.absmin_y)  return FALSE;
    if (e1.absmin_z > e2.absmax_z)  return FALSE;
    if (e1.absmax_z < e2.absmin_z)  return FALSE;
    return TRUE;
};


// Like 'Overlap' above, but adds distance.
// Useful to check collisions when one entity has a clip bonus.
float(entity e1, entity e2, float dist) Overlapped =
{
    if (e1.absmin_x > e2.absmax_x + dist)  return FALSE;
    if (e1.absmax_x < e2.absmin_x - dist)  return FALSE;
    if (e1.absmin_y > e2.absmax_y + dist)  return FALSE;
    if (e1.absmax_y < e2.absmin_y - dist)  return FALSE;
    if (e1.absmin_z > e2.absmax_z + dist)  return FALSE;
    if (e1.absmax_z < e2.absmin_z - dist)  return FALSE;
    return TRUE;
};

float(vector amin, vector amax, vector bmin, vector bmax) Point_Overlap = {
    if (amin_x > bmax_x)  return FALSE;
    if (amax_x < bmin_x)  return FALSE;
    if (amin_y > bmax_y)  return FALSE;
    if (amax_y < bmin_y)  return FALSE;
    if (amin_z > bmax_z)  return FALSE;
    if (amax_z < bmin_z)  return FALSE;
    return TRUE;
};

// Checks if entity 'e' is a missile.
float(entity e) IsMissile = {
	if (!e.touch) return FALSE;
	if (e.touch == SUB_Remove) return FALSE;
	if (!AffectedByPhysics(e)) return FALSE;
    return FALSE;
};

//  This makes an entity do a think function right now.
void(entity ent, void() thinkst) SUB_Think = {
    local   entity  swap;

    swap = self;
    self = ent;
    thinkst ();
    self = swap;
};

//==========================================================================
//  Safe Message Functions

// These are for functions that display messages and are used by clients
// (players) and non-clients (monsters).  Such functions include item pickups
// and powerup countdowns.

void(entity ent, string text) Safe_stuffcmd = { if (ent.flags & FL_CLIENT) stuffcmd(ent, text); }; // The server crashes if it attempts a stuffcmd on a non-client.

// Use this to centerprint a message to everyone.
void(string text) Mass_Centerprint = {
    local   entity  pc;

    pc = find (world, classname, "player");
    while (pc) {
        centerprint_builtin(pc, text); // Confirm pc status.
        pc = find (pc, classname, "player");
    }
};

// Convenience function -- set model, size, and origin. Called by various missile functions.
void(entity e, string s, vector v1, vector v2, vector org) setall = {
    setmodel (e, s);        // May resize hullbox after this is called.
    setsize (e, v1, v2);    // Must do *after* setmodel.
    setorigin (e, org);     // Updates links immediately, so do last.
};

//==========================================================================
//  Miscellaneous Junk
// How games handled pain in Nightmare.
// Doom:  Monsters take pain normally.  However, most monsters didn't flinch reliably, and when they did, had short delays.
// Quake1:  Immune to pain for five seconds after taking damage.
// Quake2:  Immune to pain.
// Complete immunity to pain is not fun, and makes some monsters much
// more dangerous than normal.  For instance, the lowly grunt with his
// hitscan shotgun.
// Checks if monster won't flinch from pain.
float() SUB_IgnorePain = {
    if (skill >= 3) { // Nightmare or Hell.
        if (random() < 0.5) return TRUE; // Update 1/5/10:  Go 50/50 instead of 100%.
    }
    return FALSE;
};

// Checks if monster should use a faster attack.
// Used to make rhythm tactics such as shambler dancing harder.
float() SUB_QuickAttack = {
    if (skill >= 2)
        if (self.health <= (self.max_health * 0.25))
            if (random() < 0.5) return TRUE; //0.25
    return cranked; // Always fast in Cranked mode.  Otherwise, normal speed.
};

// Checks if enemy is within melee range.  def_range is defined melee range.
// Assumes self has an enemy and can damage said enemy.
float(float def_range) InMeleeRange = {
    local   float   dist;

    if (!self.enemy.modelindex)
        if (self.enemy.solid == SOLID_NOT) return FALSE; // Phased out of the level.

    dist = vlen(self.enemy.origin - self.origin);
    if (dist > def_range)
        if ( dist > ((self.maxs_x + self.enemy.maxs_x) * SQRT2 + 10) ) return FALSE;
    return TRUE;    // Within range.
};

// Variant of 'FacingIdeal' in which TRUE is returned only if difference
// between self's yaw and ideal yaw is one-half of a degree or less.
// Used by patrol related code.
float() MatchingIdeal = {
    local   float   delta;
    
    delta = rint(self.angles_y - self.ideal_yaw);
    delta = anglemod(delta);
    return !delta;
};

// From Drake
// DRAGONS /- - - -
//==========================================================================
//  TEMP GOAL (Custom addition)
//
//  'walkmove' and 'movetogoal' always causes a flying monster to drift
//  vertically toward edict.enemy by 8 per call.  In addition, if the
//  drift fails, the whole move aborts and no horizontal move is done.
//
//  Therefore, create a dummy entity that can be swapped in temporarily
//  as the enemy.
//==========================================================================
entity  temp_goal;

// Used to control movement of flying/swimming entities.
void() InitTempGoal = {
    temp_goal = spawn();
    temp_goal.classname = "goal";
};

// From Drake
//==========================================================================
//  MOVE BOX (Custom addition)
//
//  Quake checks movement with only one of three hull sizes:
//  point-size, human-size, and shambler-size.  Anything bigger than
//  shambler-size will clip walls because it is bigger than the bbox
//  used by the Quake engine for movement.
//
//  Therefore, create a dummy entity that can test movement multiple
//  times on behalf of the monster to be moved.  The move box is
//  placed at the corners of the monster, and if all move checks are
//  good, the monster will be allowed to move.
//==========================================================================
entity  move_box;

// Used by big entities to prevent clipping of walls.
void() InitMoveBox = {
    move_box = spawn();
    setsize (move_box, VEC_HULL2_MIN, VEC_HULL2_MAX);
    move_box.solid      = SOLID_NOT;
    move_box.movetype   = MOVETYPE_STEP;
    move_box.classname  = "move_box";
};

//==========================================================================
//  Noclip Movement -- Used by wraiths and other such ghostly monsters.
// This is 'walkmove' for monsters with noclip movement.  Based on
// 'SV_movestep'.  Noclip entities are capable of unrestricted 3D movement.
// NOTE:  This function *always* returns TRUE.
// This function is float type for convenience (i.e., cut-and-paste code).
//============
float(float yaw, float dist) noclip_move = {
    local   vector  move;
	local   float   delta;

    move = '0 0 0'; move_y = yaw;
    makevectors (move);
    move = v_forward * dist * 10;
    if (self.enemy) {
        delta = self.origin_z - self.enemy.origin_z;
        if (delta < 30)
            move_z = move_z + 80;
        else if (delta > 40)
            move_z = move_z - 80;
    }
    self.velocity = move;
    return TRUE;
};

// Based on 'SV_StepDirection'.
// Originally float type, but noclip movement cannot be blocked.
void(float yaw, float dist) noclip_step = {
    self.ideal_yaw = yaw;
    ChangeYaw ();

    if (FacingIdeal ())
        noclip_move (yaw, dist);
    else
        self.velocity = '0 0 0';    // Didn't turn enough so don't move.
};

// Based on 'SV_NewChaseDir'.
void(float dist) noclip_chase = {
    local   vector  delta;
    local   float   d1, d2, old, back, turn, ax, ay;

    old = floor (self.ideal_yaw / 45);  // IIRC, int chops off decimals.
    old = anglemod (old * 45);
    back = anglemod (old - 180);

    delta = self.goalentity.origin - self.origin;
    if (delta_x > 10)
        d1 = 0;
    else if (delta_x < -10)
        d1 = 180;
    else
        d1 = -1;
    if (delta_y < -10)
        d2 = 270;
    else if (delta_y > 10)
        d2 = 90;
    else
        d2 = -1;

	// Try direct route.
    if (d1 != -1)
        if (d2 != -1) {
        if (d1 == 0)
            {if (d2 == 90) turn = 45; else turn = 315;}
        else
            {if (d2 == 90) turn = 135; else turn = 215;}

        if (turn != back) {noclip_step (turn, dist); return;}
    }

	// Try other directions.
    ax = fabs(delta_x);
    ay = fabs(delta_y);
    if ((random() < 0.333) || (ay > ax))
        {turn = d1; d1 = d2; d2 = turn;}

    if (d1 != -1)
        if (d1 != back)
            {noclip_step (d1, dist); return;}
    if (d2 != -1)
        if (d2 != back)
            {noclip_step (d2, dist); return;}

// No direct path to goal, so pick another way.
    noclip_step (old, dist);
};

//============
// This is 'movetogoal' for monsters with noclip movement.
// Based on 'SV_MoveToGoal'.
//============
void(float dist) noclip_goal = {
// Noclip entities have full, unrestricted 3D movement.

	// If next step hits enemy, stop... but only if wraith is not in a wall.
	// Why?  Because the wraith can't attack effectively if pinned in the wall.
    if (self.enemy)
        if (QC_CloseEnough (dist))
            if (pointcontents (self.origin) != CONTENT_SOLID) {self.velocity = '0 0 0'; return;}

    if (random() < 0.333)
        noclip_chase (dist);
    else
        noclip_step (self.ideal_yaw, dist);
};

//=============================================================================

// Spawns a muzzleflash.  Used by phased out monsters with a modelindex
// of zero, who cannot display effects while modelindex is zero.
// Update 9/5/09:  Also by players for some weapons to get around
// Qrack's custom client muzzleflashes.
void() SUB_Flash = {
    local   entity  e;

    e = spawn();
    e.movetype  = MOVETYPE_NONE;    //MOVETYPE_NOCLIP;
    e.velocity  = '0 0 0';          //self.velocity;
    e.touch     = SUB_Null;
    e.solid     = SOLID_NOT;
    e.effects   = EF_MUZZLEFLASH;       // The point of this function.
    e.nextthink = time + 0.1;
    e.think     = SUB_Remove;
    // Non-zero invisible model.
    setall (e, "progs/null.spr", '0 0 0', '0 0 0', self.origin); //was null_256  // formerly s_null.spr after that
};

// Like findradius, except the chain includes entities with solid_not.
// Useful when you want explosions and the like to gib non-solid corpses.
entity(vector org, float radius) QC_FindRadius = {
    local   entity  e, head;
    local   vector  spot;

    head = world;
    e = nextent (world);
    while (e) {
        spot = e.origin + (e.mins + e.maxs)*0.5;
        if (vlen(org - spot) <= radius) {
            e.chain = head;
            head = e;
        }
        e = nextent (e);
    }
    return head;
};

// visible2 -- same as visible except a 'src' entity takes place of self.
float(entity targ, entity src) visible2 = {
    local   entity  os;
    local   float   found;

    os = self;
    self = src;
    found = visible (targ);
    self = os;

    return found;
};

void(float hp) SUB_FullHealth = {
    // Health can range from -32768 to 65535.
    if (self.health) hp = self.health;
    hp = floor (hp);

    if (hp > 50000)
        hp = 50000;
    else if (hp < 1)
        hp = 1;

    self.health = self.max_health = hp;
};

// Finds a random player in the game.
entity() RandomPlayer = {
    local entity e;
    local float loop;

    e = find (world, classname, "player");
    if (deathmatch || coop) {
        loop = 0;
        while (e) {
            loop = loop + 1;
            e = find (e, classname, "player");
        }
        loop = loop * random();
        loop = ceil (loop);
        e = world;
        do {
            e = find (e, classname, "player");
            loop = loop - 1;
        } while (loop > 0);
    }
    return e;
};

// DRAGONS - This sets an entity's waterlevel and watertype in a way similar to the C code.
void(entity ent) Water_Set = {
    local   vector  spot;

    spot = ent.origin;
    spot_z = spot_z + ent.mins_z + 1;
    ent.h2otype = pointcontents (spot);
    if (ent.h2otype <= CONTENT_WATER) {
        ent.h2olevel = 1;
        spot_z = ent.origin_z + (ent.mins_z + ent.maxs_z) * 0.5;
        if (pointcontents (spot) <= CONTENT_WATER) {
            ent.h2olevel = 2;
            spot_z = ent.origin_z + ent.view_ofs_z;
            if (pointcontents (spot) <= CONTENT_WATER) ent.h2olevel = 3;
        }
    }
    else ent.h2olevel = 0;
};

// Searches all entities to do pre-thinking stuff for monsters.
void() WorldScan = {
    local   entity  e;

    e = nextent (world);
    while (e) {
        // For now, just check for water stats for dragons.
        // Used by dragons to check movement.
        if (e.flags & FL_MONSTER)
            if (e.classtype == CT_MONRYU || e.classtype == CT_MONWYRM) Water_Set (e);

        e = nextent (e);
    }
};

float(entity e) IsDead = {return ((e.health <= 0) || e.deadflag);};

// Spawns a beam of particles.
void(vector start, vector end, float color1, float color2, float density, float full)  Particle_Beam = {
    local   vector  delta, next;
    local   float   points, dist;

    delta = end - start;
    dist = vlen(delta);
    if (full) {   // Unbroken, continuous trail.  Used by meteor.
        points = dist / 24;
        points = ceil(points);
        dist = -24;
    } else {   // Sparse, broken trail.  Useful for frost trails.
        if (deathmatch || coop)
            points = 2;
        else
            points = 3;
        dist = dist / points;
        dist = 0 - dist;
    }
    delta = normalize(delta);
    next = delta * dist;
    full = color1;
    while (points > 0) {
        particle (end, delta, full, density);
        end = end + next;
        points = points - 1;
        if (full == color1)
            full = color2;
        else
            full = color1;
    }
};

void(entity ent) ReflectSound;

// Used by wand.  Note: 'damage' is used only to check reflection against courage armor. 'sparks' x=color1, y=color2, z=density (0=none).
void(vector org, vector dir, float dist, float damage, entity attacker, vector sparks)  Lead_Hitscan = {
    local   entity  ignore;
    local   vector  end;
    local   float   loop;

    ignore = attacker;
    loop = 3;
    while (loop > 0) {
        end = org + dir*dist;
        traceline (org, end, FALSE, ignore);
        if (sparks_z >= 1)
            Particle_Beam (org, trace_endpos, sparks_x, sparks_y, sparks_z, TRUE);
        if (trace_fraction != 1.0) {
            if (HasReflection (trace_ent, trace_endpos, damage)) {
                ignore = trace_ent;
                org = trace_endpos;
                dir = normalize (org - ignore.origin);
                dist = dist * (1 - trace_fraction);
                ReflectSound (trace_ent);
            } else return;
        } else return;

        loop = loop - 1;
    }
    trace_fraction = 1.0; // Reflected too many times, so fake a miss.
    trace_ent = world;
};

// Sound to be played when an attack is reflected.
void(entity ent) ReflectSound = {
	// Play sound only if entity carries an artifact that provides reflection.
	// That is, don't play sound for warlocks who cast a reflection spell.
    if (ent.mirror_finished) {
        if (ent.flags & FL_CLIENT)
            if (ent.mirror_sound < time) {
                ent.mirror_sound = time + 2;    // t+1 boings too much.
                sound (ent, CHAN_ITEM, "items/reflect3.wav", 1, ATTN_NORM);
            }
    }
};

float(entity e) ImmuneToDamage = {
    if (!e.takedamage) return TRUE;
    if (e.flags & FL_GODMODE) return TRUE;
    return (e.invincible_finished);
};

// Checks if entity 'e' can grunt in pain.
float(entity e) FeelsPain = {
    if (e.health > 0)
        if (e.th_pain)
            if (e.th_pain != SUB_Null)
                if (e.pain_finished <= time)
                    if (!ImmuneToDamage (e))
                        return TRUE;

    return FALSE;
};

void(float reload) M_Reload = {
    reload = reload + time;
    if (self.attack_finished < reload) self.attack_finished = reload;
};

// Checks if 'ent' can reflect an attack from the point 'spot'.
float(entity ent, vector spot) UseCourage = {
    if (ent.perms & POW_ARMORCOURAGE) {
        local   vector  vx, vy, vz, v1, v2;

        vx = v_forward;
		vy = v_right;
		vz = v_up;
        makevectors (ent.angles);   // Yes, use model angles, not viewangles.
        v1 = normalize (spot - ent.origin);
        v2 = v_forward;
        v_forward = vx;
		v_right = vy;
		v_up = vz;
        if ((v1 * v2) > 0.3) return TRUE; // Must be infront of 'ent'.
    }
    return FALSE;
};
//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
//
// Attributions: Drake by Patrick Martin
//
//
// Distribution / Copyright / Permissions 
//
// Please do not use any of these assets in ANY COMMERCIAL PROJECT.
// and remember to give credit if you use any of these assets. Please credit
// the appropriate authors of the various content used.  Refer to the credits
// folder.
//				  
// The QC files in this MOD are based on 1.06 source files by ID Software.
// These files are released under the terms of GNU General Public License v2 or
// later. You may use the source files as a base to build your own MODs as long
// as you release them under the same license and make the source available.
// Please also give proper credit. Check http://www.gnu.org for details.
//
// Quake is a registered trademark of id Software, Inc.
//
// All of these resources may be electronically distributed only at 
// NO CHARGE to the recipient.
//
// Stats:
// Entity count: 0
// Function count: 51
//
// Implements: Drake utilty subroutines
//
// Description:
// Useful utility functions for use by Drake mod features.
//=============================================================================

float(float yaw, float dist) noclip_move;
void(float dist) noclip_goal;
float(entity ent, vector spot, float damage) HasReflection;

//----------------------------------WAND MATHS---------------------------------
// This is NOT the same as mathlib functions.  DON'T REMOVE AGAIN!
// Returns a vector where x = cosine and y = sine of 'theta'.
vector(float theta) CoSine = {
    local   vector  tx, ty, tz, vec;

    tx = v_forward;  ty = v_right;  tz = v_up;  // Save old makevectors.
    vec = '0 1 0' * theta;
    makevectors (vec);
    vec_x = v_forward_x;    // cos
    vec_y = v_forward_y;    // sin
    vec_z = 0;
    v_forward = tx;  v_right = ty;  v_up = tz;  // Restore old makevectors.
    return vec;
};

// Returns a vector where x = cosine, y = sine, and z = tangent of 'theta'.
vector(float theta) CoST = {
    local   vector  vec;
    local   float   inf, qcsin, qccos;

    vec = CoSine (theta);

// 'inf' represents infinity.  Since a finite number is needed, set 'inf'
// to the highest possible value allowed to be returned.  The value chosen
// is one million.  I could go for broke by using ten million or even
// 16777215, the latter is all 24 bits on, instead.  However doing so
// causes rollover problems if a result of 'inf' that high gets added
// or multiplied by other numbers higher than one.  One million is
// sufficiently high and allows for some wiggle room.
    inf = 1000000;
    qccos = vec_x * inf;
    qcsin = vec_y * inf;
    if (fabs(qccos) < 1)
    {   // Avoid division by zero.
        if (qccos < 0)
            qccos = -1;
        else
            qccos = 1;
    }
    vec_z = qcsin / qccos;    // tan

    return vec;
};

// Trigonometric functions. Note:  Should use builtin when available.
float(float t) SUB_cos = {local vector v;  v = CoSine(t);  return v_x;};
float(float t) SUB_sin = {local vector v;  v = CoSine(t);  return v_y;};
float(float t) SUB_tan = {local vector v;  v = CoST(t);  return v_z;};
//--------------------------------END WAND MATHS-------------------------------

// Stops the current sound that is playing on the specified channel by playing an empty sound.
void(entity ent, float chan) StopSound = {sound (ent, chan,SOUND_EMPTY, 1, ATTN_NONE);};

// Based on 'SV_StepDirection'.  Use this only for big multi-hulled monsters such as dragons.
float(float yaw, float dist) QC_StepDir = {
	local vector spot;

    self.ideal_yaw = yaw;
    ChangeYaw ();
	spot = self.origin;
	if (walkmove (yaw, dist)) { // First, move self.  If successful, see if self is facing ideal.  If not, snap self back.
		if (!FacingIdeal ()) setorigin (self, spot); // Didn't turn enough so don't move.  
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
    if ((random() < 0.333) || (ay > ax)) {turn = d1; d1 = d2; d2 = turn;}

    if (d1 != -1)
        if (d1 != back)
            if (QC_StepDir (d1, dist)) return;
    if (d2 != -1)
        if (d2 != back)
            if (QC_StepDir (d2, dist)) return;

    if ((old != -1) && QC_StepDir (old, dist)) return; // No direct path to goal, so pick another way.

    local   float   end, next;
    if (random() < 0.5) {
		turn = 0; end = 315; next = 45;
	} else {
		turn = 315; end = 0; next = -45;
	}

    while (turn <= end) {
        if ((turn != back) && QC_StepDir (turn, dist)) return;
        turn = turn + next;
    }

    if ((back != -1) && QC_StepDir (back, dist)) return;

    self.ideal_yaw = old; // Can't move.
};

// Based on 'SV_CloseEnough'.
float(float dist) QC_CloseEnough = {
	if (!self.goalentity) return FALSE;

    if (self.goalentity.absmin_x > self.absmax_x + dist)  return FALSE;
    if (self.goalentity.absmax_x < self.absmin_x - dist)  return FALSE;
    if (self.goalentity.absmin_y > self.absmax_y + dist)  return FALSE;
    if (self.goalentity.absmax_y < self.absmin_y - dist)  return FALSE;
    if (self.goalentity.absmin_z > self.absmax_z + dist)  return FALSE;
    if (self.goalentity.absmax_z < self.absmin_z - dist)  return FALSE;
    return TRUE;
};

// This tries to emulate movetogoal for multiple bboxes acting as a unit.  This is probably a very slow function compared to other functions.  However, it is not noticable at all with a modern computer.
void(float dist) QC_MoveToGoal = {
	if (self.goalentity && QC_CloseEnough (dist)) return; // If next step hits enemy, stop.

	// Bump around...
    if (random() < 0.333)
        QC_NewChaseDir (dist);
    else if (!QC_StepDir (self.ideal_yaw, dist))
        QC_NewChaseDir (dist);
};

// Checks if the given two entities' bboxes overlap.
// Similar to 'EntitiesTouching', but uses absmin/absmax.
float(entity e1, entity e2) Overlap = {
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
float(entity e1, entity e2, float dist) Overlapped = {
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
    return TRUE;
};

//  This makes an entity do a think function right now.
void(entity ent, void() thinkst) SUB_ThinkImmediate = {
    local   entity  swap;

    swap = self;
    self = ent;
    thinkst();
    self = swap;
};

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
    setmodel(e,s);        // May resize hullbox after this is called.
    setsize(e,v1,v2);    // Must do *after* setmodel.
    setorigin(e,org);     // Updates links immediately, so do last.
};

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
    return FALSE; // Normal speed.
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

entity  temp_goal;

// From Drake DRAGONS: 'walkmove' and 'movetogoal' always causes a flying monster to drift
// vertically toward edict.enemy by 8 per call.  In addition, if the drift fails, the whole move aborts and no horizontal move is done.
// Therefore, create a dummy entity that can be swapped in temporarily as the enemy.
// Used to control movement of flying/swimming entities.
void() InitTempGoal = {
    temp_goal = spawn();
    temp_goal.classname = "goal";
    dprint("\b[SETUP]\b Drake temporary dragon goal is now setup\n");
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
    dprint("\b[SETUP]\b Drake movebox is now setup for large monsters\n");
};

//  Noclip Movement -- Used by wraiths and other such ghostly monsters.
// This is 'walkmove' for monsters with noclip movement.  Based on
// 'SV_movestep'.  Noclip entities are capable of unrestricted 3D movement.
// NOTE:  This function *always* returns TRUE.
// This function is float type for convenience (i.e., cut-and-paste code).
float(float yaw, float dist) noclip_move = {
    local   vector  move;
	local   float   delta;

    move = '0 0 0'; move_y = yaw;
    makevectors (move);
    move = v_forward * dist * 10;
    if (self.enemy) {
        delta = self.origin_z - self.enemy.origin_z;
        if (delta < 30) move_z = move_z + 80;
        else if (delta > 40) move_z = move_z - 80;
    }
    self.velocity = move;
    return TRUE;
};

// Based on 'SV_StepDirection'.
// Originally float type, but noclip movement cannot be blocked.
void(float yaw, float dist) noclip_step = {
    self.ideal_yaw = yaw;
    ChangeYaw();

    if (FacingIdeal())
        noclip_move(yaw, dist);
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
    noclip_step(old, dist);
};

// This is 'movetogoal' for monsters with noclip movement.  Based on 'SV_MoveToGoal'.
void(float dist) noclip_goal = {
	// Noclip entities have full, unrestricted 3D movement.

	// If next step hits enemy, stop... but only if wraith is not in a wall.  Why?  Because the wraith can't attack effectively if pinned in the wall.
    if (self.enemy)
        if (QC_CloseEnough (dist))
            if (pointcontents (self.origin) != CONTENT_SOLID) {self.velocity = '0 0 0'; return;}

    if (random() < 0.333 && self.goalentity.classtype != CT_PATHCORNER)
        noclip_chase(dist);
    else
        noclip_step(self.ideal_yaw, dist);
};

// Like findradius, except the chain includes entities with solid_not.  Useful when you want explosions and the like to gib non-solid corpses.
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

// Spawns a beam of particles.
void(vector start, vector end, float color1, float color2, float density, float full) Particle_Beam = {
    local   vector  delta, next;
    local   float   points, dist;

    delta = end - start;
    dist = vlen(delta);
    if (full) { // Unbroken, continuous trail.  Used by meteor.
        points = dist / 24;
        points = ceil(points);
        dist = -24;
    } else { // Sparse, broken trail.  Useful for frost trails.
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
void(vector org, vector dir, float dist, float damage, entity attacker, vector sparks) Lead_Hitscan = {
    local   entity  ignore;
    local   vector  end;
    local   float   loop;

    ignore = attacker;
    loop = 3;
    while (loop > 0) {
        end = org + dir*dist;
        traceline(org, end, FALSE, ignore);
        if (sparks_z >= 1)
            Particle_Beam(org, trace_endpos, sparks_x, sparks_y, sparks_z, TRUE);
        if (trace_fraction != 1) {
            if (HasReflection(trace_ent, trace_endpos, damage)) {
                ignore = trace_ent;
                org = trace_endpos;
                dir = normalize (org - ignore.origin);
                dist = dist * (1 - trace_fraction);
                ReflectSound(trace_ent);
            } else return;
        } else return;

        loop = loop - 1;
    }
    trace_fraction = 1.0; // Reflected too many times, so fake a miss.
    trace_ent = world;
};

// Sound to be played when an attack is reflected.  Play sound only if entity carries an artifact that provides reflection.  That is, don't play sound for warlocks who cast a reflection spell.
void(entity ent) ReflectSound = {
	if (!(ent.flags & FL_CLIENT)) return;
	if (!ent.mirror_finished) return;
	if (ent.mirror_sound >= time) return;

	ent.mirror_sound = time + 2;    // t+1 boings too much.
	sound (ent, CHAN_ITEM, "drake/items/reflect3.wav", 1, ATTN_NORM);
};

float(entity e) ImmuneToDamage = { return (e.invincible_finished || !e.takedamage || (e.flags & FL_GODMODE)); };

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
	local vector vx, vy, vz, v1, v2;

    if (ent.perms & POW_ARMORCOURAGE) {
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

// Point Contents Checks.  This checks if a bbox is inside a wall or sky.  The bbox's origin and corners are checked.  If any one points is within a solid or sky, TRUE is returned.
float(vector vmin, vector vmax, vector spot) BoxInWall = {
    local   vector  p;
    local   float   content;

    // Check origin.
    p = spot;
    content = pointcontents(p);
    if (content == CONTENT_SOLID)  return TRUE;
    if (content == CONTENT_SKY)    return TRUE;

    // Check bbox faces.
    // Order:  1)-00  2)+00  3)0-0  4)0+0  5)00-  6)00+
    p_x = spot_x + vmin_x;
    content = pointcontents(p);
    if (content == CONTENT_SOLID)  return TRUE;
    if (content == CONTENT_SKY)    return TRUE;

    p_x = spot_x + vmax_x;
    content = pointcontents(p);
    if (content == CONTENT_SOLID)  return TRUE;
    if (content == CONTENT_SKY)    return TRUE;

    p = spot;
    p_y = spot_y + vmin_y;
    content = pointcontents(p);
    if (content == CONTENT_SOLID)  return TRUE;
    if (content == CONTENT_SKY)    return TRUE;

    p_y = spot_y + vmax_y;
    content = pointcontents(p);
    if (content == CONTENT_SOLID)  return TRUE;
    if (content == CONTENT_SKY)    return TRUE;

    p = spot;
    p_z = spot_z + vmin_z;
    content = pointcontents(p);
    if (content == CONTENT_SOLID)  return TRUE;
    if (content == CONTENT_SKY)    return TRUE;

    p_z = spot_z + vmax_z;
    content = pointcontents(p);
    if (content == CONTENT_SOLID)  return TRUE;
    if (content == CONTENT_SKY)    return TRUE;

    // Check bbox corners.
    // Order:  1)+++  2)-++  3)+-+  4)--+  5)++-  6)-+-  7)+--  8)---
    p_x = spot_x + vmax_x;
    p_y = spot_y + vmax_y;
    content = pointcontents(p);
    if (content == CONTENT_SOLID)  return TRUE;
    if (content == CONTENT_SKY)    return TRUE;

    p_x = spot_x + vmin_x;
    content = pointcontents(p);
    if (content == CONTENT_SOLID)  return TRUE;
    if (content == CONTENT_SKY)    return TRUE;

    p_x = spot_x + vmax_x;
    p_y = spot_y + vmin_y;
    content = pointcontents(p);
    if (content == CONTENT_SOLID)  return TRUE;
    if (content == CONTENT_SKY)    return TRUE;

    p_x = spot_x + vmin_x;
    content = pointcontents(p);
    if (content == CONTENT_SOLID)  return TRUE;
    if (content == CONTENT_SKY)    return TRUE;

    p_x = spot_x + vmax_x;
    p_y = spot_y + vmax_y;
    p_z = spot_z + vmin_z;
    content = pointcontents(p);
    if (content == CONTENT_SOLID)  return TRUE;
    if (content == CONTENT_SKY)    return TRUE;

    p_x = spot_x + vmin_x;
    content = pointcontents(p);
    if (content == CONTENT_SOLID)  return TRUE;
    if (content == CONTENT_SKY)    return TRUE;

    p_x = spot_x + vmax_x;
    p_y = spot_y + vmin_y;
    content = pointcontents(p);
    if (content == CONTENT_SOLID)  return TRUE;
    if (content == CONTENT_SKY)    return TRUE;

    p_x = spot_x + vmin_x;
    content = pointcontents(p);
    if (content == CONTENT_SOLID)  return TRUE;
    if (content == CONTENT_SKY)    return TRUE;

    return FALSE;
};

// This traces lines through a cube in space, in an attempt to find solids such as creatures occupying the space inside said cube.
// Returns TRUE if space is clear, FALSE if solid is found.
float(vector vmin, vector vmax, vector spot, entity ignore) BoxInThing = {
    local   vector  p1, p2;

	// Check inside the bbox.
    p1 = vmin;
    p2 = vmax;
    traceline (spot + p1, spot + p2, FALSE, ignore);
    if (trace_ent) return TRUE;

	// Check along the bbox boundaries, upwards and counter-clockwise.
    p2_y = vmin_y;
    traceline (spot + p1, spot + p2, FALSE, ignore);
    if (trace_ent) return TRUE;
    p1_x = vmax_x;
    p2_y = vmax_y;
    traceline (spot + p1, spot + p2, FALSE, ignore);
    if (trace_ent) return TRUE;
    p1_y = vmax_y;
    p2_x = vmin_x;
    traceline (spot + p1, spot + p2, FALSE, ignore);
    if (trace_ent) return TRUE;
    p1_x = vmin_x;
    p2_y = vmin_y;
    traceline (spot + p1, spot + p2, FALSE, ignore);
    if (trace_ent) return TRUE;

    return FALSE; // Clear
};

//  Entry Points
//  This checks if the path near the desired spot is blocked by
//  walls or monsters.
float(vector spot) EntryPoint_Trace = {
    traceline (self.enemy.origin, spot, FALSE, self.enemy);
    if (trace_fraction < 1) {
		// Unless the entity hit is the one doing the teleporting, consider the spot blocked.
        if (trace_ent != self.owner) return TRUE;
		// Teleporting ent was hit, now check through it for more entities.
        traceline (trace_endpos, spot, FALSE, self.owner);
        if (trace_fraction < 1) return TRUE;
    }
    return FALSE;
};


//  This traces lines from the beacon entity (self.enemy) to all eight bbox points around the destination.
float() EntryPoint_Path = {
    local   vector  spot, p;

    // Check origin.
    spot = self.origin;
    p = spot;
    if (EntryPoint_Trace (p)) return TRUE;

    // Check bbox corners.
    // Order:  1)+++  2)-++  3)+-+  4)--+  5)++-  6)-+-  7)+--  8)---
    p_x = spot_x + self.maxs_x;
    p_y = spot_y + self.maxs_y;
    p_z = spot_z + self.maxs_z;
    if (EntryPoint_Trace (p)) return TRUE;

    p_x = spot_x + self.mins_x;
    if (EntryPoint_Trace (p)) return TRUE;

    p_x = spot_x + self.maxs_x;
    p_y = spot_y + self.mins_y;
    if (EntryPoint_Trace (p)) return TRUE;

    p_x = spot_x + self.mins_x;
    if (EntryPoint_Trace (p)) return TRUE;

    p_x = spot_x + self.maxs_x;
    p_y = spot_y + self.maxs_y;
    p_z = spot_z + self.mins_z;
    if (EntryPoint_Trace (p)) return TRUE;

    p_x = spot_x + self.mins_x;
    if (EntryPoint_Trace (p)) return TRUE;

    p_x = spot_x + self.maxs_x;
    p_y = spot_y + self.mins_y;
    if (EntryPoint_Trace (p)) return TRUE;

    p_x = spot_x + self.mins_x;
    if (EntryPoint_Trace (p)) return TRUE;

    return FALSE;
};

//  Checks if a given point is clear for occupation.
float(vector spot) EntryPoint_Test = {
	// Move the dummy to a test point.
    setorigin (self, spot);
    self.flags = self.flags - (self.flags & FL_ONGROUND);

	// Test the point.
    if (self.flags & (FL_FLY | FL_SWIM)) {
        if (BoxInWall (self.mins, self.maxs, spot)) return FALSE; // Note:  These only detect walls, not creatures.

        if (self.flags & FL_SWIM)
            if (pointcontents(spot) > CONTENT_WATER) return FALSE;   // Fish must be in the water.

        // The past two checks look for walls, not creatures.  This check will hit both walls and creature.
        if (BoxInThing (self.mins, self.maxs, spot, self.owner)) return FALSE;
    } else {
        droptofloor ();
        if (!walkmove (0,0)) return FALSE;
    }

	// Found a viable entry point, so now check if a clear path exists between
	// it and its beacon.  (If none exists, then skip this check.)
    if (self.enemy)
        if (EntryPoint_Path ()) return FALSE;

    return TRUE; // Got one!
};

// Selects one of twelve points equidistant from the beacon.  Used for summoning a monster to its master.
float() EntryPoint_Circle = {
    local   float   cos0, cos30, cos60;
    local   vector  spot, org;

    if (!self.enemy) return FALSE; // No beacon.

	// Spawn at one of twelve points around the master.
    org = self.enemy.origin + '0 0 32';
    makevectors (self.enemy.angles);

    // e.g., Human with Draco: 80 + (16 + 32) * 1.25 = 140.
    cos0  = 80 + (self.enemy.maxs_x + self.maxs_x) * 1.25;
    cos30 = cos0 * 0.866;
    cos60 = cos0 * 0.5;

	// First attempt:  12:00.
	spot = org + (v_forward * cos0);
	if (EntryPoint_Test (spot)) return TRUE;
	// Second attempt:  1:00.
	spot = org + (v_forward * cos30) + (v_right * cos60);
	if (EntryPoint_Test (spot)) return TRUE;
	// Third attempt:  11:00.
	spot = org + (v_forward * cos30) - (v_right * cos60);
	if (EntryPoint_Test (spot)) return TRUE;
	// Fourth attempt:  2:00.
	spot = org + (v_forward * cos60) + (v_right * cos30);
	if (EntryPoint_Test (spot)) return TRUE;
	// Fifth attempt:  10:00.
	spot = org + (v_forward * cos60) - (v_right * cos30);
	if (EntryPoint_Test (spot)) return TRUE;
	// Sixth attempt:  3:00.
	spot = org + (v_right * cos0);
	if (EntryPoint_Test (spot)) return TRUE;
	// Seventh attempt:  9:00.
	spot = org - (v_right * cos0);
	if (EntryPoint_Test (spot)) return TRUE;
	// Eigth attempt:  4:00.
	spot = org - (v_forward * cos60) + (v_right * cos30);
	if (EntryPoint_Test (spot)) return TRUE;
	// Ninth attempt:  8:00.
	spot = org - (v_forward * cos60) - (v_right * cos30);
	if (EntryPoint_Test (spot)) return TRUE;
	// Tenth attempt:  5:00.
	spot = org - (v_forward * cos30) + (v_right * cos60);
	if (EntryPoint_Test (spot)) return TRUE;
	// Eleventh attempt:  7:00.
	spot = org - (v_forward * cos30) - (v_right * cos60);
	if (EntryPoint_Test (spot)) return TRUE;
	// Twelth and final attempt:  6:00.
	spot = org - (v_forward * cos0);
	if (EntryPoint_Test (spot)) return TRUE;

    return FALSE; // Failed.
};

//  Selects a random point between a range set by given parameters.  Useful as defense for mages, and as a trick move for bosses.
//  Arguments:  r = random distance, m = minimum distance.  (max = r+m).
float(float r, float m, vector ofs) EntryPoint_Randomize_Ex = {
    local   vector  ang;
    local   vector  org;    // Original point.
    local   vector  spot;   // Potential teleport destination.
    local   float   dist;   // Distance from 'org' to new 'spot'.
    local   float   three;  // Boolean: 0 = ground only, 1 = three dimension.
    local   float   loop;   // Number of attempts before giving up.

    loop = 100;
    ang = '0 0 0';
    three = self.flags & (FL_FLY|FL_SWIM);  // Three dimensional
    org = self.origin;
    if (!three) org_z = org_z + 56;     // Now +56, was +32.  Go up slightly in case of sloping ground.
    while (loop > 0) {
        dist = random() * r + m;
        if (three) ang_x = random() * (0 - ofs_x);     //random() * 360;
        if (ofs_z) {
            ang_y = random() * ofs_y;
            if (ofs_z > 0)
                ang_y = 0 - ang_y;
        } else
            ang_y = crandom() * ofs_y;
        ang_y = anglemod (self.angles_y + ang_y);   //random() * 360;
        makevectors (ang);
        spot = org + (v_forward * dist);
        if (EntryPoint_Test (spot))
            return TRUE;

        loop = loop - 1;
    }
    return FALSE;
};

float(float r, float m) EntryPoint_Randomize = {return EntryPoint_Randomize_Ex (r, m, VEC_360);};

//  Selects a random point between close and medium range.
float() EntryPoint_Random = {return EntryPoint_Randomize_Ex (400, 100, VEC_360);};

//  Selects a random point between mid-close and long range.
float() EntryPoint_LongRandom = {return EntryPoint_Randomize_Ex (600, 250, VEC_360);};

float() EntryPoint_Fan = {return EntryPoint_Randomize_Ex (100, 60, '90 60 0');};

// Selects and tests a single given point.
float() EntryPoint_One = {return EntryPoint_Test (self.origin);};

//  This spawns a dummy entity to test points its owner may use as a
//  spawn point or teleport destination.  An entity is needed to check
//  if such points are occupied by solids, and it is better to use an
//  invisible, intangible dummy than the monster who is to be moved.
//
// 'ent' = Entity to be moved.
// 'targ' = Beacon entity, must have clear path to beacon for success.
//           If using summon function, appear somewhere around the beacon.
// 'spot' = Where the entity wants to go.
// 'func' = Function to use when finding a spot.

// Make a dummy entity to test the entry points so the entity to be teleported need not be moved around.
float(entity ent, entity targ, vector spot, float() func) EntryPoint_Spawn = {

    local   entity  test;
    local   entity  os;         // os = old self
    local   float   success;

    test = spawn();
    test.angles    = ent.angles;
    test.movetype  = MOVETYPE_STEP;
    test.velocity  = '0 0 0';
    test.touch     = SUB_Null;
    test.solid     = SOLID_NOT;
    test.owner     = ent;       // Lets dummy pass through entity at will.
    test.enemy     = targ;      // Beacon entity.
    test.flags     = ent.flags & (FL_FLY | FL_SWIM);
    setmodel (test, "");   // invisible
    setsize (test, ent.mins, ent.maxs);
    setorigin (test, spot);

	// We are ready to find an entry point.
	os = self;
	self = test;
	success = func();
	self = os;

	// Done testing, so use any found entry point and remove the dummy.
    if (success) setorigin (ent, test.origin);
    remove (test);

    return success; // Our work here is done.
};

// Speciality Updates
// Like EntryPoint_Test, but ignores creatures and beacon LoS.
float() EntryPoint_BossCube = {
	// Move the dummy to a test point.
	setorigin (self, self.origin);
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	droptofloor ();     // Do this even if creature can fly or swim.

	// Test the point.
    // Note:  These only detect walls, not creatures.
    if (BoxInWall (self.mins, self.maxs, self.origin)) return FALSE;
    if (self.flags & FL_SWIM)
        if (pointcontents(self.origin) > CONTENT_WATER) return FALSE;   // Fish must be in the water.

    // Don't check for creatures because of telefragging.

	return TRUE; // Got one!
};

// Adds 'fadd' to frame 'fr'.  Used to animate monsters.
void(float fr, float fadd, float fmax) WalkFrame_Add = {
    if ((self.walkframe < 0) || (self.walkframe > fmax)) self.walkframe = 0;
    self.frame = fr + self.walkframe;
    self.walkframe = self.walkframe + fadd;
};

// Set contents of monster's purse.
void(float loop, float drop_chance, float gem_chance) monster_purse = {
    self.purse = '0 0 0';
	self.purse_z = encode(loop,drop_chance * 100,gem_chance * 100);
    while (loop > 0) {
        if (random() < drop_chance) {
            if (random() < gem_chance)
                self.purse_y = self.purse_y + 1;    // Gem
            else
                self.purse_x = self.purse_x + 1;    // Coin
        }
        loop = loop - 1;
    }
};

void(void() thinkst) M_Break = {
    if (self.enemy.health > 0)
        if (self.enemy.solid > SOLID_TRIGGER)
            if (visible (self.enemy))
                if (enemy_range < RANGE_FAR) return;

    if (!((self.health <= 0) || self.deadflag)) self.think = thinkst; // Break attack sequence.
};

// Checks if the sky is above a given point.
float(vector org) UpIsSky = { // [FUNCTION]
    local float pc;

    traceline(org, org + '0 0 8192', TRUE, world); // Sees through monsters.
    pc = pointcontents(trace_endpos);
	if (trace_ent.classtype == CT_TRIGVOID) return TRUE; // True if we hit a trigger_void as well.
    if (trace_fraction < 1) return (pc == CONTENT_SKY);
    return ((pc == CONTENT_EMPTY) || (pc == CONTENT_SKY));
};

float(entity e) IsGhost = {return ((e.solid==SOLID_TRIGGER) && (e.movetype==MOVETYPE_NOCLIP));};
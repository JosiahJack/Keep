//==========================================================================
//  Reflector Shield

//-------------------------------------
// Field     | Purpose
//-----------+------------
// master    | Missile's true owner
// owner     | Entity to ignore/pass through
// speed     | Missile base speed.
// movedir   | Missile's current heading.
// style     | Damage flags.
// dmg       | Damage on impact.
// cnt       | Homing:  Acceleration.  Sidewinder:  Vertical angle offset.
// enemy     | Homing missiles:  Target to seek.
// dest      | Used by laser and spike for rebounding and touchblood.
// think1    | Custom explosion function to call.
// delay     | Total duration
// wait      | Intervals:  Proxy=motion detection, Fire=burn
// state     | Proxy:  Armed status.  Homing Rockets:  Follow or intercept.
// waitmin   | Laser color #1
// waitmax   | Laser color #2
// count     | # of hits.  Used for lasers and smartballs.
//           |  Also as arrow type for akarrows.
// oldorigin | origin at previous frame.
// worldtype | TE effects for spikes.  Monster summon type for nightshade.
//           |  (Update 9/4/09:  Damage algorithm for rockets.)
// movetarget| Proxy:  Who the bomb is stuck to.
// pos1      | Fireballs:  Rotate model by x.
// pos2      | Sidewinder:  Target point if no enemy to target.
// fallen    | Buriza:  Used as second owner to ignore.
//-------------------------------------

// Checks if entity has reflection from shield or armor.
// Return values: 0 = none, 1 = shield, 2 = courage armor.
float(entity ent, vector spot, float damage) HasReflection = {
	// Check for artifact because it toggles particle field off and on during
	// the three second warning.
    if (ent.mirror_finished) return TRUE;
	// Non-artifact sources of reflection require an active particle field.
    if (ent.effects & EF_BRIGHTFIELD) return TRUE;
	// Update 7/16/09:  Shub shields
    if (ent.xfl & XFL_SHIELDS)
        if (ent.classname == "monster_oldone") return TRUE;

	// Update:  Entity can reflect frontal attacks if wearing courage armor.
    if (ent.armorvalue >= damage)
    if (UseCourage (ent, spot)) {
        if (damage)     // Mess with hud only if there is damage.
        if (ent.takedamage)
        if ( !((ent.flags & FL_GODMODE) || ent.invincible_finished) ) { // Degrade armor only if vulnerable to damage.
            if (ent.armorvalue > damage) {
                ent.armorvalue = ent.armorvalue - damage;
				// DISABLED -- Armor flash.
               // if (ent.flags & FL_CLIENT)
                   // if (damage > 0) ent.dmg_save = ent.dmg_save + damage;
            } else {   // Strip armor.
                // Armor_Remove (ent);
            }
        }
        return 2;   // In case we need a non-zero value other than TRUE.
    }

    return FALSE; // No reflection.
};

void(entity ent, entity shot) ReflectMissile = {
    if (shot.movetype == MOVETYPE_NONE)
        return;     // Can't move.

// Reset fields that may affect its movement.
    if (!shot.speed)
        shot.speed = vlen(shot.velocity);

    if (HasReflection (ent, shot.origin, 0) == TRUE)
        shot.movedir = normalize (shot.origin - ent.origin);
    else    // Assume courage.
    {   local   vector  org;

        if (self.movedir == '0 0 0')
        {
            org   = ent.origin;
            org_z = ent.absmin_z + ent.size_z * 0.7;
            shot.movedir = normalize (shot.origin - org);
        }
        else
        {
            org = vectoangles (self.movedir);
            org_y = vectoyaw (shot.origin - ent.origin);
            makevectors (org);
            self.movedir = v_forward;
        }
    }
//    shot.movedir = normalize (shot.origin - ent.origin);
    shot.velocity = shot.movedir * shot.speed;
    shot.dest = shot.velocity;      // For lasers and spikes.
    shot.angles = vectoangles(shot.movedir);
    if (shot.pos1_x)    // For fireballs.
        shot.angles_x = shot.angles_x + shot.pos1_x;
    shot.oldorigin = shot.origin;   // For particle trails.
// Unstick missile if engine thinks it is on the ground.
    shot.flags = shot.flags - (shot.flags & FL_ONGROUND);
    shot.groundentity = world;
// Special:  If remote controlled mirv, sever link.
    if (shot.master)
        if (shot.master.mirv1 == shot)
            shot.master.mirv1 = world;
// Change homing missiles' target.
    if (shot.enemy == ent)
    {
        if (shot.enemy == shot.master)
        {
            shot.enemy = shot.oldenemy; // Send to previous reflector.
            shot.oldenemy = world;      // Void any backup target.
        }
        else
        {
            shot.oldenemy = shot.enemy; // Remember who reflected missile.
            shot.enemy = shot.master;   // Send back to owner.
        }
    }
// Set owner to reflector so missile may pass through reflector.
    if (shot.owner != ent)      //== shot.master)
        shot.owner = ent;
// Buriza:  Set second owner.
    if (shot.fallen != ent)
        shot.fallen = ent;

// Check for reflection sound.
    ReflectSound (ent);
};

// Delayed thinking for reflected missiles that just touched something.
void() ReflectThink =
{
    ReflectMissile (self.owner, self);
// Restore original thinking.
    self.nextthink = self.tracer_time;
    self.think = self.th_win;
};

//- - - - - - - - -
// Checks if a missile should be reflected when it touches something.
// This should only be called by a missile's touch function.
//
// 'self' is assumed to be the missile to be reflected.
// 'other' is assumed to be the target struck by the missile.
//- - - - - - - - -
float(float damage) Reflected_Damage = {
    local float yes;

    if (self) {
        yes = HasReflection (other, self.origin, damage);
        if (yes) {
			// It is possible for missile to get sandwiched between multiple
			// targets with reflection, before the missile redirects from the
			// first contact.  If that happens, pass until the missile can move.
			// That way, the missile will not get stuck.
            if (self.think != ReflectThink) {
				// We cannot reflect the missile now because the engine hasn't
				// run all of the physics code yet.  Delay reflection until the
				// next tic.
                self.owner = other;
				// Save normal thinking.
                self.tracer_time = self.nextthink;
                self.th_win = self.think;
				// Set thinking to reflection code ASAP.
                self.nextthink = 0.01;
                self.think = ReflectThink;
            }
            return yes;
        }
    }
	// Missile was not reflected, so proceed as normal.
    return FALSE;
};

float() Reflected = {return Reflected_Damage (self.dmg);};

// Turns on a particle field for 'ent' then repels missiles within the field.
// Note:  EF_BRIGHTFIELD has a radius of 80, centered on entity's origin.
void(entity ent) ReflectorShield = {
    if (!ent) return;

    local   entity  shot;

    ent.effects = ent.effects | EF_BRIGHTFIELD;
    shot = findradius (ent.origin, 80);
    while (shot)
    {   // Deflect all missiles not owned by ent.
        if (IsMissile (shot))
        {   // Missiles owned by ent are those launched or reflected recently.
            if (shot.owner != ent)
                if (shot.think != ReflectThink)
                    // Next check ignores boomerangs returning to owner.
                    if ( !((shot.classname == "Mjolnir") && (shot.master == ent)) )
                    {
                        traceline (shot.origin, ent.origin, TRUE, shot);
                        if (trace_fraction == 1.0)
                            ReflectMissile (ent, shot);
                    }
        }
        shot = shot.chain;
    }
};


//==========================================================================
//  Parrying (Used by Mjolnir)

//- - - - - - - - -
// Block_Missile -- Variation of 'ReflectMissile'.
// Redirects a missile away from a point.
// Unlike ReflectMissile, does NOT interfere with MIRVs or homing missiles.
//
// Entity who is reflecting the shot is assumed to be 'self'.
//
// shot:  Missile to be redirected.
// org:  Reflector source point.
//- - - - - - - - -
void(entity shot, vector org) Block_Missile = {
    local   entity  ent;

    ent = self;

    if (shot.movetype == MOVETYPE_NONE) return;     // Can't move.

// Reset fields that may affect its movement.
    if (!shot.speed)
        shot.speed = vlen(shot.velocity);
    shot.movedir = normalize (shot.origin - org);   //(ent.origin + '0 0 16'));   //ent.view_ofs));
    shot.velocity = shot.movedir * shot.speed;
//    if ((shot.movetype == MOVETYPE_BOUNCE) || (shot.movetype == MOVETYPE_TOSS))
//        shot.velocity_z = shot.velocity_z + 200;
    shot.dest = shot.velocity;      // For lasers and spikes.
    shot.angles = vectoangles(shot.movedir);
    if (shot.pos1_x)    // For fireballs.
        shot.angles_x = shot.angles_x + shot.pos1_x;
    shot.oldorigin = shot.origin;   // For particle trails.
// Unstick missile if engine thinks it is on the ground.
    shot.flags = shot.flags - (shot.flags & FL_ONGROUND);
    shot.groundentity = world;
//// Special:  If remote controlled mirv, sever link.
//    if (shot.master)
//        if (shot.master.mirv1 == shot)
//            shot.master.mirv1 = world;
// Set owner to reflector so missile may pass through reflector.
    if (shot.owner == shot.master)
        shot.owner = ent;
    if (shot.enemy == ent)
        shot.owner = world;     // Let homing missile hit target.

// Reflection sound will be played later.
};
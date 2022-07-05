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
// Entity count: 1
// Function count: 6
//
// Implements: Earthquake System for monsters and effects
//
// Description:
// Based on Hexen2 earthquake code, modified to behave more like Quoth's.
// Works for me.  Hexen2 quakes inflicted the least damage and knockback at the
// center of a quake, and the most at the edge.  In Quoth, this is the reverse.
// Changed to behave more like Quoth's quake behavior.  More damage at center
// like in Quoth, reverse of Hexen2.
//
// Damage emulates Quoth's earthquake behavior for hurt frame 1, 3, 5, 7, and 9
// of the whole quake.  Now using Drake's method of frame 1, 3, 6, 10, and 15.
//
// The blessed may avoid damage and chaos.  Attacker and its allies are immune.
// Swimming in the water won't save thee.  Everyone who is grounded will have
// their view shaken.  After all, if the very earth shakes, the view will shake
// even if the viewer can remain perfectly still.
//
// Hexen2 had 20% chance per think of inflicting damage.  In Quoth, quake
// caused damage up to five times in first sec.
//=============================================================================

// Checks if entity can be damaged by an earthquake.
float(entity ent) QuakeHurts = { // [FUNCTION]
	if (ent.takedamage == DAMAGE_NO) return FALSE;
	if (!(ent.flags & FL_ONGROUND)) return FALSE; // Doesn't matter if we can fly if we are on the ground.
	if (ent.movetype == MOVETYPE_NOCLIP) return FALSE; // Ghosts are immune to damage and movement.
	if (ent.movetype == MOVETYPE_FLYMISSILE) return FALSE;
	if (ent.wing_finished) return FALSE; // Boots provide stability.
    if (Invisible(ent)) return FALSE; // Makes the ring of shadows quite useful.  Arguably quake damage is magical anyhow and from the source's sight.
    if (!Align_Opposing(self,ent)) return FALSE;
	return TRUE;
};

void() Quake_Think = [0, Quake_Think] { // [FUNCTION]
    local entity head;
    local vector org, dir;
    local float radius, magnitude, dist, frac, up, upper, damage, dizzy; // Richter for magnitude  

    if (self.delay <= time) { sound (self, CHAN_VOICE, "hipnotic/misc/quakeend.wav", 1, ATTN_NORM); remove (self); return; }

    self.count = self.count + 1;
    frac = (self.delay - time) / self.wait; // Fraction, from 0 to 1.
    radius = self.distance;
    magnitude = self.dmg;
	if (radius < 1) radius = 15000; // Pick up everyone!
    head = findradius(self.origin, radius);
    while (head) {
        if (head.flags & FLx_CREATURE) {
            if (head.mass <= MASS_HEAVY) {
                dizzy = TRUE;
                if ((head.flags & FL_MONSTER) && !head.enemy) dizzy = FALSE; // Don't drift -- take damage only.
                org = Midpoint(head);
                if (radius)	dist = 1 - (vlen(self.origin - org) / radius);
                else		dist = 1;

                upper = 80; // One-tenth of normal gravity.
                if (head.flags & FLx_CREATURE) {
                    if (head.flags & FL_CLIENT) { // Shake view.  Only players can see.
                        upper = 100;
                        head.punchangle_x = crandom() * self.mangle_x;
                        head.punchangle_y = crandom() * self.mangle_y;
                        head.punchangle_z = crandom() * self.mangle_z;
                    } else if (head.flags & FL_MONSTER) {
                        if (dizzy && !((head.health <= 0) || head.deadflag)) {
                            head.angles_y = head.angles_y + (crandom() * 20); // Mess with their yaw to feign disorientation.
                            head.angles_y = anglemod(head.angles_y); // Unlike Hexen2, don't bother with pitch and roll.
                        }
                    }
                }

                if ((head != self.owner || !self.style) && QuakeHurts(head)) { // Safe or blessed.
                    damage = magnitude * dist;
                    if (damage || (head.flags & FL_MONSTER)) { // 5/7/2009:  Call damage function only if there's damage or target is a monster.  Monsters may flinch from zero damage, and flinching works well for disorientation effects.
                        if (self.count == 1 || self.count == 3 || self.count == 6
                            || self.count == 10 || self.count == 15) {
                            T_Damage(head,self,self.owner,damage,DAMARMOR);
                        }
                    }

                    // Add movement.
                    // Note:  Too much trouble discriminating which objects can be
                    // moved without problems, so move only creatures for now.
                    if (head.flags & FLx_CREATURE) {
                        if (head.flags & FL_ONGROUND) {
                            // Bump target up a bit.  We need this for players at least for impaired movement.  Monsters will thump a lot, if z is too high, and that sucks.  Hmmm...
                            up = ((random() * 100) + 25) * dist;
                            if (up > upper) up = upper;
                            head.velocity_z = head.velocity_z + up;
                        }
                        dir = '0 1 0' * (random() * 360); // Random drifting.
                        makevectors(dir);
                        dir = v_forward;
                        
                        // vel*25 from Hexen2 is too much, so use *8.
                        if (dizzy) head.velocity = head.velocity + (dir * (damage * 8 * random())); // Monster does not drift if not fighting.
                        head.flags = head.flags - (head.flags & FL_ONGROUND);
                    }
                }
            }
        }
        head = head.chain;
    }
};

// Note:  Quake can ping for 'damage' up to five times if it lasts long enough, at least 1.5 seconds required for 5 'pings'.
void(entity attacker, float radius, float damage, vector spot, float safeorblessed, float secs, vector tilt) Quake_Spawn = { // [FUNCTION]
    local   entity  quaker;
    local   float   attn;

    radius = fabs(radius);
    if (radius) {
        attn = 1000 / (radius + 200);
        if (attn > 4) attn = 4;   // Max allowed by engine.
    } else {   
        attn = ATTN_NONE; // Quake hits whole level.
	}

	// Spawn quake entity.
    quaker = spawn();
    quaker.movetype = MOVETYPE_NONE;
    quaker.velocity = '0 0 0';
    quaker.touch    = SUB_Null;
    quaker.solid    = SOLID_NOT;
    quaker.classname = quaker.deathtype = "quake";
    quaker.owner    = attacker;
    quaker.wait     = secs;
    quaker.delay    = time + quaker.wait;
    quaker.count    = 0; // Make sure it begins at zero; mostly for human's sake since qc sets it to 0 by default anyways.
    quaker.style    = safeorblessed;
	if (self == attacker) quaker.style = TRUE; // Inflictor is 'self'.  If inflictor is attacker, don't harm him.
    quaker.distance = radius;
    quaker.dmg      = damage; // Magnitude
    quaker.mangle   = tilt;
    quaker.nextthink= 0.01;
    quaker.think    = Quake_Think;
    setsize(quaker,'0 0 0','0 0 0');        
    setorigin(quaker,spot);
    sound(quaker,CHAN_VOICE,"hipnotic/misc/quake.wav",1,attn); // Update 4/9/2009:  Variable attenuation instead of ATTN_NORM.
};

void(entity who) tq_go = { // [FUNCTION]
    if (who.health <= 0 || !(who.flags & FL_CLIENT)) return;

	Quake_Spawn(self,0,0,VEC_ORIGIN,FALSE,self.wait,VEC_QUAKE); // Use Drake's quake code instead.
    SUB_UseTargets();
	SUB_Remove();
};

void() tq_use = { tq_go(activator); }; // [FUNCTION]
void() tq_touch = { tq_go(other); }; // [FUNCTION]

// Update 6/4/09:  Imported Zerstorer's earthquake trigger entity for use in Tronyn's map, toum.bsp.
// Starts an earthquake.  Players view will shake for amount of time you put in "wait".  Place the richter scale of the quake in the "dmg" field.
// It will also trigger all targets like a 'trigger_once'.
void() trigger_quake = { // [ENTITY]
    if (deathmatch) { // This will use then remove the quake.
        self.think = SUB_Remove;
		self.delay = 0.2;
		SUB_UseTargets();
        self.nextthink = time + self.delay;
        return;
    }
    InitTrigger();
	if (self.wait <= 0) self.wait = 3;
    self.use = tq_use;
    if (!(self.spawnflags & 1)) self.touch = tq_touch; // PM:  Added notouch flag.
};
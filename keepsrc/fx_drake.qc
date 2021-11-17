//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by W. Josiah Jack, aka Qmaster
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
// Entity count: 2
// Function count: 35
//
// Implements: Special Effects from the Drake Mod (lots of stuff!)
//
// Description:
// Various visual effects such as explosions, blood, lightning, etc.
//=============================================================================

void() T_MissileTouch;
void(entity ent, float chan) StopSound;
void() IceMine_Explode;

// Light Zero
// Custom addition by PM.  Used by storm code, most of it in 'drake_cool.qc'.
// Since much of the level is lit up using lightstyle 0, changing it
// will make much of the level brighter or darker.  Useful for lightning storm effects.
void() LightZero_Update = { // [FUNCTION]
    lightzero_level = floor(lightzero_level);
    if (lightzero_level < 1) lightstyle(LIGHT_ZERO, "a");
	else if (lightzero_level == 1) lightstyle(LIGHT_ZERO, "b");
	else if (lightzero_level == 2) lightstyle(LIGHT_ZERO, "c");
	else if (lightzero_level == 3) lightstyle(LIGHT_ZERO, "d");
	else if (lightzero_level == 4) lightstyle(LIGHT_ZERO, "e");
    else if (lightzero_level == 5) lightstyle(LIGHT_ZERO, "f");
	else if (lightzero_level == 6) lightstyle(LIGHT_ZERO, "g");
	else if (lightzero_level == 7) lightstyle(LIGHT_ZERO, "h");
	else if (lightzero_level == 8) lightstyle(LIGHT_ZERO, "i");
	else if (lightzero_level == 9) lightstyle(LIGHT_ZERO, "j");
    else if (lightzero_level == 10) lightstyle(LIGHT_ZERO, "k");
	else if (lightzero_level == 11) lightstyle(LIGHT_ZERO, "l");
	else if (lightzero_level == 12) lightstyle(LIGHT_ZERO, "m");
	else if (lightzero_level == 13) lightstyle(LIGHT_ZERO, "n");
	else if (lightzero_level == 14) lightstyle(LIGHT_ZERO, "o"); 
    else if (lightzero_level == 15) lightstyle(LIGHT_ZERO, "p");
	else if (lightzero_level == 16) lightstyle(LIGHT_ZERO, "q");
	else if (lightzero_level == 17) lightstyle(LIGHT_ZERO, "r");
	else if (lightzero_level == 18) lightstyle(LIGHT_ZERO, "s");
	else if (lightzero_level == 19) lightstyle(LIGHT_ZERO, "t");
    else if (lightzero_level == 20) lightstyle(LIGHT_ZERO, "u");
	else if (lightzero_level == 21) lightstyle(LIGHT_ZERO, "v");
	else if (lightzero_level == 22) lightstyle(LIGHT_ZERO, "w");
	else if (lightzero_level == 23) lightstyle(LIGHT_ZERO, "x");
	else if (lightzero_level == 24) lightstyle(LIGHT_ZERO, "y");
	else if (lightzero_level == 25) lightstyle(LIGHT_ZERO, "z");
};

void() LightZero_Go = { // [FUNCTION]
    if (!lightzero_finished) return;

    if (lightzero_finished > time) {
        lightzero_level = lightzero_level + lightzero_rate;
        if (lightzero_level < LIGHTZERO_MIN) lightzero_level = LIGHTZERO_MIN;
        else if (lightzero_level > LIGHTZERO_MAX) lightzero_level = LIGHTZERO_MAX;
    } else { // Restore normal lighting.
        if (lightzero_level > LIGHTZERO_NORMAL) { // Was brighter.
            lightzero_level = lightzero_level - 4;
            if (lightzero_level < LIGHTZERO_NORMAL) lightzero_level = LIGHTZERO_NORMAL;
        } else if (lightzero_level < LIGHTZERO_NORMAL) { // Was darker.
            lightzero_level = lightzero_level + 2;
            if (lightzero_level > LIGHTZERO_NORMAL) lightzero_level = LIGHTZERO_NORMAL;
        }
        if (lightzero_level == LIGHTZERO_NORMAL) lightzero_finished = 0; // End it!
    }
    LightZero_Update();
};

void(float lite, float add, float rate) LightZero_Set = { // [FUNCTION]
    lightzero_rate = rate;
    if (lite == -1) {
        if (lightzero_finished)
            lite = lightzero_level;
        else
            lite = LIGHTZERO_NORMAL;
    }
    add = time + add;
    if (lightzero_finished < add) lightzero_finished = add;
    if (lightzero_level != lite) {
        lightzero_level = lite;
        LightZero_Update();
    }
};

// "Storm" Lightning Strike  (a.k.a. Airstrike).  This creates a blank entity that will zap targets in the water within a radius for damage.
void(entity attacker, vector spot, float damage, entity ignore) Zapper_Spawn = { // [FUNCTION]
    local   entity  zap;

    zap = spawn();
    zap.movetype  = MOVETYPE_NONE;
    zap.velocity  = '0 0 0';
    zap.touch     = SUB_Null;
    zap.solid     = SOLID_NOT;
    zap.owner     = world;
    setall (zap, "", '0 0 0', '0 0 0', spot);   // invisible
    Rocket_Explosion2 (zap.origin, 244, 3);
    T_RadiusDamage (zap, attacker, damage, ignore, DAMAGEALL);
    remove (zap);
};

// This creates a lightning bolt that flashes down from the sky and strikes with explosive impact.
void(entity attacker, vector spot, float damage) Thunderstrike_Ex = { // [FUNCTION]
	local float points, den, blud;
    local vector air, start, end;
    local entity targ, ignore, zap;

    air = '0 0 2048';   // Max limit of lightning draw length possible.
    traceline (spot, spot + air, TRUE, world);
    start = trace_endpos - '0 0 2';

    // WARNING:  Using 'world' as last traceline argument does not work.
    // Trying to do so causes the trace to ignore all, even if the third argument is FALSE.
    // Create dummy entity to serve as ignore for the traceline. That way, the lightning strike can hit even the attacker.
    zap = spawn();
    zap.movetype  = MOVETYPE_NONE;
    zap.velocity  = '0 0 0';
    zap.touch     = SUB_Null;
    zap.solid     = SOLID_NOT;
    zap.owner     = world;
    setall (zap, "", '0 0 0', '0 0 0', spot);   // invisible   
    traceline (start, spot - air, FALSE, zap); // Execute trace.
    targ = trace_ent;
    // Don't remove zap now, we need it later for thunder effects.
    // Proceed with traceline results.
    if (targ.takedamage) { // Direct hit.
        end = Midpoint (targ);
        ignore = targ;
        traceline (end, end + air, TRUE, world); // Trace up from target center to new point in the sky.
        start = trace_endpos - '0 0 2';
        points = SUB_RandomDamage(damage);
		den = points * targ.resist_cells * 4;
		den = floor (den);
		if (den > 0) {
			if (targ.bloodtype == BLOOD_RED) blud = 225; // Lightning blood.
			else blud = targ.bloodtype;
				
			if (blud > 0) particle (end, '0 0 100', blud, den); // Hit/bleed
			else particle (end, '0 0 20', 0 - blud, 10);  // chunks
		}
		T_Damage(targ, attacker, attacker, points, DAMARMOR); // Damage the target.  NOTE:  Reflection won't save the target from the wrath of god.
    } else {
        end = trace_endpos;
        ignore = world;
    }

    // Create lightning and thunder effects.
    setorigin(zap,end);
    sound(zap,CHAN_AUTO,"hipnotic/weapons/mjolhit.wav",1,0.5);  // It's loud.
	QC_ParseBeam(TE_LIGHTNING1,string_null, zap, start, end, 32);
    remove(zap);   // Dummy served its purpose, now begone.
    if (pointcontents(end) == CONTENT_SKY) return;     // Don't explode if it hits sky below.

    Zapper_Spawn(attacker,end,damage,ignore); // Create explosion on impact.
    ShockWave(end + '0 0 4', 8, 4, "progs/drake/s_wave.spr",FALSE);
};

void() Ice_Touch = { // [FUNCTION]
    local float chunks, damage;
    local vector spot;

    if (pointcontents(self.origin) <= CONTENT_LAVA) {remove(self);  return;} // Lava or sky.
    if (Reflected ()) return;

    self.touch = SUB_Null;      // Stack overflow prevention.
    chunks = TRUE;
    damage = self.dmg;
    if (other.takedamage) {
		// Check cold resistance here instead of in the damage functions because it affects how much blood is spawned.
        if (damage > 0) {
            spawn_touchblood (self, other, damage);
            T_Damage (other, self, self.owner, damage, DAMARMOR);
            chunks = FALSE;
        }
    }
    if (chunks) {
        spawn_touchblood (self, other, 10); // Ice chunks.
        sound (self, CHAN_WEAPON, "drake/dragon/icehit.wav", 1, ATTN_NORM);
    }

	// Become a mini-shockwave if close enough to the wall.
	// In case of standard engines, just display a ring topside only.
    spot = self.origin;
    traceline (spot, spot + self.velocity, TRUE, world); // Ignore creatures.
    if (trace_fraction >= 1.0) {remove (self);  return;} // Too far from a solid surface.
	
    spot = trace_endpos + trace_plane_normal * 2;
    self.angles = vectoangles(trace_plane_normal);
    self.angles_y = anglemod(self.angles_y + 180);
    setorigin (self, spot);
    self.alpha = 0;
    BecomeAnyExplosion (RING2_ICE, 3, "progs/drake/s_wave2.spr");
};

void() Ice_Think = { // [FUNCTION]
    Meteor_Trail (39, 2, FALSE);    // Function in 'fire.qc'.
    if (self.delay <= time) {remove (self); return;}
    if (pointcontents(self.origin) == CONTENT_LAVA) {remove (self); return;}

    self.nextthink = time + 0.1;
};

void(vector start, vector dir, float sped) Ice_Launch = { // [FUNCTION]
    newmis = spawn();
    newmis.master = newmis.owner = self;
    newmis.movetype     = MOVETYPE_FLYMISSILE;
	newmis.classgroup   = CG_PROJICE;
    newmis.solid        = SOLID_BBOX;
    newmis.classname    = "ice";
    newmis.speed        = sped;
    newmis.velocity     = dir * sped;
    newmis.angles       = vectoangles(newmis.velocity);
    newmis.dmg          = 9;
    newmis.dest         = dir;
    newmis.oldorigin    = start;    // For proper particle trail drawing.
    newmis.alpha        = ALPHA_ICE;
    newmis.touch        = Ice_Touch;
    newmis.delay        = time + 5;     // Total duration.  As spikes.
    newmis.nextthink    = 0.01;
    newmis.think        = Ice_Think;
    setall(newmis,"progs/drake/ice.mdl",'0 0 0','0 0 0',start);
};

// Iceballs used by white wyrm.
// Iceball explosion effects, called by T_MissileTouch.
void() Iceball_Explode = { // [FUNCTION]
    sound(self, CHAN_AUTO,"drake/weapons/shatter.wav",1,ATTN_NORM);
    Tent_Explosion2(self.origin,32,16);
    ShockWave(self.origin,RING_ICE,3,"progs/drake/s_wave.spr",FALSE);
    BecomeIcyExp ();
};

// Thinking for iceballs.  Unlike shards, balls explode instead of melting.
void() Iceball_Think = { // [FUNCTION]
    Meteor_Trail (39, 2, TRUE); // Bigger ice chunks, so spawn a beam of frost.
	self.think = Iceball_Think;
    if ((self.delay > time) && (pointcontents(self.origin) != CONTENT_LAVA)) {self.nextthink = time + 0.1;  return;}

    T_MissileTouch (); // Time to blow up.
};

// Launch an explosive icy spikeball.
void(vector start, vector dir, float sped) Iceball_Launch = { // [FUNCTION]
    Ice_Launch (start, dir, sped);
    setmodel (newmis, "progs/drake/iceball.mdl");
    setsize (newmis, '0 0 0', '0 0 0');
    newmis.avelocity = '300 300 300';
    newmis.dmg      = 60;
    newmis.alpha    = ALPHA_ICEBALL;
    newmis.touch    = T_MissileTouch;
    newmis.think    = Iceball_Think;
    newmis.think1   = Iceball_Explode;
};

void(vector start, vector dir, float sped, float damage) Iceball_Toss = { // [FUNCTION]
    Ice_Launch (start, dir, sped);
    setmodel (newmis, "progs/drake/iceball.mdl");
    setsize (newmis, '0 0 0', '0 0 0');
    newmis.movetype = MOVETYPE_TOSS;
    newmis.avelocity = '300 300 300';
    newmis.dmg      = damage;
    newmis.alpha    = ALPHA_ICEBALL;
    newmis.touch    = T_MissileTouch;
    newmis.think    = Iceball_Think;
    newmis.think1   = Iceball_Explode;
};

//  Ice Mines

// Treat destroyed mines as barrels.
void() IceMine_Die = { // [FUNCTION]
    if (self.trigger_field) {remove (self.trigger_field);  self.trigger_field = world;}
    self.th_die= SUB_Null;      // Don't 'die' again if damaged more.
    self.touch = SUB_Null;      // Stack overflow prevention.
    self.solid = SOLID_NOT;
    self.nextthink = 0.01;
    self.think = IceMine_Explode;
};

void() IceMine_Explode = { // [FUNCTION]
    if (self.trigger_field) {remove (self.trigger_field);  self.trigger_field = world;}
    self.touch = SUB_Null;      // Stack overflow prevention.
	T_RadiusDamage (self, self, self.dmg, world, DAMAGEALL); // Explosive damage and sound+fx
	particle_explode(self.origin, 50+random()*50, 1, self.part_style, PARTICLE_BURST_CENTER); // Particle explosion drifting upward
	particle (self.origin, '0 0 0', 0, 255); // Special type (hard-coded) of particle explosion that only works if particle count=255 :)
	self.origin = self.origin + '0 0 32';
	SpawnExplosion(EXPLODE_BURST_SMOKE, self.origin, self.noise);
	entity_hide(self);
};

void() IceMine_Touch = { // [FUNCTION]
    if ((other.takedamage != DAMAGE_AIM) && !(other.flags & FLx_CREATURE)) return; // Target must either be shootable or a creature.
    if (other == self.master) return; // Don't explode on attacker.

    IceMine_Explode(); // Removed sky and reflection checks because they do not apply to land mines.
};

void() mine1 =[ 1, mine2    ] {}; // [FUNCTION]
void() mine2 =[ 2, mine3    ] { // [FUNCTION]
    local float pc;

    pc = pointcontents(self.origin);
    if (pc == CONTENT_LAVA) {IceMine_Explode();  return;}
    if (self.delay > time) self.think = mine2;

    if (self.flags & FL_ONGROUND) return;     // Attached to the ground.

	// Float check.  Ice is less dense than water.
    if ((pc == CONTENT_WATER) || (pc == CONTENT_SLIME)) {
		// Float to the surface;
        self.movetype = MOVETYPE_FLY;
		self.flags = self.flags - (self.flags & FL_ONGROUND);
        self.velocity_z = self.velocity_z + 48;
        if (self.velocity_z > 48)
            self.velocity_z = 48;
    } else
        self.movetype = MOVETYPE_TOSS;
};
void() mine3 =[ 3, SUB_Null ] {IceMine_Explode();}; // [FUNCTION]

// Made so monsters who step on the iceball will explode it.
void() IceMineTrigger_Touch = { // [FUNCTION]
    local   entity  ice, swap;

    ice = self.owner;
    if (!ice || (ice == self)) {remove (self);  return;}
    if (!(other.flags & FL_MONSTER)) return; // Other things should be able touch the iceball itself.
    if (other == ice.master) return; // Iceball owner is immune.
    if (!(ice.flags & FL_ONGROUND) || (ice.velocity != '0 0 0')) return; // Anything can touch iceball if it's moving.

	// Set off the mine!
    if (other) other.flags = other.flags - (other.flags & FL_ONGROUND);
    self.touch = SUB_Null;
    swap = self;
    self = ice;
    self.trigger_field = world;
    self.touch = SUB_Null;      // Stack overflow prevention.
    self.owner = other;         // Pass through the mine.
    IceMine_Explode();
    self = swap;
    remove (self);
};

void() IceMineTrigger_Think =[ 0, IceMineTrigger_Think ] { if (self.owner) setorigin (self, self.owner.origin); }; // [FUNCTION]

void(vector start) IceMine_Spawn = { // [FUNCTION]
    local entity swap;

	// Spawn the ice mine.
    newmis = spawn ();
    newmis.owner        = world;
    newmis.master       = self;
    newmis.movetype     = MOVETYPE_TOSS;
    newmis.solid        = SOLID_BBOX;
	newmis.classgroup = CG_PROJICE;
    newmis.classname    = "ice";
    newmis.velocity     = '0 0 0'; // set missile speed
    newmis.avelocity    = '0 0 0';
    newmis.angles       = '0 0 0';
    newmis.dmg          = 90; // set missile damage
    newmis.health       = 25;   // Barrels use 20 hp.
    newmis.takedamage   = DAMAGE_YES;
    newmis.bloodtype    = CHUNKS_ICE;
    newmis.hittype      = HIT_STONE;
    newmis.th_die       = IceMine_Die;
    newmis.resist_cold  = 1;    // Immune to cold.
    newmis.resist_fire  = 0;   // Fire melts ice!
    newmis.touch        = IceMine_Touch;
    newmis.think1       = Iceball_Explode;
    newmis.frame        = 0;
    newmis.alpha        = ALPHA_ICEBALL;
    newmis.think        = mine1;
    newmis.nextthink    = time + 0.1; // set missile duration
    newmis.delay        = time + 30;
    setall (newmis, "progs/drake/iceball.mdl", VEC_ITEM_MIN, '16 16 16', start);
	swap = self;
	self = newmis;
	droptofloor();
	self = swap;

	// Spawn touch field.
	// With solid_bbox and movetype_toss, monsters can walk on the iceball
	// without exploding it, which is unfair.  Therefore, place a trigger
	// field over the iceball so anytime a monster tries to walk on the ice,
	// the iceball will explode as expected.
    swap = spawn();
    swap.master = swap.owner = newmis;
    swap.movetype   = MOVETYPE_NONE;
    swap.solid      = SOLID_TRIGGER;
    swap.nextthink  = time + 0.1;
    swap.think      = IceMineTrigger_Think;
    swap.touch      = IceMineTrigger_Touch;
    setall(swap, "",VEC_ITEM_MIN, VEC_HULL_MAX, start);
    newmis.trigger_field  = swap;      // Link touch field to the iceball.
    sound(newmis, CHAN_AUTO, "drake/weapons/freeze.wav", 1, ATTN_NORM);
    ShockWave (newmis.origin + '0 0 4', RING_ICE, 3, "progs/drake/s_wave.spr",FALSE); // Spawning effects.
};

//  Tornado -- Used by the wind baron.  Sucks in targets near the cone, and damages those already in it.
void() Tornado_Attack = { // [FUNCTION]
    local   entity  head;
    local   vector  delta, spot, vel;
    local   float   hit;

	// Note:  Walls offer no protection against the baron's tornado.
    head = findradius (self.origin, 256);
    while (head) {
        if (head != self)
        if (head != self.master)
        if (head.origin_z + head.maxs_z >= self.origin_z) { // Head must be at or above spawnpoint.
            // Get horizontal distance between target and center.
            spot = head.origin;  spot_z = self.origin_z;
            delta = self.origin - spot;     // delta_z should be 0.

            // First, inflict some damage.
            hit = (vlen(delta) < 100);
            if (hit) T_Damage (head, self, self.master, self.dmg, DAMARMOR);

            // Next, suck the target into the vortex if possible.
            if (((head.flags & FLx_CREATURE) && head.mass <= MASS_HEAVY) || (AffectedByPhysics(head)) && head.movetype != MOVETYPE_NONE) {
                if (hit || (head.flags & FL_MONSTER)) { // Sweep the target off its feet.
                    if (!hit && (head.flags & FL_ONGROUND) && head.velocity_z < 80) head.velocity_z = 80;
                    head.flags = head.flags - (head.flags & FL_ONGROUND); // Walkers lose control of movement.
                }
                vel = head.velocity;
                vel_x = vel_x * 0.5;
                vel_y = vel_y * 0.5;
                if (hit) {
                    vel_z = vel_z * 0.5;
                    if (vel_z < 150) vel_z = 150; // Float up and away.
                }
                head.velocity = vel + normalize(delta) * 100;
            }
        }
        head = head.chain;
    }
};

// Thinking for the smoke particles in the tornado.
void() tornado2 =[ 0, tornado2 ] { // [FUNCTION]
    local vector spot, trig, dir;

    if (self.delay <= time) { remove (self); return; }

    self.speed = self.speed + 8;
    self.height = self.height + 24;
    self.cnt = anglemod (self.cnt + 47);
    spot = self.oldorigin;
    spot_z = spot_z + self.height;
    trig = CoSine (self.cnt);
    dir = (('1 0 0' * self.speed) * trig_x) + (('0 1 0' * self.speed) * trig_y);
    spot = spot + dir;
    setorigin (self, spot);
};

// Think function for the tornado.  Spawns all of its effects.
void() tornado1 =[ 0, tornado1 ] { // [FUNCTION]
    if (self.delay <= time) {
        super_active = FALSE;
        StopSound (self, 6);
        remove (self);
        return;
    }

    if (self.t_width < time) {
        self.t_width = time + 1;
        sound (self, CHAN_AUTO, "drake/baron/tornado.wav", 1, ATTN_NORM);
    }
    Tornado_Attack ();
    self.height = (self.height + 3) & 7;
    self.cnt = anglemod(self.cnt + 107);
    newmis = spawn();
    newmis.owner      = self;
    newmis.movetype   = MOVETYPE_NOCLIP;
    newmis.solid      = SOLID_NOT;
    newmis.velocity   = '0 0 0';
    newmis.nextthink  = 0.01;
    newmis.delay      = time + 1.2;     // FIXME:  Use T+1?
    if (newmis.delay > self.delay) newmis.delay = self.delay;     // Last no longer than parent.
    newmis.think      = tornado2;
    newmis.cnt        = self.cnt + self.height;
    newmis.oldorigin  = self.origin;
    setall (newmis, "progs/drake/smoke.mdl", '0 0 0', '0 0 0', self.origin);
};

// Spawns an immobile tornado that sucks in and damages targets.
void(vector start) Tornado_Spawn = { // [FUNCTION]
    if (super_active) return; // Uses many edicts and particles, only one at a time.

    traceline (start, start - '0 0 256', TRUE, self);
    if (trace_fraction == 1) return; // No ground.

    start = trace_endpos + '0 0 2';
    super_active = TRUE; // Only one big effect at a time please.
    local entity wind;

	// Spawn the tornado.
    wind = spawn ();
    wind.owner        = world;
    wind.master       = self;
    wind.movetype     = MOVETYPE_NONE;    // Immobile.  No MOVETYPE_FLY.
    wind.solid        = SOLID_NOT;
    wind.classname    = "tornado";
    wind.velocity     = '0 0 0';
    wind.dmg          = 2;      // 20/sec * 5 sec = 100.
    wind.takedamage   = DAMAGE_NO;
    wind.touch        = SUB_Null;
    wind.frame        = 0;
    wind.think        = tornado1;
    wind.nextthink    = time + 0.1;
    wind.delay        = time + 5;
    wind.t_width      = 0;
    setall (wind, "", '0 0 0', '0 0 0', start);
    ShockWave(wind.origin + '0 0 4', RING_QUAKE, 4, "progs/drake/s_wave.spr",FALSE);
};

// Was named 'Knightball_Explode'.
void() Orange_Explosion = { // [FUNCTION]
    local float r;

	T_RadiusDamage(self, self, self.dmg, world, DAMAGEALL); // Explosive damage and sound+fx
	particle_explode(self.origin, 50+random()*50, 1, self.part_style, PARTICLE_BURST_UPWARD); // Particle explosion drifting upward
	particle (self.origin, '0 0 0', 0, 255); // Special type (hard-coded) of particle explosion that only works if particle count=255 :)
    r = random() * 3;
    if (r < 1)
        Rocket_Explosion2 (self.origin, 224, 16);
    else if (r < 2)
        Rocket_Explosion2 (self.origin, 230, 8);
    else
        Rocket_Explosion2 (self.origin, 232, 8);

    BecomeExplosion ();
};

//  Teleglitter
// NOTE:  We should not emulate Heretic's algorithm for teleglitter spawners
// because that produces too many edicts, which can cause packet overflow
// in standard engines.  Therefore, particles are sometimes spawned instead
// of sprites, and glitter sprites start with some velocity so they can
// collide with the ceiling sooner and disappear.
void() glitter_think = { // [FUNCTION]
    if (self.frame >= self.waitmax) {
        if (self.cnt > 5) {remove (self);  return;} // 5 rewinds give 3 sec. life -- long enough.
		
        self.cnt = self.cnt + 1;
        self.frame = self.waitmin;
    } else self.frame = self.frame + 1;

    if (self.height) { // Accelerate.
        self.speed = self.speed + self.height;
        self.velocity = self.movedir * self.speed;
    }
    self.nextthink = time + self.delay;
};

// Show some fireworks.
void() make_glitter = { // [FUNCTION]
	local entity targ;
    local vector spot, vel;
    local float rgb, go;

    spot_x = self.absmin_x + (random() * self.size_x);
    spot_y = self.absmin_y + (random() * self.size_y);
    spot_z = self.absmin_z + (random() * self.size_z);
    vel = self.movedir * self.speed;
    rgb = self.count;
    if (self.lefty) {
		// Show particles only if the client can see the spawn point.
		// We need this check because in software mode (WinQuake),
		// a client can see particles through non-world wall entities
		// if said client is a long distance away.
        go = TRUE;
		// Don't try this in netgames.
        if (!deathmatch) {
            targ = checkclient();
            if (targ) {
                traceline (targ.origin + targ.view_ofs, spot, TRUE, targ);
                if (trace_fraction < 1) go = FALSE;
            } else go = FALSE;
        }
        if (go) {
            if (rgb > 251) rgb = 9;
            else if (rgb > 246) rgb = 225;
            else if (rgb > 243) rgb = 41;
            else if (rgb > 239) rgb = 193;
            particle (spot, vel*0.1, rgb, 10);
        }
    } else { // Heretic-style teleglitter.
        if (rgb > 251) rgb = 90;
        else if (rgb > 246) rgb = 85;
        else if (rgb > 243) rgb = 80;
        else rgb = floor(rgb / 16) * 5;

        newmis = spawn();
        setmodel (newmis, "progs/drake/s_spark.spr");
        setorigin (newmis, spot);
        newmis.movetype     = MOVETYPE_FLY;
        newmis.solid        = SOLID_TRIGGER;
        newmis.velocity     = vel;
        newmis.delay        = 0.1;
        newmis.nextthink    = time + newmis.delay;
        newmis.think        = glitter_think;
        newmis.touch        = SUB_Remove;
        newmis.classname    = "glitter";
        newmis.frame        = rgb;
        newmis.cnt          = 0;
        setsize (newmis, '-1 -1 -1', '1 1 1');
        newmis.movedir      = self.movedir;
        newmis.speed        = self.speed;
        newmis.waitmin      = newmis.frame;
        newmis.waitmax      = newmis.frame + 4;
        newmis.height       = self.height;
    }
    self.lefty = !self.lefty;   // Alternate between particles and sprites.
    self.nextthink      = time + self.wait;
    self.think          = make_glitter;
};

//============
// --> QUAKED misc_glitter (0 .5 .8) (-8 -8 -8) (8 8 8)
// Heretic-style teleglitter generator.  Use on exit or teleport pads.
// Otherwise, similar idea to air_bubbles.
//============
void() misc_glitter = { // [ENTITY]
    if (self.classname == "misc_glitter") {
        setsize (self, '-16 -16 -8', '16 16 48');
    } else {
        // Teleporter destination with glitter spawnflag on.
        // Destinations are set 27 units above placement, so subtract
        // that much from new bbox mins/maxs_z to get proper bounds.
        // Update:  z - 26 should do.
        setsize (self, '-16 -16 -34', '16 16 22');
    }
    precache_model ("progs/drake/s_spark.spr");

    if (!self.wait) self.wait   = 0.1;
    if (!self.count) self.count  = 244; // Default is bright electric blue.
    if (!self.speed) self.speed  = 100;
    if (!self.height) self.height = 50; // Acceleration per frame for teleglitter.

	// Sparks should fly up by default.  An angle of 0 is assumed to mean
	// undefined, so to force east flight path, use a yaw of 360 instead.
    if (self.angles != '0 0 0')	SetMovedir ();
    else self.movedir = '0 0 1'; // Straight up

    self.nextthink  = time + 1;
    self.think      = make_glitter;
};

// Creates a glitter spawner.  Called by spawn functions of other entities
// such as teleporter and changelevel triggers, and used by them to create
// glittering teleporter pads like in Heretic.
void() Glitter_Spawner = { // [FUNCTION]
    local entity test;
    local vector spot;

    if (deathmatch) return; // Disabled, so don't waste time spawning an entity.

    spot = Anypoint (self, '0.5 0.5 0');
    spot_z = spot_z + 8;
    test = spawn();
    test.classname = "misc_glitter";
    test.count = self.count; // Glitter color
    setorigin(test, spot);
    SUB_ThinkImmediate(test, misc_glitter);
};

// Custom particle explosion for plasma shots.
// Warning:  Calls particle function more times than healthy.  44 particle() calls!
void(vector spot, vector x1, vector x2) Particle_Explosion = { // [FUNCTION]
	local float sped, rgb, den;

	// Vertices of a rhombic triacontahedron (d30).
	sped = x1_x;
	rgb = x1_y;
	den = x1_z;
    particle (spot, '0 0 1' * sped, rgb, den);
    particle (spot, '.5076 .3688 .7787' * sped, rgb, den);
    particle (spot, '-.1939 .5967 .7787' * sped, rgb, den);
    particle (spot, '-.6274 0 .7787' * sped, rgb, den);
    particle (spot, '-.1939 -.5967 .7787' * sped, rgb, den);
    particle (spot, '.5076 -.3688 .7787' * sped, rgb, den);
    particle (spot, '.7905 .5743 .2128' * sped, rgb, den);
    particle (spot, '-.3019 .9293 .2128' * sped, rgb, den);
    particle (spot, '-.9771 0 .2128' * sped, rgb, den);
    particle (spot, '-.3019 -.9293 .2128' * sped, rgb, den);
    particle (spot, '.7905 -.5743 .2128' * sped, rgb, den);
    particle (spot, '.7236 .5257 -.4473' * sped, rgb, den);
    particle (spot, '-.2763 .8507 -.4473' * sped, rgb, den);
    particle (spot, '-.8944 0 -.4473' * sped, rgb, den);
    particle (spot, '-.2763 -.8507 -.4473' * sped, rgb, den);
    particle (spot, '.7236 -.5257 -.4473' * sped, rgb, den);
    particle (spot, '.8944 0 .4473' * sped, rgb, den);
    particle (spot, '.2763 .8507 .4473' * sped, rgb, den);
    particle (spot, '-.7236 .5257 .4473' * sped, rgb, den);
    particle (spot, '-.7236 -.5257 .4473' * sped, rgb, den);
    particle (spot, '.2763 -.8507 .4473' * sped, rgb, den);
    particle (spot, '.9771 0 -.2128' * sped, rgb, den);
    particle (spot, '.3019 .9293 -.2128' * sped, rgb, den);
    particle (spot, '-.7905 .5743 -.2128' * sped, rgb, den);
    particle (spot, '-.7905 -.5743 -.2128' * sped, rgb, den);
    particle (spot, '.3019 -.9293 -.2128' * sped, rgb, den);
    particle (spot, '.6274 0 -.7787' * sped, rgb, den);
    particle (spot, '.1939 .5967 -.7787' * sped, rgb, den);
    particle (spot, '-.5076 .3688 -.7787' * sped, rgb, den);
    particle (spot, '-.5076 -.3688 -.7787' * sped, rgb, den);
    particle (spot, '.1939 -.5967 -.7787' * sped, rgb, den);
    particle (spot, '0 0 -1' * sped, rgb, den);

	// Vertices of an icosahedron (d20).
	sped = x2_x;
	rgb = x2_y;
	den = x2_z;
	// Golden ratio = (1 + sqrt(5)) / 2.  (1:1.618)
    particle (spot, '0 .5257 .8507' * sped, rgb, den);
    particle (spot, '0 -.5257 .8507' * sped, rgb, den);
    particle (spot, '0 -.5257 -.8507' * sped, rgb, den);
    particle (spot, '0 .5257 -.8507' * sped, rgb, den);
    particle (spot, '.5257 .8507 0' * sped, rgb, den);
    particle (spot, '-.5257 .8507 0' * sped, rgb, den);
    particle (spot, '-.5257 -.8507 0' * sped, rgb, den);
    particle (spot, '.5257 -.8507 0' * sped, rgb, den);
    particle (spot, '.8507 0 .5257' * sped, rgb, den);
    particle (spot, '.8507 0 -.5257' * sped, rgb, den);
    particle (spot, '-.8507 0 -.5257' * sped, rgb, den);
    particle (spot, '-.8507 0 .5257' * sped, rgb, den);
};

// Spawns particles within an ent.  Bounds are the entity's hull boundaries.
void(entity ent, float color1, float color2) Particle_Cube = { // [FUNCTION]
    local vector spot;
    local float loop;

    loop = 11;
    while (loop > 0) {
        loop = loop - 1;
        spot_x = random();  spot_y = random();  spot_z = loop / 10;
        spot = Anypoint (ent, spot);
        if (random() < 0.25) particle (spot, '0 0 0', color2, 5);
        else particle (spot, '0 0 0', color1, 5);
    }
};

float(entity targ, entity attacker) Divine_Trace = { // [FUNCTION]
	local float dist;

    if (!(targ.flags & FLx_CREATURE)) return FALSE;
	if (targ.deadflag) return FALSE;
	if (targ.health <= 0) return FALSE;
	if (!targ.solid) return FALSE;
	if (!targ.modelindex) return FALSE;

	traceline(attacker.origin + attacker.view_ofs, targ.origin + targ.view_ofs, TRUE, attacker); // Sees through monsters.
	if (trace_fraction != 1) return FALSE;
	if (UpIsSky(targ.origin)) {
		dist = vlen(targ.origin - attacker.origin);
		if (dist >= 140 && dist <= 2000) return TRUE;
	} else return FALSE;
};

// Like CheckPowerups, except this sends a lethal bolt of lightning down to self.
void() Divine_Check = { // [FUNCTION]
	local entity attacker;

    if (!self.divine_finished || self.divine_finished >= time) return;

	attacker = self.divine_attacker;
	self.divine_finished = 0;
	self.divine_attacker = world;
	if (attacker.divine_hits <= 0) return;
	if (!Divine_Trace(self, attacker)) return;

	Thunderstrike_Ex(attacker,self.origin,80);  // Lightning can hit the target.  Send the lightning down.  Since a diety is attacking on behalf of the attacker, damage is indirect.
	LightZero_Set(20,0,-4);
	if (attacker) attacker.divine_hits = attacker.divine_hits - 1;
};

// Wrath of God (WOG).  Spawns a mini lightning storm.  The attacker is 'self'.
// 'shots' = Maximum bolts called down.
// 'dur' = How long the darkness lasts.
float(float shots, float dur) Divine_Wrath = { // [FUNCTION]
    local   entity  head;
    local   float   hits;
    local   vector  vx, dir;

    if (!self) return FALSE;
	
    if (self.flags & FL_CLIENT) vx = self.v_angle;
    else vx = self.angles;
	
    makevectors (vx);
    vx = v_forward;
    hits = 0;
    head = nextent (world);
    while (head) {
        if (Divine_Trace (head, self)) {
            dir = normalize (head.origin - self.origin);
            if (dir * vx > 0.7071) { // Must be within fov 90.
				// Send a bolt down.  Proxy damage due to divine intervention.
                // Note:  The latest attacker overrides previous attackers.
                head.divine_attacker = self;
                head.divine_finished = hits * 0.1 + time;
                hits = hits + 1;
            }
        }
        head = nextent (head);
    }
    if (hits) {
        if (!shots) shots = 255; // Set maximum hits an attacker may score.
        if (!lightzero_finished) sound (world, CHAN_AUTO, "drake/bane/thunder.wav", 1, ATTN_NONE);
        LightZero_Set(-1,dur,-2);
        self.divine_hits = shots; // Number of bolts in slam, so match that.
    }
    return hits;
};

// Triggered lightning strikes based on Divine* functions.
void() divine_use = { // [FUNCTION]
    local entity swap;
    local float hits;

    if (self.attack_finished > time) return;     // Previous attack unfinished.
	if (!activator) return;

    swap = self;
	// Spawn dummy entity to act as the attacker.  Dummy is placed where activator is so dummy can see targets.
    self = spawn();
    self.alignment  = activator.alignment;  // Don't hit activator.
    self.angles     = activator.angles;     // Use to find activator's targets.
    setorigin(self,activator.origin);
    hits = Divine_Wrath(swap.cnt,1);
    if (hits) {
        self.nextthink  = time + 0.2 + (hits * 0.1); // Lightning strike is delayed, so delay dummy removal.
        self.think      = SUB_Remove;
    } else {
		// No lightning strikes, so just flash and thunder ominously.
        sound (world, CHAN_AUTO, "drake/bane/thunder.wav", 1, ATTN_NONE);
        LightZero_Set (LIGHTZERO_MAX, 0, -4);
        remove(self);
    }
    self = swap; // Restore self.
    self.attack_finished = time + 0.2 + (hits * 0.1);
    SUB_UseTargets (); // Now function like trigger_relay.
};

void() trigger_smite = { // [ENTITY]
    precache_sound ("drake/bane/thunder.wav");
    precache_sound ("hipnotic/weapons/mjolhit.wav");
    self.attack_finished = 0;
    if (!self.cnt) self.cnt = 1;
    self.use = divine_use;
};
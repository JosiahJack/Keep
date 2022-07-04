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

void(entity ent, float chan) StopSound;
float(float shots, float dur) Divine_Wrath;

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

    spot_x = self.origin_x + (crandom() * self.size_x);
    spot_y = self.origin_y + (crandom() * self.size_y);
    spot_z = self.origin_z + (crandom() * self.size_z);
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
    if (self.angles != '0 0 0')	SetMovedir();
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
    SUB_UseTargets(); // Now function like trigger_relay.
};

void() trigger_smite = { // [ENTITY]
    precache_sound ("drake/bane/thunder.wav");
    precache_sound ("hipnotic/weapons/mjolhit.wav");
    self.attack_finished = 0;
    if (!self.cnt) self.cnt = 1;
    self.use = divine_use;
};
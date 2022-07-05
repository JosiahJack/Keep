//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
//
// Attributions: Drake, Nehahra
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
// Function count: 9
//
// Implements: Nehahra Souls, Using Drake's updates
//
// Description:
// Floating souls that come from dead monsters or players that wraiths will
// go around and collect.
//
// Here in its own file for any wraith-like monster to use.
//=============================================================================

// Drake Spawnflags used by ghosts (wraith, dreadlord, and nightshade).
// 1 = Ambush, as standard plus phased out when idle.
// 2 = Special, wraiths behave as in Nehahra, dreadlords get boss mode.
// 4 = Souls, seek out and collect souls.  Enables fleeing and aether scenes.
float   SPAWN_SOUL  = 4;    // Spawnflag that tells wraith to seek out souls.
float   SOUL_TIME   = 15;
float   WRAITH_HP_AETHER    = 50;   // Must be lower than critical.
float   WRAITH_HP_CRITICAL  = 60;   // Flee when health falls below this.

float() FollowSetup;

// Call this to remove souls.
void() Soul_Remove = { // [FUNCTION]
	local entity stemp;

    if (self.owner) {
        if (self.owner.enemy == self) self.owner.enemy = world;   // Target is gone, find another.
        if (self.owner.oldenemy == self) self.owner.oldenemy = world;    // Ditto
        self.owner.gorging = FALSE; // Get out of reaper mode.
		stemp = self;
		self = self.owner;
		self.enemy = self.oldenemy = self.goalentity = world;
		self.attack_finished = time + 0.5;
		if (!FollowSetup()) self.think = self.th_stand; // Return to walking path or standing.
		else self.think = self.th_walk;
		self.nextthink = time + 0.1;
		self = stemp;
    }
    remove(self);
};

// 'self' is the soul getting sucked in.
void() Soul_Think = [ 0, Soul_Think ] { // [FUNCTION]
    local entity reaper;
    local vector org;

    self.nextthink = time + 0.05;
    if (self.wait <= time) {
        sound (self, CHAN_BODY, "nehahra/wraith/soul.wav", 1, ATTN_IDLE);
        self.wait = random() * 60 + time;
    }

	self.alpha = self.alpha + 0.05;
	if (self.alpha > 1) self.alpha = 1;
    reaper = self.owner;
    if (self.owner) {
		if (!self.owner.gorging || (self.owner.health <= 0) || (self.owner.enemy != self)) { // Not sucking souls now.

			self.velocity = '0 0 0';
			if (self.owner.health <= 0) self.owner = world; // Reaper is dead.
			if (self.cnt > 0) { // Still inside corpse.
				// Stick to corpse.
				if (self.owner) {
					self.origin     = self.oldenemy.origin;
					self.origin_z   = self.oldenemy.absmin_z + 4;
					setorigin (self, self.origin);
				}
			}
			return;
		}
	}

    if (self.cnt > 0 || self.oldenemy.gibbed || self.oldenemy == world) { // Rip the soul out of the body.
        self.cnt = 0;
        self.effects = EF_DIMLIGHT;
    }
    if (self.mangle_x || self.mangle_y) {
		makevectors(reaper.angles);
        org = reaper.origin + (v_forward*self.mangle_x) + (v_forward*self.mangle_y) + (v_forward*self.mangle_z);
    } else org = reaper.origin + self.mangle;

    org = org - self.origin;
    self.velocity = normalize(org) * 40;
    if (vlen(org) < 20 && self.cnt >= 0) { // Close enough for soul to be devoured by wraith.
        StopSound(self,CHAN_BODY);
		self.cnt = -1;
        T_Heal(reaper,50,TRUE);
        if (reaper.classtype == CT_MONSHADE) sound (reaper, CHAN_VOICE, "drake/shade/taunt.wav", 1, ATTN_NORM);
        else sound (reaper, CHAN_VOICE, "nehahra/wraith/rych1.wav", 1, ATTN_IDLE);

        Soul_Remove();
    }
};

// Spawns a fresh soul by ripping it out of 'ent'.
// 'self' is the monster looking for souls to steal.
void(entity ent) Soul_Spawn = { // [FUNCTION]
	ent.gorging = TRUE;
    newmis = spawn(); // Nehahra aborted this if soul would spawn at the origin.
    newmis.origin     = ent.origin;
    newmis.origin_z   = ent.absmin_z + 4;
    newmis.oldenemy   = ent;
    newmis.owner      = self;  // Cannot use 'master' because summon code thinks soul is a pet.
    newmis.classname  = "soul";
	newmis.classtype  = CT_SOUL;
    newmis.solid      = SOLID_TRIGGER; // Don't make bodies glow.
    newmis.movetype   = MOVETYPE_NOCLIP;
    newmis.cnt        = 1; // Begins hidden in corpse.
    newmis.mangle     = '0 0 20';
    if (self.classtype == CT_MONSHADE) newmis.mangle_x = 30;
    newmis.wait       = 0;
	newmis.alpha	  = 0.01;
    newmis.nextthink  = time + 0.2;
    newmis.think      = Soul_Think;
    setorigin(newmis,newmis.origin);
    setmodel(newmis,"progs/nehahra/soul.mdl"); // So it can glow while invisible.
    setsize(newmis, '0 0 0', '0 0 0');
};

void(string sfx) ai_wraith = { // [FUNCTION]
	if (self.attack_state == AS_FLEEING) {
		sound (self, CHAN_VOICE, sfx, 1, ATTN_IDLE);
		sound (self.enemy, CHAN_VOICE, sfx, 1, ATTN_IDLE);
		self.attack_state = AS_STRAIGHT;
	}
};

void() aether_out1 = { // [FUNCTION], Phase out start.
    self.velocity   = '0 0 0';
    self.solid      = SOLID_NOT;
    self.takedamage = DAMAGE_NO;
    self.effects    = self.effects | EF_DIMLIGHT;
    sound(self, CHAN_VOICE, "nehahra/wraith/return.wav", 1, 0.5);  // Was ATTN_NONE.
    self.th_melee   = SUB_Null;
    self.th_missile = SUB_Null;
};
void() aether_out2 = { // [FUNCTION], Phase out end.
    self.effects    = self.effects - (self.effects & EF_DIMLIGHT);
    self.flags      = self.flags | FL_NOTARGET;
	self.alpha		= 0.01;
    self.modelindex = 0;
};

void() aether_in1 = { // [FUNCTION], Phase in start.
    self.velocity   = '0 0 0';
    self.effects    = self.effects | EF_DIMLIGHT;
    self.flags      = self.flags - (self.flags & FL_NOTARGET);
    self.modelindex = self.mindex2;
    sound (self, CHAN_VOICE, "nehahra/wraith/return.wav", 1, 0.5);  // Was ATTN_NONE.
};

void(void() hth, void() miss) aether_in2 = { // [FUNCTION], Phase in end.
    self.effects    = self.effects - (self.effects & EF_DIMLIGHT);
    self.solid      = SOLID_TRIGGER;
    self.takedamage = DAMAGE_AIM;
    self.th_melee   = hth;
    self.th_missile = miss;
};

float() Wraith_FindSoul = { // [FUNCTION]
    local float dist, d;
    local entity head, targ;

	if (self.enemy) return FALSE;

	// Find the nearest lost soul in case a friend wraith was attacked.
    dist = 1001;
    targ = world;
    head = findradius(self.origin, 1000);
    while (head) {
        if (head.classtype == CT_SOUL) {
			if (!head.owner || (head.owner == self)) {
				d = vlen(head.origin - self.origin);
				if (d < dist) { targ = head;  dist = d;}
			}
		}
        head = head.chain;
    }
    if (targ) { // Found one.
        targ.owner = self;
        if (self.enemy) self.oldenemy = self.enemy;
        self.enemy = targ;
		SUB_SelfThink(self.th_run,0.1);
        return TRUE;
    }
	// Didn't find any lost souls, so look for fresh souls in corpses.
    head = findradius(self.origin,2048);
    while (head) {
        if ((head.flags & FL_MONSTER) && head.health <= 0) {
			if (!head.gibbed && !head.gorging) { // Got one!
				if (self.classtype == CT_MONSHADE) { // Use voice channel to override others.
					sound (self, CHAN_VOICE, "drake/shade/screech.wav", 1, ATTN_NORM);
					sound (head, 6, "drake/shade/screech.wav", 1, ATTN_IDLE);
				} else { // Nehahra used item channel for selection.
					sound (self, CHAN_ITEM, "nehahra/wraith/select.wav", 1, ATTN_IDLE);
					sound (head, 6, "nehahra/wraith/select.wav", 1, ATTN_IDLE);
				}
				Soul_Spawn(head);
				self.enemy = newmis;
				self.gorging = TRUE;
				SUB_SelfThink(self.th_run,0.1);
				return TRUE;
			}
		}
        head = head.chain;
    }
    return FALSE;
};
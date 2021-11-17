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
// Function count: 54
//
// Implements: Drake Fire System and Effects
//
// Description:
// Burning for entities, particularly monsters that have been set on fire.
//=============================================================================

float() Reflected;
float(float damage) Reflected_Damage;
void(float ents) Ember_Shower;
void(entity targ) ResetDebuffBurning;
void() Ember_Think;

// Flame animation on modified 'flame2.mdl'.
void() m_ember1 =[ 28, m_ember2   ] {Ember_Think();}; // [FUNCTION]
void() m_ember2 =[ 29, m_ember3   ] {Ember_Think();}; // [FUNCTION]
void() m_ember3 =[ 30, m_ember4   ] {Ember_Think();}; // [FUNCTION]
void() m_ember4 =[ 31, m_ember5   ] {Ember_Think();}; // [FUNCTION]
void() m_ember5 =[ 32, m_ember5 ]   {Ember_Think();}; // [FUNCTION]

// This makes flaming embers rise from the burning victim 'ent'.
void(entity ent) MakeFlame = { // [FUNCTION]
    local entity fire;       // The new fire that will be created.
    local vector spot;       // The spot where the new fire will appear.
    local float r;

    spot   = ent.size * 0.5;
    spot_x = spot_x * (random() - 0.5);
    spot_y = spot_y * (random() - 0.5);
    spot_z = spot_z * (random() - 0.5);
    spot   = spot + Midpoint (ent);
    fire = spawn();
    fire.frame      = 28;
    fire.solid      = SOLID_NOT;
    fire.takedamage = DAMAGE_NO;
    fire.movetype   = MOVETYPE_FLY;
    fire.velocity   = '0 0 100';
    fire.owner      = ent;
    setall(fire, "progs/drake/flame2.mdl", '0 0 0', '0 0 0', spot);
    r = random() * 3;
    if (r > 2) SUB_ThinkImmediate (fire, m_ember3); // Animate the flame.
    else if (r > 1) SUB_ThinkImmediate (fire, m_ember2);
    else SUB_ThinkImmediate(fire, m_ember1);
};

// Thinking for the delayed damage entity spawned by BecomeBigBang.
void() DelayedFireDamage_Think = { // [FUNCTION]
    T_RadiusDamage(self, self.owner, self.dmg, world, DAMAGEALL);
    self.count = self.count - 1;
    if (self.count > 0) self.nextthink = time + 0.2;
    else remove(self);
};

// Spawn a separate entity for delayed damage so that I don't need to clog the generic explosion code or write yet another special explosion scene.
void(entity attacker, vector spot, float damage) DelayedFireDamage_Spawn = { // [FUNCTION]
    local float attn;

    if (!damage) damage = 60; // High enough damage near big fireball sprite.
    attn = damage / 100;
    if (attn > 0.5) attn = 0.5;
    newmis          = spawn();
	newmis.classgroup = CG_PROJFIRE;
    newmis.owner    = attacker;
    newmis.classname= "fire";
    newmis.movetype = MOVETYPE_NONE;
    newmis.velocity = '0 0 0';
    newmis.touch    = SUB_Null;
    newmis.solid    = SOLID_NOT;
    newmis.count    = 3;
    newmis.dmg      = damage;
    newmis.distance = 100; // radius
    newmis.volume   = attn;
    newmis.nextthink= time + 0.1;
    newmis.think    = DelayedFireDamage_Think;
    setall (newmis, "", '0 0 0', '0 0 0', spot);
};

void() BecomeBigBangExplosion = { // [FUNCTION]
    if (coop || deathmatch) Ember_Shower (5);   // Make fewer embers in netgames.
    else Ember_Shower (10); // Make a small flame cloud to make explosion look bigger.

	R_Exp3(self.origin);
	Tent_Explosion(self.origin);
    FlameWave ();
    BecomeTheBigFire ();    // Was BecomeExplosion.
};

// This creates a bigger fiery explosion like the one in the game Blood.
void() BecomeBigBang = { // [FUNCTION]
    DelayedFireDamage_Spawn(self.master,self.origin,self.dmg / 3); // Delayed damage effects.
    Quake_Spawn(self.master,self.dmg + 60,5,self.origin,FALSE,0.8,VEC_QUAKE); // Note:  A 0.8 sec quake pings for damage three times.
    BecomeBigBangExplosion(); // The rest of the explosion effect.
};

// Spawns a huge fiery explosion at a point.  'dmg1' = Explosion damage.  'dmg2' = Secondary fire damage.  Pings multiple times.  Assumes attacker to be self.
void() BaronFireworks = { // [FUNCTION]
    newmis = spawn();
	newmis.classgroup = CG_PROJFIRE;
    newmis.owner = self;
    newmis.movetype = MOVETYPE_NONE;
    newmis.solid = SOLID_NOT;
    newmis.classname = "fire";
    setorigin (newmis, self.dest);
    T_RadiusDamage(newmis,self,90,world,DAMAGEALL);
    sound(newmis,CHAN_AUTO,"zerstorer/trog/bigboom.wav",1,ATTN_NORM);
    DelayedFireDamage_Spawn(self,self.dest,60);
    Quake_Spawn(self,150,5,newmis.origin,TRUE,0.8,VEC_QUAKE);
    SUB_ThinkImmediate(newmis,BecomeBigBangExplosion);
};

//  Explosion Effects.  This enforces air resistance on embers and updates their angles.  NOTE:  Modified flame has ember scene; frames start at 2, ends at 7.
void() Ember_Think = { // [FUNCTION]
    local vector  dir;

    if (self.delay <= time) {
        if (self.walkframe >= 5) {remove (self); return;}

        self.walkframe = self.walkframe + 1;
    }
    self.frame = 28 + self.walkframe;
    dir = normalize (self.velocity);  // Update angles to its current direction.
    self.angles = vectoangles(dir) + '90 0 0';
    self.velocity = self.velocity * 0.75; // Cheap hack -- apply air resistance by reducing velocity.
};

// Throws a shower of embers from 'self'.
void(float ents) Ember_Shower = { // [FUNCTION]
    local entity fire;
    local vector dir;
    local float loop;

    loop = ents * 6;
    while (loop > 0) {
        dir_x = (random() - 0.5) * 180;
        dir_y = random() * 360;
        dir_z = 0;
        makevectors (dir);
        dir = v_forward; // Get initial direction.
        traceline (self.origin, self.origin + dir*64, FALSE, other);
        if (trace_fraction == 1.0) { // Ember will not impact the wall immediately.
            fire = spawn();
            fire.walkframe  = random() * 2 + 2.5;   //4.5;
            fire.walkframe  = floor(fire.walkframe);
            fire.frame      = 28 + fire.walkframe;
            fire.think      = m_ember1;
            fire.solid      = SOLID_BBOX;
            fire.movetype   = MOVETYPE_TOSS;
            fire.owner      = other;
            fire.velocity   = dir * (200 + random() * 800);
            fire.angles     = vectoangles(dir) + '90 0 0';
            fire.delay      = time + 0.5 + random();    // Time when it fades.
            fire.touch      = SUB_Remove;
            fire.nextthink  = time + 0.1;
            setall (fire, "progs/drake/flame2.mdl", '0 0 0', '0 0 0', self.origin);
            ents = ents - 1;
            if (ents <= 0) return;
        }
        loop = loop - 1;
    }
};

// Spawns an ember and smoke in most of its think frames.
void() Smokey_Think = { // [FUNCTION]
	local float ftime;
	local vector spot;

    if (self.wait > time) {
        if (self.enemy.modelindex) {
			ftime = floor(time * 10);
			if (ftime & 1) {
				spot = Midpoint (self.enemy);
				particle (spot, '0 0 100', 1, 5); // Make a thin trail of smoke above the flame, plus a few embers.
				if ((ftime & 2) && !InLiquid(spot)) MakeFlame (self.enemy);
			}
			self.nextthink = time + 0.1;
			return;
		}
	}
    remove(self);
};

// This creates an entity that produces smoke and a few embers around a given target 'ent'.  Used on targets that die from burning.
void(entity ent) Smokey = { // [FUNCTION]
    newmis = spawn();
    newmis.solid      = SOLID_NOT;
    newmis.takedamage = DAMAGE_NO;
    newmis.enemy      = ent;
    newmis.wait       = time + 1 + random() * 2;
    newmis.nextthink  = 0.01;
    newmis.think      = Smokey_Think;
    setall (newmis, "", '0 0 0', '0 0 0', VEC_ORIGIN);
};

//  This extinguishes the fire burning on a player (or other entity).  This function should be called whenever the fire burning on an entity must be removed immediately.
//  Examples who and when this should be called for:
//  * All players (and their minions) when the level ends.
//  * Anytime a player respawns after dying (from the 'kill' command).
//
//  Assumptions (i.e., leaps of faith):
//  * If ent == world, then ent.burner is always world (FALSE).
//  * If ent.burner is not the world, then ent.burner really is a flame.  If not, bad things will likely happen.
//
//  Update:  Since burning is back to the old Napalm style, always use this function to remove any flame pointed by ent.burner.
void(entity ent) Burn_Null = { // [FUNCTION]
	if (!ent) return;
	ResetDebuffBurning(ent);
    if (ent.burner) { // Note:  non-zero cnt means flame is underwater.
        if (ent.modelindex && !ent.burner.cnt) { // Transform flame into a small explosion.
            ent.burner.effects = EF_MUZZLEFLASH;    // No more dynamic light after the puff.
            SUB_ThinkImmediate (ent.burner, BecomeExplosion);
        } else remove(ent.burner); // Disappear right now.
        ent.burner = world;
    }
};

// Returns the point where a flame should burn, hopefully on its target.
vector(entity ent) Burn_Point = { // [FUNCTION]
	// Well this is kind of hacky, zombies had flames floating in air otherwise which looked dumb.
	if (ent.classtype == CT_MONZOMBIEK) {
		if (ent.frame == 102) return ent.origin + '0 0 -4'; // check paind
		else if (ent.frame == 103) return ent.origin + '0 0 -6';
		else if (ent.frame == 104) return ent.origin + '0 0 -8';
		else if (ent.frame == 105) return ent.origin + '0 0 -24';
		else if (ent.frame == 106) return ent.origin + '0 0 -24';
		else if (ent.frame == 107) return ent.origin + '0 0 -24';
		else if (ent.frame == 108) return ent.origin + '0 0 -24';
		else if (ent.frame == 109) return ent.origin + '0 0 -24';
		else if (ent.frame == 110) return ent.origin + '0 0 -24';
		else if (ent.frame == 111) return ent.origin + '0 0 -24';
		else if (ent.frame == 112) return ent.origin + '0 0 -23';
		else if (ent.frame == 113) return ent.origin + '0 0 -18';
		else if (ent.frame == 114) return ent.origin + '0 0 -12';
		else if (ent.frame == 115) return ent.origin + '0 0 -8';
		else if (ent.frame == 116) return ent.origin + '0 0 -4';
		else if (ent.frame == 117) return ent.origin + '0 0 -4';
		else if (ent.frame == 118) return ent.origin + '0 0 -4';
		else if (ent.frame == 119) return ent.origin + '0 0 -4';
		else if (ent.frame == 120) return ent.origin + '0 0 -4';
		else if (ent.frame == 125) return ent.origin + '0 0 -2';  // Now for paine
		else if (ent.frame == 126) return ent.origin + '0 0 -10';
		else if (ent.frame == 127) return ent.origin + '0 0 -24';
		else if (ent.frame == 128) return ent.origin + '0 0 -24';
		else if (ent.frame == 129) return ent.origin + '0 0 -24';
		else if (ent.frame == 130) return ent.origin + '0 0 -24';
		else if (ent.frame == 131) return ent.origin + '0 0 -24';
		else if (ent.frame == 132) return ent.origin + '0 0 -24';
		else if (ent.frame == 133) return ent.origin + '0 0 -24';
		else if (ent.frame == 134) return ent.origin + '0 0 -24';
		else if (ent.frame == 135) return ent.origin + '0 0 -24';
		else if (ent.frame == 136) return ent.origin + '0 0 -24';
		else if (ent.frame == 137) return ent.origin + '0 0 -24';
		else if (ent.frame == 138) return ent.origin + '0 0 -24';
		else if (ent.frame == 139) return ent.origin + '0 0 -24';
		else if (ent.frame == 140) return ent.origin + '0 0 -23';
		else if (ent.frame == 141) return ent.origin + '0 0 -18';
		else if (ent.frame == 142) return ent.origin + '0 0 -16';
		else if (ent.frame == 143) return ent.origin + '0 0 -12';
		else if (ent.frame == 144) return ent.origin + '0 0 -8';
		else if (ent.frame == 145) return ent.origin + '0 0 -2';
	}

	if (ent.classtype == CT_MONZOMBIE) {
		if (ent.frame == 102) return ent.origin + '0 0 -4'; // check painb
		else if (ent.frame == 103) return ent.origin + '0 0 -2';
		else if (ent.frame == 104) return ent.origin + '0 0 -8';
		else if (ent.frame == 105) return ent.origin + '0 0 -14';
		else if (ent.frame == 106) return ent.origin + '0 0 -18';
		else if (ent.frame == 107) return ent.origin + '0 0 -22';
		else if (ent.frame == 108) return ent.origin + '0 0 -24';
		else if (ent.frame == 109) return ent.origin + '0 0 -24';
		else if (ent.frame == 110) return ent.origin + '0 0 -24';
		else if (ent.frame == 111) return ent.origin + '0 0 -24';
		else if (ent.frame == 112) return ent.origin + '0 0 -24';
		else if (ent.frame == 113) return ent.origin + '0 0 -23';
		else if (ent.frame == 114) return ent.origin + '0 0 -21';
		else if (ent.frame == 115) return ent.origin + '0 0 -20';
		else if (ent.frame == 116) return ent.origin + '0 0 -20';
		else if (ent.frame == 117) return ent.origin + '0 0 -20';
		else if (ent.frame == 118) return ent.origin + '0 0 -18';
		else if (ent.frame == 119) return ent.origin + '0 0 -18';
		else if (ent.frame == 120) return ent.origin + '0 0 -18';
		else if (ent.frame == 121) return ent.origin + '0 0 -18';
		else if (ent.frame == 122) return ent.origin + '0 0 -16';
		else if (ent.frame == 123) return ent.origin + '0 0 -12';
		else if (ent.frame == 124) return ent.origin + '0 0 -8';
		else if (ent.frame == 125) return ent.origin + '0 0 -2';
		else if (ent.frame == 132) return ent.origin + '0 0 -2';
		else if (ent.frame == 133) return ent.origin + '0 0 -8';
		else if (ent.frame == 134) return ent.origin + '0 0 -14';
		else if (ent.frame == 135) return ent.origin + '0 0 -14';
		else if (ent.frame == 136) return ent.origin + '0 0 -14';
		else if (ent.frame == 137) return ent.origin + '0 0 -14';
		else if (ent.frame == 138) return ent.origin + '0 0 -14';
		else if (ent.frame == 139) return ent.origin + '0 0 -14';
		else if (ent.frame == 140) return ent.origin + '0 0 -14';
		else if (ent.frame == 141) return ent.origin + '0 0 -12';
		else if (ent.frame == 142) return ent.origin + '0 0 -6';
		else if (ent.frame == 143) return ent.origin + '0 0 -3';
		else if (ent.frame == 163) return ent.origin + '0 0 4'; // Now for paind
		else if (ent.frame == 164) return ent.origin + '0 0 2';
		else if (ent.frame == 167) return ent.origin + '0 0 -8';
		else if (ent.frame == 168) return ent.origin + '0 0 -16';
		else if (ent.frame == 169) return ent.origin + '0 0 -20';
		else if (ent.frame == 170) return ent.origin + '0 0 -22';
		else if (ent.frame == 171) return ent.origin + '0 0 -24';
		else if (ent.frame == 172) return ent.origin + '0 0 -24';
		else if (ent.frame == 173) return ent.origin + '0 0 -24';
		else if (ent.frame == 174) return ent.origin + '0 0 -23';
		else if (ent.frame == 175) return ent.origin + '0 0 -24';
		else if (ent.frame == 176) return ent.origin + '0 0 -24';
		else if (ent.frame == 177) return ent.origin + '0 0 -24';
		else if (ent.frame == 178) return ent.origin + '0 0 -23';
		else if (ent.frame == 179) return ent.origin + '0 0 -24';
		else if (ent.frame == 180) return ent.origin + '0 0 -23';
		else if (ent.frame == 181) return ent.origin + '0 0 -24';
		else if (ent.frame == 182) return ent.origin + '0 0 -23';
		else if (ent.frame == 183) return ent.origin + '0 0 -22';
		else if (ent.frame == 184) return ent.origin + '0 0 -21';
		else if (ent.frame == 185) return ent.origin + '0 0 -20';
		else if (ent.frame == 186) return ent.origin + '0 0 -18';
		else if (ent.frame == 187) return ent.origin + '0 0 -19';
		else if (ent.frame == 188) return ent.origin + '0 0 -14';
		else if (ent.frame == 189) return ent.origin + '0 0 -6';
		else if (ent.frame == 190) return ent.origin + '0 0 -4';
	}

    if (ent.view_ofs_z) {
        makevectors(ent.angles);
        if ((ent.burn_ofs_x) || (ent.burn_ofs_z)) return ent.origin + (v_forward*ent.burn_ofs_x) + (v_up*ent.burn_ofs_z);
        return ent.origin + (v_forward*4) + (v_up*16);
    }

    return Midpoint(ent);  // Some entities have origin at 0,0,0.
};

// IMPORTANT:  Burn immunity is NOT the same as fire immunity which is self.resist_fire >= 1 on its own.
float(entity ent) ImmuneToBurning = { // [FUNCTION]
    if (!ent.takedamage) return TRUE; // This includes head gibs and mega-enforcer shields.
    if (ent.resist_fire >= 1) return TRUE; // Immune to fire.
    if (ent.invincible_finished) return TRUE; // Items that prevent burning...
    if (ent.radsuit_finished) return TRUE; // Envirosuit
	if (ent.therm_finished) return TRUE; // Thermal protection suit
	if (ent.moditems & IT_ARTLAVASHIELD) return TRUE; // Lava Shield
    if (ent.cross_finished) return TRUE; // Update 1/6/10:  Cross of Protection
    if (ent.solid == SOLID_BSP) return TRUE; // Flames don't look good on brush entities.
    return FALSE; // BURN BABY BURN!
};

//  This makes the fire cause damage to whom it burns.
void() Burn_Burn = { // [FUNCTION]
    local float damage;
    local entity targ;

    if (self.owner.effects & (EF_DIMLIGHT | EF_BRIGHTLIGHT))
        self.effects = self.effects - (self.effects & EF_DIMLIGHT); // Dynamic lights are slow so turn off the flame's light if the burning entity already has light of its own.
    else
        self.effects = self.effects | EF_DIMLIGHT;

    if (self.delay <= time) { // Burn the target.
        targ = self.owner;
        damage = BURN_PER_SECOND;
        if (damage > self.dmg) damage = self.dmg;

        if (damage > 0) { // Negative damage prevention.
            if (targ.health > 0) { // Don't let burn damage gib the dead.
                if (targ.classgroup == CG_ZOMBIE) T_Damage (targ, targ, self.master, damage + 2, DAMARMOR);    // Update 5/13/10:  More damage to zombies to overcome regeneration.
                else T_Damage (targ, targ, self.master, damage, DAMARMOR);
            }
            T_RadiusDamage (self, self.master, damage, self.owner, DAMAGEALL);
        }

        // Subtract from total... after the damage is done because I want
        // the pain sounds done first before tampering with the flame.
        if (!self.deadflag) {
            self.dmg = self.dmg - damage;
            if (self.dmg < 1) {Burn_Null(targ); return;}
        }
        // The fire can burn again after a moment.
        // Note:  findradius is called once per burning entity, and that
        // can mean many times in horde combat scenarios.  To minimize
        // frequent calling, inflict damage once every second, much like
        // slime bathing, even though I wanted more frequent calls.
        self.delay = time + 1;
    }
};

// Check if the flame should be snuffed, else move flame with the entity it is burning and apply damage.
void() Burn_Think = { // [FUNCTION]
    local entity targ;
    local vector spot;
    local float pc;

    targ = self.owner;
    if (!targ) {remove (self); return;}

    self.nextthink = time + 0.100;
	self.think = Burn_Think;
    if (targ.burner != self) {Burn_Null (targ); return;} // This should not happen.

	if (self.walkframe >= self.pos2_y) self.walkframe = self.pos2_x;
	else self.walkframe = self.walkframe + 1;

	self.frame = self.walkframe;

	// From here on in either mode, the flame goes through a four step process:
	// * Check for flame removal.
	// * Move the flame so that it sticks to its target.
	// * Pick behavior based on its new location (e.g., water snuffs most fires).
	// * If flame is still burning, check for damage to targets.
    if (self.deadflag) { // Death mode uses different burn rules.
        if (self.owner.deadflag >= DEAD_DEAD || self.owner.solid == SOLID_NOT) { Smokey(targ); Burn_Null(targ); return; } // Done burning.

        spot = Burn_Point(self.owner); // Move the flame to its target's center point.
        setorigin (self, spot);
        if (InLiquid(spot)) { // Hide the flame and make steam in its place.  Hiss!!
			setmodel (self, "");
			sound (self, CHAN_AUTO, "player/slimbrn2.wav", 1, ATTN_NORM);
			particle(spot, '0 0 100', 1, 50); 
        } else Burn_Burn(); // Flame is not in the water, keep burning until it's out of fuel.
    } else { // Standard burn mode.
        if (targ.health < 1) {Smokey(targ); Burn_Null(targ); return;} // If enemy is dead, snuff current flame and create smoker that puffs smoke and a few embers for a second or two.
        if (self.dmg < 1) {Burn_Null(targ); return;} // Out of fuel, snuff.
        if (ImmuneToBurning(targ)) {Burn_Null(targ); return;} // Target suddenly can't burn, snuff.

        spot = Burn_Point (targ);
        setorigin (self, spot); // Move the flame.
        pc = pointcontents (spot);
        if (pc <= CONTENT_WATER) { // Check if flame is in the water.
            self.cnt = 1; // Flame disappears instead of exploding.
            Burn_Null(targ); // Snuff it. Sever link between flame and its victim.
            if (pc >= CONTENT_SLIME) { 
                sound (targ, CHAN_AUTO, "player/slimbrn2.wav", 1, ATTN_NORM); // Sizzle
				particle (spot, '0 0 100', 1, 50); // In water or slime, make some steam too.  In lava or sky, just disappear.
            } return;
        }
        Burn_Burn(); // Keep on burning.
    }
};

//  This sets the victim on fire by adding burn damage.
//  Update:  Flames do not stack, so if the victim is already burning,
//  keep the longer burning fire only.  I made the change so I can have
//  flames that can spread to others yet not sustain each other
//  indefinitely.  This style is similar to the Rabies skill in Diablo II.
void(entity victim, entity attacker, float burn) Burn_Add = { // [FUNCTION]
	local vector  spot;

	if (!victim) return;
    if (!victim.takedamage) return; // Check for fire immunity.
	if (victim.resist_fire >= 1) return;
	if (victim.health <= 0) return; // Dead!  Don't add more dynamic light to slow game.
	if (ImmuneToBurning(victim)) return; // Target can't ignite, so stop.  Assumes Napalm (one of my old QC mods) style burns.
    if (burn < 1) return; // No fuel.

	spot = Burn_Point(victim);
	if (InLiquid(spot)) return; // Flame will be out as soon as it spawns, so abort.

    if (victim.burner) {
        if (victim.burner.deadflag) return; // In death mode, so do nothing.
        if (burn < victim.burner.dmg) return; // New fire doesn't last as long, so ignore it.

        if (victim.burner.master != attacker) { // New attacker steals the old fire.
			SpawnExplosion(EXPLODE_SMALL,victim.burner.origin,"");
            victim.burner.master = attacker;
        }
        victim.burner.dmg = burn; // Replace existing with higher value.
		return;
    }

	// Victim is not on fire, so set him alight.
	if (victim.flags & FL_CLIENT) victim.pain_finished = 0; // Hack:  Reset pain for players so they can scream now.
	SpawnExplosion(EXPLODE_SMALL,spot,""); // Flare up with a bang.
	newmis = spawn(); // Spawn burner entity.
	newmis.solid        = SOLID_NOT;
	newmis.takedamage   = DAMAGE_NO;
	newmis.frame = newmis.walkframe = 6;
	newmis.pos2 = '6 16 0.1';
	newmis.effects      = EF_DIMLIGHT;
	newmis.master       = attacker;
	newmis.owner        = victim;
	newmis.classname    = "fire";
	newmis.delay        = time + 1;
	newmis.dmg          = burn; // Initial damage.
	newmis.nextthink    = 0.01;
	newmis.think        = Burn_Think;
	setall (newmis, "progs/drake/flame2.mdl", '0 0 0', '0 0 0', spot);
	newmis.mdl          = newmis.model; // Differentiate between normal and death modes.  Only used by death mode code.
	newmis.deadflag     = 0;            // Use standard burn rules.
	victim.burner = newmis; // Link target to the fire.
};

//  Fireballs
//  Fireballs are flames turned on their side.  In the official GLQuake, this results in a shadow cast somewhere in the air.
//
//  One solution would be to add a fireball scene.  However, that causes
//  animation problems for embers in source ports that support frame
//  interpolation.  In addition, some of the source ports don't let
//  flames cast shadows (which is good).  Hence, no fireball scene.
//
//  Update:  Some ports automatically substitute 'flame2.mdl' with
//  other non-model graphics (decals?), and the projectiles appear more
//  like long flame trails, which look really bad.  Therefore, allow
//  the option for alternate fireball models.  Such models do not look
//  good in vanilla GLQuake or some other ports, but it's better than
//  nothing.

//  This creates steam that has the same velocity of the fireball that spawned it.
void(entity fire) Fireball_Steam = { // [FUNCTION]
    local float sped;
    local vector vel;

    sped = vlen (fire.velocity) * 0.01;
    vel = normalize (fire.velocity) * sped;
    sound (fire, CHAN_AUTO, "player/slimbrn2.wav", 1, ATTN_NORM);
    particle (fire.origin, vel, 1, 50);
};

//  Check if fireball is in the water and if so remove it.  Returns TRUE if fireball was removed.
float(entity fire) Fireball_InWater = { // [FUNCTION]
    local float pc;

    pc = pointcontents (fire.origin);
    if (pc <= CONTENT_WATER)
    if (pc != CONTENT_SKY) { // 8/24/09:  So fire can rain from the sky.
        if ((pc == CONTENT_WATER) || (pc == CONTENT_SLIME)) Fireball_Steam(fire);
        remove(fire);
        return TRUE;
    }
    return FALSE;
};

// This is the end of a fireball's think phase.
void() Fireball_EndFrame = { // [FUNCTION]
    if (Fireball_InWater(self)) return;

    // Check if flame should burn things near it.
    if (self.wait) {
        if (self.wait <= time) { // Burn nearby enemies.
            if (self.owner.resist_fire > 0) T_RadiusDamage (self, self.owner, 1, self.owner, DAMAGEALL); // This is so dragons (or players with powerups) don't hurt themselves with their own flames.
            else T_RadiusDamage (self, self.owner, 1, world, DAMAGEALL); // It's a tiny flame so just do damage, nothing fancy.  Negative radius for the constant damage.
            self.wait = time + random();
        }
	}
    self.nextthink  = time + 0.1; // Fire is still burning, check again on the next frame.
};

// This checks when to put out the fire.  The fire is put out when the burning entity finds water or when the fire is done burning.
void() FloorFire_Think = { // [FUNCTION]
    if (self.delay <= time) { // The fire burns itself out after a period of time.
		particle (self.origin, '0 0 100', 1, 50);
        remove (self);
        return;
    }
    Fireball_EndFrame ();
};

// Spawns a small flame that burns on the ground, if there is ground. If no ground is found, no flame is spawned.  Mostly for show.  Can inflict minor damage to those standing near the flame.
void(entity attacker, entity victim, vector spot) FloorFire = { // [FUNCTION]
    local   entity  swap;

    swap = self;
    self = spawn();
    self.movetype   = MOVETYPE_TOSS;
    self.solid      = SOLID_NOT;
    self.owner      = victim;       // Use 'world' to hit anything.
    setall (self, "", '0 0 0', '0 0 0', spot);
    if (droptofloor ()) {
        self.classname  = "fire";
        self.angles     = '0 0 0';
        self.velocity   = '0 0 0';
        self.owner      = 
        self.master     = attacker;   // Remember who really owns the flame.
        self.delay      = random() * 3 + 2 + time;
        self.wait       =
        self.nextthink  = 0.01;
        self.think      = FloorFire_Think;
        setall (self, "progs/drake/flame2.mdl", '-4 -4 -12', '4 4 16', self.origin + '0 0 12');
    } else {
        remove (self);
    }
    self = swap;
};

// This checks if a flame should drop after a fireball impact.
float(entity fire, float chance) FloorFire_ZoneCheck = { // [FUNCTION]
	local entity ent;
	local vector spot;

    if (random() < chance) {
        if (InLiquid(fire.origin)) return FALSE;       // Don't drop underwater.

        // Drop flame if it is not inside or directly above the owner.
        ent = fire.owner;
        spot = fire.origin;

        // Fire is 4 wide, plus 16 for possible missile clip bouns.
        if (spot_x > (ent.absmax_x + 21))  return TRUE;
        if (spot_y > (ent.absmax_y + 21))  return TRUE;
        if (spot_x < (ent.absmin_x - 21))  return TRUE;
        if (spot_y < (ent.absmin_y - 21))  return TRUE;
        if (spot_z < (ent.absmin_z - 21))  return TRUE;
    }
    return FALSE;
};

// This checks if a fireball impacts the floor.
float() FloorFire_FloorCheck = { // [FUNCTION]
    local vector p1, p2, vel;
    local float dot;

    vel = normalize (self.velocity);
    p1 = self.origin;
    p2 = p1 + (vel * 64);
    traceline (p1, p2, TRUE, world);
    vel = trace_plane_normal;
    dot = vel * '0 0 1';
    return (dot > 0.7071);   // Pass only if slope is less than 45 degrees.
};

// Attempts to spawn a small flame on the ground.  Called by fireballs' touch functions.
void(entity fire, float chance) FloorFire_SpawnCheck = { // [FUNCTION]
    if (FloorFire_ZoneCheck(fire,chance)) {
        if (FloorFire_FloorCheck()) FloorFire(fire.master,fire,fire.origin);
	}
};

// Called when fireball impacts.  On impact, it explodes and inflicts damage.
void() Fireball_Touch = { // [FUNCTION]
    if (pointcontents(self.origin) == CONTENT_SKY) {remove (self); return;} // If it is in the sky, disappear.

    self.velocity = normalize(self.velocity);
    if (Fireball_InWater (self)) return; // If the flame is in water, dissolve into steam.
    if (Reflected ()) return; // NEW:  Rebound if impacting a reflective surface.

    self.touch = SUB_Null; // Stack overflow prevention.
    T_RadiusDamage (self, self.master, self.dmg, other, DAMAGEALL); // Hit something that bleeds.  Update 8/30/09:  Attenuation = Damage / Radius.
    self.origin = self.origin - 8*normalize(self.velocity);
    if (other.takedamage) {
        MakeFlame (other);
        T_Damage (other, self, self.master, self.dmg, DAMARMOR);
    } else FloorFire_SpawnCheck (self, 0.1);

    self.effects = self.effects | EF_MUZZLEFLASH;
    if (self.noise) sound (self, CHAN_AUTO, self.noise, 1, ATTN_NORM);
    BecomeExplosion ();
};

//  This updates the fireball's angles as it flies through the air.
void() Fireball_Update = { // [FUNCTION]
    local vector dir;

    dir = normalize (self.velocity);
    self.angles = vectoangles(dir) + self.pos1; // Update:  Use variable 'self.pos1' instead of always '90 0 0'.
    if (self.walkframe >= self.pos2_y) self.walkframe = self.pos2_x;
	else self.walkframe = self.walkframe + 1;

	self.frame = self.walkframe;
};

//  This gradually shrinks the fireball into nothing as it flies.
void() Fireball_Fade = { // [FUNCTION]
    if (self.frame >= self.delay) {remove (self);  return;}

    self.frame = self.frame + 1;
    Fireball_Update();
    Fireball_EndFrame();
};

//  This checks the fireball as it flies through the air.
void() Fireball_Think = { // [FUNCTION]
    if (self.delay <= time) { // Make the fireball fade into nothing.  Takes 3 frames to fade.
        self.frame  = 29;
        self.delay  = 31;
        self.think  = Fireball_Fade;
    }
    Fireball_Update();
    Fireball_EndFrame();
};

// Create and launch a small fireball.
void(entity attacker, vector start, vector dir, float sped, float damage) Fireball_Launch = { // [FUNCTION]
    newmis = spawn();
    newmis.movetype   = MOVETYPE_FLYMISSILE;
	newmis.classgroup = CG_PROJALL;
    newmis.solid      = SOLID_BBOX;
	newmis.frame = newmis.walkframe = 0;
	newmis.pos2 = '0 5 0.1';
    newmis.angles     = vectoangles(dir) + '90 0 0';
    newmis.speed      = sped;
    newmis.velocity   = dir * sped;
    newmis.touch      = Fireball_Touch;
    newmis.nextthink  = 0.01;
    newmis.think      = Fireball_Think;
    newmis.master = newmis.owner = attacker;
    newmis.delay      = time + 5; // Was (8000 / sped), like in Quake2.
    newmis.wait       = 0;
    newmis.dmg        = damage;
    newmis.classname  = "fire";
    newmis.pos1       = '90 0 0';
    setall(newmis, "progs/drake/flame2.mdl", '0 0 0', '0 0 0', start);
};

//  This fizzles then removes the meteor.
void(entity fire) Meteor_Fizzle = { // [FUNCTION]
    local float pc;

    pc = pointcontents (fire.origin);
    if ((pc == CONTENT_WATER) || (pc == CONTENT_SLIME)) Fireball_Steam (fire);
    remove (fire);
};

//  The fireball explodes then creates a small cloud of fire.
void() Meteor_Explode = { // [FUNCTION]
    local float damage;

	self.classgroup = CG_PROJFIRE; // So anything in radius is set on fire.
    T_RadiusDamage(self, self.master, self.dmg, self.enemy, DAMAGEALL); // Do splash damage first then explode.
	self.classgroup = CG_PROJROCKETS; // So that subsequent damage is halved for shamblers if direct hit.
    self.origin = self.origin - 8*normalize(self.velocity);
    if (self.enemy.takedamage) { // Someone took a direct hit.
        Burn_Add(other, self.master, self.dmg); // Always ignite if burn is enabled.
        damage = SUB_RandomDamage (self.dmg);
        T_Damage(self.enemy, self, self.master, damage, DAMARMOR);
    } else FloorFire_SpawnCheck (self, 1);

    // Make a fiery explosion.
    if (self.dmg >= 80) {
        R_Exp3(self.origin);
		Tent_Explosion(self.origin);
    } else Rocket_Explosion2(self.origin, 96, 16);
    BecomeExplosion2 ();
};

// The large fireball explodes on contact and inflicts severe damage within a radius.
void() Meteor_Touch = { // [FUNCTION]
    if (pointcontents(self.origin) == CONTENT_SKY) {remove (self); return;} // Destroy fireball if it has no power or if it touches the sky.
    if (self.dmg <= 0) {Meteor_Fizzle(self); return;}
    if (Reflected_Damage (COURAGE_DAMAGE)) return; // NEW:  Rebound if impacting a reflective surface.

    self.touch = SUB_Null; // Stack overflow prevention.
    self.enemy = other;
    Meteor_Explode(); // Do the damage.
};

//  This checks the big fireball.  It loses strength if it travels through water.  While active, the fireball leaves behind a trail of steam or embers.
void() Meteor_Think = { // [FUNCTION]
    local float rgb, density;

    rgb = 6; // Default trail is steam.
    density = 16;
    if (InLiquid(self.origin)) {
        self.dmg = self.dmg - 10; // Fireball loses strength in water.  Loses 10 damage per frame.  Used to be 10% damage in Dragons.
        if (self.dmg < 0) self.dmg = 0;
    } else if (!InLiquid(self.oldorigin)) {
        rgb = 233; // Fireball has not been in water lately, so make an ember trail.
        density = 8;
    }
    Meteor_Trail (rgb, density, TRUE); // Particle trail.
    Fireball_Update(); 
    if (self.dmg <= 0) {Meteor_Fizzle(self); return;} // Fizzle if it lost all power.
    if (self.delay < time) {Meteor_Explode (); return;} // The fireball will explode after a period of time.

    self.nextthink  = time + 0.1; // Fire is still burning, check again.
};

// Super-sized Fireballs (a.k.a. Meteor).  This creates a large, highly explosive fireball.
void(entity attacker, vector start, vector dir, float sped, float damage) Meteor_Launch = { // [FUNCTION]
	Fireball_Launch(attacker,start,dir,sped,damage);
    newmis.touch      = Meteor_Touch; // Classgroup is overridden later to ensure stuff sets on fire.
    newmis.think      = Meteor_Think;
    newmis.enemy      = world;
    newmis.effects    = newmis.effects | EF_DIMLIGHT;
    newmis.oldorigin  = start;
};

//  Firewalls
//  The firewall is divided into two major parts:  the spawner and the
//  flames.  The spawner is an invisible missile that spawns flames
//  on the ground below it.  The flames are stationary flame missiles
//  that burn whoever touches them.
//
//  Code derived (and modified) from mummy.hc in Hexen2.
//  In Hexen2, Each flame spawned has 17 frames and lasted about 0.85 sec.
//  With 17 frames, each wall had up to 17 edicts per firewall, and that
//  is way too much for comfort.  In Quake, each for firewall has about
//  seven flames -- a bit high, but hardly any worse than the hell knight
//  missile spray.  To compensate, the damage is higher than in Hexen2.
//
//  Functions below:
//   Firelink_*** = Flames in the firewall.
//   Firewall_*** = Invisible fire spawning missile.

// Animate the flame links in the firewall.
void() Firelink_Think { // [FUNCTION]
    self.walkframe = self.walkframe + 1;
    if (self.walkframe >= self.pos2_y) remove (self);
    else {
		self.frame = self.walkframe;
		particle (self.origin + '0 0 17', '0 0 25', self.volume, self.cnt);
	}
	self.think = Firelink_Think;
	self.nextthink = time + self.pos2_z;
};

// Oh dear!  Someone crossed the firewall.
void() Firelink_Touch = { // [FUNCTION]
    local float damage;

    if (self.wait > time) return; // Already burnt someone recently.
    if (!other.takedamage) return;
    if (other == self.owner) return; // Don't harm attacker.

    if (self.dmg < 1) damage = 1;
    else damage = (random() + 1) * self.dmg;

    T_Damage (other, self, self.master, damage, DAMARMOR);
    self.wait = time + 0.1;    // Wait until then to damage again.
    if (self.t_width < time) {
        sound (self, CHAN_BODY, "drake/weapons/fwallhit.wav", 1, ATTN_NORM); // Play burning sounds.
        self.t_width = time + 0.5;
    }
};

// Assumes 'self' is the firewall spawner missile.
// 'hot' = Spawn fire if TRUE, or spawn steam if FALSE.
void(vector spot, float hot) Firelink_Spawn = { // [FUNCTION]
    local entity fire;

    fire = spawn();
	fire.classgroup = CG_PROJALL;
    fire.owner      = self.owner;
    fire.master     = self.master;
    fire.angles     = self.angles;
    fire.movetype   = MOVETYPE_FLYMISSILE;  // Use for the clip bonus.
    fire.solid      = SOLID_TRIGGER;
    fire.frame = fire.walkframe = 17;
	fire.pos2 = '17 27 0.05';
    fire.wait       = 0;    // Time to burn on touch.
    if (hot) {
        fire.volume     = 233;  // Particle color - embers.
        fire.cnt        = 1;    // Particle count.
        // 17/7 = 2.42857.  Hexen2 dmg was 3.
        fire.dmg        = ceil(self.dmg * 0.075);
        setmodel (fire, "progs/drake/flame2.mdl");
    } else { // It's in liquid so no flame model.
        fire.volume     = 1;    // Steam
        fire.cnt        = 5;
        fire.dmg        = 0;    // Hot spot, minor damage.
        fire.modelindex = 0;    // No model.
    }
    setsize(fire, '0 0 0', '0 0 0');        
    setorigin(fire, spot);
    fire.nextthink  = time + 0.05;
    fire.think      = Firelink_Think;
    fire.touch      = Firelink_Touch;
};

void() Firewall_Think = { // [FUNCTION]
    local float pc;
    local vector spot;

    if (self.delay <= time) {remove (self);  return;}   // Time's up.

    pc = pointcontents (self.origin);
    if (pc == CONTENT_SOLID) {remove (self);  return;}   // In the void.

	if (self.classgroup == CG_PROJCELLS) {
		// Spawn a lightning bolt.
		traceline (self.origin, self.origin + '0 0 4096', TRUE, self);
		spot = trace_endpos;
		LightningBolt(spot,spot - '0 0 8192',self.master,self.dmg,self,TE_LIGHTNING2);
		particle (trace_endpos, trace_plane_normal, 41, 10);
	} else if (self.classgroup == CG_PROJFIRE) {
		// Spawn a flame.
		traceline (self.origin, self.origin - '0 0 600', TRUE, self);
		spot = trace_endpos;
		pc = pointcontents (spot); // Spawn a flame only if there is open space on the ground.
		if (trace_fraction < 1 && pc != CONTENT_SOLID && pc != CONTENT_SKY) Firelink_Spawn(spot,(pc == CONTENT_EMPTY));
	}

    if (self.enemy) { // Steer toward the enemy.
        spot = self.enemy.origin + self.enemy.view_ofs;
		spot = Aim_Line (self.origin, spot, SPEED_FIREWALL, self.enemy); // Change yaw only.  Aim_Line plots intercept course.
		self.ideal_yaw = vectoyaw(spot);
		self.ideal_yaw = anglemod(self.ideal_yaw);
		ChangeYaw();  // Change yaw only.   
        spot = self.angles;
        spot_x = 0 - spot_x;
        makevectors (spot);
        self.movedir  = v_forward; // Update direction.
    }
    self.velocity   = self.movedir * self.speed;
    self.angles     = vectoangles(self.velocity);
    self.nextthink  = time + 0.05;
};

// Explode like Maulotaur firewall. PM:  Don't reflect firewall.
void() Firewall_Touch = { // [FUNCTION]
    local float pass, pc;
    local vector spot, mp;

    pass = 0;
    traceline (self.origin, self.origin - '0 0 600', TRUE, self); // If explosion cannot hit the target, don't explode.
    if (trace_fraction == 1) pass = 1; // No flame on ground.
    else {
        spot = trace_endpos;
        pc = pointcontents (spot);
        if ((pc != CONTENT_EMPTY) && (pc != CONTENT_LAVA))
            pass = 1; // Flame in void, water, or sky.
        else if (other.flags & FLx_CREATURE) {
            if (fabs(other.origin_z - spot_z) > (self.dmg + 40))
                pass = 1; // Too far away to damage.
            else {
                mp = Midpoint (other);
                traceline (spot, mp, TRUE, self);
                if (trace_fraction < 1) pass = 1; // Blocked
            }
        }
    }
    if (pass) { // Explosion ineffective, convert to notouch version.
        self.movetype     = MOVETYPE_NOCLIP;
        self.solid        = SOLID_NOT;
        self.touch        = SUB_Null;
        return;
    }

    self.touch = SUB_Null; // Stack overflow prevention.
    self.enemy = world;
	R_Exp3(spot);
	Tent_Explosion(spot);
	if (other.takedamage) T_Damage(other,other,self.owner,self.dmg,DAMARMOR);
	T_RadiusDamage(self,self.owner,self.dmg,self.owner,DAMAGEALL);
	self.think = SUB_Remove;
	self.nextthink = time + 0.1;
};

void(vector start, vector dir, entity targ, float silent) Firewall_Spawn = { // [FUNCTION]
    newmis = spawn ();
    newmis.master       = newmis.owner      = self;
	newmis.movetype     = MOVETYPE_FLYMISSILE; // Explode if head impacts, similar to Maulotaur version (Heretic's Cyberdemon counterpart).
	newmis.solid        = SOLID_BBOX; // Can't use solid_trigger because of touch link breakage on contact...at least if we don't jump through hoops to avoid breakage.
    newmis.classname    = "fire"; // Use this so zombies burn on death.
	newmis.classgroup   = CG_PROJFIRE;
    newmis.speed        = SPEED_FIREWALL;
    newmis.movedir      = dir;
    newmis.velocity     = dir * SPEED_FIREWALL;
    newmis.angles       = vectoangles(newmis.velocity);
    newmis.dmg          = 80; // Use 120 for Maulotaur strength.
    newmis.enemy        = targ;
    newmis.yaw_speed    = 5;    // Thinks 20/sec, effective yaw_speed of 10.
    newmis.delay        = time + 3;     // Hexen2 used 2.5, not enough here.
    newmis.nextthink    = time + 0.05;
    newmis.think        = Firewall_Think;
    if (newmis.solid) newmis.touch = Firewall_Touch; // Only for Firewall, not Lightwall.
    setall(newmis,"",'0 0 0','0 0 0',start);   // Missile is invisible.
    if (!silent) sound(newmis,CHAN_WEAPON,"drake/weapons/fwall.wav",1,ATTN_NORM);
};

void(float skillaim) FirewallSetup = { // [FUNCTION]
    local vector org, dir;

    self.effects = self.effects | EF_MUZZLEFLASH;
    org = self.origin + self.view_ofs;
    dir = self.enemy.origin + self.enemy.view_ofs;
	if (skillaim) {
		if (skill >= 2) dir = Maim_Line (org, dir, SPEED_FIREWALL, self.enemy, VEC_ORIGIN); // As with Chthon, lead on Hard and up.
		else dir = Maim_Line (org, dir, SPEED_FIREWALL, world, VEC_ORIGIN);
	} else dir = Maim_Line(org,dir,SPEED_FIREWALL,world,'0 0 0');

	self.pos1 = org;
	self.pos2 = dir;
};

// Launch a firewall.  Designed for use by hell lords.
void() M_Firewall = { // [FUNCTION]
	FirewallSetup(TRUE); // Use skill based lead-up aiming.
    Firewall_Spawn(self.pos1,self.pos2,world,FALSE);
	if (skill >= 3) newmis.enemy = self.enemy; // On Nightmare or higher, the firewall seeks the enemy.  This wasn't present in Drake. -Qmaster
};

// Checks if the firewall is effective against an enemy.  Assumed to be called during ai_run and self.th_missile().
float() M_FirewallCheck = { // [FUNCTION]
    if (self.waterlevel) return FALSE;   // Spawnpoint underwater.
    if (!(self.flags & FL_ONGROUND)) return FALSE;   // Not on the ground.

    if (self.enemy) {
        if (self.enemy.waterlevel) return FALSE;       // Underwater.
        if (vlen(self.enemy.origin - self.origin) > 1000) return FALSE;       // Too far away.
        if (!(self.enemy.flags & FL_ONGROUND)) {
            traceline (self.enemy.origin, self.enemy.origin - '0 0 100', TRUE, self.enemy);
            if (trace_fraction == 1) return FALSE;   // High above the ground.
        }
    }
    return TRUE; // Fire away.
};

//  Light Wall.  Shares some with firewall code.  This is invisible and shoots lightning as it moves.
void(vector start, vector dir, entity targ) Lightwall_Spawn = { // [FUNCTION]
	Firewall_Spawn(start,dir,targ,TRUE);
	newmis.classgroup   = CG_PROJCELLS;
    newmis.movetype     = MOVETYPE_NOCLIP; // Pass through all.
    newmis.solid        = SOLID_NOT;
    newmis.classname    = "lightning";
    newmis.dmg          = 15;
    newmis.delay        = time + 6;
    sound(newmis,CHAN_WEAPON,"weapons/lstart.wav",1,ATTN_NORM);
};

// Launch a lightning wall.  Designed for use by storm knights.
void() M_Lightwall = { // [FUNCTION]
	FirewallSetup(FALSE);
    Lightwall_Spawn(self.pos1,self.pos2,world);
    if (skill >= 1) newmis.enemy = self.enemy; // Hack (hknight):  On Normal or higher, the bolt seeks the enemy.
};

// Fireball used by hell knight and baron.
void(vector start, vector dir) KnightBall_Launch = { // [FUNCTION]
    newmis = spawn ();
	newmis.classgroup = CG_PROJROCKETS;
    newmis.master      = newmis.owner     = self;
    newmis.movetype    = MOVETYPE_FLYMISSILE;
    newmis.solid       = SOLID_BBOX;
    newmis.classname   = "fireball";
    newmis.speed       = 1000;
    newmis.velocity    = dir * 1000;
    newmis.angles      = vectoangles(newmis.velocity);
    newmis.avelocity   = '0 0 0';
    newmis.avelocity_z = random()*2000 - 1000;
    newmis.dmg         = 60;
	newmis.pos1		= '60 0 40'; // Base + Random, Splash
    newmis.enemy       = world;
    newmis.touch       = Touch_Missile;
    newmis.nextthink   = time + 5;
    newmis.think       = Orange_Explosion;
    newmis.frame       = 2;
    setall(newmis,"progs/drake/k_ball.mdl",'0 0 0','0 0 0',start);
};

void(vector st, float lo) M_FireKnight = { // [FUNCTION]
    local vector p1, p2, dir;

    makevectors(self.angles);
    p1 = self.origin + (v_forward * st_x) + (v_right * st_y) + (v_up * st_z);
    p2 = Aimpoint (self.enemy);
    if (lo) p2_z = self.enemy.absmin_z + 1;
	dir = normalize(p2 - p1);
    self.effects = self.effects | EF_MUZZLEFLASH;
    sound(self, CHAN_WEAPON, "drake/baron/fireball.wav", 1, ATTN_NORM);
    KnightBall_Launch (p1, dir);
};
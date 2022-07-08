//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
//
// Attributions: Mission Pack 2 (Rogue) and Drake by Patrick Martin
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
// Function count: 11
//
// Implements: Grappling Hook Weapon and Effects
//
// Description:
// Rogue Grapple Implementation heavily modified for Drake.
// Jan'97 by ZOID <zoid@threewave.com>
// Under contract to id software for Rogue Entertainment
// PM: Added grapple support to Drake just in case others want to use it.
// I am not too fond of the grapple since it alters fundamental gameplay
// too much.  It has its uses though.
// Note 9/11/10:  Point is moot now since Tronyn used it in some of his maps.
//=============================================================================

void(entity h) GrappleSever = { // [FUNCTION]
    if (!h) return; // The world is not a hook!

    if (h.master) {
		if (h.master.hook == h) h.count = TRUE;
	}
};

// Remove the grapple and reset the player's grapple hook attachment.
void() GrappleReset = { // [FUNCTION]
    if (self.master) {
		if (self.master.hook == self) {
			self.master.hook = world;
			if (self.master.weapon == IT2_GRAPPLE) {
				if (self.master.attack_finished < (time + 0.2)) self.master.attack_finished = time + 0.2; // Add delay so player has a chance to release button and not shoot another hook immediately.
				if (self.master.flags & FL_CLIENT) self.master.weaponframe = 0;
			}
		}
    }
    remove(self);
};

float() GrappleCutCheck = { // [FUNCTION]
	local vector end;

    end = self.master.origin + '0 0 16';
    if (vlen (end - self.origin) > self.distance) return TRUE; // Exceeded maximum distance.

    traceline(self.origin,end,TRUE,self);
    if (trace_fraction < 1) return TRUE; // Not in line-of-sight.
    return FALSE;
};

void() GrappleTrack = { // [FUNCTION]
    local vector spray;
	local float save, d;

    if (self != self.master.hook) { remove(self);  return;} // PM:  Not using this hook.
    if (!self.state || self.master.health <= 0 || !self.modelindex) { GrappleReset();  return;} // Drop the hook if owner is dead or has released the button.  Update 7/11/09:  ...or has left the level.
    if (frame_pause() && (self.master.flags & FL_CLIENT)) { GrappleReset();  return;} // Player always drop the hook during a cutscene or intermission.
    if (GrappleCutCheck ()) { GrappleReset(); return;} // PM:  Must have a clear path between hook and source.  Do this here instead of the grapple check because this is called only 10/sec while the other is called more often than that.
	if (self.state != 2 && self.enemy.solid <= SOLID_TRIGGER) { GrappleReset();  return;} // Release insubstantial targets.
	if (self.state != 2 && self.enemy.teleport_time > time) { GrappleReset();  return;} // Player teleported away from the grapple.

    if (self.state != 2) {
        self.velocity = '0 0 0';
        self.origin = Midpoint(self.enemy); // It's invisible, but we need this to make the sound come from the right spot.
        setorigin (self, self.origin); // Move the hook along with the player.  
		d = self.dmg;
        if (self.master.tome_finished && self.enemy.flags & FLx_CREATURE) {
			d = self.dmg * 2;
            if (self.dmg > self.enemy.health) save = ceil(self.enemy.health * 0.1);
            else save = ceil(self.dmg * 0.1);

            if ((self.master.perms & POW_VAMPIRE) && (!(self.enemy.classgroup & CG_ZOMBIE))) save = save + ceil(1.2 * save);
			if (save > 0) T_Heal(self.master, save * d, FALSE);
		}
        sound (self, CHAN_WEAPON, "zerstorer/weapons/sawguts.wav", 1, ATTN_NORM); // Use Zerstorer's chainsaw grinding noise.
        T_Damage (self.enemy, self, self.master, d, DAMARMOR);
        spray_x = 100 * crandom();
        spray_y = 100 * crandom();
        spray_z = 100 * crandom() + 50;
        SpawnBlood (self.enemy,self.origin, spray, 20,0);
    } else self.velocity = self.enemy.velocity; // Keep it moving with player's velocity to help physics keep grapple close to player in between thinks.
    self.nextthink = time + 0.1;
};

// Tries to anchor the grapple to whatever it touches
void() GrappleAnchor = { // [FUNCTION]
    local vector org;
    local string sfx;

    if (InSky(self.origin)) { GrappleReset(); return;}
    if (Reflected_Damage(self.dmg)) return;

    if (!self.dmg) self.dmg = 10;
	if (self.master.tome_finished) self.dmg = self.dmg * 2;
    if (!self.cnt) self.cnt = 1;
    self.touch = SUB_Null; // Stack overflow prevention.
    if (other.takedamage || (other.solid != SOLID_BSP)) {   // PM:  Removed teammate immunity.
        if (Armored(other)) sfx = "drake/weapons/clang.wav";
        else if (StoneArmored(other)) sfx = "drake/weapons/axhitwal.wav";
        else if ((self.master.hook == self) && !self.count) sfx = "shambler/smack.wav";
        else  sfx = "zombie/z_hit.wav"; // Not grabbing, so just thump.
    } else {
        sfx = "player/axhit2.wav";
        self.velocity = '0 0 0';
        self.avelocity = '0 0 0';
    }

    sound (self, CHAN_AUTO, sfx, 1, ATTN_NORM);
    if (other.takedamage) {
        spawn_touchblood (self,other,self.dmg);
        T_Damage (other, self, self.master, self.dmg, DAMARMOR);
    }

	// Remove the hook if one of...
	// 1) Button isn't held and grappler is current weapon.
	// 2) Hook hits its master, possible with reflection.
	// 3) Cable was severed.
	// 4) Hook isn't connected with its master.
    if ( (!self.master.button0 && self.weapon == IT2_GRAPPLE && !self.selfweaponismoditems) || (other == self.master) || (self.count) || (self.master.hook != self) ) {
        if (!other.takedamage) {
            org = self.origin - 8*normalize(self.velocity);
            Tent_Point(TE_GUNSHOT,org);
        }
        GrappleReset();
        return;
    }

    if (other.solid == SOLID_BSP) self.state = 2; // Anchored.
    else self.state = TRUE;
    self.dmg   = self.cnt;
	if (self.master.tome_finished) self.dmg = self.dmg * 2;
    self.enemy = other; // remember this guy!
    self.think = GrappleTrack;
    self.nextthink = 0.01;
    self.solid = SOLID_NOT;
};

void() Grapple_Think = { // [FUNCTION]
    if (self.delay < time) { GrappleReset(); return;}

    if (GrappleCutCheck()) {
        GrappleSever (self);
        self.think      = GrappleReset;
        self.nextthink  = self.delay;
    } else self.nextthink  = time + 0.1;
};

void(entity attacker, vector start, vector dir) Grapple_Launch = { // [FUNCTION]
    newmis = spawn();
	newmis.classgroup = CG_PROJALL;
    newmis.movetype = MOVETYPE_FLYMISSILE;
    newmis.solid    = SOLID_BBOX;
    newmis.master   = newmis.owner  = attacker;
    newmis.classname= "hook";
    newmis.count    = FALSE;    // Cable is uncut.
    newmis.state    = FALSE;    // Hook is out flying.
    newmis.movedir  = dir;
    newmis.speed    = 800;
	if (attacker.tome_finished) newmis.speed = 1600;
    newmis.dmg      = 10;
    newmis.cnt      = 2;    // Grind damage.  Was 1.
    newmis.velocity = dir * newmis.speed;
    newmis.avelocity= '0 0 -500';       // PM:  Enabled spin.
    newmis.angles   = vectoangles(dir);
    newmis.touch    = GrappleAnchor;
    newmis.think    = Grapple_Think;
    newmis.delay    = time + 1.5; // Was 2.0, grapple only lives for X seconds, this gives max range on it
    newmis.nextthink= 0.01;
    newmis.distance = 1500; // Maximum cable range.
    newmis.frame    = 1;    // hook spread
    setall (newmis,"progs/drake/hook.mdl",'0 0 0','0 0 0',start);
    if (attacker) attacker.hook = newmis;
};

void() W_FireGrapple = { // [FUNCTION]
    if (self.hook) return; // reject subsequent calls from player.qc

    self.punchangle_x = -2; // bump him
    sound (self, CHAN_WEAPON, "drake/weapons/chain1.wav", 1, ATTN_NORM); // chain out sound (loops)
    makevectors(self.v_angle);
    Grapple_Launch (self, self.origin + v_forward * 16 + '0 0 16', v_forward);
};

entity(entity attacker) Grapple_Pull_Who = { // [FUNCTION]
    local entity targ;

    if (attacker.hook) {
		if (attacker.tome_finished) return attacker; // Always pull the player with tome, it's more fun!
        targ = attacker.hook.enemy;
        if (targ.mass == MASS_LIGHT) return targ;
        if (targ.mass == MASS_MEDIUM) return world;   // No one gets pulled.
    }
    return attacker;
};

float() Grapple_Pull_Me = { // [FUNCTION]
    return (Grapple_Pull_Who(self) == self);
};

// Called each frame by CLIENT.QC if client has a hook.
void() GrappleService = { // [FUNCTION]
    local vector vel;
    local float sped, mx;
    local entity targ, stemp, otemp; // targ is who gets pulled

    if (!self.hook) return;
    if (self.hook.count) return;     // Already severed.

    if (!self.hook.state) { // Hook is flying and not attached to anything yet.
		if (self.tome_finished && (random() < 0.2)) {
			stemp = self;
			self = self.hook; // Throw from hook
			otemp = other;
			other = targ;  
			Ember_Shower(5); // Sparkety spark spark!
			other = otemp;	
			self = stemp;
		}

        // just draw a line to the hook
        if (vlen(self.hook.origin - self.origin) > HOOK_NEAR) QC_ParseBeam(TE_BEAM,"",self.hook,(self.origin + '0 0 16'),self.hook.origin,31);
        if (!self.button0 && self.weapon == IT2_GRAPPLE && !self.selfweaponismoditems) GrappleSever(self.hook);
        return;
    } // From here on, we know the hook is attached to something.

    // PM:  We cannot check cutscene/intermission status here because this function isn't called during such as intermission.  Drop the hook if player lets go of button
    if ((!self.button0 && self.weapon == IT2_GRAPPLE && !self.selfweaponismoditems) || (!(InItems2(self, IT2_GRAPPLE))) || (self.teleport_time > time)) { // PM:  6/10/11:  Sever if weapon is stolen. Can't use grapple while morphed.
        if (self.hook) SUB_ThinkImmediate (self.hook, GrappleReset); // release when we get 'ported
        return;
    }
    
    // PM:  Made to changes to pulling...
    // 1) Smaller monsters are pulled toward the player.
    // 2) Pulling speed was greatly reduced from 1000.
    targ = Grapple_Pull_Who (self);
	if (self.tome_finished && (random() < 0.2)) {
		if (targ != self) {
			stemp = self;
			self = targ; // Throw from the enemy we've hit
			otemp = other;
			other = targ;  
			Ember_Shower(5);
			other = otemp;	
			self = stemp;
		} else { 
			otemp = other; // Throw from the player (self)
			other = self;
			Ember_Shower(5);
			other = otemp;	
		}
	}
    if (targ) {
        makevectors(self.angles);
        vel = self.hook.origin - ( self.origin + (v_up * 16 * (!self.button2)) + (v_forward * 16)); // The jump button bumps the player up a little bit.
        if (targ == self) mx = SPEED_HOOK;
        else { // Pulling target toward attacker.
			mx = 350;
			vel = vel * -1;
		}

		if (self.tome_finished) mx = mx * 2; // Double speed with Tome of Power
        sped = vlen (vel) * 10;
        if (sped > mx) sped = mx; // Was 1000 -- way too fast!
        vel = normalize(vel) * sped;
        targ.velocity = vel;
        targ.flags = targ.flags - (targ.flags & FL_ONGROUND);
    }

    if (vlen(self.hook.origin - self.origin) > HOOK_NEAR) QC_ParseBeam(TE_BEAM,"", self.hook,(self.origin + '0 0 16'),self.hook.origin, 31);
};
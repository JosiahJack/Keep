//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by W. Josiah Jack, aka Qmaster
//
// Attributions: Nehahra, Drake by Patrick Martin
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
// Entity count: 
// Function count: 
//
// Implements: Voidwraith, monster_voidwraith
//
// Description:
// A black ghostly transparent wraith that is not quite on the other side that
// wanders around collecting souls from dead monsters.  Possible to harm using
// magical weapons at which point it can materialize into a solid form in our
// plane of existance and can be fought with normal weapons at that point but
// also harm the player or monster who had inadvertantly harmed it with their
// magical weapon, typically as a result of area of affect radius attacks only
// from magical weapons only.
//
// Collecting souls has no real affect other than for show and creepy mood.
//=============================================================================

void() nehwraith_melee;
void() nehwraith_run1;
void() nehwraith_attack;

void() death_aura = { // [FUNCTION]
	if (self.alpha < 1) return;
	if (other.health < 1) return;
	if (other.takedamage == DAMAGE_NO) return;
	if (self.attack_finished < time) return;

	if (other.flags & FLx_CREATURE) T_Damage(other,self,self,random() * 10,NOARMOR);
	self.attack_finished = time + 0.5;
};

void() nehwraith_souls1  = [ 92,  nehwraith_souls2  ] { // [FUNCTION]
	ai_face();
	if (vlen(self.enemy.origin - self.origin) < 256) self.velocity = '0 0 0';
	else ai_walk(4); 
    sound(self,CHAN_VOICE, "nehahra/wraith/talk1.wav",1,ATTN_IDLE);
    self.gorging = TRUE;
};
void() nehwraith_souls2  = [ 93, nehwraith_souls3  ] { ai_face(); }; // [FUNCTION]
void() nehwraith_souls3  = [ 94, nehwraith_souls4  ] { ai_face(); }; // [FUNCTION]
void() nehwraith_souls4  = [ 95, nehwraith_souls3  ] { // [FUNCTION]
	ai_face();
	if (vlen(self.enemy.origin - self.origin) < 256) self.velocity = '0 0 0';
	else ai_walk(4); 

    if (self.enemy.classtype != CT_SOUL) self.think = nehwraith_run1;
    else self.nextthink = random() * 0.2 + 0.1 + time;
};

void(float d) ai_nehwraith_walk = { // [FUNCTION]
	if (self.health < self.max_health && self.alpha < 1) { // Regenerate a bit if health is low.  Works independently of Regen*.
		if (random() < 0.1) T_Heal(self, 1, FALSE);
	} else {
		if (self.attack_state == AS_FLEEING) { // self.enemy only in Nehahra.
			sound(self,CHAN_VOICE, "nehahra/wraith/speak.wav",1,ATTN_IDLE);
			sound(self.enemy,CHAN_VOICE, "nehahra/wraith/speak.wav",1,ATTN_IDLE);
			self.attack_state = AS_CHASING;
		}
	}

	if (Wraith_FindSoul()) return;

    ai_walk(d);
};
void() nehwraith_walk1  = [ 65,  nehwraith_walk2  ] { ai_nehwraith_walk(6); monster_idle_sound(); }; // [FUNCTION]
void() nehwraith_walk2  = [ 66,  nehwraith_walk3  ] { ai_nehwraith_walk(6); }; // [FUNCTION]
void() nehwraith_walk3  = [ 67,  nehwraith_walk4  ] { ai_nehwraith_walk(6); }; // [FUNCTION]
void() nehwraith_walk4  = [ 68,  nehwraith_walk5  ] { ai_nehwraith_walk(6); }; // [FUNCTION]
void() nehwraith_walk5  = [ 69,  nehwraith_walk6  ] { ai_nehwraith_walk(6); }; // [FUNCTION]
void() nehwraith_walk6  = [ 70,  nehwraith_walk7  ] { ai_nehwraith_walk(6); }; // [FUNCTION]
void() nehwraith_walk7  = [ 71,  nehwraith_walk8  ] { ai_nehwraith_walk(6); }; // [FUNCTION]
void() nehwraith_walk8  = [ 72,  nehwraith_walk9  ] { ai_nehwraith_walk(6); }; // [FUNCTION]
void() nehwraith_walk9  = [ 73,  nehwraith_walk10 ] { ai_nehwraith_walk(6); }; // [FUNCTION]
void() nehwraith_walk10 = [ 74, nehwraith_walk11 ] { ai_nehwraith_walk(6); }; // [FUNCTION]
void() nehwraith_walk11 = [ 75, nehwraith_walk12 ] { ai_nehwraith_walk(6); }; // [FUNCTION]
void() nehwraith_walk12 = [ 76, nehwraith_walk13 ] { ai_nehwraith_walk(6); }; // [FUNCTION]
void() nehwraith_walk13 = [ 77, nehwraith_walk14 ] { ai_nehwraith_walk(6); }; // [FUNCTION]
void() nehwraith_walk14 = [ 78, nehwraith_walk1  ] { ai_nehwraith_walk(6); }; // [FUNCTION]

void(float d) ai_nehwraith_run = { // [FUNCTION]
	if (!self.enemy) {
		self.alpha = 0.4;
		self.solid = SOLID_NOT;
		self.movetype = MOVETYPE_NOCLIP;
		if (!FollowSetup()) self.think = self.th_stand; // Return to walking path or standing.
		self.nextthink = time + 0.1;
		return;
	}

	if ((self.alpha < 1 || self.solid != SOLID_SLIDEBOX) && self.enemy) {
		if (self.enemy.classtype == CT_SOUL) {
			if (vlen(self.enemy.origin - self.origin) < 300) { nehwraith_souls1(); return; }
		} else {
			if (!SUB_BBoxInOccupied(self,self.bbmins,self.bbmaxs,self.origin)) {
				self.solid = SOLID_SLIDEBOX;
				self.movetype = MOVETYPE_STEP;
				self.alpha = 1;
			}
		}
	}

    ai_run(d);
};
void() nehwraith_run1   = [ 65,  nehwraith_run2   ] { ai_nehwraith_run(self.speed); monster_idle_sound(); }; // [FUNCTION]
void() nehwraith_run2   = [ 66,  nehwraith_run3   ] { ai_nehwraith_run(self.speed); }; // [FUNCTION]
void() nehwraith_run3   = [ 67,  nehwraith_run4   ] { ai_nehwraith_run(self.speed); }; // [FUNCTION]
void() nehwraith_run4   = [ 68,  nehwraith_run5   ] { ai_nehwraith_run(self.speed); }; // [FUNCTION]
void() nehwraith_run5   = [ 69,  nehwraith_run6   ] { ai_nehwraith_run(self.speed); }; // [FUNCTION]
void() nehwraith_run6   = [ 70,  nehwraith_run7   ] { ai_nehwraith_run(self.speed); }; // [FUNCTION]
void() nehwraith_run7   = [ 71,  nehwraith_run8   ] { ai_nehwraith_run(self.speed); }; // [FUNCTION]
void() nehwraith_run8   = [ 72,  nehwraith_run9   ] { ai_nehwraith_run(self.speed); }; // [FUNCTION]
void() nehwraith_run9   = [ 73,  nehwraith_run10  ] { ai_nehwraith_run(self.speed); }; // [FUNCTION]
void() nehwraith_run10  = [ 74, nehwraith_run11  ] { ai_nehwraith_run(self.speed); }; // [FUNCTION]
void() nehwraith_run11  = [ 75, nehwraith_run12  ] { ai_nehwraith_run(self.speed); }; // [FUNCTION]
void() nehwraith_run12  = [ 76, nehwraith_run13  ] { ai_nehwraith_run(self.speed); }; // [FUNCTION]
void() nehwraith_run13  = [ 77, nehwraith_run14  ] { ai_nehwraith_run(self.speed); }; // [FUNCTION]
void() nehwraith_run14  = [ 78, nehwraith_run1   ] { ai_nehwraith_run(self.speed); }; // [FUNCTION]

// For those summoned by Dark Lord.
void() nehwraith_grow1  = [ 8,  nehwraith_grow2  ] { ai_face(); }; // [FUNCTION]
void() nehwraith_grow2  = [ 10, nehwraith_grow3  ] { ai_face(); }; // [FUNCTION]
void() nehwraith_grow3  = [ 12, nehwraith_grow4  ] { ai_face(); }; // [FUNCTION]
void() nehwraith_grow4  = [ 14, nehwraith_grow5  ] { ai_face(); }; // [FUNCTION]
void() nehwraith_grow5  = [ 16, nehwraith_run1   ] { ai_face(); }; // [FUNCTION]

// ATTACK.  Like ai_melee, but heals wrath as it causes damage.  Built for wraths.
void() ai_drain = { // [FUNCTION]
    local float damage, rgb, den;
    local vector vec;

    if (!self.enemy) return;
    if (!InMeleeRange(80)) return; // Wrath has long arms.
    if (self.alpha < 1 || !CanDamage(self.enemy,self)) return;

    if (self.classtype == CT_MONWRAITHNEHAHRA) rgb = 145; // Purple for wraith.
    else rgb = 233; // Orange for wrath.

    damage = SUB_MeleeDamage (3);
    den = ceil(damage * 4);
    self.effects = self.effects | EF_MUZZLEFLASH;
    if (!self.t_width) sound(self,CHAN_WEAPON,"drake/wraith/drain.wav",1,ATTN_NORM); // Play effects.
    self.t_width = self.t_width + 1;
    makevectors(self.angles);
    vec = self.origin + (v_forward*47) + (v_right*6) + (v_up*10);
	if (den > 254) den = 254;
    particle(vec, '0 0 1', rgb, den);
    T_Damage(self.enemy, self, self, damage, NOARMOR); // No armor, because armor cannot block incorporal attacks.  Leech, because the wraith will suck and drain your life force.
};

void() nehwraith_fail1   = [ 101,  nehwraith_fail2  ] { ai_charge(self.speed); }; // [FUNCTION]
void() nehwraith_fail2   = [ 91,  nehwraith_fail3   ] { ai_charge(self.speed); }; // [FUNCTION]
void() nehwraith_fail3   = [ 92,  nehwraith_run1    ] { ai_charge(self.speed); }; // [FUNCTION]

void() nehwraith_melee1  = [ 92,  nehwraith_melee2  ] { ai_charge(self.speed); }; // [FUNCTION]
void() nehwraith_melee2  = [ 93,  nehwraith_melee3  ] { ai_charge(self.speed); }; // [FUNCTION]
void() nehwraith_melee3  = [ 94,  nehwraith_melee4  ] { ai_charge(self.speed); }; // [FUNCTION]
void() nehwraith_melee4  = [ 95,   nehwraith_melee5  ] { ai_charge(self.speed); self.t_width = 0; ai_drain(); }; // [FUNCTION]
void() nehwraith_melee5  = [ 96,   nehwraith_melee6  ] { ai_charge(self.speed); ai_drain(); }; // [FUNCTION]
void() nehwraith_melee6  = [ 95,   nehwraith_melee7  ] { ai_charge(self.speed); ai_drain(); // [FUNCTION]
    if (self.t_width) { // Wraith touched its target.
        if (self.t_width < 5)
            if (self.enemy.health > 0)
                if (InMeleeRange (80)) self.think = nehwraith_melee6;     // Suck some more life.
        return;
    }
    self.think = nehwraith_fail1;
};
void() nehwraith_melee7  = [ 96,   nehwraith_melee8  ] { ai_charge(self.speed); }; // [FUNCTION]
void() nehwraith_melee8  = [ 95,   nehwraith_melee9  ] { ai_charge(self.speed); }; // [FUNCTION]
void() nehwraith_melee9  = [ 96,   nehwraith_melee10 ] { ai_charge(self.speed); }; // [FUNCTION]
void() nehwraith_melee10 = [ 97,   nehwraith_melee11 ] { ai_charge(self.speed); }; // [FUNCTION]
void() nehwraith_melee11 = [ 98,   nehwraith_melee12 ] { ai_charge(self.speed); }; // [FUNCTION]
void() nehwraith_melee12 = [ 100,   nehwraith_melee13 ] { ai_charge(self.speed); }; // [FUNCTION]
void() nehwraith_melee13 = [ 95,   nehwraith_melee14 ] { ai_charge(self.speed); }; // [FUNCTION]
void() nehwraith_melee14 = [ 93,   nehwraith_run1    ] { ai_charge(self.speed); }; // [FUNCTION]

void(float ofs) nehwraith_shot = { // [FUNCTION]
    local vector dir, org;

	if (self.alpha < 1) return; // Not when in ghost mode, only after "crossing over" to our "side".

    dir = vectoangles(self.enemy.origin - self.origin);
    dir_y = dir_y + ofs * 6;
    makevectors(dir);
    dir = normalize (v_forward);
    dir_z = 0 - dir_z + (random() - 0.5)*0.1;
    dir = Maim_Scatter(dir,'0 0 0'); // Added for invisibility.
    org = self.origin + self.mins + self.size*0.5 + v_forward * 20;
	launch_projectile(org,dir,NO_SPIN,CT_PROJ_HKN,600);
    newmis.worldtype = TE_KNIGHTSPIKE;
    newmis.classname = "knightspike";
    if (self.alpha < 1) { // Wraith
        sound(self,CHAN_WEAPON,"nehahra/baron/throb.wav",1,ATTN_NORM);
        setmodel(newmis, "progs/nehahra/wr_spike.mdl");
        setsize(newmis, VEC_ORIGIN, VEC_ORIGIN);
        if (self.classtype == CT_MONDREADWRAITH) newmis.velocity = normalize(newmis.velocity)*600;
        else if (self.frame >= 94 && self.frame <= 96) newmis.velocity = normalize(newmis.velocity)*450;
        else newmis.velocity = normalize(newmis.velocity)*300; // Assume shots were sweated out passively.
    } else {
        sound(self,CHAN_WEAPON,"hknight/attack1.wav",1,ATTN_NORM);
        setmodel(newmis, "progs/k_spike.mdl");
        setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);
        if (self.classtype == CT_MONWRATHOVERLORD) newmis.velocity = normalize(newmis.velocity)*450;
        else newmis.velocity = normalize(newmis.velocity)*300;
    }
};

void() ai_nehwraith_charge = { // [FUNCTION]
    if (self.attack_state == AS_FLEEING) ai_face();
    else ai_charge(self.speed);
};

void() nehwraith_spray1  = [ 92, nehwraith_spray2  ] { ai_nehwraith_charge(); }; // [FUNCTION]
void() nehwraith_spray2  = [ 94, nehwraith_spray3  ] { ai_nehwraith_charge();nehwraith_shot(0); }; // [FUNCTION]
void() nehwraith_spray3  = [ 96, nehwraith_spray4  ] { ai_nehwraith_charge();nehwraith_shot(-1);nehwraith_shot(1); }; // [FUNCTION]
void() nehwraith_spray4  = [ 100, nehwraith_spray5  ] { ai_nehwraith_charge();nehwraith_shot(-2);nehwraith_shot(2); }; // [FUNCTION]
void() nehwraith_spray5  = [ 101, nehwraith_spray6  ] { ai_nehwraith_charge(); }; // [FUNCTION]
void() nehwraith_spray6  = [ 99,  nehwraith_spray7  ] { ai_nehwraith_charge(); }; // [FUNCTION]
void() nehwraith_spray7  = [ 98,  nehwraith_spray8  ] { ai_nehwraith_charge(); }; // [FUNCTION]
void() nehwraith_spray8  = [ 97,  nehwraith_spray9  ] { ai_nehwraith_charge(); }; // [FUNCTION]
void() nehwraith_spray9  = [ 96,  nehwraith_spray10 ] { ai_nehwraith_charge(); }; // [FUNCTION]
void() nehwraith_spray10 = [ 95,  nehwraith_spray11 ] { ai_nehwraith_charge(); }; // [FUNCTION]
void() nehwraith_spray11 = [ 94,  nehwraith_spray12 ] { ai_nehwraith_charge(); }; // [FUNCTION]
void() nehwraith_spray12 = [ 93,  nehwraith_spray13 ] { ai_nehwraith_charge(); }; // [FUNCTION]
void() nehwraith_spray13 = [ 92,  nehwraith_spray14 ] { ai_nehwraith_charge(); }; // [FUNCTION]
void() nehwraith_spray14 = [ 80,  nehwraith_run1    ] { ai_nehwraith_charge(); }; // [FUNCTION]

void() nehwraith_orb1  = [ 102,  nehwraith_orb2  ] { ai_nehwraith_charge(); }; // [FUNCTION]
void() nehwraith_orb2  = [ 91,  nehwraith_orb3  ] { ai_nehwraith_charge(); }; // [FUNCTION]
void() nehwraith_orb3  = [ 84,  nehwraith_orb4  ] { ai_nehwraith_charge(); }; // [FUNCTION]
void() nehwraith_orb4  = [ 83,  nehwraith_orb5  ] { ai_nehwraith_charge(); }; // [FUNCTION]
void() nehwraith_orb5  = [ 82,  nehwraith_orb6  ] { ai_nehwraith_charge(); }; // [FUNCTION]
void() nehwraith_orb6  = [ 83,  nehwraith_orb7  ] { ai_nehwraith_charge(); }; // [FUNCTION]
void() nehwraith_orb7  = [ 84,  nehwraith_orb8  ] { // [FUNCTION]
	ai_nehwraith_charge();
    if (self.skin) { // Note:  Was done in the previous frame
		self.effects = self.effects | EF_MUZZLEFLASH;
		sound(self,CHAN_WEAPON,"drake/hkboss/iceball.wav",1,ATTN_NORM);
		self.attack_speed = SPEED_SHALMISSILE + (skill * SPEED_SHALSKILL);
		makevectors(self.angles);
		launch_projectile(self.origin + attack_vector('18 0 10'),'0 0 10',NO_SPIN,CT_PROJ_SHAL,self.attack_speed);
		newmis.dmg = 30;
    } else WrathMissile(2);
};
void() nehwraith_orb8  = [ 102,  nehwraith_orb9  ] { ai_nehwraith_charge(); }; // [FUNCTION]
void() nehwraith_orb9  = [ 85,  nehwraith_orb10 ] { ai_nehwraith_charge(); }; // [FUNCTION]
void() nehwraith_orb10 = [ 87, nehwraith_orb11 ] { ai_nehwraith_charge(); }; // [FUNCTION]
void() nehwraith_orb11 = [ 90, nehwraith_orb12 ] { ai_nehwraith_charge(); }; // [FUNCTION]
void() nehwraith_orb12 = [ 82, nehwraith_orb13 ] { ai_nehwraith_charge(); }; // [FUNCTION]
void() nehwraith_orb13 = [ 80, nehwraith_run1  ] { ai_nehwraith_charge(); }; // [FUNCTION]

// Rubberbanding animations sucks, beats writing 100+ functions for it
void() nehwraith_stand1 = [self.walkframe, nehwraith_stand1] { // [FUNCTION]
	if (self.state == 0) {
		// Right
		if (self.lefty) {
			if (self.walkframe <= 18) {
				self.state = 1; // Left
				self.walkframe = 40; // one less since we still add one immediately
				self.cnt = 1;
				self.lefty = 0;
			}
		} else {
			if (self.walkframe >= 40) {
				self.lefty = 1;
				self.cnt = -1;
			}
		}
		self.walkframe = self.walkframe + self.cnt;
	} else {
		// Left
		if (self.lefty) {
			if (self.walkframe <= 41) {
				self.state = 0; // Right
				self.walkframe = 17; // one less since we still add one immediately
				self.cnt = 1;
			}
		} else {
			if (self.walkframe >= 64) {
				self.lefty = 1;
				self.cnt = -1;
			}
		}
		self.walkframe = self.walkframe + self.cnt;
	}
	ai_stand();
	if (Wraith_FindSoul()) { self.th_walk(); return; }
};

void() nehwraith_attack = { // [FUNCTION]
    local float r;

	if (self.alpha < 1) return;

    r = random();
    if (r < 0.5) nehwraith_spray1();
    else { // Nehahra wraith spontaneously sweated out bullets some of the time.
        r = crandom() * 1;  //3;
        nehwraith_shot(r);
    }
};

void() nehwraith_melee = { // [FUNCTION]
    local float chance;

	if (self.alpha < 1) return;

    if (InMeleeRange (80))  chance = 0.75;
    else chance = 0.5;

    if (random() < chance) nehwraith_melee1();
    else nehwraith_attack();
};

void() nehwraith_pain1 = [ 79,  nehwraith_pain2 ] {}; // [FUNCTION]
void() nehwraith_pain2 = [ 80,  nehwraith_pain3 ] {}; // [FUNCTION]
void() nehwraith_pain3 = [ 81,  nehwraith_pain4 ] {}; // [FUNCTION]
void() nehwraith_pain4 = [ 82,  nehwraith_pain5 ] {}; // [FUNCTION]
void() nehwraith_pain5 = [ 83,  nehwraith_pain6 ] {}; // [FUNCTION]
void() nehwraith_pain6 = [ 84,  nehwraith_run1  ] {}; // [FUNCTION]

void() nehwraith_painb6  = [ 85,  nehwraith_painb7  ] {}; // [FUNCTION]
void() nehwraith_painb7  = [ 86,  nehwraith_painb8  ] {}; // [FUNCTION]
void() nehwraith_painb8  = [ 87,  nehwraith_painb9  ] {}; // [FUNCTION]
void() nehwraith_painb9  = [ 88,  nehwraith_painb10 ] {}; // [FUNCTION]
void() nehwraith_painb10 = [ 89, nehwraith_painb11 ] {}; // [FUNCTION]
void() nehwraith_painb11 = [ 90, nehwraith_painb12 ] {}; // [FUNCTION]
void() nehwraith_painb12 = [ 91, nehwraith_run1    ] {}; // [FUNCTION]

void() nehwraith_materialize = { // [FUNCTION]
	ai_face();
	if (!walkmove(self.ideal_yaw, 8) || pointcontents(self.origin) == CONTENT_SOLID) {  // If we collide, keep moving towards player and check again.
		self.solid = SOLID_NOT;
		setmodel(self,"");
		setsize(self, VEC_ORIGIN, VEC_ORIGIN);
		self.think = nehwraith_materialize;
		self.nextthink = time + 0.1;
		return;
	}

	self.gorging = FALSE;   // Get out of reaper mode to stop eating souls.
	self.alpha = 1;
	self.velocity = '0 0 0';
	self.movetype = MOVETYPE_STEP;
	self.solid = SOLID_SLIDEBOX; // Switch on world interaction
	setmodel(self, self.mdl); // restore model/bbox to get world collision
	setsize (self, self.bbmins, self.bbmaxs);
	setorigin(self, self.oldorigin);
	self.think = self.th_run;
	self.nextthink = time + 0.1;
};

// Note:  In Nehahra, wraiths always bleed when hurt.  Not in Drake.
void(entity inflictor, entity attacker, float damage) nehwraith_pain = { // [FUNCTION]
	if (self.pain_finished > time) return; // Still reeling from pain last time.

	self.pain_finished = time + 5;
    if (self.health < WRAITH_HP_CRITICAL) self.attack_state = AS_FLEEING; // Run away only if using soul ai.  Makes 100% kills too hard if wraith gets away.
    if (random() < 0.5)  sound(self,CHAN_VOICE, "nehahra/wraith/growl2.wav",1,ATTN_NORM);
	else sound(self,CHAN_VOICE, "nehahra/wraith/idle2.wav",1,ATTN_NORM);

	if (self.alpha < 1 && ((inflictor.flags & FLx_CREATURE) || (attacker.flags & FLx_CREATURE))) { nehwraith_materialize(); return; } // Change from ghost to corporeal.
    if (SUB_IgnorePain()) return; // No pain anims in Nightmare.
    if (random() < 0.4) return;

    self.gorging = FALSE; // Get out of reaper mode to stop eating souls.
    if (random() < 0.05 && self.alpha < 1) nehwraith_painb6(); // Now do the standard pain routine.
    else nehwraith_pain1();
};

void() nehwraith_die1  = [ 102, nehwraith_die2  ] { self.solid = SOLID_NOT; }; // [FUNCTION]
void() nehwraith_die2 = [ 104,  nehwraith_die3  ] {}; // [FUNCTION]
void() nehwraith_die3 = [ 106,  nehwraith_die4  ] {}; // [FUNCTION]
void() nehwraith_die4 = [ 108,  nehwraith_die5  ] {}; // [FUNCTION]
void() nehwraith_die5 = [ 110,  nehwraith_die6  ] {}; // [FUNCTION]
void() nehwraith_die6 = [ 112,  nehwraith_die7  ] {}; // [FUNCTION]
void() nehwraith_die7 = [ 114, nehwraith_die8  ] {}; // [FUNCTION]
void() nehwraith_die8 = [ 116, nehwraith_die9  ] {}; // [FUNCTION]
void() nehwraith_die9 = [ 118, SUB_Null    ] { // [FUNCTION]
    monster_ThrowGib();
    T_RadiusDamage(self, self, 80, world,DAMAGEALL);
    Rocket_Explosion2 (self.origin + '0 0 24', 0, 4);
	entity_hide(self);
};

void() nehwraith_die = { // [FUNCTION]
	monster_death_precheck(); // Pre-check routine to tidy up extra entities
	self.think = nehwraith_die1;
    self.nextthink  = 0.01;
    self.modelindex = self.mindex2;
    self.takedamage = DAMAGE_NO;
    self.movetype = MOVETYPE_NONE;  // Freeze monster in place.
    if (random() < 0.2) sound(self,CHAN_VOICE, "nehahra/wraith/talk3.wav",1,ATTN_NORM);
    else sound(self,CHAN_VOICE, "nehahra/wraith/call.wav",1,ATTN_NORM);
};

void() monster_voidwraith_precache = { // [FUNCTION]
	precache_model("progs/nehahra/wraith.mdl");
	precache_model("progs/null.spr");
	precache_model("progs/nehahra/wr_spike.mdl");
	precache_model("progs/nehahra/soul.mdl");
    precache_model("progs/drake/v_spike.mdl");
    precache_model("progs/drake/w_ball.mdl");
	precache_sound("nehahra/wraith/soul.wav");
	precache_sound("nehahra/wraith/idle.wav");
	precache_sound("nehahra/wraith/idle2.wav");
	precache_sound("nehahra/baron/throb.wav");
	precache_sound("nehahra/wraith/rych1.wav");
	precache_sound("nehahra/wraith/call.wav");
	precache_sound("nehahra/wraith/talk1.wav");
	precache_sound("nehahra/wraith/weird.wav");
	precache_sound("nehahra/wraith/speak.wav");
	precache_sound("nehahra/wraith/growl2.wav");
	precache_sound("nehahra/wraith/talk3.wav");
	precache_sound("nehahra/wraith/return.wav");
	precache_sound("nehahra/wraith/select.wav");
    precache_sound("drake/hkboss/iceball.wav");
    precache_sound("hknight/attack1.wav");
    precache_sound("drake/wraith/drain.wav");
	if (ext_dppart) particleeffectnum(DPP_TEVORESPIKE); 
};

void() monster_voidwraith = { // [ENTITY]
	if (monster_checkrandomizer() == TRUE) return; // Check for any random monster setups

	if (!self.mdl) self.mdl = "progs/nehahra/wraith.mdl";
	if (!self.mdl) self.gib1mdl = "progs/rogue/wrthgib1.mdl";
	if (!self.mdl) self.gib2mdl = "progs/rogue/wrthgib2.mdl";
	if (!self.mdl) self.gib3mdl = "progs/rogue/wrthgib3.mdl";
	self.sight_sound = "nehahra/wraith/talk1.wav";
	self.hello_sound = "nehahra/wraith/idle.wav";
	self.idle_sound = "nehahra/wraith/idle.wav";
	self.idle_sound2 = "nehahra/wraith/idle2.wav";
	self.idle_soundcom = "nehahra/wraith/weird.wav";
	self.pain_sound = "nehahra/wraith/growl2.wav";
	self.pain_sound2 = "nehahra/wraith/idle2.wav";
	self.solid = SOLID_NOT;					// No interaction with world
	self.alpha = 0.4;						// Ghostly
	self.movetype = MOVETYPE_NONE;			// Static item, no movement
	self.oldorigin = self.origin;			// Store known good location (hopefully) for materializing.
	if (self.bboxtype < 1) self.bboxtype = BBOX_SHORT;
	if (self.health < 1) self.health = 600;
	self.gibhealth = MON_NEVERGIB;
	self.exactskin = 0;
	self.fullbright = 1;
	self.bloodtype  = BLOOD_DARK;   // It's like the Nazgul/ringwraith.
	self.ryuflags   = RYU_REAPER | RYU_CALM;
	self.speed        = 8;
	self.yaw_speed = 10;
	self.touch = death_aura;
	self.th_stand = nehwraith_stand1;
	self.th_walk = nehwraith_walk1;
	self.frame = self.walkframe = 18;
	self.lefty = 0;
	self.cnt = 1;
	self.state = 0;
	self.th_die = nehwraith_die;
	self.th_pain = nehwraith_pain;
	self.th_run = nehwraith_run1;
	self.th_missile = nehwraith_attack;
	self.th_melee = nehwraith_melee;
	if (self.deathstring == "")  self.deathstring = " was dispelled by a Void Wraith\n";
	Resist_ChangeType(self,-1); // Always reset Ammo Resistance to be consistent
	SetDefaultDenizenAttributes(self); // Standard DENIZEN AI
	self.classtype = CT_MONWRAITHNEHAHRA;
	self.classgroup = CG_HARMLESS; // DENIZEN!
	self.classmove = MON_MOVEFLY;
	monster_start();
};
//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by W. Josiah Jack, aka Qmaster
//
// Attributions: Drake by Patrick Martin, Zerstorer, Qtest, id1
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
// Entity count: 3
// Function count: 113
//
// Implements: Nemesant and Master Nemesant
//
// Description:
// Floating mysterious being that is somewhat like a voodoo doll crossed with
// a vore in appearance.  Has various magical attacks and can revive nearby
// enemies in the boss version.
//
// Trivia: Also the original Qtest shal-rath.  Called Troglodyte in Zerstorer.
//=============================================================================

$cd /progs/nemesant
$origin 0 0 24
$base base
$skin skin
$frame float1 float2 float3 float4 float5 float6 float7
$frame attack1 attack2 attack3 attack4 attack5 attack6 attack7 attack8
$frame attack9 attack10 attack11 attack12 attack13 attack14 attack15
$frame attackb1 attackb2 attackb3 attackb4 attackb5 attackb6 attackb7
$frame pain1 pain2 pain3 pain4 pain5 pain6
$frame death1 death2 death3 death4 death5 death6 death7 death8 death9
$frame death10 death11 death12 death13 death14 death15 death16 death17
$frame decap1 decap2 decap3 decap4 decap5 decap6 decap7 decap8 decap9
$frame decap10 decap11 decap12 decap13 decap14 decap15 decap16 decap17

//  Warp Magic
// Update 6/2/09:  Circles and Explosion moved to fx.qc.
// Used by multiple effects.

// Copied from Zerstorer code.
void() DoCircles = {
local   vector  startpos, drag, dragto;
local   float   delta;

    // Update 6/6/10:  Fizzle check.
    // Assumes the nemesant is the attacker.  If not, change the conditions!
    if ((self.owner.frame >= $pain1 ) || (self.owner.health < 1)) {
        // The spell fizzles!
        super_active = 0;
        StopSound(self,CHAN_WEAPON);
        if (self.trigger_field)     // Remove the explosion entity.
            remove (self.trigger_field);
        remove (self);
        return;
    }

    delta = self.count * 3;
    if (self.dmg == 1) {
        startpos = self.origin + '0 0 24';
        setorigin(self, self.origin + '0 0 8');
    } else {
        startpos = self.origin - '0 0 24';
        setorigin(self, self.origin - '0 0 8');
    }
    DrawCircleXY(self.origin, 84 - delta, 105);
    DrawCircleXY(startpos, 64 - delta, 232);
    self.count = self.count - self.dmg;
    if (self.count == 6) {
        super_active = 0;   // Done spamming particles.
        remove (self);
        return;
    }
    if (self.count == 0) self.dmg = -1;
    if (vlen(self.enemy.origin - self.origin) <= 250) {
        dragto = self.origin;
        dragto_z = self.enemy.origin_z;
        drag = normalize (dragto - self.enemy.origin);
        drag = drag*250;
        self.enemy.velocity = self.enemy.velocity + drag;
    }
        
    self.nextthink = time + 0.12;
};

void() TrogWarpMagic = {
    WarpExplosion(); // Moved all explosion effects into a separate function so other code can use it.

	// Damage stuff from the circle magic.
    if (self.enemy) {
        T_RadiusDamage(self, self.owner, 120, self.owner, DAMAGEALL);
        if (vlen(self.enemy.origin - self.origin) <= 120) {

        // For those immune to splash damage, inflict minor damage.
        // This is not unlike a Doom2 arch-vile vs. cyberdemon matchup.
            if (self.enemy.noradiusdmg)
                if (self.enemy != self.owner)
                    T_Damage(self.enemy, self, self.owner, 20, DAMARMOR);

            if (self.enemy.mass && (self.enemy.mass <= MASS_SUPER)) {
                self.enemy.flags = self.enemy.flags - (self.enemy.flags & FL_ONGROUND);
                self.enemy.velocity_x = (random() * 400) - 200;
                self.enemy.velocity_y = (random() * 400) - 200;
                self.enemy.velocity_z = (random() * 300) + 400;
                if (self.enemy.mass == MASS_SUPER) self.enemy.velocity = self.enemy.velocity * 0.5;
            }
        }
    }
};

void() StartTrogMagic = {
    local entity Mcircle, Tboom;
    local vector spot;

    // Mutual exclusion for trog magic attack so that we don't overflow space!
    super_active = 1;       // Global defined in defs*.qc.

    // Particle circle drawing entity.
    spot = self.enemy.origin - '0 0 12';
    Mcircle = spawn();
    Mcircle.movetype   = MOVETYPE_NONE;
    Mcircle.solid      = SOLID_NOT;
    Mcircle.owner      = self;
    Mcircle.count      = 5;
    Mcircle.dmg        = 1;
    Mcircle.enemy      = self.enemy;
    Mcircle.touch      = SUB_Null;
    Mcircle.nextthink  = time + 0.01;
    Mcircle.think      = DoCircles;      
    setorigin(Mcircle, spot);
    sound(Mcircle,CHAN_WEAPON,"zerstorer/trog/charge.wav",1,ATTN_NORM);

    // Explosion entity.
    spot = self.enemy.origin + '0 0 24';
    Tboom = spawn();
    Tboom.movetype   = MOVETYPE_NONE;
    Tboom.solid      = SOLID_NOT;
    Tboom.owner      = self;
    Tboom.enemy      = self.enemy;
    Tboom.touch      = SUB_Null;
    Tboom.nextthink  = time + 1.1;
    Tboom.think      = TrogWarpMagic;       
    setorigin(Tboom, spot);
    Mcircle.trigger_field = Tboom; // Link the two together.
};

//  Normal Attacks

// Used by necromancer and nemesant to shove an enemy away.
// Note:  Skullwiz version use different velocity and damage methods.
void() ai_repel = { // [FUNCTION] Note:  Different than Armagon's because we ignore elevation.
    local vector dir;
    if (!self.enemy) return;     // No one to attack.
    if (!InMeleeRange(120)) return;
    if (!CanDamage(self.enemy,self)) return;

    dir = self.enemy.origin;
    dir_z = self.origin_z;     // Only interested in xy-plane, so ignore z.
    dir = normalize(dir - self.origin);
    dir = dir * 1000;
    dir_z = 120;    // Add a little up to overcome normal gravity.  
    if (self.enemy.mass && (self.enemy.mass <= MASS_SUPER)) {
        self.enemy.flags = self.enemy.flags - (self.enemy.flags & FL_ONGROUND);
        self.enemy.velocity = self.enemy.velocity + dir; // Send the enemy flying.
    }

    sound(self,CHAN_WEAPON,"drake/skullwiz/push.wav",1,ATTN_NORM);
    T_Damage(self.enemy, self, self, 20, DAMARMOR);
};

// Returns the point of one of its hands.
vector(float left) Nemesant_Hand = { // [FUNCTION]
    makevectors(self.angles);
    if (left) return (self.origin + (v_forward*16) - (v_right*10) + (v_up*30)); // TRUE = use left hand, FALSE = use right hand.
    return (self.origin - (v_forward*16) + (v_right*12) + (v_up*45));
};

// This sends a bolt of lightning at an enemy, similar to the shamblers'.  Assume not in water and don't check for discharge.
void() Nemesant_Bolt = { // [FUNCTION]
    local vector p1, p2;

    p1 = Nemesant_Hand (TRUE);      // This will call makevectors as well.
    p2 = self.enemy.origin + '0 0 16';
    p2 = Maim_LineEx(p1,p2,0,self.enemy,'0 0 0',1);
    p2 = p1 + p2*600;
    self.effects = self.effects | EF_MUZZLEFLASH;
    sound(self,CHAN_WEAPON,"weapons/lhit.wav",1,ATTN_NORM);
    sound(self,CHAN_AUTO,"weapons/lstart.wav",1,ATTN_NORM);
	LightningBolt(p1,p2,self,10,self,TE_LIGHTNING2); // 10 Damage
};

// Magic missile sidewinding tracking code.
void() nemes_track = { // [FUNCTION]
    local vector vec;
    local float up, old, delta;

    if (self.delay <= time) { remove (self); return; }

    up = (self.cnt & 7) * 45;
    up = SUB_sin(up) * 5;       // Other sidewinder code uses cosine.
    self.cnt = self.cnt + 1;
    vec = self.enemy.origin + self.enemy.view_ofs;
	vec = vectoangles(vec - self.origin);
	old = self.angles_y;
	self.ideal_yaw = vec_x + up;
	self.angles_y = self.angles_x;
	ChangeYaw();
	self.angles_x = self.angles_y;
	self.angles_y = old;
	self.ideal_yaw = vec_y + self.lefty;
	ChangeYaw();
	delta = rint(self.angles_y - self.ideal_yaw);
	delta = anglemod(delta); 
	if (!delta) self.lefty = 0 - self.lefty; // TRUE if difference between self's yaw and ideal yaw is one-half of a degree or less.
	vec = self.angles;
	vec_x = 0 - vec_x;
	makevectors(vec);
	self.velocity = v_forward * self.speed;
    self.nextthink = time + 0.1;
};

// Spawns each magic missile launched by the nemesant.
void(float ofs, float up, vector vec) nemes_shot = { // [FUNCTION]
    newmis = hknight_shot(ofs);
    setorigin(newmis, vec);
    newmis.velocity  = normalize(newmis.velocity) * 600;
    if (self.enemy) { // Setup for homing sidewinders.
        newmis.enemy     = self.enemy;
        newmis.cnt       = up;
        newmis.lefty     = ofs * 20;
        newmis.speed     = 450;
        newmis.yaw_speed = 20;
        newmis.delay     = newmis.nextthink;
        newmis.nextthink = time + 0.1;
        newmis.think     = nemes_track;
    }
};

// Shoots a salvo of magic missiles at an enemy.
void() Nemesant_Missiles = { // [FUNCTION]
    local   vector  p1;

    p1 = Nemesant_Hand (TRUE);
    self.effects = self.effects | EF_MUZZLEFLASH;
// Three shots, one per finger.  Left, center, and right.
// Note:  2nd parm -- 0,2,4 for sin.  6,0,2 for cos.
    nemes_shot(-1,0,p1); nemes_shot(0.5,2,p1); nemes_shot(1,4,p1);
};
//- - - - - - - - -

// Lobs its trademark bouncing seeker fireball.
// In Drake, more monsters copy and use this attack.
void() Nemesant_FireBall = { M_FireSmart ('16 12 45'); }; // [FUNCTION]


//  Movement and Teleportation

// PM:  Teleport code mostly rewritten from the original.
void() tele_attack = { // [FUNCTION]
    local   vector  org, delta;

    delta = self.enemy.origin - self.origin;
    if (vlen(delta) < 100)
        return;     // Too close to the enemy.

    org = self.origin;    // Remember this point for fog spawning.
    if (random() < 0.5)
    {   // Standard Zerstorer AI.
        local   vector  enor;

        // Distance was originally 70, but thats too short vs. fat monsters.
        // Dist = 70 vs. players, 90 vs. ogre/shambler, 110+ vs. even fatter.
        delta_z = 0;    // Ignore elevation difference.
        delta = normalize(delta) * (self.enemy.maxs_x * 1.25 + 50);
        enor = self.enemy.origin + '0 0 32';

        // Aim behind target, and if that fails, aim in front of target.
        if (!EntryPoint_Spawn (self, self.enemy, enor + delta, EntryPoint_One))
            if (!EntryPoint_Spawn (self, self.enemy, enor - delta, EntryPoint_One))
                return;
    } else { // Custom -- teleport to random spot within range_near.
        if (!EntryPoint_Spawn (self, self, org, EntryPoint_Random)) return;
    }
    // Teleport is a success.
    self.angles_y = vectoyaw(SUB_orgEnemyTarget() - self.origin);
    if (!Invisible(self)) { // Fog only if visible.
        spawn_tfog (org);           // Before
        spawn_tfog (self.origin);   // After
    }
    // Zerstorer has after first, before second.

    // Replaced 'super_*' with 'waitmax' because monsters use powerups.
    self.waitmax = time + 2;
    self.attack_finished = 0;   // PM:  This lets mage attack now.
};

void() check_tele = { // [FUNCTION]
    local entity head;

    if (!self.enemy) return;
    if (self.enemy.health <= 0) return;
    if (self.waitmax > time) return;

    head = findradius(self.origin, 150);
    while (head) {
        // Update:  Drake uses self.master for true ownership, since
        // reflection code changes owner when used.
        if (head.master == self.enemy) {
            if (IsMissile (head)) { tele_attack(); return; }
        }
        head = head.chain;
    }
};

void() nemes_idlesound = { // [FUNCTION]
    local float wr;

    if (self.waitmin < time) {
        // Use voice channel instead of auto -- don't want slain magi talking.
        wr = random();
        if (wr > 0.7) 
            sound(self,CHAN_VOICE, "zerstorer/trog/tidle1.wav",1,ATTN_NORM);
        else if (wr < 0.3)
            sound(self,CHAN_VOICE, "zerstorer/trog/tidle2.wav",1,ATTN_NORM);
        self.waitmin = time + 10;
    }
};

void() nemes_stand1  = [$float1,  nemes_stand2  ] { ai_stand();
    if (!(self.spawnflags & 1)) nemes_idlesound(); // Chant ominously if not in ambush mode.
};
void() nemes_stand2  = [$float2,  nemes_stand3  ] { ai_stand(); };
void() nemes_stand3  = [$float3,  nemes_stand4  ] { ai_stand(); };
void() nemes_stand4  = [$float4,  nemes_stand5  ] { ai_stand(); };
void() nemes_stand5  = [$float5,  nemes_stand6  ] { ai_stand(); };
void() nemes_stand6  = [$float6,  nemes_stand7  ] { ai_stand(); };
void() nemes_stand7  = [$float7,  nemes_stand1  ] { ai_stand(); };

// WALK - - - - - - - - - - - - - - - -
void() nemes_walk1  = [$float1,  nemes_walk2  ] { ai_walk(8); nemes_idlesound(); };
void() nemes_walk2  = [$float2,  nemes_walk3  ] { ai_walk(8); };
void() nemes_walk3  = [$float3,  nemes_walk4  ] { ai_walk(8); };
void() nemes_walk4  = [$float4,  nemes_walk5  ] { ai_walk(8); };
void() nemes_walk5  = [$float5,  nemes_walk6  ] { ai_walk(8); };
void() nemes_walk6  = [$float6,  nemes_walk7  ] { ai_walk(8); };
void() nemes_walk7  = [$float7,  nemes_walk1  ] { ai_walk(8); };

// RUN - - - - - - - - - - - - - - - - -
void() nemes_side1  = [$float1,  nemes_side2  ] { ai_run(8); nemes_idlesound(); check_tele(); };
void() nemes_side2  = [$float2,  nemes_side3  ] { ai_run(8); };
void() nemes_side3  = [$float3,  nemes_side4  ] { ai_run(8); check_tele(); };
void() nemes_side4  = [$float4,  nemes_side5  ] { ai_run(8); };
void() nemes_side5  = [$float5,  nemes_side6  ] { ai_run(8); check_tele(); };
void() nemes_side6  = [$float6,  nemes_side7  ] { ai_run(8); };
void() nemes_side7  = [$float7,  nemes_side1  ] { ai_run(8); check_tele(); };

void() nemes_run1  = [$float1,  nemes_run2  ] { ai_run(16); nemes_idlesound(); check_tele(); };
void() nemes_run2  = [$float2,  nemes_run3  ] { ai_run(16); };
void() nemes_run3  = [$float3,  nemes_run4  ] { ai_run(16); check_tele(); };
void() nemes_run4  = [$float4,  nemes_run5  ] { ai_run(16); };
void() nemes_run5  = [$float5,  nemes_run6  ] { ai_run(16); check_tele(); };
void() nemes_run6  = [$float6,  nemes_run7  ] { ai_run(16); };
void() nemes_run7  = [$float7,  nemes_run1  ] { ai_run(16); check_tele(); };

// ATTACK - - - - - - - - - - - - - - -
void() TrogAttackFinished = {
    if (self.attack_finished)   // Repel hack -- set at zero bypasses delay.
        SUB_AttackFinished (2);
    if (enemy_range >= RANGE_MID || !enemy_vis)
        { self.attack_state = AS_STRAIGHT; self.think = nemes_run1; }
    else
        { self.attack_state = AS_SLIDING; self.think = nemes_side1; }
};

void() nemes_fast1  = [$attackb1,  nemes_fast2  ] { ai_face(); };
void() nemes_fast2  = [$attackb2,  nemes_fast3  ] { ai_face(); };
void() nemes_fast3  = [$attackb3,  nemes_fast4  ] { ai_face(); };
void() nemes_fast4  = [$attackb4,  nemes_fast5  ] { ai_face(); };
void() nemes_fast5  = [$attackb5,  nemes_fast6  ] {
    local   float   dist, boss, mask, zot;

    ai_face();
    sound(self,CHAN_VOICE, "zerstorer/trog/frblatck.wav",1,ATTN_NORM);
    if (self.waitmin < time + 1) self.waitmin = time + 1;

	// The mage has more options when not bound by Zerstorer mode.
	dist = vlen(self.enemy.origin - self.origin);
	zot = FALSE;

	// Update 6/6/10:  Only the boss version can shoot lightning.
	boss = FALSE;
	if (self.classname != "monster_nemesant") boss = TRUE;

	if (boss && self.enemy.movetype == MOVETYPE_NOCLIP && self.enemy.solid == SOLID_TRIGGER) {
           if ( !((dist > 600) || (self.waterlevel == 3)) ) zot = TRUE; // close enough and out of water
	}

	// If TRUE, Only lightning is effective, at least in Drake.
	if (zot) {
		Nemesant_Bolt();
		self.nextthink = time + 0.2;
	} else {
		// Use standard book of tricks.
		if ((dist <= 120) && (self.enemy.flags & FL_ONGROUND)) {
			// Try to push enemy away from melee.	
			ai_repel();
			self.attack_finished = 0;   // Don't delay for next attack.
		} else {
			// Use pattern like Dracula in Castlevania: SotN.  Launch three fireballs then magic missiles.
			self.meleeattack = self.meleeattack + 1;
			if (self.meleeattack == 3) {
				self.meleeattack = 0;
				// Use magic missiles sometimes if enemy is not immune.
				if (!(self.enemy.armortype == ARMOR_RED_TYPE)) {
					Nemesant_Missiles();
					return;
				}
            } else if (!self.meleeattack && boss) {
				// The boss gets to shoot lightning every fourth shot. Must be inrange and out of the water.
				if ( !((dist > 600) || (self.waterlevel == 3)) ) {
					Nemesant_Bolt();
					self.nextthink = time + 0.2;
					return;
				}
			}
			Nemesant_FireBall();   // The original.
		}
	}
};
void() nemes_fast6  = [$attackb6,  nemes_fast7  ] { ai_face(); };
void() nemes_fast7  = [$attackb2,  nemes_fast8  ] { ai_face(); };
void() nemes_fast8  = [$attackb1,  nemes_run1   ] { ai_face(); TrogAttackFinished(); };

void(vector st) nemes_sparks = {
    local   vector  side;

    makevectors(self.angles);
    side = v_right * st_y;
    st = self.origin + v_forward*st_x + v_up*st_z;
    particle (st + side, '0 0 50', 145, 10);
    particle (st - side, '0 0 50', 145, 10);
};
void() nemes_summon1  = [$attack1,  nemes_summon2  ] { ai_face(); nemes_sparks('0 35 22'); };
void() nemes_summon2  = [$attack3,  nemes_summon3  ] { ai_face(); nemes_sparks('-2 31 15'); };
void() nemes_summon3  = [$attack5,  nemes_summon4  ] { ai_face(); nemes_sparks('-14 30 15'); };
void() nemes_summon4  = [$attack7,  nemes_summon5  ] { ai_face(); nemes_sparks('-15 32 25'); };
void() nemes_summon5  = [$attack9,  nemes_summon6  ] { ai_face(); nemes_sparks('-15 31 28'); };
void() nemes_summon6  = [$attack10, nemes_summon7  ] { ai_face(); nemes_sparks('12 27 30'); };
void() nemes_summon7  = [$attack11, nemes_summon8  ] { ai_face(); nemes_sparks('22 3 30');
// DISABLED -- Vores as part of this boss fight is harsh.
//    if (!self.pets)
//    if (random() < 0.5)
//    if (self.health < (self.max_health / 2))
//    if (SpawnMonster (self, self.origin, ID_SHALRATH_CLASSIC, EntryPoint_Fan))
//        return;

    //if (self.pets < 3)
    //    SpawnMonster_Horde (ID_WIZARD_SCRAG, 3);
    //else
        //SpawnMonster_Horde (CT_MONWIZARD, 2);
};
void() nemes_summon8  = [$attack13, nemes_summon9  ] { ai_face(); };
void() nemes_summon9  = [$attack14, nemes_summon10 ] { ai_face(); };
void() nemes_summon10 = [$attack15, nemes_run1     ] { ai_face(); TrogAttackFinished(); };

void(vector st) nemes_sparks2 = {
    local   vector  side;

    makevectors(self.angles);
    side = v_right * st_y;
    st = self.origin + v_forward*st_x + v_up*st_z;
    particle (st + side, '0 0 50', 241, 10);
    particle (st - side, '0 0 50', 241, 10);
};
void() nemes_inviso1  = [$attack1,  nemes_inviso2  ] { ai_face(); nemes_sparks2('0 35 22'); };
void() nemes_inviso2  = [$attack3,  nemes_inviso3  ] { ai_face(); nemes_sparks2('-2 31 15'); };
void() nemes_inviso3  = [$attack5,  nemes_inviso4  ] { ai_face(); nemes_sparks2('-14 30 15'); };
void() nemes_inviso4  = [$attack7,  nemes_inviso5  ] { ai_face(); nemes_sparks2('-15 32 25'); };
void() nemes_inviso5  = [$attack9,  nemes_inviso6  ] { ai_face(); nemes_sparks2('-15 31 28'); };
void() nemes_inviso6  = [$attack10, nemes_inviso7  ] { ai_face(); nemes_sparks2('12 27 30'); };
void() nemes_inviso7  = [$attack11, nemes_inviso8  ] { ai_face(); nemes_sparks2('22 3 30');
    sound(self,CHAN_VOICE, "zerstorer/trog/frblatck.wav",1,ATTN_NORM);
    spawn_tfog (self.origin);
    self.invisible_finished = time + 10;
};
void() nemes_inviso8  = [$attack13, nemes_inviso9  ] { ai_face(); };
void() nemes_inviso9  = [$attack14, nemes_inviso10 ] { ai_face(); };
void() nemes_inviso10 = [$attack15, nemes_run1     ] { ai_face(); TrogAttackFinished(); };

void() nemes_sboom1  = [$attack1,  nemes_sboom2  ] { ai_face(); };
void() nemes_sboom2  = [$attack2,  nemes_sboom3  ] { ai_face(); };
void() nemes_sboom3  = [$attack3,  nemes_sboom4  ] { ai_face(); };
void() nemes_sboom4  = [$attack4,  nemes_sboom5  ] { ai_face();
    if (super_active) { self.think = nemes_fast1;  return; } // Someone else started it first -- use alt. instead.
    StartTrogMagic();
};
void() nemes_sboom5  = [$attack5,  nemes_sboom6  ] { ai_face(); };
void() nemes_sboom6  = [$attack6,  nemes_sboom7  ] { ai_face(); };
void() nemes_sboom7  = [$attack7,  nemes_sboom8  ] { ai_face(); };
void() nemes_sboom8  = [$attack8,  nemes_sboom9  ] { ai_face(); };
void() nemes_sboom9  = [$attack9,  nemes_sboom10 ] { ai_face(); };
void() nemes_sboom10 = [$attack10, nemes_sboom11 ] { ai_face(); };
void() nemes_sboom11 = [$attack11, nemes_sboom12 ] { ai_face(); };
void() nemes_sboom12 = [$attack12, nemes_sboom13 ] { ai_face(); };
void() nemes_sboom13 = [$attack13, nemes_sboom14 ] { ai_face(); };
void() nemes_sboom14 = [$attack14, nemes_sboom15 ] { ai_face(); };
void() nemes_sboom15 = [$attack15, nemes_run1    ] { ai_face(); TrogAttackFinished(); };

void() Nemesant_Attack = {
	local float fast;

    // Boss version has other tricks it can use half the time.
    if (self.classtype == CT_MONNEMESANTBOSS && random() < 0.5) {
        if (!self.invisible_finished && (self.health <= (self.max_health / 2))
            && random() < 0.5) { 
            nemes_inviso1(); // If hurt badly enough, cast invisibility sometimes.
            return;
        }
        if (self.count <= 1) { nemes_summon1();  return; } // Summon monsters to fight.
    }

	// Use quick attack instead of super attack if...
	// 1) Someone is using super attack now (only one at a time, please).
	// 2) Enemy is off the ground (player gets sucked in unfairly).
	// 3) Enemy is invisible (mage cannot pinpoint enemy).
	//  NOTE:  Zerstorer didn't check for invisibility.
	//
	// If super attack is available, always use it if nothing else can hurt
	// the enemy, which includes ghosts and zombies.
	//
	// Assuming no special conditions, chances of attack paths are as follows.
	//  70% chance of A -- fast magic
	//  30% chance of B -- super magic
    if ((random() < 0.7) || !(self.enemy.flags & FL_ONGROUND) || super_active
        || Invisible(self.enemy)) {
        fast = 1;
        // Allow exceptions if nothing else is effective.
        if (!super_active) {
            if (self.enemy.classgroup == CG_ZOMBIE) fast = 0;
            else if (IsGhost(self.enemy)) fast = 0;
        }
    } else fast = 0;

    if (fast) nemes_fast1();
    else nemes_sboom1();
};

// PAIN
void() nemes_pain1  = [$pain1,  nemes_pain2  ] {};
void() nemes_pain2  = [$pain2,  nemes_pain3  ] {};
void() nemes_pain3  = [$pain3,  nemes_pain4  ] {};
void() nemes_pain4  = [$pain4,  nemes_pain5  ] {};
void() nemes_pain5  = [$pain5,  nemes_pain6  ] {};
void() nemes_pain6  = [$pain6,  nemes_run1   ] {};

void(entity inflictor, entity attacker, float damage) nemes_pain = {
    if (self.pain_finished > time) return;
    if ((self.frame >= $attack1 ) && (self.frame <= $attack15 )) { // Casting the big spell, so be resistant to pain like the arch-vile.
        if (prandom() > 10) return;     // Failed to break its concentration.
    }

    self.pain_finished = time + 0.5;
    sound(self,CHAN_VOICE, "zerstorer/trog/tpain.wav",1,ATTN_NORM);
    if (random()*70 > damage) return;         // didn't flinch
    if (SUB_IgnorePain ()) return;         // No pain anims in Nightmare.
    if (self.classname != "monster_nemesant") { // Make boss versions harder to flinch and stunlock.
        if (self.lip > time) return;     // Too soon to flinch.
        self.lip = time + 2;
    }
    self.attack_finished = 0;   // So mage can counterattack after recovery.
    nemes_pain1();
    attacker = attacker;    // FrikQcc warning squelch!
};

void() nemes_death1  = [$death1,  nemes_death2  ] {};
void() nemes_death2  = [$death2,  nemes_death3  ] { monster_check_gib(); self.solid = SOLID_NOT; };
void() nemes_death3  = [$death3,  nemes_death4  ] { monster_check_gib(); DropCoin(4); };
void() nemes_death4  = [$death4,  nemes_death5  ] {};
void() nemes_death5  = [$death5,  nemes_death6  ] {};
void() nemes_death6  = [$death6,  nemes_death7  ] {};
void() nemes_death7  = [$death7,  nemes_death8  ] {};
void() nemes_death8  = [$death8,  nemes_death9  ] {};
void() nemes_death9  = [$death9,  nemes_death10 ] {};
void() nemes_death10 = [$death10, nemes_death11 ] {};
void() nemes_death11 = [$death11, nemes_death12 ] {};
void() nemes_death12 = [$death12, nemes_death13 ] {};
void() nemes_death13 = [$death13, nemes_death14 ] {};
void() nemes_death14 = [$death14, nemes_death15 ] {};
void() nemes_death15 = [$death15, nemes_death16 ] {};
void() nemes_death16 = [$death16, nemes_death17 ] { monster_death_postcheck(); };
void() nemes_death17 = [$death17, nemes_death17 ] { monster_deadbody_check(); };

void() nemes_die = {
	monster_death_precheck(); // Pre-check routine to tidy up extra entities
	if (!self.gibbed) {
        self.velocity_x = -200 + 400*random();
        self.velocity_y = -200 + 400*random();
        self.velocity_z = 200 + 100*random();   // PM:  Used to be 300.
        SUB_RemoveFlags(self,FL_ONGROUND);
        self.movetype = MOVETYPE_TOSS;
        if (random() < 0.5)
            sound(self,CHAN_VOICE, "zerstorer/trog/tdeath1.wav",1,ATTN_NORM);
        else
            sound(self,CHAN_VOICE, "zerstorer/trog/tdeath2.wav",1,ATTN_NORM);
        nemes_death1();
    }
};

void() monster_nemesant_precache = {
    precache_model ("progs/drake/nemesant.mdl");
    precache_model ("progs/drake/h_nemes.mdl");
    precache_model ("progs/k_spike.mdl");   // For sidewinder missiles.
    precache_model ("progs/drake/smartbal.mdl");  // Homing bouncing fireball.
    precache_model ("progs/drake/warp2.mdl");     // Big explosion.
	precache_model ("progs/drake/blood_gr.mdl");
	precache_model ("progs/drake/gr_gib.mdl");
    precache_model ("progs/drake/gr_gib2.mdl");
    precache_model ("progs/drake/s_wave.spr");
    precache_model ("progs/quoth/bigexp.spr");
    precache_model ("progs/drake/wizard.mdl");
    precache_model ("progs/drake/h_drake.mdl");
    precache_model ("progs/h_wizard.mdl");
    precache_model ("progs/w_spike.mdl");
    precache_sound("hknight/attack1.wav");
    precache_sound("hknight/hit.wav");    // used by C code, so don't sound2
    precache_sound("zerstorer/trog/frblatck.wav");
    precache_sound("zerstorer/trog/frblfly.wav");
    precache_sound("zerstorer/trog/charge.wav");
    precache_sound("zerstorer/trog/bigboom.wav");
    precache_sound("zerstorer/trog/tdeath1.wav");
    precache_sound("zerstorer/trog/tdeath2.wav");
    precache_sound("zerstorer/trog/tidle1.wav");
    precache_sound("zerstorer/trog/tidle2.wav");
    precache_sound("zerstorer/trog/tpain.wav");
    precache_sound("zerstorer/trog/tsight1.wav");
    precache_sound("zerstorer/trog/tsight2.wav");
    precache_sound("drake/skullwiz/push.wav");       // Melee attack.
    precache_sound("wizard/hit.wav");        // used by c code
    precache_sound("wizard/wattack.wav");
    precache_sound("wizard/wdeath.wav");
    precache_sound("wizard/widle1.wav");
    precache_sound("wizard/widle2.wav");
    precache_sound("wizard/wpain.wav");
    precache_sound("wizard/wsight.wav");
};

// --> QUAKED monster_nemesant (1 0 0) (-16 -16 -24) (16 16 40) Ambush Boss
void() monster_nemesant = { // [ENTITY]
	if (monster_checkrandomizer() == TRUE) return; // Check for any random monster setups
  
    self.mdl = "progs/drake/nemesant.mdl";
    self.headmdl = "progs/drake/h_nemes.mdl";
	self.hello_sound = "zerstorer/trog/tpain.wav";
	self.sight_sound = "zerstorer/trog/tsight1.wav";
	self.sight_sound2 = "zerstorer/trog/tsight2.wav";
    self.solid = SOLID_NOT;		// No interaction with world
    self.movetype = MOVETYPE_NONE;	// Static item, no movement
    if (self.health < 1) self.health = 280;
    if (self.gibhealth >= 0) self.gibhealth = -40;
    self.mass       = MASS_HEAVY;
    self.th_stand   = nemes_stand1;
    self.th_walk    = nemes_walk1;
    self.th_run     = nemes_run1;
    self.th_missile = Nemesant_Attack;
    self.th_pain    = nemes_pain;
    self.th_die     = nemes_die;
    self.waitmin = time + 5;     // Wait for idle sounds
	Resist_ChangeType(self,-1); // Always reset Ammo Resistance to be consistent
	if (!self.classtype) self.classtype = CT_MONNEMESANT;
	self.classgroup = CG_WIZARD;
	self.classmove = MON_MOVEFLY;
	if (random() < 0.5) {
		if (self.deathstring == "") self.deathstring = " was buried by a Nemesant\n";
	} else {
		if (self.deathstring == "") self.deathstring = " was hexed by a Nemesant\n";
	}

    monster_start();
};

// SoE entity.
void() monster_trogboss = { // [ENTITY]
    self.lip = 0;
    if (self.exactskin) self.skin = self.exactskin;
    else if (self.skin != 2) self.skin = self.exactskin = 1;
    if (self.health < 1) self.health = 1600;
    if (self.gibhealth >= 0) self.gibhealth = -60;
	self.bossflag = TRUE;
    self.classtype = CT_MONNEMESANTBOSS;
	if (self.deathstring == "") self.deathstring = " failed to impress the Master Nemesant\n";
    monster_nemesant();
};

// Original classname from Zerstorer.
void() monster_troglodyte = { // [ENTITY]
    if (world.model == "maps/coe4.bsp") { // Ugh
		self.classname = "monster_trogboss";  monster_trogboss();
	} else {
		self.classname = "monster_nemesant";  monster_nemesant();
	}
};

// Todo (maybe):  Add purple mind-flayer version that can rez bad guys.

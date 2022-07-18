//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
//
// Attributions: Patrick Martin and Drake mod
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
// Implements: Nightshade, a.k.a. the wraith dragon.
//
// Description:
// The nightshade shares some of the code and files used by the dragons.
// However, it is treated as a separate monster.
//
// In addition, the nightshade has its own model.  It is derived from
// the dragon model, but most of the scenes are different.
// The spawn scene is placed first so the phasing effects animate
// properly on Quake engines that support frame interpolation.
//
// Frames:
//     0 -  6  Form
//     7 - 14  Hover
//    15 - 23  Attack (for melee or missile)
//    24 - 29  Pain #1
//    30 - 35  Pain #2
//    36 - 41  Pain #3
//    42 - 59  Aether
//    60 - 77  Death
//
// Update:  With Nehahra-style wraiths added, the medium dragon is the
// only size that looks good with all of the other ghosts.
//=============================================================================

$cd progs/shade
$origin 0 0 24
$base base 
$skin skin

$frame form1 form2 form3 form4 form5 form6 form7
$frame fly1 fly2 fly3 fly4 fly5 fly6 fly7 fly8
$frame attack1 attack2 attack3 attack4 attack5 attack6
$frame attack7 attack8 attack9
$frame pain1 pain2 pain3 pain4 pain5 pain6
$frame painb1 painb2 painb3 painb4 painb5 painb6
$frame painc1 painc2 painc3 painc4 painc5 painc6
$frame nova1 nova2 nova3 nova4 nova5 nova6 nova7 nova8 nova9 nova10
$frame nova11 nova12 nova13 nova14 nova15 nova16 nova17 nova18

// This finds the best path to avoid danger, then moves the monster along the path.
void(float dist, entity ent) Shade_FindBestPath = {
    local float yaw, tz, sz;
    local entity targ;

    yaw = vectoyaw (ent.origin - self.origin);
	yaw = anglemod (yaw - self.angles_y);
    if (yaw < 60)   yaw = -90;   	  // Dodge right.
    else if (yaw < 120)  yaw = 0;     // Continue straight ahead.
    else if (yaw < 180)  yaw = -90;   // Dodge right.
    else if (yaw < 240)  yaw = 90;    // Dodge left.
    else if (yaw < 300)  yaw = 0;     // Continue straight ahead.
    else yaw = 90;                    // Dodge left.
	
    // Ghost monsters cannot be blocked.

	// Set new course and head in that direction if possible.
	// Formerly 'Shade_Dodge (self.angles_y + yaw, dist, ent);'.
	// void(float newyaw, float dist, entity threat) Shade_Dodge =
	// This forces the nightshade to dodge the threat entity.
    yaw = self.angles_y + yaw;
    noclip_move (yaw, dist); // Strafe away from the detected danger.
    targ = self.goalentity;

	// Face its goal.
    self.ideal_yaw = vectoyaw (targ.origin - self.origin);
    ChangeYaw();

	// Next, check if the monster should slide vertically away from its goal.
    if (targ != ent) {
        // For elevation, if dragon is between the goal and threat entity, don't slide vertically away from goal.
        tz = targ.origin_z;
        sz = self.origin_z + self.view_ofs_z;
        if (tz < sz) {
            if (sz < ent.origin_z) return;
        } else if (tz > sz) {
            if (sz > ent.origin_z) return;
		}
    }
    Ryu_VerticalSlide (dist, targ);
};

// Close in on the opponent.
void() dark_melee = {
    ai_face();
    movetogoal(SPEED_RYU_MIN);
};

// Face and close in on the opponent while attacking.
void() dark_missile = {
    ai_face();
    if (!QC_CloseEnough(SPEED_RYU_MIN)) walkmove (self.angles_y, SPEED_RYU_MIN); // Don't pass through goal.
};

////////////////////////////////////////////////////////////////////////////
//  2.  Pawns -- Zombies                                                  //
////////////////////////////////////////////////////////////////////////////

float   MAX_ZOMBIES = 5;

//  This tries to create a zombie.  If successful, it then sends it off.
void() Shade_MeatSummon = {
    //if (self.owner)
      //if (!((self.owner.health <= 0) || self.owner.deadflag))
        //if (self.owner.pets < MAX_ZOMBIES)
          //if (self.owner.enemy)
            //if (self.flags & FL_ONGROUND)
              //SpawnMonster_Point (self.master, self.origin + '0 0 41', ID_ZOMBIE); TODO!
    remove (self);
};

//  This checks if a missed shot is on the ground.  If not, the shot
//  is removed.  Otherwise, it remains for a few seconds before it is
//  removed permanently or it becomes a zombie.
void() Shade_MeatMiss = {
    if (!(self.flags & FL_ONGROUND)) { remove (self); return; }    // Didn't touch ground, remove it.

	// Let the missile's blood trail fade before spawning a monster.
    self.avelocity = '0 0 0';     // On the ground -- stop spinning.
    self.nextthink = time + 2;    // Lay dormant for a moment before growth.
    if (self.cnt)
        self.think = Shade_MeatSummon;
    else
        self.think = SUB_Remove;
};

//  A gib inflicts damage on contact.  If the gib misses, it may
//  form into a zombie later.
void() Shade_MeatTouch = {
    if (pointcontents(self.origin) == CONTENT_SKY) { remove (self); return; }
    if (Reflected ()) return;
    
    // hit something that bleeds
    if (other.takedamage) {
        spawn_touchblood (self, other, 10);
        T_Damage(other, self, self.owner, 10,DAMARMOR);
        remove (self);
    } else {
        // Make a little splat.
        sound(self,CHAN_WEAPON,"wizard/hit.wav",1,ATTN_NORM);
        spawn_touchblood (self, other, 10);

        // Make the shot non-solid and check if it can become a zombie.
        // Call rest of touch code a frame later because the onground flag
        // is never on.
        self.solid      = SOLID_NOT;
        self.touch      = SUB_Null;
        self.nextthink  = 0.01;
        self.think      = Shade_MeatMiss;
    }
};

// The nightshade shoots a bloody gib at its target.
void() Shade_Meat = {
    local   vector  org, dir, vec, vy; // org = location of dragon's mouth.  dir = vector from 'org' to gib target.
    local   float   mx, sped, up, loop, spread, arc; // mx = length of dir, which is 0 <= x <= 1.

    up = 200;
    sped = 800;     // Dragons use 'height * 200 + 800'.
    org = '50 -5 -7';
    makevectors(self.angles);
    vy = v_right;
    org = self.origin + (v_forward*org_x) + (v_right*org_y) + (v_up*org_z);
    dir = self.enemy.origin + self.enemy.view_ofs;
    dir = Aim_Ballistic(org,dir,sped,up,self.enemy,1,SHOT_TIME_BOUNCE,MOVETYPE_BOUNCE);
    dir = Maim_Scatter(dir,'0 0 0');
    mx = vlen(dir);
    sound(self,CHAN_WEAPON,"drake/dragon/ice.wav",1,ATTN_NORM);
    arc = 0.06;
    loop = 5; // Fire # of shots equal to max zombies.
    spread = (loop - 1) * arc;
    while (loop > 0) {
        vec = dir + (vy * spread);
        vec = normalize(vec) * mx;
        Meat_Launch (org, vec); // Shoot some meat.  Change some properties to allow some freaky magic.
        newmis.movetype     = MOVETYPE_TOSS;
        newmis.owner       = self;
        newmis.velocity     = vec * sped;
        newmis.velocity_z   = newmis.velocity_z + up;
        newmis.touch        = Shade_MeatTouch;
        newmis.nextthink    = time + 6;     // Same as spikes.
        newmis.cnt          = loop & 1;     // Spawn monster (0=no, 1=yes)
        spread = spread - arc - arc;
        loop = loop - 1;
    }
};

////////////////////////////////////////////////////////////////////////////
//  3.  Animation                                                         //
////////////////////////////////////////////////////////////////////////////
//==========================================================================
//  Movement Scenes
////////////////////////////////////////////////////////////////////////////
//  When the nightshade is phased out, it is invisible and invincible.    //
//  The .takedamage field is used to determine whether the nightshade     //
//  is phased in or out.                                                  //
////////////////////////////////////////////////////////////////////////////

// Set the nightshade's speed.  It gets faster when hurt -- "Now I'm angry!"
void() shadow_speed = {
    local float sped;

    if (self.max_health >= 1) {
        sped = 1 - (self.health / self.max_health);
        if (sped < 0) sped = 0;
        sped = (sped * 16) & 15;
    } else sped = 0;
    self.speed = 20 + sped;
};

// This lets the nightshade make spooky noises as it drifts.  Assumes the nightshade has phased out and is not attacking.
void() shade_sfx_idle = {
    if (self.waitmin < time) {
        if (random() < 0.01) {
			local   float   r;

			r = random();
			if (r < 0.5)
				sound(self,CHAN_VOICE, "drake/shade/idle.wav",1,ATTN_NORM);
			else
				sound(self,CHAN_VOICE, "drake/shade/taunt.wav",1,ATTN_NORM);

			// Don't make any more noise for a while.
			self.waitmin = time + 3;
		}
    }
};

// This changes the nightshade to its invisible form.  The nightshade phases out and remains in place, totally silent.
void(float in) shadow_phase = {
    if (in) { // Phase in.
        self.alpha = 0.7;
        self.takedamage = DAMAGE_AIM;
    } else {
        // Phase out.
        self.alpha = 0.01;
        self.takedamage = DAMAGE_NO;
    }
};

void() shade_stand = {
    if (self.spawnflags & SPAWN_SOUL) {
        if (Wraith_FindSoul()) { self.th_run();  return; }
	}

    ai_stand();
};
void()  shadow_stand1 = [$form7,  shadow_stand2  ] { self.alpha = 0.7; shade_stand(); };
void()  shadow_stand2 = [$form6,  shadow_stand3  ] { self.alpha = 0.6; shade_stand(); };
void()  shadow_stand3 = [$form5,  shadow_stand4  ] { self.alpha = 0.5; shade_stand(); };
void()  shadow_stand4 = [$form4,  shadow_stand5  ] { self.alpha = 0.4; shade_stand(); };
void()  shadow_stand5 = [$form3,  shadow_stand6  ] { self.alpha = 0.3; shade_stand(); };
void()  shadow_stand6 = [$form2,  shadow_stand7  ] { self.alpha = 0.2; shade_stand(); };
void()  shadow_stand7 = [$form1,  shadow_stand8  ] { self.alpha = 0.1; shade_stand(); };
void()  shadow_stand8 = [$form1,  shadow_stand9  ] {/*shadow_phase (FALSE);*/ self.alpha = 0.7;  shade_stand(); };
void()  shadow_stand9 = [$form1,  shadow_stand9  ] { shade_stand(); };

void()  shadow_stand = {
    if (self.takedamage) shadow_stand1();
    else shadow_stand8();
};

//  The nightshade phases out and moves along its path.
void(float d) shade_walk = {
    if (self.spawnflags & SPAWN_SOUL) {
        if (Wraith_FindSoul ()) { self.th_run();  return; }
	}
    ai_walk(d);
};
void()  shadow_walk1  = [$form7,  shadow_walk2  ] { self.alpha = 0.7; shade_walk(8); };
void()  shadow_walk2  = [$form6,  shadow_walk3  ] { self.alpha = 0.6; shade_walk(8); };
void()  shadow_walk3  = [$form5,  shadow_walk4  ] { self.alpha = 0.5; shade_walk(8); };
void()  shadow_walk4  = [$form4,  shadow_walk5  ] { self.alpha = 0.4; shade_walk(8); };
void()  shadow_walk5  = [$form3,  shadow_walk6  ] { self.alpha = 0.3; shade_walk(8); };
void()  shadow_walk6  = [$form2,  shadow_walk7  ] { self.alpha = 0.2; shade_walk(8); };
void()  shadow_walk7  = [$form1,  shadow_walk8  ] { self.alpha = 0.1; shade_walk(8); };
void()  shadow_walk8  = [$form1,  shadow_walk9  ] {/*shadow_phase (FALSE);*/ self.alpha = 0.7;  shade_walk(8); };
void()  shadow_walk9  = [$form1,  shadow_walk9  ] { shade_walk(8); shade_sfx_idle(); };

void()  shadow_walk = {
    if (self.takedamage) shadow_walk1();
    else shadow_walk8();
};

//  Run animation.  The nightshade flies quickly to find and close in on its target.
void() shade_sfx_fly = {
    if (self.super_sound < time) { // Not while Quad is sounding.
        if (self.waterlevel <= 1) sound(self,CHAN_BODY,"drake/shade/fly.wav",1,ATTN_NORM); // Not while in the water.
        else if ((self.liquidbase == CONTENT_WATER) || (self.liquidbase == CONTENT_SLIME)) sound(self,CHAN_BODY,"drake/dragon/flywater.wav",1,ATTN_NORM);
    }
}; 

void()  shadow_form1  = [$form1, shadow_form2  ] { shadow_phase (TRUE); self.alpha = 0.1; ai_run(self.speed); };
void()  shadow_form2  = [$form2, shadow_form3  ] { self.alpha = 0.2; ai_run(self.speed); };
void()  shadow_form3  = [$form3, shadow_form4  ] { self.alpha = 0.3; ai_run(self.speed); };
void()  shadow_form4  = [$form4, shadow_form5  ] { self.alpha = 0.4; ai_run(self.speed); };
void()  shadow_form5  = [$form5, shadow_form6  ] { self.alpha = 0.5; ai_run(self.speed); };
void()  shadow_form6  = [$form6, shadow_form7  ] { self.alpha = 0.6; ai_run(self.speed); };
void()  shadow_form7  = [$form7, shadow_run1   ] { self.alpha = 0.7; ai_run(self.speed); };
void()  shadow_run1   = [$fly1,  shadow_run2   ] { self.alpha = 0.7; shadow_speed(); ai_run(self.speed); };
void()  shadow_run2   = [$fly2,  shadow_run3   ] { ai_run(self.speed); };
void()  shadow_run3   = [$fly3,  shadow_run4   ] { ai_run(self.speed); };
void()  shadow_run4   = [$fly4,  shadow_run5   ] { ai_run(self.speed); };
void()  shadow_run5   = [$fly5,  shadow_run6   ] { ai_run(self.speed); };
void()  shadow_run6   = [$fly6,  shadow_run7   ] { ai_run(self.speed); };
void()  shadow_run7   = [$fly7,  shadow_run8   ] { ai_run(self.speed); };
void()  shadow_run8   = [$fly8,  shadow_run9   ] { shade_sfx_fly();  ai_run(self.speed); };
void()  shadow_run9   = [$fly7,  shadow_run10  ] { ai_run(self.speed); };
void()  shadow_run10  = [$fly6,  shadow_run11  ] { ai_run(self.speed); };
void()  shadow_run11  = [$fly5,  shadow_run12  ] { ai_run(self.speed); };
void()  shadow_run12  = [$fly4,  shadow_run13  ] { ai_run(self.speed); };
void()  shadow_run13  = [$fly3,  shadow_run14  ] { ai_run(self.speed); };
void()  shadow_run14  = [$fly2,  shadow_run1   ] { ai_run(self.speed); };

void()  shadow_form = {
    if (self.takedamage) shadow_run1();      // Already phased in.
    else shadow_form1(); // Materialize.
};

//  Melee attacks!
void()  shadow_bite1  = [$attack1,  shadow_bite2  ] { dark_melee(); };
void()  shadow_bite2  = [$attack2,  shadow_bite3  ] { dark_melee(); };
void()  shadow_bite3  = [$attack3,  shadow_bite4  ] { dark_melee(); };
void()  shadow_bite4  = [$attack4,  shadow_bite5  ] { dark_melee(); };
void()  shadow_bite5  = [$attack5,  shadow_bite6  ] { dark_melee(); };
void()  shadow_bite6  = [$attack6,  shadow_bite7  ] { dark_melee(); };
void()  shadow_bite7  = [$attack7,  shadow_bite8  ] { dark_melee(); };
void()  shadow_bite8  = [$attack8,  shadow_bite9  ] { dark_melee(); };
void()  shadow_bite9  = [$attack9,  shadow_bite10 ] { shade_sfx_fly(); dark_melee();Ryu_Bite(); };
void()  shadow_bite10 = [$attack8,  shadow_bite11 ] { dark_melee(); };
void()  shadow_bite11 = [$attack7,  shadow_bite12 ] { dark_melee(); };
void()  shadow_bite12 = [$attack6,  shadow_bite13 ] { dark_melee(); };
void()  shadow_bite13 = [$attack5,  shadow_bite14 ] { dark_melee(); };
void()  shadow_bite14 = [$attack4,  shadow_bite15 ] { dark_melee(); };
void()  shadow_bite15 = [$attack3,  shadow_bite16 ] { dark_melee(); };
void()  shadow_bite16 = [$attack2,  shadow_bite17 ] { dark_melee(); Ryu_Bite(); };
void()  shadow_bite17 = [$attack1,  shadow_run1   ] { dark_melee(); self.attack_state = AS_STRAIGHT; };

void() shadow_strike = {
    self.alpha = 0.7;
    self.attack_state = AS_STRAIGHT;    // Nightshade does not strafe.
    traceline(self.origin, self.enemy.origin, TRUE, self); // If path crosses contents, use only the bite.
    if (trace_inopen)
        if (trace_inwater) { shadow_bite1();  return; }

    // If close enough, it may bite or shoot.
    if (random() < 0.8)
        if (InMeleeRange (120)) { shadow_bite1();  return; }

    self.th_missile(); // Fire away instead.
};

//  Missile attacks!
void() shadow_missile1  = [$attack1,  shadow_missile2  ] {
    if (!self.takedamage) shadow_phase (TRUE);    // Fire command hack!
    self.alpha = 0.7;
    self.attack_state = AS_STRAIGHT;    // Never strafe  
    dark_missile();
};
void() shadow_missile2  = [$attack2,  shadow_missile3  ] { dark_missile(); };
void() shadow_missile3  = [$attack3,  shadow_missile4  ] { dark_missile(); };
void() shadow_missile4  = [$attack4,  shadow_missile5  ] { dark_missile(); };
void() shadow_missile5  = [$attack5,  shadow_missile6  ] { dark_missile(); };
void() shadow_missile6  = [$attack6,  shadow_missile7  ] { dark_missile(); };
void() shadow_missile7  = [$attack7,  shadow_missile8  ] { dark_missile(); };
void() shadow_missile8  = [$attack8,  shadow_missile9  ] { dark_missile(); };
void() shadow_missile9  = [$attack9,  shadow_missile10 ] { dark_missile();shade_sfx_fly();Shade_Meat(); };
void() shadow_missile10 = [$attack8,  shadow_missile11 ] { dark_missile(); };
void() shadow_missile11 = [$attack7,  shadow_missile12 ] { dark_missile(); };
void() shadow_missile12 = [$attack6,  shadow_missile13 ] { dark_missile(); };
void() shadow_missile13 = [$attack5,  shadow_missile14 ] { dark_missile(); };
void() shadow_missile14 = [$attack4,  shadow_missile15 ] { dark_missile(); };
void() shadow_missile15 = [$attack3,  shadow_missile16 ] { dark_missile(); };
void() shadow_missile16 = [$attack2,  shadow_missile17 ] { dark_missile(); };
void() shadow_missile17 = [$attack1,  shadow_run1      ] { dark_missile(); };

void() shadow_pain1  = [$pain1,   shadow_pain2  ] {};
void() shadow_pain2  = [$pain2,   shadow_pain3  ] {};
void() shadow_pain3  = [$pain3,   shadow_pain4  ] {};
void() shadow_pain4  = [$pain4,   shadow_pain5  ] {};
void() shadow_pain5  = [$pain5,   shadow_pain6  ] {};
void() shadow_pain6  = [$pain6,   shadow_run1   ] {};

void() shadow_painb1 = [$painb1,  shadow_painb2 ] {};
void() shadow_painb2 = [$painb2,  shadow_painb3 ] {};
void() shadow_painb3 = [$painb3,  shadow_painb4 ] {};
void() shadow_painb4 = [$painb4,  shadow_painb5 ] {};
void() shadow_painb5 = [$painb5,  shadow_painb6 ] {};
void() shadow_painb6 = [$painb6,  shadow_run1   ] {};

void() shadow_painc1 = [$painc1,  shadow_painc2 ] {};
void() shadow_painc2 = [$painc2,  shadow_painc3 ] {};
void() shadow_painc3 = [$painc3,  shadow_painc4 ] {};
void() shadow_painc4 = [$painc4,  shadow_painc5 ] {};
void() shadow_painc5 = [$painc5,  shadow_painc6 ] {};
void() shadow_painc6 = [$painc6,  shadow_run1   ] {};

void(entity inflictor, entity attacker, float damage) shadow_pain = {
    local   float   r, r1, r2;

    if (self.pain_finished > time) return; // Same size, standard pain.

    self.pain_finished = time + 0.5; 
    if (random() < 0.5) sound(self,CHAN_VOICE, "drake/shade/pain.wav",1,ATTN_NORM);
    else sound(self,CHAN_VOICE, "drake/shade/pain2.wav",1,ATTN_NORM);

    if (SUB_IgnorePain ()) return; // No pain anims in Nightmare.
    if (self.waitmin > time) {
        if ((random() * 400) > damage) return; // didn't flinch
    }
    // Will go into pain...
    self.waitmin = time + 5;
    self.alpha = 0.7;   // Reset alpha if it was fading.
    self.pain_finished = time + 0.5;
    self.attack_state = AS_STRAIGHT;
    self.attack_finished = 0;       // can attack anytime now!
    self.velocity = '0 0 0';    // Stop right now!
    
    r = random(); // Choose a pain scene.
    r1 = 0.4;
    r2 = 0.7;   // Was 0.8.
    // Standard pain.
	if (r < r1) shadow_pain1();
	else if (r < r2) shadow_painb1();
	else shadow_painc1();
};

// DEATH - - - - - - - - - - - - - - - -
void() shadow_boom = {
	// The nightshade releases its pawns and is forever destroyed.
    self.alpha = 1;
    self.deadflag = DEAD_DEAD;
    DropCoin(8);

    // Go boom.
    T_RadiusDamage(self, self, 100, world, DAMAGEALL);    // wrath=80, tarbaby=120.
    Rocket_Explosion2 (self.origin, 32, 5);
};
void() shadow_die1  = [$nova1,  shadow_die2  ] {};
void() shadow_die2  = [$nova2,  shadow_die3  ] {};
void() shadow_die3  = [$nova3,  shadow_die4  ] {};
void() shadow_die4  = [$nova4,  shadow_die5  ] {};
void() shadow_die5  = [$nova5,  shadow_die6  ] {};
void() shadow_die6  = [$nova6,  shadow_die7  ] {};
void() shadow_die7  = [$nova7,  shadow_die8  ] {};
void() shadow_die8  = [$nova8,  shadow_die10 ] {};
// Skip frame $nova9.
void() shadow_die10 = [$nova10, shadow_die11 ] {};
void() shadow_die11 = [$nova11, shadow_die12 ] {};
void() shadow_die12 = [$nova12, shadow_die13 ] {};
void() shadow_die13 = [$nova13, shadow_die14 ] {};
void() shadow_die14 = [$nova14, shadow_die15 ] {};
void() shadow_die15 = [$nova15, shadow_die16 ] {};
void() shadow_die16 = [$nova16, shadow_die17 ] {};
void() shadow_die17 = [$nova17, shadow_die18 ] { shadow_boom(); };
void() shadow_die18 = [$nova18, shadow_die18  ] { entity_remove(self,0.1); };

void() shadow_die = {
    monster_death_precheck();
    self.frame      = $nova1;
    self.alpha      = 0.7;
    self.movetype   = MOVETYPE_NONE;    // Freeze monster in place.
    if (random() < 0.5) sound(self,CHAN_VOICE, "drake/shade/death2.wav",1,ATTN_NORM);
    else sound(self,CHAN_VOICE, "drake/shade/death.wav",1,ATTN_NORM);

    shadow_die1();
};

void() monster_nightshade_precache = {
    precache_model ("progs/drake/shade.mdl");
    precache_model ("progs/drake/soul.mdl");
    precache_model ("progs/drake/dr1_head.mdl");  // Gib (head)
    precache_sound("demon/dhit2.wav");
    precache_sound("drake/dragon/flywater.wav");
    precache_sound("drake/shade/death.wav");
    precache_sound("drake/shade/death2.wav");
    precache_sound("drake/shade/fly.wav");
    precache_sound("drake/shade/idle.wav");
    precache_sound("drake/shade/moan.wav");
    precache_sound("drake/shade/pain.wav");
    precache_sound("drake/shade/pain2.wav");
    precache_sound("drake/shade/screech.wav");
    precache_sound("drake/shade/sing.wav");
    precache_sound("drake/dragon/ice.wav");
    precache_sound("drake/shade/taunt.wav");
    precache_sound("wizard/hit.wav");   // used by C code, so don't sound2
    precache_sound("nehahra/wraith/soul.wav");
};

// --> QUAKED monster_nightshade (1 0 0) (-32 -32 -24) (32 32 32) Ambush x Souls
void() monster_nightshade = {
	if (monster_checkrandomizer() == TRUE) return; // Check for any random monster setups
	if (monster_checkspawn() == TRUE) return; // Check all spawn exceptions (monsters.qc)

    self.sight_sound = "drake/shade/sing.wav";
    self.mdl = "progs/drake/shade.mdl";
    self.headmdl = "progs/drake/dr1_head.mdl";
    self.skin       = 0;    // Fix legacy code from early versions of Dragons.
    self.ryuflags   = 0;    // Make sure it's zero so it doesn't use water AI.
    self.waitmin    = 0;    // Pain sound timestamp.
    self.solid = SOLID_NOT;		// No interaction with world
    self.movetype = MOVETYPE_NONE;	// Static item, no movement
    if (self.bboxtype < 1) self.bboxtype = BBOX_SHADE;
    if (self.health < 1) self.health = 600;
    self.gibhealth = MON_NEVERGIB;
    self.alpha      = 0.7;
    self.th_stand   = shadow_stand;
    self.th_walk    = shadow_walk;
    self.th_run     = shadow_form1;
    self.th_melee   = shadow_strike;
    self.th_missile = shadow_missile1;
    self.th_pain    = shadow_pain;
    self.th_die     = shadow_die;
    self.th_checkattack   = Shade_CheckAttack;
    self.gibhealth = MON_NEVERGIB;
	if (self.deathstring == "") self.deathstring = " was etherialized by a Nightshade\n";
    shadow_speed();
    Resist_ChangeType(self,-1); // Always reset Ammo Resistance to be consistent
	self.resist_fire = 1; // Don't want to change this with size.
    if (!self.classtype) self.classtype = CT_MONSHADE;
    if (!self.classgroup) self.classgroup = CG_DRAGON;
    self.classmove = MON_MOVEFLY;
    monster_start();
};
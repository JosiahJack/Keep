// DRAGON (The Qtest/Drake version)
$cd progs/dragon
$origin 0 0 24
$base base 
$skin skin
$frame fly1 fly2 fly3 fly4 fly5 fly6 fly7 fly8
$frame attack1 attack2 attack3 attack4 attack5 attack6
$frame attack7 attack8 attack9
$frame pain1 pain2 pain3 pain4 pain5 pain6
$frame painb1 painb2 painb3 painb4 painb5 painb6
$frame painc1 painc2 painc3 painc4 painc5 painc6
$frame death1 death2 death3 death4 death5 death6 death7 death8 death9
$frame death10 death11 death12 death13
$frame deathb1 deathb2 deathb3 deathb4 deathb5 deathb6
$frame decap1 decap2 decap3 decap4 decap5 decap6 decap7 decap8 decap9
$frame decap10 decap11 decap12 decap13
$frame decapb1 decapb2 decapb3 decapb4 decapb5 decapb6

//  This checks whether the dragon is allowed to attack its target when one is in air while the other is in liquid.
float() Ryu_BlockCrossfire = {
    local float elements;

    if (self.th_missile) {
        elements = self.ryuflags & RYU_ELEMENTS;
        if (elements == RYU_USE_LITE) return FALSE;   // Shoot lightning into water to fry targets.
        else if (elements == RYU_USE_ICE) {   // Don't shoot ice if either endpoint is in lava.
            if (self.liquidbase == CONTENT_LAVA) {
                if (self.waterlevel > 1) return TRUE;    // Mouth in lava.
			}
            if (self.enemy.liquidbase == CONTENT_LAVA) return TRUE;    // Target covered under lava.
        }
        if (self.ryuflags & RYU_ALERT) return FALSE;   // Check alert AFTER element check. Smart enough to aim through water.
    }
    return TRUE; // Cannot attack at all.
};

//  This checks if the dragon is able to attack the target.
float() Draco_CanAttackTarget = {
    if (!enemy_vis) return FALSE;   // Standard.  Must see the target.
    if (!self.enemy.takedamage) return FALSE;   // In case mega-enforcer shields stays on long.
    // Don't let water-hating dragons get stuck trying to shoot zombies
    // that are underwater to death -- it is useless.
    if (Ryu_HatesWater ())
        if (self.enemy.xfl & XFL_ZOMBIE)    // Anyone harmed only by scar.
            if (!self.waterlevel)
                if (self.enemy.waterlevel > 2) return FALSE;

    return TRUE;
};

////////////////////////////////////////////////////////////////////////////
//  1.4.  Wyrm AI                                                         //
//                                                                        //
//  Special AI for huge (full Qtest-sized) boss dragons.                  //
////////////////////////////////////////////////////////////////////////////

// Movement when not on a path.
void() wyrm_glide = {
    local   entity  swap;
    local   float   sped, ofs, left;

	// Fly at walk speed when idle or run speed when mad at someone.
    sped = 20;
    if (self.enemy && !(self.spawnflags & SPAWN_SLOW)) sped = 32;

	// Change angles.
    ofs = anglemod(self.angles_y - self.ideal_yaw);
    if (ofs >= 180) {
		left = 1;  ofs = ofs - 360;
	} else left = 0;
    ChangeYaw ();
    if (fabs(ofs) <= self.yaw_speed)
        {ryu_untilt ();  left = 1;}
    else
        {ryu_tilt (left, 32);  left = 0;  sped = 20;}

	// Forward movement.
    swap = self.enemy;
    self.enemy = world;

    if (!Wyrm_WalkMove(self.angles_y, sped)) { // Something got in the way.
        if (left) self.ideal_yaw = anglemod(self.ideal_yaw + 180);
    }
    self.enemy = swap;
};

// Normal move.
void(entity targ) wyrm_move = {
    local   entity  swap, oe;
    local   float   sped, ofs, left, oy, nopath;
    local   vector  oang;

    if (self.movetarget)
        nopath = FALSE;
    else
        nopath = TRUE;

    sped = 20;
    if (self.enemy)
        if (!(self.spawnflags & SPAWN_SLOW))
            if (targ != self.enemy)     // Attacking if FALSE.
                sped = 32;

    self.goalentity = targ;     // In case we need 'movetogoal'.
    self.ideal_yaw = vectoyaw(targ.origin - self.origin);

    // Remember previous angles in case we need to change them back.
    oang = self.angles;
    oy = self.ideal_yaw;
	// Change angles.
    ofs = anglemod(self.angles_y - self.ideal_yaw);
    if (ofs >= 180)
        {left = 1;  ofs = ofs - 360;}
    else
        left = 0;
    ChangeYaw ();
    if (fabs(ofs) <= self.yaw_speed)
        ryu_untilt ();
    else
        {ryu_tilt (left, sped);  sped = 20;}

	// Forward movement.
    swap = self.enemy;
    if (nopath || (targ != self.enemy)) self.enemy = world;

    oe = self.enemy;
    if (!Wyrm_WalkMove(self.angles_y, sped)) { // Something got in the way.
        if (!self.enemy) {   // Restore previous angles then bump around with movetogoal.
            self.ideal_yaw = oy;
            self.angles = oang;
            QC_MoveToGoal(sped);
            ryu_untilt ();
        }
    }
    self.enemy = oe;    // In case of change by trigger_hurt and the like.

	// Vertical movement.  Must have a path to be allowed.
    if (!nopath)
        if (targ)           // If FALSE, no target to follow.
            if (!self.enemy)    // If FALSE, done already with builtin move.
            {
                left = targ.origin_z - self.origin_z;
                if (left > 8)
                    left = 8;
                else if (left < -8)
                    left = -8;
                ai_up (left);
            }

    self.enemy = swap;
};

////////////////////////////////////////////////////////////////////////////
//  2.1.  Dragon Attacks                                                  //
////////////////////////////////////////////////////////////////////////////

//  NOTE:  Use of fields normally unused (by monsters) in standard Quake.
//  Mod-makers beware!  If other custom code uses these fields, make sure they do not interfere with their use by the dragons.
//
// .worldtype = attack type dragon will use; like .weapon for clients.
// .count     = max shots per salvo; like .ammo_shells for clients.
// .height    = shot damage.
// .volume    = shots remaining in a salvo.

// Update 9/3/09:  count/volume replaced buy shots_max/shots_left.
//  NOTE #2:  There are even more such recycled fields further below.

//  Dragon Melee
//  This returns the point of the dragon's mouth relative to its origin. All frames from 8 to 16 are part of the attack scene.
vector() Ryu_Offset = {
    local   float   fr;

    // HACK:  If nightshade, convert its frames to dragon frames.
    if (self.classtype == CT_MONSHADE)
        fr = self.frame - 7;    // Nightshade appears only as medium-sized.
    else
        fr = self.frame;

	// Now find where the dragon's mouth is.
    if (self.classtype == CT_MONWYRM) {
		// Wyrm drake/dragon2.mdl.  Assumes +20.
        fr = self.frame;    // Define 'fr'!
        if (fr==16)  return '88 -9 2';    if (fr==15)  return '92 -7 20';
        if (fr==14)  return '94 -1 32';   if (fr==13)  return '86 -1 36';
        return '96 -1 20';
    }
	// Half-scale drake/dragon1.mdl.  Assumes +2.
	if (fr==16)  return '43 -5 -6';   if (fr==15)  return '46 -3 2';
	if (fr==14)  return '47 -1 8';    if (fr==13)  return '41 -1 12';
	return '47 -1 3';
};

void() Ryu_Bite = {
    local float damage;

    // Check if the bite attack can hit.
    if (!InMeleeRange (RYU_RANGE_MELEE)) return;
    if (!CanDamage (self.enemy, self)) return;
    if (!self.enemy.takedamage) return; // For mega-enforcer.

    // Bite attack is successful.
    // Inflict the damage.  Scar damage hurts and kills zombies.
    // Like many of Quake2 monsters' melee attacks, damage ranges from
    // x to x+5, while x is a multiple of 5, and damage has a minimum of 5.
    // Note:  x = ((maxs_x / 16) - 1 + random) * 5.
    // Update 4/23/2009:  Do 15-20 damage for standard.  Wyrms multiply damage.
    damage = 15 + random()*5;
    if (self.spawnflags & SPAWN_WYRM) damage = damage * 4; // Moot since wyrms can't bite.
    sound (self, CHAN_WEAPON, "demon/dhit2.wav", 1, ATTN_NORM);
    T_Damage (self.enemy, self, self, damage,DAMARMOR);
    SpawnMeatSpray(self, self.enemy,(crandom() * 200) - 100); // Throw a piece of meat from the dragon's head (mouth).
};

//  Dragon Aiming. This returns the spot where a projectile will strike.  Dragons will shoot at the spot where the target is currently standing.
vector() Ryu_TargetPoint = {
    local vector end;

    // If the dragon has no enemy, aim straight ahead.
    if (self.enemy) {
        end = Midpoint (self.enemy);

        // If target is in water and not the dragon, aim at the head.
        if (self.enemy.waterlevel >= 2)
            if (self.waterlevel < 2)
                end_z = end_z + (self.enemy.maxs_z * 0.5);

        return end;
    }
    // Aiming on its own... Aim forward and slightly downward.
    makevectors (self.angles);
    return (self.origin + v_forward*1024 - '0 0 16');
};

//  This creates a fireball shot by a dragon.  Used by both PCs and NPCs.
void(vector start, vector dir, float sped, float up, float damage) Ryu_Fire = {
    if (damage) {
        Meteor_Launch(self,start, dir,sped,damage); // Big super fireball.
        newmis.delay = time + 2.5; // Same fuse as a standard player grenade.
        newmis.movetype = MOVETYPE_TOSS;
    } else {
        // Normal fireball.  Fuse is (10 * reach / speed) + 1.  If speed is double the reach, duration is 6 frames.  Fade anim is 3 frames, so the pre-fade duration is 3 frames.
        Fireball_Launch(self, start, dir, sped, 9); // Don't use self.height for damage here because of transformed player use.
        newmis.delay = time + 0.3;
        newmis.noise = "drake/dragon/firehit.wav";
        if (Fireball_InWater(newmis)) return;
    }

    if (newmis.movetype == MOVETYPE_TOSS) {
        newmis.velocity_z = newmis.velocity_z + up;
        dir = normalize(newmis.velocity);
        newmis.angles = vectoangles(dir) + '90 0 0';
    }

    self.effects = self.effects | EF_MUZZLEFLASH;
};

//  This creates a shotgun burst of ice (or whatever).  The family of the Ps explained:
//  p1 = Origin of attack, generally out of one of the attacker's orifices.
//  p2 = Endpoint 1, generally where the target is when attack is launched.
//  p3 = Endpoint 2, where the target is predicted to be after some time.
//  p4 = Endpoint 3, a point chosen somewhere between p2 and p3.  Aim here!
void(vector p1, vector p2, float sped, float damage, entity targ, float shots, float atype)  Ryu_Multishot = {
    local float bomb, sped2, frac, loop;
    local vector dir, err, p3, p4;

    bomb = atype & RYU_BOMB; // Extra stuff for more multishot types.
    atype = atype & RYU_ELEMENTS;
	newmis.classgroup = CG_PROJALL;

    // Begin old multishot stuff.
    err = '6 4.5 0'; // For ice dragon, 5x the spread as fire spray.
    p3 = Aim_Lead (p1, p2, sped, targ);
    loop = floor(shots);
    while (loop > 0) {
        loop = loop - 1; // Do first because we use 'loop - 1' in calcs.
        if (loop) {
            frac = 1 - (loop / shots);
            if (self.spawnflags & SPAWN_SLOW)
                frac = frac * 0.5; // Can't fully track if slow.
            p4 = p2 + ((p3 - p2) * frac);
            sped2 = sped * (random() / 3 + 1);  // Boost speed by up to 33%.
        } else {
            err = '0 0 0'; 
            p4 = p3; // Aim final shot on target.
            sped2 = sped;
        }
        traceline (p1, p4, TRUE, self);
        if (trace_fraction < 1) p4 = p2; // Point is blocked, so don't lead.

        // Calculate aim vector.
        if (bomb && (atype != RYU_USE_LITE)) dir = Aim_Toss (p1, p4, sped2, 200, world);
        else dir = normalize (p4 - p1);

        dir = Maim_Scatter (dir, err);
        if (atype & RYU_ELEMENTS == RYU_USE_ICE) {
            // Ice spray.
            if (bomb) { // Explosive iceballs.
                Iceball_Toss (p1, dir, sped2, self.height);
                newmis.velocity_z = newmis.velocity_z + 200;
            } else { // Ice shards.  Default damage is 9, so raise it if too weak.
                Ice_Launch (p1, dir, sped2);    // Use 'sped' for same speed.
                newmis.delay = time + 0.7;  // Total duration.  Was 0.8.
            }
            if (newmis.dmg < damage)
                newmis.dmg = damage;
        } else if (bomb) {
            if (atype == RYU_USE_FIRE) Ryu_Fire(p1,dir,sped2,200,self.height);
            else if (atype == RYU_USE_LITE) RyuPlasma_Launch(p1,dir,sped2,self.height);
            else if (atype == RYU_USE_ACID) {
                Acidball_Launch(p1,dir,sped2,self.height);
                newmis.velocity_z = newmis.velocity_z + 200;
            }
        }
    }
};

//  This spawns a missile at the dragon's mouth then launches said missile at the target.  The missile cast varies by type.
void() Ryu_Shot_Fire = {
    local   entity  targ;   // Use shot leading if targ != world;
    local   vector  dir;    // Vector from 'start' to 'end'.
    local   vector  start;  // Location of dragon's mouth.
    local   vector  end;    // Place where projectile will strike.
    local   float   sped;   // Missile speed or lightning bolt range.
    local   float   frac;   // Lead coefficient.  0 = no lead, 1 = perfect.

	// As with players, pay ammo cost first then attack.
    if (self.shots_left < 1) return;     // Out of ammo.

	newmis = spawn();
	newmis.classgroup = CG_PROJALL;
    // Calculate lead coefficient.  The value begins at or close to zero at
    // the start of the salvo, then the value increases with each successive
    // shot until it reaches one at the final shot.
    frac = Frac_ShotDown();     // Lowers 'shots_left', pays ammo cost.
	
    if (self.spawnflags & SPAWN_SLOW) frac = frac * 0.5;      // Can't fully track if slow.

    targ = self.enemy;
    // Shot speed varies by dragon size -- bigger is faster.
    // Faster because of gravity or short range.
    // Note:  Proper speed is ((maxs_x / 16) * 100) + 600.
    // Update 4/23/2009:  1000 for dragons, 1200 for wyrms.
    // Speed may be increased by another 66%, so limit
    // speed to 1200 so that it cannot exceed 2000.
    if (self.spawnflags & SPAWN_WYRM) sped = 1200;
    else sped = 1000;

    makevectors (self.angles);

    // Find the location of the dragon's mouth (or head).
    start = Ryu_Offset ();
    start = self.origin + (v_forward * start_x) + (v_right * start_y) +
        (v_up * start_z);
    end = Ryu_TargetPoint ();   // Get the spot where dragon is aiming at.

    // Select an attack.
    if (self.worldtype == RYU_USE_FIRE) {
        sped = sped * 1.25;     // Fire spray shots are 25% faster.
        dir = Maim_LineEx (start, end, sped, targ, '1.2 0.9 0', frac);
        Ryu_Fire (start, dir, sped, 200, 0);
        if (self.height > 9) newmis.dmg = self.height;   // Extra damage.
        if (!self.shots_left || (self.shots_left == (self.shots_max - 1))) newmis.effects = newmis.effects | EF_DIMLIGHT;
    } else if (self.worldtype == RYU_USE_ACID) {
        dir = Maim_TossEx (start, end, sped, 200, targ, '0 0 0', frac);
        Acid_Toss (start, dir, sped);
        if (self.height > 9) newmis.dmg = self.height;   // Extra damage.
    } else if (self.worldtype == RYU_USE_LITE) {
        // Check for discharge, just like Thunderbolt-wielding player.
        self.effects = self.effects | EF_MUZZLEFLASH;
        if (self.waterlevel > 1) {
            // Dragon is deep enough in water so discharge.
            // Note:  Discharge is weak, so just fizzle harmlessly.
            sound (self, CHAN_WEAPON, "misc/power.wav", 1, ATTN_NORM); // vanilla id1 sound
            self.shots_left = 0;
            return;
        }
        sped = RYU_RANGE_BEST;

        // Dragon will aim bolt behind the target during the early frames
        // of a salvo.  This is done to reduce damage from an otherwise
        // unavoidable attack.  An exception is made if the target is in
        // the water, in which case, the aim becomes perfect (or rather
        // the error calcuation is skipped) to simulate water conductivity.
        if (self.enemy) {
            if (self.enemy.waterlevel < 2) end = end - (self.enemy.velocity * ((1 - frac) * 0.2));
		}

        dir = Maim_Line (start, end, 0, world, '0 0 0');    // Insta-hit.
        end = start + (dir * sped);

		LightningBolt (start, end, self, self.height, self, TE_LIGHTNING2); // Create the bolt of lightning.
    } else {
		// Multiple shot attacks.
        if (self.worldtype & RYU_BOMB) { // Super shots
            if (!(self.ryuflags & RYU_ALERT)) targ = world;
            if (self.worldtype & RYU_ELEMENTS == RYU_USE_LITE) sped = sped - 200;      // Treat as one size less.
        } else if (self.worldtype & RYU_ELEMENTS == RYU_USE_ICE) sped = sped * 1.25;
        else return;     // Invalid attack type.

        self.shots_left = 0;   // Launch all shots in one burst.
        Ryu_Multishot (start, end, sped, self.height, targ, self.shots_max, self.worldtype);
    }
};

// Used for delayed calls to Ryu_Shot_Fire by Ryu_Shot.
void() Ryu_Shot_Think = {
    if (self.owner.health > 0) SUB_ThinkImmediate (self.owner, Ryu_Shot_Fire);
    remove (self);
};

// This calls the dragon's missile spawning function now or later. If delayed, a dummy entity to spawned to call the delayed function at the time designated by 'pause'.
void(float pause) Ryu_Shot = {
    local entity echo;

    if (pause) {
        echo = spawn();
		echo.classgroup = CG_PROJALL;
        echo.owner = self;
        echo.nextthink = time + pause;
        echo.think = Ryu_Shot_Think;
    } else
        Ryu_Shot_Fire ();
};

void() ryu_sfx_fly = {
    // Not while Quad is sounding.
    if (self.super_sound < time) {
        if (self.waterlevel <= 1)     // Not while in the water.
            sound (self, CHAN_BODY, "drake/dragon/fly.wav", 1, ATTN_NORM);
        else if ((self.liquidbase == CONTENT_WATER) || (self.liquidbase == CONTENT_SLIME))
            sound (self, CHAN_BODY, "drake/dragon/flywater.wav", 1, ATTN_NORM);
    }
};

void() ryu_sfx_fire = {
    local float type;

    type = self.worldtype & RYU_ELEMENTS;
    if (type == RYU_USE_FIRE)
        sound (self, CHAN_WEAPON, "drake/dragon/fire.wav", 1, ATTN_NORM);
    else if (type == RYU_USE_ACID)
        sound (self, CHAN_WEAPON, "drake/dragon/acid.wav", 1, ATTN_NORM);
    else if (type == RYU_USE_LITE) {
        if (self.worldtype & RYU_BOMB)
            sound (self, CHAN_WEAPON, "weapons/lstart.wav", 1, ATTN_NORM);
        else {
            sound (self, CHAN_WEAPON, "weapons/lhit.wav", 1, ATTN_NORM);
            sound (self, CHAN_AUTO, "weapons/lstart.wav", 1, ATTN_NORM);
        }
    }
    else if (type == RYU_USE_ICE)
        sound (self, CHAN_WEAPON, "drake/imp/shard.wav", 1, ATTN_NORM);
};

void() ryu_sfx_idle = {sound (self, CHAN_VOICE, "drake/dragon/idle1.wav", 1, ATTN_NORM);};

//  Fly animation forward.  Used for stand, walk, and run anims.
//  Stand = Dragon hovers in place.   Walk  = The dragon slowly glides along its path.   Run   = The dragon flies quickly toward the enemy.
void() wyrm_fly_anim = {
    local   float   fadd;

    if ((self.frame > 7) || (self.walkframe >= 13))
        fadd = self.walkframe = 0;
    else if (self.walkframe >= 7)
        fadd = 14 - self.walkframe;
    else
        fadd = self.walkframe;

    self.frame = $fly1 + fadd;
    self.walkframe = self.walkframe + 1;
    if ( self.frame == $fly8 ) ryu_sfx_fly ();
};

void() ryu_stand1 =[ $fly1, ryu_stand1  ] {wyrm_fly_anim(); ai_stand();};

void() ryu_walk1  =[ $fly1, ryu_walk1   ] {wyrm_fly_anim(); ai_walk(SPEED_RYU_MIN);};

void() ryu_run1   =[ $fly1, ryu_run1    ] {wyrm_fly_anim(); ai_run(self.speed);};

void() wyrm_fly   =[ $fly1, wyrm_fly    ] {
    wyrm_fly_anim();

    // Custom move and attack AI.
    if (self.enemy)
        wyrm_move (self.enemy);
    else {
		if (self.charmer || self.movetarget) wyrm_glide ();
	}

    if ( self.frame == $fly1 ) ai_stand(); // just updates seeing an enemy
};

void() wyrm_start = {
    if (self.movetarget.classtype != CT_PATHCORNER && !self.charmer) {
        self.movetarget = world;
        self.ideal_yaw = self.angles_y;
    }
    self.th_stand = self.th_walk = self.th_run = wyrm_fly;
    wyrm_fly ();
};

void() wyrm_go = {
    if (self.classtype == CT_MONWYRM)
        wyrm_fly ();
    else
        ryu_run1 ();
};

void() dragon_bite1  =[ $attack1,  dragon_bite2  ] { self.show_hostile = time + 1; ryu_melee(); };
void() dragon_bite2  =[ $attack2,  dragon_bite3  ] {ryu_melee();};
void() dragon_bite3  =[ $attack3,  dragon_bite4  ] {ryu_melee();};
void() dragon_bite4  =[ $attack4,  dragon_bite5  ] {ryu_melee();};
void() dragon_bite5  =[ $attack5,  dragon_bite6  ] {ryu_melee();};
void() dragon_bite6  =[ $attack6,  dragon_bite7  ] {ryu_melee();};
void() dragon_bite7  =[ $attack7,  dragon_bite8  ] {ryu_melee();};
void() dragon_bite8  =[ $attack8,  dragon_bite9  ] {ryu_melee();};
void() dragon_bite9  =[ $attack9,  dragon_bite10 ] {ryu_melee(); ryu_sfx_fly (); Ryu_Bite ();};
void() dragon_bite10 =[ $attack8,  dragon_bite11 ] {ryu_melee();};
void() dragon_bite11 =[ $attack7,  dragon_bite12 ] {ryu_melee();};
void() dragon_bite12 =[ $attack6,  dragon_bite13 ] {ryu_melee();};
void() dragon_bite13 =[ $attack5,  dragon_bite14 ] {ryu_melee();};
void() dragon_bite14 =[ $attack4,  dragon_bite15 ] {ryu_melee();};
void() dragon_bite15 =[ $attack3,  dragon_bite16 ] {ryu_melee();};
void() dragon_bite16 =[ $attack2,  dragon_bite17 ] {ryu_melee(); Ryu_Bite ();};
void() dragon_bite17 =[ $attack1,  ryu_go     ] {ryu_melee(); self.attack_state = AS_STRAIGHT; self.walkframe = 0;};

// Check if missile attack is effective or not.
float(float chance) Ryu_CanBite = {
    if (!self.th_missile) return TRUE; // Can't shoot.
    if (Ryu_NoShot (self)) return TRUE; // Not allowed to fire.
    if (self.enemy.solid <= SOLID_TRIGGER) return TRUE; // Missile attacks pass through non-solid enemies.
	if (check_liquidblock(self.origin, self.enemy.origin)) return FALSE; // Check for liquid surface block condition
    if (random() < chance && InMeleeRange(RYU_RANGE_MELEE)) return TRUE; // Now check if the dragon really wants to bite.
    return FALSE; // Don't bite -- fire away instead.
};

//  Melee attack start.  About midway into the animation, the dragon decides whether to bite or to shoot something.  This is used by
//  smart dragons to foil the 'run in-and-out' strategy used by players. (Also called 'shambler dance' by the authors of Quoth.)
//  That is, run in to trigger melee attack, then run away to make said attack whiff.  
void() dragon_strike = {
    local float chance;

    if (self.inpain >= time) {
		// Dragon wants to circle-strafe and shoot.
        self.attack_state = AS_SLIDING;
        if (random() < 0.5) self.lefty = !self.lefty;
        chance = 0;
    } else {
		// Try to close in.  High chance of bite.  Always bite zombies or anyone else who is hurt only by scar damage.
        self.attack_state = AS_STRAIGHT;
        if (Ryu_KeepAway (self.enemy))
            chance = 0;     // Always shoot if trying to get away.
        else if (self.enemy.xfl & XFL_ZOMBIE)
            chance = 1;     // Bite causes scar damage.
        else
            chance = 0.8;   // Standard.
    }
    // If dragon can bite the target, do it.
    if (Ryu_CanBite (chance))
        dragon_bite1 ();
    else
        self.th_missile ();   // Shoot at target.  Assumes th_missile exists.
};

//  This makes the dragon decide whether or not to use meteor instead of fire spray.
float() Ryu_UseSpecial = {
    local   float   atype;

    if (self.spawnflags & SPAWN_WYRM) return TRUE;    // Big enough to spam multiple destructive blasts.

    // Smaller dragons choose between several small shots or one big blast.
    // Most small shots are faster and fatter but have limited range.
    // Big shots are either slower or bound by gravity, but cause high damage
    // and splash.  A spray of small shots is preferable to one big shot,
    // so if the enemy is in range and not a zombie, spray away!
    atype = self.worldtype & RYU_ELEMENTS;
    if (atype == RYU_USE_FIRE) {
		// If water is in the way, shoot meteors to penetrate it.
        if (self.waterlevel >= 2) return TRUE; // Underwater.  Only meteors are effective.
        if (self.enemy)
            if (self.enemy.waterlevel >= 3) return TRUE;    // Target is underwater.
    }
    if (self.enemy) {
		// If enemy is a zombie or too far away, lob big shots.
        if (self.enemy.xfl & XFL_ZOMBIE) {
            // Zombies need high damage to kill.
            if (atype != RYU_USE_FIRE) return TRUE; // Fire causes scar damage.
        }

        // All acid shots have same flight.
        if (atype != RYU_USE_ACID) {
            if (vlen(self.enemy.origin - self.origin) > RYU_RANGE_BEST) return TRUE;
        }
    }
    return FALSE;   // Spray small shots.
};

//  This selects the attack used based on type.
void() Ryu_SetAttack = {
    local   float   shots, element, fts, multi; // fts = Frames To Shoot. multi = Multishot attack if TRUE.

	// Select attack type.
    element = self.worldtype = self.ryuflags & RYU_ELEMENTS;
    if (Ryu_UseSpecial ()) self.worldtype = self.worldtype | RYU_BOMB;

	// Select attack based on type and change the thinking logic accordingly.
	// Recycled fields alert!
	// .wait        = time to add between shots in a salvo.
	// .delay       = time between an attack function call and the attack itself.
    if (self.worldtype & RYU_BOMB) {
        if (self.spawnflags & SPAWN_WYRM) shots = 4;
        else shots = 1;

        if (element == RYU_USE_LITE) self.height = 40;
        else self.height = 80;

        self.shots_max = self.shots_left = shots;
        self.wait = 0.6 / shots;
        self.delay = 0.3;
    } else {
		shots = 8; // Generic projectile attacks
        fts = 6;
        multi = FALSE;
        if (self.worldtype == RYU_USE_LITE) {
            shots = ((shots / 2) & 255) + ((random() * 2 * (shots & 1)) & 1);
            self.height = 10;   // Same damage as shambler bolt.
            if (shots > 12) {self.height = shots; shots = 10; fts = 5;}
        } else {
            // Damage.
            self.height = 9;
            // Special:  If too many shots, cap number and increase damage.
            if (self.worldtype == RYU_USE_FIRE)
                {if (shots > 18) {self.height = shots / 2; shots = 18;}}
            else
                {if (shots > 9) {self.height = shots; shots = 9;}}
            // Ice check.
            if (self.worldtype == RYU_USE_ICE) multi = TRUE;
        }
        // Shots.
        self.shots_max = self.shots_left = shots;
        // Rate of fire.
        if (shots > fts)
            self.wait = fts / 10 / shots;
        else
            self.wait = 0.1; // Attack delay.

        // Note:  Multishot attacks launches all ammo in an instant, so treat them as single-shot.
        if ((self.shots_left <= 1) || multi)
            self.delay = 0.3;  // $attack9
        else if (self.shots_left <= 2)
            self.delay = 0.2;  // $attack8
        else if (self.shots_left <= 4)
            self.delay = 0.1;  // $attack7
        else
            self.delay = 0;    // $attack6
    }
};

// Standard missile attack for dragons.
void() ryu_rapid_fire = {
    if (!self.wait)
        self.wait = 0.1; // Do this to avoid infinite loop.
    else if (self.wait < 0.01)
        self.wait = 0.01; // 10 shots per frame max -- spamtastic.

    // Note:  Start _click with 0.1 or higher to delay attack. 0.1 is for ten frames per second, the default animation rate.
    while (self.delay < 0.1) {
        if (self.shots_left == self.shots_max) ryu_sfx_fire(); // Play sound on the first shot.
        Ryu_Shot (self.delay); // Spawn the attack.
        self.delay = self.delay + self.wait;
    }
    self.delay = self.delay - 0.1;
};

void() dragon_ranged = {
    if (self.classtype == CT_MONWYRM) {
        wyrm_move (self.enemy);
    } else {
        if (ryu_step(FALSE)) walkmove(self.angles_y, SPEED_RYU_MIN);
	}
};
void() dragon_missile1  =[ $attack1,  dragon_missile2  ] {
    self.show_hostile = time + 1;   // wake monsters up
    if (self.classtype != CT_MONWYRM) Ryu_StrafeOption ();
    dragon_ranged();
};
void() dragon_missile2  =[ $attack2,  dragon_missile3  ] {dragon_ranged();};
void() dragon_missile3  =[ $attack3,  dragon_missile4  ] {dragon_ranged();};
void() dragon_missile4  =[ $attack4,  dragon_missile5  ] {dragon_ranged();};
void() dragon_missile5  =[ $attack5,  dragon_missile6  ] {dragon_ranged();};
void() dragon_missile6  =[ $attack6,  dragon_missile7  ] {dragon_ranged(); Ryu_SetAttack(); ryu_rapid_fire();};
void() dragon_missile7  =[ $attack7,  dragon_missile8  ] {dragon_ranged(); ryu_rapid_fire();};
void() dragon_missile8  =[ $attack8,  dragon_missile9  ] {dragon_ranged(); ryu_rapid_fire();};
void() dragon_missile9  =[ $attack9,  dragon_missile10 ] {dragon_ranged(); ryu_sfx_fly(); ryu_rapid_fire();};
void() dragon_missile10 =[ $attack8,  dragon_missile11 ] {dragon_ranged(); ryu_rapid_fire();};
void() dragon_missile11 =[ $attack7,  dragon_missile12 ] {dragon_ranged(); ryu_rapid_fire();};
void() dragon_missile12 =[ $attack6,  dragon_missile13 ] {dragon_ranged();};
void() dragon_missile13 =[ $attack5,  dragon_missile14 ] {dragon_ranged();};
void() dragon_missile14 =[ $attack4,  dragon_missile15 ] {dragon_ranged();};
void() dragon_missile15 =[ $attack3,  dragon_missile16 ] {dragon_ranged();};
void() dragon_missile16 =[ $attack2,  dragon_missile17 ] {dragon_ranged();};
void() dragon_missile17 =[ $attack1,  ryu_go        ] {
    dragon_ranged();
    if (self.classtype == CT_MONWYRM) self.attack_finished = time + (1.2 * (3 - skill));
    self.walkframe = 0;
};

void() dragon_pain1  =[ $pain1,   dragon_pain2  ] {ryu_untilt();};
void() dragon_pain2  =[ $pain2,   dragon_pain3  ] {ryu_untilt();};
void() dragon_pain3  =[ $pain3,   dragon_pain4  ] {ryu_untilt();};
void() dragon_pain4  =[ $pain4,   dragon_pain5  ] {ryu_untilt();};
void() dragon_pain5  =[ $pain5,   dragon_pain6  ] {ryu_untilt();};
void() dragon_pain6  =[ $pain6,   ryu_go     ] {ryu_untilt();};

void() dragon_painb1 =[ $painb1,  dragon_painb2 ] {ryu_untilt();};
void() dragon_painb2 =[ $painb2,  dragon_painb3 ] {ryu_untilt();};
void() dragon_painb3 =[ $painb3,  dragon_painb4 ] {ryu_untilt();};
void() dragon_painb4 =[ $painb4,  dragon_painb5 ] {ryu_untilt();};
void() dragon_painb5 =[ $painb5,  dragon_painb6 ] {ryu_untilt();};
void() dragon_painb6 =[ $painb6,  ryu_go     ] {ryu_untilt();};

void() dragon_painc1 =[ $painc1,  dragon_painc2 ] {ryu_untilt();};
void() dragon_painc2 =[ $painc2,  dragon_painc3 ] {ryu_untilt();};
void() dragon_painc3 =[ $painc3,  dragon_painc4 ] {ryu_untilt();};
void() dragon_painc4 =[ $painc4,  dragon_painc5 ] {ryu_untilt();};
void() dragon_painc5 =[ $painc5,  dragon_painc6 ] {ryu_untilt();};
void() dragon_painc6 =[ $painc6,  ryu_go     ] {ryu_untilt();};

void(entity inflictor, entity attacker, float damage) wyrm_pain = {
    local float r;      // Multi-purpose number.

    if (self.pain_finished > time) return;
    
    self.pain_finished = time + 1;
    if (self.classtype == CT_MONWYRM) {
		// Wyrm:  Spin toward attacker if not on a path. Do only if it can show pain at this time.
        if (!self.movetarget || self.charmer != self.movetarget)       // Must not have a path to follow.
            if (attacker)
                if (self.enemy == attacker)
                    if (self.attack_finished <= time)   // Don't spin if it can't attack.
                        if (visible (attacker)) self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
    }

	if (random() < 0.5)
		sound (self, CHAN_VOICE, "drake/dragon/pain1.wav", 1, ATTN_NORM);
	else
		sound (self, CHAN_VOICE, "drake/dragon/pain2.wav", 1, ATTN_NORM);

    if ((random() * 400) > damage) return; // didn't flinch
    if (damage < self.max_health * 0.01) return; // Damage dealt is too low to cause flinching.
    if (SUB_IgnorePain ()) return; // No pain anims in Nightmare.

    self.inpain = time + 2; // Strafe soon after pain.
    self.attack_state = AS_STRAIGHT;
    self.attack_finished = 0;       // can attack anytime now!
    self.walkframe = 0;     // Reset fly anim.

    // Choose one of three pain scenes.
    r = random();
    if (r < 0.4)
        dragon_pain1 ();
    else if (r < 0.7)       // Was 0.8 in older Dragons.
        dragon_painb1 ();
    else
        dragon_painc1 ();
};

void() dragon_die1  =[ $death1,   dragon_die2  ] {DropCoin(2);};
void() dragon_die2  =[ $death2,   dragon_die3  ] {DropCoin(4);monster_check_gib();};
void() dragon_die3  =[ $death3,   dragon_die4  ] {monster_check_gib(); self.solid      = SOLID_NOT; };
void() dragon_die4  =[ $death4,   dragon_die5  ] {};
void() dragon_die5  =[ $death5,   dragon_die6  ] {};
void() dragon_die6  =[ $death6,   dragon_die7  ] {};
void() dragon_die7  =[ $death7,   dragon_die8  ] {};
void() dragon_die8  =[ $death8,   dragon_die9  ] {};
void() dragon_die9  =[ $death9,   dragon_die10 ] {};
void() dragon_die10 =[ $death10,  dragon_die11 ] {};
void() dragon_die11 =[ $death11,  dragon_die12 ] {};
void() dragon_die12 =[ $death12,  dragon_die13 ] {monster_death_postcheck();};
void() dragon_die13 =[ $death13,  dragon_die13  ] { monster_deadbody_check(); };

void() dragon_dieb1 =[ $deathb1,  dragon_dieb2 ] {DropCoin(2); };
void() dragon_dieb2 =[ $deathb2,  dragon_dieb3 ] {DropCoin(4);monster_check_gib();};
void() dragon_dieb3 =[ $deathb3,  dragon_dieb4 ] {monster_check_gib(); self.solid      = SOLID_NOT; };
void() dragon_dieb4 =[ $deathb4,  dragon_dieb5 ] {};
void() dragon_dieb5 =[ $deathb5,  dragon_dieb6 ] { monster_death_postcheck();};
void() dragon_dieb6 =[ $deathb6,  dragon_dieb6  ] { monster_deadbody_check(); };

void() dragon_die = {
    monster_death_precheck();

    self.angles_x = self.angles_z = 0; // Snap tilt angles back to zero now.

    if (!self.gibbed) {
        self.velocity_x = -200 + 400*random();
        self.velocity_y = -200 + 400*random();
        self.velocity_z =  100 + 100*random();
        self.flags = self.flags - (self.flags & FL_ONGROUND);
        sound (self, CHAN_VOICE, "drake/dragon/death1.wav", 1, ATTN_NORM);
        if (random() < 0.5) {
    	    // Shove it up a little for the fallback death anim.
            self.velocity_z = 250 + 100*random();
            dragon_die1 ();
        } else
            dragon_dieb1 ();
    }
};

void() wyrm_explode = {
    local   entity  swap;
    local   vector  org, vx, vy, vz;

    // Lavasplash particles form a box with a size of 270x270x64. 135 * 1.4142 = 190.9188.  So use 160 damage for explosion radius of 200.
    T_RadiusDamage (self, self, 160, self, DAMAGEALL); // Damage first, then effects.
    sound (self, CHAN_BODY, "boss1/out1.wav", 1, ATTN_NORM);
    Tent_Point (TE_LAVASPLASH, self.origin - '0 0 32');
	self.gib1mdl = "progs/drake/dr2_lw.mdl";
	self.gib1mdl = "progs/drake/dr2_rw.mdl";
	self.gib1mdl = "progs/drake/dr2_tail.mdl";

    // The big fireball at the center.
    swap = self;
    self = spawn();
    setorigin (self, swap.origin + '0 0 24');
    WarpExplosion ();
    self = swap;
    self.health = -99;      // Spawn dragon parts. Some gibs get some velocity.
    org = self.origin;
    makevectors (self.angles);
    vx = v_forward;  vy = v_right;  vz = v_up;
    sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
    // Throw dragon parts first.  They will be thrown from a point relative to the body instead of randomly.
    // Since we do not want to update corpse origin, don't use setorigin.
    self.origin = org - vy*72 - vz*20;
	ThrowGib(11, 1);
    self.origin = org + vy*72 - vz*20;
    ThrowGib(12, 1);
    if ( self.frame == $deathb6 )
        self.origin = org - vx*72 - vz*20;
    else
        self.origin = org + vx*72 - vz*20;
	ThrowGib(13, 1);
    self.origin = org;      // Restore origin.
    ThrowGib (2, 5); // Throw random meat chunks.
    ThrowGib (3, 2);

    // Throw the head.  Now we can set origin for real.
    if ( self.frame == $deathb6 )
        org = org + (vx * 88);
    else
        org = org - (vx * 88);
    setorigin (self, org);
	ThrowGib (25,1); // headmdl
};

void() ryu_go = {
    if (self.classtype == CT_MONWYRM)
        wyrm_fly ();
    else
        ryu_run1 ();
};

void() wyrm_countdown = {
    if (self.cnt > 0)
        self.cnt = self.cnt - 1;
    else
        self.think = wyrm_explode;
};

void() wyrm_die1  =[ $death1,  wyrm_die2  ] {};
void() wyrm_die2  =[ $death2,  wyrm_die3  ] {};
void() wyrm_die3  =[ $death3,  wyrm_die4  ] {self.solid      = SOLID_NOT;};
void() wyrm_die4  =[ $death4,  wyrm_die5  ] {};
void() wyrm_die5  =[ $death5,  wyrm_die6  ] {DropCoin(4);};
void() wyrm_die6  =[ $death6,  wyrm_die7  ] {death_puff();};
void() wyrm_die7  =[ $death7,  wyrm_die8  ] {};
void() wyrm_die8  =[ $death8,  wyrm_die9  ] {};
void() wyrm_die9  =[ $death9,  wyrm_die10 ] {};
void() wyrm_die10 =[ $death10, wyrm_die11 ] {};
void() wyrm_die11 =[ $death11, wyrm_die12 ] {death_puff();};
void() wyrm_die12 =[ $death12, wyrm_die13 ] {DropCoin(2);};
void() wyrm_die13 =[ $death13, wyrm_die14 ] {death_puff(); self.nextthink = time + 0.2;};
void() wyrm_die14 =[ $death13, wyrm_die15 ] {death_puff(); self.nextthink = time + 0.3;};
void() wyrm_die15 =[ $death13, wyrm_die16 ] {death_puff(); self.nextthink = time + 0.2;};
void() wyrm_die16 =[ $death13, wyrm_die16 ] {death_puff(); wyrm_countdown();};

void() wyrm_dieb1  =[ $deathb1,  wyrm_dieb2  ] {};
void() wyrm_dieb2  =[ $deathb2,  wyrm_dieb3  ] {};
void() wyrm_dieb3  =[ $deathb3,  wyrm_dieb4  ] {};
void() wyrm_dieb4  =[ $deathb4,  wyrm_dieb5  ] {};
void() wyrm_dieb5  =[ $deathb5,  wyrm_dieb6  ] {DropCoin(4);};
void() wyrm_dieb6  =[ $deathb6,  wyrm_dieb7  ] {death_puff(); self.nextthink = time + 0.5;};
void() wyrm_dieb7  =[ $deathb6,  wyrm_dieb8  ] {death_puff(); self.nextthink = time + 0.4;};
void() wyrm_dieb8  =[ $deathb6,  wyrm_dieb9  ] {death_puff(); self.nextthink = time + 0.3;};
void() wyrm_dieb9  =[ $deathb6,  wyrm_dieb10 ] {death_puff(); DropCoin(2); self.nextthink = time + 0.2;};
void() wyrm_dieb10 =[ $deathb6,  wyrm_dieb10 ] {death_puff(); wyrm_countdown();};

// Special death for the dragon king.
void() wyrm_die = {
    monster_death_precheck();
    
    // Snap tilt angles back to zero now.
    self.angles_x = self.angles_z = 0;

    // No gib check, no decapitation, just a simple death scene.
    // Well, it is like Shub's with an initial dying anim then the big kaboom.
    self.cnt = (random() * 10 + 5) & 15;    // Extra explosions before last.
    self.velocity_x = -200 + 400*random();
    self.velocity_y = -200 + 400*random();
    self.velocity_z =  100 + 100*random();
    self.flags = self.flags - (self.flags & FL_ONGROUND);
    // The wyrm is a boss, so use full volume.
    sound (self, CHAN_VOICE, "drake/dragon/death1.wav", 1, ATTN_NONE);
    if (random() < 0.5) {
    	// Shove it up a little for the fallback death anim.
        self.velocity_z = 250 + 100*random();
        wyrm_die1 ();
    } else
        wyrm_dieb1 ();
};

void() dragon_revive1  =[ $death12, dragon_revive2  ] {};
void() dragon_revive2  =[ $death11, dragon_revive3  ] {};
void() dragon_revive3  =[ $death10, dragon_revive4  ] {};
void() dragon_revive4  =[ $death9,  dragon_revive5  ] {};
void() dragon_revive5  =[ $death8,  dragon_revive6  ] {};
void() dragon_revive6  =[ $death7,  dragon_revive7  ] {};
void() dragon_revive7  =[ $death6,  dragon_revive8  ] {};
void() dragon_revive8  =[ $death5,  dragon_revive9  ] {};
void() dragon_revive9  =[ $death4,  dragon_revive10 ] {};
void() dragon_revive10 =[ $death3,  dragon_revive11 ] {};
void() dragon_revive11 =[ $death2,  dragon_revive12 ] {};
void() dragon_revive12 =[ $death1,  ryu_run1      ] {};

void() dragon_reviveb1 =[ $deathb5, dragon_reviveb2 ] {};
void() dragon_reviveb2 =[ $deathb4, dragon_reviveb3 ] {};
void() dragon_reviveb3 =[ $deathb3, dragon_reviveb4 ] {};
void() dragon_reviveb4 =[ $deathb2, dragon_pain4    ] {};

void() dragon_revive = {
    // Choose revive scene based on current frame.
    self.flags = (self.flags - (self.flags & FL_ONGROUND)) | FL_FLY;
    if ( self.frame == $deathb6 )
        dragon_reviveb1 ();
    else
        dragon_revive1 ();
};

void() dragon_win = {
	ryu_sfx_idle();
    if (self.movetarget || self.charmer)
        self.th_walk ();
    else
        self.th_stand ();
};

float   RYUSKIN_RED        = 0;
float   RYUSKIN_GREEN      = 1;
float   RYUSKIN_BLUE       = 2;
float   RYUSKIN_WHITE      = 3;
float   RYUSKIN_GOLD       = 4; // Kept only for Soul of Evil.

void() monster_ryu_precache = {
    precache_model ("progs/drake/dr1_head.mdl");  // Gib (head)
    precache_model ("progs/drake/dr1_lw.mdl");    // Gib (left wing)
    precache_model ("progs/drake/dr1_rw.mdl");    // Gib (right wing)
    precache_model ("progs/drake/dr1_tail.mdl");  // Gib (tail)
    precache_model ("progs/drake/dragon1.mdl");   // Qtest dragon (various sizes)
    precache_model ("progs/drake/acidbal1.mdl");  // Bile bomb
    precache_model ("progs/drake/ice.mdl");       // Ice Shard
    precache_model ("progs/drake/iceball.mdl");   // Ice Ball
    precache_model ("progs/drake/plasma.mdl");    // Plasma ball
    precache_model ("progs/drake/s_wave2.spr");   // Ice bolt ripple
    precache_model ("progs/ad171/proj_wiz.mdl");   // Acid shot
    precache_sound ("demon/dhit2.wav");
    precache_sound ("drake/dragon/acid.wav");
    precache_sound ("drake/dragon/death1.wav");
    precache_sound ("drake/dragon/fire.wav");
    precache_sound ("drake/dragon/firehit.wav");
    precache_sound ("drake/dragon/fly.wav");
    precache_sound ("drake/dragon/flywater.wav");
    precache_sound ("drake/dragon/icehit.wav");
    precache_sound ("drake/dragon/idle1.wav");
    precache_sound ("drake/dragon/pain1.wav");
	precache_sound ("drake/dragon/pain2.wav"); // Qmaster added this.  The sound existed already in Drake, but it was never played.
    precache_sound ("drake/dragon/sight1.wav");
    precache_sound ("drake/imp/shard.wav");
    precache_sound ("misc/power.wav");      // Discharge & Fizzle, vanilla id1 sound
    precache_sound ("drake/weapons/shatter.wav");
    precache_sound ("wizard/hit.wav");
    precache_sound ("rogue/plasma/explode.wav");
    precache_model ("progs/drake/dr2_head.mdl");  // Gib (head)
    precache_model ("progs/drake/dr2_lw.mdl");    // Gib (left wing)
    precache_model ("progs/drake/dr2_rw.mdl");    // Gib (right wing)
    precache_model ("progs/drake/dr2_tail.mdl");  // Gib (tail)
    precache_model ("progs/drake/dragon2.mdl");   // Qtest dragon (full-sized)
    precache_model ("progs/drake/warp2.mdl");     // Big explosion
    precache_sound ("boss1/out1.wav");
    precache_sound ("hknight/hit.wav");     // used by C code, so don't sound2
    precache_sound ("zerstorer/trog/bigboom.wav");
};

// --> QUAKED monster_ryu (1 0 0) (-56 -56 -24) (56 56 56) Ambush Boss Fast Slow
void() monster_ryu = {
    local float powlevel, element, evade;

	if (monster_checkrandomizer() == TRUE) return; // Check for any random monster setups
	if (monster_checkspawn() == TRUE) return; // Check all spawn exceptions (monsters.qc)

    self.gib1mdl = "progs/drake/dr1_lw.mdl";
    self.gib2mdl = "progs/drake/dr1_rw.mdl";
    self.gib3mdl = "progs/drake/dr1_tail.mdl";
    if (self.skin == RYUSKIN_GREEN)        self.ryuflags = RYU_USE_ACID;
    else if (self.skin == RYUSKIN_BLUE)    self.ryuflags = RYU_USE_LITE;
    else if (self.skin == RYUSKIN_WHITE)   self.ryuflags = RYU_USE_ICE;
    else                                   self.ryuflags = RYU_USE_FIRE; //self.skin == RYUSKIN_RED

    // Ryu Elemental stats based on elemental type.
    evade = TRUE;
    element = self.ryuflags & RYU_ELEMENTS;
    if (element == RYU_USE_ACID) {
		self.resist_poison = self.resist_acid = 0.5; // Both slime/poisonous and poison crossbow bolt resistance.
		evade = FALSE;
		precache_model ("progs/drake/s_fancy.spr");	// careful!!! 176 frames!!!!!
		if (self.deathstring == "")  self.deathstring = " was melted by a Dragon\n";
	} else if (element == RYU_USE_LITE) {
        self.resist_cells = 0.5;
		self.resist_plasma = 0.5;
		precache_model ("progs/drake/s_fancy.spr");	// careful!!! 176 frames!!!!!
		if (self.deathstring == "")  self.deathstring = " was blasted by a Dragon\n";
    } else if (element == RYU_USE_ICE) {
        self.resist_cold = 1;
		self.resist_fire = 0;
		evade = FALSE;
		if (self.deathstring == "")  self.deathstring = " was iced by a Dragon\n";
    } else {
		// Default to fire.
        element=RYU_USE_FIRE;
		self.resist_fire = 1;
		self.resist_cold = 0;
		if (self.deathstring == "")  self.deathstring = " was fried by a Dragon\n";
	}

    // Set water evasion flag.
    if (evade) { self.ryuflags = self.ryuflags | RYU_NO_WATER; }
	else { self.ryuflags = self.ryuflags - (self.ryuflags & RYU_NO_WATER); }

    self.ryuflags = self.ryuflags - (self.ryuflags & RYU_ELEMENTS); // Set breath attack flags.
    self.ryuflags = self.ryuflags | element;

    // Fast = more alert -- better dodging and aiming.
    // Slow = slower speed, poor tracking.
    if (self.spawnflags & SPAWNx_SKILL == SPAWNx_SKILL) powlevel = cvar("skill"); // Conflict -- let skill decide.
    else if (self.spawnflags & SPAWN_FAST) powlevel = 2;
    else if (self.spawnflags & SPAWN_SLOW) powlevel = 0;
    else powlevel = 1;

    // Set speed.
    if (powlevel) {
        self.spawnflags = self.spawnflags - (self.spawnflags & SPAWN_SLOW);
        if (powlevel >= 2)
            self.ryuflags = self.ryuflags | RYU_ALERT;
        self.speed = 32;
    } else
        self.speed = 20;

    self.solid = SOLID_NOT;		// No interaction with world
    self.movetype = MOVETYPE_NONE;	// Static item, no movement

    if (self.spawnflags & SPAWN_WYRM) {
        self.headmdl   = "progs/drake/dr2_head.mdl";
		self.mdl = "progs/drake/dragon2.mdl";
        self.th_stand = self.th_walk = self.th_run = wyrm_start;
        self.ryuflags = self.ryuflags | RYU_PATH;
		self.resist_poison = self.resist_acid = 1;
		self.bossflag = TRUE;
		if (self.bboxtype < 1) self.bboxtype = BBOX_WYRM;
		if (self.health < 1) self.health = 3000;
		self.gibhealth = MON_NEVERGIB;
        self.th_die     = wyrm_die;
		self.bossflag = TRUE;
		self.classtype = CT_MONWYRM;
		if (self.fov == 0) self.fov = -1; // Force 0 = full wide angle 180deg view, age old drake custom default
    } else {
        self.headmdl   = "progs/drake/dr1_head.mdl";
		self.mdl = "progs/drake/dragon1.mdl";
        self.th_stand   = ryu_stand1;
        self.th_walk    = ryu_walk1;
        self.th_run     = ryu_run1;
        self.th_die     = dragon_die;
        self.th_melee   = dragon_strike;
        self.th_revive  = dragon_revive;
		if (self.bboxtype < 1) self.bboxtype = BBOX_RYU;
		if (self.health < 1) self.health = 750;
		self.gibhealth = -90;
        if (!self.yaw_speed) self.yaw_speed = 20;    // Same as walkmonster.
    }

    self.sight_sound = "drake/dragon/sight1.wav";
    self.th_missile = dragon_missile1;
    self.th_pain    = wyrm_pain;
    self.th_checkattack   = DragonCheckAttack;
    self.th_win     = dragon_win;
    Resist_ChangeType(self,-1); // Always reset Ammo Resistance to be consistent
    if(!self.classtype) self.classtype = CT_MONRYU;
    if (!self.classgroup) self.classgroup = CG_DRAGON;
    self.classmove = MON_MOVEFLY;
    monster_start ();
};

void() monster_ryu_wyrm = {
    self.spawnflags = self.spawnflags | SPAWN_WYRM;
    self.classname = "monster_ryu";
	self.classtype = CT_MONWYRM;
	if (self.deathstring == "")  self.deathstring = " was obliterated by a Wyrm Dragon\n";
    monster_ryu();
};

void() monster_dragon_wyrm = { monster_ryu_wyrm(); }; // Drake re-direct.
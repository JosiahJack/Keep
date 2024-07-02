//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by W. Josiah Jack, aka Qmaster
//
// Attributions: All and Qmaster
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
// Function count: 34
//
// Implements: Weapons System for the Player
//
// Description:
// Functions for changing weapons and attacking.
//=============================================================================

entity multi_ent;
float multi_damage;

// Well, we can either do these 55 someodd declarations for player stuff here, or alternatively declare weapon stuff in player.qc and move it up in the progs.src ordering.
void(entity targ) remoteplayer_run;
void() player_axe1;				// Different Axe animations
void() player_axeb1;
void() player_axec1;
void() player_axed1;
void() player_axee1;
void() player_axeoldc1;			// Different Axe animations for original axe
void() player_axeoldd1;
void() player_sg1;				// Shotgun
void() player_supersg1;			// Super Shotgun
void() player_rc1;
void() player_nail1;			// Nailgun
void() player_snail1;			// Super Nailgun
void() player_rocket1;			// Rocket Launcher
void() player_grenade1;			// Grenade Launcher
void() player_multi_rocket1;	// Multi-Rocket Launcher
void() player_multi_grenade1;	// Multi-Grenade Launcher
void() player_light1;			// Thunderbolt
void() player_plasma1;			// Plasma Gun
void() player_plasmalight1;		// Rogue Plasma Gun
void() player_ssgreset;			// Reset weaponframe
void() player_sgreset;
void() player_grenreset;
void() player_rockreset;
void() player_crossbow1;
void() player_crossbow2;
void() player_crossbow3;
void() player_crossbow4;
void() player_crossbow5;
void() player_crossbow6;
void() player_laser1;
void() player_hammer1;
void() player_hammer1original;
void() player_mjolnir1;
void() player_mjolnir1original;
void() player_prox_grenade1;
void() player_wand1;
void() player_grapple1;
void() player_grapple3;
void() player_chainlight1;
void() player_blast1;
void() player_saw1;
void() player_bfg1;
void() player_airgun1;
void() player_failedairgun1;
void() player_xbow1;
void() W_FireSparks;
void(entity ent) ReflectSound;
entity(float pause, void() thinkst, entity attacker) Echo_Shot;
void(vector lstart, entity lsource, float ldamage) LightningReflection;
void() player_lava_nail1;
void() player_lava_snail1;
float(float dist) ai_medic;

void(float reload) W_Reload = { // [FUNCTION]
	if ((self.flags & FL_CLIENT) && self.perms & POW_HASTE) reload = reload / 2;
	if (reload < 0.05) reload = 0.05; // Minimum value, to prevent near zero from Haste, Shotty, and Tome of Power stacking up.
	if (reload > 10) reload = 10; // Just in case, this is a rather ridiculous value anyway.
	if (self.slow_finished > time) reload = reload * 1.5; //Such a slog, we are cold
    self.attack_finished = time + reload;
};

void() W_ShowHostile = {
    self.show_hostile = time + 1;   // wake monsters up
    self.attack_time = time;    // So imps know when to dodge.
};

// Weapon ammo run out and switching to next best weapon
void(float wait_time) forceweaponswitch = { // [FUNCTION]
	local float nextweap;

	if (self.flags & FL_MONSTER) return;

	nextweap = W_BestWeapon(self); // has the player run out of ammo? work out next best weapon
	if (self.weapon != nextweap) { // Does the player need to switch weapons?
		self.weapon = nextweap;
		W_SetCurrentAmmo(self,TRUE);
	}
};

// Note:  'shots' is number of hitscan shots.  Does not include the two freebie side missiles.
void(vector start, vector dir, float shots) FireSparks = { // [FUNCTION]
    local float damage, dist, mid, fr, sparx;
    local vector end, end2, d1, glitter;
    local entity targ, attacker, hkproj;

    attacker = self;
    damage = WAND_DAMAGE;
    dist = WAND_RANGE;
    fr = X32_SPARK_ORANGE;
    sparx = TRUE;
    glitter = '233 97 1'; // Note:  Changed 225 to 97 so blood won't spawn in ports.

	// Check for ToP override.
    if (shots < 1) {
		// Fire the two side projectiles.  Remember, spikes lasts up to six seconds.
        shots = 5;
        damage = 5; // Heretic damage is d8 per shot.
        dist = 2048;
        fr = X32_CUT_ORANGE;
        sparx = FALSE;
        glitter_z = 0;
        d1_x = (shots - 1) * 1.40625;
		d1_y = 0;
		d1_z = 1;
        end = Aim_Scatter(dir, d1);
		hkproj = launch_projectile(start,end,NO_SPIN,CT_PROJ_HKN,630); //18*35=630.
		if (hkproj) {
			hkproj.dmg = damage;
			hkproj.touch = WandSpark_Touch;
			hkproj.classtype = CT_WANDSPARK;
			if (shots > 1) {
				d1_x = 0 - d1_x;
				end = Aim_Scatter(dir, d1);
				hkproj = launch_projectile(start,end,NO_SPIN,CT_PROJ_HKN,630); // Death Knight spike
				if (hkproj) {
					hkproj.dmg = damage;
					hkproj.touch = WandSpark_Touch;
					hkproj.classtype = CT_WANDSPARK;
				}
			}
		}
    }

	// Start multi-trace attack.  Uses MultiDamage_* functions.
    mid = (shots + 1) * 0.5;
	ClearMultiDamage();
    while (shots > 0) {
        if (mid == 1) {
            d1 = dir;
        } else {
            d1_x = (shots - mid) * 2.8125;
			d1_y = crandom()*0.5;
			d1_z = 1;
            d1 = Aim_Scatter(dir, d1);
        }
        Lead_Hitscan(start, d1, dist, damage, attacker, glitter); // Does traceline from start in direction d1 * dist    
		targ = trace_ent;
        end = trace_endpos;
        end2 = end - d1*8;
        // Note:  Reflection merely stops the beam.
        if (trace_fraction < 1) {
			AddMultiDamage (targ, damage);
            self = spawn();
            setall(self, "progs/null.spr", '0 0 0', '0 0 0', end2); //was null_256
            sound(self,CHAN_AUTO,SOUND_LASER_HIT, 0.5,ATTN_STATIC); // Play sizzle sounds at reduced volume and attenuation.
            BecomeFancy(fr, 4);
            self = attacker; // We used attacker earlier to store self
        }
        shots = shots - 1;
    }
    ApplyMultiDamage();
};

// Shoots one big explosive shot.  Doom damage d3*5.  Heretic damage d8+6 (ToP d8*7).
void(vector start, vector dir) FireBigSpark = { // [FUNCTION]
    local entity targ, attacker;
    local vector end, end2;
    local float damage, splash;

    attacker = self;
    splash = WAND_DAMAGE * (WAND_FULL + 1);
    damage = SUB_RandomDamage(splash);
    Lead_Hitscan(start,dir,WAND_RANGE,damage,attacker,'233 97 4');
    targ = trace_ent;
    end = trace_endpos;
    end2 = (end - (dir*8));
    if (targ) {
        if (targ.classgroup == CG_ZOMBIE && targ.classtype != CT_MONMUMMY) {
            if (damage < targ.health) damage = targ.health; // Update 11/2/09:  Let max charge obliterate (unarmored) zombies.
        }
        T_Damage(targ,attacker,attacker,damage,DAMARMOR);
    }
    self = spawn();
    setall(self, "progs/null.spr", '0 0 0', '0 0 0', end); // was null_256.spr
    self.classtype = CT_WANDBIGSPARK;
    T_RadiusDamage(self,attacker,splash,attacker,DAMAGEALL);
    self.origin = end2;
    Rocket_Explosion2(end2,224,16);
    BecomeFancy(X80_SPARK_ORANGE,6);
    self = attacker;
    Flare_Spawn(end2);
};

void() W_FireSparks = { // [FUNCTION]
    local vector dir, org, err;
    local float charge;

    if (self.weapon == IT2_WAND && !self.weaponismoditems) charge = self.currentammo;
    else charge = 0; // This shouldn't happen, but if so...
	
    if (charge > WAND_FULL + 1) charge = WAND_FULL + 1;
    self.currentammo = 0; // Update 4/5/10:  Use all accumulated energy.
    self.zapper_time = time + WAND_DELAY;
	W_Reload(WAND_DELAY);
    sound(self,CHAN_WEAPON,"hknight/attack1.wav",1,ATTN_NORM); // Was weapons/gldhit. wav.
    // Since weapon is a magic wand, no recoil effects are needed.
    makevectors(self.v_angle);
    org = self.origin + v_forward*8 + '0 0 16';
    dir = aim(self, 100000);
    if (self.tome_finished) FireSparks (org, dir, 0);
    else if (charge <= WAND_FULL) {
        if (!charge) {
			// Player is holding attack button down for rapid-fire.  Scatter shots a bit like in Heretic.
            err_x = random();
			err_x = err_x - random();
			err_x = err_x * 2;
            err_y = crandom();  // Was random() - 0.5;
            err_z = 1;
            dir = Aim_Scatter (dir, err);
            charge = 1; // Fire at least 1 to coincide with recharge rate
        }
        FireSparks(org, dir, charge);
    } else FireBigSpark(org, dir);
};

// Hipnotic Laser Cannon
void(float stat) HIP_FireLaser = { // [FUNCTION]
	local entity laze;
	local vector org, dir, out;
	local float ofs, aofs, glow;

	if (!self.button0) { player_run(); return; }

	if ((self.weapon == IT2_LASER_CANNON && !self.weaponismoditems) && (self.ammo_cells < TRUE) ) {
		self.weapon = W_BestWeapon(self);
		W_SetCurrentAmmo(self,TRUE);
		return ;
	}

	if ((self.weapon == IT_SHOTGUN && !self.weaponismoditems) && (self.ammo_shells < TRUE) ) { // Blaster uses this
		self.weapon = W_BestWeapon(self);
		W_SetCurrentAmmo(self,TRUE);
		return ;
	}

	self.effects = (self.effects | EF_MUZZLEFLASH);
	makevectors(self.v_angle);
	ofs = MOVETYPE_TOSS;
	out = v_forward;
	out_z = FALSE;
	out = normalize (out);
	org = ((self.origin + ((STAT_TOTALMONSTERS - ofs) * v_up)) + (STAT_TOTALMONSTERS * out));
	dir = aim (self,1000.000);
	aofs = (ofs * 0.707);
	if (stat == FALSE) {
		self.ammo_cells = (self.ammo_cells - TRUE);
		self.currentammo = (self.currentammo - TRUE);
		org = (org + (aofs * v_right));
		org = (org - (aofs * v_up));
		HIP_LaunchLaser(org,dir,FALSE);
		org = (org - ((FL_SWIM * aofs) * v_right));
		HIP_LaunchLaser(org,dir,FALSE);
	} else if (stat == TRUE) {
		self.ammo_cells = (self.ammo_cells - TRUE);
		self.currentammo = (self.currentammo - TRUE);
		org = (org + (ofs * v_up));
		if ( (random () < 0.100) ) {
			laze = HIP_LaunchLaser(org,dir,TRUE);
			laze.dmg = 25.000;
		} else {
			HIP_LaunchLaser(org,dir,FALSE);
		}
	} else { // Using the modified shotgun-turned-blaster model...
		org = self.origin + '0 0 12';
		if (stat == 2 && self.tracer_time <= time) {
			glow = TRUE;
			self.tracer_time = time + 0.5;
		}
		self.ammo_shells = (self.ammo_shells - TRUE);  // blaster uses shells??  well, I guess that's fine whatevs
		self.currentammo = (self.currentammo - TRUE);
		laze = HIP_LaunchLaser(org,dir,glow);
		laze.volume = 0; // No random chance of removal on impact.  Spread gun looks bad unless v_model is wider.
	}
	self.punchangle_x = CONTENT_EMPTY;
};

float(vector source, float axedmg) GibFloorBody = {
	local vector vec, org;
	local entity onflr;
	local float src_dist, dotprod;
	
	// See if there are any bodies lying around
	onflr = find(world, bodyonflr, MON_ONFLR);
	while (onflr) {
		src_dist = vlen(source - onflr.origin);
		if (src_dist < RANGE_PLAYAXE) { // Is the body close to the player?
			org = onflr.origin - '0 0 16';		// move origin close to floor
			makevectors(self.v_angle);			// Calculate viewing angle
			vec = normalize (org - self.origin);
			dotprod = vec * v_forward;
			// Is the body infront of the player or touching thrown mjolnir?
			if (dotprod > 0.6 || self.classname == "Mjolnir") {
				onflr.origin = org;				// Move gib closer to floor
				W_ShowHostile(); // Wake monsters up, we hit stuff.
				if ((self.weapon == IT2_MJOLNIR && !self.weaponismoditems)
					|| self.classname == "Mjolnir") {
					if (ai_medic(64)) {
						return TRUE; // True = don't do attack pain now.
					}
				}

				if (!onflr.gibbed && onflr.classtype != CT_TEMPGIB) {
					monster_flrbody_gib(onflr, axedmg*4); // Now a function in ai_gibs since it's used by boil explosion as well
					return TRUE; // Finished
				}
			}
		}
		onflr = find(onflr,bodyonflr, MON_ONFLR); // See if there are anymore bodies close by
	}
	return FALSE;
};

void() W_FireMjolnirOriginal = { // [FUNCTION]
	local vector org, source, ang, tvec, newpos;
	local float damage, cells;
	local entity tester, stemp, found;


	if (self.tome_finished > 0) {
		//adaya bfg lightning ball spawn!
		if ( ((trace_fraction == TRUE) && (self.ammo_cells >= 15.000)) ) {
			source = (source + (v_forward * 32));
			traceline(source,(source - (v_up * 50)),FALSE,self);
			self.ammo_cells = (self.ammo_cells - 15);
			self.currentammo = (self.currentammo - 15);
			SpawnLightningOrb();
			W_Reload(0.8);
			return;
		}
		org = (trace_endpos - (v_forward * 4));
		if ( trace_ent.takedamage ) {
			if (self.ammo_cells >= 15) damage = 300.000;
			else damage = 80;

			trace_ent.axhitme = TRUE;
			SpawnBlood(trace_ent, org,v_forward,damage,0);
			T_Damage(trace_ent,self,self,damage, DAMARMOR);
			if (self.ammo_cells >= 15) {
				SpawnLightningOrb();
				self.ammo_cells = (self.ammo_cells - 15);
				self.currentammo = (self.currentammo - 15);
			}
		} else {
			if ( (trace_fraction != TRUE) ) {
				sound(self,CHAN_WEAPON,"hipnotic/weapons/mjoltink.wav",TRUE,ATTN_NORM); //tink, nothin
				Tent_Point(TE_GUNSHOT,org);
			} else sound(self,CHAN_WEAPON,"knight/sword1.wav",TRUE,ATTN_NORM); //swoosh
		}
		W_Reload(0.4);
		return;
	}

	// Normal original Hipnotic Mjolnir
	W_Reload(0.4);
	source = (self.origin + '0 0 16');
	makevectors (self.v_angle);
	traceline (source,(source + (v_forward * 32)),FALSE,self);
	found = trace_ent;
	if ( ((trace_fraction == TRUE) && (self.ammo_cells >= 15)) ) {
		source = (source + (v_forward * 32));
		traceline(source,(source - (v_up * 50.000)),FALSE,self);
		if ( ((trace_fraction > 0.300) && (trace_fraction < TRUE)) ) {
			HIP_FireMjolnirLightning();
			W_Reload(1.5);
			return ;
		}
	}
	org = (trace_endpos - (v_forward * 4));
	if (found.reflectaxe) {
		Resist_Effects(found,org,VEC_ORIGIN,0,AM_NONE,SOUND_AXE_STONE,"");
	} else if ( found.takedamage ) {
		damage = 50;
		if ((found.classgroup == CG_ZOMBIE)
			&& found.classname != "monster_mummy") {

			damage = found.max_health * 2;
		}
		found.axhitme = TRUE;
		SpawnBlood(found,org,v_forward,damage,0);
		T_Damage(found,self,self,damage,DAMARMOR);
	} else {
		if ((trace_fraction != 1.00)) {
			sound(self,CHAN_WEAPON,"hipnotic/weapons/mjoltink.wav",TRUE,ATTN_NORM);
			tester = spawn();
			setorigin(tester,org);
			tester.mins = '-4 -4 0';
			tester.maxs = '4 4 16';
			setsize(tester,'-4 -4 0', '4 4 16');
			tvec = tester.origin;
			tvec_z = tvec_z + 10;
			stemp = self;
			self = tester;
			newpos = self.origin + tvec;
			trace_fraction = Wyrm_WalkMove(vectoyaw(newpos - self.origin), 0); // Perform walkmove of testbox.
			self = stemp;
			if (trace_fraction == TRUE) HIP_FireMjolnirLightning();
			remove(tester);
			Tent_Point(TE_GUNSHOT,org);
		} else {
			sound(self,CHAN_WEAPON,"knight/sword1.wav",TRUE,ATTN_NORM);
		}
	}
	W_Reload(0.4);
};

float() W_FireMjolnir = { // [FUNCTION]
    local vector org, source;
    local float damage, stat;
	local entity targ, found, oenemy;

	if (self.hammer_finished >= time) {
		if (self.hammer) self.hammer.owner = world;
		return FALSE;
	}

    source = self.origin + '0 0 16';
    makevectors(self.v_angle);
    traceline(source,source + v_forward * 80,FALSE,self);
	found = trace_ent; // Save entity as traceline is called by shockwave below.
    org = trace_endpos - v_forward * 4;
	if (GibFloorBody(trace_endpos,200)) {
		sound(self,CHAN_WEAPON,"hipnotic/weapons/mjolhit.wav",1,ATTN_NORM);
		SpawnBlood(found,org,'0 0 50',damage,225);
		return TRUE;
	}

	if (found && found != world) {
		// REFLECTION stuff like blue shields
		if (found.reflectaxe) Resist_Effects(found,org,VEC_ORIGIN,0,AM_NONE,SOUND_AXE_STONE,"");
		else if (found.takedamage) {
			oenemy = found.enemy;
			damage = 50;
			if ((found.classgroup == CG_ZOMBIE) && found.classname != "monster_mummy") damage = found.max_health * 2;
			sound(self,CHAN_WEAPON,"zombie/z_hit.wav",1,ATTN_NORM);
			SpawnBlood(found,org,'0 0 50',damage,225);
			found.axhitme = TRUE;
			HIP_FireMjolnirLightning();
			T_Damage(found, self, self, damage, DAMARMOR);

			// Multiple procs are checked independently of each other, and may
			// activate simultaneously.
			stat = 0;
			if (random() < 0.2) stat = 1;
			if (self.tome_finished) {
				if (random() < 0.1) { // Thunderstorm proc.
					if (!Divine_Wrath(3,1)) stat = stat + 1; // 3 shots, 1 sec of darkness.
				} else Divine_Wrath(1,1);
			}

			if (stat) {
				stat = stat + 1;
				stat = (stat * 100) + 100; // 300 to 400
				StaticField(found,stat);
			}

			if (found.alignment == NEUTRAL && oenemy == self) {
				found.enemy = found.oldenemy = world;
			}

			return TRUE;
		}
    } else if (trace_fraction < 1.0) { // Hit wall
        sound(self,CHAN_WEAPON,"hipnotic/weapons/mjoltink.wav",1,ATTN_NORM);
        Tent_Point(TE_GUNSHOT,org);

		// Check for premature hit on the ground.
        if (other.solid == SOLID_BSP && trace_plane_normal * '0 0 1' > COS45) {
			if (self.ammo_cells >= COST_MJOLNIR) {
				// Slammed the ground, so fire off some lightning.
				if (deathmatch // Allow for possible net frag gain.
					|| self.cross_finished     // Immune to radius damage.
					|| self.radsuit_finished   // Inherited wetsuit powers...protected
											// from lightning damage.
					|| self.waterlevel <= 1    // Not in the water.
					|| Indestructable(self)) { // Super slam.  Update 11/30/09:  Don't
											// discharge if deadly.
					Quake_Spawn(self,800,10,org,TRUE,2,VEC_QUAKE);
					HIP_FireMjolnirLightning();
					if (self.tome_finished) {
						Divine_Wrath(6, 2); // Do after Hip lightning.
						StaticField(self,400); // Soften 'em up before delayed
											   // smashing. Was 500.
					}
					if (!lightzero_finished) sound(world,CHAN_AUTO,"drake/bane/thunder.wav",1,ATTN_NONE);
					W_Reload(1.5);
				} else HIP_FireMjolnirShockwave(org); // Mini-slam.
			}
		}
        return TRUE;
    } else { // Whiff
		if (!(self.flags & FL_CLIENT)) { // Frikbot code!  Emulate a double-click, since required timing varies.
			if (random() < (skill * 0.1 + 0.7)) return FALSE; // Frikbot tries to throw hammer.  With lag, enforce a chance of failure.
		}
        self.attack_finished = self.attack_finished + 0.1;  // Update 12/11/09:  T+0.6+0.1=T+0.7.  Changed rate in impulse.qc.
		sound(self,CHAN_WEAPON,"knight/sword1.wav",1,ATTN_NORM);

		// Throw if player has the juice.
		if (!frame_pause() && (self.tome_finished || self.ammo_cells >= COST_MJOLNIR)) {   
			targ = W_ThorTarget(); // This calls 'makevectors(self.v_angle)'.
			Thor_Launch(self.origin + '0 0 12',v_forward,targ); // Do it!
			return TRUE;
		}
    }
	return FALSE;
};

void() W_FireProximityGrenade = { // [FUNCTION]
	local entity missile;

	if (self.attack_finished > time) return;
	if (self.ammo_rockets < 1) { forceweaponswitch(0.2); return; }
	NumProximityGrenades = (NumProximityGrenades + TRUE);
	self.ammo_rockets = (self.ammo_rockets - TRUE);
	self.currentammo = (self.currentammo - TRUE);
	sound(self,CHAN_WEAPON,"hipnotic/weapons/proxbomb.wav",TRUE,ATTN_NORM);
	self.punchangle_x = CONTENT_SOLID;
	missile = spawn();
	missile.classgroup = CG_PROJGRENADES;
	missile.owner = self;
	missile.lastvictim = self;
	missile.movetype = MOVETYPE_TOSS;
	missile.solid = SOLID_BBOX;
	missile.classname = "proximity_grenade";
	missile.takedamage = DAMAGE_NO;
	missile.health = MOVETYPE_FLY;
	missile.state = 0;
	makevectors(self.v_angle);
	if (self.v_angle_x ) {
		missile.velocity = ((((v_forward * 600.000) + (v_up * 200)) + ((crandom () * v_right) * MOVETYPE_BOUNCE)) + ((crandom () * v_up) * MOVETYPE_BOUNCE));
	} else {
		missile.velocity = aim (self,10000.000);
		missile.velocity = (missile.velocity * 600.000);
		missile.velocity_z = 200;
	}
	missile.avelocity = '100.000 600.000 100.000';
	missile.angles = vectoangles (missile.velocity);
	missile.touch = ProximityGrenadeTouch;
	missile.nextthink = (time + FL_SWIM);
	missile.delay = ((time + 15.000) + (MOVETYPE_BOUNCE * random ()));
	missile.think = ProximityBomb;
	missile.th_die = ProximityGrenadeExplode;
	setmodel(missile,"progs/ne_ruins/proxbomb.mdl");
	setorigin(missile,self.origin);
	setsize (missile,'-1.000 -1.000 -1.000','1.000 1.000 1.000');
	W_Reload(0.6);
};

void() W_FireSidewinder = { // [FUNCTION]
    local vector start, dir;
    local entity targ;

    if (self.ammo_rockets < 1) return;

    self.currentammo = self.ammo_rockets = self.ammo_rockets - 1;
    sound(self,CHAN_WEAPON,"zerstorer/weapons/stunfire.wav",1,ATTN_NORM);
    self.punchangle_x = -2;
    makevectors(self.v_angle);
    start = self.origin + v_forward*8 + '0 0 16';
    dir = v_forward;
	newmis = launch_projectile(start,dir,NO_SPIN,CT_PROJ_SIDEWINDER,450);
};

void() W_FireAirFist = { launch_horn(); }; // Redirect for consistent and clear naming. -Qmaster

void(float dmg, vector spraydir, float mechanical) MeleeImpactEffects = {
	local vector org;

	org = trace_endpos - v_forward*4;	// Back 4 units to spawn blood
	if (trace_ent.reflectaxe) Resist_Effects(trace_ent,org,VEC_ORIGIN,0,AM_NONE,SOUND_AXE_STONE,""); // REFLECTION stuff like blue shields
	else if (trace_ent.takedamage) { // BLEEDING/DAMAGE stuff with unique impact sounds
		if (self.tome_finished) {
			SpawnMeatSpray(self,trace_ent,(crandom() * 300));
			SpawnMeatSpray(self,trace_ent,(crandom() * 300));
			if (dmg > DAMAGE_PLAYAXE1) {
				SpawnMeatSpray(self,trace_ent,(crandom() * 300));
				SpawnMeatSpray(self,trace_ent,(crandom() * 300));
			}
		}
		if (self.weaponframe & 1) SpawnMeatSpray(self,self,(crandom() * 300));
		SpawnBlood (trace_ent,org,spraydir,dmg,0); // Spamn blood always up so player can see it
		if (trace_ent.flags & FL_MONSTER) { // Monster impact sounds (fleshy stuff)
			if (mechanical) { // E.g. Chainsaw, Grapple
				self.punchangle_x = -8;
				trace_ent.velocity = trace_ent.velocity * 0.5;
				sound(self,CHAN_WEAPON,"zerstorer/weapons/sawguts.wav",1,ATTN_NORM);
				if (trace_ent.pain_finished > time && FeelsPain(trace_ent)) {
					if (Armored(trace_ent)) {
						sound(self,CHAN_AUTO,"drake/weapons/clang.wav",1,ATTN_NORM);
					} else if (StoneArmored(other)) {
						sound(self,CHAN_AUTO,"drake/weapons/axhitwal.wav",1,ATTN_NORM);
					}
				}
			} else {
				if (random() < 0.5) sound(self,CHAN_WEAPON,GIB_SOUND_HEAVY,1,ATTN_NORM);
				else sound(self,CHAN_WEAPON,GIB_SOUND_HEAVY2,1,ATTN_NORM);
			}
		} else if (trace_ent.classtype == CT_FUNCBREAK) { // Breakable impact sounds (def=stone/brick)
			if (trace_ent.style == BTYPE_WOOD) sound(self,CHAN_WEAPON,SOUND_AXE_WOOD,1,ATTN_NORM);
			else if (trace_ent.style == BTYPE_GLASS) sound(self,CHAN_WEAPON,SOUND_AXE_GLASS,1,ATTN_NORM);
			else if (trace_ent.style == BTYPE_METAL) sound(self,CHAN_WEAPON,SOUND_AXE_METAL,1,ATTN_NORM);
			else if (trace_ent.style == BTYPE_FLESH) sound(self,CHAN_WEAPON,SOUND_AXE_FLESH,1,ATTN_NORM);
			else sound(self,CHAN_WEAPON,SOUND_AXE_STONE,1,ATTN_NORM);
		} else if (trace_ent.classtype == CT_FUNCPUSHABLE) { // Pushable impact sounds (def=stone/brick)
			if (trace_ent.style == PTYPE_WOOD) sound(self,CHAN_WEAPON,SOUND_AXE_WOOD,1,ATTN_NORM);
			else if (trace_ent.style == PTYPE_GLASS) sound(self,CHAN_WEAPON,SOUND_AXE_GLASS,1,ATTN_NORM);
			else if (trace_ent.style == PTYPE_METAL) sound(self,CHAN_WEAPON,SOUND_AXE_METAL,1,ATTN_NORM);
			else sound(self,CHAN_WEAPON,SOUND_AXE_STONE,1,ATTN_NORM);
		}
	} else {
		// WORLD OBJECT : Target does not bleed, play stone hitting sound
		sound(self,CHAN_WEAPON,SOUND_AXE_STONE,1,ATTN_NORM);
		Tent_Point(TE_GUNSHOT,org);
	}
};

void() W_FireAxe = { // [FUNCTION]
	local vector source, org;
	local float axedmg;

	makevectors(self.v_angle);				// Player forward angle
	source = self.origin + '0 0 16';		// Move source point up body
	if (developer > 0 && self.flags & FL_GODMODE && self.flags & FL_FLY) {
		traceline(source,source +(v_forward* RANGE_PLAYAXE),FALSE,self);
		if (trace_fraction < 1.0) {
			if (trace_ent && trace_ent != world) {
				if (trace_ent.flags & FL_MONSTER && trace_ent.health > 0) {
					dprint("\n\b[DEBUG]\b system active, changing monster\n");
					trace_ent.debuglvl = 1 - trace_ent.debuglvl;
				}
			}
		}
		return;
	}		 

	if (self.moditems & IT_UPGRADE_AXE || self.tome_finished) {
		if (GibFloorBody(source,axedmg)) return;
	}

	traceline (source, source + (v_forward* RANGE_PLAYAXE), FALSE, self); // Trace forward and see if the axe has hit anything?
	if (trace_fraction == 1) return;	// No contact, no hit

	W_ShowHostile();
	if (trace_ent && trace_ent != world) {
		if (trace_ent.takedamage) { // BLEEDING/DAMAGE stuff with unique impact sounds
			// Mark the monster with type of axe used and change damage
			if (self.moditems & IT_UPGRADE_AXE) {
				axedmg = DAMAGE_PLAYAXE2;
				trace_ent.axhitme = 2;
			} else {
				axedmg = DAMAGE_PLAYAXE1;
				trace_ent.axhitme = 1;
			}

			if (self.tome_finished) {
				axedmg = axedmg * 2;
				if (trace_ent.classgroup == CG_ZOMBIE) axedmg = 120;
			}
			T_Damage(trace_ent,self,self, axedmg, DAMARMOR);
		}
	}
	MeleeImpactEffects(axedmg,'0 0 1',FALSE);
};

void() W_FireSaw = { // [FUNCTION]
    local vector  spot, source, org;
	local float damage, save, ignore;
	local entity onflr, tself, tother;

	makevectors(self.v_angle); // Calculate viewing angle
	source = self.origin + '0 0 16'; // Move source point up body
	if (GibFloorBody(source, 200)) {
		SpawnMeatSpray(self,self,(crandom() * 300));
		SpawnMeatSpray(self,self,(crandom() * 300));
		return;
	}

    spot = self.origin + '0 0 16';      // 'source'
    traceline(spot, spot + v_forward*64, FALSE, self);
    if (trace_fraction == 1) return;

    spot = trace_endpos - v_forward*4;        // 'org'
	if (trace_ent && trace_ent != world) {
		if (trace_ent.takedamage) {
			damage = 40;
			SpawnMeatSpray(self,trace_ent,(crandom() * 300));

			// Suck life like Heretic's necro gauntlets.
			if (self.tome_finished && trace_ent.flags & FLx_CREATURE) {
				save = ignore = 0;
				if (trace_ent.classtype == CT_MONWRAITH || trace_ent.classtype == CT_MONWRAITH || trace_ent.classtype == CT_MONWRAITH) {
						save = 0.5;      // Assume life drain attack.
						ignore = TRUE;   // Exceed normal health limit.
				} else save = 0.1;

				if (self.dmg > trace_ent.health)
					save = ceil(trace_ent.health * save);
				else
					save = ceil(self.dmg * save);

				if ((self.perms & POW_VAMPIRE) && (!(trace_ent.classgroup & CG_ZOMBIE))) save = save + ceil(1.2 * save);
				if (save > 0) T_Heal (self, save, ignore);
			}

			T_Damage(trace_ent, self, self, damage, DAMARMOR);
		}
	}
	MeleeImpactEffects(damage,'0 0 5',TRUE);
};

void() W_FireShotgun = { // [FUNCTION]
	local vector spread_pat;
	local float shotcnt;

	if (self.attack_finished > time) return;
	if (self.ammo_shells < 1) { forceweaponswitch(0.2); return; } // Ran out of ammo, switch to next best weapon
	
	// Change weapon sound if using Projectile Pellets.
	if (!query_configflag(SVR_SHOTGPROJ)) sound(self ,CHAN_WEAPON,"ad171/weapons/sg2.wav",1,ATTN_NORM); // ever so subtle sound of a shell ejecting added to normal
	else sound(self ,CHAN_WEAPON,"weapons/guncock.wav",1,ATTN_NORM); // vanilla single barrel shotgun
	
	self.effects = self.effects | EF_MUZZLEFLASH;
	if (self.perms & POW_SHOTTYMAN) W_Reload(0.3);
	else W_Reload(0.5);

	self.punchangle_x = -2;
	if (self.classtype != CT_MONGREMLIN) player_sgreset(); // reset weaponframe
	
	self.currentammo = self.ammo_shells = self.ammo_shells - 1;
	if (self.moditems & IT_ARTSHARP) spread_pat = SPREAD_SG2;
	else spread_pat = SPREAD_SG;

	shotcnt = QUANTITY_SG;
	if (self.tome_finished) shotcnt = 3; // Extra for tome.
	if (query_configflag(SVR_SHOTGPROJ)) // Choose between a projectile or hitscan system
		FireBullets (shotcnt, spread_pat);
	else {
		Launch_Shells(shotcnt, spread_pat, CT_PROJ_SG);
		Launch_ShellCasing(1);	// Shell casings
	}
};

void() W_FireSuperShotgun = { // [FUNCTION]
	local float ssg_qty, shell_qty;
	local vector spread_pat;

	// Ran out of ammo, switch to next best weapon
	if (self.attack_finished > time) return;
	if (self.ammo_shells < 2 && self.classtype != CT_MONGREMLIN) { forceweaponswitch(0.2); return; }

	makevectors(self.v_angle);		// Special view angle for the player

	// if shot in the air - do Newton's 3rd law. (from zerstorer)
	if (!(self.flags & FL_ONGROUND)) self.velocity = self.velocity - (v_forward * 35);

	if (self.moditems & IT_UPGRADE_SSG) sound(self,CHAN_WEAPON,"ad171/weapons/ssg2.wav",1,ATTN_NORM);
	else sound(self ,CHAN_WEAPON,"weapons/shotgn2.wav",1,ATTN_NORM);

	self.effects = self.effects | EF_MUZZLEFLASH;
	if (self.perms & POW_SHOTTYMAN) {
		if (self.moditems & IT_UPGRADE_SSG) W_Reload(0.3);
		else W_Reload(0.5);
	} else W_Reload(0.7);

	self.punchangle_x = -4;
	if (self.classtype != CT_MONGREMLIN) {
		player_ssgreset();	// reset weaponframe
	}

	shell_qty = 2;				// Standard shell casings quantity

	// If the player has the Widowmaker, setup triple shot
	if (self.moditems & IT_UPGRADE_SSG) {
		// Only got 2 shells in the gun (reduced damage)
		if (self.ammo_shells < 3) {
			self.ammo_shells = 0;
			ssg_qty = QUANTITY_SSG;
		} else {
			// 150% damage
			shell_qty = 3;
			self.ammo_shells = self.ammo_shells - 3;
			ssg_qty = QUANTITY_SSG * 1.5;
		}
	} else {
		// Default ID SSG damage
		self.ammo_shells = self.ammo_shells - 2;
		ssg_qty = QUANTITY_SSG;
	}

	self.currentammo = self.ammo_shells;
	if (self.moditems & IT_ARTSHARP) spread_pat = SPREAD_SSG2;
	else spread_pat = SPREAD_SSG;

	if (self.tome_finished) { // Tone down number of explosions by using less.
		if (self.moditems & IT_UPGRADE_SSG) ssg_qty = 11; // Widowmaker (Triple-barreled)
		else ssg_qty = 7; // Double-barreled Shotgun
	}

	if (deathmatch) ssg_qty = ssg_qty + 4; // From Zerstorer

	// Choose between a projectile or hit-scan system
	if (query_configflag(SVR_SHOTGPROJ)) {
		FireBullets (ssg_qty, spread_pat);	// Hit-scan
	} else {
		Launch_Shells(ssg_qty, spread_pat, CT_PROJ_SSG);
		Launch_ShellCasing(shell_qty);
	}
};

void() W_FireRiotController = { // [FUNCTION]
	local float ssg_qty, shell_qty;
	local vector spread_pat;
	
	// Ran out of ammo, switch to next best weapon
	makevectors(self.v_angle);		// Special view angle for the player

	// if shot in the air - do Newton's 3rd law. (from zerstorer)
	if (!(self.flags & FL_ONGROUND)) self.velocity = self.velocity - (v_forward * 35);

	self.effects = self.effects | EF_MUZZLEFLASH;
	self.punchangle_x = -4;
	self.ammo_shells = self.ammo_shells - 1;
	ssg_qty = QUANTITY_SSG;
	self.currentammo = self.ammo_shells;
	if (self.moditems & IT_ARTSHARP) spread_pat = SPREAD_SSG2;
	else spread_pat = SPREAD_SSG;

	if (self.tome_finished) ssg_qty = 9; // Tone down number of explosions by using less.
	if (deathmatch) ssg_qty = ssg_qty + 4; // From Zerstorer
	if (query_configflag(SVR_SHOTGPROJ)) { // Choose between a projectile or hit-scan system
		FireBullets (ssg_qty, spread_pat);	// Hit-scan
	} else {
		Launch_Shells(ssg_qty, spread_pat, CT_PROJ_SSG);
		Launch_ShellCasing(1);
	}
};

void(float oz, float ox) W_FireSpikes = { // [FUNCTION]
	local vector org, dir;
	local entity spike1, spike2;
	local entity stemp;

	if (self.ammo_nails < 1) { forceweaponswitch(0.2); return; } // If run out of ammo, switch weapons to next best

	self.effects = self.effects | EF_MUZZLEFLASH;
	W_Reload(0.2);
	self.punchangle_x = -2;
	makevectors(self.v_angle);
	if ((autoaim_cvar < 1) && self.classtype != CT_MONGREMLIN) dir = aim(self, SPEED_PLAYSPIKE); // Check for auto aim state.  Auto aim assist (builtin function 44)
	else dir = normalize(v_forward * SPEED_PLAYSPIKE); // Straight line forward where crosshair is pointing

	// SNG setup, sound and ammo change
	if ((self.ammo_nails > 1 && self.weapon == IT_SUPER_NAILGUN) || self.in_a_vehicle) {
		if (!self.in_a_vehicle) {
			sound(self,CHAN_WEAPON,"weapons/spike2.wav",1,ATTN_NORM);
			if (self.perms & POW_DOUBLE) self.currentammo = self.ammo_nails = self.ammo_nails - 1;
			else self.currentammo = self.ammo_nails = self.ammo_nails - 2;
		} else {
			sound(self,CHAN_WEAPON,"q15/weapons/rocket1i.wav",1,ATTN_NORM);
			stemp = self;
			self = self.vehicleattachment;
			Launch_ShellCasing(1);
			self = stemp;
		}

		// Original setup - org = self.origin + '0 0 16';
		// - SNG projectile offset idea by Kinn
		// org = self.origin + dir*14 + v_right*ox;
		// org_z = org_z + oz;
		// The SNG offset idea was hiting far below the crosshair
		// which was causing impact problems.
		// Kept the barrel offset, removed the Z adjustment instead!
		org = self.origin + '0 0 16' + v_right*ox;
		if (self.tome_finished) {
			// Update 2/14/10:  Minigun mode -- fire three shots per 0.1 sec.
			org = self.origin + '0 0 16' + v_up*fabs(ox);
			Piercer_Trace(org, org + dir,self,SPIKEY_DAMAGE,self,TE_GUNSHOT);
			Echo_Shot(1/30,W_EchoSpike_Down,self);
			Echo_Shot(2/30,W_EchoSpike_Up,self);
			StackDamage_Clear();
		} else { // Normal Super Nailgun Fire
			if (world.copperoptions & COPPER_TWOSHOT_PERFORATOR) { // Copper variant fires more nails instead of one super one
				spike1 = launch_projectile(org + vecrand(0,1.25,1),dir,NO_SPIN,CT_PROJ_NG,(940 + random()*30));
				if (spike1) {
					if (self.super_damage_finished > time) {
						spike1.dmg = DAMAGE_SNGSPIKE; // So zombies still gib at 72 with quad.  Yes Copper did this.
					}

					spike2 = launch_projectile(org + vecrand(0,1.25,1),dir,NO_SPIN,CT_PROJ_NG,(1020 + random()*30));
					if (spike2) {
						if (self.super_damage_finished > time) {
							spike2.dmg = DAMAGE_SNGSPIKE; 
							spike1.buddy = spike2; // First one to hit nerfs its buddy
							spike2.buddy = spike1; // Race ya!
							if (developer > 1) dprint("Buddy nails setup!\n");
						}
					}
				}
			} else launch_projectile(org,dir,NO_SPIN,CT_PROJ_SNG,SPEED_PLAYSPIKE); // Normal Normal Super Nailgun Fire
		}
	} else { // NG setup, sound and ammo change
		sound(self,CHAN_WEAPON,"weapons/rocket1i.wav",1,ATTN_NORM);
		if (self.perms & POW_DOUBLE) {
			if (self.nailcosthalf) {
				self.currentammo = self.ammo_nails = self.ammo_nails - 1;
				self.nailcosthalf = 0;
			} else self.nailcosthalf = 1;
		} else self.currentammo = self.ammo_nails = self.ammo_nails - 1;

		
		// Original setup - org = self.origin + '0 0 16' + v_right*ox;
		// - NG projectile offset idea by Kinn
		// org = self.origin + '0 0 8' + dir*14 + v_right*ox;
		org = self.origin + '0 0 16' + v_right*ox;
		if (self.tome_finished) { // ToP makes nailguns fire armor-piercing, hitscan bullets.
			ox = ox * 2;    // Hitscan with no bonus, so extend offset.
			dir = aim (self, 100000) * SPIKEY_RANGE;
			Piercer_Trace (org,org + dir,self,SPIKEY_DAMAGE,self,TE_GUNSHOT); // ToP also doubles nailgun's rate of fire.
			if (ox < 0) Echo_Shot(0.05,W_EchoSpike_Down,self); // Fire a second nail from the same barrel a moment later.
			else Echo_Shot(0.05,W_EchoSpike_Up,self);

			StackDamage_Clear();
		} else launch_projectile(org,dir,NO_SPIN,CT_PROJ_NG,SPEED_PLAYSPIKE); // Normal Nailgun Fire
	}
};

void(float oz, float ox) W_FireLavaSpikes = { // [FUNCTION]
	local vector org, dir;
	
	if (self.ammo_lava_nails < 1) { forceweaponswitch(0.2); return; } // If run out of ammo, switch weapons to next best

	self.effects = self.effects | EF_MUZZLEFLASH;
	W_Reload(0.2);
	self.punchangle_x = -2;
	makevectors(self.v_angle);
	if ((autoaim_cvar < 1) && self.classtype != CT_MONGREMLIN)  dir = aim(self, SPEED_PLAYSPIKE); // Auto aim assist (builtin function 44)
	else dir = normalize(v_forward * SPEED_PLAYSPIKE); // Straight line forward where crosshair is pointing

	// Lava SNG setup, sound and ammo change
	if (self.ammo_lava_nails > 1 && self.weapon == IT_LAVA_SUPER_NAILGUN) {
		sound(self,CHAN_WEAPON,"weapons/spike2.wav",1,ATTN_NORM);
		if (self.perms & POW_DOUBLE) {
			self.currentammo = self.ammo_lava_nails = self.ammo_lava_nails - 1;
		} else {
			self.currentammo = self.ammo_lava_nails = self.ammo_lava_nails - 2;
		}
		// Original setup - org = self.origin + '0 0 16';
		// - SNG projectile offset idea by Kinn
		// org = self.origin + dir*14 + v_right*ox;
		// org_z = org_z + oz;
		// The SNG offset idea was hiting far below the crosshair
		// which was causing impact problems.
		// Kept the barrel offset, removed the Z adjustment instead!
		org = self.origin + '0 0 16' + v_right*ox;
		if (self.tome_finished) {
			org = self.origin + '0 0 16' + v_up*fabs(ox); // Update 2/14/10:  Minigun mode -- fire three shots per 0.1 sec.
			Piercer_Trace (org,org + dir,self,SPIKEY_DAMAGE,self,TE_GUNSHOT);
			Echo_Shot(1/30, W_EchoLavaSpike_Down,self);
			Echo_Shot(2/30, W_EchoLavaSpike_Up,self);
			StackDamage_Clear();
		} else launch_projectile(org,dir,NO_SPIN,CT_PROJ_LAVASNG,SPEED_PLAYSPIKE); // Normal Super Nailgun Fire
	} else { // Lava NG setup, sound and ammo change
		sound(self,CHAN_WEAPON,"weapons/rocket1i.wav",1,ATTN_NORM);
		if (self.perms & POW_DOUBLE) {
			if (self.nailcosthalf) {
				self.currentammo = self.ammo_lava_nails = self.ammo_lava_nails - 1;
				self.nailcosthalf = 0;
			} else self.nailcosthalf = 1;
		} else self.currentammo = self.ammo_lava_nails = self.ammo_lava_nails - 1;
		
		// Original setup - org = self.origin + '0 0 16' + v_right*ox;
		// - NG projectile offset idea by Kinn
		// org = self.origin + '0 0 8' + dir*14 + v_right*ox;
		org = self.origin + '0 0 16' + v_right*ox;
		if (self.tome_finished) { // ToP makes nailguns fire armor-piercing, hitscan bullets.
			ox = ox * 2;  // Hitscan with no bonus, so extend offset.
			dir = aim (self, 100000) * SPIKEY_RANGE;
			Piercer_Trace(org,org + dir,self,SPIKEY_DAMAGE,self,TE_GUNSHOT); // ToP also doubles nailgun's rate of fire.
			
			if (ox < 0) Echo_Shot(0.05,W_EchoLavaSpike_Down,self); // Fire a second nail from the same barrel a moment later.
			else Echo_Shot(0.05,W_EchoLavaSpike_Up,self);

			StackDamage_Clear();
		} else launch_projectile(org,dir,NO_SPIN,CT_PROJ_LAVANG,SPEED_PLAYSPIKE); // Normal Nailgun Fire
	}
};

void() W_FireGrenade = { // [FUNCTION]
	local vector dir, avel;
	local float spd;

	if (self.attack_finished > time) return;
	if (self.ammo_rockets < 1) { forceweaponswitch(0.2); return; } // Ran out of ammo, switch to next best weapon

	self.currentammo = self.ammo_rockets = self.ammo_rockets - 1;
	sound(self,CHAN_WEAPON,"weapons/grenade.wav",1,ATTN_NORM);
	self.effects = self.effects | EF_MUZZLEFLASH;
	W_Reload(0.6);
	self.punchangle_x = -2;
	player_grenreset();	// reset weaponframe
	makevectors(self.v_angle);
	dir = v_forward;
	spd = SPEED_PLAYGRENADE;
	if (autoaim_cvar < 1) spd = SPEED_PLAYAIM;
	if (self.tome_finished) {
		spd = 800; // Faster
		if (self.v_angle_x) { // Has the player aimed left/right? then no auto aim assist
			dir = dir * spd + v_up * ELEV_ZAXIS + crandom()*v_right*10 + crandom()*v_up*10;
		} else {
			if ((autoaim_cvar < 1) && self.classtype != CT_MONGREMLIN) dir = aim(self,SPEED_PLAYAIM); // Check for auto aim state
			dir = dir * spd;
			dir_z = ELEV_ZAXIS; // Work out default speed and elevation
		}
		avel = vecrand(100,200,FALSE);
        launch_projectile(self.origin,dir,avel,CT_PROJ_GLSUPER,1);
    } else {
		if (self.v_angle_x) { // Has the player aimed left/right? then no auto aim assist
			dir = dir * spd + v_up * ELEV_ZAXIS + crandom()*v_right*10 + crandom()*v_up*10;
		} else {
			if ((autoaim_cvar < 1) && self.classtype != CT_MONGREMLIN) dir = aim(self,spd); // Check for auto aim state
			dir = dir * spd;
			dir_z = ELEV_ZAXIS; // Work out default speed and elevation
		}
		avel = vecrand(100,200,FALSE);
		launch_projectile(self.origin, dir, avel, CT_PROJ_GL,1);
	}
};

void() W_FireRocket = { // [FUNCTION]
	local vector org, dir;
	
	// Ran out of ammo, switch to next best weapon
	if (self.attack_finished > time) return;
	if (self.ammo_rockets < 1) { forceweaponswitch(0.2); return; }

	self.currentammo = self.ammo_rockets = self.ammo_rockets - 1;
	sound(self,CHAN_WEAPON,"weapons/sgun1.wav",1,ATTN_NORM);
	self.effects = self.effects | EF_MUZZLEFLASH;
	W_Reload(0.8);
	self.punchangle_x = -2;
	player_rockreset();	// reset weaponframe
	makevectors(self.v_angle);
	org = self.origin + v_forward * 8 + '0 0 16';

	// Auto aim assist (builtin function 44)
	if ((autoaim_cvar < 1) && self.classtype != CT_MONGREMLIN)  dir = aim(self, SPEED_RLPLAYER);
	// Straight line forward where crosshair is pointing
	else dir = normalize(v_forward * SPEED_RLPLAYER);
	
    if (self.tome_finished) launch_projectile(org, dir,NO_SPIN,CT_PROJ_ROCKETSUPER,500); //SuperRocket_Launch (org, dir);
    else launch_projectile(org,dir,NO_SPIN,CT_PROJ_ROCKET,SPEED_RLPLAYER);
};

void() W_Fire_Crossbow = { // [FUNCTION]
	local vector org, dir;

	if (self.attack_finished > time) return;
	if (self.ammo_bolts < 1) { forceweaponswitch(0.2); return; }
	self.currentammo = self.ammo_bolts = self.ammo_bolts - 1;
	makevectors(self.v_angle);
	sound(self,CHAN_WEAPON,"ad171/weapons/crossbow_fire.wav",1,ATTN_NORM);
	if ((autoaim_cvar < 1) && self.classtype != CT_MONGREMLIN) dir = aim(self, SPEED_PLAYSPIKE);
	else dir = normalize(v_forward * SPEED_DCROSS); // Straight line forward where crosshair is pointing

	if (self.tome_finished) W_Reload(0.13);
	else W_Reload(0.9);
	org = self.origin + '0 0 16';
	newmis = launch_projectile(org,dir,NO_SPIN,CT_PROJ_BOLT1,1100);
};

void() W_Fire_Crossbow_Poison = { // [FUNCTION]
	local vector org, dir;

	if (self.attack_finished > time) return;
	if (self.ammo_poison < 1) { forceweaponswitch(0.2); return; }
	self.currentammo = self.ammo_poison = self.ammo_poison - 1;
	makevectors(self.v_angle);
	sound(self,CHAN_WEAPON,"ad171/weapons/crossbow_fire.wav",1,ATTN_NORM);
	if ((autoaim_cvar < 1) && self.classtype != CT_MONGREMLIN)  dir = aim(self, SPEED_PLAYSPIKE);
	else dir = normalize(v_forward * SPEED_DCROSS); // Straight line forward where crosshair is pointing

	if (self.tome_finished) W_Reload(0.13);
	else W_Reload(0.9);
	org = self.origin + '0 0 16';
	self.poisonous = 1;
	newmis = launch_projectile(org,dir,NO_SPIN,CT_PROJ_BOLT2,1100);
	self.poisonous = 0;
};

void() W_FireIceCrossbow = { // [FUNCTION]
    local vector start, dir, vx, vy;

    if (self.ammo_bolts < 1 && self.ammo_poison < 1) return;

	if (self.ammo_poison > 0) self.currentammo = self.ammo_poison = self.ammo_poison - 1;
    else self.currentammo = self.ammo_bolts = self.ammo_bolts - 1;

    self.punchangle_x = -2;
    makevectors(self.v_angle);
    start = self.origin + v_forward*8 + '0 0 16';
    dir = v_forward;    // No auto-aim please.
    vx = v_forward * 0.9848;    // cos(10)
    vy = v_right * 0.1736;      // sin(10)
	if (self.ammo_poison > 0) self.poisonous = 1;
    Buriza_Launch(start, dir);
	self.poisonous = 0;
	if (self.tome_finished) W_Reload(0.13);
	else W_Reload(0.9);
};

void() W_FirePlasma = { // [FUNCTION]
	local vector org, dir;
	local float cells;
	
	// If run out of ammo, switch weapons to next best
	if (self.attack_finished > time) return;
	if (self.ammo_cells < 1) { forceweaponswitch(0.2); return; }

	// Do nothing if weapon is under water
	if (self.waterlevel > 1) {
		// Air tank vania item wil explode weapon instead
		if (self.moditems & IT_ARTWETSUIT) {
			// Use all cells
			cells = self.ammo_cells;
			// Update inventory
			self.ammo_cells = 0;
			W_SetCurrentAmmo (self,TRUE);
			// Impact avoidance sound
			PlayBlastBeltSound(self);
			// Death to everything around, except players!
			T_RadiusDamage(self, self, 35*cells, self, IGNORECLASS);
			// Reduce player HP down to 50%, no armour saves!
			T_Damage(self, world, world, self.health*0.5, NOARMOR);
		} else {
			W_Reload(0.2);
			sound(self,CHAN_WEAPON,SOUND_MISFIRE,1,ATTN_NORM);
		}
		return;
	}
	
	self.effects = self.effects | EF_MUZZLEFLASH;
	W_Reload(0.2);
	self.punchangle_x = -2;
	makevectors(self.v_angle);

	// Check for auto aim state
	// Auto aim assist (builtin function 44)
	if ((autoaim_cvar < 1) && self.classtype != CT_MONGREMLIN)  dir = aim(self, SPEED_PLAYPLASMA);
	else dir = normalize(v_forward * SPEED_PLAYPLASMA); // Straight line forward where crosshair is pointing

	sound(self,CHAN_WEAPON,"ad171/weapons/plasma_fire.wav",1,ATTN_NORM);
	self.currentammo = self.ammo_cells = self.ammo_cells - 1;
	org = self.origin + v_forward*8 + '0 0 16';
	newmis = launch_projectile(org,dir,NO_SPIN,CT_PROJ_PLASMA,SPEED_PLAYPLASMA);
};

void() W_FireLightning = { // [FUNCTION]
	local vector dir;
	local float cells, ct, iter;

	if (self.ammo_cells < 1) { forceweaponswitch(0.2); return; } // Ran out of ammo, switch to next best weapon

	// explode if under water
	if (self.waterlevel > 1) {
		cells = self.ammo_cells; 
		self.currentammo = self.ammo_cells = 0; // Use all cells
		W_SetCurrentAmmo(self,TRUE); // Update inventory

		if (self.tome_finished) {
			// Make some extra tome of power spark effects off the player
			iter = 0;
			while (iter < 30) {
				newmis = make_spark(self.origin, VEC_ORIGIN, TRUE); // TRUE for random using Rubicon method.
				newmis.velocity_z = crandom() * 300;
				newmis.velocity_y = crandom() * 300;
				newmis.velocity_x = crandom() * 300;
				newmis.solid = SOLID_NOT;
				newmis.touch = SUB_Null;
				newmis.skin = 8;
				iter = iter + 1;
			}

			cells = cells * 2; // Double discharge damage
			if (cells < 50) cells = 50; // Less than 25 cells is same as 25 cells.
		}

		if (self.moditems & IT_ARTWETSUIT) {
			// Air tank vania item saves player from death
			PlayBlastBeltSound(self); // Impact avoidance sound
			T_RadiusDamage(self, self, 35*cells, self, IGNORECLASS); // Death to everything around.
			T_Damage(self, world, world, self.health*0.5, NOARMOR); // Reduce player HP down to 50%, no armour saves!
		} else {
			// Default behaviour, death to everything!
			T_RadiusDamage(self, self, 35*cells, world, DAMAGEALL); 
		}
		return;
	}

	// Time for a new LG hit sound?
	if (self.t_width < time) {
		sound(self,CHAN_WEAPON,"weapons/lhit.wav",1,ATTN_NORM);
		self.t_width = time + 0.6;
	}
	
	self.currentammo = self.ammo_cells = self.ammo_cells - 1;
	self.effects = self.effects | EF_MUZZLEFLASH;
	W_Reload(0.2);
	self.punchangle_x = -2;
	dir = self.origin + '0 0 16';
	traceline (dir, dir + v_forward*6000, TRUE, self);
	Tent_Beam(TE_LIGHTNING2,self,dir,trace_endpos);
	LightningDamage(self.origin,trace_endpos + v_forward * 4,self,DAMAGE_LGPLAYER);
};

// Fires chain lightning.  Replaces 'W_FireLightning' and custom 'W_FireBurstLight'.
void(float cl) W_FireThunderbolt = { // [FUNCTION]
    local   vector  org;
    local   float   cells, damage;     // Used as ammo cost first, then as damage.

	// Ran out of ammo, switch to next best weapon
	if (self.ammo_cells < 1) { forceweaponswitch(0.2); return; }

	// Do nothing if weapon is under water
	if (self.waterlevel > 1) {
		// Air tank vania item wil explode weapon instead
		if (self.moditems & IT_ARTWETSUIT) {
			// Use all cells
			cells = self.ammo_cells;
			// Update inventory
			self.ammo_cells = 0;
			W_SetCurrentAmmo (self,TRUE);
			PlayBlastBeltSound(self); // Impact avoidance sound
			T_RadiusDamage(self, self, 35*cells, self, IGNORECLASS); // Death to everything around, except players!
			T_Damage(self, world, world, self.health*0.5, NOARMOR); // Reduce player HP down to 50%, no armour saves!
		} else {
			W_Reload(0.2);
			sound(self,CHAN_WEAPON,SOUND_MISFIRE,1,ATTN_NORM);
		}
		return;
	}

    if (self.t_width < time) {
        sound(self,CHAN_WEAPON,"weapons/lhit.wav",1,ATTN_NORM);
        self.t_width = time + 0.6;
    }
    self.punchangle_x = -2;

    damage = 2;
    if (self.tome_finished)
        damage = damage + 1;
    if (self.ammo_cells < damage)
        damage = self.ammo_cells;

	self.currentammo = self.ammo_cells = self.ammo_cells - damage;
    damage = damage * 15;

	// Grrr, when a beam is drawn from a client, it always starts from the
	// origin no matter the source point passed.  QuakeC can't fix this
	// without causing some other problem sore to the eyes.
    makevectors(self.v_angle);
    org = self.origin + '0 0 16';
	// Note:  Changing 1st parm won't make lightning start elsewhere from client.
    if (cl)
        BurstLit_Bolt(self.origin,org + v_forward*6000,self,damage,350); // Always chain
    else
        LightningBolt(self.origin,org + v_forward*6000,self,damage,self,TE_LIGHTNING2);
};

void() W_FireMultiGrenade = { // [FUNCTION]
	local vector dir, avel;
	local float spd;

	if (self.attack_finished > time) return;
	if (self.ammo_multi_rockets < 1) { forceweaponswitch(0.2); return; }

	self.ammo_multi_rockets = (self.ammo_multi_rockets - 1);
	self.currentammo = (self.currentammo - TRUE);
	sound(self,CHAN_WEAPON,"weapons/grenade.wav",TRUE,ATTN_NORM);
	self.effects = self.effects | EF_MUZZLEFLASH;
	W_Reload(0.6);
	self.punchangle_x = -2;
	makevectors(self.v_angle);
	dir = v_forward;
	spd = SPEED_PLAYGRENADE;
	if (self.tome_finished) spd = 800; // Faster
	if (autoaim_cvar < 1) spd = SPEED_PLAYAIM;
	if (self.v_angle_x) { // Has the player aimed left/right? then no auto aim assist
		dir = dir * spd + v_up * ELEV_ZAXIS + crandom()*v_right*10 + crandom()*v_up*10;
	} else {
		if ((autoaim_cvar < 1) && self.classtype != CT_MONGREMLIN) dir = aim(self,spd); // Check for auto aim state
		dir = dir * spd;
		dir_z = ELEV_ZAXIS; // Work out default speed and elevation
	}
	avel = vecrand(100,200,FALSE);
	newmis = launch_projectile(self.origin, dir, avel, CT_PROJ_GLMULTI,1);
	newmis.tome_finished = self.tome_finished;
};

void() W_FireMultiRocket = { // [FUNCTION]
	if (self.attack_finished > time) return;
	self.ammo_multi_rockets = (self.ammo_multi_rockets - TRUE);
	self.currentammo = (self.currentammo - TRUE);
	sound(self,CHAN_WEAPON,"weapons/sgun1.wav",TRUE,ATTN_NORM);
	self.punchangle_x = CONTENT_SOLID;
	MultiRocketLaunch(-10.000,FL_SWIM);
	MultiRocketLaunch(-5,MOVETYPE_WALK);
	MultiRocketLaunch(MOVETYPE_FLY,FALSE);
	MultiRocketLaunch(MOVETYPE_BOUNCE,TRUE);
	W_Reload(0.9);
};

entity() W_FirePlasmaGun = { // [FUNCTION]
	local entity missile;
	local float cells;

	if (self.attack_finished > time) return world; // Do nothing if weapon is under water
	
	if (self.waterlevel > 1) {
		if (self.moditems & IT_ARTWETSUIT) { // Air tank vania item wil explode weapon instead
			cells = self.ammo_cells; // Use all cells
			self.ammo_cells = 0; // Update inventory
			W_SetCurrentAmmo (self,TRUE);
			PlayBlastBeltSound(self); // Impact avoidance sound
			T_RadiusDamage(self, self, 35*cells, self, IGNORECLASS); // Death to everything around, except players!
			T_Damage(self, world, world, self.health*0.5, NOARMOR); // Reduce player HP down to 50%, no armour saves!
		} else {
			W_Reload(0.2);
			sound(self,CHAN_WEAPON,SOUND_MISFIRE,1,ATTN_NORM);
		}
		return world;
	}

	self.ammo_plasma = (self.ammo_plasma - TRUE);
	self.currentammo = (self.currentammo - TRUE);
	sound(self,CHAN_WEAPON,"rogue/plasma/fire.wav",0.500,ATTN_NORM);
	self.punchangle_x = CONTENT_SOLID;
	missile = spawn();
	missile.classgroup = CG_PROJCELLS;
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	missile.classname = "plasma";
	makevectors(self.v_angle);
	missile.velocity = aim (self,1250);
	missile.velocity = (missile.velocity * 1250);
	missile.avelocity = '300.000 300.000 300.000';
	missile.angles = vectoangles (missile.velocity);
	missile.touch = PlasmaTouch;
	setmodel(missile,"progs/plasma.mdl");
	setsize (missile,VEC_ORIGIN,VEC_ORIGIN);
	setorigin(missile,((self.origin + (v_forward * FL_CLIENT)) + '0.000 0.000 16.000'));
	sound(missile,CHAN_WEAPON,"rogue/plasma/flight.wav",TRUE,ATTN_NORM);
	missile.think = PlasmaGroundOut;
	missile.nextthink = (time + MOVETYPE_FLY);
	W_Reload(0.8);
	return missile;
};

// Called when player launches a MIRV.
void() W_FireStinger = { // [FUNCTION]
    local vector start;

    if (self.ammo_rockets < COST_MIRV) { W_FireRocket(); return; }

    self.currentammo = self.ammo_rockets = self.ammo_rockets - COST_MIRV; // Cost of admission paid.  Launch the big missile.
    sound(self,CHAN_WEAPON,"drake/weapons/mirv1.wav",1,ATTN_NORM);
    self.punchangle = '6 0 -12';
    makevectors(self.v_angle);
    self.velocity = self.velocity - (v_forward * 100);  // Recoil!
    start = self.origin + self.view_ofs + (v_forward*8) + (v_right*8);
    self.mirv1 = Mirv_Launch(start,v_forward);
};

// Launches a small MIRV that splits into mini-rockets a few frames
// after launch.  One big rocket causes less backlash than several
// smaller rockets.
//
// I wanted a multi-rocket launcher, much like a shotgun that fires rockets
// instead of pellets, but backlash from multiple rockets at point-blank
// causes too much damage and knockback.  Instead, a MIRV is launched.
// See above for details.
entity() W_FireHydra = { // [FUNCTION]
    local vector start, dir;
    local float cost;
	local entity hydra;

    if (self.ammo_rockets < 1) return world;

    cost = 3;
    if (self.ammo_rockets < cost) cost = self.ammo_rockets;
    self.currentammo = self.ammo_rockets = self.ammo_rockets - cost;
    sound(self,CHAN_WEAPON,"zerstorer/weapons/stunfire.wav",1,ATTN_NORM);
    self.punchangle_x = -2;
    makevectors(self.v_angle);
    start = self.origin + v_forward*8 + '0 0 16';
    dir = v_forward;
	hydra = launch_projectile(start,dir,NO_SPIN,CT_PROJ_ROCKET,SPEED_RLPLAYER);
    hydra.velocity = dir * 600;
    hydra.count    = cost;         // # of warheads after splitting.
    hydra.nextthink= time + 0.2;
    hydra.think    = Hydra_Split;
    if (cost >= 2) { // Make bigger explosion if payload includes multiple rockets.
        hydra.dmg      = cost * 30 + 60;
        hydra.think1   = BecomeBigBang;
    }
	return hydra;
};

entity() W_FireBeam = { // [FUNCTION]
	local entity beam;

	// explode if under water
	if (self.waterlevel > 1) {
		beam_water_burst(self.ammo_cells*2);
		self.currentammo = self.ammo_cells = 0;
		return world;
	}

	beam = spawn();
	beam.solid = SOLID_NOT;
	beam.movetype = MOVETYPE_FLY;
	// amount of damage done is based on how much cell ammo you've got
	beam.currentammo = self.currentammo;
	setorigin(beam, self.origin);
	beam.owner = self;
	beam.think = beam_generate;
	beam.nextthink = time + 0.05;
	return beam;
};

// Madfox's BFG implementation
//void(float damage) W_FireRail = {
entity(float damage) W_FireBFG = { // [FUNCTION]
	local entity tempen, railtrail;
	local vector orgen, orgo, dir, tdir, dorg;
	local float donerail, loopiter;

	makevectors(self.v_angle);
	sound(self,CHAN_WEAPON,"weapons/sgun1.wav",1,ATTN_NORM);
	self.ammo_cells = self.ammo_cells - 5;
	self.currentammo = floor(self.ammo_cells / 5);
	orgo = self.origin + self.view_ofs + v_forward*8;
	dir = v_forward;
	traceline (orgo, orgo + v_forward*2048, FALSE, self);
	loopiter = 20;
	while(!donerail) {
		loopiter = loopiter - 1;
		if (trace_ent && trace_ent != world) {
			if (trace_ent.takedamage) {
				orgen = trace_endpos + dir*4;
				dorg = trace_endpos - dir*4;
				SpawnBlood(trace_ent, dorg, '0 0 0', damage,0);
				T_Damage(trace_ent, self, self, damage,DAMARMOR);
				if (trace_ent.movetype != MOVETYPE_PUSH && trace_ent.classname != "monster_oldone" && trace_ent.classname != "monster_boss") {
					tdir = trace_endpos - orgo;
					tdir = normalize(tdir);
					trace_ent.flags = trace_ent.flags - (trace_ent.flags & FL_ONGROUND);
					trace_ent.velocity = trace_ent.velocity + tdir*(170+damage);

					if (trace_ent.velocity_z < 270)
					trace_ent.velocity_z = trace_ent.velocity_z + 270;
				}
			} else {
				dorg = trace_endpos - dir*4;
				donerail = TRUE;
			}
			tempen = self;
			self = trace_ent;
			traceline(orgen, orgen + dir*2048, FALSE, self);
			self = tempen;
		}
		if (loopiter < 1) donerail = TRUE; // Kill while loop.
	}
	railtrail = spawn();
	railtrail.solid = SOLID_NOT;
	setsize(railtrail, '-1 -1 -1', '1 1 1');
	setorigin(railtrail, orgo);
	railtrail.classname = "railtrail";
	railtrail.nextthink = time + 0.1;
	railtrail.think = BFGTracerThink;
	railtrail.oldorigin = dorg;
	railtrail.view_ofs = orgo;
	railtrail.pos1 = dir; // store old velocity
	railtrail.owner = self;
	return railtrail;
};

void(entity targ, float resetweaponframe) W_SetCurrentAmmo = { // [FUNCTION]
	if (frame_pause()) return; // intermission, cinematic, or finale

	if (resetweaponframe) remoteplayer_run(targ);	// Get out of any weapon firing states.

	if (targ.tethered && targ.tetherfocus && targ.health > 0) {
		targ.currentammo = 0;
		targ.weaponmodel = "progs/hexen2/xhair.mdl";
		targ.weaponframe = 0;
		return;
	}

	if (!targ.weaponismoditems) {
		if (targ.weapon == IT_AXE) {
			targ.currentammo = 0;
			if (targ.moditems & IT_UPGRADE_AXE) {
				targ.weaponmodel = MODEL_VWEAP_UPAXE;
			} else {
				targ.weaponmodel = v_axemodel;
			}
			if (targ.perms & IT_CHAINSAW) targ.weaponmodel = v_chainsawmodel; // override axes
		} else if (targ.weapon == IT_SHOTGUN) {
			targ.currentammo = targ.ammo_shells;
			if (targ.perms & IT_BLASTER) {
				targ.weaponmodel = "progs/drake/v_laserb.mdl";
			} else {
				if (targ.items & IT_SHOTGUN) {
					targ.weaponmodel = MODEL_VWEAP_SG;
				} else {
					// This is also called no axe startup option.  Cinematic mode, no viewmodel
					targ.weaponmodel = "";
					targ.currentammo = 0;
				}
			}
		} else if (targ.weapon == IT_SUPER_SHOTGUN) {
			targ.currentammo = targ.ammo_shells;
			if (targ.moditems & IT_UPGRADE_SSG) targ.weaponmodel = MODEL_VWEAP_UPSSG;
			else if (targ.items3 & IT3_RIOTCONTROLLER) targ.weaponmodel = "progs/zerstorer/v_dshot.mdl";
			else targ.weaponmodel = MODEL_VWEAP_SSG;
		} else if (targ.weapon == IT_LAVA_NAILGUN) {
			targ.currentammo = targ.ammo_lava_nails;
			targ.weaponmodel = MODEL_VWEAP_LAVANG;
		} else if (targ.weapon == IT_NAILGUN) {
			targ.currentammo = targ.ammo_nails;
			targ.weaponmodel = MODEL_VWEAP_NG;
		} else if (targ.weapon == IT_LAVA_SUPER_NAILGUN) {
			targ.currentammo = targ.ammo_lava_nails;
			targ.weaponmodel = MODEL_VWEAP_LAVASNG;
		} else if (targ.weapon == IT_SUPER_NAILGUN) {
			targ.currentammo = targ.ammo_nails;
			targ.weaponmodel = MODEL_VWEAP_SNG;
		} else if (targ.weapon == IT_MULTI_GRENADE) {
			targ.currentammo = targ.ammo_multi_rockets;
			targ.weaponmodel = MODEL_VWEAP_MULTG;
		} else if (targ.weapon == IT_GRENADE_LAUNCHER) {
			targ.currentammo = targ.ammo_rockets;
			targ.weaponmodel = MODEL_VWEAP_GL;
		} else if (targ.weapon == IT2_PROXIMITY_GUN) {
			targ.currentammo = targ.ammo_rockets;
			if (self.perms & IT_SIDEWINDER) targ.weaponmodel = "progs/madfox/mf_v_rock.mdl";
			else targ.weaponmodel = "progs/hipnotic/v_prox.mdl";
		} else if (targ.weapon == IT_MULTI_ROCKET) {
			targ.currentammo = targ.ammo_multi_rockets;
			targ.weaponmodel = MODEL_VWEAP_MULTR;
		} else if (targ.weapon == IT_ROCKET_LAUNCHER) {
			targ.currentammo = targ.ammo_rockets;
			if (targ.moditems & IT_MIRV) {
				targ.weaponmodel = "progs/drake/v_mirv.mdl";
			} else {
				targ.weaponmodel = MODEL_VWEAP_RL;
			}
		} else if (targ.weapon == IT_LIGHTNING) {
			targ.currentammo = targ.ammo_cells;
			if (targ.moditems & IT_UPGRADE_LG) targ.weaponmodel = MODEL_VWEAP_UPLG;
			else targ.weaponmodel = MODEL_VWEAP_LG;
		} else if (targ.weapon == IT2_CHAINLIGHTNING) {
			targ.currentammo = targ.ammo_cells;
			targ.weaponmodel = "progs/drake/v_light2.mdl";
		} else if (targ.weapon == IT_PLASMA_GUN) {
			targ.currentammo = targ.ammo_plasma;
			targ.weaponmodel = MODEL_VWEAP_PLASM;
		} else if (targ.weapon == IT2_LASER_CANNON) {
			targ.currentammo = targ.ammo_cells;
			targ.weaponmodel = "progs/hipnotic/v_laserg.mdl";
		} else if (targ.weapon == IT_CROSSBOW) {
			if (targ.perms & IT_FROSTBOW) {
				if (targ.ammo_poison > 0) {
					targ.currentammo = targ.ammo_poison;
				} else {
					targ.currentammo = targ.ammo_bolts;
				}

				targ.weaponmodel = "progs/drake/v_xbow.mdl";
			} else {
				if (targ.ammo_poison > 0) {
					targ.currentammo = targ.ammo_poison;
					targ.weaponmodel = "progs/its/v_crossbow2.mdl";
				} else {
					targ.currentammo = targ.ammo_bolts;
					targ.weaponmodel = "progs/its/v_crossbow1.mdl";
				}
			}
		} else if (targ.weapon == IT2_MJOLNIR) {
			if (targ.hammer_finished >= time) {
				targ.weaponmodel = "";
				targ.currentammo = 0;
			} else {
				targ.currentammo = targ.ammo_cells;
				if (targ.tome_finished) targ.weaponmodel = "progs/violentrumble/v_hammerpw.mdl";
				else targ.weaponmodel = "progs/violentrumble/v_hammer.mdl";
			}
		} else if (targ.weapon == IT2_WAND) {
			targ.weaponmodel =  "progs/drake/v_wand.mdl";
		} else if (targ.weapon == IT2_GRAPPLE) {
			targ.currentammo = 0;
			targ.weaponmodel = "progs/drake/v_grpple.mdl";
			if (targ.hook) {
				if (targ.hook.count) {
					targ.weaponframe = 1;   // Hook is still out.
				}
			}
		} else if (targ.weapon == IT_SANGUINATORS) {
			targ.currentammo = targ.ammo_bloodcrystals;
			targ.weaponmodel = "progs/aoa/v_sanguinators.mdl";
		} else if (targ.weapon == IT_SCIMITAR) {
			targ.currentammo = targ.ammo_elemental;
			targ.weaponmodel = "progs/aoa/v_scimitar.mdl";
		} else if (targ.weapon == IT_RAPIER) {
			targ.currentammo = targ.ammo_bloodcrystals;
			targ.weaponmodel = "progs/aoa/v_rapier.mdl";
		} else {
			if (targ.weaponmodel != "") {
				targ.weaponmodel = "";
				targ.weaponismoditems = TRUE;
				W_SetCurrentAmmo(targ,FALSE); // Do it again for the hack bank.
				return;
			}
			// This is also called no axe startup option.  Cinematic mode, no viewmodel.
			targ.currentammo = 0;
			targ.weaponmodel = "";
		}
	} else {
		if (targ.weapon == IT_ICE) {
			targ.currentammo = targ.ammo_elemental;
			targ.weaponmodel = "progs/redfield/v_light.mdl";
		} else if (targ.weapon == IT_MACE) {
			targ.currentammo = targ.ammo_bloodcrystals;
			targ.weaponmodel = "progs/aoa/v_mace.mdl";
		} else if (targ.weapon == IT_VOID_STAFF) {
			targ.currentammo = targ.ammo_voidshards;
			targ.weaponmodel = "progs/aoa/v_voidstaff.mdl";
		} else if (targ.weapon == IT_FLAK) {
			targ.currentammo = CountFlakAmmo(targ);
			targ.weaponmodel = "progs/aoa/v_flak.mdl";
		} else if (targ.weapon == IT_GUNGNIR) {
			targ.currentammo = targ.ammo_voidshards;
			targ.weaponmodel = "progs/aoa/v_gungnir.mdl";
		} else if (targ.weapon == IT_AIRGUN) {
			targ.currentammo = 0;
			targ.weaponmodel = "progs/airfist/v_airgun.mdl";
		} else {
			if (targ.weaponmodel != "") {
				targ.weaponmodel = "";
				targ.weaponismoditems = FALSE;
				W_SetCurrentAmmo(targ,FALSE); // Do it again for the other bank.
				return;
			}
			// This is also called no axe startup option.  Cinematic mode, no viewmodel.
			targ.currentammo = 0;
			targ.weaponmodel = "";
		}
	}
};

// Return best weapon based on current ammo quantities, excludes rockets and multi-rockets for obvious heat of the moment self inflicted damage avoidance
float(entity targ) W_BestWeapon = { // [FUNCTION]
	if (targ.waterlevel < 1 && targ.ammo_cells > 0 && (targ.items & IT2_LASER_CANNON) ) return IT2_LASER_CANNON;
	if (targ.waterlevel < 1 && targ.ammo_cells > 0 && (targ.items2 & IT2_CHAINLIGHTNING) ) return IT2_CHAINLIGHTNING;
	if (targ.waterlevel < 1 && targ.ammo_cells > 0 && (targ.items & IT_LIGHTNING) ) return IT_LIGHTNING;
	if (targ.waterlevel < 1 && targ.ammo_cells > 0 && (targ.items & IT2_MJOLNIR) ) return IT2_MJOLNIR;
	if (targ.ammo_bloodcrystals > 0 && (targ.items & IT_SANGUINATORS) ) return IT_SANGUINATORS;
	if (targ.ammo_lava_nails > 1 && (targ.items & IT_LAVA_SUPER_NAILGUN) ) return IT_LAVA_SUPER_NAILGUN;
	if (targ.ammo_nails > 1 && (targ.items & IT_SUPER_NAILGUN) ) return IT_SUPER_NAILGUN;
	if (targ.ammo_lava_nails > 1 && (targ.items & IT_LAVA_NAILGUN) ) return IT_LAVA_NAILGUN;
	if (targ.ammo_elemental > 0 && (targ.items & IT_SCIMITAR) ) return IT_SCIMITAR;
	if ((targ.ammo_bolts > 1 || targ.ammo_poison > 1) && (targ.items & IT_CROSSBOW) ) return IT_CROSSBOW;
	if (targ.ammo_bloodcrystals > 0 && (targ.items & IT_SANGUINATORS) ) return IT_SANGUINATORS;
	if (targ.ammo_shells > 2 && (targ.items & IT_SUPER_SHOTGUN) ) return IT_SUPER_SHOTGUN; // greater than 2 in case of upgraded triple shotgun Widowmaker
	if (targ.ammo_nails > 0 && (targ.items & IT_NAILGUN) ) return IT_NAILGUN;
	if (targ.ammo_shells > 0 && ((targ.items & IT_SHOTGUN) || (targ.perms & IT_BLASTER))) return IT_SHOTGUN;
	if (targ.waterlevel > 0 && targ.ammo_cells < 1 && (targ.items & IT2_MJOLNIR) ) return IT2_MJOLNIR;
	if (targ.items & IT_AXE) return IT_AXE;
	if (targ.items2 & IT2_WAND) return IT2_WAND; // WAND
	return FALSE;
};

float(float w) RankForWeapon = {
	if (w == IT_PLASMA_GUN)
		return 1;
	if (w == IT_LIGHTNING)
		return 2;
	if (w == IT_MULTI_ROCKET)
		return 3;
	if (w == IT_ROCKET_LAUNCHER)
		return 4;
	if (w == IT_LAVA_SUPER_NAILGUN)
		return 5;
	if (w == IT_SUPER_NAILGUN)
		return 6;
	if (w == IT_MULTI_GRENADE)
		return 7;
	if (w == IT_GRENADE_LAUNCHER)
		return 8;
	if (w == IT_LAVA_NAILGUN)
		return 9;
	if (w == IT_SUPER_SHOTGUN)
		return 10;
	if (w == IT_NAILGUN)
		return 11;
	return 12;
};

void(float old, float new) Deathmatch_Weapon = {
	local float or, nr;

	// PGM - fix for changing to weapons when grappling.
	if (self.weapon == IT2_GRAPPLE && self.button0) return;

	// change self.weapon if desired
	or = RankForWeapon (self.weapon);
	nr = RankForWeapon (new);
	if ( nr < or ) self.weapon = new;
};

float(entity targ) W_CheckNoAmmo = { // [FUNCTION]
	if (targ.in_a_vehicle && targ.randomshells > 0) return TRUE;
	if (targ.tethered && targ.tetherfocus && targ.health > 0) {
		if (targ.tetherfocus.ammo_bolts > 0) return TRUE;
		sound(self,CHAN_WEAPON,"weapons/noammo.wav",1,ATTN_NORM);
		return FALSE;
	}

	if (targ.weaponismoditems) {
		if (targ.weapon == IT_FLAK) targ.currentammo = CountFlakAmmo(targ);
		if (targ.weapon == IT_GUNGNIR || targ.weapon == IT_MACE
			|| targ.weapon == IT_AIRGUN) return TRUE;
	} else {
		if (targ.weapon == IT_AXE || targ.weapon == IT2_MJOLNIR
		    || targ.weapon == IT2_WAND || targ.weapon == IT2_GRAPPLE
		    || targ.weapon == IT_RAPIER || targ.weapon == IT_SCIMITAR) {
			return TRUE;
		}
	}

	if (targ.currentammo > 0) return TRUE;

	targ.weapon = W_BestWeapon(targ);
	W_SetCurrentAmmo(targ,TRUE);
	return FALSE; // drop the weapon down
};

void() W_Attack = { // [FUNCTION]
	local entity stemp;

	if (cinematic_running > 0 || cutscene > 0) return;
	if (!W_CheckNoAmmo(self)) return;	// Out of ammo?

	makevectors(self.v_angle);		// calculate forward angle for velocity
	if (((self.weapon != IT_CROSSBOW && !self.weaponismoditems)
		|| (self.perms & IT_FROSTBOW && self.weapon == IT_CROSSBOW
		&& !self.weaponismoditems)) && self.weapon != IT_AXE
		&& !self.weaponismoditems) {
		W_ShowHostile();
	}

    self.b0_click = 0;
	if (self.in_a_vehicle && self.health > 0) {
		W_FireSpikes(0,crandom() * 2.5);
		self.randomshells = self.randomshells - 1;
		W_Reload(0.05);
		return;
	}

	// Fire a controlled ballista, obj_ballista
	if (self.tethered && self.tetherfocus && self.health > 0) {
		stemp = self;
		self = self.tetherfocus;
		self.th_missile();
		self = stemp;
		return;
	}

	if (!self.weaponismoditems) {
		if (self.weapon == IT_AXE) {
			if (self.perms & IT_CHAINSAW) { // Chainsaw overrides axes once acquired.
				player_saw1(); 
				W_Reload(0.55);
				sound(self,CHAN_AUTO,"zerstorer/weapons/sawatck.wav",1,ATTN_NORM);
				W_ShowHostile(); // Always alerting monsters nearby when chainsaw running.
			} else {
				// Axe and Shadowaxe
				if (random() < 0.5) sound(self,CHAN_WEAPON,SOUND_AXE_SWIPE1,1,ATTN_NORM);
				else sound(self,CHAN_WEAPON,SOUND_AXE_SWIPE2,1,ATTN_NORM);
				
				self.lip = self.meleeattack; // Work out which axe swing to play (never play swing twice in a row)
				while (self.meleeattack == self.lip) {
					self.lip = rint(random()*4.4);
				}
				self.meleeattack = self.lip;
				if (v_axemodel == "progs/ad171/v_shadaxe0.mdl") {
					if (self.meleeattack == 0) player_axe1();
					else if (self.meleeattack == 1) player_axeb1();
					else if (self.meleeattack == 2) player_axec1();
					else if (self.meleeattack == 3) player_axed1();
					else player_axee1();
				} else {
					if (self.meleeattack == 0) player_axe1();
					else if (self.meleeattack == 1) player_axeb1();
					else if (self.meleeattack == 2) player_axeoldc1();
					else player_axeoldd1();
				}

				if (self.tome_finished) W_Reload(0.25);
				else W_Reload(0.5);
			}
		} else if (self.weapon == IT_SHOTGUN) {
			if (self.perms & IT_BLASTER) {
				player_blast1(); // use laser blaster only once we have it, still uses shells
			} else {
				player_sg1(); // use standard single barrel shotgun
			}
		} else if (self.weapon == IT_SUPER_SHOTGUN) {
			if (self.moditems & IT_UPGRADE_SSG) player_supersg1();
			else if (self.items3 & IT3_RIOTCONTROLLER) {
				player_rc1();
				if (self.perms & POW_SHOTTYMAN) W_Reload(0.45);

				else W_Reload(0.9);
			} else player_supersg1();
		} else if (self.weapon == IT_NAILGUN) { player_nail1(); }
		else if (self.weapon == IT_LAVA_NAILGUN) { player_lava_nail1(); self.lavaGunFired = TRUE; }
		else if (self.weapon == IT_SUPER_NAILGUN) { player_snail1(); }
		else if (self.weapon == IT_LAVA_SUPER_NAILGUN) { player_lava_snail1();  self.lavaGunFired = TRUE; }
		else if (self.weapon == IT_MULTI_GRENADE) { player_multi_grenade1(); }
		else if (self.weapon == IT_GRENADE_LAUNCHER) { player_grenade1(); }
		else if (self.weapon == IT_MULTI_ROCKET) { player_multi_rocket1(); }
		else if (self.weapon == IT_ROCKET_LAUNCHER) {
			if (self.moditems & IT_MIRV) {
				player_bfg1();
				W_Reload(1.5);
				if (self.mirv1) {
					dprint("MIRV Split!\n");
					self.mirv1.delay = time;
					self.mirv1 = world;
					self.attack_finished = time + 0.1;
				} else W_FireStinger();
			} else {
				player_rocket1();
			}
		} else if (self.weapon == IT_PLASMA_GUN) { player_plasmalight1(); }
		else if (self.weapon == IT_LIGHTNING) {
			if (self.moditems & IT_UPGRADE_LG) player_plasma1();
			else {
				player_light1(); 
				sound(self,CHAN_AUTO,"weapons/lstart.wav",1,ATTN_NORM); 
			}
		} else if (self.weapon == IT_CROSSBOW) {
			if (self.perms & IT_FROSTBOW) {
				player_xbow1();
				W_Reload(0.8);
			} else {
				player_crossbow1();
			}
		} else if (self.weapon == IT2_LASER_CANNON) player_laser1();
		else if (self.weapon == IT2_MJOLNIR) {
			if ((world.hipnoticoptions & HIPNOTIC_OLDMJOLNIR)) {
				W_Reload(0.8);
				if ( (self.ammo_cells < SVC_INTERMISSION) ) {
					player_hammer1original();
				} else {
					player_mjolnir1original();
				}
			} else {
				if (self.ammo_cells < COST_MJOLNIR && self.hammer_finished == 0) {
					W_Reload(0.4);
					player_hammer1();
				} else {
					W_Reload(0.4);
					player_mjolnir1();
				}
			}
		} else if (self.weapon == IT2_GRAPPLE) {
				if (self.hook) {
					// Assume hook was improperly removed, so reset links.
					if (!self.hook.modelindex) {   
						self.hook = world;  // So W_FireGrapple fires a hook.
						player_grapple1();
						return;
					}
					if (self.hook.count) return;
					player_grapple3();
				} else player_grapple1();

				// Modified animation takes three frames to complete, hence 0.3 for 0.1 * 3.
				W_Reload(0.3);
		} else if (self.weapon == IT2_PROXIMITY_GUN) {
			if (self.tome_finished) {
				W_FireHydra();
				W_Reload(1.5);
			} else {
				if (self.perms & IT_SIDEWINDER) { W_FireSidewinder(); W_Reload(1); }
				else player_prox_grenade1();
			}
		} else if (self.weapon == IT2_CHAINLIGHTNING) {
			player_chainlight1();
			W_Reload(0.1);
			sound(self,CHAN_AUTO,"weapons/lstart.wav",1,ATTN_NORM);
		} else if (self.weapon == IT2_WAND) {
			player_wand1();
			W_FireSparks();
		} else if (self.weapon == IT_SANGUINATORS) W_FireSanguinators();
		else if (self.weapon == IT_SCIMITAR) W_FireScimitar(); 
		else if (self.weapon == IT_RAPIER) W_FireRapier();
	} else {
		if (self.weapon == IT_ICE) { W_FireIce(); }
		else if (self.weapon == IT_MACE) { W_FireMace(); }
		else if (self.weapon == IT_VOID_STAFF) { W_FireVoidStaff(); }
		else if (self.weapon == IT_FLAK) { W_FireFlak(); }
		else if (self.weapon == IT_GUNGNIR) { W_FireGungnir(); }
		else if (self.weapon == IT_AIRGUN) { W_FireAirFist(); } // Fire the Airfist weapon
	}
};

float (entity targ, float testValue) InItems = { // [FUNCTION]
   if (targ.items & testValue) return TRUE;
   return FALSE;
};

float (entity targ, float testValue) InItems2 = { // [FUNCTION]
   if (targ.items2 & testValue) return TRUE;
   return FALSE;
};

float (entity targ, float testValue) InModItems = { // [FUNCTION]
   if (targ.moditems & testValue) return TRUE;
   return FALSE;
};

float (entity targ, float testValue) InPerms = { // [FUNCTION]
   if (targ.perms & testValue) return TRUE;
   return FALSE;
};

float IN_ITEMS1 = 1;
float IN_ITEMS2 = 2;
float IN_MODITEMS = 4;
float IN_PERMS = 8;
float IN_ITEMS1_HACKBANK = 16;
float IN_ITEMS2_HACKBANK = 32;
float IN_MODITEMS_HACKBANK = 64;
float IN_PERMS_HACKBANK = 128;

float (float mask, entity targ, float testValue) InAnyItems = { // [FUNCTION]
	if (mask == IN_ITEMS1) return InItems(targ,testValue);
	if (mask == IN_ITEMS2) return InItems2(targ,testValue);
	if (mask == IN_MODITEMS) return InModItems(targ,testValue);
	if (mask == IN_PERMS) return InPerms(targ,testValue);
	if (mask == IN_ITEMS1_HACKBANK) return InItems(targ,testValue);
	if (mask == IN_ITEMS2_HACKBANK) return InItems2(targ,testValue);
	if (mask == IN_MODITEMS_HACKBANK) return InModItems(targ,testValue);
	if (mask == IN_PERMS_HACKBANK) return InPerms(targ,testValue);
	return FALSE;
}

// FOUR WEAPONS ON THE SAME KEYBOARD KEY!!!  Good lawdy we need a bigger keyboard!
// Function to cycle within the same slot by multiple keypresses, e.g. keep pressing 6 to cycle through grenade launcher,
// proximity grenade launcher, and multi-grenade launcher.
// Returns a vector: x = fl (the new self.weapon, y = gotgun (whether we have it), z = (if it is in the hackbank)
// targ = player
// wep# = # weapon in this keybind's slot
// wep#initems = bitmask to specify whether to use self.items, self.items2, self.moditems, or self.perms
vector (float current, entity targ, float wep1, float wep2, float wep3, float wep4, float wep1initems, float wep2initems, float wep3initems, float wep4initems) WeaponSlotPickOneOfFour = { // [FUNCTION]
	local vector retvec;
	local float fl, gotgun, gotgun1, gotgun2, gotgun3, gotgun4, am;
	local float inhackbank;
	// Make sure it's all zeroed out
	inhackbank = fl = gotgun1 = gotgun2 = gotgun3 = gotgun4 = am = FALSE;
	if (wep1) gotgun1 = InAnyItems(wep1initems, targ, wep1);
	if (wep2) gotgun2 = InAnyItems(wep2initems, targ, wep2);
	if (wep3) gotgun3 = InAnyItems(wep3initems, targ, wep3);
	if (wep4) gotgun4 = InAnyItems(wep4initems, targ, wep3);
	retvec = VEC_ORIGIN;

	// Check if we are already within the slot, then branch.
	if (current == wep1) {
		if (gotgun2) {
			fl = wep2;
			gotgun = TRUE;
		} else {
			fl = wep3;
			gotgun = gotgun3;
		}
	} else if (current == wep2) {
		if (gotgun3) {
			fl = wep3;
			gotgun = TRUE;
		} else {
			fl = wep4;
			gotgun = gotgun4;
		}
	} else if (current == wep3) {
		if (gotgun4) {
			fl = wep4;
			gotgun = TRUE;
		} else {
			fl = wep1;
			gotgun = gotgun1;
		}
	} else if (current == wep4) {
		if (gotgun1) {
			fl = wep1;
			gotgun = TRUE;
		} else {
			fl = wep2;
			gotgun = gotgun2;
		}
	} else {
		// If not in the slot, pick first available in slot.
		if (gotgun1) {
			fl = wep1;
			gotgun = TRUE;
		} else if (gotgun2) {
			fl = wep2;
			gotgun = TRUE;
		} else if (gotgun3) {
			fl = wep3;
			gotgun = TRUE;
		} else if (gotgun4) {
			fl = wep4;
			gotgun = TRUE;
		}
	}

	if (fl == wep1) {
		if (wep1initems == IN_ITEMS1_HACKBANK || wep1initems == IN_ITEMS2_HACKBANK
			|| wep1initems == IN_MODITEMS_HACKBANK || wep1initems == IN_PERMS_HACKBANK) inhackbank = TRUE;
	}
	if (fl == wep2) {
		if (wep2initems == IN_ITEMS1_HACKBANK || wep2initems == IN_ITEMS2_HACKBANK
			|| wep2initems == IN_MODITEMS_HACKBANK || wep2initems == IN_PERMS_HACKBANK) inhackbank = TRUE;
	}
	if (fl == wep3) {
		if (wep3initems == IN_ITEMS1_HACKBANK || wep3initems == IN_ITEMS2_HACKBANK
			|| wep3initems == IN_MODITEMS_HACKBANK || wep3initems == IN_PERMS_HACKBANK) inhackbank = TRUE;
	}
	if (fl == wep4) {
		if (wep4initems == IN_ITEMS1_HACKBANK || wep4initems == IN_ITEMS2_HACKBANK
			|| wep4initems == IN_MODITEMS_HACKBANK || wep4initems == IN_PERMS_HACKBANK) inhackbank = TRUE;
	}

	retvec.x = fl;
	retvec.y = gotgun;
	retvec.z = inhackbank;
	return retvec;
};

// Check if got weapon and ammo and switch to relevant weapon
void(entity targ) W_ChangeWeapon = { // [FUNCTION]
	local float am, fl, gotgun, inhackbank, runaway;
	local vector checkvec;
	
	if (frame_pause() || self.in_a_vehicle) return;

	if (detected_mod == MOD_ROGUE) EnableComboWeapons(other);
	am = TRUE;
	checkvec = VEC_ORIGIN;
	inhackbank = FALSE; // Set later if switching to hack bank 2nd set of 24 weapons.
	gotgun = FALSE;
	runaway = 0;
	if (targ.impulse == 1) {
		fl = targ.weapon;
		while (am) {
			checkvec = WeaponSlotPickOneOfFour(fl, targ, IT_AXE, IT2_GRAPPLE, IT_MACE, 0, IN_ITEMS1, IN_ITEMS2, IN_MODITEMS_HACKBANK, 0);
			fl = checkvec_x;
			gotgun = checkvec_y;
			inhackbank = checkvec_z;
			if (fl == IT_AXE) {
				if (InModItems(targ, IT_UPGRADE_AXE)) gotgun = TRUE;
				if (self.perms & IT_CHAINSAW) gotgun = TRUE; // Kind of hacky, but hey
				if (gotgun && fl != targ.weapon) am = FALSE;
			} else if (fl == IT_MACE && gotgun) {
				if (targ.ammo_bloodcrystals < 1) am = TRUE; // no ammo
				else if (fl != targ.weapon) am = FALSE;
			} else if (fl == IT2_GRAPPLE && gotgun) {
				if (fl != targ.weapon) am = FALSE;
			}// else if (fl == ? && gotgun) {
				//if (targ.ammo_? < 1) am = TRUE; // no ammo
				//else if (fl != targ.weapon) am = FALSE;
			//}
			runaway = runaway + 1;
			if (runaway > 13) break;
		}
	} else if (targ.impulse == 2) {
		fl = targ.weapon;
		while (am) {
			checkvec = WeaponSlotPickOneOfFour(fl, targ, IT_SHOTGUN, IT_ICE, IT_AIRGUN, 0, IN_ITEMS1, IN_MODITEMS_HACKBANK, IN_PERMS_HACKBANK, 0);
			fl = checkvec_x;
			gotgun = checkvec_y;
			inhackbank = checkvec_z;
			if (fl == IT_SHOTGUN && gotgun) {
				if (targ.ammo_shells < 1) am = TRUE; // no ammo
				else if (fl != targ.weapon) am = FALSE;
			} else if (fl == IT_ICE && gotgun) {
				if (targ.ammo_elemental < 1) am = TRUE; // no ammo
				else if (fl != targ.weapon) am = FALSE;
			} else if (fl == IT_AIRGUN && gotgun) {
				if (fl != targ.weapon) am = FALSE;
			}// else if (fl == ? && gotgun) {
				//if (targ.ammo_? < 1) am = TRUE; // no ammo
				//else if (fl != targ.weapon) am = FALSE;
			//}
			runaway = runaway + 1;
			if (runaway > 13) break;
		}
	} else if (targ.impulse == 3) {
		fl = targ.weapon;
		while (am) {
			checkvec = WeaponSlotPickOneOfFour(fl, targ, IT_SUPER_SHOTGUN, IT_SCIMITAR, 0, 0, IN_ITEMS1, IN_MODITEMS, 0, 0);
			fl = checkvec_x;
			gotgun = checkvec_y;
			inhackbank = checkvec_z;
			if (fl == IT_SUPER_SHOTGUN && gotgun) {
				if (targ.ammo_shells < 2) am = TRUE; // no ammo
				else if (fl != targ.weapon) am = FALSE;
			} else if (fl == IT_SCIMITAR && gotgun) {
				if (targ.ammo_elemental < 1) am = TRUE; // no ammo
				else if (fl != targ.weapon) am = FALSE;
			}// else if (fl == ? && gotgun) {
				//if (targ.ammo_? < 1) am = TRUE; // no ammo
				//else if (fl != targ.weapon) am = FALSE;
			//} else if (fl == ? && gotgun) {
				//if (targ.ammo_? < 1) am = TRUE; // no ammo
				//else if (fl != targ.weapon) am = FALSE;
			//}
			runaway = runaway + 1;
			if (runaway > 13) break;
		}
	} else if (targ.impulse == 4) {
		fl = targ.weapon;
		while (am) {
			checkvec = WeaponSlotPickOneOfFour(fl, targ, IT_NAILGUN, IT_LAVA_NAILGUN, IT_RAPIER, 0, IN_ITEMS1, IN_ITEMS1, IN_MODITEMS, 0);
			fl = checkvec_x;
			gotgun = checkvec_y;
			inhackbank = checkvec_z;
			if (fl == IT_NAILGUN && gotgun) {
				if (targ.ammo_nails < 1) am = TRUE; // no ammo
				else if (fl != targ.weapon) am = FALSE;
			} else if (fl == IT_LAVA_NAILGUN && gotgun) {
				if (targ.ammo_lava_nails < 1) am = TRUE; // no ammo
				else if (fl != targ.weapon) am = FALSE;
			} else if (fl == IT_RAPIER && gotgun) {
				if (fl != targ.weapon) am = FALSE; // not using ammo right now
			}// else if (fl == ? && gotgun) {
				//if (targ.ammo_? < 1) am = TRUE; // no ammo
				//else if (fl != targ.weapon) am = FALSE;
			//}
			runaway = runaway + 1;
			if (runaway > 13) break;
		}
	} else if (targ.impulse == 5) {
		fl = targ.weapon;
		while (am) {
			checkvec = WeaponSlotPickOneOfFour(fl, targ, IT_SUPER_NAILGUN, IT_LAVA_SUPER_NAILGUN, IT_VOID_STAFF, 0, IN_ITEMS1, IN_ITEMS1, IN_MODITEMS_HACKBANK, 0);
			fl = checkvec_x;
			gotgun = checkvec_y;
			inhackbank = checkvec_z;
			if (fl == IT_SUPER_NAILGUN && gotgun) {
				if (targ.ammo_nails < 2) am = TRUE; // no ammo
				else if (fl != targ.weapon) am = FALSE;
			} else if (fl == IT_LAVA_SUPER_NAILGUN && gotgun) {
				if (targ.ammo_lava_nails < 2) am = TRUE; // no ammo
				else if (fl != targ.weapon) am = FALSE;
			} else if (fl == IT_VOID_STAFF && gotgun) {
				if (targ.ammo_voidshards < 1) am = TRUE; // no ammo
				else if (fl != targ.weapon) am = FALSE;
			}// else if (fl == ? && gotgun) {
				//if (targ.ammo_? < 1) am = TRUE; // no ammo
				//else if (fl != targ.weapon) am = FALSE;
			//}
			runaway = runaway + 1;
			if (runaway > 13) break;
		}
	} else if (targ.impulse == 6) {
		fl = targ.weapon;
		while (am) {
			checkvec = WeaponSlotPickOneOfFour(fl, targ, IT_GRENADE_LAUNCHER, IT2_PROXIMITY_GUN, IT_MULTI_GRENADE, 0, IN_ITEMS1, IN_ITEMS2, IN_ITEMS1, 0);
			fl = checkvec_x;
			gotgun = checkvec_y;
			inhackbank = checkvec_z;
			if (fl == IT_GRENADE_LAUNCHER && gotgun) {
				if (targ.ammo_rockets < 1) am = TRUE; // no ammo
				else if (fl != targ.weapon) am = FALSE;
			} else if (fl == IT2_PROXIMITY_GUN && gotgun) {
				if (targ.ammo_rockets < 1) am = TRUE; // no ammo
				else if (fl != targ.weapon) am = FALSE;
			} else if (fl == IT_MULTI_GRENADE && gotgun) {
				if (targ.ammo_multi_rockets < 1) am = TRUE; // no ammo
				else if (fl != targ.weapon) am = FALSE;
			}// else if (fl == ? && gotgun) {
				//if (targ.ammo_? < 1) am = TRUE; // no ammo
				//else if (fl != targ.weapon) am = FALSE;
			//}
			runaway = runaway + 1;
			if (runaway > 13) break;
		}
	} else if (targ.impulse == 7) {
		fl = targ.weapon;
		while (am) {
			checkvec = WeaponSlotPickOneOfFour(fl, targ, IT_ROCKET_LAUNCHER, IT_MULTI_ROCKET, IT_SANGUINATORS, 0, IN_ITEMS1, IN_ITEMS1, IN_MODITEMS, 0);
			fl = checkvec_x;
			gotgun = checkvec_y;
			inhackbank = checkvec_z;
			if (fl == IT_ROCKET_LAUNCHER && gotgun) {
				if (targ.ammo_rockets < 1) am = TRUE; // no ammo
				else if (fl != targ.weapon) am = FALSE;
			} else if (fl == IT_MULTI_ROCKET && gotgun) {
				if (targ.ammo_multi_rockets < 1) am = TRUE; // no ammo
				else if (fl != targ.weapon) am = FALSE;
			} else if (fl == IT_SANGUINATORS && gotgun) {
				if (targ.ammo_bloodcrystals < 1) am = TRUE; // no ammo
				else if (fl != targ.weapon) am = FALSE;
			}// else if (fl == ? && gotgun) {
				//if (targ.ammo_? < 1) am = TRUE; // no ammo
				//else if (fl != targ.weapon) am = FALSE;
			//}
			runaway = runaway + 1;
			if (runaway > 13) break;
		}
	} else if (targ.impulse == 8) {
		fl = targ.weapon;
		while (am) {
			checkvec = WeaponSlotPickOneOfFour(fl, targ, IT_LIGHTNING, IT_PLASMA_GUN, IT_FLAK, 0, IN_ITEMS1, IN_ITEMS1, IN_MODITEMS_HACKBANK, 0);
			fl = checkvec_x;
			gotgun = checkvec_y;
			inhackbank = checkvec_z;
			if (fl == IT_LIGHTNING && gotgun) {
				if (targ.ammo_cells < 1) am = TRUE; // no ammo
				else if (fl != targ.weapon) am = FALSE;
			} else if (fl == IT_PLASMA_GUN && gotgun) {
				if (targ.ammo_plasma < 1) am = TRUE; // no ammo
				else if (fl != targ.weapon) am = FALSE;
			} else if (fl == IT_FLAK && gotgun) {
				if (targ.ammo_nails < FLAK_NAILUSAGE || targ.ammo_rockets < FLAK_ROCKETUSAGE) am = TRUE; // no ammo
				else if (fl != targ.weapon) am = FALSE;
			}// else if (fl == ? && gotgun) {
				//if (targ.ammo_? < 1) am = TRUE; // no ammo
				//else if (fl != targ.weapon) am = FALSE;
			//}
			runaway = runaway + 1;
			if (runaway > 13) break;
		}
	} else if (targ.impulse == 90) {
		fl = targ.weapon;
		while (am) {
			checkvec = WeaponSlotPickOneOfFour(fl, targ, IT_CROSSBOW, IT2_LASER_CANNON, IT2_CHAINLIGHTNING, 0, IN_ITEMS1, IN_ITEMS2, IN_ITEMS2, 0);
			fl = checkvec_x;
			gotgun = checkvec_y;
			inhackbank = checkvec_z;
			if (fl == IT_CROSSBOW && gotgun) {
				if (targ.ammo_bolts < 1) am = TRUE; // no ammo
				else if (fl != targ.weapon) am = FALSE;
			} else if (fl == IT2_LASER_CANNON && gotgun) {
				if (targ.ammo_cells < 1) am = TRUE; // no ammo
				else if (fl != targ.weapon) am = FALSE;
			} else if (fl == IT2_CHAINLIGHTNING && gotgun) {
				if (targ.ammo_cells < 1) am = TRUE; // no ammo
				else if (fl != targ.weapon) am = FALSE;
			}// else if (fl == ? && gotgun) {
				//if (targ.ammo_? < 1) am = TRUE; // no ammo
				//else if (fl != targ.weapon) am = FALSE;
			//}
			runaway = runaway + 1;
			if (runaway > 13) break;
		}
	} else if (targ.impulse == 60) {
		fl = IT_LAVA_NAILGUN;
		if (targ.ammo_lava_nails < 1) am = TRUE;
		gotgun = InItems(targ, fl);
	} else if (targ.impulse == 61) {
		fl = IT_LAVA_SUPER_NAILGUN;
		if (targ.ammo_lava_nails < 2) am = TRUE;
		gotgun = InItems(targ, fl);
	} else if (targ.impulse == 62) {
		fl = IT_MULTI_GRENADE;
		if (targ.ammo_multi_rockets < 1) am = TRUE;
		gotgun = InItems(targ, fl);
	} else if (targ.impulse == 63) {
		fl = IT_MULTI_ROCKET;
		if (targ.ammo_multi_rockets < 1) am = TRUE;
		gotgun = InItems(targ, fl);
	} else if (targ.impulse == 64) {
		fl = IT_PLASMA_GUN;
		if (targ.ammo_plasma < 1) am = TRUE;
		gotgun = InItems(targ, fl);
	} else if (targ.impulse == 75) {
		fl = IT2_LASER_CANNON;
		if (targ.ammo_cells < 1) am = TRUE;
		gotgun = InItems2(targ, fl);
	} else if (targ.impulse == 76) {
		fl = IT2_PROXIMITY_GUN;
		gotgun = InItems2(targ, fl);
	} else if (targ.impulse == 77) {
		fl = targ.weapon;
		while (am) {
			checkvec = WeaponSlotPickOneOfFour(fl, targ, IT2_MJOLNIR, IT2_WAND, IT_GUNGNIR, 0, IN_ITEMS2, IN_ITEMS2, IN_MODITEMS_HACKBANK, 0);
			fl = checkvec_x;
			gotgun = checkvec_y;
			inhackbank = checkvec_z;
			if (fl == IT_GUNGNIR && gotgun) {
				if (targ.ammo_voidshards < 1) am = TRUE; // no ammo
				else if (fl != targ.weapon) am = FALSE;
			} else if (fl == IT2_MJOLNIR && gotgun) {
				if (fl != targ.weapon) am = FALSE;
			} else if (fl == IT2_WAND && gotgun) {
				if (fl != targ.weapon) am = FALSE;
			}// else if (fl == ? && gotgun) {
				//if (targ.ammo_? < 1) am = TRUE; // no ammo
				//else if (fl != targ.weapon) am = FALSE;
			//}
			runaway = runaway + 1;
			if (runaway > 13) break;
		}
	} else if (targ.impulse == 78) {
		fl = IT_CROSSBOW;
		gotgun = InItems(targ, fl);
	} else if (targ.impulse == 79) {
		fl = IT2_WAND;
		gotgun = InItems2(targ, fl);
	} else if (targ.impulse == 80 || targ.impulse == 22) { // Rogue used 22.
		fl = IT2_GRAPPLE;
		gotgun = InItems2(targ, fl);
	} else if (targ.impulse == 81) {
		fl = IT2_CHAINLIGHTNING;
		gotgun = InItems2(targ, fl);
	} else if (targ.impulse == 82) {
		fl = IT_ICE;
		inhackbank = TRUE; // Ok we are hacking now, switch to 2nd set of 24 weapons in bank 2
		gotgun = InModItems(targ, fl);
	} else if (targ.impulse == 83) {
		fl = IT_MACE;
		inhackbank = TRUE; // Ok we are hacking now, switch to 2nd set of 24 weapons in bank 2
		gotgun = InModItems(targ, fl);
	} else if (targ.impulse == 84) {
		fl = IT_VOID_STAFF;
		inhackbank = TRUE; // Ok we are hacking now, switch to 2nd set of 24 weapons in bank 2
		gotgun = InModItems(targ, fl);
	} else if (targ.impulse == 85) {
		fl = IT_FLAK;
		inhackbank = TRUE; // Ok we are hacking now, switch to 2nd set of 24 weapons in bank 2
		gotgun = InModItems(targ, fl);
	} else if (targ.impulse == 86) {
		fl = IT_GUNGNIR;
		inhackbank = TRUE; // Ok we are hacking now, switch to 2nd set of 24 weapons in bank 2
		gotgun = InModItems(targ, fl);
	} else if (targ.impulse == 87) {
		fl = IT_SANGUINATORS;
		gotgun = InModItems(targ, fl);
	} else if (targ.impulse == 88) {
		fl = IT_SCIMITAR;
		gotgun = InModItems(targ, fl);
	} else if (targ.impulse == 89) {
		fl = IT_RAPIER;
		gotgun = InModItems(targ, fl);
	} else if (targ.impulse == 47) {
		fl = IT_AIRGUN;
		inhackbank = TRUE; // Ok we are hacking now, switch to 2nd set of 24 weapons in bank 2
		gotgun = InPerms(targ, fl);
	}
	targ.impulse = 0; // Clear impulse
	if (!(gotgun)) { sprint(targ,"no weapon.\n"); return; } //Do we have this weapon?
	if (am) { sprint(targ,"not enough ammo.\n"); return; } //Do we have ammo?

	if (inhackbank) {
		targ.weaponismoditems = TRUE;
		if (fl == IT_ICE) {
			sprint(targ,"Blizzard Sphere!\n");
		} else {
			if (fl== IT_MACE) {
				sprint(targ,"Vampiric Mace!\n");
			} else {
				if (fl== IT_VOID_STAFF) {
					sprint(targ,"Void Staff!\n");
				} else {
					if (fl == IT_FLAK) {
						sprint(targ,"Flak Cannon!\n");
					} else {
						if (fl == IT_AIRGUN) {
							sprint(targ,"Air Fist!\n");
						} else {
							if (fl == IT_GUNGNIR) sprint(targ,"Gungnir!\n");
						}
					}
				}
			}
		}
	} else {
		targ.weaponismoditems = FALSE;
		if ( (targ.weapon != fl) ) {
		  if ( ((targ.weapon == IT_LAVA_NAILGUN) || (targ.weapon == IT_LAVA_SUPER_NAILGUN)) ) {
			 if ( ((fl == IT_NAILGUN) || (fl == IT_SUPER_NAILGUN)) ) {
				sprint(targ,"Normal Nails\n");
			 }
		  } else {
			 if ( (targ.weapon == IT_MULTI_GRENADE) ) {
				if ( (fl == IT_GRENADE_LAUNCHER) ) {
				   sprint(targ,"Normal Grenades\n");
				}
			 } else {
				if ( (targ.weapon == IT_MULTI_ROCKET) ) {
				   if (fl == IT_ROCKET_LAUNCHER) sprint(targ,"Normal Rockets\n");
				} else {
				   if ( (targ.weapon == IT_PLASMA_GUN) ) {
					  if ( (fl == IT_LIGHTNING) ) {
						 if (targ.moditems & IT_UPGRADE_LG) {
							sprint(targ,"Plasma Gun\n");
						 } else {
							sprint(targ,"Lightning Gun\n");
						 }
					  }
				   } else {
					  if ( ((fl == IT_LAVA_NAILGUN) || (fl == IT_LAVA_SUPER_NAILGUN)) ) {
						 sprint(targ,"Lava Nails!\n");
					  } else {
						 if ( (fl == IT_MULTI_GRENADE) ) {
							sprint(targ,"Multi-Grenades!\n");
						 } else {
							if ( (fl == IT_MULTI_ROCKET) ) {
							   sprint(targ,"Multi-Rockets!\n");
							} else {
							   if ( (fl == IT_PLASMA_GUN) ) {
								  sprint(targ,"Plasma Gun!\n");
							   } else {
								  if ( (fl == IT2_PROXIMITY_GUN) ) {
									 sprint(targ,"Proximity Grenades!\n");
								  } else {
									 if ( (fl == IT2_LASER_CANNON) ) {
										sprint(targ,"Laser Cannon!\n");
									 }  else {
										if ( (fl == IT2_WAND) ) {
											sprint(targ,"Magic Wand!\n");
										}  else {
											if ( (fl == IT2_MJOLNIR) ) {
												sprint(targ,"Mjolnir's Hammer!\n");
											} else {
												if ( (fl == IT_SANGUINATORS) ) {
													sprint(targ,"Sanguinators!\n");
												} else {
													if ( (fl == IT_SCIMITAR) ) {
														sprint(targ,"Fire Scimitar!\n");
													} else {
														if ( (fl == IT_RAPIER) ) sprint(targ,"Ghost Rapier!\n"); // Sharp if nest there, don't prick your eyes.
													}
												}
											}
										}
									 }
								  }
							   }
							}
						 }
					  }
				   }
				}
			 }
		  }
	   }
	}
	targ.weapon = fl;
	W_SetCurrentAmmo(targ,TRUE);
};

// Returns unique ID in list of weapon cycling order.  Refer to defskeep.qc for the list and ID's
float GetWepIDIndex (float wep, float inhackbank) = { // [FUNCTION]
	float retval;
	retval = 0;
	if (inhackbank) {
		if (wep == IT_MACE) 		retval = ID_MACE;
		if (wep == IT_ICE)			retval = ID_ICE;
		if (wep == IT_VOID_STAFF)	retval = ID_VOIDSTAFF;
		if (wep == IT_FLAK) 		retval = ID_FLAK;
		if (wep == IT_GUNGNIR) 		retval = ID_GUNGNIR;
		if (wep == IT_AIRGUN) 		retval = ID_AIRGUN;
	} else {
		if (wep == IT2_GRAPPLE) 			retval = ID_GRAPPLE;
		if (wep == IT_AXE)					retval = ID_AXE_SHADAXE_CHAINSAW;
		if (wep == IT_SHOTGUN)				retval = ID_SHOTGUN_BLASTER;
		if (wep == IT_SUPER_SHOTGUN)		retval = ID_SUPER_SHOTGUN_WIDOWMAKER_SHOTCYCLER_QUADSHOTTY;
		if (wep == IT_SCIMITAR)				retval = ID_SCIMITAR;
		if (wep == IT_NAILGUN)				retval = ID_NAILGUN;
		if (wep == IT_LAVA_NAILGUN)			retval = ID_LAVANAILGUN;
		if (wep == IT_RAPIER)				retval = ID_RAPIER;
		if (wep == IT_SUPER_NAILGUN)		retval = ID_PERFORATOR;
		if (wep == IT_LAVA_SUPER_NAILGUN)	retval = ID_LAVASUPERNAILGUN;
		if (wep == IT_GRENADE_LAUNCHER)		retval = ID_GRENADE_LAUNCHER;
		if (wep == IT2_PROXIMITY_GUN)		retval = ID_PROXIMITY_GRENADE;
		if (wep == IT_MULTI_GRENADE)		retval = ID_MULTI_GRENADE;
		if (wep == IT_ROCKET_LAUNCHER)		retval = ID_ROCKETLAUNCHER;
		if (wep == IT_MULTI_ROCKET)			retval = ID_MULTIROCKETLAUNCHER;
		if (wep == IT_SANGUINATORS)			retval = ID_SANGUINATORS;
		if (wep == IT_LIGHTNING)			retval = ID_THUNDERBOLT_AD_PLASMAGUN;
		if (wep == IT_PLASMA_GUN)			retval = ID_PLASMAGUN_ROGUE;
		if (wep == IT_CROSSBOW)			retval = ID_CROSSBOW;
		if (wep == IT2_LASER_CANNON)		retval = ID_LASER_CANNON;
		if (wep == IT2_CHAINLIGHTNING)		retval = ID_CHAINLIGHTNING;
		if (wep == IT2_WAND)				retval = ID_WAND;
		if (wep == IT2_MJOLNIR)				retval = ID_MJOLNIR;
	}
	return retval;
};

vector GetWepIT_FromID(float id) = { // [FUNCTION]
	local vector retval;

	retval = VEC_ORIGIN;
	if (id == ID_MACE ) 		{ retval_x = IT_MACE;			retval_y = TRUE; } // in hack bank
	if (id == ID_ICE )			{ retval_x = IT_ICE;			retval_y = TRUE; }
	if (id == ID_VOIDSTAFF )	{ retval_x = IT_VOID_STAFF;		retval_y = TRUE; }
	if (id == ID_FLAK ) 		{ retval_x = IT_FLAK;			retval_y = TRUE; }
	if (id == ID_GUNGNIR ) 		{ retval_x = IT_GUNGNIR;		retval_y = TRUE; }
	if (id == ID_AIRGUN ) 		{ retval_x = IT_AIRGUN;			retval_y = TRUE; }
	if (id == ID_GRAPPLE ) 				{ retval_x = IT2_GRAPPLE; retval_y = FALSE; }
	if (id == ID_AXE_SHADAXE_CHAINSAW )	{ retval_x = IT_AXE; retval_y = FALSE; }
	if (id == ID_SHOTGUN_BLASTER )		{ retval_x = IT_SHOTGUN; retval_y = FALSE; }
	if (id == ID_SUPER_SHOTGUN_WIDOWMAKER_SHOTCYCLER_QUADSHOTTY ) { retval_x = IT_SUPER_SHOTGUN; retval_y = FALSE; }
	if (id == ID_SCIMITAR )				{ retval_x = IT_SCIMITAR; retval_y = FALSE; }
	if (id == ID_NAILGUN )				{ retval_x = IT_NAILGUN; retval_y = FALSE; }
	if (id == ID_LAVANAILGUN )			{ retval_x = IT_LAVA_NAILGUN; retval_y = FALSE; }
	if (id == ID_RAPIER )				{ retval_x = IT_RAPIER; retval_y = FALSE; }
	if (id == ID_PERFORATOR )			{ retval_x = IT_SUPER_NAILGUN; retval_y = FALSE; }
	if (id == ID_LAVASUPERNAILGUN )		{ retval_x = IT_LAVA_SUPER_NAILGUN; retval_y = FALSE; }
	if (id == ID_GRENADE_LAUNCHER )		{ retval_x = IT_GRENADE_LAUNCHER; retval_y = FALSE; }
	if (id == ID_PROXIMITY_GRENADE )	{ retval_x = IT2_PROXIMITY_GUN; retval_y = FALSE; }
	if (id == ID_MULTI_GRENADE )		{ retval_x = IT_MULTI_GRENADE; retval_y = FALSE; }
	if (id == ID_ROCKETLAUNCHER )		{ retval_x = IT_ROCKET_LAUNCHER; retval_y = FALSE; }
	if (id == ID_MULTIROCKETLAUNCHER )	{ retval_x = IT_MULTI_ROCKET; retval_y = FALSE; }
	if (id == ID_SANGUINATORS )			{ retval_x = IT_SANGUINATORS; retval_y = FALSE; }
	if (id == ID_THUNDERBOLT_AD_PLASMAGUN) { retval_x = IT_LIGHTNING; retval_y = FALSE; }
	if (id == ID_PLASMAGUN_ROGUE )		{ retval_x = IT_PLASMA_GUN; retval_y = FALSE; }
	if (id == ID_CROSSBOW )				{ retval_x = IT_CROSSBOW; retval_y = FALSE; }
	if (id == ID_LASER_CANNON )			{ retval_x = IT2_LASER_CANNON; retval_y = FALSE; }
	if (id == ID_CHAINLIGHTNING )		{ retval_x = IT2_CHAINLIGHTNING; retval_y = FALSE; }
	if (id == ID_WAND )					{ retval_x = IT2_WAND; retval_y = FALSE; }
	if (id == ID_MJOLNIR )				{ retval_x = IT2_MJOLNIR; retval_y = FALSE; }
	return retval;
};

float(float wepID, vector idconversion, float am) SetCycledWeapon = {
	local float oktoset;

	idconversion = GetWepIT_FromID(wepID); // Return to normal IT_* number.
	self.weapon = idconversion_x;
	self.weaponismoditems = idconversion_y;

	// Has the player got the weapons and ammo to switch?
	if (self.weaponismoditems) {
		if (wepID == ID_MACE || wepID == ID_ICE
			|| wepID == ID_VOIDSTAFF || wepID == ID_FLAK
			|| wepID == ID_GUNGNIR) {
			if ((self.moditems & self.weapon) && !am) oktoset = TRUE;
		} else if (wepID == ID_AIRGUN) {
			if ((self.perms & self.weapon) && !am) oktoset = TRUE;
		}
	} else {
		if (wepID == ID_RAPIER) {
			if ((self.moditems & self.weapon) && !am) oktoset = TRUE;
		} else if (wepID == ID_SCIMITAR || wepID == ID_SANGUINATORS) {
			if ((self.moditems & self.weapon) && !am) oktoset = TRUE;
		} else if (wepID == ID_LASER_CANNON || wepID == ID_MJOLNIR
			|| wepID == ID_PROXIMITY_GRENADE || wepID == ID_WAND
			|| wepID == ID_GRAPPLE || wepID == ID_CHAINLIGHTNING) {
			if ((self.items2 & self.weapon) && !am) oktoset = TRUE;
		} else {
			if ((self.items & self.weapon) && !am) oktoset = TRUE;
		}
	}
	if (oktoset) { W_SetCurrentAmmo(self,TRUE); return TRUE; }
	return FALSE;
};

void() CycleWeaponCommand = { // [FUNCTION]
	local float	am, inhackbank, wepID, cyclecheck;
	local vector idconversion;
	
	if (detected_mod == MOD_ROGUE) EnableComboWeapons(other);
	inhackbank = FALSE;
	if (self.weaponismoditems) inhackbank = TRUE;
	if (frame_pause()) return;		// Remote camera active

	self.impulse = 0;			// reset impulse
	cyclecheck = 0; // counter to see how many times we go through the loop
	if (self.weapon == 0 && self.items == 0 && self.items2 == 0 && self.moditems == 0 && self.perms == 0) return;
	wepID = GetWepIDIndex(self.weapon, inhackbank);
	while (1) { // Keep cycling around weapon list until found a weapon with ammo
		am = 0;
		cyclecheck = cyclecheck + 1;
		if (cyclecheck > 100) return; // exit gracefully, no runaway loop error

		if (wepID == ID_AXE_SHADAXE_CHAINSAW) {
			wepID = ID_GRAPPLE;
		} else if (wepID == ID_GRAPPLE) {
			wepID = ID_MACE;
		} else if (wepID == ID_MACE) {
			wepID = ID_SHOTGUN_BLASTER;
			if (self.ammo_shells < 1) am = 1;
		} else if (wepID == ID_SHOTGUN_BLASTER) {
			wepID = ID_ICE;
			if (self.ammo_elemental < 1) am = 1;
		} else if (wepID == ID_ICE) {
			wepID = ID_AIRGUN;
		} else if (wepID == ID_AIRGUN) {
			wepID = ID_SUPER_SHOTGUN_WIDOWMAKER_SHOTCYCLER_QUADSHOTTY;
			if (self.ammo_shells < 1) am = 1; // only checking for 1 shell since autoshotgun/shotcycler might only use 1
		} else if (wepID == ID_SUPER_SHOTGUN_WIDOWMAKER_SHOTCYCLER_QUADSHOTTY) {
			wepID = ID_SCIMITAR;
		} else if (wepID == ID_SCIMITAR) {
			wepID = ID_NAILGUN;
			if (self.ammo_nails < 1) am = 1;
		} else if (wepID == ID_NAILGUN) {
			wepID = ID_LAVANAILGUN;
			if (self.ammo_lava_nails < 2) am = 1;
		} else if (wepID == ID_LAVANAILGUN) {
			wepID = ID_RAPIER;
			if (self.ammo_bloodcrystals < 1) am = 1;
		} else if (wepID == ID_RAPIER) {
			wepID = ID_PERFORATOR;
			if (self.ammo_nails < 2) am = 1;
		} else if (wepID == ID_PERFORATOR) {
			wepID = ID_LAVASUPERNAILGUN;
			if (self.ammo_lava_nails < 2) am = 1;
		} else if (wepID == ID_LAVASUPERNAILGUN) {
			wepID = ID_VOIDSTAFF;
			if (self.ammo_voidshards < 1) am = 1;
		} else if (wepID == ID_VOIDSTAFF) {
			wepID = ID_GRENADE_LAUNCHER;
			if (self.ammo_rockets < 1) am = 1;
		} else if (wepID == ID_GRENADE_LAUNCHER) {
			wepID = ID_PROXIMITY_GRENADE;
			if (self.ammo_rockets < 1) am = 1;
		} else if (wepID == ID_PROXIMITY_GRENADE) {
			wepID = ID_MULTI_GRENADE;
			if (self.ammo_multi_rockets < 1) am = 1;
		} else if (wepID == ID_MULTI_GRENADE) {
			wepID = ID_ROCKETLAUNCHER;
			if (self.ammo_rockets < 1) am = 1;
		} else if (wepID == ID_ROCKETLAUNCHER) {
			wepID = ID_MULTIROCKETLAUNCHER;
			if (self.ammo_multi_rockets < 1) am = 1;
		} else if (wepID == ID_MULTIROCKETLAUNCHER) {
			wepID = ID_SANGUINATORS;
			if (self.ammo_bloodcrystals < 1) am = 1;
		} else if (wepID == ID_SANGUINATORS) {
			wepID = ID_THUNDERBOLT_AD_PLASMAGUN;
			if (self.ammo_cells < 1) am = 1;
		} else if (wepID == ID_THUNDERBOLT_AD_PLASMAGUN) {
			wepID = ID_PLASMAGUN_ROGUE;
			if (self.ammo_plasma < 1) am = 1;
		} else if (wepID == ID_PLASMAGUN_ROGUE) {
			wepID = ID_FLAK;
			if (self.ammo_rockets < FLAK_ROCKETUSAGE || self.ammo_nails < FLAK_NAILUSAGE) am = 1; // Flak uses multiple nails & rockets per shot
		} else if (wepID == ID_FLAK) {
			wepID = ID_CROSSBOW;
			if (self.ammo_bolts < 1 && self.ammo_poison < 1) am = 1;
		} else if (wepID == ID_CROSSBOW) {
			wepID = ID_LASER_CANNON;
			if (self.ammo_cells < 1) am = 1;
		} else if (wepID == ID_LASER_CANNON) {
			wepID = ID_CHAINLIGHTNING;
			if (self.ammo_cells < 1) am = 1;
		} else if (wepID == ID_CHAINLIGHTNING) {
			wepID = ID_MJOLNIR;
		} else if (wepID == ID_MJOLNIR) {
			wepID = ID_WAND;
		} else if (wepID == ID_WAND) {
			wepID = ID_GUNGNIR;
			if (self.ammo_voidshards < 1) am = 1;
		} else if (wepID == ID_GUNGNIR) {
			wepID = ID_AXE_SHADAXE_CHAINSAW;
		}

		if (wepID == FALSE) return; // prevent crash in "cinematic mode"

		if (SetCycledWeapon(wepID,idconversion,am)) return;
	}
};

void() CycleWeaponReverseCommand = { // [FUNCTION]
	local float	am, inhackbank, wepID, cyclecheck;
	local vector idconversion;
	
	if (detected_mod == MOD_ROGUE) EnableComboWeapons(other);
	inhackbank = FALSE;
	if (self.weaponismoditems) inhackbank = TRUE;
	if (intermission_running > 0) return;		// intermission or finale
	if (cinematic_running > 0) return;		// Remote camera active
	self.impulse = 0;			// reset impulse
	cyclecheck = 0; // counter to see how many times we go through the loop
	if (self.weapon == 0 && self.items == 0 && self.items2 == 0 && self.moditems == 0 && self.perms == 0) return;
	wepID = GetWepIDIndex(self.weapon, inhackbank);

	// Keep cycling around weapon list until found a weapon with ammo
	while (1) {
		am = 0;
		cyclecheck = cyclecheck + 1;
		if (cyclecheck > 100) return; // exit gracefully, no runaway loop error
		if (wepID == ID_GUNGNIR) {
			wepID = ID_WAND;
		} else if (wepID == ID_WAND) {
			wepID = ID_MJOLNIR;
		} else if (wepID == ID_MJOLNIR) {
			wepID = ID_CHAINLIGHTNING;
			if (self.ammo_cells < 1) am = 1;
		} else if (wepID == ID_CHAINLIGHTNING) {
			wepID = ID_LASER_CANNON;
			if (self.ammo_cells < 2) am = 1;
		} else if (wepID == ID_LASER_CANNON) {
			wepID = ID_CROSSBOW;
			if (self.ammo_bolts < 1 && self.ammo_poison < 1) am = 1;
		} else if (wepID == ID_CROSSBOW) {
			wepID = ID_FLAK;
			if (self.ammo_rockets < FLAK_ROCKETUSAGE || self.ammo_nails < FLAK_NAILUSAGE) am = 1; // Flak uses multiple nails & rockets per shot
		} else if (wepID == ID_FLAK) {
			wepID = ID_PLASMAGUN_ROGUE;
			if (self.ammo_plasma < 1) am = 1;
		} else if (wepID == ID_PLASMAGUN_ROGUE) {
			wepID = ID_THUNDERBOLT_AD_PLASMAGUN;
			if (self.ammo_cells < 1) am = 1;
		} else if (wepID == ID_THUNDERBOLT_AD_PLASMAGUN) {
			wepID = ID_SANGUINATORS;
			if (self.ammo_bloodcrystals < 1) am = 1;
		} else if (wepID == ID_SANGUINATORS) {
			wepID = ID_MULTIROCKETLAUNCHER;
			if (self.ammo_multi_rockets < 1) am = 1;
		} else if (wepID == ID_MULTIROCKETLAUNCHER) {
			wepID = ID_ROCKETLAUNCHER;
			if (self.ammo_rockets < 1) am = 1;
		} else if (wepID == ID_ROCKETLAUNCHER) {
			wepID = ID_MULTI_GRENADE;
			if (self.ammo_multi_rockets < 1) am = 1;
		} else if (wepID == ID_MULTI_GRENADE) {
			wepID = ID_PROXIMITY_GRENADE;
			if (self.ammo_rockets < 1) am = 1;
		} else if (wepID == ID_PROXIMITY_GRENADE) {
			wepID = ID_GRENADE_LAUNCHER;
			if (self.ammo_rockets < 1) am = 1;
		} else if (wepID == ID_GRENADE_LAUNCHER) {
			wepID = ID_VOIDSTAFF;
			if (self.ammo_voidshards < 1) am = 1;
		} else if (wepID == ID_VOIDSTAFF) {
			wepID = ID_LAVASUPERNAILGUN;
			if (self.ammo_lava_nails < 2) am = 1;
		} else if (wepID == ID_LAVASUPERNAILGUN) {
			wepID = ID_PERFORATOR;
			if (self.ammo_nails < 2) am = 1;
		} else if (wepID == ID_PERFORATOR) {
			wepID = ID_RAPIER;
			if (self.ammo_bloodcrystals < 1) am = 1;
		} else if (wepID == ID_RAPIER) {
			wepID = ID_LAVANAILGUN;
			if (self.ammo_lava_nails < 1) am = 1;
		} else if (wepID == ID_LAVANAILGUN) {
			wepID = ID_NAILGUN;
			if (self.ammo_nails < 1) am = 1;
		} else if (wepID == ID_NAILGUN) {
			wepID = ID_SCIMITAR;
		} else if (wepID == ID_SCIMITAR) {
			wepID = ID_SUPER_SHOTGUN_WIDOWMAKER_SHOTCYCLER_QUADSHOTTY;
			if (self.ammo_shells < 1) am = 1; // only checking for 1 shell since autoshotgun/shotcycler might only use 1
		} else if (wepID == ID_SUPER_SHOTGUN_WIDOWMAKER_SHOTCYCLER_QUADSHOTTY) {
			wepID = ID_AIRGUN;
		} else if (wepID == ID_AIRGUN) {
			wepID = ID_ICE;
			if (self.ammo_elemental < 1) am = 1;
		} else if (wepID == ID_ICE) {
			wepID = ID_SHOTGUN_BLASTER;
			if (self.ammo_shells < 1) am = 1;
		} else if (wepID == ID_SHOTGUN_BLASTER) {
			wepID = ID_MACE;
		} else if (wepID == ID_MACE) {
			wepID = ID_GRAPPLE;
		} else if (wepID == ID_GRAPPLE) {
			wepID = ID_AXE_SHADAXE_CHAINSAW;
		} else if (wepID == ID_AXE_SHADAXE_CHAINSAW) {
			wepID = ID_GUNGNIR;
			if (self.ammo_voidshards < 1) am = 1;
		}

		if (wepID == FALSE) return; // prevent crash in "cinematic mode"

		if (SetCycledWeapon(wepID,idconversion,am)) return;
	}
};

void(float gibDeath) Cheat_KillRay = { // [FUNCTION]
	local float dmg;
	local vector src, dir, vel, org;

	if (self.attack_finished > time) return;

	if (gibDeath) sound(self,CHAN_WEAPON,"tronyn/lightning_blast.wav",1,ATTN_NORM);
	else sound(self,CHAN_WEAPON,"tronyn/lightning_strike.wav",1,ATTN_NORM);
	
	self.effects = self.effects | EF_MUZZLEFLASH;
	W_Reload(0.5);
	self.punchangle_x = -2;
	makevectors(self.v_angle);
	dir = normalize(v_forward * SPEED_PLAYAIM);
	src = self.origin + v_forward*10;
	traceline(src,src + dir * 2048,FALSE,self);
	if (trace_fraction != 1.0) {
		vel = normalize(dir + v_up*crandom() + v_right*crandom());
		vel = vel + 2*trace_plane_normal;
		vel = vel * 200;
		org = trace_endpos - dir*4;
		if (!InSky(org)) { // Check for sky content? skies don't impact or bleed
			if (trace_ent && trace_ent != world) {
				if (trace_ent.takedamage) {
					dmg = trace_ent.health + 1;
					if (gibDeath) dmg = dmg - trace_ent.gibhealth + 1;
					if (trace_ent.flags & FL_MONSTER) SpawnBlood(trace_ent,org + (crandom() * 4 * '1 1 1'),vel*0.2,dmg*2,0); // Hitting monsters does twice the amount of blood effects
					else SpawnBlood(trace_ent,org + (crandom() * 4 * '1 1 1'),vel*0.2,dmg,0);

					if (trace_ent.vulnerability > 0) trace_ent.vulnerability = 0;
					T_Damage(trace_ent,self,self,dmg,DAMARMOR);
					if (trace_ent.classtype == CT_TARGETDUMMY) MarkAttack(org, trace_ent.wait); // Check for target dummy (manually create marker)
				} else Tent_Point(TE_GUNSHOT,org); // Hit something that does not bleed (often world)
			} else Tent_Point(TE_GUNSHOT,org); // Hit something that does not bleed (often world)
		}
	} 
};

void() W_WeaponFrame = { // [FUNCTION]
	if (self.lavaGunFired) {
		if (self.weapon == IT_LAVA_NAILGUN || self.weapon == IT_LAVA_SUPER_NAILGUN) {
			sound(self,CHAN_BODY,"rogue/weapons/snail.wav",1,ATTN_NORM); // Hiss!
		}
		self.lavaGunFired = 0;
	}

	if (time < self.attack_finished) {
		if (!self.button0) {
			if (!self.b0_click) self.b0_click = 1; // Released button.
		}
		return;
	}

	ImpulseCommands();
	if (self.ammo_poison > 0) W_SetCurrentAmmo(self,FALSE); // Change crossbow skin if bolts are poisoned
	if (!self.button0) return; // check for attack

	if (self.b0_click) self.b0_click = 2; // Just double-clicked.
	if (self.super_damage_finished > 0 && self.powerup_sound < time) { // Only play one powerup sound at once
		if (self.super_sound < time) {
			self.super_sound = time + 1;
			self.powerup_sound = time + 1;
			sound(self,CHAN_BODY,SOUND_ARTQUAD3,1,ATTN_NORM);
		}
	}
	
	if (self.sharpshoot_finished > 0 && self.powerup_sound < time) { // Only play one powerup sound at once
		if (self.weapon == IT_SHOTGUN || self.weapon == IT_SUPER_SHOTGUN) { // Only works with the shotguns
			if (self.sharpshooter_sound < time) {
				self.sharpshooter_sound = time + 0.5;
				self.powerup_sound = time + 1; // Only play the sound every other shot
				sound(self,CHAN_BODY,SOUND_ARTSHARP3,1,ATTN_NORM);
			}
		}
	}

	if (self.nailpiercer_finished > 0 && self.powerup_sound < time) { // Only play one powerup sound at once
		// Only works with nailgun + super nailgun
		if (self.weapon == IT_NAILGUN || self.weapon == IT_SUPER_NAILGUN) {
			if (self.nailpiercer_sound < time) {
				self.nailpiercer_sound = time + 0.5;
				self.powerup_sound = time + 1;
				sound(self,CHAN_BODY,SOUND_ARTNAILP3,1,ATTN_NORM);
			}
		}
	}
	// Check for weapon updates
	if (cheatflags & CHEAT_GIBGUN) {
		Cheat_KillRay(1);
	} else if (cheatflags & CHEAT_KILLGUN) {
		Cheat_KillRay(0);
	} else {
		W_Attack();
	}
};

//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
//
// Attributions: All, see credits folder
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
// Entity count: 1
// Function count: 11
//
// Implements: Damage application and calculations, direct and radius
//
// Description:
// All damage is applied through T_Damage here.  Damage calculations are also
// all done here except for the ammo resistances which are in ai_ammoresist.qc.
//=============================================================================

void(entity targ, entity attacker) ClientObituary;
void(entity victim, entity attacker, float burn) Burn_Add;
void(entity targ, float jump, float destroy) TakeTargetOutOfVehicle;

float(entity targ, entity inflictor) CanDamage = {
	if (targ.takedamage == DAMAGE_NO) return FALSE; // Any entity marked with no damage is automatically excluded
	
	if (targ.movetype == MOVETYPE_PUSH) { // bmodels need special checking because their origin is 0,0,0
		traceline(inflictor.origin, 0.5 * (targ.absmin + targ.absmax), TRUE, inflictor);
		if (trace_fraction == 1) return TRUE;
		if (trace_ent == targ) return TRUE;
		return FALSE;
	}
	
	// Trace around the target to see if it can hit
	traceline(inflictor.origin, targ.origin, TRUE, inflictor);
	if (trace_fraction == 1) return TRUE;
	traceline(inflictor.origin, targ.origin + '15 15 0', TRUE, inflictor);
	if (trace_fraction == 1) return TRUE;
	traceline(inflictor.origin, targ.origin + '-15 -15 0', TRUE, inflictor);
	if (trace_fraction == 1) return TRUE;
	traceline(inflictor.origin, targ.origin + '-15 15 0', TRUE, inflictor);
	if (trace_fraction == 1) return TRUE;
	traceline(inflictor.origin, targ.origin + '15 -15 0', TRUE, inflictor);
	if (trace_fraction == 1) return TRUE;

	

	return FALSE; // Couldn't hit
};

// --> QUAKED trigger_victory (.5 .5 .5) (-8 -8 -8) (8 8 8)
// Drake entity.
// Only be fired by killing the last monster on a level (i.e., 100% kills).
// It can contain killtargets, targets, delays, and messages.
void() trigger_victory = {};

void(entity targ) AddToTotals = {
	if (targ.classtype == CT_MONANACONDACOIL) return; // The coils are part of monster_anaconda

	if (targ.classgroup == CG_HARMLESS) {
		total_denizens = total_denizens + 1;
		targ.xfl = targ.xfl | XFL_PET; // Denizens don't add to frags
	} else {
		total_monsters = total_monsters + 1;
		targ.xfl = targ.xfl | XFL_ADD_TO_KILL; // Added here.  Some monsters have special clones, like monster_bane that don't add to either count
	}
	update_hud_totals(HUD_MONSTERS);
};

float(entity e, float heal, float ignore) T_Repair;

void(entity thekilled, entity attacker) AddToKills = {
    local entity victory, swap;

    if (thekilled.xfl & XFL_ADD_TO_KILL && self.classtype != CT_MONANACONDACOIL) { // Marked as a countable enemy
        // thekilled.xfl = thekilled.xfl - XFL_ADD_TO_KILL;  // Count only once.  -Qmaster: Nope.  Well, we might have been revived alright, monster_revive should add to the count by 1.
        killed_monsters = killed_monsters + 1;
		if (killed_monsters > total_monsters) total_monsters = killed_monsters; // Just in case!
        WriteByte (MSG_ALL, SVC_KILLEDMONSTER);

		// Apply any benefits to the thing that killed us
		if (attacker) {
			// Update 5/14/10:  Kills recharge demonhide armor.
			if (attacker.perms & POW_ARMORBERSERKER) T_Repair(attacker,attacker.armortype * 10,TRUE); // Repair armor up to 250.  Note to hackers, good way to have monsters heal themselves when infighting other monsters. -Qmaster

			// SoE:  Killing monsters adds to frags.  And in Versus mode. -Qmaster
			if (attacker.flags & FL_CLIENT) {
				if (deathmatch || (coop > 2 && attacker.versustype != VT_GAMEMASTER)) attacker.frags = attacker.frags + 1;
			}
		}

		// PM:  Activate 'all clear' triggers at 100% kills.
        if (killed_monsters == total_monsters) { // Just reached 100% kills.
            victory = find (world, classname, "trigger_victory");
			swap = self;
			self = thekilled;
            while(victory) {
                activator = attacker;
				SUB_UseTargets();
				victory = find(victory, classname, "trigger_victory");
            }
			self = swap;
        }
    } else if (thekilled.xfl & XFL_PET) {
		killed_denizens = killed_denizens + 1;
		if (killed_denizens > total_denizens) total_denizens = killed_denizens; // Just in case!

		// Apply any benefits to the thing that killed us
		if (attacker) {
			// Update 5/14/10:  Kills recharge demonhide armor.
			if (attacker.perms & POW_ARMORBERSERKER) T_Repair(attacker,attacker.armortype * 10,TRUE); // Repair armor up to 250.  Note to hackers, good way to have monsters heal themselves when infighting other monsters. -Qmaster

			// SoE:  Killing monsters adds to frags.  And in Versus mode if we are gamemasters. -Qmaster
			if (attacker.flags & FL_CLIENT) {
				if (deathmatch || (coop > 2 && attacker.versustype == VT_GAMEMASTER)) attacker.frags = attacker.frags + 1;
			}
		}
	}
};

void(entity targ, entity attacker) T_Freeze;

void(entity targ, entity attacker) Killed = {
	local entity oself;

	oself = self; self = targ; // Switch self for death functions
	self.activate = attacker; // Always keep track of what did damage

	// doors, triggers, etc
	if (self.movetype == MOVETYPE_PUSH || self.movetype == MOVETYPE_NONE || self.classtype == CT_FUNCPUSHABLE) {	
		self.th_die();
	} else {
		if (!self.deadflag && (self.flags & FL_MONSTER || self.flags & FL_CLIENT) ) {
			self.tethered = FALSE;
			self.tetherfocus = world;
			self.deadflag = DEAD_DYING; // Object is dying, stop re-triggering
			self.enemy = attacker;	// Enemy dealing final blow
			if (self.enemy.classtype == CT_WORLD) self.enemy = self;	
			if ((self.flags & FL_MONSTER) && !self.nomonstercount) AddToKills(self,attacker); // bump the monster counter
			ClientObituary(self, attacker);
			self.touch = SUB_Null;
			if (self.flags & FL_MONSTER) monster_death_use();
			if (self.frozen) T_Freeze(self, attacker);
			else self.th_die ();
		} else if (!self.deadflag && self.classtype == CT_MONIDSHUB) {
			// Completely messed up setup for the oldone boss with a weird target field and mess of triggers around it! This elseif is just an exception so it works, anyway no one fights the oldone!
			self.deadflag = DEAD_DEAD;
			if ((self.flags & FL_MONSTER) && !self.nomonstercount) AddToKills(self,attacker);
			if (self.frozen) { T_Freeze(self, attacker); monster_death_use(); }
			else self.th_die ();
		}
	}
	self = oself; // Restore self
};

float(entity targ, float damage, float drain) PowerArmor_Absorb;

// All damage runs through here at some point or another.
// Applies damage to a target after first checking for any boosts or
// reductions from armor, powerups, etc.
//
// The damage is coming from inflictor, but get mad at attacker
// This should be the only function that ever reduces health.
//
// Parameters:
// targ = entity receiving damage (monster)
// inflictor = entity causing damage (bullets)
// attacker = parent entity of inflictor (player firing bullets)
// damage = quantity (before modifiers, quad etc)
// checkarmor = can bypass armour (DAMARMOR, NOARMOR, DAMSPLASH)
// DAMARMOR    - Typical damage to health + armour
// NOARMOR     - Ingnores armour for damage reduction
// DAMSPLASH   - Splash damage only
// ======================================================================
void(entity targ, entity inflictor, entity attacker, float damage, float checkarmor) T_Damage = {
	local float save, saveperms, take, flinch, misc, noarmordmg, adamant, oldarmorvalue, saveresist;
	local vector dir;
	local entity oldself;

	// Cannot hurt the world or enemy targets (fake flying markers)
	if (targ.classtype == CT_WORLD) return;
	if (targ.classtype == CT_ENEMYTARGET) return;

	if (targ.in_a_vehicle) {
		take = (damage * 0.25);
		if (targ.health - take <= 0) {
			TakeTargetOutOfVehicle(self.bmodel_act,TRUE,TRUE); // Jump, destroy car
			return;
		}
		targ.health = targ.health - take;
		return;
	}

	if (targ.items2 & IT2_MJOLNIR && targ.weapon == IT2_MJOLNIR && !targ.selfweaponismoditems && (inflictor.classgroup == CG_PROJCELLS || inflictor.classgroup == CG_PROJPLASMAROGUE || attacker.classtype == CT_MONSHAM || attacker.classtype == CT_MONGAUNT)) damage = damage * 0.5; // 50% lightning protection while holding mjolnir

	// resist_fire is the odd one out here. There were too many edge cases not handled by classgroups so they exist in individual locations

	if (attacker.poisonous || inflictor.poisonous) {
		if (targ.resist_acid > 0) damage = Resist_Damage(targ, AM_ACID, damage);
	}

	if (inflictor.classgroup == CG_PROJCELLS) {
		if (targ.resist_cells > 0) damage = Resist_Damage(targ, AM_CELLS, damage);
	}

	if (inflictor.classgroup == CG_PROJROCKETS || inflictor.classgroup == CG_PROJGRENADES) {
		if (targ.resist_rockets > 0) damage = Resist_Damage(targ, AM_ROCKETS, damage);
	}

	if (inflictor.classgroup == CG_PROJSHELLS) {
		if (targ.resist_shells > 0) damage = Resist_Damage(targ, AM_SHELLS, damage);
	}

	if (inflictor.classgroup == CG_PROJNAILS) {
		if (targ.resist_nails > 0) damage = Resist_Damage(targ, AM_NAILS, damage);
	}

	if (inflictor.classgroup == CG_PROJLAVANAILS) {
		if (targ.resist_lava_nails > 0) damage = Resist_Damage(targ, AM_LAVANAILS, damage);
	}

	if (inflictor.classgroup == CG_PROJMULTIROCKETS) {
		if (targ.resist_multi_rockets > 0) damage = Resist_Damage(targ, AM_MULTI_ROCKETS, damage);
	}

	if (inflictor.classgroup == CG_PROJPLASMAROGUE) {
		if (targ.resist_plasma > 0) damage = Resist_Damage(targ, AM_PLASMA, damage);
	}

	if (inflictor.classgroup == CG_PROJBOLTS) {
		if (targ.resist_bolts > 0) damage = Resist_Damage(targ, AM_BOLTS, damage);
	}

	if (inflictor.classgroup == CG_PROJBOLTSPOISON) {
		if (targ.resist_poison > 0) damage = Resist_Damage(targ, AM_POISON, damage);
	}

	if (inflictor.classgroup == CG_PROJBLOODCRYSTALS) {
		if (targ.resist_bloodcrystals > 0) damage = Resist_Damage(targ, AM_BLOODCRYSTALS, damage);
	}

	if (inflictor.classgroup == CG_PROJVOID) {
		if (targ.resist_voidshards > 0) damage = Resist_Damage(targ, AM_VOIDSHARDS, damage);
	}

	if (inflictor.classgroup == CG_PROJMAGIC) {
		if (targ.resist_elemental > 0) damage = Resist_Damage(targ, AM_ELEMENTAL, damage);
	}

	if (inflictor.classgroup == CG_PROJICE) {
		if (targ.resist_cold > 0) damage = Resist_Damage(targ, AM_COLD, damage);
	}

	// Is the monster dying and going through death animation?
	if (targ.flags & FL_MONSTER && targ.health < 1) {
		if (targ.health > targ.gibhealth) {
			// SSG projectiles need to do more damage (higher chance of gib)
			if (inflictor.classtype == CT_PROJ_SSG) take = 1 + random()*0.25;
			// Lowered the chance of extra gibs from other weapons
			// way to much gibbing was happening to all monsters
			else take = 1;
			
			// Keep taking health off after death
			targ.health = targ.health - (ceil(damage)*take);
		}
		return;
	}

	if (targ.takedamage == DAMAGE_NO) return; // If target cannot take damage, no point doing damage

	damage_attacker = attacker; // used by buttons and triggers to set activator for target firing

	if (attacker.super_damage_finished > 0 && targ.classtype != CT_MONINQUISITOR) {
		damage = ceil(damage * 4); // check for quad damage powerup on the attacker
		if (self.dmg == 18 && self.buddy) {self.buddy.dmg = 0; dprint("Nerfed a buddy nail\n");} // Nerf double copper super nails, last one there is a rotten egg! Allows for both to start at 18 and get quadded up to gib a zombie.
	}
	if (attacker.curse_type == CURSE_WEAKEN) damage = damage * 0.5;
	if (targ.spirit_blessed) damage = damage * 0.25; // 25% Protection of the Watchers from Spirit Shrine desecration
	if (attacker.shroom_finished > time) damage = damage * 1.5; // 50% damage boost when shroomed up!
	if (targ.shroom_finished > time) damage = damage * 0.5; // 50% damage protection when shroomed up!

	// Berserker Helm melee damage boost, Drake permanent powerup
	if ((attacker.perms & POW_VAMPIRE) || (attacker.shroom_finished > time)) {
		if (attacker.selfweaponismoditems) {
			if (attacker.weapon == IT_MACE) damage = damage * 2;
		} else {
			if (attacker.weapon == IT_AXE || attacker.weapon == IT2_MJOLNIR || attacker.weapon == IT_SCIMITAR || attacker.weapon == IT_RAPIER) damage = damage * 2;
		}
	}

	if (targ.classtype == CT_MONDLORD && targ.shield == 1) damage = damage * 0.5; // Death Lord from Quoth puts up his shield.

	// co-op team play damage avoidance
	if ( (teamplay == 1) && (targ.team > 0) && (targ.team == attacker.team) ) return;

	// Poor zombies, they have so many exceptional ways to die!
	if (targ.classgroup == CG_ZOMBIE && targ.classtype != CT_MONMUMMY) {
		if (targ.watertype == CONTENT_SLIME) { // If a zombie falls into slime or lava, instant death
			damage = fabs(targ.gibhealth * 4); // gib health is usually negative, hence the fabs
			damage = damage * (1-targ.resist_acid);
		}
		if (targ.watertype == CONTENT_LAVA) {
			damage = fabs(targ.gibhealth * 4); // gib health is usually negative, hence the fabs
			damage = damage * (1-targ.resist_fire);
		}
		if (attacker.classtype == CT_MONBOIL) damage = fabs(targ.gibhealth * 2); // Exploding boils always destroy zombies
	}
	
	// Are monsters infighting and is there a damage modifier active?
	if (attacker.infightextra && targ.flags & FL_MONSTER) damage = ceil(damage * attacker.infightextra);

	// Check for plasma burn/explosion on fatal hit
	if (inflictor.classtype == CT_PROJ_PLASMA && attacker.flags & FL_CLIENT) {
		if ((targ.health-damage < 0) && attacker.plasma_burn < time && random() < 0.2) {
			attacker.plasma_burn = time + 4 + random()*4; // Stop the plasma burn effect not happening alot at once
			if (attacker.super_damage_finished == 0) damage = (targ.health - targ.gibhealth); // Don't add anymore damage if quad active
			particle_explode(targ.origin-'0 0 16', 50+random()*50, 2, PARTICLE_BURST_BLUE, PARTICLE_BURST_UPWARD);
			SpawnExplosion(EXPLODE_PLASMA_BIG, inflictor.origin+'0 0 8', SOUND_REXP3); // Big blue sprite explosion + particles
		} 
	}

	if (Align_Match(attacker,targ)) {
		if (targ.vulnerability == VULN_SERAPHIC || (targ.vulnerability == VULN_UNDEAD && targ.classname == attacker.classname)) return; // Seraphic allies don't hurt each other
		if (targ.vulnerability == VULN_RESISTANT) damage = damage * 0.5; // 50% damage when resistant
	}

	damage = Align_DamageModifier(targ,attacker,damage,FALSE); // False because we don't know if this is a touch 
	if (!damage) return; // Nothing to do!

	if (targ.classtype == CT_MONBANE && targ.classtype == attacker.classtype) {
        if (Ally_Check (targ, attacker)) return;     // Bane can't hurt himself and his clones.
	}

	// Check for monster/breakable extra damage key condition
	// The key is usually checked with ai_damagebreakable function
	// Needs to be checked with projectiles as well
	if (targ.classgroup == CG_BREAKABLE && attacker.flags & FL_MONSTER) {
		if (targ.brkmondmg > 0) damage = ceil(damage + targ.brkmondmg);
	}
	
	// Blast Belt resistance prevents armour being decreased
	if (checkarmor == DAMSPLASH && targ.flags & FL_CLIENT && targ.moditems & IT_ARTBLASTBELT) noarmordmg = TRUE;
	else noarmordmg = FALSE; // Default for any kind of damage through this function

	// Special artifact combo setups for extra abilities:
	// Blast Belt + Quad reduces incoming damage by 50%
	if (targ.flags & FL_CLIENT && targ.moditems & IT_ARTBLASTBELT && targ.items & IT_QUAD) damage = ceil(damage * 0.5);

	// Lava Shield + Pentagram prevents armour from being damaged
	if (targ.flags & FL_CLIENT && targ.moditems & IT_ARTLAVASHIELD && targ.items & IT_INVULNERABILITY) noarmordmg = TRUE;	

	// save damage based on the target's armor level
	save = 0;
	saveperms = 0;
	adamant = 0;
	oldarmorvalue = targ.armorvalue;
	adamant = (targ.perms & POW_ARMORONYX) || (targ.perms & POW_ARMORONYXPOWER) || (targ.perms & POW_ARMORBERSERKER);

	if (checkarmor == DAMARMOR || checkarmor == DAMSPLASH) {
		// Normal armor handling, armor 1, 2, and inv(3) --------------
		save = ceil(targ.armortype*damage);
		if (save >= targ.armorvalue) { // Run out of amour?
			save = targ.armorvalue; // Use remaining armour
			if (noarmordmg == FALSE) { // If no armour block, remove armour
				targ.armortype = 0;	// lost all armor
				targ.items2 = targ.items2 - (targ.items2 & (IT2_ARMOR1 | IT2_ARMOR2 | IT2_ARMOR3));
			}
		}
		// Reduce armour based on save forumla above
		if (noarmordmg == FALSE) targ.armorvalue = targ.armorvalue - save;

		// CEIL function will round up any fractional damage
		// TBH it is better to round up than round down
		take = ceil(damage-save);
		// End normal armor handling ----------------------------------

		// Power Armor
		if (targ.perms & POW_ARMORONYX) take = ceil(take * 0.5);

		// Power Armor
		if (targ.perms & POW_ARMORONYXPOWER) {
			if (targ.powershield_active) {
				if (targ.ammo_cells > 1) {
					saveperms = PowerArmor_Absorb(targ,take,TRUE); // only does something if damage is greater than 2
				} else {
					targ.powershield_active = FALSE;
					sound (targ, CHAN_AUTO, "zerstorer/me/me_soff.wav", 1, ATTN_NORM);
				}
			}
		}
		take = ceil(take-saveperms);

		// Courage Armor
		if (targ.perms & POW_ARMORCOURAGE) {
			if (UseCourage(targ,inflictor.origin)) {
				saveperms = ceil(ARMOR_COURAGE_TYPE*take); // Apply another armor reduction
			}
		}
		take = ceil(take-saveperms);

		// Chaos Armor (does more when armor is high and health is low, really helps when almost dead)
		if (targ.perms & POW_ARMORCHAOS) {
			if ((targ.health/targ.max_health) < 0.5) saveperms = 0.25;
			else saveperms = 0.10;
			saveperms = ceil (saveperms * take);
		}
		take = ceil(take-saveperms);
	} else take = damage; // Damage bypasses all armor (NOARMOR)

	// Add to the damage total for clients, which will be sent as a single message at the end of the frame
	if (targ.flags & FL_CLIENT) {
		targ.dmg_take = targ.dmg_take + take;
		targ.dmg_save = targ.dmg_save + save;
		targ.dmg_inflictor = inflictor;
	}

	// figure momentum add
	// This is what gives Rocket Jumps its Velocity!
	if (inflictor && targ && (targ.movetype == MOVETYPE_WALK || (targ.flags & FL_CLIENT))) {
		dir = targ.origin - (inflictor.absmin + inflictor.absmax) * 0.5;
		dir = normalize(dir);
		dir = dir*damage*8;
		if (targ.mass == MASS_SUPER) dir = dir*0.5; // Harder to shove.
		damage_velocity = dir;
		targ.velocity = targ.velocity + dir;

		// Wand knockback
		if (attacker.weapon == IT2_CROSS && !attacker.selfweaponismoditems || attacker.tome_finished) {
			float z_add = 150;
			if (attacker.tome_finished) z_add = z_add * 2;
			if (targ.mass == MASS_SUPER) z_add = z_add * 0.5;
			targ.flags = targ.flags - FL_ONGROUND;
			targ.velocity = targ.velocity + dir;
			if (targ.velocity_z < z_add) targ.velocity_z = z_add;	
		}
	}

	// Check for Blast Belt 100% splashdamage resistance
	if (checkarmor == DAMSPLASH && targ.flags & FL_CLIENT 
		&& targ.moditems & IT_ARTBLASTBELT) {
		PlayBlastBeltSound(targ);
		return;
	}

	// check for godmode or invincibility
	if (targ.flags & FL_GODMODE || targ.invincible_finished >= time) { PlayPentagramSound(targ); return; }

	// Warlord special dodging.  From Quake 1.5, simplified a little.   -Qmaster
	if (targ.classtype == CT_MONWARLORD) {
		if ((targ.enemy != world) && (inflictor.classgroup != CG_PROJROCKETS)) { 	// when shot from unseen inflictor !  ( => Did not see inflicter/player)   Warlord can not dodge rockets, only grenades !
			if (targ.dodge_finished < time)	{ // chance to dodge
				if (random () > 0.15) {				// checks if Warlord resists this attack and dodge
					take = 0;
					targ.dodge_finished = time + 1.2;		// finetune invulnerable/dodging time !
					targ.dodging = 1;
				}
			}
		}	
	}	
	
	//------------------------------------------------------//
	//------------//
	//---//
	//
	targ.health = targ.health - take; // DO THE DAMAGE  --------- DO IT!!!
	//
	//---//
	//------------//
	//----------------------- OUCH! ------------------------//

	// Apply berserker helm life leech to heal the attacker if the target still has health
	if (attacker.perms & POW_VAMPIRE && targ.health > 0) {
		if (attacker.selfweaponismoditems) {
			if (attacker.weapon == IT_MACE) {
				misc = ceil(take * 0.1); //10% of the damage done gets leeched.  Damage was already done so doesn't affect damage amount
				if (misc < 1) misc = 1; // minimum of 1 leech
				if (misc > 0) T_Heal (attacker, misc, FALSE);
				if (attacker.health > HEAL_MEGAMAX) attacker.health = HEAL_MEGAMAX;
			}
		} else {
			if (attacker.weapon == IT_AXE || attacker.weapon == IT2_MJOLNIR || attacker.weapon == IT_SCIMITAR || attacker.weapon == IT_RAPIER) {
				misc = ceil(take * 0.1); //10% of the damage done gets leeched.  Damage was already done so doesn't affect damage amount
				if (misc < 1) misc = 1; // minimum of 1 leech
				if (misc > 0) T_Heal (attacker, misc, FALSE);
				if (attacker.health > HEAL_MEGAMAX) attacker.health = HEAL_MEGAMAX;
			}
		}

	}

	// Changed the turret code to allow for monster % HP triggers
	// The turret movespeed is no longer a pre-condition, can have trigger events for larger HP monsters like shamblers
	// Greater opportunity to keep the pacing insync with the player with any monster having this trigger
	// Check monster turret is to be released based on % health and fire any targets (once only) when this condition is met
	if (targ.turrethealth > 0) {
		if (targ.flags & FL_MONSTER) {
			// Check if HP % trigger should happen? (less than = event)
			if (targ.health < (targ.max_health * targ.turrethealth)) {
				// Trigger HP debug info (developer 1 mode)
				dprint("Target ("); dprint(targ.classname);
				dprint(") HP ("); dprint(ftos(targ.health));
				dprint(") % ("); dprint(ftos(targ.turrethealth));
				dprint(") Trig ("); dprint(targ.turrettarget);
				dprint(")\n");
				if (targ.turrettarget != "") trigger_strs(targ.turrettarget, attacker); // Fire all targets if string exists
				if (targ.movespeed < 0) targ.movespeed = 1; // Release turret, free movement
				
				// Is there a second HP % event?
				if (targ.turrethealth2 > 0) {
					if (targ.turrethealth2 >= targ.turrethealth) {
						dprint("\b[MONSTER]\b Second HP % trigger high than first!\n");
						targ.turrethealth = targ.turrethealth2 = 0; // Reset health + target fields
						targ.turrettarget = targ.turrettarget2 = "";
					} else {
						targ.turrethealth = targ.turrethealth2; // Copy over targets
						targ.turrettarget = targ.turrettarget2;
						targ.turrethealth2 = 0; // Reset					
					}
				} else {
					targ.turrethealth = 0; // Reset health + target fields
					targ.turrettarget = "";
				}
			}
		}
	}

	// When the SG projectile system is active each monster needs to keep track of cumulative damage so that pain flinches work correctly
	// CG_PROJSHELLS classgroup is only TRUE when projectiles are fired, not hitscans (multidamage applied prior)
	if (inflictor.classgroup == CG_PROJSHELLS) {
		// Does the frame damage acculator need to be reset?
		if (targ.dmgtimeframe <= time) {
			targ.dmgtimeframe = time + 0.1;
			targ.dmgcombined = 0;
		}
		targ.dmgcombined = targ.dmgcombined + take; // Accumulate damage until next fromae
	}
	
	// When the SG projectile system is active ZOMBIES need to know if there has been enough damage over a single frame to die or not
	if (targ.classgroup == CG_ZOMBIE && targ.classtype != CT_MONMUMMY) {
		if (random() < 0.5) targ.pain_finished = 0; // Zombies need to be hurt more!
		// Horrible Hack - Launch_Bullet sets the weapon flag on projectiles.  Only register damage against zombies if SSG upgrade or Quad!
		if (inflictor.classgroup == CG_PROJSHELLS && inflictor.weapon) {
			if (targ.dmgcombined > targ.max_health) targ.health = targ.gibhealth; // Has the accumulator gone over the max health?
		}
	}
	
	if (targ.health < 1) {
		if ((inflictor.classgroup == CG_PROJICE || inflictor.classtype == CT_FROSTSHARD) && targ.resist_cold < 1) targ.frozen = TRUE;
		Killed (targ, attacker);
		return;
	} // Has the target died?
	
	// Switch self (foundtarget and pain function need self correct)
	// self restored before end of function
	oldself = self;
	self = targ;

	// react to the damage - only if a monster
	// No reaction if attacker is world (env trap, door, etc) or a crossbow bolt (stealth weapon)
	if ( (self.flags & FL_MONSTER) && attacker != world && inflictor.classtype != CT_PROJ_BOLT1 && inflictor.classtype != CT_PROJ_BOLT2) {
		// Is the current attacker not self and not current enemy target?
		if (self != attacker && attacker != SUB_entEnemyTarget()) {
			if (!Align_Match(self,attacker) || IsInsane(self)) { // Don't get angry at friends, unless insane
				if ((self.noinfighting && attacker.flags & FL_MONSTER || attacker.noinfighting) && !(IsInsane(self))) {
					// Prevent monsters from infighting
					// but let them react to the player
				} else {
					// If previous switch target dead, focus on new target
					if (self.switchattacker.health < 1 || self.classtype == CT_MONSHAMVILE) self.switchtimer = 0;
					// Is the attacker a different classgroup and switching target available?
					if (self.switchtimer < time) {
						if (self.classgroup != attacker.classgroup || IsInsane(self)) {
							// Prevent the monster from rapidily switching targets
							if (self.switchattacker != attacker) self.switchtimer = time + 1;
							else self.switchtimer = time + 0.1 + random();
							// Switch to new target
							self.switchattacker = attacker;

							// Shift previous enemy to old enemy ready for new target
							// Only switch if the new enemy is the player! (id logic)
							// Check for new enemy target system before switching
							if (SUB_flagsEnemyTarget(FL_CLIENT)) self.oldenemy = SUB_entEnemyTarget();
							if (self.enemy.classtype == CT_ENEMYTARGET) SUB_switchEnemyTarget();
							self.enemy = attacker;		// attack the attacker!
							FoundTarget ();				// Run+turn towards new enemy
						}
					}
				}
			}
		}
	}
	self = oldself;

	// Check for ammo type resistance and immunity to pain
	// Targetdummies rely on the pain function to display stats
	if (targ.classtype != CT_TARGETDUMMY) {
		if (targ.resist_shells > 0 && inflictor.classgroup == CG_PROJSHELLS) return;
		else if (targ.resist_nails > 0 && inflictor.classgroup == CG_PROJNAILS) return;
		else if (targ.resist_rockets > 0 && inflictor.classgroup == CG_PROJROCKETS) return;
		else if (targ.resist_cells > 0 && inflictor.classgroup == CG_PROJCELLS) return;
		else if (targ.resist_lava_nails > 0 && inflictor.classgroup == CG_PROJLAVANAILS) return;
		else if (targ.resist_multi_rockets > 0 && inflictor.classgroup == CG_PROJMULTIROCKETS) return;
		else if (targ.resist_plasma > 0 && inflictor.classgroup == CG_PROJPLASMAROGUE) return;
		else if (targ.resist_bolts > 0 && inflictor.classgroup == CG_PROJBOLTS) return;
		else if (targ.resist_poison > 0 && inflictor.classgroup == CG_PROJBOLTSPOISON) return;
		else if (targ.resist_bloodcrystals > 0 && inflictor.classgroup == CG_PROJBLOODCRYSTALS) return;
		else if (targ.resist_voidshards > 0 && inflictor.classgroup == CG_PROJVOID) return;
		else if (targ.resist_elemental > 0 && inflictor.classgroup == CG_PROJMAGIC) return;
	}

	// Switch self (foundtarget and pain function need self correct), self restored before end of function
	oldself = self;
	self = targ;

	if (self.th_pain && (self.pain_finished < time)) {
		self.pain_finstate = self.pain_finished; // Save pain finished state for later		

		// The damage from projectile shotguns trinkle at the monster which means it cannot trigger the flinch function
		// Let the combined damage over 1 frame accumulate first.  Exception - Zombies don't flinch, they must run pain function
		if (inflictor.classgroup == CG_PROJSHELLS && targ.classgroup != CG_ZOMBIE) {
			// Demon, Shambler, Shalrath and Wizard all have high flinch values
			if (self.pain_flinch > 40) flinch = 40;
			else flinch = self.pain_flinch + 1;
			if (self.dmgcombined < flinch) {self = oldself; return;}
		}

		self.pain_finished = time + self.pain_timeout; // Block pain re-trigger event
		
		// Ignoring pain from other monsters? (infighting)
		if ((self.pain_ignore || IsInsane(self)) && attacker.flags & FL_MONSTER) {
			self.pain_finished = self.pain_finished + 1 + random();
		} else {
			// If accumulated pain is higher, use that instead
			// Added classgroup exception otherwise damage qty is wrong
			if (inflictor.classgroup == CG_PROJSHELLS && take < self.dmgcombined) self.th_pain (inflictor, attacker, self.dmgcombined);
			else self.th_pain (inflictor, attacker, take);
	
			// nightmare mode monsters don't go into pain frames often
			if (skill == SKILL_NIGHTMARE && targ.classgroup != CG_ZOMBIE) self.pain_finished = time + 5;

			// Exceptions to pain not being blocked (even nightmare!).  If the monster is in slime or lava always go into pain
			if (self.watertype == CONTENT_SLIME && !self.resist_acid) self.pain_finished = time + 0.3;
			if (self.watertype == CONTENT_LAVA && !self.resist_fire) self.pain_finished = time + 0.3;
		}
	}
	self = oldself;
};

// inflictor -(self) = projectile
// attacker - (self.owner) = monster/player OR (self) = direct attack
// ignore   - (other) = Original target OR (world) = no exceptions
void(entity inflictor, entity attacker, float damage, entity ignore, float checkclass) T_RadiusDamage = {
	local	float 	points;
	local	entity	head;
	local	vector	org, imporg, dir;

	// Cannot hurt the world or enemy targets (fake flying markers)
	if (attacker.noradiusdmg) return;
	if (attacker.classtype == CT_WORLD) return;
	if (attacker.classtype == CT_ENEMYTARGET) return;

	// check if inflictor is a bmodel (different origin location)
	if (inflictor.bsporigin) imporg = bmodel_origin(inflictor);
	else imporg = inflictor.origin;
	head = findradius(imporg, damage+40);
	points = damage;
	while (head) {
		if (head != ignore) {
			// This is used mostly for wraiths so when they die they don't kill each other, can't get the code logic to work so its setup as a dead exception path
			if (checkclass == IGNORECLASS && head.classtype == ignore.classtype) { // Nothing
			} else {
				if (ai_immunebreakable(attacker, head)) { // Check for breakable/pushable monster immunity.  Do nothing, radius damage has no miss effect
				} else if (ai_foundbreakable(attacker, head,TRUE) && head.brktrigmissile !=0) { // Check for any breakable which is prone to explosive damage
					trigger_ent(head, attacker);
				} else {
					// Can be damaged and NOT immune to radius (splash) damage
					if (head.takedamage > 0 && head.noradiusdmg == 0) {
						// This formula is using bounding box size which means the damage amount is lower if the monster is larger
						// It should really be based on bounding box edge not monster origin
						org = head.origin + (head.mins + head.maxs)*0.5;
						points = 0.5*vlen (imporg - org);
						if (points < 0) points = 0;
						points = damage - points;
						if (head == attacker) points = points * 0.5; // Half damage if caught by own explosion
						if (points > 0 && head.health > 0) {
							// Need CanDamage to check for anything blocking LoS.  It will do several traces (source->target) to check for any blocking entities (lifts, doors, walls etc)
							if (CanDamage(head, inflictor)) {
								if (points > 0) {
									if ((inflictor.classgroup == CG_PROJFIRE || attacker.classgroup == CG_PROJFIRE) && (random() < (damage+1)*0.01)) Burn_Add(head, attacker, MAX_BURN_DAMAGE); // Chance to burn equals (damage + 1)%.  E.g., 9 damage = 10%. Yes, use 'damage' and not 'take'.
									T_Damage (head, inflictor, attacker, points, DAMARMOR); // Any damage left? Check for poison as well
								}
								if (attacker.poisonous) PoisonDeBuff(head);
							}
						}
					}

					// From bsqmsafe
					if (head.classtype == CT_TEMPGIB || head.frozen) {
						if (head.flags & FL_ONGROUND) head.flags = head.flags - FL_ONGROUND;
						dir = head.origin - ((inflictor.absmin + inflictor.absmax) * 0.5);
						dir = normalize(dir);
						if (head.frozen) {
							head.velocity = head.velocity + dir*damage*2; // Half as much for frozen enemies
							head.health = head.health - points;
						} else head.velocity = head.velocity + dir*damage*4;
						if (head.velocity_z < 10) head.velocity_z = 10;
						head.velocity_z = vlen(head.velocity) * 0.5;
					}
				}
			}
		}
		head = head.chain;
	}
};

// Add armor to entity e, within limits.  Similar to T_Heal, but for armor.
float(entity e, float heal, float ignore) T_Repair = {
    local float full;

    if (e.health <= 0) return 0;   // Dead.

    if (ignore)
        full = 250;     // armorvalue on hud is restricted to max of 255.
    else if (e.armortype == ARMOR_RED_TYPE)
        full = ARMOR_RED_VALUE;
    else if (e.armortype == ARMOR_YEL_TYPE)
        full = ARMOR_YEL_VALUE;
    else
        full = ARMOR_GRN_VALUE;

    if (e.armorvalue >= full) return 0;   // Armor already fully restored.
    if (heal < 1) return 0;   // Don't damage the armor.

    if (e.armorvalue + heal >= full) e.armorvalue = full;
	else e.armorvalue = e.armorvalue + heal;

	if (e.curse_type == CURSE_ARMOR) {
		e.armorvalue = e.armorvalue - heal; // flip it!
		if (e.armorvalue < 0) {
			e.armorvalue = 0;
			e.armortype = 0;
		}
	}

    return heal;        // Return amount healed instead of TRUE.
};

// Radius damage but ignores entities outside of the water and other eels
// inflictor -(self) = projectile
// attacker - (self.owner) = monster/player OR (self) = direct attack
// ignore   - (other) = Original target OR (world) = no exceptions
void(entity inflictor, entity attacker, float damage, entity ignore, float checkclass) T_EELZap = {
	local float points;
	local entity head;
	local vector org, imporg;

	// Cannot hurt the world or enemy targets (fake flying markers)
	if (attacker.noradiusdmg) return;
	if (attacker.classtype == CT_WORLD) return;
	if (attacker.classtype == CT_ENEMYTARGET) return;

	// check if inflictor is a bmodel (different origin location)
	if (inflictor.bsporigin) imporg = bmodel_origin(inflictor);
	else imporg = inflictor.origin;
		
	head = findradius(imporg, damage+40);
	while (head) {
		if (head != ignore) {
			// This is used also for wraiths so when they die they don't kill each other
			if ((checkclass != IGNORECLASS) && (head.classtype != ignore.classtype)) {
				// Check for any breakable which is prone to explosive damage
				if (ai_foundbreakable(attacker, head,TRUE) && head.brktrigmissile !=0) {
					trigger_ent(head, attacker);
				} else {
					// Can be damaged and NOT immune to radius (splash) damage
					if (head.takedamage > 0 && head.noradiusdmg == 0) {
						org = head.origin + (head.mins + head.maxs)*0.5;
						points = 0.5*vlen (imporg - org);
						if (points < 0) points = 0;
						points = damage - points;
						if (head == attacker) points = points * 0.5;
						if (points > 0 && head.health > 0) {
							// Need CanDamage to check for anything blocking LoS.  It will do several traces (source->target) to check for any blocking entities (lifts, doors, walls etc)
							if (CanDamage (head, inflictor)) {
								if ((head.classtype != CT_MONEEL) && (head.flags & FL_INWATER)) T_Damage (head, inflictor, attacker, points, DAMARMOR);
							}
						}
					}
				}
			}
		}
		head = head.chain;
	}
};

// From Quoth
void() ai_shotcheck = { if (visible(self.enemy)) self.oldenemyorigin = self.enemy.origin; };
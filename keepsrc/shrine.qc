void(entity targ) ResetDebuffPoisoned;
void(entity targ) ResetDebuffBleeding;
void(entity targ) bound_other_ammo;

void(entity targ) ResetAuraEffects = {
	if (targ.flags & FL_MONSTER) { targ.aura_type = -1; return; }

	if (targ.aura_type == 0) { // Earth
		dprint("Reset Earth shrine effects\n");
		targ.resist_acid = targ.save_acid; 				// Return to normal resistance

	} else if (targ.aura_type == 1) { // Water
		dprint("Reset Water shrine effects\n");
		targ.resist_lava_nails = targ.save_lava_nails; 	// Return to normal resistance
		targ.resist_fire = targ.save_fire; 				// Return to normal resistance

	} else if (targ.aura_type == 2) { // Air
		dprint("Reset Air shrine effects\n");
		targ.air_finished = time; 						// No air left!  Suck it down!	
		targ.air_blessed = 0;

	} else if (targ.aura_type == 3) { // Fire
		dprint("Reset Fire shrine effects\n");
		targ.resist_cold = targ.save_cold;

	} else if (targ.aura_type == 4) { // Blood
		dprint("Reset Blood shrine effects\n");
		// None
		
	} else if (targ.aura_type == 5) { // Spirit
		dprint("Reset Spirit shrine effects\n");
		// None
		
	}
	targ.aura_type = -1;
};

void(entity targ,float type) DesecrateEffects = {
	if (targ.flags & FL_CLIENT == 0) return;

	if (type == 0) {
		// Earth
		targ.armortype = ARMOR_RED_TYPE;		// 200 Armor points
		targ.armorvalue = ARMOR_RED_VALUE;		// 80% Armor - Red Armor item_armorInv
		targ.resist_acid = 1;					// 100% Resistance to poison and slime

	} else if (type == 1) {
		// Water
		targ.water_blessed = 1;					// Speed swimming
		targ.maxshells = targ.maxshells + 100;	// Increase maximum shells
		targ.ammo_shells = targ.maxshells;		// Give full shell ammo
		bound_other_ammo(targ);					// Make sure we don't go past limit
		W_SetCurrentAmmo(targ);					// Update HUD count

	} else if (type == 2) {
		// Air
		targ.maxnails = targ.maxnails + 100;	// Increase maximum nails
		targ.ammo_nails = targ.maxnails;		// Gives full nail ammo
		bound_other_ammo(targ);					// Make sure we don't go past limit
		W_SetCurrentAmmo(targ);					// Update HUD count
		targ.jumpboots_finished = POWERUP_VANIA; // Unlimited timeframe for using double jump
		targ.jumpboots_airmax = targ.jumpboots_airmax + 1; // Add double jump, or increase number of jumps by 1 to triple or quadruple
		if (targ.jumpboots_airmax > ART_JUMPBOOTS_AIRMAX) targ.jumpboots_airmax = ART_JUMPBOOTS_AIRMAX; // Still only 4 at most

	} else if (type == 3) {
		// Fire
		targ.maxlavanails = targ.maxlavanails + 100;	// Increase maximum lava nails
		targ.ammo_lava_nails = targ.maxlavanails;		// Give full lava nail ammo
		targ.maxrockets = targ.maxrockets + 50;	// Increase maximum rocket
		targ.ammo_rockets = targ.maxrockets;	// Give full rocket ammo
		targ.maxmultirockets = targ.maxmultirockets + 50;	// Increase maximum multi-rocket
		targ.ammo_multi_rockets = targ.maxmultirockets;		// Give full multi-rocket ammo
		bound_other_ammo(targ);					// Make sure we don't go past limit
		W_SetCurrentAmmo(targ);					// Update HUD count

	} else if (type == 4) {
		// Blood
		targ.mega_health = 300; 		// Change regardless of Chaos mode for mega health's maximum, because even the gods appreciate less chaos
		targ.maxblood = targ.maxblood + 50;		// Increase maximum blood crystals
		targ.ammo_bloodcrystals = targ.maxblood; // Give full blood crystal ammo
		targ.max_health = targ.max_health + 25;	// Increase max normal health by 25
		targ.health = targ.max_health;			// Woop!
		bound_other_ammo(targ);					// Make sure we don't go past limit
		W_SetCurrentAmmo(targ);					// Update HUD count

	} else if (type == 5) {
		// Spirit
		targ.spirit_blessed = 1;				// 25% Damage reduction for all damage

	}
};

void() shrine_desecrate_think = {
    local entity pc;

	if (self.pain_finished > time) {
		while (pc) {
			centerprint_msg3(pc, self.message, self.message3, self.ckeyname2);
			pc = find (pc, classname, "player");
		}
	}
	if (self.pain_finished < time) self.think = SUB_Remove;
	else self.think = shrine_desecrate_think;
	self.nextthink = time + 0.1;
};

void() shrine_desecrate = {
    local entity pc;

    pc = find (world, classname, "player");
    while (pc) {
		centerprint_msg3(pc, self.message, self.message3, self.ckeyname2);
		ResetAuraEffects(pc);
		DesecrateEffects(pc,self.style);
        pc = find (pc, classname, "player");
    }
	self.pain_finished = time + 4;
	self.think = shrine_desecrate_think;
	self.nextthink = time + 0.1;
};

void() shrine_desecrate_angry = {
	if (self.target != "") {
		SUB_UseTargets();
		clear_trigstrs(self); // Only fire targets once, remove any further triggering
	}

	self.state = STATE_OFF;
	shrine_desecrate();
};

void() shrine_magic_think = {
	local vector dir, spot;

	spot = self.enemy.origin;
	spot_x = spot_x + (crandom() * 8);
	spot_y = spot_y + (crandom() * 8);
	spot_z = spot_z + (crandom() * 8);
	dir = normalize(spot - self.origin);
	self.velocity = dir * 80;
	if (self.pain_finished < time) self.think = SUB_Remove;
	else self.think = shrine_magic_think;
	self.nextthink = time + 0.05;
};

void(vector spot,entity targ, float sprtype) shrine_magic_beam = {
	local entity partic;
	local string s;

	s = "progs/ad171/s_dotmed_grn.spr";
	if (sprtype == 1) { s = "progs/ad171/s_dotmed_blue.spr";
	} else if (sprtype == 2) { s = "progs/ad171/s_dotmed_grey.spr";
	} else if (sprtype == 3) { s = "progs/ad171/s_dotmed_yell.spr";
	} else if (sprtype == 4) { s = "progs/ad171/s_dotmed_red.spr";
	} else if (sprtype == 5) { s = "progs/ad171/s_dotmed_purp.spr"; }

	partic = spawn();
	partic.solid = SOLID_NOT;
	partic.movetype = MOVETYPE_NOCLIP;
	setmodel (partic, s);
	setsize(partic,'0 0 0', '0 0 0');
	spot_x = spot_x + (crandom() * 8);
	spot_y = spot_y + (crandom() * 8);
	spot_z = spot_z + (crandom() * 8);
	setorigin(partic,spot);
	partic.enemy = targ;
	partic.think = shrine_magic_think;
	partic.nextthink = time + 0.05;
	partic.pain_finished = time + (self.proj_limit/80);
};

void() shrine_aura_think = {
	local entity e;// pc1, pc2, pc3, pc4;
	// local float c;

	// pc1 = pc2 = pc3 = pc4 = world; // Reset

	if (self.attack_finished < time) {
		// dprint("Shrine thinking!\n");
		e = findradius(self.origin,self.proj_limit);
		while (e) {
			if (e.flags & FLx_CREATURE && e.health > 0) {
				shrine_magic_beam(self.origin,e,self.style);
				shrine_magic_beam(self.origin,e,self.style);
				shrine_magic_beam(self.origin,e,self.style);
				e.aura_finished = time + 1 + self.delay; // Lasts slightly when out of range
				e.aura_type = self.style;

				// Benefits to good monsters
				if (e.flags & FL_MONSTER && e.alignment != EVIL) {
					e.aura_type = 1;
					e.health = e.health + self.cnt;
					if (e.health > e.max_health) e.health = e.max_health;
					e.pain_finished = time + 5; // don't flinch, we are helping the player
				}

				// Benefits to players
				if (e.flags & FL_CLIENT) {
					if (time < self.pain_finished) centerprint_msg3(e, self.message, self.message2, self.ckeyname1);

					// if (c == 0 && !pc1) pc1 = e;
					// if (c == 1 && !pc2) pc2 = e;
					// if (c == 2 && !pc3) pc3 = e;
					// if (c == 3 && !pc4) pc4 = e;
					// c = c + 1;

					if (self.style == 0) {
						// Earth
						e.curse_finished = e.curse_ping = e.curse_type = 0; // Curses begone!  Remove before other benefits
						ResetDebuffPoisoned(e);								// Remove poison effects
						e.armortype = ARMOR_RED_TYPE;
						T_Repair(e,self.cnt,TRUE);
						if (e.save_acid) e.save_acid = e.resist_acid;		// remember what we were for later
						if (e.resist_acid < 0.75) e.resist_acid = 0.75;		// 

					} else if (self.style == 1) {
						// Water
						ResetDebuffBurning(e);
						e.ammo_shells = e.ammo_shells + self.cnt;
						bound_other_ammo(e);
						W_SetCurrentAmmo(e);
						if (e.save_lava_nails) e.save_lava_nails = e.resist_lava_nails; // remember what we were
						if (e.resist_lava_nails < 0.75) e.resist_lava_nails = 0.75;
						if (e.save_fire) e.save_fire = e.resist_fire; // remember what we were
						if (e.resist_fire < 0.75) e.resist_fire = 0.75;

					} else if (self.style == 2) {
						// Air
						e.ammo_nails = e.ammo_nails + self.cnt;
						bound_other_ammo(e);
						W_SetCurrentAmmo(e);
						e.air_finished = time + WATER_AIR;				// Breath under water
						e.air_blessed = 1;

					} else if (self.style == 3) {
						// Fire
						e.ammo_lava_nails = e.ammo_lava_nails + self.cnt;
						e.ammo_multi_rockets = e.ammo_multi_rockets + self.cnt;
						e.ammo_rockets = e.ammo_rockets + self.cnt;
						bound_other_ammo(e);
						W_SetCurrentAmmo(e);
						if (e.resist_cold) e.save_cold = e.resist_cold;
						e.resist_cold = 0.75;

					} else if (self.style == 4) {
						// Blood
						ResetDebuffBleeding(e);
						if (random() < 0.4) { // Hacky way to simulate slower rate compared to healing
							e.ammo_bloodcrystals = e.ammo_bloodcrystals + self.cnt;
							bound_other_ammo(e);
							W_SetCurrentAmmo(e);
						}
						e.health = e.health + self.cnt;
						if (e.health > HEAL_MEGAMAX) e.health = HEAL_MEGAMAX;

					} else if (self.style == 5) {
						// Spirit
						e.ammo_elemental = e.ammo_elemental + self.cnt;
						bound_other_ammo(e);
						W_SetCurrentAmmo(e);
						e.zapper_time = time - 7; // guarantee full charge if wand is out
					}
				}
			}
			e = e.chain;
		}
		self.attack_finished = time + self.delay;
	}

	// Remember up to 4 players so we can properly remove and reset aura effects when they are out of range
	// if (pc1) {
		// self.oldenemy = pc1;
	// } else {
		// if (self.oldenemy) {
			// c = vlen(self.origin - self.oldenemy.origin);
			// if (c > self.proj_limit) ResetAuraEffects(self.oldenemy);
			// self.oldenemy = world;
		// }
	// }
	// if (pc2) {
		// self.lastvictim = pc2;
	// } else {
		// if (self.lastvictim) {
			// c = vlen(self.origin - self.oldenemy.origin);
			// if (c > self.proj_limit) ResetAuraEffects(self.lastvictim);
			// self.lastvictim = world;
		// }
	// }
	// if (pc3) {
		// self.charmer = pc3;
	// } else {
		// if (self.charmer) {
			// c = vlen(self.origin - self.oldenemy.origin);
			// if (c > self.proj_limit) ResetAuraEffects(self.charmer);
			// self.charmer = world;
		// }
	// }
	// if (pc4) {
		// self.aiment = pc4;
	// } else {
		// if (self.aiment) {
			// c = vlen(self.origin - self.oldenemy.origin);
			// if (c > self.proj_limit) ResetAuraEffects(self.aiment);
			// self.aiment = world;
		// }
	// }
	self.think = shrine_aura_think;
	self.nextthink = time + 0.05;
};

void(entity o) shrine_respect = {
	self.state = STATE_ON;
	self.think = shrine_aura_think;
	self.nextthink = time + 0.1;
	self.enemylastseen = time;
	self.use = shrine_desecrate_angry;
	self.pain_finished = time + 4;
	if (self.style == 0) { // Earth
		if (!self.delay) self.delay = 0.3;
		if (!self.cnt) self.cnt = 1;
	} else if (self.style == 1) { // Water
		if (!self.delay) self.delay = 0.5;
		if (!self.cnt) self.cnt = 1;
	} else if (self.style == 2) { // Air
		if (!self.delay) self.delay = 0.3;
		if (!self.cnt) self.cnt = 1;
	} else if (self.style == 3) { // Fire
		if (!self.delay) self.delay = 0.5;
		if (!self.cnt) self.cnt = 1;
	} else if (self.style == 4) { // Blood
		if (!self.delay) self.delay = 0.3;
		if (!self.cnt) self.cnt = 1;
	} else if (self.style == 5) { // Spirit
		if (!self.delay) self.delay = 0.2;
		if (!self.cnt) self.cnt = 1;
	}
};

void() shrine_use = {
	if (activator.flags & FL_CLIENT) {
		shrine_respect(activator);
		centerprint_msg3(activator, self.message, self.message2, self.ckeyname1);
	} else {
		if (activator.classgroup == CG_BREAKABLE || activator.classtype == CT_FUNCBREAKMDL || activator.classtype == CT_FUNCBREAK) {
			shrine_desecrate();
			self.pain_finished = time + 4;
			centerprint_msg3(activator, self.message, self.message3, self.ckeyname2);
		} else {
			dprint("Something other than a player or a breakable tried to activate a shrine, check your setup!\n");
		}
	}
};

void() info_shrine = {
	local string s, magik, magikb;

	precache_model("progs/ad171/s_dotmed_grn.spr");
	precache_model("progs/ad171/s_dotmed_blue.spr");
	precache_model("progs/ad171/s_dotmed_grey.spr");
	precache_model("progs/ad171/s_dotmed_yell.spr");
	precache_model("progs/ad171/s_dotmed_red.spr");
	precache_model("progs/ad171/s_dotmed_purp.spr");

	if (self.style == 0) {s = "\nof the Earth Shrine has blessed\nyou with Aura of Earth Magick,\nbecome as stone. \n"; magikb = " of the Earth Shrine has\nlost influence,\n the Elder God blesses with\nPoison Protection! \n"; }
	if (self.style == 1) {s = "\nof the Water Shrine has blessed\nyou with Aura of Water Magick,\nflow as water. \n"; magikb = " of the Water Shrine has\nlost influence,\n the Elder God blesses with\nSwimfall Prowess! \n"; }
	if (self.style == 2) {s = "\nof the Air Shrine has blessed\nyou with Aura of Air Magick,\ninhale deeply. \n"; magikb = " of the Air Shrine has\nlost influence,\n the Elder God blesses with\nBreath of Uplifting! \n"; }
	if (self.style == 3) {s = "\nof the Fire Shrine has blessed\nyou with Aura of Fire Magick,\nburst with rage. \n"; magikb = " of the Fire Shrine has\nlost influence,\n the Elder God blesses with\nFire and Power! \n"; }
	if (self.style == 4) {s = "\nof the Blood Shrine has blessed\nyou with Aura of Blood Magick,\nblood of the ancients courses\nthrough you! \n"; magikb = " of the Blood Shrine has\nlost influence,\n the Elder God blesses with\nOverheal Bloodlust! \n"; }
	if (self.style == 5) {s = "\nof the Spirit Shrine has blessed\nyou with Aura of Spirit Magick,\nthe angels watch over you. \n"; magikb = " of the Spirit Shrine has\nlost influence,\n the Elder God blesses with\nProtection of the Watchers! \n"; }
	self.use = shrine_use;	
	self.think = SUB_Null;
	self.state = STATE_OFF;
	if (!self.proj_limit) self.proj_limit = 384; // Aura size radius
	if (!self.message) self.message = "Cthulhu";
	if (!self.message2) self.message2 = s;
	if (!self.message3) self.message3 = magikb; 
};
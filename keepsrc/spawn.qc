// May the LORD look upon you and give you peace
// And may he forgive me for what may come from this
// Unholy function...
string(string old, float type) GetRandomMonsterName = {
	local string retval;
	local float rand;

	retval = old; // in case something bad happens
	if (retval == string_null) retval = "monster_voreling";
	rand = random();

	// Are you sure?  Like...really really?  REALLY????
	// Ok, let's pick ANY MONSTER EVER...aaand go!!
	if (type == 99) {
		// More than 100 monsters so I'll split it

		// Excluding from random list:
		// monster_coil since it doesn't attack back
		// monster_judgeminion since it is the same as the monster_gaunt
		// monster_deathguard since it is identical redirect with monster_death_guard
		// monster_fragy since it is identical redirect with monster_frog
		// monster_afrit since it is identical redirect with monster_imp
		// monster_minotaurminion since it is the same as monster_gargoyle
		// monster_necrominiongolem since it is the same as monster_golem
		// monster_mcorn since it is identical redirect with monster_manitcore
		// monster_me since it is identical redirect with monster_megaforce
		// monster_shuffler since it is identical redirect with monster_minotaur	
		// monster_yakman since it is identical redirect with monster_minotaur
		// monster_guardian since it is identical redirect with monster_morph
		// monster_sorcerer since it is identical redirect with monster_sorceror
		// monster_fragwiz since it is identical redirect with monster_acolyte
		// monster_newboss since it is identical redirect with monster_virtus
		// monster_ogre_spikeshooter since it is identical redirect with monster_ogre_flak
		// monster_ogre_fishing since it wouldn't make sense to spawn randomly just anywhere.
		// monster_ogre_fishing_ghost since it is a decoration
		// monster_dreadnaught since it is identical redirect with monster_pyro
		// monster_queen since it is a decoration
		// monster_wraithminion since it is the same as the monster_spider
		// monster_wraithminion2 since it is the same as the monster_scorpion
		// monster_tur since it is a stationary turret
		// monster_turret since it is a stationary turret
		// monster_vomit since it is identical redirect with monster_vomitus
		// monster_nourminion since it is identical redirect with monster_wizard
		// monster_flytrap since it is a stationary traplike plant
		// monster_flytrap_ground since it is a stationary plantlike trap

		// Including everything else:
		if (random() < 0.5) {
			if (rand < 0.01) retval = "monster_acolyte";
			else if (rand < 0.02) retval = "monster_anac";
			else if (rand < 0.03) retval = "monster_archer";
			else if (rand < 0.04) retval = "monster_archer_lord";
			else if (rand < 0.05) retval = "monster_armagon";
			else if (rand < 0.06) retval = "monster_army";
			else if (rand < 0.07) retval = "monster_army_cyborg";
			else if (rand < 0.08) retval = "monster_army_grenade";
			else if (rand < 0.09) retval = "monster_army_plasma";
			else if (rand < 0.10) retval = "monster_army_rocket";
			else if (rand < 0.11) retval = "monster_axegrunt";
			else if (rand < 0.12) retval = "monster_axeman";
			else if (rand < 0.13) retval = "monster_bandit";
			else if (rand < 0.14) retval = "monster_bane";
			else if (rand < 0.15) retval = "monster_baron";
			else if (rand < 0.16) retval = "monster_boglord";
			else if (rand < 0.17) retval = "monster_boil";
			else if (rand < 0.18) retval = "monster_boss";
			else if (rand < 0.19) retval = "monster_centurion";
			else if (rand < 0.20) retval = "monster_chthon";
			else if (rand < 0.21) retval = "monster_cyberdemon";
			else if (rand < 0.22) retval = "monster_dark_lord";
			else if (rand < 0.23) retval = "monster_dcrossbow";
			else if (rand < 0.24) retval = "monster_death_guard";
			else if (rand < 0.25) retval = "monster_death_lord";
			else if (rand < 0.26) retval = "monster_defender";
			else if (rand < 0.27) retval = "monster_demon1";
			else if (rand < 0.28) retval = "monster_demon";
			else if (rand < 0.29) retval = "monster_dfury";
			else if (rand < 0.30) retval = "monster_dguard";
			else if (rand < 0.31) retval = "monster_dknight";
			else if (rand < 0.32) retval = "monster_dog";
			else if (rand < 0.33) retval = "monster_dragon";
			else if (rand < 0.34) retval = "monster_drole";
			else if (rand < 0.35) retval = "monster_dsergeant";
			else if (rand < 0.36) retval = "monster_edie";
			else if (rand < 0.37) retval = "monster_eel";
			else if (rand < 0.38) retval = "monster_eidolon";
			else if (rand < 0.39) retval = "monster_eliminator";
			else if (rand < 0.40) retval = "monster_enforcer";
			else if (rand < 0.41) retval = "monster_fallen_angel";
			else if (rand < 0.42) retval = "monster_fallen_angel_lord";
			else if (rand < 0.43) retval = "monster_firetopboss";
			else if (rand < 0.44) retval = "monster_fish";
			else if (rand < 0.45) retval = "monster_floyd";
			else if (rand < 0.46) retval = "monster_freddie";
			else if (rand < 0.47) retval = "monster_fumigator";
			else if (rand < 0.48) retval = "monster_gargoyle";
			else if (rand < 0.49) retval = "monster_gaunt";
			else if (rand < 0.50) retval = "monster_goblin";
			else if (rand < 0.51) retval = "monster_golem";
			else if (rand < 0.52) retval = "monster_gremlin";
			else if (rand < 0.53) retval = "monster_gug";
			else if (rand < 0.54) retval = "monster_hell_hound";
			else if (rand < 0.55) retval = "monster_hell_knight";
			else if (rand < 0.56) retval = "monster_hell_knight_champion";
			else if (rand < 0.57) retval = "monster_hell_lord";
			else if (rand < 0.58) retval = "monster_hell_pointknight";
			else if (rand < 0.59) retval = "monster_hkboss";
			else if (rand < 0.60) retval = "monster_hogre";
			else if (rand < 0.61) retval = "monster_hogreham";
			else if (rand < 0.62) retval = "monster_hogremac";
			else if (rand < 0.63) retval = "monster_hydra";
			else if (rand < 0.64) retval = "monster_icegolem";
			else if (rand < 0.65) retval = "monster_impling";
			else if (rand < 0.66) retval = "monster_inquisitor";
			else if (rand < 0.67) retval = "monster_jim";
			else if (rand < 0.68) retval = "monster_knight";
			else if (rand < 0.79) retval = "monster_lava_man";
			else if (rand < 0.80) retval = "monster_lostsoul";
			else if (rand < 0.81) retval = "monster_meatwad";
			else if (rand < 0.82) retval = "monster_minotaur";
			else if (rand < 0.83) retval = "monster_morph";
			else if (rand < 0.84) retval = "monster_mummy";
			else if (rand < 0.85) retval = "monster_necromancer";
			else if (rand < 0.86) retval = "monster_nemesant";
			else if (rand < 0.87) retval = "monster_nightshade";
			else if (rand < 0.88) retval = "monster_nour";
			else if (rand < 0.89) retval = "monster_octa";
			else if (rand < 0.90) retval = "monster_ogre";
			else if (rand < 0.91) retval = "monster_ogre_flak";
			else if (rand < 0.92) retval = "monster_ogre_multi";
			else if (rand < 0.93) retval = "monster_oldone";
			else if (rand < 0.94) retval = "monster_polyp";
			else if (rand < 0.95) retval = "monster_pyro";
			else if (rand < 0.96) retval = "monster_ryu";
			else if (rand < 0.97) retval = "monster_ryu_wyrm";
			else if (rand < 0.98) retval = "monster_scorpion";
			else if (rand < 0.99) retval = "monster_scourge";
			else if (rand < 1.00) retval = "monster_seeker";
			// 100!  Ok...we ran out of slots in random...not really, but I'm counting on poor precision here so...yeah
		} else {
			if (rand < 0.01) retval = "monster_sentinel";
			else if (rand < 0.02) retval = "monster_shalrath";
			else if (rand < 0.03) retval = "monster_shambler";
			else if (rand < 0.04) retval = "monster_shub";
			else if (rand < 0.05) retval = "monster_shubupsd";
			else if (rand < 0.06) retval = "monster_skullwiz";
			else if (rand < 0.07) retval = "monster_snakeman";
			else if (rand < 0.08) retval = "monster_sorceror";
			else if (rand < 0.09) retval = "monster_spider";
			else if (rand < 0.10) retval = "monster_spikemine";
			else if (rand < 0.11) retval = "monster_super_grunt";
			else if (rand < 0.12) retval = "monster_super_wrath";
			else if (rand < 0.13) retval = "monster_swampling";
			else if (rand < 0.14) retval = "monster_sword";
			else if (rand < 0.15) retval = "monster_tarbaby";
			else if (rand < 0.16) retval = "monster_tarbaby_mitosis";
			else if (rand < 0.17) retval = "monster_trogboss";
			else if (rand < 0.18) retval = "monster_troglodyte";
			else if (rand < 0.19) retval = "monster_vermis";
			else if (rand < 0.20) retval = "monster_virtus";
			else if (rand < 0.21) retval = "monster_vomitus";
			else if (rand < 0.22) retval = "monster_voreling";
			else if (rand < 0.23) retval = "monster_warlock";
			else if (rand < 0.24) retval = "monster_wizard";
			else if (rand < 0.25) retval = "monster_wraith";
			else if (rand < 0.26) retval = "monster_wrath";
			else if (rand < 0.27) retval = "monster_wspider";
			else if (rand < 0.28) retval = "monster_zombie";
			else if (rand < 0.29) retval = "monster_zombiek";
			else if (rand < 0.30) retval = "monster_zombiep";
			else if (rand < 0.31) retval = "monster_reiver";
			else if (rand < 0.32) retval = "monster_carnivean";
			else if (rand < 0.33) retval = "monster_shalrath_boss";
			else if (rand < 0.34) retval = "monster_dfury_boss";
			else if (rand < 0.35) retval = "monster_oldone_tentacle";
			else if (rand < 0.36) retval = "monster_hell_knight2";
			else if (rand < 0.37) retval = "monster_army_spike"; 
			else if (rand < 0.38) retval = "monster_super_enforcer";
			else if (rand < 0.39) retval = "monster_hell_knight_enforcer";
			else if (rand < 0.40) retval = "monster_bob";
			// else if (rand < 0.41) retval = "monster_mistermax";
			else if (rand < 0.42) retval = "monster_ogre_marksman";
			else if (rand < 0.43) retval = "monster_ogre_spikeshooter";
			else if (rand < 0.44) retval = "monster_rebel";
			else if (rand < 0.45) retval = "monster_judicator";
			else if (rand < 0.46) retval = "monster_justice";
			else if (rand < 0.47) retval = "monster_deflector";
			else if (rand < 0.48) retval = "monster_dprince";
			else if (rand < 0.49) retval = "monster_drone";
			else if (rand < 0.50) retval = "monster_frog";
			else if (rand < 0.51) retval = "monster_imp";
			else if (rand < 0.52) retval = "monster_huntress";
			else if (rand < 0.53) retval = "monster_karasu";
			else if (rand < 0.54) retval = "monster_manticore";
			// else if (rand < 0.55) retval = "monster_enf2";
			// else if (rand < 0.56) retval = "monster_enf3";
			else if (rand < 0.57) retval = "monster_lichfiend";
			else if (rand < 0.58) retval = "monster_megaforce";
			else if (rand < 0.59) retval = "monster_nehahra";
			else if (rand < 0.60) retval = "monster_ogle";
			else if (rand < 0.61) retval = "monster_raven";
			else if (rand < 0.62) retval = "monster_sheep";
			else if (rand < 0.63) retval = "monster_spellmaster";
			else if (rand < 0.64) retval = "monster_spirit";
			// else if (rand < 0.65) retval = "monster_servomech";
			else if (rand < 0.66) retval = "monster_steelclaw";
			else if (rand < 0.67) retval = "monster_beez";
			// else if (rand < 0.68) retval = "monster_ubs";
			else if (rand < 0.69) retval = "monster_wolf";
			// else if (rand < 0.70) retval = "monster_wraith_lord";
			else if (rand < 0.71) retval = "monster_xmas_elf";
			else if (rand < 0.72) retval = "monster_xmas_raindeer";
			else if (rand < 0.73) retval = "monster_xmas_santa";
			else if (rand < 0.74) retval = "monster_xmas_snowman";
			// else if (rand < 0.75) retval = "monster_zombie_master";
			else if (rand < 0.76) retval = "monster_soldier";
			else if (rand < 0.77) retval = "monster_soldier_elite";
			else if (rand < 0.78) retval = "monster_commando";
			else if (rand < 0.79) retval = "monster_gunner";
			else if (rand < 0.80) retval = "monster_thug";
			else if (rand < 0.81) retval = "monster_shamvile";
			else if (rand < 0.82) retval = "monster_ultra";
			else if (rand < 0.83) retval = "monster_warrior";
			else if (rand < 0.84) retval = "monster_baron_fire";
			else if (rand < 0.85) retval = "monster_baron_wind";
			else if (rand < 0.86) retval = "monster_baron_earth";
			else if (rand < 0.87) retval = "monster_baron_water";
			else if (rand < 0.88) retval = "monster_oglib";
			else if (rand < 0.89) retval = "monster_lavagolem";
			// More slots!?!!?
			//
			//
			//
			//
			//
			//
			//
			//
			//
			else if (rand < 1.00) retval = "monster_voidwraith"; // Do we have enough choices, yeesh!
		}
	} else if (self.style == 1) { // Denizens
		if (rand < 0.16) retval = "monster_frog";
		else if (rand < 0.32) retval = "monster_ogle";
		else if (rand < 0.48) retval = "monster_raven";
		else if (rand < 0.64) retval = "monster_voidwraith";
		else if (rand < 0.80) retval = "monster_beez";
		else if (rand < 0.85) retval = "monster_oglib";
		else retval = "monster_sheep"; // Favor sheep slightly more
	} else if (self.style == 2) { // Fodder Military
		if (rand < 0.25) retval = "monster_enforcer";
		else if (rand < 0.50) retval = "monster_dog";
		else if (rand < 0.75) retval = "monster_axegrunt";
		else retval = "monster_army";
	} else if (self.style == 3) { // Fodder Mystic
		if (rand < 0.2) retval = "monster_scorpion";
		else if (rand < 0.4) retval = "monster_wspider";
		else if (rand < 0.6) retval = "monster_spider";
		else if (rand < 0.8) retval = "monster_gargoyle";
		else retval = "monster_impling";
	} else if (self.style == 4) { // Fodder Horrors
		if (rand < 0.18) retval = "monster_lostsoul";
		else if (rand < 0.33) retval = "monster_polyp";
		else if (rand < 0.48) retval = "monster_spikemine";
		else if (rand < 0.66) retval = "monster_swampling";
		else if (rand < 0.82) retval = "monster_voreling";
		else  retval = "monster_wizard";
	} else if (self.style == 5) { // Fodder Brigade
		if (rand < 0.2) retval = "monster_dguard";
		else if (rand < 0.33) retval = "monster_goblin";
		else if (rand < 0.48) retval = "monster_bandit";
		else if (rand < 0.66) retval = "monster_sword";
		else if (rand < 0.8) retval = "monster_rebel";
		else retval = "monster_knight";
	} else if (self.style == 6) { // Ogre Establishment
		if (rand < 0.2) retval = "monster_ogre";
		else if (rand < 0.4) retval = "monster_ogre_marksman";
		else if (rand < 0.6) retval = "monster_ogre_spikeshooter";
		else if (rand < 0.8) retval = "monster_ogre_flak";
		else retval = "monster_hogre";
	} else if (self.style == 7) { // Elite Ogres
		if (rand < 0.33) retval = "monster_ogre_multi";
		else if (rand < 0.66) retval = "monster_hogremac";
		else retval = "monster_hogreham";
	} else if (self.style == 8) { // Undead
		if (rand < 0.33) retval = "monster_zombiek";
		else if (rand < 0.66) retval = "monster_zombiep";
		else retval = "monster_zombie";
	} else if (self.style == 9) { // Midrank Military
		if (rand < 0.11) retval = "monster_army_grenade";
		else if (rand < 0.22) retval = "monster_army_plasma";
		else if (rand < 0.33) retval = "monster_army_rocket";
		else if (rand < 0.44) retval = "monster_defender";
		else if (rand < 0.55) retval = "monster_megaforce";
		else if (rand < 0.66) retval = "monster_jim";
		else if (rand < 0.77) retval = "monster_bob";
		else if (rand < 0.88) retval = "monster_scourge";
		else retval = "monster_floyd";
	} else if (self.style == 10) { // Midrank Mystic
		if (rand < 0.09) retval = "monster_skullwiz";
		else if (rand < 0.18) retval = "monster_acolyte";
		else if (rand < 0.27) retval = "monster_sorceror";
		else if (rand < 0.36) retval = "monster_golem";
		else if (rand < 0.45) retval = "monster_steelclaw";
		else if (rand < 0.54) retval = "monster_gremlin";
		else if (rand < 0.63) retval = "monster_minotaur";
		else if (rand < 0.72) retval = "monster_fallen_angel";
		else if (rand < 0.81) retval = "monster_nemesant";
		else if (rand < 0.90) retval = "monster_troglodyte";
		else retval = "monster_wrath";
	} else if (self.style == 11) { // Midrank Horrors
		if (rand < 0.125) retval = "monster_boil";
		else if (rand < 0.25) retval = "monster_gaunt";
		else if (rand < 0.375) retval = "monster_demon1";
		else if (rand < 0.5) retval = "monster_hell_hound";
		else if (rand < 0.625) retval = "monster_sentinel";
		else if (rand < 0.75) retval = "monster_snakeman";
		else if (rand < 0.875) retval = "monster_oldone_tentacle";
		else retval = "monster_ryu";
	} else if (self.style == 12) { // Midrank Brigade
		if (rand < 0.14) retval = "monster_dcrossbow";
		else if (rand < 0.28) retval = "monster_archer";
		else if (rand < 0.42) retval = "monster_death_guard";
		else if (rand < 0.56) retval = "monster_dknight";
		else if (rand < 0.70) retval = "monster_axeman";
		else if (rand < 0.84) retval = "monster_death_knight";
		else retval = "monster_hell_knight";
	} else if (self.style == 13) { // Elite Military
		if (rand < 0.11) retval = "monster_cyberdemon";
		else if (rand < 0.22) retval = "monster_super_grunt";
		else if (rand < 0.33) retval = "monster_eliminator";
		else if (rand < 0.44) retval = "monster_ultra";
		else if (rand < 0.55) retval = "monster_centurion";
		else if (rand < 0.66) retval = "monster_freddie";
		else if (rand < 0.77) retval = "monster_fumigator";
		else if (rand < 0.88) retval = "monster_pyro";
		else retval = "monster_seeker";
	} else if (self.style == 14) { // Elite Mystic
		if (rand < 0.33) retval = "monster_fallen_angel_lord";
		else if (rand < 0.66) retval = "monster_mummy";
		else retval = "monster_wraith";
	} else if (self.style == 15) { // Elite Horrors
		if (rand < 0.2) retval = "monster_drole";
		else if (rand < 0.33) retval = "monster_shalrath";
		else if (rand < 0.48) retval = "monster_lava_man";
		else if (rand < 0.66) retval = "monster_nightshade";
		else if (rand < 0.8) retval = "monster_tarbaby_mitosis";
		else retval = "monster_tarbaby";
	} else if (self.style == 16) { // Elite Brigade
		if (rand < 0.2) retval = "monster_archer_lord";
		else if (rand < 0.4) retval = "monster_death_lord";
		else if (rand < 0.6) retval = "monster_dfury";
		else if (rand < 0.8) retval = "monster_dsergeant";
		else retval = "monster_hell_knight_champion";
	} else if (self.style == 17) { // Archnidae
		if (rand < 0.125) retval = "monster_scorpion";
		else if (rand < 0.25) retval = "monster_wspider";
		else if (rand < 0.375) retval = "monster_spider";
		else if (rand < 0.5) retval = "monster_shalrath";
		else if (rand < 0.625) retval = "monster_scourge";
		else if (rand < 0.75) retval = "monster_steelclaw";
		else if (rand < 0.875) retval = "monster_swampling";
		else retval = "monster_voreling";
	} else if (self.style == 18) { // Hostile Animals
		if (rand < 0.09) retval = "monster_dog";
		else if (rand < 0.18) retval = "monster_gremlin";
		else if (rand < 0.36) retval = "monster_hell_hound";
		else if (rand < 0.45) retval = "monster_minotaur";
		else if (rand < 0.54) retval = "monster_nightshade";
		else if (rand < 0.63) retval = "monster_ryu";
		else if (rand < 0.72) retval = "monster_scorpion";
		else if (rand < 0.81) retval = "monster_scourge";
		else if (rand < 0.90) retval = "monster_spider";
		else if (rand < 0.95) retval = "monster_wspider";
		else retval = "monster_steelclaw";
	} else if (self.style == 19) { // Fodder Swimmers
		if (rand < 0.4) retval = "monster_eel";
		else retval = "monster_fish"; // Favor fish
	} else if (self.style == 20) { // Midrank Swimmers
		if (rand < 0.4) retval = "monster_hydra";
		else retval = "monster_octa"; // Favor octopi
	} else if (self.style == 21) { // Elite Swimmers
	
		// Nothing yet
	
	} else if (self.style == 22) { // Boss Swimmers
	
		// Don't I wish
	
	} else if (self.style == 23) { // Fodder Terrestrial
		if (rand < 0.06) retval = "monster_enforcer";
		else if (rand < 0.12) retval = "monster_dog";
		else if (rand < 0.18) retval = "monster_axegrunt";
		else if (rand < 0.24) retval = "monster_army";
		else if (rand < 0.30) retval = "monster_scorpion";
		else if (rand < 0.36) retval = "monster_wspider";
		else if (rand < 0.42) retval = "monster_spider";
		else if (rand < 0.48) retval = "monster_swampling";
		else if (rand < 0.54) retval = "monster_voreling";
		else if (rand < 0.60) retval = "monster_dguard";
		else if (rand < 0.66) retval = "monster_goblin";
		else if (rand < 0.72) retval = "monster_bandit";
		else if (rand < 0.78) retval = "monster_sword";
		else if (rand < 0.84) retval = "monster_rebel";
		else retval = "monster_knight"; // Favor ye old standard swordsman
	} else if (self.style == 24) { // Midrank Terrestrial
		if (rand < 0.03) retval = "monster_ogre";
		else if (rand < 0.06) retval = "monster_ogre_marksman"; // Favor ogres
		else if (rand < 0.09) retval = "monster_ogre_spikeshooter";
		else if (rand < 0.12) retval = "monster_ogre_flak";
		else if (rand < 0.15) retval = "monster_hogre";
		else if (rand < 0.18) retval = "monster_army_grenade";
		else if (rand < 0.21) retval = "monster_army_plasma";
		else if (rand < 0.24) retval = "monster_army_rocket";
		else if (rand < 0.27) retval = "monster_defender";
		else if (rand < 0.30) retval = "monster_megaforce";
		else if (rand < 0.33) retval = "monster_scourge";
		else if (rand < 0.36) retval = "monster_floyd";  // Go Map!
		else if (rand < 0.39) retval = "monster_skullwiz";
		else if (rand < 0.42) retval = "monster_acolyte";
		else if (rand < 0.45) retval = "monster_sorceror";
		else if (rand < 0.48) retval = "monster_golem";
		else if (rand < 0.51) retval = "monster_gremlin";
		else if (rand < 0.54) retval = "monster_minotaur";
		else if (rand < 0.57) retval = "monster_boil";
		else if (rand < 0.60) retval = "monster_demon1";
		else if (rand < 0.63) retval = "monster_hell_hound";
		else if (rand < 0.66) retval = "monster_snakeman";
		else if (rand < 0.69) retval = "monster_oldone_tentacle";
		else if (rand < 0.72) retval = "monster_dcrossbow";
		else if (rand < 0.75) retval = "monster_archer";
		else if (rand < 0.78) retval = "monster_death_guard";
		else if (rand < 0.81) retval = "monster_dknight";
		else if (rand < 0.84) retval = "monster_axeman";
		else if (rand < 0.87) retval = "monster_death_knight";
		else if (rand < 0.90) retval = "monster_steelclaw";
		else retval = "monster_hell_knight"; // Favor ye old standard death knight
	} else if (self.style == 37) { // Elite Terrestrial
		if (rand < 0.04) retval = "monster_ogre_multi";
		else if (rand < 0.08) retval = "monster_hogremac";
		else if (rand < 0.12) retval = "monster_hogreham";
		else if (rand < 0.16) retval = "monster_cyberdemon";
		else if (rand < 0.20) retval = "monster_super_grunt";
		else if (rand < 0.24) retval = "monster_eliminator";
		else if (rand < 0.28) retval = "monster_ultra";
		else if (rand < 0.32) retval = "monster_freddie";
		else if (rand < 0.36) retval = "monster_fumigator";
		else if (rand < 0.40) retval = "monster_pyro";
		else if (rand < 0.44) retval = "monster_seeker";
		else if (rand < 0.48) retval = "monster_mummy";
		else if (rand < 0.52) retval = "monster_drole";
		else if (rand < 0.56) retval = "monster_shalrath";
		else if (rand < 0.60) retval = "monster_lava_man";
		else if (rand < 0.64) retval = "monster_tarbaby_mitosis";
		else if (rand < 0.68) retval = "monster_tarbaby";
		else if (rand < 0.72) retval = "monster_archer_lord";
		else if (rand < 0.76) retval = "monster_death_lord";
		else if (rand < 0.80) retval = "monster_dfury";
		else if (rand < 0.84) retval = "monster_dsergeant";
		else retval = "monster_hell_knight_champion"; // Chance favors the champion
	} else if (self.style == 25) { // Boss Terrestrial
		if (rand < 0.03) retval = "monster_morph";
		else if (rand < 0.06) retval = "monster_dark_lord";
		else if (rand < 0.09) retval = "monster_hell_lord";
		else if (rand < 0.12) retval = "monster_hkboss";
		else if (rand < 0.15) retval = "monster_baron";
		else if (rand < 0.18) retval = "monster_baron_fire";
		else if (rand < 0.21) retval = "monster_baron_wind";
		else if (rand < 0.24) retval = "monster_baron_earth";
		else if (rand < 0.27) retval = "monster_baron_water";
		else if (rand < 0.30) retval = "monster_warlock";
		else if (rand < 0.33) retval = "monster_karasu";
		else if (rand < 0.36) retval = "monster_necromancer";
		else if (rand < 0.39) retval = "monster_gug";
		else if (rand < 0.42) retval = "monster_meatwad";
		else if (rand < 0.45) retval = "monster_vomit";
		else if (rand < 0.48) retval = "monster_shamvile";
		else if (rand < 0.51) retval = "monster_shambler"; // Favor shamblers
		else if (rand < 0.54) retval = "monster_armagon";
		else if (rand < 0.57) retval = "monster_bane";
		else if (rand < 0.60) retval = "monster_icegolem";
		else if (rand < 0.63) retval = "monster_lavagolem";
		else if (rand < 0.66) retval = "monster_eidolon";
		else if (rand < 0.69) retval = "monster_wolf";
		else if (rand < 0.72) retval = "monster_oldone";
		else if (rand < 0.75) retval = "monster_boss";
		else if (rand < 0.78) retval = "monster_vermis";
		else if (rand < 0.81) retval = "monster_virtus";
		else if (rand < 0.84) retval = "monster_anac";
		else if (rand < 0.87) retval = "monster_manticore";
		else if (rand < 0.91) retval = "monster_lichfiend";
		else if (rand < 0.95) retval = "monster_nehahra";
		else retval = "monster_boglord";
	} else if (self.style == 26) { // Fodder Flyers
		if (rand < 0.16) retval = "monster_gargoyle";
		else if (rand < 0.32) retval = "monster_impling";
		else if (rand < 0.48) retval = "monster_lostsoul";
		else if (rand < 0.64) retval = "monster_polyp";
		else if (rand < 0.80) retval = "monster_spikemine";
		else  retval = "monster_wizard";
	} else if (self.style == 27) { // Midrank Flyers
		if (rand < 0.125) retval = "monster_jim";
		else if (rand < 0.25) retval = "monster_bob";
		else if (rand < 0.375) retval = "monster_fallen_angel";
		else if (rand < 0.5) retval = "monster_nemesant";
		else if (rand < 0.625) retval = "monster_troglodyte";
		else if (rand < 0.75) retval = "monster_wrath";
		else if (rand < 0.875) retval = "monster_sentinel";
		else retval = "monster_ryu";
	} else if (self.style == 38) { // Elite Flyers
		if (rand < 0.25) retval = "monster_centurion";
		else if (rand < 0.5) retval = "monster_fallen_angel_lord";
		else if (rand < 0.75) retval = "monster_wraith";
		else retval = "monster_nightshade";
	} else if (self.style == 28) { // Boss Flyers
		if (rand < 0.2) retval = "monster_super_wrath";
		else if (rand < 0.4) retval = "monster_ryu_wyrm";
		else if (rand < 0.6) retval = "monster_trogboss";
		else if (rand < 0.8) retval = "monster_dragon";
		else retval = "monster_nour";
	} else if (self.style == 29) { // Denizen Swimmers
		retval = "monster_frog";  // The only one right now.
								  // Will change once jellyfish is added.
	} else if (self.style == 30) { // Denizen Terrestrial
		if (rand < 0.25) retval = "monster_frog";
		else if (rand < 0.5) retval = "monster_ogle";
		else if (rand < 0.6) retval = "monster_oglib";
		else retval = "monster_sheep"; // Favor sheep more
	} else if (self.style == 31) { // Denizen Flyers
		if (rand < 0.33) retval = "monster_raven";
		else if (rand < 0.66) retval = "monster_voidwraith";
		else retval = "monster_beez";
	} else if (self.style == 32) { // Military
		if (rand < 0.045) retval = "monster_enforcer";
		else if (rand < 0.09) retval = "monster_dog";
		else if (rand < 0.135) retval = "monster_axegrunt";
		else if (rand < 0.18) retval = "monster_army";
		else if (rand < 0.225) retval = "monster_army_grenade";
		else if (rand < 0.27) retval = "monster_army_plasma";
		else if (rand < 0.315) retval = "monster_army_rocket";
		else if (rand < 0.36) retval = "monster_defender";
		else if (rand < 0.405) retval = "monster_megaforce";
		else if (rand < 0.45) retval = "monster_jim";
		else if (rand < 0.495) retval = "monster_bob";
		else if (rand < 0.54) retval = "monster_scourge";
		else if (rand < 0.595) retval = "monster_floyd";
		else if (rand < 0.64) retval = "monster_cyberdemon";
		else if (rand < 0.685) retval = "monster_super_grunt";
		else if (rand < 0.73) retval = "monster_eliminator";
		else if (rand < 0.775) retval = "monster_ultra";
		else if (rand < 0.82) retval = "monster_centurion";
		else if (rand < 0.865) retval = "monster_freddie";
		else if (rand < 0.91) retval = "monster_fumigator";
		else if (rand < 0.955) retval = "monster_pyro";
		else retval = "monster_seeker";
	} else if (self.style == 33) { // Mystic
		if (rand < 0.04) retval = "monster_scorpion";
		else if (rand < 0.08) retval = "monster_wspider";
		else if (rand < 0.12) retval = "monster_spider";
		else if (rand < 0.16) retval = "monster_gargoyle";
		else if (rand < 0.20) retval = "monster_impling";
		else if (rand < 0.3) retval = "monster_skullwiz";
		else if (rand < 0.34) retval = "monster_acolyte";
		else if (rand < 0.4) retval = "monster_sorceror";
		else if (rand < 0.44) retval = "monster_golem";
		else if (rand < 0.48) retval = "monster_gremlin";
		else if (rand < 0.56) retval = "monster_minotaur";
		else if (rand < 0.60) retval = "monster_fallen_angel";
		else if (rand < 0.64) retval = "monster_nemesant";
		else if (rand < 0.68) retval = "monster_troglodyte";
		else if (rand < 0.72) retval = "monster_wrath";
		else if (rand < 0.80) retval = "monster_steelclaw";
		else if (rand < 0.84) retval = "monster_fallen_angel_lord";
		else if (rand < 0.92) retval = "monster_mummy";
		else retval = "monster_wraith";
	} else if (self.style == 34) { // Horrors
		if (rand < 0.05) retval = "monster_lostsoul";
		else if (rand < 0.1) retval = "monster_polyp";
		else if (rand < 0.14) retval = "monster_spikemine";
		else if (rand < 0.19) retval = "monster_swampling";
		else if (rand < 0.24) retval = "monster_voreling";
		else if (rand < 0.30) retval = "monster_wizard";
		else if (rand < 0.33) retval = "monster_boil";
		else if (rand < 0.38) retval = "monster_gaunt";
		else if (rand < 0.43) retval = "monster_demon1";
		else if (rand < 0.48) retval = "monster_hell_hound";
		else if (rand < 0.52) retval = "monster_sentinel";
		else if (rand < 0.57) retval = "monster_snakeman";
		else if (rand < 0.62) retval = "monster_ryu";
		else if (rand < 0.67) retval = "monster_drole";
		else if (rand < 0.71) retval = "monster_shalrath";
		else if (rand < 0.83) retval = "monster_lava_man";
		else if (rand < 0.88) retval = "monster_nightshade";
		else if (rand < 0.93) retval = "monster_tarbaby_mitosis";
		else if (rand < 0.96) retval = "monster_shamvile";
		else retval = "monster_tarbaby";
	} else if (self.style == 35) { // Brigade
		if (rand < 0.055) retval = "monster_dguard";
		else if (rand < 0.11) retval = "monster_goblin";
		else if (rand < 0.165) retval = "monster_bandit";
		else if (rand < 0.22) retval = "monster_sword";
		else if (rand < 0.275) retval = "monster_rebel";
		else if (rand < 0.33) retval = "monster_knight";
		else if (rand < 0.385) retval = "monster_dcrossbow";
		else if (rand < 0.44) retval = "monster_archer";
		else if (rand < 0.495) retval = "monster_death_guard";
		else if (rand < 0.55) retval = "monster_dknight";
		else if (rand < 0.605) retval = "monster_axeman";
		else if (rand < 0.66) retval = "monster_death_knight";
		else if (rand < 0.715) retval = "monster_hell_knight";
		else if (rand < 0.76) retval = "monster_archer_lord";
		else if (rand < 0.815) retval = "monster_death_lord";
		else if (rand < 0.87) retval = "monster_dfury";
		else if (rand < 0.935) retval = "monster_dsergeant";
		else retval = "monster_hell_knight_champion";
	} else if (self.style == 36) { // Christmas Ruiners
		if (rand < 0.25) retval = "monster_xmas_elf";
		else if (rand < 0.5) retval = "monster_xmas_raindeer";
		else if (rand < 0.75) retval = "monster_xmas_santa";
		else retval = "monster_xmas_snowman";
	} else if (self.style == 92) { // Boss Ancients
		if (rand < 0.5) retval = "monster_morph";
		else retval = "monster_super_wrath";
	} else if (self.style == 93) { // Boss Medieval Menaces
		if (rand < 0.1) retval = "monster_dark_lord";
		else if (rand < 0.2) retval = "monster_hell_lord";
		else if (rand < 0.3) retval = "monster_hkboss";
		else if (rand < 0.4) retval = "monster_baron";
		else if (rand < 0.5) retval = "monster_baron_fire";
		else if (rand < 0.6) retval = "monster_baron_wind";
		else if (rand < 0.7) retval = "monster_baron_earth";
		else if (rand < 0.8) retval = "monster_baron_water";
		else if (rand < 0.9) retval = "monster_warlock";
		else if (rand < 0.95) retval = "monster_karasu";
		else retval = "monster_necromancer";
	} else if (self.style == 94) { // Boss Eldritch Horrors
		if (rand < 0.2) retval = "monster_gug";
		else if (rand < 0.3) retval = "monster_meatwad";
		else if (rand < 0.4) retval = "monster_vomit";
		else if (rand < 0.5) retval = "monster_shamvile";
		else retval = "monster_shambler"; // Favor shamblers
	} else if (self.style == 95) { // Boss Technological Terrors
		retval = "monster_armagon";
	} else if (self.style == 96) { // Boss Medieval Monstrosities
		if (rand < 0.125) retval = "monster_bane";
		else if (rand < 0.25) retval = "monster_icegolem";
		else if (rand < 0.375) retval = "monster_lavagolem";
		else if (rand < 0.5) retval = "monster_ryu_wyrm";
		else if (rand < 0.625) retval = "monster_eidolon";
		else if (rand < 0.75) retval = "monster_trogboss";
		else if (rand < 0.875) retval = "monster_wolf";
		else retval = "monster_dragon";
	} else if (self.style == 97) { // Boss Eldritch Abominations
		if (rand < 0.1) retval = "monster_oldone";
		else if (rand < 0.2) retval = "monster_boss";
		else if (rand < 0.3) retval = "monster_vermis";
		else if (rand < 0.4) retval = "monster_nour";
		else if (rand < 0.5) retval = "monster_virtus";
		else if (rand < 0.6) retval = "monster_anac";
		else if (rand < 0.7) retval = "monster_manticore";
		else if (rand < 0.8) retval = "monster_lichfiend";
		else if (rand < 0.9) retval = "monster_nehahra";
		else retval = "monster_boglord";
	} else if (self.style == 98) { // Bosses All
		if (rand < 0.02) retval = "monster_morph";
		else if (rand < 0.04) retval = "monster_dark_lord";
		else if (rand < 0.06) retval = "monster_hell_lord";
		else if (rand < 0.08) retval = "monster_hkboss";
		else if (rand < 0.10) retval = "monster_baron";
		else if (rand < 0.12) retval = "monster_baron_fire";
		else if (rand < 0.14) retval = "monster_baron_wind";
		else if (rand < 0.16) retval = "monster_baron_earth";
		else if (rand < 0.18) retval = "monster_baron_water";
		else if (rand < 0.20) retval = "monster_warlock";
		else if (rand < 0.22) retval = "monster_karasu";
		else if (rand < 0.24) retval = "monster_necromancer";
		else if (rand < 0.28) retval = "monster_gug";
		else if (rand < 0.29) retval = "monster_meatwad";
		else if (rand < 0.30) retval = "monster_vomit";
		else if (rand < 0.32) retval = "monster_shamvile";
		else if (rand < 0.36) retval = "monster_armagon";
		else if (rand < 0.40) retval = "monster_bane";
		else if (rand < 0.44) retval = "monster_icegolem";
		else if (rand < 0.48) retval = "monster_lavagolem";
		else if (rand < 0.52) retval = "monster_eidolon";
		else if (rand < 0.56) retval = "monster_wolf";
		else if (rand < 0.60) retval = "monster_oldone";
		else if (rand < 0.64) retval = "monster_boss";
		else if (rand < 0.68) retval = "monster_vermis";
		else if (rand < 0.72) retval = "monster_virtus";
		else if (rand < 0.76) retval = "monster_anac";
		else if (rand < 0.80) retval = "monster_manticore";
		else if (rand < 0.84) retval = "monster_lichfiend";
		else if (rand < 0.86) retval = "monster_nehahra";
		else if (rand < 0.88) retval = "monster_boglord";
		else if (rand < 0.90) retval = "monster_super_wrath";
		else if (rand < 0.92) retval = "monster_ryu_wyrm";
		else if (rand < 0.94) retval = "monster_trogboss";
		else if (rand < 0.96) retval = "monster_dragon";
		else retval = "monster_nour";
	}
	return retval; // Goodness to mergatroid what did I do!
};

void(string mname) BeMonsterFromString = {
	local entity spawner, newspawn, last;

	if (!self.enemy) last = self;
	else last = self.enemy;

	spawner = self;

	newspawn = spawn();
	self = newspawn;
	setorigin(self,spawner.origin);

	// We are a monster to spawn now
	// self.spawnnotelefrag = TRUE; // Prevent spawngibbing ourselves
	self.randomized = TRUE; // Prevent chaosmode randomizing us yet again
	self.owner = last; // Pass through
	spawner.enemy = self;
	self.master = spawner;

	// if (self.spawnflags & 64) self.spawnflags = self.spawnflags - 64; // No delay spawn
	self.classname = mname;
	// if (self.targetname) self.spawnflags = self.spawnflags | 64; // we need to be targeted to spawn, othewise, boom! we are here!
	if (mname == "monster_acolyte") { monster_acolyte(); }
	else if (mname == "monster_afrit") { monster_afrit(); }
	else if (mname == "monster_anac") { monster_anac(); }
	else if (mname == "monster_archer") { monster_archer(); }
	else if (mname == "monster_archer_lord") { monster_archer_lord(); }
	else if (mname == "monster_armagon") { monster_armagon(); }
	else if (mname == "monster_army") { monster_army(); }
	else if (mname == "monster_army_cyborg") { monster_army_cyborg(); }
	else if (mname == "monster_army_grenade") { monster_army_grenade(); }
	else if (mname == "monster_army_plasma") { monster_army_plasma(); }
	else if (mname == "monster_army_rocket") { monster_army_rocket(); }
	else if (mname == "monster_army_spike") { monster_army_spike(); }
	else if (mname == "monster_axegrunt") { monster_axegrunt(); }
	else if (mname == "monster_axeman") { monster_axeman(); }
	else if (mname == "monster_bandit") { monster_bandit(); }
	else if (mname == "monster_bane") { monster_bane(); }
	else if (mname == "monster_baron") { monster_baron(); }
	else if (mname == "monster_baron_fire") { monster_baron_fire(); }
	else if (mname == "monster_baron_wind") { monster_baron_wind(); }
	else if (mname == "monster_baron_earth") { monster_baron_earth(); }
	else if (mname == "monster_baron_water") { monster_baron_water(); }
	else if (mname == "monster_beez") { monster_beez(); }
	else if (mname == "monster_bob") { monster_bob(); }
	else if (mname == "monster_boglord") { monster_boglord(); }
	else if (mname == "monster_boil") { monster_boil(); }
	else if (mname == "monster_boss") { monster_boss(); }
	else if (mname == "monster_carnivean") { monster_carnivean(); }
	else if (mname == "monster_commando") { monster_commando(); }
	else if (mname == "monster_chthon") { monster_chthon(); }
	else if (mname == "monster_coil") { monster_coil(); }
	else if (mname == "monster_coil") { monster_coil(); }
	else if (mname == "monster_cyberdemon") { monster_cyberdemon(); }
	else if (mname == "monster_dark_lord") { monster_dark_lord(); }
	else if (mname == "monster_dcrossbow") { monster_dcrossbow(); }
	else if (mname == "monster_death_guard") { monster_death_guard(); }
	else if (mname == "monster_death_lord") { monster_death_lord(); }
	else if (mname == "monster_defender") { monster_defender(); }
	else if (mname == "monster_deflector") { monster_deflector(); }
	else if (mname == "monster_demon1") { monster_demon1(); }
	else if (mname == "monster_demon") { monster_demon1(); }
	else if (mname == "monster_dfury") { monster_dfury(); }
	else if (mname == "monster_dfury_boss") { monster_dfury_boss(); }
	else if (mname == "monster_dguard") { monster_dguard(); }
	else if (mname == "monster_dknight") { monster_dknight(); }
	else if (mname == "monster_dknightghost") { monster_dknightghost(); }
	else if (mname == "monster_dog") { monster_dog(); }
	else if (mname == "monster_dprince") { monster_dprince(); }
	else if (mname == "monster_dragon") { monster_dragon(); }
	else if (mname == "monster_dreadnaught") { monster_dreadnaught(); }
	else if (mname == "monster_drole") { monster_drole(); }
	else if (mname == "monster_drone") { monster_drone(); }
	else if (mname == "monster_dsergeant") { monster_dsergeant(); }
	else if (mname == "monster_edie") { monster_edie(); }
	else if (mname == "monster_eel") { monster_eel(); }
	else if (mname == "monster_eidolon") { monster_eidolon(); }
	else if (mname == "monster_eliminator") { monster_eliminator(); }
	else if (mname == "monster_enforcer") { monster_enforcer(); }
	// else if (mname == "monster_enf2") { monster_enf2(); }
	// else if (mname == "monster_enf3") { monster_enf3(); }
	else if (mname == "monster_fallen_angel") { monster_fallen_angel(); }
	else if (mname == "monster_fallen_angel_lord") { monster_fallen_angel_lord(); }
	else if (mname == "monster_firetopboss") { monster_firetopboss(); }
	else if (mname == "monster_fish") { monster_fish(); }
	else if (mname == "monster_floyd") { monster_floyd(); }
	else if (mname == "monster_flytrap") { monster_flytrap(); }
	else if (mname == "monster_flytrap_ground") { monster_flytrap_ground(); }
	else if (mname == "monster_fragy") { monster_fragy(); }
	else if (mname == "monster_fragwiz") { monster_fragwiz(); }
	else if (mname == "monster_freddie") { monster_freddie(); }
	else if (mname == "monster_frog") { monster_frog(); }
	else if (mname == "monster_fumigator") { monster_fumigator(); }
	else if (mname == "monster_gargoyle") { monster_gargoyle(); }
	else if (mname == "monster_gaunt") { monster_gaunt(); }
	else if (mname == "monster_goblin") { monster_goblin(); }
	else if (mname == "monster_golem") { monster_golem(); }
	else if (mname == "monster_gremlin") { monster_gremlin(); }
	else if (mname == "monster_guardian") { monster_guardian(); }
	else if (mname == "monster_gug") { monster_gug(); }
	else if (mname == "monster_gunner") { monster_gunner(); }
	else if (mname == "monster_hell_hound") { monster_hell_hound(); }
	else if (mname == "monster_hell_knight") { monster_hell_knight(); }
	else if (mname == "monster_hell_knight2") { monster_hell_knight2(); } // Warlord
	else if (mname == "monster_hell_knight_enforcer") { monster_hell_knight_enforcer(); }
	else if (mname == "monster_hell_knight_champion") { monster_hell_knight_champion(); }
	else if (mname == "monster_hell_lord") { monster_hell_lord(); }
	else if (mname == "monster_hell_pointknight") { monster_hell_pointknight(); }
	else if (mname == "monster_hkboss") { monster_hkboss(); }
	else if (mname == "monster_hogre") { monster_hogre(); }
	else if (mname == "monster_hogreham") { monster_hogreham(); }
	else if (mname == "monster_hogremac") { monster_hogremac(); }
	else if (mname == "monster_huntress") { monster_huntress(); }
	else if (mname == "monster_hydra") { monster_hydra(); }
	else if (mname == "monster_icegolem") { monster_icegolem(); }
	else if (mname == "monster_imp") { monster_imp(); }
	else if (mname == "monster_impling") { monster_impling(); }
	else if (mname == "monster_inquisitor") { monster_inquisitor(); }
	else if (mname == "monster_jim") { monster_jim(); }
	else if (mname == "monster_judgeminion") { monster_judgeminion(); }
	else if (mname == "monster_judicator") { monster_judicator(); }
	else if (mname == "monster_justice") { monster_justice(); }
	else if (mname == "monster_karasu") { monster_karasu(); }
	else if (mname == "monster_knight") { monster_knight(); }
	else if (mname == "monster_lavagolem") { monster_lavagolem(); }
	else if (mname == "monster_lava_man") { monster_lava_man(); }
	else if (mname == "monster_lichfiend") { monster_lichfiend(); }
	else if (mname == "monster_lostsoul") { monster_lostsoul(); }
	else if (mname == "monster_manticore") { monster_manticore(); }
	else if (mname == "monster_mcorn") { monster_mcorn(); }
	else if (mname == "monster_me") { monster_me(); }
	else if (mname == "monster_meatwad") { monster_meatwad(); }
	else if (mname == "monster_megaforce") { monster_megaforce(); }
	else if (mname == "monster_minotaur") { monster_minotaur(); }
	else if (mname == "monster_minotaurminion") { monster_minotaurminion(); }
	// else if (mname == "monster_mistermax") { monster_mistermax(); }
	else if (mname == "monster_morph") { monster_morph(); }
	else if (mname == "monster_mummy") { monster_mummy(); }
	else if (mname == "monster_necromancer") { monster_necromancer(); }
	else if (mname == "monster_necrominiongolem") { monster_necrominiongolem(); }
	else if (mname == "monster_nehahra") { monster_nehahra(); }
	else if (mname == "monster_nemesant") { monster_nemesant(); }
	else if (mname == "monster_newboss") { monster_newboss(); }
	else if (mname == "monster_nightshade") { monster_nightshade(); }
	else if (mname == "monster_nour") { monster_nour(); }
	else if (mname == "monster_nourminion") { monster_nourminion(); }
	else if (mname == "monster_octa") { monster_octa(); }
	else if (mname == "monster_ogle") { monster_ogle(); }
	else if (mname == "monster_oglib") { monster_oglib(); }
	else if (mname == "monster_ogre") { monster_ogre(); }
	else if (mname == "monster_ogre_flak") { monster_ogre_flak(); }
	else if (mname == "monster_ogre_fishing") { monster_ogre_fishing(); }
	else if (mname == "monster_ogre_fishing_ghost") { monster_ogre_fishing_ghost(); }
	else if (mname == "monster_ogre_marksman") { monster_ogre_marksman(); }
	else if (mname == "monster_ogre_multi") { monster_ogre_multi(); }
	else if (mname == "monster_ogre_spikeshooter") { monster_ogre_spikeshooter(); }
	else if (mname == "monster_oldone") { monster_oldone(); }
	else if (mname == "monster_oldone_tentacle") { monster_oldone_tentacle(); }
	else if (mname == "monster_polyp") { monster_polyp(); }
	else if (mname == "monster_pyro") { monster_pyro(); }
	else if (mname == "monster_queen") { monster_queen(); }
	// else if (mname == "monster_ranger") { monster_ranger(); }
	else if (mname == "monster_raven") { monster_raven(); }
	else if (mname == "monster_rebel") { monster_rebel(); }
	else if (mname == "monster_reiver") { monster_reiver(); }
	else if (mname == "monster_ryu") { monster_ryu(); }
	else if (mname == "monster_ryu_wyrm") { monster_ryu_wyrm(); }
	else if (mname == "monster_scorpion") { monster_scorpion(); }
	else if (mname == "monster_scourge") { monster_scourge(); }
	else if (mname == "monster_seeker") { monster_seeker(); }
	else if (mname == "monster_sentinel") { monster_sentinel(); }
	// else if (mname == "monster_servomech") { monster_servomech(); }
	else if (mname == "monster_shalrath") { monster_shalrath(); }
	else if (mname == "monster_shalrath_boss") { monster_shalrath_boss(); }
	else if (mname == "monster_shalrathminion") { monster_shalrathminion(); }
	else if (mname == "monster_shambler") { monster_shambler(); }
	else if (mname == "monster_shamvile") { monster_shamvile(); }
	else if (mname == "monster_sheep") { monster_sheep(); }
	else if (mname == "monster_shub") { monster_shub(); }
	else if (mname == "monster_shubupsd") { monster_shubupsd(); }
	else if (mname == "monster_shuffler") { monster_shuffler(); }
	else if (mname == "monster_skull_wizard_lord") { monster_skull_wizard_lord(); }
	else if (mname == "monster_skullwiz") { monster_skullwiz(); }
	else if (mname == "monster_skullwizminion") { monster_skullwizminion(); }
	else if (mname == "monster_snakeman") { monster_snakeman(); }
	else if (mname == "monster_soldier") { monster_soldier(); }
	else if (mname == "monster_soldier_elite") { monster_soldier_elite(); }
	else if (mname == "monster_sorceror") { monster_sorceror(); }
	else if (mname == "monster_sorcerer") { monster_sorcerer(); } // Typo redirect
	else if (mname == "monster_spellmaster") { monster_spellmaster(); }
	else if (mname == "monster_spider") { monster_spider(); }
	else if (mname == "monster_spikemine") { monster_spikemine(); }
	else if (mname == "monster_spirit") { monster_spirit(); }
	else if (mname == "monster_steelclaw") { monster_steelclaw(); }
	else if (mname == "monster_super_enforcer") { monster_super_enforcer(); }
	else if (mname == "monster_super_grunt") { monster_super_grunt(); }
	else if (mname == "monster_super_wrath") { monster_super_wrath(); }
	else if (mname == "monster_swampling") { monster_swampling(); }
	else if (mname == "monster_sword") { monster_sword(); }
	else if (mname == "monster_tarbaby") { monster_tarbaby(); }
	else if (mname == "monster_tarbaby_mitosis") { monster_tarbaby_mitosis(); }
	else if (mname == "monster_thug") { monster_thug(); }
	else if (mname == "monster_trogboss") { monster_trogboss(); }
	else if (mname == "monster_troglodyte") { monster_troglodyte(); }
	else if (mname == "monster_tur") { monster_tur(); }
	// else if (mname == "monster_turret") { monster_turret(); }
	// else if (mname == "monster_ubs") { monster_ubs(); }
	else if (mname == "monster_ultra") { monster_ultra(); }
	else if (mname == "monster_vermis") { monster_vermis(); }
	else if (mname == "monster_virtus") { monster_virtus(); }
	else if (mname == "monster_voidwraith") { monster_voidwraith(); }
	else if (mname == "monster_vomit") { monster_vomit(); }
	else if (mname == "monster_vomitus") { monster_vomitus(); }
	else if (mname == "monster_voreling") { monster_voreling(); }
	else if (mname == "monster_warlock") { monster_warlock(); }
	else if (mname == "monster_warrior") { monster_warrior(); }
	else if (mname == "monster_wizard") { monster_wizard(); }
	else if (mname == "monster_wolf") { monster_wolf(); }
	else if (mname == "monster_wraith") { monster_wraith(); }
	// else if (mname == "monster_wraith_lord") { monster_wraith_lord(); }
	else if (mname == "monster_wraithminion") { monster_wraithminion(); }
	else if (mname == "monster_wraithminion2") { monster_wraithminion2(); }
	else if (mname == "monster_wrath") { monster_wrath(); }
	else if (mname == "monster_wspider") { monster_wspider(); }
	else if (mname == "monster_yakman") { monster_yakman(); }
	else if (mname == "monster_xmas_elf") { monster_xmas_elf(); }
	else if (mname == "monster_xmas_raindeer") { monster_xmas_raindeer(); }
	else if (mname == "monster_xmas_santa") { monster_xmas_santa(); }
	else if (mname == "monster_xmas_snowman") { monster_xmas_snowman(); }
	else if (mname == "monster_zombie") { monster_zombie(); }
	else if (mname == "monster_zombiek") { monster_zombiek(); }
	// else if (mname == "monster_zombie_master") { monster_zombie_master(); }
	else if (mname == "monster_zombiep") { monster_zombiep(); }

	if (activator) {
		if (activator.flags & FLx_CREATURE && activator.invisible_finished <= time && !Align_Match(self,activator)) {
			self.enemy = activator;
			// self.think1 = FoundTarget;
		}
	}
	dprint("BeMonsterFromString is now a ");
	dprint(self.classname);
	dprint(" at ");
	dprint(vtos(self.origin));
	if (self.enemy) dprint(", and has an enemy\n");
	else dprint("\n");
	newmis = self;
	self = spawner;
};

// A code way to spawn minions
void(string monstername, vector minion_org, entity minion_targ) SpawnMinion = {
	if (entity_pcontent(minion_org)) return; // Check if there is space to spawn entity
	
	update_minioncount(self,1);				// Update spawn counters.  Self = minotaur, there is no egg
	newmis = spawn();
	BeMonsterFromString(monstername);
	setorigin(newmis, minion_org);			// Move to new location
	if (developer > 0) spawn_marker(minion_org, SPNMARK_YELLOW);
	newmis.owner = self;					// Spawner Parent Link
	newmis.enemy = minion_targ;				// Target to attack
	newmis.infightextra = self.infightextra;
	newmis.alignment = self.alignment;
	newmis.temperament = self.temperament;
	newmis.vulnerability = self.vulnerability;
	// Check for poison gibs being cached first
	if (gibpoison && self.poisonous == TRUE) {
		newmis.poisonous = self.poisonous;	// carry over from host spawner 
		newmis.gibtype = GIBTYPE_POISON;	// Poisonous blood trails
	}
	newmis.minion_active = TRUE;			// Minion flag
	newmis.bodyfadeaway = TRUE;				// Get rid of body
	newmis.spawnflags = 0;
	newmis.effects = 0;
	newmis.nextthink = time + 0.01;
	newmis.think = newmis.th_run;
};
 
float(vector spot) SpawnMinionInRadius = {
	local vector vec, dir;

	if (self.minion_count >= self.minion_maxcount) return FALSE;

	if (CheckZeroVector(spot)) spot = self.origin;
	vec = spot + vecrand(0,200,TRUE);
	dir = normalize(vec - spot);
	spot = spot + dir * (self.bbmins_x * 1.5 + random() * 128);
	if (spot_z < self.origin_z) spot_z = self.origin_z;
	self.aflag = find_minionspace(spot);
	if (self.aflag == TRUE) {
		SpawnMinion(self.minion_name,spot,self.owner.enemy);
		return TRUE;
	}
	return FALSE;
};

void() func_spawn_use = {
	local float r;
	local string mname;

	if (self.attack_count >= self.cnt) return;
	if (self.pain_finished > time) return;

	self.attack_count = self.attack_count + 1;
	self.pain_finished = time + self.wait;
	mname = self.spawnclassname;
	if (self.spawnflags & 2) {
		r = random();
		if (r < 0.07 && self.brkobj1 != string_null) 	  mname = self.brkobj1;
		else if (r < 0.14 && self.brkobj2 != string_null) mname = self.brkobj2; 
		else if (r < 0.21 && self.brkobj3 != string_null) mname = self.brkobj3; 
		else if (r < 0.28 && self.brkobj4 != string_null) mname = self.brkobj4; 
		else if (r < 0.35 && self.corner_event != string_null) mname = self.corner_event; 
		else if (r < 0.42 && self.gib1soundx != string_null) mname = self.gib1soundx; 
		else if (r < 0.49 && self.gib2soundx != string_null) mname = self.gib2soundx; 
		else if (r < 0.56 && self.gib3soundx != string_null) mname = self.gib3soundx; 
		else if (r < 0.63 && self.break_template1 != string_null) mname = self.break_template1; 
		else if (r < 0.70 && self.break_template2 != string_null) mname = self.break_template2; 
		else if (r < 0.77 && self.break_template3 != string_null) mname = self.break_template3; 
		else if (r < 0.84 && self.break_template4 != string_null) mname = self.break_template4; 
		else if (r < 1.00 && self.break_template5 != string_null) mname = self.break_template5; 
	}

	dprint("Spawning a ");
	dprint(mname);
	dprint("...");
	BeMonsterFromString(mname);
	dprint("\n");
};

void () func_spawn = {
	if (!self.spawnclassname) self.spawnclassname = "monster_dog";
	precache_monster(self.spawnclassname);
	if (self.minion_name != string_null) monster_checkminion(self.minion_name);

	if (self.wait == 0) self.wait = 0.1;
	else if (self.wait < 0) self.wait = 0;

	if (!self.cnt){
		if (self.count) self.cnt = self.count;
		else self.cnt = 1;
	}
	self.attack_count = 0;

	// Precache 13 random monsters
	if (self.spawnflags & 2) {
		if (self.style == 0) self.style = 99; // Complete random! May God have mercy on your soul!
		if (self.style > 0) {
			self.brkobj1 = GetRandomMonsterName(self.spawnclassname,self.style); // Pass spawnclassname as a backup
			self.brkobj2 = GetRandomMonsterName(self.spawnclassname,self.style);
			self.brkobj3 = GetRandomMonsterName(self.spawnclassname,self.style);
			self.brkobj4 = GetRandomMonsterName(self.spawnclassname,self.style);
			self.corner_event = GetRandomMonsterName(self.spawnclassname,self.style);
			self.gib1soundx = GetRandomMonsterName(self.spawnclassname,self.style);
			self.gib2soundx = GetRandomMonsterName(self.spawnclassname,self.style);
			self.gib3soundx = GetRandomMonsterName(self.spawnclassname,self.style);
			self.break_template1 = GetRandomMonsterName(self.spawnclassname,self.style);
			self.break_template2 = GetRandomMonsterName(self.spawnclassname,self.style);
			self.break_template3 = GetRandomMonsterName(self.spawnclassname,self.style);
			self.break_template4 = GetRandomMonsterName(self.spawnclassname,self.style);
			self.break_template5 = GetRandomMonsterName(self.spawnclassname,self.style);
		}
		if (self.brkobj1 != "") precache_monster(self.brkobj1);
		if (self.brkobj2 != "") precache_monster(self.brkobj2);
		if (self.brkobj3 != "") precache_monster(self.brkobj3);
		if (self.brkobj4 != "") precache_monster(self.brkobj4);
		if (self.corner_event != "") precache_monster(self.corner_event);
		if (self.gib1soundx != "") precache_monster(self.gib1soundx);
		if (self.gib2soundx != "") precache_monster(self.gib2soundx);
		if (self.gib3soundx != "") precache_monster(self.gib3soundx);
		if (self.break_template1 != "") precache_monster(self.break_template1);
		if (self.break_template2 != "") precache_monster(self.break_template2);
		if (self.break_template3 != "") precache_monster(self.break_template3);
		if (self.break_template4 != "") precache_monster(self.break_template4);
		if (self.break_template5 != "") precache_monster(self.break_template5);
	}

	if (self.targetname) {
		self.use = func_spawn_use;
	} else {
		func_spawn_use();
	}
};

// Handy entity for seeing a smaller bounding box in the editor.  That is all.
void () func_spawn_small = { func_spawn (); };

// Should match BeMonsterFromString()'s list
void(string mname) precache_monster = {
	if (framecount > 1) return;

	// dprint("Precaching ");
	// dprint(mname);
	// dprint(".\n");
	if (mname == "monster_acolyte")				necro_cache();
	else if (mname == "monster_afrit")			monster_gargoyle_precache();
	else if (mname == "monster_anac")			monster_anac_precache();
	else if (mname == "monster_archer")			monster_archer_precache();
	else if (mname == "monster_archer_lord") 	monster_archer_precache();
	else if (mname == "monster_armagon")		monster_armagon_precache();
	else if (mname == "monster_army")			monster_army_precache();
	else if (mname == "monster_army_cyborg")	monster_army_precache();
	else if (mname == "monster_army_grenade")	monster_army_precache();
	else if (mname == "monster_army_plasma")	monster_army_precache();
	else if (mname == "monster_army_rocket")	monster_army_precache();
	else if (mname == "monster_army_spike")		monster_army_precache();
	else if (mname == "monster_axegrunt")		monster_axegrunt_precache();
	else if (mname == "monster_axeman")			monster_ax_precache();
	else if (mname == "monster_bandit")			monster_bandit_precache();
	else if (mname == "monster_bane")			monster_bane_precache();
	else if (mname == "monster_baron")			monster_baron_precache();
	else if (mname == "monster_baron_wind")		monster_baron_precache();
	else if (mname == "monster_baron_fire")		monster_baron_precache();
	else if (mname == "monster_baron_earth")	monster_baron_precache();
	else if (mname == "monster_baron_water")	monster_baron_precache();
	else if (mname == "monster_beez")			monster_beez_precache();
	else if (mname == "monster_bob")			monster_jim_precache();
	else if (mname == "monster_boglord")		monster_boglord_precache();
	else if (mname == "monster_boil")			monster_boil_precache();
	else if (mname == "monster_boss")			monster_chthon_precache();
	else if (mname == "monster_carnivean")		monster_carnivean_precache();
	else if (mname == "monster_centurion")		monster_centurion_precache();
	else if (mname == "monster_chthon")			monster_chthon_precache();
	else if (mname == "monster_coil")			monster_coil_precache();
	else if (mname == "monster_commando")		monster_enforcer_precache();
	else if (mname == "monster_cyberdemon")		monster_cyberdemon_precache();
	else if (mname == "monster_dark_lord")		monster_dark_lord_precache();
	else if (mname == "monster_dcrossbow")		monster_dcrossbow_precache();
	else if (mname == "monster_death_guard")	monster_deathguard_precache();
	else if (mname == "monster_deathguard")		monster_deathguard_precache();
	else if (mname == "monster_death_lord")		monster_death_lord_precache();
	else if (mname == "monster_defender")		monster_enforcer_precache();
	else if (mname == "monster_deflector")		monster_deflector_precache();
	else if (mname == "monster_demon1")			monster_demon1_precache();
	else if (mname == "monster_demon")			monster_demon1_precache();
	else if (mname == "monster_dfury")			monster_dfury_precache();
	else if (mname == "monster_dfury_boss")		monster_dfury_boss_precache();
	else if (mname == "monster_dguard")			monster_dguard_precache();
	else if (mname == "monster_dknight") 		monster_dknight_precache();
	else if (mname == "monster_dknightghost") 	monster_dknight_precache();
	else if (mname == "monster_dog")			monster_dog_precache();
	else if (mname == "monster_dprince")		monster_dprince_precache();
	else if (mname == "monster_dragon")			monster_dragon_precache();
	else if (mname == "monster_dreadnaught")	monster_pyro_precache();
	else if (mname == "monster_drole")			monster_drole_precache();
	else if (mname == "monster_drone")			monster_drone_precache();
	else if (mname == "monster_dsergeant")		monster_dsergeant_precache();
	else if (mname == "monster_edie")			monster_freddie_precache();
	else if (mname == "monster_eel")			monster_eel_precache();
	else if (mname == "monster_eidolon")		monster_eidolon_precache();
	else if (mname == "monster_eliminator")		monster_enforcer_precache();
	else if (mname == "monster_enforcer")		monster_enforcer_precache();
	// else if (mname == "monster_enf2")			monster_enf2_precache();
	// else if (mname == "monster_enf3")			monster_enf3_precache();
	else if (mname == "monster_fallen_angel")	monster_fallen_angel_precache();
	else if (mname =="monster_fallen_angel_lord")monster_fallen_angel_precache();
	else if (mname == "monster_firetopboss")	monster_chthon_precache();
	else if (mname == "monster_fish")			monster_fish_precache();
	else if (mname == "monster_floyd")			monster_floyd_precache();
	else if (mname == "monster_flytrap")		monster_flytrap_precache();
	else if (mname == "monster_flytrap_ground")	monster_flytrap_ground_precache();
	else if (mname == "monster_fragy")			monster_fragy_precache();
	else if (mname == "monster_fragwiz")		necro_cache();
	else if (mname == "monster_freddie")		monster_freddie_precache();
	else if (mname == "monster_frog")			monster_fragy_precache();
	else if (mname == "monster_fumigator")		monster_fumigator_precache();
	else if (mname == "monster_gargoyle")		monster_gargoyle_precache();
	else if (mname == "monster_gaunt") 			monster_gaunt_precache();
	else if (mname == "monster_goblin")			monster_bandit_precache();
	else if (mname == "monster_golem")			monster_golem_precache();
	else if (mname == "monster_gremlin")		monster_gremlin_precache();
	else if (mname == "monster_guardian")		monster_morph_precache();
	else if (mname == "monster_gug")			monster_gug_precache();
	else if (mname == "monster_gunner")			monster_enforcer_precache();
	else if (mname == "monster_hell_hound") 	monster_dog_precache();
	else if (mname == "monster_hell_knight")	monster_hell_knight_precache();
	else if (mname == "monster_hell_knight2")	monster_hell_knight2_precache(); // Warlord
	else if(mname=="monster_hell_knight_champion")monster_hell_knight_precache();
	else if(mname=="monster_hell_knight_enforcer")monster_hell_knight_precache();
	else if (mname == "monster_hell_lord")		monster_hell_lord_precache();
	else if (mname == "monster_hell_pointknight")monster_hell_knight_precache();
	else if (mname == "monster_hkboss")			monster_hkboss_precache();
	else if (mname == "monster_hogre")			monster_hogre_precache();
	else if (mname == "monster_hogreham")		monster_hogreham_precache();
	else if (mname == "monster_hogremac")		monster_hogremac_precache();
	else if (mname == "monster_huntress")		monster_huntress_precache();
	else if (mname == "monster_hydra")			monster_hydra_precache();
	else if (mname == "monster_icegolem")		monster_icegolem_precache();
	else if (mname == "monster_imp")			monster_gargoyle_precache();
	else if (mname == "monster_impling")		monster_gargoyle_precache();
	else if (mname == "monster_inquisitor")		monster_inquisitor_precache();
	else if (mname == "monster_jim")			monster_jim_precache();
	else if (mname == "monster_judgeminion")	monster_gaunt_precache();
	else if (mname == "monster_judicator")		monster_judicator_precache();
	else if (mname == "monster_justice")		monster_justice_precache();
	else if (mname == "monster_karasu")			monster_karasu_precache();
	else if (mname == "monster_knight")			monster_knight_precache();
	else if (mname == "monster_lava_man")		monster_lava_man_precache();
	else if (mname == "monster_lavagolem")      monster_lavagolem_precache();
	else if (mname == "monster_lichfiend")		monster_mcorn_precache();
	else if (mname == "monster_lostsoul")		monster_lostsoul_precache();
	else if (mname == "monster_manticore")		monster_mcorn_precache();
	else if (mname == "monster_mcorn")			monster_mcorn_precache();
	else if (mname == "monster_me")				monster_megaforce_precache();
	else if (mname == "monster_meatwad")		monster_vomit_precache();
	else if (mname == "monster_megaforce")		monster_megaforce_precache();
	else if (mname == "monster_minotaur")		monster_minotaur_precache();
	else if (mname == "monster_minotaurminion")	monster_gargoyle_precache();
	// else if (mname == "monster_mistermax")		monster_mistermax_precache();
	else if (mname == "monster_morph")			monster_morph_precache(); // monster_guardian classname redirect
	else if (mname == "monster_mummy")			monster_mummy_precache();
	else if (mname == "monster_necromancer")	necro_cache();
	else if(mname == "monster_necrominiongolem")monster_golem_precache();
	else if (mname == "monster_nehahra")		monster_nehahra_precache();
	else if (mname == "monster_nemesant")		monster_nemesant_precache();
	else if (mname == "monster_newboss")		monster_virtus_precache();
	else if (mname == "monster_nightshade")		monster_nightshade_precache();
	else if (mname == "monster_nour")			monster_nour_precache();
	else if (mname == "monster_nourminion")		monster_wizard_precache();
	else if (mname == "monster_octa")			monster_octa_precache();
	else if (mname == "monster_ogle")			monster_ogle_precache();
	else if (mname == "monster_oglib")			monster_oglib_precache();
	else if (mname == "monster_ogre")			monster_ogre_precache();
	else if (mname == "monster_ogre_marksman")	monster_ogre_precache();
	else if (mname == "monster_ogre_flak")		monster_ogre_spikeshooter_precache();
	else if (mname == "monster_ogre_fishing")	monster_ogre_precache();
	else if (mname=="monster_ogre_fishing_ghost")monster_ogre_precache();
	else if (mname == "monster_ogre_multi")		monster_ogre_precache();
	else if(mname =="monster_ogre_spikeshooter")monster_ogre_spikeshooter_precache();
	else if (mname == "monster_oldone")			monster_shub_precache();
	else if (mname == "monster_oldone_tentacle")monster_oldone_tentacle_precache();
	else if (mname == "monster_polyp")			monster_polyp_precache();
	else if (mname == "monster_pyro")			monster_pyro_precache();
	else if (mname == "monster_queen")			monster_queen_precache();
	// else if (mname == "monster_ranger")			monster_ranger_precache();
	else if (mname == "monster_raven")			monster_raven_precache();
	else if (mname == "monster_rebel")			monster_rebel_precache();
	else if (mname == "monster_reiver")			monster_reiver_precache();
	else if (mname == "monster_ryu")			monster_ryu_precache();
	else if (mname == "monster_ryu_wyrm")		monster_ryu_precache();
	else if (mname == "monster_scorpion")		monster_scorpion_precache();
	else if (mname == "monster_wraithminion2")	monster_scorpion_precache();
	else if (mname == "monster_scourge") 		monster_scourge_precache();
	else if (mname == "monster_seeker")			monster_seeker_precache();
	else if (mname == "monster_sentinel")		monster_sentinel_precache();
	// else if (mname == "monster_servomech")		monster_servomech_precache();
	else if (mname == "monster_shalrath")		monster_shalrath_precache();
	else if (mname == "monster_shalrath_boss")	monster_shalrath_boss_precache();
	else if (mname == "monster_shalrathminion")	monster_voreling_precache();
	else if (mname == "monster_shambler")		monster_shambler_precache();
	else if (mname == "monster_shamvile")		monster_shambler_precache();
	else if (mname == "monster_sheep")			monster_sheep_precache();
	else if (mname == "monster_shub")			monster_shub_precache();
	else if (mname == "monster_shubupsd")		monster_shub_precache();
	else if (mname == "monster_shuffler")		monster_minotaur_precache();
	else if (mname == "monster_skullwiz")		monster_skullwiz_precache();
	else if (mname == "monster_skullwizminion")	monster_lostsoul_precache();
	else if (mname =="monster_skull_wizard_lord")monster_skullwiz_precache();
	else if (mname == "monster_snakeman")		monster_snakeman_precache();
	else if (mname == "monster_soldier")		monster_army_precache();
	else if (mname == "monster_soldier_elite")	monster_army_precache();
	else if (mname == "monster_sorcerer")		necro_cache();
	else if (mname == "monster_sorceror")		necro_cache();
	else if (mname == "monster_spellmaster")	monster_spellmaster_precache();
	else if (mname == "monster_spider")			monster_spider_precache();
	else if (mname == "monster_spikemine")		monster_spikemine_precache();
	else if (mname == "monster_spirit")			monster_spirit_precache();
	else if (mname == "trap_spike_mine")		monster_spikemine_precache();
	else if (mname == "monster_steelclaw")		monster_steelclaw_precache();
	else if (mname == "monster_super_enforcer")	monster_enforcer_precache();
	else if (mname == "monster_super_grunt")	monster_super_grunt_precache();
	else if (mname == "monster_super_wrath")	monster_super_wrath_precache();
	else if (mname == "monster_swampling")		monster_swampling_precache();
	else if (mname == "monster_sword")			monster_sword_precache();
	else if (mname == "monster_tarbaby")		monster_tarbaby_precache();
	else if (mname == "monster_tarbaby_mitosis")monster_tarbaby_precache();
	else if (mname == "monster_thug")			monster_ax_precache();
	else if (mname == "monster_trogboss")		monster_nemesant_precache();
	else if (mname == "monster_troglodyte")		monster_nemesant_precache();
	else if (mname == "monster_tur")			monster_tur_precache();
	// else if (mname == "monster_turret")		monster_turret_precache();
	// else if (mname == "monster_ubs")			monster_ubs_precache();
	else if (mname == "monster_ultra")			monster_enforcer_precache();
	else if (mname == "monster_vermis")			monster_vermis_precache();
	else if (mname == "monster_virtus")			monster_virtus_precache();
	else if (mname == "monster_voidwraith")		monster_voidwraith_precache();
	else if (mname == "monster_vomit")			monster_vomit_precache();
	else if (mname == "monster_vomitus")		monster_vomit_precache();
	else if (mname == "monster_voreling")		monster_voreling_precache();
	else if (mname == "monster_warlock")		necro_cache();
	else if (mname == "monster_warrior")		monster_knight_precache();
	else if (mname == "monster_wizard")			monster_wizard_precache();
	else if (mname == "monster_wolf")			monster_wolf_precache();
	else if (mname == "monster_wraith")			monster_wraith_precache();
	// else if (mname == "monster_wraith_lord")	monster_wraith_lord_precache();
	else if (mname == "monster_wraithminion")	monster_spider_precache();
	else if (mname == "monster_wraithminion2")	monster_scorpion_precache();
	else if (mname == "monster_wrath")			monster_wrath_precache();
	else if (mname == "monster_wspider")		monster_wspider_precache();
	else if (mname == "monster_xmas_elf")		monster_xmas_elf_precache();
	else if (mname == "monster_xmas_raindeer")	monster_xmas_raindeer_precache();
	else if (mname == "monster_xmas_santa")		monster_xmas_santa_precache();
	else if (mname == "monster_xmas_snowman")	monster_xmas_snowman_precache();
	else if (mname == "monster_yakman")			monster_minotaur_precache();
	else if (mname == "monster_zombie")			monster_zombie_precache();
	else if (mname == "monster_zombiek")		monster_zombiek_precache();
	// else if (mname == "monster_zombie_master")	monster_zombie_master_precache();
	else if (mname == "monster_zombiep")		monster_zombiep_precache();
};
// May the Lord look upon you and give you peace
// And may he forgive me for what may come from this
// Unholy function...
string(string old, float type) GetRandomMonsterName = {
	local string retval;
	local float rand;

	retval = old; // in case something bad happens
	rand = random();

	// Are you sure?  Like...really really?  REALLY????
	// Ok, let's pick ANY MONSTER EVER...aaand go!!
	if (type == 99) {
		// More than 100 monsters so I'll split it
		if (random() < 0.5) {
			if (rand < 0.01) retval = "monster_acolyte";
			if (rand < 0.02) retval = "monster_anac";
			if (rand < 0.03) retval = "monster_archer";
			if (rand < 0.04) retval = "monster_archer_lord";
			if (rand < 0.05) retval = "monster_armagon";
			if (rand < 0.06) retval = "monster_army";
			if (rand < 0.07) retval = "monster_army_grenade";
			if (rand < 0.08) retval = "monster_army_plasma";
			if (rand < 0.09) retval = "monster_army_rocket";
			if (rand < 0.10) retval = "monster_axegrunt";
			if (rand < 0.11) retval = "monster_axeman";
			if (rand < 0.12) retval = "monster_bandit";
			if (rand < 0.13) retval = "monster_bane";
			if (rand < 0.14) retval = "monster_baron";
			if (rand < 0.15) retval = "monster_boglord";
			if (rand < 0.16) retval = "monster_boil";
			if (rand < 0.17) retval = "monster_boss";
			if (rand < 0.18) retval = "monster_centurion";
			if (rand < 0.19) retval = "monster_chthon";
			if (rand < 0.20) retval = "monster_cyberdemon";
			if (rand < 0.21) retval = "monster_dark_lord";
			if (rand < 0.22) retval = "monster_dcrossbow";
			if (rand < 0.23) retval = "monster_death_guard";
			if (rand < 0.24) retval = "monster_death_lord";
			if (rand < 0.25) retval = "monster_defender";
			if (rand < 0.26) retval = "monster_demon1";
			if (rand < 0.27) retval = "monster_demon";
			if (rand < 0.28) retval = "monster_dfury";
			if (rand < 0.29) retval = "monster_dguard";
			if (rand < 0.30) retval = "monster_dknight";
			if (rand < 0.31) retval = "monster_dog";
			if (rand < 0.32) retval = "monster_dragon";
			if (rand < 0.33) retval = "monster_drole";
			if (rand < 0.34) retval = "monster_dsergeant";
			if (rand < 0.35) retval = "monster_edie";
			if (rand < 0.36) retval = "monster_eel";
			if (rand < 0.37) retval = "monster_eidolon";
			if (rand < 0.38) retval = "monster_eliminator";
			if (rand < 0.39) retval = "monster_enforcer";
			if (rand < 0.40) retval = "monster_fallen_angel";
			if (rand < 0.41) retval = "monster_fallen_angel_lord";
			if (rand < 0.42) retval = "monster_firetopboss";
			if (rand < 0.43) retval = "monster_fish";
			if (rand < 0.44) retval = "monster_floyd";
			if (rand < 0.45) retval = "monster_freddie";
			if (rand < 0.46) retval = "monster_fumigator";
			if (rand < 0.47) retval = "monster_gargoyle";
			if (rand < 0.48) retval = "monster_gaunt";
			if (rand < 0.49) retval = "monster_goblin";
			if (rand < 0.50) retval = "monster_golem";
			if (rand < 0.51) retval = "monster_gremlin";
			if (rand < 0.52) retval = "monster_gug";
			if (rand < 0.53) retval = "monster_hell_hound";
			if (rand < 0.54) retval = "monster_hell_knight";
			if (rand < 0.55) retval = "monster_hell_knight_champion";
			if (rand < 0.56) retval = "monster_hell_lord";
			if (rand < 0.57) retval = "monster_hell_pointknight";
			if (rand < 0.58) retval = "monster_hkboss";
			if (rand < 0.59) retval = "monster_hogre";
			if (rand < 0.60) retval = "monster_hogreham";
			if (rand < 0.61) retval = "monster_hogremac";
			if (rand < 0.62) retval = "monster_hydra";
			if (rand < 0.63) retval = "monster_icegolem";
			if (rand < 0.64) retval = "monster_impling";
			if (rand < 0.67) retval = "monster_inquisitor";
			if (rand < 0.68) retval = "monster_jim";
			if (rand < 0.69) retval = "monster_knight";
			if (rand < 0.70) retval = "monster_lava_man";
			if (rand < 0.71) retval = "monster_lostsoul";
			if (rand < 0.72) retval = "monster_meatwad";
			if (rand < 0.73) retval = "monster_minotaur";
			if (rand < 0.74) retval = "monster_morph";
			if (rand < 0.75) retval = "monster_mummy";
			if (rand < 0.76) retval = "monster_necromancer";
			if (rand < 0.77) retval = "monster_nemesant";
			if (rand < 0.78) retval = "monster_nightshade";
			if (rand < 0.79) retval = "monster_nour";
			if (rand < 0.80) retval = "monster_octa";
			if (rand < 0.81) retval = "monster_ogre";
			if (rand < 0.82) retval = "monster_ogre_flak";
			if (rand < 0.83) retval = "monster_ogre_multi";
			if (rand < 0.84) retval = "monster_oldone";
			if (rand < 0.85) retval = "monster_polyp";
			if (rand < 0.86) retval = "monster_pyro";
			if (rand < 0.87) retval = "monster_ryu";
			if (rand < 0.88) retval = "monster_ryu_wyrm";
			if (rand < 0.89) retval = "monster_scorpion";
			if (rand < 0.90) retval = "monster_scourge";
			if (rand < 0.91) retval = "monster_seeker";
			if (rand < 0.92) retval = "monster_sentinel";
			if (rand < 0.93) retval = "monster_shalrath";
			if (rand < 0.94) retval = "monster_shambler";
			if (rand < 0.95) retval = "monster_shub";
			if (rand < 0.96) retval = "monster_shubupsd";
			if (rand < 0.97) retval = "monster_skullwiz";
			if (rand < 0.98) retval = "monster_snakeman";
			if (rand < 0.99) retval = "monster_sorceror"; // 99
			if (rand < 1) 	 retval = "monster_spider"; // 100!  Ok...we ran out of slots in random...not really, but I'm counting on poor precision here so...yeah
		} else {
			if (rand < 0.01) retval = "monster_spikemine";
			if (rand < 0.02) retval = "monster_super_grunt";
			if (rand < 0.03) retval = "monster_super_wrath";
			if (rand < 0.04) retval = "monster_swampling";
			if (rand < 0.05) retval = "monster_sword";
			if (rand < 0.06) retval = "monster_tarbaby";
			if (rand < 0.07) retval = "monster_tarbaby_mitosis";
			if (rand < 0.08) retval = "monster_sword";
			if (rand < 0.09) retval = "monster_trogboss";
			if (rand < 0.10) retval = "monster_troglodyte";
			if (rand < 0.11) retval = "monster_vermis";
			if (rand < 0.12) retval = "monster_virtus";
			if (rand < 0.13) retval = "monster_vomitus";
			if (rand < 0.14) retval = "monster_voreling";
			if (rand < 0.15) retval = "monster_warlock";
			if (rand < 0.16) retval = "monster_wizard";
			if (rand < 0.17) retval = "monster_wraith";
			if (rand < 0.18) retval = "monster_wrath";
			if (rand < 0.19) retval = "monster_wspider";
			if (rand < 0.20) retval = "monster_zombie";
			if (rand < 0.21) retval = "monster_zombiek";
			if (rand < 0.22) retval = "monster_zombiep";
			if (rand < 0.23) retval = "monster_reiver";
			if (rand < 0.24) retval = "monster_carnivean";
			if (rand < 0.25) retval = "monster_shalrath_boss";
			if (rand < 0.26) retval = "monster_dfury_boss";
			if (rand < 0.27) retval = "monster_oldone_tentacle";
			if (rand < 1) retval = "monster_hell_knight2";
			// if (rand < 0.29) retval = "monster_acolyte"; // More slots for when I add more, yeesh!
			// if (rand < 0.30) retval = "monster_acolyte";
			// if (rand < 0.31) retval = "monster_acolyte";
			// if (rand < 0.32) retval = "monster_acolyte";
			// if (rand < 0.33) retval = "monster_acolyte";
			// if (rand < 0.34) retval = "monster_acolyte";
			// if (rand < 0.35) retval = "monster_acolyte";
			// if (rand < 0.36) retval = "monster_acolyte";
			// if (rand < 0.37) retval = "monster_acolyte";
			// if (rand < 0.38) retval = "monster_acolyte";
			// if (rand < 0.39) retval = "monster_acolyte";
			// if (rand < 0.40) retval = "monster_acolyte";
			// if (rand < 0.41) retval = "monster_acolyte";
			// if (rand < 0.42) retval = "monster_acolyte";
			// if (rand < 0.43) retval = "monster_acolyte";
			// if (rand < 0.44) retval = "monster_acolyte";
			// if (rand < 0.45) retval = "monster_acolyte";
			// if (rand < 0.46) retval = "monster_acolyte";
			// if (rand < 0.47) retval = "monster_acolyte";
			// if (rand < 0.48) retval = "monster_acolyte";
			// if (rand < 0.49) retval = "monster_acolyte";
			// if (rand < 0.50) retval = "monster_acolyte";
			// if (rand < 0.51) retval = "monster_acolyte";
			// if (rand < 0.52) retval = "monster_acolyte";
			// if (rand < 0.53) retval = "monster_acolyte";
			// if (rand < 0.54) retval = "monster_acolyte";
			// if (rand < 0.55) retval = "monster_acolyte";
			// if (rand < 0.56) retval = "monster_acolyte";
			// if (rand < 0.57) retval = "monster_acolyte";
			// if (rand < 0.58) retval = "monster_acolyte";
			// if (rand < 0.59) retval = "monster_acolyte";
			// if (rand < 0.60) retval = "monster_acolyte";
			// if (rand < 0.61) retval = "monster_acolyte";
			// if (rand < 0.62) retval = "monster_acolyte";
			// if (rand < 0.63) retval = "monster_acolyte";
			// if (rand < 0.64) retval = "monster_acolyte";
			// if (rand < 0.67) retval = "monster_acolyte";
			// if (rand < 0.68) retval = "monster_acolyte";
			// if (rand < 0.69) retval = "monster_acolyte";
			// if (rand < 0.70) retval = "monster_acolyte";
			// if (rand < 0.71) retval = "monster_acolyte";
			// if (rand < 0.72) retval = "monster_acolyte";
			// if (rand < 0.73) retval = "monster_acolyte";
			// if (rand < 0.74) retval = "monster_acolyte";
			// if (rand < 0.75) retval = "monster_acolyte";
			// if (rand < 0.76) retval = "monster_acolyte";
			// if (rand < 0.77) retval = "monster_acolyte";
			// if (rand < 0.78) retval = "monster_acolyte";
			// if (rand < 0.79) retval = "monster_acolyte";
			// if (rand < 0.80) retval = "monster_acolyte";
			// if (rand < 0.81) retval = "monster_acolyte";
			// if (rand < 0.82) retval = "monster_acolyte";
			// if (rand < 0.83) retval = "monster_acolyte";
			// if (rand < 0.84) retval = "monster_acolyte";
			// if (rand < 0.85) retval = "monster_acolyte";
			// if (rand < 0.86) retval = "monster_acolyte";
			// if (rand < 0.87) retval = "monster_acolyte";
			// if (rand < 0.88) retval = "monster_acolyte";
			// if (rand < 0.89) retval = "monster_acolyte";
			// if (rand < 0.90) retval = "monster_acolyte";
			// if (rand < 0.91) retval = "monster_acolyte";
			// if (rand < 0.92) retval = "monster_acolyte";
			// if (rand < 0.93) retval = "monster_acolyte";
			// if (rand < 0.94) retval = "monster_acolyte";
			// if (rand < 0.95) retval = "monster_acolyte";
			// if (rand < 0.96) retval = "monster_acolyte";
			// if (rand < 0.97) retval = "monster_acolyte";
			// if (rand < 0.98) retval = "monster_acolyte";
			// if (rand < 0.99) retval = "monster_acolyte"; // 199
			// if (rand < 1) 	 retval = "monster_acolyte"; // 200!  Do we have enough choices, yeesh!
		}
	}
	return retval; // Goodness to mergatroidd what did I do!
};

void(string mname) BeMonsterFromString = {
	local entity stemp, newspawn;
	local float numloops;

	if (self.count == 0) {
		if (self.cnt != 0) self.count = self.cnt; // give the mapper a chance in case he's forgetful or didn't read the manual
		if (self.count == 0) self.count = 1; // spawn at least 1 monster
	}

	if (self.count > 99) self.count = 99; // Prevent engines from thinking we are in a runaway loop by doing less than 100
	numloops = self.count;
	stemp = self;
	while (numloops > 0) {
		dprint(ftos(self.count));
		dprint(".");
		if (self.spawnflags & LIGHTNING_RANDOM) mname = GetRandomMonsterName(mname,99); // May God have mercy on your soul!
		numloops = numloops - 1;
		self = stemp; // !!  Oi vey, whatchya doing there Qmaster??  It's fine, look up a few lines
		stemp = self;
		newspawn = spawn();
		self = newspawn;
		copyentity(stemp,self);
		self.spawnnotelefrag = TRUE; // Prevent spawngibbing ourselves
		self.randomized = TRUE; // Prevent chaosmode randomizing us yet again
		if (newspawn == world) self.count = 0; // we failed somehow ... but we'll try one last time...
		self.classname = mname;
		if (self.targetname) self.spawnflags = self.spawnflags | 64; // we need to be targeted to spawn, othewise, boom! we are here!
		if (mname == "monster_acolyte") { monster_acolyte(); continue; }
		if (mname == "monster_anac") { monster_anac(); continue; }
		if (mname == "monster_archer") { monster_archer(); continue; }
		if (mname == "monster_archer_lord") { monster_archer_lord(); continue; }
		if (mname == "monster_armagon") { monster_armagon(); continue; }
		if (mname == "monster_army") { monster_army(); continue; }
		if (mname == "monster_army_grenade") { monster_army_grenade(); continue; }
		if (mname == "monster_army_plasma") { monster_army_plasma(); continue; }
		if (mname == "monster_army_rocket") { monster_army_rocket(); continue; }
		if (mname == "monster_axegrunt") { monster_axegrunt(); continue; }
		if (mname == "monster_axeman") { monster_axeman(); continue; }
		if (mname == "monster_bandit") { monster_bandit(); continue; }
		if (mname == "monster_bane") { monster_bane(); continue; }
		if (mname == "monster_baron") { monster_baron(); continue; }
		if (mname == "monster_boglord") { monster_boglord(); continue; }
		if (mname == "monster_boil") { monster_boil(); continue; }
		if (mname == "monster_boss") { monster_boss(); continue; }
		if (mname == "monster_centurion") { monster_centurion(); continue; }
		if (mname == "monster_chthon") { monster_chthon(); continue; }
		if (mname == "monster_cyberdemon") { monster_cyberdemon(); continue; }
		if (mname == "monster_dark_lord") { monster_dark_lord(); break; }
		if (mname == "monster_dcrossbow") { monster_dcrossbow(); break; }
		if (mname == "monster_death_guard") { monster_death_guard(); break; }
		if (mname == "monster_death_lord") { monster_death_lord(); break; }
		if (mname == "monster_defender") { monster_defender(); break; }
		if (mname == "monster_demon1") { monster_demon1(); break; }
		if (mname == "monster_demon") { monster_demon1(); break; }
		if (mname == "monster_dfury") { monster_dfury(); break; }
		if (mname == "monster_dguard") { monster_dguard(); break; }
		if (mname == "monster_dknight") { monster_dknight(); break; }
		if (mname == "monster_dog") { monster_dog(); continue; }
		if (mname == "monster_dragon") { monster_dragon(); continue; }
		if (mname == "monster_drole") { monster_drole(); continue; }
		if (mname == "monster_dsergeant") { monster_dsergeant(); continue; }
		if (mname == "monster_edie") { monster_edie(); continue; }
		if (mname == "monster_eel") { monster_eel(); continue; }
		if (mname == "monster_eidolon") { monster_eidolon(); continue; }
		if (mname == "monster_eliminator") { monster_eliminator(); continue; }
		if (mname == "monster_enforcer") { monster_enforcer(); continue; }
		if (mname == "monster_fallen_angel") { monster_fallen_angel(); continue; }
		if (mname == "monster_fallen_angel_lord") { monster_fallen_angel_lord(); continue; }
		if (mname == "monster_firetopboss") { monster_firetopboss(); continue; }
		if (mname == "monster_fish") { monster_fish(); continue; }
		if (mname == "monster_floyd") { monster_floyd(); continue; }
		if (mname == "monster_freddie") { monster_freddie(); continue; }
		if (mname == "monster_fumigator") { monster_fumigator(); continue; }
		if (mname == "monster_gargoyle") { monster_gargoyle(); continue; }
		if (mname == "monster_gaunt") { monster_gaunt(); continue; }
		if (mname == "monster_goblin") { monster_goblin(); continue; }
		if (mname == "monster_golem") { monster_golem(); continue; }
		if (mname == "monster_gremlin") { monster_gremlin(); continue; }
		if (mname == "monster_gug") { monster_gug(); continue; }
		if (mname == "monster_hell_hound") { monster_hell_hound(); continue; }
		if (mname == "monster_hell_knight") { monster_hell_knight(); continue; }
		if (mname == "monster_hell_knight_champion") { monster_hell_knight_champion(); continue; }
		if (mname == "monster_hell_lord") { monster_hell_lord(); continue; }
		if (mname == "monster_hell_pointknight") { monster_hell_pointknight(); continue; }
		if (mname == "monster_hkboss") { monster_hkboss(); continue; }
		if (mname == "monster_hogre") { monster_hogre(); continue; }
		if (mname == "monster_hogreham") { monster_hogreham(); continue; }
		if (mname == "monster_hogremac") { monster_hogremac(); continue; }
		if (mname == "monster_hydra") { monster_hydra(); continue; }
		if (mname == "monster_icegolem") { monster_icegolem(); continue; }
		if (mname == "monster_impling") { monster_impling(); continue; }
		if (mname == "monster_inquisitor") { monster_inquisitor(); continue; }
		if (mname == "monster_jim") { monster_jim(); continue; }
		if (mname == "monster_knight") { monster_knight(); continue; }
		if (mname == "monster_lava_man") { monster_lava_man(); continue; }
		if (mname == "monster_lostsoul") { monster_lostsoul(); continue; }
		if (mname == "monster_meatwad") { monster_meatwad(); continue; }
		if (mname == "monster_minotaur") { monster_minotaur(); continue; }
		if (mname == "monster_morph") { monster_morph(); continue; }
		if (mname == "monster_mummy") { monster_mummy(); continue; }
		if (mname == "monster_necromancer") { monster_necromancer(); continue; }
		if (mname == "monster_nemesant") { monster_nemesant(); continue; }
		if (mname == "monster_nightshade") { monster_nightshade(); continue; }
		if (mname == "monster_nour") { monster_nour(); continue; }
		if (mname == "monster_octa") { monster_octa(); continue; }
		if (mname == "monster_ogre") { monster_ogre(); continue; }
		if (mname == "monster_ogre_flak") { monster_ogre_flak(); continue; }
		if (mname == "monster_ogre_multi") { monster_ogre_multi(); continue; }
		if (mname == "monster_oldone") { monster_oldone(); continue; }
		if (mname == "monster_polyp") { monster_polyp(); continue; }
		if (mname == "monster_pyro") { monster_pyro(); continue; }
		if (mname == "monster_ryu") { monster_ryu(); continue; }
		if (mname == "monster_ryu_wyrm") { monster_ryu_wyrm(); continue; }
		if (mname == "monster_scorpion") { monster_scorpion(); continue; }
		if (mname == "monster_scourge") { monster_scourge(); continue; }
		if (mname == "monster_seeker") { monster_seeker(); continue; }
		if (mname == "monster_sentinel") { monster_sentinel(); continue; }
		if (mname == "monster_shalrath") { monster_shalrath(); continue; }
		if (mname == "monster_shambler") { monster_shambler(); continue; }
		if (mname == "monster_shub") { monster_shub(); continue; }
		if (mname == "monster_shubupsd") { monster_shubupsd(); continue; }
		if (mname == "monster_skullwiz") { monster_skullwiz(); continue; }
		if (mname == "monster_snakeman") { monster_snakeman(); continue; }
		if (mname == "monster_sorceror") { monster_sorceror(); continue; }
		if (mname == "monster_spider") { monster_spider(); continue; }
		if (mname == "monster_spikemine") { monster_spikemine(); continue; }
		if (mname == "monster_super_grunt") { monster_super_grunt(); continue; }
		if (mname == "monster_super_wrath") { monster_super_wrath(); continue; }
		if (mname == "monster_swampling") { monster_swampling(); continue; }
		if (mname == "monster_sword") { monster_sword(); continue; }
		if (mname == "monster_tarbaby") { monster_tarbaby(); continue; }
		if (mname == "monster_tarbaby_mitosis") { monster_tarbaby_mitosis(); continue; }
		if (mname == "monster_sword") { monster_sword(); continue; }
		if (mname == "monster_trogboss") { monster_trogboss(); continue; }
		if (mname == "monster_troglodyte") { monster_troglodyte(); continue; }
		if (mname == "monster_vermis") { monster_vermis(); continue; }
		if (mname == "monster_virtus") { monster_virtus(); continue; }
		if (mname == "monster_vomitus") { monster_vomitus(); continue; }
		if (mname == "monster_voreling") { monster_voreling(); continue; }
		if (mname == "monster_warlock") { monster_warlock(); continue; }
		if (mname == "monster_wizard") { monster_wizard(); continue; }
		if (mname == "monster_wraith") { monster_wraith(); continue; }
		if (mname == "monster_wrath") { monster_wrath(); continue; }
		if (mname == "monster_wspider") { monster_wspider(); continue; }
		if (mname == "monster_zombie") { monster_zombie(); continue; }
		if (mname == "monster_zombiek") { monster_zombiek(); continue; }
		if (mname == "monster_zombiep") { monster_zombiep(); continue; }
		if (mname == "monster_reiver") { monster_reiver(); continue; }
		if (mname == "monster_carnivean") { monster_carnivean(); continue; }
		if (mname == "monster_shalrath_boss") { monster_shalrath_boss(); continue; }
		if (mname == "monster_dfury_boss") { monster_dfury_boss(); continue; }
		if (mname == "monster_oldone_tentacle") { monster_oldone_tentacle(); continue; }
		if (mname == "monster_hell_knight2") { monster_hell_knight2(); continue; } // Warlord
	}
	dprint("\n");
};

void() func_spawn_use = {
	BeMonsterFromString(self.spawnclassname);
};

void () func_spawn = {
	if (!self.spawnclassname) self.spawnclassname = "monster_dog";
	dprint("Spawning a ");
	dprint(self.spawnclassname);
	dprint("...");
	if (self.targetname) {
		self.use = func_spawn_use;
	} else {
		func_spawn_use();
	}
};

// Handy entity for seeing a smaller bounding box in the editor.  That is all.
void () func_spawn_small = { func_spawn (); };
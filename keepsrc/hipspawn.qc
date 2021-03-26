void(string mname) BeMonsterFromString = {
	self.classname = mname;
	if (self.targetname) self.spawnflags = self.spawnflags | 64; // we need to be targeted
	if (mname == "monster_acolyte") { monster_acolyte(); return; }
	if (mname == "monster_anac") { monster_anac(); return; }
	if (mname == "monster_archer") { monster_archer(); return; }
	if (mname == "monster_archer_lord") { monster_archer_lord(); return; }
	if (mname == "monster_armagon") { monster_armagon(); return; }
	if (mname == "monster_army") { monster_army(); return; }
	if (mname == "monster_army_grenade") { monster_army_grenade(); return; }
	if (mname == "monster_army_plasma") { monster_army_plasma(); return; }
	if (mname == "monster_army_rocket") { monster_army_rocket(); return; }
	if (mname == "monster_axegrunt") { monster_axegrunt(); return; }
	if (mname == "monster_axeman") { monster_axeman(); return; }
	if (mname == "monster_bandit") { monster_bandit(); return; }
	if (mname == "monster_bane") { monster_bane(); return; }
	if (mname == "monster_baron") { monster_baron(); return; }
	if (mname == "monster_boglord") { monster_boglord(); return; }
	if (mname == "monster_boil") { monster_boil(); return; }
	if (mname == "monster_boss") { monster_boss(); return; }
	if (mname == "monster_centurion") { monster_centurion(); return; }
	if (mname == "monster_chthon") { monster_chthon(); return; }
	if (mname == "monster_cyberdemon") { monster_cyberdemon(); return; }
	if (mname == "monster_dark_lord") { monster_dark_lord(); return; }
	if (mname == "monster_dcrossbow") { monster_dcrossbow(); return; }
	if (mname == "monster_death_guard") { monster_death_guard(); return; }
	if (mname == "monster_death_lord") { monster_death_lord(); return; }
	if (mname == "monster_defender") { monster_defender(); return; }
	if (mname == "monster_demon1") { monster_demon1(); return; }
	if (mname == "monster_demon") { monster_demon1(); return; }
	if (mname == "monster_dfury") { monster_dfury(); return; }
	if (mname == "monster_dguard") { monster_dguard(); return; }
	if (mname == "monster_dknight") { monster_dknight(); return; }
	if (mname == "monster_dog") { monster_dog(); return; }
	if (mname == "monster_dragon") { monster_dragon(); return; }
	if (mname == "monster_drole") { monster_drole(); return; }
	if (mname == "monster_dsergeant") { monster_dsergeant(); return; }
	if (mname == "monster_edie") { monster_edie(); return; }
	if (mname == "monster_eel") { monster_eel(); return; }
	if (mname == "monster_eidolon") { monster_eidolon(); return; }
	if (mname == "monster_eliminator") { monster_eliminator(); return; }
	if (mname == "monster_enforcer") { monster_enforcer(); return; }
	if (mname == "monster_fallen_angel") { monster_fallen_angel(); return; }
	if (mname == "monster_fallen_angel_lord") { monster_fallen_angel_lord(); return; }
	if (mname == "monster_firetopboss") { monster_firetopboss(); return; }
	if (mname == "monster_fish") { monster_fish(); return; }
	if (mname == "monster_floyd") { monster_floyd(); return; }
	if (mname == "monster_freddie") { monster_freddie(); return; }
	if (mname == "monster_fumigator") { monster_fumigator(); return; }
	if (mname == "monster_gargoyle") { monster_gargoyle(); return; }
	if (mname == "monster_gaunt") { monster_gaunt(); return; }
	if (mname == "monster_goblin") { monster_goblin(); return; }
	if (mname == "monster_golem") { monster_golem(); return; }
	if (mname == "monster_gremlin") { monster_gremlin(); return; }
	if (mname == "monster_gug") { monster_gug(); return; }
	if (mname == "monster_hell_hound") { monster_hell_hound(); return; }
	if (mname == "monster_hell_knight") { monster_hell_knight(); return; }
	if (mname == "monster_hell_knight_champion") { monster_hell_knight_champion(); return; }
	if (mname == "monster_hell_lord") { monster_hell_lord(); return; }
	if (mname == "monster_hell_pointknight") { monster_hell_pointknight(); return; }
	if (mname == "monster_hkboss") { monster_hkboss(); return; }
	if (mname == "monster_hogre") { monster_hogre(); return; }
	if (mname == "monster_hogreham") { monster_hogreham(); return; }
	if (mname == "monster_hogremac") { monster_hogremac(); return; }
	if (mname == "monster_hydra") { monster_hydra(); return; }
	if (mname == "monster_icegolem") { monster_icegolem(); return; }
	if (mname == "monster_impling") { monster_impling(); return; }
	if (mname == "monster_inquisitor") { monster_inquisitor(); return; }
	if (mname == "monster_jim") { monster_jim(); return; }
	if (mname == "monster_knight") { monster_knight(); return; }
	if (mname == "monster_lava_man") { monster_lava_man(); return; }
	if (mname == "monster_lostsoul") { monster_lostsoul(); return; }
	if (mname == "monster_meatwad") { monster_meatwad(); return; }
	if (mname == "monster_minotaur") { monster_minotaur(); return; }
	if (mname == "monster_morph") { monster_morph(); return; }
	if (mname == "monster_mummy") { monster_mummy(); return; }
	if (mname == "monster_necromancer") { monster_necromancer(); return; }
	if (mname == "monster_nemesant") { monster_nemesant(); return; }
	if (mname == "monster_nightshade") { monster_nightshade(); return; }
	if (mname == "monster_nour") { monster_nour(); return; }
	if (mname == "monster_octa") { monster_octa(); return; }
	if (mname == "monster_ogre") { monster_ogre(); return; }
	if (mname == "monster_ogre_flak") { monster_ogre_flak(); return; }
	if (mname == "monster_ogre_multi") { monster_ogre_multi(); return; }
	if (mname == "monster_oldone") { monster_oldone(); return; }
	if (mname == "monster_polyp") { monster_polyp(); return; }
	if (mname == "monster_pyro") { monster_pyro(); return; }
	if (mname == "monster_ryu") { monster_ryu(); return; }
	if (mname == "monster_ryu_wyrm") { monster_ryu_wyrm(); return; }
	if (mname == "monster_scorpion") { monster_scorpion(); return; }
	if (mname == "monster_scourge") { monster_scourge(); return; }
	if (mname == "monster_seeker") { monster_seeker(); return; }
	if (mname == "monster_sentinel") { monster_sentinel(); return; }
	if (mname == "monster_shalrath") { monster_shalrath(); return; }
	if (mname == "monster_shambler") { monster_shambler(); return; }
	if (mname == "monster_shub") { monster_shub(); return; }
	if (mname == "monster_shubupsd") { monster_shubupsd(); return; }
	if (mname == "monster_skullwiz") { monster_skullwiz(); return; }
	if (mname == "monster_snakeman") { monster_snakeman(); return; }
	if (mname == "monster_sorceror") { monster_sorceror(); return; }
	if (mname == "monster_spider") { monster_spider(); return; }
	if (mname == "monster_spikemine") { monster_spikemine(); return; }
	if (mname == "monster_super_grunt") { monster_super_grunt(); return; }
	if (mname == "monster_super_wrath") { monster_super_wrath(); return; }
	if (mname == "monster_swampling") { monster_swampling(); return; }
	if (mname == "monster_sword") { monster_sword(); return; }
	if (mname == "monster_tarbaby") { monster_tarbaby(); return; }
	if (mname == "monster_tarbaby_mitosis") { monster_tarbaby_mitosis(); return; }
	if (mname == "monster_sword") { monster_sword(); return; }
	if (mname == "monster_trogboss") { monster_trogboss(); return; }
	if (mname == "monster_troglodyte") { monster_troglodyte(); return; }
	if (mname == "monster_vermis") { monster_vermis(); return; }
	if (mname == "monster_virtus") { monster_virtus(); return; }
	if (mname == "monster_vomitus") { monster_vomitus(); return; }
	if (mname == "monster_voreling") { monster_voreling(); return; }
	if (mname == "monster_warlock") { monster_warlock(); return; }
	if (mname == "monster_wizard") { monster_wizard(); return; }
	if (mname == "monster_wraith") { monster_wraith(); return; }
	if (mname == "monster_wrath") { monster_wrath(); return; }
	if (mname == "monster_wspider") { monster_wspider(); return; }
	if (mname == "monster_zombie") { monster_zombie(); return; }
	if (mname == "monster_zombiek") { monster_zombiek(); return; }
	if (mname == "monster_zombiep") { monster_zombiep(); return; }
	if (mname == "monster_reiver") { monster_reiver(); return; }
	if (mname == "monster_carnivean") { monster_carnivean(); return; }
	if (mname == "monster_shalrath_boss") { monster_shalrath_boss(); return; }
	if (mname == "monster_dfury_boss") { monster_dfury_boss(); return; }
	if (mname == "monster_oldone_tentacle") { monster_oldone_tentacle(); return; }
	if (mname == "monster_hell_knight2") { monster_hell_knight2(); return; } // Warlord
};

void () func_spawn = {
	//if (!self.targetname) { dprint("ERROR: No targetname on func_spawn!!"); return; }
	if (!self.spawnclassname) self.spawnclassname = "monster_dog";
	BeMonsterFromString(self.spawnclassname);
};

void () func_spawn_small = {
   func_spawn ();
};

/////////////// These are several auto_cvar default settings, that are used in many other .qc files  (with a short summary what they are for and where they are used)
/////////////// There are some more auto_cvars definitions inside other .qc files (from older SMC versions, where I didnt collect them all here)
/////////////// Later on, you will find code for: "custom particle effects and sound implementation"   into existing maps 




/////// Quoth Enforcers:
var float autocvar_Quoth_enforcer_defender_chance = 15;		// set cvar 'Quoth_enforcer_defender_chance' default to 15  (= 15%).  Set the percentage of replacing the regular Enforcer with a Defender (0= never.  100= always). Choose any value you want between 0 and 100 %.     Defenders use shotguns and grenade launchers as weapon.
								// cvar used inside enforcer.qc
var float autocvar_Quoth_enforcer_eliminator_chance = 15;	// set cvar 'Quoth_enforcer_eliminator_chance' default to 15  (= 15%).  Set the percentage of replacing the regular Enforcer with a Eliminator (0= never.  100= always). Choose any value you want between 0 and 100 %.     Eliminators use plasma guns as weapon.
								// cvar used inside enforcer.qc
var float autocvar_Quoth_enforcer_pyro_chance = 15;		// set cvar 'Quoth_enforcer_pyro_chance' default to 15  (= 15%).  Set the percentage of replacing the regular Enforcer with a Pyro (0= never.  100= always). Choose any value you want between 0 and 100 %.     Pyros use flame throwers as weapon.   ATTENTION: Pyros cannot run+shoot because of their heavy weapon
								// cvar used inside enforcer.qc

var float autocvar_Quoth_enforcer_defender_health = 120;	// set cvar 'Quoth_enforcer_defender_health' default to 120.  
								// cvar used inside enforcer.qc
var float autocvar_Quoth_enforcer_defender_shotgun = 4;		// Enforcer_Defender큦 shotgun has 10 pellets. Set damage value for 1 pellet.
								// Enforcer_Defender큦 grenade launcher uses the same damage as Ogre큦 grenade launcher. It also follows improved z-aiming from Ogre큦 cvar:  autocvar_ogreaim (find it at the end of the smc_config.cfg) !!!

var float autocvar_Quoth_enforcer_eliminator_health = 120;	// set cvar 'Quoth_enforcer_eliminator_health' default to 120.  
								// cvar used inside enforcer.qc
var float autocvar_Quoth_enforcer_eliminator_plasma = 25;	// Set damage value for Enforcer_Eliminator큦 plasma weapon projectile.

var float autocvar_Quoth_enforcer_pyro_health = 120;		// set cvar 'Quoth_enforcer_pyro_health' default to 120.  
								// cvar used inside enforcer.qc
var float autocvar_Quoth_enforcer_pyro_fire = 2;		// Set damage value for Enforcer_Pyro큦 flame thrower. It fires 15 flames per attack-sequenze (1.5 seconds).




/////// Run+shoot and dodge feature:
var float autocvar_enforcer_run_and_shoot = 1;		   // set cvar 'enforcer_run_and_shoot' default to 1.    "0"= disabled (Regular Quake behavior)    "1"= Enforcers can run + shoot at the same time   ATTENTION: Needs special model with new animation sequences (included in the SMC) !!   
							   // cvar used inside enforcer.qc
var float autocvar_enforcer_defender_run_and_shoot = 0;	   // set cvar 'enforcer_defender_run_and_shoot' default to 0.    "0"= disabled (Regular Quake behavior)    "1"= Defenders can run + shoot at the same time   ATTENTION: Needs special model with new animation sequences (included in the SMC) !!   
							   // cvar used inside enforcer.qc
var float autocvar_enforcer_eliminator_run_and_shoot = 0;  // set cvar 'enforcer_eliminator_run_and_shoot' default to 0.    "0"= disabled (Regular Quake behavior)    "1"= Eliminators can run + shoot at the same time   ATTENTION: Needs special model with new animation sequences (included in the SMC) !!   
							   // cvar used inside enforcer.qc

var float autocvar_soldier_run_and_shoot = 0;		   // set cvar 'soldier_run_and_shoot' default to 0.    "0"= disabled (Regular Quake behavior)    "1"= Soldiers can run + shoot at the same time   ATTENTION: Needs special model with new animation sequences (included in the SMC) !!   
							   // cvar used inside soldier.qc



/////// Weapon aim jittering:
var float autocvar_weapon_aim_jittering = 0;	// set cvar 'weapon_aim_jittering' default to 0.   Add a jittering recoil behavior to fast firing weapons that makes them aim less accurate.    "0"= disabled (Regular Quake gun aim behavior)     "1" =  enable only for nailgun and supernailgun.    "2" =  enable for nailgun, supernailgun and lightning gun.
						// cvar used inside weapons.qc



/////// Powerup HUD models / textures and HUD water effects:
var float autocvar_biosuit_HUD_visor = 1;		// set cvar 'biosuit_HUD_visor' default to 1.    "0"= disabled    "1" = Spawn visible HUD visor when picking up biosuit.   "2" = Spawn spinning biosuit HUD model when picking up biosuit.    ATTENTION: Automatic scaling for biosuit visor TEXTURE is shared with "HUD_visor_texture_manual_scale" cvar to keep both effects in harmony and match each other.  Automatic positioning for spinning biosuit MODEL is shared with "HUD_spinning_side_model_manual_position" cvars to keep both effects in harmony and match each other.
							// cvar used inside client.qc and weapons.qc
var float autocvar_quad_HUD_visor = 2;			// set cvar 'quad_HUD_visor' default to 2.    "0"= disabled    "1" = Spawn visible quad HUD visor texture when picking up quad rune.   "2" = Spawn spinning quad HUD model when picking up quad rune.    ATTENTION: Automatic scaling for quad visor TEXTURE is shared with "HUD_visor_texture_manual_scale" cvar to keep both effects in harmony and match each other.  Automatic positioning for spinning quad MODEL is shared with "HUD_spinning_side_model_manual_position" cvars to keep both effects in harmony and match each other.
							// cvar used inside client.qc and weapons.qc
var float autocvar_pent_HUD_visor = 2;			// set cvar 'pent_HUD_visor' default to 2.    "0"= disabled    "1" = Spawn visible pent HUD visor texture when picking up pentagram rune.   "2" = Spawn spinning pent HUD model when picking up pent rune.     ATTENTION: Automatic scaling for pent visor TEXTURE is shared with "HUD_visor_texture_manual_scale" cvar to keep both effects in harmony and match each other.  Automatic positioning for spinning pent MODEL is shared with "HUD_spinning_side_model_manual_position" cvars to keep both effects in harmony and match each other.
							// cvar used inside client.qc and weapons.qc
var float autocvar_ring_HUD_visor = 1;			// set cvar 'ring_HUD_visor' default to 1.    "0"= disabled    "1" = Spawn spinning ring HUD model when picking up invisibility ring.     Automatic positioning for spinning ring MODEL is shared with "HUD_spinning_side_model_manual_position" cvars to keep both effects in harmony and match each other.
							// cvar used inside client.qc and weapons.qc
var float autocvar_keys_HUD_visor = 0;			// set cvar 'keys_HUD_visor' default to 0.    "0"= disabled    "1" = Spawn spinning key HUD model when picking up keys.     Automatic positioning for spinning keys MODEL is shared with "HUD_spinning_bottom_model_manual_position" cvars to keep in harmony and match with mini-player HUD model.
							// cvar used inside client.qc and weapons.qc
var float autocvar_HUD_waterdrops_out_of_water = 2;	// set cvar 'HUD_waterdrops_out_of_water' default to 2.    "0"= disabled    "1" = Always enable water drops running down players face / HUD when coming out of water or slime. This means you can have this waterdrops effect also without the "biosuit_HUD_visor" cvar enabled !!    "2" = ONLY enable water drops running down players face / HUD when coming out of water or slime, when "biosuit_HUD_visor" cvar is enabled !!       ATTENTION: Automatic scaling for waterdrops is shared with "HUD_visor_texture_manual_scale" to keep both effects in harmony and match each other.
							// cvar used inside client.qc and custom_effects.qc

var float autocvar_HUD_blood_splatter = 100;		// set cvar 'HUD_blood_splatter' default to 100.    When gibbing corpses or living monsters, blood splatters are spawned at players HUD.    But ONLY when staying near the gibbed monster/corpse. Set the maximum distance in Quake units towards monster/corpse to spawn the effect.     "0"= disable this feature     Example: "100" --> Only when staying 100 Quake units or less away from gibbed monster/corpse, blood splatter will be spawned on HUD.       
							// cvar used inside client.qc and weapons.qc

var float autocvar_HUD_visor_texture_manual_scale = 0;			// set cvar 'HUD_visor_texture_manual_scale' default to 0.    "0"= Visor texture size / scale is automatically calculated via qc code (based on resolution 1920x1080) to match your FOV value !!      Values other than "0" sets the scale value manually (ignoring qc code calculation).  Example:  "1.3" will scale the visor to this scale value. Choose any value >0 you want to match your FOV.     ATTENTION: Automatic scaling works robust with screen resolution 1920x1080. If you have a different screen resolution, the visor needs manual scale values (sometimes a modified sized model as well. Simply resize the model to your used screen resolution ratio.).
									// cvar used inside custom_effects.qc
var float autocvar_HUD_spinning_side_model_manual_y_position = 0;	// set cvar 'HUD_spinning_side_model_manual_y_position' default to 0.    "0"= Spinning powerup HUD model is automatically calculated via qc code (based on resolution 1920x1080) to match your FOV value !!      Values other than "0" sets the left / right position manually (ignoring qc code calculation).  Example:  "14" will place the model to a far left position. Choose any value you want.     ATTENTION: Automatic positioning works robust with screen resolution 1920x1080. If you have a different screen resolution, the model needs manual position values.  Works with every screen resolution and FOV.
									// cvar used inside custom_effects.qc
var float autocvar_HUD_spinning_side_model_manual_z_position = 0;	// set cvar 'HUD_spinning_side_model_manual_z_position' default to 0.    "0"= Spinning powerup HUD model is automatically calculated via qc code (based on resolution 1920x1080) to match your FOV value !!      Values other than "0" sets the up / down position manually (ignoring qc code calculation). 	Example:  "5" will place the model to an upper position. Choose any value you want.      ATTENTION: Automatic positioning works robust with screen resolution 1920x1080. If you have a different screen resolution, the model needs manual position values.  Works with every screen resolution and FOV.
									// cvar used inside custom_effects.qc
var float autocvar_HUD_spinning_bottom_model_manual_y_position = 0;	// set cvar 'HUD_spinning_bottom_model_manual_y_position' default to 0.    "0"= Spinning mini-player and key HUD model is automatically calculated via qc code (based on resolution 1920x1080) to match your FOV value !!      Values other than "0" sets the left / right position manually (ignoring qc code calculation).  Example:  "7" will place the model to a left position. Choose any value you want.     ATTENTION: Automatic positioning works robust with screen resolution 1920x1080. If you have a different screen resolution, the model needs manual position values.  Works with every screen resolution and FOV.
									// cvar used inside custom_effects.qc
var float autocvar_HUD_spinning_bottom_model_manual_z_position = 0;	// set cvar 'HUD_spinning_bottom_model_manual_z_position' default to 0.    "0"= Spinning mini-player and key HUD model is automatically calculated via qc code (based on resolution 1920x1080) to match your FOV value !!      Values other than "0" sets the up / down position manually (ignoring qc code calculation). 	Example:  "-9" will place the model to a lower position. Choose any value you want.      ATTENTION: Automatic positioning works robust with screen resolution 1920x1080. If you have a different screen resolution, the model needs manual position values.  Works with every screen resolution and FOV.
									// cvar used inside custom_effects.qc




/////// War cry:
var float autocvar_war_cry = 2;			// set cvar 'war_cry' default to 2.    Player sometimes shouts out a war cry when in the heat of a tough battle.    "0"= disabled    "1" =  ONLY when equipped with axe    "2" =  ONLY when equipped with axe or nailgun/supernailgun     "3" =  ONLY when equipped with axe or nailgun/supernailgun or lightning gun    "4" =  ONLY when equipped with axe or nailgun/supernailgun or lightning gun or rocket/grenade launcher     "5" =  with all weapons
						// cvar used inside weapons.qc



/////// Kickable gibs:
var float autocvar_kickgibs = 0;			// set cvar 'kickgibs' default to 0.     "0"= disables kickable gibs+ heads   "1" = enables kickable gibs + heads     ATTENTION: feature will be overriden by "eatablegibs" (see below)
							// cvar used inside player.qc

var float autocvar_gibsexplode = 1;      		// set cvar 'gibsexplode' default to 1    "0"= gibs only fade away (become smaller and transparent)   "1" = gibs fade away and leave a blood splat behind them
							// cvar used inside player.qc

/////// Eatable gibs:
var float autocvar_eatablegibs = 0;			// set cvar 'eatablegibs' default to 0.     "0"= disabled   "1" = player can  ONLY  "eat" heart gibs to restore some health    "2" = player can "eat" heart gibs AND head gibs to restore some health    "3" = player can "eat" heart gibs AND head gibs AND regular gibs to restore some health    
							// cvar used inside player.qc
var float autocvar_eatable_regular_gib_healamount = 2;	// set cvar 'eatable_regular_gib_healamount' default to 2.     Player receives some health when touching/eating gibs     Set the amount of health points for regular gibs (no head gib) here
							// cvar used inside player.qc
var float autocvar_eatable_head_gib_healamount = 4;	// set cvar 'eatable_head_gib_healamount' default to 4.     Player receives some health when touching/eating head gibs     Set the amount of health points for head gibs here
							// cvar used inside player.qc
var float autocvar_eatable_heart_gib_healamount = 5;	// set cvar 'eatable_heart_gib_healamount' default to 5.     Player receives some health when touching/eating heart gibs     Set the amount of health points for heart gibs here
							// cvar used inside player.qc

/////// Bleeding gibs:
var float autocvar_blood_spitting_gibs = 1;		// set cvar 'blood_spitting_gibs' default to 1.     "0"= disabled   "1" = head gibs and regular gibs are still pumping some blood when lying on the floor   
							// cvar used inside kickgibs.qc and eatgibs.qc



/////// Blood puddles beneath monster corpses:
var float autocvar_monster_blood_puddles = 1;		// set cvar 'monster_blood_puddles' default to 1 (enabled).   "0"= disabled    "1"= blood puddles are spawned beneath monster corpses.
							// cvar used inside world.qc



/////// Head gibs always turn towards player:
var float autocvar_head_gibs_always_face_player = 1;		// set cvar 'head_gibs_always_face_player' default to 1 (enabled).   "0"= disabled    "1"= head gibs will always turn towards (facing) player.   (requested be several at quakeone.com)
								// cvar used inside kickgibs.qc and player.qc



/////// Random angled ammo + health (if not spinning custom health models) pickups:
var float autocvar_ammo_health_boxes_angle_randomness = 20;	// set cvar 'ammo_health_boxes_angle_randomness' default to 20 (= 20�).   "0"= disable this feature    Values "1" or higher = place all ammo and health (if not spinning custom health models) boxes with random angles on ground. Angle variies between +/- value.   ATTENTION: Do not go much higher than "20" or the boxes might leak or overlap into nearby walls or other boxes. That is not a technical problem, only a visual problem.
								// cvar used inside items.qc


/////// Flashlight
var float autocvar_flashlight_type = 2;				// choose between 2 different flashlight types ("1" regular and "2" cubemap style)
var float autocvar_flashlight_radius = 170;			// adjust flashlights light radius for flashlight type 1 here
var float autocvar_flashlight_cubemap_radius = 700;		// adjust flashlights light radius for flashlight type 2 here
var float autocvar_flashlight_color_brightness_red = 1.8;	// adjust flashlights light intensity (color red)
var float autocvar_flashlight_color_brightness_green = 1.7;	// adjust flashlights light intensity (color green)	
var float autocvar_flashlight_color_brightness_blue = 1.7;	// adjust flashlights light intensity (color blue)	



/////// Ogre additional chainsaw particles:
var float autocvar_ogre_additional_particle_effects = 1;	// set cvar 'ogre_additional_particle_effects' default to 1.   "0"= disabled (no additional chainsaw particle effects)    "1"= If you ONLY use the original ogre model    "2"= If you ONLY use Tea Monsters Ogre replacement model    "3"= If you use BOTH (original and Tea Monsters) ogre model via multimodel/multiskin feature and have the original model set as 1st model.   "4"= If you use BOTH (original and Tea Monsters) ogre model via multimodel/multiskin feature and have Tea Monsters model set as 1st model. 
								// cvar used inside ogre.qc



/////// Shalrath큦 jumping and hanging on ceiling:
var float autocvar_shalrath_jumping_chance = 50;			// set cvar 'shalrath_jumping_chance' default to 50  (= 50%).  Set chance for shalrath to perform a jump (if space above is big enough).  (0= never(disable this feature)   100= always). Choose any value you want between 0 and 100   
									// cvar used inside shalrath.qc
var float autocvar_shalrath_hanging_on_ceiling_chance = 60;		// set cvar 'shalrath_hanging_on_ceiling_chance' default to 60  (= 60%).  When shalrath performes a jump (see cvar: "shalrath_jumping_chance") she tries to catch and hang on the ceiling.  (0= never(always only jumping !)   100= always). Choose any value you want between 0 and 100   
									// cvar used inside shalrath.qc
var float autocvar_shalrath_free_space_limit_for_jumping = 150;		// set cvar 'shalrath_free_space_limit_for_jumping' default to 150.   Set a minimum space above shalrath (between her head and the ceiling) to do a jump. When space is smaller than this value, shalrath does not perform a jump.  
									// cvar used inside shalrath.qc
var float autocvar_shalrath_hanging_no_enemy_in_sight_time = 1.5;	// set cvar 'shalrath_hanging_no_enemy_in_sight_time' default to 1.5 seconds.  When shalrath is hanging on a ceiling and lose sight to her enemy (usually the player) she will drop down again. Set the time for her to wait on the ceiling before dropping down. Choose any positive value you want between (in seconds).
									// cvar used inside shalrath.qc
var float autocvar_shalrath_pain_drop_down_from_ceiling = 0;		// set cvar 'shalrath_pain_drop_down_from_ceiling' default to 0 (disabled).   When this cvar is enabled ("1") shalrath can ONLY be shot/taken down from ceiling when shot with grenade launcher, rocket launcher or lightning gun.
									// cvar used inside shalrath.qc
var float autocvar_shalrath_hanging_on_ceiling_on_map_start_chance = 33;// set cvar 'shalrath_hanging_on_ceiling_on_map_start_chance' default to 33  (= 33%).   Set chance for shalrath to try to jump and hang on ceiling at beginning of a map, for better suprise affect.  (0= never(disable this feature)   100= always). Choose any value you want between 0 and 100   
									// cvar used inside shalrath.qc
var float autocvar_shalrath_runs_frantically_towards_player = 33;	// set cvar 'shalrath_runs_frantically_towards_player' default to 33  (= 33%).   Set chance for shalrath to rush frantically towards the player when she is still far away (for max. 2 seconds, or when she gets closer than 300 Quake units).    (0= never(disable this feature)   100= always). Choose any value you want between 0 and 100   
									// cvar used inside shalrath.qc



////////  Player is surrounded by flying dust cvars
var float autocvar_flying_dust = 1;		// set cvar 'flying_dust' default to 1.   ATTENTION: Only in single player or coop.   "0"= disabled     "1"= enable flying dust particles in non-base Quake maps    "2"= enable flying dust particles in all Quake maps
						// cvar used inside client.qc
var float autocvar_flying_dust_quantity = 1;	// set cvar 'flying_dust_quantity' default to 1.    "0"= disabled    "1"= standard quantity     "2"= double quantity    "3"= triple quantity   and so on ...
						// cvar used inside custom_effects.qc
var float autocvar_flying_dust_type = 1;	// set cvar 'flying_dust_type' default to 1.     "1"= dust     "2"= ember    "3"= snow   "4"= rain
						// cvar used inside custom_effects.qc


////////  Displaying a powerup countdown
var float autocvar_powerupcountdown = 2;	// set cvar 'powerupcountdown' default to 2.    "0"= disabled    "1"= starts a countdown counter on center-screen when powerups are taken   "2"= starts a countdown counter on top left of screen when powerups are taken  	
						// cvar used inside client.qc


////////  Player changes shirt color according/depending on used armor
var float autocvar_player_changes_shirt_color_according_to_used_armor = 1;	// set cvar 'player_changes_shirt_color_according_to_used_armor' default to 1.    ATTENTION: Only in single player or coop.   "0"= disabled     "1"= Player changes shirt color according/depending on used armor (visible in 3rd person view or inside reflecting surfaces in 1st person view)  
										// cvar used inside client.qc


/////// Skill-dependencies for monster attacks
var float autocvar_skill_adjusted_soldier_aiming = 0;			// set cvar 'skill_adjusted_soldier_aiming' default to 0.     0= disabled (original Quake behaviour)     1= Soldier aim better the higher skill you are playing  ( skill 0(easy)= like original Quake    skill 1(normal)= 25% better than original Quake     skill 2(hard)= 50% better than original Quake     skill 3(nightmare)= 75% better than original Quake )
									// cvar used inside soldier.qc
var float autocvar_skill_adjusted_hellknight_projectile_homing = 0;	// set cvar 'skill_adjusted_hellknight_projectile_homing' default to 0.     0= disabled (original Quake behaviour)     1= Hellknight projectiles start to mildly home the higher skill you are playing  ( skill 0(easy)= like original Quake    skill 1(normal)= projectiles home very slightly     skill 2(hard)= projectiles home a little bit more     skill 3(nightmare)= projectiles home stronger )
									// cvar used inside hknight.qc
var float autocvar_skill_adjusted_wizard_projectile_homing = 0;		// set cvar 'skill_adjusted_wizard_projectile_homing' default to 0.     0= disabled (original Quake behaviour)     1= Wizard projectiles start to mildly home the higher skill you are playing  ( skill 0(easy)= like original Quake    skill 1(normal)= projectiles home very slightly     skill 2(hard)= projectiles home a little bit more     skill 3(nightmare)= projectiles home stronger )
									// cvar used inside wizard.qc
var float autocvar_skill_adjusted_monster_rangedattack_frequence = 0;	// set cvar 'skill_adjusted_monster_rangedattack_frequence' default to 0.     0= disabled (original Quake behaviour)     1= Monsters use their range attacks more often    ( skill 0(easy)= like original Quake    skill 1(normal)= 25% more often than original Quake     skill 2(hard)= 50% more often than original Quake     skill 3(nightmare)=  nightmare mode is not changed )
									// cvar used inside several monsters qc and fight.qc

var float autocvar_monster_run_animation_speed_factor = 0;		// set cvar 'monster_run_animation_speed_factor' default to 0.      Set the speed factor of monsters run animations here      0= disabled (original Quake behaviour)      10= 10% faster run animations    20= 20% faster run animations    and so on...  Choose any value you want between 0 and 100 (negative values makes them slower :)
									// cvar used inside several monsters qc 
var float autocvar_monster_rangedattack_animation_speed_factor = 0;	// set cvar 'monster_rangedattack_animation_speed_factor' default to 0.      Set the speed factor of monsters ranged attack animations here      0= disabled (original Quake behaviour)      10= 10% faster ranged attack animations    20= 20% faster ranged attack animations    and so on... Choose any value you want between 0 and 100  (negative values makes them slower :) 
									// cvar used inside several monsters qc 
var float autocvar_monster_skip_pain_animation_chance = 0;		// set cvar 'monster_skip_pain_animation_chance' default to 0.      Set the chance of not going into pain animation for monsters      0= disabled (original Quake behaviour)      10= 10% chance to skip pain animation     20= 20% chance to skip pain animation    and so on... Choose any value you want between 0 and 100 
									// cvar used inside combat.qc 


/////// Afrits, Carniveans, Hellknights, Reivers, Torments, Warlords projectiles and lava pools can ignite/inflame the player
var float autocvar_fire_projectiles_and_lava_inflame_time = 12;		// set cvar 'fire_projectiles_inflame_time' default to 12.     0= disable the feature completely     Set the maximum burning/suffering time for the player in seconds.   Note: When picking up medikits or jump into water, the burning will be cured at once !
									// cvar used inside weapons.qc
var float autocvar_afrit_projectiles_inflame_chance = 25;		// set cvar 'afrit_projectiles_inflame_chance' default to 25.    Set the chance of getting inflamed by Afrits projectiles in percent.    10= 10% chance to get inflamed     50= 50% chance to get inflamed    100= Every Afrits projectile will inflame the player
									// cvar used inside afrit.qc
var float autocvar_carnivean_projectiles_inflame_chance = 30;		// set cvar 'carnivean_projectiles_inflame_chance' default to 30.    Set the chance of getting inflamed by carniveans explosive projectiles in percent.    10= 10% chance to get inflamed     50= 50% chance to get inflamed    100= Every carniveans explosive projectile will inflame the player     ATTENTION: Only projectile type 1 can inflame the player (see cvar: "carnivean_projectile_type").
									// cvar used inside carnivean.qc
var float autocvar_hellknight_projectiles_inflame_chance = 25;		// set cvar 'hellknight_projectiles_inflame_chance' default to 25.    Set the chance of getting inflamed by Hellknights projectiles in percent.    10= 10% chance to get inflamed     50= 50% chance to get inflamed    100= Every hellknights projectile will inflame the player
									// cvar used inside weapons.qc
var float autocvar_reiver_fireball_inflame_chance = 30;			// set cvar 'reiver_fireball_inflame_chance' default to 30.    Set the chance of getting inflamed by Reivers fireballs in percent.    10= 10% chance to get inflamed     50= 50% chance to get inflamed    100= Every Reivers fireball will inflame the player     
									// cvar used inside reiver.qc
var float autocvar_torment_projectiles_inflame_chance = 25;		// set cvar 'torment_projectiles_inflame_chance' default to 25.    Set the chance of getting inflamed by torments projectiles in percent.    10= 10% chance to get inflamed     50= 50% chance to get inflamed    100= Every torments projectile will inflame the player
									// cvar used inside torment.qc
var float autocvar_warlord_projectiles_inflame_chance = 25;		// set cvar 'warlord_projectiles_inflame_chance' default to 25.    Set the chance of getting inflamed by Warlords projectiles in percent.    10= 10% chance to get inflamed     50= 50% chance to get inflamed    100= Every Warlords projectile will inflame the player
									// cvar used inside weapons.qc
var float autocvar_fire_projectiles_and_lava_inflame_frequence = 2;  	// set cvar 'fire_projectiles_inflame_frequence' default to 2.    Set the frequence in seconds between inflame/burning pains.
									// cvar used inside client.qc and weapons.qc
var float autocvar_fire_projectiles_and_lava_inflame_damage = 1;	// set cvar 'fire_projectiles_inflame_damage' default to 1.    Set the amount of burning damage per frequence.
									// cvar used inside client.qc
var float autocvar_fire_projectiles_and_lava_inflame_flicker = 1;	// set cvar 'fire_projectiles_inflame' default to 1.    0= disabled     1= burning inflicts a frequent flicker, tinting the complete screen red.
									// cvar used inside client.qc
var float autocvar_fire_projectiles_and_lava_inflame_particles = 1;  	// set cvar 'fire_projectiles_inflame_particles' default to 1.    0= do not use fire particles around player when inflamed     1= use fire particles around player when inflamed
									// cvar used inside client.qc


/////// Wizards projectiles and slime pools can poison the player
var float autocvar_wizard_projectiles_and_slime_poison_time = 15;	// set cvar 'wizard_projectiles_and_slime_poison_time' default to 15.    0= disable this feature completely      Set the maximum poison suffering time for the player in seconds.   Note: When picking up medikits, the poison will be cured at once !
									// cvar used inside client.qc and weapons.qc
var float autocvar_wizard_projectiles_poison_chance = 30;		// set cvar 'wizard_projectiles_poison_chance' default to 30.    Set the probability of getting poisoned by wizards projectiles in percent.    10= 10% chance to get poisoned     50= 50% chance to get poisoned    100= Every wizards projectile will poison the player
									// cvar used inside weapons.qc
var float autocvar_wizard_projectiles_and_slime_poison_frequence = 3;	// set cvar 'wizard_projectiles_and_slime_poison_frequence' default to 3.    Set the frequence in seconds between poison pains.
									// cvar used inside client.qc and weapons.qc
var float autocvar_wizard_projectiles_and_slime_poison_damage = 1;	// set cvar 'wizard_projectiles_and_slime_poison_damage' default to 1.    Set the amount of poison damage per frequence.
									// cvar used inside client.qc
var float autocvar_wizard_projectiles_and_slime_poison_flicker = 1;	// set cvar 'wizard_projectiles_and_slime_poison_flicker' default to 1.    0= disabled     1= poison inflicts a frequent flicker, tinting the complete screen green.
									// cvar used inside client.qc



/////// Random monster skin colors
var float autocvar_monster_random_skin_color_alteration = 1;	// set cvar 'monster_random_skin_color_alteration' default to 1.    0= disable this feature for all monsters completely     1= use only a slight texture color alteration     2= use a moderate texture color alteration    3= use a strong texture color alteration
							// cvar used inside demon.qc
var float autocvar_demon_random_skin_colors = 1;	// set cvar 'demon_random_skin_colors' default to 1.    0= do not modify/edit this monster types skin textures     1= modify/edit this monster types skin texture randomly (for higher variation in-game)
							// cvar used inside demon.qc
var float autocvar_dog_random_skin_colors = 1;		// set cvar 'dog_random_skin_colors' default to 1.    0= do not modify/edit this monster types skin textures     1= modify/edit this monster types skin texture randomly (for higher variation in-game)
							// cvar used inside dog.qc
var float autocvar_enforcer_random_skin_colors = 1;	// set cvar 'enforcer_random_skin_colors' default to 1.    0= do not modify/edit this monster types skin textures     1= modify/edit this monster types skin texture randomly (for higher variation in-game)
							// cvar used inside enforcer.qc
var float autocvar_fish_random_skin_colors = 1;		// set cvar 'fish_random_skin_colors' default to 1.    0= do not modify/edit this monster types skin textures     1= modify/edit this monster types skin texture randomly (for higher variation in-game)
							// cvar used inside fish.qc
var float autocvar_hknight_random_skin_colors = 1;	// set cvar 'hknight_random_skin_colors' default to 1.    0= do not modify/edit this monster types skin textures     1= modify/edit this monster types skin texture randomly (for higher variation in-game)
							// cvar used inside hknight.qc
var float autocvar_knight_random_skin_colors = 1;	// set cvar 'knight_random_skin_colors' default to 1.    0= do not modify/edit this monster types skin textures     1= modify/edit this monster types skin texture randomly (for higher variation in-game)
							// cvar used inside knight.qc
var float autocvar_ogre_random_skin_colors = 1;		// set cvar 'ogre_random_skin_colors' default to 1.    0= do not modify/edit this monster types skin textures     1= modify/edit this monster types skin texture randomly (for higher variation in-game)
							// cvar used inside ogre.qc
var float autocvar_shalrath_random_skin_colors = 1;	// set cvar 'shalrath_random_skin_colors' default to 1.    0= do not modify/edit this monster types skin textures     1= modify/edit this monster types skin texture randomly (for higher variation in-game)
							// cvar used inside shalrath.qc
var float autocvar_shambler_random_skin_colors = 0;	// set cvar 'shambler_random_skin_colors' default to 0.    0= do not modify/edit this monster types skin textures     1= modify/edit this monster types skin texture randomly (for higher variation in-game)
							// cvar used inside shambler.qc
var float autocvar_soldier_random_skin_colors = 1;	// set cvar 'soldier_random_skin_colors' default to 1.    0= do not modify/edit this monster types skin textures     1= modify/edit this monster types skin texture randomly (for higher variation in-game)
							// cvar used inside soldier.qc
var float autocvar_tarbaby_random_skin_colors = 1;	// set cvar 'tarbaby_random_skin_colors' default to 1.    0= do not modify/edit this monster types skin textures     1= modify/edit this monster types skin texture randomly (for higher variation in-game)
							// cvar used inside tarbaby.qc
var float autocvar_wizard_random_skin_colors = 1;	// set cvar 'wizard_random_skin_colors' default to 1.    0= do not modify/edit this monster types skin textures     1= modify/edit this monster types skin texture randomly (for higher variation in-game)
							// cvar used inside wizard.qc
var float autocvar_zombie_random_skin_colors = 1;	// set cvar 'zombie_random_skin_colors' default to 1.    0= do not modify/edit this monster types skin textures     1= modify/edit this monster types skin texture randomly (for higher variation in-game)
							// cvar used inside zombie.qc



/////// Lossless pickup crates (ammo / health / backpack)
var float autocvar_lossless_ammo_pickup = 0;		// set cvar 'lossless_ammo_pickup' default to 0.    0= use original Quake rules     1= crates can be "used" multiple times. They only vanish, when they are completely used up. Player will only take out the quantity until his max. capacity limit is reached. The rest remains in crate (see detailed description in items.qc)
							// cvar used inside items.qc
var float autocvar_lossless_health_pickup = 0;		// set cvar 'lossless_health_pickup' default to 0.    0= use original Quake rules     1= crates can be "used" multiple times. They only vanish, when they are completely used up. Player will only take out the quantity until his max. capacity limit is reached. The rest remains in crate (see detailed description in items.qc)
							// cvar used inside items.qc
var float autocvar_lossless_backpack_pickup = 0; 	// set cvar 'lossless_backpack_pickup' default to 0.  Only affects single player !!   0= use original Quake rules     1= backpack can be "used" multiple times. They only vanish, when they are completely used up. Player will only take out the quantity until his max. capacity limit is reached. The rest remains in backpack (see detailed description in items.qc)
							// cvar used inside items.qc  



/////// Shambler custom lightning beam
var float autocvar_shambler_lightning_beam = 0;		// set cvar 'shambler_lightning_beam' default to 0.    0= use original shambler lightning beam effect     1= use single custom particle shambler lightning beam effect      2= use double (hands) custom particle shambler lightning beam effect
							// cvar used inside shambler.qc


/////// Shalrath shootable missile
var float autocvar_shalrath_shootable_missile = 0;		// set cvar 'shalrath_shootable_missile' default to 0.    0= disabled    1= shalrath큦 missiles are shootable
								// cvar used inside shalrath.qc
/////// Shalrath shootable missile health
var float autocvar_shalrath_shootable_missile_health = 30;	// set health for Shalrath shootable missile health 
								// cvar used inside shalrath.qc
/////// Shalrath shootable missile teleporting when shot
var float autocvar_shalrath_shootable_missile_teleporting = 50;	// set cvar 'shalrath_shootable_missile_teleporting' default to 50.    0= shalrath큦 shootable missiles do NOT teleport when shot      Set the teleporting radius here when shalrath큦 shootable missiles are shot
								// cvar used inside shalrath.qc


/////// Interactive crosshairs
var float autocvar_weapon_range_crosshair = 0;		// set cvar 'weapon_range_crosshair' default to 0.   Changes crosshair color when aiming at monsters/exploboxes considering individual weapon range     0= disable     1= change crosshair color red/green in 1st person view     2= change crosshair color red/green in 1st and 3rd person view  (ATTENTION: In 3rd person view the crosshair is automagically moved upwards by the engine, so this feature should not be used in 3rd person)  (ATTENTION: Cannot be used together with  "player_health_crosshair"  or  "monster_health_crosshair"  feature !!!)
							// cvar used inside client.qc			
var float autocvar_player_health_crosshair = 0;		// set cvar 'player_health_crosshair' default to 0.   Changes crosshair color according to players health (from green = healthy  to  red = critical health)     0= disabled     1= enabled   (ATTENTION: Cannot be used together with  "weapon_range_crosshair"  or  "monster_health_crosshair"  feature !!!)
							// cvar used inside client.qc			
var float autocvar_monster_health_crosshair = 1;	// set cvar 'monster_health_crosshair' default to 1.   Change crosshair color according to monsters health the player is amining at (from green = healthy  to  red = critical health)     0= disabled     1= enabled   (ATTENTION: Cannot be used together with  "weapon_range_crosshair"  or  "player_health_crosshair"  feature !!!)
							// cvar used inside client.qc			
var float autocvar_weapon_specific_crosshair = 0;	// set cvar 'weapon_specific_crosshair' default to 0.   Change crosshair according to equipped weapon (every weapon uses its own crosshair)     0= disabled     1= enabled   (ATTENTION: Can be used together with any other intractive crosshair feature except "animated_crosshair" )
							// cvar used inside client.qc			
var float autocvar_animated_crosshair = 0;		// set cvar 'animated_crosshair' default to 0.   Animates crosshair when picking up quad-damage     0= disabled     1= enabled   (ATTENTION: Can be used together with any interactive crosshair features except "weapon_specific_crosshair" )
							// cvar used inside client.qc			
var float autocvar_distance_scale_crosshair = 0;	// set cvar 'distance_scale_crosshair' default to 0.   Change crosshair size depending on distance     0= disabled     1= Only change crosshair size when aiming at monsters and explo boxes (depending on distance towards entity)    2= Always change crosshair size (not only when aiming at monsters and explo boxes) (depending on distance towards surface)   (ATTENTION: Can be used together with  any other intractive crosshair feature !!!)
							// cvar used inside client.qc			
var float autocvar_distance_scale_crosshair_default = 1; // set cvar 'distance_scale_crosshair_default' default to 1.   cvar is only used when feature "distance_scale_crosshair" is enabled.  Set this cvar identical to the engine cvar: crosshair_size    (Had to be implemented because I do not want to edit the users config.cfg with this mod)
							 // cvar used inside client.qc			


/////// Player 3rd person view effects
var float autocvar_3rd_person_visible_weapons = 1;  	// set cvar '3rd_person_visible_weapons' default to 1.   0= disabled    1= Real weapon models (not only multigun) are visible in 3rd person view.  Also known as 'vwep'  (if this cvar is enabled, it will override the  'player_model'  cvar !!!)
							// cvar used inside client.qc

var float autocvar_3rd_person_extended_ring_effect = 0.3;	// Set the transparency of the 3rd person player model when picking the ring of shadows    0= disabled (original Quake eyes-model will be used)     0.3= 30% percent visibility    1= fully visible   Choose any value you want between 0 and 1   (independent to vwep cvar. Also works with regular player model !!!)
								// cvar used inside client.qc
var float autocvar_3rd_person_extended_quad_effect = 3;		// set cvar '3rd_person_extended_quad_effect' default to 3.    add different effects to 3rd person player model when picking quad damage rune     0= disabled     1= player model will be tinted in blue    2= Quake3-style glowing and moving shader around player model    3= effect 1 + 2 together   (independent to vwep cvar. Also works with regular player model !!!) 
								// cvar used inside client.qc
var float autocvar_3rd_person_extended_pent_effect = 1; 	// set cvar '3rd_person_extended_pent_effect' default to 1.    add different effects to 3rd person player model when picking pentagram       0= disabled     1= player model will be tinted in red     2= particle protection-shield is surrounding the player      3= effect 1 + 2 together  (independent to vwep cvar. Also works with regular player model !!!)
								// cvar used inside client.qc

/////// Player 1st person view quad effects
var float autocvar_1st_person_extended_quad_effect = 1;	// set cvar '1st_person_extended_quad_effect' default to 1.     0= disabled     1= add Quake3-style glowing and moving shader around view-weapon-model when picking quad damage rune  (ATTENTION: If you are using replacement view-weapon-models, you have to edit the skin file to match the replacement models mesh name !  See readme.txt inside included example-weapon-pack for more details ) 
							// cvar used inside client.qc


/////// player legs visibility in 1st person view
var float autocvar_player_legs_visibility = 1;		// set cvar 'player_legs_visibility' default to 1.    0= disabled    1= player legs are visible in 1st person view when looking down (this setting is for FOV smaller than 100)   2= player legs are visible in 1st person view when looking down (this setting is for FOV between 100 and 110)    3= player legs are visible in 1st person view when looking down (this setting is for FOV higher than 110)
							// cvar used inside client.qc and custom_effects.qc
var float autocvar_player_legs_model = 2;		// set cvar 'player_legs_model' default to 2.     1= use original ID1 player legs when cvar 'player_legs_visibility' is enabled        2= use Ruohis player legs when cvar 'player_legs_visibility' is enabled    
							// cvar used inside custom_effects.qc


/////// player chasecam death
var float autocvar_chasecam_death_view = 0;		// set cvar 'chasecam_death_view' default to 0.    0= disabled    1= enable chasecam view during players death animation     ATTENTION: Do not use this cvar if you play Quake in 3rd person view (chasecam view)
							// cvar used inside client.qc and player.qc

/////// player model selection
var float autocvar_player_model = 0;			// set cvar 'player_model' default to 0.   Only works when cvar '3rd_person_visible_weapons' is disabled !!!   0= use player.mdl / h_player.mdl    1= use player1.mdl / h_player1.mdl    2= use player2.mdl / h_player2.mdl    3= use player3.mdl / h_player3.mdl     4= use player4.mdl / h_player4.mdl
							// cvar used inside client.qc and player.qc


/////// Player suffering effects when seriously wounded
var float autocvar_player_wounded_heartbeat = 0.4;  	// set cvar 'player_wounded_heartbeat' default to 0.4.   0= disabled   If health is 30 and lower players heart starts pumping (gets worse when below 15).   1= max. volume heartbeat sound   (Choose any volume-value you want between 0 and 1)
							// cvar used inside client.qc
var float autocvar_player_wounded_aiming = 1;	  	// set cvar 'player_wounded_aiming' default to 1.      0= disabled   If health is 30 and lower players aiming starts to suffer (gets worse when below 15)
							// cvar used inside client.qc
var float autocvar_player_wounded_aiming_reset = 0;  	// set cvar 'player_wounded_aiming_reset' default to 0.     Sets engine cvar:  v_idlescale  to the specified value when player health is not below 30    (some people use a custom value for the engine cvar:  v_idlescale )
							// cvar used inside client.qc
var float autocvar_player_wounded_bleeding = 1;	  	// set cvar 'player_wounded_bleeding' default to 1.    0= disabled   1= if health is 40 and lower player starts to bleed (bleeding gets worse when health is below 20)   
							// cvar used inside client.qc


/////// monster bleeding
var float autocvar_monster_bleeding = 2;		// set cvar 'monster_bleeding' default to 2.    0= disabled    1= monsters bleed, when wounded (amount of blood is small)    2= monsters bleed, when wounded (amount of blood is high)
							// cvar used inside ai.qc

/////// monster ragdoll effect
var float autocvar_ragdoll = 2;				// set cvar 'ragdoll' default to 2.  0= disable   1= only ragdoll corpse 1 frame (= subtle)   2= ragdoll corpse up to 2 frames (= more intense)  3= ragdoll corpse up to 3 frames (= very intense)
							// cvar used inside world.qc

/////// Twitching corpses
var float autocvar_twitching_corpses = 0;		// set cvar 'twitching_corpses' default to 0.  0= disable   1= only twich 1 frame (= subtle)   2= twitch up to 2 frames (= more intense)
							// cvar used inside world.qc
/////// Twitching corpses interval
var float autocvar_twitching_corpses_interval = 2;	// set cvar 'twitching_corpses_interval' default to 2 seconds.  Sets the minimum frequency /intervall between twitches (the bigger the value, the less twitches !)   Choose any value you want between 0 and 100
							// cvar used inside world.qc



/////// medikits + armor + ammo  values
var float autocvar_medikit_small_health = 15;		// set health restore value of this medikit type.
var float autocvar_medikit_large_health = 25;		// set health restore value of this medikit type.
var float autocvar_medikit_mega_health = 100;		// set health restore value of this medikit type.

var float autocvar_armor_green = 100;			// set armor value of this armor type.
var float autocvar_armor_yellow = 150;			// set armor value of this armor type.
var float autocvar_armor_red = 200;			// set armor value of this armor type.

var float autocvar_shells_small = 20;			// set ammo quanity of this ammo type.
var float autocvar_shells_big = 40;			// set ammo quanity of this ammo type.
var float autocvar_nails_small = 25;			// set ammo quanity of this ammo type.
var float autocvar_nails_big = 50;			// set ammo quanity of this ammo type.
var float autocvar_rockets_small = 5;			// set ammo quanity of this ammo type.
var float autocvar_rockets_big = 10;			// set ammo quanity of this ammo type.
var float autocvar_cells_small = 6;			// set ammo quanity of this ammo type.
var float autocvar_cells_big = 12;			// set ammo quanity of this ammo type.

var float autocvar_shells_max_capacity = 100;		// set players max ammo capacity of this ammo type (also affects impulse 9 cheat)
var float autocvar_nails_max_capacity = 200;		// set players max ammo capacity of this ammo type (also affects impulse 9 cheat)
var float autocvar_rockets_max_capacity = 100;		// set players max ammo capacity of this ammo type (also affects impulse 9 cheat)
var float autocvar_cells_max_capacity = 100;		// set players max ammo capacity of this ammo type (also affects impulse 9 cheat)

var float autocvar_backpack_enforcer_cells = 5;		// set cell amount in this backpack type.
var float autocvar_backpack_soldier_shells = 5;		// set shell amount in this backpack type.
var float autocvar_backpack_ogre_grenades = 2;		// set grenade/rocket amount in this backpack type.




/////// monster health values
var float autocvar_demon_health = 300;		// set health value of this monster type.
var float autocvar_dog_health = 25;		// set health value of this monster type.
var float autocvar_enforcer_health = 80;	// set health value of this monster type.
var float autocvar_fish_health = 25;		// set health value of this monster type.
var float autocvar_hellknight_health = 250;	// set health value of this monster type.
var float autocvar_knight_health = 75;		// set health value of this monster type.
var float autocvar_ogre_health = 200;		// set health value of this monster type.
var float autocvar_shalrath_health = 400;	// set health value of this monster type.
var float autocvar_shambler_health = 600;	// set health value of this monster type.
var float autocvar_soldier_health = 30;		// set health value of this monster type.
var float autocvar_tarbaby_health = 80;		// set health value of this monster type.
var float autocvar_wizard_health = 80;		// set health value of this monster type.
// zombie health should remain 60



/////// monster attack values
var float autocvar_chton_lavaballs = 100;	// set damage value of this monster type.
var float autocvar_demon_claws = 10;		// set damage value of this monster attack type.
var float autocvar_demon_jump = 40;		// set damage value of this monster attack type.
var float autocvar_dog_bite = 8;		// set damage value of this monster attack type.
var float autocvar_dog_jump = 10;		// set damage value of this monster attack type.
var float autocvar_enforcer_laser = 15;		// set damage value of this monster type.
var float autocvar_fish_bite = 3;		// set damage value of this monster type.
var float autocvar_hellknight_sword = 3;	// set damage value of this monster type.
var float autocvar_hellknight_missile = 9;	// set damage value of this monster type.
var float autocvar_knight_sword = 3;		// set damage value of this monster type.
var float autocvar_ogre_chainsaw = 4;		// set damage value of this monster attack type.
var float autocvar_ogre_grenade = 40;		// set damage value of this monster attack type.
var float autocvar_shalrath_missile = 40;	// set damage value of this monster type.
var float autocvar_shambler_claws = 20;		// set damage value of this monster attack type.
var float autocvar_shambler_doubleclaws = 40;	// set damage value of this monster attack type.
var float autocvar_shambler_lightning = 10;	// set damage value of this monster attack type.
var float autocvar_soldier_gun = 4;		// (soldiers shotgun has 4 pellets) set damage value of this monster type.
var float autocvar_tarbaby_jump = 10;		// set damage value of this monster attack type.
var float autocvar_tarbaby_explode = 120;	// set damage value of this monster attack type.
var float autocvar_wizard_missile = 9;		// set damage value of this monster type.
var float autocvar_zombie_flesh = 10;		// set damage value of this monster type.


/////// player weapon-damage values
var float autocvar_player_axe = 20;		// set damage value for the axe.
var float autocvar_player_shotgun_pellets = 4;	// (shotgun has 6 pellets, doubleshotgun has 14 pellets)
var float autocvar_player_nailgun = 9;		// set damage value for nailgun nails.
var float autocvar_player_supernailgun = 18;	// set damage value for supernailgun nails.
var float autocvar_player_grenades = 120;	// set damage value for grenades radiusdamage.
var float autocvar_player_rocket_impact = 100;	// set damage value for rockets direct impact.
var float autocvar_player_rocket_radius = 120;	// set damage value for rockets radiusdamage.
var float autocvar_player_lightninggun = 30;	// set damage value for lightning gun.



/////// teleport zoom view
var float autocvar_teleport_zoom_view = 1;		// set cvar 'teleport_zoom_view' default to 1.    0= disabled    1= enable view animation, when traveling through teleporters
							// cvar used inside triggers.qc

/////// teleporter particles
var float autocvar_teleporter_particles = 3;		// set cvar 'teleporter_particles' default to 3.    0= disabled    1= enable extra particle effects ONLY in front of regular teleporters     2= enable extra particle effects in front of teleporters AND end-map-teleporters     3= enable extra particle effects ONLY in front of end-map-teleporters
							// cvar used inside triggers.qc
/////// slipgate teleporter particles
var float autocvar_teleporter_particles_slipgates = 3;	// set cvar 'teleporter_particles_slipgates' default to 3.    0= disabled    1= enable "soak in" effect for slipgates (in base maps)     2= enable "rising-stars" effect for slipgates (in base maps)     3= enable "red-fog" effect for slipgates (in base maps)     4= enable combination of "soak in" + "red-fog" effect for slipgates (in base maps)     5= enable combination of "rising-stars" + "red-fog" effect for slipgates (in base maps)
							// cvar used inside triggers.qc



/////// Face effect
var float autocvar_evil_faces = 1;	  		// evil face textures are interactive.   0= disabled   1= textures bleed, when shot   2= evil monster is spawn when shot
							// cvar used inside weapons.qc + face.qc
/////// Face uses v_psycho effect
var float autocvar_evil_faces_psycho_effect = 0;  	// visual screen effect when evil monster appears   0= disabled   1= enabled  (when evil_face is set to "2")
							// cvar used inside client.qc
/////// Face effect monster scale
var float autocvar_evil_faces_monster_scale = 1.7;     	// set scale for evil face monster (when evil_faces is set to "1.7")
							// cvar used inside face.qc
/////// Face effect monster health
var float autocvar_evil_faces_monster_health = 35;	// set health for evil face monster (when evil_faces is set to "2")
							// cvar used inside face.qc
/////// Face effect monster behaviour
var float autocvar_evil_faces_monster_behaviour = 1;	// 0= evil face monster will vanish, when hitting walls/meshes    1= evil face monster will NOT vanish, when hitting walls/meshes (= more dangerous)    (when evil_faces is set to "2")
							// cvar used inside face.qc



/////// Warlord health value:
var float autocvar_warlord_health = 250;		// set health value of the Warlords
							// cvar used inside warlord.qc
/////// Warlord chance to replace a hknight:
var float autocvar_warlord_replace_hknight = 17;	// set cvar 'warlord_replace_hknight' default to 17  (= 17%).  Set the percentage of replacing the hknight with an Warlord (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside hknight.qc
/////// Warlord chance to replace an ogre:
var float autocvar_warlord_replace_ogre = 12;		// set cvar 'warlord_replace_ogre' default to 12  (= 12%).  Set the percentage of replacing the ogre with an Warlord (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside ogre.qc
/////// Warlord grenade type:
var float autocvar_warlord_grenade_type = 2;		// set cvar 'warlord_grenade_type' default to 2.    "0"= Warlord does not throw any grenades   "1"= Warlord can also throw regular grenades   "2"= Warlord can also throw multi-grenades
							// cvar used inside warlord.qc
/////// Warlord grenade damage value:
var float autocvar_warlord_grenade = 40;		// set damage value of this monster attack type.
							// cvar used inside warlord.qc
/////// Warlord spiked-grenade (multi-grenade) damage value:
var float autocvar_warlord_spike_grenade = 50;		// set damage value of this monster attack type.
							// cvar used inside warlord.qc
/////// Warlord spike type:
var float autocvar_warlord_spike_type = 1;		// set cvar 'warlord_spike_type' default to 1.    "0"= Warlord uses the same model as Hellknight for his standard magic ranged attacks   "1"= Warlord uses different model as Hellknight for his standard magic ranged attacks   
							// cvar used inside warlord.qc
/////// Warlord spike damage:
var float autocvar_warlord_missile = 9;			// set damage value of this monster types.
							// cvar used inside weapons.qc
/////// Warlord can throw homing projectiles:
var float autocvar_warlord_homing_projectile = 1;	// set cvar 'warlord_homing_projectile' default to 1.    "0"= Warlord can NOT spawn additional (shootable) homing projectiles   "1"= Warlord can also spawn additional (shootable) homing projectiles
							// cvar used inside warlord.qc
/////// Warlord homing missile damage value:
var float autocvar_warlord_homing_missile = 15;		// set damage value of this monster attack type.
							// cvar used inside warlord.qc
/////// Warlord homing behaviour:
var float autocvar_warlord_homing_behaviour = 0;	// set cvar 'warlord_homing_behaviour' default to 0.   0= face will vanish, when hitting walls/meshes    1= face will NOT vanish, when hitting walls/meshes (= must be shot/destroyed to vanish)
							// cvar used inside warlord.qc
/////// Warlord shield ram attack:
var float autocvar_warlord_ram_pushback = 300;		// set cvar 'warlord_ram_pushback' default to 300.   Set the force of warlords shield-ram-attack here.   0= disabeld     Set any value you want.
							// cvar used inside client.qc
/////// Warlord shield ram attack damage value:
var float autocvar_warlord_ram_attack = 5;		// set damage value of this monster attack type.
							// cvar used inside warlord.qc
/////// Warlord dodge chance:
var float autocvar_warlord_dodge_chance = 15;		// set cvar 'warlord_dodge_chance' default to 15  (= 15%).  Set chance of dodging non-explosive attacks attacks  (0= never.  100= always). Choose any value you want between 0 and 100   
							// cvar used inside combat.qc




/////// Torment health value:
var float autocvar_torment_health = 200;		// Torment큦 have the health value of the monster type it replaces !  This cvar only takes affect in custom maps, where the torments are spawned directly !
							// cvar used inside torment.qc
/////// Torment hell rod melee damage:	
var float autocvar_torment_rod_melee = 4;		// set damage value of this monster attack type.
							// cvar used inside fight.qc
/////// Torment hell rod projectiles damage:
var float autocvar_torment_rod_missile = 25;		// set damage value of this monster attack type.
							// cvar used inside torment.qc
/////// Torment chance to replace a demon:
var float autocvar_torment_replace_demon = 5;		// set cvar 'torment_replace_demon' default to 5  (= 5%).  Set the percentage of replacing the demon with an torment (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside demon.qc
/////// Torment chance to replace a hknight:
var float autocvar_torment_replace_hknight = 12;	// set cvar 'torment_replace_hknight' default to 12  (= 12%).  Set the percentage of replacing the hknight with an torment (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside hknight.qc
/////// Torment chance to replace a knight:
var float autocvar_torment_replace_knight = 7;		// set cvar 'torment_replace_knight' default to 7  (= 7%).  Set the percentage of replacing the knight with an torment (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside knight.qc
/////// Torment chance to replace an ogre:
var float autocvar_torment_replace_ogre = 15;		// set cvar 'torment_replace_ogre' default to 15  (= 15%).  Set the percentage of replacing the ogre with an torment (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside ogre.qc




/////// Carnivean health value:
var float autocvar_carnivean_health = 400;				// Carnivean큦 have the health value of the monster type it replaces !  This cvar only takes affect in custom maps, where the carniveans are spawned directly !
									// cvar used inside carnivean.qc
/////// Carnivean melee damage:	
var float autocvar_carnivean_scythe_damage = 4;				// set damage value for carnivean melee attacks.
									// cvar used inside fight.qc
/////// Carnivean projectiles damage:
var float autocvar_carnivean_explosive_projectile_impact_damage = 25;	// set damage value for carnivean explosive projectiles direct impact.
var float autocvar_carnivean_explosive_projectile_radius_damage = 50;	// set damage value for carnivean explosive projectiles radiusdamage.
var float autocvar_carnivean_rock_projectile_impact_damage = 20;	// set damage value for carnivean rock projectiles direct impact.
var float autocvar_carnivean_rock_projectile_pushback = 200;		// set pushback value for carnivean rock projectiles direct impact.
var float autocvar_carnivean_rock_projectile_homing = 1;		// set if rock projectile shall be homing (following player) = "1"  or not = "0"

/////// Carnivean projectile type:
var float autocvar_carnivean_projectile_type = 60;			// Select chance for different carnivean projectiles: rock/stone-like  or  fireball-like.   ATTENTION: Only fireball-like projectiles can inflame the player  (see cvar: "carnivean_projectiles_inflame_chance")          Examples: "0"= always rock/stone-like projectile    "100"= always use fireball-like     "50"= use both projectiles randomly (50/50 %).  "75"= 25% chance to use rock/stone-like and 75% to use fireball-like projectile		   
									// cvar used inside carnivean.qc
/////// Carnivean chance to replace a hellknight:
var float autocvar_carnivean_replace_hellknight = 10;			// set cvar 'carnivean_replace_hellknight' default to 10 (= 10%).  Set the percentage of replacing the hellknight with a carnivean (0= never.  100= always). Choose any value you want between 0 and 100
									// cvar used inside hknight.qc
/////// Carnivean chance to replace an ogre:
var float autocvar_carnivean_replace_ogre = 10;				// set cvar 'carnivean_replace_ogre' default to 10 (= 10%).  Set the percentage of replacing the ogre with a carnivean (0= never.  100= always). Choose any value you want between 0 and 100
									// cvar used inside ogre.qc
/////// Carnivean chance to replace a shalrath:
var float autocvar_carnivean_replace_shalrath = 10;			// set cvar 'carnivean_replace_shalrath' default to 10 (= 10%).  Set the percentage of replacing the shalrath with a carnivean (0= never.  100= always). Choose any value you want between 0 and 100
									// cvar used inside shalrath.qc
/////// Carnivean chance to replace a shambler:
var float autocvar_carnivean_replace_shambler = 5;			// set cvar 'carnivean_replace_shambler' default to 5 (= 5%).  Set the percentage of replacing the shambler with a carnivean (0= never.  100= always). Choose any value you want between 0 and 100
									// cvar used inside shambler.qc
/////// Carnivean chance to replace a knight:
var float autocvar_carnivean_replace_knight = 0;			// set cvar 'carnivean_replace_knight' default to 0  (= 0%).  Set the percentage of replacing the knight with an carnivean (0= never.  100= always). Choose any value you want between 0 and 100
									// cvar used inside knight.qc




/////// Yakman health value:
var float autocvar_yakman_health = 555;			// Yakman큦 have the health value of the monster type it replaces !  This cvar only takes affect in custom maps, where the Yakmans are spawned directly !
							// cvar used inside yakman.qc
/////// Yakman melee damage:	
var float autocvar_yakman_melee_damage = 17;		// set damage value for Yakman melee attacks.
							// cvar used inside yakman.qc
/////// Yakman ram damage:	
var float autocvar_yakman_ram_damage = 27;		// set damage value for Yakman ram attack.
var float autocvar_yakman_ram_velocity = 277;		// set power (velocity) value for Yakman ram attack.
							// cvar used inside yakman.qc
/////// Yakman projectiles damage:
var float autocvar_yakman_projectile_damage = 7;	// set damage value for yakman projectiles impact.
							// cvar used inside yakman.qc
/////// Yakman skin selection:
var float autocvar_yakman_skin_selection = 2;		// set cvar 'yakman_skin_selection' default to 1.   Set the skin you want to have for the Yakman.    "1"= light-brown/grey   "2"= dark-brown/grey   "3"= dark-green/black   "4"= brown/grey   "5"= white/grey   "0"= random skin (1-5)            
							// cvar used inside yakman.qc
/////// Yakman chance to replace a hellknight:
var float autocvar_yakman_replace_hellknight = 10;	// set cvar 'yakman_replace_hellknight' default to 10 (= 10%).  Set the percentage of replacing the hellknight with a yakman (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside hknight.qc
/////// Yakman chance to replace an ogre:
var float autocvar_yakman_replace_ogre = 10;		// set cvar 'yakman_replace_ogre' default to 10 (= 10%).  Set the percentage of replacing the ogre with a yakman (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside ogre.qc
/////// Yakman chance to replace a shalrath:
var float autocvar_yakman_replace_shalrath = 10;	// set cvar 'yakman_replace_shalrath' default to 10 (= 10%).  Set the percentage of replacing the shalrath with a yakman (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside shalrath.qc
/////// Yakman chance to replace a shambler:
var float autocvar_yakman_replace_shambler = 10;	// set cvar 'yakman_replace_shambler' default to 10 (= 10%).  Set the percentage of replacing the shambler with a yakman (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside shambler.qc
/////// Yakman chance to replace a knight:
var float autocvar_yakman_replace_knight = 0;		// set cvar 'yakman_replace_knight' default to 0 (= 0%).  Set the percentage of replacing the knight with a yakman (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside knight.qc




/////// Reiver health value:
var float autocvar_reiver_health = 200;			// Reiver큦 have the health value of the monster type it replaces !  This cvar only takes affect in custom maps, where the Reivers are spawned directly !
							// cvar used inside reiver.qc
/////// Reiver melee scratch damage:	
var float autocvar_reiver_melee_scratch_damage = 4;	// set damage value for Reivers melee scratch attacks.
							// cvar used inside reiver.qc
/////// Reiver projectile type:
var float autocvar_reiver_projectile_type = 60;		// Select chance for different Reivers projectiles: ghosts or fireballs.   ATTENTION: Only fireballs can inflame the player  (see cvar: "reiver_fireball_inflame_chance")          Examples: "0"= always summon ghosts    "100"= always summon fireballs     "50"= use both projectiles randomly (50/50 %).  "75"= 25% chance to use ghosts and 75% to use fireballs		   
							// cvar used inside reiver.qc
/////// Reiver ghost-follower damage:
var float autocvar_reiver_ranged_ghost_damage = 5;	// set damage value for Reivers ranged attack ghost impacts.
							// cvar used inside reiver.qc
/////// Reiver ghost-follower health:
var float autocvar_reiver_ranged_ghost_health = 7;	// set health value for Reivers ranged attack ghosts. Use any value >0
							// cvar used inside reiver.qc
/////// Reiver ghost-follower psycho effect:
var float autocvar_ghost_follower_psycho_effect = 0.3;	// visual screen effect when ghost_follower touches player   0= disabled   Values >0 = enabled  Set the value (in seconds) how long visual effect shall remain
							// cvar used inside reiver.qc and client.qc
/////// Reiver fireball damage:
var float autocvar_reiver_ranged_fireball_damage = 20;	// set damage value for Reivers fireballs.
							// cvar used inside reiver.qc
/////// Reiver fireball health:
var float autocvar_reiver_ranged_fireball_health = 0;	// "0"= Reiver큦 fireballs are NOT shootable.  Use any value >0 to make them shootable/killable. Sets the health value for Reivers fireballs. 
							// cvar used inside reiver.qc
/////// Reiver fireball homing:
var float autocvar_reiver_ranged_fireball_homing = 1;	// "0"= Reiver큦 fireballs are NOT homing (following the player).  "1"= Reiver큦 fireballs are homing (following the player).
							// cvar used inside reiver.qc
/////// Reiver vampire life drain:
var float autocvar_reiver_vampire_life_drain = 5;	// "0"= disable this attack type completely.   Any value >0  --> Set amount of health that is soaked out of players body and added to reivers health during Reivers vampire attack (Reiver cannot have more than his max. health). In easy and normal skill Reiver does it 2 times in each vampire attack. In hard and nightmare skill he does it 3 times.    
							// cvar used inside reiver.qc
/////// Reiver vampire life drain particle effect:
var float autocvar_reiver_vampire_life_drain_particle_effect = 2;	// Set particle effect type for Reivers vampire attack  "0"= disabled  "1"= effect 1 (small dots/stars)   "2"= effect 2 (small blood/cloud)
							// cvar used inside reiver.qc
/////// Reiver death big BANG:
var float autocvar_reiver_death_explosion_radius_damage = 66;	// Set radius damage value for Reivers death
							// cvar used inside reiver.qc
/////// Reiver multi_shield chance:
var float autocvar_reiver_multi_shield_chance = 10;	// set cvar 'reiver_multi_shield_chance' default to 10  (= 10%).  Set chance of spawning multi_shield around reiver, that blocks projectiles  (0= never(disable this feature)   100= always). Choose any value you want between 0 and 100   
							// cvar used inside combat.qc
/////// Reiver multi_shield lifetime:
var float autocvar_reiver_multi_shield_lifetime = 1.5;	// set cvar 'reiver_multi_shield_lifetime' default to 2.   Set lifetime in seconds for multi_shield around reiver each time it spawns.  Choose any value you want  > 0   
							// cvar used inside combat.qc and reiver.qc

/////// Reiver chance to hide in the underground:
var float autocvar_reiver_hide_underground = 40;	// set cvar 'reiver_hide_underground' default to 40  (= 40%).  Set the chance for Reiver hiding/sneeking in the underground  (0= never.  100= always). Choose any value you want between 0 and 100    ATTENTION: Only when replacing walking monsters !!
							// cvar used inside reiver.qc

/////// Reiver큦 chance to replace a demon:
var float autocvar_reiver_replace_demon = 0;		// set cvar 'reiver_replace_demon' default to 0  (= 0%).  Set the chance of replacing the demon with an reiver (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside demon.qc
/////// Reiver큦 chance to support a demon:
var float autocvar_reiver_supports_demon = 5;		// set cvar 'reiver_supports_demon' default to 5  (= 5%).  Set the chance of spawning an ADDITIONAL reiver beside a demon  (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside demon.qc
/////// Reiver큦 chance to replace a dog:
var float autocvar_reiver_replace_dog = 0;		// set cvar 'reiver_replace_dog' default to 0  (= 0%).  Set the chance of replacing the dog with an reiver (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside dog.qc
/////// Reiver큦 chance to support a dog:
var float autocvar_reiver_supports_dog = 0;		// set cvar 'reiver_supports_dog' default to 0  (= 0%).  Set the chance of spawning an ADDITIONAL reiver beside a dog  (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside dog.qc
/////// Reiver큦 chance to replace a enforcer:
var float autocvar_reiver_replace_enforcer = 0;		// set cvar 'reiver_replace_enforcer' default to 0  (= 0%).  Set the chance of replacing the enforcer with an reiver (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside enforcer.qc
/////// Reiver큦 chance to support a enforcer:
var float autocvar_reiver_supports_enforcer = 0;	// set cvar 'reiver_supports_enforcer' default to 0  (= 0%).  Set the chance of spawning an ADDITIONAL reiver beside a enforcer  (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside enforcer.qc
/////// Reiver큦 chance to replace a hknight:
var float autocvar_reiver_replace_hknight = 0;		// set cvar 'reiver_replace_hknight' default to 0  (= 0%).  Set the chance of replacing the hknight with an reiver (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside hknight.qc
/////// Reiver큦 chance to support a hknight:
var float autocvar_reiver_supports_hknight = 10;	// set cvar 'reiver_supports_hknight' default to 10  (= 10%).  Set the chance of spawning an ADDITIONAL reiver beside a hknight  (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside hknight.qc
/////// Reiver큦 chance to replace a knight:
var float autocvar_reiver_replace_knight = 0;		// set cvar 'reiver_replace_knight' default to 0  (= 0%).  Set the chance of replacing the knight with an reiver (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside knight.qc
/////// Reiver큦 chance to support a knight:
var float autocvar_reiver_supports_knight = 5;		// set cvar 'reiver_supports_knight' default to 5  (= 5%).  Set the chance of spawning an ADDITIONAL reiver beside a knight  (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside knight.qc
/////// Reiver큦 chance to replace a ogre:
var float autocvar_reiver_replace_ogre = 0;		// set cvar 'reiver_replace_ogre' default to 0  (= 0%).  Set the chance of replacing the ogre with an reiver (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside ogre.qc
/////// Reiver큦 chance to support a ogre:
var float autocvar_reiver_supports_ogre = 5;		// set cvar 'reiver_supports_ogre' default to 5  (= 5%).  Set the chance of spawning an ADDITIONAL reiver beside a ogre  (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside ogre.qc
/////// Reiver큦 chance to replace a shalrath:
var float autocvar_reiver_replace_shalrath = 0;		// set cvar 'reiver_replace_shalrath' default to 0  (= 0%).  Set the chance of replacing the shalrath with an reiver (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside shalrath.qc
/////// Reiver큦 chance to support a shalrath:
var float autocvar_reiver_supports_shalrath = 5;	// set cvar 'reiver_supports_shalrath' default to 5  (= 5%).  Set the chance of spawning an ADDITIONAL reiver beside a shalrath  (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside shalrath.qc
/////// Reiver큦 chance to replace a shambler:
var float autocvar_reiver_replace_shambler = 0;		// set cvar 'reiver_replace_shambler' default to 0  (= 0%).  Set the chance of replacing the shambler with an reiver (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside shambler.qc
/////// Reiver큦 chance to support a shambler:
var float autocvar_reiver_supports_shambler = 5;	// set cvar 'reiver_supports_shambler' default to 5  (= 5%).  Set the chance of spawning an ADDITIONAL reiver beside a shambler  (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside shambler.qc
/////// Reiver큦 chance to replace a soldier:
var float autocvar_reiver_replace_soldier = 0;		// set cvar 'reiver_replace_soldier' default to 0  (= 0%).  Set the chance of replacing the soldier with an reiver (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside soldier.qc
/////// Reiver큦 chance to support a soldier:
var float autocvar_reiver_supports_soldier = 0;		// set cvar 'reiver_supports_soldier' default to 0  (= 0%).  Set the chance of spawning an ADDITIONAL reiver beside a soldier  (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside soldier.qc
/////// Reiver큦 chance to replace a tarbaby:
var float autocvar_reiver_replace_tarbaby = 0;		// set cvar 'reiver_replace_tarbaby' default to 0  (= 0%).  Set the chance of replacing the tarbaby with an reiver (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside tarbaby.qc
/////// Reiver큦 chance to support a tarbaby:
var float autocvar_reiver_supports_tarbaby = 5;		// set cvar 'reiver_supports_tarbaby' default to 5  (= 5%).  Set the chance of spawning an ADDITIONAL reiver beside a tarbaby  (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside tarbaby.qc
/////// Reiver큦 chance to replace a wizard:
var float autocvar_reiver_replace_wizard = 15;		// set cvar 'reiver_replace_wizard' default to 15 (= 15%).  Set the percentage of replacing the wizard with a reiver (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside wizard.qc
/////// Reiver큦 chance to support a wizard:
var float autocvar_reiver_supports_wizard = 5;		// set cvar 'reiver_supports_wizard' default to 5  (= 5%).  Set the chance of spawning an ADDITIONAL reiver beside a wizard  (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside wizard.qc
/////// Reiver큦 chance to replace a zombie:
var float autocvar_reiver_replace_zombie = 0;		// set cvar 'reiver_replace_zombie' default to 0  (= 0%).  Set the chance of replacing the zombie with an reiver (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside zombie.qc
/////// Reiver큦 chance to support a zombie:
var float autocvar_reiver_supports_zombie = 0;		// set cvar 'reiver_supports_zombie' default to 0  (= 0%).  Set the chance of spawning an ADDITIONAL reiver beside a zombie  (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside zombie.qc





var float autocvar_necromancer_replace_wizard = 17;			// set cvar 'necromancer_replace_wizard' default to 17 (= 17%).  Set the percentage of replacing the wizard with a necromancer (0= never.  100= always). Choose any value you want between 0 and 100
									// cvar used inside wizard.qc
var float autocvar_necromancer_health = 150;				// Necromancer큦 have the health value of the monster type it replaces !  This cvar only takes affect in custom maps, where the Necromancers are spawned directly !
									// cvar used inside necromancer.qc
var float autocvar_necromancer_skin = 1;				// set cvar 'necromancer_skin' default to 1.   Set texture for Necromancer here.   "0"= randomly select skin 1, 2 or 3   "1"= always use skin 1    "2"= always use skin 2   "3"= always use skin 3
									// cvar used inside necromancer.qc
var float autocvar_necromancer_summon_sprite_effect = 0;		// set cvar 'necromancer_summon_sprite_effect' default to 0    Choose between 2 different spherical summon effects in front of necromancer while summoning     "1"= Choose effect 1     "2"= Choose effect 2     "3"= Choose randomly 1 or 2     (ATTENTION: If you enabled the "necromancer_summon_particle_effect", you should NOT enable this sprite effect in addition)
									// cvar used inside necromancer.qc
var float autocvar_necromancer_summon_particle_effect = 1;		// set cvar 'necromancer_summon_particle_effect' default to 1     "0"= disabled    "1"= enabled    Add particle summon effect in front of necromancer while summoning    (ATTENTION: If you enabled any of the "necromancer_summon_sprite_effect"큦, you should NOT enable this particle effect in addition)
									// cvar used inside necromancer.qc
var float autocvar_necromancer_summon_minions = 2;			// set cvar 'necromancer_summon_minions' default to 2     Choose which monsters shall be summoned by necromancer     "0"= disabled (no monster summoning. Only ranged attacks)    "1"= summon only wizards (low threat)    "2"= summon only wizards or afrits (medium threat)     3= summon wizards, afrits or reivers (high threat)
									// cvar used inside necromancer.qc
var float autocvar_necromancer_summon_minions_chance = 25;		// set cvar 'necromancer_summon_minions_chance' default to 25 (= 25%)     Set the chance for summoning monsters when necromancer is attacking.     "0"= never / only cast ranged attacks    "100"= always       Choose any value you want between 0 and 100
									// cvar used inside necromancer.qc
var float autocvar_necromancer_summon_minions_min_time_interval = 6;	// set cvar 'necromancer_summon_minions_min_time_interval' default to 6 (= 6 seconds)     Set minimum time intervall between summoning monsters.      The smaller the time intervall the more often chance for summoning monsters.     Choose any value you want greater than 0.
									// cvar used inside necromancer.qc
var float autocvar_necromancer_skull_damage = 10;			// set damage value of necromancers skull attack (be aware that 2 skulls are spawned during attack animation)
									// cvar used inside necromancer.qc
var float autocvar_necromancer_ray_damage = 2;				// set damage value of necromancers ray attack (be aware that multiple rays are spawned during attack animation)
									// cvar used inside necromancer.qc
var float autocvar_necromancer_death_explosion_radius_damage = 75;	// set damage value of the necromancers skull attack
									// cvar used inside necromancer.qc
var float autocvar_necromancer_pentagram_health = 5;			// set health value of pickable pentagram when necromancer dies
									// cvar used inside necromancer.qc




/////// Teneb chance to replace a demon:
var float autocvar_teneb_replace_demon = 20;		// set cvar 'teneb_replace_demon' default to 20  (= 20%).  Set the percentage of replacing the demon with an Teneb (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside hknight.qc




/////// Water walk and swim sound
var float autocvar_waterwalk_and_swim_sound = 2;	// set cvar 'waterwalk_and_swim_sound' default to 2.  0= disable waterwalk and swim sound  1= only play waterwalk sound  2= play waterwalk AND swim sound
							// cvar used inside player.qc

/////// Player Footsteps
var float autocvar_playerfootsteps = 0.5;		// set cvar 'playerfootsteps' default to 0.5.   0= disable footsteps sound     1= max. volume footsteps sound for player   (0.5 plays footsteps with half volume. Choose any volume-value you want between 0 and 1)
							// cvar used inside player.qc



/////// Use visual "adrenalin" screen effect
var float autocvar_psycho = 0;		  	 // visual screen effect when picking up quad and/or pent   0= disabled  1= enable when picking up quad   2= enable when picking up pent   3= enable when picking up quad OR pent
						 // cvar used inside world.qc and client.qc




/////// Use Slowmotion
var float autocvar_slowmotion = 2;			// set cvar 'slowmotion' default to 2. "0" disabled. "1" start slowmotion ONLY when gibbing living monsters. "2" start slowmotion also when gibbing corpses. "3" start slowmotion also at regular killing. "4" start slowmotion also when hurting enemies
							// cvar used inside world.qc and all monsters .qc files
/////// Slowmotion intensity
var float autocvar_slowmotion_intensity = 0.35;		// set cvar 'slowmotion_intensity' default to 0.35.  Set the slowmotion / game speed.  "0.3" means 30% of regular time / game speed. (0= totally freeze.  1= normal speed.). Choose any value you want between 0 and 1 (higher values will increase speed)
							// cvar used inside client.qc, world.qc and all monsters .qc files
/////// Slowmotion duration
var float autocvar_slowmotion_duration = 2;		// set cvar 'slowmotion_duration' default to 2.  Set the slowmotion duration in seconds.  
							// cvar used inside world.qc and all monsters .qc files
/////// Slowmotion occurrence corpses
var float autocvar_slowmotion_randomness_corpse = 17;	// set cvar 'slowmotion_randomness_corpse' default to 17  (= 17%).  Set chance of slowmotion effect appearance for when gibbing corpses (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside the monsters .qc file
/////// Slowmotion occurrence afrit
var float autocvar_slowmotion_randomness_afrit = 20;	// set cvar 'slowmotion_randomness_afrit' default to 20  (= 20%).  Set chance of slowmotion effect appearance for this monster-type (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside the monsters .qc file
/////// Slowmotion occurrence carnivean
var float autocvar_slowmotion_randomness_carnivean = 20; // set cvar 'slowmotion_randomness_carnivean' default to 20  (= 20%).  Set chance of slowmotion effect appearance for this monster-type (0= never.  100= always). Choose any value you want between 0 and 100
							 // cvar used inside the monsters .qc file
/////// Slowmotion occurrence demon
var float autocvar_slowmotion_randomness_demon = 20;	// set cvar 'slowmotion_randomness_demon' default to 20  (= 20%).  Set chance of slowmotion effect appearance for this monster-type (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside the monsters .qc file
/////// Slowmotion occurrence dog
var float autocvar_slowmotion_randomness_dog = 17;	// set cvar 'slowmotion_randomness_dog' default to 17  (= 17%).  Set chance of slowmotion effect appearance for this monster-type (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside the monsters .qc file
/////// Slowmotion occurrence enforcer
var float autocvar_slowmotion_randomness_enforcer = 17;	// set cvar 'slowmotion_randomness_enforcer' default to 17  (= 17%).  Set chance of slowmotion effect appearance for this monster-type (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside the monsters .qc file
/////// Slowmotion occurrence hknight
var float autocvar_slowmotion_randomness_hknight = 20;	// set cvar 'slowmotion_randomness_hknight' default to 20  (= 20%).  Set chance of slowmotion effect appearance for this monster-type (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside the monsters .qc file
/////// Slowmotion occurrence knight
var float autocvar_slowmotion_randomness_knight = 17;	// set cvar 'slowmotion_randomness_knight' default to 17  (= 17%).  Set chance of slowmotion effect appearance for this monster-type (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside the monsters .qc file
/////// Slowmotion occurrence ogre
var float autocvar_slowmotion_randomness_ogre = 20;	// set cvar 'slowmotion_randomness_ogre' default to 20  (= 20%).  Set chance of slowmotion effect appearance for this monster-type (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside the monsters .qc file
/////// Slowmotion occurrence reiver
var float autocvar_slowmotion_randomness_reiver = 20;	// set cvar 'slowmotion_randomness_reiver' default to 20  (= 20%).  Set chance of slowmotion effect appearance for this monster-type (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside the monsters .qc file
/////// Slowmotion occurrence shalrath
var float autocvar_slowmotion_randomness_shalrath = 25;	// set cvar 'slowmotion_randomness_shalrath' default to 25  (= 25%).  Set chance of slowmotion effect appearance for this monster-type (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside the monsters .qc file
/////// Slowmotion occurrence shambler
var float autocvar_slowmotion_randomness_shambler = 30;	// set cvar 'slowmotion_randomness_shambler' default to 30  (= 30%).  Set chance of slowmotion effect appearance for this monster-type (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside the monsters .qc file
/////// Slowmotion occurrence soldier
var float autocvar_slowmotion_randomness_soldier = 15;	// set cvar 'slowmotion_randomness_soldier' default to 15  (= 15%).  Set chance of slowmotion effect appearance for this monster-type (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside the monsters .qc file
/////// Slowmotion occurrence spider
var float autocvar_slowmotion_randomness_spider = 15;	// set cvar 'slowmotion_randomness_spider' default to 15  (= 15%).  Set chance of slowmotion effect appearance for this monster-type (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside the monsters .qc file
/////// Slowmotion occurrence torment
var float autocvar_slowmotion_randomness_torment = 20;	// set cvar 'slowmotion_randomness_torment' default to 20  (= 20%).  Set chance of slowmotion effect appearance for this monster-type (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside the monsters .qc file
/////// Slowmotion occurrence Warlord
var float autocvar_slowmotion_randomness_warlord = 20;	// set cvar 'slowmotion_randomness_warlord' default to 20  (= 20%).  Set chance of slowmotion effect appearance for this monster-type (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside the monsters .qc file
/////// Slowmotion occurrence wizard
var float autocvar_slowmotion_randomness_wizard = 15;	// set cvar 'slowmotion_randomness_wizard' default to 15  (= 15%).  Set chance of slowmotion effect appearance for this monster-type (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside the monsters .qc file
/////// Slowmotion occurrence yakman
var float autocvar_slowmotion_randomness_yakman = 20;	// set cvar 'slowmotion_randomness_yakman' default to 20  (= 20%).  Set chance of slowmotion effect appearance for this monster-type (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside the monsters .qc file
/////// Slowmotion occurrence zombie
var float autocvar_slowmotion_randomness_zombie = 5;	// set cvar 'slowmotion_randomness_zombie' default to 5  (= 10%).  Set chance of slowmotion effect appearance for this monster-type (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside the monsters .qc file



/////// afrits health:
var float autocvar_afrit_health = 120;			// Afrit큦 have the health value of the monster type it replaces/supports !  This cvar only takes affect in custom maps, where the Afrits are spawned directly !
							// cvar used inside afrit.qc
/////// afrits cocoon shape:
var float autocvar_afrit_waits_in_cocoon = 40;		// set cvar 'afrit_waits_in_cocoon' default to 40 (= 40%).  Set the chance for afrit using his cocoon shape while idling. (0% = never.  100% = always). Choose any value you want between 0 and 100
							// cvar used inside afrit.qc
/////// afrits fireball damage:
var float autocvar_afrit_fireball_damage = 7;		// set cvar 'afrit_fireball_damage' default to 7.  Set the amount of damage per fireball-hit.
							// cvar used inside afrit.qc
/////// afrits chance to replace a demon:
var float autocvar_afrit_replace_demon = 0;		// set cvar 'afrit_replace_demon' default to 0  (= 0%).  Set the chance of replacing the demon with an afrit (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside demon.qc
/////// afrits chance to support a demon:
var float autocvar_afrit_supports_demon = 10;		// set cvar 'afrit_supports_demon' default to 10  (= 10%).  Set the chance of spawning an ADDITIONAL afrit beside a demon  (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside demon.qc
/////// afrits chance to replace a dog:
var float autocvar_afrit_replace_dog = 0;		// set cvar 'afrit_replace_dog' default to 0  (= 0%).  Set the chance of replacing the dog with an afrit (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside dog.qc
/////// afrits chance to support a dog:
var float autocvar_afrit_supports_dog = 0;		// set cvar 'afrit_supports_dog' default to 0  (= 0%).  Set the chance of spawning an ADDITIONAL afrit beside a dog  (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside dog.qc
/////// afrits chance to replace a enforcer:
var float autocvar_afrit_replace_enforcer = 0;		// set cvar 'afrit_replace_enforcer' default to 0  (= 0%).  Set the chance of replacing the enforcer with an afrit (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside enforcer.qc
/////// afrits chance to support a enforcer:
var float autocvar_afrit_supports_enforcer = 0;		// set cvar 'afrit_supports_enforcer' default to 0  (= 0%).  Set the chance of spawning an ADDITIONAL afrit beside a enforcer  (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside enforcer.qc
/////// afrits chance to replace a hknight:
var float autocvar_afrit_replace_hknight = 0;		// set cvar 'afrit_replace_hknight' default to 0  (= 0%).  Set the chance of replacing the hknight with an afrit (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside hknight.qc
/////// afrits chance to support a hknight:
var float autocvar_afrit_supports_hknight = 10;		// set cvar 'afrit_supports_hknight' default to 10  (= 10%).  Set the chance of spawning an ADDITIONAL afrit beside a hknight  (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside hknight.qc
/////// afrits chance to replace a knight:
var float autocvar_afrit_replace_knight = 0;		// set cvar 'afrit_replace_knight' default to 0  (= 0%).  Set the chance of replacing the knight with an afrit (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside knight.qc
/////// afrits chance to support a knight:
var float autocvar_afrit_supports_knight = 5;		// set cvar 'afrit_supports_knight' default to 5  (= 5%).  Set the chance of spawning an ADDITIONAL afrit beside a knight  (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside knight.qc
/////// afrits chance to replace a ogre:
var float autocvar_afrit_replace_ogre = 0;		// set cvar 'afrit_replace_ogre' default to 0  (= 0%).  Set the chance of replacing the ogre with an afrit (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside ogre.qc
/////// afrits chance to support a ogre:
var float autocvar_afrit_supports_ogre = 10;		// set cvar 'afrit_supports_ogre' default to 10  (= 10%).  Set the chance of spawning an ADDITIONAL afrit beside a ogre  (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside ogre.qc
/////// afrits chance to replace a shalrath:
var float autocvar_afrit_replace_shalrath = 0;		// set cvar 'afrit_replace_shalrath' default to 0  (= 0%).  Set the chance of replacing the shalrath with an afrit (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside shalrath.qc
/////// afrits chance to support a shalrath:
var float autocvar_afrit_supports_shalrath = 5;		// set cvar 'afrit_supports_shalrath' default to 5  (= 5%).  Set the chance of spawning an ADDITIONAL afrit beside a shalrath  (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside shalrath.qc
/////// afrits chance to replace a shambler:
var float autocvar_afrit_replace_shambler = 0;		// set cvar 'afrit_replace_shambler' default to 0  (= 0%).  Set the chance of replacing the shambler with an afrit (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside shambler.qc
/////// afrits chance to support a shambler:
var float autocvar_afrit_supports_shambler = 5;		// set cvar 'afrit_supports_shambler' default to 5  (= 5%).  Set the chance of spawning an ADDITIONAL afrit beside a shambler  (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside shambler.qc
/////// afrits chance to replace a soldier:
var float autocvar_afrit_replace_soldier = 0;		// set cvar 'afrit_replace_soldier' default to 0  (= 0%).  Set the chance of replacing the soldier with an afrit (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside soldier.qc
/////// afrits chance to support a soldier:
var float autocvar_afrit_supports_soldier = 0;		// set cvar 'afrit_supports_soldier' default to 0  (= 0%).  Set the chance of spawning an ADDITIONAL afrit beside a soldier  (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside soldier.qc
/////// afrits chance to replace a tarbaby:
var float autocvar_afrit_replace_tarbaby = 10;		// set cvar 'afrit_replace_tarbaby' default to 10  (= 10%).  Set the chance of replacing the tarbaby with an afrit (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside tarbaby.qc
/////// afrits chance to support a tarbaby:
var float autocvar_afrit_supports_tarbaby = 10;		// set cvar 'afrit_supports_tarbaby' default to 10  (= 10%).  Set the chance of spawning an ADDITIONAL afrit beside a tarbaby  (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside tarbaby.qc
/////// afrits chance to replace a wizard:
var float autocvar_afrit_replace_wizard = 17;		// set cvar 'afrit_replace_wizard' default to 17  (= 17%).  Set the chance of replacing the wizard with an afrit (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside wizard.qc
/////// afrits chance to support a wizard:
var float autocvar_afrit_supports_wizard = 10;		// set cvar 'afrit_supports_wizard' default to 10  (= 10%).  Set the chance of spawning an ADDITIONAL afrit beside a wizard  (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside wizard.qc
/////// afrits chance to replace a zombie:
var float autocvar_afrit_replace_zombie = 0;		// set cvar 'afrit_replace_zombie' default to 0  (= 0%).  Set the chance of replacing the zombie with an afrit (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside zombie.qc
/////// afrits chance to support a zombie:
var float autocvar_afrit_supports_zombie = 5;		// set cvar 'afrit_supports_zombie' default to 5  (= 5%).  Set the chance of spawning an ADDITIONAL afrit beside a zombie  (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside zombie.qc




/////// spiders health value
var float autocvar_spider_health = 111;			// Spider큦 have the health value of the monster type it replaces !  This cvar only takes affect in custom maps, where the Spiders are spawned directly !
							// cvar used inside spider.qc
/////// spiders melee attack damage value
var float autocvar_spider_melee = 7;			// set damage value of this monster attack type.
							// cvar used inside spider.qc
/////// spiders jump attack damage value
var float autocvar_spider_jump = 15;			// set damage value of this monster attack type.
							// cvar used inside spider.qc
/////// spiders ranged attack damage value
var float autocvar_spider_web = 7;			// set damage value of this monster attack type.
							// cvar used inside spider.qc
/////// spiders chance to resist an attack:
var float autocvar_spider_attack_resistance = 25;	// set cvar 'spider_attack_resistance' default to 25  (= 25%).  Set the percentage how much the spider has a chance to resist an attack  (0= never.  100= always resist). Choose any value you want between 0 and 100
							// cvar used inside weapons.qc
/////// spiders improved jump behaviour  (takes height difference into account)
var float autocvar_spider_improved_jump_behaviour = 1;	// set cvar 'spider_improved_jump_behaviour' default to 1.   0= only jumps towards player when his position is in a close z-range compared to player (dependency/behaviour is identical to demon. Like in SMC before)       1= always jumps towards player and taking height difference into account (doesnt matter if player is much higher or lower than spider in world) 
							// cvar used inside spider.qc
/////// spiders chance to jump and hang on ceiling on map start:
var float autocvar_spider_hanging_on_ceiling_on_map_start_chance = 50;	// set cvar 'spider_hanging_on_ceiling_on_map_start_chance' default to 50  (= 50%).   Set chance for spider to try to jump and hang on ceiling at beginning of a map, for better suprise affect.  (0= never(disable this feature)   100= always). Choose any value you want between 0 and 100   
									// cvar used inside spider.qc
/////// spiders minimum space towards roof for jumping:
var float autocvar_spider_free_space_limit_for_jumping = 100;	// set cvar 'spider_free_space_limit_for_jumping' default to 100.   Set a minimum space above spider (between it head and the ceiling) to do a jump and hang on ceiling at map start. When space is smaller than this value, spiders will not perform a jump.  
								// cvar used inside spider.qc
/////// Spider skin selection:
var float autocvar_spider_random_skin_selection = 1;	// set cvar 'spider_random_skin_selection' default to 1.   "0"= Spider will use a dedicated skin, depending on the replaced monster type.   "1"= always use a random skin color (independ to which monster the spider replaces)   
							// cvar used inside spider.qc
/////// spiders chance to hide in the underground:
var float autocvar_spider_hide_underground = 37;	// set cvar 'spider_hide_underground' default to 37  (= 37%).  Set the percentage chance for spider hiding/sneeking in the underground  (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside spider.qc
/////// spiders paralyze attack time:
var float autocvar_spider_web_paralyzetime = 2;		// set cvar 'spider_web_paralyzetime' default to 2 seconds.  Sets the paralyze-time of spiders ranged web attacks. Choose any  positive value you want (in seconds).
							// cvar used inside spider.qc
/////// spiders paralyze particle effect around player:
var float autocvar_spider_paralyze_effect = 1;		// set cvar 'spider_paralyze_effect' default to 1   Choose between 2 different particle effects, when projectile hits the player  (choose between "1" and "2")
							// cvar used inside spider.qc
/////// Spider spawn inside water:
var float autocvar_spider_can_spawn_in_water = 0;	// set cvar 'spider_can_spawn_in_water' default to 0.   "0"= Spider will not replace monsters which are in water, because original Quake has no transparent water and in shallow waters spider cann not be seen (like e1m3)    "1"= Spider CAN replace monsters which are in water. Use "1" when you have transparent water.
							// cvar used inside all monsters .qc
/////// spiders chance to replace a demon:
var float autocvar_spider_replace_demon = 10;		// set cvar 'spider_replace_demon' default to 10  (= 10%).  Set the percentage of replacing the demon with a spider (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside demon.qc
/////// spiders chance to replace a dog:
var float autocvar_spider_replace_dog = 15;		// set cvar 'spider_replace_dog' default to 15  (= 15%).  Set the percentage of replacing the dog with a spider (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside dog.qc
/////// spiders chance to replace a enforcer:
var float autocvar_spider_replace_enforcer = 0;		// set cvar 'spider_replace_enforcer' default to 0  (= 0%).  Set the percentage of replacing the enforcer with a spider (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside enforcer.qc
/////// spiders chance to replace a hknight:
var float autocvar_spider_replace_hknight = 5;		// set cvar 'spider_replace_hknight' default to 5  (= 5%).  Set the percentage of replacing the hknight with a spider (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside hknight.qc
/////// spiders chance to replace a knight:
var float autocvar_spider_replace_knight = 0;		// set cvar 'spider_replace_knight' default to 0  (= 0%).  Set the percentage of replacing the knight with a spider (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside knight.qc
/////// spiders chance to replace a ogre:
var float autocvar_spider_replace_ogre = 0;		// set cvar 'spider_replace_ogre' default to 0  (= 0%).  Set the percentage of replacing the ogre with a spider (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside ogre.qc
/////// spiders chance to replace a shalrath:
var float autocvar_spider_replace_shalrath = 0;		// set cvar 'spider_replace_shalrath' default to 0  (= 0%).  Set the percentage of replacing the shalrath with a spider (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside shalrath.qc
/////// spiders chance to replace a shambler:
var float autocvar_spider_replace_shambler = 5;		// set cvar 'spider_replace_shambler' default to 5  (= 5%).  Set the percentage of replacing the shambler with a spider (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside shambler.qc
/////// spiders chance to replace a soldier:
var float autocvar_spider_replace_soldier = 7;		// set cvar 'spider_replace_soldier' default to 7  (= 7%).  Set the percentage of replacing the soldier with a spider (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside soldier.qc
/////// spiders chance to replace a tarbaby:
var float autocvar_spider_replace_tarbaby = 12;		// set cvar 'spider_replace_tarbaby' default to 12  (= 12%).  Set the percentage of replacing the tarbaby with a spider (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside tarbaby.qc
/////// spiders chance to replace a zombie:
var float autocvar_spider_replace_zombie = 0;		// set cvar 'spider_replace_zombie' default to 0  (= 0%).  Set the percentage of replacing the zombie with a spider (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside zombie.qc




/////// move view_weapons to the right side, with FIXED model-set and model-position (NOT changeable. Not recommended.)
var float autocvar_weapon_position_right = 0;			// set cvar 'weapon_position_right' default to 0 (disabled).   "1" uses a COMPLETE set of preconfigured weapon models, that are moved to the right side. Together with projectiles and muzzleflashes moved to the correct position.    "2" uses the preconfigured set of moved weapon models (EXCEPT Lightning gun ! which remains in the center, due to DP큦 lightning bolt movement-fix)
								// cvar used in player.qc and weapons.qc and client.qc


/////// set view_weapons fully adjustable for any model !!
var float autocvar_weapon_position_fully_adjustable = 2;			// set cvar 'weapon_position_fully_adjustable' default to 2.    "0" disabled    "1" allows to fully adjust any weapon and weapon model positions and angles. As well as projectiles and muzzleflashes spawn positions. Including Lightning gun.    "2" allows to fully adjust any weapon and weapon model positions and angles. As well as projectiles and muzzleflashes spawn positions. EXCEPT Lightning gun ! (which remains in the center, due to DP큦 lightning bolt movement-fix)
										// cvar used in player.qc and weapons.qc and custom_effects.qc and client.qc
var float autocvar_weapon_position_fully_adjustable_idle_animation = 1;			// set cvar 'weapon_position_fully_adjustable_idle_animation' default to 1 (enabled).    "0" disabled    "1" enables random idle weapon animation
											// cvar used in custom_effects.qc
var float autocvar_weapon_position_fully_adjustable_idle_animation_vigor = 0.5;		// set cvar 'weapon_position_fully_adjustable_idle_animation_vigor' default to 0.5      Set your animation strength/intensity here.    Values smaller than "0.5" will decrease animation movement/radius (try 0.2).    Values bigger than "0.5" will increase animation movement/radius (try 1).
											// cvar used in custom_effects.qc
var float autocvar_weapon_position_fully_adjustable_idle_animation_speed = 0.035;	// set cvar 'weapon_position_fully_adjustable_idle_animation_speed' default to 0.035     Set your animation speed here.    Smaller values will increase animation speed (try 0.02).    Bigger values will decrease animation speed (try 0.05).  ATTENTION: When using values bigger than 0.05, animation will start to stutter !
											// cvar used in custom_effects.qc
var float autocvar_weapon_position_fully_adjustable_idle_animation_pause = 0.07;	// set cvar 'weapon_position_fully_adjustable_idle_animation_pause' default to 0.07     You can make a pause after each random animation frequence.    Smaller values will increase chance to make a pause (try 0.005)     Bigger values will decrease chance to make a pause (ATTENTION: When using values bigger than 0.05, animation will almost never pause !)
											// cvar used in custom_effects.qc


//// values behind the "//" in the below weapon positions, are samples for right-handed weapon mode (try them if you want to play with your weapons moved to the right side !)
var float autocvar_weapon_position_fully_adjustable_axe_x_offset = 0;		// Move your view_weapon forward / backward with this value
var float autocvar_weapon_position_fully_adjustable_axe_y_offset = 0; //-5;	// Move your view_weapon left / right with this value
var float autocvar_weapon_position_fully_adjustable_axe_z_offset = 0;		// Move your view_weapon up / down with this value
var float autocvar_weapon_position_fully_adjustable_axe_x_angle = 0;		// Turn your view_weapon up / down with this value
var float autocvar_weapon_position_fully_adjustable_axe_y_angle = 0;		// Turn your view_weapon left / right with this value
var float autocvar_weapon_position_fully_adjustable_axe_z_angle = 0;		// Turn your view_weapon clockwise / counterclockwise with this value

var float autocvar_weapon_position_fully_adjustable_shot1_x_offset = 0;		// Move your view_weapon forward / backward with this value
var float autocvar_weapon_position_fully_adjustable_shot1_y_offset = 0; //-7; 	// Move your view_weapon left / right with this value
var float autocvar_weapon_position_fully_adjustable_shot1_z_offset = 0;		// Move your view_weapon up / down with this value
var float autocvar_weapon_position_fully_adjustable_shot1_x_angle = 0;		// Turn your view_weapon up / down with this value
var float autocvar_weapon_position_fully_adjustable_shot1_y_angle = 0;		// Turn your view_weapon left / right with this value
var float autocvar_weapon_position_fully_adjustable_shot1_z_angle = 0;		// Turn your view_weapon clockwise / counterclockwise with this value

var float autocvar_weapon_position_fully_adjustable_shot2_x_offset = 0;		// Move your view_weapon forward / backward with this value
var float autocvar_weapon_position_fully_adjustable_shot2_y_offset = 0; //-6;	// Move your view_weapon left / right with this value
var float autocvar_weapon_position_fully_adjustable_shot2_z_offset = 0;		// Move your view_weapon up / down with this value
var float autocvar_weapon_position_fully_adjustable_shot2_x_angle = 0;		// Turn your view_weapon up / down with this value
var float autocvar_weapon_position_fully_adjustable_shot2_y_angle = 0;		// Turn your view_weapon left / right with this value
var float autocvar_weapon_position_fully_adjustable_shot2_z_angle = 0;		// Turn your view_weapon clockwise / counterclockwise with this value

var float autocvar_weapon_position_fully_adjustable_nail1_x_offset = 0;		// Move your view_weapon forward / backward with this value
var float autocvar_weapon_position_fully_adjustable_nail1_y_offset = 0; //-12; 	// Move your view_weapon left / right with this value
var float autocvar_weapon_position_fully_adjustable_nail1_z_offset = 0;		// Move your view_weapon up / down with this value
var float autocvar_weapon_position_fully_adjustable_nail1_x_angle = 0;		// Turn your view_weapon up / down with this value
var float autocvar_weapon_position_fully_adjustable_nail1_y_angle = 0;		// Turn your view_weapon left / right with this value
var float autocvar_weapon_position_fully_adjustable_nail1_z_angle = 0;		// Turn your view_weapon clockwise / counterclockwise with this value

var float autocvar_weapon_position_fully_adjustable_nail2_x_offset = 0;		// Move your view_weapon forward / backward with this value
var float autocvar_weapon_position_fully_adjustable_nail2_y_offset = 0; //-13; 	// Move your view_weapon left / right with this value
var float autocvar_weapon_position_fully_adjustable_nail2_z_offset = 0;		// Move your view_weapon up / down with this value
var float autocvar_weapon_position_fully_adjustable_nail2_x_angle = 0;		// Turn your view_weapon up / down with this value
var float autocvar_weapon_position_fully_adjustable_nail2_y_angle = 0;		// Turn your view_weapon left / right with this value
var float autocvar_weapon_position_fully_adjustable_nail2_z_angle = 0;		// Turn your view_weapon clockwise / counterclockwise with this value

var float autocvar_weapon_position_fully_adjustable_gren_x_offset = 0;		// Move your view_weapon forward / backward with this value
var float autocvar_weapon_position_fully_adjustable_gren_y_offset = 0; //-7;	// Move your view_weapon left / right with this value
var float autocvar_weapon_position_fully_adjustable_gren_z_offset = 0;		// Move your view_weapon up / down with this value
var float autocvar_weapon_position_fully_adjustable_gren_x_angle = 0;		// Turn your view_weapon up / down with this value
var float autocvar_weapon_position_fully_adjustable_gren_y_angle = 0;		// Turn your view_weapon left / right with this value
var float autocvar_weapon_position_fully_adjustable_gren_z_angle = 0;		// Turn your view_weapon clockwise / counterclockwise with this value

var float autocvar_weapon_position_fully_adjustable_rock_x_offset = 0; //-1;	// Move your view_weapon forward / backward with this value
var float autocvar_weapon_position_fully_adjustable_rock_y_offset = 0; //-7;	// Move your view_weapon left / right with this value
var float autocvar_weapon_position_fully_adjustable_rock_z_offset = 0; //-1;	// Move your view_weapon up / down with this value
var float autocvar_weapon_position_fully_adjustable_rock_x_angle = 0;		// Turn your view_weapon up / down with this value
var float autocvar_weapon_position_fully_adjustable_rock_y_angle = 0; //-10;	// Turn your view_weapon left / right with this value
var float autocvar_weapon_position_fully_adjustable_rock_z_angle = 0; //-3;	// Turn your view_weapon clockwise / counterclockwise with this value

var float autocvar_weapon_position_fully_adjustable_light_x_offset = 0;		// Move your view_weapon forward / backward with this value  (ATTENTION: Only possible when cvar "autocvar_weapon_position_fully_adjustable" is set to "1". Not recommended.)
var float autocvar_weapon_position_fully_adjustable_light_y_offset = 0; //-10; 	// Move your view_weapon left / right with this value  (ATTENTION: Only possible when cvar "autocvar_weapon_position_fully_adjustable" is set to "1". Not recommended.)
var float autocvar_weapon_position_fully_adjustable_light_z_offset = 0;		// Move your view_weapon up / down with this value  (ATTENTION: Only possible when cvar "autocvar_weapon_position_fully_adjustable" is set to "1". Not recommended.)
var float autocvar_weapon_position_fully_adjustable_light_x_angle = 0;		// Turn your view_weapon up / down with this value  (ATTENTION: Only possible when cvar "autocvar_weapon_position_fully_adjustable" is set to "1". Not recommended.)
var float autocvar_weapon_position_fully_adjustable_light_y_angle = 0;		// Turn your view_weapon left / right with this value  (ATTENTION: Only possible when cvar "autocvar_weapon_position_fully_adjustable" is set to "1". Not recommended.)
var float autocvar_weapon_position_fully_adjustable_light_z_angle = 0;		// Turn your view_weapon clockwise / counterclockwise with this value  (ATTENTION: Only possible when cvar "autocvar_weapon_position_fully_adjustable" is set to "1". Not recommended.)

var float autocvar_weapon_position_adjustable_projectile_nail1a_offset = 3; //10;	// Move your Nailgun nail1 left / right with this value
var float autocvar_weapon_position_adjustable_projectile_nail1b_offset = -3; //5;	// Move your Nailgun nail2 left / right with this value
var float autocvar_weapon_position_adjustable_projectile_nail2_offset = 0; //8;		// Move your Supernailgun nails left / right with this value
var float autocvar_weapon_position_adjustable_projectile_grenade_offset = 0; //6;	// Move your Grenades left / right with this value
var float autocvar_weapon_position_adjustable_projectile_rocket_offset = 0; //8;	// Move your Rockets left / right with this value
var float autocvar_weapon_position_adjustable_projectile_lighting_offset = 0; //6;	// Move your Lightning bolt left / right with this value (ATTENTION: Only possible when cvar "autocvar_weapon_position_fully_adjustable" is set to "1". Not recommended.)

var float autocvar_weapon_position_adjustable_projectile_casing_offset = 2; //8;	// Move your casings left / right with this value
var float autocvar_weapon_position_adjustable_muzzleflash_shot1_offset = 0; //7;	// Move your shotgun muzzleflash left / right with this value
var float autocvar_weapon_position_adjustable_muzzleflash_shot2_offset = 0; //6;	// Move your super-shotgun muzzleflash left / right with this value
var float autocvar_weapon_position_adjustable_muzzleflash_nail1a_offset = 3; //10;	// Move your nailgun muzzleflash1 left / right with this value
var float autocvar_weapon_position_adjustable_muzzleflash_nail1b_offset = -3; //5;	// Move your nailgun muzzleflash2 left / right with this value
var float autocvar_weapon_position_adjustable_muzzleflash_nail2_offset = 0; //7;	// Move your supernailgun muzzleflash left / right with this value





////////  Use magic hands instead of lightnign gun (Hexen 1 weapon)
var float autocvar_mage_weapon = 0;		// set cvar 'mage_weapon' default to 0.    "0"= disabled      "1"= use magical hands weapon (Hexen 1) instead of lightnign gun 
						// cvar used inside client.qc, custom_effects.qc, player.qc, weapons.qc

void () animate_mage_weapon =
{
	if (self.button0)
		return;
	self.animate_mage_weapon_frequence = time + 0.1;

	if ((random() < 0.12) && (!cvar("chase_active")))
		sound (self, CHAN_AUTO, "weapons/v_mage1_idle.wav", 0.8, ATTN_NORM);	

	if (self.animate_mage_weapon_helper == 0)
	{
		self.weaponframe = self.weaponframe + 1;
		if (self.weaponframe > 12)
		{
			self.weaponframe = 11;
			self.animate_mage_weapon_helper = 1;
		}
	}
	else
	{
		self.weaponframe = self.weaponframe - 1;
		if (self.weaponframe < 0)
		{
			self.weaponframe = 1;
			self.animate_mage_weapon_helper = 0;
		}
	}
};





////////  Check bodycount per time and play audio taunt sound
var float autocvar_taunt_sounds = 0;		// set cvar 'taunt_sounds' default to 0.    "0"= disabled      "1"= Play audio taunt file when killing an adjustable value of monster within 2 seconds      "2"= Play audio taunt file only when gibbing an adjustable value of monster within 2 seconds 
						// cvar used inside client.qc, all monsters .qc files
var float autocvar_taunt_sounds_limit = 3;	// set cvar 'taunt_sounds_limit' default to 3.       Select the quantity of killed/gibbed monsters within 2 seconds (so that the taunt sounds are played).   "1"= only 1 monster must be killed/gibbed within 2 seconds to play the taunt sounds (= always !!)     "2"= 2 monsters must be killed/gibbed within 2 seconds to play the taunt sounds     ...and so on
						// cvar used inside custom_effects.qc

void () check_bodycount =
{
	self.check_bodycount_frequence = time + 2;
	
	if (autocvar_taunt_sounds == 1)
	{	
		if ((killed_monsters - killed_monsters_old) >= autocvar_taunt_sounds_limit)
		{
			local float zufall;
			zufall = random();
			if (zufall < 0.2)
				sound (self, CHAN_AUTO, "player/taunt1.wav", 1, ATTN_NORM);
			else if (zufall < 0.4)
				sound (self, CHAN_AUTO, "player/taunt2.wav", 1, ATTN_NORM);
			else if (zufall < 0.6)
				sound (self, CHAN_AUTO, "player/taunt3.wav", 1, ATTN_NORM);
			else if (zufall < 0.8)
				sound (self, CHAN_AUTO, "player/taunt4.wav", 1, ATTN_NORM);
			else 
				sound (self, CHAN_AUTO, "player/taunt5.wav", 1, ATTN_NORM);
		}
	}
	else
	{
		if ((gibbed_monsters - gibbed_monsters_old) >= autocvar_taunt_sounds_limit)
		{
			local float zufal;
			zufal = random();
			if (zufal < 0.2)
				sound (self, CHAN_AUTO, "player/taunt1.wav", 1, ATTN_NORM);
			else if (zufal < 0.4)
				sound (self, CHAN_AUTO, "player/taunt2.wav", 1, ATTN_NORM);
			else if (zufal < 0.6)
				sound (self, CHAN_AUTO, "player/taunt3.wav", 1, ATTN_NORM);
			else if (zufal < 0.8)
				sound (self, CHAN_AUTO, "player/taunt4.wav", 1, ATTN_NORM);
			else 
				sound (self, CHAN_AUTO, "player/taunt5.wav", 1, ATTN_NORM);
		}
	}
	
	killed_monsters_old = killed_monsters;
	gibbed_monsters_old = gibbed_monsters;
};





/////// Use custom backpack models and sounds
var float autocvar_backpack = 2;     			// set cvar 'backpack' default to 2.   "0"= standard backpacks are NOT shootable, floatable in water, use original model for all    "1"= standard backpacks use gyro and can float on water, use original model for all     "2"= backpacks use custom models for each monster, if selected/enabled via below cvars !!
							// cvar used in items.qc
var float autocvar_backpack_enforcer_custom = 1; 	// set cvar 'backpack_enforcer_custom' default to 1.   "0"= use standard/original backpack model for enforcers    "1"= use custom backpack model + sounds for enforcers
							// cvar used in items.qc
var float autocvar_backpack_ogre_custom = 1;     	// set cvar 'backpack_ogre_custom' default to 1.      "0"= use standard/original backpack model for ogres    "1"= use custom backpack model + sound for ogres
							// cvar used in items.qc
var float autocvar_backpack_soldier_custom = 1;  	// set cvar 'backpack_soldier_custom' default to 1.      "0"= use standard/original backpack model for soldiers    "1"= use custom backpack model + sound for soldiers
							// cvar used in items.qc


/////// Spawn debris chunks when exploding boxes detonate
var float autocvar_debris = 1;          		// set cvar 'debris' default to 1.   "0"= disable spawning of debris chunks when exploding boxes detonate  "1"= enable spawning debris chunks when exploding boxes detonate
							// cvar used in misc.qc


/////// change weapon sounds:
var float autocvar_changeweaponsounds = 0.7;		// set cvar 'changeweaponsounds' default to 0.7.  0= disabled  1= max volume.  Plays custom change-weapon-sounds, when changing your weapon.
							// cvar used inside all monsters .qc files

/////// monster footsteps:
var float autocvar_monsterfootsteps = 1;		// set cvar 'monsterfootsteps' default to 1  (enable/disable monster footstep sounds)
							// cvar used inside all monsters .qc files

/////// Monster transparency::
var float autocvar_monstertransparency = 100;		// set cvar 'monstertransparency' default to 100 (= 100% = fully opaque).  Set the percentage how much transparent the monsters shall be (0= fully invisible). Choose any value you want between 0 and 100
							// cvar used inside all monsters .qc files


/////// Shell casing:
var float autocvar_shellcasing = 1;			// set cvar 'shellcasing' default to 1 (enabled).  If enabled, shell casing will be ejected when shooting with SG / SSG  
							// cvar used inside player.qc and weapons.qc
var float autocvar_gruntcasing = 1;			// set cvar 'gruntcasing' default to 1 (enabled).  If enabled, the grunt (soldier) monster will eject shell casings when shooting  
							// cvar used inside soldier.qc
var float autocvar_casinglifetime = 20;			// set cvar 'casinglifetime' default to 20 seconds   (sets the lifetime of shell casings before they start to fade away)
							// cvar used inside weapons.qc 	
var float autocvar_casingejectpos = 0;			// set cvar 'casingejectpos' default to 0  (you can adjust the z-position (= height position) of shell casing ejection
							// cvar used inside weapons.qc 	
var float autocvar_casingejectframe = 3;		// set cvar 'casingejectframe' default to 3  (adjust when the casings shall be ejected out of the weapon ("0"= 1st frame (=immediately); "1"= 2nd frame; and so on... until "5"= last frame))
							// cvar used inside player.qc 	
var float autocvar_casingusegyro = 1;			// set cvar 'casingusegyro' default to 1  ("0"= casings dont use gyro;  "1" casings use gyro)
							// cvar used inside player.qc 	
var float autocvar_casingmass = 950;			// set cvar 'casingemass' default to 950  (adjust your casing mass here)
							// cvar used inside player.qc 
var float autocvar_casingdropsound = 0.22;		// set cvar 'casingdropsound' default to 0.22    0= disabled  1= max volume.  (Plays random sound when shell casing drops to floor)
							// cvar used inside weapons.qc 	



/////// Nail stuck lifetime:
var float autocvar_spikelifetime = 20;			// set cvar 'spikelifetime' default to 20 seconds   (sets the lifetime of nails before they start to fade away)
							// cvar used inside weapons.qc 	


/////// Burnable corpses:
var float autocvar_corpseburntime = 4;			// set cvar 'corpseburntime' default to 4 seconds   (sets the burntime when corpses catch fire)
							// cvar used inside world.qc 
var float autocvar_corpseburnpentagram = 1;		// set cvar 'corpseburnpentagram' default to 1   (enables/disables pentagram after corpse has burned out)
							// cvar used inside world.qc 
var float autocvar_corpseburnpentagram_health = 5;	// set cvar 'corpseburnpentagram_health' default to 5     0= player receives NO health when touching pentagram     set the amount of health points the player receives when touching the magical pentagram
							// cvar used inside world.qc 



/////// New zombie model:
var float autocvar_zombie_use_newmodel = 30;		// set cvar 'zombieusenewmodel' default to 30%   (see detailed description in zombie.qc)
							// cvar used inside zombie.qc 
var float autocvar_zombieaxeanimation = 1;  		// set cvar 'zombieaxeanimation' default to 1
							// cvar used inside weapons.qc and world.qc
var float autocvar_zombienewmodelproperties = 1;	// set cvar 'zombienewmodelproperties' default to 1   (see detailed description in zombie.qc)
							// cvar used inside zombie.qc and weapons.qc
var float autocvar_zombienewmodelburnable = 1;		// set cvar 'zombienewmodelburnable' default to 1  
							// cvar used inside world.qc
var float autocvar_zombienewmodelprojectile = 1;	// set cvar 'zombienewmodelprojectile' default to 1  
							// cvar used inside zombie.qc



/////// Blood extension:
var float autocvar_bloodextension = 1;			// set cvar 'bloodextension' default to 1     "0"= disabled     "1"= use extended blood effects when shooting and gibbing corpses as well as gibbing living monsters
							// cvar used inside all monsters  .qc files, player.qc and world.qc

////// animated heartgib:
var float autocvar_heartgib = 2;			// set cvar 'heartgib' default to 2
							// cvar used inside all monsters  .qc files, player.qc and world.qc
var float autocvar_heartgiblifetime = 7;		// set cvar 'heartgiblifetime' default to 7 seconds. It is the time where the heartgib is beating/pumping before it dies.




////// monster can create an earthquake:
var float autocvar_monstercorpsequake = 1;		// set cvar 'monstercorpsequake' default to 1  (sets level of earth shaking when monster corpse falls on the floor) "0"= disabled  "1"= standard value.  Values <"1" reduces the effect (try 0.4);  values >"1" amplifies the effect(try 1.4). 

float() crandom;
void (float fPunchStrength, float fRadius) Monster_Animation_EarthQuake =	// idea taken from kleshik
{ 
if(self.flags & FL_ONGROUND)
{ 
	if (autocvar_monstercorpsequake)
	{ 
		local entity enFind;
		enFind = findradius(self.origin, fRadius);
			
		while(enFind)
		{ 
			if(enFind.flags & FL_ONGROUND && enFind != self)
			{ 
				if (enFind.flags & FL_MONSTER || enFind.classname == "player")
				{
					enFind.velocity_x = autocvar_monstercorpsequake * (enFind.velocity_x + (crandom() * fPunchStrength * 5));  
					enFind.velocity_y = autocvar_monstercorpsequake * (enFind.velocity_y + (crandom() * fPunchStrength * 5)); 
					enFind.velocity_z = autocvar_monstercorpsequake * (enFind.velocity_z + (fPunchStrength * 10) + (crandom() * 40));  
				}
				if(enFind.classname == "player")
					enFind.punchangle = enFind.punchangle + (randomvec() * (0.7 * fPunchStrength));  // Apply Punchangle
			}
			enFind = enFind.chain;
		}
	}
}
};



////// shambler + yakman can make the ground shattering and kickup dust when walking/running:
var float autocvar_shambler_walking_quake = 3;		// set cvar 'shambler_walking_quake' default to 3    "0"= disabled    "1"= shambler footsteps makes the ground shattering when he walks/runs     "2"= shambler footsteps adds raising dust when he walks/runs    "3"= shambler footsteps makes the ground shattering when he walks/runs + adds raising dust !
							// cvar used inside shambler.qc
var float autocvar_yakman_walking_quake = 3;		// set cvar 'yakman_walking_quake' default to 3    "0"= disabled    "1"= yakman footsteps makes the ground shattering when he walks/runs     "2"= yakman footsteps adds raising dust when he walks/runs    "3"= yakman footsteps makes the ground shattering when he walks/runs + adds raising dust !
							// cvar used inside yakman.qc

void () shambler_walking_quake =
{ 
local entity enFind;
	enFind = findradius(self.origin, 444);
			
	while(enFind)
	{ 
		if(enFind.flags & FL_ONGROUND)
		{ 
			if (enFind.classname == "player")
			{
				enFind.velocity_x = enFind.velocity_x + (crandom() * 30);  
				enFind.velocity_y = enFind.velocity_y + (crandom() * 30); 
				enFind.velocity_z = enFind.velocity_z + (crandom() * 75);  
			   	enFind.punchangle = enFind.punchangle + (randomvec() * 0.6);  // Apply Punchangle
			}
		}
		enFind = enFind.chain;
	}
};




/////// Random Earthquake spawn  (starts a small earthquake randomly and taking minimum time interval in account)

/////// Earthquake interval
var float autocvar_earthquake_interval = 60;		// set cvar 'earthquake_interval' default to 60 seconds.  Sets the minimum pause between earthquakes (the bigger the value, the less eartquakes will appear).  "0"= disabled.    Choose any value you want
							// cvar used inside client.qc

void() start_earthquake_think =
{

	if ((self.earthquake_nextquake < time) && (quaketime == 1))
	{
		self.earthquake_finished = time + 3;
		sound ( self, CHAN_AUTO, "ambience/rumblefade.wav", 0.8, ATTN_NORM );
		quaketime = 0;
	}
		
	if (quaketime == 0)
	{
		self.earthquake_nextquake = time + autocvar_earthquake_interval + (70 * random());
		quaketime = 1;
	}
};


void () start_earthquake =
{ 
local entity enFind;
	enFind = findradius(self.origin, 666);
			
	while(enFind)
	{ 
		if(enFind.flags & FL_ONGROUND)
		{ 
			if (enFind.flags & FL_MONSTER)
			{
				enFind.velocity_x = enFind.velocity_x + (crandom() * 15);  
				enFind.velocity_y = enFind.velocity_y + (crandom() * 15); 
				enFind.velocity_z = enFind.velocity_z + (crandom() * 40);  
			}
			if (enFind.classname == "player")
			{
				enFind.velocity_x = enFind.velocity_x + (crandom() * 10);  
				enFind.velocity_y = enFind.velocity_y + (crandom() * 10); 
				enFind.velocity_z = enFind.velocity_z + (crandom() * 30);  
			   	enFind.punchangle = enFind.punchangle + (randomvec() * 0.2);  // Apply Punchangle
			}
		}
		enFind = enFind.chain;
	}
};




////////  Player Heartbeat sound when heavily wounded:

void() PlayerHeartbeat_quick =
{
	self.playerheartbeat_finished = time + 0.5;
	sound (self, CHAN_AUTO, "ambience/gibheartbeat.wav", autocvar_player_wounded_heartbeat, 3);	
};

void() PlayerHeartbeat_slow =
{
	self.playerheartbeat_finished = time + 0.666;
	sound (self, CHAN_AUTO, "ambience/gibheartbeat.wav", autocvar_player_wounded_heartbeat - 0.07, 3);	
};




////////  Player is surrounded by flying dust

void() spawn_flying_dust =
{
local float counta;
counta = autocvar_flying_dust_quantity;
	self.flying_dust_finished = time + 0.01;
	if (cvar("chase_active"))		// we are in 3rd person mode
	{
		while (counta > 0)
		{
			if (autocvar_flying_dust_type == 1)
				pointparticles(particleeffectnum("flying_dust"), self.origin + self.view_ofs + v_up * 15 + v_forward*20, self.velocity*10, 1);
			else if (autocvar_flying_dust_type == 2)
				pointparticles(particleeffectnum("flying_ember"), self.origin + self.view_ofs + v_up * 15 + v_forward*20, self.velocity*10, 1);
			else if (autocvar_flying_dust_type == 3)
				pointparticles(particleeffectnum("flying_snow"), self.origin + self.view_ofs + v_up * 15 + v_forward*20, self.velocity*10, 1);
			else if (autocvar_flying_dust_type == 4)
				pointparticles(particleeffectnum("flying_rain"), self.origin + self.view_ofs + v_up * 15 + v_forward*20, self.velocity*10, 1);
			counta = counta - 1;
		}
	}
	else
	{
		while (counta > 0)
		{
			if (autocvar_flying_dust_type == 1)
				pointparticles(particleeffectnum("flying_dust"), self.origin + self.view_ofs + v_up * 15 + v_forward*20, self.velocity*10, 1);
			else if (autocvar_flying_dust_type == 2)
				pointparticles(particleeffectnum("flying_ember"), self.origin + self.view_ofs + v_up * 15 + v_forward*20, self.velocity*10, 1);
			else if (autocvar_flying_dust_type == 3)
				pointparticles(particleeffectnum("flying_snow"), self.origin + self.view_ofs + v_up * 15 + v_forward*20, self.velocity*10, 1);
			else if (autocvar_flying_dust_type == 4)
				pointparticles(particleeffectnum("flying_rain"), self.origin + self.view_ofs + v_up * 15 + v_forward*20, self.velocity*10, 1);
			counta = counta - 1;
		}
	}
};





/////// Powerup HUD model / texture / water effects:   Spawn visible HUD visor/texture or model when picking up powerup/item and spawn waterdrops running down HUD when coming out of water or slime

void(entity enti) Scaling_according_to_FOV =
{
	local float fov_value;
	fov_value = stof (cvar_string ("fov"));		// read players FOV value and set model scale accordingly. Single player only !
							// ATTENTION: Full screen texture-model must match the screen resolution. In this case I use 1920x1080 (= 1,777:1), as it is the most used monitor resolution nowadays (= Full-HD).
	if (fov_value < 90)
		enti.scale = 0.94;
	else if (fov_value < 94)
		enti.scale = 1;
	else if (fov_value < 97)
		enti.scale = 1.07;
	else if (fov_value < 101)
		enti.scale = 1.13;
	else if (fov_value < 104)
		enti.scale = 1.19;
	else if (fov_value < 107)
		enti.scale = 1.25;
	else if (fov_value < 112)
		enti.scale = 1.38;
	else if (fov_value < 114)
		enti.scale = 1.44;
	else if (fov_value < 116)
		enti.scale = 1.5;
	else if (fov_value < 118)
		enti.scale = 1.57;
	else if (fov_value < 120)
		enti.scale = 1.63;
	else if (fov_value < 122)
		enti.scale = 1.69;
	else if (fov_value < 124)
		enti.scale = 1.75;
	else if (fov_value < 126)
		enti.scale = 1.82;
	else if (fov_value < 127)
		enti.scale = 1.94;
	else
		enti.scale = 2;
};


void(entity enti) Positioning_Y_according_to_FOV =
{
	local float fov_value;
	fov_value = stof (cvar_string ("fov"));		// read players FOV value and set model y-position accordingly. Single player only !
							// ATTENTION: Position is depending on screen resolution. In this case I use 1920x1080 (= 1,777:1), as it is the most used monitor resolution nowadays (= Full-HD).
	if (fov_value < 90)
		enti.origin_y = 17;
	else if (fov_value < 94)
		enti.origin_y = 18;
	else if (fov_value < 97)
		enti.origin_y = 19;
	else if (fov_value < 100)
		enti.origin_y = 20;
	else if (fov_value < 103)
		enti.origin_y = 21;
	else if (fov_value < 106)
		enti.origin_y = 22;
	else if (fov_value < 108)
		enti.origin_y = 23;
	else if (fov_value < 110)
		enti.origin_y = 24;
	else if (fov_value < 112)
		enti.origin_y = 25;
	else if (fov_value < 114)
		enti.origin_y = 26;
	else if (fov_value < 116)
		enti.origin_y = 27;
	else if (fov_value < 118)
		enti.origin_y = 28;
	else if (fov_value < 120)
		enti.origin_y = 29;
	else if (fov_value < 122)
		enti.origin_y = 30;
	else if (fov_value < 124)
		enti.origin_y = 31;
	else if (fov_value < 126)
		enti.origin_y = 32;
	else if (fov_value < 127)
		enti.origin_y = 33;
	else
		enti.origin_y = 34;
};

void(entity enti) Positioning_Z_according_to_FOV =
{
	local float fov_value;
	fov_value = stof (cvar_string ("fov"));		// read players FOV value and set model z-position accordingly. Single player only !
							// ATTENTION: Position is depending on screen resolution. In this case I use 1920x1080 (= 1,777:1), as it is the most used monitor resolution nowadays (= Full-HD).
	if (fov_value < 90)
		enti.origin_z = 5.5;
	else if (fov_value < 94)
		enti.origin_z = 6;
	else if (fov_value < 97)
		enti.origin_z = 6.5;
	else if (fov_value < 100)
		enti.origin_z = 7;
	else if (fov_value < 103)
		enti.origin_z = 7.5;
	else if (fov_value < 106)
		enti.origin_z = 8;
	else if (fov_value < 108)
		enti.origin_z = 8.5;
	else if (fov_value < 110)
		enti.origin_z = 9;
	else if (fov_value < 112)
		enti.origin_z = 9.5;
	else if (fov_value < 114)
		enti.origin_z = 10;
	else if (fov_value < 116)
		enti.origin_z = 10.5;
	else if (fov_value < 118)
		enti.origin_z = 11;
	else if (fov_value < 120)
		enti.origin_z = 11.5;
	else if (fov_value < 122)
		enti.origin_z = 12;
	else if (fov_value < 124)
		enti.origin_z = 12.5;
	else if (fov_value < 126)
		enti.origin_z = 13;
	else if (fov_value < 127)
		enti.origin_z = 13.5;
	else
		enti.origin_z = 14;
};



void(entity enti) Positioning_Y_according_to_FOV_bottom =
{
	local float fov_value;
	fov_value = stof (cvar_string ("fov"));		// read players FOV value and set model y-position accordingly. Single player only !
							// ATTENTION: Position is depending on screen resolution. In this case I use 1920x1080 (= 1,777:1), as it is the most used monitor resolution nowadays (= Full-HD).
	enti.origin_y = 10;
};

void(entity enti) Positioning_Z_according_to_FOV_bottom =
{
	local float fov_value;
	fov_value = stof (cvar_string ("fov"));		// read players FOV value and set model z-position accordingly. Single player only !
							// ATTENTION: Position is depending on screen resolution. In this case I use 1920x1080 (= 1,777:1), as it is the most used monitor resolution nowadays (= Full-HD).
	if (fov_value < 90)
		enti.origin_z = -8.5;
	else if (fov_value < 92)
		enti.origin_z = -9;
	else if (fov_value < 94)
		enti.origin_z = -9.5;
	else if (fov_value < 96)
		enti.origin_z = -10;
	else if (fov_value < 98)
		enti.origin_z = -10.5;
	else if (fov_value < 101)
		enti.origin_z = -11;
	else if (fov_value < 103)
		enti.origin_z = -11.5;
	else if (fov_value < 105)
		enti.origin_z = -12;
	else if (fov_value < 107)
		enti.origin_z = -12.5;
	else if (fov_value < 109)
		enti.origin_z = -13;
	else if (fov_value < 111)
		enti.origin_z = -13.5;
	else if (fov_value < 113)
		enti.origin_z = -14;
	else if (fov_value < 115)
		enti.origin_z = -14.5;
	else if (fov_value < 117)
		enti.origin_z = -15;
	else if (fov_value < 119)
		enti.origin_z = -15.5;
	else if (fov_value < 121)
		enti.origin_z = -16;
	else if (fov_value < 123)
		enti.origin_z = -16.5;
	else if (fov_value < 125)
		enti.origin_z = -17;
	else if (fov_value < 127)
		enti.origin_z = -17.5;
	else if (fov_value < 129)
		enti.origin_z = -18;
	else
		enti.origin_z = -18.5;
};




/////// Water drops running down players visor / HUD when coming out of water or slime  (  effect started in WaterMove();   )

void() waterdrops_animation =
{
	if ((autocvar_HUD_waterdrops_out_of_water == 2) && (!self.owner.radsuit_finished))
	{	
		remove (self);
		return;
	}

	if (intermission_running)			// do not show waterdrops during intermission
	{	
		remove (self);
		return;
	}
 
 	if (self.owner.waterlevel == 3)			// remove waterdrops as soon as players head is underwater
	{	
		remove (self);
		return;
	}

 	if (self.alpha < 0.05)				// remove waterdrops when alpha reaches low value
	{	
		remove (self);
		return;
	}

	self.origin_z = self.origin_z - 0.017;			// movement speed downwards
	if (self.randomdirection)
		self.origin_y = self.origin_y + 0.0025;		// move it a little left or right to make it look more real + varied
	else
		self.origin_y = self.origin_y - 0.0025;
	
	self.alpha = self.alpha - 0.003;			// fade out

	if (autocvar_HUD_visor_texture_manual_scale == 0)	// to make it possible to adjust scale without map restart
		Scaling_according_to_FOV (self);
	else
		self.scale = autocvar_HUD_visor_texture_manual_scale;
	self.scale = self.scale + 0.13;			// to correct mismatch between waterdrops and other HUD textures, make it little bigger than calculated/set
	
	self.think = waterdrops_animation;
	self.nextthink = time + 0.01;
};


void() waterdrops_start =
{
	if (random() < 0.5)
		self.randomdirection = 0;
	else
		self.randomdirection = 1;

	self.think = waterdrops_animation;
	self.nextthink = time;
};


void(entity e) water_drops =
{
	local entity waterdrops;
	waterdrops = spawn();
	waterdrops.alpha = 0.5;	
	waterdrops.skin = 1;		// waterdrops texture
	waterdrops.owner = e;
	waterdrops.viewmodelforclient = self;

	setmodel(waterdrops, "progs/biosui.mdl");

	waterdrops.origin_x = 3.3;
	waterdrops.origin_y = crandom() * 0.125;
	waterdrops.origin_z = 0.5;

	waterdrops.angles_x = 90;
	waterdrops.angles_y = -90;
	waterdrops.angles_z = 90;

	waterdrops.effects = 4864;	// --> DP_EF_NOGUNBOB = 256;	EF_FULLBRIGHT = 512;    EF_NOSHADOW = 4096;

	if (autocvar_HUD_visor_texture_manual_scale == 0)
		Scaling_according_to_FOV (waterdrops);
	else
		waterdrops.scale = autocvar_HUD_visor_texture_manual_scale;
	waterdrops.scale = waterdrops.scale + 0.13;		// to correct mismatch between waterdrops and other HUD textures, make it little bigger than calculated/set

	waterdrops.think = waterdrops_start;
	waterdrops.nextthink = time;
};






/////// Biosuit HUD model and texture effects/animations: 

void() biosuit_countdown_start =
{
	if (!self.owner.radsuit_finished)
	{	
		remove (self);
		return;
	}

	if (intermission_running)		// do not show HUD model during intermission
	{	
		remove (self);
		return;
	}

	self.skin = self.skin + 1;		// animation realized via skin textures (4 until 33)

	if (self.skin > 33)
	{	
		remove (self);
		return;
	}

	if (autocvar_HUD_visor_texture_manual_scale == 0)	// to make it possible to adjust scale without map restart
		Scaling_according_to_FOV (self);
	else
		self.scale = autocvar_HUD_visor_texture_manual_scale;
	
	self.think = biosuit_countdown_start;
	self.nextthink = time + 1;
};


void(entity e) biosuit_countdown =
{
	local entity biosuit_HUD_model;
	biosuit_HUD_model = spawn();
	biosuit_HUD_model.alpha = 1;	
	biosuit_HUD_model.skin = 4;
	biosuit_HUD_model.owner = e;
	biosuit_HUD_model.viewmodelforclient = self;
	
	setmodel(biosuit_HUD_model, "progs/biosui.mdl");

	biosuit_HUD_model.origin_x = 3;
	biosuit_HUD_model.origin_y = 0;
	biosuit_HUD_model.origin_z = 0;

	biosuit_HUD_model.angles_x = 90;
	biosuit_HUD_model.angles_y = -90;
	biosuit_HUD_model.angles_z = 90;

	biosuit_HUD_model.effects = 4864;	// --> DP_EF_NOGUNBOB = 256;	EF_FULLBRIGHT = 512;    EF_NOSHADOW = 4096;

	if (autocvar_HUD_visor_texture_manual_scale == 0)
		Scaling_according_to_FOV (biosuit_HUD_model);
	else
		biosuit_HUD_model.scale = autocvar_HUD_visor_texture_manual_scale;

	biosuit_HUD_model.think = biosuit_countdown_start;
	biosuit_HUD_model.nextthink = time + 2;
};




void() biosuit_blinking_start =
{
	if (!self.owner.radsuit_finished)
	{	
		remove (self);
		return;
	}

	if (intermission_running)			// do not show HUD model during intermission
	{	
		remove (self);
		return;
	}

	if ((time > self.ltime + 0.25) && (self.magiccounter == 0))	// shorter OFF time than ON time (looks better than even ON/OFF times)
	{
		self.skin = 3;			// ON
		self.ltime = time;
		self.magiccounter = 1;
	}

	if ((time > self.ltime + 0.75) && (self.magiccounter == 1))	// shorter OFF time than ON time (looks better than even ON/OFF times)
	{
		self.skin = 2;			// OFF
		self.ltime = time;
		self.magiccounter = 0;
	}

	if (autocvar_HUD_visor_texture_manual_scale == 0)	// to make it possible to adjust scale without map restart
		Scaling_according_to_FOV (self);
	else
		self.scale = autocvar_HUD_visor_texture_manual_scale;

	self.think = biosuit_blinking_start;
	self.nextthink = time + 0.01;
};


void(entity e) biosuit_blinking =
{
	local entity biosuit_HUD_model;
	biosuit_HUD_model = spawn();
	biosuit_HUD_model.alpha = 1;	
	biosuit_HUD_model.skin = 2;		// OFF
	biosuit_HUD_model.owner = e;
	biosuit_HUD_model.viewmodelforclient = self;
	
	setmodel(biosuit_HUD_model, "progs/biosui.mdl");

	biosuit_HUD_model.origin_x = 3;
	biosuit_HUD_model.origin_y = 0;
	biosuit_HUD_model.origin_z = 0;

	biosuit_HUD_model.angles_x = 90;
	biosuit_HUD_model.angles_y = -90;
	biosuit_HUD_model.angles_z = 90;

	biosuit_HUD_model.effects = 4864;	// --> DP_EF_NOGUNBOB = 256;	EF_FULLBRIGHT = 512;    EF_NOSHADOW = 4096;

	if (autocvar_HUD_visor_texture_manual_scale == 0)
		Scaling_according_to_FOV (biosuit_HUD_model);
	else
		biosuit_HUD_model.scale = autocvar_HUD_visor_texture_manual_scale;

	biosuit_HUD_model.ltime = time;

	if (autocvar_HUD_visor_texture_manual_scale == 0)	// to make it possible to adjust scale without map restart
		Scaling_according_to_FOV (self);
	else
		self.scale = autocvar_HUD_visor_texture_manual_scale;

	biosuit_HUD_model.think = biosuit_blinking_start;
	biosuit_HUD_model.nextthink = time;
};




void() biosuit_HUD_start =
{
	if (!self.owner.radsuit_finished)
	{	
		remove (self);
		return;
	}

	if (intermission_running)			// do not show HUD model during intermission
	{	
		remove (self);
		return;
	}

	if (autocvar_HUD_visor_texture_manual_scale == 0)	// to make it possible to adjust scale without map restart
		Scaling_according_to_FOV (self);
	else
		self.scale = autocvar_HUD_visor_texture_manual_scale;
	
	self.think = biosuit_HUD_start;
	self.nextthink = time + 0.01;
};


void(entity e) biosuit_HUD =
{
	local entity biosuit_HUD_model;
	biosuit_HUD_model = spawn();
	biosuit_HUD_model.alpha = 1;	
	biosuit_HUD_model.skin = 0;
	biosuit_HUD_model.owner = e;
	biosuit_HUD_model.viewmodelforclient = self;
	
	setmodel(biosuit_HUD_model, "progs/biosui.mdl");

	biosuit_HUD_model.origin_x = 3;
	biosuit_HUD_model.origin_y = 0;
	biosuit_HUD_model.origin_z = 0;

	biosuit_HUD_model.angles_x = 90;
	biosuit_HUD_model.angles_y = -90;
	biosuit_HUD_model.angles_z = 90;

	biosuit_HUD_model.effects = 4864;	// --> DP_EF_NOGUNBOB = 256;	EF_FULLBRIGHT = 512;    EF_NOSHADOW = 4096;

	if (autocvar_HUD_visor_texture_manual_scale == 0)
		Scaling_according_to_FOV (biosuit_HUD_model);
	else
		biosuit_HUD_model.scale = autocvar_HUD_visor_texture_manual_scale;

	biosuit_HUD_model.think = biosuit_HUD_start;
	biosuit_HUD_model.nextthink = time;
	biosuit_countdown (e);
	biosuit_blinking (e);
};








void() biosuit_HUD_spinning_model_start =
{
	if (!self.owner.radsuit_finished)
	{	
		remove (self);
		return;
	}

	if (intermission_running)			// do not show HUD model during intermission
	{	
		remove (self);
		return;
	}

	self.angles_y = self.angles_y + 2.5;	// rotate speed

	if (autocvar_HUD_spinning_side_model_manual_y_position == 0)
		Positioning_Y_according_to_FOV (self);
	else
		self.origin_y = autocvar_HUD_spinning_side_model_manual_y_position;

	if (autocvar_HUD_spinning_side_model_manual_z_position == 0)
		Positioning_Z_according_to_FOV (self);
	else
		self.origin_z = autocvar_HUD_spinning_side_model_manual_z_position;
	self.origin_z = self.origin_z - 7.5;	// position it beneath ring model
	
	self.think = biosuit_HUD_spinning_model_start;
	self.nextthink = time + 0.02;
};


void(entity e) biosuit_HUD_spinning_model =
{
	local entity biosuit_HUD_model;
	biosuit_HUD_model = spawn();
	biosuit_HUD_model.alpha = 1;	
	biosuit_HUD_model.skin = 0;
	biosuit_HUD_model.owner = e;
	biosuit_HUD_model.viewmodelforclient = self;
	
	setmodel(biosuit_HUD_model, "progs/suit_HUD.mdl");

	biosuit_HUD_model.origin_x = 15;		//  back/forth  (= big/small)

	if (autocvar_HUD_spinning_side_model_manual_y_position == 0)
		Positioning_Y_according_to_FOV (biosuit_HUD_model);
	else
		biosuit_HUD_model.origin_y = autocvar_HUD_spinning_side_model_manual_y_position;

	if (autocvar_HUD_spinning_side_model_manual_z_position == 0)
		Positioning_Z_according_to_FOV (biosuit_HUD_model);
	else
		biosuit_HUD_model.origin_z = autocvar_HUD_spinning_side_model_manual_z_position;
	biosuit_HUD_model.origin_z = biosuit_HUD_model.origin_z - 7.5;	// position it beneath ring model

	biosuit_HUD_model.angles_x = 0;
	biosuit_HUD_model.angles_y = 0;
	biosuit_HUD_model.angles_z = 0;

	biosuit_HUD_model.effects = 4864;	// --> DP_EF_NOGUNBOB = 256;  EF_FULLBRIGHT = 512;  EF_NOSHADOW = 4096;

	biosuit_HUD_model.scale = 0.07;

	biosuit_HUD_model.think = biosuit_HUD_spinning_model_start;
	biosuit_HUD_model.nextthink = time;
};









/////// Quad HUD model and texture effects:   Spawn visible HUD visor frame when picking up quad rune

void() quad_HUD_texture_animation01;
void() quad_HUD_texture_animation00 =		// fade in approx. 2 times faster than fade out
{
	if (!self.owner.super_damage_finished)
	{	
		remove (self);
		return;
	}

	if (intermission_running)		// do not show HUD model during intermission
	{	
		remove (self);
		return;
	}

	if (self.alpha < 0.15)
	{
		self.alpha = self.alpha + 0.005;
		self.think = quad_HUD_texture_animation00; 
	}
	else
		self.think = quad_HUD_texture_animation01; 
	self.nextthink = time + 0.02;	

	if (autocvar_HUD_visor_texture_manual_scale == 0)	// to make it possible to adjust scale without map restart
		Scaling_according_to_FOV (self);
	else
		self.scale = autocvar_HUD_visor_texture_manual_scale;
	self.scale = self.scale + 0.13;				// to correct mismatch between waterdrops and other HUD textures
};


void() quad_HUD_texture_animation01 =		// fade out
{
	if (!self.owner.super_damage_finished)
	{	
		remove (self);
		return;
	}

	if (intermission_running)		// do not show HUD model during intermission
	{	
		remove (self);
		return;
	}

	if (self.alpha > 0.02)
	{
		self.alpha = self.alpha - 0.003;
		self.think = quad_HUD_texture_animation01; 
	}
	else
		self.think = quad_HUD_texture_animation00; 
	self.nextthink = time + 0.02;

	if (autocvar_HUD_visor_texture_manual_scale == 0)	// to make it possible to adjust scale without map restart
		Scaling_according_to_FOV (self);
	else
		self.scale = autocvar_HUD_visor_texture_manual_scale;
	self.scale = self.scale + 0.13;				// to correct mismatch between waterdrops and other HUD textures
};


void(entity e) quad_HUD_texture =
{
	local entity quad_HUD_model;
	quad_HUD_model = spawn();
	quad_HUD_model.alpha = 0.005;	
	quad_HUD_model.skin = 34;
	quad_HUD_model.owner = e;
	quad_HUD_model.viewmodelforclient = self;
	
	setmodel(quad_HUD_model, "progs/biosui.mdl");

	quad_HUD_model.origin_x = 3.3;			// in front of biosuit visor
	quad_HUD_model.origin_y = 0;
	quad_HUD_model.origin_z = 0;

	quad_HUD_model.angles_x = 90;
	quad_HUD_model.angles_y = -90;
	quad_HUD_model.angles_z = 90;

	quad_HUD_model.effects = 4864;	// --> DP_EF_NOGUNBOB = 256;  EF_FULLBRIGHT = 512;  EF_NOSHADOW = 4096;

	if (autocvar_HUD_visor_texture_manual_scale == 0)
		Scaling_according_to_FOV (quad_HUD_model);
	else
		quad_HUD_model.scale = autocvar_HUD_visor_texture_manual_scale;
	quad_HUD_model.scale = quad_HUD_model.scale + 0.13;		// to correct mismatch between waterdrops and other HUD textures

	quad_HUD_model.think = quad_HUD_texture_animation00;
	quad_HUD_model.nextthink = time;
};






void() quad_HUD_spinning_model_start =
{
	if (!self.owner.super_damage_finished)
	{	
		remove (self);
		return;
	}

	if (intermission_running)			// do not show HUD model during intermission
	{	
		remove (self);
		return;
	}

	self.angles_y = self.angles_y + 2.5;	// rotate speed
	
	if (autocvar_HUD_spinning_side_model_manual_y_position == 0)
		Positioning_Y_according_to_FOV (self);
	else
		self.origin_y = autocvar_HUD_spinning_side_model_manual_y_position;

	if (autocvar_HUD_spinning_side_model_manual_z_position == 0)
		Positioning_Z_according_to_FOV (self);
	else
		self.origin_z = autocvar_HUD_spinning_side_model_manual_z_position;

	self.think = quad_HUD_spinning_model_start;
	self.nextthink = time + 0.02;
};


void(entity e) quad_HUD_spinning_model =
{
	local entity quad_HUD_model;
	quad_HUD_model = spawn();
	quad_HUD_model.alpha = 1;	
	quad_HUD_model.skin = 0;
	quad_HUD_model.owner = e;
	quad_HUD_model.viewmodelforclient = self;
	
	setmodel(quad_HUD_model, "progs/quaddama_HUD.mdl");

	quad_HUD_model.origin_x = 15;	

	if (autocvar_HUD_spinning_side_model_manual_y_position == 0)
		Positioning_Y_according_to_FOV (quad_HUD_model);
	else
		quad_HUD_model.origin_y = autocvar_HUD_spinning_side_model_manual_y_position;

	if (autocvar_HUD_spinning_side_model_manual_z_position == 0)
		Positioning_Z_according_to_FOV (quad_HUD_model);
	else
		quad_HUD_model.origin_z = autocvar_HUD_spinning_side_model_manual_z_position;

	quad_HUD_model.angles_x = 0;
	quad_HUD_model.angles_y = 0;
	quad_HUD_model.angles_z = 0;

	quad_HUD_model.effects = 4864;	// --> DP_EF_NOGUNBOB = 256;  EF_FULLBRIGHT = 512;  EF_NOSHADOW = 4096;

	quad_HUD_model.scale = 0.07;

	quad_HUD_model.think = quad_HUD_spinning_model_start;
	quad_HUD_model.nextthink = time;
};













/////// Pent HUD model and texture effects:   Spawn visible HUD visor frame when picking up pent rune

void() pent_HUD_texture_animation01;
void() pent_HUD_texture_animation00 =		// fade in approx. 2 times faster than fade out
{
	if (!self.owner.invincible_finished)
	{	
		remove (self);
		return;
	}

	if (intermission_running)		// do not show HUD model during intermission
	{	
		remove (self);
		return;
	}

	if (self.alpha < 0.15)
	{
		self.alpha = self.alpha + 0.005;
		self.think = pent_HUD_texture_animation00; 
	}
	else
		self.think = pent_HUD_texture_animation01; 
	self.nextthink = time + 0.02;	

	if (autocvar_HUD_visor_texture_manual_scale == 0)	// to make it possible to adjust scale without map restart
		Scaling_according_to_FOV (self);
	else
		self.scale = autocvar_HUD_visor_texture_manual_scale;
	self.scale = self.scale + 0.13;				// to correct mismatch between waterdrops and other HUD textures
};


void() pent_HUD_texture_animation01 =		// fade out
{
	if (!self.owner.invincible_finished)
	{	
		remove (self);
		return;
	}

	if (intermission_running)		// do not show HUD model during intermission
	{	
		remove (self);
		return;
	}

	if (self.alpha > 0.02)
	{
		self.alpha = self.alpha - 0.003;
		self.think = pent_HUD_texture_animation01; 
	}
	else
		self.think = pent_HUD_texture_animation00; 
	self.nextthink = time + 0.02;

	if (autocvar_HUD_visor_texture_manual_scale == 0)	// to make it possible to adjust scale without map restart
		Scaling_according_to_FOV (self);
	else
		self.scale = autocvar_HUD_visor_texture_manual_scale;
	self.scale = self.scale + 0.13;				// to correct mismatch between waterdrops and other HUD textures
};


void(entity e) pent_HUD_texture =
{
	local entity pent_HUD_model;
	pent_HUD_model = spawn();
	pent_HUD_model.alpha = 0.005;	
	pent_HUD_model.skin = 35;
	pent_HUD_model.owner = e;
	pent_HUD_model.viewmodelforclient = self;
	
	setmodel(pent_HUD_model, "progs/biosui.mdl");

	pent_HUD_model.origin_x = 3.3;			// in front of biosuit visor
	pent_HUD_model.origin_y = 0;
	pent_HUD_model.origin_z = 0;

	pent_HUD_model.angles_x = 90;
	pent_HUD_model.angles_y = -90;
	pent_HUD_model.angles_z = 90;

	pent_HUD_model.effects = 4864;	// --> DP_EF_NOGUNBOB = 256;  EF_FULLBRIGHT = 512;  EF_NOSHADOW = 4096;

	if (autocvar_HUD_visor_texture_manual_scale == 0)
		Scaling_according_to_FOV (pent_HUD_model);
	else
		pent_HUD_model.scale = autocvar_HUD_visor_texture_manual_scale;
	pent_HUD_model.scale = pent_HUD_model.scale + 0.13;		// to correct mismatch between waterdrops and other HUD textures

	pent_HUD_model.think = pent_HUD_texture_animation00;
	pent_HUD_model.nextthink = time;
};







void() pent_HUD_spinning_model_start =
{
	if (!self.owner.invincible_finished)
	{	
		remove (self);
		return;
	}

	if (intermission_running)			// do not show HUD model during intermission
	{	
		remove (self);
		return;
	}

	self.angles_y = self.angles_y + 2.5;	// rotate speed

	if (autocvar_HUD_spinning_side_model_manual_y_position == 0)
		Positioning_Y_according_to_FOV (self);
	else
		self.origin_y = autocvar_HUD_spinning_side_model_manual_y_position;

	if (autocvar_HUD_spinning_side_model_manual_z_position == 0)
		Positioning_Z_according_to_FOV (self);
	else
		self.origin_z = autocvar_HUD_spinning_side_model_manual_z_position;
	self.origin_z = self.origin_z - 2.7;	// position it beneath quad model
	
	self.think = pent_HUD_spinning_model_start;
	self.nextthink = time + 0.02;
};


void(entity e) pent_HUD_spinning_model =
{
	local entity pent_HUD_model;
	pent_HUD_model = spawn();
	pent_HUD_model.alpha = 1;	
	pent_HUD_model.skin = 0;
	pent_HUD_model.owner = e;
	pent_HUD_model.viewmodelforclient = self;
	
	setmodel(pent_HUD_model, "progs/invulner_HUD.mdl");

	pent_HUD_model.origin_x = 15;		//  back/forth  (= big/small)

	if (autocvar_HUD_spinning_side_model_manual_y_position == 0)
		Positioning_Y_according_to_FOV (pent_HUD_model);
	else
		pent_HUD_model.origin_y = autocvar_HUD_spinning_side_model_manual_y_position;

	if (autocvar_HUD_spinning_side_model_manual_z_position == 0)
		Positioning_Z_according_to_FOV (pent_HUD_model);
	else
		pent_HUD_model.origin_z = autocvar_HUD_spinning_side_model_manual_z_position;
	pent_HUD_model.origin_z = pent_HUD_model.origin_z - 2.7;	// position it beneath quad model

	pent_HUD_model.angles_x = 0;
	pent_HUD_model.angles_y = 0;
	pent_HUD_model.angles_z = 0;

	pent_HUD_model.effects = 4864;	// --> DP_EF_NOGUNBOB = 256;  EF_FULLBRIGHT = 512;  EF_NOSHADOW = 4096;

	pent_HUD_model.scale = 0.07;

	pent_HUD_model.think = pent_HUD_spinning_model_start;
	pent_HUD_model.nextthink = time;
};









/////// Ring HUD model effects:  Spawn spinning HUD model when picking up invisibility ring

void() ring_HUD_spinning_model_start =
{
	if (!self.owner.invisible_finished)
	{	
		remove (self);
		return;
	}

	if (intermission_running)			// do not show HUD model during intermission
	{	
		remove (self);
		return;
	}

	self.angles_y = self.angles_y + 2.5;	// rotate speed

	if (autocvar_HUD_spinning_side_model_manual_y_position == 0)
		Positioning_Y_according_to_FOV (self);
	else
		self.origin_y = autocvar_HUD_spinning_side_model_manual_y_position;

	if (autocvar_HUD_spinning_side_model_manual_z_position == 0)
		Positioning_Z_according_to_FOV (self);
	else
		self.origin_z = autocvar_HUD_spinning_side_model_manual_z_position;
	self.origin_z = self.origin_z - 5.3;	// position it beneath pent model
	
	self.think = ring_HUD_spinning_model_start;
	self.nextthink = time + 0.02;
};


void(entity e) ring_HUD_spinning_model =
{
	local entity ring_HUD_model;
	ring_HUD_model = spawn();
	ring_HUD_model.alpha = 1;	
	ring_HUD_model.skin = 0;
	ring_HUD_model.owner = e;
	ring_HUD_model.viewmodelforclient = self;
	
	setmodel(ring_HUD_model, "progs/invisibl_HUD.mdl");

	ring_HUD_model.origin_x = 15;		//  back/forth  (= big/small)

	if (autocvar_HUD_spinning_side_model_manual_y_position == 0)
		Positioning_Y_according_to_FOV (ring_HUD_model);
	else
		ring_HUD_model.origin_y = autocvar_HUD_spinning_side_model_manual_y_position;

	if (autocvar_HUD_spinning_side_model_manual_z_position == 0)
		Positioning_Z_according_to_FOV (ring_HUD_model);
	else
		ring_HUD_model.origin_z = autocvar_HUD_spinning_side_model_manual_z_position;
	ring_HUD_model.origin_z = ring_HUD_model.origin_z - 5.3;	// position it beneath pent model

	ring_HUD_model.angles_x = 0;
	ring_HUD_model.angles_y = 0;
	ring_HUD_model.angles_z = 0;

	ring_HUD_model.effects = 4864;	// --> DP_EF_NOGUNBOB = 256;  EF_FULLBRIGHT = 512;  EF_NOSHADOW = 4096;

	ring_HUD_model.scale = 0.07;

	ring_HUD_model.think = ring_HUD_spinning_model_start;
	ring_HUD_model.nextthink = time;
};











/////// Player HUD model:  Spawn animated player HUD model

void() player_HUD_model_animation =
{
	if (intermission_running)		// do not show HUD model during intermission
	{	
		remove (self);
		return;
	}

	self.frame = self.owner.frame;				// animation similar to player
	self.angles_x = (self.owner.angles_x + 15) * 1.3;	// amplify animation in angles_x

	if (autocvar_HUD_spinning_bottom_model_manual_y_position == 0)
		Positioning_Y_according_to_FOV_bottom (self);
	else
		self.origin_y = autocvar_HUD_spinning_bottom_model_manual_y_position;

	if (autocvar_HUD_spinning_bottom_model_manual_z_position == 0)
		Positioning_Z_according_to_FOV_bottom (self);
	else
		self.origin_z = autocvar_HUD_spinning_bottom_model_manual_z_position;

	if (self.owner.invisible_finished)
	{
		setmodel(self, "progs/eyes.mdl");
		self.scale = 0.13;
		self.origin_z = self.origin_z - 2;
	}
	else
	{
		setmodel(self, "progs/player_HUD.mdl");		// for NOT-SMC
		self.scale = 0.07;
	}

	self.think = player_HUD_model_animation;
	self.nextthink = time + 0.025;
};


void(entity e) player_HUD_model =
{
	local entity player_HUDmodel;
	player_HUDmodel = spawn();
	player_HUDmodel.alpha = 1;	
	player_HUDmodel.skin = 0;
	player_HUDmodel.owner = e;
	player_HUDmodel.viewmodelforclient = self;
	
	setmodel(player_HUDmodel, "progs/player_HUD.mdl");

	player_HUDmodel.origin_x = 17;		//  back/forth  (= big/small)
//	player_HUDmodel.origin_y = 8;
//	player_HUDmodel.origin_z = -11;

	if (autocvar_HUD_spinning_bottom_model_manual_y_position == 0)
		Positioning_Y_according_to_FOV_bottom (player_HUDmodel);
	else
		player_HUDmodel.origin_y = autocvar_HUD_spinning_bottom_model_manual_y_position;

	if (autocvar_HUD_spinning_bottom_model_manual_z_position == 0)
		Positioning_Z_according_to_FOV_bottom (player_HUDmodel);
	else
		player_HUDmodel.origin_z = autocvar_HUD_spinning_bottom_model_manual_z_position;

	player_HUDmodel.angles_x = 0;
	player_HUDmodel.angles_y = 210;
	player_HUDmodel.angles_z = 0;

	player_HUDmodel.effects = 4864;	// --> DP_EF_NOGUNBOB = 256;  EF_FULLBRIGHT = 512;  EF_NOSHADOW = 4096;

	player_HUDmodel.scale = 0.07;

	player_HUDmodel.think = player_HUD_model_animation;
	player_HUDmodel.nextthink = time;
};



void() item_mini_player_touch =
{
	if (other.health <= 0)
		return;
	if (other.classname != "player")
		return;

	sprint (other, "You got the ");
	sprint (other, self.netname);
	sprint (other,"\n");

	sound (other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
	stuffcmd (other, "bf\n");

	other.mini_player_picked_up = 1;
	
	self.touch = SUB_Null;
	remove (self);
};


void () item_mini_player =
{
	self.touch = item_mini_player_touch;

	precache_model ("progs/player_HUD.mdl");
	precache_sound ("player/laugh.wav");
	self.noise = "player/laugh.wav";
	setmodel (self, "progs/player_HUD.mdl");

	self.traileffectnum = particleeffectnum("g_weaponeffect");

	self.netname = "mini_player";
	setsize (self, '-16 -16 -24', '16 16 32');

	self.flags = FL_ITEM;
	self.solid = SOLID_TRIGGER;
	self.movetype = MOVETYPE_FLY;	
	self.modelflags = MF_ROTATE;
	self.origin_z = self.origin_z + 20;
	self.scale = 0.45;
	self.frame = 15;
};










/////// KEY HUD model effects:  Spawn spinning HUD model when picking up key

void() key_s_HUD_spinning_model_start =
{
	if (intermission_running)		// do not show HUD model during intermission
	{	
		remove (self);
		return;
	}

	self.angles_y = self.angles_y + 2.5;	// rotate speed
	key_s_HUD_orientation_y = self.angles_y;	

	if (autocvar_HUD_spinning_bottom_model_manual_y_position == 0)
		Positioning_Y_according_to_FOV_bottom (self);
	else
		self.origin_y = autocvar_HUD_spinning_bottom_model_manual_y_position;
	self.origin_y = self.origin_y - 22;

	if (autocvar_HUD_spinning_bottom_model_manual_z_position == 0)
		Positioning_Z_according_to_FOV_bottom (self);
	else
		self.origin_z = autocvar_HUD_spinning_bottom_model_manual_z_position;
	self.origin_z = self.origin_z - 4;

	self.think = key_s_HUD_spinning_model_start;
	self.nextthink = time + 0.02;
};


void(entity e) key_s_HUD_spinning_model =
{
	local entity key_HUD_model;
	key_HUD_model = spawn();
	key_HUD_model.alpha = 1;	
	key_HUD_model.skin = 0;
	key_HUD_model.owner = e;
	key_HUD_model.viewmodelforclient = self;

	if (world.worldtype == 0)
		setmodel (key_HUD_model, "progs/w_s_key.mdl");
	else if (world.worldtype == 1)
		setmodel (key_HUD_model, "progs/m_s_key.mdl");
	else if (world.worldtype == 2)
		setmodel (key_HUD_model, "progs/b_s_key.mdl");

	key_HUD_model.origin_x = 20;		//  back/forth  (= big/small)

	if (autocvar_HUD_spinning_bottom_model_manual_y_position == 0)
		Positioning_Y_according_to_FOV_bottom (key_HUD_model);
	else
		key_HUD_model.origin_y = autocvar_HUD_spinning_bottom_model_manual_y_position;
	key_HUD_model.origin_y = key_HUD_model.origin_y - 17;

	if (autocvar_HUD_spinning_bottom_model_manual_z_position == 0)
		Positioning_Z_according_to_FOV_bottom (key_HUD_model);
	else
		key_HUD_model.origin_z = autocvar_HUD_spinning_bottom_model_manual_z_position;
	key_HUD_model.origin_z = key_HUD_model.origin_z - 4;

	key_HUD_model.angles_x = 0;
	key_HUD_model.angles_y = key_g_HUD_orientation_y;	// always spin sync to other key 
	key_HUD_model.angles_z = 0;

	key_HUD_model.effects = 4864;	// --> DP_EF_NOGUNBOB = 256;  EF_FULLBRIGHT = 512;  EF_NOSHADOW = 4096;

	key_HUD_model.scale = 0.07;

	key_HUD_model.think = key_s_HUD_spinning_model_start;
	key_HUD_model.nextthink = time;
};







void() key_g_HUD_spinning_model_start =
{
	if (intermission_running)			// do not show HUD model during intermission
	{	
		remove (self);
		return;
	}

	self.angles_y = self.angles_y + 2.5;	// rotate speed
	key_g_HUD_orientation_y = self.angles_y;

	if (autocvar_HUD_spinning_bottom_model_manual_y_position == 0)
		Positioning_Y_according_to_FOV_bottom (self);
	else
		self.origin_y = autocvar_HUD_spinning_bottom_model_manual_y_position;
	self.origin_y = self.origin_y - 23.5;

	if (autocvar_HUD_spinning_bottom_model_manual_z_position == 0)
		Positioning_Z_according_to_FOV_bottom (self);
	else
		self.origin_z = autocvar_HUD_spinning_bottom_model_manual_z_position;
	self.origin_z = self.origin_z - 4;

	self.think = key_g_HUD_spinning_model_start;
	self.nextthink = time + 0.02;
};


void(entity e) key_g_HUD_spinning_model =
{
	local entity key_HUD_model;
	key_HUD_model = spawn();
	key_HUD_model.alpha = 1;	
	key_HUD_model.skin = 0;
	key_HUD_model.owner = e;
	key_HUD_model.viewmodelforclient = self;

	if (world.worldtype == 0)
		setmodel (key_HUD_model, "progs/w_g_key.mdl");
	else if (world.worldtype == 1)
		setmodel (key_HUD_model, "progs/m_g_key.mdl");
	else if (world.worldtype == 2)
		setmodel (key_HUD_model, "progs/b_g_key.mdl");

	key_HUD_model.origin_x = 20;		//  back/forth  (= big/small) 

	if (autocvar_HUD_spinning_bottom_model_manual_y_position == 0)
		Positioning_Y_according_to_FOV_bottom (key_HUD_model);
	else
		key_HUD_model.origin_y = autocvar_HUD_spinning_bottom_model_manual_y_position;
	key_HUD_model.origin_y = key_HUD_model.origin_y - 17;

	if (autocvar_HUD_spinning_bottom_model_manual_z_position == 0)
		Positioning_Z_according_to_FOV_bottom (key_HUD_model);
	else
		key_HUD_model.origin_z = autocvar_HUD_spinning_bottom_model_manual_z_position;
	key_HUD_model.origin_z = key_HUD_model.origin_z - 4;

	key_HUD_model.angles_x = 0;
	key_HUD_model.angles_y = key_s_HUD_orientation_y;	// always spin sync to other key 
	key_HUD_model.angles_z = 0;

	key_HUD_model.effects = 4864;	// --> DP_EF_NOGUNBOB = 256;  EF_FULLBRIGHT = 512;  EF_NOSHADOW = 4096;

	key_HUD_model.scale = 0.07;

	key_HUD_model.think = key_g_HUD_spinning_model_start;
	key_HUD_model.nextthink = time;
};









/////// Bloot splats on HUD when standing near corpses or monsters when gibbing them   ( <100 Quake units )

void() blood_HUD_splat_think =
{
	if (intermission_running)			// do not show waterdrops during intermission
	{	
		remove (self);
		return;
	}
 
 	if (self.owner.waterlevel == 3)			// remove blood splats as soon as players head is underwater
	{	
		remove (self);
		return;
	}

 	if (self.alpha < 0.05)				// remove waterdrops when alpha reaches low value
	{	
		remove (self);
		return;
	}

/*
	self.origin_z = self.origin_z - 0.017;			// movement speed downwards
	if (self.randomdirection)
		self.origin_y = self.origin_y + 0.0025;		// move it a little left or right to make it look more real + varied
	else
		self.origin_y = self.origin_y - 0.0025;
*/
	
	self.alpha = self.alpha - 0.007;			// fade out

	if (autocvar_HUD_visor_texture_manual_scale == 0)	// to make it possible to adjust scale without map restart
		Scaling_according_to_FOV (self);
	else
		self.scale = autocvar_HUD_visor_texture_manual_scale;
	self.scale = self.scale + 0.07;				// make it little bigger than calculated/set
	
	self.think = blood_HUD_splat_think;
	self.nextthink = time + 0.01;
};


void(entity e) blood_HUD_splat_start =
{
	local float randy;
	local entity blood_HUD_model;
	blood_HUD_model = spawn();
	blood_HUD_model.alpha = 0.8;	
	randy = random();
	if (randy < 0.11)
		blood_HUD_model.skin = 36;		// blood texture1
	else if (randy < 0.22)
		blood_HUD_model.skin = 37;		// blood texture2
	else if (randy < 0.33)
		blood_HUD_model.skin = 38;		// blood texture3
	else if (randy < 0.44)
		blood_HUD_model.skin = 39;		// blood texture4
	else if (randy < 0.55)
		blood_HUD_model.skin = 40;		// blood texture5
	else if (randy < 0.66)
		blood_HUD_model.skin = 41;		// blood texture6
	else if (randy < 0.77)
		blood_HUD_model.skin = 42;		// blood texture7
	else if (randy < 0.88)
		blood_HUD_model.skin = 43;		// blood texture8
	else
		blood_HUD_model.skin = 44;		// blood texture9
	blood_HUD_model.owner = e;
	blood_HUD_model.viewmodelforclient = self;
	
	setmodel(blood_HUD_model, "progs/biosui.mdl");

	blood_HUD_model.origin_x = 3.7;			// in front of biosuit visor
	blood_HUD_model.origin_y = crandom() * 1.55;
	blood_HUD_model.origin_z = crandom() * 1.1;

	blood_HUD_model.angles_x = 90 + crandom() * 25;
	blood_HUD_model.angles_y = -90;
	blood_HUD_model.angles_z = 90;

	blood_HUD_model.effects = 4864;		// --> DP_EF_NOGUNBOB = 256;  EF_FULLBRIGHT = 512;  EF_NOSHADOW = 4096;

	if (autocvar_HUD_visor_texture_manual_scale == 0)
		Scaling_according_to_FOV (blood_HUD_model);
	else
		blood_HUD_model.scale = autocvar_HUD_visor_texture_manual_scale;
	blood_HUD_model.scale = blood_HUD_model.scale + 0.07;		// make it little bigger than calculated/set

	blood_HUD_model.think = blood_HUD_splat_think;
	blood_HUD_model.nextthink = time + 0.4;
};








/////// Invisible weapon function  (make view_weapons visible during invisibility phase):

void() add_weapon =
{
	self.origin = '0 0 0';
	setmodel(self, self.owner.weaponmodel);
	self.alpha = 0.3;
	self.frame = self.owner.weaponframe;
	self.think = SUB_Remove;
	self.nextthink = time;
}

void(entity e) add_transparent_weaponmodel =
{
	newmis = spawn();
	newmis.owner = e;
	newmis.viewmodelforclient = self;
	newmis.think = add_weapon;
	newmis.nextthink = time;
};





/////// Add Quake3 quad-damage-effect to moved view weapons  (based on idea by Nahuel)

void() Quake3_quad_effect_v_weapon_position_anim =
{
	if (intermission_running)			// do not show view_weapon during intermission
	{	
		remove (self);
		return;
	}
 
 	if (self.owner.meleeing == 1)			// instant melee axe attack
	{	
		self.alpha = -1;
		self.think = Quake3_quad_effect_v_weapon_position_anim;
		self.nextthink = time;
		return;
	}
	else
		self.alpha = 0.5;

	if (!self.owner.super_damage_finished)
	{	
		remove (self);
		return;
	}

	if ((autocvar_mage_weapon) && (self.owner.weapon == IT_LIGHTNING))
		self.alpha = -1;
	else
		self.alpha = 0.5;

	if (self.owner.weapon == IT_SHOTGUN)
	{
		setmodel(self, "progs/v_shot.mdl");
		self.origin_x = autocvar_weapon_position_fully_adjustable_shot1_x_offset;
		self.origin_y = autocvar_weapon_position_fully_adjustable_shot1_y_offset;
		self.origin_z = autocvar_weapon_position_fully_adjustable_shot1_z_offset;
		self.angles_x = autocvar_weapon_position_fully_adjustable_shot1_x_angle;
		self.angles_y = autocvar_weapon_position_fully_adjustable_shot1_y_angle;
		self.angles_z = autocvar_weapon_position_fully_adjustable_shot1_z_angle;
	}
	else if (self.owner.weapon == IT_SUPER_SHOTGUN)
	{
		setmodel(self, "progs/v_shot2.mdl");
		self.origin_x = autocvar_weapon_position_fully_adjustable_shot2_x_offset;
		self.origin_y = autocvar_weapon_position_fully_adjustable_shot2_y_offset;
		self.origin_z = autocvar_weapon_position_fully_adjustable_shot2_z_offset;
		self.angles_x = autocvar_weapon_position_fully_adjustable_shot2_x_angle;
		self.angles_y = autocvar_weapon_position_fully_adjustable_shot2_y_angle;
		self.angles_z = autocvar_weapon_position_fully_adjustable_shot2_z_angle;
	}
	else if (self.owner.weapon == IT_NAILGUN)
	{
		setmodel(self, "progs/v_nail.mdl");
		self.origin_x = autocvar_weapon_position_fully_adjustable_nail1_x_offset;
		self.origin_y = autocvar_weapon_position_fully_adjustable_nail1_y_offset;	
		self.origin_z = autocvar_weapon_position_fully_adjustable_nail1_z_offset;
		self.angles_x = autocvar_weapon_position_fully_adjustable_nail1_x_angle;
		self.angles_y = autocvar_weapon_position_fully_adjustable_nail1_y_angle;
		self.angles_z = autocvar_weapon_position_fully_adjustable_nail1_z_angle;
	}
	else if (self.owner.weapon == IT_SUPER_NAILGUN)
	{
		setmodel(self, "progs/v_nail2.mdl");
		self.origin_x = autocvar_weapon_position_fully_adjustable_nail2_x_offset;
		self.origin_y = autocvar_weapon_position_fully_adjustable_nail2_y_offset;	
		self.origin_z = autocvar_weapon_position_fully_adjustable_nail2_z_offset;
		self.angles_x = autocvar_weapon_position_fully_adjustable_nail2_x_angle;
		self.angles_y = autocvar_weapon_position_fully_adjustable_nail2_y_angle;
		self.angles_z = autocvar_weapon_position_fully_adjustable_nail2_z_angle;
	}
	else if (self.owner.weapon == IT_GRENADE_LAUNCHER)
	{
		setmodel(self, "progs/v_rock.mdl");
		self.origin_x = autocvar_weapon_position_fully_adjustable_gren_x_offset;
		self.origin_y = autocvar_weapon_position_fully_adjustable_gren_y_offset;	
		self.origin_z = autocvar_weapon_position_fully_adjustable_gren_z_offset;
		self.angles_x = autocvar_weapon_position_fully_adjustable_gren_x_angle;
		self.angles_y = autocvar_weapon_position_fully_adjustable_gren_y_angle;
		self.angles_z = autocvar_weapon_position_fully_adjustable_gren_z_angle;
	}
	else if (self.owner.weapon == IT_ROCKET_LAUNCHER)
	{
		setmodel(self, "progs/v_rock2.mdl");
		self.origin_x = autocvar_weapon_position_fully_adjustable_rock_x_offset;
		self.origin_y = autocvar_weapon_position_fully_adjustable_rock_y_offset;	
		self.origin_z = autocvar_weapon_position_fully_adjustable_rock_z_offset;
		self.angles_x = autocvar_weapon_position_fully_adjustable_rock_x_angle;
		self.angles_y = autocvar_weapon_position_fully_adjustable_rock_y_angle;
		self.angles_z = autocvar_weapon_position_fully_adjustable_rock_z_angle;
	}
	else if (self.owner.weapon == IT_LIGHTNING)
	{
		setmodel(self, "progs/v_light.mdl");
		if (autocvar_weapon_position_fully_adjustable == 1)
		{
			self.origin_x = autocvar_weapon_position_fully_adjustable_light_x_offset;
			self.origin_y = autocvar_weapon_position_fully_adjustable_light_y_offset;	
			self.origin_z = autocvar_weapon_position_fully_adjustable_light_z_offset;
			self.angles_x = autocvar_weapon_position_fully_adjustable_light_x_angle;
			self.angles_y = autocvar_weapon_position_fully_adjustable_light_y_angle;
			self.angles_z = autocvar_weapon_position_fully_adjustable_light_z_angle;
		}
		else
		{
			self.origin = '0 0 0';
			self.angles = '0 0 0';
		}	
	}
	else	// axe
	{
		if (autocvar_zombieaxeanimation)	
			setmodel(self, "progs/v_axe_zombie00.mdl");
		else
			setmodel(self, "progs/v_axe.mdl");
		self.origin_x = autocvar_weapon_position_fully_adjustable_axe_x_offset;
		self.origin_y = autocvar_weapon_position_fully_adjustable_axe_y_offset;
		self.origin_z = autocvar_weapon_position_fully_adjustable_axe_z_offset;
		self.angles_x = autocvar_weapon_position_fully_adjustable_axe_x_angle;
		self.angles_y = autocvar_weapon_position_fully_adjustable_axe_y_angle;
		self.angles_z = autocvar_weapon_position_fully_adjustable_axe_z_angle;
	}

	self.frame = self.owner.weaponframe;
	self.nextthink = time;
};


void(entity e) add_Quake3_quad_effect_v_weapon_position = 
{
	newmis = spawn();
	newmis.owner = e;
	newmis.skin = 1;
	newmis.alpha = 0.5;
	newmis.colormod = '0 0 0.5'; 
	newmis.viewmodelforclient = self;
	newmis.think = Quake3_quad_effect_v_weapon_position_anim;
	newmis.nextthink = time;
};




///////  Add adjustable idle weapon animation to view-weapons

void (float x_offset, float y_offset, float z_offset, float x_angle, float y_angle, float z_angle) idle_weapon_animation =	
{
if (!autocvar_weapon_position_fully_adjustable_idle_animation)
	return;

local float randy_x_off, randy_y_off, randy_z_off, randy_x_ang, randy_y_ang, randy_z_ang;

	self.v_weapon_animation = time + (autocvar_weapon_position_fully_adjustable_idle_animation_speed + (crandom() * 0.007));	// animation begins to stutter at a frequence of 0.06 seconds !!

	self.origin_x_old = self.origin_x;
	self.origin_y_old = self.origin_y;
	self.origin_z_old = self.origin_z;
	self.angles_x_old = self.angles_x;
	self.angles_y_old = self.angles_y;
	self.angles_z_old = self.angles_z;
	
	if (self.weapon_anim_x_offset_downwards == 0)
	{	
		if ((self.origin_x_old + 0.006) < (x_offset + (autocvar_weapon_position_fully_adjustable_idle_animation_vigor * 0.5))) 	// forward
			self.origin_x = self.origin_x_old + 0.006;
		else
			self.weapon_anim_x_offset_downwards = 1;			// when reaching border/limit position, move to opposite at once
		if ((self.origin_x > (x_offset - 0.004)) && (self.origin_x < (x_offset + 0.004)))	// when coming back to initial pos
			self.weapon_anim_x_offset_downwards = 2;
	}
	else if (self.weapon_anim_x_offset_downwards == 1)
	{
		if ((self.origin_x_old - 0.006) > (x_offset - (autocvar_weapon_position_fully_adjustable_idle_animation_vigor * 0.8)))  // backward
			self.origin_x = self.origin_x_old - 0.006;
		else
			self.weapon_anim_x_offset_downwards = 0;			// when reaching border/limit position, move to opposite at once
		if ((self.origin_x > (x_offset - 0.004)) && (self.origin_x < (x_offset + 0.004)))	// when coming back to initial pos
			self.weapon_anim_x_offset_downwards = 2;		
	}
	else 	// = 2							// pause animation at initial pos
	{
		randy_x_off = random ();
		if (randy_x_off < autocvar_weapon_position_fully_adjustable_idle_animation_pause)
			self.weapon_anim_x_offset_downwards = 0;
		else if (randy_x_off < (2 * autocvar_weapon_position_fully_adjustable_idle_animation_pause))
			self.weapon_anim_x_offset_downwards = 1;
	}

	if (self.weapon_anim_y_offset_downwards == 0)
	{	
		if ((self.origin_y_old + 0.006) < (y_offset + (autocvar_weapon_position_fully_adjustable_idle_animation_vigor * 0.5))) 	// left
			self.origin_y = self.origin_y_old + 0.006;
		else
			self.weapon_anim_y_offset_downwards = 1;			// when reaching border/limit position, move to opposite at once
		if ((self.origin_y > (y_offset - 0.004)) && (self.origin_y < (y_offset + 0.004)))	// when coming back to initial pos
			self.weapon_anim_y_offset_downwards = 2;	// pause animation at initial pos
	}
	else if (self.weapon_anim_y_offset_downwards == 1)
	{
		if ((self.origin_y_old - 0.006) > (y_offset - (autocvar_weapon_position_fully_adjustable_idle_animation_vigor * 0.7))) 	// right
			self.origin_y = self.origin_y_old - 0.006;
		else
			self.weapon_anim_y_offset_downwards = 0;			// when reaching border/limit position, move to opposite at once
		if ((self.origin_y > (y_offset - 0.004)) && (self.origin_y < (y_offset + 0.004)))	// when coming back to initial pos
			self.weapon_anim_y_offset_downwards = 2;	// pause animation at initial pos
	}
	else	// =2							// pause animation at initial pos
	{
		randy_y_off = random ();
		if (randy_y_off < autocvar_weapon_position_fully_adjustable_idle_animation_pause)
			self.weapon_anim_y_offset_downwards = 0;
		else if (randy_y_off < (2 * autocvar_weapon_position_fully_adjustable_idle_animation_pause))
			self.weapon_anim_y_offset_downwards = 1;
	}
	
	if (self.weapon_anim_z_offset_downwards == 0)
	{	
		if ((self.origin_z_old + 0.006) < (z_offset + (autocvar_weapon_position_fully_adjustable_idle_animation_vigor * 0.7))) 	// upwards (but keep gun-mouth quite down) (make it even with downwards)
			self.origin_z = self.origin_z_old + 0.006;
		else
			self.weapon_anim_z_offset_downwards = 1;			// when reaching border/limit position, move to opposite at once
		if ((self.origin_z > (z_offset - 0.004)) && (self.origin_z < (z_offset + 0.004)))	// when coming back to initial pos
			self.weapon_anim_z_offset_downwards = 2;
	}
	else if (self.weapon_anim_z_offset_downwards == 1)
	{
		if ((self.origin_z_old - 0.006) > (z_offset - (autocvar_weapon_position_fully_adjustable_idle_animation_vigor * 0.7))) 	// downwards (but keep gun-mouth quite down) 
			self.origin_z = self.origin_z_old - 0.006;
		else
			self.weapon_anim_z_offset_downwards = 0;			// when reaching border/limit position, move to opposite at once
		if ((self.origin_z > (z_offset - 0.004)) && (self.origin_z < (z_offset + 0.004)))	// when coming back to initial pos
				self.weapon_anim_z_offset_downwards = 2;
	}
	else	// =2							// pause animation at initial pos
	{
		randy_z_off = random ();
		if (randy_z_off < autocvar_weapon_position_fully_adjustable_idle_animation_pause)
			self.weapon_anim_z_offset_downwards = 0;
		else if (randy_z_off < (2 * autocvar_weapon_position_fully_adjustable_idle_animation_pause))
			self.weapon_anim_z_offset_downwards = 1;
	}
	
	
	if (self.weapon_anim_x_angles_downwards == 0)
	{	
		if ((self.angles_x_old + 0.025) < (x_angle + (autocvar_weapon_position_fully_adjustable_idle_animation_vigor * 3))) 	// more or less "forward + up" 
			self.angles_x = self.angles_x_old + 0.025;
		else
			self.weapon_anim_x_angles_downwards = 1;			// when reaching border/limit position, move to opposite at once
		if ((self.angles_x > (x_angle - 0.015)) && (self.angles_x < (x_angle + 0.015)))	// when coming back to initial pos
			self.weapon_anim_x_angles_downwards = 2;
	}
	else if (self.weapon_anim_x_angles_downwards == 1)
	{
		if ((self.angles_x_old - 0.035) > (x_angle - (autocvar_weapon_position_fully_adjustable_idle_animation_vigor * 3)))  	// more or less "backward + down" 
			self.angles_x = self.angles_x_old - 0.035;
		else
			self.weapon_anim_x_angles_downwards = 0;			// when reaching border/limit position, move to opposite at once
		if ((self.angles_x > (x_angle - 0.02)) && (self.angles_x < (x_angle + 0.02)))	// when coming back to initial pos
			self.weapon_anim_x_angles_downwards = 2;
	}
	else	// =2							// pause animation at initial pos
	{
		randy_x_ang = random ();
		if (randy_x_ang < autocvar_weapon_position_fully_adjustable_idle_animation_pause)
			self.weapon_anim_x_angles_downwards = 0;
		else if (randy_x_ang < (2 * autocvar_weapon_position_fully_adjustable_idle_animation_pause))
			self.weapon_anim_x_angles_downwards = 1;
	}

	if (self.weapon_anim_y_angles_downwards == 0)
	{	
		if ((self.angles_y_old + 0.05) < (y_angle + (autocvar_weapon_position_fully_adjustable_idle_animation_vigor * 5))) 		// aim left (keep left and right even)
			self.angles_y = self.angles_y_old + 0.05;
		else
			self.weapon_anim_y_angles_downwards = 1;			// when reaching border/limit position, move to opposite at once
		if ((self.angles_y > (y_angle - 0.04)) && (self.angles_y < (y_angle + 0.04)))	// when coming back to initial pos
			self.weapon_anim_y_angles_downwards = 2;
	}
	else if (self.weapon_anim_y_angles_downwards == 1)
	{
		if ((self.angles_y_old - 0.05) > (y_angle - (autocvar_weapon_position_fully_adjustable_idle_animation_vigor * 5)))   	// aim right (keep left and right even)
			self.angles_y = self.angles_y_old - 0.05;
		else
			self.weapon_anim_y_angles_downwards = 0;			// when reaching border/limit position, move to opposite at once
		if ((self.angles_y > (y_angle - 0.04)) && (self.angles_y < (y_angle + 0.04)))	// when coming back to initial pos
			self.weapon_anim_y_angles_downwards = 2;
	}
	else	// =2							// pause animation at initial pos
	{
		randy_y_ang = random ();
		if (randy_y_ang < autocvar_weapon_position_fully_adjustable_idle_animation_pause)
			self.weapon_anim_y_angles_downwards = 0;
		else if (randy_y_ang < (2 * autocvar_weapon_position_fully_adjustable_idle_animation_pause))
			self.weapon_anim_y_angles_downwards = 1;
	}

	if (self.weapon_anim_z_angles_downwards == 0)
	{	
		if ((self.angles_z_old + 0.05) < (z_angle + (autocvar_weapon_position_fully_adjustable_idle_animation_vigor * 3))) 	// clockwise (so, keep this value smaller than opposite)
			self.angles_z = self.angles_z_old + 0.05;
		else
			self.weapon_anim_z_angles_downwards = 1;			// when reaching border/limit position, move to opposite at once
		if ((self.angles_z > (z_angle - 0.04)) && (self.angles_z < (z_angle + 0.04)))	// when coming back to initial pos
			self.weapon_anim_z_angles_downwards = 2;
	}
	else if (self.weapon_anim_z_angles_downwards == 1)
	{
		if ((self.angles_z_old - 0.05) > (z_angle - (autocvar_weapon_position_fully_adjustable_idle_animation_vigor * 6)))  	// counter-clockwise 
			self.angles_z = self.angles_z_old - 0.05;
		else
			self.weapon_anim_z_angles_downwards = 0;			// when reaching border/limit position, move to opposite at once
		if ((self.angles_z > (z_angle - 0.04)) && (self.angles_z < (z_angle + 0.04)))	// when coming back to initial pos
			self.weapon_anim_z_angles_downwards = 2;
	}
	else	// =2							// pause animation at initial pos
	{
		randy_z_ang = random ();
		if (randy_z_ang < autocvar_weapon_position_fully_adjustable_idle_animation_pause)
			self.weapon_anim_z_angles_downwards = 0;
		else if (randy_z_ang < (2 * autocvar_weapon_position_fully_adjustable_idle_animation_pause))
			self.weapon_anim_z_angles_downwards = 1;
	}
};


///////  Make view weapons fully adjustable to any position and angle

void() v_weapon_position_think =
{
	if (self.owner.v_weapon_position_helper == 0)		// makes it possible to switch back to regular positioned weapons without restarting the map
	{
		self.owner.weaponmodel = self.model; 
		remove (self);
		return;
	}
	if (intermission_running)			// do not show view_weapon during intermission
	{	
		remove (self);
		return;
	}

	if (self.owner.meleeing == 1)			// instant melee axe attack
	{
		self.initial_weapon_position_shot1 = 0;
		self.initial_weapon_position_shot2 = 0;
		self.initial_weapon_position_nail1 = 0;
		self.initial_weapon_position_nail2 = 0;
		self.initial_weapon_position_gren = 0;
		self.initial_weapon_position_rock = 0;
		self.initial_weapon_position_light = 0;
		if (!autocvar_zombieaxeanimation)	
			setmodel(self, "progs/v_axe.mdl");
		else
			setmodel(self, "progs/v_axe_zombie00.mdl");
	
		self.owner.weaponmodel = "";

		self.frame = self.owner.weaponframe;
		if ((invisweapon) && (self.owner.invisible_finished))
			self.alpha = 0.3;
		else if ((!invisweapon) && (self.owner.invisible_finished))
			self.alpha = -1;
		else
			self.alpha = 1;
		self.nextthink = time;
		return;
	}
	
	if (self.owner.weapon == IT_SHOTGUN)
	{
		self.initial_weapon_position_axe = 0;
		self.initial_weapon_position_shot2 = 0;
		self.initial_weapon_position_nail1 = 0;
		self.initial_weapon_position_nail2 = 0;
		self.initial_weapon_position_gren = 0;
		self.initial_weapon_position_rock = 0;
		self.initial_weapon_position_light = 0;
		setmodel(self, "progs/v_shot.mdl");
		if ((self.owner.button0) || ((self.owner.velocity != '0 0 0') && (self.owner.earthquake_finished < time)) || (self.owner.super_damage_finished))	// go into initial pos when shooting or walking/running (quad effect would not match to animation, so do the same when then)
		{
			self.origin_x = autocvar_weapon_position_fully_adjustable_shot1_x_offset;
			self.origin_y = autocvar_weapon_position_fully_adjustable_shot1_y_offset;
			self.origin_z = autocvar_weapon_position_fully_adjustable_shot1_z_offset;
			self.angles_x = autocvar_weapon_position_fully_adjustable_shot1_x_angle;
			self.angles_y = autocvar_weapon_position_fully_adjustable_shot1_y_angle;
			self.angles_z = autocvar_weapon_position_fully_adjustable_shot1_z_angle;
			if (random() < 0.5)
				self.weapon_anim_x_offset_downwards = 0;
			else
				self.weapon_anim_x_offset_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_y_offset_downwards = 0;
			else
				self.weapon_anim_y_offset_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_z_offset_downwards = 0;
			else
				self.weapon_anim_z_offset_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_x_angles_downwards = 0;
			else
				self.weapon_anim_x_angles_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_y_angles_downwards = 0;
			else
				self.weapon_anim_y_angles_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_z_angles_downwards = 0;
			else
				self.weapon_anim_z_angles_downwards = 1;
		}
		else if (self.initial_weapon_position_shot1 == 0)
		{
			self.initial_weapon_position_shot1 = 1;
			if (random() < 0.5)
				self.weapon_anim_x_offset_downwards = 0;
			else
				self.weapon_anim_x_offset_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_y_offset_downwards = 0;
			else
				self.weapon_anim_y_offset_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_z_offset_downwards = 0;
			else
				self.weapon_anim_z_offset_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_x_angles_downwards = 0;
			else
				self.weapon_anim_x_angles_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_y_angles_downwards = 0;
			else
				self.weapon_anim_y_angles_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_z_angles_downwards = 0;
			else
				self.weapon_anim_z_angles_downwards = 1;
			self.origin_x = autocvar_weapon_position_fully_adjustable_shot1_x_offset;
			self.origin_y = autocvar_weapon_position_fully_adjustable_shot1_y_offset;
			self.origin_z = autocvar_weapon_position_fully_adjustable_shot1_z_offset;
			self.angles_x = autocvar_weapon_position_fully_adjustable_shot1_x_angle;
			self.angles_y = autocvar_weapon_position_fully_adjustable_shot1_y_angle;
			self.angles_z = autocvar_weapon_position_fully_adjustable_shot1_z_angle;
		}
		else if (self.v_weapon_animation < time)
			idle_weapon_animation (autocvar_weapon_position_fully_adjustable_shot1_x_offset, autocvar_weapon_position_fully_adjustable_shot1_y_offset, autocvar_weapon_position_fully_adjustable_shot1_z_offset, autocvar_weapon_position_fully_adjustable_shot1_x_angle, autocvar_weapon_position_fully_adjustable_shot1_y_angle, autocvar_weapon_position_fully_adjustable_shot1_z_angle);
	}
	else if (self.owner.weapon == IT_SUPER_SHOTGUN)
	{
		self.initial_weapon_position_axe = 0;
		self.initial_weapon_position_shot1 = 0;
		self.initial_weapon_position_nail1 = 0;
		self.initial_weapon_position_nail2 = 0;
		self.initial_weapon_position_gren = 0;
		self.initial_weapon_position_rock = 0;
		self.initial_weapon_position_light = 0;
		setmodel(self, "progs/v_shot2.mdl");
		if ((self.owner.button0) || ((self.owner.velocity != '0 0 0') && (self.owner.earthquake_finished < time)) || (self.owner.super_damage_finished))	// go into initial pos when shooting or walking/running (quad effect would not match to animation, so do the same when then)
		{
			self.origin_x = autocvar_weapon_position_fully_adjustable_shot2_x_offset;
			self.origin_y = autocvar_weapon_position_fully_adjustable_shot2_y_offset;
			self.origin_z = autocvar_weapon_position_fully_adjustable_shot2_z_offset;
			self.angles_x = autocvar_weapon_position_fully_adjustable_shot2_x_angle;
			self.angles_y = autocvar_weapon_position_fully_adjustable_shot2_y_angle;
			self.angles_z = autocvar_weapon_position_fully_adjustable_shot2_z_angle;
			if (random() < 0.5)
				self.weapon_anim_x_offset_downwards = 0;
			else
				self.weapon_anim_x_offset_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_y_offset_downwards = 0;
			else
				self.weapon_anim_y_offset_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_z_offset_downwards = 0;
			else
				self.weapon_anim_z_offset_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_x_angles_downwards = 0;
			else
				self.weapon_anim_x_angles_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_y_angles_downwards = 0;
			else
				self.weapon_anim_y_angles_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_z_angles_downwards = 0;
			else
				self.weapon_anim_z_angles_downwards = 1;
		}
		else if (self.initial_weapon_position_shot2 == 0)
		{
			self.initial_weapon_position_shot2 = 1;
			if (random() < 0.5)
				self.weapon_anim_x_offset_downwards = 0;
			else
				self.weapon_anim_x_offset_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_y_offset_downwards = 0;
			else
				self.weapon_anim_y_offset_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_z_offset_downwards = 0;
			else
				self.weapon_anim_z_offset_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_x_angles_downwards = 0;
			else
				self.weapon_anim_x_angles_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_y_angles_downwards = 0;
			else
				self.weapon_anim_y_angles_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_z_angles_downwards = 0;
			else
				self.weapon_anim_z_angles_downwards = 1;
			self.origin_x = autocvar_weapon_position_fully_adjustable_shot2_x_offset;
			self.origin_y = autocvar_weapon_position_fully_adjustable_shot2_y_offset;
			self.origin_z = autocvar_weapon_position_fully_adjustable_shot2_z_offset;
			self.angles_x = autocvar_weapon_position_fully_adjustable_shot2_x_angle;
			self.angles_y = autocvar_weapon_position_fully_adjustable_shot2_y_angle;
			self.angles_z = autocvar_weapon_position_fully_adjustable_shot2_z_angle;
		}
		else if (self.v_weapon_animation < time)
			idle_weapon_animation (autocvar_weapon_position_fully_adjustable_shot2_x_offset, autocvar_weapon_position_fully_adjustable_shot2_y_offset, autocvar_weapon_position_fully_adjustable_shot2_z_offset, autocvar_weapon_position_fully_adjustable_shot2_x_angle, autocvar_weapon_position_fully_adjustable_shot2_y_angle, autocvar_weapon_position_fully_adjustable_shot2_z_angle);
	}
	else if (self.owner.weapon == IT_NAILGUN)
	{
		self.initial_weapon_position_axe = 0;
		self.initial_weapon_position_shot1 = 0;
		self.initial_weapon_position_shot2 = 0;
		self.initial_weapon_position_nail2 = 0;
		self.initial_weapon_position_gren = 0;
		self.initial_weapon_position_rock = 0;
		self.initial_weapon_position_light = 0;
		setmodel(self, "progs/v_nail.mdl");
		if ((self.owner.button0) || ((self.owner.velocity != '0 0 0') && (self.owner.earthquake_finished < time)) || (self.owner.super_damage_finished))	// go into initial pos when shooting or walking/running (quad effect would not match to animation, so do the same when then)
		{
			self.origin_x = autocvar_weapon_position_fully_adjustable_nail1_x_offset;
			self.origin_y = autocvar_weapon_position_fully_adjustable_nail1_y_offset;
			self.origin_z = autocvar_weapon_position_fully_adjustable_nail1_z_offset;
			self.angles_x = autocvar_weapon_position_fully_adjustable_nail1_x_angle;
			self.angles_y = autocvar_weapon_position_fully_adjustable_nail1_y_angle;
			self.angles_z = autocvar_weapon_position_fully_adjustable_nail1_z_angle;
			if (random() < 0.5)
				self.weapon_anim_x_offset_downwards = 0;
			else
				self.weapon_anim_x_offset_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_y_offset_downwards = 0;
			else
				self.weapon_anim_y_offset_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_z_offset_downwards = 0;
			else
				self.weapon_anim_z_offset_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_x_angles_downwards = 0;
			else
				self.weapon_anim_x_angles_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_y_angles_downwards = 0;
			else
				self.weapon_anim_y_angles_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_z_angles_downwards = 0;
			else
				self.weapon_anim_z_angles_downwards = 1;
		}
		else if (self.initial_weapon_position_nail1 == 0)
		{
			self.initial_weapon_position_nail1 = 1;
			if (random() < 0.5)
				self.weapon_anim_x_offset_downwards = 0;
			else
				self.weapon_anim_x_offset_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_y_offset_downwards = 0;
			else
				self.weapon_anim_y_offset_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_z_offset_downwards = 0;
			else
				self.weapon_anim_z_offset_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_x_angles_downwards = 0;
			else
				self.weapon_anim_x_angles_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_y_angles_downwards = 0;
			else
				self.weapon_anim_y_angles_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_z_angles_downwards = 0;
			else
				self.weapon_anim_z_angles_downwards = 1;
			self.origin_x = autocvar_weapon_position_fully_adjustable_nail1_x_offset;
			self.origin_y = autocvar_weapon_position_fully_adjustable_nail1_y_offset;
			self.origin_z = autocvar_weapon_position_fully_adjustable_nail1_z_offset;
			self.angles_x = autocvar_weapon_position_fully_adjustable_nail1_x_angle;
			self.angles_y = autocvar_weapon_position_fully_adjustable_nail1_y_angle;
			self.angles_z = autocvar_weapon_position_fully_adjustable_nail1_z_angle;
		}
		else if (self.v_weapon_animation < time)
			idle_weapon_animation (autocvar_weapon_position_fully_adjustable_nail1_x_offset, autocvar_weapon_position_fully_adjustable_nail1_y_offset, autocvar_weapon_position_fully_adjustable_nail1_z_offset, autocvar_weapon_position_fully_adjustable_nail1_x_angle, autocvar_weapon_position_fully_adjustable_nail1_y_angle, autocvar_weapon_position_fully_adjustable_nail1_z_angle);
	}
	else if (self.owner.weapon == IT_SUPER_NAILGUN)
	{
		self.initial_weapon_position_axe = 0;
		self.initial_weapon_position_shot1 = 0;
		self.initial_weapon_position_shot2 = 0;
		self.initial_weapon_position_nail1 = 0;
		self.initial_weapon_position_gren = 0;
		self.initial_weapon_position_rock = 0;
		self.initial_weapon_position_light = 0;
		setmodel(self, "progs/v_nail2.mdl");
		if ((self.owner.button0) || ((self.owner.velocity != '0 0 0') && (self.owner.earthquake_finished < time)) || (self.owner.super_damage_finished))	// go into initial pos when shooting or walking/running (quad effect would not match to animation, so do the same when then)
		{
			self.origin_x = autocvar_weapon_position_fully_adjustable_nail2_x_offset;
			self.origin_y = autocvar_weapon_position_fully_adjustable_nail2_y_offset;
			self.origin_z = autocvar_weapon_position_fully_adjustable_nail2_z_offset;
			self.angles_x = autocvar_weapon_position_fully_adjustable_nail2_x_angle;
			self.angles_y = autocvar_weapon_position_fully_adjustable_nail2_y_angle;
			self.angles_z = autocvar_weapon_position_fully_adjustable_nail2_z_angle;
			if (random() < 0.5)
				self.weapon_anim_x_offset_downwards = 0;
			else
				self.weapon_anim_x_offset_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_y_offset_downwards = 0;
			else
				self.weapon_anim_y_offset_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_z_offset_downwards = 0;
			else
				self.weapon_anim_z_offset_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_x_angles_downwards = 0;
			else
				self.weapon_anim_x_angles_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_y_angles_downwards = 0;
			else
				self.weapon_anim_y_angles_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_z_angles_downwards = 0;
			else
				self.weapon_anim_z_angles_downwards = 1;
		}
		else if (self.initial_weapon_position_nail2 == 0)
		{
			self.initial_weapon_position_nail2 = 1;
			if (random() < 0.5)
				self.weapon_anim_x_offset_downwards = 0;
			else
				self.weapon_anim_x_offset_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_y_offset_downwards = 0;
			else
				self.weapon_anim_y_offset_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_z_offset_downwards = 0;
			else
				self.weapon_anim_z_offset_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_x_angles_downwards = 0;
			else
				self.weapon_anim_x_angles_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_y_angles_downwards = 0;
			else
				self.weapon_anim_y_angles_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_z_angles_downwards = 0;
			else
				self.weapon_anim_z_angles_downwards = 1;
			self.origin_x = autocvar_weapon_position_fully_adjustable_nail2_x_offset;
			self.origin_y = autocvar_weapon_position_fully_adjustable_nail2_y_offset;
			self.origin_z = autocvar_weapon_position_fully_adjustable_nail2_z_offset;
			self.angles_x = autocvar_weapon_position_fully_adjustable_nail2_x_angle;
			self.angles_y = autocvar_weapon_position_fully_adjustable_nail2_y_angle;
			self.angles_z = autocvar_weapon_position_fully_adjustable_nail2_z_angle;
		}
		else if (self.v_weapon_animation < time)
			idle_weapon_animation (autocvar_weapon_position_fully_adjustable_nail2_x_offset, autocvar_weapon_position_fully_adjustable_nail2_y_offset, autocvar_weapon_position_fully_adjustable_nail2_z_offset, autocvar_weapon_position_fully_adjustable_nail2_x_angle, autocvar_weapon_position_fully_adjustable_nail2_y_angle, autocvar_weapon_position_fully_adjustable_nail2_z_angle);
	}
	else if (self.owner.weapon == IT_GRENADE_LAUNCHER)
	{
		self.initial_weapon_position_axe = 0;
		self.initial_weapon_position_shot1 = 0;
		self.initial_weapon_position_shot2 = 0;
		self.initial_weapon_position_nail1 = 0;
		self.initial_weapon_position_nail2 = 0;
		self.initial_weapon_position_rock = 0;
		self.initial_weapon_position_light = 0;
		setmodel(self, "progs/v_rock.mdl");
		if ((self.owner.button0) || ((self.owner.velocity != '0 0 0') && (self.owner.earthquake_finished < time)) || (self.owner.super_damage_finished))	// go into initial pos when shooting or walking/running (quad effect would not match to animation, so do the same when then)
		{
			self.origin_x = autocvar_weapon_position_fully_adjustable_gren_x_offset;
			self.origin_y = autocvar_weapon_position_fully_adjustable_gren_y_offset;
			self.origin_z = autocvar_weapon_position_fully_adjustable_gren_z_offset;
			self.angles_x = autocvar_weapon_position_fully_adjustable_gren_x_angle;
			self.angles_y = autocvar_weapon_position_fully_adjustable_gren_y_angle;
			self.angles_z = autocvar_weapon_position_fully_adjustable_gren_z_angle;
			if (random() < 0.5)
				self.weapon_anim_x_offset_downwards = 0;
			else
				self.weapon_anim_x_offset_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_y_offset_downwards = 0;
			else
				self.weapon_anim_y_offset_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_z_offset_downwards = 0;
			else
				self.weapon_anim_z_offset_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_x_angles_downwards = 0;
			else
				self.weapon_anim_x_angles_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_y_angles_downwards = 0;
			else
				self.weapon_anim_y_angles_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_z_angles_downwards = 0;
			else
				self.weapon_anim_z_angles_downwards = 1;
		}
		else if (self.initial_weapon_position_gren == 0)
		{
			self.initial_weapon_position_gren = 1;
			if (random() < 0.5)
				self.weapon_anim_x_offset_downwards = 0;
			else
				self.weapon_anim_x_offset_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_y_offset_downwards = 0;
			else
				self.weapon_anim_y_offset_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_z_offset_downwards = 0;
			else
				self.weapon_anim_z_offset_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_x_angles_downwards = 0;
			else
				self.weapon_anim_x_angles_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_y_angles_downwards = 0;
			else
				self.weapon_anim_y_angles_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_z_angles_downwards = 0;
			else
				self.weapon_anim_z_angles_downwards = 1;
			self.origin_x = autocvar_weapon_position_fully_adjustable_gren_x_offset;
			self.origin_y = autocvar_weapon_position_fully_adjustable_gren_y_offset;
			self.origin_z = autocvar_weapon_position_fully_adjustable_gren_z_offset;
			self.angles_x = autocvar_weapon_position_fully_adjustable_gren_x_angle;
			self.angles_y = autocvar_weapon_position_fully_adjustable_gren_y_angle;
			self.angles_z = autocvar_weapon_position_fully_adjustable_gren_z_angle;
		}
		else if (self.v_weapon_animation < time)
			idle_weapon_animation (autocvar_weapon_position_fully_adjustable_gren_x_offset, autocvar_weapon_position_fully_adjustable_gren_y_offset, autocvar_weapon_position_fully_adjustable_gren_z_offset, autocvar_weapon_position_fully_adjustable_gren_x_angle, autocvar_weapon_position_fully_adjustable_gren_y_angle, autocvar_weapon_position_fully_adjustable_gren_z_angle);
	}
	else if (self.owner.weapon == IT_ROCKET_LAUNCHER)
	{
		self.initial_weapon_position_axe = 0;
		self.initial_weapon_position_shot1 = 0;
		self.initial_weapon_position_shot2 = 0;
		self.initial_weapon_position_nail1 = 0;
		self.initial_weapon_position_nail2 = 0;
		self.initial_weapon_position_gren = 0;
		self.initial_weapon_position_light = 0;
		setmodel(self, "progs/v_rock2.mdl");
		if ((self.owner.button0) || ((self.owner.velocity != '0 0 0') && (self.owner.earthquake_finished < time)) || (self.owner.super_damage_finished))	// go into initial pos when shooting or walking/running (quad effect would not match to animation, so do the same when then)
		{
			self.origin_x = autocvar_weapon_position_fully_adjustable_rock_x_offset;
			self.origin_y = autocvar_weapon_position_fully_adjustable_rock_y_offset;
			self.origin_z = autocvar_weapon_position_fully_adjustable_rock_z_offset;
			self.angles_x = autocvar_weapon_position_fully_adjustable_rock_x_angle;
			self.angles_y = autocvar_weapon_position_fully_adjustable_rock_y_angle;
			self.angles_z = autocvar_weapon_position_fully_adjustable_rock_z_angle;
			if (random() < 0.5)
				self.weapon_anim_x_offset_downwards = 0;
			else
				self.weapon_anim_x_offset_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_y_offset_downwards = 0;
			else
				self.weapon_anim_y_offset_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_z_offset_downwards = 0;
			else
				self.weapon_anim_z_offset_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_x_angles_downwards = 0;
			else
				self.weapon_anim_x_angles_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_y_angles_downwards = 0;
			else
				self.weapon_anim_y_angles_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_z_angles_downwards = 0;
			else
				self.weapon_anim_z_angles_downwards = 1;
		}
		else if (self.initial_weapon_position_rock == 0)
		{
			self.initial_weapon_position_rock = 1;
			if (random() < 0.5)
				self.weapon_anim_x_offset_downwards = 0;
			else
				self.weapon_anim_x_offset_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_y_offset_downwards = 0;
			else
				self.weapon_anim_y_offset_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_z_offset_downwards = 0;
			else
				self.weapon_anim_z_offset_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_x_angles_downwards = 0;
			else
				self.weapon_anim_x_angles_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_y_angles_downwards = 0;
			else
				self.weapon_anim_y_angles_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_z_angles_downwards = 0;
			else
				self.weapon_anim_z_angles_downwards = 1;
			self.origin_x = autocvar_weapon_position_fully_adjustable_rock_x_offset;
			self.origin_y = autocvar_weapon_position_fully_adjustable_rock_y_offset;
			self.origin_z = autocvar_weapon_position_fully_adjustable_rock_z_offset;
			self.angles_x = autocvar_weapon_position_fully_adjustable_rock_x_angle;
			self.angles_y = autocvar_weapon_position_fully_adjustable_rock_y_angle;
			self.angles_z = autocvar_weapon_position_fully_adjustable_rock_z_angle;
		}
		else if (self.v_weapon_animation < time)
			idle_weapon_animation (autocvar_weapon_position_fully_adjustable_rock_x_offset, autocvar_weapon_position_fully_adjustable_rock_y_offset, autocvar_weapon_position_fully_adjustable_rock_z_offset, autocvar_weapon_position_fully_adjustable_rock_x_angle, autocvar_weapon_position_fully_adjustable_rock_y_angle, autocvar_weapon_position_fully_adjustable_rock_z_angle);
	}
	else if (self.owner.weapon == IT_LIGHTNING)
	{
		self.initial_weapon_position_axe = 0;
		self.initial_weapon_position_shot1 = 0;
		self.initial_weapon_position_shot2 = 0;
		self.initial_weapon_position_nail1 = 0;
		self.initial_weapon_position_nail2 = 0;
		self.initial_weapon_position_gren = 0;
		self.initial_weapon_position_rock = 0;
		if (autocvar_mage_weapon) 
			setmodel(self, "progs/v_mage1.mdl");
		else
			setmodel(self, "progs/v_light.mdl");
		if ((self.owner.button0) || ((self.owner.velocity != '0 0 0') && (self.owner.earthquake_finished < time)) || (self.owner.super_damage_finished))	// go into initial pos when shooting or walking/running (quad effect would not match to animation, so do the same when then)
		{
			if (autocvar_weapon_position_fully_adjustable == 1)
			{
				cvar_set ("cl_beams_quakepositionhack", "0");		// if 'weapon_position_right' is set to '1', change DP큦 lightning-hack cvar setting to be able to move the lightning to the right
				self.origin_x = autocvar_weapon_position_fully_adjustable_light_x_offset;
				self.origin_y = autocvar_weapon_position_fully_adjustable_light_y_offset;
				self.origin_z = autocvar_weapon_position_fully_adjustable_light_z_offset;
				self.angles_x = autocvar_weapon_position_fully_adjustable_light_x_angle;
				self.angles_y = autocvar_weapon_position_fully_adjustable_light_y_angle;
				self.angles_z = autocvar_weapon_position_fully_adjustable_light_z_angle;
			}
			else
			{
				cvar_set ("cl_beams_quakepositionhack", "1");		// restore default setting of DP큦 lightning-hack cvar setting
				self.origin = '0 0 0';
				self.angles = '0 0 0';
			}	
			if (random() < 0.5)
				self.weapon_anim_x_offset_downwards = 0;
			else
				self.weapon_anim_x_offset_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_y_offset_downwards = 0;
			else
				self.weapon_anim_y_offset_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_z_offset_downwards = 0;
			else
				self.weapon_anim_z_offset_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_x_angles_downwards = 0;
			else
				self.weapon_anim_x_angles_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_y_angles_downwards = 0;
			else
				self.weapon_anim_y_angles_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_z_angles_downwards = 0;
			else
				self.weapon_anim_z_angles_downwards = 1;
		}
		else if ((self.initial_weapon_position_light == 0) && (!autocvar_mage_weapon))
		{
			self.initial_weapon_position_light = 1;
			if (random() < 0.5)
				self.weapon_anim_x_offset_downwards = 0;
			else
				self.weapon_anim_x_offset_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_y_offset_downwards = 0;
			else
				self.weapon_anim_y_offset_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_z_offset_downwards = 0;
			else
				self.weapon_anim_z_offset_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_x_angles_downwards = 0;
			else
				self.weapon_anim_x_angles_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_y_angles_downwards = 0;
			else
				self.weapon_anim_y_angles_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_z_angles_downwards = 0;
			else
				self.weapon_anim_z_angles_downwards = 1;
			if (autocvar_weapon_position_fully_adjustable == 1)
			{
				cvar_set ("cl_beams_quakepositionhack", "0");	// if 'weapon_position_right' is set to '1', change DP큦 lightning-hack cvar setting to be able to move the lightning to the right
				self.origin_x = autocvar_weapon_position_fully_adjustable_light_x_offset;
				self.origin_y = autocvar_weapon_position_fully_adjustable_light_y_offset;
				self.origin_z = autocvar_weapon_position_fully_adjustable_light_z_offset;
				self.angles_x = autocvar_weapon_position_fully_adjustable_light_x_angle;
				self.angles_y = autocvar_weapon_position_fully_adjustable_light_y_angle;
				self.angles_z = autocvar_weapon_position_fully_adjustable_light_z_angle;
			}
			else
			{
				cvar_set ("cl_beams_quakepositionhack", "1");	// restore default setting of DP큦 lightning-hack cvar setting
				self.origin = '0 0 0';
				self.angles = '0 0 0';
			}	
		}
		else if ((self.v_weapon_animation < time) && (!autocvar_mage_weapon))
		{
			if (autocvar_weapon_position_fully_adjustable == 1)
				idle_weapon_animation (autocvar_weapon_position_fully_adjustable_light_x_offset, autocvar_weapon_position_fully_adjustable_light_y_offset, autocvar_weapon_position_fully_adjustable_light_z_offset, autocvar_weapon_position_fully_adjustable_light_x_angle, autocvar_weapon_position_fully_adjustable_light_y_angle, autocvar_weapon_position_fully_adjustable_light_z_angle);
			else
				idle_weapon_animation (0, 0, 0, 0, 0, 0);
		}	
	}
	else	// axe
	{
		self.initial_weapon_position_shot1 = 0;
		self.initial_weapon_position_shot2 = 0;
		self.initial_weapon_position_nail1 = 0;
		self.initial_weapon_position_nail2 = 0;
		self.initial_weapon_position_gren = 0;
		self.initial_weapon_position_rock = 0;
		self.initial_weapon_position_light = 0;
		if (!autocvar_zombieaxeanimation)	
			setmodel(self, "progs/v_axe.mdl");
		else
		{
			if (self.owner.weaponmodel != "")
				setmodel(self, self.owner.weaponmodel);
		}	
		if ((self.owner.button0) || ((self.owner.velocity != '0 0 0') && (self.owner.earthquake_finished < time)) || (self.owner.super_damage_finished))	// go into initial pos when shooting or walking/running (quad effect would not match to animation, so do the same when then)
		{
			self.origin_x = autocvar_weapon_position_fully_adjustable_axe_x_offset;
			self.origin_y = autocvar_weapon_position_fully_adjustable_axe_y_offset;
			self.origin_z = autocvar_weapon_position_fully_adjustable_axe_z_offset;
			self.angles_x = autocvar_weapon_position_fully_adjustable_axe_x_angle;
			self.angles_y = autocvar_weapon_position_fully_adjustable_axe_y_angle;
			self.angles_z = autocvar_weapon_position_fully_adjustable_axe_z_angle;
			if (random() < 0.5)
				self.weapon_anim_x_offset_downwards = 0;
			else
				self.weapon_anim_x_offset_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_y_offset_downwards = 0;
			else
				self.weapon_anim_y_offset_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_z_offset_downwards = 0;
			else
				self.weapon_anim_z_offset_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_x_angles_downwards = 0;
			else
				self.weapon_anim_x_angles_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_y_angles_downwards = 0;
			else
				self.weapon_anim_y_angles_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_z_angles_downwards = 0;
			else
				self.weapon_anim_z_angles_downwards = 1;
		}
		else if (self.initial_weapon_position_axe == 0)
		{
			self.initial_weapon_position_axe = 1;
			if (random() < 0.5)
				self.weapon_anim_x_offset_downwards = 0;
			else
				self.weapon_anim_x_offset_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_y_offset_downwards = 0;
			else
				self.weapon_anim_y_offset_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_z_offset_downwards = 0;
			else
				self.weapon_anim_z_offset_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_x_angles_downwards = 0;
			else
				self.weapon_anim_x_angles_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_y_angles_downwards = 0;
			else
				self.weapon_anim_y_angles_downwards = 1;
			if (random() < 0.5)
				self.weapon_anim_z_angles_downwards = 0;
			else
				self.weapon_anim_z_angles_downwards = 1;
			self.origin_x = autocvar_weapon_position_fully_adjustable_axe_x_offset;
			self.origin_y = autocvar_weapon_position_fully_adjustable_axe_y_offset;
			self.origin_z = autocvar_weapon_position_fully_adjustable_axe_z_offset;
			self.angles_x = autocvar_weapon_position_fully_adjustable_axe_x_angle;
			self.angles_y = autocvar_weapon_position_fully_adjustable_axe_y_angle;
			self.angles_z = autocvar_weapon_position_fully_adjustable_axe_z_angle;
		}
		else if (self.v_weapon_animation < time)
			idle_weapon_animation (autocvar_weapon_position_fully_adjustable_axe_x_offset, autocvar_weapon_position_fully_adjustable_axe_y_offset, autocvar_weapon_position_fully_adjustable_axe_z_offset, autocvar_weapon_position_fully_adjustable_axe_x_angle, autocvar_weapon_position_fully_adjustable_axe_y_angle, autocvar_weapon_position_fully_adjustable_axe_z_angle);
	}
	self.owner.weaponmodel = "";

	self.frame = self.owner.weaponframe;
	if ((invisweapon) && (self.owner.invisible_finished))
		self.alpha = 0.3;
	else if ((!invisweapon) && (self.owner.invisible_finished))
		self.alpha = -1;
	else
		self.alpha = 1;
	self.nextthink = time;
};


void(entity e) v_weapon_position = 
{
	newmis = spawn();
	newmis.owner = e;
	newmis.viewmodelforclient = self;
	newmis.think = v_weapon_position_think;
	newmis.nextthink = time;
};






///////  Change crosshair color when aiming at monsters/exploboxes considering individual weapon range     

void() update_weapon_range_crosshair =		
{
local vector source;
	makevectors (self.v_angle);
	source = self.origin + '0 0 16';
	
	if (self.weapon == IT_AXE)
		traceline (source, source + v_forward*64, FALSE, self);
	else if (self.weapon == IT_SHOTGUN)
		traceline (source, source + v_forward*2048, FALSE, self);
	else if (self.weapon == IT_SUPER_SHOTGUN)
		traceline (source, source + v_forward*2048, FALSE, self);
	else if (self.weapon == IT_NAILGUN)
		traceline (source, source + v_forward*2048, FALSE, self);
	else if (self.weapon == IT_SUPER_NAILGUN)
		traceline (source, source + v_forward*2048, FALSE, self);
	else if (self.weapon == IT_GRENADE_LAUNCHER)
		traceline (source, source + v_forward*777, FALSE, self);	// FIXME: find better calculation
	else if (self.weapon == IT_ROCKET_LAUNCHER)
		traceline (source, source + v_forward*2048, FALSE, self);
	else if (self.weapon == IT_LIGHTNING)
		traceline (source, source + v_forward*600, FALSE, self);
	else
		return;

	if ((trace_ent.takedamage == DAMAGE_AIM) && (trace_ent.health > 0) && (!trace_ent.i_am_a_corpse))	// if aiming at a living monster/exploboxes in weapon range
	{
		stuffcmd(self, "crosshair_color_red 0\n");		// change color
		stuffcmd(self, "crosshair_color_green 1\n");
		stuffcmd(self, "crosshair_color_blue 0\n");
	}
	else
	{
		stuffcmd(self, "crosshair_color_red 1\n");		// change color
		stuffcmd(self, "crosshair_color_green 0\n");
		stuffcmd(self, "crosshair_color_blue 0\n");
	}
};



///////  Change crosshair color according to players health
 
void() update_player_health_crosshair =		
{
	if (self.health >= 80)
	{
		stuffcmd(self, "crosshair_color_red 0\n");		// change color to green
		stuffcmd(self, "crosshair_color_green 1\n");
		stuffcmd(self, "crosshair_color_blue 0\n");
	}
	else if (self.health >= 60)
	{
		stuffcmd(self, "crosshair_color_red 0.7\n");		// change color to green-yellow
		stuffcmd(self, "crosshair_color_green 1.1\n");
		stuffcmd(self, "crosshair_color_blue 0\n");
	}
	else if (self.health >= 40)
	{
		stuffcmd(self, "crosshair_color_red 1.1\n");		// change color to yellow-ish
		stuffcmd(self, "crosshair_color_green 0.93\n");
		stuffcmd(self, "crosshair_color_blue 0\n");
	}
	else if (self.health >= 20)
	{
		stuffcmd(self, "crosshair_color_red 1\n");		// change color to orange	
		stuffcmd(self, "crosshair_color_green 0.55\n");
		stuffcmd(self, "crosshair_color_blue 0\n");
	}
	else 
	{
		stuffcmd(self, "crosshair_color_red 1\n");		// change color to red
		stuffcmd(self, "crosshair_color_green 0\n");
		stuffcmd(self, "crosshair_color_blue 0\n");
	}
};



///////  Change crosshair color according to monsters health the player is amining at
 
void() update_monster_health_crosshair =		
{
local vector source;
	makevectors (self.v_angle);
	source = self.origin + '0 0 16';
	
	traceline (source, source + v_forward*2048, FALSE, self);

	if ((trace_ent.takedamage == DAMAGE_AIM) && (trace_ent.health > 0) && (!trace_ent.i_am_a_corpse) && (trace_ent.model != "maps/b_explob.bsp") && (trace_ent.model != "maps/b_exbox2.bsp"))	// if aiming at a living monster, change crosshair according to its health level
	{
		if (trace_ent.classname != "monster_zombie")
		{
			if (trace_ent.health / trace_ent.health_initial >= 0.85)
			{
				stuffcmd(self, "crosshair_color_red 0\n");		// change color to green
				stuffcmd(self, "crosshair_color_green 1\n");
				stuffcmd(self, "crosshair_color_blue 0\n");
			}
			else if (trace_ent.health / trace_ent.health_initial >= 0.63)
			{
				stuffcmd(self, "crosshair_color_red 0.7\n");		// change color to green-yellow
				stuffcmd(self, "crosshair_color_green 1.1\n");
				stuffcmd(self, "crosshair_color_blue 0\n");
			}
			else if (trace_ent.health / trace_ent.health_initial >= 0.4)
			{
				stuffcmd(self, "crosshair_color_red 1.1\n");		// change color to yellow-ish
				stuffcmd(self, "crosshair_color_green 0.93\n");
				stuffcmd(self, "crosshair_color_blue 0\n");
			}
			else if (trace_ent.health / trace_ent.health_initial >= 0.15)
			{
				stuffcmd(self, "crosshair_color_red 1\n");		// change color to orange
				stuffcmd(self, "crosshair_color_green 0.55\n");
				stuffcmd(self, "crosshair_color_blue 0\n");
			}
		}
		else 	// zombie큦 do not "lose" health
		{
			stuffcmd(self, "crosshair_color_red 0\n");		// change color to green
			stuffcmd(self, "crosshair_color_green 1\n");
			stuffcmd(self, "crosshair_color_blue 0\n");
		}
	}
	else
	{
		stuffcmd(self, "crosshair_color_red 1\n");		// change color to red
		stuffcmd(self, "crosshair_color_green 0\n");
		stuffcmd(self, "crosshair_color_blue 0\n");
	}
};
 


///////  Change crosshair type according to equipped weapon (every weapon uses a different crosshair)
 
void() update_weapon_specific_crosshair =		
{
	if (self.weapon == IT_AXE)
		stuffcmd(self, "crosshair 0\n");		// disable crosshair
	else if (self.weapon == IT_SHOTGUN)
		stuffcmd(self, "crosshair 21\n");		// use crosshair no.21
	else if (self.weapon == IT_SUPER_SHOTGUN)
		stuffcmd(self, "crosshair 22\n");		// use crosshair no.22
	else if (self.weapon == IT_NAILGUN)
		stuffcmd(self, "crosshair 23\n");		// use crosshair no.23
	else if (self.weapon == IT_SUPER_NAILGUN)
		stuffcmd(self, "crosshair 24\n");		// use crosshair no.24
	else if (self.weapon == IT_GRENADE_LAUNCHER)
		stuffcmd(self, "crosshair 25\n");		// use crosshair no.25
	else if (self.weapon == IT_ROCKET_LAUNCHER)
		stuffcmd(self, "crosshair 26\n");		// use crosshair no.26
	else if (self.weapon == IT_LIGHTNING)
		stuffcmd(self, "crosshair 27\n");		// use crosshair no.27
	else
		stuffcmd(self, "crosshair 1\n");		// use crosshair no.1 as default
};



///////  Animates crosshair when picking up quad-damage
 
void() update_animated_crosshair =		
{
	self.animated_crosshair_counter = time + 0.1;
	self.animated_crosshair_type = self.animated_crosshair_type + 1;
	if (self.animated_crosshair_type == 6)
		self.animated_crosshair_type = 0;

	if (self.animated_crosshair_type == 0)
		stuffcmd(self, "crosshair 32\n");		
	else if (self.animated_crosshair_type == 1)
		stuffcmd(self, "crosshair 33\n");		
	else if (self.animated_crosshair_type == 2)
		stuffcmd(self, "crosshair 34\n");		
	else if (self.animated_crosshair_type == 3)
		stuffcmd(self, "crosshair 35\n");		
	else if (self.animated_crosshair_type == 4)
		stuffcmd(self, "crosshair 36\n");		
	else if (self.animated_crosshair_type == 5)
		stuffcmd(self, "crosshair 31\n");		
};



///////  Change crosshair size depending on monster distance
 
void() update_distance_scale_crosshair =		
{
local vector source, monster_distance;
local float crosshair_scaler;
	makevectors (self.v_angle);
	source = self.origin + '0 0 16';
	
	traceline (source, source + v_forward*2777, FALSE, self);

	if (autocvar_distance_scale_crosshair == 1)	// only change crosshair scale when aiming at monsters and explo boxes
	{
		if ((trace_ent.takedamage == DAMAGE_AIM) && (trace_ent.health > 0) && (!trace_ent.i_am_a_corpse))	// if aiming at a living monster/exploboxes 
		{
			monster_distance = trace_endpos - source;
			crosshair_scaler = ((1 / vlen(monster_distance)) * 255) * autocvar_distance_scale_crosshair_default;	// calculates the crosshair size fluently depending on used default size and distance towards enemy. When closer than 255 Quake units it gets bigger. When further away than 255 Quake units it gets smaller.
			if (crosshair_scaler < (autocvar_distance_scale_crosshair_default / 3))			// sets a minimum size, so that crosshair doesnt get too small.
				crosshair_scaler = autocvar_distance_scale_crosshair_default / 3;
			if (crosshair_scaler > (autocvar_distance_scale_crosshair_default * 3))			// sets a maximum size, so that crosshair doesnt get too large.
				crosshair_scaler = autocvar_distance_scale_crosshair_default * 3;
			stuffcmd(self, "crosshair_size ");
			stuffcmd(self, ftos(crosshair_scaler));
			stuffcmd(self, "\n");
		}
		else
			cvar_set ("crosshair_size", ftos(autocvar_distance_scale_crosshair_default));		// reset
	}
	else		// always change crosshair scale (not only when aiming at monsters and explo boxes) depending on surface distance
	{
		monster_distance = trace_endpos - source;
		crosshair_scaler = ((1 / vlen(monster_distance)) * 255) * autocvar_distance_scale_crosshair_default;	// calculates the crosshair size fluently depending on used default size and distance towards enemy. When closer than 255 Quake units it gets bigger. When further away than 255 Quake units it gets smaller.
		if (crosshair_scaler < (autocvar_distance_scale_crosshair_default / 3))			// sets a minimum size, so that crosshair doesnt get too small.
			crosshair_scaler = autocvar_distance_scale_crosshair_default / 3;
		if (crosshair_scaler > (autocvar_distance_scale_crosshair_default * 3))			// sets a maximum size, so that crosshair doesnt get too large.
			crosshair_scaler = autocvar_distance_scale_crosshair_default * 3;
		stuffcmd(self, "crosshair_size ");
		stuffcmd(self, ftos(crosshair_scaler));
		stuffcmd(self, "\n");
	}
};





///////  Make player model (legs) visible in 1st person view	

void() player_legs_animation =
{
	if ((cvar("chase_active")) || (self.owner.invisible_finished))	// if switched into 3rd person mode while playing
		self.alpha = -1;
	else
		self.alpha = 1;
	
	makevectors (self.owner.angles);
	if ((self.owner.angles_x <= -9) && (self.owner.health >= 0))    // only spawn player legs when looking downwards and is alive
	{
		if (autocvar_player_legs_visibility == 3)
			self.origin = self.owner.origin + v_up * 7 + v_forward * -20;		// for approx. FOV > 110
		else if (autocvar_player_legs_visibility == 2)
			self.origin = self.owner.origin + v_up * 7 + v_forward * -15;		// for approx. FOV between 100 and 110
		else 
			self.origin = self.owner.origin + v_up * 7 + v_forward * -10;		// for approx. FOV < 100

		self.angles = self.owner.angles;
		self.angles_x = 15;		// legs must not change x-angles together with player큦 view
		if (autocvar_player_legs_model == 1)
			setmodel(self, "progs/player_legs1.mdl");
		else
			setmodel(self, "progs/player_legs2.mdl");
		setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
	}
	else	
		setmodel(self, "");

	self.solid = SOLID_NOT;
	self.frame = self.owner.frame;

	self.think = player_legs_animation;
	self.nextthink = time;
};


void(entity e) player_legs =
{
	local entity shaderrr;
	shaderrr = spawn();
	shaderrr.skin = 0;	
	shaderrr.owner = e;
	shaderrr.think = player_legs_animation;
	shaderrr.nextthink = time;
};






///////  Switch weapon models in 3rd person view
					
void() switch_vweps
{
	if (self.health >= -40)
	{
		if (self.weapon == IT_AXE)
		{
			setmodel (self, "progs/player_shot.mdl");
			setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
		}
		else if (self.weapon == IT_SHOTGUN)
		{
			setmodel (self, "progs/player_shot.mdl");
			setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
		}
		else if (self.weapon == IT_SUPER_SHOTGUN)
		{
			setmodel (self, "progs/player_shot2.mdl");
			setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
		}
		else if (self.weapon == IT_NAILGUN)
		{
			setmodel (self, "progs/player_nail.mdl");
			setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
		}
		else if (self.weapon == IT_SUPER_NAILGUN)
		{
			setmodel (self, "progs/player_nail2.mdl");
			setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
		}
		else if (self.weapon == IT_GRENADE_LAUNCHER)
		{
			setmodel (self, "progs/player_rock.mdl");
			setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
		}
		else if (self.weapon == IT_ROCKET_LAUNCHER)
		{
			setmodel (self, "progs/player_rock2.mdl");
			setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
		}
		else if (self.weapon == IT_LIGHTNING)
		{
			setmodel (self, "progs/player_light.mdl");
			setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
		}
	}
};






/////// Add Quake3 quad-damage-effect in 3rd person view  (based on idea by Nahuel)

void () Quake3_quad_effect_3rd_think =
{
	if (intermission_running)
	{	
		remove (self);
		return;
	}

	if (!cvar("chase_active"))
	{	
		remove (self);
		return;
	}
	
	if (!self.owner.super_damage_finished)
	{	
		remove (self);
		return;
	}

	setmodel(self, self.owner.model);
	setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);

	self.origin = self.owner.origin;
	self.frame = self.owner.frame;
	self.angles = self.owner.angles;

	self.think = Quake3_quad_effect_3rd_think;
	self.nextthink = time;
};


void(entity e) add_Quake3_quad_effect_3rd =
{
	local entity shaderr;
	shaderr = spawn();
	shaderr.skin = 1;	
	shaderr.owner = e;
	shaderr.alpha = 0.5;
	shaderr.colormod = '0 0 0.5'; 
	shaderr.think = Quake3_quad_effect_3rd_think;
	shaderr.nextthink = time;
};





/////// Add Quake3 quad-damage-effect in 1st person view  (based on idea by Nahuel)

void () Quake3_quad_effect_1st_think =
{
	if (intermission_running)
	{	
		remove (self);
		return;
	}

	if (self.owner.meleeing == 1)			// instant melee axe attack
	{	
		self.alpha = -1;
		self.think = Quake3_quad_effect_1st_think;
		self.nextthink = time;
		return;
	}
	else
		self.alpha = 0.5;

	if (cvar("chase_active"))
	{	
		remove (self);
		return;
	}
	
	if (!self.owner.super_damage_finished)
	{	
		remove (self);
		return;
	}

	if ((!invisweapon) && (self.owner.invisible_finished))
	{	
		remove (self);
		return;
	}
	
	setmodel(self, self.owner.weaponmodel);
	setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
	self.solid = SOLID_NOT;

	self.frame = self.owner.weaponframe;

	self.think = Quake3_quad_effect_1st_think;
	self.nextthink = time;
};


void(entity e) add_Quake3_quad_effect_1st =
{
	local entity shaderr;
	shaderr = spawn();
	shaderr.skin = 1;	
	shaderr.owner = e;
	shaderr.alpha = 0.5;
	shaderr.colormod = '0 0 0.5'; 
	shaderr.viewmodelforclient = self;
	shaderr.think = Quake3_quad_effect_1st_think;
	shaderr.nextthink = time;
};





/////// Add Quake3 quad-damage-effect in 1st person view to legs  (based on idea by Nahuel)

void() add_Quake3_quad_effect_1st_legs_think =
{
	if (!self.owner.super_damage_finished)
	{	
		remove (self);
		return;
	}

	if ((cvar("chase_active"))||(self.owner.invisible_finished))
		self.alpha = -1;
	else
		self.alpha = 1;
	
	makevectors (self.owner.angles);
	if ((self.owner.angles_x <= -9) && (self.owner.health >= 0))    // only spawn player legs when looking downwards and is alive
	{
		if (autocvar_player_legs_visibility == 3)
			self.origin = self.owner.origin + v_up * 7 + v_forward * -20;		// for approx. FOV > 110
		else if (autocvar_player_legs_visibility == 2)
			self.origin = self.owner.origin + v_up * 7 + v_forward * -15;		// for approx. FOV between 100 and 110
		else 
			self.origin = self.owner.origin + v_up * 7 + v_forward * -10;		// for approx. FOV < 100

		self.angles = self.owner.angles;
		self.angles_x = 15;		// legs must not change x-angles together with player큦 view
		if (autocvar_player_legs_model == 1)
			setmodel(self, "progs/player_legs1.mdl");
		else
			setmodel(self, "progs/player_legs2.mdl");
		setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
	}
	else	
		setmodel(self, "");

	self.solid = SOLID_NOT;
	self.frame = self.owner.frame;

	self.think = add_Quake3_quad_effect_1st_legs_think;
	self.nextthink = time;
};


void(entity e) add_Quake3_quad_effect_1st_legs =
{
	local entity shaderrrr;
	shaderrrr = spawn();
	shaderrrr.skin = 1;	
	shaderrrr.owner = e;
	shaderrrr.alpha = 0.5;
	shaderrrr.colormod = '0 0 0.5'; 
	shaderrrr.think = add_Quake3_quad_effect_1st_legs_think;
	shaderrrr.nextthink = time;
};







/////// Lightning gun new death animation for monsters:
var float autocvar_lightninggun_death_animation = 1;	// set cvar 'lightninggun_death_animation' default to 1.  "0" = disabled. "1" = monsters which are killed with lighnting gun, will have a new death animation: Coaled to death. They remain in a pain state until they are shot (or automatically after a set time), they will fall apart.
							// "2" = monsters which are killed with lighnting gun, will have a new death animation: They remain in a pain state and they fade away (in an adjustable time).
							// cvar used all monster큦 .qc files

/////// Lifetime of coaled monsters (lightning gun):
var float autocvar_coaled_monster_lifetime = 4;		// set cvar 'coaled_monster_lifetime' default to 4 seconds.  Sets the lifetime of coaled monsters (when killed with lightning gun value "1") before they fall apart (in seconds).
							// cvar used inside world.qc

/////// Fadetime for alternative coaled monsters (lightning gun):
var float autocvar_coaled_monster_fadetime = 2;		// set cvar 'coaled_monster_fadetime' default to 2 seconds.  Sets the fadetime of coaled monsters (when killed with lightning gun value "2") in seconds.
							// var used in custom_effects.qc
 
////////////////////////////////////////////////////////////////////////
//   Lightning gun new death animation for monsters  (Alternative 2)
//   (Alternative 1 is handled in world.qc !)
////////////////////////////////////////////////////////////////////////

void() DropBackpack;

void()	lightninggun_death_fade1 =
{
local float countdown;
self.magiccounter = self.magiccounter - 1;
countdown = 1/(autocvar_coaled_monster_fadetime * 10);
if (self.magiccounter >= 0)
	{
	self.alpha = self.alpha - countdown; 
	self.think = lightninggun_death_fade1;
	self.nextthink = time + 0.1;
	}
else
	{
//	if (self.backpack_thrower)	// alternative DropBackpack when monster has completely faded out
//		DropBackpack();
	self.think = SUB_Remove;	
	self.nextthink = time;
	}
};

void()	lightninggun_death_fade =
{
self.solid = SOLID_NOT;
self.colormod = '0.25 0.22 0.22';	// skins gets darker (looks burned)
self.alpha = 1;
self.magiccounter = autocvar_coaled_monster_fadetime * 10;
if (self.backpack_thrower)
	DropBackpack();
lightninggun_death_fade1();
};






/////// Burning death animation for monsters:
var float autocvar_burning_monsters_death_animation = 30;	// set cvar 'burning_monsters_death_animation' default to 30.   "0" = disabled.   Monsters will catch fire (get inflamed) when killed with explosive weapons (rocket and grenade launcher).  A new after-death animation: Burned to death. They run around in panic. Burning and screaming.   Sets the chance in percent for this feature ("100": always)
								// cvar used in all monster큦 .qc files
var float autocvar_burning_monsters_death_animation_time = 4;	// set cvar 'burning_monsters_death_animation_time' default to 4 seconds.    Sets the time in seconds in which the monsters run around in panic (burning and screaming) before they finally die. (when killed with explosive weapons and enabled cvar: 'burning_monsters_death_animation')
								// cvar used in all monster큦 .qc files
var float autocvar_burning_monsters_fade_animation_time = 4;	// set cvar 'burning_monsters_fade_animation_time' default to 4 seconds.     Sets the burn out time when burning monsters finally collapse.
								// cvar used inside custom_effects.qc 


void() corpse_burn_out =	// this code makes the corpse fade away while burning !  
{
local float countdown;
self.magiccounter = self.magiccounter - 1;
countdown = 1/(autocvar_burning_monsters_fade_animation_time * 12);

if (self.magiccounter >= 0)
	{
	self.alpha = self.alpha - countdown; 
	self.think = corpse_burn_out;
	self.nextthink = time + 0.1;
	}
else
	{
	sound (self, CHAN_WEAPON, "misc/null.wav", 1, ATTN_NORM);
	self.think = SUB_Remove;	
	self.nextthink = time;
	}
};


void() inflamed_die =
{
	local vector check;
	check = (self.origin - ((VEC_HULL2_MIN + VEC_HULL2_MAX) * 0.5)) + '0 0 1';
	if ((pointcontents(check) != CONTENT_WATER)&&(pointcontents(check) != CONTENT_SLIME))	// burning monster is NOT in water/slime
	{
		self.traileffectnum = particleeffectnum("corpse_burn");
		self.colormod = '0.40 0.25 0.25';	// skins gets darker (looks burned)
		sound (self, CHAN_WEAPON, "zombie/corpse_fire.wav", 1, ATTN_NORM); 		// play fire loop sound
		self.alpha = 1;
		self.magiccounter = autocvar_burning_monsters_fade_animation_time * 10;	
		self.think = corpse_burn_out;
		self.nextthink = time;
		return;
	}
};





/////// Enforcer큦 shield code:
var float autocvar_enforcer_shield_chance = 10;		// set cvar 'enforcer_shield_chance' default to 10  (= 10%).  Set chance of spawning powershield around enforcer, that blocks projectiles  (0= never(disable this feature)   100= always). Choose any value you want between 0 and 100   
							// cvar used inside combat.qc
var float autocvar_enforcer_shield_lifetime = 2;	// set cvar 'enforcer_shield_lifetime' default to 2.   Set lifetime in seconds for powershield around enforcer each time it spawns.  Choose any value you want  > 0   
							// cvar used inside combat.qc and custom_effects.qc

void () protective_shield_entity_think =
{
	if (self.owner.health <= 0)
	{
		remove (self);
		return;
	}

	if (autocvar_enforcer_shield_chance == 0)	// to make it possible to also disable feature while playing (without map restart)
	{
		remove (self);
		return;
	}
	
	self.scale = 11;

	if (self.owner.dodge_finished > time)
	{
		self.alpha = 1;					// show shield
		self.protective_shield_spawned = 1;
		self.owner.takedamage = DAMAGE_YES; 		// grenades bounces off of Enforcer
	}
	else
	{
		self.alpha = -1;				// hide shield
		self.protective_shield_spawned = 0;
		self.owner.takedamage = DAMAGE_AIM; 		// regular behaviour
	}

	if ((self.owner.enemy != world) && (self.protective_shield_spawned == 0))	// spawn shield randomly when hunting an enemy (even when not got shot)
	{
		if (random() < 0.0007)	// 0.0009
		{
			self.owner.dodge_finished = time + autocvar_enforcer_shield_lifetime + random();
		}
	}
	
	makevectors (self.angles);	
	setorigin (self, '0 0 -68' + v_forward * -7);

	self.think = protective_shield_entity_think;
	self.nextthink = time + 0.01;
};





/////// Demon jump motion blur:
var float autocvar_demon_jump_motion_blur = 2;		// set cvar 'demon_jump_motion_blur' default to 2    "0"= disabled      Values between "1" and "10" = When demon jumps, his body has an "motion blur" / "tail" effect.  The higher the value, the more subtle/transparent the effect will be. 
							// cvar used inside demon.qc

void () motion_blur_entity_think =
{
	if (self.owner.tail_visible)
		self.alpha = (0.6 - (0.6 * (autocvar_demon_jump_motion_blur / 10)));		// reduce default alpha value in 10% steps via cvar
	else
		self.alpha = -1;
	
	self.frame = self.owner.frame;
	self.scale = 1.07;

	makevectors (self.angles);	
	setorigin (self, '0 0 0' + v_forward * -5);

	self.think = motion_blur_entity_think;
	self.nextthink = time + 0.01;
};


void () motion_blur_entity1_think =
{
	if (self.owner.tail_visible)
		self.alpha = (0.5 - (0.5 * (autocvar_demon_jump_motion_blur / 10)));		// reduce default alpha value in 10% steps via cvar
	else
		self.alpha = -1;

	self.frame = self.owner.frame;
	self.scale = 1.14;

	makevectors (self.angles);	
	setorigin (self, '0 0 0' + v_forward * -10);

	self.think = motion_blur_entity1_think;
	self.nextthink = time + 0.01;
};


void () motion_blur_entity2_think =
{
	if (self.owner.tail_visible)
		self.alpha = (0.4 - (0.4 * (autocvar_demon_jump_motion_blur / 10)));		// reduce default alpha value in 10% steps via cvar
	else
		self.alpha = -1;

	self.frame = self.owner.frame;
	self.scale = 1.2;

	makevectors (self.angles);	
	setorigin (self, '0 0 0' + v_forward * -15);

	self.think = motion_blur_entity2_think;
	self.nextthink = time + 0.01;
};


void () motion_blur_entity3_think =
{
	if (self.owner.tail_visible)
		self.alpha = (0.3 - (0.3 * (autocvar_demon_jump_motion_blur / 10)));		// reduce default alpha value in 10% steps via cvar
	else
		self.alpha = -1;

	self.frame = self.owner.frame;
	self.scale = 1.27;

	makevectors (self.angles);	
	setorigin (self, '0 0 0' + v_forward * -20);

	self.think = motion_blur_entity3_think;
	self.nextthink = time + 0.01;
};


void () motion_blur_entity4_think =
{
	if (self.owner.tail_visible)
		self.alpha = (0.2 - (0.2 * (autocvar_demon_jump_motion_blur / 10)));		// reduce default alpha value in 10% steps via cvar
	else
		self.alpha = -1;

	self.frame = self.owner.frame;
	self.scale = 1.33;

	makevectors (self.angles);	
	setorigin (self, '0 0 0' + v_forward * -25);

	self.think = motion_blur_entity4_think;
	self.nextthink = time + 0.01;
};


void () motion_blur_entity5_think =
{
	if (self.owner.tail_visible)
		self.alpha = (0.1 - (0.1 * (autocvar_demon_jump_motion_blur / 10)));		// reduce default alpha value in 10% steps via cvar
	else
		self.alpha = -1;

	self.frame = self.owner.frame;
	self.scale = 1.4;

	makevectors (self.angles);	
	setorigin (self, '0 0 0' + v_forward * -30);

	self.think = motion_blur_entity5_think;
	self.nextthink = time + 0.01;
};






/////////// Pain skins for all monsters:
var float autocvar_painskin_transparency = 0.3;		// set cvar 'painskin_transparency' default to 0.3    "0"= disabled     Set transparency for painskins here. Values between "0" (not visible) and "1" (fully visible) are possible. Be aware that the blood color may change by changing transparency (depending on monster skin).
							// cvar used inside custom_effects.qc and all monster .qc큦

void () pain_skin_entity_think =			// for living monsters
{
	if ((autocvar_painskin_transparency == 0) || (self.owner.delete_painskin == 1))
	{
		remove (self);
		return;
	}

	self.frame = self.owner.frame;
	self.alpha = autocvar_painskin_transparency;

	if (self.owner.health < self.owner.health_initial)
	{
		if (self.owner.health < (0.5 * self.owner.health_initial))
		{
			if (self.owner.painskin_helper == 2)		// "2" is regular spider (it has 8 used skins)
				self.skin = 9;
			else if (self.owner.painskin_helper == 3)	// "3" is yakman (he has 5 used skins)
			{
				self.skin = 6;
				if ((self.owner.skin == 1)||(self.owner.skin == 2))
					self.alpha = autocvar_painskin_transparency - 0.1;	// on dark skins painskin is stronger
			}
			else if (self.owner.painskin_helper == 4)	// "4" is necromancer (he has 3 used skins)
			{
				self.skin = 4;
				self.alpha = autocvar_painskin_transparency - 0.1;	// on dark skins painskin is stronger
			}
			else
				self.skin = 3;
		}
		else
		{
			if (self.owner.painskin_helper == 2)		// "2" is regular spider (it has 8 used skins)
				self.skin = 8;
			else if (self.owner.painskin_helper == 3)	// "3" is yakman (he has 5 used skins)
			{
				self.skin = 5;
				if ((self.owner.skin == 1)||(self.owner.skin == 2))
					self.alpha = autocvar_painskin_transparency - 0.1;	// on dark skins painskin is stronger
			}
			else if (self.owner.painskin_helper == 4)	// "4" is necromancer (he has 3 used skins)
			{
				self.skin = 3;
				self.alpha = autocvar_painskin_transparency - 0.1;	// on dark skins painskin is stronger
			}
			else
				self.skin = 2;
		}
	}
	
	if (self.owner.painskin_helper == 1)		// for zombie painskins (zombie큦 health never drops below 60 as long as he is not dead)
		self.skin = 4;				// zombie uses already skins 2 and 3 for Trinity effect

	self.think = pain_skin_entity_think;
	self.nextthink = time;
};



void () pain_skin_entity_corpse_think =		// for corpses
{
	if ((autocvar_painskin_transparency == 0) || (self.owner.delete_painskin == 1))
	{
		remove (self);
		return;
	}

	self.frame = self.owner.frame;
	self.alpha = autocvar_painskin_transparency;

	if (self.owner.painskin_helper == 1)		// for zombie painskins (zombie큦 health never drops below 60 as long as he is not dead)
		self.skin = 4;				// zombie uses already skins 2 and 3 for Trinity effect
	else if (self.owner.painskin_helper == 2)	// "2" is regular spider (it has 8 used skins)
		self.skin = 9;	
	else if (self.owner.painskin_helper == 3)	// "3" is yakman (he has 5 used skins)
	{
		self.skin = 6;
		if ((self.owner.skin == 1)||(self.owner.skin == 2))
			self.alpha = autocvar_painskin_transparency - 0.1;	// on dark skins painskin is stronger
	}
	else
		self.skin = 3;				// all other monsters

	self.think = pain_skin_entity_corpse_think;
	self.nextthink = time;
};







/////////// Personal player teleporter:
var float autocvar_personal_player_teleporter_guiding = 0;		// set cvar 'personal_player_teleporter_guiding' default to 0    "0"= disabled (it will always run straight forward)     "1"= enabled (You can guide it by looking left and right. It will run left and right as you look)
									// cvar used inside custom_effects.qc
var float autocvar_personal_player_teleporter_transparency = 0.4;	// set cvar 'personal_player_teleporter_transparency' default to 0.4    Set transparency of personal_player_teleporter.  Valid values: Between 0.1 and 1
   									// cvar used inside custom_effects.qc


void() player_teleporter_entity_think =
{
local vector front_pos, vec;

	if (self.owner.health < 1)	
	{
		self.owner.personal_teleporter_spawned = 0; 	// reset
		self.owner.personal_teleporter_start_beam = 0;	// reset
		remove (self);
		return;
	}

	if (self.maxlifetime < time)
	{
		self.owner.personal_teleporter_spawned = 0; 	// reset
		self.owner.personal_teleporter_start_beam = 0;	// reset
		remove (self);
		return;
	}

	self.frame = self.frame + 1;
	if (self.owner.weapon == IT_AXE)
	{
		if (self.frame >= 6)			
			self.frame = 0;
	}
	else
	{
		if (self.frame >= 12)			
			self.frame = 6;
	}
			
	if (self.owner.personal_teleporter_start_beam)
	{
		self.owner.origin = self.origin + '0 0 1';
		self.owner.personal_teleporter_spawned = 0; 	// reset
		self.owner.personal_teleporter_start_beam = 0;	// reset
		if (random() < 0.5)
			sound (self.owner, CHAN_AUTO, "misc/r_tele1.wav", 1, ATTN_NORM);
		else
			sound (self.owner, CHAN_AUTO, "misc/r_tele2.wav", 1, ATTN_NORM);
		view_zoom_out = 1;
		self.owner.viewzoom = 0.01;
		remove (self);
		return;
	}

	self.alpha = autocvar_personal_player_teleporter_transparency;
	
//////////////	Below code ONLY works with MOVETYPE_FLY.   (MOVETYPE_STEP and  walkmove  brought issues). 

	if (autocvar_personal_player_teleporter_guiding)
		makevectors (self.owner.v_angle);	// if it should be controllable	by player (steer it by looking left and right)
	else
		makevectors (self.angles);		// if it should be NOT controllable	
	vec = normalize (v_forward);			
	self.velocity = vec * 250;			// adjust speed	
	self.velocity_z = 0;		
	self.angles = vectoangles (self.velocity);
	self.angles_x = 0;				// make him always look in walking direction

	traceline (self.origin, self.origin - '0 0 100', TRUE, self);	// keep him on ground when walking setps downwards
	if (self.origin_z - trace_endpos_z > 30)			// 30
		self.origin = self.origin - '0 0 15';			// 15

	makevectors (self.angles);					// make him walk up stairs and easy slopes. Hard slopes dont work (like in e1m1).  Code is really POOR, I know :)
	front_pos = self.origin + v_forward * 45;			// 40 35 
	traceline (front_pos, front_pos - '0 0 100', TRUE, self);
	if (self.origin_z - trace_endpos_z < 22)			// 22 20 
		self.origin = self.origin + '0 0 20';			// 20
	
//	pointparticles(particleeffectnum("double_shotgun_muzzleflash"), front_pos_near, '0 0 0', 10);	// for development only
//	pointparticles(particleeffectnum("double_shotgun_muzzleflash"), trace_endpos, '0 0 0', 10);	// for development only

	self.nextthink = time + 0.1;		
	self.think = player_teleporter_entity_think;	
};



void (vector spawn_pos, vector spawn_vel) launch_player_teleporter_entity =
{
local entity player_teleporter_entity;

	player_teleporter_entity = spawn ();
	
	player_teleporter_entity.owner = self;
	player_teleporter_entity.enemy = self;

	player_teleporter_entity.solid = SOLID_SLIDEBOX;
	player_teleporter_entity.movetype = MOVETYPE_FLY;		// MOVETYPE_STEP  brought issues

	player_teleporter_entity.velocity = spawn_vel * 250;
	player_teleporter_entity.angles = vectoangles (player_teleporter_entity.velocity);
	player_teleporter_entity.angles_x = 0;				// make him always look straight

	if (self.owner.weapon == IT_AXE)
		player_teleporter_entity.frame = 0;			// start frame when holding axe
	else		
		player_teleporter_entity.frame = 6;			// start frame when holding gun
	player_teleporter_entity.alpha = autocvar_personal_player_teleporter_transparency;
	player_teleporter_entity.skin = 2;	
	player_teleporter_entity.colormod = '0.9 0.5 0.2'; 

	player_teleporter_entity.classname = "player_teleporter_entity";
	player_teleporter_entity.think = player_teleporter_entity_think;	
	player_teleporter_entity.nextthink = time;	
	
	player_teleporter_entity.maxlifetime = time + 5;
	player_teleporter_entity.health = 1;
	
	setmodel (player_teleporter_entity, "progs/player.mdl");		
	setsize (player_teleporter_entity, VEC_HULL_MIN, VEC_HULL_MAX);

	setorigin (player_teleporter_entity, spawn_pos);
};



void() player_teleport =
{
	local vector org, vec;

	makevectors (self.v_angle);
	org = self.origin + '0 0 1';
	
	vec = normalize (v_forward);
	vec_z = vec_z * -1;

	sound (self, CHAN_AUTO, "player/personal_player_teleport.wav", 1, ATTN_NORM);
	self.personal_teleporter_spawned = 1;		// flag that we already spawned one

	launch_player_teleporter_entity (org, vec); 
};






///////////////////////////////////////////////////////////////////////////
//   custom particle effects and sound implementation   into existing maps 
///////////////////////////////////////////////////////////////////////////

// First 2 paragraphs adds custom particle effects via .ent file + effectinfo.txt into a map
// Third paragraph adds custom sound via .ent file into a map

// Example (custom particle effects) : 
// put into start.ent:
// {
// "classname" "info_notnull"
// "origin" "864 985 -104"
// "nextthink" "0.1"
// "think" "seven_think"
// "model" "testhardentrance"
// }
//
// put into start_effectinfo.txt (in your "maps" folder):
// effect testhardentrance
// countabsolute 0.1
// type smoke
// color 0x6f0f00 0xe3974f  
// tex 48 55
// size 2 4
// alpha 50 80 7
// sizeincrease 3.2
// originoffset 0 10 0
// originjitter 160 200 0
// velocityjitter 4 5 2
// velocitymultiplier 0.01
// gravity -0.004
// bounce 1
//

	var float autocvar_ent = 1;
	var float autocvar_ent_00 = 1;
	var float autocvar_ent_01 = 0;
	var float autocvar_ent_02 = 0; 
	var float autocvar_ent_03 = 0;
	var float autocvar_ent_04 = 0;
	var float autocvar_ent_05 = 0;
	var float autocvar_ent_06 = 0;
	var float autocvar_ent_07 = 0; 
	var float autocvar_ent_08 = 0;
	var float autocvar_ent_09 = 0;
	
	
// cvar to change between map effect handling for different Darkplaces builds. Since build 20130301 the engine behaviour was changed
var float autocvar_darkplaces_build = 1;	// set cvar 'darkplaces_build' default to 1.  0= for DP builds before 20130301   1= for DP builds since 20130301


void() seven_think_old =
{
	self.nextthink = time + 0.00065;
	pointparticles(particleeffectnum(self.model), self.origin, '0 0 0', 1); 
};


void() seven_think1 =
{
	pointparticles(particleeffectnum(self.model), self.origin, '0 0 0', 1); 
	self.nextthink = time + 0.00065;
};

void() seven_think2 =
{
	pointparticles(particleeffectnum(self.model), self.origin, '0 0 0', 1); 
	self.nextthink = time + 0.00065;
};

void() seven_think3 =
{
	pointparticles(particleeffectnum(self.model), self.origin, '0 0 0', 1); 
	self.nextthink = time + 0.00065;
};

void() seven_think4 =
{
	pointparticles(particleeffectnum(self.model), self.origin, '0 0 0', 1); 
	self.nextthink = time + 0.00065;
};

void() seven_think5 =
{
	pointparticles(particleeffectnum(self.model), self.origin, '0 0 0', 1); 
	self.nextthink = time + 0.00065;
};

void() seven_think6 =
{
	pointparticles(particleeffectnum(self.model), self.origin, '0 0 0', 1); 
	self.nextthink = time + 0.00065;
};

void() seven_think7 =
{
	pointparticles(particleeffectnum(self.model), self.origin, '0 0 0', 1); 
	self.nextthink = time + 0.00065;
};

void() seven_think8 =
{
	pointparticles(particleeffectnum(self.model), self.origin, '0 0 0', 1); 
	self.nextthink = time + 0.00065;
};

void() seven_think9 =
{
	pointparticles(particleeffectnum(self.model), self.origin, '0 0 0', 1); 
	self.nextthink = time + 0.00065;
};

void() seven_think10 =
{
	pointparticles(particleeffectnum(self.model), self.origin, '0 0 0', 1); 
	self.nextthink = time + 0.00065;
};

void() seven_think11 =
{
	pointparticles(particleeffectnum(self.model), self.origin, '0 0 0', 1); 
	self.nextthink = time + 0.00065;
};

void() seven_think12 =
{
	pointparticles(particleeffectnum(self.model), self.origin, '0 0 0', 1); 
	self.nextthink = time + 0.00065;
};

void() seven_think13 =
{
	pointparticles(particleeffectnum(self.model), self.origin, '0 0 0', 1); 
	self.nextthink = time + 0.00065;
};

void() seven_think14 =
{
	pointparticles(particleeffectnum(self.model), self.origin, '0 0 0', 1); 
	self.nextthink = time + 0.00065;
};

void() seven_think15 =
{
	pointparticles(particleeffectnum(self.model), self.origin, '0 0 0', 1); 
	self.nextthink = time + 0.00065;
};

void() seven_think16 =
{
	pointparticles(particleeffectnum(self.model), self.origin, '0 0 0', 1); 
	self.nextthink = time + 0.00065;
};


void() seven_think_new =		// fix for DP build 20130301 and newer
{
	seven_think1 ();
	seven_think2 ();
	seven_think3 ();
	seven_think4 ();
	seven_think5 ();
	seven_think6 ();
	seven_think7 ();
	seven_think8 ();
	seven_think9 ();
	seven_think10 ();
	seven_think11 ();
	seven_think12 ();
	seven_think13 ();
	seven_think14 ();
	seven_think15 ();
	seven_think16 ();
};


/////// Enable/Disable custom particle map effects
var float autocvar_cl_particles_custom_effects = 1;	// set cvar 'cl_particles_custom_effects' default to 1.     0= disable custom particle effects in maps     1= enable custom particle effects in maps

void() seven_think =
{
if (!autocvar_cl_particles_custom_effects)
	return;
if (autocvar_darkplaces_build)
	self.think = seven_think_new;	// use code for DP builds 20130301 and newer
else
	self.think = seven_think_old;	// use code for DP builds before 20130301
self.nextthink = time + 0.01;
};


void() seven_init =
{
	
	if (((autocvar_ent_00 == 1) && (self.cnt == 0)) || ((autocvar_ent_01 == 1) && (self.cnt == 1)) || ((autocvar_ent_02 == 1) && (self.cnt == 2)) || ((autocvar_ent_03 == 1) && (self.cnt == 3))
	 || ((autocvar_ent_04 == 1) && (self.cnt == 4)) || ((autocvar_ent_05 == 1) && (self.cnt == 5)) || ((autocvar_ent_06 == 1) && (self.cnt == 6)) || ((autocvar_ent_07 == 1) && (self.cnt == 7))
	 || ((autocvar_ent_08 == 1) && (self.cnt == 8)) || ((autocvar_ent_09 == 1) && (self.cnt == 9)))
	{
	self.think = seven_think;
	self.nextthink = time + 0.01;
	}
	else remove(self);	
};




////////////////////////////////////////////////
////////////////////////////////////////////////
//    Lava eruptions 
////////////////////////////////////////////////

.float Xsmall;		// for lava pool corner with smallest X-coordinate (negative values are smaller than positive)
.float Ysmall;		// for lava pool corner with smallest Y-coordinate (negative values are smaller than positive)
.float Xbig;		// for lava pool corner with biggest X-coordinate (negative values are smaller than positive)
.float Ybig;		// for lava pool corner with biggest Y-coordinate (negative values are smaller than positive)
.float Zheight;		// for z-coordinate of lava pool
.float variation;	// sets which eruption variations to use: "1"=small eruption only "2"=medium eruption only "3"=large eruption only
			// "4"=random small or medium eruption "5"=all 3 eruptions randomly


void () eruption_touch =
{
if (other.classname != "player")
	return;
	if (other.health)
	{
		T_Damage (other, self, self, 10);	// does 10 damage when lava eruption is touched
		self.touch = SUB_Null;			// to prevent damage overflow
		remove(self);
	}
};


void () spawn_lava_eruption =
{
local float dX, dY, Xparticle, Yparticle, Zparticle, zufall;
local vector eruption;

	dX = self.Xbig - self.Xsmall;
	dY = self.Ybig - self.Ysmall;
	Xparticle = self.Xsmall + (random () * dX);
	Yparticle = self.Ysmall + (random () * dY);
	Zparticle = self.Zheight;

	eruption_x = Xparticle;
	eruption_y = Yparticle;
	eruption_z = Zparticle;

	local entity eruptiondamage;		// area that does damage when touching the lava eruption
	eruptiondamage = spawn();		// size and lifetime of area is depending on size of lava eruption
	eruptiondamage.origin = eruption;
	eruptiondamage.velocity = '0 0 0';
	eruptiondamage.movetype = MOVETYPE_NONE;
	eruptiondamage.solid = SOLID_TRIGGER;
	eruptiondamage.touch = eruption_touch;
	eruptiondamage.think = SUB_Remove;

	if (!self.variation)
		self.variation = 5;
	if (self.variation == 1)
	{
		pointparticles (particleeffectnum ("lava_eruption_small"), eruption, '0 0 0 ', 1);
		pointsound (eruption, "ambience/lava_eruption_small.wav", 1, ATTN_NORM);
		setsize (eruptiondamage, '-15 -15 0', '15 15 45');
		eruptiondamage.nextthink = time + 1;
	}
	else if (self.variation == 2)
	{
		pointparticles (particleeffectnum ("lava_eruption_medium"), eruption, '0 0 0 ', 1);
		pointsound (eruption, "ambience/lava_eruption_medium.wav", 1, ATTN_NORM);
		setsize (eruptiondamage, '-22 -22 0', '22 22 75');
		eruptiondamage.nextthink = time + 1.3;
	}
	else if (self.variation == 3)
	{
		pointparticles (particleeffectnum ("lava_eruption_large"), eruption, '0 0 0 ', 1);
		pointsound (eruption, "ambience/lava_eruption_large.wav", 1, ATTN_NORM);
		setsize (eruptiondamage, '-30 -30 0', '30 30 115');
		eruptiondamage.nextthink = time + 1.6;
	}
	else if (self.variation == 4)
	{
		zufall = random();
		if (zufall < 0.5)
		{
			pointparticles (particleeffectnum ("lava_eruption_small"), eruption, '0 0 0 ', 1);
			pointsound (eruption, "ambience/lava_eruption_small.wav", 1, ATTN_NORM);
			setsize (eruptiondamage, '-15 -15 0', '15 15 45');
			eruptiondamage.nextthink = time + 1;
		}
		else
		{
			pointparticles (particleeffectnum ("lava_eruption_medium"), eruption, '0 0 0 ', 1);
			pointsound (eruption, "ambience/lava_eruption_medium.wav", 1, ATTN_NORM);
			setsize (eruptiondamage, '-22 -22 0', '22 22 75');
			eruptiondamage.nextthink = time + 1.3;
		}
	}
	else 
	{
		zufall = random();
		if (zufall < 0.33)
		{
			pointparticles (particleeffectnum ("lava_eruption_small"), eruption, '0 0 0 ', 1);
			pointsound (eruption, "ambience/lava_eruption_small.wav", 1, ATTN_NORM);
			setsize (eruptiondamage, '-15 -15 0', '15 15 45');
			eruptiondamage.nextthink = time + 1;
		}
		else if (zufall > 0.66)
		{
			pointparticles (particleeffectnum ("lava_eruption_medium"), eruption, '0 0 0 ', 1);
			pointsound (eruption, "ambience/lava_eruption_medium.wav", 1, ATTN_NORM);
			setsize (eruptiondamage, '-22 -22 0', '22 22 75');
			eruptiondamage.nextthink = time + 1.3;
		}
		else
		{
			pointparticles (particleeffectnum ("lava_eruption_large"), eruption, '0 0 0 ', 1);
			pointsound (eruption, "ambience/lava_eruption_large.wav", 1, ATTN_NORM);
			setsize (eruptiondamage, '-30 -30 0', '30 30 115');
			eruptiondamage.nextthink = time + 1.6;
		}
	}
};


void() lava_think =
{
	precache_sound ("ambience/lava_eruption_small.wav");
	precache_sound ("ambience/lava_eruption_medium.wav");
	precache_sound ("ambience/lava_eruption_large.wav");
	self.nextthink = time + self.count + random()*3;  	// change "3" to any value for additional fixed random time gap between eruptions
	spawn_lava_eruption ();
};


void() lava_init =
{
if (((autocvar_ent_00 == 1) && (self.cnt == 0)) || ((autocvar_ent_01 == 1) && (self.cnt == 1)) || ((autocvar_ent_02 == 1) && (self.cnt == 2)) || ((autocvar_ent_03 == 1) && (self.cnt == 3))
	 || ((autocvar_ent_04 == 1) && (self.cnt == 4)) || ((autocvar_ent_05 == 1) && (self.cnt == 5)) || ((autocvar_ent_06 == 1) && (self.cnt == 6)) || ((autocvar_ent_07 == 1) && (self.cnt == 7))
	 || ((autocvar_ent_08 == 1) && (self.cnt == 8)) || ((autocvar_ent_09 == 1) && (self.cnt == 9)))
{
	self.think = lava_think;
	self.nextthink = time + 0.01;
}
else remove(self);
};


void() func_lava =
{
	self.think = lava_think;
	self.nextthink = time + 0.01;
};

// Example for lava eruptions in E1M7: 
// put into e1m7.ent:
// {
//"classname" "info_notnull"
//"Xsmall" "80"
//"Ysmall" "-180"
//"Xbig" "750"
//"Ybig" "310"
//"Zheight" "-30"
//"nextthink" "0.1"
//"think" "lava_think"
//"count" "0.5"
//"variation" "5"
//}
//
// Put the particle effect into your effectinfo.txt
// (see attached effectinfo.txt file inside 'small mod compilation' for this lava eruption effect)
//




////////////////////////////////////////////////
////////////////////////////////////////////////
//    custom sound 
////////////////////////////////////////////////


void() callsound =
{
	pointsound (self.origin, self.model, self.alpha, ATTN_NORM);
//	pointsound (vector origin, string sample, float volume, float attenuation);
};


void() sound_think =
{
	precache_sound (self.model);
	self.nextthink = time + self.count;
	callsound ();
};


void() sound_init =
{
if (((autocvar_ent_00 == 1) && (self.cnt == 0)) || ((autocvar_ent_01 == 1) && (self.cnt == 1)) || ((autocvar_ent_02 == 1) && (self.cnt == 2)) || ((autocvar_ent_03 == 1) && (self.cnt == 3))
	 || ((autocvar_ent_04 == 1) && (self.cnt == 4)) || ((autocvar_ent_05 == 1) && (self.cnt == 5)) || ((autocvar_ent_06 == 1) && (self.cnt == 6)) || ((autocvar_ent_07 == 1) && (self.cnt == 7))
	 || ((autocvar_ent_08 == 1) && (self.cnt == 8)) || ((autocvar_ent_09 == 1) && (self.cnt == 9)))
{
	self.think = sound_think;
	self.nextthink = time + 0.01;
}
else remove(self);
};


void() func_sound =
{
	self.think = sound_think;
	self.nextthink = time + 0.01;
};

// Example (custom sound) : 
// put into e1m1.ent:
// {
// "classname" "info_notnull"
// "origin" "700 850 -280"	// represents coordination
// "nextthink" "0.1"
// "alpha" "0.6"		// represents volume (1= max,  0= min)
// "count" "7"			// represents time loop (in seconds)
// "think" "sound_think"
// "model" "sound/ambience/wateramb.wav"
// }
// 
// Add the soundfile  wateramb.wav (which is 7 seconds long) into your "sound/ambience" subfolder
// It will then be spawned in the secret water passage of the map.

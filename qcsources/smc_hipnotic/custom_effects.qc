
/////////////// These are several auto_cvar default settings, that are used in many other .qc files  (with a short summary what they are for and where they are used)
/////////////// Later on, you will find code for: "custom particle effects and sound implementation"   into existing maps 



/////// Flashlight
var float autocvar_flashlight_type = 2;				// choose between 2 different flashlight types ("1" regular and "2" cubemap style)
var float autocvar_flashlight_radius = 170;			// adjust flashlights light radius for flashlight type 1 here
var float autocvar_flashlight_cubemap_radius = 700;		// adjust flashlights light radius for flashlight type 2 here
var float autocvar_flashlight_color_brightness_red = 1.8;	// adjust flashlights light intensity (color red)
var float autocvar_flashlight_color_brightness_green = 1.7;	// adjust flashlights light intensity (color green)	
var float autocvar_flashlight_color_brightness_blue = 1.7;	// adjust flashlights light intensity (color blue)	



/////// Random angled ammo + health (if not spinning custom health models) pickups:
var float autocvar_ammo_health_boxes_angle_randomness = 20;	// set cvar 'ammo_health_boxes_angle_randomness' default to 20 (= 20°).   "0"= disable this feature    Values "1" or higher = place all ammo and health (if not spinning custom health models) boxes with random angles on ground. Angle variies between +/- value.   ATTENTION: Do not go much higher than "20" (I would say "25" is maximum) or the boxes might leak into nearby walls. That is not a technical problem, only a visual problem.
								// cvar used inside items.qc



////////  Player is surrounded by flying dust cvars
var float autocvar_flying_dust = 1;		// set cvar 'flying_dust' default to 1.   ATTENTION: Only in single player or coop.   "0"= disabled     "1"= enable flying dust particles in non-base Quake maps    "2"= enable flying dust particles in all Quake maps
						// cvar used inside client.qc
var float autocvar_flying_dust_quantity = 1;	// set cvar 'flying_dust_quantity' default to 1.    "0"= disabled    "1"= standard quantity     "2"= double quantity    "3"= triple quantity   and so on ...
						// cvar used inside custom_effects.qc
var float autocvar_flying_dust_type = 1;	// set cvar 'flying_dust_type' default to 1.     "1"= dust     "2"= ember    "3"= snow   "4"= rain
						// cvar used inside custom_effects.qc



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


/////// Afrits, Hellknights, Warlords projectiles and lava pools can ignite/inflame the player
var float autocvar_fire_projectiles_and_lava_inflame_time = 15;		// set cvar 'fire_projectiles_inflame_time' default to 15.     0= disable the feature completely     Set the maximum burning/suffering time for the player in seconds.   Note: When picking up medikits or jump into water, the burning will be cured at once !
									// cvar used inside weapons.qc
var float autocvar_afrit_projectiles_inflame_chance = 25;		// set cvar 'afrit_projectiles_inflame_chance' default to 25.    Set the chance of getting inflamed by Afrits projectiles in percent.    10= 10% chance to get inflamed     50= 50% chance to get inflamed    100= Every Afrits projectile will inflame the player
									// cvar used inside afrit.qc
var float autocvar_hellknight_projectiles_inflame_chance = 25;		// set cvar 'hellknight_projectiles_inflame_chance' default to 25.    Set the chance of getting inflamed by Hellknights projectiles in percent.    10= 10% chance to get inflamed     50= 50% chance to get inflamed    100= Every hellknights projectile will inflame the player
									// cvar used inside weapons.qc
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
var float autocvar_wizard_projectiles_and_slime_poison_time = 20;	// set cvar 'wizard_projectiles_and_slime_poison_time' default to 20.    0= disable this feature completely      Set the maximum poison suffering time for the player in seconds.   Note: When picking up medikits, the poison will be cured at once !
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
var float autocvar_monster_random_skin_color_alteration = 2;	// set cvar 'monster_random_skin_color_alteration' default to 0.    0= disable this feature for all monsters completely     1= use only a slight texture color alteration     2= use a moderate texture color alteration    3= use a strong texture color alteration
							// cvar used inside demon.qc
var float autocvar_demon_random_skin_colors = 1;	// set cvar 'demon_random_skin_colors' default to 1.    0= do not modify/edit this monster types skin textures     1= modify/edit this monster types skin texture randomly (for higher variation in-game)
							// cvar used inside demon.qc
var float autocvar_dog_random_skin_colors = 1;		// set cvar 'dog_random_skin_colors' default to 1.    0= do not modify/edit this monster types skin textures     1= modify/edit this monster types skin texture randomly (for higher variation in-game)
							// cvar used inside dog.qc
var float autocvar_enforcer_random_skin_colors = 1;	// set cvar 'enforcer_random_skin_colors' default to 1.    0= do not modify/edit this monster types skin textures     1= modify/edit this monster types skin texture randomly (for higher variation in-game)
							// cvar used inside enforcer.qc
var float autocvar_fish_random_skin_colors = 1;		// set cvar 'fish_random_skin_colors' default to 1.    0= do not modify/edit this monster types skin textures     1= modify/edit this monster types skin texture randomly (for higher variation in-game)
							// cvar used inside fish.qc
var float autocvar_gremlin_random_skin_colors = 1;	// set cvar 'gremlin_random_skin_colors' default to 1.    0= do not modify/edit this monster types skin textures     1= modify/edit this monster types skin texture randomly (for higher variation in-game)
							// cvar used inside hipgrem.qc
var float autocvar_hknight_random_skin_colors = 1;	// set cvar 'hknight_random_skin_colors' default to 1.    0= do not modify/edit this monster types skin textures     1= modify/edit this monster types skin texture randomly (for higher variation in-game)
							// cvar used inside hknight.qc
var float autocvar_knight_random_skin_colors = 1;	// set cvar 'knight_random_skin_colors' default to 1.    0= do not modify/edit this monster types skin textures     1= modify/edit this monster types skin texture randomly (for higher variation in-game)
							// cvar used inside knight.qc
var float autocvar_ogre_random_skin_colors = 1;		// set cvar 'ogre_random_skin_colors' default to 1.    0= do not modify/edit this monster types skin textures     1= modify/edit this monster types skin texture randomly (for higher variation in-game)
							// cvar used inside ogre.qc
var float autocvar_scourge_random_skin_colors = 1;	// set cvar 'scourge_random_skin_colors' default to 1.    0= do not modify/edit this monster types skin textures     1= modify/edit this monster types skin texture randomly (for higher variation in-game)
							// cvar used inside hipscrge.qc
var float autocvar_shalrath_random_skin_colors = 1;	// set cvar 'shalrath_random_skin_colors' default to 1.    0= do not modify/edit this monster types skin textures     1= modify/edit this monster types skin texture randomly (for higher variation in-game)
							// cvar used inside shalrath.qc
var float autocvar_shambler_random_skin_colors = 0;	// set cvar 'shambler_random_skin_colors' default to 0.    0= do not modify/edit this monster types skin textures     1= modify/edit this monster types skin texture randomly (for higher variation in-game)
							// cvar used inside shambler.qc
var float autocvar_soldier_random_skin_colors = 1;	// set cvar 'soldier_random_skin_colors' default to 1.    0= do not modify/edit this monster types skin textures     1= modify/edit this monster types skin texture randomly (for higher variation in-game)
							// cvar used inside soldier.qc
var float autocvar_spikemine_random_skin_colors = 1;	// set cvar 'spikemine_random_skin_colors' default to 1.    0= do not modify/edit this monster types skin textures     1= modify/edit this monster types skin texture randomly (for higher variation in-game)
							// cvar used inside hipitems.qc
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
var float autocvar_shalrath_shootable_missile = 0;		// set cvar 'shalrath_shootable_missile' default to 0.    0= disabled    1= shalrath´s missiles are shootable
								// cvar used inside shalrath.qc
/////// Shalrath shootable missile health
var float autocvar_shalrath_shootable_missile_health = 30;	// set health for Shalrath shootable missile health 
								// cvar used inside shalrath.qc
/////// Shalrath shootable missile teleporting when shot
var float autocvar_shalrath_shootable_missile_teleporting = 50;	// set cvar 'shalrath_shootable_missile_teleporting' default to 50.    0= shalrath´s shootable missiles do NOT teleport when shot      Set the teleporting radius here when shalrath´s shootable missiles are shot
								// cvar used inside shalrath.qc


/////// Interactive crosshairs
var float autocvar_weapon_range_crosshair = 0;		// set cvar 'weapon_range_crosshair' default to 0.   Changes crosshair color when aiming at monsters/exploboxes considering individual weapon range     0= disable     1= change crosshair color red/green in 1st person view     2= change crosshair color red/green in 1st and 3rd person view  (ATTENTION: In 3rd person view the crosshair is automagically moved upwards by the engine, so this feature should not be used in 3rd person)  (ATTENTION: Cannot be used together with  "player_health_crosshair"  or  "monster_health_crosshair"  feature !!!)
							// cvar used inside client.qc			
var float autocvar_player_health_crosshair = 0;		// set cvar 'player_health_crosshair' default to 0.   Changes crosshair color according to players health (from green = healthy  to  red = critical health)     0= disabled     1= enabled   (ATTENTION: Cannot be used together with  "weapon_range_crosshair"  or  "monster_health_crosshair"  feature !!!)
							// cvar used inside client.qc			
var float autocvar_monster_health_crosshair = 1;	// set cvar 'monster_health_crosshair' default to 1.   Change crosshair color according to monsters health the player is amining at (from green = healthy  to  red = critical health)     0= disabled     1= enabled   (ATTENTION: Cannot be used together with  "weapon_range_crosshair"  or  "player_health_crosshair"  feature !!!)
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
var float autocvar_armagon_health = 2000;	// set health value of this monster type (skill dependency is considered via qc).
var float autocvar_demon_health = 300;		// set health value of this monster type.
var float autocvar_dog_health = 25;		// set health value of this monster type.
var float autocvar_enforcer_health = 80;	// set health value of this monster type.
var float autocvar_fish_health = 25;		// set health value of this monster type.
var float autocvar_gremlin_health = 100;	// set health value of this monster type.
var float autocvar_hellknight_health = 250;	// set health value of this monster type.
var float autocvar_knight_health = 75;		// set health value of this monster type.
var float autocvar_ogre_health = 200;		// set health value of this monster type.
var float autocvar_scourge_health = 300;	// set health value of this monster type.
var float autocvar_shalrath_health = 400;	// set health value of this monster type.
var float autocvar_shambler_health = 600;	// set health value of this monster type.
var float autocvar_soldier_health = 30;		// set health value of this monster type.
var float autocvar_spikemine_health = 200;	// set health value of this monster type.
var float autocvar_tarbaby_health = 80;		// set health value of this monster type.
var float autocvar_wizard_health = 80;		// set health value of this monster type.
// zombie health should remain 60



/////// monster attack values
var float autocvar_armagon_repulse_melee_attack = 60;	// set damage value of this monster attack type.
// var float autocvar_armagon_missile_attack = 100;	// is identical to players rocket launcher
// var float autocvar_armagon_laser_attack = 18;	// is identical to players laser cannon
var float autocvar_chton_lavaballs = 100;		// set damage value of this monster type.
var float autocvar_demon_claws = 10;			// set damage value of this monster attack type.
var float autocvar_demon_jump = 40;			// set damage value of this monster attack type.
var float autocvar_dog_bite = 8;			// set damage value of this monster attack type.
var float autocvar_dog_jump = 10;			// set damage value of this monster attack type.
var float autocvar_enforcer_laser = 15;			// set damage value of this monster type.
var float autocvar_fish_bite = 3;			// set damage value of this monster type.
var float autocvar_gremlin_melee = 10;			// set damage value of this monster attack type.
// var float autocvar_gremlin_ranged = 10;		// is identical to players weapon damages
var float autocvar_gremlin_steal_weapon_chance = 50;	// set chance for stealing weapon from player in percent (range is between 0 and 100 percent)
var float autocvar_gremlin_gorge_speed_multiplier = 1;	// set speed multiplier for gremlin´s ability to gorge corpses and clone himself
var float autocvar_hellknight_sword = 3;		// set damage value of this monster type.
var float autocvar_hellknight_missile = 9;		// set damage value of this monster type.
var float autocvar_knight_sword = 3;			// set damage value of this monster type.
var float autocvar_ogre_chainsaw = 4;			// set damage value of this monster attack type.
var float autocvar_ogre_grenade = 40;			// set damage value of this monster attack type.
var float autocvar_scourge_tail = 40;			// set damage value of this monster attack type.
var float autocvar_scourge_nails = 9;			// set damage value of this monster attack type.
var float autocvar_shalrath_missile = 40;		// set damage value of this monster type.
var float autocvar_shambler_claws = 20;			// set damage value of this monster attack type.
var float autocvar_shambler_doubleclaws = 40;		// set damage value of this monster attack type.
var float autocvar_shambler_lightning = 10;		// set damage value of this monster attack type.
var float autocvar_soldier_gun = 4;			// (soldiers shotgun has 4 pellets) set damage value of this monster type.
var float autocvar_spikemine_impact = 10;		// set damage value for spikemines touch damage (actual health of spikemine is always added automagically)
var float autocvar_spikemine_radius = 110;		// set damage value of this monster attack type.
var float autocvar_tarbaby_jump = 10;			// set damage value of this monster attack type.
var float autocvar_tarbaby_explode = 120;		// set damage value of this monster attack type.
var float autocvar_wizard_missile = 9;			// set damage value of this monster type.
var float autocvar_zombie_flesh = 10;			// set damage value of this monster type.


/////// player weapon-damage values
var float autocvar_player_axe = 20;		// set damage value for the axe.
var float autocvar_player_shotgun_pellets = 4;	// (shotgun has 6 pellets, doubleshotgun has 14 pellets)
var float autocvar_player_nailgun = 9;		// set damage value for nailgun nails.
var float autocvar_player_supernailgun = 18;	// set damage value for supernailgun nails.
var float autocvar_player_grenades = 120;	// set damage value for grenades radiusdamage.
var float autocvar_player_proximity_bomb = 95;	// set damage value for proximity bomb radiusdamage.
var float autocvar_player_rocket_impact = 100;	// set damage value for rockets direct impact.
var float autocvar_player_rocket_radius = 120;	// set damage value for rockets radiusdamage.
var float autocvar_player_lightninggun = 30;	// set damage value for lightning gun.
var float autocvar_player_lasergun = 18;	// set damage value for laser gun.
var float autocvar_player_mjolnir_hit = 50;	// set damage value for the mjolnir hit.
var float autocvar_player_mjolnir_lightning = 80; // set damage value for the mjolnir lightning´s first impact.



/////// teleport zoom view
var float autocvar_teleport_zoom_view = 1;		// set cvar 'teleport_zoom_view' default to 1.    0= disabled    1= enable view animation, when traveling through teleporters
							// cvar used inside triggers.qc

/////// teleporter particles
var float autocvar_teleporter_particles = 2;		// set cvar 'teleporter_particles' default to 2.    0= disabled    1= enable extra particle effects ONLY in front of regular teleporters     2= enable extra particle effects in front of teleporters AND end-map-teleporters     3= enable extra particle effects ONLY in front of end-map-teleporters
							// cvar used inside triggers.qc
/////// slipgate teleporter particles
var float autocvar_teleporter_particles_slipgates = 3;	// set cvar 'teleporter_particles_slipgates' default to 3.    0= disabled    1= enable "soak in" effect for slipgates (in base maps)     2= enable "rising-stars" effect for slipgates (in base maps)     3= enable "red-fog" effect for slipgates (in base maps)     4= enable combination of "soak in" + "red-fog" effect for slipgates (in base maps)     5= enable combination of "rising-stars" + "red-fog" effect for slipgates (in base maps)
							// cvar used inside triggers.qc



/////// Face effect
var float autocvar_evil_faces = 0;	  		// evil textures are interactive.  0= disabled   1= textures bleed, when shot   2= evil monster is spawn when shot
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
var float autocvar_evil_faces_monster_behaviour = 0;	// 0= evil face monster will vanish, when hitting walls/meshes    1= evil face monster will NOT vanish, when hitting walls/meshes (= more dangerous)    (when evil_faces is set to "2")
							// cvar used inside face.qc



/////// Warlord health value:
var float autocvar_warlord_health = 250;		// set health value of the Warlords
							// cvar used inside warlord.qc

/////// Warlord chance to replace a hknight:
var float autocvar_warlord_replace_hknight = 20;	// set cvar 'warlord_replace_hknight' default to 20  (= 20%).  Set the percentage of replacing the hknight with an Warlord (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside hknight.qc

/////// Warlord chance to replace an ogre:
var float autocvar_warlord_replace_ogre = 15;		// set cvar 'warlord_replace_ogre' default to 15  (= 15%).  Set the percentage of replacing the ogre with an Warlord (0= never.  100= always). Choose any value you want between 0 and 100
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
							// cvar used inside warlord.qc




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
var float autocvar_slowmotion_intensity = 0.3;		// set cvar 'slowmotion_intensity' default to 0.3.  Set the slowmotion / game speed.  "0.3" means 30% of regular time / game speed. (0= totally freeze.  1= normal speed.). Choose any value you want between 0 and 1 (higher values will increase speed)
							// cvar used inside client.qc, world.qc and all monsters .qc files

/////// Slowmotion duration
var float autocvar_slowmotion_duration = 3;		// set cvar 'slowmotion_duration' default to 3.  Set the slowmotion duration in seconds.  
							// cvar used inside world.qc and all monsters .qc files

/////// Slowmotion occurrence corpses
var float autocvar_slowmotion_randomness_corpse = 30;	// set cvar 'slowmotion_randomness_corpse' default to 30  (= 30%).  Set chance of slowmotion effect appearance for when gibbing corpses (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside the monsters .qc file

/////// Slowmotion occurrence afrit
var float autocvar_slowmotion_randomness_afrit = 30;	// set cvar 'slowmotion_randomness_afrit' default to 30  (= 30%).  Set chance of slowmotion effect appearance for this monster-type (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside the monsters .qc file

/////// Slowmotion occurrence demon
var float autocvar_slowmotion_randomness_demon = 30;	// set cvar 'slowmotion_randomness_demon' default to 30  (= 30%).  Set chance of slowmotion effect appearance for this monster-type (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside the monsters .qc file

/////// Slowmotion occurrence dog
var float autocvar_slowmotion_randomness_dog = 30;	// set cvar 'slowmotion_randomness_dog' default to 30  (= 30%).  Set chance of slowmotion effect appearance for this monster-type (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside the monsters .qc file

/////// Slowmotion occurrence enforcer
var float autocvar_slowmotion_randomness_enforcer = 30;	// set cvar 'slowmotion_randomness_enforcer' default to 30  (= 30%).  Set chance of slowmotion effect appearance for this monster-type (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside the monsters .qc file

/////// Slowmotion occurrence gremlin
var float autocvar_slowmotion_randomness_gremlin = 30;	// set cvar 'slowmotion_randomness_gremlin' default to 30  (= 30%).  Set chance of slowmotion effect appearance for this monster-type (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside the monsters .qc file

/////// Slowmotion occurrence hknight
var float autocvar_slowmotion_randomness_hknight = 30;	// set cvar 'slowmotion_randomness_hknight' default to 30  (= 30%).  Set chance of slowmotion effect appearance for this monster-type (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside the monsters .qc file

/////// Slowmotion occurrence knight
var float autocvar_slowmotion_randomness_knight = 30;	// set cvar 'slowmotion_randomness_knight' default to 30  (= 30%).  Set chance of slowmotion effect appearance for this monster-type (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside the monsters .qc file

/////// Slowmotion occurrence ogre
var float autocvar_slowmotion_randomness_ogre = 30;	// set cvar 'slowmotion_randomness_ogre' default to 30  (= 30%).  Set chance of slowmotion effect appearance for this monster-type (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside the monsters .qc file

/////// Slowmotion occurrence scourge
var float autocvar_slowmotion_randomness_scourge = 30;	// set cvar 'slowmotion_randomness_scourge' default to 30  (= 30%).  Set chance of slowmotion effect appearance for this monster-type (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside the monsters .qc file

/////// Slowmotion occurrence shalrath
var float autocvar_slowmotion_randomness_shalrath = 30;	// set cvar 'slowmotion_randomness_shalrath' default to 30  (= 30%).  Set chance of slowmotion effect appearance for this monster-type (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside the monsters .qc file

/////// Slowmotion occurrence shambler
var float autocvar_slowmotion_randomness_shambler = 30;	// set cvar 'slowmotion_randomness_shambler' default to 30  (= 30%).  Set chance of slowmotion effect appearance for this monster-type (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside the monsters .qc file

/////// Slowmotion occurrence soldier
var float autocvar_slowmotion_randomness_soldier = 30;	// set cvar 'slowmotion_randomness_soldier' default to 30  (= 30%).  Set chance of slowmotion effect appearance for this monster-type (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside the monsters .qc file

/////// Slowmotion occurrence spider
var float autocvar_slowmotion_randomness_spider = 30;	// set cvar 'slowmotion_randomness_spider' default to 30  (= 30%).  Set chance of slowmotion effect appearance for this monster-type (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside the monsters .qc file

/////// Slowmotion occurrence Warlord
var float autocvar_slowmotion_randomness_warlord = 30;	// set cvar 'slowmotion_randomness_warlord' default to 30  (= 30%).  Set chance of slowmotion effect appearance for this monster-type (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside the monsters .qc file

/////// Slowmotion occurrence wizard
var float autocvar_slowmotion_randomness_wizard = 30;	// set cvar 'slowmotion_randomness_wizard' default to 30  (= 30%).  Set chance of slowmotion effect appearance for this monster-type (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside the monsters .qc file

/////// Slowmotion occurrence zombie
var float autocvar_slowmotion_randomness_zombie = 30;	// set cvar 'slowmotion_randomness_zombie' default to 30  (= 30%).  Set chance of slowmotion effect appearance for this monster-type (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside the monsters .qc file



/////// afrits health:
var float autocvar_afrit_health = 120;			// Afrit´s have the health value of the monster type it replaces/supports !  This cvar only takes affect in custom maps, where the Afrits are spawned directly !
							// cvar used inside afrit.qc

/////// afrits cocoon shape:
var float autocvar_afrit_waits_in_cocoon = 40;		// set cvar 'afrit_waits_in_cocoon' default to 40 (= 40%).  Set the chance for afrit using his cocoon shape while idling. (0% = never.  100% = always). Choose any value you want between 0 and 100
							// cvar used inside afrit.qc

/////// afrits fireball damage:
var float autocvar_afrit_fireball_damage = 7;		// set cvar 'afrit_fireball_damage' default to 7.  Set the amount of damage per fireball-hit.
							// cvar used inside afrit.qc

/////// afrits chance to replace a demon:
var float autocvar_afrit_replace_demon = 5;		// set cvar 'afrit_replace_demon' default to 5  (= 5%).  Set the chance of replacing the demon with an afrit (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside demon.qc
/////// afrits chance to support a demon:
var float autocvar_afrit_supports_demon = 15;		// set cvar 'afrit_supports_demon' default to 15  (= 15%).  Set the chance of spawning an ADDITIONAL afrit beside a demon  (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside demon.qc

/////// afrits chance to replace a dog:
var float autocvar_afrit_replace_dog = 5;		// set cvar 'afrit_replace_dog' default to 5  (= 5%).  Set the chance of replacing the dog with an afrit (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside dog.qc
/////// afrits chance to support a dog:
var float autocvar_afrit_supports_dog = 10;		// set cvar 'afrit_supports_dog' default to 10  (= 10%).  Set the chance of spawning an ADDITIONAL afrit beside a dog  (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside dog.qc

/////// afrits chance to replace a enforcer:
var float autocvar_afrit_replace_enforcer = 0;		// set cvar 'afrit_replace_enforcer' default to 0  (= 0%).  Set the chance of replacing the enforcer with an afrit (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside enforcer.qc
/////// afrits chance to support a enforcer:
var float autocvar_afrit_supports_enforcer = 0;		// set cvar 'afrit_supports_enforcer' default to 0  (= 0%).  Set the chance of spawning an ADDITIONAL afrit beside a enforcer  (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside enforcer.qc

/////// afrits chance to replace a gremlin:
var float autocvar_afrit_replace_gremlin = 5;		// set cvar 'afrit_replace_gremlin' default to 5  (= 5%).  Set the chance of replacing the gremlin with an afrit (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside hipgrem.qc
/////// afrits chance to support a gremlin:
var float autocvar_afrit_supports_gremlin = 5;		// set cvar 'afrit_supports_gremlin' default to 5  (= 5%).  Set the chance of spawning an ADDITIONAL afrit beside a gremlin  (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside hipgrem.qc

/////// afrits chance to replace a hknight:
var float autocvar_afrit_replace_hknight = 5;		// set cvar 'afrit_replace_hknight' default to 5  (= 5%).  Set the chance of replacing the hknight with an afrit (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside hknight.qc
/////// afrits chance to support a hknight:
var float autocvar_afrit_supports_hknight = 10;		// set cvar 'afrit_supports_hknight' default to 10  (= 10%).  Set the chance of spawning an ADDITIONAL afrit beside a hknight  (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside hknight.qc

/////// afrits chance to replace a knight:
var float autocvar_afrit_replace_knight = 5;		// set cvar 'afrit_replace_knight' default to 5  (= 5%).  Set the chance of replacing the knight with an afrit (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside knight.qc
/////// afrits chance to support a knight:
var float autocvar_afrit_supports_knight = 10;		// set cvar 'afrit_supports_knight' default to 10  (= 10%).  Set the chance of spawning an ADDITIONAL afrit beside a knight  (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside knight.qc

/////// afrits chance to replace a ogre:
var float autocvar_afrit_replace_ogre = 5;		// set cvar 'afrit_replace_ogre' default to 5  (= 5%).  Set the chance of replacing the ogre with an afrit (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside ogre.qc
/////// afrits chance to support a ogre:
var float autocvar_afrit_supports_ogre = 15;		// set cvar 'afrit_supports_ogre' default to 15  (= 15%).  Set the chance of spawning an ADDITIONAL afrit beside a ogre  (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside ogre.qc

/////// afrits chance to replace a scourge:
var float autocvar_afrit_replace_scourge = 5;		// set cvar 'afrit_replace_scourge' default to 5  (= 5%).  Set the chance of replacing the scourge with an afrit (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside hipscrge.qc
/////// afrits chance to support a scourge:
var float autocvar_afrit_supports_scourge = 10;		// set cvar 'afrit_supports_scourge' default to 10  (= 10%).  Set the chance of spawning an ADDITIONAL afrit beside a scourge  (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside hipscrge.qc

/////// afrits chance to replace a shalrath:
var float autocvar_afrit_replace_shalrath = 0;		// set cvar 'afrit_replace_shalrath' default to 0  (= 0%).  Set the chance of replacing the shalrath with an afrit (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside shalrath.qc
/////// afrits chance to support a shalrath:
var float autocvar_afrit_supports_shalrath = 15;	// set cvar 'afrit_supports_shalrath' default to 15  (= 15%).  Set the chance of spawning an ADDITIONAL afrit beside a shalrath  (0= never.  100= always). Choose any value you want between 0 and 100
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
var float autocvar_afrit_supports_soldier = 10;		// set cvar 'afrit_supports_soldier' default to 10  (= 10%).  Set the chance of spawning an ADDITIONAL afrit beside a soldier  (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside soldier.qc

/////// afrits chance to replace a tarbaby:
var float autocvar_afrit_replace_tarbaby = 10;		// set cvar 'afrit_replace_tarbaby' default to 10  (= 10%).  Set the chance of replacing the tarbaby with an afrit (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside tarbaby.qc
/////// afrits chance to support a tarbaby:
var float autocvar_afrit_supports_tarbaby = 15;		// set cvar 'afrit_supports_tarbaby' default to 15  (= 15%).  Set the chance of spawning an ADDITIONAL afrit beside a tarbaby  (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside tarbaby.qc

/////// afrits chance to replace a wizard:
var float autocvar_afrit_replace_wizard = 15;		// set cvar 'afrit_replace_wizard' default to 15  (= 15%).  Set the chance of replacing the wizard with an afrit (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside wizard.qc
/////// afrits chance to support a wizard:
var float autocvar_afrit_supports_wizard = 20;		// set cvar 'afrit_supports_wizard' default to 20  (= 20%).  Set the chance of spawning an ADDITIONAL afrit beside a wizard  (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside wizard.qc

/////// afrits chance to replace a zombie:
var float autocvar_afrit_replace_zombie = 0;		// set cvar 'afrit_replace_zombie' default to 0  (= 0%).  Set the chance of replacing the zombie with an afrit (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside zombie.qc
/////// afrits chance to support a zombie:
var float autocvar_afrit_supports_zombie = 10;		// set cvar 'afrit_supports_zombie' default to 10  (= 10%).  Set the chance of spawning an ADDITIONAL afrit beside a zombie  (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside zombie.qc




/////// spiders health value
var float autocvar_spider_health = 111;			// Spider´s have the health value of the monster type it replaces !  This cvar only takes affect in custom maps, where the Spiders are spawned directly !
							// cvar used inside spider.qc

/////// spiders melee attack damage value
var float autocvar_spider_melee = 7;			// set damage value of this monster attack type.
							// cvar used inside spider.qc

/////// spiders jump attack damage value
var float autocvar_spider_jump = 15;			// set damage value of this monster attack type.
							// cvar used inside spider.qc

/////// spiders ranged attack damage value
var float autocvar_spider_web = 1;			// set damage value of this monster attack type.
							// cvar used inside spider.qc

/////// spiders chance to resist an attack:
var float autocvar_spider_attack_resistance = 25;	// set cvar 'spider_attack_resistance' default to 25  (= 25%).  Set the percentage how much the spider has a chance to resist an attack  (0= never.  100= always resist). Choose any value you want between 0 and 100
							// cvar used inside weapons.qc

/////// spiders improved jump behaviour  (takes height difference into account)
var float autocvar_spider_improved_jump_behaviour = 1;	// set cvar 'spider_improved_jump_behaviour' default to 1.   0= only jumps towards player when his position is in a close z-range compared to player (dependency/behaviour is identical to demon. Like in SMC before)       1= always jumps towards player and taking height difference into account (doesnt matter if player is much higher or lower than spider in world) 
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

/////// spiders chance to replace a demon:
var float autocvar_spider_replace_demon = 17;		// set cvar 'spider_replace_demon' default to 17  (= 17%).  Set the percentage of replacing the demon with a spider (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside demon.qc

/////// spiders chance to replace a dog:
var float autocvar_spider_replace_dog = 15;		// set cvar 'spider_replace_dog' default to 15  (= 15%).  Set the percentage of replacing the dog with a spider (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside dog.qc

/////// spiders chance to replace a enforcer:
var float autocvar_spider_replace_enforcer = 10;	// set cvar 'spider_replace_enforcer' default to 10  (= 10%).  Set the percentage of replacing the enforcer with a spider (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside enforcer.qc

/////// spiders chance to replace a gremlin:
var float autocvar_spider_replace_gremlin = 10;		// set cvar 'spider_replace_gremlin' default to 10  (= 10%).  Set the percentage of replacing the gremlin with a spider (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside HIPGREM.qc

/////// spiders chance to replace a hknight:
var float autocvar_spider_replace_hknight = 10;		// set cvar 'spider_replace_hknight' default to 10  (= 10%).  Set the percentage of replacing the hknight with a spider (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside hknight.qc

/////// spiders chance to replace a knight:
var float autocvar_spider_replace_knight = 15;		// set cvar 'spider_replace_knight' default to 15  (= 15%).  Set the percentage of replacing the knight with a spider (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside knight.qc

/////// spiders chance to replace a ogre:
var float autocvar_spider_replace_ogre = 10;		// set cvar 'spider_replace_ogre' default to 10  (= 10%).  Set the percentage of replacing the ogre with a spider (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside ogre.qc

/////// spiders chance to replace a scourge:
var float autocvar_spider_replace_scourge = 10;		// set cvar 'spider_replace_scourge' default to 10  (= 10%).  Set the percentage of replacing the scourge with a spider (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside hipscrge.qc

/////// spiders chance to replace a shalrath:
var float autocvar_spider_replace_shalrath = 0;		// set cvar 'spider_replace_shalrath' default to 0  (= 0%).  Set the percentage of replacing the shalrath with a spider (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside shalrath.qc

/////// spiders chance to replace a shambler:
var float autocvar_spider_replace_shambler = 10;	// set cvar 'spider_replace_shambler' default to 10  (= 10%).  Set the percentage of replacing the shambler with a spider (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside shambler.qc

/////// spiders chance to replace a soldier:
var float autocvar_spider_replace_soldier = 15;		// set cvar 'spider_replace_soldier' default to 15  (= 15%).  Set the percentage of replacing the soldier with a spider (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside soldier.qc

/////// spiders chance to replace a tarbaby:
var float autocvar_spider_replace_tarbaby = 20;		// set cvar 'spider_replace_tarbaby' default to 20  (= 20%).  Set the percentage of replacing the tarbaby with a spider (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside tarbaby.qc

/////// spiders chance to replace a zombie:
var float autocvar_spider_replace_zombie = 5;		// set cvar 'spider_replace_zombie' default to 5  (= 5%).  Set the percentage of replacing the zombie with a spider (0= never.  100= always). Choose any value you want between 0 and 100
							// cvar used inside zombie.qc


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
var float autocvar_bloodextension = 1;			// set cvar 'bloodextension' default to 1
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



////// shambler can make the ground shattering and kickup dust when he walks/runs:
var float autocvar_shambler_walking_quake = 3;		// set cvar 'shambler_walking_quake' default to 3    "0"= disabled    "1"= shambler footsteps makes the ground shattering when he walks/runs     "2"= shambler footsteps adds raising dust when he walks/runs    "3"= shambler footsteps makes the ground shattering when he walks/runs + adds raising dust !
							// cvar used inside shambler.qc

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
	else if ((self.weapon == IT_SUPER_NAILGUN) || (self.weapon == IT_LASER_CANNON))
		traceline (source, source + v_forward*2048, FALSE, self);
	else if (self.weapon == IT_GRENADE_LAUNCHER)
		traceline (source, source + v_forward*777, FALSE, self);	// FIXME: find better calculation
	else if (self.weapon == IT_PROXIMITY_GUN)
		traceline (source, source + v_forward*500, FALSE, self);
	else if (self.weapon == IT_ROCKET_LAUNCHER)
		traceline (source, source + v_forward*2048, FALSE, self);
	else if (self.weapon == IT_LIGHTNING)
		traceline (source, source + v_forward*600, FALSE, self);
	else if (self.weapon == IT_MJOLNIR)
	{
		if (self.ammo_cells >= 15)
			traceline (source, source + v_forward*350, FALSE, self);
		else
			traceline (source, source + v_forward*32, FALSE, self);
	}
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
		else 	// zombie´s do not "lose" health
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
		self.angles_x = 15;		// legs must not change x-angles together with player´s view
		if (autocvar_player_legs_model == 1)
		{
			if (self.owner.weapon == IT_MJOLNIR)
				setmodel(self, "progs/player_legs_ham1.mdl");
			else
				setmodel(self, "progs/player_legs1.mdl");
		}
		else
		{
			if (self.owner.weapon == IT_MJOLNIR)
				setmodel(self, "progs/player_legs_ham2.mdl");
			else
				setmodel(self, "progs/player_legs2.mdl");
		}
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
		else if ((self.weapon == IT_GRENADE_LAUNCHER) || (self.weapon == IT_PROXIMITY_GUN))
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
		else if (self.weapon == IT_LASER_CANNON)
		{
			setmodel (self, "progs/player_multi.mdl");
			setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
		}
		else if (self.weapon == IT_MJOLNIR)
		{
   			setmodel (self, "progs/playham.mdl");
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
		self.angles_x = 15;		// legs must not change x-angles together with player´s view

		if (autocvar_player_legs_model == 1)
		{
			if (self.owner.weapon == IT_MJOLNIR)
				setmodel(self, "progs/player_legs_ham1.mdl");
			else
				setmodel(self, "progs/player_legs1.mdl");
		}
		else
		{
			if (self.owner.weapon == IT_MJOLNIR)
				setmodel(self, "progs/player_legs_ham2.mdl");
			else
				setmodel(self, "progs/player_legs2.mdl");
		}
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
							// cvar used all monster´s .qc files

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
								// cvar used in all monster´s .qc files
var float autocvar_burning_monsters_death_animation_time = 4;	// set cvar 'burning_monsters_death_animation_time' default to 4 seconds.    Sets the time in seconds in which the monsters run around in panic (burning and screaming) before they finally die. (when killed with explosive weapons and enabled cvar: 'burning_monsters_death_animation')
								// cvar used in all monster´s .qc files
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
.float variation;       // sets which eruption variations to use: "1"=small eruption only "2"=medium eruption only "3"=large eruption only
				//                                        "4"=random small or medium eruption "5"=all 3 eruptions randomly


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
      eruptiondamage = spawn();			// size and lifetime of area is depending on size of lava eruption
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

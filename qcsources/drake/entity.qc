// entity.qc -- Entity fields used by Drake.

//==========================================================================
//
//  STANDARD
//
//==========================================================================

//
// world fields (FIXME: make globals)
//
.string     wad;
.string     map;
.float      worldtype;  // 0=medieval 1=metal 2=base
//================================================
.string     killtarget;
//
// quakeed fields
//
.float      light_lev;        // not used by game, but parsed by light util
.float      style;
//
// monster ai
//
.void()     th_stand;
.void()     th_walk;
.void()     th_run;
.void()     th_missile;
.void()     th_melee;
.void(entity attacker, float damage)    th_pain;
.void()     th_die;
.entity     oldenemy;        // mad at this player before taking damage
.float      speed;
.float      lefty;
.float      search_time;
.float      attack_state;

// PM:  Attack state globals moved to 'const.qc'.

//
// player only fields (PM:  Used by monsters too!)
//
.float      walkframe;
.float      attack_finished;
.float      pain_finished;
//------------------------
// POWERUPS!
// PM:  Ack!  The names are confusing, and I would have renamed them for
// my convenience if not for mapping/compatibility reasons.
// The important fields -- check these for activity.
.float      invincible_finished;
.float      invisible_finished;
.float      super_damage_finished;
.float      radsuit_finished;
// Other fields for item pickup or timers.
.float      invincible_time, invincible_sound;
.float      invisible_time, invisible_sound;
.float      super_time, super_sound;
.float      rad_time;
//------------------------
.float      fly_sound;      // set by wind tunnels.
.float      axhitme;
.float      show_hostile;   // set to time+0.2 whenever a client fires a
                            // weapon or takes damage.  Used to alert
                            // monsters that otherwise would let the player go
.float      jump_flag;        // player jump flag (falling damage)
.float      swim_flag;        // player swimming sound flag
.float      air_finished;   // when time > air_finished, start drowning
.float      bubble_count;     // keeps track of the number of bubbles
.string     deathtype;        // keeps track of how the player died
// object stuff ------------------------------------------------------------
.string     mdl;
.vector     mangle;            // angle at start
.float      t_length, t_width;
// doors, etc --------------------------------------------------------------
.vector     dest, dest1, dest2;
.float      wait;           // time from firing to restarting
.float      delay;          // time from activation to firing
.entity     trigger_field;  // door's trigger entity  (PM:  Used by Hip too!)
.string     noise4;
// monsters ----------------------------------------------------------------
.float      pausetime;      // Used by Zerstorer cutscene code.
.entity     movetarget;
// doors -------------------------------------------------------------------
.float      aflag;      // PM:  What code beyond 1.06 progs use this?
.float      dmg;        // damage done by door when hit  (PM:  Also drowning.)
// misc --------------------------------------------------------------------
.float      cnt;        // misc flag  (PM:  Used by 'SUB_CheckRefire'.)
// subs --------------------------------------------------------------------
.void()     think1;
.vector     finaldest, finalangle;
// triggers ----------------------------------------------------------------
.float      count;      // for counting triggers
// plats / doors / buttons -------------------------------------------------
.float      lip;
.float      state;
.vector     pos1, pos2;     // top and bottom positions
.float      height;
// sounds ------------------------------------------------------------------
.float      waitmin, waitmax;
.float      distance;
.float      volume;


//==========================================================================
// fields in 1.06 progs not found in defs.qc

.float      healamount, healtype;   // items.qc -- Used by health items.
.float      dmgtime;        // client.qc (id) / pow.qc (Drake)
//.float      hit_z;          // weapons.qc -- Unused in 1.06.
.float      inpain;         // zombie.qc


//==========================================================================
//
//  BUILTIN VARS FOR CUSTOM PORTS (e.g., FitzQuake, DarkPlaces, etc.)
//
//==========================================================================

//
// more Quake engine vars
//
.float      alpha;      // Transparent entities in some custom engines.
.float      gravity;    // From 1.07 Scourge of Armagon.
.float      items2;     // HUD icons in Mission Packs/Quoth.
.string     sky;        // Some engines use this to load skyboxes.
.vector     color;      // Used in dpextensions.  Formerly float type.
                        //  Hip particle fields use color_x.


//==========================================================================
//
//  MISSION PACKS
//
//==========================================================================

// spawning --------------------------------------------------------------
// Taken from Hip's func_spawn code.
.void()     spawnfunction;      // Also used by custom dynamic items code.
.string     spawnclassname;     // Ditto.
.float      spawnsolidtype;
.string     spawnmodel;
.void()     spawnthink;
.entity     spawnmaster;
.vector     spawnmins;
.vector     spawnmaxs;
.float      spawnsilent;
.float      spawnmulti;
.float      spawnskin;  // PM:  This one is new.  Used by respawning code.


//==========================================================================
//
//  DRAKE
//
//==========================================================================

//
// null fields
//
// WARNING:  Do not *use* these fields to store data!
.void()     null_func;      // Use 'world.null_func' for null function needs.
.string     null_string;    // Replace 'string_null' with 'world.null_string'.
                            //  null string, nothing should be held here.

//
// more monster ai
//
.void()             th_jump;    // Jump anim when monsters touch jump trigger.
.void(float hello)  th_sight;   // Sight sound when spotting a target.
.float()            th_check;   // Check attack.
.float()            th_harass;  // Check attack when enemy is !visible.
.float(float dm)    th_gib;
.void()             th_revive;  // Resurrection scene.
.void()             th_spawn;   // Respawn function.
.void()             th_void;    // Called when killed by a void trigger.
.void()             th_win;     // Monsters:  sound when killing a player.
                                // Missiles:  code prior to origin shift.
                                // Items:  additional code after spawning.
.float(float yaw, float dist)   th_move;    // 'walkmove' or equivalent.
.void(float dist)   th_goal;    // 'movetogoal' or equivalent.

// Quoth stuff --------------------------------------------------------------
//.float  lose_items;     // Set to '1' for world entity to restart stats.

// resistance ---------------------------------------------------------------
.float      resist_acid;    // slime, acid.
.float      resist_rocket;  // damage caused by rocket or railgun.
.float      resist_fire;    // lava, flames.
.float      resist_light;   // electrical attacks such as lightning bolts.
.float      resist_cold;    // ice.

//---------------------------------------------------------------------------
.float      gib_health;     // Call xxx.th_gib when health falls below this.

//---------------------------------------------------------------------------
.float      h2olevel;       // 'waterlevel' without the C code baggage.
.float      h2otype;        // Ditto, except for 'watertype'.

// persistent attacks -------------------------------------------------------
.entity     burner;         // Flame that is burning on the entity.
.vector     burn_ofs;       // Where flame burns relative to target origin.
                            //  x = v_forward, y = v_right, z = v_up.

// hit type -----------------------------------------------------------------
.float      hittype;

// mass/weight --------------------------------------------------------------
.float      mass;

// key operators ------------------------------------------------------------
// Keyops are used to respawn keys when the monster who took them dies.
.entity     keyop1;
.entity     keyop2;

// armour values ------------------------------------------------------------
.vector     armor_stats;    // x = armortype, y = armorvalue, z = item bit

// morphing stuff -----------------------------------------------------------
.float      form_active;        // Non-zero if player is in monster form.

// Note:  Until dragonscale armor was settled on, the dragon morph was
// triggered by an artifact weapon named "Eye/Mark of Bahamut".
// Thus, some names are legacy code written prior to morphing armors.
.float      baha_ammo;          // Renewable energy for dragon form.
.float      baha_time;          // Time it takes for ammo to recharge.
.float      baha_click;         // Helps check for double-clicking.
// The b2_* fields should be used only in client.qc and impulse.qc.
.float      b0_click;       // Button0 (attack) press counter.
.float      b2_click;       // Button2 (jump) press counter.
.float      b2_time;        // Time to wait for jump double press.
.float      b2_done;        // Ignore jump if > time.  Stops spam grief.

// more monster ai -------------------------------------------------------
.entity     fallen;     // Face this entity while resurrecting it.
.entity     master;     // Like owner, without the C code bondage.
                        //  HEAVILY USED by monster summoning code!
                        //  Update:  Used by all missiles for reflection.
.float      attack_time;    // Time when a creature attack last.
.float      spawned;    // TRUE if created/summoned after a level load.
.float      mindex2;    // Backup modelindex.  Used by sf64 code.
                        //  Also by monsters for invisibility powerup.
.float      fighting;   // Checks if monster is really fighting while
                        //  running.  Monsters can run to follow friends.
.float      level;      // Rapture:  Baron element type.
.float      pets;       // Number of pets owned.  Used by nightshade and necro.
.float      punked;     // Set to TRUE when a soldier loses a gun mid-attack.
.vector     zones;      // Set of distance values used for following.
                        //  x=minimum, y=spawning, z=maximum
                        //  if ?<x, run away, else if ?>z follow, else stay.
.vector     purse;      // Used by monsters to drop money when killed.
                        //  x=coins, y=gems, z=random data.
                        //  z1=max items, z2=spawn chance, z3=gem chance.
.vector     aim_here;   // Aim shot at this spot.  For Quoth's oldenemyorigin.


// Added so monsters can seek path_corners and trigger other things when
// killed.  Use .target for path corners and .target2 for triggering.
.string     target2;
.string     mdl_head;   // Used by gremlin when it throws a head.
                        // Update:  Also by decapitation code.
.string     soul;       // Wraiths check this field to find and reap souls.

// The rest is for gremlins.  Comment out if gremlin isn't included.
// Update:  Wraith uses gorging to toggle soul reaper mode.
.float      gorging;    // Gremlin food AI / Enemies may be eaten if TRUE.

// 8/7/2010:  New field for summoning.  Used by gauroch.
.string     summontarget;

// triggers --------------------------------------------------------------
.float      duration;       // Used by Hipnotic explosion code.
// Trigger count field for Zerstorer since Hipnotic stuff uses cnt.
.float      zerc;   // Short for ZERstorer Count.

//===========================================================================

// Monsters that have a common family do not infight from friendly fire
// alone unless insane.
.float      family;

//===========================================================================
//  Weapons

// weapon values ------------------------------------------------------------
.float      saw_time;       // Time to play chainsaw idle sound.
.float      tracer_time;    // Used by rapid-fire energy weapons.
.float      zapper_time;    // Time to recharge flare gun/wand.
.float      arsenal;        // Up to 24 weapons can be stored here.
.float      war;            // Short for 'Weapon ARmed'.  Current weapon.
.float      drama1;         // DRAke Monster Arsenal.  For release 1.
.float      ammo_super;     // Super shots for crossbow.
.float      shots_max;      // Maximum shots in an attack.
.float      shots_left;     // Like currentammo.
.float      hit_points;     // True health, used to stop 'give h <#>'.
// DISABLED -- Stopping 'give' ammo cheats requires adding code in
// too many places.  With the other cheats removed, combined with the
// monsters' ferocity in Hell, the player can give himself as much ammo
// as he wants, and he will probably still die anyway.
// real_* is used to stop the give ammo cheats.

// FIXME:  Can we find another field that can be used as this?
.float      encore;     // TRUE = followup attack in a series.

// FIXME:  tamed is unused.
//.entity     tamed;          // Link to monster stored in capture weapon.
.entity     mist;           // Link to monster capturing entity.
.entity     chain2;
.entity     mirv1;          // Link to most recently launched MIRV.
.entity     hook;           // Link to most recently launched grappling hook.
// FIXME:  Do I need this?
//.entity     rain1;          // Link to rainstorm entity.

// extra flags --------------------------------------------------------------
.float      xfl, xf2;   // Extra flags without C code connections.
.float      xsf;        // Extra spawnflags used by func_spawn and sf64.

// More powerups -----------------------------------------------------------
// Hip wetsuit merged with biosuit.
.float      thorns_finished, thorns_time, thorns_sound; // Empathy shields
.float      wing_finished, wing_time, wing_sound;       // Dark-Angel Wings *
.float      mirror_finished, mirror_time, mirror_sound, mirror_ping;  // Reflection
.float      cross_finished, cross_time, cross_sound;    // Cross of Deflection
.float      tome_finished, tome_time;       // Tome of Power.
.float      hammer_finished;    // When Mjolnir returns to player.
//.float      thaxe_finished;     // When throwing axe returns to player.
// * Replaced by Boots of Leviation if not in Zerstorer mode.
// Possible ToDo:  Add thunderstorm artifact.  Confusion artifact.
.float      curse_finished, curse_type, curse_ping;     // Necromancer debuffs.
.float      curse_slow;     // Delay nextthink to time here.
.float      jump_time;      // Used by custom trigger_jump.
.float      slow_finished, slow_time, slow_ping;    // For those hit by ice arrow.

.float      perms;  // Permanent powerups.
// FIXME:  Keep?
//.float      perm_hp;    // Bonus permanent health.
//.float      tech;   // Mutually exclusive powerups.  FIXME:  Merge w/ perms.

// Books -------------------------------------------------------------------
.float      book_page;
.float      book_time;
.entity     book_ent;
.string     page1, page2, page3, page4, page5, page6, page7, page8;

// Cutscenes ---------------------------------------------------------------
// Cutscenes -- Borrowed from Zerstorer.
.string     script;         //dhm - denotes which script to read.
.string     next_script;    //dhm - denotes the current script.
.string     script_num;     //dhm - number for info_scripts.
//.string     camera_point;   //dhm - target for camera to move to.
.string     focal_point;    //dhm - focus point for camera.
.float      script_delay;   //dhm - time until next script.
.float      script_time;    //dhm - used for script timing.
.float      script_count;   //dhm - ditto.


//==========================================================================
//  DRAGONS

// threat values -----------------------------------------------------------
// Used by Dragons
// BIG BIG FIXME!!!:  Use bit flags to determine threat types.
.float      threats;
.float      ryuflags;   // AI flags for monsters.

// -- Who should use what: --
// Danger:  shambler, shalrath, nemesant, wrath, ebon necros
// Death:  tarbaby, OUM drone, nightshade, wrath.
// Badass:  tarbaby, OUM drone, cyberdemon, Armagon
// Vis:  Fiend
// Enemy:  Shambler, scourge, snakeman
// Size:  Qtest dragon, nightshade
// ---------------------------


//===========================================================================
//  TRONYN
//  (FIXME:  For Tronyn only -- remove for Drake.)

.float      tronyn;     // Flags that do special things in his maps.

//===========================================================================
// align.qc
.string     alignment;
.float      threshold;  // Time when monster can fight back new targets.
                        //  Named 'threshold' because that's what Doom used.
                        //  Known as 'activated_time' in the Chapters source.

// blood.qc
.float      bloodtype;      // For blood other than red, like in Alien Quake.

// hp.qc
// Note:  'healrate*' values are the time required to regain 1 hp...
.float      healrate;       // Time to regain 1 hp, up to full health.
.float      healrate2;      // Time to regain 1 hp, up to hakf health.
// The above two can stack.
.float      healtime;       // Time when damaged entity regains health.
.float      poison_rate;        // How much poison the entity has.
.float      poison_finished;    // Time when entity takes poison damage.
// FIXME:  Rate.
//.float      repairrate;     // Time required to regain 1 ap.
.float      repairtime;     // Time when entity's armor rebuilds.
.float      veil_time;      // Ultra enforcers' particle shield.

// mirv.qc (Update: ...and hydra.qc)
.float      rate2;

// cool.qc
.entity     divine_attacker;    // Who gets credit when lightning strikes.
.float      divine_finished;    // If non-zero, when an entity gets zapped.
.float      divine_hits;        // How many zaps an attacker is allowed.

// doomcube.qc
// The difference between this and Quake's standard movetogoal is 'self'
// will move around the enemy as if a wall instead of an abrupt stop.
.float      movecount;
.vector     attack_ofs;

// rotate.qc (Originally hiprot.qc)
.string     event;


//===========================/  END OF FILE  /===========================//

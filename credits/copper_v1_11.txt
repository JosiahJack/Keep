================================================================================

    COPPER
    a single-player refinement mod
    for id software's QUAKE
    
    http://www.lunaran.com/copper/
    
    File        : copper_v1_11.zip
    Version     : 1.11
    Date        : July 15th, 2020
    Author      : Matthew "Lunaran" Breit
    Email       : itslunaranyo@gmail.com
    Website     : http://www.lunaran.com/
    
================================================================================
    
    ABOUT COPPER
    ============
We all like Quake, but if we're being honest, its gameplay isn't as tight as it could be. By the end of its development in 1996, id were burned out and just wanted to ship something and take a break (something I came to understand quite a bit as a game developer), and a hurried Doom clone sewn together from dark fantasy was what we got. Over the years since, several high-profile single-player mods have sought to expand Quake's breadth, perceiving problems in its design as gaps that need to be filled and new content as the solution. I wanted to instead polish Quake's existing gameplay the way id might have if they'd taken the time to do so, to improve its depth and clarity as much as possible before considering what could be built on its foundation. 

Copper is therefore meant to be "Vanilla+", targeted at being a drop-in improvement to stock /id1/ gameplay and an equally suitable basis for new mods. It neither adds nor replaces any items, weapons, or monsters. It is not intended to be a kitchen-sink supermod like Quoth or Arcane Dimensions, nor move Quake towards some new 'vision' other than what it already is (or, at best, is trying to be).

A summary, if you'd like to just get the broad strokes and go play:

    - Weapons fire is not blocked by monsters in death animations
    - Ring of Shadows makes enemies less accurate in combat
    - Vore missiles have a less-than-perfect turn rate
    - Ogres are 'partially' Z-aware
    - Zombie edge cases are fixed
    - Armor protection is proportional to current quantity
    - Nightmare skill is 50 max HP instead of turret-monsters
    - Cooperative limits respawns and makes death dangerous

    
    
    INSTALLATION
    ============
Unzip the contents of the zip file into your /quake/ directory, so that the /copper/ folder is alongside, not in, the /id1/ folder. If you already have a previous version of Copper installed, go ahead and overwrite everything.

Start your favorite Quake engine port with '-game copper' appended to the command line. Fitzquake-derived engines such as Quakespasm or MarkV are recommended, but any flavor of GLQuake should do. Play with GL_NEAREST texture filtering, like the dark elders intended.

Please note: running the game with a different -game prefix, or none, and changing the mod to Copper via the console in such engines that support this may lead to unwanted config state being carried over from other mods, leading to potentially unpredictable results. Bite the bullet and make a new shortcut. (Especially before reporting bugs.)

Start a new game and play through any (or all!) of the original episodes, the additional new episode Underdark Overbright, or try out any custom Quake single player map that doesn't require another mod. Retry old favorites!



    CHANGE LOG
    ==========
1.11: July 15, 2020
- Additions
	- Autosaves are now signaled by a subtle sound since lunaran doesn't notice autosaves happen in maps other
		than his own
	- monster_boss now has a 'shootable' spawnflag, for BeyondBelief/Koohoo-style damage sponge Chthons
	- target_lightstyle can cycle multiple styles (set using additional noise-noise4 keyvalues)
	- A func_explobox with 'health -1' cannot be harmed and will only explode if triggered
	- The undocumented Nightmare-only quick-refire behavior on Ogres and Grunts has been disabled for
		philosophical reasons
- Bugfixes
	- Players will fall into a func_void for the same length of time regardless of whether they will be killed
		or teleported to the salvation spot
	- Health and ammo pickup sounds no longer cut each other off
	- Angled items no longer shrink to points when too close to walls
	- Fixed monsters sometimes firing in crazy vertical directions when their target is invisible
	- Fixed more cases that would sometimes cause monsters to shoot behind them
	- Fixed monsters choosing not to fire up or down at targets with large height differences (thx PoolboyQ)
	- Threshold for an "only below" monsterjump changed from 0 units to -16 (step height)
	- 'wait -1' on trigger_monsterjump now works as expected (thx McClone)
	- 'delay -1' on trigger_hurt properly sets the frequency to 0 (ie framerate-dependent as fast as possible)
	- Fixed trigger_hurt ALWAYS hurting monsters regardless of the NO_MONSTERS spawnflag (thx grome)
	- Fixed monsters not being hurt by a trigger_hurt if they aren't moving around in it (thx grome)
	- Stepping off a func_plat after it reaches top will not shorten the delay to less than 'wait' seconds 
		after it reached top (thx fairweather)
- copper.fgd
	- Added func_detail_fence
	- Reference to the health item models no longer broken
	- Certain entities no longer missing difficulty spawnflags
	- Fixed func_bobbing missing the 'angle' key
	- misc other things i didn't note, there will always be something wrong with this goddamn file
	
1.1: June 20, 2020
- Cooperative
    - An improved coop mode that makes death and resources more meaningful:
        - Every player death triggers a 5-second respawn lockout. If all players are dead at the same time, it's
            game over: no one can respawn and the level restarts.
        - Killed players respawn with only starting health and ammo, but keep their weapons
        - Weapons vanish on pickup, but are immediately granted (with ammo) to all players
        - The Megahealth heals all other players to full when grabbed (100 E/N/H, 50 NM)
        - Backpacks dropped when players die cannot be picked up by teammates
        - Vanilla coop can still be played with 'coop 2'
    - Monsters no longer fixate on one player at a time, and will seamlessly attack the most convenient player if
        not infighting. An attack that triggers a pain animation will also now pull aggro for a while.
    - Players will be pushed off a teleport destination or spawn point if they're about to be telefragged
    - Func_plats don't leave right away if another player is near to give them a chance to hop on
    - Friendly fire is always disabled with 'teamplay' regardless of team or pants color
    - Player backpacks do not expire in coop
    - Set 'timelimit N' to allow N seconds between the first player exiting and the level actually ending
    - Frag count shows monster kills instead of how many of your friends you've murdered
    - Added 'target_playercount' for selectively triggering entities based on number of players
    - Setting an entity's 'count' keyvalue to -4 will make it use the number of players as its count
    - Trigger_multiples have an 'all clients' spawnflag to make them respond to every player standing in them per
        active frame instead of just the first client, for activator-specific targets like target_heal

- Gameplay
    - Ranged attacks will now pass directly through a player with the Ring of Shadows without doing harm, but 
        melee attacks do full damage once again. Don't get cornered. 
    - Enemies confused by the Ring will now misfire by a wider margin
    - The Thunderbolt beam now leaps from one enemy to another in a more or less straight line, doing diminishing
        damage to each additional enemy, up to three times
    - Fixed the strange 'three beams' bug that causes lightning attacks to be invisibly duplicated elsewhere in
        the level with an unpredictable offset. (Speedrunners will have to find another way to kill the Vores 
        through that wall in E2M6.)
    - Shambler lightning now stops at the entity it hurts rather than continuing harmlessly through to world
    - Fiends are better at aiming their leap at enemies that aren't level with them, and are now threatening from
        more effective angles
    - Adjusted Perforator spread and movetype to stay effective at close to mid ranges but better fall behind
        the Nailgun at mid to long range
    - Voreball homing turn rate raised from 224 degrees/second to 270. Still dodgeable, more threatening, easier 
        to lead into other enemies, but harder to ignore.
    - Voreballs now home in on an invisible player just as tightly as a visible one
    - All explosions strong enough to gib nearby standing zombies will properly find and gib downed zombies too
        (Chthon lavaballs, exploding spawns, exploboxen), not just a player's GL/RL
    - Monsters lower than their targets will shift their aim from the center of their target toward the top, to 
        try and clear the ledge the target is standing on more effectively
    - Holding +jump while underwater propels the player upward at the same speed as holding +moveup
    - Grunts deal full damage to each other again

- Assets
    - Converted health/ammo items from .bsp to .mdl so they're lit by the environment like weapons and powerups
    - Included seven's shalrath.mdl with added idle animation
    - Fixed texture alignment on Shambler lightning bolt, replaced MSPaint-scribble skin with proper texture

- Mapping
    - Monsters set to 'no telefrag' that fail to spawn do not need to be retriggered now, and will try again on
        their own every half second
    - trigger_push
        - can have its default sound overridden, for water currents or etc
        - ADD_VELOCITY mode is no longer framerate dependent
        - ADD_VELOCITY can limit the player's maximum speed so it doesn't keep accelerating you to infinity
        - pushes gibs now
    - Added target_lightstyle: sets any style to any string at any time. Much less limited than the crummy 
        'oldstyle' system.
    - trigger_inventory deprecated, since the same functionality is better accomplished with a target_items and
        an ALL_CLIENTS trigger. the trigger_inventory spawnfunction will now create the above setup for backwards
        compatibility and print a warning in developer mode.
    - Added CRUSHER spawnflag to func_door
    - Added misc_particlefield for a trigger brush-based version of misc_particlefield_box
    - Added trigger_once_box
    - Added 'mangle' keyvalue to target_meat_fireworks. still defaults to up if left blank.
    - Added 'rand' keyvalue to target_explosion/telefog/meat for randomly staggering them
    - Added support to target_state for < > <= >= comparisons
    - Moved checks for untargeted trigger-spawned monsters to "developer 1" mode only, to reduce pressure on 
        SUB_VerifyTriggerable
    - Removed KILL_LAST trigger_relay spawnflag from copper.def/fgd (was never implemented, flag did nothing)
    - Removed CHANGE_SKIN func_door spawnflag as well (was default behavior, flag did nothing)
    - fixes in copper.fgd:
        - delay not showing up on all entities with targets
        - renamed incorrect 'teleport fog' spawnflag on monsters to 'no teleport fog'
        - trigger_secret_box was duplicate target_secret
        - func_explobox was brush class named misc_explobox2
        - func_flytrain was point class
        - target_setskill was duplicate pointclass named trigger_setskill
        - target_changelevel was named trigger_changelevel
        - targets/targetname/angle not showing up on func_button or path_corner
        - targets/targetname being valid properties of trigger_hurt, trigger_monsterjump, trigger_push, and
            misc_meat_fireworks
        - removed unhelpful direct pastes of the 'nmmonmnomasdfjketc' light style strings

- Bugs
    - Hacked info_nulls that call barrel_explode no longer explode at the origin, and can be triggered more than
        once to match vanilla again
    - Fixed trigger_multiple/trigger_once/func_wall notnull maphacks causing disallowed-precache errors; sound and
        model precaches are now wrapped in a guard function in many places to prevent a late precache from killing 
        the server
    - Fixed 'players only' on target_heal causing it to heal nobody
    - Eyeballs no longer visible when two players are looking through the same intermission camera
    - Fixed keys being duped in coop when dying while holding some
    - Suiciding at the console in coop now properly transfers keys to other players
    - Fixed gnarly coop-only bug that caused zombies that spawn lying down to skip the standing animation and be 
        nonsolid and invincible forever (searching for new targets when they shouldn't)
    - Fixed telefragging another player leaving behind a standing ghost
    - Fixed nailgun not respecting 'sv_aim' (supernailgun left alone)
    - Firing the supernailgun with only 1 nail left will not fire the lesser nailgun if the player doesn't have 
        one - likewise for the super shotgun (vanilla bug)
    - Fixed grunts not lagging their shots if their target is standing still on a moving brushmodel (vanilla bug)
    - Bounds and origin of Rotfish adjusted vertically by 8 units to help them get stuck less (thx ijed)
    - Fixed trains firing their pathcorner targets not setting an activator; will use whatever player is touching
        the train at that moment, and default to player 1 if none are
    - Fixed monsters turning east when stopping at the last pathcorner if the corner specifies no angle
    - Fixed view not fading to the fadecolor if your dead body or head gib falls into a func_void after you die
    - Made func_void plunge triggers 64 units thicker on z by default to make it harder to clear the whole thing in
        one hostframe if already falling very fast
    - Fixed func_void with a custom deathtype string not deducting a frag from players who fall in
    - -1 converts to 0 for func_void 'lip' and 'delay'
    - Fixed -1 not universally signalling 0 for the 'dmg' keyvalue (a func_void with a 'dmg' of -1 no longer gives
        the player +1 HP)
    - Fixed being able to immediately fire a weapon after picking one up or switching due to being out of ammo,
        regardless of firing rate of previous weapon
    - Fixed -1 not converting to 0 for 'distance' on doors and buttons
    - Fixed delay, deathtype, and message not being copied to triggered monsters from their original
    - Fixed sigils overriding custom .message (zendar/bakstein start rune)
    - Fixed missing 'spikeshooter_use' function (1000cuts crash)
    - Bubbles now disappear when crossing any two content types, not when outside water, to emulate weird vanilla
        behavior again (1000cuts health pool bubbs)
    - Changed trigger message print behavior back to id1, ie fire targets and print messages both after 'delay'
        (jumbled/failed message prints in dm456sp)
    - Fixed monsters that were supposed to spawn on doors sometimes being stuck embedded slightly in them
        (dm456sp ogre platform over the nailgun)
    - func_doors with noise1/noise2 override sounds set now use them regardless of the 'sounds' value (dm456sp red
        plumber's tie prop making a clunking noise)
    - Fixed teleporting a monster to a misc_teleporttrain screwing up the train's path and triggering the train's 
        targets (SMEJ fix)
    - Fixed misc_teleporttrain starting at its second pathcorner instead of its first (SMEJ fix)
    - Fixed trap_spikeshooter still being stupid with delay (spawning spikes at the origin, not firing with the
        right timing, etc)
    - Fixed brushwork func_explobox simply never appearing
    - Fixed misc_models with pos1 animations but no targetname sometimes refusing to animate
    - Fixed multiple linked key doors still playing the locked noise on touch after being opened
    - Fixed a trigger_relay with RANDOM not respecting its 'target2', 'target3', or 'target4'
    - Fixed trigger_hurt never hurting monsters regardless of the NO_MONSTERS spawnflag
    - Fixed a target_items that changes your current weapon's ammo not updating the hud until you swap weapons
    - Fixed dog pain animation always being instantly resettable (vanilla bug)
    - Fixed ogre idle sound sometimes immediately canceling its wakeup bark (vanilla bug)


1.05: Jul 16, 2019
    - Enforcer laser damage reduced from 15 to 12, to help compensate for their more aggressive firing pattern
    - PAK0.PAK renamed to pak0.pak to play nice with case-sensitive operating systems
    - Shamblers no longer fire lightning at cockeyed angles when their target is invisible
    - Downed zombies who've had doors or crushers invade their personal space no longer become non-solid (id1 bug)
    - Projectiles no longer have a random chance of nullifying a Fiend's leap in midair (id1 bug)
    - The land-on-head protection delay of Fiends, Dogs, and Spawns will no longer cause them to fail to damage a 
        player on impact if they've just glanced off of something else
    - False positives related to the Ring of Shadows in monster attack checks fixed, so monsters always infer the
        player's presence from his real origin while always trying to attack his fake one
    - Weapon pickups fire their targets the first time they're touched in Coop, then forget them, so maps which
        fire important triggers from weapon pickups aren't broken if everyone already has the weapon
    - Chthon should be less likely to instantly snipe the player when they teleport the moment a lavaball is thrown
    - Quad axe no longer corrupts monster flags or sends Shub flying (thanks to Ian 'iw' Walshaw for these fixes)
    - func_trains now require a spawnflag to inherit speed from their pathcorners, and the keyvalue for setting
        default corner wait time has changed from 'wait' to 'pausetime' to avoid conflicts with stale 'wait' keys
        on various id and custom maps (e3m3, e4m5, k1m3) (thanks again to iw for running interference on this
        issue and patching all my mistakes)
    - Added a developer warning when a trigger spawned monster can't be triggered by anything (more thanks to iw)
    - Player can now jump while standing in the same depth of water as /id1 (iw again)
    - Door wait times are no longer set improperly in the -1 case (E3M7 zombie pit platform) (iw)
    - Intentionally prevented use of boss_death10 killcount hack, as it was only ever used to balance the rotfish 
        killcount bug, which was already fixed (iw)
    - Trigger_relay no longer objerror()s if not targeted (is a warning in Fitz+ but an error in stock engines,
        which caused them to crash e1m5 & e1m6) (iw)
    - Items which are targeted and killtargeted by the same entity no longer fail to spawn (E4M2 'fake' items) (iw)
    - Fixed some monsters (Enforcers, Scrags) being able to see and attack the player while in water, caused
        by arcane conditional failures in engine trace behavior. is this the last bug in traceline2? only the 
        shadow knows ... (found by iw)
    - Spikeshooters that are triggered more frequently than their 'delay' no longer fail to ever fire (iw)
    - Changed late monster/secret stat updates to MSG_ALL (iw)
    - Monsters do their drop to floor test late enough to be properly positioned on movers that don't start at 
        their zero point, important if the movers start in lava/slime (iw for president)
    - Fixed runaway loop error in bbin1 caused by item spawn code (iw is now my husband)
    - Biosuit lava protection max depth changed to 16 units (used to be 24, which seemed too deep, and the above 
        water jump fix made it grow to 28)
    - 'light_lev is not a field' spam in developer mode silenced
    - Powerup sounds are now always precached so sounds aren't broken when using powerup impulses (registered
        Quake has fewer total sounds in it than the original .exe's MAX_SOUNDS limit, and memory is free right?)
    - Monster backpacks make the original ammo pickup sound, and the extended pickup noise is only for pre-placed 
        item_backpacks
    - Doors with a +0/+a animated texture don't desync animation state when blocked or triggered repeatedly
    - Fog change entities now work for all clients, not just player 1
    - Gibbing a fish no longer makes bubbles
    - dev_trigger and dev_invoke cheats no longer work in multiplayer
    - Added 'trigger_inventory' to address the fact that a trigger_multiple targeting a target_items to test for
        a player's stats/inventory only works for the first client due to default trigger touch logic
    - Numerous .fgd errors fixed (monster spawnflags, etc) (thanks fairweather)
    - Fixed typo in Chthon death notification
    
1.0: Jun 20, 2019
    - Initial release
    

    
    DEVELOPER COMMENTARY
    ====================
All of my changes to Quake's single-player and the rationale behind them are explained below. Each has been carefully weighed and tested, from the points of view of both a player and a mapper. (If you want to know what neat stuff has been added for mappers to use, scroll to the end.) In all cases I preferred a light touch, looking for ways to gain maximum benefit by applying minimal pressure to the design. They don't really change the game, and yet they really do.

Over time, my reasons for changes coalesced around a very clearly motivated "spirit" to Copper, summed up in the form of a list of goals:

    - Introduce no new major mechanics; only tweak existing mechanics and their interactions
    - Ensure that any changed or adjusted mechanics are clearly legible through gameplay (no
        invisible fudging of outcomes while hiding causes)
    - Fix the "gameplay bugs" we've all just gotten used to since 1996, without sacrificing
        what value or charm they may have
    - Incorporate players' existing expectations and Quake instincts (don't set the player up
        to feel like their old instincts "betrayed" them)
    - Expand, never reduce, opportunity for skill-based play at high levels
    - Give level designers more options and flexibility to build compelling gameplay and not 
        just pretty rooms
    - Maintain backwards compatibility with Quake's original four episodes and as many custom 
        maps as feasible

Detailed descriptions of every change, as well as the rationale behind each one, follow.


    SHOOT-THROUGH
    -------------
The bug where monsters in death animations act as solid walls to bullets and projectiles has been fixed. Shotguns now feel much more effective at crowd control, especially against large amounts of weak monsters. As individual shotgun pellets add their damage to a target, once enough damage to kill it has been totaled up, further pellets will do 50% damage to that target and continue their trace beyond it at full damage. This works similarly to the Doom shotguns, giving Quake's shotguns the same satisfying feeling of room-clearing penetration, while retaining (albeit reducing) the chance of Quake's trademark shotgun-gibbing. Now, on average, it pays off for the player to maneuver to line up targets in rows when shotgunning, and to use the SSG on crowds.

Nails no longer 'plink' against dying monsters, and grenades do not bounce off of them, passing through instead. Dying monsters are still solid to players and other monsters until the same times in the animations as before.


    RING OF SHADOWS
    ---------------
The Ring of Shadows now protects the player in combat: monsters no longer know exactly where the player is once awakened. They will shoot or melee randomly into an invisible player's general area, hoping to get lucky, usually missing, and sometimes even hitting other monsters. In exchange, the Ring no longer makes all monsters deaf to your gunfire. This makes the Ring function much the same as the Invisibility powerup in Doom/Doom II, but with this addition: ranged attacks always miss the player, even if they would hit dead-on by chance. Getting boxed into a corner in melee is as deadly as ever, so players should take advantage of the confusion to stay light on their feet. The protection against ranged attacks does not extend to splash damage from nearby explosions, or leaping melee attacks.

Dogs are known to be able to hunt using an otherworldly power of perception known as "smell" and are unaffected by the Ring of Shadows once awakened. Fiends are affected just like every other monster, because they have eyes. (To be less facetious about it, it's more fun to watch deadly Fiends dive hard into other monsters by mistake, or over cliff edges, than it is to imagine they can 'just sense' you.)

Mappers almost never bother to place a Ring of Shadows in their levels, and when they do, players are never excited to find one, because the power to merely delay engagement with monsters is of very limited value. The improved Ring is now a very good 'soft' powerup for mappers to place in their levels, especially when hidden before nasty ambushes, when granting the extreme power of a Quad or a Pentagram is too much. Players also enjoy watching the chaos that ensues.

Importing Doom-style invisibility also imported Doom players' perception that invisibility is a "powerdown." The Ring originally blunted melee damage in Copper, but not ranged attacks. It was expected that monsters' confused random shots would make for adequate ranged protection for invisible players, but it created an upside-down situation. Average-skill players who didn't have exact muscle memory for anticipating and dodging attacks perfectly were hit a lot less and liked it, but the unpredictability robbed high-skill players of the ability to consistently avoid hits, sometimes being tricked into dodging into a projectile that "should" have missed. 

Becoming effectively non-solid to projectiles achieves the original intended effect across all skill levels without requiring per-skill mechanical variations, and close quarters being the primary threat dovetails nicely with the Copper philosophy that difficulty levels should vary mostly through number and arrangement of enemies.


    VORES
    -----
Vore missiles have been given a limited turn rate. They will still follow the player aggressively, but sidestepping them is now a skill-based option to buy a few seconds of safety before they loop around again (or to swing them into walls or other targets). Their maneuverability is reduced once their parent Vore has been killed, providing the player another option for shaking them that encourages staying in combat rather than fleeing. 

Vanilla Vores are hard for the mapper to use well because the player response to them is almost always excessive caution, leading to a hard stop on combat. The minigame of "Hide From The Voreball" is so high priority because of their perfect homing that it overrides all other gameplay rather than adding to it, and often forces the player to backtrack through lots of empty map. Fighting a Vore in the open is also a time-delayed death sentence rather than a unique challenge. Mappers therefore tend to deploy Vores alone, frequently as nothing more than turrets. Making Vore missiles home tightly but not perfectly gives the mapper more flexibility to challenge players with Vores in more situations, overlapping in new ways with other monsters, making for more fun level design and combat.


    OGRES
    -----
Ogres are "semi-Z-aware." An Ogre is now much better at getting grenades near their target, no longer mindlessly firing far over the target's head or at walls beneath them, but without gaining pinpoint in-your-face Z-accuracy, so the player retains some of the expected advantage from large height differences. The Ogre feels more threatening from more angles, but not unfairly so.

The typical Z-aware Ogre implementation makes for Ogres that dead-eye the player unexpectedly from any angle, but vanilla Ogres are of limited utility to the mapper because they have a hard-coded firing arc, requiring that architecture be customized to accomodate them. The Copper approach is simple: average the hard-coded angle and the perfect-solution angle. This yields an Ogre which is much more effective at localizing the "bouncing grenade chaos" to the player's vicinity, but still feels like the old Ogre, so the player's existing instincts for fighting them don't need to be relearned. The mapper can therefore use Ogres more flexibly and with greater confidence.

This is the only kind of Ogre in Copper. Z-accuracy is not a mapper-selectable option on Ogres, to maintain consistency and predictability for the player.


    ZOMBIES
    -------
Zombies can be killed by any explosion, not just rocket-strength blasts. Ogre grenades were formerly too weak to do more than knock Zombies down even on a direct hit; they now do extra damage vs. Zombies, enough to gib them. This gives players a few sneaky extra ways to eliminate them by exploiting other monsters.

Zombies still require explosions to kill. The "axe kills downed Zombies" feature from Honey was not adopted. It makes chopping up Zombies a slow chore just to save a rocket, and defuses the tension that comes from encountering Zombies before the player has a way to kill them, which robs the mapper of a whole family of potential designed scenarios.

As a helpful quality-of-life improvement for the player, one hit from the Axe instantly knocks a Zombie over without having to "wear it down" first.

Zombies no longer need to be standing to be gibbed by an explosion. Grenades will still not collide against a downed Zombie and explode (this would lead to too many accidental blasts), but a grenade that comes to rest on or next to one before exploding, or explodes against something else that's close enough, will still reduce a Zombie to chunks. The Rocket Launcher works the same way. To be gibbed by Quad Damage shotgun or nailgun fire, however, Zombies must still be standing.

Monsters no longer get stuck eternally infighting with a Zombie they can't kill. They will attack it until they knock it down, then consider it dead and revert to their previous target. The Zombie will also not resume infighting with that monster when it stands back up.


    SHAMBLERS
    ---------
After a Shambler's first two melee attacks in a row, a chance of making a lightning attack in place of the next melee will gradually build. The "Shambler Dance" of moving in and out to induce but avoid melee attacks remains a viable strategy for a few seconds at a time, but attempting to exploit it continuously is now a more dangerous gamble. Coincidentally, the length of two melee attacks is almost exactly as long as a Shambler can survive sustained fire from the Perforator before dropping.

Players have been heard to complain that once they became skilled at the Dance, Shamblers ceased to be scary. This change still lets players briefly mitigate a Shambler with a practiced series of fake-outs, but infuses the act with a new tension: doing so without an exit plan is as dangerous as it ought to be. Making the strategy less reliable for players makes Shamblers more reliable for mappers: they can now count on a Shambler being a frightening, in-your-face rush monster that forces the player to dance on the move, and not in place.

Shamblers no longer try to fire lightning from beyond the maximum range of their lightning. This bug was largely unnoticeable at the typical scale of Quake's original maps, but became clear as custom Quake levels grew in scope. There is no longer an envelope at the edge of their range within which the charging-up animation is a false signal. (The other potential fix, extending the range of the lightning instead, was rejected out of a desire not to muddy the role of a Shambler as a frightening, in-your-face rush monster with what would amount to the power to snipe the player at a distance.)


    ENFORCERS
    ---------
Enforcers, rather than firing twice in a salvo, begin firing continuously like a turret until they lose line of sight or are interrupted by pain. When encountered in groups or at range, it places greater emphasis on using movement, pain-juggling, and selectively breaking line of sight to manage their threat, which helps all Enforcers feel less like speed bumps and more like a unique threat. To avoid unbalancing the game too excessively in their presence, their laser bolt damage has been reduced from 15 each to 12.

Enforcers have long and likely pain animations, and most only live long enough to fire twice anyway, so this doesn't introduce inordinate difficulty to most maps. It does add one more axis of micro-decisionmaking for players when an Enforcer is on the field, which is one more tool for designers to use to craft gameplay. It also helps differentiate the Enforcer into a more unique role than "better Grunt" or "non-flying Scrag" for both parties. There is an open in space in Quake's menagerie for (to borrow more parlance from Doom2) a Chaingunner/Arachnotron-style enemy, and the Enforcer's lack of a strong role and existing style of attack makes them an ideal fit. 


    OTHER MONSTERS
    --------------
The bug where players could be instantly killed by a Fiend, Spawn, or Dog landing on their head has been fixed. Fiends also have a better sense of when their leap path is clear, and will no longer bounce spastically back and forth across a doorway or at the bottoms of stairs.

Knights have had their health reduced from 75 to 72, enough to make it possible to kill them with three careful and complete shotgun blasts instead of always requiring a fourth.

A Hell Knight's magic spreadfire projectiles have been sped up from 300 to 425. This helps make them less of a spammy non-entity at medium to long ranges, while not making the projectile too fast to outrun at close range or dodge at middle range.

Fixes for the various problems with Rotfish (double kill count, being solid too long after death, shrunken head in death frames, getting stuck at the surface of the water) have all been included. They also swim just a little faster and bite just a little harder, so they're not just fodder.

A Spawn that loses sight of its enemy will, eventually, stop leaping around, giving the player another chance to find and kill it in its sluggish state. This mostly preserves the fun-panic unpredictability of Spawns without them being a never-ending crap shoot, making it easier for the mapper to predict how much health or ammo a player might expend fighting them. This behavior interacts with the Ring of Shadows.

Ch'thon still leads his shots to a degree modulated by skill, a necessary component of his balance when there's only so much that can be done with the level around him. His projectiles now travel faster for each time he's been zapped, to add increasing danger and mounting tension to Ch'thon encounters. The hissing bomb-in-flight sound they now make as they narrowly miss the player is pretty good for that, too.

All monsters (except Grunts) already refuse to infight with other monsters of the same classname, but they now take half damage from attacks by such monsters as well. Vores and Ogres are immune to their own splash damage (but not others'), so they can no longer slowly bomb themselves to death.

Infighting monsters who fail to successfully damage their target for 15 seconds will give up on the infight and revert to their previous enemy, so Ogres on plinths no longer accumulate permanent fan clubs milling around their feet. Monsters who do not have a ranged attack will give up after 10 seconds.

Some monsters' bounding boxes have been shortened vertically, so you can't shoot them by firing into empty space above their heads. This does not fix 64x64 monsters getting stuck in rooms with ceilings lower than the height of a Shambler, which requires engine and .bsp support.


    SKILL LEVELS
    ------------
Monster behavior in Copper is consistent across all four skill levels, and attack frequency is no longer used to artifically inflate the difficulty of Nightmare skill. Nightmare is now distinguished from Hard by reducing the player's maximum health from 100 to 50. This simulates the way that players lean forward and begin playing for keeps only when their health is unusually low, requiring the player to stay in low-health clutch mode to survive. Easy, Medium, and Hard skill levels are still distinguished from each other by the level design.

The highest difficulty level in the game should reward system mastery and high-level play. Monsters in vanilla Nightmare are aggressive to the point of becoming exploitably broken, forced to stand in place and fire continuously when the player is in sight like mindless turrets. This robs the game of an important source of unpredictability, that of monster movements and actions, which in turn only encourages degenerate cheesy tactics from players that aren't valid on any other skill level, so it has been eliminated.

Very few things in Quake's game code (or, for that matter, Doom's) changed with skill level, and this style of design has been scrupulously maintained. The only things that should vary between skill levels are things which are readily apparent and instantly understood. If a map has more monsters and fewer health items, the player understands the harder situation at a glance. If instead the monsters have more health and the health items give less, the difficulty is increased in an opaque and hidden way, because the player's learned expectations are now wrong. Thus instincts developed on Normal would be useless or even detrimental when trying a map on Hard or Nightmare, and vice versa. Since lowered max health is clearly reflected on the HUD, it is immediately understood by the player and instantly teaches them that playing differently is necessary.

The additional Nightmare-only exceptions that make Voreballs 40% faster and Shambler lightning last for 33% longer (and thus do an extra 10 damage) were found to be unnecessary to the new Nightmare gameplay and have been removed. Skill and muscle memory developed on other difficulties for reacting to Shamblers and Vores will serve the player equally well on Nightmare, and are all the more valuable for it. 


    COOPERATIVE MODE
    ----------------

Version 1.1 added a great deal of polish and features aimed at improving Coop gameplay for players and expanding possibilities for mappers interested in supporting Coop mode. The main goal was to reintroduce fear of death, a constant in singleplayer but entirely absent from Coop. With no real way to lose, owing to players always being able to respawn and keep going no matter what, vanilla Coop is a hectic but tension-free shooting gallery. 

A level is now considered failed in Cooperative mode if all players are dead at the same time. Killed players can only respawn as long as there is at least one player currently alive. If the last player dies before anyone has had a chance to respawn, the level resets and must be reattempted from the start. (Singleplayer works this way too, in a manner of speaking, just with a maximum player count of one.) Since this circumstance is vanishingly rare even in a two-player game, a player is now prevented from respawing for five seconds after dying. If another player dies in that window, the cutoff is pushed back a little more, and so on, accelerating the possibility of a Total Party Kill. Death is now dangerous.

Furthermore, unless the level has reset after wiping out, respawned players don't come back with all the ammo and armor they entered the level with. They retain their weapons (since there's no guarantee a level or episode will continue to provide duplicates), but otherwise return to play with nothing to their name but the typical 25 shells. They can have their ammo back, of course - if they can return to the backpack they dropped. Falling into lava or a void thus has the potential to waste vital resources. If this might make finishing the level impossible, players can always try, and start over if they fail - this outcome at least gets them playing again right away rather than degrading to a war of attrition with axes.

Other players are now prevented from snagging each other's backpacks, to prevent accidental deprivation or intentional malice.

Rather than weapons hovering non-solidly and refusing to interact with any player who already has one, weapons can always be picked up, and will vanish as soon as they do, as in singleplayer. To prevent other players from missing out on having the weapon, Copper considers the party as a whole to have acquired it, and it is immediately granted (along with its ammo) to all players. Finding a secret lightning gun when you've already got one should at least be worth some cells, after all.

One more item has seen a party-friendly modification: when a player picks up a Megahealth, in addition to receiving +100 overhealing, all their teammates are restored to full health. (Saving a Megahealth for a well-timed moment in the midst of a tough fight can make a world of difference.)

All of the above changes are siloed to 'coop 1'. The instant and well-supplied respawns and weapons-stay behavior of vanilla are still available as 'coop 2' if you miss that kind of thing. All changes that follow are universal upgrades to both Cooperative modes.

The frag count displayed on the HUD in Coop now sensibly shows monster kills instead of player kills. Teammate kills, suicides and self-owns like visiting the volcano god are worth -5. Friendly fire can also now be disabled in Coop entirely by setting the 'teamplay' cvar to 1.

There is no longer need for players to be delicate around teleporters and spawnpoints out of fear of someone being telefragged. If the sudden appearance of a player would gib another, that player is safely pushed off the destination instead. The teleporting or respawning player appears as soon as the destination is clear. If the other player is prevented from being pushed away by something, or is being intentionally cheeky, the waiting player can avoid being trapped in teleport limbo by pressing jump or fire to force a telefrag.

This fixes the unfortunate side effect of two players falling into a void at the same time telefragging each other when they're teleported back to solid ground. Sorry about that.

Monsters' attention spans are now wide enough to include multiple players, or rather, they no longer make rigid distinctions about which player they're angry with. They will no longer single-mindedly ignore an easy target just because the last player who harmed them is playing hard-to-get. Get too close, or get in their way, and expect to become their new target. Aggro can still be drawn, just not exploited, so no matter what your buddies are up to, you aren't safe from any monster that can see you. This does mean that a Ring of Shadows is a great way to let your allies take more than their share of the heat. (Announcing your presence with the glowing power of a Quad Damage has an effect, too...)

Monsters will still fixate, for a little while, on any player who hurts them badly enough to trigger a pain animation, something experienced Quake players already have muscle-memory for on a monster-by-monster basis. This adds a dimension of battlefield control to Coop that isn't present in singleplayer, making monsters that are easy to stun (like Ogres) easy to manipulate, and monsters which don't stun so easily (Shamblers) more bullish.

A change of enemy is never random. Choice of player to attack is based solely on a simple assessment of range, forwardness-vs-behindness, and visibility. This makes it easy to develop a 'feel' for when you'll pull a monster's attention and how you can lose it, allowing players to make informed split-second decisions with intent to control a fight, rather than only reacting to the unpredictable.

The dreaded func_plat elevator, which begins rising as soon as anyone steps onto it, works fine with one player but is almost guaranteed to split multiple players apart unless they time their movements very carefully. Now, when a player steps onto a plat, it will automatically check a narrow radius for other players who might be about to hop on, and delay movement for about a second to give anyone it finds a chance. Otherwise, it behaves normally. 

The 'timelimit' cvar now has a Coop function. If set, once any player exits the level, the intermission won't be triggered for that many seconds, allowing other players to finish grabbing supplies or anything else they might be doing. Everyone who exits before then still gets to peer through the intermission cameras, and can even pan them around.  


    HEALTH
    ------
One-point-per-second health degradation when overhealed is now something that simply always happens to every player's health (above 100, or 50 on Nightmare), and is no longer tied to recent Megahealth pickups. Grabbing two Megahealths no longer leads to your health ticking down at twice the rate, and should anyone venture into Copper multiplayer, their health will no longer stop rotting if someone else picks up the same Megahealth after it respawns.

Some health pickups have been given a visual pass. By popular request, +15s are now a little smaller than +25s, to more clearly distinguish them. Megahealths now look a little more ornate (only a little - they're still adorably cubic) and have a unique top texture, so they're no longer generic brown boxes when viewed from above. While this is a break with the "canon" that +15s are rotten +25s, and thus should look similar, too many players seemed unable to tell the existing pickups apart even with extra rot smeared on.

The 50 HP 'safety buffer' that players are healed up to if they finished a prior map with low health is disabled on Nightmare.


    ARMOR
    -----
The percentage of damage diverted to armor is now proportional to the number of armor HP the player has, rather than always being inherited from the last armor picked up, but otherwise closely matches the original protection amounts players are accustomed to. For example, Red Armor still absorbs the lion's share of damage at first, but effectively 'degrades' to Yellow and then Green protection as it's shot away. The HUD icon still changes color to indicate protection strength, just like before.

This alleviates the effect of a Green Armor lasting longer than a Red Armor, as well as the sudden spike in health damage the player takes after the last points of a Red Armor are lost and the player is left suddenly naked. This also simplifies away the player's awkward mental calculation of deciding whether or not to pick up an armor item when it would raise their armor quantity but lower their armor strength.

The only interaction a player has with an item is to pick it up, so the only decision an item introduces to the game is when to do so. The complex secret armor pickup math of vanilla Quake doesn't make that decision more compelling or interesting, just more opaque. Since the value of an armor pickup is now proportional only to its quantity, more is now unquestionably more, and the only deciding factor is how many points would go to waste. This also helps the mapper predict and adjust difficulty, because every armor granted to the player will wear down and reduce its protection in the same way, while retaining the relatively higher values of Yellow and Red Armor.

'armorvalue'/'armortype' keyvalue hacks still work as normal on monsters.

Armor is now shielded by the Pentagram of Protection, just like health. While the old behavior of still losing armor while invulnerable was something that players were probably used to (those who noticed, at least), it never quite fit the concept of invulnerability, and may very well have simply been a bug. The stylish 666 on the HUD also prevented the player from even knowing how much armor they were losing until the Pent had expired, so this removes the mystery.


    NAILGUNS
    --------
To help distinguish the two nailguns from each other, so that the Perforator is less of a straight upgrade, the velocity of nails from the Nailgun has been doubled, while the Perforator has been given a little spread (comparable to the Shotgun). This makes the Nailgun better at long-range needling (to reduce the necessity of efficient-but-boring shotgun sniping), while the Perforator is just as good as always at close DPS but potentially wasteful at range. Their damage outputs are unchanged.

The Perforator now fires two regular nails at once, rather than one nail that is "better", to better leverage the aforementioned shoot-through. When the player uses the Perforator with a Quad, the two spikes' damages are always combined against one target, to ensure there is no reduction in ludicrous gibs compared to vanilla Quake.


    THE AXE
    -------
Players no longer alert monsters by swinging the axe without hitting anything.

The axe view model has been reanimated at 20fps. This makes the axe feel a lot more responsive and satisfying, as the damage frame now lags less behind the attack impulse. Axe damage has also been raised slightly (from 20 to 24), so that it takes exactly as many hits from the Axe to kill any given monster as it takes complete hits from the Shotgun.

The axe now makes sounds when hitting monsters or damageable brushmodels.


    AMMO DROPS
    ----------
Ogre ammo drops have been reduced to 1 rocket each (from 2). Vanilla Ogres were 'ammo neutral' in that it took two grenades (or two grenades worth of shotgun or nail damage) to kill them, and two grenades were dropped in return, so each Ogre was effectively a means of converting other ammo into rockets. The level designer could not then give the player a grenade launcher or rocket launcher without making them instantly overpowered thanks to all the rockets they'd saved up, due to what a bread and butter monster the Ogre is. This change improves the mapper's ability to make rockets rare if they choose, without having to so severely limit use of Ogres.

Enforcers no longer drop any cells for the same reason.

Small and large rocket ammo pickups have been reduced to 4 and 8 (from 5 and 10) to give the mapper slightly finer control over the quantity of rockets they dish out. This doesn't actually seem to affect the balance of most existing maps too badly, because a perception that rockets are more rare causes players to maximize their value by using them more on groups and big bads, rather than casually spamming grenades around corners or using the rocket launcher to frag one Knight at a time. The CanDamage() bugfix has also been applied, making explosions less likely to skip targets within their blast radius, so rockets and grenades should compensate in application by feeling a bit more powerful against groups.

All small ammo pickups are now centered on their bounding boxes. The rocket ammo pickups have been redone to match the scale and style of the other ammo boxes, and no longer depict weird fat & skinny rockets.


    LIQUIDS
    -------
Monsters now take damage from immersion in lava or slime. They can wade in it without issue, but if they should get in "over their heads" in a place they can't get out of, they won't run around hidden under the surface forever. Monsters pre-placed in lava or slime remain immune to both so as to not break backwards compatibility with existing maps that hide them there on purpose, but they lose their immunity once they fully leave the liquid. Zombies and Scrags are always immune to slime; Zombies because you can't poison the dead, and Scrags because they spit slime and there's no good way to stop them flying into it anyway. Zombies which take damage from lava are gibbed, because that's the only damage that's meaningful.

The bug that caused drowning damage to be partially subtracted from armor has been fixed. The speed at which drowning damage escalates has been cut back a little instead, so that water is still only proportionately as deadly as before. It's about making the player panic so they drown themselves, after all.

The player recovers most of the damage they took from drowning once they're above water again (or if they find themselves a biosuit while drowning). Short choking episodes do no permanent damage, but the longer the player goes without air, the more health is lost permanently. If they dive below the surface before the recovery is complete (in other words, before they get their wind back) the onset of drowning damage comes sooner and harder the next time. This makes players feel a bit more free to explore underwater just a little too long for only short-term risk but no permanent penalty, which should in turn help mappers feel more comfortable with use of swimming gameplay (especially to make the player feel uncomfortable ...).

Drowning damage and recovery (and only those two things) are reduced by half on Nightmare, to stay in proportion with the player's maximum health. Otherwise, shortening the drowning timer so severely may make long underwater segments in some maps not just more scary and deadly, but physically impossible to complete.

A biosuit's protection against lava reduces the player's effective depth in lava by one step (ie if immersed in lava, damage is taken as if chest-deep, and so on). This makes a biosuit effectively proof against lava that is only ankle deep.


    KEYS & RUNES
    ------------
Players can carry more than one key of the same type, should they happen across any. Quake reminds players how many they have with an upper-right-corner print when they grab or use one, and the icon only disappears from the HUD once the last key has been used.

This required a change to how keys work in cooperative play. Keys now disappear when picked up in coop just like in single-player, meaning whichever player grabbed it is the one who has to open the door with it. If that player dies or disconnects, held keys are automatically transferred to a different living player to ensure a map is never made impossible to finish by "losing" a key in an unreachable place. If all other players are dead when a keyholder dies in 'coop 2', that player simply respawns with their keys.

This opens up a family of nonlinear level layout possibilities that use duplicate keys to grant the player some choice in which progression gates to unlock in what order, or to promote certain other gating mechanisms to a higher 'tier' than buttons, without the awkwardness of players being unable to pick up a key when they already have one.

Preach's fix for the "restarting after dying loses your runes" bug has been gratefully incorporated. Players can now safely hero it through all the haunted lands of Quake without resorting to quicksaving if they so desire.
    

    MISCELLANY
    ----------
The explobox recursion crash fix has been applied, so barrels-o-fun style usage is possible. Explobox solidity type has been changed to BSP, so the small explobox no longer has a strange tall bounding box, and players can stand and jump up and down on top of both small and large exploboxes (including suicidally barrel-jumping off the tops of them and not just the sides).

Splash damage indirectly activating shootable doors and buttons has been curtailed. Splash radius is reduced by two thirds vs damageable brush entities, so explosions must happen closely enough to be intentional. This preserves the player's ability to use rockets and grenades to activate such entities (and thus the mapper's ability to use them that way), while preventing players or monsters with splash weapons from doing so accidentally.

The flying teleport ball from the final Shub level has custom movement code rather than using func_train functionality, so while it moves the same as it used to, it can no longer cause the onerous MOVETYPE_PUSH crash if you touch it wrong.

Intermission cameras will slowly cycle automatically, or can be cycled by players, to ogle every view of the nice level art they didn't notice while deep in skill-based high-level play. Since whichever of 'Jump' or 'Fire' is rebound to cycle the cameras is guaranteed to annoy the 50% of players who use that button, and never the other button, to exit the intermission, intermission cameras in Copper are instead cycled using Impulse 10 & 12 (the next weapon/previous weapon impulses), which most players will likely have bound to the mousewheel.



    STUFF FOR MAPPERS
    =================
A non-exhaustive list:

Smoothly blending fog functionality from Honey/AD, and fog control/transition entities (both a one-time blend entity, and a trigger volume that transitions the fog based on the player's position inside it, so moving back and forth in a hallway doesn't lead to the fog swapping mysteriously at either end). Fog values can also be set on every player start, teleport destination, and intermission camera, so the player's fog can always be set to desired local values.

Plenty of mapper quality-of-life additions have been adapted from Quoth and other places, such as: 
    - every monster can be configured as a spawner
    - four targetN keys on all entities (targetnameN keys were not found to be worth the code complexity)
    - bounding-box point triggers
    - func_everything support for external bsp/mdl models
    - auto-spawning or respawning items
    - toggleable func_walls (either solidity & visibility, or +0/+a texture state)
    - a generic ambient_sound entity
    - 'not in coop' and 'coop only' spawnflags 4096 & 8192 supported on all entities
    - misc_model for .mdl decorations and obligatory dead bodies and candles
    - override obituary messages with the deathtype keyvalue on all entities
    - angle keys work on ammo and health - without the need for special ammo models or a worldspawn key
    - impulse 205 kills all monsters without breaking level scripting
    - worldspawn gravity key
    - smooth movement for flying/swimming monsters, including z-axis path walking fix
    
Useful new entities:
    - func_void: for Quoth trigger_void levels of utility plus Honey's pit-death levels of polish, including a nice scream, an even better meaty splat, and integrated "punishment teleporter" alternate functionality.
    - target_items: Add/subtract/override/check for item/weapon/inventory/stat loadouts on players through an entity. Do useful stuff like test mid-episode maps with an estimated set of starting gear, without having to play through the previous maps. 
    - target_lock: selectively enable and disable other entities, including triggers, trigger_relays, and path_corners.
    - func_flytrain: smooth, curvy motion along a chain of path_corners.
    - target_autosave: saves the game to auto.sav when triggered, can be loaded from console.
    - info_teleport_target: teleports the activator to it when triggered, for complex scripting where using teleport volumes won't do
    - target_explosion/target_telefog/target_meat_fireworks: configurable effects on demand without barrel_explode5 think hacks
    - item_backpack: a small ammo reward for those little hideaways that aren't really full secrets (okay, one new item)
    - and more

Quake2- & Quake3-style noclip mode which prevents all interaction with the level, so you can fly around without waking monsters and touching stuff.

Override and customize light stylestrings through keyvalues, to create any custom flicker/pulse/discoteque you desire. Triggerable lights can also be toggled between off and a lightstyle.

The most configurable monsterjump trigger ever: include a monster by classname, exclude a monster by classname, plus spawnflags to only allow 32x32 or 64x64 monsters, only melee monsters, as well as "only if my enemy is below me" and "only if my enemy is in front of the trigger."

Coop starting spots can spawn disabled and be enabled by trigger during gameplay, so you can gradually move the coop starts forward to keep them close to the action (or on the correct side of backward-progression blocks).

Trigger_hurt can be set to ignore monsters and/or biosuited players. Target_items can be used to, among many other things, make any trigger ignore invisible players.

Any skip-textured func_ entity can be effective as "creatureclip" with the 'notrace 1' keyvalue. Note: creatureclip is still solid to players, and is used primarily for making monsters walk over grates or other fancy holey floors without blocking line of sight or weapons fire like normal solid skip.

nomonsters cvar is functional.

All of the above was implemented while paying careful attention to backwards compatibility with existing /id1 maps, both stock and custom. Even some of negke's maps.



    STUFF FOR MOD AUTHORS
    =====================
Full QuakeC source is included. You may, and are encouraged to, use it as a base for additional mods, adopting or adapting features, or merely to learn from. Compiling it requires FTEQCC (any version from at least 2018), by Spike, available as of the writing of this document here: [ http://fte.triptohell.info/ ]. Other compilers may work, provided they support a few syntax upgrades (such as field masking and not requiring the 'local' keyword) as well as #pragma autoproto. If you're unsure if your compiler will work, try it and it should tell you. :)
    
    
When extending Copper for your own mod, I strongly encourage you to use the complete corpus of gameplay tweaks described above if you use any, rather than sampling what may be your favorites. This will avoid fracturing for players the 'gameplay base' that Copper strives to provide. Copper touches many aspects of the game in small but significant ways. If every mod were to include a different subset of these, the play experience for each player would be muddled by a trepidatious series of accidental discoveries of which way the player should expect them all to function *this* time, rather than being able to take the entire package as a given *every* time.

Consider the conventional Z-aware Ogres, the ones with perfect aim. When you play a Quake add-on that includes them, how do you learn they're there? Is it in the readme? Does the game warn you? Or do you find out the hard way, the first time one shoots you in the face from an angle you thought safe? Now consider this problem of relearning part of the game as you play, but multiplied across every alteration in Copper. Players could no longer take the presence of any one Copper feature as an indicator of the presence of any other, and while your mod may be that little bit more like the Quake you want others to play, such subtle but constant confusion would, I feel, make Quake a little worse for everyone.

Kell released Quoth closed-source, and cited as a reason a desire to avoid such fracturing caused by "everyone compiling their own interpretations of Quoth." While I feel that's a little too protective, I understand the sentiment. However, a great deal of the mapper features in Copper originate from Quoth, and had to be re-engineered from scratch on my part without any source code to work from, and I won't let any of my personal (and possibly selfish) reservations lead me to do the same to you. The source is provided happily, because this is still better for Quake overall no matter what people may do with it. Everything will work out okay in the end.


    ENTITY DEFINITIONS
    ------------------
id's original means of generating editor entity definitions was to overload block comments. Every comment block that opened with "/*QUAKED" was considered an entity class definition, whose first line was treated as a formatted metadata definition of name, size, color, and spawnflag names (point/brush status was inferred from presence or absence of a defined size). Everything else in the comment was treated as a descriptive docstring. QuakeEd itself simply scanned the QuakeC game source for these comments directly and built its definition library from there. /*QUAKED*/ definitions could thus be kept alongside the code for the very entities they described, making it easy to keep them updated and accurate. 

Future Radiant map editors that built on QuakeEd moved toward loading them all from one file, with a .def extension, but not changing or extending the syntax at all. The far more common format in use now for entity definitions is Worldcraft's FGD format, now used most prominently by Kristian 'sleepwalkr' Duske's Trenchbroom editor, because it supports quite a bit more metadata regarding keyvalues and their required types, while the QuakeEd/def system only supports this insofar as there's a large block of text in which developers can describe them in plain English.

I have chosen to support entity definition maintenance for FGD in the same way that the QuakeC source originally supported it for QuakeEd: by using comments within the source itself. The Copper source code still includes /*QUAKED*/ comments, adding and updating them wherever relevant to keep them up to date, because while Radiant and QuakeEd users are rare today, they do still exist. :) You will commonly find these paired with comment blocks beginning with "/*FGD" now as well. While editors like Trenchbroom do not scan multiple files looking for such comments, the notation made it easy for me to automate extracting the two types of comment blocks and compiling their contents into respective .def and .fgd files. 

The Python scripts I used for these two tasks are included with the QuakeC source. They should Just Work(tm) provided Python 3+ is installed correctly, which is left as an exercise for the reader. 


    CODE REFERENCE
    --------------
Here are some handy notes on important functions:

    enemy_vispos(), ai.qc
    ---------------------
Any time a monster would use the vector stored as self.enemy.origin, be it for a line of sight test, launching a projectile or some other attack, or any other purpose, enemy_vispos() is called instead. Normally it simply returns self.enemy.origin anyway, but if self.enemy has a Ring of Shadows, it instead returns an origin offset in a standardized noisy way, so that the Ring confuses all monsters identically for gameplay purposes. Be aware that any time you bypass this function and use self.enemy.origin directly, the code in question will not be affected by invisibility unless you check the IT_INVISIBILITY flag manually (the most obvious example being ShalHome() in m_shalrath.qc).

    traceline2(), projectiles.qc
    ----------------------------
traceline() can only ignore one entity at a time. To support the 'notrace 1' keyvalue for creatureclip, secondary traces have to be made to continue the trace through any hit notrace 'bmodels' which should be skipped by the trace. traceline2 is a wrapper for this functionality, and will perform any necessary extra traces automatically for you, modifying all the output trace_* global variables to contain accurate unified results as if a single trace had been performed. Thus you can use it exactly the same way you would traceline(), and in fact, you probably should pretty much everywhere.

Note that this is not the same code that enables shotgun penetration, although it is similar. That code is in FireBullets() in w_shotguns.qc (because it needs to apply the special case of adding damage to each TAKEDAMAGE target it passes through). You will notice that even this function still uses traceline2(), because players should be able to fire shotguns through both dying monsters and notrace bmodels at the same time.

    CheckProjectilePassthru() & etc, projectiles.qc
    -----------------------------------------------
traceline2() may work for hitscan and line of sight traces passing through a 'notrace' bmodel, but does not help in the case of point entities we would also expect to pass through them, such as nails, grenades, or gibs. These required a little more work. To enable such entities to pass through creatureclip, their touch functions should call CheckProjectilePassthru() and return without doing anything if it returns true. Note that this code IS used for allowing point entities and projectiles to pass through monsters in death animations, unlike traceline2() and FireBullets().

Much more information on understanding and working with point entity passthrough can be had in the comment blocks of projectiles.qc.

    launch_projectile(), projectiles.qc
    -----------------------------------
Code duplication in projectile and shooting functions across the codebase was cut down for convenience, and all such functions were gathered together into this file. All nails, rockets, lavaballs, grenades, etc, are spawned by one function or another that either calls launch_projectile() or something else which calls it and modifies the projectile it returns.

    CheckValidTouch(), items.qc
    ---------------------------
Checks at the top of touch functions whether 'other' is a player, is alive, and isn't in NOCLIP were becoming ubiquitous across all triggers and items. Any touch function activated only by players can call this for all-in-one confirmation. 

    mon_spawner(), monsters.qc
    --------------------------
Copper unifies a monster, a triggerable monster spawn, and a repeatedly-triggerable monster spawner into the monster itself. A monster's spawn function is split into two, with initial game frame necessities (such as precaches) separated from actual spawn completion code (such as walkmonster_start()). Initial setup remains in the monster's classname function, and spawn completion is moved to a second function, universally named as monster_classname_spawn().

The unification is accomplished by way of function objects. First, the classname function calls monster_spawnsetup() and passes it the name of a function which will spawn the monster in question when called. This should be a single-line function (universally named as monster_[name]_spawner()) declared uniquely for each monster, which injects some universal monster spawning code into our monster's spawn completion function by calling mon_spawner_use() and passing the spawn completion function as a parameter. This is a little convoluted, but is necessary so that each monster spawner's Use function is both customized to one monster and callable with no parameters (required by the .th_use field prototype). monster_spawnsetup() checks all the possible spawner configuration states and spawnflags by itself, which are universal across all non-boss monsters. It returns True if the classname function should stop before continuing on to spawn the monster directly (ie, call the spawn completion function). 

Examine any monster's source file (m_*.qc) and scroll to the bottom for an example. To support triggerable monster spawning on a new monster, you need only ensure spawning code is split in the same way, and uses monster_spawnsetup() and mon_spawner_use() the same way. Note that spawnflags 1-5 and 8 are already reserved for spawner configuration, so new monsters will have to make do with flags 6 and 7. There are plenty of spare keyvalues should you feel you need more flavors than that. (at which point the game designer in me asks, "shouldn't that just be more than one kind of monster?")

    

    PERMISSIONS
    ===========
You are free to distribute by any electronic means copper.zip, unaltered. Do not distribute new maps made for Copper by repackaging the Copper progs.dat or assets with the map; distribute the map standalone and clearly list Copper as a requirement. 

The original QuakeC game source code on which Copper is based is copyright id software, so mods based on Copper cannot be exploited commercially.
    
    
    
    ACKNOWLEDGEMENTS
    ================
Special thanks to:
    - Scampie for endless testing, ideas, sounding and discussion
    - Spike for FTEQCC, and putting up with my stupid questions
    - Preach for providing QuakeC programming sanity checks, ballistic theta code, and for an explanation of how to implement Quoth's drifty fly and swim movement without running into the same bugs they did
    - czg for the fog code in honey_fog.qc and the brilliant and terrible stuffcmd_float() (his maps are ok too)
    - Bal, ijed, ionous, negke, JCR, mfx, sock, muk, and NewHouse for testing
    - VuRkka and zigiii for extra coop testing
    - iw for diligently identifying, and providing example fixes for, a bunch of bugs in 1.0
    - the entire Quake community for making so many other great mods over the years, because all the different visions of what Quake can be make this game what it is

Assets not by the author:
    - g_shotgn.mdl is from Rubicon2, by John 'metlslime' Fitzgibbons
    - Ranger falling-to-his-death sound is from Quake3:Arena, by id software
	- Autosave sound by markie music
    - Backpack pickup sounds are from Arcane Dimensions, by Simon 'sock' O'Callaghan et al
    - deep1.wav and machlp.wav are from Arcane Dimensions, by Simon 'sock' O'Callaghan
    - underw1.wav, wdribble.wav, and wpool.wav are from Rubicon2, by John 'metlslime' 
        Fitzgibbons
    - shalrath.mdl modified by 'seven'




================================================================================

    June 20th
    2019

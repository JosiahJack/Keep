/* to do list:
required
- .... - long menu titles
- .... - new animations for strafe
- .... - update grenade + raw paths/detection
- .... - flashbang reaction
- .... - listening bots
- .... - sweeping mp5, mp5sd
- .... - newsflash
- .... - readme
- .... - detect raw
- .... - replace game specific stuffs
- .... - have bots be affected by flashgrenades
- .... - temp1 -> detect glquake
- .... - sound alert (gun firing)
- .... - deal differently with corpses
- .... - nearby enemies during spread out
- .... - use strafe attack
- .... - drop "already checked" notes
- .... - coop direction?
- .... - continue patrol after check
- .... - run to help time out
- .... - machine gun trace_attack
- .... - sit down animations
- .... - realistic clip contents
- .... - hunt enemy
- .... - attack probably depends on visibility only
- .... - solve blocking near waypoint
- .... - invalid spread positions
- .... - alert by doors/elevators/plats
- .... - detect enemy, if hit from behind, aside
- .... - have members evaluate their shots
- .... - implement .team for team coordination entity
nice
- .... - have strafe attack move and face correctly
- .... - implement retreat
- .... - ouch during roll
- .... - code grenade target points
- .... - separate anim and think
- .... - prevent long distance melee attacks
- .... - program shortcuts in waypoints
- .... - zig zag attack?
- .... - determine when members should run (cohesion, enemy...)
- .... - implement L formation
postpone
- .... - have members use broadcast messages, under control of variable
- .... - reimplement patrol timeout
- .... - have pointman ignore everything except for enemies
- .... - "jump while diving to the ground"
- .... - have bots turn in a more realistic fashion
- .... - wait and assemble if waypoint difference too large
- .... - team decide to assemble
- .... - move while firing (part of the animation)
- .... - team Beta
- .... - buddy
- .... - marker for last known location of buddy
- .... - sounds (keywords like "sweep", "negative", "roger", "recon", "area"
         "sitrep")
- .... - carry dead buddy

======= done before releasing private beta 5==(v2.0.1)========================
- done - pdude now only as 12 bullet clip mk23
- done - bots use flashbang grenades
- done - have mp5 bots use mp5/mp5sd (hack)
- done - weapon_nailgun?
- done - why M16 launch?
- done - test multiplayer
- done - rewrite menu
- done - rewrite weapon spawn
- done - "died" message
======= done before releasing private beta 4==(v2.0)========================
- done - coop launch?
- done - detect/crash netgame
======= done before releasing private beta 3==(v1.3)========================
- done - frag problems (don't disconnect)
- done - remove private frag admin
- done - improved wait/draw gun animations
- done - also ambush when first man
- done - decide to ambush/wait instead of attack
- done - improved infront (wider view angle)
- done - changed problem squad insertion waypoints
- done - team exits ambush -> patrol/draw
- done - adjust wait/sit/draw behavior for guard.mdl
- done - adjust spread out times (distinguish between waypoint and
         enemy)
- done - version info

====== done before releasing public beta 3==(v1.2)==========================
- done - .team bug

====== done before releasing public beta 2==(v1.1)==========================
- done - deathmatch 24, 25 (no stuff), 56, 57 (fast deploy), auto deploy
- done - bot machine gun firing (3 shot burst)
- done - reload aborts firing
- done - "mission" messages removed
- done - run if in water or slime
- done - fast insert of bots
- done - updated credits
- done - no grenade throwing to dead enemies
- done - continued bot scores
- done - less sensitive for slime, waste
- done - first assembly touching member to go for pos 1
- done - have member sit during attack if other member behind him
- done - defend/roll
- done - remove roll state
- done - draw state
- done - attacks uses anim from draw state
- done - mixed team composition
- done - faster walking (guard)
- done - bot check frames
- done - method to distinguish between member role
- done - menu option to toggle squad composition
- done - game option for squad composition

====== done before releasing public beta 1 ==(v1.0)=========================
- done - detect target and no_target
- done - have members swim correctly
- done - check EveryFrame/damage
- done - faster menu disable
- done - bots now move out of water/slime
- done - prevent check soon after waypoint visiting
- done - deathmatch (start near exit/start, auto respawn, items)
- done - prohibit closeby grenades
- done - adjust fire tempo
- done - evade hand grenades
- done - recognize hand grenade
- done - side checking during patrol
- done - only spread if necessary
- done - pre-throw check, spread
- done - multiple reassembles during deathmatch
- done - include all pdude animations
- done - faster pistol firing
- done - pre-throw handgrenade path check
- done - HuntEnemy may start with throwing a grenade
- done - remove team if members killed
- done - head hits (mk23 only)
- done - grenade throw code
- done - customizable aiming precision
- done - solve lava - pain1 stack overflow bug
- done - add hand grenade animations
- done - spread roll
- done - team debug
- done - spread out in team state
- done - assembly/spread/script direction
- done - add spreading waypoints
- done - add waypoint timeouts
- done - improve CHECK (ideal_yaw ...)
- done - improve SPREAD out AI (follow waypoints until seen)
- done - entry/exit SOP
- done - look for marker during runtohelp
- done - faster walk, run
- done - check implemented
- done - no target option in debug menu
- done - spread implemented
- done - SPOT renamed to GUARD
- done - waypoint entity defs for WorldCraft
- done - water level (EveryFrame)
- done - Waypoint_Spawn -> Waypoint_Create, separate waypoint script
         flags
- done - added pain sounds
- done - fixed deathmatch 9 respawn bug

====== done before releasing private beta 1 ================================
- done - solve elevator bug
- done - skilled precision
- done - death sounds for pdude used
- done - menus (5 entries, credits, all weapons)
- done - change direction in deathmatch mode
- done - correct player respawn position in dm 8, 9
- done - implement "TF-like" menu's to position bot enemies
- done - add game mode (Infiltrate Start-to-Exit, Exit-to-Start, no respawn
         of bots/player)
- done - random spawn for Start-to-exit, Exit-to-start squad
- done - waypoints to room upstairs
- done - bots of a team share team color shirt and pants (via team)
- done - detect nearby enemies from all directions
- done - melee attack
- done - reload while empty bug!
- done - add menus (#bots, waypoint visibility, team state, member state
                    help)
- done - improve huntenemy, especially for long distance
- done - door touch bug
- done - renumber waypoints, % 100 denotes area
- done - have members communicate
- done - member requests assistance to team, based on # of enemies
- done - plan reloading during patrol (random moments)
- done - use run animations for members that have urgency
- done - menu entities and mechanism added
- done - correct run animation to move quicker
- done - member asks "line of fire" blocking other member to move out
- done - add waypoint near elevator
- done - have bots enter formation more flexibly
- exit - parachute drop
- exit - no long distance axe attacks
- done - plan reloading during regroup
- done - solve return from reloading (pain)
- done - eject shells when firing
- done - reloading, reload during attack
- done - reload animation
- done - have some members sit upon assembly
- done - correct administration errors if bot leaves formation
- done - stop rotating while sitting in SPOT state
- done - "smaller" square formation
- done - have some members sit upon assembly
- post - position assembly positions some distance from waypoint
- done - use markers instead of touch to position members
- done - allow members to occupy higher priority positions if
         they arrive there; re-route others (do so in touch)
- done - have markers have associated entities
- post - axe run animations
- done - headers for sQuad .qc files
- done - prevent members from being assigned to 2+ assembly positions
- done - make assembly positions into entities
- done - implement strafing for pdude mdl bot
- done - modified Navy SEALs files: ai.qc, buttons.qc, combat.qc, doors.qc,
         weapons.qc, items.qc, monsters.qc, plats.qc, triggers.qc, world.qc,
         client.qc

====== done before integration with Navy SEALs =Sept 30, 97 ================
- done - document changes of SEALsQad to normal QuakeC code
- done - have line and L formation look for wall themselves
- done - have members looking for removed stuff patrol again
- done - code assembly formation in waypoint
- done - use movetarget in debug info
- done - have members hop across inclines
- done - solve hangup
- done - rewrite reselect
- done - have bots dodge each other
- done - select waypoints based on current contents
- done - solve freeze after target kill (reset all attacking bots)
- done - add waypoints for alternative routing
- done - do low level movement code in Anim
- done - change waypoint system to use names and autoconnect
- done - add pain state
- done - have bots jump
- done - bots in stats screen
- done - team detect front man
- done - also use ReselectWaypoint to determine point man
- done - mark waypoint visited for bots that assembled
- done - code assembly points in waypoint
- done - team behavior
- done - team states: assembly and spotting
- done - faster pain animation
- done - init spotting
- done - time outs for attack and waypoint
- done - export version
- done - implement change weapon method
- done - smart dive for missile during attack
- done - waypoint touch
- done - careful shooting (not team members nor walls)
- done - remove bot*.qc from source
- done - strafe animation
- done - waypoint reselect function
- done - one way waypoint visiting in coop mode
- done - have bots attack monsters
- done - delay after weapon change (EveryAttack)
- done - different (numbered) S.E.A.L. skins (0 - base, 1..4 numbered)
- done - all weapons
- done - direction coding in waypoints (affected during reach)
- done - waypoints for e1m2
- done - code "buttons" in waypoints
- done - target detection if in front
- done - target detection delay (0.1 - 0.2) ! in set_state, not ideal
- done - marker for last known location of enemy

- exit - target detection if audible (turn around)

- post - secret door handling
- post - forbidden status of unreachable stuff

*/


/* modifications to original QuakeC files:
--------------------------------------------
ai.qc - no changes:
void() FoundTarget =
{
        if ((self.enemy.classname == "player") || (self.enemy.classname == "bot"))

void FindTarget ...
//
// got one
//
	self.enemy = client;
// BG Bot - begin bot recognition
        if ((self.enemy.classname != "player") && (self.enemy.classname != "bot"))
// BG Bot - end bot recognition
	if (self.enemy.classname != "player")
	{
		self.enemy = self.enemy.enemy;
// BG Bot - begin bot recognition
                if ((self.enemy.classname != "player") || (self.enemy.classname == "bot"))
// BG Bot - end bot recognition


--------------------------------------------
buttons.qc - no changes:
void() button_touch =
{
  // hack for button location dectection
  if (WAYPOINT_DEBUG)
    { dprint("button @ ");
      local vector button_center;
      button_center = self.mins + 0.5 * self.size;
      dprint(vtos(button_center));
      dprint("\n");
    }

  // BG Bot - bot recognition
  if ((other.classname != "player") && (other.classname != "bot"))
	if (other.classname != "player")
    return;
  self.enemy = other;
  button_fire ();
};


--------------------------------------------
client.qc:
ranking code + frag code
--
many changes, scoring code/quake world?

--------------------------------------------
combat.qc - no changes:
T_Damage modified


--------------------------------------------
defs.qc:
--
float IT_GRENADE = 4095;

--------------------------------------------
dogs.qc:
--
some parameters changed;

--------------------------------------------
doors.qc:
door_touch, secret_touch modified
--
addition in func_door_secret

--------------------------------------------
impulse2.qc:

--------------------------------------------
items.qc:
health_touch, armor_touch, weapon_touch, ammo_touch, BackpackTouch
--
bound_other_ammo, ammo_touch!!!, item_shells, item_cells, BackpackTouch!!!,
DropBackpack

--------------------------------------------
monsters.qc:
monster_use
--
no changes

--------------------------------------------
plats.qc:
plat_center_touch, plat_outside_touch
--
no changes

--------------------------------------------
triggers.qc:
multi_trigger, multi_touch, counter_use, tdeath_touch, teleport_touch,
trigger_skill_touch, trigger_onlyregistered_touch, trigger_push_touch,
--
no changes

--------------------------------------------
weapons.qc:
ImpulseCommands calls CheckSecondaryImpulseCommands
--
lots of changes

--------------------------------------------
world.qc:
rankings code, precaching for waypoints and squad
--
no changes


*/

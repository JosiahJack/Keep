======================================================================
    D  R  A  K  E      D  E  V  K  I  T
======================================================================

Version  : Drake Beta 1
Date     : 6/24/2011

    1. Engine and General Notes
    2. Items
    3. Weapons
    4. Triggers and Func Objects
    5. Miscellaneous Entities
    6. Monsters
    7. Compiling Notes

Note:  The documentation is incomplete!  Not all entities are
documented, and some features are prone to change before a final
release.

======================================================================
    1. Engine and General Notes
======================================================================

----------------------------------------------------------------------
WORLDSPAWN

"drama1"
Short for DRAke Map Arsenal release 1.  This field overrides the
items field (see below) for weapons the player will be given.
Use this field if you want to give the player custom weapons.
     1 = Grapple
     2 = Axe
     4 = Chainsaw
     8 = Shotgun
    16 = Ruby Wand
    32 = Nailgun
    64 = Double(-Barrelled) Shotgun
   128 = Blaster
   256 = Grenade Launcher
   512 = Super Nailgun
  1024 = Sidewinder Launcher
  2048 = Rocket Launcher
  4096 = Hyperblaster
  8192 = Plasma Gun
 16384 = Thunderbolt
 32768 = Chain Thunderbolt
 65536 = MIRV Launcher
131072 = Mjolnir
262144 = Buriza-Do Kyanon

"gravity"
Add a value to set the gravity of the map.  Values less than zero
are ignored.  Default gravity is 800, and e1m8 gravity is 100.

"items"
Sets the default items the player receives when starting a new game
on the map.  Player will be given a small amount of ammo to use each
weapon.  Note that if the drama1 field is set, the items field will
be ignored.
   -1 = No items!
    1 = Shotgun
    2 = Super Shotgun
    4 = Nailgun
    8 = Super Nailgun
   16 = Grenade Launcher
   32 = Rocket Launcher
   64 = Thunderbolt
 4096 = Axe
 8192 = Green Armor
16384 = Yellow Armor
32768 = Red Armor

"noise"
Causes the map the play the given .wav filed shortly after the map
starts.  Useful for playing background music.  If the field is blank,
nothing will be played.

"sky"
Some custom engines can load a skybox and display that instead of
the textures from a sky brush.

----------------------------------------------------------------------
DUAL TARGETING

The field "target2" has been added to allow entities to activate two
independent targets.  This also allows monsters to follow a path set
by path_corners and target other things when slain.  However, a
monster will only seek path_corners if their targetname matches
the monster's target field.  target2 is not used for path_corners.

----------------------------------------------------------------------
NO KILLTARGET SHORT-CURCUITING

If an entity has the field killtarget set, it will no longer ignore
any targets it had when used.  After the removal of entities whose
targetname matches the killtarget, entities whose targetname matches
target or target2 will be activated.


======================================================================
    2. Items
======================================================================

item_armor_exotic
item_artifact_berserker
item_artifact_equalizer
item_artifact_levitation
item_artifact_optimizer
item_artifact_regeneration
item_artifact_reflection
item_artifact_shambler
item_artifact_super_pack
item_artifact_tomeofpower
item_backpack
item_bloodcube
item_book
item_fake
item_pushup
item_sigil_bane
item_treasure

----------------------------------------------------------------------
ITEM SPAWNFLAGS

Most items have may use the following fields.

"spawnflags"
 32 = Delay Spawn, Silent
 64 = Delay Spawn
128 = Always Respawn

DELAY SPAWN
With this spawnflag and a valid targetname, items do not spawn until
triggered.

ALWAYS RESPAWN
Item respawns in any game mode, not just deathmatch.  Has no effect
on items that do not respawn at all in any mode, such as runes or
fake items.

----------------------------------------------------------------------
ITEM MODIFICATIONS

-- Biosuit --
The biosuit has inherited the effects of the wetsuit from Scourge of
Armagon.  This means in addition to drown and slime immunity, the
biosuit allows the player to swim faster and grants immunity to
lightning damage.  Also, any item_artifact_wetsuit entities found
are automatically converted to Biosuits.

----------------------------------------------------------------------
EXOTIC ARMOR

Classname......:  item_armor_exotic

See the Drake manual for a brief description of what each armor does.
Full description will be placed here in a future version.

"spawnflags"
1 = Courage armor
2 = Dragonscale
3 = Onyx armor
4 = Power armor
5 = Demonhide
6 = Spirit Shroud
7 = Chaos armor
8 = Jump armor

----------------------------------------------------------------------
BERSERKER HELM

Classname......:  item_artifact_berserker

Increases damage of all of your melee attacks by 25%, and heals you
by 1 health per hit against living enemies.  You cannot gain health
from undead enemies such as zombies or inanimate objects.

Using even a chainsaw against powerful enemies such as death knights,
fiends, or worse is a losing battle, or at least a drain on health.
This powerup will let the player take out difficult targets with less
pain, or even gain health when fighting weaklings such as grunts or
knights.

This powerup remains with the player until the end of an episode.

----------------------------------------------------------------------
TWIN SHOT (formerly EQUALIZER in Soul of Evil)

Classname......:  item_artifact_equalizer

This rune allows nailguns to fire twice per nail.  Rate of fire
remains the same.  The end result is the nails required to kill an
enemy may be reduced by up to half.

This powerup remains with the player until the end of an episode.
In addition to more efficient nailguns, this item increases nails to
maximum capacity.

-- PM says --
The twin shot was created to boost nail capacity without increasing
ammo limits.

----------------------------------------------------------------------
BOOTS OF LEVITATION

Classname......:  item_artifact_levitation

This powerup allows the player to reverse the effects gravity has on
him.  While the jump button is held, the player will levitate by
falling upward.  Releasing the jump button will restore gravity back
to normal.  In addition to levitation, the artifact bestows a feather
fall effect so that anytime the player falls down, he will always
fall downward slowly and never take falling damage.  The artifact
wears out like most others, but the duration is longer, 45 seconds
instead of 30.

----------------------------------------------------------------------
OPTIMIZER

Classname......:  item_artifact_optimizer

Quickens shotguns' rate of fire.  The rate of fire of the normal
shotgun speeds up from once every 0.7 seconds to once every 0.5
seconds, and the double shotgun speeds up from once every second to
once every 0.7 seconds.  Damage per second on the normal shotgun
increases from 64.2/sec to 90/sec, and the double shotgun increases
from 110/sec to 157.1/sec.

The main use of this item is to make shotguns viable in high power
levels where anything much weaker than a super nailgun is too weak.
Keep in mind that the player will consume shells at a faster rate.
If you want the player to use shotguns as their primary weapon,
make sure they get plenty of shells.

This powerup remains with the player until the end of an episode.
In addition to faster shotguns, this item increases shells to
maximum capacity.

-- PM says --
The optimizer was created to power up shotguns without adding another
shotgun variant, such as Nehahra's auto shotgun.

----------------------------------------------------------------------
REJUVENATOR

Classname......:  item_artifact_regeneration

Collecting this powerup grants the player the power to regenerate
health at a rate of one per second.  The regeneration power lasts
until the end of the level.  Should the player collect another
rejuvenator in the same level, the regeneration effects will stack,
quickening the rate of regeneration.

-- PM says --
This is good for the map designer who does not want to place health
packs all over a map.  Keep in mind that anytime the player is hurt
and is able to hide, he will eventually heal back to full.

----------------------------------------------------------------------
AMULET OF REFLECTION

Classname......:  item_artifact_reflection

This artifact raises a powerful force field that repels nearly any
missile attack away from the player.  Buckshot, nails, rockets,
lightning bolts... you name it.  The force field does not protect
against melee attacks, full body attacks (such as pummeling from
fiends), splash damage, or deadly effects from hostile environments.

This is an extremely powerful powerup.  Although not quite on the
level of invincibility, it is close.  The reflective force field can
provide complete protection against other players and monsters that
rely solely on ranged attacks.  Against melee specialists such as
knights, not so much.

----------------------------------------------------------------------
SHAMBLER DOLL

Classname......:  item_artifact_shambler

This plush monster doll will summon a tame shambler near the player.
If there is no room near the player, the summoning will be delayed
until room is available.  The shambler will follow its new master
and attack any enemies it finds.  The shambler will last until slain
or the end of the level.

----------------------------------------------------------------------
SUPER PACK

Classname......:  item_artifact_super_pack

Similar to the backpack in Doom, this super-sized backpack increases
maximum ammo capacity and gives some ammo.  Shell capacity increases
to 120, nail and cell capacity increases to 250 each, and rocket
capacity increases 60.

----------------------------------------------------------------------
TOME OF POWER

Classname......:  item_artifact_tomeofpower

Just like in Heretic and Hexen2, this black book modifies and
augments weapon effects.  The resulting increase of the rate of
damage is variable, ranging from roughly 150% to 200%.  Since the
damage increase is not as dramatic as quad damage, this item may
be placed more freely by the mapper who may wish to reward a clever
player with a bonus that is not as extreme as quad damage.

Example effects on various weapons.
Chainsaw = Extra damage and life leech.
Shotguns = Explosive shells.
Nailguns = Hitscan and piercing rounds.
Lasers   = Stronger yellow bolts that auto-aim on rebound.

Note, The effects of Tome of Power and Quad Damage can stack.
The combined power from both artifacts is enough to let the player
destroy anything vulnerable to damage in seconds.  Mappers beware.

----------------------------------------------------------------------
HEART OF DARKNESS

Classname......:  item_artifact_vitality

This artifact raises a player's maximum health by 25, then heals him
back to full health.  Maximum health cannot exceed 250 this way.
Useful in levels where the default health maximum of 100 is not
quite enough.

----------------------------------------------------------------------
BACKPACK

Classname......:  item_backpack

Backpacks may be placed on the map.  The following fields may be
set to set the backpack's contents.

ammo_shells  = Amount of shells in backpack.
ammo_nails   = Amount of nails in backpack.
ammo_rockets = Amount of rockets in backpack.
ammo_cells   = Amount of cells in backpack.
ammo_super   = Amount of crossbow bolts in backpack.
healamount   = Amount of health in backpack.
healtype     = Antidote to cure sickness.  (DEPRECATED)

The defaults of all of the above are 0.  If all of the ammo fields
are zero, the backpack will be filled with a small box of each of
the four classic ammo types.

"spawnflags"
1 = Doubles the default ammo given.  Has no effect on custom settings.
2 = Add the axe and all guns to the backpack.  Chainsaw, Mjolnir,
 and the Buriza are not included.  Player will be given the lowest
 ranking weapon not in the player's possession when backpack is taken.

----------------------------------------------------------------------
BLOODCUBE

Classname......:  item_bloodcube

A relic from Zerstorer, this bloodthirsty and treacherous entity will
"befriend" the player and suck the blood from all nearby creatures.
Those slain by the bloodcube are instantly reduced to gibs which it
can absorb.  Each gib absorbed increases the player's health be 3,
and the health increase can exceed the normal maximum.  Once every
two seconds, the bloodcube will feed on the player, inflicting one
point of damage.  After 40 seconds (or 30 if deathmatch), the
bloodcube will leave the player.

Assuming the map has the proper ambience, the bloodcube can be a
nice substitute for a megahealth.

----------------------------------------------------------------------
BOOK

Classname......:  item_book

The books featured in Soul of Evil behave more like miscellaneous
entities than items, but are included here since it uses items code.
When the player touches a book, a message is displayed at the center
of the screen and stays there for as long as the player is touching
the book.  Books are not taken and do not disappear when touched.
A book can have targets, but it will only trigger them once when
a message is displayed for the first time.

Books may have multiple pages, up to eight, and each page can by
accessed by the number keys or the / key.  For example, press 3 to
read page 3.

"page1" (required)
Page 1 of message to be displayed.

"page2"
Page 2 of message to be displayed.

"page3"
Page 3 of message to be displayed.

"page4"
Page 4 of message to be displayed.

"page5"
Page 5 of message to be displayed.

"page6"
Page 6 of message to be displayed.

"page7"
Page 7 of message to be displayed.

"page8"
Page 8 of message to be displayed.

----------------------------------------------------------------------
FAKE ITEM

Classname......:  item_fake

This is an item that can appear to be any other item.  When touched,
it disappears in a puff of smoke, then triggers its targets.  Useful
for the map designer who wants to place fake runes or powerups on
the level.

"mdl"
Sets item model.
Default is "progs/end1.mdl".

----------------------------------------------------------------------
JUMP ITEM

Classname......:  item_pushup

Whoever takes this strange item will have his velocity overriden by a
preset velocity.  With the proper velocity, this item can serve as a
one-time super jump item.  Once taken, the item disappears and will
not respawn.

"movedir"
Velocity to be set at when the item is taken.  Must be set manually.

-- PM says --
This item was created to overcome a design flaw in nsoe4.  Namely,
the tower with a broken spiraling staircase.  It is very hard to
climb the stairs without falling off to certain death, unless the
player is willing to save scum as insurance against failure.  With
this new item, the player has one chance to super jump to the top.

----------------------------------------------------------------------
SEAL OF BANE

Classname......:  item_sigil_bane

A custom MacGuffin, similar to end-of-episode runes, made special for
nsoe5.  When taken, all players' maximum health are raised by 50, and
health set to the new maximum.  In addition, corpse removal is turned
off for the rest of the level.

----------------------------------------------------------------------
TREASURE

Classname......:  item_treasure

Treasure can take the form of either gold coins or gemstones.
Similar to armor shards in the games Quake2 and Doom3, gold coins
increase armor by 5 per coin, which can exceed the normal maximum,
though the player is bound by a hard limit of 250.  Gemstones
increase health similarly, with a hard limit of 150 above maximum
health.

The default treasure item spawned is a gold coin.  To spawn a gem
instead, check the first spawnflag on.  Gems, and only gems, have
four colors available, with ruby red as the default.

It is important to note that all gems use fullbright colors,
while the gold coins do not.

"healtype"
0 = gold coin
1 = gem
Default is 0.

"skin" (applies to gems only)
0 = red
1 = orange
2 = yellow
3 = blue-white
Default is 0.

"spawnflags"
1 = small, +5 to stat instead of +10 (overrides sf2)
2 = big, +20 to stat instead of +10

-- PM says --
This may be replaced by something else in the final version of Drake.


======================================================================
    3. Weapons
======================================================================

weapon_axe
weapon_blaster
weapon_chainlightning
weapon_chainsaw
weapon_crossbow
weapon_mjolnir
weapon_plasma_gun
weapon_shotgun
weapon_sidewinder
weapon_stinger
weapon_zapper

----------------------------------------------------------------------
WEAPON MODIFICATIONS

-- (Double) Shotgun --
Shotguns fire slower for much higher damage.  The behavior more like
the shotguns in other id games such as Doom or other Quake games.
Shotguns can decapitate enemies when killed by a well-aimed headshot.
The double shotgun can also shove enemies it kills away.

-- Thunderbolt --
Lightning has been modified so that it hits all in its path, not just
the first target in the way.  This means it is possible for the
player to line up monsters in his aim, then fire away to hit two or
more of them simultaneously.

-- Laser Cannon --
Renamed to Hyperblaster to make it clear it is the super version of
the blaster.  The center shot only costs half of the twin shot.
However, the glowing tracer shot no longer hits for increased damage.

-- Mjolnir --
This mighty hammer received several upgrades.  See below for details.

----------------------------------------------------------------------
AXE

Classname......:  weapon_axe
Attack Type....:  melee
Rate Of Fire...:  varies
Damage Per Shot:  24 or 30
Damage Pet Sec.:  80 or 60
Ammo Type......:  none
Ammo On Pickup.:  none
HUD Slot.......:  1
Select Command.:  impulse 1
Special........:  decapitation

The player begins with the axe.  While the entity is unnecessary,
it is available for those who want it.

In standard Quake, the axe is so weak the player has little to no
incentive to use it.  To make sure the axe could get some use, it
features several upgrades.

1. The player can tap the fire button to swing the axe at normal
speed for 30 damage, or hold the fire button to swing the axe at
increased speed (over three times per second) at 24 damage per hit.
The former is useful for one-hit kills against grunts and dogs while
the latter has a higher rate of damage against stronger foes.

2. If the player kills a monster with a close, clean hit, the monster
will be decapitated if possible.  Decapitated enemies cannot be raised
from the dead.  Yes, there are monsters who can raise the dead!

3. The axe can destroy zombies in three hits.  Useful when
grenades are unavailable.

All in all, the faster speed and possible decapitation are reasons
enough to use the axe occasionally.

----------------------------------------------------------------------
BLASTER

Classname......:  weapon_blaster
Attack Type....:  projectile (laser)
Rate Of Fire...:  3 shots/0.4 seconds
Damage Per Shot:  18
Damage Pet Sec.:  135
Ammo Type......:  cells
Ammo On Pickup.:  30
HUD Slot.......:  5
Select Command.:  impulse 5 while super nailgun is selected
                   or impulse 35
Special........:  rebounding shots

Quake lacks two things:  blasters you can take from slain enforcers,
and a cell-based weapon that is not overpowering in non-deathmatch
games.  The blaster presented addresses both of these problems.
The blaster is perfect for the map designer who desires to give the
player a weapon that can consume cells and not be overpowering.

To keep the blaster from becoming yet another projectile weapon,
the energy bolts fired from the weapon will rebound off the walls
like those fired from the Laser Cannon in Scourge of Armagon.
In fact, the blaster is a half strength Laser Cannon.  The only
difference is these blaster bolts do not have the 15% chance of
disappearing on impact with a wall.  Compared to the original Quake
weapons, the blaster ranks between the nailgun and super nailgun,
thanks to its damage rate of 135 per second.

While the blaster does not have a rate of damage as high as the other
cell-based weapons, its 18 damage per cell versus thunderbolt's 15
means the blaster gives more bang for the buck against lone targets
when cell conservation is necessary.

----------------------------------------------------------------------
CHAIN THUNDERBOLT

Classname......:  weapon_chainlightning
Attack Type....:  hitscan (lightning bolt)
Rate Of Fire...:  1 shot/0.1 seconds
Damage Per Shot:  30 (primary) and 20x3 (secondary)
Ammo Type......:  cells
Ammo On Pickup.:  30
HUD Slot.......:  8
Select Command.:  impulse 8
Special........:  chain attack, discharge

Designed for crowd control, the chain thunderbolt fires electricity
that arcs from a primary target to a maximum of three secondary
targets.  The primary target takes 30 damage, and each secondary
target takes 20 damage.  As long as the lightning strikes the first
target, all secondary targets will be hit automatically.  Allies are
neither targeted nor hit by the lightning, making chain thunderbolt
perfect for zapping a crowd without harming allies.  Under optimal
conditions, this weapon has an effective damage rate of 900 per
second, though not all of it dealt to the same target.

This weapon is very powerful.  It is at least as damaging as the
normal Thunderbolt.  In fact, this weapon replaces the Thunderbolt
when taken.  It should be available only in maps that feature horde
combat.

- Note -
If fired underwater, the weapon will discharge like the Thunderbolt.
In other words, generate a colossal explosion with you at the center.

----------------------------------------------------------------------
CHAINSAW

Classname......:  weapon_chainsaw
Attack Type....:  melee
Rate Of Fire...:  1 hit/0.2 seconds
Damage Per Hit.:  24
Damage Pet Sec.:  120
Ammo Type......:  none
Ammo On Pickup.:  none
HUD Slot.......:  1
Select Command.:  impulse 1
Special........:  can destroy zombies, can decapitate enemies.

This is the same tool of mayhem and destruction from Zerstorer.
The chainsaw is a rapid-fire melee weapon that can shred most
monsters to pieces quickly.  Once taken, the chainsaw will replace
the axe since the chainsaw does everything the axe can do better.
As a comparison, the chainsaw has a damage rate 150% higher than the
axe's.  The chainsaw is a little noisy, but it is not enough to
alert monsters any more than any other passive activities.

----------------------------------------------------------------------
BURIZA-DO KYANON

Classname......:  weapon_crossbow
Attack Type....:  projectile (ice bolt)
Rate Of Fire...:  1 shot/2 seconds
Damage Per Hit.:  100 + special
Ammo Type......:  bolts
Ammo On Pickup.:  5
HUD Slot.......:  8
Select Command.:  impulse 8 while plasma gun is selected,
                   or impulse 48
Special........:  piercing, one hit kills most targets, survivors
                   are slowed.

Based on an infamous "exceptional unique" weapon from Diablo II: LoD,
The Buriza is an extremely powerful crossbow that launches icy bolts.
When launched, each bolt will fly straight ahead, piercing every
target along the way, until it impacts a solid wall or the sky.
Targets that are not boss monsters are slain instantly and usually
shatter into several ice fragments, preventing resurrection or other
corpse dependant abilities.  Invulnerability, godmode, and even
DAMAGE_NO does not prevent death from a direct hit.  However,
reflection will repel bolts.  Boss monsters take up to 100 damage
and are slowed to half speed for five seconds.  In addition to
direct hit damage, bolts that impact the wall explode for up to 60
points of damage.  Of course, the splash damage is nowhere near as
deadly as an automatic one-hit kill.

The Buriza uses its own class of ammo, named bolts, Each crossbow
holds five shots, and the player can carry a maximum of ten.
Crossbows can be stolen by gremlins then fired against its previous
owner.

Although the Buriza is a weapon, it is treated more like an artifact
in terms of pickup and respawning.  A player can take a crossbow in
coop mode even if he is holding one already.  In deathmatch,
crossbows take 60 seconds to respawn instead of 30.

----------------------------------------------------------------------
MJOLNIR

Classname......:  weapon_mjolnir
Attack Type....:  special
Rate Of Fire...:  special, no faster than 1 hit/0.6 seconds
Damage Per Shot:  varies
Ammo Type......:  cells
Ammo On Pickup.:  60
HUD Slot.......:  1
Select Command.:  impulse 1 while axe is selected,
                   or impulse 31
Special........:  shockwave, slam, can be thrown

The Mjolnir in Drake has more special powers than it did in the first
mission pack, Scourge of Armagon.  This is because the mission pack
version is usually weaker and less efficient than the thunderbolt.
This is fine in levels where the thunderbolt would be overpowered.
However, in Tronyn's map packs, Mjolnir may be found after one of the
lightning guns is found.  To prevent the Mjolnir from becoming nothing
more than an extra large ammo box of cells, it was given several extra
special powers.

Mjolnir can be swung to hit targets in melee.  A direct hit will
inflict 50 damage to the target.  If the target is a zombie, it is
obliterated instead.  It can smite enemies once every 0.6 seconds.
if the swing misses, what happens next varies by the interaction of
the attack button.

If the fire button was tapped and released before the hammer hits the
ground, the hammer will produce a shockwave when it slams the ground.
The shockwave will repel any nearby missiles and enemies and inflict
up to 50 points damage.  The shockwave does not consume any ammo.

If the fire button was held when the hammer hits the ground, and the
player has at least 25 cells, the hammer will cause an earthquake and
the standard lightning effects from Scourge of Armagon.  The standard
lightning effects from the original hammer can cause up to 200 damage
to a maximum of four targets.  Since lightning pierces in Drake, it
is possible to for lightning to overlap such that targets take damage
from multiple bolts.  Theoretically, a target can take up to 800
damage if all four lightning bolts hit for the entire duration.  In
addition to the damage from the lightning, the earthquake will damage
every hostile creature incapable of flight and some objects for up to
50 points within a long distance from the epicenter.  The further
away from the epicenter, the less damage a target takes.  Those
affected by the earthquake will also their movement impaired until
the quake stops.  Finally, if the player is outdoors, additional
lightning bolts may flash from the sky and smite enemies for an
addition 80 damage per bolt.

If the fire button was double pressed before the hammer slams the
ground, and the attacker has at least 25 cells, the hammer will be
thrown.  The hammer will automatically home in on the closest target
in front of the attacker.  If no target is available, the hammer will
fly straight ahead for about two seconds before returning.  If the
hammer hits its target, and the attacker is not too close to the
hammer, the hammer will discharge, inflicting up to 250 damage against
the target struck, and send lightning toward other nearby targets, up
to a maximum of five, and zap them for a maximum of 100 damage.
Entities who are friendly to the attacker take reduced damage from
a hammer impact and are not targeted by the lightning.  The hammer
does not discharge on impact if it strikes a wall, if the attacker
is too close to the hammer, or strikes another target after a
discharge.  If the hammer strikes a target without discharging,
the target takes normal hammer damage of 50.  After impact the hammer
will return to the attacker.  The hammer can hit other targets who
are in the hammer's path.  If the hammer gets stuck on something and
cannot return to the attacker, the hammer will teleport back to the
attacker.  If the hammer returns without discharging or teleporting,
the attacker will get his cells back.  The hammer will remain in
mid-air for a maximum of ten seconds, and the hammer will teleport
back to the attacker if it has not returned by then.

- Note -
If the player attempts the super slam while underwater, the hammer
will discharge with him at the center, just like the thunderbolt
weapon series, but only in deathmatch or if the player is invulnerable
to damage.  However, the hammer will not discharge if only the slam
point is underwater.  The player must be deep enough in water for the
discharge to occur.

----------------------------------------------------------------------
PLASMA GUN

Classname......:  weapon_plasma_gun (or weapon_plasmagun)
Attack Type....:  projectile (plasma)
Rate Of Fire...:  1 shot/0.2 seconds
Damage Per Shot:  50 (maximum, average is 45.8)
Damage Per Sec.:  229.1
Ammo Type......:  cells
Ammo On Pickup.:  30
HUD Slot.......:  8
Select Command.:  impulse 8 while thunderbolt is selected,
                   or impulse 38
Special........:  discharge

Based on Quoth's plasma gun, with minor differences and slightly
weaker.  This weapon fires explosive plasma at a relatively fast rate,
consuming three cells per shot.  Unlike Quoth, direct hit damage
varies between 42 and 50, instead of a flat 50.  Plasma can gib
zombies, but it usually takes two shots to do so.  Other differences
include plasma shots spreading out slightly and discharging on contact
with water, much like in IKguns.  Like the thunderbolt, this weapon
explodes if fired underwater.

Compared to the Thunderbolt, the plasma gun has a weaker damage rate
(plasma gun's 229.1/sec vs. thunderbolt's 300/sec), but it has greater
range and it can gib zombies.

----------------------------------------------------------------------
SHOTGUN

Classname......:  weapon_shotgun
Attack Type....:  hitscan (pellets)
Rate Of Fire...:  1 shot/0.7 seconds
Damage Per Shot:  45
Damage Per Sec.:  64.2
Ammo Type......:  shells
Ammo On Pickup.:  5
HUD Slot.......:  2
Select Command.:  impulse 2
Special........:  decapitation

The player always starts with one.  However, if you want to place
a shotgun in the map for grins-and-giggles, the weapon entity is
available for use.

Shotguns are powered up in Drake, and can decapitate enemies on a
kill with a well-aimed headshot.  The shotgun behaves much like a
slightly weaker version of the Quake's unmodified double shotgun.

----------------------------------------------------------------------
SIDEWINDER

Classname......:  weapon_sidewinder
Attack Type....:  projectile
Rate Of Fire...:  1 shot/second
Damage Per Shot:  95
Ammo Type......:  rockets
Ammo On Pickup.:  5
HUD Slot.......:  6
Select Command.:  impulse 6 while grenade launcher is selected,
                   or impulse 36
Special........:  tracking

This is based on the mega enforcer's missile launcher from Zerstorer,
and it may be yours to play with!

The rocket launcher in Quake is generally overpowered due to a
combination of high damage, long range, and ease of use.  To provide
the mapper with a weaker alternative, as well as something for mega
enforcers to drop, the sidewinder was born.  The sidewinder is a
missile launcher that fires slower, weaker homing missiles with
limited range at a slower rate.  Even though the missiles are homing,
they also wind from side to side as they fly, which makes them easier
to dodge, and sniping through narrow areas is very difficult or
impossible.  Despite the weaknesses, the sidewinder is very easy to
use, and all the player needs to do is look at the target's general
direction and shoot.

- Note -
This weapon replaces the proximity gun from Mission Pack 1, and any
weapon_proximity_gun entities found will be converted to sidewinder
launchers.

----------------------------------------------------------------------
MIRV LAUNCHER

Classname......:  weapon_stinger (or weapon_mirv)
Attack Type....:  projectile and splash
Rate Of Fire...:  1 MIRV or 5 payload missiles/1.5 seconds
Damage Per Shot:  190x2 or 95x5
Ammo Type......:  rockets
Ammo On Pickup.:  5
HUD Slot.......:  7
Select Command.:  impulse 7 while rocket launcher is selected,
                   or impulse 37
Special........:  remote control guidance, incendiary explosion,
                   payload homing missiles

Designed to be a BFG-class weapon, the MIRV Launcher is the most
powerful all-around weapon available to the player.  However, it
is a bit complicated to use, or least more complicated than just
point-and-shoot like most other weapons.  Proper use of the weapon
is a three step process:

Step 1. Press the fire button to launch the MIRV.  As long as
the fire button is held, the player may steer the MIRV wherever
he wants just by looking.

Step 2. While the fire button is held, select targets for the
payload missiles by aiming the weapon until the desired target(s)
are within the launcher sights.  Once done...

Step 3. Release the fire button.  This will cause the MIRV to
self-destruct (harmlessly) and release its payload of five homing
missiles.  Each missile will seek its assigned target, and on
impact, explode for up to 95 damage.

If the MIRV impacts before it releases the warheads, it will explode
big, for up to 190 damage on the first frame on impact.  The
incendiary explosion will ping three more times for more damage
in subsequent frames, totalling up to another another 190 damage.
This huge explosion can be useful for catching enemies with high
splash damage, or as a super rocket jump for the player.  However,
since each MIRV consumes five rockets per shot, these applications
are usually a waste of ammo.

On the other hand, if each payload missile hits a single target,
the target may take up to 480 damage.  While this combined assault
only has the power of four standard rockets for the price of five,
the rate this damage can be inflicted by this weapon can only be
matched by the Thunderbolt.

All of this explosive power gives the MIRV Launcher its primary
weakness: it is a medium-to-long range weapon.  Attempts to fire
the weapon in close combat will result in a near-lethal amount of
backlash damage to the attacking player.  Despite this weakness,
this weapon is extremely powerful, and should only be placed in maps
that feature high-level horde combat, final boss encounters, or other
similar apocalyptic fights.

Tip:  Never fire this weapon against a target with reflection unless
you have reflection yourself.  All reflected payload missiles will
be sent back at the attacker.

----------------------------------------------------------------------
RUBY WAND

Classname......:  weapon_zapper
Attack Type....:  hitscan
Rate Of Fire...:  1 shot/0.35 seconds
Damage Per Shot:  15, but can be charged up to 60
Damage Per Sec.:  42.8
Ammo Type......:  none
Ammo On Pickup.:  none
HUD Slot.......:  2
Select Command.:  impulse 2 while shotgun is selected,
                   or impulse 32
Special........:  can be charged, full charge repels enemies and
                   lights a flare

This is a weak weapon similar to the elven wand from Heretic, with
unlimited ammo like the hand blaster from Unreal or Quake2.  However,
while the wand is held, it can build up power for a stronger attack.
At maximum power, the wand can fire a powerful shot that will gib
zombies or shove any other target stuck and spawn a flare that will
light up the area for several seconds.

Quake is generally ill-suited for long range combat, so to prevent
the player from spending a minute of sniping helpless enemies from
long range away at no cost, the wand has limited range comparable to
the thunderbolt.

Because this weapon can spawn flares that shed bright light, the
mapper can build a map with dark areas, then provide the player a
wand to light up the way.  Aside from that, this weapon should be
given as a last resort option, should melee prove to be suicide for
ammoless players.

- PM says -
This weapon is bit of a utility weapon.  It can hurt enemies and push
them around, gib zombies, light up dark rooms, or even rocket jump.
However, do not force this weapon to be the player's primary weapon
by being stingy with ammo.  Players do not like to be forced to plink
at enemies with weak weaponry.


======================================================================
    4. Triggers and Func Objects
======================================================================

func_door
info_teleport_destination
info_teleport_random
trigger_changelevel
trigger_teleport
trigger_victory
trigger_void

----------------------------------------------------------------------
DOORS

Classname......:  func_door

Same as usual, except for one modification:  Turning on both key
spawnflags (8 and 16) causes the door entity to require both silver
and gold keys to open.

----------------------------------------------------------------------
TELEPORT DESTINATION

Classname......:  info_teleport_destination

Turning on spawnflag 32 will make it glitter like a misc_glitter
entity.  Except for angles, it can use any field usable by a
glitter spawner to set glitter properties.  Otherwise, this is the
entity as before.

----------------------------------------------------------------------
RANDOM TELEPORT DESTINATION

Classname......:  info_teleport_random

This entity serves as a possible destination for teleport triggers
with random destinations.  No targetname is necessary.

As with info_teleport_destination, spawnflag 32 will make the entity
glitter as well.

----------------------------------------------------------------------
TRIGGER CHANGELEVEL

Classname......:  trigger_changelevel

As before, activating the trigger ends the level.

"targetname"
If set, the trigger cannot be touched, and must be used to exit the
level.

"spawnflags"
 1 = No Intermission
 8 = DMSP Off
16 = DMSP On
32 = Glitter

NO INTERMISSION
Intermission between levels is skipped.

DMSP OFF
Turns off dmsp mode beginning next level.

DMSP ON
Turns on dmsp mode beginning next level.

GLITTER
Creates a glitter spawner at the trigger's center.  The new glitter
spawner will inherit any usable fields except angles from the
trigger.  See misc_glitter for usable fields.

----------------------------------------------------------------------
TRIGGER TELEPORT

Classname......:  trigger_teleport

Teleports entities touching the trigger as before.  The teleporters
have more features available via spawnflags 4+.

"spawnflags"
 1 = Player Only
 2 = Silent
 4 = Random
 8 = Stealth
32 = Glitter

PLAYER ONLY
May be triggered only by players.

SILENT
Teleporter will not produce any ambient humming noises.

RANDOM
Teleports entities to the location of a randomly chosen
"info_teleport_random" entity.  No target is required.

STEALTH
This entity does not spawn any teleporter effects when used.

GLITTER
Creates a glitter spawner at the trigger's center.  The new glitter
spawner will inherit any usable fields except angles from the
trigger.  See misc_glitter for usable fields.

"target" (required unless sf4 is set)
Teleports entities to an info_teleport_destination with a matching
targetname.

----------------------------------------------------------------------
TRIGGER VICTORY

Classname......:  trigger_victory

This trigger works much like a trigger_relay, except trigger_victory
can be activated only once as soon as 100% kills are scored.  Thus,
trigger_victory only needs 'target's, and no targetname is necessary.

----------------------------------------------------------------------
TRIGGER VOID

Classname......:  trigger_void

Any (solid) creature that touches this trigger disappears and dies
instantly, regardless of health or protections.  Most items that
touch this trigger are removed as well.

"spawnflags"
1 = Sky

SKY
Flying or ethereal creatures are unaffected.


======================================================================
    5. Miscellaneous Entities
======================================================================

misc_barrel
misc_bell
misc_chest
misc_decor
misc_fireball
misc_glitter
misc_meat
misc_statue
misc_tree
misc_wanted

----------------------------------------------------------------------
EXPLOSIVE BARREL

Classname......:  misc_barrel

Similar to misc_explobox except this spawns a wooden barrel, which is
just as explosive when destroyed.  Unlike the original radioactive
containers, barrels are wider, shorter, and can be pushed and stood
on.  In fact, barrels are short enough for the player to jump onto,
although doing so with enemies nearby is foolish since their attacks
may explode the barrel.  Also, the barrels' origin is centered.

----------------------------------------------------------------------
BELL

Classname......:  misc_bell

This is a huge bell like those found in an old bell tower.  All it
can do is ring loudly.  To make it ring, use it like other entities,
that is, set its targetname field.

The bell is a huge entity with an unusual size.  To make it fit in
with the nsoe* maps, the dimensions of the bell were set from
'-64 -64 -80' to '64 64 88'.

----------------------------------------------------------------------
TREASURE CHEST

Classname......:  misc_chest

This is a locked treasure chest that is usually filled with treasure.
To open it, the player must break it with an attack.  However, the
chances of an empty chest are one-in-eight, and half of the empty
chests are booby-trapped with lethal explosives.  The rest of the
time, a large coin or gem is spawned followed by several smaller
coins and gems.  The chest's contents are determined at spawn time,
so the player cannot reroll the contents by save-scumming.
An item spawned by a chest does not respawn after it is taken.

In addition to the treasure, or lack of, the chests themselves may
be pushed around or stood on as platforms.  Each chest is 24 units
tall.  Thus, chests may be pushed, stood on, then used as a platform
to jump to places that are normally too high for the player to reach
without the aid of the chest.

"spawnclassname"
If spawnfunction is set, its spawnclassname must match it.

"spawnfunction"
Causes the chest to always spawn a specific item.  If set, function
must be an item_* or weapon_*.  Other objects such as misc_* or
monster_* are not supported!

----------------------------------------------------------------------
GENERIC DECORATION

Classname......:  misc_decor

This spawns a solid model that just sits there as decoration.
Model and size are adjustable.  If the fields are not filled in,
the entity will default to a Zerstorer style dead tree.

"mdl"
Sets model.  Default is "progs/tree_zer.mdl".

"pos1"
Sets bounding box minimum.

"pos2"
Sets bounding box maximum.

----------------------------------------------------------------------
LAVABALLS

Classname......:  misc_fireball

The same red hot lavaballs you are familiar with, plus one added
feature, their damage is adjustable.

"dmg"
Damage done on contact.  If set to 40 or higher, the lavaball will
explode like a rocket.  Default is 20.

"spawnflags"
If the second spawnflag is checked on, the lavaball spawner will be
converted to a gib fountain as in Zerstorer.

----------------------------------------------------------------------
GIB FOUNTAIN

Classname......:  misc_gibft

This entity is a gib spawner, which periodically spews blood-soaked
gibs into the air, producing a gory shower of blood in the process.

"speed"
How fast the gibs are sent.  Default is 1000.

----------------------------------------------------------------------
TELEGLITTER

Classname......:  misc_glitter

This a glitter spawner, similar to those in the game Heretic.
The glitter spawned consists of particles and glitter sprites.
They begin with some velocity then speed up until they impact with
a solid.  Useful for decorating teleporter pads and the like.

Glitter is spawned within a bounding box from '-16 -16 -8' to
'16 16 48' relative to the spawner's origin.

A word of warning, glitter spawners are entity spawning hogs.
Limit usage of these entities to a few, say three or four, maximum
per map.  Also, glitter is disabled in deathmatch games.

"wait"
Time between glitter spawns.  Default is 0.1.

"count"
Color of particles and glitter sprites.  Default is 244.
  
"speed"
Initial speed of the particles when spawned.  Default is 100.

"height"
Speed added to each glitter sprite after each tenth-of-a-second.
Default is 50.  Note, use 80 if you want default gravity speed.

"angles"
Affects the direction of glitter flight.  Default is '0 -1 0',
which sets movedir to '0 0 1' and causes the glitter to float up.

----------------------------------------------------------------------
GIBS

Classname......:  misc_meat

This entity spawns a pile of four gibs near its origin during spawn
time.  The gibs produced are a zombie head, an arm, a torso, and a
meat chunk.  The gibs do not disappear, although they can be eaten.

----------------------------------------------------------------------
STATUE

Classname......:  misc_statue

This is a huge statue of a praying angel.  Size ranges from
'-48 -48 0' to '48 48 120'.

----------------------------------------------------------------------
TREES

Classname......:  misc_tree

Specialized decoratation, this is a dead-looking tree which may or
may not be destroyed.

"cnt"
If the value is 1, 2, or 3, a Zerstorer-style tree will be spawned.
All other values will spawn a Hexen2-style tree.

"health"
How much damage the tree can take before splintering.  Damage must
be enabled first by checking the first spawnflag.  Default is 200.

"spawnflags"
Checking the first spawnflag will make the tree vulnerable to damage.
Trees will bleed sap when damaged.

----------------------------------------------------------------------
WANTED POSTER

Classname......:  misc_wanted

This is a simple, Wild West style "Wanted" poster of the player,
who is named Baneslayer in the Soul of Evil: Indian Summer story.

This entity is a near duplicate of the Hipnotic function wallsprite,
with the following two differences:

1. Default model is "progs/wanted.mdl", instead of "s_blood1.spr".

2. The entity can be destroyed by 10 points of splash damage.
This also means the entity is not static, unlike those spawned
by wallsprite.

This is designed for map made for Soul of Evil: Indian Summer.


======================================================================
    6. Monsters
======================================================================

WARNING:  This section is very much unfinished.  It contains data
mostly from Soul of Evil: Indian Summer.  It has been updated for
Drake, but other content remains undocumented at this time.

6. Monsters
   6.1 Wilderness
   6.2 Disciples of Bane
   6.3 Knights of the Bane
   6.4 Hellspawn
   6.5 Miscellaneous

----------------------------------------------------------------------
COMMON STUFF

"ammo_shells"
"ammo_nails"
"ammo_rockets"
"ammo_cells"
Most monsters can carry and drop ammo.  Setting any of these will
override the monster's defaults.

"health"
Monster health is adjustable.  However, it cannot be less than 1
or greater than 50,000.

"message"
Friendly monsters (see below) will display a message to the player
they choose to serve.  It is displayed only on the first encounter.

"netname"
Monsters may be given a name by setting the netname field.  This
changes its obituary to a generic "Player was slain by <netname>".

"spawnflags"
All monsters may use the following spawnflags:
  1 = Ambush (becomes CRUCIFIED for monster_zombie)
 16 = Friendly
 32 = Delay Spawn, silent
 64 = Delay Spawn, teleport effects
128 = Spawn Aware

AMBUSH (sf1)
This is the standard set in Quake.  Monsters wake up only when they
see (or are triggered or hurt by) the player directly, not when they
see another monster get angry.  Zombies are the exception, sf1 causes
them to spawn crucified and sf2 sets ambush for zombies.  However,
unlike standard Quake, sf2 no longer sets ambush for monsters other
than zombies.

FRIENDLY (sf16)
Monsters with sf16 will be spawned as friendly NPCs.  Once a monster
becomes aware of the player, that monster becomes a pet of the player.
As a pet, the monster will follow the player around and fight other
hostile monsters.  NPC monsters do NOT count toward the monster
counter, and they will be attacked on sight by hostile monsters.

DELAY SILENT (sf32)
With this spawnflag and a valid targetname, monsters do not spawn
until triggered.  This is the same feature as in the mods Zerstorer
and Quoth.

DELAY SPAWN (sf64)
With this spawnflag and a valid targetname, monsters do not spawn
until triggered.  This is the same feature as in the mods Zerstorer
and Quoth.

SPAWN_AWARE (sf128)
Used in conjuction with delayed spawn, a monster with this spawnflag
is aware and angry (or friendly with sf16) at the player as soon as
it spawns.

----------------------------------------------------------------------
MONSTER AI

Z-AWARE
Ogres, zombies, and other monsters who can toss ballistic projectiles
can aim up or down to hit the player.  However, missiles remain bound
by their normal speeds, so they have range limits.  For example,
ogres' grenades have the same speed and range as the player's.
Even so, this change gives the player much fewer safe spots available
to attack such monsters with impunity.

----------------------------------------------------------------------
MONSTER SKINS

Some classic monsters have multiple skins, and can be set.
The monsters whose skin value only affects appearance are below
as follows:

-- monster_demon1 --
0 = classic fiend
1 = black scaly shadow fiend
2 = gray mutant wolf-fiend
3 = blue eye white snow fiend (for Unforgiven)
4 = red eye black fiend
Note:  Shadow Fiend has quicker melee attacks.

-- monster_dog --
0 = gray wolf
1 = classic rottweiler
2 = hell hound

-- monster_ogre --
0 = classic ogre
1 = flak ogre (see monster_ogre_flak below)

-- monster_shalrath --
0 = classic white
1 = dark blue

-- monster_shambler --
0 = classic white
1 = dark blue and black
2 = Sha'Vile (see monster_shamvile below)

-- monster_tarbaby --
0 = classic blue, with purple blood
1 = green, with green blood
2 = red, with red blood

-- monster_wizard --
0 = classic Scrag
1 = green Drake
Note:  Drakes bleed green.

----------------------------------------------------------------------
MONSTER MODIFICATIONS

Monsters who have modifications beyond skin color and not detailed
in their own section are listed here.

OGRE (monster_ogre)
Aside from Z-awareness, ogres will drop chainsaws, found in their
backpacks, when slain.

FIENDS (monster_demon1)
Their old Qtest overhead smash has been given back.  It is as quick
and damaging as its standard attack.

VORE (monster_shalrath)
Renamed to Shal-Rath.  Multiple spike bombs from the same shal-rath
can merge into a single, stronger missile.

SPAWN (monster_tarbaby)
Whenever its enemy dies, and it has no more enemies to kill,
it stops bouncing.  It, the classic version, also bleeds purple
instead of red.

ROTFISH (monster_fish)
Has several bugs fixed.  Monster counter no longer counts fish twice.
Fish can glide along the water surface from below, instead of getting
stuck there previously.  Also, fish can see targets across contents
and will always attack the player if close enough.

GREMLIN (monster_gremlin)
A stolen weapon may be recovered if the gremlin who stole it is slain
before it loses the weapon.  Also, all attacks from stolen weapons
are of the same power as those from a player.  For instance, grenades
will hit for up to 120 damage instead of the ogres' 40.  Gremlins may
steal weapons from other monsters if the attacked monster carries
multiple weapons.


======================================================================

6.1. Wilderness

monster_archer
monster_bandit
monster_thug
monster_ogre_flak
monster_dragon

----------------------------------------------------------------------
ARCHER (ORC in Soul of Evil)

Classname......:  monster_archer
Health.........:  80
Size...........:  small
Ranged.........:  arrows
Melee..........:  none
Special........:  drops 20 nails

Appears in place of standard enforcers, with some differences.
Shoots two powerful arrows at the player.  The arrows are fast,
and hit for 15 damage each.

As with the enforcers they replace, they are still low level fodder.
However, orcs can dish out the pain if the player cannot or does not
care to dodge their incoming fire.

For those who have played Hexen2, you will recognize these guys as
the archer grunts.  However, their AI was modified to behave more
like Quake's enforcers, since they were designed to replace the
"greater goblins" from the original Soul of Evil (Twilight Autumn).

----------------------------------------------------------------------
BANDIT

Classname......:  monster_bandit
Health.........:  30
Size...........:  small
Ranged.........:  arrows
Melee..........:  none
Special........:  drops 10 nails, will infight with anyone

The bandit is the result when you replace the grunt's shotgun with a
longbow and change his clothes to medieval garb.  Aside from this,
bandits behave identically to grunts.  Bandits shoot arrows at the
player, which are fast and hit for 9 damage each.

As with their original base counterparts, bandits are weak and
will die just by sneezing on them with just about anything.  They
are only a threat when encountered en masse or when accompanied by
stronger opposition.  Even then, once a bandit gets hit by friendly
fire, their penchant for infighting will cause chaos within the
enemy group.

"skin"
0 = human bandit
1 = green-skined goblin

----------------------------------------------------------------------
FOREST THUG

Classname......:  monster_thug
Health.........:  200
Size...........:  small
Ranged.........:  none
Melee..........:  axe
Special........:  none

The forest thug is a fleet-footed, homicidal, axe-wielding maniac.
His basic attack strategy is to run to the player as quickly as
possible, then whack the player until he is dead.  The thug has no
other abilities.  Think of him like a knight, only faster and tougher.

Due to the axemen's speed, the player will need at least a super
shotgun and plenty of room to maneuver in to take down an axeman
without taking too much damage.

----------------------------------------------------------------------
FLAK OGRE

Classname......:  monster_ogre_flak
Health.........:  200
Size...........:  large
Ranged.........:  nail scattergun
Melee..........:  chainsaw
Special........:  drops chainsaw and 10 nails

A variation of the standard ogre, the flak ogre has a different skin
and a scattergun to launch spikey buckshot at your general direction.
When a flak ogre fires his scattergun, four nails are launched
simultaneously.  One nail is fired straight at the player while
the remaining three spread out slightly in a random direction.
In essence, the flak ogres' scattergun is a projectile version of
the shotgun.  Each nail can hit for 9 damage, and with four nails,
the maximum damage possible per attack is 36.

Flak ogres are slightly more dangerous than normal ogres since the
scattergun has better range and accuracy than grenades.  Flak ogres
can be very annoying snipers.  Otherwise, they are no tougher than
other ogres.

----------------------------------------------------------------------
DRAGON

Classname......:  monster_dragon
Health.........:  750 (3000 for wyrm version)
Size...........:  special
Ranged.........:  varies by color
Melee..........:  bite
Special........:  flight, strafes, elemental resistance,
                   explodes after death (wyrm only)

Dragon Stats by size
Size    Health      Mins          Maxs
----------------------------------------------------
Classic   750  '-56 -56 -24'   '56 56 56'
Wyrm     3000  '-112 -112 -24' '112 112 112'

Winged creatures that spew death from above.  All dragons can fly and
the smaller ones are capable of dodging incoming fire.  Each dragon
may come in one of several different flavored colors and sizes.

RED DRAGON
Breathes fire, and has two types of attack.  One is a fire spray,
which is a stream of mini-fireballs.  Each hit causes 9 damage.
The mini-fireballs fade quickly and have limited range.  They also
cannot penetrate water.  The other attack is a single large
fireball, tossed like a grenade, except it explodes on impact like
a rocket.  Maximum damage is 80.  A huge fireball can pass through
water, but will lose power doing so.  Red wyrms always launch four
large fireballs at a time.

GREEN DRAGON
Launches a stream of poison shots much like the scrags' except they
fly much faster, and are affected by gravity.  Launches a number of
shots equal to 9 or twice its level, whichever is less.  If shots
launched is 9, damage is equal to twice its level, otherwise
damage is 9.  Green wyrms launch bile bombs instead, up to four
at a time, which can hit a target for up to 80 damage each.

BLUE DRAGON
At close range, it shoots lightning like a shambler.  Maximum damage
caused is 40.  The bolt can be dodged partially.  At long range, the
dragon shoots a plasma ball, and a direct hit will cause up to 60
damage.  After impact, the plasma ball will discharge and hit other
nearby targets, friend or foe, for up to 20 damage.  Blue wyrms fire
only plasma balls, four at a time.

WHITE DRAGON
Launches a spray of ice shards, sort of like an icy shotgun.
The shard are fast, but have limited range.  Damage is the same
as the poison shots from the green dragon.  White wyrms launch a
spray of icy spike bombs instead, four at a time, and each can
explode for up to 80 damage.

GOLD DRAGON
Aside from color, it is identical to the red dragon.

The dragons use incremental shot leading for all ranged attacks,
except for the large fireball.  Incremental shot leading means the
dragon will aim the first shot of the salvo at the player's current
location.  Each successive shot is aimed increasingly closer to the
player's projected location.  The last shot of the salvo will have
perfect leading, and will be aimed at where the player will be.
In the case of the blue dragons' lightning attack, it will initially
aim behind the player, then steer the bolt toward the player.  Due
to incremental shot leading, dodging the full attack is difficult,
and the player will often take about 10 to 20 damage per attack,
if cover is not available.

In close combat, any dragon without PATH AI can bite the player twice
per attack.  Each bite will cause damage equal to a maximum of its
level times 5.

When a wyrm, and only a wyrm, dies, it will explode into a shower of
fire and gore a few seconds later.  The explosion is deadly and will
cause up to 160 damage.

"classname"
monster_dragon
monster_dragon_wyrm

"skin"
0 = Red
1 = Green
2 = Blue
3 = White
4 = Gold
Default is 0.

"spawnflags"
 1 = Ambush
 2 = Wyrm
 4 = Fast
 8 = Slow

AMBUSH
Standard.  Flag this to make the dragon wake up only when it sees an
enemy.

WYRM
This spawns the full-sized Qtest dragon instead of the smaller dragons
used in Dragons.  It is far too big to chase enemies like other
monsters, let alone dodge incoming fire.  Instead, if it has
path_corners as targets, it will glide along the path set by
path_corners, firing at any enemies found along the way.  If it has
no path_corners, it merely glides back and forth at the elevation it
was placed at.  Wyrms are much bigger, stronger, and tougher.  See
above for their stats.

FAST
Dragon gains increased awareness and agility, allowing it to dodge
while attacking.  Wyrms may also lead their shots to a moving target.

SLOW
Dragon moves slower and cannot fully track an enemy with its attacks.
Cranked and Slow are mutually exclusive -- if combined with Cranked,
the spawnflag that is overriden varies on skill level.  If in Easy,
Slow will be used.  If in Normal, both spawnflags are ignored.  If in
Hard or higher, Cranked is used.

Countermeasures:
Players with a MIRV Launcher can just point and shoot.  The dragon,
try as it might, cannot dodge the homing payload missiles effectively.
Only a few shots are needed to shoot down a dragon.  Usually, the
player will not have this super weapon and must use more conventional
weaponry.

Unless the dragon has the fast spawnflag, the dragon will slow down
when it attacks.  During this time, rockets or a good spray from the
super nailgun will deal the pain effectively.  If the player cannot
wait for an attack, hitscan weapons will work.  If the dragon is stuck
somewhere at long range, the humble shotgun can be used to snipe and
wear down the dragon.  At closer range, thunderbolts are ideal,
although the super shotgun is adequate.

Players with dragonscale should not try to fight a dragon as a
dragon.  Player dragon attacks have low damage rates, and the
increased size while in dragon form makes it much more difficult
to dodge enemy dragon attacks.


======================================================================

6.2. Disciples of Bane

monster_acolyte
monster_sorcerer
monster_warlock

----------------------------------------------------------------------
ACOLYTE

classname......:  monster_acolyte
Health.........:  150
Size...........:  small
Ranged.........:  sidewinding poison shots
Melee..........:  sickle
Special........:  poisoning, immune to other acolytes' shots,
                   won't infight with other disciples

The weakest of the three disciple ranks.  From a distance, acolytes
can launch two or three poisonous, sidewinding, green shots at the
player.  Up close, they swing a mean sickle to cut down the player.

The sidewinding poison shots have limited homing ability, and will
sidewind toward the player.  Despite this, the shots can be
sidestepped easily, provided the player has room to do so, and once
the shots travel behind him, they lose of their target and will not
loop back to hit.  Should the player get hit by a poison shot, he
suffers 9 points of damage.

Countermeasures:
A super shotgun or any other stronger gun will put these guys in
their place soon enough.

----------------------------------------------------------------------
SORCERER

classname......:  monster_sorcerer
Health.........:  300
Size...........:  small
Ranged.........:  bouncing fireball
Melee..........:  explosive rune
Special........:  teleportation, won't infight with other disciples

The middle rank of discipleship.  Sorcerers wield wands and use them
to cast their spells.  They favor ranged combat and will lob bouncing
fireballs at the player from afar.  If caught within melee range,
the sorcerer will teleport away and, if no other ally (enemy to you)
is found, leave behind a rune that will explode one second later or
on contact.  Explosion damage has a maximum of 70.  The sorcerer can
also teleport anytime he sees incoming fire.

The fireballs sorcerers cast are almost identical to those from
Zerstorer's nemesant.  A ballistic fireball is tossed at the player,
causing up to 40 points of damage on a direct hit.  If the fireball
misses then hits the ground or wall, it will bounce in a new direction
toward the player.  Unlike fireballs cast by a nemesant, which could
bounce up to three times before exploding, the fireballs cast by a
sorcerer may bounce only once.

Countermeasures:
Shotguns or either thunderbolt are your best bet since their attacks
are hitscan and the sorcerer cannot dodge those.  Any other weapon
may activate his teleportation, which usually results in wasted ammo.
Never, under any circumstance, try to attack with a melee weapon.
You will simply run into the rune the sorcerer will leave behind and
take severe damage.  If you do not have the weapons to take down a
sorcerer, try to lure one of the bouncing fireballs into another
monster, such as knights, to instigate infighting.

----------------------------------------------------------------------
WARLOCK

classname......:  monster_warlock
Health.........:  450
Size...........:  small
Ranged.........:  guided energy bolt
Melee..........:  telekinesis
Special........:  reflector shield, immune to other warlocks' shots,
                   won't infight with other disciples

The highest of the three disciple ranks.  Warlocks are powerful
enough not to require any tools to do their work.  As with the
sorcerer, warlocks prefer ranged combat, but use even nastier spells
to fight with.  Warlocks can launch powerful guided crimson bolts of
energy to seek out and blast enemies with.  If an enemy approaches
too close to the warlock, the warlock may use telekinesis to shove
the enemy away for 20 damage.  Warlocks may also defend themselves
from missile fire by erecting a force field to repel nearly any
ranged attack.  Compared to other monsters, warlocks are very powerful
and extremely dangerous.  Even though their health is not as high as
other top non-boss monsters, their firepower allows them to destroy
shamblers or even larger dragons without much trouble.

The guided bolt is a strange, yet potent attack.  It is similar to
the shal-rath spike bombs except the bolt updates velocity only once
per second.  Each bolt may update up to three times before vanishing,
and each update weakens the bolt's power by 10 points.  A direct hit
from a bolt at full power explodes for up to 70 damage, and other
targets nearby will take splash damage.  Occasionally, the warlock
will aim his bolts toward the ground, hoping to catch his prey with
splash damage.

Countermeasures:
Thunderbolt, with hitscan and high rate of damage, is ideal for
taking warlocks down.  The shotguns will work, but are slow given
the warlock's health.  Attacks from projectile weapons usually talk
to the hand and get blown away by the shield unless the player is
almost close enough for melee.  Within this border range, nailguns
and blasters are effective, though the player runs a high risk of
taking damage, either from the warlock's bolts or telekinesis.
Rockets of any kind are unreliable at best.  Do NOT try to kill
warlocks with the MIRV Launcher.  There is a very good chance the
reflector shield will be up, and the missiles will be redirected back
at the player!


======================================================================

6.3. Knights of The Bane

monster_knight
monster_warrior
monster_hell_knight
monster_axeman
monster_archer_lord
monster_hell_lord
monster_baron
monster_golem
monster_hkboss
monster_dark_lord
monster_bane

----------------------------------------------------------------------
KNIGHT

Classname......:  monster_knight
Health.........:  75
Size...........:  small
Ranged.........:  none
Melee..........:  sword slash
special........:  won't infight other Bane knights

The classic Quake knight is the same as before with one exception:
His armor has been enchanted to absorb magic missiles, protecting
him completely against the missile sprays from hell knights.

Skin is automatically set to 0.

"spawnflags"
1 = Upgrade to Soldier (changes classname to monster_warrior)
2 = Ambush

----------------------------------------------------------------------
WARRION (OF BANE)

Classname......:  monster_warrior
Health.........:  150
Size...........:  small
Ranged.........:  none
Melee..........:  sword slash
special........:  won't infight other Bane knights

The warrior is a more experienced knight with more health and quicker
swordsmanship.  Aside from these enhanced attributes, the warrior is
still the same Quake knight.

Skin is automatically set to 1.

----------------------------------------------------------------------
HELL KNIGHT

Classname......:  monster_hell_knight
Health.........:  250
Size...........:  small
Ranged.........:  magic missile spray
Melee..........:  sword slash
special........:  won't infight other Bane knights

You know him well.  He is the same as in normal Quake, only renamed
from Death Knight to Hell Knight.  The only change of note is his
magic missiles do not harm other knights of any kind.

In Soul or Evil, skin is automatically set to either 0 or 1, with
equal chance of either.

----------------------------------------------------------------------
AXE KNIGHT

Classname......:  monster_axeman
Health.........:  300
Size...........:  small
Ranged.........:  throwing axe
Melee..........:  axe
Special........:  won't infight other Bane knights

Like the forest thug, the axe knight is a fleet-footed, homicidal,
axe-wielding maniac.  His basic attack strategy is to run to the
player as fast as possible, then whack the player until he is dead.
Unlike the thug, the axe knight can throw axes at the player while
on the move along the way, and he has an unlimited supply of axes.
In addition, the axe knight is a part of Bane's army of knights,
meaning he does not infight with other knights, and his armor
protects him from the hell knights' magic missiles.

Due to the axemen's speed, the player will need at least a super
shotgun and plenty of room to maneuver in to take down an axeman
without taking too much damage.

"skin"
0 = Axe Knight
1 = Forest Thug (see monster_thug above)

----------------------------------------------------------------------
ARCHER_LORD (ASSASSIN in Soul of Evil)

Classname......:  monster_archer_lord
Health.........:  325
Size...........:  small
Ranged.........:  explosive arrows
Melee..........:  none
Special........:  leads shots, drops 20-25 nails, won't infight other
                   Bane knights or orcs.

An archer who is much tougher and meaner than the orcs.  He shoots
arrows at the player, and can them lead them on an intercept course
with frightening accuracy.  He has two types of arrows he can shoot.
One type is a normal ebony arrow that can hit for 18 damage.
The other type is an energy arrow that can not only explode for up
to 30 damage, but also send an enemy hit directly by the arrow
flying away.

As part of Bane's army, he is immune to magic missiles, and will not
infight with other knights in Bane's army.  Also, as an elite archer,
he does not infight with other orcs, and orcs do not infight with
the assassin.

Countermeasures:
Assassins will read your movements, so keep your distance and avoid
moving in the same direction for any extended period of time.  As
for counterattacking, any long range projectile weapon is ideal.
As one of the tougher enemies in the game, use the stronger weapons
such as the rocket launcher or super nailgun to eliminate assassins
as quickly as possible.  If you are forced into a closer distance
with an assassin, thunderbolt may take him out before he gets a shot
off.

----------------------------------------------------------------------
HELL LORD

Classname......:  monster_hell_lord
Health.........:  400
Size...........:  small
Ranged.........:  magic missile spray (two patterns), meteor strike,
                   firewall
Melee..........:  sword slash
special........:  won't infight other Bane knights

Hell Lords may seem little more than upgraded hell knights with more,
stronger ranged options.  However, their increased health and new
fiery magics make Hell Lords much more dangerous than a standard
Hell Knight.  In addition to all of the Hell Knights' attacks,
Hell Lords may also rain meteors or raise firewalls at the player.

The meteor strike spawns a lavaball in mid-air then sends it toward
the player at a slow speed.  If the skill level is Hard or Nightmare,
the velocity will be sent on an intercept course to hit a moving
target.  Despite slow speed, the lavaball hits with the force of a
rocket.

The firewall is an unusual attack.  It is a wall of fire that glides
along the ground toward the player.  The firewall is unstable, and
can explode for up to 80 damage if the head of the firewall impacts.
If the player crosses the flames behind the head he will burn for
6 to 12 damage per flame touched per tenth of a second.  As with
the meteor, firewalls will be set on an intercept course in the
higher skill levels.

Countermeasures:
Stay away from walls!  Meteors and firewalls will impact quickly and
may cause unavoidable splash damage.  Other than that, the player can
treat Hell Lords as Hell Knights and fight them as such.

----------------------------------------------------------------------
BARON

Classname......:  monster_baron
Health.........:  500
Size...........:  small
Ranged.........:  leap attack, magic missile spray, fireballs
Melee..........:  claymore, fist smash
special........:  won't infight other Bane knights

If you have played Nehahra or Rapture, you will recognize these guys.
If not, the Baron is a big, muscle-bound knight wielding a claymore
in his blood-stained hands.  Up close, he alternates attacks between
his claymore and a left overhead fist.  From a distance, he has a
variety of attacks he can use.

The Baron may spray magic missiles much like a hell knight, albeit
in a slightly different pattern.  The missiles are the same as
those cast by the Hell Knights.  Instead of magic missiles, he
may point at the player to cast a fireball.  The fireball is the
equivalent of a half-strength rocket, and he may fire two in
quick succession in the higher skill levels.

Sometimes, the Baron will jump at the player.  While such jumps are
harmless in Nehahra or Rapture, they are not here.  If the Baron
connects with the player during his jump, he will swing his sword
down and strike for 20 to 30 points of damage.  If the jump misses
its mark but lands close, the baron will begin melee immediately
for some quick minor damage.

"level"
Setting this to a non-zero value will enable elemental boss mode
as in Rapture.  Elemental bosses' attacks cause much more damage,
and they use different ranged attacks.
0 = Normal, Nehahra-style Baron
1 = Fire Baron
2 = Earth Baron
3 = Storm Baron
4 = Rain Baron
Default is 0.

FIRE BARON
Has 1400 health.  Changed the least from the default Baron.
Magic missiles fly much faster and cause 20 damage per hit.
When pointing, the Fire Baron may launch up to four fireballs
in quick succession, each hitting for up to 60 damage.  He may
slam the ground and spawn a firewall.  The firewall is similar
to the hell lords' but more powerful, as it can home on in the
player and explode for up to 120 damage.

EARTH BARON
Has 1900 health.  The bruiser of the bunch.  Sprays superspikes
instead of magic missiles.  When pointing, he casts a spray of
5 to 8 chunks of rubble that can hit for up to 45 damage each.
Yes, this means a full spray of rubble to the face is a near-
guaranteed kill for the player.  He may also slam the ground to
cause an earthquake, shaking up nearby players and causing up to
40 damage per quake.  The earthquake will also cause a rock geyser
to erupt a few moments later where the target stood when the baron
slammed the ground.  The rock geyser is simply a rubbly spray
originating from the ground, causing similar damage.

STORM BARON
Has 2200 health.  The toughest of the bunch.  While his attacks may
inflict the least damage, they are much more difficult to avoid.
May cast air gusts from beneath all opponents to throw them up and
away and cause 10 to 15 points of unavoidable damage, and to deflect
incoming missile attacks.  When pointing, the baron will cast a
powerful ball of plasma which strikes for up to 90 damage.  The baron
can also summon lightning from the sky, causing up to 80 damage per
bolt.

RAIN BARON
Has 1000 health.  The weakest link of the baron boss family.
Sprays ice shards which can hit for 18 damage each.  When pointing,
he sprays more ice shards 6 to 9 at a time.  Occasionally, he may
summon a storm to rain deadly ice shards on his target for five
seconds.

"spawnflags"
1 = Ambush
4 = No jump

NO JUMP
Disables jumping.  Useful for the map designer when jumping may be a
bad idea for the baron, such as fighting on a bridge over lava.

----------------------------------------------------------------------
GOLEM

Classname......:  monster_golem
Health.........:  500
Size...........:  small
Ranged.........:  shard spray
Melee..........:  sword chop
special........:  never flinches, won't infight other Bane knights

This is a stone statue version of the Hell Knight.  The golem shares
the same model and animations as the Hell Knight, but this is where
the similarity ends.  When it finds an enemy, the golem will walk
relentlessly towards it, pausing only occasionally to launch five
shards in a deadly spray.  Each shard is an energy missile that
explodes on impact and may cause up to 40 damage per hit.  Despite
the relatively high firepower it wields, the golem can launch shards
no faster than once every five seconds.  Once the golem is within
melee range with its target, it will swing its sword down, causing
up to 120 damage per hit, much like a shambler.

As a tough construct made of stone, the golem does not flinch when
it takes damage, so it is impossible to interrupt its attacks.
Also, since it is built in the image of Bane's army, it does not
infight with its members.

"spawnflags"
4 = Statue
With this, the golem spawns dormant.  While dormant, the golem is
motionless and immune to damage.  If the golem has a targetname,
it will begin to move and become vulnerable to damage when activated.
If no targetname was given, the golem is merely decoration and will
not increase the monster count.  One note:  statue and delay spawn
(sf64) are mutually exclusive, so if both are on, sf64 will override
the statue spawnflag.

Countermeasures:
Avoid putting your back against the wall.  Multiple shards will cause
high splash damage otherwise.  Aside from that, his attacks are easy
to avoid.  The golem is the classic tank monster -- high damage and
moderate health, but very slow speed.  The player can either stay
back and shoot, dodging when necessary; or if the player feels
daring, employ the shambler dance, that is repeatedly run into melee
range then back away when the monster starts swinging, to put the
golem in a melee lock.  As it swings at air, attack.

----------------------------------------------------------------------
WARLORD

Classname......:  monster_hkboss
Health.........:  900
Size...........:  small
Ranged.........:  magic missile spray, homing spikeball,
                   lightning pillar
Melee..........:  sword slash
special........:  won't infight other Bane knights

An upgraded hell knight similar to those found in other level paks
such as mexx8, Rapture, and a few others.  The warlord wears gray
armor with blue stripes, so that it is easier to tell apart from his
lesser brethren.  (In other mods, he simply had green and yellow
stripes.)  He has increased health and extra attacks to put him on
the level of a sub-boss.  In addition to possessing the standard hell
knights' attacks, the steel lord can launch homing spike bombs like
a shal-rath or spawn a pillar of lightning.

The pillar of lightning is a thin bolt of lightning that arcs from
the ceiling to the ground continuously, and the pillar to sent
toward the player by the attacking steel lord.  Contact with the
pillar causes 15 damage per one-twentieth of a second.  A stationary
player that lets the pillar hit him usually takes 15 or 30 damage.

Countermeasures:
The knight boss favors the shal-raths' homing spike bomb attack,
which means the player needs cover to hide behind and let the bombs
impact.  Otherwise, he can be treated much like a hell knight.
Despite high health, the knight boss is not a damage monger like the
hell lords or even the barons.

With high health, the knight boss will stick around for a while if
the player does not have high rate of damage capability such as
the thunderbolt or nearly any weapon with quad damage.

----------------------------------------------------------------------
THE BANE

Classname......:  monster_bane
Health.........:  2000
Size...........:  small
Ranged.........:  leap attack, fireball spray, thunderstorm
Melee..........:  sword slash
special........:  teleportation, resurrects dead monsters, cloning,
                   immune to decapitation, will infight with anyone

The endboss of nsoe5 in Soul of Evil: Indian Summer.  As leader of
the knights, the Bane is extremely powerful and brutal.  The Bane runs
at double speed, and his melee attacks are stronger and quicker than
normal.  The combination of extreme speed and variety of deadly
special powers make The Bane death incarnate.  To help drive home the
point that the Bane is deadly and not just yet another hell knight,
the Bane wears black armor.

Leap Attack
The Bane can jump at the player just like a fiend, except the Bane
does not stop running the few frames preceeding a jump, so it is
even harder to dodge.  Contact will cost the player 40 to 50 health.

Fireball Spray
Same as the hell lords' magic missile spray except the projectiles
launched are fireballs with half the explosive power of a standard
rocket.  Each fireball can hit for up to 60 damage.  As you can
imagine, the spray will make short of nearly anything.

Thunderstorm
When summoned, the screen will darken then lightning will flash down
from the sky for about three seconds.  Each lightning bolt can strike
for up to 80 damage each.  Lightning will lock on to a point, usually
the target's origin, a half second before striking.

Resurrection
Bane may revive most dead monsters, much like Doom2's Arch-Vile.
Not much else needs to be said about this.

Teleportation
The Bane fades away then reappears elsewhere near the player.
Bane will teleport under any of the following conditions:
* Random chance in lieu of an attack if the enemy is above The Bane.
* Low random chance when hit for damage.
* Bane takes damage in slime or lava.
* Enemy has not been in The Bane's line-of-sight for more than five
 seconds.  This means it is very difficult to impossible to camp
 and hide from The Bane.

Cloning
When Bane's health falls below or at 500 in Normal or 666 in Hard,
Bane will heal back up to 500 or 666 health, disappear as if
teleporting, then multiple images of Bane reappear.  The Bane can
spawn clones only once in his life.  Each clone has all of the Bane's
powers at the time of cloning.  If a clone dies, it disappears in a
puff of smoke.  If the real Bane dies, all surviving clones vanish.

The Bane was designed as a boss and should be treated as such.
The Bane can run faster than the player, and the player will need
terrain with enough obstacles to make it harder for the Bane to
reach the player.  The player will also need powerful weapons such
as the super nailgun and enough ammo to defeat the Bane and any
monsters he may resurrect.

Initially, The Bane's powers are limited to the leap attack and
fireball spray.  In Easy, this is all he is allowed to do, but in
Normal and higher skill levels, the Bane will be allowed to use more
of his powers as he takes damage.  Once the Bane's health falls below
50% of maximum health in Normal or 66% in higher skill levels, he may
begin to teleport, summon storms, and revive any monster with a
maximum health of 300 or less.  Once the Bane's health falls below
25% of maximum health in Normal or 33% in higher skill levels, he
will clone himself and be allowed to resurrect any monster that can
be revived.

- SoE Note -
In nsoe5, the Bane will broadcast messages to all players.
He will not broadcast messages in any other map.


======================================================================

6.4. Hellspawn

monster_hell_hound
monster_imp
monster_nemesant
monster_trogboss
monster_vomit
monster_shamvile

Hellspawn includes the more monstrous members of the Shal-Rath Cult
as well as other horrors from beyond.

----------------------------------------------------------------------
HELL HOUND

Classname......:  monster_hell_hound
Health.........:  150
Size...........:  large
Ranged.........:  fireball spray, leaping attack
Melee..........:  bite
Special........:  resists fire

A nastier fiery variation of the rottweiler.  It behaves and looks
almost exactly like the rottweiler except it can pause to breathe
a spray of three fireballs from medium range at the player, and
each fireball can inflict up to 9 damage per hit.  In addition to
the fire spray, the hell hound's other attacks cause more damage
than normal.  The hell hound is much tougher than the basic
rottweiler, thanks to increased health and the ability to shrug
of pain more easily when its health is high.

Countermeasures:
Despite increased power, it is still a relatively low level threat
by itself.  Just a few shots from anything stronger than a shotgun
will put one down soon.  Just be ready to dodge if it suddenly
attacks in the meantime.

----------------------------------------------------------------------
IMP

Classname......:  monster_imp
Health.........:  75
Size...........:  small
Ranged.........:  fireball or ice spray
Melee..........:  claw
Special........:  flight, swoop

Winged little devils that fly around to cause trouble.  They can
detect and evade incoming fire, making them difficult to hit,
especially with projectiles such as nails or rockets.  From a
distance, imps can lob either a fireball or a trio of ice shards at
the player.  Fireballs explode for up to 20 damage.  Ice shards hit
for 9 damage each.  If the imp has a clear path to the player, it
may swoop at the player and try to ram him for up to 30 damage.
Up close, imps can scratch the player for 10 to 15 damage.

"skin"
0 = brown, fire imp
1 = white, ice imp
Default is 0.

"spawnflags"
4 = Statue
With this, the imp spawns as a stone statue.  While in statue form,
the imp is dormant, and the player can push it around or even stand
on it and use it as a platform.  If the statue has a targetname, the
imp will break free from its stony imprisonment when activated.  If
no targetname was given, the imp statue is merely decoration and will
not increase the monster count.  One note:  statue and delay spawn
(sf64) are mutually exclusive, so if both are on, sf64 will override
the statue spawnflag.

Countermeasures:
Imps have relatively low health, so any weapon will work, although
they will try to dodge attacks.  However, this can work against them
since firing a weapon will stop the imps' swooping attack cold.

----------------------------------------------------------------------
NEMESANT

Classname......:  monster_nemesant
Health.........:  280
Size...........:  small
Ranged.........:  explosion, bouncing fireballs, magic missiles,
Melee..........:  telekinesis
Special........:  flight, teleportation

You may remember this guy as the troglodyte from the classic
Zerstorer pack.  Well, he is back, and with new tricks.  To refresh
your memory, the nemesant can float freely in the air, much like a
scrag, and attack the player from above.  When shot at with nails or
rockets, the nemesant can teleport to the player's rear, not only
dodging the attack, but also relocated favorably to launch a counter
attack.  The nemesant from Zerstorer possessed two signature attacks,
the bouncing fireballs stolen by Bane's sorcerers, and a devastating
explosion reminisent of the Arch-Vile's flame explosion attack.
In Drake, the nemesant gains another ranged attack and a melee attack.
He can launch homing magic missiles at distant enemies, or
telekinetically shove nearby enemies away for 20 damage.

Explosion
He takes a relatively long time to cast this spell, but once done,
a large explosion will erupt and anyone caught in the blast will take
up to 120 damage.  If the intended target is close enough to ground
zero, he will also be violently thrown up in the air.  As the spell
is cast, the area around the targeted point will glitter and the
intended target will be sucked in.  The player must fight the pull
by running at full speed.

Fireballs
His signature attack, and does it better than the sorcerer disciples.
Bounces toward the enemy up to three times, and hits for up to 40
damage.

Magic Missiles
A trio of spiraling shots that will seek the player.  Aside from the
homing ability, these shots are identical to the Hell Knights'.

Countermeasures:
The player should avoid unnecessary jumping or fighting on sloping
ground since it will make it much harder to escape the pull from any
explosion attacks.

Super shotgun or thunderbolt is ideal for eliminating a nemesant
since hitscan weapons do not trigger his teleportation defense.
With enough cover and a hitscan weapon, the player can take down
a nemesant with no or minimal damage.  On the other hand, if the
player has no cover and/or is limited to projectile weapons such as
nailguns, the nemesant's teleportation will be problematic, and the
player will be exposed to the nemesant's attacks.

----------------------------------------------------------------------
THE MASTER

Classname......:  monster_trogboss
Health.........:  1800
Size...........:  small
Ranged.........:  explosion, bouncing fireballs, magic missiles,
                   lightning bolt
Melee..........:  telekinesis
Special........:  flight, teleportation, summons scrags, temporary
                   invisibility

He is simply a demon mage/nemesant with a different skin, much higher
health, and more tricks.  He can summon up to three scrags at a time,
and when reduced to half health or less, he can turn invisible for
several seconds at a time.

----------------------------------------------------------------------
VOMITUS

Classname......:  monster_vomit
Health.........:  400
Size...........:  large
Ranged.........:  blob spawning or gib shower
Melee..........:  vampiric bite
Special........:  eats weapons and corpses

One of the monsters from Qtest, the vomitus is a giant blob that
vomits stuff at the player.  The vomitus can be blue or bloody, and
what it can vomit depends on its color.

The blue vomitus spawns tarbabies by spitting them at the player
one at a time.  Each vomitus is limited to three active tarbabies
at a time, and can only spawn more when one of its existing tarbabies
is destroyed.

The bloody vomitus spews a stream of gibs at the player, much like a
zombie, except the gibs are bigger, and usually more than one are
flying at once.

All vomitus can bite the player, causing up to 30 damage per hit.
Also, 10% of the damage inflicted is given to the vomitus as health.
In addition to damage, the vomitus has a 10% chance per hit of eating
the player's weapon.  In effect, the vomitus can steal weapons much
like a gremlin.  However, the vomitus cannot use eaten weapons
against the player.

The vomitus is a voracious glutton.  Any corpse or fallen zombie
it moves over is crushed into gibs then eaten.  The vomitus gains
health as it devours the gibs.

monster_vomitus is recognized then converted to monster_vomit.

"skin"
0 = blue
1 = bloody
Default is 0.

----------------------------------------------------------------------
SHA'VILE

Classname......:  monster_shamvile
Health.........:  1000
Size...........:  large
Ranged.........:  fireballs, firewall, explosion
Melee..........:  vorpal claw smash
Special........:  resurrects dead monsters, melee decapitates on kill

The sha'vile combines powers from the shambler and the arch-vile
(from Doom II) into one scary package.  It has powerful attacks that
are difficult to avoid, resurrects slain monsters like the classic
arch-vile, and last but not least, it moves with blinding speed.
Our lead tester has called it "caffeine incarnate".  Did we mention
it is tough as hell?

The Sha'Vile has two ranged attacks to choose from.  It can lob
fireballs from its claws or it can spawn explosions centered at
its target.

The fireballs are simply flaming missiles with splash damage.
Each can hit up to 60 damage.  These fireballs also fly at fast
as the players' rockets.

The explosions the Sha'Vile can cast are similar to the fire attacks
from the Arch-Vile in Doom2.  The Sha'Vile raises it arms much like
an attacking Shambler, then a ball of fire appears in its claws.
If the player is in the Sha'Vile's line-of-sight when it finishes
its deadly spell, an explosion will erupt centered on the player,
causing up to 60 damage and producing a shockwave that violently
throws the player up in the air and shoves anyone else near the
explosion away.

The Sha'Vile can attack nearby targets with its deadly, vorpal claws.
The damage is the same as the shambler, but the Sha'Vile swings with
increased speed.  In addition to damage, any monster the Sha'Vile
kills is either gibbed or decapitated.  Also, the one-handed claw
attacks will automatically launch fireballs instead, if the swing
misses its mark.  Similarly, the double claw smash will spawn a
wall of fire if it whiffs.  Thus, the strategy known as the
"shambler dance" is ineffective against the Sha'Vile.

Given its speed, the player will need hard cover to have a chance
to avoid its explosion attack.

Finally, the Sha'Vile is resistant to damage from rockets just like
the shambler, so firing rockets at it will do little good.

Countermeasures:
If encountered, the Sha'Vile should be the first target the player
should eliminate since it can resurrect other slain monsters.
As for eliminating this beast, the super nailgun or any cell based
weapon will take it down in a satisfactory amount of time.  Also,
despite reduced effectiveness, the MIRV Launcher is still powerful
enough to seriously damage the sha'vile, at the cost of many rockets.
Any other weapon will be slow and relatively ineffective.


======================================================================

6.5 Miscellaneous

monster_ranger

----------------------------------------------------------------------
RANGER

Classname......:  monster_ranger
Health.........:  100
Size...........:  small
Ranged.........:  player weapons
Melee..........:  axe
Special........:  has armor, drops ammo and a weapon

He is a copy of the player, and can wield the many of the same
weapons just as effectively.  Compared to many other monsters,
the ranger a fast and agile opponent capable of destroying the
player with heavy firepower.  In higher skill levels, the ranger
runs at the same speed as the player, and he can lead his shots
to intercept a moving target.

The weapons used by the ranger can be set with the "drama1" and
"items" fields.  The values used are the same as used in worldspawn.
If the fields are not set, the ranger's inventory will vary by
skill level.

Skill   Default items
--------------------------------------------------------
  0     Shotgun, Nailgun
  1     Shotgun, Nailgun, Green armor
  2     Shotgun, Nailgun, Grenade Launcher, Yellow Armor
  3     Shotgun, Nailgun, Grenade Launcher, Red Armor

Given how fast and damaging a ranger can be, the player should
have at least a super shotgun or nailgun to have a fighting chance
to win.

"spawnflags"
4 = Melee
This adds an axe to the ranger's arsenal.  In addition, the ranger
will begin with triple ammo, but his attacks will consume ammo.
If the ranger runs out of ammo, he will swing his axe at you.

Countermeasures:
A ranger who approaches too close to the player will begin to
circle-strafe around him.  It is best for the player to not let
that happen or else the ranger will become much harder to hit.
Therefore, the player should always keep some distance away from
the ranger, backpedaling if necessary.  Attacking frequently
will cause the ranger to favor the nailgun over the shotgun which,
though more powerful, is easier to dodge.


======================================================================
    7. Compiling Notes
======================================================================
At the very least, you will need an enhanced QuakeC compiler with
optimization options, such as FrikQcc.  Optimization is required to
build a progs.dat that will not break any standard Quake engine
limits.  More details are available in the file "progs.src", with
comments at the top of the file.

Included in this devkit is the complete source to create a progs.dat
for most Quake engines and additional files for a progs.dat specific
to DarkPlaces.  To compile a progs.dat for DarkPlaces, open progs.src
then enable dpextensions.qc, sv_user.qc, and swapdp.qc, then disable
swap.qc.  Save the changes and close progs.src.  Recompile the source
with FTEqcc.  FrikQcc cannot compile a new DarkPlaces progs.dat, only
FTEqcc can.  DarkPlaces requires its version of a progs.dat because
it handles flymode physics differently than other Quake engines, and
it uses its builtin rain and snow effects if the map features them.


======================================================================
    T H E   E N D
======================================================================

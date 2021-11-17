AirFist Coding Readme:

This text file is to help people to integrate our code into server patches.
We, at the Evolve team, have tried to make the code for this patch as simple as
possible for people to integrate.

For this reason the code is split into 4 sections.

1. The AirFist code that does all the work.
2. The AirFist exclusion code.
3. The New Weapon code.
4. The Previous Weapon Code.

Files modified for AirFist are:

  progs.src
  world.qc
  enforcer.qc
  client.qc
  player.qc
  weapons.qc
  items.qc
  defs.qc

Files added:
  horn.qc

Other files used:
  progs\s_ablast.spr
  progs\v_airgun.mdl
  sound\weapons\agfail.wav
  sound\weapons\agfire.wav
  sound\weapons\agwater.wav



1. The AirFist code:

Files used:
  defs.qc
  world.qc
  player.qc
  weapons.qc
  horn.qc
  defs.qc

All the code sections that are to do with the main AirFist code are surrounded
by
// AIRG_MAIN_START
... code ...
// AIRG_MAIN_END

The AirFist main code is the only mandatory code for this patch.  Everything
else you can strip out and use your own code if you like.



2. AirFist Exclusion code:

Files used:
  enforcer.qc
  horn.qc
  defs.qc

All the code sections that are to do with the AirFist exclusion code are
surrounded by
// AIRG_EXCLUDE_START
... code ...
// AIRG_EXCLUDE_END

This code is optional and is used to exclude entity's from the affect of the
AirFist.  Because of the way that ID wrote most of there missile code, it is
allot simpler to exclude what you don't want than to include.  The only entity
type that we have excluded so far is laser fire.   If you want to exclude other
things, you set the AIRG_Flags field to AIRG_EXCLUDEENTITY on creation of the
entity. See enforcer.qc for an example.



3. New Weapon code:

Files used:
  client.qc
  weapons.qc
  items.qc
  defs.qc

All the code sections that are to do with the new weapon code are surrounded by
// AIRG_WEAPON_START
... code ...
// AIRG_WEAPON_END

This code is optional and is used to add the AirFist as another weapon in the
quake weapon arsenal.  We have included a number of options to customise the
weapon setup.  See defs.qc for the options.



4. Previous Weapon code:

Files used:
  weapons.qc
  items.qc
  defs.qc

All the code sections that are to do with the previous weapon impulse code are
surrounded by
// AIRG_PREVWEAPON_START
... code ...
// AIRG_PREVWEAPON_END

This code is optional and is used to add the a Previous Weapon impulse.  This is
mainly for use with the standalone version of the AirFist put there for the
convenience of quick fire quake binds involving the AirFist.
e.g. bind e "impulse 47;+attack;wait;-attack;impulse 48"

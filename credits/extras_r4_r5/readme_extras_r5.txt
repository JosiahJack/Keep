-------------------------------------------------------------------------
--About--

"Extras" is a QuakeC mod that allows mappers to create more varied and interactive environments to (hopefully) bring something new to Quake without changing how the weapons and monsters work/behave.

This was coded with my own mini-episode in mind, and version r4 marks the end of my "To Do" list. Sadly, my episode will not see the light of day (or darkness of Quake as it were...)

-------------------------------------------------------------------------
--Requirements--

You'll need the full version of Quake (obviously) but note that many of the new entities exploit the "gravity" entity field, and therefore only work with Quake builds released after the "Scourge of Armagon" Mission Pack (1.0.7 and later, I think). Custom engines should be OK, but I would highly recommend sticking with official releases, or bugfix-only opensourced builds or no frills ports for non-Windows people.

-------------------------------------------------------------------------
--Installation--

Put the "extras" folder in your Quake directory, and start Quake with "-game extras". Load up "map water", "map switches", and "map emitters" through the console to try out some of the new entities.

-------------------------------------------------------------------------
--Mapping--

The "extras/docs/" directory contains complete HTML documentation for the new entities. There are also three small test/example maps included with this release (with source):

"water.bsp"
The main features of this map are various types of moving water volumes, ladders, and a func_train_ext that can be controlled by "move" and "direction" buttons. The train control buttons themselves are func_button_ext (they can be shot or touched).

"switches.bsp"
This map featues a "realistic" elevator with control switches that move along with it, exploding entities with before/after models, and a couple examples of the extremely customizable emitters (fire and water).

"emitters.bsp"
Here you'll find emitter pre-sets for common effects like rain, snow, rubble, and shooter-traps (plus some not so useful, but interesting effects).

Entity definitions for the Quiver map editor (for MacOS) are included in this distribution, and I don't think it's much of a stretch to convert them for your editor of choice (I'll gladly add donated def files for PC editors in future releases). I've tried to include "QUAKED" comments in the source files for QuakEd based editors, but I haven't tested them personally.

-------------------------------------------------------------------------
--The QuakeC Source--

FrikQCC (for MacOS) was used to compile the included progs.dat (with args: "/o2 -allownest"), YMMV if using a different compiler.

All new entities and routines are in the "/src/extras/" directory and are heavily commented (for the most part). Modifications to existing source files can be found by searching for "pOx", or the date for URQP <http://www.inside3d.com/qip/> fixes. (Please see the "HISTORY.TXT" file for detailed change log, and version diffs).

An "oldgravity" field has been added to extras_defs.c that should be set by any player-gravity modifying entity to allow it to play nice with new entities that also modify gravity (that includes the gravity trigger in the "Scourge of Armagon" Mission Pack, if you plan on adding it).

-------------------------------------------------------------------------
--Known Issues--

- FrikBot has not been tested or modified to work with func_water or func_ladder. There will likely be issues (especially with func_ladder)
- Using a parent train, or an emitter with active particles as a killtarget will mess stuff up royally (this may or may not be fixed - Just don't do it!)
- Software rendered Quake has some issues when edge sorting func_water entities that use true water (*) textures - test your maps!
- Underwater "muffle" sound not played in DM/Coop (or else other players hear it too, and that's just silly)
- Extra weapon effects are not used in DM/Coop to save bandwidth
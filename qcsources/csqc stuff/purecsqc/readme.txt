purecsqc v0.1ish

WARNING:
This mod currently depends upon RF_VIEWMODEL behaviour that does not feel correct.
The behaviour of the engine may change at some future point, so take this mod with a pinch of salt.
Essentually: when the the view position can be moved at any point in time, or is simply not known, adding an entity with VF_VIEWMODEL and getting the warm and fuzzy feeling safe in the knowledge that it is actually attached to the screen properly without having to check where the player is, whether the player is moving, jogging, etc... its just simpler.
On the other hand, when viewmodel bobbing is implemented in csqc, when the engine doesn't know the player's entity (because there isn't one!), when the engine doesn't know the player's speed (ie: when the engine cannot automatically do weapon bobbing for you), what should happen? should it still automatically be stuck to the screen?
Additionally, should I say fuck it and just use whatever works for compatibility with DP, resulting in the need to query player positions and require that viewmodel bobbing is implemented in csqc FOR EVERY MOD THAT USES CSQC VIEWMODELS. This requires the mod know the player's speed, whether they're onground, things that are not provided via DP's CSQC builtins.
In SSQC terms, this is whether (the csqc equivelent of) .viewmodelforclient should be relative to the view, or if you should have to update the entity's origin every single frame in order to track the player properly (complete with eular angle addition...).
Obviously these concerns are not significant for purecsqc itself as purecsqc needs to implement all bobbing itself (the engine doesn't think that there's even a player, let alone know how fast its moving), but it does need to use the same API (to avoid bugs with mirrors), and thus does depend upon the behaviour of that API. The only difference to purecsqc is just an extra addition or two (or rather, removal) (or rather, assignment, as viewmodel bobbing is not currently implemented anyway).
(This paragraph should be removed when this is resolved)

What this is:
This is a csprogs.dat that runs fully within the clientside qc module, but with the full logic of the original game (meaning you can still load up a map and gib some monsters without starting up any server component).
Because this is purely clientside code, there is no support for multiplayer at all.
This mod requires a recent version of FTE. Expect to need to update (from http://triptohell.info/moodles/ ).
This mod requires that pr_csqc_formenus is set to 1. This should be applied by the included default.cfg, but if you try it with old versions first, this may fail to be applied properly.
If configured correctly, the mod should automatically load start.bsp or resume from the previous map that was cfg_saved.
Once the mod is loaded, you can use the 'csmap' command to instruct it to load a different map. This command acts like the changelevel command normally would.
You should not join a server first nor use the map/load/playdemo/changelevel/restart commands, as these are not supported modes of operation (you should get a print and the csprogs.dat then pretending that its not present).

License:
spawn.qc, pmove.qc, hud.pc, screen.qc, purecs.qc, menu.qc, csdefs.qc
These files are most easily thought of as GNU GPLv2 or above.
cleanqc's code appears to be GNU GPLv2 (but unfortunately fails to explicitly mention this, other than the inclusion of the license file , so lets assume the best because I'm feeling lucky, yay gplv2 as opposed to unlicensed and thus unusable! I make this assumption based on the belief that it is based upon the gpled v1.01 release as opposed to the quake-only v1.06 source release, as implied by the presence of a fish-count fix).
My own contributions to these files are free for you to use however you wish, I only request that you make your changes to my code available to others as I did to you.
However, as this is basically a derivative work of certain sections of the quake engine, and includes the gpled cleanqc code, you're the one responsible for figuring out whether the individual parts of the code were written from scratch, a derivative work of quake, or a derivative of the cleanqc mod - if you're lazy like me, then assume the whole thing is gplv2.
Compatibility is a bummer.
The scintilla DLL has its own license. Any other included binaries are gplv2.

Motivation:
csqc is meant to be generally compatible with ssqc so that its fairly consistant. This means that nearly everything that's needed was already there.
by putting in the time to do this, I can use this mod to test a load of different csqc features that don't otherwise get used by test mods, yet are expected to exist for people who are familiar with it. It did reveal a few bugs which are now hopefully fixed.
It also demonstrates that the csqc module works correctly even without a server connection, with more interesting workloads.
Plus its funky.
If you just want to make a single player game, this mod proves that you can do that with a quake engine, and not worry about networking details whatsoever.
Because the contained ssqc code wasn't significantly changed, it should be a sufficient starting point for adapting more extensive mods to pure csqc too.


Vanilla qc file changes:
these files are originally from gnounc's cleanqc mod, which you should be able to find online somewhere should you find yourself in need of an unmolested version.
for the most part they are unchanged - the only changes are the removal of the builtins from defs.qc, and the addition of some extra .qc files into progs.src, as well as removing a few lingering warnings.
In order to reduce the number of changes needed elsewhere, I wrote some writebyte parsing in qc. This stuff was a fairly rushed implementation and can only cope with a limited set of svcs, so if you try replacing the ssqc code with some other mod, beware that you will likely need to fix up any additions there.

csapi.qc:
Generated by the 'pr_dumpplatform -o csapi -Tcs' console command.
This file contains a list of the various public api functions provided by FTE.

csdefs.qc:
csapi.qc contains only api defs that are supported in the current module, thus it lacks certain things.
This includes both non-networked fields (and their values), and csqc wrappers/reimplementations for ssqc-only builtins.

pmove.qc:
some crappy pure-qc player physics. usable as a base if you want completely custom physics, but not exactly readable.
note that the player's movetype is |256 to prevent the engine from using non-player physics on the player's entity.

spawn.qc:
some simple crappy code to parse entities from the map, and call spawn functions in a similar way to how the server would do it.

menu.qc:
basic and partial replacement menus. intended as a stepping stone rather than a full implementation. omissions are implemented by just using the engine's menus instead.
it includes a binds menu on account of the api being a bit weird, but no sliders/checkboxes/etc for cvar tweaking. most people should have no problem just using cvar/cvar_set to draw whatever sliders as desired.
if you want mouse support or something 

hud.qc:
the engine's hud only supports reading ammo counts from stats. thus if we want to read entity fields to discover how much health we should have, we need to provide our own csqc hud implementation.
note that the included hud is of course only usable for pure csqc, check out my pourtall mod if you want a more traditional csqc version.

screen.qc:
Contains the CSQC_UpdateView function, which handles the 3d rendering differences between ssqc and csqc.
This is the bit of the code that implements interpolation and particle trails, as well as setting up the game view.

purecs.qc:
Contains all the code that isn't elsewhere, basically.
Mediates between the vanillaish qc and the csqc api, including console commands (noclip etc), map changes, 

ssqc.qc+fteextensions.qc:
demonstrates that the ssqc codebase can still be compiled for ssqc with only one change - the addition of fteextensions.qc to compensate for the loss of the builtins from defs.qc
This is not a particuarly practical demonstration, but is nice to demonstrate that its somewhat trivial to port a mod to pure csqc by adding the extra qc files from this project to an existing mod.

limitations:
no multiplayer. potentially, the mod could be hacked up to support split-screen, but I didn't bother. Its not currently possible to tell the client to switch number of seats without it joining a server.
no multiplayer means no demo recording either.
no saved games. presumably the cross-level cvar should be flagged as archive, then the worst case is just a map restart. yay, no more quicksave cheating! saved games could be implemented with frik_file, but I didn't bother. model precaches would be a pain.
player movement was written purely in qc, so it doesn't match quake that well. airstepping is on for a start.
the hud etc was rewritten in qc, which generally means it ends up a bit different from what you're familiar with. on the plus side, tweaking it is more trivial than ever before!

omissions/issues:
death tilt isn't implemented.
no weapon bobbing. there's a bug in there somewhere.
no view bobbing either. the engine won't do it because it isn't tracking the player's speed.
no pause. csqc has no control over the current game time, as timing is normally meant to come from the server, to keep things consistent. potentially you could 'pause' by disabling physics completely, and then fixing up timer fields by adding the length of time the game was paused for. this version of the mod is intended to be somewhat easy to glue into an existing ssqc mod, so I didn't bother assuming to know all timer fields.
no player step smoothing. feel free to write some.
qc player physics has buggy air-step enabled. this means you can actually jump higher.
rocket trails - should they generate an rt/dlight as part of the trail itself? the jury is out on that one.
I expect there are a number of bugs with csqc te_* builtins not spawning sounds, but I didn't check.
If you want to fix these and give me your fixes, get in contact with me.

engine tweaks:
getting a world map loaded without a server running was the primary change required.
there were also some bugs with setsize+setmodel.
csqc's setmodel now sets the modelflags field so you can see the model's flags. handy. this avoids having to hardcode trail flags.
there were also some misc bugfixes.
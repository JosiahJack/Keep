We have included Deathmatch Maker formatted files for all of the levels included on 
this cd-rom.  These examples illustrate both good level-building and some common 
pitfalls that you may run into as you build levels for Quake(TM).

If you installed Deathmatch Maker with the Parental Lock option you will only have 
the VSTART example file.

Several of the levels will compile without any problems, but some of the following 
templates will illustrate common problems with compiling Quake levels.  These 
templates will provide you with material for building your own levels and examples 
for work.

Some of the examples included are incomplete versions of levels used in the Virtus
episodes.  These levels exhibit good level-building techniques and provide 
examples of common pitfalls.  

Several levels will compile and run without warnings and leaks.  These allow you a 
starting point for building your levels or for scavenging pieces and starting your 
own.

Several of the levels have common problems.  We list these below to enable you to 
trouble shoot and to fix problems.  None of the levels have errors that prevent the
full compile of the .bsp or light, but they may contain leaks that prevent the full 
visibility compile.

Listed below are all of the levels included on the CD that are built by Virtus. We
provide information about their state and some of the common pitfalls that you can fix
to get a feel for level building.

Compile time estimates are based on a Pentium 133 Mhz with 16 MB RAM.

VSTART	This is a good example of building with Deathmatch 
Maker.  There are good bridges and archway slipgates to steal 
and use in your levels. 

This level compiles to .bsp in under 5 minutes and reports 
only one warning.  The warning is "One or more geometric items 
without a texture were found" and is an indication that a 
geometry was created and the surfaces were not all textured.
When you drag textures into the Walk Window, only the surface you 
drag to is textured, unless you hold down the Ctrl or Shift key.
Since Deathmatch Maker does not know if you are using the inside 
or the outside of an object, it checks all surfaces for textures.
The .bsp compiler removes faces that are not used so the untextured 
face may not ever show up in Quake(TM).  To identify untextured faces, id
placed a default pink-and-black-checkered pattern texture on 
those faces.  If you see this texture when playing your level, 
you can then go back to Deathmatch Maker and re-texture the 
surface. This texture also appears if a texture you used is not 
found in the Virtus.wad file. 
		
E1M7EX	This is a good example of a full level.  It was 
designed with both deathmatch and multiplayer in mind, but it 
does make excessive use of large spaces that will slow the game
down some, and includes a lot of dead (unused) open space.  

This level was designed to be easy to place bad guys and to 
change the difficulty level.  Practice adding or removing ammo 
and armor to see how hard a few changes make a level.
There is a geometry without texture warning error. This level 
compiles to .bsp and light in under 5 minutes.

VDM1		A deathmatch-only level, this level is a unique example
of thinking through the design before starting to build.  This 
level is built entirely out of slabs and uses the Advanced Items
Gallery to place bad guys, ammo, and power-ups.  The white boxes 
draw faster than textured boxes, and therefore, the Walk Window 
draws faster when you want to view your level.  This level makes 
good use of the Layer Editor.

The designer of this level thought through the design first, 
built the main rooms and connecting halls, and spent the 
rest of the time filling them with the tiers of walkways and  
precisely placed objects.

This level compiles to .bsp and light in under 10 minutes.  It 
reports a geometry without texture warning and it indicates that 
there is no player start position defined.  A player position must
be defined to run properly in Quake. When Deathmatch Maker does 
not find a start position, it creates one where the Walk Window 
Observer is last located. If the Observer is looking at the outside of 
the level, when you load your level into Quake, you will start 
outside of the level and you will fall forever.  

ARENA 	This simple level shows the effects of textured objects
slowing down the Walk Window.  You will run into this as you build 
complex levels, but it can be avoided by using the layering 
capabilities of Deathmatch Maker.  This level is also fun to pit
bad guy against bad guy or player against different bad guys and see 
their limitations and abilities.  There is also a trigger that fills 
a doorway, which shows that triggers can be anywhere. Play this level
as is to see which bad guy is the strongest, change the bad guys 
to see who hunts best as a pack, and which monsters are loners.

VE1M1	This is a full-fledged level that is both deathmatch- and 
multiplayer- ready.  The major features of this level include heavy use
of the layering and the coloring of layers.  Another notable 
feature is the use and placement of animated textures.  The texture 
boxes from the Animated Textures Gallery are all lined up outside the 
level to ensure all of the needed textures are included in the level.
This level keeps one ground plane but goes up to add the feel of a 
real warehouse. The compile time is under 30 minutes for .bsp and 
lighting.  
	
VE1M2	This level is an example of a linear-progression level.  
The player has a definite order and sequence of events that lead to the
end.  The tasks branch out and up from a central room, and the player
must return to the center to start the next task.  This leads to lower
quality of deathmatch play but is quite feasible in multiplayer mode.
This example has one problem: It has at least one leak.  

While the leak does not stop the .bsp and light compiler from running 
in under 30 minutes, it does keep the visibility compiler from running.
(The leaks are caused by gaps between walls or items sticking out of 
the level.) Here are several suggestions to help find the leaks.  The 
first is to remove all of the objects, leave the geometry, and compile 
to ensure you have not placed an item through the walls.  Another is to 
be sure trains and doors are all contained in the level for their entire
path, and while open or closed. Another is to light the level, suround 
it with a box, and use the console NOCLIP command in Quake to fly around
and look for the light leaking out of the level walls. After compiling
in Deathmatch Maker with the 'Remove temporary files' checkbox 
unchecked, the leak file is written to the same file as the .bsp. 

One way to find leaks is built into Quake. Put the leak file in the maps 
directory with the .bsp, load the level, and from the console type 
POINTFILE. This will put a visible marker at each leak point.  Do not do
this with huge .pts files because it will take forever.  In this model
it is just a bad guy in the wall and the coordinates of that are listed 
when you load the map. 

Another warning in this level is "Brush with duplicate plane." This is 
usually caused by polygons inter-penetrating or by infinitely thin
geometries. If you create intersecting geometries, Deathmatch Maker cuts
the object up into faces so Quake can use them.  If a face is too thin, 
less than 1 Quake unit, it causes this warning.  Most of the time this 
is not a serious warning but sometimes this causes a huge phantom wall 
in the running version of the .bsp. These phantom walls can be nasty to 
find because they are usually small intersections or walls that were 
accidentally dragged to have no thickness.   

VE1M3	Playability is a big concern while building a level.  This 
level has some playability issues, but it is sound in the flow and 
progression. Take a look at the pieces of this level and decide what 
you would add to it to make it feel more thought out and more playable.
This level is very large and has lots of dead ends and places to add and
expand.  Overall, a good level with lots and lots of things to use.  

This level demonstrates that even though Deathmatch Maker gives you the 
ability to make items that are small and intricate -- like a grate or a
set of spiral stairs -- it is best if you build using bulky objects.  
The use of bulky geometries helps to avoid large face counts that slow 
drawing down. The use of bulky geometry also helps you avoid the trap of
creating detail that will never be seen in Quake.  

VE1M4	We chose this level at a point where it had lots of leaks to
allow you to see some of the different ways leaks manifest themselves. 
While compiling this level, which takes around 40 minutes, you will get
12 warning messages like: "CutNodePortals_r:new portal was clipped 
away." This is a leak in another form. These are leaks created by very 
small, sometimes less than 1 Quake unit, gaps between walls.  To avoid 
these, always work with the Snap to Grid option turned on.  If you turn 
it off, you will have many of these warnings. 

Another very dangerous problem with this map is the error you get at the
beginning of the compile: "An object was named 'walkway' but is not 
targeted. All objects with names must be targeted." We put this error 
check in place because almost all objects can have a name or a target, 
but when the compiled level is run in Quake, all targeted or named 
objects must have a mate. The map will not run unless you fix this error.

VE1M5	Another complete level to pull some great items from. Pay 
attention to the push triggers that create the effects of throwing the 
player into the air or up a shaft.  There is also a simple example of a 
train that works very well with two platforms. 

VE2M1	This level shows how easy it is to create a recognizable 
real-world situation that is fun to play.  This mock-up of a subway 
station gives you the look and feel of a real subway. The final version
suffers from spaces that are too large, and it runs very slowly.
There is no number we can supply that will help you decide what size 
room is too big. If you you can, have very large rooms broken up by lots 
of objects: The level will run fast.  You will just have to experiment
for yourself.

This level will compile to .bsp in around 30 minutes, but it has several 
warnings. The CutNodePortals warning listed in VE1M4 and a new warning: 
"Couldn't create brush face." This warning is caused again by 
inter-penetrating objects that create faces that have parts over 1 Quake
unit thick but in general are too small to create a useful face in Quake.
To avoid this problem, do not intersect objects.  This problem may create
a leak, but in general all that will happen is that the face in question
will just be dropped and you will see no difference.

At this point in this level it was surrounded by a large box to allow
the visibility compiler to run.  This is a very bad technique that 
causes the level to run very slowly.  This is a valid way to help view 
the level and to try and find some of the leaks.

VE2M2	This small level is another example of how you can use 
Deathmatch Maker to create a level with a real-world theme.  This 
cityscape has the look and feel of city streets, sewers, and buildings.
When playing this level, look for the flashing street lamp that is a 
slightly different color, because you can shoot it out to open a 
secret.

VE2M3	The Office Park intends to give the look and feel of a place
of business.  With a parking garage, freight elevator, and garden foyer, 
the illusion is complete. Create your own office floor and add it above
the main room. The lift can take you to it and you can frag your office
mates.

VFINAL	A very complete level that shows some of the things you can do
with lava. Look for lava pits in the main intersecting room that bad guys 
come out of and that you can go into. This level also combines lifts that
move at angles as well as large rooms and lava to create a solid 
atmosphere of danger and difficulty.  This level combines many of the 
techniques available to the Quake level-builder into a fun to play and 
visually stimulating level. When playing the Virtus episode examples that
are installed, notice the new end bad guy the lava worm that we threw 
into this level for your enjoyment. If you aspire to create great levels,
spend time looking into this one for some of the techniques used and for 
the way it makes you feel when you enter a room.


Virtus is a registered trademark and Deathmatch Maker is a trademark of 
Virtus Corporation. 

QUAKE(r) Texture Graphics and Artwork(c) 1996 Id Software, Inc.  All
Rights Reserved.  
QUAKE(r) is a registered trademark of Id Software, Inc.
The Id Software name and logo are trademarks of Id Software, Inc.



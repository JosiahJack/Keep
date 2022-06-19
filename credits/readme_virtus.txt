Virtus DeathmatchMaker Readme 3/17/97

What this readme contains:
I.	Hello from Virtus
II.	Installation Notes
III.	Technical Support
IV.	Things You Need to Know
V.	Places to Look for More Info
VI.	Mindspring Offer
VII.	Legal and Copyright Stuff


I. Hello from Virtus
Virtus' Deathmatch Maker software provides everything you need to create 
and edit 3-D levels for Quake(R) without building anything from scratch! 

This fast, easy 3-D level-building program features a drag-and-drop 
WYSIWYG approach: You drag templates and basic 3-D shapes 
from galleries and drop them into the Design Window. 

To construct complex multilevel rooms and interconnecting corridors, 
you combine templates and basic 3-D shapes. Then, you edit the room 
templates and shapes and sizes, and add surface features such as 
windows and doorways. After that, you drop in textures like wood, stone, 
tile, sky, water, lava, and more to create Quakes unique look. 
Then you can drag and drop Quake objects, weapons, ammo, 
environmental hazards and effects, power-ups, and bad guys
from the 3-D gallery and add them anywhere in your new Quake level. 
Additions and changes immediately appear in the Walk Window, 
which lets you explore your level. 

Deathmatch Maker features space in which to design your Quake worlds, 
a set of editing tools, and different navigation techniques. 

Also included are galleries of 2-D surface features and textures, 3-D shapes, 
and Quake objects and bad guys, all of which you can add to your Quake worlds. 
Deathmatch Maker also provides several pre-built Quake levels that illustrate 
the program's level making, texture mapping, and walk-through capabilities.

II. Installation Notes
*****System requirements*****
-Windows 95
-Intel Pentium Processor
-8 MB RAM (16+ MB recommended)
-40 MB available on hard drive
-SVGA monitor in 256 colors
-CD-ROM drive
-Quake (registered version; Quake requires 80 MB of hard drive space)

*****How to Install*****
Follow these steps to install your Deathmatch Maker application:
1. Insert the Deathmatch Maker CD-ROM in the CD-ROM drive.
2. Run setup.exe from the root directory of the CD-ROM.
3. Follow the installation options in the dialog box. The default installation
is the Deathmatch Maker application and all the contents.

As the program is installed, a progress meter shows the status of the installation.

III. Technical Support
The best place for updates, the newest information,  and technical support
is the Virtus Deathmatch Maker web site! Point your web browser 
to http://www.deathmatchmaker.com.

If you have difficulty installing Virtus Deathmatch Maker, call 
(919) 467-9599.

IV. Things You Need to Know
A. Outstanding Issues
1.  BSP Compiler Leak: The bsp compiler has a small memory leak. 
After several compiles of a large level you will notice your memory 
usage bar increasing.  When this gets to about 80 percent, we suggest
you save your file, exit the application, and run the
application again with your file to clean up this leak.  Note this
will only be noticeable on large levels after multiple compiles.

2. When Objects Won't Export: If you drag and drop an object from the
Basic shapes 3-D Gallery to the Design Window, place the Observer inside it,
apply a texture or textures, and export (Compile BSP), you will get this 
error message: 

DMM reports: Unexpected Error: Entity with no Valid Brushes. 

This error message will occur when you try to create a minimal, very
simple level using an object from the Basic shapes 3-D Gallery. Basically,
the object has not extruded (see "Hulling Effect Tips" in "Understanding Quake 
and Deathmatch Maker Concepts" in the user's guide for a brief explanation 
of this topic). To prevent this from happening, at the very least, add a 
transparent surface feature or an object from one of the galleries 
to the object, and export to Quake. 

3. Deleting Layers: You cannot use the undo command after using the Delete layer
menu command.  If you do attempt to undo after you delete a layer Deathmatch Maker
will behave unpredictably.

4. Virtus Episodes: When you install Deathmatch Maker, the completed Virtus examples
are installed in your Quake directory in episode format. To play Virtus' levels, 
from the Quake directory at the DOS prompt type:

quake -game virtus +map vstart 

and press Enter.  Quake will start with Virtus' levels loaded.

B. Tips and Tricks
1. To Increase Deathmatch Maker Processing Speed: While you are creating 
your levels, reduce/minimize the size of your Walk Window.

2. HTML Version of Textures: An HTML version of the textures in the .wad file 
is available. Use your HTML browser to call up index.htm from the 
'textures\HTML Pages' directory to see what the textures look like.

C. Documentation
1. Description of Gallery Window and Its Parts: The Gallery Window and its parts 
are described in "Selecting 3-D Galleries" in the "Tasks" chapter.

2. Name Change: Basic 3-D Gallery name was changed to Basic shapes
3-D Gallery (in the 3-D galleries). 

3. Rectangle object: Rectangle object was dropped from Basic shapes 3-D
Gallery, and Square should be used instead of Rectangle in "Getting Started."

4. Description of Revert and Default: The Revert button and the Default button 
are not fully described in "Reference: Deathmatch Maker Interfaces."
On the Preferences drop-down under the Edit menu, you can choose
between four buttons: OK, Cancel, Revert, and Default. The first two are
standard Windows 95 buttons. The second two are Deathmatch Maker buttons.
The Revert button allows you to change back to the previous setting.
Default allows you to reset the default setting to the one of your choice.

5. Rigid objects are not fully described. Rigid objects are representations 
of Quake-created objects: Ammo, health, bad guys, etc. They can be moved, 
but they cannot be re-textured or re-sized. You can recognize them by their 
red handles when they are dragged and dropped in the Design Window.

6. Text File Documentation: Due to time constraints, some documentation 
additions are in the text file form in different directories.  
Utilities.txt is a list of the unsupported tools we included on the CD.
Example guide.txt in the examples directory is a guided tour of the sample
files we included. Property.txt is a breakdown of the gallery items and 
textures and lists who owns the rights to use and distribute them.

V. Places to look for more info updataed or new from the documentation.
*****Web Sites*****
The Best Quake Levels
http://www.ruralnet.net.au/~huda/index.html
Offers deathmatch and single-player level ratings and downloads.

Quake C Archives
http://www.planetquake.com/qca/index.shtm
Patches, FAQ, levels, etc.

Quake Command
http://www.nuc.net/quake
Diary of Quake fanatic and links to other Quake pages.

Scary's Quakeholio
http://www.quakehole.com
Demos, QuakeC patches, links, downloadable .maps and utilities

Seismic Spew
http://www.gatsbyhouse.com/quake
Forum, downloadable files (partial conversions, demos, QuakeC, 
documentation, graphics, sounds, levels, utilities, etc.), FAQ, news, links, etc.

*****Books*****
Prima's Quake Games Secrets : Unauthorized Guide to the Shareware 
Levels. Kip Ward, Mike Van Mantgem (Prima, 1996).
Covers all the shareware levels, secrets, monsters, etc.

Quake: Authorized Strategy Guide. Kevin Perry with Ed Dille 
(Ed Dille, 1996).
Explains all the levels of Quake in order on the normal difficulty setting. 
Offers secrets, maps, and weapon ranges for various bad guys.

Quake: Authorized Strategy Guide. (Indianapolis, Indiana: 
Brady Publishing, 1996).
Explains all the game basics, explains missions, provides detailed maps, 
offers strategies.

*****Articles*****
"Design the Fault Line" by The Levelord with Tom Mustaine, PC Games 
(February 1997) 35-38.
HIGHLY RECOMMENDED as a general overview of the technical side of 
Quake level building, especially compiling, frame rates, and troubleshooting.

*****Newsgroups*****
alt.games.quake 
rec.games.computer.quake.announce 
rec.games.computer.quake.editing 
rec.games.computer.quake.misc
rec.games.computer.quake.playing 
rec.games.computer.quake.quake-c
rec.games.computer.quake.servers 

VI. MindSpring Offer
Included on Virtus' Deathmatch Maker CD-ROM is the MindSpring
Internet software package. With MindSpring, you can surf the
'Net, receive email, and much more. The instructions are below:

1. Insert Virtus' Deathmatch Maker CD into your CD-ROM drive.
2. Run: [your cd drive]:\setup.
3. Follow the instructions at the prompt.
4. Complete forms for registration.
5. Select your monthly usage plan.
6. Mindspring will check for your modem, verify the mailbox name that you
requested, and return confirmation of a userid, your mailbox name, and your 
password. PLEASE WRITE DOWN THE PASSWORD.
7. You will be asked if you want to restart your computer.  You MUST
restart for the installation to be complete.
8. Click on the PipeLine+ icon on the desktop.
9. Click on the Connect button to connect to MindSpring.  Some subscribers
may experience a delay in establishing their first connection while
MindSpring activates their new account.

Need Help?
For help with your MindSpring software, consult the software version of
our "User's Guide" included on the enclosed CD.  It is located at
d:\mspring\manual\manual\manual.doc.  If you do not have Microsoft
Word, you may use the WordViewer also provided in the "manual" subdirectory.  
If you would like to order a printed copy of the User's Guide, 
please e-mail MindSpring Customer Service at service@mindspring.com 
or call 1-800-719-4660 and request a copy of the manual.  Your account 
will be charged $10 for each manual shipped to you.

If you have an Internet connection, check our on-line help pages at
http://help.mindspring.com/.  If you are able, you may send an e-mail
describing your problem to MindSpring Technical Support at
support@mindspring.com, or call the MindSpring Technical Support line at
800-719-4660.

VII. Legal and Copyright Stuff


Copyright 1997 Virtus Corporation. All Rights Reserved.
Virtus Corporation
114 MacKenan Drive, Suite 100
Cary, NC 27511
http://www.deathmatchmaker.com
Installation technical support: (919) 467-9599

Virtus is a registered trademark and Deathmatch Maker is a trademark of 
Virtus Corporation. 

QUAKE(r) Texture Graphics and Artwork(c) 1996 Id Software, Inc.  All
Rights Reserved.  
QUAKE(r) is a registered trademark of Id Software, Inc.
The Id Software name and logo are trademarks of Id Software, Inc.

All other trademarks are property of their respective owners.


Title    : Drone QC Modification Beta 
		(c)opyright 1996 Jacob Fenwick, Robin Ball.  All rights reserved.
Filename : drone07.zip
Version  : 0.7 Beta
Date     : 12/24/96
Author(s): Jacob Fenwick, Robin Ball, Jim Dodge
Email    : dor12@cocentric.net ballra@falmouth.ac.uk jdodge@net-link.net
Credits  : Robin Ball for making the Drone model.
           Jim Dodge for doing the QC base.
           IdSoftware for making Quake
           Bryan Martin for MedDLe ver 1.7
           


Type of Modification
--------------------

Additional Monster

Deathmatch    : no
Single Player : yes

Quake C       : yes
Sound         : yes
MDL           : yes



Description of the Modification
-------------------------------
This makes a new monster that you can include in your levels by adding
monster_drone in as the drone's spawn spot. 


How to Install the Modification
-------------------------------

First, create a subdirectory under \quake called drone
Ex(from dos): md c:\quake\drone

Next, unzip the drone07.zip with the -d extension 
Ex(from dos): pkunzip drone07.zip -d c:\quake\drone

Then, start your game with the command line parameter "-game drone"
ex: quake -game drone
(there is a test map included, type quake -game drone +map drone)

Technical Details
-----------------

This .qc modification is derived from id Software's .qc source version 1.06.

The pak0.pak file includes, and can be unpacked into, the following files:

	progs.dat				(the compiled .qc code)

	maps\drone.bsp                          (drone test map (crummy))

        progs\drone1.mdl			(drone model)
	progs\drngib1.mdl			(a drone gib)
	progs\drngib2.mdl		        (another drone gib)
        progs\drngib3.mdl                       (yet another drone gib)
	
        src\drone1.qc                           (drone's QC)
        src\ai.qc                               (used for the drone's sight sound)
        src\client.qc                           (used for the player death from the drone)

Author Information
------------------

You dont need to know about me, I only made the text and fixed coding 
anyways 8-) Although you can go to my page at
http://www.geocities.com/SiliconValley/Park/2134
But, Robin Ball is an aspiring artist and game designer, and his page is at
http://www.compulink.co.uk/~999sw/pages/robinb.htm
Go check it out!

If you want to email any of us:
    
        Jacob Fenwick: dor12@concentric.net  (thats me)
        Robin Ball:    ballra@falmouth.ac.uk
        Jim Dodge:     jdodge@net-link.net

Distribution Permission
-----------------------
You may use this monster in your own maps, tc's whatever, but please let 
me know and give us credit! I want to see how well people like it 8-)

Availability
------------

This modification is available from the following places:

http://www.geocities.com/SiliconValley/Park/2134/drone.html
ftp.cdrom (SOON!)


Version Information
-------------------
0.7     First Release

Disclaimer and Trademarks
-------------------------
The author takes no responsiblity for misuse of	this program. 
He is not responsible for any damage caused by it.


Quake TM (c)1996 Id Software, Inc.  All Rights Reserved.
All trademarks are the property of their respective companies.

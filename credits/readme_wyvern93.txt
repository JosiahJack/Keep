Title    : Wyvern QC Modification 
		(c)opyright 1996 Jim Rowley.  All rights reserved.
Filename : wyvern.zip
Version  : 0.93 Beta
Date     : 11/24/96
Author   : Jim Rowley
Email    : howley@cts.com
Credits  : Quake TM (c)1996 id Software, Inc. All Rights Reserved
           id Software, Inc. again for their version 1.6 QC source code
           Bryan Martin for MedDLe ver 1.5
           Tristan Rowley (no relation) for ideas in his flames.qc


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

This modification introduces a wyvern monster into your original quake levels.
Currently, the wyvern replaces 1/3 of the original scrags in your quake levels.


How to Install the Modification
-------------------------------

First, create a subdirectory under \quake called wyvern
Ex(from dos): md c:\quake\wyvern

Next, copy the pak0.pak file included with this modification into your new directory

Then, start your game with the command line parameter "-game wyvern"
ex: quake -game wyvern


Technical Details
-----------------

This .qc modification is derived from id Software's .qc source version 1.06.

The pak0.pak file includes, and can be unpacked into, the following files:

	progs.dat				(the compiled .qc code)

	progs\wyvflame.mdl			(lingering flame)
	progs\wyvern.mdl			(wyvern model)
	progs\h_wyvern.mdl			(wyvern's head gib)
	progs\fball.mdl				(wyvern's fire ball)

	sound\wyvern\growl1.wav			(idle growl1)
	sound\wyvern\growl2.wav			(idle growl2)
	sound\wyvern\growl3.wav			(idle whine)
	sound\wyvern\flapup.wav			(wings flapping up)
	sound\wyvern\flapdown.wav		(wings flapping down)
	sound\wyvern\sight.wav			(ahhah!)
	sound\wyvern\fire.wav			(breath fire)
	sound\wyvern\sting.wav			(sting player)
	sound\wyvern\pain.wav			(ouch!)
	sound\wyvern\death.wav			(double ouch!)


Author Information
------------------

I am a PC game addict. Some current aspirations of mine include becoming good enough at 
Quake (TM) to be an asset to a good clan, writing more .qc modifications, and possibly 
joining a team working on total conversions for Quake (TC's).

Look for my other .qc modifications:

magnagun.zip, a magnetic gun; a cool blaster for deathmatch/singles. :)
psislug.zip, a psionic slug; my first new monster for quake :)
goblin.zip, my second new monster for quake: a smaller, faster, and nastier grunt. :)


If you have:
	any praise whatsoever,
	constructive critisism,
	an interesting TC you may need help on,
Please e-mail me at this address: howley@cts.com


Distribution Permission
-----------------------

AUTHORS MAY ***NOT*** USE THESE MODIFICATIONS AS A BASIS FOR ANY 
OTHER WORK UNLESS YOU HAVE PRIOR PERMISSION FROM ME: howley@cts.com


Availability
------------

This modification is available from the following places:

Not sure yet.  Probably ftp.cdrom.com, www.stomped.com and bubbah's web page.


Version Information
-------------------
0.9	Original

0.91	Converted only 1/3 of wizards to wyverns, instead of all
	Changed flame code to require less processing
	Reduced flinching
	Reduced the delay between deciding to breath fire and firing
	Increased starting health to 400

0.92	Sped up movement
	Altered flame code to spread quicker
	Improved AI to slide based on range & enemy facing
	Improved AI to dodge some missile attacks
	Fire breath: aim lower, and increased fireballs to 5

0.93	Increased Wyvern size by 150%
	Created new animated fireball model
	Reduced finching further


Disclaimer and Trademarks
-------------------------
The author takes no responsiblity for misuse of	this program. 
He is not responsible for any damage caused by it.


Quake TM (c)1996 Id Software, Inc.  All Rights Reserved.
All trademarks are the property of their respective companies.
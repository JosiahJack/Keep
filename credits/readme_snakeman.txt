Title    : Bubbah's Snakeman
Filename : snakeman.zip
Version  : 1.0
Date     : Oct. 23, 1996
Author   : Bubbah -- aka. Tan Sian Yue and parts of qc by Coyote
Email    : yue@worldaccess.nl
Credits  : id software for a kick-ass game
           & Ken Turner's Spider qc and help when I was stuck and 
	   also Ken's qc-file as the base  
           ,hell even Ken's .txt file (hope he don't mind). 
           I got little time as it is...
	   Also like to thank Coyote~ for his 
           input and help in making the qc file. All the AI credit
           should go to him...(thanks)

Type of Mod
-----------
Quake C  : yes
Sound    : no
MDL      : yes
BSP      : yes

Format of QuakeC
-----------------------------------
unified diff  : no
context diff  : no
.qc files     : yes
progs.dat     : yes
BSP           : yes

Description of the Modification
-------------------------------

Snakeman is a muscle bound, double Uzi Wieldin' "Snake-man". 
He likes dark, tight places where he can unleash devastating ambushes
upon uncareful travellers. He ain't too bad in open spaces either...Strafin'
and running up, firing at your, scared shitless little arse!!!
Highly trained mercenaries (a grunt-extra), the ARMY of SNAKEMEN...

He has 2 death sequences, 2 hurt sequences, a walk sequence and a
Double Uzi Blastin' sequence. Hell I've even made an Uzi.mdl that bounce 
around when you Gib him...heh.

You can use him in all your new levels.
Note that this distribution is not intended as a stand-alone
modification.  At least some knowledge of Quake editing is
required.


How to Install the Modification
-------------------------------

Unzip "snakeman.zip" into a subdirectory "snake" in the quake directory,
copy the snakeman.mdl and uzi.mdl files into a progs subdirectory.
thus C:\quake\snake\progs.dat
     C:\quake\snake\snake.qc
     C:\quake\snake\snakeman.txt
     C:\quake\snake\progs\snakeman.mdl
     C:\quake\snake\progs\uzi.mdl
                                           just in case |-)

     C:\quake\id1\MAPS\snaker.bsp

To include Snakeman in your new levels, simply place an entity
with a classname of "monster_snakeman" into your map.  Note that
the snakemen are fairly large and need about the same amount of
space as the shalrath-- make hallways a little broader so he can strafe.

In addition you must add "snakeman.qc" to your "progs.src" file
and re-compile- if you want to use a different ai-or want to mix 
him with other favorite qc files, like Ken's Spider.
All required code is contained within "snakeman.qc"
so it should mesh seamlessly with your own mods.

***Finally, please notify me if possible so that I may check out
   your level!*** yue@worldaccess.nl

For testing purposes I have included a bsp file called SNAKERS...
Copy this into your ID1\MAPS directory... The map is a test and only
intended to show what these critters are capable of etc... It's
especially tough, just a section from a map I did called Bubbah.zip 
(can be downloaded from "Only The Best Quake Levels" 
(without snakes, though, but complete)).
Don't worry about the walkmonster in wall text at startup...

run quake by

quake -game snake +map snakers

happy blastin'


Technical Details
-----------------

Sankeman was created from scratch using 3dstudio, Bones IPAS 1,2 and 3.
The Blobsculpter 2.0 and Adobe Photoshop 3.0.


Author Information
------------------

Bubbah studies Architecture in Delft and was enlightened by the huge
potential of VR. walkthrough the QUAKE engine has. Unfortunately now he's
doin' other things that have absolutely nothin' to do with his studies
and ends up makin' things like Snakemen.... And for the future (and watch 
out for this folks) AMAZONIAN BAZOOKA BABES....

Notice
------

Anyone out there likin' my model and wantin' to use it in their TC, 
go ahead... I'd be glad... But mail me... Anyone interested in
workin' with me on anythin', mail me. Anyone with a good idea for
a new monster, mail me...Anyone with a good model, mail me...

I want to set up a quake modelling alliance (or somethin'), Mail me.


Copyright and Distribution Permissions
--------------------------------------

Authors are encouraged to include these modifications in their
freely-distributable levels, as long as this description file
remains intact and unmodified and is included in the distribution.
Only thing I ask of you is not to mess around with the skin in the mdl
file... I want to be able to recognize him, you see...thanks

Authors may not include these modifications in commercial products
without prior written permission of BUBBAH aka. Tan Sian Yue.

Cheers
BUBBAH



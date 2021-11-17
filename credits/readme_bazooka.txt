
================================================================
Title                   : BazookaBabes 2.0
Filename                : bazooka.mdl, h_babe.mdl, pulse.mdl, progs.dat, 
			  bazooka.qc, step1.wav, stepstop.wav, *.wav
                          ,bazooka.txt
Author                  : Bubbah aka. Tan Sian Yue
Email Address           : yue@worldaccess.nl
Misc. Author Info       : Used the step wav files from Ultimate Quake...
Description             : There's too little women in Quake... So i added one
                          im not talkin' 'bout the fragile type, but the ROBUST
                          ass-fraggin' A.Shwarzenegger Type, hyper, mega, 
                          stompin',bitchy type...MEGA BIG!!!
                          Babes with a vengeance!!! Broadzillas...
                          (excuse the phrase)...Quake dude looks puny in 
                          comparison...heh...
                                                 
Additional Credits to   : Gyro Gearloose, Lando (for gettin' me the qmflag 
                          proggy) Brian K. Martin and Gib666 for
                          test drivin' her and comments...And my personal
                          babe S. for her voice...heh...

Stuff used              : Well, 3dstudio, Bones IPAS123, Meddle, Adobe Photoshop, Grafixer, 
                          Blobs2.0, qmflag and FASTQCC...thank you all... 

Keep checking http://www.worldaccess.nl/~yue/mdl.htm for more monster stuff!
                          
================================================================


* HOWTOUSE *

when makin' yer level, use the monster_bazooka to add a bazooka babe
to that level...she's as big as a player character...go on and get 
creative...




* The DRILL *

put bazooka.zip into your quake directory....
uzip it using the -d parameter...
ie. pkunzip bazooka.zip -d

then,

quake -game babe +map yourlevel


* Bugs Found *

if you get a D_CheckCacheGuard: failed prompt and know why...
mail me please 



Author Information
------------------

Bubbah studies Architecture in Delft and was enlightened by the huge
potential of VR. walkthrough the QUAKE engine has. Unfortunately now he's
doin' other things that have absolutely nothin' to do with his studies
and ends up makin' things like Snakemen and Bazooka Babes....
He's right now workin' on some TC's....watch out for them, they'll be good!!!
...heheh... 

Notice
------

Anyone out there likin' my model and wantin' to use it in their TC, 
go ahead... I'd be glad... But mail me... Anyone interested in
workin' with me on anythin', mail me. Anyone with a good idea for
a new monster, mail me...Anyone with a good model, mail me...


Copyright and Distribution Permissions
--------------------------------------

Authors are encouraged to include these modifications in their
freely-distributable levels, as long as this description file
remains intact and unmodified and is included in the distribution.

Authors may not include these modifications in commercial products
without prior written permission of BUBBAH aka. Tan Sian Yue.

CHEERS
BUBBAH

P.S. you check out my snakeman patch and snakepit and Gyro Gearloose's 
     excellent level yet?
     go get them from my website:  http://www.worldaccess.nl/~yue/mdl.htm
     ...You make levels too eh? Go check it out for the latest monster 
     models...heh...and monster levels... 

--------------------------------------------------------------------
Additional note on combining the Bazooka Babe with other monsters:

When a player dies, a message like "Gyro was scragged by a Scrag"
is printed.  This is the client obituary, which is printed from
clients.qc (not bazooka.qc).

If you will be creating your own PROGS.DAT, you will want to modify
your own client.qc file so that obituaries are still printed when the
player is killed by the Bazooka Babe.  In client.qc, toward the bottom
of the file is the routine ClientObituary.  In that routine you will find
some code that looks like this:

	if (attacker.flags & FL_MONSTER)
	{
		if (attacker.classname == "monster_army")
			bprint (" was shot by a Grunt\n");

Add an appropriate Bazooka Babe obituary like this:

	if (attacker.flags & FL_MONSTER)
	{
		if (attacker.classname == "monster_bazooka")
			bprint (" was dumped by a Babe\n");
		if (attacker.classname == "monster_army")
			bprint (" was shot by a Grunt\n");

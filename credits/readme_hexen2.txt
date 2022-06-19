Hexen II: Hammer of Thyrion 1.5.9 (May 31, 2018) :


Installation Instructions for Windows (64 bit):
-----------------------------------------------

Install Hexen II from your cdrom, first. Apply the official 1.11 patch
of Raven software (you need a file named "ph2v111.exe", see gamers.org
mirros: http://www.gamers.org/pub/idgames2/hexen2/official/patch/ )
Alternatively, you can run the small h2patch program included here:
open a DOS window, i.e. a command prompt, and type h2patch.

If you want the mission pack and/or hexenworld, install them, too.

NOTE: The Hexen II cdrom installer puts a file named opengl32.dll
into the installation folder: This is a 3dfx-specific opengl mini
driver for old Voodoo cards only and you want to delete this file
unless you are using one of those very old cards. If you get an error
message like "glide2x.dll not found", then this is the reason!

Now, download these Hammer of Thyrion zip files:

hexen2-1.5.9-win64.zip :	Main game package containing the
				up-to-date exe files and game data

hexenworld-1.5.9-win64.zip :	Up-to-date hexenworld exe files
				and game data

Now unzip the Hammer of Thyrion packages into your installation
folder. You must allow overwriting the existing files. They contain
all of the updated program files and gamedata. You no longer need
the h2mp and glh2mp exe files: they are obsoleted, you can delete
them. Run the game as you normally would.

To play the mission pack, run the game with a "-portals" commandline
switch (without the quotes, of course). For example:

    h2.exe -portals
or
    glh2.exe -portals

If you want to automate this, change the mission pack game entries in
your windows start menu, by using the "properties" right-click option
on them: Change all "glh2mp.exe" into "glh2.exe -portals" and all of
"h2mp.exe" into "h2.exe -portals".

Additionally, we provide windows versions of several stand-alone
hexen II utilities, too:

hexen2-utils-1.5.9-win64.zip	 : Several mapping tools and hc compiler
hexenworld-utils-1.5.9-win64.zip : A master server, and remote server
				   administration tools for hexenworld


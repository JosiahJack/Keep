============================
Nehahra QuakeC code
============================
Released:  February 28, 2002
============================


More than a year after the release of Nehahra, I am releasing the "QuakeC"
source code to Nehahra.  I have placed QuakeC in quotes because it is not
what you would call true QuakeC, but a Pascal-Hybrid.  The compiler/decompiler
was created by Armin Rigo, a set of utilities called ACCQC.

I have included in this archive REACC.EXE, which will compile a progs.dat
from the .QC files.  The error messages are in French.  Sorry. :)

The included DEACC.EXE will decompile a progs.dat into the format
recognizable by REACC.EXE; however, DEACC is picky and won't decompile large
progs.dat files (such as a Nehahra progs.dat).  It will, however, decompile
the normal Quake progs.dat file.

Because the compiler doesn't support comments, there are no included comments
with this source.  (nor do I usually make comments).  I am releasing this only
so you can get a look at it.  Those of you who are QuakeC coders should be
able to follow it.

I am not quite proud of all of the routines here.  Some of the code, I myself
don't understand (probably because I never made comments, go figure).  I have
found better, cleaner ways to do almost everything in Nehahra...some things
are downright hacky...but this is a good piece of nostalgia.

Yes, you can create your own Nehahra progs.dat files with changes you make.
Once you create a new progs.dat, you need only create a new directory off
the Nehahra directory and run nehahra with the -game parameter for your
new directory.  Nehahra automatically looks in the /nehahra dir for
models and such.


((Say those of you who are looking to make a
stripped version of Nehahra that'll run on software... I'm not gonna do this,
but if you do it...I can't stop you :>  Though you'd need to kill a number of
builtins and where they're called...))

Those of you who tried QuakeC and couldn't quite get the hang of it...
maybe I've handed you an alternative you can deal with.  I learned this
language through trial and error.... :)  Side Note:  My next game, Obscurus,
will be coded in the same language.

I don't know what this'll be worth to anyone...other than a peek inside
Nehahra...(or a chance to make your own alternate version) but Enjoy!



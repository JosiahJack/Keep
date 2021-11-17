Title    : Willy the Spider
Filename : spider.zip
Version  : 0.7
Date     : Oct. 9, 1996
Author   : The Birthing Chamber -- Ken Turner
Email    : kturner@mail.dialnet.net
Credits  : id software for a kick-ass game


Type of Mod
-----------
Quake C  : yes
Sound    : no
MDL      : yes


Format of QuakeC
-----------------------------------
unified diff  : no
context diff  : no
.qc files     : yes
progs.dat     : no


Description of the Modification
-------------------------------

Willy the Spider is a completely new .mdl and the .qc code
needed to drive him.  He is intended to be used in all your
new single-player levels.

Note that this distribution is not intended as a stand-alone
modification.  At least some knowledge of Quake editing is
required.

How to Install the Modification
-------------------------------

Unzip "spider.zip" into your quake directory, taking care to
retain the directory structure.

To include Willy in your new levels, simply place an entity
with a classname of "monster_spider" into your map.  Note that
the spider is fairly large and needs about the same amount of
space as the shalrath.

In addition you must add "spider.qc" to your "progs.src" file
and re-compile.  All required code is contained within "spider.qc"
so it should mesh seamlessly with your own mods.

Finally, please notify me if possible so that I may check out
your level!

For testing purposes I have included an edited version of 
"e1m1.map" with the dogs replaced with spiders.  To use this,
extract "maps/e1m1.bsp" from "quake/id1/pak0.pak" into
"quake/id/spider/maps" and run QBSP as follows:

qbsp -onlyents e1m1.map

then run "quake -game spider" and proceed to map e1m1.

Technical Details
-----------------

Willy the Spider was created from scratch using Lightwave3d,
Fractal Design Painter, and several custom utilities.


Author Information
------------------

Ken Turner is an arachnophobic living in beautiful Springfield, MO.
He is married with 2 cats.

Copyright and Distribution Permissions
--------------------------------------

Authors are encouraged to include these modifications in their
freely-distributable levels, as long as this description file
remains intact and unmodified and is included in the distribution.

Authors may not include these modifications in commercial products
without prior written permission of Ken Turner and The Birthing
Chamber.


Availability
------------

This modification is available from the following places:

WWW   : http://www.dialnet.net/users/kturner

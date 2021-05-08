Title    : FrikQCC
Filename : winfrik26.zip
Version  : 2.6
Date     : ?-?-2002
Author   : Ryan "Frika C" Smith
Email    : frikac@telefragged.com
Credits  : JP Grossman for qccx 1.0
           Lee Smith for proqcc 1.60
           Both for releasing their source under GPL
           Riot for help in porting to Macintosh
           LordHavoc for just about everything else
          
Description 
-----------

Features
========
* Compiler Warnings
* Labels and Goto
* Break and Continue
* New Operators
* Conditional Expressions
* Type Casting Made "Simple"
* Integer Type
* Arrays Made "Simple"
* Initialized Variables
* Save Game Features
* "Precompiler"
* Command Line Parameters
* C-Like Function Format
* Optimizations
* Misc features


Compiler Warnings
-----------------
Compiler warnings is a pretty novel feature I haven't seen in any other 
QuakeC compiler to date. For the unitiated - warnings are like errors,  only
they aren't "fatal". Meaning, hitting a warning will not cause the compiler
to abort. Warnings, as the name implies, warn you about potentially error
causing situations, or lines of code that could be changed for better
performance.

Most warnings the compiler supports are based on relatively common warnings
in MSVC++. Like most compilers, frikqcc supports 4 warning levels, and an
option to turn warnings off. Lower numbered levels produce fewer warnings,
while warning level 4 will nitpick your code to death. You can specify
the warning level with the command line parameter -warn x, where x
ranges from 0 to 4. At 0, no warnings will be displayed.

At warning level 3 and above, you may see the message "Unreferenced local
variable somevector_x", in this situation the compiler means the vector
"somevector" is not referenced at all within the function. Due to my extreme
laziness, I just let it use the default def name :).

[There aren't any level 4 warnings yet, btw]

Labels and Goto
---------------
In my effort to give you a little more control over program flow, I added
labels and the goto command from C. Unlike C, however, labels are not defined
by a name followed by a colon, but rather a colon then a name. This was done
to make spotting labels a little easier.

Example:

void() main =
{
	if (i == 1)
		goto main_end;
	
	// do some code

	:main_end
	// code to finish up
};


Note that goto need not be restricted to the same function or even the same
.qc file. You can, I believe, jump from anywhere to anywhere in the QC with
this command.


Break and Continue
------------------
These work identically to their C counterparts. break; aborts out of the
current loop, and continue; sends the loop for another pass.

Also remember that qccx supports for loops, you can use break and continue
there aswell.

New Operators
-------------
Frikqcc 2.5+ support some new operators at popular request they are:

value++ Post-Increment
value-- Post-Decrement
++value Pre-Decrement
--value Pre-Decrement

Operation and store operators:

+=, *=, /=, |=, &=, -=

EDIT: These actually don't work. Don't use them.


Conditional Expressions
-----------------------
Frikqcc supports also C-style conditional expressions in the format:

(condition) ? expression1 : expression2

The operation of this is identical to C. If the condition true, expression1
is used, otherwise, expression2 is used. A simple toggle might be:

self.aflag = self.aflag ? 0 : 1;



New Optimizations
-----------------
Used with no command line options, frikqcc will produce approximately
the same progs.dat as the original id qcc (except if any of the above
features are used, in which case qcc could never compile it).

On the other hand you can trim a lot of fat out of the progs.dat and
speed it up in several ways by employing the use of optimizations. Each
optimization can be enabled individually, by specifying it on the command
line or you can use two pre-sets: /O2 will enable all the clasic
optimizations opting for the greatest space savings. /O1 will enable
most of the classic optimizations but will sacrifice space for
greater runtime speed.

Note the names of optimizations use the letter O and not the numeral 0.
Case is sensitive aswell, ie the compiler will ignore /o2.

/Ot - Eliminate temporary variables
---
This is one of JP Grossman's optimizations it flattens store
opcodes into one line. This optimization can cause decompilers to
choke, if they don't recognize the improved generated code.

OP    A, B, temp
STORE temp, C

to

OP    A, B, C


/Oi - Shorten ifs
---
Another of JP Grossman's optimizations. It will change NOT then IFNOT into IF,
NOT then IF inot IFNOT.

NOT   A, temp
IFNOT temp

to

IF    A

/Op - Non-vector parms
---
Saves a few cycles by copying non-vector function parameters with a STOREF
rather than a STOREV. This is a minor effect, since the only real change
takes place in the C code. It doesn't affect decompilability of the mod.

/Oc - Eliminate constant defs/names
---
The names and associated defs of constant variables are not
stored in the progs.dat.  This is a space optimization and does not affect 
speed. This can make the progs.dat harder to decompile. Unless the decompiler
can make up names for the the constants, the decompiler will choke.

/Od - Eliminate duplicate defs
---
If two constant variables have the same value, only one def is used.
Another space optimization. This is merely an extension of something QCC
already did, it reused constant defs for immediates. The extension allows
other constants to re-use constants, and as such doesn't change the
decompilability of the progs.

/Os - Hash lookup in CopyString
---
Using this option avoids duplicate strings in the string table; another space
optimization.

/Ol - Eliminate local names
---
The names of local, static and immediates are stripped from the progs.dat
upon write time. This saves some space, and does not affect the usability of
the compiled code. This also makes it harder to be decompiled.


/On - Eliminate uneeded function names
---
The function names of any function assigned to a built-in are removed from
the progs.dat. Again, a space optimization only. This doesn't affect
decompilation.


/Of - Eliminate source code file names
---
*Another* space optimization, file names of the source files are not stored
in the compiled progs. This will affect decompilation on older decompilers.


/Oo - Add logical jumps
---
This is a speed optimization that adds opcodes to attempt to skip past long
logical calculations in conditionals. Because this adds opcodes it is not
a space optimization. This optimization will confuse decompilers and may
result in "indentation structure corrupt" errors when trying to decompile.

/Oa - Flatten constant arithmetic
---
This optimization will convert, for example:

self.health = 100 + 1;

to essentially:

self.health = 101; 

in the compiled assembly. This is a speed optimization and although it saves
statements it tends to generate more pr_globals for the immediates it 
generates. This does not affect decompilation.

/Or - Recycle temps
---
This optimization will make the compiler use only a few new temps for each
function. After each line, it will allow itself to re-use the temps from
previous lines, saving huge amounts on numpr_globals. This may cause
decompilers to choke.


Misc Features
-------------
* Frikqcc will write an error.log in the source dir of all errors/warnings
  encountered during the compile.
* Frikqcc will wait for any key to be pressed before closing when run with
  no parameters. (Note: the command line parameters -nopause and -pause can
  be used to override this behavior, one way or the other)
  (Also note that Windows doesn't properly support getchar() and will wait
  for a press of the enter key.)
* The semicolon on the end of functions is now optional.
* You can optionally use a more C-stlye function header, for example
  float main (void) as opposed to float(void) main =. The equal sign
  is also optional.
* There's a new type name, int. It's really a float
* The keyword "local" is also now optional. "float x;" inside a function is
  equivalent to the code "local float x;"
* Summaries have been disabled so you can see more of the warnings in the
  cheesy Windows DOS box. I never realized how much that sucked until using
  Linux. You can re-enable the summaries with the -summary option.
* JP Grossman's mysterious ^[ operator has been renamed to ~[ to resolve
  an optable conflict with |=. I doubt anyone even knew ^[ existed
  (it's a vector version of [, for array access) so I doubt this is
  much of a hassle.
* More than 8 parameters are allowed for quakec defined functions. 
* A state keyword is supplied to use OP_STATE inside a function. This
  was done for Nehahra support and I kept it because it was cute.
* Static variable support has been eliminated.
* Numerous bugs in qcc, qccx and fastqcc have been fixed. I won't
  even begin to try and list them all.
* FrikQCC has changed many warnings and errors to be much more descriptive
  It will mention what types were expected in a type mismatch, where
  original declarations are in some redeclared errors, etc.
* Variable declarations can be prefixed with the keyword "var" to make sure
  they are not defined constant, but only assigned an initial value.
  For example: "var float x = 9;"
* Variable declarations can be prefixed with the keyword "const" to make sure
  they ARE defined constant. Doing so will make all other definitions assume
  non constant.
* Variable declarations can be prefixed with the keyword "nosave" to make sure
  they are not saved to a save game file (DEF_SAVEGLOBAL). 
  Ex: "nosave var float r;"
* Frikqcc can predict wether an int or float will be needed, and will convert
  immediates to the appropriate value. Because of this you can use single
  quoted characters as floats now (previously only available as ints). In
  addition, the % for int is now optional.


Copyright and Distribution Permissions
--------------------------------------
qccx is Copyrighted (c) 2000 by JP Grossman
ProQCC is Copyrighted (c) 1997-2000 Lee Smith
FrikQCC specific additions are Copyrighted (c) 2000-2001 by Ryan Smith

Frikqcc is released under the GNU General Public License. Please read 
gnu.txt.  (Taking from JP Grossman's readme) John Carmack summarized the
GPL as follows:

"The code is all licensed under the terms of the GPL (gnu public license).  
You should read the entire license, but the gist of it is that you can do 
anything you want with the code, including sell your new version.  The catch 
is that if you distribute new binary versions, you are required to make the 
entire source code available for free to everyone."

The source code is not included with this archive. You can obtain the source
code from my website.

Availability
------------
This utility is available from the following places:

FrikBot homepage at http://www.inside3d.com/frikbot/

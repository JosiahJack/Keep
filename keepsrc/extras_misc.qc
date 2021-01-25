/*
This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by the
Free Software Foundation; either version 2 of the License, or (at your
option) any later version.

This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software Foundation,
Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
*/

/*
	Written by Frank Condello <pox@planetquake.com>
	
	Misc functions/entities....
	
	func_ladder
	func_explobsp
	func_breakaway
	func_nodraw
	func_bspframe
	func_model
*/

//============================================================================
/*QUAKED func_nodraw (0 .5 .8) ? 1
Like func_wall, but is invisible by default, and has no think/use.

Spawnflags:

"1" Show brush geometry

*/
void() func_nodraw =
{
	self.angles = '0 0 0';
	self.movetype = MOVETYPE_PUSH;
	self.solid = SOLID_BSP;
	
	setmodel (self, self.model);

	if (!(self.spawnflags & 1))
		self.model = string_null;
};

//============================================================================

// Transfer mdl to owner
void() bspframe_init =
{
	local entity	targ;
	
	targ = find (world, targetname, self.target);
	
	if (targ.classname == "func_switch" ||
		targ.classname == "func_explobsp" ||
		targ.classname == "func_breakaway")
		targ.mdl = self.mdl;
	
	remove(self);
};

/*QUAKED func_bspframe (0 .5 .8) ?
A little hack to allow alternate bsp model "frames" for certain ents

"target"	The owner object

NOTE:

When used on solid objects (like func_explobsp) insure these won't stick into nearby
players/monsters
when the parent object switches frames. (i.e. make this object smaller
than the parent, or create
a clip area that encompases both object frames)

*/
void() func_bspframe =
{
	if (!self.target) objerror("func_bspframe without target");
	
	self.angles = '0 0 0';
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.mdl = self.model;

	self.modelindex = 0;
	self.model = "";
	
	self.nextthink = time+0.1;
	self.think = bspframe_init;
};
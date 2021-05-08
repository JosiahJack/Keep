/* Pushable walls QuickC program
   By Jim Dose'  9/16/96
   Copyright (c)1996 Hipnotic Interactive, Inc.
   All rights reserved.
   Do not distribute.
*/

void() push_use =
{
	local vector delta;
	local float x, y, pushang;

	if(!(other.flags & FL_CLIENT))
		return;
	if(other.absmin_z > self.absmax_z)
		return;

//	makevectors(other.angles);
/*
	x = fabs( other.velocity_x );
	y = fabs( other.velocity_y );
	dprint( ftos( x ) );
	dprint( ", " );
	dprint( ftos( y ) );
	if ( x > y )
	{
		dprint( " x move\n\n\n\n" );
		if ( other.velocity_x > 0 )
			walkmove ( 0, 16 * frametime);
		else
			walkmove( 180, 16 * frametime );
	}
	else
	{
		dprint( " y move\n\n\n\n" );
		if ( other.velocity_y > 0 )
			walkmove ( 90, 16 * frametime);
		else
			walkmove( 270, 16 * frametime );
	}
*/
	delta = vectoangles(other.velocity);
	pushang = delta_y;
	walkmove(pushang, 16 * frametime);
//	droptofloor();
	
//	delta = self.origin - self.oldorigin;
//	setorigin (self.owner, self.owner.oldorigin + delta );
	setorigin (self.owner, self.origin + self.pos1);
//	setorigin (self.owner, self.origin);
};

/*QUAKED func_pushable (0 .5 .8) ?
Pushable walls.
*/

void() func_pushable =
{
	local entity new;
	local vector newsize;

	self.mangle = self.angles;
	self.angles = '0 0 0';

	self.classname = "pushablewall";
//	self.solid = SOLID_BSP;
//	self.movetype = MOVETYPE_PUSH;
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_NONE;
	setmodel (self, self.model);
	setorigin( self, self.origin );
	setsize (self, self.mins, self.maxs );
	self.oldorigin = self.origin;

	new = spawn();
	new.owner = self;
	new.mangle = self.mangle;
	new.angles = self.angles;

	new.classname = "pushablewallproxy";
	new.solid = SOLID_BBOX;
	new.movetype = MOVETYPE_STEP;
	new.origin = ( self.mins + self.maxs ) * 0.5 + '0 0 1';
	newsize = ( self.maxs - self.mins ) * 0.5;
	new.mins = '-1 -1 0' - newsize;
	new.maxs = '1 1 -2' + newsize;
//	setorigin( new, self.origin );
//	setsize( new, self.mins, self.maxs );
	setsize( new, new.mins, new.maxs );
	setorigin( new, new.origin );
//	new.oldorigin = new.origin;
 	new.touch = push_use;
	new.pos1 = self.origin - new.origin;
};
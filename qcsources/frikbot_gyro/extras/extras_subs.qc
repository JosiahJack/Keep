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
	
	Modified SUB_CalcMove clone that work with non-push entities,
	and misc reusable functions...
	
*/

//============================================================================

/*
============
SUB_RandomRange

Return a random number between min & max (or min if max is 0)
Just make sure max is greater than min...
============
*/
float(float rmin, float rmax) SUB_RandomRange =
{
	if (!rmax)
		return rmin;
	else
		return rmin + random()*(rmax-rmin);
};

//============================================================================
float lastframe;

/*
============
This is called from PostThink to advance all moving triggers each frame
============
*/
void() SUB_PushFrameMovers =
{
	local entity ent;
	
	// Make sure this only happens once per frame (bots)
	if (lastframe == time) return;	
	lastframe = time;
	
	// Find the first ent
	ent = find(world, fmover, "moving");
	
	while(ent)
	{	
		// Child move
		if (ent.owner)
		{
			// Ignore next frame (done moving)
			if (ent.owner.velocity == '0 0 0') {
				ent.fmover = string_null;
				ent.origin = ent.owner.origin;
				setorigin(ent, ent.origin);
			}
			// Parent is Blocked
			else if ((ent.owner.attack_finished-(0.5-frametime)) > time ) {
				ent.origin = ent.owner.origin;
				setorigin(ent, ent.origin);
			}
			// Lead parent a bit (seems to track better)
			else {
				ent.origin = ent.owner.origin + ent.owner.velocity*frametime;
				setorigin(ent, ent.origin);
			}
		}
		// Independant func_water or func_watertrain
		else if (ent.velocity == '0 0 0') {
			ent.fmover = string_null;// Ignore next frame (done moving)
		}
		// Add move for this frame
		else {
			ent.origin = ent.origin + ent.velocity*frametime;
			setorigin(ent, ent.origin);
		}
		
		// Get the mext one
		ent = find(ent, fmover, "moving");
	}	
};

//============================================================================

void() SUB_fCalcMoveDone =
{
	self.fmover = string_null;
	setorigin(self, self.finaldest);
	self.velocity = '0 0 0';
	self.nextthink = -1;
	if (self.think1) self.think1();
};

/*
=============
SUB_fCalcMove

Just like SUB_CalcMove, sets up fmover for next frame
==============
*/
void(vector tdest, float tspeed, void() func) SUB_fCalcMove =
{
	local vector	vdestdelta;
	local float		len, traveltime;

	if (!tspeed) objerror("No speed is defined!");
	
	self.think1 = func;
	self.finaldest = tdest;
	self.think = SUB_fCalcMoveDone;
	
	if (tdest == self.origin) {
		self.velocity = '0 0 0';
		self.nextthink = time + 0.1;
		return;
	}
	
	vdestdelta = tdest - self.origin;
	len = vlen(vdestdelta);
	traveltime = len / tspeed;
	
	if (traveltime < 0.1) {
		self.velocity = '0 0 0';
		self.nextthink = time + 0.1;
		return;
	}
	
	self.fmover = "moving";
	self.nextthink = time + traveltime;
	self.velocity = vdestdelta * (1/traveltime);
};

//============================================================================

/*
	The following are routines from Scourge of Armagon,
	required by rotating brush entities (see hipnotic/hiprot.qc)
*/

void(entity ent, float amount) hurt_setdamage =
{
	ent.dmg = amount;
	if (!amount)
		ent.solid = SOLID_NOT;
	else
	  ent.solid = SOLID_TRIGGER;
	  
	ent.nextthink = -1;
};

vector(vector ang) SUB_NormalizeAngles =
{
	while(ang_x > 360)
	  ang_x = ang_x - 360;

	while(ang_x < 0)
	  ang_x = ang_x + 360;
	
	while(ang_y > 360)
	  ang_y = ang_y - 360;
	  
	while(ang_y < 0)
	  ang_y = ang_y + 360;
	
	while(ang_z > 360)
	  ang_z = ang_z - 360;

	while(ang_z < 0)
	  ang_z = ang_z + 360;
	
	return ang;
};

//============================================================================

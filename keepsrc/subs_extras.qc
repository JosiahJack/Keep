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

// pOx - START - disslve bubbles quicker for players
void() bubble_bob2 =
{
local float		rnd1, rnd2;

	self.cnt = self.cnt + 1;
	if (self.cnt == 2)
		self.frame = 1;
	if (self.cnt == 6)
		remove(self);

	rnd1 = self.velocity_x + (-10 + (random() * 20));
	rnd2 = self.velocity_y + (-10 + (random() * 20));

	if (rnd1 > 10)
		rnd1 = 5;
	if (rnd1 < -10)
		rnd1 = -5;
		
	if (rnd2 > 10)
		rnd2 = 5;
	if (rnd2 < -10)
		rnd2 = -5;
	
	self.velocity_x = rnd1;
	self.velocity_y = rnd2;
		
	self.nextthink = time + 0.2;
	self.think = bubble_bob2;
};
// pOx - END - disslve bubbles quicker for players

void() DeathBubblesSpawnOnEntity =
{
	local entity	bubble;
	local vector	tmp_vec_up;
	local float		tmp_forward;
	if (self.owner.waterlevel != 3 && !self.owner.infuncwater)
	{
		dprint("Not in water\n");
		return;
	}
	
	bubble = spawn();
	setmodel (bubble, "progs/s_bubble.spr");
	
	tmp_vec_up = self.owner.maxs * 0.5;
	tmp_vec_up_x = tmp_vec_up_y = 0;
	tmp_vec_up = self.owner.origin + tmp_vec_up;
	
	tmp_forward = self.owner.maxs_x * 0.5;
	
	makevectors(self.owner.angles);
	setorigin (bubble, tmp_vec_up + v_forward * tmp_forward);// pOx - moved this infront a bit
	bubble.movetype = MOVETYPE_NOCLIP;
	bubble.solid = SOLID_NOT;
	bubble.velocity = '0 0 15';
	bubble.nextthink = time + 0.25;
	bubble.think = bubble_bob2;//bubble_bob; // pOx - disslve bubbles quicker for players
	bubble.classname = "bubble";
	bubble.classtype = CT_BUBBLE;
	bubble.frame = 0;
	bubble.cnt = 0;
	setsize (bubble, '-8 -8 -8', '8 8 8');
	self.nextthink = time + 0.15;
	self.think = DeathBubblesSpawnOnEntity;
	self.air_finished = self.air_finished + 1;
	if (self.air_finished >= self.bubble_count)
		remove(self);
};

void(entity ent, float num_bubbles) DeathBubblesOnEntity =
{
	local entity	bubble_spawner;
	
	bubble_spawner = spawn();
	setorigin (bubble_spawner, ent.origin);
	bubble_spawner.movetype = MOVETYPE_NONE;
	bubble_spawner.solid = SOLID_NOT;
	bubble_spawner.nextthink = time + 0.2;
	bubble_spawner.think = DeathBubblesSpawnOnEntity;
	bubble_spawner.air_finished = 0;
	bubble_spawner.owner = ent;
	bubble_spawner.bubble_count = num_bubbles;
	return;
};
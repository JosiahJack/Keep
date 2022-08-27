//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/ 
//
// Compiled by Qmaster
//
// Attributions: Arms of Asgard (AoA) by ryanscissorhands
//
//
// Distribution / Copyright / Permissions 
//
// Please do not use any of these assets in ANY COMMERCIAL PROJECT.
// and remember to give credit if you use any of these assets. Please credit
// the appropriate authors of the various content used.  Refer to the credits
// folder.
//				  
// The QC files in this MOD are based on 1.06 source files by ID Software.
// These files are released under the terms of GNU General Public License v2 or
// later. You may use the source files as a base to build your own MODs as long
// as you release them under the same license and make the source available.
// Please also give proper credit. Check http://www.gnu.org for details.
//
// Quake is a registered trademark of id Software, Inc.
//
// All of these resources may be electronically distributed only at 
// NO CHARGE to the recipient.
//
// Stats:
// Entity count: 0
// Function count: 18
//
// Implements: Arms of Asgard weapons' subroutine functions
//
// Description:
// Simple utility functions for AoA weapons and their effects.
//=============================================================================

void(string a, string b, string c, string d) aoaprint = {
	bprint(a);
	bprint(b);
	bprint(c);
	bprint(d);
	bprint("\n");
};

void(string playerModel) setPlayerModel = { //sets the player model to the string value, and sets appropriate mins/maxs
	setmodel(self, playerModel);
	setsize (self, '-16 -16 -24', '16 16 32');
	setorigin(self, self.origin);
	self.view_ofs = '0 0 22';
};

//healing utility called by health-draining melee weapons like the Mace
void(entity target, float hlth, float maxHealth) TriggerHeal = {
	
	if (target.health > maxHealth)
		return;
	else if (target.health + hlth < maxHealth)
		target.health = target.health + hlth;
	else
		target.health = maxHealth;
	sound(target,CHAN_AUTO,"aoa/heal.wav", 0.6,ATTN_NORM);
};

/*
=====================================================================
Mirror Player Model (for testing player animations)	#mirror
=====================================================================
*/
void() mirrorPlayerModel = {
	if (time > self.attack_finished)
	{
		remove(self);
		return;
	}	
	setmodel(self, self.owner.model);
	self.skin = self.owner.skin;
	self.frame = self.owner.frame;
	// self.angles = self.owner.angles; this makes is difficult to see the front of the mirror
	self.nextthink = time + 0.1;
	self.think = mirrorPlayerModel;

};

void() spawnPlayerModel = {
	local entity playerModel;
	
	playerModel = spawn();
	playerModel.owner = self;
	playerModel.skin = self.skin;
	playerModel.frame = self.frame;
	playerModel.attack_finished = time + 60;
	setmodel(playerModel, self.model);
	setsize (playerModel, '0 0 0', '0 0 0');
	setorigin(playerModel, self.origin);
	playerModel.nextthink = time + 0.1;
	playerModel.think = mirrorPlayerModel;
};
//===========================END OF MIRROR PLAYER MODEL====================================


void(float frames) LoopFrames = {
	if (self.frame >= frames)
		self.frame = 0;
	else
		self.frame = self.frame + 1;
};

/*
=====================================================================
Beam - for emulating lightning gun effect	#beam #ryanscissorhands
=====================================================================
*/

void() randomTwist = {
	if (time > self.attack_finished)
	{
		remove(self);
		return;
	}
	
	/*local float spin;
	
	spin = random()*2000 + 1500;
	if (random() > 0.5)
		spin = spin * (-1);
	
	self.avelocity_z = spin;
	self.angles_z = random()*360;
	*/
	
	self.angles_z = random()*720;
	
	self.nextthink = time + 0.001;
	self.think = randomTwist;
};

void(vector org, vector dir, string model, float duration) SpawnBeamSegment = {
	local entity segment;
	
	makevectors(self.v_angle);
	segment = spawn();
	segment.owner = self;
	segment.angles = vectoangles(v_forward);
	segment.movetype = MOVETYPE_FLY;
	segment.solid = SOLID_NOT;
	
	setmodel(segment, model);
	setsize(segment, '0 0 0', '0 0 0');
	setorigin(segment, org);
	segment.attack_finished = time + duration;
	segment.nextthink = time + 0.03;
	segment.think = randomTwist;
};

void(vector org, vector dest, string model, float duration) MakeBeam = {
	local float span;
	local vector nextSegment;
	span = vlen(dest-org);
	nextSegment = org;
	while (span > 32)
	{
		makevectors(dest - org);
		SpawnBeamSegment(nextSegment, v_forward, model, duration);
		nextSegment = nextSegment + v_forward*32;
		span = span - 32;
	}
};

//========================END OF BEAM===================================================================================================================================================================

/*
======================================================================================================
Vector Utilities
======================================================================================================
*/
void(vector org) TestThisVector = //this function is designed to test locations by spawning a floating projectile at the given vector
{
	local	entity	test;
	test = spawn();
	setmodel(test, "progs/aoa/test.mdl");		
	setorigin(test, org);
	test.nextthink = time + 4;
	test.think = SUB_Remove;
};


//Line of Sight methods
float(entity targ, entity inflictor) HasLOS = {
	
	traceline(inflictor.origin, targ.origin, TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
	else
		return FALSE;
};

float(vector point1, vector point2) InLOS = {
	
	traceline(point1, point2, TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
	else
		return FALSE;
};

vector ignoreVertical(vector bearing) = //returns a normalized vector with no vertical component
{
	local vector upless;
	upless = bearing;
	upless_z = 0; // this removes the vertical or 'z' component
	upless = normalize(upless);
	return upless;
};

void(string model, vector org) TestModel = {
	local entity ModelPreview;
	
	ModelPreview = spawn();
	ModelPreview.owner = self;
	ModelPreview.nextthink = time + 10;
	ModelPreview.think = SUB_Remove;
	ModelPreview.movetype = MOVETYPE_TOSS;
	
	setmodel(ModelPreview, model);
	setsize( ModelPreview, '0 0 0', '0 0 0');
	setorigin(ModelPreview, org);
};

/*
===================================================================
Randomization Functions - ryanscissorhands
===================================================================
*/

float rnd (float min, float max) = //returns a random value between min and max
{
	local float result;
	result = min + random()*(max - min);
	return result;
};

vector spread(vector variance) = //returns a randomized vector within +/-  the input vector’s bounds
{
	local float x, y, z;
	local vector result;

	x = fabs(variance_x);
	y = fabs(variance_y);
	z = fabs(variance_z);

	result_x = rnd(-x, x);
	result_y = rnd(-y, y);
	result_z = rnd(-z, z);

	return result;
};

float(entity target) CountFlakAmmo = {
	local float nails, rockets;
	
	nails = target.ammo_nails /8;
	rockets = target.ammo_rockets/2;
	if (nails > rockets)
		return rockets;
	else
		return nails;
};
//======END OF RANDOMIZATION FUNCTIONS==================================
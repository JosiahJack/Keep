
// bdw - 02/04/03 - some of my new sprite stuff here...

/*
=========================================
BDW_TracerEffect

this approximates a tracer effect for missiles and such. the only way to produce a particle effect in quakec
is to call the particle() function, which is quite limited; particle origins are randomised (in the game, this appears
to be roughly 16 units in each direction) so there is a limit as to how accurately you can specify a particles origin. 
also, colour is slightly randomised, but this generally works in your favour. called each frame, what this function does 
is work out how far the missile has travelled since it last spawned particles, it then spawns a certain number every 
16 units to fill the gap.

==========================================
*/


void() BDW_TracerEffect =
{	
	local vector dir, porg, pvel;
	local float len, pcol;

	dir = self.origin - self.oldorigin;
	len = vlen(dir);

self.think = BDW_TracerEffect;
self.nextthink = 1;	//next frame

	if (len < 16)
		return;	//not enough distance travelled to spawn particle, so keep oldorigin and return


	if (self.color == 0)
		pcol = 232;	//lava red
	else
		pcol = self.color;

	pvel = '0 0 0';	//test

	dir = normalize(dir);

	while (len > 0)
	{
		porg = self.oldorigin + dir*len;
		particle(porg, pvel, pcol, 4);

		len = len - 16;
	}

	self.oldorigin = self.origin;
};



	

	


/*
======================================================
BDW_SpriteGenericLoop

Loops a sprite animation

self.idleweaponframe represents the total number 
of frames in the animation. Frames are numbered 
starting from 0, so the last frame in the animation 
is actually (self.idleweaponframe - 1). Useful for
missiles.

BDW_SpriteGenericPlayOnce

Similar to the above, but removes sprite at end of
animation. Useful for explosions.
======================================================
*/

void() BDW_SpriteGenericLoop =
{
	self.frame = self.frame + 1;
	if (self.frame > (self.idleweaponframe - 1))
		self.frame = 0;

	self.think = BDW_SpriteGenericLoop;
	self.nextthink = time + 0.05;
};

void() BDW_SpriteGenericPlayOnce =
{
	self.frame = self.frame + 1;
	if (self.frame > (self.idleweaponframe - 1))
	{
		BDW_DelayedRemove();	// hack!
		return;
	}
		
	self.think = BDW_SpriteGenericPlayOnce;
	self.nextthink = time + 0.05;
};

/*
void(vector org, string sprname, float numframes) BDW_SpawnMuzzleFlash =
{
	local entity flash;
	local vector o;
	local float f;

	flash = spawn();

	makevectors(self.v_angle);

	o = self.origin + self.view_ofs + v_forward*org_x + v_right*org_y + v_up*org_z;	

	setmodel(flash, sprname);
	setsize(flash, '0 0 0', '0 0 0');
	setorigin(flash, o);

	// randomise the starting frame...
	//f = random()*numframes;		
	//f = ceil(f);
	//f = f - 1;
	//flash.frame = f;	

	flash.frame = 2;
	flash.scale = 0.5;

	flash.think = SUB_Remove;
	flash.nextthink = time + 0.01;
};
*/


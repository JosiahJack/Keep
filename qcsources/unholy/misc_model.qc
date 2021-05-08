/*
 * misc_model.qc requires math.qc
 *
 * Author: Joshua Skelton joshua.skelton@gmail.com
 * Edited by: Inky 20201219 Minor changes for a better integration with my own code
 */

// Forward declarations
void() misc_model_think;

/*QUAKED misc_model (0 0.5 0.8) (-8 -8 -8) (8 8 8) X X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
{
	model ({"path" : mdl, "skin" : skin, "frame": frame});
}
An entity for displaying models. A frame range can be given to animate the
model.

model:   The model to display. Can be of type mdl, bsp, or spr.
frame:   The frame to display (static models).
button0: Can be used to offset the animation.
button1: The starting frame of the animation.
button2: The last frame of the animation.
frags:   How long the animation frames last; default 0.05
*/
void() misc_model = {
    
	self.solid = SOLID_NOT;

	if(!self.model) return;
	
	precache_model(self.model);
    setmodel(self, self.model);
	
    if (!self.frame) self.frame = self.button1;

    self.think = misc_model_think;
	
	// Only animate if given a frame range
    if (!self.button2)
	{
		self.nextthink = -1;
		return;
	}

    if (self.button0) self.frame = self.button0;

    if (!self.frags) self.frags = 0.05; // Default animation speed

    self.nextthink = time + self.frags;
    
};

/*
 * misc_model_think
 *
 * Handles animation for misc_model entity.
 */
void() misc_model_think = {
    self.nextthink = time + fabs(self.frags);
    self.frame = self.frame + sign(self.frags);
	
	if (self.spawnflags & /*Anim back & forth*/2 && self.frame < self.button1)
	{
		self.frags = -1 * self.frags;
		self.frame+=2;
	}
	else if (self.spawnflags & /*Anim back & forth*/2 && self.frame > self.button2)
	{
		self.frags = -1 * self.frags;
		self.frame-=2;
	}
	else
		self.frame = wrap(self.frame, self.button1, self.button2);
		
	if(self.spawnflags & /*Only once*/1 && self.frame==self.button2 && self.button2!=self.button1) self.nextthink = -1;
};

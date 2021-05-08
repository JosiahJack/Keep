
//************************************************************
// Kicking Gibs n Dead Heads (based on code by Ivana Gibson)
// But edit heavily beyond recognition
//************************************************************

//////Gib bounce noise (GLITCHY)
var float autocvar_gibs_bounce_sound = 1;			//determines whether or not gibs make a squish noise on bounce


void () head_gib_faceplayer =		// requested be several at quakeone.com
{

	self.ideal_yaw = self.angles * '0 1 0';		// necessary for gibbable corpse feature
	if (!self.yaw_speed)
		self.yaw_speed = 20;
	self.view_ofs = '0 0 25';
	
	ai_face();
	self.nextthink = time + 0.05;
	self.think = head_gib_faceplayer;
};



void() gib_gravity_reset =	  // to reset the gravity (after gib was kicked) to "1" for GYRO 
{
    if (random()< 0.5) 
		self.gravity = 0.9; 
    else
		self.gravity = 1.1; 

var float autocvar_gibsduration = 10;    		 // set cvar 'gibsduration' default to 10 == original ID1 behaviour
	if (autocvar_gibsduration == 0)		 // if 'gibsduration' is set via autoexec.cfg to '0'
		return;					 // --> gibs will NEVER disappear !!!

precache_sound ("player/gibexplode.wav");  	
self.think = gibsfade_blood;				// without these 4 lines, the three gib models would never
self.ltime = time;					// disappear after they have been kicked.
self.nextthink = time + autocvar_gibsduration + random()*10;	
};


void() gib_gravity_reset2 =	  // to reset the gravity (after head-gib was kicked) to "1" for GYRO 
{
    if (random()< 0.5) 
		self.gravity = 0.9; 
    else
		self.gravity = 1.1; 
    
    if (autocvar_head_gibs_always_face_player)
    {
	    self.nextthink = time;
	    self.think = head_gib_faceplayer;
    }
};


void() gib_gravity_reset3 =	  // to reset the gravity (after debris was kicked) to "1" for GYRO 
{
    if (random()< 0.5) 
		self.gravity = 0.9; 
    else
		self.gravity = 1.1; 
};



void() kick_touch;
void() kick_touch2;
void() kick_touch3;
void() kick_touch4;


void() kick_touch =  			// for gibs (except head-gib)
{
	if (self.velocity > '0 0 0' && pointcontents(self.origin) == CONTENT_EMPTY)
		sound7(other, CHAN_ITEM, "gib/gibhit1.wav", 1, ATTN_NORM, SNDSPD);
};




void() kick_touch2 = 			// for head gibs
{
	local vector v;

if (!(deathmatch || coop))
{
   	if (pointcontents(self.origin) == CONTENT_LAVA)				// checks for lava
   		{
      		self.traileffectnum = particleeffectnum("gibburn");		//  adds particle effect to gibs when in lava (customize the effect in your effectinfo.txt)
	//	self.skin = 1;								// use a different "burnt" skin "1" if you have/want.
		self.colormod = '0.4 0.1 0.1';					// change the color of the gib to  burned  dark red
      		}
   	if (pointcontents(self.origin) == CONTENT_SLIME)			// checks for slime
   		{
      		self.traileffectnum = particleeffectnum("gibacid");		//  adds particle effect to gibs when in slime (customize the effect in your effectinfo.txt)
	//	self.skin = 2;								// use a different "acidly" skin "2" if you have/want.
		self.colormod = '0.3 1.6 0.3';					// change the color of the gib to  slimy/etchy  green
      		}
   	if ((pointcontents(self.origin) != CONTENT_SLIME) && (pointcontents(self.origin) != CONTENT_LAVA))	// needed to STOP the particle effect when gib is kicked/shot out of slime or lava !!
   		{
      		self.traileffectnum = particleeffectnum("gibnull");		//  REMOVES the particle effect from gibs (it is a null effect in your effectinfo.txt)
      		}

var float autocvar_gibflies = 1;     	// set cvar 'gibflies' default to 1
	if (autocvar_gibflies == 1)		// if 'gibflies' is '1' 
		{
   		if ((pointcontents(self.origin) != CONTENT_SLIME) && (pointcontents(self.origin) != CONTENT_LAVA) && (pointcontents(self.origin) != CONTENT_WATER))	// check if gib is out of slime or lava or water
	      	self.traileffectnum = particleeffectnum("gibfliesblack");		//  adds BLACK flies to gibs (customize the effect in your effectinfo.txt)
		}
	if (autocvar_gibflies == 2)		// if 'gibflies' is '2' 
		{
   		if ((pointcontents(self.origin) != CONTENT_SLIME) && (pointcontents(self.origin) != CONTENT_LAVA) && (pointcontents(self.origin) != CONTENT_WATER))	// check if gib is out of slime or lava or water
	      	self.traileffectnum = particleeffectnum("gibfliesbrown");		//  adds BROWN flies to gibs (customize the effect in your effectinfo.txt)
		}
}

	// only a player can kick it
	if (other.classname != "player")
		return;

	//randomize sound
	if (random()< 0.7)
		sound(other, CHAN_ITEM, "kickgib/gib_hit.wav", 1, ATTN_NORM);
	else
		sound(other, CHAN_ITEM, "kickgib/gib_miss.wav", 1, ATTN_NORM);

	//define velocity 
	//you can play with these formulas to adjust trajectory
	if (random()< 0.5)    // randomized gib velocity, so they don't cluster ontop of one another.
	v_x = (other.velocity_x*1.4);
	else
	v_x = (other.velocity_x*1.5);
	
	if (random()< 0.5)     // randomized gib velocity, so they don't cluster ontop of one another.
	v_y = (other.velocity_y*1.4);
	else
	v_y = (other.velocity_y*1.5);
	
	if (v_x & v_y == 0)  // avoids infinite gib jumping on players head
		v_z = -220;
	else
		v_z = 250;

local float zufall;
    zufall = random();
    if (zufall > 0.66)   		// randomized gib weight, so they don't cluster ontop of one another.
		self.gravity = 1.6;    	// makes the gibs heavier. So they dont bounce like pingpong balls anymore
    else if (zufall < 0.34)  		// randomized gib weight, so they don't cluster ontop of one another.
		self.gravity = 1.7; 	// makes the gibs heavier. So they dont bounce like pingpong balls anymore
    else
		self.gravity = 1.5;	// makes the gibs heavier. So they dont bounce like pingpong balls anymore

	
	self.flags = self.flags - ( self.flags & FL_ONGROUND );
    	self.velocity = v;

	if (v_x & v_y & v_z == 0)  // avoids gib spinning when player stands inside gib (which is possible due to above "infinite head jumping" workaround)
		self.avelocity = '0 0 0'; 
	else
		self.avelocity = '0 300 0';   // spins the gib, so that it looks more realistic; but only around its yaw.
						// Otherwise the headmdl would sink into the floor.
	self.cansplash = 1;

	self.think = gib_gravity_reset2;	// to reset the gravity to 1 for GYRO !!! 
	self.nextthink = time + 1.1;
};

void() kick_touch2_temp = 		// for new zombie_model head gib
{
	self.origin = self.origin + '0 0 7';
	droptofloor();
	setsize (self, '-8 -8 0', '8 8 24');
	self.touch = kick_touch2; 
	self.think = kick_touch2;
	self.nextthink = time + 0.5;	// wait a bit so that gib doesnt hang in walls
};



void() kick_touch3 = 			// for all gibs (when cvar kickgibs is set to "0")
{
	/*if (other.classname == "buzzsaw")
	{
		self.solid = SOLID_NOT;
		return;
	}
	self.solid = SOLID_TRIGGER;*/
	//self.solid = SOLID_TRIGGER;
	if (time - self.delay < 0.2)
		return;
	
	if (self.velocity <= 50)
	{
		if (self.angles_z >= 80 || self.angles_z <= -80)
			self.angles_z = 0;
		if (self.angles_x >= 80 || self.angles_x <= -80)
			self.angles_x = 0;
	}
	if (self.flags & FL_ONGROUND)
		self.angles_x = 0;
		
	
	if (other.classname == "player" || other.classname == "gib" || other.flags & FL_MONSTER)
		return;
	else if (pointcontents(self.origin) == CONTENT_EMPTY && self.velocity <= 20 && other == world && self.classname != "player")
	{
		te_blood (self.origin,'0 80 1000', 7);
		//sendParticle("gib_impact", self.origin, '0 0 0', 1);

		if (random() < 0.4)
			sound7 (self, CHAN_BODY, "gib/gibhit1.wav", 1, ATTN_NORM, SNDSPD);
		else if (random() < 0.7)
			sound7 (self, CHAN_BODY, "gib/gibhit2.wav", 1, ATTN_NORM, SNDSPD);
		else if (random() < 0.99)
			sound7 (self, CHAN_BODY, "gib/gibhit3.wav", 1, ATTN_NORM, SNDSPD);
		else 
			sound7 (self, CHAN_BODY, "gib/gibhit4.wav", 1, ATTN_NORM, SNDSPD);
	}
	
	
if (!(deathmatch || coop))
{
   	if (pointcontents(self.origin) == CONTENT_LAVA)				// checks for lava
   		{
      		self.traileffectnum = particleeffectnum("gibburn");		//  adds particle effect to gibs when in lava (customize the effect in your effectinfo.txt)
	//	self.skin = 1;								// use a different "burnt" skin "1" if you have/want.
		self.colormod = '0.4 0.1 0.1';					// change the color of the gib to  burned  dark red
      		}
   	if (pointcontents(self.origin) == CONTENT_SLIME)			// checks for slime
   		{
      		self.traileffectnum = particleeffectnum("gibacid");		//  adds particle effect to gibs when in slime (customize the effect in your effectinfo.txt)
	//	self.skin = 2;								// use a different "acidly" skin "2" if you have/want.
		self.colormod = '0.9 1.4 0.4';						// change the color of the gib to  slimy/etchy  green
      		}
      	if (pointcontents(self.origin) == CONTENT_WATER)			// checks for slime
   		{
      		self.traileffectnum = particleeffectnum("gibnull");		//  adds particle effect to gibs when in slime (customize the effect in your effectinfo.txt)
      		}
   	if ((pointcontents(self.origin) != CONTENT_SLIME) && (pointcontents(self.origin) != CONTENT_LAVA) && (self.traileffectnum != particleeffectnum("burning_gib") && (self.traileffectnum != particleeffectnum("burning_gib_fade") && (self.traileffectnum != particleeffectnum("charred_gib") && (self.traileffectnum != particleeffectnum("gib_lg"))))))	// needed to STOP the particle effect when gib is kicked/shot out of slime or lava !!
   		{
   		//Gib bounce sound test - HALF ASSED IM SORRY
   		/*if (self.lip <= .01 && other.classname != "player" && autocvar_gibs_bounce_sound == 1) 
			sound(self, CHAN_BODY, "gib/gibhit1.wav", .2, ATTN_NORM);*/	
		self.traileffectnum = particleeffectnum("gibnull");		//  REMOVES the particle effect from gibs (it is a null effect in your effectinfo.txt)
		}
	if (self.traileffectnum == particleeffectnum("burning_gib"))
	{		
		self.think = burngib_init;
		self.nextthink = time;
	}
	
	
	/*if (self.velocity > '0 0 0' && pointcontents(self.origin) == CONTENT_EMPTY)
		sound(other, CHAN_ITEM, "gib/gibhit1.wav", 1, ATTN_NORM);*/

var float autocvar_gibflies = 1;     	// set cvar 'gibflies' default to 1
	if (autocvar_gibflies == 1)		// if 'gibflies' is '1' 
		{
   		if ((pointcontents(self.origin) != CONTENT_SLIME) && (pointcontents(self.origin) != CONTENT_LAVA) && (pointcontents(self.origin) != CONTENT_WATER))	// check if gib is out of slime or lava or water
	      	self.traileffectnum = particleeffectnum("gibfliesblack");		//  adds BLACK flies to gibs (customize the effect in your effectinfo.txt)
		}
	if (autocvar_gibflies == 2)		// if 'gibflies' is '2' 
		{
   		if ((pointcontents(self.origin) != CONTENT_SLIME) && (pointcontents(self.origin) != CONTENT_LAVA) && (pointcontents(self.origin) != CONTENT_WATER))	// check if gib is out of slime or lava or water
	      	self.traileffectnum = particleeffectnum("gibfliesbrown");		//  adds BROWN flies to gibs (customize the effect in your effectinfo.txt)
		}
}

local float zufall;
    zufall = random();
    if (zufall > 0.66)   		// randomized gib weight, so they don't cluster ontop of one another.
		self.gravity = 1.1;    	
    else if (zufall < 0.34)  		// randomized gib weight, so they don't cluster ontop of one another.
		self.gravity = 1; 
    else
		self.gravity = 0.9;
		
	self.delay = time;
};

void() kick_touch3_temp = 		// for new zombie_model head gib
{
	self.origin = self.origin + '0 0 7';
	droptofloor();
	setsize (self, '-8 -8 0', '8 8 24');
	self.touch = kick_touch3; 
	self.think = kick_touch3;
	self.nextthink = time + 0.5;	// wait a bit so that gib doesnt hang in walls
};



void() kick_touch4 = 			// for exploding boxes debris
{
	local vector v;

	// only a player can kick it
	if (other.classname != "player")
		return;

	//randomize sound
	local float zufallsound;
	zufallsound = random();
	if (zufallsound > 0.66)
		sound(other, CHAN_ITEM, "kickgib/kick_debris1.wav", 1, ATTN_NORM);
	else if (zufallsound < 0.34)
		sound(other, CHAN_ITEM, "kickgib/kick_debris2.wav", 1, ATTN_NORM);
	else
		sound(other, CHAN_ITEM, "kickgib/kick_debris3.wav", 1, ATTN_NORM);

	//define velocity 
	//you can play with these formulas to adjust trajectory
	if (random()< 0.5)    // randomized debris velocity, so they don't cluster ontop of one another.
	v_x = (other.velocity_x*.01);
	else
	v_x = (other.velocity_x*.02);
	
	if (random()< 0.5)     // randomized debris velocity, so they don't cluster ontop of one another.
	v_y = (other.velocity_y*.01);
	else
	v_y = (other.velocity_y*.02);
	
	if (v_x & v_y == 0)  // avoids infinite debris jumping on players head
		v_z = -220;
	else
		v_z = 250;

local float zufall;
    zufall = random();
    if (zufall > 0.66)   		// randomized debris weight, so they don't cluster ontop of one another.
		self.gravity = 1.6;    	// makes the debris heavier. So they dont bounce like pingpong balls anymore
    else if (zufall < 0.34)  		// randomized debris weight, so they don't cluster ontop of one another.
		self.gravity = 1.7; 	// makes the debris heavier. So they dont bounce like pingpong balls anymore
    else
		self.gravity = 1.5;	// makes the debris heavier. So they dont bounce like pingpong balls anymore


	self.flags = self.flags - ( self.flags & FL_ONGROUND );
    	self.velocity = v;

	if (v_x & v_y & v_z == 0)  // avoids debris spinning when player stands inside gib (which is possible due to above "infinite head jumping" workaround)
		self.avelocity = '0 0 0'; 
	else
		self.avelocity = '0 300 0';   // spins the debris, so that it looks more realistic; but only around its yaw.

	self.think = gib_gravity_reset3;	// to reset the gravity to 1 for GYRO !!! 
	self.nextthink = time + 1.1;
};



void() kick_touch5 =  			// for afrit gibs (burning)
{
	local vector v;

   	if (pointcontents(self.origin) == CONTENT_LAVA)				// checks for lava
   		{
      		self.traileffectnum = particleeffectnum("gibburn");		//  adds particle effect to gibs when in lava (customize the effect in your effectinfo.txt)
	//	self.skin = 1;								// use a different "burnt" skin "1" if you have/want.
		self.colormod = '0.4 0.1 0.1';					// change the color of the gib to  burned  dark red
      		}
   	if (pointcontents(self.origin) == CONTENT_SLIME)			// checks for slime
   		{
      		self.traileffectnum = particleeffectnum("gibacid");		//  adds particle effect to gibs when in slime (customize the effect in your effectinfo.txt)
	//	self.skin = 2;								// use a different "acidly" skin "2" if you have/want.
		self.colormod = '0.3 1.6 0.3';					// change the color of the gib to  slimy/etchy  green
      		}
   	if ((pointcontents(self.origin) != CONTENT_SLIME) && (pointcontents(self.origin) != CONTENT_LAVA))	// needed to STOP the particle effect when gib is kicked/shot out of slime or lava !!
   		{
      		self.traileffectnum = particleeffectnum("gibnull");		//  REMOVES the particle effect from gibs (it is a null effect in your effectinfo.txt)
      		}

   	if ((pointcontents(self.origin) != CONTENT_SLIME) && (pointcontents(self.origin) != CONTENT_LAVA) && (pointcontents(self.origin) != CONTENT_WATER))	// check if gib is out of slime or lava or water
		{
		if (self.skin_type)
		      	self.traileffectnum = particleeffectnum("Afrit_gib_grey");	//  adds burning particles to gibs (customize the effect in your effectinfo.txt)
		else
		      	self.traileffectnum = particleeffectnum("Afrit_gib_red");	//  adds burning particles to gibs (customize the effect in your effectinfo.txt)
		}

	// only a player can kick it
	if (other.classname != "player")
		return;

	//randomize sound
	if (random()< 0.7)
		sound(other, CHAN_ITEM, "kickgib/gib_hit.wav", 1, ATTN_NORM);
	else
		sound(other, CHAN_ITEM, "kickgib/gib_miss.wav", 1, ATTN_NORM);

	//define velocity 
	//you can play with these formulas to adjust trajectory
	if (random()< 0.5)    // randomized gib velocity, so they don't cluster ontop of one another.
	v_x = (other.velocity_x*1.4);
	else
	v_x = (other.velocity_x*1.5);
	
	if (random()< 0.5)     // randomized gib velocity, so they don't cluster ontop of one another.
	v_y = (other.velocity_y*1.4);
	else
	v_y = (other.velocity_y*1.5);
	
	if (v_x & v_y == 0)  // avoids infinite gib jumping on players head
		v_z = -220;
	else
		v_z = 250;

local float zufall;
    zufall = random();
    if (zufall > 0.66)   		// randomized gib weight, so they don't cluster ontop of one another.
		self.gravity = 1.6;    	// makes the gibs heavier. So they dont bounce like pingpong balls anymore
    else if (zufall < 0.34)  		// randomized gib weight, so they don't cluster ontop of one another.
		self.gravity = 1.7; 	// makes the gibs heavier. So they dont bounce like pingpong balls anymore
    else
		self.gravity = 1.5;	// makes the gibs heavier. So they dont bounce like pingpong balls anymore

	
	self.flags = self.flags - ( self.flags & FL_ONGROUND );
    	self.velocity = v;

	if (v_x & v_y & v_z == 0)  // avoids gib spinning when player stands inside gib (which is possible due to above "infinite head jumping" workaround)
		self.avelocity = '0 0 0'; 
	else
		{
		self.avelocity_x = crandom()*300;
		self.avelocity_y = crandom()*300;
		self.avelocity_z = crandom()*300;
		}

	setsize (self, '-12 -12 0', '12 12 48');
	self.touch = kick_touch5;      

	self.cansplash = 1;

	self.think = gib_gravity_reset;		// to reset the gravity to 1 for GYRO !!! 
	self.nextthink = time + 1.1;
};


void() kick_touch5temp = 		// for afrit gibs (burning)
{
	self.think = kick_touch5;
	self.nextthink = time + 1;	// wait for 1 second so that gibs doesnt hang in walls
	self.touch = kick_touch5; 
};



void() kick_touch6 = 			// for afrit gibs (burning) (when cvar kick_afrit_gibs is set to "0")
{
   	if (pointcontents(self.origin) == CONTENT_LAVA)				// checks for lava
   		{
      		self.traileffectnum = particleeffectnum("gibburn");		//  adds particle effect to gibs when in lava (customize the effect in your effectinfo.txt)
	//	self.skin = 1;								// use a different "burnt" skin "1" if you have/want.
		self.colormod = '0.4 0.1 0.1';					// change the color of the gib to  burned  dark red
      		}
   	if (pointcontents(self.origin) == CONTENT_SLIME)			// checks for slime
   		{
      		self.traileffectnum = particleeffectnum("gibacid");		//  adds particle effect to gibs when in slime (customize the effect in your effectinfo.txt)
	//	self.skin = 2;								// use a different "acidly" skin "2" if you have/want.
		self.colormod = '0.3 1.6 0.3';					// change the color of the gib to  slimy/etchy  green
      		}
   	if ((pointcontents(self.origin) != CONTENT_SLIME) && (pointcontents(self.origin) != CONTENT_LAVA))	// needed to STOP the particle effect when gib is kicked/shot out of slime or lava !!
	      	self.traileffectnum = particleeffectnum("gibnull");		//  REMOVES the particle effect from gibs (it is a null effect in your effectinfo.txt)

   	if ((pointcontents(self.origin) != CONTENT_SLIME) && (pointcontents(self.origin) != CONTENT_LAVA) && (pointcontents(self.origin) != CONTENT_WATER))	// check if gib is out of slime or lava or water
		{
		if (self.skin_type)
		      	self.traileffectnum = particleeffectnum("Afrit_gib_grey");	//  adds burning particles to gibs (customize the effect in your effectinfo.txt)
		else
		      	self.traileffectnum = particleeffectnum("Afrit_gib_red");	//  adds burning particles to gibs (customize the effect in your effectinfo.txt)
		}

local float zufall, gibsfadetime;
    zufall = random();
    if (zufall > 0.66)   		// randomized gib weight, so they don't cluster ontop of one another.
		self.gravity = 1.1;    	
    else if (zufall < 0.34)  		// randomized gib weight, so they don't cluster ontop of one another.
		self.gravity = 1; 
    else
		self.gravity = 0.9;

	setsize (self, '-12 -12 0', '12 12 48');
	self.touch = kick_touch6;  
	 
	var float autocvar_gibsduration = 10;      // set cvar 'gibsduration' default to 10 == original ID1 behaviour
	if (autocvar_gibsduration == 0)		   // if 'gibsduration' is set via autoexec.cfg to '0'
		{				   // --> gibs will NEVER disappear !!!
	 	self.nextthink = -1;
		}
	else 					  // if 'gibsduration' is set via autoexec.cfg to any other value than '0'
		{				  // --> gibs fade out
		gibsfadetime = autocvar_gibsduration;
		self.think = gibsfade_noblood;
		self.ltime = time;
		self.nextthink = time + gibsfadetime + random()*10;
		}
};


void() kick_touch6temp = 		// for afrit gibs (burning) (when cvar kick_afrit_gibs is set to "0")
{
	self.think = kick_touch6;
	self.nextthink = time + 1;	// wait for 1 second so that gibs doesnt hang in walls
};




//**********************************************
//**********************************************
// For animated heart gib
//**********************************************
//**********************************************

void() gib_heart_stop_beating;

void() heart_dies =	  // heart will stop beating and starts countdown to vanish
{
	precache_sound ("player/gibexplode.wav");  
	self.scale = 1; 
	self.gravity = 1; 
	self.think = gib_heart_stop_beating;	
	self.nextthink = time + 0.1;
};

void() kick_touch_heart1 =  			// for animated heart gib
{
	local vector v;
   	if (pointcontents(self.origin) == CONTENT_WATER)				// checks for lava
   		{
		self.traileffectnum = particleeffectnum("gib_heart_nobeating");
		self.think = heart_dies;		
		self.nextthink = time + 0.1;
	      	}
   	if (pointcontents(self.origin) == CONTENT_LAVA)				// checks for lava
   		{
      		self.traileffectnum = particleeffectnum("gibburn");		//  adds particle effect to gibs when in lava (customize the effect in your effectinfo.txt)
	//	self.skin = 1;							// use a different "burnt" skin "1" if you have/want.
		self.colormod = '0.4 0.1 0.1';					// change the color of the gib to  burned  dark red
		self.think = heart_dies;		
		self.nextthink = time + 0.1;
	      	}
   	if (pointcontents(self.origin) == CONTENT_SLIME)			// checks for slime
   		{
      		self.traileffectnum = particleeffectnum("gibacid");		//  adds particle effect to gibs when in slime (customize the effect in your effectinfo.txt)
	//	self.skin = 2;							// use a different "acidly" skin "2" if you have/want.
		self.colormod = '0.3 1.6 0.3';					// change the color of the gib to  slimy/etchy  green
		self.think = heart_dies;		
		self.nextthink = time + 0.1;
	      	}
   	if ((pointcontents(self.origin) != CONTENT_SLIME) && (pointcontents(self.origin) != CONTENT_LAVA))	// needed to STOP the particle effect when gib is kicked/shot out of slime or lava !!
   		{
      		self.traileffectnum = particleeffectnum("gib_heart"); 		//  REMOVES the lava/liquid particle effect from heart gib (it is a null effect in your effectinfo.txt)
      		}

	// only a player can kick it
	if (other.classname != "player")
		return;

	//randomize sound
	if (random()< 0.7)
		sound(other, CHAN_ITEM, "kickgib/gib_hit.wav", 1, ATTN_NORM);
	else
		sound(other, CHAN_ITEM, "kickgib/gib_miss.wav", 1, ATTN_NORM);

	//define velocity 
	//you can play with these formulas to adjust trajectory
	if (random()< 0.5)    // randomized gib velocity, so they don't cluster ontop of one another.
	v_x = (other.velocity_x*1.4);
	else
	v_x = (other.velocity_x*1.5);
	
	if (random()< 0.5)     // randomized gib velocity, so they don't cluster ontop of one another.
	v_y = (other.velocity_y*1.4);
	else
	v_y = (other.velocity_y*1.5);
	
	if (v_x & v_y == 0)  // avoids infinite gib jumping on players head
		v_z = -220;
	else
		v_z = 250;

local float zufall;
    zufall = random();
    if (zufall > 0.66)   		// randomized gib weight, so they don't cluster ontop of one another.
		self.gravity = 1.6;    	// makes the gibs heavier. So they dont bounce like pingpong balls anymore
    else if (zufall < 0.34)  		// randomized gib weight, so they don't cluster ontop of one another.
		self.gravity = 1.7; 	// makes the gibs heavier. So they dont bounce like pingpong balls anymore
    else
		self.gravity = 1.5;	// makes the gibs heavier. So they dont bounce like pingpong balls anymore
	
	self.flags = self.flags - ( self.flags & FL_ONGROUND );
    	self.velocity = v;

	if (v_x & v_y & v_z == 0)  // avoids gib spinning when player stands inside gib (which is possible due to above "infinite head jumping" workaround)
		self.avelocity = '0 0 0'; 
	else
		self.avelocity = '0 300 0';		// spins the gib, so that it looks more realistic; but only around its yaw.
};



void() kick_touch_heart2 = 			// for animated heart gib (when cvar kickgibs is set to "0")
{
   	if (pointcontents(self.origin) == CONTENT_WATER)				// checks for lava
   		{
		self.traileffectnum = particleeffectnum("gib_heart_nobeating");
		self.think = heart_dies;		
		self.nextthink = time + 0.1;
	      	}
   	if (pointcontents(self.origin) == CONTENT_LAVA)				// checks for lava
   		{
      		self.traileffectnum = particleeffectnum("gibburn");		//  adds particle effect to gibs when in lava (customize the effect in your effectinfo.txt)
	//	self.skin = 1;							// use a different "burnt" skin "1" if you have/want.
		self.colormod = '0.4 0.1 0.1';					// change the color of the gib to  burned  dark red
		self.think = heart_dies;		
		self.nextthink = time + 0.1;
	      	}
   	if (pointcontents(self.origin) == CONTENT_SLIME)			// checks for slime
   		{
      		self.traileffectnum = particleeffectnum("gibacid");		//  adds particle effect to gibs when in slime (customize the effect in your effectinfo.txt)
	//	self.skin = 2;							// use a different "acidly" skin "2" if you have/want.
		self.colormod = '0.3 1.6 0.3';					// change the color of the gib to  slimy/etchy  green
		self.think = heart_dies;		
		self.nextthink = time + 0.1;
	      	}
   	if ((pointcontents(self.origin) != CONTENT_SLIME) && (pointcontents(self.origin) != CONTENT_LAVA))	// needed to STOP the particle effect when gib is kicked/shot out of slime or lava !!
   		{
      		self.traileffectnum = particleeffectnum("gib_heart"); 		//  REMOVES the lava/liquid particle effect from heart gib (it is a null effect in your effectinfo.txt)
      		}

local float zufall;
    zufall = random();
    if (zufall > 0.66)   		// randomized gib weight, so they don't cluster ontop of one another.
		self.gravity = 1.1;    	
    else if (zufall < 0.34)  		// randomized gib weight, so they don't cluster ontop of one another.
		self.gravity = 1; 
    else
		self.gravity = 0.9;
};



void() kick_touch_heart1_nobeating =  			// for animated heart gib when it stopped beating
{
	local vector v;
   	if (pointcontents(self.origin) == CONTENT_WATER)				// checks for lava
   		{
		self.traileffectnum = particleeffectnum("gib_heart_nobeating");
		heart_dies();
	      	}

   	if (pointcontents(self.origin) == CONTENT_LAVA)				// checks for lava
   		{
      		self.traileffectnum = particleeffectnum("gibburn");		//  adds particle effect to gibs when in lava (customize the effect in your effectinfo.txt)
	//	self.skin = 1;							// use a different "burnt" skin "1" if you have/want.
		self.colormod = '0.4 0.1 0.1';					// change the color of the gib to  burned  dark red
		heart_dies();
	      	}
   	if (pointcontents(self.origin) == CONTENT_SLIME)			// checks for slime
   		{
      		self.traileffectnum = particleeffectnum("gibacid");		//  adds particle effect to gibs when in slime (customize the effect in your effectinfo.txt)
	//	self.skin = 2;							// use a different "acidly" skin "2" if you have/want.
		self.colormod = '0.3 1.6 0.3';					// change the color of the gib to  slimy/etchy  green
		heart_dies();
	      	}
   	if ((pointcontents(self.origin) != CONTENT_SLIME) && (pointcontents(self.origin) != CONTENT_LAVA))	// needed to STOP the particle effect when gib is kicked/shot out of slime or lava !!
   		{
      		self.traileffectnum = particleeffectnum("gib_heart_nobeating"); 		//  REMOVES the lava/liquid particle effect from heart gib (it is a null effect in your effectinfo.txt)
      		}

	// only a player can kick it
	if (other.classname != "player")
		return;

	//randomize sound
	if (random()< 0.7)
		sound(other, CHAN_ITEM, "kickgib/gib_hit.wav", 1, ATTN_NORM);
	else
		sound(other, CHAN_ITEM, "kickgib/gib_miss.wav", 1, ATTN_NORM);

	//define velocity 
	//you can play with these formulas to adjust trajectory
	if (random()< 0.5)    // randomized gib velocity, so they don't cluster ontop of one another.
	v_x = (other.velocity_x*1.4);
	else
	v_x = (other.velocity_x*1.5);
	
	if (random()< 0.5)     // randomized gib velocity, so they don't cluster ontop of one another.
	v_y = (other.velocity_y*1.4);
	else
	v_y = (other.velocity_y*1.5);
	
	if (v_x & v_y == 0)  // avoids infinite gib jumping on players head
		v_z = -220;
	else
		v_z = 250;

local float zufall;
    zufall = random();
    if (zufall > 0.66)   		// randomized gib weight, so they don't cluster ontop of one another.
		self.gravity = 1.6;    	// makes the gibs heavier. So they dont bounce like pingpong balls anymore
    else if (zufall < 0.34)  		// randomized gib weight, so they don't cluster ontop of one another.
		self.gravity = 1.7; 	// makes the gibs heavier. So they dont bounce like pingpong balls anymore
    else
		self.gravity = 1.5;	// makes the gibs heavier. So they dont bounce like pingpong balls anymore
	
	self.flags = self.flags - ( self.flags & FL_ONGROUND );
    	self.velocity = v;

	if (v_x & v_y & v_z == 0)  // avoids gib spinning when player stands inside gib (which is possible due to above "infinite head jumping" workaround)
		self.avelocity = '0 0 0'; 
	else
		self.avelocity = '0 300 0';		// spins the gib, so that it looks more realistic; but only around its yaw.
};


void() kick_touch_heart2_nobeating =  			// for animated heart gib (when cvar kickgibs is set to "0") when it stopped beating
{
   	if (pointcontents(self.origin) == CONTENT_WATER)				// checks for lava
   		{
		self.traileffectnum = particleeffectnum("gib_heart_nobeating");
		heart_dies();
		}
   	if (pointcontents(self.origin) == CONTENT_LAVA)				// checks for lava
   		{
      		self.traileffectnum = particleeffectnum("gibburn");		//  adds particle effect to gibs when in lava (customize the effect in your effectinfo.txt)
	//	self.skin = 1;							// use a different "burnt" skin "1" if you have/want.
		self.colormod = '0.4 0.1 0.1';					// change the color of the gib to  burned  dark red
		heart_dies();
	      	}
   	if (pointcontents(self.origin) == CONTENT_SLIME)			// checks for slime
   		{
      		self.traileffectnum = particleeffectnum("gibacid");		//  adds particle effect to gibs when in slime (customize the effect in your effectinfo.txt)
	//	self.skin = 2;							// use a different "acidly" skin "2" if you have/want.
		self.colormod = '0.3 1.6 0.3';					// change the color of the gib to  slimy/etchy  green
		heart_dies();
	      	}
   	if ((pointcontents(self.origin) != CONTENT_SLIME) && (pointcontents(self.origin) != CONTENT_LAVA))	// needed to STOP the particle effect when gib is kicked/shot out of slime or lava !!
   		{
      		self.traileffectnum = particleeffectnum("gib_heart_nobeating"); 		//  REMOVES the lava/liquid particle effect from heart gib (it is a null effect in your effectinfo.txt)
      		}

local float zufall;
    zufall = random();
    if (zufall > 0.66)   		// randomized gib weight, so they don't cluster ontop of one another.
		self.gravity = 1.1;    	
    else if (zufall < 0.34)  		// randomized gib weight, so they don't cluster ontop of one another.
		self.gravity = 1; 
    else
		self.gravity = 0.9;
};




//**********************************************
// Alternative gib behaviour: instead of kicking a gib/head, only MOVE it.
// If you want to use that code, delete the above code and remove the:  /* and */
//**********************************************
/*

void() kick_touch;
 
void() kick_touch = 
 
{
      // kicking sounds are deactivated here, because otherwise they would be called almost constantly.
      // only a player can kick it
      if (other.classname != "player")
            return;
  
      self.origin = self.origin + '0 0 0.2';   // lifts the gib a little from the floot, so that it can be moved.
 
      self.flags = self.flags - ( self.flags & FL_ONGROUND );

      self.velocity_x = (other.velocity_x*1.3);
      self.velocity_y = (other.velocity_y*1.3);
      // no velocity in z-direction !	

      self.avelocity = '0 100 0'; // spins the gib, so that it looks more realistic; but only around its yaw.
			    		    // Otherwise the headmdl would sink into the floor.

};

*/
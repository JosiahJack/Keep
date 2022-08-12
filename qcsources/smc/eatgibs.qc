//************************************************************
//
// Eatable regular gibs and head gibs
// 
//************************************************************

void() head_gib_faceplayer;
void() heart_dies;


void() regular_gib_think =	  
{
var float autocvar_gibsduration = 10;    		 // set cvar 'gibsduration' default to 10 == original ID1 behaviour
	if (autocvar_gibsduration == 0)			 // if 'gibsduration' is set via autoexec.cfg to '0'
		return;					 // --> gibs will NEVER disappear !!!

// without the following lines, the three gib models would never
// disappear after they have been touched.
	
	if (autocvar_gibsexplode == 0)
		{
		self.think = gibsfade_noblood;
		self.ltime = time;
		self.nextthink = time + autocvar_gibsduration + random()*10;
		}
	else				
		{
		precache_sound ("player/gibexplode.wav");  
		self.think = gibsfade_blood;
		self.ltime = time;
		self.nextthink = time + autocvar_gibsduration + random()*10;
		}
};




void() eat_regular_gib_touch =  		// for regular gibs (no head-gib)
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
   	if ((pointcontents(self.origin) != CONTENT_SLIME) && (pointcontents(self.origin) != CONTENT_LAVA))	// needed to STOP the particle effect when gib is shot out of slime or lava !!
   		{
      		self.traileffectnum = particleeffectnum("gibnull");		//  REMOVES the particle effect from gibs (it is a null effect in your effectinfo.txt)
      		}

var float autocvar_gibflies = 1;     	// set cvar 'gibflies' default to 1
	if (autocvar_gibflies == 1)		// if 'gibflies' is '1' 
		{
   		if ((pointcontents(self.origin) != CONTENT_SLIME) && (pointcontents(self.origin) != CONTENT_LAVA) && (pointcontents(self.origin) != CONTENT_WATER))	// check if gib is out of slime or lava or water
	      		{
			if (autocvar_blood_spitting_gibs)
				self.traileffectnum = particleeffectnum("gibfliesblack_plus_blood_spit");	//  adds BLACK flies to gibs AND gibs pumping some blood  (customize the effect in your effectinfo.txt)
			else
				self.traileffectnum = particleeffectnum("gibfliesblack");			//  adds BLACK flies to gibs (customize the effect in your effectinfo.txt)
			}
		}
	else if (autocvar_gibflies == 2)		// if 'gibflies' is '2' 
		{
   		if ((pointcontents(self.origin) != CONTENT_SLIME) && (pointcontents(self.origin) != CONTENT_LAVA) && (pointcontents(self.origin) != CONTENT_WATER))	// check if gib is out of slime or lava or water
	      		{
			if (autocvar_blood_spitting_gibs)
				self.traileffectnum = particleeffectnum("gibfliesbrown_plus_blood_spit");	//  adds BROWN flies to gibs AND gibs pumping some blood  (customize the effect in your effectinfo.txt)
			else
			      	self.traileffectnum = particleeffectnum("gibfliesbrown");			//  adds BROWN flies to gibs (customize the effect in your effectinfo.txt)
			}
		}
	else
		{
   		if ((pointcontents(self.origin) != CONTENT_SLIME) && (pointcontents(self.origin) != CONTENT_LAVA) && (pointcontents(self.origin) != CONTENT_WATER))	// check if gib is out of slime or lava or water
	      		{
			if (autocvar_blood_spitting_gibs)
				self.traileffectnum = particleeffectnum("TR_BLOOD_plus_blood_spit");	//  adds gibs pumping some blood  (customize the effect in your effectinfo.txt)
			else
			      	self.traileffectnum = particleeffectnum("TR_BLOOD");			//  standard Quake effect (customize the effect in your effectinfo.txt)
			}
		}

	self.think = regular_gib_think;
	self.nextthink = time + 0.2;


	// only a player can eat it
	if (other.classname != "player")
		return;


	if (T_Heal(other, self, 0))
	{

		//randomize sound
		if (random()< 0.5)
			sound(other, CHAN_AUTO, "player/eatgib01.wav", 0.65, ATTN_NORM);
		else
			sound(other, CHAN_AUTO, "player/eatgib02.wav", 0.9, ATTN_NORM);

		// spawn a little blood when picked
		v = self.origin;
		te_blood (v,'0 100 1000', 20);								// FIXME set blood velocity
		te_blood (v,'100 0 1000', 20);
		te_blood (v,'-100 0 1000', 20);
		te_blood (v,'0 -100 1000', 20);

		stuffcmd (other, "bf\n");			// small screen flash

		local	string	s;
		sprint(other, "You receive ");
		s = ftos(self.healamount);
		sprint(other, s);
		sprint(other, " health\n");

		self.touch = SUB_Null;
		self.nextthink = time + 0.01;
		self.think = SUB_Remove;	
	}
};






void() eat_head_gib_touch = 			// for head gibs
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
	      		{
			if (autocvar_blood_spitting_gibs)
				self.traileffectnum = particleeffectnum("gibfliesblack_plus_blood_spit");	//  adds BLACK flies to gibs AND gibs pumping some blood  (customize the effect in your effectinfo.txt)
			else
				self.traileffectnum = particleeffectnum("gibfliesblack");			//  adds BLACK flies to gibs (customize the effect in your effectinfo.txt)
			}
		}
	if (autocvar_gibflies == 2)		// if 'gibflies' is '2' 
		{
   		if ((pointcontents(self.origin) != CONTENT_SLIME) && (pointcontents(self.origin) != CONTENT_LAVA) && (pointcontents(self.origin) != CONTENT_WATER))	// check if gib is out of slime or lava or water
	      		{
			if (autocvar_blood_spitting_gibs)
				self.traileffectnum = particleeffectnum("gibfliesbrown_plus_blood_spit");	//  adds BROWN flies to gibs AND gibs pumping some blood  (customize the effect in your effectinfo.txt)
			else
			      	self.traileffectnum = particleeffectnum("gibfliesbrown");			//  adds BROWN flies to gibs (customize the effect in your effectinfo.txt)
			}
		}
	else
		{
   		if ((pointcontents(self.origin) != CONTENT_SLIME) && (pointcontents(self.origin) != CONTENT_LAVA) && (pointcontents(self.origin) != CONTENT_WATER))	// check if gib is out of slime or lava or water
	      		{
			if (autocvar_blood_spitting_gibs)
				self.traileffectnum = particleeffectnum("TR_BLOOD_plus_blood_spit");	//  adds gibs pumping some blood  (customize the effect in your effectinfo.txt)
			else
			      	self.traileffectnum = particleeffectnum("TR_BLOOD");			//  standard Quake effect (customize the effect in your effectinfo.txt)
			}
		}
}


	if (autocvar_head_gibs_always_face_player)
	{
	    self.nextthink = time + 0.1;
	    self.think = head_gib_faceplayer;
	}


	// only a player can eat it
	if (other.classname != "player")
		return;


	if (T_Heal(other, self, 0))
	{

		//randomize sound
		if (random()< 0.5)
			sound(other, CHAN_AUTO, "player/eatgib01.wav", 0.65, ATTN_NORM);
		else
			sound(other, CHAN_AUTO, "player/eatgib02.wav", 0.9, ATTN_NORM);

		// spawn a little blood when picked
		v = self.origin;
		te_blood (v,'0 100 1000', 20);								// FIXME set blood velocity
		te_blood (v,'100 0 1000', 20);
		te_blood (v,'-100 0 1000', 20);
		te_blood (v,'0 -100 1000', 20);

		stuffcmd (other, "bf\n");			// small screen flash

		local	string	s;
		sprint(other, "You receive ");
		s = ftos(self.healamount);
		sprint(other, s);
		sprint(other, " health\n");

		self.touch = SUB_Null;
		self.nextthink = time + 0.01;
		self.think = SUB_Remove;	
	}
};







void() eat_heart_gib_touch =  			// for animated heart gib
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

	// only a player can eat it
	if (other.classname != "player")
		return;


	if (T_Heal(other, self, 0))
	{

		//randomize sound
		if (random()< 0.5)
			sound(other, CHAN_AUTO, "player/eatgib01.wav", 0.65, ATTN_NORM);
		else
			sound(other, CHAN_AUTO, "player/eatgib02.wav", 0.9, ATTN_NORM);

		// spawn a little blood when picked
		v = self.origin;
		te_blood (v,'0 100 1000', 20);								// FIXME set blood velocity
		te_blood (v,'100 0 1000', 20);
		te_blood (v,'-100 0 1000', 20);
		te_blood (v,'0 -100 1000', 20);

		stuffcmd (other, "bf\n");			// small screen flash

		local	string	s;
		sprint(other, "You receive ");
		s = ftos(self.healamount);
		sprint(other, s);
		sprint(other, " health\n");

		self.touch = SUB_Null;
		self.nextthink = time + 0.01;
		self.think = SUB_Remove;	
	}
};



void() eat_heart_gib_touch_nobeating =  		// for animated heart gib when it stopped beating
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

	// only a player can eat it
	if (other.classname != "player")
		return;


	if (T_Heal(other, self, 0))
	{

		//randomize sound
		if (random()< 0.5)
			sound(other, CHAN_AUTO, "player/eatgib01.wav", 0.65, ATTN_NORM);
		else
			sound(other, CHAN_AUTO, "player/eatgib02.wav", 0.9, ATTN_NORM);

		// spawn a little blood when picked
		v = self.origin;
		te_blood (v,'0 100 1000', 20);								// FIXME set blood velocity
		te_blood (v,'100 0 1000', 20);
		te_blood (v,'-100 0 1000', 20);
		te_blood (v,'0 -100 1000', 20);

		stuffcmd (other, "bf\n");			// small screen flash

		local	string	s;
		sprint(other, "You receive ");
		s = ftos(self.healamount);
		sprint(other, s);
		sprint(other, " health\n");

		self.touch = SUB_Null;
		self.nextthink = time + 0.01;
		self.think = SUB_Remove;	
	}
};


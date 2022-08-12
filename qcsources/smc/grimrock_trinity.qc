//  This is the death animation code for the new  "Legend of Grimrock + Blade-Trinity"  death animation.
//  Can be used by any monster. It only makes use of additional skins/models for the zombie (other monsters dont).
//  It started as a simple idea while playing the game "Legend of Grimrock" and turned out into a good looking
//  new death effect animation for Quake.
//  If you want to disable GYRO during death animation (so that the monster´s ashes does not "fly away"), see my note/edit in
//  the individual monsters .qc files.
//  Thank you Nahuel for his great "Blade Trinity" code extension ontop of the "Grimrock" effect !
//
//  Have fun,
//  Seven


.float burn_flag; // On/off for the flashlight
.entity burny;   // flash entity
.float burnz_origin; // On/off for the flashlight
.float burn_origin; // On/off for the flashlight
.float burn_color;   //  added random float for different particle colors


/////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////
///////////////////  Zombie version below  //////////////////
/////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////

void() zdisapear =
{
self.frame = self.owner.frame;
if (self.alpha < 0)
	{
	remove(self);
	}
else
	{
	if (self.alpha < 0.1)
		{
		self.skin = 4;			//  was 3. Had to change it due to SMC multiskin feature
		}
self.alpha = self.alpha - 0.01;		// was  -0.005
self.nextthink = time + 0.01;
	}
};


void() zbburn =
{
if (self.alpha > 1)
	{        
	self.nextthink = time + 0.01;
	self.think = zdisapear;
	self.frame = self.owner.frame;
	}
else
	{
	makevectors (self.owner.angles);
        traceline (self.owner.origin , (self.owner.origin) , FALSE , self);

        setorigin (self, trace_endpos);
        self.nextthink = time + 0.01;
	self.think = zbburn;
	self.frame = self.owner.frame;
	self.skin = 3;			//  was 2. Had to change it due to SMC multiskin feature
	self.scale = 1;
	self.angles = self.owner.angles;
	self.owner.alpha = self.owner.alpha - 0.03; //0.01;	// was  - 0.006
	self.alpha = self.alpha + 0.03; //+ 0.01;		// was  + 0.006
	}
};


void() zburna =
{
        // Make a new entity to hold the Flashlight
        local entity myburn;

        // spawn flash
        myburn = spawn ();
        myburn.movetype = MOVETYPE_NONE;
        myburn.solid = SOLID_NOT;
        setmodel (myburn, "progs/zombie.mdl"); 
        setsize (myburn, '0 0 0', '0 0 0');

        // Wire Player And Flashlight Together
        myburn.owner = self;
        self.burny = myburn;

        myburn.classname = "flash";
        
        makevectors (self.v_angle);
        traceline (self.origin , (self.origin) , FALSE , self);
        setorigin (myburn, trace_endpos);
	  myburn.alpha = -0.01;

        myburn.think = zbburn;
        myburn.nextthink = time + 0.005;
};




void() bburnb =
{
if (self.burn_origin < -10)	
	{
	self.think = SUB_Remove;
	self.nextthink = time + 0.02;
	}
if (self.burn_origin >= 10)		//  will never fullfill this !!!
	{
	if (self.burn_origin < -6)	
		{
		self.owner.skin = 2;			//  was 1. Had to change it due to SMC multiskin feature
		}
	pointparticles(particleeffectnum("burningzombie"), self.origin, '0 0 0', 1);
 	pointparticles(particleeffectnum("burningzombie"), self.origin, '0 0 0', 1);
 	pointparticles(particleeffectnum("grimrock_zombie"), self.origin, '0 0 0', 1);
 
	makevectors (self.owner.angles);
        traceline (self.owner.origin , (self.owner.origin) , FALSE , self);
   	setorigin (self, trace_endpos+(v_up * (-5+ (self.owner.burnz_origin) )));
        self.nextthink = time + 0.02;
	self.burn_origin = self.burn_origin - 0.4;
	self.think = bburnb;
	}
};

void() burnb =
{
        local entity myburn;
        myburn = spawn ();
        myburn.movetype = MOVETYPE_NONE;
        myburn.solid = SOLID_NOT;
        setsize (myburn, '0 0 0', '0 0 0');
        myburn.owner = self;
        self.burny = myburn;
        myburn.classname = "flash";
        makevectors (self.v_angle);
        traceline (self.origin , (self.origin) , FALSE , self);
        setorigin (myburn, trace_endpos);
        myburn.think = bburnb;
        myburn.nextthink = time + 0.005;
};



void() bburnc =
{
if (self.burn_origin > 10)	
	{
      self.think = SUB_Remove;
      self.nextthink = time + 0.02;
	}

////////////////////////   first stage:

if (self.burn_origin <= 4)	
	{

	if (self.burn_color == 1)
		{
 		pointparticles(particleeffectnum("grimrock_zombie_a"), self.origin, '0 0 0', 1);
		}
	else 
		{
 		pointparticles(particleeffectnum("grimrock_zombie_b"), self.origin, '0 0 0', 1);
		}
	pointparticles(particleeffectnum("grimrock_zombie1"), self.origin, '0 0 0', 1);
 	pointparticles(particleeffectnum("burningzombie"), self.origin, '0 0 0', 1);
 	pointparticles(particleeffectnum("burningzombie"), self.origin, '0 0 0', 1);
	makevectors (self.owner.angles);
        traceline (self.owner.origin , (self.owner.origin) , FALSE , self);
        setorigin (self, trace_endpos+(v_up * (-5+ (self.owner.burnz_origin + self.burn_origin) )));
        self.nextthink = time + 0.02;
	self.think = bburnc;
	self.burn_origin = self.burn_origin + 0.4;
	}

////////////////////////   second stage added:

if ((self.burn_origin <= 10)&&(self.burn_origin > 4))
	{
	if (self.burn_origin > 6)	
		{
		self.owner.skin = 2;			//  was 1. Had to change it due to SMC multiskin feature
		}
	if (self.burn_color == 1)
		{
 		pointparticles(particleeffectnum("grimrock_zombie_a"), self.origin, '0 0 0', 1);
		}
	else 
		{
 		pointparticles(particleeffectnum("grimrock_zombie_b"), self.origin, '0 0 0', 1);
		}
	pointparticles(particleeffectnum("grimrock_zombie2"), self.origin, '0 0 0', 1);
 	pointparticles(particleeffectnum("burningzombie"), self.origin, '0 0 0', 1);
 	pointparticles(particleeffectnum("burningzombie"), self.origin, '0 0 0', 1);
	makevectors (self.owner.angles);
        traceline (self.owner.origin , (self.owner.origin) , FALSE , self);
        setorigin (self, trace_endpos+(v_up * (-5+ (self.owner.burnz_origin + self.burn_origin) )));
        self.nextthink = time + 0.02;
	self.think = bburnc;
	self.burn_origin = self.burn_origin + 0.4;
	}
};


void() burnc =
{
        local entity myburn;
	  local float zufall;
        myburn = spawn ();
        myburn.movetype = MOVETYPE_NONE;
        myburn.solid = SOLID_NOT;
        setsize (myburn, '0 0 0', '0 0 0');
        myburn.owner = self;
        self.burny = myburn;
        myburn.classname = "flash";
        self.alpha = 1;
        makevectors (self.v_angle);
        traceline (self.origin , (self.origin) , FALSE , self);
        setorigin (myburn, trace_endpos);
zufall = random();
if (zufall > 0.37)
	myburn.burn_color = 1;		// added random usage of particle colors in main function
else
	myburn.burn_color = 2;
        myburn.think = bburnc;
        myburn.nextthink = time + 0.005;
};


void () burn_toggle =
{
if (self.burn_flag == FALSE)
     	{       
      self.burn_flag = TRUE;
	burnb();	// has no effect in this code
	burnc();
      zburna();
     	}
};



////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////  Allround version (except shambler) below  ////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////


void() zdisapeard =
{
self.frame = self.owner.frame;
if (self.alpha < 0)
	{
	remove(self);
	}
else
	{
	//if (self.alpha < 0.1)
	//{
	//self.skin = 3;
	//}
	self.alpha = self.alpha - 0.01;		// was  -0.005
	self.nextthink = time + 0.01;
	}
};


void() zbburnd =
{

if (self.alpha > 1)
	{        
	self.nextthink = time + 0.01;
	self.think = zdisapeard;
	self.frame = self.owner.frame;
	}
else
	{
	makevectors (self.owner.angles);
	traceline (self.owner.origin , (self.owner.origin) , FALSE , self);
	setorigin (self, trace_endpos);
	self.nextthink = time + 0.01;
	self.think = zbburnd;
	self.frame = self.owner.frame;
	//self.skin = 2;
	self.scale = 1;
	self.angles = self.owner.angles;
	self.owner.alpha = self.owner.alpha - 0.025; 	//- 0.03;	// was  - 0.006
	self.alpha = self.alpha + 0.025; 			//+ 0.03;	// was  + 0.006
	}
};


void() zburnd =
{
        // Make a new entity to hold the Flashlight
        local entity myburn;

        // spawn flash
        myburn = spawn ();
        myburn.movetype = MOVETYPE_NONE;
        myburn.solid = SOLID_NOT;
        setsize (myburn, '0 0 0', '0 0 0');

        // Wire Player And Flashlight Together
        myburn.owner = self;
        self.burny = myburn;
        
        myburn.classname = "flash";
        
        makevectors (self.v_angle);
        traceline (self.origin , (self.origin) , FALSE , self);
        setorigin (myburn, trace_endpos);
	myburn.alpha = -0.01;

        myburn.think = zbburnd;
        myburn.nextthink = time + 0.005;
};



void() bburnd =
{
if (self.burn_origin > 10)	
	{
        self.think = SUB_Remove;
        self.nextthink = time + 0.02;
	}

////////////////////////   first stage:

if (self.burn_origin <= 4)	
	{
	if (self.burn_color == 1)
		{
 		pointparticles(particleeffectnum("grimrock_zombie_a"), self.origin, '0 0 0', 1);
		}
	else if (self.burn_color == 2)
		{
 		pointparticles(particleeffectnum("grimrock_zombie_b"), self.origin, '0 0 0', 1);
		}
	else
		{
 		pointparticles(particleeffectnum("grimrock_zombie_c"), self.origin, '0 0 0', 1);
		}
	pointparticles(particleeffectnum("grimrock_zombie1"), self.origin, '0 0 0', 1);
	pointparticles(particleeffectnum("burningzombie"), self.origin, '0 0 0', 1);
	pointparticles(particleeffectnum("burningzombie"), self.origin, '0 0 0', 1);
	makevectors (self.owner.angles);
        traceline (self.owner.origin , (self.owner.origin) , FALSE , self);
        setorigin (self, trace_endpos+(v_up * (-5+ (self.owner.burnz_origin + self.burn_origin) )));
        self.nextthink = time + 0.02;
	self.think = bburnd;
	self.burn_origin = self.burn_origin + 0.4;
	}

////////////////////////   second stage added:

if ((self.burn_origin <= 10)&&(self.burn_origin > 4))
	{
	//if (self.burn_origin > 6)	
	//{
	//self.owner.skin = 1;
	//}
	if (self.burn_color == 1)
		{
 		pointparticles(particleeffectnum("grimrock_zombie_a"), self.origin, '0 0 0', 1);
		}
	else if (self.burn_color == 2)
		{
 		pointparticles(particleeffectnum("grimrock_zombie_b"), self.origin, '0 0 0', 1);
		}
	else
		{
 		pointparticles(particleeffectnum("grimrock_zombie_c"), self.origin, '0 0 0', 1);
		}
	pointparticles(particleeffectnum("grimrock_zombie2"), self.origin, '0 0 0', 1);
 	pointparticles(particleeffectnum("burningzombie"), self.origin, '0 0 0', 1);
 	pointparticles(particleeffectnum("burningzombie"), self.origin, '0 0 0', 1);
	makevectors (self.owner.angles);
        traceline (self.owner.origin , (self.owner.origin) , FALSE , self);
        setorigin (self, trace_endpos+(v_up * (-5+ (self.owner.burnz_origin + self.burn_origin) )));
        self.nextthink = time + 0.02;
	self.think = bburnd;
	self.burn_origin = self.burn_origin + 0.4;
	}
};



void() burnd =
{
        local entity myburn;
	  local float zufall;
        myburn = spawn ();
        myburn.movetype = MOVETYPE_NONE;
        myburn.solid = SOLID_NOT;
        setsize (myburn, '0 0 0', '0 0 0');
        myburn.owner = self;
        self.burny = myburn;
        myburn.classname = "flash";
        self.alpha = 1;
        makevectors (self.v_angle);
        traceline (self.origin , (self.origin) , FALSE , self);
        setorigin (myburn, trace_endpos);
zufall = random();
if (zufall > 0.61)
	myburn.burn_color = 1;		// added random usage of particle colors in main function
else if (zufall < 0.39)
	myburn.burn_color = 2;
else
	myburn.burn_color = 3;
        myburn.think = bburnd;
        myburn.nextthink = time + 0.005;
};



void () burn_toggle_allround =
{
        if (self.burn_flag == FALSE)
        	{       
            self.burn_flag = TRUE;
		burnd();
            zburnd();
        	}
};




////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////  Shambler version below  //////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////

void() zdisapeare =
{
self.frame = self.owner.frame;
if (self.alpha < 0)
	{
	remove(self);
	}
else
	{
	//if (self.alpha < 0.1)
	//{
	//self.skin = 3;
	//}
	self.alpha = self.alpha - 0.01;		// was  -0.005
	self.nextthink = time + 0.01;
	}
};


void() zbburne =
{

if (self.alpha > 1)
	{        
	self.nextthink = time + 0.01;
	self.think = zdisapeare;
	self.frame = self.owner.frame;
	}
else
	{
	makevectors (self.owner.angles);
	traceline (self.owner.origin , (self.owner.origin) , FALSE , self);
	setorigin (self, trace_endpos);
	self.nextthink = time + 0.01;
	self.think = zbburne;
	self.frame = self.owner.frame;
	//self.skin = 2;
	self.scale = 1;
	self.angles = self.owner.angles;
	self.owner.alpha = self.owner.alpha - 0.025; 	//- 0.03;	// was  - 0.006
	self.alpha = self.alpha + 0.025; 			//+ 0.03;	// was  + 0.006
	}
};


void() zburne =
{
        // Make a new entity to hold the Flashlight
        local entity myburn;

        // spawn flash
        myburn = spawn ();
        myburn.movetype = MOVETYPE_NONE;
        myburn.solid = SOLID_NOT;
        setsize (myburn, '0 0 0', '0 0 0');

        // Wire Player And Flashlight Together
        myburn.owner = self;
        self.burny = myburn;
        
        myburn.classname = "flash";
        
        makevectors (self.v_angle);
        traceline (self.origin , (self.origin) , FALSE , self);
        setorigin (myburn, trace_endpos);
	myburn.alpha = -0.01;

        myburn.think = zbburne;
        myburn.nextthink = time + 0.005;
};



void() bburne =
{
if (self.burn_origin > 10)	
	{
        self.think = SUB_Remove;
        self.nextthink = time + 0.02;
	}

////////////////////////   first stage:

if (self.burn_origin <= 4)	
	{
	pointparticles(particleeffectnum("grimrock_shambler"), self.origin, '0 0 0', 1);
	pointparticles(particleeffectnum("grimrock_shambler1"), self.origin, '0 0 0', 1);
	pointparticles(particleeffectnum("burningshambler"), self.origin, '0 0 0', 1);
	pointparticles(particleeffectnum("burningshambler"), self.origin, '0 0 0', 1);
	makevectors (self.owner.angles);
        traceline (self.owner.origin , (self.owner.origin) , FALSE , self);
        setorigin (self, trace_endpos+(v_up * (-5+ (self.owner.burnz_origin + self.burn_origin) )));
        self.nextthink = time + 0.02;
	self.think = bburne;
	self.burn_origin = self.burn_origin + 0.4;
	}

////////////////////////   second stage added:

if ((self.burn_origin <= 10)&&(self.burn_origin > 4))
	{
	//if (self.burn_origin > 6)	
	//{
	//self.owner.skin = 1;
	//}
	pointparticles(particleeffectnum("grimrock_shambler"), self.origin, '0 0 0', 1);
	pointparticles(particleeffectnum("grimrock_shambler2"), self.origin, '0 0 0', 1);
 	pointparticles(particleeffectnum("burningshambler"), self.origin, '0 0 0', 1);
 	pointparticles(particleeffectnum("burningshambler"), self.origin, '0 0 0', 1);
	makevectors (self.owner.angles);
        traceline (self.owner.origin , (self.owner.origin) , FALSE , self);
        setorigin (self, trace_endpos+(v_up * (-5+ (self.owner.burnz_origin + self.burn_origin) )));
        self.nextthink = time + 0.02;
	self.think = bburne;
	self.burn_origin = self.burn_origin + 0.4;
	}
};



void() burne =
{
        local entity myburn;
        myburn = spawn ();
        myburn.movetype = MOVETYPE_NONE;
        myburn.solid = SOLID_NOT;
        setsize (myburn, '0 0 0', '0 0 0');
        myburn.owner = self;
        self.burny = myburn;
        myburn.classname = "flash";
        self.alpha = 1;
        makevectors (self.v_angle);
        traceline (self.origin , (self.origin) , FALSE , self);
        setorigin (myburn, trace_endpos);
        myburn.think = bburne;
        myburn.nextthink = time + 0.005;
};



void () burn_toggle_shambler =
{
        if (self.burn_flag == FALSE)
        	{       
            self.burn_flag = TRUE;
		burne();
            zburne();
        	}
};


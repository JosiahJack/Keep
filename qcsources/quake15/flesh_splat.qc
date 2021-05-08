float() crandom; //function prototype for crandom
.float ONCEIL;

void()	flesh_remove1	=	[0,		flesh_remove2] {self.scale = 0.7;};
void()	flesh_remove2	=	[0,		flesh_remove3] {self.scale = 0.6;};
void()	flesh_remove3	=	[0,		flesh_remove4] {self.scale = 0.5;};
void()	flesh_remove4	=	[0,		flesh_remove5] {self.scale = 0.4;};
void()	flesh_remove5	=	[0,		flesh_remove6] {self.scale = 0.2;};
void()	flesh_remove6	=	[0,		flesh_remove7] {self.scale = 0.1;};
void()	flesh_remove7	=	[0,		flesh_remove7] {remove(self);};

//SplatThink: Controls behavior of splats after they have hit the wall
void() SplatThink =
{
        if ( (self.attack_finished <= time) ||
             (self.flags & FL_ONGROUND) )
        {
                //remove(self); //remove if: time "runs out" or on ground
                flesh_remove1();
                return;
        }
        if (self.model == "progs/gib_splat.mdl")
		self.traileffectnum = particleeffectnum("gibtr");
	self.velocity_z = random()*-10; //splat slowly slides down walls, changing speed
	if (self.model != "progs/gib_splat.mdl")
		self.angles = vectoangles(self.velocity); //point in direction of movement
	else
		self.angles_z = 0;
        self.solid = SOLID_TRIGGER;
     
       // self.nextthink = time + 0.2;
       self.nextthink = time + 10.2;
};

void() misc_drip;

void() DripThink =
{
	
        if ( (self.attack_finished <= time) ||
             (self.flags & FL_ONGROUND))
        {
                remove(self); //remove if: time "runs out" or on ground
                return;
        }
        self.angles = vectoangles(self.velocity); //point in direction of movement
        self.solid = SOLID_TRIGGER;
       // self.nextthink = time + 0.2;
       self.nextthink = time + 10.2;
       self.ONCEIL = 0;
};

//SplatTouch: Called(by the engine) when splats touch the world or an entity
//after being spawned
void() SplatTouch =
{
	
        if ( (other != world) ||
             (pointcontents(self.origin) <= -3) ||
             (self.flags & FL_ONGROUND) || (pointcontents(self.origin) == CONTENT_SKY))
        {
                remove(self); //remove if: didn't hit wall, in liquid, or on ground
                return;
        }

        self.velocity = self.avelocity = '0 0 0'; //stop moving and spinning
        self.movetype = MOVETYPE_FLY; //changed to remove effect of gravity
        self.touch = SUB_Null; //don't call this (touch) function again
	self.attack_finished = time + 4 + (2*random()); //set random "time limit"
	pointparticles(particleeffectnum("hldecal"), self.origin, '0 0 0', 2); // large blood splatter decal

	if (self.ONCEIL == 0)
	{
		self.traileffectnum = particleeffectnum("gibd");
		self.think = SplatThink;
	}
	else	
	{
		self.traileffectnum = particleeffectnum("gibceil");
		self.think = DripThink;
		
	}
        self.nextthink = time + 0.2;
};

//ThrowBloodSplat: This will create a blood splat at "org", moving in
//direction "dir", and owned by "own"
void(vector dir, vector org, entity own) ThrowBloodSplat =
{
        local entity splat;
        local vector dir;

	if (trace_ent.classname == "ShalrathMissile" || trace_ent.classname == "monster_jim")
		return;
        if ( !((own.flags & FL_MONSTER) ||
               (own.classname == "player")) )
                return; //only monsters and players should create splats!

        splat = spawn();
        splat.owner = own; //move through hit monster/player
        splat.movetype = MOVETYPE_TOSS; //gravity with no bouncing
        splat.solid = SOLID_BBOX; //does not move through other entities (besides owner)
        splat.effects = EF_LOWPRECISION;	//save network performance with low quality coords
	if (self.ONCEIL)
		splat.velocity = dir; //random velocity in direction of shot
	else
	{
		dir = normalize(dir); //make sure "dir" has length 1
		splat.velocity = dir * (1050 + 50*random()); //random velocity in direction of shot
		splat.velocity_x = splat.velocity_x + crandom()*40; //randomize x velocity (+/- 40)
		splat.velocity_y = splat.velocity_y + crandom()*40; //randomize y velocity (+/- 40)
		splat.velocity_z = splat.velocity_z + 120 + 50*random(); //randomize z velocity (+ 120-170)
		splat.avelocity = '3000 1000 2000'; //spin fast!
	}
        splat.touch = SplatTouch;
	
        splat.nextthink = time + 2;
        splat.think = SUB_Remove;
        
        if (self.ONCEIL == 0 && random() < 0.03)
        {
		setmodel (splat,"progs/gib_splat.mdl");
		if (random() < 0.3)
			splat.scale = 0.8;
		//splat.traileffectnum = particleeffectnum("hldecal");
		//splat.angles *= random();
	}
        else
        {
		setmodel (splat, "progs/wallsplat.mdl");
		
		splat.alpha = 0.1;
	}
	splat.traileffectnum = particleeffectnum("gibd");
        //splat.traileffectnum = particleeffectnum("gibnull");
        //setmodel (splat, "progs/wallsplat.mdl");
        splat.alpha = 1;
        setsize (splat, '0 0 0', '0 0 0');     
        setorigin (splat, org); //start splat at point of damage
};


//Throws chunks that stick to ceiling and don't move downwards, produces blood drip particle
/*
void() CeilSplat =
{
	local vector throwdir;
	self.ONCEIL = 1;
	throwdir_x = random(-130,130);
	throwdir_y = random(-130, 130);
	throwdir_z = random( 1360, 1450);

	ThrowBloodSplat(throwdir, self.origin, self);
}*/

float MAX_DRIPS = 12;
float BLD;

void() cs_touch =
{
	if (other != world)
		return;
	
	if (pointcontents(self.origin) == CONTENT_SKY)
	{
			remove(self);
			return;
	}
		
	local float surfacenum;
	local string tex;
	surfacenum = getsurfacenearpoint(world, self.origin);
	if (surfacenum >= 0)
	{
		tex = getsurfacetexture(world, surfacenum);
		if ((tex == "sky1") || (tex == "sky4") || (tex == "sky_base") || (tex == "sky_curse1"))
		{
			remove(self);
			return;
		}
	}
	
	
	sendParticle("hldecal", self.origin, '0 0 100', 2);
	
		
	self.netname = "gibsplat";
	self.movetype = MOVETYPE_NONE;
	self.spawnflags = MISC_DRIPBLOOD;
	BLD++;	//add 1 to the global blood counter (network game optimization)
	self.think = misc_drip;
	self.nextthink = time;
}

void() CeilSplat =
{
	local entity dripper;
	local vector throwdir;
	
	throwdir_x = random(-230,230);
	throwdir_y = random(-230, 230);
	throwdir_z = random(260, 350);
	
	//if ((coop || deathmatch) && (BLD > MAX_DRIPS))
	//	return;
	
	dripper = spawn();
	//setmodel (dripper,"progs/player.mdl");
	
	setorigin(dripper, self.origin);
	
	setsize (dripper, '0 0 0', '0 0 0');  
	
	if (random(100) < 50)
		dripper.wait = 0.1;
	else
		dripper.wait = 0.4;
		
	dripper.gravity = .3;
	
	dripper.velocity = throwdir;
	dripper.movetype = MOVETYPE_FLY;
	//dripper.traileffectnum = particleeffectnum("gibceil");
	dripper.solid = SOLID_TRIGGER;
	dripper.touch = cs_touch;
	//dripper.nextthink = time;
}

//SEVEN's MODIFIED SPLAT CODE

/*
float() crandom; //function prototype for crandom


//SplatThink: Controls behavior of splats after they have hit the wall
void() SplatThink =
{
        if ( (self.attack_finished <= time) ||
             (self.flags & FL_ONGROUND) )
        {
                remove(self); //remove if: time "runs out" or on ground
                return;
        }
        self.velocity_z = random()*-10; //splat slowly slides down walls, changing speed
  //      self.angles = vectoangles(self.velocity); //point in direction of movement  // edited out because the model "gibby" is not volumetric
        self.nextthink = time + 2;
};


//SplatTouch: Called(by the engine) when splats touch the world or an entity
//after being spawned
void() SplatTouch =
{
        if ( (other != world) ||
             (pointcontents(self.origin) <= -3) ||
             (self.flags & FL_ONGROUND) )
        {
                remove(self); //remove if: didn't hit wall, in liquid, or on ground
                return;
        }

        self.velocity = self.avelocity = '0 0 0'; //stop moving and spinning
        self.movetype = MOVETYPE_FLY; //changed to remove effect of gravity
        self.touch = SUB_Null; //don't call this (touch) function again
        self.attack_finished = time + 4 + (2*random()); //set random "time limit"

        self.think = SplatThink;
        self.nextthink = time + 0.1;	// was  1  (reduced it, so that splats on walls slide down without a second wait time)
};


void() SplatEffects =
{
self.think = SUB_Remove;
self.nextthink = time + 10;
self.touch = SplatTouch;

if(random() < 0.4)
return;

self.scale = self.scale + 0.3;

if (self.cnt == 1)
{       self.traileffectnum = particleeffectnum("giba");
}
if (self.cnt == 2)
{       self.traileffectnum = particleeffectnum("gibb");
}
if (self.cnt == 3)
{       self.traileffectnum = particleeffectnum("gibc");
}
if (self.cnt == 4)
{       self.traileffectnum = particleeffectnum("gibd");
}
if (self.cnt == 5)
{       self.traileffectnum = particleeffectnum("gibe");
}
};


//ThrowBloodSplat: This will create a blood splat at "org", moving in
//direction "dir", and owned by "own"
void(vector dir, vector org, entity own, float gibtype, float spikegib) ThrowBloodSplat =
{
        local entity splat;

        if ( !((own.flags & FL_MONSTER) || (own.classname == "player") || (own.i_am_a_corpse == 1)) )
                return; 	//only monsters and players should create splats!
        
        splat = spawn();
        splat.owner = own; //move through hit monster/player
        splat.movetype = MOVETYPE_TOSS; //gravity with no bouncing
        splat.solid = SOLID_BBOX; //does not move through other entities (besides owner)

        dir = normalize(dir); //make sure "dir" has length 1
        splat.cnt = gibtype;
        splat.velocity = dir * (-30 -30*random()); //random velocity in direction of shot
        splat.velocity_x = splat.velocity_x + 20 + crandom()*120;
        splat.velocity_y = splat.velocity_y + 20 + crandom()*120;
        splat.velocity_z = splat.velocity_z + 100 + 40*random(); 

        splat.avelocity = '3000 1000 2000'; //spin fast!
        splat.touch = SplatTouch;
	  splat.scale = 0.1 * (random() * 6) ;	

if (spikegib < 1)
{
	  splat.scale = 0.1 * (random() * 6) ;	
}
if (spikegib >= 1)
{
	  splat.scale = 0.1 * (random() * 8) ;	
}

if (splat.scale > 0.5)
{       
if (splat.cnt == 1)
{splat.colormod =  '0 1 0';}
if (splat.cnt == 2)
{splat.colormod =  '0.8 0 0';}
if (splat.cnt == 3)
{splat.colormod =  '1 0.5 0.1';}
if (splat.cnt == 4)
{splat.colormod =  '1 0 1';}
if (splat.cnt == 5)
{splat.colormod =  '0 0 1';}
 	  splat.nextthink = time;
        splat.think = SplatEffects;
}
else
    {
    splat.nextthink = time + 10;
    splat.think = SUB_Remove;
    splat.colormod =  '0.7 0 0';
    }

 splat.frame = 1 * (random() * 5) ;	
 setmodel (splat,"progs/gibby.mdl");
 setsize (splat, '0 0 0', '0 0 0');     
 setorigin (splat, org); //start splat at point of damage
}; 


*/
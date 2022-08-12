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


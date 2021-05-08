void rain_go(vector v1, vector v2, vector e_size, vector dir,
	float color, float count);

void () rain_use =
{
	dprint(" rain ");

	rain_go(self.mins,self.maxs,self.size,'125 100 0',self.color+random(8),self.counter);
	self.nextthink = time + self.wait;
};

float RAIN_STRAIGHT = 1;

/*QUAKED weather_rain (0 1 1) ? STRAIGHT NO_SPLAT
MG&RL
Rain falls within this entity.
STRAIGHT = Rain will fall straight down rather than at an angle
NO_SPLAT = Rain will not make "splats" on the ground
-------------------------FIELDS-------------------------
color   - palette number of the rain's color - will range between this color and this color + 8 unless monochrome is checked
        default - 414 (translucent blue)
counter - number of rain particles to generate every 10th of a second.
        default - 300
wait    - how often to generate rain particles
        default - .1 of a second
soundtype - 0 = rain (default)
			1 = drip (cave-type- wetness)
--------------------------------------------------------
*/
void rain_splatter ()
{//MG
vector spot1,spot2;
	spot1=self.mins;
	spot1_x+=random(self.size_x);
	spot1_y+=random(self.size_y);
	spot1_z=self.maxs_z;
	spot2=spot1;
	spot2_z=self.mins_z - 10;
	
	traceline(spot1,spot2,FALSE,self);
	if(trace_fraction<1)
	{
//		particle4(trace_endpos,10,random(408,412),PARTICLETYPE_FASTGRAV,random(5,10));
		particle4(trace_endpos,10,random(408,412),PARTICLETYPE_GRAV,random(5,10));
		thinktime self : random(0.01,0.2);
	}
	else
		thinktime self : 0;
}

void make_splatter ()
{
	newmis=spawn();
	setorigin(newmis,self.origin);
	setsize(newmis,self.mins,self.maxs);
	newmis.think=rain_splatter;
	thinktime newmis : 0;
}

void() weather_rain =
{//MG&BL
vector dir;
float splat_count;
	if (!self.soundtype)
	{
		precache_sound2("ambience/rain.wav");
		self.noise1="ambience/rain.wav";
	}
	else
	{
		precache_sound2("ambience/drip1.wav");
		self.noise1 = ("ambience/drip1.wav");
		self.think = sound_again;
		self.nextthink = time + random(5,30);
	}

  	self.movetype = MOVETYPE_NOCLIP;
  	self.owner = self;
  	self.solid = SOLID_NOT;
  	setsize (self, self.mins , self.maxs);
  	setorigin (self, self.origin);
  	setmodel (self, self.model);
   self.modelindex = 0;
  	self.model = "";
	
	if (!self.wait)
	   self.wait=0.10;
	       
	if (!self.color)
		self.color=414;

	if (!self.counter)
		self.counter=300;

	if (self.spawnflags & RAIN_STRAIGHT)
		dir = '0 0 0';
	else
		dir = '125 100 0';

	self.color=414;
	starteffect(CE_RAIN, self.mins, self.maxs, self.size, dir, self.color, self.counter, self.wait);

	if(!self.soundtype)
		ambientsound (self.origin, "ambience/rain.wav",1 , ATTN_NONE);
	else
		sound (self, CHAN_VOICE, self.noise1, 1, ATTN_NORM);

	if(!self.spawnflags&2)
		splat_count=10;
	while(splat_count)
	{
		make_splatter();
		splat_count-=1;
	}
	if(!self.soundtype)
		remove(self);
};

$frame 0 1 2 3 4 5 6 7 

void() skyl_stand1	=[  $0,	skyl_stand2  ]{lightstyle(0,"z");};
void() skyl_stand2	=[  $1,	skyl_stand3  ]{lightstyle(0,"m");};
void() skyl_stand3	=[  $2,	skyl_stand4  ]
{
 sound(self, CHAN_AUTO, "ambience/thunder2.wav", 1,0.01);
};
void() skyl_stand4	=[  $3,	skyl_stand5  ]{lightstyle(0,"m");};
void() skyl_stand5	=[  $4,	skyl_stand6  ]{lightstyle(0,"z");};
void() skyl_stand6	=[  $5,	skyl_stand7  ]{lightstyle(0,"m");};
void() skyl_stand7	=[  $6,	skyl_stand8  ]{lightstyle(0,"z");};
void() skyl_stand8	=[  $7,	skyl_stand1  ]{self.nextthink = time + 15.0;}; //time  lightning appears time + your time

void() model_skylight = 
{
	precache_model ("progs/skylight.spr");
	self.solid = SOLID_BBOX;                               
	self.movetype = MOVETYPE_NONE;

	setmodel (self, "progs/skylight.spr");

	setsize (self, '16 16 16', '24 24 24');
	self.think = skyl_stand1;
	self.nextthink = time + 0.01;

 
};
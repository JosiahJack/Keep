$frame 0 1 2 3  4 5 6 7 8 9 10 11 12 13 14 15 16 17 18
$frame 19 20 21 22 23 24 25 26 27 28 29 30 

void() harm_stand1       =[  0,        harm_stand2  ] {};
void() harm_stand2       =[  0,        harm_stand1  ] {};

void() harm_walk1       =[  0,         harm_walk2  ] 
{
if (random() < 0.2)
 sound (self, CHAN_VOICE, "harmon/crash.wav", 1, ATTN_NORM);
};
void() harm_walk2       =[  1,         harm_walk3  ] {};
void() harm_walk3       =[  2,         harm_walk4  ] {};
void() harm_walk4       =[  3,         harm_walk5  ] {};
void() harm_walk5       =[  4,         harm_walk6  ] {};
void() harm_walk6       =[  5,         harm_walk7  ] {};
void() harm_walk7       =[  6,         harm_walk8  ] {};
void() harm_walk8       =[  7,         harm_walk9  ] {};
void() harm_walk9       =[  8,         harm_walk10 ] {};
void() harm_walk10      =[  9,         harm_walk11 ] {};
void() harm_walk11      =[  10,        harm_walk12 ] {};
void() harm_walk12      =[  11,        harm_walk13 ] {};
void() harm_walk13      =[  12,        harm_walk14 ] {};
void() harm_walk14      =[  13,        harm_walk15 ] {};
void() harm_walk15      =[  14,        harm_walk16 ] {};
void() harm_walk16      =[  15,        harm_walk17 ] {};
void() harm_walk17      =[  16,        harm_walk18 ] {};
void() harm_walk18      =[  17,        harm_walk19 ] {};
void() harm_walk19      =[  18,        harm_walk20 ] {};
void() harm_walk20      =[  19,        harm_walk21 ] {};
void() harm_walk21      =[  20,        harm_walk22 ] {};
void() harm_walk22      =[  21,        harm_walk23 ] {};
void() harm_walk23      =[  22,        harm_walk24 ] {};
void() harm_walk24      =[  23,        harm_walk25 ] {};
void() harm_walk25      =[  24,        harm_walk26 ] {};
void() harm_walk26      =[  25,        harm_walk27 ] {};
void() harm_walk27      =[  26,        harm_walk28 ] {};
void() harm_walk28      =[  27,        harm_walk29 ] {};
void() harm_walk29      =[  28,        harm_walk30 ] {};
void() harm_walk30      =[  29,        harm_walk31 ] {};
void() harm_walk31      =[  30,        harm_walk31 ] {}; 

void() harm_start;
void() harm_toggle_on;
void() harm_toggle_off;

void() harm_start = 
{ 
 
       	local float r;


	if (self.pain_finished > time)
		return;


  	{
                harm_walk1 ();
		self.pain_finished = time + 1;
                self.use = harm_toggle_off;
	}

};

void() harm_toggle_off = 
{ 
 
       	local float r;


	if (self.pain_finished > time)
		return;


  	{
                harm_stand1 ();
//		self.pain_finished = time + 1;
	        self.nextthink = -1;
                self.use = harm_toggle_on;
	}

};

void() harm_toggle_on = 
{ 
 
       	local float r;


	if (self.pain_finished > time)
		return;


  	{
                harm_walk1 ();
//		self.pain_finished = time + 1;
	        self.nextthink = +1;
                self.use = harm_toggle_off;
	}

};


void() info_harmony = 
{
     precache_model ("progs/harmoxide.mdl");
     precache_sound ("harmon/crash.wav");
     self.solid = SOLID_BBOX;                               
     self.movetype = MOVETYPE_NONE;

     setmodel (self, "progs/harmoxide.mdl");

     setsize (self, '-16 -32 -24', '16 32 10');
     self.use = harm_start;
     harm_stand1();

};

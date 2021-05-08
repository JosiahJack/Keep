 //Thunderstorm effects
 /*======================================================================
/*QUAKED light_storm (.5 .5 .5) ? x x x x x x STARTOFF x Not_Easy Not_Normal Not_Hard Not_DM
Point-light based thunderstorm like Hexen 2
-------- KEYS --------
targetname : required to make the flashing work correctly (does not need to be targeted)
light   : radius/brightness value of light flash
wait    : Scale the fade distance of the light by "n"
delay   :Select an attenuation formaula for the light: 
		0 => Linear attenuation (default) 
		1 => 1/x attenuation 
		2 => 1/(x^2) attenuation 
		3 => No attenuation (same brightness at any distance) 
		4 => "local minlight" - No attenuation and like minlight, 
		it won’t raise the lighting above it’s light value. 
		Unlike minlight, it will only affect surfaces within 
		line of sight of the entity. 
		5 => 1/(x^2) attenuation, but slightly more attenuated and 
		without the extra bright effect that "delay 2" has 
		near the source.
-------- SPAWNFLAGS --------
NOSOUND : Does not produce ambient thunder sounds - useful to prevent overlapping sounds from
	  multiple light_storms, or to use ambient_custom_sound to define your own
-------- NOTES --------
Point light that generates thunder sounds and flashes. Ideal placement is in front of skyboxes
or next to windows with sky textures. Requires targetname for light flashes work properly
======================================================================*/
float IS_FLASHING;

float NO_SOUND = 2;
 
void() storm_start;
 
void() storm_reset =
{
	lightstyle(self.style, "a");
	if (self.cnt == 2)
		self.count = 0;
	//global to control sky flash effect	
	IS_FLASHING = 0;
	
	if(!(self.spawnflags & NO_SOUND) && (self.cnt >= 3))
	{
		if (random(100) > 90)
			sound7(self, CHAN_ITEM, "ambience/thunder3.wav", 1, ATTN_NONE, SNDSPD);
		else if (random(100) > 65)
			sound7(self, CHAN_ITEM, "ambience/thunder2.wav", 1, ATTN_NONE, SNDSPD);
		else if (random(100) > 35)
			sound7(self, CHAN_ITEM, "ambience/thunder1.wav", 1, ATTN_NONE, SNDSPD);
	}
		
	self.think = storm_start;
	self.nextthink = time + random(17, 31);

}

void() storm_start =
{
	if (self.cnt >= 1)	
	{
		lightstyle(self.style, "nbn");
		IS_FLASHING = 1;
	}
	self.cnt+=1;
	self.think = storm_reset;
	self.nextthink = time + .7;
		
}	

void() light_storm =
{
	precache_sound("ambience/thunder1.wav");
	precache_sound("ambience/thunder2.wav");
	precache_sound("ambience/thunder3.wav");
	IS_FLASHING = 0;
	self.count = 2;
	self.think = storm_start;
	lightstyle(self.style, "a");
	self.nextthink = time + 6;
}
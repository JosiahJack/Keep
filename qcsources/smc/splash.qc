//  Used for entities with  'entity'.cansplash = TRUE;   
//  For shotgun bullet splash look into "weapons.qc" --> function "W_BulletSplash"

//  -----------------

//  Thanks to Tux for this code. 
//  I only changed it to use pointparticles instead of vanilla qc particles.
//  That made the code much smaller, but of course incompatible with other engines than DarkPlaces.
//  In additon I extended the code to work in slime as well.


void(vector spot, vector splashsize) Splash =	
{
	precache_sound ("player/watersplash.wav");	
	pointsound (spot, "player/watersplash.wav", 0.8, ATTN_NORM);
  	pointparticles(particleeffectnum("watersplash"), spot, '0 0 0', 1);
};	


void(vector spot, vector splashsize) Splash_big =	
{
	precache_sound ("player/watersplash.wav");	
	pointsound (spot, "player/watersplash.wav", 0.8, ATTN_NORM);
  	pointparticles(particleeffectnum("watersplashbig"), spot, '0 0 0', 1);
};	


void(vector spot, vector splashsize) Splash_Lava =	
{
	precache_sound ("ambience/lavasplash.wav");	
	pointsound (spot, "ambience/lavasplash.wav", 0.9, ATTN_NORM);
	pointparticles(particleeffectnum("lavasplash"), spot, '0 0 0', 1);
};	


void(vector spot, vector splashsize) Splash_Lava_big =	
{
	precache_sound ("ambience/lavasplash.wav");	
	pointsound (spot, "ambience/lavasplash.wav", 0.9, ATTN_NORM);
	pointparticles(particleeffectnum("lavasplashbig"), spot, '0 0 0', 1);
};	


void() CheckSplash =
{
	local entity checker;
	local float check;
	checker = findradius(self.origin, 100000);
	while (checker)
	{
		if (checker.cansplash == 1)
		{
			check = pointcontents(checker.origin);
			if ((check == CONTENT_WATER) || (check == CONTENT_SLIME) && (checker.splashy == 1))
			{
				checker.splashy = 0;
				if ((checker.model == "progs/grenade.mdl") || (checker.model == "progs/missile.mdl"))
					Splash_big(checker.origin, checker.velocity);
				else
				{
					Splash(checker.origin, checker.velocity);
					checker.cansplash = 0;
				}	
			}
			if ((check == CONTENT_LAVA) && (checker.splashy == 1))
			{
				checker.splashy = 0;
				if ((checker.model == "progs/grenade.mdl") || (checker.model == "progs/missile.mdl"))
					Splash_Lava_big(checker.origin, checker.velocity);
				else
					Splash_Lava(checker.origin, checker.velocity);
			}
			if (check == CONTENT_EMPTY)
			{
				checker.splashy = 1;
			}
		}

		checker = checker.chain;
	}
};
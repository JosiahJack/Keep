/* -----------------------------------------------------------------

skull animation and effects (for vengeance of the enslaved effect)

Must be included in "progs.src" just before "ogre.qc".
-------------------------------------------------------------------- */


$cd id1/models/skull
$origin 0 0 24
$base base
$skin skin

$frame idle1 idle2 idle3 idle4 idle5 idle6 idle7 idle8 



void() SkullTouch =
{
local float skulldmg;
	if (other.takedamage)
		{
		var float autocvar_vengeancedamage = 0;   	// set cvar 'vengeancedamage' default to 0
		if (autocvar_vengeancedamage == 0)	  		// if 'vengeancedamage' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '0'
			{							// do nothing (no damage)
			sound (self, CHAN_WEAPON, "vengeance/skulltouch.wav", 1, ATTN_NORM);	 // To abort the skull fly-sound. Use same channel !!!!
			}
		else
			{
			skulldmg = rint(0.5 + (2 * random()));  			// chances=  50%: 1 damage /  50%: 2 damage
			T_Damage (other, self, self.owner, skulldmg); 		// if value is NOT "0", player get hurt from this effect !
			sound (self, CHAN_WEAPON, "vengeance/skulltouch.wav", 1, ATTN_NORM);	 // To abort the skull fly-sound. Use same channel !!!!
			}
		}
	else
		{
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_KNIGHTSPIKE);
		WriteCoord (MSG_BROADCAST, self.origin_x);
		WriteCoord (MSG_BROADCAST, self.origin_y);
		WriteCoord (MSG_BROADCAST, self.origin_z);
		sound (self, CHAN_WEAPON, "vengeance/skulltouch.wav", 1, ATTN_NORM);	 // To abort the skull fly-sound. Use same channel !!!!
		}

remove(self);
};



void() SkullHoming =
{
local vector	dir, vtemp, faceplayer1, faceplayer2;
	vtemp = self.enemy.origin + '0 0 16';    			// adjust flight-height of skull
	dir = normalize(vtemp - self.origin);

	faceplayer1 = vectoangles (vtemp - self.origin);	// adjust the skull to always face the player !
	makevectors (faceplayer1);
	faceplayer2 = normalize (v_forward);
	self.angles = vectoangles(faceplayer2);  

	self.frame = self.frame + 1;				// skull animation
	if (self.frame >= 8)
		self.frame = 0;

	self.velocity = dir * 280;		// speed of skull.  Vore: 250;
	self.nextthink = time + 0.2;		// inertia of homing effect.  Vore: 0.2
	self.think = SkullHoming;	
};




void() vengeance_skull_main = 	  	
{
	local	vector dir;
	local	float	dist, flytime;

	dir = normalize((self.enemy.origin + '0 0 10') - self.origin);
	dist = vlen (self.enemy.origin - self.origin);
	flytime = dist * 0.002;
	if (flytime < 0.1)
		flytime = 0.1;

self.glow_color = 75;
self.glow_size = 600;

	sound (self, CHAN_WEAPON, "vengeance/skull.wav", 1, ATTN_NORM);	  

	self.velocity = dir * 50;			//  to set speed for the first 0.2 seconds (Vore: 400)
	self.nextthink = flytime + time;
	self.think = SkullHoming;
	self.touch = SkullTouch;
};




void(vector org) launch_vengeance_skull = 	
{
	local	vector face1, face2;

	newmis = spawn ();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BBOX;

face1 = vectoangles (self.enemy.origin - self.origin);    // to set the correct skull angle (face the player)
makevectors (face1);
face2 = normalize (v_forward);
newmis.angles = vectoangles(face2);

	newmis.traileffectnum = particleeffectnum("EF_STARDUST");
	newmis.touch = SkullTouch; 			
	newmis.classname = "skull_fly";
	newmis.think = vengeance_skull_main;	
	newmis.nextthink = time + 0.01;	
	setmodel (newmis, "progs/skull.mdl");		
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);		
	setorigin (newmis, org);
	newmis.enemy = self.enemy;
};


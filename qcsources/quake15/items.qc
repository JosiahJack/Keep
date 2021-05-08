void() W_SetCurrentAmmo;
/* ALL LIGHTS SHOULD BE 0 1 0 IN COLOR ALL OTHER ITEMS SHOULD
BE .8 .3 .4 IN COLOR */


void () dummyeffectblink1_green_armor;  
void () dummyeffectblink1_yellow_armor;
void () dummyeffectblink1_red_armor;
void () megahealth_heart_movement;
void () g_mage1_effect;

var float autocvar_armorspecialeffect = 1;	// set 'armorspecialeffect' default to "1".   "0"= disabled (no particle effects)   "1" uses the special spinning effect.  "2" uses a standard particle effect

void() SUB_regen =
{
	self.model = self.mdl;		// restore original model
	self.solid = SOLID_TRIGGER;	// allow it to be touched again
	sound (self, CHAN_VOICE, "items/itembk2.wav", 1, ATTN_NORM);	// play respawn sound
	setorigin (self, self.origin);
	
if (autocvar_armorspecialeffect == 1)		// "1" uses the special spinning effect.  Any other value (ex. "0") uses a standard particle effect
{
	if (((self.model == "progs/armor.mdl") || (self.model == "progs/armor1.mdl")) && (self.skin == 0))   // to restart time-related particle effects after respawn for green armor 
	 {
		self.nextthink = time + 0.2;		
		self.think = dummyeffectblink1_green_armor;	
	 }

	if (((self.model == "progs/armor.mdl") || (self.model == "progs/armor1.mdl")) && (self.skin == 1))   // to restart time-related particle effects after respawn for yellow armor
	 {
		self.nextthink = time + 0.2;		
		self.think = dummyeffectblink1_yellow_armor;	
	 }

	if (((self.model == "progs/armor.mdl") || (self.model == "progs/armor1.mdl")) && (self.skin == 2))   // to restart time-related particle effects after respawn for red armor
	 {
		self.nextthink = time + 0.2;		
		self.think = dummyeffectblink1_red_armor;	
	 }
}

	if (self.model == "maps/b_bh100heart.bsp")   // to start megahealth heart effects
	 {
	//	self.origin = self.origin + '12 12 0';	// to compensate the positioning mismatch of heart model
		self.movetype = MOVETYPE_FLY;
		self.scale = 1;
		if (autocvar_darkplaces_build)
			self.traileffectnum = particleeffectnum("megahealth_heart_new");	// use effect for DP builds 20130301 and newer
		else
			self.traileffectnum = particleeffectnum("megahealth_heart_old");	// use effect for DP builds before 20130301
		self.nextthink = time + 0.2;		
		self.think = megahealth_heart_movement;	
	 }
	   
	if (self.model == "maps/b_bh100cross.bsp")   // to set megahealth first-aid-cross effects
	  {
	//	self.origin = self.origin + '12 12 0';	// to compensate the positioning mismatch of cross model
		self.movetype = MOVETYPE_FLY;
		self.scale = 1;
		if (autocvar_darkplaces_build)
			self.traileffectnum = particleeffectnum("megahealth_cross_new");	// use effect for DP builds 20130301 and newer
		else
			self.traileffectnum = particleeffectnum("megahealth_cross_old");	// use effect for DP builds before 20130301
	  }

	if (self.model == "maps/b_bh10custom1.bsp")	// to set new custom health model effects
	  {
	//	self.origin = self.origin + '12 12 0';	// to compensate the positioning mismatch of cross model
		self.movetype = MOVETYPE_FLY;
		self.scale = 1;
		//self.traileffectnum = particleeffectnum("health10custom");
	  }

	if (self.model == "maps/b_bh25custom1.bsp")	// to set new custom health model effects
	  {
	//	self.origin = self.origin + '12 12 0';	// to compensate the positioning mismatch of cross model
		self.movetype = MOVETYPE_FLY;
		self.scale = 1;
		//self.traileffectnum = particleeffectnum("health25custom");
	  }

	if (self.model == "progs/g_mage1.mdl")		// to set new weapon pickup effects
	  {
		self.movetype = MOVETYPE_FLY;
		self.nextthink = time + 0.2;		
		self.think = g_mage1_effect;	
	  }

};



/*QUAKED noclass (0 0 0) (-8 -8 -8) (8 8 8)
prints a warning message when spawned
*/
void() noclass =
{
	dprint ("noclass spawned at");
	dprint (vtos(self.origin));
	dprint ("\n");
	remove (self);
};



/*
============
PlaceItem

plants the object on the floor
============
*/

void() PlaceItem =
{
	local float	oldz;

	self.mdl = self.model;		// so it can be restored on respawn

	self.flags = FL_ITEM;		// make extra wide
	self.solid = SOLID_TRIGGER;
	self.movetype = MOVETYPE_TOSS;	
	self.velocity = '0 0 0';
	self.origin_z = self.origin_z + 6;
	oldz = self.origin_z;
	if (!droptofloor())
	{
		dprint ("Bonus item fell out of level at ");
		dprint (vtos(self.origin));
		dprint ("\n");
		remove(self);
		return;
	}

if (autocvar_armorspecialeffect == 1)		// "1" uses the special spinning effect.  Any other value (ex. "0") uses a standard particle effect
{
	if (((self.model == "progs/armor.mdl") || (self.model == "progs/armor1.mdl")) && (self.skin == 0))   // to start time-related particle effects for green armor
	{
		self.nextthink = time + 0.2;		
		self.think = dummyeffectblink1_green_armor;	
	}

	if (((self.model == "progs/armor.mdl") || (self.model == "progs/armor1.mdl")) && (self.skin == 1))   // to start time-related particle effects for yellow armor
	{
		self.nextthink = time + 0.2;		
		self.think = dummyeffectblink1_yellow_armor;	
	}

	if (((self.model == "progs/armor.mdl") || (self.model == "progs/armor1.mdl")) && (self.skin == 2))   // to start time-related particle effects for red armor
	{
		self.nextthink = time + 0.2;		
		self.think = dummyeffectblink1_red_armor;	
	}
}

if (self.model == "maps/b_bh100heart.bsp")   // to start megahealth heart effects
  {
	self.origin = self.origin + '12 12 0';	// to compensate the positioning mismatch of heart model
	self.movetype = MOVETYPE_FLY;
	self.scale = 1;
	if (autocvar_darkplaces_build)
		self.traileffectnum = particleeffectnum("megahealth_heart_new");	// use effect for DP builds 20130301 and newer
	else
		self.traileffectnum = particleeffectnum("megahealth_heart_old");	// use effect for DP builds before 20130301
	self.nextthink = time + 0.2;		
	self.think = megahealth_heart_movement;	
  }
  
if (self.model == "maps/b_bh100cross.bsp")   // to set megahealth first-aid-cross effects
  {
	self.origin = self.origin + '12 12 0';	// to compensate the positioning mismatch of cross model
	self.movetype = MOVETYPE_FLY;
	self.scale = 1;
	if (autocvar_darkplaces_build)
		self.traileffectnum = particleeffectnum("megahealth_cross_new");	// use effect for DP builds 20130301 and newer
	else
		self.traileffectnum = particleeffectnum("megahealth_cross_old");	// use effect for DP builds before 20130301
  }

if (self.model == "maps/b_bh10custom1.bsp")	// to set new custom health model effects
  {
	self.origin = self.origin + '12 12 0';	// to compensate the positioning mismatch of cross model
	self.movetype = MOVETYPE_FLY;
	self.scale = 1;
	//self.traileffectnum = particleeffectnum("health10custom");
  }

if (self.model == "maps/b_bh25custom1.bsp")	// to set new custom health model effects
  {
	self.origin = self.origin + '12 12 0';	// to compensate the positioning mismatch of cross model
	self.movetype = MOVETYPE_FLY;
	self.scale = 1;
	//self.traileffectnum = particleeffectnum("health25custom");
  }

if (self.model == "progs/g_mage1.mdl")		// to set new weapon pickup effects
  {
	self.origin = self.origin + '0 0 33';	// to compensate the positioning mismatch of model
	self.movetype = MOVETYPE_FLY;
	self.scale = 0.7;
	self.nextthink = time + 0.2;		
	self.think = g_mage1_effect;	
  }


///// Randomly angled ammo + health (if not spinning custom health models) pickups:
if (autocvar_ammo_health_boxes_angle_randomness)
{
	if ((self.model == "maps/b_shell1.bsp")	|| (self.model == "maps/b_shell0.bsp") || (self.model == "maps/b_nail1.bsp") || (self.model == "maps/b_nail0.bsp") || (self.model == "maps/b_rock1.bsp") || (self.model == "maps/b_rock0.bsp") || (self.model == "maps/b_batt1.bsp") || (self.model == "maps/b_batt0.bsp"))
		self.angles_y = self.angles_y + (crandom() * autocvar_ammo_health_boxes_angle_randomness);
	if ((self.model == "maps/b_bh10.bsp") || (self.model == "maps/b_bh25.bsp") || (self.model == "maps/b_bh100.bsp"))
		self.angles_y = self.angles_y + (crandom() * autocvar_ammo_health_boxes_angle_randomness);
}

self.flashtarg = "yes";
};


/*
============
StartItem

Sets the clipping size and plants the object on the floor
============
*/

void() StartItem =
{
	self.nextthink = time + 0.2;	// items start after other solids
	self.think = PlaceItem;
};



/*
=========================================================================

HEALTH BOX

=========================================================================
*/

void() megahealth_heart_movement2 =		// scale the heart smaller
{
if (self.scale > 0.92)
	{
	self.nextthink = time + 0.014;
	self.scale = self.scale - 0.007;    //frametime * 0.5; 
	self.think = megahealth_heart_movement2; 
	}
else
	{
	sound (self, CHAN_WEAPON, "ambience/heartbeat.wav", 1, 3);	
	self.nextthink = time; //0.01;
	self.think = megahealth_heart_movement; 
	}
};


void() megahealth_heart_movement =		// scale the heart bigger
{
if (self.scale < 1.08)
	{
	self.nextthink = time + 0.014;
	self.scale = self.scale + 0.007;   //frametime * 0.5; 	
	self.think = megahealth_heart_movement; 
	}
else
	{
	self.nextthink = time; //0.001;
	self.think = megahealth_heart_movement2; 
	}
};


void() health_touch;

void() health_touch_delay =
{
	self.touch = health_touch;		
};

//
// T_Heal: add health to an entity, limiting health to max_health
// "ignore" will ignore max_health limit
//
float (entity e, entity selv, float ignore) T_Heal =
{
	if (e.health <= 0)
		return 0;
	e.poisoned = 0;		// health packs will stop wizard큦 poisoning the player at once !		
	e.inflamed = 0;		// health packs will stop hellknight큦 projectile burning at once !
	sound (e, 120, "misc/null.wav", 1, ATTN_NORM); 	// stop fire loop sound
	if ((!ignore) && (e.health >= other.max_health))	// player already has 100 health
		return 0;
	selv.healamount = ceil(selv.healamount);

	e.health = e.health + selv.healamount;			// add health crate큦 healamount to players health

	if (autocvar_lossless_health_pickup)
	{
		if ((!ignore) && (e.health >= other.max_health))	// if players health reached >100
		{
			selv.healamount = e.health - other.max_health;	// set new health quantity of crate, because player could not take all !!
			if (selv.healamount == 0)
				selv.crate_is_empty = 1;	
			e.health = other.max_health;			// reset players health to 100
		}
		else if (!ignore)					// players health ist still <100
			selv.crate_is_empty = 1;			// that means, he used up complete health crate !
	}
	else
	{
		if ((!ignore) && (e.health >= other.max_health))
			e.health = other.max_health;
	}
			
	if (e.health > 250)
		e.health = 250;
	return 1;
};

/*QUAKED item_health (.3 .3 1) (0 0 0) (32 32 32) rotten megahealth
Health box. Normally gives 25 points.
Rotten box heals 5-10 points,
megahealth will add 100 health, then 
rot you down to your maximum health limit, 
one point per second.
*/

float	H_ROTTEN = 1;
float	H_MEGA = 2;
// .float healamount;	// moved to defs.qc
.float	healtype;
void() health_touch;
void() item_megahealth_rot;
var float autocvar_health = 1;		// set cvar 'health' default to 1    "1"= use spinning new custom health model set (except megahealth) ONLY in none-base maps !!     "2"= use NOT-spinning new custom health model set (except megahealth) ONLY in none-base maps !!    
var float autocvar_megahealth = 1;	// set cvar 'megahealth' default to 1  (used for new custom megahealth model effects)   "0"= use original megahealth in every world   "1"= use original megahealth ONLY in "base" worlds, use new animated heart model in every other world-type   "2"= use new animated heart model in every world-type   "3"= use new first-aid-cross model in every world-type  "4"= use new first-aid-cross model ONLY in "base" worlds and use new animated heart model in every other world

void() item_health =
{	
	self.touch = health_touch;

	if (self.spawnflags & H_ROTTEN)
	{
		if (autocvar_health)		// use original health models ONLY in "base" worlds, use new health model set in every other world
		{
			if (world.worldtype == 2)	// base map
			{
				precache_model("maps/b_bh10.bsp");
				setmodel(self, "maps/b_bh10.bsp");
				precache_sound("items/r_item1.wav");
				self.noise = "items/r_item1.wav";
			}
			else
			{
				precache_model("maps/b_bh10custom1.bsp");
				setmodel(self, "maps/b_bh10custom1.bsp");
				precache_sound("items/r_item1_potion_small.wav");	// precache custom sound for small potion
				self.noise = "items/r_item1_potion_small.wav";
				self.traileffectnum = particleeffectnum("health_small");
				//if (autocvar_health == 2)
				//	self.effects = EF_NOMODELFLAGS;
			}
		}
		else
		{
			precache_model("maps/b_bh10.bsp");
			setmodel(self, "maps/b_bh10.bsp");
			precache_sound("items/r_item1.wav");
			self.noise = "items/r_item1.wav";
		}
		self.healamount = autocvar_medikit_small_health;	// default 15
		self.healtype = 0;
		//self.traileffectnum = particleeffectnum("health_small");	
	}
	else
	if (self.spawnflags & H_MEGA)
	{
		if (autocvar_megahealth == 1)			// use original megahealth ONLY in "base" worlds, use new megahealth heart model in every other world
		{
			if (world.worldtype == 2)	// base map
			{
				precache_model("maps/b_bh100.bsp");
				setmodel(self, "maps/b_bh100.bsp");
				precache_sound("items/r_item2.wav");
				self.noise = "items/r_item2.wav";
			}
			else
			{
				precache_model("maps/b_bh100heart.bsp");
				setmodel(self, "maps/b_bh100heart.bsp");
				precache_sound("ambience/heartbeat.wav");		// precache heartbeat sound
				precache_sound("items/r_item2_heart_pickup.wav");	// precache custom sound for heart pickup
				self.noise = "items/r_item2_heart_pickup.wav";
			}
		}
		else if (autocvar_megahealth == 2)		// use new megahealth heart in every world
		{
			precache_model("maps/b_bh100heart.bsp");
			setmodel(self, "maps/b_bh100heart.bsp");
			precache_sound("ambience/heartbeat.wav");		// precache heartbeat sound
			precache_sound("items/r_item2_heart_pickup.wav");	// precache custom sound for heart pickup
			self.noise = "items/r_item2_heart_pickup.wav";
		}
		else if (autocvar_megahealth == 3)		// use new megahealth first-aid-cross model in every world
		{
			precache_model("maps/b_bh100cross.bsp");
			setmodel(self, "maps/b_bh100cross.bsp");
			precache_sound("items/r_item2.wav");
			self.noise = "items/r_item2.wav";
		}
		else if (autocvar_megahealth == 4)		// use new megahealth first-aid-cross model ONLY in "base" worlds, use new megahealth heart model in every other world
		{
			if (world.worldtype == 2)	// base map
			{
				precache_model("maps/b_bh100cross.bsp");
				setmodel(self, "maps/b_bh100cross.bsp");
				precache_sound("items/r_item2.wav");
				self.noise = "items/r_item2.wav";
			}
			else
			{
				precache_model("maps/b_bh100heart.bsp");
				setmodel(self, "maps/b_bh100heart.bsp");
				precache_sound("ambience/heartbeat.wav");		// precache heartbeat sound
				precache_sound("items/r_item2_heart_pickup.wav");	// precache custom sound for heart pickup
				self.noise = "items/r_item2_heart_pickup.wav";
			}
		}
		else							// if cvar 'megahealth' has any other value (exapmle "0") use original megahealth in every world
		{
			precache_model("maps/b_bh100.bsp");
			setmodel(self, "maps/b_bh100.bsp");
			precache_sound("items/r_item2.wav");
			self.noise = "items/r_item2.wav";
		}
		self.healamount = autocvar_medikit_mega_health;		// default 100
		self.healtype = 2;
		self.traileffectnum = particleeffectnum("health_mega");	
	}
	else
	{
		if (autocvar_health)		// use original health models ONLY in "base" worlds, use new health model set1 in every other world
		{
			if (world.worldtype == 2)	// base map
			{
				precache_model("maps/b_bh25.bsp");
				setmodel(self, "maps/b_bh25.bsp");
				precache_sound("items/health1.wav");
				self.noise = "items/health1.wav";
			}
			else
			{
				precache_model("maps/b_bh25custom1.bsp");
				setmodel(self, "maps/b_bh25custom1.bsp");
				precache_sound("items/health1_potion_medium.wav");	// precache custom sound for medium potion
				self.noise = "items/health1_potion_medium.wav";
				self.traileffectnum = particleeffectnum("health_medium");
				//if (autocvar_health == 2)
				//	self.effects = EF_NOMODELFLAGS;
			}
		}
		else
		{
			precache_model("maps/b_bh25.bsp");
			setmodel(self, "maps/b_bh25.bsp");
			precache_sound("items/health1.wav");
			self.noise = "items/health1.wav";
		}
		self.healamount = autocvar_medikit_large_health;	// default 25
		self.healtype = 1;
		//self.traileffectnum = particleeffectnum("health_medium");	
	}
	self.initial_amount = self.healamount;
	setsize (self, '0 0 0', '32 32 56');
	StartItem ();
};


void() health_touch =
{
//	local	float amount;
	local	string	s;
	
	if (other.classname != "player")
		return;
	
	self.healamount_old = self.healamount;		// detect the current health amount of crate (to be able to do calculations later on)

	if (self.healtype == 2) // Megahealth?  Ignore max_health...
	{
		if (coop && autocvar_coop_life_pool == 1)//give all coop players a life
		{
			LIFE_BONUS = PLR_CNT-1;
			self.lives +=1;
			centerprint(other, "Life Bonus! ^2+1 lives ^8to all players");
		}
		if (other.health >= 250)
			return;
		if (!T_Heal(other, self, 1))		// changed to T_Heal(entity, entity, float) to be able to use crates .floats inside T_Heal
			return;
	}
	else
	{
		if (!T_Heal(other, self, 0))		// changed to T_Heal(entity, entity, float) to be able to use crates .floats inside T_Heal
			return;
	}

	if (autocvar_lossless_health_pickup)
	{
		sprint (other, "You received ");			// rewritten notification message code, to exactly calculate how many health points the player really received, and
		if ((!self.crate_is_empty) && (self.healtype != 2))	// if the crate is not completely used up, tell him.
			s = ftos(self.healamount_old - self.healamount);
		else
			s = ftos(self.healamount_old);
		sprint (other, s);
		sprint (other, " health");
		if ((!self.crate_is_empty) && (self.healtype != 2))
		{
			sprint (other, ". Max health reached. ");
			s = ftos(self.healamount);
			sprint (other, s);
			sprint (other, " health remaining.");
		}
		sprint (other, "\n");
	}
	else
	{
		sprint(other, "You receive ");
		s = ftos(self.healamount);
		sprint(other, s);
		sprint(other, " health\n");
	}
	
// health touch sound
	sound(other, CHAN_ITEM, self.noise, 1, ATTN_NORM);

	stuffcmd (other, "bf\n");

	if (autocvar_lossless_health_pickup)
	{
		if ((self.crate_is_empty == 1) || (self.healtype == 2))		// crate is emtpy or was Megahealth (which shall not be usable multiple times)
		{								// so reset original values and remove model
			self.crate_is_empty = 0;			// reset (to be usable in deathmatch again)
			self.healamount = self.initial_amount;		// reset (to be usable in deathmatch again)

			if (world.worldtype != 2)	// none-base maps
			{
				if (self.healtype == 0 && autocvar_health) 		// health10 custom model
					pointparticles(particleeffectnum("health10custom_touch"), self.origin, '0 0 0', 1); 
				else if (self.healtype == 1 && autocvar_health) 	// health25 custom model
					pointparticles(particleeffectnum("health25custom_touch"), self.origin, '0 0 0', 1); 
			}

			self.model = string_null;
			self.solid = SOLID_NOT;

			// Megahealth = rot down the player's super health
			if (self.healtype == 2)
			{
				//other.items = other.items | IT_SUPERHEALTH;
				self.nextthink = time + 5;
				self.think = item_megahealth_rot;
				self.owner = other;
			}
			else
			{
				if (deathmatch != 2)		// deathmatch 2 is the silly old rules
				{
					if (deathmatch)
						self.nextthink = time + 20;
					self.think = SUB_regen;
				}
			}
	
			activator = other;
			SUB_UseTargets();				// fire all targets / killtargets
		}
		else		// crate is not yet emtpy (Megahealth shall not be usable multiple times !!), so leave model in game until it is fully used up.
		{
			self.touch = SUB_Null;		//  to avoid overflows
			self.nextthink = time + 1;	//  delay next pickup of this crate, in case player stands inside it and gets injured
			self.think = health_touch_delay;
		}
	}
	else
	{
		if (world.worldtype != 2)	// none-base maps
		{
			if (self.healtype == 0 && autocvar_health) 		// health10 custom model
				pointparticles(particleeffectnum("health10custom_touch"), self.origin, '0 0 0', 1); 
			else if (self.healtype == 1 && autocvar_health) 	// health25 custom model
				pointparticles(particleeffectnum("health25custom_touch"), self.origin, '0 0 0', 1); 
		}
		
		self.model = string_null;
		self.solid = SOLID_NOT;

		// Megahealth = rot down the player's super health
		if (self.healtype == 2)
		{
			//other.items = other.items | IT_SUPERHEALTH;
			self.nextthink = time + 5;
			self.think = item_megahealth_rot;
			self.owner = other;
		}
		else
		{
			if (deathmatch != 2)		// deathmatch 2 is the silly old rules
			{
				if (deathmatch)
					self.nextthink = time + 20;
				self.think = SUB_regen;
			}
		}
	
		activator = other;
		SUB_UseTargets();				// fire all targets / killtargets
	}
};	

void() item_megahealth_rot =
{
	other = self.owner;
	
	if (other.health > other.max_health)
	{
		other.health = other.health - 1;
		self.nextthink = time + 1;
		return;
	}

// it is possible for a player to die and respawn between rots, so don't
// just blindly subtract the flag off
	//other.items = other.items - (other.items & IT_SUPERHEALTH);
	
	if (deathmatch == 1)	// deathmatch 2 is silly old rules
	{
		self.nextthink = time + 20;
		self.think = SUB_regen;
	}
};

/*
===============================================================================

ARMOR

===============================================================================
*/


var float autocvar_armor_model = 0; 	// set cvar 'armor_model' default to 0    "0"= always use regular armor model (armor.mdl)   "1"= use regular armor model (armor.mdl) ONLY in "base" worlds, use alternative armor model (armor1.mdl) in every other world type     "2"= like "1" and in addition: also use different HUD icons for regular armor model (armor.mdl --> gfx/sb_armor1 until gfx/sb_armor3) and alternative armor model (armor1.mdl --> gfx/sb_armor11 until gfx/sb_armor33). ATTENTION: Custom csqc HUD needed !
void() armor_touch;

void() armor_touch =
{
	local	float	type, value, bit;
	
	if (other.health <= 0)
		return;
	if (other.classname != "player")
		return;

	if (self.classname == "item_armor1")
	{
		type = 0.3;
		value = autocvar_armor_green;		// default 100
		bit = IT_ARMOR1;
	}
	if (self.classname == "item_armor2")
	{
		type = 0.6;
		value = autocvar_armor_yellow;		// default 150
		bit = IT_ARMOR2;
	}
	if (self.classname == "item_armorInv")
	{
		type = 0.8;
		value = autocvar_armor_red;		// default 200
		bit = IT_ARMOR3;
	}
	if (other.armortype*other.armorvalue >= type*value)
		return;
		
	other.armortype = type;
	other.armorvalue = value;
	other.items = other.items - (other.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3)) + bit;

	self.solid = SOLID_NOT;
	self.model = string_null;
	if (deathmatch == 1)
		self.nextthink = time + 20;
	if (deathmatch)		// added  (related to time-dependend effects)
		self.think = SUB_regen;

	sprint(other, "You got armor\n");
// armor touch sound
	sound(other, CHAN_ITEM, "items/armor1.wav", 1, ATTN_NORM);
	stuffcmd (other, "bf\n");
	
	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};


/*QUAKED item_armor1 (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() dummyeffectblink20_green_armor =		// created for green armor effect 
{
self.traileffectnum = particleeffectnum("armor_green_20");
self.nextthink = time + 0.12;		// adjust your frequence time here
self.think = dummyeffectblink1_green_armor;	
};

void() dummyeffectblink19_green_armor =		// created for green armor effect 
{
self.traileffectnum = particleeffectnum("armor_green_19");
self.nextthink = time + 0.12;		// adjust your frequence time here
self.think = dummyeffectblink20_green_armor;	
};

void() dummyeffectblink18_green_armor =		// created for green armor effect
{
self.traileffectnum = particleeffectnum("armor_green_18");
self.nextthink = time + 0.12;		// adjust your frequence time here
self.think = dummyeffectblink19_green_armor;	
};

void() dummyeffectblink17_green_armor =		// created for green armor effect 
{
self.traileffectnum = particleeffectnum("armor_green_17");
self.nextthink = time + 0.12;		// adjust your frequence time here
self.think = dummyeffectblink18_green_armor;	
};

void() dummyeffectblink16_green_armor =		// created for green armor effect 
{
self.traileffectnum = particleeffectnum("armor_green_16");
self.nextthink = time + 0.12;		// adjust your frequence time here
self.think = dummyeffectblink17_green_armor;	
};

void() dummyeffectblink15_green_armor =		// created for green armor effect 
{
self.traileffectnum = particleeffectnum("armor_green_15");
self.nextthink = time + 0.12;		// adjust your frequence time here
self.think = dummyeffectblink16_green_armor;	
};

void() dummyeffectblink14_green_armor =		// created for green armor effect 
{
self.traileffectnum = particleeffectnum("armor_green_14");
self.nextthink = time + 0.12;		// adjust your frequence time here
self.think = dummyeffectblink15_green_armor;	
};

void() dummyeffectblink13_green_armor =		// created for green armor effect 
{
self.traileffectnum = particleeffectnum("armor_green_13");
self.nextthink = time + 0.12;		// adjust your frequence time here
self.think = dummyeffectblink14_green_armor;	
};

void() dummyeffectblink12_green_armor =		// created for green armor effect
{
self.traileffectnum = particleeffectnum("armor_green_12");
self.nextthink = time + 0.12;		// adjust your frequence time here
self.think = dummyeffectblink13_green_armor;	
};

void() dummyeffectblink11_green_armor =		// created for green armor effect
{
self.traileffectnum = particleeffectnum("armor_green_11");
self.nextthink = time + 0.12;		// adjust your frequence time here
self.think = dummyeffectblink12_green_armor;	
};

void() dummyeffectblink10_green_armor =		// created for green armor effect
{
self.traileffectnum = particleeffectnum("armor_green_10");
self.nextthink = time + 0.12;		// adjust your frequence time here
self.think = dummyeffectblink11_green_armor;	
};

void() dummyeffectblink9_green_armor =		// created for green armor effect
{
self.traileffectnum = particleeffectnum("armor_green_9");
self.nextthink = time + 0.12;		// adjust your frequence time here
self.think = dummyeffectblink10_green_armor;	
};

void() dummyeffectblink8_green_armor =		// created for green armor effect
{
self.traileffectnum = particleeffectnum("armor_green_8");
self.nextthink = time + 0.12;		// adjust your frequence time here
self.think = dummyeffectblink9_green_armor;	
};

void() dummyeffectblink7_green_armor =		// created for green armor effect
{
self.traileffectnum = particleeffectnum("armor_green_7");
self.nextthink = time + 0.12;		// adjust your frequence time here
self.think = dummyeffectblink8_green_armor;	
};

void() dummyeffectblink6_green_armor =		// created for green armor effect
{
self.traileffectnum = particleeffectnum("armor_green_6");
self.nextthink = time + 0.12;		// adjust your frequence time here
self.think = dummyeffectblink7_green_armor;	
};

void() dummyeffectblink5_green_armor =		// created for green armor effect
{
self.traileffectnum = particleeffectnum("armor_green_5");
self.nextthink = time + 0.12;		// adjust your frequence time here
self.think = dummyeffectblink6_green_armor;	
};

void() dummyeffectblink4_green_armor =		// created for green armor effect
{
self.traileffectnum = particleeffectnum("armor_green_4");
self.nextthink = time + 0.12;		// adjust your frequence time here
self.think = dummyeffectblink5_green_armor;	
};

void() dummyeffectblink3_green_armor =		// created for green armor effect
{
self.traileffectnum = particleeffectnum("armor_green_3");
self.nextthink = time + 0.12;		// adjust your frequence time here
self.think = dummyeffectblink4_green_armor;	
};

void() dummyeffectblink2_green_armor =		// created for green armor effect
{
self.traileffectnum = particleeffectnum("armor_green_2");
self.nextthink = time + 0.12;		// adjust your frequence time here
self.think = dummyeffectblink3_green_armor;	
};

void() dummyeffectblink1_green_armor =		// created for green armor effect
{
self.traileffectnum = particleeffectnum("armor_green_1");
self.nextthink = time + 0.12;		// adjust your frequence time here
self.think = dummyeffectblink2_green_armor;	
};



void() item_armor1 =
{
	self.touch = armor_touch;

	if (autocvar_armor_model)		// use regular armor models (armor.mdl) ONLY in "base" worlds, use alternative armor model (armor1.mdl) in every other world
	{
		if (world.worldtype == 2)	// base map
		{
			precache_model ("progs/armor.mdl");
			setmodel (self, "progs/armor.mdl");
		}
		else
		{
			precache_model ("progs/armor1.mdl");
			setmodel (self, "progs/armor1.mdl");
		}
	}
	else
	{
		precache_model ("progs/armor.mdl");
		setmodel (self, "progs/armor.mdl");
	}

	if (autocvar_armorspecialeffect == 2)		// "1" uses the special spinning effect.  "2" uses a standard particle effect
		self.traileffectnum = particleeffectnum("green_armor");   // standard particle effect

	self.skin = 0;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};


/*QUAKED item_armor2 (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() dummyeffectblink20_yellow_armor =		// created for yellow armor effect
{
self.traileffectnum = particleeffectnum("armor_yellow_20");
self.nextthink = time + 0.12;		// adjust your frequence time here
self.think = dummyeffectblink1_yellow_armor;	
};

void() dummyeffectblink19_yellow_armor =		// created for yellow armor effect
{
self.traileffectnum = particleeffectnum("armor_yellow_19");
self.nextthink = time + 0.12;		// adjust your frequence time here
self.think = dummyeffectblink20_yellow_armor;	
};

void() dummyeffectblink18_yellow_armor =		// created for yellow armor effect
{
self.traileffectnum = particleeffectnum("armor_yellow_18");
self.nextthink = time + 0.12;		// adjust your frequence time here
self.think = dummyeffectblink19_yellow_armor;	
};

void() dummyeffectblink17_yellow_armor =		// created for yellow armor effect
{
self.traileffectnum = particleeffectnum("armor_yellow_17");
self.nextthink = time + 0.12;		// adjust your frequence time here
self.think = dummyeffectblink18_yellow_armor;	
};

void() dummyeffectblink16_yellow_armor =		// created for yellow armor effect
{
self.traileffectnum = particleeffectnum("armor_yellow_16");
self.nextthink = time + 0.12;		// adjust your frequence time here
self.think = dummyeffectblink17_yellow_armor;	
};

void() dummyeffectblink15_yellow_armor =		// created for yellow armor effect
{
self.traileffectnum = particleeffectnum("armor_yellow_15");
self.nextthink = time + 0.12;		// adjust your frequence time here
self.think = dummyeffectblink16_yellow_armor;	
};

void() dummyeffectblink14_yellow_armor =		// created for yellow armor effect
{
self.traileffectnum = particleeffectnum("armor_yellow_14");
self.nextthink = time + 0.12;		// adjust your frequence time here
self.think = dummyeffectblink15_yellow_armor;	
};

void() dummyeffectblink13_yellow_armor =		// created for yellow armor effect
{
self.traileffectnum = particleeffectnum("armor_yellow_13");
self.nextthink = time + 0.12;		// adjust your frequence time here
self.think = dummyeffectblink14_yellow_armor;	
};

void() dummyeffectblink12_yellow_armor =		// created for yellow armor effect
{
self.traileffectnum = particleeffectnum("armor_yellow_12");
self.nextthink = time + 0.12;		// adjust your frequence time here
self.think = dummyeffectblink13_yellow_armor;	
};

void() dummyeffectblink11_yellow_armor =		// created for yellow armor effect
{
self.traileffectnum = particleeffectnum("armor_yellow_11");
self.nextthink = time + 0.12;		// adjust your frequence time here
self.think = dummyeffectblink12_yellow_armor;	
};

void() dummyeffectblink10_yellow_armor =		// created for yellow armor effect
{
self.traileffectnum = particleeffectnum("armor_yellow_10");
self.nextthink = time + 0.12;		// adjust your frequence time here
self.think = dummyeffectblink11_yellow_armor;	
};

void() dummyeffectblink9_yellow_armor =		// created for yellow armor effect
{
self.traileffectnum = particleeffectnum("armor_yellow_9");
self.nextthink = time + 0.12;		// adjust your frequence time here
self.think = dummyeffectblink10_yellow_armor;	
};

void() dummyeffectblink8_yellow_armor =		// created for yellow armor effect
{
self.traileffectnum = particleeffectnum("armor_yellow_8");
self.nextthink = time + 0.12;		// adjust your frequence time here
self.think = dummyeffectblink9_yellow_armor;	
};

void() dummyeffectblink7_yellow_armor =		// created for yellow armor effect
{
self.traileffectnum = particleeffectnum("armor_yellow_7");
self.nextthink = time + 0.12;		// adjust your frequence time here
self.think = dummyeffectblink8_yellow_armor;	
};

void() dummyeffectblink6_yellow_armor =		// created for yellow armor effect
{
self.traileffectnum = particleeffectnum("armor_yellow_6");
self.nextthink = time + 0.12;		// adjust your frequence time here
self.think = dummyeffectblink7_yellow_armor;	
};

void() dummyeffectblink5_yellow_armor =		// created for yellow armor effect
{
self.traileffectnum = particleeffectnum("armor_yellow_5");
self.nextthink = time + 0.12;		// adjust your frequence time here
self.think = dummyeffectblink6_yellow_armor;	
};

void() dummyeffectblink4_yellow_armor =		// created for yellow armor effect
{
self.traileffectnum = particleeffectnum("armor_yellow_4");
self.nextthink = time + 0.12;		// adjust your frequence time here
self.think = dummyeffectblink5_yellow_armor;	
};

void() dummyeffectblink3_yellow_armor =		// created for yellow armor effect
{
self.traileffectnum = particleeffectnum("armor_yellow_3");
self.nextthink = time + 0.12;		// adjust your frequence time here
self.think = dummyeffectblink4_yellow_armor;	
};

void() dummyeffectblink2_yellow_armor =		// created for yellow armor effect
{
self.traileffectnum = particleeffectnum("armor_yellow_2");
self.nextthink = time + 0.12;		// adjust your frequence time here
self.think = dummyeffectblink3_yellow_armor;	
};

void() dummyeffectblink1_yellow_armor =		// created for yellow armor effect
{
self.traileffectnum = particleeffectnum("armor_yellow_1");
self.nextthink = time + 0.12;		// adjust your frequence time here
self.think = dummyeffectblink2_yellow_armor;	
};


void() item_armor2 =
{
	self.touch = armor_touch;
	
	if (autocvar_armor_model)		// use regular armor models (armor.mdl) ONLY in "base" worlds, use alternative armor model (armor1.mdl) in every other world
	{
		if (world.worldtype == 2)	// base map
		{
			precache_model ("progs/armor.mdl");
			setmodel (self, "progs/armor.mdl");
		}
		else
		{
			precache_model ("progs/armor1.mdl");
			setmodel (self, "progs/armor1.mdl");
		}
	}
	else
	{
		precache_model ("progs/armor.mdl");
		setmodel (self, "progs/armor.mdl");
	}

	if (autocvar_armorspecialeffect == 2)		// "1" uses the special spinning effect.  "2" uses a standard particle effect
		self.traileffectnum = particleeffectnum("yellow_armor");   // standard particle effect

	self.skin = 1;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};


/*QUAKED item_armorInv (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() dummyeffectblink20_red_armor =		// created for red armor effect
{
self.traileffectnum = particleeffectnum("armor_red_20");
self.nextthink = time + 0.12;		// adjust your frequence time here
self.think = dummyeffectblink1_red_armor;	
};

void() dummyeffectblink19_red_armor =		// created for red armor effect
{
self.traileffectnum = particleeffectnum("armor_red_19");
self.nextthink = time + 0.12;		// adjust your frequence time here
self.think = dummyeffectblink20_red_armor;	
};

void() dummyeffectblink18_red_armor =		// created for red armor effect
{
self.traileffectnum = particleeffectnum("armor_red_18");
self.nextthink = time + 0.12;		// adjust your frequence time here
self.think = dummyeffectblink19_red_armor;	
};

void() dummyeffectblink17_red_armor =		// created for red armor effect
{
self.traileffectnum = particleeffectnum("armor_red_17");
self.nextthink = time + 0.12;		// adjust your frequence time here
self.think = dummyeffectblink18_red_armor;	
};

void() dummyeffectblink16_red_armor =		// created for red armor effect
{
self.traileffectnum = particleeffectnum("armor_red_16");
self.nextthink = time + 0.12;		// adjust your frequence time here
self.think = dummyeffectblink17_red_armor;	
};

void() dummyeffectblink15_red_armor =		// created for red armor effect
{
self.traileffectnum = particleeffectnum("armor_red_15");
self.nextthink = time + 0.12;		// adjust your frequence time here
self.think = dummyeffectblink16_red_armor;	
};

void() dummyeffectblink14_red_armor =		// created for red armor effect
{
self.traileffectnum = particleeffectnum("armor_red_14");
self.nextthink = time + 0.12;		// adjust your frequence time here
self.think = dummyeffectblink15_red_armor;	
};

void() dummyeffectblink13_red_armor =		// created for red armor effect
{
self.traileffectnum = particleeffectnum("armor_red_13");
self.nextthink = time + 0.12;		// adjust your frequence time here
self.think = dummyeffectblink14_red_armor;	
};

void() dummyeffectblink12_red_armor =		// created for red armor effect
{
self.traileffectnum = particleeffectnum("armor_red_12");
self.nextthink = time + 0.12;		// adjust your frequence time here
self.think = dummyeffectblink13_red_armor;	
};

void() dummyeffectblink11_red_armor =		// created for red armor effect
{
self.traileffectnum = particleeffectnum("armor_red_11");
self.nextthink = time + 0.12;		// adjust your frequence time here
self.think = dummyeffectblink12_red_armor;	
};

void() dummyeffectblink10_red_armor =		// created for red armor effect
{
self.traileffectnum = particleeffectnum("armor_red_10");
self.nextthink = time + 0.12;		// adjust your frequence time here
self.think = dummyeffectblink11_red_armor;	
};

void() dummyeffectblink9_red_armor =		// created for red armor effect
{
self.traileffectnum = particleeffectnum("armor_red_9");
self.nextthink = time + 0.12;		// adjust your frequence time here
self.think = dummyeffectblink10_red_armor;	
};

void() dummyeffectblink8_red_armor =		// created for red armor effect
{
self.traileffectnum = particleeffectnum("armor_red_8");
self.nextthink = time + 0.12;		// adjust your frequence time here
self.think = dummyeffectblink9_red_armor;	
};

void() dummyeffectblink7_red_armor =		// created for red armor effect
{
self.traileffectnum = particleeffectnum("armor_red_7");
self.nextthink = time + 0.12;		// adjust your frequence time here
self.think = dummyeffectblink8_red_armor;	
};

void() dummyeffectblink6_red_armor =		// created for red armor effect
{
self.traileffectnum = particleeffectnum("armor_red_6");
self.nextthink = time + 0.12;		// adjust your frequence time here
self.think = dummyeffectblink7_red_armor;	
};

void() dummyeffectblink5_red_armor =		// created for red armor effect
{
self.traileffectnum = particleeffectnum("armor_red_5");
self.nextthink = time + 0.12;		// adjust your frequence time here
self.think = dummyeffectblink6_red_armor;	
};

void() dummyeffectblink4_red_armor =		// created for red armor effect
{
self.traileffectnum = particleeffectnum("armor_red_4");
self.nextthink = time + 0.12;		// adjust your frequence time here
self.think = dummyeffectblink5_red_armor;	
};

void() dummyeffectblink3_red_armor =		// created for red armor effect
{
self.traileffectnum = particleeffectnum("armor_red_3");
self.nextthink = time + 0.12;		// adjust your frequence time here
self.think = dummyeffectblink4_red_armor;	
};

void() dummyeffectblink2_red_armor =		// created for red armor effect
{
self.traileffectnum = particleeffectnum("armor_red_2");
self.nextthink = time + 0.12;		// adjust your frequence time here
self.think = dummyeffectblink3_red_armor;	
};

void() dummyeffectblink1_red_armor =		// created for red armor effect
{
self.traileffectnum = particleeffectnum("armor_red_1");
self.nextthink = time + 0.12;		// adjust your frequence time here
self.think = dummyeffectblink2_red_armor;	
};


void() packTouch =
{
	local entity	stemp;

	if (other.health <= 0)
		return;
	if (other.classname != "player")
		return;
	if (random() > 0.7)
	{
		other.grenade_ammo+=5;
		other.ammo_shells+=15;
		other.ammo_nails+=25;
		other.ammo_rockets+=12;
		other.ammo_cells+=20;
		sprint(other, "You got a supply pack with 5 proximity hand grenades and ammo\n");
		
		// pack touch sound
		sound (other, CHAN_ITEM, "misc/backpack_ammo.wav", 1, ATTN_NORM);
	}
	else
	{
		other.grenade_ammo+=3;
		other.ammo_shells+=10;
		other.ammo_nails+=15;
		other.ammo_rockets+=6;
		other.ammo_cells+=15;
		
		//armor
		other.armortype = 0.6;
		other.armorvalue += 30;
		other.items = other.items - (other.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3)) + IT_ARMOR2;
		
		sprint(other, "You got a supply pack with 3 proximity hand grenades, ammo, and 30 yellow armor shards\n");
		
		// pack touch sound
		sound (other, CHAN_ITEM, "misc/backpack_armour.wav", 1, ATTN_NORM);
	}
		
	stuffcmd (other, "bf\n");
	
	stemp = self;
	self = other;
	W_SetCurrentAmmo();
	self = stemp;
	
	
	
	self.model = string_null;
	self.solid = SOLID_NOT;
	if (deathmatch == 1)
		self.nextthink = time + 30;
	self.think = SUB_regen;

	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
	
	//remove(self);
	
}

void() item_backpack =
{
	self.touch = packTouch;
	
	precache_model ("progs/backpack.mdl");
	setmodel (self, "progs/backpack.mdl");
	
	precache_sound ("misc/backpack_armour.wav");  
	precache_sound ("misc/backpack_ammo.wav");  

	//self.skin = 2;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};

void() item_armorInv =
{
	if ((autocvar_redarmor_backpack == 1) && random()< 0.2)
	{
		item_backpack();
		return;
	}
	self.touch = armor_touch;
	
	if (autocvar_armor_model)		// use regular armor models (armor.mdl) ONLY in "base" worlds, use alternative armor model (armor1.mdl) in every other world
	{
		if (world.worldtype == 2)	// base map
		{
			precache_model ("progs/armor.mdl");
			setmodel (self, "progs/armor.mdl");
		}
		else
		{
			precache_model ("progs/armor1.mdl");
			setmodel (self, "progs/armor1.mdl");
		}
	}
	else
	{
		precache_model ("progs/armor.mdl");
		setmodel (self, "progs/armor.mdl");
	}

	if (autocvar_armorspecialeffect == 2)		// "1" uses the special spinning effect.  "2" uses a standard particle effect
		self.traileffectnum = particleeffectnum("red_armor");   // standard particle effect

	self.skin = 2;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};



/*
===============================================================================

WEAPONS

===============================================================================
*/

void() bound_other_ammo =
{
	if (other.ammo_shells > autocvar_shells_max_capacity)		// default 100)
		other.ammo_shells = autocvar_shells_max_capacity;
	if (other.ammo_nails > autocvar_nails_max_capacity)		// default 200
		other.ammo_nails = autocvar_nails_max_capacity;
	if (other.ammo_rockets > autocvar_rockets_max_capacity)		// default 100)
		other.ammo_rockets = autocvar_rockets_max_capacity;		
	if (other.ammo_cells > autocvar_cells_max_capacity)		// default 100)
		other.ammo_cells = autocvar_cells_max_capacity;		
	if (other.grenade_ammo > 15)
		other.grenade_ammo = 15;
};


float(float w) RankForWeapon =
{
	if (w == IT_LIGHTNING)
		return 1;
	if (w == IT_ROCKET_LAUNCHER)
		return 2;
	if (w == IT_LASER_CANNON)
		return 3;
	if (w == IT_SUPER_NAILGUN)
		return 3;
	if (w == IT_GRENADE_LAUNCHER)
		return 4;
	if (w == IT_SUPER_SHOTGUN)
		return 5;
	if (w == IT_NAILGUN)
		return 6;
	if (w == IT_CHAINSAW)
		return 6;
	return 7;
};

/*
=============
Deathmatch_Weapon

Deathmatch weapon change rules for picking up a weapon

.float		ammo_shells, ammo_nails, ammo_rockets, ammo_cells;
=============
*/
void(float old, float new) Deathmatch_Weapon =
{
	local float or, nr;

// change self.weapon if desired
	or = RankForWeapon (self.weapon);
	nr = RankForWeapon (new);
	if ( nr < or )
		self.weapon = new;
};

/*
=============
weapon_touch
=============
*/
float() W_BestWeapon;

void() weapon_touch =
{
	local	float	hadammo, best, new, old;
	local	entity	stemp;
	local	float	leave;

	if (!(other.flags & FL_CLIENT))
		return;

// if the player was using his best weapon, change up to the new one if better		
	stemp = self;
	self = other;
	best = W_BestWeapon();
	self = stemp;

	if (deathmatch == 2 || coop)
		leave = 1;
	else
		leave = 0;
	
	if (self.classname == "weapon_nailgun")
	{
		if (leave && (other.items & IT_NAILGUN) )
			return;
		hadammo = other.ammo_nails;
		new = IT_NAILGUN;
		other.ammo_nails = other.ammo_nails + 30;
	}
	else if (self.classname == "weapon_supernailgun")
	{
		if (leave && (other.items & IT_SUPER_NAILGUN) )
			return;
		hadammo = other.ammo_rockets;	
		new = IT_SUPER_NAILGUN;
		other.ammo_nails = other.ammo_nails + 30;
	}
	else if (self.classname == "weapon_supershotgun")
	{
		if (leave && (other.items & IT_SUPER_SHOTGUN) )
			return;
		hadammo = other.ammo_rockets;	
		new = IT_SUPER_SHOTGUN;
		other.ammo_shells = other.ammo_shells + 5;
	}
	else if (self.classname == "weapon_rocketlauncher")
	{
		if (leave && (other.items & IT_ROCKET_LAUNCHER) )
			return;
		hadammo = other.ammo_rockets;		
		new = IT_ROCKET_LAUNCHER;
		other.ammo_rockets = other.ammo_rockets + 5;
	}
	else if (self.classname == "weapon_grenadelauncher")
	{
		if (leave && (other.items & IT_GRENADE_LAUNCHER) )
			return;
		hadammo = other.ammo_rockets;		
		new = IT_GRENADE_LAUNCHER;
		other.ammo_rockets = other.ammo_rockets + 5;
	}
	else if (self.classname == "weapon_lightning")
	{
		if (leave && (other.items & IT_LIGHTNING) )
			return;
		hadammo = other.ammo_rockets;			
		new = IT_LIGHTNING;
		other.ammo_cells = other.ammo_cells + 15;
	}
	else if (self.classname == "weapon_chainsaw")
	{
		if (leave && (other.items & IT_CHAINSAW) )
			return;
		hadammo = other.ammo_rockets;			
		new = IT_CHAINSAW;
	}
	else if (self.classname == "weapon_laser_gun")
	{
	if (leave && (other.items & IT_LASER_CANNON) )
			return;
		hadammo = other.ammo_rockets;
		new = IT_LASER_CANNON;
		other.ammo_cells = other.ammo_cells + 30;
	}
	/*else if (self.classname == "weapon_proximity_gun")
	{
		if (leave && (other.items & IT2_PROXIMITY_GUN) )
			return;
		hadammo = other.ammo_rockets;
		new = IT2_PROXIMITY_GUN;
		other.ammo_rockets = other.ammo_rockets + 6;
	}*/
	else
		objerror ("weapon_touch: unknown classname");

	sprint (other, "You got the ");
	sprint (other, self.netname);
	sprint (other, "\n");
// weapon touch sound
	if (self.model == "progs/g_mage1.mdl")
		sound (other, CHAN_ITEM, "weapons/g_mage1.wav", 1, ATTN_NORM);
	else
		sound (other, CHAN_ITEM, "weapons/pkup.wav", 1, ATTN_NORM);
	stuffcmd (other, "bf\n");

	bound_other_ammo ();

// change to the weapon
	old = other.items;
	other.items = other.items | new;
	
	stemp = self;
	self = other;

	var float autocvar_weaponautoswitch = 1;	// "0"= never autoswitch to the picked up weapon   "1"= standard Quake  
	if ( autocvar_weaponautoswitch == 0 )	// "2"= only autoswitch to the picked up weapon if its better (order= like deathmatch) 
	{							// "3"= only autoswitch to the picked up weapon if its new   
		if (deathmatch)
			Deathmatch_Weapon (old, new);
	}
	else if ( autocvar_weaponautoswitch == 2 )	
	{						
		if (coop)				// singleplayer is now handled like Deathmatch. Only coop is different.
			self.weapon = new;
		else
			Deathmatch_Weapon (old, new);
	}
	else if ( autocvar_weaponautoswitch == 3 )
	{
		if (!(old & new))
		{
			if (!deathmatch)
				self.weapon = new;
			else
				Deathmatch_Weapon (old, new);
		}
	}
	else
	{
		if (!deathmatch)
			self.weapon = new;
		else
			Deathmatch_Weapon (old, new);
	}


	W_SetCurrentAmmo();

	self = stemp;

	if (leave)
		return;

// remove it in single player, or setup for respawning in deathmatch
	if (self.model == "progs/g_mage1.mdl")
		self.vanish = 1;
	self.model = string_null;
	self.solid = SOLID_NOT;
	if (deathmatch == 1)
		self.nextthink = time + 30;
	if (self.vanish != 1)
		self.think = SUB_regen;
	else if (deathmatch || coop)
		self.think = SUB_regen;
		
	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};


/*QUAKED weapon_supershotgun (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() weapon_supershotgun =
{
	if (autocvar_qc_ssg == 0)
	{
		precache_model ("progs/g_shot.mdl");
		setmodel (self, "progs/g_shot.mdl");
	}
	else
	{
		precache_model ("progs/QC/g_shot.mdl");
		setmodel (self, "progs/QC/g_shot.mdl");
	}

self.traileffectnum = particleeffectnum("g_weaponeffect");		//////////////  adds particle effect to g_weapons (customize the effect in your effectinfo.txt)

	self.weapon = IT_SUPER_SHOTGUN;
	self.netname = "Double-barrelled Shotgun";
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};

/*QUAKED weapon_nailgun (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() weapon_nailgun =
{
	if (self.dmg == 1)
	   {
	   	if (self.health == 1)
	   	{
	   		precache_model ("progs/g_sawdrop.mdl");
			setmodel (self, "progs/g_sawdrop.mdl");

		}
		else
		{
			precache_model ("progs/g_saw.mdl");
			setmodel (self, "progs/g_saw.mdl");
		}
		self.weapon = 3;
		self.classname = "weapon_chainsaw";
		self.netname = "Chainsaw";
		self.touch = weapon_touch;
		setsize (self, '-16 -16 0', '16 16 56');
		StartItem ();
	   }
	else
	{
		precache_model ("progs/g_nail.mdl");
		setmodel (self, "progs/g_nail.mdl");

		self.traileffectnum = particleeffectnum("g_weaponeffect");		//////////////  adds particle effect to g_weapons (customize the effect in your effectinfo.txt)

		self.weapon = IT_NAILGUN;
		self.netname = "nailgun";
		self.touch = weapon_touch;
		setsize (self, '-16 -16 0', '16 16 56');
		StartItem ();
	}
};

/*QUAKED weapon_supernailgun (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() weapon_supernailgun =
{
	if (self.dmg == 1)
	{

		precache_model ("progs/g_prox.mdl");
		setmodel (self, "progs/g_prox.mdl");
		self.weapon = 3;
		self.classname = "weapon_proximity_gun";
		self.netname = "Proximity Gun";
		self.touch = weapon_touch;
		setsize (self, '-16 -16 0', '16 16 56');
		StartItem ();
	   
	}
	else
	{
		precache_model ("progs/g_nail2.mdl");
		setmodel (self, "progs/g_nail2.mdl");

		self.traileffectnum = particleeffectnum("g_weaponeffect");		//////////////  adds particle effect to g_weapons (customize the effect in your effectinfo.txt)

		self.weapon = IT_SUPER_NAILGUN;
		self.netname = "Super Nailgun";
		self.touch = weapon_touch;
		setsize (self, '-16 -16 0', '16 16 56');
		StartItem ();
	}
};

/*QUAKED weapon_grenadelauncher (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() weapon_grenadelauncher =
{
	precache_model ("progs/g_rock.mdl");
	setmodel (self, "progs/g_rock.mdl");

self.traileffectnum = particleeffectnum("g_weaponeffect");		//////////////  adds particle effect to g_weapons (customize the effect in your effectinfo.txt)

	self.weapon = 3;
	self.netname = "Grenade Launcher";
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};

/*QUAKED weapon_rocketlauncher (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() weapon_rocketlauncher =
{
	precache_model ("progs/g_rock2.mdl");
	setmodel (self, "progs/g_rock2.mdl");

self.traileffectnum = particleeffectnum("g_weaponeffect");		//////////////  adds particle effect to g_weapons (customize the effect in your effectinfo.txt)

	self.weapon = 3;
	self.netname = "Rocket Launcher";
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};


/*QUAKED weapon_lightning (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void () g_mage1_effect =
{
	self.frame = self.frame + 1;
	if (self.frame > 7)
		self.frame = 0;
	self.nextthink = time + 0.15;
	self.think = g_mage1_effect;
};

void() weapon_lightning =
{
	if (self.dmg == 1)
	   {
	   	//if (self.health == 1)
	   	//{
	   	//	precache_model ("progs/g_sawdrop.mdl");
		//	setmodel (self, "progs/g_sawdrop.mdl");

		//}
		//else
		//{
			precache_model ("progs/g_laserg.mdl");
			setmodel (self, "progs/g_laserg.mdl");
		//}
		self.weapon = 3;
		self.classname = "weapon_laser_gun";
		self.netname = "LaserGun";
		self.touch = weapon_touch;
		setsize (self, '-16 -16 6', '16 16 56');
		//StartItem ();
	   }
	else
	{
		if (autocvar_mage_weapon)
		{
			precache_model ("progs/g_mage1.mdl");
			setmodel (self, "progs/g_mage1.mdl");
			precache_sound("weapons/g_mage1.wav");
			self.netname = "Arc of Death";
		}
		else
		{
			precache_model ("progs/g_light.mdl");
			setmodel (self, "progs/g_light.mdl");
			self.traileffectnum = particleeffectnum("g_weaponeffect");		//////////////  adds particle effect to g_weapons (customize the effect in your effectinfo.txt)
			self.netname = "Thunderbolt";
		}

		self.weapon = 3;
		self.touch = weapon_touch;
		setsize (self, '-16 -16 0', '16 16 56');
	}
	StartItem ();
};

void() weapon_chainsaw =
{
	precache_model ("progs/g_saw.mdl");
	setmodel (self, "progs/g_saw.mdl");
	self.weapon = 3;
	self.netname = "Chainsaw";
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
	dprint("ERROR: change to weapon_nailgun with 'dmg' '1'\n");
};

//HIP Weapon

void() weapon_laser_gun =
{
   precache_model ("progs/g_laserg.mdl");
   setmodel (self, "progs/g_laserg.mdl");
	self.weapon = 3;
   self.netname = "Laser Cannon";
   self.items = IT_LASER_CANNON;
   self.touch = weapon_touch;
	if (self.health == 1)
		setsize (self, '-16 -16 10', '16 16 56');
	else
		setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};

void() prox_touch
{
	local	string	s;
	
	if (other.classname != "player")
		return;
		
	if (self.health == 5)
		other.grenade_ammo += 2;
	else
		other.grenade_ammo += 6;
	bound_other_ammo();
	sprint(other, "You have ");
	s = ftos(other.grenade_ammo);
	sprint(other, s);
	sprint(other, " proximity grenades\n");
	stuffcmd (other, "bf\n");
	sound (other, CHAN_ITEM, "weapons/grenarm.wav", 1, ATTN_NORM);
	
	
	remove(self);
}

void() weapon_proximity_gun =
{
	precache_model ("progs/g_prox.mdl");
	setmodel (self, "progs/g_prox.mdl");
	self.weapon = 3;
	self.classname = "weapon_proximity_gun";
	self.netname = "Proximity Gun";
	self.touch = prox_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
	dprint("ERROR: change to weapon_supernailgun with 'dmg' '1'\n");
};
/*
void() weapon_proximity_gun =
{
   precache_model ("progs/g_prox.mdl");
   setmodel (self, "progs/g_prox.mdl");
	self.weapon = 3;
   self.netname = "Proximity Gun";
   self.items = IT2_PROXIMITY_GUN;
   self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};
*/


/*
===============================================================================

AMMO

===============================================================================
*/

void() ammo_touch;

void() ammo_touch_delay =
{
	self.touch = ammo_touch;		
};

void() ammo_touch =
{
local entity	stemp;
local float	best;
local string	s;

	if (other.classname != "player")
		return;
	if (other.health <= 0)
		return;
		


// if the player was using his best weapon, change up to the new one if better		
	stemp = self;
	self = other;
	best = W_BestWeapon();
	self = stemp;

	self.aflag_old = self.aflag;		// detect the current ammo amount of crate (to be able to do calculations later on)

// shells
	if (self.weapon == 1)
	{
		if (other.ammo_shells >= autocvar_shells_max_capacity)		// default 100
			return;
		other.ammo_shells = other.ammo_shells + self.aflag;
		if (autocvar_lossless_ammo_pickup)
		{
			if (other.ammo_shells > autocvar_shells_max_capacity)
				self.aflag = other.ammo_shells - autocvar_shells_max_capacity;	// set new ammo quantity of crate, because player could not take all !!
			else
				self.crate_is_empty = 1;					// player used up complete amount in crate !!
		}
	}

// nails
	if (self.weapon == 2)
	{
		if (other.ammo_nails >= autocvar_nails_max_capacity)		// default 200
			return;
		other.ammo_nails = other.ammo_nails + self.aflag;
		if (autocvar_lossless_ammo_pickup)
		{
			if (other.ammo_nails > autocvar_nails_max_capacity)
				self.aflag = other.ammo_nails - autocvar_nails_max_capacity;	// set new ammo quantity of crate, because player could not take all !!
			else
				self.crate_is_empty = 1;					// player used up complete amount in crate !!
		}
	}

// rockets
	if (self.weapon == 3)
	{
		if (other.ammo_rockets >= autocvar_rockets_max_capacity)	// default 100
			return;
		other.ammo_rockets = other.ammo_rockets + self.aflag;
		if (autocvar_lossless_ammo_pickup)
		{
			if (other.ammo_rockets > autocvar_rockets_max_capacity)
				self.aflag = other.ammo_rockets - autocvar_rockets_max_capacity; // set new ammo quantity of crate, because player could not take all !!
			else
				self.crate_is_empty = 1;					// player used up complete amount in crate !!
		}
	}

// cells
	if (self.weapon == 4)
	{
		if (other.ammo_cells >= autocvar_cells_max_capacity)		// default 100
			return;
		other.ammo_cells = other.ammo_cells + self.aflag;
		if (autocvar_lossless_ammo_pickup)
		{
			if (other.ammo_cells > autocvar_cells_max_capacity)
				self.aflag = other.ammo_cells - autocvar_cells_max_capacity;	// set new ammo quantity of crate, because player could not take all !!
			else
				self.crate_is_empty = 1;					// player used up complete amount in crate !!
		}
	}

	bound_other_ammo ();

	if (autocvar_lossless_ammo_pickup)
	{
		sprint (other, "You got ");		// rewritten notification message code, to exactly calculate how many ammo the player really received, and
		if (!self.crate_is_empty)		// if the crate is not completely used up, tell him.
			s = ftos(self.aflag_old - self.aflag);
		else
			s = ftos(self.aflag_old);
		sprint (other, s);
		sprint (other, " ");
		sprint (other, self.netname);
		if (!self.crate_is_empty)
		{
			sprint (other, ". Max capacity reached. ");
			s = ftos(self.aflag);
			sprint (other, s);
			sprint (other, " ");
			sprint (other, self.netname);
			sprint (other, " remaining.");
		}
	}
	else
	{
		sprint (other, "You got the ");
		sprint (other, self.netname);
	}
	sprint (other, "\n");

// ammo touch sound
	sound (other, CHAN_ITEM, "weapons/lock4.wav", 1, ATTN_NORM);
	stuffcmd (other, "bf\n");

// change to a better weapon if appropriate

	if ( other.weapon == best )
	{
		stemp = self;
		self = other;
		self.weapon = W_BestWeapon();
		W_SetCurrentAmmo ();
		self = stemp;
	}

// if changed current ammo, update it
	stemp = self;
	self = other;
	W_SetCurrentAmmo();
	self = stemp;

// remove it in single player, or setup for respawning in deathmatch

	if (autocvar_lossless_ammo_pickup)
	{
		if (self.crate_is_empty == 1)			// player used up complete amount in crate 
		{	
			self.crate_is_empty = 0;		// reset (to be usable in deathmatch again)
			self.aflag = self.initial_amount;	// reset (to be usable in deathmatch again)
			self.model = string_null;
			self.solid = SOLID_NOT;
			if (deathmatch == 1)
				self.nextthink = time + 30;
			self.think = SUB_regen;

			activator = other;
			SUB_UseTargets();				// fire all targets / killtargets
		}
		else		// crate is not yet emtpy, so leave model in game until it is fully used up.
		{
			self.touch = SUB_Null;		//  to avoid overflows
			self.nextthink = time + 1;	//  delay next pickup of this crate, in case player stands inside it and fires a weapon that uses this ammo
			self.think = ammo_touch_delay;
		}
	}
	else
	{
		self.model = string_null;
		self.solid = SOLID_NOT;
		if (deathmatch == 1)
			self.nextthink = time + 30;
		self.think = SUB_regen;

		activator = other;
		SUB_UseTargets();				// fire all targets / killtargets
	}
};




float WEAPON_BIG2 = 1;

/*QUAKED item_shells (0 .5 .8) (0 0 0) (32 32 32) big
*/

void() item_shells =
{
	self.touch = ammo_touch;

	if (self.spawnflags & WEAPON_BIG2)
	{
		precache_model ("maps/b_shell1.bsp");
		setmodel (self, "maps/b_shell1.bsp");
		self.aflag = autocvar_shells_big;		// default 40
		self.traileffectnum = particleeffectnum("shells_ammo_big");	
	}
	else
	{
		precache_model ("maps/b_shell0.bsp");
		setmodel (self, "maps/b_shell0.bsp");
		self.aflag = autocvar_shells_small;		// default 20
		self.traileffectnum = particleeffectnum("shells_ammo_small");	
	}
	self.initial_amount = self.aflag;
	self.weapon = 1;
	self.netname = "shells";
	setsize (self, '0 0 0', '32 32 56');
	StartItem ();
};

/*QUAKED item_spikes (0 .5 .8) (0 0 0) (32 32 32) big
*/

void() item_spikes =
{
	self.touch = ammo_touch;

	if (self.spawnflags & WEAPON_BIG2)
	{
		precache_model ("maps/b_nail1.bsp");
		setmodel (self, "maps/b_nail1.bsp");
		self.aflag = autocvar_nails_big;		// default 50
		self.traileffectnum = particleeffectnum("nails_ammo_big");	
	}
	else
	{
		precache_model ("maps/b_nail0.bsp");
		setmodel (self, "maps/b_nail0.bsp");
		self.aflag = autocvar_nails_small;		// default 25
		self.traileffectnum = particleeffectnum("nails_ammo_small");	
	}
	self.initial_amount = self.aflag;
	self.weapon = 2;
	self.netname = "nails";
	setsize (self, '0 0 0', '32 32 56');
	StartItem ();
};

/*QUAKED item_rockets (0 .5 .8) (0 0 0) (32 32 32) big
*/

void() item_rockets =
{
	self.touch = ammo_touch;

	if (self.spawnflags & WEAPON_BIG2)
	{
		precache_model ("maps/b_rock1.bsp");
		setmodel (self, "maps/b_rock1.bsp");
		self.aflag = autocvar_rockets_big;		// default 10
		self.traileffectnum = particleeffectnum("rockets_ammo_big");	
	}
	else
	{
		precache_model ("maps/b_rock0.bsp");
		setmodel (self, "maps/b_rock0.bsp");
		self.aflag = autocvar_rockets_small;		// default 5
		self.traileffectnum = particleeffectnum("rockets_ammo_small");	
	}
	self.initial_amount = self.aflag;
	self.weapon = 3;
	self.netname = "rockets";
	setsize (self, '0 0 0', '32 32 56');
	StartItem ();
};


/*QUAKED item_cells (0 .5 .8) (0 0 0) (32 32 32) big
*/

void() item_cells =
{
	self.touch = ammo_touch;

	if (self.spawnflags & WEAPON_BIG2)
	{
		precache_model ("maps/b_batt1.bsp");
		setmodel (self, "maps/b_batt1.bsp");
		self.aflag = autocvar_cells_big;		// default 12
		self.traileffectnum = particleeffectnum("cells_ammo_big");	
	}
	else
	{
		precache_model ("maps/b_batt0.bsp");
		setmodel (self, "maps/b_batt0.bsp");
		self.aflag = autocvar_cells_small;		// default 6
		self.traileffectnum = particleeffectnum("cells_ammo_small");	
	}
	self.initial_amount = self.aflag;
	self.weapon = 4;
	self.netname = "cells";
	setsize (self, '0 0 0', '32 32 56');
	StartItem ();
};


/*QUAKED item_weapon (0 .5 .8) (0 0 0) (32 32 32) shotgun rocket spikes big
DO NOT USE THIS!!!! IT WILL BE REMOVED!
*/

float WEAPON_SHOTGUN = 1;
float WEAPON_ROCKET = 2;
float WEAPON_SPIKES = 4;
float WEAPON_BIG = 8;
void() item_weapon =
{
	self.touch = ammo_touch;

	if (self.spawnflags & WEAPON_SHOTGUN)
	{
		if (self.spawnflags & WEAPON_BIG)
		{
			precache_model ("maps/b_shell1.bsp");
			setmodel (self, "maps/b_shell1.bsp");
			self.aflag = 40;
		}
		else
		{
			precache_model ("maps/b_shell0.bsp");
			setmodel (self, "maps/b_shell0.bsp");
			self.aflag = 20;
		}
		self.weapon = 1;
		self.netname = "shells";
	}

	if (self.spawnflags & WEAPON_SPIKES)
	{
		if (self.spawnflags & WEAPON_BIG)
		{
			precache_model ("maps/b_nail1.bsp");
			setmodel (self, "maps/b_nail1.bsp");
			self.aflag = 40;
		}
		else
		{
			precache_model ("maps/b_nail0.bsp");
			setmodel (self, "maps/b_nail0.bsp");
			self.aflag = 20;
		}
		self.weapon = 2;
		self.netname = "spikes";
	}

	if (self.spawnflags & WEAPON_ROCKET)
	{
		if (self.spawnflags & WEAPON_BIG)
		{
			precache_model ("maps/b_rock1.bsp");
			setmodel (self, "maps/b_rock1.bsp");
			self.aflag = 10;
		}
		else
		{
			precache_model ("maps/b_rock0.bsp");
			setmodel (self, "maps/b_rock0.bsp");
			self.aflag = 5;
		}
		self.weapon = 3;
		self.netname = "rockets";
	}
	
	setsize (self, '0 0 0', '32 32 56');
	StartItem ();
};


/*
===============================================================================

KEYS

===============================================================================
*/

var float autocvar_key_icon = 0		// set cvar 'key_icon' default to 0 (= disabled)   "1"= enable custom HUD key icons:    For worldtype medieval = "0"  key model: w_s_key.mdl --> gfx/sb_key10.tga  and  w_g_key.mdl --> gfx/sb_key20.tga.     For worldtype metal = "1"  key model: m_s_key.mdl --> gfx/sb_key11.tga  and  m_g_key.mdl --> gfx/sb_key21.tga.    For worldtype base = "2"  key model: b_s_key.mdl --> gfx/sb_key12.tga  and  b_g_key.mdl --> gfx/sb_key22.tga		ATTENTION: Custom csqc HUD needed !
 
void() key_touch =
{
	if (other.classname != "player")
		return;
	if (other.health <= 0)
		return;
	if (other.items & self.items)
		return;
		
	if (!coop && !deathmatch && autocvar_auto_save)
	{
		stuffcmd(other, "Echo Checkpoint...\n");
		//stuffcmd(other, strcat("save autosaves_",world.model,".sav\n"));
		stuffcmd(other, "save autosaves/autosave\n");
	}

	sprint (other, "You got the ");
	sprint (other, self.netname);
	sprint (other,"\n");

	sound (other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
	stuffcmd (other, "bf\n");
	other.items = other.items | self.items;

	if (!coop)
	{	
		self.solid = SOLID_NOT;
		self.model = string_null;
	}

	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};


void() key_setsounds =
{
	if (world.worldtype == 0)
	{
		precache_sound ("misc/medkey.wav");
		self.noise = "misc/medkey.wav";
	}
	if (world.worldtype == 1)
	{
		precache_sound ("misc/runekey.wav");
		self.noise = "misc/runekey.wav";
	}
	if (world.worldtype == 2)
	{
		precache_sound2 ("misc/basekey.wav");
		self.noise = "misc/basekey.wav";
	}
};

/*QUAKED item_key1 (0 .5 .8) (-16 -16 -24) (16 16 32)
SILVER key
In order for keys to work
you MUST set your maps
worldtype to one of the
following:
0: medieval
1: metal
2: base
*/

void() item_key1 =
{
	/*if (CTF_ENABLED)
	{
		item_flagblue();
		return;
	}*/

	if (world.worldtype == 0)
	{
		precache_model ("progs/w_s_key.mdl");
		setmodel (self, "progs/w_s_key.mdl");
		self.netname = "silver key";
self.traileffectnum = particleeffectnum("silver_key");	
	}
	else if (world.worldtype == 1)
	{
		precache_model ("progs/m_s_key.mdl");
		setmodel (self, "progs/m_s_key.mdl");
		self.netname = "silver runekey";
self.traileffectnum = particleeffectnum("silver_rune_key");
	}
	else if (world.worldtype == 2)
	{
		precache_model2 ("progs/b_s_key.mdl");
		setmodel (self, "progs/b_s_key.mdl");
		self.netname = "silver keycard";
self.traileffectnum = particleeffectnum("silver_key_card");
	}
	

	key_setsounds();
	self.touch = key_touch;
	self.items = IT_KEY1;
	setsize (self, '-16 -16 -24', '16 16 32');
	StartItem ();
};

/*QUAKED item_key2 (0 .5 .8) (-16 -16 -24) (16 16 32)
GOLD key
In order for keys to work
you MUST set your maps
worldtype to one of the
following:
0: medieval
1: metal
2: base
*/

void() item_key2 =
{
	/*if (CTF_ENABLED)
	{
		item_flagred();
		return;
	}*/
	if (world.worldtype == 0)
	{
		precache_model ("progs/w_g_key.mdl");
		setmodel (self, "progs/w_g_key.mdl");
		self.netname = "gold key";
self.traileffectnum = particleeffectnum("gold_key");
	}
	if (world.worldtype == 1)
	{
		precache_model ("progs/m_g_key.mdl");
		setmodel (self, "progs/m_g_key.mdl");
		self.netname = "gold runekey";
self.traileffectnum = particleeffectnum("gold_rune_key");
	}
	if (world.worldtype == 2)
	{
		precache_model2 ("progs/b_g_key.mdl");
		setmodel (self, "progs/b_g_key.mdl");
		self.netname = "gold keycard";
self.traileffectnum = particleeffectnum("gold_key_card");
	}


	key_setsounds();
	self.touch = key_touch;
	self.items = IT_KEY2;
	setsize (self, '-16 -16 -24', '16 16 32');
	StartItem ();
};



/*
===============================================================================

END OF LEVEL RUNES

===============================================================================
*/

void() sigil_touch =
{
	if (other.classname != "player")
		return;
	if (other.health <= 0)
		return;

	centerprint (other, "You got the rune!");

	sound (other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
	stuffcmd (other, "bf\n");
	self.solid = SOLID_NOT;
	self.model = string_null;
	serverflags = serverflags | (self.spawnflags & 15);
	self.classname = "";		// so rune doors won't find it
	
	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};


/*QUAKED item_sigil (0 .5 .8) (-16 -16 -24) (16 16 32) E1 E2 E3 E4
End of level sigil, pick up to end episode and return to jrstart.
*/

void() item_sigil =
{
	if (!self.spawnflags)
		objerror ("no spawnflags");

	precache_sound ("misc/runekey.wav");
	self.noise = "misc/runekey.wav";

	if (self.spawnflags & 1)
	{
		precache_model ("progs/end1.mdl");
		setmodel (self, "progs/end1.mdl");
	}
	if (self.spawnflags & 2)
	{
		precache_model2 ("progs/end2.mdl");
		setmodel (self, "progs/end2.mdl");
	}
	if (self.spawnflags & 4)
	{
		precache_model2 ("progs/end3.mdl");
		setmodel (self, "progs/end3.mdl");
	}
	if (self.spawnflags & 8)
	{
		precache_model2 ("progs/end4.mdl");
		setmodel (self, "progs/end4.mdl");
	}

self.traileffectnum = particleeffectnum("rune");		//////////////  adds particle effect to runes (customize the effect in your effectinfo.txt)
	
	self.touch = sigil_touch;
	setsize (self, '-16 -16 -24', '16 16 32');
	StartItem ();
};

/*
===============================================================================

POWERUPS

===============================================================================
*/

//void() powerup_touch;

void() SpawnRebreather;
void() item_artifact_timerune;

void() powerup_touch =
{
	if (other.classname != "player")
		return;
	if (other.health <= 0)
		return;

	sprint (other, "You got the ");
	sprint (other, self.netname);
	sprint (other,"\n");

	if (deathmatch)
	{
		self.mdl = self.model;
		
		if ((self.classname == "item_artifact_invulnerability") ||
			(self.classname == "item_artifact_invisibility"))
			self.nextthink = time + 60*5;
		else
			self.nextthink = time + 60;
		
		self.think = SUB_regen;
	}	

	sound (other, CHAN_VOICE, self.noise, 1, ATTN_NORM);
	stuffcmd (other, "bf\n");
	self.solid = SOLID_NOT;
	other.items = other.items | self.items;
	self.model = string_null;

// do the apropriate action
	if (self.classname == "item_artifact_envirosuit")
	{
		other.rad_time = 1;
		other.radsuit_finished = time + 30;
		other.radsuit_counter = 30;
		SpawnRebreather();
	}
	
	if (self.classname == "item_artifact_invulnerability")
	{
		other.invincible_time = 1;
		other.invincible_finished = time + 30;
		other.invincible_counter = 30;
	}
	
	if (self.classname == "item_artifact_invisibility")
	{
		other.invisible_time = 1;
		other.invisible_finished = time + 30;
		other.invisible_counter = 30;
	}

	if (self.classname == "item_artifact_super_damage")
	{
		other.super_time = 1;
		other.super_damage_finished = time + 30;
		other.super_damage_counter = 30;
	}	

	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};



/*QUAKED item_artifact_invulnerability (0 .5 .8) (-16 -16 -24) (16 16 32)
Player is invulnerable for 30 seconds
*/
void() item_artifact_invulnerability =
{
	if (autocvar_slowmo_powerup == 4 && deathmatch)
	{
		self.dmg = 2;
		item_artifact_timerune();
		return;
	}
	self.touch = powerup_touch;

	precache_model ("progs/invulner.mdl");
	precache_sound ("items/protect.wav");
	precache_sound ("items/protect2.wav");
	precache_sound ("items/protect3.wav");
	self.noise = "items/protect.wav";
	setmodel (self, "progs/invulner.mdl");

if (world.model == "maps/e1m8.bsp")
	self.traileffectnum = particleeffectnum("pentagram_low_gravity");
else
	self.traileffectnum = particleeffectnum("pentagram_normal_gravity");

	self.netname = "Pentagram of Protection";
	self.items = IT_INVULNERABILITY;
	setsize (self, '-16 -16 -24', '16 16 32');
	StartItem ();
};

/*QUAKED item_artifact_envirosuit (0 .5 .8) (-16 -16 -24) (16 16 32)
Player takes no damage from water or slime for 30 seconds
*/
void() hip_powerup_touch;

void() item_artifact_envirosuit =
{
	if (autocvar_slowmo_powerup == 3 && deathmatch)
	{
		self.dmg = 2;
		item_artifact_timerune();
		return;
	}
	else if (self.dmg == 1)
	{
		self.classname = "item_artifact_envirosuit";
		self.touch = powerup_touch;
		precache_model ("progs/wetsuit.mdl");
		precache_sound ("misc/wetsuit.wav");
		precache_sound ("misc/weton.wav");
		precache_sound ("items/suit2.wav");
		self.noise = "misc/weton.wav";
		setmodel (self, "progs/wetsuit.mdl");
		self.netname = "Wetsuit";
		//self.netname = "Biosuit";
		self.items = IT_SUIT;
		setsize (self, '-16 -16 -24', '16 16 32');

		StartItem ();
	}
	else
	{
		self.touch = powerup_touch;

		precache_model ("progs/suit.mdl");
		precache_sound ("items/suit.wav");
		precache_sound ("items/suit2.wav");
		precache_sound ("misc/wetsuit.wav");
		self.noise = "items/suit.wav";
		setmodel (self, "progs/suit.mdl");

		self.traileffectnum = particleeffectnum("biosuit");		//////////////  adds particle effect to biosuit (customize the effect in your effectinfo.txt)

		self.netname = "Biosuit";
		self.items = IT_SUIT;
		setsize (self, '-16 -16 -24', '16 16 32');
		StartItem ();
	}
};

.float slowmo_timer;

void() slowmo_counter =
{
	
	if (self.owner.slowmo_timer == 0)
	{
		cvar_set("slowmo", "1");
		stuffcmd (self.owner, "bf\n");
		IN_SLOWMO = 0;
		self.owner.bulletspeed = 900; //reset bullet travel speed to player default
		if (deathmatch)
		{
			self.think = SUB_regen;
			self.nextthink = time + 80;
		}
	}
	else
	{
		self.think = slowmo_counter;
		self.nextthink = time + 1;
		self.owner.slowmo_timer--;
		if (self.owner.slowmo_timer == 1)
		{
			stuffcmd (self.owner, "bf\n");
			sprint (self.owner,"the Time Dilation Rune is wearing off...\n");
			sound(world, CHAN_AUTO, "items/slowmo_expire.wav", 1, ATTN_NONE);
		}
	}
}

void() slowmo_touch =
{
	if (other.classname != "player")
		return;
	if (other.health <= 0)
		return;

	sprint (other, "You got the ");
	sprint (other, self.netname);
	sprint (other,"\n");

	/*if (deathmatch)
	{
		self.mdl = self.model;
		
		if ((self.classname == "item_artifact_invulnerability") ||
			(self.classname == "item_artifact_invisibility"))
			self.nextthink = time + 60*5;
		else
			self.nextthink = time + 60;
		
		self.think = SUB_regen;
	}*/	

	sound (other, CHAN_VOICE, self.noise, 1, ATTN_NORM);
	stuffcmd (other, "bf\n");
	self.solid = SOLID_NOT;
	//other.items = other.items | self.items;
	self.model = string_null;
	
	IN_SLOWMO = 1; //server flag so respawns don't disable slowmo
	
// do the apropriate action
	//other.invisible_time = 1;
	//other.invisible_finished = time + 15;
	//other.invisible_counter = 15;
	
	cvar_set("slowmo", ".55");
	self.owner = other;
	
	self.owner.bulletspeed = 1200;
	other.slowmo_timer = 13;
	self.think = slowmo_counter;
	self.nextthink = time + 1;

	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};


/*void() slowmo_touch = 
{
	slowmo_timer++;
	if (slowmo_timer < 30)
		cvar_set("slowmo", ".45");
	else
	{
		cvar_set("slowmo", "1");
		self.think = SUB_Remove;
		self.nextthink = time + 0.1;
	}
	
	self.think = slowmo_touch;
	self.nextthink = time + 1;
	
}*/

/*QUAKED item_artifact_invisibility (0 .5 .8) (-16 -16 -24) (16 16 32)
Player is invisible for 30 seconds
*/
void() item_artifact_timerune =
{
	precache_model ("progs/timerune.mdl");
	precache_sound ("items/slowmo_pickup.wav");
	precache_sound ("items/slowmo_expire.wav");
	self.noise = "items/slowmo_pickup.wav";
	setmodel (self, "progs/timerune.mdl");

	self.touch = slowmo_touch;
	self.traileffectnum = particleeffectnum("time_rune");		//////////////  adds particle effect to ring (customize the effect in your effectinfo.txt)

	self.netname = "Time Dilation Rune";
	//self.items = IT_INVISIBILITY;
	setsize (self, '-16 -16 -24', '16 16 32');
	StartItem ();
}
void() item_artifact_invisibility =
{
	if (autocvar_chainsaw_replaces_ring == 1 && deathmatch)
	{
		
		self.dmg = 1;
		weapon_nailgun();
	}
	else if ((autocvar_slowmo_powerup == 1 && deathmatch) || (autocvar_slowmo_powerup == 1 && !deathmatch && random() > 0.5))
	{
		
		self.dmg = 2;
		item_artifact_timerune();

	}
	else
	{
		self.touch = powerup_touch;

		precache_model ("progs/invisibl.mdl");
		precache_sound ("items/inv1.wav");
		precache_sound ("items/inv2.wav");
		precache_sound ("items/inv3.wav");
		self.noise = "items/inv1.wav";
		setmodel (self, "progs/invisibl.mdl");

		self.traileffectnum = particleeffectnum("ring");		//////////////  adds particle effect to ring (customize the effect in your effectinfo.txt)

		self.netname = "Ring of Shadows";
		self.items = IT_INVISIBILITY;
		setsize (self, '-16 -16 -24', '16 16 32');
		StartItem ();
	}
};



/*QUAKED item_artifact_super_damage (0 .5 .8) (-16 -16 -24) (16 16 32)
The next attack from the player will do 4x damage
*/



void() item_artifact_super_damage =
{
	if ((autocvar_slowmo_powerup == 2 && deathmatch) || (autocvar_slowmo_powerup == 2 && !deathmatch && random() > 0.5))
	{
		self.dmg = 2;
		item_artifact_timerune();
		return;
	}
	self.touch = powerup_touch;

	precache_model ("progs/quaddama.mdl");
	precache_sound ("items/damage.wav");
	precache_sound ("items/damage2.wav");
	precache_sound ("items/damage3.wav");
	self.noise = "items/damage.wav";
	setmodel (self, "progs/quaddama.mdl");

self.traileffectnum = particleeffectnum("quad");		//////////////  adds particle effect to quad (customize the effect in your effectinfo.txt)

	self.netname = "Quad Damage";
	self.items = IT_QUAD;
	setsize (self, '-16 -16 -24', '16 16 32');

   	StartItem ();
};



/*
===============================================================================

PLAYER BACKPACKS

===============================================================================
*/

entity backpackchildren;   // for enforcers backpack cell models

void() BackpackTouch;

void() backpack_touch_delay =
{
	self.touch = BackpackTouch;
	self.nextthink = time + 120;	// remove after 2 minutes
	self.think = SUB_Remove;
};

void() BackpackTouch =
{
	local string	s;
	local	float	best, old, new;
	local	entity	stemp;
	local	float	acount;
	
	if (other.classname != "player")
		return;
	if (other.health <= 0)
		return;
		
	if (cvar("coop_life_pool"))
	{
		if (self.owner.classname == "player" && other != self.owner)
			return;
	}
		

	if (autocvar_lossless_backpack_pickup)
	{
		if (!(deathmatch || coop ))		// "backpack waste"-feature only used in single player
		{
			if ((self.ammo_shells) && (other.ammo_shells >= autocvar_shells_max_capacity))		// default 100
				return;
			if ((self.ammo_nails) && (other.ammo_nails >= autocvar_nails_max_capacity))		// default 200
				return;
			if ((self.ammo_rockets) && (other.ammo_rockets >= autocvar_rockets_max_capacity))	// default 100
				return;
			if ((self.ammo_cells) && (other.ammo_cells >= autocvar_cells_max_capacity))		// default 100
				return;
		}
	}

	acount = 0;
	sprint (other, "You get ");

	if (self.items)
		if ((other.items & self.items) == 0)
		{
			acount = 1;
			sprint (other, "the ");
			sprint (other, self.netname);
		}

// if the player was using his best weapon, change up to the new one if better		
	stemp = self;
	self = other;
	best = W_BestWeapon();
	self = stemp;

	self.ammo_shells_old = self.ammo_shells;	// detect the current ammo amount of backpack (to be able to do calculations later on)
	self.ammo_nails_old = self.ammo_nails;
	self.ammo_rockets_old = self.ammo_rockets;
	self.ammo_cells_old = self.ammo_cells;
	

// change weapons
	other.ammo_shells = other.ammo_shells + self.ammo_shells;
	if (autocvar_lossless_backpack_pickup)
	{
		if (other.ammo_shells > autocvar_shells_max_capacity)
			self.ammo_shells = other.ammo_shells - autocvar_shells_max_capacity;	// set new ammo quantity of backpack, because player could not take all !!
		else
			self.shells_are_empty = 1;			// player used up complete amount in backpack !!
	}
	other.ammo_nails = other.ammo_nails + self.ammo_nails;
	if (autocvar_lossless_backpack_pickup)
	{
		if (other.ammo_nails > autocvar_nails_max_capacity)
			self.ammo_nails = other.ammo_nails - autocvar_nails_max_capacity;	// set new ammo quantity of backpack, because player could not take all !!
		else
			self.nails_are_empty = 1;			// player used up complete amount in backpack !!
	}
	other.ammo_rockets = other.ammo_rockets + self.ammo_rockets;
	if (autocvar_lossless_backpack_pickup)
	{
		if (other.ammo_rockets > autocvar_rockets_max_capacity)
			self.ammo_rockets = other.ammo_rockets - autocvar_rockets_max_capacity;	// set new ammo quantity of backpack, because player could not take all !!
		else
			self.rockets_are_empty = 1;			// player used up complete amount in backpack !!
	}
	other.ammo_cells = other.ammo_cells + self.ammo_cells;
	if (autocvar_lossless_backpack_pickup)
	{
		if (other.ammo_cells > autocvar_cells_max_capacity)
			self.ammo_cells = other.ammo_cells - autocvar_cells_max_capacity;	// set new ammo quantity of backpack, because player could not take all !!
		else
			self.cells_are_empty = 1;			// player used up complete amount in backpack !!
	}

	new = self.items;
	if (!new)
		new = other.weapon;
	old = other.items;
	other.items = other.items | new;
	
	bound_other_ammo ();

	if (self.ammo_shells)
	{
		if (acount)
			sprint(other, ", ");
		acount = 1;
		if (autocvar_lossless_backpack_pickup)
		{
			if (!self.shells_are_empty)
				s = ftos(self.ammo_shells_old - self.ammo_shells);
			else
				s = ftos(self.ammo_shells_old);
		}
		else
			s = ftos(self.ammo_shells);
		sprint (other, s);
		sprint (other, " shells");
	}
	if (self.ammo_nails)
	{
		if (acount)
			sprint(other, ", ");
		acount = 1;
		if (autocvar_lossless_backpack_pickup)
		{
			if (!self.nails_are_empty)
				s = ftos(self.ammo_nails_old - self.ammo_nails);
			else
				s = ftos(self.ammo_nails_old);
		}
		else
			s = ftos(self.ammo_nails);
		sprint (other, s);
		sprint (other, " nails");
	}
	if (self.ammo_rockets)
	{
		if (acount)
			sprint(other, ", ");
		acount = 1;
		if (autocvar_lossless_backpack_pickup)
		{
			if (!self.rockets_are_empty)
				s = ftos(self.ammo_rockets_old - self.ammo_rockets);
			else
				s = ftos(self.ammo_rockets_old);
		}
		else
			s = ftos(self.ammo_rockets);
		sprint (other, s);
		sprint (other, " rockets");
	}
	if (self.ammo_cells)
	{
		if (acount)
			sprint(other, ", ");
		acount = 1;
		if (autocvar_lossless_backpack_pickup)
		{
			if (!self.cells_are_empty)
				s = ftos(self.ammo_cells_old - self.ammo_cells);
			else
				s = ftos(self.ammo_cells_old);
		}
		else
			s = ftos(self.ammo_cells);
		sprint (other, s);
		sprint (other, " cells");
	}
	if ((!(deathmatch || coop )) && (autocvar_lossless_backpack_pickup))	// "backpack waste"-feature only used in single player
	{
		if ((!self.shells_are_empty) || (!self.nails_are_empty) || (!self.rockets_are_empty) || (!self.cells_are_empty))	// backpack is not empty yet. Tell player !!
		sprint (other, ". Max capacity reached.");
	}
	
	sprint (other, "\n");
	
// backpack touch sound
	if (self.backpack_sound == 1)		// soldier
		sound (other, CHAN_ITEM, "ambience/backpack_soldier.wav", 1, ATTN_NORM);
	else if (self.backpack_sound == 2)	// enforcer
	{
		sound (self, CHAN_ITEM, "misc/null.wav", 1, ATTN_NORM);		// to stop the cell ambience sound
		sound (other, CHAN_ITEM, "ambience/backpack_enforcer.wav", 1, ATTN_NORM);
	}
	else if (self.backpack_sound == 3)	// ogre
		sound (other, CHAN_ITEM, "ambience/backpack_ogre.wav", 1, ATTN_NORM);
	else					// standard
		sound (other, CHAN_ITEM, "weapons/lock4.wav", 1, ATTN_NORM);
	stuffcmd (other, "bf\n");


	if ((!(deathmatch || coop )) && (autocvar_lossless_backpack_pickup))	// "backpack waste"-feature only used in single player
	{
		if ((self.shells_are_empty == 1) && (self.nails_are_empty == 1) && (self.rockets_are_empty == 1) && (self.cells_are_empty == 1))	// backpack is completely empty 
		{	
		// remove the backpack, change self to the player
			remove(self);
			self = other;

		// change to the weapon
			if (!deathmatch)
				self.weapon = new;
			else
				Deathmatch_Weapon (old, new);
			W_SetCurrentAmmo ();
		}
		else		// backpack is not yet emtpy, so leave model in game until it is fully used up.
		{
			self.touch = SUB_Null;		//  to avoid overflows
			self.nextthink = time + 1;	//  delay next pickup of this backpack, in case player stands inside it and fires a weapon that uses the remaining ammo
			self.think = backpack_touch_delay;
		// if changed current ammo, update it
			stemp = self;
			self = other;
			W_SetCurrentAmmo();
			self = stemp;
		}
	}
	else		// we are in multiplayer, or in single player but with disabled autocvar_lossless_backpack_pickup !
	{
	// remove the backpack, change self to the player
		remove(self);
		self = other;
	// change to the weapon
		if (!deathmatch)
			self.weapon = new;
		else
			Deathmatch_Weapon (old, new);
		W_SetCurrentAmmo ();
	}
};

/*
===============
DropBackpack
===============
*/

void() backpack_enforcer_movement =
{
	self.movetype = MOVETYPE_FLY;
	self.velocity = '0 0 0.1';	// is necessary. Without this, no movement possible.
	self.avelocity = randomvec() * 333 + '100 100 100';	// each cell atom moves independent and randomly
	self.nextthink = time + 120;	// remove after 2 minutes
	self.think = SUB_Remove;
};


void() backpackchildren_touch =
{
	if (other.classname != "player")
		return;
	sound (other, CHAN_ITEM, "ambience/backpack_enforcer.wav", 1, ATTN_NORM);
	remove(self);
};


void(vector dir, float num) spawn_more_backpack_cells =
{
	backpackchildren = spawn ();
	if (num == 1)
		{
		backpackchildren.origin = self.origin;
		backpackchildren.velocity = dir + '5 5 5';
		}
	if (num == 2)
		{
		backpackchildren.origin = self.origin;
		backpackchildren.velocity = dir - '5 5 5';
		}
	if (num == 3)
		{
		backpackchildren.origin = self.origin;
		backpackchildren.velocity = dir + '3 3 3';
		}
	if (num == 4)
		{
		backpackchildren.origin = self.origin;
		backpackchildren.velocity = dir - '3 3 3';
		}
	backpackchildren.solid = SOLID_TRIGGER;
	backpackchildren.movetype = MOVETYPE_TOSS;
	setmodel (backpackchildren, "progs/backpack_enforcer.mdl"); 
	setsize (backpackchildren, '-24 -24 -20', '24 24 24');
	backpackchildren.scale = 0.9;
	backpackchildren.touch = backpackchildren_touch;
	backpackchildren.owner = self;
	backpackchildren.traileffectnum = particleeffectnum("backpack_enforcer");

	backpackchildren.nextthink = time + 0.65;  
	backpackchildren.think = backpack_enforcer_movement;
};

void() followowner =
{
	if (self.owner.health > 0)
		setorigin(self, self.owner.origin);
	self.think = followowner;
	self.nextthink = time + 0.2;
}

void() DropBackpack =
{
	local entity	item;

	if (!(self.ammo_shells + self.ammo_nails + self.ammo_rockets + self.ammo_cells))
		return;	// nothing in it

	item = spawn();
	item.origin = self.origin - '0 0 24';
	
	if (self.classname == "player")
		item.colormap = self.colormap;
	
	if (cvar("coop_life_pool"))
		item.owner = self;
	
	item.items = self.weapon;
	if (item.items == IT_AXE)
		item.netname = "Axe";
	else if (item.items == IT_SHOTGUN)
		item.netname = "Shotgun";
	else if (item.items == IT_SUPER_SHOTGUN)
		item.netname = "Double-barrelled Shotgun";
	else if (item.items == IT_NAILGUN)
		item.netname = "Nailgun";
	else if (item.items == IT_SUPER_NAILGUN)
		item.netname = "Super Nailgun";
	else if (item.items == IT_GRENADE_LAUNCHER)
		item.netname = "Grenade Launcher";
	else if (item.items == IT_ROCKET_LAUNCHER)
		item.netname = "Rocket Launcher";
	else if (item.items == IT_LIGHTNING)
		item.netname = "Thunderbolt";
	else if (item.items == IT_CHAINSAW)
			item.netname = "Chainsaw";
	else if (item.items == IT_LASER_CANNON)
		item.netname = "Laser Cannon";
	/*else if (item.items == IT2_PROXIMITY_GUN)
		item.netname = "Proximity Gun";*/
	else
		item.netname = "";

	item.ammo_shells = self.ammo_shells;
	item.ammo_nails = self.ammo_nails;
	item.ammo_rockets = self.ammo_rockets;
	item.ammo_cells = self.ammo_cells;

	item.velocity_z = 300;
	item.velocity_x = -100 + (random() * 200);
	item.velocity_y = -100 + (random() * 200);
	
	item.flags = FL_ITEM;
	item.solid = SOLID_TRIGGER;
	item.movetype = MOVETYPE_TOSS;
	
	if (autocvar_backpack == 1)		// if 'backpack' is set to '1', make the backpack use gyro (shootable + floatable in water)
	{
		precache_model ("progs/backpack1.mdl");
		setmodel (item, "progs/backpack1.mdl");		// different positioned backpack model is needed
		setsize (item, '-16 -16 -16', '16 16 32');	// different box calculation is needed
		BackpackPhysics(item);
	}		
	else if (autocvar_backpack == 2)	// if 'backpack' is set to '2', new custom backpack models will be used (different ones for each monster)
	{
		if (self.backpack_thrower == 1)		// "1" = soldier
		{
			if (autocvar_backpack_soldier_custom)
			{
				precache_model ("progs/backpack_soldier.mdl");		// it is already precached in world.qc, but some DP builds have issues with it
				setmodel (item, "progs/backpack_soldier.mdl");		// NEW model for soldier
				setsize (item, '-16 -16 -7', '16 16 32');
				item.avelocity = '0 250 0'; 
				item.backpack_sound = 1;	// play special touch-sound for soldier큦 shells
				precache_sound ("ambience/backpack_soldier.wav");
			}
			else
			{
				setmodel (item, "progs/backpack.mdl");
				setsize (item, '-16 -16 0', '16 16 56');
			}
		}
		else if (self.backpack_thrower == 2)	// "2" = enforcer
		{
			if (autocvar_backpack_enforcer_custom)
			{
				precache_model ("progs/backpack_enforcer.mdl");		// it is already precached in world.qc, but some DP builds have issues with it
				setmodel (item, "progs/backpack_enforcer.mdl");		// NEW model for enforcer
				setsize (item, '-16 -16 0', '16 16 48');
				item.scale = 0.9;
				item.traileffectnum = particleeffectnum("backpack_enforcer");
				local vector direction;
				direction = item.velocity; 
				spawn_more_backpack_cells (direction, 1);
				spawn_more_backpack_cells (direction, 2);	// spawn as many as you want here ;)
				item.touch = BackpackTouch;
				item.backpack_sound = 2;	// play special touch-sound for enforcer큦 cells
				precache_sound ("ambience/backpack_enforcer.wav");
				item.nextthink = time + 0.62;  		// fine tuned so that cells float perfectly in air after they are thrown out of corpse
				item.think = backpack_enforcer_movement;
				sound (item, CHAN_ITEM, "ambience/backpack_enforcer_ambience.wav", 1, ATTN_NORM);	// play cell ambience sound
				return;					// jump out of here !
			}
			else
			{
				setmodel (item, "progs/backpack.mdl");
				setsize (item, '-16 -16 0', '16 16 56');
			}
		}
		else if (self.backpack_thrower == 3)	// "3" = ogre
		{
			if (autocvar_backpack_ogre_custom)
			{
				precache_model ("progs/backpack_ogre.mdl");		// it is already precached in world.qc, but some DP builds have issues with it
				setmodel (item, "progs/backpack_ogre.mdl");		// NEW model for ogre
				setsize (item, '-16 -16 -6', '16 16 32');
				item.scale = 0.8;
				item.avelocity = '0 250 0'; 
				item.backpack_sound = 3;	// play special touch-sound for ogre큦 grenades
				precache_sound ("ambience/backpack_ogre.wav");
				//self.items = self.items | IT_CHAINSAW;
			}
			else
			{
				setmodel (item, "progs/backpack.mdl");
				setsize (item, '-16 -16 0', '16 16 56');
			}
		}
		else if (self.backpack_thrower == 4)		// "4" = nail soldier
		{
			setmodel (item, "progs/backpack.mdl");
			setsize (item, '-16 -16 0', '16 16 56');
		}
		else					// for multiplayer
		{
			setmodel (item, "progs/backpack.mdl");
			setsize (item, '-16 -16 0', '16 16 56');
		}
	}
	else		// if 'backpack' is '0', use original Quake behaviour and model
	{
		setmodel (item, "progs/backpack.mdl");
		setsize (item, '-16 -16 0', '16 16 56');
	}
	
var float autocvar_backpackspin = 1;   	// set cvar 'backpackspin' default to 1
	if (autocvar_backpackspin == 0)	// if 'backpackspin' is '0', backpack does not spin 
		item.effects = EF_NOMODELFLAGS;
		
	item.touch = BackpackTouch;
	item.flashtarg = "yes";
	item.cansplash = TRUE;		// create a splash when fall into liquid

	if (coop && cvar("coop_life_pool"))
	{
		item.think = followowner;
		item.effects = item.effects | EF_FULLBRIGHT;
		item.nextthink = time + 0.1;
	}
	else
	{
		item.nextthink = time + 120;	// remove after 2 minutes
		item.think = SUB_Remove;
	}
};

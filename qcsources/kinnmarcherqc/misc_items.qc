void() BDW_SetCurrentWeapon;
float(float w) BDW_ImpulseForWeapon;
float(float id) AddToItemList;	//bdw

/* ALL LIGHTS SHOULD BE 0 1 0 IN COLOR ALL OTHER ITEMS SHOULD
BE .8 .3 .4 IN COLOR */


void() SUB_regen =
{
	self.model = self.mdl;		// restore original model
	self.solid = SOLID_TRIGGER;	// allow it to be touched again
	sound (self, CHAN_VOICE, "items/itembk2.wav", 1, ATTN_NORM);	// play respawn sound
	setorigin (self, self.origin);
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
	self.mdl = self.model;		// so it can be restored on respawn	
	self.flags = FL_ITEM;		// make extra wide
	self.solid = SOLID_TRIGGER;
	self.movetype = MOVETYPE_TOSS;
	self.velocity = '0 0 0';
	self.origin_z = self.origin_z + 6;
	if (!droptofloor())
	{
		//bdw - changed this slightly, and no longer removes item...

		dprint (self.classname);
		dprint (" spawned in solid at ");
		dprint (vtos(self.origin));
		dprint ("\n");

		setorigin (self, self.origin);	//bdw - not removed, so needs re-linking if droptofloor returns false
		//remove(self);
		//return;
	}	
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
//
// T_Heal: add health to an entity, limiting health to max_health
// "ignore" will ignore max_health limit
//
float (entity e, float healamount, float ignore) T_Heal =
{
	if (e.health <= 0)
		return 0;
	if ((!ignore) && (e.health >= other.max_health))
		return 0;
	healamount = ceil(healamount);

	e.health = e.health + healamount;
	if ((!ignore) && (e.health >= other.max_health))
		e.health = other.max_health;

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
.float	healamount, healtype;
void() health_touch;
void() item_megahealth_rot;

void() item_health_init =
{
	self.classname = "item_health";	//bdw - for spawning

	self.touch = health_touch;

	if (self.spawnflags & H_ROTTEN)
	{		
		setmodel(self, "maps/b_bh10.bsp");
		self.noise = "items/r_item1.wav";
		self.healamount = 15;
		self.healtype = 0;
	}
	else if (self.spawnflags & H_MEGA)
	{
		setmodel(self, "maps/b_bh100.bsp");
		self.noise = "items/r_item2.wav";
		self.healamount = 100;
		self.healtype = 2;
	}
	else
	{
		setmodel(self, "maps/b_bh25.bsp");
		self.noise = "items/health1.wav";
		self.healamount = 25;
		self.healtype = 1;
	}

	setsize(self, '0 0 0', '32 32 56');		
};

void() item_health_precache =
{
	if (self.spawnflags & H_ROTTEN)
	{
		precache_model("maps/b_bh10.bsp");
		precache_sound("items/r_item1.wav");
	}
	else if (self.spawnflags & H_MEGA)
	{
		precache_model("maps/b_bh100.bsp");
		precache_sound("items/r_item2.wav");
	}
	else
	{
		precache_model("maps/b_bh25.bsp");
		precache_sound("items/health1.wav");
	}
};

void() item_health =
{
	item_health_precache();

	if (AddToItemList(IT_HEALTH))		
		return;

	item_health_init();
	StartItem();
};

void() health_touch =
{
	local	float amount;
	local	string	s;

	if (other.classname != "player")
		return;

	if (self.healtype == 2) // Megahealth?  Ignore max_health...
	{
		if (other.health >= 250)
			return;
		if (!T_Heal(other, self.healamount, 1))
			return;
	}
	else
	{
		if (!T_Heal(other, self.healamount, 0))
			return;
	}

	sprint(other, "You receive ");
	s = ftos(self.healamount);
	sprint(other, s);
	sprint(other, " health\n");

// health touch sound
	sound(other, CHAN_ITEM, self.noise, 1, ATTN_NORM);

	stuffcmd (other, "bf\n");

	self.model = string_null;
	self.solid = SOLID_NOT;

	// Megahealth = rot down the player's super health
	if (self.healtype == 2)
	{
// 11/02/96 removed SUPERHEALTH from defs.qc
//      other.items = other.items | IT_SUPERHEALTH;
		self.nextthink = time + 5;
		self.think = item_megahealth_rot;
		self.owner = other;
	}
	else if (deathmatch)	//bdw - removed deathmatch 2 stuff and made item remove self in sp
	{			
		self.nextthink = time + 20;
		self.think = SUB_regen;
	}
	else
	{
		self.nextthink = time + 0.1;
		self.think = SUB_Remove;
	}

	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
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
// MED 11/02/96 removed SUPERHEALTH
//   other.items = other.items - (other.items & IT_SUPERHEALTH);

	if (deathmatch)	//bdw - removed deathmatch 2 stuff and made item remove self in sp
	{			
		self.nextthink = time + 20;
		self.think = SUB_regen;
	}
	else
	{
		self.nextthink = time + 0.1;
		self.think = SUB_Remove;
	}
};

/*
===============================================================================

ARMOR

===============================================================================
*/

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
		value = 100;
      	bit = IT_ARMOR1;
   	}
	if (self.classname == "item_armor2")
	{
		type = 0.6;
		value = 150;
		bit = IT_ARMOR2;
	}
	if (self.classname == "item_armorInv")
	{
		type = 0.8;
		value = 200;
		bit = IT_ARMOR3;
	}
	if (other.armortype*other.armorvalue >= type*value)
		return;

	other.armortype = type;
	other.armorvalue = value;
   	other.items = other.items - (other.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3)) + bit;

	self.solid = SOLID_NOT;
	self.model = string_null;

//bdw - removed deathmatch 2 stuff and made item remove self in sp...	
	if (deathmatch)	
	{			
		self.nextthink = time + 20;
		self.think = SUB_regen;
	}
	else
	{
		self.nextthink = time + 0.1;
		self.think = SUB_Remove;
	}

	sprint(other, "You got armor\n");
// armor touch sound
	sound(other, CHAN_ITEM, "items/armor1.wav", 1, ATTN_NORM);
	stuffcmd (other, "bf\n");

	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};


/*QUAKED item_armor1 (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() item_armor_init =
{
	self.touch = armor_touch;
	setmodel(self, "progs/armor.mdl");
	setsize(self, '-16 -16 0', '16 16 56');
};

//===============================================

void() item_armor1_init =
{
	self.classname = "item_armor1";
	self.skin = 0;
	item_armor_init();
};
void() item_armor2_init =
{
	self.classname = "item_armor2";
	self.skin = 1;
	item_armor_init();
};
void() item_armorInv_init =
{
	self.classname = "item_armorInv";
	self.skin = 2;
	item_armor_init();
};

//===============================================

void() item_armor1 =
{
	precache_model("progs/armor.mdl");

	if (AddToItemList(IT_ARMOR1))		
		return;

	item_armor1_init();
	StartItem();
};
void() item_armor2 =
{
	precache_model("progs/armor.mdl");

	if (AddToItemList(IT_ARMOR2))		
		return;

	item_armor2_init();
	StartItem();
};
void() item_armorInv =
{
	precache_model("progs/armor.mdl");

	if (AddToItemList(IT_ARMOR3))		
		return;

	item_armorInv_init();
	StartItem();
};

/*
===============================================================================

WEAPONS

===============================================================================
*/

float(float w) RankForWeapon =
{
	if (w == IT_LIGHTNING)
		return 1;
	if (w == IT_ROCKET_LAUNCHER)
		return 2;
	if (w == IT_SUPER_NAILGUN)
		return 3;
	if (w == IT_GRENADE_LAUNCHER)
		return 4;
	if (w == IT_SUPER_SHOTGUN)
		return 5;
	if (w == IT_NAILGUN)
		return 6;
	if (w == IT_SHOTGUN)	//bdw
		return 7;
	return 8;
};

float() W_BestWeapon;

/*
======================================
BDW_AmmoWeaponTouch

this is a new, unified touch function 
for ammo, backpacks and weapons.
======================================
*/

//bdw...
/*
float MAX_AMMO_SHELLS = 250;
float MAX_AMMO_NAILS = 250;
float MAX_AMMO_ROCKETS = 250;
float MAX_AMMO_CELLS = 250;
*/

//bdw - restored it to vanilla ammo caps...
float MAX_AMMO_SHELLS = 100;
float MAX_AMMO_NAILS = 200;
float MAX_AMMO_ROCKETS = 100;
float MAX_AMMO_CELLS = 100;


float() CheckForAmmoWeaponPickup =
{
	if (self.classname == "backpack")
	{
		return TRUE;
	}

	if (self.items)	//weapon or backpack (so must be weapon)
	{		
		if (deathmatch == 2 || coop)	//weapon stay
		{
			if (other.items & self.items)
				return FALSE;
		}

		return TRUE;
	}	
	if (self.ammo_shells)
	{
		if (other.ammo_shells < MAX_AMMO_SHELLS)
			return TRUE;
	}
	if (self.ammo_nails)
	{
		if (other.ammo_nails < MAX_AMMO_NAILS)
			return TRUE;
	}
	if (self.ammo_rockets)
	{
		if (other.ammo_rockets < MAX_AMMO_ROCKETS)
			return TRUE;
	}
	if (self.ammo_cells)
	{
		if (other.ammo_cells < MAX_AMMO_CELLS)
			return TRUE;
	}	

	return FALSE;
};

void() BDW_AmmoWeaponTouch =
{
   	local float acount, gained;

	if (other.classname != "player")
		return;
	if (other.health <= 0)
		return;

	if (!CheckForAmmoWeaponPickup())
		return;

   	sprint (other, "You got ");

//update weapon items...
   	if (self.items)
      	{
         	acount = 1;
         	sprint (other, "the ");
         	sprint (other, self.netname);
		other.items = other.items | self.items;
      	}

   	if (self.ammo_shells)
	{
		if (other.ammo_shells < MAX_AMMO_SHELLS)
		{
			if (other.ammo_shells + self.ammo_shells > MAX_AMMO_SHELLS)
				gained = MAX_AMMO_SHELLS - other.ammo_shells;
			else
				gained = self.ammo_shells;

			if (other.ammo_shells <= 0)	//previously out of shells
			{
				if ( (gained >= 2) && (other.items & IT_SUPER_SHOTGUN) )
				{
					if (RankForWeapon(IT_SUPER_SHOTGUN) < RankForWeapon(other.weapon))
						other.impulse = BDW_ImpulseForWeapon(IT_SUPER_SHOTGUN);
				}
				else if (other.items & IT_SHOTGUN)
				{
					if (RankForWeapon(IT_SHOTGUN) < RankForWeapon(other.weapon))
						other.impulse = BDW_ImpulseForWeapon(IT_SHOTGUN);
				}
			}

			other.ammo_shells = other.ammo_shells + gained;		

			if ( (other.weapon == IT_SHOTGUN) || (other.weapon == IT_SUPER_SHOTGUN) )
				other.currentammo = other.ammo_shells;

			if (acount)
				sprint(other, ", ");
			acount = 1;
			sprint(other, ftos(gained));
			sprint(other, " shell");
			if (gained > 1)
				sprint(other, "s");
		}
	}
	if (self.ammo_nails)
	{
		if (other.ammo_nails < MAX_AMMO_NAILS)
		{
			if (other.ammo_nails + self.ammo_nails > MAX_AMMO_NAILS)
				gained = MAX_AMMO_NAILS - other.ammo_nails;
			else
				gained = self.ammo_nails;

			if (other.ammo_nails <= 0)	//previously out of nails
			{
				if ( (gained >= 2) && (other.items & IT_SUPER_NAILGUN) )
				{
					if (RankForWeapon(IT_SUPER_NAILGUN) < RankForWeapon(other.weapon))
						other.impulse = BDW_ImpulseForWeapon(IT_SUPER_NAILGUN);
				}
				else if (other.items & IT_NAILGUN)
				{
					if (RankForWeapon(IT_NAILGUN) < RankForWeapon(other.weapon))
						other.impulse = BDW_ImpulseForWeapon(IT_NAILGUN);
				}
			}

			other.ammo_nails = other.ammo_nails + gained;	

			if ( (other.weapon == IT_NAILGUN) || (other.weapon == IT_SUPER_NAILGUN) )
				other.currentammo = other.ammo_nails;	

			if (acount)
				sprint(other, ", ");
			acount = 1;
			sprint(other, ftos(gained));
			sprint(other, " nail");
			if (gained > 1)
				sprint(other, "s");
		}
	}
	if (self.ammo_rockets)
	{
		if (other.ammo_rockets < MAX_AMMO_ROCKETS)
		{
			if (other.ammo_rockets + self.ammo_rockets > MAX_AMMO_ROCKETS)
				gained = MAX_AMMO_ROCKETS - other.ammo_rockets;
			else
				gained = self.ammo_rockets;			

			other.ammo_rockets = other.ammo_rockets + gained;	

			if ( (other.weapon == IT_GRENADE_LAUNCHER) || (other.weapon == IT_ROCKET_LAUNCHER) )
				other.currentammo = other.ammo_rockets;

			if (acount)
				sprint(other, ", ");
			acount = 1;
			sprint(other, ftos(gained));
			sprint (other, " rocket");
			if (gained > 1)
				sprint(other, "s");
		}
	}
	if (self.ammo_cells)
	{
		if (other.ammo_cells < MAX_AMMO_CELLS)
		{
			if (other.ammo_cells + self.ammo_cells > MAX_AMMO_CELLS)
				gained = MAX_AMMO_CELLS - other.ammo_cells;
			else
				gained = self.ammo_cells;

			if (other.ammo_cells <= 0)	//previously out of nails
			{
				if (other.items & IT_LIGHTNING)
				{
					if (RankForWeapon(IT_LIGHTNING) < RankForWeapon(other.weapon))
						other.impulse = BDW_ImpulseForWeapon(IT_LIGHTNING);
				}				
			}

			other.ammo_cells = other.ammo_cells + gained;	

			if (other.weapon == IT_LIGHTNING)
				other.currentammo = other.ammo_cells;

			if (acount)
				sprint(other, ", ");
			acount = 1;
			sprint(other, ftos(gained));
			sprint (other, " cell");
			if (gained > 1)
				sprint(other, "s");
		}
	}

	if (self.items)	//if just picked up a weapon, then always change to it in single player...
	{
		if (!deathmatch)
			other.impulse = BDW_ImpulseForWeapon(self.items);
		else
		{
			//change self.weapon if desired...
			if (RankForWeapon(self.items) < RankForWeapon(other.weapon))
				other.impulse = BDW_ImpulseForWeapon(self.items);	//bdw
		}
	}	
	
	sprint (other, "\n");

	if (!self.noise)
		self.noise = "weapons/lock4.wav";

	sound(other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
	stuffcmd(other, "bf\n");

//fire targets, remove the item
	activator = other;
	SUB_UseTargets();	//bdw - note having this here also avoids a bug in the id progs where a dm 2 or coop weapon won't fire it's targets.
	
	if (self.classname == "backpack")
	{
		self.model = string_null;
		self.solid = SOLID_NOT;	
		self.nextthink = time + 0.1;
		self.think = SUB_Remove;
		return;
	}
	
	if (self.items)	//it's a weapon
	{
		if (deathmatch == 2 || coop)	//leave it be
			return;

	}
	
	self.model = string_null;
	self.solid = SOLID_NOT;	

	if (deathmatch == 1)
	{
		self.nextthink = time + 30;
		self.think = SUB_regen;
	}
	else	
	{
		self.nextthink = time + 0.1;
		self.think = SUB_Remove;
	}	
	
};

/*QUAKED weapon_supershotgun (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() weapon_supershotgun =
{
	precache_model("progs/g_shot.mdl");
	setmodel(self, "progs/g_shot.mdl");
	self.netname = "Double-Barrelled Shotgun";

	self.items = IT_SUPER_SHOTGUN;
	self.ammo_shells = 5;
	self.noise = "weapons/pkup.wav";

	self.touch = BDW_AmmoWeaponTouch;
	setsize(self, '-16 -16 0', '16 16 56');
	StartItem();
};

/*QUAKED weapon_nailgun (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() weapon_nailgun =
{
	precache_model("progs/g_nail.mdl");
	setmodel(self, "progs/g_nail.mdl");
	self.netname = "Nailgun";
	
	self.items = IT_NAILGUN;
	self.ammo_nails = 30;
	self.noise = "weapons/pkup.wav";

	self.touch = BDW_AmmoWeaponTouch;
	setsize(self, '-16 -16 0', '16 16 56');
	StartItem();
};

/*QUAKED weapon_supernailgun (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() weapon_supernailgun_precache = 
{
	precache_model("progs/g_nail2.mdl");
};

void() weapon_supernailgun_init =
{
	self.classname = "weapon_supernailgun";

	setmodel(self, "progs/g_nail2.mdl");
	self.netname = "Super Nailgun";
	
	self.items = IT_SUPER_NAILGUN;
	self.ammo_nails = 30;
	self.noise = "weapons/pkup.wav";
	self.touch = BDW_AmmoWeaponTouch;

	setsize(self, '-16 -16 0', '16 16 56');
};

void() weapon_supernailgun =
{
	weapon_supernailgun_precache();
	
	if (AddToItemList(IT_SUPER_NAILGUN))		
		return;
		
	weapon_supernailgun_init();	
	StartItem();
};

/*QUAKED weapon_grenadelauncher (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() weapon_grenadelauncher_precache =
{
	precache_model("progs/g_rock.mdl");
};

void() weapon_grenadelauncher_init =
{
	self.classname = "weapon_grenadelauncher";

	setmodel(self, "progs/g_rock.mdl");
		
	self.netname = "Grenade Launcher";
	self.items = IT_GRENADE_LAUNCHER;
	self.ammo_rockets = 5;
	self.noise = "weapons/pkup.wav";
	self.touch = BDW_AmmoWeaponTouch;

	setsize(self, '-16 -16 0', '16 16 56');
};	

void() weapon_grenadelauncher =
{
	weapon_grenadelauncher_precache();
	
	if (AddToItemList(IT_GRENADE_LAUNCHER))		
		return;
	
	weapon_grenadelauncher_init();
	StartItem();
};

/*QUAKED weapon_rocketlauncher (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() weapon_rocketlauncher_precache =
{
	precache_model("progs/g_rock2.mdl");
};

void() weapon_rocketlauncher_init =
{
	self.classname = "weapon_rocketlauncher";

	setmodel(self, "progs/g_rock2.mdl");

	self.netname = "Rocket Launcher";
	self.items = IT_ROCKET_LAUNCHER;
	self.ammo_rockets = 5;
	self.noise = "weapons/pkup.wav";
	self.touch = BDW_AmmoWeaponTouch;

	setsize(self, '-16 -16 0', '16 16 56');
};

void() weapon_rocketlauncher =
{
	weapon_rocketlauncher_precache();

	if (AddToItemList(IT_ROCKET_LAUNCHER))		
		return;

	weapon_rocketlauncher_init();
	StartItem();
};


/*QUAKED weapon_lightning (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() weapon_lightning_precache =
{
	precache_model("progs/g_light.mdl");
};

void() weapon_lightning_init =
{
	self.classname = "weapon_lightning";
	
	setmodel(self, "progs/g_light.mdl");
	self.netname = "Thunderbolt";

	self.items = IT_LIGHTNING;
	self.ammo_cells = 30;
	self.noise = "weapons/pkup.wav";
	self.touch = BDW_AmmoWeaponTouch;
		
	setsize(self, '-16 -16 0', '16 16 56');
};	

void() weapon_lightning =
{
	weapon_lightning_precache();
	
	if (AddToItemList(IT_LIGHTNING))		
		return;	
	
	weapon_lightning_init();
	StartItem();
};

//bdw - you can call the weapons by their alternate names in maps...
void() weapon_machinegun = {self.classname = "weapon_nailgun"; weapon_nailgun();};
void() weapon_chaingun = {self.classname = "weapon_supernailgun"; weapon_supernailgun();};
void() weapon_plasmagun = {self.classname = "weapon_lightning"; weapon_lightning();};

/*
===============================================================================

AMMO

===============================================================================
*/

float WEAPON_BIG2 = 1;

/*QUAKED item_shells (0 .5 .8) (0 0 0) (32 32 32) big
*/

void() item_shells_init =
{
	self.classname = "item_shells";	//bdw - for spawning

	if (self.spawnflags & WEAPON_BIG2)
		self.ammo_shells = 40;
	else
		self.ammo_shells = 20;

	self.touch = BDW_AmmoWeaponTouch;
	
	if (self.spawnflags & WEAPON_BIG2)
		setmodel(self, "maps/b_shell1.bsp");
	else
		setmodel(self, "maps/b_shell0.bsp");

	setsize(self, '0 0 0', '32 32 56');
};

void() item_shells_precache =
{
	if (self.spawnflags & WEAPON_BIG2)
		precache_model("maps/b_shell1.bsp");
	else
		precache_model("maps/b_shell0.bsp");
};

void() item_shells =
{
	item_shells_precache();

	if (AddToItemList(IT_SHELLS))		
		return;

	item_shells_init();
	StartItem();
};

/*QUAKED item_spikes (0 .5 .8) (0 0 0) (32 32 32) big
*/

void() item_spikes_init =
{
	self.classname = "item_spikes";

	if (self.spawnflags & WEAPON_BIG2)
		self.ammo_nails = 50;
	else
		self.ammo_nails = 25;	

	self.touch = BDW_AmmoWeaponTouch;

	if (self.spawnflags & WEAPON_BIG2)
		setmodel(self, "maps/b_nail1.bsp");
	else
		setmodel(self, "maps/b_nail0.bsp");

	setsize (self, '0 0 0', '32 32 56');
};

void() item_spikes_precache =
{
	if (self.spawnflags & WEAPON_BIG2)
		precache_model("maps/b_nail1.bsp");
	else
		precache_model("maps/b_nail0.bsp");
};

void() item_spikes =
{	
	item_spikes_precache();

	if (AddToItemList(IT_NAILS))		
		return;

	item_spikes_init();	
	StartItem();
};

/*QUAKED item_rockets (0 .5 .8) (0 0 0) (32 32 32) big
*/

void() item_rockets_init =
{
	self.classname = "item_rockets";

	if (self.spawnflags & WEAPON_BIG2)
		self.ammo_rockets = 10;
	else
		self.ammo_rockets = 5;
	
	self.touch = BDW_AmmoWeaponTouch;
	
	if (self.spawnflags & WEAPON_BIG2)
		setmodel(self, "maps/b_rock1.bsp");
	else
		setmodel(self, "maps/b_rock0.bsp");

	setsize (self, '0 0 0', '32 32 56');
};

void() item_rockets_precache =
{
	if (self.spawnflags & WEAPON_BIG2)
		precache_model("maps/b_rock1.bsp");
	else
		precache_model("maps/b_rock0.bsp");
};
	

void() item_rockets =
{
	item_rockets_precache();

	if (AddToItemList(IT_ROCKETS))		
		return;
	
	item_rockets_init();	
	StartItem ();
};


/*QUAKED item_cells (0 .5 .8) (0 0 0) (32 32 32) big
*/

void() item_cells_init =
{
	self.classname = "item_cells";

	if (self.spawnflags & WEAPON_BIG2)
		self.ammo_cells = 12;
	else
		self.ammo_cells = 6;	

	self.touch = BDW_AmmoWeaponTouch;

	if (self.spawnflags & WEAPON_BIG2)
		setmodel(self, "maps/b_batt1.bsp");
	else
		setmodel(self, "maps/b_batt0.bsp");

	setsize (self, '0 0 0', '32 32 56');
};

void() item_cells_precache =
{
	if (self.spawnflags & WEAPON_BIG2)
		precache_model("maps/b_batt1.bsp");
	else
		precache_model("maps/b_batt0.bsp");
};

void() item_cells =
{
	item_cells_precache();

	if (AddToItemList(IT_CELLS))		
		return;

	item_cells_init();	
	StartItem();
};


/*QUAKED item_weapon (0 .5 .8) (0 0 0) (32 32 32) shotgun rocket spikes big
DO NOT USE THIS!!!! IT WILL BE REMOVED!
*/

//bdw - totally rewrote this function

float WEAPON_SHOTGUN = 1;
float WEAPON_ROCKET = 2;
float WEAPON_SPIKES = 4;
float WEAPON_BIG = 8;
void() item_weapon =
{
	local float biggie, shellage, spikeage, rockage;

	if (self.spawnflags & WEAPON_BIG) {biggie = 1;}
	shellage = self.spawnflags & WEAPON_SHOTGUN;
	rockage = self.spawnflags & WEAPON_ROCKET;
	spikeage = self.spawnflags & WEAPON_SPIKES;
		
	self.spawnflags = biggie + self.spawnflags - (self.spawnflags & (WEAPON_SHOTGUN | WEAPON_ROCKET | WEAPON_SPIKES | WEAPON_BIG) );

	if (shellage) {item_shells();return;}
	if (spikeage) {item_spikes();return;}
	if (rockage) {item_rockets();return;}

	remove(self);
};


/*
===============================================================================

KEYS

===============================================================================
*/

void() key_touch =
{
local entity	stemp;
local float		best;

	if (other.classname != "player")
		return;
	if (other.health <= 0)
		return;
	if (other.items & self.items)
		return;

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
		//bdw - if not coop, just remove...
		self.nextthink = time + 0.1;
		self.think = SUB_Remove;
	}

	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};

void() key_setsounds =
{
	if (world.worldtype == 0)
		self.noise = "misc/medkey.wav";
	else if (world.worldtype == 1)
		self.noise = "misc/runekey.wav";
	else if (world.worldtype == 2)
		self.noise = "misc/basekey.wav";
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

void() item_key1_precache =
{
	if (world.worldtype == 0)
	{
		precache_sound ("misc/medkey.wav");
		precache_model ("progs/w_s_key.mdl");
	}
	else if (world.worldtype == 1)
	{
		precache_sound ("misc/runekey.wav");
		precache_model ("progs/m_s_key.mdl");
	}
	else if (world.worldtype == 2)
	{
		precache_sound2 ("misc/basekey.wav");
		precache_model2 ("progs/b_s_key.mdl");
	}
};

void() item_key1_init =
{
	self.classname = "item_key2";

	if (world.worldtype == 0)
	{
		setmodel (self, "progs/w_s_key.mdl");
		self.netname = "silver key";
	}
	else if (world.worldtype == 1)
	{
		setmodel (self, "progs/m_s_key.mdl");
		self.netname = "silver runekey";
	}
	else if (world.worldtype == 2)
	{
		setmodel (self, "progs/b_s_key.mdl");
		self.netname = "silver keycard";
	}
	key_setsounds();
	self.touch = key_touch;
	self.items = IT_KEY1;
	setsize (self, '-16 -16 -24', '16 16 32');
};

void() item_key1 =
{
	item_key1_precache();

	if (AddToItemList(IT_KEY1))		
		return;

	item_key1_init();	
	StartItem ();
};

void() item_key2_precache =
{
	if (world.worldtype == 0)
	{
		precache_sound ("misc/medkey.wav");
		precache_model ("progs/w_g_key.mdl");
	}
	else if (world.worldtype == 1)
	{
		precache_sound ("misc/runekey.wav");
		precache_model ("progs/m_g_key.mdl");
	}
	else if (world.worldtype == 2)
	{
		precache_sound2 ("misc/basekey.wav");
		precache_model2 ("progs/b_g_key.mdl");
	}
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

void() item_key2_init =
{
	self.classname = "item_key2";

	if (world.worldtype == 0)
	{
		setmodel (self, "progs/w_g_key.mdl");
		self.netname = "gold key";
	}
	else if (world.worldtype == 1)
	{
		setmodel (self, "progs/m_g_key.mdl");
		self.netname = "gold runekey";
	}
	else if (world.worldtype == 2)
	{
		setmodel (self, "progs/b_g_key.mdl");
		self.netname = "gold keycard";
	}
	key_setsounds();
	self.touch = key_touch;
	self.items = IT_KEY2;
	setsize (self, '-16 -16 -24', '16 16 32');
};

void() item_key2 =
{
	item_key2_precache();

	if (AddToItemList(IT_KEY2))		
		return;

	item_key2_init();	
	StartItem ();
};


/*
===============================================================================

END OF LEVEL RUNES

===============================================================================
*/

void() sigil_touch =
{
local entity	stemp;
local float		best;

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

//bdw - made item remove self in sp...	
	else
	{
		self.nextthink = time + 0.1;
		self.think = SUB_Remove;
	}

	sound (other, CHAN_VOICE, self.noise, 1, ATTN_NORM);
	stuffcmd (other, "bf\n");
	self.solid = SOLID_NOT;
	other.items = other.items | self.items;
	self.model = string_null;

// do the apropriate action
	if (self.classname == "item_artifact_super_damage")
	{
		other.super_time = 1;
		other.super_damage_finished = time + 30;
	}
	else if (self.classname == "item_artifact_invulnerability")
	{
		other.invincible_time = 1;
		other.invincible_finished = time + 30;
	}
	else if (self.classname == "item_artifact_invisibility")
	{
		other.invisible_time = 1;
		other.invisible_finished = time + 30;
	}
	else if (self.classname == "item_artifact_envirosuit")
	{
		other.rad_time = 1;
		other.radsuit_finished = time + 30;
	}	

	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};



/*QUAKED item_artifact_invulnerability (0 .5 .8) (-16 -16 -24) (16 16 32)
Player is invulnerable for 30 seconds
*/
void() item_artifact_invulnerability =
{
	self.touch = powerup_touch;

	precache_model ("progs/invulner.mdl");
	precache_sound ("items/protect.wav");
	precache_sound ("items/protect2.wav");
	precache_sound ("items/protect3.wav");
	self.noise = "items/protect.wav";
	setmodel (self, "progs/invulner.mdl");
	self.netname = "Pentagram of Protection";
	self.items = IT_INVULNERABILITY;
	setsize (self, '-16 -16 -24', '16 16 32');
	StartItem ();
};

/*QUAKED item_artifact_envirosuit (0 .5 .8) (-16 -16 -24) (16 16 32)
Player takes no damage from water or slime for 30 seconds
*/
void() item_artifact_envirosuit =
{
	self.touch = powerup_touch;

	precache_model ("progs/suit.mdl");
	precache_sound ("items/suit.wav");
	precache_sound ("items/suit2.wav");
	self.noise = "items/suit.wav";
	setmodel (self, "progs/suit.mdl");
	self.netname = "Biosuit";
	self.items = IT_SUIT;
	setsize (self, '-16 -16 -24', '16 16 32');
	StartItem ();
};


/*QUAKED item_artifact_invisibility (0 .5 .8) (-16 -16 -24) (16 16 32)
Player is invisible for 30 seconds
*/
void() item_artifact_invisibility =
{
	self.touch = powerup_touch;

	precache_model ("progs/invisibl.mdl");
	precache_sound ("items/inv1.wav");
	precache_sound ("items/inv2.wav");
	precache_sound ("items/inv3.wav");
	self.noise = "items/inv1.wav";
	setmodel (self, "progs/invisibl.mdl");
	self.netname = "Ring of Shadows";
	self.items = IT_INVISIBILITY;
	setsize (self, '-16 -16 -24', '16 16 32');
	StartItem ();
};


/*QUAKED item_artifact_super_damage (0 .5 .8) (-16 -16 -24) (16 16 32)
The next attack from the player will do 4x damage
*/
void() item_artifact_super_damage =
{
	self.touch = powerup_touch;

   precache_model ("progs/quaddama.mdl");
	precache_sound ("items/damage.wav");
	precache_sound ("items/damage2.wav");
	precache_sound ("items/damage3.wav");
	self.noise = "items/damage.wav";
	setmodel (self, "progs/quaddama.mdl");
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


/*
===============
DropBackpack
===============
*/
void() DropBackpack =
{
	local entity	item;

	if (!(self.ammo_shells + self.ammo_nails + self.ammo_rockets + self.ammo_cells))
		return;	// nothing in it

	item = spawn();
	item.classname = "backpack";	//bdw
	item.origin = self.origin - '0 0 24';

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
	setmodel (item, "progs/backpack.mdl");
	setsize (item, '-16 -16 0', '16 16 56');
	item.touch = BDW_AmmoWeaponTouch;

	item.nextthink = time + 120;	// remove after 2 minutes
	item.think = SUB_Remove;
};

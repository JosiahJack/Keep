void() quoth_powerup_touch =
{
local entity		stemp;
local float		best;

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

		self.nextthink = time + 60;
		self.think = SUB_regen;
	}

	sound (other, CHAN_VOICE, self.noise, 1, ATTN_NORM);
	stuffcmd (other, "bf\n");
	self.solid = SOLID_NOT;
   	other.items2 = other.items2 | self.items2;  //use items2 cause no more room for bitflags on items.
	self.model = string_null;

	// turn on the powerups...
	if ( self.classname == "item_artifact_trinity" )
	{
		other.trinity_time = 1;
		other.trinity_finished = time + 30;
		other.trinity_start = 1;
	}
	if ( self.classname == "item_artifact_cross" )
	{
		other.cross_time = 1;
		other.cross_start = 1;
		other.cross_finished = time + 30;
	}

	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};


/*QUAKED item_artifact_trinity (0 .5 .8) (-16 -16 -24) (16 16 32)
Multiplies damage done by nails by 3.
*/
void() item_artifact_trinity =
{
	self.touch = quoth_powerup_touch;

	precache_model ("progs/trinity.mdl");
	precache_sound ("items2/trintake.wav");
	precache_sound ("items2/trinuse.wav");
	precache_sound ("items2/trinend.wav");
	self.noise = "items2/trintake.wav";
	setmodel (self, "progs/trinity.mdl");
	self.netname = "Trinity";
	self.items2 = IT_TRINITY;
	setsize (self, '-16 -16 -24', '16 16 32');

	StartItem ();
};


/*QUAKED item_artifact_cross_of_deflection (0 .5 .8) (-16 -16 -24) (16 16 32)
Multiplies damage done by nails by 3.
*/
void() item_artifact_cross =
{
	self.touch = quoth_powerup_touch;

	precache_model ("progs/cross.mdl");
	precache_sound ("items2/crostake.wav");
	precache_sound ("items2/crosend.wav");
	self.noise = "items2/crostake.wav";
	setmodel (self, "progs/cross.mdl");
	self.netname = "Cross of Deflection";
	self.items2 = IT_CROSS;
	setsize (self, '-16 -16 -24', '16 16 32');

	StartItem ();
};








//================================================




void() hammer_touch =
{
	local	float	hadammo, best, new, old_item;
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
	
	if (leave && (other.items2 & IT_HAMMER) )
		return;
	hadammo = other.ammo_nails;			

	sprint (other, "You got the Hammer\n");
	// weapon touch sound
	sound (other, CHAN_ITEM, "weapons/pkup.wav", 1, ATTN_NORM);
	stuffcmd (other, "bf\n");

	bound_other_ammo ();

// change to the weapon
	old_item = other.items;
	other.items2 = other.items2 | IT_HAMMER;
	
	stemp = self;
	self = other;

	if (!deathmatch)
		self.weapon = IT_AXE;
	else
		Deathmatch_Weapon (old_item, new);

	W_SetCurrentAmmo();

	self = stemp;

	if (leave)
		return;

// remove it in single player, or setup for respawning in deathmatch
	self.model = string_null;
	self.solid = SOLID_NOT;
	if (deathmatch == 1)
		self.nextthink = time + 30;
	self.think = SUB_regen;
	
	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};


/*QUAKED weapon_warhammer (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() weapon_hammer =
{
	precache_model ("progs/g_ham.mdl");
	setmodel (self, "progs/g_ham.mdl");
	self.touch = hammer_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};
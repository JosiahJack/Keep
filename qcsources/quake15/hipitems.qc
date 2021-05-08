/*
===============================================================================

HIPNOTIC ITEMS

===============================================================================
*/
//
// hip_powerup_touch function
//
void() hip_powerup_touch =
{
local entity	stemp;
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

//      if ((self.classname == "item_artifact_invulnerability") ||
//         (self.classname == "item_artifact_invisibility"))
//         self.nextthink = time + 60*5;
//      else
      self.nextthink = time + 60;

		self.think = SUB_regen;
	}

	sound (other, CHAN_VOICE, self.noise, 1, ATTN_NORM);
	stuffcmd (other, "bf\n");
	self.solid = SOLID_NOT;
	other.items = other.items | self.items;
	self.model = string_null;

// do the apropriate action
   if ( self.classname == "item_artifact_envirosuit" && self.dmg == 1 )
	{
		other.wetsuit_time = 1;
		other.wetsuit_finished = time + 30;
	}
   /*if ( self.classname == "item_artifact_empathy_shields" )
	{
      other.empathy_time = 1;
      other.empathy_finished = time + 30;
	}*/

	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};


/*QUAKED item_artifact_wetsuit (0 .5 .8) (-16 -16 -24) (16 16 32)
Player takes no damage from electrical attacks and swims faster for 30 seconds
*/
void() item_artifact_wetsuit =
{
   
   self.dmg = 1;
   item_artifact_envirosuit();
};

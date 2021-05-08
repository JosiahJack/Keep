void() trigger_void_touch =
{

	//bprint ("void\n");
	if (other.classname == "monster_vermis")
		return;


	if (other.takedamage)
	{
		if (other.shield == 1)
			T_Damage (other, self, self, other.health * 2 + 1);
		else
			T_Damage (other, self, self, other.health + 1);

		if (other.flags & FL_MONSTER)
		{
			remove(other);
			force_retouch = 2;
			return;
		}
	}

	if (other.classname == "gib" || other.classname == "grenade" || other.classname == "spike" || other.classname == "missile")
	{
		remove(other);
		force_retouch = 2;
		return;
	}

	if (other.flags & FL_ITEM)
		remove(other);

	force_retouch = 2;

};

/*QUAKED trigger_void (.5 .5 .5) ?
Use this for a 'void' area.  removes monsters, gibs, ammo, etc...  also kills player.
*/
void() trigger_void =
{
	InitTrigger ();
	self.touch = trigger_void_touch;
};




float (entity owner, entity item) Put_Item_Into_Inventory;


float (float f, float default) NonZero =
{
	if (!f)
		return default;
	else
		return f;
};


/* Less than interesting way to pickup items at the moment */

void() WpnTouch =
{
	if (other.classname != "player" || self.attack_finished > time)
			return;
			
	float f;
				
	 f = Put_Item_Into_Inventory(other, self);

	 if (f == TRUE)	//	successfully put in.
	 {
	 
	// other.weaponmodel = self.v_model;
	//	Do Equipping things here
		remove (self);
		
	 }	
};

void (entity ent) Inherit_Weapon_Base =
{
	ent.itemtype = "weapon";
	ent.maxammo = ent.currentammo;

	ent.weight = NonZero (ent.weight, 1);
	ent.durability = NonZero (ent.durability, 1);
	ent.maxdurability = NonZero (ent.maxdurability, ent.durability);		
};

void (entity ent) Materialize_Weapon_Base =
{

	ent.solid = SOLID_TRIGGER;
	ent.movetype = MOVETYPE_TOSS;
	ent.touch = WpnTouch;	

	if (ent.w_model == "")
	{
		print ("^1ERROR: Materialize_Weapon_Base() Item has no w_model, removing\n");
		remove (ent);	return;
	}
	else
	{
		setmodel (ent, ent.w_model);	
	}	

};
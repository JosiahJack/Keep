/* Less than interesting way to pickup items at the moment */

void() ArmorTouch =
{
	if (other.classname != "player" || self.attack_finished > time)
			return;
			
	float f;
				
	 f = Put_Item_Into_Inventory(other, self);

	 if (f == TRUE)	//	successfully put in.
	   remove (self);
		
	
};

void (entity ent) Inherit_Armor_Base =
{
	ent.itemtype = "armor";


	ent.weight = NonZero (ent.weight, 1);
	ent.durability = NonZero (ent.durability, 1);
	ent.maxdurability = NonZero (ent.maxdurability, ent.durability);		
};

void (entity ent) Materialize_Armor_Base =
{

	ent.solid = SOLID_TRIGGER;
	ent.movetype = MOVETYPE_TOSS;
	ent.touch = ArmorTouch;	

	if (ent.w_model == "")
	{
		print ("^1ERROR: Materialize_Armor_Base() Item has no w_model, removing\n");
		remove (ent);	return;
	}
	else
	{
		setmodel (ent, ent.w_model);	
	}	

};
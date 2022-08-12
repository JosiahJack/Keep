/*=======================
Example Item for inventory
	'08 
========================*/


/* animation sequences */


//------




/* Logical entity */

void(entity ent) LArmor_Yellow =
{	
	precache_model ("models/armor/armor.mdl");

	
	ent.w_model = "models/armor/armor.mdl";
	
	ent.durability  = 50;
	ent.weight      = 20;
	ent.itempic	    = "armor_y";
	ent.netname     = "Yellow Armor";
	ent.inv_item_size = '4 3 0';

	
	
	Inherit_Armor_Base (ent);	
};

/* Physical entity once materialized */

void() Armor_Yellow =
{

	local entity ent;
	ent = spawn();
	
	setorigin (ent, self.origin);
	ent.angles = self.angles;
	
	LArmor_Yellow(ent);
	
	Materialize_Armor_Base(ent);

};
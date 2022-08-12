/*=======================
Example Weapon for inventory
	'08 
========================*/
float (entity owner, entity item) Put_Item_Into_Inventory;

float (float f, float def) NonZero =
{
	if (!f)
		return def;
	else
		return f;
};

/* animation sequences */

ANIM shotgun_idle =  '0 0 1';
ANIM shotgun_shoot =  '1 8 0.1';

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

void() LWpn_DBShotgun_PrimaryFire =
{
	if (self.attack_finished > time)
			return;
			
	print ("Bam!\n");		
			
//	self.currentweapon.currentammo--;
//	etc etc...			
			
			
	self.attack_finished = time + 1;
};

void() Wpn_DBShotgun =
{

	local entity ent;

	precache_model ("models/dbshotgun/v_shot2.mdl");
	precache_model ("models/dbshotgun/g_shot.mdl");

	ent = spawn();
	setorigin (ent, self.origin);
	ent.angles = self.angles;
	ent.v_model = "models/dbshotgun/v_shot2.mdl";
	ent.w_model = "models/dbshotgun/g_shot.mdl";
	ent.currentammo =  8;
	ent.durability  = 10;
	ent.weight      = 17;
	ent.itempic	    = "dbshotgun";
	ent.netname     = "Double Barreled Shotgun";
	ent.inv_item_size = '1 4 0';
	ent.PrimaryFire = LWpn_DBShotgun_PrimaryFire;
	ent.itemtype = "weapon";
	ent.maxammo = ent.currentammo;
	ent.weight = NonZero (ent.weight, 1);
	ent.durability = NonZero (ent.durability, 1);
	ent.maxdurability = NonZero (ent.maxdurability, ent.durability);
	ent.solid = SOLID_TRIGGER;
	ent.movetype = MOVETYPE_TOSS;
	ent.touch = WpnTouch;
	setmodel (ent, ent.w_model);

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
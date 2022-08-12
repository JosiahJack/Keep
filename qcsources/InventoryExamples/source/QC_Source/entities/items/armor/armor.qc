/*=======================
Example Weapon for inventory
	'08 
========================*/


/* animation sequences */

ANIM shotgun_idle =  '0 0 1';
ANIM shotgun_shoot =  '1 8 0.1';



void() LWpn_DBShotgun_PrimaryFire =
{
	if (self.attack_finished > time)
			return;
			
	print ("Bam!\n");		
			
//	self.currentweapon.currentammo--;
//	etc etc...			
			
			
	self.attack_finished = time + 1;
};


/* Logical entity */

void(entity ent) LWpn_DBShotgun =
{	
	precache_model ("models/dbshotgun/v_shot2.mdl");
	precache_model ("models/dbshotgun/g_shot.mdl");
	

	ent.v_model = "models/dbshotgun/v_shot2.mdl";
	ent.w_model = "models/dbshotgun/g_shot.mdl";
	
	ent.currentammo =  8;
	ent.durability  = 10;
	ent.weight      = 17;
	ent.itempic	    = "dbshotgun";
	ent.netname     = "Double Barreled Shotgun";
	ent.inv_item_size = '1 4 0';
	ent.PrimaryFire = LWpn_DBShotgun_PrimaryFire;
	
	
	Inherit_Weapon_Base (ent);	
};

/* Physical entity once materialized */

void() Wpn_DBShotgun =
{

	local entity ent;
	ent = spawn();
	
	setorigin (ent, self.origin);
	ent.angles = self.angles;
	
	LWpn_DBShotgun(ent);
	
	Materialize_Weapon_Base(ent);

};
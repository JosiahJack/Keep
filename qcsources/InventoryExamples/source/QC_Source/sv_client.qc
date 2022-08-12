 
 void() precaches;
 
 
  void() GetImpulses =
 {
 local float f;
 
	if (self.impulse == 30)
	{
		if (self.ToggleInventory == TRUE)
		{
			self.ToggleInventory = FALSE;
			self.impulse = 0;
			return;
		}
		if (self.ToggleInventory == FALSE)
		{
			self.ToggleInventory = TRUE;
			self.impulse = 0;
			return;
		}	
	}
 
	if (self.impulse == 31)	// Quick test for putting items into inventory
	if (self.attack_finished < time)
	{
	local entity TestItem;
	TestItem = spawn();
	//LWpn_DBShotgun(TestItem);
	LArmor_Yellow(TestItem);
	f = Put_Item_Into_Inventory (self, TestItem);

	if (f == FALSE)
		remove(TestItem);

	
	}
 
	self.impulse = 0;
 };
 
 
 
 void() ClientConnect = 
 {
	Inv_Init ();
 };
 
  void() ClientKill = {};
 void() ClientDisconnect = {};
 
 
 void() PlayerPreThink = 
 {	
 
 GetImpulses ();

 };
 
 
 void() PlayerPostThink = {};
 
 
 
void() PutClientInServer =
{
local entity spawn_spot;            
spawn_spot = find (world, classname, "info_player_start"); 

self.classname = "player";           
self.health = self.max_health = 100; 
self.takedamage = DAMAGE_AIM;       
self.solid = SOLID_SLIDEBOX;      
self.movetype = MOVETYPE_WALK;       
self.flags = FL_CLIENT;             

self.origin = spawn_spot.origin + '0 0 1'; 
self.angles = spawn_spot.angles;    
self.fixangle = TRUE;              

setmodel (self, "models/plyr/m/male01.dpm");
setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
self.view_ofs = '0 0 28';          
self.velocity = '0 0 0';            
};
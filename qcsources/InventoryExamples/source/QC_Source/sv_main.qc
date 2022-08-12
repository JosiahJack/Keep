void() LightStyles_setup; 
void() precaches;

void() main = {};


void() CSQC_AddStats =
{	
	
	SV_AddStatFloat(36, 8, ToggleInventory);
	//SV_AddStatString(40, 1, csqcslot1);	
	
	
	
	
};
 
 
void() worldspawn = 
{
CSQC_AddStats ();

precaches(); 
LightStyles_setup();


};
 
 
 void() SetNewParms = {};
 void() SetChangeParms = {};
 void() StartFrame = {};
 
 
void() precaches =
{
 precache_model ("models/plyr/m/male01.dpm");
 precache_model ("models/null.md3");

};
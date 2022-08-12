.float Version;
.float() SendEntity;
float MSG_ENTITY = 5;

float BUTTON_ATTACK = 1;
float BUTTON_JUMP = 2;
float BUTTON_3 = 4;
float BUTTON_4 = 8;
float BUTTON_5 = 16;
float BUTTON_6 = 32;
float BUTTON7 = 64;
float BUTTON8 = 128;
float BUTTON_USE = 256;
float BUTTON_CHAT = 512;
float BUTTON_PRYDONCURSOR = 1024;
float BUTTON_9 = 2048;
float BUTTON_10 = 4096;
float BUTTON_11 = 8192;
float BUTTON_12 = 16384;
float BUTTON_13 = 32768;
float BUTTON_14 = 65536;
float BUTTON_15 = 131072;
float BUTTON_16 = 262;

#define ANIM vector
#define object entity


float INVNONE = -1;


float INV_ROWSIZE = 10;
float INV_COLUMNSIZE = 5;
#define INV_SLOTS  INV_ROWSIZE*INV_COLUMNSIZE

.float currentammo;

enum {

	SEND_INV, SEND_WPN, SEND_3DHUD

	 };


//==========
//
//==========
.float ToggleInventory;	// toggle for on / off
float SaveMouseMove;	// used to save info about setwantsmove()
	

string StoreItempic;

float CurrentlyHighlightedID;	// client side hovered over object ID.





//=========================
object InvContainer, CursorContainer;

float inventory_initialised;
.float initialised;
.vector handle;
.vector border_lip;

.float() collision;

string icon_dir = "gfx/hud/items/";
string slot_pic = "gfx/hud/slot";
string cursor_pic = "gfx/hud/cursor";
vector ICON_SIZE = '35 35 0';	//	size of slots
vector CURSOR_SIZE = '20 20 0'; //	size of cursor
//=========================

entity DummyEnt;	// Store dummy values in
entity ItemLink;	// Used to link dragging item to cursor

.entity inventory[INV_SLOTS];	// server side of inventory.
entity cl_inventory[INV_SLOTS];	// client side of inventory.



	




/*
=====
 Item specific
-----
*/

.float maxammo;
.float weight;
.float durability, maxdurability;

.string v_model, w_model;	//view and world models.

.void() PrimaryFire;	// holds item firing function
.vector inv_item_size;

.float slotnumber;
.float pointsto;	// used to point back to data container of item. 
					// is -1 when slot is not in use
.string itemtype;
.string itempic;
.string netname;					
/*
====

----
*/



void(entity ent) UpdateSharedEnt =
{
	ent.Version++;
};

void() InitialUpdateSharedEnt =
{
	self.Version++;
};

float(float num) GetHundreds =
{
   float f;
   f = floor(num * 0.01);
   f = f - (floor(f * 0.1) * 10);
   return f;
};

float(float num) GetTens =
{
   float f;
   f = floor(num * 0.1);
   f = f - (floor(f * 0.1) * 10);
   return f;
};

float(float num) GetOnes =
{
   float f;
   f = num;
   f = f - (floor(f * 0.1) * 10);
   return f;
}; 

string(string dst, string src) zonecpy = 
{
	string	s;

	if(src != "")
		s = strzone(src);
	else
		s = "";
	
	if(dst != "")
		strunzone(dst);

	return s;
}

//	AddStats to send svqc frequently changed values to csqc

void(float index, float type, .float) SV_AddStatFloat = #232;
void(float index, float type, .string) SV_AddStatString = #232;


// Used to grab dimensions of items based on the
// naming scheme. In Example:
// 44scimitar would load a 4x4 sized image that stretches right 4 slots
// and down 4 slots relevant to the top left corner of the item.
/* DEPRECATED */

// simply have it send to client the inv_item_size to determine.

float (string pic) GetItempicX =
{
   float f;
   f = stof (pic);
   f = GetTens(f);
   return f;
};

float (string pic) GetItempicY =
{
   float f;
   f = stof (pic);
   f = GetOnes(f);
   return f;
};
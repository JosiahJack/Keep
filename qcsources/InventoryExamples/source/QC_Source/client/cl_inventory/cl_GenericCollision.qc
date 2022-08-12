
// y up is less
// x left is less
// full right is 640

vector MOUSECOORD = '640 480 0';	// mouse coord offset.

vector cursor_drag_offset;
float IsDragging;


/*
	Grabs 2dvector of mouse on screen
*/

vector() GetCursorPos =
{
	local vector pos, vid_size;
		
	vid_size_x = cvar("vid_conwidth");
	vid_size_y = cvar("vid_conheight");
			
	pos = vid_size*0.5 + getmousepos();
	
		return pos;
};

/* ====================================

	ReturnInvEntity ~ 
		Returns entity specified with index of array
	
	ReturnInvObject ~
		Returns object/item's data container as pointed
		to at the index of the array.
	

======================================= */

entity (float slotnum) ReturnInvEntity =
{
	if (slotnum == INVNONE)
		return DummyEnt;
		
	if (slotnum >= 0 && slotnum < INV_SLOTS)
		return (cl_inventory[slotnum]);
};

entity (float slotnum) ReturnInvObject =
{
	local entity ent;

	if (slotnum >= 0 && slotnum < INV_SLOTS)
		ent = (cl_inventory[slotnum]);
		
		if (ent.pointsto == INVNONE)
			return DummyEnt;
		
		return (cl_inventory[ent.pointsto]);
		
};

/*
	CheckDragging is currently so utterly specific to inventory
	however is easily extendable. This is in control of dragging
	borders of containers and dragging items within them.

*/

void(object Container, vector pos, float Isntborder) CheckDragging =
{

	local float chl, available;
	local string s;
	local entity e, slot;
	
	chl = CurrentlyHighlightedID;


	if (input_buttons==0)	// All buttons released
	{
		if (ItemLink.slotnumber != INVNONE)
		{
		//print (StoreItempic, ", De-linking.. StoreItempic\n");
		
			ItemLink.itempic = StoreItempic;	// reset item's image
			StoreItempic = "";					// empty storing of item string
			
			ItemLink = DummyEnt;				// de-link item to ItemLink
			ItemLink.slotnumber = INVNONE;	    // de-link item to cursor
		}	
		IsDragging = 0;
	}	
		
	if (input_buttons & BUTTON_ATTACK && ItemLink.slotnumber == INVNONE)
	{	
	
		slot = ReturnInvEntity(chl);

		pos = GetCursorPos();
		
		if (Isntborder == true)	// not on border.
		{
				if (slot.pointsto == INVNONE)
						return;
				
		// Link item to cursor

			if ((chl >= 0 && chl < INV_SLOTS) && ItemLink.slotnumber == INVNONE )
			{
			ItemLink = ReturnInvObject(CurrentlyHighlightedID);
								
			StoreItempic = ItemLink.itempic;
			
		//print (StoreItempic, ", linking.. StoreItempic\n");
		//print ("ItemLink.slotnumber: ", ftos(ItemLink.slotnumber), "\n");
			
			ItemLink.itempic = "empty";
			}
		}
		else // on border, drag container.
		{
			if (!IsDragging)
			{
			cursor_drag_offset_x = pos_x - Container.handle_x;
			cursor_drag_offset_y = pos_y - Container.handle_y;		
				IsDragging = 1;
			}	
			Container.handle_x = pos_x - cursor_drag_offset_x;	
			Container.handle_y = pos_y - cursor_drag_offset_y;		
		}
		
	}		
};

/* Preliminary check to make sure cursor is within Container box */

/*
Check_Container_Collision()

Pass in the container entity and do a specific check (at the moment) against
inventory slots by seeing if the cursor is outside of the block of slots.

add border for additional padding around the inventory

*/

float (object Container, vector pos, vector border) Check_Container_Collision =
{
	if ((Container.handle_x - border_x) >= pos_x)	// left of inventory
				return false;

	if ((Container.handle_x + (INV_ROWSIZE*ICON_SIZE_x) + border_x) <= pos_x)	// right of inventory
				return false;				

	if ((Container.handle_y - border_y) >= pos_y)	// above inventory
				return false;
				
	if ((Container.handle_y + (INV_COLUMNSIZE*ICON_SIZE_y) + border_y) <= pos_y)	// below inventory
				return false;	

				return true;
};

float (float pcoll) ReturnCollision =
{

	if (pcoll == INVNONE)
		return false;

		return true;
};


/*============================
 Main collision check 
 =============================*/

float (vector pos) Check_Cursor_Collision =
{

	local float GetCollision;	
	
	GetCollision = InvContainer.collision();
	
	//if (!ReturnCollision(GetCollision))		// GetCollision returned INVNONE, so check other containers.
	//GetCollision = ExampleContainer.collision();

	/*
	Its best to make sure you're rendering each container
	in the same order you're checking their collisions.
	This allows you to overlay windows on top of eachother without
	collision issues for the most part.
	*/
	
	return GetCollision;
	
}
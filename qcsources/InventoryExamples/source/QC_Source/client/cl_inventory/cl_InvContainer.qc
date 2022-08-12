
/*
	InvContainer specific collisions
	---
	All collisions called from 
	Check_Cursor_Collision() in cl_GenericCollision.qc
*/

float() Inventory_Collision =
{

	local float Rowpos, Colpos, InvCollChk, InvBorderChk;
	local vector pos;
	
	pos = GetCursorPos();
	pos_x -= MOUSECOORD_x;
	
	
	InvCollChk = Check_Container_Collision (InvContainer, pos, InvContainer.border_lip);	
	// check if within inventory + borders
		
	if (InvCollChk == true)
	{
	
	InvBorderChk = Check_Container_Collision (InvContainer, pos, '0 0 0');	// check if on borders
																// false if not on inventory, but on borders.
		CheckDragging (InvContainer, pos, InvBorderChk);		// therefore check if dragging borders.
	}
	
	if (InvBorderChk == false)	// is on borders so skip slot calculations.
			return INVNONE;
			
	if ((InvBorderChk + InvCollChk) == false)	// not on any of inventory, skip.
			return INVNONE;
	
	Rowpos = ceil((InvContainer.handle_x - pos_x)/ICON_SIZE_x);
	Colpos = ceil((InvContainer.handle_y - pos_y)/ICON_SIZE_y);
	
	return (fabs((Colpos*INV_ROWSIZE) + Rowpos));	
}


/*
	Initialize Inventory Container
*/

void() InvContainer_Init =
{
	local float i;
		
	for (i = 0; i < INV_SLOTS; i++)
	{
		cl_inventory[i] = spawn();
		cl_inventory[i].itempic = strzone("empty");
		cl_inventory[i].slotnumber = i;
		cl_inventory[i].pointsto = -1;
	}
	
	InvContainer = spawn();

	InvContainer.handle = '-600 100 0';	//	initial origin of inventory 
    InvContainer.border_lip  = '15 15 0';	//  the lip of the border on inventory you can drag it with.
	InvContainer.collision = Inventory_Collision;	//	collision on this container

	
	InvContainer.initialised = true;
	
};

/*
	Update slots from svqc here
*/

void (float isnew, float ShouldIgnore) Update_Slot =
{
	local float i;
	local entity slot;

	i = ReadByte();
	slot = cl_inventory[i];

		
	slot.pointsto = ReadByte();
	
//	print (ftos(slot.pointsto), " ~ pointsto\n");
	
	if (slot.pointsto == 255)	
		slot.pointsto = -1;
	
	
	slot.itemtype = "";
	slot.itemtype = zonecpy(slot.itemtype, ReadString());
	slot.itempic = "";
	slot.itempic = zonecpy(slot.itempic, ReadString());
	slot.netname = "";
	slot.netname = zonecpy(slot.netname, ReadString());
	
	
	slot.inv_item_size_x = ReadByte();
	slot.inv_item_size_y = ReadByte();
	
	slot.durability = ReadByte();
	slot.weight = ReadByte();
	slot.currentammo = ReadByte();
	
};




void (entity ent, float pnum) Draw_Slot =
{
	local vector org;
	local entity hl;
	
	org_x =  InvContainer.handle_x + (GetOnes(pnum)*ICON_SIZE_x);
	org_y =  InvContainer.handle_y + (GetTens(pnum)*ICON_SIZE_y);
	
	hl = ReturnInvEntity(CurrentlyHighlightedID);
	
	if (ItemLink.slotnumber == INVNONE)
	{
	if (CurrentlyHighlightedID == pnum || (ent.pointsto == hl.pointsto && hl.pointsto != INVNONE && CurrentlyHighlightedID != INVNONE))
		drawpic('1 0 0'*vid_width + org,  slot_pic, ICON_SIZE, '10 0 0', 1, 0);	
	else
		drawpic('1 0 0'*vid_width + org,  slot_pic, ICON_SIZE, '1 1 1', 1, 0);		
	}
	else
	{
	if (CurrentlyHighlightedID == pnum)
		drawpic('1 0 0'*vid_width + org,  slot_pic, ICON_SIZE, '10 0 0', 1, 0);	
	else
		drawpic('1 0 0'*vid_width + org,  slot_pic, ICON_SIZE, '1 1 1', 1, 0);		
	}
	
};



vector (entity ent, float pnum, string pic) Draw_Item =
{
	local float i, x, y;
	local vector org, isize;
	local string picname;
	
	x = INV_ROWSIZE;
	y = INV_COLUMNSIZE;

	picname = strcat(icon_dir, pic);

	org_x =  InvContainer.handle_x + (GetOnes(pnum)*ICON_SIZE_x);
	org_y =  InvContainer.handle_y + (GetTens(pnum)*ICON_SIZE_y);
	
	isize_x = ICON_SIZE_x*ent.inv_item_size_x;
	isize_y = ICON_SIZE_y*ent.inv_item_size_y;
	
	drawpic('1 0 0'*vid_width + org,  picname, isize, '1 1 1', 1, 0);
};


void() Draw_FillerBorder =
{
	local vector border, org;
	
	org_x = InvContainer.handle_x - InvContainer.border_lip_x;
	org_y = InvContainer.handle_y - InvContainer.border_lip_y;
	
	border_x = INV_ROWSIZE*ICON_SIZE_x + InvContainer.border_lip_x*2;
	border_y = INV_COLUMNSIZE*ICON_SIZE_y + InvContainer.border_lip_y*2;	
	
	drawfill ('1 0 0'*vid_width + org, border, '0 0 0', 1.0, 0);
};



void() Render_Inventory =
{
	if (!InvContainer.initialised)
			return;

	local float i;
	local entity slot;
	local vector v;
	
	Draw_FillerBorder();
	
	for (i = 0; i < INV_SLOTS; i++)
	{
		slot = cl_inventory[i];	
		Draw_Slot (slot, i);	
	}
	for (i = 0; i < INV_SLOTS; i++)
	{
		slot = cl_inventory[i];	
		
		if (slot.itempic != "empty")	
			Draw_Item (slot, i, slot.itempic);
	}		
};











/*
	Initialize Cursor Container
*/

void() CursorContainer_Init =
{
		
	CursorContainer = spawn();

	DummyEnt = spawn();
	DummyEnt.slotnumber = INVNONE;
	DummyEnt.pointsto   = INVNONE;
	DummyEnt.itempic    = "empty";
	
	ItemLink = spawn();
	ItemLink.slotnumber = INVNONE;
	ItemLink = DummyEnt;

	
	CursorContainer.initialised = 1;
	
};

/*
	Draw item attributes when highlighting them
*/


void (object ent, vector curpos) Draw_ItemDetails =
{

	if (ent == DummyEnt)
		return;

	float increment;
	string s;
	
	increment = 10;

	curpos_y += increment;	
	
	drawstring(curpos, ent.netname, '9 9 0', '2 1 0', 1, 0);
	
	curpos_y += increment*1.5;	// slightly more space since netname text is bigger.
	
	s = strcat("Dur: ", ftos(ent.durability));
	drawstring(curpos, s, '7 7 0', '2 1 1', 1, 0);
	
	curpos_y += increment;
	
	s = strcat("Wt: ", ftos(ent.weight));
	drawstring(curpos, s, '7 7 0', '2 1 1', 1, 0);	

};


/*
	Render cursor but also calls main collision loop:
	Check_Cursor_Collision() in cl_GenericCollision.qc
*/


void() Cursor_BtnRelease_Interact =
{
	local float available;

	if (ItemLink.slotnumber == INVNONE)	// cursor not linked to any item
			return;

		if (CurrentlyHighlightedID == INVNONE)	//	not highlighting any slots, drop item into world
		{
			print ("ItemLink.slotnumber: ", ftos(ItemLink.slotnumber), "\n");
			
			ItemLink.itempic = "empty";	// de-link anyways
			localcmd ("cmd inv_DropItem ", ftos(ItemLink.slotnumber), "\n");		
			StoreItempic = "empty";
			ItemLink = DummyEnt;	
			ItemLink.slotnumber = INVNONE;
		}
		
		if (CurrentlyHighlightedID != INVNONE)	//	move item into highlighted inventory
		{
		
			available = CheckAvailableSpace(ItemLink, CurrentlyHighlightedID);	// shared/functions.qc

			if (available == true)
			{
			
			print ("^3available was true!\n");
			
				if (ItemLink.slotnumber != CurrentlyHighlightedID)
				{
				ItemLink.itempic = "empty";	// de-link anyways
				StoreItempic = "empty";
				
				localcmd ("cmd inv_MoveItem ", ftos(ItemLink.slotnumber), " ");		
				localcmd (ftos(CurrentlyHighlightedID), "\n");	//inv_moveitem-from-to
				}
			
			}
		}				



};

void() Render_Cursor =
{


	if (!CursorContainer.initialised)
			return;

	local vector v, curpos;
	local string s;
	local entity e;
	
	curpos = GetCursorPos();

	if (ItemLink.slotnumber == INVNONE)
	{
	if (CurrentlyHighlightedID == INVNONE)
		drawpic(curpos, cursor_pic, CURSOR_SIZE, '1 1 1', 1, 0);
	else
		drawpic(curpos, cursor_pic, CURSOR_SIZE, '10 0 0', 5, 0);
	}
	else	//	Dragging item, set image of it to cursor
	{
	v_x = ItemLink.inv_item_size_x*ICON_SIZE_x;
	v_y = ItemLink.inv_item_size_y*ICON_SIZE_y;
	
	
	if (StoreItempic)
	s = strcat (icon_dir, StoreItempic);
	else
	s = strcat (icon_dir, cursor_pic);

	drawpic(curpos, s, v, '1 1 1', 1, 0);
	}
	
	curpos_x += CURSOR_SIZE_x;	// offset curpos from cursor position to draw item details.
	curpos_y += CURSOR_SIZE_y;
	
	if (CurrentlyHighlightedID != INVNONE)
	{
		e = ReturnInvObject(CurrentlyHighlightedID);
					
		if (e.slotnumber != INVNONE )
			Draw_ItemDetails(e, curpos);
	}
	
	
	if (ItemLink != DummyEnt && ItemLink.pointsto == INVNONE)
			ItemLink = DummyEnt;	//	set to dummyent if pointing to empty slot
	
		if (input_buttons == 0)	// item interaction on release of drag
			Cursor_BtnRelease_Interact();	
			

		CurrentlyHighlightedID = Check_Cursor_Collision (GetCursorPos()); // Get collision at cursor
					//GenericCollision
};
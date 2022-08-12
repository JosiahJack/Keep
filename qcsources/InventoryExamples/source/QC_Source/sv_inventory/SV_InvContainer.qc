/*
 ==========
 INVENTORY STUFF
 ==========
*/
void(float pslotnum, entity slot) Init_Slot;


//====================
//	Inv_Init 
//  called from sv_client.qc >> ClientConnect()
//====================

void() Inv_Init =
{
	local float i;
	
		
	for (i = 0; i < INV_SLOTS; i++)
	{
		self.(inventory[i]) = spawn();
		Init_Slot (i, self.(inventory[i]));
	}
	
	inventory_initialised = TRUE;

};


/*
	Send slot info to csqc
*/

float(entity viewer) SendInvSlot =
{

	if (viewer != self.owner) 
		return FALSE;

		
	WriteByte(MSG_ENTITY, SEND_INV);
	WriteByte(MSG_ENTITY, self.slotnumber);
	WriteByte(MSG_ENTITY, self.pointsto);	
	WriteString(MSG_ENTITY, self.itemtype);
	WriteString(MSG_ENTITY, self.itempic);	
	WriteString(MSG_ENTITY, self.netname);	
	
	WriteByte(MSG_ENTITY, self.inv_item_size_x);
	WriteByte(MSG_ENTITY, self.inv_item_size_y);	
	WriteByte(MSG_ENTITY, self.durability);
	WriteByte(MSG_ENTITY, self.weight);	
	WriteByte(MSG_ENTITY, self.currentammo);	

	
	return TRUE;
};

void (float pslotnum, entity slot) Init_Slot =
{
	slot.slotnumber = pslotnum;
	slot.classname  = "slot";
	slot.itemtype   = "empty";
	slot.itempic    = "empty";
	slot.pointsto	= -1;
	slot.owner      = self;
	slot.SendEntity = SendInvSlot;
	slot.Version = 1;	
	slot.think = InitialUpdateSharedEnt;
	slot.nextthink = time;	// Give ServerID time to send to client
	setorigin (slot, '0 0 0');
	setmodel (slot, "models/null.md3");	//	required to pass to csqc 
};

void (entity to, entity from) Inv_Copy =
{

	to.itempic  = from.itempic;
	to.itemtype = from.itemtype;
	to.inv_item_size = from.inv_item_size;
	to.durability = from.durability;
	to.weight = from.weight;
	to.currentammo = from.currentammo;
	to.netname = from.netname;
	to.w_model = from.w_model;
	to.v_model = from.v_model;
	
};

void (entity s) Inv_Release =
{
	s.itempic = "empty";
	s.itemtype = "empty";
	s.pointsto = -1;
	s.inv_item_size = '0 0 0';
	s.durability = 0;
	s.weight = 0;
	s.currentammo = 0;
	s.netname = "";
};


/*
============
ReturnInvEntity

returns the entity matching slotnumber passed in
============	
*/

entity (float slotnum) ReturnInvEntity =
{		
	if (slotnum >= 0 && slotnum < INV_SLOTS)
		return (self.(inventory[slotnum]));
};

/*
============
Inv_DropItem 
	
drops into 3dworld.
============
*/

void (entity ent) Inv_DropItem =
{	
	makevectors(self.v_angle);
	ent.origin = self.origin + '0 0 20';
	ent.attack_finished = time + 1;	// disallow anyone picking up for 1 second
	Materialize_Weapon_Base(ent);
	ent.velocity = v_forward*(150+(random()*50)) + v_up*(80*random());
};

void (entity ent) Inv_RemoveItem =
{
	local float i;
	local entity slot;
	
	for (i = (ent.slotnumber+1); i < INV_SLOTS; i++)
	{
		slot = self.(inventory[i]);
		
		if (slot.pointsto == ent.pointsto)
		{
			Inv_Release(slot);
			UpdateSharedEnt (slot);
		}
	}
	print ("ent.slotnumber: ", ftos(ent.slotnumber), "\n");
	
		Inv_Release(ent);
		UpdateSharedEnt (ent);
};

/*
============
Inv_ApplyPointers
---
make all .pointsto of item point back
to data container (top left slot)
============
*/

void (entity ent) Inv_ApplyPointers =
{
	local float i, here, row_inc;
	local vector size;
	local entity slot;

	size = ent.inv_item_size;
	ent.pointsto = ent.slotnumber;
	
	while (row_inc < size_y)
	{
	
		for (here = ent.slotnumber + (row_inc*INV_ROWSIZE); i < size_x; here++)
		{
			i++;
			slot = self.(inventory[here]);
			slot.pointsto = ent.pointsto;
			UpdateSharedEnt (slot);
			print ("ApplyPointers: ", ftos(slot.slotnumber), "\n");
		}
		row_inc++;
		i = 0;
	}	
};

/*
Inv_Check_Fit()

TODO:
	Fix some logging (print) issues
	Stress Test and abuse to shake out any more bugs.
*/

entity(entity owner, entity item) Inv_Check_Fit =
{
	local float x, y, i, YIncrement, IsFree, CheckEdgeOfRow;
	local float RowS;
	local entity index;
	
	x = item.inv_item_size_x;
	y = item.inv_item_size_y;
	RowS = INV_ROWSIZE;
	YIncrement = 0;
	CheckEdgeOfRow = 1;	


	for (i = 0; i < INV_SLOTS; i++)	
	{								
	
		index = owner.(inventory[i]);
		
		
		if (CheckEdgeOfRow == TRUE)
		{		
			if ((GetOnes(i) + (x)) > (RowS))	// not enough room for item on this row without wrap around.
			{
			
				i = ((GetTens(i)*RowS) + (RowS));	// drop a row
				
				if (i==0)		// If its the first row GetTens will return 0. This is not what we want.
					i = (RowS);
				
				if (i < INV_SLOTS)
					index = owner.(inventory[i]);
				else
					break;
					
				print ("^1Prevented wrap around item dropping to beginning of next row.\n");				
				print ("^4DROP TO ROW: ", ftos(i), "\n");
				CheckEdgeOfRow = 0;
				IsFree = 0;
				YIncrement = 0;
			}	
		}
		
		print ("Slotnumber: ", ftos(i), " \n");
		print ("Row: ", ftos(YIncrement + 1), "\n");
		
		if (index.itemtype == "empty" && index.pointsto == INVNONE)
		{
			print ("^3Empty Slot\n");
			IsFree += 1;
			CheckEdgeOfRow = 0;
		}	
		else
		{
			print ("^1HIT FILLED BLOCK ", ftos(i), "\n");
			print ("Blocking item is a: ", index.itemtype, "\n");
			IsFree = 0;
			CheckEdgeOfRow = 1;
			i -= (YIncrement * RowS);	//	reset row position to first one.
			YIncrement = 0;
			
		}
		
		if (IsFree >= x)	// accomplished a row
		{
		
			YIncrement++;
			CheckEdgeOfRow = 1;
			
			if (YIncrement < y)	// Have one or more rows to check through.
			{
			IsFree = 0;
			i += (RowS - x);
			}
			else
			{
				print ("Succeeded: Completed for loop\n");
				
				i -= ((YIncrement-1) * RowS);	// up to first row.
				i -= (x-1);						// to the left at first slot.
				
				print ("Returned Index: ", ftos(i), "\n");
				index = owner.(inventory[i]);
				
				return index;
			}
		}
	
	}
	
	return owner;	// failed

};


float (entity owner, entity item) Put_Item_Into_Inventory =
{
	local float x, y, i, YIncrement, max_2d, MovingIndex;
	local float RowS;
	local entity index, slot;
	
	
	
	if (owner.attack_finished > time)
			return FALSE;
	
	owner.attack_finished = time + 0.3;	//	throttle
	
	index = Inv_Check_Fit (owner, item);

	if (index == owner)
	{
	print ("Item does not fit into ", owner.netname, "'s inventory\n");
	return FALSE;
	}
	
	//	index is the succesfully fitted item's top left slot..
	//	this contains all the data, all other slots are simply
	//	pointers back to the top left data container.

	Inv_Copy (index, item);
	
	
	index.pointsto = index.slotnumber;	// point towards itself
	UpdateSharedEnt (index);			//send to csqc
	
	x = item.inv_item_size_x;
	y = item.inv_item_size_y;
	RowS = INV_ROWSIZE;
	YIncrement = 1;
	

	print ("^1Begin pointing towards: ", ftos(index.slotnumber), "\n");
	
	while (YIncrement <= y)
	{
		for (i = (index.slotnumber + MovingIndex); i <= ((x-1) + index.slotnumber + MovingIndex); i++)
		{
			slot = owner.(inventory[i]);		
			slot.pointsto = index.slotnumber;	
			slot.itemtype = index.itemtype;
			UpdateSharedEnt (slot);
		//		print ("Slotnumber: ", ftos(i), " points to: ");
		//		print (ftos(index.slotnumber), "\n");
		}	
		
		//if (YIncrement != y)
		//print ("^1Dropping a Row\n");
	
	MovingIndex += RowS;	// used to drop down to each level
								// << >> Use different variables for clarity..
	YIncrement++;					// stores how many rows we've dropped
	

	}

	return TRUE;
};






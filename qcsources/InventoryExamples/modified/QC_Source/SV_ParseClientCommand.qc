

/*
=====================
SV_ParseClientCommand
=====================

Receives zany messages from csqc to validate client's
calculations were correct in item interaction and to do them.

*/

void (string cmd) SV_ParseClientCommand =	
{
	local float s, available;
	local entity ent, spot, spotb;
	s = tokenize (cmd);
	
		if (argv(0) == "inv_DropItem")
		{
		spot = ReturnInvEntity(stof(argv(1)));	
		ent = spawn();
		Inv_Copy (ent, spot);
		Inv_RemoveItem(spot);
		print ("^4SV_ParseClientCommand->inv_DropItem: ", ftos(ent.slotnumber), "\n");
		Inv_DropItem (ent);
		}

		if (argv(0) == "inv_MoveItem")
		{
		print ("^4SV_ParseClientCommand->inv_MoveItem: ", argv(1), " to ");
		print (argv(2), "\n");

		spot = ReturnInvEntity(stof(argv(1)));	
		spotb = ReturnInvEntity(stof(argv(2)));	
		
		available = CheckAvailableSpace (spot, stof(argv(2)) );
		
		if (available == TRUE)
		{
		Inv_Release(spotb);
		Inv_Copy (spotb, spot);
		Inv_RemoveItem(spot);
		Inv_ApplyPointers(spotb);
		UpdateSharedEnt (spot);
		UpdateSharedEnt (spotb);
		}

		}		
};


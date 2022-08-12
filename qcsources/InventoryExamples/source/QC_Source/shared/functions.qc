
/*
	Functions.qc
	
	shared functions between svqc & csqc
*/


#ifdef SVQC
float true = 1;
float false = 0;
#endif


entity (float slotnum) ReturnInvEntity;


/*
===================
CheckAvailableSpace
===================
Used to determine if item passed fits within inventory

NOTE: only pass it the data container (top left corner of item)
*/
float (entity item, float here) CheckAvailableSpace =
{
	local vector size;
	local float column_inc, allslots, i, original_slot;
	local entity e;
	
	size = item.inv_item_size;	
	original_slot = here;
	
	if ((INV_ROWSIZE - GetOnes(here)) < size_x)
	{
			print ("Went out of bounds, prevented wrap around\n");				
				return false;	
	}
	
	print ("size: ", vtos(size), "\n");
	
	while (column_inc < size_x)
	{
		for (here; here < (original_slot + (size_y* (INV_ROWSIZE )+ column_inc) ); here+= INV_ROWSIZE)
		{						
			if (here >= INV_SLOTS)
			{
			print ("Failed at: ", ftos(here), "\n");
			print ("Item size went out of bounds of inventory\n");				
				return false;
			}
		
		
			e = ReturnInvEntity(here);
			print ("here: ", ftos(here), "\n");
			print ("will do until: ", ftos((size_y* (INV_ROWSIZE + column_inc))), "\n");
			
			allslots++;	// keep track of how many slots we have gone over
			
			if (e.pointsto != INVNONE && e.pointsto != item.pointsto)
			{
			print ("Failed at: ", ftos(e.slotnumber), "\n");
			print ("slot pointed to: ", ftos(e.pointsto), "\n");
				return false;
			}	
		}
		column_inc++;
		here = original_slot + column_inc;
	}

			if ((allslots) < (size_x*size_y))	// if we've gone over less slots than area of item
			{									// more of a fail safe than anything
			
			print ("^1ERROR:All slots not determined, cannot move item!\n");			
				return false;
			}	
	

		return true;
};
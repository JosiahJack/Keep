
// Based on Flashlight code from Renegade and Nahuel.



void() flash_update =
{
	local entity y;
	local vector middle;

	if (autocvar_flashlight_type == 2)
	{	
		remove (self);
		return;
	}

        if ((self.owner.deadflag != DEAD_NO) || (intermission_running))  	// do not show flashlight when player is dead or during intermission
	{	
		remove (self);
		return;
	}
        else
	{
//		self.effects = EF_DIMLIGHT;  
		self.pflags = PFLAGS_FULLDYNAMIC;
   		self.light_lev = autocvar_flashlight_radius;
	   	self.color_x = autocvar_flashlight_color_brightness_red;	
	   	self.color_y = autocvar_flashlight_color_brightness_green;	
	   	self.color_z = autocvar_flashlight_color_brightness_blue;	
	}

	// Traceline ...
       	makevectors (self.owner.v_angle);
      	traceline (self.owner.origin , (self.owner.origin+(v_forward * 384)) , FALSE , self);
	middle = (self.owner.origin + trace_endpos + '0 0 22') * 0.5;
	
	if (self.classname == "flash")
	{
	       	setorigin (self, trace_endpos + '0 0 22' +(v_forward * -5));

		// Find all non-solid item entities so make them solid as to make the
		// flashlight more realistic ..
		y = find(world, flashtarg, "yes"); // find flashtarg entities
		while(y)
		{
			if (y.flags & FL_ITEM && y.model != string_null)
			{
	 			if (y.solid != SOLID_BBOX)
				{
					y.solid = SOLID_BBOX;
					setmodel (y, y.model);
				}
			}
			y = find(y, flashtarg, "yes"); // find flashtarg entities
		}

		// Find all solid item entities and set them back to SOLID_TRIGGER
		// so nobody can become stuck in them
		y = find(world, flashtarg, "yes"); // find flashtarg entities
		while(y)
		{
			if (y.flags & FL_ITEM && y.model != string_null)
			{
	 			if (y.solid != SOLID_TRIGGER)
				{
					y.solid = SOLID_TRIGGER;
					setmodel (y, y.model);
				}
			}
			y = find(y, flashtarg, "yes"); // find flashtarg entities
		}
	}
	else if (self.classname == "flash2")
        	setorigin (self, middle);
	self.nextthink = time + 0.01;
};


void() flash_on =
{
        local entity myflash, myflash2;
	local vector middle;

        makevectors (self.v_angle);

	//
	// Spawn flashlight entity at end of traceline
	//

        myflash = spawn ();
        myflash.movetype = MOVETYPE_NONE;
        myflash.solid = SOLID_NOT;
        setmodel (myflash, "progs/null.spr"); // replace with transparent 2D sprite
        setsize (myflash, '0 0 0', '0 0 0');
        myflash.owner = self; // link entities
        self.flash = myflash; // link entities
        
        myflash.classname = "flash";
        
//      traceline (self.origin , (self.origin+(v_forward * 384)) , FALSE , self);
//      setorigin (myflash, trace_endpos);

        myflash.think = flash_update;
        myflash.nextthink = time + 0.01;

	//
	// Spawn flashlight entity at middle of traceline
	//

	middle = (self.owner.origin + trace_endpos) * 0.5;

        myflash2 = spawn ();
        myflash2.movetype = MOVETYPE_NONE;
        myflash2.solid = SOLID_NOT;
        setmodel (myflash2, "progs/null.spr"); // replace with transparent 2D sprite
        setsize (myflash2, '0 0 0', '0 0 0');
        myflash2.owner = self; // link entities
        self.flash2 = myflash2; // link entities
        
        myflash2.classname = "flash2";
        setorigin (myflash2, middle);

        myflash2.think = flash_update;
        myflash2.nextthink = time + 0.01;
};


void () flash_toggle =
{
        if (self.flash_flag == FALSE)
        {
		sound (self, CHAN_AUTO, "player/click.wav", 0.5, ATTN_NORM);	
		sprint (self, "Flashlight: ON\n");
                self.flash_flag = TRUE;
                flash_on();
        }
        else
        {
		sound (self, CHAN_AUTO, "player/click.wav", 0.5, ATTN_NORM);	
		sprint (self, "Flashlight: OFF\n");
                self.flash_flag = FALSE;
		// Turn end light off
                self.flash.think = SUB_Remove;
                self.flash.nextthink = time + 0.1;
		// Turn middle light off
                self.flash2.think = SUB_Remove;
                self.flash2.nextthink = time + 0.1;
        }
};
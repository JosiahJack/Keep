
// Based on Flashlight code from Renegade and Nahuel.



void() flash_update_cubemap =
{
	if (autocvar_flashlight_type == 1)
	{	
		remove (self);
		return;
	}
	
        if ((self.owner.deadflag != DEAD_NO) || (intermission_running))  	// do not show flashlight when player is dead or during intermission
	{	
		remove (self);
		return;
	}
        makevectors (self.owner.v_angle);
        traceline (self.owner.origin , (self.owner.origin + (v_forward * 10)), FALSE , self);
        setorigin (self, trace_endpos + '0 0 22' + (v_forward * 7)); 

	self.angles_x = ((self.owner.v_angle_x) - 180);
	self.angles_y = self.owner.v_angle_y;
	self.angles_z = self.owner.angles_z;
	self.pflags = PFLAGS_FULLDYNAMIC;
	self.light_lev = autocvar_flashlight_cubemap_radius;
	self.color_x = autocvar_flashlight_color_brightness_red;
  	self.color_y = autocvar_flashlight_color_brightness_green;
   	self.color_z = autocvar_flashlight_color_brightness_blue;
	self.skin = 237;

        self.nextthink = time + 0.01;
};


void() flash_on_cubemap =
{
        local entity myflash;

        myflash = spawn ();
        myflash.movetype = MOVETYPE_NONE;
        myflash.solid = SOLID_NOT;
        setmodel (myflash, "progs/null.spr"); // replace with transparent 2D sprite
        setsize (myflash, '0 0 0', '0 0 0');
        myflash.owner = self;
        self.flash = myflash;
        myflash.classname = "flash_cubemap";
        
        makevectors (self.v_angle);
        traceline (self.origin , (self.origin+(v_forward * 10)) , FALSE , self);
        setorigin (myflash, trace_endpos);

        myflash.think = flash_update_cubemap;
        myflash.nextthink = time + 0.01;
};


void () flash_toggle_cubemap =
{
        if (self.flash_flag == FALSE)
        {
		sound (self, CHAN_AUTO, "player/click.wav", 0.5, ATTN_NORM);	
		sprint (self, "Flashlight: ON\n");
                self.flash_flag = TRUE;
                flash_on_cubemap ();
        }
        else
        {
		sound (self, CHAN_AUTO, "player/click.wav", 0.5, ATTN_NORM);	
		sprint (self, "Flashlight: OFF\n");
                self.flash_flag = FALSE;
                self.flash.think = SUB_Remove;
                self.flash.nextthink = time + 0.1;
        }
};

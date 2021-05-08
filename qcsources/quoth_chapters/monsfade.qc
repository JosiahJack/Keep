//q3 style corpse removal
.float		mlah;

void() monster_fade_start =
{
        local   vector   neworigin;

        neworigin = self.origin;

        neworigin_z = neworigin_z - 1;

        setorigin (self, neworigin);

        self.nextthink = time + 0.1;
        self.think = monster_fade_start;

        self.mlah = self.mlah + 1;

        if (self.mlah >= 40)
        {
                self.think = SUB_Remove;
        }

};


void() monster_fade =
{

	self.solid = SOLID_TRIGGER;
	setorigin (self, self.origin);  //this is needed to rebuild the link list otherwise quake will crash with "Trigger in clipping list".  Thanks, FrikaC.
	
	if (!self.corpse_time)
		self.nextthink = time + CORPSE_TIME_GLOBAL;
	else if (self.corpse_time == -1)
		self.nextthink = time + 99999;
	else /*if (self.corpse_time)*/
		self.nextthink = time + self.corpse_time;
		
	self.think = monster_fade_start;
};

void() monster_spawn =
{

	//function that all spawning monsters will run...
	spawn_tdeath(self.origin, self);
	self.use = monster_use;
};
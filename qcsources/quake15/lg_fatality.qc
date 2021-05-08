
void() lg_shock =
{
	
	sound7(self, CHAN_WEAPON, "weapons/lhit.wav", .7, ATTN_IDLE, SNDSPD);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY); // temp entity
	WriteByte (MSG_BROADCAST, TE_LIGHTNING2); // makes lightning line i think
	WriteEntity (MSG_BROADCAST, self); // write head entity
	WriteCoord (MSG_BROADCAST, self.origin_x+random(-10,10)); // lightning start pos
	WriteCoord (MSG_BROADCAST, self.origin_y+random(-10,10)); 
	WriteCoord (MSG_BROADCAST, self.origin_z+random(-10,10)); 
	
	WriteCoord (MSG_BROADCAST, self.origin_x+random(-10,10)); // lightning end pos
	WriteCoord (MSG_BROADCAST, self.origin_y+random(-10,10));
	WriteCoord (MSG_BROADCAST, self.origin_z+random(-10,10)); 
}

void() lg_shock_player =
{

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY); // temp entity
	WriteByte (MSG_BROADCAST, TE_LIGHTNING2); // makes lightning line i think
	WriteEntity (MSG_BROADCAST, self); // write head entity
	WriteCoord (MSG_BROADCAST, self.origin_x+random(-5,5)); // lightning start pos
	WriteCoord (MSG_BROADCAST, self.origin_y+random(-5,5)); 
	WriteCoord (MSG_BROADCAST, self.origin_z+random(-5,5)); 
	
	WriteCoord (MSG_BROADCAST, self.origin_x+random(-5,5)); // lightning end pos
	WriteCoord (MSG_BROADCAST, self.origin_y+random(-5,5));
	WriteCoord (MSG_BROADCAST, self.origin_z+random(-5,5)); 
}

//Shock fatality

void() shocked_explode =
{
	ThrowBody ("progs/coal.mdl", self.health);
	 ThrowBody ("progs/coal.mdl", self.health);
	 ThrowBody ("progs/coal.mdl", self.health);
	 ThrowBody ("progs/coal.mdl", self.health);
	 ThrowBody ("progs/coal.mdl", self.health);
	 ThrowBody ("progs/coal.mdl", self.health);
	 ThrowBody ("progs/coal.mdl", self.health);
	 ThrowBody ("progs/coal.mdl", self.health);
	 ThrowBody ("progs/coal.mdl", self.health);
	 ThrowBody ("progs/coal.mdl", self.health);
	 ThrowBody ("progs/coal.mdl", self.health);
	 ThrowBody ("progs/coal.mdl", self.health);
	 ThrowBody ("progs/coal.mdl", self.health);
	 ThrowBody ("progs/coal.mdl", self.health);
	 
	 sound7 (self, CHAN_AUTO, "ambience/coaled_monster_explode.wav", 1, ATTN_NORM, SNDSPD);
	 
	 remove(self);
	 
}


void()	lg_death1 =
{
	
	self.shocked++;
	if (self.classname == "monster_afrit" && self.colormod != '.2 .2 .2')
		self.velocity = 0;
	self.colormod = '.2 .2 .2';
	self.traileffectnum = particleeffectnum("corpse_charred");
	//makevectors(self.angles);
	
	
	
	if (self.classname == "monster_army" || self.classname == "monster_afrit")
	{
		self.frame++;
		
		if (random(100) < 40)
			lg_shock();
		if (self.frame <= 43)
		{
			if (random(100) < 20)
				Part_Emitter(self, "progs/s_smoke_muzz.spr", random(.3, .8), '5 5 -8', '0 0 10', '0 0 0', .8);
			//self.origin+= v_forward*2;
			//self.angles_y+=13;
			if (self.noise)
				sound7 (self, CHAN_VOICE, self.noise, 1, ATTN_NORM, SNDSPD);
			lg_shock();
			self.frame = 43;
			
		}
		else if (self.frame >= 46)
		{
			//self.angles_y-=13;
			//self.origin+= -v_forward*2;
			if (random(100) < 20)
				Part_Emitter(self, "progs/s_smoke_muzz.spr", random(.3, .8), '5 5 -8', '0 0 10', '0 0 0', .8);
			if (random(100) > 50)
			{
				lg_shock();
				self.frame = 44;
			}
			else
				self.frame = 43;

			lg_shock();
		}
		/*else if (self.frame == 41 || self.frame == 43 || self.frame == 45)
			lg_shock();*/
	}
	else if (self.classname == "monster_ogre")
	{
		self.frame++;
		
		if (random(100) < 40)
			lg_shock();
		if (self.frame <= 67)
		{
			if (random(100) < 20)
				Part_Emitter(self, "progs/s_smoke_muzz.spr", random(.3, .8), '5 5 -8', '0 0 10', '0 0 0', .8);
			//self.origin+= v_forward*2;
			//self.angles_y+=13;
			if (self.noise)
				sound7 (self, CHAN_VOICE, self.noise, 1, ATTN_NORM, SNDSPD);
			lg_shock();
			self.frame = 67;
			
		}
		else if (self.frame >= 72)
		{
			//self.angles_y-=13;
			//self.origin+= -v_forward*2;
			if (random(100) < 20)
				Part_Emitter(self, "progs/s_smoke_muzz.spr", random(.3, .8), '5 5 -8', '0 0 10', '0 0 0', .8);
			if (random(100) > 50)
			{
				lg_shock();
				self.frame = 69;
			}
			else
				self.frame = 67;

			lg_shock();
		}
		/*else if (self.frame == 41 || self.frame == 43 || self.frame == 45)
			lg_shock();*/
	}
	else
	{
		if (self.frame <= 1)
		{
			Part_Emitter(self, "progs/s_smoke_muzz.spr", random(.3, .8), '5 5 -8', '0 0 10', '0 0 0', .8);
			//self.origin+= v_forward*2;
			self.angles_y+=13;
			self.frame = random(8,9);
			lg_shock();
		}
		else
		{
			self.angles_y-=13;
			//self.origin+= -v_forward*2;
			self.frame = random(0,1);
		}
	}
	
		
	self.health = -200;
	if (self.shocked == 28)
	{
		self.frame = 0;
		self.think = self.th_die;
		//self.think = shocked_explode;
		self.nextthink = time + 0.7;
	}
	else
	{
		self.think = lg_death1;
		if (self.classname != "monster_army" && self.classname != "monster_ogre")
			self.nextthink = time + 0.07;
		else
			self.nextthink = time + 0.055;
	}
	
	
}




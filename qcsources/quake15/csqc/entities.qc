

void() spriteThink =
{
	if (self.frame < 7)
		self.frame+=0.06;
	local vector v;
	v = self.origin + self.velocity*frametime;
	
	self.lifetime++;
	
//check bounding box
	
	if (pointcontents(self.origin) != CONTENT_SOLID)
	{	
		//if (pointcontents(self.origin-'0 0 5') != CONTENT_SOLID)
		setorigin(self, v);
		if (self.velocity_x > 0)
			self.velocity_x-= 0.5*cvar("slowmo");
		if (self.velocity_y > 0)
			self.velocity_y-= 0.5*cvar("slowmo");
		self.velocity_z+= 0.6*cvar("slowmo");
		self.angles_x+=2*cvar("slowmo");
		self.angles_y+=2*cvar("slowmo");
		self.oldorigin = self.origin;
		/*setorigin(self, v);
		if (self.velocity_x > 0)
			self.velocity_x-= 0.5*cvar("slowmo");
		if (self.velocity_y > 0)
			self.velocity_y-= 0.1*cvar("slowmo");
		self.velocity_z-= 6*cvar("slowmo");
		//self.angles_x+=2*cvar("slowmo");
		//self.angles_y+=2*cvar("slowmo");
		self.oldorigin = self.origin;*/
		
		
	}
	self.think = spriteThink;
	self.nextthink = time;
	
	self.alpha-=0.007;
	self.scale+=0.001;
	
	if (self.lifetime > 100)
		remove(self);
}

void() spritegen =
{
	local entity sprite;
	//local vector ejectpos;
	//local float correction;

	sprite = spawn();
	
	self.lifetime++;

	//smoke.angles = view_angles;
	//smoke.angles_x = casing.angles_x * -1;	// old Quake bug...
	sprite.effecttype = self.effecttype;

	if (sprite.effecttype == EFF_SMOKE)
	{
		setmodel (sprite, "progs/s_smoke_muzz.spr");
		sprite.alpha = .8;
		sprite.scale = 0.3;
		//effect(self.origin, "progs/s_smoke_muzz.spr",0,7, 8);
	}
		
	setorigin (sprite, self.origin);
	
	//if (!self.scale)
		
	//else
		//sprite.scale = self.scale;
		
			
	
	//sprite.movetype = MOVETYPE_BOUNCE;
	//sprite.solid = SOLID_TRIGGER;
	sprite.drawmask = MASK_ENGINE;
	sprite.velocity = self.velocity;
	sprite.velocity_old = self.velocity;
	sprite.velocity_old_z += 10; 
	
	if (self.lifetime > 45)
	{
		remove(self);
	}
	sprite.think = spriteThink;
	sprite.nextthink = time;
	
	
	self.think = spritegen;
	self.nextthink = time + 0.5;
	
};


void() casingSound =
{
	if (self.casetype == CASING_SHELL)
	{
		if (random() <= 0.4)
			sound7 (self, CHAN_WEAPON, "weapons/casings1.wav", autocvar_casingdropsound, ATTN_NORM, SNDSPD);
		else if (random() >= 0.6)
			sound7 (self, CHAN_WEAPON, "weapons/casings2.wav", autocvar_casingdropsound, ATTN_NORM, SNDSPD);
		else 
			sound7 (self, CHAN_WEAPON, "weapons/casings3.wav", autocvar_casingdropsound, ATTN_NORM, SNDSPD);
	}
	else if (self.casetype == CASING_NAIL)
	{
		if (random() <= 0.4)
			sound7 (self, CHAN_WEAPON, "weapons/nailcase1.wav", autocvar_casingdropsound, ATTN_NORM, SNDSPD);
		else if (random() >= 0.6)
			sound7 (self, CHAN_WEAPON, "weapons/nailcase2.wav", autocvar_casingdropsound, ATTN_NORM, SNDSPD);
		else 
			sound7 (self, CHAN_WEAPON, "weapons/nailcase3.wav", autocvar_casingdropsound, ATTN_NORM, SNDSPD);

	}
	else if (self.casetype == CASING_ROCKET)
	{
		if (random() <= 0.6)
			sound7 (self, CHAN_WEAPON, "weapons/rockcase.wav", autocvar_casingdropsound, ATTN_NORM, SNDSPD);
		else 
			sound7 (self, CHAN_WEAPON, "weapons/rockcase1.wav", autocvar_casingdropsound, ATTN_NORM, SNDSPD);
	}
	
}

void() runphysics_casing_gravity =
{
	local vector v, modelsize;
	v = self.origin + self.velocity*frametime;
	//print(vtos(self.velocity),"\n");
	
	if (self.casetype == CASING_SHELL)
		modelsize = '0 0 2';
	else if (self.casetype == CASING_NAIL)
		modelsize = '0 0 1';
	else if (self.casetype == CASING_ROCKET)
		modelsize = '0 0 2';
	
	//check bounding box
	if (pointcontents(self.origin-modelsize) != CONTENT_SOLID)
	{	
		//if (pointcontents(self.origin-'0 0 5') != CONTENT_SOLID)
		setorigin(self, v);
		if (self.velocity_x > 0)
			self.velocity_x-= 0.5*cvar("slowmo");
		if (self.velocity_y > 0)
			self.velocity_y-= 0.5*cvar("slowmo");
		self.velocity_z-= 6*cvar("slowmo");
		self.angles_x+=2*cvar("slowmo");
		self.angles_y+=2*cvar("slowmo");
		self.oldorigin = self.origin;
	}
	else if (pointcontents(self.origin) == CONTENT_SOLID)
	{
		if (self.casetype == CASING_SHELL)
		{
			if (pointcontents(self.origin-'0 0 2') == CONTENT_SOLID)
				setorigin(self, self.origin + '0 0 0.5');
		}
		else if (self.casetype == CASING_NAIL)
		{
			if (pointcontents(self.origin-'0 0 3') == CONTENT_SOLID)
				setorigin(self, self.origin + '0 0 .5');
			else if (pointcontents(self.origin-'0 0 1') == CONTENT_SOLID)
			{
				setorigin(self, self.origin + '0 0 .3');
				self.velocity = 0;
			}
		}
		else if (self.casetype == CASING_ROCKET)
		{
			if (pointcontents(self.origin-'0 0 2') == CONTENT_SOLID)
				setorigin(self, self.origin + '0 0 2');
		}
		
		if (pointcontents(self.origin-'0 3 0') == CONTENT_SOLID)
		{
			setorigin(self, self.origin + '0 3 0');
			self.velocity_y = -self.velocity_y;
			self.velocity_old_y = -self.velocity_old_y;
		}
		if (pointcontents(self.origin+'0 3 0') == CONTENT_SOLID)
		{
			setorigin(self, self.origin - '0 3 0');
			self.velocity_y = -self.velocity_y;
			self.velocity_old_y = -self.velocity_old_y;
		}
		if (pointcontents(self.origin-'3 0 0') == CONTENT_SOLID)
		{
			setorigin(self, self.origin + '3 0 0');
			self.velocity_x = -self.velocity_x;
			self.velocity_old_x = -self.velocity_old_x;
		}
		if (pointcontents(self.origin+'3 0 0') == CONTENT_SOLID)
		{
			setorigin(self, self.origin - '3 0 0');
			self.velocity_x = -self.velocity_x;
			self.velocity_old_x = -self.velocity_old_x;
		}
		
		//casingSound();
	}
		
	else //if (pointcontents(self.origin-'0 0 5') != CONTENT_SOLID)
	{
		
		if (self.velocity_z < -9)
			self.velocity_old_z/=1.01;
		else
			self.velocity_old_z/=1.4;
				
		if (self.velocity_old_y < -2)
			self.velocity_old_x/=1.04;
		else
			self.velocity_old_x/=1.4;
			
		if (self.velocity_old_y < -2)
			self.velocity_old_y/=1.04;
		else
			self.velocity_old_y/=1.4;
		
		
		self.velocity = self.velocity_old*2;
		self.velocity_z = self.velocity_old_z*1.65;
		setorigin(self, v);
		if (self.angles_x != 0)
			casingSound();
		self.angles_x = 0;// + random() * 10;		// makes it look random but still keeps it flat
	}
}


void() casing_placement =		// place it on ground, so that it looks a little bit random, but does not sink into floor
{
	
	runphysics_casing_gravity();
	
	
	if (pointcontents(self.origin-'0 0 4') == CONTENT_SOLID && (self.velocity_z < 1 && self.velocity_z > -1))
		{
		
		//if (autocvar_casingusegyro == 1)
			//MonsterPhysics (self, autocvar_casingmass);
		self.nextthink = time + 100;
		self.think = SUB_Remove;			// casings will fade away
		return;
		}
	self.nextthink = time;
};
 
/*void() shellcasing_touch =
{
	if (other.solid == SOLID_BSP)		// noting can touch it, only the map brushes
		{
		self.velocity = self.velocity * 0.9;	// make it less bouncing
		if (autocvar_casingdropsound)
			{
			
			local float zufall;
			zufall = random();
			if (zufall <= 0.4)
				sound7 (self, CHAN_WEAPON, "weapons/casings1.wav", autocvar_casingdropsound, ATTN_NORM, SNDSPD);
			else if (zufall >= 0.6)
				sound7 (self, CHAN_WEAPON, "weapons/casings2.wav", autocvar_casingdropsound, ATTN_NORM, SNDSPD);
			else 
				sound7 (self, CHAN_WEAPON, "weapons/casings3.wav", autocvar_casingdropsound, ATTN_NORM, SNDSPD);
			}
		self.touch = SUB_Null;
		}
};*/



void() casing =
{
	local entity casing;
	//local vector ejectpos;
	//local float correction;

	casing = spawn();

	casing.angles = view_angles;
	casing.angles_x = casing.angles_x * -1;	// old Quake bug...
	casing.casetype = self.casetype;

	if (casing.casetype == CASING_SHELL)
	{
		setmodel (casing, "progs/casing.mdl");
		setsize (casing, '-1 -1 -2', '1 1 2');	
	}
	else if (casing.casetype == CASING_NAIL)
	{
		setmodel (casing, "progs/nailcasing.mdl");
		setsize (casing, '-1 -1 -2', '1 1 2');
	}	
	else if (casing.casetype == CASING_ROCKET)
	{
		setmodel (casing, "progs/missilecasing.mdl");
		setsize (casing, '-1 -1 1', '1 1 1');
	}
		
	setorigin (casing, self.origin);
	
	
	
	casing.scale = .9;	
	
	casing.alpha = 1;
	casing.movetype = MOVETYPE_BOUNCE;
	casing.solid = SOLID_TRIGGER;
	casing.drawmask = MASK_ENGINE;
	casing.velocity = self.velocity;
	casing.velocity_old = self.velocity;
	casing.velocity_old_z += 10; 
	//casing.avelocity = '390 322 290' + randomvec() * 44;
	casing.think = casing_placement;
	casing.nextthink = time;
	casing.cansplash = TRUE;		// Yes, its fun  ;)
	casing.count = 0;
	//shellcasing.gravity = 1.3;
	//print (vtos(shellcasing.origin), "\n");
	
	//pointparticles(particleeffectnum("TE_SPIKE), self.origin, self.velocity, self.count);
};

void() Particle_Emitter_Think =
{
    pointparticles(self.fx, self.origin, self.velocity, self.count);
    
    //if (!self.wait)
    //{
    	self.think = SUB_Remove;
	self.nextthink = time + 1;
   // }
   // else
   // {
      //  self.think = Particle_Emitter_Think;
	//self.nextthink = time + self.wait;
    // }
    
   
      
};

void( float isnew ) Sprite_Spawner =
{

   // Emitter Origin
   self.origin_x = ReadCoord();
   self.origin_y = ReadCoord();
   self.origin_z = ReadCoord();
   
   // Emitter Velocity
   self.velocity_x = ReadCoord();
   self.velocity_y = ReadCoord();
   self.velocity_z = ReadCoord();
   
   
   //type of sprite to emit
   self.effecttype = ReadCoord();

   setorigin(self, self.origin);
   
   self.think = spritegen;
   self.nextthink = time;
   
   self.classname = "sprite";

};

void( float isnew ) Casing_Spawner =
{

   // Emitter Origin
   self.origin_x = ReadCoord();
   self.origin_y = ReadCoord();
   self.origin_z = ReadCoord();
   
   // Emitter Velocity
   self.velocity_x = ReadCoord();
   self.velocity_y = ReadCoord();
   self.velocity_z = ReadCoord();
   
   self.casetype = ReadCoord();

   setorigin(self, self.origin);
   
   self.think = casing;
   self.nextthink = time;

};

void( float isnew ) Particle_Emitter =
{
   local string temp_fxname;
 // if ( isnew )
	//print("testing");
//   {
   
   // Emitter Origin
   self.origin_x = ReadCoord();
   self.origin_y = ReadCoord();
   self.origin_z = ReadCoord();
   
   // Emitter Velocity
   self.velocity_x = ReadCoord();
   self.velocity_y = ReadCoord();
   self.velocity_z = ReadCoord();
   
   // Emitter amount
   self.count = ReadCoord();
   
   self.wait = ReadCoord();
   
   
   // Emitter ParticleEffectNum
   temp_fxname = strzone(ReadString());
   
   self.fx = particleeffectnum(temp_fxname);
   setorigin(self, self.origin);
   
   
   if (self.fx == -1)
   {
      print("no effectinfo for ", temp_fxname, "\n");
      strunzone(temp_fxname);
      remove(self);
      return;
   }

   strunzone(temp_fxname);
   
   

   self.think = Particle_Emitter_Think;
   self.nextthink = time;

};

//EFFECTS

/*void() spriteanim = 
{
	self.frame++;
	self.ltime++;
	if (self.ltime < 15)
	{
		if (self.velocity > 10)
			self.velocity/=2;
		self.velocity_x = self.velocity_x + random(10,-10);
		self.velocity_y = self.velocity_y + random(10,-10);
		self.scale-=0.03;
		self.think = spriteanim;
		self.nextthink = time + 0.07;
	}
	else
		remove(self);
}
void() burnsprite =
{
	newmis = spawn();
	newmis.scale = 0.4;
	newmis.alpha = 0.5;
	newmis.effects = EF_ADDITIVE;
	setmodel(newmis, "progs/s_flame.spr");
	setorigin(newmis, self.origin);
	setsize (newmis, '0 0 0', '0 0 0');
	newmis.movetype = MOVETYPE_TOSS;
	newmis.gravity = -0.1;
	newmis.velocity = self.velocity/2;
	newmis.velocity_y = newmis.velocity_y + random(-5,5);
	newmis.think = spriteanim;
	newmis.nextthink = time + 0.1;
	
	self.ltime+=1;
	if (self.ltime < 55)
	{
		self.think = burnsprite;
		self.nextthink = time + 0.3;
	}
	else
		remove(self);
}*/

void(float eftype) sparkler =
{
	local entity new;
	
	new = spawn();
	new.origin = self.origin + '0 0 10';
	new.origin_x = new.origin_x + random(-5,5);
	new.origin_y = new.origin_y + random(-5,5);
	new.origin = new.origin + -v_forward*40;
	new.movetype = MOVETYPE_TOSS;
	new.solid = SOLID_NOT;
	new.velocity_x = random(-300, 300);
	new.velocity_y = random(-300, 300);
	new.velocity_z = random(300, 700);
	if (eftype == 2)
		new.gravity = 1.1;
	else
		new.gravity = 0.7;
	if (coop || deathmatch)
		new.effects = EF_LOWPRECISION;
	
	setmodel(new, "progs/misc_spark.mdl");
	setsize (new, '0 0 0', '0 0 0');
	new.think = SUB_Remove;
	new.alpha = 0.01;
	if (eftype == 2)
	{
		//new.think = burnsprite;
		//new.nextthink = time;
		/*setmodel(new, "progs/s_flame.spr");
		setsize (new, '0 0 0', '0 0 0');
		new.alpha = 0.4;
		new.effects = EF_ADDITIVE;
		new.scale = 0.4;*/
		new.velocity_x = random(-180, 180);
		new.velocity_y = random(-180, 180);
		new.velocity_z = random(200, 500);
		new.nextthink = time + random(2, 5);
	}
	else if (eftype == 1)
	{
		new.velocity_x = random(-180, 180);
		new.velocity_y = random(-180, 180);
		new.velocity_z = random(200, 220);
		new.nextthink = time + random(1, 3);
	}
	else
	{
		new.nextthink = time + random(.5, 3);
	}
	
	if (eftype == 1)
		new.traileffectnum = particleeffectnum("smoke_trail");
	else if (eftype == 2)
		new.traileffectnum = particleeffectnum("fire_trail");
	else
		new.traileffectnum = particleeffectnum("sparkler");
	
	if (pointcontents(new.origin) == CONTENT_SOLID )
		remove(new);
	
	//self.think = SUB_Remove;
	//self.nextthink = time + 
};

void(float eftype) sparklers=
{
	if (autocvar_effects_sparkballs == 1)
	{
		if (random() > 0.5)
		{
			sparkler(eftype);
			sparkler(eftype);
		}
		if (random() > 0.7)	
		{
			
			sparkler(eftype);
			sparkler(eftype);
		}
	}
};


/*
================
Muzzleflash code
================
*/

void() muzzle_think =
{
	self.ltime++;
	if (self.model == "progs/shot_muzz.spr" || self.model == "progs/shot_muzz_b.spr")
		self.scale+=.05;
	else
		self.scale+=.2;
	
	self.think = muzzle_think;
	self.nextthink = time + 0.005;
	
	if (self.ltime > 5.65)
		remove(self);		
}

void() muzzle_small_think =
{
	self.ltime++;
	
	self.think = muzzle_small_think;
	if (self.model == "progs/s_explodmed.spr")
	{
		if (self.frame <= 13)
		{
			self.alpha-=.09;
			self.frame++;
		}
		
		if (self.ltime > 14)
			remove(self);
			
		self.scale+=.03;
		self.nextthink = time + 0.07;
	}
	else
	{
		self.nextthink = time + 0.005;
		if (self.model == "progs/sng_muzz.spr" || self.model == "progs/sng_muzz_b.spr" || self.model == "progs/shot_muzz_b.spr")
		{
			self.scale+=.04;
			self.alpha-=.05;
		}
		else
			self.scale+=.1;
		if (self.ltime > 5.65)
			remove(self);
	}
	
			
}

void() SpawnMuzzleFlash =			//Spawns a first person muzzleflash
{
	newmis = spawn();
	newmis.movetype = MOVETYPE_NONE;
	newmis.solid = SOLID_NOT;
	newmis.viewmodelforclient = self;
	newmis.owner = self;
	newmis.classname = "flash";
	newmis.effects = newmis.effects + EF_ADDITIVE;
	
	if (self.waterlevel >= 3)
		setmodel(newmis, "progs/s_smoke_muzz.spr");
	else
	{
		if (random(100) < 50)
			setmodel(newmis, "progs/shot_muzz.spr");
		else
		{
			if (random(100) < 50)
				setmodel(newmis, "progs/muzzleflash3.spr");
			else
				setmodel(newmis, "progs/muzzleflash.spr");
		}
	}
	
	newmis.scale = .8;
	newmis.alpha = 1;
	setsize(newmis, '0 0 0', '0 0 0');
	setorigin(newmis, '104 -16 -18');	//Don't worry about this showing up in weird places on higher resolutions -
						// all viewmodels are scaled to fit the res perfectly
						
	if (autocvar_centered_weapons)
		newmis.origin = newmis.origin + '0 16 0';
		
	newmis.think = muzzle_think;
	newmis.nextthink = time + 0.01;		//Adjust this as you wish
};

void() SpawnSSGFlash =			//Spawns a first person muzzleflash
{
	newmis = spawn();
	newmis.movetype = MOVETYPE_NONE;
	newmis.solid = SOLID_NOT;
	newmis.viewmodelforclient = self;
	newmis.owner = self;
	newmis.classname = "flash";
	newmis.effects = newmis.effects + EF_ADDITIVE;
	newmis.alpha = 1;
	
	if(!self.cnt)
		self.cnt++;
	else
		self.cnt = 0;
	
	if (self.waterlevel >= 3)
		setmodel(newmis, "progs/s_smoke_muzz.spr");
	else
	{
		if (self.cnt)
			setmodel(newmis, "progs/shot_muzz_b.spr");
		else
			setmodel(newmis, "progs/shot_muzz.spr");
	}
	setsize(newmis, '0 0 0', '0 0 0');
	newmis.scale = 1;
	setorigin(newmis, '108 -26 -34');	//Don't worry about this showing up in weird places on higher resolutions -
						// all viewmodels are scaled to fit the res perfectly
						
	if (autocvar_centered_weapons)
		newmis.origin = newmis.origin + '0 26 0';
		
	newmis.think = muzzle_think;
	newmis.nextthink = time + 0.01;		//Adjust this as you wish
};

void(vector offset) SpawnNailgunFlash =			//Spawns a first person muzzleflash
{
	if (self.waterlevel >= 3)
		return;
	newmis = spawn();
	newmis.movetype = MOVETYPE_NONE;
	newmis.solid = SOLID_NOT;
	newmis.viewmodelforclient = self;
	newmis.owner = self;
	newmis.classname = "flash";
	newmis.effects = newmis.effects + EF_ADDITIVE;
	setmodel(newmis, "progs/muzzleflash2.spr");
	setsize(newmis, '0 0 0', '0 0 0');
	setorigin(newmis, '104 -24 -43' + offset);	//Don't worry about this showing up in weird places on higher resolutions -
						// all viewmodels are scaled to fit the res perfectly
	if (autocvar_centered_weapons)
		newmis.origin = newmis.origin + '0 24 0';
		
	newmis.think = muzzle_think;
	newmis.nextthink = time + 0.01;		//Adjust this as you wish
};

void(vector offset, vector color) SpawnSNGFlash =			//Spawns a first person muzzleflash
{
	if (self.waterlevel >= 3)
		return;
		
	newmis = spawn();
	newmis.movetype = MOVETYPE_NONE;
	newmis.solid = SOLID_NOT;
	newmis.viewmodelforclient = self;
	newmis.owner = self;
	newmis.classname = "flash";
	
	if(self.cnt < 2)
		self.cnt++;
	else
		self.cnt = 0;
	
	newmis.colormod = color;
	newmis.effects = newmis.effects + EF_ADDITIVE;
	if (!self.cnt)
		setmodel(newmis, "progs/sng_muzz_b.spr");
	else if (self.cnt == 1)
		setmodel(newmis, "progs/sng_muzz.spr");
	else
		setmodel(newmis, "progs/shot_muzz_b.spr");
	newmis.scale = 0.65;
	newmis.alpha = 0.9;
	setsize(newmis, '0 0 0', '0 0 0');
	setorigin(newmis, '104 -26 -25' + offset);	//Don't worry about this showing up in weird places on higher resolutions -
						// all viewmodels are scaled to fit the res perfectly
						
	if (autocvar_centered_weapons)
		newmis.origin = newmis.origin + '0 26 0';
		
	newmis.think = muzzle_small_think;
	newmis.nextthink = time + 0.01;		//Adjust this as you wish
};

void() SpawnHLFlash =			//Spawns a first person muzzleflash
{
	
	newmis = spawn();
	newmis.movetype = MOVETYPE_NONE;
	newmis.solid = SOLID_NOT;
	newmis.viewmodelforclient = self;
	newmis.owner = self;
	newmis.classname = "flash";
	newmis.effects = newmis.effects + EF_ADDITIVE;
	setmodel(newmis, "progs/muzzleflash1.spr");
	newmis.scale = 0.6;
	newmis.alpha = 0.3;
	setsize(newmis, '0 0 0', '0 0 0');
	setorigin(newmis, '104 -26 -24');	//Don't worry about this showing up in weird places on higher resolutions -
						// all viewmodels are scaled to fit the res perfectly
	if (autocvar_centered_weapons)
		newmis.origin = newmis.origin + '0 26 0';
	newmis.think = muzzle_think;
	newmis.nextthink = time + 0.01;		//Adjust this as you wish
};

void(vector offset, vector color) SpawnRockFlash =			//Spawns a first person muzzleflash
{
	if (self.waterlevel >= 3)
		return;
		
	newmis = spawn();
	newmis.movetype = MOVETYPE_NONE;
	newmis.solid = SOLID_NOT;
	newmis.viewmodelforclient = self;
	newmis.owner = self;
	newmis.classname = "flash";
	newmis.movetype = MOVETYPE_NOCLIP;
	
	newmis.colormod = color;
	//newmis.effects = newmis.effects + EF_ADDITIVE;
	newmis.alpha = 1;

	newmis.velocity_z = 20;
	
	setmodel(newmis, "progs/s_explodmed.spr");
	newmis.scale = 0.45;
	setsize(newmis, '0 0 0', '0 0 0');
	setorigin(newmis, '74 7 -69' + offset);	//Don't worry about this showing up in weird places on higher resolutions -
						// all viewmodels are scaled to fit the res perfectly
					
		
	newmis.think = muzzle_small_think;
	newmis.nextthink = time + 0.01;		//Adjust this as you wish
};

void() muzzle_smoke_think =
{
	self.frame++;
		
	self.ltime++;
	self.alpha-=.05;
	self.scale-=.05;
	self.velocity_z = self.velocity_z+16;
	//self.velocity_x = self.velocity_x-25;
	self.think = muzzle_smoke_think;
	self.nextthink = time + 0.08;
	
	if (self.ltime > 11)
		remove(self);		
}

void() muzzle_smoke_nail_think =
{
	self.frame++;
	self.ltime++;
	self.alpha-=.06;
	self.scale+=.2;
	self.velocity_z = self.velocity_z+16;
	//self.velocity_x = self.velocity_x-25;
	self.think = muzzle_smoke_think;
	self.nextthink = time + 0.08;
	
	if (self.ltime > 11)
		remove(self);		
}

void() muzzle_spark_think =
{
	self.frame++;
	self.ltime++;
	self.alpha-=.03;
	self.scale-=.02;
	self.velocity_z = self.velocity_z-16;
	self.velocity_x = self.velocity_x-15;
	self.think = muzzle_spark_think;
	self.nextthink = time + 0.03;
	
	if (self.ltime > 9)
		remove(self);		
}

void(float spscale, vector offset, float smokedir, vector color, float spritealpha) SpawnSmoke_Flash =			//Spawns a first person muzzleflash
{
	newmis = spawn();
	newmis.movetype = MOVETYPE_NOCLIP;
	newmis.solid = SOLID_NOT;
	newmis.viewmodelforclient = self;
	newmis.owner = self;
	newmis.classname = "flash";
	//newmis.effects = newmis.effects + EF_ADDITIVE;
	setmodel(newmis, "progs/s_smoke_muzz.spr");
	//newmis.angles = self.v_angle;
	newmis.scale = spscale;
	newmis.scale+= random(-0.1, 0.1);
	newmis.alpha = spritealpha;
	newmis.colormod = color;
	if (smokedir)
		newmis.velocity = '60 0 0';
	else
		newmis.velocity = '60 0 -40';
	if (self.weapon == IT_SUPER_NAILGUN || self.weapon == IT_GRENADE_LAUNCHER)
	{
		newmis.velocity_y += random(-50, 50);
		newmis.velocity_z += random(-20, 20);
	}
	else
	{
		newmis.velocity_x += random(-25, -15);
		newmis.velocity_y += random(-18, 18);
		newmis.velocity_z += random(-10, 10);
	}
	
	setsize(newmis, '0 0 0', '0 0 0');
	setorigin(newmis, '114 -37 -29');	//Don't worry about this showing up in weird places on higher resolutions -
						// all viewmodels are scaled to fit the res perfectly
	newmis.origin+= offset;
	
	if (autocvar_centered_weapons)
		newmis.origin = newmis.origin + '0 33 -10';
		
	if (!smokedir)
		newmis.think = muzzle_smoke_think;
	else
		newmis.think = muzzle_smoke_nail_think;
	newmis.nextthink = time + 0.01;		//Adjust this as you wish
};

void(float spscale, vector offset, vector color, float spritealpha) SpawnSpark_Flash =			//Spawns a first person muzzleflash
{
	newmis = spawn();
	newmis.movetype = MOVETYPE_NOCLIP;
	newmis.solid = SOLID_NOT;
	newmis.viewmodelforclient = self;
	newmis.owner = self;
	newmis.classname = "flash";
	newmis.effects = newmis.effects + EF_ADDITIVE;
	setmodel(newmis, "progs/s_spark_muzz.spr");
	//newmis.angles = self.v_angle;
	if (!spritealpha)
		newmis.alpha = 1;
	else
		newmis.alpha = spritealpha;
	newmis.scale = spscale;
	newmis.velocity = '420 0 -5';
	setsize(newmis, '0 0 0', '0 0 0');
	setorigin(newmis, '74 7 -69');	//Don't worry about this showing up in weird places on higher resolutions -
	
	if (!color)
		newmis.colormod = '1 1 1';
	else				
		newmis.colormod = color;
	newmis.origin+= offset;
	
	if(autocvar_centered_weapons && self.weapon != IT_LASER_CANNON)
		newmis.origin = newmis.origin + '0 15 0';
	newmis.think = muzzle_spark_think;
	newmis.nextthink = time + 0.01;		//Adjust this as you wish
};
/*
void() SpawnRockFlash =			//Spawns a first person muzzleflash
{
	newmis = spawn();
	newmis.movetype = MOVETYPE_NONE;
	newmis.solid = SOLID_NOT;
	newmis.viewmodelforclient = self;
	newmis.owner = self;
	newmis.classname = "flash";
	//newmis.effects = newmis.effects + EF_ADDITIVE;
	setmodel(newmis, "progs/s_explodsmallp.spr");
	//newmis.angles = self.v_angle;
	newmis.scale = .6;
	newmis.alpha = 0.9;
	setsize(newmis, '0 0 0', '0 0 0');
	setorigin(newmis, '104 -22 -19');	//Don't worry about this showing up in weird places on higher resolutions -
						// all viewmodels are scaled to fit the res perfectly
	newmis.think = muzzle_smoke_think;
	newmis.nextthink = time + 0.01;		//Adjust this as you wish
};*/